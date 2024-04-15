// Decompiled by Jad v1.5.7d. Copyright 2000 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/SiliconValley/Bridge/8617/jad.html
// Decompiler options: packimports(3)
// Source File Name:   ven_bd_ins6.java

package supply.admin.info;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ven_bd_ins6 extends HttpServlet {
	
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
    	SepoaFormater sf = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		
    		
    		if("getMainternace_icomvncp".equals(mode)){ 
    			gdRes = this.getMainternace_icomvncp(gdReq, info);
    		}else if("setSave_icomvncp".equals(mode)){
    			gdRes = this.setSave_icomvncp(gdReq, info);
    		}else if("setDelete_icomvncp".equals(mode)){
    			gdRes = this.setDelete_icomvncp(gdReq, info);
    		}else if("doConfirm".equals(mode)){
    			gdRes = this.doConfirm(gdReq, info);
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
	private GridData getMainternace_icomvncp(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "p0010", "CONNECTION", "getMainternace_icomvncp", obj);
	
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
    private GridData setSave_icomvncp(GridData gdReq, SepoaInfo info) throws Exception{
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

    		value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "setSave_icomvncp", obj);
    		
    		String[] tmp = value.result;
    		
//    		if(tmp != null && tmp.length > 0){
//    			for(int i = 0 ; i < tmp.length ; i++){
//    				
//    			}
//    		}
    		 
    		
    		if(value.flag) {
    			gdRes.addParam("rtnVal", value.result[0]);
    			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setDelete_icomvncp(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "setDelete_icomvncp", obj);
			
			String[] tmp = value.result;
			
//			if(tmp != null && tmp.length > 0){
//				for(int i = 0 ; i < tmp.length ; i++){
//					
//				}
//			}
			
			
			if(value.flag) {
				gdRes.addParam("rtnVal", value.result[0]);
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData doConfirm(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "doConfirm", obj);
			
			String[] tmp = value.result;
			
//			if(tmp != null && tmp.length > 0){
//				for(int i = 0 ; i < tmp.length ; i++){
//					
//				}
//			}
			
			
			if(value.flag) {
				gdRes.addParam("rtnVal", value.result[0]);
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
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
//    public ven_bd_ins6()
//    {
//    
//    }
//
//    public void doQuery(WiseStream ws)
//        throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//
////        WiseInfo info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//        String house_code 		= info.getSession("HOUSE_CODE");
//        String user_id 			= info.getSession("ID");
//        String user_name_loc 	= info.getSession("NAME_LOC");
//        String user_name_eng 	= info.getSession("NAME_ENG");
//        String user_dept 		= info.getSession("DEPARTMENT");
//        String vendor_code 		= ws.getParam("vendor_code");
//        String company_code 	= ws.getParam("company_code");
//        Object args[] = {
//            house_code, company_code, vendor_code
//        };
//        WiseOut value = ServiceConnector.doService(info, "p0010", "CONNECTION", "getMainternace_icomvncp", args);
//        WiseFormater wf = ws.getWiseFormater(value.result[0]);
//        WiseFormater wf1= ws.getWiseFormater(value.result[1]);
//        int jRowCount 		= wf1.getRowCount();
//        if(wf.getRowCount() == 0)
//        {
//            ws.setCode("M001");
//            ws.setMessage(msg.getMessage("0008"));
//            ws.write();
//            return;
//        }
//        int	IDX_POSITION	= ws.getColumnIndex("TEXT_POSITION");
//        //------------------ �޺� ���� ---------------------------
//		Vector position_v = new Vector();
//		String[][] position_combo = null;
//
//		for(int j = 0 ; j < jRowCount; j++){
//
//			String[] str = { wf1.getValue("TEXT1", j) , wf1.getValue("CODE",j)};
//        	position_v.addElement(str);
//
//    	}
//
//		position_combo = new String[position_v.size()][2];
//		position_v.copyInto(position_combo);
//		//--------------------------------------------------------
//
//        for(int i = 0; i < wf.getRowCount(); i++)
//        {
//            String check[] = {"false", ""};
//            String imagetext[] = {"/kr/images/button/query.gif", "", ""};
//            ws.addValue("SELECTED"		, check, "");
//            ws.addValue("USER_NAME"		, wf.getValue("USER_NAME"		, i), "");
//            ws.addValue("DIVISION"		, wf.getValue("DIVISION"		, i), "");
//            ws.addValue("POSITION"		, wf.getValue("POSITION"	, i), "");
//            ws.addValue("POP1"			, imagetext							, "");
//            ws.addValue("PHONE_NO"		, wf.getValue("PHONE_NO"		, i), "");
//            ws.addValue("EMAIL"			, wf.getValue("EMAIL"			, i), "");
//            ws.addValue("MOBILE_NO"		, wf.getValue("MOBILE_NO"		, i), "");
//            ws.addValue("FAX_NO"		, wf.getValue("FAX_NO"			, i), "");
//            ws.addValue("HOUSE_CODE"	, wf.getValue("HOUSE_CODE"		, i), "");
//            ws.addValue("COMPANY_CODE"	, wf.getValue("COMPANY_CODE"	, i), "");
//            ws.addValue("VENDOR_CODE"	, wf.getValue("VENDOR_CODE"		, i), "");
//            ws.addValue("SEQ"			, wf.getValue("SEQ"				, i), "");
//            ws.addValue("FLAG"			, "U"								, "");
//            String code1 = wf.getValue( "POSITION" , i);
//
//			//�޺��� addValue
//			ws.addValue(IDX_POSITION,  position_combo, "TEXT_POSITION"  , getIndex(code1, position_combo));
//        }
//
//        ws.setCode("M001");
//        ws.setMessage(value.message);
//        ws.write();
//    }
//
//	private int getIndex(String code,String[][] payTerms_c){
//		int vSize = payTerms_c.length;
//		int index = 0;
//		for(int i = 0 ; i < vSize ; i++ ){
//			if(payTerms_c[i][1].equals(code))
//				index = i ;
//		}
//		return index;
//	}
//
//    public void doData(WiseStream ws)
//        throws Exception
//    {
//        String mode = ws.getParam("mode");
//        if(mode.equals("setSave_icomvncp"))
//            setSave_icomvncp(ws, mode);
//        else if(mode.equals("setDelete_icomvncp"))
//            setDelete_icomvncp(ws, mode);
//        else if(mode.equals("doConfirm"))
//        	doConfirm(ws, mode);
//        else if(mode.equals("setVnglSignStatus"))
//        	setVnglSignStatus(ws, mode);
//    }
//
//
//	private void setSave_icomvncp(WiseStream ws, String mode)
//	    throws Exception
//	{
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//
////	    WiseInfo info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//	    WiseFormater wf = ws.getWiseFormater();
//	    int iRowCount = wf.getRowCount();
//	    String HOUSE_CODE 		= info.getSession("HOUSE_CODE");
//	    String I_COMPANY_CODE 	= ws.getParam("company_code");
//	    String I_VENDOR_CODE 	= ws.getParam("vendor_code");
//	    String PHONE_NO[] 		= wf.getValue("PHONE_NO");
//	    String USER_NAME[] 		= wf.getValue("USER_NAME");
//	    String DIVISION[] 		= wf.getValue("DIVISION");
//	    String FAX_NO[] 		= wf.getValue("FAX_NO");
//	    String MOBILE_NO[] 		= wf.getValue("MOBILE_NO");
//	    String EMAIL[] 			= wf.getValue("EMAIL");
//	    String POSITION[] 		= wf.getValue("TEXT_POSITION");
//	    String SEQ[] 			= wf.getValue("SEQ");
//	    String FLAG[] 			= wf.getValue("FLAG");
//	    int ins_cnt = 0;
//	    int upd_cnt = 0;
//	    for(int i = 0; i < iRowCount; i++)
//	        if(FLAG[i].equals("U"))
//	            upd_cnt++;
//	        else
//	            ins_cnt++;
//
//	    String ins_data[][] = new String[ins_cnt][];
//	    String upd_data[][] = new String[upd_cnt][];
//	    ins_cnt = 0;
//	    upd_cnt = 0;
//	    for(int i = 0; i < iRowCount; i++)
//	        if(FLAG[i].equals("U"))
//	        {
//	            Logger.debug.println(info.getSession("ID"), this, "000000000000000000" + upd_data.length);
//	            String upd_temp[] = {
//				                      PHONE_NO[i]
//				                    , USER_NAME[i]
//				                    , DIVISION[i]
//				                    , FAX_NO[i]
//				                    , MOBILE_NO[i]
//				                    , EMAIL[i]
//				                    , POSITION[i]
//				                    , HOUSE_CODE
//				                    , I_COMPANY_CODE
//				                    , I_VENDOR_CODE
//				                    , SEQ[i]
//				                	};
//	            upd_data[upd_cnt] = upd_temp;
//	            upd_cnt++;
//	            Logger.debug.println(info.getSession("ID"), this, "upd_cnt=" + upd_cnt);
//	        } else
//	        {
//	            String ins_temp[] = {
//	                				    HOUSE_CODE
//	                				  , I_COMPANY_CODE
//	                				  , I_VENDOR_CODE
//	                				  , PHONE_NO[i]
//	                				  , USER_NAME[i]
//	                				  , DIVISION[i]
//	                				  , FAX_NO[i]
//	                				  , MOBILE_NO[i]
//	                				  , EMAIL[i]
//	                				  , POSITION[i]
//	            					};
//	            ins_data[ins_cnt] = ins_temp;
//	            ins_cnt++;
//	        }
//
//	    Object obj[] = {
//	        ins_data, upd_data, I_COMPANY_CODE, I_VENDOR_CODE
//	    };
//	    WiseOut value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "setSave_icomvncp", obj);
//	    ws.setCode("0000");
//	    String userObj[] = {
//	        mode, value.result[0]
//	    };
//	    ws.setUserObject(userObj);
//	    ws.setMessage(value.message);
//	    ws.write();
//	}
//
//
//    public void setDelete_icomvncp(WiseStream ws, String mode)
//        throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//
////        WiseInfo info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//        WiseFormater wf = ws.getWiseFormater();
//        int iRowCount = wf.getRowCount();
//        String HOUSE_CODE = info.getSession("HOUSE_CODE");
//        String I_COMPANY_CODE = ws.getParam("company_code");
//        String I_VENDOR_CODE = ws.getParam("vendor_code");
//        String SEQ[] = wf.getValue("SEQ");
//        String delData[][] = new String[iRowCount][];
//        for(int i = 0; i < iRowCount; i++)
//        {
//            String temp[] = {
//                HOUSE_CODE, I_COMPANY_CODE, I_VENDOR_CODE, SEQ[i]
//            };
//            delData[i] = temp;
//        }
//
//        Object obj[] = {
//            delData, I_COMPANY_CODE, I_VENDOR_CODE
//        };
//        WiseOut value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "setDelete_icomvncp", obj);
//        ws.setCode("0000");
//        String userObj[] = {
//            mode, value.result[0]
//        };
//        ws.setUserObject(userObj);
//        ws.setMessage(value.message);
//        ws.write();
//    }
//	public void doConfirm(WiseStream ws, String mode)
//        throws Exception
//    {
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//
////        WiseInfo info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//        WiseFormater wf = ws.getWiseFormater();
//        int iRowCount = wf.getRowCount();
//        String HOUSE_CODE = info.getSession("HOUSE_CODE");
//        String I_COMPANY_CODE = ws.getParam("company_code");
//        String I_VENDOR_CODE = ws.getParam("vendor_code");
//
//        Object obj[] = {
//            HOUSE_CODE, I_COMPANY_CODE, I_VENDOR_CODE
//        };
//        WiseOut value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "doConfirm", obj);
//        ws.setCode("0000");
//        String userObj[] = {
//            mode, value.result[0]
//        };
//        ws.setUserObject(userObj);
//        ws.setMessage(value.message);
//        ws.write();
//    }
//
//	public void setVnglSignStatus(WiseStream ws, String mode)
//    throws Exception
//{
//	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    WiseFormater wf = ws.getWiseFormater();
//    String HOUSE_CODE = info.getSession("HOUSE_CODE");
//    String I_COMPANY_CODE = ws.getParam("company_code");
//    String I_VENDOR_CODE = ws.getParam("vendor_code");
//
//    SignResponseInfo inf = new SignResponseInfo();
//
//    inf.setSignStatus(ws.getParam("sign_status"));
//    inf.setDocType("VM");
//    inf.setDocNo(wf.getValue("vendor_code"));
//    inf.setDocSeq(wf.getValue("vendor_code"));
//
//    Object obj[] = {
//    	inf
//    };
//    WiseOut value = ServiceConnector.doService(info, "p0070", "TRANSACTION", "Approval", obj);
//    ws.setCode(Integer.toString(value.status));
////    String userObj[] = {
////        mode, value.result[0]
////    };
////    ws.setUserObject(userObj);
//    ws.setMessage(value.message);
//    ws.write();
//}
//
//
//
//Message msg;
}