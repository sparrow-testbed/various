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

public class sta_bd_lis06 extends HttpServlet{
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
    		
    		if("getStaProVendorList".equals(mode)){
    			gdRes = this.getStaProVendorList(gdReq, info);
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
     * 업체별 구매현황 
     * getStaProVendorList
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-11-24
     * @modify 2014-11-24
     */
	private GridData getStaProVendorList(GridData gdReq, SepoaInfo info) {
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
	    	value    = ServiceConnector.doService(info, "p7008", "CONNECTION", "getStaProVendorList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		gdRes        = this.getStaProVendorListGdRes(gdReq, gdRes, value);
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
	    	String class_grade			              = header.get("class_grade");
	    	String vendor_name_loc		              = header.get("vendor_name_loc");
	    	String material_type		              = header.get("material_type");
	    	String maker_name			              = header.get("maker_name");
	    	String sec_vendor_code_text	              = header.get("sec_vendor_code_text");
	    	
	    	
	    	resultInfo.put("house_code"			      , houseCode			 );
	    	resultInfo.put("from_date"			      , from_date			 );
	    	resultInfo.put("to_date"				  , to_date				 );   
	    	resultInfo.put("class_grade"			  , class_grade			 );
	    	resultInfo.put("vendor_name_loc"		  , vendor_name_loc		 );
	    	resultInfo.put("material_type"		      , material_type		 );
	    	resultInfo.put("maker_name"			      , maker_name			 );
	    	resultInfo.put("sec_vendor_code_text"     , sec_vendor_code_text );
	    	
	    	
	    	result[0] = resultInfo;
	    	
	    	return result;
	    	
	    }
	    
	    private GridData getStaProVendorListGdRes(GridData gdReq, GridData gdRes, SepoaOut value) throws Exception{
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
