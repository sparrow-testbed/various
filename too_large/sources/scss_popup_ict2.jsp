<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
</head>
<body>
<s:header popup="true">
<form name="form1" id="form1" method=post >
				<table style="BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid">
					<tr>
						<td valign="top" align="middle" height="30" width="300"  colspan="2">
													<br>
													<font class="title_summary" color="black" style="font-size:15px"><a href="#" onclick="javascript:onBtnInput();">【업체탈퇴요청】</a></font><br>														
						</td>						
					</tr>
					<tr>
						<td align="middle" height="30" width="300" colspan="2">
							<b>업체탈퇴 요청 하시겠습니까?</b>
						</td>
						
					</tr>	
					<tr>
						<td align="right" height="20" width="300">
							<script language="javascript">btn("javascript:parent.doScss();self.close();","탈퇴요청")</script>
						</td>
						<td align="left" height="20" width="300">
							<script language="javascript">btn("javascript:self.close();", "닫 기")</script>
						</td>						
					</tr>	
					<tr>
						<td align="middle" height="20" width="300" colspan="2">
							&nbsp;
						</td>						
					</tr>					
				</table>
</form>

</s:header>
<s:footer/>
</body>						
</html>