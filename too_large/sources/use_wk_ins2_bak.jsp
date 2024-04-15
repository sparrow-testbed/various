<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("p0030");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "p0030";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/s_kr/admin/user/use_wk_ins2.jsp -->
<!--
 Title:        Duplicate Checking
 Description:  
 Copyright:    Copyright (c) 
 Company:      ICOMPIA <p>
 @author       chan-gon, Moon <p>
 @version      1.0
 @Comment      
-->

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID= "p0030"; %>

<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE= "KR"; %>

<!-- JSP import or useBean tags here. -->
<!-- Wisehub FrameWork 공통 모듈 Import 부분(무조건 사용) -->
<%-- <%@ include file="/include/wisehub_common.jsp" %> --%>

<!-- Wisehub 해당 모듈 Import 부분(무조건 사용) -->
<%-- <%@ include file="/include/wisehub_session.jsp"%> --%>

<% 
	String house_code = info.getSession("HOUSE_CODE");
	Logger.debug.println(info.getSession("ID"),request,"message = " + house_code);
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<!-- META TAG 정의  -->
<!-- Wisehub Common Scripts -->
<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<%   		
    		String[] args = new String[2];
	    	args[0] = house_code;
	    	args[1] = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	    	if (args[1].equals(""))
	    		args[1] = JSPUtil.nullToEmpty(request.getParameter("USER_ID"));

	    	Object[] obj = {args};
	    	String nickName= "s6030";
	    	String conType = "CONNECTION";
	    	String MethodName = "getDuplicate";
	        SepoaOut value = null; 
	        SepoaRemote remote = null;
		    String count =  "";

	        try {
				 	remote = new SepoaRemote(nickName, conType, info);
				 	value = remote.lookup(MethodName, obj);
				 	if(value.status == 1)
					{

						//Count값을 가져온다. 
						SepoaFormater wf = new SepoaFormater(value.result[0]);
						count = wf.getValue("COUNT",0);
			   			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
   						Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
			   		}
	        }catch(SepoaServiceException wse) {
			    Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
				Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
	   			Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	        }catch(Exception e) {
	            Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    	}finally{
	    		try{
					remote.Release();
				}catch(Exception e){}
			}
%>							   	

<Script language="javascript">
<!-- 

function Init()
{
   if("<%=value.status%>" == "1")
    {
    	var count = document.form.count.value;
    	 	if(count != 0) 
	    	{
	    		alert("입력하신 ID는 이미 존재합니다.");
	    		parent.checkDulicate('F');
	    	}
	    	else 
	    	{
		    	alert("등록 가능한 ID 입니다.");
		    	parent.checkDulicate('T');
	    	}
    }
    else alert("조회가 실패하였습니다.");
}


//-->
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
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<!--내용시작-->
<form name="form">
<input type="hidden" name="count" value="<%=count%>"> 
</form>
</body>
</html>


