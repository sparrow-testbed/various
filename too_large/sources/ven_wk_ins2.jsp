<%--
 Title:        vendor create
 Description:  vendor create
 Copyright:    Copyright (c)
 Company:      ICOMPIA <p>
 @author       eun pyo ,Lee<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
--%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.raonsecure.touchen.KeyboardSecurity" %>

<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@page import="sepoa.fw.util.JSPUtil"%>
<% String WISEHUB_PROCESS_ID="p0010"; %>
<% String WISEHUB_LANG_TYPE="KR"; %>
<%-- <%@ include file="/include/wisehub_common.jsp" %> --%>
<%-- <%@ include file="/include/wisehub_nonsession.jsp" %> --%>
<%-- <%@ page import="wise.util.EncDec"%> --%>

<%
//	SepoaInfo info = new SepoaInfo("000","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL");
	String user_id          		= info.getSession("ID");
	String user_name_loc    		= info.getSession("NAME_LOC");
	String user_name_eng    		= info.getSession("NAME_ENG");
	String user_dept        		= info.getSession("DEPARTMENT");
	String company_code     		= info.getSession("COMPANY_CODE");
	String house_code       		= info.getSession("HOUSE_CODE");
	
	String FLAG           			= JSPUtil.nullToEmpty(request.getParameter("FLAG"));

	String mode           			= JSPUtil.nullToEmpty(request.getParameter("mode"));
	String HOUSE_CODE             	= house_code;
//	String VENDOR_CODE 			  	= JSPUtil.nullToEmpty(request.getParameter("VENDOR_CODE")			  );
    String VENDOR_CODE 			  	= company_code;
    if("".equals(VENDOR_CODE)){
    	VENDOR_CODE  = JSPUtil.nullToEmpty(request.getParameter("VENDOR_CODE"));
	}
    
	Logger.debug.println(info.getSession("ID"), this, "여기 : " + VENDOR_CODE);
	//if (true) return;
//	String VENDOR_ID 			  	= JSPUtil.nullToEmpty(request.getParameter("USER_ID"));
	String VENDOR_ID 			  	= JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "USER_ID"));
//	String VENDOR_PASSWORD		  	= JSPUtil.nullToEmpty(request.getParameter("PASSWORD"));
//	String VENDOR_PASSWORD		  	= JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "PASSWORD"));
	String VENDOR_PASSWORD  = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "PASSWORD"));		
	if(!"".equals(VENDOR_PASSWORD)){
		VENDOR_PASSWORD  = CryptoUtil.getSHA256(VENDOR_PASSWORD);
	}
	String BP_FLAG             	  	= JSPUtil.nullToEmpty(request.getParameter("BP_FLAG"));
	String VENDOR_NAME_LOC        	= JSPUtil.nullToEmpty(request.getParameter("VENDOR_NAME_LOC")		  );
	String SOLE_PROPRIETOR_FLAG   	= JSPUtil.nullToEmpty(request.getParameter("SOLE_PROPRIETOR_FLAG")  );
	String SHIPPER_TYPE           	= JSPUtil.nullToEmpty(request.getParameter("SHIPPER_TYPE")          );
	String VENDOR_TYPE            	= JSPUtil.nullToEmpty(request.getParameter("VENDOR_TYPE")           );
	String IRS_NO1                	= JSPUtil.nullToEmpty(request.getParameter("IRS_NO1")               );
	String IRS_NO2                	= JSPUtil.nullToEmpty(request.getParameter("IRS_NO2")               );
	String IRS_NO3                	= JSPUtil.nullToEmpty(request.getParameter("IRS_NO3")               );
	String IRS_NO_OLD1            	= JSPUtil.nullToEmpty(request.getParameter("IRS_NO_OLD1")           );
	String IRS_NO_OLD2            	= JSPUtil.nullToEmpty(request.getParameter("IRS_NO_OLD2")           );
	String IRS_NO_OLD3            	= JSPUtil.nullToEmpty(request.getParameter("IRS_NO_OLD3")           );
	String BUSINESS_TYPE          	= JSPUtil.nullToEmpty(request.getParameter("BUSINESS_TYPE")         );
	String INDUSTRY_TYPE          	= JSPUtil.nullToEmpty(request.getParameter("INDUSTRY_TYPE")         );
	String START_DATE             	= JSPUtil.nullToEmpty(SepoaString.getDateUnSlashFormat( request.getParameter("START_DATE") )           );
	String CAPITAL                	= JSPUtil.nullToEmpty(request.getParameter("CAPITAL")               );
	String CEO_NAME_LOC           	= JSPUtil.nullToEmpty(request.getParameter("CEO_NAME_LOC")          );
	String RESIDENT_NO1           	= "";
	String RESIDENT_NO2			  	= "";
	String irs_no			  	  	= "";
	if(mode.equals("irs_no")){
       	irs_no			= JSPUtil.nullToEmpty(request.getParameter("irs_no"));
		IRS_NO1			= irs_no.substring(0,3);
		IRS_NO2			= irs_no.substring(3,5);
		IRS_NO3			= irs_no.substring(5);
		RESIDENT_NO1	= "";
		RESIDENT_NO2	= "";
	}else{
		String resident_no	= "";
			   RESIDENT_NO1	= "";
			   RESIDENT_NO2 = "";
	}
	String PHONE_NO1              = JSPUtil.nullToEmpty(request.getParameter("PHONE_NO1"));
	String EMAIL                  = JSPUtil.nullToEmpty(request.getParameter("EMAIL"));
	String ENTRY_DEPT_NAME        = JSPUtil.nullToEmpty(request.getParameter("ENTRY_DEPT_NAME"));
	String ENTRY_USER_NAME        = JSPUtil.nullToEmpty(request.getParameter("ENTRY_USER_NAME"));
	String COUNTRY                = JSPUtil.nullToEmpty(request.getParameter("COUNTRY"));
	//String CITY_CODE            = JSPUtil.nullToEmpty(request.getParameter("CITY_CODE"));
	String ZIP_CODE1              = JSPUtil.nullToEmpty(request.getParameter("ZIP_CODE1"));
	String ZIP_CODE2              = JSPUtil.nullToEmpty(request.getParameter("ZIP_CODE2"));
	String ADDRESS_LOC            = JSPUtil.nullToEmpty(request.getParameter("ADDRESS_LOC"));
	String PHONE_NO2              = JSPUtil.nullToEmpty(request.getParameter("PHONE_NO2"));
	String FAX_NO                 = JSPUtil.nullToEmpty(request.getParameter("FAX_NO"));
	String BIZ_CLASS1             = JSPUtil.nullToEmpty(request.getParameter("BIZ_CLASS1"));
	String BIZ_CLASS2             = JSPUtil.nullToEmpty(request.getParameter("BIZ_CLASS2"));
	String BIZ_CLASS3             = JSPUtil.nullToEmpty(request.getParameter("BIZ_CLASS3"));
	String BIZ_CLASS4             = JSPUtil.nullToEmpty(request.getParameter("BIZ_CLASS4"));
	String BIZ_CLASS5             = JSPUtil.nullToEmpty(request.getParameter("BIZ_CLASS5"));
	String BANK_CODE              = JSPUtil.nullToEmpty(request.getParameter("HBKID"));
	String DEPOSITOR_NAME         = JSPUtil.nullToEmpty(request.getParameter("DEPOSITOR_NAME"));
	String BANK_ACCT              = JSPUtil.nullToEmpty(request.getParameter("BANK_ACCT"));
// 	String BANK_ACCT              = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "BANK_ACCT"));
	String CREDIT_RATING          = JSPUtil.nullToEmpty(request.getParameter("CREDIT_RATING"));
	String CREDIT_DATE            = JSPUtil.nullToEmpty(request.getParameter("CREDIT_DATE"));
	String IRS_NO_MAIN1           = JSPUtil.nullToEmpty(request.getParameter("IRS_NO_MAIN1"));
	String IRS_NO_MAIN2           = JSPUtil.nullToEmpty(request.getParameter("IRS_NO_MAIN2"));
	String IRS_NO_MAIN3           = JSPUtil.nullToEmpty(request.getParameter("IRS_NO_MAIN3"));
	String COMPANY_REG_NO1        = JSPUtil.nullToEmpty(request.getParameter("COMPANY_REG_NO1"));
	String COMPANY_REG_NO2	      = JSPUtil.nullToEmpty(request.getParameter("COMPANY_REG_NO2"));
	String ATTACH_NO	      	  = JSPUtil.nullToEmpty(request.getParameter("attach_no"));

	String s_type1 			= JSPUtil.nullToEmpty(request.getParameter("s_type1")       	  );
	String s_type2 			= JSPUtil.nullToEmpty(request.getParameter("s_type2")       	  );
	String s_type3 			= JSPUtil.nullToEmpty(request.getParameter("s_type3")       	  );

	//1127추가
	String SEARCH_KEY	    = JSPUtil.nullToEmpty(request.getParameter("SEARCH_KEY")       	  );
	String CITY_CODE	    = JSPUtil.nullToEmpty(request.getParameter("city_code")       	  );
	String HOUSE_NUM1	    = JSPUtil.nullToEmpty(request.getParameter("HOUSE_NUM1")       	  );
	String AKONT 			= JSPUtil.nullToEmpty(request.getParameter("AKONT"));
	String ZTERM 			= JSPUtil.nullToEmpty(request.getParameter("ZTERM"));
	String ZWELS 			= JSPUtil.nullToEmpty(request.getParameter("ZWELS"));
	String HBKID 			= JSPUtil.nullToEmpty(request.getParameter("HBKID"));

	String BANK_KEY 		= JSPUtil.nullToEmpty(request.getParameter("BANK_KEY"));
	String EMP_COUNT1 		= JSPUtil.nullToEmpty(request.getParameter("EMP_COUNT1"));
	String EMP_COUNT2 		= JSPUtil.nullToEmpty(request.getParameter("EMP_COUNT2"));
	
	String HOME_URL 	    = JSPUtil.nullToEmpty(request.getParameter("HOME_URL"));
	String ENGINEER_COUNT 	= JSPUtil.nullToEmpty(request.getParameter("ENGINEER_COUNT"));
	String TAX_DIV 		    = JSPUtil.nullToEmpty(request.getParameter("TAX_DIV"));
	String ENTRY_TEL 		= JSPUtil.nullToEmpty(request.getParameter("ENTRY_TEL"));
	String ENTRY_EMAIL 		= JSPUtil.nullToEmpty(request.getParameter("ENTRY_EMAIL"));
	
	String VENDOR_NAME_LOC_O = JSPUtil.nullToEmpty(request.getParameter("VENDOR_NAME_LOC_O"));
	String BUSINESS_TYPE_O = JSPUtil.nullToEmpty(request.getParameter("BUSINESS_TYPE_O"));
	String INDUSTRY_TYPE_O = JSPUtil.nullToEmpty(request.getParameter("INDUSTRY_TYPE_O"));
	String CEO_NAME_LOC_O = JSPUtil.nullToEmpty(request.getParameter("CEO_NAME_LOC_O"));
	String PHONE_NO1_O = JSPUtil.nullToEmpty(request.getParameter("PHONE_NO1_O"));
	String ENTRY_DEPT_NAME_O = JSPUtil.nullToEmpty(request.getParameter("ENTRY_DEPT_NAME_O"));
	String ENTRY_USER_NAME_O = JSPUtil.nullToEmpty(request.getParameter("ENTRY_USER_NAME_O"));
	String ENTRY_TEL_O = JSPUtil.nullToEmpty(request.getParameter("ENTRY_TEL_O"));
	String ENTRY_EMAIL_O = JSPUtil.nullToEmpty(request.getParameter("ENTRY_EMAIL_O"));
	String PHONE_NO2_O = JSPUtil.nullToEmpty(request.getParameter("PHONE_NO2_O"));
	String BANK_KEY_O = JSPUtil.nullToEmpty(request.getParameter("BANK_KEY_O"));
	String DEPOSITOR_NAME_O = JSPUtil.nullToEmpty(request.getParameter("DEPOSITOR_NAME_O"));
	String BANK_ACCT_O = JSPUtil.nullToEmpty(request.getParameter("BANK_ACCT_O"));
	String COMPANY_REG_NO1_O = JSPUtil.nullToEmpty(request.getParameter("COMPANY_REG_NO1_O"));
	String COMPANY_REG_NO2_O = JSPUtil.nullToEmpty(request.getParameter("COMPANY_REG_NO2_O"));
	
	BP_FLAG	= BP_FLAG == null || BP_FLAG.equals("")? "0" : "1";
	BIZ_CLASS1	= BIZ_CLASS1 == null || BIZ_CLASS1.equals("")? "0" : "1";
	BIZ_CLASS2  = BIZ_CLASS2 == null || BIZ_CLASS2.equals("")? "0" : "1";
	BIZ_CLASS3  = BIZ_CLASS3 == null || BIZ_CLASS3.equals("")? "0" : "1";
	BIZ_CLASS4  = BIZ_CLASS4 == null || BIZ_CLASS4.equals("")? "0" : "1";
	BIZ_CLASS5  = BIZ_CLASS5 == null || BIZ_CLASS5.equals("")? "0" : "1";

	/*String doc_type = SOLE_PROPRIETOR_FLAG.equals("3") ? "FR" : "VM";
	if("".equals(VENDOR_CODE)){
		WiseOut wo = appcommon.getDocNumber(info,doc_type);
		VENDOR_CODE = wo.result[0];
	}*/
	String doc_type = SOLE_PROPRIETOR_FLAG.equals("3") ? "FR" : "VM";

	/*프리랜서 일 경우만 채번*/
	if("".equals(VENDOR_CODE)) {
		if("irs_no".equals(mode)) {
			//VENDOR_CODE = irs_no;
			VENDOR_CODE = VENDOR_ID;
		} else{
			Object[] params= {};
			SepoaOut wo = ServiceConnector.doService(info, "p0010", "TRANSACTION","getMaxVedorCode", params);
			SepoaFormater wf = new SepoaFormater(wo.result[0]);
			VENDOR_CODE = wf.getValue("VENDOR_CODE", 0);
		}
	}
    String JOB_STATUS = mode.equals("irs_no")?"D":"D";

	PHONE_NO1 = PHONE_NO1.replaceAll("-", "");
	PHONE_NO1 = PHONE_NO1.replaceAll("-", "");
	FAX_NO = FAX_NO.replaceAll("-", "");

// 	EncDec enc = new EncDec();
// 	String RES = enc.encrypt(RESIDENT_NO1+ RESIDENT_NO2); // 암호화
	String RES = ""; // 암호화
	
// 	CEncrypt encrypt = new CEncrypt("MD5", VENDOR_PASSWORD);
// 	String VENDOR_PASSWORD_ENC = encrypt.getEncryptData();

	String VENDOR_PASSWORD_ENC = VENDOR_PASSWORD;

	String[] temp_vngl = {
		  HOUSE_CODE
		, VENDOR_CODE
		, "C"
		, user_id
		, user_dept
		, JOB_STATUS
		, BP_FLAG
		, VENDOR_NAME_LOC
		, SOLE_PROPRIETOR_FLAG
		, SHIPPER_TYPE
		, VENDOR_TYPE
		, IRS_NO1+IRS_NO2+IRS_NO3
		, IRS_NO_OLD1+IRS_NO_OLD2+IRS_NO_OLD3
		, BUSINESS_TYPE
		, INDUSTRY_TYPE
		, START_DATE
		, CAPITAL
		, RES
		, ENTRY_DEPT_NAME
		, ENTRY_USER_NAME
		, COUNTRY
		, CITY_CODE
		, BIZ_CLASS1
		, BIZ_CLASS2
		, BIZ_CLASS3
		, BIZ_CLASS4
		, BIZ_CLASS5
		, BANK_KEY
		, DEPOSITOR_NAME
		, BANK_ACCT
		, CREDIT_RATING
		, CREDIT_DATE
		, IRS_NO_MAIN1+IRS_NO_MAIN2+IRS_NO_MAIN3
		, COMPANY_REG_NO1+COMPANY_REG_NO2
		, ATTACH_NO
		, SEARCH_KEY
		, AKONT
		, ZTERM
		, ZWELS
		, BANK_KEY
		, EMP_COUNT1
		, EMP_COUNT2
		, VENDOR_ID
		, VENDOR_PASSWORD_ENC
		, HOME_URL
		, ENGINEER_COUNT
		, TAX_DIV
		, ENTRY_TEL
	    , ENTRY_EMAIL
	};
	String[] temp_vngl_upd = {
		  VENDOR_NAME_LOC
		, BP_FLAG
		, SOLE_PROPRIETOR_FLAG
		, SHIPPER_TYPE
		, VENDOR_TYPE
		, IRS_NO1+IRS_NO2+IRS_NO3
		, IRS_NO_OLD1+IRS_NO_OLD2+IRS_NO_OLD3
		, BUSINESS_TYPE
		, INDUSTRY_TYPE
		, START_DATE
		, CAPITAL
		, RES
		, ENTRY_DEPT_NAME
		, ENTRY_USER_NAME
		, COUNTRY
		, CITY_CODE
		, BIZ_CLASS1
		, BIZ_CLASS2
		, BIZ_CLASS3
		, BIZ_CLASS4
		, BIZ_CLASS5
		, BANK_KEY
		, DEPOSITOR_NAME
		, BANK_ACCT
		, CREDIT_RATING
		, CREDIT_DATE
		, IRS_NO_MAIN1+IRS_NO_MAIN2+IRS_NO_MAIN3
		, COMPANY_REG_NO1+COMPANY_REG_NO2
		, ATTACH_NO
		, SEARCH_KEY
		, AKONT
		, ZTERM
		, ZWELS
		, BANK_KEY
		, EMP_COUNT1
		, EMP_COUNT2
		, HOME_URL
		, ENGINEER_COUNT
		, TAX_DIV
		, ENTRY_TEL
	    , ENTRY_EMAIL
		, HOUSE_CODE
		, VENDOR_CODE
	};
	String I_CODE_NO    = VENDOR_CODE;
	String I_CODE_TYPE  = "2"; //1:COMPANY, 2: VENDOR, 3: USER
	String[] temp_addr = {
		  HOUSE_CODE
		, I_CODE_NO
		, I_CODE_TYPE
		, ZIP_CODE1
		, PHONE_NO1
		, PHONE_NO2
		, FAX_NO
		, ADDRESS_LOC
		, CEO_NAME_LOC
		, EMAIL
		, HOUSE_NUM1
	};
	String[] temp_addr_upd = {
		  ZIP_CODE1
		, PHONE_NO1
		, PHONE_NO2
		, FAX_NO
		, ADDRESS_LOC
		, CEO_NAME_LOC
		, EMAIL
		, HOUSE_NUM1
		, HOUSE_CODE
		, I_CODE_NO
		, I_CODE_TYPE
	};
	
	
	String[] temp_vngl_old = {
			VENDOR_NAME_LOC_O
			,BUSINESS_TYPE_O
			,INDUSTRY_TYPE_O
			,CEO_NAME_LOC_O
			,PHONE_NO1_O
			,ENTRY_DEPT_NAME_O 
			,ENTRY_USER_NAME_O 
			,ENTRY_TEL_O
			,ENTRY_EMAIL_O
			,PHONE_NO2_O
			,BANK_KEY_O
			,DEPOSITOR_NAME_O
			,BANK_ACCT_O
			,COMPANY_REG_NO1_O + COMPANY_REG_NO2_O 
	};
	
	String[][] args_vngl = new String[1][];
	String[][] args_addr = new String[1][];
	String[][] args_vngl_old = new String[1][];
	Object[] obj = null;
	String strMethodName = "setInsert_icomvngl";
	if(FLAG.equals("C"))
	{
		args_vngl[0] = temp_vngl;
		args_addr[0] = temp_addr;
		obj = new Object[3];
		obj[0] = args_vngl;
		obj[1] = args_addr;
		obj[2] = VENDOR_CODE;
	}
	else if(FLAG.equals("U")){
		strMethodName = "setUpdate_vngl";
		args_vngl[0] = temp_vngl_upd;
		args_addr[0] = temp_addr_upd;
		args_vngl_old[0] = temp_vngl_old;
		
		obj = new Object[4];
		obj[0] = args_vngl;
		obj[1] = args_addr;
		obj[2] = VENDOR_CODE;
		obj[3] = args_vngl_old;
		
	}
	//Object[] obj = {args_vngl, args_addr, VENDOR_ID};

	if(info == null){
		Logger.err.println("nullllllllll");
	}
	
	SepoaOut value = ServiceConnector.doService(info, "p0010", "TRANSACTION",strMethodName, obj);

	String message = "";

	String isSuccess          = JSPUtil.nullToRef(request.getParameter("isSuccess"),"true");
	String s_template_refitem = JSPUtil.nullToEmpty(request.getParameter("s_template_refitem"));
	String c_template_refitem = JSPUtil.nullToEmpty(request.getParameter("c_template_refitem"));
	int IU_flag               = Integer.parseInt(JSPUtil.nullToRef(request.getParameter("iRowCount2"),"0"));
	String aa                 = JSPUtil.nullToEmpty(request.getParameter("lCode"));
    String sg_refitem         = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));	//소싱 그룹 구분키
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript">

function Init()
{
	parent.Saved("<%=value.result[0]%>", "<%=value.status%>");
}

</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
