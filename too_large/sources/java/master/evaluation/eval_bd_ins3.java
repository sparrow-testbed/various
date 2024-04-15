package master.evaluation;

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

import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class eval_bd_ins3 extends HttpServlet {
	
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
    		
    		if("eval_user_list".equals(mode)){ 
    			gdRes = this.eval_user_list(gdReq, info);
    		}
    		else if("eval_list".equals(mode)){ 
    			gdRes = this.eval_list(gdReq, info);
    		}
    		else if("create".equals(mode)){
    			gdRes = this.create(gdReq, info);
    		}
    		else if("setEvalScore".equals(mode)){
    			gdRes = this.setEvalScore(gdReq, info);
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
	private GridData eval_user_list(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "p0080", "CONNECTION", "getEvaluationValuerList", obj);
	
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
			    			
			    			if("sel".equals(gridColAry[k])){
			    				gdRes.addValue("sel", "0");
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
    private GridData eval_list(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p0080", "CONNECTION", "getEvaluationVendorList_1", obj);
    		
    		if(value.flag){// 조회 성공
    			gdRes.setMessage(message.get("MESSAGE.0001").toString());
    			gdRes.setStatus("true");
    			
    			sf= new SepoaFormater(value.result[0]);
    			
    			rowCount = sf.getRowCount(); // 조회 row 수
    			
    			if(rowCount == 0){
    				gdRes.setMessage(message.get("MESSAGE.1001").toString());
    			}
    			else{
    				
//                	ws.addValue(0, String.valueOf(i+1), "");
//            		ws.addValue(1, wf.getValue(i, 1), "");	//VENDOR_CODE
//            		ws.addValue(2, wf.getValue(i, 2), "");	//VENDOR_NAME
//            		ws.addValue(3, wf.getValue(i, 3), "");	//SG_NAME
//            		ws.addValue(4, wf.getValue(i, 8), "");	//평가기간
//            		String[] imagetext1 = {"", wf.getValue(i, 4), wf.getValue(i, 4)};	
//            		
//            		ws.addValue(5, imagetext1, "");			//평가여부
//            		ws.addValue(6, wf.getValue(i, 5), "");	//E_TEMPLATE_REFITEM
//            		ws.addValue(7, wf.getValue(i, 6), "");	//TEPLATE_TYPE
//            		ws.addValue(8, wf.getValue(i, 7), "");	//EVAL_ITEM_REFITEM
//            		ws.addValue(9, wf.getValue(i, 0), "");	//EVAL_VALUER_REFITEM
//            		ws.addValue(10, wf.getValue(i, 9), "");		//평가자아이디
//            		ws.addValue(11, wf.getValue(i, 10), "");	//평가자
//            		ws.addValue(12, wf.getValue(i, 11), "");	//평가자소속
//            		ws.addValue(13, wf.getValue(i, 12), "");	//첨부파일정보    				
    				
    				
    				for (int i = 0; i < rowCount; i++){
    					for(int k=0; k < gridColAry.length; k++){
    						if("SELECTED".equals(gridColAry[k])){
    							gdRes.addValue("SELECTED", "0");
    						}
    						else if("num".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], i+1 + "");
    						}
    						else if("vendor_code".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], sf.getValue("VENDOR_CODE", i));
    						}
    						else if("vendor_name".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], sf.getValue("NAME_LOC", i));
    						}
    						else if("sg_name".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], sf.getValue("SG_NAME", i));
    						}
    						else if("template_type".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], sf.getValue("TEMPLATE_TYPE", i));
    						}
    						else if("eval_item_refitem".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], sf.getValue("EVAL_ITEM_REFITEM", i));
    						}
    						else if("eval_valuer_refitem".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], sf.getValue("EVAL_VALUER_REFITEM", i));
    						}
    						else if("complte".equals(gridColAry[k])){
    							gdRes.addValue(gridColAry[k], sf.getValue("COMPLETE", i));
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
    private GridData create(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p1015d", "TRANSACTION", "setEvalPropInert",       obj);
    		
    		String[] tmp = value.result;
    		
    		if(tmp != null && tmp.length > 0){
    			for(int i = 0 ; i < tmp.length ; i++){
    				Logger.debug.println();
    			}
    		}
    		
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setEvalScore(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "p0080", "TRANSACTION", "insertEvaluerScore",       obj);
			
			String[] tmp = value.result;
			
			if(tmp != null && tmp.length > 0){
				for(int i = 0 ; i < tmp.length ; i++){
					Logger.debug.println();
				}
			}
			
			
			
			if(value.flag) {
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
//	 public void doQuery(WiseStream ws) throws Exception 
//	 {
//		 WiseInfo info = WiseSession.getAllValue(ws.getRequest());
// 		 String mode = ws.getParam("mode");
// 		
// 		 if(mode.equals("eval_list")) {
//			
//			String eval_refitem = ws.getParam("eval_refitem");
//			String eval_user_id = ws.getParam("eval_user_id");
//		
//			String value = getEvaluationVendorList_1(info, eval_refitem, eval_user_id);
//        	WiseFormater wf = ws.getWiseFormater(value);
//        	
//        	if(wf.getRowCount() == 0)
//        	{
//	        	ws.setCode("M001");
//    	    		ws.setMessage("조회된 데이터가 없습니다.");
//        		ws.write();
//        		return;
//        	}
//
//        	for(int i=0; i<wf.getRowCount(); i++) {
//            	ws.addValue(0, String.valueOf(i+1), "");
//        		ws.addValue(1, wf.getValue(i, 1), "");	//VENDOR_CODE
//        		ws.addValue(2, wf.getValue(i, 2), "");	//VENDOR_NAME
//        		ws.addValue(3, wf.getValue(i, 3), "");	//SG_NAME
//        		ws.addValue(4, wf.getValue(i, 8), "");	//평가기간
//        		String[] imagetext1 = {"", wf.getValue(i, 4), wf.getValue(i, 4)};	
//        		
//        		ws.addValue(5, imagetext1, "");			//평가여부
//        		ws.addValue(6, wf.getValue(i, 5), "");	//E_TEMPLATE_REFITEM
//        		ws.addValue(7, wf.getValue(i, 6), "");	//TEPLATE_TYPE
//        		ws.addValue(8, wf.getValue(i, 7), "");	//EVAL_ITEM_REFITEM
//        		ws.addValue(9, wf.getValue(i, 0), "");	//EVAL_VALUER_REFITEM
//        		ws.addValue(10, wf.getValue(i, 9), "");		//평가자아이디
//        		ws.addValue(11, wf.getValue(i, 10), "");	//평가자
//        		ws.addValue(12, wf.getValue(i, 11), "");	//평가자소속
//        		ws.addValue(13, wf.getValue(i, 12), "");	//첨부파일정보
//        		String[] imagetext2 = {"", wf.getValue(i, 13), wf.getValue(i, 13)};	
//        		ws.addValue(14, imagetext2, "");	//평가점수
//        	}
//	        ws.setCode("M001");
//	        ws.setMessage("정상적으로 데이타가 query되었습니다.");
//	      
//	       	ws.write();
//	       	
//		}else if(mode.equals("eval_user_list")) {
//		
//			String eval_refitem = ws.getParam("eval_refitem");
//			String value = getEvaluationValuerList(info, eval_refitem);
//			WiseFormater wf = ws.getWiseFormater(value);
//        	
//			if(wf.getRowCount() == 0)
//			{
//	        	ws.setCode("M001");
//    	    	ws.setMessage("조회된 데이터가 없습니다.");
//        		ws.write();
//        		return;
//        	}
//			Logger.debug.println(info.getSession("ID"),this,"=======================mode::"+mode);
//			Logger.debug.println(info.getSession("ID"),this,"=======================wf.getRowCount()::"+wf.getRowCount());
//			
//			for(int i=0; i<wf.getRowCount(); i++) {
//        		Logger.debug.println(info.getSession("ID"),this,"=======================::"+i);
//				Logger.debug.println(info.getSession("ID"),this,"=======================wf.getValue(EVAL_VALUER_NAME)::"+wf.getValue("EVAL_VALUER_NAME"	, i));
//				
//        		ws.addValue(0		, "", "");
//        		ws.addValue(1		, wf.getValue("EVAL_VALUER_DEPT_NAME"	, i), "");
//            	ws.addValue(2		, wf.getValue("EVAL_VALUER_NAME"		, i), "");
//        		ws.addValue(3		, wf.getValue("EVAL_VALUER_ID"			, i), "");
//        		ws.addValue(4		, wf.getValue("E_TEMPLATE_REFITEM"		, i), "");
//        	}
//			
//			
//	        ws.setCode("M001");
//	        ws.setMessage("정상적으로 데이타가 query되었습니다.");
//	      
//	       	ws.write();
//		}  	 
//		 
//	 }
// 
//
// 	public String getEvaluationVendorList_1(WiseInfo info, String eval_refitem, String user_id) throws Exception {
//
// 		Object obj[] = { eval_refitem, user_id };
// 
// 		String nickName= "p0080";		
// 		String conType = "CONNECTION";		
//    		String MethodName = "getEvaluationVendorList_1";	
//       		WiseOut value = new WiseOut();
//       		wise.util.WiseRemote ws;
//	        
//	        try {
//		       
//		        ws = new wise.util.WiseRemote(nickName,conType,info);
//		        value = ws.lookup(MethodName,obj);
//	 		
//	    	} catch(Exception e) {
//	    		try{
//		        	Logger.err.println("err = " + e.getMessage());
//		        	Logger.err.println("message = " + value.message);	
//		        	Logger.err.println("status = " + value.status);	    			
//	    		}catch(NullPointerException ne){
//	        		ne.printStackTrace();
//	        	}
//	     	} 
//	    	return value.result[0];
// 	}
// 	
// 	public String getEvaluationValuerList(WiseInfo info, String eval_refitem) throws Exception {
//
// 		Object obj[] = { eval_refitem };
// 
// 		String nickName= "p0080";		
// 		String conType = "CONNECTION";		
//    		String MethodName = "getEvaluationValuerList";	
//       		WiseOut value = new WiseOut();
//       		wise.util.WiseRemote ws ;
//	        
//	        try {
//		       
//		        ws = new wise.util.WiseRemote(nickName,conType,info);
//		        value = ws.lookup(MethodName,obj);
//	 		
//	    	} catch(Exception e) {
//	    		try{
//		        	Logger.err.println("err = " + e.getMessage());
//		        	Logger.err.println("message = " + value.message);	
//		        	Logger.err.println("status = " + value.status);
//	    		}catch(NullPointerException ne){
//	        		ne.printStackTrace();
//	        	}  		
//	     	} 
//	    	return value.result[0];
// 	}
// 	
//	 public void doData( WiseStream ws ) throws Exception
//		{
//		   	String screenId = "eval_bd_ins3";
//	        String processId = "p40";
//	        
//	        Configuration config = new Configuration();
//			String eval_user_id = config.get("wise.eval.user_id");
//			
//	        
//	        WiseInfo info 	= WiseSession.getAllValue(ws.getRequest());
//	        String language = info.getSession("LANGUAGE");	
//			Message msg 	= new Message(language, processId); 
//			WiseFormater wf = ws.getWiseFormater();
//
//	        boolean isOk     = true;        
//	        String message   = "";
//			String msg_value = "";
//
//			String evalname  	= ws.getParam( "evalname" );
//			String doc_no  		= ws.getParam( "bid_no" );
//			String doc_count  	= ws.getParam( "bid_count" );
//			String fromdate  	= ws.getParam( "fromdate" );
//			String todate  		= ws.getParam( "todate" );
//			String eval_id		= ws.getParam( "eval_id" );
//			String flag			= ws.getParam( "flag" );
//			String attach_no	= ws.getParam( "attach_no" );
//			String strEvalFlag = "T";	//평가대기중
//			
//			String mode  				= ws.getParam( "mode" );
//			String eval_refitem  		= ws.getParam( "eval_refitem" );
//			String eval_item_refitem  	= ws.getParam( "eval_item_refitem" );
//			String eval_valuer_refitem  = ws.getParam( "eval_valuer_refitem" );
//			
//			Logger.debug.println(info.getSession("ID"),this,"========================mode::" + mode);
//			Logger.debug.println(info.getSession("ID"),this,"create info ::::::::::::::::::::::::::::::::");
//			Logger.debug.println(info.getSession("ID"),this,"=====================doc_count::" + doc_count);
//			Logger.debug.println(info.getSession("ID"),this,"======================fromdate::" + fromdate);
//			Logger.debug.println(info.getSession("ID"),this,"========================todate::" + todate);
//			Logger.debug.println(info.getSession("ID"),this,"=======================eval_id::" + eval_id);
//			Logger.debug.println(info.getSession("ID"),this,"update info ::::::::::::::::::::::::::::::::");
//			Logger.debug.println(info.getSession("ID"),this,"=======================eval_refitem::" + eval_refitem);
//			Logger.debug.println(info.getSession("ID"),this,"=======================eval_item_refitem::" + eval_item_refitem);
//			Logger.debug.println(info.getSession("ID"),this,"=======================eval_valuer_refitem::" + eval_valuer_refitem);
//			
//			if("update".equals(mode)){
//				//제안평가자 평가정보 삭제
//				WiseOut value = setUpdate(info, doc_no, doc_count, eval_refitem, eval_item_refitem, eval_valuer_refitem);
//				
//				
//				if ( value.status != 1 )	
//				{
//					isOk = false;
//				}else{
//					isOk = true;
//				}
//	
//				//등록중 오류가 발생하였다면...
//				if ( ! isOk ){
//					msg.setArg( "SCREEN_ID", screenId );
//					msg_value = "평가정보가 정상적으로 삭제 처리되었습니다.";
//					ws.setMessage( msg_value );
//					String [] userObject = {msg_value, "F" ,""};
//					ws.setUserObject( userObject );
//				}
//				else
//				{
//					msg.setArg( "SCREEN_ID", screenId );
//					msg_value = "평가정보 삭제 처리중 오류가 발생하였습니다.";
//					ws.setMessage( msg_value );
//					String [] userObject = {msg_value, "S" , value.result[0]};
//					ws.setUserObject( userObject );
//				}	
//			}else{
//				//평가정보 생성
//				String[] vendor_name   			= wf.getValue("EVAL_VALUER_DEPT_NAME");
//				String[] value_name				= wf.getValue("EVAL_VALUER_NAME");
//	 
//				Logger.debug.println(info.getSession("ID"),this,"=======================value_name.length::" + value_name.length);
//				int realData = 0;
//				for (int i = 0; i<value_name.length; i++) 
//				{
//					if(!"".equals(value_name[i])){
//						realData++;
//					}
//				}
//				Logger.debug.println(info.getSession("ID"),this,"=======================RealData value_name.length::" + realData);
//				
//				String setData[][] = new String[realData][];
//				realData = 0;
//				for (int i = 0; i<value_name.length; i++) 
//				{
//					if(!"".equals(value_name[i])){
//						String Data[] = { vendor_name[i], value_name[i], eval_user_id};
//						setData[i] = Data;
//						realData++;
//					}
//				}
//				
//				// 해당클래스, 메소드, nickName, ConType을 Mapping한다.
//				WiseOut value = setSave(info, setData, doc_no, doc_count, evalname, fromdate, todate, strEvalFlag, eval_id, attach_no);
//				
//				
//				if ( value.status != 1 )	
//				{
//					isOk = false;
//				}else{
//					isOk = true;
//				}
//	
//				//등록중 오류가 발생하였다면...
//				if ( ! isOk ){
//					msg.setArg( "SCREEN_ID", screenId );
//					msg_value = msg.getMessage( "0004" );
//					ws.setMessage( msg_value );
//					String [] userObject = {msg_value, "F" ,""};
//					ws.setUserObject( userObject );
//				}
//				else
//				{
//					msg.setArg( "SCREEN_ID", screenId );
//					msg_value = msg.getMessage( "0013" );
//					ws.setMessage( msg_value );
//					String [] userObject = {msg_value, "S" , value.result[0]};
//					ws.setUserObject( userObject );
//				}		
//			}
//			ws.write();
//			return;
//		}   
//
//		public WiseOut setSave( WiseInfo info, String[][] SetData, String doc_no, String doc_count, String evalname, String fromdate, String todate,
//								String strEvalFlag, String eval_id, String attach_no)
//		{
//			String serviceId = "p1015d";
//			String conType = "TRANSACTION";
//			String MethodName = "setEvalPropInert";
//
//			Object[] obj = {SetData, doc_no, doc_count, evalname, fromdate, todate, strEvalFlag, eval_id, attach_no};
//
//			wise.srv.WiseOut value = null;
//			wise.util.WiseRemote wr = null;
//
//			Logger.debug.println(info.getSession("ID"),this,"[setSave]=======================p1015d.setEvalPropInert CALL.");
//			
//			// 다음은 실행할 class을 =loading하고 Method호출수 결과를 return하는 부분
//			try{
//				wr = new wise.util.WiseRemote( serviceId, conType, info );
//				value = wr.lookup( MethodName, obj );
//			}
//			catch(Exception e){
//				try{
//					Logger.err.println("err = " + e.getMessage());
//					Logger.err.println("message = " + value.message);
//					Logger.err.println("status = " + value.status);					
//				}catch(NullPointerException ne){
//	        		ne.printStackTrace();
//	        	}
//			}
//			finally{
//				try{
//				    wr.Release();
//				}catch(Exception e){
//					e.printStackTrace();
//				}
//			}
//			return value;
//		}
//		
//		
//		public WiseOut setUpdate( WiseInfo info, String doc_no, String doc_count, String eval_refitem, String eval_item_refitem, String eval_valuer_refitem)
//		{
//			String serviceId = "p1015d";
//			String conType = "TRANSACTION";
//			String MethodName = "setEvalPropUpdate";
//			
//			Object[] obj = {doc_no, doc_count, eval_refitem, eval_item_refitem, eval_valuer_refitem};
//			
//			wise.srv.WiseOut value = null;
//			wise.util.WiseRemote wr = null;
//			
//			Logger.debug.println(info.getSession("ID"),this,"[setUpdate]=======================p1015d.setEvalPropUpdate CALL.");
//			
//			// 다음은 실행할 class을 =loading하고 Method호출수 결과를 return하는 부분
//			try{
//				wr = new wise.util.WiseRemote( serviceId, conType, info );
//				value = wr.lookup( MethodName, obj );
//			}
//			catch(Exception e){
//				try{
//					Logger.err.println("err = " + e.getMessage());
//					Logger.err.println("message = " + value.message);
//					Logger.err.println("status = " + value.status);					
//				}catch(NullPointerException ne){
//	        		ne.printStackTrace();
//	        	}
//			}
//			finally{
//				try{
//				    wr.Release();
//				}catch(Exception e){
//					e.printStackTrace();
//				}
//				}
//			return value;
//		}
//		
//		 
//		
		
		
		
		
		
		
		
}
