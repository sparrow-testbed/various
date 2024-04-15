package dt.rat;
 
import java.util.*;
import java.io.*;

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


public class rat_bd_lis3 extends HttpServlet {

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
    		
    		if("getratbdRegList".equals(mode)){ // 참가신청등록
    			gdRes = this.getratbdRegList(gdReq, info);
    		}
    		else if("setRaDelete".equals(mode)){ // 역경매공고 삭제
    			//gdRes = this.setRaDelete(gdReq, info);
    			Logger.debug.println();
    		}
    		else if("doData".equals(mode)){ // 저장 샘플
    		//	gdRes = this.doData(gdReq, info);
    			Logger.debug.println();
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
	private GridData getratbdRegList(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "p1008", "CONNECTION","getratbdRegList", obj);
	
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

//	
//	
//	public void doQuery(WiseStream ws) throws Exception {
//       	//get session
//       	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//       	Message msg = new Message("KO","p1008");
//	           		
//		String mode = ws.getParam("mode");
//		
//		Logger.debug.println(info.getSession("ID"),this,"mode------------------>"+mode);
//	    		
//
//		if(mode.equals("getratbdRegList")) { //참가자등록조회
//            String house_code   = info.getSession("HOUSE_CODE");
//	       	String from_date	= ws.getParam("from_date");
//	       	String to_date		= ws.getParam("to_date");
//	       	String ann_no		= ws.getParam("ann_no");
//	       	String ann_item		= ws.getParam("ann_item");
//	       	String bid_flag		= ws.getParam("bid_flag");
//            String CHANGE_USER_NAME     = ws.getParam("CHANGE_USER_NAME");
//	       	
//			String[] pData = {house_code, from_date, to_date, ann_no, ann_item, bid_flag, CHANGE_USER_NAME};
//			
//			WiseOut out = getratbdRegList(info, pData);
//			
//	        WiseFormater wf = ws.getWiseFormater(out.result[0]);
//
//	        String[] obj = new String[1];
//    		if(checkNull(out.result[1]) != null) {
//      			WiseFormater wf1 = ws.getWiseFormater(out.result[1]);
//      			if(wf1.getRowCount() > 0) 
//        			obj[0] = getDBDate(wf1.getValue(0, 0));
//      			else 
//           			obj[0] = getServerDate();
//    		} else {
//       			obj[0] = getServerDate();
//            }
//   		    ws.setUserObject(obj);
//       		
//	        if(wf == null) { 
//	        	msg.getMessage("0001");
//	       		ws.setMessage("데이타 포맷이 정확하지 않습니다.");
//	       		ws.write();
//    	    	return;
//	        }
//		    
//	   	    if(wf.getRowCount() == 0) {
//				ws.setCode("M001");
//				ws.setMessage("조회된 데이타가 없습니다.");
//	        	ws.write();
//				return;
//      	    }
//
//            int INDEX_SELECTED              =    ws.getColumnIndex("SELECTED");       
//            int INDEX_ANN_NO                =    ws.getColumnIndex("ANN_NO");
//            int INDEX_ANN_ITEM              =    ws.getColumnIndex("ANN_ITEM");      
//            int INDEX_BID_BEGIN_DATE        =    ws.getColumnIndex("BID_BEGIN_DATE");
//            int INDEX_BID_END_DATE          =    ws.getColumnIndex("BID_END_DATE");  
//            int INDEX_CHANGE_USER_NAME_LOC  =    ws.getColumnIndex("CHANGE_USER_NAME_LOC");  
//            int INDEX_STATUS_TEXT           =    ws.getColumnIndex("STATUS_TEXT");   
//            int INDEX_SIGN_PERSON_ID        =    ws.getColumnIndex("SIGN_PERSON_ID");        
//            int INDEX_SIGN_STATUS           =    ws.getColumnIndex("SIGN_STATUS");        
//            int INDEX_RA_TYPE1              =    ws.getColumnIndex("RA_TYPE1");        
//            
//            int INDEX_VOTE_COUNT            =    ws.getColumnIndex("VOTE_COUNT");        
//            
//            int INDEX_CHANGE_USER_ID        =    ws.getColumnIndex("CHANGE_USER_ID");        
//            int INDEX_STATUS                =    ws.getColumnIndex("STATUS");        
//            int INDEX_PR_NO                 =    ws.getColumnIndex("PR_NO");         
//            int INDEX_CONT_TYPE2            =    ws.getColumnIndex("CONT_TYPE2");         
//            int INDEX_BID_END_DATE_VALUE    =    ws.getColumnIndex("BID_END_DATE_VALUE");         
//            int INDEX_CTRL_CODE             =    ws.getColumnIndex("CTRL_CODE");
//            
//            int INDEX_OPEN_REQ_FROM_DATE             =    ws.getColumnIndex("OPEN_REQ_FROM_DATE");
//            int INDEX_OPEN_REQ_TO_DATE             =    ws.getColumnIndex("OPEN_REQ_TO_DATE");
//            
//            
//
//			for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
//				String ls_ann_no          = wf.getValue("ANN_NO", i);
//
//				String[] img_check  = {"false", ""};
//				String[] img_ann_no =  {"", ls_ann_no, ls_ann_no};
//
//                ws.addValue(INDEX_SELECTED          ,    img_check , "");       
//                ws.addValue(INDEX_ANN_NO            ,    img_ann_no , "");  
//                ws.addValue(INDEX_ANN_ITEM          ,    wf.getValue("ANN_ITEM"                , i), "");
//                ws.addValue(INDEX_VOTE_COUNT        ,    wf.getValue("VOTE_COUNT"              , i), "");
//                ws.addValue(INDEX_BID_BEGIN_DATE    ,    wf.getValue("BID_BEGIN_DATE"          , i), "");
//                ws.addValue(INDEX_BID_END_DATE      ,    wf.getValue("BID_END_DATE"            , i), "");
//                ws.addValue(INDEX_CHANGE_USER_NAME_LOC,  wf.getValue("CHANGE_USER_NAME_LOC"    , i), "");
//                ws.addValue(INDEX_STATUS_TEXT       ,    wf.getValue("STATUS_TEXT"             , i), "");
//                
//                //hidden value
//                ws.addValue(INDEX_RA_TYPE1    		,    wf.getValue("RA_TYPE1"      		   , i), "");
//                ws.addValue(INDEX_SIGN_PERSON_ID    ,    wf.getValue("SIGN_PERSON_ID"          , i), "");
//                ws.addValue(INDEX_SIGN_STATUS       ,    wf.getValue("SIGN_STATUS"             , i), "");
//                ws.addValue(INDEX_CHANGE_USER_ID    ,    wf.getValue("CHANGE_USER_ID"          , i), "");
//                ws.addValue(INDEX_STATUS            ,    wf.getValue("STATUS"                  , i), "");
//                ws.addValue(INDEX_PR_NO             ,    wf.getValue("PR_NO"                   , i), "");
//                ws.addValue(INDEX_BID_END_DATE_VALUE,    wf.getValue("BID_END_DATE_VALUE"      , i), "");
//                ws.addValue(INDEX_CTRL_CODE         ,    wf.getValue("CTRL_CODE"               , i), "");
//                               
//                ws.addValue(INDEX_OPEN_REQ_FROM_DATE         ,    wf.getValue("OPEN_REQ_FROM_DATE"               , i), "");
//                ws.addValue(INDEX_OPEN_REQ_TO_DATE         ,    wf.getValue("OPEN_REQ_TO_DATE"               , i), "");
//
//			}
//	       	ws.setCode("M001");
//	       	ws.setMessage("성공적으로 작업을 수행하였습니다..");
//	       	ws.write();		
//		}
//   	}
//
//       	public WiseOut getratbdRegList(WiseInfo info, String[] pData) {
//       		Object[] args = {pData};
//       		
//       		WiseOut rtn = null;
//       		WiseRemote wr = null;
//
//       		String conType    = "CONNECTION";
//       		String nickName   = "p1008";
//       		String MethodName = "getratbdRegList";
//
//       		try {
//           		wr = new WiseRemote(nickName, conType, info);
//       			rtn = wr.lookup(MethodName, args);
//       		}catch(Exception e) {
//           		Logger.dev.println(info.getSession("ID"), this, "Servlet===>getratbdRegList Exceptioin =====> " + e.getMessage());
//       		}finally{
//			    wr.Release();
//       		}
//
//       		return rtn;						
//	}

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
//   	public void doData(WiseStream ws) throws Exception {
//		//get session
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//		
//		//get Parameter
//		String mode = ws.getParam("mode");
//		WiseFormater wf = ws.getWiseFormater();
//
//		
//		Logger.debug.println(info.getSession("ID"),this,"doData mode------------------>"+mode);
//	}

	public String checkNull(String value) {
        if(value == null || "".equals(value.trim()))
        	{value = null;}
        
		return value;
	}
	
    public String getServerDate() {
        java.util.Calendar svr_calendar = java.util.Calendar.getInstance();
        
        svr_calendar.setTime(new java.util.Date());
        
        return String.valueOf(svr_calendar.getTimeInMillis());
    }

    public String getDBDate(String date_time) {
        int db_year     = Integer.parseInt(date_time.substring(0,4));
        int db_month    = Integer.parseInt(date_time.substring(4,6)) - 1; 
        int db_date     = Integer.parseInt(date_time.substring(6,8));
        int db_hour     = Integer.parseInt(date_time.substring(8,10));
        int db_minute   = Integer.parseInt(date_time.substring(10,12));
        int db_second   = Integer.parseInt(date_time.substring(12,14));
        
        java.util.Calendar svr_calendar = java.util.Calendar.getInstance();
        
        svr_calendar.set(db_year, db_month, db_date, db_hour, db_minute, db_second);

        return String.valueOf(svr_calendar.getTimeInMillis());
    }

}
/*******************************************************************************************************************************
                                                       END OF File
*********************************************************************************************************************************/
