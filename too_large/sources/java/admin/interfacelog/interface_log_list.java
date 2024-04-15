package admin.interfaceLog;

import java.io.IOException;
import java.io.PrintWriter;
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

import poasrm.sepoa.ws.provider.EpsStub;
import poasrm.sepoa.ws.provider.EpsStub.EPS0022_2;
import poasrm.sepoa.ws.provider.EpsStub.EPS0022_2Response;
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

public class interface_log_list extends HttpServlet{
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
    		
    		if("selectSinfhdList".equals(mode)){
    			gdRes = this.selectSinfhdList(gdReq, info);
    		}
    		else if("gwClick".equals(mode)){
    			gdRes = this.gwClick(gdReq, info);
    		}
    		else if("selectUserlogList".equals(mode)){
    			gdRes = this.selectUserlogList(gdReq, info);
    		}
    		
    		
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("selectSinfhdList".equals(mode) || "selectUserlogList".equals(mode)){
    				OperateGridData.write(req, res, gdRes, out);
        		}
        		else if("gwClick".equals(mode)){
        			out.print(gdRes.getMessage());
        		}
    		}
    		catch (Exception e) {
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
    
    @SuppressWarnings({ "unchecked", "unused" })
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
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
    
    
    
    
    private Object[] selectSinfhdListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result = new Object[1];
    	Map<String, String> header = this.getHeader(gdReq, info);
    	String  inf_date     = header.get("inf_date");	    	
    	
    	header.put("inf_date".trim(), SepoaString.getDateUnSlashFormat( inf_date ) );	    	
    	header.put("inf_start_time".trim(), header.get("sTime")+header.get("sMin")+"00" );
    	header.put("inf_end_time".trim(), header.get("eTime")+header.get("eMin")+"00" );
    	
    
    	
    	result[0] = header;
    	
    	return result;
    }
    
    private GridData selectSinfhdListGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
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
    			
    			gdRes.addValue(colKey, colValue);
    		}
    	}
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes" })
	private GridData selectSinfhdList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    Object[] obj = null;
	    String        gdResMessage = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);  	
	    	gdRes.addParam("mode", "doQuery");
	    	obj = selectSinfhdListObj(gdReq, info);
	  	
	    	value    = ServiceConnector.doService(info, "interfaceLog", "CONNECTION", "selectSinfhdList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.selectSinfhdListGdRes(gdReq, gdRes, sf);
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
	
	private GridData gwClick(GridData gdReq, SepoaInfo info) throws Exception{
		GridData gdRes        = new GridData();
		String   infNo        = gdReq.getParam("INF_NO");
		String   gdResMessage = null;
		
		try{
			EpsStub           epsStup           = new EpsStub();
			EPS0022_2         eps0022_2         = new EPS0022_2();
			EPS0022_2Response eps0022_2Response = null;
			String[]          responseReturn    = null;
			
			eps0022_2.setDOC_NO(infNo);
			eps0022_2.setSTATUS("E");
			eps0022_2.setGW_DOC_NO("20150109_1454");
			eps0022_2.setAPP_DATE("20150101");
			eps0022_2.setAPP_TIME("120103");
			eps0022_2.setGW_TITLE("title");
			eps0022_2.setDOC_LINK("http://www.daum.net");
			eps0022_2.setREGISTER_DATE("2015-01-01");
			eps0022_2.setAPPROVAL_INS_ID("12345678901234567890123456789012345");
			eps0022_2.setAPPROVAL_PRO_ID("12345678901234567890123456789012345");
			
			eps0022_2Response = epsStup.ePS0022_2(eps0022_2);
			responseReturn    = eps0022_2Response.get_return();
			
			gdResMessage = "{code:'" + responseReturn[0] + "'}";
		}
		catch(Exception e){
			gdResMessage = "{code:'900'}";
		}
		
		gdRes.setMessage(gdResMessage);
		
		return gdRes;
	}
	
	
	
	private Object[] selectUserlogListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result = new Object[1];
    	Map<String, String> header = this.getHeader(gdReq, info);
    	String  inf_date     = header.get("job_date");	    	
    	
    	header.put("job_date".trim(), SepoaString.getDateUnSlashFormat( inf_date ) );	    	
    	header.put("start_job_time".trim(), header.get("sTime")+header.get("sMin")+"00" );
    	header.put("end_job_time".trim(), header.get("eTime")+header.get("eMin")+"00" );
    	
    
    	
    	result[0] = header;
    	
    	return result;
    }
    
    private GridData selectUserlogListGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
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
    			
    			gdRes.addValue(colKey, colValue);
    		}
    	}
    	
    	return gdRes;
    }
	
	
	@SuppressWarnings({ "rawtypes" })
	private GridData selectUserlogList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    Object[] obj = null;
	    String        gdResMessage = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);  	
	    	gdRes.addParam("mode", "doQuery");
	    	obj = selectUserlogListObj(gdReq, info);
	  	
	    	value    = ServiceConnector.doService(info, "interfaceLog", "CONNECTION", "selectUserlogList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.selectUserlogListGdRes(gdReq, gdRes, sf);
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