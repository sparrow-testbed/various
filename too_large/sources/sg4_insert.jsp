<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String house_code = info.getSession("HOUSE_CODE");
	
%>
<%--
 Title:                 sou_tb_lis1.jsp <p>
 Description:           SUPPLY / ADMIN /  소싱그룹정의서 세분류매핑 <p>
 Copyright:             Copyright (c) <p>
 Company:               ICOMPIA <p>
 @author                SHYI<p>
 @version
 @Comment
--%>
<% String WISEHUB_PROCESS_ID="SR_003";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page import="wise.util.*" %>


<%
    String sg_refitem = JSPUtil.CheckInjection(request.getParameter("sg_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_refitem"));
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="javascript">

	function init() {
	    self.resizeTo(570,280);
	    doRequestUsingPOST( 'SL0018', "<%=house_code%>"+'#M040' ,'MATERIAL_TYPE', '' );
	}
	
	function clearMATERIAL_CLASS2() {

  	  	if(form1.MATERIAL_CLASS2.length > 0) {
  	    		for(i=form1.MATERIAL_CLASS2.length-1; i>=0;  i--) {
  	     			form1.MATERIAL_CLASS2.options[i] = null;
  	    		}
  	  	}
  	}

  	function setMATERIAL_CLASS2(name, value) {
  		var option1 = new Option(name, value, true);
  	  	form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.length] = option1;
  	}

  	function MATERIAL_CLASS1_Changed() {

  		clearMATERIAL_CLASS2();
  		setMATERIAL_CLASS2("----------", "");
  	  	var value = form1.MATERIAL_CLASS1.value;
  	  	doRequestUsingPOST( 'SL0089', "<%=house_code%>"+'#M122#'+value ,'MATERIAL_CLASS2', '' );
  	}

  	function clearMATERIAL_CLASS1() {

  	  	if(form1.MATERIAL_CLASS1.length > 0) {
  	    		for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
  	     			form1.MATERIAL_CLASS1.options[i] = null;
  	    		}
  	  	}
  	}

  	function setMATERIAL_CLASS1(name, value) {
  		var option1 = new Option(name, value, true);
  	  	form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
  	}

  	function MATERIAL_CTRL_TYPE_Changed() {

  	  	clearMATERIAL_CLASS1();
  		clearMATERIAL_CLASS2();
  		setMATERIAL_CLASS1("----------", "");
  		setMATERIAL_CLASS2("----------", "");
  		
  	  	/* var id = "SL0019";
  	  	var code = "M042"; */

  	  	var value = form1.MATERIAL_CTRL_TYPE.value;
  	  	doRequestUsingPOST( 'SL0019', "<%=house_code%>"+'#M042#'+value ,'MATERIAL_CLASS1', '' );
  	  	
  	  	/* target = "MATERIAL_CTRL_TYPE";

  	  	data = "sou_item_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

  	  	this.hiddenframe.location.href = data; */
  	}

  	function clearMATERIAL_CTRL_TYPE() {
  	  	if(form1.MATERIAL_CTRL_TYPE.length > 0) {
  	    		for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
  	     			form1.MATERIAL_CTRL_TYPE.options[i] = null;
  	    		}
  	  	}
  	}

  	function setMATERIAL_CTRL_TYPE(name, value) {
  	  	var option1 = new Option(name, value, true);
  	  	form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
  	}

  	function MATERIAL_TYPE_Changed() {

  	  	clearMATERIAL_CTRL_TYPE();
		clearMATERIAL_CLASS1();
		clearMATERIAL_CLASS2();
  	  	setMATERIAL_CLASS1("----------", "");
  	  	setMATERIAL_CLASS2("----------", "");
  	  	setMATERIAL_CTRL_TYPE("----------", "");
  	    var value = form1.MATERIAL_TYPE.value;
  	  	doRequestUsingPOST( 'SL0009', "<%=house_code%>"+'#M041#'+value ,'MATERIAL_CTRL_TYPE', '' );
		
  	}

  	function addsg()
	{
		if(form1.MATERIAL_CLASS2.selectedIndex > 0) {
			var obj = document.form1.selectedSg;
			var len = obj.length
			var value = document.form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.selectedIndex].value;
			for(i=0; i < form1.selectedSg.length; i++) {
				if(value == form1.selectedSg.options[i].value) {
					alert('이미 선택된 아이템입니다.');
					return;
				}
			}
			obj.options[len++] = new Option(document.form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.selectedIndex].text,document.form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.selectedIndex].value,false,"");
		}
	}

	function delsg()
	{
    		var obj = document.form1.selectedSg;
    		if(form1.selectedSg.selectedIndex >= 0) {
			obj.options[form1.selectedSg.selectedIndex] = null;
		}
	}
	function clearSG() {
  	  	if(form1.selectedSg.length > 0) {
  	    		for(i=form1.selectedSg.length-1; i>=0;  i--) {
  	     			form1.selectedSg.options[i] = null;
  	    		}
  	  	}
  	}

  	function ins_item() {
  		if(form1.selectedSg.length > 0) {
  			var param = "";
  			var param2 = "";
  	    		for(i=form1.selectedSg.length-1; i>=0;  i--) {
  	     			param = param + "," + form1.selectedSg.options[i].value;
  	     			param2 = param2 + ",'" + form1.selectedSg.options[i].value + "'";
  	    		}
  	  	}else{
  	  		alert('선택된 아이템이 없습니다.');
  	  		return;
  	  	}
  	  	param = param.substring(1);
  	  	param2 = param2.substring(1);
  	  	data = "sou_item_ins.jsp?type=M119&sg_refitem=<%=sg_refitem%>&param=" + param + "&param2=" + param2;
  	  	var params ="type=M119&sg_refitem=<%=sg_refitem%>&param=" + param + "&param2=" + param2;
  	  	var f1=document.form1;
  		var nickName        = "SR_003";
      	var conType         = "CONNECTION";
      	var methodName      = "sgCheckItem";
      	var SepoaOut        = doServiceAjax( nickName, conType, methodName ,params);
  	  	
      	if( SepoaOut.status == "1" ) { // 성공
        	if(SepoaOut.result[0]=="0"){
        		var nickName        = "SR_003";
              	var conType         = "TRANSACTION";
              	var methodName      = "setSgInsert";
              	var SepoaOut        = doServiceAjax( nickName, conType, methodName ,params);
              	if( SepoaOut.status == "1" ) { // 성공
              		alert("정상 등록되었습니다.");
              		parent.close();
                } else {
                    if(SepoaOut.message == "null"){
                        alert("<%=text.get ( "CT_001.TXT_030" ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
                    }else{
                        alert(SepoaOut.message);
                    }
                }
        		<%-- location.href="sou_item_ins.jsp?mode=insert&type=<%=type%>&sg_refitem=<%=sg_refitem%>&param=<%=param%>"; --%>
        	}else{
        		var value = confirm('다른 소싱그룹에 매핑된 세분류가 포함되어 있습니다. \n기존 매핑관계는 삭제됩니다. 계속 진행 하시겠습니까?');
        		if(value) {
        			var nickName        = "SR_003";
                  	var conType         = "TRANSACTION";
                  	var methodName      = "setSgInsert";
                  	var SepoaOut        = doServiceAjax( nickName, conType, methodName ,params);
                  	if( SepoaOut.status == "1" ) { // 성공
                  		alert("정상 등록되었습니다.");
                  		parent.close();
                    } else {
                        if(SepoaOut.message == "null"){
                            alert("<%=text.get ( "CT_001.TXT_030" ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
                        }else{
                            alert(SepoaOut.message);
                        }
                    }
					<%-- location.href="sou_item_ins.jsp?mode=insert&type=<%=type%>&sg_refitem=<%=sg_refitem%>&param=<%=param%>"; --%>
				}
        	}
        } else {
            if(SepoaOut.message == "null"){
                alert("<%=text.get ( "CT_001.TXT_030" ) %><%-- 관리자에게 문의 부탁드립니다. --%>");
            }else{
                alert(SepoaOut.message);
            }
        }
  	  	/* this.hiddenframe2.location.href = data; */

  	  }

    

</script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%-- <%@ include file="/include/sepoa_grid_common.jsp"%> --%>
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
</script>
</head>
<BODY onload="init();" TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000">

<%-- <s:header> --%>
<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle">
		&nbsp;세분류매핑
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

					<form name="form1">
        			<table width="98%" border="0" cellspacing="0" cellpadding="0">
      					<tr>
				 		<td align="left"  width="50%">
				 			<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> <b> 대분류 :</b>

							<select name="MATERIAL_TYPE" id="MATERIAL_TYPE" class="input_re" onChange="javascript:MATERIAL_TYPE_Changed();">
							<option value=''>선택</option>
							<%-- <%
							String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
							out.println(listbox1);
							%> --%>
							</select>
							<br>
    						<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> <b> 중분류 :</b>
      						<select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" class="input_re" onChange="javascript:MATERIAL_CTRL_TYPE_Changed();">
							<option value=''>선택</option>
							</select>
    						<br>
              				<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> <b> 소분류 :</b>
							<select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" class="input_re" onChange="javascript:MATERIAL_CLASS1_Changed();">
							<option value=''>선택</option>
							</select>
							<br>
              				<img src="/images/icon/icon_s_arr.gif" width="9" height="9"> <b> 세분류 :</b>
							<select name="MATERIAL_CLASS2" id="MATERIAL_CLASS2" class="input_re" onChange="">
							<option value=''>선택</option>
							</select>
						</td>
						<td align="center" width="10%"><a href="javascript:addsg();"><img src="../../images//button/butt_arrow1_.gif" border=0></a>
						<br>
						<a href="javascript:delsg();"><img src="../../images//button/butt_arrow2_.gif" border=0></a>
						</td>
						<td width="40%" height="100" align="center"><SELECT style="width:250px; height:80px" class="input_re" NAME="selectedSg" MULTIPLE SIZE=5></SELECT></td>
        				</tr>
      				</table>
      				</form>
			</td>
		</tr>
	</table>
	<table width="100%">
	<td align="right" >
	<iframe name="hiddenframe" src="" width="0" height="0"></iframe>
	<iframe name="hiddenframe2" src="" width="0" height="0"></iframe>
	</td>
	</table>
	<table width="98%">
	<tr>
      		<td height="30" align="right">
    			<TABLE cellpadding="0">
    	      		<TR>
        	  			<td><script language="javascript">btn("javascript:ins_item()","저 장")</script></td>
        	  			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
        	  		</TR>
      			</TABLE>
      		</td>
	</tr>
	</table>

<%-- </s:header>
<s:grid screen_id="SR_003" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</BODY>
</HTML>



