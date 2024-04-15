<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>
<%
	String to_day 	 = SepoaDate.getShortDateString();
	String from_date = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(to_day,-30));
	String to_date 	 = SepoaString.getDateSlashFormat(to_day);	
	
	String summary		 = JSPUtil.paramCheck(request.getParameter("summary"));		
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	

	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String user_type	= info.getSession("USER_TYPE");
	String company_code	= info.getSession("COMPANY_CODE");
	String company_name	= info.getSession("COMPANY_NAME");
	String NAME_LOC		= info.getSession("NAME_LOC");	
	String USER_ID		= info.getSession("ID"); 
	String CTRL_CODE	= info.getSession("CTRL_CODE");
	String IS_ADMIN_USER	= info.getSession("IS_ADMIN_USER");
	String Var_CTRL_CODE	= "";
	
	if((!CTRL_CODE.equals("")) || (CTRL_CODE.length()>0))
	{
		if(CTRL_CODE.indexOf("&") >0)
		{
			//CTRL_CODE=CTRL_CODE.substring(0,CTRL_CODE.indexOf("&"));				
			Var_CTRL_CODE = CTRL_CODE.substring(0,CTRL_CODE.indexOf("&"));
		}
		
		if(Var_CTRL_CODE.indexOf("&") >0)
		{
			CTRL_CODE=Var_CTRL_CODE;	
		}
		else
		{
			//CTRL_CODE=Var_CTRL_CODE;		
			CTRL_CODE = CTRL_CODE;
		}
	}

	
	// Dthmlx Grid 전역변수들..
	String screen_id = "CT_006";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list2";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	<% if(summary.equals("true") || summary.equals("old")){ %>
    		setTimeout("doQuery();",500);
    	<% } %>     	
    }

	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }
    
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
 		if(status == "false") alert(msg);

		//if(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("BD_SELLER_CNT")).getValue() !="0")
		//{
			//GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("BD_SELLER_CNT")).setValue("yellow");
		//}
		return true;
    }
    
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);

    	if( header_name == "BD_NO")
		{

			var bd_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BD_NO")).getValue());
			var bd_count  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BD_COUNT")).getValue());
			var pub_type  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PUB_TYPE")).getValue());
			/*
			var param = "?bd_no=" + encodeUrl(bd_no) + "&bd_count=" + encodeUrl(bd_count);
			popUpOpen("bd_req_detail.jsp"+param, 'BD_REQ_DETAIL', '1090', '800');
			*/
			//openBdReqInfo(bd_no, bd_count);
			document.form.p_bd_no.value = bd_no;
			document.form.p_bd_count.value = bd_count;
			document.form.pub_type.value = pub_type;
			document.form.update_flag.value = "D";
			     
			var url = "bd_req_update.jsp";
			var width = "1040";
			var height = "700";
			
			doOpenPopup(url, width, height);
		}
    	
    	if( header_name == "PO_SELLER_NAME" ) {
    			
   			var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "PO_SELLER_CODE");
   			
   			if(vendor_code != null && vendor_code != "") {
   			
   				var url    = '/s_kr/admin/info/ven_bd_con.jsp';
   				var title  = '업체상세조회';
   				var param  = 'popup=Y';
   				param     += '&mode=irs_no';
   				param     += '&vendor_code=' + vendor_code;
   				popUpOpen01(url, title, '900', '700', param);
   				
   			}
   			
   		}
		
    	if( header_name == "PO_NUMBER")
		{
			/* 
			var PO_NUMBER = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PO_NUMBER")).getValue());
			var PO_COUNT  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PO_COUNT")).getValue());
			window.open("../procure/po_detail_display.jsp?PO_NUMBER="+PO_NUMBER+"&PO_COUNT="+PO_COUNT+"&PAGE_TYPE=P","PO_DETAIL_DISPLAY","width=1000,height=800");
			 */
			var po_number = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PO_NUMBER")).getValue());
    		var po_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PO_COUNT")).getValue());
            var url =  "<%=POASRM_CONTEXT_NAME%>/procure/po_popup.jsp?po_number="+po_number+"&po_count="+po_count;	

			doOpenPopup(url,'1100','570');
		}
		
    	if( header_name == "RFQ_NUMBER" ) {
            var rfq_number = LRTrim( GridObj.cells( rowId, GridObj.getColIndexById("RFQ_NUMBER") ).getValue() );
            var rfq_count  = LRTrim( GridObj.cells( rowId, GridObj.getColIndexById("RFQ_COUNT") ).getValue() );
            var url =  "<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_update.jsp";
            if( rfq_number != '' ) {
                document.form.P_RFQ_NUMBER.value = rfq_number;
                document.form.P_RFQ_COUNT.value  = rfq_count;
                document.form.popup_flag.value = "true";            
                document.form.save_flag .value = "display"; 
                doOpenPopup( url, '1050', '550' );
            }
        }
    	if( header_name == "EXEC_NO" ) {
    		var    exec_number = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("EXEC_NO")).getValue());  
            var    exec_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("EXEC_COUNT")).getValue());  
            if(exec_number != ''){
                window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_number+ "&pr_type=I&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");            	
            	
//                 document.forms[0].p_exec_no.value    = exec_number;
//                 document.forms[0].p_exec_count.value = exec_count;
//                 document.forms[0].p_popup_flag.value = "true";            
//                 document.forms[0].p_save_flag .value = "display"; 
//                 var url = "../sourcing/app_insert.jsp?popup_flag_header=true";
//                 doOpenPopup( url, '1050', '700' );
            }    
        }
    	
    }
 	function setSelectGrid(){
		
		for(var row = 0; row < GridObj.getRowsNum(); row++) 
		{
			GridObj.enableSmartRendering(true);
	    	GridObj.selectRowById(GridObj.getRowId(row), false, true);
	    	GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).setValue("1");
		}
	}
	
 	function setReTender(param) {
		//setSelectGrid();
		//alert("param=="+param);
		var grid_array = getGridChangedRows(GridObj, "SELECTED");	

		myDataProcessor = new dataProcessor(param);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
    
    function doOnCellChange(stage,rowId,cellInd)
    {
    	var max_value = GridObj.cells(rowId, cellInd).getValue();
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
    	
			return true;
		} else if(stage==2) {
			
			
			return true;
		}
		return false;
    }
    
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("CT_006.0001")%>");
		return false;
	}
    function initAjax()
	{ 
        doQuery();
    }
    
	/**
	 * @Function Name  : getBdList
	 * @작성일         : 2009. 07. 06
	 * @변경이력       :
	 * @Function 설명  :  조회
	 */		
	function doQuery()
	{
        var grid_col_id = "<%=grid_col_id%>";
    	var param = "mode=query&grid_col_id="+grid_col_id;
    	param += dataOutput();
    	GridObj.post(G_SERVLETURL, param);
    	GridObj.clearAll(false);
	}
	/**
	 * @Function Name  : doInsert
	 * @작성일         : 2009. 07. 10
	 * @변경이력       :
	 * @Function 설명  : 계약생성
	 */	
	function doInsert(){
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("CT_006.0004")%>");
			return;
		}
		 
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		 var cont_no = "";
		 var cont_gl_seq = "";
		 var exec_no = "";
		 var exec_count = "";
		 var rfq_no = "";
		 var rfq_count  = "";
		 var seller_code = "";
		 var seller_name = "";
		
		for(var i = 0; i < grid_array.length; i++)
		{
			exec_no 	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EXEC_NO")).getValue());
			exec_count 	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EXEC_COUNT")).getValue());
			cont_no 	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NUMBER")).getValue());
			cont_gl_seq  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			rfq_no 		 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("RFQ_NUMBER")).getValue());
			rfq_count  	 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("RFQ_COUNT")).getValue());
			seller_code  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("PO_SELLER_CODE")).getValue()); 
			seller_name  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("PO_SELLER_NAME")).getValue());  
		}
		
 		var param = "?exec_no=" + encodeUrl(exec_no) + "&exec_count=" + encodeUrl(exec_count) + "&cont_no=" + encodeUrl(cont_no) + "&cont_gl_seq=" + encodeUrl(cont_gl_seq) + "&rfq_no=" + encodeUrl(rfq_no) + "&rfq_count=" + encodeUrl(rfq_count); 
 		    //param += "&seller_code=" + encodeUrl(seller_code);// + "&seller_name=" + encodeUrl(seller_name); 
 		    param += "&rfq_no=" + encodeUrl(rfq_no); 
		     
 		popUpOpen("contract_insert.jsp"+param, 'cont_ins_pop', '1040', '700');  
	}

	/**
	 * @Function Name  : doInsert
	 * @작성일         : 2009. 07. 10
	 * @변경이력       :
	 * @Function 설명  : 계약생성
	 */	
	function doInsert_price(){
 		popUpOpen("contract_insert.jsp?contractPrice=Y", 'cont_ins_pop', '1040', '700');  
	}
/* 
	function doOpenPopup(url, width, height)
	{
	  	document.form.action = url;
	  	document.form.method = "post";
	  	
	  	//화면 가운데로 배치
	    var dim = new Array(2);
	
		dim = ToCenter(height,width);
		var top = dim[0];
		var left = dim[1];
	
	    var toolbar = 'no';
	    var menubar = 'no';
	    var status = 'yes';
	    var scrollbars = 'yes';
	    var resizable = 'yes';
	  	
	  	var setValue  = "left="+left+", top="+top+",width="+width+",height="+height+", toolbar="+toolbar+", menubar="+menubar+", status="+status+", scrollbars="+scrollbars+", resizable="+resizable ;
	
	 	var newWin = window.open('','EX', setValue);
	  	document.form.target = "EX";
	  	document.form.submit();
	}
	 */
	/**
	 * @Function Name  : SP0216_Popup
	 * @작성일       : 2009. 04. 24
	 * @변경이력     :
	 * @Function 설명  : 구매그룹 조회팝업
	 */
	function SP0216_Popup() {
		var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP0216&function=SP0216_Code&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
		Code_Search(url, '', '', '', '600', '500');
	}
	
	function SP0216_Code(code, text1) {
	    document.forms[0].ctrl_code.value = code  ;
	    document.forms[0].ctrl_name_loc.value = text1 ;
	}	
		
	/**
	 * @Function Name  : getCtrlPersonId
	 * @작성일       : 2009. 04. 24
	 * @변경이력     :
	 * @Function 설명  : 업체 조회 팝업
	 */
    function getSellerCode() {
        var arrayValue = new Array("<%=info.getSession("COMPANY_CODE")%>","");
        PopupCommonPost("SP0087","SP0087_getCode",arrayValue);
    }
    function SP0087_getCode( code, name  ) {
		document.forms[0].seller_code.value = code;
		document.forms[0].company_name.value = name;
    }
    function doRemove(inputString){
        //alert(inputString);
        var array_data = inputString.split("||");
        var len = array_data.length;
        for(var i=0;i<len;i++){
            document.getElementById(array_data[i]).value = "";
        }
    } 
    
    // 구매담당자 조회팝업  
    function getCtrlPerson() {
        var arrayValue = new Array("<%=info.getSession("COMPANY_CODE")%>","","");
        PopupCommonPost("SP0023","SP0023_getCode",arrayValue);
    }
    function SP0023_getCode( ls_ctrl_person_id ,  ls_ctrl_person_name,ls_ctrl_code, ls_ctrl_name ) {
        document.forms[0].ctrl_code.value = ls_ctrl_person_id;
        document.forms[0].ctrl_name_loc.value = ls_ctrl_person_name;
    }
    /**
	 * @Function Name  : getAssigment
	 * @작성일       : 2013. 07. 03
	 * @변경이력     :
	 * @Function 설명  : 담당자 조회팝업
	 */
    function getAssigment() {
        var ctrl_code = document.form.ctrl_code.value;
        PopupCommonPost( "SP0023", "SP0023_getCode1", new Array( "<%=info.getSession("COMPANY_CODE")%>", ctrl_code, ''), '', '', '', "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp" );
    }
    // 담당자지정 선택 이후 CALLBACK
    function SP0023_getCode1( ls_ctrl_person_id ,  ls_ctrl_person_name,ls_ctrl_code, ls_ctrl_name) {
        document.forms[0].ctrl_code.value = ls_ctrl_person_id;
        document.forms[0].ctrl_name_loc.value = ls_ctrl_person_name;

    }
    
    
	function setContractInsert() {
		var contract_number		= "";
		var contract_count		= "";
		var cont_seller_code	= "";
		var cont_seller_name	= "";
		var rfq_type			= "";
		var	contract_amt		= "";
		var bd_kind				= "";
		var checked_count		= 0;
		var pr_no 				="";
		var cont_type1_text 	="";
		var cont_type2_text 	="";
		var x_purchase_qty      ="";
		var delv_place          ="";
		var exec_no				="";
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
			
			contract_number		= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NUMBER")).getValue());
			contract_count		= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			cont_seller_code	= GridObj.cells(grid_array[i], GridObj.getColIndexById("PO_SELLER_CODE")).getValue();
			cont_seller_name	= GridObj.cells(grid_array[i], GridObj.getColIndexById("PO_SELLER_NAME")).getValue();
			contract_amt		= GridObj.cells(grid_array[i], GridObj.getColIndexById("EXEC_AMT_KRW")).getValue();
			exec_no				= GridObj.cells(grid_array[i], GridObj.getColIndexById("EXEC_NO")).getValue();
// 			rfq_type			= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("RFQ_TYPE")).getValue());
// 			bd_kind				= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("BD_KIND")).getValue());
// 			ctrl_person_id		= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CTRL_PERSON_ID")).getValue());
// 			ctrl_person_name	= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CTRL_PERSON_NAME")).getValue());
// 			pr_no	            = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_NO")).getValue());
// 			cont_type1_text	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE1_TEXT")).getValue());
// 			cont_type2_text	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE2_TEXT")).getValue());
// 			x_purchase_qty	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("X_PURCHASE_QTY")).getValue());
// 			delv_place   	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("DELV_PLACE")).getValue());
																								  
		}
		 
		//계약담당자는 사전에 지정이 안됨.2010.12.23 총무부요청사항
		//if(ctrl_person_id != '<=info.getSession("ID")>') {
		//	alert("계약 담당자가 아닙니다");
		//	return;
		//}
		
        if(checked_count > 1)  {
            alert(G_MSS2_SELECT);
            return;
        }

		if (confirm("계약서를 생성하시겠습니까?")) {
			var sTmpUrl = "";
			sTmpUrl = sTmpUrl + "contract_wait_list_insert.jsp";
			sTmpUrl = sTmpUrl + "?cont_seller_code=" + encodeUrl(cont_seller_code);
			sTmpUrl = sTmpUrl + "&cont_seller_name=" + encodeUrl(cont_seller_name);
			sTmpUrl = sTmpUrl + "&contract_amt="     + encodeUrl(contract_amt);
			sTmpUrl = sTmpUrl + "&exec_no="     	 + encodeUrl(exec_no);
			sTmpUrl = sTmpUrl + "&contract_number="  + encodeUrl(contract_number);
			sTmpUrl = sTmpUrl + "&contract_count="   + encodeUrl(contract_count);
// 			sTmpUrl = sTmpUrl + "&rfq_type="         + rfq_type;
// 			sTmpUrl = sTmpUrl + "&bd_kind="          + bd_kind;
// 			sTmpUrl = sTmpUrl + "&ctrl_person_id="   + ctrl_person_id;
// 			sTmpUrl = sTmpUrl + "&ctrl_person_name=" + ctrl_person_name;
// 			sTmpUrl = sTmpUrl + "&pr_no="            + pr_no;
// 			sTmpUrl = sTmpUrl + "&cont_type1_text="  + cont_type1_text;
// 			sTmpUrl = sTmpUrl + "&cont_type2_text="  + cont_type2_text;
// 			sTmpUrl = sTmpUrl + "&x_purchase_qty="   + x_purchase_qty;
// 			sTmpUrl = sTmpUrl + "&delv_place="       + delv_place;

			//alert(sTmpUrl);
			//return;
			location.href = sTmpUrl;

		}
	}    
	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        doQuery();
	    }
	}
</script>
</head>

<body leftmargin="10" topmargin="6" onload="setGridDraw();initAjax();">
<s:header>
<%
// 	if("true".equals(JSPUtil.nullToEmpty(request.getParameter("summary")))){ 
// 		thisWindowPopupScreenName= text.get("PR_005.PR_MANAGER_S")+" > "+text.get("PR_005.PR_MANAGER_S")+" > "+text.get("PR_005.PR_TITLE1_S")+" > "+text.get("PR_005.PR_TITLE2_S"); 
// 		thisWindowPopupFlag = "true";
// 	}
%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form">  
		<input type="hidden" name="popup_flag"/>
		<input type="hidden" name="save_flag"/>
		<input type="hidden" name="P_RFQ_NUMBER" id="P_RFQ_NUMBER" />
		<input type="hidden" name="P_RFQ_COUNT" id="P_RFQ_COUNT" />
		<input type="hidden" id="p_exec_count" name="p_exec_count" value="">
		<input type="hidden" id="p_exec_no" name="p_exec_no" value="">
		<input type="hidden" id="p_popup_flag" name="p_popup_flag" value="">
		<input type="hidden" id="p_save_flag" name="p_save_flag" value="">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td style="display: none;"><%=text.get("CT_006.T_SIGN_PERSON")%></td>
										<td style="display: none;">
											<input type="text" name="ctrl_name_loc" id="ctrl_name_loc" size="10" class="inputsubmit" readOnly  value="<%=info.getSession("NAME_LOC")%>">
											<a href="javascript:getCtrlPerson()">
												<img src="/images/icon/icon_search.gif" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('ctrl_person_id||ctrl_person_name');">
												<img src="/images/icon/icon_del.gif" align="absmiddle" border="0">
											</a>
											<input type="hidden" name="ctrl_person_id" id="ctrl_person_id" size="10" class="input_empty" value="<%=info.getSession("ID")%>">
											<input type="hidden" name="ctrl_code" id="ctrl_code" size="5" class="inputsubmit" readOnly value="<%=info.getSession("CTRL_TYPE_CODE_LIST")%>">
											<input type="hidden" name="ctrl_name" id="ctrl_name" size="25" class="inputsubmit" readOnly >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("CT_006.T_PO_SELLER_NAME")%></td>
										<td class="data_td">
											<input type="text" name="vendor_name_loc" id="vendor_name_loc" size="25" onkeydown='entKeyDown()'>
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
                        	<td>
<script language="javascript">
btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>");
</script>
							</td><%--  조회 --%> 
							<td>
<%-- <script language="javascript"> --%>
<%-- btn("javascript:doInsert()","<%=text.get("CT_006.T_CONTRACT_INSERT")%>"); --%>
<%-- </script> --%>
<script language="javascript">
btn("javascript:setContractInsert()","<%=text.get("CT_006.T_CONTRACT_INSERT")%>");
</script>
							</td><%-- 계약생성 --%> 
	                    </TR>
    	            </TABLE>
        	    </td>
        	</tr>
    	</table>
	</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>