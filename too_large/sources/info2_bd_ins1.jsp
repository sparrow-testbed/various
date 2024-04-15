<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_007_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_007_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
 
	String WISEHUB_LANG_TYPE="KR";
	String WISEHUB_PROCESS_ID="MA_007_1";
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String Attach_Index = "";
    SepoaListBox lb = new SepoaListBox();
    String result = lb.Table_ListBox( request, "SL0200", house_code, "#", "@");

    //단위결정기준
    String make_amt_codes = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M799", "07");

    
    String Z_CHARACTER_CLASS1 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS1"));
    
    if(Z_CHARACTER_CLASS1 == null ){
    	Z_CHARACTER_CLASS1 = "";
    }
    
    String Z_CHARACTER_CLASS2 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS2"));
    
    if(Z_CHARACTER_CLASS2 == null ){
    	Z_CHARACTER_CLASS2 = "";
    }
    
    String Z_CHARACTER_CLASS3 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS3"));
    
    if(Z_CHARACTER_CLASS3 == null ){
    	Z_CHARACTER_CLASS3 = "";
    }

    String gate         = JSPUtil.nullToRef(request.getParameter("gate"),""); // 외부에서 접근하였을 경우 flag
    
    String G_IMG_ICON = "/images/ico_zoom.gif"; 
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/order.info.info2_bd_lis1";    // order/info/p2004.java

function searchProfile(fc) {
	if(fc =="vendor_code"){
		window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
}

function SP0054_getCode(code, text1, text2) {
	document.forms[0].vendor_code.value = code;
	document.forms[0].vendor_name.value = text1;
}


var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
        return true;
    }
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
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
    }
    else {
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

//지우기
function doRemove( type ){
    if( type == "MAKER_FLAG" ) {
    	document.getElementById("MAKER_CODE").value        ="";
		document.getElementById("MAKER_NAME").value            = "";
    }  
}

function category(){
	url = "/kr/catalog/cat_pp_lis_main.jsp?isSingle=Y";
	CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");	
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	$("#item_no").val(itemNo);
	$("#item_name").val(descriptionLoc);
	$("#basicUnit").val(basicUnit);
	$("#specification").val(specification);

	$("#item_name_td").html(descriptionLoc);
	$("#basicUnit_td").html(basicUnit);
	return true;
}

var calByte = {
		getByteLength : function(s) {
			if (s == null || s.length == 0) {
				return 0;
			}
			var size = 0;
			for ( var i = 0; i < s.length; i++) {
				size += this.charByteSize(s.charAt(i));
			}
			return size;
		},		
		cutByteLength : function(s, len) {
			if (s == null || s.length == 0) {
				return 0;
			}
			var size = 0;
			var rIndex = s.length;
			for ( var i = 0; i < s.length; i++) {
				size += this.charByteSize(s.charAt(i));
				if( size == len ) {
					rIndex = i + 1;
					break;
				} else if( size > len ) {
					rIndex = i;
					break;
				}
			}
			return s.substring(0, rIndex);
		},
		charByteSize : function(ch) {
			if (ch == null || ch.length == 0) {
				return 0;
			}
			var charCode = ch.charCodeAt(0);
			if (charCode <= 0x00007F) {
				return 1;
			} else if (charCode <= 0x0007FF) {
				return 2;
			} else if (charCode <= 0x00FFFF) {
				return 3;
			} else {
				return 4;
			}
		}
	};

	

function doSave(){
	
	var vendor_code 	= $.trim($("#vendor_code").val());
	var item_no 		= $.trim($("#item_no").val());
	var cont_price 		= $.trim($("#cont_price").val());
	var cont_from_date 	= $.trim($("#cont_from_date").val());
	var cont_to_date 	= $.trim($("#cont_to_date").val());
	var mdlmdlnm 	    = $.trim($("#mdlmdlnm").val());
		
	if(vendor_code == ''){
		alert("업체명을 선택해 주세요.");
		$("#vendor_code").focus();
		return;
	}
	if(item_no == ''){
		alert("품목명을 선택해 주세요.");
		$("#item_no").focus();
		return;
	}
	if(calByte.getByteLength( mdlmdlnm ) > 50){
		alert("모델명은 50Byte 까지 입력 가능합니다.\r\n\r\n( 한글:3Byte , 영문/특수문자:1Byte )");
		$("#mdlmdlnm").val(  calByte.cutByteLength(  mdlmdlnm, 50 )  );
		$("#mdlmdlnm").focus();
		return;
	}
	if(cont_price == ''){
		alert("계약단가를 입력해 주세요.");
		$("#cont_price").focus();
		return;
	}
	if(cont_from_date == ''){
		alert("계약일자를(from) 선택해 주세요.");
		$("#cont_from_date").focus();
		return;
	}
	if(cont_to_date == ''){
		alert("계약일자를(to) 선택해 주세요.");
		$("#cont_to_date").focus();
		return;
	}
	
	var nickName    = "p2004";
	var conType     = "CONNECTION";//TRANSACTION
	var methodName  = "getInfoData";
	var SepoaOut    = doServiceAjax( nickName, conType, methodName );
	 
  	if( SepoaOut.status == "1" ) { // 성공
  		
        var tmp = (SepoaOut.result[0]).split("<%=CommonUtil.getConfig( "sepoa.separator.line" )%>");
        var tmp1 = tmp[1].split("<%=CommonUtil.getConfig( "sepoa.separator.field" )%>");
        
        var chkCnt = tmp1.toString().replaceAll(",","");
        
        if(Number(chkCnt) > 0){
        	if($.trim($("#reason").val()) == ''){
	        	alert("입력하신 정보의 단가정보가 존재합니다.\n수정시에는 변경사유를 입력하여야 합니다.");
	        	$("#reason").focus();
	        	return;
        	}
        	$("#updYn").val("Y");
        }else{
        	if($.trim($("#reason").val()) != ''){
        		alert("신규등록일 경우에는 변경사유가 저장되지 않습니다.");
        	}
        	$("#updYn").val("N");
        }
        
        if(!confirm("등록하시겠습니까?"))return;
        
    	var nickName1    = "p2004";
    	var conType1     = "TRANSACTION";//TRANSACTION
    	var methodName1  = "setInsertInfo";
    	var SepoaOut1    = doServiceAjax( nickName1, conType1, methodName1 );
    	
    	if( SepoaOut.status == "1" ) { // 성공
    		alert("성공적으로 처리하였습니다.");
    		opener.$("#vendor_code").val($("#vendor_code").val());
    		opener.$("#vendor_name").val($("#vendor_name").val());
    		opener.$("#item_no").val($("#item_no").val());
    		opener.$("#description_loc").val($("#item_name").val());
    		opener.doSelect();
    		window.close();
    	}else{
    		alert("처리시 오류가 발생하였습니다.");
    		return;
    	}
  	}
}

function onlyNumber(keycode){
	if(keycode >= 48 && keycode <= 57){
	}else {
		return false;
	}
	return true;
}
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">단가생성</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" method="post" action="">
		<input type="hidden" id="updYn" name="updYn" value="N">
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" >
											<input type="text" name="vendor_code" id="vendor_code" style="width:30%;ime-mode:inactive" class="inputsubmit" maxlength="10" readonly="readonly">
											<a href="javascript:searchProfile('vendor_code')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="vendor_name" id="vendor_name" style="width:35%" class="inputsubmit"  readonly="readonly">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
										<td class="data_td" width="35%" id="specification_td">											
										</td>
										<input type="hidden" name="specification" id="specification" class="inputsubmit" maxlength="10" readonly="readonly">
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="35%">
											<input type="text" name="item_no" id="item_no" style="width:30%;ime-mode:inactive" class="inputsubmit" maxlength="10"  readonly="readonly">
											<a href="javascript:category();">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="item_name" id="item_name" style="width:35%" class="inputsubmit" readonly="readonly">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모델명</td>
										<td class="data_td" width="35%" id="mdlmdlnm_td">
											<input type="text" name="mdlmdlnm" id="mdlmdlnm" value="" style="width:60%"  class="inputsubmit" maxlength="50" style="text-align: left;ime-mode:disabled;">
										</td>										
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위</td>
										<td class="data_td" id="basicUnit_td">
										</td>
										<input type="hidden" name="basicUnit" id="basicUnit" value="" class="inputsubmit" maxlength="500" readonly="readonly">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;통화</td>
										<td class="data_td">KRW
											<input type="hidden" name="cur" id="cur" value="KRW" size="52" class="inputsubmit">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약단가&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td">
											<input type="text" name="cont_price" id="cont_price" value="" class="inputsubmit" maxlength="10" style="text-align: right;ime-mode:disabled;" onfocus="this.value=del_comma(this.value);" onblur="this.value=add_comma(this.value,0);" onKeyPress="return onlyNumber(event.keyCode);" >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약일자&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td">
											<s:calendar id_from="cont_from_date" id_to="cont_to_date" default_from="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" default_to="" format="%Y/%m/%d"/>
										</td>										
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;변경사유</td>
										<td class="data_td" colspan="3">
											<textarea id="reason" name="reason" rows="5" style="width: 98%;" onKeyUp="return chkMaxByte(500, this, '변경사유');"></textarea>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:doSave()", "등록");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:window.close()", "닫기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
	<iframe name="childFrame" src="" frameborder="1" width="0" height="50" marginwidth="0" marginheight="0" scrolling="yes"> </iframe>
</s:header>
<s:footer/>
</body>
</html>