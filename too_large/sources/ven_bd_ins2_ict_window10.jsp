<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<!-- PROCESS ID 선언 -->
<%
	String WISEHUB_PROCESS_ID = "p0010";
%>
<!-- 사용 언어 설정 -->
<%
	String WISEHUB_LANG_TYPE = "KR";
%>

<%@ page import="java.util.*"%>

<%
	//SepoaInfo info = SepoaSession.getAllValue(request);
	String user_type = "";
	String CompanyCode = JSPUtil.nullToEmpty(request.getParameter("CompanyCode"));
	String G_IMG_ICON = "/images/ico_zoom.gif";
	
	//여기선 관리자인지 일반 사용자인지 구분하기 위해 사용
	String ctrl_code = "";
			
// 	Config conf = new Configuration();
	String all_admin_profile_code = "";
	String admin_profile_code = "";
	String session_profile_code = info.getSession("MENU_TYPE");
	
	String readOnly = "";
	try {

		all_admin_profile_code = CommonUtil.getConfig("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
		admin_profile_code = CommonUtil.getConfig("wise.admin.profile_code."+info.getSession("HOUSE_CODE"));

	} catch (Exception e1) {
		
		all_admin_profile_code = "";
		admin_profile_code = "";
	}

	if(null == session_profile_code || "".equals(session_profile_code)){
		session_profile_code = "P01";
	}else if (session_profile_code.equals(all_admin_profile_code) || session_profile_code.equals(admin_profile_code)) {
		ctrl_code = "P01";
	}else if("MUP100300001".equals(session_profile_code)){
		ctrl_code = "P01";
	}else{
		ctrl_code = "P99";	
	}
	
	String menu_type = "";
	
	if (info.getSession("ID").equals("YPP")) {
		user_type = "SS";
	} else {
		user_type = "S";
	}
	String buyer_house_code = JSPUtil.nullToEmpty(request.getParameter("buyer_house_code"));
	String house_code = info.getSession("HOUSE_CODE");
	String popup = JSPUtil.nullToEmpty(request.getParameter("popup"));
	String mode = JSPUtil.nullToEmpty(request.getParameter("mode"));
	String status = JSPUtil.nullToEmpty(request.getParameter("status"));
	String flag = JSPUtil.nullToEmpty(request.getParameter("flag"));

	String readOnly_flag = "";
	if (popup.equals("Y")) {
		readOnly_flag = "readOnly";
		//flag = "update";
	}

	String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String company_code = JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String irs_no = JSPUtil.nullToEmpty(request.getParameter("irs_no"));
	String resident_no = JSPUtil.nullToEmpty(request.getParameter("resident_no"));
	String VENDOR_CODE = "";
	String USER_ID = "";
	String SIGN_STATUS = "";
	String BP_FLAG = "";
	String VENDOR_NAME_LOC = "";
	String SOLE_PROPRIETOR_FLAG = "";
	String SHIPPER_TYPE = "";
	String VENDOR_TYPE = "";
	String TAX_KEY = "";
	String IRS_NO = "";
	String IRS_NO_OLD = "";
	String BUSINESS_TYPE = "";
	String INDUSTRY_TYPE = "";
	String START_DATE = "";
	String CAPITAL = "";
	String CEO_NAME_LOC = "";
	String RESIDENT_NO = "";
	String PHONE_NO1 = "";
	
	String ENTRY_DEPT_NAME = "";
	String ENTRY_USER_NAME = "";
	String COUNTRY = "";
	String CITY_CODE = "";
	String TEXT_CITY_CODE = "";
	String ZIP_CODE = "";
	String ADDRESS_LOC = "";
	String PHONE_NO2 = "";
	String FAX_NO = "";
	String BIZ_CLASS1 = "";
	String BIZ_CLASS2 = "";
	String BIZ_CLASS3 = "";
	String BIZ_CLASS4 = "";
	String BIZ_CLASS5 = "";
	String BANK_CODE = "";
	String DEPOSITOR_NAME = "";
	String BANK_ACCT = "";
	String CREDIT_RATING = "";
	String CREDIT_DATE = "";
	String IRS_NO_MAIN = "";
	String COMPANY_REG_NO = "";
	String JOB_STATUS = "";
	String ATTACH_NO = "";
	String ATTACH_COUNT = "";
	String SEARCH_KEY = "";
	String HOUSE_NUM1 = "";
	String AKONT = "";
	String ZTERM = "";
	String ZWELS = "";
	String HBKID = "";
	String lCode = "";
	String lText = "";
	String mCode = "";
	String mText = "";
	String sCode = "";
	String sText = "";
	String BANK_KEY = "";
	String EMP_COUNT1 = "";
	String EMP_COUNT2 = "";
	
	String HOME_URL    = "";
	String TAX_DIV = "";
	String ENGINEER_COUNT = "";
	String ENTRY_TEL = "";
	String ENTRY_EMAIL = "";
	String REJECT_REASON = "";	// 반려사유
	
	int iRowCount = 0;
	int iRowCount2 = 0;
	SepoaOut value = null;
	SepoaOut value2 = null;

	if (flag.equals("update") || !"".equals(vendor_code)) {
		String[] data = { house_code, vendor_code };
		Object[] obj = { (Object[]) data, "select" };
		Object[] obj2 = { vendor_code };
		value  = ServiceConnector.doService(info, "I_p0010", "CONNECTION", "getDis_icomvngl", obj);
		// ICT는 소싱그룹연결 사용하지 않음
		//value2 = ServiceConnector.doService(info, "I_s6006", "CONNECTION", "getScrItem", obj2);

		if (value.status == 1) {
			SepoaFormater wf = new SepoaFormater(
					value.result[0]);
			iRowCount = wf.getRowCount();
			if (iRowCount > 0) {
				VENDOR_CODE				= wf.getValue("VENDOR_CODE", 0);
				USER_ID                 = wf.getValue("USER_ID", 0);
				SIGN_STATUS				= wf.getValue("JOB_STATUS", 0);
				BP_FLAG					= wf.getValue("BP_FLAG", 0);
				VENDOR_NAME_LOC			= wf.getValue("VENDOR_NAME_LOC", 0);
				SOLE_PROPRIETOR_FLAG	= wf.getValue("SOLE_PROPRIETOR_FLAG", 0);
				SHIPPER_TYPE			= wf.getValue("SHIPPER_TYPE", 0);
				VENDOR_TYPE				= wf.getValue("VENDOR_TYPE", 0);
				IRS_NO					= wf.getValue("IRS_NO", 0);
				IRS_NO_OLD				= wf.getValue("IRS_NO_OLD", 0);
				BUSINESS_TYPE			= wf.getValue("BUSINESS_TYPE", 0);
				INDUSTRY_TYPE			= wf.getValue("INDUSTRY_TYPE", 0);
				START_DATE				= wf.getValue("START_DATE", 0);
				CAPITAL					= wf.getValue("CAPITAL", 0);
				CEO_NAME_LOC			= wf.getValue("CEO_NAME_LOC", 0);
				RESIDENT_NO				= wf.getValue("RESIDENT_NO", 0);
				PHONE_NO1				= wf.getValue("PHONE_NO1", 0);

				ENTRY_DEPT_NAME			= wf.getValue("ENTRY_DEPT_NAME", 0);
				ENTRY_USER_NAME			= wf.getValue("ENTRY_USER_NAME", 0);
				COUNTRY					= wf.getValue("COUNTRY", 0);
				CITY_CODE				= wf.getValue("CITY_CODE", 0);
				TEXT_CITY_CODE			= wf.getValue("TEXT_CITY_CODE", 0);
				ZIP_CODE				= wf.getValue("ZIP_CODE", 0);
				ADDRESS_LOC				= wf.getValue("ADDRESS_LOC", 0);
				PHONE_NO2				= wf.getValue("PHONE_NO2", 0);
				FAX_NO					= wf.getValue("FAX_NO", 0);
				BIZ_CLASS1				= wf.getValue("BIZ_CLASS1", 0);
				BIZ_CLASS2				= wf.getValue("BIZ_CLASS2", 0);
				BIZ_CLASS3				= wf.getValue("BIZ_CLASS3", 0);
				BIZ_CLASS4				= wf.getValue("BIZ_CLASS4", 0);
				BIZ_CLASS5				= wf.getValue("BIZ_CLASS5", 0);
				BANK_CODE				= wf.getValue("BANK_CODE", 0);
				DEPOSITOR_NAME			= wf.getValue("DEPOSITOR_NAME", 0);
				BANK_ACCT				= wf.getValue("BANK_ACCT", 0);
				CREDIT_RATING			= wf.getValue("CREDIT_RATING", 0);
				CREDIT_DATE				= wf.getValue("CREDIT_DATE", 0);
				IRS_NO_MAIN				= wf.getValue("IRS_NO_MAIN", 0);
				COMPANY_REG_NO			= wf.getValue("COMPANY_REG_NO", 0);
				ATTACH_NO				= wf.getValue("ATTACH_NO", 0);
				ATTACH_COUNT			= wf.getValue("ATTACH_COUNT", 0);
				SEARCH_KEY				= wf.getValue("SEARCH_KEY", 0);
				HOUSE_NUM1				= wf.getValue("HOUSE_NUM1", 0);
				AKONT					= wf.getValue("AKONT", 0);
				ZTERM					= wf.getValue("ZTERM", 0);
				ZWELS					= wf.getValue("ZWELS", 0);
				EMP_COUNT1				= wf.getValue("EMP_COUNT1", 0);
				EMP_COUNT2				= wf.getValue("EMP_COUNT2", 0);

				HOME_URL				= wf.getValue("HOME_URL", 0);
				TAX_DIV					= wf.getValue("TAX_DIV", 0);
				ENGINEER_COUNT			= wf.getValue("ENGINEER_COUNT", 0);
				ENTRY_TEL				= wf.getValue("ENTRY_TEL", 0);
				ENTRY_EMAIL				= wf.getValue("ENTRY_EMAIL", 0);
				REJECT_REASON			= wf.getValue("REJECT_REASON", 0);
				

				if (HBKID == null)
					HBKID = wf.getValue("BANK_CODE", 0);
				else
					HBKID = "".equals(wf.getValue("BANK_CODE", 0)) ? ""
							: String.valueOf(Integer.parseInt(wf
									.getValue("BANK_CODE", 0)));
				BANK_KEY = wf.getValue("BANK_KEY", 0);
			}
		}

		//if (value2.status == 1) {
			//SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
			//iRowCount2 = wf2.getRowCount();
			//if (iRowCount2 > 0) {
			//	lCode = wf2.getValue("L_CODE", 0);
			//	lText = wf2.getValue("L_TEXT", 0);
			//	mCode = wf2.getValue("M_CODE", 0);
			//	mText = wf2.getValue("M_TEXT", 0);
			//	sCode = wf2.getValue("S_CODE", 0);
			//	sText = wf2.getValue("S_TEXT", 0);
			//}
		//}
	} else if (status.equals("T")) {
		/*주민번호 일 경우엔 암호화 한다.*/
// 		EncDec enc = new EncDec();
// 		String resident_no_p = enc.encrypt(resident_no);
		String resident_no_p = resident_no;

		String[] data = { house_code,
				"".equals(irs_no) ? resident_no_p : irs_no };
		Object[] obj = { (Object[]) data,
				"".equals(irs_no) ? "resident_no" : "irs_no" };

		value  = ServiceConnector.doService(info, "I_p0010", "CONNECTION", "getDis_icomvngl", obj);
		Object[] obj2 = { vendor_code };
		// ICT는 소싱그룹연결 사용하지 않음
		//value2 = ServiceConnector.doService(info, "I_s6006", "CONNECTION", "getScrItem", obj2);

		if (value.status == 1) {
			SepoaFormater wf = new SepoaFormater(
					value.result[0]);
			iRowCount = wf.getRowCount();
			if (iRowCount > 0) {
				VENDOR_CODE				= wf.getValue("VENDOR_CODE", 0);
				USER_ID                 = wf.getValue("USER_ID", 0);
				SIGN_STATUS				= wf.getValue("JOB_STATUS", 0);
				BP_FLAG					= wf.getValue("BP_FLAG", 0);
				VENDOR_NAME_LOC			= wf.getValue("VENDOR_NAME_LOC", 0);
				SOLE_PROPRIETOR_FLAG	= wf.getValue("SOLE_PROPRIETOR_FLAG", 0);
				SHIPPER_TYPE			= wf.getValue("SHIPPER_TYPE", 0);
				VENDOR_TYPE				= wf.getValue("VENDOR_TYPE", 0);
				IRS_NO					= wf.getValue("IRS_NO", 0);
				IRS_NO_OLD				= wf.getValue("IRS_NO_OLD", 0);
				BUSINESS_TYPE			= wf.getValue("BUSINESS_TYPE", 0);
				INDUSTRY_TYPE			= wf.getValue("INDUSTRY_TYPE", 0);
				START_DATE				= wf.getValue("START_DATE", 0);
				CAPITAL					= wf.getValue("CAPITAL", 0);
				CEO_NAME_LOC			= wf.getValue("CEO_NAME_LOC", 0);
				RESIDENT_NO				= wf.getValue("RESIDENT_NO", 0);
				PHONE_NO1				= wf.getValue("PHONE_NO1", 0);
				
				ENTRY_DEPT_NAME			= wf.getValue("ENTRY_DEPT_NAME", 0);
				ENTRY_USER_NAME			= wf.getValue("ENTRY_USER_NAME", 0);
				COUNTRY					= wf.getValue("COUNTRY", 0);
				CITY_CODE				= wf.getValue("CITY_CODE", 0);
				TEXT_CITY_CODE			= wf.getValue("TEXT_CITY_CODE", 0);
				ZIP_CODE				= wf.getValue("ZIP_CODE", 0);
				ADDRESS_LOC				= wf.getValue("ADDRESS_LOC", 0);
				PHONE_NO2				= wf.getValue("PHONE_NO2", 0);
				FAX_NO					= wf.getValue("FAX_NO", 0);
				BIZ_CLASS1				= wf.getValue("BIZ_CLASS1", 0);
				BIZ_CLASS2				= wf.getValue("BIZ_CLASS2", 0);
				BIZ_CLASS3				= wf.getValue("BIZ_CLASS3", 0);
				BIZ_CLASS4				= wf.getValue("BIZ_CLASS4", 0);
				BIZ_CLASS5				= wf.getValue("BIZ_CLASS5", 0);
				BANK_KEY				= wf.getValue("BANK_KEY", 0);
				DEPOSITOR_NAME			= wf.getValue("DEPOSITOR_NAME", 0);
				BANK_ACCT				= wf.getValue("BANK_ACCT", 0);
				CREDIT_RATING			= wf.getValue("CREDIT_RATING", 0);
				CREDIT_DATE				= wf.getValue("CREDIT_DATE", 0);
				IRS_NO_MAIN				= wf.getValue("IRS_NO_MAIN", 0);
				COMPANY_REG_NO			= wf.getValue("COMPANY_REG_NO", 0);
				ATTACH_NO				= wf.getValue("ATTACH_NO", 0);
				ATTACH_COUNT			= wf.getValue("ATTACH_COUNT", 0);
				SEARCH_KEY				= wf.getValue("SEARCH_KEY", 0);
				HOUSE_NUM1				= wf.getValue("HOUSE_NUM1", 0);
				AKONT					= wf.getValue("AKONT", 0);
				ZTERM					= wf.getValue("ZTERM", 0);
				ZWELS					= wf.getValue("ZWELS", 0);
				EMP_COUNT1				= wf.getValue("EMP_COUNT1", 0);
				EMP_COUNT2				= wf.getValue("EMP_COUNT2", 0);
				
				HOME_URL				= wf.getValue("HOME_URL", 0);
				TAX_DIV					= wf.getValue("TAX_DIV", 0);
				ENGINEER_COUNT			= wf.getValue("ENGINEER_COUNT", 0);
				ENTRY_TEL				= wf.getValue("ENTRY_TEL", 0);
				ENTRY_EMAIL				= wf.getValue("ENTRY_EMAIL", 0);
				REJECT_REASON			= wf.getValue("REJECT_REASON", 0);
				
				if (HBKID == null)
					HBKID = wf.getValue("BANK_CODE", 0);
				else
					HBKID = "".equals(wf.getValue("BANK_CODE", 0)) ? ""
							: String.valueOf(Integer.parseInt(wf
									.getValue("BANK_CODE", 0)));

			}
		}
		//Logger.debug.println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbbbbbbbbbbbbbbbb"+value2);
		//if (value2.status == 1) {
			//SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
			//iRowCount2 = wf2.getRowCount();
			//if (iRowCount2 > 0) {
			//	lCode = wf2.getValue("L_CODE", 0);
			//	lText = wf2.getValue("L_TEXT", 0);
			//	mCode = wf2.getValue("M_CODE", 0);
			//	mText = wf2.getValue("M_TEXT", 0);
			//	sCode = wf2.getValue("S_CODE", 0);
			//	sText = wf2.getValue("S_TEXT", 0);
			//}
		//}
	}

	//ATTACH_COUNT = ATTACH_NO.equals("") ? "0" : "1";

	BP_FLAG = BP_FLAG == null || BP_FLAG.equals("") ? "0" : BP_FLAG;
	BIZ_CLASS1 = BIZ_CLASS1 == null || BIZ_CLASS1.equals("") ? "0" : BIZ_CLASS1;
	BIZ_CLASS2 = BIZ_CLASS2 == null || BIZ_CLASS2.equals("") ? "0" : BIZ_CLASS2;
	BIZ_CLASS3 = BIZ_CLASS3 == null || BIZ_CLASS3.equals("") ? "0" : BIZ_CLASS3;
	BIZ_CLASS4 = BIZ_CLASS4 == null || BIZ_CLASS4.equals("") ? "0" : BIZ_CLASS4;
	BIZ_CLASS5 = BIZ_CLASS5 == null || BIZ_CLASS5.equals("") ? "0" : BIZ_CLASS5;

	JOB_STATUS = SIGN_STATUS.equals("P") ? "승인대기" : (SIGN_STATUS.equals("R") ? "반려" : (SIGN_STATUS.equals("E") ? "승인" : ""));
	COUNTRY = COUNTRY.equals("") ? "KR" : COUNTRY;

	String LB_SHIPPER_TYPE = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M025", SHIPPER_TYPE);
	String LB_COUNTRY = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M001", COUNTRY);
	//String LB_CITY_CODE = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M004", CITY_CODE);
	String LB_BANK_KEY = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M349","020");
	String LB_VENDOR_TYPE = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M076", "SU");
	String LB_TAX_KEY = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M400", TAX_KEY);
	/*
	 String LB_L_CODE = "";
	 String LB_M_CODE = "";
	 String LB_S_CODE = "";
	 LB_L_CODE = ListBox(info, "SL0313", "1#"+ lCode, "");
	 LB_M_CODE = ListBox(info, "SL0313", "2#"+ mCode, "");
	 LB_S_CODE = ListBox(info, "SL0313", "3#"+ sCode, "");
	 */
	///////////////////////////////////////////////////////////////////////////
	String message = "";
	String isSuccess          = JSPUtil.nullToEmpty(request.getParameter("isSuccess"));
	String s_template_refitem = JSPUtil.nullToEmpty(request.getParameter("s_template_refitem"));
	String c_template_refitem = JSPUtil.nullToEmpty(request.getParameter("c_template_refitem"));

	String[] s_factor_refitem = JSPUtil.koForArray(request.getParameterValues("s_factor_refitem"));
	String[] answered_seq     = JSPUtil.koForArray(request.getParameterValues("answered_seq"));
	String sg_refitem         = JSPUtil.nullToEmpty(request.getParameter("sg_refitem")); //소싱 그룹 구분키

	///////////////////////////////////////////////////////////////////////////

	String toDays = SepoaDate.getShortDateString();

	/* 복호화 */
	//EncDec enc = new EncDec();
	//RESIDENT_NO = enc.decrypt(RESIDENT_NO);
	RESIDENT_NO = RESIDENT_NO;
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/pwdPolicy.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/pluginfree/js/nppfs-1.13.0.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript" type="text/javascript">
$(document).ready(function(){
	npPfsStartup(document.form1, false, true, false, false, "npkencrypt", "on");
});
var G_HOUSE_CODE   = "<%=house_code%>";
var G_VENDOR_CODE  = "<%=vendor_code%>";
var G_COMPANY_CODE = "<%=company_code%>";
var G_IRS_NO       = "<%=irs_no%>";
var G_RESIDENT_NO  = "<%=resident_no%>";
var G_MODE		   = "<%=mode%>";
var G_TARGET       = "childFrame";
var G_LOADING_FLAG = true;
var G_MESSAGE1     = "";
var G_ERROR_MESSAGE = "에러가 발생하였습니다. 시스템 담당자에게 문의하십시오.";
var toDays = "<%=toDays%>";

function Init()
{
	document.forms[0].mode.value		= G_MODE;
	document.forms[0].irs_no.value 		= G_IRS_NO;
	document.forms[0].resident_no.value = G_RESIDENT_NO;
	parent.up.form1.vendor_code.value 	= "<%=vendor_code%>";
	parent.up.form1.flag.value 			= "<%=flag%>";
	
	var flag = "<%=flag%>";
	if(flag=="update" || "<%=status%>"=="T" || "<%=vendor_code%>" != "") {
		// 협력업체 정보 뿌려주기
		setVendorInfo();
		// 사업자 등록번호는 변경 불가 (변경할 경우 중복검토로직 넣을 것)
		document.forms[0].IRS_NO1.readOnly = "readOnly";
		document.forms[0].IRS_NO2.readOnly = "readOnly";
		document.forms[0].IRS_NO3.readOnly = "readOnly";
		/* 
		document.forms[0].IRS_NO1.style.backgroundColor = "DCDCDC";
		document.forms[0].IRS_NO2.style.backgroundColor = "DCDCDC";
        document.forms[0].IRS_NO3.style.backgroundColor = "DCDCDC";
         */
        document.forms[0].VENDOR_NAME_LOC.readOnly = "readOnly";        
        /*
        document.forms[0].BUSINESS_TYPE.readOnly = "readOnly";
        document.forms[0].INDUSTRY_TYPE.readOnly = "readOnly";
        document.forms[0].CEO_NAME_LOC.readOnly = "readOnly";
        document.forms[0].PHONE_NO1.readOnly = "readOnly";
        */       
        /*
        document.forms[0].VENDOR_NAME_LOC.style.backgroundColor = "DCDCDC";
        document.forms[0].BUSINESS_TYPE.style.backgroundColor = "DCDCDC";
        document.forms[0].INDUSTRY_TYPE.style.backgroundColor = "DCDCDC";
        document.forms[0].CEO_NAME_LOC.style.backgroundColor = "DCDCDC";
        document.forms[0].PHONE_NO1.style.backgroundColor = "DCDCDC";
		*/
        
        
        
        
        
        
        
        
        
        
        if ("<%=SIGN_STATUS%>"=="R"){
        	document.forms[0].VENDOR_NAME_LOC.readOnly = "";       
        	alert("반려되었습니다.\n\n반려사유:<%=REJECT_REASON%>");
        }
        
        
	} else {
		//alert(G_MODE);
		if(G_MODE == "irs_no"){
			document.forms[0].IRS_NO1.value = G_IRS_NO.substring(0,3);
			document.forms[0].IRS_NO2.value = G_IRS_NO.substring(3,5);
			document.forms[0].IRS_NO3.value = G_IRS_NO.substring(5);
			document.forms[0].IRS_NO1.disabled  = true;
			document.forms[0].IRS_NO2.disabled  = true;
			document.forms[0].IRS_NO3.disabled  = true;
			document.forms[0].IRS_NO1.style.backgroundColor = "DCDCDC";
			document.forms[0].IRS_NO2.style.backgroundColor = "DCDCDC";
            document.forms[0].IRS_NO3.style.backgroundColor = "DCDCDC";
		} else {
			document.forms[0].RESIDENT_NO1.value = G_RESIDENT_NO.substring(0,6);
			document.forms[0].RESIDENT_NO2.value = G_RESIDENT_NO.substring(6);
			document.forms[0].SOLE_PROPRIETOR_FLAG.value = 3;
			setResidentNo();
		}
	}
	checkSoleProprietorFlag();
	doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>'+'#M912' ,'city_code', '<%=CITY_CODE%>' );
	
}

function setResidentNo(){
	//alert("setResidentNo");
	document.forms[0].RESIDENT_NO1.disabled  	= true;
	document.forms[0].RESIDENT_NO2.disabled  	= true;
	document.forms[0].IRS_NO1.disabled  	 	= true;
	document.forms[0].IRS_NO2.disabled  	 	= true;
	document.forms[0].IRS_NO3.disabled  	 	= true;
	document.forms[0].IRS_NO_OLD1.disabled   	= true;
	document.forms[0].IRS_NO_OLD2.disabled   	= true;
	document.forms[0].IRS_NO_OLD3.disabled   	= true;
	document.forms[0].IRS_NO_MAIN1.disabled  	= true;
	document.forms[0].IRS_NO_MAIN2.disabled  	= true;
	document.forms[0].IRS_NO_MAIN3.disabled  	= true;
	document.forms[0].COMPANY_REG_NO1.disabled  = true;
	document.forms[0].COMPANY_REG_NO2.disabled  = true;
	document.forms[0].CREDIT_RATING.disabled  	= true;
	document.forms[0].CREDIT_DATE.disabled  	= true;
	document.forms[0].ENTRY_DEPT_NAME.disabled  = true;
	document.forms[0].SOLE_PROPRIETOR_FLAG.disabled  = true;
	document.forms[0].VENDOR_TYPE.disabled 		= true;
	document.forms[0].BUSINESS_TYPE.disabled	= true;
	document.forms[0].INDUSTRY_TYPE.disabled    = true;
	document.forms[0].START_DATE.disabled       = true;
	document.forms[0].RESIDENT_NO1.style.backgroundColor	= "DCDCDC";
	document.forms[0].RESIDENT_NO2.style.backgroundColor	= "DCDCDC";
	document.forms[0].IRS_NO1.style.backgroundColor 		= "DCDCDC";
	document.forms[0].IRS_NO2.style.backgroundColor 		= "DCDCDC";
	document.forms[0].IRS_NO3.style.backgroundColor 		= "DCDCDC";
	document.forms[0].IRS_NO_OLD1.style.backgroundColor 	= "DCDCDC";
	document.forms[0].IRS_NO_OLD2.style.backgroundColor 	= "DCDCDC";
	document.forms[0].IRS_NO_OLD3.style.backgroundColor 	= "DCDCDC";
	document.forms[0].IRS_NO_MAIN1.style.backgroundColor	= "DCDCDC";
	document.forms[0].IRS_NO_MAIN2.style.backgroundColor	= "DCDCDC";
	document.forms[0].IRS_NO_MAIN3.style.backgroundColor	= "DCDCDC";
	document.forms[0].COMPANY_REG_NO1.style.backgroundColor	= "DCDCDC";
	document.forms[0].COMPANY_REG_NO2.style.backgroundColor	= "DCDCDC";
	document.forms[0].CREDIT_RATING.style.backgroundColor	= "DCDCDC";
	document.forms[0].CREDIT_DATE.style.backgroundColor		= "DCDCDC";
	document.forms[0].ENTRY_DEPT_NAME.style.backgroundColor	= "DCDCDC";
	document.forms[0].BUSINESS_TYPE.style.backgroundColor	= "DCDCDC";
	document.forms[0].INDUSTRY_TYPE.style.backgroundColor   = "DCDCDC";
	document.forms[0].START_DATE.style.backgroundColor      = "DCDCDC";
	
}
function setVendorInfo()
{
	var f = document.forms[0];
	var IRS_NO      	;
	var IRS_NO_OLD		;
	var IRS_NO_MAIN		;
	var COMPANY_REG_NO	;
	var RESIDENT_NO		;
	var ZIP_CODE		;

	f.VENDOR_CODE.value 			= "<%=VENDOR_CODE%>";
	f.VENDOR_CODE2.value 			= "<%=VENDOR_CODE%>";
	f.USER_ID_2.value                 = "<%=USER_ID%>";
	f.SIGN_STATUS.value             = "<%=JOB_STATUS%>";
	f.BP_FLAG.checked            	= "<%=BP_FLAG%>";
	f.VENDOR_NAME_LOC.value         = "<%=VENDOR_NAME_LOC%>";
	f.SOLE_PROPRIETOR_FLAG.value    = "<%=SOLE_PROPRIETOR_FLAG%>";
	f.SHIPPER_TYPE.value            = "<%=SHIPPER_TYPE%>";
	f.VENDOR_TYPE.value             = "SU";
	IRS_NO		                  	= "<%=IRS_NO%>";
	IRS_NO_OLD		              	= "<%=IRS_NO_OLD%>";
	f.BUSINESS_TYPE.value           = "<%=BUSINESS_TYPE%>";
	f.INDUSTRY_TYPE.value           = "<%=INDUSTRY_TYPE%>";
	
	f.START_DATE.value              = "<%=START_DATE%>";
	
	
	
	f.CAPITAL.value                 = add_comma("<%=CAPITAL%>", 0);
	f.CEO_NAME_LOC.value            = "<%=CEO_NAME_LOC%>";
	RESIDENT_NO		            	= "<%=RESIDENT_NO%>";
	f.PHONE_NO1.value               = "<%=PHONE_NO1%>";
	
	f.ENTRY_DEPT_NAME.value         = "<%=ENTRY_DEPT_NAME%>";
	f.ENTRY_USER_NAME.value         = "<%=ENTRY_USER_NAME%>";
	f.COUNTRY.value                 = "<%=COUNTRY%>";
	ZIP_CODE	                	= "<%=ZIP_CODE%>";
	f.ZIP_CODE1.value               = ZIP_CODE;
	f.ADDRESS_LOC.value             = "<%=ADDRESS_LOC%>";
	f.PHONE_NO2.value               = "<%=PHONE_NO2%>";
	f.FAX_NO.value                  = "<%=FAX_NO%>";
	
	// 거래구분 체크박스 세팅
	if("<%=BIZ_CLASS1%>" == "1") {
		f.BIZ_CLASS1.checked = "checked";
	}
	if("<%=BIZ_CLASS2%>" == "1") {
		f.BIZ_CLASS2.checked = "checked";
	}
	if("<%=BIZ_CLASS3%>" == "1") {
		f.BIZ_CLASS3.checked = "checked";
	}
	if("<%=BIZ_CLASS4%>" == "1") {
		f.BIZ_CLASS4.checked = "checked";
	}
	if("<%=BIZ_CLASS5%>" == "1") {
		f.BIZ_CLASS5.checked = "checked";
	}
	
	f.BANK_KEY.value                = "<%=BANK_KEY%>";
	f.DEPOSITOR_NAME.value          = "<%=DEPOSITOR_NAME%>";
	f.BANK_ACCT.value               = "<%=BANK_ACCT%>";
	f.CREDIT_RATING.value           = "<%=CREDIT_RATING%>";
	f.CREDIT_DATE.value             = "<%=CREDIT_DATE%>";
	IRS_NO_MAIN            			= "<%=IRS_NO_MAIN%>";
	COMPANY_REG_NO		         	= "<%=COMPANY_REG_NO%>";
	f.SEARCH_KEY.value             	= "<%=SEARCH_KEY%>";
	f.HOUSE_NUM1.value             	= "<%=HOUSE_NUM1%>";
	f.city_code.value             	= "<%=CITY_CODE%>";
	f.AKONT_TEXT.value             	= "<%=AKONT%>";
	f.AKONT.value             		= "<%=AKONT%>";
	f.ZTERM.value             		= "<%=ZTERM%>";
	f.ZWELS.value             		= "<%=ZWELS%>";
	f.HBKID.value             		= "<%=HBKID%>";
	f.EMP_COUNT1.value				= add_comma("<%=EMP_COUNT1%>", 0);
	f.EMP_COUNT2.value				= add_comma("<%=EMP_COUNT2%>", 0);
	
	f.HOME_URL.value                = "<%=HOME_URL%>";
	f.TAX_DIV.value                 = "<%=TAX_DIV%>";
	f.ENTRY_TEL.value               = "<%=ENTRY_TEL%>";
	f.ENTRY_EMAIL.value             = "<%=ENTRY_EMAIL%>";

	if(IRS_NO.length >= 10)
	{
		f.IRS_NO1.value = IRS_NO.substring(0,3);
		f.IRS_NO2.value = IRS_NO.substring(3,5);
		f.IRS_NO3.value = IRS_NO.substring(5);
		f.irs_no.value = IRS_NO;
	}
	if(IRS_NO_OLD		>= 10){
		f.IRS_NO_OLD1.value = IRS_NO_OLD.substring(0,3);
		f.IRS_NO_OLD2.value = IRS_NO_OLD.substring(3,5);
		f.IRS_NO_OLD3.value = IRS_NO_OLD.substring(5);
	}
	if(IRS_NO_MAIN		>= 10){
		f.IRS_NO_MAIN1.value = IRS_NO_MAIN.substring(0,3);
		f.IRS_NO_MAIN2.value = IRS_NO_MAIN.substring(3,5);
		f.IRS_NO_MAIN3.value = IRS_NO_MAIN.substring(5);
	}
	if(COMPANY_REG_NO	>= 14){
		f.COMPANY_REG_NO1.value = COMPANY_REG_NO.substring(0,6);
		f.COMPANY_REG_NO2.value = COMPANY_REG_NO.substring(6);
		
		f.COMPANY_REG_NO1_O.value = COMPANY_REG_NO.substring(0,6);
		f.COMPANY_REG_NO2_O.value = COMPANY_REG_NO.substring(6);
	}
	if(RESIDENT_NO		>= 13){


		var work_type ;

		try{
			work_type = parent.opener.parent.parent.parent.topFrame.work_type;
		}catch(e){
			try{
				work_type = parent.parent.opener.parent.parent.parent.topFrame.work_type;
			}catch(e){
				parent.parent.work_type;
			}
		}

		var g_reg_s="";
		f.RESIDENT_NO1.value = RESIDENT_NO.substring(0,6);
		if("G" == work_type && "Y" == "<%=popup%>"){
			for(i = 0; i < RESIDENT_NO.substring(6).length ; i++){
				g_reg_s += RESIDENT_NO.substring(6).charAt(i).replace(RESIDENT_NO.substring(6).charAt(i),"*");
			}
			f.RESIDENT_NO2.value = g_reg_s;
		}else{
			f.RESIDENT_NO2.value = RESIDENT_NO.substring(6);
		}
	}

	if(G_MODE != 'irs_no')
		setResidentNo();
}

function check_irs_no(obj, chknum)
{

	if (obj.value.length != chknum)
	{
		var message = "첫번째";
		if(obj.name=="i_irs_no2")
			message = "두번째";
		else if(obj.name=="i_irs_no3")
			message = "세번째";
		alert("사업자등록번호 "+message+"에는 "+chknum+"자리로 입력하셔야 합니다.");
		obj.select();
		obj.focus();
		return;
	}

	if(!IsNumber1(obj.value)) {
	 	alert("사업자등록번호에는 숫자만 입력하셔야 합니다.");
	 	obj.focus();
		return;
	}

}

function moveFocus(obj, targetObj, chknum)
{
	if(obj.value.length == chknum)
		targetObj.focus();
}

/*
 	주민번호 앞자리 유효성 체크
*/
function Resident_chk(resident_no){

	var t_year =toDays.substring(2,4);

	var rNo_year = resident_no.substring(0,2);
	var rNo_month = resident_no.substring(2,4);
	var rNo_date = resident_no.substring(4,6);

	var i = 1;

	if(rNo_year=="00"||rNo_month=="00"||rNo_date=="00"){
		alert("주민번호 앞자리의 생년월일을 형식에 맞게 입력하여 주십시오.");
		document.form1.RESIDENT_NO1.value="";
		return false;
	}

	if(rNo_year.substring(0,1)=="0"){

		rNo_year = rNo_year.substring(1,3);
	}
	if (t_year.substring(2,3)=="0"){

		t_year =  t_year.substring(2,4);
	}
	if(rNo_year < 40){

		alert("주민번호 앞자리의 년도를 정확히 입력하여 주십시오.");
		document.form1.RESIDENT_NO1.value="";
		return false;
	}

	if(rNo_month.substring(0,1)=="0"){
		rNo_month = rNo_month.substring(1,3);

	}
	if(rNo_month > 12 || rNo_month < i){
		alert("주민번호 앞자리의 달을 형식에 맞게 입력하여 주십시오.");
		document.form1.RESIDENT_NO1.value="";
		return false;
	}
	if(rNo_date.substring(0,1)=="0"){
		rNo_date = rNo_date.substring(1,3);

	}
	if(rNo_date > 31 || rNo_date < i){
		alert("주민번호 앞자리의 날짜를 형식에 맞게 입력하여 주십시오.");
		document.form1.RESIDENT_NO1.value="";
		return false;
	}
	return true;
}

function chkIdIsEquals(chkstr)
{
    var user_id = document.forms[0].USER_ID.value;

    if(chkstr.indexOf(user_id) != -1) return false;
    else return true;
}

function chkMixing(chkstr)
{
    var j, a_cnt = 0, AA_cnt = 0, n_cnt = 0, ch = "";

    for (j=0; j<chkstr.length; j++)
    {
        ch = chkstr.charAt(j);
        if (!(ch >= 'a' && ch <= 'z') && !(ch >= 'A' && ch <= 'Z') && !(ch >= '0' && ch <= '9'))
        {
            return false;
        }

        if(ch >= 'a' && ch <= 'z') a_cnt++;
        if(ch >= 'A' && ch <= 'Z') AA_cnt++;
        if(ch >= '0' && ch <= '9') n_cnt++;
    }

    if(a_cnt == 0 && AA_cnt == 0) return false;
    if(n_cnt == 0) return false;

    return true;
}

function chkInputRepeat(chkstr)
{
    var j, repeat_cnt = 0, ch = "";

    for (j=0; j<chkstr.length; j++)
    {
        var tmp_ch = chkstr.charAt(j);

        if(j == 0) {
            ch = tmp_ch;
            repeat_cnt = 1;
        } else {
            if(ch == tmp_ch) {
                ch = tmp_ch;
                repeat_cnt++;
            } else {
                ch = tmp_ch;
                repeat_cnt = 1;
            }
        }
        if(repeat_cnt > 2) return false;
    }
    return true;
}

function isValidPasswd()
{
	var strPassword = LRTrim(document.form1.PASSWORD.value);
	if(strPassword.length == 0)
	{
		return "비밀번호를 입력하셔야 합니다.";
	}

	// /include/wisehub_scripts.jsp
// 	if(!hangulCheckCommon(strPassword))
// 	{
// 		return "비밀번호에는 한글을 사용할 수 없습니다.";
// 	}

	return "SUCCESS";
}

function isValidConfirmPasswd()
{
	var strPassword      = LRTrim(document.form1.PASSWORD.value);
	var confirm_password = LRTrim(document.form1.CONFIRM_PASSWORD.value);

	if(confirm_password.length == 0) {
		return "비밀번호확인을 입력하셔야 합니다.";
	}

	if(strPassword != confirm_password) {
		return "비밀번호가 다릅니다.";
	}

	return "SUCCESS";
}

function isEqualsIdPasswd() {

	return "SUCCESS";
}


function checkData(f)
{
	<%if (SIGN_STATUS.equals("")) {%>
				if(isEmpty(f.USER_ID.value))
				{
					alert("아이디(ID)를 입력하여 주십시오.");
					f.USER_ID.focus();
					return false;
				}
			
				if (f.duplicate.value == "F")
				{
					alert("아이디(ID) 중복확인을 입력하여 주십시오.");
					return false;
				}
			
				if(isEmpty(f.PASSWORD.value))
				{
					alert("비밀번호를 입력하여 주십시오.");
					f.PASSWORD.focus();
					return false;
				}
			
				if(isEmpty(f.CONFIRM_PASSWORD.value))
				{
					alert("확인 비밀번호를 입력하여 주십시오.");
					f.CONFIRM_PASSWORD.focus();
					return false;
				}
				/*
				if(!(f.PASSWORD.value == f.CONFIRM_PASSWORD.value) ) {
					alert("비밀번호가 일치하지 않습니다.");
					f.PASSWORD.focus();
					return ;
				}
				
				
				if(!chkIdIsEquals(f.PASSWORD.value)) {
					alert("비밀번호는 ID가 포함되어 있으면 안됩니다.");
					f.PASSWORD.focus();
					return ;
				}
				*/
				// 비밀번호 정책 적용체크
				// js/pwdPolicy.js : isNewValidPwd
				/*
				if ( !isNewValidPwd(f.USER_ID.value, f.PASSWORD.value) )
				{
					return;
				}
				*/
				//비밀번호 체크
				/*
				message = isValidPasswd();
				if(message != "SUCCESS")
				{
					alert(message);
					f.PASSWORD.focus();
					f.PASSWORD.select();
					return;
				}
				*/
				//사용자 ID, 비밀번호 동일체크
				/*
				message = isEqualsIdPasswd();
				if(message != "SUCCESS")
				{
					alert(message);
					f.PASSWORD.focus();
					f.PASSWORD.select();
					return;
				}
				*/
				//비밀번호확인 체크
				/*
				message = isValidConfirmPasswd();
				if(message != "SUCCESS")
				{
					alert(message);
					f.CONFIRM_PASSWORD.focus();
					f.CONFIRM_PASSWORD.select();
					return;
				}
				*/
	
	<%}%>



	if(isEmpty(f.VENDOR_NAME_LOC.value))
	{
		alert("회사명을 입력하여 주십시오.");
		f.VENDOR_NAME_LOC.focus();
		return false;
	}
	
	//if(isEmpty(f.SHIPPER_TYPE.value))
	//{
	//	alert("내/외자를 선택해 주십시오.");
	//	f.SHIPPER_TYPE.focus();
	//	return false;
	//}
	
	//if(isEmpty(f.VENDOR_TYPE.value))
	//{
	//	alert("업체구분을 입력하여주십시오.");
	//	f.VENDOR_TYPE.focus();
	//	return false;
	//}
	
	if(G_MODE=="irs_no"){
		if(f.SOLE_PROPRIETOR_FLAG.value != 3) {
			if( f.SHIPPER_TYPE.value  ==  "D") {
				if (f.IRS_NO1.value.length != 3) {
					alert("사업자등록번호 첫번째 칸에는 3자리로 입력하셔야 합니다.");
					f.IRS_NO1.focus();
					return false;
				}

				if (f.IRS_NO2.value.length != 2)
				{
					alert("사업자등록번호 두번째 칸에는 2자리로 입력하셔야 합니다.");
					f.IRS_NO2.focus();
					return false;
				}

				if (f.IRS_NO3.value.length != 5)
				{
					alert("사업자등록번호 세번째 칸에는 5자리로 입력하셔야 합니다.");
					f.IRS_NO3.focus();
					return false;
				}
			}
		}
	
		if(isEmpty(f.BUSINESS_TYPE.value))
		{
			alert("업태를 입력하여주십시오.");
			f.BUSINESS_TYPE.focus();
			return false;
		}
		
		if(isEmpty(f.INDUSTRY_TYPE.value))
		{
			alert("업종을 입력하여주십시오.");
			f.INDUSTRY_TYPE.focus();
			return false;
		}
	}
	
	/* 추가 */
	//if(isEmpty(f.CAPITAL.value)){
	//	alert("자본금을 입력하여 주십시오.");
	//	f.CAPITAL.focus();
	//	return false;
	//}
	
	//if(isEmpty(f.EMP_COUNT1.value) && isEmpty(f.EMP_COUNT2.value)){
	//	alert("종업원 수를 입력하여 주십시오.");
	//	f.EMP_COUNT1.focus();
	//	return false;
	//}
	
	var emp1 = f.EMP_COUNT1.value;
	var emp2 = f.EMP_COUNT2.value;
	if(emp1 == ''){
		emp1 = 0;
	}
	
	if(emp2 == ''){
		emp2 = 0;
	}
	
	
	if(isEmpty(f.CEO_NAME_LOC.value))
	{
		alert("대표자명(한글)을 입력하여 주십시오.");
		f.CEO_NAME_LOC.focus();
		return false;
	}
	
	// 보증관련 : 법인-비필수 , 개인, 프리랜서 - 필수
	var SOLE_PROPRIETOR_FLAG = document.form1.SOLE_PROPRIETOR_FLAG.value;
	
	if (isEmpty(f.PHONE_NO1.value))
	{
		alert("대표 전화번호를 입력하여 주십시오.");
		f.PHONE_NO1.focus();
		return false;
	}
	
	if (isEmpty(f.ENTRY_DEPT_NAME.value))
	{
		alert("작성자(사용자대리인)부서를 입력하여 주십시오.");
		f.ENTRY_DEPT_NAME.focus();
		return false;
	}
	
	if (isEmpty(f.ENTRY_USER_NAME.value))
	{
		alert("작성자(사용자대리인)성명을 입력하여 주십시오.");
		f.ENTRY_USER_NAME.focus();
		return false;
	}
	
	if (isEmpty(f.ENTRY_TEL.value))
	{
		alert("작성자(사용자대리인) 연락처를 입력하여 주십시오.");
		f.ENTRY_TEL.focus();
		return false;
	}
	
	if (isEmpty(f.ENTRY_EMAIL.value))
	{
		alert("작성자(사용자대리인) 이메일을  입력하여 주십시오.");
		f.ENTRY_EMAIL.focus();
		return false;
	}
	
	re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
	if(!re.test(f.ENTRY_EMAIL.value)) {
		alert("작성자(사용자대리인) 이메일이 잘못되었습니다.");
		f.ENTRY_EMAIL.focus();
		return;
	}
	
	if (isEmpty(f.ZIP_CODE1.value) )
	{
		alert("우편번호를 입력하여주십시오.");
		f.ZIP_CODE1.focus();
		return false;
	}
	
	if (chkKorea(f.ZIP_CODE1.value) != 5 )
	{
		alert("우편번호는 5자 입니다.");
		f.ZIP_CODE1.focus();
		return false;
	}
	
	if (isEmpty(f.ADDRESS_LOC.value))
	{
		alert("주소를 입력하여주십시오.");
		f.ADDRESS_LOC.focus();
		return false;
	}
	
	if (f.attach_no.value == ""){
		alert("파일첨부를 해주십시오.");
		f.attach_no.focus();
		return false;
	}
	
	/* if (isEmpty(f.PHONE_NO2.value))
	{
		alert("SMS 수신번호를 입력하여 주십시오.");
		f.PHONE_NO2.focus();
		return false;
	} */
	
	/* if(f.DEPOSITOR_NAME.value == ""){
		alert("예금주를 입력하여 주십시오.");
		f.DEPOSITOR_NAME.focus();
		return false;
	} */
	
	/* if(f.BANK_ACCT.value == ""){
		alert("계좌번호를 입력하여 주십시오.");
		f.BANK_ACCT.focus();
		return false;
	} */
	
	//if(f.city_code.value == ""){
	//	alert("도시를 입력하여 주십시오.");
	//	f.city_code.focus();
	//	return false;
	//}
	
	if(f.BANK_KEY.value == ""){
		alert("주거래은행을 입력하여 주십시오.");
		f.BANK_KEY.focus();
		return false;
	}
	
	// 거래구분 체크여부에 따른 값 세팅
	if(f.BIZ_CLASS1.checked) {
		f.BIZ_CLASS1.value = "1";
	} else {
		f.BIZ_CLASS1.value = "0";
	}

	if(f.BIZ_CLASS2.checked) {
		f.BIZ_CLASS2.value = "1";
	} else {
		f.BIZ_CLASS2.value = "0";
	}

	if(f.BIZ_CLASS3.checked) {
		f.BIZ_CLASS3.value = "1";
	} else {
		f.BIZ_CLASS3.value = "0";
	}
	
	if(f.BIZ_CLASS4.checked) {
		f.BIZ_CLASS4.value = "1";
	} else {
		f.BIZ_CLASS4.value = "0";
	}
	
	if(f.BIZ_CLASS5.checked) {
		f.BIZ_CLASS5.value = "1";
	} else {
		f.BIZ_CLASS5.value = "0";
	}
	
	return true;
}

function email_chk(email)
{
  	var invalidChars = "\"|&;<>!*\'\\"   ;
  	for (var i = 0; i < invalidChars.length; i++) {
    	if (email.indexOf(invalidChars.charAt ) != -1) {
    		alert("잘못된 이메일 주소입니다.");
      		return;
    	}
  	}
  	if (email.indexOf("@")==-1){
    	alert("잘못된 이메일 주소입니다. '@'가 없습니다..");
    	return;
  	}
  	if (email.indexOf(" ") != -1){
    	alert("잘못된 이메일 주소입니다.");
    	return;
  	}
  	if (window.RegExp) {
    	var reg1str = "(@.*@)|(\\.\\.)|(@\\.)|(\\.@)|(^\\.)";
    	var reg2str = "^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$";
    	var reg1 = new RegExp (reg1str);
    	var reg2 = new RegExp (reg2str);
		
    	if (reg1.test(email) || !reg2.test(email)) {
    		alert("잘못된 이메일 주소입니다.");
      		return;
    	}
  	}
  	return true;
}

//저장
function doSave()
{
	var f = document.forms[0];
	var flag = "<%=flag%>";

	document.forms[0].FLAG.value = flag == "update"||"<%=status%>"=="T"||"<%=vendor_code%>"!="" ? "U" : "C" ;
	var i_irs_no =  f.IRS_NO1.value +f.IRS_NO2.value +f.IRS_NO3.value;

	f.COUNTRY.disabled = false;

	if(!checkData(f))
		return;

	<%if (SIGN_STATUS.equals("")) {%>	
		f.USER_ID.value = f.USER_ID.value.toUpperCase();
	<%}%>	

	//공백 : 회원가입, U : 관리자수정, Y : 상세정보보기, T : 협력업체에서 정보보기
	var message = "저장 하시겠습니까?";
	<%if (!"".equals(popup)) { %>
		message = "회사정보를 수정하시겠습니까?";
	<%}%>
	if(flag == "insert"){
			if(i_irs_no != ""){
				CheckingIrsNo(i_irs_no);
			}
	} else {
		document.forms[0].ADDRESS_LOC.value = document.forms[0].ADDRESS_LOC.value + document.forms[0].ADDRESS_LOC2.value;

		if (confirm(message)){
			NextSave();
			//document.attachFrame.startUpload();	//2 startUpload
		}
	}
}

function rMateFileAttach(att_mode, view_type, file_type, att_no) {	//1
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (view_type == "C") {
		f.action = "/rMateFM/file_upload.jsp";
	} else if (view_type == "R"){
		f.action = "/rMateFM/rMate_file_attach.jsp";
	} else {
		return;
	}

	f.method = "POST";
	f.target = "attachFrame";
	f.submit();
}

function uploadCompleteUpdateData(att_no, att_data, att_del_data) {	//3
	var f = document.forms[0];

	f.att_no.value       = att_no;
	f.attach_no.value    = att_no;
	f.att_data.value     = att_data;
	f.att_del_data.value = att_del_data;

   	attachFileSave();
}

function attachFileSave() {											//4
	var f = document.forms[0];
	f.method = "POST";
	f.target = "childFrame";
	f.action = "/rMateFM/nAttachFileManage.jsp";
	f.submit();
}

function attachFileSaveResult(att_no, att_cnt) {					//5
	var attach_key   = att_no;
	var attach_count = att_cnt;

	var f = document.forms[0];
    f.att_no.value       = attach_key;
    f.attach_no.value    = attach_key;
    f.attach_count.value = attach_count;

    NextSave();
}

function CheckingIrsNo(irs_no)
{
	var temp_irs_no = "";
	temp_irs_no += document.form1.IRS_NO1.value;
	temp_irs_no += document.form1.IRS_NO2.value;
	temp_irs_no += document.form1.IRS_NO3.value;
	document.form1.irs_no.value = temp_irs_no;
	document.form1.method = "POST";
	document.form1.action = "checkDupIrsNo2.jsp"
	document.form1.target = G_TARGET;
	document.form1.submit();
}

function NextSave()
{
	var f = document.forms[0];
	
	f.CAPITAL.value 	= del_comma(f.CAPITAL.value);
	f.EMP_COUNT1.value 	= del_comma(f.EMP_COUNT1.value);
	f.EMP_COUNT2.value 	= del_comma(f.EMP_COUNT2.value);
	f.method = "POST";
 	f.target = G_TARGET;
	f.action = "ven_wk_ins2_ict_window10.jsp?SOLE_PROPRIETOR_FLAG="+f.SOLE_PROPRIETOR_FLAG.value+"&VENDOR_TYPE="+f.VENDOR_TYPE.value;
	
	f.submit();

}

function b2b()
{
		window.open('b2b_account.htm','test','width=500,height=700,status=yes')
}

function Saved(result, status)
{
	if(status == "1")
	{
		<%if (!"E".equals(SIGN_STATUS)) {%>
			alert("성공적으로 처리하였습니다.\r\n영업담당 저장후 가입신청하여야 정상진행이 됩니다.");			
		<%} else {%>
			alert("저장되었습니다.");
		<%}%>

		parent.up.form1.vendor_code.value = result;
		parent.up.form1.flag.value = "update";
		if(G_MODE == "irs_no"){
			parent.up.MM_showHideLayers('m1','','hide','m2','','show','m3','','hide','m4','','hide','m5','','hide','m6','','hide','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide');
			parent.up.goPage('cp');
		}else{
			parent.up.MM_showHideLayers('m1','','hide','m2','','show','m3','','hide','m4','','hide','m5','','hide','m6','','hide','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide')
			parent.up.goPage('cp');
		}
	} else {
		alert(G_ERROR_MESSAGE+" 사유 : "+result);
	}
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

function getCredit()
{
	var f = document.forms[0];
	var ecredit_flag = f.i_ecredit_flag.value;
	if( ecredit_flag == 'N' ){
		alert("신용평가기관과 연계가 안되어 있습니다.");
		return;
	}

	if(f.b_type.value == "1")
	{
		if( f.i_shipper_type.value  ==  "D")
		{
			if (f.i_irs_no1.value.length != 3)
			{
				alert("사업자등록번호 첫번째 칸에는 3자리로 입력하셔야 합니다.");
				f.i_irs_no1.focus();
				return false;
			}
			if (f.i_irs_no2.value.length != 2)
			{
				alert("사업자등록번호 두번째 칸에는 2자리로 입력하셔야 합니다.");
				f.i_irs_no2.focus();
				return false;
			}
			if (f.i_irs_no3.value.length != 5)
			{
				alert("사업자등록번호 세번째 칸에는 5자리로 입력하셔야 합니다.");
				f.i_irs_no3.focus();
				return false;
			}
		}
	}
	var vendor_code = form1.i_irs_no1.value + form1.i_irs_no2.value + form1.i_irs_no3.value;

	MM_openBrWindow('about:blank','subpop','width=716,height=660,left=40,top=20,resizable=yes');
	GotoUrl('https://www.ecredit.co.kr/embedded/pri/p_index.asp?bizno=' + vendor_code + '&EID=WJT','subpop');
}

function credit_query(){
	var temp_irs_no = "";
	temp_irs_no += document.form1.IRS_NO1.value;
	temp_irs_no += document.form1.IRS_NO2.value;
	temp_irs_no += document.form1.IRS_NO3.value;
	window.open("http://clip.nice.co.kr/rep_nclip/rep_DLink/rep_Link_CJSystems.jsp?bz_ins_no="+temp_irs_no,'subpop','width=850,height=660,left=40,top=20,resizable=yes')
}

function PopupManager(part)
{
	var FormName = document.forms[0];
	if(part=="city")
	{
		var COUNTRY_CODE = FormName.COUNTRY.value;
		if (COUNTRY_CODE == "")
		{
			alert("먼저 국가코드를 입력하세요.");
			return;
		}
		MM_openBrWindow('/s_kr/admin/info/hico_loc_search_pop.jsp','subpop','width=500,height=500,left=40,top=20,resizable=yes');
	}
}

function getIndustry_type(code,text1,text2,text3 ) {
	document.forms[0].INDUSTRY_TYPE.value = code;
}


function SP0274_Popup() {

	//MM_openBrWindow('/s_kr/admin/info/hico_addr_search_pop.jsp','subpop','width=500,height=500,left=40,top=20,resizable=yes');
	MM_openBrWindow('/common/AddrSearch.jsp','subpop','width=500,height=500,left=40,top=20,resizable=yes');
}

function  selectAddr(zip_code, address_loc1, address_loc2, city ) {
	form1.ZIP_CODE1.value = zip_code;
	//form1.ZIP_CODE2.value = zip_code.substring(3,6);
	form1.ADDRESS_LOC.value = address_loc2;
	//form1.city_code.value = city;
}

function start_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.START_DATE.value=year+month+day;
}

function credit_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.CREDIT_DATE.value=year+month+day;
}

function searchProfile(fc) {
	var url = "";
	if( fc == "company_code" ) {
	   if (document.forms[0].edit.value == "N")
	   		return;

	   if (document.forms[0].user_type.value  == "") {
			alert("사용자 구분을 먼저 선택해야 합니다.");
			return;
	   }

	   if (document.forms[0].user_type.value == "P") {
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0055&function=getPartner_code&values=<%=house_code%>&values=&values=";

	   } else if (document.forms[0].user_type.value  == "S") {
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
			return;
	   }
	}
	
	if(fc == "city") {
		if(document.forms[0].COUNTRY.value == "") {
			alert("국가를 먼저 선택해야 합니다.");
			return;
		} else {
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0019&function=getCity&values=<%=house_code%>&values="+document.forms[0].COUNTRY.value+"&values=&values=";
		}
	} else if(fc == "dept") {
		if (document.forms[0].user_type.value  == "P" || document.forms[0].user_type.value  == "S")
		{
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0053&function=getDept&values=<%=house_code%>&values=M105";
		} else {

			if(document.forms[0].company_code.value == "") {
				alert("회사단위를 먼저 선택해야 합니다.");
				return;
			}
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0022&function=getDept&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values=&values=";
		}

	}  else if(fc == "pr")
		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getPr&values=<%=house_code%>&values=M062&values=&values=";
	else if(fc == "posi") {
		if (document.forms[0].user_type.value  == "P" || document.forms[0].user_type.value  == "S")
		{
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getPosition&values=<%=house_code%>&values=M106&values=&values=";
		} else {

			if(document.forms[0].company_code.value == "") {
				alert("회사단위를 먼저 선택해야 합니다.");
				return;
			}
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9029&function=getPosition&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values=C002&values=&values=";
		}
	}else if(fc == "manager_posi") {
		if (document.forms[0].user_type.value  == "P" || document.forms[0].user_type.value  == "S")
		{
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getmanager_Position&values=<%=house_code%>&values=M107&values=&values=";
		} else {
			if(document.forms[0].company_code.value == "") {
				alert("회사단위를 먼저 선택해야 합니다.");
				return;
			}
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9183&function=getmanager_Position&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values=&values=";
		}
	}

	Code_Search(url,'','','','','');
}

function getCity(code, text) {
	//document.forms[0].city_code.value = code;
	//document.forms[0].text_city_code.value = text;
}

	function selectCode( maker_code, maker_name) {
		document.forms[0].AKONT_TEXT.value 	= maker_name;
		document.forms[0].AKONT.value 	= maker_code;
	}

	function SP9053_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M351&values=&values=/&desc=코드&desc=이름";
		var doc = window.open( url, 'pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	function downFile(v_fileName){
		window.open("/wisefw/resource/file_download.jsp?att_file=/support/guide/"+v_fileName+"&file_name="+v_fileName, 'user', 'left=100, top=200, width=0, height=0, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
	}

	function goCredit(irs_no){
		var credit_rating = "<%=CREDIT_RATING%>";
		if(credit_rating == ""){
			alert("신용등급이 없습니다.");
			return;
		}
		var url = "http://clip.nice.co.kr/rep_nclip/rep_DLink/rep_Link_ibk.jsp?bz_ins_no="+irs_no;
		var credit_eval = window.open(url,"credit","left=0,top=0,width=900,height=780,resizable=yes,scrollbars=yes");
		credit_eval.focus();
	}

	function checkSoleProprietorFlag(){
		var SOLE_PROPRIETOR_FLAG = document.form1.SOLE_PROPRIETOR_FLAG.value;
		//alert("SOLE_PROPRIETOR_FLAG : " + SOLE_PROPRIETOR_FLAG);
		if(SOLE_PROPRIETOR_FLAG == 1 ){ // 법인사업자
			document.form1.RESIDENT_NO1.className 	= "inputsubmit";
			document.form1.RESIDENT_NO2.className 	= "inputsubmit";
			document.form1.COMPANY_REG_NO1.className= "input_re";
			document.form1.COMPANY_REG_NO2.className= "input_re";
		}else {							// 개인, 프리랜서
			document.form1.RESIDENT_NO1.className 	= "input_re";
			document.form1.RESIDENT_NO2.className 	= "input_re";
			document.form1.COMPANY_REG_NO1.className= "inputsubmit";
			document.form1.COMPANY_REG_NO2.className= "inputsubmit";
		}

	}
	
	function doClose(){		
		parent.window.close();
	}
	
	function goDuplicate() 
	{
		var f = document.forms[0];
		f.duplicate.value = "T";
		f.USER_ID.value = f.USER_ID.value.toUpperCase();
		var user_id = f.USER_ID.value;

		if(!checkEmpty(f.USER_ID, "사용자 ID를 입력하여 주십시오."))
			return;

		if(!checkKorea(f.USER_ID, "사용자 ID는 10자 이내입니다.", 10))
			return ;

		f.method = "POST";
		f.target = "childFrame";
		f.action = "/ict/s_kr/admin/user/use_wk_ins2_ict.jsp";
		f.submit();
	}
	
	function checkDulicate(o_flag)
	{
		document.forms[0].duplicate.value = o_flag;

		if(o_flag == "F") {
			document.forms[0].USER_ID.select();
			return false;
		} else if(o_flag == "T") {
			return true;
		}
	}
	function onlyNumber(keycode){
		/* alert(keycode); */
		if(keycode >= 48 && keycode <= 57){
		}else {
			return false;
		}
		return true;
	}
	
 	function onlyNumberUp(obj){
 		if(isNaN(obj.value)){
 			var regExt = /\D/g;
 			obj.value = obj.value.replace(regExt, '');
 			alert(obj.value);
 		}
 	}
	
	/* function goAttach(attach_no){
		attach_file(attach_no,"IMAGE");
	} */

// 	function setAttach(attach_key, arrAttrach, attach_count) {
// 		$("#att_no").val(attach_key);
// 		$("#attach_no").val(attach_key);
// 		$("#attach_no_count").val(attach_count);
		
// // 		document.form1.att_no.value = attach_key;
// // 		document.form1.attach_no.value = attach_key;
// // 		document.form1.attach_count.value = attach_count;
// 	}	

function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.getElementById("attach_no").value            = attach_key;
	document.getElementById("attach_no_count").value      = attach_count;
}

function comma(value,value2){
	//alert(value.replace(/,/gi,""));
	return add_comma(value.replace(/,/gi,""),0);
	
}

function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}

//INPUTBOX 입력시 콤마 제거
function setOnFocus(obj) {
    var target = eval("document.forms[0]." + obj.name);
    target.value = del_comma(target.value);
}

//INPUTBOX 입력 후 콤마 추가
function setOnBlur(obj) {
    var target = eval("document.forms[0]." + obj.name);
    if(IsNumber(target.value) == false) {
        alert("숫자를 입력하세요.");
        return;
    }
    target.value = add_comma(target.value,0);
}

function ckbFg_onclick(){
	if(document.forms[0].ckbFg.checked){
		document.forms[0].ZIP_CODE1.readOnly= ""; 
	}else{
		document.forms[0].ZIP_CODE1.readOnly= "readOnly";
	}
	
}

/*****************************************************************************************/
</script>
</head>

<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="Init()">

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<form id="form1" name="form1" method="post" action="">
								<input type="hidden" id="IRS_NO" 		name="IRS_NO" 			value="">
								<input type="hidden" id="VENDOR_CODE" 	name="VENDOR_CODE" 		value="">
								<input type="hidden" id="STATUS" 		name="STATUS" 			value="">
								<input type="hidden" id="FLAG" 			name="FLAG" 			value="">
								<input type="hidden" id="mode" 			name="mode" 			value="">
								<input type="hidden" id="irs_no" 		name="irs_no" 			value="">
								<input type="hidden" id="resident_no" 	name="resident_no" 		value="">
								<input type="hidden" id="iRowCount2" 	name="iRowCount2" 		value="<%=iRowCount2%>">
								<input type="hidden" id="lCode" 		name="lCode" 			value="<%=lCode%>">
								<input type="hidden" id="att_mode" 		name="att_mode" 		value=""> 
								<input type="hidden" id="view_type" 	name="view_type" 		value=""> 
								<input type="hidden" id="file_type" 	name="file_type" 		value=""> 
								<input type="hidden" id="tmp_att_no" 	name="tmp_att_no" 		value=""> 
								<input type="hidden" id="att_data" 		name="att_data" 		value=""> 
								<input type="hidden" id="att_del_data" 	name="att_del_data" 	value="">
								<input type="hidden" name="duplicate" value="F">
							
							<% if(!ctrl_code.equals("P99")){ %>
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;승인상태
									</td>
									<td class="data_td" >
										<input type="text" 		id="SIGN_STATUS" name="SIGN_STATUS" value="" size="10" maxlength="20" class="input_data2" readOnly>
										<input type="hidden" 	id="BP_FLAG" name="BP_FLAG" value="" size="30" maxlength="50" class="inputsubmit" <%=readOnly_flag%>>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회사코드
									</td>
									<td class="data_td" >
										<input type="text" 		id="VENDOR_CODE2" name="VENDOR_CODE2" value="" size="10" maxlength="20" class="input_data2" readOnly>			
									</td>
								</tr>
								
								<% if (SIGN_STATUS.equals("")) { %>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr>
										<td class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;아이디(ID)
										</td>
										<td class="data_td">
											<table cellpadding="0">
												<tr>
													<td> 
														<input type="text" id="USER_ID" name="USER_ID" size="20" maxlength="10" value="" style="ime-mode: disabled;" class="input_re" onKeyUp="return chkMaxByte(10, this, '사용자ID');">
													</td>
													<td><script language="javascript">btn("javascript:goDuplicate()","중복확인")</script></td>
												</tr>
											</table>
										</td>
										<td class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;비밀번호/확인
										</td>
										<td class="data_td">
											<input type="password" id="PASSWORD" name="PASSWORD" size="18" maxlength="20" class="input_re"   npkencrypt="on" style="ime-mode:disabled;">
											<input type="password" id="CONFIRM_PASSWORD" name="CONFIRM_PASSWORD" size="18" maxlength="20" class="input_re"  npkencrypt="on" style="ime-mode:disabled;">
											<br/>
											비밀번호는 영문,숫자,특수문자중<br/>
											2가지 이상을 조합할 경우 10자리,<br/>
											3가지 이상을 조합할 경우 8자리로 구성하여 주십시오. <br/>
										</td>
									</tr>
								<% } %>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td width="18%" class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;회사명
									</td>
									<td class="data_td">
										<input type="text" id="VENDOR_NAME_LOC" name="VENDOR_NAME_LOC" value="" size="35" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(50, this, '회사명');" maxlength="50">
										<input type="hidden" id="VENDOR_NAME_LOC_O" name="VENDOR_NAME_LOC_O" value='<%=VENDOR_NAME_LOC %>'/>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계정(로그인)
									</td>
									<td class="data_td" >
										<input type="text" 		id="USER_ID_2" name="USER_ID_2" value="" size="10" maxlength="20" class="input_data2" readOnly>			
									</td>
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;등록형태
									</td>
									<td class="data_td" style="display: none;">
										<select id="SOLE_PROPRIETOR_FLAG" name="SOLE_PROPRIETOR_FLAG" class="inputsubmit" onChange="checkSoleProprietorFlag();">
											<option value="1" selected>법인사업자</option>
											<option value="2">개인사업자</option>
											<% if (mode.equals("resident_no")) { %>
												<option value="3">프리랜서</option>
											<% } %>
										</select>
									</td>
								</tr>
								<tr style="display: none;">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;내자/외자
									</td>
									<td class="data_td" colspan="3">
										<select id="SHIPPER_TYPE" name="SHIPPER_TYPE" class="input_re">
											<%=LB_SHIPPER_TYPE%>
										</select>(국내업체, 해외업체)
									</td>
									<td class="title_td" style="display: none;" >
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;파트너종류
									</td>
									<td class="data_td" style="display: none;">
										<select id="VENDOR_TYPE" name="VENDOR_TYPE" class="input_re">
											<%=LB_VENDOR_TYPE%>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;사업자등록번호
									</td>
									<td class="data_td" colspan="3">
										<input type="text" id="IRS_NO1" name="IRS_NO1" value="" size="3" maxlength="3" class="input_re" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);"> - 
										<input type="text" id="IRS_NO2" name="IRS_NO2" value="" size="2" maxlength="2" class="input_re" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);"> - 
										<input type="text" id="IRS_NO3" name="IRS_NO3" value="" size="5" maxlength="5" class="input_re" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);">
										<% if("Y".equals(popup)){ %>
											&nbsp;&nbsp;&nbsp;&nbsp;
											<a href ="javascript:goCredit('<%=IRS_NO%>')">
												<img src="/images/btn_nice.gif" style="border:0;" width="90" height="15">
											</a>
										<%} %>
									</td>
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;이전사업자등록번호
									</td>
									<td class="data_td" style="display: none;">
										<input type="text" id="IRS_NO_OLD1" name="IRS_NO_OLD1" value="" size="3" maxlength="3" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="width: 60px;ime-mode:disabled;"> - 
										<input type="text" id="IRS_NO_OLD2" name="IRS_NO_OLD2" value="" size="2" maxlength="2" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="width: 40px;ime-mode:disabled;"> - 
										<input type="text" id="IRS_NO_OLD3" name="IRS_NO_OLD3" value="" size="5" maxlength="5" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="width: 90px;ime-mode:disabled;">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;업태
									</td>
									<td class="data_td">
										<input type="text" id="BUSINESS_TYPE" name="BUSINESS_TYPE" value="" size="15" class="input_re" onKeyUp="return chkMaxByte(100, this, '업태');" maxlength="100">
										<input type="hidden" id="BUSINESS_TYPE_O" name="BUSINESS_TYPE_O" value='<%=BUSINESS_TYPE %>'/>
										ex.) 도.소매,서비스 외
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;업종
									</td>
									<td class="data_td">
										<input type="text" id="INDUSTRY_TYPE" name="INDUSTRY_TYPE" value="" size="15" class="input_re" onKeyUp="return chkMaxByte(100, this, '업종');" maxlength="100">
										<input type="hidden" id="INDUSTRY_TYPE_O" name="INDUSTRY_TYPE_O" value='<%=INDUSTRY_TYPE %>'/>
										ex.) 소프트웨어개발	외
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede" style="display: none;"></td>
								</tr>
								<tr  style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;자본금
									</td>
									<td class="data_td">
										<input type="text" id="CAPITAL" name="CAPITAL" value="" size="15" class="input_re"  style="ime-mode: disabled; text-align: right;" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n"  onchange="$('#CAPITAL').val(comma(this.value, 0));" maxlength="15"> 원
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;종업원 수
									</td>
									<td class="data_td">
										<input type="text" id="EMP_COUNT1" name="EMP_COUNT1" value="" size="7" class="input_re"  style="ime-mode: disabled;"	onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" maxlength="13" onfocus="setOnFocus(this)" onblur="setOnBlur(this)"> (정규직)
										<input type="text" id="EMP_COUNT2" name="EMP_COUNT2" value="" size="7" class="input_re"  style="ime-mode: disabled;"	onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" maxlength="13" onfocus="setOnFocus(this)" onblur="setOnBlur(this)"> (계약직)
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede" style="display: none;"></td>
								</tr>
								<tr style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;과세구분
									</td>
									<td class="data_td" colspan="3">
										<select id="TAX_DIV" name="TAX_DIV" class="inputsubmit" > <%=LB_TAX_KEY%> </select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede" style="display: none;"></td>
								</tr>	
								<tr style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;영업개시일
									</td>
									<td class="data_td" colspan="3">
										<s:calendar id="START_DATE" default_value="" format="%Y/%m/%d"/>
										ex.) 2007/07/01
									</td>
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;검색용어
									</td>
									<td class="data_td"  style="display: none;">
										<input type="text" id="SEARCH_KEY" name="SEARCH_KEY" value="" size="30" class="input_re"  onKeyUp="return chkMaxByte(20, this, '검색용어');">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;대표자명
									</td>
									<td class="data_td" colspan="3">
										<input type="text" id="CEO_NAME_LOC" name="CEO_NAME_LOC" value="" size="20" class="input_re"  onKeyUp="return chkMaxByte(20, this, '대표자명');" maxlength="20">
										<input type="hidden" id="CEO_NAME_LOC_O" name="CEO_NAME_LOC_O" value='<%=CEO_NAME_LOC %>'/>
									</td>
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;대표자 생년월일
									</td>
									<td class="data_td" style="display: none;">
										<input type="text" id="RESIDENT_NO1" name="RESIDENT_NO1" value="" size="10" maxlength="6" class=""  onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n"  onKeyUp="return chkMaxByte(200, this, '대표자 생년월일');"  style="width: 90px;ime-mode: disabled;" >
										<input type="hidden" id="RESIDENT_NO2" name="RESIDENT_NO2" value="" size="10" maxlength="7" class=""  onKeyPress="return onlyNumber(event.keyCode);" style="width: 100px;">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;전화번호
									</td>
									<td class="data_td" colspan="3">
										<input type="text" id="PHONE_NO1" name="PHONE_NO1" value="" size="20" class="input_re"  data-dataType="n"  style="ime-mode: disabled;"  maxlength="20" onKeyUp="return chkMaxByte(20, this, '전화번호');" onKeyPress="return onlyNumber(event.keyCode);">
										<input type="hidden" id="PHONE_NO1_O" name="PHONE_NO1_O" value='<%=PHONE_NO1 %>'/> 
										ex.)021234567
									</td>
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;홈페이지
									</td>
									<td class="data_td" style="display: none;">
										<input type="text" id="HOME_URL" name="HOME_URL" value="" size="30" class="inputsubmit"  onKeyUp="return chkMaxByte(50, this, '홈페이지');" maxlength="50" style="ime-mode: disabled;">
									</td>
								</tr>		
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;작성자(사용자대리인) 부서
									</td>
									<td class="data_td">
										<input type="text" id="ENTRY_DEPT_NAME" name="ENTRY_DEPT_NAME" value="" size="20" class="input_re"  onKeyUp="return chkMaxByte(30, this, '작성자부서');" maxlength="30">
										<input type="hidden" id="ENTRY_DEPT_NAME_O" name="ENTRY_DEPT_NAME_O" value='<%=ENTRY_DEPT_NAME %>'/> 
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;작성자(사용자대리인) 성명
									</td>
									<td class="data_td">
										<input type="text" id="ENTRY_USER_NAME" name="ENTRY_USER_NAME" value="" size="30" class="input_re"  onKeyUp="return chkMaxByte(30, this, '작성자성명');" maxlength="30">
										<input type="hidden" id="ENTRY_USER_NAME_O" name="ENTRY_USER_NAME_O" value='<%=ENTRY_USER_NAME %>'/> 
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;작성자(사용자대리인) 연락처
									</td>
									<td class="data_td">
										<input type="text" id="ENTRY_TEL" name="ENTRY_TEL" value="" size="20" class="input_re"  onKeyUp="return chkMaxByte(20, this, '작성자 연락처');" data-dataType="n" style="ime-mode: disabled;" onKeyPress="return onlyNumber(event.keyCode);" maxlength="20">
										<input type="hidden" id="ENTRY_TEL_O" name="ENTRY_TEL_O" value='<%=ENTRY_TEL %>'/> 
										ex.)021234567
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;작성자(사용자대리인) 이메일
									</td>
									<td class="data_td">
										<input type="text" id="ENTRY_EMAIL" name="ENTRY_EMAIL" value="" size="30" class="input_re"  onKeyUp="return chkMaxByte(50, this, ' 작성자 이메일');" style="ime-mode:disabled;" maxlength="50">
										<input type="hidden" id="ENTRY_EMAIL_O" name="ENTRY_EMAIL_O" value='<%=ENTRY_EMAIL %>'/> 
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;본사주소
									</td>
									<td class="data_td" colspan="3">
										<table width="100%" border="0" cellspacing="1" cellpadding="1">
											<tr>
												<td>
													우편번호 <input type="text" id="ZIP_CODE1" name="ZIP_CODE1" value="" size="5" maxlength="5" class="input_re" data-dataType="n" 
													onKeyPress="return onlyNumber(event.keyCode);"  style="ime-mode: disabled;">
													<input type="text" id="ZIP_CODE2" name="ZIP_CODE2" value="" size="4" maxlength="3" style="display:none;" data-dataType="n" readOnly>
													<a href="javascript:SP0274_Popup()">
														<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" style="display:none;">
													</a> 
													<input type="checkbox" id="ckbFg"  onclick="javascript:ckbFg_onclick();" style="display:none;">
												</td>
											</tr>
											<tr>
												<td>
													<input type="text" id="ADDRESS_LOC" name="ADDRESS_LOC" style="width:98%" size="45" class="inputsubmit" onKeyUp="return chkMaxByte(200, this, '본사주소');" maxlength="200">
													<input type="hidden" id="ADDRESS_LOC2" name="ADDRESS_LOC2">
													<input type="hidden" id="HOUSE_NUM1" name="HOUSE_NUM1" value="0">
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;국가
									</td>
									<td class="data_td">
										<select id="COUNTRY" name="COUNTRY" class="inputsubmit" <%=readOnly_flag%> disabled>
											<%=LB_COUNTRY%>
										</select>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;도시
									</td>
									<td class="data_td">
										<select id="city_code" name="city_code" class="inputsubmit" <%=readOnly_flag%>></select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede" style="display: none;"></td>
								</tr>	
								<tr style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;SMS 수신번호
									</td>
									<td class="data_td" colspan="3">
										<input type="text" id="PHONE_NO2" name="PHONE_NO2" value="" size="18" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(20, this, 'SMS 수신번호');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="ime-mode:disabled;" maxlength="20">
										<input type="hidden" id="PHONE_NO2_O" name="PHONE_NO2_O" value='<%=PHONE_NO2 %>'/>  
										ex.)01011112222
									</td>
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;본사 FAX
									</td>
									<td class="data_td" style="display: none;">
										<input type="text" id="FAX_NO" name="FAX_NO" value="" size="11" class="inputsubmit" <%=readOnly_flag%> onKeyUp="return chkMaxByte(20, this, '본사 FAX');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="ime-mode:disabled;" maxlength="20"> 
										ex.)021234567
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								
								<input type="hidden" id="s_template_refitem" 	name="s_template_refitem" 	value="0"> 
								<input type="hidden" id="c_template_refitem" 	name="c_template_refitem" 	value="0"> 
								<input type="hidden" id="isSuccess"				name="isSuccess"			> 
								<input type="hidden" id="sg_refitem" 			name="sg_refitem" 			value="<%=sg_refitem%>"> 
								<input type="hidden" id="vendor_code" 			name="vendor_code" 			value="<%=vendor_code%>"> 
								<input type="hidden" id="status" 				name="status" 				value="<%=status%>"> 
								<input type="hidden" id="buyer_house_code" 		name="buyer_house_code" 	value="<%=buyer_house_code%>">

								<tr style="display: none;">
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;거래구분
									</td>
									<td class="data_td" style="display: none;">상품 
										<input type="checkbox" id="BIZ_CLASS1" name="BIZ_CLASS1" value="" size="30" maxlength="50" <%=readOnly_flag%>>&nbsp; 용역 
										<input type="checkbox" id="BIZ_CLASS2" name="BIZ_CLASS2" value="" size="30" maxlength="50" <%=readOnly_flag%>>&nbsp; 유지보수 
										<input type="checkbox" id="BIZ_CLASS3" name="BIZ_CLASS3" value="" size="30" maxlength="50" <%=readOnly_flag%>>&nbsp; 공사
										<input type="checkbox" id="BIZ_CLASS4" name="BIZ_CLASS4" value="" size="30" maxlength="50" <%=readOnly_flag%>>&nbsp; IT
										<input type="checkbox" id="BIZ_CLASS5" name="BIZ_CLASS5" value="" size="30" maxlength="50" <%=readOnly_flag%>>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;거래은행
									</td>
									<td class="data_td" colspan="3">
										<select id="BANK_KEY" name="BANK_KEY" class="input_re" <%=readOnly_flag%>>
											<%=LB_BANK_KEY%>
										</select>
										<input type="hidden" id="BANK_KEY_O" name="BANK_KEY_O" value='<%=BANK_KEY %>'/>
									</td>
								</tr>
								<tr style="display: none;">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;예금주
									</td>
									<td class="data_td">
										<input type="text" id="DEPOSITOR_NAME" name="DEPOSITOR_NAME" value="" size="20" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(50, this, '예금주');" maxlength="50">
										<input type="hidden" id="DEPOSITOR_NAME_O" name="DEPOSITOR_NAME_O" value='<%=DEPOSITOR_NAME %>'/>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;계좌번호
									</td>
									<td class="data_td">
										<input type="text" id="BANK_ACCT" name="BANK_ACCT" value="" size="20" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(30, this, '계좌번호');" onKeyPress="return onlyNumber(event.keyCode);"  data-dataType="n" maxlength="30" style="ime-mode:disabled;">
										<input type="hidden" id="BANK_ACCT_O" name="BANK_ACCT_O" value='<%=BANK_ACCT %>'/>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								
								<input type="hidden" id="CREDIT_RATING" name="CREDIT_RATING" value="" size="20" maxlength="10" class="inputsubmit" <%=readOnly_flag%>> 
								<input type="hidden" id="CREDIT_DATE" name="CREDIT_DATE" value="" size="10" maxlength="8" class="inputsubmit" <%=readOnly_flag%>>
								
								<tr style="display: none;">
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;본사사업자등록번호
									</td>
									<td class="data_td" colspan="3">
										<input type="text" id="IRS_NO_MAIN1" name="IRS_NO_MAIN1" value="" size="3" maxlength="3" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="width: 60px; ime-mode:disabled;"> 
										- 
										<input type="text" id="IRS_NO_MAIN2" name="IRS_NO_MAIN2" value="" size="2" maxlength="2" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="width: 40px; ime-mode:disabled;"> 
										- 
										<input type="text" id="IRS_NO_MAIN3" name="IRS_NO_MAIN3" value="" size="5" maxlength="5" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="width: 90px; ime-mode:disabled;">
									</td>
									<td class="title_td" style="display: none;" >
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;법인등록번호
									</td>
									<td class="data_td"  style="display: none;">
										<input type="text" id="COMPANY_REG_NO1" name="COMPANY_REG_NO1" value="" size="10" maxlength="6" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="ime-mode:disabled;"> 
										- 
										<input type="text" id="COMPANY_REG_NO2" name="COMPANY_REG_NO2" value="" size="10" maxlength="7" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="ime-mode:disabled;">
										<input type="hidden" id="COMPANY_REG_NO1_O" name="COMPANY_REG_NO1_O" />
										<input type="hidden" id="COMPANY_REG_NO2_O" name="COMPANY_REG_NO2_O" />
									</td>
								</tr>
								<% if (!user_type.equals("SS")) { %>
									<tr style="display: none;">
										<td class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;&nbsp;조정계정
										</td>
										<td class="data_td">
											<input type="hidden" id="AKONT" name="AKONT" size="13" maxlength="22" class="inputsubmit"> 
											<input type="text" id="AKONT_TEXT" name="AKONT_TEXT" size="13" maxlength="22" class="inputsubmit"> 
											<a href="javascript:SP9053_Popup()">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"> 
											</a>
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건</td>
										<td class="data_td">
											<select id="ZTERM" name="ZTERM" class="inputsubmit">
												<option>선택</option>
												<%
												String lb1 = ListBox(request, "SL0018",
												info.getSession("HOUSE_CODE") + "#M352", ZTERM);
												out.println(lb1);
												%>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede" style="display: none;"></td>
									</tr>	
									<tr style="display: none;">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급방법</td>
										<td class="data_td">
											<select id="ZWELS" name="ZWELS" class="inputsubmit">
												<option>선택</option>
												<%
												ZWELS = ListBox(request, "SL0018", house_code + "#M354#", VENDOR_TYPE);
												out.println(ZWELS);
												%>
											</select>
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;은행키</td>
										<td class="data_td">
											<select id="HBKID" name="HBKID" class="inputsubmit">
												<option>선택</option>
												<%
												String lb4 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M353", HBKID);
												out.println(lb4);
												%>
											</select>
										</td>
									</tr>
								<% } else { %>
									<input type="hidden" id="AKONT" name="AKONT" size="13" maxlength="22" class="inputsubmit"> 
									<input type="hidden" id="AKONT_TEXT" name="AKONT_TEXT" size="13" maxlength="22" class="inputsubmit"> 
									<input type="hidden" id="ZTERM" name="ZTERM" class="inputsubmit"> 
									<input type="hidden" id="ZWELS" name="ZWELS" class="inputsubmit"> 
									<input type="hidden" id="HBKID" name="HBKID" class="inputsubmit">
								<% } %>
								<tr>
									<td valign="top" class="title_td" style="vertical-align: middle;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;첨부문서
									</td>
									<td class="data_td" colspan="3">
										<table border="0" cellspacing="2" cellpadding="0">
											<tr>
												<td>
													<b>※원본 스캔하여 파일을 첨부해 주세요.</b><br> ◎법인사업자 - 사업자등록증
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회사소개서						
													<br>
												</td>
												<% if (popup==null||"".equals(popup)||popup.equals("U")||popup.equals("T")) { %>
													<td class="data_td" colspan="3" height="200">
														<script language="javascript">btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일첨부");</script>
													</td>
																					
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="<%=ATTACH_COUNT%>" name="attach_no_count" id="attach_no_count"/>
														<input type="hidden" value="<%=ATTACH_NO%>" name="attach_no" id="attach_no">
														<input type="hidden" value="<%=ATTACH_NO%>" name="att_no" id="att_no">
													</td>					
												<% }else{ %>
													<td width="" class="data_td" colspan="3" >
														<script language="javascript">btn("javascript:fnFiledown(document.getElementById('attach_no').value)", "파일보기")</script>
													</td>
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="<%=ATTACH_COUNT%>" name="attach_no_count" id="attach_no_count"/>
														<input type="hidden" value="<%=ATTACH_NO%>" name="attach_no" id="attach_no">
														<input type="hidden" value="<%=ATTACH_NO%>" name="att_no" id="att_no">
													</td>	
												<% } %>					
											</tr>
										</table>
									</td>
								</tr>
							<% } else { %>
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;승인상태
									</td>
									<td class="data_td" colspan="3">
										<input type="text" id="SIGN_STATUS" name="SIGN_STATUS" value="" size="10" maxlength="20" class="input_data2" readOnly>
										<input type="hidden" id="BP_FLAG" name="BP_FLAG" value="" size="30" maxlength="50" class="inputsubmit" <%=readOnly_flag%>>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
																					
								<% if (SIGN_STATUS.equals("")) { %>
									<tr>
										<td class="title_td">
											아이디(ID)
										</td>
										<td class="data_td">
											<table cellpadding="0">
												<tr>
													<td>
														<input type="text" id="USER_ID" name="USER_ID" size="20" maxlength="20" class="input_re" onKeyUp="return chkMaxByte(20, this, '사용자ID');">
													</td>
													<td><script language="javascript">btn("javascript:goDuplicate()",28,"중복확인")</script></TD>
												</tr>
											</table>
										</td>
										<td class="title_td">
											비밀번호/확인
										</td>
										<td class="data_td">
											<input type="password" id="PASSWORD" name="PASSWORD" size="18" maxlength="20" class="input_re">
											<input type="password" id="CONFIRM_PASSWORD" name="CONFIRM_PASSWORD" size="18" maxlength="20" class="input_re">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
								<% } %>
								<tr>
									<td width="18%" class="title_td">
										회사명
									</td>
									<td width="32%" class="data_td">
										<input type="text" id="VENDOR_NAME_LOC" name="VENDOR_NAME_LOC" value="" size="35" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(50, this, '회사명');">
										<input type="hidden" id="VENDOR_NAME_LOC_O" name="VENDOR_NAME_LOC_O" value='<%=VENDOR_NAME_LOC %>'/>
									</td>
									<td width="18%" class="title_td">
										등록형태
									</td>
									<td width="32%" class="data_td">
										<select id="SOLE_PROPRIETOR_FLAG" name="SOLE_PROPRIETOR_FLAG" class="inputsubmit" onChange="checkSoleProprietorFlag();">
											<option value="1" selected>법인사업자</option>
											<option value="2">개인사업자</option>
											<% if (mode.equals("resident_no")) { %>
												<option value="3">프리랜서</option>
											<% } %>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										내자/외자
									</td>
									<td class="data_td" colspan="3">
										<select id="SHIPPER_TYPE" name="SHIPPER_TYPE" class="input_re">
											<%=LB_SHIPPER_TYPE%>
										</select>(국내업체, 해외업체)
									</td>
									<td class="title_td" style="display: none;">
										<font>파트너종류</font>
									</td>
									<td class="data_td" style="display: none;">
										<select id="VENDOR_TYPE" name="VENDOR_TYPE" class="input_re">
											<%=LB_VENDOR_TYPE%>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;사업자등록번호
									</td>
									<td class="data_td">
										<input type="text" id="IRS_NO1" name="IRS_NO1" value="" size="3" maxlength="3" class="input_re" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);"> 
										- 
										<input type="text" id="IRS_NO2" name="IRS_NO2" value="" size="2" maxlength="2" class="input_re" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);"> 
										- 
										<input type="text" id="IRS_NO3" name="IRS_NO3" value="" size="5" maxlength="5" class="input_re" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);">
										<% if("Y".equals(popup)){ %>
												&nbsp;&nbsp;&nbsp;&nbsp;<a href ="javascript:goCredit('<%=IRS_NO%>')"><img src="/images/btn_nice.gif" style="border:0;" width="90" height="15"></a>
										<%} %>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;이전사업자등록번호
									</td>
									<td class="data_td">
										<input type="text" id="IRS_NO_OLD1" name="IRS_NO_OLD1" value="" size="3" maxlength="3" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" style="width: 60px;" data-dataType="n">- 
										<input type="text" id="IRS_NO_OLD2" name="IRS_NO_OLD2" value="" size="2" maxlength="2" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" style="width: 40px;" data-dataType="n"> - 
										<input type="text" id="IRS_NO_OLD3" name="IRS_NO_OLD3" value="" size="5" maxlength="5" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" style="width: 90px;" data-dataType="n">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 업태
									</td>
									<td class="data_td">
										<input type="text" id="BUSINESS_TYPE" name="BUSINESS_TYPE" value="" size="15" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(100, this, '업태');">
										<input type="hidden" id="BUSINESS_TYPE_O" name="BUSINESS_TYPE_O" value='<%=BUSINESS_TYPE %>'/>
										ex.) 도.소매,서비스 외
									</td>
									<td class="title_td">
										<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 업종
									</td>
									<td class="data_td">
										<input type="text" id="INDUSTRY_TYPE" name="INDUSTRY_TYPE" value="" size="15" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(100, this, '업종');">
										<input type="hidden" id="INDUSTRY_TYPE_O" name="INDUSTRY_TYPE_O" value='<%=INDUSTRY_TYPE %>'/>
										ex.) 소프트웨어개발	외
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;자본금
									</td>
									<td class="data_td">
										<input type="text" id="CAPITAL" name="CAPITAL" value="" size="15" class="input_re" <%=readOnly_flag%>style="ime-mode: disabled;" onKeyPress="checkNumberFormat('[0-9]', this)"> 원
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;종업원 수
									</td>
									<td class="data_td">
										<input type="text" id="EMP_COUNT1" name="EMP_COUNT1" value="" size="7" class="input_re" <%=readOnly_flag%> style="ime-mode: disabled;"	onKeyPress="checkNumberFormat('[0-9]', this)"> (정규직)
										<input type="text" id="EMP_COUNT2" name="EMP_COUNT2" value="" size="7" class="input_re" <%=readOnly_flag%> style="ime-mode: disabled;"	onKeyPress="checkNumberFormat('[0-9]', this)"> (계약직)
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;과세구분
									</td>
									<td class="data_td" colspan="3">
										<select id="TAX_DIV" name="TAX_DIV" class="inputsubmit"
											<%=readOnly_flag%>>
											<%=LB_TAX_KEY%>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;영업개시일
									</td>
									<td class="data_td">
										<s:calendar id="START_DATE" default_value="" format="%Y/%m/%d"/>
										ex.) 20070701
									</td>
									<td class="title_td" style="display: none;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;검색용어
									</td>
									<td class="data_td" style="display: none;">
										<input type="text" id="SEARCH_KEY" name="SEARCH_KEY" value="" size="30" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(20, this, '검색용어');">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;대표자명
									</td>
									<td class="data_td">
										<input type="text"   id="CEO_NAME_LOC"   name="CEO_NAME_LOC"   value="" size="20" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(20, this, '대표자명');">
										<input type="hidden" id="CEO_NAME_LOC_O" name="CEO_NAME_LOC_O" value='<%=CEO_NAME_LOC %>'/>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;홈페이지
									</td>
									<td class="data_td">
										<input type="text" id="HOME_URL" name="HOME_URL" value="" size="30" class="inputsubmit" <%=readOnly_flag%> onKeyUp="return chkMaxByte(50, this, '홈페이지');">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<%-- <tr>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전화번호2</td>
									<td class="data_td" colspan="3">
										<input type="text" id="PHONE_NO1" name="PHONE_NO1" value="" size="20" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(20, this, '대표 전화번호');"  style="ime-mode: disabled;"  onKeyPress="return onlyNumber(event.keyCode);" maxlength="20">
										<input type="hidden" id="PHONE_NO1_O" name="PHONE_NO1_O" value='<%=PHONE_NO1 %>'/> 
										ex.)021234567
									</td>
								
								</tr>	
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr> --%>	
								<tr>
									<td class="title_td">
										본사주소
									</td>
									<td class="data_td" colspan="3">
										<table width="100%" border="0" cellspacing="1" cellpadding="1">
											<tr>
												<td>
													<input type="text" id="ZIP_CODE1" name="ZIP_CODE1" value="" size="4" maxlength="3" class="input_re" readOnly>
													-
													<input type="text" id="ZIP_CODE2" name="ZIP_CODE2" value="" size="4" maxlength="3" class="input_re" readOnly>
													<a href="javascript:SP0274_Popup()"> <img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""> </a>
												</td>
											</tr>
											<tr>
												<td>
													<input type="text"  id="ADDRESS_LOC" name="ADDRESS_LOC" style="width:98%" size="45" class="inputsubmit" <%=readOnly_flag%> onKeyUp="return chkMaxByte(200, this, '본사주소');">
													<input type="hidden" id="ADDRESS_LOC2" name="ADDRESS_LOC2">
													<input type="hidden" id="HOUSE_NUM1" name="HOUSE_NUM1" value="0">
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;국가
									</td>
									<td class="data_td">
										<select id="COUNTRY" name="COUNTRY" class="inputsubmit" <%=readOnly_flag%> disabled>
											<%=LB_COUNTRY%>
										</select>
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;도시
									</td>
									<td class="data_td">
										<input type="text" id="city_code" name="city_code" value="" size="30" class="inputsubmit" readOnly>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;본사 FAX
									</td>
									<td class="data_td">
										<input type="text" id="FAX_NO" name="FAX_NO" value="" size="11" class="inputsubmit" <%=readOnly_flag%> onKeyUp="return chkMaxByte(20, this, '본사 FAX');" onKeyPress="return onlyNumber(event.keyCode);"> 
											ex.)021234567
									</td>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;거래구분
									</td>
									<td class="data_td">
										상품 <input type="checkbox" id="BIZ_CLASS1" name="BIZ_CLASS1" value="" size="30" maxlength="50" class="inputsubmit" <%=readOnly_flag%>>&nbsp; 
										용역 <input type="checkbox" id="BIZ_CLASS2" name="BIZ_CLASS2" value="" size="30" maxlength="50" class="inputsubmit" <%=readOnly_flag%>>&nbsp;
										유지보수 <input type="checkbox" id="BIZ_CLASS3" name="BIZ_CLASS3" value="" size="30" maxlength="50" class="inputsubmit" <%=readOnly_flag%>>&nbsp; 
										공사 <input type="checkbox" id="BIZ_CLASS4" name="BIZ_CLASS4" value="" size="30" maxlength="50" class="inputsubmit" <%=readOnly_flag%>>&nbsp; 
										IT<input type="checkbox" id="BIZ_CLASS5" name="BIZ_CLASS5" value="" size="30" maxlength="50" class="inputsubmit" <%=readOnly_flag%>>
									</td>	
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								
								<input type="hidden" id="s_template_refitem" 	name="s_template_refitem" 	value="0"> 
								<input type="hidden" id="c_template_refitem" 	name="c_template_refitem" 	value="0"> 
								<input type="hidden" id="isSuccess"				name="isSuccess"			> 
								<input type="hidden" id="sg_refitem" 			name="sg_refitem" 			value="<%=sg_refitem%>"> 
								<input type="hidden" id="vendor_code" 			name="vendor_code" 			value="<%=vendor_code%>"> 
								<input type="hidden" id="status" 				name="status" 				value="<%=status%>"> 
								<input type="hidden" id="buyer_house_code" 		name="buyer_house_code" 	value="<%=buyer_house_code%>">
								<input type="hidden" id="CREDIT_RATING" name="CREDIT_RATING" value="" size="20" maxlength="10" class="inputsubmit" <%=readOnly_flag%>> 
								<input type="hidden" id="CREDIT_DATE" name="CREDIT_DATE" value="" size="10" maxlength="8" class="inputsubmit" <%=readOnly_flag%>>
								
								<tr>
									<td class="title_td">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;본사사업자등록번호
									</td>
									<td class="data_td">
										<input type="text" id="IRS_NO_MAIN1" name="IRS_NO_MAIN1" value="" size="3" maxlength="3" class="inputsubmit" <%=readOnly_flag%>	onKeyPress="return onlyNumber(event.keyCode);" style="width: 60px;"> 
										-                                                           
										<input type="text" id="IRS_NO_MAIN2" vname="IRS_NO_MAIN2" alue="" size="2" maxlength="2" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" style="width: 40px;"> 
										-                                                           
										<input type="text" id="IRS_NO_MAIN3" vname="IRS_NO_MAIN3" alue="" size="5" maxlength="5" class="inputsubmit" <%=readOnly_flag%> onKeyPress="return onlyNumber(event.keyCode);" style="width: 90px;">
									</td>
									<td class="title_td">
										<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif"	width="9" height="9">
										법인등록번호
									</td>
									<td class="data_td">
										<input type="text"   id="COMPANY_REG_NO1"		 name="COMPANY_REG_NO1"				value="" size="10" maxlength="6" class="inputsubmit" <%=readOnly_flag%>	onKeyPress="return onlyNumber(event.keyCode);"> 
										-                                                                        
										<input type="text"   id="COMPANY_REG_NO2" 	 name="COMPANY_REG_NO2" 			value="" size="10" maxlength="7"	class="inputsubmit" <%=readOnly_flag%>	onKeyPress="return onlyNumber(event.keyCode);">
										<input type="hidden" id="COMPANY_REG_NO1_O"  name="COMPANY_REG_NO1_O"/>
										<input type="hidden" id="COMPANY_REG_NO2_O"  name="COMPANY_REG_NO2_O"/>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>	
								<% if (!user_type.equals("SS")) { %>
									<tr style="display: none;">
										<td class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;&nbsp;조정계정
										</td>
										<td class="data_td">
											<input type="hidden" id="AKONT" name="AKONT" size="13" maxlength="22" class="inputsubmit"> 
											<input type="text"   id="AKONT_TEXT" name="AKONT_TEXT" size="13" maxlength="22" class="inputsubmit"> 
											<a href="javascript:SP9053_Popup()">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"> 
											</a>
										</td>
										<td class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;&nbsp;지급조건
										</td>
										<td class="data_td">
											<select id="ZTERM" name="ZTERM" class="inputsubmit">
												<option>선택</option>
												<%
												String lb1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M352", ZTERM);
												out.println(lb1);
												%>
											</select>
										</td>
									</tr>
									<tr style="display: none;">
										<td class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;&nbsp;지급방법
										</td>
										<td class="data_td">
											<select id="ZWELS" name="ZWELS" class="inputsubmit">
												<option>선택</option>
												<%
												ZWELS = ListBox(request, "SL0018", house_code + "#M354#", VENDOR_TYPE);
												out.println(ZWELS);
												%>
											</select>
										</td>
										<td class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;&nbsp;은행키
										</td>
										<td class="data_td">
											<select id="HBKID" name="HBKID" class="inputsubmit">
												<option>선택</option>
												<%
												String lb4 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M353", HBKID);
												out.println(lb4);
												%>
											</select>
										</td>
									</tr>
																					
								<% } else { %>
									<input type="hidden" id="AKONT" name="AKONT" size="13" maxlength="22" class="inputsubmit"> 
									<input type="hidden" id="AKONT_TEXT" name="AKONT_TEXT" size="13" maxlength="22" class="inputsubmit"> 
									<input type="hidden" id="ZTERM" name="ZTERM" class="inputsubmit"> 
									<input type="hidden" id="ZWELS" name="ZWELS" class="inputsubmit"> 
									<input type="hidden" id="HBKID" name="HBKID" class="inputsubmit">
								<% } %>
								
								<tr style="display:none;">
									<td valign="top" class="title_td" style="vertical-align: middle;">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;첨부문서
									</td>
									<td class="data_td" colspan="3">
										<table border="1" cellspacing="0" cellpadding="0">
											<tr>
												<td>
													<b>※원본 스캔하여 파일을 첨부해 주세요.</b><br> ◎법인사업자 - 사업자등록증
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사용인감계
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;법인인감증명서
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;통장사본
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회사소개서						
													<br> <br>◎개인사업자 - 사업자등록증 
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;인감증명서
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;통장사본
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회사소개서
												</td>
												
												<% if (popup==null||"".equals(popup)||popup.equals("U")||popup.equals("T")) { %>
													<td class="data_td" colspan="3" height="200">
														<table>
															<tr>
																<td>
																	<script language="javascript">
																		btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일첨부");
																	</script>
																</td>
																<td>
																	<input type="text" size="3" readOnly class="input_empty" value="<%=ATTACH_COUNT%>" name="attach_no_count" id="attach_no_count"/>
																	<input type="hidden" value="<%=ATTACH_NO%>" name="attach_no" id="attach_no">
																</td>
															</tr>
														</table>
													</td>	
												<% }else{ %>
													<td width="" class="data_td" colspan="3" >
														<script language="javascript">btn("javascript:fnFiledown(document.getElementById('attach_no').value)", "파일보기")</script>
														<input type="text" size="3" readOnly class="input_empty" value="<%=ATTACH_COUNT%>" name="attach_no_count" id="attach_no_count"/>
														<input type="hidden" value="<%=ATTACH_NO%>" name="attach_no" id="attach_no">
													</td>
												<% } %>						
																					
												<br>&nbsp;
												
											</tr>
										</table>
									</td>
								</tr>
							<% } %>	
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>	


<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30" align="right">
			<table cellpadding="0">
				<tr>
					<% if (popup==null||"".equals(popup)||popup.equals("U")||popup.equals("T")) { %>
						<td><script language="javascript">btn("javascript:doSave();","저 장")</script></TD>
						<td><script language="javascript">btn("javascript:doClose();", "닫 기")</script></TD>
					<% } %>
				</tr>
			</table>
		</td>
	</tr>
</table>
																					
</form>

<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

</body>
</html>
