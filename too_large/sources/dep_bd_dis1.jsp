<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_134");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AD_134";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="AD_134";%>
<%--
화면명  : 부서단위 > (부서단위)상세조회 (/kr/admin/organization/depart/dep_bd_dis1.jsp)
내  용  : (부서단위)상세조회
작성자  : 신병곤
작성일  : 2006.01.19.
비  고  :
--%>
<%
	String user_id       = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept     = info.getSession("DEPARTMENT");
	String house_code    = info.getSession("HOUSE_CODE");
	String url           = JSPUtil.nullToEmpty(request.getParameter("url"));
	String titleName     = JSPUtil.nullToEmpty(request.getParameter("titleName"));
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<%
	String I_COMPANY_CODE   = JSPUtil.nullToEmpty(request.getParameter("I_COMPANY_CODE"));
	String I_DEPT           = JSPUtil.nullToEmpty(request.getParameter("I_DEPT"));
	String I_PR_LOCATION    = JSPUtil.nullToEmpty(request.getParameter("I_PR_LOCATION"));

	String dept_name_loc                = "" ;
	String dept_name_eng                = "" ;
	String manager_name            = "" ;
	String manager_position        = "" ;
	String manager_position_name   = "" ;
	String pr_location             = "" ;
	String pr_location_name        = "" ;
	String menu_profile_code       = "" ;
	String menu_name               = "" ;
	String ctrl_dept_flag          = "" ;
	String phone_no                = "" ;
	String fax_no                  = "" ;
	String menu_type               = "" ;

	String[] data = {house_code,I_COMPANY_CODE,I_DEPT,I_PR_LOCATION};
	Object[] obj = {data};
	SepoaOut value = ServiceConnector.doService(info, "p6008", "CONNECTION","getDis", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	
	if(wf.getRowCount() > 0) {
        for(int i=0;i<wf.getRowCount();i++){
        	dept_name_loc           = wf.getValue("DEPT_NAME_LOC"        , 0) ;
			dept_name_eng           = wf.getValue("DEPT_NAME_ENG"        , 0) ;
			manager_name            = wf.getValue("MANAGER_NAME"         , 0) ;
			manager_position        = wf.getValue("MANAGER_POSITION"     , 0) ;
			manager_position_name   = wf.getValue("MANAGER_POSITION_NAME", 0) ;
			pr_location             = wf.getValue("PR_LOCATION"          , 0) ;
			pr_location_name        = wf.getValue("PR_LOCATION_NAME"     , 0) ;
			menu_profile_code       = wf.getValue("MENU_PROFILE_CODE"    , 0) ;
			menu_name               = wf.getValue("MENU_NAME"            , 0) ;
			ctrl_dept_flag          = wf.getValue("CTRL_DEPT_FLAG"       , 0) ;
			phone_no                = wf.getValue("PHONE_NO"             , 0) ;
			fax_no                  = wf.getValue("FAX_NO"               , 0) ;
			menu_type               = wf.getValue("MENU_TYPE"            , 0) ;
        }
    }


	/* try {
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName, obj);
		if(value.status == 1)
		{
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			if ( wf.getRowCount() > 0 ) {
				dept_name_loc           = wf.getValue("DEPT_NAME_LOC"        , 0) ;
				dept_name_eng           = wf.getValue("DEPT_NAME_ENG"        , 0) ;
				manager_name            = wf.getValue("MANAGER_NAME"         , 0) ;
				manager_position        = wf.getValue("MANAGER_POSITION"     , 0) ;
				manager_position_name   = wf.getValue("MANAGER_POSITION_NAME", 0) ;
				pr_location             = wf.getValue("PR_LOCATION"          , 0) ;
				pr_location_name        = wf.getValue("PR_LOCATION_NAME"     , 0) ;
				menu_profile_code       = wf.getValue("MENU_PROFILE_CODE"    , 0) ;
				menu_name               = wf.getValue("MENU_NAME"            , 0) ;
				ctrl_dept_flag          = wf.getValue("CTRL_DEPT_FLAG"       , 0) ;
				phone_no                = wf.getValue("PHONE_NO"             , 0) ;
				fax_no                  = wf.getValue("FAX_NO"               , 0) ;
				menu_type               = wf.getValue("MENU_TYPE"            , 0) ;
			}
		}
	}catch(Exception e) {
		Logger.debug.println(info.getSession("ID"),request,"---------->e = " + e.getMessage());
	}finally{
		try{
			ws.Release();
		}catch(Exception e){}
	} */
%>
<Script language="javascript">
function Init()
{
	if(document.form.ctrl_dept_flag2.value == "Y") document.form.ctrl_dept_flag.checked = true;
}

function doList()
{
	top.MakeTabList("<%=titleName%>","<%=url%>");
	//location.href="dep_bd_lis1.jsp";
}
</Script>



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
    return true;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" onload="Init();">

<s:header>
<!--내용시작-->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr >
	  		<td class="cell_title1" width="78%" align="left">&nbsp;
	  		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12">
	  			<%@ include file="/include/sepoa_milestone.jsp" %>
	  		</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>	
  
<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
<form name="form" >
	<tr>
	  <td class="c_title_1" width="20%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 회사코드</td>
	  <td class="c_data_1" width="80%">
		<input type="text" name="company_code" value="<%=I_COMPANY_CODE%>" size="30" class="input_data2" readOnly>
	  </td>
	</tr>
  </table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
	      			<TD><script language="javascript">btn("javascript:history.back(-1)","취 소")</script></TD>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
	<tr>
	  <td width="20%" class="c_title_1" height="32">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 부서코드</div>
	  </td>
	  <td class="c_data_1" colspan="3"><%=I_DEPT%></td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 부서명(한글)</div>
	  </td>
	  <td colspan="3" class="c_data_1"><%=dept_name_loc%></td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 부서명(영문)</div>
	  </td>
	  <td colspan="3" class="c_data_1"><%=dept_name_eng%></td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 부서장</td>
	  <td width="30%" class="c_data_1"><%=manager_name%></td>
	  <td width="20%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 부서장직책</td>
	  <td width="30%" class="c_data_1"><%=manager_position%>/<%=manager_position_name%></td>
	</tr>

	 <tr>
	  <td width="20%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 메뉴형태</div>
	  </td>
	  <td colspan="3" class="c_data_1"><%=menu_type%></td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 프로파일코드</td>
	  <td colspan="3" class="c_data_1" colspan="3"><%=menu_profile_code%>/<%=menu_name%></td>
	</tr>

	<tr>
	  <td width="20%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 청구지역코드</td>
	  <td colspan="3" class="c_data_1"> <%=pr_location_name%></td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 통제부서</td>
	  <td colspan="3" class="c_data_1">
		 <input type="checkbox" name="ctrl_dept_flag" value="">
		 <input type="hidden" name="ctrl_dept_flag2" value="<%=ctrl_dept_flag%>"></td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 전화번호</td>
	  <td colspan="3" class="c_data_1"> <%=phone_no%></td>
	</tr>
	<tr>
	  <td width="20%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 팩스번호</td>
	  <td colspan="3" class="c_data_1"> <%=fax_no%> </td>
	</tr>
  </table>

</form>


</s:header>
<%-- <s:grid screen_id="AD_134" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>


