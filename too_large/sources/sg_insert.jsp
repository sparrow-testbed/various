<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:                 sou_tb_lis1.jsp <p>
 Description:           SUPPLY / ADMIN /  소싱그룹정의서 트리메뉴 <p>
 Copyright:             Copyright (c) <p>
 Company:               ICOMPIA <p>
 @author                SHYI<p>
 @version
 @Comment
--%>
<%-- <% String WISEHUB_PROCESS_ID="SR_001";%>
<% String WISEHUB_LANG_TYPE="KR";%> --%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=euc-kr"> -->
<script language="javascript" src="../../jscomm/common.js" type="text/javascript"></script>
<script language="javascript" src="../../jscomm/menu.js" type="text/javascript"></script>
<SCRIPT LANGUAGE="JavaScript" type="text/javascript">

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
			alert('소싱그룹이름을 입력하십시요.');
			return;
		}
		if(f.sg_refitem.value == 'undefined') {
			alert('상위 소싱그룹을 선택하십시요.');
			return;
		}
		f.target = "tree_fr";
		f.level.value = parseInt(f.level.value) + 1;

		f.parent_no.value = f.sg_refitem.value;
		if(f.level.value == "4") {
			alert("최하위 노드입니다. 하위에 더이상 소싱그룹을 만들수 없습니다.");
			return;
		}

		f.action = "sou_tree_frame.jsp";
		f.submit();

	}

	function insertRow_SG()
	{
		f = document.tree;
		f.mode.value = "tree_ins";
		if(f.sg_name.value == '') {
			alert('소싱그룹이름을 입력하십시요.');
			return;
		}
		f.target = "tree_fr";
		if(f.sg_refitem.value == "undefined") {
			f.level.value = "1";
			f.parent_no.value = "";
		}

		f.action = "sou_tree_frame.jsp";
		f.submit();

	}

	function updateRow_SG(){

		f = document.tree;
		f.mode.value = "tree_up";
		if(f.sg_name.value == '') {
			alert('소싱그룹 이름을 입력하십시요.');
			return;
		}

		if(f.sg_refitem.value == 'undefined') {
			alert('수정할 소싱그룹을 선택하십시요.');
			return;
		}

		f.target = "tree_fr";
		f.action = "sou_tree_frame.jsp";
		f.submit();

	}

	function deleteRow_SG(){

		f = document.tree;
		f.mode.value = "tree_del";
		if(f.sg_refitem.value == 'undefined') {

			alert('삭제할 소싱그룹을 선택하십시요.');
			return;
		}
		var value = confirm('삭제 하시겠습니까?');
		if(!value) {
			return;
		}
		f.target = "tree_fr";
		f.action = "sou_tree_frame.jsp";
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

		f.action = "sou_def_frame.jsp";
		f.submit();
	}

	var doc;
	function se_pop(){

		if(doc) {
			doc.close();
		}

		//f = document.tree;
		var left = 0;
		var top = 0;
		var width = 500;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'no';
		var resizable = 'no';

		f = document.form1;
		if(f.sgrefitem.value == "undefined" || f.sgrefitem.value == ""){
			alert('소분류를 선택해주세요.');
			return;
		}
		if(f.level_count.value == '' || f.level_count.value == 'undefined') {
			alert('소분류를 선택해주세요.');
			return;
		}
		if(parseInt(f.level_count.value) < 3) {
			alert('소분류를 선택해주세요.');
			return;
		}

<%--	var url = "sou_se_pop.jsp?sg_refitem=" + f.sg_refitem.value; --%>
		var url = "sg4_list.jsp?sg_refitem=" + f.sgrefitem.value;
		doc = window.open( url, 'doc', 'left=250, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	function map_pop() {
		if(doc) {
			doc.close();
		}
		f = document.form1;
		var left = 0;
		var top = 0;
		var width = 500;
		var height = 180;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		
		f = document.form1;
		if(f.sgrefitem.value == "undefined" || f.sgrefitem.value == ""){
			alert('소분류를 선택해주세요.');
			return;
		}
		if(f.level_count.value == '' || f.level_count.value == 'undefined') {
			alert('소분류를 선택해주세요.');
			return;
		}
		if(parseInt(f.level_count.value) < 3) {
			alert('소분류를 선택해주세요.');
			return;
		}

		var url = "sg4_insert.jsp?sg_refitem=" + f.sgrefitem.value;
		alert('url : ' + url);
		doc = window.open( url, 'doc', 'left=200, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	function sg_update() {
		f = document.form1;
		if(f.sgrefitem.value == "undefined" || f.sgrefitem.value == ""){
			alert('소싱 그룹을 소분류까지 선택해주세요');
			return;
		}
		if(f.sgname.value == '') {
			alert('소싱그룹 이름을 입력해주세요.');
			return;
		}

// 		if(f.st_num.value == ''){
// 			if(f.noticedivision[0].checked){
// 				alert("업체등록평가 템플릿의 값이 없으면 게시할 수 없습니다.");
// 				return;
// 			}
// 		}

		if(f.noticedivision[0].checked) {
			f.is_notice.value = "Y";
		}else{
			f.is_notice.value = "N";
		}
		if(f.user_id.value == '') {
			alert('담당자를 입력해주세요.');
			return;
		}
		var nickName        = "SR_001";
	    var conType         = "TRANSACTION";
	    var methodName      = "setSgUpdate";
	    var SepoaOut        = doServiceAjax( nickName, conType, methodName );
	    
	    if( SepoaOut.status == "1" ) { // 성공
	    	alert("저장되었습니다.");
	    } else {
	        if(SepoaOut.message == "null"){
	            alert("<%=text.get ( "CT_001.TXT_030" ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
	        }else{
	            alert(SepoaOut.message);
	        }
	    }

	}

	function sg_attach_download() {
		f = document.tree;

		if(f.sg_refitem.value == "undefined"){
			alert('소싱 그룹을 소분류까지 선택해주세요');
			return;
		}
		this.definition.sg_attach_download();
	}
	

</SCRIPT>



<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}

function PopupManager(part)
{
	var url = "";
	var f = document.form1;

	if(part == "s_tmp")
	{
		var arrValue = new Array();
		var arrDesc = new Array();

		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "";
		
		arrDesc[0] = "템플릿명";

		PopupCommonArr("SP6001","SP6001_getCode",arrValue,arrDesc);
	}
	else if(part == "c_tmp")
	{
		var arrValue = new Array();
		var arrDesc = new Array();

		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "";
		
		arrDesc[0] = "템플릿명";

		PopupCommonArr("SP6002","SP6002_getCode",arrValue,arrDesc);
	}
	else if(part == "username")
	{
		var arrValue = new Array();
		var arrDesc = new Array();

		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "";
		
		arrDesc[0] = "템플릿명";

		PopupCommonArr("SP6011","SP6011_getCode",arrValue,arrDesc);
	}
	
}

function  SP6001_getCode(code, text1, text2, text3) {
	document.form1.st_num.value = code;
	document.form1.st.value = text1;
}

function  SP6002_getCode(code, text1, text2, text3) {
	document.form1.ct_num.value = code;
	document.form1.ct.value = text1;
}

function  SP6011_getCode(code, text1, text2, text3) {
	document.form1.user_id.value = code;
	document.form1.username.value = text1;
}

/*
tree 세팅
*/
var treeObj = null;

function treeInit(){
	treeObj = new SepoaDhtmlXTreeObject("left_tree","100%","100%");
	//treeObj.enableDynamicOpen(true);
	treeObj.setEditable(true);	//저장일 때 true
	treeObj.addProperty("text", "name");		//노드추가 옵션
	treeObj.setUrl("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg_insert");
	treeObj.doQuery();
	
	//필수
	//tree화면에 나타날 데이터의 컬럼명 지정
}
function recal() {
    $('#left_tree').css('height', ($(window).height() - 170) + 'px');
 }
$(document).ready(function(){
    
	$(window).resize(recal);
    $(recal);
});

//tree를 클릭했을때 이벤트 지정
function treeClicked(id) {
	var f1=document.form1;
	document.getElementById("sg_refitem").value = treeObj.getUserData(id,"sg_refitem");
 	//document.getElementById("account_code").value = treeObj.getUserData(id,"account_code");
 	//document.getElementById("sg_name").value = treeObj.getUserData(id,"sg_name");
 	document.getElementById("sgrefitem").value = treeObj.getUserData(id,"sg_refitem");
 	document.getElementById("level_count").value = treeObj.getUserData(id,"level_count");
 	//document.tree.sg_name.value=treeObj.getUserData(id,"sg_name");
 	/* document.getElementById("is_leaf").value = treeObj.getUserData(id,"is_leaf");
 	document.getElementById("is_use").value = treeObj.getUserData(id,"is_use");
 	document.getElementById("parent_sg_refitem").value = treeObj.getUserData(id,"parent_sg_refitem");
 	document.getElementById("level_count").value = treeObj.getUserData(id,"level_count"); */
 	if(treeObj.getUserData(id,"level_count") != 3) {
		return;
 	}
	doQuery();
	
}

//팝업창에서 확인하였을 때
function popupConfirm(map) {
	var text = map.get("text");
	if(text == ""){
		alert("<%=text.get("MT_204.MSG1")%>");
		return;
	}
	treeObj.doTreeSave(map);
}

//팝업창에서 닫기하였을 때
function popupClose() {
	treeObj.popupClose(); 
}

function doTreeSaveEnd(obj)
{
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");
	var id = obj.getAttribute("id");
	var sg_refitem   = obj.getAttribute("sg_refitem");
	var level_count   = obj.getAttribute("level_count");
	//alert("message="+message+"!mode="+mode);
	//alert("!status="status+"!id="+id);
	//alert("!sg_refitem="+sg_refitem);
	//var account_code = obj.getAttribute("account_code");
	var flag   = obj.getAttribute("flag");
	if(flag=="false_1"){
		alert("최하위 노드입니다. 하위에 더이상 소싱그룹을 만들수 없습니다.");
		location.href="sg_insert.jsp";
	}else if(flag=="false_2"){
		alert("소싱그룹과 동등한 노드를 만들수 없습니다.");
		location.href="sg_insert.jsp";
	}else{
		treeObj.closeProgressBar();
		
		if(status == "true") {
			treeObj.setUserData(id, "sg_refitem", sg_refitem);
			treeObj.setUserData(id, "level_count", level_count);
			alert("<%=text.get("MESSAGE.0001")%>");
			
			//doAddRow();
			document.getElementById("sg_refitem").value = treeObj.getUserData(id,"sg_refitem");
			//document.getElementById("sgrefitem").value = treeObj.getUserData(id,"sg_refitem");
			//document.getElementById("level_count").value = treeObj.getUserData(id,"level_count");

		} 
	}
	return false;
}

function doQuery(){
	var f1=document.form1;
	var nickName        = "SR_001";
    var conType         = "CONNECTION";
    var methodName      = "getNodeInfo";
    var SepoaOut        = doServiceAjax( nickName, conType, methodName );
    // SepoaOut.result[0] << setValue
    
    
    if( SepoaOut.status == "1" ) { // 성공
    	document.getElementById("sgrefitem").value = SepoaOut.result[0];
    	document.getElementById("sgname").value = SepoaOut.result[1];
    	document.getElementById("definition").value = SepoaOut.result[2];
//     	document.getElementById("remark").value = SepoaOut.result[3];
    	document.getElementById("is_notice").value = SepoaOut.result[4];
    	if(SepoaOut.result[4]=="Y"){
    		document.getElementsByName("noticedivision")[0].checked=true;
    	}else{
    		document.getElementsByName("noticedivision")[1].checked=true;
    	}
    	//document.getElementById("st").value = SepoaOut.result[5];
//     	document.getElementById("ct").value = SepoaOut.result[6];
    	document.getElementById("condition").value = SepoaOut.result[7];
//     	document.getElementById("st_num").value = SepoaOut.result[8];
//     	document.getElementById("ct_num").value = SepoaOut.result[9];
    	document.getElementById("user_id").value = SepoaOut.result[10];
    	document.getElementById("username").value = SepoaOut.result[11];
//     	document.getElementById("type").value = SepoaOut.result[12];
//     	document.getElementById("ATTACH_NO").value = SepoaOut.result[13];
//     	document.getElementById("FILE_NAME").value = SepoaOut.result[14];
    } else {
        if(SepoaOut.message == "null"){
            alert("<%=text.get ( "CT_001.TXT_030" ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
        }else{
            alert(SepoaOut.message);
        }
    }
    
}

function setAttach(attach_key, arrAttrach, attach_count) {


    var attachfilename  = arrAttrach + "";
    var result 			="";

	var attach_info 	= attachfilename.split(",");

	for (var i =0;  i <  attach_count; i ++)
    {
	    var doc_no 			= attach_info[0+(i*7)];
		var doc_seq 		= attach_info[1+(i*7)];
		var type 			= attach_info[2+(i*7)];
		var des_file_name 	= attach_info[3+(i*7)];
		var src_file_name 	= attach_info[4+(i*7)];
		var file_size 		= attach_info[5+(i*7)];
		var add_user_id 	= attach_info[6+(i*7)];

		if (i == attach_count-1)
			result = result + src_file_name;
		else
			result = result + src_file_name + ",";
	}

	document.forms[1].ATTACH_NO.value = attach_key;
	document.forms[1].FILE_NAME.value = result;

}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

//지우기
function doRemove( type ){
    if( type == "user_id" ) {
    	document.form1.user_id.value = "";
        document.form1.username.value = "";
    }  
}
</script>


</head>
<body onload="treeInit();" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">

<s:header>
<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1"><!-- <img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle"> -->
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>
<br>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="98%" height="90%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
				<tr>
					<td width="40%">
						<form name="tree" method="post" action="">
							<!-- <input type="hidden" name="mode" id="mode">
							<input type="hidden" name="parent_sg_refitem" id="parent_sg_refitem">
							<input type="hidden" name="level" id="level">
							<input type="hidden" name="is_leaf" id="is_leaf">
							<input type="hidden" name="is_use" id="is_use">
							<input type="hidden" name="sg_name" id="sg_name"  value=""> -->
							<!-- <input type="hidden" name="level_count" id="level_count"> -->
							<input type="hidden" name="sg_refitem" id="sg_refitem">
							<!-- <input type="hidden" name="temp_level" id="temp_level">
							<input type="hidden" name="sg_type" id="sg_type"> -->

							<!-- <iframe name="tree_fr" frameborder="1" marginwidth="10" marginheight="10" src="sou_tree_frame.jsp" width="100%" height="75%"></iframe> -->
							<!-- <div id="left" style="width: 95%; height: 550px; float: left; padding: 0px 0px 0px 15px;">
								<div id="left_inner" style="background-color: #F1F2F6; width: 100%; height: 100%;fixed;">
									<div id="left_tree" style="background-color: #F1F2F6; padding: 5px 5px 5px 5px;">
										
									</div>
								</div>
							</div> -->
							<table id="left" style="width: 95%; height: 550px; float: left; padding: 0px 0px 0px 15px;">
								<tr id="left_inner" style="background-color: #F1F2F6; width: 100%; height: 100%;fixed;">
									<td id="left_tree" style="background-color: #F1F2F6; padding: 5px 5px 5px 5px;"></td>
								</tr>
							</table>
							<%-- <table>
								<tr>

									<td width="35%" class="title_td_1">
										<img src="img" width="9" height="9"> 소싱그룹명
									</td>
									<td width="65%" class="data_td">
										<input type="text" name="sg_name" id="sg_name" size="25" class="text" value="">
									</td>
								</tr>

								<tr>
									<td width="30%" class="cell_title">
										소싱그룹 타입
									</td>
									<td width="70%" class="cell_data">
										<input type="radio" name="sg_type_radio" checked>
										구매
										<input type="radio" name="sg_type_radio">
										제작
									</td>
								</tr>

								<form action=""></form>
							</table> --%>
							<%-- <table>
								<tr>
								</tr>
								<tr align="center">
									<td height="30" align="left">
									<TABLE cellpadding="0">
							      		<TR>
						    	  			<TD><script language="javascript">btn("javascript:insertChildRow()","하위추가")    </script></TD>
											<TD><script language="javascript">btn("javascript:insertRow_SG()","추 가")   </script></TD>
							      			<TD><script language="javascript">btn("javascript:updateRow_SG()","수 정")</script></TD>
											<TD><script language="javascript">btn("javascript:deleteRow_SG()","삭 제")</script></TD>

						    	  		</TR>
					      			</TABLE>
					      			</td>
								</tr>
							</table> --%>
						</form>
					</td>
					<td width="60%" valign="top">
						<!-- <iframe id="def" name="definition" frameborder="1" marginwidth="0" src="sou_def_frame.jsp" width="100%" height="75%"></iframe> -->
						<div id="menu_mode">
						<table width="100%" border="0" cellspacing="0" cellpadding="1">
							<tr>
							<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
							<tr>
							<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<form name="form1" action="" method="post" >
								<%-- <input type="hidden" name="attach_no" id="attach_no" value=""> --%>
								<input type="hidden" name="attach_count" id="attach_count" value="">
								<input type="hidden" name="attach_gubun" id="attach_gubun" value="body"> 
								<input type="hidden" name="att_mode" id="att_mode" value="">
								<input type="hidden" name="view_type" id="view_type" value="">
								<input type="hidden" name="file_type" id="file_type"  value="">
								<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
							<tr>
								<td class="title_td" nowrap>&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱그룹명
								</td>
								<td class="data_td" nowrap>
									<input type="hidden" name="sgrefitem" id="sgrefitem" value="">
									<input type="hidden" name="level_count" id="level_count">
									<input type="text" class="text" size="50" name="sgname" id="sgname" value="<%-- <%=sg_name%> --%>" onKeyUp="return chkMaxByte(150, this, '소싱그룹명');">
							              	</td>
							           	</tr>
<!-- 							<tr> -->
<!-- 								<td class="title_td"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 구매조직 -->
<!-- 								</td> -->
<!-- 								<td class="data_td" nowrap> -->
<%-- 									<input type="text" class="text" size="50" name="type" id="type" value="<%=type%>" readonly > --%>
<!-- 							                  </td> -->
<!-- 							             	</tr> -->
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
							<tr>
								<td class="title_td" vlign="top" nowrap>&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;정의</td>
								<td class="data_td" nowrap>
									<textarea class="textarea" rows="4" cols="45" name="definition" id="definition"  onKeyUp="return chkMaxByte(1000, this, '정의');"><%-- <%=sg_def%> --%></textarea>
							                  </td>
							               </tr>
							
<!-- 							<tr> -->
<!-- 								<td class="title_td" vlign="top" nowrap><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 공급업체특이사항</td> -->
<!-- 								<td class="data_td" nowrap> -->
<%-- 								  <textarea class="textarea" rows="4" cols="45" name="remark" id="remark"><%=remark%></textarea> --%>
<!-- 							                  </td> -->
<!-- 							               </tr> -->
							
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
							<tr>
								<td class="title_td" nowrap>&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱그룹 게시여부</td>
								<td class="data_td" nowrap>
							       	게시<input type=radio name="noticedivision" id="noticedivision" checked value="Y" class=radio <%-- <%if(notice.equals("Y")) {%>checked<%}%> --%>>
										
									미게시<input type=radio name="noticedivision" id="noticedivision" value="N" class=radio <%-- <%if(notice.equals("N")) {%>checked<%}%> --%>>
									<input type="hidden" name="is_notice" id="is_notice">
							                  </td>
							             	</tr>
<!-- 							<tr> -->
<!-- 								<td class="title_td" nowrap><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 업체등록평가 템플릿</td> -->
<!-- 								<td class="data_td" nowrap> -->
<%-- 									<input type="text" size=30 name="st" id="st" readonly class="readonly_text" value="<%=s_temp%>"> --%>
<%-- 									<input type=button class=button_1 value="선택"  onClick="javascript:tmp_pop('s_tmp');" style="cursor:hand"> --%>
<!-- 									<a href="javascript:PopupManager('s_tmp');"><img src="/images/icon/icon_search.gif" border="0" align="absmiddle"></a> -->
<%-- 									<input type="hidden" name="st_num" id="st_num" value="<%=st_num%>"> --%>
<!-- 							                  </td> -->
<!-- 							               </tr> -->
<!-- 							 <tr> -->
<!-- 							      <td class="title_td" nowrap><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 체크리스트 템플릿</td> -->
<!-- 							      <td class="data_td" nowrap> -->
<%-- 								  	<input type="text" size=30 name="ct" id="ct" readonly class="readonly_text" value="<%=c_temp%>"> --%>
<%-- 								 	<input type=button class=button_1 value="선택"  onClick="javascript:tmp_pop('c_tmp');" style="cursor:hand" > --%>
<!-- 							                  	<a href="javascript:PopupManager('c_tmp');"><img src="/images/icon/icon_search.gif" border="0" align="absmiddle"></a> -->
<%-- 							                  	<input type="hidden" name="ct_num" id="ct_num" value="<%=ct_num%>"> --%>
<!-- 							                  </td> -->
<!-- 							               </tr> -->
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
							 <tr>
							      <td class="title_td" vlign="top" nowrap>&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급사 구비조건</td>
							      <td class="data_td" nowrap>
								  	<textarea class="textarea" rows="4" cols="45" name="condition" id="condition"  onKeyUp="return chkMaxByte(1500, this, '공급사 구비조건');"><%-- <%=condition%> --%></textarea>
							                  </td>
							               </tr>
							 <tr>
							 	<td class="title_td" nowrap>&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자</td>
							 	<td class="data_td" nowrap>
							 		<input type="hidden" name="user_id" id="user_id" value="<%-- <%=user_id%> --%>">
							 		<input type="text" size=12 name="username" id="username" value="<%-- <%=charge%> --%>" readonly class="readonly_text">
							               		<input type="hidden" name="urefitem" value="">
									<a href="javascript:PopupManager('username');"><img src="/images/ico_zoom.gif" border="0" align="absmiddle"></a>
									<a href="javascript:doRemove('user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							 	</td>
							 </tr>
<!-- 							<tr> -->
<!-- 								<td width="15%" class="title_td"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 첨부파일</td> -->
<!-- 								<td class="data_td" colspan="3" height="200"> -->
<!-- 									<TABLE > -->
<!-- 						      			<TR> -->
<!-- 						      				<td><input type="text" name="FILE_NAME" id="FILE_NAME" class="inputsubmit" size="80" readonly"></td> -->
<!-- 											<td><input type="hidden" name="ATTACH_NO" id="ATTACH_NO"> attach_key    </td> -->
<%-- 									        <td><script language="javascript">btn("javascript:attach_file(document.forms[1].ATTACH_NO.value,'NOT')","<%=text.get("BUTTON.add-file")%>")</script></td> --%>
<!-- 						   	  			</TR> -->
<!-- 									</TABLE> -->
									
<!-- 									<iframe name="attachFrame" width="380" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe> -->
<!-- 									<br>&nbsp; -->
<!-- 								</td> -->
<!-- 							</tr> -->
							</table>
							   		</td>
   	</tr>
 	</table>
 	</td>
   	</tr>
 	</table>
							</form>
							</div>
						
						<table width="87%" border="0" cellspacing="0" cellpadding="0">
							<tr align="center">

								<td height="30" align="right">
									<TABLE cellpadding="0">
							      		<TR>
<%-- 						    	  			<TD><script language="javascript">btn("javascript:sg_attach_download()","다운로드")    </script></TD> --%>
						    	  			<TD><script language="javascript">btn("javascript:sg_update()","저 장")    </script></TD>
<%-- 											<TD><script language="javascript">btn("javascript:se_pop()","세분류 조회")   </script></TD> --%>
<%-- 							      			<TD><script language="javascript">btn("javascript:map_pop()","세분류 매핑")</script></TD> --%>
						    	  		</TR>
					      			</TABLE>
					      		</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</s:header>
<s:footer/>
</body></html>


