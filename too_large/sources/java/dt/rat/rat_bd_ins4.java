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

public class rat_bd_ins4 extends HttpServlet {

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
    		
    		if("gstRatTableData".equals(mode)){ // 참가업체 조회
    			gdRes = this.gstRatTableData(gdReq, info);
    		}
    		else if("setratbdins4_1".equals(mode)){ // 낙찰
    			gdRes = this.setratbdins4_1(gdReq, info);
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
	private GridData gstRatTableData(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "p1008", "CONNECTION","gstRatTableData", obj);
	
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
    private GridData setratbdins4_1(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p1008", "TRANSACTION", "setratbdins4_1",       obj);
    		
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
//    public void doQuery(WiseStream ws) throws Exception {
//        //get session
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        Message msg = new Message("KO","p1008");
//
//        String mode = ws.getParam("mode");
//
//        Logger.debug.println(info.getSession("ID"),this,"mode------------------>"+mode);

/**
 *역경매관리>역경매현황> 역경매 개찰 LOAD시 자료조회  house_code, ra_no, ra_count
 **/
//        if(mode.equals("gstRatTableData")) {
//
//            String house_code   = info.getSession("HOUSE_CODE");
//            String ra_no        = ws.getParam("ra_no");
//            String ra_count     = ws.getParam("ra_count");
//
//            String[] pData = {house_code, ra_no, ra_count, house_code, ra_no, ra_count};
//
//            WiseOut out = gstRatTableData(info, pData);
//
//            WiseFormater wf = new WiseFormater(out.result[0]);
//
//            if(wf == null) { //데이타 포맷이 정확하지 않을경우
//                msg.getMessage("0001");
//                ws.setMessage("데이타 포맷이 정확하지 않습니다.");
//                ws.write();
//
//                return;
//            }
//
//            if(wf.getRowCount() == 0) { //데이타가 없는 경우
//                ws.setCode("M001");
//                ws.setMessage("조회된 데이타가 없습니다.");
//                ws.write();
//
//                return;
//            }
//
//            int INDEX_ROWNUM           = ws.getColumnIndex("ROWNUM");
//            int INDEX_VENDOR_CODE      = ws.getColumnIndex("VENDOR_CODE");
//            int INDEX_NAME_LOC         = ws.getColumnIndex("NAME_LOC");
//            int INDEX_CEO_NAME_LOC     = ws.getColumnIndex("CEO_NAME_LOC");
//            int INDEX_VNGL_ADDRESS     = ws.getColumnIndex("VNGL_ADDRESS");
//            int INDEX_BID_PRICE        = ws.getColumnIndex("BID_PRICE");
//            int INDEX_USER_NAME_LOC      = ws.getColumnIndex("USER_NAME_LOC");
//            int INDEX_USER_ID      = ws.getColumnIndex("USER_ID");
//            int INDEX_PHONE_NO      = ws.getColumnIndex("PHONE_NO");
//            int INDEX_SETTLE_FLAG      = ws.getColumnIndex("SETTLE_FLAG");
//            int INDEX_EVAL_SCORE      = ws.getColumnIndex("EVAL_SCORE");
//            
//
//            for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
//                ws.addValue(INDEX_ROWNUM           ,wf.getValue("ROWNUM"        , i)     ,"");// NO
//                ws.addValue(INDEX_VENDOR_CODE      ,wf.getValue("VENDOR_CODE"   , i)     ,"");// 공급업체코드
//                ws.addValue(INDEX_NAME_LOC         ,wf.getValue("VENDOR_NAME_LOC"      , i)     ,"");// 공급업체명
//                ws.addValue(INDEX_CEO_NAME_LOC     ,wf.getValue("CEO_NAME_LOC"  , i)     ,"");// 공급업체 대표자명
//                ws.addValue(INDEX_VNGL_ADDRESS     ,wf.getValue("VNGL_ADDRESS"  , i)     ,"");// 공급업체주소
//                ws.addValue(INDEX_BID_PRICE        ,wf.getValue("BID_PRICE"     , i)     ,"");// 입찰가격
//                ws.addValue(INDEX_USER_NAME_LOC      ,wf.getValue("CHANGE_USER_NAME_LOC"     , i)    ,"");// 담당자명
//                ws.addValue(INDEX_USER_ID      ,wf.getValue("CHANGE_USER_ID"     , i)    ,"");// 담당자 ID
//                ws.addValue(INDEX_PHONE_NO      ,wf.getValue("PHONE_NO2"     , i)   ,"");// 담당자 전화번호
//                ws.addValue(INDEX_SETTLE_FLAG      ,wf.getValue("SETTLE_FLAG"   , i)     ,"");//
//                ws.addValue(INDEX_EVAL_SCORE      ,wf.getValue("EVAL_SCORE"   , i)     ,"");//
//                
//                
//
//            }
//
//            ws.setCode("M001");
//            ws.setMessage("성공적으로 작업을 수행하였습니다..");
//            ws.write();
//
//       }
//
//    }
//
//
//    public WiseOut gstRatTableData(WiseInfo info, String[] pData) {
//        Object[] args = {pData};
//
//        WiseOut rtn = null;
//        WiseRemote wr = null;
//
//        String conType    = "CONNECTION";
//        String nickName   = "p1008";
//        String MethodName = "gstRatTableData";
//
//        try {
//            wr = new WiseRemote(nickName, conType, info);
//            rtn = wr.lookup(MethodName, args);
//        }catch(Exception e) {
//            Logger.dev.println(info.getSession("ID"), this, "Servlet===>gstRatTableData Exceptioin =====> " + e.getMessage());
//        }finally{
//            wr.Release();
//        }
//
//        return rtn;
//    }

/**********************************************************************************************************************************/

//
//    public void doData(WiseStream ws) throws Exception{
//        //session 정보를 가져온다.
//        WiseInfo info   = WiseSession.getAllValue(ws.getRequest());
//        WiseFormater wf = ws.getWiseFormater();
//
//        String house_code       = info.getSession("HOUSE_CODE");
//        String company_code     = info.getSession("COMPANY_CODE");
//        String user_id          = info.getSession("ID");
//        String name_loc         = info.getSession("NAME_LOC");
//        String name_eng         = info.getSession("NAME_ENG");
//        String department       = info.getSession("DEPARTMENT");
//
//        WiseOut value = null;
//        String mode = ws.getParam("mode");
//
//        String type             = ws.getParam("type");
//        String msg              = ws.getParam("msg");
//        String  settle_flag     = ws.getParam("settle_flag");
//
//        String RA_NO            = ws.getParam("RA_NO");
//        String RA_COUNT         = ws.getParam("RA_COUNT");
//        String VENDOR_CODE      = ws.getParam("VENDOR_CODE");
//        String BID_STATUS       = ws.getParam("BID_STATUS");
//        String NB_REASON       	= ws.getParam("NB_REASON");
//        String BID_SEQ          = ws.getParam("BID_SEQ");
//        String SR_ATTACH_NO     = ws.getParam("SR_ATTACH_NO");
//
//        type            = checkNull(type);
//        msg             = checkNull(msg);
//        settle_flag     = checkNull(settle_flag);
//
//        RA_NO           = checkNull(RA_NO);
//        RA_COUNT        = checkNull(RA_COUNT);
//        VENDOR_CODE     = checkNull(VENDOR_CODE);
//        BID_STATUS      = checkNull(BID_STATUS);
//        NB_REASON      = checkNull(NB_REASON);
//        
//        BID_SEQ      = checkNull(BID_SEQ);
//        
//        String PR_PROCEEDING_FLAG = "";
//
//        if(mode.equals("setratbdins4_1")) { //
//
//             if ("SB".equals(BID_STATUS)) {  //낙찰
//                settle_flag = "Y";
//                PR_PROCEEDING_FLAG = "E"; // 품의 대기
//             } else {                        //유찰
//                settle_flag = "N";
//                PR_PROCEEDING_FLAG = "P"; // 구매대기
//             }
//             String[] sendPRDT = {BID_STATUS , house_code ,RA_NO, RA_COUNT, PR_PROCEEDING_FLAG};
//
//             String[][] dataRAHD = {{ "C" ,user_id ,name_loc ,name_eng ,department
//                        ,NB_REASON , SR_ATTACH_NO ,house_code ,RA_NO ,RA_COUNT}
//                      };
//
//             String[][] dataRADT = {{ settle_flag ,user_id ,name_loc ,name_eng ,department
//                        ,house_code ,RA_NO ,RA_COUNT}
//                      };
//
//             
//             /*
//              * RABD테이블은 ID와 NAME이 변경될 필요 없음.
//              */
//             String[] USER_ID = wf.getValue("USER_ID");
//             String[] USER_NAME_LOC = wf.getValue("USER_NAME_LOC");
//             
//             String[][] dataRABD = {{settle_flag ,/* USER_ID[0] ,USER_NAME_LOC[0] ,name_eng ,*/house_code
//                       ,VENDOR_CODE, RA_NO ,RA_COUNT, BID_SEQ}
//                         };
//
//             
//             if ("NB".equals(BID_STATUS)) {  //유찰
//             	dataRABD = null;
//             }
//             
//             //Object[] obj_save = {dataPRDT, dataRAHD, dataRADT, dataRABD};
//             /*if (bid_status.equals("SB")) {
//                 msg = "정상적으로 낙찰 되었습니다";
//             } else {
//                 msg = "정상적으로 유찰 되었습니다";
//             }*/
//
//             value = setratbdins4_1(info, sendPRDT, dataRAHD, dataRADT, dataRABD);
//             //String[] obj = new String[1];
//             //obj[0] = value.message;
//             ws.setMessage(value.message);
//             Logger.debug.println(info.getSession("ID"), this, "===============AVENGER KIM================="+value.message);
//             //ws.setUserObject(obj);            
//        }
//       
//        try{
//	        ws.setCode(String.valueOf(value.status));
//	        if ("SB".equals(BID_STATUS)) {
//	            ws.setMessage("정상적으로 낙찰 되었습니다");
//	        } else {
//	            ws.setMessage("정상적으로 유찰 되었습니다");
//	        }
//	        
//	        
//	
//	        ws.write();
//        }catch(NullPointerException ne){
//			ne.printStackTrace();
//		}
//    }
//
//    
//
//    
//   
//    public WiseOut setratbdins4_1(WiseInfo info, String[] sendPRDT, String[][] dataRAHD, String[][] dataRADT, String[][] dataRABD) {
//        String nickName= "p1008";
//        String conType = "TRANSACTION";
//        String MethodName = "setratbdins4_1";
//        WiseOut value = null;
//        WiseRemote wr = null;
//        String ebidding_no = null;  //생성시 채번..
//
//        Object[] obj_save = {sendPRDT, dataRAHD, dataRADT, dataRABD};
//
//        //Object[] args = {dataRAHD, dataRADT, dataPRDT, dataRQSE};
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


    public String checkNull(String value) {
        if(value == null) {value = null;}
        else if("".equals(value.trim())) {value = null;}
        return value;
    }

    public String null2Void(String pStr)  {
        try {
            if (pStr == null) {
                return "";
            } else {
                return pStr.trim();
            }
        } catch (Exception e) {
                  return "";
       }
    }

}
