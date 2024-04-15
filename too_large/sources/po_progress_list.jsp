<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!-- 2011-03-08 solarb 발주진행현황-->
<%
	String house_code 		= info.getSession("HOUSE_CODE");
	String company_code 	= info.getSession("COMPANY_CODE");
	String ctrl_code 		= info.getSession("CTRL_CODE");
	String user_name	 	= info.getSession("NAME_LOC");
	String user_id 			= info.getSession("ID");
	
	String G_IMG_ICON = "/images/ico_zoom.gif";

	String z_loi_flag = JSPUtil.nullToEmpty(request.getParameter("z_loi_flag"));

	String to_date = SepoaDate.getShortDateString(); // 현재 시스템 날짜
	String from_date = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(to_date,-3)); // 오늘을 기준으로 1달전
	to_date = SepoaString.getDateSlashFormat(to_date); // 현재 시스템 날짜

	Object[] obj  = {"2", "P','D"};
// 	SepoaOut value = ServiceConnector.doService(info, "PO_003", "CONNECTION", "getCount2", obj);
// 	SepoaFormater wf = new SepoaFormater(value.result[0]);

	int bacp_cnt = 0;

// 	if(wf.getRowCount() > 0) {
// 		bacp_cnt = Integer.parseInt(wf.getValue(0, 0));
// 	}

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

<Script language="javascript">
//<!--
var G_C_INDEX    = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";
var G_C_INDEX_PJ = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:MAKER_NAME:MAKER_CODE:ITEM_GROUP:PR_QTY:CUR:UNIT_PRICE:EXCHANGE_RATE:PR_AMT:REC_VENDOR_NAME:CONTRACT_DIV:RD_DATE:DELY_TO_ADDRESS:WARRANTY:KTGRM";
var G_C_INDEX_MY = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS";
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
	if(header_name == "PO_NO") {
		var url = "../procure/po_detail.jsp";
			var param = "";
			param += "?popup_flag_header=true";
			param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
			PopupGeneral(url+param, "PoDetailPop", "", "", "1000", "600");
	}
	
	if(header_name=="EXEC_NO") {		//기안번호
		var exec_no	    = SepoaGridGetCellValueId(GridObj, rowId, "EXEC_NO");	
		var pr_type	    = SepoaGridGetCellValueId(GridObj, rowId, "PR_TYPE");	
		var req_type	= "P";	//LRTrim(GridObj.cells(rowId, IDX_REQ_TYPE).getValue());	
		var sign_status = "E";
		var edit = "N";
		var aurl  = "/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type="+req_type;
		window.open(aurl,"execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
	}
	
	if( header_name == "VENDOR_NAME" ) {//업체상세
		
	    var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
	    
	    if(vendor_code != null && vendor_code != "") {
	    
	      var url    = '/s_kr/admin/info/ven_bd_con.jsp';
	      var title  = '업체상세조회';
	      var param  = 'popup=Y';
	      param     += '&mode=irs_no';
	      param     += '&vendor_code=' + vendor_code;
	      popUpOpen01(url, title, '900', '700', param);
	    
	    }
			
	}
	
	if( header_name == "ITEM_NO" ) {//품목상세
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	}
	
	if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var prNo       = SepoaGridGetCellValueId(GridObj, rowId, "PR_NO");
		var prType     = SepoaGridGetCellValueId(GridObj, rowId, "PR_TYPE");
		var page       = null;
		
		if(prType == "I"){
			page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		}
		else{
			page = "/kr/dt/pr/pr1_bd_dis1NotI.jsp";
		}
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
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
    
//     document.form1.from_date.value = add_Slash( document.form1.from_date.value );
//     document.form1.to_date.value   = add_Slash( document.form1.to_date.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
var house_code = "<%=info.getSession("HOUSE_CODE")%>";
<%-- var	servletUrl = "<%=getSepoaServletPath("order.bpo.po4_bd_lis1")%>"; --%>

var IDX_SEL						;
var IDX_PO_NO				    ;
var IDX_ITEM_NO					;
var IDX_DESCRIPTION_LOC			;
var IDX_PO_CREATE_DATE		    ;
var IDX_CHANGE_USER_NAME_LOC	;
var IDX_RD_DATE					;
var IDX_CONT_SEQ			    ;
var IDX_CUR						;
var IDX_UNIT_PRICE			    ;
var IDX_ITEM_AMT				;
var IDX_CUSTOMER_PRICE		    ;
var IDX_S_ITEM_AMT			    ;
var IDX_DISCOUNT				;
var IDX_UNIT_MEASURE			;
var IDX_ITEM_QTY				;
var IDX_VENDOR_CODE				;
var IDX_VENDOR_NAME				;
var IDX_PR_NO				    ;
var IDX_PR_PRICE				;
var IDX_PR_AMT				    ;
var IDX_CUST_CODE			    ;
var IDX_COMPLETE_MARK		    ;
var IDX_SUBJECT		  			;
var IDX_EXEC_NO	                ;
var IDX_PR_TYPE                 ;
var IDX_QTA_NO					;
var IDX_ORDER_NO				;
var mode;
var chkrow;

function Init() {
setGridDraw();
//setHeader();
	<%--
	결함 #108
	메뉴선택시 조회조건에의해서 기본 조회되어야함.
	getQuery(); 추가
	--%>
	//getQuery();

}

function setHeader()
{

	GridObj.bHDMoving 	= false;
	GridObj.bHDSwapping 	= false;
	GridObj.nHDLineSize   = 40;
	// 2011-03-08 고객사 hidden
 // 2011-03-08 계약서번호 hidden
	//GridObj.AddHeader("QTA_NO"					,"견적서번호"		,"t_imagetext"	,20		,110	,false);
	// 2011-03-08 제안서번호 hidden

	GridObj.AddGroup("S_INFO"	,"정가"	);
	GridObj.AddGroup("INFO"	,"발주금액"	);

	GridObj.AppendHeader("S_INFO","CUSTOMER_PRICE");
	GridObj.AppendHeader("S_INFO","S_ITEM_AMT");
	GridObj.AppendHeader("INFO","UNIT_PRICE");
	GridObj.AppendHeader("INFO","ITEM_AMT");
	
	
	GridObj.SetNumberFormat("ITEM_QTY"		,G_format_qty);
	GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
	GridObj.SetNumberFormat("CUSTOMER_PRICE"	,G_format_unit);
	GridObj.SetNumberFormat("PR_PRICE"		,G_format_unit);
	GridObj.SetNumberFormat("ITEM_AMT"		,G_format_amt);
	GridObj.SetNumberFormat("S_ITEM_AMT"		,G_format_amt);
	GridObj.SetNumberFormat("PR_AMT"			,G_format_amt);
	GridObj.SetNumberFormat("ITEM_QTY"		,G_format_qty);
	GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd");
	GridObj.SetDateFormat("RD_DATE"			,"yyyy/MM/dd");

	//GridObj.SetNumberFormat("GI_QTY",       G_format_qty);
	//GridObj.SetNumberFormat("EXA_QTY",       G_format_qty);
	

	IDX_SEL						= GridObj.GetColHDIndex("SEL"						);
	IDX_PO_NO				    = GridObj.GetColHDIndex("PO_NO"					);
	IDX_ITEM_NO					= GridObj.GetColHDIndex("ITEM_NO"					);
	IDX_DESCRIPTION_LOC			= GridObj.GetColHDIndex("DESCRIPTION_LOC"			);
	IDX_PO_CREATE_DATE		    = GridObj.GetColHDIndex("PO_CREATE_DATE"			);
	IDX_CHANGE_USER_NAME_LOC	= GridObj.GetColHDIndex("CHANGE_USER_NAME_LOC"	);
	IDX_RD_DATE					= GridObj.GetColHDIndex("RD_DATE"					);
	IDX_CONT_SEQ			    = GridObj.GetColHDIndex("CONT_SEQ"				);
	IDX_CUR						= GridObj.GetColHDIndex("CUR"						);
	IDX_UNIT_PRICE			    = GridObj.GetColHDIndex("UNIT_PRICE"				);
	IDX_ITEM_AMT				= GridObj.GetColHDIndex("ITEM_AMT"				);
	IDX_CUSTOMER_PRICE		    = GridObj.GetColHDIndex("CUSTOMER_PRICE"			);
	IDX_S_ITEM_AMT			    = GridObj.GetColHDIndex("S_ITEM_AMT"				);
	IDX_DISCOUNT				= GridObj.GetColHDIndex("DISCOUNT"				);
	IDX_UNIT_MEASURE			= GridObj.GetColHDIndex("UNIT_MEASURE"			);
	IDX_ITEM_QTY				= GridObj.GetColHDIndex("ITEM_QTY"				);
	IDX_VENDOR_CODE				= GridObj.GetColHDIndex("VENDOR_CODE"				);
	IDX_VENDOR_NAME				= GridObj.GetColHDIndex("VENDOR_NAME"				);
	IDX_PR_NO				    = GridObj.GetColHDIndex("PR_NO"					);
	IDX_PR_PRICE				= GridObj.GetColHDIndex("PR_PRICE"				);
	IDX_PR_AMT				    = GridObj.GetColHDIndex("PR_AMT"					);
	IDX_CUST_CODE			    = GridObj.GetColHDIndex("CUST_CODE"				);
	IDX_COMPLETE_MARK		    = GridObj.GetColHDIndex("COMPLETE_MARK"			);
	IDX_SUBJECT		    		= GridObj.GetColHDIndex("SUBJECT"					);
	IDX_EXEC_NO					= GridObj.GetColHDIndex("EXEC_NO"	                );
	IDX_PR_TYPE					= GridObj.GetColHDIndex("PR_TYPE"	                );
	IDX_QTA_NO					= GridObj.GetColHDIndex("QTA_NO"					);
	IDX_ORDER_NO				= GridObj.GetColHDIndex("ORDER_NO"				);
	//getQuery();
}

function getQuery()
{
	//var order_no	 	= document.form1.order_no.value;
	
	var from_date = del_Slash( document.form1.from_date.value );
	var to_date   = del_Slash( document.form1.to_date.value   );
	
	if(!checkDateCommon(from_date)) {
		alert(" 발주일자(From)를 확인 하세요 ");
		document.form1.from_date.select();
		return;
	}

	if(!checkDateCommon(to_date)) {
		alert(" 발주일자(To)를 확인 하세요 ");
		document.form1.to_date.select();
		return;
	}
	var grid_col_id = "<%=grid_col_id%>";
	var param = "mode=getProgressList&grid_col_id="+grid_col_id;
	param += dataOutput();
	var url = "../servlets/sepoa.svl.procure.po_progress_list";
	GridObj.post(url, param);
	GridObj.clearAll(false);
// 	GridObj.SetParam("mode"			,mode);
// 	GridObj.SetParam("from_date"		,from_date);
// 	GridObj.SetParam("to_date"		,to_date);
// 	GridObj.SetParam("po_no"			,po_no);
// 	GridObj.SetParam("item_no"		,item_no);
// 	GridObj.SetParam("vendor_code"	,vendor_code);
// 	GridObj.SetParam("ctrl_person_id"	,ctrl_person_id);
// 	GridObj.SetParam("ctrl_code"		,ctrl_code);
// 	GridObj.SetParam("dept"			,document.form1.demand_dept.value	);
// 	GridObj.SetParam("complete_mark"	,complete_mark);
// 	GridObj.SetParam("order_no"		,"");
// 	GridObj.SetParam("ct_name"		,ct_name);
// 	GridObj.SetParam("req_dept"		,req_dept);
// 	GridObj.SetParam("maker_name"		,maker_name);
// 	GridObj.SetParam("cust_name"		,cust_name);
// 	GridObj.SetParam("po_name"		,po_name);
// 	GridObj.SetParam("wbs_name"		,wbs_name);
// 	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 	GridObj.SendData(servletUrl);
// 	GridObj.strHDClickAction="sortmulti";
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if(msg1 == "doQuery") {

	}

	if(msg1 == "doData")
	{
		var chk_status = GridObj.GetStatus();
		var message = GD_GetParam(GridObj,0);

		if(chk_status == "1")
			getQuery();
	}
	if(msg1 == "t_insert") {

	}

	if(msg1 == "t_imagetext") {
		if(msg3==IDX_PO_NO) {
			po_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
		    window.open("po3_pp_dis1.jsp"+"?po_no="+po_no,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
	    } else if(msg3==IDX_VENDOR_CODE) {
	    	if(vendor_code==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+msg4,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
	    }else if(msg3==IDX_VENDOR_NAME) {
	    	var vendor_code = GridObj.GetCellValue("VENDOR_CODE",msg2);
			if(msg4==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
	    }else if(msg3 == IDX_ITEM_NO){
			var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}else if(msg3 == IDX_DESCRIPTION_LOC){
			var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
			var item_no = GridObj.GetCellValue("ITEM_NO",msg2);
			//if(pr_type=="I")
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			//else
			//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}else if(msg3 == IDX_EXEC_NO) {
			var exec_no = GridObj.GetCellValue("EXEC_NO",msg2);
			if(exec_no != ""){
//				window.open("/kr/dt/app/app_pp_dis2.jsp?exec_no="+msg5,"execwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
				var pr_type = GridObj.GetCellValue("PR_TYPE",msg2);
                window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+exec_no+ "&pr_type=" + pr_type + "&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
			}
		}else if(msg3 == IDX_PR_NO){
			window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+msg4,"pr1_bd_dis1","left=0,top=0,width=900,height=650,resizable=yes,scrollbars=yes");
		}  else if(msg3==IDX_QTA_NO) {
			var qta_no = GridObj.GetCellValue("QTA_NO",msg2);

			if(qta_no != ""){
				window.open("/kr/dt/rfq/qta_pp_dis1.jsp?st_qta_no="+msg4,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			}
	    }  else if(msg3==IDX_ORDER_NO) {
	    	alert("준비중입니다.");
	    	return;
			window.open("/kr/dt/rfq/qta_pp_dis1.jsp?st_qta_no="+msg4,"newWin","width=1024,height=500,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
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
	}

	function getVendorCode(setMethod) { popupvendor(setMethod); }
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = desc1;
	}

	function popupvendor( fun )
	{
		window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}



function add_from_date(year,month,day,week)
{
	document.form1.from_date.value=year+month+day;
}
function add_to_date(year,month,day,week)
{
	document.form1.to_date.value=year+month+day;
}

function setClose()
{
	var rowcount    = GridObj.GetRowCount();
	var chk_count 	= 0;

	for(row=0;row < rowcount; row++)
	{
		var check_flag = GD_GetCellValueIndex(GridObj,row,IDX_SEL);
		var gr_flag 	= GD_GetCellValueIndex(GridObj,row,IDX_COMPLETE_GR_MARK);
		if(check_flag == "true")
		{
			if(gr_flag == "Y")
			{
				alert("발주완료건은 완결 불가능합니다.");
				return;
			}
			chk_count++;
		}
	}

	if(chk_count == 0)
	{
		alert(G_MSS1_SELECT);
		return;
	}

	if(confirm("발주완결처리 하시겠습니까?"))
	{
		mode = "setPoClose";

		GridObj.SetParam("mode", mode);
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}
}


function Update()
{
	var rowcount    = GridObj.GetRowCount();
	var chk_count 	= 0;

	for(row=0;row < rowcount; row++)
	{
		var check_flag 	= GD_GetCellValueIndex(GridObj,row,IDX_SEL);
		var gr_flag 	= GD_GetCellValueIndex(GridObj,row,IDX_COMPLETE_GR_MARK);
		if(check_flag == "true")
		{
			if(gr_flag == "Y"){
				alert("발주완료건은 수정 불가능합니다.");
				return;
			}
			chk_count++;

		}


	}

	if(chk_count == 0)
	{
		alert(G_MSS1_SELECT);
		return;
	}

	if(confirm("수정 하시겠습니까?"))
	{
		mode = "setPoUpdate_DO";
		GridObj.SetParam("mode", mode);
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}
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
	var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0371&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0371_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {

	form1.ctrl_person_id.value = ls_ctrl_person_id;
	form1.ctrl_person_name.value = ls_ctrl_person_name;

}
function getOrg(code, name) {
	document.forms[0].org.value = code;
	document.forms[0].text_org.value = name;
}

function SP1001_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP1001&function=SP1001_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=프로젝트&desc=프로젝트명";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function SP1001_Popup_getCode(z_code1, project_name) {
	document.form1.z_code1.value = z_code1;
	document.form1.project_name.value = project_name;
}
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "DEMAND_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "ADD_USER_ID")
	{
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "ITEM_NO")
	{
		setCatalogIndex("MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP");
		url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ;
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}
	else if(part == "CTRL_PERSON")
	{
		window.open("/common/CO_008.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "REQ_DEPT")
	{
		window.open("/common/CO_009.jsp?callback=getReq_dept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	//구매담당직무ㅁ
	if(part == "CTRL_CODE")
	{
		PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
	}
}

function getCtrlUser(code, text) {
	document.forms[0].ctrl_person_id.value = code;
	document.forms[0].ctrl_person_name.value = text;
}

function getReq_dept(code,text){
	document.forms[0].req_dept.value      = code;
	document.forms[0].req_dept_name.value = text;
}

//구매담당직무
function getCtrlManager(code, text)
{
	document.form1.ctrl_code.value = code;
	document.form1.ctrl_name.value = text;
}

function getDemand(code, text)
{
	document.forms[0].demand_dept_name.value = text;
	document.forms[0].demand_dept.value = code;
}

function getAddUser(code, text)
{
	document.forms[0].add_user_name.value = text;
	document.forms[0].add_user_id.value = code;
}
function getCtrlPerson(code, text ,code1, text1)
{
	document.forms[0].ctrl_person_name.value = text1;
	document.forms[0].ctrl_person_id.value = code1;
}
//function setCatalog(item_code){
function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	document.forms[0].item_no.value = itemNo;
	document.forms[0].DESCRIPTION_LOC.value = descriptionLoc;
}
function getReqDept(code, text)
{
	document.forms[0].req_dept_name.value = text;
	document.forms[0].req_dept.value = code;
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
	var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {

	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].ctrl_name.value = ls_ctrl_name;
	document.forms[0].ctrl_person_id.value = ls_ctrl_person_id;
	document.forms[0].ctrl_person_name.value = ls_ctrl_person_name;
}


//지우기
function doRemove( type ){
    if( type == "ctrl_person_id" ) {
    	document.forms[0].ctrl_person_id.value = "";
        document.forms[0].ctrl_person_name.value = "";
    }  
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }
    if( type == "item_no" ) {
    	document.forms[0].item_no.value = "";
        document.forms[0].DESCRIPTION_LOC.value = "";
    }
    if( type == "req_dept" ) {
    	document.forms[0].req_dept.value = "";
        document.forms[0].req_dept_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        getQuery();
    }
}

//-->
</Script>
</head>
<body onload="Init();getQuery();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" >
		<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">	
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
											<s:calendar id_from="from_date" default_from="<%=from_date %>" default_to="<%=to_date %>" id_to="to_date" format="%Y/%m/%d" />
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주번호</td>
										<td width="35%" class="data_td">
											<input type="text" name="po_no" id="po_no" style="width:95%; ime-mode:inactive;" maxlength="20" class="inputsubmit" onkeydown='entKeyDown()'  >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주명</td>
										<td width="35%" class="data_td">
											<input type="text" name="po_name" id="po_name" style="width:95%" class="inputsubmit" maxlength="100"  onkeydown='entKeyDown()' >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기안명</td>
										<td width="35%" class="data_td">
											<input type="text" name="ct_name" id="ct_name" style="width:95%" class="inputsubmit" maxlength="100"  onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 고객사</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="cust_name" id="cust_name" style="width:95%" class="inputsubmit" maxlength="40"  onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 프로젝트명</td>
										<td class="c_data_1" width="35%">
											<input type="text" name="wbs_name" id="wbs_name" style="width:95%" class="inputsubmit" maxlength="100"  onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
										<td width="35%" class="data_td">
											<b>
												<input type="text" name="ctrl_person_id" id="ctrl_person_id" style="ime-mode:inactive"  size="15" class="inputsubmit" value="<%=user_id%>"  onkeydown='entKeyDown()' >
												<a href="javascript:PopupManager('CTRL_PERSON');">
													<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
												</a>
												<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
												<input type="text" name="ctrl_person_name" id="ctrl_person_name" size="20" class="input_data2" readOnly  value="<%=info.getSession("NAME_LOC")%>"  onkeydown='entKeyDown()' >
											</b>
											<input type="hidden" name="ctrl_code" id="ctrl_code" size="5" maxlength="5" class="inputsubmit" readOnly value="">
											<input type="hidden" name="ctrl_name" id="ctrl_name" size="25" class="input_data2" readOnly >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드</td>
										<td width="35%" class="data_td">
											<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive"  size="15" class="inputsubmit" maxlength="10"  onkeydown='entKeyDown()' >
											<a href="javascript:getVendorCode('setVendorCode')">
												<img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="vendor_code_name" id="vendor_code_name" size="20" class="input_data2" onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</td>
										<td width="35%" class="data_td">
											<input type="text" name="item_no" id="item_no" style="ime-mode:inactive"  size="15" class="inputsubmit"  onkeydown='entKeyDown()' >
											<a href="javascript:PopupManager('ITEM_NO');">
												<img src="/images/ico_zoom.gif" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('item_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="DESCRIPTION_LOC" id="DESCRIPTION_LOC" size="20" class="input_data2" readOnly  onkeydown='entKeyDown()' >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
										<td width="35%" class="data_td">
											<input type="text" name="maker_name" id="maker_name" style="width:95%" class="inputsubmit" maxlength="24"  onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 담당부서      </td>
										<td class="c_data_1" width="35%">
											<input type="text" name="demand_dept" id="demand_dept" size="15" maxlength="10" class="inputsubmit" value=''  onkeydown='entKeyDown()' >
											<a href="javascript:PopupManager('DEMAND_DEPT');">
												<img src="../../images//button/query.gif" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" class="input_data2" readonly value=''  onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
										<td width="35%" class="data_td">
											<input type="text" name="req_dept" id="req_dept" style="ime-mode:inactive"  size="16" class="inputsubmit" value='' onkeydown='entKeyDown()'>
											<a href="javascript:PopupManager('REQ_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="req_dept_name" id="req_dept_name" size="25" class="input_data2" readonly value='' readOnly onkeydown='entKeyDown()'>
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
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰구분</td>
      									<td width="20%" height="24" class="data_td" colspan="3">
									        <select id="bid_type_c" name="bid_type_c">
		        								<option value="">전체</option>
		        								<option value="D">구매입찰</option>
		        								<option value="C">공사입찰</option>
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
      			<td height="30" align="left"></td>
      			<td height="30" align="right">
					<TABLE cellpadding="0">
			      		<TR>
	    		  			<TD>
<script language="javascript">
btn("javascript:getQuery()","조 회");
</script>
							</TD>
	    		  		</TR>
      				</TABLE>
	      		</td>
    		</tr>
  		</table>
	</form>
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PO_003" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>