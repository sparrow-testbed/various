<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_017");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_017";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String house_code       = info.getSession("HOUSE_CODE");
	String company_code     = info.getSession("COMPANY_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 		= info.getSession("NAME_LOC");
	
	String G_IMG_ICON = "/images/ico_zoom.gif";
	
    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
    String  to_date     = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1);
    
	String purchaser_id = "";
	String purchaser_nm = "";
	
	purchaser_id = info.getSession("ID");
	purchaser_nm = info.getSession("NAME_LOC");
	

	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_bd_result_list"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
    
%> 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>  

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 
<script language="javascript">
<!--
	var G_HOUSE_CODE   = "<%=house_code%>";
	var G_COMPANY_CODE = "<%=company_code%>";
    var mode;
  

    function checkUserId(row_idx) {
        var user_id        = "<%=user_id%>";
	    var change_user_id = GD_GetCellValueIndex(GridObj,row_idx, INDEX_CHANGE_USER_ID);

        if (user_id != change_user_id) {
   	        alert("담당자만 작업 가능합니다.");
   	        return false;
        }

 		return true;
  	}

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
			for(var i = 0; i < GridObj.GetRowCount(); i++) {
				if( "SB" == GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_STATUS),i)) {
        			for (var j = 0; j < GridObj.GetColCount(); j++) {
    					//GridObj.SetCellBgColor(GridObj.GetColHDKey( j),i, "254|251|226");
        			}
				}
			}
	    } else if(msg1 == "doData") {
	    	if(mode == "doCancelBidding"){
	    		alert(GridObj.GetMessage());
				doSelect();
	    	}
			
			
	    } else if(msg1 == "t_imagetext") { //공고번호 click

            BID_NO          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT       = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            VOTE_COUNT      = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_COUNT);
            PR_NO           = GD_GetCellValueIndex(GridObj,msg2, INDEX_PR_NO);
            ANN_NO          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_NO),msg2);
            ANN_ITEM        = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_ITEM),msg2);
            VENDOR_NAME     = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_NAME),msg2);
            VENDOR_CODE     = GD_GetCellValueIndex(GridObj,msg2, INDEX_VENDOR_CODE);

            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_STATUS);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_ANN_ITEM) {
                //window.open('/ebid_doc/inchalresult.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT+'&VOTE_COUNT='+VOTE_COUNT,"ebd_pp_dis32","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
            } else if(msg3 == INDEX_VENDOR_CODE) {
    	    	var vendor_code = GridObj.GetCellValue("VENDOR_CODE",msg2);
    			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
            }else if(msg3 == INDEX_PRINT_NO){ // 인쇄번호 클릭시
            	var announce_flag = GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE_FLAG);
            	childFrame.location.href = "/report/iReportPrint.jsp?flag=COM&so_no="+BID_NO+"&house_code=<%=house_code%>&type=BID&so_count="+BID_COUNT+"&vote_count="+VOTE_COUNT+"&so_ann_flag="+announce_flag;
            }
        }
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
            doQuery();
        }
    }
    
    function doPrint(){
    
    }
    
    
	function PopupManager(part)
	{
		
		if(part == "CONTACT_USER"){
			window.open("/common/CO_008.jsp?callback=getConUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		
		/* 
		if(part=="CONTACT_USER")
		{
			PopupCommon2("SP0023","getAddUser",G_HOUSE_CODE, G_COMPANY_CODE,"담당자ID","담당자명");
		}
		*/
		
		if(part == "PURCHASER_ID"){
			window.open("/common/CO_008.jsp?callback=getPurUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
	}
	
	function getConUser(code, text){
		document.form1.contact_user.value = code;
		document.form1.contact_user_name.value = text;
	}	
	
	/* 
	function getAddUser(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION)
	{
		document.form1.contact_user.value = USER_ID;
		document.form1.contact_user_name.value = USER_NAME_LOC;
	}
	*/
	
	function getPurUser(code, text){
		document.form1.purchaser_name.value = text;
		document.form1.purchaser_id.value = code;
	}
	
	
	function getVendorCode(setMethod) { popupvendor(setMethod); }
	
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.form1.settle_vendor_code.value = code;
		document.form1.settle_vendor.value = desc1;
	}

	function popupvendor( fun ){
	    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}


//-->
</script>



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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_result_list";

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
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	if(header_name == "ANN_NO")
    {
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());      
		var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
		var bid_type = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());
		
		var url = "/sourcing/bd_ann_d_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'800','700');
    }else if(header_name == "ANN_ITEM"){
    	
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());     
        var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());     
        //url =  "bd_open_compare_pop.jsp?BID_NO="+bid_no+"&BID_COUNT="+bid_count+"&VOTE_COUNT="+vote_count;
        //doOpenPopup(url,'1100','700');       
        var url    = '/sourcing/bd_open_compare_pop.jsp';
		var title  = '개찰결과';
		var param  = 'popup=Y';
		param     += '&BID_NO=' + bid_no;
		param     += '&BID_COUNT=' + bid_count;
		param     += '&VOTE_COUNT=' + vote_count;
		popUpOpen01(url, title, '1100', '700', param);                   
    } else if(header_name == "VENDOR_NAME") {
    	
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
    }else if(GridObj.getColIndexById("VENDOR_COUNT") == cellInd || GridObj.getColIndexById("VENDOR_COUNT1") == cellInd || GridObj.getColIndexById("VENDOR_COUNT2") == cellInd || GridObj.getColIndexById("VENDOR_COUNT3") == cellInd){
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());          	
        var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());          	
        
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].VOTE_COUNT.value = vote_count; 
	
        var url = "bd_pp_dis.jsp?BID_NO=" + bid_no + "&BID_COUNT=" + bid_count + "&VOTE_COUNT=" + vote_count ;
		doOpenPopup(url,'800','350');
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
    var params = "mode=getBdResultList";
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
   
    document.forms[0].start_change_date.value = add_Slash( document.forms[0].start_change_date.value );
    document.forms[0].end_change_date.value   = add_Slash( document.forms[0].end_change_date.value   );
    
    return true;
}
//낙찰취소
function doCancelBidding(){
	if(!checkUser()) return;

	var checkedCnt = 0;
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    for( var i = 0; i < grid_array.length; i++ ) {
			checkedCnt++;
	        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
	        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
	        var VOTE_COUNT      = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue();
	        
			if(!(GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue() == "SB" 
						&& GridObj.cells(grid_array[i], GridObj.getColIndexById("PREFERRED_BIDDER")).getValue() != "Y")){
				alert("입찰결과가 낙찰인 경우에 낙찰취소가 가능합니다.");
				return;
			}
			
			if(GridObj.cells(grid_array[i], GridObj.getColIndexById("CAN_CANCEL_BIDDING")).getValue()== "N"){
				alert("품의가 진행되어서 낙찰취소 하실 수 없습니다.");
				return;
			} 
	}
	
	if(checkedCnt == 0){
		alert("선택하신 건이 없습니다.");
		return;
	}
	
	if(!confirm("낙찰취소 하시겠습니까?")){
		return;
	}
	
	//mode   = "doCancelBidding";

    var cols_ids = "<%=grid_col_id%>"; 
	document.form1.BID_NO.value 		= BID_NO;
	document.form1.BID_COUNT.value		= BID_COUNT;
	document.form1.VOTE_COUNT.value  = VOTE_COUNT;
    var params = "mode=setBdCancel";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput(); 
    myDataProcessor = new dataProcessor( G_SERVLETURL, params );
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
}

// 직무권한 체크
function checkUser() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    for( var i = 0; i < grid_array.length; i++ ) {
			for( i=0; i<ctrl_code.length; i++ )
			{
					if(ctrl_code[i] == GridObj.cells(grid_array[i], GridObj.getColIndexById("CTRL_CODE")).getValue()) {
						flag = true;
						break;
					} else
						flag = false;
				} 
		}

	if (!flag)
		alert("작업을 수행할 권한이 없습니다.");

		return flag;
	}

function initAjax()
{ 
		doRequestUsingPOST( 'SL0018', '<%=house_code%>'+'#M976' ,'bid_flag', '' );   
}
// 지우기
function doRemove( type ){
    if( type == "CONTACT_USER" ) {
    	document.forms[0].contact_user.value = "";
        document.forms[0].contact_user_name.value = "";
    }  
    if( type == "purchaser_id" ) {
    	document.forms[0].purchaser_id.value = "";
        document.forms[0].purchaser_name.value = "";
    }  
    if( type == "vendor_code" ) {
    	document.form1.settle_vendor_code.value = "";
        document.form1.settle_vendor.value = "";
    }
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
	sRptData += document.form1.bid_flag.options[document.form1.bid_flag.selectedIndex].text;	//입찰결과
	sRptData += rf;
	sRptData += document.form1.ann_no.value;	//공고번호
	sRptData += rf;
	sRptData += document.form1.ann_item.value;	//입찰건명
	sRptData += rf;
	sRptData += document.form1.settle_vendor_code.value;	//낙찰업체1
	sRptData += rf;
	sRptData += document.form1.settle_vendor.value;	//낙찰업체2
	sRptData += rf;
	sRptData += document.form1.contact_user.value;	//입찰담당자1
	sRptData += rf;
	sRptData += document.form1.contact_user_name.value;	//입찰담당자2
	sRptData += rf;
	sRptData += document.form1.BID_TYPE_C.options[document.form1.BID_TYPE_C.selectedIndex].text;	//입찰구분	
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("STATUS_TEXT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("ANN_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VOTE_COUNT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ANN_ITEM",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("BID_END_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("CONT_TYPE1_TEXT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VENDOR_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VENDOR_COUNT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VENDOR_COUNT1",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VENDOR_COUNT2",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("VENDOR_COUNT3",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("CUR",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("SUM_AMT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("REASON",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("BID_TYPE_NM",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("ITEM_TYPE_TEXT_D",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("ESTM_SUM_AMT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("ESTM_C_PRICE",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("FINAL_ESTM_PRICE",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("CNST_BATCH_GB_TEXT",i);
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
<body onload="javascript:init();initAjax();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->

<form name="form1" >
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
<input type="hidden" name="ctrl_code" value="">
<input type="hidden" name="BID_NO" id="BID_NO">
<input type="hidden" name="BID_COUNT" id="BID_COUNT">
<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT">
<input type="hidden" name="SCR_FLAG" value="">

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
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        입찰마감일자
      </td>
      <td width="35%" class="data_td">
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/> 
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
      	입찰결과
      </td>
      <td width="35%" class="data_td">
        <select name="bid_flag" id="bid_flag" >
          <option value="">전체</option> 
        </select>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        공고번호
      </td>
      <td class="data_td">
        <input type="text" name="ann_no" id="ann_no" size="20" maxlength="20"  style="ime-mode:inactive" onkeydown='entKeyDown()'>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        입찰건명
      </td>
      <td class="data_td">
        <input type="text" style="ime-mode:active;width:95%"  name="ann_item" id="ann_item"  onkeydown='entKeyDown()'>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	     
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        낙찰업체
      </td>
      <td width="35%" class="data_td">
<!--         <input type="text" name="settle_vendor" id="settle_vendor"  size="20" onkeydown='entKeyDown()'> -->
		<input type="text"  onkeydown='entKeyDown()'  name="settle_vendor_code" id="settle_vendor_code" size="15" class="inputsubmit" maxlength="10" readonly>
        <a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
        <a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
        <input type="text"  onkeydown='entKeyDown()'  name="settle_vendor" id="settle_vendor" size="20" class="inputsubmit" readonly>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        입찰담당자
      </td>
      <td width="35%" class="data_td">
		<input type="text" name="contact_user" id="contact_user" size="16" maxlength="10"  value='<%=(!"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")))?info.getSession("ID"):"" %>' >
		<a href="javascript:PopupManager('CONTACT_USER');">
			<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
		</a>
        <a href="javascript:doRemove('CONTACT_USER')"><img src="../images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" name="contact_user_name" id="contact_user_name" size="25" onkeydown='entKeyDown()' readonly value='<%=(!"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")))?info.getSession("NAME_LOC"):""%>'>
      </td>
    </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	     
    <tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰구분</td>
      	<td width="35%" class="data_td" colspan="3">
			<select id="BID_TYPE_C" name="BID_TYPE_C">
		    	<option value="">전체</option>
		       	<option value="D">구매입찰</option>
		       	<option value="C">공사입찰</option>
		    </select>	
		</td>  
		
		
		<td class="title_td" style="display: none;" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		  구매담당자
		</td>
		<td class="data_td" style="display: none;">
			<input type="text" name="purchaser_id" id="purchaser_id" size="20" style="ime-mode:inactive"  value="" class="inputsubmit"  onkeydown='entKeyDown()' >
			<a href="javascript:PopupManager('PURCHASER_ID')">
				<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0">
			</a>
			<a href="javascript:doRemove('purchaser_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
			<input type="text" name="purchaser_name" id="purchaser_name" size="20" class="input_data2" value=""  onkeydown='entKeyDown()'  readOnly>
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
		<table><tr>
			<td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
<%if(!"MUP110300005".equals(info.getSession("MENU_TYPE"))){ %>
<%-- 			<td><script language="javascript">btn("javascript:doCancelBidding()", "낙찰취소")</script></td> --%>
<%} %>
			<td><script language="javascript">btn("javascript:clipPrint()","출 력")		</script></td>
		</tr></table>
		</div>
      </td>
    </tr>
  </table> 
  </form>
<iframe name = "childFrame" src=""  width="0%" height="0" border=0 frameborder=0></iframe>  
<!---- END OF USER SOURCE CODE ----> 
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="BD_017" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html> 