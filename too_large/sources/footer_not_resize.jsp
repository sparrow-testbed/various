<%@ page contentType="text/html; charset=UTF-8"%>
		<%
			if(session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX") != null){
				//초기 페이지가 지정되어 있으면, 선택한 것처럼 나타내야 한다.(상단 아이콘 변화)
		%>
			<script>
			$(document).ready(function(){
				topMenuMouseOver("<%=session.getAttribute("RECENT_MENU_OBJECT_CODE_IMGURL")%>", "<%=session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX")%>");
			});
			</script>
		<%	} %>

		<form name='form_header'>
			<input type='hidden' name='nowClickedIndex' value='<%=(session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX")==null ? "" : (String)session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX"))%>'>
			<input type='hidden' name='nowClickedImgUrl' value='<%=(session.getAttribute("RECENT_MENU_OBJECT_CODE_IMGURL")==null ? "" : (String)session.getAttribute("RECENT_MENU_OBJECT_CODE_IMGURL"))%>'>
		</form>
		<form name='form_footer'>
			<input type='hidden' name='setGridDrawEnd' value='false'>
			<!-- 현재 트리의 menuObjectCode를 기억한다.
			좌측 트리메뉴안에서 다른 아이템 메뉴 선택시 menuObjectCode를 매개변수로 넘겨서 form에 있는 menuObjcetCode값을 session의 RECENT_MENU_OBJECT_CODE 다시 저장토록 한다.
			상단 단위에서의 화면 이동이 없는 한에서는 불필요한 작업이지만, 다른 상단메뉴로 이동 후 backspace를 이용하여 화면이 전 화면으로 바뀌었을때, 
			click으로 인한 이동이 아니기에 session의 RECENT_MENU_OBJECT_CODE값은 변경되지 않게 된다.
			그로인해 좌측메뉴 클릭시, 엉뚱한 화면(현재 화면이 아닌 전 화면)으로 이동할 가능성이 있다. -->
			<input type='hidden' name='menuObjectCode' value='<%=(String)session.getAttribute("RECENT_MENU_OBJECT_CODE")%>'>
			<input type='hidden' name='hideMenu' value='false'>
			<input type='hidden' name='nowPageAddress' value='<%=request.getServletPath()%>'>
		</form>
		<form name="formstyle">
			<input type="hidden" name="csvBuffer">
			<input type="hidden" name="headText">
			<input type="hidden" name="gridColids">
			<input type="hidden" name="headWidth">
			<input type="hidden" name="screen_id">
			<input type="hidden" name="user_id">
		</form>
                </div><!-- end of content -->
            </div><!-- end of contents-box -->
        </div><!-- end of container -->
	</div><!-- end of wrap -->
	<iframe name="timer_frame" src="/common/timer.jsp" marginwidth="0" marginheight="0" frameborder="0" scrolling="auto" width="0" height="0"></iframe>