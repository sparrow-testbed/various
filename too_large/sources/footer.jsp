<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/include/sepoa_common.jsp"%>
		<%
		    if(session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX") != null){
				//초기 페이지가 지정되어 있으면, 선택한 것처럼 나타내야 한다.(상단 아이콘 변화)
		%>
			<script>
			$(document).ready(function(){
				//첫화면에서 상단메뉴 클릭한 상태로 보이기
				topMenuMouseOver(<%-- "<%=session.getAttribute("RECENT_MENU_OBJECT_CODE_IMGURL")%>", --%> "<%=session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX")%>");
			});
			</script>
		<%	} %>
		<%
		    String strProfile = SepoaSession.getValue(request, "MENU_PROFILE_CODE");
		%>

		<form name='form_header'>
			<input type='hidden' id='nowClickedIndex' name='nowClickedIndex' value='<%=(session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX")==null ? "" : (String)session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX"))%>'>
			<%-- <input type='hidden' name='nowClickedImgUrl' value='<%=(session.getAttribute("RECENT_MENU_OBJECT_CODE_IMGURL")==null ? "" : (String)session.getAttribute("RECENT_MENU_OBJECT_CODE_IMGURL"))%>'> --%>
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
        <script>
        function recal() {
            var gridObjs = $('div[id^=\"gridbox\"]');
            if(gridObjs.length == 1) {
            	var height = ($(window).height() - $('#head_area').height() - $('#header').height() - 33);
                
                if(height > 200){
                    gridObjs[0].style.height = height + 'px';
                }else{
                	gridObjs[0].style.height = '200px';	//기본값
                }
            } else if(gridObjs.length > 1) {
                var height = ($(window).height() - $('#head_area').height() - $('#header').height() - 67);
                for(var i = 0; i < gridObjs.length; i++ ) {
                    var percent = gridObjs[i].getAttribute('height');
                    pheight = (height * percent) / 100;
                    if(pheight > 200){"C:/Users/woori/AppData/Local/Microsoft/Windows/Temporary Internet Files/Content.IE5/WYO4ZH2L/btn_logout[1].gif"
                        gridObjs[i].style.height = pheight + 'px';
                    }else{
                    	gridObjs[i].style.height = '200px';	//기본값
                    }
                }
            }

            <%if ("MUP141000003".equals(strProfile)){%>
            	$('#treeboxbox_tree').css('height', ($(window).height() - $('#header').height() - 500) + 'px');
            <%}else if ("MUP150700002".equals(strProfile)){%>
            	$('#treeboxbox_tree').css('height', ($(window).height() - $('#header').height() - 300) + 'px');
            <%}else{%>
            	$('#treeboxbox_tree').css('height', ($(window).height() - $('#header').height() - 70) + 'px');
            <%}%>

            $('#snb').css('height', ($(window).height() - $('#header').height() - 20) + 'px');
        }
            $(document).ready(function(){
	            recal();
            	$(window).resize(recal);
                $(recal);
                
                //팝업이 아닌경우에만
                if(typeof setTreeDraw != "undefined") {
                    //좌측트리메뉴를 그린다.
                    $(setTreeDraw);
                    
                    //상단 메뉴 포커스(테스트중)
<%--                     var id = "topMenuId" + "<%=(session.getAttribute("RECENT_MENU_OBJECT_CODE_INDEX"))%>"; 
                    $("#"+id).focus(); --%>
                    
                }
               
                //IE8버전이하-호환성보기에서 실행해야 할 것들...
                if ('v'=='\v') {
                	$("div#topmenu ul").css("overflow-y","auto");
                }
                
	            //바로 전 화면에서 상단 메뉴 클릭한 곳을 찾아서 그곳의 img를 눌림상태로 변경해준다.
	            //로그인 후 최초에는 nowClickedIndex 값이 없다.
	            if(!document.form_header.nowClickedIndex.value == ""){
	            	var temp = document.getElementById("topMenuText_"+document.form_header.nowClickedIndex.value);
	            	//popup 일때는 null이다.
	            	if(temp != null){
		            	//temp.src = document.form_header.nowClickedImgUrl.value;
		            	temp.style.color = "#FEA843";//주황색
	            	}
	            }
	            
	            if(parent.isUsinglayoutTabbar){
	            	$("#closeLayoutTabbar").css("display","block");	
	            }
            });
            
            function closeLayoutTabbarProc(){
            	if(parent.isUsinglayoutTabbar){
            		parent.layoutTabbar.closeTabOthers();	//현재 활성된 탭을 제외하고 모든 탭을 닫는다.
            	}
            }
            
            function changeHashOnLoad() {
                window.location.href += "#";
                setTimeout("changeHashAgain()", "50"); 
           }

           function changeHashAgain() {
             window.location.href += "1";
           }
/*
           var storedHash = window.location.hash;
           window.setInterval(function () {
               if (window.location.hash != storedHash) {
                    window.location.hash = storedHash;
               }
           }, 50);

           $(document).ready(changeHashOnLoad);
*/
        </script>
                </div><!-- end of content -->
            </div><!-- end of contents-box -->
        </div><!-- end of container -->
	</div><!-- end of wrap -->
	<iframe name="timer_frame" src="/common/timer.jsp" marginwidth="0" marginheight="0" frameborder="0" scrolling="auto" width="0" height="0"></iframe>