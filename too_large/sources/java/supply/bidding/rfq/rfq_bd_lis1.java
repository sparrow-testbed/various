package supply.bidding.rfq;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.icompia.util.CommonUtil;

public class rfq_bd_lis1 extends HttpServlet {
				
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
	    		
	    		if("getQuery_New_Rfq_List".equals(mode)){ 					// 견적요청접수현황
	    			gdRes = this.getQuery_New_Rfq_List(gdReq, info);
	    		}else if("setRejectRfq".equals(mode)){ 					    // 견적포기
	    			gdRes = this.setRejectRfq(gdReq, info);
	    		}
	    		
	    	}
	    	catch (Exception e) {
	    		gdRes.setMessage("Error: " + e.getMessage());
	    		gdRes.setStatus("false");
	    		
	    	}finally {
	    		try{
	    			OperateGridData.write(req, res, gdRes, out);
	    		}
	    		catch (Exception e) {
	    			Logger.debug.println();
	    		}
	    	}
	    } 
	    
	    
	    /**
	     * 견적포기 
	     * setReject
	     * @param  gdReq
	     * @param  info
	     * @return GridData
	     * @throws Exception
	     * @since  2014-10-07
	     * @modify 2014-10-07
	     */ 
	    @SuppressWarnings("unchecked")
		private GridData setRejectRfq(GridData gdReq, SepoaInfo info) throws Exception{
	    	GridData            gdRes       = new GridData();
	    	Vector              multilangId = new Vector();
	    	HashMap             message     = null;
	    	SepoaOut            value       = null;
	    	Map<String, Object>       svcParam    = new HashMap<String, Object>();
	    	List<Map<String, String>> gridData    = this.doDataGridData(gdReq, info);
	   
	    	multilangId.addElement("MESSAGE");
	    	message = MessageUtil.getMessage(info, multilangId);

	    	try {
	    		
	    		gdRes.addParam("mode", "doSave");
	    		gdRes.setSelectable(false);
	    		
	    		svcParam.put("gridData", gridData);
	    		
	    		Object[] obj = {svcParam};
	    		value = ServiceConnector.doService(info, "s2011", "TRANSACTION", "setRejectRfq", obj);
	    		
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

	    
	    
	    @SuppressWarnings("unchecked")
		private List<Map<String, String>> doDataGridData(GridData gdReq, SepoaInfo info) throws Exception{
	    	List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
	    	List<Map<String, String>> grid       = null;
	    	Map<String, Object>       data       = SepoaDataMapper.getData(info, gdReq);
	    	Map<String, String>       gridInfo   = null;
	    	Map<String, String>       resultInfo = null;
	    	Map<String, String>       header     = null;
	    	String                    matCode    = null;
	    	String                    type       = null;
	    	String                    houseCode  = info.getSession("HOUSE_CODE");
	    	int                       gridSize   = 0;
	    	int                       i          = 0;
	    	
	    	grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	    	gridSize = grid.size();
	    	
	    	for(i = 0; i < gridSize; i++){
	    		resultInfo = new HashMap<String, String>();
	    		
	    		gridInfo = grid.get(i);
	    		
	    		resultInfo.put("rfq_type",      gridInfo.get("RFQ_TYPE"));
	    		resultInfo.put("rfq_no",       	gridInfo.get("RFQ_NO"));
	    		resultInfo.put("rfq_count", 	gridInfo.get("RFQ_COUNT"));
	    		
	    		result.add(resultInfo);
	    	}
	    	
	    	return result;
	    }

		/**
	     * 견적요청접수현황 
	     * getRfqList
	     * @param  gdReq
	     * @param  info
	     * @return GridData
	     * @throws Exception
	     * @since  2014-10-07
	     * @modify 2014-10-07
	     */  
	    @SuppressWarnings("unchecked")
		private GridData getQuery_New_Rfq_List(GridData gdReq, SepoaInfo info) throws Exception{
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
		    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids"));
		    	gridColAry = SepoaString.parser(gridColId, ",");
		    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
		    	
		    	
		    	
		
		    	gdRes.addParam("mode", "doQuery");
		    	
		
		    	Object[] obj = {header};
		
		    	value = ServiceConnector.doService(info, "s2011", "CONNECTION", "getQuery_New_Rfq_List", obj);
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

		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    	Message msg = new Message("STDSUPRFQ");
		
        String start_date 	= ws.getParam("start_date");
        String end_date 	= ws.getParam("end_date");
		String status 		= CommonUtil.nullToEmpty(ws.getParam("status")); 
		String bid_rfq_type = CommonUtil.nullToEmpty(ws.getParam("bid_rfq_type")); 
		String create_type = CommonUtil.nullToEmpty(ws.getParam("create_type")); 

		Object[] obj = {start_date, end_date, status, bid_rfq_type, create_type };
		SepoaOut value = ServiceConnector.doService(info, "s2011", "CONNECTION", "getQuery_New_Rfq_List", obj);
	
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
	
		if(wf.getRowCount() == 0) 
		{ 
			ws.setMessage(msg.getMessage("0004"));
			ws.write();
			return;
  	    }
		
		int cnt = wf.getRowCount();
		
		for(int i=0; i<cnt; i++) 
		{
			String[] check = {"false", ""};
	  
		    String[] img_company = {"",wf.getValue("BUYER_COMPANY_NAME", i),wf.getValue("BUYER_COMPANY_NAME", i)};   // 구매회사
		    String[] img_rfq_no = {"",wf.getValue("RFQ_NO", i),wf.getValue("RFQ_NO", i)};                           // rfq_no
		
		    ws.addValue("SELECTED"                  , check							   , "");
		    ws.addValue("BUYER_COMPANY_NAME"   , img_company						   , "");
		    ws.addValue("RFQ_NO"               , img_rfq_no							   , "");
		    ws.addValue("RFQ_COUNT"            , wf.getValue("RFQ_COUNT           ", i), "");
		    ws.addValue("STATUS"               , wf.getValue("STATUS              ", i), "");
		    ws.addValue("SUBJECT"              , wf.getValue("SUBJECT             ", i), "");
		    ws.addValue("CLOSE_DATE"           , wf.getValue("CLOSE_DATE          ", i), "");
		    ws.addValue("BUYER_USER_NAME"      , wf.getValue("BUYER_USER_NAME     ", i), "");
		    ws.addValue("BUYER_COMPANY_CODE"   , wf.getValue("BUYER_COMPANY_CODE  ", i), "");
		    ws.addValue("RFQ_FLAG"             , wf.getValue("RFQ_FLAG            ", i), "");
		    ws.addValue("RFQ_CLOSE_DATE"       , wf.getValue("RFQ_CLOSE_DATE      ", i), "");
		    ws.addValue("BUYER_DEPT"           , wf.getValue("BUYER_DEPT          ", i), "");
		    ws.addValue("RFQ_TYPE"             , wf.getValue("RFQ_TYPE            ", i), "");
		    ws.addValue("RFQ_TYPE_NAME"        , wf.getValue("RFQ_TYPE_NAME       ", i), "");
		}                              

		ws.setMessage(value.message);
		ws.write();
	}
 
///////////////////////////////// doData /////////////////////////////////////////////

	public void doData(SepoaStream ws) throws Exception {
		  
	    SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
	    String mode = ws.getParam("mode");

	    if(mode.equals("setReject")) {
	        //SepoaTable로부터 upload된 data을 formatting하여 얻는다.
	        SepoaFormater wf = ws.getSepoaFormater();

	        String RFQ_TYPE         = ws.getParam("RFQ_TYPE");
	        String[] RFQ_NO         = wf.getValue("RFQ_NO");
	        String[] RFQ_COUNT      = wf.getValue("RFQ_COUNT");

	        String setData[][] = new String[wf.getRowCount()][];

	        String[] sendobj = new String[1];

	        for (int i = 0; i<wf.getRowCount(); i++) {
	            String tmp_Data[] = {RFQ_NO[i],RFQ_COUNT[i]};
	            setData[i] = tmp_Data;    
	        }

	        Object[] obj = {setData, RFQ_TYPE};
	        SepoaOut value = ServiceConnector.doService(info, "s2011", "TRANSACTION", "setRejectRfq", obj);
	        
	        sendobj[0] = value.message;

	        ws.setUserObject(sendobj);
	        ws.setCode(String.valueOf(value.status));
	        ws.setMessage(sendobj[0]);
	        ws.write();
	    }
	}*/

}
