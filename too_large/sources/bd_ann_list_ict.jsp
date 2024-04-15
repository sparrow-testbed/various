<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
    String  to_date     = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1);
    
	String HOUSE_CODE = info.getSession("HOUSE_CODE");


	String ANN_VERSION = "";
	
	Object[] obj = new Object[1]; 
	
	SepoaOut value = ServiceConnector.doService(info, "I_BD_002", "CONNECTION","getBdAnnVersion", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	if(wf.getRowCount() > 0) {
		ANN_VERSION = wf.getValue("CODE", 0);
	}

%>

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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_ann_list_ict";

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
	var gg = getGridSelectedRows(GridObj, "SELECTED");
	if(gg !=0){
		
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			//GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
		}
	}
	
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;	

	var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	if( header_name == "ANN_NO")
    {
		var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());
        var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
        var bid_type = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());
        
        var url = "/ict/sourcing/bd_ann_d_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
        
        if(bid_no != ""){
    		document.forms[0].BID_NO.value = bid_no;
    		document.forms[0].BID_COUNT.value = bid_count; 
    		
    		
    		document.forms[0].SCR_FLAG .value = "D"; 
    		
    		doOpenPopup(url,'1100','800');
        }
    }else if( header_name == "ANN_NO2"){
		var ann_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_NO2")).getValue());   
        var ann_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_COUNT2")).getValue());
        var ann_version = "001";
        
        var url = "/ict/sourcing/bd_ann_d2_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&&ANN_VERSION="+ ann_version;
        
        if(ann_no != ""){
    		document.forms[0].ANN_NO.value = ann_no;
    		document.forms[0].ANN_COUNT.value = ann_count; 
    		
    		
    		document.forms[0].SCR_FLAG .value = "D"; 
    		
    		doOpenPopup(url,'1100','600');
        }
    }else if( header_name == "CHANGE_USER_NAME"){
    	var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());
        
        var url = "/common/CO_021_ict.jsp";
        
        if(bid_no != ""){
        	document.forms[0].DOC_NO.value = bid_no;
    		document.forms[0].DOC_SEQ.value = bid_count; 
    		
    		doOpenPopup(url,'660','450');
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
        return true;
    } else if(stage==1) {
    	if( header_name == "SELECTED" ) {
    		var gg = getGridSelectedRows(GridObj, "SELECTED");
    		if(gg !=0){
    			
    			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
    			{
    				//GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
    			}
    		}
    		
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	row_id = rowId;
	    	return true;
    	}
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
						url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=C&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
                    } else if(front_STATUS == "C" ){
	                    url = "ebd_bd_ins2.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&SCR_FLAG=C&BID_STATUS="+BID_STATUS;  //취소공문 확정
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
                alert("'결재완료'된 입찰공문만 공문할 수 있습니다.");
            }
        
    }
}

//정정공문
function setAmendNoti() {
	//alert("준비중입니다.");
	//return;
		
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

        // bid_begin_date
        var APP_BEGIN_DATE = new Number(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_BEGIN_DATE")).getValue().replaceAll("/","").replaceAll(":","").replaceAll(" ",""));
        // bid_end_date
        var APP_END_DATE   = new Number(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_END_DATE"  )).getValue().replaceAll("/","").replaceAll(":","").replaceAll(" ",""));
        var NOW_DATE = new Number("<%=SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4)%>");
        
        
            checked_count++;

            // 정정공문 가능 상황
            // 공문가 시작되고, 입찰이 시작되지 않은상태
            // 투찰한 업체가 없는 경우
            
            if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
                alert("처리할 권한이 없습니다.");
                return;
            }

            //if(BID_STATUS == "CC") {
            if(BID_STATUS == "CC") {
                alert("해당건은 취소공문건입니다.");
                return;
            }

            if(SIGN_STATUS != "C") { // 결재완료된 건이면서, 확정된건.
                alert("공문건만 정정공문를 하실 수 있습니다.");
                return;
            }
            /*
            if(!(SIGN_STATUS == "C" && tmp_status == "C") && !(SIGN_STATUS == "C" && tmp_status == "R")) { // 결재완료된 건이면서, 확정된건.
                alert("공문건만 정정공문를 하실 수 있습니다.");
                return;
            }
            */
            
            /*
            if(SIGN_STATUS+tmp_status != "CC") { // 결재완료된 건이면서, 확정된건.
                alert("공문건만 정정공문를 하실 수 있습니다.");
                return;
            }
            */

            if(BDAP_CNT != "Y") {
                alert("투찰 참가 업체가 있는 건은 정정공문를 하실 수 없습니다.");
                return;
            }
            
            //if( "Y" == BDAP_CNT && "Y" == J_PERIOD_COND) {
                url = "/ict/sourcing/bd_ann_ict_"+ann_version+".jsp?BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
                /*
                if(NOW_DATE > APP_BEGIN_DATE && NOW_DATE < APP_END_DATE){
                	alert("입찰진행중에는 정정공문를 하실 수 없습니다.");
                	return;
                }
                */
            //}
            //else {
            //    alert("정정공문를 하실 수 없습니다.");
            //    return;
            //} 
         
            document.form.BID_NO.value 		= BID_NO;
    		document.form.BID_COUNT.value	= BID_COUNT;
    		
    		var nickName = "I_BD_002";
    		var conType = "CONNECTION";
    		var methodName = "getPrgBidCount";
    		
    		var SepoaOut = doServiceAjax( nickName, conType, methodName );
    		
    		if(SepoaOut.status != '1') {
    			alert(SepoaOut.message);
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
	document.form.BID_COUNT.value	= BID_COUNT;
	document.form.BID_STATUS.value	= "UT"; 
	document.form.SCR_FLAG.value    = "I";

	window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "doBidding";
	document.form.submit();
}
    
// 공문삭제
function doDelete() {
	//alert("준비중입니다.");
	//return;
	
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
		
        checked_count++;

		if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
			alert("처리할 권한이 없습니다.");
			return;
		}

		// 작성중인 공문만 삭제 가능
		if(BID_STATUS != "AT" && BID_STATUS != "AJ" && BID_STATUS != "UT" && BID_STATUS != "UJ" && BID_STATUS != "CT" && BID_STATUS != "CJ") {
			alert("현재 진행상태는 삭제할 수 없습니다.");
			return;
		}
    }
	
    if(checked_count == 0) {
        alert("선택된 로우가 없습니다.");
        return;
    }
	
	Message = "삭제 하시겠습니까?";
    var cols_ids = "<%=grid_col_id%>"; 
 
	if(confirm(Message) == 1) {

		document.form.BID_NO.value		= BID_NO;
		document.form.BID_COUNT.value	= BID_COUNT;
        var params = "mode=setBdDelete";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput(); 
        myDataProcessor = new dataProcessor( G_SERVLETURL, params );
        sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
	}
}

<%--공문작성--%>
function doCreate(){
		
	var checkCnt                     = 0;
	var cur                          = "";
	var pr_data                      = "";
	var pr_type                      = "";
	var req_type                     = "";
	var create_type                  = "";
	var shipper_type                 = "";
	var preferred_bidder_vendor_name = "";
	var pr_name                      = "";
	var gwStatusColIndex             = GridObj.getColIndexById("GW_STATUS");
	var gwStatusColValue             = null;


	document.form.BID_NO.value		= "";
	document.form.BID_COUNT.value	= "";

	var url  = "/ict/sourcing/bd_ann_ict_<%=ANN_VERSION%>.jsp?SCR_FLAG=I&BID_STATUS=AT&BID_TYPE=D&GUBUN=W&ANN_VERSION=<%=ANN_VERSION%>";
	
	var pop_focus = window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=800,left=0,top=0");
	
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "doBidding";
	document.form.submit();
	pop_focus.focus();	
}

<%--공문수정/확정--%>
function setModify() {
    var SCR_FLAG;
    var url;

    var checked_count = 0; 
    var index_flag = 0;

    if(!checkRows()) return;
    
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
 
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
        var end_STATUS      = BID_STATUS.substring(1, 2);


        if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
            alert("작성자만 결재요청,수정할 수 있습니다.");
            return;
        }

        if("AC" == BID_STATUS || "UC" == BID_STATUS) {
            alert("진행상태가 공문중인 문서는 결재요청,수정할 수 없습니다.");
            return;
        }
        
        if( "T" == SIGN_STATUS || "B" == SIGN_STATUS ){
        	url = "/ict/sourcing/bd_ann_ict_" + ann_version + ".jsp";
        	url = url + "?BID_TYPE=" + bid_type;
        	url = url + "&ANN_VERSION=" + ann_version;
        }else if( "P" == SIGN_STATUS){
        	alert("결재요청 중입니다.");
        	return;
        }else{
        	alert("거래가능 상태가 아닙니다.");
        	return;
        }


//            if( "T" == SIGN_STATUS || "B" == SIGN_STATUS) { // 수정 (어차피 결재반려건은 조회 안됨.)
//                if(front_STATUS == "A" || front_STATUS == "U") {
////                     url = "bd_ann.jsp?SCR_FLAG=U";  //입찰공문, 정정공문 수정
//					url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=U&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
////                     url = "bd_ann_to_be.jsp?SCR_FLAG=U";  //입찰공문, 정정공문 수정
//                }else{
////                     url = "ebd_bd_ins2.jsp?SCR_FLAG=U";  //취소공문 수정
//                    url = "ebd_bd_ins2.jsp?SCR_FLAG=U";  //취소공문 수정
//                }
//            }
//            else if(SIGN_STATUS == "C" && end_STATUS == "R") {                   // 확정
//                if(front_STATUS == "A" || front_STATUS == "U") {
////                     url = "bd_ann.jsp?SCR_FLAG=C";  //입찰공문, 정정공문 확정
////                     url = "bd_ann_to_be.jsp?SCR_FLAG=C";  //입찰공문, 정정공문 확정
//                    url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=C&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
//                } else {
//                    url = "ebd_bd_ins2.jsp?SCR_FLAG=C";  //취소공문 확정
//                }
//            }
//            else  {                   // 확인(상세조회)
//                if(front_STATUS == "A" || front_STATUS == "U") {
//					url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
////                     url = "bd_ann.jsp?SCR_FLAG=D";  //입찰공문, 정정공문 상세조회
////                     url = "bd_ann_to_be.jsp?SCR_FLAG=D";  //입찰공문, 정정공문 상세조회
//                } else {
//                    url = "ebd_bd_dis2.jsp?SCR_FLAG=D";  //취소공문 상세조회
//                }
//            }
//
//            if(BID_STATUS == "RC" || BID_STATUS == "SR" || BID_STATUS == "SC") { // 마감처리, 규격평가 건일 경우에는 아래의 로직의 예외사항...-> 확인 으로 보여준다.
////                 url = "bd_ann.jsp?SCR_FLAG=D";  //입찰공문, 정정공문 상세조회
////                 url = "bd_ann_to_be.jsp?SCR_FLAG=D";  //입찰공문, 정정공문 상세조회
//				url = "/sourcing/bd_ann_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
//            }
// 
    }
    
    document.form.BID_NO.value 		= BID_NO;
	document.form.BID_COUNT.value	= BID_COUNT;
	document.form.BID_STATUS.value	= BID_STATUS;  
	document.form.SCR_FLAG.value    = "U";

	window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "doBidding";
	document.form.submit(); 
}

// 취소공문
function setCancelNoti() {
	//alert("준비중입니다.");
	//return;
	
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

		if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
			alert("처리할 권한이 없습니다.");
            return;
		}

		if(BID_STATUS == "CC") {
			alert("이미 공문된 취소공문건입니다.");
            return;
        }

		if(SIGN_STATUS+tmp_status != "CC") { // 결재완료된 건이면서, 확정된건.
			alert("공문건만 취소공문를 하실 수 있습니다.");
            return;
        }

		if(BDAP_CNT != "Y") {
            alert("투찰 참가 업체가 있는 건은 취소공문를 하실 수 없습니다.");
            return;
        }
		
        if(BID_STATUS == "NB" || BID_STATUS == "SB") {
            alert("이미 개찰이 끝난건은 취소공문를 하실 수 없습니다.");
            return;
        } else {
            url = "bd_ann_cancel_ict.jsp?SCR_FLAG=I&BID_STATUS=CR";  //취소공문 생성
        }
        
        document.form.BID_NO.value 		= BID_NO;
		document.form.BID_COUNT.value	= BID_COUNT;
		
		var nickName = "I_BD_002";
		var conType = "CONNECTION";
		var methodName = "getPrgBidCount";
		
		var SepoaOut = doServiceAjax( nickName, conType, methodName );
		
		if(SepoaOut.status != '1') {
			alert(SepoaOut.message);
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
	document.form.BID_STATUS.value		= BID_STATUS;  

	window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=460,height=280,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "doBidding";
	document.form.submit(); 
}


<%--공문 담당자변경--%>
function doTransfer() {
    var SCR_FLAG;
    var url;

    var checked_count = 0; 
    var index_flag = 0;

    if(!checkRows()) return;
    
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";
    
    var Transfer_person_id 		= LRTrim(form.Transfer_person_id.value);
	var Transfer_person_name 	= LRTrim(form.Transfer_person_name.value);

	if(Transfer_person_id == "") {
		alert("변경할 공문담당자를 입력하셔야 합니다.");
		form.Transfer_person_name.select();
		button_flag = false;
		return;
	}
 
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
        var end_STATUS      = BID_STATUS.substring(1, 2);


        if("<%=info.getSession("ID")%>" != CHANGE_USER_ID && "<%=info.getSession("MENU_PROFILE_CODE")%>" != "MUP150700003") {
            alert("담당자변경 권한이 없습니다.\r\n\r\n권한자 : 해당 공문 담당자 , 'ICT_내부관리자_주관부서'권한자 ");
            return;
        }

        if("CC" == BID_STATUS || "RR" == BID_STATUS || "NB" == BID_STATUS  || "SB" == BID_STATUS) {
            alert("현 진행상태는 담당자변경이 불가합니다.");
            return;
        }
        
        if(Transfer_person_id == CHANGE_USER_ID){
        	alert("동일한 담당자로 변경 불가합니다.");
        	form.Transfer_person_name.select();
            return;
        }
    }
    
	Message = "공문담당자를 "+Transfer_person_name+"으로 지정 하시겠습니까?";
	
	if(confirm(Message) == 1) {
			
	
			var grid_array = getGridChangedRows(GridObj, "SELECTED");
			var cols_ids = "<%=grid_col_id%>";
			var params;
			params = "mode=charge_transfer";
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();			

			myDataProcessor = new dataProcessor( G_SERVLETURL, params );
	        sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );	        
	}	
}//doTransfer End


function entKeyDown2(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        SP9113_Popup();
    }
}

function Transfer_person_name_onblur(obj){
	if(obj.value == ""){
		document.forms[0].Transfer_person_id.value = "";
	}
    
}

//공문담당자 선택
function SP9113_Popup() {
	window.open("/common/CO_008_ict.jsp?callback=getTransfer&readOnly=readOnly&userName="+document.forms[0].Transfer_person_name.value, "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}
function getTransfer(code, text) {
	document.forms[0].Transfer_person_name.value = text;
	document.forms[0].Transfer_person_id.value = code;
}

function initAjax()
{ 
}

// 지우기
function doRemove( type ){
    if( type == "CHANGE_USER" ) {
    	document.forms[0].CHANGE_USER.value = "";
        document.forms[0].CHANGE_USER_NAME.value = "";
    }else if( type == "Transfer" ) {
    	document.forms[0].Transfer_person_id.value = "";
        document.forms[0].Transfer_person_name.value = "";
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
	window.open("/common/CO_008_ict.jsp?callback=getChUser", "SP0023", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
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
	<input type="hidden" name="BID_STATUS" id="BID_STATUS">
	<input type="hidden" name="SCR_FLAG" id="SCR_FLAG">
	
	<input type="hidden" name="ANN_NO" id="ANN_NO">
	<input type="hidden" name="ANN_COUNT" id="ANN_COUNT">
	

	<input type="hidden"    name="PR_NO_SEQ"        id="PR_NO_SEQ"         value=""            />
	<input type="hidden"    name="PR_NUMBER"        id="PR_NUMBER"          value=""            />
	<input type="hidden"    name="PR_SEQ"           id="PR_SEQ"             value=""            />
	<input type="hidden"    name="PR_TYPE"          id="PR_TYPE"            value=""            />

	<input type="hidden" name="DOC_NO" id="DOC_NO" />
	<input type="hidden" name="DOC_SEQ" id="DOC_SEQ" />
	
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
												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;공문일자
												</td>
												<td width="35%" class="data_td">
													<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"
														id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
												</td>
												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;진행상태
												</td>
												<td width="35%" class="data_td">
													<select name="STATUS" id="STATUS" class="inputsubmit">
														<option value="">전체</option>
														<option value="C">공문중</option>
														<option value="T">작성중</option>
														<option value="P">결재중</option>
													</select>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;공문번호
												</td>
												<td class="data_td">
													<input type="text" name="ann_no" id="ann_no" size="20" style="ime-mode:inactive" maxlength="20" class="inputsubmit" onkeydown='entKeyDown()'>
												</td>
												<td class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰건명
												</td>
												<td class="data_td">
													<input type="text" name="ann_item" id="ann_item" style="ime-mode:active;width:95%" maxlength="100" class="inputsubmit" onkeydown='entKeyDown()'>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰담당자
												</td>
												<td class="data_td">
													<input type="text" name="CHANGE_USER" id="CHANGE_USER" size="20" maxlength="10" class="inputsubmit" value="<%=info.getSession("ID")%>" onBlur="javascript: param1 = form.CHANGE_USER.value; get_Wisedesc('SP0255', 'form', this, 'CHANGE_USER_NAME','values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values='+param1+'&values=','1');" onkeydown='entKeyDown()'>
													<a href="javascript:SP0023_Popup()">
														<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
													</a>
													<a href="javascript:doRemove('CHANGE_USER')">
														<img src="<%=POASRM_CONTEXT_NAME%>/images/button/ico_x2.gif" align="absmiddle" border="0">
													</a>
													<input type="text" name="CHANGE_USER_NAME" id="CHANGE_USER_NAME" size="20" readonly value='<%=info.getSession("NAME_LOC")%>' onkeydown='entKeyDown()' >
												</td>
												<td class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰구분
												</td>
												<td class="data_td">
													<select name="ES_FLAG" id="ES_FLAG" class="inputsubmit">
														<option value="">전체</option>
														<option value="E">전자입찰</option>
														<option value="S">현장입찰</option>
													</select>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;현재시간
												</td>
												<td class="data_td" colspan="3">
													<div id="id1"></div>
													<input type="hidden" name="h_server_date" class="input_empty" size="50" readonly>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
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
							<div align="left">
								<table cellpadding="0">
									<tr>
										<td style="font-weight:bold;font-size:12px;color:#555555;">&nbsp;변경할 공문담당자</td>
								      	<td> <b>								        
								        <input type="text" name="Transfer_person_name" id="Transfer_person_name" size="6" class="inputsubmit" onkeydown='entKeyDown2()' onblur="Transfer_person_name_onblur(this)" >
								        <a href="javascript:SP9113_Popup();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>       </b>
								        <a href="javascript:doRemove('Transfer')">
											<img src="<%=POASRM_CONTEXT_NAME%>/images/button/ico_x2.gif" align="absmiddle" border="0">
										</a>
										<input type="text" name="Transfer_person_id" id="Transfer_person_id" size="7" maxlength="8" class="input_data0" readOnly >
							      		</td>
							      		<td> <b>
								        	<table><tr><td><script language="javascript">btn("javascript:doTransfer()","담당자변경")</script></td></tr></table>
							      		</td>
									</tr>
								</table>
							</div>
						</td>												   
						<td height="30">
							<div align="right">
								<table cellpadding="0">
									<tr>
										<td><script language="javascript">btn("javascript:doSelect()"		, "조 회")	</script></td>
										<td><script language="javascript">btn("javascript:doCreate()"		, "공문작성")</script></td>
										<td><script language="javascript">btn("javascript:setAmendNoti()"	, "정정공문작성")</script></td>
										<td><script language="javascript">btn("javascript:setModify()"		, "결재요청(수정)")</script></td>
										<td><script language="javascript">btn("javascript:setCancelNoti()"	, "취소공문")</script></td>
										<td><script language="javascript">btn("javascript:doDelete()"		, "공문삭제")</script></td>
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
<%-- <s:grid screen_id="I_BD_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe> 