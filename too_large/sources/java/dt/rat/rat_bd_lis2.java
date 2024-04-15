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

/**************************************************
 *역경매관리>역경매>역경매결과
 *JUN.S.K
 *************************************************/
public class rat_bd_lis2 extends HttpServlet {


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
    		
    		if("getratbdlis2_1".equals(mode)){ // 역경매결과 조회
    			gdRes = this.getratbdlis2_1(gdReq, info);
    		}
    		else if("setCancelBid".equals(mode)){ // 역경매공고 삭제
    			gdRes = this.setCancelBid(gdReq, info);
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
	private GridData getratbdlis2_1(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "p1008", "CONNECTION","getratbdlis2_1", obj);
	
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
    private GridData setCancelBid(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p1008", "TRANSACTION", "setCancelBid",       obj);
    		
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
    
//
//	public void doQuery(WiseStream ws) throws Exception {
//       		//get session
//       	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//       	Message msg = new Message("KO","p1008");
//
//		String mode = ws.getParam("mode");
//
//		double abc = 10000000;
//		if(mode.equals("getratbdlis2_1")) { //역경매결과조회
//            String house_code   = info.getSession("HOUSE_CODE");
//	       	String from_date	= ws.getParam("from_date");
//	       	String to_date		= ws.getParam("to_date");
//	       	String ann_no		= ws.getParam("ann_no");
//	       	String bid_flag     = ws.getParam("bid_flag");
//            String CHANGE_USER_NAME     = ws.getParam("CHANGE_USER_NAME");
//
//	       	String[] pData = {house_code, bid_flag, from_date, to_date, ann_no, house_code, CHANGE_USER_NAME};
//
//			WiseOut rtn = getratbdlis2_1(info, pData);
//
//	        WiseFormater wf = ws.getWiseFormater(rtn.result[0]);
//
//	        if(wf == null) { //데이타 포맷이 정확하지 않을경우
//	        	msg.getMessage("0001");
//	       		ws.setMessage("데이타 포맷이 정확하지 않습니다.");
//	       		ws.write();
//
//	    	    return;
//	        }
//
//	   	    if(wf.getRowCount() == 0) { //데이타가 없는 경우
//				ws.setCode("M001");
//				ws.setMessage("조회된 데이타가 없습니다.");
//		        ws.write();
//
//				return;
//	      	}
//
//	   	    int INDEX_SELECTED          = ws.getColumnIndex("SELECTED");
//	   	    int INDEX_ANN_NO            = ws.getColumnIndex("ANN_NO");
//            int INDEX_SUBJECT           = ws.getColumnIndex("SUBJECT");
//            int INDEX_ATTACH_NO         = ws.getColumnIndex("ATTACH_NO");
//            int INDEX_END_DATETIME      = ws.getColumnIndex("END_DATETIME");
//            int INDEX_BID_COUNT         = ws.getColumnIndex("BID_COUNT");
//            int INDEX_SETTLE_FLAG       = ws.getColumnIndex("SETTLE_FLAG");
//            int INDEX_NAME_LOC          = ws.getColumnIndex("NAME_LOC");
//            int INDEX_CURRENT_PRICE     = ws.getColumnIndex("CURRENT_PRICE");
//            int INDEX_RESERVE_PRICE     = ws.getColumnIndex("RESERVE_PRICE");
//            int INDEX_BID_PRICE         = ws.getColumnIndex("BID_PRICE");
//            int INDEX_PR_NO             = ws.getColumnIndex("PR_NO");
//            int INDEX_RA_NO             = ws.getColumnIndex("RA_NO");
//            int INDEX_RA_COUNT          = ws.getColumnIndex("RA_COUNT");
//            int INDEX_VENDOR_CODE       = ws.getColumnIndex("VENDOR_CODE");
//            int INDEX_NB_REASON       	= ws.getColumnIndex("NB_REASON");
//            int INDEX_PRINT_NO       	= ws.getColumnIndex("PRINT_NO");
//            int INDEX_SETTLE_HIDDEN_FLAG= ws.getColumnIndex("SETTLE_HIDDEN_FLAG");
//            int INDEX_PROCEEDING_FLAG	= ws.getColumnIndex("PROCEEDING_FLAG");
//
//			for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
//				String ls_ann_no         = wf.getValue("ANN_NO", i);
//				String ls_subject        = wf.getValue("SUBJECT", i);
//				String ls_pr_no          = wf.getValue("PR_NO", i);
//				String attach_no         = wf.getValue("ATTACH_NO", i);
//				String attach_count      = wf.getValue("ATTACH_COUNT", i);
//				String bid_count         = wf.getValue("BID_COUNT" ,i);
//				String name_loc          = wf.getValue("NAME_LOC" ,i);
//
//                String image_ATTACH      = "/kr/images/button/query.gif";
//                String image_print_no	 = "/kr/images/button/detail.gif";
//
//				String[] img_check     =  {"false", ""};
//				String[] img_ann_no    =  {"", ls_ann_no, ls_ann_no};
//				String[] img_subject   =  {"", ls_subject, ls_subject};
//				String[] img_bid_count =  {"", bid_count, bid_count};
//				String[] img_pr_no     =  {"", ls_pr_no, ls_pr_no};
//				String[] img_name_loc  =  {"", name_loc, name_loc};
//				String[] img_print_no  =  {image_print_no,"",""};
//
//    	        if ("0".equals(attach_count)) {
//    	            image_ATTACH    = "";
//	                attach_count    = "";
//	                attach_no       = "";
//	            }
//				String[] img_attach_no  =  {image_ATTACH, attach_count, attach_no};
//
//				ws.addValue(INDEX_SELECTED           ,img_check                             	,"");
//				ws.addValue(INDEX_ANN_NO             ,img_ann_no                             	,"");
//				ws.addValue(INDEX_SUBJECT            ,img_subject                            	,"");
//				ws.addValue(INDEX_ATTACH_NO          ,img_attach_no                          	,"");
//				ws.addValue(INDEX_END_DATETIME       ,wf.getValue("END_DATETIME" 		,i)     ,"");
//				ws.addValue(INDEX_BID_COUNT          ,img_bid_count                          	,"");
//				ws.addValue(INDEX_SETTLE_FLAG        ,wf.getValue("SETTLE_FLAG" 		,i)     ,"");
//				ws.addValue(INDEX_NAME_LOC           ,img_name_loc             					,"");
//				ws.addValue(INDEX_CURRENT_PRICE      ,wf.getValue("CURRENT_PRICE" 		,i)     ,"");
//				ws.addValue(INDEX_RESERVE_PRICE      ,wf.getValue("RESERVE_PRICE" 		,i)     ,"");
//				ws.addValue(INDEX_BID_PRICE          ,wf.getValue("BID_PRICE" 			,i)     ,"");
//				ws.addValue(INDEX_PR_NO              ,img_pr_no                              	,"");
//				ws.addValue(INDEX_RA_NO              ,wf.getValue("RA_NO" 				,i)     ,"");
//				ws.addValue(INDEX_RA_COUNT           ,wf.getValue("RA_COUNT" 			,i)     ,"");
//				ws.addValue(INDEX_VENDOR_CODE        ,wf.getValue("VENDOR_CODE" 		,i)     ,"");
//				ws.addValue(INDEX_NB_REASON        	 ,wf.getValue("NB_REASON" 			,i)     ,"");
//				ws.addValue(INDEX_PRINT_NO        	 ,img_print_no          					,"");
//				ws.addValue(INDEX_SETTLE_HIDDEN_FLAG ,wf.getValue("SETTLE_HIDDEN_FLAG" 	,i)     ,"");
//				ws.addValue(INDEX_PROCEEDING_FLAG 	 ,wf.getValue("PROCEEDING_FLAG" 	,i)     ,"");
//			}
//
//	       	ws.setCode("M001");
//	       	ws.setMessage("성공적으로 작업을 수행하였습니다..");
//	       	ws.write();
//		}
//
//   	}
//
//
//   	     //null 이나 "" 를 null로 바꾸어준다.
//	 	public String checkNull(String value) {
//	        if(value == null || value.trim().equals(""))
//	        	value = null;
//	        
//          return value;
//     	}                     
//
//       	public WiseOut getratbdlis2_1(WiseInfo info, String[] pData) {
//       		Object[] args = { pData };
//
//       		WiseOut rtn = null;
//       		WiseRemote wr = null;
//
//       		String nickName = "p1008";
//       		String MethodName = "getratbdlis2_1";
//       		String conType = "CONNECTION";
//
//       		try {
//           		wr = new WiseRemote(nickName, conType, info);
//
//       			rtn = wr.lookup(MethodName, args);
//       		}catch(Exception e) {
//           		Logger.dev.println(info.getSession("ID"), this, "Servlet===>getratbdlis2_1 Exceptioin =====> " + e.getMessage());
//       		}finally{
//			wr.Release();
//       		}
//
//       		return rtn;
//	}
///**********************************************************************************************************************************/
//
///**********************************************************************************************************************************/
//   	public void doData(WiseStream ws) throws Exception {
//		//get session
//		WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//
//		//get Parameter
//		String mode = ws.getParam("mode");
//		WiseFormater wf = ws.getWiseFormater();
//
//		Logger.debug.println(info.getSession("ID"),this,"doData mode------------------>"+mode);
//
//		//청구복구
//   		if(mode.equals("setratbdlis2_1")) {
//
//
//			//저장/전송
//			String[] ra_no		= wf.getValue("RA_NO");
//			String[] ra_count	= wf.getValue("RA_COUNT");
//			String[] ra_seq		= wf.getValue("RA_SEQ");
//			String[] pr_no		= wf.getValue("PR_NO");
//			String[] pr_seq		= wf.getValue("PR_SEQ");
//
//
//			String[][] setData = new String[wf.getRowCount()][];
//			for( int i=0; i < wf.getRowCount(); i++)
//			{
//
//				String[] Data = {	ra_no[i],
//							ra_count[i],
//							ra_seq[i],
//							pr_no[i],
//							pr_seq[i]
//						};
//
//				setData[i] = Data;
//			};
//
//   			WiseOut out = setratbdlis2_1(info, setData);
//
//	    		String[] obj = new String[1];
//	    		obj[0] = out.message;
//
//	    		Logger.debug.println(info.getSession("ID"),this,"Message------------------>"+out.message);
//	    		Logger.debug.println(info.getSession("ID"),this,"Status------------------>"+out.status);
//
//	    		ws.setUserObject(obj);
//	    		ws.setCode(String.valueOf(out.status));
//       			ws.setMessage("");
//	    		ws.write();
//
//   		}
//   		//결재요청
//   		else if(mode.equals("setratbdlis2_2")) {
//
//			String APPROVALSTR	= ws.getParam("APPROVALSTR");
//
//			//저장/전송
//			String[] ra_no 		= wf.getValue("RA_NO");
//			String[] ra_count 	= wf.getValue("RA_COUNT");
//			String[] ra_seq 	= wf.getValue("RA_SEQ");
//			String[] vendor_code= wf.getValue("VENDOR_CODE");
//			String[] bid_qty 	= wf.getValue("BID_QTY");
//			String[] bid_price 	= wf.getValue("BID_PRICE");
//			String[] cur 		= wf.getValue("CUR");
//			String[] shipper_type 	= wf.getValue("SHIPPER_TYPE");
//
//
//
//			String[][] setData = new String[wf.getRowCount()][];
//			
//			for( int i=0; i < wf.getRowCount(); i++)
//			{
//
//				String[] Data = {	ra_no[i],
//									ra_count[i],
//									ra_seq[i],
//									vendor_code[i],
//									bid_qty[i],
//									bid_price[i],
//									cur[i],
//									shipper_type[i],
//									APPROVALSTR};
//
//				setData[i] = Data;
//			};
//
//   			WiseOut out = setratbdlis2_2(info, setData);
//
//	    		String[] obj = new String[1];
//	    		obj[0] = out.message;
//
//	    		Logger.debug.println(info.getSession("ID"),this,"Message------------------>"+out.message);
//	    		Logger.debug.println(info.getSession("ID"),this,"Status------------------>"+out.status);
//
//	    		ws.setUserObject(obj);
//	    		ws.setCode(String.valueOf(out.status));
//       			ws.setMessage("");
//	    		ws.write();
//
//   		}else if(mode.equals("setCancelBid")){
//   			
//   			WiseOut value = null;
//   			String house_code       = info.getSession("HOUSE_CODE");
//   	        String company_code     = info.getSession("COMPANY_CODE");
//   	        String user_id          = info.getSession("ID");
//   	        String name_loc         = info.getSession("NAME_LOC");
//   	        String name_eng         = info.getSession("NAME_ENG");
//   	        String department       = info.getSession("DEPARTMENT");
//   			
//   			String[] RA_NO = wf.getValue("RA_NO");
//   			String[] RA_COUNT = wf.getValue("RA_COUNT");
//   			String[] VENDOR_CODE = wf.getValue("VENDOR_CODE");
//   			String[] NB_REASON   = wf.getValue("NB_REASON");
//
//   			String[] sendPRDT = {"AR" ,house_code ,RA_NO[0], RA_COUNT[0]};
//
//            String[][] dataRAHD = {{ "P" ,user_id ,name_loc ,name_eng ,department,NB_REASON[0],house_code ,RA_NO[0] ,RA_COUNT[0]}};
//
//            String[][] dataRADT = {{ "P" ,user_id ,name_loc ,name_eng ,department,house_code ,RA_NO[0] ,RA_COUNT[0]}};
//
//            String[][] dataRABD = {{"N" ,house_code,VENDOR_CODE[0], RA_NO[0] ,RA_COUNT[0]}};
//           
//            value = setCancelBid(info, sendPRDT, dataRAHD, dataRADT, dataRABD);
//            ws.setMessage(value.message);
//            Logger.debug.println(info.getSession("ID"), this, "===============AVENGER KIM================="+value.message);  
//            ws.write();
//   		}
//	}
//
//   	/*
//   	 * 낙찰 취소 -- 낙찰 바로 전단계로 돌아감~ PRDT BID_STATUS  SB -> AR
//   	 *                                    RAHD RA_FLAG C -> P
//   	 *                                    RADT SETTLE_FLAG Y -> P, PR_PROCEEDING_FLAG E --> C
//   	 *                                    RABD SETTLE_FLAG Y -> N
//   	 */
//   	public WiseOut setCancelBid(WiseInfo info, String[] sendPRDT, String[][] dataRAHD, String[][] dataRADT, String[][] dataRABD) {
//        String nickName= "p1008";
//        String conType = "TRANSACTION";
//        String MethodName = "setCancelBid";
//        WiseOut value = null;
//        WiseRemote wr = null;
//
//        Object[] obj_save = {sendPRDT, dataRAHD, dataRADT, dataRABD};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,obj_save);
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
//   	
//   	//청구복구
//       	public WiseOut setratbdlis2_1(WiseInfo info, String[][] pData) {
//
//       		Object[] args = { pData	};
//
//       		WiseOut rtn = null;
//       		WiseRemote wr = null;
//
//
//       		String nickName = "p1008";
//       		String MethodName = "setratbdlis2_1";
//       		String conType = "TRANSACTION";
//
//       		try {
//           		wr = new WiseRemote(nickName, conType, info);
//
//       			rtn = wr.lookup(MethodName, args);
//
//       		}catch(Exception e) {
//       			try{
//           			Logger.dev.println(info.getSession("ID"), this, "rtn.status=========********>" + rtn.status);
//           			Logger.dev.println(info.getSession("ID"), this, "rtn.message========********>" + rtn.message);
//               		Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());      				
//       			}catch(NullPointerException ne){
//       				ne.printStackTrace();
//       			}
//       		}finally{
//			wr.Release();
//       		}
//
//       		return rtn;
//	}
//
//
//	//결재요청
//       	public WiseOut setratbdlis2_2(WiseInfo info, String[][] setData) {
//
//       		Object[] args = { setData };
//
//       		WiseOut rtn = null;
//       		WiseRemote wr = null;
//
//
//       		String nickName = "p1008";
//       		String MethodName = "setratbdlis2_2";
//       		String conType = "TRANSACTION";
//
//       		try {
//           		wr = new WiseRemote(nickName, conType, info);
//
//       			rtn = wr.lookup(MethodName, args);
//
//       		}catch(Exception e) {
//       			try{
//           			Logger.dev.println(info.getSession("ID"), this, "rtn.status=========********>" + rtn.status);
//           			Logger.dev.println(info.getSession("ID"), this, "rtn.message========********>" + rtn.message);
//               		Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());      				
//       			}catch(NullPointerException ne){
//       				ne.printStackTrace();
//       			}
//       		}finally{
//			wr.Release();
//       		}
//
//       		return rtn;
//	}



}
/*******************************************************************************************************************************
                                                       END OF File
*********************************************************************************************************************************/