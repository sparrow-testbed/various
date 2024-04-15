<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("ST_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "ST_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% //PROCESS ID 선언%>
<% String WISEHUB_PROCESS_ID="ST_001";%>

<% //사용 언어 설정%>
<% String WISEHUB_LANG_TYPE="KR";%>

<%
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_ebd_bd_lis15"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
%>



<html>
<head>
    <title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@ include file="/include/include_css.jsp"%>
	<%@ include file="/include/sepoa_grid_common.jsp"%>
	<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>    
    <%
    String house_code       = info.getSession("HOUSE_CODE");
    String user_id		    = info.getSession("ID");
    String ctrl_code		= info.getSession("CTRL_CODE");
    //String gubun        	= request.getParameter("gubun") == null || request.getParameter("gubun").equals("") ? "D" : request.getParameter("gubun");
//     String bidType         = ListBox(request, "SL0018",  house_code+"#M410#", "");
    String bidType  = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M410#", "");
    
    %>
    
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
    var mode;
    
    var INDEX_SELECTED             ;
    var INDEX_NO                   ;
    var INDEX_ANN_ITEM             ;
    var INDEX_BASIC_AMT            ;
    var INDEX_ESTM_PRICE           ;
	var INDEX_RATE                 ;
	var INDEX_FINAL_ESTM_PRICE_ENC ;
	var INDEX_AVERAGEPRICE         ;
	var INDEX_BID_AMT              ;
	var INDEX_SETTLEAVERAGEPRICE   ;
	var INDEX_CONTRAST             ;
    
    function init() {
		setGridDraw();
		setHeader();
       // doSelect();
    }

    function setHeader() {

		GridObj.bHDMoving 			= false;
		GridObj.bHDSwapping 		= false;
		GridObj.bRowSelectorVisible = false;
		GridObj.strRowBorderStyle 	= "none";
		GridObj.nRowSpacing 		= 0 ;
		GridObj.strHDClickAction 	= "select";
		GridObj.nHDLineSize  		= 40; 

        
// 		GridObj.AddGroup("GUBUN", "내정가격");
		
// 		GridObj.AppendHeader("GUBUN", "ESTM_PRICE");
// 		GridObj.AppendHeader("GUBUN", "RATE");
// 		GridObj.AppendHeader("GUBUN", "FINAL_ESTM_PRICE_ENC");
// 		GridObj.AppendHeader("GUBUN", "AVERAGEPRICE");


// 		GridObj.SetNumberFormat("BASIC_AMT"            ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("ESTM_PRICE"           ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("RATE"                 ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("FINAL_ESTM_PRICE_ENC" ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("AVERAGEPRICE"         ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("BID_AMT"              ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("SETTLEAVERAGEPRICE"   ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("CONTRAST"             ,"#,###,###,###,###,###");

        INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
        INDEX_NO                    = GridObj.GetColHDIndex("NO");
        INDEX_ANN_ITEM              = GridObj.GetColHDIndex("ANN_ITEM");
        INDEX_BASIC_AMT             = GridObj.GetColHDIndex("BASIC_AMT");
        INDEX_ESTM_PRICE            = GridObj.GetColHDIndex("ESTM_PRICE");
		INDEX_RATE                  = GridObj.GetColHDIndex("RATE");
		INDEX_FINAL_ESTM_PRICE_ENC  = GridObj.GetColHDIndex("FINAL_ESTM_PRICE_ENC");
		INDEX_AVERAGEPRICE          = GridObj.GetColHDIndex("AVERAGEPRICE");
		INDEX_BID_AMT               = GridObj.GetColHDIndex("BID_AMT");
		INDEX_SETTLEAVERAGEPRICE    = GridObj.GetColHDIndex("SETTLEAVERAGEPRICE");
		INDEX_CONTRAST              = GridObj.GetColHDIndex("CONTRAST");

	}

    //조회버튼을 클릭
    function doSelect()
    {
    	form1.start_change_date.value   = del_Slash(form1.start_change_date.value);
    	form1.end_change_date.value     = del_Slash(form1.end_change_date.value);
		var from_date	   = LRTrim(form1.start_change_date.value);
		var to_date	       = LRTrim(form1.end_change_date.value);
		var bid_type       = $("#bid_type").val();

		if(from_date == "" || to_date == "" ) {
			alert("입찰마감일자를 입력하셔야 합니다.");
			return;
		}
		
		if(!checkDate(from_date)) {
			alert("입찰마감일자를 확인하세요.");
			form1.start_change_date.select();
			return;
		}
		
		if(!checkDate(to_date)) {
			alert("입찰마감일자를 확인하세요.");
			form1.end_change_date.select();
			return;
		}

		if(eval(del_Slash(document.forms[0].end_change_date.value)) < eval(del_Slash(document.forms[0].start_change_date.value)))
		{
			alert("입찰마감일자를 확인하세요.");
			return;
		}
		
        //service : p1014
        var mode   = "getRestricLowest";
        servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.bidd.ebd_bd_lis15";

        var cols_ids = "<%=grid_col_id%>";
		var params = "mode=" + mode;
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);

//         GridObj.SetParam("mode"      , mode);
//         GridObj.SetParam("from_date" , from_date);
//         GridObj.SetParam("to_date"   , to_date);

//         GridObj.bSendDataFuncDefaultValidate=false;
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(servletUrl);
    }

    function start_change_date(year,month,day,week) {
        document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
        document.forms[0].end_change_date.value=year+month+day;
    }

     //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13) {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            doSelect();
        }
    }

	function JavaCall(msg1, msg2, msg3, msg4, msg5){
	    if(msg1 == "doQuery"){

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
    	
    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,예비내정가격,사정율,확정,유효중(평균가),#rspan,#rspan,#rspan");
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
    
    document.form1.start_change_date.value = add_Slash( document.form1.start_change_date.value );
    document.form1.end_change_date.value   = add_Slash( document.form1.end_change_date.value   );
    
    return true;
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	sRptData += document.form1.start_change_date.value;	//입찰마감일 from
	sRptData += " ~ ";
	sRptData += document.form1.end_change_date.value;	//입찰마감일 to
	sRptData += rf;
	sRptData += document.form1.bid_type.options[document.form1.bid_type.selectedIndex].text;	//입찰구분
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("BID_TYPE_TXT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("ANN_ITEM",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("BASIC_AMT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ESTM_PRICE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("RATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("FINAL_ESTM_PRICE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("AVERAGEPRICE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("BID_AMT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("SETTLEAVERAGEPRICE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("CONTRAST",i);
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

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->

<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>
<form id="form1" name="form1">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>	
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
<input type="hidden" id="ctrl_code" name="ctrl_code" 	value="">

<%-- <%@ include file="/include/include_top.jsp"%> --%>

   	<tr>
   		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰마감일자</td>
   		<td width="20%" height="24" class="data_td">
   			<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), -2))%>" 	format="%Y/%m/%d"/>~
   			<s:calendar id="end_change_date"   default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" 									format="%Y/%m/%d"/>
   		</td>
   		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰구분</td>
   		<td width="20%" height="24" class="data_td">
			<select id="bid_type" name="bid_type" class="inputsubmit" style="width:120px" >
         		<option value="">전체</option>
         		<%=bidType%>
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

<table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td height="10">
            <div align="right">
                <table><tr>
                        <td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
                        <%-- <td><script language="javascript">btn("javascript:SaveFileCommon('ALL')","다운로드")</script></td> --%>
                        <td><script language="javascript">btn("javascript:clipPrint()","출 력")		</script></td>
                </tr></table>
            </div>
        </td>
    </tr>
</table>
</form>
<!---- END OF USER SOURCE CODE ---->
<!---- END OF USER SOURCE CODE ---->

</s:header>
<s:grid screen_id="ST_001" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


