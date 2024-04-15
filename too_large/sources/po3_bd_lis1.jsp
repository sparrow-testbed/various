<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/include/wisehub_common.jsp"%>
<!-- 2011-03-08 solarb -->
<!-- form hidden 泥�━, 洹몃━��而щ� 湲몄� 0�쇰�-->
<% String WISEHUB_PROCESS_ID="PO_002";%>

<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wisetable_scripts.jsp"%>

<%
	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String house_code      = info.getSession("HOUSE_CODE");
	String toDays          = SepoaDate.getShortDateString();
	String toDays_1        = SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");

	// 2011.07.28 HMCHOI ���
	// 諛�＜����� 諛���������怨������� �ъ��щ�
	// wise.properties��wise.po.contract.use.#HOUSE_CODE# = true/false ���곕� �듭��쇰� 吏�����.
	Config wise_conf = new Configuration();
	boolean po_contract_use_flag = false;
	try {
		po_contract_use_flag = wise_conf.getBoolean("wise.po.contract.use." + info.getSession("HOUSE_CODE")); //諛�＜ ���怨�� �ъ��щ�
	} catch (Exception e) {
		po_contract_use_flag = false;
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/wisehub_scripts.jsp"%>
<script language="javascript">
	var	servletUrl = "<%=getWiseServletPath("order.bpo.po3_bd_lis1")%>";
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

	function setHeader() {
		var f0 = document.forms[0];

		f0.po_from_date.value = "<%=toDays_1%>";
		f0.po_to_date.value   = "<%=toDays%>";


		// 2011-03-08 Class hidden

		// 2011-03-08 怨���щ�~���遺�� hidden


		
		
		//諛�＜ �������� 異����낫
		


		GridObj.SetColCellSortEnable("PO_CREATE_DATE"		,false);
		GridObj.SetColCellSortEnable("CUR"				,false);
		GridObj.SetColCellSortEnable("PO_TTL_AMT"			,false);
		GridObj.SetColCellSortEnable("CTRL_CODE"			,false);
		GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd");
		GridObj.SetDateFormat("GAP_SIGN_DATE"		,"yyyy/MM/dd");
		GridObj.SetNumberFormat("PO_TTL_AMT"		,G_format_amt);
		GridObj.SetNumberFormat("TOTAL_AMT"		,G_format_amt);


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
		var f0 = document.forms[0];

		if(f0.po_from_date.value != "") {
			if(!checkDateCommon(f0.po_from_date.value)) {
				alert(" 諛�＜�쇱�(From)瑜���� �����");
				f0.po_from_date.focus();
				return;
			}
		}

		if(f0.po_to_date.value != "") {
			if(!checkDateCommon(f0.po_to_date.value)) {
				alert(" 諛�＜�쇱�(To)瑜���� �����");
				f0.po_to_date.focus();
				return;
			}
		}

		if(f0.ctrl_person_id.value == "") {
			alert(" 援щℓ�대���� ��� �������� ");
			f0.ctrl_person_id.focus();
			return;
		}

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
		GridObj.SetParam("mode"					,"getPoList"				);
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

		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti";
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

		if (msg1 == "t_imagetext") {
			if(msg3==IDX_PO_NO) {
				var po_no	= GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
				var po_type	= GD_GetCellValueIndex(GridObj,msg2,IDX_PO_TYPE);
			    //window.open("po3_pp_dis1.jsp"+"?po_no="+po_no+"&po_type="+po_type,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");

			    var url              = "/kr/order/bpo/po3_pp_dis1.jsp";
				var title            = '발주화면상세조회';
				var param = "";
				param = param + "po_no=" + po_no;
				param = param + "&po_type=" + po_type;
				//param = param + "&OSQ_COUNT=" + osqCountColValue;
				if (po_no != "") {
				    popUpOpen01(url, title, '1024', '600', param);
				}
			}

			if(msg3==IDX_EXEC_NO) {
                var exec_no = GD_GetCellValueIndex(GridObj,msg2,IDX_EXEC_NO);
                var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);

                window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
		    }

		    if (msg3==IDX_VENDOR_CODE) {
				if (msg4=="") {
					alert("��껜媛�������.");
					return;
				}
				window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+msg4,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
	    	}else if (msg3==IDX_VENDOR_NAME) {
	    		var vendor_code = GridObj.GetCellValue("VENDOR_CODE",msg2);
				if(msg4==""){
					alert("��껜媛�������.");
					return;
				}
				window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
	    	}else if(msg3 == IDX_EVAL_FLAG_DESC){	//������
	    		
	    		var po_no	= GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
	    		var subject = GD_GetCellValueIndex(GridObj,msg2,IDX_SUBJECT);
	    		
	    		var eval_refitem = GridObj.GetCellValue("EVAL_REFITEM",msg2);
	    		var eval_valuer_refitem = GridObj.GetCellValue("EVAL_VALUER_REFITEM",msg2);
				var complete = GridObj.GetCellValue("EVAL_FLAG_DESC",msg2);
				var e_template_refitem = GridObj.GetCellValue("E_TEMPLATE_REFITEM",msg2);
				var template_type = GridObj.GetCellValue("TEMPLATE_TYPE",msg2);
				var eval_item_refitem = GridObj.GetCellValue("EVAL_ITEM_REFITEM",msg2);
				var vendor_name = '';
				var sg_name = '';
				
	    		if(complete == "�����린以�) 
				{
	    			var url;
	    			
	    			if(eval_refitem == ''){
	    				url = "po3_wk_ins1.jsp?po_no="+po_no+"&subject="+subject;
	    			}else{
	    				url = "/kr/master/evaluation/eva_list_pop1.jsp?e_template_refitem="+e_template_refitem+"&template_type="+template_type+"&eval_valuer_refitem="+eval_valuer_refitem+"&eval_item_refitem="+eval_item_refitem+"&eval_refitem="+eval_refitem;	
	    			}
	    			
					window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
				}else if(complete == "������") {
					var url = "/kr/master/evaluation/eva_pp_lis3.jsp?e_template_refitem=" + e_template_refitem + 
						  "&template_type=" + template_type +
					      "&eval_item_refitem=" + eval_item_refitem + 
					      "&eval_refitem=" +
					      "&vendor_name="+ vendor_name +
					      "&sg_name="+ sg_name;
					window.open(url ,"windowopenSS","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
				}
            }
		    
		}
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

	    var iCheckedRow = checkedOneRow(IDX_SEL);

	    if(iCheckedRow==-1)
	        return;
	    
		po_no 			= wise.GetCellValue("PO_NO",iCheckedRow);
		sign_status 	= wise.GetCellValue("SIGN_STATUS",iCheckedRow);
		complete_mark 	= wise.GetCellValue("COMPLETE_MARK",iCheckedRow);
		confirm_flag	= wise.GetCellValue("CONFIRM_FLAG",iCheckedRow);
		del_flag        = wise.GetCellValue("DEL_FLAG" , iCheckedRow);
		ctrl_code   	= wise.GetCellValue("CTRL_CODE",iCheckedRow);
		po_type			= wise.GetCellValue("PO_TYPE",iCheckedRow);

		if(sign_status != "R" && sign_status != "T") {
			alert("吏�����媛����以��嫄곕� 諛����嫄대� �����媛���⑸���");
			return;
		}
		if (complete_mark == "Y") {
			alert("�대� �����諛�＜ �����");
			return;
		}

		if (complete_mark == "YY") {
			alert("�대� 醫�껐��諛�＜ �����");
			return;
		}

		if (del_flag == "N") {
			alert("寃����낫媛������諛�＜嫄댁� ��� ����������.");
			return;
		}
		
		// �����껜 ������ (SIGN_STATUS=E)
		// ����щ����(CONFIRM_FLAG=N), ����ы���CONFIRM_FLAG=Y), ����щ���CONFIRM_FLAG=R)
		if (sign_status == "E") {
			if (confirm_flag == "N") { // 誘명���				alert("���������������諛�＜嫄댁� �������������.");
				return;
			}
			if (confirm_flag == "Y") { // ������
				alert("����ъ�����������諛�＜嫄댁� �������������.");
				return;
			}
		}
		
		var t_url = "";
		
		if ( po_type == "D" || po_type == "M") {
			t_url 	 = "po1_bd_upd2.jsp?po_no="+po_no;  //吏��二�硫���쇰�二����
		} else {
			t_url 	 = "po1_bd_upd1.jsp?po_no="+po_no;  //���諛�＜ ���
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
				
				// T : ���以� P : 寃곗�以�				if(sign_status == "P"){
					alert("吏�����媛�[寃곗�以���諛�＜嫄댁� �������������.");
					return;
				}
				/*
				else if( confirm_flag == 'Y'){
					alert("��� �����嫄댁� �������������.");
					return;					
				}
				*/
				
				if (del_flag == "N" ) {
					//alert("留ㅼ�怨����� ������ ��� 諛�＜��\n ��� ����������.");
					alert("寃����낫媛� ������ ��� 諛�＜����� ����������.");
					return;
				}
				
				if(contract_flag == "Y"){
					alert("怨�� 泥닿껐 諛�＜嫄댁� ��� ����������.");
					return;
				}
				
			}
		}

		if (selectedRow == -1) {
			alert("諛�＜踰��瑜�����댁＜�몄�.")
			return;
		}

		if (confirm("��� ��� ���寃�����?")) {
			GridObj.SetParam("mode" , "setPoDelete");
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl,"ALL","ALL");
			GridObj.strHDClickAction="sortmulti";
		}
	}
	//吏�Т沅�� 泥댄�
	function checkUser() {
		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = true;

		for(var row=0; row<GridObj.GetRowCount(); row++) {
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
			alert("����������沅����������.");

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
	//�대���	function SP0216_Popup() {
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
	//�대���	function SP0371_Popup() {
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
		//援щℓ�대�吏�Т
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","吏�Т肄��","吏�Т紐�);
		}
	}

	//援щℓ�대�吏�Т
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

    	setMATERIAL_CLASS1("��껜", "");

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
		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0120F&function=scms_getCust&values=&values=/&desc=怨���ъ���desc=怨���щ�";
		Code_Search(url,'','','','','');
	}

	function scms_getCust(code, text, div) {
		document.form1.cust_type.value = div;
		document.form1.cust_code.value = code;
		document.form1.cust_name.value = text;
	}

	/* 諛�＜以��醫�껐 */
	function doIngStop()
	{
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

	    var iCheckedRow = checkedOneRow(IDX_SEL);

	    if(iCheckedRow==-1)
	        return;

		po_no 			= wise.GetCellValue("PO_NO",iCheckedRow);
		sign_status 	= wise.GetCellValue("SIGN_STATUS",iCheckedRow);
		confirm_flag 	= wise.GetCellValue("CONFIRM_FLAG",iCheckedRow);
		complete_mark 	= wise.GetCellValue("COMPLETE_MARK",iCheckedRow);
		del_flag        = wise.GetCellValue("DEL_FLAG" , iCheckedRow);
		ctrl_code   	= wise.GetCellValue("CTRL_CODE",iCheckedRow);
		stop_flag 		= wise.GetCellValue("STOP_FLAG",iCheckedRow);
		/*
		if(sign_status != "R" && sign_status != "T"){
			alert("諛��以��嫄곕� ���以�� 嫄대� �����媛���⑸���");
			return;
		}*/
		
		//if( confirm_flag == 'N' || stop_flag == 'N'){
		if(stop_flag == 'N'){			
			alert("��� �����嫄댁� ������ 以��醫�껐��媛���⑸���");
			return;
		}
		if(complete_mark == "Y"){
			alert("�대� �����諛�＜ �����");
			return;
		}
		if(complete_mark == "YY"){
			alert("�대� 醫�껐��諛�＜ �����");
			return;
		}
		/*
		if(del_flag == "N"){
			alert("寃����낫媛������諛�＜嫄댁� \n��� ����������..");
			return;
		}
		*/

		var t_url = "po1_bd_upd3.jsp?po_no="+po_no;
		if(confirm("諛�＜ 以��醫�껐 ���寃�����?")){
    		window.open(t_url,"","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	}
	}
	
	//�대���	function SP0071_Popup() {
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
	        window.focus(); // Key Down���ъ빱���대�.. 荑쇰━���명� 媛�� �щ�吏�� 寃�� 諛⑹�..
	    }
	}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid��JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox��JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 洹몃━���대┃ �대깽��������몄� �⑸��� rowId ����� ID�대ŉ cellInd 媛�� 而щ� �몃���媛��硫�// �대깽��泥�━��而щ�紐�怨������� 泥�━����ㅻ㈃ GridObj.getColIndexById("selected") == cellInd �대�寃�泥�━���硫��⑸���
function doOnRowSelected(rowId,cellInd)
{
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

// 洹몃━����ChangeEvent ������몄� �⑸���
// stage = 0 ������, 1 = ����댁����, 2 = �������� true �������������ŉ false ������댁�媛��濡�����⑸���
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 ������, 1 = ����댁����, 2 = �������� true �������������ŉ false ������댁�媛��濡�����⑸���
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// ���由우�濡��곗��곕� ��� 諛���� 諛���� 泥�━ 醫����� �몄� ��� �대깽�������
// ���由우���message, status, mode 媛�� �����㈃ 媛�� �쎌��듬���
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

// ��� �������� ��� ����� ������ 蹂듭���� 踰���대깽�몃� doExcelUpload �몄��������// 蹂듭����곗��곌� 洹몃━��� Load �⑸���
// !!!! �щ＼,����댄����ы�由��ㅽ���釉���곗�������대┰蹂대������ ��렐 沅����留�������doExcelUpload �ㅽ������ 諛�� 
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
    // Wise洹몃━������ �ㅻ�諛����status��0���명����.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:setGridDraw();
setHeader();GD_setProperty(document.WiseGrid);;<%--;寃고� #108;硫�������議고�議곌굔����댁� 湲곕낯 議고�����쇳�.;doSelect(); 異��;--%>;doSelect();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--�댁����-->
<form name="form1" >
<input type="hidden" name="kind">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><td></td></tr>
</table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 諛�＜�쇱�</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="po_from_date" size="8" class="input_re" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('po_valid_from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
		~
		<input type="text" name="po_to_date" size="8" class="input_re" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('po_valid_to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
	</td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 諛�＜踰��</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="po_no" size="15" class="inputsubmit" maxlength="20">
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ��껜肄��</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="vendor_code" size="8" class="inputsubmit" maxlength="10" >
		<a href="javascript:getVendorCode('setVendorCode')"><img src="<%=G_IMG_ICON%>" width="19" height="19" align="absmiddle" border="0"></a>
		<input type="text" name="vendor_code_name" size="20" class="input_data2">
	</td>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ��껜紐�	</td>
	<td width="35%" class="c_data_1">
		<input type="text" name="vendor_name_loc" style="width:95%" class="inputsubmit">
	</td>
</tr>
<tr>
	<!-- 2011-03-08 Class hidden -->
	<td width="15%" class="c_title_1" style="display: none;">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Class
	</td>
	<td width="35%" class="c_data_1" style="display: none;">
        <select name="class_grade" class="inputsubmit">
        <option value="">��껜</option>
        <%
        String vendor_class = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M934", "");
        out.println(vendor_class);
        %>
        </select>
	</td>
<%-- 	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 援щℓ�대�吏�Т      </td> --%>
<!-- 	<td class="c_data_1" width="35%"> -->
<%-- 		<input type="text" name="ctrl_code" size="15" value="<%=parsingCtrlCode(info.getSession("CTRL_CODE"))%>" class="input_re" > --%>
<%-- 		<a href="javascript:PopupManager('CTRL_CODE')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a> --%>
<!-- 		<input type="text" name="ctrl_name" size="20" class="input_data2" value="" readOnly> -->
<!-- 		<input type="hidden" name="ctrl_person_id" value=""> -->
<!-- 		<input type="hidden" name="ctrl_person_name" value=""> -->
<!-- 	</td> -->
    <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 援щℓ�대���     </td>
    <td class="c_data_1" width="35%">
    	<b><input type="text" name="ctrl_person_id" size="15" class="inputsubmit" value="<%=user_id%>"  onkeydown="entKeyDown();">
      <a href="javascript:SP0071_Popup();"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
      <input type="text" name="ctrl_person_name" size="20" class="input_data2" readOnly  value="<%=info.getSession("NAME_LOC")%>" onkeydown="entKeyDown();"></b>
    	<input type="hidden" name="ctrl_code" size="5" maxlength="5" class="inputsubmit" readOnly value="">
      <input type="hidden" name="ctrl_name" size="25" class="input_data2" readOnly >
    </td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ��껌遺��</td>
	<td class="c_data_1" width="35%" colspan="3">
		<input type="text" name="req_dept" size="15" maxlength="6" class="inputsubmit" value='' >
		<a href="javascript:PopupManager('REQ_DEPT');"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
		<input type="text" name="req_dept_name" size="20" class="input_data2" readonly value=''>
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ����щ�</td>
	<td class="c_data_1" width="35%">
		<select name="confirm_flag" class="inputsubmit">
		<option value="">��껜</option>
<%
		String confirm_status = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M644", "");
		out.println(confirm_status);
%>
		</select>
	</td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ����щ�</td>
	<td class="c_data_1" width="35%">
		<select name="complete_mark" class="inputsubmit">
		<option value="">��껜</option>
<%
		String complete_mark = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M645", "");
		out.println(complete_mark);
%>
		</select>
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 諛�＜����щ�</td>
	<td class="c_data_1" width="35%">
		<select name="po_status" class="inputsubmit">
		<option value="">��껜</option>
		<option value="C">���</option>
		<option value="R">蹂�꼍</option>
		</select>
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 怨��湲곌�</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="cont_from_date" size="8" class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_valid_from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
		~
		<input type="text" name="cont_to_date" size="8" class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_valid_to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
	</td>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ���瑜�	</td>
	<td width="35%" class="c_data_1">
        <select name="material_type" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
        <option value="">��껜</option>
        <%
        String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
        out.println(listbox1);
        %>
        </select>
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 以��瑜�	</td>
	<td width="35%" class="c_data_1">
        <select name="material_ctrl_type" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
        <option value=''>��껜</option>
        </select>
	</td>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ���瑜�	</td>
	<td width="35%" class="c_data_1">
        <select name="material_class1" class="inputsubmit">
        <option value=''>��껜</option>
        </select>
	</td>
</tr>

<!-- 2011-03-08 怨��泥닿껐��怨����hidden -->
<tr style="display: none;">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 怨��踰��</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="cont_seq" size="15" class="inputsubmit" maxlength="20">
	</td>
</tr>
<tr style="display: none;">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 怨��泥닿껐��/td>
	<td class="c_data_1" width="35%">
		<input type="text" name="cont_sign_from_date" size="8" class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_sign_valid_from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
		~
		<input type="text" name="cont_sign_to_date" size="8" class="inputsubmit" maxlength="8">
<!-- 		<a href="javascript:Calendar_Open('cont_sign_valid_to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
	</td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 怨��紐�/td>
	<td class="c_data_1" width="35%">
		<input type="text" name="cont_title" style="width:95%" class="inputsubmit" maxlength="100">
	</td>
</tr>
<tr style="display: none;">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 怨�����</td>
	<td class="c_data_1" width="35%">
		<select name="cont_status" class="inputsubmit">
		<option value="">��껜</option>
		<option value="C">���</option>
		<option value="R">蹂�꼍</option>
		</select>
	</td>
	<td width="15%" class="c_title_1">
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 怨����	</td>
	<td width="35%" class="c_data_1">
		<input type="hidden" name="cust_type">
		<input type="text" name="cust_code" size="10" class="inputsubmit" value='' >
		<a href="javascript:searchCust();"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" ></a>
		<input type="text" name="cust_name" size="26" class="input_data2" value='' style="border:0" readonly>
	</td>
</tr>
<tr style="display:none;">
	<!-- 2011-03-08 ���遺�� hidden -->
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ���遺��</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="sales_dept" size="15" maxlength="6" class="inputsubmit" value='' >
		<a href="javascript:PopupManager('SALES_DEPT');"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
		<input type="text" name="sales_dept_name" size="20" class="input_data2" readonly value=''>
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ������紐�/td>
	<td class="c_data_1" width="35%">
		<input type="text" name="wbs_name" style="width:95%" class="inputsubmit" maxlength="100">
	</td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ���紐�/td>
	<td class="c_data_1" width="35%">
		<input type="text" name="ct_name" style="width:95%" class="inputsubmit" maxlength="100">
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 諛�＜紐�/td>
	<td class="c_data_1" width="35%">
		<input type="text" name="po_name" style="width:95%" class="inputsubmit" maxlength="100">
	</td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ��“��/td>
	<td class="c_data_1" width="35%">
		<input type="text" name="maker_name" style="width:95%" class="inputsubmit" maxlength="24">
	</td>
</tr>
<tr style="display:none;">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> �대�遺��</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="demand_dept" size="15" maxlength="6" class="inputsubmit" value='<%=info.getSession("DEPARTMENT")%>'>
		<a href="javascript:PopupManager('DEMAND_DEPT');"><img src="../../images//button/query.gif" align="absmiddle" border="0" alt=""></a>
		<input type="text" name="demand_dept_name" size="20" class="input_data2" readonly value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>'>
	</td>
</tr>
</table>

<script language="javascript">rdtable_bot1()</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:doSelect()",2,"議���)</script></TD>
			<TD><script language="javascript">btn("javascript:doUpdate()",43,"����)</script></TD>
			<TD><script language="javascript">btn("javascript:doDelete()",3,"諛�＜���")</script></TD>
			<TD><script language="javascript">btn("javascript:doIngStop()",1,"諛�＜以��醫�껐")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid ��� bar -->
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","310")%>
	</td>
</tr>
</table>
</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe name = "work_frame" src=""  width="0" height="0" border="no" frameborder="no"></iframe>

</s:header>
<s:grid screen_id="PO_002" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


