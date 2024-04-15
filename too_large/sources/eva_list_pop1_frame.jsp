<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_034_01");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_034_01";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="SR_034_01";%>

<%

	int checkVal = 0;
	String ret = null;
	String title = "";
	String factor_type = "";
	
	SepoaFormater wf = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String dept = JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
	
	String eval_refitem        = JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
	String e_template_refitem  = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	String template_type       = JSPUtil.nullToEmpty(request.getParameter("template_type"));
	String eval_valuer_refitem = JSPUtil.nullToEmpty(request.getParameter("eval_valuer_refitem"));
	String eval_item_refitem   = JSPUtil.nullToEmpty(request.getParameter("eval_item_refitem"));

/*
	if(template_type.equals("2")) 
	{
		if(dept.equals("510007")) {	//구매
			factor_type = "1";
		}else if(dept.equals("510008")) {	//제작
			factor_type = "2";
		}
	}
*/
	String nickName= "p0080";
	String conType = "CONNECTION";
	String MethodName = "getEvalTempFactorList";
	Object[] obj = { e_template_refitem, template_type, factor_type };
	
	alert("e_template_refitem="+e_template_refitem);
	
	try {
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
		ret = value.result[0];
		wf =  new SepoaFormater(ret);
	}catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	}finally{
		try{
			ws.Release();
		}catch(Exception e){}
	}
%>

<html>
<head>
	<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	 <script language="javascript" src="../../jscomm/crypto.js"></script>
	<script language="javascript" src="../../jscomm/common.js"></script>
	<script language="javascript" src="../../jscomm/menu.js"></script>
	
	<script language="javascript">
	//<!--
 	function setData()
 	{
 		f = document.form1;
 		var e_factor_refitem = "";
 		var answered_seq = "";
 		var answered_score = "";
 		var answered_num = "";
 		var weight = "";
 		var max_score = "";
 		
 		var i = 0;
 		if(f.answered_seq.length > 1) 
 		{
	 		for(i=0; i < f.answered_seq.length; i++) 
	 		{
	 			if(f.answered_seq[i].value == '') 
	 			{
	 				alert('모든항목을 빠짐없이 체크해주세요.');
	 				return;
	 			}else{
	 				answered_seq = answered_seq + "," + f.answered_seq[i].value;		//선택항목 SEQ
	 				weight = weight + "," + f.weight[i].value;
	 				e_factor_refitem = e_factor_refitem + "," + f.e_factor_refitem[i].value;
	 				answered_score = answered_score + "," + f.answered_score[i].value;	//선택항목 점수
	 				answered_num = answered_num + "," + f.answered_num[i].value;		//선택항목 고유번호 
	 				max_score = max_score + "," + f.item_maxscore[i].value;					//평가항목 최고점수  
	 			}
	 		}
	 		answered_seq 		= answered_seq.substring(1);		//선택항목 SEQ
 			weight 				= weight.substring(1);				//가중치
 			e_factor_refitem 	= e_factor_refitem.substring(1);
 			answered_score 		= answered_score.substring(1);		//선택항목 점수
 			answered_num 		= answered_num.substring(1);		//선택항목 고유번호
 			max_score 			= max_score.substring(1);			//평가항목 최고점수  
	 	}else{
	 		answered_seq 	= f.answered_seq.value;
	 		weight 			= f.weight.value;
	 		e_factor_refitem = f.e_factor_refitem.value;
	 		answered_score 	= f.answered_score.value;
	 		answered_num 	= f.answered_num.value;
	 		max_score 		= f.item_maxscore.value;
	 	}
	 
 		var value = confirm('평가점수를 등록하시겠습니까?');
 		if(value) 
 		{
 			var note = escape(parent.getNote());
 			location.href="eva_list_pop1_ins.jsp?answered_seq=" + answered_seq +
 									    "&e_factor_refitem=" + e_factor_refitem +
 									    "&weight=" + weight +
 									    "&answered_score=" + answered_score + 
 									    "&answered_num=" + answered_num + 
 									    "&max_score=" + max_score + 
 									    "&eval_valuer_refitem=<%=eval_valuer_refitem%>" +
 									    "&eval_item_refitem=<%=eval_item_refitem%>" +
 									    "&eval_refitem=<%=eval_refitem%>" +
 									    "&note=" + note; //특수문자 이유로 항상 맨 밑에 위치 시킬 것.
 									    
 		}
 		
	}
	function checkData(cnt, value, itemScore, item_num) 
	{
		f = document.form1;
		if(f.answered_seq.length > 1) 
		{
			f.answered_seq[cnt].value = value;
			f.answered_score[cnt].value = itemScore;
			f.answered_num[cnt].value = item_num;
		}else{
			f.answered_seq.value = value;
			f.answered_score.value = itemScore;
			f.answered_num.value = item_num;
		}
	}
	
	function onClose() 
	{
		parent.onClose();
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
<body onload="" bgcolor="" text="#000000" leftmargin="0" topmargin="0">

<s:header>
<!--내용시작-->
<form name="form1">

<table width="100%" border="0" cellpadding="1" cellspacing="1">
<%
	int count = 0;
	for(int i=0; i < wf.getRowCount(); i++) {
		int scale = Integer.parseInt(wf.getValue(i, 2));
		String factor_num = wf.getValue(i, 3);
%>
<tr height=25>
	<td colspan="7" class="c_title_1">
		<div align="left"><strong><%=wf.getValue(i, 1)%></strong></div>
		<input type="hidden" name="answered_seq"><!--선택된 값이 담긴다.-->
		<input type="hidden" name="answered_score"><!--선택된 값이 담긴다.-->
		<input type="hidden" name="answered_num"><!--선택된 값이 담긴다.-->
		<input type="hidden" name="weight" value="<%=wf.getValue(i, 6)%>" >
		<input type="hidden" name="e_factor_refitem" value="<%=factor_num%>" >
	</td>
</tr>
<tr height=25 >
<%
		int maxScore = 0;
		int itemScore = 0;
		for(int j=0; j < scale; j++){
			itemScore = Integer.parseInt(wf.getValue(i, 7));
			if(itemScore > maxScore) maxScore = itemScore;
%>
		<td class="c_data_1">
			<input type="radio" name="factor_<%=factor_num%>"  style="border:'0';" onClick="javascript:checkData(<%=count%>, <%=wf.getValue(i+j, 5)%>, <%=wf.getValue(i+j, 7)%>, <%=wf.getValue(i+j, 8)%>);">
			<%=wf.getValue(i+j, 4)%>&nbsp;
		</td>
<%	
		}
	
		i = i + (scale-1);
%>
<input type="hidden" name="item_maxscore" value="<%=maxScore%>">
</tr>
<%
		count++;
	}
%>
</table>
				
</form>	
<iframe name="hiddenframe" src="" width="0" height="0"></iframe>

</s:header>
<s:grid screen_id="SR_034_01" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


