<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SRQ_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SRQ_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="SRQ_005";%>

<%
    String HOUSE_CODE 	= info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    String CTRL_CODE 	= info.getSession("CTRL_CODE");
    String dNameLoc 	= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT_NAME_LOC"));
    String depart 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
    
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
	String to_date = to_day;
    
%>

<html>
	<head>
	<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		
		<%@ include file="/include/include_css.jsp"%>
		<%-- Dhtmlx SepoaGrid용 JSP--%>
		<%@ include file="/include/sepoa_grid_common.jsp"%>
		<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
		<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
		<%-- Ajax SelectBox용 JSP--%>
		<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
		<!-- 사용자 정의 Script -->
		<!-- HEADER START (JavaScript here)-->

		<script language="javascript" type="text/javascript">
//<!--
	var mode;

	var IDX_SELECTED           ;
	var IDX_RFQ_NO             ;
	var IDX_RFQ_COUNT          ;
	var IDX_RFQ_QTY            ;
	var IDX_QTA_NO             ;
    var IDX_CUSTOMER_PRICE     ;
    var IDX_SUPPLY_PRICE       ;
	var IDX_SUPPLY_AMT         ;
	
		
		
		function Init()
    {
		
		setGridDraw();
		setHeader();
        doSelect();
        
    }
	
	function setHeader() {


		IDX_SELECTED                    = GridObj.GetColHDIndex("SELECTED");
		IDX_RFQ_NO                      = GridObj.GetColHDIndex("RFQ_NO");
		IDX_RFQ_COUNT                   = GridObj.GetColHDIndex("RFQ_COUNT");
		IDX_QTA_NO                   	= GridObj.GetColHDIndex("QTA_NO");
		IDX_RFQ_QTY                  	= GridObj.GetColHDIndex("RFQ_QTY");
		IDX_CUSTOMER_PRICE              = GridObj.GetColHDIndex("CUSTOMER_PRICE");
		IDX_CUSTOMER_AMT                = GridObj.GetColHDIndex("CUSTOMER_AMT");
		IDX_SUPPLY_PRICE                = GridObj.GetColHDIndex("UNIT_PRICE");
		IDX_SUPPLY_AMT                  = GridObj.GetColHDIndex("ITEM_AMT");
	}  

	function doSelect() {
		
		var start_date = del_Slash( form1.start_date.value );
		var end_date   = del_Slash( form1.end_date.value   );

		if(LRTrim(form1.start_date.value) == "" || LRTrim(form1.end_date.value) == "" ) {
			alert("요청일자를 입력하셔야 합니다.");
			return;
		}
		if(!checkDate(start_date)) {
			alert("요청일자를 확인하세요.");
			form1.start_date.select();
			return;
		}
		if(!checkDate(end_date)) {
			alert("요청일자를 확인하세요.");
			form1.end_date.select();
			return;
		}

		
		$('#create_type').val("PR");
		
		form1.start_date.value = del_Slash( form1.start_date.value );
		form1.end_date.value   = del_Slash( form1.end_date.value   );
		
	    var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.qta.qta_bd_lis2";
        var cols_ids = "<%=grid_col_id%>";
        var params = "mode=getCompanyQtaList";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        GridObj.post( G_SERVLETURL, params);
        GridObj.clearAll(false);
		
	}

    //구매담당
    function SP0216_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=HOUSE_CODE%>&values=<%=COMPANY_CODE%>&values=&values=";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
   		document.form1.change_user.value = ls_ctrl_code;
   		document.form1.txtchange_user.value = ls_ctrl_name;
	}

	function checkUser() {
		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = true;

  		for(var row=0; row<GridObj.GetRowCount(); row++) {
  			if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
  				for( i=0; i<ctrl_code.length; i++ )
				{
  					if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, IDX_CTRL_CODE)) {
  						flag = true;
  						break;
  					} else flag = false;
  				}
  			}
  		}

		if (!flag)
			alert("작업을 수행할 권한이 없습니다.");

  		return flag;
  	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		for(var i=0;i<GridObj.GetRowCount();i++) {
	           if(i%2 == 1){
			    for (var j = 0;	j<GridObj.GetColCount(); j++){
			        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
		        }
	           }
		}
		if(msg1 == "t_imagetext") { //견적요청번호 click
            if(msg3 == IDX_RFQ_NO) { //견적요청번호
                rfq_no = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_NO),msg2);
                rfq_count = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_COUNT);

                window.open("/s_kr/bidding/rfq/rfq_pp_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"rfq_win1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1050,height=640,left=0,top=0");
            }

            else if(msg3 == IDX_QTA_NO) { //견적서번호
                st_qta_no = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_QTA_NO),msg2);
                st_rfq_no = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_NO),msg2);
                st_rfq_count = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_COUNT);

                send_url = "qta_pp_dis1.jsp?st_vendor_code=<%=info.getSession("COMPANY_CODE")%>"+"&st_qta_no=" + st_qta_no;
                send_url += "&st_rfq_no=" + st_rfq_no + "&st_rfq_count=" + st_rfq_count;

                window.open(send_url,"qta_win1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=1050,height=760,left=0,top=0");
            }
		}

		else if(msg1 == "doData") {
			alert(GD_GetParam(GridObj,0));
			if(mode == "setRfqDelete") {
				if("1" == GridObj.GetStatus()) doSelect();
			}
			if(mode == "setRFQClose") {
				if("1" == GridObj.GetStatus()) doSelect();
			}
		}else  if(msg1 == "doQuery")  {

	        //GridObj.SetGroupMerge("RFQ_NO,RFQ_COUNT,SUBJECT,QTA_NO,CHANGE_USER_NAME_LOC");

            var maxRow = GridObj.GetRowCount();
			var customer_unitPrice;
			var supply_unitPrice;
			
			
            for(i=0; i<maxRow; i++) {
            	customer_unitPrice = GridObj.cells(GridObj.getRowId(i),IDX_CUSTOMER_PRICE).getValue(); //GD_GetCellValueIndex(GridObj,i, IDX_CUSTOMER_PRICE);
				//var supply_unitPrice   = GridObj.cells(GridObj.getRowId(i),IDX_SUPPLY_PRICE).getValue(); //GD_GetCellValueIndex(GridObj,i, IDX_SUPPLY_PRICE);
            	
				
             	if(eval(customer_unitPrice) > 0){
            		calculate_grid_amt(GridObj, i, IDX_RFQ_QTY, IDX_CUSTOMER_PRICE, "1", "CUSTOMER_AMT");
            	} 
            	/* if(eval(supply_unitPrice) > 0){
        	    		calculate_grid_amt(GridObj, i, IDX_RFQ_QTY, IDX_SUPPLY_PRICE, "1", "ITEM_AMT");
            	} */
            	
            	
				//customer_unitPrice = GD_GetCellValueIndex(GridObj,i, IDX_CUSTOMER_PRICE);
				//supply_unitPrice = GD_GetCellValueIndex(GridObj,i, IDX_SUPPLY_PRICE);

				//if(eval(customer_unitPrice) > 0){
				//	itemQty = GD_GetCellValueIndex(GridObj,i, IDX_RFQ_QTY);
                //	var tmp_amt = eval(customer_unitPrice) * eval(itemQty);
                	//GD_SetCellValueIndex(GridObj,i, IDX_CUSTOMER_AMT, setAmt(tmp_amt));
               // }
				//itemQty = GD_GetCellValueIndex(GridObj,i, IDX_RFQ_QTY);
                //var tmp_amt = eval(supply_unitPrice) * eval(itemQty);
                //GD_SetCellValueIndex(GridObj,i, IDX_SUPPLY_AMT, tmp_amt);
            }
	    }
	}

	function getVendorCode(setMethod) {
		popupvendor(setMethod);
	}
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = desc2;
	}

	function popupvendor( fun )
	{
	    var url = "/kr/admin/wisepopup/ose_pp_lis1.jsp?function=" + fun;
	    var width = 650;
	    var height = 500;

	    var dim = new Array(2);

	    dim = CenterWindow(height,width);
	    top = dim[0];
	    left = dim[1];

	    var left = left;
	    var top = top;

	    var toolbar = 'no';
	    var menubar = 'no';
	    var status = 'no';
	    var scrollbars = 'no';
	    var resizable = 'no';
	    var vendor_search = window.open( url, 'vendor_search', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	    vendor_search.focus();
	}

   /*  function start_date(year,month,day,week) {
           document.form1.start_date.value=year+month+day;
    }

    function end_date(year,month,day,week) {
           document.form1.end_date.value=year+month+day;
    }

 */
//-->
</script>



<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,합계,단가,합계,#rspan,#rspan,#rspan");
    	
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	var vendorCode = "<%=info.getSession("ID")%>";
	
	if(cellInd == GridObj.getColIndexById("RFQ_NO")) {
		var rfqNo    = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
		var rfqCount = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
	    var url = '/s_kr/bidding/rfq/rfq_pp_dis1.jsp?rfq_no=' + encodeUrl(rfqNo) + '&rfq_count=' + encodeUrl(rfqCount) + '&screen_flag=search&popup_flag=true';
	    popUpOpen(url, 'GridCellClick', '1024', '650');
	}else if(cellInd == GridObj.getColIndexById("QTA_NO")) {
		
		var st_qta_no = SepoaGridGetCellValueId(GridObj, rowId, "QTA_NO");

		if(LRTrim(st_qta_no	) == "")
			return;

		var st_close_data 	= "";	//SepoaGridGetCellValueId(GridObj, rowId, "CLOSE_DATA");
		var rfqNo    		= SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
		var rfqCount 		= SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");

		if (st_qta_no=="견적포기"){
			alert("업체에서 견적 포기한 건입니다.");
			return;
		}
		var url = "/s_kr/bidding/qta/qta_pp_dis1.jsp?st_vendor_code=" + vendorCode + "&st_qta_no=" + st_qta_no + "&t_flag=Y";
		    url += "&st_rfq_no=" + rfqNo + "&st_rfq_count=" + rfqCount + "&st_close_data=" + st_close_data;
	    //var url = 'rfq_bd_dis1.jsp?rfq_no=' + encodeUrl(rfqNo) + '&rfq_count=' + encodeUrl(rfqCount) + '&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '1012', '760');
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
    
    form1.start_date.value = add_Slash( form1.start_date.value );
    form1.end_date.value   = add_Slash( form1.end_date.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->
<form name="form1" action="">
	<input type="hidden" name="h_rfq_no" id="h_rfq_no">
	<input type="hidden" name="h_rfq_count" id="h_rfq_count">
	<input type="hidden" name="create_type" id="create_type">

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
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			 작성일
		</td>
		<td width="35%" class="data_td">
			<s:calendar id="start_date" default_value="<%=SepoaString.getDateSlashFormat( from_date ) %>" format="%Y/%m/%d"/>
			~
			<s:calendar id="end_date" default_value="<%=SepoaString.getDateSlashFormat( to_date ) %>" format="%Y/%m/%d"/>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			 견적요청번호
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="rfq_no" id="rfq_no" style="width:95%;ime-mode:inactive" class="inputsubmit" maxlength="14">
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			 선정여부
		</td>
		<td class="data_td">
			<select name="settle_flag" id="settle_flag" class="inputsubmit">
				<option value="">
					전체
				</option>
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			 견적요청명
		</td>
		<td class="data_td">
			<input type="text" name="subject" id="subject" style="width:95%" maxlength="20" class="inputsubmit">
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
	<td height="30" align="left">
		<TABLE cellpadding="0">
      	<TR>
  	  	</TR>
  		</TABLE>
  	</td>
  	<td height="30" align="right">
		<TABLE cellpadding="0">
      	<TR>
  	  		<td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
  	  		<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td>
  	  	</TR>
  		</TABLE>
  	</td>
</tr>
</table>


</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SRQ_005" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


