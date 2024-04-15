<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    Vector multilang_id = new Vector();
 
	HashMap text = MessageUtil.getMessageMap( info, "MESSAGE", "BUTTON" );

	Config conf = new Configuration(); 
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<%@ include file="/include/include_css.jsp"%> 
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script> 
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 
<script language="javascript" type="text/javascript"> 
 
function getApprovalSend() { 
	var cancle_text  = document.form.comment.value;
	//var sr_attach_no = document.form1.attach_no.value;

	opener.document.form1.NB_REASON.value  = cancle_text;
	//opener.document.form1.sr_attach_no.value = sr_attach_no;
	opener.doBdProcess("NB");
	window.close();
} 
</Script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<s:header popup="true">
<form name="form" method="post" action=""> 
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td class='title_page'>
		유찰사유
    &nbsp;
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
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>  
                <tr>
      <td width="15%" class="title_td">유찰사유</td>
      <td class="data_td">&nbsp;
		<textarea name="comment" id="comment" style="width:98%" class="inputsubmit" maxlength=400 rows="5"></textarea>
      </td>
    </tr> 
	  	</table>
	      		</td>
	    	</tr>
	  	</table>
	  </td>
	  </tr>
	  </table>	
  <br>
 
	  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
	    	<tr>
	      		<td height="30" align="right">
					<TABLE cellpadding="0">
			      		<TR> 
					  			<TD><script language="javascript">btn("javascript:getApprovalSend()", "유찰")</script></TD> 
		    	  		</TR>
	      			</TABLE>
	      		</td>
	    	</tr>
	  	</table>
</form>
</s:header> 
</body>
</html> 
