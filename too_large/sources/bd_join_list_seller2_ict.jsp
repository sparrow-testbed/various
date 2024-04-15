<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SBD_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SBD_008";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) );
    String  to_date     = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1) );

    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
%> 
<!--
title_tdle:         가격입찰  <p>
 Description:  가격입찰<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!--> 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>  

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)--> 
<script language="javascript">
<!--
    var mode;
 
    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
       	    server_time = GD_GetParam(GridObj,0);

       	    clock("s");
	    } else if(msg1 == "doData") {

	    } else if(msg1 == "t_imagetext") { //공고번호 click

            ANN_NO              = GD_GetCellValueIndex(GridObj,msg2, INDEX_ANN_NO);
            ANN_COUNT           = GD_GetCellValueIndex(GridObj,msg2, INDEX_ANN_COUNT);
            ANN_STATUS          = GD_GetCellValueIndex(GridObj,msg2, INDEX_ANN_STATUS);
            BID                 = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID);
            PARTICIPATE_FLAG    = GD_GetCellValueIndex(GridObj,msg2, INDEX_PARTICIPATE_FLAG);
            VOTE_FLAG           = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_FLAG);
            FINAL_FLAG          = GD_GetCellValueIndex(GridObj,msg2, INDEX_FINAL_FLAG);
            SPEC_FLAG           = GD_GetCellValueIndex(GridObj,msg2, INDEX_SPEC_FLAG);
            BID_CANCEL          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_CANCEL);
            CONT_TYPE2          = GD_GetCellValueIndex(GridObj,msg2, INDEX_CONT_TYPE2);

            VOTE_COUNT          = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_COUNT);

            var front_status = ANN_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?ANN_NO='+ANN_NO+'&ANN_COUNT='+ANN_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?ANN_NO='+ANN_NO+'&ANN_COUNT='+ANN_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_ATTACH_VIEW) {
                var ATTACH_VIEW_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_VIEW));

                if("" != ATTACH_VIEW_VALUE) {
                    rMateFileAttach('P','R','BD',ATTACH_VIEW_VALUE);
                }
            } else if(msg3 == INDEX_BID) {
                var ENABLE_YN = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ENABLE_YN));
                var ANNOUNCE_FLAG = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE_FLAG));
                var ANNOUNCE_YN = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE_YN));

				if(ENABLE_YN == "N") {
                    alert("제재기간중이므로 입찰에 참가할 수 없습니다.");
                    return;
                }
                if(BID == "F") {
                    alert("아직 진행중인 건이 아닙니다.");
                    return;
                }
                if(BID == "C") {
                    alert("이미 종료된 건입니다.");
                    return;
                }
                if(BID_CANCEL == "Y"){
                    alert("입찰 취소하신 건입니다.");
                    return;
                }
                if(VOTE_FLAG != "0") {
                    alert("이미 제출을 하신 건입니다.");
                    return;
                }
				if(FINAL_FLAG == "N") {
					alert("적합업체로 선정되지 못한 업체는 가격입찰을 하실수 없습니다.");
					return;
				}
                if(CONT_TYPE2 != "LP") {
                	if(PARTICIPATE_FLAG == "0"){
						alert("참가신청을 하지 않거나 입찰 취소하신 건입니다.");
						return;
					}
                    if(SPEC_FLAG != "Y") {
                        alert("1차평가에서 부적합업체로 선정되어 가격입찰을 하실수 없습니다.");
                        return;
                    }
					if(ANN_STATUS == "RC" || ANN_STATUS == "SC" || ANN_STATUS == "QC") {
					} else {
						alert("아직 마감되지 않은 건입니다.");
						return;
					}
                }
                if(ANNOUNCE_FLAG == "Y"){
                	if(ANNOUNCE_YN == "N"){
	                	alert("제안설명회 미참석 업체는 신청하실 수 없습니다.");
	                    return;
                	}
                }
                location.href="ebd_pp_ins1.jsp?ANN_NO="+ANN_NO+"&ANN_COUNT="+ANN_COUNT+"&VOTE_COUNT="+VOTE_COUNT;
            }
        }
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

var button_flag = false;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_price_list_seller2_ict";

function init() {
	setGridDraw(); 
    doQuery();
	printDate();
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
        var ann_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_NO")).getValue());   
        var ann_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_COUNT")).getValue());      
        var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());      
        
        
<%--         var url =  "<%=POASRM_CONTEXT_NAME%>/sourcing/bd_ann_detail.jsp";	 --%>
        var url =  "<%=POASRM_CONTEXT_NAME%>/ict/sourcing/bd_ann_d2_ict_"+ann_version+".jsp?SCR_FLAG=D&ANN_STATUS=AR&ANN_VERSION="+ ann_version+"&VIEW_KIND=SUPPLY";
		
		document.forms[0].ANN_NO.value = ann_no;
		document.forms[0].ANN_COUNT.value = ann_count; 
		document.forms[0].ANN_VERSION.value = ann_version; 
		document.forms[0].SCR_FLAG.value = "D"; 
		
		doOpenPopup(url,'1100','700');
    }
	if(GridObj.getColIndexById("ATTACH_NO") == cellInd){
   	 	var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO_H")).getValue();
   	    //var attach_cnt = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_CNT")).getValue();
   	 	//alert(attach_cnt)
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
	
	var header_name = GridObj.getColumnId(cellInd);
	
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
    	if( header_name == "FINAL_FLAG" ) {
        	return false;
    	}
		  return true;
    } else if(stage==1) {
    	if( header_name == "FINAL_FLAG" ) {
        	return false;
    	}

    } else if(stage==2) {
    	if( header_name == "FINAL_FLAG" ) {
        	return false;
    	}

    	
    
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
    var params = "mode=getBdJoinList";
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

function doBidJoin() { 
    var chkcnt = 0;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>"; 

    for( var i = 0; i < grid_array.length; i++ ) {
            chkcnt++; 
			
            ANN_NO              = GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_NO")).getValue();
            ANN_COUNT           = GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_COUNT")).getValue();
            ANN_STATUS          = GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_STATUS")).getValue();
            BID                 = GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue();
            FINAL_FLAG          = GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_FLAG")).getValue();
            JOIN_FLAG 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("JOIN_FLAG")).getValue());   
            X_DOC_SUBMIT_DATE_TIME = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("X_DOC_SUBMIT_DATE_TIME")).getValue());  
	} // for문끝
	if(chkcnt == 0){
	    alert(G_MSS1_SELECT);
	    return;
	}
	if(chkcnt != 1){
	    alert(G_MSS2_SELECT);
	    return;
	}
	
// 	if(JOIN_FLAG != "0"){
//         alert("이미 참가신청서를 제출하신 건입니다.");
//         return;
// 	}

// 	alert(X_DOC_SUBMIT_DATE_TIME.toString().replaceAll("/","").replaceAll(":","").replaceAll(" ","") +"00" + "\n" + $("#h_server_date").val());
// 	return;
	
    var x_doc_time = X_DOC_SUBMIT_DATE_TIME.toString().replaceAll("/","").replaceAll(":","").replaceAll(" ","") +"00";
    var server_time = $("#h_server_date").val();
	
    /*
    if(Number(server_time) > Number(x_doc_time)){
		alert("입찰서류 제출기한이 만료되었습니다.")	;
		return;
	}
    */
    
    if(ANN_STATUS != "AC" && ANN_STATUS != "UC"){
    	alert("현진행상태는 참가신청이 불가합니다.");
    	return;
    }
  	
// 	if(ENABLE_YN == "N") {
//         alert("제재기간중이므로 입찰에 참가할 수 없습니다.");
//         return;
//     }
//     if(BID == "F") {
//         alert("아직 진행중인 건이 아닙니다.");
//         return;
//     }
//     if(BID == "C") {
//         alert("이미 종료된 건입니다.");
//         return;
//     }
//     if(BID_CANCEL == "Y"){
//         alert("입찰 취소하신 건입니다.");
//         return;
//     }
//     if(VOTE_FLAG != "0") {
//         alert("이미 입찰서를 제출하신 건입니다.");
//         return;
//     }
// 	if(FINAL_FLAG == "N") {
// 		alert("적합업체로 선정되지 못한 업체는 가격입찰을 하실수 없습니다.");
// 		return;
// 	}
// 	// 총액 입찰이 아닌 경우에는 참가신청 후 합격을 해야한다.
//     if(CONT_TYPE2 != "LP") {
//     	if(PARTICIPATE_FLAG == "0"){
// 			alert("참가신청을 하지 않거나 입찰 취소하신 건입니다.");
// 			return;
// 		}
//         if(SPEC_FLAG != "Y") {
//             alert("평가에서 부적합 업체로 선정되어 가격입찰을 하실수 없습니다.");
//             return;
//         }
//         //가격입찰, 2단계가격입찰, 적격심사가격입찰
// 		if(ANN_STATUS == "RC" || ANN_STATUS == "SC" || ANN_STATUS == "QC") {
// 		} else {
// 			alert("아직 마감되지 않은 건입니다.");
// 			return;
// 		}
//     }
//     if(ANNOUNCE_FLAG == "Y" && ANNOUNCE_YN == "N") {
//        	alert("제안설명회 미참석 업체는 입찰에 참여하실 수 없습니다.");
// 		return;
//     }
    //location.href="ebd_pp_ins1.jsp?ANN_NO="+ANN_NO+"&ANN_COUNT="+ANN_COUNT+"&VOTE_COUNT="+VOTE_COUNT;

	var f = document.forms[0];
	f.ANN_NO.value            = ANN_NO;
	f.ANN_COUNT.value		   = ANN_COUNT; 
	f.target                   = "_self"; 
	f.method                   = "post";   
	f.action = "bd_join_seller2_insert_ict.jsp";
	f.submit();
}

function doBidJoinCancel() { 
	if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }
	
    var chkcnt = 0;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>"; 

    for( var i = 0; i < grid_array.length; i++ ) {
            chkcnt++; 
			
            ANN_NO              = GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_NO")).getValue();
            ANN_COUNT           = GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_COUNT")).getValue();
            ANN_STATUS          = GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_STATUS")).getValue();
            BID                 = GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue();
            FINAL_FLAG          = GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_FLAG")).getValue();
            JOIN_FLAG 	        = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("JOIN_FLAG")).getValue());   
            X_DOC_SUBMIT_DATE_TIME = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("X_DOC_SUBMIT_DATE_TIME")).getValue());
            INP_CNF_TXT         = GridObj.cells(grid_array[i], GridObj.getColIndexById("INP_CNF_TXT")).getValue();
	} // for문끝
	if(chkcnt == 0){
	    alert(G_MSS1_SELECT);
	    return;
	}
	if(chkcnt != 1){
	    alert(G_MSS2_SELECT);
	    return;
	}
// 	if(JOIN_FLAG != "0"){
//         alert("이미 참가신청서를 제출하신 건입니다.");
//         return;
// 	}

// 	alert(X_DOC_SUBMIT_DATE_TIME.toString().replaceAll("/","").replaceAll(":","").replaceAll(" ","") +"00" + "\n" + $("#h_server_date").val());
// 	return;
	
    var x_doc_time = X_DOC_SUBMIT_DATE_TIME.toString().replaceAll("/","").replaceAll(":","").replaceAll(" ","") +"00";
    var server_time = $("#h_server_date").val();
	
    /*
    if(Number(server_time) > Number(x_doc_time)){
		alert("입찰서류 제출기한이 만료되었습니다.")	;
		return;
	}
    */
    
    
    if(INP_CNF_TXT == "미참가"){
		alert("참가신청건에 한정하여 참가신청취소가 가능합니다.");
	    return;	
	}
    
    if(INP_CNF_TXT == "접수"){
		alert("서류접수 되어 참가신청취소가 불가합니다.");
	    return;	
	}
    
 	if(ANN_STATUS != "AC" && ANN_STATUS != "UC" && ANN_STATUS != "CC"){
    	alert("현진행상태는 참가신청취소가 불가합니다.");
    	return;
    }
	
// 	if(ENABLE_YN == "N") {
//         alert("제재기간중이므로 입찰에 참가할 수 없습니다.");
//         return;
//     }
//     if(BID == "F") {
//         alert("아직 진행중인 건이 아닙니다.");
//         return;
//     }
//     if(BID == "C") {
//         alert("이미 종료된 건입니다.");
//         return;
//     }
//     if(BID_CANCEL == "Y"){
//         alert("입찰 취소하신 건입니다.");
//         return;
//     }
//     if(VOTE_FLAG != "0") {
//         alert("이미 입찰서를 제출하신 건입니다.");
//         return;
//     }
// 	if(FINAL_FLAG == "N") {
// 		alert("적합업체로 선정되지 못한 업체는 가격입찰을 하실수 없습니다.");
// 		return;
// 	}
// 	// 총액 입찰이 아닌 경우에는 참가신청 후 합격을 해야한다.
//     if(CONT_TYPE2 != "LP") {
//     	if(PARTICIPATE_FLAG == "0"){
// 			alert("참가신청을 하지 않거나 입찰 취소하신 건입니다.");
// 			return;
// 		}
//         if(SPEC_FLAG != "Y") {
//             alert("평가에서 부적합 업체로 선정되어 가격입찰을 하실수 없습니다.");
//             return;
//         }
//         //가격입찰, 2단계가격입찰, 적격심사가격입찰
// 		if(ANN_STATUS == "RC" || ANN_STATUS == "SC" || ANN_STATUS == "QC") {
// 		} else {
// 			alert("아직 마감되지 않은 건입니다.");
// 			return;
// 		}
//     }
//     if(ANNOUNCE_FLAG == "Y" && ANNOUNCE_YN == "N") {
//        	alert("제안설명회 미참석 업체는 입찰에 참여하실 수 없습니다.");
// 		return;
//     }
    //location.href="ebd_pp_ins1.jsp?ANN_NO="+ANN_NO+"&ANN_COUNT="+ANN_COUNT+"&VOTE_COUNT="+VOTE_COUNT;

 	var Message = "참가신청취소를 하시겠습니까?";
    if(confirm(Message) != 1){
        button_flag = false;
        return;
    }else{

        button_flag = true;

    }
    
    $.post(
    	G_SERVLETURL,
    	{
    		ann_no      	: ANN_NO,
    		ann_count      	: ANN_COUNT,
    		mode            : "setBDAPjoinCancel"
    	},
    	function(arg){
    		var result = arg.split("|");
    		
    		if(result[1] == "true"){
    			button_flag = false;
    			alert(result[0]);
    			doQuery();
    		}
    		
    		if(result[1] == "false"){
    			button_flag = false;
    			alert(result[0]);
    		}
    	}
    );        
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
 
<form name="form" >
	<input type="hidden" name="ctrl_code" id="ctrl_code" value=""> 
	<input type="hidden" name="att_mode"  id="att_mode"  value="">
	<input type="hidden" name="view_type"  id="view_type"  value="">
	<input type="hidden" name="file_type"  id="file_type"value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no"value="">

	<input type="hidden" name="ANN_NO" id="ANN_NO" value="">
	<input type="hidden" name="ANN_VERSION" id="ANN_VERSION" value="">
	<input type="hidden" name="ANN_COUNT" id="ANN_COUNT" value="">
	<input type="hidden" name="SCR_FLAG" >

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
                <table width="100%" class="board-search"border="0" cellpadding="0" cellspacing="0">
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
      <td width="35%" class="data_td" colspan="3"> 
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        				id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
         
	  </td> 
      <td width="15%" class="title_td" style="display:none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
      <td width="35%" class="data_td" style="display:none;">
        <select name="bid_flag" id="bid_flag" class="inputsubmit">
          <option value="">전체</option>
          <option value="P">입찰진행중</option>
          <option value="F">입찰대기</option>
          <option value="C">입찰종료</option>
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
      <td width="35%" class="data_td">
        <input type="text" name="ann_no" id="ann_no" style="ime-mode:inactive" size="20" maxlength="20" class="inputsubmit">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        공고명
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="ann_item" id="ann_item" style="width:95%" class="inputsubmit">
      </td>
    </tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        현재시간
      </td>
      <td width="35%" colspan="3" class="data_td">
        			<div id="id1"></div>
			        <input type="hidden" id="h_server_date" name="h_server_date" class="input_empty" size="50" readonly> 
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
          <td><script language="javascript">btn("javascript:doBidJoin()", "참가신청")</script></td>
          <td><script language="javascript">btn("javascript:doBidJoinCancel()", "참가신청취소")</script></td>
		  </tr></table>  
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
<%-- <s:grid screen_id="SBD006" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


