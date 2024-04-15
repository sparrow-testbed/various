package admin.organization.depart;

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


public class dep_bd_lis1 extends HttpServlet {
	
	
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
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getMainternace".equals(mode)){ 
    			gdRes = this.getMainternace(gdReq, info);
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
	private GridData getMainternace(GridData gdReq, SepoaInfo info) throws Exception{
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
	    	
	    	value = ServiceConnector.doService(info, "p6008", "CONNECTION","getMainternace", obj);
	
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

//	//	조회시 사용되는 Method 입니다. Method Name(doQuery)는 변경할 수 없습니다.
//	public void doQuery(WiseStream ws) throws Exception 
//	{
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//		//framework을 사용하여 원하는 결과값을 얻는다.
//		String I_HOUSE_CODE   = ws.getParam("I_HOUSE_CODE");
//		String I_COMPANY_CODE = ws.getParam("I_COMPANY_CODE");
//		String I_DEPT         = ws.getParam("I_DEPT");
//		String I_DEPT_NAME    = ws.getParam("I_DEPT_NAME");
//		String I_PR_LOCATION  = ws.getParam("I_PR_LOCATION");
//		
//		//String value = getSelect(info, I_HOUSE_CODE, I_COMPANY_CODE, I_DEPT, I_DEPT_NAME, I_PR_LOCATION);
//    	//결과값을 WiseTable에서 조작가능하게 formatting한다.
//		Object[] obj = {
//				I_HOUSE_CODE
//				, I_COMPANY_CODE
//				, I_DEPT
//				, I_DEPT_NAME
//				, I_PR_LOCATION
//		};
//		
//		WiseOut value = ServiceConnector.doService(info, "p6008", "CONNECTION","getMainternace", obj);		
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//
//    	for(int i=0; i<wf.getRowCount(); i++) 
//    	{
//    		String[] check = {"false", ""};	//Check flag, Check Tooltip
//    		String profile_flag = wf.getValue("PROFILE_FLAG",i);
//    		
//    		if("".equals(profile_flag)){ // 프로파일코드 존재여부
//    			profile_flag = "미설정" ;  
//    		}else{
//    			profile_flag = "설정"; 
//    		}
//    		
//        	ws.addValue("SEL"				, check								, "");
//    		ws.addValue("DEPT"				, wf.getValue("DEPT",i)				, "");	//depart Code
//    		ws.addValue("DEPT_NAME_LOC"		, wf.getValue("DEPT_NAME_LOC",i)	, "");		//loc
//    		ws.addValue("DEPT_NAME_ENG"		, wf.getValue("DEPT_NAME_ENG",i)	, "");
//    		ws.addValue("PR_LOCATION_NAME"	, wf.getValue("PR_LOCATION_NAME",i)	, "");
//    		ws.addValue("PR_LOCATION"		, wf.getValue("PR_LOCATION",i)		, "");
//    		ws.addValue("PROFILE_FLAG"		, profile_flag		, "");
//    		ws.addValue("HIGH_DEPT"			, wf.getValue("HIGH_DEPT",i)		, "");
//    		ws.addValue("HIGH_DEPT_TEXT"	, wf.getValue("HIGH_DEPT_TEXT",i)		, "");
//    		ws.addValue("DEPT_LEVEL"		, wf.getValue("DEPT_LEVEL",i)		, "");
//    	}
//    	ws.setCode("M001");
//    	ws.setMessage(value.message);
//    	
//    	//위에서 구성한 data를 WiseTable로 전송한다.
//    	ws.write();
//    	
//	}
//	public void doData(WiseStream ws) throws Exception 
//	{
//        
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//		WiseFormater wf = ws.getWiseFormater();
//		
//		//Table에서 가져온 Data를 특정컬럼값으로 가져온다.
//		String I_COMPANY_CODE = ws.getParam("I_COMPANY_CODE");
//		String[] DEPT         = wf.getValue("DEPT");
//		String[] PR_LOCATION  = wf.getValue("PR_LOCATION");
//
//		//Sessing에서 가져올 User정보
//    	String HOUSE_CODE        = info.getSession("HOUSE_CODE");
//		String CHANGE_USER_ID    = info.getSession("ID");
//		String cur_date = WiseDate.getShortDateString(); 
//		String cur_time = WiseDate.getShortTimeString(); 
//		String status = "D"; 
//		
//		String setData[][] = new String[wf.getRowCount()][];
//
//		for (int i = 0; i<wf.getRowCount(); i++) {
//			String Data[] = {
//					  status
//					, cur_date
//					, cur_time
//					, CHANGE_USER_ID
//					, HOUSE_CODE
//					, I_COMPANY_CODE
//					, DEPT[i]
//					, PR_LOCATION[i]
//				};
//					
//			setData[i] = Data;  			
//		}	
//
//		//해당클래스, 메소드, nickName, ConType을 Mapping한다.
//		WiseOut value = ServiceConnector.doService(info, "p6008", "TRANSACTION","setDelete", setData);
//		
//		//WiseTable에 message를 전송할 수 있다. 또한 script에서 code와 message를 얻을 수 있다.
//		ws.setCode("M002");
//		ws.setMessage(value.message);
//    	
//		//위에서 구성한 data를 WiseTable로 전송한다.
//		ws.write();
//	}
}
