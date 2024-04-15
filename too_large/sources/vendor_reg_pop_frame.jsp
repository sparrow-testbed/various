<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_102_01");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_102_01";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!-- 사용 언어 설정 -->
<% String WISEHUB_PROCESS_ID="SU_102_01";%>
<%
	/* String ret = null;
	
	SepoaFormater wf = null;	
	sepoa.srv.SepoaOut value = null; 
	sepoa.util.SepoaRemote ws = null;	 */
	
	String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String sg_refitem  = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));
	
	Object[] obj = { vendor_code, sg_refitem };
	SepoaOut value = ServiceConnector.doService(info, "p0070", "CONNECTION", "getVenScrRst", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	
	/* String nickName= "p0070";
	String conType = "CONNECTION";
	String MethodName = "getVenScrRst";
	Object[] obj = { vendor_code, sg_refitem };
	
	try 
	{
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
		ret = value.result[0];
		wf =  new SepoaFormater(ret);
	}
	catch(SepoaServiceException wse) 
	{
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}
	catch(Exception e) 
	{
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    e.printStackTrace();
	}
	finally
	{
		try
		{
			ws.Release();
		}
		catch(Exception e)
		{
		}
	} */
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

<s:header popup="true">
<!--내용시작-->
<table border=0 cellpadding=0 cellspacing=0 width="100%">
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 width="100%">
			<%
				int selected = 0;
				String chk = "";
				String factor_name = "";
				String MAX_SCALE_COUNT = "";
				String COLSPAN = "";
				for(int i=0; i < wf.getRowCount(); i++) 
				{
					int s_factor_ref = Integer.parseInt(wf.getValue("S_FACTOR_REFITEM", i));
					factor_name= wf.getValue("FACTOR_NAME", i);
					MAX_SCALE_COUNT = wf.getValue("MAX_SCALE_COUNT", i);
					
					selected = Integer.parseInt(wf.getValue("SELECTED_SEQ", i));
					if(selected == 1)
					{
						chk = "checked";
					}else
					{
						chk = "";
					}
			%>
			  <tr height=25>
				<td colspan="<%=MAX_SCALE_COUNT%>" class="c_title_1">
					<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;<strong><%=factor_name%></strong></div>
					<input type="hidden" name="chk" value="1">
				</td>
			  </tr>
			  <tr height=25>
			   	<td class="c_data_1">
			   	<input disabled type="radio" class="input_data1" name="<%=s_factor_ref%>" <%=chk%>><%=wf.getValue("ITEM_NAME", i)%>
			   	</td>
			<%
					for(int j=2; ; j++)
					{
						int front = -1;
				 		if(i < wf.getRowCount() - 1)
				 		{
							front = Integer.parseInt(wf.getValue("S_FACTOR_REFITEM", i+1));
						}
						
						if(s_factor_ref == front) 
						{
							i++;
							if(j == selected)
							{
								chk = "checked";
							}
							else
							{
							 	chk = "";
							}
		   %>	
				<td  class="c_data_1">
				<input disabled type="radio" class="input_data1" name="<%=s_factor_ref%>" <%=chk%>><%=wf.getValue("ITEM_NAME", i)%>
				</td>
			<%
					}else{
						break;
					}
				}
			%>
				
			  </tr>
		<%}%>
		</table>				
		</td>
	</tr>
</table>


</s:header>
<%-- <s:grid screen_id="SU_102_01" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>


