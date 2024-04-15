<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/dhtmlx_common.jsp"%>
<%
	String language = request.getParameter("language");
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	
	// 동일한 브라우저에서 로그인을 다시 하면 이전에 선택했던 메뉴값이 세션에 남아있을 수 있다. 삭제한다.
	//session.removeAttribute("treeMenuId");
	
	// 초기 페이지를 지정할 경우 - 좌측메뉴의 id값을 세션(treeMenuId)에 등록해서 좌측메뉴의 해당 아이템이 자동으로 화면에 스크롤될 수 있도록 해야한다.
    //request.getRequestDispatcher("/common/main.jsp").forward(request, response);
%>
<link rel="stylesheet" href="<%=POASRM_CONTEXT_NAME%>/css/jquery.contextMenu.css" type="text/css"/>
<script  src="<%=POASRM_CONTEXT_NAME%>/js/lib/jquery.contextMenu.js"></script>
<script>
	var home_jsp = "<%=POASRM_CONTEXT_NAME%>/common/testMain.jsp";
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우리은행 전자구매시스템</title>
<script>
	var layoutTabbar = null;			//전역변수로서 parent 페이지 전역에서 사용한다.
	//layout tabbar를 사용할지 여부 //전역변수로서 parent 페이지 전역에서 사용한다.(메뉴 링크 제어할 때 꼭 필요하다.)
	//sepoa.layoutTabbar = true; 추가 필요(사용하는 경우)
	var isUsinglayoutTabbar = <%= olConfxxxx.getString("sepoa.layoutTabbar") %>;		
	function tab_init(){
		if(isUsinglayoutTabbar){
			layoutTabbar = new SepoaDhtmlXTabBar("layoutTab", "bottom", 7);	//layoutTab:div의 id, bottom:위치, 7:tab max count 
			layoutTabbar.enableTabCloseButton(true);			//삭제가능한지 여부
			layoutTabbar.addTabWithUrl("main",home_jsp);		//tab 추가(탭이름,url)
		}
	}
	function startPage(){
		window.location.href = home_jsp;
	}
	function init(){
		//layout 탭을 사용하는 경우
		if(isUsinglayoutTabbar){
			tab_init();
		}else{
			startPage();
		}
	}
	$(function(){
	    $.contextMenu({
	        selector: '.dhx_tab_element', 
	        callback: function(key, options) {
	        	ad();
	        	alert(this.tabIndex);
	        },
	        items: {
	            "CO": {name: "Close Others"}
	        }
	    });
	    
	});

    $(document).ready(function(){
		function recal() {
	        $('#layoutTab').height(($(window).height() - 20 + 'px'));
	    }
        $(window).resize(recal);
        $(recal);
    }) ;
	
	

</script>
</head>
<body onload="init();">
	<div id="layoutTab" style="width:100%;"></div>
</body>
</html>