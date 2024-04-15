<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SUP_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SUP_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="I_SUP_002";%>

<%



	String house_code  = info.getSession("HOUSE_CODE");
	String vendor_code = info.getSession("COMPANY_CODE");
	String sign_status = JSPUtil.nullToEmpty(request.getParameter("sign_status"));
	String gubun       = JSPUtil.nullToEmpty(request.getParameter("gubun"));
	String user_id     = info.getSession("ID");

	String work_type_code = "";

	String[] args = {house_code,user_id,vendor_code,sign_status};
	Object[] obj = {(Object[])args};

	SepoaOut value = ServiceConnector.doService(info, "s6030", "CONNECTION","getWokrType_ict", obj);

	if(value.status == 1)
	{
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		if ( wf.getRowCount() > 0 ){
				work_type_code           = wf.getValue("WORK_TYPE"      , 0) ;
		}
	}

%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">
//<!--

function Init(){
	
	setGridDraw();
	setHeader();
	doSelect();
	
}
function setHeader() {
	//조회된 화면을 View한다.
	doSelect();
}

	//Data Query해서 가져오기
	function doSelect() {
		var company_code = document.form.company_code.value;
		var depart = document.form.depart.value;
		var user_id = document.form.user_id.value;
		var user_name = document.form.user_name.value;
		var user_type = document.form.user_type.value;
		var work_type = document.form.work_type.value; 

		document.form.depart.value = document.form.depart.value.toUpperCase();
		document.form.user_id.value = document.form.user_id.value.toUpperCase();
		/*
		if(company_code == "") {
			alert("회사코드를 넣어주세요");
			return;
		}
		*/
		if(user_id == "") document.forms[0].text_user_name.value = "";
		if (document.forms[0].dept_usedpopup.value == "off" && depart != "" && user_id == "") {
			getDeptDesc(company_code,depart,"1");
		}
		if (document.forms[0].id_usedpopup.value == "off" && depart != "" && user_id != "") {
			getDeptUserDesc(company_code,depart,user_id,"2");
		}
		if(depart == "") document.form.text_depart.value = "";

		document.forms[0].dept_usedpopup.value = "off";
		document.forms[0].id_usedpopup.value = "off";
		
		/* GridObj.SetParam("user_id",user_id);
		GridObj.SetParam("user_name",user_name);
		GridObj.SetParam("company_code",company_code);
		GridObj.SetParam("depart",depart); */
		
		
		/*
			서플라이쪽 사용자현황에서 업체소속의 사용자 요청건에 한해서 승인할 수 있는 권한이 추가되었기 때문에,
			새로운 sign_status를 값으로 넘겨서 승인된 사용자와 승인되지 않는 사용자를
			조회한다.
		*/

		<%-- GridObj.SetParam("sign_status","<%=sign_status%>"+"R");
		GridObj.SetParam("user_type",user_type);
		GridObj.SetParam("work_type",work_type);

		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; --%>
		
		$('#user_id').val(user_id);
		$('#user_name').val(user_name);
		$('#company_code').val(company_code);
		$('#depart').val(depart);
				
		$('#sign_status').val("<%=sign_status%>"+"R");
		$('#user_type').val(user_type);
		$('#work_type').val(work_type);
		
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.supply.admin.user.use_lis1_ict";

		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getMainternace";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		
	}

/*팝업화면을 이용하지 않고 손으로 입력했을때 description 보여주기 */
function getDeptDesc(company_code,depart,flag) {
	parent.work.location.href = "use_wk_lis2.jsp?company_code="+company_code+"&depart="+depart+"&user_id= &flag="+flag;
}
function setDeptDesc(text_depart) {
	document.forms[0].text_depart.value = text_depart;
}
function getDeptUserDesc(company_code,depart,user_id,flag) {
	parent.work.location.href = "use_wk_lis2.jsp?company_code="+company_code+"&depart="+depart+"&user_id="+user_id+"&flag="+flag;
}

function setDeptUserDesc(text_depart,user_name) {
	document.forms[0].text_depart.value = text_depart;
	document.forms[0].text_user_name.value = user_name;
}

	//선택된 Row 수정화면으로 이동
	function doModify() {

		var wise =  GridObj;
		var sel_row = "";

		/* 변경할 항목을 선택했는지 체크하고 여러개가 선택되었으면 가장 위의 항목에 대한 변경화면으로 이동한다.*/
		for(var i=0;i<GridObj.GetRowCount();i++){
			var temp = GD_GetCellValueIndex(GridObj,i,0);
			if(temp == true) {
				sel_row += i + "&";

				dim = ToCenter('600','800');
				var top = dim[0];
				var left = dim[1];

				// flag는 B: top에서의 자기자신의 사용자 정보를 고칠때 ,N: 마스터 사용자메뉴에서  사용자 수정 P: ?

				if("<%=user_id%>" != GD_GetCellValueIndex(GridObj,i,1) && "Z" != "<%=work_type_code%>"){
					alert("해당사용자 또는 관리자만 사용자정보를 수정할 수 있습니다.");
					return;
				}
				winobj = window.open("/s_kr/admin/user/use_bd_updf.jsp?flag=N&user_id="+GD_GetCellValueIndex(GridObj,i,1),"BKWin","top="+top+",left="+left+",width=840,height=500,resizable=yes,status=yes,scrollbars = yes");

				break;
			}
		}
		if(sel_row=="") alert("항목을 선택해주세요.");
	}

	//선택된 항목의 세부사항을 보여준다.
	function Display() {
		var wise =  GridObj;
		var sel_row = "";

		/* 변경할 항목을 선택했는지 체크하고 여러개가 선택되었으면 가장 위의 항목에 대한 변경화면으로 이동한다.*/
		for(var i=0;i<GridObj.GetRowCount();i++){
			var temp = GD_GetCellValueIndex(GridObj,i,0);
			if(temp == true) {
				sel_row += i + "&";
				//alert(i+1+"번째 항목이 선택되었습니다.");

				dim = ToCenter('600','800');
				var top = dim[0];
				var left = dim[1];

				winobj = window.open("/ict/s_kr/admin/user/use_bd_dis2_ict.jsp?user_id="+GD_GetCellValueIndex(GridObj,i,1),"BKWin","top="+top+",left="+left+",width=840,height=500,resizable=yes,status=yes,scrollbars = yes");

				break;
			}
		}
		if(sel_row=="") alert("항목을 선택해주세요.");

	}

	//승인시 이 함수를 부른다. 선택된 ROW를 확인.
	function checkrow() {
		var rtn = "false"
	    var addrow = GridObj.GetRowCount();
		for(i = 0 ; i < parseInt(addrow) ; i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,"0") != "false") rtn = "true";
		}
        return rtn;
	}

	//승인시 이 함수를 부른다. 선택된 곳의 메뉴 코드가 있는지 확인.
	function checkcode() {
		var rtn = "false"
	    var addrow = GridObj.GetRowCount();
		for(i = 0 ; i < parseInt(addrow) ; i++)
		{
			// 선택이 되었고 메뉴코드가 없는 것이 발견되었다.
			if(GD_GetCellValueIndex(GridObj,i,"0") == "true" && GD_GetCellValueIndex(GridObj,i,"9") == "") rtn = "true";
		}
        return rtn;
	}



	//사용자 승인
	function setApproval() {
		var SepoaObj = GridObj;
		checkrtn = checkrow();
		if(checkrtn == "false")
		{
			alert("데이타를 선택하세요 !!!! ");
			return;
		}

		if(checkcode() == "true")
		{
			alert("프로파일 코드를 넣어주세요.");
			return;
		}

		if("<%=work_type_code%>" != "Z")
		{
			alert("관리자 계정을 가진 사람만 승인 가능합니다.");
			return;

		}

		if(!confirm("승인 하시겠습니까?")) return;
/* 		var servletUrl = "/servlets/supply.admin.user.use_app1"; */
		/* GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL"); */
		
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.user.use_app1";
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setApproval";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(G_SERVLETURL+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}



	//사용자 삭제
	function doDelete(flag) {
		
		var SepoaObj = GridObj;
		checkrtn = checkrow();
		
		if(checkrtn == "false")	{
			alert("데이타를 선택하세요 !!!! ");
			return;
		}else {
			if("<%=work_type_code%>" != "Z"){
				alert("관리자 계정을 가진 사람만 삭제 가능합니다.");
				return;
			}
			var anw = confirm("정말 삭제 하시겠습니까?");
			if(anw == true) {
				GridObj.SetParam("flag",flag);

				var G_SERVLETURL = "/servlets/ict.supply.admin.user.use_del1_ict";
				
				var grid_array = getGridChangedRows(GridObj, "SELECTED");
				var cols_ids = "<%=grid_col_id%>";
				var params;
				params = "?mode=setDelete";
				params += "&cols_ids=" + cols_ids;
				params += dataOutput();
				myDataProcessor = new dataProcessor(G_SERVLETURL+params);
				//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
				sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
				
			} else return;
		}
	}

// 메뉴 오브젝트 코드를 받고 프로 파일 정보를 볼 수있도록 팝업을 띄운다.
function setobjectcode(obj_code,code) {
	var col = document.forms[0].scol.value;
	var row = document.forms[0].srow.value;
	var obj_name = GridObj.GetCellValue(GridObj.GetColHDKey(row),col);

	var url = "/kr/admin/system/mu1_pp_ins2.jsp?MENU_PROFILE_CODE=" +obj_code+ "&MENU_NAME=" + obj_name+"&MENU_CODE="+code;
	var dim = new Array(2);

	dim = ToCenter('600','800');
	var top = dim[0];
	var left = dim[1];
	window.open(url,"BKWin","top="+top+",left="+left+",width=800,height=600,resizable=yes,status=yes,scrollbars = yes");


}



function JavaCall(msg1, msg2, msg3, msg4, msg5)  {

	if(msg1 == "doData") {
   		//rtn = GD_GetParam(GridObj, 0 );
   		//alert(rtn); // 서버에서 가져오는 메세지이다.

		doSelect();
	}

	if(msg1 == "t_imagetext" )
	{
			document.forms[0].scol.value = msg2;
			document.forms[0].srow.value = msg3;

			var obj_code = GD_GetCellValueIndex(GridObj,msg2,msg3);
			if (obj_code == "") {
				alert("프로파일 코드가 지정되지 않았습니다.");
				return;
			}

			parent.work.location.href = "use_wk_get1.jsp?code="+obj_code;

	}
}

function Setprofile(code,name) {

	var col = document.forms[0].scol.value;
	var row = document.forms[0].srow.value;
	GD_SetCellValueIndex(GridObj,col, row,"/kr/images/button/query.gif&"+name+"&"+code,"&");

	;


}

/*팝업화면.*/
function getDept(code, text) {
	document.forms[0].depart.value = code;
	document.forms[0].text_depart.value = text;
	document.forms[0].dept_usedpopup.value = "on";
}

function SP9112_getCode(id, no, name, dept ) {
	document.forms[0].user_id.value = id;
	document.forms[0].text_user_name.value = name;
	document.forms[0].id_usedpopup.value = "on";
}

function getPartner_code(code,text, type) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code.value = text;
}

function getVendor_code(code,text, texteng) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code.value = text;
}

function searchProfile(fc) {
	var url = "";
		if( fc == "company_code" ) {

		   if (document.forms[0].edit.value == "N")
		   		return;

		   if (document.forms[0].user_type.value  == "")
		   {
				alert("회사 구분을 먼저 선택해야 합니다.");
				return;
		   }

		   if (document.forms[0].user_type.value  == "P")
		   {
				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0055&function=getPartner_code&values=<%=house_code%>&values=&values=";

		   } else if (document.forms[0].user_type.value  == "S")
		   {
				window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
				return;
		   }

		}
		if(fc == "dept") {

			if (document.forms[0].user_type.value  == "P" || document.forms[0].user_type.value  == "S")
			{
			//url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getDept&values=<%=house_code%>&values=M105&values=&values=";
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9029&function=getDept&values=<%=house_code%>&values=<%=vendor_code%>&values=C009&values=&values=";

			} else {


				if(document.forms[0].company_code.value == "") {
					alert("회사를 먼저 선택해주세요");
					return;
				}else
					url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0022&function=getDept&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values=&values=";


			}



		}else if (fc == "user_id")  {
			if(document.forms[0].company_code.value == "") {
				alert("회사를 먼저 선택해주세요");
				return;
			}

			if(document.forms[0].depart.value == "") {
				alert("부서단위를 먼저 선택해주세요");
				return;
			}

			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9112&function=D&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values="+document.forms[0].depart.value+"&values=&values=";
		}

		Code_Search(url,'','','','','');
}

function actionedit() {

	user_type = document.forms[0].user_type.value;
	text_user_type = document.forms[0].user_type.options[document.forms[0].user_type.selectedIndex].text;

    if ( user_type == "P" || user_type == "S" ) {
  		document.forms[0].edit.value = "Y";
   		document.forms[0].company_code.value = "";
		document.forms[0].text_company_code.value = "";
    } else {
  		document.forms[0].company_code.value = user_type;
		document.forms[0].text_company_code.value = text_user_type;
		document.forms[0].edit.value = "N";
    }
}

//enter를 눌렀을때 event발생
function entKeyDown()
{
  if(event.keyCode==13) {
                       window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
                       doSelect();
                      }
}
//-->

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
        doSelect();
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
    return true;
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp"%>
<form name="form" method="post" action="">
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
									<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자구분</td>
									<td class="data_td" colspan="3">Supplier
										<input type="hidden" name="user_type" id="user_type" value="S" class="input_data0" readonly  >
										<input type="hidden" name="work_type" id="work_type" value="Z" class="input_data0" readonly  >
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자 ID<br>
									</td>
									<td class="data_td" width="35%">
										<input type="text" size="12" value="" name="user_id" id="user_id" class="inputsubmit" onkeydown='entKeyDown()' >
									</td>
									<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자명<br>
									</td>
									<td class="data_td" width="35%">
										<input type="text" name="user_name" id="user_name" size="20" class="inputsubmit" onkeydown='entKeyDown()' >
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
			<td>
				<input type="hidden"  name="dept_usedpopup" value="off" >
				<input type="hidden"    name="id_usedpopup"   value="off"   >
			</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<table cellpadding="0">
					<tr>
						<td><script language="javascript">btn("javascript:doSelect()","조 회")    </script></td>
						<%
						if (sign_status.equals("R")) {
						%>
							<td><script language="javascript">btn("javascript:Display()","상세정보")    </script></td>
							<!-- <td><script language="javascript">btn("javascript:setApproval()","승 인")    </script></td> -->
							<td><script language="javascript">btn("javascript:doDelete('R')","삭 제")</script></td>
																						
						<%} else {%>
							<%
							if (!gubun.equals("M")) {
							%>
								<td style="display: none;"><script language="javascript">btn("javascript:doModify()","수 정")    </script></td>
							<%} %>
							
							<td><script language="javascript">btn("javascript:Display()","상세정보") </script></td>
							<%
							if (work_type_code.equals("Z")) {
							%>
								<!-- <td><script language="javascript">btn("javascript:setApproval()","승 인")</script></td> -->
								<td><script language="javascript">btn("javascript:doDelete('R')","삭 제")</script></td>
							<%}	%>
						<%} %>
					</tr>
				</table>
			</td>
		</tr>
	</table>
																						
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<input type="hidden" name="scol"           id="scol"              value="" >
				<input type="hidden" name="srow"           id="srow"              value="" >
				<input type="hidden" name="edit"           id="edit"              value="Y">
				<input type="hidden" name="company_code"   id="company_code"      value="<%=vendor_code%>" class="input_data1" readonly  >
				<input type="hidden" name="depart"         id="depart"            size="12" value="" class="inputsubmit"  onkeydown='entKeyDown()' >
				<input type="hidden" name="text_depart"    id="text_depart"       value=""  size="20" class="input_data1" readOnly >
				<input type="hidden" name="text_user_name" id="text_user_name"    value="" size="20" class="input_data1" readOnly >
			</td>
		</tr>
	</table>
</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_SUP_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


