<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("DV_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "DV_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%@ page import="xecure.servlet.*" %>
<%@ page import="xecure.crypto.*" %>

<%
	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String house_code      = info.getSession("HOUSE_CODE");
	String department      = info.getSession("DEPARTMENT");
	String department_name = info.getSession("DEPARTMENT_NAME_LOC");
	/* String toDays          = SepoaDate.getShortDateString();
	String toDays_1        = SepoaDate.addSepoaDateMonth(toDays,-1);
	 */
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(to_day,-1));
	String to_date = SepoaString.getDateSlashFormat(to_day);
	
	String user_name_loc   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");
	
	String state           = JSPUtil.nullToEmpty(request.getParameter("state"));
	String IRS_NO = "";
	
	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 작성 사용여부
	// wise.properties의 wise.po.contract.use.#HOUSE_CODE# = true/false 에 따라 옵션으로 진행한다.	Config wise_conf = new Configuration();
	Config sepoa_conf = new Configuration();
 	boolean po_contract_use_flag = false;
	try {
		po_contract_use_flag = sepoa_conf.getBoolean("sepoa.po.contract.use."+house_code); //諛�＜ ���怨�� �ъ��щ�
	} catch (Exception e) {
		po_contract_use_flag = false;
	} 
%>



<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid��JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox��JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">
	<%-- var	servletUrl = "<%=getWiseServletPath("supply.ordering.po.po3_bd_lis1")%>"; --%>
	var mode;
	var checked_count = 0;

	var IDX_SEL			 	 ;
	var IDX_STATUS_TXT		 ;
	var IDX_CONFIRM_STATUS	 ;
	var IDX_PO_NO			 ;
	var IDX_SUBJECT			 ;
	var IDX_PO_CREATE_DATE	 ;
	var IDX_PAY_TERMS		 ;
	var IDX_CTRL_CODE		 ;
	var IDX_TAKE_USER_NAME	 ;
	var IDX_CUR			     ;
	var IDX_PO_TTL_AMT		 ;
	var IDX_IRS_NO			 ;
	var IDX_CONT_SEQ		 ;
	var IDX_CONT_COUNT		 ;

	var chkrow;

	function init() {
		setGridDraw();
		setHeader();
		
		
		var temp = "<%=state%>";
		var f0 = document.forms[0];

		if (temp != "") {
			for(var i = 0; i < f0.po_status.length; i++) {
				if (temp == f0.po_status.options(i).value) {
					f0.po_status.selectedIndex = i;
					break;
				}
			}
			doSelect();
		}
	}

	function setHeader() {
		var f0 = document.forms[0];

		f0.po_from_date.value = "<%=from_date%>";
		f0.po_to_date.value   = "<%=to_date%>";

		

		/* GridObj.SetNumberFormat(     "PO_TTL_AMT"			,G_format_amt); */
	/* 	GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd"); */

 
		IDX_SEL			 	 = GridObj.GetColHDIndex("SEL"				);
		IDX_STATUS_TXT		 = GridObj.GetColHDIndex("STATUS_TXT"			);
		IDX_CONFIRM_STATUS	 = GridObj.GetColHDIndex("CONFIRM_STATUS"		);
		IDX_PO_NO			 = GridObj.GetColHDIndex("PO_NO"				);
		IDX_SUBJECT	 		 = GridObj.GetColHDIndex("SUBJECT"			);
		//IDX_PO_CREATE_DATE	 = GridObj.GetColHDIndex("PO_CREATE_DATE"		);
		IDX_PAY_TERMS		 = GridObj.GetColHDIndex("PAY_TERMS"			);
		IDX_CTRL_CODE		 = GridObj.GetColHDIndex("CTRL_CODE"			);
		IDX_TAKE_USER_NAME	 = GridObj.GetColHDIndex("TAKE_USER_NAME"		);
		IDX_CUR			     = GridObj.GetColHDIndex("CUR"				);
		//IDX_PO_TTL_AMT		 = GridObj.GetColHDIndex("PO_TTL_AMT"			);
		IDX_IRS_NO		     = GridObj.GetColHDIndex("IRS_NO"			    );
		IDX_CONT_SEQ	     = GridObj.GetColHDIndex("CONT_SEQ"			);
		IDX_CONT_COUNT	     = GridObj.GetColHDIndex("CONT_COUNT"			);  
	}

	function doSelect()
	{
		var f0 = document.forms[0];

		if( !checkDate(f0.po_from_date.value.replaceAll("/","")) ){
			alert(" 수주일자(From)를 확인 하세요");
			f0.po_from_date.focus();
			return;
		}
		if( !checkDate(f0.po_to_date.value.replaceAll("/","")) ){
			alert(" 수주일자(To)를 확인 하세요");
			f0.po_to_date.focus();
			return;
		}


		f0.po_no.value        = f0.po_no.value.toUpperCase();
		GridObj.SetParam("mode",           "getPoList");
		GridObj.SetParam("from_date",      f0.po_from_date.value);
		GridObj.SetParam("to_date",        f0.po_to_date.value);
		GridObj.SetParam("po_no",          f0.po_no.value);
		GridObj.SetParam("confirm_status", f0.confirm_status.value);
		GridObj.SetParam("po_status",      f0.po_status.value);
		GridObj.SetParam("subject",      	 f0.subject.value);
		//GridObj.SetParam("ctrl_code",      f0.ctrl_code.value);
		//GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		//GridObj.SendData(servletUrl);
		//GridObj.strHDClickAction="sortmulti";
		
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getStateList&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.order_state_list";
	
		
		GridObj.post(url, param);
		GridObj.clearAll(false);	
	}
	var windowObj;
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		var f0              = document.forms[0];
		var row             = GridObj.GetRowCount();
		var po_no           = "";
		var shipper         = "";
		var sign_flag       = "";

    for(var i=0;i<GridObj.GetRowCount();i++) {
           if(i%2 == 1){
		    for (var j = 0;	j<GridObj.GetColCount(); j++){
		        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
	        }
           }
	}

		if(msg1 == "doData"){
			//if(windowObj != ""){
			//	windowObj.document.forms[0].PO_NO.focus();
			//}
			alert(GD_GetParam(GridObj,"0"));
			if(GridObj.GetStatus()==1)
				doSelect();
		}

		if(msg1 == "t_imagetext")
		{
			if(msg3==IDX_PO_NO) {
				var po_no          = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
				//var CONFIRM_STATUS = GD_GetCellValueIndex(GridObj,msg2,IDX_CONFIRM_STATUS);
			    var windowObj = window.open("po3_pp_dis1.jsp"+"?po_no="+po_no,"po3_pp_dis1","width=1024,height=570,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		    }
		}
	}

	function doConfirm(status) {
		var selectedRow = 0;
		var signCont = "";
		var sign = "";
		var vendor = "";
		var cont_seq = "";
		var cont_count = "";
		for(var i=0; i<GridObj.GetRowCount(); i++) {
			if(GD_GetCellValueIndex(GridObj,i, IDX_SEL) == "1") {

				var CONFIRM_STATUS = GD_GetCellValueIndex(GridObj,i, IDX_CONFIRM_STATUS);

				signCont = GD_GetCellValueIndex(GridObj,i, IDX_PO_NO);
				vendor = GD_GetCellValueIndex(GridObj,i, IDX_IRS_NO);
				cont_seq = GD_GetCellValueIndex(GridObj,i, IDX_CONT_SEQ);
				cont_count = GD_GetCellValueIndex(GridObj,i, IDX_CONT_COUNT);

				if(CONFIRM_STATUS == "확인"){
					alert("선택하신 수주는 이미 [확인] 처리하셨습니다.");
					return;
				}
				if(CONFIRM_STATUS == "확인반송"){
					alert("선택하신 수주는 이미 [반송] 처리하셨습니다.");
					return;
				}
				selectedRow++;
			}
		}
		if(selectedRow == 0){
			alert("수주건을 선택해 주세요.");
			return;
		}
		if(selectedRow > 1){
            alert("수주건을 1개만 선택해 주세요.");
            return;
        }
		// 확인 또는 전자계약 화면으로 이동
		confirm_cont(signCont, vendor, cont_seq, cont_count, signCont);
		return;
	}
	
	
	
	//서명검증 및 식별번호 검증 후 call.
	function doSignConfirm(sign){
        GridObj.SetParam("mode", "setPoConfirm");
        GridObj.SetParam("confirm_sign", sign);
        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
        GridObj.SendData(servletUrl, "ALL", "ALL");
    }

    function setPreSignData(SignData) {
        var presigndata = '';
        presigndata = SignData + "<%=company_code%>" + "<%=user_id%>";
	    return presigndata;
    }

//************************************************** Date Set *************************************
	function valid_from_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.po_from_date.value=year+month+day;
	}

	function valid_to_date(year,month,day,week) {
	    var f0 = document.forms[0];
	    f0.po_to_date.value=year+month+day;
	}

	function checkedRow()
	{
		var sendRow = "" ;
		var row = GridObj.GetRowCount() ;

		for (var i=0; i<row; i++)
		{
			check = GD_GetCellValueIndex(GridObj,i,IDX_SEL) ;
			if (check == "true")
			{
				sendRow += (i+"&") ;
			}
		}

		return sendRow ;
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
	function printRD(){
		var wise 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;

		for(var i=0;i<iRowCount;i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "true")
			{
				iCheckedCount++;
				iSelectedRow = i;
				var po_no = GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_PO_NO);
				if(po_no == ""){
					alert("수주 정보가 없습니다.");
					continue;
				}
				window.open("/RD/po_rd_dis.jsp?po_no="+po_no+"&house_code=<%=info.getSession("HOUSE_CODE")%>","newWin"+i,"width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			}
		}
		if(iSelectedRow == -1)
			alert("선택된 수주 정보가 없습니다.");
	}

	/**
	 * 계약서 전자서명
	 */
 	function confirm_cont(po_no, vendor_code, cont_seq, cont_count, signCont)
	{
		//2011.08.24 HMCHOI
		//전자계약서 서명 (발주서를 기준으로 전자계약을 체결하지 않았거나, 계약서번호가 없으면 기존 형식으로 처리함)
       	<%if (!po_contract_use_flag) {%>
			var windowObj = window.open("order_confirm.jsp"+"?po_no="+signCont+"&confirm_flag=Y","order_confirm_c","width=1024,height=700,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			return;
       	<%} else {%>
			if (cont_seq == "" || cont_seq == null) {
				var windowObj = window.open("order_confirm.jsp"+"?po_no="+signCont+"&confirm_flag=Y","order_confirm_c","width=1024,height=700,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
				return;
			}
       	<%}%>
        window.open("","contractwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
        
    	document.main.target = 'contractwin';
    	document.main._page.value = "CONTRACT_READ";//GO_READ
    	document.main._action.value = "HANDLE";
    	document.main._param.value = "CONTRACT_READ_HANDLER";
    	
    	document.main.bid_no.value = po_no;
    	document.main.vendor_code.value = vendor_code;
    	document.main.cont_seq.value = cont_seq;
    	document.main.cont_count.value = cont_count;
    	
    	document.main.action = "/s_kr/ctr/Main.jsp";
    	document.main.submit();
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
// 洹몃━���대┃ �대깽��������몄� �⑸��� rowId ����� ID�대ŉ cellInd 媛�� 而щ� �몃���媛��硫�// �대깽��泥�━��而щ�紐�怨������� 泥�━����ㅻ㈃ GridObj.getColIndexById("selected") == cellInd �대�寃�泥�━���硫��⑸���
function doOnRowSelected(rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
	
	if(header_name=="PO_NO") {
		var po_no	= LRTrim(GridObj.cells(rowId, IDX_PO_NO).getValue());   //GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
 		//var po_type	= LRTrim(GridObj.cells(rowId, INDEX_PO_TYPE).getValue());	//GD_GetCellValueIndex(GridObj,msg2,IDX_PO_TYPE);
	    //window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no ,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		var url              = "/kr/order/bpo/po3_pp_dis1.jsp";
		var title            = '발주화면상세조회';
		var param = "";
		param = param + "po_no=" + po_no;

		if (po_no != "") {
		    popUpOpen01(url, title, '1024', '600', param);
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
    
//     document.forms[0].po_from_date.value = add_Slash( document.forms[0].po_from_date.value );
//     document.forms[0].po_to_date.value   = add_Slash( document.forms[0].po_to_date.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:init();doSelect();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--�댁����-->
<form name="form1" >
<input type="hidden" name="kind" id="kind">
<input type="hidden" name="po_status" id="po_status">

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
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주일자</td>
      <td class="data_td" width="35%">
       	<s:calendar id_to="po_to_date"  id_from="po_from_date"  format="%Y/%m/%d"/>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주번호</td>
      <td class="data_td" width="35%">
        <input type="text" name="po_no" id="po_no" style="width:35%;ime-mode:inactive" class="inputsubmit" maxlength="20">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 확인여부</td>
      <td class="data_td" width="35%">
        <select name="confirm_status" id="confirm_status" class="inputsubmit">
          <option value="">전체</option>
        <%
            String confirm_status = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M644", "");
            out.println(confirm_status);
        %>
        </select>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주명 </td>
      <td class="data_td" width="35%">
         <input type="text" name="subject" id="subject" style="width:35%" class="inputsubmit" maxlength="20">
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
      			<b>※5일 이내 확인 확인 요망</b>
      		</td>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
		      			<TD><script language="javascript">btn("javascript:doSelect()","조회")    </script></TD>
		      			<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td>
	    	  			<TD><script language="javascript">btn("javascript:doConfirm()","확인/반송")    </script></TD>
	    	  			<!--TD><script language="javascript">btn("javascript:printRD()",34,"인쇄)    </script></TD-->
					</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>


</form>

<form name="form2" method=post action="/s_kr/xecureVerify.jsp" target="getDescframe">
<input type="hidden" name="signdata">
<input type="hidden" name="vid_msg">
<input type="hidden" name="signcount">
<input type="hidden" name="signnum">
</form>

<!-- 전자계약 화면이동 시작 -->
<form name="main" method="post">
	<input type="hidden" name="_page">
	<input type="hidden" name="_action">
	<input type="hidden" name="_param">
	
	<!-- 발주 및 업체번호 -->
	<input type="hidden" name="bid_no">
	<input type="hidden" name="vendor_code">
	
	<!-- 계약번호 및 계약차수 -->
	<input type="hidden" name="cont_seq">
	<input type="hidden" name="cont_count">
</form>
<!-- 전자계약 화면이동 종료 -->

<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="DV_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


