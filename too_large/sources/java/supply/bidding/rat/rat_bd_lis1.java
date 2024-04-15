package supply.bidding.rat;

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

/**************************************************
 *BIDDING>역경매관리>역경매현황
 *JUN.S.K
 *************************************************/
public class rat_bd_lis1 extends HttpServlet {
	
	
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
    		
    		if("getratbdlis1_1".equals(mode)){ // 역경매현황
    			gdRes = this.getratbdlis1_1(gdReq, info);
    		}
    		else if("setJoinVendorReg".equals(mode)){ // 역경매공고 삭제
    			gdRes = this.setJoinVendorReg(gdReq, info);
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
    
    /**
     * 역경매현황 조회 (Sup)
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getratbdlis1_1(GridData gdReq, SepoaInfo info) throws Exception{
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
	    	
	    	header.put( "from_date ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "from_date ".trim(), "" ) ) );
	    	header.put( "to_date   ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "to_date   ".trim(), "" ) ) );
	
	    	gdRes.addParam("mode", "query");
	
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "s2031", "CONNECTION","getratbdlis1_1", obj);
	
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
	
	/**
	 * 역경매 참가신청 (Sup)
	 * @param gdReq
	 * @param info
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setJoinVendorReg(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "s2031", "TRANSACTION", "setVendorReg",       obj);
    		
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
	

//  	public void doQuery(WiseStream ws) throws Exception {
//
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//
//		String mode = ws.getParam("mode");
//
//		Logger.debug.println(info.getSession("ID"),this,"doQuery mode------------------>"+mode);
//
//
//		if(mode.equals("getratbdlis1_1")) { //역경매현황조회
//            String house_code   = info.getSession("HOUSE_CODE");
//            String vendor_code  = info.getSession("COMPANY_CODE");
//
//            String from_date	= ws.getParam("from_date");
//            String to_date	    = ws.getParam("to_date");
//            String ann_no		= ws.getParam("ann_no");
//
//			String[] pData = {house_code, from_date, to_date, ann_no};
//
//            WiseOut out = getratbdlis1_1(info, pData);
//
//            WiseFormater wf = ws.getWiseFormater(out.result[0]);
//
//   			String[] obj = new String[1];
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
//            int INDEX_SELECTED          = ws.getColumnIndex("SELECTED");
//            int INDEX_ANN_NO            = ws.getColumnIndex("ANN_NO");
//            int INDEX_SUBJECT           = ws.getColumnIndex("SUBJECT");
//            int INDEX_START_TEXT        = ws.getColumnIndex("START_TEXT");
//            int INDEX_END_TEXT          = ws.getColumnIndex("END_TEXT");
//            int INDEX_BID_COUNT         = ws.getColumnIndex("BID_COUNT");
//            int INDEX_CUR               = ws.getColumnIndex("CUR");
//            int INDEX_BID_PRICE         = ws.getColumnIndex("BID_PRICE");
//            int INDEX_CURRENT_PRICE     = ws.getColumnIndex("CURRENT_PRICE");
//            int INDEX_RESERVE_PRICE     = ws.getColumnIndex("RESERVE_PRICE");
//            int INDEX_RA_NO             = ws.getColumnIndex("RA_NO");
//            int INDEX_RA_COUNT          = ws.getColumnIndex("RA_COUNT");
//            int INDEX_STATUS            = ws.getColumnIndex("STATUS");
//            int INDEX_START_DATETIME    = ws.getColumnIndex("START_DATETIME");
//            int INDEX_END_DATETIME      = ws.getColumnIndex("END_DATETIME");
//            int INDEX_ATTACH_NO         = ws.getColumnIndex("ATTACH_NO");
//            int INDEX_IRS_NO            = ws.getColumnIndex("IRS_NO");
//            int INDEX_RA_FLAG           = ws.getColumnIndex("RA_FLAG");
//            int INDEX_JOIN_FLAG         = ws.getColumnIndex("JOIN_FLAG");
//            int INDEX_REG_FLAG         = ws.getColumnIndex("REG_FLAG");
//            
//            int INDEX_RA_TYPE1          = ws.getColumnIndex("RA_TYPE1");
//            int INDEX_CHANGE_USER_ID    = ws.getColumnIndex("CHANGE_USER_ID");
//            
//            int INDEX_OPEN_REQ_FROM_DATE = ws.getColumnIndex("OPEN_REQ_FROM_DATE");
//            int INDEX_OPEN_REQ_TO_DATE = ws.getColumnIndex("OPEN_REQ_TO_DATE");
//
//			for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
//				String ls_ann_no          = wf.getValue("ANN_NO", i);
//				String attach_no          = wf.getValue("ATTACH_NO", i);
//				String attach_count       = wf.getValue("ATTACH_COUNT", i);
//				
//
//                String image_ATTACH      = "/kr/images/button/query.gif";
//
//				String[] img_check  = {"false", ""};
//				String[] img_ann_no =  {"", ls_ann_no, ls_ann_no};
//				
//
//    	        if (attach_count.equals("0")) {
//    	            image_ATTACH    = "";
//	                attach_count    = "";
//	                attach_no       = "";
//	            }
//				String[] img_attach_no  =  {image_ATTACH, attach_count, attach_no};
//
//				ws.addValue(INDEX_SELECTED          ,img_check                              ,"");//선택
//				ws.addValue(INDEX_ANN_NO            ,img_ann_no                             ,"");//
//				ws.addValue(INDEX_SUBJECT           ,wf.getValue("SUBJECT" ,i)              ,"");//
//				ws.addValue(INDEX_ATTACH_NO         ,img_attach_no                          ,"");//
//				ws.addValue(INDEX_START_TEXT        ,wf.getValue("START_TEXT" ,i)           ,"");//
//				ws.addValue(INDEX_END_TEXT          ,wf.getValue("END_TEXT" ,i)             ,"");//
//				ws.addValue(INDEX_BID_COUNT         ,wf.getValue("BID_COUNT" ,i)            ,"");//
//				ws.addValue(INDEX_CUR               ,wf.getValue("CUR" ,i)                  ,"");//
//				ws.addValue(INDEX_BID_PRICE         ,wf.getValue("BID_PRICE" ,i)            ,"");//
//				ws.addValue(INDEX_CURRENT_PRICE     ,wf.getValue("CURRENT_PRICE" ,i)        ,"");//
//				ws.addValue(INDEX_RESERVE_PRICE     ,wf.getValue("RESERVE_PRICE" ,i)        ,"");//
//				ws.addValue(INDEX_RA_NO             ,wf.getValue("RA_NO" ,i)                ,"");//
//				ws.addValue(INDEX_RA_COUNT          ,wf.getValue("RA_COUNT" ,i)             ,"");//
//				ws.addValue(INDEX_STATUS            ,wf.getValue("STATUS" ,i)               ,"");//
//				ws.addValue(INDEX_START_DATETIME    ,wf.getValue("START_DATETIME" ,i)       ,"");//
//                ws.addValue(INDEX_END_DATETIME      ,wf.getValue("END_DATETIME" ,i)         ,"");//
//                ws.addValue(INDEX_IRS_NO            ,wf.getValue("IRS_NO" ,i)               ,"");//
//                ws.addValue(INDEX_RA_FLAG           ,wf.getValue("RA_FLAG" ,i)              ,"");//
//                ws.addValue(INDEX_JOIN_FLAG           ,wf.getValue("JOIN_FLAG" ,i)          ,"");//
//                ws.addValue(INDEX_REG_FLAG           ,"".equals(wf.getValue("REG_FLAG" ,i)) ? "N" :  wf.getValue("REG_FLAG" ,i) ,"");//
//                
//                ws.addValue(INDEX_RA_TYPE1           ,wf.getValue("RA_TYPE1" ,i)          ,"");//
//                ws.addValue(INDEX_CHANGE_USER_ID           ,wf.getValue("CHANGE_USER_ID" ,i)          ,"");//
//                
//                ws.addValue(INDEX_OPEN_REQ_FROM_DATE           ,wf.getValue("OPEN_REQ_FROM_DATE" ,i)          ,"");//
//                ws.addValue(INDEX_OPEN_REQ_TO_DATE           ,wf.getValue("OPEN_REQ_TO_DATE" ,i)          ,"");//
//                
//                
//			}
//
//	       	ws.setCode("M001");
//	       	ws.setMessage("성공적으로 작업을 수행하였습니다..");
//	       	ws.write();
//		
//		
//		
//		
//		}else if(mode.equals("getReAuctionList")){
//			String house_code   = info.getSession("HOUSE_CODE");
//            
//            String ann_no		= ws.getParam("ann_no");
//            String ra_count		= ws.getParam("ra_count");
//            
//
//			String[] pData = {house_code, ann_no, ra_count};
//
//            WiseOut out = getReAuctionList(info, pData);
//
//            WiseFormater wf = ws.getWiseFormater(out.result[0]);
//
//   			/*
//            String[] obj = new String[1];
//   			
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
//			*/
//			int cnt = wf.getRowCount();
//			if(cnt == 0) { //데이타가 없는 경우
//      		    ws.setCode("1");
//		    	ws.setMessage("조회된 데이타가 없습니다.");
//	            ws.write();
//
//		    	return;
//			}
//			
//			
//            int INDEX_SELECTED          = ws.getColumnIndex("SELECTED");
//            int INDEX_ITEM_NO            = ws.getColumnIndex("ITEM_NO");
//            int INDEX_DESCRIPTION_LOC           = ws.getColumnIndex("DESCRIPTION_LOC");
//            int INDEX_SPECIFICATION        = ws.getColumnIndex("SPECIFICATION");
//            int INDEX_MAKER_NAME          = ws.getColumnIndex("MAKER_NAME");
//            int INDEX_UNIT_MEASURE         = ws.getColumnIndex("UNIT_MEASURE");
//            int INDEX_QTY               = ws.getColumnIndex("QTY");
//            int INDEX_CUR         = ws.getColumnIndex("CUR");
//            int INDEX_UNIT_PRICE     = ws.getColumnIndex("UNIT_PRICE");
//            int INDEX_AMT     = ws.getColumnIndex("AMT");
//            int INDEX_RA_SEQ     = ws.getColumnIndex("RA_SEQ");
//            
//
//			
//            
//            
//            for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
//				/*
//				String ls_ann_no          = wf.getValue("ITEM_NO", i);
//				String attach_no          = wf.getValue("ATTACH_NO", i);
//				String attach_count       = wf.getValue("ATTACH_COUNT", i);
//
//                String image_ATTACH      = "/kr/images/button/icon_con_gla.gif";
//
//				
//				String[] img_ann_no =  {"", ls_ann_no, ls_ann_no};
//
//    	        if (attach_count.equals("0")) {
//    	            image_ATTACH    = "";
//	                attach_count    = "";
//	                attach_no       = "";
//	            }
//	            String[] img_attach_no  =  {image_ATTACH, attach_count, attach_no};
//	            
//	            */
//				String item_no          = wf.getValue("ITEM_NO", i);
//				
//				String[] img_check  = {"true", ""};
//				
//				String[] img_item_no =  {"", item_no, item_no};
//				
//				/*
//				 * 품목별 정보
//				 */
//				ws.addValue(	INDEX_SELECTED          ,img_check                        ,"");//선택
//				ws.addValue(	INDEX_ITEM_NO           ,img_item_no                      ,"");//
//				ws.addValue(	INDEX_DESCRIPTION_LOC   ,wf.getValue("DESCRIPTION_LOC" ,i),"");//
//				ws.addValue(	INDEX_SPECIFICATION     ,wf.getValue("SPECIFICATION" ,i)  ,"");//
//				ws.addValue(	INDEX_MAKER_NAME        ,wf.getValue("MAKER_NAME" ,i)     ,"");//
//				ws.addValue(	INDEX_UNIT_MEASURE      ,wf.getValue("UNIT_MEASURE" ,i)   ,"");//
//				ws.addValue(	INDEX_QTY               ,wf.getValue("QTY" ,i)            ,"");//
//				ws.addValue(	INDEX_CUR               ,wf.getValue("CUR" ,i)            ,"");//
//				/*
//				 * 사용자 입력사항(단가, 합계)
//				 */
//				if("".equals(wf.getValue("UNIT_PRICE" ,i))){
//					ws.addValue(	INDEX_UNIT_PRICE        ,""     					  ,"");// 단가
//				}else{
//					ws.addValue(	INDEX_UNIT_PRICE        ,wf.getValue("UNIT_PRICE" ,i) ,"");// 단가
//				}
//				
//				if("".equals(wf.getValue("AMT" ,i))){
//					ws.addValue(	INDEX_AMT     			,""            					,"");// 합계
//				}else{
//					ws.addValue(	INDEX_AMT        ,wf.getValue("AMT" ,i)		  		    ,"");// 합계
//				}
//				ws.addValue(	INDEX_RA_SEQ               ,wf.getValue("RA_SEQ" ,i)            ,"");//
//				
//			}
//
//	       	ws.setCode("M001");
//	       	ws.setMessage("성공적으로 작업을 수행하였습니다..");
//	       	ws.write();
//		}
//  	}
//  	
//  	public void doData(WiseStream ws) throws Exception{
//        //session 정보를 가져온다.
//        WiseInfo info	= WiseSession.getAllValue(ws.getRequest());
//        WiseFormater wf	= ws.getWiseFormater();
//        String HOUSE_CODE = info.getSession("HOUSE_CODE");
//        
//        WiseOut value = null;
//        String mode = ws.getParam("mode");
//        Logger.debug.println(info.getSession("ID"), this,"mode=========>"+mode );
//        
//        String VENDOR_CODE = ws.getParam("VENDOR_CODE");
//        
//        if(mode.equals("setJoinVendorReg")) {  // 참가여부등록
//        	String[] RA_NO             		= wf.getValue("RA_NO");
//            String[] VOTE_COUNT         	= wf.getValue("RA_COUNT");
//            String[] RA_TYPE1     			= wf.getValue("RA_TYPE1");
//            String[] CHANGE_USER_ID     	= wf.getValue("CHANGE_USER_ID");
//            
//            String REG_FLAG 				= "Y"; // 참가신청여부
//            String setRQSE[][] = new String[wf.getRowCount()][];
//
//            for (int i = 0; i<wf.getRowCount(); i++) {
//
//                String tmp_RQSE[] = {
//   					 				 "",
//   					 				 REG_FLAG,
//   					 				 HOUSE_CODE,
//                					 "LIGS", //COMPANY_CODE
//                					 RA_NO[i],                					 
//                					 VOTE_COUNT[i] ,
//                					 CHANGE_USER_ID[i] ,
//                					 VENDOR_CODE,
//                                    };
//
//                setRQSE[i] = tmp_RQSE;
//            }
//            
//            value = setJoinVendorReg(info, setRQSE,RA_TYPE1[0]);
//            
//        }
//        try{
//	        ws.setCode(String.valueOf(value.status));
//	        ws.setMessage(value.message);
//	
//	        ws.write();
//        }catch(NullPointerException ne){
//			ne.printStackTrace();
//		}
//    }
//
//    public WiseOut setJoinVendorReg(WiseInfo info, String[][] setRQSE, String RA_TYPE) {
//        String nickName= "s2031";
//        String conType = "TRANSACTION";
//        String MethodName = "setVendorReg";
//
//        WiseOut value = null;
//        WiseRemote wr = null;
//
//        Object[] args = {setRQSE, RA_TYPE};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,args);
//        } catch(Exception e) {
//        	try{
//                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
//                Logger.err.println("status = " + value.status + "  message = " + value.message);        		
//        	}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
//        } finally{
//            try {
//                wr.Release();
//            } catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return value;
//    }
//    
//  	public WiseOut getratbdlis1_1(WiseInfo info, String[] pData)
//    {
//    		Object[] args = {pData};
//
//    		WiseOut value = null;
//    		WiseRemote wr = null;
//
//    		String conType    = "CONNECTION";
//    		String nickName   = "s2031";
//    		String MethodName = "getratbdlis1_1";
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
//  	public WiseOut getReAuctionList(WiseInfo info, String[] pData)
//    {
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
//  	
//
//	public String checkNull(String value) {
//        if(value == null || value.trim().equals(""))
//        	value = null;
//        
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

}
