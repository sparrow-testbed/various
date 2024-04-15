<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_019");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_019";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
%>
<!--
 Title:        	업체평가 생성 <p>
 Description:  	업체평가 생성 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	SHYI<p>
 @version      	1.0.0<p>
 @Comment       업체평가 생성
!-->
<!--  Session 값 -->
<%
	String house_code = info.getSession("HOUSE_CODE");
	String fromdate = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), 0);
	String todate = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), 1);
	
%>

<html>
<head>
<title>
	<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
<!--	
var INDEX_SEL;
var INDEX_VALUER;
var INDEX_QTY_YN;
var INDEX_VALUE_ID;
var INDEX_SG_REFITEM;

function Init() 
{
	setGridDraw();
	doRequestUsingPOST( 'SL0116', '1#'+"<%=house_code%>" ,'MATERIAL_TYPE', '' );
}

function getLastDate(str)
{
    var yy,mm,ny,nm;
    var arr_d;
	var error = "99";

    if(str.length != 6)
    {
		alert("다음과 같은 형식으로 입력하십시요[200704]");
        return error;
    }

    yy = str.substring(0,4);// 년, 월을 문자열로 가지고 있는다.
    mm = str.substring(4,6);

    if(mm < '10')// patch 판
    {
        mm = mm.substring(1);// patch 판
    }

    ny = parseInt(yy);      // 년, 월을 정수형으로 가지고 있는다.
    nm = parseInt(mm);

    if(!(Number(yy)) || (ny < 1000) || (ny>9999))
    {
        alert('년도를 입력하시요.');
        return error;
    }

    if(!(Number(mm)) || (nm < 1) || (nm > 12))
    {
        alert('월을 입력하시요.');
        return error;
    }

    arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31')

    if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0)) 
    	arr_d[1] = 29;

	return arr_d[nm-1];
  }

function setHeader() 
{

	INDEX_SEL 			= GridObj.GetColHDIndex("sel");
	INDEX_VALUER 		= GridObj.GetColHDIndex("valuer");
	INDEX_QTY_YN 		= GridObj.GetColHDIndex("qty_yn");
	INDEX_VALUE_ID 		= GridObj.GetColHDIndex("value_id");
	INDEX_SG_REFITEM 	= GridObj.GetColHDIndex("sg_refitem");
}

function Query() 
{
	var evaltemp_num 	= document.form1.evaltemp_num.value;
	var selectedSg 		= document.form1.selectedSg.value;

	if(document.form1.evaltemp_num.value == "")
	{
		alert("평가템플릿을 선택해야 합니다.");
		document.form1.evaltemp.focus();
		return;
	}
	var mode_type = ""; 
	var paramvalue = "";

	
	// 대분류 중분류 선택여부 확인
	if(form1.MATERIAL_TYPE.value != "" &&
	   form1.MATERIAL_CTRL_TYPE.value == "" &&
	   form1.MATERIAL_CLASS1.value == "" ){  // 대분류일 경우
		mode_type = "ITEM1";
		paramvalue = form1.MATERIAL_TYPE.value;
	}else if(form1.MATERIAL_TYPE.value != "" &&
  		     form1.MATERIAL_CTRL_TYPE.value != "" &&
  		 	 form1.MATERIAL_CLASS1.value == "" ){  // 중분류일 경우
		mode_type = "ITEM2";
		paramvalue = form1.MATERIAL_CTRL_TYPE.value;
	}else{
		if(document.form1.selectedSg.length > 0) {		// 추가 리스트 등록시
			for (i = document.form1.selectedSg.length - 1; i >= 0;  i--) {
				paramvalue = paramvalue + form1.selectedSg.options[i].value;
				if (i != 0) {
					paramvalue = paramvalue + "','";
				}
			}
			mode_type = "ITEM3";
	  	}  
	  	else{
	  		alert('선택된 소싱그룹이 없습니다.');
	  		return;	
	  	}	
	}
	
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_insert";
	var grid_col_id = "<%=grid_col_id%>";
	var param = "mode=getEvaList&grid_col_id="+grid_col_id;
	param +="&evaltemp_num="+evaltemp_num;
	param +="&sg_refitem="+paramvalue;
	param +="&mode_type="+mode_type;
	param += dataOutput();
	GridObj.post(servletUrl, param);
	GridObj.clearAll(false);
}

function entKeyDown() 
{
	if(event.keyCode==13) 
	{
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		Query();
	}
}

function MATERIAL_TYPE_Changed()
{
	clearMATERIAL_CTRL_TYPE();
	clearMATERIAL_CLASS1();
	var newOption = document.createElement('OPTION');
	newOption.text="전체";
	newOption.value="";
	var house_code = "<%=house_code%>";
	var code = "2";
	var value = form1.MATERIAL_TYPE.value;
	document.form1.MATERIAL_CTRL_TYPE.add(newOption, null);
	doRequestUsingPOST( 'SL0121', house_code+'#'+code+'#'+value ,'MATERIAL_CTRL_TYPE','' );
	/* var id = "SL0121";
	var code = "2";

	var value = form1.MATERIAL_TYPE.value;
	target = "MATERIAL_CTRL_TYPE";

	data = "/kr/master/sg/sou_bd_lis1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    document.childFrame.location.href = data; */
}

function clearMATERIAL_CTRL_TYPE()
{
	if(form1.MATERIAL_CTRL_TYPE.length > 0)
	{
		for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
			form1.MATERIAL_CTRL_TYPE.options[i] = null;
		}
	}
}

function clearMATERIAL_CLASS1()
{
	if(form1.MATERIAL_CLASS1.length > 0)
	{
		for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--)
		{
			form1.MATERIAL_CLASS1.options[i] = null;
		}
	}
}

function setMATERIAL_CLASS1(name, value)
{
	var option1 = new Option(name, value, true);
	form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
}

function setMATERIAL_CTRL_TYPE(name, value)
{
	var option1 = new Option(name, value, true);
	form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
}

function MATERIAL_CTRL_TYPE_Changed()
{
	clearMATERIAL_CLASS1();

	//var id = "SL0121";
	var code = "3";
	var house_code = "<%=house_code%>";
	var value = form1.MATERIAL_CTRL_TYPE.value;
	//target = "MATERIAL_TYPE";
	var newOption = document.createElement('OPTION');
	newOption.text="전체";
	newOption.value="";
	document.form1.MATERIAL_CLASS1.add(newOption, null);
	doRequestUsingPOST( 'SL0121', house_code+'#'+code+'#'+value ,'MATERIAL_CLASS1','' );
	/* data = "/kr/master/sg/sou_bd_lis1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    document.childFrame.location.href = data; */
}

function from_date(year,month,day,week) 
{
	document.form1.fromdate.value=year+month+day;
}

function to_date(year,month,day,week) 
{
	document.form1.todate.value=year+month+day;
}

function tmp_pop() 
{
// 	var left = 0;
// 	var top = 0;
// 	var width = 590;
// 	var height = 400;
// 	var toolbar = 'no';
// 	var menubar = 'no';
// 	var status = 'no';
// 	var scrollbars = 'no';
// 	var resizable = 'no';
// 	var url = "eva_reg_pop1.jsp";
// 	var url = "eva_pp_lis1.jsp";
// 	var doc = window.open( url, 'doc', 'left=250, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	 var arrValue = new Array();
		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "";
		var arrDesc = new Array();
		arrDesc[0] = "템플릿 명";
		PopupCommonArr("SP0245","setEvaltemp",arrValue,arrDesc);
}
function setEvaltemp(code, desc)
{
	document.forms[0].evaltemp_num.value = code;
	document.forms[0].evaltemp.value = desc;
}

function addsg()
{
	if(form1.MATERIAL_CLASS1.selectedIndex > 0) 
	{
		var obj = document.form1.selectedSg;
		var len = obj.length
		var name = document.form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.selectedIndex].text;
		
		for(i=0; i < form1.selectedSg.length; i++) 
		{
			if(name == form1.selectedSg.options[i].text) 
			{
				alert('이미 선택된 아이템입니다.');
				return;
			}
		}

		var value = document.form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.selectedIndex].value;
		obj.options[len++] = new Option(name,value,false,"");
	}
}

function delsg()
{
	var obj = document.form1.selectedSg;
	if(form1.selectedSg.selectedIndex >= 0) 
	{
		obj.options[form1.selectedSg.selectedIndex] = null;
	}
}

//선택된 템플릿 값이 세팅된다.
// function s_select(no, name) 
// {
// 	f = document.form1;
// 	f.evaltemp.value = name;
// 	f.evaltemp_num.value = no;
// }

function JavaCall(msg1,msg2,msg3,msg4,msg5)
{
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(i%2 == 1){
			for (var j = 0;	j<GridObj.GetColCount(); j++){
				//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
			}
		}
	}

	if(msg3 == INDEX_VALUER)
	{
		var qty_yn = GD_GetCellValueIndex(GridObj,msg2, INDEX_QTY_YN);	

		if(qty_yn == "N") <%--정량평가만 있는 경우 --%>
		{
			alert("정량평가 항목만 있는 평가템플릿은 평가자를 지정 할 수 없습니다.");
			return;
		}

		var url = "eva_pp_ins1.jsp?i_row=" + msg2;

		window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=450,left=0,top=0");
	}

	if(msg1 == "doData")
	{
		//alert(GD_GetParam(GridObj,0));
		//alert("등록중 에러가 발생하였습니다.");

		var result = GD_GetParam(GridObj,1);
		
		if(result == "S")
		{
            location.href = "eva_bd_ins1.jsp";
		}
	}
}

function getCompany(szRow) 
{
	if ("Y" == GD_GetCellValueIndex(GridObj,szRow, INDEX_VALUER)) 
	{
		return com_data = GD_GetCellValueIndex(GridObj,szRow, INDEX_VALUE_ID);
	}
	return;
}

function valuerInsert(szRow, SELECTED, SELECTED_COUNT) 
{
	if(confirm("전체 업체에 대해 지정하시겠습니까 ?") == 1) 
	{
		for(row=0; row<=GridObj.GetRowCount(); row++) 
		{
			GridObj.cells(row+1, GridObj.getColIndexById("valuer")).setValue(SELECTED_COUNT);
			GridObj.cells(row+1, GridObj.getColIndexById("value_id")).setValue(SELECTED);
		}
	}
	else
	{
		GridObj.cells(szRow, GridObj.getColIndexById("valuer")).setValue(SELECTED_COUNT);
		GridObj.cells(szRow, GridObj.getColIndexById("value_id")).setValue(SELECTED);
	}
}

function itemDelete() {
   	var grid_array = getGridChangedRows(GridObj, "sel");
   	var rowcount = grid_array.length;
   	GridObj.enableSmartRendering(false);

   	for(var row = rowcount - 1; row >= 0; row--) {
		if("1" == GridObj.cells(grid_array[row], 0).getValue()) {
			GridObj.deleteRow2(grid_array[row]);
       	}
    }
}

function update_item(flag)
{
    var chk_cnt=0;
	for(row=0; row<GridObj.GetRowCount(); row++) 
	{
		//GD_SetCellValueIndex(GridObj,row, INDEX_SEL,"true&", "&");
		
		qty_yn = GridObj.cells(row+1, GridObj.getColIndexById("qty_yn")).getValue();

		if(qty_yn == "Y" && "1" == GridObj.cells(row+1, GridObj.getColIndexById("sel")).getValue())
		{
			value_yn = GridObj.cells(row+1, GridObj.getColIndexById("valuer")).getValue();

			if(value_yn < "1")
			{
				alert("평가자를 지정하셔야 합니다.");
				return;
			}
		}		
		chk_cnt++;
	}

	if(chk_cnt == 0)
	{
		alert("지정된 평가업체가 없습니다. 평가업체 지정 후 평가 생성 하십시요.");
		return;
	}
	
	f = document.form1;
	var evalname = f.evalname.value;	
	var fromdate = del_Slash(f.fromdate.value);	
	var todate = del_Slash(f.todate.value);	
	var evaltemp_num = f.evaltemp_num.value;	

	if(evalname == "")
	{
		alert("평가명을 입력하십시요.");
		f.evalname.focus();
		return;
	}

	if(fromdate == "" || todate == "") 
	{
		alert("평가기간을 입력해 주세요.");
		return;
	}
	
	if(fromdate > todate ) 
	{
		alert("평가 시작일자가 종료일자보다 큽니다. 다시 입력해 주세요.");
		return;
	}

	if(evaltemp_num.value == "")
	{
		alert("평가템플릿을 선택 해 주십시요.");
		f.evaltemp.focus();
		return;
	}

// 	if(document.form1.selectedSg.length == 0) 
// 	{
//   		alert("선택된 소싱그룹이 없습니다.");
//   		return;
// 	}
	Message = "";
	if(flag == "1") Message = "저장 하시겠습니까?";
	if(flag == "2") Message = "실행 하시겠습니까?";
	
	f.fromdate.value = del_Slash( f.fromdate.value );
	f.todate.value   = del_Slash( f.todate.value   );

	if(confirm(Message) == 1) 
	{
		var grid_array = getGridChangedRows(GridObj, "sel");
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_insert";
		var cols_ids = "<%=grid_col_id%>";
		var param = "mode=getEvaInsert&cols_ids="+grid_col_id;
		param +="&flag="+flag;
		param += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl, param);
		sendTransactionGridPost(GridObj, myDataProcessor, "sel", grid_array);
	}
}
//-->
</script>

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
	var header_name = GridObj.getColumnId(cellInd);
		if(header_name == "valuer") {
			var url = "<%=POASRM_CONTEXT_NAME%>/procure/evaluator_list.jsp";
			var param = "";
			param += "?popup_flag_header=true";
			param += "&i_row="+rowId;
			PopupGeneral(url+param, "valuer", "", "", "800", "640");
	}
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
        Query();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    document.form1.fromdate.value = add_Slash(document.form1.fromdate.value);
    document.form1.todate.value = add_Slash(document.form1.todate.value);
    
//     if("undefined" != typeof JavaCall) {
//     	JavaCall("doQuery");
//     } 
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onkeydown='entKeyDown()'>

<s:header>
<!--내용시작-->
<form name="form1" method="post" action="">
	<input type="hidden" name="evaltemp_num" id="evaltemp_num">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1"><%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left">
			<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가명
		</div>
	</td>
	<td width="35%" class="c_data_1">
		<input type="text" size="40" maxlength="40" class="inputsubmit" name="evalname" id="evalname">
	</td>
	<td width="15%" class="c_title_1">
		<div align="left">
			<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가기간
		</div>
	</td>
	<td width="35%" class="c_data_1">
		<s:calendar id_from="fromdate"  default_from="<%=SepoaString.getDateSlashFormat(fromdate) %>" id_to="todate" default_to="<%=SepoaString.getDateSlashFormat(todate) %>" format="%Y/%m/%d"/>
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1">
		<div align="left">
			<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가템플릿
		</div>
	</td>
	<td class="c_data_1" colspan="3">
		<input type="text" size="20" maxlength="20" class="inputsubmit" name="evaltemp" id="evaltemp" readonly>
		<a href="javascript:tmp_pop();">
			<img src="/images/icon/icon_search.gif" align="absmiddle" border="0" alt="">
		</a>
	</td>
</tr>
</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0" >
<tr>
	<td width="15%" class="c_title_1_1" colspan="4">
		<div align="left">
			평가소싱그룹
		</div>
	</td>
</tr>
<tr>
	<td width="20%" class="c_data_1">
		<table>
		<tr>
			<td height="1"></td>
		</tr>
		</table>
		대분류
		<select name="MATERIAL_TYPE" id="MATERIAL_TYPE" class="input_re" onChange="javascript:MATERIAL_TYPE_Changed();">
		<option value=''>----------</option>
		</select>
		<table>
		<tr>
			<td height="1"></td>
		</tr>
		</table>
		중분류
		<select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" class="input_re" onChange="javascript:MATERIAL_CTRL_TYPE_Changed();">
		<option value=''>----------</option>
		</select>
		<table>
		<tr>
			<td height="1"></td>
		</tr>
		</table>
		소분류
		<select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" class="inputsubmit">
		<option value=''>----------</option>
		</select>
		<table>
		<tr>
			<td height="1"></td>
		</tr>
		</table>
	</td>
	<td width="9%" class="c_data_1">
		<table>
		<tr>
			<td>
				<a href="javascript:addsg();">
					<img src="../../images//button/butt_arrow1_.gif" border="0" alt="">
				</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="javascript:delsg();">
					<img src="../../images//button/butt_arrow2_.gif" border="0" alt="">
				</a>
			</td>
		</tr>
		</table>
	</td>
	<td width="50%" class="c_data_1">
		<table>
		<tr>
			<td height="1"></td>
		</tr>
		</table>
		<SELECT style="width:150px; height:150px" class="input_re" NAME="selectedSg" id="selectedSg" MULTIPLE SIZE="5">
		</SELECT>
		<table>
		<tr>
			<td height="1"></td>
		</tr>
		</table>
	</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<td><script language="javascript">btn("javascript:Query()","조 회")</script></td>
			<td><script language="javascript">btn("javascript:update_item('1')","등 록")</script></td>
			<td><script language="javascript">btn("javascript:itemDelete()","삭 제")</script></td>
			<td><script language="javascript">btn("javascript:update_item('2')","실 행")</script></td>
		</TR>
		</TABLE>
	</td>		
</tr>
</table>

</form>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

</s:header>
<s:grid screen_id="SR_019" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


