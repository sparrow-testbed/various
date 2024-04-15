package ict.supply.bidding.rfq;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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

import com.icompia.util.CommonUtil;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rfq_bd_upd1 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("setRfqSubmit2".equals(mode)){
    			gdRes = this.setRfqSubmit2(gdReq, info);   
    		}else if("setRfqGiveUp2".equals(mode)){
    			gdRes = this.setRfqGiveUp2(gdReq, info);   
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
    
        
    //[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
    @SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
    private GridData setRfqSubmit2(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes           = null;
    	HashMap                   message         = null;
    	SepoaOut                  value           = null;
    	Map<String, Object>       data            = null;
    	Map<String, Object>       svcParam        = null;
    	Map<String, String>       header          = null;
    	
    	String                    id              = info.getSession("ID");
    	String                    nameLoc         = info.getSession("NAME_LOC");
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	
    	message = this.setRfqCreateMessage(info);

    	try {
    		svcParam      = new HashMap<String, Object>();
    		data          = SepoaDataMapper.getData(info, gdReq);
    		header        = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
    		
    		header.put("SUBMIT_USER_ID",   id);
    		header.put("SUBMIT_USER_NAME", nameLoc);
    		header.put("SUBMIT_DATE",      shortDateString);
    		header.put("SUBMIT_TIME",      shortTimeString);
    		
    		//System.out.println(gdReq.getParam("I_PFLAG"));
    		
    		svcParam.put("header",      header);    		
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "I_s2011", "TRANSACTION", "setRfqSubmit2", obj);
    		gdRes = this.setRfqCreateGdRes(value, message);
    	}
    	catch(Exception e){
    		gdRes = new GridData();//결과를 XML형태로 보내주기 위해 생성
    		gdRes.setSelectable(false);//true : 커넥션 / false : 트랜잭션
    		
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
    private GridData setRfqGiveUp2(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes           = null;
    	HashMap                   message         = null;
    	SepoaOut                  value           = null;
    	Map<String, Object>       data            = null;
    	Map<String, Object>       svcParam        = null;
    	Map<String, String>       header          = null;
    	
    	String                    id              = info.getSession("ID");
    	String                    nameLoc         = info.getSession("NAME_LOC");
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	
    	message = this.setRfqCreateMessage(info);

    	try {
    		svcParam      = new HashMap<String, Object>();
    		data          = SepoaDataMapper.getData(info, gdReq);
    		header        = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
    		
    		header.put("SUBMIT_USER_ID",   id);
    		header.put("SUBMIT_USER_NAME", nameLoc);
    		header.put("SUBMIT_DATE",      shortDateString);
    		header.put("SUBMIT_TIME",      shortTimeString);
    		
    		//System.out.println(gdReq.getParam("I_PFLAG"));
    		
    		svcParam.put("header",      header);    		
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "I_s2011", "TRANSACTION", "setRfqGiveUp", obj);
    		gdRes = this.setRfqCreateGdRes(value, message);
    	}
    	catch(Exception e){
    		gdRes = new GridData();//결과를 XML형태로 보내주기 위해 생성
    		gdRes.setSelectable(false);//true : 커넥션 / false : 트랜잭션
    		
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap setRfqCreateMessage(SepoaInfo info) throws Exception{
    	Vector  multilangId = new Vector();
    	HashMap message     = null;
    	
    	multilangId.addElement("MESSAGE");
    	   
    	message = MessageUtil.getMessage(info, multilangId);
    	
    	return message;
    }
    
    @SuppressWarnings("rawtypes")
	private GridData setRfqCreateGdRes(SepoaOut value, HashMap message) throws Exception{
    	GridData gdRes = new GridData();
    	
    	gdRes.addParam("mode", "doSave");
		gdRes.setSelectable(false);
		
    	if(value.flag) {
			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			gdRes.setStatus("true");
		}
		else {
			gdRes.setMessage(value.message);
			gdRes.setStatus("false");
		}
    	
    	return gdRes;
    }
    
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if("".equals(str)){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
	
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
}