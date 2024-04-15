package sepoa.svl.procure;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class eva_action_list extends HttpServlet {
	
	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		// 세션 Object
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

		GridData gdReq = null;
		GridData gdRes = new GridData();
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");

		String mode = "";
		PrintWriter out = res.getWriter();

		try {
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
			if ("getEvaList".equals(mode)) {
				gdRes = getEvaList(gdReq, info); // 조회
			}

		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
			
		} finally {
			try {
				OperateGridData.write(req, res, gdRes, out);
			} catch (Exception e) {
				Logger.debug.println();
			}
		}
	}
	
	//조회시 사용되는 Method 입니다. Method Name(doQuery)는 변경할 수 없습니다.
//    	public void doQuery(SepoaStream ws) throws Exception 	{
//    		
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//    		String mode = ws.getParam("mode");
//
//    		if(mode.equals("lis1")) 	{
//    			
//	    		String evalname 	= ws.getParam("evalname");
//	    		String operator 	= ws.getParam("operator");
//	    		String status 		= ws.getParam("status");
//	    		String from_date 	= ws.getParam("from_date");
//	    		String to_date 		= ws.getParam("to_date");
//	    		
//	    		String value = getEvaluationList(info, evalname, operator, status, from_date, to_date);
//	        	SepoaFormater wf = ws.getSepoaFormater(value);
//	        	
//				if(wf.getRowCount() == 0) {
//		        	ws.setCode("M001");
//    	    		ws.setMessage("조회된 데이터가 없습니다.");
//	        		ws.write();
//	        		return;
//	        	}
//	
//	        	for(int i=0; i<wf.getRowCount(); i++) {
//	        		
//	        		String[] check = {"false", ""};						
//            		ws.addValue(0, check, "");
//            		ws.addValue(1, String.valueOf(i+1), "");
//            		String[] imagetext1 = {"",wf.getValue(i, 1),wf.getValue(i, 1)};	
//            		ws.addValue(2, imagetext1, "");
//            		String[] imagetext2 = {"",wf.getValue(i, 2),wf.getValue(i, 2)};	
//            		ws.addValue(3, imagetext2, "");
//	            		
//	        		ws.addValue(4, wf.getValue(i, 3), "");
//	        		ws.addValue(5, wf.getValue(i, 4), "");
//	        		ws.addValue(6, wf.getValue(i, 5), "");
//	        		ws.addValue(7, wf.getValue(i, 6), "");
//	        		ws.addValue(8, wf.getValue(i, 7), "");
//	        		ws.addValue(9, wf.getValue(i, 0), "");
//	        	
//	        	}
//		        ws.setCode("M001");
//		        ws.setMessage("정상적으로 데이타가 query되었습니다.");
//		      
//		       	ws.write();
//    		}else if(mode.equals("lis2")) {
//    			String eval_refitem = ws.getParam("eval_refitem");
//			
//    			String value = getEvaluationVendorList(info, eval_refitem);
//	        	SepoaFormater wf = ws.getSepoaFormater(value);
//	        	
//	        	if(wf.getRowCount() == 0)
//	        	{
//		        	ws.setCode("M001");
//	    	    		ws.setMessage("조회된 데이터가 없습니다.");
//	        		ws.write();
//	        		return;
//	        	}
//	
//	        	for(int i=0; i<wf.getRowCount(); i++) {
//	            	ws.addValue(0, String.valueOf(i+1), "");
//	        		ws.addValue(1, wf.getValue(i, 1), "");
//	        		ws.addValue(2, wf.getValue(i, 2), "");
//	        		ws.addValue(3, wf.getValue(i, 3), "");
//	        		String[] imagetext1 = {"", wf.getValue(i, 4), wf.getValue(i, 4)};	
//	        		ws.addValue(4, imagetext1, "");
//	        		
//	        		String[] imagetext2 = {"", wf.getValue(i, 5), wf.getValue(i, 5)};	
//	        		ws.addValue(5, imagetext2, "");
//	        		ws.addValue(6, wf.getValue(i, 6), "");
//	        		ws.addValue(7, wf.getValue(i, 7), "");
//	        		ws.addValue(8, wf.getValue(i, 8), "");
//	        		ws.addValue(9, wf.getValue(i, 0), "");
//	        		ws.addValue(10, wf.getValue(i, 9), "");
//	        		ws.addValue("EVAL_REFITEM", wf.getValue("EVAL_REFITEM", i), "");
//	        		ws.addValue("EVAL_SCORE", wf.getValue("EVAL_SCORE", i), "");
//	        	}
//		        ws.setCode("M001");
//		        ws.setMessage("정상적으로 데이타가 query되었습니다.");
//		      
//		       	ws.write();
//    		
//			}else if(mode.equals("lis2_1")) 	{
//    			
//    			String eval_refitem = ws.getParam("eval_refitem");
//    			
//    			String value = getEvaluationVendorList_2(info, eval_refitem);
//	        	SepoaFormater wf = ws.getSepoaFormater(value);
//	        	
//	        	if(wf.getRowCount() == 0)
//	        	{
//		        	ws.setCode("M001");
//	    	    		ws.setMessage("조회된 데이터가 없습니다.");
//	        		ws.write();
//	        		return;
//	        	}
//	
//	        	for(int i=0; i<wf.getRowCount(); i++) {
//	            	ws.addValue("NUM", String.valueOf(i+1), "");
//	        		String[] imagetext1 = {"", wf.getValue("HUMAN_NAME", i), wf.getValue("HUMAN_NAME", i)};	
//	        		ws.addValue("HUMAN_NAME", imagetext1, "");
//	        		String[] imagetext2 = {"", wf.getValue("COMPLETE", i), wf.getValue("COMPLETE", i)};	
//	        		ws.addValue("COMPLTE", imagetext2, "");
//	        		ws.addValue("E_TEMPLATE_REFITEM", wf.getValue("E_TEMPLATE_REFITEM", i), "");
//	        		ws.addValue("VENDOR_CODE", wf.getValue("VENDOR_CODE", i), "");
//	        		ws.addValue("VENDOR_NAME", wf.getValue("VENDOR_NAME", i), "");
//	        		ws.addValue("SG_NAME", wf.getValue("SG_NAME", i), "");
//	        		ws.addValue("INPUT_PERIOD", wf.getValue("INPUT_PERIOD", i), "");
//	        		ws.addValue("TEMPLATE_TYPE", wf.getValue("TEMPLATE_TYPE", i), "");
//	        		ws.addValue("EVAL_ITEM_REFITEM", wf.getValue("EVAL_ITEM_REFITEM", i), "");
//	        		ws.addValue("EVAL_VALUER_REFITEM", wf.getValue("EVAL_VALUER_REFITEM", i), "");
//	        		ws.addValue("HUMAN_NO", wf.getValue("HUMAN_NO", i), "");
//	        		ws.addValue("EVAL_REFITEM", wf.getValue("EVAL_REFITEM", i), "");
//	        		ws.addValue("EVAL_SCORE", wf.getValue("EVAL_SCORE", i), "");
//	        	}
//		        ws.setCode("M001");
//		        ws.setMessage("정상적으로 데이타가 query되었습니다.");
//		      
//		       	ws.write();
//    		}else if(mode.equals("lis3")) {
//	    		String eval_refitem = ws.getParam("eval_refitem");
//	    		String value = getEvaluationResultList(info, eval_refitem);
//	        	SepoaFormater wf = ws.getSepoaFormater(value);
//	        	
//	        	if(wf.getRowCount() == 0)
//	        	{
//		        	ws.setCode("M001");
//	    	    		ws.setMessage("조회된 데이터가 없습니다.");
//	        		ws.write();
//	        		return;
//	        	}
//	
//	        	for(int i=0; i<wf.getRowCount(); i++) {
//	        		//String[] check = {"false", ""};						
//	            	//ws.addValue(0, check, "");			 
///*	
//	            	ws.addValue(0, String.valueOf(i+1), "");
//	        		ws.addValue(1, wf.getValue(i, 1), "");
//	        		ws.addValue(2, wf.getValue(i, 2), "");
//	        		ws.addValue(3, wf.getValue(i, 3), "");
//	        		String[] imagetext1 = {"", wf.getValue(i, 4), wf.getValue(i, 4)};	
//	        		
//	        		
//	        		ws.addValue(4, imagetext1, "");
//	        		ws.addValue(5, wf.getValue(i, 5), "");
//	        		ws.addValue(6, wf.getValue(i, 6), "");
//	        		ws.addValue(7, wf.getValue(i, 0), "");
//	        		ws.addValue(8, wf.getValue(i, 0), "");
//*/	        	
//	        		ws.addValue("num", String.valueOf(i+1), "");
//	        		ws.addValue("vendor_code", wf.getValue("VENDOR_CODE", i), "");
//	        		ws.addValue("vendor_name", wf.getValue("NAME_LOC", i), "");
//	        		ws.addValue("sg_name"    , wf.getValue("SG_NAME", i), "");
//	        		String[] imagetext1 = {"",wf.getValue("COMPLETE",i),wf.getValue("COMPLETE",i)};
//	        		ws.addValue("complte", imagetext1, "");
//	        		ws.addValue("E_TEMPLATE_REFITEM", wf.getValue("E_TEMPLATE_REFITEM", i), "");
//	        		ws.addValue("template_type", wf.getValue("TEMPLATE_TYPE", i), "");
//	        		ws.addValue("eval_item_refitem", wf.getValue("EVAL_ITEM_REFITEM", i), "");
//	        		ws.addValue("eval_valuer_refitem", wf.getValue("EVAL_VALUER_REFITEM", i), "");
//	        		
//	        	}
//		        ws.setCode("M001");
//		        ws.setMessage("정상적으로 데이타가 query되었습니다.");
//		      
//		       	ws.write();
//			}else if(mode.equals("lis4")) {
//	    		String evalname = ws.getParam("evalname");
//	    		String operator = ws.getParam("operator");
//	    		
//	    		String value = getEvaluationProgressList(info, evalname, operator);
//	        	SepoaFormater wf = ws.getSepoaFormater(value);
//	        	
//	        	if(wf.getRowCount() == 0)
//	        	{
//		        	ws.setCode("M001");
//	    	    		ws.setMessage("조회된 데이터가 없습니다.");
//	        		ws.write();
//	        		return;
//	        	}
//	
//	        	for(int i=0; i<wf.getRowCount(); i++) {
//	        		
//	        		String[] check = {"false", ""};						
//            		ws.addValue("sel", check, "");
//            		ws.addValue(1, String.valueOf(i+1), "");
//            		String[] imagetext1 = {"",wf.getValue("EVAL_NAME", i),wf.getValue("EVAL_NAME", i)};	
//            		ws.addValue("eval_name", imagetext1, "");
//            		String[] imagetext2 = {"",wf.getValue("STATUS", i),wf.getValue("STATUS", i)};	
//            		ws.addValue("status", imagetext2, "");
//	            		
//	        		ws.addValue("interval", wf.getValue("INTERVAL", i), "");
//	        		ws.addValue("updated", wf.getValue("UPDATED", i), "");
//	        		ws.addValue("operator", wf.getValue("USER_NAME_LOC", i), "");
//	        		ws.addValue("e_template_refitem", wf.getValue("E_TEMPLATE_REFITEM", i), "");
//	        		ws.addValue("eval_status", wf.getValue("EVAL_STATUS", i), "");
//	        		ws.addValue("eval_refitem", wf.getValue("EVAL_REFITEM", i), "");
//	        	
//	        	}
//		        ws.setCode("M001");
//		        ws.setMessage("정상적으로 데이타가 query되었습니다.");
//		      
//		       	ws.write();
//			}
//     	}

    	
    	public String getEvaluationList(SepoaInfo info, String evalname, String operator, String status, String from_date, String to_date) throws Exception 
    	{
    		Object obj[] = { evalname, operator, status, from_date, to_date};
    
    		String nickName= "p0080";		
    		String conType = "CONNECTION";		
       		String MethodName = "getEvaluationList";	
       		SepoaOut value = new SepoaOut();
       		SepoaRemote ws ;
	        
	        try {
		       
		        ws = new SepoaRemote(nickName,conType,info);
		        value = ws.lookup(MethodName,obj);
	 		
	    	} catch(Exception e) {
	    		try{
		        	Logger.err.println("err = " + e.getMessage());
		        	Logger.err.println("message = " + value.message);	
		   			Logger.err.println("status = " + value.status);	    			
	    		}catch(NullPointerException ne){
	    			Logger.debug.println();
	        	}
	     	} 
	    	return value.result[0];
    	}
    	
    	public String getEvaluationProgressList(SepoaInfo info, String evalname, String operator) throws Exception {

    		Object obj[] = { evalname, operator };
    
    		String nickName= "p0080";		
    		String conType = "CONNECTION";		
       		String MethodName = "getEvaluationProgressList";	
       		SepoaOut value = new SepoaOut();
       		SepoaRemote ws ;
	        
	        try {
		       
		        ws = new SepoaRemote(nickName,conType,info);
		        value = ws.lookup(MethodName,obj);
	 		
	    	} catch(Exception e) {
	    		try{
		        	Logger.err.println("err = " + e.getMessage());
		        	Logger.err.println("message = " + value.message);
		        	Logger.err.println("status = " + value.status);
	    		}catch(NullPointerException ne){
	    			Logger.debug.println();
	        	}	
	     	}
	    	return value.result[0];
    	}
    	
    	public GridData getEvaList(GridData gdReq, SepoaInfo info) throws Exception {
    		GridData gdRes = new GridData();
    		Vector multilang_id = new Vector();
    		multilang_id.addElement("MESSAGE");
    		HashMap message = MessageUtil.getMessage(info, multilang_id);
    
    		String nickName= "p0080";		
    		String conType = "CONNECTION";		
       		String MethodName = "getEvaluationVendorList";	
	        
       		try {
    			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); // 그리드

    			String grid_col_id = JSPUtil.CheckInjection(
    					gdReq.getParam("grid_col_id")).trim();
    			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

    			gdRes = OperateGridData.cloneResponseGridData(gdReq);
    			gdRes.addParam("mode", "doQuery");

    			Object[] obj = { data };
    			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
    			SepoaOut value = ServiceConnector.doService(info, "SR_028", "CONNECTION", "getEvaList", obj);

    			if (value.flag) {
    				gdRes.setMessage(message.get("MESSAGE.0001").toString());
    				gdRes.setStatus("true");
    			} else {
    				gdRes.setMessage(value.message);
    				gdRes.setStatus("false");
    				return gdRes;
    			}

    			SepoaFormater wf = new SepoaFormater(value.result[0]);

    			if (wf.getRowCount() == 0) {
    				gdRes.setMessage(message.get("MESSAGE.1001").toString());
    				return gdRes;
    			}

    			for (int i = 0; i < wf.getRowCount(); i++) {
    				for (int k = 0; k < grid_col_ary.length; k++) {
    					if(grid_col_ary[k] != null && grid_col_ary[k].equals("num")) {
    			    		gdRes.addValue(grid_col_ary[k], Integer.toString(i+1));
    			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("vendor_code")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("VENDOR_CODE", i));
    			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("vendor_name")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("NAME_LOC", i));
                    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("sg_name")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("SG_NAME", i));
                    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("human_name")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("HUMAN_NAME", i));
                    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("complete")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("COMPLETE", i));
                    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("e_template_refitem")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("E_TEMPLATE_REFITEM", i));
                    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("template_type")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("TEMPLATE_TYPE", i));
                    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("eval_valuer_refitem")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("EVAL_VALUER_REFITEM", i));
                    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("eval_item_refitem")) {
    			    		gdRes.addValue(grid_col_ary[k], wf.getValue("EVAL_ITEM_REFITEM", i));
                    	}else{
    					gdRes.addValue(grid_col_ary[k],	wf.getValue(grid_col_ary[k], i));
                    	}
    				}
    			}

    		} catch (Exception e) {
    			gdRes.setMessage(message.get("MESSAGE.1002").toString());
    			gdRes.setStatus("false");
    		}
    		return gdRes;
    	}
    	
    	public String getEvaluationVendorList_2(SepoaInfo info, String eval_refitem) throws Exception {
    		
    		Object obj[] = { eval_refitem };
    		
    		String nickName= "p0080";		
    		String conType = "CONNECTION";		
    		String MethodName = "getEvaluationVendorList_2";	
       		SepoaOut value = new SepoaOut();
       		SepoaRemote ws;
    		
    		try {
    			
    			ws = new SepoaRemote(nickName,conType,info);
    			value = ws.lookup(MethodName,obj);
    			
    		} catch(Exception e) {
    			try{
        			Logger.err.println("err = " + e.getMessage());
        			Logger.err.println("message = " + value.message);	
        			Logger.err.println("status = " + value.status);    				
    			}catch(NullPointerException ne){
    				Logger.debug.println();
	        	}
    		}
    		return value.result[0];
    	}
    	
    	
    	public String getEvaluationResultList(SepoaInfo info, String eval_refitem) throws Exception{

    		Object obj[] = { eval_refitem };
    
    		String nickName= "p0080";		
    		String conType = "CONNECTION";		
       		String MethodName = "getEvaluationResultList";	
       		SepoaOut value = new SepoaOut();
       		SepoaRemote ws; 
	        
	        try {
		       
		        ws = new SepoaRemote(nickName,conType,info);
		        value = ws.lookup(MethodName,obj);
	 		
	    	} catch(Exception e) {
	    		try{
		        	Logger.err.println("err = " + e.getMessage());
		        	Logger.err.println("message = " + value.message);
		        	Logger.err.println("status = " + value.status);
	    		}catch(NullPointerException ne){
	    			Logger.debug.println();
	        	}
	     	} 
	    	return value.result[0];
    	}
}

