package statistics;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
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

public class sta_bd_lis08  extends HttpServlet{
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
    		
    		if("getStaUPItemList".equals(mode)){
    			gdRes = this.getStaUPItemList(gdReq, info);
    		}
    		
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    		this.loggerExceptionStackTrace(e);
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			this.loggerExceptionStackTrace(e);
    		}
    	}
    }


    
    /**
     * 품목별 단가현황 
     * getStaUPItemList
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-11-25
     * @modify 2014-11-25
     */
	private GridData getStaUPItemList(GridData gdReq, SepoaInfo info) {
		
		GridData            gdRes            = new GridData();
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    String              gdResMessage     = null;
	    Object[]            obj              = null;
	    boolean             isStatus         = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.requestListHeader(gdReq, info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	value    = ServiceConnector.doService(info, "p7008", "CONNECTION", "getStaUPItemList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		gdRes        = this.getPrProceedingListGdRes(gdReq, gdRes, value);
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch(Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
		
		
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
	    
	    @SuppressWarnings({ "unchecked" })
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
	    

	    private Object[] requestListHeader(GridData gdReq, SepoaInfo info) throws Exception{
	    	Object[]            result                = new Object[1];
	    	Map<String, String> resultInfo            = new HashMap<String, String>();
	    	Map<String, String> header                = this.getHeader(gdReq, info);
	    	String              houseCode             = info.getSession("HOUSE_CODE");
	    	String from_date			              = header.get("from_date");
			String to_date				              = header.get("to_date");
			String cust_code			              = header.get("cust_code");
			String project_code			              = header.get("project_code");
			String vendor_code			              = header.get("vendor_code");
			String item_no				              = header.get("item_no");
			String flag					              = header.get("flag");
		    	  
	    	resultInfo.put("from_date"            ,   from_date	     );
	    	resultInfo.put("to_date"              ,   to_date		 );   
	    	resultInfo.put("cust_code"            ,   cust_code	     );
	    	resultInfo.put("project_code"         ,   project_code	 );
	    	resultInfo.put("vendor_code"          ,   vendor_code	 );
	    	resultInfo.put("item_no"              ,   item_no		 );
	    	resultInfo.put("flag"                 ,   flag			 );
	    	
	    	result[0] = resultInfo;
	    	
	    	return result;
	    	
	    }
	    
	    private GridData getPrProceedingListGdRes(GridData gdReq, GridData gdRes, SepoaOut value) throws Exception{
	    	SepoaFormater sf               = new SepoaFormater(value.result[0]);
	    	String[]      gridColAry       = this.getGridColArray(gdReq);
	    	String        colKey           = null;
		    String        colValue         = null;
			int           rowCount         = sf.getRowCount();
			int           i                = 0;
			int           k                = 0;
			int           gridColAryLength = gridColAry.length;

	    	if(rowCount != 0){
	    		for(i = 0; i < rowCount; i++){
		    		for(k = 0; k < gridColAryLength; k++){
		    			colKey   = gridColAry[k];
		    			colValue = sf.getValue(colKey, i);
		    			
		    			if("SELECTED".equals(colKey)){
		    				gdRes.addValue("SELECTED", "0");
		    			}
		    			else{
		    				gdRes.addValue(colKey, colValue);
		    			}
		    		}
		    	}
	    	}
	    	
	    	return gdRes;
	    }
    
	    private String getExceptionStackTrace(Exception e){
			Writer      writer      = null;
			PrintWriter printWriter = null;
			String      s           = null;
			
			writer      = new StringWriter();
			printWriter = new PrintWriter(writer);
			
			e.printStackTrace(printWriter);
			
			s = writer.toString();
			
			return s;
		}
		
		private void loggerExceptionStackTrace(Exception e){
			String trace = this.getExceptionStackTrace(e);
			
			Logger.err.println(trace);
		}
}
