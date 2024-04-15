<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_009");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_009";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bid/ebd_bd_ins1.jsp -->
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
   #1. 평가점수 입력 항목을 제거한다.  
 --> 
<%

    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String VOTE_COUNT    = JSPUtil.nullToEmpty(request.getParameter("VOTE_COUNT"));
    String screen_flag    = JSPUtil.nullToEmpty(request.getParameter("screen_flag"));
 
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
  
    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_NO             = "";
    String ANN_ITEM           = "";
    String CHANGE_USER_NAME_LOC= "";
    String CONT_TYPE1_TEXT_D  = "";
    String CONT_TYPE2_TEXT_D  = "";

    String STANDARD_POINT  	= "";
    String TECH_DQ  		= "";
    String AMT_DQ  			= "";

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
        CHANGE_USER_NAME_LOC         = wf.getValue("CHANGE_USER_NAME_LOC"            ,0);
        CONT_TYPE1_TEXT_D            = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
        CONT_TYPE2_TEXT_D            = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);

        STANDARD_POINT  	         = wf.getValue("STANDARD_POINT"     	,0);
        TECH_DQ  		             = wf.getValue("TECH_DQ"     			,0);
        AMT_DQ  			         = wf.getValue("AMT_DQ"     			,0);
        }
    }
    
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  --> 
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<Script language="javascript">
<!--

    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";
    var VOTE_COUNT  = "<%=VOTE_COUNT%>";

	var mode;
	var button_flag = false;

    var date_flag;
	var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
 
    var thistime    = "<%=current_time%>".substring(0,2);
    var thisminute    = "<%=current_time%>".substring(2,4);
 
	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		if(msg1 == "doQuery") {

        } else if(msg1 == "doData") { // 전송/저장시
            alert(GD_GetParam(GridObj,0));
            button_flag = false; // 버튼 action ...  action을 취할수있도록...
            opener.doSelect();
            window.close();
		} else if(msg1 == "t_imagetext") {
	        if(msg3 == INDEX_AP_ATTACH_CNT) {
                var ATTACH_VIEW_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_AP_ATTACH_CNT));
                if("" != ATTACH_VIEW_VALUE) {
 					document.form1.attach_gubun.value = "wise";
					
					rMateFileAttach('P','R','BD',ATTACH_VIEW_VALUE);
                }
            }
            
            if(msg3 == INDEX_VO_ATTACH_CNT) {
                var ATTACH_VIEW_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_VO_ATTACH_CNT));

                if("" != ATTACH_VIEW_VALUE) {
 					document.form1.attach_gubun.value = "wise";
					
					rMateFileAttach('P','R','BD',ATTACH_VIEW_VALUE);
                }
            }
            if(msg3 == INDEX_VENDOR_NAME) {
                var VENDOR_NAME_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_VENDOR_NAME));

                if("Y" != LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_SEL_YN))) {
                	Current_Row = msg2;
                	url =  "ebd_pp_ins21.jsp";
    	        	window.open( url , "ebd_pp_ins21","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=860,height=400,left=0,top=0");
                }
            }
            
            if(msg3 == INDEX_BID_PARTICIPATION_FORM) {
            	printBidParticipationForm(msg2);
            }

	    } else if(msg1 == "t_header") {

		}  else if(msg1 == "t_insert") {
			if(msg3 == INDEX_TECH_POINT || msg3 == INDEX_AMT_POINT)
			{
				var tech_point = parseFloat(LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_TECH_POINT)));
				var amt_point  = parseFloat(LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_AMT_POINT)));
				
				if(tech_point > 100 || tech_point < 0){
					alert("점수는 0 ~ 100 까지 입니다.");
					GD_SetCellValueIndex(GridObj,msg2, INDEX_TECH_POINT,"");
					return;
				}
				if(amt_point > 100 || amt_point < 0){
					alert("점수는 0 ~ 100 까지 입니다.");
					GD_SetCellValueIndex(GridObj,msg2, INDEX_AMT_POINT,"");
					return;
				}
				
				var tech_dq = parseFloat("<%=TECH_DQ%>"); // 기술점수 비율(입찰 공고시)
				var amt_dq 	= parseFloat("<%=AMT_DQ%>");  // 가격점수 비율(입찰 공고시)
				if("<%=CONT_TYPE2%>" == "QE"){
					tech_dq = 100;
					amt_dq = 0;
				}
				
				var test_point 		= ((tech_point * tech_dq) / 100)+((amt_point * amt_dq)/100);
				//alert(test_point);
				var standard_point 	= parseFloat(LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_STANDARD_POINT)));
				
				// 기술점수 및 가격점수를 입력한 경우 평가점수를 세팅한다.
				if(GD_GetCellValueIndex(GridObj,msg2,INDEX_TECH_POINT)!=""&&GD_GetCellValueIndex(GridObj,msg2,INDEX_AMT_POINT)!="") {
					GD_SetCellValueIndex(GridObj,msg2,INDEX_TEST_POINT,test_point);
				}
				// 평가점수 > 기준점수 : 합격
				// 평가점수 < 기준점수 : 불합격
				if(test_point < standard_point){
					GD_SetCellValueIndex(GridObj,msg2,INDEX_SPEC_FLAG," ","#","@",1);
				}else{
					GD_SetCellValueIndex(GridObj,msg2,INDEX_SPEC_FLAG," ","#","@",0);
				}
			}
        }
	}

	function setVendorCode(VENDOR_CODE, VENDOR_NAME, CEO_NAME, TEL, USER_NAME, USER_POSITION, USER_MOBILE, USER_EMAIL) {
		var	checked_count =	0;
		var	rowcount = GridObj.GetRowCount();
		var	ck_vendor_code = "";

		for(row=0; row<GridObj.GetRowCount();	row++) {
			ck_vendor_code = GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_CODE);
			if(ck_vendor_code == VENDOR_CODE) {
				alert("등록한 업체입니다.");
				return;
			}
		}
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_VENDOR_CODE,      VENDOR_CODE);
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_VENDOR_NAME,      "&" + VENDOR_NAME + "&" + VENDOR_NAME,"&");
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_CEO_NAME_LOC,     CEO_NAME);
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_TEL,      		TEL);
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_USER_NAME,      	USER_NAME);
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_USER_POSITION,   	USER_POSITION);
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_USER_MOBILE,     	USER_MOBILE);
		GD_SetCellValueIndex(GridObj,Current_Row, INDEX_USER_EMAIL,      	USER_EMAIL);
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

    function getUnproper() {
        window.open( "/kr/master/vendor/unt_pp_lis1.jsp" , "unt_pp_lis1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=700,height=370,left=0,top=0");
    }

	function  LineInsert()
    {
        GridObj.AddRow();
        rownum = GridObj.GetRowCount();
        GD_SetCellValueIndex(GridObj,rownum - 1, INDEX_SELECTED, "true&", "&");
		GD_SetCellValueIndex(GridObj,rownum - 1, INDEX_SPEC_FLAG, " ", "#", "@", 0);
		GD_SetCellValueIndex(GridObj,rownum - 1, INDEX_ATTACH_VIEW, " &0&", "&");
		GD_SetCellValueIndex(GridObj,rownum - 1, INDEX_VENDOR_NAME, " &", "&");
		GD_SetCellValueIndex(GridObj,rownum - 1, INDEX_STANDARD_POINT, "<%=STANDARD_POINT%>");
		GD_SetCellActivation(GridObj,rownum - 1, INDEX_CEO_NAME_LOC	, "true");
		GD_SetCellActivation(GridObj,rownum - 1, INDEX_TEL			, "true");
		GD_SetCellActivation(GridObj,rownum - 1, INDEX_USER_NAME		, "true");
		GD_SetCellActivation(GridObj,rownum - 1, INDEX_USER_POSITION	, "true");
		GD_SetCellActivation(GridObj,rownum - 1, INDEX_USER_MOBILE	, "true");
		GD_SetCellActivation(GridObj,rownum - 1, INDEX_USER_EMAIL		, "true");

    }

    function  LineDelete()
    {
        rowcount = GridObj.GetRowCount();
        if(rowcount == 0) {
            alert("삭제할 대상이 없습니다.");
            return;
        }
        if(rowcount > 0) {
            if(confirm("삭제 하시겠습니까?") == 1) {
                for(row=rowcount-1; row>=0; row--) {
                    if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED) && GD_GetCellValueIndex(GridObj,row, INDEX_SEL_YN) != "Y") {
                        GridObj.DeleteRow(row);
                    }
                }
            }
        }
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
		} else if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}
	
	// 참가신청서 출력(iReport)
	function printBidParticipationForm(idx)
	{
		/*
		var checkedIndex = "";
		var checkedCnt   = 0;
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkedIndex = i;
				checkedCnt ++;
			}
		}
		
		if(checkedCnt != 1){
			alert("한 업체를 선택해주십시요.");
			return;
		}
		*/	
		var so_no 		= "<%=BID_NO%>";
		var so_count 	= "<%=BID_COUNT%>";
		var vendor_code = GridObj.GetCellValue("VENDOR_CODE", idx);
		var type 		= "BID";	
	
		//type  입찰 : BID   견적 RFQ  역경매 RAT
		childFrame.location.href = "/report/iReportPrint.jsp?flag=BID_PARTICIPATION_FORM&so_no="+so_no+"&house_code=<%=info.getSession("HOUSE_CODE")%>&type="+type+"&so_count="+so_count+"&vendor_code="+vendor_code ;
	}
//-->
</Script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_estimate_popup";

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
        alert(messsage);
        doQuery();
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
    var params = "mode=getBdEstimatePopupList";
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
    
    return true;
}
function doSpecFlag() {
    if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }
    button_flag = true;

    
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
  
	for(var i = 0; i < grid_array.length; i++)
	{ 
		var test_point      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("TEST_POINT")).getValue()); 
		var standard_point 	= parseFloat(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("STANDARD_POINT")).getValue()));
		var spec_falg 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("SPEC_FLAG")).getValue();// GD_GetCellValueIndex(GridObj,row, INDEX_SPEC_FLAG);
		var reason 			= GridObj.cells(grid_array[i], GridObj.getColIndexById("REASON")).getValue();
		var vendor 			= GridObj.cells(grid_array[i], GridObj.getColIndexById("VENDOR_NAME")).getValue();

		var VENDOR_CODE 	= GridObj.cells(grid_array[i], GridObj.getColIndexById("VENDOR_CODE")).getValue();
		var CEO_NAME_LOC 	= GridObj.cells(grid_array[i], GridObj.getColIndexById("CEO_NAME_LOC")).getValue();
		var TEL 			= GridObj.cells(grid_array[i], GridObj.getColIndexById("TEL")).getValue();
		var USER_NAME 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_NAME")).getValue();
		var USER_MOBILE 	= GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_MOBILE")).getValue();
		var USER_EMAIL 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_EMAIL")).getValue();

		if(VENDOR_CODE == ""){
			alert("공급사를 선택해 주세요.");
			button_flag = false;
			return;
		}
		if(CEO_NAME_LOC == ""){
			//alert("공급사["+vendor+"] 의 대표자명을 입력해 주세요.");
			//button_flag = false;
			//return;
		}
		if(TEL == ""){
			//alert("공급사["+vendor+"] 의 담당자 전화번호를 입력해 주세요.");
			//button_flag = false;
			//return;
		}
		if(USER_NAME == ""){
			//alert("공급사["+vendor+"] 의 담당자이름을 입력해 주세요.");
			//button_flag = false;
			//return;
		}

		if(USER_MOBILE == ""){
			//alert("공급사["+vendor+"] 의 담당자헨드폰을 입력해 주세요.");
			//button_flag = false;
			//return;
		}
		if(USER_EMAIL == ""){
			//alert("공급사["+vendor+"] 의 담당자이메일을 입력해 주세요.");
			//button_flag = false;
			//return;
		}

	<%
		//if(CONT_TYPE2.equals("NE")){
		if(!CONT_TYPE2.equals("LP")) { // 경쟁방법(총액)이 아닌 경우
	%>
		/*
		#1 : 평가점수 입력 체크 로직을 제거합니다. 
			if(test_point < standard_point && spec_falg == "Y" && reason == ""){
				alert("공급사 ["+vendor+"]의 평가점수가 입찰공고시 기준점수보다 낮습니다.\n\n합격 사유를 입력해 주세요.");
				button_flag = false;
				return;
			}
			if(GD_GetCellValueIndex(GridObj,row, INDEX_TEST_POINT) == ""){
				alert("공급사 ["+vendor+"]의 평가점수를 입력해 주세요.");
				button_flag = false;
				return;
			}
			if(test_point > standard_point && spec_falg == "N" && reason == ""){
				alert("공급사 ["+vendor+"]의 평가점수가 입찰공고시 기준점수보다 높습니다.\n\n불합격 사유를 입력해 주세요.");
				button_flag = false;
				return;
			}
	    */
	<%
		}
	%>
    }
	
    if(!confirm("1단계 평가 결과를 저장하시겠습니까?")) {
    	button_flag = false;
        return;
    }
    var url = "bd_estimate_confirm.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT+"&TITLE=가격입찰일시등록";
    window.open( url , "bd_estimate_confirm","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=300,left=50,top=80");
}

function setDecision(BID_BEGIN_DATE, BID_BEGIN_TIME, BID_END_DATE, BID_END_TIME, OPEN_DATE, OPEN_TIME)
{ 
	document.forms[0].BID_BEGIN_DATE.value = BID_BEGIN_DATE ;                             
	document.forms[0].BID_BEGIN_TIME.value = BID_BEGIN_TIME ;                             
	document.forms[0].BID_END_DATE.value   = BID_END_DATE   ;                             
	document.forms[0].BID_END_TIME.value   = BID_END_TIME   ;                             
	document.forms[0].OPEN_DATE.value      = OPEN_DATE      ;                             
	document.forms[0].OPEN_TIME.value      = OPEN_TIME      ;                             
	
	if(!checkRows()) return;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    
    var mode = "setSpecEstimate";

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode="+mode; 
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    myDataProcessor = new dataProcessor( G_SERVLETURL, params );
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
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
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작-->
<form name="form1" >
	<input type="hidden" name="attach_gubun" value="body"> 
	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_count" value="">

<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>">
<input type="hidden" name="BID_COUNT" id="VOTE_COUNT" value="<%=VOTE_COUNT%>">
<input type="hidden" name="BID_BEGIN_DATE" id="BID_BEGIN_DATE" >
<input type="hidden" name="BID_BEGIN_TIME" id="BID_BEGIN_TIME" >
<input type="hidden" name="BID_END_DATE" id="BID_END_DATE" >
<input type="hidden" name="BID_END_TIME" id="BID_END_TIME" >
<input type="hidden" name="OPEN_DATE" id="OPEN_DATE" >
<input type="hidden" name="OPEN_TIME" id="OPEN_TIME" >  
<input type="hidden" name="FLAG" id="FLAG" value="C">  

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
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰방법</td>
      <td width="85%" class="data_td">&nbsp;
        <%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 담당자명</td>
      <td width="85%" class="data_td">&nbsp;
      <%=CHANGE_USER_NAME_LOC%>
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
           <table>
				<tr> 
				<%if(!screen_flag.equals("Y")){ %>
					<td><script language="javascript">btn("javascript:doSpecFlag();", "평가결과등록")</script></td>
					<%} %>
					<td><script language="javascript">btn("javascript:self.close();", "닫 기")</script></td>
				</tr>
			</table>
		</div>
      </td>
    </tr>
  </table>
</form>

</s:header>
<s:grid screen_id="BD_009" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<iframe name = "childFrame" src=""  width="0%" height="0" border=0 frameborder=0></iframe>


