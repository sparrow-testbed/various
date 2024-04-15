<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_104_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	Configuration conf = new Configuration();
	String domain = CommonUtil.getConfig("sepoa.system.domain.name");// conf.getString("sepoa.system.domain.name");
  
	String screen_id = "SR_104_1";
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" src="../../jscomm/common.js" type="text/javascript"></script>
<script language="javascript" src="../../jscomm/menu.js" type="text/javascript"></script>

<Script language="javascript">

	function help(){
		var url = "<%=domain%>/help/<%=screen_id%>.htm";
		var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'yes';
        var title = "Help";
        var left = "100";
        var top = "100";
        var width = "800";
        var height = "600";
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();

	}
	
	
	function setTreeProperty(sg_refitem, parent_no, level) {

		f = document.tree;
		f.parent_no.value = parent_no;
		f.level.value = level;
		f.sg_refitem.value = sg_refitem;

	}

	function setSgName(sg_name){
		f = document.tree;
		f.sg_name.value = sg_name;
	}

	function insertChildRow(){
		f = document.tree;
		f.mode.value = "tree_ins";

		if(f.sg_name.value == '') {
			//alert('소싱그룹이름을 입력하십시요.');
			alert("<%=text.get("소싱그룹이름을 입력하십시요.")%>");
			return;
		}
		if(f.sg_refitem.value == 'undefined') {
			
			//alert('상위 소싱그룹을 선택하십시요.');
			alert("<%=text.get("상위 소싱그룹을 선택하십시요.")%>");
			return;
		}
		f.target = "tree_fr";

		f.level.value = parseInt(f.level.value) + 1;

		f.parent_no.value = f.sg_refitem.value;
		
		if(f.level.value == "4") {
			alert("최하위 노드입니다. 하위에 더이상 소싱그룹을 만들수 없습니다.");
			return;
		}
		f.action = "scg_meaning_main_pop.jsp";
		f.submit();

	}

	function insertRow_SG()
	{
		f = document.tree;
		f.mode.value = "tree_ins";
		if(f.sg_name.value == '') {
			//alert('소싱그룹이름을 입력하십시요.');
			alert("<%=text.get("소싱그룹이름을 입력하십시요.")%>");
			return;
		}
		f.target = "tree_fr";
		if(f.sg_refitem.value == "undefined") {
			f.level.value = "1";
			f.parent_no.value = "";
		}

		f.action = "scg_meaning_main_pop.jsp";
		f.submit();

	}

	function updateRow_SG(){

		f = document.tree;
		f.mode.value = "tree_up";
		if(f.sg_name.value == '') {
			//alert('소싱그룹 이름을 입력하십시요.');
			alert("<%=text.get("소싱그룹 이름을 입력하십시요.")%>");
			return;
		}

		if(f.sg_refitem.value == 'undefined') {
			//alert('수정할 소싱그룹을 선택하십시요.');
			alert("<%=text.get("수정할 소싱그룹을 선택하십시요.")%>");
			return;
		}

		f.target = "tree_fr";
		f.action = "scg_meaning_main_pop.jsp";
		f.submit();

	}

	function deleteRow_SG(){
		f = document.tree;

		var sg_refitem = f.sg_refitem.value // ( 자신의 번호 )
		var parent_no  = f.parent_no.value  // ( 부모의 번호 )
		var level      = f.level.value      // ( 자신의 레벨 )
		
		if(f.sg_refitem.value == 'undefined') {
			alert("<%=text.get("삭제할 소싱그룹을 선택하십시오.")%>");
			return;
		}
		
		var f     = document.forms[0];
    	var param  = "?sg_refitem=" + sg_refitem;
    	    param += "&parent_no="  + parent_no;
    	    param += "&level="      + level;
		
		f.method = "POST";
		f.target = "childFrame";
		f.action = "sg_delCheck.jsp" + param;
		f.submit();		
				
		
	}
	
	function setdeleteRow_SG( count ){
		if( count > 0 ){
			alert("심사표로 등록이 되어있는 항목입니다. 삭제할 수 없습니다.");
			return;
		}
		
		var value = confirm('<%=text.get("MESSAGE.1015")%>');
		if( !value ) return;
		
		f            = document.tree;
		f.mode.value = "tree_del";		
		f.target     = "tree_fr";
		f.action     = "scg_meaning_main_pop.jsp";
		f.submit();	
	}
	
	function setRefItem(sg_refitem, level, sg_parent_refitem){

		f = document.tree;

		if(level != 3) {
			return;
		}

		f.sg_refitem.value = sg_refitem;
		f.level.value = level;
		f.parent_no.value = sg_parent_refitem;
		f.mode.value = "view";
		f.target = "definition";

		f.action = "scg_meaning.jsp";
		f.submit();
	}

	var doc;
	function se_pop(){

		if(doc) {
			doc.close();
		}

		f = document.tree;
		var left = 0;
		var top = 0;
		var width = 500;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'no';
		var resizable = 'no';

		if(f.level.value == '' || f.level.value == 'undefined') {
			//alert('소분류를 선택해주세요.');
			alert("<%=text.get("SR_104_1.MSG_0106")%>");
			return;
		}
		if(parseInt(f.level.value) < 3) {
			//alert('소분류를 선택해주세요.');
			alert("<%=text.get("SR_104_1.MSG_0106")%>");
			return;
		}

<%--	var url = "sou_se_pop.jsp?sg_refitem=" + f.sg_refitem.value; --%>
		var url = "scg_meaning_main_search.jsp?sg_refitem=" + f.sg_refitem.value;
		doc = window.open( url, 'doc', 'left=250, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	function map_pop() {
		if(doc) {
			doc.close();
		}
		f = document.tree;
		var left = 0;
		var top = 0;
		var width = 500;
		var height = 180;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';

		if(f.level.value == '' || f.level.value == 'undefined') {
			//alert('소분류를 선택해주세요.');
			alert("<%=text.get("SR_104_1.MSG_0106")%>");
			return;
		}
		if(parseInt(f.level.value) < 3) {
			//alert('소분류를 선택해주세요.');
			alert("<%=text.get("SR_104_1.MSG_0106")%>");
			return;
		}

		var url = "scg_meaning_main_maping.jsp?sg_refitem=" + f.sg_refitem.value;
		doc = window.open( url, 'doc', 'left=200, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	function sg_update() {
		f = document.tree;

		if(f.sg_refitem.value == "undefined"){
			alert('소싱 그룹을 소분류까지 선택해주세요');
			//alert("<%=text.get("SR_104_1.MSG_0107")%>");
			return;
		}
		this.definition.sg_update();

	}
	
	function calHeight(obj){
		var the_height = document.documentElement.clientHeight - 220;
		obj.height = the_height;
	}

	</SCRIPT>

	</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" >
<s:header>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "소싱그룹정의";
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "true";
%>
	<tr>
		<td height="100%" valign="top">
		<table height="100%" border="0" cellpadding="0" cellspacing="0"> 
			<tr>
				<td width="10" height="100%" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_left.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="10" height="100%"></td>
				<td width="100%" align="center" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_top.gif); background-repeat:repeat-x; background-position:top; padding:5px;word-breakbreak-all">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" > 
				<%@ include file="/include/sepoa_milestone.jsp"%>  
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="10" colspan="2"></td>
							</tr> 
						</table>
					<table width="97%" height="80%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB" >
								<form name="tree" method="post" action="">
									<input type="hidden" name="mode">
									<input type="hidden" name="parent_no">
									<input type="hidden" name="level">
									<input type="hidden" name="sg_refitem">
									<input type="hidden" name="temp_level">
									<input type="hidden" name="sg_type"> 
						<tr>
							<td width="33%"> 
									<iframe name="tree_fr" frameborder="0" marginwidth="10" marginheight="10" src="scg_meaning_main_pop.jsp" width="100%" onload="javascript:calHeight(this);"></iframe>
							</td>
							<td width="67%"> 
									<iframe id="def" name="definition" frameborder="0" marginwidth="0" src="scg_meaning.jsp" width="100%" height="100%" onload="javascript:calHeight(this);"></iframe>
							</td>
						</tr>
					</table>  
					<table width="97%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB" >
						<tr> 
							<td  width="33%">
								<table bgcolor="#FFFFFF" width="100%">
									<tr>
										<td width="30%" class="cell_title" align="center"> 
															소싱그룹명:
										</td>
										<td  width="70%" class="cell_data">
															&nbsp;
															<input type="text" name="sg_name" size="20" class="text" value="">
										</td>
									</tr>
									<tr> 
										<td colspan="2" height="30">
											<TABLE cellpadding="0">
												<TR>
											    	<TD><script language="javascript">btn("javascript:insertChildRow()", "하위추가")    </script></TD>
													<TD><script language="javascript">btn("javascript:insertRow_SG()", "추가")   </script></TD>
												    <TD><script language="javascript">btn("javascript:updateRow_SG()", "수정")</script></TD>
													<TD><script language="javascript">btn("javascript:deleteRow_SG()", "삭제")</script></TD>
										    	 </TR>
										      	</TABLE>
										  </td>
									</tr>
								   </table>
							    </td>
							    <td width="67%" bgcolor="#FFFFFF"  align="left"> 
								<TABLE width="100%" cellpadding="0" bgcolor="#FFFFFF">
									<TR>
										<td width="80%"></td>
								    	  	<TD><script language="javascript">btn("javascript:sg_update()", "<%=text.get("BUTTON.save")%>")    </script></TD>
								    	</TR>
							      	</TABLE>
							    </td>
						    </tr>  
					    </table> 
					</form>  
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
<s:footer/>
</body>
</html>
