<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="java.net.URLDecoder"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_T04_3");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_T04_3";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/admin/wisepopup/cod_sp_lis3.jsp --%>
<%--
 Title:        	cod_pp_lis3.jsp <p>
 Description:  	코드 POPUP<p>
 Copyright:    	Copyright (c) <p>
 Company:     ICOMPIA <p>
 @author       	DEV.Team Hong Sun Hee<p>
 @version      1.0.0<p>
 @Comment    Code Search<p>
!--%>

<%-- 개발자 정의 모듈 Import 부분 --%>
<%@ page import="java.util.*"%>
<% String WISEHUB_PROCESS_ID="PR_T04_3";%>
<%
	String code     = JSPUtil.nullToEmpty(request.getParameter("code"));	//CODE ID
	String function = JSPUtil.nullToEmpty(request.getParameter("function"));

	if (function == null) function = "";

	//N : Null Return되는 값없이 조회만 할 경우
	//D : 기본적으로 제공하는 Function Name을 이용
	//"function name" : User가 정한 Function Name으로 연결한다.

	String width = JSPUtil.nullToEmpty(request.getParameter("width"));	 //Table Width

	width = String.valueOf(Integer.parseInt(width)-40);
 	//String[] desc = JSPUtil.koForArray(request.getParameterValues("desc"));
 	String[] desc = request.getParameterValues("desc");

 	for (int i = 0; i<desc.length; i++)  {
		if (desc[i] == null) desc[i] = "";
	}

	if (desc[0].length() == 0){
		desc[0] = "코드";
	}
	else{
		//desc[0] =  new String(desc[0].getBytes("8859_1"), "euc-kr");
		desc[0] = URLDecoder.decode(desc[0]);
	}
	
	if (desc[1].length() == 0){
		desc[1] = "설명";
	}
	else{
		//sdesc[1] =  new String(desc[1].getBytes("euc-kr"), "euc-kr");
		desc[1] = URLDecoder.decode(desc[1]);
	}

	Object[] obj = {code};
	String nickName = "p6032";
	String conType = "CONNECTION";

	String methodName = "";

	SepoaRemote wr_title = null;
	SepoaRemote wr_column = null;

	SepoaOut title = null;
	SepoaOut column = null;

	//헤더정보조회
	methodName = "getCodeMaster";
	try {
		wr_title = new SepoaRemote(nickName, conType,info);
		title = wr_title.lookup(methodName, obj);
		Logger.debug.println(info.getSession("ID"),"message = " + title.message);
	 	Logger.debug.println(info.getSession("ID"),"status = " + title.status);		
	} catch(Exception e) {
		
		Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
		Logger.debug.println(info.getSession("ID"),"message = " + title.message);
		Logger.debug.println(info.getSession("ID"),"status = " + title.status);
	} finally {
		wr_title.Release();
	}

	//컬럼정보조회
	methodName = "getCodeColumn";
	try {
		wr_column = new SepoaRemote(nickName, conType, info);
		column = wr_column.lookup(methodName, obj);
	} catch(Exception e) {
		
		Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
	} finally {
		wr_column.Release();
	}
%>
<html>
<head>
<title>Code Search</title>
<script language="javascript">
<%-- --%>
    function Search() {
    	var frm = document.form
	    code=frm.elements[frm.elements.length - 2].value;
        des=frm.elements[frm.elements.length - 1].value;
        <%--//msg ==> 한가지 이상의 조회 조건을 입력하세요.--%>
        if(code == "" && des == "")	{
		  	alert( "한가지 이상의 조회 조건을 입력하세요." );
		  	return;
		} else if(code.length > 0 || des.length > 0 ) {
			document.form.method = "POST";
			document.form.target = "center";
			<%--//alert("parent.center.document.location.href==="+parent.center.document.location.href);--%>
			document.form.action = "cod_sp_lis2.jsp";
			document.form.submit();

			//code=SP0157&dssss=D&width=540&flag=Y&values=100&values=CGV&values=&values=&desc=&desc=
		}
	}

	function entKeyDown() {
		if(event.keyCode==13) {
			window.focus();   <%--// Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..--%>
			Search();
		}
	}
	
	function setFocus(){
		try{
			var textValues = document.getElementsByName("values");
			if(textValues == null){
				return;
			}
		
			if(textValues.length == null){
				return;
			}
		
			document.form.values[textValues.length-1].focus();
		}catch(e){
			
		}
	}
<%
	String  masterDescription   ="" ;

	if(title.status == 1) { // 성공적으로 조회
		SepoaFormater wf = new SepoaFormater(title.result[0]);

		for(int i=0; i<wf.getRowCount(); i++) {
			masterDescription  = wf.getValue(i,2);
			masterDescription += "(" + wf.getValue(i,1) + ")";
		}// for
	}// if
%>
<%--//--%>
</script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP
<%@ include file="/include/sepoa_grid_common.jsp"%>
--%>
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

function KeyFunction(temp) {
	if(temp == "Enter") {
		if(event.keyCode == 13) {
			Search();
		}
	}
}

</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onkeydown='entKeyDown()' onload="setFocus();">


<!--내용시작-->

<table width="96%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
		&nbsp;<%=masterDescription%>
	</td>
</tr>
</table> 

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

<form name="form" >
<%
	String[] values = JSPUtil.koForArray(request.getParameterValues("values"));
	String flag     = JSPUtil.nullToEmpty(request.getParameter("flag")); //POPUP 조회시, 코드/Desc로 조회할 코드값이 있을 경우 "Y" 없을 경우 "N"
	if (values != null)  {
		for (int i = 0; i<values.length; i++)  {
			if (values[i] == null) values[i] = "";
			if (values[i].length() != 0)  {
%>
				<input type="hidden" name="values" value="<%=values[i]%>" size="20" class="inputsubmit">
<%
			}//if
		}//for
	}//if
%>

	<input type="hidden" name="width" value="<%=width%>" size="20" class="inputsubmit">
<%
	if (flag.equals("Y"))  {		//파라미터값이 있을경우에만 조회조건을 넣는다.
%> 
	<tr>
      <td width="25%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <%=desc[0]%></td>
      <td class="data_td" width="25%"><input type="text" name="values" style="width:95%;ime-mode:inactive;" class="inputsubmit" onkeydown="KeyFunction('Enter')"></td>
      <td class="title_td" width="25%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <%=desc[1]%></td>
      <td class="data_td" width="25%"><input type="text" name="values" style="width:95%" class="inputsubmit" style="ime-mode:active" onkeydown="KeyFunction('Enter')"></td>
    </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		


<!--   	
  <script language="javascript">rdtable_top()</script>
<table width="<%=width%>" border="0" cellspacing="0" cellpadding="0"> 
      <tr>
      <td height="4" colspan="4"></td>
    </tr>
    <tr>
      <td class="cell4_title" width="15%"><%=desc[0]%></td>
      <td class="cell4_data" width="35%">
        <input type="text" name="values" size="20" class="inputsubmit">
      </td>
      <td class="cell4_title" width="15%"><%=desc[1]%></td>
      <td class="cell4_data" width="35%">
        <input type="text" name="values" size="20" class="inputsubmit" >
      </td>
    </tr>
  </table> 
  <script language="javascript">rdtable_bot()</script> 
-->  
<TABLE width="96%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<td><script language="javascript">btn("javascript:Search()","조 회")</script></td>
		</TR>
		</TABLE>
</TR>
</TABLE>
<% 
	}
%>

<table width="96%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
<%
	SepoaFormater wf = new SepoaFormater(column.result[0]);
	String tmp = wf.getValue("TEXT3",0);

//Width = 540, Width =  800으로 Fix해서 처리한다.

	SepoaStringTokenizer st_column = new SepoaStringTokenizer(tmp,"#");
	int st_count = st_column.countTokens();
	if (st_count != 0) {
		int td_width = Integer.parseInt(width) / st_count;
		for(int j = 0; j<st_count; j++)  {
			String col = st_column.nextToken();
			if( j== 0 )	{
%>
				<td width="<%=td_width%>" align="center" class="c_title_1_p_c"><%= col%></td>
<%
			} else {			
%>			
      			<td align="center" width="<%=td_width%>" class="c_title_1_p_c"><%= col%></td>
<%
			}			
		}//for
	} else {
%>
      <td class="c_title_1_p_c">
        <div align="center"><B>코드</B></div>
      </td>
      <td class="c_title_1_p_c">
        <div align="center">설명1</div>
      </td>
      <td class="c_title_1_p_c">
        <div align="center">설명2</div>
      </td>
<%
	}
%>
</tr>
</table> 
  <input type="hidden" name="code" value="<%=code%>">
  <input type="hidden" name="function" value="<%=function%>" >
  </form>
<%--
<s:header>
</s:header>
<s:grid screen_id="PR_T04_3" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
 --%>
</body>
</html>


