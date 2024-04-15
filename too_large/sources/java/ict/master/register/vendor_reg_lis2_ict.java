package ict.master.register;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class vendor_reg_lis2_ict  extends HttpServlet 
{
	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		// 세션 Object
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

		GridData gdReq = null;
		GridData gdRes = new GridData();
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");

		String mode = "";
		PrintWriter out = res.getWriter();

		try {
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
			if ("getRegVenLst".equals(mode)) {
				gdRes = getRegVenLst(gdReq, info);        // 조회
			}else if ("real_setUpdate_vngl".equals(mode)) {
				gdRes = real_setUpdate_vngl(gdReq, info); // 협력사 신용등급 등록(첨부파일 저장)
			}else if ("setVendorReg".equals(mode)) {
				gdRes = setVendorReg(gdReq, info);        // 협력사정보 저장
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
	 * 협력사 신용등급 등록
	 * real_setUpdate_vngl
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-24
	 * @modify 2014-10-24
	 */
	private GridData real_setUpdate_vngl(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	
    	Map<String, String> result               = new HashMap<String, String>();
    	
	    result.put("house_code"               , gdReq.getParam("house_code"));
		result.put("company_code"             , gdReq.getParam("company_code"));
		result.put("dept_code"                , gdReq.getParam("dept_code"));
		result.put("req_user_id"              , gdReq.getParam("req_user_id"));
		result.put("doc_type"                 , gdReq.getParam("doc_type"));
		result.put("fnc_name"                 , gdReq.getParam("fnc_name"));
		result.put("ctrl_dept"                , gdReq.getParam("ctrl_dept"));
		result.put("ctrl_flag"                , gdReq.getParam("ctrl_flag"));
		result.put("query_flag"               , gdReq.getParam("query_flag"));
		result.put("model_flag"               , gdReq.getParam("model_flag"));
		result.put("model_no"                 , gdReq.getParam("model_no"));
		result.put("material_type"            , gdReq.getParam("material_type"));
		result.put("material_ctrl_type"       , gdReq.getParam("material_ctrl_type"));
		result.put("material_class1"          , gdReq.getParam("material_class1"));
		result.put("material_class2"          , gdReq.getParam("material_class2"));
		result.put("pr_flag"                  , gdReq.getParam("pr_flag"));
		result.put("material_class2_name"     , gdReq.getParam("material_class2_name"));
		result.put("basic_unit"               , gdReq.getParam("basic_unit"));
		result.put("item_abbreviation"        , gdReq.getParam("item_abbreviation"));
		result.put("app_tax_code"             , gdReq.getParam("app_tax_code"));
		result.put("item_block_flag"          , gdReq.getParam("item_block_flag"));
		result.put("attach_no"                , gdReq.getParam("attach_no"));
		result.put("vendor_code"              , gdReq.getParam("vendor_code"));
		result.put("att_mode"                 , gdReq.getParam("att_mode"));
		result.put("view_type"                , gdReq.getParam("view_type"));
		result.put("file_type"                , gdReq.getParam("file_type"));
		result.put("tmp_att_no"               , gdReq.getParam("tmp_att_no"));		
		result.put("credit_rating"            , gdReq.getParam("credit_rating"));		
    	
		
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);
    	
		
    	try {
    		
    		gdRes.addParam("mode", "doSaveEnd");
    		gdRes.setSelectable(false);
    		
    		Object[] obj = {result};
    		
    		value = ServiceConnector.doService(info, "t0002", "TRANSACTION","real_setUpdate_vngl", obj);
    		
    		gdRes.setMessage(value.message);
    		gdRes.setStatus(Boolean.toString(value.flag));
    		
    	}
    	catch(Exception e){
    		
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
	}


	/* ict 사용 : 협력사 현황*/
	private GridData getRegVenLst(GridData gdReq, SepoaInfo info) throws Exception {
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
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "doQuery");
	
	    	Object[] obj = {header};

	    	value = ServiceConnector.doService(info, "I_p0070", "CONNECTION","getRegVenLst",obj);
	
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

	public GridData setVendorReg(GridData gdReq, SepoaInfo info) throws Exception{
		GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		Object[] obj = {data};
    		value = ServiceConnector.doService(info, "p0070", "TRANSACTION", "setVendorReg",       obj);
    		
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
	


}

