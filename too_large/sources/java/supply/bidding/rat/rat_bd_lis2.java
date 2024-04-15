package supply.bidding.rat;

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

/**************************************************
 *역경매관리>역경매결과
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
    		
    		if("getratbdlis2_1".equals(mode)){ // 역경매현황
    			gdRes = this.getratbdlis2_1(gdReq, info);
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
    
    /**
     * 역경매현황 조회
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
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
	
	    	value = ServiceConnector.doService(info, "s2031", "CONNECTION","getratbdlis2_1", obj);
	
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
//	public void doQuery(WiseStream ws) throws Exception {
//       	//get session
//       	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//       	Message msg = new Message("KO","supplier");
//
//		String mode = ws.getParam("mode");
//
//		if(mode.equals("getratbdlis2_1")) { //역경매결과
//            String house_code   = info.getSession("HOUSE_CODE");
//            String vendor_code  = info.getSession("COMPANY_CODE");
//
//	       	String from_date	= ws.getParam("from_date");
//	       	String to_date		= ws.getParam("to_date");
//	       	String settle_flag	= ws.getParam("settle_flag");
//
//	       	String[] pData = {vendor_code, vendor_code, vendor_code, house_code, from_date, to_date, settle_flag, vendor_code};
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
//    	    	return;
//	        }
//
//	   	    if(wf.getRowCount() == 0) { //데이타가 없는 경우
//				ws.setCode("1");
//				ws.setMessage("조회된 데이타가 없습니다.");
//		        	ws.write();
//
//				return;
//	      	}
//
//            int INDEX_ANN_NO            = ws.getColumnIndex("ANN_NO");
//            int INDEX_SUBJECT           = ws.getColumnIndex("SUBJECT");
//            int INDEX_ATTACH_NO         = ws.getColumnIndex("ATTACH_NO");
//            int INDEX_START_TEXT        = ws.getColumnIndex("START_TEXT");
//            int INDEX_END_TEXT          = ws.getColumnIndex("END_TEXT");
//            int INDEX_BID_COUNT         = ws.getColumnIndex("BID_COUNT");
//            int INDEX_CUR               = ws.getColumnIndex("CUR");
//            int INDEX_BID_PRICE         = ws.getColumnIndex("BID_PRICE");
//            int INDEX_CURRENT_PRICE     = ws.getColumnIndex("CURRENT_PRICE");
//            int INDEX_SETTLE_FLAG       = ws.getColumnIndex("SETTLE_FLAG");
//            int INDEX_RA_NO             = ws.getColumnIndex("RA_NO");
//            int INDEX_RA_COUNT          = ws.getColumnIndex("RA_COUNT");
//            int INDEX_COMPANY_CODE      = ws.getColumnIndex("COMPANY_CODE");
//
//			for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
//				String ls_ann_no         = wf.getValue("ANN_NO", i);
//				String attach_no         = wf.getValue("ATTACH_NO", i);
//				String attach_count      = wf.getValue("ATTACH_COUNT", i);
//
//				String ls_ann_item        = wf.getValue("SUBJECT", i);
//
//                String image_ATTACH      = "/kr/images/button/query.gif";
//
//				String[] img_ann_no =  {"", ls_ann_no, ls_ann_no};
//				String[] img_ann_item       = {"", ls_ann_item, ls_ann_item};
//
//    	        if (attach_count.equals("0")) {
//    	            image_ATTACH    = "";
//	                attach_count    = "";
//	                attach_no       = "";
//	            }
//				String[] img_attach_no  =  {image_ATTACH, attach_count, attach_no};
//
//				ws.addValue(INDEX_ANN_NO            ,img_ann_no                             ,"");//
//                ws.addValue(INDEX_SUBJECT          ,    img_ann_item                				, "");
//				ws.addValue(INDEX_ATTACH_NO         ,img_attach_no                          ,"");//
//				ws.addValue(INDEX_START_TEXT        ,wf.getValue("START_TEXT" ,i)           ,"");//
//				ws.addValue(INDEX_END_TEXT          ,wf.getValue("END_TEXT" ,i)             ,"");//
//				ws.addValue(INDEX_BID_COUNT         ,wf.getValue("BID_COUNT" ,i)            ,"");//
//				ws.addValue(INDEX_CUR               ,wf.getValue("CUR" ,i)                  ,"");//
//				ws.addValue(INDEX_BID_PRICE         ,wf.getValue("BID_PRICE" ,i)            ,"");//
//				ws.addValue(INDEX_CURRENT_PRICE     ,wf.getValue("CURRENT_PRICE" ,i)        ,"");//
//				ws.addValue(INDEX_SETTLE_FLAG       ,wf.getValue("SETTLE_FLAG" ,i)          ,"");//
//				ws.addValue(INDEX_RA_NO             ,wf.getValue("RA_NO" ,i)                ,"");//
//				ws.addValue(INDEX_RA_COUNT          ,wf.getValue("RA_COUNT" ,i)             ,"");//
//				ws.addValue(INDEX_COMPANY_CODE      ,wf.getValue("COMPANY_CODE" ,i)         ,"");//
//                //ws.addValue("CONT_STATUS"            ,    wf.getValue("CONT_STATUS"                  , i), "");
//			}
//
// 		Logger.dev.println(info.getSession("ID"), this, "Servlet===>aa =====> 2");
//	       	ws.setCode("M001");
//	       	ws.setMessage("성공적으로 작업을 수행하였습니다..");
//	       	ws.write();
// 		Logger.dev.println(info.getSession("ID"), this, "Servlet===>aa =====> 3");
//		}
//
//   	}
//
//    public WiseOut getratbdlis2_1(WiseInfo info, String[] pData) {
//    	Object[] args = { pData };
//
//    	WiseOut rtn = null;
//    	WiseRemote wr = null;
//
//    	String nickName = "s2031";
//    	String MethodName = "getratbdlis2_1";
//    	String conType = "CONNECTION";
//
//    	try {
//       		wr = new WiseRemote(nickName, conType, info);
//
//    		rtn = wr.lookup(MethodName, args);
//
//    	}catch(Exception e) {
//       		Logger.dev.println(info.getSession("ID"), this, "Servlet===>getratbdlis2_1 Exceptioin =====> " + e.getMessage());
//    	}finally{
//		    wr.Release();
//    	}
//
//    	return rtn;
//	}


}
/*******************************************************************************************************************************
                                                       END OF File
*********************************************************************************************************************************/