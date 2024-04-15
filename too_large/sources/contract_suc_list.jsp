<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date = to_day;
	String ct_flagsss		= JSPUtil.nullToEmpty(request.getParameter("ct_flagsss"));
	String cc_flag		= JSPUtil.nullToEmpty(request.getParameter("cc_flag"));
	String cont_no		= JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String seller_code		= JSPUtil.nullToEmpty(request.getParameter("seller_code"));
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_020");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");
	String company_code = info.getSession("COMPANY_CODE");
	String user_id = info.getSession("ID");
	String user_dept   =  info.getSession("DEPARTMENT");

	// Dthmlx Grid 전역변수들..
	String screen_id = "CT_020";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = true;
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_contract_suc_list"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title>
<%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"%><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	
    }

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }

    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");

		if(status == "false") alert(msg);
		return true;
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

    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
    	var header_name = GridObj.getColumnId(cellInd);
    	
    	if( header_name == "CONT_NO")
		{
			var	cont_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());	
			var	cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			var subject      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("SUBJECT")).getValue());
			
			/*
			if(cont_no != '') {
				
				var strParm = "cont_no=" + cont_no + "&cont_gl_seq=" + cont_gl_seq + "&cont_form_no=" + cont_no;
			 	popUpOpen("contract_detail_print_f.jsp?"+strParm, 'CONT_NO_DETAIL', '1080', '700');
			}
			*/
			
			if(cont_no != '') {
				//var strParm = "doc_no="+cont_no+"&doc_seq="+cont_gl_seq+"&doc_type=CT&sign_enable=T&attach_no=&doc_status=N&proceeding_flag=P&ct_flag=CD&sign_status=E&subject="+subject;
			 	//popUpOpen("/approval/approval_ct.jsp?"+strParm, 'CONT_NO_DETAIL', '1080', '950');
			 	var default_url = "/approval/approval_ct.jsp?doc_no="+cont_no+"&doc_seq="+cont_gl_seq+"&doc_type=CT&sign_enable=T&attach_no=&doc_status=N&proceeding_flag=P&ct_flag=CD&sign_status=E&subject="+subject;
				winpopup = window.open(default_url, "_blank", "width=1050, height=950, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );					
			}
			
			
		}
		
    	if(GridObj.getColIndexById("CONT_FILE_IMG") == cellInd)
    	{
    		var w_dim  = new Array(2);
			    w_dim  = ToCenter(400, 640);
			var w_top  = w_dim[0];
			var w_left = w_dim[1];
    		
    		var TYPE       = "NOT";
    		var attach_key = SepoaGridGetCellValueId(GridObj, rowId, "CONT_FILE_NO"); 
			var view_type  = "VI";

    		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
    		
    		//FileAttach(rowId, SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_TXT") );
    	}	
    	
    	if(GridObj.getColIndexById("FAULT_FILE_IMG") == cellInd)
    	{
    		var w_dim  = new Array(2);
			    w_dim  = ToCenter(400, 640);
			var w_top  = w_dim[0];
			var w_left = w_dim[1];
    		
    		var TYPE       = "NOT";
    		var attach_key = SepoaGridGetCellValueId(GridObj, rowId, "FAULT_FILE_NO"); 
			var view_type  = "VI";

    		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
    		
    		//FileAttach(rowId, SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_TXT") );
    	}	
    	if(GridObj.getColIndexById("RECT_IMG") == cellInd)
    	{
    		var w_dim  = new Array(2);
			    w_dim  = ToCenter(300, 740);
			var w_top  = w_dim[0];
			var w_left = w_dim[1];
    		 
    		var delete_confirm = SepoaGridGetCellValueId(GridObj, rowId, "REJECT_REASON");  
			if(delete_confirm != "")
    		win = window.open("contract_delete_confirm.jsp?delete_confirm="+encodeUrl(delete_confirm),"delete_confirm_pop",'left=' + w_left + ',top=' + w_top + ', width=620, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
    		 
    	}	
    	
    	if( header_name == "CONT_INS_NO")
		{ 
			var	cont_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());	
			var	cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			var	cont_ins_vn	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_VN")).getValue());
			var	cont_ins_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_NO")).getValue());
			  
			if(cont_ins_vn == "서울금융보증보험" && cont_ins_no != '') {
				
	 		var param  = "cont_no="	+  encodeUrl(cont_no); 
	 		  param  += "&cont_gl_seq=" +  encodeUrl(cont_gl_seq);
	 		  param  += "&bond_type=002";
				   
			 	popUpOpen("contract_guarantee_view.jsp?"+param, 'guarantee_pop', '750', '700');
				 
			}
		}
			
    	if( header_name == "FAULT_INS_NO")
		{ 
			var	cont_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());	
			var	cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			var	cont_ins_vn	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_INS_VN")).getValue());
			var	cont_ins_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("FAULT_INS_NO")).getValue());
			  
			if(cont_ins_vn == "서울금융보증보험" && cont_ins_no != '') {
				
	 		var param  = "cont_no="	+  encodeUrl(cont_no); 
	 		  param  += "&cont_gl_seq=" +  encodeUrl(cont_gl_seq);
	 		  param  += "&bond_type=003";
				   
			 	popUpOpen("contract_guarantee_view.jsp?"+param, 'guarantee_pop', '750', '700');
				 
			}
		}
    	
    	if( header_name == "EXEC_NO")
		{
    		var    exec_number = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("EXEC_NO")).getValue());  
            if(exec_number != ''){
                window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_number+ "&pr_type=I&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");            	
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
			return true;
		} else if(stage==2) {
		    return true;
		}
		
		return false;
    }
    
    // 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 loadXML 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{
		var from_date      = del_Slash(document.form.from_date.value);
		var to_date        = del_Slash(document.form.to_date.value);
		
		var seller_code    = document.form.seller_code.value;       // 업체코드
		var cont_no        = document.form.cont_no.value;			// 계약번호
		var ele_cont_flag  = document.form.ele_cont_flag.value;		// 전자계약여부
		var ctrl_person_id = document.form.ctrl_person_id.value;	// 계약담당자
		var subject        = document.form.subject.value;			// 계약명
		var sg_type1        = document.form.sg_type1.value;			// 소싱그룹대분류
		var sg_type2        = document.form.sg_type2.value;			// 소싱그룹중분류
		var sg_type3        = document.form.sg_type3.value;			// 소싱그룹소분류
		
		var param  = "";
		    param += "&from_date="		+ encodeUrl(from_date);
		    param += "&to_date="		+ encodeUrl(to_date);
		    param += "&seller_code="	+ encodeUrl(seller_code);
		    param += "&cont_no="		+ encodeUrl(cont_no);
		    param += "&ele_cont_flag="	+ encodeUrl(ele_cont_flag);
   			param += "&ctrl_person_id="	+ encodeUrl(ctrl_person_id);
			param += "&subject="	    + encodeUrl(subject);
			param += "&view=Y";
			param += "&sg_type1="	    + encodeUrl(sg_type1);
			param += "&sg_type2="	    + encodeUrl(sg_type2);
			param += "&sg_type3="	    + encodeUrl(sg_type3);
		
		var grid_col_id = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=query2&grid_col_id="+grid_col_id + param;
		GridObj.post(SERVLETURL);
		GridObj.clearAll(false);
	}
	
	
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("항목을 선택해 주세요.");
		return false;
	}
	
	function doContractRead()
	{
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }

<%--	    if("<%=info.getSession("LOGIN_FLAG")%>" == "Y") {                                    --%>
<%--	    	alert("공인인증서로 로그인 하지 않았습니다. \n등록된 인증서로 로그인하여 주세요.");--%>
<%--	    	return;                                                                            --%>
<%--	    }--%>
<%--	    --%>
		for(var i = 0; i < grid_array.length; i++)
		{
			var	cont_no      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
			var	cont_gl_seq  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			var	ct_flag      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
			var	cont_form_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FORM_NO")).getValue());
			
			if(ct_flag == "CT" || ct_flag == "CW") {
				alert("계약서 내용이 없습니다.");
				return;
			}

			if(cont_no != '') {
				location.href = "contract_list_detail_buyer.jsp?btn=N&cont_no="+ cont_no +"&ct_flag="+ ct_flag + "&cont_form_no=" + cont_form_no + "&cont_gl_seq=" + cont_gl_seq;
			}
			
			
		}
	}
	
	function doSend() {
		if( !checkRows() ) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
        
        var	cont_no 	 = "";
        var	cont_gl_seq	 = "";
        var	ct_flag      = "";
        var cont_form_no = "";
        var seller_code_text = "";//업체명
        var cont_type    = "";
        
		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no 	  	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
			ct_flag       	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
			cont_form_no  	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FORM_NO")).getValue());
			ele_cont_flag 	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ELE_CONT_FLAG")).getValue());
			cont_gl_seq   	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			seller_code_text = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_CODE_TEXT")).getValue());
			cont_type        = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE")).getValue());			
		}

		if( ele_cont_flag == "No" ){
			alert("전자계약서여부가 Yes인것만 전송이 가능합니다.");
			return;
		}
		
		if(ct_flag != "CA") {
			alert("계약서의 상태가 전자계약서작성중일때에 업체전송이 가능합니다.");
			return;
		}
		
		if(cont_type != "C") {
			alert("계약서종류가 계약서인것만 업체전송 할 수 있습니다.");
			return;
		}		
		
		if (confirm("전자계약서 페이지로 이동합니다.\n계속 하시겠습니까?")) {
			location.href = "contract_list_detail_buyer.jsp?btn=send&cont_no="+ cont_no + "&cont_form_no="+cont_form_no + "&cont_gl_seq=" + cont_gl_seq+ "&seller_code_text=" + encodeUrl(seller_code_text);
		}
	}
	
	function doDelete_d() {
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
        
        var	cont_no = "";
        var	ct_flag = "";
		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
			ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
		}
		
		if(ct_flag == "CT" || ct_flag == "CW" || ct_flag == "CA" || ct_flag == "CB" || ct_flag == "CE" || ct_flag == "CF") {
			alert("업체가 인증한건이거나 우리은행인증건에 대해서만 폐기 가능합니다.");
			return;
		}
		
		if (confirm("전자계약을 폐기 하시겠습니까?")) {
				location.href = "contract_list_detail_buyer.jsp?btn=delete&cont_no="+ cont_no;
		}
	}
	
	function doContractSend() {
		if( !checkRows() ) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;
		
		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
        
        
        var	cont_no   	 = "";
        var	cont_gl_seq  = "";
        var	ct_flag   	 = "";
        var	cont_type 	 = "";
        var	seller    	 = "";
        var cont_form_no = "";
        var sign_status = "";
        var exec_no = "";
        
		for( var i = 0; i < grid_array.length; i++ )
		{
			cont_no       = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
			cont_gl_seq   = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			ct_flag       = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
			cont_type     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE")).getValue());
			seller        = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_CODE")).getValue());
			cont_form_no  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FORM_NO")).getValue());
			ele_cont_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ELE_CONT_FLAG")).getValue());
			exec_no 	  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EXEC_NO")).getValue());
// 			sign_status = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue()));
		}
		
		if( ele_cont_flag == "No" ){
			alert("전자계약서여부가 Yes인것만 전송이 가능합니다.");
			return;
		}
	 
		if(ct_flag != "CC") {
			alert("계약서의 상태가 업체인증인 건에 대해서만 우리은행인증이 가능합니다.");
			return;
		}
		
// 		if(ct_flag == "CC" && !(sign_status == "E") ) {
// 			alert("계약서의 상태가 업체인증이고 결재상태가 결재완료된 건에 대해서만 우리은행인증이 가능합니다.");
// 			return;
// 		}
		
		if(cont_type != "C") {
			alert("계약서종류가 계약서인것만 우리은행인증 할 수 있습니다.");
			return;
		}

		if(ct_flag == "CD") {
			alert("우리은행인증이 완료 된 상태입니다.");
			return;
		}

		if (confirm("전자계약서 페이지로 이동합니다.\n우리은행인증 하시겠습니까?")) {
			location.href = "contract_list_detail_buyer.jsp?btn=wori&cont_no="+ cont_no+"&seller_code="+ seller + "&cont_form_no=" +cont_form_no + "&cont_gl_seq="+cont_gl_seq + "&exec_no=" + exec_no;
		}
	}

	function initAjax(){
<%--  		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M287' ,'status', '' ); --%>
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '' );
	}

	function doDelete() {
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue()));
			ct_flag = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()));
			
			if( ct_flag != "CA" ) {
				alert("계약서상태가 전자계약서작성중인 건에 대해서만 계약삭제가 가능합니다.");
				return;
			}
		}

		var grid_array = getGridChangedRows(GridObj, "SELECTED");

	   	if (confirm("<%=text.get("MESSAGE.1015")%>")){
	        var cols_ids = "<%=grid_col_id%>";
			var S_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_create_list";
			var SERVLETURL  = S_SERVLETURL + "?mode=delete&cols_ids="+ cols_ids;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	   }
	}
	
	function getCtrlPersonId() {
	   	PopupCommon1("SP5004", "setCtrlPerson", "", "ID", "사용자명");
	}
	
	function setCtrlPerson(code, text1) {
	    document.forms[0].ctrl_person_id.value = code  ;
	    document.forms[0].ctrl_person_name.value = text1 ;
	}

	function getSellerCode() {
		PopupCommon2( "SP5001", "SP5001_getCode",  "", "", "업체코드", "업체명" );//업체코드,업체명
	}
	
	function SP5001_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = text1;
	}
		
    //결재선지정
	function doApproval(){  
	   
		if( !checkRows() ) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count = 0;
	 
		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert("하나이상 선택할 수 없습니다.");
            return;
        }
      
		for(var i = 0; i < grid_array.length; i++)
		{
			ct_flag = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()));
			sign_status = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue()));
		}
 
		if(!ct_flag == "CC") {
				alert("결재요청하실 수 없습니다.");
				return;
		}
		if(ct_flag == "CC" && (sign_status == "P" ||sign_status == "E") ) {
					alert("결재요청하실 수 없습니다.");
					return; 
		}
		if(ct_flag == "CC" && (sign_status =="" || sign_status == "R") ) {
			var param = "";
		
			param += "company_code="+'<%=company_code%>';
			param += "&dept_code="+'<%=user_dept%>';
			param += "&req_user_id="+'<%=user_id%>';
			param += "&doc_type=CT";
			param += "&fnc_name=getApproval"; 
			param += "&from=P"; 
	
			childFrame.location.href="app_approval.jsp?"+param; 
		}
	}
	
	//결재선 지정후 실제 결재요청하는 함수(app_aproval_list3.jsp에서 넘어옴)
	function getApproval(Approval_str) {
 
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cont_no = "";
		var subject = "";
		var cont_amt = "";
 
		for(var i = 0; i < grid_array.length; i++)
		{ 
			cont_no   = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue()));
		 	subject   = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SUBJECT")).getValue()));
		 	cont_amt  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_AMT")).getValue();
			cont_gl_seq = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()));
		  
		}
   
		 
		if (Approval_str == "") {
			alert("<%=text.get("CT_020.MSG_001")%>");//결재자를 지정해 주세요.
			return;
		}
		  
		var param = "";
		param += "&APPROVAL_STR="+encodeUrl(Approval_str);		//결재요청건의 결재선
		param += "&CONT_NO="+cont_no;	 	
		param += "&CONT_GL_SEQ="+cont_gl_seq;	 	
		param += "&SUBJECT="+subject;	
		param += "&CONT_AMT="+cont_amt;	 
		
		if (confirm("<%=text.get("CT_020.MSG_002")%>")){	//결재요청 하시겠습니까?
	   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
			var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_list?cols_ids="+cols_ids+"&mode=approval"+param);
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	   }
	}
	
	// 변경계약서 생성
	function doChange(){
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
        
        var	cont_no     = "";
        var	ct_flag     = "";
        var	cont_gl_seq = "";
		var max_cnt     = "";
		var max_ct_flag = "";
		
		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
			ct_flag         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
			cont_gl_seq     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			max_cnt         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("MAX_CNT")).getValue());			
			max_ct_flag     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("MAX_CT_FLAG")).getValue());
		}
		
		var stringStr = max_cnt.split(',');
		
		if( cont_gl_seq != "001"){
			alert("계약차수가 001인 원본 계약서만 변경계약이 가능합니다.");
			return;
		}
		
		if( max_cnt != "001" && max_ct_flag != "CD"){
			alert("현재 " + max_cnt + "인 계약차수로 진행중인 계약서가 있습니다.");
			return;			
		}	
		
		if( ct_flag != "CD" ) {
			alert("계약서상태가 우리은행인증인 건만 계약서변경이 가능합니다.");
			return;
		}
		
		var param   = "?cont_no="			+ encodeUrl(cont_no);
			param  += "&cont_gl_seq="		+ encodeUrl(cont_gl_seq);
		
		if( confirm("계약서를 변경하시겠습니까?") ) {
			location.href = "change_contract.jsp"+ param;
		}		
	}
	
	function doDrop(){
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
        
       	var ct_flag = "";
       	var sign_status = "";
        
		for(var i = 0; i < grid_array.length; i++)
		{
			ct_flag         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
// 			sign_status = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue()));
		}
		
// 		if(sign_status != "R") {
			
			// 우리은행인증, 업체인증, 업체전송, 업체변경요청 인 경우
			if( ct_flag == "CD" || ct_flag == "CC" || ct_flag == "CB" || ct_flag == "CE" ){

			}else{
				alert("계약서의 상태가 우리은행인증, 업체인증, 업체전송, 업체변경요청인 경우에만 계약폐기요청이 가능합니다.");
				return;			
			}
// 		}
		if( confirm("계약서를 폐기요청 하시겠습니까?") ) {
			var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_list?cols_ids="+cols_ids+"&mode=drop&ct_flag=CR");
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}	        		
	}	
	
	function doContractDelete() {
	
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
        
       	var cont_no = "";
       	var cont_gl_seq = "";
       	var ct_flag = "";
       	var sign_status = "";
        
		for(var i = 0; i < grid_array.length; i++)
		{
			cont_no         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
			cont_gl_seq     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
			ct_flag         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue());
// 			sign_status 	= encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SIGN_STATUS")).getValue()));
		}
		
		if(ct_flag != "CV") {
				alert("계약서의 상태가 폐기승인인 경우에만 계약폐기가 가능합니다.");
				return;	
		}
		
		if (confirm("계약서를 폐기 하시겠습니까?")) {
			var param = "&ct_flag=CL";
			var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_list?cols_ids="+cols_ids+"&mode=delete"+param);
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
	}
	function doDelete_reject(){
		document.form.delete_confirm.value="";
		 
        var width = 700;
    	var height = 150;
        var left = "";
		var top = "";
	
	    //화면 가운데로 배치
	    var dim = new Array(2);
	
		dim = ToCenter(height,width);
		top = dim[0];
		left = dim[1];
	
	    var toolbar = 'no'; 
	    var menubar = 'no';
	    var status = 'yes';
	    var scrollbars = 'yes';
	    var resizable = 'yes';
	    
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var checked_count;

		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
         
		for(var i = 0; i < grid_array.length; i++)
		{
			delete_confirm         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("REJECT_REASON")).getValue()); 
		}
		var param   = "?delete_confirm="			+ encodeUrl(delete_confirm);
	    delete_confirm_pop = window.open("contract_delete_confirm.jsp"+param, 'DELETE_CONFIRM', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	    delete_confirm_pop.focus();
        
	}
	
	function nextAjax( type ){
		var f = document.forms[0];
		
		if( type == '2' ){
			var sg_refitem  = f.sg_type1.value;
			var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
			
			sg_type2_id.options.length = 0;    //길이 0으로
//			sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
			}
			else{
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
		else if( type == '3' ){
			var sg_refitem  = f.sg_type2.value;
			var sg_type3_id = eval(document.getElementById('sg_type3')); //id값 얻기
			
			sg_type3_id.options.length = 0;     //길이 0으로
//			sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type3_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ) {
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '3'+'#'+sg_refitem ,'sg_type3', '' );
			}
			else{
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
	}	
	
	function SP9113_Popup() {
		/*
		var arrValue = new Array();
		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "<%=info.getSession("COMPANY_CODE")%>";
		arrValue[2] = "";
		arrValue[3] = "";
		var arrDesc = new Array();
		arrDesc[0] = "아이디";
		arrDesc[1] = "이름";
		PopupCommonArr("SP9113","SP9113_getCode",arrValue,arrDesc);
		*/
		window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}

	function  SP9113_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {
		document.forms[0].ctrl_person_id.value         = ls_ctrl_person_id;
		document.forms[0].ctrl_person_name.value       = ls_ctrl_person_name;
	}	
	
	function getVendorCode(setMethod) { popupvendor(setMethod); }
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = desc1;
	}

	function popupvendor( fun )
	{
	    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}	
	//지우기
	function doRemove( type ){
	    if( type == "ctrl_person_id" ) {
	    	document.forms[0].ctrl_person_id.value = "";
	        document.forms[0].ctrl_person_name.value = "";
	    }  
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }
	}

	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        doQuery();
	    }
	}
	
	<%-- ClipReport4 리포터 호출 스크립트 --%>
	function clipPrint(rptAprvData,approvalCnt) {
		var sRptData = "";
		var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
		var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
		var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
		
		sRptData += document.form.from_date.value;	//계약작성일 from
		sRptData += " ~ ";
		sRptData += document.form.to_date.value;	//계약작성일 to
		sRptData += rf;
		sRptData += document.form.ctrl_person_id.value;	//계약담당자1
		sRptData += rf;
		sRptData += document.form.ctrl_person_name.value;	//계약담당자2
		sRptData += rf;
		sRptData += document.form.cont_no.value;	//계약번호
		sRptData += rf;
		sRptData += document.form.seller_code.value;	//업체명1
		sRptData += rf;
		sRptData += document.form.seller_name.value;	//업체명2
		sRptData += rf;
		sRptData += document.form.ele_cont_flag.options[document.form.ele_cont_flag.selectedIndex].text;	//전자계약여부
		sRptData += rf;
		sRptData += document.form.subject.value;	//계약명
		sRptData += rf;
		if(document.form.sg_type1.value == ""){
			sRptData += "";	
		}else{
			sRptData += document.form.sg_type1.options[document.form.sg_type1.selectedIndex].text;	//계약구분 1
		}
		sRptData += "   ";
		if(document.form.sg_type2.value == ""){
			sRptData += "";	
		}else{
			sRptData += document.form.sg_type2.options[document.form.sg_type2.selectedIndex].text;	//계약구분 2
		}
		sRptData += "   ";
		if(document.form.sg_type3.value == ""){
			sRptData += "";	
		}else{
			sRptData += document.form.sg_type3.options[document.form.sg_type3.selectedIndex].text;	//계약구분 3
		}
		sRptData += rd;
				
		for(var i = 0; i < GridObj.GetRowCount(); i++){
			sRptData += GridObj.GetCellValue("CONT_NO",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("CONT_GL_SEQ",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("SG_LEV",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("SUBJECT",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("SELLER_CODE_TEXT",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("CT_NAME",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("CONT_AMT",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("CONT_ADD_DATE",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("EXEC_NO",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("EXEC_USER_ID",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("EXEC_USER_NAME",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("LAST_SIGN_USER_ID",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("LAST_SIGN_USER_NAME",i);
			sRptData += rl;				
		}	

		document.form.rptData.value = sRptData;
		
		if(typeof(rptAprvData) != "undefined"){
			document.form.rptAprvUsed.value = "Y";
			document.form.rptAprvCnt.value = approvalCnt;
			document.form.rptAprv.value = rptAprvData;
	    }
	    var url = "/ClipReport4/ClipViewer.jsp";
		//url = url + "?BID_TYPE=" + bid_type;	
	    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		document.form.method = "POST";
		document.form.action = url;
		document.form.target = "ClipReport4";
		document.form.submit();
		cwin.focus();
	}

</script>
</head>

<body leftmargin="15" topmargin="6"
	onload="setGridDraw();initAjax();doQuery();">
	<s:header>
		<form id="form" name="form">
			<%--ClipReport4 hidden 태그 시작--%>
			<input type="hidden" name="rptName" id="rptName"
				value="<%=_rptName%>"> <input type="hidden" name="rptData"
				id="rptData"
				value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
			<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y"> <input
				type="hidden" name="rptAprvUsed" id="rptAprvUsed"> <input
				type="hidden" name="rptAprvCnt" id="rptAprvCnt"> <input
				type="hidden" name="rptAprv" id="rptAprv">
			<%--ClipReport4 hidden 태그 끝--%>
			<%@ include file="/include/sepoa_milestone.jsp"%>
			<table width="99%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="5">&nbsp;</td>
				</tr>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="1" cellpadding="0"
							bgcolor="#dedede">
							<tr>
								<td width="100%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="20%" class="title_td">&nbsp;<img
												src="/images/blt_srch.gif" width="7" height="7"
												align="absmiddle">&nbsp;&nbsp; 계약작성일
											</td>
											<td width="30%" class="data_td"><s:calendar
													id_from="from_date" id_to="to_date"
													default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"
													default_to="<%=SepoaString.getDateSlashFormat(to_date)%>"
													format="%Y/%m/%d" /></td>
											<td width="20%" class="title_td">&nbsp;<img
												src="/images/blt_srch.gif" width="7" height="7"
												align="absmiddle">&nbsp;&nbsp; 계약담당자
											</td>

											<td class="data_td" width="35%"><b><input
													type="text" name="ctrl_person_id" id="ctrl_person_id"
													value="<%=info.getSession("ID")%>" size="15"
													class="inputsubmit" readonly="readonly"
													onkeydown='entKeyDown()'> <a
													href="javascript:SP9113_Popup();"><img
														src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
													<a href="javascript:doRemove('ctrl_person_id')"><img
														src="<%=POASRM_CONTEXT_NAME%>/images/button/ico_x2.gif"
														align="absmiddle" border="0"></a> <input type="text"
													name="ctrl_person_name" id="ctrl_person_name" size="20"
													value="<%=info.getSession("NAME_LOC")%>" readOnly
													onkeydown='entKeyDown()'></b></td>
										</tr>
										<tr>
											<td colspan="6" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td width="20%" class="title_td">&nbsp;<img
												src="/images/blt_srch.gif" width="7" height="7"
												align="absmiddle">&nbsp;&nbsp; 계약번호
											</td>
											<td width="30%" class="data_td"><input type="text"
												id="cont_no" name="cont_no" style="ime-mode: inactive"
												onkeydown='entKeyDown()'></td>
											<td width="20%" class="title_td">&nbsp;<img
												src="/images/blt_srch.gif" width="7" height="7"
												align="absmiddle">&nbsp;&nbsp; 업체명
											</td>

											<td class="data_td" width="35%"><input type="text"
												name="seller_code" id="seller_code" size="15"
												class="inputsubmit" maxlength="10" readonly="readonly"
												onkeydown='entKeyDown()'> <a
												href="javascript:getVendorCode('setVendorCode')"><img
													src="/images/ico_zoom.gif" width="19" height="19"
													align="absmiddle" border="0"></a> <a
												href="javascript:doRemove('seller_code')"><img
													src="<%=POASRM_CONTEXT_NAME%>/images/button/ico_x2.gif"
													align="absmiddle" border="0"></a> <input type="text"
												name="seller_name" id="seller_name" size="20"
												readonly="readonly" onkeydown='entKeyDown()'></td>

										</tr>
										<tr>
											<td colspan="6" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td width="20%" class="title_td">&nbsp;<img
												src="/images/blt_srch.gif" width="7" height="7"
												align="absmiddle">&nbsp;&nbsp; 전자계약여부
											</td>
											<td width="30%" class="data_td" colspan="3"><select
												id="ele_cont_flag" name="ele_cont_flag">
													<option value="">전체</option>
													<option value="Y">Yes</option>
													<option value="N">No</option>
											</select></td>
											<!--         							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; -->
											<!--         								상태 -->
											<!--         							</td> -->
											<!--         							<td width="30%"  class="data_td"> -->
											<%--         								<select id="status" name="status"> --%>
											<!--         									<option value="">전체</option> -->
											<%--         								</select> --%>
											<!--         							</td>        		 -->
										</tr>
										<tr>
											<td colspan="6" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td width="20%" class="title_td">&nbsp;<img
												src="/images/blt_srch.gif" width="7" height="7"
												align="absmiddle">&nbsp;&nbsp; 계약명
											</td>
											<td width="30%" class="data_td"><input type="text"
												id="subject" name="subject" style="width: 150px;"
												onkeydown='entKeyDown()' /></td>
											<td width="20%" class="title_td">&nbsp;<img
												src="/images/blt_srch.gif" width="7" height="7"
												align="absmiddle">&nbsp;&nbsp; 계약구분
											</td>
											<td width="30%" class="data_td"><select id="sg_type1"
												name="sg_type1" class="inputsubmit"
												onchange="nextAjax('2');">
													<option value="">--------</option>
											</select> <select id="sg_type2" name="sg_type2" class="inputsubmit"
												onchange="nextAjax('3');">
													<option value="">--------</option>
											</select> <select id="sg_type3" name="sg_type3" class="inputsubmit">
													<option value="">--------</option>
											</select></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				<TR>
					<td style="padding: 5 5 5 0" align="right">
						<TABLE cellpadding="2" cellspacing="0">
							<TR>
								<td><script language="javascript">btn("javascript:doQuery()"			,"조 회")			</script></td>
								<td><script language="javascript">btn("javascript:clipPrint()","출 력")		</script></td>
							</TR>
						</TABLE>
					</td>
				</TR>
			</TABLE>
		</form>
	</s:header>
	<s:grid screen_id="CT_020" grid_box="gridbox" grid_obj="GridObj" />
	<s:footer />
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0"
	height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>