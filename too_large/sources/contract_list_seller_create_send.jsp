<%@page import="org.apache.commons.collections.MapUtils"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- AnySign 솔루션으로 교체 
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.pki.pkix.SignedData" %> 
<%@ page import="tradesign.pki.pkix.X509Certificate" %> 
<%@ page import="tradesign.pki.pkix.*" %> 
<%@ page import="tradesign.pki.util.JetsUtil" %>
<%@ page import="tradesign.crypto.cert.validator.*" %>

<%@ page import="tradesign.crypto.cert.validator.ExtendedPKIXParameters" %>
<%@ page import="tradesign.crypto.cert.validator.PKIXCertPath" %>
--%>
<%@ page import="java.io.*"%>
<%@ page import="java.security.*"%>
<%@ page import="java.security.cert.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*" %>

<% 
	Vector multilang_id = new Vector();
	multilang_id.addElement("CTS_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MASSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String irs_no	= info.getSession("IRS_NO");
	
	String user_name = info.getSession("NAME_LOC");
	String id = info.getSession("ID");
	String to_day = SepoaDate.getShortDateString();
	
	String CONT_DESC		= "";
	String CONT_CONTENT     = "";

	String cont_no	    		= JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq  		= JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String cont_form_no 		= JSPUtil.nullToEmpty(request.getParameter("cont_form_no"));
	String se_attach_no			= JSPUtil.nullToEmpty(request.getParameter("se_attach_no"));
	String save_flag    		= JSPUtil.nullToEmpty(request.getParameter("save_flag"));
	String vendor_in_attach_no	= JSPUtil.nullToEmpty(request.getParameter("vendor_in_attach_no"));
	String ct_flag    			= JSPUtil.nullToEmpty(request.getParameter("ct_flag"));
	String cont_dd_flag    		= JSPUtil.nullToEmpty(request.getParameter("cont_dd_flag"));
	String fault_dd_flag    	= JSPUtil.nullToEmpty(request.getParameter("fault_dd_flag")); 
	String stamp_tax_no    		= JSPUtil.nullToEmpty(request.getParameter("stamp_tax_no")); 
	String stamp_tax_amt    	= JSPUtil.nullToEmpty(request.getParameter("stamp_tax_amt")); 

	Object[] obj = { cont_no, cont_gl_seq };
	SepoaOut value  = ServiceConnector.doService(info, "CTS_001", "CONNECTION",  "getContractTotalSelect", obj);
	SepoaFormater wf1  = new SepoaFormater(value.result[0]); // CLOB
	SepoaFormater wf11 = new SepoaFormater(value.result[1]); // DATA
	
	for(int i = 0; i < wf1.getRowCount(); i++)
	{
		CONT_CONTENT += wf1.getValue("CONTENT", i);
	}

	for(int i = 0; i < wf11.getRowCount(); i++)
	{
		CONT_CONTENT += wf11.getValue("CONTENT", i);
	}
	
	CONT_CONTENT = CONT_CONTENT.replaceAll("\"", "");
	CONT_CONTENT = CONT_CONTENT.replaceAll("\r\n", "");
	//CONT_CONTENT = new String(CONT_CONTENT.getBytes("UTF-8"));
	
	Logger.sys.println(">>>>>>> CONT_CONTENT = " + CONT_CONTENT);
	Logger.sys.println(">>>>>>> CONT_CONTENT.LENGTH() = " + CONT_CONTENT.length());
	
	Object[] obj1 = { id }; // ICOMVNGL  업체일반 정보에서  인증서 키값 인증서발급기관 가져오기
	//SepoaOut value1  = ServiceConnector.doService(info, "CTS_001", "CONNECTION",  "getContractApproval", obj1); 
	//SepoaFormater wf2 = new SepoaFormater(value1.result[0]);
	
	String sign_value	= "";//wf2.getValue("SIGN_VALUE", 0);
	String sign_name	= "";//wf2.getValue("SIGN_NAME", 0);
	
	////////////////////////////////////////////////////////////////////
	
	String data = new String(CONT_CONTENT);
	
// 	JeTS.installProvider("D:/util/TradeSign_1414S/tradesign3280.properties");
//  	JeTS.installProvider("D:/workspace/Poa-SRM-WOORI/poasrm/WebContent/contract/TSToolKit/tradesignlocal.properties");
	/* //AnySign 솔루션으로 교체 
	JeTS.installProvider(CommonUtil.getConfig("sepoa.tradesign.path"));
	
	Logger.sys.println("MessageDigest start");
	java.security.MessageDigest md = java.security.MessageDigest.getInstance("HAS160", "JeTS");
	Logger.sys.println("MessageDigest end");
	
	byte[] result = md.digest(data.getBytes());
	String HashStr = new String(JetsUtil.encodeBase64(result));
	String Strb64_enc = "";
	
	byte[] b64_enc = JetsUtil.encodeBase64(HashStr.getBytes());
	
	// Base64 인코딩 데이타
	Strb64_enc = new String(b64_enc);
	Logger.sys.println(">>>>>>> Strb64_enc = " + Strb64_enc); */
	///////////////////////////////////////////////////////////////////////////////	
 	String Strb64_enc = "";
%>

<html>
<head>
<%-- AnySign 솔루션으로 교체
<SCRIPT language=javascript src="../include/attestation/TSToolkitConfig.js"></script>
--%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>

<%-- AnySign 솔루션으로 교체
<Script language="javascript">
function Init_bak()
{
	var signMsg;
	var nRet, certdn, storage;
	
	// 서명할 문자열 데이타 설정.
	var cont_no		= "<%=cont_no%>";
	var save_flag	= "<%=save_flag%>";
	var ct_flag		= "<%=ct_flag%>";
	var cont_dd_flag	= "<%=cont_dd_flag%>";
	var fault_dd_flag	= "<%=fault_dd_flag%>";

	// 모든 Condition 설정.
	nRet = TSToolkit.SetConfig("", CA_LDAP_INFO, CTL_INFO, POLICIES, 
							INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
							USING_CRL_CHECK, USING_ARL_CHECK);
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
 		//return;
		//전자승인처리 강제승인
	}
	

	// 사용자가 자신의 인증서를 선택. 
	nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
	if (nRet > 0)
	{
		alert("SelectCertificate : " + TSToolkit.GetErrorMessage());
 		//return;
		//전자승인처리 강제승인
	}
	nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
	if (nRet > 0)
	{
		alert("GetCertificate : " + TSToolkit.GetErrorMessage());
 		//return;
		//전자승인처리 강제승인
	}
	
	var cert;
	cert = TSToolkit.OutData;
	
	nRet = TSToolkit.CertificateValidation(cert);
	if (nRet > 0)
	{
		if (nRet == 141)
		{
			var revokedTime;
			revokedTime = TSToolkit.OutData;
			alert("선택한 인증서는 폐기 및 손상된 인증서 입니다. \n인증센터에서 인증서를 발급 받으십시오.");
	 		//return;
			//전자승인처리 강제승인
		}
		
	}

	
	nRet = TSToolkit.VerifyVID("<%=irs_no%>");
		
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
	 		//return;
			//전자승인처리 강제승인			
		}
		if (TSToolkit.OutData != "true")
		{
			alert("해당 사업자번호와 인증서의 사업자번호가 일치하지 않습니다.");
	 		//return;
			//전자승인처리 강제승인
		}
	
		
	
	//고유한 인증서 값을 가져 온다..
	var str;
	TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_SUBJECT_KEY_ID);
	str = TSToolkit.OutData;
	var str_value = str;
	document.form.sign_key.value   = str;

	nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
	if (nRet > 0)
	{
		alert("GetCertificate : " + TSToolkit.GetErrorMessage());
 		//return false;
		//전자승인처리 강제승인
	}
	
	var cert;
	cert = TSToolkit.OutData

	//var sign_value;
	TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_CRLDP);
	
	str = TSToolkit.OutData;
	
	
	
// 	signName = str.substring(str.indexOf(",o=")+3, str.indexOf(",c="));
	signName = "test1111";
	
	document.form.cont_no.value		= cont_no;//계약번호
	document.form.sign_name.value	= signName;//인증서발급기관
	document.form.sign_encode.value	= "<%=Strb64_enc%>";
	document.form.save_flag.value	= save_flag;
	document.form.ct_flag.value     =  ct_flag;
	document.form.cont_dd_flag.value	= cont_dd_flag;
	document.form.fault_dd_flag.value	= fault_dd_flag;
	
	var aaa = "<%=sign_value%>";
	var bbb = "<%=sign_name%>";
	
// 	if( aaa == str_value && bbb == signName){  // signName , str  비교    DB에서 가져와서
	if( true ){  // signName , str  비교    DB에서 가져와서
		document.form.method = "POST";
		document.form.target = "childFrame";
		document.form.action = "contract_list_seller_create_send_save.jsp";
		document.form.submit();
	
	}else{
		alert("선택한 인증서가 업체 등록 인증서와 일치 하지 않습니다.");
		return;
	}
	
}

function Init(){
	
	var signMsg = "";
	var nRet    = "";
	var certdn  = "";
	var storage = "";
	if("<%=sign_value %>" == ""){
		//alert("업체등록 화면에서 인증서를 등록해주세요.");
		//return;
	}

	if("<%=sign_name %>" == ""){
		//alert("업체등록 화면에서 인증서를 등록해주세요.");
		//return;
	}
	
	// 모든 Condition 설정. POLICIES >> POLICIES1로 셋팅시 법인용 인증서만 보인다.
	nRet = TSToolkit.SetConfig("", CA_LDAP_INFO, CTL_INFO, POLICIES1, INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN, USING_CRL_CHECK, USING_ARL_CHECK); 
	if (nRet > 0) {	alert(nRet + " : " + TSToolkit.GetErrorMessage());return;}

	// 사용자가 자신의 인증서를 선택. 
	nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
	if (nRet > 0) { alert("SelectCertificate : " + TSToolkit.GetErrorMessage()); return; } 
	nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
	if (nRet > 0) { alert("GetCertificate : " + TSToolkit.GetErrorMessage());return; }
	
	var cert;
	cert = TSToolkit.OutData;
	nRet = TSToolkit.CertificateValidation(cert);
	if (nRet > 0) {		
		alert(nRet + " : " + TSToolkit.GetErrorMessage());		
		if (nRet == 141) {
			var revokedTime;
			revokedTime = TSToolkit.OutData;
			alert("선택한 인증서는 폐기 및 손상된 인증서 입니다. \n인증센터에서 인증서를 발급 받으십시오.");
			return;
		}
		return;		
	}
	
	nRet = TSToolkit.VerifyVID("<%=irs_no %>");//.replaceAll ( "-" , "" ).trim (  )
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	 
	if (TSToolkit.OutData != "true")
	{
		//alert("발급된 인증서의 사업자번호와 계약서의 사업자번호가 다릅니다.");
		//return false;
	}
	
	//고유한 인증서 값을 가져 온다..
	var str;
	TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_SUBJECT_KEY_ID); 
	str = TSToolkit.OutData; 
	var str_value = str;
	document.form.sign_key.value   = str;
	nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
	if (nRet > 0) {	alert("GetCertificate : " + TSToolkit.GetErrorMessage());return false;	}
	var cert;
	cert = TSToolkit.OutData;
	
	TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_CRLDP);
	str = TSToolkit.OutData;
	
	var signValue = str.substring(str.indexOf(",o=")+3, str.indexOf(",c="));
	document.form.sign_value.value   = signValue; 	
	
	signName = signValue;
	
	//추가수정_20171127
	nRet = TSToolkit.SignData("<%=data%>");
	if (nRet > 0) {
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	document.form.seller_sign.value = TSToolkit.OutData;
	
	var cont_no			= "<%=cont_no%>";
	var save_flag		= "<%=save_flag%>";
	var ct_flag			= "<%=ct_flag%>";
	var cont_dd_flag	= "<%=cont_dd_flag%>";
	var fault_dd_flag	= "<%=fault_dd_flag%>";
	
	document.form.cont_no.value			= cont_no;//계약번호
	document.form.sign_name.value		= signName;//인증서발급기관
	document.form.sign_encode.value		= "<%=Strb64_enc%>";
	document.form.save_flag.value		= save_flag;
	document.form.ct_flag.value     	= ct_flag;
	document.form.cont_dd_flag.value	= cont_dd_flag;
	document.form.fault_dd_flag.value	= fault_dd_flag;
	
	var aaa = "<%=sign_value%>";
	var bbb = "<%=sign_name%>";
	
// 	if( aaa == str_value && bbb == signName){  // signName , str  비교    DB에서 가져와서
	if( true ){  // signName , str  비교    DB에서 가져와서
		document.form.method = "POST";
		document.form.target = "childFrame";
		document.form.action = "contract_list_seller_create_send_save.jsp";
		document.form.submit();
	
	}else{
		alert("선택한 인증서가 업체 등록 인증서와 일치 하지 않습니다.");
		return;
	}	
}
--%>

</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
<%-- AnySign 솔루션으로 교체
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
--%>
</body>
<form name="form">
<input type="hidden" id="cont_no"     	name="cont_no"     	vaue="<%=cont_no%>">
<input type="hidden" id="cont_gl_seq" 	name="cont_gl_seq" 	value="<%=cont_gl_seq%>">
<input type="hidden" id="sign_key"		name="sign_key"		>
<input type="hidden" id="sign_name"		name="sign_name"	>
<input type="hidden" id="sign_encode"	name="sign_encode"	>
<input type="hidden" id="save_flag"		name="save_flag"	> 
<input type="hidden" id="ct_flag"		name="ct_flag"		> 
<input type="hidden" id="cont_dd_flag"	name="cont_dd_flag"	> 
<input type="hidden" id="fault_dd_flag"	name="fault_dd_flag"> 
<input type="hidden" id="sign_value"	name="sign_value"> 
<input type="hidden" id="seller_sign"	name="seller_sign">  //추가수정_20171127
<input type="hidden" id="stamp_tax_no"	name="stamp_tax_no" value="<%=stamp_tax_no%>"> 
<input type="hidden" id="stamp_tax_amt"	name="stamp_tax_amt"value="<%=stamp_tax_amt%>"> 
<input type="hidden" id="vendor_in_attach_no" name="vendor_in_attach_no" value="<%=vendor_in_attach_no%>">
</form>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>