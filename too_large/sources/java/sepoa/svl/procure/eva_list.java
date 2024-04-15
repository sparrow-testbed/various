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

public class eva_list extends SepoaServlet 
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
			if ("getEvaList".equals(mode)) 
			{
				gdRes = getEvaList(gdReq, info); // 조회
			}else if("setEvaComplete".equals(mode))
			{
				gdRes = setEvaComplete(gdReq, info);
			}else if("setEvaDelete".equals(mode))
			{
				gdRes = setEvaDelete(gdReq, info);
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
//        String status 	= ws.getParam("status");
//        String from_date = ws.getParam("from_date");
//        String to_date 	= ws.getParam("to_date");
//            
//        SepoaOut value = getQuery(evalname, status, from_date, to_date, info);  
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
//					String[] imagetext1 = {"",	wf.getValue("eval_name" , i), wf.getValue("eval_name" , i)};
//					String[] imagetext2 = {"",	wf.getValue("eval_temp" , i), wf.getValue("eval_temp" , i)};
//
//					ws.addValue("sel", check, "");
//	                ws.addValue("eval_name" , 		imagetext1, "");
//	                ws.addValue("status" , 			wf.getValue("status" , i), "");
//	                ws.addValue("eval_temp" , 		imagetext2, "");
//	                ws.addValue("interval" , 		wf.getValue("interval" , i), "");
//
//					ws.addValue("updated", 			wf.getValue("updated" , i), "");
//	                ws.addValue("operator", 		wf.getValue("operator" , i), "");
//	                ws.addValue("assi_cnt", 		wf.getValue("assi_cnt" , i), "");
//	                ws.addValue("comp_cnt", 		wf.getValue("comp_cnt" , i), "");
//	                ws.addValue("eval_refitem", 	wf.getValue("eval_refitem" , i), "");
//
//	                ws.addValue("eval_status", 		wf.getValue("eval_status" , i), "");
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


//        String nickName = "p0080";
//        String MethodName = "getEvabdlis1";  
//        String conType = "CONNECTION";

        try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
			
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");
			
			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_021", "CONNECTION", "getEvaList", obj);
			
			if(value.flag) {
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
				for(int k=0; k < grid_col_ary.length; k++) {
			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
			    		gdRes.addValue("SELECTED", "0");
			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("updated")) {
    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue("UPDATED", i)));
                	}else {
			        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
			        }
				}
			}
		    
		} catch (Exception e) {
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

//	public void doData( SepoaStream ws ) throws Exception
//	{
//	   	String screenId = "eva_bd_ins1";
//        String processId = "p40";
//        
//        SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
//        String language = info.getSession("LANGUAGE");	
//		Message msg 	= new Message(language, processId); 
//		SepoaFormater wf = ws.getSepoaFormater();
//
//        boolean isOk     = true;        
//        String message   = "";
//		String msg_value = "";
//
//		String mode  	= ws.getParam( "mode" );
//
//		if(mode.equals("Delete"))
//		{
//			String[] eval_refitem   	= wf.getValue("eval_refitem");
//
//			String setData[][] = new String[wf.getRowCount()][];
//
//			for (int i = 0; i<wf.getRowCount(); i++) 
//			{
//				String Data[] = { eval_refitem[i]};
//				setData[i] = Data;
//			}
//
//			// 해당클래스, 메소드, nickName, ConType을 Mapping한다.
//			SepoaOut value = setDelete(info, setData);
//
//			if ( value.status != 1 )	
//			{
//				isOk = false;
//			}else{
//				isOk = true;
//			}
//
//			//등록중 오류가 발생하였다면...
//			if ( ! isOk ){
//				msg.setArg( "SCREEN_ID", screenId );
//				msg_value = msg.getMessage( "0005" );
//				ws.setMessage( msg_value );
//				String [] userObject = {msg_value, "F" };
//				ws.setUserObject( userObject );
//			}
//			else
//			{
//				msg.setArg( "SCREEN_ID", screenId );
//				msg_value = msg.getMessage( "0012" );
//				ws.setMessage( msg_value );
//				String [] userObject = {msg_value, "S" };
//				ws.setUserObject( userObject );
//			}		
//	
//			ws.write();
//			return;
//		}
//		else if(mode.equals("Complete"))
//		{
//			String[] eval_refitem   	= wf.getValue("eval_refitem");
//
//			String setData[][] = new String[wf.getRowCount()][];
//
//			for (int i = 0; i<wf.getRowCount(); i++) 
//			{
//				String Data[] = { eval_refitem[i]};
//				setData[i] = Data;
//			}
//
//			// 해당클래스, 메소드, nickName, ConType을 Mapping한다.
//			SepoaOut value = setComplete(info, setData);
//
//			if ( value.status != 1 )	
//			{
//				isOk = false;
//			}else{
//				isOk = true;
//			}
//
//			//등록중 오류가 발생하였다면...
//			if ( ! isOk ){
//				msg.setArg( "SCREEN_ID", screenId );
//				msg_value = msg.getMessage( "0004" );
//				ws.setMessage( msg_value );
//				String [] userObject = {msg_value, "F" };
//				ws.setUserObject( userObject );
//			}
//			else
//			{
//				msg.setArg( "SCREEN_ID", screenId );
//				msg_value = msg.getMessage( "0001" );
//				ws.setMessage( msg_value );
//				String [] userObject = {msg_value, "S" };
//				ws.setUserObject( userObject );
//			}		
//	
//			ws.write();
//			return;
//		}
//	}   

	public GridData setEvaDelete(GridData gdReq, SepoaInfo info) throws Exception
	{
		String serviceId = "p0080";
		String conType = "TRANSACTION";
		String MethodName = "setEvabddel1";
		
		GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
	
		SepoaOut value = null;
		SepoaRemote wr = null;

		// 다음은 실행할 class을 =loading하고 Method호출수 결과를 return하는 부분
		try{

			gdRes.addParam("mode", "doDelete");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			value = ServiceConnector.doService(info, "SR_021", "TRANSACTION","setEvaDelete", obj);
			
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		
		}
		catch(Exception e){
			try{
				Logger.err.println("err = " + e.getMessage());
//				Logger.err.println("message = " + value.message);
//				Logger.err.println("status = " + value.status);				
			}catch(NullPointerException ne){
				Logger.debug.println();
        	}
		}
		finally{
			try{
			    if(wr != null){ wr.Release(); }
			}catch(Exception e){
				Logger.debug.println();
			}
		}
		return gdRes;
	}
	
	public GridData setEvaComplete(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		String serviceId = "p0080";
		String conType = "TRANSACTION";
		String MethodName = "setEvabdcom1";

			try {
    			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); // 그리드

    			String cols_ids = JSPUtil.CheckInjection(gdReq.getParam("cols_ids")).trim();
    			String[] grid_col_ary = SepoaString.parser(cols_ids, ",");

				gdRes.setSelectable(false);
    			gdRes.addParam("mode", "dosave");

    			Object[] obj = { data };
    			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
    			SepoaOut value = ServiceConnector.doService(info, "SR_021", "TRANSACTION", "setEvaComplete", obj);
    	
	    			if (value.flag) {
	    				gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    				gdRes.setStatus("true");
	    			} else {
	    				gdRes.setMessage(value.message);
	    				gdRes.setStatus("false");
	    				return gdRes;
	    			} 
    			}catch (Exception e) {
					gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
					gdRes.setStatus("false");
				}

    		return gdRes;
			
		}

	public SepoaOut setComplete( SepoaInfo info, String[][] SetData)
	{
		String serviceId = "p0080";
		String conType = "TRANSACTION";
		String MethodName = "setEvabdcom1";

		Object[] obj = {SetData};

		SepoaOut value = null;
		SepoaRemote wr = null;

		// 다음은 실행할 class을 =loading하고 Method호출수 결과를 return하는 부분
		try{
			wr = new SepoaRemote( serviceId, conType, info );
			value = wr.lookup( MethodName, obj );
		}
		catch(Exception e){
			try{
				Logger.err.println("err = " + e.getMessage());
//				Logger.err.println("message = " + value.message);
//				Logger.err.println("status = " + value.status);				
			}catch(NullPointerException ne){
				Logger.debug.println();
        	}
		}
		finally{
			try{
				if(wr != null){ wr.Release(); }
			}catch(Exception e){
				Logger.debug.println();
			}
		}
		return value;
	}

}
