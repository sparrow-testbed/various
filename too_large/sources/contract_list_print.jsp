<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MASSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	
	String CONT_DESC		= "";
	String CHANGE_USER_ID	= "";
	String CONT_CONTENT     = "";
	
	String cont_no	    = JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq  = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String cont_form_no	= JSPUtil.nullToEmpty(request.getParameter("cont_form_no"));
	String flag	        = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String ct_flag      = JSPUtil.nullToEmpty(request.getParameter("ct_flag"));

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
																					
	Logger.sys.println("CONT_CONTENT = " + CONT_CONTENT);
	
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
	//window.print();
}

</Script>
<script src="../qm/Scripts/AC_ActiveX.js" type="text/javascript"></script>
<script src="../qm/Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
</head>

<body leftmargin="0" topmargin="0" onload="init()">
<s:header popup="true">
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
<form name="form">

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
<script type="text/javascript">
AC_AX_RunContent( 'id','label','viewastext','viewastext','style','display:none','classid','clsid:1663ed61-23eb-11d2-b92f-008048fdd814','codebase','../PrintCab/smsx.cab#Version=6,3,436,14' ); //end AC code
</script><noscript><object id="label" viewastext  style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="../PrintCab/smsx.cab#Version=6,3,436,14"></object></noscript>

<script language="JavaScript">
    document.label.printing.header = "";
	document.label.printing.footer = "";
	document.label.printing.portrait = true;
	document.label.printing.leftMargin = 25;
	document.label.printing.topMargin = 18;
	document.label.printing.rightMargin = 25;
	document.label.printing.bottomMargin = 18;
	this.focus();
	document.label.printing.Print(true, window);
</script>
</s:header>
<s:footer/>
</body>
</html>
