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
<%@ include file="/include/sepoa_common.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>System Message</title>
<style type="text/css">
<!--
body {
	margin-top: 30px;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 18px;
	font-weight: bold;
}
-->
</style></head>

<body>
<center>
  <table width="704" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td width="704" height="118" colspan="3" background="images/err_bg_main.gif">&nbsp;</td>
    </tr>
    <tr>
      <td width="152" align="right" valign="middle" background="images/err_box_bg_left.gif"><img src="images/err_box_left.gif" width="113" height="20" hspace="10" vspace="3"></td>
      <td width="532" align="left" valign="top" bgcolor="#F4F5F4" style="color:#555555;font-size:11px;font-family:tahoma, verdana, arial"><p>&nbsp;</p>
          <p><span class="style2"><%=JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("error_text")))%></span></p>
          <p>&nbsp;</p>          </td>
      <td width="20" height="1" background="images/err_box_bg_right.gif"><img src="images/err_box_bg_right.gif" width="20" height="1"></td>
    </tr>
    <tr>
      <td colspan="3" width="704" height="20"><img src="images/err_box_bottom.gif" width="704" height="20"></td>
    </tr>
  </table>
</center>
</body>
</html>
