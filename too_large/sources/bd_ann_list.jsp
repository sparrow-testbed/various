<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
    String  to_date     = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1);
    
	String HOUSE_CODE = info.getSession("HOUSE_CODE");
%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/rfq/ebd_bd_lis2.jsp -->
<!--
title_tdle:         e-bidding결과<p>
 Description:  e-bidding결과<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       csj<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!--> 
<% 
	String USER_NAME 	= info.getSession("NAME_LOC");
    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title>  <%-- 우리은행 전자구매시스템 --%>
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_ann_list";

function init() {
	setGridDraw();
	doSelect();
	printDate();
	/* 
	GridObj.setColumnHidden( GridObj.getColIndexById( "BID_STATUS" ), false );
	GridObj.setColumnHidden( GridObj.getColIndexById( "SIGN_STATUS" ), false);
	GridObj.setColumnHidden( GridObj.getColIndexById( "BID_TYPE" ), false );
	*/
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
	if( header_name == "ANN_NO")
    {
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());
        var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
        var bid_type = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());
        
//         var url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
        var url = "/sourcing/bd_ann_d_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
        
<%--         var url =  "<%=POASRM_CONTEXT_NAME%>/sourcing/bd_ann_detail.jsp";	 --%>
		
        if(bid_no != ""){
    		document.forms[0].BID_NO.value = bid_no;
    		document.forms[0].BID_COUNT.value = bid_count; 
    		
    		
    		document.forms[0].SCR_FLAG .value = "D"; 
    		
    		doOpenPopup(url,'1100','700');
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
        doSelect();
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

function doSelect() {
	
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdAnnList";
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
function Approval(pflag) {       // 확정= 'C'
    var SCR_FLAG;
    var url;

    var checked_count = 0; 
    var index_flag = 0;
 
    if(!checkRows()) return;
    
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
    //if(!checkUser()) return;

    checked_count = 0;

    for( var i = 0; i < grid_array.length; i++ ) {
        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
        var BID_STATUS      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
        var SIGN_STATUS  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue();
        var CHANGE_USER_ID  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue();
        var ANN_DATE  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_DATE")).getValue();
        var ann_version = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_VERSION")).getValue());
        var bid_type = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_TYPE")).getValue());
         
            checked_count++; 
            var front_STATUS  = BID_STATUS.substring(0, 1);
            var end_STATUS    = BID_STATUS.substring(1, 2);

            if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
                alert("처리할 권한이 없습니다.");
                return;
            }
 
            if(SIGN_STATUS == "C" && end_STATUS == "R") {                   // 확정
                if(end_STATUS == "R") {                   // 확정
                    if(front_STATUS == "A" || front_STATUS == "U") {
// 	                    url = "bd_ann.jsp?SCR_FLAG=C";  //입찰공고, 정정공고 확정
						url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=C&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
//						url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=U&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
// 	                    url = "bd_ann_to_be.jsp?SCR_FLAG=C";  //입찰공고, 정정공고 확정
                    } else if(front_STATUS == "C" ){
	                    url = "ebd_bd_ins2.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&SCR_FLAG=C&BID_STATUS="+BID_STATUS;  //취소공고 확정
        	        }

            		document.form.BID_NO.value 		= BID_NO;
            		document.form.BID_COUNT.value		= BID_COUNT;
            		document.form.BID_STATUS.value		= BID_STATUS; 
 
            		window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
            		document.form.method = "POST";
            		document.form.action = url;
            		document.form.target = "doBidding";
            		document.form.submit();
            		 
            	}else {
            		alert("이미 확정된 건입니다.");
                	return;
            	}
            } else {
                alert("'결재완료'된 입찰공고만 공고할 수 있습니다.");
            }
        
    }
}
//정정공고
function setAmendNoti() {
    var SCR_FLAG;
    var url;

    var checked_count = 0; 

    if(!checkRows()) return;
    
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
    //if(!checkUser()) return;

    checked_count = 0;

    for( var i = 0; i < grid_array.length; i++ ) {
        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
        var BID_STATUS      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
        var SIGN_STATUS  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue();
        var CHANGE_USER_ID  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue();
        var BDAP_CNT  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("BDAP_CNT")).getValue();
        var J_PERIOD_COND  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("J_PERIOD_COND")).getValue();
        var tmp_status = BID_STATUS.substring(1, 2);
        
        var ann_version = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_VERSION")).getValue());
        var bid_type = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_TYPE")).getValue());     

        var APP_BEGIN_DATE = new Number(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_BEGIN_DATE")).getValue().replaceAll("/","").replaceAll(":","").replaceAll(" ",""));
        var APP_END_DATE   = new Number(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_END_DATE"  )).getValue().replaceAll("/","").replaceAll(":","").replaceAll(" ",""));
        var NOW_DATE = new Number("<%=SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4)%>");
        
        
            checked_count++; 

            <% /* MUP150200001 내부 - 총무부장 , MUP210200001 내부 - 총무팀장 , MUP150400001 WFIS관리자 */
	        if( !"MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) && 
	     	    !"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")) &&
	     	    !"MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))	  ){ 
	     	%>
		     	if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
	                alert("처리할 권한이 없습니다.");
	                return;
	            }
	        <% } %>

            if(BID_STATUS == "CC") {
                alert("해당건은 취소공고건입니다.");
                return;
            }
			/*
            if(BID_STATUS == "UC") {
                alert("이미 공고된 정정공고건입니다.");
                return;
            }
			*/
			/*
            if(SIGN_STATUS != "C") {
                alert("확정건만 정정공고를 하실 수 있습니다.");
                return;
            }
			*/

            if(SIGN_STATUS+tmp_status != "CC") { // 결재완료된 건이면서, 확정된건.
                alert("공고건만 정정공고를 하실 수 있습니다.");
                return;
            }
/*
            if(BDAP_CNT != "Y") {
                alert("입찰참가신청 업체가 있는건은 정정공고를 하실 수 없습니다.");
                return;
            }

            if( "Y" == BDAP_CNT && "Y" == J_PERIOD_COND) {
*/            	
			if( "Y" == J_PERIOD_COND) {
                //url = "ebd_bd_ins1.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&SCR_FLAG=I&BID_STATUS=UR";  //정정공고 생성
//                 url = "bd_ann.jsp";  //정정공고 생성
                //url = "bd_ann_to_be.jsp";  //정정공고 생성
                url = "/sourcing/bd_ann_"+ann_version+".jsp?BID_STATUS=UR&SCR_FLAG=I&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
                if(NOW_DATE > APP_BEGIN_DATE && NOW_DATE < APP_END_DATE){
                	alert("입찰진행중에는 정정공고를 하실 수 없습니다.");
                	return;
                }
            }
            else  {
                alert("정정공고를 하실 수 없습니다.");
                return;
              } 
    }

    if(checked_count == 0) {
        alert("선택된 로우가 없습니다.");
        return;
    }

    if(checked_count > 1) {
        alert("한 건만 선택하실 수 있습니다.");
        return;
    }
	 
	document.form.BID_NO.value 		= BID_NO;
	document.form.BID_COUNT.value		= BID_COUNT;
	document.form.BID_STATUS.value		= "UR"; 
	document.form.SCR_FLAG.value = "I";

	window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "doBidding";
	document.form.submit();
}

function doDelete() {

    var SCR_FLAG;
    var url;

    var checked_count = 0; 

    if(!checkRows()) return;
    
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
    //if(!checkUser()) return;

    checked_count = 0;

    for( var i = 0; i < grid_array.length; i++ ) {
        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
        var BID_STATUS      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();         
        var CHANGE_USER_ID  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue();
        var end_STATUS    	= BID_STATUS.substring(1, 2);
        var SIGN_STATUS  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue();          
        
        checked_count++;
		
		<% /* MUP150200001 내부 - 총무부장 , MUP210200001 내부 - 총무팀장 , MUP150400001 WFIS관리자 */
	    if( !"MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) && 
	        !"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")) &&
	        !"MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))	  ){ 
	    %>
		    if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
				alert("처리할 권한이 없습니다.");
				return;
			}
	    <% } %>
		if(SIGN_STATUS == "J" && end_STATUS == "C"){ //결재회수
			
			
		}else{
			if(end_STATUS != "R" && end_STATUS != "J") {	// A(공고),U(정정공고),C(취소공고) + R (공고작성,결재중,결재완료) | +J (결재반려)
				alert("확정된 공고는 삭제할 수 없습니다.");
				return;
			}			
		}

		
    }
	
    if(checked_count == 0) {
        alert("선택된 로우가 없습니다.");
        return;
    }
	
	Message = "삭제 하시겠습니까?";
    var cols_ids = "<%=grid_col_id%>"; 
 
	if(confirm(Message) == 1) {

		document.form.BID_NO.value 		= BID_NO;
		document.form.BID_COUNT.value		= BID_COUNT;
        var params = "mode=setBdDelete";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput(); 
        myDataProcessor = new dataProcessor( G_SERVLETURL, params );
        sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
	}
}

function setModify() {
    var SCR_FLAG;
    var url;

    var checked_count = 0; 
    var index_flag = 0;

    if(!checkRows()) return;
    
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
    //if(!checkUser()) return;
 
    for( var i = 0; i < grid_array.length; i++ ) {
        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
        var BID_STATUS      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
        var SIGN_STATUS  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue();
        var CHANGE_USER_ID  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue();
        var ANN_DATE  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_DATE")).getValue();
        
        var ann_version = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_VERSION")).getValue());
        var bid_type = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_TYPE")).getValue());
             
        var front_STATUS    = BID_STATUS.substring(0, 1);
        var end_STATUS    = BID_STATUS.substring(1, 2);
            
            <% /* MUP150200001 내부 - 총무부장 , MUP210200001 내부 - 총무팀장 , MUP150400001 WFIS관리자 */
    	    if( !"MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) && 
    	        !"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")) &&
    	        !"MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))	  ){ 
    	    %>
	    	    if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
	                alert("처리할 권한이 없습니다.");
	                return;
	            }
    	    <% } %>
            if( "P" == SIGN_STATUS) {
                alert("결재중인 공고는 수정하실 수 없습니다.");
                return;
            } else if ( "C" == SIGN_STATUS) {
                alert("결재완료된 공고는 수정하실 수 없습니다.");
                return;
            }
            
            if( "J" == SIGN_STATUS || "C" == end_STATUS) { // 결재회수
            	alert("결재회수건은 공고삭제후 다시 입찰공고 작성하세요.");
                return;
            }      

            if( "T" == SIGN_STATUS || "B" == SIGN_STATUS) { // 수정 (어차피 결재반려건은 조회 안됨.)
                if(front_STATUS == "A" || front_STATUS == "U") {
//                     url = "bd_ann.jsp?SCR_FLAG=U";  //입찰공고, 정정공고 수정
					url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=U&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
//                     url = "bd_ann_to_be.jsp?SCR_FLAG=U";  //입찰공고, 정정공고 수정
                }else{
//                     url = "ebd_bd_ins2.jsp?SCR_FLAG=U";  //취소공고 수정
                    url = "ebd_bd_ins2.jsp?SCR_FLAG=U";  //취소공고 수정
                }
            }
            else if(SIGN_STATUS == "C" && end_STATUS == "R") {                   // 확정
                if(front_STATUS == "A" || front_STATUS == "U") {
//                     url = "bd_ann.jsp?SCR_FLAG=C";  //입찰공고, 정정공고 확정
//                     url = "bd_ann_to_be.jsp?SCR_FLAG=C";  //입찰공고, 정정공고 확정
                    url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=C&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
                } else {
                    url = "ebd_bd_ins2.jsp?SCR_FLAG=C";  //취소공고 확정
                }
            }
            else if( "J" == SIGN_STATUS || "C" == end_STATUS) { // 결재회수
                if(front_STATUS == "A" || front_STATUS == "U") {
					url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=U&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
                }else{
                    url = "ebd_bd_ins2.jsp?SCR_FLAG=U";  //취소공고 수정
                }
            }                       
            else  {                   // 확인(상세조회)
                if(front_STATUS == "A" || front_STATUS == "U") {
					url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
//                     url = "bd_ann.jsp?SCR_FLAG=D";  //입찰공고, 정정공고 상세조회
//                     url = "bd_ann_to_be.jsp?SCR_FLAG=D";  //입찰공고, 정정공고 상세조회
                } else {
                    url = "ebd_bd_dis2.jsp?SCR_FLAG=D";  //취소공고 상세조회
                }
            }

            if(BID_STATUS == "RC" || BID_STATUS == "SR" || BID_STATUS == "SC") { // 마감처리, 규격평가 건일 경우에는 아래의 로직의 예외사항...-> 확인 으로 보여준다.
//                 url = "bd_ann.jsp?SCR_FLAG=D";  //입찰공고, 정정공고 상세조회
//                 url = "bd_ann_to_be.jsp?SCR_FLAG=D";  //입찰공고, 정정공고 상세조회
				url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
            }
 
    }
 
	document.form.BID_NO.value 		= BID_NO;
	document.form.BID_COUNT.value		= BID_COUNT;
	document.form.BID_STATUS.value		= BID_STATUS;  

	window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "doBidding";
	document.form.submit(); 
}

function setCancelNoti() {
    var SCR_FLAG;
    var url;

    var checked_count = 0; 
    var index_flag = 0;

    if(!checkRows()) return;
    
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
    //if(!checkUser()) return;
 
    for( var i = 0; i < grid_array.length; i++ ) {
        checked_count++;
        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
        var BID_STATUS      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
        var SIGN_STATUS  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue();
        var CHANGE_USER_ID  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue();
        var BDAP_CNT  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("BDAP_CNT")).getValue();
        var C_PERIOD_COND  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("C_PERIOD_COND")).getValue(); 
        var tmp_status = BID_STATUS.substring(1, 2);

		<% /* MUP150200001 내부 - 총무부장 , MUP210200001 내부 - 총무팀장 , MUP150400001 WFIS관리자 */
	    if( !"MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) && 
	        !"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")) &&
	        !"MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))	  ){ 
	    %>
		    if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
				alert("처리할 권한이 없습니다.");
	            return;
			}
	    <% } %>
/*
         if(BID_STATUS == "UC") {
             alert("해당건은 정정공고건입니다.");
             return;
         }
*/
        //if(BID_STATUS == "AC") {
		//	alert("공고종료된 건은 취소할 수 없습니다.");
        //    return;
        //}

		if(BID_STATUS == "CC") {
			alert("이미 공고된 취소공고건입니다.");
            return;
        }
/*
         if(SIGN_STATUS != "C") {
             alert("확정건만 취소공고를 하실 수 있습니다.");
             return;
         }
*/
		if(SIGN_STATUS+tmp_status != "CC") { // 결재완료된 건이면서, 확정된건.
			alert("공고건만 취소공고를 하실 수 있습니다.");
            return;
        }
        
        if(BID_STATUS == "NB" || BID_STATUS == "SB") {
            alert("이미 개찰이 끝난건은 취소공고를 하실 수 없습니다.");
            return;
        } else {
            url = "bd_ann_cancel.jsp?SCR_FLAG=I&BID_STATUS=CR";  //취소공고 생성
        }
    }

    if(checked_count == 0) {
        alert("선택된 로우가 없습니다.");
        return;
    }

    if(checked_count > 1) {
        alert("한 건만 선택하실 수 있습니다.");
        return;
    }

	document.form.BID_NO.value 		= BID_NO;
	document.form.BID_COUNT.value		= BID_COUNT;
	document.form.BID_STATUS.value		= BID_STATUS;  

	window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=460,height=280,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "doBidding";
	document.form.submit(); 
}

function initAjax()
{ 
<%-- 		doRequestUsingPOST( 'SL0018', '<%=HOUSE_CODE%>'+'#M935' ,'STATUS', 'XX' ); --%>
}

// 지우기
function doRemove( type ){
    if( type == "CHANGE_USER" ) {
    	document.forms[0].CHANGE_USER.value = "";
        document.forms[0].CHANGE_USER_NAME.value = "";
    }  
}

//enter를 눌렀을때 event발생
function entKeyDown()
{
   if(event.keyCode==13) {
       window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
       doSelect();
   }
} 


function SP0023_Popup() {
	/*
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
	CodeSearchCommon(url,'doc','0','0','570','530');
	*/
<%-- 	PopupCommon2("SP0352","SP0352_getCode", "<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>", "담당자ID", "담당자명"); --%>
	window.open("/common/CO_008.jsp?callback=getChUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}

function getChUser(code, text) {
	document.forms[0].CHANGE_USER_NAME.value = text;
	document.forms[0].CHANGE_USER.value = code;
}

function SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
		document.forms[0].CHANGE_USER.value = USER_ID;
		document.forms[0].CHANGE_USER_NAME.value = USER_NAME_LOC;
}

function  SP0352_getCode(CTRL_NAME, CTRL_CODE, USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
	document.forms[0].CHANGE_USER.value = USER_ID;
	document.forms[0].CHANGE_USER_NAME.value = USER_NAME_LOC;
}

// 직무권한 체크
function checkUser() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;

		for(var row=0; row<GridObj.GetRowCount(); row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				for( i=0; i<ctrl_code.length; i++ )
			{
					if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)) {
						flag = true;
						break;
					} else
						flag = false;
				}
			}
		}

	if (!flag)
		alert("작업을 수행할 권한이 없습니다.");

		return flag;
	}
	
function doBdTm() {
	    var SCR_FLAG;
	    var url;

	    var checked_count = 0; 

	    if(!checkRows()) return;
	    
	    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	    var cols_ids = "<%=grid_col_id%>";
	    //if(!checkUser()) return;

	    checked_count = 0;

	    for( var i = 0; i < grid_array.length; i++ ) {
	        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
	        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
	        var VOTE_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue();
	        
	        var BID_STATUS      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
	        var SIGN_STATUS  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue();
	        var CHANGE_USER_ID  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue();
	        var BDAP_CNT  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("BDAP_CNT")).getValue();
	        var J_PERIOD_COND  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("J_PERIOD_COND")).getValue();
	        var tmp_status = BID_STATUS.substring(1, 2);
	        
	        var ann_version = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_VERSION")).getValue());
	        var bid_type = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_TYPE")).getValue());     

	        var APP_BEGIN_DATE = new Number(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_BEGIN_DATE")).getValue().replaceAll("/","").replaceAll(":","").replaceAll(" ",""));
	        var APP_END_DATE   = new Number(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_END_DATE"  )).getValue().replaceAll("/","").replaceAll(":","").replaceAll(" ",""));
	        var NOW_DATE = new Number("<%=SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4)%>");
	        
	        <% /* MUP150200001 내부 - 총무부장 , MUP210200001 내부 - 총무팀장 , MUP150400001 WFIS관리자 */
	        if( !"MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) && 
	     	    !"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")) &&
	     	    !"MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))	  ){ 
	     	%>
		        if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
		            alert("처리할 권한이 없습니다.");
		            return;
		        }
	        <% } %>
	        
	        if(BID_STATUS == "CC") {
	            alert("해당건은 취소공고건입니다.");
	            return;
	        }
	        
	        if(SIGN_STATUS+tmp_status != "CC") { // 결재완료된 건이면서, 확정된건.
                alert("공고건만 입찰시간을 변경 하실 수 있습니다.");
                return;
            }
	        
	        if(NOW_DATE >= APP_END_DATE){
            	alert("입찰종료건은 입찰시간을 변경 하실 수 없습니다.");
            	return;
            }
	        
	        checked_count++;  
	    }

	    if(checked_count == 0) {
	        alert("선택된 로우가 없습니다.");
	        return;
	    }

	    if(checked_count > 1) {
	        alert("한 건만 선택하실 수 있습니다.");
	        return;
	    }
		 
		document.form.BID_NO.value 		= BID_NO;
		document.form.BID_COUNT.value		= BID_COUNT;
		document.form.VOTE_COUNT.value		= VOTE_COUNT;
		document.form.BID_STATUS.value		= "UR"; 
		document.form.SCR_FLAG.value = "I";

		//var url = "ebd_pp_ins7.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT+"&TITLE=재입찰일시등록";
	    //window.open( url , "ebd_pp_ins7","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=300,left=0,top=0");
	    url =  "bd_ann_re2.jsp";
	    window.open( url , "doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=300,left=0,top=0");
	    document.forms[0].method = "POST";
		document.forms[0].action = url;
		document.forms[0].target = "doBidding";
		document.forms[0].submit();
	        
	   	//return;
}

</script>
</head>
<body onload="javascript:init();initAjax();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 
<form name="form" > 
	<input type="hidden" name="attach_gubun" value="body"> 
	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_count" value="">

	<input type="hidden" name="FROM_AMT" value="">
	<input type="hidden" name="TO_AMT" value="">

	<input type="hidden" name="BID_NO" id="BID_NO">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT">
	<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT">
	<input type="hidden" name="BID_STATUS" id="BID_STATUS">
	<input type="hidden" name="SCR_FLAG" id="SCR_FLAG">
	
    <input type="hidden"    name="PR_NO_SEQ"        id="PR_NO_SEQ"         value=""            />
    <input type="hidden"    name="PR_NUMBER"        id="PR_NUMBER"          value=""            />
    <input type="hidden"    name="PR_SEQ"           id="PR_SEQ"             value=""            />
    <input type="hidden"    name="PR_TYPE"          id="PR_TYPE"            value=""            /> 

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
        <td width="100%" valign="top">

            <table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>  
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        공고일자
      </td>
      <td width="35%" class="data_td">
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
          
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
      <td width="35%" class="data_td">
        <select name="STATUS" id="STATUS" class="inputsubmit">
          <option value="">전체</option>  
        <%
			String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M935", "XX");
			out.println(com1);          
        %>  
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
        <input type="text" name="ann_no" id="ann_no" size="20" style="ime-mode:inactive" maxlength="20" class="inputsubmit" onkeydown='entKeyDown()'>
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰건명</td>
      <td class="data_td">
        <input type="text" name="ann_item" id="ann_item" style="ime-mode:active;width:95%" maxlength="100" class="inputsubmit" onkeydown='entKeyDown()'>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        입찰구분
      </td>
      <td class="data_td">
        <select id="BID_TYPE" name="BID_TYPE">
        	<option value="">전체</option>
        	<option value="D">구매입찰</option>
        	<option value="C">공사입찰</option>
        </select>			
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰담당자</td>
      <td class="data_td">
        <input type="text" name="CHANGE_USER" id="CHANGE_USER" size="20" maxlength="10" class="inputsubmit" value='<%=(!"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")))?info.getSession("ID"):""%>' onBlur="javascript: param1 = form.CHANGE_USER.value; get_Wisedesc('SP0255', 'form', this, 'CHANGE_USER_NAME','values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values='+param1+'&values=','1');" onkeydown='entKeyDown()'>
		<a href="javascript:SP0023_Popup()">
			<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
		</a>
        <a href="javascript:doRemove('CHANGE_USER')"><img src="../images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" name="CHANGE_USER_NAME" id="CHANGE_USER_NAME" size="20" readonly value='<%=(!"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")))?info.getSession("NAME_LOC"):""%>' onkeydown='entKeyDown()' >
      </td> 
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        현재시간
      </td>
      <td class="data_td" colspan="3">
        			<div id="id1"></div>
			        <input type="hidden" name="h_server_date" class="input_empty" size="50" readonly> 
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
						<td><script language="javascript">btn("javascript:doSelect()"		, "조 회")	</script></td>
<%-- 						<td><script language="javascript">btn("javascript:Approval('C')"	, "입찰공고")</script></td> --%>
						<td><script language="javascript">btn("javascript:setModify()"		, "공고수정")</script></td>
						<td><script language="javascript">btn("javascript:setAmendNoti()"	, "정정공고")</script></td>
						<td><script language="javascript">btn("javascript:setCancelNoti()"	, "취소공고")</script></td>
						<td><script language="javascript">btn("javascript:doDelete()"		, "공고삭제")</script></td>
						<td><script language="javascript">btn("javascript:doBdTm()", "입찰시간변경")</script></td>
					</tr>
				</table>
			</div>
      	</td>
    </tr>
</table>
</td>
</tr>
</table>
</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="BD_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe> 