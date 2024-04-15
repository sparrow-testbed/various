package ict.dt.rfq;

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
			} else if ("setRfqDelete".equals(mode)){	// 삭제
       			gdRes = setRfqDelete(gdReq, info);		
       		} else if ("setRFQCancel".equals(mode)){		// 견적마감       		
       			gdRes = setRFQCancel(gdReq, info);
       		} else if ("setRFQClose".equals(mode)){		// 견적마감       		
       			gdRes = setRFQClose(gdReq, info);
       		} else if ("setRFQCloseCancel".equals(mode)){		// 견적마감취소      		
       			gdRes = setRFQCloseCancel(gdReq, info);
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
     * 견적요청(회수) 
     * setRFQClose
     * @since  2014-09-03
     * @modify 2014-09-30
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     */
	private GridData setRFQCancel(GridData gdReq, SepoaInfo info)  throws Exception {
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
    		value = ServiceConnector.doService(info, "I_p1004", "TRANSACTION", "setRFQCancel", obj);

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
    		value = ServiceConnector.doService(info, "I_p1004", "TRANSACTION", "setRFQClose", obj);

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
     * 견적마감취소 
     * setRFQCloseCancel
     * @since  2014-09-03
     * @modify 2014-09-30
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     */
	private GridData setRFQCloseCancel(GridData gdReq, SepoaInfo info)  throws Exception {
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
    		value = ServiceConnector.doService(info, "I_p1004", "TRANSACTION", "setRFQCloseCancel", obj);

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
	    		
	    		value = ServiceConnector.doService(info, "I_p1004", "TRANSACTION", "setRFQExtends", obj);

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
            value        = ServiceConnector.doService(info, "I_p1004", "CONNECTION", "getRfqList", obj);
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
    		
    		value = ServiceConnector.doService(info, "I_p1004", "TRANSACTION","setRfqDelete", obj);
    		
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
	
}
