<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
 
<%

	request.setCharacterEncoding("UTF-8");
	String menuObjectCode = request.getParameter("menuObjectCode");
	String menuObjectCode_index = request.getParameter("index");
	String menuObjectCode_imgUrl = request.getParameter("imgUrl");

	String url = request.getParameter("url");
	String url3 = request.getParameter("url3");
	String beforeUrl = request.getParameter("beforeUrl");
	
	session.setAttribute("RECENT_MENU_OBJECT_CODE",menuObjectCode);	//세션에 등록한다.
	session.setAttribute("RECENT_MENU_OBJECT_CODE_INDEX",menuObjectCode_index);	//상단 images 에 대한 src 조정을 하기 위해
	session.setAttribute("RECENT_MENU_OBJECT_CODE_IMGURL",menuObjectCode_imgUrl);	//상단 images 에 대한 src 조정을 하기 위해
	
	//좌측메뉴의 선택된 아이템을 세션에서 제거한다.
	session.removeAttribute("treeMenuId");
	
	//이동할 화면의 트리를 미리 만들어서 정보를 찾기 위해 tree xml 추출해줌
	Map<String, String> leftMenuMap = (Map<String, String>) session.getAttribute("LEFT_MENU");
	String leftMenu = leftMenuMap.get(menuObjectCode);
	
%>
<html>
<head>
<script language="javascript" type="text/javascript">
function init() {
	treeXml = "<%=leftMenu%>";
	
    var index = (new Date()).getTime();
    var divT = document.createElement('div');
    divT.id='temporaryDiv'+index;
    divT.style.display = "none";
    document.body.appendChild(divT);

	var dhtmlxTreeTemp = new dhtmlXTreeObject(divT.id, "100%","100%", 0);
	dhtmlxTreeTemp.loadXMLString(treeXml);

	var treeMenuId = seekTreeMenuIdFromUrl(dhtmlxTreeTemp, "<%=url%>");
	if(treeMenuId != null) {
		leftMenuClick(treeMenuId, null, dhtmlxTreeTemp);
	}
	
	document.body.removeChild(divT);
<%
	String jsp_addr = null;
	if(url == null || "".equals(url)) {
		jsp_addr = POASRM_CONTEXT_NAME + beforeUrl;
	} else {
		if(url3 == null || "".equals(url3) || "undefined".equals(url3)) {
			jsp_addr = POASRM_CONTEXT_NAME + url;	
		} else {
			jsp_addr = POASRM_CONTEXT_NAME + url3;	
		}
	}
	
%>
		var vCommonForm = document.createElement("form");
		vCommonForm.setAttribute("name"   , "commonForm"  );
		vCommonForm.setAttribute("method" , "post"             );
//		vCommonForm.setAttribute("target" , title              );
		vCommonForm.setAttribute("action" , _POASRM_CONTEXT_NAME + "/common/openPage.jsp"	);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "id" );
        postInputObj.setAttribute("value" , treeMenuId);
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "menuObjectCode" );
        postInputObj.setAttribute("value" , "<%=menuObjectCode%>");
        vCommonForm.appendChild(postInputObj);

        postInputObj = document.createElement("input");
        postInputObj.setAttribute("type"  , "hidden" );
        postInputObj.setAttribute("name"  , "jsp_addr" );
        postInputObj.setAttribute("value" , "<%=jsp_addr%>");
        vCommonForm.appendChild(postInputObj);

		document.body.appendChild(vCommonForm);
		vCommonForm.submit();
}
</script>
</head>
<body onload="init();">
</body>
</html>
