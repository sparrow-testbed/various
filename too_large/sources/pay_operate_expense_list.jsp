<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%-- TOBE 2017-07-01 점코드 글로벌 상수 --%>
<%@  page import="sepoa.svc.common.constants" %>
<%! String gam_jum_cd = constants.DEFAULT_GAM_JUMCD; %>
<%! String ict_jum_cd = constants.DEFAULT_ICT_JUMCD; %>
<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>
<%! String acc_jum_cd = constants.DEFAULT_ACC_JUMCD; %>


<% 
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_012");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TX_012";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif";

%>

<%
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    String USER_DEPT 	= info.getSession("DEPARTMENT");
    
    // ASIS 2017-07-01
    //if("20644".equals(USER_DEPT)) USER_DEPT = "" ;
    
    //TOBE 2017-07-01
    if(gam_jum_cd.equals(USER_DEPT) || acc_jum_cd.equals(USER_DEPT)) USER_DEPT = "" ;
    //String LB_PAY_TARGET 		= ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M400", ""); //지급대상
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script type="text/javascript">
//<!--
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_operate_expense_list";

var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_CUR_ROW;

var mode = "";

function init()
{
	setGridDraw();
    doSelect();
}

function doSelect()
{
	
	document.forms[0].inv_start_date.value = del_Slash( document.forms[0].inv_start_date.value );
	document.forms[0].inv_end_date.value   = del_Slash( document.forms[0].inv_end_date.value   );
	
    mode = "getPayOperateExpenseList";
    
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=" + mode;
    params += "&grid_col_id=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);    
}


function getVendorCode(setMethod) {
	window.open("/common/CO_014.jsp?callback=" + setMethod, "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}

function setVendorCode( code, desc1, desc2 , desc3) {
	$("#vendor_code").val(code);
	$("#vendor_code_name").val(desc1);
}

function doGive(){
	alert("지급 : 준비중");
}

function doCreateDoc(){
// 	자본적지출대상 : 
// 		   vendor_code가 모두 같은 지 확인
// 		   소속점 같아야 한다.
// 		   param: 하우스코드, 세금계산서번호, 상세번호, (house_code, tax_no, tax_seq)	
	
	var chkCnt = 0 ; 
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++ ){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			chkCnt++;
		}
	}
	
	if(chkCnt == 0){
		alert("지급문서를 생성할 대상을 선택해 주세요.");
		return;
	}
	
	//TOBE 2017-07-01 한 ROW 이상 선택 불가 추가
	if(chkCnt > 1){
		alert("한 Row 이상 선택하실 수 없습니다.");
		return;
	}
	
	var params = "";
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++ ){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			
			if(i==0){
				//ASIS 2017-07-01 params += "tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i)+"&vendor_code="+GridObj.GetCellValue("VENDOR_CODE", i)+"&tax_date="+del_Slash(GridObj.GetCellValue("TAX_DATE", i));
				//TOBE 2017-07-01 지급결의담당부서 추가
				params += "tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&proc_dept="+GridObj.GetCellValue("PROC_DEPT", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i)+"&vendor_code="+GridObj.GetCellValue("VENDOR_CODE", i)+"&tax_date="+del_Slash(GridObj.GetCellValue("TAX_DATE", i));
			}else{
				//ASIS 2017-07-01 params += "&tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i)+"&vendor_code="+GridObj.GetCellValue("VENDOR_CODE", i)+"&tax_date="+del_Slash(GridObj.GetCellValue("TAX_DATE", i));
				//TOBE 2017-07-01 지급결의담당부서 추가
				params += "&tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&proc_dept="+GridObj.GetCellValue("PROC_DEPT", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i)+"&vendor_code="+GridObj.GetCellValue("VENDOR_CODE", i)+"&tax_date="+del_Slash(GridObj.GetCellValue("TAX_DATE", i));
			}
		}
	}
	
	$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svc.common.HldyInfoServlet",
		{
			mode        : "isHldy"
		},
		function(arg){
			
			var result  = eval("(" + arg + ")"); 
			var code    = result.code;
			var message = result.message;
			
			if(result != "0" ){
				alert("휴일거래 불가합니다.");
			}else if(result == "0" ){ 
				var url = "pay_bd_ins2_pop.jsp?" + params;
				window.open(url, "payPop", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=750,left=0,top=0");
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

function doModify(){
	alert("계정과목수정 : 준비중");
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
function doOnRowSelected(rowId,cellInd){
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if( header_name == "VENDOR_NAME" ) {//업체상세
		
	    var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
	    
	    if(vendor_code != null && vendor_code != "") {
	    
	      var url    = '/s_kr/admin/info/ven_bd_con.jsp';
	      var title  = '업체상세조회';
	      var param  = 'popup=Y';
	      param     += '&mode=irs_no';
	      param     += '&vendor_code=' + vendor_code;
	      popUpOpen01(url, title, '900', '700', param);
	    
	    }
			
	}
	
	if( GridObj.getColIndexById("TAX_NO") == cellInd ){
		if($.trim(GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
	  		var tax_no 	= GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_NO")).getValue();
	  		var status 	= GridObj.cells(rowId, GridObj.GetColHDIndex("PROGRESS_CODE")).getValue(); 
	  		location.href = "tax_pub_ins.jsp?tax_no=" + tax_no + "&gubun=" + status + "&gubun=P";
		}else{
			var pubCode = GridObj.cells(rowId, GridObj.GetColHDIndex("PUBCODE")).getValue();
			
			var iMyHeight;
			width = (window.screen.width-635)/2
			if(width<0)width=0;
			iMyWidth = width;
			height = 0;
			if(height<0)height=0;
			iMyHeight = height;
			var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=700px, height=760px");
			document.taxListForm.action="<%=CommonUtil.getConfig("sepoa.trus.server")%>/jsp/directTax/TaxViewIndex.jsp";
			document.taxListForm.method="post";
			document.taxListForm.pubCode.value=pubCode;
			document.taxListForm.docType.value= "T"; //세금계산서
			document.taxListForm.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
			document.taxListForm.target="taxInvoice";
			document.taxListForm.submit();		
		}
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

    alert(messsage);
    
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    document.forms[0].inv_start_date.value = add_Slash( document.forms[0].inv_start_date.value );
    document.forms[0].inv_end_date.value   = add_Slash( document.forms[0].inv_end_date.value   );

    return true;
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
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
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
<!--내용시작-->
<form id="form1" name="form1" action="">
	<input type="hidden" id="user_dept" name="user_dept" VALUE="<%=USER_DEPT%>"> 
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
		<tr>
        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서 발행일자</td>
            <td class="data_td">
            	<s:calendar id="inv_start_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) )%>" format="%Y/%m/%d" cssClass=" "/>
                ~
                <s:calendar id="inv_end_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.getShortDateString() )%>" format="%Y/%m/%d" cssClass=" "/>
			</td>
			<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체</td>
			<td class="data_td">
				<input type="text" name="vendor_code" id="vendor_code" size="12" class="inputsubmit" maxlength="10" style="ime-mode:inactive" onkeydown='entKeyDown()' >
				<a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
				<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
				<input type="text" name="vendor_code_name" id="vendor_code_name" size="20"  onkeydown='entKeyDown()'>			
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서번호</td>
			<td class="data_td" colspan="3">
            	<input type="text" id="tax_no" name="tax_no" style="ime-mode:inactive"  size="10" value='' onkeydown='entKeyDown()'>
			</td>
			<%-- <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급상태</td>
			<td class="data_td">
            	<select>
            	
            	</select>
			</td> --%>
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
                        <TD><script language="javascript">btn("javascript:doSelect()"	,"조 회")    	</script></TD>
                        <TD><script language="javascript">btn("javascript:doCreateDoc()","지급결의생성")	</script></TD> 
                        <TD style="display: none;"><script language="javascript">btn("javascript:doModify()"	,"계정과목수정")	</script></TD> 
                    </TR>
                </TABLE>
            </td>
        </tr>
    </table>
</form>

<form id="taxListForm" name="taxListForm" method="get">
	<input type="hidden" id="pubCode"  name="pubCode" >
	<input type="hidden" id="docType"  name="docType" >
	<input type="hidden" id="userType" name="userType" >
</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="TX_012" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
<%-- TOBE 2017-07-01 구 activeX 미사용 주석처리
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
--%>
</OBJECT>
</body>
</html>