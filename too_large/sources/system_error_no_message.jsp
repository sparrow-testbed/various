<%
/**
 *========================================================
 *Copyright(c) 2007 세포아소프트
 *@File : 
 *@FileName : 
 *Open Issues :
 *Change history
 *@LastModifyDate : 
 *@LastModifier : 
 *@LastVersion : 
 *=========================================================
 */
 %>
 <%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ page isErrorPage="true" %>
<html>
<head>
<title>Error Page</title>
<style type="text/css">
body {margin-top: 30px;color:#555555;font-size:11px;font-family:tahoma, verdana, arial}
</style>
</head>
<body>
<center>
  <table width="704" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td width="704" height="118" colspan="3"><img src="./images/err_box_top.gif" width="704" height="118"></td>
    </tr>
    <tr>
      <td width="152" align="right" valign="middle" background="./images/err_box_bg_left.gif"><img src="./images/err_box_left.gif" width="113" height="20" hspace="10" vspace="3"></td>
      <td width="532" align="left" valign="top" bgcolor="#F4F5F4" style="color:#555555;font-size:11px;font-family:tahoma, verdana, arial">
	<%
	//Throwable er = (Throwable)request.getAttribute("javax.servlet.jsp.jspException");
//	Throwable er = (Throwable)request.getAttribute("javax.servlet.error.exception");

//	if(er == null) out.println("<b>Error is null. Contact system administrator.</b>");
//    else
	out.println("Unknown error.");
%>
	</td>
      <td width="20" height="1" background="./images/err_box_bg_right.gif"><img src="./images/err_box_bg_right.gif" width="20" height="1"></td>
    </tr>
    <tr>
      <td colspan="3" width="704" height="20"><img src="./images/err_box_bottom.gif" width="704" height="20"></td>
    </tr>
  </table>
</center>
</body>
</html>
