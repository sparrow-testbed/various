package sepoa.svl.co;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import com.raonsecure.touchen.KeyboardSecurity;
import com.raonsecure.touchenkey.TouchEn_Crypto;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.Base64;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.CryptoUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.fw.util.SepoaDate;
import wise.util.WiseEncrypt;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.nprotect.pluginfree.modules.PluginFreeConfig;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.Enumeration;
import java.util.Collections;
import java.util.Iterator;
import com.nprotect.pluginfree.PluginFree;
import com.nprotect.pluginfree.PluginFreeDTO;
import com.nprotect.pluginfree.PluginFreeException;
import com.nprotect.pluginfree.PluginFreeWarning;
import com.nprotect.pluginfree.PluginFreeDeviceDTO;
import com.nprotect.pluginfree.modules.PluginFreeRequest;
import com.nprotect.pluginfree.util.RequestUtil;
import com.nprotect.pluginfree.util.StringUtil;
import com.nprotect.pluginfree.transfer.InitechTransferImpl;
import java.util.StringTokenizer;
import sepoa.fw.util.pwdPolicy;

public class co_login_process extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private String login_type   = "";
	
	public void init(javax.servlet.ServletConfig config) throws ServletException {Logger.debug.println();}
	    
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
	    	
    	String user_id      = "";
    	String password     = "";
    	String new_password = "";
    	String new_password_confirm = "";
    	String param1       = "";
    	String verifierKey  = "";
    	String gb           = "";
    	String from_site    = "";

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		from_site  = JSPUtil.CheckInjection(gdReq.getParam("FromSite"));
    		
    		
//    		//차세대적용으로 인한 운영중단 20180504 ~ 20180507    /////////////////////////////////////////////////////////////////////////////
//    		String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
//    		String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
//    		if("20180504".equals(current_date) || "20180505".equals(current_date) || "20180506".equals(current_date)){      			
//    			if(!"1.232.5.3".equals(req.getRemoteAddr()) && !"1.232.5.6".equals(req.getRemoteAddr())){
//    				if("setLogin".equals(mode) || "setXecureLogin".equals(req.getAttribute("mode")) || "setDirectLogin".equals(mode) ){
//        				throw new Exception("연휴기간 우리은행 전자구매 접속중단 5월 8일부터 접속 가능합니다."); 
//        			}
//    			}
//    		}
//    		if("20180507".equals(current_date)){      			
//    			if(!"1.232.5.3".equals(req.getRemoteAddr()) && !"1.232.5.6".equals(req.getRemoteAddr())){
//    				if("setLogin".equals(mode) || "setXecureLogin".equals(req.getAttribute("mode"))){
//        				throw new Exception("연휴기간 우리은행 전자구매 접속중단 5월 8일부터 접속 가능합니다."); 
//        			}
//    			}
//    		}
//    		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    		
    		
    		
    		if("setLogin".equals(mode)){
//    			user_id = req.getParameter("user_id");	//KeyboardSecurity.getTouchEnKey(req, "user_id");
//              R101806158471  - [서비스개발] (변원상) 2018년 우리은행 전자금융기반시설 취약점 분석평가 취약점 조치 요청(전자구매시스템) 
    			user_id = JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(req.getParameter("user_id")));    			
    			password = KeyboardSecurity.getTouchEnKey(req, "password");
    			gdRes = this.setLogin(gdReq, info, user_id, password, "", req);
            
    		}else if("setLogin2".equals(mode)){   
    			javax.servlet.ServletRequest pluginfreeRequest = new PluginFreeRequest(req);
    			
    			user_id =  JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(req.getParameter("user_id")));    			
    			//password = JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(req.getParameter("password")));
    			password = JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(pluginfreeRequest.getParameter("password")));
    			gdRes = this.setLogin(gdReq, info, user_id, password, "", req);
    		    			
    		}else if("setDirectLogin".equals(mode)){

    			param1 = req.getParameter("param1");
    			gdRes = this.setDirectLogin(gdReq, info, req, param1);
    		}else if("setXecureLogin".equals(req.getAttribute("mode"))){
    			
    			mode = "setXecureLogin";
    			verifierKey = (String) req.getAttribute("verifier_key");
    			
    			gdRes = this.setXecureLogin(gdReq, info, req, verifierKey);
    		}else if("setPwdNew".equals(mode)){ 
    			user_id = req.getParameter("user_id");	//KeyboardSecurity.getTouchEnKey(req, "user_id");
    			password = KeyboardSecurity.getTouchEnKey(req, "password");
    			new_password = KeyboardSecurity.getTouchEnKey(req, "new_password");
    			gdRes = this.setLogin(gdReq, info, user_id, password, new_password, req);
    		}else if("setPwdNew2".equals(mode)){
    			javax.servlet.ServletRequest pluginfreeRequest = new PluginFreeRequest(req);
    			
    			user_id = req.getParameter("user_id");	//KeyboardSecurity.getTouchEnKey(req, "user_id");
        		//password = req.getParameter("password");        //KeyboardSecurity.getTouchEnKey(req, "password");
    			password = pluginfreeRequest.getParameter("password");
        		new_password = pluginfreeRequest.getParameter("new_password");//KeyboardSecurity.getTouchEnKey(req, "new_password");
        		new_password_confirm = pluginfreeRequest.getParameter("new_password_confirm");
        		
        		if(!"".equals(new_password)) {
        			if(new_password.equals(password)) {
        				gdRes.setStatus("false");
        				gdRes.setMessage("기존 비밀번호와 새 비밀번호는 동일할 수 없습니다.");        				        				
        			}
        			
        			if(!"false".equals(gdRes.getStatus())){
	        			if(!new_password.equals(new_password_confirm)) {
	        				gdRes.setStatus("false");
	        				gdRes.setMessage("새 패스워드 두개가 일치하지 않습니다.");        		        				
	        			}
        			}
        			
        			if(!"false".equals(gdRes.getStatus())){
	        			String msgValidPwd = sepoa.fw.util.pwdPolicy.isNewValidPwd(user_id, new_password); 
	        		    if(!"".equals(msgValidPwd)){
	        		    	gdRes.setStatus("false");
	        				gdRes.setMessage(msgValidPwd);        		        			
	        		    }
        			}
        		}
        		
        		if(!"false".equals(gdRes.getStatus())){
        			gdRes = this.setLogin(gdReq, info, user_id, password, new_password, req);
        		}        		    			        		
        	}else if("setLoginLocal".equals(mode)){ 
    			
    			user_id = req.getParameter("user_id");	//KeyboardSecurity.getTouchEnKey(req, "user_id");
    			password = req.getParameter("password");	//KeyboardSecurity.getTouchEnKey(req, "user_id");
    			//password = KeyboardSecurity.getTouchEnKey(req, "password");
    			gdRes = this.setLoginLocal(gdReq, info, req, user_id, password);
    			
    		}else{
    			gdRes.setStatus("false");
    		}
    		
    	}
    	catch (Exception e) {

    		Logger.err.println(e.getMessage());
    		gdRes.setMessage(e.getMessage());
    		gdRes.setStatus("false");

    	}
    	finally {
    		try{

    			SepoaSession.putValue(req, "logStatus", gdRes.getStatus());
    			SepoaSession.putValue(req, "mode"     , mode);
    			SepoaSession.putValue(req, "user_id"  , user_id);
    			SepoaSession.putValue(req, "msg"      , gdRes.getMessage());
    			String url = "/common/login_process.jsp";
    			if("ICT".equals(from_site)){
    				url = "/common/login_process_ict.jsp";
    			}else if("ICT2".equals(from_site)){
    				url = "/common/login_process_ict2.jsp";
    			}else if("GAD2".equals(from_site)){
    				url = "/common/login_process2.jsp";
    			}else{
    				url = "/common/login_process.jsp";
    			}
    			RequestDispatcher rd = req.getRequestDispatcher(url);
    			rd.forward(req, res);
  			

    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }

    
    /**
     * 키보드보안로그인(ID,PW 로그인)
     * setLogin
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setLogin(GridData gdReq, SepoaInfo info, String user_id, String password, String new_password, HttpServletRequest request) throws Exception{
	    GridData            gdRes        = new GridData();
	    SepoaFormater       sf           = null;
	    SepoaOut            value        = null;
	    Vector              v            = new Vector();
	    HashMap             message      = null;
	    Map<String, Object> allData      = null;
	    Map<String, String> header       = null;
	    String              gridColId    = null;
	    int                 rowCount     = 0;
	    String              pwdMd5       = "";
	    String              pwdSha       = "";
	    String              mode         = "";
	    String              os_gb        = "";
		login_type = JSPUtil.nullToEmpty(request.getParameter("login_type")) ;
	    
    	String     houseCode    = "000";//info.getSession("HOUSE_CODE");
	    
	    v.addElement("MESSAGE");
	
	    //message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	//gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	//gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	WiseEncrypt wiseEnc = new WiseEncrypt();
	    	pwdMd5       = wiseEnc.getMD5(password);
	    	pwdSha       = CryptoUtil.getSHA256(password);			    	  
	    	mode         = request.getParameter("mode");
	    		    	
	    	if(new_password != null && !"".equals(new_password)){
	    		new_password  = CryptoUtil.getSHA256(new_password);
	    	}
	    	
	    	os_gb        = JSPUtil.nullToEmpty(request.getParameter("os_gb"));
	    	
	    	
	    	String strFromSite  = request.getParameter("FromSite");
	    	header.put("FromSite" , strFromSite);		  
//	    	if ("ICT".equals(strFromSite)){
//	    		header.put("FromSite" , strFromSite);		    	
//	    	}else if ("GAD".equals(strFromSite)){
//	    		header.put("FromSite" , strFromSite);		    	
//	    	}else{
//	    		header.put("FromSite" , "");		    	
//	    	}
	    	
	    	header.put("user_id"      , user_id);
	    	header.put("password"     , password);
	    	header.put("pwdMd5"       , pwdMd5);
	    	header.put("pwdSha"       , pwdSha);
	    	header.put("house_code"   , houseCode);
	    	header.put("language"     , "KO");
	    	header.put("userIp"       , request.getRemoteAddr());
	    	header.put("mode"         , mode);
	    	header.put("new_password" , new_password);
	    	Object[] obj = {header};

	    	value = ServiceConnector.doService(info, "CO_004", "CONNECTION","setLoginMap2", obj);
	
	    	if(value.flag){// 조회 성공
	    		
	    		sf= new SepoaFormater(value.result[0]);
		    	rowCount = sf.getRowCount(); // 조회 row 수

		    	if(rowCount > 0){
		    			gdRes.setStatus("true");
		    		
		    			Config sepoa_login_process_con = new Configuration();
		    	    	String buyer_compnay_code = sepoa_login_process_con.getString("sepoa.buyer.company.code");//BUYER Company Code 추가 2012.07.25
		    	    	
		    	    	boolean isReal = Boolean.parseBoolean(CommonUtil.getConfig("sepoa.isReal"));
		    	    	
		    	    	if("WOORI".equals(sf.getValue("COMPANY_CODE", 0)) && isReal){
		    	    		gdRes.setMessage("내부사용자는 그룹웨어를 통하여 로그인하여 주십시오.");
				    		gdRes.setStatus("false");
		    	    	}else{
		    	    		SepoaSession.putValue(request, "BUYER_COMPANY_CODE", buyer_compnay_code);
			    			SepoaSession.putValue(request, "COMPANY_CODE", sf.getValue("COMPANY_CODE", 0));
			    			SepoaSession.putValue(request, "DEPARTMENT", sf.getValue("DEPARTMENT", 0));
			    			SepoaSession.putValue(request, "NAME_LOC", sf.getValue("NAME_LOC", 0));
			    			SepoaSession.putValue(request, "NAME_ENG", sf.getValue("NAME_ENG", 0));
			    			SepoaSession.putValue(request, "PLANT_CODE", sf.getValue("PLANT_CODE", 0));
			    			SepoaSession.putValue(request, "LOCATION_CODE", sf.getValue("LOCATION_CODE", 0));
			    			SepoaSession.putValue(request, "DEPARTMENT_NAME_LOC", sf.getValue("DEPARTMENT_NAME_LOC", 0));
			    			SepoaSession.putValue(request, "DEPARTMENT_NAME_ENG", sf.getValue("DEPARTMENT_NAME_ENG", 0));
			    			SepoaSession.putValue(request, "DEPARTMENT_CODE", sf.getValue("DEPARTMENT_CODE", 0));
			    			SepoaSession.putValue(request, "LANGUAGE", sf.getValue("LANGUAGE", 0));
			    			SepoaSession.putValue(request, "COUNTRY", sf.getValue("COUNTRY", 0));
			    			SepoaSession.putValue(request, "EMPLOYEE_NO", sf.getValue("EMPLOYEE_NO", 0));
			    			SepoaSession.putValue(request, "TEL", sf.getValue("TEL", 0));
			    			SepoaSession.putValue(request, "MOBILE_NO", sf.getValue("MOBILE_NO", 0));
			    			SepoaSession.putValue(request, "ID", sf.getValue("ID", 0));
			    			SepoaSession.putValue(request, "POSITION", sf.getValue("POSITION", 0));
			    			SepoaSession.putValue(request, "CITY", sf.getValue("CITY", 0));
			    			SepoaSession.putValue(request, "LOCATION_NAME", sf.getValue("LOCATION_NAME", 0));
			    			SepoaSession.putValue(request, "EMAIL", sf.getValue("EMAIL", 0));
			    			SepoaSession.putValue(request, "CTRL_CODE", sf.getValue("CTRL_CODE", 0));
			    			SepoaSession.putValue(request, "OWN_CTRL_CODE_LIST", sf.getValue("OWN_CTRL_CODE_LIST", 0));
			    			SepoaSession.putValue(request, "WORK_TYPE", sf.getValue("WORK_TYPE", 0));
			    			SepoaSession.putValue(request, "USER_TYPE", sf.getValue("USER_TYPE", 0));
			    			SepoaSession.putValue(request, "IS_ADMIN_USER", sf.getValue("IS_ADMIN_USER", 0));
			    			SepoaSession.putValue(request, "MENU_PROFILE_CODE", sf.getValue("MENU_PROFILE_CODE", 0));
			    			
//노창국차장 요청
//정인길차장이 공인인증모듈 업그레이드 프로젝트 지연으로 인하여
//레거시 공인인증모듈로 운영이불가하여 
//업체로그인시 공인인증시 매뉴와 동일하게 설정 
			    			if("BD".equals(login_type) && "S".equals(sf.getValue("USER_TYPE", 0))){
			    				SepoaSession.putValue(request, "MENU_PROFILE_CODE", "MUP141200003");
			    			}

			    			SepoaSession.putValue(request, "USER_IP", request.getRemoteAddr());
			    			SepoaSession.putValue(request, "HOUSE_CODE", "100");
			    			SepoaSession.putValue(request, "USER_OS_LANGUAGE", header.get("language"));
			    			SepoaSession.putValue(request, "COMPANY_NAME", sf.getValue("COMPANY_NAME", 0));
			    			SepoaSession.putValue(request, "QM_CTRL_CODE", sf.getValue("QM_CTRL_CODE", 0));
			    			SepoaSession.putValue(request, "MM_CTRL_CODE", sf.getValue("MM_CTRL_CODE", 0));
			    			SepoaSession.putValue(request, "SHIPPER_TYPE", sf.getValue("SHIPPER_TYPE", 0));
			    			SepoaSession.putValue(request, "CTRL_TYPE_CODE_LIST", sf.getValue("CTRL_TYPE_CODE_LIST", 0));
			    			SepoaSession.putValue(request, "SELLER_PP_TYPE", sf.getValue("SELLER_PP_TYPE", 0));
			    			SepoaSession.putValue(request, "AFFILIATED_COMPANY_FLAG", sf.getValue("AFFILIATED_COMPANY_FLAG", 0));
			    			SepoaSession.putValue(request, "HOUSE_CODE", sf.getValue("HOUSE_CODE", 0));
			    			SepoaSession.putValue(request, "IRS_NO", sf.getValue("IRS_NO", 0));
			    			SepoaSession.putValue(request, "VIEW_USER_TYPE", sf.getValue("VIEW_USER_TYPE", 0));
			    			SepoaSession.putValue(request, "FROM_SITE", sf.getValue("FROM_SITE", 0));			    			
			    			SepoaSession.putValue(request, "BD_ADMIN", sf.getValue("BD_ADMIN", 0));			    			
			    			SepoaSession.putValue(request, "OS_GB", os_gb);		
			    			SepoaSession.putValue(request, "GB_GJ", sf.getValue("GB_GJ", 0));
			    			
			    			SepoaSession.putValue(request, "PURCHASE_BLOCK_FLAG", sf.getValue("PURCHASE_BLOCK_FLAG", 0));
			    			
			    			SepoaSession.putValue(request, "JUMJUMGB", sf.getValue("JUMJUMGB", 0));
			    			SepoaSession.putValue(request, "MOJMOJCD", sf.getValue("MOJMOJCD", 0));
		    	    	}
		    	   }
		    	else{
		    		gdRes.setMessage(value.message);
		    		gdRes.setStatus("false");
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage("");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}

    /**
     * 공인인증서 로그인
     * setXecureLogin
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	private GridData setXecureLogin(GridData gdReq, SepoaInfo info, HttpServletRequest request, String verifierKey) throws Exception {
    	GridData            gdRes      = new GridData();
 	    SepoaFormater       sf         = null;
 	    SepoaOut            value      = null;
 	    Vector              v          = new Vector();
 	    HashMap             message    = null;
 	    Map<String, Object> allData    = null;
 	    Map<String, String> header     = null;
 	    String              gridColId  = null;
 	    int                 rowCount   = 0;

 	    String              os_gb       = "";
		
     	String                    houseCode    = info.getSession("HOUSE_CODE");
 	    
 	    v.addElement("MESSAGE");
 	    message = MessageUtil.getMessage(info, v);
 	
 	    try{ 	    	
 	    	allData    = SepoaDataMapper.getData(info, gdReq);
 	    	header     = MapUtils.getMap(allData, "headerData");
 	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
 	
 	    	os_gb        = JSPUtil.nullToEmpty(request.getParameter("rdoWin")); 	    	
 	    	
 	    	header.put("verifierKey", verifierKey);
 	    	header.put("house_code", houseCode);


 	    	Object[] obj = {header};
 	    	value = ServiceConnector.doService(info, "CO_004", "CONNECTION","setXecureLogin", obj);
 	
 	    	if(value.flag){// 조회 성공
 	    		
 	    		sf= new SepoaFormater(value.result[0]);
 		    	rowCount = sf.getRowCount(); // 조회 row 수
 		
 		    	if(rowCount > 0){
 		    		gdRes.setStatus("true");
 		    		
 		    			Config sepoa_login_process_con = new Configuration();
 		    	    	String buyer_compnay_code = sepoa_login_process_con.getString("sepoa.buyer.company.code");//BUYER Company Code 추가 2012.07.25

 		    			SepoaSession.putValue(request, "BUYER_COMPANY_CODE", buyer_compnay_code);
 		    			SepoaSession.putValue(request, "COMPANY_CODE", sf.getValue("COMPANY_CODE", 0));
 		    			SepoaSession.putValue(request, "DEPARTMENT", sf.getValue("DEPARTMENT", 0));
 		    			SepoaSession.putValue(request, "NAME_LOC", sf.getValue("NAME_LOC", 0));
 		    			SepoaSession.putValue(request, "NAME_ENG", sf.getValue("NAME_ENG", 0));
 		    			SepoaSession.putValue(request, "PLANT_CODE", sf.getValue("PLANT_CODE", 0));
 		    			SepoaSession.putValue(request, "LOCATION_CODE", sf.getValue("LOCATION_CODE", 0));
 		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_LOC", sf.getValue("DEPARTMENT_NAME_LOC", 0));
 		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_ENG", sf.getValue("DEPARTMENT_NAME_ENG", 0));
 		    			SepoaSession.putValue(request, "LANGUAGE", sf.getValue("LANGUAGE", 0));
 		    			SepoaSession.putValue(request, "COUNTRY", sf.getValue("COUNTRY", 0));
 		    			SepoaSession.putValue(request, "EMPLOYEE_NO", sf.getValue("EMPLOYEE_NO", 0));
 		    			SepoaSession.putValue(request, "TEL", sf.getValue("TEL", 0));
 		    			SepoaSession.putValue(request, "MOBILE_NO", sf.getValue("MOBILE_NO", 0));
 		    			SepoaSession.putValue(request, "ID", sf.getValue("ID", 0));
 		    			SepoaSession.putValue(request, "POSITION", sf.getValue("POSITION", 0));
 		    			SepoaSession.putValue(request, "CITY", sf.getValue("CITY", 0));
 		    			SepoaSession.putValue(request, "LOCATION_NAME", sf.getValue("LOCATION_NAME", 0));
 		    			SepoaSession.putValue(request, "EMAIL", sf.getValue("EMAIL", 0));
 		    			SepoaSession.putValue(request, "CTRL_CODE", sf.getValue("CTRL_CODE", 0));
 		    			SepoaSession.putValue(request, "OWN_CTRL_CODE_LIST", sf.getValue("OWN_CTRL_CODE_LIST", 0));
 		    			SepoaSession.putValue(request, "USER_TYPE", sf.getValue("USER_TYPE", 0));
 		    			SepoaSession.putValue(request, "IS_ADMIN_USER", sf.getValue("IS_ADMIN_USER", 0));
 		    			SepoaSession.putValue(request, "MENU_PROFILE_CODE", sf.getValue("MENU_PROFILE_CODE", 0));
 		    			SepoaSession.putValue(request, "USER_IP", request.getRemoteAddr());
 		    			SepoaSession.putValue(request, "USER_OS_LANGUAGE", header.get("language"));
 		    			SepoaSession.putValue(request, "COMPANY_NAME", sf.getValue("COMPANY_NAME", 0));
 		    			SepoaSession.putValue(request, "QM_CTRL_CODE", sf.getValue("QM_CTRL_CODE", 0));
 		    			SepoaSession.putValue(request, "MM_CTRL_CODE", sf.getValue("MM_CTRL_CODE", 0));
 		    			SepoaSession.putValue(request, "SHIPPER_TYPE", sf.getValue("SHIPPER_TYPE", 0));
 		    			SepoaSession.putValue(request, "CTRL_TYPE_CODE_LIST", sf.getValue("CTRL_TYPE_CODE_LIST", 0));
 		    			SepoaSession.putValue(request, "SELLER_PP_TYPE", sf.getValue("SELLER_PP_TYPE", 0));
 		    			SepoaSession.putValue(request, "AFFILIATED_COMPANY_FLAG", sf.getValue("AFFILIATED_COMPANY_FLAG", 0));
 		    			SepoaSession.putValue(request, "HOUSE_CODE", sf.getValue("HOUSE_CODE", 0));
 		    			SepoaSession.putValue(request, "IRS_NO", sf.getValue("IRS_NO", 0));
 		    			SepoaSession.putValue(request, "VIEW_USER_TYPE", sf.getValue("VIEW_USER_TYPE", 0)); 		    			
 		    			SepoaSession.putValue(request, "BD_ADMIN", sf.getValue("BD_ADMIN", 0));  		    			
 		    			SepoaSession.putValue(request, "OS_GB", os_gb);
 		    			SepoaSession.putValue(request, "GB_GJ", null);
 		    			
 		    			SepoaSession.putValue(request, "PURCHASE_BLOCK_FLAG", sf.getValue("PURCHASE_BLOCK_FLAG", 0));
 		    			
 		    			SepoaSession.putValue(request, "JUMJUMGB", sf.getValue("JUMJUMGB", 0));
		    			SepoaSession.putValue(request, "MOJMOJCD", sf.getValue("MOJMOJCD", 0));
 		    	   }
 		    	else{
 		    		gdRes.setMessage(value.message);
 		    		gdRes.setStatus("false");
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

	
    /**
     * 그룹웨어 직접 로그인
     * setDirectLogin
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setDirectLogin(GridData gdReq, SepoaInfo info, HttpServletRequest request, String param1) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
//	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    Map<String, String>       header 	   = new HashMap<String, String>();
    	String                    houseCode    = "000";	//info.getSession("HOUSE_CODE");
    	String                    language    =  "KO";	//info.getSession("HOUSE_CODE");
	    
	    
    	//v.addElement("MESSAGE");
	    //message = MessageUtil.getMessage(info, v);
	    	    
	    String user_id      = "";
	    String strFromSite  = request.getParameter("FromSite");
	    String service_name = "";
	
	    try{

	    	param1 = Base64.base64Decode(param1);
	    	param1 = CryptoUtil.decryptText(param1);	//복호화

	    	if(param1.length() == 30){
	    		user_id = param1.substring(8,16);
	    	}else{
	    		user_id = "";
	    	}
	    	
	    	header.put("direct"     , "true");
	    	header.put("user_id"    , user_id);
	    	header.put("house_code" , houseCode);
	    	header.put("language"   , language);

	    	
	    	// ICT지원센터를 위한 추가 Parameter
	    	if ("ICT".equals(strFromSite)){
	    		service_name = "setDirectLogin_ICT";
	    	}
	    	else{
	    		service_name = "setDirectLogin";
	    	}
	    	
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "CO_004", "CONNECTION",service_name, obj);
	    	
	    	if(value.flag){// 조회 성공
	    		
	    		sf= new SepoaFormater(value.result[0]);
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount > 0){
		    			gdRes.setStatus("true");
		    		
		    			Config sepoa_login_process_con = new Configuration();
		    	    	String buyer_compnay_code = sepoa_login_process_con.getString("sepoa.buyer.company.code");//BUYER Company Code 추가 2012.07.25

		    			SepoaSession.putValue(request, "BUYER_COMPANY_CODE", buyer_compnay_code);
		    			SepoaSession.putValue(request, "COMPANY_CODE", sf.getValue("COMPANY_CODE", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT", sf.getValue("DEPARTMENT", 0));
		    			SepoaSession.putValue(request, "NAME_LOC", sf.getValue("NAME_LOC", 0));
		    			SepoaSession.putValue(request, "NAME_ENG", sf.getValue("NAME_ENG", 0));
		    			SepoaSession.putValue(request, "PLANT_CODE", sf.getValue("PLANT_CODE", 0));
		    			SepoaSession.putValue(request, "LOCATION_CODE", sf.getValue("LOCATION_CODE", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_LOC", sf.getValue("DEPARTMENT_NAME_LOC", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_ENG", sf.getValue("DEPARTMENT_NAME_ENG", 0));
		    			SepoaSession.putValue(request, "LANGUAGE", sf.getValue("LANGUAGE", 0));
		    			SepoaSession.putValue(request, "COUNTRY", sf.getValue("COUNTRY", 0));
		    			SepoaSession.putValue(request, "EMPLOYEE_NO", sf.getValue("EMPLOYEE_NO", 0));
		    			SepoaSession.putValue(request, "TEL", sf.getValue("TEL", 0));
		    			SepoaSession.putValue(request, "MOBILE_NO", sf.getValue("MOBILE_NO", 0));
		    			SepoaSession.putValue(request, "ID", sf.getValue("ID", 0));
		    			SepoaSession.putValue(request, "POSITION", sf.getValue("POSITION", 0));
		    			SepoaSession.putValue(request, "CITY", sf.getValue("CITY", 0));
		    			SepoaSession.putValue(request, "LOCATION_NAME", sf.getValue("LOCATION_NAME", 0));
		    			SepoaSession.putValue(request, "EMAIL", sf.getValue("EMAIL", 0));
		    			SepoaSession.putValue(request, "CTRL_CODE", sf.getValue("CTRL_CODE", 0));
		    			SepoaSession.putValue(request, "OWN_CTRL_CODE_LIST", sf.getValue("OWN_CTRL_CODE_LIST", 0));
		    			SepoaSession.putValue(request, "USER_TYPE", sf.getValue("USER_TYPE", 0));
		    			SepoaSession.putValue(request, "IS_ADMIN_USER", sf.getValue("IS_ADMIN_USER", 0));
		    			SepoaSession.putValue(request, "MENU_PROFILE_CODE", sf.getValue("MENU_PROFILE_CODE", 0));
		    			SepoaSession.putValue(request, "USER_IP", request.getRemoteAddr());
		    			SepoaSession.putValue(request, "HOUSE_CODE", "100");
		    			SepoaSession.putValue(request, "USER_OS_LANGUAGE", header.get("language"));
		    			SepoaSession.putValue(request, "COMPANY_NAME", sf.getValue("COMPANY_NAME", 0));
		    			SepoaSession.putValue(request, "QM_CTRL_CODE", sf.getValue("QM_CTRL_CODE", 0));
		    			SepoaSession.putValue(request, "MM_CTRL_CODE", sf.getValue("MM_CTRL_CODE", 0));
		    			SepoaSession.putValue(request, "SHIPPER_TYPE", sf.getValue("SHIPPER_TYPE", 0));
		    			SepoaSession.putValue(request, "CTRL_TYPE_CODE_LIST", sf.getValue("CTRL_TYPE_CODE_LIST", 0));
		    			SepoaSession.putValue(request, "SELLER_PP_TYPE", sf.getValue("SELLER_PP_TYPE", 0));
		    			SepoaSession.putValue(request, "AFFILIATED_COMPANY_FLAG", sf.getValue("AFFILIATED_COMPANY_FLAG", 0));
		    			SepoaSession.putValue(request, "HOUSE_CODE", sf.getValue("HOUSE_CODE", 0));
		    			SepoaSession.putValue(request, "IRS_NO", sf.getValue("IRS_NO", 0));
		    			SepoaSession.putValue(request, "VIEW_USER_TYPE", sf.getValue("VIEW_USER_TYPE", 0));		    			
		    			SepoaSession.putValue(request, "FROM_SITE", strFromSite);
		    			SepoaSession.putValue(request, "BD_ADMIN", sf.getValue("BD_ADMIN", 0));		    			
		    			SepoaSession.putValue(request, "DEPARTMENT_ORG", sf.getValue("DEPARTMENT", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_LOC_ORG", sf.getValue("DEPARTMENT_NAME_LOC", 0));
		    			SepoaSession.putValue(request, "GB_GJ", null);
		    			
		    			SepoaSession.putValue(request, "PURCHASE_BLOCK_FLAG", sf.getValue("PURCHASE_BLOCK_FLAG", 0));
		    			
		    			SepoaSession.putValue(request, "JUMJUMGB", sf.getValue("JUMJUMGB", 0));
		    			SepoaSession.putValue(request, "MOJMOJCD", sf.getValue("MOJMOJCD", 0));
		    	   }
		    	else{
		    		gdRes.setMessage(value.message);
		    		gdRes.setStatus("false");
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage("");
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
	
	
	/* 관리자 로그인 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setLoginLocal(GridData gdReq, SepoaInfo info, HttpServletRequest request, String user_id, String password) throws Exception{
	    GridData            gdRes        = new GridData();
	    SepoaFormater       sf           = null;
	    SepoaOut            value        = null;
	    Vector              v            = new Vector();
	    HashMap             message      = null;
	    Map<String, Object> allData      = null;
	    Map<String, String> header       = null;
	    String              gridColId    = null;
	    int                 rowCount     = 0;
	    String              pwdSha       = "";
	    String              mode         = "";
	    String              strFromSite  = "";
	    String              strMaster_Pass= "";
	    
	    

    	String houseCode    = "000";//info.getSession("HOUSE_CODE");
	    
	    v.addElement("MESSAGE");
	

	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	mode = request.getParameter("mode");

	    	// 사용자ID
	    	user_id = Base64.base64Decode(user_id);
	    	user_id = CryptoUtil.decryptText(user_id);	//복호화

	    	// 사용자암호(복호화)
	    	pwdSha       = CryptoUtil.getSHA256(password);			    	  

	    	
	    	// 업무구분(총무부,ICT)(복호화)
	    	strFromSite = request.getParameter("FromSite");
	    	strFromSite = Base64.base64Decode(strFromSite);
	    	strFromSite = CryptoUtil.decryptText(strFromSite);	//복호화

	    	// 관리자 암호
	    	strMaster_Pass = request.getParameter("Master_Pass");
	    	strMaster_Pass = Base64.base64Decode(strMaster_Pass);
	    	strMaster_Pass = CryptoUtil.decryptText(strMaster_Pass);	//복호화

	    	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	    	String strCheck_Pass = "epro"+current_date.substring(6,8) +  current_date.substring(4,6)+"~";
	    	

	    	if (!strMaster_Pass.equals(strCheck_Pass)){
	    		gdRes.setMessage("관리자 암호가 일치하지 않습니다.");
	    		gdRes.setStatus("false");
	    		return gdRes;
	    	}
	    	
	    	if ("ICT".equals(strFromSite)){
	    		strFromSite = "ICT";
	    	}
	    	else{
	    		strFromSite = "GAD";
	    	}
	    	
	    	header.put("user_id"      , user_id);
	    	header.put("password"     , password);
	    	header.put("pwdSha"       , pwdSha);
	    	header.put("house_code"   , houseCode);
	    	header.put("language"     , "KO");
	    	header.put("userIp"       , request.getRemoteAddr());
	    	header.put("mode"         , mode);
	    	header.put("direct"       , "true");
	    	header.put("fromsite"     , strFromSite);
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "CO_004", "CONNECTION","setLocalLogin", obj);
	
	    	if(value.flag){// 조회 성공
	    		
	    		sf= new SepoaFormater(value.result[0]);
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount > 0){
		    		gdRes.setStatus("true");
		    		
		    			Config sepoa_login_process_con = new Configuration();
		    	    	String buyer_compnay_code = sepoa_login_process_con.getString("sepoa.buyer.company.code");//BUYER Company Code 추가 2012.07.25
		    	    	
	    	    		SepoaSession.putValue(request, "BUYER_COMPANY_CODE", buyer_compnay_code);
		    			SepoaSession.putValue(request, "COMPANY_CODE", sf.getValue("COMPANY_CODE", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT", sf.getValue("DEPARTMENT", 0));
		    			SepoaSession.putValue(request, "NAME_LOC", sf.getValue("NAME_LOC", 0));
		    			SepoaSession.putValue(request, "NAME_ENG", sf.getValue("NAME_ENG", 0));
		    			SepoaSession.putValue(request, "PLANT_CODE", sf.getValue("PLANT_CODE", 0));
		    			SepoaSession.putValue(request, "LOCATION_CODE", sf.getValue("LOCATION_CODE", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_LOC", sf.getValue("DEPARTMENT_NAME_LOC", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_ENG", sf.getValue("DEPARTMENT_NAME_ENG", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT_CODE", sf.getValue("DEPARTMENT_CODE", 0));
		    			SepoaSession.putValue(request, "LANGUAGE", sf.getValue("LANGUAGE", 0));
		    			SepoaSession.putValue(request, "COUNTRY", sf.getValue("COUNTRY", 0));
		    			SepoaSession.putValue(request, "EMPLOYEE_NO", sf.getValue("EMPLOYEE_NO", 0));
		    			SepoaSession.putValue(request, "TEL", sf.getValue("TEL", 0));
		    			SepoaSession.putValue(request, "MOBILE_NO", sf.getValue("MOBILE_NO", 0));
		    			SepoaSession.putValue(request, "ID", sf.getValue("ID", 0));
		    			SepoaSession.putValue(request, "POSITION", sf.getValue("POSITION", 0));
		    			SepoaSession.putValue(request, "CITY", sf.getValue("CITY", 0));
		    			SepoaSession.putValue(request, "LOCATION_NAME", sf.getValue("LOCATION_NAME", 0));
		    			SepoaSession.putValue(request, "EMAIL", sf.getValue("EMAIL", 0));
		    			SepoaSession.putValue(request, "CTRL_CODE", sf.getValue("CTRL_CODE", 0));
		    			SepoaSession.putValue(request, "OWN_CTRL_CODE_LIST", sf.getValue("OWN_CTRL_CODE_LIST", 0));
		    			SepoaSession.putValue(request, "WORK_TYPE", sf.getValue("WORK_TYPE", 0));
		    			SepoaSession.putValue(request, "USER_TYPE", sf.getValue("USER_TYPE", 0));
		    			SepoaSession.putValue(request, "IS_ADMIN_USER", sf.getValue("IS_ADMIN_USER", 0));
		    			SepoaSession.putValue(request, "MENU_PROFILE_CODE", sf.getValue("MENU_PROFILE_CODE", 0));

		    			// 개발자가 접속시... 업체의 모든 메뉴 표시를 위하여... 강제로 Setting : ICT는 제외
		    			if("S".equals(sf.getValue("USER_TYPE", 0)) && !"ICT".equals(strFromSite) ){
			    			SepoaSession.putValue(request, "MENU_PROFILE_CODE", "MUP141000002");
		    			}
		    			
		    			SepoaSession.putValue(request, "USER_IP", request.getRemoteAddr());
		    			SepoaSession.putValue(request, "HOUSE_CODE", "100");
		    			SepoaSession.putValue(request, "USER_OS_LANGUAGE", header.get("language"));
		    			SepoaSession.putValue(request, "COMPANY_NAME", sf.getValue("COMPANY_NAME", 0));
		    			SepoaSession.putValue(request, "QM_CTRL_CODE", sf.getValue("QM_CTRL_CODE", 0));
		    			SepoaSession.putValue(request, "MM_CTRL_CODE", sf.getValue("MM_CTRL_CODE", 0));
		    			SepoaSession.putValue(request, "SHIPPER_TYPE", sf.getValue("SHIPPER_TYPE", 0));
		    			SepoaSession.putValue(request, "CTRL_TYPE_CODE_LIST", sf.getValue("CTRL_TYPE_CODE_LIST", 0));
		    			SepoaSession.putValue(request, "SELLER_PP_TYPE", sf.getValue("SELLER_PP_TYPE", 0));
		    			SepoaSession.putValue(request, "AFFILIATED_COMPANY_FLAG", sf.getValue("AFFILIATED_COMPANY_FLAG", 0));
		    			SepoaSession.putValue(request, "HOUSE_CODE", sf.getValue("HOUSE_CODE", 0));
		    			SepoaSession.putValue(request, "IRS_NO", sf.getValue("IRS_NO", 0));
		    			SepoaSession.putValue(request, "VIEW_USER_TYPE", sf.getValue("VIEW_USER_TYPE", 0));		    			
		    			SepoaSession.putValue(request, "FROM_SITE", strFromSite);
		    			SepoaSession.putValue(request, "BD_ADMIN", sf.getValue("BD_ADMIN", 0));		    			
		    			SepoaSession.putValue(request, "DEPARTMENT_ORG", sf.getValue("DEPARTMENT", 0));
		    			SepoaSession.putValue(request, "DEPARTMENT_NAME_LOC_ORG", sf.getValue("DEPARTMENT_NAME_LOC", 0));		    			
		    			SepoaSession.putValue(request, "GB_GJ", sf.getValue("GB_GJ", 0));
		    			
		    			SepoaSession.putValue(request, "PURCHASE_BLOCK_FLAG", sf.getValue("PURCHASE_BLOCK_FLAG", 0));
		    			
		    			SepoaSession.putValue(request, "JUMJUMGB", sf.getValue("JUMJUMGB", 0));
		    			SepoaSession.putValue(request, "MOJMOJCD", sf.getValue("MOJMOJCD", 0));
		    	   }
		    	else{
		    		gdRes.setMessage(value.message);
		    		gdRes.setStatus("false");
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage("");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
    
}
