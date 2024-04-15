<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_028");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_028";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>
<%
	
	String eval_refitem = JSPUtil.nullChk(request.getParameter("eval_refitem"));
	String evalname = JSPUtil.nullChk(request.getParameter("evalname"));  
	String interval = JSPUtil.nullChk(request.getParameter("interval"));         		
	String gateflag = JSPUtil.nullChk(request.getParameter("gate"));   
	String closeBtn = JSPUtil.nullChk(request.getParameter("closebtn"));   
	String company_code    = info.getSession("COMPANY_CODE");      		

%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script language="javascript">
<!--
  	
// 	function setHeader() 
// 	{

// 		GridObj.AddHeader("E_TEMPLATE_REFITEM"	,""				,"t_text",100,0,false);
// 		GridObj.AddHeader("template_type"			,""				,"t_text",100,0,false);
// 		GridObj.AddHeader("eval_item_refitem"		,""				,"t_text",100,0,false);
// 		GridObj.AddHeader("eval_valuer_refitem"	,""				,"t_text",100,0,false);
// 		GridObj.AddHeader("HUMAN_NO"				,""				,"t_text",100,0,false);
// 		GridObj.AddHeader("EVAL_REFITEM"			,""				,"t_text",100,0,false);
		


		
// 		//조회된 화면을 View한다.
// 		getQuery();
// 	}

	//Data Query해서 가져오기
	function getQuery() 
	{		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_action_list";
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getEvaList&grid_col_id="+grid_col_id;
		param += dataOutput();
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false);
		
// 		if(opener.doSelect != null)
// 			opener.doSelect();
	}
  	
  	
  	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
  	function JavaCall(msg1,msg2,msg3,msg4,msg5)
  	{
		if(msg1 == "t_imagetext"){
			var eval_valuer_refitem = GD_GetCellValueIndex(GridObj,msg2, 9);
			var complete = GD_GetCellValueIndex(GridObj,msg2, 5);
			var e_template_refitem = GD_GetCellValueIndex(GridObj,msg2, 6);
			var template_type = GD_GetCellValueIndex(GridObj,msg2, 7);
			var eval_item_refitem = GD_GetCellValueIndex(GridObj,msg2, 8);
			var vendor_name = GD_GetCellValueIndex(GridObj,msg2, 2);
			var sg_name = GD_GetCellValueIndex(GridObj,msg2, 3);
			var human_no = GD_GetCellValueIndex(GridObj,msg2, 10);
			var vendor_code = GD_GetCellValueIndex(GridObj,msg2, 1);
			
			if(msg3 == '4'){
				company_code 	= "<%=company_code%>";
				
				if(msg4 == ""){
					alert("개발자가 존재하지 않습니다.");
					return;
				}
				window.open("/s_kr/master/human/hum_bd_con.jsp?popup=Y&mode=human_search&human_no="+human_no+"&vendor_code="+vendor_code+"&company_code="+company_code,"hum_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
	   
			}else if(msg3 == '5'){
			
				if(complete == "미완료") 
				{
					var url = "eva_list_pop1.jsp?e_template_refitem=" + e_template_refitem + 
						  "&template_type=" + template_type +
					      "&eval_valuer_refitem=" + eval_valuer_refitem + 
					      "&eval_item_refitem=" + eval_item_refitem + 
					      "&eval_refitem=<%=eval_refitem%>";
					window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
				}else if(complete = "완료") {
					var url = "eva_pp_lis3.jsp?e_template_refitem=" + e_template_refitem + 
						  "&template_type=" + template_type +
					      "&eval_item_refitem=" + eval_item_refitem + 
					      "&eval_refitem=<%=eval_refitem%>" +
					      "&vendor_name="+ vendor_name +
					      "&sg_name="+ sg_name;
					window.open(url ,"windowopenSS","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
				}
			}
		}
	}
  	
	function onRefresh() {
		setGridDraw();
	}
	
//-->

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
	var slip_status = GridObj.cells(rowId, GridObj.getColIndexById("complete")).getValue();
	if(header_name == "complete") {
		
		//미완료
		if(slip_status == "미완료") { 
			var url = "<%=POASRM_CONTEXT_NAME%>/procure/eva_write_detail.jsp";
			var param = "";
			param += "?popup_flag_header=true";
			param += "&e_template_refitem="+SepoaGridGetCellValueId(GridObj, rowId, "e_template_refitem");
			param += "&template_type="+SepoaGridGetCellValueId(GridObj, rowId, "template_type");
			param += "&eval_valuer_refitem="+SepoaGridGetCellValueId(GridObj, rowId, "eval_valuer_refitem");
			param += "&eval_item_refitem="+SepoaGridGetCellValueId(GridObj, rowId, "eval_item_refitem");
			param += "&eval_refitem="+"<%=eval_refitem%>";
			PopupGeneral(url+param, "eva_write", "", "", "1000", "650");
		} else if(slip_status == "완료") { 
			var url = "<%=POASRM_CONTEXT_NAME%>/procure/eva_result_detail.jsp";
			var param = "";
			param += "?popup_flag_header=true";
			param += "&e_template_refitem="+SepoaGridGetCellValueId(GridObj, rowId, "e_template_refitem");
			param += "&template_type="+SepoaGridGetCellValueId(GridObj, rowId, "template_type");
			param += "&eval_item_refitem="+SepoaGridGetCellValueId(GridObj, rowId, "eval_item_refitem");
			param += "&eval_refitem="+"<%=eval_refitem%>";
			param += "&vendor_name="+SepoaGridGetCellValueId(GridObj, rowId, "vendor_name");
			param += "&sg_name="+SepoaGridGetCellValueId(GridObj, rowId, "sg_name");
			param += "&eval_name="+"<%=evalname%>";
			PopupGeneral(url+param, "eva_detail", "", "", "1000", "650");
		}
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>

</head>
<body onload="setGridDraw();getQuery();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<form name="form1" method="post">
<input type="hidden" name="eval_refitem" id="eval_refitem" value="<%=eval_refitem%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
	<% if("eproinv".equals(gateflag)){
		out.println("수행평가");
	 }else{%>
		<%@ include file="/include/sepoa_milestone.jsp" %>
	<%}%>
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가명</div>
	</td>
	<td width="35%" class="c_data_1">
		<input type=text size="40" class="inputsubmit" value='<%=evalname%>' name="evalname" id="evalname" readonly >
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가기간</div>
	</td>
	<td width="35%" class="c_data_1">	
		<input name="interval" id="interval" type="text" size="25" maxlength="25" class="inputsubmit" value="<%=interval%>" readonly >
	</td>
</tr>
</table>
  	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
    	<tr>
      		<td height="30" align="right">
      		<TABLE cellpadding="0">
      		<%if(closeBtn.equals("Y")){ %>
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
	    	<%}else{ %>
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:window.history.back();","이 전")</script></TD>
	    	  		</TR>
	    	<%} %>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

<iframe name="hiddenframe" src="" width="0" height="0"></iframe>  
</form> 

</s:header>
<s:grid screen_id="SR_028" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html> 
  
 


