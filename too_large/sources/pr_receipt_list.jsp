<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateDay( to_day, -30 );
    String  to_date     = to_day;
%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style type="text/css">
<!--
.input_white {
	font-size: 12px;
	color: #333333;
	padding-left: 3;
	font-weight: normal;
	padding-right: 3px;
	background-color: ffffff;
	border-style: none
}
-->
</style>

<%
	String HOUSE_CODE = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String PURCHASE_LOCATION = info.getSession("PURCHASE_LOCATION");
	String CTRL_CODE = info.getSession("CTRL_CODE");
	String SH_CONFIRM_YN = request.getParameter("sh_confirm_yn");	
	
	String ctrl_code = info.getSession("CTRL_CODE");

	String purchaser_id = "";
	String purchaser_nm = "";
	if(!"".equals(ctrl_code)){
		purchaser_id = "";
		purchaser_nm = "";
	}else{
		purchaser_id = info.getSession("ID");
		purchaser_nm = info.getSession("NAME_LOC");
	}
%>

<!-- Ajax lib include한다. utf-8로 씌여졌으므로 charset은 반드시 utf-8로 기술할 것!! -->
<script language="javascript" src="/include/script/js/lib/jslb_ajax.js" charset="utf-8">
</script>
<script language="javascript">
 <!--
	var house_code = "<%=HOUSE_CODE%>";
	var company_code = "<%=COMPANY_CODE%>";
	var param="";

	var button_flag = false;
	var cancel_flag = false;
	//견적요청 popup 상태
	var rfq_pop_id = false;
	var mode;

	var INDEX_SELECTED			;
	var INDEX_PR_NO				;
	var INDEX_SUBJECT			;
	var INDEX_ADD_DATE			;
	var INDEX_CONTRACT_HOPE_DAY	;
	var INDEX_DEMAND_DEPT_NAME	;
	var INDEX_ADD_USER_NAME		;
	var INDEX_ITEM_NO			;
	var INDEX_DESCRIPTION_LOC	;
	var INDEX_PURCHASER_NAME	;
	var INDEX_UNIT_MEASURE		;
	var INDEX_PR_QTY     		;
	var INDEX_CUR       		;
	var INDEX_UNIT_PRICE     	;
	var INDEX_PR_AMT     		;
	var INDEX_PR_KRW_AMT     	;
	var INDEX_REC_VENDOR_NAME	;
	var INDEX_DEMAND_DEPT		;
	var INDEX_ADD_USER_ID		;
	var INDEX_VENDOR_CODE		;
	var INDEX_SIGN_STATUS		;
	var INDEX_PR_TYPE			;
	var INDEX_PLANT_CODE		;
	var INDEX_SHIPPER_TYPE		;
	var INDEX_CTRL_CODE			;
	var INDEX_PR_SEQ 			;
	var INDEX_DELY_TO_ADDRESS 		;
	var INDEX_DELY_TO_ADDRESS_NAME 	;
	var INDEX_DELY_TO_LOCATION 		;
	var INDEX_DELY_TO_LOCATION_NAME ;
	var INDEX_RD_DATE 				;
	var INDEX_PURCHASE_LOCATION 	;
	var INDEX_CTRL_NAME 			;
	var INDEX_VENDOR_NAME 			;
	var INDEX_PO_VENDOR_CODE		;
	var INDEX_PO_UNIT_PRICE			;
	var Send_Data = "";
	function init() {
setGridDraw();
setHeader();
		setContextMenu();
		<%
			if(SH_CONFIRM_YN != null && !SH_CONFIRM_YN.equals("")){
				if(SH_CONFIRM_YN.equals("Y")){
					%>document.forms.form1.sh_confirm_yn.value = 'Y'<%
				}else if(SH_CONFIRM_YN.equals("N")){
					%>document.forms.form1.sh_confirm_yn.value = 'N'<%
				}
			}
		%>
		doSelect();
	}

	function checkSelectedRows() {

		var gridObj = GridObj;
		var f = gridObj.GetSelectedCells();
		var rtnArr = new Array();

		if (f.length > 0) {
		    var aArr = f.split(',');

		    var index = 0;
		    for (var i = 0; i < aArr.length; i += 2) {
		        gridObj.SetCellValue("SELECTED", aArr[i + 1], "1");
		    }
		}
	}

	function setContextMenu() {
<%--
		var gridObj = GridObj;
		gridObj.bUseDefaultContextMenu = false;
		gridObj.bUserContextMenu = true;

		gridObj.AddUserContextMenuItem('MENU_CELL','checkSelectedRows','선택한 열을 체크');
		gridObj.AddContextMenuSeparator('MENU_CELL');

		gridObj.AddDefaultContextMenuItem('MENUITEM_CELL_COPY');
		gridObj.AddDefaultContextMenuItem('MENUITEM_CELL_PASTE');
		gridObj.AddDefaultContextMenuItem('MENUITEM_CELL_EXCELEXPORT');
		gridObj.AddDefaultContextMenuItem('MENUITEM_CELL_FIND');

		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_ADDLEVEL');
		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_DELETELEVEL');
		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_SAVELAYOUT');
		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_RESETLAYOUT');
		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_HIDEHEADER');
		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_CANCELHIDEHEADER');
		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_FIXHEADER');
		gridObj.AddDefaultContextMenuItem('MENUITEM_HD_CANCELFIXHEADER');
		gridObj.AddDefaultContextMenuItem('MENUITEM_ROW_COPY');
		--%>
	}

	function setHeader() {
		 
	}//setHeader End

	//조회
	function doSelect() {
<%--
		CTRL_CODE = form1.CTRL_CODE.value;
		CTRL_CODE = CTRL_CODE.toUpperCase();
		form1.CTRL_CODE.value=CTRL_CODE;
		
		var MATERIAL_TYPE       = form1.MATERIAL_TYPE.value;
	    var MATERIAL_CTRL_TYPE  = form1.MATERIAL_CTRL_TYPE.value;
	    var MATERIAL_CLASS1     = form1.MATERIAL_CLASS1.value;
	    var MATERIAL_CLASS2     = form1.MATERIAL_CLASS2.value;
 
		GridObj.SetParam("mode", "prItemsList");
		GridObj.SetParam("start_add_date"     , form1.start_add_date.value);
		GridObj.SetParam("end_add_date"      	, form1.end_add_date.value);
		GridObj.SetParam("demand_dept"        , form1.demand_dept.value);
		GridObj.SetParam("purchaser_id"		, form1.purchaser_id.value);
		GridObj.SetParam("pr_no"				, form1.pr_no.value);
		//GridObj.SetParam("item_no"			, form1.item_no.value);
		GridObj.SetParam("pr_add_user_name"	, form1.pr_add_user_name.value);
    	GridObj.SetParam("order_no" 			, form1.order_no.value);
    	GridObj.SetParam("pr_wbs_name" 		, form1.pr_wbs_name.value);
    	GridObj.SetParam("sh_confirm_yn" 		, form1.sh_confirm_yn.value);
    	
    	GridObj.SetParam("item_nm"			, form1.item_nm.value);
    	GridObj.SetParam("MATERIAL_TYPE", MATERIAL_TYPE);
        GridObj.SetParam("MATERIAL_CTRL_TYPE", MATERIAL_CTRL_TYPE);
        GridObj.SetParam("MATERIAL_CLASS1", MATERIAL_CLASS1);
        GridObj.SetParam("MATERIAL_CLASS2", MATERIAL_CLASS2);
        
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		--%>
	}


	function checkUser() {
		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = true;
		var rowcount = GridObj.GetRowCount();

		for (var row = 0; row < rowcount; row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				for(i=0; i < ctrl_code.length; i++ ) {
					if (ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)) {
						flag = true;
						break;
					} else {
	                    flag = false;
	                }
	            }
	        }
	    }
	    return flag;
	}

	//견적요청
    function doRequest() {
        //이미 한번이라도 콜을 했을때
    	//견적은 KRW, 외화 둘다 할수있다. 하지만 KRW 끼리, 외화끼리만 할수있다.
    	//입찰, 역경매, 종가발주는 KRW만 할수있다.
		if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
			return;
		}
		/*if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<//%=info.getSession("ID")%>")){
			return;
		}*/

		var checkCnt=0;
		var cur 	="";
		var pr_data ="";

		var pr_type			= "";
		var req_type		= "";
		var create_type		= "";
		var shipper_type	= "";
		var pr_name 		= "";

		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkCnt ++;
				if(checkCnt == 1){
					cur = GridObj.GetCellValue("CUR", i);

					pr_type 		= GridObj.GetCellValue("PR_TYPE", i);
					req_type 		= GridObj.GetCellValue("REQ_TYPE", i);
					create_type		= GridObj.GetCellValue("CREATE_TYPE", i);
					shipper_type	= GridObj.GetCellValue("SHIPPER_TYPE", i);
					pr_name			= GridObj.GetCellValue("SUBJECT", i);
				}

				if(i == GridObj.GetRowCount()-1){
					pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
				}else {
					pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
				}
			}
		}

		if(checkCnt == 0){
			alert("선택하신 항목이 없습니다.");
			return;
		}

		if(!hasRequreCondition("CUR", "통화가 같아야합니다.", cur)){
			return;
		}

		if(!confirm("견적요청 하시겠습니까?")){
			return;
		}

		document.form2.PR_DATA.value        = pr_data;
		document.form2.PR_TYPE.value		= pr_type;
		document.form2.REQ_TYPE.value		= req_type;
		document.form2.CREATE_TYPE.value	= create_type;
		document.form2.SHIPPER_TYPE.value	= shipper_type;
		document.form2.PR_NAME.value		= pr_name;
		
		var url  = "/kr/dt/rfq/rfq_bd_ins1.jsp";
		window.open("","doRequest","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
		document.form2.method = "POST";
		document.form2.action = url;
		document.form2.target = "doRequest";
		document.form2.submit();

		/*
        if(rfq_pop_id){

            if(rfq_pop_id.closed){// true -> 윈도우는 닫힌상태 false -> 윈도우 활성화
                doRequest_New();
            }
            else{
                alert("현재 견적요청생성을 작업중에 있습니다.");
                rfq_pop_id.focus();
                return;
            }
        }else{// 한번도 콜하지 않았을때
            doRequest_New();
        }
        */
    }

    function doRequest_New() {
		if(!checkUser())
			return;

		var checked_count = 0;
		var checked_shipper_type_d = 0;
		var checked_shipper_type_o = 0;

        var PR_NO            = "";
        var PR_SEQ           = "";
        var ITEM_NO          = "";
        var DESCRIPTION_LOC  = "";
        var UNIT_MEASURE     = "";
        var PR_QTY           = "";
        var CUR              = "";
        var PR_UNIT_PRICE    = "";
        var SPECIFICATION    = "";
        var RD_DATE          = "";
        var DELY_TO_ADDRESS  = "";
        var PLANT_CODE       = "";
        var PR_TYPE          = "";
		var DELY_TO_LOCATION_NAME = "";
        var tempPrType = "";
        var tempPrFlag = "";

		for(row=0; row<GridObj.GetRowCount(); row++) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {

				checked_count++;

				var purchaser_name = GD_GetCellValueIndex(GridObj,row,INDEX_PURCHASER_NAME);
				if(purchaser_name == "") {
				 	alert("구매담당자를 먼저 선택하세요.");
				 	return;
				}
                item_flag =GD_GetCellValueIndex(GridObj,row, INDEX_PR_STATUS_FLAG);

                if( "C" == item_flag ) {
					alert("진행중인 ITEM은 견적요청서를 작성할 수 없습니다.");
					return;
				}

                pr_type =GD_GetCellValueIndex(GridObj,row, INDEX_PR_TYPE);

				if( checked_count == 1 ){
					tempPrType = pr_type;
					tempPrFlag = item_flag;
				}else{
    			    if( tempPrType != pr_type ){
    			        alert("요청구분이 동일한 item에 대해서만 견적요청를 생성하실 수 있습니다.");
    			        return;
    			    }

    			    if (tempPrFlag != item_flag){
    			        alert("견적요청를 생성하실 수 있습니다.");
    			        return;
    			    }

				}

				SHIPPER_TYPE = GD_GetCellValueIndex(GridObj,row, INDEX_SHIPPER_TYPE);

				if(SHIPPER_TYPE == "D")
					checked_shipper_type_d++;
				if(SHIPPER_TYPE == "O")
					checked_shipper_type_o++;
			}
		}

		params = getDataParams('RQ');

		if(typeof(params) == "undefined") return;

		if(checked_shipper_type_d > 0 && checked_shipper_type_o > 0 ) {
			alert("내자와 외자는 동시에 견적요청을 생성할 수 없습니다.");
			return;
		}

		sendRequest(moveRFQ,params,'POST','/servlets/dt.pr.AjaxPR',false,false);
	}//doRequest_New End

	function doBidding()
	{
		if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
			return;
		}
		/*if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<//%=info.getSession("ID")%>")){
			return;
		}*/
		var checkCnt=0;
		var cur 	="";
		var pr_data ="";

		var pr_type			= "";
		var req_type		= "";
		var create_type		= "";
		var shipper_type	= "";
		var preferred_bidder_vendor_name = "";
		var pr_name 		= "";

		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkCnt ++;
				cur 							= GridObj.GetCellValue("CUR", i);
				preferred_bidder_vendor_name	= GridObj.GetCellValue("PREFERRED_BIDDER_VENDOR_NAME", i);
				if(cur != "KRW"){
					alert("원화만 입찰요청을 하실 수 있습니다.");
					return;
				}

				if(preferred_bidder_vendor_name != ""){
					alert("이미 입찰에서 우선협상업체가 선정되었습니다.");
					return;
				}

				if(checkCnt == 1){
					pr_type 		= GridObj.GetCellValue("PR_TYPE", i);
					req_type 		= GridObj.GetCellValue("REQ_TYPE", i);
					create_type		= GridObj.GetCellValue("CREATE_TYPE", i);
					shipper_type	= GridObj.GetCellValue("SHIPPER_TYPE", i);
					pr_name			= GridObj.GetCellValue("SUBJECT", i);
				}

				if(i == GridObj.GetRowCount()-1){
					pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
				}else {
					pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
				}
			}
		}

		if(checkCnt == 0){
			alert("선택한 항목이 없습니다.");
			return;
		}

		if(!confirm("입찰요청 하시겠습니까?")){
			return;
		}

		document.form2.PR_DATA.value 		= pr_data;
		document.form2.PR_TYPE.value		= pr_type;
		document.form2.REQ_TYPE.value		= req_type;
		document.form2.CREATE_TYPE.value	= create_type;
		document.form2.SHIPPER_TYPE.value	= shipper_type;
		document.form2.PR_NAME.value		= pr_name;

		var url  = "bd_ann.jsp?BID_STATUS=AR";
		window.open("","doBidding","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		document.form2.method = "POST";
		document.form2.action = url;
		document.form2.target = "doBidding";
		document.form2.submit();
	}

	function moveBidding()
	{
		var wise = GridObj;
		var iRowCount = GridObj.GetRowCount();
		var iCheckedCount = 0;
		var subject = "";

		for(var i=0;i<iRowCount;i++)
		{
			subject = GD_GetCellValueIndex(GridObj,i,INDEX_SUBJECT);
			iCheckedCount++;
		}

		var url  = "/kr/dt/ebd/ebd_bd_ins1.jsp";

		var ebd_pop_id = window.open(url,"ebd_pop_id","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
        ebd_pop_id.focus();
	}

	function doReverseAuction()
	{
		if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
			return;
		}

		if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<%=info.getSession("ID")%>")){
			return;
		}

		var checkCnt=0;
		var cur 	="";
		var pr_data ="";

		var pr_type			= "";
		var req_type		= "";
		var create_type		= "";
		var shipper_type	= "";
		var pr_name 		= "";

		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkCnt ++;
				cur = GridObj.GetCellValue("CUR", i);
				if(cur != "KRW"){
					alert("원화만 역경매요청을 하실 수 있습니다.");
					return;
				}

				if(checkCnt == 1){
					pr_type 		= GridObj.GetCellValue("PR_TYPE", i);
					req_type 		= GridObj.GetCellValue("REQ_TYPE", i);
					create_type		= GridObj.GetCellValue("CREATE_TYPE", i);
					shipper_type	= GridObj.GetCellValue("SHIPPER_TYPE", i);
					pr_name			= GridObj.GetCellValue("SUBJECT", i);
				}

				if(i == GridObj.GetRowCount()-1){
					pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i);
				}else {
					pr_data += GridObj.GetCellValue("PR_NO", i) + "-" + GridObj.GetCellValue("PR_SEQ", i) + ",";
				}

			}
		}

		if(checkCnt == 0){
			alert("선택하신 항목이 없습니다.");
			return;
		}

		if(!confirm("역경매요청 하시겠습니까?")){
			return;
		}

		document.form2.PR_DATA.value 		= pr_data;
		document.form2.PR_TYPE.value		= pr_type;
		document.form2.REQ_TYPE.value		= req_type;
		document.form2.CREATE_TYPE.value	= create_type;
		document.form2.SHIPPER_TYPE.value	= shipper_type;
		document.form2.PR_NAME.value		= pr_name;

		var url  = "/kr/dt/rat/rat_bd_ins1.jsp";
		window.open("","doReverseAuction","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		document.form2.method = "POST";
		document.form2.action = url;
		document.form2.target = "doReverseAuction";
		document.form2.submit();

		/*
		var f = document.form2;
        params = getDataParams('RA');
		sendRequest(moveRAuction,params,'POST','/servlets/dt.pr.AjaxPR',false,false);
		*/
	}

	function moveRAuction()
	{
		return;

		var wise = GridObj;
		var iRowCount = GridObj.GetRowCount();
		var iCheckedCount = 0;
		var subject = "";

		for (var i=0;i<iRowCount;i++) {
			subject = GD_GetCellValueIndex(GridObj,i,INDEX_SUBJECT);
			iCheckedCount++;
		}

		var url  = "/kr/dt/rat/rat_bd_ins1.jsp";

		var ebd_pop_id = window.open(url,"rat_pop_id","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
        ebd_pop_id.focus();
	}

	function getDataParams(BID_TYPE)
	{
		var wise = GridObj;
		var SEND_BID_TYPE = "&BID_TYPE="+BID_TYPE;
		var PR_NO            = "";
        var PR_SEQ           = "";
        var ITEM_NO          = "";
        var DESCRIPTION_LOC  = "";
        var UNIT_MEASURE     = "";
        var PR_QTY           = "";
        var CUR              = "";
        var PR_UNIT_PRICE    = "";
        var SPECIFICATION    = "";
        var RD_DATE          = "";
        var DELY_TO_ADDRESS  = "";
        var PLANT_CODE       = "";
        var PR_TYPE          = "";
        var PR_AMT            = "";
		var CTRL_NAME         = "";
		var DEMAND_DEPT_NAME  = "";
		var VENDORCNT         = "";
		var REC_VENDOR_NAME   = "";
		var SHIPPER_TYPE_NAME = "";
		var CTRL_CODE         = "";
		var VENDOR_CODE       = "";
		var SHIPPER_TYPE      = "";
		var PURCHASE_LOCATION = "";
		var DELY_TO_LOCATION  = "";
		var ADD_USER_NAME     = "";
		var DELY_TO_LOCATION_NAME  = "";
		var PURCHASE_LOCATION = "";
        var PR_TYPE          = "";
		var CREATE_TYPE = "";
		var SUBJECT = "";
		var REQ_TYPE = "";
		var HUMAN_NAME_LOC = "";
		var TECHNIQUE_GRADE = "";
		var TECHNIQUE_FLAG = "";
		var TECHNIQUE_TYPE = "";
		var INPUT_FROM_DATE	= "";
		var INPUT_TO_DATE	= "";
		var ATTACH_NO	= "";
		var ATT_COUNT	= "";
		var PR_KRW_AMT = "";
		var MAKER_NAME = "";

		var chk_cnt = 0;

		for(var i=0;i<GridObj.GetRowCount();i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "true")
			{
				var pr_type = GD_GetCellValueIndex(GridObj,i, INDEX_PR_TYPE);

				PR_NO            = PR_NO             + "&PR_NO=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_NO);
				ITEM_NO          = ITEM_NO           + "&ITEM_NO=" + GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_NO);
				PR_SEQ           = PR_SEQ            + "&PR_SEQ=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_SEQ);
				DESCRIPTION_LOC  = DESCRIPTION_LOC   + "&DESCRIPTION_LOC=" + ( GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC) );
				UNIT_MEASURE     = UNIT_MEASURE      + "&UNIT_MEASURE=" + GD_GetCellValueIndex(GridObj,i, INDEX_UNIT_MEASURE);
				PR_QTY           = PR_QTY            + "&PR_QTY=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY);
				PR_AMT           = PR_AMT            + "&PR_AMT=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_AMT);
				CUR              = CUR               + "&CUR=" + GD_GetCellValueIndex(GridObj,i, INDEX_CUR);
				PR_UNIT_PRICE    = PR_UNIT_PRICE     + "&PR_UNIT_PRICE=" + GD_GetCellValueIndex(GridObj,i, INDEX_UNIT_PRICE);
				RD_DATE          = RD_DATE           + "&RD_DATE=" + GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE);
				DELY_TO_ADDRESS  = DELY_TO_ADDRESS   + "&DELY_TO_ADDRESS=" + GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS);
				PLANT_CODE       = PLANT_CODE        + "&PLANT_CODE=" + GD_GetCellValueIndex(GridObj,i, INDEX_PLANT_CODE);
				VENDOR_CODE       	= VENDOR_CODE        + "&VENDOR_CODE="       + GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_CODE      );
				SHIPPER_TYPE      	= SHIPPER_TYPE       + "&SHIPPER_TYPE="      + GD_GetCellValueIndex(GridObj,i,INDEX_SHIPPER_TYPE     );
				DELY_TO_LOCATION  	= DELY_TO_LOCATION   + "&DELY_TO_LOCATION="  + GD_GetCellValueIndex(GridObj,i,INDEX_DELY_TO_LOCATION );
				DELY_TO_LOCATION_NAME     = DELY_TO_LOCATION_NAME      + "&DELY_TO_LOCATION_NAME="     + GD_GetCellValueIndex(GridObj,i,INDEX_DELY_TO_LOCATION_NAME );
				PURCHASE_LOCATION   = PURCHASE_LOCATION  + "&PURCHASE_LOCATION="   + GD_GetCellValueIndex(GridObj,i,INDEX_PURCHASE_LOCATION  );
				ADD_USER_NAME   	= ADD_USER_NAME    	 + "&ADD_USER_NAME="   + GD_GetCellValueIndex(GridObj,i,INDEX_ADD_USER_NAME  );
				REC_VENDOR_NAME   	= REC_VENDOR_NAME    + "&REC_VENDOR_NAME="   + GD_GetCellValueIndex(GridObj,i,INDEX_REC_VENDOR_NAME  );
				SUBJECT 			= SUBJECT 			 + "&SUBJECT="   + GD_GetCellValueIndex(GridObj,i,INDEX_SUBJECT );    //cjsrm에서 SPECIFICATION을 사용안함으로 CREATE_TYPE을 SPECIFICATION으로 사용.
				CREATE_TYPE 		= CREATE_TYPE 		 + "&CREATE_TYPE="   + GD_GetCellValueIndex(GridObj,i,INDEX_CREATE_TYPE  );    //cjsrm에서 SPECIFICATION을 사용안함으로 CREATE_TYPE을 SPECIFICATION으로 사용.
				PR_TYPE          	= PR_TYPE            + "&PR_TYPE=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_TYPE);
				REQ_TYPE           	= REQ_TYPE           + "&REQ_TYPE=" + GD_GetCellValueIndex(GridObj,i, INDEX_REQ_TYPE );
				HUMAN_NAME_LOC      = HUMAN_NAME_LOC     + "&CTRL_NAME=" + GD_GetCellValueIndex(GridObj,i, INDEX_HUMAN_NAME_LOC );
				TECHNIQUE_GRADE     = TECHNIQUE_GRADE    + "&TECHNIQUE_GRADE=" + GD_GetCellValueIndex(GridObj,i, INDEX_TECHNIQUE_GRADE );
  				SPECIFICATION       = SPECIFICATION      + "&SPECIFICATION=" + GD_GetCellValueIndex(GridObj,i, INDEX_SPECIFICATION );
				TECHNIQUE_FLAG      = TECHNIQUE_FLAG     + "&TECHNIQUE_FLAG=" + GD_GetCellValueIndex(GridObj,i, INDEX_TECHNIQUE_FLAG );
  				TECHNIQUE_TYPE      = TECHNIQUE_TYPE     + "&TECHNIQUE_TYPE=" + GD_GetCellValueIndex(GridObj,i, INDEX_TECHNIQUE_TYPE );
  				INPUT_FROM_DATE		= INPUT_FROM_DATE    + "&INPUT_FROM_DATE=" + GD_GetCellValueIndex(GridObj,i, INDEX_INPUT_FROM_DATE );
				INPUT_TO_DATE		= INPUT_TO_DATE      + "&INPUT_TO_DATE=" + GD_GetCellValueIndex(GridObj,i, INDEX_INPUT_TO_DATE );
				ATTACH_NO			= ATTACH_NO     	 + "&ATTACH_NO=" + GD_GetCellValueIndex(GridObj,i, INDEX_ATTACH_NO );
				ATT_COUNT			= ATT_COUNT			 + "&ATT_COUNT=" + GD_GetCellValueIndex(GridObj,i, INDEX_ATT_COUNT );
  				PR_KRW_AMT			= PR_KRW_AMT			 + "&PR_KRW_AMT=" + GD_GetCellValueIndex(GridObj,i, INDEX_PR_KRW_AMT );
  				CTRL_CODE			= CTRL_CODE		+ "&CTRL_CODE=" + GD_GetCellValueIndex(GridObj,i, INDEX_CTRL_CODE );
  				MAKER_NAME			= MAKER_NAME		+ "&MAKER_NAME=" + GD_GetCellValueIndex(GridObj,i, INDEX_MAKER_NAME );

  				chk_cnt++;

			}
		}

		if(chk_cnt == 0) {
			alert(G_MSS1_SELECT);
			return;
		}

        if (BID_TYPE == "RQ" ) {
			Message = "견적요청을 생성하시겠습니까?";
        } else if (BID_TYPE == "EX" ) {
			Message = "입찰을 생성하시겠습니까?";
		} else if (BID_TYPE == "RA" ) {
			Message = "역경매를 생성하시겠습니까?";
		} else {
			alert("정의되지않은  Sourcing 입니다!");
			return;
		}

		if(!confirm(Message)) return;

		var params = SEND_BID_TYPE + PR_NO + ITEM_NO + PR_SEQ+ DESCRIPTION_LOC+ UNIT_MEASURE+ PR_QTY+ PR_AMT+ CUR+ PR_UNIT_PRICE;
		params = params + RD_DATE + DELY_TO_ADDRESS + PLANT_CODE ;
		params = params + CTRL_CODE + VENDOR_CODE + SHIPPER_TYPE;
		params = params + DELY_TO_LOCATION+ DELY_TO_LOCATION_NAME + PURCHASE_LOCATION+ ADD_USER_NAME+ REC_VENDOR_NAME;
		params = params + CREATE_TYPE  + SUBJECT + PR_TYPE;
		params = params + REQ_TYPE + HUMAN_NAME_LOC + SPECIFICATION + TECHNIQUE_GRADE  + TECHNIQUE_FLAG + TECHNIQUE_TYPE ;
		params = params + INPUT_FROM_DATE  + INPUT_TO_DATE + ATT_COUNT + ATTACH_NO + PR_KRW_AMT + MAKER_NAME;

		return params;
	}

	function moveRFQ(oj)
	{
		var url  = "/kr/dt/rfq/rfq_bd_ins1.jsp";
		var rfq_pop_id = window.open(url,"rfq_pop_id","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1000,height=560,left=0,top=0");
        rfq_pop_id.focus();
	}

	// 반송 / 외자반송
	function doReturn(flag) {
		/*
		if(!hasRequreCondition("CONFIRM_USER_ID", "이미 접수되었습니다.", "FULL")){
			return;
		}
		if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<//%=info.getSession("ID")%>")){
			return;
		}
		*/
		checked_count = 0;
		var email;
		var pr_name;
		rowcount = GridObj.GetRowCount();
		for(row=rowcount-1; row>=0; row--) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			    email 	= " ";//GD_GetCellValueIndex(GridObj,row, INDEX_EMAIL);
			    pr_name = GD_GetCellValueIndex(GridObj,row, INDEX_ADD_USER_NAME);

				checked_count++;
			}
		}

		if(checked_count == 0)  {
			alert("선택하신 항목이 없습니다.");
			return;
		}
		/*
		if( flag == "D" && checked_count > 1)  {
			alert("구매요청번호를 하나만 선택하십시요.");
			return;
		}
		*/
		mode = "reject";
		/*
		if( flag == "O" ){
		    msg = "외자반송하시겠습니까?";
		    if( !confirm(msg) ) return;
		    setReason("외자반송","doReturnO","07","","");
		}else{
		    pMode = "doReturn_doc";
		    msg = "반려하시겠습니까?";
		    if( !confirm(msg) ) return;
		    window.open('pr_pp_ins1.jsp?pMode='+pMode+'&email='+email+'&pr_name='+pr_name,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=580,height=340,left=0,top=0");
	    }
		*/
		pMode = "doReturn_doc";
		msg = "반려하시겠습니까?";
		if( !confirm(msg) ) return;
		window.open('pr_pp_ins1.jsp?pMode='+pMode+'&email='+email+'&pr_name='+pr_name,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=580,height=340,left=0,top=0");
	}//doReturn End


	function setReason(memo,pReturn,reason_code,email,pr_name) {
		mode="reject";

		if(pReturn	== "doReturnO") {                       //외자반려

			GridObj.SetParam("mode", "reject");
			GridObj.SetParam("flag", "O");
			GridObj.SetParam("pTitle_Memo", memo);
			GridObj.SetParam("reason_code", reason_code);
			GridObj.SetParam("email", email);
			GridObj.SetParam("pr_name", pr_name);
			GridObj.SetParam("req_type", "P");
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}else if(pReturn	== "doReturn_doc") {                //반송 
			GridObj.SetParam("mode", "reject");
			GridObj.SetParam("flag", "D");
			GridObj.SetParam("pTitle_Memo", memo);
			GridObj.SetParam("reason_code", reason_code);
			GridObj.SetParam("email", email);
			GridObj.SetParam("pr_name", pr_name);
			GridObj.SetParam("req_type", "P");
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}
	}//setReason End


	//이관
	function doTransfer() {

        checked_count = 0;
		rowcount = GridObj.GetRowCount();

		for(row=rowcount-1; row>=0; row--) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				checked_count++;
			}
		}

		if(checked_count == 0)  {
			alert("선택하여주십시요!");
			button_flag = false;
			return;
		}

		Transfer_id 			= LRTrim(form1.Transfer_id.value);
		Transfer_name 			= LRTrim(form1.Transfer_name.value);
		Transfer_person_id 		= LRTrim(form1.Transfer_person_id.value);
		Transfer_person_name 	= LRTrim(form1.Transfer_person_name.value);
		Transfer_id 			= Transfer_id.toUpperCase();

		if(Transfer_person_id == "") {
			alert("구매담당자를 입력하셔야 합니다.");
			button_flag = false;
			return;
		}
		/*
		if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<%=info.getSession("ID")%>")){
			return;
		}
		*/
		Message = "구매담당을 "+Transfer_name+" / "+Transfer_person_name+"으로 지정 하시겠습니까?";
		if(confirm(Message) == 1) { 
			GridObj.SetParam("mode", "charge_transfer");//
			GridObj.SetParam("Transfer_id", Transfer_id);
			GridObj.SetParam("Transfer_name", Transfer_name);
			GridObj.SetParam("Transfer_person_id", Transfer_person_id);
			GridObj.SetParam("Transfer_person_name", Transfer_person_name);

			mode = "doTransfer";
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}

	}//doTransfer End

    function allEqualLineCheck() {}
	
	function setVendorName(tmpVendorName) {
	    GD_SetCellValueIndex(GridObj,tmpVendorRow,INDEX_VENDOR_NAME,tmpVendorName);
	}

	var row = 0;
	var TEMP_TAX_CODE_ID;
	var tmpRdDate;
	var tmpVendorRow;

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {

        row = msg2;
        /*
		for(var i=0;i<GridObj.GetRowCount();i++) {
			if(i%2 == 1){
				for (var j = 0;	j<GridObj.GetColCount(); j++){
					//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
				}
			}
		}
		*/
		if(msg1 == "doQuery") {
			//GridObj.SetGroupMerge("PR_NO,SUBJECT");
		} else if(msg1 == "doData") {
			var mode = GD_GetParam(GridObj,2);
			var status = GD_GetParam(GridObj,0);

			if(mode == "charge_transfer") {
				alert(GridObj.GetMessage());
				button_flag = false; // 버튼 action ...  action을 취할수있도록...
				if(status == "1") {
					doSelect();
					document.form1.Transfer_id.value = "";
					document.form1.Transfer_name.value = "";
					document.form1.Transfer_person_id.value = "";
					document.form1.Transfer_person_name.value = "";
				}
			} else if(mode == "reject") {
				button_flag = false; // 버튼 action ...  action을 취할수있도록...
				alert(GridObj.GetMessage());
				if(status == "1") {
					doSelect();
				}
			} else if(mode == "po_domestic") {
				alert(GridObj.GetMessage());
				button_flag = false; // 버튼 action ...  action을 취할수있도록...
				if("1" == status) {
					doSelect();
				}
			} else if(mode == "po_export") {
				if("0" == status) {
					button_flag = false; // 버튼 action ...  action을 취할수있도록...
					alert(GridObj.GetMessage());
				} else {
					button_flag = false; // 버튼 action ...  action을 취할수있도록...
					window.open("/kr/order/bpo/po2_bd_ins1.jsp?bType=PR"+"&prStr="+Send_Data,"_self","");
				}
			}else if(mode == "setSendPo"){
				if(status == "1") {
					//alert(GridObj.GetMessage());
					alert("정상적으로 처리되었습니다.\n\n기안대기현황에서 기안서를 작성하세요.");
					doSelect();
				}
			}else if(mode == "setDirectPo"){
				if(status == "1") {
					//alert(GridObj.GetMessage());
					alert("정상적으로 처리되었습니다.\n\직발주대상조회에서 발주생성하세요.");
					doSelect();
				}
			}else if(mode == "doConfirm"){
				alert(GridObj.GetMessage());
				doSelect();
			}
		} else if(msg1 == "t_imagetext") {
			//구매요청번호

      		var img_pr_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_NO);
            if (msg3 == INDEX_PR_NO) {
      			window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+img_pr_no,"pr1_bd_dis1","left=0,top=0,width=1024,height=650,resizable=yes,scrollbars=yes");
			}
			if (msg3 == INDEX_UNIT_PRICE_CONTRACT_VENDOR_CNT) {
				  tmpVendorRow = msg2;
      			var info_cnt 			= GD_GetCellValueIndex(GridObj,msg2,INDEX_UNIT_PRICE_CONTRACT_VENDOR_CNT);
      			var purchase_location 	= GD_GetCellValueIndex(GridObj,msg2,INDEX_PURCHASE_LOCATION);
      			var item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);

      			if(info_cnt > 0 ) {
      				/*
            		var pr_status_flag = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_STATUS_FLAG);
            		if(pr_status_flag == "B") {//종전단가
            			var pr_location = GD_GetCellValueIndex(GridObj,msg2,INDEX_PURCHASE_LOCATION);
	      				var item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
	      				var item_flag = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_STATUS_FLAG);
	      				window.open("/kr/dt/pr/pr5_pp_lis1.jsp?pr_location="+pr_location+"&item_no="+item_no+"&item_flag="+item_flag,"pr5_pp_lis1","left=0,top=0,width=500,height=300,resizable=yes,scrollbars=yes");
	      			}else{

						var bid_status = GD_GetCellValueIndex(GridObj,msg2,INDEX_BID_STATUS);
	      				var item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
      					var pr_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_NO);
            			var bid_pr_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_BID_PR_NO);
            			var pr_type = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_TYPE);
            			var item_flag = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_STATUS_FLAG);
	      				window.open("/kr/dt/pr/pr5_pp_lis1.jsp?bid_pr_no="+bid_pr_no+"&pr_no="+pr_no+"&item_no="+item_no+"&pr_type="+pr_type+"&item_flag="+item_flag,"pr5_pp_lis1","left=0,top=0,width=500,height=300,resizable=yes,scrollbars=yes");

	      			}
	      			*/
	      			window.open("/kr/dt/pr/pr5_pp_lis1.jsp?pr_location=" + purchase_location + "&item_no="+item_no,"pr5_pp_lis1","left=0,top=0,width=500,height=300,resizable=yes,scrollbars=yes");
      			}
			}
        } else if(msg1 == "t_insert") {

			if(msg3 == INDEX_SELECTED)
			{
				//selectCond(GridObj, msg2);
			}
		}

	}//JavaCall End

	function selectCond(wise, selectedRow)
	{
		var wise = GridObj;
		var cur_pr_no  	 = GD_GetCellValueIndex(wise,selectedRow, INDEX_PR_NO);
		var iRowCount   	 = wise.GetRowCount();
		for(var i=0;i<iRowCount;i++)
		{
			if(i==selectedRow)
				continue;
			if(cur_pr_no == GD_GetCellValueIndex(wise,i,INDEX_PR_NO))
			{
				var flag = "true";
				GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");

			}else{
				var flag = "false";
				GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
			}
		}
	}

	function POPUP_Open(url, title, left, top, width, height) {
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		code_search.focus();
  	}//POPUP_Open End

	function reason() {
		window.open("../../approval/app_pp_dis1.htm","windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=548,height=170,left=0,top=0")
	}
	function START_SIGN_DATE(year,month,day,week) {
   		document.form1.START_SIGN_DATE.value=year+month+day;
	}
	function END_SIGN_DATE(year,month,day,week) {
   		document.form1.END_SIGN_DATE.value=year+month+day;
	}

	function send_po(){

		if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
			return;
		}
		
		/*if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<//%=info.getSession("ID")%>")){
			return;
		}*/

		var wise = GridObj;
		var f = document.forms[1];
		var sign_flag;

		var iRowCount = wise.GetRowCount();
		var iCheckedCount =	0;
		var args="";
		for(i=0;i<iRowCount;i++){
			if("true"==GD_GetCellValueIndex(wise, i, INDEX_SELECTED)){
				/*var purchaser_name = GD_GetCellValueIndex(GridObj,i,INDEX_PURCHASER_NAME);
				if(purchaser_name == "") {
				 	alert("구매담당자를 먼저 선택하세요.");
				 	return;
				}*/
				sign_flag		 = GD_GetCellValueIndex(wise,i,INDEX_SIGN_STATUS);
				if(sign_flag != "E"){
					alert("결재완료된 건에 대해서만 발주요청을 하실 수 있습니다.");
					return;
				}

				if(GridObj.GetCellValue("PO_VENDOR_CODE", i) == ""){
					alert("발주대상업체를 선택하여 주십시요.");
					return;
				}
				iCheckedCount++;
			}
		}
		if(iCheckedCount<1) {
			alert("항목을 선택해 주세요.");
			return;
		}
		if(confirm("종가발주를 하시겠습니까?")==1){
		    mode = "setSendPo";
		    GridObj.SetParam("mode",     		mode);
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}
	}
	
	function direct_po()
	{
		if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
			return;
		}
		
		/*if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<//%=info.getSession("ID")%>")){
			return;
		}*/

		var wise = GridObj;
		var f = document.forms[1];
		var sign_flag;

		var iRowCount = wise.GetRowCount();
		var iCheckedCount =	0;
		var args="";
		for(i=0;i<iRowCount;i++){
			if("true"==GD_GetCellValueIndex(wise, i, INDEX_SELECTED)){

				/* var purchaser_name = GD_GetCellValueIndex(GridObj,i,INDEX_PURCHASER_NAME);
				if(purchaser_name == "") {
				 	alert("구매담당자를 먼저 선택하세요.");
				 	return;
				} */
				sign_flag		 = GD_GetCellValueIndex(wise,i,INDEX_SIGN_STATUS);
				if(sign_flag != "E"){
					alert("결재완료된 건에 대해서만 발주요청을 하실 수 있습니다.");
					return;
				}

				if(GridObj.GetCellValue("PO_VENDOR_CODE", i) == ""){
					alert("발주대상업체를 선택하여 주십시요.");
					return;
				}
				iCheckedCount++;
			}
		}
		if(iCheckedCount<1) {
			alert("항목을 선택해 주세요.");
			return;
		}
		if(confirm("직발주를 하시겠습니까?")==1){
		    mode = "setDirectPo";
		    GridObj.SetParam("mode",     		mode);
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}
	}

	/*
	결재, 저장
	*/
	function Approval(sign_status)
	{
		var wise = GridObj;
		var f = document.forms[1];
		var sign_flag;

		var iRowCount = wise.GetRowCount();
		var iCheckedCount =0;

		for(i=0;i<iRowCount;i++){

			if("true"==GD_GetCellValueIndex(wise, i, INDEX_SELECTED)){
				iCheckedCount++;
				sign_flag=GD_GetCellValueIndex(wise,i,INDEX_SIGN_STATUS);
				if(sign_flag == "E" || sign_flag == "P"){
					alert("결재중이거나 결재완료된 건에 대해서는 결재요청을 하실 수 없습니다.");
					return;
				}
			}
		}
		if(iCheckedCount<1)
		{
			alert(G_MSS1_SELECT);
			return;
		}

		if(sign_status == "P")
		{
			f.method = "POST";
			f.target = "childFrame";
			f.action = "/kr/admin/basic/approval/approval.jsp";
			f.submit();
		}
		else if(sign_status == G_SAVE_STATUS)
		{
			getApproval(sign_status);
		}
	}//Approval End
	function getApproval(str) {

		if(str == ""){
			alert("결재자를 지정해 주세요");
			return;
		}

		Message = "결재요청을 하시겠습니까";

		if(confirm(Message) == 1) {
			cancel_flag = true;
			servletUrl = "/servlets/dt.pr.pr5_bd_lis2"; //pr1_bd_lis1";
			mode = "setApprovalCreate";			//p2016.setApprovalCreate
			GridObj.SetParam("mode", mode);
			GridObj.SetParam("param", "");
			GridObj.SetParam("APPROVAL", str);
			GridObj.SetParam("SIGN_FLAG", "P");
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl,"ALL","ALL");
		}
	}

  	function checkConfirm_Qty() {
  		for(var row=0; row<GridObj.GetRowCount(); row++) {
  			if("true" == GD_GetCellValueIndex(GridObj,row, "0")) {
	  			if(0 >= parseFloat(GD_GetCellValueIndex(GridObj,row, INDEX_CONFIRM_QTY))) {
	  				return false;
	  			}
	  		}
  		}
  		return true;
  	}

	function SP0023_Popup() {
		var left = 0;
		var top = 0;
		var width = 570;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function  SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {

		form1.Transfer_id.value = USER_ID;
		form1.Transfer_name.value = USER_NAME_LOC;
		form1.Transfer_person_id.value = USER_ID;
		form1.Transfer_person_name.value = USER_NAME_LOC;

	}
	
	function SP0352_Popup() {
		var left = 0;
		var top = 0;
		var width = 670;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0352&function=SP0352_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function  SP0352_getCode(CTRL_NAME, CTRL_CODE, USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {

		form1.Transfer_id.value = CTRL_CODE;
		form1.Transfer_name.value = CTRL_NAME;
		form1.Transfer_person_id.value = USER_ID;
		form1.Transfer_person_name.value = USER_NAME_LOC;

	}

	function SP0180_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0180&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=20070521&values=20070621";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function SP0180_getCode(pr_no, subject) {
		document.form1.pr_no.value = pr_no;
	}

    function catalog() {
    windowopen1 = window.open("pr1_pp_lis2_frame.jsp?item_cnt=one","catalog","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1010,height=500,left=0,top=0");
    }

	function SP0149_Popup() {
	var left = 0;
	var top = 0;
	var width = 570;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0149&function=SP0149_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=&desc=";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function SP0149_Popup_getCode(code, text) {
		//document.form1.item_no.value = code;
		//document.form1.item_name.value = text;
	}

function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "ADD_USER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	if(part == "DEMAND_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	//구매담당직무
	if(part == "CTRL_CODE")
	{
		PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
	}
	if(part == "PURCHASER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getPurUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}
function getPurUser(code, text)
{
	document.form1.purchaser_name.value = text;
	document.form1.purchaser_id.value = code;
}
//구매담당직무
function getCtrlManager(code, text)
{
	document.form1.ctrl_code.value = code;
	document.form1.ctrl_name.value = text;
}

function getAddUser(code, text)
{
	document.form1.purchaser_name.value = text;
	document.form1.purchaser_id.value = code;
}

function getDemand(code, text)
{
	document.form1.demand_dept_name.value = text;
	document.form1.demand_dept.value = code;
}

/**
 * 발주업체 세팅
 */
function setPo(po_vendor_code, po_vendor_name, po_unit_price) {

	GD_SetCellValueIndex(GridObj,row,INDEX_PO_VENDOR_CODE	,po_vendor_code);
	GD_SetCellValueIndex(GridObj,row,INDEX_VENDOR_NAME	,po_vendor_name);
	GD_SetCellValueIndex(GridObj,row,INDEX_PO_UNIT_PRICE	,po_unit_price);
	return true;
}

function start_add_date(year,month,day,week)
{
    document.form1.start_add_date.value = year+month+day;
}

function end_add_date(year,month,day,week)
{
    document.form1.end_add_date.value = year+month+day;
}

// 접수
function doConfirm(){
	// 구매담당자지정 - 접수 - 소싱
	// 구매담당자 체크 

	var chk_cnt = 0;
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "true"){
 				chk_cnt++;
		}
	}
	
	if(chk_cnt == 0) {
		alert("선택하신 항목이 없습니다.");
		return;
	}
	
	if(!hasRequreCondition("CONFIRM_USER_ID", "이미 접수되었습니다.", "FULL")){
		return;
	}
	
	//if(hasManagerCondition("PURCHASER_ID", "선택한 구매 요청건에 대해 담당자로써 업무를 진행하시겠습니까?")){
	if(hasRequreCondition("PURCHASER_ID", "담당자를 먼저 지정해주십시요.")){
		if (confirm('접수하시겠습니까?')) {
			mode = "doConfirm";
			GridObj.SetParam("mode", mode);
			GridObj.SetParam("req_type", "P");
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}
	}
}

// 구매담당자 지정여부, 접수여부 체크, 담당자 체크
function hasRequreCondition(_condition , _msg, _emptyOrFull){
	var condition = "";
	_emptyOrFull = _emptyOrFull == null ? "EMPTY" : _emptyOrFull;

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			condition = GridObj.GetCellValue(_condition, i);
			if(_emptyOrFull == "EMPTY"){
				if(condition == ""){
					alert(_msg);
					return false;
				}
			}else if(_emptyOrFull =="FULL"){
				if(condition != ""){
					alert(_msg);
					return false;
				}
			}else{	// EMPTY, FULL 값이 아니고 특정한 값
				if(condition != "" && condition != _emptyOrFull){
					alert(_msg);
					return false;
				}
			}
		}
	}
	return true;
}

// 구매담당자 지정여부, 접수여부 체크, 담당자 체크
function hasManagerCondition(_condition , _msg, _emptyOrFull){
	var condition = "";
	_emptyOrFull = _emptyOrFull == null ? "EMPTY" : _emptyOrFull;

	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			condition = GridObj.GetCellValue(_condition, i);
			if(_emptyOrFull == "EMPTY"){
				if(condition == ""){
					if (confirm(_msg)) {
						return false;
					}
				}
			}else if(_emptyOrFull =="FULL"){
				if(condition != ""){
					if (confirm(_msg)) {
						return false;
					}
				}
			}else{	// EMPTY, FULL 값이 아니고 특정한 값
				if(condition != "" && condition != _emptyOrFull){
					if (confirm(_msg)) {
						return false;
					}
				}
			}
		}
	}
	return true;
}

function doModify(){
	checkCnt = 0;
	pr_data  = "";
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			cur = GridObj.GetCellValue("CUR", i);
			if(cur != "KRW"){
				//alert("원화만 입찰요청을 하실 수 있습니다.");
				//return;
			}
			pr_data = GridObj.GetCellValue("PR_NO", i);
		}
	}
	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		return;
	}
	if(checkCnt > 1){
		alert("수정은 한건씩만 가능합니다");
		return;
	}
	/*
	if(!hasRequreCondition("CONFIRM_USER_ID", "접수를 먼저 해주십시요.")){
		return;
	}
	if(!hasRequreCondition("PURCHASER_ID", "담당자가 아닙니다.", "<%=info.getSession("ID")%>")){
		return;
	}
	*/
	document.form2.PR_NO.value = pr_data;
	
	var url  = "/kr/dt/pr/pr1_bd_ins2.jsp";
	window.open("","doModifyPR","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=760,left=0,top=0");
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doModifyPR";
	document.form2.submit();
}

function MATERIAL_TYPE_Changed()
{
    clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS1("전체", "");
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0009";
    var code = "M041";
    var value = form1.MATERIAL_TYPE.value;
    target = "MATERIAL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}
function MATERIAL_CTRL_TYPE_Changed()
{
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0019";
    var code = "M042";
    var value = form1.MATERIAL_CTRL_TYPE.value;
    target = "MATERIAL_CTRL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function MATERIAL_CLASS1_Changed()
{
    clearMATERIAL_CLASS2();
    var id = "SL0089";
    var code = "M122";
    var value = form1.MATERIAL_CLASS1.value;
    target = "MATERIAL_CLASS1";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}
function clearMATERIAL_CTRL_TYPE() {
    if(form1.MATERIAL_CTRL_TYPE.length > 0) {
        for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
            form1.MATERIAL_CTRL_TYPE.options[i] = null;
        }
    }
}
function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
}
function clearMATERIAL_CLASS1() {
    if(form1.MATERIAL_CLASS1.length > 0) {
        for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS1.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS1(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
}
function clearMATERIAL_CLASS2() {
    if(form1.MATERIAL_CLASS2.length > 0) {
        for(i=form1.MATERIAL_CLASS2.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS2.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS2(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.length] = option1;
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.pr_receipt_list";

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
<%--    
	
    
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

function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getPrReceiptList";
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
    
    document.forms[0].start_add_date.value = add_Slash( document.forms[0].start_add_date.value );
    document.forms[0].end_add_date.value   = add_Slash( document.forms[0].end_add_date.value   );
    
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">

<s:header>
<!--내용시작-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		구매요청 > 구매요청 접수 > 구매요청 접수 
		<//%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>
 
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">

<form name="form2" action="/kr/dt/rfq/rfq_bd_ins1.jsp" method="post">
	<!--견적요청 hidden-->
	<input type="hidden" name="PR_NO"		id="PR_NO"		        >
	<input type="hidden" name="ITEM_NO"		id="ITEM_NO"		        >
	<input type="hidden" name="PR_NO_H" 		id="PR_NO_H" 		        value="">
	<input type="hidden" name="PR_SEQ_H" 		id="PR_SEQ_H" 		value="">
	<input type="hidden" name="BUYER_ITEM_NO_H" 	id="BUYER_ITEM_NO_H" 	        value="">
	<input type="hidden" name="DESCRIPTION_LOC_H" 	id="DESCRIPTION_LOC_H" 	value="">
	<input type="hidden" name="UNIT_MEASURE_H" 	id="UNIT_MEASURE_H" 	        value="">
	<input type="hidden" name="PR_QTY_H" 		id="PR_QTY_H" 		value="">
	<input type="hidden" name="UNIT_PRICE_H" 	id="UNIT_PRICE_H" 	        value="">
	<input type="hidden" name="RD_DATE_H" 		id="RD_DATE_H" 		value="">
	<input type="hidden" name="DELY_TO_ADDRESS_H" 	id="DELY_TO_ADDRESS_H" 	value="">
	<input type="hidden" name="PLANT_NAME_H" 	id="PLANT_NAME_H" 	        value="">
	<input type="hidden" name="CHANGE_USER_NAME_H" 	id="CHANGE_USER_NAME_H" 	value="">
	<input type="hidden" name="TEL_NO_H" 		id="TEL_NO_H" 		value="">
	<input type="hidden" name="CTRL_CODE_H" 	id="CTRL_CODE_H" 	        value="">
	<input type="hidden" name="PLANT_CODE_H" 	id="PLANT_CODE_H" 	        value="">
	<input type="hidden" name="CUR_H" 		id="CUR_H" 		        value="">
	<input type="hidden" name="PRTYPE_H" 		id="PRTYPE_H" 		value="">
	<input type="hidden" name="REQ_TYPE" 		id="REQ_TYPE" 		value="P">
	<input type="hidden" name="dom_loi_flag" 	id="dom_loi_flag" 	        value="">
                                                                                 
	<input type="hidden" name="PR_DATA"		id="PR_DATA"		        	>
	<input type="hidden" name="PR_TYPE"     	id="PR_TYPE"     	        value="">
	<input type="hidden" name="REQ_TYPE"    	id="REQ_TYPE"    	        value="">
	<input type="hidden" name="CREATE_TYPE" 	id="CREATE_TYPE" 	        value="">
	<input type="hidden" name="SHIPPER_TYPE" 	id="SHIPPER_TYPE" 	        value="">
	<input type="hidden" name="PR_NAME"		id="PR_NAME"		         value="">

</form>
<form name="form1">
	<!-- hidden -->
	<input type="hidden" name="buyer_item_no" id="buyer_item_no" value="">
	<input type="hidden" name="CTRL_CODE" id="CTRL_CODE" value="<%=CTRL_CODE%>">
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
	<input type="hidden" name="sign_status" 	id="sign_status" 	        value="">
	<input type="hidden" name="house_code" 		id="house_code" 		value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code" 	id="company_code" 	        value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code" 		id="dept_code" 		value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id" 	id="req_user_id" 	        value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type" 		id="doc_type" 		value="PRD">
	<input type="hidden" name="fnc_name" 		id="fnc_name" 		value="getApproval">
	<input type="hidden" name="VENDOR_CODE" 	id="VENDOR_CODE" 	        value="">
	<input type="hidden" name="DELY_TERMS" 		id="DELY_TERMS" 		value="">
	<input type="hidden" name="PAY_TERMS" 		id="PAY_TERMS" 		value="">
	<input type="hidden" name="ARRIVAL_PORT" 	id="ARRIVAL_PORT" 	        value="">
	<input type="hidden" name="INFO_VENDOR_CODE" 	id="INFO_VENDOR_CODE" 	value="">
	<input type="hidden" name="PO_UNIT_PRICE" 	id="PO_UNIT_PRICE" 	        value="">

		<tr>
			<td class="c_title_1" width="15%">요청일자</td>
			<td class="c_data_1" width="35%">
      		<s:calendar id_from="start_add_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="end_add_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
         
			</td>
			<td width="15%" class="c_title_1">요청부서</td>
			<td class="c_data_1">
				<input type="text" name="demand_dept" id="demand_dept" size="15" maxlength="6" class="inputsubmit" value='' onBlur="javascript: param1 = form1.demand_dept.value; ">
					<a href="javascript:PopupManager('DEMAND_DEPT');"><img src="/images/button/query.gif" align="absmiddle" border="0" id=h13> 
					</a>
					<input type="text" name="demand_dept_name" size="20" class="input_data2" readonly value=''>
			</td>
		</tr>
		<tr> 
			<td width="15%" class="c_title_1">요청자</td>
			<td class="c_data_1" colspan="1">
				<input type="text" name="pr_add_user_name" id="pr_add_user_name" style="width:95%" maxlength="20" class="inputsubmit">
			</td>
			<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 구매요청번호</td>
			<td class="c_data_1">
				<input type="text" name="pr_no" id="pr_no" style="width:95%" maxlength="20" class="inputsubmit">
			</td>
		</tr> 
		<tr style="display:none;">
			<td class="c_title_1">관리번호</td>
			<td class="c_data_1" colspan="3">
				<input type="text" name="order_no" id="order_no" style="width:95%" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td class="c_title_1">프로젝트명</td>
			<td class="c_data_1" colspan="1">
				<input type="text" name="pr_wbs_name" id="pr_wbs_name" style="width:95%" maxlength="20" class="inputsubmit">
			</td>	
			<td class="c_title_1">접수여부</td>
			<td class="c_data_1">
				<select id="" name="sh_confirm_yn" id="sh_confirm_yn" class="c_data_1">
					<option value="">전체</option>
					<option value="Y">접수</option>
					<option value="N">미접수</option>
				</select>
			</td>	
		</tr>
		<tr>		
			<td class="c_title_1">품목명</td>
			<td class="c_data_1" colspan="1">
				<input type="text" name="item_nm" id="item_nm" style="width:95%" maxlength="20" class="inputsubmit">
			</td>
			<td class="c_title_1">구매담당자</td>
		    <td class="c_data_1">
		        <input type="text" name="purchaser_id" id="purchaser_id" size="20" value="<%=purchaser_id%>" class="inputsubmit" >
		        <a href="javascript:PopupManager('PURCHASER_ID')"><img src="/images/button/query.gif" align="absmiddle" border="0" id=h13></a>
		        <input type="text" name="purchaser_name" id="purchaser_name" size="20" class="input_data2" value="<%=purchaser_nm%>" readOnly>
	        </td>		
		</tr>		
		
		<tr>
		    <td class="c_title_1"> 대분류</td>
		    <td class="c_data_1">
		        <select name="MATERIAL_TYPE" id="MATERIAL_TYPE" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
		        <option value="">전체</option>
		        <%
		        String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
		        out.println(listbox1);
		        %>
		        </select>
		    </td>
		    <td class="c_title_1"> 중분류</td>
		    <td class="c_data_1">
		        <select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
		        <option value=''>전체</option>
		        </select>
		    </td>
		</tr>
		<tr>
		    <td class="c_title_1">소분류</td>
		    <td class="c_data_1">
		        <select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
		        <option value=''>전체</option>
		        </select>
		    </td>
		    <td class="c_title_1">세분류</td>
		    <td class="c_data_1">
		        <select name="MATERIAL_CLASS2" id="MATERIAL_CLASS2" class="inputsubmit">
		        <option value=''>전체</option>
		        </select>
		    </td>
		</tr>
	</table>
 
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
    		<td width="10%" style="font-weight:bold;font-size:12px;color:#555555;"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> &nbsp;담당자지정</td>
			<td width="25%" > <b>
	        	<input type="text" name="Transfer_person_id" id="Transfer_person_id" size="10" maxlength="5" class="inputsubmit" readOnly >/
	        	<input type="text" name="Transfer_person_name" id="Transfer_person_name" size="15" class="inputsubmit" readOnly >
	        		<a href="javascript:SP0352_Popup();"><img src="/images/button/query.gif" align="absmiddle" border="0" id=h13></a>       </b>
	        	<input type="hidden" name="Transfer_id" id="Transfer_id" >
	        	<input type="hidden" name="Transfer_name" id="Transfer_name" ></td>
			<TD>
				<script language="javascript">
					btn("javascript:doTransfer()" ,13,"지 정")     
				</script>
			</TD>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:doQuery()", "조 회")    </script></TD>
	    	  			<TD><script language="javascript">btn("javascript:doConfirm()", "접 수")    </script></TD>
	    	  			<!--  <TD><script language="javascript">btn("javascript:doModify()",43,"수 정")     </script></TD> -->
						<TD><script language="javascript">btn("javascript:doReturn('D')", "반 려")     </script></TD>
						<TD><script language="javascript">btn("javascript:doRequest()", "견적요청")   </script></TD>
						<TD><script language="javascript">btn("javascript:doBidding()", "입찰요청")   </script></TD>
						<TD><script language="javascript">btn("javascript:doReverseAuction()", "역경매")   </script></TD>
<!-- 						<TD><script language="javascript">btn("javascript:direct_po()",32,"직발주")   </script></TD> -->
						<TD><script language="javascript">btn("javascript:send_po()", "종가발주")     </script></TD>
						<%--
						
						
				        <TD><script language="javascript">btn("javascript:doTransfer()" ,18,"지 정")     </script></TD>
						--%>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table> 

	<table width="99%" border="0" cellspacing="0" cellpadding="0">
		<input type="hidden" name="mtou_flag" value="N" readOnly>
	</table>
	<table width="99%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		</tr>
	</table>
	<iframe name="xWork" width="0" height="0" border="0"></iframe>
	<iframe name="childFrame" src="" width="0%" height="0" border=0 frameborder=0> </iframe>
	<iframe name="getDescframe" src="" width="0%" height="0" border=0 frameborder=0></iframe>
</form>


</s:header>
<s:grid screen_id="PR_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>


