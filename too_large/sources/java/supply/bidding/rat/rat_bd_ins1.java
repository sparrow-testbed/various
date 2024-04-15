package supply.bidding.rat;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
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


/**************************************************
 *BIDDING>역경매관리>역경매현황>입찰
 *************************************************/
public class rat_bd_ins1 extends HttpServlet {
	
	
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
    	SepoaFormater sf = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getReAuctionList".equals(mode)){ // 역경매현황
    			gdRes = this.getReAuctionList(gdReq, info);
    		}
    		else if("setReAuctioncreate".equals(mode)){ // 역경매공고 삭제
    			gdRes = this.setReAuctioncreate(gdReq, info);
    		}
    		else if("getRaMinPrice".equals(mode)){ // 역경매 입찰조회
    			String ra_no 		= JSPUtil.CheckInjection(gdReq.getParam("ra_no"));
    			String ra_count 	= JSPUtil.CheckInjection(gdReq.getParam("ra_count"));
    			String vendor_code 	= JSPUtil.CheckInjection(gdReq.getParam("vendor_code"));
    			
    			
    			sf = this.getRaMinPrice(gdReq, info, ra_no, ra_count, vendor_code);
    		}
    		else if("TEST".equals(mode)){ // 역경매 입찰조회
    			Logger.debug.println();
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("getRaMinPrice".equals(mode)){ // 저장 샘플
    				if(sf != null){
    				out.print(sf.getValue("CURRENT_PRICE", 0)+"&");
    				out.print(sf.getValue("CURRENT_DATETIME", 0)+"&");
    				out.print(sf.getValue("END_DATETIME", 0)+"&");
    				out.print(sf.getValue("RANKING", 0)); }else{out.print("&&&");}
        		}else{
        			OperateGridData.write(req, res, gdRes, out);
        		}
    			
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }  
    
    /**
     * 역경매현황 조회 (Sup)
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getReAuctionList(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "s2031", "CONNECTION","getReAuctionList", obj);
	
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private SepoaFormater getRaMinPrice(GridData gdReq, SepoaInfo info, String args1, String args2, String args3) throws Exception{
		
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
			
			header.put("ra_no"		, args1);                
			header.put("ra_count"	, args2);          
			header.put("vendor_code", args3);    
			
			Object[] obj = {header};
			
			value = ServiceConnector.doService(info, "s2031", "CONNECTION","getRaMinPrice", obj);
			
			if(value.flag){// 조회 성공
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
				
				sf= new SepoaFormater(value.result[0]);
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
		
		return sf;
	}   
	

	/**
	 * 입찰 (Sup)
	 * @param gdReq
	 * @param info
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setReAuctioncreate(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "s2031", "TRANSACTION", "setratbdins1_1",       obj);
    		
    		String[] tmp = value.result;
    		
//    		if(tmp != null && tmp.length > 0){
//    			for(int i = 0 ; i < tmp.length ; i++){
//    				
//    			}
//    		}
    		 
    		
    		if(value.flag) {
    			gdRes.addParam("rtnVal", value.result[0]);
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
	
//  	public void doQuery(WiseStream ws) throws Exception {
//  		
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//		
//		String mode = ws.getParam("mode");
//		String house_code = info.getSession("HOUSE_CODE");
//		
//		Logger.debug.println(info.getSession("ID"),this,"doQuery mode------------------>"+mode);
//	    		
//		
//		if(mode.equals("getratbdins1_2")) { //실시간 역경매 화면 조회
//			
//    		String ra_no	= ws.getParam("ra_no");
//    		String ra_count = ws.getParam("ra_count");
//    		String ra_seq	= ws.getParam("ra_seq");
//
//            String[] pData = {house_code , ra_no, ra_count,ra_seq};
//
//     		Object[] obj = {pData};
//    		
//    		WiseOut out = ServiceConnector.doService(info,"s2031","CONNECTION","getratbdins1_2",obj);
//    		
//    		WiseFormater wf = ws.getWiseFormater(out.result[0]);
//	    		
//			int cnt = wf.getRowCount();
//			
//			if(cnt == 0) { //데이타가 없는 경우
//	      			ws.setMessage("조회된 데이타가 없습니다.");
//			} 
//			else { //데이타가 있는 경우				
//				for(int i=0; i<cnt; i++) {
//					ws.addValue("vendor_name", 	wf.getValue(i, 0), ""); 
//					ws.addValue("vendor_code", 	wf.getValue(i, 1), "");
//					ws.addValue("bid_time", 	wf.getValue(i, 2), "");
//					ws.addValue("cur", 			wf.getValue(i, 3), "");
//					ws.addValue("bid_price", 	wf.getValue(i, 4), "");
//					ws.addValue("bid_qty", 		wf.getValue(i, 5), "");
//	    		}
//			}
//			ws.write();
//		}else if(mode.equals("getReAuctionList")){
//			house_code   = info.getSession("HOUSE_CODE");
//            
//            String ann_no		= ws.getParam("ann_no");
//            String ra_count		= ws.getParam("ra_count");
//
//			String[] pData = {house_code, ann_no, ra_count};
//
//            WiseOut out = getReAuctionList(info, pData);
//
//            WiseFormater wf = ws.getWiseFormater(out.result[0]);
//            
//            String[] obj = new String[1];
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
//			int cnt = wf.getRowCount();
//			if(cnt == 0) { //데이타가 없는 경우
//      		    ws.setCode("1");
//		    	ws.setMessage("조회된 데이타가 없습니다.");
//	            ws.write();
//
//		    	return;
//			}
//
//			int INDEX_SELECTED          	= ws.getColumnIndex("SELECTED");
//            int INDEX_ITEM_NO            	= ws.getColumnIndex("ITEM_NO");
//            int INDEX_DESCRIPTION_LOC       = ws.getColumnIndex("DESCRIPTION_LOC");
//            int INDEX_SPECIFICATION        	= ws.getColumnIndex("SPECIFICATION");
//            int INDEX_MAKER_NAME          	= ws.getColumnIndex("MAKER_NAME");
//            int INDEX_UNIT_MEASURE         	= ws.getColumnIndex("UNIT_MEASURE");
//            int INDEX_QTY               	= ws.getColumnIndex("QTY");
//            int INDEX_CUR         			= ws.getColumnIndex("CUR");
//            int INDEX_UNIT_PRICE     		= ws.getColumnIndex("UNIT_PRICE");
//            int INDEX_AMT     				= ws.getColumnIndex("AMT");
//            int INDEX_RA_SEQ     			= ws.getColumnIndex("RA_SEQ");
//            
//            for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
//				
//				String item_no          = wf.getValue("ITEM_NO", i);
//				String[] img_check  = {"true", ""};
//				String[] img_item_no =  {"", item_no, item_no};
//				
//				/*
//				 * 품목별 정보
//				 */
//				ws.addValue(	INDEX_SELECTED          ,img_check                        ,"");
//				ws.addValue(	INDEX_ITEM_NO           ,img_item_no                      ,"");
//				ws.addValue(	INDEX_DESCRIPTION_LOC   ,wf.getValue("DESCRIPTION_LOC" ,i),"");
//				ws.addValue(	INDEX_SPECIFICATION     ,wf.getValue("SPECIFICATION" ,i)  ,"");
//				ws.addValue(	INDEX_MAKER_NAME        ,wf.getValue("MAKER_NAME" ,i)     ,"");
//				ws.addValue(	INDEX_UNIT_MEASURE      ,wf.getValue("UNIT_MEASURE" ,i)   ,"");
//				ws.addValue(	INDEX_QTY               ,wf.getValue("QTY" ,i)            ,"");
//				ws.addValue(	INDEX_CUR               ,wf.getValue("CUR" ,i)            ,"");
//				
//				/*
//				 * 사용자 입력사항(단가, 합계)
//				 */
//				
//				String value_price 	= (wf.getValue("UNIT_PRICE" ,i)).equals("") ? "" : wf.getValue("UNIT_PRICE" ,i);
//				String value_amt 	= (wf.getValue("AMT" ,i)).equals("") ? "" : wf.getValue("AMT" ,i);
//				
//				ws.addValue(	INDEX_UNIT_PRICE        ,value_price     					  ,"");// 단가
//				ws.addValue(	INDEX_AMT     			,value_amt            					,"");// 합계
//				ws.addValue(	INDEX_RA_SEQ               ,wf.getValue("RA_SEQ" ,i)            ,"");//
//			}
//
//	       	ws.setCode("M001");
//	       	ws.setMessage("성공적으로 작업을 수행하였습니다.");
//	       	ws.write();
//		}
//		
//  	}
//
//  	public WiseOut getReAuctionList(WiseInfo info, String[] pData)
//    {
//  		
//    		Object[] args = {pData};
//
//    		WiseOut value = null;
//    		WiseRemote wr = null;
//
//    		String conType    = "CONNECTION";
//    		String nickName   = "s2031";
//    		String MethodName = "getReAuctionList";
//
//    		try {
//	      		wr = new wise.util.WiseRemote(nickName,conType,info);
//	      		value = wr.lookup(MethodName,args);
//    		}
//    		catch(Exception e) {
//	      		Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
//	      		Logger.dev.println(e.getMessage());
//    		}
//    		finally {
//	      		try{
//	        		wr.Release();
//	      		}catch(Exception e){
//	      			e.printStackTrace();
//	      		}
//    		}
//
//		return value;
//  	}
//  	
//	/**************************************************************************/
//   	public String checkNull(String value)    {
//        if(value == null || value.trim().equals(""))
//        	value = null;
//        
//          	return value;
//   	}
//   	
//   	public String getServerDate() {
//        java.util.Calendar svr_calendar = java.util.Calendar.getInstance();
//
//        svr_calendar.setTime(new java.util.Date());
//
//        return String.valueOf(svr_calendar.getTimeInMillis());
//    }
//   	
//   	public String getDBDate(String date_time) {
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
//   	
//   	
//    public void doData(WiseStream ws) throws Exception{
//        //session 정보를 가져온다.
//        WiseInfo info   = WiseSession.getAllValue(ws.getRequest());
//        WiseFormater wf = ws.getWiseFormater();
//        Logger.debug.println(info.getSession("ID"), this, "############################################################");
//
//
//        String house_code       = info.getSession("HOUSE_CODE");
//        String vendor_code      = info.getSession("COMPANY_CODE");
//        String user_id          = info.getSession("ID");
//        String name_loc         = info.getSession("NAME_LOC");
//        String name_eng         = info.getSession("NAME_ENG");
//
//        WiseOut value = null;
//        String mode = ws.getParam("mode");
//        Logger.debug.println(info.getSession("ID"), this,"mode=========>"+mode );
//
//        String company_code 	= ws.getParam("company_code");
//        String ra_no		    = ws.getParam("ra_no");
//       	String ra_count		    = ws.getParam("ra_count");
//       	String cur		        = ws.getParam("cur");
//       	String bid_flag		    = ws.getParam("bid_flag");
//    	String bid_price	    = ws.getParam("bid_price");//입찰가
//    	
//    	String count_day 		= ws.getParam("count_day");
//    	String count_hh 		= ws.getParam("count_hh");
//    	String count_mi 		= ws.getParam("count_mi");
//    	String count_ss 		= ws.getParam("count_ss");
//    	
//    	company_code            = checkNull(company_code);
//    	ra_no            		= checkNull(ra_no);
//    	ra_count            	= checkNull(ra_count);
//    	cur            			= checkNull(cur);
//    	bid_flag            	= checkNull(bid_flag);
//    	bid_price            	= checkNull(bid_price);
//    	
//    	count_day            	= checkNull(count_day);
//    	count_hh            	= checkNull(count_hh);
//    	count_mi            	= checkNull(count_mi);
//    	count_ss            	= checkNull(count_ss);
//       
//    	if(mode.equals("setReAuctioncreate")){
//    	String[] RA_SEQ     = wf.getValue("RA_SEQ");
//    	String[] QTY        = wf.getValue("QTY");
//    	String[] UNIT_PRICE = wf.getValue("UNIT_PRICE");
//    	String[] AMT        = wf.getValue("AMT");
//            
//        String dataRABD[][] = new String[wf.getRowCount()][];
//        
//        String[] pData = {house_code, ra_no, ra_count, bid_price, bid_flag, count_day, count_hh, count_mi, count_ss};
//    	
//
//            for (int i = 0; i < wf.getRowCount(); i++) {
//                String tmp_data[] = {
//                		house_code,
//                		vendor_code,
//                		ra_no,
//                		ra_count,
//                		RA_SEQ[i],
//                		house_code,
//                		vendor_code,
//                		ra_no,
//                		ra_count,
//                		company_code,
//                		user_id,
//                		name_loc,
//                		name_eng,
//                		user_id,
//                		name_loc,
//                		name_eng,
//                		cur,
//                		"N",
//                		RA_SEQ[i],
//                        UNIT_PRICE[i],
//                        AMT[i],
//                        QTY[i]
//                };
//                dataRABD[i] = tmp_data;
//            }
//
//             value = setReAuctioncreate(info, dataRABD, pData);
//             //ws.setMessage(value.message);
//             ws.setMessage(value.result[0]);
//    	}
//    	try{
//	        Logger.debug.println(info.getSession("ID"), this, "status===================================>"+String.valueOf(value.status));
//	        ws.write();
//    	}catch(NullPointerException ne){
//			ne.printStackTrace();
//		}
//    }
//
//	public WiseOut setReAuctioncreate(WiseInfo info, String [][]dataRABD, String [] pData) {
//	    String nickName= "s2031";
//	    String conType = "TRANSACTION";
//	    String MethodName = "setratbdins1_1";
//	
//	    WiseOut value = null; 
//		WiseRemote wr = null;
//	
//		Object[] obj = {pData, dataRABD};
//
//	    try {
//	        wr = new wise.util.WiseRemote(nickName, conType, info);
//	        value = wr.lookup(MethodName,obj);
//	        
//	        Logger.debug.println(info.getSession("ID"),this," value.result[0]====>"+value.result[0]);
//			Logger.debug.println(info.getSession("ID"),this," value.status====>"+value.status);
//			
//	    } catch(Exception e) {
//	    	try{
//		    	Logger.err.println("test1 err = " + e.getMessage());
//				Logger.err.println("message = " + value.message);	
//				Logger.err.println("status = " + value.status);	    		
//	    	}catch(NullPointerException ne){
//				ne.printStackTrace();
//			}
//	    } finally{
//	        try {
//	            wr.Release();
//	        } catch(Exception e){
//	        	e.printStackTrace();
//	        }
//	    }
//	
//	    return value;
//	}

	/**************************************************************************/ 
}
