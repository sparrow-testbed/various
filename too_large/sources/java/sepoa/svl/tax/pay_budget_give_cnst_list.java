package sepoa.svl.tax;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

/* 현행화테스트 */

@SuppressWarnings("serial")
public class pay_budget_give_cnst_list extends HttpServlet{
	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
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
    		
    		
    		if("getPayBudgetGiveCnstList".equals(mode)){	
       			gdRes = this.getPayBudgetGiveCnstList(gdReq, info);
       		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
//    		e.printStackTrace();
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
//    			e.printStackTrace();
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
   	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
       	Vector  v      = new Vector();
       	
       	v.addElement("MESSAGE");
       	
       	result = MessageUtil.getMessage(info, v);
       	
       	return result;
	}
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
    	return result;
    }
    
    private Object[] getPayBudgetGiveCnstListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result = new Object[1];
    	Map<String, String> header = this.getHeader(gdReq, info);
    	
    	
    	header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
		header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
		
		
    	result[0] = header;
    	
    	return result;
    }
    
    private GridData getPayBudgetGiveCnstListGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
    	String[]            gridColAry       = this.getGridColArray(gdReq);
    	String              colKey           = null;
	    String              colValue         = null;
    	int                 i                = 0;
	    int                 k                = 0;
	    int                 rowCount         = sf.getRowCount();
	    int                 gridColAryLength = gridColAry.length;
	    
    	for (i = 0; i < rowCount; i++){
    		for(k = 0; k < gridColAryLength; k++){
    			colKey   = gridColAry[k];
    			colValue = sf.getValue(colKey, i);
    			
    			if("SELECTED".equals(gridColAry[k])){
    				gdRes.addValue("SELECTED", "0");
    			}
    			else{
    				gdRes.addValue(colKey, colValue);
    			}
    		}
    	}
    	
    	return gdRes;
    }
    
    @SuppressWarnings({ "rawtypes" })
	private GridData getPayBudgetGiveCnstList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.getPayBudgetGiveCnstListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "TX_017", "CONNECTION", "getPayBudgetGiveCnstList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.getPayBudgetGiveCnstListGdRes(gdReq, gdRes, sf);
		    	}
		    	
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
}