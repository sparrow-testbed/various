<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우리은행 전자구매시스템</title>
<style type="text/css">
#html,body {
	height: 100%;
}
</style>
<%@ include file="/include/sepoa_common.jsp"%>

<%@ include file="/include/include_css.jsp"%>

<!-- <script type="text/javascript" src="../js/lib/cssrefresh.js"></script> -->
<script type="text/javascript" src="../js/lib/jquery-1.10.2.min.js"></script>
<!-- JSP내용 추가 start _____________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->

<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!public String nullCheck(String str) {
		if (str == null)
			return "";
		else
			return str;
	}%>

<%
    String language = info.getSession("LANGUAGE");	
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_031");
	multilang_id.addElement("BUTTON");
	
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
    String MENU_OBJECT_CODE = JSPUtil.CheckInjection(request.getParameter("MENU_OBJECT_CODE")) ;
    
	String MENU_NAME = JSPUtil.CheckInjection(request.getParameter("MENU_NAME")) ;
	if( MENU_NAME == null ) {
		MENU_NAME = "";
	} else {
		MENU_NAME = java.net.URLDecoder.decode(MENU_NAME, "UTF-8");
	}
	String SCREEN_ID =JSPUtil.CheckInjection(request.getParameter("SCREEN_ID")) ;
	if( SCREEN_ID == null )
		SCREEN_ID = "";
%>

<script language=javascript src="../js/lib/sec.js"></script>
<!-- 폴더 위치 변경됨,파일 추가됨 -->

<!-- 폴더 위치 변경됨,파일 추가됨 -->
<!-- 삭제 예정 -->

<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<!-- 폴더 위치 변경됨 -->

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><!-- 파일 추가됨 -->


<script language="javascript">

function CheckNode(arg) {
	var menu_object_code = '<%=MENU_OBJECT_CODE%>';
	var menu_field_code = $('#menu_field_code').val();
	var menu_parent_field_code = $('#menu_parent_field_code').val();
	var menu_name = $('#menu_name').val(); 
	var screen_id = $('#screen_id').val(); 
	var menu_link_flag = 'Y';
	var child_flag = $("input:radio[name=child_flag]:checked").val();
	var order_seq = $('#order_seq').val(); 
	var use_flag = $('#use_flag').val(); 
    if(arg == null) arg = '';
	var status = arg;
	var sub_flag = $("input:radio[name=sub_flag]:checked").val();
	var folder_flag = $('#folder_flag').val(); 

	if(menu_name == ''){	
		alert('<%=text.get("AD_031.0102")%>');
		return;
	}
	if(status != 'C' && menu_field_code == ''){
		alert('<%=text.get("AD_031.0103")%>');
		return;
	}
	if(menu_parent_field_code == ''){
			menu_parent_field_code = '*';
			order_seq = '0';		
	}
    var params = 'menu_object_code='+menu_object_code+'&menu_field_code='+menu_field_code+ '&menu_parent_field_code='+ menu_parent_field_code+ 
    '&menu_name='+ encodeUrl(menu_name) + '&screen_id='+ screen_id+ '&menu_link_flag='+ menu_link_flag+ '&child_flag='+ child_flag+ 
    '&order_seq='+ order_seq+ '&use_flag='+ use_flag+ '&status='+ status+ '&sub_flag='+ sub_flag+ '&folder_flag='+ folder_flag;
    
    var loadXMLUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.Menupop_tree?" + params;
    dhtmlxTree.destructor();
    setTreeDraw();
    dhtmlxTree.loadXML(loadXMLUrl);
}	
</script>
</head>
<body>
	<s:header popup="true">
		<div id="head_area">
			<!--타이틀시작-->
			<div id="title">
				<h3>메뉴필드 등록</h3>
				<div class="location">
					SYSTEM &gt; <span>메뉴</span>
				</div>
			</div>
			<!--//타이틀끝-->

			<!--내용시작-->
			<div id="left" style="width: 60%; float: left;">
				<!-- JSP내용 추가 start _____________________________________________________________________________________________ -->
				<!-- ______________________________________________________________________________________________________________ -->
				<form name="form">
					<input type='hidden' id='menu_object_code' name='menu_object_code' value='<%=MENU_OBJECT_CODE%>'>
					<input type='hidden' id='menu_field_code' name='menu_field_code' >
					<input type='hidden' id='menu_parent_field_code' name='menu_parent_field_code' >
					<input type='hidden' id='menu_link_flag' name='menu_link_flag' value='Y'>
					<input type='hidden' id='folder_flag' name='folder_flag'>
					<input type='hidden' id='order_seq' name='order_seq'>
					<%
					    String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
															if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
					%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="1" valign="top"><img
								src="../images/page/title_left.gif"></td>
							<td
								style="background-image: url(../images/page/title_mid.gif); background-repeat: repeat-x"
								class="se_title">메뉴필드 등록</td>
							<td align="right">
								<table width="100%" border="0" cellpadding="0" cellspacing="0"
									style="background-image: url(../images/page/title_mid.gif); background-repeat: repeat-x">
									<tr>
										<td align="right" class="se_location"></td>
										<td width="1" align="right"><img src="../images/page/title_end.gif" width="13" height="26"></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<div id="condition_area">
						<div class="title_sub" style="padding-top: 20px;"><%=text.get("AD_031.LB_01")%></div>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
						<table width="100%" border="0" cellspacing="0" bgcolor="#DBDBDB">
							<tr>
								<td width="25%" height="25" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_02")%></td>
								<td class="data_td" width="25%"><%=nullCheck(JSPUtil.CheckInjection(request.getParameter("MENU_OBJECT_CODE")))%> </td>
								<td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_03")%> </td>
                                <td class="data_td" width="25%">
                                    <select name="use_flag" id="use_flag" class="inputsubmit">
										<OPTION VALUE='Y'>Y</OPTION>
										<OPTION VALUE='N'>N</OPTION>
                                    </select>
                                </td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td width="25%" height="25" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_04")%></td>
                                <td class="data_td" width="75%" colspan="3">
                                    &nbsp; <input type="text" class="inputsubmit" name="menu_name" id="menu_name" value='<%=MENU_NAME%>' size="40">
								</td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td width="25%" height="25" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_05")%></td>
                                <td class="data_td" width="75%" colspan="3">
                                    &nbsp; <input type="text" class="input_data0" name="screen_id" id="screen_id" value='<%=SCREEN_ID%>' size="40">
								</td>
							</tr>
						</table>
						</td>
                		</tr>
            		</table>
						<div class="title_sub" style="padding-top: 20px;"><%=text.get("AD_031.LB_06")%></div>
						<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
						<table width="100%" border="0" cellspacing="0" bgcolor="#DBDBDB">
							<tr>
								<td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_07")%></td>
                                <td class="data_td">
                                    <input name="child_flag" id="child_flag" type="radio" class="radio" value="Y" CHECKED>
                                </td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_08")%></td>
                                <td class="data_td">
                                    <input name="child_flag" id="child_flag" type="radio" class="radio" value="N">
                                </td>
							</tr>
						</table>
						</td>
                		</tr>
            		</table>
						<div class="title_sub" style="padding-top: 5px;"><%=text.get("AD_031.LB_09")%></div>
						<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
						<td width="100%">
						<table width="100%" border="0" cellspacing="0" bgcolor="#DBDBDB">
							<tr>
								<td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_10")%></td>
                                <td class="data_td">
                                    <input name="sub_flag" id="sub_flag" type="radio" class="radio" value="N" CHECKED>
                                </td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_11")%></td>
                                <td class="data_td">
                                    <input name="sub_flag" id="sub_flag" type="radio" class="radio" value="Y">
                                </td>
							</tr>
						</table>
						</td>
                		</tr>
            		</table>
					</div>
					<div id="btn_area">
						<table border="0" cellspacing="3" cellpadding="0" align=right>
							<tr>
								<td><script language="javascript">btn("javascript:CheckNode('C')",	"<%=text.get("BUTTON.insert")%>");</script> </td>
								<td><script language="javascript">btn("javascript:CheckNode('R')",	"<%=text.get("BUTTON.update")%>");</script> </td>
								<td><script language="javascript">btn("javascript:CheckNode('D')",	"<%=text.get("BUTTON.deleted")%>");</script> </td>
								<td><script language="javascript">btn("javascript:parent.window.close();",	"<%=text.get("BUTTON.close")%>");</script> </td>
							</tr>
						</table>
					</div>
				</form>
			</div>
			<div id="right"
				style="width: 37%; height: 350px; float: left; padding: 0px 0px 0px 15px;">
				<div id="right_inner"
					style="background-color: #F1F2F6; width: 100%; height: 100%;">
					<div id="right_tree"
						style="background-color: #F1F2F6; padding: 5px 5px 5px 5px;"></div>
					<script>
                        var dhtmlxTree = null;
                        function setTreeDraw() {
                            dhtmlxTree = new dhtmlXTreeObject("right_tree", "100%", "100%", 0);
                            dhtmlxTree.setSkin('dhx_skyblue');
                            dhtmlxTree.setImagePath("../dhtmlx/dhtmlx_full_version/imgs/csh_bluefolders/");
                            dhtmlxTree.setLockedIcons("lock.gif","lock.gif","lock.gif");
                            dhtmlxTree.enableHighlighting(false);
                            dhtmlxTree.attachEvent(
                                            "onClick",
                                            function(id) {
                                                var use_flag = dhtmlxTree.getUserData(id, "useflag");
                                                var screen_id = dhtmlxTree.getUserData(id, "screenid");
                                                var menu_name = dhtmlxTree.getUserData(id, "menuname");
                                                var child_flag = dhtmlxTree.getUserData(id, "childflag");
                                                var menu_field_code = dhtmlxTree.getUserData(id, "menufieldcode");
                                                var menu_parent_field_code = dhtmlxTree.getUserData(id, "menuparentfieldcode");
                                                var order_seq = dhtmlxTree.getUserData(id, "orderseq");
                                                
                                                $("#use_flag").val(use_flag);
                                                $("#screen_id").val(screen_id);
                                                $("#menu_name").val(menu_name);
                                                $("#child_flag").val(child_flag);
                                                $("#folder_flag").val(child_flag);
                                                $("#menu_field_code").val(menu_field_code);
                                                $("#menu_parent_field_code").val(menu_parent_field_code);
                                                $("#order_seq").val(order_seq);
                                                $("input:radio[name=child_flag]").filter("[value="+child_flag+"]").prop("checked", true);
                                            });
                        }
                        function loadTree() {
                            var loadXMLUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.Menupop_tree?menu_object_code=<%=MENU_OBJECT_CODE%>";
                            dhtmlxTree.loadXML(loadXMLUrl);
                        }

						function recal() {
						    $('#right_tree').css('height', ($(window).height() - 100) + 'px');
						}
						$(window).resize(recal);
						$(recal);
                    </script>
				</div>
			</div>
		</div>
		<!-- JSP내용 추가 end _______________________________________________________________________________________________ -->
		<!-- ______________________________________________________________________________________________________________ -->

		<!-- Body End-->
	</s:header>
	<script>
    $(setTreeDraw);	
    $(loadTree);	
	</script>
</body>
</html>
