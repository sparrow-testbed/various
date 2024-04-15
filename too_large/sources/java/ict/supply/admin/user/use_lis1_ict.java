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

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class use_lis1_ict   extends HttpServlet 
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
			if ("getMainternace".equals(mode)) {
				gdRes = getMainternace(gdReq, info); // 조회
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
	
	
	/* ICT 사용 */
	private GridData getMainternace(GridData gdReq, SepoaInfo info) throws Exception {
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
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids"));
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	
	    	
	    	
	
	    	gdRes.addParam("mode", "doQuery");
	    	
	
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "s6030", "CONNECTION", "getMainternace_ict", obj);

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
 



		/*//조회시 사용되는 Method 입니다. Method Name(doQuery)는 변경할 수 없습니다.
    	public void doQuery(SepoaStream ws) throws Exception {

    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    		String house_code = info.getSession("HOUSE_CODE");
    		
    		String user_id = ws.getParam("user_id");
    		String user_name = ws.getParam("user_name");
    		String company_code = ws.getParam("company_code");
    		String depart = ws.getParam("depart");
    		String sign_status = ws.getParam("sign_status");
    		String user_type = ws.getParam("user_type");	
    		String work_type = ws.getParam("work_type");
    		
    		String args[] = {sign_status, house_code, user_id, "%"+user_name+"%", company_code, depart,user_type,work_type};
    		
    		String value = null;
			value = getSelect(info, args);
    		
        	SepoaFormater wf = ws.getSepoaFormater(value);
        	Logger.debug.println(info.getSession("ID"),ws.getRequest(),"opr_lis1:servlet:info===>"+info.getSession("ID"));

			if(wf.getRowCount() == 0)
			{
	        	ws.setCode("M001");
    	    	ws.setMessage("조회된 데이터가 없습니다.");
        		ws.write();
        		return;
        	}

        	String tmp = new String();
        	
                	
        	//행별로 각 컬럼에 Query한 값을 Setting한다.     	
        	for(int i=0; i<wf.getRowCount(); i++) {
        		//Check Value Set
        		String[] check = {"false", ""};	//Check flag, Check Tooltip
            	ws.addValue(0, check, "");
        		ws.addValue(1, wf.getValue(i, 1), "");	//USER_ID																			
        		ws.addValue(2, tmp = (wf.getValue(i, 2).equals("null") ? "" : wf.getValue(i, 2)), "");	//USER_NAME_LOC	
        		ws.addValue(3, tmp = (wf.getValue(i, 3).equals("null") ? "" : wf.getValue(i, 3)), "");	//COMPANY_NAME	
        		ws.addValue(4, tmp = (wf.getValue(i, 4).equals("null") ? "" : wf.getValue(i, 4)), "");	//TEXT_WORK_TYPE	
        		ws.addValue(5, tmp = (wf.getValue(i, 5).equals("null") ? "" : wf.getValue(i, 5)), "");	//DEPT	
        		ws.addValue(6, tmp = (wf.getValue(i, 6).equals("null") ? "" : wf.getValue(i, 6)), "");	//POSITION	
        		ws.addValue(7, tmp = (wf.getValue(i, 7).equals("null") ? "" : wf.getValue(i, 7)), "");	//MANAGER_POSITION	
        		ws.addValue(8, tmp = (wf.getValue(i, 8).equals("null") ? "" : wf.getValue(i, 8)), "");	//PHONE_NO	
        		
        		//MUP20020400001 seller profile이다.
        		String[] imagetext = {"", wf.getValue(i, 9) , wf.getValue(i, 10) };	//menu porfile name
            	ws.addValue(9, imagetext, ""); // menu porfile name
        		
        		//ws.addValue(6, tmp = (wf.getValue(i, 6).equals("null") ? "" : wf.getValue(i, 6)), "");		
        		ws.addValue(10, tmp = (wf.getValue(i, 0).equals("null") ? "" : wf.getValue(i, 0)), "");
        		ws.addValue(11, wf.getValue("SIGN_STATUS",i),"");  // sign_status
        	}
	         	ws.setCode("M001");
	        	ws.setMessage("정상적으로 데이타가 query되었습니다.");
	       	ws.write();
     	}



    	//framework에 접근하여 data을 추출하는 Method이다. 임의로 만들어서 사용하도록 한다.
    	public String getSelect(SepoaInfo info, String[] args)throws Exception {

    		Object obj[] = {(Object[])args};
    
    		String nickName= "s6030";		//sepoahub.srv에 등록된 Alias
    		String conType = "CONNECTION";		//conType : CONNECTION/TRANSACTION/NONDBJOB
       		String MethodName = "getMainternace";	//NickName으로 연결된 Class에 정의된 Method Name
       		SepoaOut value = new SepoaOut();
       		sepoa.util.SepoaRemote ws;
	        
	        //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	    	try {
		        	ws = new sepoa.util.SepoaRemote(nickName,conType,info);
		        	value = ws.lookup(MethodName,obj);		        	

	 				if(value.status == 1) {
	  				for(int i = 0 ; i < value.result.length ; i++){
	   					//Logger.debug.println("value = " + value.result[0]);
	   				}
   			}
				Logger.debug.println("message = " + value.message);	
	   			Logger.debug.println("status = " + value.status);
	    	} catch(Exception e) {
	    		try{
		        	Logger.err.println("test1 err = " + e.getMessage());
		        	Logger.err.println("message = " + value.message);	
		   			Logger.err.println("status = " + value.status);	    			
	    		}catch(NullPointerException ne){
					ne.printStackTrace();
				}
	     	} 
	    	return value.result[0];
    	}*/
}

