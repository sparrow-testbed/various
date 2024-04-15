<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_015";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bidd/ebd_bd_dis4.jsp -->
<!--
Title:        FrameWork 적용 Sample화면(PROCESS_ID)  <p>
 Description:  개발자들에게 적용될 기본 Sample(조회) 작업 입니다.(현재 모듈명에 대한 간략한 내용 기술) <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<!-- 
  * 수정내역
  #1 : 기술점수는 제안평가점수로 한다. 
 -->
 
<%

    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String VOTE_COUNT    = JSPUtil.nullToEmpty(request.getParameter("VOTE_COUNT"));
    String EVAL_REFITEM    = JSPUtil.nullToEmpty(request.getParameter("EVAL_REFITEM"));	//평가일련번호 
    String EVAL_CODE    = JSPUtil.nullToEmpty(request.getParameter("EVAL_CODE"));	//평가구분코드

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_NO             = "";
    String ANN_ITEM           = "";
    String BID_BEGIN_DATE     = "";
    String BID_END_DATE       = "";

    String BID_BEGIN_TIME_HOUR = "";
    String BID_BEGIN_TIME_MINUTE = "";
    String BID_END_TIME_HOUR = "";
    String BID_END_TIME_MINUTE = "";

    String CONT_TYPE1_TEXT_D = "";
    String CONT_TYPE2_TEXT_D = "";
    String PROM_CRIT_NAME = "";
    String PROM_CRIT = "";

    String ESTM_FLAG         = "";
    String COST_STATUS       = "";
    String BID_EVAL_SCORE	 = ""; // 평가배점
    String TECH_DQ			 = ""; // 기술점수 비율
    boolean sign_result      = false;  //서명검증
    

	Map< String, String >   map = new HashMap< String, String >();
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_006", "CONNECTION","getBdHeaderDetail", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]); 

    if(wf != null) {
        if(wf.getRowCount() > 0) { //데이타가 있는 경우
        CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
        CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
        ANN_NO                       = wf.getValue("ANN_NO"                ,0);
        ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
        BID_BEGIN_DATE               = wf.getValue("BID_BEGIN_DATE"        ,0);
        BID_END_DATE                 = wf.getValue("BID_END_DATE"          ,0);
        BID_BEGIN_TIME_HOUR          = wf.getValue("BID_BEGIN_TIME_HOUR"   ,0);
        BID_BEGIN_TIME_MINUTE        = wf.getValue("BID_BEGIN_TIME_MINUTE" ,0);
        BID_END_TIME_HOUR            = wf.getValue("BID_END_TIME_HOUR"     ,0);
        BID_END_TIME_MINUTE          = wf.getValue("BID_END_TIME_MINUTE"   ,0);
        CONT_TYPE1_TEXT_D            = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
        CONT_TYPE2_TEXT_D            = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);
        PROM_CRIT_NAME            	 = wf.getValue("PROM_CRIT_NAME"        ,0);
        CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);

        ESTM_FLAG                    = wf.getValue("ESTM_FLAG"             ,0);
        COST_STATUS                  = wf.getValue("COST_STATUS"           ,0);
        BID_EVAL_SCORE				 = wf.getValue("BID_EVAL_SCORE"    	   ,0);
        TECH_DQ						 = wf.getValue("TECH_DQ"           	   ,0);
        PROM_CRIT             		 = wf.getValue("PROM_CRIT"             ,0);

        //서명검증
        //---------------------------------------
        String CERTV                 = wf.getValue("CERTV"                 ,0);
        String TIMESTAMP             = wf.getValue("TIMESTAMP"             ,0);
        String SIGN_CERT             = wf.getValue("SIGN_CERT"             ,0);

        String BID_TYPE              = wf.getValue("BID_TYPE"              ,0);
        String ANN_DATE              = wf.getValue("ANN_DATE"              ,0);
        String APP_BEGIN_DATE        = wf.getValue("APP_BEGIN_DATE"        ,0);
        String APP_BEGIN_TIME        = wf.getValue("APP_BEGIN_TIME"        ,0);
        String APP_END_DATE          = wf.getValue("APP_END_DATE"          ,0);
        String APP_END_TIME          = wf.getValue("APP_END_TIME"          ,0);
        String BID_BEGIN_TIME        = wf.getValue("BID_BEGIN_TIME"        ,0);
        String BID_END_TIME          = wf.getValue("BID_END_TIME"          ,0);
        String OPEN_DATE             = wf.getValue("OPEN_DATE"             ,0);
        String OPEN_TIME             = wf.getValue("OPEN_TIME"             ,0);
        String BID_PLACE             = wf.getValue("BID_PLACE"             ,0);
        String LIMIT_CRIT            = wf.getValue("LIMIT_CRIT"            ,0);
        
        String BID_ETC               = wf.getValue("BID_ETC"               ,0);
        String CTRL_AMT              = wf.getValue("CTRL_AMT"              ,0);
        }
    }  

    String VIEW_FROM_DATE = "";;
    String VIEW_TO_DATE = "";

    if(!BID_BEGIN_DATE.equals("")) {
        VIEW_FROM_DATE = BID_BEGIN_DATE.substring(0, 4) + "년 " + BID_BEGIN_DATE.substring(4, 6) + "월 " + BID_BEGIN_DATE.substring(6, 8) + "일 " + BID_BEGIN_TIME_HOUR + "시 " + BID_BEGIN_TIME_MINUTE + "분";
        VIEW_TO_DATE = BID_END_DATE.substring(0, 4) + "년 " + BID_END_DATE.substring(4, 6) + "월 " + BID_END_DATE.substring(6, 8) + "일 " + BID_END_TIME_HOUR + "시 " + BID_END_TIME_MINUTE + "분";
    }
    
    String eval_id_prop = "";	//제안평가
    /*
	try {
		Config conf = new Configuration();
	    eval_id_prop = conf.get("wise.eval.prop");
	}catch(ConfigurationException e) {
		Logger.err.println(info.getSession("ID"),request, " ConfigurationException: " + e.getMessage());
	}		
	Logger.debug.println(info.getSession("ID"),request, "eval_id_prop::" + eval_id_prop);
	Logger.debug.println(info.getSession("ID"),request, "EVAL_CODE::" + EVAL_CODE);
	*/
	// 2012.05.17 최홍모
	// 입찰 공고시 기술평가 비율이 있는 경우
	// 1단계 평가의 기술점수를 비율로 곱한 금액을 가져옴
	// ICOYBDSP : TECHNICAL_SCORE = TEST_POINT * (TECH_DQ/100);
	String TECH_DQ_SIZE = String.valueOf(Double.parseDouble("".equals(TECH_DQ) ? "0" : TECH_DQ) > 0 ? "100" : "0");
    
	/* 제안평가가 있는 경우(규격, 적격심사)
	String TECH_DQ_SIZE = "0";
    if(!"".equals(EVAL_REFITEM) && eval_id_prop.equals(EVAL_CODE)) {
    	TECH_DQ_SIZE = "100";
    }*/
%> 

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  --> 
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 <%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<Script language="javascript">
<!--
var BID_NO      = "<%=BID_NO%>";
var BID_COUNT   = "<%=BID_COUNT%>";
var VOTE_COUNT  = "<%=VOTE_COUNT%>";
var EVAL_REFITEM  = "<%=EVAL_REFITEM%>";

var mode;
var button_flag = false;

var date_flag;
var Current_Row;

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";
  
function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery") {}
	else if(msg1 == "doData") { // 전송/저장시
		if("<%=CONT_TYPE2%>"=="NE"){
			location.href = "ebd_pp_ins13.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;
		}
		else{
			//location.href = "ebd_pp_ins3.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;
			location.href = "ebd_pp_ins13.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;
		}
       		//}
	}
	else if(msg1 == "t_imagetext") {
		if(msg3 == INDEX_ATTACH_VIEW){
			var ATTACH_VIEW_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_VIEW));

			if("" != ATTACH_VIEW_VALUE) {
				rMateFileAttach('P','R','BD',ATTACH_VIEW_VALUE);
			}
		}
	}
	if(mode == "getBDAPDisplay2") {
		/* #1 : 기술점수는 제안평가점수로 한다.*/
		//setTECH_DQ(); // 기술점수 세팅   //#1 : 
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

function checkData() {
	rowcount = GridObj.GetRowCount();

	checked_count = 0;
	
	for(row = rowcount - 1; row >= 0; row--) {
		checked_count++;
	}

	if(checked_count == 0) {
		alert("선택된 건이 없습니다.");
		
		return;
	}

	return true;
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
	else if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}
	
/**
 * 1단계 평가결과의 기술점수 세팅
 */
function setTECH_DQ(){
	var BID_EVAL_SCORE 	= parseFloat("<%="".equals(BID_EVAL_SCORE) ? "1" :  BID_EVAL_SCORE%>");	// 공고작성시 평가배점
	var TECH_DQ			= parseFloat("<%="".equals(TECH_DQ) ? "1" :  TECH_DQ%>");				// 공고작성시 기술점수 비율

	for(var i=0; i<GridObj.GetRowCount(); i++){
		GridObj.SetCellValue("TECH_DQ", i, <%=TECH_DQ%>);
		
		if(GridObj.GetCellValue("TECHNICAL_SCORE", i) == ""){
			var TEST_POINT 		= parseFloat(GridObj.GetCellValue("TEST_POINT", i) == "" ? "0" : GridObj.GetCellValue("TEST_POINT", i));
			var TECHNICAL_SCORE	= RoundEx(calulateTechnicalScore(TECH_DQ * BID_EVAL_SCORE, TEST_POINT), 5);
			
			GridObj.SetCellValue("TECHNICAL_SCORE", i, TECHNICAL_SCORE);
		}
	}		
}
	
// 입찰시스템의 기술점수 산정 방식
function calulateTechnicalScore(TECH_DQ, TEST_POINT){
	/**
		입찰시스템 입찰기술 평점산식
		기술점수 = 1단계 평가점수 * 기술점수 비율
	*/  
	TECH_DQ		= TECH_DQ 		== "" ? "0" : parseFloat(TECH_DQ); // 기술점수비율
	TEST_POINT	= TEST_POINT 	== "" ? "0" : parseFloat(TEST_POINT); // 기술점수
	
	var TECHNICAL_SCORE = TEST_POINT * (TECH_DQ / 100);
	
	return TECHNICAL_SCORE;
}
	
/**
 * 제안 평가결과
 */
function doDisplay_Eval(){
	var url = "/kr/master/evaluation/eva_bd_lis7.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT+"&EVAL_REFITEM="+EVAL_REFITEM;
	window.open( url , "ebd_bd_lis7","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=500,left=0,top=0");
}
	
   /**
    * 제안 평가결과를 기술점수에 넣어주는 함수
    */
function setEvalScore(evData, choice_eval_num, eval_refitem){
	document.form1.choice_eval_num.value=choice_eval_num;	//제안평가 계산식 중 선택한 번호
	document.form1.eval_refitem.value=eval_refitem;			//평가 번호
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		for(var j=0;j<evData.length;j++){
			if(GD_GetCellValueIndex(GridObj,i, INDEX_VENDOR_CODE) == evData[j][0]){
				GridObj.SetCellValue("TECHNICAL_SCORE", i, evData[j][1]);
			}
		}
	}
}
//-->
</Script>
<Script language="javascript" type="text/javascript">

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_open";


function init() {
	setGridDraw(); 
	
	<%
	if(!"C".equals(PROM_CRIT)){%>
	GridObj.setColumnHidden(GridObj.getColIndexById("TECHNICAL_SCORE"), true);
	<%
	}
	%>
	
    doQuery();
}

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
  
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
        //alert(messsage);
        //location.href = "ebd_pp_ins13.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;

    	document.form1.BID_NO.value = BID_NO;
    	document.form1.BID_COUNT.value = BID_COUNT; 
    	document.form1.VOTE_COUNT.value = VOTE_COUNT; 
    	 
        url =  "bd_open_compare.jsp";
        document.form1.target = "_self";
        document.form1.method = "POST";
    	document.form1.action = url; 
    	document.form1.submit();  
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
    var params = "mode=getBdOpen";
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
//     	GridObj.selectRowById(GridObj.getRowId(i), false, true);
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");	
    	
	}		
	
	
    return true;
}
// ★GRID CHECK BOX가 체크되었는지 체크해주는 공통 함수[필수]
function checkRows() {

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    if( grid_array.length > 0 ) {
        return true;
    }

    alert("<%=text.get("MESSAGE.MSG_1001")%>");<%-- 대상건을 선택하십시오.--%>
    return false;

}

function doBidProcess() {
    if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }

   // if(!checkRows()) return;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
    
	if("<%=TECH_DQ_SIZE%>" != "0"){
        for( var i = 0; i < grid_array.length; i++ ) { 
			if(GridObj.cells(grid_array[i], GridObj.getColIndexById("TECHNICAL_SCORE")).getValue() == ""){
				alert(GridObj.cells(grid_array[i], GridObj.getColIndexById("VENDOR_NAME")).getValue() + " 업체의 기술점수를 입력해 주세요.");
				return;
			}
		}
	}
    
    

	if(grid_array.length > 0){
		var params = "mode=setBdProcess";
	    params += "&cols_ids=" + cols_ids;
	    params += dataOutput();
	    myDataProcessor = new dataProcessor( G_SERVLETURL, params );
	    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
	}else{
    	document.form1.BID_NO.value = BID_NO;
    	document.form1.BID_COUNT.value = BID_COUNT; 
    	document.form1.VOTE_COUNT.value = VOTE_COUNT; 
    	 
        url =  "bd_open_compare.jsp";
        document.form1.target = "_self";
        document.form1.method = "POST";
    	document.form1.action = url; 
    	document.form1.submit();  		
	}


//             var nickName    = "BD_014";
//             var conType     = "TRANSACTION";
//             var methodName  = "setBdProcess";
//             var SepoaOut    = doServiceAjax( nickName, conType, methodName );

//             if( SepoaOut.status == "1" ) { // 성공

//             	document.form1.BID_NO.value = BID_NO;
//             	document.form1.BID_COUNT.value = BID_COUNT; 
//             	document.form1.VOTE_COUNT.value = VOTE_COUNT; 
            	 
//                 url =  "bd_open_compare.jsp";
//                 document.form1.target = "_self";
//                 document.form1.method = "POST";
//             	document.form1.action = url; 
//             	document.form1.submit();  
//             } else { // 실패
//                 alert( SepoaOut.message );
//             }
   // } else {
   //     alert("예정가격이 확정되지 않은 건입니다");
   //     return;
   // }
}

/**
 * 1단계 평가결과 팝업창
 */
function doDisplay() {
   // var url = "bd_estimate_popup.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT+"&screen_flag=Y";
	var url = "bd_estimate_popup.jsp?screen_flag=Y";
	document.forms[0].BID_NO.value 		= BID_NO;
	document.forms[0].BID_COUNT.value		= BID_COUNT;
	document.forms[0].VOTE_COUNT.value		= VOTE_COUNT;  

    window.open( url , "bd_estimate_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=500,left=0,top=0");
	document.forms[0].method = "POST";
	document.forms[0].action = url;
	document.forms[0].target = "bd_estimate_popup";
	document.forms[0].submit(); 
}

</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 
<form name="form1" >
	<input type="hidden" name="attach_gubun" value="body"> 
	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_count" value="">
	<input type="hidden" name="choice_eval_num" value="">
	<input type="hidden" name="eval_refitem" value="">
	<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
	<input type="hidden" name="BID_COUNT" id=BID_COUNT value="<%=BID_COUNT%>">
	<input type="hidden" name="VOTE_COUNT" id=VOTE_COUNT value="<%=VOTE_COUNT%>">
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
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      <td width="85%" class="data_td">&nbsp;
        <%=ANN_NO%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰건명</td>
      <td width="85%" class="data_td">&nbsp;
        <%=ANN_ITEM%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰차수</td>
      <td width="85%" class="data_td">&nbsp;
        <%=VOTE_COUNT%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰방법</td>
      <td width="85%" class="data_td">&nbsp;
        <%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME %>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰일시</td>
      <td width="85%" class="data_td">&nbsp;
      <%=VIEW_FROM_DATE%>&nbsp;~&nbsp;<%=VIEW_TO_DATE%>
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
	<td height="30">
		<div align="right">
		<table cellpadding="0">
		<tr>
	<%
		// 제안평가(규격평가, 적격심사)
        if(!"".equals(EVAL_REFITEM) && eval_id_prop.equals(EVAL_CODE)) {
	%>
<%--           	<td><script language="javascript">btn("javascript:doDisplay_Eval()","제안평가결과")</script></td> --%>
	<%
       	}
		// LP : 총액별, TE : 2단계 경쟁, NE : 협상에의한 계약(수의계약)
       	if(!CONT_TYPE2.equals("LP")) {
	%>
          	<td><script language="javascript">btn("javascript:doDisplay()","1단계평가결과")</script></td>
	<%
       	}
	%>
	
	<%
		if(!"C".equals(PROM_CRIT)){
	%>
			<td><script language="javascript">btn("javascript:doBidProcess()","재입찰대상")</script></td>
	<%
		}else{
	%>
			<td><script language="javascript">btn("javascript:doBidProcess()","개찰")</script></td>
	<%		
		}
	%>
	
			<td><script language="javascript">btn("javascript:history.back(-1)","취 소")</script></td>
		</tr>
		</table>
		</div>
	</td>
	<td height="30">
	</td>
</tr>
</table>
    
</form>
<!---- END OF USER SOURCE CODE ----> 

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="BD_015" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


