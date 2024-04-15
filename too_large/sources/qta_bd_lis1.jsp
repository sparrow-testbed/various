<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SRQ_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SRQ_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="SRQ_004";%>
<%
	String house_code = info.getSession("HOUSE_CODE");
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
	
	String to_date = to_day;
    String to_time = SepoaDate.getShortTimeString();
%>

<html>
	<head>
		<title>
			<%=text.get("MESSAGE.MSG_9999")%>
		</title> <%-- 우리은행 전자구매시스템 --%>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<%@ include file="/include/include_css.jsp"%>
		<%-- Dhtmlx SepoaGrid용 JSP--%>
		<%@ include file="/include/sepoa_grid_common.jsp"%>
		<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
		<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
		<%-- Ajax SelectBox용 JSP--%>
		<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript" type="text/javascript">
//<!--
    var mode;

	var IDX_SELECTED             ;            
	var IDX_BUYER_COMPANY_NAME   ;             
	var IDX_QTA_NO               ;            
	var IDX_QTA_DATE             ;            
	var IDX_QTA_VAL_DATE         ;            
	
	var IDX_RFQ_NO               ;            
	var IDX_RFQ_COUNT            ;            
	var IDX_SETTLE_TYPE          ;            
	var IDX_SITUATION            ;            
	var IDX_SUBJECT              ;            
	
	var IDX_CLOSE_DATE           ;            
	var IDX_ITEM_CNT             ;            
	var IDX_CONFIRM_DATE         ;            
	var IDX_ADD_USER_NAME        ;            
	var IDX_STATUS               ;            
	
	var IDX_BUYER_COMPANY_CODE   ;             
	var IDX_RFQ_FLAG             ;            
	var IDX_RFQ_CLOSE_DATE       ;
	var IDX_QTA_STATUS			 ;       

	
	function Init()
    {
		
		setGridDraw();
		setHeader();
        doSelect();
        
    }
	
    function setHeader() {

        


		/* GridObj.SetColCellSortEnable("SELECTED",false);
		GridObj.SetDateFormat("QTA_DATE",  "yyyy/MM/dd");
		GridObj.SetDateFormat("QTA_VAL_DATE",  "yyyy/MM/dd");
		GridObj.SetDateFormat("CONFIRM_DATE",  "yyyy/MM/dd");
		GridObj.SetColCellSortEnable("STATUS",false);
		GridObj.SetColCellSortEnable("BUYER_COMPANY_CODE",false);
		GridObj.SetColCellSortEnable("RFQ_FLAG",false);
		GridObj.SetColCellSortEnable("RFQ_CLOSE_DATE",false); */
		
		
		IDX_SELECTED                     = GridObj.GetColHDIndex("SELECTED");        
		IDX_QTA_NO                  = GridObj.GetColHDIndex("QTA_NO");
		IDX_QTA_DATE                = GridObj.GetColHDIndex("QTA_DATE");
		IDX_QTA_VAL_DATE            = GridObj.GetColHDIndex("QTA_VAL_DATE");		
		IDX_RFQ_NO                  = GridObj.GetColHDIndex("RFQ_NO");
		
		IDX_RFQ_COUNT               = GridObj.GetColHDIndex("RFQ_COUNT");
		IDX_SETTLE_TYPE             = GridObj.GetColHDIndex("SETTLE_TYPE");
		IDX_SITUATION               = GridObj.GetColHDIndex("SITUATION");
		IDX_SUBJECT                 = GridObj.GetColHDIndex("SUBJECT");		
		IDX_CLOSE_DATE              = GridObj.GetColHDIndex("CLOSE_DATE");    
		    
		IDX_BUYER_COMPANY_NAME      = GridObj.GetColHDIndex("BUYER_COMPANY_NAME"); 
		IDX_ITEM_CNT                = GridObj.GetColHDIndex("ITEM_CNT");
		IDX_CONFIRM_DATE            = GridObj.GetColHDIndex("CONFIRM_DATE");
		IDX_ADD_USER_NAME           = GridObj.GetColHDIndex("ADD_USER_NAME");
		IDX_STATUS                  = GridObj.GetColHDIndex("STATUS");
		
		IDX_BUYER_COMPANY_CODE      = GridObj.GetColHDIndex("BUYER_COMPANY_CODE");
		IDX_RFQ_FLAG                = GridObj.GetColHDIndex("RFQ_FLAG");
		IDX_RFQ_CLOSE_DATE          = GridObj.GetColHDIndex("RFQ_CLOSE_DATE");       
		IDX_QTA_STATUS		        = GridObj.GetColHDIndex("QTA_STATUS");       
    }

    function doSelect() {

        var fr = document.forms[0];
        
        var start_rfq_date = del_Slash( fr.start_rfq_date.value );
        var end_rfq_date   = del_Slash( fr.end_rfq_date.value   );

        if(LRTrim(fr.start_rfq_date.value) == "" || LRTrim(fr.end_rfq_date.value) == "" ) {
            alert("생성일을 입력하셔야 합니다.");
            return;
        }

        if(!checkDateCommon(start_rfq_date)) {
            alert("생성일을 확인하세요.");
            document.forms[0].start_rfq_date.select();
            return;

        }

        if(!checkDateCommon(end_rfq_date)) {
            alert("생성일을 확인하세요.");
            document.forms[0].end_rfq_date.select();
            return;

        }

        /* var start_rfq_date = LRTrim(fr.start_rfq_date.value);
        var end_rfq_date   = LRTrim(fr.end_rfq_date.value); 
        var status    = fr.STATUS.options[fr.STATUS.selectedIndex].value;     //진행상황
        var settle_type  = fr.settle_type.options[fr.settle_type.selectedIndex].value;
		var subject   = LRTrim(fr.subject.value); */
<%--         servletUrl = "<%=getWiseServletPath("supply.bidding.qta.qta_bd_lis1")%>"; --%>
        
        

       /*  GridObj.SetParam("mode", "getQtaList");
        GridObj.SetParam("start_date", start_rfq_date);
        GridObj.SetParam("end_date", end_rfq_date); 
        GridObj.SetParam("status", status);
        GridObj.SetParam("settle_type", settle_type);
        GridObj.SetParam("subject", subject);
        GridObj.SetParam("create_type", "PR");  
        
        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
        GridObj.strHDClickAction="sortmulti"; */
        
        //$('#str_status').val(fr.status.options[fr.status.selectedIndex].value);
        
        fr.start_rfq_date.value = del_Slash( fr.start_rfq_date.value );
        fr.end_rfq_date.value   = del_Slash( fr.end_rfq_date.value   );
        
        var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.qta.qta_bd_lis1";
        var cols_ids = "<%=grid_col_id%>";
        var params = "mode=getCurrentQtaList";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        GridObj.post( G_SERVLETURL, params);
        GridObj.clearAll(false);
        
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
        var maxRow = GridObj.GetRowCount();

        if( msg1 == "doQuery" )
        {

        }
        if(msg1 == "doData") {
            if(mode =="setQtDelete") {
                if(GridObj.GetStatus() == "0") {
                         alert(GD_GetParam(GridObj,0));
                      return;
                } else {
                         alert(GD_GetParam(GridObj,0));
                      for(var j = (maxRow-1);j >= 0 ; j--){
                         var check = GD_GetCellValueIndex(GridObj,j, IDX_SELECTED);
                        if(check =="true") GridObj.DeleteRow(j);
                      }
                }
            }//setQtDelete
        }
        else if(msg1 == "t_imagetext") {
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
            } else if(msg3 == IDX_BUYER_COMPANY_NAME) { // 구매업체
                company_code = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_BUYER_COMPANY_CODE),msg2);
                window.open("/s_kr/master/customer/cus_bd_dis1.jsp?flag=P&company_code=" + company_code,"companyWin","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=840,height=490,left=0,top=0");
            }

        } // t_imagetext
    }

    function start_rfq_date(year,month,day,week) {
           document.form1.start_rfq_date.value=year+month+day;
    }

    function end_rfq_date(year,month,day,week) {
           document.form1.end_rfq_date.value=year+month+day;
    }

    function setModify() {

        var row = GridObj.GetRowCount();
        var chkcnt = 0;

        if(row > 0) {
            if(confirm("수정하시겠습니까?")) {
                for(var i = 0;i < row;i++){
                    var check = GD_GetCellValueIndex(GridObj,i, IDX_SELECTED);
                    if(check == true){
                        chkcnt++;

                        send_flag   = GD_GetCellValueIndex(GridObj,i,IDX_QTA_STATUS);
                        STATUS      = GD_GetCellValueIndex(GridObj,i,IDX_STATUS);
                        rfq_no      = GD_GetCellValueIndex(GridObj,i,IDX_RFQ_NO);
                        rfq_count   = GD_GetCellValueIndex(GridObj,i,IDX_RFQ_COUNT);
                        qta_no      = GD_GetCellValueIndex(GridObj,i,IDX_QTA_NO);
                        RFQ_FLAG    = GD_GetCellValueIndex(GridObj,i,IDX_RFQ_FLAG);
                        CLOSE_DATE  = GD_GetCellValueIndex(GridObj,i,IDX_RFQ_CLOSE_DATE);

                        //if( RFQ_FLAG == "C" )
                        //{
                           // alert( (i+1) + "번째 견적내역은 이미 종료되어 수정할 수 없습니다.");
                            //return;
                        //}
                        var CUR_DATE = "<%=to_date%>"+""+"<%=to_time%>".substring(0,2);

                        if( CLOSE_DATE <= CUR_DATE )
                        {
                            alert( (i + 1) + "번째 견적내역은 견적마감되어 수정할 수 없습니다.");
                            return;
                        }
                    }
                } // for문끝
                
                if(chkcnt == 0){
                    alert(G_MSS1_SELECT);
                    return;
                }
                if(chkcnt != 1){
                    alert(G_MSS2_SELECT);
                    return;
                }
                if(STATUS == "N" || qta_no == "") {
                    alert("수정할 수 없는 건입니다.");
                    return;
                }
 				
                var loc = "qta_bd_upd.jsp?st_rfq_no="+rfq_no+"&st_rfq_count="+rfq_count+"&st_qta_no="+qta_no+"&send_flag="+send_flag;
                location.href = loc;
            } else {
            	return;
            }
        }
    }

    function setDelete() {

        var row = GridObj.GetRowCount();
        var chkcnt = 0;

        if(row > 0) {
            if(confirm("삭제 하시겠습니까?") == 1) {
                for(var i = 0;i < row;i++) {
                    if( "true" == GD_GetCellValueIndex(GridObj,i, IDX_SELECTED)) {
                        chkcnt++;
                        STATUS = GD_GetCellValueIndex(GridObj,i,IDX_STATUS);
                        if(STATUS == "N"){
                            alert(++i + "번째 줄의 견적건은 수정할 수 없는 건입니다.");
                            return;
                        }
                    }
                }
            }
        }

        if(chkcnt == 0){
            alert(G_MSS1_SELECT);
            return;
        }

        mode = "setQtDelete";
<%--         servletUrl = "<%=getWiseServletPath("supply.bidding.qta.qta_bd_lis1")%>"; --%>
        servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.qta.qta_bd_lis1";
        GridObj.SetParam("mode",mode);

        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");

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
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
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
    
    document.form1.start_rfq_date.value = add_Slash( document.form1.start_rfq_date.value );
    document.form1.end_rfq_date.value   = add_Slash( document.form1.end_rfq_date.value );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<form name="form1" action="">
<input type="hidden" name="create_type" id="create_type" value="">
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
		 생성일자
	</td>
	<td class="data_td" width="35%">
		<s:calendar id="start_rfq_date" default_value="<%=SepoaString.getDateSlashFormat( from_date ) %>" format="%Y/%m/%d"/>
		~
		<s:calendar id="end_rfq_date" default_value="<%=SepoaString.getDateSlashFormat( to_date ) %>" format="%Y/%m/%d"/>
		
		
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 진행상태
	</td>
	<td width="35%" class="data_td">
		<select name="status" id="status" class="inputsubmit">
			<option value="">
				전체
			</option>
<%
     String com2 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M643", "");
     out.println(com2);
%>
		</select>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			 견적명
		</td>
		<td class="data_td" colspan="3">
			<input type="text" name="subject" id="subject" style="width:50%" maxlength="20" class="inputsubmit">
		</td>				
	</tr>
<tr style="display:none;">
	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 비교방식
	</td>
	<td class="data_td" colspan="3">
		<select name="settle_type" id="settle_type" class="inputsubmit">
			<option value="">
				전체
			</option>
<%
        String settle = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M149", "");
        out.println(settle);
%>
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
  	  		<td><script language="javascript">btn("javascript:setModify()","수 정")</script></td>
  	  	</TR>
  		</TABLE>
  	</td>
</tr>
</table>

</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SRQ_004" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
	</body>
</html>


