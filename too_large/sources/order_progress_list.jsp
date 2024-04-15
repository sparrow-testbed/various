<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("DV_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "DV_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--
 Title:        수주진행 <p>
 Description:  수주된 Item의 진행 상태를 확인하는 화면. <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<%
	String z_loi_flag = JSPUtil.nullToEmpty(request.getParameter("z_loi_flag"));
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String dept_code = info.getSession("DEPARTMENT");
	String dept_name_loc = info.getSession("DEPARTMENT_NAME_LOC");
	String ctrl_code = info.getSession("CTRL_CODE");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_id = info.getSession("ID");

	String location_code = info.getSession("LOCATION_CODE");

	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(to_day,-1));
	String to_date = SepoaString.getDateSlashFormat(to_day);
	Configuration con = new Configuration();
	String BUYER_CODE = con.get("sepoa.buyer.company.code");
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid��JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox��JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<Script language="javascript">
<!--
var INDEX_SELECTED			;
var INDEX_PO_NO				;
var INDEX_PO_TYPE			;
var INDEX_SUBJECT			;
var INDEX_ITEM_NO			;
var INDEX_DESCRIPTION_LOC	;
var INDEX_PO_DATE			;
var INDEX_CTRL_CODE			;
var INDEX_RD_DATE			;
var INDEX_CTR_NO			;
var INDEX_CUR				;
var INDEX_UNIT_PRICE		;
var INDEX_UNIT_MEASURE		;
var INDEX_PO_QTY			;
var INDEX_GR_QTY			;
var INDEX_IV_SEQ			;
var INDEX_COMPLETE_GR_MARK	;
var INDEX_ITEM_AMT			;
var mode;
var chkrow;

function Init() {
setGridDraw();
setHeader();
	<%--
		결함 #108
		메뉴선택시 조회조건에의해서 기본 조회되어야함.
		getQuery(); 추가
	--%>
	getQuery();
}

function setHeader()
{

	
	
	/* GridObj.SetDateFormat("RD_DATE"		,"yyyy/MM/dd");
	GridObj.SetDateFormat("PO_DATE"		,"yyyy/MM/dd");
	GridObj.SetDateFormat("DP_PLAN_DATE"	,"yyyy/MM/dd");
	GridObj.SetNumberFormat("PO_QTY"			,G_format_qty);
	GridObj.SetNumberFormat("GR_QTY"			,G_format_qty);
	GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
	GridObj.SetNumberFormat("ITEM_AMT"		,G_format_unit); */
	

	INDEX_SELECTED			= GridObj.GetColHDIndex("SELECTED"			);
	INDEX_PO_NO				= GridObj.GetColHDIndex("PO_NO"				);
	INDEX_PO_TYPE			= GridObj.GetColHDIndex("PO_TYPE"				);
	INDEX_SUBJECT			= GridObj.GetColHDIndex("SUBJECT"				);
	INDEX_ITEM_NO			= GridObj.GetColHDIndex("ITEM_NO"				);
	INDEX_DESCRIPTION_LOC	= GridObj.GetColHDIndex("DESCRIPTION_LOC"	    );
	INDEX_PO_DATE			= GridObj.GetColHDIndex("PO_DATE"			    );
	INDEX_CTRL_CODE			= GridObj.GetColHDIndex("CTRL_CODE"			);
	INDEX_RD_DATE			= GridObj.GetColHDIndex("RD_DATE"			    );
	INDEX_CTR_NO			= GridObj.GetColHDIndex("CTR_NO"				);
	INDEX_CUR				= GridObj.GetColHDIndex("CUR"				    );
	INDEX_UNIT_PRICE		= GridObj.GetColHDIndex("UNIT_PRICE"		    );
	INDEX_UNIT_MEASURE		= GridObj.GetColHDIndex("UNIT_MEASURE"		);
	INDEX_PO_QTY			= GridObj.GetColHDIndex("PO_QTY"			    );
	INDEX_GR_QTY			= GridObj.GetColHDIndex("GR_QTY"			    );
	INDEX_IV_SEQ			= GridObj.GetColHDIndex("IV_SEQ"	    		);
	INDEX_COMPLETE_GR_MARK	= GridObj.GetColHDIndex("COMPLETE_GR_MARK"	);
	INDEX_ITEM_AMT			= GridObj.GetColHDIndex("ITEM_AMT"	);

}

function getQuery()
{

	var from_date 		= del_Slash(document.wiseForm.from_date.value);
	var to_date 		= del_Slash(document.wiseForm.to_date.value);
	var po_no 			= document.wiseForm.po_no.value.toUpperCase();
	var item_no 		= document.wiseForm.item_no.value.toUpperCase();
	//var ctrl_person_id 	= document.wiseForm.ctrl_person_id.value;
	var close_status    = document.wiseForm.close_status.value;
	var vendor_code = "<%=company_code%>";

	if(!checkDateCommon(from_date)) {
		alert(" 수주일자(From)를 확인 하세요 ");
		document.wiseForm.from_date.select();
		return;
	}

	if(!checkDateCommon(to_date)) {
		alert(" 수주일자(To)를 확인 하세요");
		document.wiseForm.to_date.select();
		return;
	}


	//var servletUrl = "/servlets/supply.ordering.po.po4_bd_lis1";

	GridObj.SetParam("from_date"		,from_date		);
	GridObj.SetParam("to_date"		,to_date		);
	GridObj.SetParam("po_no"			,po_no			);
	GridObj.SetParam("item_no"		,item_no		);
	GridObj.SetParam("vendor_code"	,vendor_code	);
	//GridObj.SetParam("ctrl_person_id"	,ctrl_person_id	);
	GridObj.SetParam("close_status"	,close_status	);

	/* GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl);
	GridObj.strHDClickAction="sortmulti"; */
	
	 var grid_col_id     = "<%=grid_col_id%>";
	var param = "mode=getProgressList&grid_col_id="+grid_col_id;
	    param += dataOutput();
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.order_progress_list";
	
	GridObj.post(url, param);
	GridObj.clearAll(false);
}



function JavaCall(msg1, msg2, msg3, msg4, msg5)
{

    for(var i=0;i<GridObj.GetRowCount();i++) {
           if(i%2 == 1){
		    for (var j = 0;	j<GridObj.GetColCount(); j++){
		        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
	        }
           }
	}

	if(msg1 == "doQuery") {
		var max_row = GridObj.GetRowCount();
		if(max_row == 0) {
			//alert("조회된 데이타가 없습니다. ");
			return;
		}
	}

	if(msg1 == "t_header" && msg3 == INDEX_RD_DATE)
	{
		if(GridObj.GetRowCount() > 1)
		{
			var rd_date = GD_GetCellValueIndex(GridObj,0,INDEX_RD_DATE);

			//if(LRTrim(rd_date) == "")
			if(rd_date == "")
				return;

			for(i=1; i<GridObj.GetRowCount(); i++)
			{
				GD_SetCellValueIndex(GridObj,i, INDEX_RD_DATE, rd_date);
			}
		}
	}

	if(msg1 == "doData")
	{
	}

	if(msg1 == "t_imagetext") {
		if(msg3 == INDEX_ITEM_NO){
			var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}else if(msg3 == INDEX_DESCRIPTION_LOC){
			var item_no = GridObj.GetCellValue("ITEM_NO",msg2);
			var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
		if(msg3==INDEX_PO_NO) {
			po_no            = GD_GetCellValueIndex(GridObj,msg2,INDEX_PO_NO);
	    	window.open("po3_pp_dis1.jsp"+"?po_no="+po_no,"po3_pp_dis1","width=1000,height=570,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		}
	}

}

function getItemNo()
{
	<%-- var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0046&function=setItemNo&values=<%=house_code%>&values=<%=company_code%>&values=<%=buyer_code%>&values=&values=";
 --%>
	var left = 50;
	var top = 100;
	var width = 650;
	var height = 450;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'no';
	var scrollbars = 'no';
	var resizable = 'no';
	var itemNoWin = window.open( url, 'itemNoWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	itemNoWin.focus();
}

function PopupManager(part) {
	var url = "";
	var f = document.forms[0];
	
	if(part == "getItemNo"){
		window.open("/common/CO_015.jsp?callback=setItemNo", "SP0046", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}


function setItemNo(code, text1, text2)
{
	document.wiseForm.item_no.value = code;
}

function add_from_date(year,month,day,week)
{
	document.wiseForm.from_date.value=year+month+day;
}

function add_to_date(year,month,day,week)
{
	document.wiseForm.to_date.value=year+month+day;
}
//�대���	
function SP0071_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		<%-- var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=buyer_code%>&values=P";
 --%>		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {

		document.forms[0].ctrl_code.value = ls_ctrl_code;
		document.forms[0].ctrl_name.value = ls_ctrl_name;
		document.forms[0].ctrl_person_id.value = ls_ctrl_person_id;
		document.forms[0].ctrl_person_name.value = ls_ctrl_person_name;

	}
//-->
</Script>




<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 洹몃━���대┃ �대깽��������몄� �⑸��� rowId ����� ID�대ŉ cellInd 媛�� 而щ� �몃���媛��硫�// �대깽��泥�━��而щ�紐�怨������� 泥�━����ㅻ㈃ GridObj.getColIndexById("selected") == cellInd �대�寃�泥�━���硫��⑸���
function doOnRowSelected(rowId,cellInd)
{
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if(header_name=="PO_NO") {
		var po_no	= LRTrim(GridObj.cells(rowId, INDEX_PO_NO).getValue());   //GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
 		//var po_type	= LRTrim(GridObj.cells(rowId, INDEX_PO_TYPE).getValue());	//GD_GetCellValueIndex(GridObj,msg2,IDX_PO_TYPE);
	    //window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no ,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		var url              = "/kr/order/bpo/po3_pp_dis1.jsp";
		var title            = '발주화면상세조회';
		var param = "";
		param = param + "po_no=" + po_no;

		if (po_no != "") {
		    popUpOpen01(url, title, '1024', '600', param);
		}	    
    }	
	
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 洹몃━����ChangeEvent ������몄� �⑸���
// stage = 0 ������, 1 = ����댁����, 2 = �������� true �������������ŉ false ������댁�媛��濡�����⑸���
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 ������, 1 = ����댁����, 2 = �������� true �������������ŉ false ������댁�媛��濡�����⑸���
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// ���由우�濡��곗��곕� ��� 諛���� 諛���� 泥�━ 醫����� �몄� ��� �대깽�������
// ���由우���message, status, mode 媛�� �����㈃ 媛�� �쎌��듬���
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

// ��� �������� ��� ����� ������ 蹂듭���� 踰���대깽�몃� doExcelUpload �몄��������// 蹂듭����곗��곌� 洹몃━��� Load �⑸���
// !!!! �щ＼,����댄����ы�由��ㅽ���釉���곗�������대┰蹂대������ ��렐 沅����留�������doExcelUpload �ㅽ������ 諛�� 
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
    // Wise洹몃━������ �ㅻ�諛����status��0���명����.
    if(status == "0") alert(msg);
    
//     document.forms[0].from_date.value = add_Slash( document.forms[0].from_date.value );
//     document.forms[0].to_date.value   = add_Slash( document.forms[0].to_date.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--�댁����-->
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<form name="wiseForm" >
<input type="hidden" name="operating_code">
<input type="hidden" name="po_complete_mark">
<input type="hidden" name="pr_company">
<input type="hidden" name="shipper_type">
<input type="hidden" name="pr_dept">
<input type="hidden" name="exec_no">
<input type="hidden" name="project_no">
<input type="hidden" name="project_loc">
<input type="hidden" name="string_project">

<tr>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주일자
	</td>
	<td class="data_td" width="35%">
			<s:calendar id_to="to_date"  default_to="<%=to_date %>" id_from="from_date" default_from="<%=from_date %>" format="%Y/%m/%d"/>
	</td>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주번호
	</td>
	<td class="data_td" width="35%">
		<input type="text" name="po_no" id="po_no" style="width:35%;ime-mode:inactive" maxlength="25" class="inputsubmit">
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 완료여부
	</td>
	<td class="data_td" width="35%">
		<select name="close_status" id="close_status" class="inputsubmit">
		<option value="">전체</option>
<%
		String complete_mark = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M645", "");
		out.println(complete_mark);
%>
		</select>
	</td>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 품목코드
	</td>
	<td class="data_td" width="35%">
		<input type="text" name="item_no" id="item_no" style="ime-mode:inactive" size="18" maxlength="10" class="inputsubmit" <%--  onBlur="javascript: param1 = wiseForm.item_no.value; get_Sepoadesc('SP0255', 'wiseForm', this, 'item_no','values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=<%=info.getSession("BUYER_CODE")%>&values='+param1+'&values=','1');" --%>>
		<a href="javascript:PopupManager('getItemNo')">
			<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
		</a>
	</td>
</tr>
</table>
</td>
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
			<TD><script language="javascript">btn("javascript:getQuery()","조회")</script></TD>
			<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td>
		</TR>
		</TABLE>
	</td>
</tr>
</table>


</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="DV_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


