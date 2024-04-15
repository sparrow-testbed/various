<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_005_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_005_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

 
<%
    String BID_NO       = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT    = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String VOTE_COUNT   = JSPUtil.nullToEmpty(request.getParameter("VOTE_COUNT"));

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
    
    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_NO             = "";
    String APP_END_DATE       = "";
    String APP_END_TIME       = "";
    String ANN_ITEM           = "";
    String CONT_TYPE1_TEXT_D  = "";
    String CONT_TYPE2_TEXT_D  = "";
    String LIMIT_CRIT         = "";
    String LIMIT_CRIT_TEXT    = "";
    String PROM_CRIT          = "";
    String PROM_CRIT_NAME	  = "";
    String APP_END_TIME_HOUR  = "";
    String APP_END_TIME_MINUTE= "";
    String PR_NO              = "";

    String BID_BEGIN_DATE     = "";
    String BID_BEGIN_TIME     = "";
    String X_DOC_SUBMIT_DATE  = "";
    String X_DOC_SUBMIT_TIME  = "";
  
   	Map map = new HashMap();
   	map.put("BID_NO"		, BID_NO);
   	map.put("BID_COUNT"		, BID_COUNT);

   	Object[] obj = {map};
   	SepoaOut value = ServiceConnector.doService(info, "I_BD_005", "CONNECTION","getBdHeaderDetail", obj);
   	
   	SepoaFormater wf = new SepoaFormater(value.result[0]); 

	CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
	CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
	ANN_NO                       = wf.getValue("ANN_NO"                ,0);
	ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
	LIMIT_CRIT                   = wf.getValue("LIMIT_CRIT"            ,0);
	LIMIT_CRIT_TEXT              = wf.getValue("LIMIT_CRIT_TEXT"       ,0);
	PROM_CRIT                    = wf.getValue("PROM_CRIT"             ,0);
	PROM_CRIT_NAME				 = wf.getValue("PROM_CRIT_NAME"        ,0);
	APP_END_DATE                 = wf.getValue("APP_END_DATE"          ,0);
	APP_END_TIME                 = wf.getValue("APP_END_TIME"          ,0);
	CONT_TYPE1_TEXT_D            = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
	CONT_TYPE2_TEXT_D            = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);
	APP_END_TIME_HOUR            = wf.getValue("APP_END_TIME_HOUR"     ,0);
	APP_END_TIME_MINUTE          = wf.getValue("APP_END_TIME_MINUTE"   ,0);
	PR_NO                        = wf.getValue("PR_NO"                 ,0);
	
	BID_BEGIN_DATE               = wf.getValue("BID_BEGIN_DATE"        ,0);
	BID_BEGIN_TIME               = wf.getValue("BID_BEGIN_TIME"        ,0);
	X_DOC_SUBMIT_DATE            = wf.getValue("X_DOC_SUBMIT_DATE"     ,0);
	X_DOC_SUBMIT_TIME            = wf.getValue("X_DOC_SUBMIT_TIME"     ,0);

       
 
    String VIEW_DATE  = "";//X_DOC_SUBMIT_DATE.substring(0, 4) + "년 " + X_DOC_SUBMIT_DATE.substring(4, 6) + "월 " + X_DOC_SUBMIT_DATE.substring(6, 8) + "일 " + X_DOC_SUBMIT_TIME.substring(0, 2) + "시 " + X_DOC_SUBMIT_TIME.substring(2, 4) + "분";
    String VIEW_DATE2 = "";//BID_BEGIN_DATE.substring(0, 4) + "년 " + BID_BEGIN_DATE.substring(4, 6) + "월 " + BID_BEGIN_DATE.substring(6, 8) + "일 " + BID_BEGIN_TIME.substring(0, 2) + "시 " + BID_BEGIN_TIME.substring(2, 4) + "분";
    
    //if(LIMIT_CRIT_TEXT == null || "".equals(LIMIT_CRIT_TEXT)) {
    //	LIMIT_CRIT_TEXT = LIMIT_CRIT;
    //}
    
    boolean isSave = true;
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 
<Script language="javascript">
<!--
    var G_flag;
	var mode;
	var button_flag = false;

    var date_flag;
	var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
 
    var thistime    = "<%=current_time%>".substring(0,2);
    var thisminute   = "<%=current_time%>".substring(2,4);
    
	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		if(msg1 == "doQuery") {
			GridObj.AddComboListValue('FINAL_FLAG','선택','');

        } else if(msg1 == "doData") { // 전송/저장시
            alert(GD_GetParam(GridObj,0));
            button_flag = false; // 버튼 action ...  action을 취할수있도록...
            opener.doSelect();

            if(G_flag == "RC"){
                url =  "ebd_pp_dis7.jsp?BID_NO=<%=BID_NO%>&BID_COUNT=<%=BID_COUNT%>";
                window.open( url , "ebd_pp_dis7","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=500,left=0,top=0");
            }
            window.close();
		} else if(msg1 == "t_imagetext") {

	    } else if(msg1 == "t_header") {

		} else if(msg1 == "t_insert") {
            if(msg3 == INDEX_UNT_FLAG || msg3 == INDEX_ACHV_FLAG) {//부정당업체,실적확인
                if(GridObj.GetCellHiddenValue("UNT_FLAG", msg2) == "Y" || GridObj.GetCellHiddenValue("ACHV_FLAG", msg2) == "N") {
                    GridObj.SetComboSelectedHiddenValue("FINAL_FLAG", msg2,"N");                    
            	}
			}

        }
	}

	function POPUP_Open(url, title, left, top, width, height) {
        var toolbar = 'no';
        var menubar = 'no';
        var status = 'no';
        var scrollbars = 'yes';
        var resizable = 'no';
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();
	}

//-->
</Script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_confirm_popup_ict2";

function init() {
	setGridDraw();
    doQuery();
}

function setGridDraw()
{
   	GridObj_setGridDraw();  
   	GridObj.setSizes();
}
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
     if(GridObj.getColIndexById("ATTACH_NO") == cellInd){
    	 var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO_H")).getValue();
    	 
    	 if(attach_no != ""){
    		 var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
        	 var b = "fileDown";
        	 var c = "300";
        	 var d = "100";
        	 
        	 window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
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

    if(status == "true") {
        alert(messsage);
        opener.doQuery();
        window.close();
    } else {
        alert(messsage);
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

function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdItemDetail";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);

	for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
		GridObj.enableSmartRendering(true);
    	GridObj.selectRowById(GridObj.getRowId(i), false, true);
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");	
    	
	}		

	return true;
}

function checkData() {
  
	var checked_count = 0;
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다


	for(var i = 0; i < grid_array.length; i++)
	{ 
		var FINAL_FLAG      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_FLAG")).getValue());
		var INCO_REASON      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("INCO_REASON")).getValue());
            // 최종결과 부적합 판정시 사유를 반드시 입력 
		 
             if (FINAL_FLAG == "U") {
                if(INCO_REASON == "") {
                    alert("보완요청 사유를 반드시 입력해야 합니다.");
                    return false;
                }
            }
            
            if (FINAL_FLAG == "N") {
                if(INCO_REASON == "") {
                    alert("최종결과가 부적합 판정시에는 사유를 반드시 입력해야 합니다.");
                    return false;
                }
            }

            checked_count++; 
    }
	return true;
}

// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("<%=text.get("MESSAGE.1004")%>");
	return false;
}
function doBidStatus(pflag) {
    G_flag = pflag;
    
    <%
    String current_date1 = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time1 = SepoaDate.getShortTimeString();//현재 시스템 시간
    
    if(Long.parseLong(BID_BEGIN_DATE + BID_BEGIN_TIME) < Long.parseLong(current_date1 + current_time1)){%>
		//alert("입찰시작일시까지만 입찰자적격확인 처리가 가능합니다.");
		//return;
		<%
    }%>

    if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }

    button_flag = true;
 
    if(pflag == "Y") { 
        if(confirm("확인 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    }

	document.forms[0].PFLAG.value         = pflag ;                  // 입찰마감, 유찰
	  
 
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	var rowcount = grid_array.length;
 
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=setBdStatus";
 
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    myDataProcessor = new dataProcessor( G_SERVLETURL, params ); 
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
}

function doAddVendor(){
    <%
    String current_date2 = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time2 = SepoaDate.getShortTimeString();//현재 시스템 시간
    
    if(Long.parseLong(BID_BEGIN_DATE + BID_BEGIN_TIME) < Long.parseLong(current_date2 + current_time2)){ 
	%>
	alert("입찰시작일시 까지만 입찰업체 추가신청 처리가 가능합니다.");
  	return false;
	<%
    }
    %>
	
	window.open("bd_join_seller_insert_pop.jsp?BID_NO=<%=BID_NO%>&BID_COUNT=<%=BID_COUNT%>&VOTE_COUNT=<%=VOTE_COUNT%>", "allVendor", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=700,left=0,top=0");
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작--> 

<form name="form" >
<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>">
<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT" value="<%=VOTE_COUNT%>">
<input type="hidden" name="CONT_TYPE2" id="CONT_TYPE2" value="<%=CONT_TYPE2%>">
<input type="hidden" name="PR_NO" id="PR_NO" value="<%=PR_NO%>">
<input type="hidden" name="PFLAG" id="PFLAG" > 

<%  
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = "입찰대상업체입력확인";
%>

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
    <colgroup>
        <col width="15%" />
        <col width="35%" />
        <col width="15%" />
        <col width="35%" />
    </colgroup>
    <tr>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공문번호</td>
      <td width="80%" class="data_td">&nbsp;
        <%=ANN_NO%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<!-- 
    <tr>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제출 마감일시</td>
      <td width="80%" class="data_td">&nbsp;
      <%=VIEW_DATE %>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;적격확인처리 유효일시</td>
      <td width="80%" class="data_td">&nbsp;
      <%=VIEW_DATE2 %>
      </td>
    </tr>
     -->
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰건명</td>
      <td width="80%" class="data_td">&nbsp;
        <%=ANN_ITEM%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
      <td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰방법</td>
      <td width="80%" class="data_td">&nbsp;
        <%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<!--
    <tr>
      <td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰참가자격</td>
      <td width="80%" class="data_td">
      	<textarea rows="3" class="inputsubmit" style="width:90%;" readOnly><%=LIMIT_CRIT_TEXT%></textarea>
      	<input type="hidden" id="LIMIT_CRIT" name="LIMIT_CRIT" value="<%=LIMIT_CRIT%>">
      </td>
    </tr>
    -->
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	

<br>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<!-- <TD><script language="javascript">btn("javascript:doAddVendor();", "입찰업체추가신청")</script></TD> -->
			<TD><script language="javascript">btn("javascript:doBidStatus('Y');", "확 인")</script></TD>
			<TD><script language="javascript">btn("javascript:window.close();", "닫 기")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table> 


</form>
<!---- END OF USER SOURCE CODE ----> 
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_BD_005_1" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


