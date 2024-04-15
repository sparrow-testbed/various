<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_008";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<%

	int checkVal = 0;
	String title = "";
	String readOnly = "";	
	String ScreeningItemName = null;
	
	String ret = null;
	SepoaFormater wf = null;
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String mode = JSPUtil.CheckInjection(request.getParameter("mode"))==null?"":JSPUtil.CheckInjection(request.getParameter("mode"));
	String s_factor_refitem = JSPUtil.CheckInjection(request.getParameter("s_factor_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("s_factor_refitem"));
	
	if(mode.equals("update") || mode.equals("view")){
	
		String nickName= "SR_008";
		String conType = "CONNECTION";
		String MethodName = "chkUpdateItem";
		Object[] obj = { s_factor_refitem };
		
		try {
		
			if(mode.equals("update")) {
				ws = new SepoaRemote(nickName, conType, info);
				value = ws.lookup(MethodName,obj);
				ret = value.result[0];
				wf =  new SepoaFormater(ret);
				checkVal = wf.getRowCount();
				title = "업체등록 평가 항목 수정";
				
			}
			
			MethodName = "getScrDetail";
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
		if(checkVal > 0){
			mode = "view";	
		}		
		if(mode.equals("view")) {
			readOnly = "readonly";
			title = "업체등록 평가 항목 조회";
		}
		
		if((mode.equals("update") || mode.equals("view")) && wf != null && wf.getRowCount() > 0) {
			ScreeningItemName = wf.getValue("factor_name", 0);
		}
	}else{
		title = "업체등록 평가 신규항목 추가";
	}
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
	
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
	
	<script language="javascript" src="../../global/common.js"></script>
	<script language="javascript" src="../../global/vmmenu.js"></script>
	<script language="javascript" src="../../jscomm/common.js"></script>
	<script language="javascript" src="../../jscomm/menu.js"></script>
	<script language="javascript">
	
	
	function addItem() {
		var obj = document.form1;
		var objchk = obj.isValid ;
		
		var scale = 0;
		var itemChk;
		var recommendCnt = -1 ;
		var selectedCnt  = 0 ;
		
		if(obj.ScreeningItemName.value == "") {
			alert("업체등록 평가 항목명을 입력해 주십시요.");
			obj.ScreeningItemName.focus();
			return;
		}
		
		for(var i=0; i<obj.itemName.length;i++)
		{
<%--
			if(Trim(obj.itemName[i].value) != ""){
				itemChk = true;
				scale++;
			}
--%>
			if(obj.itemName[i].value != ""){
				itemChk = true;
				scale++;
			}else{
				if(obj.itemScore[i].value != ""){
					alert("항목점수를 입력하여 주십시오.");
					return ;
				}
			}

// 			if(obj.isRecommand[i].checked){
// 				obj.recommendNum.value = i + 1;
// 				recommendCnt = i;	
// 			}
		}
		
		if(!itemChk) {
			alert("선택항목 내용을 입력하여 주십시요.");
			return;
		}
// 		if(recommendCnt < 0){
// 			alert("선택요구 항목을 선택하여 주십시요.");
// 			return;
// 		}
// 		if(obj.itemName[recommendCnt].value == "") {
// 			alert("내용이 존재하는 선택항목에만 요구항목이 지정 가능 합니다.");
// 			return;
// 		}	
		obj.mode.value = "insert";
		obj.scale.value = scale;
		obj.action="scr_item_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();
		
		
	}

	<%if(mode.equals("update")) {%>
	function updateItem() {
		var obj = document.form1;
		var objchk = obj.isValid ;
		
		var scale = 0;
		var itemChk;
		var recommendCnt = -1 ;
		var selectedCnt  = 0 ;

		if(obj.ScreeningItemName.value == "") {
			alert("업체등록 평가 항목명을 입력해 주십시요.");
			obj.ScreeningItemName.focus();
			return;
		}

	if (obj.itemName.length == null) {
		if( obj.itemName.value != ""){
			itemChk = true;
			scale++;
		}else{
			if(obj.itemScore[i].value != ""){
				alert("항목점수를 입력하여 주십시오.");
				return ;
			}
		}

// 		if(obj.isRecommand.checked){
// 			obj.recommendNum.value = 1;
// 			recommendCnt = 1;	
// 		}
	} else {
		 for(var i = 0; i < obj.itemName.length; i++){
<%--

			if(Trim(obj.itemName[i].value) != ""){
				itemChk = true;
				scale++;
			}
--%>
			if(obj.itemName[i].value != ""){
				itemChk = true;
				scale++;
			}else{
				if(obj.itemScore[i].value != ""){
					alert("항목점수를 입력하여 주십시오.");
					return ;
				}
			}
			
// 			if(obj.isRecommand[i].checked){
// 				obj.recommendNum.value = i + 1;
// 				recommendCnt = i;	
// 			}
		}	
	}

// 		if(!itemChk) {
// 			alert("선택항목 내용을 입력하여 주십시요.");
// 			return;
// 		}

// 		if(recommendCnt < 0){
// 			alert("선택요구 항목을 선택하여 주십시요.");
// 			return;
// 		}

	if (obj.itemName.length == null) {
		if(obj.itemName.value == "") {
			alert("내용이 존재하는 선택항목에만 요구항목이 지정 가능 합니다.");
			return;
		}
	} 
// 	else {
// 		if(obj.itemName[recommendCnt].value == "") {
// 			alert("내용이 존재하는 선택항목에만 요구항목이 지정 가능 합니다.");
// 			return;
// 		}
// 	}

		obj.s_factor_refitem.value = <%=s_factor_refitem%>;	
		obj.mode.value  = "update";
		obj.scale.value = scale;
		obj.action="scr_item_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();
	}
	<%}%>
	
	function goRef(){
		opener.onRefresh(); 
		window.close();
	}
	
	function init() {
		alert('이미 사용된 항목으로 수정할수 없습니다.');
		return;
	}
    function onOnlyNumber(obj)
    {    	
     	for (var i = 0; i < obj.value.length ; i++){
    	  	chr = obj.value.substr(i,1);  
    	  	chr = escape(chr);
    	  	key_eg = chr.charAt(1);
    	  	//if (key_eg == ’u’){
    	  	if (key_eg == 'u'){
    	   		key_num = chr.substr(i,(chr.length-1));   
    	   		if((key_num < "AC00") || (key_num > "D7A3")) { 
    	    		event.returnValue = false;
    	   		}    
    	  	}
    	 }
    	 //backspace, tab, delete, -, numpad key 예외..
     	if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 46 || event.keyCode == 189 || (event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 103) ) {
     	} else {
      		event.returnValue = false;
     	}
    }
	
	</script>

	

              
                


</head>
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" <%if(checkVal > 0){%>onload="javascript:init();"<%}%>>


<!--내용시작-->

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle">
		&nbsp;<%=title%>
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>


<form name="form1" >
	<input type="hidden" id="s_factor_refitem" name="s_factor_refitem">
	<input type="hidden" name="recommendNum" >
	<input type="hidden" name="scale" >
	<input type="hidden" name="mode" >

<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<%--					
<tr height=15>
	<td width=100 class="c_title_1">
		<div align="left">항목타입</div>
	</td>
	<td width=120 class="c_data_1">
		<div align="left">Auto Screening 항목</div>
	</td>
</tr>
--%>
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 항목명</div>
	</td>
	<td width=120 class="c_data_1">
		<input type="text" class="inputsubmit" style="width:80%" id= "ScreeningItemName" value="<%=ScreeningItemName%>"	name="ScreeningItemName"  maxlength="50" <%=readOnly%>>

	</td>
</tr>
</table>
	

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
<%
		if(mode.equals("update")) {
%>
	    	<td><script language="javascript">btn("javascript:updateItem()","수 정")</script></td>
<%
		} else if(!mode.equals("view")) {
%>
	    	<td><script language="javascript">btn("javascript:addItem()","등 록")</script></td>
<%
		}
%>
			<td><script language="javascript">btn("javascript:self.close()","닫 기")</script></td>
		</TR>
  		</TABLE>
	</td>
</tr>
</table>

		<table width="98%" border="1" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
		<tr>
			<td  width="10%" align="center"  class="c_title_1_p_c">SEQ</td>
			<td  width="80%" align="center"  class="c_title_1_p_c">선택항목</td>
			<td  width="10%" align="center"  class="c_title_1_p_c">점수</td>
		</tr>			
<%
	if(mode.equals("update") || mode.equals("view")) {
		for(int i=0; i < wf.getRowCount(); i++) {
			int seq = Integer.parseInt(wf.getValue(i, 3));
			//int req_seq = Integer.parseInt(wf.getValue(i, 4));
%>
		<tr>
			<td align="center" class="c_data_1_p_c"><%=seq%></td>
			<td class="c_data_1_p" align="center"><%=wf.getValue(i, 2)%></td>
			<td align="center" class="c_data_1_p_c"><%=wf.getValue(i, 4)%></td>
		</tr>
<%
			}
		} else {
%>
		<tr>
			<td align="center" class="c_data_1_p_c">1</td>
			<td class="c_data_1_p"><input type="text" name="itemName" class="inputsubmit" style="width:95%" value="" maxlength="30"></td>
			<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore"  maxlength="3" style="width:40;IME-MODE:disabled;" onKeyDown="onOnlyNumber(this);" ></td>
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">2</td>
			<td class="c_data_1_p"><input type="text" name="itemName" class="inputsubmit" style="width:95%" value="" maxlength="30"></td>
			<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore"  maxlength="3" style="width:40;IME-MODE:disabled;" onKeyDown="onOnlyNumber(this);" ></td>
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">3</td>
			<td class="c_data_1_p"><input type="text" name="itemName" class="inputsubmit" style="width:95%" value="" maxlength="30"></td>
			<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore"  maxlength="3" style="width:40;IME-MODE:disabled;" onKeyDown="onOnlyNumber(this);" ></td>
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">4</td>
			<td class="c_data_1_p"><input type="text" name="itemName" class="inputsubmit" style="width:95%" value="" maxlength="30"></td>
			<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore"  maxlength="3" style="width:40;IME-MODE:disabled;" onKeyDown="onOnlyNumber(this);" ></td>
		</tr>
		<tr>
			<td align="center" class="c_data_1_p_c">5</td>
			<td class="c_data_1_p"><input type="text" name="itemName" class="inputsubmit" style="width:95%" value="" maxlength="30"></td>
			<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore"  maxlength="3" style="width:40;IME-MODE:disabled;" onKeyDown="onOnlyNumber(this);" ></td>
		</tr>
<%
		}
%>
		</table>

<iframe name="hiddenframe" src="scr_item_ins.jsp" width="0" height="0"></iframe>
</form>



</BODY> 

</HTML>


