package	dt.rfq;

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
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;
import sepoa.svl.util.SepoaStream;

public class qta_bd_lis2 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
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
    		
    		/*String start_rfq_date	= gdReq.getParam("start_rfq_date");
    		String end_rfq_date		= gdReq.getParam("end_rfq_date");
    		String rfq_no			= gdReq.getParam("rfq_no");
    		String settle_type		= gdReq.getParam("settle_type");
    		String subject			= gdReq.getParam("subject");
    		String ctrl_person_id   = gdReq.getParam("ctrl_person_id");
    		String bid_rfq_type   = gdReq.getParam("bid_rfq_type");*/
    		
    		if("getSettleVendor".equals(mode)){ // 조회 샘플
    			gdRes = this.getSettleVendor(gdReq, info);
    		}
    		/*else if("getCatalog2".equals(mode)){ // ?
    			gdRes = this.getCatalog2(gdReq, info);
    		}
    		else if("doData".equals(mode)){ // 저장 샘플
    			gdRes = this.doData(gdReq, info);
    		}*/
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

	@SuppressWarnings("unchecked")
	private GridData getSettleVendor(GridData gdReq, SepoaInfo info) throws Exception {
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
            // DB  : CONNECTION, TRANSACTION, NONDBJOB
            value        = ServiceConnector.doService(info, "p1072", "CONNECTION", "getSettleVendor", obj);
   			if(value.flag) {
   			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
   			    gdRes.setStatus("true");
   			} else {
   				gdRes.setMessage(value.message);
   				gdRes.setStatus("false");
   			    return gdRes;
   			}
   			
   			sf = new SepoaFormater(value.result[0]);
   			
   			if (sf.getRowCount() == 0) {
   			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
   			    return gdRes;
   			}
   			
   			for (int i = 0; i < sf.getRowCount(); i++) {
   				for(int k=0; k < gridColAry.length; k++) {
   			    	if(gridColAry[k] != null && gridColAry[k].equals("SELECTED")) {
   			    		gdRes.addValue("SELECTED", "0");
   			    	} else if(gridColAry[k] != null && gridColAry[k].equals("CHANGE_DATE")) {
       	            	gdRes.addValue(gridColAry[k], SepoaString.getDateSlashFormat(sf.getValue(gridColAry[k], i)));
                   	}else {
   			        	gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
   			        }
   				}
   			}
   		    
   		} catch (Exception e) {
   			
   		    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
   			gdRes.setStatus("false");
   	    }
   		
   		return gdRes;
		
		/* GridData            gdRes      = new GridData();
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
	
	    	gdRes.addParam("mode", "getSettleVendor");
	
	
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "p1072", "CONNECTION", "getSettleVendor", obj);
	
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
	    
	    return gdRes;*/
	}

	/*public void	doQuery(SepoaStream ws) throws Exception	{
		//get session
		SepoaInfo info =	SepoaSession.getAllValue(ws.getRequest());

		String mode	= ws.getParam("mode");

		String start_rfq_date	= ws.getParam("start_rfq_date");
		String end_rfq_date		= ws.getParam("end_rfq_date");
		String rfq_no			= ws.getParam("rfq_no");
		String settle_type		= ws.getParam("settle_type");
		String subject			= ws.getParam("subject");
		String ctrl_person_id   = ws.getParam("ctrl_person_id");
		String bid_rfq_type   = ws.getParam("bid_rfq_type");

		Object[] obj = {start_rfq_date,	end_rfq_date, rfq_no, settle_type, subject, ctrl_person_id, bid_rfq_type};
		SepoaOut value = ServiceConnector.doService(info, "p1072", "CONNECTION", "getSettleVendor", obj);

		SepoaFormater wf	= ws.getSepoaFormater(value.result[0]);
		
		for(int	i=0; i<wf.getRowCount(); i++) {	//데이타가 있는	경우

			String[] check = {"false", ""};
			
			String[] img_rfq_no	= {wf.getValue("RFQ_NO"		,i), wf.getValue("RFQ_NO"	  ,i), wf.getValue("RFQ_NO"		,i)};
			//String[] img_eval_refitem	= {"", wf.getValue("EVAL_REFITEM_FLAG"	  ,i), wf.getValue("EVAL_REFITEM_FLAG"		,i)};
			ws.addValue("SELECTED"          , check                            , "");
			ws.addValue("RFQ_NO"            , img_rfq_no                       , "");
			ws.addValue("RFQ_COUNT"         , wf.getValue("RFQ_COUNT      ", i), "");
			ws.addValue("SUBJECT"           , wf.getValue("SUBJECT        ", i), "");
			ws.addValue("SETTLE_TYPE_TXT"   , wf.getValue("SETTLE_TYPE_TXT", i), "");
			ws.addValue("CLOSE_DATE"        , wf.getValue("CLOSE_DATE     ", i), "");
			ws.addValue("BIDDER"            , wf.getValue("BIDDER         ", i), "");
			ws.addValue("CHANGE_USER_NAME"  , wf.getValue("CHANGE_USER_NAME", i), "");
			ws.addValue("CTRL_CODE"         , wf.getValue("CTRL_CODE      ", i), "");
			ws.addValue("RFQ_TYPE"          , wf.getValue("RFQ_TYPE       ", i), "");
			ws.addValue("RFQ_TYPE_NAME"          , wf.getValue("RFQ_TYPE_NAME       ", i), "");
			ws.addValue("SETTLE_TYPE"       , wf.getValue("SETTLE_TYPE    ", i), "");
			ws.addValue("BID_REQ_TYPE"      , wf.getValue("BID_REQ_TYPE    ", i), "");
			ws.addValue("EVAL_FLAG" 		, wf.getValue("EVAL_FLAG    	", i), "");
			ws.addValue("EVAL_FLAG_DESC"    , wf.getValue("EVAL_FLAG_DESC    ", i), "");
			ws.addValue("EVAL_REFITEM"      , wf.getValue("EVAL_REFITEM    ", i), "");			
			ws.addValue("REQ_TYPE"      	, wf.getValue("REQ_TYPE    ", i), "");
			ws.addValue("REQ_TYPE_NAME"      , wf.getValue("REQ_TYPE_NAME    ", i), "");

		}

		ws.setMessage(value.message);
		ws.write();
	} // end of	doQuery
*/
	public void	doData(SepoaStream ws) throws Exception
	{
		SepoaInfo info =	SepoaSession.getAllValue(ws.getRequest());

		SepoaFormater wf	= ws.getSepoaFormater();

		String[] RFQ_NO				= wf.getValue("RFQ_NO");
		String[] RFQ_COUNT			= wf.getValue("RFQ_COUNT");
		String[] SUBJECT  			= wf.getValue( "SUBJECT" );	//rfq_name
		
		String mode  = ws.getParam("mode");

		if(mode != null){
			if("charge_eval".equals(mode)){	//icomvevh(평가마스터정보), icomvevd(평가상세정보), icomvevl(평가자정보) 등록 
				Integer eval_id = Integer.valueOf(ws.getParam("eval_id"));
				String strEvalFlag  = "";
				
				if(eval_id == 0){	//평가제외를 선택했을 경우
					strEvalFlag = "N";	//평가제외
				}else{
					strEvalFlag = "T";	//평가대기중
				}
				Object[] obj = {RFQ_NO[0], RFQ_COUNT[0], SUBJECT[0], strEvalFlag, eval_id};
				SepoaOut iValue = ServiceConnector.doService(info, "p1072", "TRANSACTION", "setEvalInert", obj);
				
				String[] res = new String[2];
				res[0] = iValue.result[0];
				res[1] = iValue.message;

				ws.setUserObject(res);
				ws.setCode(String.valueOf(iValue.status));
				ws.write();
				
			}else if("charge_interview".equals(mode)){	//인터뷰 선정 요청
				String strEvalFlag  = "";
				
				strEvalFlag = "I";	//인터뷰 선정중
				
				Object[] obj = {RFQ_NO[0], RFQ_COUNT[0], SUBJECT[0], strEvalFlag};
				SepoaOut iValue = ServiceConnector.doService(info, "p1072", "TRANSACTION", "setEvalInterview", obj);
				
				String[] res = new String[2];
				res[0] = iValue.result[0];
				res[1] = iValue.message;

				ws.setUserObject(res);
				ws.setCode(String.valueOf(iValue.status));
				ws.write();
			}
		}else{
			String setData[][] = new String[wf.getRowCount()][];
			String cur_date         = SepoaDate.getShortDateString();
			String cur_time         = SepoaDate.getShortTimeString().substring(0,4);
			
			for	(int i = 0;	i <	wf.getRowCount(); i++) {
	
				String tmp_data[] =	{cur_date,
									 cur_time,
									 info.getSession("HOUSE_CODE"),
									 RFQ_NO[i],
									 RFQ_COUNT[i]
									};
				setData[i] = tmp_data;
			}
			
			Object[] obj = {setData};
			SepoaOut value = ServiceConnector.doService(info, "p1072", "TRANSACTION", "setRFQClose", obj);
	
	
			
			String[] sendobj = new String[2];
	
			sendobj[0] = value.result[0];
			sendobj[1] = value.message;
	
			ws.setUserObject(sendobj);
			ws.setCode(String.valueOf(value.status));
			ws.write();
		}
	}
	
}

