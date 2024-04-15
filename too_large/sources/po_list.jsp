<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%

	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(to_day,-3));
	String to_date = SepoaString.getDateSlashFormat(to_day);
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<!-- 2011-03-08 solarb -->
<!-- form hidden 처리, 그리드 컬럼 길이 0으로-->


<%
	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String house_code      = info.getSession("HOUSE_CODE");
	String menu_profile_code = info.getSession("MENU_PROFILE_CODE");
	String toDays          = SepoaDate.getShortDateString();
	String toDays_1        = SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");
	String G_IMG_ICON="";
	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 작성 사용여부
	// wise.properties의 wise.po.contract.use.#HOUSE_CODE# = true/false 에 따라 옵션으로 진행한다.
	
	Config wise_conf = new Configuration();
	boolean po_contract_use_flag = false;
	try {
		po_contract_use_flag = wise_conf.getBoolean("wise.po.contract.use." + info.getSession("HOUSE_CODE")); //발주 전자계약 사용여부
	} catch (Exception e) {
		po_contract_use_flag = false;
	}
	
	String[] ctrl_codes = info.getSession("CTRL_CODE").split("&");
	String ctrl_yn = "N";
	for(int v1=0; v1 < ctrl_codes.length; v1++){
		if(ctrl_codes[v1].equals("P01")){
			ctrl_yn = "Y";
			break;
		}
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">

	<%-- var	servletUrl = "<%=getWiseServletPath("order.bpo.po3_bd_lis1")%>"; --%>
	var mode;
	var checked_count = 0;

	var IDX_SEL                ;
	var IDX_SIGN_NAME          ;
	var IDX_PO_NO              ;
	var IDX_EXEC_NO            ;
	var IDX_PO_CREATE_DATE     ;
	var IDX_VENDOR_CODE        ;
	var IDX_VENDOR_NAME        ;
	var IDX_CUR                ;
	var IDX_PO_TTL_AMT         ;
	var IDX_CTRL_CODE          ;
	var IDX_CONFIRM_FLAG       ;
	var IDX_CONFIRM_DATE_TIME  ;
	var IDX_COMPLETE_MARK_TEXT ;
	var IDX_SIGN_STATUS        ;
	var IDX_PR_INFO            ;
	var IDX_PR_NO              ;
	var IDX_PR_SEQ             ;
	var IDX_COMPLETE_MARK      ;
	var IDX_BSART      		;
	var IDX_PO_TYPE;
	var IDX_EVAL_FLAG_DESC	;
	var IDX_SUBJECT;
	var IDX_EVAL_FLAG;
	var IDX_EVAL_REFITEM;
	var IDX_EVAL_ITEM_REFITEM;
	var IDX_EVAL_VALUER_REFITEM;
	var IDX_E_TEMPLATE_REFITEM;
	var IDX_TEMPLATE_TYPE;
	

	var chkrow;
	
	
	function init()	{
		doRequestUsingPOST( 'SL0018', "<%=house_code%>"+'#M040' ,'material_type', '' );
		setGridDraw();
		setHeader();
		doSelect();
	
	}

	function setHeader() {
	<%-- 	var f0 = document.forms[0];

		f0.po_from_date.value = "<%=toDays_1%>";
		f0.po_to_date.value   = "<%=toDays%>"; --%>


		// 2011-03-08 Class hidden

		// 2011-03-08 계약여부~영업부서 hidden


		
		
		//발주 수정을 위한 추가정보
		


	/* 	GridObj.SetColCellSortEnable("PO_CREATE_DATE"		,false);
		GridObj.SetColCellSortEnable("CUR"				,false);
		GridObj.SetColCellSortEnable("PO_TTL_AMT"			,false);
		GridObj.SetColCellSortEnable("CTRL_CODE"			,false);
		GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd");
		GridObj.SetDateFormat("GAP_SIGN_DATE"		,"yyyy/MM/dd");
		GridObj.SetNumberFormat("PO_TTL_AMT"		,G_format_amt);
		GridObj.SetNumberFormat("TOTAL_AMT"		,G_format_amt);
 */

		IDX_SEL					= GridObj.GetColHDIndex("SEL"					);
		IDX_PO_NO				= GridObj.GetColHDIndex("PO_NO"				);
		IDX_EXEC_NO				= GridObj.GetColHDIndex("EXEC_NO"				);
		IDX_PO_CREATE_DATE	    = GridObj.GetColHDIndex("PO_CREATE_DATE"	    );
		IDX_VENDOR_NAME			= GridObj.GetColHDIndex("VENDOR_NAME"			);
		IDX_CTRL_CODE			= GridObj.GetColHDIndex("CTRL_CODE"			);
		IDX_PR_TYPE				= GridObj.GetColHDIndex("PR_TYPE"				);
		IDX_ORDER_NO			= GridObj.GetColHDIndex("ORDER_NO"			);
		IDX_TAKE_USER_NAME	    = GridObj.GetColHDIndex("TAKE_USER_NAME"	    );
		IDX_CUR					= GridObj.GetColHDIndex("CUR"					);
		IDX_PO_TTL_AMT		    = GridObj.GetColHDIndex("PO_TTL_AMT"		    );
		IDX_VENDOR_CODE			= GridObj.GetColHDIndex("VENDOR_CODE"			);
		IDX_COMPLETE_MARK		= GridObj.GetColHDIndex("COMPLETE_MARK"		);
		IDX_PO_TYPE				= GridObj.GetColHDIndex("PO_TYPE"				);
		IDX_EVAL_FLAG_DESC		= GridObj.GetColHDIndex("EVAL_FLAG_DESC"		);
		IDX_SUBJECT				= GridObj.GetColHDIndex("SUBJECT"		);
		IDX_EVAL_FLAG			= GridObj.GetColHDIndex("EVAL_FLAG"		);
		IDX_EVAL_REFITEM		= GridObj.GetColHDIndex("EVAL_REFITEM"		);
		IDX_EVAL_ITEM_REFITEM	= GridObj.GetColHDIndex("EVAL_ITEM_REFITEM"		);
		IDX_EVAL_VALUER_REFITEM	= GridObj.GetColHDIndex("EVAL_VALUER_REFITEM"		);
		IDX_E_TEMPLATE_REFITEM	= GridObj.GetColHDIndex("E_TEMPLATE_REFITEM"		);
		IDX_TEMPLATE_TYPE		= GridObj.GetColHDIndex("TEMPLATE_TYPE"		);
	}

	function doSelect() {
		
	 	var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getPoList&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_list";
	
		
		GridObj.post(url, param);
		GridObj.clearAll(false);	 
		
		
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		var f0              = document.forms[0];
		var row             = GridObj.GetRowCount();
		var po_no           = "";
		var shipper         = "";
		var sign_flag       = "";

		if (msg1 == "doData") {
			alert(GD_GetParam(GridObj,"0"));

			if (GridObj.GetStatus()==1)
				doSelect();
		}

		/* if (msg1 == "t_imagetext") {
			
		    
		} */
	}

	function doUpdate()
	{
		if (!checkUser()) return;
		
		var wise 		  = GridObj;
		var rowCount 	  = wise.GetRowCount();
		var selectedRow   = -1;
		var po_no		  = "";
		var sign_status   = "";
		var complete_mark = "";
		var confirm_flag  = "";
		var del_flag 	  = "";
		var ctrl_code	  = "";
		var po_type		  = "";

	    var iCheckedRow = Number(checkedOneRow('SEL'))-1;
		
	    if(iCheckedRow < 0)
	        return; 
	    
		po_no 			= wise.GetCellValue("PO_NO",iCheckedRow);
		sign_status 	= wise.GetCellValue("SIGN_STATUS",iCheckedRow);
		complete_mark 	= wise.GetCellValue("COMPLETE_MARK",iCheckedRow);
		confirm_flag	= wise.GetCellValue("CONFIRM_FLAG",iCheckedRow);
		del_flag        = wise.GetCellValue("DEL_FLAG" , iCheckedRow);
		ctrl_code   	= wise.GetCellValue("CTRL_CODE",iCheckedRow);
		po_type			= wise.GetCellValue("PO_TYPE",iCheckedRow);

		if(confirm_flag != "R" && confirm_flag != "T") {
			alert("진행상태가 작성중이거나 반송된 건만 수정이 가능합니다.");
			return;
		}
		if (complete_mark == "Y") {
			alert("이미 완료된 발주 입니다.");
			return;
		}

		if (complete_mark == "YY") {
			alert("이미 종결된 발주 입니다.");
			return;
		}

		if (del_flag == "N") {
			alert("검수정보가 생성된 발주건은 수정 할 수 없습니다.");
			return;
		}  
		
		// 협력업체 전송완료 (SIGN_STATUS=E)
		// 협력사미확인(CONFIRM_FLAG=N), 협력사확인(CONFIRM_FLAG=Y), 협력사반송(CONFIRM_FLAG=R)
		  if (sign_status == "E") {
			if (confirm_flag == "N") { // 미확인
				alert("협력사 전송이 완료된 발주건은 수정할 수 없습니다.");
				return;
			}
			if (confirm_flag == "Y") { // 확인완료
				alert("협력사에서 확인완료한 발주건은 수정할 수 없습니다.");
				return;
			}
		}  
		
		var t_url = "";
		
		if ( po_type == "D" || po_type == "M") {
			alert("어?");<%-- 알림창 메세지 수정필요함~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!! --%>
			//	t_url 	 = "po_update.jsp?po_no="+po_no;  //직발주,메뉴얼발주 수정
		} else {
			t_url 	 = "po_update.jsp?po_no="+po_no;  //품의발주 수정
		}
		
    	location.href = t_url;
	}

	function doDelete()
	{
		if (!checkUser()) return;
		
		var wise 		= GridObj;
		var rowCount 	= wise.GetRowCount();
		var selectedRow = -1;
		var po_no		= "";
		var sign_status = "";
		var del_flag    = "";
		var ctrl_code	= "";
		var contract_flag = "";
		for( i = 0 ; i < rowCount ; i++) {
			if(1==wise.GetCellValue("SEL",i)) {
				selectedRow = i;
				po_no 		= wise.GetCellValue("PO_NO",i);
				sign_status = wise.GetCellValue("SIGN_STATUS",i);
				confirm_flag = wise.GetCellValue("CONFIRM_FLAG",i);
				del_flag    = wise.GetCellValue("DEL_FLAG",i);
				ctrl_code   = wise.GetCellValue("CTRL_CODE",i);
				contract_flag = wise.GetCellValue("CONTRACT_FLAG",i);
				
				// T : 작성중, P : 결재중
				if(sign_status == "P"){
					alert("진행상태가 [결재중]인 발주건은 삭제할 수 없습니다.");
					return;
				}
				/*
				else if( confirm_flag == 'Y'){
					alert("확인 완료된 건은 삭제할 수 없습니다.");
					return;					
				}
				*/
				
				if (del_flag == "N" ) {
					//alert("매입계산서가 생성되어 있는 발주는 \n 삭제 할 수 없습니다.");
					alert("검수정보가  생성되어 있는 발주는 삭제 할 수 없습니다.");
					return;
				}
				
				if(contract_flag == "Y"){
					alert("계약 체결 발주건은 삭제 할 수 없습니다.");
					return;
				}
				
			}
		}

		if (selectedRow == -1) {
			alert("발주번호를 선택해주세요.")
			return;
		}

		if (confirm("정말 삭제 하시겠습니까?")) {
			GridObj.SetParam("mode" , "setPoDelete");
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl,"ALL","ALL");
			GridObj.strHDClickAction="sortmulti";
		}
	}
	//직무권한 체크
	function checkUser() {
		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = true;

		for(var row = 0; row < GridObj.GetRowCount(); row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
				for( i=0; i<ctrl_code.length; i++ )
				{
					if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, IDX_CTRL_CODE)) {
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

	function po_valid_from_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.po_from_date.value = year+month+day;
	}

	function po_valid_to_date(year,month,day,week) {
	    var f0 = document.forms[0];
	    f0.po_to_date.value = year+month+day;
	}

	function cont_valid_from_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.cont_from_date.value = year+month+day;
	}

	function cont_valid_to_date(year,month,day,week) {
	    var f0 = document.forms[0];
	    f0.cont_to_date.value = year+month+day;
	}

	function cont_sign_valid_from_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.cont_sign_from_date.value = year+month+day;
	}

	function cont_sign_valid_to_date(year,month,day,week) {
	    var f0 = document.forms[0];
	    f0.cont_sign_to_date.value = year+month+day;
	}

	function getVendorCode(setMethod) {
		popupvendor(setMethod);
	}

	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = desc1;
	}

	function popupvendor( fun ) {
		window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}

	function checkedRow() {
		var sendRow = "" ;
		var row = GridObj.GetRowCount() ;

		for (var i=0; i<row; i++) {
			check = GD_GetCellValueIndex(GridObj,i,IDX_SEL) ;
			if (check == "true") {
				sendRow += (i+"&") ;
			}
		}

		return sendRow ;
	}
	//담당자
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
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
		document.form1.ctrl_code.value = ls_ctrl_code;
		document.form1.ctrl_name.value = ls_ctrl_name;
	}
	//담당자
	function SP0371_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0371&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function  SP0371_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {
		form1.ctrl_person_id.value = ls_ctrl_person_id;
		form1.ctrl_person_name.value = ls_ctrl_person_name;

	}

	function PopupManager(part) {
		var url = "";
		var f = document.forms[0];

		if(part == "REQ_DEPT") {
			window.open("/common/CO_009.jsp?callback=getReqDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "SALES_DEPT") {
			window.open("/common/CO_009.jsp?callback=getSalesDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "DEMAND_DEPT") {
			window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "ADD_USER_ID") {
			window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		else if(part == "ctrl_person_id")
		{
			window.open("/common/CO_008.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		//구매담당직무
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
		}
	}
	
	function getCtrlUser(code, text) {
		document.form1.ctrl_person_id.value = code;
		document.form1.ctrl_person_name.value = text;
	}

	//구매담당직무
	function getCtrlManager(code, text)
	{
		document.form1.ctrl_code.value = code;
		document.form1.ctrl_name.value = text;
	}

	function getDemand(code, text) {
		document.forms[0].demand_dept_name.value = text;
		document.forms[0].demand_dept.value = code;
	}

	function getAddUser(code, text) {
		document.forms[0].add_user_name.value = text;
		document.forms[0].add_user_id.value = code;
	}
	
	function getCtrlPerson(code, text ,code1, text1)
	{
		document.forms[0].ctrl_person_name.value = text1;
		document.forms[0].ctrl_person_id.value = code1;
	}

	function getReqDept(code, text) {
		document.forms[0].req_dept_name.value = text;
		document.forms[0].req_dept.value = code;
	}

	function getSalesDept(code, text) {
		document.forms[0].sales_dept_name.value = text;
		document.forms[0].sales_dept.value = code;
	}

	function MATERIAL_TYPE_Changed() {
    	clearMATERIAL_CTRL_TYPE();
    	clearMATERIAL_CLASS1();
    	var newOption = document.createElement('OPTION');
    	newOption.text="전체";
    	newOption.value="";
    	var house_code = "<%=house_code%>";
    	var code = "M041";
    	var value = form1.material_type.value;
    	document.form1.material_ctrl_type.add(newOption, null);
    	doRequestUsingPOST( 'SL0009', house_code+'#'+code+'#'+value ,'material_ctrl_type','' );

    	
    /* 	var id = "SL0009";
   		var code = "M041";
    	var value = form1.material_type.value;
    	target = "MATERIAL_TYPE";
    	data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    	work_frame.location.href = data; */
	}

	function MATERIAL_CTRL_TYPE_Changed() {
		clearMATERIAL_CLASS1();
		
		//var id = "SL0019";
		var code = "M042";
		var house_code = "<%=house_code%>";
		var value = form1.material_type.value;
		//var code = "M042";
		//var value = form1.material_ctrl_type.value;
		//target = "MATERIAL_CTRL_TYPE";
		var newOption = document.createElement('OPTION');
		newOption.text="전체";
		newOption.value="";
		document.form1.material_class1.add(newOption, null);
		doRequestUsingPOST( 'SL0020', house_code+'#'+code+'#'+value ,'material_class1','' );
		/* data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
		work_frame.location.href = data; */
	}

	function setMATERIAL_CTRL_TYPE(name, value) {
		var option1 = new Option(name, value, true);
		form1.material_ctrl_type.options[form1.material_ctrl_type.length] = option1;
	}

	function setMATERIAL_CLASS1(name, value) {
		var option1 = new Option(name, value, true);
		form1.material_class1.options[form1.material_class1.length] = option1;
	}

	function clearMATERIAL_CTRL_TYPE() {
		if(form1.material_ctrl_type.length > 0) {
			for(i=form1.material_ctrl_type.length-1; i>=0;  i--) {
				form1.material_ctrl_type.options[i] = null;
			}
		}
	}

	function clearMATERIAL_CLASS1() {
		if(form1.material_class1.length > 0) {
			for(i=form1.material_class1.length-1; i>=0;  i--) {
				form1.material_class1.options[i] = null;
			}
		}
	}

	function searchCust() {
		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0120F&function=scms_getCust&values=&values=/&desc=고객사코드&desc=고객사명";
		Code_Search(url,'','','','','');
	}

	function scms_getCust(code, text, div) {
		document.form1.cust_type.value = div;
		document.form1.cust_code.value = code;
		document.form1.cust_name.value = text;
	}

	/* 발주중도종결 */
	function doIngStop()
	{
		var isSelected = false;
		var iRowCount  = GridObj.GetRowCount();
		
		for(var i=0;i<iRowCount;i++){
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == true){
				isSelected = true;

				break;
			}
		}

		if(isSelected == false) {
			alert('선택된 행이 없습니다.');
			return;
		}

		if (!checkUser()) return;
		
		var wise 		  = GridObj;
		var rowCount 	  = wise.GetRowCount();
		var selectedRow   = -1;
		var po_no		  = "";
		var sign_status   = "";
		var complete_mark = "";
		var del_flag 	  = "";
		var ctrl_code	  = "";
		var stop_flag	  = "";
		var wk_type       = "";
	
	    //var iCheckedRow = checkedOneRow(IDX_SEL);
	    var iCheckedRow = Number(checkedOneRow('SEL'))-1;
	    if(iCheckedRow < 0)
	        return;

		po_no 			= wise.GetCellValue("PO_NO",iCheckedRow);
		sign_status 	= wise.GetCellValue("SIGN_STATUS",iCheckedRow);
		confirm_flag 	= wise.GetCellValue("CONFIRM_FLAG",iCheckedRow);
		complete_mark 	= wise.GetCellValue("COMPLETE_MARK",iCheckedRow);
		del_flag        = wise.GetCellValue("DEL_FLAG" , iCheckedRow);
		ctrl_code   	= wise.GetCellValue("CTRL_CODE",iCheckedRow);
		stop_flag 		= wise.GetCellValue("STOP_FLAG",iCheckedRow);
		wk_type         = "1";
		/*
		if(sign_status != "R" && sign_status != "T"){
			alert("반송중이거나 작성중인 건만 수정이 가능합니다.");
			return;
		}*/

		//if( confirm_flag == 'N' || stop_flag == 'N'){
		if(stop_flag == 'N'){			
			alert("검수요청된 건에 대해서만 중도종결이 가능합니다.");
			return;
		}
		if(complete_mark == "Y"){
			alert("이미 완료된 발주 입니다.");
			return;
		}
		if(complete_mark == "YY"){
			alert("이미 종결된 발주 입니다.");
			return;
		}
		/*
		if(del_flag == "N"){
			alert("검수정보가 생성된 발주건은 \n수정 할 수 없습니다..");
			return;
		}
		*/
		var t_url = "/kr/order/bpo/po1_bd_upd3.jsp";
		var param = "";
			param +="?po_no="+po_no;
			param +="&wk_type="+wk_type;
		if(confirm("발주 중도종결 하시겠습니까?")){
    		window.open(t_url+param,"","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}
	}

	//연단가발주취소
	function yrpoCancel() {
	    var iCheckedRow = Number(checkedOneRow('SEL'))-1;
	    if(iCheckedRow < 0)
	        return;		

		if (!checkUser()) return;
		
		var wise 		      = GridObj;
		var rowCount 	      = wise.GetRowCount();
		var selectedRow       = -1;
		var po_no		      = "";
		var sign_status       = "";
		var complete_mark     = "";
		var del_flag 	      = "";
		var ctrl_code	      = "";
		var stop_flag	      = "";
		var pr_no             = "";
		var exec_no			  = "";
		var yr_unit_pr_ord_gb = "";
		var prdt_pr_seq       = "";
		var wk_type           = "";

		po_no 			  = wise.GetCellValue("PO_NO",iCheckedRow);
		sign_status 	  = wise.GetCellValue("SIGN_STATUS",iCheckedRow);
		confirm_flag 	  = wise.GetCellValue("CONFIRM_FLAG",iCheckedRow);
		complete_mark 	  = wise.GetCellValue("COMPLETE_MARK",iCheckedRow);
		del_flag          = wise.GetCellValue("DEL_FLAG" , iCheckedRow);
		ctrl_code   	  = wise.GetCellValue("CTRL_CODE",iCheckedRow);
		stop_flag 		  = wise.GetCellValue("STOP_FLAG",iCheckedRow);
		pr_no 			  = wise.GetCellValue("PR_NO",iCheckedRow);
		exec_no 		  = wise.GetCellValue("EXEC_NO",iCheckedRow);
		yr_unit_pr_ord_gb = wise.GetCellValue("YR_UNIT_PR_ORD_GB",iCheckedRow);
		prdt_pr_seq 	  = wise.GetCellValue("PRDT_PR_SEQ",iCheckedRow);
		wk_type           = "2";

		if(yr_unit_pr_ord_gb != "Y") {
			alert("연단가발주 대상이 아닙니다.");
			return;
		}
		/*if(confirm_flag == "Y") {
			alert("업체수주전에만 연단가발주취소가 가능합니다.");
			return;
		}*/
		if(complete_mark == "Y"){
			alert("이미 완료된 발주 입니다.");
			return;
		}
		if(complete_mark == "YY"){
			alert("이미 종결된 발주 입니다.");
			return;
		}
		/*
		if(stop_flag == "Y") {
			alert("검수진행 건은 발주취소(연단가)가 불가합니다.");
			return;
		}
        */
		var t_url = "/kr/order/bpo/po1_bd_upd3.jsp";
		var param = "";
			param +="?po_no="+po_no;
			param +="&pr_no="+pr_no;
			param +="&exec_no="+exec_no;
			param +="&yr_unit_pr_ord_gb="+yr_unit_pr_ord_gb;
			param +="&prdt_pr_seq="+prdt_pr_seq;
			param +="&wk_type="+wk_type;

			if(confirm("발주취소(연단가)를 하시겠습니까?")){
    		window.open(t_url+param,"","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}
	}
	
	//발주취소(기안생성)
	function expoCancel() {
	    var iCheckedRow = Number(checkedOneRow('SEL'))-1;
	    if(iCheckedRow < 0)
	        return;		

		if (!checkUser()) return;
		
		var wise 		      = GridObj;
		var rowCount 	      = wise.GetRowCount();
		var selectedRow       = -1;
		var po_no		      = "";
		var sign_status       = "";
		var complete_mark     = "";
		var del_flag 	      = "";
		var ctrl_code	      = "";
		var stop_flag	      = "";
		var pr_no             = "";
		var exec_no			  = "";
		var yr_unit_pr_ord_gb = "";
		var prdt_pr_seq       = "";
		var wk_type           = "";

		po_no 			  = wise.GetCellValue("PO_NO",iCheckedRow);
		sign_status 	  = wise.GetCellValue("SIGN_STATUS",iCheckedRow);
		confirm_flag 	  = wise.GetCellValue("CONFIRM_FLAG",iCheckedRow);
		complete_mark 	  = wise.GetCellValue("COMPLETE_MARK",iCheckedRow);
		del_flag          = wise.GetCellValue("DEL_FLAG" , iCheckedRow);
		ctrl_code   	  = wise.GetCellValue("CTRL_CODE",iCheckedRow);
		stop_flag 		  = wise.GetCellValue("STOP_FLAG",iCheckedRow);
		pr_no 			  = wise.GetCellValue("PR_NO",iCheckedRow);
		exec_no 		  = wise.GetCellValue("EXEC_NO",iCheckedRow);
		yr_unit_pr_ord_gb = wise.GetCellValue("YR_UNIT_PR_ORD_GB",iCheckedRow);
		prdt_pr_seq 	  = wise.GetCellValue("PRDT_PR_SEQ",iCheckedRow);
		wk_type           = "4";

		if(yr_unit_pr_ord_gb == "Y") {
			alert("연단가발주건은 대상이 아닙니다.");
			return;
		}
		/*if(confirm_flag == "Y") {
			alert("업체수주전에만 연단가발주취소가 가능합니다.");
			return;
		}*/
		if(complete_mark == "Y"){
			alert("이미 완료된 발주 입니다.");
			return;
		}
		if(complete_mark == "YY"){
			alert("이미 종결된 발주 입니다.");
			return;
		}
		/*if(stop_flag == "Y") {
			alert("검수진행 건은 발주취소(기안생성)가 불가합니다.");
			return;
		}*/

		var t_url = "/kr/order/bpo/po1_bd_upd3.jsp";
		var param = "";
			param +="?po_no="+po_no;
			param +="&pr_no="+pr_no;
			param +="&exec_no="+exec_no;
			param +="&yr_unit_pr_ord_gb="+yr_unit_pr_ord_gb;
			param +="&prdt_pr_seq="+prdt_pr_seq;
			param +="&wk_type="+wk_type;

			if(confirm("발주취소(기안생성)를 하시겠습니까?")){
    		window.open(t_url+param,"","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}
	}

	//발주대기로 환원
	function poReturn() {
	    var iCheckedRow = Number(checkedOneRow('SEL'))-1;
	    if(iCheckedRow < 0)
	        return;		

		if (!checkUser()) return;
		
		var wise 		      = GridObj;
		var rowCount 	      = wise.GetRowCount();
		var selectedRow       = -1;
		var po_no		      = "";
		var sign_status       = "";
		var complete_mark     = "";
		var del_flag 	      = "";
		var ctrl_code	      = "";
		var stop_flag	      = "";
		var pr_no             = "";
		var exec_no			  = "";
		var yr_unit_pr_ord_gb = "";
		var prdt_pr_seq       = "";
		var wk_type           = "";

		po_no 			  = wise.GetCellValue("PO_NO",iCheckedRow);
		sign_status 	  = wise.GetCellValue("SIGN_STATUS",iCheckedRow);
		confirm_flag 	  = wise.GetCellValue("CONFIRM_FLAG",iCheckedRow);
		complete_mark 	  = wise.GetCellValue("COMPLETE_MARK",iCheckedRow);
		del_flag          = wise.GetCellValue("DEL_FLAG" , iCheckedRow);
		ctrl_code   	  = wise.GetCellValue("CTRL_CODE",iCheckedRow);
		stop_flag 		  = wise.GetCellValue("STOP_FLAG",iCheckedRow);
		pr_no 			  = wise.GetCellValue("PR_NO",iCheckedRow);
		exec_no 		  = wise.GetCellValue("EXEC_NO",iCheckedRow);
		yr_unit_pr_ord_gb = wise.GetCellValue("YR_UNIT_PR_ORD_GB",iCheckedRow);
		prdt_pr_seq 	  = wise.GetCellValue("PRDT_PR_SEQ",iCheckedRow);
		wk_type           = "3";
		
		if(complete_mark == "Y"){
			alert("이미 완료된 발주 입니다.");
			return;
		}
		if(complete_mark == "YY"){
			alert("이미 종결된 발주 입니다.");
			return;
		}

		var t_url = "/kr/order/bpo/po1_bd_upd3.jsp";
		var param = "";
			param +="?po_no="+po_no;
			param +="&pr_no="+pr_no;
			param +="&exec_no="+exec_no;
			param +="&yr_unit_pr_ord_gb="+yr_unit_pr_ord_gb;
			param +="&prdt_pr_seq="+prdt_pr_seq;
			param +="&wk_type="+wk_type;

			if(confirm("재발주를 위해 발주대기로 환원 하시겠습니까?")){
    		window.open(t_url+param,"","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}
	}

	//담당자
	function SP0071_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {

		document.forms[0].ctrl_code.value = ls_ctrl_code;
		document.forms[0].ctrl_name.value = ls_ctrl_name;
		document.forms[0].ctrl_person_id.value = ls_ctrl_person_id;
		document.forms[0].ctrl_person_name.value = ls_ctrl_person_name;
	}
	
	function onRefresh() {
		doSelect();
	}
	
	function entKeyDown()
	{
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	    }
	}
	
	function SP9113_Popup() {
		window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	
	function  SP9113_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {
		form1.Transfer_person_id.value   = ls_ctrl_person_id;
        form1.Transfer_person_name.value = ls_ctrl_person_name;
	}
	
	/*
     검수담당자 변경
    - 구매담당자만 사용할수 있어야 함. (수정)
	*/
	function doTransfer() {
		if (!checkUser()) return;
		
		var wise 		= GridObj;
		var rowCount 	= wise.GetRowCount();
		var selectedRow = -1;
		var po_no		= "";
		var sign_status = "";
		var complete_mark = "";
		for( i = 0 ; i < rowCount ; i++) {
			
			if(1==wise.GetCellValue("SEL",i)) {
				selectedRow = i;
				po_no 		= wise.GetCellValue("PO_NO",i);
				sign_status = wise.GetCellValue("SIGN_STATUS",i);
				complete_mark 	  = wise.GetCellValue("COMPLETE_MARK",i);
				
				// T : 작성중, P : 결재중, R : 반려
				if(sign_status == "R"){
					alert("진행상태가 [반려]인 발주는 검수담당자 변경 불가합니다.");
					return;
				}
				
				if(complete_mark == "Y"){
					alert("완료된 발주는 검수담당자 변경 불가합니다.");
					return;
				}
				if(complete_mark == "YY"){
					alert("종결된 발주 검수담당자 변경 불가합니다.");
					return;
				}
			}
		}

		if (selectedRow == -1) {
			alert("선택된 행이 없습니다.")
			return;
		}
	 
		if("<%=menu_profile_code%>" != "MUP141000001" && "<%=menu_profile_code%>" != "MUP141200004" && "<%=menu_profile_code%>" != "MUP150400001" && "<%=menu_profile_code%>" != "MUP210200001"){
	    	/*alert("검수담당자 변경은 구매담당자만 가능합니다.");*/
	    	alert("검수담당자 변경은 구매담당자,총무부-관리자만 가능합니다.");
	    	return;
	    }
		 
	    var Transfer_person_id 		= LRTrim(form1.Transfer_person_id.value);
		var Transfer_person_name 	= LRTrim(form1.Transfer_person_name.value);
		var TAKE_TEL                = LRTrim(form1.TAKE_TEL.value);
		if(Transfer_person_id == "") {
			alert("검수담당자를 입력하셔야 합니다.");
			form1.Transfer_person_id.focus();
			return;
		}
		if(TAKE_TEL == "") {
			alert(" 검수담당자 연락처를 입력하셔야 합니다.");
			form1.TAKE_TEL.focus();
			return;
		}
	
		var Message = "검수담당자를 "+Transfer_person_name+"으로 지정 하시겠습니까?";
		
		if(confirm(Message) == 1) {
			
	
			var grid_array = getGridChangedRows(GridObj, "SEL");
			var cols_ids = "<%=grid_col_id%>";
			var params;
			params = "?mode=charge_transfer";
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();
			myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_insert"+params);
			//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
			sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);			
	//			GridObj.SetParam("mode", "charge_transfer");//
	//			GridObj.SetParam("Transfer_person_id", Transfer_person_id);
	//			mode = "doTransfer";
	//			GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
	//			GridObj.SendData(servletUrl, "ALL", "ALL");
		}
	
	}//doTransfer End
</script>





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
	var header_name = GridObj.getColumnId(cellInd);
	
	if(header_name=="PO_NO") {
		var po_no	= LRTrim(GridObj.cells(rowId, IDX_PO_NO).getValue());   //GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
// 		var po_type	= LRTrim(GridObj.cells(rowId, IDX_PO_TYPE).getValue());	//GD_GetCellValueIndex(GridObj,msg2,IDX_PO_TYPE);
// 	    window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no+"&po_type="+po_type,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		var url = "../procure/po_detail.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&po_no="+po_no;
		PopupGeneral(url+param, "PoDetailPop", "", "", "1000", "600");	    
	    
    }

	if(header_name=="EXEC_NO") {
        var exec_no = LRTrim(GridObj.cells(rowId, IDX_EXEC_NO).getValue());     //GD_GetCellValueIndex(GridObj,msg2,IDX_EXEC_NO);
        var pr_type = LRTrim(GridObj.cells(rowId, IDX_PR_TYPE).getValue());     //GridObj.GetCellValue("PR_TYPE",msg2);

        window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
    }

    if (header_name=="VENDOR_CODE") {
    	
    	var vendor_code = LRTrim(GridObj.cells(rowId, IDX_VENDOR_CODE).getValue());    	
    	
		if (vendor_code=="") {
			alert("업체가 없습니다.");
			return;
		}
		window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+msg4,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
	}else if (header_name=="VENDOR_NAME") {
		var vendor_code = LRTrim(GridObj.cells(rowId, IDX_VENDOR_CODE).getValue());     //GridObj.GetCellValue("VENDOR_CODE",msg2);
		var vendor_name = LRTrim(GridObj.cells(rowId, IDX_VENDOR_NAME).getValue());
		if(vendor_name==""){
			alert("업체가 없습니다.");
			return;
		}
		window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
	}else if(header_name == "EVAL_FLAG_DESC"){	//수행평가
		
		var po_no	            = LRTrim(GridObj.cells(rowId, IDX_PO_NO).getValue());     //GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
		var subject             = LRTrim(GridObj.cells(rowId, IDX_SUBJECT).getValue());     //GD_GetCellValueIndex(GridObj,msg2,IDX_SUBJECT);
		
		var eval_refitem        = LRTrim(GridObj.cells(rowId, IDX_EVAL_REFITEM).getValue());     //GridObj.GetCellValue("EVAL_REFITEM",msg2);
		var eval_valuer_refitem = LRTrim(GridObj.cells(rowId, IDX_EVAL_VALUER_REFITEM).getValue());     //GridObj.GetCellValue("EVAL_VALUER_REFITEM",msg2);
		var complete            = LRTrim(GridObj.cells(rowId, IDX_EVAL_FLAG_DESC).getValue());     //GridObj.GetCellValue("EVAL_FLAG_DESC",msg2);
		var e_template_refitem  = LRTrim(GridObj.cells(rowId, IDX_E_TEMPLATE_REFITEM).getValue());     //GridObj.GetCellValue("E_TEMPLATE_REFITEM",msg2);
		var template_type       = LRTrim(GridObj.cells(rowId, IDX_TEMPLATE_TYPE).getValue());     //GridObj.GetCellValue("TEMPLATE_TYPE",msg2);
		var eval_item_refitem   = LRTrim(GridObj.cells(rowId, IDX_EVAL_ITEM_REFITEM).getValue());     //GridObj.GetCellValue("EVAL_ITEM_REFITEM",msg2);
		var vendor_name = '';
		var sg_name = '';
		
		if(complete == "평가대기중") 
		{
			var url;
			
			if(eval_refitem == ''){
				url = "/kr/order/bpo/po3_wk_ins1.jsp?po_no="+po_no+"&subject="+subject;
			}else{
				url = "/kr/master/evaluation/eva_list_pop1.jsp?e_template_refitem="+e_template_refitem+"&template_type="+template_type+"&eval_valuer_refitem="+eval_valuer_refitem+"&eval_item_refitem="+eval_item_refitem+"&eval_refitem="+eval_refitem;	
			}
			
			window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
		}else if(complete == "평가완료") {
			var url = "/kr/master/evaluation/eva_pp_lis3.jsp?e_template_refitem=" + e_template_refitem + 
				  "&template_type=" + template_type +
			      "&eval_item_refitem=" + eval_item_refitem + 
			      "&eval_refitem=" +
			      "&vendor_name="+ vendor_name +
			      "&sg_name="+ sg_name;
			window.open(url ,"windowopenSS","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
		}
    }
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
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



//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }  
    if( type == "req_dept" ) {
    	document.forms[0].req_dept.value = "";
        document.forms[0].req_dept_name.value = "";
    }
    if( type == "ctrl_person_id" ) {
    	document.forms[0].ctrl_person_id.value = "";
        document.forms[0].ctrl_person_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header>
	<form name="form1" >
		<input type="hidden" name="kind">
		
		
		<%@ include file="/include/sepoa_milestone.jsp" %>

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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주일자</td>
										<td width="35%" class="data_td">
											<s:calendar id_from="po_from_date"  default_from="<%=from_date %>" id_to="po_to_date" default_to="<%=to_date %>" format="%Y/%m/%d"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주번호</td>
										<td width="35%" class="data_td">
											<input type="text" name="po_no" id="po_no" style="ime-mode:inactive" size="15" maxlength="20" onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드</td>
										<td width="35%" class="data_td">
											<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive" size="8" maxlength="10" onkeydown='entKeyDown()'>
											<a href="javascript:getVendorCode('setVendorCode')">
												<img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="vendor_code_name" id="vendor_code_name" size="20" onkeydown='entKeyDown()'>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명</td>
										<td width="35%" class="data_td">
											<input type="text" name="vendor_name_loc" id="vendor_name_loc" style="width:95%" onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="c_title_1" style="display: none;">
											<img src="../images/ibk_s_arr.gif" width="9" height="9"> Class
										</td>
										<td width="35%" class="c_data_1" style="display: none;">
        									<select name="class_grade" id="class_grade" class="inputsubmit">
												<option value="">전체</option>
<%
	String vendor_class = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M934", "");
	out.println(vendor_class);
%>
											</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
										<td width="35%" class="data_td">
											<b>
												<input type="text" name="ctrl_person_id" id="ctrl_person_id" style="ime-mode:inactive" size="15" value="<%=user_id%>"  onkeydown='entKeyDown()' >
												<a href="javascript:PopupManager('ctrl_person_id');">
													<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
												</a>
												<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
												<input type="text" name="ctrl_person_name" id="ctrl_person_name" size="20" class="input_data2" onkeydown='entKeyDown()' readOnly  value="<%=info.getSession("NAME_LOC")%>" onkeydown="entKeyDown();">
											</b>
    										<input type="hidden" name="ctrl_code" id="ctrl_code" size="5" maxlength="5" class="inputsubmit" readOnly value="">
      										<input type="hidden" name="ctrl_name" id="ctrl_name" size="25" class="input_data2" readOnly >
    									</td>
    									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
										<td width="35%" class="data_td">
											<input type="text" name="req_dept" id="req_dept" style="ime-mode:inactive" size="15" maxlength="6" value='' onkeydown='entKeyDown()'>
											<a href="javascript:PopupManager('REQ_DEPT');">
												<img src="/images/ico_zoom.gif" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="req_dept_name" id="req_dept_name" size="20" readonly value='' onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;확인여부</td>
										<td width="35%" class="data_td">
											<select name="confirm_flag" id="confirm_flag" class="inputsubmit">
												<option value="">전체</option>
<%
	String confirm_status = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M644", "");
	out.println(confirm_status);
%>
											</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;완료여부</td>
										<td width="35%" class="data_td">
											<select name="complete_mark" id="complete_mark" class="inputsubmit">
												<option value="">전체</option>
<%
	String complete_mark = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M645", "");
	out.println(complete_mark);
%>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1"><img src="../images/ibk_s_arr.gif" width="9" height="9"> 발주수정여부</td>
										<td class="c_data_1" width="35%">
											<select name="po_status" id="po_status" class="inputsubmit">
												<option value="">전체</option>
												<option value="C">신규</option>
												<option value="R">변경</option>
											</select>
										</td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약기간</td>
										<td width="35%" class="data_td">
											<s:calendar id_from="cont_from_date"  id_to="cont_to_date"  format="%Y/%m/%d"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
										<td width="35%" class="data_td">
											<select name="material_type" id="material_type" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
												<option value="">전체</option>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
										<td width="35%" class="data_td">
											<select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
												<option value=''>전체</option>
											</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
										<td width="35%" class="data_td">
											<select name="material_class1" id="material_class1" class="inputsubmit">
												<option value=''>전체</option>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display: none;">
										<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 계약번호</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="cont_seq" id="cont_seq" style="ime-mode:inactive" size="15" class="inputsubmit" maxlength="20" onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr style="display: none;">
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 계약체결일
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="cont_sign_from_date" size="8" class="inputsubmit" maxlength="8">
<!-- 											<a href="javascript:Calendar_Open('cont_sign_valid_from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
											~
											<input type="text" name="cont_sign_to_date" size="8" class="inputsubmit" maxlength="8">
<!-- 											<a href="javascript:Calendar_Open('cont_sign_valid_to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
										</td>
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 계약명
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="cont_title" id="cont_title" style="width:95%" class="inputsubmit" maxlength="100">
										</td>
									</tr>
									<tr style="display: none;">
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 계약상태
										</td>
										<td class="c_data_1" width="35%">
											<select name="cont_status" class="inputsubmit">
												<option value="">전체</option>
												<option value="C">신규</option>
												<option value="R">변경</option>
											</select>
										</td>
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 고객사
										</td>
										<td width="35%" class="c_data_1">
											<input type="hidden" name="cust_type">
											<input type="text" name="cust_code" size="10" class="inputsubmit" value='' onkeydown='entKeyDown()'>
											<a href="javascript:searchCust();">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" >
											</a>
											<input type="text" name="cust_name" size="26" class="input_data2" value='' style="border:0" readonly onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 영업부서
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="sales_dept" style="ime-mode:inactive" size="15" maxlength="6" class="inputsubmit" value='' onkeydown='entKeyDown()'>
											<a href="javascript:PopupManager('SALES_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="sales_dept_name" size="20" class="input_data2" readonly value='' onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 프로젝트명
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="wbs_name" style="width:95%" class="inputsubmit" maxlength="100" onkeydown='entKeyDown()'>
										</td>
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 품의명
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="ct_name" style="width:95%" class="inputsubmit" maxlength="100" onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9" > 발주명
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="po_name" style="width:95%" class="inputsubmit" maxlength="100" onkeydown='entKeyDown()'>
										</td>
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 제조사
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="maker_name" style="width:95%" class="inputsubmit" maxlength="24" onkeydown='entKeyDown()'>
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1">
											<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 담당부서
										</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="demand_dept" size="15" maxlength="6" class="inputsubmit" value='<%=info.getSession("DEPARTMENT")%>'>
											<a href="javascript:PopupManager('DEMAND_DEPT');">
												<img src="../../images//button/query.gif" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="demand_dept_name" size="20" class="input_data2" readonly value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>'>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안번호</td>
										<td width="35%" class="data_td" colspan="3">
											<input type="text" name="exec_no" id="exec_no" style="ime-mode:inactive" size="15" maxlength="20" onkeydown='entKeyDown()'>
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
    		    <td height="30" align="left">
    		    	<TABLE cellpadding="0">
                		<TR>       
    		    		<%if(ctrl_yn.equals("Y")){%>
				    	 	<td width="11%" style="font-weight:bold;font-size:12px;color:#555555;"><img src="../../images/blt_srch.gif">&nbsp;검수담당자<br>&nbsp;&nbsp;검수담당자연락처</td>
					      	<td width="20%" > <b>
					        <input type="text" name="Transfer_person_id" id="Transfer_person_id" size="12" maxlength="5" class="inputsubmit" readOnly > /
					        <input type="text" name="Transfer_person_name" id="Transfer_person_name" size="15" class="inputsubmit" readOnly >
					        <a href="javascript:SP9113_Popup();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a><br>					        
					        <input type="text" name="TAKE_TEL" id="TAKE_TEL" size="30" style="ime-mode:disabled;" class="inputsubmit" onKeyUp="return chkMaxByte(30, this, '검수자연락처');">
					        </b>
				      		</td>
				      		 <td width="11%" > <script language="javascript">btn("javascript:doTransfer()","검수담당자변경")</script>
				      		</td>
				      	<%} %>
    		    	</TR>
    		        </TABLE>
    		    </td>
    			<td height="30" align="right">
            		<TABLE cellpadding="0">
                		<TR>       
                        	<td>
<script language="javascript">
btn("javascript:doSelect()", "조 회");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:doUpdate()","수 정");
</script>
							</TD>
<!-- 							<TD> -->
<%-- <script language="javascript"> --%>
<!-- // btn("javascript:doDelete()","발주삭제"); -->
<%-- </script> --%>
<!-- 							</TD> -->
							<TD>
<script language="javascript">
 btn("javascript:doIngStop()","발주중도종결");
 </script>
							</TD>
							<TD>
<script language="javascript">
 btn("javascript:yrpoCancel()","발주취소(연단가)");
 </script>
							</TD>
							<TD>
<script language="javascript">
 btn("javascript:expoCancel()","발주취소(기안생성)");
 </script>
							</TD>
							<TD>
<script language="javascript">
 btn("javascript:poReturn()","발주대기환원");
 </script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
	<iframe name = "work_frame" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PO_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>