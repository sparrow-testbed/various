<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TEST123");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TEST123";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!-- Parameter 정보/Session 정보 -->
<%

	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
%>

<html>
	<head>
		<title>
			<%=text.get("MESSAGE.MSG_9999")%>
		</title> <%-- 우리은행 전자구매시스템 --%>
		<script language="javascript">
//<!--

function Confirm(){
	var form1 = document.form1;
	
	if(form1.buyer_reject_Remark.value == "" || form1.buyer_reject_Remark.value == null){
		alert("반려사유를 입력하세요.");
		return;
	}
	
	opener.SetReject_Reamrk(form1.buyer_reject_Remark.value);
	window.close();
}

//-->
</script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
</head>
<body onload="" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작-->

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;세금계산서 반려사유 등록
	</td>
</tr>
</table>

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>
<form name="form1">
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td width="78%" class="cell3_title"><b>반려사유</b>
  		</td>
	</tr>
	<tr>
  		<td height="5" bgcolor="#FFFFFF"></td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#407bbc" style="border-collapse:collapse;">
	<tr>
		<td class="c_data_1_p" width="100%">
     		<div align="left">
   				<textarea style="width: 98%; height: 150px" name="buyer_reject_Remark" class="inputsubmit" cols="80" rows="8" onKeyUp="return chkMaxByte(2000, this, '반려 사유');"></textarea>
    		</div>
		</td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
 	<tr>
   		<td height="30" align="right">
			<TABLE cellpadding="0">
		     	<TR>
		  	  		<TD><script language="javascript">btn("javascript:Confirm()","확 인")    </script></TD>
					<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
		  	  	</TR>
   			</TABLE>
   		</td>
 	</tr>
</table>
	</form>

</s:header>
<s:footer/>
	</body>
</html>


