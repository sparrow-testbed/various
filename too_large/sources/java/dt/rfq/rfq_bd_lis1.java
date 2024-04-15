package dt.rfq;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
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

public class rfq_bd_lis1 extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException{Logger.debug.println();}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
		doPost(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
		
		try{
			
			gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if ("getRfqList".equals(mode)){				// 견적요청현황 조회
				gdRes = getRfqList(gdReq,info);
			} else if("setRFQExtends".equals(mode)){	// 견적 기간 연장
				gdRes = setRFQExtends(gdReq, info); 
			}
			else if ("setRfqDelete".equals(mode)){	// 삭제
       			gdRes = setRfqDelete(gdReq, info);		
       		}
       		else if ("setRFQClose".equals(mode)){		// 견적마감
       		
       			gdRes = setRFQClose(gdReq, info);
       		}
       			       		
		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
        	gdRes.setStatus("false"); 
        	
        } finally {
        	try {
        		OperateGridData.write(req, res, gdRes, out);
        	} catch (Exception e) {
        		Logger.debug.println();
        	}
        }
		
	
	}
	
	
	/**
     * 견적마감 
     * setRFQClose
     * @since  2014-09-03
     * @modify 2014-09-30
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     */
	private GridData setRFQClose(GridData gdReq, SepoaInfo info)  throws Exception {
		GridData            gdRes       	      = new GridData();
    	Vector              multilangId           = new Vector();
    	HashMap             message               = null;
    	SepoaOut            value                 = null;
    	Map<String, Object> data                  = null;
    	Map<String, Object> recvData              = null;
    	
    	multilangId.addElement("MESSAGE");
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "setRFQClose");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		recvData = this.setRFQCloseRevcData(info, data);  
			
    		
    		Object[] obj = {recvData};
    		value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRFQClose", obj);

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

	
	/**
     * 견적기간마감 리스트 추출
     * setRFQCloseRevcData
     * @since  2014-09-03
     * @modify 2014-09-30
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     */
	private Map<String, Object> setRFQCloseRevcData(SepoaInfo info, Map<String, Object> data) {
    	Map<String, String>       gridInfo        = null;
    	Map<String, Object>       result          = new HashMap<String, Object>();
    	
    	List<Map<String, String>> grid            = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	
    	List<Map<String, String>> recvData        = new ArrayList<Map<String, String>>();
    	Map<String, String> tmp_recvData          = new HashMap<String, String>();
    	int                       i               = 0;
    	int                       gridSize        = grid.size();
    	
    	for(i = 0; i < gridSize; i++){
    		
    		gridInfo          = grid.get(i);
    		
    		tmp_recvData.put("rfq_close_date" , SepoaDate.getShortDateString());
    		tmp_recvData.put("rfq_close_time" , SepoaDate.getShortTimeString().substring(0, 4));
    		tmp_recvData.put("house_code"     , info.getSession("HOUSE_CODE"));
    		tmp_recvData.put("rfq_no"         , gridInfo.get("RFQ_NO"));
    		tmp_recvData.put("rfq_count"      , gridInfo.get("RFQ_COUNT"));
    		
    		recvData.add(tmp_recvData);
    	}
    	
    	result.put("recvData", recvData);
    	
    	return result;
	}

	/**
     * 견적기간연장 
     * setRFQExtends
     * @since  2014-09-03
     * @modify 2014-09-30
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     */
	 @SuppressWarnings("unchecked")
	private GridData setRFQExtends(GridData gdReq, SepoaInfo info) throws Exception {
		 GridData            gdRes       = new GridData();
	    	Vector              multilangId = new Vector();
	    	HashMap             message     = null;
	    	SepoaOut            value       = null;
	    	Map<String, Object> data        = null;
	   
	    	multilangId.addElement("MESSAGE");
	    	message = MessageUtil.getMessage(info, multilangId);

	    	try {
	    		gdRes.addParam("mode", "setRFQExtends");
	    		gdRes.setSelectable(false);
	    		data = SepoaDataMapper.getData(info, gdReq);
	    		
	    		Object[] obj = {data};
	    		
	    		value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRFQExtends", obj);

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

	/**
     * 견적요청 현황 리스트를 조회한다.
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	private GridData getRfqList(GridData gdReq, SepoaInfo info) throws Exception {
        
		GridData gdRes   		= new GridData();
   	    Vector multilang_id 	= new Vector();
   	    multilang_id.addElement("MESSAGE");
   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
   	
		SepoaFormater       sf              = null;
        Map<String, Object> allData         = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header          = null;
	    SepoaOut            value           = null;
        String              grid_col_id     = null;
        String[]            grid_col_ary    = null;
        //int                 rowCount      = 0;
        
        try{
        	allData      = SepoaDataMapper.getData(info, gdReq);	// 파라미터로 넘어온 모든 값 조회
        	header       = MapUtils.getMap(allData, "headerData");
	    	grid_col_id  = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "getRfqList");
   			
   			header.put( "start_change_date ".trim() , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "start_change_date ".trim(), "" ) ) );
   			header.put( "end_change_date   ".trim() , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "end_change_date   ".trim(), "" ) ) );
   			
            Object[] obj = {header};
            // DB  : CONNECTION, TRANSACTION, NONDBJOB
            //System.out.println("header:"+header);
            value        = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqList", obj);
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
   				for(int k=0; k < grid_col_ary.length; k++) {
   			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
   			    		gdRes.addValue("SELECTED", "0");
   			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CHANGE_DATE")) {
       	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(sf.getValue(grid_col_ary[k], i)));
                   	}else {
   			        	gdRes.addValue(grid_col_ary[k], sf.getValue(grid_col_ary[k], i));
   			        }
   				}
   			}
   		    
   		} catch (Exception e) {
   		    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
   			gdRes.setStatus("false");
   	    }
   		
   		return gdRes;
	}

	/**
	 * 견적요청 삭제 
	 * setRfqDelete
	 * @since  2014-09-30
	 * @modify 2014-09-30
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 */
	private GridData setRfqDelete(GridData gdReq, SepoaInfo info) throws Exception {
		GridData                  gdRes       = new GridData();
    	Vector                    multilangId = new Vector();
    	HashMap                   message     = null;
    	SepoaOut                  value       = null;
    	Map<String, Object>       data        = null;
    	Map<String, Object>       svcParam    = null;
    	List<Map<String, String>> grid        = null;
   
    	multilangId.addElement("MESSAGE");
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data     = SepoaDataMapper.getData(info, gdReq);
    		grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    		svcParam = this.setRfqChkParam(info, grid);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1004", "TRANSACTION","setRfqDelete", obj);
    		
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

	
	/**
	 * 견적요청 체크된 값 가져오는 메소드
	 * setRfqChkParam
	 * @since  2014-09-30
	 * @modify 2014-09-30
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 */
	private Map<String, Object> setRfqChkParam(SepoaInfo info, List<Map<String, String>> grid) {
		Map<String, Object>       result              	= new HashMap<String, Object>();
    	List<Map<String, String>> paramList     		= new ArrayList<Map<String, String>>();
    	Map<String, String>       paramListInfo 		= null;
    	Map<String, String>       gridInfo            	= null;
    	String                    rfqNo                	= null;
    	String                    rfqCount             	= null;
    	String                    houseCode           	= info.getSession("HOUSE_CODE");
    	int                       gridSize            	= grid.size();
    	int                       i                   	= 0;
    	
    	for(i = 0; i < gridSize; i++){
    		paramListInfo = new HashMap<String, String>();
    		
    		gridInfo  = grid.get(i);
    		rfqNo     = gridInfo.get("RFQ_NO");
    		rfqCount  = gridInfo.get("RFQ_COUNT");
    		
    		paramListInfo.put("rfqNo",      rfqNo);
    		paramListInfo.put("rfqCount",   rfqCount);
    		paramListInfo.put("houseCode",  houseCode);
    		
    		paramList.add(paramListInfo);
    	}
    	
    	result.put("paramList", paramList);
    	
    	return result;
	}
	
	/*
	public void doQuery(SepoaStream ws) throws Exception {
		//get session
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		String mode = ws.getParam("mode");
		
		String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
		
        
		if(mode.equals("getRfqList")) { 
			String start_change_date 	= ws.getParam("start_change_date");
			String end_change_date   	= ws.getParam("end_change_date");
			String rfq_no            	= ws.getParam("rfq_no");
			String subject            	= ws.getParam("subject");
			String change_user       	= ws.getParam("change_user"); 
			String rfq_flag      		= ws.getParam("rfq_flag"); 
			String create_flag      	= "PR"; 
			
			StringTokenizer st = new StringTokenizer(change_user, "&");
			String ctrl_code = "";
			int cnt = 0;
			while (st.hasMoreElements()) {
				if (cnt == 0) ctrl_code  = st.nextToken();
				else		  ctrl_code += "','" + st.nextToken();
				cnt++;
			}
			 
            Object[] obj = {start_change_date, end_change_date, rfq_no, subject, ctrl_code, rfq_flag, create_flag};
            
//            SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqList", obj);
            SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqList", obj);
            
            SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

            String img_name = "/kr/images/icon/detail.gif";
            
            for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
            	String[] check = {"false", ""};      
            	//String[] img_rfq_no = {"", wf.getValue("RFQ_NO" ,i), wf.getValue("RFQ_NO" ,i)};    
            	String tmp_announce = wf.getValue("ANNOUNCE_DATE",i);
            	if(tmp_announce.equals("N")) img_name = "";

            	String[] img_announce = {img_name, "", wf.getValue("ANNOUNCE_DATE",i)};    
            	
            	for(int k=0;k < grid_col_ary.length; k++){
            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")){
    					ws.addValue("SELECTED", "1");
    				}else{
    	            	ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
    	            }
            	}
            	
            	ws.addValue("SEL"                    , check								 , "");
            	ws.addValue("RFQ_NO"                 , img_rfq_no							 , "");
            	ws.addValue("RFQ_COUNT"              , wf.getValue("RFQ_COUNT           " ,i), "");
            	ws.addValue("RFQ_FLAG_TEXT"          , wf.getValue("RFQ_FLAG_TEXT       " ,i), "");
            	ws.addValue("RFQ_TYPE"               , wf.getValue("RFQ_TYPE            " ,i), "");
            	
            	ws.addValue("ITEM_CNT"               , wf.getValue("ITEM_CNT            " ,i), "");
            	ws.addValue("CHANGE_DATE"            , wf.getValue("CHANGE_DATE         " ,i), "");
            	ws.addValue("SUBJECT"                , wf.getValue("SUBJECT             " ,i), "");
            	ws.addValue("RFQ_CLOSE_TIME"         , wf.getValue("RFQ_CLOSE_TIME      " ,i), "");
            	ws.addValue("VIEW_CNT"               , wf.getValue("VIEW_CNT            " ,i), "");
            	
            	ws.addValue("BID_COUNT"              , wf.getValue("BID_COUNT           " ,i), "");
            	ws.addValue("VENDOR_CNT"          	 , wf.getValue("VENDOR_CNT       	" ,i), "");
            	ws.addValue("RFQ_GIVEUP_CNT"         , wf.getValue("RFQ_GIVEUP_CNT      " ,i), "");
            	ws.addValue("ANNOUNCE_DATE"          , img_announce							 , "");
            	ws.addValue("DEPT_NAME"              , wf.getValue("DEPT_NAME           " ,i), "");
            	ws.addValue("CHANGE_USER_NAME_LOC"   , wf.getValue("CHANGE_USER_NAME_LOC" ,i), "");
            	
            	ws.addValue("CTRL_CODE_NAME"         , wf.getValue("CTRL_CODE_NAME		" ,i), "");
            	ws.addValue("CHANGE_USER_ID"         , wf.getValue("CHANGE_USER_ID      " ,i), "");
            	ws.addValue("CHANGE_DEPT_CODE"       , wf.getValue("CHANGE_DEPT_CODE    " ,i), "");
            	ws.addValue("CREATE_TYPE"            , wf.getValue("CREATE_TYPE         " ,i), "");
            	ws.addValue("RFQ_FLAG"               , wf.getValue("RFQ_FLAG            " ,i), "");
            	ws.addValue("CTRL_CODE"		         , wf.getValue("CTRL_CODE			" ,i), "");
            	ws.addValue("REQ_TYPE"		         , wf.getValue("REQ_TYPE			" ,i), "");
            	
            	ws.addValue("RFQ_EXTENDS_DATE"		 , wf.getValue(""					  ,i), "");
            	ws.addValue("RFQ_EXTENDS_TIME"		 , wf.getValue(""					  ,i), "");
            }
            ws.setMessage(value.message);
            ws.write();
		}else if(mode.equals("getRfqInterList")) { 
			String start_change_date 	= ws.getParam("start_change_date");
			String end_change_date   	= ws.getParam("end_change_date");
			String rfq_no            	= ws.getParam("rfq_no");
			String subject            	= ws.getParam("subject");
			String pm_id				= info.getSession("ID");
			
            Object[] obj = {start_change_date, end_change_date, rfq_no, subject, pm_id};
            
            SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqInterList", obj);
            
            SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

            String img_name = "/kr/images/icon/detail.gif";
            
            for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
            	//String[] check = {"false", ""};      
            	//String[] img_rfq_no = {"", wf.getValue("RFQ_NO" ,i), wf.getValue("RFQ_NO" ,i)};    
            	//String tmp_announce = wf.getValue("ANNOUNCE_DATE",i);
            	//if(tmp_announce.equals("N")) img_name = "";

            	//String[] img_announce = {img_name, "", wf.getValue("ANNOUNCE_DATE",i)};    
            	
            	
            	for(int k=0;k < grid_col_ary.length; k++){
            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")){
    					ws.addValue("SELECTED", "1");
    				}else{
    	            	ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
    	            }
            	}
            	ws.addValue("SEL"                    , check								 , "");
            	ws.addValue("RFQ_NO"                 , img_rfq_no							 , "");
            	ws.addValue("RFQ_COUNT"              , wf.getValue("RFQ_COUNT           " ,i), "");
            	ws.addValue("RFQ_FLAG_TEXT"          , wf.getValue("RFQ_FLAG_TEXT       " ,i), "");
            	ws.addValue("RFQ_TYPE"               , wf.getValue("RFQ_TYPE            " ,i), "");
            	
            	ws.addValue("ITEM_CNT"               , wf.getValue("ITEM_CNT            " ,i), "");
            	ws.addValue("CHANGE_DATE"            , wf.getValue("CHANGE_DATE         " ,i), "");
            	ws.addValue("SUBJECT"                , wf.getValue("SUBJECT             " ,i), "");
            	ws.addValue("RFQ_CLOSE_TIME"         , wf.getValue("RFQ_CLOSE_TIME      " ,i), "");
            	ws.addValue("VIEW_CNT"               , wf.getValue("VIEW_CNT            " ,i), "");
            	
            	ws.addValue("BID_COUNT"              , wf.getValue("BID_COUNT           " ,i), "");
            	ws.addValue("VENDOR_CNT"          	 , wf.getValue("VENDOR_CNT       	" ,i), "");
            	ws.addValue("ANNOUNCE_DATE"          , img_announce							 , "");
            	ws.addValue("DEPT_NAME"              , wf.getValue("DEPT_NAME           " ,i), "");
            	ws.addValue("CHANGE_USER_NAME_LOC"   , wf.getValue("CHANGE_USER_NAME_LOC" ,i), "");
            	
            	ws.addValue("CTRL_CODE_NAME"         , wf.getValue("CTRL_CODE_NAME		" ,i), "");
            	ws.addValue("CHANGE_USER_ID"         , wf.getValue("CHANGE_USER_ID      " ,i), "");
            	ws.addValue("CHANGE_DEPT_CODE"       , wf.getValue("CHANGE_DEPT_CODE    " ,i), "");
            	ws.addValue("CREATE_TYPE"            , wf.getValue("CREATE_TYPE         " ,i), "");
            	ws.addValue("RFQ_FLAG"               , wf.getValue("RFQ_FLAG            " ,i), "");
            	ws.addValue("CTRL_CODE"		         , wf.getValue("CTRL_CODE			" ,i), "");
            	
            	ws.addValue("RFQ_EXTENDS_DATE"		 , wf.getValue(""					  ,i), "");
            	ws.addValue("RFQ_EXTENDS_TIME"		 , wf.getValue(""					  ,i), "");
            	ws.addValue("INTERVIEW_STATUS"		 , wf.getValue("INTERVIEW_STATUS"	  ,i), "");
            }
            ws.setMessage(value.message);
            ws.write();    	
		}
        
	}
	
	public void doData(SepoaStream ws) throws Exception {
		
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());

		String mode = ws.getParam("mode");
		Logger.debug.println(info.getSession("ID"),this,"mode==//"+mode+"//");
		SepoaFormater wf = ws.getSepoaFormater();
		
		if(mode.equals("setRfqDelete")) 
		{
			String[] RFQ_NO    = wf.getValue("RFQ_NO");
			String[] RFQ_COUNT = wf.getValue("RFQ_COUNT");
			
			String[][] recvdata = new String[wf.getRowCount()][];
			
			for(int i=0;i<wf.getRowCount();i++)
			{
				String[] temp = {info.getSession("HOUSE_CODE"), RFQ_NO[i], RFQ_COUNT[i]};
				recvdata[i] = temp;
			}

			Object[] obj = {recvdata};
			SepoaOut value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRfqDelete", obj);

            String[] res = new String[1];
			res[0] = value.message;

            ws.setUserObject(res);

			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
			ws.write();
		} else if(mode.equals("setRFQClose")) 
		{
			
			String[] RFQ_NO    = wf.getValue("RFQ_NO");
			String[] RFQ_COUNT = wf.getValue("RFQ_COUNT");
			
			String[][] recvdata = new String[wf.getRowCount()][];
			
			for(int i=0;i<wf.getRowCount();i++)
			{
				String[] temp = {SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString().substring(0, 4)
								, info.getSession("HOUSE_CODE")
								, RFQ_NO[i]
								, RFQ_COUNT[i]
								 };
				recvdata[i] = temp;
			}

			Object[] obj = {recvdata};
			SepoaOut value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRFQClose", obj);

            String[] res = new String[1];
			res[0] = value.message;

            ws.setUserObject(res);

			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
			ws.write();
		} else if(mode.equals("setRFQExtends")) 
		{
			
			String[] RFQ_NO    = wf.getValue("RFQ_NO");
			String[] RFQ_COUNT = wf.getValue("RFQ_COUNT");			
			String[] RFQ_EXTENDS_DATE = wf.getValue("RFQ_EXTENDS_DATE");
			String[] RFQ_EXTENDS_TIME = wf.getValue("RFQ_EXTENDS_TIME");
			
			String[][] recvdata = new String[wf.getRowCount()][];
			
			for(int i=0;i<wf.getRowCount();i++)
			{
				String[] temp = {
								  RFQ_EXTENDS_DATE[i]
								, RFQ_EXTENDS_TIME[i]
								, info.getSession("HOUSE_CODE")
								, RFQ_NO[i]
								, RFQ_COUNT[i]
								 };
				recvdata[i] = temp;
			}

			Object[] obj = {recvdata};
			SepoaOut value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRFQExtends", obj);

            String[] res = new String[1];
			res[0] = value.message;

            ws.setUserObject(res);

			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
			ws.write();
		}
	}*/
}
