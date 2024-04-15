package supply.bidding.bidd;

import java.util.*;

import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

import java.io.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;


public class ebd_bd_lis15 extends HttpServlet {
	
	
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
    		
    		if("getBidAvgRateList".equals(mode)){ // 역경매현황
    			gdRes = this.getBidAvgRateList(gdReq, info);
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
	private GridData getBidAvgRateList(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "s1009", "CONNECTION","getBidAvgRateList", obj);
	
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
//		if(mode.equals("getBidAvgRateList")) { //
//	        String from_date	= ws.getParam("from_date");
//		      String to_date		= ws.getParam("to_date");
//		      String bid_type		= ws.getParam("bid_type");
//	       	String cont_type2 = ws.getParam("cont_type2");
//	            	            
//				  String[] pData = {from_date, to_date, bid_type, cont_type2};
//	
//				  WiseOut out = getBidAvgRateList(info, pData);
//		      WiseFormater wf = ws.getWiseFormater(out.result[0]);
//	   			String[] obj = new String[1];
//	    		
//	    		if(checkNull(out.result[1]) != null) {
//	      			WiseFormater wf1 = ws.getWiseFormater(out.result[1]);
//	      			if(wf1.getRowCount() > 0) 
//	        			obj[0] = getDBDate(wf1.getValue(0, 0));
//	      			else 
//	           	  obj[0] = getServerDate();
//	           	  
//	    		} else {
//	       			obj[0] = getServerDate();
//	        }
//   		    ws.setUserObject(obj);
//       		
//	        if(wf == null) { 
//	        	msg.getMessage("0001");
//	       		ws.setMessage("����Ÿ ������ ��Ȯ���� �ʽ��ϴ�.");
//	       		ws.write();
//    	    	return;
//	        }
//		    
//	   	    if(wf.getRowCount() == 0) {
//					ws.setCode("M001");
//					ws.setMessage("��ȸ�� ����Ÿ�� ����ϴ�.");
//	        ws.write();
//					return;
//     	}
//
//      int INDEX_SELECTED              = ws.getColumnIndex("SELECTED");
//      //int INDEX_ITEM_TYPE             = ws.getColumnIndex("ITEM_TYPE");
//      int INDEX_ITEM_NAME             = ws.getColumnIndex("ITEM_NAME");
//      int INDEX_FINAL_ESTM_PRICE_ENC  = ws.getColumnIndex("FINAL_ESTM_PRICE_ENC");
//      int INDEX_BID_AMT               = ws.getColumnIndex("BID_AMT");
//      int INDEX_AVG_RATE              = ws.getColumnIndex("AVG_RATE");
//            
//			for(int i=0; i<wf.getRowCount(); i++) { //����Ÿ�� �ִ� ���
//				
//								String[] img_check  = {"false", ""};
//				
//                ws.addValue(INDEX_SELECTED             ,    img_check , "");       
//                ws.addValue(INDEX_ITEM_NAME            ,    wf.getValue("ITEM_NAME"                , i), "");
//                ws.addValue(INDEX_FINAL_ESTM_PRICE_ENC ,    wf.getValue("FINAL_ESTM_PRICE_ENC"     , i), "");
//                ws.addValue(INDEX_BID_AMT              ,    wf.getValue("BID_AMT"                  , i), "");
//                ws.addValue(INDEX_AVG_RATE             ,    wf.getValue("AVG_RATE"                 , i), "");     
//			}
//	
//	       	ws.setCode("M001");
//	       	ws.setMessage("���������� �۾��� �����Ͽ����ϴ�..");
//	       	ws.write();		
//			}
//   	}
//
//   	public WiseOut getBidAvgRateList(WiseInfo info, String[] pData) {
//       		Object[] args = {pData};
//       		
//       		WiseOut rtn = null;
//       		WiseRemote wr = null;
//
//       		String conType    = "CONNECTION";
//       		String nickName   = "s1009";
//       		String MethodName = "getBidAvgRateList";
//
//       		try {
//           		wr = new WiseRemote(nickName, conType, info);
//       			rtn = wr.lookup(MethodName, args);
//       		}catch(Exception e) {
//           		Logger.dev.println(info.getSession("ID"), this, "Servlet===>getratbdlis1_1 Exceptioin =====> " + e.getMessage());
//       		}finally{
//			    wr.Release();
//       		}
//
//       		return rtn;						
//	}
//
///**********************************************************************************************************************************/
///**********************************************************************************************************************************/
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
//
//	public String checkNull(String value) {
//		if(value == null) value = null;
//		if(value.trim().equals("")) value = null;
//		return value;
//	}
//	
//    public String getServerDate() {
//        java.util.Calendar svr_calendar = java.util.Calendar.getInstance();
//        
//        svr_calendar.setTime(new java.util.Date());
//        
//        return String.valueOf(svr_calendar.getTimeInMillis());
//    }
//
//    public String getDBDate(String date_time) {
//        int db_year     = Integer.parseInt(date_time.substring(0,4));
//        int db_month    = Integer.parseInt(date_time.substring(4,6)) - 1; 
//        int db_date     = Integer.parseInt(date_time.substring(6,8));
//        int db_hour     = Integer.parseInt(date_time.substring(8,10));
//        int db_minute   = Integer.parseInt(date_time.substring(10,12));
//        int db_second   = Integer.parseInt(date_time.substring(12,14));
//        
//        java.util.Calendar svr_calendar = java.util.Calendar.getInstance();
//        
//        svr_calendar.set(db_year, db_month, db_date, db_hour, db_minute, db_second);
//
//        return String.valueOf(svr_calendar.getTimeInMillis());
//    }
//
}
/*******************************************************************************************************************************
                                                       END OF File
*********************************************************************************************************************************/
