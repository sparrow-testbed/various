<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_034");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_034";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String house_code   	= info.getSession("HOUSE_CODE");
    String company_code 	= info.getSession("COMPANY_CODE");

    String item_no 			= JSPUtil.CheckInjection(request.getParameter("ITEM_NO"));
    String Attach_Index 	= "";
	String WISEHUB_PROCESS_ID="PR_034";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
	String[] args={ item_no};

	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","real_getReqList1", args);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	String ITEM_GROUP					= "";
	String ITEM_NO						= "";
	String Z_PURCHASE_TYPE 		        = "";
	String MATERIAL_TYPE_NAME           = "";
	String MATERIAL_CTRL_TYPE_NAME      = "";
	String MATERIAL_CLASS1_NAME         = "";
	String MATERIAL_CLASS2              = "";
	String MATERIAL_CLASS2_NAME         = "";
	String DESCRIPTION_LOC  	        = "";
	String ITEM_ABBREVIATION            = "";
	String BASIC_UNIT 		            = "";
	String IMAGE_FILE_PATH 	            = "";
	String IMAGE_FILE_NAME 	            = "";
	String MARKET_TYPE 		            = "";
	String DELIVERY_LT  		        = "";
	String APP_TAX_CODE 		        = "";
	String DRAWING_NO1  		        = "";
	String ITEM_BLOCK_FLAG			    = "";
	String MAKER_NAME		            = "";
	String MAKER_ITEM_NO 		        = "";
	String OLD_ITEM_NO   		        = "";
	String DO_FLAG 			            = "";
	String QI_FLAG					    = "";
	String PROXY_ITEM_NO	            = "";
	String Z_WORK_STAGE_FLAG            = "";
	String Z_DELIVERY_CONFIRM_FLAG		= "";
	String Z_ITEM_DESC					= "";
    String SPECIFICATION				= "";
	String REMARK						= "";
	String MAKER_FLAG					= "";
	String MODEL_FLAG					= "";
	String MODEL_NO						= "";
	String ITEM_GROUP_NAME				= "";
	String TAXKM_NAME					= "";
	String KTGRM_NAME					= "";
	String BKLAS_NAME					= "";
	String MTART_NAME					= "";
	String MATKL_NAME					= "";
	String ATTACH_NO					= "";
	String N_KTGRM 						= "";
	String ATTACH_COUNT                 = "";
	String MAKE_AMT_NAME     			= "";
	String MAKE_AMT_CODE            = "";
	String WID                                  = "";
	String HGT                                 = "";
	

    for ( int i = 0; i<wf.getRowCount(); i++) {

        ITEM_NO      		 			= wf.getValue("ITEM_NO"     			    ,   i);
        MATERIAL_CLASS2      			= wf.getValue("MATERIAL_CLASS2"     	    ,   i);
        MATERIAL_CLASS2_NAME 			= wf.getValue("MATERIAL_CLASS2_NAME"	    ,   i);
        MATERIAL_CLASS1_NAME 			= wf.getValue("MATERIAL_CLASS1_NAME"	    ,   i);
        MATERIAL_CTRL_TYPE_NAME 		= wf.getValue("MATERIAL_CTRL_TYPE_NAME"   	,   i);
        MATERIAL_TYPE_NAME 				= wf.getValue("MATERIAL_TYPE_NAME"   		,   i);
        DESCRIPTION_LOC      			= wf.getValue("DESCRIPTION_LOC"     	    ,   i);
        ITEM_ABBREVIATION				= wf.getValue("ITEM_ABBREVIATION"		    ,	i);
        BASIC_UNIT           			= wf.getValue("BASIC_UNIT"          	    ,   i);
        MAKER_NAME           			= wf.getValue("MAKER_NAME"          	    ,   i);
        MARKET_TYPE						= wf.getValue("MARKET_TYPE"					,   i);
        DELIVERY_LT						= wf.getValue("DELIVERY_LT"					,	i);
        APP_TAX_CODE					= wf.getValue("APP_TAX_CODE"			    ,   i);
        ITEM_BLOCK_FLAG     			= wf.getValue("ITEM_BLOCK_FLAG", i).equals("Y")?"구매정지 ":"구매가능";
        MAKER_ITEM_NO					= wf.getValue("MAKER_ITEM_NO"			    ,	i);
        DO_FLAG 			   			= wf.getValue("DO_FLAG" 			        ,	i);
		QI_FLAG							= wf.getValue("QI_FLAG"						,	i);
		PROXY_ITEM_NO	       			= wf.getValue("PROXY_ITEM_NO"	            ,	i);
		Z_WORK_STAGE_FLAG      			= wf.getValue("Z_WORK_STAGE_FLAG"         	,	i);
		Z_DELIVERY_CONFIRM_FLAG			= wf.getValue("Z_DELIVERY_CONFIRM_FLAG"   	,	i);
        IMAGE_FILE_PATH      			= wf.getValue("IMAGE_FILE_PATH"     	    ,   i);
        IMAGE_FILE_NAME      			= wf.getValue("IMAGE_FILE_NAME"     	    ,   i);
        DRAWING_NO1       				= wf.getValue("DRAWING_NO1"      			,   i);
        OLD_ITEM_NO          			= wf.getValue("OLD_ITEM_NO"         	    ,   i);
        Z_ITEM_DESC          			= wf.getValue("Z_ITEM_DESC"         	    ,   i);
        SPECIFICATION    				= wf.getValue("SPECIFICATION"   		    ,   i);
        REMARK    						= wf.getValue("REMARK"   				    ,   i);
		Z_PURCHASE_TYPE 				= wf.getValue("Z_PURCHASE_TYPE"   			,   i);
	  	MAKER_FLAG						= wf.getValue("MAKER_FLAG"   	    ,   i);
	  	MODEL_FLAG						= wf.getValue("MODEL_FLAG"   	    ,   i);
	  	MODEL_NO						= wf.getValue("MODEL_NO"   	    	,   i);
	  	ITEM_GROUP_NAME					= wf.getValue("ITEM_GROUP_NAME"   	    	,   i);
	  	TAXKM_NAME						= wf.getValue("TAXKM_NAME"   	    	,   i);
	  	KTGRM_NAME						= wf.getValue("KTGRM_NAME"   	    	,   i);
	  	BKLAS_NAME						= wf.getValue("BKLAS_NAME"   	    	,   i);
	  	MTART_NAME						= wf.getValue("MTART_NAME"   	    	,   i);
	  	MATKL_NAME						= wf.getValue("MATKL_NAME"   	    	,   i);
	  	ATTACH_NO						= wf.getValue("ATTACH_NO"   	    	,   i);
	  	ATTACH_COUNT					= wf.getValue("ATTACH_COUNT"   	    	,   i);
	  	
	  	N_KTGRM							= wf.getValue("N_KTGRM"   	    	,   i);
	  	MAKE_AMT_NAME    		    = wf.getValue("MAKE_AMT_NAME"   		    ,   i);	    
	  	MAKE_AMT_CODE             = wf.getValue("MAKE_AMT_CODE"   		    ,   i);	  	
	  	WID    				                = wf.getValue("WID"   		    ,   i);
	  	HGT    				                = wf.getValue("HGT"   		    ,   i);
	    
    }
%>
<script language="javascript">
var INDEX_MANDATORY_FLAG         ;
var INDEX_ATTRIBUTE_ID           ;
var INDEX_ATTRIBUTE_NAME         ;
var INDEX_ATTRIBUTE_VALUE        ;

</script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
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
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" >
		<input type="hidden" name="ATTACH_NO" value="<%=ATTACH_NO%>">

		<input type="hidden" name="att_mode"   value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
		<input type="hidden" name="attachImageUrl"> <%--이미지첨부일경우 실제 URL--%>

		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>품목상세</span>
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
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</td>
										<td width="35%" class="data_td">
											<%=ITEM_NO%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매정지</td>
										<td width="35%" class="data_td">
											<%=ITEM_BLOCK_FLAG%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
										<td width="35%" class="data_td">
											<%=MATERIAL_TYPE_NAME%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
										<td width="35%" class="data_td">
											<%=MATERIAL_CTRL_TYPE_NAME%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
										<td width="35%" class="data_td">
											<%=MATERIAL_CLASS1_NAME%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
										<td width="35%" class="data_td">
											<%=MATERIAL_CLASS2_NAME%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
										<td class="data_td">
											<%=DESCRIPTION_LOC%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모델명</td>
										<td class="data_td">
											<%=MODEL_NO%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;유사품목명</td>
										<td width="35%" class="data_td">
											<%=ITEM_ABBREVIATION%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계정그룹</td>
										<td width="35%" class="data_td">
											<%=KTGRM_NAME %>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기본단위</td>
										<td width="35%" class="data_td">
											<%=BASIC_UNIT%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
										<td width="35%" class="data_td">
											<%=MAKER_NAME%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										
										<% if(MAKE_AMT_CODE.equals("01")){ %>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위결정기준</td>
											<td width="35%" class="data_td">
												<%=MAKE_AMT_NAME%>
											</td>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;가로 * 세로</td>
											<td width="35%" class="data_td">
												<%=WID%> * <%=HGT%> 
											</td>										
										<% }else if(MAKE_AMT_CODE.equals("02")){ %>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위결정기준</td>
											<td width="35%" class="data_td">
												<%=MAKE_AMT_NAME%>
											</td>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;가로</td>
											<td width="35%" class="data_td">
												<%=WID%>
											</td>										
										<% }else if(MAKE_AMT_CODE.equals("03")){ %>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위결정기준</td>
											<td width="35%" class="data_td">
												<%=MAKE_AMT_NAME%>
											</td>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세로</td>
											<td width="35%" class="data_td">
												<%=HGT%> 
											</td>										
										<% }else{ %>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위결정기준</td>
											<td width="35%" class="data_td" colspan="3">
												<%=MAKE_AMT_NAME%>
											</td>											
										<% } %>										
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
										<td width="35%" class="data_td" colspan="3">
											<%=SPECIFICATION%>
										</td>										
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목설명</td>
										<td class="data_td" colspan="3">
											<textarea name="Z_ITEM_DESC" value="" style="width: 98%; height: 140px;"  rows="5" cols="85"  scrollbar="auto" class="inputsubmit" readonly ><%=Z_ITEM_DESC%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3">
											<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 115px; border: 0px;" frameborder="0" ></iframe>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:parent.close()", "닫 기");
</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
</s:header>
<s:footer/>
</body>
</html>