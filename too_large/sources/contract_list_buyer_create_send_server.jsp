<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page buffer="16kb" %>
<%@ page import="xecure.servlet.*" %>
<%@ page import="xecure.crypto.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
	String aCharset = "UTF-8";

	String msg = "";
	String err = "";
	Vector multilang_id = new Vector();
	multilang_id.addElement("CTS_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MASSAGE");
	
	HashMap text = MessageUtil.getMessage(info, multilang_id);


	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	
	String CONT_DESC		= "";
	String CONT_CONTENT     = "";
	SepoaOut value1         = null;
	SepoaOut value2         = null;
	
	
	String cont_no		    = JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq	    = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String save_flag	    = JSPUtil.nullToEmpty(request.getParameter("save_flag"));
	String seller_code_old	= JSPUtil.nullToEmpty(request.getParameter("seller_code"));
	String cont_date_old	= JSPUtil.nullToEmpty(request.getParameter("cont_date"));
	String ct_flag			= JSPUtil.nullToEmpty(request.getParameter("ct_flag"));
	String exec_no			= JSPUtil.nullToEmpty(request.getParameter("exec_no"));

	String stamp_tax_no		= JSPUtil.nullToEmpty(request.getParameter("stamp_tax_no"));
	String stamp_tax_amt	= JSPUtil.nullToEmpty(request.getParameter("stamp_tax_amt"));
	
	
	Object[] obj = {cont_no, cont_gl_seq, "C"};
	
	SepoaOut value	= null;
//	SepoaFormater wf1 = null;
//	SepoaFormater wf11 = null;
	
	String SELLER_SIGN = "";
	String BUYER_SIGN = "";
	
	

	/* MultiSign */
	Signer signer = null;
	MultiSignVerifier mverifier= null;
    String aMultiSignedData = "";
	String aMultiSignedData2 = "";
	String aMDN1 = "";
	String aMDN2 = "";
	
	XecureConfig aXecureConfig = new XecureConfig ();
	
	try{
		value = ServiceConnector.doService(info, "CTS_001", "CONNECTION", "getContractTotalSelect", obj);
/* 		
        wf1  = new SepoaFormater(value.result[0]); // CLOB
		wf11 = new SepoaFormater(value.result[1]); // DATA
		
		
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
 */		
        //CONT_CONTENT = new String(CONT_CONTENT.getBytes("UTF-8"));
		
		
		SepoaFormater wf99999 = new SepoaFormater(value.result[2]);
		
		if( wf99999.getRowCount() > 0 ){
			SELLER_SIGN = wf99999.getValue("SELLER_SIGN", 0);
//			Logger.sys.println("############## SELLER_SIGN = " + SELLER_SIGN);
		}
		
		String SELLER_SIGN1 = new String(SELLER_SIGN);
		
		
		//verifier = new SignVerifier (aXecureConfig , aResult, aCharset, 1);
		
		//signer = new Signer(aXecureConfig, "utf-8");
		signer = new Signer(aXecureConfig);
		
//2. 우리은행서명시 업체서명값을 aResult 넣어 우리은행서명하는 방법
        
		// 사용자 인증서로 생성된 전자서명문에 서버인증서로 전자서명. aResult 값은 원본 전자서명문
		aMultiSignedData = signer.MultiSignMessage(SELLER_SIGN1);
		//aMultiSignedData2 = signer.MultiSignMessage_CMS(aResult);

		
		// 멀티 전자서명문 검증. 파라미터는 XecureConf 설정파일과 멀티서명문
		mverifier = new MultiSignVerifier(aXecureConfig, aMultiSignedData);
		
		// 서명횟수
//		aNumberSign = mverifier.getNumberOfSigner();
		
		// 사용자 인증서
		aMDN1 = mverifier.getSignerSubject(0);
		Logger.sys.println("############## aMDN1 = " + aMDN1);
		
		// 서버인증서
        aMDN2 = mverifier.getSignerSubject(1);
		Logger.sys.println("############## aMDN2 = " + aMDN2);
		
		
	}catch(Exception e){
		//e.printStackTrace();
		err = e.getMessage();
	}
	

	
	try{
	

	
		Map<String, String> setParams = new HashMap<String, String>();
		
		setParams.put("house_code"	, info.getSession("HOUSE_CODE"));
		setParams.put("exec_no"		, exec_no);
		
		Object[] obj2 = {setParams};
		
		if (mverifier.getLastError() != 0)
		{
			msg = mverifier.getLastErrorMsg();
			err = mverifier.getLastErrorMsg();
			Logger.sys.println(mverifier.getLastErrorMsg());
		}
		else
		{
			Object[] obj3 = {cont_no, cont_gl_seq, stamp_tax_no, stamp_tax_amt, aMultiSignedData, aMDN2}; //추가수정_20171127
	 		value1 = ServiceConnector.doService(info, "CTS_001", "TRANSACTION", "getContractSignBuyer", obj3);
	
			if(value1.flag == true){
				if(!"".equals(exec_no)){
					value2 = ServiceConnector.doService(info, "CTS_001", "TRANSACTION", "createInfoData", obj2);
					
					if(value2.flag == true){
						msg = "우리은행인증서로 서명하셨습니다."; 
					}else{
						msg = "우리은행인증서로 서명 실패하였습니다.";
						err = "우리은행인증서로 서명 실패하였습니다.";
					}
				}else{
					msg = "우리은행인증서로 서명하셨습니다."; 				
				}
			}else{
				msg = "우리은행인증서로 서명 실패하였습니다.";
				err = "우리은행인증서로 서명 실패하였습니다.";
			}
			
		}
	
	}//end of try
	catch(Throwable e)
	{
 		//e.printStackTrace();
		String ret = e.getMessage();
		//out.print("에러 : " + ret);
		Logger.err.println(ret);
		msg = "에러 : " + ret;
		err = e.getMessage();
	}

 %>
<html>
<head>
<Script language="javascript">
function Init()
{
	
	<%if( !"".equals(err) ){%>
        alert("<%=msg%>");
	<%}else{%>	
		alert("<%=msg%>");
		parent.location.href = "contract_list.jsp";
	<%}%>

}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
<form name="form">
</form>
</html>
