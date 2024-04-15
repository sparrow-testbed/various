<%@ page contentType = "text/html; charset=UTF-8" %>
<table width="99%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td class='title_page' height="20" align="left" valign="bottom">
<%
	String       strstr           = null;
	String       beforePathStr    = null;
	String       afterPathStr     = null;
	StringBuffer pathStringBuffer = new StringBuffer();
	int          pathIndex        = 0;

	if(thisWindowPopupFlag.toLowerCase().equals("true") == false){ // popup 창이 아닐 경우
		strstr = info.getSession("SEPOA_SCREEN_PATH");

		if(strstr == null){
			strstr = "";
		}
		
		pathIndex = strstr.lastIndexOf(">");
		
		if(pathIndex != -1){
			beforePathStr = strstr.substring(0, pathIndex + 1);
			afterPathStr  = strstr.substring(pathIndex + 1);
			
			pathStringBuffer.append(beforePathStr).append("<span class='location_end'>").append(afterPathStr).append("</span>");
		}
	}
	else{ // 팝업창인 경우
		pathStringBuffer.append(thisWindowPopupScreenName);
	}
	
	strstr = pathStringBuffer.toString();
	
	out.println(strstr);
%>
			&nbsp;
		</td>
	</tr>
</table>