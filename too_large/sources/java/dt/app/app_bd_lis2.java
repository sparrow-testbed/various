/**
 *@P/G ID : app_bd_lis2.java
 *@Author : CORAL MOON
 *@Date   : 2001.09.13
 *@Path   : ǰ�� ��Ȳ ���
 *@Desc   : ǰ�� ��Ȳ ��� ��ȸ ���? 
 **/

package dt.app;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class app_bd_lis2 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
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
    		
    		if("getEXList".equals(mode)){
    			gdRes = this.getEXList(gdReq, info);
    		}
    		else if("setDeleteEx".equals(mode)){
    			gdRes = this.setDeleteEx(gdReq, info);
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
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getEXList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	
	    	StringTokenizer st 			= new StringTokenizer(header.get("ctrl_code"), "&");
	    	
			String ctrl_code			= "";
			int cnt = 0;
	    	
			while (st.hasMoreElements()) {
				if (cnt == 0) {ctrl_code  = st.nextToken();}
				else	{	  ctrl_code += ",'" + st.nextToken();}
				cnt++;
			}
			
			header.put("ctrl_code", ctrl_code);
	    	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	    	
	    	value = ServiceConnector.doService(info,"p1062","CONNECTION","getEXList",obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			else{
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
			    			}
			    		}
			    	}
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}    
    

  	@SuppressWarnings({ "rawtypes", "unchecked" })
  	private GridData setDeleteEx(GridData gdReq, SepoaInfo info) throws Exception{
      	GridData            gdRes       = new GridData();
      	Vector              multilangId = new Vector();
      	HashMap             message     = null;
      	SepoaOut            value       = null;
      	Map<String, Object> data        = null;
     
      	multilangId.addElement("MESSAGE");
     
      	message = MessageUtil.getMessage(info, multilangId);

      	try {
      		gdRes.addParam("mode", "doSave");
      		gdRes.setSelectable(false);
      		data = SepoaDataMapper.getData(info, gdReq);
      		
      		Object[] obj = {data};
      		
      		value = ServiceConnector.doService(info, "p1062", "TRANSACTION","setDeleteEx", obj);
      		
      		if(value.flag) {
      			gdRes.setMessage(value.message); 
      			gdRes.setStatus("true");
      		}
      		else {
      			gdRes.setMessage(value.message);
      			gdRes.setStatus("false");
      		}
      	}
      	catch(Exception e){
      		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
      		gdRes.setStatus("false");
      	}
      	return gdRes;
    }	        
//    
//	private void getEXList(String mode, WiseStream ws) throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//    	
//        String house_code = info.getSession("HOUSE_CODE");
//        
//        String from_date    		= ws.getParam("from_date");
//		String to_date      		= ws.getParam("to_date");
//		String ctrl_code_session    = ws.getParam("ctrl_code");
//		String sign_status  		= ws.getParam("sign_status");
//		String exec_no      		= ws.getParam("exec_no");
//		String subject				= ws.getParam("subject");
//		String dept      			= ws.getParam("dept");
//		String req_type				= ws.getParam("req_type");
//		String ctrl_person_id		= ws.getParam("ctrl_person_id");
//		String purchaser_id     	= ws.getParam("purchaser_id");
//		String vendor_code      	= ws.getParam("vendor_code");
//		String cust_code      		= ws.getParam("cust_code");
//		String maker_name      		= ws.getParam("maker_name");
//		String project_code     	= ws.getParam("project_code");
//		String pr_no     			= ws.getParam("pr_no");
//		
//		String add_date     		= WiseDate.getShortDateString();
//		String add_time     		= WiseDate.getShortTimeString();
//		String server_date  		= add_date + add_time;
//		
//		StringTokenizer st = new StringTokenizer(ctrl_code_session, "&");
//		String ctrl_code = "";
//		int cnt = 0;
//		while (st.hasMoreElements()) {
//			if (cnt == 0) ctrl_code  = st.nextToken();
//			else		  ctrl_code += ",'" + st.nextToken();
//			cnt++;
//		}
//		
//		String[] args = {
//				house_code
//				, exec_no
//				, subject
//				, from_date
//				, to_date
//				, ctrl_code
//				, sign_status
//				, dept
//				, req_type
//				, ctrl_person_id
//				, purchaser_id
//				, vendor_code
//				, cust_code
//				, maker_name	
//				, project_code
//				, pr_no
//		};
//		Object[] obj = {args, ctrl_code};
//		
//		WiseOut value = ServiceConnector.doService(info,"p1062","CONNECTION","getEXList",obj);
//    	
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//
//		String[] userObj = {
//				mode
//		};
//		
//		if(wf.getRowCount() == 0) 
//		{
//	    	ws.setUserObject(userObj);
//			ws.setMessage(msg.getMessage("0008"));
//			ws.write();
//			return;
//  	    }
//		
//        String icon_con_gla = "/kr/images/icon/detail.gif";
//
//		for(int i=0; i<wf.getRowCount(); i++)
//		{
//			String[] check = {"false", ""};
//			String[] img_exec_no = {"", wf.getValue("EXEC_NO",i), wf.getValue("EXEC_NO",i)};
//			String[] img_bf_exec_no = {"", wf.getValue("BF_EXEC_NO",i), wf.getValue("BF_EXEC_NO",i)};
//			
//			ws.addValue("SELECTED"               , check, "" );
//			ws.addValue("SIGN_STATUS"            , wf.getValue("SIGN_STATUS"            , i), "" );
//			ws.addValue("SIGN_STATUS_TEXT"       , wf.getValue("SIGN_STATUS_TEXT"       , i), "" );
//			ws.addValue("EXEC_NO"                , img_exec_no								, "" );
//			ws.addValue("SUBJECT"                , wf.getValue("SUBJECT"           		, i), "" );
//			ws.addValue("CTRL_CODE"              , wf.getValue("CTRL_CODE"              , i), "" );
//			ws.addValue("CTRL_NAME"              , wf.getValue("CTRL_NAME"            	, i), "" );
//			ws.addValue("EXEC_FLAG"              , wf.getValue("EXEC_FLAG"           	, i), "" );
//			ws.addValue("EXEC_FLAG_TEXT"         , wf.getValue("EXEC_FLAG_TEXT"         , i), "" );
//			ws.addValue("CHANGE_DATE"            , wf.getValue("CHANGE_DATE"            , i), "" );
//			ws.addValue("SIGN_DATE"              , wf.getValue("SIGN_DATE"         		, i), "" );
//			ws.addValue("SIGN_PERSON_ID"         , wf.getValue("SIGN_PERSON_ID"       	, i), "" );
//			ws.addValue("SETTLE_VENDOR_COUNT"    , wf.getValue("SETTLE_VENDOR_COUNT"    , i), "" );
//			ws.addValue("CUR"                    , wf.getValue("CUR"       				, i), "" );
//			ws.addValue("EXEC_AMT_KRW"           , wf.getValue("EXEC_AMT_KRW"     		, i), "" );
//			ws.addValue("ITEM_COUNT"             , wf.getValue("ITEM_COUNT"           	, i), "" );
//			ws.addValue("PR_TYPE"                , wf.getValue("PR_TYPE"           	    , i), "" );
//			ws.addValue("PR_TYPE_TEXT"           , wf.getValue("PR_TYPE_TEXT"      	    , i), "" );
//			ws.addValue("TTL_ITEM_QTY"           , wf.getValue("TTL_ITEM_QTY"     		, i), "" );			
//			ws.addValue("BID_TYPE"               , wf.getValue("BID_TYPE"           	, i), "" );
//			ws.addValue("BID_TYPE_TEXT"          , wf.getValue("BID_TYPE_TEXT"          , i), "" );
//			ws.addValue("ATTACH_NO"              , wf.getValue("ATTACH_NO"           	, i), "" );
//			ws.addValue("REMARK"             	 , wf.getValue("REMARK"           		, i), "" );
//			ws.addValue("DEL_FLAG"           	 , wf.getValue("DEL_FLAG"      	    	, i), "" );
//			ws.addValue("PO_TYPE"           	 , wf.getValue("PO_TYPE"      	    	, i), "" );
//			ws.addValue("PO_TYPE_TEXT"           , wf.getValue("PO_TYPE_TEXT"      	    , i), "" );
//			ws.addValue("EXCHANGE_EXEC_FLAG"     , wf.getValue("EXCHANGE_EXEC_FLAG"	    , i), "" );
//			ws.addValue("PURCHASER_ID"     		 , wf.getValue("PURCHASER_ID"	    	, i), "" );
//			ws.addValue("PURCHASER_NAME"     	 , wf.getValue("PURCHASER_NAME"	    	, i), "" );
//			ws.addValue("BF_EXEC_NO"             , img_bf_exec_no						, "" );
//			ws.addValue("PRE_CONT_SEQ"           , wf.getValue("PRE_CONT_SEQ"	    	, i), "" );
//			ws.addValue("PRE_CONT_COUNT"         , wf.getValue("PRE_CONT_COUNT"	    	, i), "" );
//			ws.addValue("IS_CT_NO"         		 , wf.getValue("IS_CT_NO"	    		, i), "" );
//			ws.addValue("IS_PO_NO"         		 , wf.getValue("IS_PO_NO"	    		, i), "" );
//		}
//		
//		ws.setUserObject(userObj);
//		ws.setMessage(value.message);
//		ws.write();
//    }
//
//
//    public void doData(WiseStream ws) throws Exception
//    {
//    	String mode = ws.getParam("mode");
//    	
//    	if(mode.equals("setDeleteEx"))
//		{
//    		setDeleteEx(ws, mode);
//		}
//    }
//    
//    private void setDeleteEx(WiseStream ws, String mode) throws Exception
//	{
//		WiseInfo info	    = WiseSession.getAllValue(ws.getRequest());
//		String house_code   = info.getSession("HOUSE_CODE");
//		String add_user_id  = info.getSession("ID");
//		String company_code = info.getSession("COMPANY_CODE");
//		String add_date     = WiseDate.getShortDateString();
//		String add_time     = WiseDate.getShortTimeString();
//		
//		WiseFormater wf	= ws.getWiseFormater();
//		int iRowCount = wf.getRowCount();
//		String[] EXEC_NO = wf.getValue("EXEC_NO");
//		
//		String[][] objCNHD = new String[iRowCount][];
//		
//		for(int i=0;i<iRowCount;i++)
//		{
//			String[] TEMP_CNHD = {
//					add_user_id
//					, add_date
//					, add_time
//					, house_code
//					, EXEC_NO[i]
//
//			};
//			objCNHD[i] = TEMP_CNHD;
//		}
//		String mss_exec_no = CommonUtil.combinationArr(EXEC_NO,",");
//		Object[] obj = { mss_exec_no,objCNHD };
//		WiseOut value = ServiceConnector.doService(info, "p1062", "TRANSACTION","setDeleteEx", obj);
//	    
//		ws.setMessage(value.message);
//
//		String[] userObj = {mode, String.valueOf(value.status)};
//		ws.setUserObject(userObj);
//
//		ws.write();
//	}
//
//    
}
