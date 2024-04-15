package order.ivdp;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import com.woorifg.barcode.webservice.EPS_007_WSStub;
import com.woorifg.barcode.webservice.EPS_007_WSStub.ArrayOfString;
import com.woorifg.barcode.webservice.EPS_007_WSStub.EPS007;
import com.woorifg.barcode.webservice.EPS_007_WSStub.EPS007Response;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class inv1_bd_lis2 extends HttpServlet {
	
	
	private static final long serialVersionUID = 1L;

	public void init(javax.servlet.ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }	
    

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("approval".equals(mode)){ // 역경매 대상 상세조회
    			gdRes = this.approval(gdReq, info);
    		}
       		else if ("Tly_Cancel".equals(mode)){
       			gdRes = this.Tly_Cancel(gdReq, info);
       		}
       		else if ("attachFile".equals(mode)){
       			gdRes = this.attachFile(gdReq, info);
       		}
    		
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if(str.equals("")){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
	
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	private String getStringMaxByte(String target, int maxLength){
    	byte[] targetByteArray       = target.getBytes();
    	int    targetByteArrayLength = targetByteArray.length;
    	int    targetLength          = 0;
    	
    	while(targetByteArrayLength > maxLength){
    		targetLength          = target.length();
    		targetLength          = targetLength - 1;
    		target                = target.substring(0, targetLength);
    		targetByteArray       = target.getBytes();
    		targetByteArrayLength = targetByteArray.length;
    	}
    	
    	return target;
    }
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
    
    private String getWebserviceId(SepoaInfo info) throws Exception{
		String id = info.getSession("ID");
		
		if("ADMIN".equals(id)){
			id = "19116877";
		}
		
		return id;
	}
    
    private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend) throws Exception{
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		String              infNo     = null;
		String              houseCode = info.getSession("HOUSE_CODE");
		String              id        = this.getWebserviceId(info);
		boolean             flag      = false;
		
		param.put("HOUSE_CODE",     houseCode);
		param.put("INF_TYPE",       "W");
		param.put("INF_CODE",       infCode);
		param.put("INF_SEND",       infSend);
		param.put("INF_ID",         id);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> approvalEps007SelectIcoyivHdDtSeList(SepoaInfo info, Map<String, Object> allData) throws Exception{
    	SepoaFormater             sf               = null;	
    	SepoaOut                  value            = null;
    	Map<String, String>       headerInfo       = null;
    	Map<String, String>	      header           = MapUtils.getMap(allData, SepoaDataMapper.KEY_HEADER_DATA);
    	Map<String, String>       gridDataInfo     = null;
    	Map<String, String>       resultInfo       = null;
    	List<Map<String, String>> gridData         = (List<Map<String, String>>) MapUtils.getObject(allData, SepoaDataMapper.KEY_GRID_DATA);
    	List<Map<String, String>> result           = new ArrayList<Map<String, String>>();
    	String                    invNo            = header.get("inv_no");
		String                    houseCode        = info.getSession("HOUSE_CODE");
		String                    invSeq           = null;
		String                    qty              = null;
		String                    grQty            = null;
		String                    itemNo           = null;
		String                    itemLetter       = null;
		String                    itemStartNumber  = null;
		String                    materialCtrlCode = null;
		Object[]                  svcObj           = new Object[1];
		int                       gridDataSize     = gridData.size();
		int                       i                = 0;
		int                       rowCount         = 0;
		int                       j                = 0;
		int                       infInvSeq        = 1;
		
		for(i = 0; i < gridDataSize; i++){
			gridDataInfo     = gridData.get(i);
			grQty            = gridDataInfo.get("GR_QTY");
			grQty            = grQty.replace(",", "");
			invSeq           = gridDataInfo.get("INV_SEQ");
			itemNo           = gridDataInfo.get("ITEM_NO");
			materialCtrlCode = gridDataInfo.get("MATERIAL_CTRL_TYPE");
			
			if(
				("0".equals(grQty) == false) &&
				(
					("01030".equals(materialCtrlCode)) ||
					("01020".equals(materialCtrlCode)) ||
					("03091".equals(materialCtrlCode)) 
				)
			){
				headerInfo = new HashMap<String, String>();
				
				headerInfo.put("HOUSE_CODE", houseCode);
				headerInfo.put("INV_NO",     invNo);
				headerInfo.put("INV_SEQ",    invSeq);
				
				svcObj[0] = headerInfo;
				value     = ServiceConnector.doService(info, "p2050", "TRANSACTION", "selectIcoyivHdDtSeList", svcObj);
				
				sf = new SepoaFormater(value.result[0]);
				
				rowCount = sf.getRowCount();
				
				for(j = 0; j < rowCount; j++){
					resultInfo = new HashMap<String, String>();
					
					qty              = sf.getValue("ITEM_QTY", j);
					itemLetter       = sf.getValue("ITEM_LETTER", j);
					itemStartNumber  = sf.getValue("ITEM_START_NUMBER", j);
					
					resultInfo.put("INF_MODE",          "C");
					resultInfo.put("INV_NO",            invNo);
					resultInfo.put("INV_SEQ",           Integer.toString(infInvSeq));
					resultInfo.put("SEQ",               Integer.toString(j + 1));
					resultInfo.put("ITEM_NO",           itemNo);
					resultInfo.put("QTY",               this.nvl(qty, grQty));
					resultInfo.put("ITEM_LETTER",       this.nvl(itemLetter));
					resultInfo.put("ITEM_START_NUMBER", this.nvl(itemStartNumber));
					
					result.add(resultInfo);
				}
				
				infInvSeq++;
			}
		}
		
    	return result;
    }
    
	private EPS007 approvalEps007(SepoaInfo info, Map<String, Object> allData, String infNo) throws Exception{
    	EPS007                    eps007               = null;
		ArrayOfString             modeArray            = new ArrayOfString();
		ArrayOfString             invNumberArray       = new ArrayOfString();
		ArrayOfString             invSeqArray          = new ArrayOfString();
		ArrayOfString             invSeNoArray         = new ArrayOfString();
		ArrayOfString             itemCodeArray        = new ArrayOfString();
		ArrayOfString             itemQtyArray         = new ArrayOfString();
		ArrayOfString             itemLetterArray      = new ArrayOfString();
		ArrayOfString             itemStartNumberArray = new ArrayOfString();
		String                    usrUsrId             = this.getWebserviceId(info);
		List<Map<String, String>> list                 = null;
		Map<String, String>       listInfo             = null;
		int                       rowCount             = 0;
		int                       i                    = 0;
		
		list     = this.approvalEps007SelectIcoyivHdDtSeList(info, allData);
		rowCount = list.size();
		
		if(rowCount != 0){
			eps007 = new EPS007();
			
			for(i = 0; i < rowCount; i++){
	    		listInfo = list.get(i);
	    		
	    		modeArray.addString(this.nvl(listInfo.get("INF_MODE")));
				invNumberArray.addString(this.nvl(listInfo.get("INV_NO")));
				invSeqArray.addString(this.nvl(listInfo.get("INV_SEQ")));
				invSeNoArray.addString(this.nvl(listInfo.get("SEQ")));
				itemCodeArray.addString(this.nvl(listInfo.get("ITEM_NO")));
				itemQtyArray.addString(this.nvl(listInfo.get("QTY")));
				itemLetterArray.addString(this.nvl(listInfo.get("ITEM_LETTER")));
				itemStartNumberArray.addString(this.nvl(listInfo.get("ITEM_START_NUMBER")));
	    	}
			
	    	eps007.setMODE(modeArray);
			eps007.setINV_NUMBER(invNumberArray);
			eps007.setINV_SEQ(invSeqArray);
			eps007.setINV_SE_NO(invSeNoArray);
			eps007.setITEM_CODE(itemCodeArray);
			eps007.setITEM_QTY(itemQtyArray);
			eps007.setITEM_LETTER(itemLetterArray);
			eps007.setITEM_START_NUMBER(itemStartNumberArray);
			eps007.setUSRUSRID(usrUsrId);
			eps007.setINF_NO(infNo);
		}
    	
		return eps007;
    }
	
	private void insertSinfep007Info(SepoaInfo info, String infNo, EPS007 eps007) throws Exception{
		String                    houseCode            = info.getSession("HOUSE_CODE");
		Object[]                  obj                  = new Object[1];
		Map<String, Object>       objInfo              = new HashMap<String, Object>();
		Map<String, String>       eps007Hd             = new HashMap<String, String>();
		Map<String, String>       eps007Dtpr           = null;
		List<Map<String, String>> eps007Dt             = new ArrayList<Map<String, String>>();
		SepoaOut                  value                = null;
		String[]                  modeArray            = eps007.getMODE().getString();
		String[]                  invNumberArray       = eps007.getINV_NUMBER().getString();
		String[]                  invSeqArray          = eps007.getINV_SEQ().getString();
		String[]                  invSeNoArray         = eps007.getINV_SE_NO().getString();
		String[]                  itemCodeArray        = eps007.getITEM_CODE().getString();
		String[]                  itemQtyArray         = eps007.getITEM_QTY().getString();
		String[]                  itemLetterArray      = eps007.getITEM_LETTER().getString();
		String[]                  itemStartNumberArray = eps007.getITEM_START_NUMBER().getString();
		boolean                   isStatus             = false;
		int                       i                    = 0;
		int                       modeArrayLength      = modeArray.length;
		
		eps007Hd.put("HOUSE_CODE", houseCode);
		eps007Hd.put("INF_NO",     infNo);
		
		for(i = 0; i < modeArrayLength; i++){
			eps007Dtpr = new HashMap<String, String>();
			
			eps007Dtpr.put("HOUSE_CODE", houseCode);
			eps007Dtpr.put("INF_NO", infNo);
			eps007Dtpr.put("SEQ", Integer.toString(i));
			eps007Dtpr.put("INF_MODE", modeArray[i]);
			eps007Dtpr.put("INV_NUMBER", invNumberArray[i]);
			eps007Dtpr.put("INV_SEQ", invSeqArray[i]);
			eps007Dtpr.put("ITEM_CODE", itemCodeArray[i]);
			eps007Dtpr.put("ITEM_QTY", itemQtyArray[i]);
			eps007Dtpr.put("ITEM_LETTER", itemLetterArray[i]);
			eps007Dtpr.put("ITEM_START_NUMBER", itemStartNumberArray[i]);
			eps007Dtpr.put("INV_SE_NO", invSeNoArray[i]);
			
			eps007Dt.add(eps007Dtpr);
		}
		
		objInfo.put("eps007",   eps007Hd);
		objInfo.put("eps007Pr", eps007Dt);
		
		obj[0] = objInfo;

		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep007", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(); 
		}
	}
	
	private void updateSinfhdInfo(SepoaInfo info, String infNo, String status, String reason, String infReceiveNo){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("STATUS",         status);
			param.put("REASON",         reason);
			param.put("HOUSE_CODE",     houseCode);
			param.put("INF_NO",         infNo);
			param.put("INF_RECEIVE_NO", infReceiveNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfhdInfo", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	private void updateSinfep007Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = null;
		Object[]            obj       = null;
		String              houseCode = null;
		String              return1   = null;
		String              return2   = null;
		
		try{
			param     = new HashMap<String, String>();
			obj       = new Object[1];                
			houseCode = info.getSession("HOUSE_CODE");
			return1   = response[0];
			return1   = this.nvl(return1);
			return2   = response[1];                  
			
			param.put("RETURN1",    return1);
			param.put("RETURN2",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep007Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private void approvalEps007Call(SepoaInfo info, Map<String, Object> allData) throws Exception{
    	ArrayOfString  eps007ResponseArray       = null;
		EPS007Response eps007Response            = null;
		String[]       eps007ResponseArrayString = null;
		String         infNo                     = null;
		String         returnMessage             = null;
		String         rInfNo                    = null;
		String         status                    = null;
		String         reason                    = null;
		EPS007         eps007                    = null;
		
		try{
			infNo  = this.insertSinfhdInfo(info, "EPS007", "S");
			eps007 = this.approvalEps007(info, allData, infNo);
			
			if(eps007 != null){
				this.insertSinfep007Info(info, infNo, eps007);
				
				eps007Response = new EPS_007_WSStub().ePS007(eps007);
				
				eps007ResponseArray       = eps007Response.getEPS007Result();
				eps007ResponseArrayString = eps007ResponseArray.getString();
				returnMessage             = eps007ResponseArrayString[0];
				returnMessage             = this.nvl(returnMessage);
				rInfNo                    = eps007ResponseArrayString[1];
				
				if("".equals(returnMessage)){
					status = "Y";
					reason = "";
				}
				else{
					status = "N";
					reason = returnMessage;
				}
			}
			else{
				status = "I";
				reason = "파라미터 생성되지 않음";
			}
		}
		catch(Exception e){
			eps007ResponseArrayString = new String[2];
			
			status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			rInfNo = "";
			
			eps007ResponseArrayString[0] = "901";
			eps007ResponseArrayString[1] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, rInfNo);
		
		if("I".equals(status) == false){
			this.updateSinfep007Info(info, infNo, eps007ResponseArrayString);
		}
		
		if("N".equals(status)){
			throw new Exception(returnMessage);
		}
    }
        
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData approval(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes   = new GridData();
	    SepoaOut            value   = null;
	    Vector              v       = new Vector();
	    HashMap             message = null;
	    Map<String, Object> allData = null;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq);
	    	
			gdRes.setSelectable(false);

	    	Object[] obj = {allData};
	    	
//	    	this.approvalEps007Call(info, allData);
	    	
	    	value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "setApproval", obj);
	    	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	this.loggerExceptionStackTrace(e);
	    	
	    	gdRes.setMessage(e.getLocalizedMessage());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
   	private GridData attachFile(GridData gdReq, SepoaInfo info) throws Exception{
   	    GridData            gdRes   = new GridData();
   	    SepoaOut            value   = null;
   	    Vector              v       = new Vector();
   	    HashMap             message = null;
   	    Map<String, Object> allData = null;
   	
   	    v.addElement("MESSAGE");
   	
   	    message = MessageUtil.getMessage(info, v);
   	
   	    try{
   	    	allData    = SepoaDataMapper.getData(info, gdReq);
   	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq);
   	    	
   			gdRes.setSelectable(false);

   	    	Object[] obj = {allData};
   	    	
//   	    	this.approvalEps007Call(info, allData);
   	    	
   	    	value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "attachFile", obj);
   	    	
   	    	if(value.flag){// 조회 성공
   	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
   	    		gdRes.setStatus("true");
   	    	}
   	    	else{
   	    		gdRes.setMessage(value.message);
   	    		gdRes.setStatus("false");
   	    	}
   	    }
   	    catch (Exception e){
   	    	this.loggerExceptionStackTrace(e);
   	    	
   	    	gdRes.setMessage(e.getLocalizedMessage());
   	    	gdRes.setStatus("false");
   	    }
   	    
   	    return gdRes;
   	}

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData Tly_Cancel(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes   = new GridData();
	    SepoaOut            value   = null;
	    Vector              v       = new Vector();
	    HashMap             message = null;
	    Map<String, Object> allData = null;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	    Map<String, String> header  = null;
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq);
	    	
			gdRes.setSelectable(false);
	
			header = (Map<String, String>) allData.get("headerData");
			//Object[] obj = {header.get("inv_no"),header.get("inv_seq"),header.get("pr_no"),header.get("pr_seq")};
			Object[] obj = {header.get("inv_no")};

	    	value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "Tly_Cancel", obj);

	    	if(value.flag){
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	this.loggerExceptionStackTrace(e);
	    	
	    	gdRes.setMessage(e.getLocalizedMessage());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
    }
//
//	public void doQuery(WiseStream ws) throws Exception {
//
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//		String mode              = ws.getParam("mode");
//
//		String from_date		= ws.getParam("from_date"		);
//		String to_date		    = ws.getParam("to_date"		    );
//		String inv_from_date	= ws.getParam("inv_from_date"	);
//		String inv_to_date	    = ws.getParam("inv_to_date"	    );
//		String ctrl_person_id	= ws.getParam("ctrl_person_id"	);
//		String sign_status	    = ws.getParam("sign_status"	    );
//		String pay_flag			= ws.getParam("pay_flag"		);
//		String vendor_code	    = ws.getParam("vendor_code"	    );
//		String inv_person_id	= ws.getParam("inv_person_id"	);
//		String po_no			= ws.getParam("po_no"			);
//		String order_no			= ws.getParam("order_no"		);
//		String dept				= ws.getParam("dept"			);
//		String app_status		= JspUtil.nullToEmpty(ws.getParam("app_status"));
//        Object[] obj = {from_date
//					   ,to_date
//					   ,inv_from_date
//					   ,inv_to_date
//					   ,ctrl_person_id
//					   ,sign_status
//					   ,pay_flag
//					   ,vendor_code
//					   ,inv_person_id
//					   ,po_no
//					   ,order_no
//					   ,dept
//					   ,"inv_person"
//					   ,"A"
//					   ,app_status
//					   };
//		WiseOut value = ServiceConnector.doService(info, "p2050", "CONNECTION","getInvList",obj);
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//		int iRowCount = wf.getRowCount();
//		String icon_con_gla = "/kr/images/icon/detail.gif";
//		for(int i=0; i<iRowCount; i++)
//		{
//			String[] check = {"false", ""};
//			String[] img_po_no       = {""			, wf.getValue("PO_NO"	   ,i)	, wf.getValue("PO_NO"		,i)};
//			String[] img_iv_no       = {""			, wf.getValue("IV_NO"	   ,i)	, wf.getValue("IV_NO"		,i)};
//			String[] img_vendor_code = {""			, wf.getValue("VENDOR_CODE",i)	, wf.getValue("VENDOR_CODE"	,i)};
//			String[] img_vendor_name = {""			, wf.getValue("VENDOR_NAME",i)	, wf.getValue("VENDOR_NAME"	,i)};
//			String[] img_query		 = {icon_con_gla, wf.getValue("SIGN_REMARK",i)	, wf.getValue("SIGN_REMARK"	,i)};
//			String[] img_inv_no       = {""			, wf.getValue("INV_NO"	   ,i)	, wf.getValue("INV_NO"		,i)};
//			String[] img_eval_flag_desc = {icon_con_gla			, wf.getValue("EVAL_FLAG_DESC"	   ,i)	, wf.getValue("EVAL_FLAG_DESC"		,i)};
//			String[] img_attach		 = {icon_con_gla, wf.getValue("ATTACH_POP" ,i)  , wf.getValue("ATTACH_POP"  ,i)};
//			ws.addValue("SEL"				, check                            		, "");
//			ws.addValue("PO_NO"				, img_po_no 							, "");
//			ws.addValue("PO_SUBJECT"		, wf.getValue("PO_SUBJECT"			,i) , "");
//			ws.addValue("PO_CREATE_DATE"	, wf.getValue("PO_CREATE_DATE"	    ,i)	, "");
//			ws.addValue("VENDOR_CODE"		, img_vendor_code						, "");
//			ws.addValue("VENDOR_NAME"		, img_vendor_name						, "");
//			ws.addValue("PO_TTL_AMT"		, wf.getValue("PO_TTL_AMT"		    ,i)	, "");
//			ws.addValue("INV_PERSON_NAME"	, wf.getValue("INV_PERSON_NAME"		,i)	, "");
//			ws.addValue("ADD_USER_NAME"		, wf.getValue("ADD_USER_NAME"	    ,i)	, "");
//			ws.addValue("INV_PERSON_ID"		, wf.getValue("INV_PERSON_ID"		,i)	, "");
//			Logger.debug.println("INV_PERSON_ID::" + wf.getValue("INV_PERSON_ID"		,i));
//			ws.addValue("ADD_USER_ID"		, wf.getValue("ADD_USER_ID"	    	,i)	, "");
//			ws.addValue("IV_NO"				, img_iv_no								, "");
//			ws.addValue("DP_TEXT"			, wf.getValue("DP_TEXT"			    ,i)	, "");
//			ws.addValue("DP_PAY_TERMS"		, wf.getValue("DP_PAY_TERMS"		,i) , "");
//			ws.addValue("IV_SEQ"			, wf.getValue("IV_SEQ"			    ,i)	, "");
//			ws.addValue("DP_PERCENT"		, wf.getValue("DP_PERCENT"		    ,i)	, "");
//			ws.addValue("DP_AMT"			, wf.getValue("DP_AMT"			    ,i)	, "");
//			ws.addValue("INV_DATE"			, wf.getValue("INV_DATE"			,i) , "");
//			ws.addValue("CONFIRM_DATE"		, wf.getValue("CONFIRM_DATE"		,i)	, "");
//			ws.addValue("SIGN_STATUS"		, wf.getValue("SIGN_STATUS"		    ,i)	, "");
//			ws.addValue("SIGN_STATUS_DESC"	, wf.getValue("SIGN_STATUS_DESC"    ,i)	, "");
//			ws.addValue("ATTACH_POP"		, img_attach							, "");
//			ws.addValue("ATTACH_NO"			, wf.getValue("ATTACH_NO"    		,i)	, "");
//			ws.addValue("SIGN_REMARK"		, img_query								, "");
//			ws.addValue("PAY_FLAG"			, wf.getValue("DP_FLAG"				,i)	, "");
//			ws.addValue("INV_SUBJECT"		, wf.getValue("INV_SUBJECT"			, i), "");
//			ws.addValue("INV_QTY"			, wf.getValue("INV_QTY"				,i)	, "");
//			ws.addValue("ORDER_NO"			, wf.getValue("ORDER_NO"			,i)	, "");
//			ws.addValue("INV_NO"			, img_inv_no							, "");
//			ws.addValue("PIS_STATUS"		, wf.getValue("PIS_STATUS"			,i)	, "");
//			ws.addValue("EVAL_FLAG"			, wf.getValue("EVAL_FLAG"			,i)	, "");
//			ws.addValue("EVAL_FLAG_DESC"	, img_eval_flag_desc					, "");
//			ws.addValue("EVAL_REFITEM"		, wf.getValue("EVAL_REFITEM"		,i)	, "");
//			ws.addValue("EVAL_DATE"			, wf.getValue("EVAL_DATE"		,i)	, "");
//			ws.addValue("APP_STATUS"			, wf.getValue("APP_STATUS"		,i)	, "");
//			ws.addValue("APP_STATUS_TXT"			, wf.getValue("APP_STATUS_TXT"		,i)	, "");
//		}
//
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//		ws.write();
//	}
//
//	public void doData(WiseStream ws) throws Exception
//	{
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	WiseFormater wf 	= ws.getWiseFormater();
//		String mode     	= ws.getParam("mode");
//		
//		if (mode.equals("charge_transfer")) {
//			charge_transfer(ws);
//		} else if(mode.equals("cancel_inv")){
//			cancel_inv(ws);
//		} else {
//			approval(ws);
//		}
//	}
//	
//	public void cancel_inv(WiseStream ws) throws Exception
//	{
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//		WiseFormater wf = ws.getWiseFormater();
//		
//		String inv_no     = ws.getParam("inv_no");
//		String house_code = info.getSession("HOUSE_CODE");
//		
//		HashMap<String, String> paramMap = new HashMap<String,String>();
//		paramMap.put("inv_no", inv_no);
//		paramMap.put("house_code", house_code);
//		//�����˼���û���ε� �ݷ��� ��� ������������ �����ؾ��Ѵ�.
//		Object[] obj = {paramMap};
//		WiseOut value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "cancelInv", obj);
//
//		String[] res = new String[2];
//		res[0] = value.message;
//		res[1] = String.valueOf(value.status);
//
//		ws.setUserObject(res);
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//
//		ws.write();
//	}
//	public void approval(WiseStream ws) throws Exception
//	{
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	WiseFormater wf = ws.getWiseFormater();
//    	
//		String inv_no     		= ws.getParam("inv_no");
//		String sign_status		= ws.getParam("sign_status");
//		String sign_remark  	= ws.getParam("sign_remark");
//		String eval_refitem 	= ws.getParam("eval_refitem");	//�����˼���û���� ��� �򰡹�ȣ�� ����.
//		String inv_total_amt  	= ws.getParam("inv_total_amt");
//		String inv_date		  	= ws.getParam("inv_date");
//		String last_yn		  	= ws.getParam("last_yn");
//		String exec_no		  	= ws.getParam("exec_no");
//		String dp_div		  	= ws.getParam("dp_div");
//		String confirm_date1	= ws.getParam("confirm_date1");
//		
//		HashMap<String, String> paramMap = new HashMap<String,String>();
//		paramMap.put("last_yn", last_yn);
//		paramMap.put("exec_no", exec_no);
//		paramMap.put("dp_div", dp_div);
//		
//		String[] DT_INV_SEQ		= wf.getValue("INV_SEQ");
//		String[] DT_GR_QTY		= wf.getValue("GR_QTY");
//		String[] DT_INV_QTY		= wf.getValue("INV_QTY");
//		String[] DT_INV_AMT		= wf.getValue("EXPECT_AMT");
//		
//		String IvhdData[][] = {{
//			 info.getSession("ID") // CHANGE_USER_ID
//				,inv_total_amt // INV_AMT
//				,info.getSession("ID") // INV_PERSON_ID
//				,confirm_date1   // INV_COMFRIM_DATE1
//				//,inv_date // INV_DATE
//				,sign_status // SIGN_STATUS
//				,sign_remark // SIGN_REMARK
//				,eval_refitem // EVAL_REFITEM
//				,info.getSession("HOUSE_CODE") // HOUSE_CODE
//				,inv_no // INV_NO
//				
//		}};
//
//		String IvdtData[][] = new String[wf.getRowCount()][];
//		String PodtData[][] = new String[wf.getRowCount()][];
//		for (int i = 0; i<wf.getRowCount(); i++) {
//			String tmpIvdt[] = {
//					info.getSession("ID") // CHANGE_USER_ID
//					,DT_GR_QTY[i] // GR_QTY (�԰���� : ���԰�)
//					,DT_INV_QTY[i] // INV_QTY (�˼��հݼ���)
//					,DT_INV_AMT[i] // INV_AMT (�˼��ݾ�)
//					,info.getSession("HOUSE_CODE") // HOUSE_CODE
//					,inv_no // INV_NO
//					,DT_INV_SEQ[i] // INV_SEQ
//			};
//			IvdtData[i]    = tmpIvdt;
//			
//			String tmpPodt[] = {
//					info.getSession("ID") // CHANGE_USER_ID
//					,info.getSession("HOUSE_CODE") // HOUSE_CODE
//					,info.getSession("HOUSE_CODE") // HOUSE_CODE
//					,inv_no // INV_NO
//					,DT_INV_SEQ[i] // INV_SEQ
//			};
//			PodtData[i]    = tmpPodt;
//		}
//		//Logger.debug.println(info.getSession("ID"), this, "����1");
//		
//		//�����˼���û���ε� �ݷ��� ��� ������������ �����ؾ��Ѵ�.
//		Object[] obj = {inv_no, IvhdData, IvdtData, PodtData, paramMap};
//		WiseOut value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "setApproval", obj);
//
//		String[] res = new String[2];
//		res[0] = value.message;
//		res[1] = String.valueOf(value.status);
//
//		ws.setUserObject(res);
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//
//		ws.write();
//
//		/*�ݷ� �� ��� ��ü�� email*/
///*		if(value.status == 1 && "R".equals(sign_status)) {
//			sendMail(info, inv_no);
//		}*/
//		
//		//�˼��Ϸ� sms �߼�.
//		if(value.status == 1) {
//			try{
//				String[] args = {inv_no};
//				Object[] sms_args = {args};
//				
//				ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00010_1", sms_args);
//			} catch (Exception e) {
//				Logger.debug.println("mail error = " + e.getMessage());
//				e.printStackTrace();
//			}	
//		}
//	}
//
//
//	public void charge_transfer(WiseStream ws) throws Exception {
//
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//		//WiseTable�κ��� upload�� data�� formatting�Ͽ� ��´�.
//    	WiseFormater wf = ws.getWiseFormater();
//		String[] inv_no     = wf.getValue("INV_NO");
//	    String Transfer_person_id	= ws.getParam("Transfer_person_id");
//
//	    Logger.debug.println(info.getSession("ID"), this, "   inv_no.length  === > " + inv_no.length);
//		Object[] obj = {Transfer_person_id, inv_no };
//		WiseOut value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "charge_transfer", obj);
//
//		String[] res = new String[1];
//		res[0] = value.message;
//
//		ws.setUserObject(res);
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//
//		ws.write();
//	}
//
//	public void sendMail(WiseInfo info, String inv_no) throws Exception {
//		try{
//			Object[] sms_args = {inv_no};
//	        String mail_type = "";
//
//	        mail_type 	= "M00012";
//
//	        if(!"".equals(mail_type)){
//	        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
//	        }
//		}catch(Exception e){
//			e.printStackTrace();
//		}
//
//	}

}
