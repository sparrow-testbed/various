<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/rfq/rat_bd_lis2.jsp -->
<!--
Title:         역경매결과  <p>
 Description:  역경매결과<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="AU_004";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<%
	String USER_NAME 	= info.getSession("NAME_LOC");
	String company_code = info.getSession("COMPANY_CODE");
	String house_code   = info.getSession("HOUSE_CODE");
%>
<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>

<script language="javascript">
<!--
    var mode;

	var INDEX_SELECTED
    var INDEX_ANN_NO;
    var INDEX_SUBJECT;
    var INDEX_ATTACH_NO;
    var INDEX_END_DATETIME ;
    var INDEX_BID_COUNT;
    var INDEX_SETTLE_FLAG;
    var INDEX_NAME_LOC;
    var INDEX_CURRENT_PRICE;
    var INDEX_RESERVE_PRICE;
    var INDEX_BID_PRICE;
    var INDEX_PR_NO;
    var INDEX_RA_NO;
    var INDEX_RA_COUNT;
    var INDEX_VENDOR_CODE;
    var INDEX_PRINT_NO;
    var INDEX_SETTLE_HIDDEN_FLAG;

    function init() {
		setGridDraw();
		setHeader();
        doSelect();
    }

    function setHeader() {
    	GridObj.strHDClickAction="sortmulti";
// 		GridObj.SetColCellSortEnable(	     "END_DATETIME"  ,false);
// 		GridObj.SetNumberFormat(	     "CURRENT_PRICE" ,G_format_amt);
// 		GridObj.SetColCellSortEnable(	     "CURRENT_PRICE" ,false);
// 		GridObj.SetNumberFormat(	     "RESERVE_PRICE" ,G_format_amt);
// 		GridObj.SetColCellSortEnable(	     "RESERVE_PRICE" ,false);
// 		GridObj.SetNumberFormat(	     "BID_PRICE"     ,G_format_amt);
// 		GridObj.SetColCellSortEnable(	     "BID_PRICE"     ,false);
// 		GridObj.SetColCellSortEnable(      "RA_NO"         ,false);
// 		GridObj.SetColCellSortEnable(		 "RA_COUNT"      ,false);
// 		GridObj.SetColCellSortEnable(	 "VENDOR_CODE"   ,false);
// 		GridObj.SetColCellSortEnable(	 "NB_REASON"   	 ,false);

        INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
        INDEX_ANN_NO            = GridObj.GetColHDIndex("ANN_NO");
        INDEX_SUBJECT           = GridObj.GetColHDIndex("SUBJECT");
        INDEX_ATTACH_NO         = GridObj.GetColHDIndex("ATTACH_NO");
        INDEX_END_DATETIME      = GridObj.GetColHDIndex("END_DATETIME");
        INDEX_BID_COUNT         = GridObj.GetColHDIndex("BID_COUNT");
        INDEX_SETTLE_FLAG       = GridObj.GetColHDIndex("SETTLE_FLAG");
        INDEX_NAME_LOC          = GridObj.GetColHDIndex("NAME_LOC");
        INDEX_CURRENT_PRICE     = GridObj.GetColHDIndex("CURRENT_PRICE");
        INDEX_RESERVE_PRICE     = GridObj.GetColHDIndex("RESERVE_PRICE");
        INDEX_BID_PRICE         = GridObj.GetColHDIndex("BID_PRICE");
        INDEX_PR_NO             = GridObj.GetColHDIndex("PR_NO");
        INDEX_RA_NO             = GridObj.GetColHDIndex("RA_NO");
        INDEX_RA_COUNT          = GridObj.GetColHDIndex("RA_COUNT");
        INDEX_VENDOR_CODE       = GridObj.GetColHDIndex("VENDOR_CODE");
        INDEX_NB_REASON         = GridObj.GetColHDIndex("NB_REASON");
        INDEX_PRINT_NO          = GridObj.GetColHDIndex("PRINT_NO");
        INDEX_SETTLE_HIDDEN_FLAG = GridObj.GetColHDIndex("SETTLE_HIDDEN_FLAG");
    }

    //조회버튼을 클릭
    function doSelect() {
    	
    	form1.from_date.value = del_Slash(form1.from_date.value);
    	form1.to_date.value = del_Slash(form1.to_date.value);
    	
    	var from_date			= LRTrim(form1.from_date.value);
    	var to_date	    		= LRTrim(form1.to_date.value);
    	var ann_no	    		= LRTrim(form1.ann_no.value).toUpperCase();
    	var bid_flag			= LRTrim(form1.bid_flag.value);
		var CHANGE_USER_NAME	= LRTrim(form1.CHANGE_USER_NAME.value);


    	if(from_date == "" || to_date == "" ) {
    		alert("생성일자를 입력하셔야 합니다.");
    		return;
    	}
    	if(!checkDate(form1.from_date.value)) {
    		alert("생성일자를 확인하세요.");
    		form1.from_date.select();
    		return;
    	}
    	if(!checkDate(form1.to_date.value)) {
    		alert("생성일자를 확인하세요.");
    		form1.to_date.select();
    		return;
    	}

		if(eval(document.forms[0].to_date.value) < eval(document.forms[0].from_date.value))
		{
			alert("생성일자를 확인하세요.");
			return;
		}
		
		
        var mode   = "getratbdlis2_1";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis2";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);
    }
    
    function checkValue(){
    	var wise = GridObj;
    	var count = 0;
    	for(var i = 0; i < wise.GetRowCount(); i++){
    		var temp = wise.GetCellValue("SELECTED", i);
    		if(temp == 1){
    			count++;
    		}
    	}
    	return count;
    }
    
    function checkNB(){
    	var wise = GridObj;
    	
    	for(var i = 0; i < wise.GetRowCount(); i++){
    		var temp = wise.GetCellValue("SELECTED", i);
    		if(temp == 1){
    			var settle_flag = wise.GetCellValue("SETTLE_HIDDEN_FLAG", i);
    			var proceeding_flag = wise.GetCellValue("PROCEEDING_FLAG", i);
    			if(settle_flag == "N"){
    				alert("유찰된건은 낙찰취소 할 수 없습니다.");
    				return;
    			}
    			//A:품의진행, B:품의완료, C:소싱진행, E:품의대기 ,F:입고완료, O:발주완료, P:구매대기, R:구매반송
    			if(proceeding_flag != "E"){
    				alert("품의가 진행중입니다.");
    				return;
    			}
    		}
    	}
    	return true;
    }
     
    function doCancelBid(){
		
		// 구매품의서 작성 or 품의단계에서는 처리할 수 없음  
		// 분기하여 경고창 해줘야됨~
    	
//     	servletUrl = "/servlets/dt.rat.rat_bd_lis2"; //p1008
		
		if(checkValue() == 0){
			alert("선택된 ROW가 없습니다.");
			return;
		}else if(checkValue() > 1){
			alert("한건만 선택하실 수 있습니다.");
			return;
		}
		
		if(!checkNB()) return;
		
		if(!confirm("낙찰을 취소하시겠습니까?")) return;
		
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis2";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setCancelBid";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
    }
    
    
    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
    	if(msg1 == "t_imagetext") {
    		
    		
    		var ra_no		= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_NO")).getValue());
    		var ra_count	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_COUNT")).getValue());
    		var pr_no       = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PR_NO")).getValue());
    		

    		if(msg3 == INDEX_ANN_NO) {
    			window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1dd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
//    			window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
		    } else if(msg3 == INDEX_SUBJECT) { //역경매건명
		    	
		    	var settle_flag = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("SETTLE_FLAG")).getValue());
		    	
                if (settle_flag == "낙찰") {
        			window.open("/ebid_doc/reveracutionresult.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&REQ_PR_NO="+pr_no+"&CREATE_FLAG=P","windowopen2dd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1000,height=740,left=0,top=0");
//        			window.open("/ebid_doc/reveracutionresult.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&REQ_PR_NO="+pr_no+"&CREATE_FLAG=P","windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1000,height=490,left=0,top=0");
                }else{
                	var REASON = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("NB_REASON")).getValue());
        			window.open("/ebid_doc/reveracutionresult.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&REQ_PR_NO="+pr_no+"&CREATE_FLAG=P","windowopen2dd","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1000,height=740,left=0,top=0");
//	    			window.open( "/kr222/dt/rat/rat_pp_ins21.jsp?REASON="+REASON , "rat_pp_ins21","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=no,resizable=no,width=600,height=170,left=0,top=0");
                }
		    } else if(msg3 == INDEX_ATTACH_NO) { //첨부파일
				var attach_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ATTACH_NO);
				if (attach_no != "") {
					rMateFileAttach('P','R','RA',attach_no);
				}
			} else if(msg3 ==  INDEX_BID_COUNT){ // 참가업체수	
				var row_idx = msg2;

        		if (row_idx == -1) return;

				document.form1.ra_no.value 					= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_NO")).getValue());
				document.form1.ra_count.value 				= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_COUNT")).getValue());
				document.form1.ann_item.value 				= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("SUBJECT")).getValue());				
				document.form1.ra_type1.value 				= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_TYPE1")).getValue());			
				document.form1.change_user_name_loc.value 	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("CHANGE_USER_NAME")).getValue());		
				document.form1.editable.value 				= "N";
		
       			url =  "/kr/dt/rat/rat_bd_ins3.jsp";
  	   			window.open( "", "doReverseRegReq","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=700,height=500,left=0,top=0");
   	   			document.form1.method = "POST";
	   			document.form1.action = url;
	   			document.form1.target = "doReverseRegReq";
	   			document.form1.submit();
			
			}
    	}else if(msg1 == "t_insert") {
            if(msg3 == INDEX_SELECTED) {
                for(i=0; i<GridObj.GetRowCount(); i++) {
                    if("true" == GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED)) {
                        if(i != msg2) {
                            GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "false&", "&");
                        }
                    }
                }
            }
        }else if(msg1 == "doQuery") {
		
	    }else if(msg1 == "doData"){
// 	    	alert(GridObj.GetMessage());
	    	doSelect();
	    }
    }

    function to_date(year,month,day,week) {
    	document.form1.to_date.value=year+month+day;
    }

    function from_date(year,month,day,week) {
    	document.form1.from_date.value=year+month+day;
    }

	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];
	
		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "P") {
			var protocol = location.protocol;
			var host     = location.host;
			var addr     = protocol +"//" +host;

			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

			f.method = "POST";
			f.target = "fileattach";
			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
			f.submit();
		}
	}

/-->
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
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

--%> 
    
	var header_name = LRTrim(GridObj.getColumnId(cellInd));
	
	if( header_name == "NAME_LOC") {
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
    
	if("undefined" != typeof JavaCall) {
		type = "";
		if(GridObj.getColType(cellInd) == 'img') {
			type = "t_imagetext";
		}
		JavaCall("t_imagetext", rowId, cellInd);
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
//         doQuery();
		doSelect();
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
	form1.from_date.value = add_Slash(form1.from_date.value);
	form1.to_date.value = add_Slash(form1.to_date.value);
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<form name="form1" >
	<input type="hidden" id="att_mode"   			name="att_mode"  	value="">
	<input type="hidden" id="view_type"  			name="view_type"  	value="">
	<input type="hidden" id="file_type"  			name="file_type"  	value="">
	<input type="hidden" id="tmp_att_no" 			name="tmp_att_no" 	value="">
	
	
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
		<tr>
			<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 생성일자</td>
	      	<td width="20%" height="24" class="data_td">
	      		<s:calendar id="from_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" 	format="%Y/%m/%d"/>~
      			<s:calendar id="to_date"   default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1))%>" 									format="%Y/%m/%d"/>
	      	</td>
	      	<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 낙찰여부</td>
	      	<td width="20%" height="24" class="data_td">
	        	<select id="bid_flag" name="bid_flag" class="inputsubmit">
	          		<option value="">전체</option>
	          		<option value="Y">낙찰</option>
	          		<option value="N">유찰</option>
	          		<option value="D">취소</option>
	        	</select>
	      	</td>
	    </tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  	    
	    <tr>
	      	<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
	      	<td width="20%" height="24" class="data_td">
	        	<input type="text" id="ann_no" name="ann_no" style="ime-mode:inactive" size="20" maxlength="14" class="inputsubmit" onkeydown='entKeyDown()' >
	      	</td>
	      	<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자</td>
	      	<td width="20%" height="24" class="data_td">
			 	<input type="text" id="CHANGE_USER_NAME" name="CHANGE_USER_NAME"  value="<%=USER_NAME%>" size="10" maxlength="10" class="inputsubmit" onkeydown='entKeyDown()' >
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
					<tr>
						<td><script language="javascript">btn("javascript:doCancelBid()","낙찰취소")</script></td>
						<td><script language="javascript">btn("javascript:doSelect()","조 회")</script> </td>
					</tr>
				</TABLE>
			</td>
		</tr>
	</table>
</form>

<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
	<!---- END OF USER SOURCE CODE ---->
</s:header>
<s:grid screen_id="AU_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


