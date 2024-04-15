<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("IV_001_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "IV_001_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<% String WISEHUB_PROCESS_ID="IV_001_1";%>

<%
    String house_code = info.getSession("HOUSE_CODE");
    String inv_no	= JSPUtil.nullToEmpty(request.getParameter("inv_no"));
    String eval_refitem	= JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
    String po_no    = JSPUtil.nullToEmpty(request.getParameter("po_no"));

	String toDays          = SepoaDate.getShortDateString();    
    
    String po_no11 = "";
    String po_name12 = "";
    String project_name21 = "";
    String iv_no31 = "";   //매입계산서번호
    String inv_no32 = "";
    String inv_seq41 = "";
    String app_status42 = "";
    String confirm_date1 = "";
    String po_ttl_amt51 = "";
    String inv_amt52 = "";
    String dp_amt = "";
    String vendor_name61 = "";
    String vendor_cp_name62 = "";
    String bb71 = "";
    String attach_no81 = "";
    String inv_date98 = "";
    String inv_person_name99 = "";
    String invoice_status = "";
    String last_yn = "N";
    String exec_no = "";
    String dp_div = "";
    
    Object[] obj = {inv_no};
    SepoaOut value = ServiceConnector.doService(info, "p2050", "CONNECTION", "getInvDisplay", obj);
	
    SepoaFormater wf = new SepoaFormater(value.result[0]);
    wf.setFormat("INV_DATE","YYYY/MM/DD","DATE");
    if(wf.getRowCount() > 0) {
        po_no11           = wf.getValue("po_no11", 0);
        po_name12         = wf.getValue("po_name12", 0);
        project_name21    = wf.getValue("project_name21", 0);
        inv_no32          = wf.getValue("inv_no32", 0);
        inv_seq41         = wf.getValue("inv_seq41", 0);
        app_status42      = wf.getValue("app_status42", 0);
        confirm_date1     = wf.getValue("confirm_date1", 0);
        
        if(confirm_date1.equals("//")) {
        	confirm_date1 = "미완료";	
        }
        
        po_ttl_amt51      = wf.getValue("po_ttl_amt51", 0);
        inv_amt52         = wf.getValue("inv_amt52", 0);
        dp_amt            = wf.getValue("dp_amt", 0);
        vendor_name61     = wf.getValue("vendor_name61", 0);
        vendor_cp_name62  = wf.getValue("vendor_cp_name62", 0);
        bb71              = wf.getValue("bb71", 0);
        attach_no81       = wf.getValue("attach_no81", 0);
        inv_date98        = wf.getValue("inv_date98", 0);
        inv_person_name99 = wf.getValue("inv_person_name99", 0);
        invoice_status	  = wf.getValue("sign_status", 0);
        last_yn			  = wf.getValue("LAST_YN", 0);
        exec_no	  		  = wf.getValue("EXEC_NO", 0);
        dp_div			  = wf.getValue("DP_DIV", 0);
    }
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
<!--
    var servletUrl 		= "<%=getWiseServletPath("order.ivdp.inv1_bd_dis1")%>";
    var mode;
	
    var IDX_SEL;
    var IDX_ITEM_NO;
    var IDX_DESCRIPTION_LOC;
    var IDX_UNIT_PRICE;
    var IDX_INV_QTY;
    var IDX_GR_QTY;
    var IDX_GR_AMT;

    function setHeader()
    {
		
	    //GridObj.AddGroup("INVOICE_PRICE", "납품정보");
 		//GridObj.AppendHeader("INVOICE_PRICE", "ITEM_QTY");
  		//GridObj.AppendHeader("INVOICE_PRICE", "ITEM_AMT");
		
        GridObj.SetNumberFormat("UNIT_PRICE"  ,G_format_amt);
        GridObj.SetNumberFormat("EXPECT_AMT"  ,G_format_amt);
        GridObj.SetNumberFormat("LAST_EXPECT_AMT"  ,G_format_amt);
        GridObj.SetNumberFormat("ITEM_AMT"    ,G_format_amt);
        GridObj.SetNumberFormat("ITEM_QTY"    ,G_format_qty);
		
		
        
        IDX_SEL = GridObj.GetColHDIndex("SEL");
        IDX_ITEM_NO = GridObj.GetColHDIndex("ITEM_NO");
        IDX_DESCRIPTION_LOC = GridObj.GetColHDIndex("DESCRIPTION_LOC");
        IDX_UNIT_PRICE = GridObj.GetColHDIndex("UNIT_PRICE");
        IDX_INV_QTY = GridObj.GetColHDIndex("INV_QTY");
        IDX_GR_QTY = GridObj.GetColHDIndex("GR_QTY");
        IDX_GR_AMT = GridObj.GetColHDIndex("EXPECT_AMT");
		
        doSelect();
    }

    function doSelect()
    {
        GridObj.SetParam("inv_no",	"<%=inv_no%>");
        GridObj.SetParam("grid_type",	"grid_top");
        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
        GridObj.SendData(servletUrl);
        GridObj.strHDClickAction="sortmulti";
    }

    function calculate_gr_amt(wise, row)
    {
		// 소숫점 두자리까지 계산
      	var GR_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_GR_QTY))*getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3);
      	GD_SetCellValueIndex(GridObj,row,IDX_GR_AMT,setAmt(GR_AMT));
    }
    var summaryCnt = 0;
    function JavaCall(msg1, msg2, msg3, msg4, msg5)
    {
        //var GridObj = GridObj;
        //GridObj.AddSummaryBar('SUMMARY1', '소계', 'summaryall', 'sum', 'EXPECT_AMT');
        
        var f0              = document.forms[0];
        var row             = GridObj.GetRowCount();
        var po_no           = "";
        var shipper         = "";
        var sign_flag       = "";
        
        if(msg1 == "doQuery") {
            var tmp_camt = 0;
            var c_amt = 0;

            var maxRow = GridObj.GetRowCount();
            for(i = 0; i < maxRow; i++) {
                GD_SetCellValueIndex(GridObj,i, IDX_SEL, "true&", "&");
				
				unitPrice = parseFloat(GD_GetCellValueIndex(GridObj,i, IDX_UNIT_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, IDX_UNIT_PRICE));
				invQty = parseFloat(GD_GetCellValueIndex(GridObj,i, IDX_INV_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, IDX_INV_QTY));
                tmp_camt = RoundEx(eval(unitPrice) * eval(invQty), 3);

                //GD_SetCellValueIndex(GridObj,i, IDX_GR_AMT, setAmt(tmp_camt));
                GD_SetCellValueIndex(GridObj,i, IDX_GR_AMT, 0);
            }
			if(summaryCnt == 0) {
				GridObj.AddSummaryBar('SUMMARY1', '합 계', 'summaryall', 'sum', 'INV_QTY,GR_QTY,EXPECT_AMT,LAST_EXPECT_AMT');
                GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
                summaryCnt++;
			}
        }
        
        if(msg1 == "doData") {
    		var mode   = GD_GetParam(GridObj,0);
    		var status = GD_GetParam(GridObj,1);

    		alert(GridObj.GetMessage());
    		if(status != "0") {
    			window.close();
    			opener.doSelect();
    		}
    	}
    	
        // 검수수량이 변경될 경우 검수금액 계산
        if(msg1 == "t_insert") {
	        if(msg3 == IDX_GR_QTY) {
				calculate_gr_amt(GridObj, msg2);
				
				<%if(last_yn.equals("Y")){	//마지막 검수완료 차수일경우 수량이 안맞는 경우를 대비해 검수요청 수량만큼 금액을 보정해준다.%>
					if(GridObj.GetCellValue("INV_QTY", msg2) == GridObj.GetCellValue("GR_QTY", msg2)){
						GridObj.SetCellValue("EXPECT_AMT", msg2, GridObj.GetCellValue("LAST_EXPECT_AMT", msg2));
					}
				<%}%>
	        }
		}
		
		if(msg1 == "t_imagetext") {
			if(msg3 == IDX_ITEM_NO) {
				item_no = GD_GetCellValueIndex(GridObj,msg2,IDX_ITEM_NO);
				window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}
		}
    }

    function Add_file(){
	    var ATTACH_NO_VALUE = document.forms[0].attach_no.value;
	    FileAttach('INV',ATTACH_NO_VALUE,'VI');
	}

    /*
	    파일첨부 팝업에서 받아오는 화면
	*/
	function setAttach(attach_key, arrAttrach, attach_count)
	{
	    var f = document.forms[0];
	    f.attach_no.value = attach_key;
	    f.attach_count.value = attach_count;
	}
	
	function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
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
			if (company == "B") {			// Buyer
				f.target = "attachBFrame";
			} else if (company == "S") {	// Supplier
				f.target = "attachSFrame";
			}
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	function valid_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.confirm_date1.value=year+month+day;
	}
	/**
	 * 입고 및 검수 승인하기
	 */
	function Approval(sign_status)
	{
		var iRowCount = GridObj.GetRowCount();
		var iCheckedCount = 0;
		var comfirm_date1_str = "";
		var gr_amt = 0;
		if(!checkDateCommon(document.forms[0].confirm_date1.value)) {
			alert(" 발행일자를 확인 하세요. ");
			document.forms[0].confirm_date1.focus();
			return;
		}
		comfirm_date1_str = document.forms[0].confirm_date1.value.substr(0,4) + "년"
					 	  + document.forms[0].confirm_date1.value.substr(4,2) + "월"
					  	  + document.forms[0].confirm_date1.value.substr(6,2) + "일";
		
		for(var i = 0; i < iRowCount; i++) {
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "true") {
				inv_qty = GD_GetCellValueIndex(GridObj,i,IDX_INV_QTY);
				gr_qty  = GD_GetCellValueIndex(GridObj,i,IDX_GR_QTY);
				gr_amt  += parseInt(GD_GetCellValueIndex(GridObj,i,IDX_GR_AMT));

				if (Number (inv_qty) < Number (gr_qty)) { // 합격수량이 납품수량보다 클수는 없다.
					alert('합격수량이 납품수량보다 클수는 없습니다.');
					return;
				}
				if (Number (inv_qty) > Number (gr_qty)) { // 납품수량이 합격수량보다 클경우 반송사유를 입력하도록 한다.
					if (document.forms[0].sign_remark.value == "") {
						alert('반송 품목이 존재합니다.\n\n반송을 하는 경우에는 반송사유를 입력해야 합니다.');
						return;
					}
				}
			}
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "false") {
				iCheckedCount++;
			}
		}
		
		if(iCheckedCount > 1) {
			alert("선택되지 않은 항목이 있습니다.");
			return;
		}
		
	    var Message = "합격되지 않은 수량은 공급업체로 반송됩니다. \n\n"+comfirm_date1_str+"로 입고("+gr_amt+"원) 및 검수 완료하시겠습니까?";
	    /*
	    if(sign_status == "E1") {
	    	Message = "입고 및 검수 완료하시겠습니까?";
	    }
	    if(sign_status == "R") {
	    	Message = "전량 반송 하시겠습니까?";
			if(document.forms[0].sign_remark.value == "") {
				alert("반송 사유를 넣으셔야 합니다.");
				return;
			}
	    }
	    */
	    if(confirm(Message)) {
	    	getApproval(sign_status);
	    }
	    return;
	}

	function getApproval(approval_str){
		var tot_amt = 0;
		for(var i = 0; i < GridObj.GetRowCount();i++) {
			tot_amt = tot_amt + new Number(GridObj.GetCellValue("EXPECT_AMT", i));
		}
		var f = document.forms[0];
		var servletUrl1 = "<%=getWiseServletPath("order.ivdp.inv1_bd_lis2")%>";
		
		// 검수완료시 모든 검수완료건은 승인(E1)으로 하고, (반송건수 = 납품수량 - 승인수량)으로 한다.
		GridObj.SetParam("mode",			"approval");
		GridObj.SetParam("inv_no",		"<%=inv_no%>");
		GridObj.SetParam("sign_status",	approval_str);
		GridObj.SetParam("eval_refitem",	"<%=eval_refitem%>");
		GridObj.SetParam("sign_remark",	f.sign_remark.value);
		GridObj.SetParam("inv_total_amt",	tot_amt);
		GridObj.SetParam("last_yn",		'<%=last_yn%>');
		GridObj.SetParam("exec_no",		'<%=exec_no%>');
		GridObj.SetParam("dp_div",		'<%=dp_div%>');
		GridObj.SetParam("confirm_date1",	document.forms[0].confirm_date1.value);
		
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl1, "ALL", "ALL");
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">



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
</script>
</head>
<body onload="javascript:setGridDraw();
setHeader();GD_setProperty(document.WiseGrid);" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<form name="form1" >
	<input type="hidden" name="kind">
	<input type="hidden" name="attach_no" value="<%=attach_no81%>">
	<input type="hidden" name="attach_count" value="">

	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">

	<input type="hidden" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id" value="<%=info.getSession("ID")%>">
	<input type="hidden" name="fnc_name" value="getApproval">
	<input type="hidden" name="approval_str" value="">
	<input type="hidden" name="sign_status" value="N">
	<input type="hidden" name="doc_type" value="INV">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;입고 및 검수처리
	</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<script language="javascript">rdtable_top1()</script>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
    <tr>
      <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 발주번호</td>
      <td width="35%" class="c_data_1"><%=po_no11%></td>
      <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 발주명</td>
      <td width="35%" class="c_data_1"><%=po_name12%></td>
    </tr>
    <tr>
      <!--
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 프로젝트명</td>
      <td class="c_data_1"><//%=project_name21%></td>
      -->
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수요청일자</td>
      <td class="c_data_1"><%=app_status42%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수완료일자</td>
      <td class="c_data_1">
 		<input type="text" name="confirm_date1" size="30" class="input_re" maxlength="10"  value="<%=toDays.replace("-", "")%>">
 		<a href="javascript:Calendar_Open('valid_date');">
<!-- 			<img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"> -->
		</a>
      </td>
    </tr>
    <tr>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수요청번호</td>
      <td class="c_data_1"><%=inv_no32%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 요청차수</td>
      <td class="c_data_1"><%=inv_seq41%></td>
    </tr>
    <tr>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 발주총금액<br>&nbsp;&nbsp;&nbsp;(VAT별도)</td>
      <td class="c_data_1"><%=po_ttl_amt51%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수후잔액<br>&nbsp;&nbsp;&nbsp;(VAT별도)</td>
      <td class="c_data_1"><%=inv_amt52%></td>
    </tr>  
    <tr>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 공급업체</td>
      <td class="c_data_1"><%=vendor_name61%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 공급업체담당자</td>
      <td class="c_data_1"><%=vendor_cp_name62%></td>
    </tr>
    <!-- 2011-03-08 solarb 검수요청현황 -->
    <!-- 2011-03-08 보증보험증권  hidden -->
    <tr style="display: none;">
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 보증보험증권</td>
      <td colspan="3" class="c_data_1"><%=bb71%></td>
    </tr>
	<tr>
		<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 첨부파일</td>
		<td class="c_data_1" colspan="3">
			<iframe name="attachSFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
			<br>&nbsp;
		</td>
	</tr>
	<tr>
		<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 반송사유<br>(불합격 수량이 있는 경우 작성)</td>
		<td class="c_data_1" colspan="3">
            <textarea name="sign_remark" class="inputsubmit" rows="4" style="width:98%"></textarea>
		</td>
	</tr>
</table>

<script language="javascript">rdtable_bot1()</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td height="30" align="right">
            <TABLE cellpadding="0">
                <TR>
                    <TD><script language="javascript">btn("javascript:Approval('E1')","검수완료")</script></TD>
                    <TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
                </TR>
            </TABLE>
        </td>
    </tr>
</table>

<!-- <table width="100%" border="0" cellpadding="0" cellspacing="0"> -->
<!-- <tr> -->
<!-- 	<td height="1" class="cell"></td> -->
<!-- </tr> -->
<!-- <tr> -->
<!-- 	<td> -->
<%-- 		<%=WiseTable_Scripts("100%","200","",  info.getSession("LANGUAGE") ,"WiseGrid")%> --%>
<!-- 	</td> -->
<!-- </tr> -->
<!-- </table> -->
</form>

<iframe src="" name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe>


</s:header>
<s:grid screen_id="IV_001_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>

<script language="javascript">rMateFileAttach('S','R','IV',form1.attach_no.value,'S');</script>




