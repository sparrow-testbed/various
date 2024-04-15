package sepoa.svc.co;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import tradesign.pki.util.JetsUtil;

import com.raonsecure.touchen.KeyboardSecurity;
import com.raonsecure.touchenkey.TouchEn_Crypto;

public class CO_004 extends SepoaService
{
    private String ID;

    public CO_004(String opt, SepoaInfo info) throws SepoaServiceException
    {
        super(opt, info);
        ID = this.info.getSession("ID");
        setVersion("1.0.0");
    }

    public String getConfig(String s)
    {
        try
        {
            Configuration configuration = new Configuration();
            s = configuration.get(s);

            return s;
        }
        catch (ConfigurationException configurationexception)
        {
            Logger.sys.println((new StringBuilder("getConfig error : ")).append(configurationexception.getMessage()).toString());
        }
        catch (Exception exception)
        {
            Logger.sys.println((new StringBuilder("getConfig error : ")).append(exception.getMessage()).toString());
        }

        return null;
    }

    public SepoaOut setLoginMap(Map map) throws Exception {
	    SepoaOut out = null;
    	try {
    	HttpServletRequest request = (HttpServletRequest) map.get(SepoaDataMapper.KEY_REQUEST);
    	Map<String, String> paramMap = (Map<String, String>)map.get("headerData");
    	SepoaSession.putValue(request, "HOUSE_CODE", "000");
	    
	    out = setLogin(paramMap);
	    SepoaFormater sf = new SepoaFormater(out.result[0]);
	    	    
	    if(sf.getRowCount() > 0) { 
	    	out.status = 2;
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
			SepoaSession.putValue(request, "USER_OS_LANGUAGE", paramMap.get("language"));
			SepoaSession.putValue(request, "COMPANY_NAME", sf.getValue("COMPANY_NAME", 0));
			SepoaSession.putValue(request, "QM_CTRL_CODE", sf.getValue("QM_CTRL_CODE", 0));
			SepoaSession.putValue(request, "MM_CTRL_CODE", sf.getValue("MM_CTRL_CODE", 0));
			SepoaSession.putValue(request, "SHIPPER_TYPE", sf.getValue("SHIPPER_TYPE", 0));
			SepoaSession.putValue(request, "CTRL_TYPE_CODE_LIST", sf.getValue("CTRL_TYPE_CODE_LIST", 0));
			SepoaSession.putValue(request, "SELLER_PP_TYPE", sf.getValue("SELLER_PP_TYPE", 0));
			SepoaSession.putValue(request, "AFFILIATED_COMPANY_FLAG", sf.getValue("AFFILIATED_COMPANY_FLAG", 0));
			SepoaSession.putValue(request, "HOUSE_CODE", sf.getValue("HOUSE_CODE", 0));
			SepoaSession.putValue(request, "MENU_TYPE", sf.getValue("MENU_PROFILE_CODE", 0));
			SepoaSession.putValue(request, "IRS_NO", sf.getValue("IRS_NO", 0));
	    }
	    out.result = null;//json 데이터에 가끔씩 parsing 오류가 생기는 것 같다.
    	} catch(Exception e) {
    		Logger.err.println(info.getSession("ID"), this, e);
    	}
	    return out;
    }

    

    
    
    public SepoaOut setLoginMap2(Map<String, String> paramMap) throws Exception {
	    SepoaOut out = null;
    	try {
    		out = setLogin(paramMap);
    	} catch(Exception e) {
    		Logger.err.println(info.getSession("ID"), this, e);
    	}
	    return out;
    }

    /**
	 * 직접 로그인
	 * @method setDirectLogin
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-12-16
	 * @modify 2014-12-16
	 */
    public SepoaOut setDirectLogin(Map<String, String> paramMap) throws Exception {
	    SepoaOut out = null;
    	try {
    		out = setLogin(paramMap);
    	} catch(Exception e) {
    		Logger.err.println(info.getSession("ID"), this, e);
    	}
	    return out;
    }


    /*
     * ICT사용 : 직접 로그인(주로 내부사용자 이용)
	 */
    public SepoaOut setDirectLogin_ICT(Map<String, String> paramMap) throws Exception {
	    SepoaOut out = null;
    	try {
    		out = setLogin_ICT(paramMap);
    	} catch(Exception e) {
    		Logger.err.println(info.getSession("ID"), this, e);
    	}
	    return out;
    }

    /*
     * setLocalLogin 사용
	 */
    public SepoaOut setLocalLogin(Map<String, String> paramMap) throws Exception {
	    SepoaOut out = null;
    	try {
    		out = setLogin_Local(paramMap);
    	} catch(Exception e) {
    		Logger.err.println(info.getSession("ID"), this, e);
    	}
	    return out;
    }

    public SepoaOut setLogin(Map<String, String> map)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            
            // ICT를 위한 추가 : 총무부/ICT 사용자 체크

            String FromSite = "";
            FromSite = map.get("FromSite");
            
            if ("ICT".equals(FromSite) || "ICT2".equals(FromSite)){
            	// 그룹웨어 ICT Direct 밖에 없음
            	rtn = svcSetLogin_ICT(map);
            }
            else
            {
//	            rtn = setLogin_User_Check_ICT(map);
//	            
//	            FromSite = rtn[0];	// ICT 사용자인 경우는 'ICT' return
//	            map.put("FromSite", FromSite);
//	            
//	            if ("GAD".equals(FromSite)){	// 총무부 사용자
//	                rtn = svcSetLogin(map);
//	            } else if ("ICT".equals(FromSite))	// ICT 사용자
//	            {
//	            	rtn = svcSetLogin_ICT(map);
//	            }
//	            else
//	            {
//	                rtn = svcSetLogin(map);
//	            }
            	
            	rtn = svcSetLogin(map);
            }

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }
            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

    /* ICT 사용*/
    public SepoaOut setLogin_ICT(Map<String, String> map)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcSetLogin_ICT(map);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }
            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }


    /* ICT 사용*/
    public SepoaOut setLogin_Local(Map<String, String> map)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            //rtn = svcSetLogin_GAD(map);
            rtn = svcSetLocalLogin(map);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }
            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }
    
    // 총무부/ICT 사용자 체크
    private String[] setLogin_User_Check_ICT(Map<String, String> map) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        
        try
        {
            Map<String, String> addMap = new HashMap<String, String>();
            String houseCode = info.getSession("HOUSE_CODE");
            if(houseCode != null && houseCode.length() > 0) {
                addMap.put("house_code", houseCode);
            }

            SepoaXmlParser sxp = new SepoaXmlParser(this, "setLogin_User_Check_ICT");
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            SepoaFormater wff1 = new SepoaFormater(ssm.doSelect(map, addMap));
            String FROM_SITE = "";
            if(wff1.getRowCount()>0){	//사용자 ID 존재
            	FROM_SITE = wff1.getValue("FROM_SITE",0);
            	rtn[0] = FROM_SITE;
            }else{
            	//사용자 ID가 없음.
            	throw new Exception("사용자의 ID가 존재하지 않습니다.");
            }
        }
        catch (Exception e)
        {
            rtn[1] = e.getMessage();
            Logger.err.println(ID, this, e);
        }
        finally
        {
           	ctx = null;
        }
        return rtn;	
        
    }
    
    private String[] svcSetLogin(Map<String, String> map) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        
        String success_yn = "";
        String pwd_new   = "";
        String current_day = SepoaDate.getShortDateString();
        String current_time= SepoaDate.getShortTimeString();
    	String date3m = SepoaDate.addSepoaDateMonth(current_day,-3);
        
    	//directLogin 체크
        String strDirect    = map.get("direct");
        String pwdMd5       = map.get("pwdMd5");
        String pwdSha       = map.get("pwdSha");
        String userIp       = map.get("userIp");
        String mode         = map.get("mode");		//비밀번호 변경
        String new_password = map.get("new_password");
        
        String svcSetLogin_Gubun  = "svcSetLogin";
        
        try
        {
            Map<String, String> addMap = new HashMap<String, String>();
            String houseCode = info.getSession("HOUSE_CODE");
            if(houseCode != null && houseCode.length() > 0) {
                addMap.put("house_code", houseCode);
            }
            
            
            if(!"true".equals(strDirect)){
            	svcSetLogin_Gubun = "svcSetLogin_vendor";
            }

            //SepoaXmlParser sxp = new SepoaXmlParser();
            SepoaXmlParser sxp = new SepoaXmlParser(this, svcSetLogin_Gubun);
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            
            
            
            SepoaFormater wff1 = new SepoaFormater(ssm.doSelect(map, addMap));
            String PW_RESET_FLAG = "";
            int Pw_reset_cnt  = 0;
            if(wff1.getRowCount()>0){	//사용자 ID 존재
	            PW_RESET_FLAG = wff1.getValue("PW_RESET_FLAG",0);
	            Pw_reset_cnt  = Integer.parseInt(wff1.getValue("PASS_CHECK_CNT",0));
            
	            sxp = new SepoaXmlParser(this, "svcSetLogin_SELECT_userType");
	            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	            
	            SepoaFormater wff = new SepoaFormater(ssm.doSelect(map, addMap));
	
	            String USER_TYPE       = "";
	            String PASSWORD        = "";
	            String PASSWORD_OLD    = "";
	            String LAST_LOGIN_DATE = "";
	            String PW_RESET_DATE = "";
	            
	            if(wff.getRowCount()>0){ //비밀번호, 비밀번호 초과 회수, 사용자 암호 변경주기 도래 확인 	
	        	    USER_TYPE       = wff.getValue("USER_TYPE",0);
	        	    PASSWORD        = wff.getValue("PASSWORD",0);
	        	    PASSWORD_OLD    = wff.getValue("PASSWORD_OLD",0);
	        	    LAST_LOGIN_DATE = wff.getValue("LAST_LOGIN_DATE",0);
	        	    PW_RESET_DATE   = wff.getValue("PW_RESET_DATE",0);
	                /*sxp = new SepoaXmlParser(this, "svcSetLogin_UPDATE_language");
	                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	                
	                ssm.doUpdate(map, addMap);*/
					/*SepoaOut wo = DocumentUtil.getDocNumber(info, "UH");
					String UH_NO = wo.result[0];
	        	    map.put("UH_NO", UH_NO);*/
	        	    
//	        	    strDirect = "true";//비밀번호 체크 안하고 로그인 : 반영시에는 지워야함
	        	    
	                if("true".equals(strDirect)){		//강제로그인
	                	addMap.put("force_login_flag",strDirect);	
	                	
	                	sxp = new SepoaXmlParser(this, "svcSetLogin_Login");
	 	                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	 	
	 		            rtn[0] = ssm.doSelect(map, addMap);
	 	                SepoaFormater sf = new SepoaFormater(rtn[0]);
	 	                
	 	                /*사용자 비밀번호 변경 : 반영시에는 지워야함
	 	                if(sf.getRowCount() > 0){//사용자 비밀번호 변경
	 	                	
	 	                	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_Reset");
	 	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	 	                    ssm.doUpdate(map);
	 	                	
	 	                }else{
	 	                	//사용자 ID가 없음.
	 	                	throw new Exception();
	 	                }
	                	*/
	                	
	                }else if("setPwdNew".equals(mode)||"setPwdNew2".equals(mode)){		//비밀번호 변경
	                	
	                	sxp = new SepoaXmlParser(this, "svcSetLogin_setPwdNew");
		                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		
			            rtn[0] = ssm.doSelect(map, addMap);
		                SepoaFormater sf = new SepoaFormater(rtn[0]);
		                if(sf.getRowCount() > 0){
		                	
		                	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_New");
		                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		                    map.put("PASS_CHECK_CNT", "0");
		                    map.put("LAST_LOGIN_IP" , userIp);
		                    map.put("pwd_new"      , new_password);
		                    map.put("current_day"   , current_day); 
		        	    	map.put("current_time"  , current_time); 
		                    ssm.doUpdate(map);
		                    
		                    //변경 로그 기록
		                    sxp = new SepoaXmlParser(this, "setLogin_Pwd_History");
			                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		                    ssm.doInsert(map);
		                    
		                    // 전자구매시스템 - 공급사 패스워드 변경시 재로그인 처리 20220805
		                    throw new Exception("정상적으로 변경 되었습니다.다시 로그인 하세요.");	   
		                	
		                }else{
		                	throw new Exception("사용자의 ID 혹은 암호가 일치하지 않습니다");	                	
		                }
	                }else{
	                	
	                	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_Pass_Cnt");
 	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
 	                    
 	                    success_yn = "N";
 	                    
 	                    //System.out.println("debug:JSPUtil.nullChk(PASSWORD):"+JSPUtil.nullChk(PASSWORD)+"|"+"pwdSha:"+pwdSha);

 	                    if(Pw_reset_cnt > 4){
		        	    	Pw_reset_cnt = 0;
		        	    	rtn[1] = "비밀번호 오류가 5회 초과 되었습니다.rnrn초기화면에서 ID/PW찾기를 실행 하세요.";
	        	    	
		        	    }else if(!"".equals(JSPUtil.nullChk(PASSWORD)) && !pwdSha.equals(JSPUtil.nullChk(PASSWORD))){

		        	    	success_yn = "N";
		        	    	Pw_reset_cnt = Pw_reset_cnt + 1;
		        	    	map.put("PASS_CHECK_CNT", Pw_reset_cnt+"");
		        	    	
		        	    	ssm.doUpdate(map, addMap);	
		        	    	
		        	    	rtn[1] = "사용자의 ID 혹은 암호가 일치하지 않습니다.rnrn비밀번호 오류회수 : "+Pw_reset_cnt+"rnrn5회이상 비밀번호 오류시 비밀번호 재발급 받으셔야 합니다.rnrn(초기화면에서 ID/PW찾기를 실행 하세요.)";
		        	    
		        	    }else if("".equals(JSPUtil.nullChk(PASSWORD)) && !pwdMd5.equals(PASSWORD_OLD)){
		        	    	
		    	        	success_yn = "N";
		    	        	Pw_reset_cnt = Pw_reset_cnt + 1;
		        	    	map.put("PASS_CHECK_CNT", Pw_reset_cnt+"");
		        	    	
		        	    	ssm.doUpdate(map, addMap);		        	    
		        	    	
		        	    	rtn[1] = "사용자의 ID 혹은 암호가 일치하지 않습니다.rnrn 비밀번호 오류회수 : "+Pw_reset_cnt+"rnrn5회이상 비밀번호 오류 시 비밀번호 재발급 받으셔야 합니다.rnrn(초기화면에서 ID/PW찾기를 실행 하세요.)";
		    	       
		        	    		        	   
		        	    }else if(pwdSha.equals(PASSWORD) && Integer.parseInt(date3m) > Integer.parseInt(JSPUtil.nullToRef(PW_RESET_DATE,"0")) && LAST_LOGIN_DATE != null && !"".equals(LAST_LOGIN_DATE) ){
		        	    	
		        	    	success_yn = "N";
		        	    	rtn[1] = "setDateOver";
		        	    	map.put("PASSWORD", pwdSha);
		        	    	//map.put("current_day"  ,""); 
		        	    	//map.put("current_time" ,"");
		        	    	//System.out.println("debug:"+rtn[1]);
		        	    	ssm.doUpdate(map, addMap);
		        	    }else if(pwdMd5.equals(PASSWORD_OLD) && Integer.parseInt(date3m) > Integer.parseInt(JSPUtil.nullToRef(PW_RESET_DATE,"0"))){
		        	    	
		        	    	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_Reset");
	 	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	 	                    
		        	    	success_yn = "N";
		        	    	rtn[1] = "setDateOver";
		        	    	map.put("PASSWORD", pwdSha);

		        	    	ssm.doUpdate(map, addMap);
	        	    	
		        	    }else if(pwdSha.equals(PASSWORD)){	    //비밀번호 일치함.
		        	    	success_yn = "Y";
		        	    
		        	    }else if(pwdMd5.equals(PASSWORD_OLD)){	//비밀번호 일치함.
		        	    	success_yn = "Y";
		        	    	pwd_new   = pwdSha;
		        	    }
 	                    
 	                    
 	                   //System.out.println("debug:success_yn:"+success_yn);
 	                   if("Y".equals(success_yn)){		
		        	    	sxp = new SepoaXmlParser(this, "svcSetLogin_Login");
			                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			                map.put("password", pwdSha);
				            rtn[0] = ssm.doSelect(map, addMap);
			                SepoaFormater sf = new SepoaFormater(rtn[0]);
			                if(sf.getRowCount() > 0){
			                	
			                	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_New");
			                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			                    map.put("PASS_CHECK_CNT", "0");
			                    map.put("LAST_LOGIN_IP" , userIp);
			                    map.put("pwd_new"       , pwdSha);
			                    map.put("current_day"   , current_day); 
			        	    	map.put("current_time"  , current_time); 
			                    ssm.doUpdate(map); 
			                    
			                }else{
			                	throw new Exception("사용자의 ID 혹은 암호가 일치하지 않습니다.");	                	
			                }
			                
	                	}
	                	
	                }
               

	            }
	            Commit();
            }else{
            	//사용자 ID가 없음.
            	throw new Exception("사용자의 ID가 존재하지 않습니다.");
            
            }
        }
        catch (Exception e)
        {
        	Rollback();
            rtn[1] = e.getMessage();
            // e.printStackTrace();
            Logger.err.println(ID, this, e);
        }
        finally
        {
           	ctx = null;
        }
        return rtn;	
        
    }

    /* ICT 사용 */
    private String[] svcSetLogin_ICT(Map<String, String> map) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        
        String success_yn = "";
        String pwd_new   = "";
        String current_day = SepoaDate.getShortDateString();
        String current_time= SepoaDate.getShortTimeString();
    	String date3m = SepoaDate.addSepoaDateMonth(current_day,-3);
        
    	//directLogin 체크
        String strDirect    = map.get("direct");
        String pwdMd5       = map.get("pwdMd5");
        String pwdSha       = map.get("pwdSha");
        String userIp       = map.get("userIp");
        String mode         = map.get("mode");		//비밀번호 변경
        String new_password = map.get("new_password");
        
        try
        {
            Map<String, String> addMap = new HashMap<String, String>();
            String houseCode = info.getSession("HOUSE_CODE");
            if(houseCode != null && houseCode.length() > 0) {
                addMap.put("house_code", houseCode);
            }
            
            addMap.put("user_id", map.get("user_id"));

            SepoaXmlParser  sxp = new SepoaXmlParser(this, "svcSetLogin_ICT");
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            SepoaFormater  wff1 = new SepoaFormater(ssm.doSelect(map, addMap));

            String PW_RESET_FLAG = "";
            int Pw_reset_cnt  = 0;
            if(wff1.getRowCount()>0){	//사용자 ID 존재
	            PW_RESET_FLAG = wff1.getValue("PW_RESET_FLAG",0);
	            Pw_reset_cnt  = Integer.parseInt(wff1.getValue("PASS_CHECK_CNT",0));
            
	            sxp = new SepoaXmlParser(this, "svcSetLogin_SELECT_userType_ICT");
	            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	            
	            SepoaFormater wff = new SepoaFormater(ssm.doSelect(map, addMap));
	
	            String USER_TYPE       = "";
	            String PASSWORD        = "";
	            String PASSWORD_OLD    = "";
	            String LAST_LOGIN_DATE = "";
	            String PW_RESET_DATE = "";
	            
	            if(wff.getRowCount() > 0){ //비밀번호, 비밀번호 초과 회수, 사용자 암호 변경주기 도래 확인 	
	        	    USER_TYPE       = wff.getValue("USER_TYPE",0);
	        	    PASSWORD        = wff.getValue("PASSWORD",0);
	        	    PASSWORD_OLD    = wff.getValue("PASSWORD_OLD",0);
	        	    LAST_LOGIN_DATE = wff.getValue("LAST_LOGIN_DATE",0);
	        	    PW_RESET_DATE   = wff.getValue("PW_RESET_DATE",0);
	        	    
	                if("true".equals(strDirect)){		//강제로그인
	                	addMap.put("force_login_flag",strDirect);	
	                	
	                	sxp = new SepoaXmlParser(this, "svcSetLogin_Login_ICT");
	 	                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	 	
	 		            rtn[0] = ssm.doSelect(map, addMap);
	 	                SepoaFormater sf = new SepoaFormater(rtn[0]);
	 	                
	                }else if("setPwdNew".equals(mode)||"setPwdNew2".equals(mode)){		//비밀번호 변경

	                	sxp = new SepoaXmlParser(this, "svcSetLogin_setPwdNew_ICT");
		                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		
			            rtn[0] = ssm.doSelect(map, addMap);
		                SepoaFormater sf = new SepoaFormater(rtn[0]);
		                if(sf.getRowCount() > 0){
		                	
		                	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_New_ICT");
		                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		                    map.put("PASS_CHECK_CNT", "0");
		                    map.put("LAST_LOGIN_IP" , userIp);
		                    map.put("pwd_new"       , new_password);
		                    map.put("current_day"   , current_day); 
		        	    	map.put("current_time"  , current_time); 
		                    ssm.doUpdate(map);
		                    
		                    //변경 로그 기록(ICOMPWDL : 공통사용)
		                    sxp = new SepoaXmlParser(this, "setLogin_Pwd_History");
			                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		                    ssm.doInsert(map);
		                    
		                    // IT전자입찰시스템 - 공급사 패스워드 변경시 재로그인 처리 20220805
		                    throw new Exception("정상적으로 변경 되었습니다.다시 로그인 하세요.");	   
		                	
		                }else{
		                	throw new Exception("사용자의 ID 혹은 암호가 일치하지 않습니다");	                	
		                }
	                }else{
	                	
	                	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_Pass_Cnt_ICT");
 	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
 	                    
 	                    success_yn = "N";
 	                    
 	                    if(Pw_reset_cnt > 4){
		        	    	Pw_reset_cnt = 0;
		        	    	rtn[1] = "비밀번호 오류가 5회 초과 되었습니다.rnrn초기화면에서 ID/PW찾기를 실행 하세요.";
	        	    	
		        	    }else if(!"".equals(JSPUtil.nullChk(PASSWORD)) && !pwdSha.equals(JSPUtil.nullChk(PASSWORD))){

		        	    	success_yn = "N";
		        	    	Pw_reset_cnt = Pw_reset_cnt + 1;
		        	    	map.put("PASS_CHECK_CNT", Pw_reset_cnt+"");
		        	    	
		        	    	ssm.doUpdate(map, addMap);	
		        	    	
		        	    	rtn[1] = "사용자의 ID 혹은 암호가 일치하지 않습니다.rnrn비밀번호 오류회수 : "+Pw_reset_cnt+"rnrn5회이상 비밀번호 오류시 비밀번호 재발급 받으셔야 합니다.rnrn(초기화면에서 ID/PW찾기를 실행 하세요.)";
		        	    
		        	    }else if("".equals(JSPUtil.nullChk(PASSWORD)) && !pwdMd5.equals(PASSWORD_OLD)){
		        	    	
		    	        	success_yn = "N";
		    	        	Pw_reset_cnt = Pw_reset_cnt + 1;
		        	    	map.put("PASS_CHECK_CNT", Pw_reset_cnt+"");
		        	    	
		        	    	ssm.doUpdate(map, addMap);		        	    
		        	    	
		        	    	rtn[1] = "사용자의 ID 혹은 암호가 일치하지 않습니다.rnrn 비밀번호 오류회수 : "+Pw_reset_cnt+"rnrn5회이상 비밀번호 오류 시 비밀번호 재발급 받으셔야 합니다.rnrn(초기화면에서 ID/PW찾기를 실행 하세요.)";
		    	       
		        	    		        	   
		        	    }else if(pwdSha.equals(PASSWORD) && Integer.parseInt(date3m) > Integer.parseInt(JSPUtil.nullToRef(PW_RESET_DATE,"0")) && LAST_LOGIN_DATE != null && !"".equals(LAST_LOGIN_DATE) ){
		        	    	
		        	    	success_yn = "N";
		        	    	rtn[1] = "setDateOver";
		        	    	map.put("PASSWORD", pwdSha);
		        	    	ssm.doUpdate(map, addMap);
		        	    }else if(pwdMd5.equals(PASSWORD_OLD) && Integer.parseInt(date3m) > Integer.parseInt(JSPUtil.nullToRef(PW_RESET_DATE,"0"))){
		        	    	
		        	    	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_Reset");
	 	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
    
		        	    	success_yn = "N";
		        	    	rtn[1] = "setDateOver";
		        	    	map.put("PASSWORD", pwdSha);

		        	    	ssm.doUpdate(map, addMap);
	        	    	
		        	    }else if(pwdSha.equals(PASSWORD)){	    //비밀번호 일치함.
		        	    	success_yn = "Y";
		        	    
		        	    }else if(pwdMd5.equals(PASSWORD_OLD)){	//비밀번호 일치함.
		        	    	success_yn = "Y";
		        	    	pwd_new   = pwdSha;
		        	    }
 	                    
 	                    
 	                   if("Y".equals(success_yn)){		
		        	    	sxp = new SepoaXmlParser(this, "svcSetLogin_Login_ICT");
			                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			                map.put("password", pwdSha);
				            rtn[0] = ssm.doSelect(map, addMap);
			                SepoaFormater sf = new SepoaFormater(rtn[0]);

			                if(sf.getRowCount() > 0){

			                	sxp = new SepoaXmlParser(this, "svcSetLogin_Update_New_ICT");
			                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			                    map.put("PASS_CHECK_CNT", "0");
			                    map.put("LAST_LOGIN_IP" , userIp);
			                    map.put("pwd_new"      , pwdSha);
			                    map.put("current_day"   , current_day); 
			        	    	map.put("current_time"  , current_time); 
			                    ssm.doUpdate(map);
			                    
			                }else{
			                	throw new Exception("사용자의 ID 혹은 암호가 일치하지 않습니다.");
			                }
			                
	                	}
	                	
	                }
               

	            }

	            Commit();

            }else{
            	//사용자 ID가 없음.
            	throw new Exception("사용자의 ID가 존재하지 않습니다.");
            
            }
        }
        catch (Exception e)
        {
        	Rollback();
            rtn[1] = e.getMessage();
            // e.printStackTrace();
            Logger.err.println(ID, this, e);
        }
        finally
        {
           	ctx = null;
        }
        return rtn;	
        
    }
 
    /* local login 사용 */
    private String[] svcSetLocalLogin(Map<String, String> map) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        
        String success_yn = "";
        String pwd_new   = "";
        String current_day = SepoaDate.getShortDateString();
        String current_time= SepoaDate.getShortTimeString();
    	String date3m = SepoaDate.addSepoaDateMonth(current_day,-3);
        
    	//directLogin 체크
        String strDirect    = map.get("direct");
        String pwdMd5       = map.get("pwdMd5");
        String pwdSha       = map.get("pwdSha");
        String userIp       = map.get("userIp");
        String mode         = map.get("mode");		//비밀번호 변경
        String new_password = map.get("new_password");
        String fromsite     = map.get("fromsite");
        
        try
        {
            Map<String, String> addMap = new HashMap<String, String>();
            String houseCode = info.getSession("HOUSE_CODE");
            if(houseCode != null && houseCode.length() > 0) {
                addMap.put("house_code", houseCode);
            }
            addMap.put("fromsite", fromsite);
            addMap.put("user_id", map.get("user_id"));

            SepoaXmlParser sxp = new SepoaXmlParser(this, "svcSetLocal_Login");
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);

            rtn[0] = ssm.doSelect(map, addMap);
            SepoaFormater sf = new SepoaFormater(rtn[0]);
            if(sf.getRowCount() < 0 ){	//사용자 ID 존재하지 않음
            	throw new Exception("사용자의 ID가 존재하지 않습니다.");
            }
        }
        catch (Exception e)
        {
        	Rollback();
            rtn[1] = e.getMessage();
            Logger.err.println(ID, this, e);
        }
        finally
        {
           	ctx = null;
        }
        return rtn;	
        
    }
    
    
    /**
	 * 공인인증서 로그인
	 * @method setXecureLogin
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-12-16
	 * @modify 2014-12-16
	 */
    public SepoaOut setXecureLogin(Map<String, String> paramMap) throws Exception {
	    SepoaOut out = null;
    	try {
    		out = et_setXecureLogin(paramMap);
    	} catch(Exception e) {
    		Logger.err.println(info.getSession("ID"), this, e);
    	}
	    return out;
    }
   
    /**
	 * 공인인증서 로그인
	 * @method et_setXecureLogin
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-12-16
	 * @modify 2014-12-16
	 */
    public SepoaOut et_setXecureLogin(Map<String, String> map)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcSetXecureLogin(map);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }
            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }
    
    /**
	 * 공인인증서 로그인
	 * @method svcSetXecureLogin
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-12-16
	 * @modify 2014-12-16
	 */
    private String[] svcSetXecureLogin(Map<String, String> map) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        
        //directLogin 체크
        String verifierKey = map.get("verifierKey");
        
        
        
        try
        {
            Map<String, String> addMap = new HashMap<String, String>();
           
            map.put("force_login_flag" , "true");			//강제로그인
            map.put("language"         , "KO");			
            addMap.put("verifierKey"   , verifierKey);	//공인인증키
            
            String houseCode = info.getSession("HOUSE_CODE");
            if(houseCode != null && houseCode.length() > 0) {
                map.put("house_code", houseCode);
                addMap.put("house_code", houseCode);
            }

            SepoaXmlParser sxp = new SepoaXmlParser();
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            SepoaFormater wff1 = new SepoaFormater(ssm.doSelect(map, addMap));
            String USER_ID = "";
            String PW_RESET_FLAG = "";
            String Pw_reset_cnt  = "";
            if(wff1.getRowCount()>0){
	            USER_ID       = wff1.getValue("USER_ID",0);
	            PW_RESET_FLAG = wff1.getValue("PW_RESET_FLAG",0);
	            Pw_reset_cnt  = wff1.getValue("PASS_CHECK_CNT",0);
            }
            map.put("user_id", USER_ID);
            sxp = new SepoaXmlParser(this, "svcSetLogin_SELECT_userType");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            SepoaFormater wff = new SepoaFormater(ssm.doSelect(map, addMap));

            String USER_TYPE = "";
            if(wff.getRowCount()>0)
            {	
        	    USER_TYPE = wff.getValue("USER_TYPE",0);
        	    
                if(PW_RESET_FLAG.equals("Y") && !Pw_reset_cnt.equals("0")){
//                	byte[] b64_enc =JetsUtil.encodeBase64(_password.getBytes());
//                	_password = new String(b64_enc);
                }        	    
        	    
                sxp = new SepoaXmlParser(this, "svcSetLogin_UPDATE_language");
                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                
                ssm.doUpdate(map, addMap);
                //if("true".equals(strDirect)){
                 
                //}
                sxp = new SepoaXmlParser(this, "svcSetLogin_Login");
                sxp.addVar("force_login_flag" , "true");
                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	            rtn[0] = ssm.doSelect(map, addMap);
	            Commit();
            }
        }
        catch (Exception e)
        {
        	Rollback();
            rtn[1] = e.getMessage();
            // e.printStackTrace();
            Logger.err.println(ID, this, e);
        }
        finally
        {
           	ctx = null;
        }
        return rtn;	
        
    }
    
    public SepoaOut setScssReqProcess_ICT(SepoaInfo _info)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcSetScssReqProcess_ICT(_info);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }

            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }
    
    private String[] svcSetScssReqProcess_ICT(SepoaInfo _info) throws Exception
    {
    	String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = null;
        StringBuffer sql = new StringBuffer();
        String now_date = SepoaDate.getShortDateString();
        String now_time = SepoaDate.getShortTimeString();

        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		
		// 담당자(행번,회신번호)
		String ChrId = "";
		String ChrNmloc = "";
		String ChrNmEng = "";
		String ChrDept = "";
		String ChrMobile = "";
		String trCallBack = "";

		// SYSTEM 계정
		String sysId = "";
		
		String adm1_mobile = "";
		String adm2_mobile = "";
		String adm3_mobile = "";
		String adm1_id = "";
		String adm2_id = "";
		String adm3_id = "";
		
		// 업체
		String vend_mobile = "";
		String vend_name = "";
		
		String smsMsg = "";
		
        try
        {
        	ctx = getConnectionContext();
            
            //SepoaOut wo = DocumentUtil.getDocNumber(null, "USERLOG", "H");
            String user_log_no = (new StringBuilder(String.valueOf(_info.getSession("ID")))).append("-").append(SepoaDate.getTimeStampString()).toString();
            //String user_log_no = "";

            //if (wo.status == 1)
            //{
             //   user_log_no = wo.result[0];
            //}

            Map map = new HashMap();
            map.put("user_log_no", user_log_no);
            map.put("userType", info.getSession("USER_TYPE"));
            map.put("id", info.getSession("ID"));
            map.put("nameLoc", info.getSession("NAME_LOC"));
            map.put("now_date", now_date);
            map.put("now_time", now_time);
            map.put("userIp", info.getSession("USER_IP"));
            map.put("house_code", info.getSession("HOUSE_CODE"));
            map.put("vendor_code", info.getSession("COMPANY_CODE"));
            
            
            
            /*
            SepoaXmlParser sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT1");
            SepoaSQLManager ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doInsert(map);
            */
            
            sxp = new SepoaXmlParser( this, "svcGetScssReqProcess_ICT" );
			ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
			sf  = new SepoaFormater( ssm.doSelect( map ) );
			if(sf.getValue("CNT", 0).equals("1")){
				throw new Exception("이미 탈퇴요청하셨습니다.");
			}
            
            sxp = new SepoaXmlParser(this,"svcSetScssReqProcess_ICT");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
                        
			sxp = new SepoaXmlParser( this, "svcSetScssProcess_ICT0" );
			ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
			sf  = new SepoaFormater( ssm.doSelect( map ) );
			
			for (int i = 0; i < sf.getRowCount(); i++) {				
				if( "0001".equals( sf.getValue( "CODE", i ) ) ) {//CODE가 0001이면... (이 분기가 SCODE에서 CODE로 관리하는 값이어야함)					
					//담당자 정보 저장
					ChrId     = sf.getValue("TEXT1", i).trim();
//					ChrNmloc  = sf.getValue("TEXT2", i).trim();
//					ChrNmEng  = sf.getValue("TEXT3", i).trim();
//					ChrDept   = sf.getValue("TEXT4", i).trim();
					ChrMobile = sf.getValue("TEXT5", i).trim();
					trCallBack   = sf.getValue("TEXT6", i).trim();					
				} else if( "0002".equals( sf.getValue( "CODE", i ) ) ) {					
					//시스템 정보 저장
					sysId = sf.getValue("TEXT1", i);					
				} else if( "0003".equals( sf.getValue( "CODE", i ) ) ) {					
					//관리자 정보 저장
					adm1_id     = sf.getValue( "TEXT1", i );
					adm1_mobile = sf.getValue( "TEXT5", i );					
				} else if( "0004".equals( sf.getValue( "CODE", i ) ) ) {					
					//관리자 정보 저장
					adm2_id     = sf.getValue( "TEXT1", i );
					adm2_mobile = sf.getValue( "TEXT5", i );					
				} else if( "0005".equals( sf.getValue( "CODE", i ) ) ) {					
					//관리자 정보 저장
					adm3_id     = sf.getValue( "TEXT1", i );
					adm3_mobile = sf.getValue( "TEXT5", i );					
				} else {
					vend_mobile = sf.getValue( "TEXT5", i );
					vend_name   = sf.getValue( "VENDOR_NAME_LOC", i );
				}
			}
			
			smsMsg = vend_name + "가 WOORI전자입찰을 탈퇴요청하였습니다.수신거부 0808151265";
			//TOBE 2017-07-01 
			//ASIS setSmsData(ctx, ChrMobile, smsMsg, sysId, trCallBack);	        			
			//ASIS setSmsData(ctx, vend_mobile, smsMsg, sysId, trCallBack);
			setSmsData(ctx, ChrMobile, smsMsg, sysId, trCallBack, "SMWMGSGF0001671", vend_name);	        			
			setSmsData(ctx, vend_mobile, smsMsg, sysId, trCallBack, "SMWMGSGF0001671", vend_name);
//			setTlkData(ctx, ChrMobile, smsMsg, sysId, trCallBack, "WBWMGSGF0120630", vend_name);	        			
//			setTlkData(ctx, vend_mobile, smsMsg, sysId, trCallBack, "WBWMGSGF0120630", vend_name);
								                
            Commit();
        }
        catch (Exception e)
        {
            Rollback();
            rtn[1] = e.getMessage();
            
            Logger.debug.println(ID, this, e.getMessage());
        }

        return rtn;
    }

    
    public SepoaOut setScssProcess_ICT(SepoaInfo _info,String vendor_code)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcSetScssProcess_ICT(_info,vendor_code);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }

            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }
    
    private String[] svcSetScssProcess_ICT(SepoaInfo _info,String vendor_code) throws Exception
    {
    	String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = null;
        StringBuffer sql = new StringBuffer();
        String now_date = SepoaDate.getShortDateString();
        String now_time = SepoaDate.getShortTimeString();

        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		
		// 담당자(행번,회신번호)
		String ChrId = "";
		String ChrNmloc = "";
		String ChrNmEng = "";
		String ChrDept = "";
		String ChrMobile = "";
		String trCallBack = "";

		// SYSTEM 계정
		String sysId = "";
		
		String adm1_mobile = "";
		String adm2_mobile = "";
		String adm3_mobile = "";
		String adm1_id = "";
		String adm2_id = "";
		String adm3_id = "";
		
		// 업체
		String vend_mobile = "";
		String vend_name = "";
		
		String smsMsg = "";
		
        try
        {
        	ctx = getConnectionContext();
            
            //SepoaOut wo = DocumentUtil.getDocNumber(null, "USERLOG", "H");
            String user_log_no = (new StringBuilder(String.valueOf(_info.getSession("ID")))).append("-").append(SepoaDate.getTimeStampString()).toString();
            //String user_log_no = "";

            //if (wo.status == 1)
            //{
             //   user_log_no = wo.result[0];
            //}

            Map map = new HashMap();
            map.put("user_log_no", user_log_no);
            map.put("userType", info.getSession("USER_TYPE"));
            map.put("id", info.getSession("ID"));
            map.put("nameLoc", info.getSession("NAME_LOC"));
            map.put("now_date", now_date);
            map.put("now_time", now_time);
            map.put("userIp", info.getSession("USER_IP"));
            map.put("house_code", info.getSession("HOUSE_CODE"));
            map.put("vendor_code", vendor_code);
            
            
            
            /*
            SepoaXmlParser sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT1");
            SepoaSQLManager ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doInsert(map);
            */
            
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT2");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
            
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT3");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
            
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT4");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
            
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT5");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
            
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT6");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
            
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT7");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
			
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT8");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
			
            sxp = new SepoaXmlParser(this,"svcSetScssProcess_ICT9");
            ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp);
            ssm.doUpdate(map);
            
			sxp = new SepoaXmlParser( this, "svcSetScssProcess_ICT0" );
			ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
			sf  = new SepoaFormater( ssm.doSelect( map ) );
			
			for (int i = 0; i < sf.getRowCount(); i++) {				
				if( "0001".equals( sf.getValue( "CODE", i ) ) ) {//CODE가 0001이면... (이 분기가 SCODE에서 CODE로 관리하는 값이어야함)					
					//담당자 정보 저장
					ChrId     = sf.getValue("TEXT1", i).trim();
//					ChrNmloc  = sf.getValue("TEXT2", i).trim();
//					ChrNmEng  = sf.getValue("TEXT3", i).trim();
//					ChrDept   = sf.getValue("TEXT4", i).trim();
					ChrMobile = sf.getValue("TEXT5", i).trim();
					trCallBack   = sf.getValue("TEXT6", i).trim();					
				} else if( "0002".equals( sf.getValue( "CODE", i ) ) ) {					
					//시스템 정보 저장
					sysId = sf.getValue("TEXT1", i);					
				} else if( "0003".equals( sf.getValue( "CODE", i ) ) ) {					
					//관리자 정보 저장
					adm1_id     = sf.getValue( "TEXT1", i );
					adm1_mobile = sf.getValue( "TEXT5", i );					
				} else if( "0004".equals( sf.getValue( "CODE", i ) ) ) {					
					//관리자 정보 저장
					adm2_id     = sf.getValue( "TEXT1", i );
					adm2_mobile = sf.getValue( "TEXT5", i );					
				} else if( "0005".equals( sf.getValue( "CODE", i ) ) ) {					
					//관리자 정보 저장
					adm3_id     = sf.getValue( "TEXT1", i );
					adm3_mobile = sf.getValue( "TEXT5", i );					
				} else {
					vend_mobile = sf.getValue( "TEXT5", i );
					vend_name   = sf.getValue( "VENDOR_NAME_LOC", i );
				}
			}
			
			smsMsg = vend_name + "가 WOORI전자입찰을 탈퇴하였습니다.수신거부 0808151265";
			
			//TOBE 2017-07-01 
			//ASIS setSmsData(ctx, ChrMobile, smsMsg, sysId, trCallBack);	        			
			//ASIS setSmsData(ctx, vend_mobile, smsMsg, sysId, trCallBack);	        
			setSmsData(ctx, ChrMobile, smsMsg, sysId, trCallBack, "SMWMGSGF0001672", vend_name);	        			
			setSmsData(ctx, vend_mobile, smsMsg, sysId, trCallBack, "SMWMGSGF0001672", vend_name);	        
//			setTlkData(ctx, ChrMobile, smsMsg, sysId, trCallBack, "WBWMGSGF0120631", vend_name);	        			
//			setTlkData(ctx, vend_mobile, smsMsg, sysId, trCallBack, "WBWMGSGF0120631", vend_name);	        
			
            Commit();
        }
        catch (Exception e)
        {
            Rollback();
            rtn[1] = e.getMessage();
            
            Logger.debug.println(ID, this, e.getMessage());
        }

        return rtn;
    }
    
    private void setSmsData(ConnectionContext ctx, String mobile_no,String message,String sysId,String trCallBack
    		,String ums_tmpl_cd , String mpng_1  //TOBE 2017-07-01 추가 템플릿코드, 매핑1
    		) throws Exception {
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		HashMap<String, String> smsMap = new HashMap<String, String>();
		
        /* TOBE 2017-07-01 ICT 글로벌 상수 */
        String default_ict_jumcd   = sepoa.svc.common.constants.DEFAULT_ICT_JUMCD;
        /* TOBE 2017-07-01 ICT 글로벌 상수 */
        smsMap.put("DEFAULT_ICT_JUMCD", default_ict_jumcd);
        
		smsMap.put("sysid", sysId);
		smsMap.put("trCallBack", trCallBack);
		//smsMap.put("mobile_no", "0000000000");
		smsMap.put("mobile_no", mobile_no);
		//message = new String(message.getBytes("utf-8"), "euc-kr");
		smsMap.put("message", message);
		
		//TOBE 2017-07-01 추가
		smsMap.put("UMS_TMPL_CD", ums_tmpl_cd);
		smsMap.put("MPNG_1", mpng_1);
		smsMap.put("MPNG_2", "");
		smsMap.put("MPNG_3", "");
		
		sxp = new SepoaXmlParser(this, "I_SMS");
		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		ssm.doInsert(smsMap);

	}
    
    private void setTlkData(ConnectionContext ctx, String mobile_no,String message,String sysId,String trCallBack
    		,String ums_tmpl_cd , String mpng_1  //TOBE 2017-07-01 추가 템플릿코드, 매핑1
    		) throws Exception {
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		HashMap<String, String> tlkMap = new HashMap<String, String>();
		
        /* TOBE 2017-07-01 ICT 글로벌 상수 */
        String default_ict_jumcd   = sepoa.svc.common.constants.DEFAULT_ICT_JUMCD;
        /* TOBE 2017-07-01 ICT 글로벌 상수 */
        tlkMap.put("DEFAULT_ICT_JUMCD", default_ict_jumcd);
        
		tlkMap.put("sysid", sysId);
		tlkMap.put("trCallBack", trCallBack);
		//tlkMap.put("mobile_no", "0000000000");
		tlkMap.put("mobile_no", mobile_no);
		//message = new String(message.getBytes("utf-8"), "euc-kr");
		tlkMap.put("message", message);
		
		//TOBE 2017-07-01 추가
		tlkMap.put("UMS_TMPL_CD", ums_tmpl_cd);
		tlkMap.put("MPNG_1", mpng_1);
		tlkMap.put("MPNG_2", "");
		tlkMap.put("MPNG_3", "");
		tlkMap.put("UMS_SMS_CNVSD_YN", "Y");
		
		sxp = new SepoaXmlParser(this, "I_TLK");
		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
		ssm.doInsert(tlkMap);

	}
    
    public SepoaOut setLogoutProcess(SepoaInfo _info)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcSetLogoutProcess(_info);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }

            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

    private String[] svcSetLogoutProcess(SepoaInfo _info) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        String now_date = SepoaDate.getShortDateString();
        String now_time = SepoaDate.getShortTimeString();

        try
        {
            //SepoaOut wo = DocumentUtil.getDocNumber(null, "USERLOG", "H");
            String user_log_no = (new StringBuilder(String.valueOf(_info.getSession("ID")))).append("-").append(SepoaDate.getTimeStampString()).toString();
            //String user_log_no = "";

            //if (wo.status == 1)
            //{
             //   user_log_no = wo.result[0];
            //}

            Map map = new HashMap();
            map.put("user_log_no", user_log_no);
            map.put("userType", info.getSession("USER_TYPE"));
            map.put("id", info.getSession("ID"));
            map.put("nameLoc", info.getSession("NAME_LOC"));
            map.put("now_date", now_date);
            map.put("now_time", now_time);
            map.put("userIp", info.getSession("USER_IP"));
            
            SepoaXmlParser sxp = new SepoaXmlParser();
            SepoaSQLManager ssm = new SepoaSQLManager(_info.getSession("ID"), this, ctx, sxp.getQuery());
            ssm.doInsert(map);
               
            Commit();
        }
        catch (Exception e)
        {
            Rollback();
            rtn[1] = e.getMessage();
            
            Logger.debug.println(ID, this, e.getMessage());
        }

        return rtn;
    }

    public SepoaOut setLoginProcess(SepoaInfo _info)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcSetLoginProcess(_info);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
                setStatus(0);
                setFlag(false);
            }

            setValue(rtn[0]);
        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

    private String[] svcSetLoginProcess(SepoaInfo _info) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        String now_date = SepoaDate.getShortDateString();
        String now_time = SepoaDate.getShortTimeString();

        try
        {
            ParamSql sm = new ParamSql(_info.getSession("ID"), this, ctx);
            String user_log_no = (new StringBuilder(String.valueOf(_info.getSession("ID")))).append("-").append(SepoaDate.getTimeStampString()).toString();
            sql.append(" INSERT INTO sulog     \n");
            sql.append(" (                        \n");
            sql.append("      NO,                 \n");
            sql.append("      USER_TYPE, \n");
            sql.append("      USER_ID,            \n");
            sql.append("      USER_NAME_LOC,           \n");
            sql.append("      PROGRAM,            \n");
            sql.append("      PROGRAM_DESC,       \n");
            sql.append("      JOB_TYPE,           \n");
            sql.append("      JOB_DATE,           \n");
            sql.append("      JOB_TIME,           \n");
            sql.append("      IP,                 \n");
            sql.append("      PROCESS_ID,         \n");
            sql.append("      METHOD_NAME         \n");
            sql.append(" ) VALUES (               \n");
            sql.append((new StringBuilder("      '")).append(user_log_no).append("',  \n").toString());
            sql.append((new StringBuilder("      '")).append(_info.getSession("USER_TYPE")).append("', \n ").toString());
            sql.append((new StringBuilder("      '")).append(_info.getSession("ID")).append("',           \n").toString());
            sql.append("      ?,\n");
            sm.addStringParameter(_info.getSession("NAME_LOC"));
            sql.append("      'Login',            \n");
            sql.append("      'Login',            \n");
            sql.append("      'LI',               \n");
            sql.append((new StringBuilder("      '")).append(now_date).append("',    \n").toString());
            sql.append((new StringBuilder("      '")).append(now_time).append("',    \n").toString());
            sql.append((new StringBuilder("      '")).append(_info.getSession("USER_IP")).append("', \n").toString());
            sql.append("      'CO_004',         \n");
            sql.append("      'Login'              \n");
            sql.append(" ) \n");
            sm.doInsert(sql.toString());
            
            sm.removeAllValue();
            sql.delete(0, sql.length());
            sql.append(" update ICOMLUSR set \n ");
            sql.append(" last_login_date = ?, \n ");sm.addStringParameter(SepoaDate.getShortDateString());
            sql.append(" last_login_time = ?, \n ");sm.addStringParameter(SepoaDate.getShortTimeString());
            sql.append(" last_login_ip = ? \n ");sm.addStringParameter(info.getSession("USER_IP"));
            sql.append(" where user_id = ? \n ");sm.addStringParameter(info.getSession("ID"));
            sql.append(" and company_code = ? \n ");sm.addStringParameter(info.getSession("COMPANY_CODE"));
            sm.doUpdate(sql.toString());

            Commit();
        }
        catch (Exception e)
        {
            Rollback();
            rtn[1] = e.getMessage();
            
            Logger.debug.println(ID, this, e.getMessage());
        }

        return rtn;
    }

    public SepoaOut getBulletinList(int rownum, String language)
    {
        try
        {
        	String rtn = et_getBulletinList(rownum, language);
        	String rtn1 = et_getBulletinList1(rownum, language);
            setStatus(1);
            setValue(rtn);
            setValue(rtn1);
            setMessage("true");
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(e.getMessage());
        }

        return getSepoaOut();
    }
    
    private String et_getBulletinList1(int rownum, String language) throws Exception {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append((new StringBuilder(" select top ")).append(rownum).append(" a.* from ( \n ").toString());
        }
        else
        {
            tSQL.append(" select a.* from ( \n ");
        }

        tSQL.append(" SELECT SNOTE.SUBJECT  \n");
        tSQL.append(" ,SNOTE.SEQ \n ");
        tSQL.append(", SNOTE.ADD_DATE \n ");
        tSQL.append(" FROM SNOTE \n ");
        tSQL.append(" WHERE \n ");
        tSQL.append(" " + DB_NULL_FUNCTION + "(SNOTE.DEL_FLAG, 'N') <> 'Y' \n ");
        tSQL.append("   and " + DB_NULL_FUNCTION + "(GONGJI_GUBUN, ' ') in ('R')  \n ");
        tSQL.append("   and COMPANY_CODE='"+info.getSession("COMPANY_CODE")+"'  \n ");

        if (!SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" SEQ DESC\n");
        }

        tSQL.append(" ) a \n ");

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" a.ADD_DATE DESC\n");
        }

        if (rownum > 0)
        {
            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                tSQL.append((new StringBuilder(" where rownum <= ")).append(rownum).toString());
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                tSQL.append((new StringBuilder(" limit ")).append(rownum).toString());
            }
        }

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect((String[])null);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    private String et_getBulletinList(int rownum, String language) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append((new StringBuilder(" select top ")).append(rownum).append(" a.* from ( \n ").toString());
        }
        else
        {
            tSQL.append(" select a.* from ( \n ");
        }

        tSQL.append(" SELECT SNOTE.SUBJECT  \n");
        tSQL.append(" ,SNOTE.SEQ \n ");
        tSQL.append(", SNOTE.ADD_DATE \n ");
        tSQL.append(" FROM SNOTE \n ");
        tSQL.append(" WHERE \n ");
        tSQL.append(" " + DB_NULL_FUNCTION + "(SNOTE.DEL_FLAG, 'N') <> 'Y' \n ");
        //tSQL.append("   and " + DB_NULL_FUNCTION + "(GONGJI_GUBUN, ' ') in ('A')  \n ");
        //tSQL.append("   and COMPANY_CODE='"+info.getSession("COMPANY_CODE")+"'  \n ");

        if (!SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" SEQ DESC\n");
        }

        tSQL.append(" ) a \n ");

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" a.SEQ DESC\n");
        }

        if (rownum > 0)
        {
            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                tSQL.append((new StringBuilder(" where rownum <= ")).append(rownum).toString());
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                tSQL.append((new StringBuilder(" limit ")).append(rownum).toString());
            }
        }

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect((String[])null);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public SepoaOut getFaqList(int rownum, String language)
    {
        try
        {
        	String rtn = et_getFaqList(rownum, language);
        	String rtn1 = et_getFaqList1(rownum, language);
            setStatus(1);
            setValue(rtn);
            setValue(rtn1);
            setMessage("true");
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(e.getMessage());
        }

        return getSepoaOut();
    }
    
    private String et_getFaqList1(int rownum, String language) throws Exception {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append((new StringBuilder(" select top ")).append(rownum).append(" a.* from ( \n ").toString());
        }
        else
        {
            tSQL.append(" select a.* from ( \n ");
        }

        tSQL.append(" SELECT SFAQ.SUBJECT  \n");
        tSQL.append(" ,SFAQ.SEQ \n ");
        tSQL.append(", SFAQ.ADD_DATE \n ");
        tSQL.append(" FROM SFAQ \n ");
        tSQL.append(" WHERE \n ");
        tSQL.append(" " + DB_NULL_FUNCTION + "(SFAQ.DEL_FLAG, 'N') <> 'Y' \n ");
        //tSQL.append("   and " + DB_NULL_FUNCTION + "(GONGJI_GUBUN, ' ') in ('R')  \n ");
        tSQL.append("   and COMPANY_CODE='"+info.getSession("COMPANY_CODE")+"'  \n ");

        if (!SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" SEQ DESC\n");
        }

        tSQL.append(" ) a \n ");

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" a.ADD_DATE DESC\n");
        }

        if (rownum > 0)
        {
            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                tSQL.append((new StringBuilder(" where rownum <= ")).append(rownum).toString());
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                tSQL.append((new StringBuilder(" limit ")).append(rownum).toString());
            }
        }

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect((String[])null);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    private String et_getFaqList(int rownum, String language) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append((new StringBuilder(" select top ")).append(rownum).append(" a.* from ( \n ").toString());
        }
        else
        {
            tSQL.append(" select a.* from ( \n ");
        }

        tSQL.append(" SELECT SFAQ.SUBJECT  \n");
        tSQL.append(" ,SFAQ.SEQ \n ");
        tSQL.append(", SFAQ.ADD_DATE \n ");
        tSQL.append(" FROM SFAQ \n ");
        tSQL.append(" WHERE \n ");
        tSQL.append(" " + DB_NULL_FUNCTION + "(SFAQ.DEL_FLAG, 'N') <> 'Y' \n ");
        //tSQL.append("   and " + DB_NULL_FUNCTION + "(GONGJI_GUBUN, ' ') in ('A')  \n ");
        //tSQL.append("   and COMPANY_CODE='"+info.getSession("COMPANY_CODE")+"'  \n ");

        if (!SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" SEQ DESC\n");
        }

        tSQL.append(" ) a \n ");

        if (SEPOA_DB_VENDOR.equals("MSSQL"))
        {
            tSQL.append(" ORDER BY \t\n");
            tSQL.append(" a.SEQ DESC\n");
        }

        if (rownum > 0)
        {
            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                tSQL.append((new StringBuilder(" where rownum <= ")).append(rownum).toString());
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                tSQL.append((new StringBuilder(" limit ")).append(rownum).toString());
            }
        }

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect((String[])null);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    
    public SepoaOut getBulletin(String _seq)
    {
        try
        {
            String rtn = et_getBulletin(_seq);
            setStatus(1);
            setValue(rtn);
            setMessage("true");
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(e.getMessage());
        }

        return getSepoaOut();
    }

    private String et_getBulletin(String _seq) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT SUBJECT  \n");
        tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = SNOTE.COMPANY_CODE),'') AS COMPANY_NAME \n ").toString());
        tSQL.append(" , ADD_DATE  \t\n");
        tSQL.append((new StringBuilder(", ")).append(SEPOA_DB_OWNER).append("getusername(add_user_id, '").append(info.getSession("LANGUAGE")).append("','").append(info.getSession("COMPANY_CODE")).append("') ADD_USER_NAME \n ").toString());
        tSQL.append(" , ATTACH_NO  \t\n");
        tSQL.append(" , CONTENT   \t\n");
        tSQL.append(" , SEQ   \n");
        tSQL.append(" , NOTE_TYPE\n");
        tSQL.append(" FROM SNOTE  \n");
        tSQL.append(" WHERE \n");
        tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(DEL_FLAG, 'N') <> 'Y' \t\n").toString());
        tSQL.append((new StringBuilder("   and seq = ")).append(_seq).append(" \n ").toString());

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect((String[])null);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    //#########################################  alice method   #####################################################


    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% getBulletin %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public SepoaOut getBulletin_New(String _seq, String language)
    {
        try
        {
            String rtn = et_getBulletin_New(_seq, language);
            setValue(rtn);

            rtn = et_getBulletin_New_contents(_seq);
            setValue(rtn);

            rtn = et_getBulletin_New_contents1(_seq,language);
            setValue(rtn);

            setStatus(1);
            setMessage("true");
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(e.getMessage());
        }

        return getSepoaOut();
    }

    private String et_getBulletin_New(String _seq, String language) throws Exception
    {
    	String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
        {
	        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	        sm.removeAllValue();
	        sb.append(" SELECT  \t\n");
	        sb.append("\t  note.SUBJECT  \t\n");
	        sb.append(" , ADD_DATE  \t\n");
	        sb.append((new StringBuilder(", ")).append(SEPOA_DB_OWNER).append("getusername(add_user_id, '").append(info.getSession("LANGUAGE")).append("','").append(info.getSession("COMPANY_CODE")).append("') ADD_USER_NAME \n ").toString());
	        sb.append((new StringBuilder("\t, ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = note.COMPANY_CODE),'') AS COMPANY_NAME\t\n").toString());
	        sb.append("\t, " + SEPOA_DB_OWNER +"getCodeText1('M216',dept_type, '" + language + "') dept_type \n");
	        sb.append("\t, note.ATTACH_NO \n");
	        sb.append("\t, note.NOTE_TYPE \n");
	        sb.append("\t, note.VIEW_COUNT \n");
	        sb.append(" FROM SNOTE note \t\n");
	        sb.append(" WHERE 1 = 1 \n");
	        sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(_seq);
	        sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
	        rtn = sm.doSelect(sb.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private String et_getBulletin_New_contents1(String _seq, String language) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
        {
	        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	        sm.removeAllValue();
	        sb.append(" SELECT 											\n");
	        sb.append(" TE.SEQ		 									\n");
	        sb.append(","+SEPOA_DB_OWNER+"getCodeText1('M002',GL.CUR,'"+language+"') AS CUR \n");
	        sb.append(",NOTE_TYPE 										\n");
			sb.append(",GL.RFQ_CLOSE_DATE 								\n");
			sb.append(",GL.RFQ_CLOSE_TIME 								\n");
			sb.append(","+SEPOA_DB_OWNER+"getCodeText1('M005',GL.ESTIMATE_TYPE,'"+language+"') AS ESTIMATE_TYPE \n");
			sb.append(",GL.PR_ITEM  									\n");
			sb.append(",GL.REMARK	  									\n");
	        sb.append(" FROM SNOTE TE									\n");
			sb.append(" LEFT OUTER JOIN SRQGL GL						\n");
			sb.append(" ON GL.RFQ_NUMBER = TE.RFQ_NUMBER				\n");
			sb.append(" AND GL.RFQ_COUNT='1'							\n");
			sb.append(sm.addFixString(" WHERE TE.SEQ = ? 				\n")); sm.addStringParameter(_seq);
	        rtn = sm.doSelect(sb.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    private String et_getBulletin_New_contents(String _seq) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
        {
	        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	        sm.removeAllValue();
	        sb.append(" SELECT CONTENT \t\n");
	        sb.append(" FROM snotd note \t\n");
	        sb.append(" WHERE 1 = 1 \n");
	        sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(_seq);
	        sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
	        sb.append(" order by seq_seq \n ");
	        rtn = sm.doSelect(sb.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    /**
     * 자료실 조회
     * @param pg_no
     * @param pg_row
     * @param gubun
     * @param quest
     * @param search
     * @param con_type
     * @return
     * @throws Exception
     */
    public SepoaOut getQuery_dataStore_ICOMMACH(String pg_no, String pg_row, String gubun, String quest, String search, String con_type) throws Exception{
		try
		{

			String rtn = null;
			String rtn_YN = null;

            String pageNum = pg_no 		;//== null || pg_no.equals("") ? "" : pg_no;
            String pageSize = pg_row 	;//== null || pg_row.equals("") ? "" : pg_row;
            String s_gubun = gubun 		;//== null || gubun.equals("") ? "" : gubun;
            String s_quest = quest 		;//== null || quest.equals("") ? "" : quest;
            String s_search = search 	;//== null || search.equals("") ? "" : search;
			// Isvalue(); ....

			rtn_YN = et_getQueryTotCount_dataStore_ICOMMACH(s_gubun, s_quest, s_search, con_type);

			SepoaFormater wf = new SepoaFormater(rtn_YN);
			String count = wf.getValue(0,0);

            //Logger.debug.println(info.getSession("ID"), this, "게시물 총 카운드=="+count);

			rtn = et_getQuery_dataStore_ICOMMACH(pageNum, pageSize, count, s_gubun, s_quest, s_search, con_type);

			setValue(rtn_YN);
			setValue(rtn);
			setStatus(1);

		} catch(Exception e) {
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println("SYSTEM",this,"Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}
    
    private String et_getQueryTotCount_dataStore_ICOMMACH(String gubun, String quest, String search, String con_type) throws Exception
	{

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("search", search);
			wxp.addVar("gubun", gubun);
			wxp.addVar("con_type", con_type);
			wxp.addVar("quest", quest);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

//			tSQL.append( "	SELECT COUNT(*) \n");
//			tSQL.append( "	FROM ICOMNOTE \n");
//			tSQL.append( "	WHERE STATUS <> 'D' \n");
//	        if(!search.equals("")){
//	            if(gubun.equals("S"))  tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'		\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	        }

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this,ctx, wxp.getQuery());

			rtn = sm.doSelect();

			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
				throw new Exception("et_getQueryTotCount_dataStore_ICOMMACH:"+e.getMessage());
			} finally{
				// Release();
			}
		return rtn;
	}
    
    private String et_getQuery_dataStore_ICOMMACH(String pg_no, String pg_row, String Totcount, String gubun, String quest, String search, String con_type) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			int myPage = Integer.parseInt(pg_no);	     // 현재 화면의 페이지 수
			int myRows = Integer.parseInt(pg_row);       // 현재 화면에 보여지는 Row 갯수
			int totalRows = Integer.parseInt(Totcount);  // 해당 쿼리의 전체 쿼리수...

			int srowm = (myPage * myRows) - (myRows -1);
			int erowm = (myPage * myRows);

            int totPage = totalRows/myRows + ( (totalRows%myRows) > 0 ? 1:0);

            /*
            SELECT TOP [불러올 총 게시물수] [출력 필드명] FROM [테이블 명]
           WHERE [글번호] IN (SELECT TOP [페이지출력 갯수] [글번호] FROM
           (SELECT TOP [불러올 총 게시물수] [글번호] FROM [테이블 명]) AS A ORDER BY [글번호])
           ORDER BY [글번호] DESC
			*/

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("srowm", srowm);
			wxp.addVar("erowm", erowm);
			wxp.addVar("gubun", gubun);
			wxp.addVar("quest", quest);
			wxp.addVar("search", search);
			wxp.addVar("con_type", con_type);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

//			tSQL.append( "SELECT LAST.A, LAST.NO, LAST.SUB, LAST.NAME, LAST.ADD_DATE, LAST.VIEW_COUNT, LAST.ATT_FLAG,  LAST.ATT \n");
//			tSQL.append( "FROM \n");
//			//tSQL.append( "     (SELECT ROWNUM AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "     (SELECT ROW_NUMBER() OVER(ORDER BY aaa.no desc) AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "      FROM \n");
//			tSQL.append( "          (SELECT NO, SUB, NAME,  ADD_DATE, VIEW_COUNT,ATT_FLAG, ATT, A \n");
//			tSQL.append( "           FROM (SELECT ROW_NUMBER() OVER(ORDER BY seq) AS A, \n");
//			tSQL.append( "                       SEQ AS NO, \n");
////			tSQL.append( "                       SUBSTRING(SUBJECT,0,45)||DECODE(SUBSTRING(SUBJECT,30,1),'','','.....(생략)') AS SUB, \n");
//			tSQL.append( "                       SUBSTRING(SUBJECT, 0, 45) + CASE SUBSTRING(SUBJECT, 30, 1) WHEN '' THEN '' ELSE '.....(생략)' END AS SUB, \n");
//			tSQL.append( "                       (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = A.ADD_USER_ID) AS NAME,	 \n");
//			tSQL.append( "                       SUBSTRING(ADD_DATE,0,5)+'-'+SUBSTRING(ADD_DATE,5,2)+'-'+SUBSTRING(ADD_DATE,7,2) AS ADD_DATE, \n");
//			tSQL.append( "                       '' AS VIEW_COUNT, \n");
////			tSQL.append( "                       DECODE(ISNULL(ATTACH_NO,'N'),'','N','N','N','Y') AS ATT_FLAG, \n");
//      tSQL.append( "                       CASE ISNULL(ATTACH_NO, 'N') WHEN '' THEN 'N' WHEN 'N' THEN 'N' ELSE 'Y' END AS ATT_FLAG, \n");
//			tSQL.append( "                       ATTACH_NO AS ATT \n");
//			tSQL.append( "                 FROM ICOMNOTE A  \n");
//			tSQL.append( "                 WHERE STATUS <> 'D' \n");
//			tSQL.append( "                 AND NOTE_TYPE = '"+con_type+"' \n");
//
//	        if(search != null){
//	            if(gubun.equals("S"))  		tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' 																\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' 		\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' 																\n");
//	        }
//
//			tSQL.append( "                 ) TMP \n");
//			tSQL.append( "           ) AAA \n");
//			tSQL.append( "       ) LAST \n");
//			tSQL.append( "WHERE LAST.TTT BETWEEN "+ srowm +" AND "+ erowm + " \n");

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this, ctx, wxp.getQuery());

			rtn = sm.doSelect();
			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
//				e.printStackTrace();
				throw new Exception("et_getQuery_dataStore_ICOMMACH:"+e.getMessage());
			} finally{
				Release();
			}
		return rtn;
	}
    
 
    
    /* ICT 수정 */
    public SepoaOut getQuery_dataStore_ICOMMACH_ICT(String pg_no, String pg_row, String gubun, String quest, String search, String con_type) throws Exception{
		try
		{

			String rtn = null;
			String rtn_YN = null;

            String pageNum = pg_no 		;//== null || pg_no.equals("") ? "" : pg_no;
            String pageSize = pg_row 	;//== null || pg_row.equals("") ? "" : pg_row;
            String s_gubun = gubun 		;//== null || gubun.equals("") ? "" : gubun;
            String s_quest = quest 		;//== null || quest.equals("") ? "" : quest;
            String s_search = search 	;//== null || search.equals("") ? "" : search;
			// Isvalue(); ....

			rtn_YN = et_getQueryTotCount_dataStore_ICOMMACH_ICT(s_gubun, s_quest, s_search, con_type);

			SepoaFormater wf = new SepoaFormater(rtn_YN);
			String count = wf.getValue(0,0);

            //Logger.debug.println(info.getSession("ID"), this, "게시물 총 카운드=="+count);

			rtn = et_getQuery_dataStore_ICOMMACH_ICT(pageNum, pageSize, count, s_gubun, s_quest, s_search, con_type);

			setValue(rtn_YN);
			setValue(rtn);
			setStatus(1);

		} catch(Exception e) {
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println("SYSTEM",this,"Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}
    
    /* ICT 수정 */
   private String et_getQueryTotCount_dataStore_ICOMMACH_ICT(String gubun, String quest, String search, String con_type) throws Exception
	{

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("search", search);
			wxp.addVar("gubun", gubun);
			wxp.addVar("con_type", con_type);
			wxp.addVar("quest", quest);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this,ctx, wxp.getQuery());

			rtn = sm.doSelect();

			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
				throw new Exception("et_getQueryTotCount_dataStore_ICOMMACH:"+e.getMessage());
			} finally{
				// Release();
			}
		return rtn;
	}
    
   /* ICT 수정 */
    private String et_getQuery_dataStore_ICOMMACH_ICT(String pg_no, String pg_row, String Totcount, String gubun, String quest, String search, String con_type) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			int myPage = Integer.parseInt(pg_no);	     // 현재 화면의 페이지 수
			int myRows = Integer.parseInt(pg_row);       // 현재 화면에 보여지는 Row 갯수
			int totalRows = Integer.parseInt(Totcount);  // 해당 쿼리의 전체 쿼리수...

			int srowm = (myPage * myRows) - (myRows -1);
			int erowm = (myPage * myRows);

            int totPage = totalRows/myRows + ( (totalRows%myRows) > 0 ? 1:0);

            /*
            SELECT TOP [불러올 총 게시물수] [출력 필드명] FROM [테이블 명]
           WHERE [글번호] IN (SELECT TOP [페이지출력 갯수] [글번호] FROM
           (SELECT TOP [불러올 총 게시물수] [글번호] FROM [테이블 명]) AS A ORDER BY [글번호])
           ORDER BY [글번호] DESC
			*/

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("srowm", srowm);
			wxp.addVar("erowm", erowm);
			wxp.addVar("gubun", gubun);
			wxp.addVar("quest", quest);
			wxp.addVar("search", search);
			wxp.addVar("con_type", con_type);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this, ctx, wxp.getQuery());

			rtn = sm.doSelect();
			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
//				e.printStackTrace();
				throw new Exception("et_getQuery_dataStore_ICOMMACH:"+e.getMessage());
			} finally{
				Release();
			}
		return rtn;
	}    
    
    
    
	public SepoaOut getQuery_ICOMMACH(String pg_no, String pg_row, String gubun, String quest, String search, String con_type) throws Exception{
		try
		{

			String rtn = null;
			String rtn_YN = null;

            String pageNum = pg_no 		;//== null || pg_no.equals("") ? "" : pg_no;
            String pageSize = pg_row 	;//== null || pg_row.equals("") ? "" : pg_row;
            String s_gubun = gubun 		;//== null || gubun.equals("") ? "" : gubun;
            String s_quest = quest 		;//== null || quest.equals("") ? "" : quest;
            String s_search = search 	;//== null || search.equals("") ? "" : search;
			// Isvalue(); ....

			rtn_YN = et_getQueryTotCount_ICOMMACH(s_gubun, s_quest, s_search, con_type);

			SepoaFormater wf = new SepoaFormater(rtn_YN);
			String count = wf.getValue(0,0);

            //Logger.debug.println(info.getSession("ID"), this, "게시물 총 카운드=="+count);

			rtn = et_getQuery_ICOMMACH(pageNum, pageSize, count, s_gubun, s_quest, s_search, con_type);

			setValue(rtn_YN);
			setValue(rtn);
			setStatus(1);

		} catch(Exception e) {
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println("SYSTEM",this,"Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}




	private String et_getQueryTotCount_ICOMMACH(String gubun, String quest, String search, String con_type) throws Exception
	{

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("search", search);
			wxp.addVar("gubun", gubun);
			wxp.addVar("con_type", con_type);
			wxp.addVar("quest", quest);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

//			tSQL.append( "	SELECT COUNT(*) \n");
//			tSQL.append( "	FROM ICOMNOTE \n");
//			tSQL.append( "	WHERE STATUS <> 'D' \n");
//	        if(!search.equals("")){
//	            if(gubun.equals("S"))  tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'		\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	        }

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this,ctx, wxp.getQuery());

			rtn = sm.doSelect();

			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
				throw new Exception("et_getQueryTotCount_NOTICE:"+e.getMessage());
			} finally{
				// Release();
			}
		return rtn;
	}



	private String et_getQuery_ICOMMACH(String pg_no, String pg_row, String Totcount, String gubun, String quest, String search, String con_type) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			int myPage = Integer.parseInt(pg_no);	     // 현재 화면의 페이지 수
			int myRows = Integer.parseInt(pg_row);       // 현재 화면에 보여지는 Row 갯수
			int totalRows = Integer.parseInt(Totcount);  // 해당 쿼리의 전체 쿼리수...

			int srowm = (myPage * myRows) - (myRows -1);
			int erowm = (myPage * myRows);

            int totPage = totalRows/myRows + ( (totalRows%myRows) > 0 ? 1:0);

            /*
            SELECT TOP [불러올 총 게시물수] [출력 필드명] FROM [테이블 명]
           WHERE [글번호] IN (SELECT TOP [페이지출력 갯수] [글번호] FROM
           (SELECT TOP [불러올 총 게시물수] [글번호] FROM [테이블 명]) AS A ORDER BY [글번호])
           ORDER BY [글번호] DESC
			*/

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("srowm", srowm);
			wxp.addVar("erowm", erowm);
			wxp.addVar("gubun", gubun);
			wxp.addVar("quest", quest);
			wxp.addVar("search", search);
			wxp.addVar("con_type", con_type);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

//			tSQL.append( "SELECT LAST.A, LAST.NO, LAST.SUB, LAST.NAME, LAST.ADD_DATE, LAST.VIEW_COUNT, LAST.ATT_FLAG,  LAST.ATT \n");
//			tSQL.append( "FROM \n");
//			//tSQL.append( "     (SELECT ROWNUM AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "     (SELECT ROW_NUMBER() OVER(ORDER BY aaa.no desc) AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "      FROM \n");
//			tSQL.append( "          (SELECT NO, SUB, NAME,  ADD_DATE, VIEW_COUNT,ATT_FLAG, ATT, A \n");
//			tSQL.append( "           FROM (SELECT ROW_NUMBER() OVER(ORDER BY seq) AS A, \n");
//			tSQL.append( "                       SEQ AS NO, \n");
////			tSQL.append( "                       SUBSTRING(SUBJECT,0,45)||DECODE(SUBSTRING(SUBJECT,30,1),'','','.....(생략)') AS SUB, \n");
//			tSQL.append( "                       SUBSTRING(SUBJECT, 0, 45) + CASE SUBSTRING(SUBJECT, 30, 1) WHEN '' THEN '' ELSE '.....(생략)' END AS SUB, \n");
//			tSQL.append( "                       (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = A.ADD_USER_ID) AS NAME,	 \n");
//			tSQL.append( "                       SUBSTRING(ADD_DATE,0,5)+'-'+SUBSTRING(ADD_DATE,5,2)+'-'+SUBSTRING(ADD_DATE,7,2) AS ADD_DATE, \n");
//			tSQL.append( "                       '' AS VIEW_COUNT, \n");
////			tSQL.append( "                       DECODE(ISNULL(ATTACH_NO,'N'),'','N','N','N','Y') AS ATT_FLAG, \n");
//      tSQL.append( "                       CASE ISNULL(ATTACH_NO, 'N') WHEN '' THEN 'N' WHEN 'N' THEN 'N' ELSE 'Y' END AS ATT_FLAG, \n");
//			tSQL.append( "                       ATTACH_NO AS ATT \n");
//			tSQL.append( "                 FROM ICOMNOTE A  \n");
//			tSQL.append( "                 WHERE STATUS <> 'D' \n");
//			tSQL.append( "                 AND NOTE_TYPE = '"+con_type+"' \n");
//
//	        if(search != null){
//	            if(gubun.equals("S"))  		tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' 																\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' 		\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' 																\n");
//	        }
//
//			tSQL.append( "                 ) TMP \n");
//			tSQL.append( "           ) AAA \n");
//			tSQL.append( "       ) LAST \n");
//			tSQL.append( "WHERE LAST.TTT BETWEEN "+ srowm +" AND "+ erowm + " \n");

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this, ctx, wxp.getQuery());

			rtn = sm.doSelect();
			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
//				e.printStackTrace();
				throw new Exception("et_getQuery_ICOMMACH:"+e.getMessage());
			} finally{
				Release();
			}
		return rtn;
	}


	
	/* ICT 수정 */
	public SepoaOut getQuery_ICOMMACH_ICT(String pg_no, String pg_row, String gubun, String quest, String search, String con_type) throws Exception{
		try
		{

			String rtn = null;
			String rtn_YN = null;

            String pageNum = pg_no 		;//== null || pg_no.equals("") ? "" : pg_no;
            String pageSize = pg_row 	;//== null || pg_row.equals("") ? "" : pg_row;
            String s_gubun = gubun 		;//== null || gubun.equals("") ? "" : gubun;
            String s_quest = quest 		;//== null || quest.equals("") ? "" : quest;
            String s_search = search 	;//== null || search.equals("") ? "" : search;

			rtn_YN = et_getQueryTotCount_ICOMMACH_ICT(s_gubun, s_quest, s_search, con_type);

			SepoaFormater wf = new SepoaFormater(rtn_YN);
			String count = wf.getValue(0,0);

            //Logger.debug.println(info.getSession("ID"), this, "게시물 총 카운드=="+count);

			rtn = et_getQuery_ICOMMACH_ICT(pageNum, pageSize, count, s_gubun, s_quest, s_search, con_type);

			setValue(rtn_YN);
			setValue(rtn);
			setStatus(1);

		} catch(Exception e) {
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println("SYSTEM",this,"Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}	
	
	/* ICT 수정 */
	private String et_getQueryTotCount_ICOMMACH_ICT(String gubun, String quest, String search, String con_type) throws Exception
	{

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("search", search);
			wxp.addVar("gubun", gubun);
			wxp.addVar("con_type", con_type);
			wxp.addVar("quest", quest);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this,ctx, wxp.getQuery());

			rtn = sm.doSelect();

			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
				throw new Exception("et_getQueryTotCount_NOTICE:"+e.getMessage());
			} finally{
				// Release();
			}
		return rtn;
	}


	/* ICT 수정 */
	private String et_getQuery_ICOMMACH_ICT(String pg_no, String pg_row, String Totcount, String gubun, String quest, String search, String con_type) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			int myPage = Integer.parseInt(pg_no);	     // 현재 화면의 페이지 수
			int myRows = Integer.parseInt(pg_row);       // 현재 화면에 보여지는 Row 갯수
			int totalRows = Integer.parseInt(Totcount);  // 해당 쿼리의 전체 쿼리수...

			int srowm = (myPage * myRows) - (myRows -1);
			int erowm = (myPage * myRows);

            int totPage = totalRows/myRows + ( (totalRows%myRows) > 0 ? 1:0);

            /*
            SELECT TOP [불러올 총 게시물수] [출력 필드명] FROM [테이블 명]
           WHERE [글번호] IN (SELECT TOP [페이지출력 갯수] [글번호] FROM
           (SELECT TOP [불러올 총 게시물수] [글번호] FROM [테이블 명]) AS A ORDER BY [글번호])
           ORDER BY [글번호] DESC
			*/

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("srowm", srowm);
			wxp.addVar("erowm", erowm);
			wxp.addVar("gubun", gubun);
			wxp.addVar("quest", quest);
			wxp.addVar("search", search);
			wxp.addVar("con_type", con_type);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this, ctx, wxp.getQuery());

			rtn = sm.doSelect();
			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
//				e.printStackTrace();
				throw new Exception("et_getQuery_ICOMMACH:"+e.getMessage());
			} finally{
				Release();
			}
		return rtn;
	}	
	
	
	public SepoaOut getQuery_MAINFAQ(String pg_no, String pg_row, String gubun, String quest, String search, String con_type) throws Exception{
		try
		{

			String rtn = null;
			String rtn_YN = null;

            String pageNum = pg_no 		;//== null || pg_no.equals("") ? "" : pg_no;
            String pageSize = pg_row 	;//== null || pg_row.equals("") ? "" : pg_row;
            String s_gubun = gubun 		;//== null || gubun.equals("") ? "" : gubun;
            String s_quest = quest 		;//== null || quest.equals("") ? "" : quest;
            String s_search = search 	;//== null || search.equals("") ? "" : search;
			// Isvalue(); ....

			rtn_YN = et_getQueryTotCount_MAINFAQ(s_gubun, s_quest, s_search, con_type);

			SepoaFormater wf = new SepoaFormater(rtn_YN);
			String count = wf.getValue(0,0);

            //Logger.debug.println(info.getSession("ID"), this, "게시물 총 카운드=="+count);

			rtn = et_getQuery_MAINFAQ(pageNum, pageSize, count, s_gubun, s_quest, s_search, con_type);

			setValue(rtn_YN);
			setValue(rtn);
			setStatus(1);

		} catch(Exception e) {
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println("SYSTEM",this,"Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}


	private String et_getQueryTotCount_MAINFAQ(String gubun, String quest, String search, String con_type) throws Exception
	{

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("search", search);
			wxp.addVar("gubun", gubun);
			wxp.addVar("con_type", con_type);
			wxp.addVar("quest", quest);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

//			tSQL.append( "	SELECT COUNT(*) \n");
//			tSQL.append( "	FROM ICOMNOTE \n");
//			tSQL.append( "	WHERE STATUS <> 'D' \n");
//	        if(!search.equals("")){
//	            if(gubun.equals("S"))  tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'		\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	        }

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this,ctx, wxp.getQuery());

			rtn = sm.doSelect();

			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
				throw new Exception("et_getQueryTotCount_NOTICE:"+e.getMessage());
			} finally{
				// Release();
			}
		return rtn;
	}

	private String et_getQuery_MAINFAQ(String pg_no, String pg_row, String Totcount, String gubun, String quest, String search, String con_type) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			int myPage = Integer.parseInt(pg_no);	     // 현재 화면의 페이지 수
			int myRows = Integer.parseInt(pg_row);       // 현재 화면에 보여지는 Row 갯수
			int totalRows = Integer.parseInt(Totcount);  // 해당 쿼리의 전체 쿼리수...

			int srowm = (myPage * myRows) - (myRows -1);
			int erowm = (myPage * myRows);

            int totPage = totalRows/myRows + ( (totalRows%myRows) > 0 ? 1:0);

            /*
            SELECT TOP [불러올 총 게시물수] [출력 필드명] FROM [테이블 명]
           WHERE [글번호] IN (SELECT TOP [페이지출력 갯수] [글번호] FROM
           (SELECT TOP [불러올 총 게시물수] [글번호] FROM [테이블 명]) AS A ORDER BY [글번호])
           ORDER BY [글번호] DESC
			*/

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("srowm", srowm);
			wxp.addVar("erowm", erowm);
			wxp.addVar("gubun", gubun);
			wxp.addVar("quest", quest);
			wxp.addVar("search", search);
			wxp.addVar("con_type", con_type);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("VIEW_USER_TYPE"));

//			tSQL.append( "SELECT LAST.A, LAST.NO, LAST.SUB, LAST.NAME, LAST.ADD_DATE, LAST.VIEW_COUNT, LAST.ATT_FLAG,  LAST.ATT \n");
//			tSQL.append( "FROM \n");
//			//tSQL.append( "     (SELECT ROWNUM AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "     (SELECT ROW_NUMBER() OVER(ORDER BY aaa.no desc) AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "      FROM \n");
//			tSQL.append( "          (SELECT NO, SUB, NAME,  ADD_DATE, VIEW_COUNT,ATT_FLAG, ATT, A \n");
//			tSQL.append( "           FROM (SELECT ROW_NUMBER() OVER(ORDER BY seq) AS A, \n");
//			tSQL.append( "                       SEQ AS NO, \n");
////			tSQL.append( "                       SUBSTRING(SUBJECT,0,45)||DECODE(SUBSTRING(SUBJECT,30,1),'','','.....(생략)') AS SUB, \n");
//			tSQL.append( "                       SUBSTRING(SUBJECT, 0, 45) + CASE SUBSTRING(SUBJECT, 30, 1) WHEN '' THEN '' ELSE '.....(생략)' END AS SUB, \n");
//			tSQL.append( "                       (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = A.ADD_USER_ID) AS NAME,	 \n");
//			tSQL.append( "                       SUBSTRING(ADD_DATE,0,5)+'-'+SUBSTRING(ADD_DATE,5,2)+'-'+SUBSTRING(ADD_DATE,7,2) AS ADD_DATE, \n");
//			tSQL.append( "                       '' AS VIEW_COUNT, \n");
////			tSQL.append( "                       DECODE(ISNULL(ATTACH_NO,'N'),'','N','N','N','Y') AS ATT_FLAG, \n");
//      tSQL.append( "                       CASE ISNULL(ATTACH_NO, 'N') WHEN '' THEN 'N' WHEN 'N' THEN 'N' ELSE 'Y' END AS ATT_FLAG, \n");
//			tSQL.append( "                       ATTACH_NO AS ATT \n");
//			tSQL.append( "                 FROM ICOMNOTE A  \n");
//			tSQL.append( "                 WHERE STATUS <> 'D' \n");
//			tSQL.append( "                 AND NOTE_TYPE = '"+con_type+"' \n");
//
//	        if(search != null){
//	            if(gubun.equals("S"))  		tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' 																\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' 		\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' 																\n");
//	        }
//
//			tSQL.append( "                 ) TMP \n");
//			tSQL.append( "           ) AAA \n");
//			tSQL.append( "       ) LAST \n");
//			tSQL.append( "WHERE LAST.TTT BETWEEN "+ srowm +" AND "+ erowm + " \n");

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this, ctx, wxp.getQuery());

			rtn = sm.doSelect();
			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
//				e.printStackTrace();
				throw new Exception("et_getQuery_MAINFAQ:"+e.getMessage());
			} finally{
				Release();
			}
		return rtn;
	}
	
	
	
	public SepoaOut getQuery_MAINRPT(String pg_no, String pg_row, String gubun, String quest, String search, String con_type) throws Exception{
		try
		{

			String rtn = null;
			String rtn_YN = null;

            String pageNum = pg_no 		;//== null || pg_no.equals("") ? "" : pg_no;
            String pageSize = pg_row 	;//== null || pg_row.equals("") ? "" : pg_row;
            String s_gubun = gubun 		;//== null || gubun.equals("") ? "" : gubun;
            String s_quest = quest 		;//== null || quest.equals("") ? "" : quest;
            String s_search = search 	;//== null || search.equals("") ? "" : search;
			// Isvalue(); ....

			rtn_YN = et_getQueryTotCount_MAINRPT(s_gubun, s_quest, s_search, con_type);

			SepoaFormater wf = new SepoaFormater(rtn_YN);
			String count = wf.getValue(0,0);

            //Logger.debug.println(info.getSession("ID"), this, "게시물 총 카운드=="+count);

			rtn = et_getQuery_MAINRPT(pageNum, pageSize, count, s_gubun, s_quest, s_search, con_type);

			setValue(rtn_YN);
			setValue(rtn);
			setStatus(1);

		} catch(Exception e) {
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println("SYSTEM",this,"Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}


	private String et_getQueryTotCount_MAINRPT(String gubun, String quest, String search, String con_type) throws Exception
	{

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("search", search);
			wxp.addVar("gubun", gubun);
			wxp.addVar("con_type", con_type);
			wxp.addVar("quest", quest);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("MENU_PROFILE_CODE"));
			wxp.addVar("bd_admin", info.getSession("BD_ADMIN"));			

//			tSQL.append( "	SELECT COUNT(*) \n");
//			tSQL.append( "	FROM ICOMNOTE \n");
//			tSQL.append( "	WHERE STATUS <> 'D' \n");
//	        if(!search.equals("")){
//	            if(gubun.equals("S"))  tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'		\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' AND NOTE_TYPE = '"+con_type+"'	\n");
//	        }

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this,ctx, wxp.getQuery());

			rtn = sm.doSelect();

			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
				throw new Exception("et_getQueryTotCount_NOTICE:"+e.getMessage());
			} finally{
				// Release();
			}
		return rtn;
	}

	private String et_getQuery_MAINRPT(String pg_no, String pg_row, String Totcount, String gubun, String quest, String search, String con_type) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			int myPage = Integer.parseInt(pg_no);	     // 현재 화면의 페이지 수
			int myRows = Integer.parseInt(pg_row);       // 현재 화면에 보여지는 Row 갯수
			int totalRows = Integer.parseInt(Totcount);  // 해당 쿼리의 전체 쿼리수...

			int srowm = (myPage * myRows) - (myRows -1);
			int erowm = (myPage * myRows);

            int totPage = totalRows/myRows + ( (totalRows%myRows) > 0 ? 1:0);

            /*
            SELECT TOP [불러올 총 게시물수] [출력 필드명] FROM [테이블 명]
           WHERE [글번호] IN (SELECT TOP [페이지출력 갯수] [글번호] FROM
           (SELECT TOP [불러올 총 게시물수] [글번호] FROM [테이블 명]) AS A ORDER BY [글번호])
           ORDER BY [글번호] DESC
			*/

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("srowm", srowm);
			wxp.addVar("erowm", erowm);
			wxp.addVar("gubun", gubun);
			wxp.addVar("quest", quest);
			wxp.addVar("search", search);
			wxp.addVar("con_type", con_type);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("view_user_type", info.getSession("MENU_PROFILE_CODE"));
			wxp.addVar("bd_admin", info.getSession("BD_ADMIN"));
			

//			tSQL.append( "SELECT LAST.A, LAST.NO, LAST.SUB, LAST.NAME, LAST.ADD_DATE, LAST.VIEW_COUNT, LAST.ATT_FLAG,  LAST.ATT \n");
//			tSQL.append( "FROM \n");
//			//tSQL.append( "     (SELECT ROWNUM AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "     (SELECT ROW_NUMBER() OVER(ORDER BY aaa.no desc) AS TTT, AAA.NO, AAA.SUB, AAA.NAME, AAA.ADD_DATE, AAA.VIEW_COUNT, AAA.ATT_FLAG,  AAA.ATT, AAA.A \n");
//			tSQL.append( "      FROM \n");
//			tSQL.append( "          (SELECT NO, SUB, NAME,  ADD_DATE, VIEW_COUNT,ATT_FLAG, ATT, A \n");
//			tSQL.append( "           FROM (SELECT ROW_NUMBER() OVER(ORDER BY seq) AS A, \n");
//			tSQL.append( "                       SEQ AS NO, \n");
////			tSQL.append( "                       SUBSTRING(SUBJECT,0,45)||DECODE(SUBSTRING(SUBJECT,30,1),'','','.....(생략)') AS SUB, \n");
//			tSQL.append( "                       SUBSTRING(SUBJECT, 0, 45) + CASE SUBSTRING(SUBJECT, 30, 1) WHEN '' THEN '' ELSE '.....(생략)' END AS SUB, \n");
//			tSQL.append( "                       (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = A.ADD_USER_ID) AS NAME,	 \n");
//			tSQL.append( "                       SUBSTRING(ADD_DATE,0,5)+'-'+SUBSTRING(ADD_DATE,5,2)+'-'+SUBSTRING(ADD_DATE,7,2) AS ADD_DATE, \n");
//			tSQL.append( "                       '' AS VIEW_COUNT, \n");
////			tSQL.append( "                       DECODE(ISNULL(ATTACH_NO,'N'),'','N','N','N','Y') AS ATT_FLAG, \n");
//      tSQL.append( "                       CASE ISNULL(ATTACH_NO, 'N') WHEN '' THEN 'N' WHEN 'N' THEN 'N' ELSE 'Y' END AS ATT_FLAG, \n");
//			tSQL.append( "                       ATTACH_NO AS ATT \n");
//			tSQL.append( "                 FROM ICOMNOTE A  \n");
//			tSQL.append( "                 WHERE STATUS <> 'D' \n");
//			tSQL.append( "                 AND NOTE_TYPE = '"+con_type+"' \n");
//
//	        if(search != null){
//	            if(gubun.equals("S"))  		tSQL.append( "	AND  SUBJECT LIKE '%"+quest+"%' 																\n");
//	            else if(gubun.equals("U"))  tSQL.append( "	AND  dbo.GETUSERNAME('100',ADD_USER_ID,'LOC') LIKE '%"+quest+"%' 		\n");
//	            else if(gubun.equals("D"))  tSQL.append( "	AND  ADD_DATE LIKE '%"+quest+"%' 																\n");
//	        }
//
//			tSQL.append( "                 ) TMP \n");
//			tSQL.append( "           ) AAA \n");
//			tSQL.append( "       ) LAST \n");
//			tSQL.append( "WHERE LAST.TTT BETWEEN "+ srowm +" AND "+ erowm + " \n");

			SepoaSQLManager sm = new SepoaSQLManager("CGV04",this, ctx, wxp.getQuery());

			rtn = sm.doSelect();
			if(rtn == null) throw new Exception("SQL Manager is Null");
			}catch(Exception e) {
//				e.printStackTrace();
				throw new Exception("et_getQuery_MAINFAQ:"+e.getMessage());
			} finally{
				Release();
			}
		return rtn;
	}


    
}