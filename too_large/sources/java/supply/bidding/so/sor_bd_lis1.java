package supply.bidding.so;

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

public class sor_bd_lis1 extends HttpServlet {
	
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
    		
    		if("getOsqReqList".equals(mode)){ 					// 실사요청접수현황
    			gdRes = this.getOsqReqList(gdReq, info);
    		}else if("setRejectOsq".equals(mode)){ 			// 실사포기
    			gdRes = this.setRejectOsq(gdReq, info);
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
     * 실사포기 
     * setRejectOsq
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-11-11
     * @modify 2014-11-11
     */
    private GridData setRejectOsq(GridData gdReq, SepoaInfo info)  throws Exception{
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
    		value = ServiceConnector.doService(info, "s2041", "TRANSACTION", "setRejectOsq", obj);
    		
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
	    		
	    		resultInfo.put("osq_no",       	gridInfo.get("OSQ_NO"));
	    		resultInfo.put("osq_count", 	gridInfo.get("OSQ_COUNT"));
	    		
	    		result.add(resultInfo);
	    	}
	    	
	    	return result;
	    }

	/**
     * 실사요청현황 
     * getOsqReqList
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-10-29
     * @modify 2014-10-29
     */
	private GridData getOsqReqList(GridData gdReq, SepoaInfo info)  throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "s2041", "CONNECTION", "getOsqReqList", obj);
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
}
