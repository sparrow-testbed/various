package srm;

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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CO_072_Servlet
 */
public class srm_bd_list extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public srm_bd_list() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		this.doPost(req, res);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
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
    	String param1       = "";
    	String verifierKey  = "";
    	

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		
    		if(JSPUtil.CheckInjection(gdReq.getParam("m")).equals("1"))
    			mode = "setDirectLogin";
    		else
    			mode = "setXecureLogin";
    		
    		param1 = req.getParameter("p");
			gdRes = this.setDirectLogin(gdReq, info, req, param1);    		
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
//    		e.printStackTrace();
    	}
    	finally {
    		try{
    			SepoaSession.putValue(req, "logStatus", gdRes.getStatus());
    			SepoaSession.putValue(req, "mode"     , mode);
    			SepoaSession.putValue(req, "user_id"  , user_id);
    			SepoaSession.putValue(req, "msg"      , gdRes.getMessage());
    			String url = "/common/login_process.jsp";
    			RequestDispatcher rd = req.getRequestDispatcher(url);
    			rd.forward(req, res);
  			
    		}
    		catch (Exception e) {
//    			e.printStackTrace();
    			Logger.debug.println();
    		}
    	}

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
	
	    Map<String, String>       header	= new HashMap<String, String>();
    	String                    houseCode	= "000";	//info.getSession("HOUSE_CODE");
    	String                    language	=  "KO";	//info.getSession("HOUSE_CODE");
	    	    
    	String[]            aParam;
    	 
	    String user_id = "";
	    String p1 = "";
	    String p2 = "";
	    String p3 = "";
	    
	    long l3 = 0;
	    long c3 = 0;
	    
	
	    try{
	    	
	    	param1 = Base64.base64Decode(param1);
	    	param1 = CryptoUtil.decryptText(param1);	//복호화
	    	
	    	aParam = param1.split("!@");
	    	/*
	    	p1 = param1.substring(0, 8);
	    	p2 = param1.substring(8, 16);
	    	p3 = param1.substring(16);
	    	*/
	    	p1 = aParam[0];	// 접근문자 
	    	p2 = aParam[1];	// USER_ID
	    	p3 = aParam[2];	// 시간
	    	
	    	if(!p1.equals("sns5sms!"))
	    	{
	    		gdRes.setMessage("비정상경로 접근시 형사고발 조치 됩니다.1");
	    		gdRes.setStatus("false");
	    		return gdRes;
	    	}
	    	
	    	
	    	l3 = Long.valueOf(p3);
	    	c3 = System.currentTimeMillis();
	    		    	
	    	if((c3-l3) > (1000*60*5))
	    	{
	    		gdRes.setMessage("비정상경로 접근시 형사고발 조치 됩니다.2");
	    		gdRes.setStatus("false");
	    		return gdRes;
	    	}
	    	
	    	user_id = p2;	// USER_ID 저장
	    	
	    	header.put("direct"     , "true");
	    	header.put("user_id"    , user_id);
	    	header.put("house_code" , houseCode);
	    	header.put("language"   , language);

	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "CO_004", "CONNECTION","setDirectLogin", obj);
	    	
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
		    			
		    			SepoaSession.putValue(request, "BD_ADMIN", sf.getValue("BD_ADMIN", 0));
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
	    	gdRes.setMessage((message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"");
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


}

