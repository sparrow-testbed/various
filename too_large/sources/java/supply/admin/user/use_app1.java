package supply.admin.user;

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
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class use_app1 extends HttpServlet 
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
			if ("setApproval".equals(mode)) {
				gdRes = setApproval(gdReq, info); // 승인
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

	
	/**
	 * 사용자승인 
	 * setApproval
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-29
	 * @modify 2014-10-29
	 */
	private GridData setApproval(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "s6030","TRANSACTION","setApproval",obj);
    		
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
          String id = info.getSession("ID");
          
        	SepoaFormater wf = ws.getSepoaFormater();			
			//Table에서 가져온 Data를 특정컬럼값으로 가져온다.
			String[] house_code = wf.getValue("HOUSE_CODE");
			String[] user_id = wf.getValue("USER_ID");
			String[] menu_code = wf.getValue("MENU_NAME");
			
			String setData[][] = new String[wf.getRowCount()][];
			for (int i = 0; i<wf.getRowCount(); i++) {
				String Data[] = {menu_code[i],house_code[i], user_id[i]};
				setData[i] = Data;  			
			}	
        	SepoaOut value = setApproval(info,setData);
        	
        	//client로 메세지를 뿌려주기위함
        	String [] userObject = { value.message };
            ws.setUserObject( userObject );
            
        	
        	ws.setCode("0000");
        	ws.setMessage("정상적으로 데이타가 승인되었습니다.");
        	ws.write();
    	}		

	public SepoaOut setApproval(SepoaInfo info, String[][] setData) {

    		String nickName= "s6030";
    		String conType = "TRANSACTION";
       		String MethodName = "setApproval";
	    	SepoaOut value = null; 
	    	sepoa.util.SepoaRemote ws = null;
	    	
	    	
	    	String id = info.getSession("ID");
	    	
	    	Object[] obj = {setData};
	    	try {
		        	ws = new sepoa.util.SepoaRemote(nickName,conType,info);
		        	value = ws.lookup(MethodName,obj);

		 			if(value.status == 1) {
		  				for(int i = 0 ; i < value.result.length ; i++){
		   					Logger.debug.println(id,this,"value = " + value.result[0]);
		   				}
   					}
					Logger.debug.println(id,this,"message = " + value.message);	
		   			Logger.debug.println(id,this,"status = " + value.status);
	    	}catch(Exception e) {
	    		try{
		        	Logger.debug.println(id,this,"test1 err = " + e.getMessage());
		        	Logger.debug.println(id,this,"message = " + value.message);	
		   			Logger.debug.println(id,this,"status = " + value.status);	    			
	    		}catch(NullPointerException ne){
					ne.printStackTrace();
				}
	    	}finally {
		    	try{
		    		System.out.println("finally");
					ws.Release();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
	    	return value;
    	}*/

