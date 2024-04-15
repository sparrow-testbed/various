<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("ST_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "ST_006";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
%>
<% String WISEHUB_PROCESS_ID="ST_006";%>
<%
/**
 *========================================================
 *Copyright(c) 2010 ICOMPIA
 *
 *@File       : sta_bd_lis08.jsp
 *
 *@FileName   : 품목별 단가현황
 *
 *Open Issues :
 *
 *Change history  :
 *@LastModifyDate : 2010. 06. 02
 *@LastModifier   : ICOMPIA
 *@LastVersion    : V 1.0.0
 *=========================================================
 */
 %>

<%
	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript">
<!--
	var G_HOUSE_CODE   = "<%=house_code%>";
	var G_COMPANY_CODE = "<%=company_code%>";
	var GridObj = null;
	
	var G_PRE_CODE   = "B";

	function setGridObj(arg) {
		GridObj = arg;
	}
	
	function init() {
		setGridObj(GridObj);
		setGridDraw();
		setHeader();
		//setAlign();
		//setFormat();
	}

	 function setHeader() {

	}

	/*
	function setAlign() {
	}

	 function setFormat() {
		GridObj.SetNumberFormat("MEAN_PRICE"			,G_format_unit);
		GridObj.SetNumberFormat("MAX_PRICE"			,G_format_unit);
		GridObj.SetNumberFormat("MIN_PRICE"			,G_format_unit);
	} 
 */
	function EndGridQuery() {
		var status = GridObj.GetStatus();
		var mode   = GridObj.GetParam("mode");

		if (GridObj.GetStatus() == "false" ){
			alert(GridObj.GetMessage());
			return;
		}
	}

	function doSelect() {
		var from_date   		= del_Slash(document.form1.from_date.value);
		var to_date     		= del_Slash(document.form1.to_date.value);
		var cust_code     		= document.form1.cust_code.value;
		var project_code	    = document.form1.pjt_seq.value;
		var vendor_code			= document.form1.vendor_code.value;
		var item_no				= document.form1.item_no.value;
		var flag				= document.form1.flag.value;

		if(LRTrim(from_date) == "" || LRTrim(to_date) == "") {
			alert("기간을 입력하셔야 합니다.");
			return;
		}

		if(!checkDateCommon(from_date)) {
			alert("조회기간의 시작일자를 확인 하세요 ");
			document.form1.from_date.focus();
			return;
		}

		if(!checkDateCommon(to_date)) {
			alert("조회기간의 종료일자를 확인 하세요 ");
			document.form1.to_date.focus();
			return;
		}
		
		/* 
		var servlet_url ="/servlets/statistics.sta_bd_lis08";

		GridObj.SetParam("mode", 				"getStaUPItemList");
		GridObj.SetParam("from_date",			from_date);
		GridObj.SetParam("to_date",				to_date);
		GridObj.SetParam("cust_code",			cust_code);
		GridObj.SetParam("project_code",		project_code);
		GridObj.SetParam("vendor_code",			vendor_code);
		GridObj.SetParam("item_no",				item_no);
		GridObj.SetParam("flag",				flag);

		GridObj.DoQuery(servlet_url, null, true, false);
		 */
		 
		document.forms[0].from_date.value = del_Slash( document.forms[0].from_date.value );
		document.forms[0].to_date.value   = del_Slash( document.forms[0].to_date.value   );
		 
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/statistics.sta_bd_lis08";

		var cols_ids = "<%=grid_col_id%>";
        var params = "mode=getStaUPItemList";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        GridObj.post( G_SERVLETURL, params );
        GridObj.clearAll(false); 
	}

	function from_date(year,month,day,week) {
		document.form1.from_date.value = year+month+day;
	}

	function to_date(year,month,day,week) {
		document.form1.to_date.value = year+month+day;
	}

	function searchCust() {
		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0120F&function=scms_getCust&values=&values=/&desc=고객사코드&desc=고객사명";
		Code_Search(url,'','','','','');
	}

	function scms_getCust(code, text, div) {  
		document.form1.cust_type.value = div;
		document.form1.cust_code.value = code;
		document.form1.cust_name.value = text;
	}

	/* function PopupManager(part) {
		var url = "";
		var f = document.forms[0];
		var sepoa = GridObj;

		if(part == "PROJECT_NM")
	    {
			PopupCommon4("SP0350","getProject_nm",G_PRE_CODE,G_PRE_CODE,G_PRE_CODE,G_HOUSE_CODE,"프로젝트코드","프로젝트명");
	    }
	} */

	function getProject_nm(code, text, cust, cust_name, cust_type, seq)
	{
		document.form1.pjt_name.value = text;
		document.form1.pjt_code.value = code;
		//document.form1.scms_cust_code.value = cust;
		//document.form1.subject.value = text;
		document.form1.pjt_seq.value = seq;
	}
	
	function getVendorCode(setMethod) {
		popupvendor(setMethod);
	}

	function popupvendor( fun ) {
		window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}

	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].vendor_code.value     = code;
		document.forms[0].vendor_name_loc.value = desc1;
	}	

	function getItemNo(setMethod) {
		popupitemno(setMethod);
	}

	function popupitemno( fun ) {
		PopupCommon1("SP0149","setItemNo","<%=info.getSession("HOUSE_CODE")%>","품목코드","품목명");
	}

	function setItemNo( code, desc1, desc2 , desc3) {
		document.forms[0].item_no.value     	= code;
		document.forms[0].description_loc.value = desc1;
	}	
	
	function setCal(div){
		var startDay = "<%=SepoaDate.getShortDateString()%>";
		var endDay = "";
		var curStartDay = del_Slash(document.form1.from_date.value);
		var setDay = "";
		
		var curYear = curStartDay.substring(0,4);
		
		var february = ((0 == curYear % 4) && (0 != (curYear % 100))) || (0 == curYear % 400) ? 29 : 28;
		var arrLastDate = new Array(31, february, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);//해당월의 마지막일
		
		var lastdate = arrLastDate[parseInt(curStartDay.substring(4,6),10)-1];
		
		if(div == 'y'){
			setDay = curStartDay.substring(0,4)+"0101";
			endDay = curStartDay.substring(0,4)+"1231";
		}else if(div == 'q'){
			var mon = curStartDay.substring(4,6);
			if(parseInt(mon,10) < 7){
				setDay = curStartDay.substring(0,4)+"0101";
				endDay = curStartDay.substring(0,4)+"0630";
			}else{
				setDay = curStartDay.substring(0,4)+"0701";
				endDay = curStartDay.substring(0,4)+"1231";
			}
		}else if(div == 'm'){
			setDay = curStartDay.substring(0,6)+"01";
			endDay = curStartDay.substring(0,6)+lastdate;
		}
		document.form1.from_date.value = add_Slash(setDay);
		document.form1.to_date.value = add_Slash(endDay);
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
	
	if( header_name == "ITEM_NO" ) {//품목상세
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	}
	
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		//GridCellClick(strColumnKey,nRow)

    
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
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    
    document.forms[0].from_date.value = add_Slash( document.forms[0].from_date.value );
	document.forms[0].to_date.value   = add_Slash( document.forms[0].to_date.value   );
	
    return true;
}

//지우기
function doRemove( type ){
    if( type == "cust_code" ) {
    	document.forms[0].cust_code.value = "";
        document.forms[0].cust_name.value = "";
    }  
    if( type == "item_no" ) {
    	document.forms[0].item_no.value = "";
        document.forms[0].description_loc.value = "";
    }
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_name_loc.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">

<s:header>
<!--내용시작-->

<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>
<form name="form1">
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
<form name="form1">
<input type="hidden" name="pjt_code" id="pjt_code"  />
<input type="hidden" name="pjt_name" id="pjt_name" />
<input type="hidden" name="pjt_seq" id="pjt_seq"  />        
<tr>
	<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기간
	</td>
	<td width="40%" class="data_td">
	<TABLE cellpadding="0">
		<TR>
			<td>
				<%-- <input type="text" name="from_date" id="from_date" size="10" maxlength="8" class="input_re" value='<%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1)%>'>
				<a href="javascript:Calendar_Open('from_date');"><img src="/images/button/butt_calender.gif"  width="22" height="19" align="absmiddle" border="0" alt=""></a>
				~
				<input type="text" name="to_date" id="to_date" size="10" maxlength="8" class="input_re" value='<%=SepoaDate.getShortDateString()%>'>
				<a href="javascript:Calendar_Open('to_date');"><img src="/images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0" alt=""></a> --%>
				<s:calendar id="from_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" format="%Y/%m/%d"/>
				~
				<s:calendar id="to_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d"/>
				
			</td>
			<TD><script language="javascript">btn("javascript:setCal('y')","년")    </script></TD>
			<TD><script language="javascript">btn("javascript:setCal('q')","반기")    </script></TD>
			<TD><script language="javascript">btn("javascript:setCal('m')","월")    </script></TD>
		</TR>
	</TABLE>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고객사
	</td>
	<td width="35%" class="data_td">
		<input type="hidden" name="cust_type" id="cust_type">
		<input type="text" onkeydown='entKeyDown()' name="cust_code" id="cust_code" style="ime-mode:inactive" size="10" class="inputsubmit" value='' >
		<a href="javascript:searchCust();"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" ></a>
		<a href="javascript:doRemove('cust_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" onkeydown='entKeyDown()' name="cust_name" id="cust_name" size="26" class="input_data2" value='' style="border:0" readonly>
	</td>
</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목
	</td>
	<td width="35%" class="data_td">
		<input type="text" onkeydown='entKeyDown()' name="item_no" id="item_no" style="ime-mode:inactive" size="15" class="input_re" > 
			<a href="javascript:getItemNo('setItemNo')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
		<a href="javascript:doRemove('item_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" onkeydown='entKeyDown()' name="description_loc" id="description_loc" size="20" class="input_data2" readOnly>
	</td>
	    
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체
	</td>
	<td width="35%" class="data_td">
		<input type="text" onkeydown='entKeyDown()' name="vendor_code" id="vendor_code" style="ime-mode:inactive" size="15" class="inputsubmit" maxlength="10" >
			<a href="javascript:getVendorCode('setVendorCode')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
	<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" onkeydown='entKeyDown()' name="vendor_name_loc" id="vendor_name_loc" size="20" class="input_data2">
	</td>
</tr>

<tr style="display:none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구분
	</td>
	<td width="35%" class="data_td" colspan="3">
        <select name="flag" id="flag" class="inputsubmit">
        <option value="M">Monthly</option>
        <option value="Q">Quarterly</option>
        <option value="Y">Yearly</option>
        </select>
	</td>
</tr>
</table>
   		</td>
   	</tr>
 	</table>
 	</td>
   	</tr>
 	
<table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                              
<tr>                                                                                                                                                                                    
	<td height="30" align="right">                                                                                                                                            
		<TABLE cellpadding="0">                                                                                                                                                   
		<TR>	                                                                                                                                                                              
			<TD><script language="javascript">btn("javascript:doSelect()","조회")</script></TD>
		</TR>                                                                                                                                                                               
		</TABLE>                                                                                                                                                                              
	</td>
</tr>
</table>                                                                                                                                                                                 

</form>
<iframe name = "work_frame" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>
<s:grid screen_id="ST_006" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>



