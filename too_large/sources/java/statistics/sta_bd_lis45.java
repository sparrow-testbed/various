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

public class sta_bd_lis45  extends HttpServlet{
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
    		
    		if("getSmaglList".equals(mode)){
    			gdRes = this.getSmaglList(gdReq, info);
    		} else if("getSmaglListHistory".equals(mode)) {
    			gdRes = this.getSmaglListHistory(gdReq, info);
    		} else if("doDelete".equals(mode)) {
    			gdRes = this.doDelete(gdReq, info);
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
     * 간판설치현황리스트
     * getStaUPItemList
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-02-12
     * @modify
     */
	private GridData getSmaglList(GridData gdReq, SepoaInfo info) {
		
		GridData gdRes  			= new GridData();
	    SepoaOut value          	= null;
	    HashMap message       	= null;
	    String gdResMessage   	= null;
	    Object[] obj              	= null;
	    boolean isStatus       	= false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.requestListHeader(gdReq, info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	value    = ServiceConnector.doService(info, "p7009", "CONNECTION", "getSmaglList", obj);
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
	
	/**
	 * 간판설치현황리스트History
	 * getSmaglListHistory
	 * @param  gdReq
	 * @param  info
	 * @return GridData2
	 * @throws Exception
	 * @since  2015-02-12
	 * @modify
	 */
	private GridData getSmaglListHistory(GridData gdReq, SepoaInfo info) {
		
		GridData gdRes  			= new GridData();
		SepoaOut value          	= null;
		HashMap message       	= null;
		String gdResMessage   	= null;
//		Object[] obj              	= null;
		boolean isStatus       	= false;
		
		try {
			
			String house_code 		= JSPUtil.CheckInjection(gdReq.getParam("house_code")).trim();
	        String key_no 				= JSPUtil.CheckInjection(gdReq.getParam("key_no")).trim();
	        String branches_code 	= JSPUtil.CheckInjection(gdReq.getParam("branches_code")).trim();
	        String item_no 			= JSPUtil.CheckInjection(gdReq.getParam("item_no")).trim();
	        String io_number 			= JSPUtil.CheckInjection(gdReq.getParam("io_number")).trim();
			
			message  = this.getMessage(info);
//			obj      = this.requestListHeaderHistory(gdReq, info);
//			obj = {info, house_code, key_no, branches_code, item_no, io_number};
			Object[] obj = {info, house_code, key_no, branches_code, item_no, io_number};
			gdRes    = OperateGridData.cloneResponseGridData(gdReq);
			value    = ServiceConnector.doService(info, "p7009", "CONNECTION", "getSmaglListHistory", obj);
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
	
	public GridData doDelete(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		try {
			gdRes.addParam("mode", "doDelete");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "p7009", "TRANSACTION","doDelete", obj);
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
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
	    	String houseCode					= info.getSession("HOUSE_CODE");
	    	String branches_from_code	= header.get("branches_from_code");
			String branches_to_code		= header.get("branches_to_code");
			String confirm_from_date		= header.get("confirm_from_date");
			String confirm_to_date			= header.get("confirm_to_date");
			String item_no			           	= header.get("item_no");
			String install_store				= header.get("install_store");
			String signform					   	= header.get("signform");
			String remove_flag				= header.get("remove_flag");
		    	  
	    	resultInfo.put("branches_from_code"	,   branches_from_code);
	    	resultInfo.put("branches_to_code"		,   branches_to_code);
	    	resultInfo.put("confirm_from_date"		,   confirm_from_date);
	    	resultInfo.put("confirm_to_date"			,   confirm_to_date);
	    	resultInfo.put("item_no"						,   item_no);
	    	resultInfo.put("install_store"				,   install_store);
	    	resultInfo.put("signform"					,   signform);
	    	resultInfo.put("remove_flag"				,   remove_flag);
	    	
	    	result[0] = resultInfo;
	    	
	    	return result;
	    	
	    }
	    
	    private Object[] requestListHeaderHistory(GridData gdReq, SepoaInfo info) throws Exception{
	    	Object[]            result                = new Object[1];
	    	Map<String, String> resultInfo            = new HashMap<String, String>();
	    	Map<String, String> header                = this.getHeader(gdReq, info);
	    	String houseCode					= info.getSession("HOUSE_CODE");
	    	String branches_from_code	= header.get("branches_from_code");
	    	String branches_to_code		= header.get("branches_to_code");
	    	String confirm_from_date		= header.get("confirm_from_date");
	    	String confirm_to_date			= header.get("confirm_to_date");
	    	String item_no			           	= header.get("item_no");
	    	String install_store				= header.get("install_store");
	    	String signform					   	= header.get("signform");
	    	
	    	resultInfo.put("branches_from_code"	,   branches_from_code);
	    	resultInfo.put("branches_to_code"		,   branches_to_code);
	    	resultInfo.put("confirm_from_date"		,   confirm_from_date);
	    	resultInfo.put("confirm_to_date"			,   confirm_to_date);
	    	resultInfo.put("item_no"						,   item_no);
	    	resultInfo.put("install_store"				,   install_store);
	    	resultInfo.put("signform"					,   signform);
	    	
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
		    			} else if("REMARK_IMAGE".equals(colKey)) {
							if( colValue !=null && !("".equals(colValue.trim())) ){
								gdRes.addValue(colKey, "<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''>");
							}else{
								gdRes.addValue(colKey, "");
							}
		    			} else if("IMAGE".equals(colKey)) {
		    				gdRes.addValue(colKey, "<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''>");
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
