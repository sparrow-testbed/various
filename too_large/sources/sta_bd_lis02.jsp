<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("ST_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "ST_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
%>
<% String WISEHUB_PROCESS_ID="ST_003";%>


<%
	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String house_code      = info.getSession("HOUSE_CODE");
	String toDays          = SepoaDate.getShortDateString();
	String toDays_1        = SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");

	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 작성 사용여부
	// sepoa.properties의 sepoa.po.contract.use.#HOUSE_CODE# = true/false 에 따라 옵션으로 진행한다.
	Config sepoa_conf = new Configuration();
	boolean po_contract_use_flag = false;
	try {
		po_contract_use_flag = sepoa_conf.getBoolean("sepoa.po.contract.use." + info.getSession("HOUSE_CODE")); //발주 전자계약 사용여부
	} catch (Exception e) {
		po_contract_use_flag = false;
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

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
<script language="javascript">
	var	G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/statistics.sta_bd_lis02";
	var mode;
	var checked_count = 0;

	var IDX_SELECTED           ;
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

	var chkrow;

	
  	function Init()
    {
		setGridDraw();
		setHeader();
		//doSelect();
    }
	  
	  
	function setHeader() {
		var f0 = document.forms[0];

		f0.po_from_date.value = add_Slash("<%=toDays_1%>");
		f0.po_to_date.value   = add_Slash("<%=toDays%>");
		
		// 2011-03-08 Class hidden

		// 2011-03-08 계약여부~영업부서 hidden



		//발주 수정을 위한 추가정보

/* 
		GridObj.SetColCellSortEnable("PO_CREATE_DATE"		,false);
		GridObj.SetColCellSortEnable("CUR"				,false);
		GridObj.SetColCellSortEnable("PO_TTL_AMT"			,false);
		GridObj.SetColCellSortEnable("CTRL_CODE"			,false);
		GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd");
		GridObj.SetDateFormat("GAP_SIGN_DATE"		,"yyyy/MM/dd");
		GridObj.SetNumberFormat("PO_TTL_AMT"		,G_format_amt);
		GridObj.SetNumberFormat("TOTAL_AMT"		,G_format_amt);
 */

		IDX_SELECTED					= GridObj.GetColHDIndex("SELECTED"					);
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
	}

	function doSelect() {
		var f0 = document.forms[0];

		if(f0.po_from_date.value != "") {
			if(!checkDateCommon(del_Slash(f0.po_from_date.value))) {
				alert(" 발주일자(From)를 확인 하세요 ");
				f0.po_from_date.focus();
				return;
			}
		}

		if(f0.po_to_date.value != "") {
			if(!checkDateCommon(del_Slash(f0.po_to_date.value))) {
				alert(" 발주일자(To)를 확인 하세요 ");
				f0.po_to_date.focus();
				return;
			}
		}

		/* 
		if(f0.ctrl_code.value == "") {
			alert(" 구매담당직무는 필수 입력입니다. ");
			f0.ctrl_code.focus();
			return;
		}
		*/
		
		f0.po_no.value          = f0.po_no.value.toUpperCase();
		f0.vendor_code.value    = f0.vendor_code.value.toUpperCase();
		f0.ctrl_person_id.value = LRTrim(f0.ctrl_person_id.value.toUpperCase());
		f0.po_status.value      = f0.po_status.value.toUpperCase();
		f0.confirm_flag.value   = f0.confirm_flag.value.toUpperCase();
		f0.complete_mark.value  = f0.complete_mark.value.toUpperCase();
		f0.cust_code.value 		= f0.cust_code.value.toUpperCase();
		f0.req_dept.value 		= f0.req_dept.value.toUpperCase();
		f0.ctrl_code.value		= f0.ctrl_code.value.toUpperCase();
<%--
		f0.wbs_name.value 		= f0.wbs_name.value.toUpperCase();
		f0.ct_name.value 		= f0.ct_name.value.toUpperCase();
		f0.po_name.value 		= f0.po_name.value.toUpperCase();
		f0.maker_name.value 	= f0.maker_name.value.toUpperCase();
--%>
		/* GridObj.SetParam("mode"					,"getPoList"				);
		GridObj.SetParam("po_from_date"			,f0.po_from_date.value		);
		GridObj.SetParam("po_to_date"				,f0.po_to_date.value		);
		GridObj.SetParam("po_no"					,f0.po_no.value         	);
		GridObj.SetParam("vendor_code"			,f0.vendor_code.value   	);
		GridObj.SetParam("vendor_name_loc"		,f0.vendor_name_loc.value	);
		GridObj.SetParam("class_grade"			,f0.class_grade.value		);
		GridObj.SetParam("ctrl_person_id"			,f0.ctrl_person_id.value	);
		GridObj.SetParam("confirm_flag"			,f0.confirm_flag.value  	);
		GridObj.SetParam("complete_mark"			,f0.complete_mark.value 	);
		GridObj.SetParam("po_status"				,f0.po_status.value     	);
		GridObj.SetParam("material_type"			,f0.material_type.value 	);
		GridObj.SetParam("material_ctrl_type"		,f0.material_ctrl_type.value);
		GridObj.SetParam("material_class1"		,f0.material_class1.value	);
		GridObj.SetParam("cont_from_date"			,f0.cont_from_date.value	);
		GridObj.SetParam("cont_to_date"			,f0.cont_to_date.value		);
		GridObj.SetParam("cont_seq"				,f0.cont_seq.value			);
		GridObj.SetParam("cont_sign_from_date"	,f0.cont_sign_from_date.value);
		GridObj.SetParam("cont_sign_to_date"		,f0.cont_sign_to_date.value	);
		GridObj.SetParam("cont_title"				,f0.cont_title.value		);
		GridObj.SetParam("cont_status"			,f0.cont_status.value		);
		GridObj.SetParam("cust_code"				,f0.cust_code.value			);
		GridObj.SetParam("sales_dept"				,f0.sales_dept.value		);
		GridObj.SetParam("req_dept"				,f0.req_dept.value			);

		GridObj.SetParam("wbs_name"				,f0.wbs_name.value			);
		GridObj.SetParam("ct_name"				,f0.ct_name.value			);
		GridObj.SetParam("po_name"				,f0.po_name.value			);
		GridObj.SetParam("maker_name"				,f0.maker_name.value		);
		GridObj.SetParam("ctrl_code"				,f0.ctrl_code.value 		);
		GridObj.SetParam("BID_DIV"            	,f0.BID_DIV.value            );

		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; */
		
		document.forms[0].po_from_date.value = del_Slash( document.forms[0].po_from_date.value );
		document.forms[0].po_to_date.value   = del_Slash( document.forms[0].po_to_date.value   );
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getPoList";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
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
			if(msg3==IDX_PO_NO) {
				var po_no	= GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
				var po_type	= GD_GetCellValueIndex(GridObj,msg2,IDX_PO_TYPE);
			    window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no+"&po_type="+po_type,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		    }

			if(msg3==IDX_EXEC_NO) {
                var exec_no = GD_GetCellValueIndex(GridObj,msg2,IDX_EXEC_NO);
                var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);

                window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
		    }

		    if (msg3==IDX_VENDOR_CODE) {
				if (msg4=="") {
					alert("업체가 없습니다.");
					return;
				}
				window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+msg4,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
	    	}else if (msg3==IDX_VENDOR_NAME) {
	    		var vendor_code = GridObj.GetCellValue("VENDOR_CODE",msg2);
				if(msg4==""){
					alert("업체가 없습니다.");
					return;
				}
				window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
	    	}
		} */
	}

	//직무권한 체크
	function checkUser() {
		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = true;

		for(var row=0; row<GridObj.GetRowCount(); row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SELECTED)) {
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
			check = GD_GetCellValueIndex(GridObj,i,IDX_SELECTED) ;
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
		var url = "/kr/admin/sepoapopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
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
		var url = "/kr/admin/sepoapopup/cod_cm_lis1.jsp?code=SP0371&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>";
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
		//구매담당직무
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
		}
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

    	setMATERIAL_CLASS1("전체", "");

    	var id = "SL0009";
   		var code = "M041";
    	var value = form1.material_type.value;
    	target = "MATERIAL_TYPE";
    	data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    	work_frame.location.href = data;
	}

	function MATERIAL_CTRL_TYPE_Changed() {
		clearMATERIAL_CLASS1();

		var id = "SL0019";
		var code = "M042";
		var value = form1.material_ctrl_type.value;
		target = "MATERIAL_CTRL_TYPE";
		data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
		work_frame.location.href = data;
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
		url = "/kr/admin/sepoapopup/cod_cm_lis1.jsp?code=SP0120F&function=scms_getCust&values=&values=/&desc=고객사코드&desc=고객사명";
		Code_Search(url,'','','','','');
	}

	function scms_getCust(code, text, div) {
		document.form1.cust_type.value = div;
		document.form1.cust_code.value = code;
		document.form1.cust_name.value = text;
	}
	
	function setCal(div){
		var startDay = "<%=SepoaDate.getShortDateString()%>";
		var endDay = "";
		var curStartDay = del_Slash(document.form1.po_from_date.value);
		var setDay = "";
		
		var curYear = curStartDay.substring(0,4);
		
		var february = ((0 == curYear % 4) && (0 != (curYear % 100))) || (0 == curYear % 400) ? 29 : 28;
		var arrLastDate = new Array(31, february, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);//해당월의 마지막일
		
		var lastdate = arrLastDate[parseInt(curStartDay.substring(4,6),10)-1];
		
		if(div == 'y'){
			setDay = curStartDay.substring(0,4)+"0101";
			endDay = curStartDay.substring(0,4)+"1231";
		}else if(div == 'q'){
			var mon = curStartDay.substring(4,6);
			if(parseInt(mon,10) < 7){
				setDay = curStartDay.substring(0,4)+"0101";
				endDay = curStartDay.substring(0,4)+"0630";
			}else{
				setDay = curStartDay.substring(0,4)+"0701";
				endDay = curStartDay.substring(0,4)+"1231";
			}
		}else if(div == 'm'){
			setDay = curStartDay.substring(0,6)+"01";
			endDay = curStartDay.substring(0,6)+lastdate;
		}
		document.form1.po_from_date.value = add_Slash(setDay);
		document.form1.po_to_date.value = add_Slash(endDay);
	}

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
    //alert(GridObj.cells(rowId, cellInd).getValue());
    
    var selectedId = GridObj.getSelectedId();
	var rowIndex   = GridObj.getRowIndex(selectedId);
	
	
	if(cellInd==IDX_PO_NO) {
		var po_no       = GD_GetCellValueIndex(GridObj, rowIndex, IDX_PO_NO);
		//var po_no       = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PO_NO);
		var po_type     = GD_GetCellValueIndex(GridObj, rowIndex, IDX_PO_TYPE);

	    //window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no+"&po_type="+po_type,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		var url              = "/kr/order/bpo/po3_pp_dis1.jsp";
		var title            = '발주화면상세조회';
		var param = "";
		param = param + "po_no=" + po_no;
		param = param + "&po_type=" + po_type;

		if (po_no != "") {
		    popUpOpen01(url, title, '1024', '600', param);
		}
	}

	if(cellInd==IDX_EXEC_NO) {
       var exec_no = GD_GetCellValueIndex(GridObj, rowIndex, IDX_EXEC_NO);
       var pr_type = GD_GetCellValueIndex(GridObj, rowIndex, IDX_PR_TYPE);	//GridObj.GetCellValue("PR_TYPE",msg2);

       window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
    }

    if (cellInd==IDX_VENDOR_NAME) {
   		var vendor_code = GD_GetCellValueIndex(GridObj, rowIndex, IDX_VENDOR_CODE);	//GridObj.GetCellValue("VENDOR_CODE",msg2);
		if(vendor_code ==""){
			alert("업체가 없습니다.");
			return;
		}
		window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
   	}
		
<%--    
		GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

    
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    
    document.forms[0].po_from_date.value = add_Slash( document.forms[0].po_from_date.value );
    document.forms[0].po_to_date.value   = add_Slash( document.forms[0].po_to_date.value   );
    
    return true;
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }  
    if( type == "ctrl_code" ) {
    	document.form1.ctrl_code.value = "";
		document.form1.ctrl_name.value = "";
    }
    if( type == "req_dept" ) {
    	document.forms[0].req_dept.value      = "";
    	document.forms[0].req_dept_name.value = "";
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
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->

<form name="form1" >
<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>

<form name="form1" action="">
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
<input type="hidden" name="kind">

<tr>
	<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주일자</td>
	<td class="data_td" width="40%">
	<TABLE cellpadding="0">
		<TR>
			<td>
				<!-- <input type="text" name="po_from_date" size="8" class="input_re" maxlength="8">
				<a href="javascript:Calendar_Open('po_valid_from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a>
				~
				<input type="text" name="po_to_date" size="8" class="input_re" maxlength="8">
				<a href="javascript:Calendar_Open('po_valid_to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
				
				<s:calendar id="po_from_date" default_value="" format="%Y/%m/%d"/>
				~
				<s:calendar id="po_to_date" default_value="" format="%Y/%m/%d"/>
			</td>
			<TD><script language="javascript">btn("javascript:setCal('y')","년")    </script></TD>
			<TD><script language="javascript">btn("javascript:setCal('q')","반기")    </script></TD>
			<TD><script language="javascript">btn("javascript:setCal('m')","월")    </script></TD>
   	  	</TR>
	</TABLE>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주번호</td>
	<td class="data_td" width="35%">
		<input type="text" name="po_no" id="po_no" style="ime-mode:inactive" size="15" class="inputsubmit" maxlength="20" onkeydown='entKeyDown()'>
	</td>
</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드</td>
	<td class="data_td" width="35%">
		<input type="text" onkeydown='entKeyDown()' name="vendor_code" id="vendor_code" style="ime-mode:inactive" size="8" class="inputsubmit" maxlength="10" >
		<a href="javascript:getVendorCode('setVendorCode')"><img src="<%=G_IMG_ICON%>" width="19" height="19" align="absmiddle" border="0"></a>
		<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" onkeydown='entKeyDown()' name="vendor_code_name" id="vendor_code_name" size="20" class="input_data2">
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명
	</td>
	<td width="35%" class="data_td">
		<input type="text" onkeydown='entKeyDown()' name="vendor_name_loc" id="vendor_name_loc" style="width:95%" class="inputsubmit">
	</td>
</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
<tr>
	<!-- 2011-03-08 Class hidden -->
	<td width="15%" class="title_td" style="display: none;">
		 Class
	</td>
	<td width="35%" class="data_td" style="display: none;">
        <select name="class_grade" id="class_grade" class="inputsubmit">
        <option value="">전체</option>
        <%
        String vendor_class = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M934", "");
        out.println(vendor_class);
        %>
        </select>
	</td>
	
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
	<td class="data_td" width="35%" colspan="3">
		<input type="text" onkeydown='entKeyDown()' name="req_dept" id="req_dept" style="ime-mode:inactive" size="15" maxlength="6" onkeydown='entKeyDown()' class="inputsubmit" value='' >
		<a href="javascript:PopupManager('REQ_DEPT');"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
		<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" onkeydown='entKeyDown()' name="req_dept_name" id="req_dept_name" size="20" onkeydown='entKeyDown()' class="input_data2" readonly value=''>
	</td>
	
	<td width="15%" class="title_td" style="display:none">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당직무      </td>
	<td class="data_td" width="35%" style="display:none">
		<input type="text" onkeydown='entKeyDown()' name="ctrl_code" id="ctrl_code" style="ime-mode:inactive" size="15" onkeydown='entKeyDown()' value="<% //=parsingCtrlCode(info.getSession("CTRL_CODE")) %>" class="input_re" >
		<a href="javascript:PopupManager('CTRL_CODE')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
		<a href="javascript:doRemove('ctrl_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" onkeydown='entKeyDown()' name="ctrl_name" id="ctrl_name" size="20" class="input_data2" onkeydown='entKeyDown()' value="" readOnly>
		<input type="hidden" name="ctrl_person_id" id="ctrl_person_id" value="">
		<input type="hidden" name="ctrl_person_name" id="ctrl_person_name" value="">
	</td>
	
</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;접수여부</td>
	<td class="data_td" width="35%">
		<select name="confirm_flag" id="confirm_flag" class="inputsubmit">
		<option value="">전체</option>
<%
		String confirm_status = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M644", "");
		out.println(confirm_status);
%>
		</select>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;완료여부</td>
	<td class="data_td" width="35%">
		<select name="complete_mark" id="complete_mark" class="inputsubmit">
		<option value="">전체</option>
<%
		String complete_mark = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M645", "");
		out.println(complete_mark);
%>
		</select>
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주수정여부</td>
	<td class="data_td" width="35%">
		<select name="po_status" id="po_status" class="inputsubmit">
		<option value="">전체</option>
		<option value="C">신규</option>
		<option value="R">변경</option>
		</select>
	</td>
</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약기간</td>
	<td class="data_td" width="35%">
		<input type="text" onkeydown='entKeyDown()' name="cont_from_date" id="cont_from_date" onkeydown='entKeyDown()' size="8" class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_valid_from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
		~
		<input type="text" onkeydown='entKeyDown()' name="cont_to_date" id="cont_to_date" size="8" onkeydown='entKeyDown()' class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_valid_to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류
	</td>
	<td width="35%" class="data_td">
        <select name="material_type" id="material_type" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
        <option value="">전체</option>
        <%
        String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
        out.println(listbox1);
        %>
        </select>
	</td>
</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류
	</td>
	<td width="35%" class="data_td">
        <select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
        <option value=''>전체</option>
        </select>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류
	</td>
	<td width="35%" class="data_td">
        <select name="material_class1" id="material_class1" class="inputsubmit">
        <option value=''>전체</option>
        </select>
	</td>
</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰방식
	</td>
	<td width="35%" class="data_td" colspan="3">
		<select name="BID_DIV" id="BID_DIV" class="inputsubmit">
	        <option value="">전체</option>
	        <option value="RQ">견적</option>
	        <option value="RA">역경매</option>
	        <option value="BD">입찰</option>
	        <option value="PC">수의계약</option>
	    </select>
	</td>
</tr>

<!-- 2011-03-08 계약체결일~고객사 hidden -->
<tr style="display: none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약번호</td>
	<td class="data_td" width="35%">
		<input type="text" onkeydown='entKeyDown()' name="cont_seq" id="cont_seq" size="15" class="inputsubmit" maxlength="20">
	</td>
</tr>
<tr style="display: none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약체결일</td>
	<td class="data_td" width="35%">
		<input type="text" onkeydown='entKeyDown()' name="cont_sign_from_date" id="cont_sign_from_date" size="8" class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_sign_valid_from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
		~
		<input type="text" onkeydown='entKeyDown()' name="cont_sign_to_date" id="cont_sign_to_date" size="8" class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_sign_valid_to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약명</td>
	<td class="data_td" width="35%">
		<input type="text" onkeydown='entKeyDown()' name="cont_title" id="cont_title" style="width:95%" onkeydown='entKeyDown()' class="inputsubmit" maxlength="100">
	</td>
</tr>
<tr style="display: none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약상태</td>
	<td class="data_td" width="35%">
		<select name="cont_status" id="cont_status" class="inputsubmit">
		<option value="">전체</option>
		<option value="C">신규</option>
		<option value="R">변경</option>
		</select>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고객사
	</td>
	<td width="35%" class="data_td">
		<input type="hidden" name="cust_type" id="cust_type">
		<input type="text" name="cust_code" id="cust_code" size="10" class="inputsubmit" onkeydown='entKeyDown()' value='' >
		<a href="javascript:searchCust();"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" ></a>
		<input type="text" onkeydown='entKeyDown()' name="cust_name" id="cust_name" size="26" class="input_data2" value='' onkeydown='entKeyDown()' style="border:0" readonly>
	</td>
</tr>
<tr style="display:none;">
	<!-- 2011-03-08 영업부서 hidden -->
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;영업부서</td>
	<td class="data_td" width="35%">
		<input type="text" onkeydown='entKeyDown()' name="sales_dept" id="sales_dept" size="15" maxlength="6" class="inputsubmit" value='' >
		<a href="javascript:PopupManager('SALES_DEPT');"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
		<input type="text"  name="sales_dept_name" id="sales_dept_name" size="20" class="input_data2" readonly value=''>
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;프로젝트명</td>
	<td class="data_td" width="35%">
		<input type="text" name="wbs_name" id="wbs_name" style="width:95%" class="inputsubmit" maxlength="100">
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의명</td>
	<td class="data_td" width="35%">
		<input type="text" name="ct_name" id="ct_name" style="width:95%" class="inputsubmit" maxlength="100">
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주명</td>
	<td class="data_td" width="35%">
		<input type="text" name="po_name" id="po_name" style="width:95%" class="inputsubmit" maxlength="100">
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
	<td class="data_td" width="35%">
		<input type="text" name="maker_name" id="maker_name" style="width:95%" class="inputsubmit" maxlength="24">
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당부서</td>
	<td class="data_td" width="35%">
		<input type="text" name="demand_dept" id="demand_dept" size="15" maxlength="6" class="inputsubmit" value='<%=info.getSession("DEPARTMENT")%>'>
		<a href="javascript:PopupManager('DEMAND_DEPT');"><img src="../../images//button/query.gif" align="absmiddle" border="0" alt=""></a>
		<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" class="input_data2" readonly value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>'>
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
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>


</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe name = "work_frame" src=""  width="0" height="0" border="no" frameborder="no"></iframe>

</s:header>
<s:grid screen_id="ST_003" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


