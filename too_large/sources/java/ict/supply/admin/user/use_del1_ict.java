package ict.supply.admin.user;

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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class use_del1_ict  extends HttpServlet 
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
			if ("setDelete".equals(mode)) {
				gdRes = setDelete(gdReq, info); // 승인
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

	/* ICT 사용 : 사용자정보 삭제 */
	private GridData setDelete(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "s6030","TRANSACTION","setDelete_ict",obj);
    		
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
	
	
}	
	/*public void doData(SepoaStream ws) throws Exception {

        	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        	SepoaFormater wf = ws.getSepoaFormater();
			wf.print();
			String[] house_code = wf.getValue("HOUSE_CODE");
			String[] user_id = wf.getValue("USER_ID");
			String flag = ws.getParam("flag");
				
			String setData[][] = new String[wf.getRowCount()][];
			for (int i = 0; i<wf.getRowCount(); i++) 
			{

				String Data[] = {house_code[i], user_id[i]};
				setData[i] = Data;
			}
			
			
			SepoaOut value = setDelete(info,setData,"setDelete"); 					
    		//client로 메세지를 뿌려주기위함
    		String [] userObject = { value.message };
        	ws.setUserObject( userObject );
			
			
			if (flag.equals("R")) {
        		SepoaOut value = setDelete(info,setData,"setDelete"); 
        		
        		//client로 메세지를 뿌려주기위함
        		String [] userObject = { value.message };
            	ws.setUserObject( userObject );
            
        	}else {
        		SepoaOut value = setDelete(info,setData,"setStatusD");
        	
        		//client로 메세지를 뿌려주기위함
        		String [] userObject = { value.message };
            	ws.setUserObject( userObject );
            }
            	
        		
        	ws.setCode("0000");
        	ws.setMessage("정상적으로 데이타가 삭제되었습니다.");
        	ws.write();
    	}

	public SepoaOut setDelete(SepoaInfo info, String[][] setData,String MethodName) {

    		String nickName= "s6030";
    		String conType = "TRANSACTION";
	    	SepoaOut value = null; 
	    	SepoaRemote ws = null;
	    	Object[] obj = {setData};
	    	try {
		        	ws = new SepoaRemote(nickName,conType,info);
		        	value = ws.lookup(MethodName,obj);

		 			if(value.status == 1) {
		  				for(int i = 0 ; i < value.result.length ; i++){
		   					Logger.debug.println("value = " + value.result[0]);
		   				}
   					}
				Logger.debug.println("message = " + value.message);	
	   			Logger.debug.println("status = " + value.status);

	    	}catch(Exception e) {
	    		try{
		        	Logger.err.println("test1 err = " + e.getMessage());
		        	Logger.err.println("message = " + value.message);	
		   			Logger.err.println("status = " + value.status);	    			
	    		}catch(NullPointerException ne){
					ne.printStackTrace();
				}
	    	} finally {
		    	try{
					ws.Release();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
	    	return value;
    }
    	*/
    	
    	
    	
    	
    	

