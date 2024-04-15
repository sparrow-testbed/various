<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page buffer="16kb" %>
<%@ page import="xecure.servlet.*" %>
<%@ page import="xecure.crypto.*" %>
<%@ page import="java.io.*" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<% 
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
	String aCharset = "UTF-8";
    
	Vector multilang_id = new Vector();
	multilang_id.addElement("CTS_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	SepoaOut value = null;
	String message =  "";

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	
	String cont_no		= JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq  = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String sign_key	    = JSPUtil.nullToEmpty(request.getParameter("sign_key"));
	//String sign_name	= JSPUtil.nullToEmpty(request.getParameter("sign_name"));
	String sign_name	=  "";
	String sign_encode	= JSPUtil.nullToEmpty(request.getParameter("sign_encode"));
	//�߰�����_20171127
	//String seller_sign	= JSPUtil.nullToEmpty(request.getParameter("seller_sign"));
	
	String save_flag	= JSPUtil.nullToEmpty(request.getParameter("save_flag"));
	String ct_flag	= JSPUtil.nullToEmpty(request.getParameter("ct_flag"));
	String cont_dd_flag	= JSPUtil.nullToEmpty(request.getParameter("cont_dd_flag"));
	String fault_dd_flag	= JSPUtil.nullToEmpty(request.getParameter("fault_dd_flag"));
	String vendor_in_attach_no	= JSPUtil.nullToEmpty(request.getParameter("vendor_in_attach_no"));
	
//	Logger.sys.println("############## vendor_in_attach_no = " + vendor_in_attach_no);

	String stamp_tax_no	= JSPUtil.nullToEmpty(request.getParameter("stamp_tax_no"));
	String stamp_tax_amt	= JSPUtil.nullToEmpty(request.getParameter("stamp_tax_amt"));
	
	
	
	
	String aResult	= JSPUtil.nullToEmpty(request.getParameter("signed_msg"));
	String aRequestPlain = JSPUtil.nullToEmpty(request.getParameter("plain"));
	
	XecureConfig aXecureConfig = new XecureConfig ();
	SignVerifier	verifier = null;
	
	int aErrCode = 0;
	String aErrReason = "";
	String aPlain = "";
	String aPlainHex = "";
	String aCertificate = "";
	String aSubjectRDN = "";
	String aPolicy = "";
		
	SplitSign aSplitSign = new SplitSign(aXecureConfig);
	
	String aIssuser = "";
		
	if (aResult == null || aResult.equals(""))
	{
		aErrCode = -1;
		aErrReason = "invalid parameter";
	}
	else if (aResult.length() < 10)
	{
		aErrCode = -1;
		aErrReason = "invalid parameter (short)";
	}
	else
	{
// 		if (aResult.substring(0, 4).equalsIgnoreCase("3082"))
//		{
//			/* Hex encoded Data */
//			verifier = new SignVerifier (aXecureConfig , aResult, aCharset, 0);
//		}
//		else
//		{
//			/* Base64 encoded Data */
//			verifier = new SignVerifier (aXecureConfig , aResult, aCharset, 1);
//		}
 		
 		if (aResult.substring(0, 4).equalsIgnoreCase("3082"))
		{
			/* Hex encoded Data */
			verifier = new SignVerifier (aXecureConfig , aResult, aCharset, 0);
		}
		else
		{
			/* Base64 encoded Data */
			verifier = new SignVerifier (aXecureConfig , aResult, aCharset, 1);
		}

	
		if (verifier.getLastError() != 0)
		{
			aErrCode = verifier.getLastError();
			aErrReason = verifier.getLastErrorMsg();
		}
		else
		{
			//Logger.sys.println("saver - 1" );
			aPlain = verifier.getVerifiedMsg_Text();
			aCertificate = verifier.getSignerCertificate().getCertPem().replaceAll ("\n", "");
			aSubjectRDN = verifier.getSignerCertificate().getSubject();
			sign_name = verifier.getSignerCertificate().getSubject("o"); 
			aPolicy = verifier.getSignerCertificate().getPolicy();
			aIssuser = verifier.getSignerCertificate().getIssuer();  
			
			byte[] buf = verifier.getVerifiedMsg();
			String tmp = "";
			
			//Logger.sys.println("saver - 2" );
			/*
			for (int i = 0; i < buf.length; i++)
			{
				tmp = Integer.toHexString(0xFF & buf[i]);
				if (tmp.length() == 1) tmp = "0" + tmp;
				aPlainHex += tmp;
			}
			*/
			aPlainHex = " ";
			//Logger.sys.println("saver - 3" );
			
			
//AnySign 솔루션으로 교체
//			Object[] obj = {cont_no, sign_key, sign_name, sign_encode, save_flag, ct_flag, cont_dd_flag, fault_dd_flag, vendor_in_attach_no, cont_gl_seq, stamp_tax_no, stamp_tax_amt, seller_sign};			
			Object[] obj = {cont_no, sign_key, sign_name, sign_encode, save_flag, ct_flag, cont_dd_flag, fault_dd_flag, vendor_in_attach_no, cont_gl_seq, stamp_tax_no, stamp_tax_amt,
					        aPlain, aPlainHex, aSubjectRDN, aPolicy, aCertificate, aResult, aIssuser };	
			//Logger.sys.println("saver - 4" );
			value = ServiceConnector.doService(info, "CTS_001", "TRANSACTION", "getContractSign", obj);		    
			//Logger.sys.println("saver - 5" );
			message =  value.message;
		}
	}
	
	
/* 
	Logger.sys.println("############## 오류 코드         = " + aErrCode);
	Logger.sys.println("############## 오류 메세지        = " + aErrReason);
	Logger.sys.println("############## 서명 원문         = " + aPlain);
	Logger.sys.println("############## 서명 원문(Hex)    = " + aPlainHex);
	Logger.sys.println("############## 서명 인증서 주체     = " + aSubjectRDN);
	Logger.sys.println("############## Policy 정책 값   = " + aPolicy);
	Logger.sys.println("############## 서명 인증서        = " + aCertificate);
	Logger.sys.println("############## 원본 서명문        = " + aResult);
	Logger.sys.println("############## 발급자 정보        = " + aIssuser);
*/	

%>

<html>
<head>
<SCRIPT language=javascript src="../include/attestation/TSToolkitConfig.js"></script>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>

<Script language="javascript">
function Init()
{
	<% if (verifier.getLastError() != 0){ %>	
			alert("<%=verifier.getLastErrorMsg()%>");
	<% }else{ %>	
			if("<%=value.status%>" == "1")
			{
				alert("<%=text.get("MESSAGE.0001")%>");
				if("<%=ct_flag%>" == "CC"){
					parent.location.href = "contract_list_seller.jsp";
				}else{
					parent.location.href = "contract_list_seller_info.jsp";
				}
			}else{ 
				alert("<%=message%>"); 			
			}
	<% } %>	
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>
