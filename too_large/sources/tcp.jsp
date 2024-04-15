<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="sepoa.fw.util.TripleDes01" %>
<%@ page import="sepoa.fw.util.SepoaDate" %>
<%@ page import="javax.servlet.RequestDispatcher"%>
<!DOCTYPE html>
<html>
<head>
<title>전자구매</title>
<script language="javascript">
function init(){
	
}

function setData1(){
	var F=document.forms[0];

	if (LRTrim(F.CONTENT.value) == ""){
		alert("내용을 입력하세요.");
		F.CONTENT.value = LRTrim(F.CONTENT.value);
		F.CONTENT.focus();
		return;
	}
	
	var anw = confirm("전송하시겠습니까?");
	if(anw == false) return;

 	F.mode.value = "doSend";
 	F.method = "POST";
    F.target = "childFrame";
    F.action = "tcp_sub.jsp";
    F.submit();

}
</script>
</head>
<body leftmargin="15" topmargin="6">
<form name="form1"  method="post">
	  <input type="hidden" name="mode"       id="mode"  >
	  <TABLE cellpadding="2" cellspacing="0">
		<TR>
					<TD><input type="button" value='전송'   onclick='javascript:setData1();'/></td>					                	
		</TR>
		</TABLE>
       	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			 	 	 <td colspan='2' >
			 	 	 <textarea name="CONTENT" id="CONTENT"  style="width:1890px;height:480px" ></textarea>
			 	 	 </td>
			 	</tr>	  			  			    
         </table>
</form>
<iframe name="childFrame" src="" frameborder="0" width="1890px" height="480px" marginwidth="0" marginheight="0" scrolling="auto"></iframe>
</body>
</html>