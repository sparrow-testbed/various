<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_234");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_234";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif"; // 이미지 

	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;

%>
<% String WISEHUB_PROCESS_ID="RQ_234";%>
<%
	Config conf1 = new Configuration();
	String all_admin_profile_code = "";
	String admin_profile_code = "";		
	String session_profile_code = info.getSession("MENU_TYPE");
	try {
		all_admin_profile_code = conf1.get("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
		admin_profile_code = conf1.get("wise.admin.profile_code."+info.getSession("HOUSE_CODE"));
	} catch (Exception e1) {
		
		all_admin_profile_code = "";
		admin_profile_code = "";
	}
%>
<html>
	<head>
	<title><%=text.get("MESSAGE.MSG_9999") %></title><%-- 우리은행 전자구매시스템 --%>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<%@ include file="/include/include_css.jsp"%>
		<%-- Dhtmlx SepoaGrid용 JSP--%>
		<%@ include file="/include/sepoa_grid_common.jsp"%>
		<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
		<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
		<%-- Ajax SelectBox용 JSP--%>
		<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
		<Script language="javascript" type="text/javascript">
<!--
    var mode;

	var INDEX_SEL              ;
	var INDEX_RFQ_NO           ;
	var INDEX_RFQ_COUNT        ;
	var INDEX_SUBJECT          ;
	var INDEX_SETTLE_TYPE_TXT  ;
	var INDEX_CLOSE_DATE       ;
	var INDEX_BIDDER           ;
	//var INDEX_CHANGE_USER_ID   ;
	var INDEX_CTRL_CODE        ;
	var INDEX_RFQ_TYPE         ;
	var INDEX_SETTLE_TYPE      ;
	var INDEX_EVAL_FLAG      ;
	var INDEX_EVAL_FLAG_DESC      ;
	var INDEX_EVAL_REFITEM      ;
	var INDEX_REQ_TYPE         ;

	function init() {	//화면 초기설정 
		setGridDraw();
		setHeader();
		doSelect();
	}
	
    function setHeader() {
	
		//GridObj.SetColCellSortEnable("SELECTED",false);
		//GridObj.strHDClickAction="sortmulti";
	
	
		INDEX_SEL                = GridObj.GetColHDIndex("SELECTED");
		INDEX_RFQ_NO             = GridObj.GetColHDIndex("RFQ_NO");
		INDEX_RFQ_COUNT          = GridObj.GetColHDIndex("RFQ_COUNT");
		INDEX_SUBJECT            = GridObj.GetColHDIndex("SUBJECT");
		INDEX_SETTLE_TYPE_TXT    = GridObj.GetColHDIndex("SETTLE_TYPE_TXT");
		INDEX_CLOSE_DATE         = GridObj.GetColHDIndex("CLOSE_DATE");
		INDEX_BIDDER             = GridObj.GetColHDIndex("BIDDER");
		//INDEX_CHANGE_USER_ID     = GridObj.GetColHDIndex("CHANGE_USER_ID");
		INDEX_CTRL_CODE          = GridObj.GetColHDIndex("CTRL_CODE");
		INDEX_RFQ_TYPE           = GridObj.GetColHDIndex("RFQ_TYPE");
		INDEX_REQ_TYPE           = GridObj.GetColHDIndex("REQ_TYPE");
		INDEX_SETTLE_TYPE        = GridObj.GetColHDIndex("SETTLE_TYPE");
		INDEX_BID_REQ_TYPE       = GridObj.GetColHDIndex("BID_REQ_TYPE");
		INDEX_EVAL_FLAG  		 = GridObj.GetColHDIndex("EVAL_FLAG");
		INDEX_EVAL_FLAG_DESC	 = GridObj.GetColHDIndex("EVAL_FLAG_DESC");
		INDEX_EVAL_REFITEM       = GridObj.GetColHDIndex("EVAL_REFITEM");
			
	//	doSelect();
    }

    function doSelect() {
        if(LRTrim(form1.start_rfq_date.value) == "" || LRTrim(form1.end_rfq_date.value) == "") {
            alert("생성일자를 입력하셔야 합니다.");
            return;
        }
        if(!checkDate(del_Slash(form1.start_rfq_date.value))) {
            alert("생성일자를 확인하세요.");
            form1.start_rfq_date.select();
            return;
        }
        if(!checkDate(del_Slash(form1.end_rfq_date.value))) {
            alert("생성일자를 확인하세요.");
            form1.end_rfq_date.select();
            return;
        }


        //if(LRTrim(form1.pid.value) == "" || LRTrim(form1.pid.value) == "") {
        //    alert("구매직무를 입력하셔야 합니다.");
        //    form1.pid.focus();
        //    return;
        //}
        //
        //pid = LRTrim(form1.pid.value);
        //pid = pid.toUpperCase();

		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_lis2";
        GridObj.SetParam("bid_rfq_type", "PR");

        //GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		//GridObj.SendData(servletUrl);
        var grid_col_id = "<%=grid_col_id%>";
        var params = "mode=getSettleVendor";
        params += "&cols_ids=" + grid_col_id;
        params += dataOutput();
        GridObj.post( servletUrl, params );
        GridObj.clearAll(false);
    }
	
    // 견적비교
    function qtaCompare() {
        if(!checkUser()) return;

        rowcount = GridObj.GetRowCount() -1;
        if(rowcount < 0) return;

        checked_count = 0;
        selected_row = -1;

        for(row=rowcount; row>=0; row--) {
            if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
                checked_count++;
                selected_row = row;
            }
        }

        if(checked_count < 1)  {
            alert(G_MSS1_SELECT);
            return;
        }

        if(checked_count > 1)  {
            alert(G_MSS2_SELECT);
            return;
        }

        if(parseInt(GD_GetCellValueIndex(GridObj,selected_row, INDEX_BIDDER)) <= 0) {
            alert("제안업체수가 0보다 커야합니다.");
            return;
        }

        settle_type         = GD_GetCellValueIndex(GridObj,selected_row, INDEX_SETTLE_TYPE);
        rfq_no              = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RFQ_NO),selected_row);
        rfq_count           = GD_GetCellValueIndex(GridObj,selected_row, INDEX_RFQ_COUNT);
        bid_req_type           = GD_GetCellValueIndex(GridObj,selected_row, INDEX_BID_REQ_TYPE);
        req_type           = GD_GetCellValueIndex(GridObj,selected_row, INDEX_REQ_TYPE);


		// 평가는 구매요청만 해당된다. 사전지원는 제외.
		var REQ_TYPE = GridObj.GetCellValue("REQ_TYPE", selected_row);
		var eval_status     = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_EVAL_FLAG),selected_row);
		/*
		if(REQ_TYPE == "P"){
			if(!(eval_status == "N" || eval_status == "C") ){
				alert("평가제외 또는 평가 완료된 건이 아니면 견적비교 하실 수 없습니다.");
				return;
			}
		}*/

		if(settle_type == "DOC") {
			window.open("qta_pp_ins1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count + "&settle_type=" + settle_type + "&bid_req_type=" + bid_req_type + "&req_type=" + req_type, "qta_pp_ins1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1015,height=520,left=0,top=0");
		} else {
			window.open("qta_bd_ins3.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count + "&bid_req_type=" + bid_req_type + "&req_type=" + req_type, "qta_bd_ins3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1015,height=520,left=0,top=0");
		}
    }
	
    // 재견적 요청
    function reQuotation() {
        if(!checkUser()) return;

        rowcount = GridObj.GetRowCount()-1;
        if(rowcount < 0) return;

        checked_count = 0;
        selected_row = -1;

        for(row=rowcount; row>=0; row--) {
            if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
                checked_count++;
                selected_row = row;
            }
        }

        if(checked_count < 1)  {
            alert(G_MSS1_SELECT);
            return;
        }

        if(checked_count > 1)  {
            alert(G_MSS2_SELECT);
            return;
        }
        req_type = GD_GetCellValueIndex(GridObj,selected_row, INDEX_REQ_TYPE);
		
        // 직접입력한 견적건은 재견적 안됨
        if(req_type == "M"){
            //alert("[메뉴얼 견적]은 재견적할 수 없습니다." );
            //return;
        }

        settle_type = GD_GetCellValueIndex(GridObj,selected_row, INDEX_SETTLE_TYPE);
        rfq_no      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RFQ_NO),selected_row);
        rfq_count   = GD_GetCellValueIndex(GridObj,selected_row, INDEX_RFQ_COUNT);

        window.open("rfq_pp_ins3.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count + "&settle_type=" + settle_type, "windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
    }
	
    // 권한 검토
    function checkUser() {
        var flag = false;

        for(var row=0; row<GridObj.GetRowCount(); row++) {
            if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
                var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
                for( i=0; i< ctrl_code.length; i++ )
                {
                    if(ctrl_code[i] != GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)) {
                        flag = false;
                    } else {
                        flag = true;
                        break;
                    }
                }
                if( flag == false )
                {
                    alert("작업을 수행할 권한이 없습니다.");
                    return false;
                }
            }
        }
        return true;
    }

    function start_rfq_date(year,month,day,week) {
        document.form1.start_rfq_date.value=year+month+day;
    }

    function end_rfq_date(year,month,day,week) {
        document.form1.end_rfq_date.value=year+month+day;
    }
	
    // 견적마감
    function setRFQClose() {
        if(!checkUser()) return;

        rowcount = GridObj.GetRowCount() -1;
        if(rowcount < 0) return;

        checked_count = 0;
        selected_row = -1;

        for(row=rowcount; row>=0; row--) {
            if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
                checked_count++;
                selected_row = row;
            }
        }

        if(checked_count < 1)  {
            alert(G_MSS1_SELECT);
            return;
        }

        if(!confirm("견적 마감 하시겠습니까?")) {
            return;
        }

        servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_lis2";

        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");

    }

	function SP0216_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
		//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		CodeSearchCommon(url, 'doc', left, top, width, height);
	}

	function SP0023_Popup() {
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
		
		CodeSearchCommon(url,'doc','0','0','570','530');
	}

	function SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
		document.form1.pid.value = ls_ctrl_code;
		document.form1.txtpid.value = ls_ctrl_name;
	}

	function SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION ) {
		document.form1.ctrl_person_id.value = USER_ID;
		document.form1.ctrl_person_id_name.value = USER_NAME_LOC;
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
      if(msg1 == "t_imagetext") {
            if(msg3 == INDEX_RFQ_NO) { //견적요청번호
                rfq_no = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RFQ_NO),msg2);
                rfq_count = GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_COUNT);

                window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=640,left=0,top=0");
            }
            /*
            else if(msg3 == INDEX_EVAL_FLAG){
            	eval_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_REFITEM);
            	if( eval_refitem != ""){
            		alert("test!!!!!\n" + eval_refitem);
            	     //window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=640,left=0,top=0");
            	}
            }*/
        }

        else if(msg1 == "t_insert") {
            if(msg3 == INDEX_SEL) {
                for(i=0; i<GridObj.GetRowCount(); i++) {
                    if("true" == GD_GetCellValueIndex(GridObj,i, INDEX_SEL)) {
                        if(i != msg2) {
                            GD_SetCellValueIndex(GridObj,i, INDEX_SEL, "false&", "&");
                        }
                    }
                }
            }
        }
        else if(msg1 == "doData") {
        	if(mode == "charge_eval") {
				alert(GridObj.GetMessage());
				if(GridObj.GetStatus() == "1") {
					doSelect();
				}
			}else{
            	alert(GD_GetParam(GridObj,1));
            	doSelect();
            }
        }
  	}

	function doEval() {
        var checked_count = 0;
		var rowcount = GridObj.GetRowCount();
		var vendor_count = 0;
		var eval_status = "";
		var checkedIndex;

		for(row=rowcount-1; row>=0; row--) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
			 	vendor_count = GD_GetCellValueIndex(GridObj,row, INDEX_BIDDER);
			 	eval_status = GD_GetCellValueIndex(GridObj,row, INDEX_EVAL_FLAG);
				checked_count++;
				checkedIndex = row;
			}
		}

		if(checked_count == 0)  {
			alert("견적내용을 선택하여주십시요!");
			return;
		}

		if(GridObj.GetCellValue("REQ_TYPE", checkedIndex) == "B"){
			alert("사전지원요청건은 평가등록을 하실 수 없습니다.");
			return;
		}

		if(vendor_count ==0){
			alert("제안업체수가 0인 건은 평가를 생성할 수 없습니다!");
			return;
		}

		var eval_id = form1.template_type.value;

		if(eval_id == "") {
			alert("평가대상을 등록하려면 평가를 선택해야  합니다.");
			return;
		}

		if(eval_status == "I"){
			alert("인터뷰 선정중인 건은 평가를 생성할 수 없습니다!");
			return;
		}

		if(eval_status == "S" && eval_id != "3"){
			alert("인터뷰 선정완료 건은 [투입인력 선정평가]를  선택해야 합니다.\n[투입인력 선정평가]를 선택해 주세요!");
			return;
		}

		Message = "평가대상을 ["+document.form1.template_type.options[document.form1.template_type.options.selectedIndex].text+"] 으로 지정 하시겠습니까?";
		if(confirm(Message) == 1) {
<%-- 			servletUrl = "<%=getWiseServletPath("dt.rfq.qta_bd_lis2")%>"; --%>
			servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_lis2";
			GridObj.SetParam("mode", "charge_eval");
			GridObj.SetParam("eval_id", eval_id);
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}

	}//doEval End

	// PM에게 인터뷰 선정 요청
	function doInterview(){
	 	var rowcount = GridObj.GetRowCount() -1;
        if(rowcount < 0) return;

        var checked_count = 0;
        var selected_row = -1;

		if(checkEval()){
			Message = "인터뷰 선정 요청을 하시겠습니까?";
			if(confirm(Message) == 1) {
				for(row=rowcount; row>=0; row--) {
            		if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
                		checked_count++;
                		selected_row = row;
            		}
        		}
        		var rfq_count = GD_GetCellValueIndex(GridObj,selected_row, INDEX_RFQ_COUNT);
        		var req_type  = GD_GetCellValueIndex(GridObj,selected_row, INDEX_RFQ_COUNT);
				var eval_status = GD_GetCellValueIndex(GridObj,selected_row, INDEX_EVAL_FLAG);

				if(eval_status == "I" || eval_status == "S"){
					alert("인터뷰 선정을 진행중이거나 완료된 건 입니다.\n[인터뷰 선정완료]된 상태이면 [투입인력 선정평가]를 진행하세요. ");
					return;
				}

<%-- 				servletUrl = "<%=getWiseServletPath("dt.rfq.qta_bd_lis2")%>"; --%>
				servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_lis2";
				GridObj.SetParam("mode", "charge_interview");
				GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
				GridObj.SendData(servletUrl, "ALL", "ALL");
			}
		}
	}

	function checkEval(){
		var checked_count = 0;
		var rowcount = GridObj.GetRowCount();
		var vendor_count = 0;
		var checkedIndex;

		for(row=rowcount-1; row>=0; row--) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
			 	vendor_count = GD_GetCellValueIndex(GridObj,row, INDEX_BIDDER);
				checked_count++;
				checkedIndex = row;
			}
		}

		if(checked_count == 0)  {
			alert("견적내용을 선택해주십시요!");
			return false;
		}

		if(checked_count > 1)  {
			alert("견적내용을 하나만 선택해 주십시요!");
			return false;
		}

		if(GridObj.GetCellValue("REQ_TYPE", checkedIndex) == "B"){
			alert("사전지원요청건은 인터뷰 선정 요청을 하실 수 없습니다.");
			return;
		}

		if(vendor_count ==0){
			alert("제안업체수가 0인 건은 인터뷰 선정 요청을 생성할 수 없습니다!");
			return;
		}
		return true;
	}
//-->
</Script>
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
	
	var rfqType    = "";
	var rfqNo      = "";
	var rfqCount   = "";
	var url        = "";
	var vendorType = "";

    rfqType   = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_TYPE");
	rfqNo     = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
    rfqCount  = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
    if(cellInd == GridObj.getColIndexById("RFQ_NO")) {
	    url = 'rfq_bd_dis1.jsp?rfq_no=' + encodeUrl(rfqNo) + '&rfq_count=' + encodeUrl(rfqCount) + '&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '1024', '650');
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

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->
<form name="form1" action="">
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
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 요청일자
	</td>
	<td class="data_td">
		<%-- <input type="text" name="start_rfq_date" id="start_rfq_date" size="8" maxlength="8" class="input_re" value="<%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1)%>">
		<a href="javascript:Calendar_Open('start_rfq_date');">
			<img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0" alt="">
		</a>
		~
		<input type="text" name="end_rfq_date" id="end_rfq_date" size="8" maxlength="8" class="input_re" value="<%=SepoaDate.getShortDateString()%>">
		<a href="javascript:Calendar_Open('end_rfq_date');">
			<img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0" alt="">
		</a> --%>
		<s:calendar id="start_rfq_date" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
		~
		<s:calendar id="end_rfq_date" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
	</td>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 견적요청번호
	</td>
	<td class="data_td">
		<input type="text" name="rfq_no" id="rfq_no" style="width:95%;ime-mode:inactive;" maxlength="20"  onkeydown='entKeyDown()'  class="inputsubmit">
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 견적요청명
	</td>
	<td width="35%" class="data_td">
		<input type="text" name="subject" id="subject" style="width:95%"  onkeydown='entKeyDown()' class="inputsubmit">
	</td>
		<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 견적담당자
	</td>
	<td width="35%" class="data_td" >
<% if (session_profile_code.equals(all_admin_profile_code) || session_profile_code.equals(admin_profile_code)) {%>                        	
		<input type="text" name="ctrl_person_id" id="ctrl_person_id" size="20" maxlength="10" class="inputsubmit" value="<%=info.getSession("ID")%>"   onkeydown='entKeyDown()' >
		<a href="javascript:SP0023_Popup()">
			<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
		</a>
<% } else{%> 
		<input type="text" name="ctrl_person_id" id="ctrl_person_id" size="20" maxlength="10" class="inputsubmit" value="<%=info.getSession("ID")%>" readonly  onkeydown='entKeyDown()' >		
<%} %>
		<input type="text" name="ctrl_person_id_name" id="ctrl_person_id_name" size="25" class="input_data2" value='<%=info.getSession("NAME_LOC")%>'  onkeydown='entKeyDown()' >
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr style="display:none">

	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비교방식
	</td>
	<td class="data_td" colspan="3">
		<select name="settle_type" id="settle_type" id="settle_type" class="inputsubmit">
		<option value=''>전체</option>
<%
    String settle = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M149", "");
    out.println(settle);
%>
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


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="left" width="50%">
		<TABLE cellpadding="0"  border="0" >
			<TR style="display:none;">
				<td width="3%">&nbsp;</td>
				<td width="25%"> &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가대상</td>
				<td >
					<select name="template_type" class="inputsubmit">
					<option value="0">평가 제외</option>
					<%
    				String template_type = ListBox(request, "SL0109", info.getSession("HOUSE_CODE") + "#M924"+ "#Y", "");
    				out.println(template_type);
					%>
					</select>
				</td>
				<td width="30%"> <script language="javascript">btn("javascript:doEval()","등록")</script></td>
<!-- 				<td width="25%"> <script language="javascript">btn("javascript:doInterview()",2,"인터뷰 요청")</script></td> -->
			</TR>
		</TABLE>
	</td>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:doSelect()","조 회")    </script></TD>
			<TD><script language="javascript">btn("javascript:qtaCompare()","견적비교")   </script></TD>
			<%-- <TD><script language="javascript">btn("javascript:reQuotation()","재견적")</script></TD> --%>
		</TR>
		</TABLE>
	</td>
</tr>
</table>
<!-- <a href="#" onclick="javascript:reQuotation()"> -->

</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>
<%-- <s:grid screen_id="RQ_234" grid_obj="GridObj" grid_box="gridbox"/> --%>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>
	

