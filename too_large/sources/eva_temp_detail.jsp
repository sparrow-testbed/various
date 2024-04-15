<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_018");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_018";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<%
	int checkVal = 0;
	int wf_count = 0;
	
	String ret = null;
	String title = "";
	String readOnly = "";
	String disabled = "";
	String type_disabled = "";
	int template_type = 0;
	
	SepoaFormater wf = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String mode               = JSPUtil.nullToEmpty(request.getParameter("mode"));
	String e_template_refitem = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	
	String nickName= "SR_018";
	String conType = "CONNECTION";
	String MethodName = "";
	Object[] obj = { };
	
	if(mode.equals("insert")) {	
		MethodName = "getEvaTempFactorList";
		title = "평가 신규템플릿 추가";
	}else if(mode.equals("update") || mode.equals("view")) {
		MethodName = "getTempDetail";
		obj = new Object[1];
		obj[0] = e_template_refitem;
	}
	
	try {
		//수정할수 있는지 체크
		if(mode.equals("update")) {
			MethodName = "chkUpdateEvaTemp";
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
			ret = value.result[0];
			wf =  new SepoaFormater(ret);
			checkVal = wf.getRowCount();
			MethodName = "getEvaTemp";
			title = "평가 템플릿 수정";
		}
		//항목내용불러오기..
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
		ret = value.result[0];
		wf =  new SepoaFormater(ret);
		
		if (wf != null) {
			wf_count = wf.getRowCount();
		}
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
	
	if(checkVal > 0) {
		mode = "view";
	}
	
	if(mode.equals("view")) {
		readOnly = "readonly";
		disabled = "disabled";
		title = "평가 템플릿 조회";
	}
	
	String evaTempName = "";
	if((mode.equals("update") || mode.equals("view")) && wf != null && wf_count > 0) {
		type_disabled = "disabled";
		evaTempName = wf.getValue(0, 9);
		template_type = Integer.parseInt(wf.getValue(0, 12));
	}
	
	String ret1 = null;
	SepoaFormater wf1 = null;
	/*
	nickName= "p0060";
	conType = "CONNECTION";
	MethodName = "getCodeName";
	Object[] obj1 = { "M125" };
	
	try {
		ws = new WiseRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj1);
		ret1 = value.result[0];
		wf1 =  new WiseFormater(ret1);
		
	}catch(WiseServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    e.printStackTrace();
	}finally{
		try{
			ws.Release();
		}catch(Exception e){}
	}
	
	template_type = 1; //�쇰� Fixed
	*/
	String LB_TEMPLATE_TYPE = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M924", String.valueOf(template_type));
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" src="../../global/common.js"></script>
<script language="javascript" src="../../global/vmmenu.js"></script>
<script language="javascript" src="../../jscomm/common.js"></script>
<script language="javascript" src="../../jscomm/menu.js"></script>

<script language="javascript">
<!--
	function addEvaTemp() {
		<%if(wf == null || wf_count == 0) {%>
		alert('등록할 평가항목이 없습니다.\n평가 항목부터 생성해주세요.');
		return;
		<%}%>
		var obj = document.form1;
		
		var factor_param = "";
		var weight_param = "";
		var qnt_param = "";
		
		var tempChk;
		var weightChk = 0;
		
		var typeChk = false;
		
		if(obj.evaTempName.value == "") {
			alert("평가 템플릿명을 입력해 주십시요.");
			obj.evaTempName.focus();
			return;
		}
	 
		if(obj.factor_chk.length > 1) {
			for(var i=0; i<obj.factor_chk.length;i++){
				if(obj.factor_chk[i].checked){
					if(obj.weight[i].value == ""){
						alert("평가항목 가중치를 입력해 주십시요.");
						obj.weight[i].focus();
						return;
					}else{		
						tempChk = true;
						weightChk = weightChk + parseFloat(obj.weight[i].value);
						factor_param = factor_param + "," + obj.factor_num[i].value;
						weight_param = weight_param + "," + obj.weight[i].value;
					}
				}
			}
			factor_param = factor_param.substring(1);
			weight_param = weight_param.substring(1);
			
		}else{
			if(obj.factor_chk.checked){
				tempChk = true;
				weightChk = parseInt(obj.weight.value);
				factor_param = obj.factor_num.value;
				weight_param = obj.weight.value;
			}
		}
		
		
		if(!tempChk) {
			alert("템플릿에 저장될 항목을 체크해주세요.");
			return;
		}
		/*
		if(weightChk > 100) {
			alert("媛��移�� 珥����100�������������.");
			return;
		}else if(weightChk < 100) {
			alert("媛��移�� 珥����100�쇰� 留���댁＜�몄�.");
			return;
		}
		*/
		obj.factor_param.value = factor_param;
		obj.weight_param.value = weight_param;
		
		obj.mode.value = "insert";
		obj.action="eva_template_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();

	}
	<%if(mode.equals("update")) {%>
	function updateEvaTemp() {
		var obj = document.form1;
		
		var factor_param = "";
		var weight_param = "";
		var weightChk = 0;
		
		if(obj.evaTempName.value == "") {
			alert("평가 템플릿명을 입력해 주십시요.");
			obj.evaTempName.focus();
			return;
		}
				
		if(obj.factor_num.length > 1){
			for(var i = 0; i < obj.factor_num.length; i++){
				if(obj.weight[i].value == ""){
					alert("템플릿 가중치를 입력해 주십시요.");
					obj.weight[i].focus();
					return;
				}else{		
					
					weightChk = weightChk + parseInt(obj.weight[i].value);
					factor_param = factor_param + "," + obj.factor_num[i].value;
					weight_param = weight_param + "," + obj.weight[i].value;
				}
				
			}
			factor_param = factor_param.substring(1);
			weight_param = weight_param.substring(1);
		}else{
			if(obj.weight.value == ""){
				alert("일반 평가항목 가중치를 입력해 주십시요.");
				obj.weight[i].focus();
				return;
			}else{		
				weightChk = obj.weight.value;
				factor_param = obj.factor_num.value;
				weight_param = obj.weight.value;
			}
		}
		
		
		//////////////////////////////////////////////////////////////////////////////
		/*
		if(weightChk > 100) {
			alert("媛��移�� 珥����100�������������.");
			return;
		}else if(weightChk < 100) {
			alert("媛��移�� 珥����100�쇰� 留���댁＜�몄�.");
			return;
		}
		*/
		obj.e_template_refitem.value = <%=e_template_refitem%>;	
		
		obj.factor_param.value = factor_param;
		obj.weight_param.value = weight_param;
		obj.mode.value = "update";
		obj.action="eva_template_ins.jsp";
		obj.target="hiddenframe";
		obj.submit();
	}
	<%}%>
	
	function goRef(){
		opener.onRefresh(); 
		window.close();
	}
	
	function init() {
		
		alert('이미 사용된 템플릿으로 수정할수 없습니다.');
		return;
	}
	
	<%if(mode.equals("insert")) {%>
	function show_layer(flag) {
		
		if(flag == "1") {	//공동
			document.getElementById('layer1').style.visibility = "visible";
			document.getElementById('layer2').style.visibility = "hidden";
			var obj = document.form1;
			for(var i = 0; i < obj.factor_num.length; i++){
				obj.factor_chk[i].checked = false;
				obj.weight[i].value = "";
			}
					
		}else if(flag == "2"){	//일반
			document.getElementById('layer1').style.visibility = "hidden";
			document.getElementById('layer2').style.visibility = "visible";
			var obj = document.form1;
			for(var i=0; i < obj.factor_num.length; i++){
				obj.factor_chk[i].checked = false;
				obj.weight[i].value = "";
			}
		}
		
	}
	<%}%>
			
-->
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
        getQuery();
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
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" <%if(checkVal > 0){%>onload="javascript:init();"<%}%>>



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
	<input type="hidden" name="e_template_refitem">
	<input type="hidden" name="factor_param" >
	<input type="hidden" name="mode" >
	<input type="hidden" name="weight_param" >
	

	<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<tr>						
		<td width="20%" class="c_title_1">
			<div>템플릿명</div>
		</td>
		<td width="80%" class="c_data_1">
<%
		if(mode.equals("view")) {
%>
			<%=evaTempName%>
			<input type="hidden" class="text" style="width:95%" value="<%=evaTempName%>" name="evaTempName">
<%
		} else {
%>			
			<input type="text" class="text" style="width:95%" value="<%=evaTempName%>" name="evaTempName"  maxlength="50" <%=readOnly%>>
<%
		}
%>
		</td>						
	</tr>
	<tr>						
		<td width="20%" class="c_title_1">
			<div>템플릿구분</div>
		</td>
		<td width="80%" class="c_data_1">
			<select name="template_type" class="inputsubmit" <%=disabled%>>
          		<%=LB_TEMPLATE_TYPE%>
        	</select>
		</td>						
	</tr>
	</table>

	<table border=0 cellpadding=1 cellspacing=0 width="99%">
	<tr align="right">
		<td>
			<TABLE cellpadding="0">
			<TR>
<%
		if(mode.equals("update")) {
%>
				<td><script language="javascript">btn("javascript:updateEvaTemp()","수정")</script></td>
<%
		} else if(!mode.equals("view")){
%>
				<td><script language="javascript">btn("javascript:addEvaTemp()","등록")</script></td>
<%
		}
%>
				<td><script language="javascript">btn("javascript:self.close()","닫기")</script></td>
			</TR>
			</TABLE>
		</td>
	</tr>
	</table>

	
	<TABLE width="98%" border="1" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<TR> 
		<TD width="4%" class="c_title_1_p_c" align="center" ></TD>
		<TD width="7%" class="c_title_1_p_c" align="center" >평가분류</TD>
		<TD width="4%" class="c_title_1_p_c" align="center" >구분</TD>
		<TD width="18%" class="c_title_1_p_c" align="center" >항목내용</TD>
		<TD width="12%"  class="c_title_1_p_c" align="center" >1</TD>
		<TD width="12%"  class="c_title_1_p_c" align="center" >2</TD>
		<TD width="12%"  class="c_title_1_p_c" align="center" >3</TD>
		<TD width="12%"  class="c_title_1_p_c" align="center" >4</TD>
		<TD width="12%"  class="c_title_1_p_c" align="center" >5</TD>
		<TD width="7%" class="c_title_1_p_c" align="center" >가중치</TD>
	</TR>
<%
	int i     = 0;
	int scale = 0;

	for(; i < wf_count; i++) {
		
		try {
			scale = Integer.parseInt(wf.getValue(i, 5));
		} catch (Exception e) {
			scale = 5;
		}
	
		int e_factor_ref = Integer.parseInt(wf.getValue(i, 0));
		String qnt = wf.getValue(i, 6);
		//if(qnt.equals("Y")) {
		//	break;
		//}		
%>
	<TR>
		<TD class="c_data_1_p_c"  align="center"><input type="checkbox" name="factor_chk" <%if(!mode.equals("insert")) {%> disabled <%}%>> </td>
			<input type="hidden" name="factor_num" value="<%=e_factor_ref%>">
		<TD class="c_data_1_p_c" alt="���遺��" align="center"><%=wf.getValue(i, 7)%></TD>
		<TD class="c_data_1_p_c" alt="���援щ�" align="center"><%=wf.getValue(i, 13)%></TD>
		<TD class="c_data_1_p_c" alt="��ぉ�댁�" align="left"><%=wf.getValue(i, 1)%></TD>
<%
		for(int j=0; j < 5; j++){
			String temp_value = scale<=j ? "-" : wf.getValue(i + j, 3);
			String temp_score = scale<=j ? "" : "<br>[배점:"+wf.getValue(i + j, 4) + "]";
			temp_value=temp_value.equals(" ") || temp_value.equals("") ? "-" : temp_value;
			temp_value = temp_value.concat(temp_score);
%>	
		<TD class="c_data_1_p_c"  align="center"><%=temp_value%></TD>
<%
		}

		i = i + (scale - 1);
		
		if(mode.equals("update") || mode.equals("view")) {
%>
		<TD class="c_data_1_p_c"  align="center"><%=wf.getValue(i, 10)%>%</TD>
<%
		} else {
%>
		<TD class="c_data_1_p_c"  align="center"><input type="text" name="weight" class="text" style="width:40" <%=readOnly%>>%</TD>
<%
		}
%>
	</TR>
<%
	}
%>
      				
<%
	if(mode.equals("insert")) {
%>
	</TABLE>
	
	<div id="layer1" style="position:absolute; visibility:hidden;" align="center">
	<TABLE width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<%
 	}

	//정량평가항목
	for(; i < wf_count; i++) {
		scale = 5;
		int e_factor_ref = Integer.parseInt(wf.getValue(i, 0));
%>
	<TR>    				 	
		<TD class="c_data_1_p_c" align="center"> 
			<input type="checkbox" name="factor_chk" <%if(!mode.equals("insert")) {%> disabled <%}%>></td>				       
			<input type="hidden" name="factor_num" value="<%=e_factor_ref%>">				         
		<TD class="c_data_1_p_c" align="left"><%=wf.getValue(i, 1)%></TD>
		<TD class="c_data_1_p_c" align="center"><%=wf.getValue(i, 7)%></TD>
<%
		for(int j = 0; j < scale; j++){
%>	
		<TD class="cell1_data"  width="80" align="center">-</TD>
<%
		}
%>

<%
		if(mode.equals("update") || mode.equals("view")) {
%>
		<TD class="c_data_1_p_c" align="center">
			<input type="text"  name="weight" value="<%=wf.getValue(i, 10)%>" class="text" style="width:40" <%=readOnly%>>%
		</TD>
<%
		} else {
%>
		<TD class="c_data_1_p_c" align="center"><input type="text" name="weight" class="text" style="width:40" <%=readOnly%>>%
		</TD>
<%
		}
%>
	</TR>
<%
	}
%> 
	</TABLE>
	
	</div>

<%
	if(wf_count == 0) {
%>
		<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
		<tr>
			<td align="center" class="c_data_1_p_c">평가항목을 먼저 생성하십시요.</td>
		</tr>
		</table>
<%
	}
%>

<iframe name="hiddenframe" src="eva_template_ins.jsp" width="0" height="0"></iframe>
</form>	


</BODY> 

</HTML>


