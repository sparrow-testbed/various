<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_016");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_016";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<%

	int checkVal = 0;
	String readOnly = "";
	String disabled = "";
	String title = "";
	String evaItemName = "";
	int factor_type = 0;
	String factor_qnt_flag = "";
	String factorDesc = "";
	
	String ret = null;
	SepoaFormater wf = null;
	SepoaOut value = null; 
	SepoaRemote ws = null;
	
	String mode = JSPUtil.nullToEmpty(request.getParameter("mode"));
	String e_factor_refitem = JSPUtil.nullToEmpty(request.getParameter("e_factor_refitem"));
	
	if(mode.equals("update") || mode.equals("view")) {
	
		String nickName= "SR_016";
		String conType = "CONNECTION";
		String MethodName = "chkUpdateEvaItem";
		Object[] obj = { e_factor_refitem };
		
		try {
			//수정할수 있는지 체크
			if(mode.equals("update")) {
				ws = new SepoaRemote(nickName, conType, info);
				value = ws.lookup(MethodName,obj);
				ret = value.result[0];
				wf =  new SepoaFormater(ret);
				checkVal = wf.getRowCount();
				title = "평가항목 수정";
			}
			//항목내용불러오기..
			MethodName = "getEvaDetail";
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
			mode = "view";	//사용된 항목이면 보기모드로 전환
		}
		
		if(mode.equals("view")) {
			readOnly = "readonly";
			disabled = "disabled";
			title = "평가항목 조회";
		}
		
		if(wf != null && wf.getRowCount() > 0) {
			evaItemName = wf.getValue("FACTOR_NAME", 0);
			factor_type = Integer.parseInt(wf.getValue("FACTOR_TYPE", 0));
			factorDesc = wf.getValue(0, 6);
			factor_qnt_flag = wf.getValue(0, 7);
		}
	}else{
		title = "평가 신규항목 추가";
	}
	
	/*
	String ret1 = null;
	WiseFormater wf1 = null;
	
	String nickName= "p0060";
	String conType = "CONNECTION";
	String MethodName = "getCodeName";
	Object[] obj = { "M124" };
	
	try {
		ws = new WiseRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
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
	*/
	String LB_FACTOR_TYPE = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M124", String.valueOf(factor_type));
	String LB_FACTOR_qnt_flag = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M657", factor_qnt_flag);
		
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid��JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox��JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

	<script language="javascript" src="../../global/common.js"></script>
	<script language="javascript" src="../../global/vmmenu.js"></script>
	<script language="javascript" src="../../jscomm/common.js"></script>
	<script language="javascript" src="../../jscomm/menu.js"></script>
<script language="javascript">
	<!--
	function addEvaItem() {
		var obj = document.form1;
		
		var scale = 0;
		var itemChk;
		var typeChk = false;
		var factor_type;
		
		/* for(var i=0; i<obj.factor_type_chk.length;i++){
			if(obj.factor_type_chk[i].checked){
				typeChk = true;
				factor_type = obj.factor_type_chk[i].value;
			}
		}
		if(!typeChk) {
			alert("항목 타입을 선택해 주십시요.");
			return;
		}
		 */
		if(obj.evaItemName.value == "") {
			alert("체크리스트 항목명을 입력해 주십시요.");
			obj.evaItemName.focus();
			return;
		}
		
		for(var i=0; i<obj.itemName.length;i++){
			if(obj.itemName[i].value != ""){
				itemChk = true;
				//obj.itemScore[i].value = 0;
				scale++;
			}
		}
		if(!itemChk) {
			alert("선택항목 내용을 입력하여 주십시요.");
			obj.itemName[0].focus();
			return;
		}
		/* if(scale != 7) {
			alert("선택항목 내용을 7개 모두 입력하십시요");
			return;
		} */
		obj.scale.value = scale;
		/* obj.factor_type.value = factor_type;
		obj.mode.value = "insert";		
		obj.action="eva_item_ins.jsp";
		obj.target="hiddenframe";
		obj.submit(); */
		
		 var nickName        = "SR_016";
	        var conType         = "TRANSACTION";
	        var methodName      = "setEvaInsert";
	        var SepoaOut        = doServiceAjax( nickName, conType, methodName );
	        // SepoaOut.result[0] << setValue
	        
	        if( SepoaOut.status == "1" ) { // 성공
	            alert(SepoaOut.message);
	            window.close();
	            opener.getQuery();
	            
	            //if( SepoaOut.result[0] != "" )
	                //document.forms[0].product_sales_amt.value    = add_comma(,0);
	        } else {
	            if(SepoaOut.message == "null"){
	                alert("<%=text.get ( "관리자에게 문의 부탁드립니다." ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
	            }else{
	                alert(SepoaOut.message);
	            }
	        }
		
	}
		
		
	
<%if(mode.equals("update")) {%>
	function updateEvaItem() {
		var obj = document.form1;
		var scale = 0;
		var itemChk;
		var factor_type;
		
		/* if(obj.evaItemName.value == "") {
			alert("체크리스트 항목명을 입력해 주십시요.");
			obj.evaItemName.focus();
			return;
		}
		for(var i=0; i < obj.factor_type_chk.length; i++){
			if(obj.factor_type_chk[i].checked){
				factor_type = obj.factor_type_chk[i].value;
			}
		} */
		for(var i=0; i < obj.itemName.length; i++){
			if(obj.itemName[i].value != ""){
				itemChk = true;
				//obj.itemScore[i].value = 0;
				scale++;
			}
		}
		if(!itemChk) {
			alert("선택항목 내용을 입력하여 주십시요.");
			obj.itemName[0].focus();
			return;
		}
		/* if(scale != 7) {
			alert("선택항목 내용을 7개 모두 입력하십시요");
			return;
		} */
		obj.scale.value = scale;
		obj.factor_type.value = factor_type;
		obj.e_factor_refitem.value = <%=e_factor_refitem%>;	
		/* obj.mode.value = "update";
		obj.action="eva_item_ins.jsp";
		obj.target="hiddenframe";
		obj.submit(); */
		
		
		 var nickName        = "SR_016";
	        var conType         = "TRANSACTION";
	        var methodName      = "setEvaUpdate";
	        var SepoaOut        = doServiceAjax( nickName, conType, methodName );
	        // SepoaOut.result[0] << setValue
	        
	        if( SepoaOut.status == "1" ) { // 성공
	            alert("성공");
	            window.close();
	            opener.getQuery();
	            
	           /*   for(int i=0; i<scale; i++){
		            document.getElementById("itemName_"+(i+1)).value = SepoaOut.result[i];
		            }  */
	            
	        } else {
	            if(SepoaOut.message == "null"){
	                alert("<%=text.get ( "관리자에게 문의 부탁드립니다." ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
	            }else{
	                alert(SepoaOut.message);
	            }
	        }
		
		
		
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
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" <%if(checkVal > 0){%>onload="javascript:init();"<%}%>>


<!--�댁����-->

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
	<input type="hidden" name="e_factor_refitem" id="e_factor_refitem" value="<%=e_factor_refitem%>">
	<input type="hidden" name="scale" id="scale" >
	<input type="hidden" name="mode" id="mode">
	<input type="hidden" name="factor_type">

	
	<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<tr>
		<td width="20%" class="c_title_1">
			<div align="left">평가분류</div>
		</td>
		<td width="80%" class="c_data_1">
			<select name="factor_type" id="factor_type" class="inputsubmit" <%=disabled%>>
          		<%=LB_FACTOR_TYPE%>
        	</select>
		</td>
	</tr>
	<tr>
		<td width="20%" class="c_title_1">
			<div align="left">평가구분</div>
		</td>
		<td width="80%" class="c_data_1">
			<select name="factor_qnt_flag" class="inputsubmit" <%=readOnly%>>
          		<%=LB_FACTOR_qnt_flag %>
        	</select>
		</td>
	</tr>
	<tr>
		<td width="20%" class="c_title_1">
			<div align="left">항목명</div>
		</td>
		<td width="80%" class="c_data_1">
<%
	if (mode.equals("update") || mode.equals("view")) {
%>
			<input type="text" class="text" style="width:350" value="<%=evaItemName%>" name="evaItemName" id="evaItemName"  maxlength="50" <%=readOnly%>>
<%
	} else {
%>
			<input type="text" class="text" style="width:350" value="" name="evaItemName" id="evaItemName" maxlength="50">
<%
	}
%>
		</td>
	</tr>
	<tr>
		<td width="20%" class="c_title_1">
			<div align="left">항목설명</div>
		</td>
		<td width="80%" class="c_data_1">
			<textarea name="factor_desc" id="factor_desc" class="inputsubmit" rows="3" style="width:98%; height: 100px" onKeyUp="return chkMaxByte(1000, this, '��ぉ�ㅻ�');"><%=factorDesc%></textarea>
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
	    	<td><script language="javascript">btn("javascript:updateEvaItem()","수정")</script></td>
<%
		} else if(!mode.equals("view")) {
%>
	    	<td><script language="javascript">btn("javascript:addEvaItem()","등록")</script></td>
<%
		}
%>
			<td><script language="javascript">btn("javascript:self.close()","닫기")</script></td>
		</TR>
		</TABLE>
	</td>
</tr>
</table>
	

	<table width="98%" border="1" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<tr>
		<td  width="10%" align="center"  class="c_title_1_p_c">번호</td>
		<td  width="80%" align="center"  class="c_title_1_p_c">선택항목</td>
		<td  width="10%" align="center"  class="c_title_1_p_c">점수</td>
	</tr>				
<%
	if (mode.equals("update") || mode.equals("view")) {
		for(int i=0; i < wf.getRowCount(); i++) {
%>
	<tr>
		<td align="center" class="c_data_1_p_c"><%=wf.getValue(i, 3)%></td>
		<td class="c_data_1_p">
			<input type="text" name="itemName" id="itemName_<%=i+1%>" class="inputsubmit" style="width:95%" value="<%=wf.getValue(i, 2)%>" maxlength="30" <%if(mode.equals("view")){%>readonly<%}%>>
		</td>
		<td align="center" class="c_data_1_p_c">
			<input type="text" name="itemScore" id="itemScore_<%=i+1%>" class="inputsubmit" style="width:50%" value="<%=wf.getValue(i, 4)%>" maxlength="30" <%if(mode.equals("view")){%>readonly<%}%>></td>
	</tr>
<%
		}

	} else {
%>
	<tr>
		<td align="center" class="c_data_1_p_c">1</td>
		<td class="c_data_1_p">
			<input type="text" name="itemName" id="itemName_1" class="text" style="width:95%" value="" maxlength="30">
		</td>
		<td align="center" class="c_data_1_p_c">
			<input type="text" name="itemScore" id="itemScore_1" class="text" value="" style="width:50%">
		</td>
	</tr>
	<tr>
		<td align="center" class="c_data_1_p_c">2</td>
		<td class="c_data_1_p">
			<input type="text" name="itemName" id="itemName_2" class="text" style="width:95%" value="" maxlength="30">
		</td>
		<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore" id="itemScore_2" class="text" value="" style="width:50%"></td>
	</tr>
	<tr>
		<td align="center" class="c_data_1_p_c">3</td>
		<td class="c_data_1_p">
			<input type="text" name="itemName" id="itemName_3" class="text" style="width:95%" value="" maxlength="30">
		</td>
		<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore" id="itemScore_3" class="text" value="" style="width:50%"></td>
	</tr>
	<tr>
		<td align="center" class="c_data_1_p_c">4</td>
		<td class="c_data_1_p">
			<input type="text" name="itemName" id="itemName_4" class="text" style="width:95%" value="" maxlength="30">
		</td>
		<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore" id="itemScore_4" class="text" value="" style="width:50%"></td>
	</tr>
	<tr>
		<td align="center" class="c_data_1_p_c">5</td>
		<td class="c_data_1_p">
			<input type="text" name="itemName" id="itemName_5" class="text" style="width:95%" value="" maxlength="30">
		</td>
		<td align="center" class="c_data_1_p_c"><input type="text" name="itemScore" id="itemScore_5" class="text" value="" style="width:50%"></td>
	</tr>
<%
	}
%>			
</table>

<iframe name="hiddenframe" src="eva_item_ins.jsp" width="0" height="0"></iframe>
</form>	


</BODY> 

</HTML>


