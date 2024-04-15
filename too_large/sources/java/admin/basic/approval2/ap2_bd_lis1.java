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
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ap2_bd_lis1 extends HttpServlet 
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
			}else if ("setUpdateInfo".equals(mode)) {
				Logger.debug.println();
				//gdRes = setUpdateInfo(gdReq, info); // 수정
			}else if ("setDeleteInfo".equals(mode)) {
				Logger.debug.println();
				//gdRes = setDeleteInfo(gdReq, info); // 삭제
			}

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
	    	value = ServiceConnector.doService(info, "p6028", "CONNECTION","getMaintain",obj);
	
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

		if(mode.equals("getMaintain")){
			getMaintain(ws, mode);
    	}
	}

	private void getMaintain(SepoaStream ws, String mode) throws Exception
	{
		SepoaInfo info 		= SepoaSession.getAllValue(ws.getRequest());
		String house_code 	= info.getSession("house_code");
		String user_id 		= "";
		String sign_cnt		= "";
		
		String SIGN_PATH_NO 	= ws.getParam("SIGN_PATH_NO");
		String SIGN_PATH_NAME 	= ws.getParam("SIGN_PATH_NAME");
		
		//String[] args = {house_code, user_id, SIGN_PATH_NO, SIGN_PATH_NAME};
		String[] args = {house_code, user_id, SIGN_PATH_NO, SIGN_PATH_NAME};
		Object[] obj = {args};

    	SepoaOut value = ServiceConnector.doService(info, "p6028", "CONNECTION","getMaintain", obj);
    	SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

    	for(int i=0; i<wf.getRowCount(); i++)
    	{
    		sign_cnt		= "";
    		if(!wf.getValue("SIGN_CNT", i).equals("0")){   // 설정된 결재경로가 있을 경우 경로수 표시
    			sign_cnt = wf.getValue("SIGN_CNT", i);
    		}
    		
    		String[] check 		= {"false", ""};
    		String[] imagetext1 = {"/kr/images/button/query.gif",sign_cnt, null};
//			String[] imagetext2 = {"/kr/images/button/query.gif", "" , wf.getValue("SIGN_REMARK", i)};
			String[] imagetext2 = {"/kr/images/button/query.gif", wf.getValue("SIGN_REMARK", i) , wf.getValue("SIGN_REMARK", i)};

    		ws.addValue("SELECTED", 		check, 								""); //선택
        	ws.addValue("SIGN_PATH_NO", 	wf.getValue("SIGN_PATH_NO", 	i), ""); //제목
    		ws.addValue("SIGN_PATH_NAME", 	wf.getValue("SIGN_PATH_NAME", 	i), ""); //작성일
    		ws.addValue("SIGN_PATH", 		imagetext1, 						""); //선택
        	ws.addValue("SIGN_REMARK", 		imagetext2, 						""); //제목
        	ws.addValue("SIGN_REMARK_HIDDEN", 		"", 						""); //제목
    		ws.addValue("ADD_DATE", 		wf.getValue("ADD_DATE", 		i), ""); //작성일
    		ws.addValue("CHANGE_DATE", 		wf.getValue("CHANGE_DATE", 		i), ""); //선택
  		
    		ws.addValue("FLAG", 			"Y",	"");
    	}

    	ws.setCode("M001");
    	ws.setMessage(value.message);
    	ws.write();
	}

   public void doData(SepoaStream ws) throws Exception
    {
    	String mode 	= ws.getParam("mode");
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
		SepoaFormater wf = ws.getSepoaFormater();

		String house_code 	= info.getSession("house_code");
		String user_id 		= info.getSession("id");

		String[] SIGN_PATH_NO 	= wf.getValue("SIGN_PATH_NO");
		String[] SIGN_PATH_NAME = wf.getValue("SIGN_PATH_NAME");
		String[] SIGN_REMARK 	= wf.getValue("SIGN_REMARK");
		String[] SIGN_REMARK_HIDDEN 	= wf.getValue("SIGN_REMARK_HIDDEN");

		String current_date     = SepoaDate.getShortDateString();
		String current_time     = SepoaDate.getShortTimeString();

		String[][] data = new String[wf.getRowCount()][];

	    if(mode.equals("setInsert")){
	    	for(int i=0; i<wf.getRowCount(); i++) {
				String[] temp = {house_code, user_id, house_code, user_id, SIGN_PATH_NAME[i],
						SIGN_REMARK_HIDDEN[i], current_date, current_time, current_date, current_time};
				data[i] = temp;
			}
	    	setInsert(ws, mode, data);
	    }else if(mode.equals("setUpdate")){
	    	for(int i=0; i<wf.getRowCount(); i++) {
				String[] temp = {SIGN_PATH_NAME[i], SIGN_REMARK_HIDDEN[i], current_date, current_time,
						house_code, user_id, SIGN_PATH_NO[i] };
				data[i] = temp;
			}
	    	setUpdate(ws, mode, data);
	    }else if(mode.equals("setDelete")){
	    	for(int i=0; i<wf.getRowCount(); i++) {
				String[] temp = {house_code, user_id, SIGN_PATH_NO[i] };
				data[i] = temp;
			}
	    	setDelete(ws, mode, data);
	    }
    }

    private void setInsert(SepoaStream ws, String mode, String[][] data) throws Exception
	{
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		Object[] obj = {data} ;

        SepoaOut value = ServiceConnector.doService(info,"p6028","TRANSACTION","setInsert",obj);

        String[] uObj = {mode, String.valueOf(value.status)};
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
	}

    private void setUpdate(SepoaStream ws, String mode, String[][] data) throws Exception
	{
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		Object[] obj = {data} ;

        SepoaOut value = ServiceConnector.doService(info,"p6028","TRANSACTION","setUpdate",obj);

        String[] uObj = {mode, String.valueOf(value.status)};
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
	}

    private void setDelete(SepoaStream ws, String mode, String[][] data) throws Exception
	{
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		Object[] obj = {data} ;

        SepoaOut value = ServiceConnector.doService(info,"p6028","TRANSACTION","setDelete",obj);

        String[] uObj = {mode, String.valueOf(value.status)};
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
	}*/

}