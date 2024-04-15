<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_contract_detail_print"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MASSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	
	String CONT_NO				= "";
	String CONT_GL_SEQ          = "";  
	String SUBJECT				= "";
	String CONT_GUBUN      		= "";
	String PROPERTY_YN			= "";
	String SELLER_CODE			= "";
	String SELLER_NAME			= "";
	String SIGN_PERSON_ID		= "";
	String SIGN_PERSON_NAME		= "";
	String CONT_FROM			= "";
	String CONT_TO				= "";
	String CONT_DATE			= "";
	String CONT_ADD_DATE		= "";
	String CONT_TYPE			= "";
	String ELE_CONT_FLAG		= "";
	String ASSURE_FLAG			= "";
	String START_START_INS_FLAG	= "";
	String CONT_PROCESS_FLAG	= "";
	String CONT_AMT				= "";
	String CONT_ASSURE_PERCENT	= "";
	String CONT_ASSURE_AMT		= "";
	String FAULT_INS_PERCENT	= "";
	String FAULT_INS_AMT		= "";
	String PAY_DIV_FLAG			= "";
	String FAULT_INS_TERM		= "";
	String BD_NO				= "";
	String BD_COUNT				= "";
	String AMT_GUBUN			= "";
	String TEXT_NUMBER			= "";
	String DELAY_CHARGE			= "";
	String DELV_PLACE			= "";
	String REMARK				= "";
	String CTRL_DEMAND_DEPT		= "";
	String CT_FLAG_TEXT			= "";	
	String CT_FLAG				= "";	
	String CTRL_CODE			= "";
	String COMPANY_CODE			= "";
	String RFQ_TYPE				= "";
	String REJECT_REASON		= "";
	
	String ACCOUNT_CODE			= "";
	String ACCOUNT_NAME			= "";
	
	
	String CONT_TYPE1_TEXT      = "";
	String CONT_TYPE2_TEXT      = "";


	String SG_LEV1				= "";
	String SG_LEV2				= "";
	String SG_LEV3				= "";
	String ADD_TAX_FLAG			= "";
	String ITEM_TYPE			= "";
	String RD_DATE				= "";
	String CONT_TOTAL_GUBUN		= "";
	String CONT_PRICE			= "";
	
	String EXEC_NO				= "";
	
	String SG_LEV1_TEXT             = "";
	String SG_LEV2_TEXT             = "";
	String SG_LEV3_TEXT             = "";
	String CONT_PROCESS_FLAG_TEXT   = "";
	String CONT_TYPE1_TEXT_TEXT	    = "";
	String CONT_TYPE2_TEXT_TEXT     = "";
	String ELE_CONT_FLAG_TEXT       = "";
	String CONT_TYPE_TEXT           = "";
	String ASSURE_FLAG_TEXT         = "";
	String CONT_TOTAL_GUBUN_TEXT    = "";
	
	String CONT_DESC		= "";
	String CHANGE_USER_ID	= "";
	String CONT_CONTENT     = "";
	
	String cont_no	    = JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq  = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String cont_form_no	= JSPUtil.nullToEmpty(request.getParameter("cont_form_no"));
	String flag	        = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String ct_flag      = JSPUtil.nullToEmpty(request.getParameter("ct_flag"));
	
	String contractstatus	= "";

	if ("".equals(cont_no) || "GET".equals(request.getMethod())) {
		%>
		<script>
			alert("잘못된 접근방법을 사용하였습니다.");
			sessionCloseF("/errorPage/no_autho_en.jsp?flag=e1");
		</script>
		<%
	}
	
	Object[] obj0 = {cont_no, cont_gl_seq};
	SepoaOut value0 = ServiceConnector.doService(info, "CT_020", "TRANSACTION","getContractUpdateSelect", obj0);
	SepoaFormater wf  = new SepoaFormater(value0.result[0]);
	//DB에서 받아올값들 초기화
    if(wf.getRowCount() > 0) {
    	CONT_NO					= JSPUtil.nullToEmpty(wf.getValue("CONT_NO",				0));
    	CONT_GL_SEQ				= JSPUtil.nullToEmpty(wf.getValue("CONT_GL_SEQ",			0));
    	SUBJECT					= JSPUtil.nullToEmpty(wf.getValue("SUBJECT",				0));
//    	CONT_GUBUN     			= JSPUtil.nullToEmpty(wf.getValue("CONT_GUBUN",				0));
    	PROPERTY_YN				= JSPUtil.nullToEmpty(wf.getValue("PROPERTY_YN",			0));
    	
    	
    	ACCOUNT_CODE			= JSPUtil.nullToEmpty(wf.getValue("ACCOUNT_CODE",			0));
    	ACCOUNT_NAME			= JSPUtil.nullToEmpty(wf.getValue("ACCOUNT_NAME",			0));
    	
    	SELLER_CODE				= JSPUtil.nullToEmpty(wf.getValue("SELLER_CODE",			0));
    	
    	SELLER_NAME				= JSPUtil.nullToEmpty(wf.getValue("SELLER_NAME",			0));
    	SIGN_PERSON_ID			= JSPUtil.nullToEmpty(wf.getValue("SIGN_PERSON_ID",			0));
    	SIGN_PERSON_NAME		= JSPUtil.nullToEmpty(wf.getValue("SIGN_PERSON_NAME",		0));
    	CONT_FROM				= JSPUtil.nullToEmpty(wf.getValue("CONT_FROM",				0));
    	CONT_TO					= JSPUtil.nullToEmpty(wf.getValue("CONT_TO",				0));
    	
    	CONT_DATE				= JSPUtil.nullToEmpty(wf.getValue("CONT_DATE",				0));
    	CONT_ADD_DATE			= JSPUtil.nullToEmpty(wf.getValue("CONT_ADD_DATE",			0));
    	CONT_TYPE				= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE",				0));
    	ELE_CONT_FLAG			= JSPUtil.nullToEmpty(wf.getValue("ELE_CONT_FLAG",			0));
    	ASSURE_FLAG				= JSPUtil.nullToEmpty(wf.getValue("ASSURE_FLAG",			0));
    	
    	START_START_INS_FLAG	= JSPUtil.nullToEmpty(wf.getValue("START_START_INS_FLAG",	0));
    	CONT_PROCESS_FLAG		= JSPUtil.nullToEmpty(wf.getValue("CONT_PROCESS_FLAG",		0));
    	CONT_AMT				= JSPUtil.nullToEmpty(wf.getValue("CONT_AMT",				0));
    	CONT_ASSURE_PERCENT		= JSPUtil.nullToEmpty(wf.getValue("CONT_ASSURE_PERCENT",	0));
    	CONT_ASSURE_AMT			= JSPUtil.nullToEmpty(wf.getValue("CONT_ASSURE_AMT",		0));
    	
    	FAULT_INS_PERCENT		= JSPUtil.nullToEmpty(wf.getValue("FAULT_INS_PERCENT",		0));
    	FAULT_INS_AMT			= JSPUtil.nullToEmpty(wf.getValue("FAULT_INS_AMT",			0));
    	PAY_DIV_FLAG			= JSPUtil.nullToEmpty(wf.getValue("PAY_DIV_FLAG",			0));
    	FAULT_INS_TERM			= JSPUtil.nullToEmpty(wf.getValue("FAULT_INS_TERM",			0));
    	BD_NO					= JSPUtil.nullToEmpty(wf.getValue("BD_NO",					0));
    	
    	BD_COUNT				= JSPUtil.nullToEmpty(wf.getValue("BD_COUNT",				0));
    	AMT_GUBUN				= JSPUtil.nullToEmpty(wf.getValue("AMT_GUBUN",				0));
    	TEXT_NUMBER				= JSPUtil.nullToEmpty(wf.getValue("EXEC_NO",				0));
    	DELAY_CHARGE			= JSPUtil.nullToEmpty(wf.getValue("DELAY_CHARGE",			0));
    	DELV_PLACE				= JSPUtil.nullToEmpty(wf.getValue("DELV_PLACE",				0));
    	
    	REMARK					= JSPUtil.nullToEmpty(wf.getValue("REMARK",					0));
	   	CTRL_DEMAND_DEPT		= JSPUtil.nullToEmpty(wf.getValue("CTRL_DEMAND_DEPT",		0));     
	   	CT_FLAG_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CT_FLAG_TEXT",			0));   
	   	CT_FLAG					= JSPUtil.nullToEmpty(wf.getValue("CT_FLAG",				0));   
    	CTRL_CODE				= JSPUtil.nullToEmpty(wf.getValue("CTRL_CODE",				0));
    	COMPANY_CODE			= JSPUtil.nullToEmpty(wf.getValue("COMPANY_CODE",			0));  
    	RFQ_TYPE				= JSPUtil.nullToEmpty(wf.getValue("RFQ_TYPE",				0));  
    	REJECT_REASON			= JSPUtil.nullToEmpty(wf.getValue("REJECT_REASON",			0));  
    	//CONFIRM_USER_ID			= JSPUtil.nullToEmpty(wf.getValue("CONFIRM_USER_ID",	0));  
    	//CONFIRM_USER_NAME		= JSPUtil.nullToEmpty(wf.getValue("CONFIRM_USER_NAME",		0));
    	CONT_TYPE1_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE1_TEXT",		0));  
    	CONT_TYPE2_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE2_TEXT",		0)); 

	    SG_LEV1					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV1",				0)); 
		SG_LEV2					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV2",				0)); 
		SG_LEV3					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV3",				0)); 
		ADD_TAX_FLAG			= JSPUtil.nullToEmpty(wf.getValue("ADD_TAX_FLAG",			0));  
		ITEM_TYPE				= JSPUtil.nullToEmpty(wf.getValue("ITEM_TYPE",				0));  
		RD_DATE					= JSPUtil.nullToEmpty(wf.getValue("RD_DATE",				0));  
		CONT_TOTAL_GUBUN		= JSPUtil.nullToEmpty(wf.getValue("CONT_TOTAL_GUBUN",		0));  
		CONT_PRICE				= JSPUtil.nullToEmpty(wf.getValue("CONT_PRICE",				0));     	 
		EXEC_NO					= JSPUtil.nullToEmpty(wf.getValue("EXEC_NO",				0));  
		
		SG_LEV1_TEXT          	= JSPUtil.nullToEmpty(wf.getValue("SG_LEV1_TEXT",				0));     	 
		SG_LEV2_TEXT          	= JSPUtil.nullToEmpty(wf.getValue("SG_LEV2_TEXT",				0));     	 
		SG_LEV3_TEXT          	= JSPUtil.nullToEmpty(wf.getValue("SG_LEV3_TEXT",				0));     	 
		CONT_PROCESS_FLAG_TEXT	= JSPUtil.nullToEmpty(wf.getValue("CONT_PROCESS_FLAG_TEXT",				0));     	 
		CONT_TYPE1_TEXT_TEXT	= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE1_TEXT_TEXT",				0));     	 
		CONT_TYPE2_TEXT_TEXT  	= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE2_TEXT_TEXT  ",				0));     	 
		ELE_CONT_FLAG_TEXT    	= JSPUtil.nullToEmpty(wf.getValue("ELE_CONT_FLAG_TEXT",				0));     	 
		CONT_TYPE_TEXT        	= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE_TEXT",				0));     	 
		ASSURE_FLAG_TEXT      	= JSPUtil.nullToEmpty(wf.getValue("ASSURE_FLAG_TEXT",				0));     	 
		CONT_TOTAL_GUBUN_TEXT 	= JSPUtil.nullToEmpty(wf.getValue("CONT_TOTAL_GUBUN_TEXT",				0));     	 		
    }
	
	
	
	Object[] obj = {cont_form_no, cont_gl_seq};
	SepoaOut value = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractFormSelectSCPMT", obj);
	
	SepoaFormater wf11 = new SepoaFormater(value.result[0]);
	
	for(int i = 0; i < wf11.getRowCount(); i++)
	{
		CONT_CONTENT += wf11.getValue("CONTENT", i);
	}
	
	
	Object[] obj1 = {cont_no, cont_gl_seq};
	SepoaOut value1 = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractContNoSelect", obj1);
	SepoaFormater wf2 = new SepoaFormater(value1.result[0]);

	String in_val_cont_type					= "";
	String seller_code						= "";
	String in_val_cont_add_date             = ""; // 계약일자
	
    if(wf2.getRowCount() > 0) {
    	seller_code						= JSPUtil.nullToEmpty(wf2.getValue("seller_code",0));      //업체코드
    	in_val_cont_type				= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_TYPE",0)); //계약종류
    	in_val_cont_add_date            = JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_ADD_DATE",0));	// 계약일자
	}

	String in_woori_sign_name		= "";//우리은행 싸인
	String in_vendor_sign_name		= "";//업체 싸인
	
	if( "CC".equals(ct_flag) || "CD".equals(ct_flag) ) { // 업체인증, 우리은행인증
	    Object[] obj2 = {"W100", seller_code};
		SepoaOut value2 = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractsignSelect", obj2);
		SepoaFormater wf3 = new SepoaFormater(value2.result[0]);
		
	    if(wf3.getRowCount() > 0) {
	    	if( "CC".equals(ct_flag) )   in_vendor_sign_name = JSPUtil.nullToEmpty(wf3.getValue("VENDOR_SIGN_NAME",0));
	    	if( "CD".equals(ct_flag) ){
	    		in_woori_sign_name	 = JSPUtil.nullToEmpty(wf3.getValue("WOORI_SIGN_NAME",0));
	    		in_vendor_sign_name  = JSPUtil.nullToEmpty(wf3.getValue("VENDOR_SIGN_NAME",0));
	    	}
	    }	
    }
	
	Logger.sys.println("@@@@@@@@@@@@@@@@@@@@@ in_val_cont_add_date=  " + in_val_cont_add_date);
	
    if(in_val_cont_add_date.length()			> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<SPAN id=in_val_cont_add_date></SPAN>"     , "<font size=3 face=바탕 color=black>"+in_val_cont_add_date+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<SPAN id=in_val_cont_add_date></SPAN>"     , "" );   

	Logger.sys.println("in_woori_sign_name  = " + in_woori_sign_name);
	Logger.sys.println("in_vendor_sign_name = " + in_vendor_sign_name);
	Logger.debug.println( info.getSession("ID"), this, "==================== in_woori_sign_name : " + in_woori_sign_name );
	Logger.debug.println( info.getSession("ID"), this, "==================== in_vendor_sign_name = " + in_vendor_sign_name );
																			
	if(in_vendor_sign_name.length()	> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<IMG name=vendor_sign src=\"https://dev.wooriepro.com/poasrm/sign/blank.gif\" width=60 height=60>",		"<IMG name=vendor_sign src=/poasrm/sign/"+in_vendor_sign_name+" width=60 height=60>");
	if(in_woori_sign_name.length()	> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<IMG name=woori_sign src=\"https://dev.wooriepro.com/poasrm/sign/blank.gif\" width=60 height=60>",		"<IMG name=woori_sign src=/poasrm/sign/"+in_woori_sign_name+" width=60 height=60>");
																					
	//Logger.sys.println("CONT_CONTENT = " + CONT_CONTENT);

//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
_rptData.append(contractstatus);	//계약상태
_rptData.append(_RF);
_rptData.append(CONT_NO);	
_rptData.append(_RF);
_rptData.append(CONT_GL_SEQ);	
_rptData.append(_RF);
_rptData.append(SUBJECT);
_rptData.append(_RD);
_rptData.append("<html>");
_rptData.append("<head>");
_rptData.append("</head>");
_rptData.append("<body>");
_rptData.append(CONT_CONTENT);////////////////////////////////////////////////////////////////////////////////////////
_rptData.append("</body>");
_rptData.append("</html>");
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////		
%>
<%/* Alice Editer Object css&js */%>
<link rel="stylesheet" type="text/css" HREF="../css/alice/alice.css">
<link rel="stylesheet" type="text/css" HREF="../css/alice/oz.css">

<%@ include file="/include/alice_scripts.jsp"%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<SCRIPT language=javascript src="../include/attestation/TSToolkitConfig.js"></script>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>

<STYLE> 
	.dd tr,td {	} 
</STYLE> 

<script language="javascript">

function init() {
}
<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	//alert(document.form.rptData.value);
	if(typeof(rptAprvData) != "undefined"){
		document.form.rptAprvUsed.value = "Y";
		document.form.rptAprvCnt.value = approvalCnt;
		document.form.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "ClipReport4";
	document.form.submit(); 
	cwin.focus();
}
</Script>
</head>

<body leftmargin="0" topmargin="0" onload="init()">
<s:header popup="true">
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
<form name="form" id="form">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot").replaceAll("\\\\", "￦")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
<%
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = "전자계약서 상세내역"; //전자계약진행현황
%>
<%@ include file="/include/sepoa_milestone.jsp"%>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" bgcolor="#ffffff"  align="right">
					<TABLE cellpadding="0">
						<TR>
<% if("CD".equals(CT_FLAG)){ %>
							<TD >
<script language="javascript">
btn("javascript:clipPrint()", "출 력");
</script>
							</TD>
<% } %>					
							<TD >
<script language="javascript">
btn("javascript:window.close()", "닫 기");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>	
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0"  bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" > 
				    		<tr>
		        				<td class="data_td" width="100%" colspan="2" >
     		    					<%=CONT_CONTENT%>
        						</td>
        	  				</tr>  
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="10"></td>
	</tr> 
  	<tr>
    	<td align="center">
	  		<%if(in_val_cont_type.equals("계약서")) { %>
   		      	이 문서는 전자 서명으로 체결한 계약서로 수정, 변경 할 수 없습니다.
     		<%} else { %>
   				이 문서는 전자 서명으로 체결한 계약 승인서로 수정, 변경 할 수 없습니다.
     		<%} %>
  		</td>
  	</tr>  
</table>	
</form>
</s:header>
<s:footer/>
</body>
</html>
