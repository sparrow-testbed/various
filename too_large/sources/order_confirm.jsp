<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("DV_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "DV_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%
	/*확인를 위해*/
	String confirm_flag    = JSPUtil.nullToEmpty(request.getParameter("confirm_flag"));
    String inv_no          = JSPUtil.nullToEmpty(request.getParameter("po_no"));
    Object[] obj1 = {inv_no};
    SepoaOut value1 = ServiceConnector.doService(info, "DV_003", "CONNECTION", "getPoCreateInfo_2", obj1);
    SepoaFormater wf1 = new SepoaFormater(value1.result[0]);
    String dely_terms = "";
    String delay_remark = "";
    String warranty_month = "";
    String first_percent = "";
    String contract_percent = "";
    String mengel_percent = "";
    if(wf1.getRowCount() > 0) {
    	dely_terms = wf1.getValue("DELY_TERMS", 0);
    	delay_remark = wf1.getValue("DELAY_REMARK", 0);
    	warranty_month = wf1.getValue("WARRANTY_MONTH", 0);
    	first_percent = wf1.getValue("FIRST_PERCENT", 0);
    	contract_percent = wf1.getValue("CONTRACT_PERCENT", 0);
    	mengel_percent = wf1.getValue("MENGEL_PERCENT", 0);
    }
%>

<%
       String user_id        	= info.getSession("ID");
       String house_code     	= info.getSession("HOUSE_CODE");
       String company_code   	= info.getSession("COMPANY_CODE");
       String ctrl_code      	= info.getSession("CTRL_CODE");
       String user_name	 	= info.getSession("NAME_LOC");
       String toDaysSo       	= SepoaDate.getShortDateString();
       String toDays         	= SepoaDate.getFormatString("yyyy/MM/dd");
	String VENDOR_CODE		= "";
	String VENDOR_NAME		= "";
	String SUBJECT			= "";
	String CTRL_CODE		= "";
	String PAY_TERMS		= "";
	String PR_TYPE			= "";
	String PR_TYPE_CODE		= "";
	String ORDER_NO			= "";
	String CUR				= "";
	String EXEC_AMT_KRW		= "";
	String TAKE_USER_NAME	= "";
	String CTR_DATE			= "";
	String TAKE_TEL			= "";
	String REMARK			= "";
	String EXEC_NO			= "";
	String CTR_NO			= "";
	String PO_CREATE_DATE	= "";
	String ADD_USER_NAME	= "";
	String VENDOR_CP_NAME	= "";
	String VENDOR_MOBILE_NO = "";
	String VENDOR_EMAIL		= "";
	String PO_TYPE			= "";
	String CONT_SEQ			= "";
	String CONTRACT_FROM_DATE	= "";
	String CONTRACT_TO_DATE		= "";
	String CONTRACT_NO			= "";
	String ATTACH_NO			= "";
	String FILE_NAME ="";

       String po_no          		= JSPUtil.nullToEmpty(request.getParameter("po_no"));
	if ("".equals(po_no)) po_no = JSPUtil.nullToEmpty(request.getParameter("doc_no"));
       Object[] obj = {po_no};
       SepoaOut value = ServiceConnector.doService(info, "DV_003", "CONNECTION", "getPoDetailHeader", obj);

       SepoaFormater wf = new SepoaFormater(value.result[0]);
	if(wf.getRowCount() > 0) {
		VENDOR_CODE		    = wf.getValue("VENDOR_CODE"	 		, 0);
		VENDOR_NAME		    = wf.getValue("VENDOR_NAME"	 		, 0);
		SUBJECT			    = wf.getValue("SUBJECT"	 			, 0);
		CTRL_CODE		    = wf.getValue("CTRL_CODE"    		, 0);
		PAY_TERMS		    = wf.getValue("PAY_TERMS_DESC" 		, 0);
		PR_TYPE			    = wf.getValue("PR_TYPE_DESC"		, 0);
		ORDER_NO			= wf.getValue("ORDER_NO"	 		, 0);
		CUR				    = wf.getValue("CUR"	 				, 0);
		EXEC_AMT_KRW		= wf.getValue("PO_TTL_AMT"			, 0);
		TAKE_USER_NAME	    = wf.getValue("TAKE_USER_NAME"  	, 0);
		CTR_DATE			= wf.getValue("CTR_DATE"	 		, 0);
		TAKE_TEL			= wf.getValue("TAKE_TEL"	 		, 0);
		REMARK			    = wf.getValue("REMARK"    			, 0);
		EXEC_NO			    = wf.getValue("EXEC_NO"	 			, 0);
		CTR_NO			    = wf.getValue("CTR_NO"    			, 0);
		PO_CREATE_DATE		= wf.getValue("PO_CREATE_DATE"  	, 0);
		ADD_USER_NAME		= wf.getValue("USER_NAME"			, 0);
		VENDOR_CP_NAME		= wf.getValue("VENDOR_CP_NAME"		, 0);
		VENDOR_MOBILE_NO    = wf.getValue("VENDOR_MOBILE_NO"	, 0);
		VENDOR_EMAIL		= wf.getValue("VENDOR_EMAIL"	, 0);
		CONTRACT_FROM_DATE	= wf.getValue("CONTRACT_FROM_DATE"	, 0);
		CONTRACT_TO_DATE    = wf.getValue("CONTRACT_TO_DATE"	, 0);
		PR_TYPE_CODE		= wf.getValue("PR_TYPE"				, 0);
		CONTRACT_NO			= wf.getValue("CONTRACT_NO"			, 0);
		ATTACH_NO    		= wf.getValue("ATTACH_NO"			, 0);
		PO_TYPE				= wf.getValue("PO_TYPE"				, 0);
		CONT_SEQ			= wf.getValue("CONT_SEQ"			, 0);
		FILE_NAME		= wf.getValue("SRC_FILE_NAME", 0);
		if ( PO_TYPE.equals("M") || PO_TYPE.equals("C") ) {
			dely_terms = wf.getValue("DELY_TERMS_DESC" 		, 0);
		}
	}

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
%>
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

<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>

<script language="javascript">

var G_CUR_ROW = -1;

var mode;
var G_HOUSE_CODE   = "<%=house_code%>";
var G_COMPANY_CODE = "<%=company_code%>";
var pr_type = "<%=PR_TYPE_CODE%>";
var IDX_SEL					;
var IDX_ITEM_NO				;
var IDX_DESCRIPTION_LOC		;
var IDX_RD_DATE				;
var IDX_UNIT_MEASURE		;
var IDX_PO_QTY			    ;
var IDX_UNIT_PRICE		    ;
var IDX_ITEM_AMT			;
var IDX_PR_UNIT_PRICE	    ;
var IDX_PR_AMT			    ;
var IDX_DOWN_AMT			;
var IDX_PR_NO			    ;
var IDX_CUST_CODE		    ;
var IDX_CUR					;
var IDX_EXCHANGE_RATE	    ;
var IDX_EXEC_AMT_KRW		;
var IDX_DELY_TO_LOCATION	;
var IDX_VENDOR_RD_DATE   	;

	function init() {
		document.forms[0].EXEC_AMT_KRW.value = add_comma(document.forms[0].EXEC_AMT_KRW.value,0);
	setGridDraw();
	setHeader();
	}

	function setHeader() {
	    var itemsize 	= 100;
		var servicesize = 0;
		var item_no			 = "품목코드";
		var description_loc  = "품목명";
		var po_qty           = "수량";
		var dely_to_location = "납품장소";
		if(pr_type=="S"){
			item_no			= "인력코드";
			description_loc = "성명";
			po_qty          = "공수";
			dely_to_location= "근무장소";
			itemsize 	= 0;
			servicesize = 120;
		}



/* 
		GridObj.SetColCellSortEnable("DESCRIPTION_LOC"	,false);
		GridObj.SetColCellSortEnable("UNIT_MEASURE"		,false);
		GridObj.SetColCellSortEnable("ITEM_AMT"			,false);
		GridObj.SetColCellSortEnable("PR_AMT"				,false);
		GridObj.SetColCellSortEnable("DELY_TO_LOCATION"	,false); */
	/* 	GridObj.SetNumberFormat("PO_QTY"			,G_format_qty);
		GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
		GridObj.SetNumberFormat("PR_UNIT_PRICE"	,G_format_unit);
		GridObj.SetNumberFormat("ITEM_AMT"		,G_format_amt);
		GridObj.SetNumberFormat("PR_AMT"			,G_format_amt);
		GridObj.SetNumberFormat("EXEC_AMT_KRW"	,G_format_amt);
		GridObj.SetNumberFormat("DOWN_AMT"		,G_format_amt);
		GridObj.SetDateFormat("RD_DATE"			,"yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_FROM_DATE"	,"yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_TO_DATE"		,"yyyy/MM/dd"); */


	    IDX_SEL					= GridObj.GetColHDIndex("SEL"				);
	    IDX_ITEM_NO				= GridObj.GetColHDIndex("ITEM_NO"			);
	    IDX_DESCRIPTION_LOC		= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
	    IDX_RD_DATE				= GridObj.GetColHDIndex("RD_DATE"			);
	    IDX_UNIT_MEASURE		= GridObj.GetColHDIndex("UNIT_MEASURE"	);
	    IDX_PO_QTY			    = GridObj.GetColHDIndex("PO_QTY"			);
	    IDX_UNIT_PRICE		    = GridObj.GetColHDIndex("UNIT_PRICE"		);
	    IDX_ITEM_AMT			= GridObj.GetColHDIndex("ITEM_AMT"		);
	    IDX_PR_UNIT_PRICE	    = GridObj.GetColHDIndex("PR_UNIT_PRICE"	);
	    IDX_PR_AMT			    = GridObj.GetColHDIndex("PR_AMT"			);
	    IDX_DOWN_AMT			= GridObj.GetColHDIndex("DOWN_AMT"		);
	    IDX_PR_NO			    = GridObj.GetColHDIndex("PR_NO"			);
	    IDX_CUST_CODE		    = GridObj.GetColHDIndex("CUST_CODE"		);
	    IDX_CUR					= GridObj.GetColHDIndex("CUR"				);
	    IDX_EXCHANGE_RATE	    = GridObj.GetColHDIndex("EXCHANGE_RATE"	);
	    IDX_EXEC_AMT_KRW		= GridObj.GetColHDIndex("EXEC_AMT_KRW"	);
	    IDX_DELY_TO_LOCATION	= GridObj.GetColHDIndex("DELY_TO_LOCATION");
	    IDX_VENDOR_RD_DATE   	= GridObj.GetColHDIndex("VENDOR_RD_DATE");
	    
	    doQuery();
	    
	}
	
	function doQuery()
	{
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getPoCreateInfo&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.order_confirm";
		
		
		
		GridObj.post(url, param);
		GridObj.clearAll(false);	
	}

   	var summaryCnt = 0;
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
        if(msg1 == "doData") { // 전송/저장시 Row삭제
// 			alert(GD_GetParam(GridObj,"0"));
			//if(GridObj.GetStatus()==1){
				opener.doSelect();
				window.close();
			//}

		} else if (msg1 == "t_imagetext") {
			G_CUR_ROW = msg2;

			if(msg3 == IDX_ITEM_NO){
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_DESCRIPTION_LOC){
				var item_no = GridObj.GetCellValue("ITEM_NO", msg2);
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}
		} else if (msg1 == "t_insert") {
            if(msg3 == IDX_RD_DATE) {
				se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, IDX_RD_DATE);

				if(se_rd_date <= eval("<%=SepoaDate.getShortDateString()%>") ) {
					alert("납기요청일은 현재날짜 이후여야 합니다."  );
					GD_SetCellValueIndex(GridObj,msg2, IDX_RD_DATE, msg4);
				}
            }
		} else if(msg1 == "t_header") {
			if(msg3 == IDX_RD_DATE) {
				copyCell(WiseTable, IDX_RD_DATE, "t_date");
			}
		} else if(msg1 == "doQuery") {
        	if(msg3 == IDX_PO_QTY) {
        		calculate_po_qty(GridObj, msg2);
				calculate_po_amt(GridObj, msg2);
			}
			/* if(summaryCnt == 0) {
				GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PO_QTY,ITEM_AMT');
                GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
                summaryCnt++;
			} */
		}
	}

	/**
	 * 품목별 발주 수량을 계산한다.
     */
	function calculate_po_qty(wise, row)
  	{
  		// 소숫점 두자리까지 계산
    	GD_SetCellValueIndex(GridObj,row, IDX_PO_QTY, RoundEx(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY), 3));
  	}
	
	/**
	 * 품목별 발주 금액을 계산한다.
     */
	function calculate_po_amt(wise, row)
  	{
  		// 소숫점 두자리까지 계산
    	var ITEM_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY))*getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3);
    	GD_SetCellValueIndex(GridObj,row, IDX_ITEM_AMT, setAmt(ITEM_AMT));
  	}

	function approvalSign(){
		<!-- alert("approvalSign---------------start"); -->
	    childframe.location.href='/kr/admin/basic/approval/approval.jsp?house_code=<%=info.getSession("HOUSE_CODE")%>&company_code=<%=info.getSession("COMPANY_CODE")%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=POD&fnc_name=getApproval';
	}

	var saveRock  = false;
	var divStatus = "";

	function approval(set){

	    var wise = GridObj;


	    divStatus = set;
	    var f0 = document.forms[0];

	    f0.VENDOR_CODE.value = f0.VENDOR_CODE.value.toUpperCase();
	    f0.PO_NO.value       = f0.PO_NO.value.toUpperCase();

	    if(saveRock==true){
	        alert("해당하는 품번에 대해 이미 발주가 생성되었습니다.");
	        return;
	    }

	    var checked_count = 0;
	    var rowcount = GridObj.GetRowCount();
	    var qtyChk = true;
	    var rdChk = true;
	    var unitPriceChk = true;

	    var tmp_ctrl_code = "";

	    for(row=0; row<rowcount; row++) {
	        if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {

	            checked_count ++;

	            if(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY)=="")
	                qtyChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_RD_DATE)=="")
	                rdChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)=="")
	                unitPriceChk = false;
	        }
	    }

	    if(checked_count == 0){
	        alert(G_MSS1_SELECT);
	        return;
	    }

	    if(!qtyChk){
	        alert("발주 수량은 필수입력사항입니다.");
	        return;
	    }
	    if(!unitPriceChk){
	        alert("단가는 필수입력사항입니다.");
	        return;
	    }

	    if(!rdChk){
	        alert("납기요청일은 필수입력사항입니다.");
	        return;
	    }


	    var setCnt = 0;
	    for(var c=0; c<rowcount; c++)
	        if("true" == GD_GetCellValueIndex(GridObj,c, IDX_SEL))
	            setCnt ++;

	    if(!confirm("수정하시겠습니까?.")){
	        return;
	    }

	    var VENDOR_CODE =  f0.VENDOR_CODE.value;
	    var PO_NO       =  f0.PO_NO.value;
	    var CUR         =  f0.CUR.value;
	    var TTL_AMT     =  del_comma(f0.EXEC_AMT_KRW.value);
	    if(PO_NO=="") PO_NO="xp";
		GridObj.SetParam("VENDOR_CODE"	,VENDOR_CODE			);
	    GridObj.SetParam("PO_NO"          ,PO_NO					);
	    GridObj.SetParam("CUR"            ,CUR					);
	    GridObj.SetParam("TTL_AMT"        ,TTL_AMT				);
	    GridObj.SetParam("REMARK"         ,f0.REMARK.value		);
	    GridObj.SetParam("COMPANY_CODE"   ,"<%=company_code%>"	);
	    GridObj.SetParam("DELY_TERMS"     ,f0.dely_terms.value	);
	    GridObj.SetParam("PAY_TERMS"      ,f0.pay_terms.value		);
   	    GridObj.SetParam("ACCOUNT_TYPE"   ," "					);
   	    GridObj.SetParam("ORDER_NO"   	,f0.ORDER_NO.value		);
		GridObj.SetParam("CTR_NO"			,f0.CTR_NO.value		);
		GridObj.SetParam("CTR_DATE"		,f0.CTR_DATE.value		);
		GridObj.SetParam("PR_TYPE"		,f0.PR_TYPE.value		);
		GridObj.SetParam("ctrl_code"		,f0.ctrl_code.value		);
		GridObj.SetParam("SUBJECT"		,f0.SUBJECT.value		);
		GridObj.SetParam("ctrl_person_id"	,f0.ctrl_person_id.value);

	    if(set=="SAVE")
	        getApproval("SAVE");
	    else
	        approvalSign();
	}

	function getApproval(str){
	    if(str == '') return;

	    var sign_flag = "";
	    saveRock = true;

	    if(str=="SAVE")
	        sign_flag = "T";   // 작성중
	    else
	        sign_flag = "P";   // 결재중(결재상신)

	    GridObj.SetParam("SIGN_FLAG",sign_flag);
	    GridObj.SetParam("APPROVAL",str);
		GridObj.SetParam("CTRL_CODE","<%=ctrl_code%>");

	    var servletUrl = "/servlets/order.bpo.po1_bd_upd1";

	    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}

	function clearRow() {
        GridObj.RemoveAllData();
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

	form1.ctrl_code.value = ls_ctrl_code;
	form1.ctrl_name.value = ls_ctrl_name;
	form1.ctrl_person_id.value = ls_ctrl_person_id;
	form1.ctrl_person_name.value = ls_ctrl_person_name;

}
function printOZ(){
    window.open("/oz/oz_po3_pp_dis1.jsp?PO_NO=<%=po_no%>&house_code=<%=house_code%>","po_rd_dis","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
}

function rMateFileAttach(att_mode, view_type, file_type, att_no) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "P") {
		var protocol = location.protocol;
		var host     = location.host;
		var addr     = protocol +"//" +host;

		var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

		f.method = "POST";
		f.target = "fileattach";
		f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
		f.submit();
	} else if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

function goIReport(){
	<%--
	var cur = "<%=CUR%>";

	/*
	if(confirm("발주 내자는 YES 외자는 NO")){
		getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<%=house_code%>&so_no=<%=po_no%>&type=D";
	}else{
		getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<%=house_code%>&so_no=<%=po_no%>&type=O";
	}
	*/

	if(cur == "KRW"){
		getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<%=house_code%>&so_no=<%=po_no%>&type=D";
	}else{
		getDescframe.location.href = "/report/iReportPrint.jsp?flag=PO&house_code=<%=house_code%>&so_no=<%=po_no%>&type=O";
	}
	--%>
	//window.open("/kr/order/bpo/po3_pp_dis2.jsp"+"?exec_no=<//%=EXEC_NO%>","newWin","width="+screen.availWidth+",height=690,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
	window.open("/s_kr/ordering/po/po_bd_print.jsp"+"?po_no=<%=po_no%>","newWin","width=1000,height=650,resizable=yes,scrollbars=yes,status=yes,top=0,left=0");
}

function doConfirm() {
	for(var i = 1; i <= GridObj.getRowsNum(); i++)
	{
		GridObj.cells(i, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
	}
	var f0 = document.forms[0];
	var grid_array = getGridChangedRows(GridObj, "SEL");
	
	//select된 Row만 돌려서 납기가능일 필수체크를 한다.
	for(var j = 0; j < grid_array.length; j++) {
		var vendor_rd_date = GridObj.cells(grid_array[j], GridObj.getColIndexById("VENDOR_RD_DATE")).getValue();
		if(vendor_rd_date == "") {
			alert("납기가능일은 필수입니다.");
			return;
		}
	}
	
	if(!confirm( "선택하신 수주를  확인하시겠습니까?")){
		return;
	}
	
<%-- 	mode = "setPoConfirm_2";
    GridObj.SetParam("mode", "setPoConfirm_2");
    GridObj.SetParam("po_no", "<%=inv_no%>");
    GridObj.SetParam("confirm_sign", "Y"); // 확인여부(확인)
    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
    GridObj.SendData('<%=getWiseServletPath("supply.ordering.po.po3_bd_lis1")%>', "ALL", "ALL"); --%>
    
    var confirm_sign = "Y";
    
    f0.CONFIRM_SIGN.value=confirm_sign;
    
    var cols_ids = "<%=grid_col_id%>";
 	var params = "mode=setPoConfirm";
    params += "&cols_ids="+cols_ids;
 	params += dataOutput();
 	
    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.order_confirm" , params);
   
    sendTransactionGridPost( GridObj, myDataProcessor, "SEL", grid_array );
}

function doReject(reject_rsn) {
	if(!confirm( "선택하신 수주를 반송하시겠습니까?")){
		return;
	}
	for(var i = 1; i <= GridObj.getRowsNum(); i++)
	{
		GridObj.cells(i, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
	}
	var f0 = document.forms[0];
	var grid_array = getGridChangedRows(GridObj, "SEL");
	<%-- mode = "setPoReject";
   	GridObj.SetParam("mode", "setPoReject");
    GridObj.SetParam("po_no", "<%=inv_no%>");
    GridObj.SetParam("confirm_sign", "N"); // 확인여부(반송)
    GridObj.SetParam("reject_rsn", reject_rsn); // 반송사유
    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
    GridObj.SendData('<%=getWiseServletPath("supply.ordering.po.po3_bd_lis1")%>', "ALL", "ALL"); --%>
	
 	var confirm_sign = "N";
    
 	var reject_rsn = "";
 	
    f0.CONFIRM_SIGN.value=confirm_sign;
    f0.REJECT_RSN.value=reject_rsn;
    
    var cols_ids = "<%=grid_col_id%>";
 	var params = "mode=setPoReject";
    params += "&cols_ids="+cols_ids;
 	params += dataOutput();
 	
    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.order_confirm" , params);
   
    sendTransactionGridPost( GridObj, myDataProcessor, "SEL", grid_array );
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

function getSumData(){
	var sum_PO_QTY = 0;
	var sum_UNIT_PRICE = 0;
	var sum_ITEM_AMT = 0;
	for(var i = 1 ; i<=GridObj.getRowsNum() ; i++){
		sum_PO_QTY += Number(GridObj.cells(i,GridObj.getColIndexById("PO_QTY")).getValue());
		sum_UNIT_PRICE += Number(GridObj.cells(i,GridObj.getColIndexById("UNIT_PRICE")).getValue());
		sum_ITEM_AMT += Number(GridObj.cells(i,GridObj.getColIndexById("ITEM_AMT")).getValue());
	}
	var nextRowId = GridObj.getRowsNum()+1;
	GridObj.addRow(nextRowId, "", GridObj.getRowIndex(nextRowId));
	GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_NO")).setValue("합계");
	GridObj.cells(nextRowId,GridObj.getColIndexById("PO_QTY")).setValue(sum_PO_QTY);
	GridObj.cells(nextRowId,GridObj.getColIndexById("UNIT_PRICE")).setValue(sum_UNIT_PRICE);
	GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_AMT")).setValue(sum_ITEM_AMT);
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    
    if(GridObj.GetRowCount() > 0){
    	$("#dely_address_loc").html(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DELY_TO_ADDRESS")).getValue());
    }
    
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    getSumData();
    return true;
}
function setAttach(attach_key_value, arrAttrach, rowId, attach_count){
	var attach_arr = arrAttrach + "";
	$("#FILE_NAME").val(attach_arr.split(",")[4]);
	$("#ATTACH_NO").val(attach_key_value);
	
	var f = document.forms[0];

	f.method = "POST";
	f.target = "attachFrm";
	f.action = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI";
	f.submit();
}

/*
첫번째 행의 납기가능일 모든 행에 일괄적용(합계 행 제외)
*/
function setDeliveryData() {
	
	var VENDOR_RD_DATE = '';
	
	var iRowCount = GridObj.GetRowCount();
	
	for(var i = 0; i < (iRowCount - 1); i++) {//합계 행은 마지막에 위치하므로 반복을 1번 덜 돌려야한다
		if(i == 0) {
			VENDOR_RD_DATE = GD_GetCellValueIndex(GridObj, i, IDX_VENDOR_RD_DATE);
			if( isEmpty(VENDOR_RD_DATE) ){
				alert('첫번째 행의 납기가능일을 입력하십시오.');
				return;
			}
		} else {
			if( isEmpty(VENDOR_RD_DATE) ){
				alert('첫번째 행의 납기가능일을 입력하십시오.');
				return;
			} else {
				GD_SetCellValueIndex(GridObj, i, IDX_VENDOR_RD_DATE, VENDOR_RD_DATE);
			}
		}
	}
	
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<!--내용시작-->
<form id="form1" name="form1" method="post">
	<input type="hidden" name="h_po_no">
	<input type="hidden" name="set_company_code">
	<input type="hidden" name="SHIPPER_TYPE" value = "D">

	<input type="hidden" name="attach_gubun" value="body">
	<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>">
	<input type="hidden" name="attach_count" value="">
	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="CONFIRM_SIGN" id="CONFIRM_SIGN" value="">
	<input type="hidden" name="REJECT_RSN" id="REJECT_RSN" value="">
	

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
		&nbsp;수주화면 상세조회
	</td>
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
      	<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주번호</td>
      	<td width="30%" class="data_td">
      		<input type="text" name="PO_NO" id="po_no" style="width:95%" value="<%=po_no%>" readOnly class="input_data2" style="border:0">
      	</td>
      	<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주명</td>
      	<td width="30%" class="data_td">
      		<input type="text" name="SUBJECT" style="width:95%" value="<%=SUBJECT%>" readOnly class="input_data2" style="border:0">
      	</td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주업체</td>
      	<td class="data_td">
      		<input type="text" name="VENDOR_NAME" style="width:95%" value="<%=VENDOR_NAME%>" readOnly class="input_data2" style="border:0">
      	</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주일자</td>
      	<td class="data_td">
      		<input type="text" name="PO_CREATE_DATE" style="width:95%" value="<%=SepoaString.getDateSlashFormat(PO_CREATE_DATE)%>" readOnly class="input_data2" style="border:0">
      	</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체담당자</td>
      	<td class="data_td">
      		담당자 : <%=VENDOR_CP_NAME%><br>
        	<%-- 헨드폰 : <%=getFormatPhoneNo(VENDOR_MOBILE_NO)%><br> --%>
        	이메일 : <%=VENDOR_EMAIL%>
      	</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주금액 (VAT 포함)</td>
      	<td class="data_td">
      		<input type="text" name="EXEC_AMT_KRW" style="width:95%" value="<%=EXEC_AMT_KRW%>" readOnly class="input_data2" style="border:0">
      	</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급조건</td>
      <td class="data_td"><%=PAY_TERMS%></td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 인도조건</td>
      <td class="data_td"><%=dely_terms%></td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 인수자</td>
      	<td class="data_td">
      		<input type="text" name="TAKE_USER_NAME" style="width:95%" value="<%=TAKE_USER_NAME%>" class="input_data2"  readOnly style="border:0">
      	</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 인수자연락처</td>
      	<td class="data_td">
      		<%=TAKE_TEL%>
      	</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지체상금율</td>
      	<td class="data_td" ><%=delay_remark  %></td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 영업점주소</td>
      	<td class="data_td" id="dely_address_loc"></td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <tr>
      	<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 하자이행 보증기간</td>
      	<td width="30%" class="data_td">검수일로부터 ( <%=warranty_month%> )개월</td>
      	<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 계약일반사항</td>
      	<td width="30%" class="data_td">
			선급금보증 <%=first_percent%>%<br>
			계약이행보증 <%=contract_percent%>%<br>
			하자이행보증 <%=mengel_percent%>%<br>
      	</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비고</td>
    	<td class="data_td" colspan="3">
			<textarea name="REMARK" style="width:97%" rows="5" readOnly style="border:0"><%=REMARK%></textarea>
    	</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
		<td class="data_td" colspan="3" height="150">
			<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 115px; border: 0px;" frameborder="0" ></iframe>
		</td>
	</tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
		<td class="data_td" colspan="3" height="150">
			<table>
				<tr>
					<td>
						<input type="text" name="FILE_NAME" id="FILE_NAME" >
						<input type="hidden" name="ATTACH_NO" id="ATTACH_NO" value=<%=ATTACH_NO%> ><!--  attach_key     -->
					</td>
					<td>
						<script language="javascript">btn("javascript:attach_file($('#ATTACH_NO').val(),'TEMP')","첨부파일")</script>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		
  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
    		<td width="14%" height="30" align="left">
    			<script language="javascript">btn("javascript:setDeliveryData()","납기가능일 일괄적용")</script>
    		</td>
    		<td width="26%" height="30" align="left">
    			<font color="red" style="font-size:10px">&nbsp;* 납기가능일을<br>&nbsp;&nbsp;&nbsp;&nbsp;첫번째 행 기준으로 일괄적용합니다.</font>
    		</td>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
					<%if("Y".equals(confirm_flag)){ %>
    					<TD><script language="javascript">btn("javascript:doConfirm()","접수/확인")</script></TD>
    					<%if("".equals(CONT_SEQ)){//계약서가 있는 경우 반송불가 처리.	 %>
<%--     					<TD><script language="javascript">btn("javascript:doReject()","반 송")</script></TD> --%>
    					<%} %>
					<%} else {%>
    					<TD><script language="javascript">btn("javascript:goIReport()","주문장")</script></TD>
					<%}%>
					<!-- 2011.08.30 HMCHOI -->
					<!-- 발주서 전자계약인 경우 주문장은 보여주지 않는다. -->
					<%if (!po_contract_use_flag) {%>
						<!--
    					<TD><script language="javascript">btn("javascript:goIReport()",34,"주문장")</script></TD>
    					-->
					<%}%>
    					<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>
<form>
   <input type="hidden" name="po_no">
</form>

<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>
<s:grid screen_id="DV_003" grid_obj="GridObj" grid_box="gridbox" height="260"/>
<%if("Y".equals(confirm_flag)){ %>
<%if("".equals(CONT_SEQ)){//계약서가 있는 경우 반송불가 처리.	 %>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30" align="right">
			<TABLE cellpadding="0">
				<tr>
					<TD><script language="javascript">btn("javascript:doReject()","반 송")</script></TD>
				</tr>
			</TABLE>
		</td>	
	</tr>
</table>
<%} %>
<%} %>

<s:footer/>
</body>
</html>


