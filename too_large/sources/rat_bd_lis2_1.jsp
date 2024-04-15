<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_006";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/s_kr/bidding/rat/rat_bd_lis2.jsp -->
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
<% String WISEHUB_PROCESS_ID="AU_006";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>
<%

String company_code = info.getSession("COMPANY_CODE");

%>
<script language="javascript">
<!--
var mode;

    var INDEX_ANN_NO;
    var INDEX_SUBJECT;
    var INDEX_ATTACH_NO;
    var INDEX_START_TEXT;
    var INDEX_END_TEXT;
    var INDEX_BID_COUNT;
    var INDEX_CUR;
    var INDEX_BID_PRICE;
    var INDEX_CURRENT_PRICE;
    var INDEX_SETTLE_FLAG;
    var INDEX_COMPANY_CODE;
    var INDEX_RA_NO;
    var INDEX_RA_COUNT;

	function init() {
setGridDraw();
setHeader();
        doSelect();
    }

    function setHeader() {


        
        //GridObj.AddHeader(       "CONT_STATUS",		"단가제출여부","t_text",100,100,false);
    	

// 	    GridObj.strHDClickAction="sortmulti";
// 		GridObj.SetColCellSortEnable(	     "START_TEXT"       ,false);
// 		GridObj.SetColCellSortEnable(	     "END_TEXT"         ,false);
// 		GridObj.SetColCellSortEnable(    "BID_COUNT"        ,false);
// 		GridObj.SetNumberFormat(	     "BID_PRICE"        ,G_format_amt);
// 		GridObj.SetColCellSortEnable(	     "BID_PRICE"        ,false);
// 		GridObj.SetNumberFormat(	     "CURRENT_PRICE"    ,G_format_amt);
// 		GridObj.SetColCellSortEnable(	     "CURRENT_PRICE"    ,false);
// 		GridObj.SetColCellSortEnable(		     "CUR"              ,false);
// 		GridObj.SetColCellSortEnable(	     "SETTLE_FLAG"      ,false);
// 		GridObj.SetColCellSortEnable(  "COMPANY_CODE"     ,false);
// 		GridObj.SetColCellSortEnable(      "RA_NO"            ,false);
// 		GridObj.SetColCellSortEnable(		 "RA_COUNT"         ,false);
		
        INDEX_ANN_NO                = GridObj.GetColHDIndex("ANN_NO");
        INDEX_SUBJECT               = GridObj.GetColHDIndex("SUBJECT");
        INDEX_ATTACH_NO         = GridObj.GetColHDIndex("ATTACH_NO");
        INDEX_START_TEXT            = GridObj.GetColHDIndex("START_TEXT");
        INDEX_END_TEXT              = GridObj.GetColHDIndex("END_TEXT");
        INDEX_BID_COUNT             = GridObj.GetColHDIndex("BID_COUNT");
        INDEX_CUR                   = GridObj.GetColHDIndex("CUR");
        INDEX_BID_PRICE             = GridObj.GetColHDIndex("BID_PRICE");
        INDEX_CURRENT_PRICE         = GridObj.GetColHDIndex("CURRENT_PRICE");
        INDEX_SETTLE_FLAG           = GridObj.GetColHDIndex("SETTLE_FLAG");
        INDEX_COMPANY_CODE          = GridObj.GetColHDIndex("COMPANY_CODE");
        INDEX_RA_NO                 = GridObj.GetColHDIndex("RA_NO");
        INDEX_RA_COUNT              = GridObj.GetColHDIndex("RA_COUNT");
        
    }

    //조회버튼을 클릭
    function doSelect(){
    	var from_date		= del_Slash( form1.from_date.value );
    	var to_date			= del_Slash( form1.to_date.value );
    	var settle_flag		= form1.settle_flag.value;

    	if(from_date == "" || to_date == "" ) {
    		alert("마감일자를 입력하셔야 합니다.");
    		return;
    	}

        if(!checkDateCommon(from_date)) {
        	alert("마감일자를 확인하세요.");
        	document.forms[0].from_date.select();
        	return;
        }

        if(!checkDateCommon(to_date)) {
        	alert("마감일자를 확인하세요.");
        	document.forms[0].to_date.select();
        	return;
        }
        
        form1.from_date.value = del_Slash( form1.from_date.value );
        form1.to_date.value   = del_Slash( form1.to_date.value   );

        var mode   = "getratbdlis2_1";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rat.rat_bd_lis2";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
    	if(msg1 == "t_imagetext") {
    		var ra_no		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_NO),msg2);
    		var ra_count	= GD_GetCellValueIndex(GridObj,msg2, INDEX_RA_COUNT);
    		var SETTLE_FLAG	= GD_GetCellValueIndex(GridObj,msg2, INDEX_SETTLE_FLAG);

    		if(msg3 == INDEX_ANN_NO) { //공고번호
    			window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
		    } else if(msg3 == INDEX_ATTACH_NO) { //첨부파일
				var attach_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ATTACH_NO);
				if (attach_no != "") {
                	rMateFileAttach('P','R','RA',attach_no);
                }
    		}

            if(msg3 == INDEX_SUBJECT) {
                if(SETTLE_FLAG == "Y") { // 입찰공고, 정정공고
                    window.open('/s_kr/bidding/rat/rat_pp_ins4.jsp?RA_NO='+ra_no+'&RA_COUNT='+ra_count+'&VENDOR_CODE=<%=company_code%>',"rat_pp_ins4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                }else{
                	alert("낙찰되지 않은 건 입니다.");
                	return;
                }
            }

    	}
    	else if(msg1 == "doData") {
    		if(mode == "delete") {
    			if("1" == GridObj.GetStatus()) doSelect();
    		}
    	}
    	else if(msg1 == "doQuery") {
			/*
			for(var i = 0; i < GridObj.GetRowCount(); i++) {
				if( "Y" == GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_SETTLE_FLAG),i)) {
        			for (var j = 0; j < GridObj.GetColCount(); j++) {
    					GridObj.SetCellBgColor(GridObj.GetColHDKey( j),i, "254|251|226");
        			}
				}
			}
			*/
    	}
    }

    function from_date(year,month,day,week) {
    	document.form1.from_date.value=year+month+day;
    }

    function to_date(year,month,day,week) {
    	document.form1.to_date.value=year+month+day;
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
    if(GridObj.getColIndexById("ANN_NO") == cellInd){
		var ra_no		= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_NO")).getValue());
		var ra_count	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_COUNT")).getValue());
		
        window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    form1.from_date.value = add_Slash( form1.from_date.value );
    form1.to_date.value   = add_Slash( form1.to_date.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->
<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- 	<tr> -->
<!-- 		<td class="cell_title1" width="78%" align="left">&nbsp; -->
<%-- 	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12"> --%>
<%-- 	  	<%@ include file="/include/sepoa_milestone.jsp" %> --%>
<!-- 	  	</td> -->
<!-- 	</tr> -->
<!-- </table> -->
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
		<form name="form1" >
		<input type="hidden" name="h_rfq_no">
		<input type="hidden" name="h_rfq_count">
		<input type="hidden" name="att_mode"  value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
	
	    <tr>
	      <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 마감일자</td>
	      <td width="20%" height="24" class="data_td">
	      	<s:calendar id="from_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) )%>" 	format="%Y/%m/%d"/>~
	      	<s:calendar id="to_date"   default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), 1) )%>" 									format="%Y/%m/%d"/>
	      </td>
	      <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 선정여부</td>
	      <td width="20%" height="24" class="data_td">
	        <select id="settle_flag" name="settle_flag" class="inputsubmit">
	          <option value=''>전체</option>
	          <option value="Y">Y</option>
	          <option value="N">N</option>
	        </select>
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
						<TD><script language="javascript">btn("javascript:doSelect()","조 회")   </script></TD>
	    	  		</TR>
	   			</TABLE>
	   		</td>
	   	</tr>
	</table>
  </form>

<!---- END OF USER SOURCE CODE ---->


</s:header>
<s:grid screen_id="AU_006" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


