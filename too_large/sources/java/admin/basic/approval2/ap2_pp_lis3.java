package admin.basic.approval2;

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
import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ap2_pp_lis3 extends HttpServlet 
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
			if ("getMaintain".equals(mode)) {
				gdRes = getMaintain(gdReq, info); // 결재경로현황 조회
			}
//			else if (mode.equals("setUpdateInfo")) {
//				//gdRes = setUpdateInfo(gdReq, info); // 수정
//			}else if (mode.equals("setDeleteInfo")) {
//				//gdRes = setDeleteInfo(gdReq, info); // 삭제
//			}

		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false"); 
			
		} finally {
			try {
				OperateGridData.write(req, res, gdRes, out);
			} catch (Exception e) {
				e.getMessage();
			}
		}
	}

	
	/**
	 * 결재경로 조회 
	 * getMaintain
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-29
	 * @modify 2014-10-29
	 */
	private GridData getMaintain(GridData gdReq, SepoaInfo info) throws Exception {
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
	
	    	gdRes.addParam("mode", "doQuery");
	
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "p6028", "CONNECTION","getMaintainSignPath",obj);
	
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



	/*public void doQuery(SepoaStream ws) throws Exception 
	{
		String mode = ws.getParam("mode");
		if(mode.equals("getMaintain")) 
    	{
			getMaintain(ws, mode);
    	}
	}

	private void getMaintain(SepoaStream ws, String mode) throws Exception{	    	
		SepoaInfo info 		= SepoaSession.getAllValue(ws.getRequest());
		String house_code 	= info.getSession("house_code");	
		String user_id 		= info.getSession("id");	
		String SIGN_PATH_NO = ws.getParam("sign_path_no");
		
		String[] args = {house_code,SIGN_PATH_NO};
		Object[] obj = {args};
	    SepoaOut value = ServiceConnector.doService(info, "p6028", "CONNECTION","getMaintainSignPath", obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
		
	    //데이타가 없는 경우
        if(wf.getRowCount() == 0) {
        	Message msg = new Message(info.getSession("LANGUAGE"),"p80");
        	ws.setCode("M001");
        	ws.setMessage(msg.getMessage("0024"));
        	ws.write();
        	return;
        }
        
        SepoaCombo sepoaCombo = new SepoaCombo();
       // String combo[][] = sepoaCombo.getCombo(ws.getRequest(), "SL0022", info.getSession("HOUSE_CODE") + "#M119" , "@");
        String combo[][] = sepoaCombo.getCombo(ws.getRequest(), "SL0197", info.getSession("HOUSE_CODE") + "#M119" , "@");
        
        //for(int j=0;j<2;j++){
        //	for(int k=0;k<4;k++)
        //	 Logger.debug.println(info.getSession("ID"),this,"combo================="+combo[j][k]);
        //}
        
    	for(int i=0; i<wf.getRowCount(); i++)
    	{
    		String[] check 		= {"false", ""};
    		String[] imagetext1 = {"/kr/images/button/query.gif", "" , null};  		
			
			
    		int comboIndex = sepoaCombo.getIndex(wf.getValue("PROCEEDING_FLAG", i));
    		
    		Logger.debug.println(info.getSession("ID"),this,"comboIndex================="+comboIndex); 
    		
			ws.addValue("SELECTED", 				check, 									""); 
			ws.addValue("SIGN_PATH_SEQ", 			wf.getValue("SIGN_PATH_SEQ", 		i), ""); 
    		ws.addValue("USER_NAME_LOC", 			wf.getValue("USER_NAME_LOC", 		i), ""); 
    		ws.addValue("USER_POP", 				imagetext1							  , ""); 
        	ws.addValue("DEPT_NAME", 				wf.getValue("DEPT_NAME", 			i),	""); 
    		ws.addValue("POSITION_NAME", 			wf.getValue("POSITION_NAME", 		i), ""); 
    		ws.addValue("MANAGER_POSITION_NAME", 	wf.getValue("MANAGER_POSITION_NAME",i), ""); 
    		ws.addValue("PROCEEDING_FLAG", 			combo								  ,	"", comboIndex); 
        	ws.addValue("SIGN_USER_ID", 			wf.getValue("SIGN_USER_ID", 		i), ""); 
    		ws.addValue("SIGN_PATH_NO", 			wf.getValue("SIGN_PATH_NO", 		i), ""); 
    		ws.addValue("POSITION", 				wf.getValue("POSITION", 			i),	""); 
        	ws.addValue("MANAGER_POSITION", 		wf.getValue("MANAGER_POSITION", 	i),	""); 
    	}

    	ws.setCode("M001");
    	ws.setMessage(value.message);
    	ws.write();
	}

	public void doData(SepoaStream ws) throws Exception {
		//Sessin 정보
		String mode 	= ws.getParam("mode");
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
		SepoaFormater wf = ws.getSepoaFormater();
		
		String house_code 	= info.getSession("house_code");	
		String user_id 		= info.getSession("id");	
		
		String[] SIGN_PATH_SEQ 		= wf.getValue("SIGN_PATH_SEQ");
		String[] SIGN_PATH_NO 		= wf.getValue("SIGN_PATH_NO");
		String[] SIGN_USER_ID 		= wf.getValue("SIGN_USER_ID");
		String[] PROCEEDING_FLAG 	= wf.getValue("PROCEEDING_FLAG");
	    
		String current_date     = SepoaDate.getShortDateString();
		String current_time     = SepoaDate.getShortTimeString();

		String[][] data = new String[wf.getRowCount()][];
		
		if(mode.equals("setInsertSignPath")){
	    	for(int i=0; i<wf.getRowCount(); i++) {
				String[] temp = {house_code, user_id, SIGN_PATH_NO[i], house_code, user_id
						, SIGN_PATH_NO[i], SIGN_USER_ID[i], PROCEEDING_FLAG[i]};
				data[i] = temp;
			}
	    	setInsertSignPath(ws, mode, data);
	    }else if(mode.equals("setUpdateSignPath")){
	    	for(int i=0; i<wf.getRowCount(); i++) {
				String[] temp = {SIGN_USER_ID[i], PROCEEDING_FLAG[i], house_code
						, user_id, SIGN_PATH_NO[i], SIGN_PATH_SEQ[i]};
				data[i] = temp;
			}
	    	setUpdateSignPath(ws, mode, data);
	    }else if(mode.equals("setDeleteSignPath")){
	    	for(int i=0; i<wf.getRowCount(); i++) {
				String[] temp = {house_code, user_id, SIGN_PATH_NO[i], SIGN_PATH_SEQ[i] };
				data[i] = temp;
			}
	    	setDeleteSignPath(ws, mode, data);
	    }
	}

	private void setInsertSignPath(SepoaStream ws, String mode, String[][] data) throws Exception
	{
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		Object[] obj = {data} ;
		
        SepoaOut value = ServiceConnector.doService(info,"p6028","TRANSACTION","setInsertSignPath",obj);
    	
        String[] uObj = {mode, String.valueOf(value.status)};
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
	}
    
    private void setUpdateSignPath(SepoaStream ws, String mode, String[][] data) throws Exception
	{
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		Object[] obj = {data} ;
		
        SepoaOut value = ServiceConnector.doService(info,"p6028","TRANSACTION","setUpdateSignPath",obj);
    	
        String[] uObj = {mode, String.valueOf(value.status)};
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
	}
    
    private void setDeleteSignPath(SepoaStream ws, String mode, String[][] data) throws Exception
	{
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		Object[] obj = {data} ;
		
        SepoaOut value = ServiceConnector.doService(info,"p6028","TRANSACTION","setDeleteSignPath",obj);
    	
        String[] uObj = {mode, String.valueOf(value.status)};
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
	}*/
}