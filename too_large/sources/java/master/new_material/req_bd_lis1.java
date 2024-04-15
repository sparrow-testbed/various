package master.new_material;

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

public class req_bd_lis1 extends HttpServlet{
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
    		
    		if("newmtrl_bd_lis2_getQuery".equals(mode)){
    			gdRes = this.newmtrl_bd_lis2_getQuery(gdReq, info);
    		}
    		else if("setDelete".equals(mode)){
    			gdRes = this.setDelete(gdReq, info);
    		}
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
	private Map<String, String> newmtrlBdLis2QetQueryHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> header            = null;
    	Map<String, Object> allData           = null;
    	String              createDateFrom    = null;
    	String              createDateTo      = null;
    	String              description       = null;
    	String              selProceedingType = null;
    	String              houseCode         = info.getSession("HOUSE_CODE");
    	String              reqUserId         = null;
    	
    	allData           = SepoaDataMapper.getData(info, gdReq);
    	header            = MapUtils.getMap(allData, "headerData");
    	createDateFrom    = header.get("create_date_from");
    	createDateFrom    = SepoaString.getDateUnSlashFormat(createDateFrom);
    	createDateTo      = header.get("create_date_to");
    	createDateTo      = SepoaString.getDateUnSlashFormat(createDateTo);
    	description       = header.get("description");
    	selProceedingType = header.get("sel_proceeding_type");
    	reqUserId         = header.get("req_user_id");
    	
    	header.clear();
    	
    	header.put("HOUSE_CODE",      houseCode);
    	header.put("REQ_DATE_FROM",   createDateFrom);
    	header.put("REQ_DATE_TO",     createDateTo);
    	header.put("REQ_USER_ID",     reqUserId);
    	header.put("DESCRIPTION_LOC", description);
    	header.put("CONFIRM_STATUS",  selProceedingType);
    	
    	return header;
    }

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData newmtrl_bd_lis2_getQuery(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	header     = this.newmtrlBdLis2QetQueryHeader(gdReq, info);
	
	    	gdRes.addParam("mode", "query");
	
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "t0002", "CONNECTION", "newmtrl_bd_lis2_getQuery", obj);
	
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
			    			
			    			else if("REJECT_REMARK".equals(gridColAry[k])){
			    				if(!"".equals(this.nvl(sf.getValue(gridColAry[k], i)))){
			    					gdRes.addValue(gridColAry[k], "<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''> ");
//			    					gdRes.addValue(gridColAry[k], "<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''> " + sf.getValue(gridColAry[k], i));
			    				}else{
			    					gdRes.addValue(gridColAry[k], "");
			    				}
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
	
	@SuppressWarnings("unchecked")
	private List<Map<String, String>> setDeleteSvcParam(GridData gdReq, SepoaInfo info) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid       = null;
		Map<String, Object>       data       = SepoaDataMapper.getData(info, gdReq);
		Map<String, String>       gridInfo   = null;
		Map<String, String>       resultInfo = null;
		String                    id         = info.getSession("ID");
		String                    houseCode  = info.getSession("HOUSE_CODE");
		String                    reqItemNo  = null;
		int                       gridSize   = 0;
		int                       i          = 0;
		
		grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
		gridSize = grid.size();
		
		for(i = 0; i < gridSize; i++){
			resultInfo = new HashMap<String, String>();
			
			gridInfo  = grid.get(i);
			reqItemNo = gridInfo.get("REQ_ITEM_NO");
			
			resultInfo.put("STATUS",         "D");
			resultInfo.put("CHANGE_USER_ID", id);
			resultInfo.put("HOUSE_CODE",     houseCode);
			resultInfo.put("REQ_ITEM_NO",    reqItemNo);
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setDelete(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes       = new GridData();
    	Vector                    multilangId = new Vector();
    	HashMap                   message     = null;
    	SepoaOut                  value       = null;
    	Map<String, Object>       data        = new HashMap<String, Object>();
    	List<Map<String, String>> svcParam    = this.setDeleteSvcParam(gdReq, info);
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data.put("svcParam", svcParam);
    		
    		Object[] obj = {data};
    		
    		value = ServiceConnector.doService(info, "t0002", "TRANSACTION", "req_setDelete", obj);
    		
    		gdRes.setMessage(value.message);
    		gdRes.setStatus(Boolean.toString(value.flag));
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
    
    /**
     * String이 널일경우 "", 아닐경우 자기 자신 반환
     * @param string
     * @return
     * @throws Exception
     */
    private String nvl(String string) throws Exception{
    	String result = null;
    	
    	if(string == null){
    		result = "";
    	}
    	else{
    		result = string;
    	}
    	
    	return result;
    }
}