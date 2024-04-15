<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	
	thisWindowPopupScreenName = "입찰생성";

	Config conf = new Configuration();
	boolean dev_flag = false;
	String ssn = ""; // 사업자등록번호

	String sign_use_module = "";// 전자결재 사용모듈
	boolean sign_use_yn = true;
	
    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateDay( to_day, -30 ) );
    String  to_date     = SepoaString.getDateSlashFormat( to_day );
  
	String BID_NO = JSPUtil.nullToEmpty(request.getParameter("BID_NO")); // 생성/수정/확정/상세조회
	String BID_COUNT = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT")); // 생성/수정/확정/상세조회 

	String BID_TYPE = JSPUtil.nullToRef(request.getParameter("BID_TYPE"), "D");
	String CTRL_AMT = JSPUtil.nullToRef(request.getParameter("CTRL_AMT"), "0"); // 통제금액
	String SCR_FLAG = JSPUtil.nullToRef(request.getParameter("SCR_FLAG"), "I"); // 생성/수정/확정/상세조회 flag
					

	String HOUSE_CODE = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String USER_ID = info.getSession("ID");

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	///////////////////////////////

	String script = "";
	String abled = "";
	String script_c = "";
	String abled_c = "";

	if (SCR_FLAG.equals("C") || SCR_FLAG.equals("D")) {
		script = "readonly";
		abled = "disabled";
	}

	if (SCR_FLAG.equals("C")) { // 확정(공고)일때 변경 가능한 항목 설정
		script_c = "";
		abled_c = "";
	}

	///////////////////////////////
	String CONT_TYPE1 = "";
	String CONT_TYPE2 = "";
	String ANN_TITLE = "";
	String ANN_NO = "";
	String ANN_DATE = "";
	String ANN_ITEM = "";
	String RD_DATE = "";
	String DELY_PLACE = "";
	String LIMIT_CRIT = "";
	String PROM_CRIT = "";
	String APP_BEGIN_DATE = "";
	String APP_BEGIN_TIME = "";
	String APP_END_DATE = "";
	String APP_END_TIME = "";
	String APP_PLACE = "";
	String APP_ETC = "";
	String ATTACH_NO = "";
	String ATTACH_CNT = "0";
	String VENDOR_CNT = "0";
	String VENDOR_VALUES = "";
	String LOCATION_CNT = "0";
	String LOCATION_VALUES = "";
	String ANNOUNCE_DATE = "";
	String ANNOUNCE_TIME_FROM = "";
	String ANNOUNCE_TIME_TO = "";
	String ANNOUNCE_AREA = "";
	String ANNOUNCE_PLACE = "";
	String ANNOUNCE_NOTIFIER = "";
	String ANNOUNCE_RESP = "";
	String DOC_FRW_DATE = "";
	String ANNOUNCE_COMMENT = "";
	String ANNOUNCE_FLAG = "";
	String ANNOUNCE_TEL = "";
	String ESTM_FLAG = "";
	String COST_STATUS = "";
	String BID_BEGIN_DATE = "";
	String BID_BEGIN_TIME = "";
	String BID_END_DATE = "";
	String BID_END_TIME = "";
	String BID_PLACE = "";
	String BID_ETC = "";
	String OPEN_DATE = "";
	String OPEN_TIME = "";
	String REPORT_ETC = "";
	String BID_STATUS = "";
  
	String APP_BEGIN_TIME_HOUR_MINUTE = "0000";
	String APP_END_TIME_HOUR_MINUTE = "0000";
	String BID_BEGIN_TIME_HOUR_MINUTE = "0000";
	String BID_END_TIME_HOUR_MINUTE = "0000";
	String OPEN_TIME_HOUR_MINUTE = "0000";
 ; 
	String ESTM_KIND = "";
	String ESTM_RATE = "";
	String ESTM_MAX = "";
	String ESTM_VOTE = "";
	String FROM_CONT = "";
	String FROM_CONT_TEXT = "";
	String FROM_LOWER_BND = "";
	String ASUMTN_OPEN_YN = "";

	String CONT_TYPE_TEXT = "";
	String CONT_PLACE = "";
	String BID_PAY_TEXT = "";
	String BID_CANCEL_TEXT = "";
	String BID_JOIN_TEXT = "";
	String REMARK = "";
	String ESTM_MAX_VOTE = "";

	String STANDARD_POINT = "";
	String TECH_DQ = "";
	String AMT_DQ = "";
	String BID_EVAL_SCORE = ""; 
	String PR_NO = "";
 
	Map map = new HashMap();
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getPrHeaderDetail", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]); 

	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	
    if(wf.getRowCount() > 0) {
 
			CONT_TYPE1 = wf.getValue("CONT_TYPE1", 0);
			CONT_TYPE2 = wf.getValue("CONT_TYPE2", 0);
			ANN_TITLE = wf.getValue("ANN_TITLE", 0);
			ANN_NO = wf.getValue("ANN_NO", 0);
			ANN_DATE = wf.getValue("ANN_DATE", 0);
			ANN_ITEM = wf.getValue("ANN_ITEM", 0);
			RD_DATE = wf.getValue("RD_DATE", 0);
			DELY_PLACE = wf.getValue("DELY_PLACE", 0);
			LIMIT_CRIT = wf.getValue("LIMIT_CRIT", 0);
			PROM_CRIT = wf.getValue("PROM_CRIT", 0);
			APP_BEGIN_DATE = wf.getValue("APP_BEGIN_DATE", 0);
			APP_BEGIN_TIME = wf.getValue("APP_BEGIN_TIME", 0);
			APP_END_DATE = wf.getValue("APP_END_DATE", 0);
			APP_END_TIME = wf.getValue("APP_END_TIME", 0);
			APP_PLACE = wf.getValue("APP_PLACE", 0);
			APP_ETC = wf.getValue("APP_ETC", 0);
			ATTACH_NO = wf.getValue("ATTACH_NO", 0);
			ATTACH_CNT = wf.getValue("ATTACH_CNT", 0);
			VENDOR_CNT = wf.getValue("VENDOR_CNT", 0);
			LOCATION_CNT = wf.getValue("LOCATION_CNT", 0);
			VENDOR_VALUES = wf.getValue("VENDOR_VALUES", 0);
			LOCATION_VALUES = wf.getValue("LOCATION_VALUES", 0);
			ANNOUNCE_DATE = wf.getValue("ANNOUNCE_DATE", 0);
			ANNOUNCE_TIME_FROM = wf.getValue("ANNOUNCE_TIME_FROM", 0);
			ANNOUNCE_TIME_TO = wf.getValue("ANNOUNCE_TIME_TO", 0);
			ANNOUNCE_AREA = wf.getValue("ANNOUNCE_AREA", 0);
			ANNOUNCE_PLACE = wf.getValue("ANNOUNCE_PLACE", 0);
			ANNOUNCE_NOTIFIER = wf.getValue("ANNOUNCE_NOTIFIER", 0);
			ANNOUNCE_RESP = wf.getValue("ANNOUNCE_RESP", 0);
			DOC_FRW_DATE = wf.getValue("DOC_FRW_DATE", 0);
			ANNOUNCE_COMMENT = wf.getValue("ANNOUNCE_COMMENT", 0);
			ANNOUNCE_FLAG = wf.getValue("ANNOUNCE_FLAG", 0);
			ANNOUNCE_TEL = wf.getValue("ANNOUNCE_TEL", 0);
			BID_STATUS = wf.getValue("BID_STATUS", 0);
			ESTM_FLAG = wf.getValue("ESTM_FLAG", 0);
			COST_STATUS = wf.getValue("COST_STATUS", 0);
			BID_BEGIN_DATE = wf.getValue("BID_BEGIN_DATE", 0);
			BID_BEGIN_TIME = wf.getValue("BID_BEGIN_TIME", 0);
			BID_END_DATE = wf.getValue("BID_END_DATE", 0);
			BID_END_TIME = wf.getValue("BID_END_TIME", 0);
			BID_PLACE = wf.getValue("BID_PLACE", 0);
			BID_ETC = wf.getValue("BID_ETC", 0);
			OPEN_DATE = wf.getValue("OPEN_DATE", 0);
			OPEN_TIME = wf.getValue("OPEN_TIME", 0);

			APP_BEGIN_TIME_HOUR_MINUTE = wf.getValue( "APP_BEGIN_TIME_HOUR", 0) + wf.getValue("APP_BEGIN_TIME_MINUTE", 0);
			APP_END_TIME_HOUR_MINUTE = wf.getValue("APP_END_TIME_HOUR", 0) + wf.getValue("APP_END_TIME_MINUTE", 0);
			BID_BEGIN_TIME_HOUR_MINUTE = wf.getValue( "BID_BEGIN_TIME_HOUR", 0) + wf.getValue("BID_BEGIN_TIME_MINUTE", 0);
			BID_END_TIME_HOUR_MINUTE = wf.getValue("BID_END_TIME_HOUR", 0) + wf.getValue("BID_END_TIME_MINUTE", 0);
			OPEN_TIME_HOUR_MINUTE = wf.getValue("OPEN_TIME_HOUR", 0) + wf.getValue("OPEN_TIME_MINUTE", 0);

			PR_NO = wf.getValue("PR_NO", 0);
			BID_TYPE = wf.getValue("BID_TYPE", 0);

			ESTM_KIND = wf.getValue("ESTM_KIND", 0);
			ESTM_RATE = wf.getValue("ESTM_RATE", 0);
			ESTM_MAX = wf.getValue("ESTM_MAX", 0);
			ESTM_VOTE = wf.getValue("ESTM_VOTE", 0);
			FROM_CONT = wf.getValue("FROM_CONT", 0);
			FROM_CONT_TEXT = wf.getValue("FROM_CONT_TEXT", 0);
			FROM_LOWER_BND = wf.getValue("FROM_LOWER_BND", 0);
			ASUMTN_OPEN_YN = wf.getValue("ASUMTN_OPEN_YN", 0);

			CONT_TYPE_TEXT = wf.getValue("CONT_TYPE_TEXT", 0);
			CONT_PLACE = wf.getValue("CONT_PLACE", 0);
			BID_PAY_TEXT = wf.getValue("BID_PAY_TEXT", 0);
			BID_CANCEL_TEXT = wf.getValue("BID_CANCEL_TEXT", 0);
			BID_JOIN_TEXT = wf.getValue("BID_JOIN_TEXT", 0);

			REMARK = wf.getValue("REMARK", 0);
			ESTM_MAX_VOTE = wf.getValue("ESTM_MAX_VOTE", 0);

			STANDARD_POINT = wf.getValue("STANDARD_POINT", 0);
			TECH_DQ = wf.getValue("TECH_DQ", 0);
			AMT_DQ = wf.getValue("AMT_DQ", 0);
			BID_EVAL_SCORE = wf.getValue("BID_EVAL_SCORE", 0);
			REPORT_ETC = wf.getValue("REPORT_ETC", 0); 
	 
	}  
 
%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%> 
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">

var explanation_modify_flag = "false";
var button_flag 	= false;
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_ann";

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var j=0;

function init() { 
	setGridDraw();   
}

function setGridDraw()
{
    GridObj_setGridDraw();
    GridObj.setSizes();
	doQuery();
	setVisibleVendor(); // 업체지정
	//checkExplanation();
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
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
 
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
	var bid_no = obj.getAttribute("bid_no");
	var bid_count = obj.getAttribute("bid_count");
	var pflag = obj.getAttribute("pflag");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }
 
    return false;
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

	for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
		GridObj.enableSmartRendering(true);
    	GridObj.selectRowById(GridObj.getRowId(i), false, true);
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");	
    	
	}	

	 <%if( !info.getSession("USER_TYPE").equals("S")) { %>
	    if( GridObj.getRowsNum() > 0 ) {
	
	        supiFlame.rfq_no = "<%=BID_NO%>";
	        supiFlame.rfq_count = "<%=BID_COUNT%>"; 
	
			var	SELLER_SELECTED = LRTrim(GridObj.cells(1, GridObj.getColIndexById("SELLER_SELECTED")).getValue());
			var SELLER = SELLER_SELECTED.split("#");
			var seller_codes = "";
			for (var i = 0 ; i < SELLER.length ; i++){
				seller_codes += SELLER[i].split("@")[0] + "@";
			}
	        supiFlame.doSelect(seller_codes,null,null,"BID");
	    }
	    GridObj.setSizes();
    <%}%>
	setVisiblePeriod(); // 
	setVisibleESTM(); // 단일예가/복수예가
    return true;
}

function initAjax()
{ 
		doRequestUsingPOST( 'SL0018', '<%=HOUSE_CODE%>'+'#M974' ,'CONT_TYPE1', '<%=CONT_TYPE1%>' );  
		doRequestUsingPOST( 'SL0018', '<%=HOUSE_CODE%>'+'#M973' ,'CONT_TYPE2', '<%=CONT_TYPE2%>' );  
		doRequestUsingPOST( 'SL0018', '<%=HOUSE_CODE%>'+'#M930' ,'PROM_CRIT', '<%=PROM_CRIT%>' );  
}
/**
 * 일반경쟁, 지명경쟁에 따른 업체지정
 */
function setVisibleVendor() {
	var CONT_TYPE1 = document.forms[0].CONT_TYPE1.value; // 입찰방법
	
	if ( CONT_TYPE1 == "NC" ) { // 지명경쟁
		for(m=1;m<=4;m++) { // 지역지정
			document.all["h1"+m].style.visibility = "hidden";
		}
		document.forms[0].location_count.value = "0";
	}
	else if ( CONT_TYPE1 == "LC" ) { // 지역공개경쟁
		for(m=1;m<=4;m++) { // 지역지정
			document.all["h1"+m].style.visibility = "visible";
		}
		for(n=1;n<=4;n++) { // 업체지정
			document.all["h"+n].style.visibility = "hidden";
		}
		document.forms[0].vendor_values.value = "";
		document.forms[0].seller_cnt.value = "0";
	}
	else { // 일반경쟁
		/*for(n=1;n<=4;n++) { // 업체지정
			document.all["h"+n].style.visibility = "hidden";
		}*/
		//document.forms[0].vendor_values.value = "";
		//document.forms[0].seller_cnt.value = "0";
		
		//for(m=1;m<=4;m++) { // 지역지정
		//	document.all["h1"+m].style.visibility = "hidden";
		//}
		document.forms[0].location_count.value = "0";
	}
}

/**
 * 입찰방법(총액, 2단계경쟁, 수의계약)
 */
function setVisiblePeriod() {
	var CONT_TYPE2 = document.forms[0].CONT_TYPE2.value;
 
	if ( CONT_TYPE2 == "LP" ) { // 총액입찰
		for(n=1;n<=2;n++) {
			document.all["g"+n].style.display = ""; // 입찰서 제출일시, 개찰일시
		}
		for(m=1;m<=1;m++) {
			document.all["i"+m].style.display = "none"; // 입찰참가 신청일시
		}
	    //document.form.TECH_DQ.value = 80; // 기술점수 비율
	    //document.form.AMT_DQ.value = 20; // 가격점수 비율
		for(x=1;x<=1;x++) {
			//document.all["q"+x].style.display = ""; // 기준점수(1~6), 점수비율(7~12)
			document.all["q"+x].style.display = ""; // 기준점수(1~6), 점수비율(7~12)
		}
	} else { // 2단계 및 협상에 의한 계약
		for(n=1;n<=2;n++) {
			document.all["g"+n].style.display = "none"; // 입찰서 제출일시, 개찰일시
		}
		for(m=1;m<=1;m++) {
			document.all["i"+m].style.display = ""; // 입찰참가 신청일시
		}
		for(x=1;x<=1;x++) {
			document.all["q"+x].style.display = ""; // 기준점수(1~6)
		}
		if (( CONT_TYPE2 == "TE" ) || ( CONT_TYPE2 == "NE" )){ // 2단계 및 협상에 의한 계약
			for(x=1;x<=1;x++) { // 기준점수(1~6), 점수비율(7~12)
				document.all["q"+x].style.display = "";
			}
		}else{
			for(x=1;x<=1;x++) {
				document.all["q"+x].style.display = "none";
			}
		}
	}
	 
}
/**
 * 단일예가/복수예가 체크
 */
function setVisibleESTM()   {
	var ESTM_KIND = document.forms[0].ESTM_KIND.value;

	if ( ESTM_KIND  == "M"  ) { // 복수예가
		for(n=1;n<=1;n++) {
			document.all["e"+n].style.display = "";
		}
		//생성시 디폴트값 세팅
		<%if (SCR_FLAG.equals("I")) {%>
			document.form.ESTM_RATE.value = 2;
		<%}%>
	} else { // 단일예가
		for(n=1;n<=1;n++) {
			document.all["e"+n].style.display = "none";
		}
		document.forms[0].ESTM_VOTE.value = "2";
		document.forms[0].ESTM_MAX.value = "";
		document.forms[0].ESTM_RATE.value = "";
	}
} 
	// 첨부파일
	function setAttach(attach_key, arrAttrach, attach_count) {
		if(document.forms[0].isGridAttach.value == "true"){
			setAttach_Grid(attach_key, arrAttrach, attach_count);
			return;
		}
	    var attachfilename  = arrAttrach + "";
	    var result 			="";
		var attach_info 	= attachfilename.split(",");
		for (var i =0;  i <  attach_count; i ++)
	    {
		    var doc_no 			= attach_info[0+(i*7)];
			var doc_seq 		= attach_info[1+(i*7)];
			var type 			= attach_info[2+(i*7)];
			var des_file_name 	= attach_info[3+(i*7)];
			var src_file_name 	= attach_info[4+(i*7)];
			var file_size 		= attach_info[5+(i*7)];
			var add_user_id 	= attach_info[6+(i*7)];
	
			if (i == attach_count-1)
				result = result + src_file_name;
			else
				result = result + src_file_name + ",";
		}
		document.forms[0].attach_no.value     	= attach_key;
		document.forms[0].attach_cnt.value     	= attach_count;
        document.getElementById("attach_no_text").innerHTML = "";
        document.forms[0].only_attach.value = "attach_no";
        //setAttach1();
    }
    
    function setAttach1() {
        var nickName        = "SIF_001";
        var conType         = "TRANSACTION";
        var methodName      = "getFileNames";
        var SepoaOut        = doServiceAjax( nickName, conType, methodName );
        
        if( SepoaOut.status == "1" ) { // 성공
            //alert("성공적으로 처리 하였습니다.");
            var test = (SepoaOut.result[0]).split("<%=conf.getString( "sepoa.separator.line" )%>");
            var test1 = test[1].split("<%=conf.getString( "sepoa.separator.field" )%>");
            
            setAttach2(test1[0]);
            
        } else { // 실패
<%--             alert("<%=text.get("MESSAGE.1002")%>"); --%>
        }
    }

    function setAttach2(result){
        var text  = result.split("||");
        var text1 = "";
    
        for( var i = 0; i < text.length ; i++ ){
            
            text1  += text[i] + "<br/>";
        }
        
        document.getElementById("attach_no_text").innerHTML = text1;
    }
	
	
	//그리드 파일첨부
	function setAttach_Grid(attach_key, arrAttrach, attach_count) {
	    var attachfilename  = arrAttrach + "";
	    var result 			="";
		var attach_info 	= attachfilename.split(",");
		for (var i =0;  i <  attach_count; i ++)
	    {
		    var doc_no 			= attach_info[0+(i*7)];
			var doc_seq 		= attach_info[1+(i*7)];
			var type 			= attach_info[2+(i*7)];
			var des_file_name 	= attach_info[3+(i*7)];
			var src_file_name 	= attach_info[4+(i*7)];
			var file_size 		= attach_info[5+(i*7)];
			var add_user_id 	= attach_info[6+(i*7)];
	
			if (i == attach_count-1)
				result = result + src_file_name;
			else
				result = result + src_file_name + ",";
		}
		GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO")).setValue(attach_key);
		GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO_CNT")).setValue(attach_count);
		document.forms[0].isGridAttach.value = "false";
	}
 
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="javascript:init();initAjax();">

<s:header popup="true">
<!--내용시작-->

<form name="form"> 
<input type="hidden" name="APP_BEGIN_TIME" id="APP_BEGIN_TIME" />
<input type="hidden" name="APP_END_TIME" id="APP_END_TIME" />   
<input type="hidden" name="pflag" id="pflag" />
<input type="hidden" name="approval_str" id="approval_str" />

<input type="hidden" name="PR_DATA" id="PR_DATA" value=""/>
		<!-- 업체수 hidden으로 바꿈 -->                                                    
<input type="hidden" name="vendor_count" id="vendor_count" value="0">                         
		                                                            
<input type="hidden" name="sign_status" id="sign_status" value="N">                          
<!-- 저장,결재를 구분하는 플래그 -->                                        
<input type="hidden" name="bid_amt" id="bid_amt" value="">                               
<input type="hidden" name="vendor_values"   id="vendor_values"  value="<%=VENDOR_VALUES%>">       
<input type="hidden" name="location_values" id="location_values" value="<%=LOCATION_VALUES%>">   
                                                            
<!-- hidden(제안설명회) //-->                                               
<input type="hidden" name="bid_no" 	  id="bid_no" 	         value="<%=BID_NO%>">                     
<input type="hidden" name="bid_count" 	  id="bid_count" 	 value="<%=BID_COUNT%>">              
<input type="hidden" name="start_time" 	  id="start_time" 	 value="<%=ANNOUNCE_TIME_FROM%>">    
<input type="hidden" name="end_time" 	  id="end_time" 	 value="<%=ANNOUNCE_TIME_TO%>">         
<input type="hidden" name="ANNOUNCE_FLAG" id="ANNOUNCE_FLAG"     value="<%=ANNOUNCE_FLAG%>">       
<input type="hidden" name="ANNOUNCE_TEL"  id="ANNOUNCE_TEL"      value="<%=ANNOUNCE_TEL%>">         
<input type="hidden" name="area" 	  id="area" 	         value="<%=ANNOUNCE_AREA%>">                
<input type="hidden" name="place" 	  id="place" 	         value="<%=ANNOUNCE_PLACE%>">              
<input type="hidden" name="notifier" 	  id="notifier" 	 value="<%=ANNOUNCE_NOTIFIER%>">
<input type="hidden" name="doc_frw_date"  id="doc_frw_date"      value="<%=DOC_FRW_DATE%>">         
<input type="hidden" name="resp" 	  id="resp" 	         value="<%=ANNOUNCE_RESP%>">                
<input type="hidden" name="comment" 	  id="comment" 	         value="<%=ANNOUNCE_COMMENT%>">          
<input type="hidden" name="data1" 	  id="data1" 	         value="">                         
<input type="hidden" name="attach_gubun"  id="attach_gubun"      value="body">        
<input type="hidden" name="att_mode" 	  id="att_mode" 	 value="">                      
<input type="hidden" name="view_type" 	  id="view_type" 	 value="">                     
<input type="hidden" name="file_type" 	  id="file_type" 	 value="">                     
<input type="hidden" name="tmp_att_no" 	  id="tmp_att_no" 	 value="">                    
<input type="hidden" name="BID_EVAL_SCORE" id="BID_EVAL_SCORE"  value="<%=BID_EVAL_SCORE%>"/>      
 
<input type="hidden" name="seller_change_flag" id="seller_change_flag" value= "Y"><!-- 업체선택여부 -->
<input type="hidden" name="vendor_each_flag">
<input type="hidden" name="rownum">
<input type="hidden" name="seller_cnt" value="<%=VENDOR_CNT%>">
<input type="hidden" name="seller_choice">

<input type="hidden" name="PR_NO_SEQ" id="PR_NO_SEQ">
<input type="hidden" name="p_approval_flag" id="p_approval_flag"> 

<input type="hidden" name="app_line_id"  id="app_line_id"  />
<input type="hidden" name="app_line_seq" id="app_line_seq" />
<input type="hidden" name="app_auto_flag" id="app_auto_flag" />
<input type="hidden" name="app_line"     id="app_line"     />
<input type="hidden" name="Approval_str" id="Approval_str" />
<input type="hidden" name="att_show_flag">
<input type="hidden" name="attach_seq">	
<input type="hidden" name="isGridAttach">
<input type="hidden" name="only_attach" id="only_attach" value="">
		    
<%  
thisWindowPopupFlag = "true";
thisWindowPopupScreenName = "입찰공고 상세조회";
%>
	<%@ include file="/include/sepoa_milestone.jsp"%>

		<table width="100%" border="0" cellpadding="0" cellspacing="0">
	
		<tr>
    	 	<td height="5"> </td>
	  	</tr>
	  	<tr>
	    	<td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
			<tr>
				<td width="20%" class="title_td">공고번호</td>
				<td class="data_td_input" width="35%">&nbsp;<%=ANN_NO%>
				</td>
				<td width="15%" class="title_td">공고일자</td>
				<td width="35%" class="data_td_input">&nbsp;<%=SepoaString.getDateSlashFormat(ANN_DATE) %>
				</td>
			</tr>
			<tr>
				<td width="15%" class="title_td">입찰건명</td>
				<td class="data_td_input"  colspan="3">&nbsp;<%=ANN_ITEM %>
				</td>
			</tr>
			<tr>				
				<td width="15%" class="title_td">입찰방법</td>
				<td class="data_td_input" width="35%"><b>
                        <select name="CONT_TYPE1" id="CONT_TYPE1" class="inputsubmit" onChange="setVisibleVendor()" <%=abled %>> 
                        </select>&nbsp; 
                        <select name="CONT_TYPE2" id="CONT_TYPE2" class="inputsubmit" onChange="setVisiblePeriod()" <%=abled %>> 
                        </select> </b>
				</td>
				<td width="15%" class="title_td">낙찰자 선정기준</td>
				<td width="35%" class="data_td_input">
						<select name="PROM_CRIT" id="PROM_CRIT" class="inputsubmit" onChange="avengerkim()" <%=abled %>> 
                        </select> 
				
					<script>
				    	function avengerkim() {
				    		f = document.forms[0];
				    		if (f.PROM_CRIT.value=='B') { //낙찰하한가이면
				    			f.FROM_LOWER_BND.value='80';
				    			f.FROM_LOWER_BND.readOnly = '';
				    		} else {
				    			f.FROM_LOWER_BND.value='0';
				    			f.FROM_LOWER_BND.readOnly = '';
				    		}
				    	}
				    </script>
				    <input type="hidden" name="FROM_CONT_TEXT" id="FROM_CONT_TEXT" value="<%=FROM_CONT_TEXT%>">
				    <input type="hidden" name="FROM_CONT" id="FROM_CONT" value="<%=FROM_CONT%>">
					<!--input type="hidden" name="FROM_LOWER_BND" value="<//%=FROM_LOWER_BND%>"-->
				</td>
			</tr>
			<tr id="q1">
				<td class="title_td" width="15%"></td>
				<td class="data_td_input" colspan="3">&nbsp;점수비율 [ 기술제안서</span> <%=TECH_DQ%> % : 가격 <%=AMT_DQ%> %
					]&nbsp;&nbsp;&nbsp;&nbsp;기준점수 <%=STANDARD_POINT%>&nbsp;&nbsp;&nbsp;&nbsp;
					낙찰하한율<b> <%=FROM_LOWER_BND%> %</b>
				</td>
			</tr>
			<tr>
				<td width="15%" class="title_td">세부입찰방법</td>
				<td width="35%" class="data_td_input" colspan="3">&nbsp;<%=CONT_TYPE_TEXT%>
						<input type="hidden" name="location_count" id="location_count" size="3" value="<%=LOCATION_CNT%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly id=h14>
					</span>
				</td>
			</tr>
			<tr>
				<td width="15%" class="title_td">입찰장소</td>
				<td class="data_td_input" width="35%" colspan="3">&nbsp;<%=CONT_PLACE%></td>
			</tr>

			<tr id="i1">
				<td class="title_td" width="15%">입찰참가 신청일시
				</td>
				<td class="data_td_input" width="35%" colspan="3">&nbsp;<%=APP_BEGIN_DATE %>일 <%=wf.getValue( "APP_BEGIN_TIME_HOUR", 0)%> : <%=wf.getValue( "APP_BEGIN_TIME_MINUTE", 0) %>
						&nbsp;&nbsp;~&nbsp;&nbsp; 
					<%=APP_END_DATE %>일 <%=wf.getValue( "APP_END_TIME_HOUR", 0)%> : <%=wf.getValue( "APP_END_TIME_MINUTE", 0) %>
				</td>
			</tr>
 
			<tr  id="g1">
				<td class="title_td" width="15%">입찰서 제출일시
				</td>
				<td class="data_td_input" width="35%" colspan="3"  >&nbsp;<%=BID_BEGIN_DATE %>일 <%=wf.getValue( "BID_BEGIN_TIME_HOUR", 0)%> : <%=wf.getValue( "BID_BEGIN_TIME_MINUTE", 0) %>
						&nbsp;&nbsp;~&nbsp;&nbsp; 
					<%=BID_END_DATE %>일 <%=wf.getValue( "BID_END_TIME_HOUR", 0)%> : <%=wf.getValue( "BID_END_TIME_MINUTE", 0) %></td>
			</tr>

			<tr  id="g2">
				<td class="title_td" width="15%">개찰일시
				</td>
				<td class="data_td_input" width="35%" colspan="3">&nbsp;<%=OPEN_DATE %>일 <%=wf.getValue( "OPEN_TIME_HOUR", 0)%> : <%=wf.getValue( "OPEN_TIME_MINUTE", 0) %></td>
			</tr>

			<tr>
				<td width="15%" class="title_td">입찰참가 자격</td>
				<td width="35%" class="data_td_input" colspan="3"> 
				<textarea name="LIMIT_CRIT" id="LIMIT_CRIT" cols="95" rows="3"  <%=script%> onKeyUp="return chkMaxByte(1000, this, '입찰참가자격');"><%=LIMIT_CRIT%></textarea>
				</td>
			</tr>

			<tr>
				<td width="15%" class="title_td">입찰보증금 납부 및 귀속</td>
				<td class="data_td_input" width="35%" colspan="3">&nbsp;<%=BID_PAY_TEXT%> 
			</tr>
			<tr>
				<td width="15%" class="title_td">입찰무효</td>
				<td class="data_td_input" width="35%" colspan="3">&nbsp;<%=BID_CANCEL_TEXT%></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">입찰참가 등록</td>
				<td class="data_td_input" width="35%" colspan="3">&nbsp;<%=BID_JOIN_TEXT%></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">문의사항</td>
				<td class="data_td_input" width="35%" colspan="3">&nbsp;<%=REMARK%>
				</td>
			</tr>

			<tr style="display: none;">
				<td width="15%" class="title_td">예정가격</td>
				<td class="data_td_input" width="35%"><b> 
				<select name="ESTM_KIND" id="ESTM_KIND" class="inputsubmit" onChange="setVisibleESTM()"
						<%=abled%>>
							<option value="U" selected>단일예가</option>
							<option value="M">복수예가</option>
					</select> </b></td>
				<td width="50%" class="title_td" colspan="2">예비가격범위 
				<input type="text" name="ESTM_RATE" id="ESTM_RATE" size="3" maxlength="2" value="<%=ESTM_RATE%>"
						<%=script%>>
						%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<span id="e1">사용예비가격/추첨수 
						<input type="hidden" name="ESTM_MAX_VOTE" id="ESTM_MAX_VOTE"> 
						<input type="text" name="ESTM_MAX" id="ESTM_MAX" size="3" maxlength="2" value="<%=ESTM_MAX%>"
							onblur="check_ESTM_MAX()" <%=script%> > 
						<input type="text" name="ESTM_VOTE" id="ESTM_VOTE" size="2" maxlength="1" readOnly
							value="<%=ESTM_VOTE%>" onblur="check_ESTM_VOTE()" <%=script%>> </span>
				</td>
			</tr>
			<tr>
				<td class="title_td" width="15%">납기일자</td>
				<td class="data_td_input" width="35%">&nbsp;<%=RD_DATE %>일 
				</td>
				<td class="title_td" width="15%">납품장소</td>
				<td class="data_td_input" width="35%">&nbsp;<%=DELY_PLACE%></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">기타사항</td>
				<td width="35%" class="data_td_input" colspan="3">
				<textarea name="BID_ETC" id="BID_ETC" style="ime-mode: active" rows="3" cols="95"  <%=script%> onKeyUp="return chkMaxByte(1000, this, '기타사항');"><%=BID_ETC%></textarea>
				</td>
			</tr>
			<tr>
				<td width="15%" class="title_td">보고사항</td>
				<td width="35%" class="data_td_input" colspan="3">
				<textarea name="REPORT_ETC" id="REPORT_ETC" style="ime-mode: active" rows="3" cols="95"  <%=script%> onKeyUp="return chkMaxByte(1000, this, '기타사항');"><%=REPORT_ETC%></textarea>
				</td>
			</tr>
			<tr>
				<td width="15%" class="title_td"> 첨부파일</td>
				<td class="data_td_input" id="attach_td_id" colspan="3"> &nbsp;
        				<TABLE>
    		      			<TR>
    		      				<td><input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>"></td>
    	    	  				<td>
	                            <% if(SCR_FLAG.equals("D")){%>
	                                <script language="javascript">btn("javascript:FileAttach('BD',document.forms[0].attach_no.value,'VI');","파일첨부")</script>
	                            <%}else{ %>
	                                <script language="javascript">btn("javascript:attach_file(document.forms[0].attach_no.value,'BD');document.forms[0].attach_seq.value=1","파일첨부" )</script>
	                            <%}%> 
                               </td>
    		      				<td><input type="text" name="attach_cnt" id="attach_cnt" size="3" class="div_empty_num_no" readonly value="<%=ATTACH_CNT%>">
                                    <input type="text" size="5" readOnly class="div_empty_no" value="<%=text.get("MESSAGE.file_count")%>" name="file_count">
                                </td>
                                <td width="170">
                                    <div id="attach_no_text"></div>
                                </td>
    						</TR>
						</TABLE>
				</td>
			</tr>
		</table>

		<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<td><script language="javascript">btn("javascript:window.close()", "닫 기")</script></td>
						</TR>
					</TABLE></TD>
			</TR>
		</TABLE>
		 <%if( !info.getSession("USER_TYPE").equals("S")) { %>
    <div width="100%" height="250" id="supiFlameDiv" name="supiFlameDiv">
    	<iframe src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_botton_vi.jsp" name="supiFlame" id="supiFlame" width="100%" height="170px" border="0" scrolling="no" frameborder="0"></iframe>
    </div>
    <%} %>
</form>
 
		<!---- END OF USER SOURCE CODE ---->

</s:header> 
<s:grid screen_id="BD_001" grid_obj="GridObj" grid_box="gridbox"/>  
<s:footer/>

</body>
</html> 