<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SST_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SST_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간 
    String disp_current_date = current_date.substring(0, 4) + "년 " + current_date.substring(4, 6) + "월 " + current_date.substring(6, 8) + "일";
	
	
	String bidType  = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M410#", "");
//  String itemType1	= ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M750#", ""); //구매
	
//	String itemType2	= ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M551", ""); //공사
	//String com3 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M550", ITEM_TYPE); //공사
	
    //구매입찰
	String code1 = "";
	String desc1 = "";
	String itemType1 = "";
	SepoaListBox wlb1 = new SepoaListBox();
	String node_code1 = wlb1.Table_ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#" + "M750" + "#", "#", "@");
	StringTokenizer st1 = new StringTokenizer(node_code1,"@");
	int count1 = st1.countTokens();
	String[] line1 = new String[count1];
	
	for ( int k = 0 ; k < count1 ; k++ ){
		line1[k] = st1.nextToken().trim();
	}

	for( int l=0; l< line1.length ; l++){
		StringTokenizer std1 = new StringTokenizer(line1[l],"#");
		code1 =std1.nextToken();
		desc1 =std1.nextToken();
		itemType1 += "<input type='checkbox' id='itemtype1_"+l+"' name='itemtype1' value='"+code1+"' onChange='itemtype_onChange()'>"+desc1+"</input>&nbsp;&nbsp;&nbsp;&nbsp;";		
	}
	
	
	
	//공사입찰
	String code2 = "";
	String desc2 = "";
	String itemType2 = "";
	SepoaListBox wlb2 = new SepoaListBox();
	String node_code2 = wlb2.Table_ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#" + "M551" + "#", "#", "@");
	StringTokenizer st2 = new StringTokenizer(node_code2,"@");
	int count2 = st2.countTokens();
	String[] line2 = new String[count2];
	
	for ( int i = 0 ; i < count2 ; i++ ){
		line2[i] = st2.nextToken().trim();
	}

	for( int j=0; j< line2.length ; j++){
		StringTokenizer std2 = new StringTokenizer(line2[j],"#");
		code2 =std2.nextToken();
		desc2 =std2.nextToken();
		itemType2 += "<input type='checkbox' id='itemtype2_"+j+"' name='itemtype2' value='"+code2+"' onChange='itemtype_onChange()'>"+desc2+"</input>&nbsp;&nbsp;&nbsp;&nbsp;";		
	}
	
	
    
%>

<!--
Title:         평균낙찰율(구매입찰)  <p>
 Description:  평균낙찰율(구매입찰)<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       비밀<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="SST_001";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>

<%
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_ebd_bd_lis15_b"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->


<script language="javascript">
	function itemtype_onChange(){
		//alert($("input:checkbox[name='itemtype2']:checked").val());
		var checked_obj = "";
		
		//$("input:checkbox[name='itemtype2']:checked").each(function(index){
		$("input[type='checkbox']:checked").each(function(index){
			if(index != 0){
				checked_obj += ",";
			}
			checked_obj += $(this).val();
		});
		
		$("#item_type").val(checked_obj)
		
	}
  
    var mode;

    var server_time;
    var diff_time;

    var INDEX_SELECTED               ;
    //var INDEX_ITEM_TYPE              ;
    var INDEX_ITEM_NAME              ;
    var INDEX_FINAL_ESTM_PRICE_ENC   ;
    var INDEX_BID_AMT                ;
    var INDEX_AVG_RATE               ;
    
    function init() {
		setGridDraw();
		setHeader();
        nextAjax();
    }

    function setHeader() {
       
        GridObj.strHDClickAction="sortmulti";
				
// 				GridObj.SetNumberFormat("FINAL_ESTM_PRICE_ENC","###,###,###,###,###,###");
// 				GridObj.SetNumberFormat("BID_AMT","###,###,###,###,###,###");
// 				GridObj.SetNumberFormat("AVG_RATE","###,###,###,###,###,###.00");
				
		
        INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
        INDEX_ANN_NO                = GridObj.GetColHDIndex("ITEM_NAME");
        INDEX_ANN_ITEM              = GridObj.GetColHDIndex("FINAL_ESTM_PRICE_ENC");
        INDEX_CONT_TYPE_TEXT        = GridObj.GetColHDIndex("BID_AMT");
        INDEX_APP_BEGIN_DATE_TIME   = GridObj.GetColHDIndex("AVG_RATE");
    }
    
    

    //조회버튼을 클릭
    function doSelect() {
        //var today = new Date("YYYY-MM-DD");
      
        var from_date	= "";
        var to_date	    = "";
        var bid_type    = "D"
        var PROM_CRIT  = form1.PROM_CRIT.value;
		var gb_period   = "";
        
        
		var len = form1.period.length;  //라디오박스의 갯수
		if(len > 0){  //라디오박스가 있다면
			for(var i=0; i<len; i++)  //라디오박스 길이만큼 루프
				if(form1.period[i].checked == true){  //항목이 체크되있는지검사
					gb_period = form1.period[i].value; 	
				}
			}
				 
		if(gb_period == "1"){
			from_date = <%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1)%>;
	      	to_date   = <%=SepoaDate.getShortDateString()%>;
		}else{
	       	from_date = <%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-3)%>;
	      	to_date   = <%=SepoaDate.getShortDateString()%>;
		}
		$("#from_date").val(from_date);
		$("#to_date").val(to_date);
        
        //service : p1012
        var mode   = "getBidAvgRateList";
        servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.bidd.ebd_bd_lis15";

        var cols_ids = "<%=grid_col_id%>";
		var params = "mode=" + mode;
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);        
        
//         GridObj.SetParam("mode", mode);

//         GridObj.SetParam("from_date",	 from_date);
//         GridObj.SetParam("to_date",	   to_date);
//         GridObj.SetParam("bid_type",	  bid_type);
//         GridObj.SetParam("cont_type2",	cont_type2);
        
//         GridObj.bSendDataFuncDefaultValidate=false;
// 				GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 				GridObj.SendData(servletUrl);
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
       	    //server_time = GD_GetParam(GridObj,0);

       	    //clock("s");
	    } else if(msg1 == "doData") {

	    }
    }
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
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

function nextAjax(){
	var f = document.forms[0];
	
		//var sg_refitem  = f.sg_type1.value;
		var bid_type_id = eval(document.getElementById('bid_type')); //id값 얻기
		var item_type_id = eval(document.getElementById('item_type')); //id값 얻기
		
		//item_type_id.options.length = 0;    //길이 0으로
		//item_type_id.fireEvent("onchange"); //onchange 이벤트발생
		//alert($("#bid_type option:selected").val());
		$("#item_type").val("");
		
		$("input:checkbox").removeAttr('checked');
		
		if($("#bid_type option:selected").val() == ""){
			$("#div_item_type1").show();
			$("#div_item_type2").hide();
			$("#div_item_type3").hide();
			
		}else if($("#bid_type option:selected").val() == "C"){ //공사			
			$("#div_item_type1").hide();
			$("#div_item_type2").show();
			$("#div_item_type3").hide();
		    			
			$("#sp_title_item").text("공종");
			$("#PROM_CRIT").val("B");								
//			var obj = document.getElementById('item_type2');
//			obj[0].selected = true
		}else{
			$("#div_item_type1").hide();
			$("#div_item_type2").hide();
			$("#div_item_type3").show();
			
			$("#sp_title_item").text("품목구분");
			$("#PROM_CRIT").val("A");
//			var obj = document.getElementById('item_type3');
//			obj[0].selected = true
		}
		
		doSelect();        
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	
	if(grid_array.length < 1){
		alert("출력대상을 체크하세요.");
		return;
	}
	
	if($("#bid_type option:selected").val() == "C"){ //공사	
		$("#rptName").val("020644/rpt_ebd_bd_lis15_b");
		
		var grpitem = "";
		for(var i = 0; i < grid_array.length; i++){
			grpitem += GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_TYPE_TEXT")).getValue();
			if(i < grid_array.length-1 ){
				grpitem += ",";			
			}
		}
		
		sRptData += "최근 ";	
		sRptData += $("input:radio[name='period']:checked").val();	
		sRptData += "개월 입찰평균(";	
		sRptData += grpitem;
		sRptData += ") 낙찰률";	
		sRptData += rf;
		sRptData += "입찰평균 낙찰률 산정(";
		sRptData += "<%=disp_current_date%>";
		sRptData += " 기준)";
		sRptData += rf;	
		sRptData += grpitem;
		sRptData += " 평균 낙찰률";	
		sRptData += rd;
		
	}else{ //구매
		$("#rptName").val("020644/rpt_ebd_bd_lis15_a");
	
		sRptData += "최근 ";	
		sRptData += $("input:radio[name='period']:checked").val();	
		sRptData += "개월 구매입찰(";	
		sRptData += $("#PROM_CRIT option:selected").text();
		sRptData += ") 낙찰률";			
		sRptData += rf;
		sRptData += "구매입찰평균 낙찰률 산정(";
		sRptData += "<%=disp_current_date%>";
		sRptData += " 기준)";
		sRptData += rd;
	}
	
	for(var i = 0; i < grid_array.length; i++){
		sRptData += GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_TYPE_TEXT")).getValue();
		sRptData += rf;
		sRptData += GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_ESTM_PRICE_ENC")).getValue();
		sRptData += rf;		
		sRptData += GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_AMT")).getValue();
		sRptData += rf;		
		sRptData += GridObj.cells(grid_array[i], GridObj.getColIndexById("AVG_RATE")).getValue();
		sRptData += rl;		 		
	}

	document.form1.rptData.value = sRptData;
	
	if(typeof(rptAprvData) != "undefined"){
		document.form1.rptAprvUsed.value = "Y";
		document.form1.rptAprvCnt.value = approvalCnt;
		document.form1.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit();
	cwin.focus();
}

var selectAllFlag = 0;
function selectAll(){
	if(selectAllFlag == 0)
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1");
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		}
		selectAllFlag = 1;
	}
	else
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
		}
		selectAllFlag = 0;
	}
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >
<s:header>
<!--내용시작-->

<%-- <%@ include file="/include/include_top.jsp"%> --%>
<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>
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
<form id="form1" name="form1" >
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>	
<input type="hidden" name="ctrl_code" value="">
<input type="hidden" id="item_type" name="item_type" value="">
<input type="hidden" id="from_date" name="from_date" 	value="">
<input type="hidden" id="to_date" 	name="to_date" 		value="">

<!--   <table width="98%" border="0" cellspacing="0" cellpadding="0" class="title_table_top"> -->
<!--     <tr > -->
<%--       <td class="title_table_top" ><%@ include file="/include/sepoa_milestone.jsp" %></td> --%>
<!--     </tr> -->
<!--   </table> -->
<!--   <table width="98%" border="0" cellspacing="0" cellpadding="0"> -->
<!--     <tr> -->
<!--       <td></td> -->
<!--     </tr> -->
<!--   </table> -->
  
    
      <!--
      <td width="15%" class="cell_title">진행상황</td>
      <td width="35%" class="cell_data">
        <select name="bid_flag" class="inputsubmit">
          <option value="">전체</option>
<%
		//String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M974", "");
		//out.println(com1);
%>
        </select>
      </td>
-->

   	<tr>
   		<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰구분</td>
   		<td width="35%" height="24" class="data_td" colspan=3>
			<select id="bid_type" name="bid_type" class="inputsubmit" style="width:120px" onChange="nextAjax()">
         		<!-- option value="">전체</option -->
         		<%=bidType%>
         	</select>
   		</td>
   		<%--
   		<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목구분</td>
   		<td width="35%" height="24" class="data_td">   		     
   			<div id=div_item_type1 style="display:"> 
   		    <select id="item_type1" name="item_type1" class="inputsubmit" style="width:120px" >
         		<option value="">전체</option>
         	</select></div>
         	<div id=div_item_type2 style="display:none">
			<select id="item_type2" name="item_type2" class="inputsubmit" style="width:120px" onChange='$("#item_type").val(this.value)'>
         		<option value="">전체</option>
         		<%=itemType2%>
         	</select></div>
         	<div id=div_item_type3 style="display:none">
         	<select id="item_type3" name="item_type3" class="inputsubmit" style="width:120px" onChange='$("#item_type").val(this.value)'>
         		<option value="">전체</option>
         		<%=itemType1%>
         	</select></div>         	
   		</td>
   		--%>
   	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>

	<tr>
   		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<span id="sp_title_item" name="sp_title_item">품목구분</span></td>
   		<td height="24" class="data_td" colspan=3>
   			<div id=div_item_type1 style="display:"> 
   		    </div>
         	<div id=div_item_type2 style="display:none">
			<%=itemType2%>
			</div>
         	<div id=div_item_type3 style="display:none">
         	<%=itemType1%>
         	</div>
   		</td>
   	</tr>
   	
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
		<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;낙찰방법
		</td>
		<td width="35%" height="24" class="data_td">
			<select id="PROM_CRIT" name="PROM_CRIT" class="inputsubmit" style="width:120px" >
					<%
					    //A : 최저가 (LP)
					    //B : 제한적최저가 (RL)	
					    String PROM_CRIT   = "B"; 
						String com2 		= ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M930", PROM_CRIT);
						out.println(com2);
					%>
			</select>
		</td>
		<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기간
		</td>
		<td width="35%" height="24" class="data_td">
			<input type="radio" id="period1" name="period" value="1">최근 1개월</input>  
			<input type="radio" id="period2" name="period" value="3" checked>최근 3개월</input>
		</td>
	</tr>
</table>
   		</td>
   	</tr>
 	</table>
 	</td>
   	</tr>
 	</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30">
        	<div align="left">
				<table cellpadding="0">
					<tr>
					    <td><script language="javascript">btn("javascript:selectAll()","전체선택")	</script></td>					    						
					</tr>
				</table>
			</div>
		</td>
    	<td height="30">
        	<div align="right">
				<table cellpadding="0">
					<tr>
					    <td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
						<td><script language="javascript">btn("javascript:clipPrint()","출 력")</script></td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
<!--   <table width="98%" border="0" cellpadding="2" cellspacing="1" class="jtable_bgcolor"> -->
<%--     <%=WiseTable_Scripts("100%","300")%> --%>
<!--   </table> -->
<!-- <table width="98%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- 	<tr> -->
<!-- 		<td width="20%"> -->
<!-- 			<div align="left"> -->
<!-- 				<a href="javascript:SaveFileCommon('ALL');"><img src="../../images/button/butt_download.gif" align="absmiddle" border=0></a> -->
<!-- 			</div> -->
<!-- 		</td> -->
<!-- 		<td width="80%" height="30"> -->
<!-- 			<div align="right"></div> -->
<!-- 		</td> -->
<!-- 	</tr> -->
<!-- </table> -->
</form>

</s:header>
<s:grid screen_id="SST_001" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


