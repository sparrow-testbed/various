<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_029");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_029";
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
 title_tdle:   견적서제출확인   <p>
 Description:  견적서제출확인<p>
 Copyright:    Copyright (c) <p>
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

	    } else if(msg1 == "t_imagetext") { //공문번호 click

            BID_NO              = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT           = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            BID_STATUS          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);
            BID                 = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID);
            PARTICIPATE_FLAG    = GD_GetCellValueIndex(GridObj,msg2, INDEX_PARTICIPATE_FLAG);
            VOTE_FLAG           = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_FLAG);
            FINAL_FLAG          = GD_GetCellValueIndex(GridObj,msg2, INDEX_FINAL_FLAG);
            SPEC_FLAG           = GD_GetCellValueIndex(GridObj,msg2, INDEX_SPEC_FLAG);
            BID_CANCEL          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_CANCEL);
            CONT_TYPE2          = GD_GetCellValueIndex(GridObj,msg2, INDEX_CONT_TYPE2);

            VOTE_COUNT          = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_COUNT);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공문, 정정공문
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
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
					if(BID_STATUS == "RC" || BID_STATUS == "SC" || BID_STATUS == "QC") {
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
                location.href="ebd_pp_ins1.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_ct_confirm_ict2";

function init() {
	setGridDraw(); 
    doQuery();
}

function setGridDraw()
{
	GridObj_setGridDraw();
	GridObj.setSizes();
}

//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;	
}


var click_rowId = null;
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{ 
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
    click_rowId = rowId;
    if( header_name == "ANN_NO")
    {
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());      
        var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());      
        var bid_type    = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());
        var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());     
        
        if( vote_count != ""){
	        var url =  "<%=POASRM_CONTEXT_NAME%>/ict/sourcing/bd_ann_d_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version+"&VIEW_KIND=SUPPLY";
			
			document.forms[0].BID_NO.value = bid_no;
			document.forms[0].BID_COUNT.value = bid_count; 
			document.forms[0].ANN_VERSION.value = ann_version; 
			document.forms[0].SCR_FLAG.value = "D"; 
			
			doOpenPopup(url,'1100','700');
        }
    }
	if(header_name == "ANN_ITEM"){
    	
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());     
        var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());     
        //url =  "bd_open_compare_pop_ict.jsp?BID_NO="+bid_no+"&BID_COUNT="+bid_count+"&VOTE_COUNT="+vote_count;
        //doOpenPopup(url,'1100','700');
        if( vote_count != ""){
        	var url    = '/ict/sourcing/bd_open_compare_pop_ict.jsp';
    		var title  = '개찰결과';
    		var param  = 'popup=Y';
    		param     += '&BID_NO=' + bid_no;
    		param     += '&BID_COUNT=' + bid_count;
    		param     += '&VOTE_COUNT=' + vote_count;
    		popUpOpen01(url, title, '1100', '700', param);   
        }               
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
	if(header_name == "VENDOR_CODE" || header_name == "VENDOR_NAME") {
    	
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/ict/s_kr/admin/info/ven_bd_con_ict.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
    }
	
	if(header_name == "BIZ") {
		var biz_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BIZ_NO")).getValue());   
	    var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
	    var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());    
	    
		if(vote_count == ""){
			var url  = '';
			var title  = '';
			var param  = '';
			//window.open("/common/CO_008_ict.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");		
			url    = '/ict/kr/dt/rfq/rfq_bzNo_pop_main.jsp?flag=1';
			title  = '사업번호조회';
		    param  = 'popup=Y';
			//param  += '&callback=getVendorCode';
			popUpOpen01(url, title, '450', '550', param);
		}
	}	
	
	if(header_name == "VENDOR") {
		var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
		var vendor_code = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VENDOR_CODE")).getValue());   
		var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());    
		
		if(bid_no == "" && vote_count == ""){
			var url  = '';
			var title  = '';
			var param  = '';
			//window.open("/common/CO_008_ict.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");		
			url    = '/common/CO_014_ict.jsp';
			title  = '계약업체조회';
		    param  = 'popup=Y';
			param  += '&callback=getVendorCode';
			popUpOpen01(url, title, '450', '550', param);
		}
	}	
}

function  setBIZNO(biz_no, biz_nm) {
	var bid_no = LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("BID_NO")).getValue());
	var vote_count = LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());     
	if( bid_no != "" && vote_count == ""){
		GridObj.cells(click_rowId, GridObj.getColIndexById("CRUD")).setValue("U");
	}
	GridObj.cells(click_rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells(click_rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(click_rowId, GridObj.getColIndexById("BIZ_NO")).setValue(biz_no);
	GridObj.cells(click_rowId, GridObj.getColIndexById("BIZ_NM")).setValue(biz_nm);
}	

function getVendorCode(code, text) {
	var bid_no = LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("BID_NO")).getValue()); 
	var vote_count = LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());     
	if( bid_no != ""  && vote_count == ""){
		GridObj.cells(click_rowId, GridObj.getColIndexById("CRUD")).setValue("U");
	}
	GridObj.cells(click_rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells(click_rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(click_rowId, GridObj.getColIndexById("VENDOR_CODE")).setValue(code);
	GridObj.cells(click_rowId, GridObj.getColIndexById("VENDOR_NAME")).setValue(text);
	
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
	
	var header_name = GridObj.getColumnId(cellInd);
	
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());     
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
    	if(vote_count == ""){
    		if( header_name == "HD_GB" || header_name == "ANN_NO" || header_name == "ANN_ITEM"  || header_name == "SETTLE_AMT") {
            	return true;
        	}
    	}
    	if(header_name == "SELECTED" || header_name == "CONFIRM_FLAG" || header_name == "NFIT_RSN" ) {
        	return true;
    	}
    } else if(stage==1) {
    	if(vote_count == ""){
    		if( header_name == "HD_GB" || header_name == "ANN_NO" || header_name == "ANN_ITEM"  || header_name == "SETTLE_AMT") {
            	return true;
        	}
    	}
    	if(header_name == "SELECTED" || header_name == "CONFIRM_FLAG" || header_name == "NFIT_RSN" ) {
        	return true;
    	}	
    } else if(stage==2) {
    	if(vote_count == ""){
    		if( header_name == "HD_GB" || header_name == "ANN_NO" || header_name == "ANN_ITEM"  || header_name == "SETTLE_AMT") {
            	return true;
        	}
    	}
    	if(header_name == "SELECTED" || header_name == "CONFIRM_FLAG" || header_name == "NFIT_RSN" ) {
        	return true;
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
    var params = "mode=getBdCt2ConfirmList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
    click_rowId = null;
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

function doCt2Confirm() { 
    var chkcnt = 0;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>"; 

    for( var i = 0; i < grid_array.length; i++ ) {
            chkcnt++; 
			
            BID_NO              = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
            BID_COUNT           = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
            VOTE_COUNT          = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue();
            CONFIRM_FLAG        = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONFIRM_FLAG")).getValue();
            CONFIRM_FLAG_H      = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONFIRM_FLAG_H")).getValue();
            ATTACH_NO_H         = GridObj.cells(grid_array[i], GridObj.getColIndexById("ATTACH_NO_H")).getValue();
            
            if(ATTACH_NO_H == ""){
          		alert("계약서류가 제출되지 않아 확인 불가합니다.");
          		return;
        	}
            
            if(CONFIRM_FLAG == ""){
          		alert("확인결과를 선택하세요.");
          		return;
        	}
            
	} // for문끝
	if(chkcnt == 0){
	    alert(G_MSS1_SELECT);
	    return;
	}
	
 	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	var rowcount = grid_array.length;
 
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=setBdCt2Confirm";
    
    var Message = "확인 하시겠습니까?";
    if(confirm(Message) != 1){
        return;
    }else{
    	params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        myDataProcessor = new dataProcessor( G_SERVLETURL, params ); 
        sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );  
    } 
}
<%--
//행추가 이벤트 입니다.
function doAddRow()
{
	dhtmlx_last_row_id++;
	var nMaxRow2 = dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRUD")).setValue("C");
	SepoaGridSetCellValueId(GridObj, nMaxRow2, "BIZ", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
    SepoaGridSetCellValueId(GridObj, nMaxRow2, "VENDOR", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
    
    dhtmlx_before_row_id = nMaxRow2;
}

//행삭제시 호출 되는 함수 입니다.
function doDeleteRow()
{
	if(!checkRows())return;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("1" == GridObj.cells(grid_array[row], 0).getValue() && "C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CRUD")).getValue())
		{
			GridObj.deleteRow(grid_array[row]);
    	}
    }
	
	click_rowId = null;
}

function doSaveHNDG()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
	{
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("HD_GB")).getValue()))
		{
			alert("구분을 선택하세요.");
			return;
		}
		
		var vote_count = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue());  
		if("" == vote_count)
		{
			if("B" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("HD_GB")).getValue()))
			{
				alert("입찰 선택은 불가합니다.");
				return;
			}
		}else{
			alert("입찰건은 수기 저장이 불가 합니다.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BIZ_NO")).getValue()))
		{
			alert("사업명을 지정하세요.");
			return;
		}
				
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_NO")).getValue()))
		{
			alert("공문번호를 입력하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANN_ITEM")).getValue()))
		{
			alert("입찰명을 입력하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("VENDOR_CODE")).getValue()))
		{
			alert("계약업체를 지정하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SETTLE_AMT")).getValue()))
		{
			alert("낙찰금액을 입력하세요.");
			return;
		}
	}

    if (confirm("저장 하시겠습니까?")) {
        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
        var cols_ids = "<%=grid_col_id%>";
        
        var params;
    	params = "?mode=saveHndgList";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
	    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	    
	    click_rowId = null;
    }
}

function doDeleteHNDG()
{
	if(!checkRows())return;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);
	
	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CRUD")).getValue())
		{
			alert("행삭제를 하세요.");
			return;
    	}
		
		if("" != GridObj.cells(grid_array[row], GridObj.getColIndexById("VOTE_COUNT")).getValue())
		{
			alert("삭제(수기) 대상이 아닙니다.");
			return;
    	}
    }
	
	if(rowcount > 1)  {
		alert(G_MSS2_SELECT);		
		return;
	}
	
    
   	if (confirm("삭제하시겠습니까?")){
   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
	    var cols_ids = "<%=grid_col_id%>";
        
        var params;
    	params = "?mode=deleteHndgList";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		 
		click_rowId = null;		
   }
}
--%>



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

	<input type="hidden" name="BID_NO" id="BID_NO" value="">
	<input type="hidden" name="ANN_VERSION" id="ANN_VERSION" value="">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="">
	<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT" value="">
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
        입찰일자 / 계약생성일자
      </td>
      <td width="35%" class="data_td" colspan="3"> 
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        				id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
         
	  </td> 
    </tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        공문번호
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="ann_no" id="ann_no" style="ime-mode:inactive" size="20" maxlength="20" class="inputsubmit">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        입찰(계약)명
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="ann_item" id="ann_item" style="width:95%" class="inputsubmit">
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
      <%--
      <td height="30">
        <div align="left">
        <table><tr>
          <td><script language="javascript">btn("javascript:doAddRow()","행삽입")</script></td>
		  <td><script language="javascript">btn("javascript:doDeleteRow()","행삭제")</script></td>
		  <td><script language="javascript">btn("javascript:doSaveHNDG()","저장(수기)")</script></td>
		  <td><script language="javascript">btn("javascript:doDeleteHNDG()","삭제(수기)")</script></td>
		  </tr></table>  
        </div>
      </td>
      --%>      
      <td height="30">
        <div align="right">
        <table><tr>
          <td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
          <td><script language="javascript">btn("javascript:doCt2Confirm()", "확 인")</script></td>
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


