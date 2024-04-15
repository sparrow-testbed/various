package sepoa.svl.procure;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
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
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class eva_wait_list extends SepoaServlet 
{
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
			}else if("getVendor".equals(mode)){
				gdRes = getVendor(gdReq, info); // 조회
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
	
	
    //=========================================================================================================
//    public void doQuery(SepoaStream ws) throws Exception 
//    {
//        String processId = "p40";
//        
//        SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
//        String language = info.getSession("LANGUAGE");	
//		Message msg 	= new Message(language, processId); 
//
//        boolean isOk     = true;        
//        String message   = "";
//		String msg_value = "";
//
//        String evalname = ws.getParam("evalname");
//            
//        SepoaOut value = getQuery(evalname, info);  
//
//        if( value.status == 0 ){
//			isOk = false;
//			message = value.message;                
//		}else{
//			isOk = true;
//			message = "";
//		}  
//		
//		if(!isOk ){
//	       msg.setArg( "SCREEN_ID", processId );
//	       msg_value = msg.getMessage( "0002" );                         
//	       ws.setMessage( msg_value );
//	       String [] userObject = { message };
//	       ws.setUserObject( userObject );
//	       ws.write();
//	       return;
//	    }
//       
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//		int row_cnt = wf.getRowCount();
//		
//        try
//        {
//            if(row_cnt > 0)
//            {
//                for(int i=0; i<row_cnt; i++) 
//                {
//					String[] check = {"false", ""};
//					String[] imagetext1 = {"",	wf.getValue("eval_temp" , i), wf.getValue("eval_temp" , i)};
//					String[] imagetext2 = {"/kr/images/button/query.gif",	wf.getValue("v_cnt" , i), wf.getValue("v_cnt" , i)};
//
//					ws.addValue("sel", check, "");
//	                ws.addValue("eval_name" , 		wf.getValue("eval_name" , i), "");
//	                ws.addValue("eval_temp" , 		imagetext1, "");
//	                ws.addValue("interval" , 		wf.getValue("interval" , i), "");
//	                ws.addValue("eval_vendor" , 	imagetext2, "");
//
//	                ws.addValue("operator", 		wf.getValue("operator" , i), "");
//	                ws.addValue("eval_refitem", 	wf.getValue("eval_refitem" , i), "");
//	                ws.addValue("e_template_refitem", 	wf.getValue("e_template_refitem" , i), "");
//				}
//            }else{
//                            
//        	    msg.setArg("SCREEN_ID", processId);        	
//        	    msg_value = msg.getMessage("0006");
//			    ws.setMessage(msg_value);
//        	    ws.write();
//        	    return;
//            }
//        
//        }catch(Exception ex){
//            Logger.debug.println(info.getSession("ID"),this,"A###"+ ex);
//        }
//
//        msg.setArg("SCREEN_ID", processId);
//        msg_value = msg.getMessage("0001");
//		ws.setMessage(msg_value);
//        ws.write();
//    }

    //=========================================================================================================
    public GridData getEvaList(GridData gdReq, SepoaInfo info) throws Exception 
    {
    	GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

        String nickName = "p0080";
        String MethodName = "getEvabdlis2";  
        String conType = "CONNECTION";

        try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); // 그리드

			String grid_col_id = JSPUtil.CheckInjection(
					gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");

			Object[] obj = { data };
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_027", "CONNECTION", "getEvaList", obj);

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
					if(grid_col_ary[k] != null && grid_col_ary[k].equals("eval_vendor")){
						gdRes.addValue(grid_col_ary[k],	wf.getValue("V_CNT", i));
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
    
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getVendor(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	
	    	value = ServiceConnector.doService(info, "SR_027", "CONNECTION","getEvaVendorList", obj);
	
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

    //=========================================================================================================
    private String chkNull(String value) {
        if("".equals(value)){
           value = "0";
        }
        return value;
    }
    private String setZero(String value){
        if(value.indexOf(".") != -1 ){
           int decimal = Integer.parseInt(value.substring(value.indexOf(".")+1, value.length()));
           if(decimal == 0 ){
              value = value.substring(0,value.indexOf("."));
           }
      }
        return value;
    }

}
