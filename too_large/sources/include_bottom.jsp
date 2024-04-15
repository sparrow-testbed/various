<%--
<%@ page contentType = "text/html; charset=UTF-8" %>
		<%
			String bottom_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));

			if(bottom_popup_flag.equals("true"))
			{	%>
							<tr>
								<td width="95%" height="40" align="right">
								<table border="0" cellspacing="3" cellpadding="0">
									<tr>
										<td align="right"><script language="javascript">btn("javascript:self.close();","Close")</script></td>
									</tr>
								</table>
								</td>
							</tr>
		<%	}	%>
--%>
<%--
 <div id="contents" style="position:absolute; width:290px; height:360px; z-index:1; visibility: hidden; left:0px; top:0px;" align="center">
   <iframe  name="hold_list" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="auto"></iframe>
 </div>
--%>
<%-- 지우지마세요 --%>