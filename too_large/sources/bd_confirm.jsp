<%
/**
 * @파일명   : bd_confirm.jsp
 * @생성일자 : 2009. 07. 09
 * @변경이력 :
 * @프로그램 설명 : 입찰자 적격 처리
 */
%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>


<%
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date = to_day;
	
	String seller_code   = JSPUtil.paramCheck(request.getParameter("seller_code"));
	String seller_name   = JSPUtil.paramCheck(request.getParameter("seller_name"));
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String user_type    = info.getSession("USER_TYPE");
	String company_code = info.getSession("COMPANY_CODE");
	String company_name = info.getSession("COMPANY_NAME");
	
		
	if(seller_code != null && seller_code.trim().length() > 0) {
		company_code = seller_code;
		company_name = seller_name;
	}
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "BD_004";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
		
%>


<%
	String BD_NO			= JSPUtil.paramCheck(request.getParameter("bd_no"));
	String BD_COUNT			= JSPUtil.paramCheck(request.getParameter("bd_count"));
	String BD_METHOD		= JSPUtil.paramCheck(request.getParameter("bd_methode"));
	String SUITABLE_FLAG	= JSPUtil.paramCheck(request.getParameter("SUITABLE_FLAG"));

	
	String BD_TYPE           = "";
	String BD_TYPE_TEXT      = "";
	//String BD_METHOD        = "";
	String BD_METHOD_TEXT   = "";
	String PUB_ITEM          = "";
	String REQ_END_DATE      = "";
	String REQ_END_TIME      = "";
	String REQ_END_DATE_VIEW = "";
	String BD_ELIGIBILITY    = "";
	String BD_KIND			 = "";
	String BD_KIND_TEXT      = "";
	String BD_OPEN_DATE      = "";
	String BD_OPEN_TIME      = "";
 
    Map< String, String > map = new HashMap< String, String >();
    
    map.put( "bd_no", BD_NO );
    map.put( "bd_count", BD_COUNT ); 
    Object[]    obj     = { map }; 
    SepoaOut value = ServiceConnector.doService(info, "BD_003", "CONNECTION","getBdConfirmHD", obj);

    SepoaFormater wf = new SepoaFormater(value.result[0]);
    int iRowCount = wf.getRowCount();
    
    if(iRowCount>0)
    {
    	//BD_NO             = wf.getValue("BD_NO",0);                
    	//BD_COUNT          = wf.getValue("BD_COUNT",0);             
    	BD_TYPE           = wf.getValue("BD_TYPE",0);              
    	BD_TYPE_TEXT      = wf.getValue("BD_TYPE_TEXT",0);         
    	BD_METHOD        = wf.getValue("BD_METHOD",0);           
    	BD_METHOD_TEXT   = wf.getValue("BD_METHOD_TEXT",0);      
    	PUB_ITEM          = wf.getValue("PUB_ITEM",0);             
    	REQ_END_DATE      = wf.getValue("REQ_END_DATE",0);         
    	REQ_END_TIME      = wf.getValue("REQ_END_TIME",0);         
    	REQ_END_DATE_VIEW = wf.getValue("REQ_END_DATE_VIEW",0);    
    	BD_ELIGIBILITY    = wf.getValue("BD_ELIGIBILITY",0);    
    	BD_KIND 		  = wf.getValue("BD_KIND",0);  
    	BD_KIND_TEXT      = wf.getValue("BD_KIND_TEXT",0);  
    	BD_OPEN_DATE      = wf.getValue("BD_OPEN_DATE",0);  
    	BD_OPEN_TIME      = wf.getValue("BD_OPEN_TIME",0);  
    }

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>


<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_comfirm_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	 
    	<%if(!BD_NO.equals("") && !BD_COUNT.equals("")) {%>
    	  doQuery();
    	<%}%>
    }

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }
    
    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		
		if(status == "false") alert(msg);
		
		return true;
    }
    
    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    var row_id=0;
    var col_id=0;
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);
    	
		if(header_name == "SELLER_NAME")
		{//팝업창 만듬
			var VENDOR_CODE = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("SELLER_CODE")).getValue());
			openSellerInfo(VENDOR_CODE);
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
		} else if(stage==2) {
		
			var unt_flag = LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "UNT_FLAG"));//부정당
			var achv_flag = LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "ACHV_FLAG"));//실적확인 
			
			if(GridObj.getColIndexById("UNT_FLAG") == cellInd){

				if(unt_flag == "N" && achv_flag == "Y"){
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "Y");
				}else if(unt_flag == "N" && achv_flag == ""){
					SepoaGridSetCellValueId(GridObj, rowId, "ACHV_FLAG", "Y");
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "Y");
				}else if(unt_flag == "Y" && achv_flag == ""){
					SepoaGridSetCellValueId(GridObj, rowId, "ACHV_FLAG", "N");
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "N");
				}else if(unt_flag == "" && achv_flag == "Y"){
					SepoaGridSetCellValueId(GridObj, rowId, "UNT_FLAG", "Y");
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "Y");
				}else if(unt_flag == "" && achv_flag == "N"){
					SepoaGridSetCellValueId(GridObj, rowId, "UNT_FLAG", "N");
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "N");
				}else if(unt_flag == "" && achv_flag == ""){
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "");
				}else {
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "N");
				} 
				
			}else if(GridObj.getColIndexById("ACHV_FLAG") == cellInd){
				
				if(unt_flag == "N" && achv_flag == "Y"){
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "Y");
				}else if(unt_flag == "N" && achv_flag == ""){
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "Y");
				}else if(unt_flag == "" && achv_flag == "Y"){
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "Y");
				}else if(unt_flag == "" && achv_flag == ""){
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "");
				}else {
					SepoaGridSetCellValueId(GridObj, rowId, "FINAL_FLAG", "N");
				} 
			}
			
			return true;
		}
		
		return false;
    }
    
    // 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{

		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("BD_004.0001")%>");
		return false;
	}
	
	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'SELECTED') return;
		GridObj.SetCellValue("SELECTED", nRow, "1");
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
			/// doQuery();
			self.close();
		} else {
			alert(messsage);
		}

		return false;
	}
    
    function initAjax()
	{
    }
	
	
	/**
	 * @Function Name  : doQuery
	 * @작성일         : 2009. 07. 09
	 * @변경이력       :
	 * @Function 설명  : 입찰자 적격 확인 처리  > 조회
	 */		
	function doQuery()
	{
		
		 var cols_ids = "<%=grid_col_id%>";
		 var params = "mode=queryComfirm";
		 params += "&cols_ids=" + cols_ids;
		 params += dataOutput();
		 GridObj.post( G_SERVLETURL, params );
		 GridObj.clearAll(false);

	}
	
	
	/**
	 * @Function Name  : doComfirm
	 * @작성일         : 2009. 07. 09
	 * @변경이력       :
	 * @Function 설명  : 입찰자 적격 확인 처리  > 확인
	 */	
	function doComfirm() {


		for(var i= dhtmlx_start_row_id ; i < dhtmlx_last_row_id; i++) {
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).getValue("1");
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		}

		
		if(!checkRows()) return;
		
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		for(var i = 0; i < grid_array.length; i++)
		{
			
			if( LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_FLAG")).getValue()).length <= 0 )
			{
				<%--부정당업체 판정을 하시기 바랍니다.--%>
				alert("<%=text.get("BD_004.0004")%>");
				return;
			}
			
			<%-- 최종결과가 부적합 판정시에는 사유를 반드시 입력해야 합니다.--%>
			if( LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_FLAG")).getValue()) == "N")
			{
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("INCO_REASON")).getValue()) == "")
				{
					alert("<%=text.get("BD_004.0002")%>");
					return;
				}
			}
		}
		
		if (confirm("<%=text.get("BD_004.0003")%>") ) {
            
			var grid_array = getGridChangedRows(GridObj, "SELECTED");
			var cols_ids = "<%=grid_col_id%>";
			
			var params;
			params = "?mode=setBdConfirm";
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();
			myDataProcessor = new dataProcessor(G_SERVLETURL+params);
			//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);

       	}

	}
	
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();">
<s:header popup="true">

<form name="form">
<input type="hidden" name="bd_no" id="bd_no" value="<%=BD_NO %>">
<input type="hidden" name="bd_count" id="bd_count" value="<%=BD_COUNT %>">

	<%@ include file="/include/sepoa_milestone.jsp"%>
    
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
    		<td height="5"> </td>
	  	</tr>
	  	<tr>
	    	<td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
	      		<tr>
       				<td width="16%" height="24" class="se_cell_title"><%=text.get("BD_004.T_BD_NO")%></td> <%-- 공고번호 --%>
	        		<td width="20%"  class="se_cell_data">
	        			<%=BD_NO %>
	        		</td>
	        		<td width="12%"  class="se_cell_title"><%=text.get("BD_004.T_REQ_END_DATE")%></td> <%-- 입찰신청마감일시 --%>
	        		<td width="20%"  class="se_cell_data">
       					<%=REQ_END_DATE_VIEW %>
       				</td>
		  		</tr>
		  		<tr>
	        		<td width="16%"  class="se_cell_title"><%=text.get("BD_004.T_PUB_ITEM")%></td> <%-- 입찰건명 --%>
	        		<td width="20%"  class="se_cell_data" colspan="3">
	        			<%=PUB_ITEM %>
	        		</td>
				</tr>
		   		<tr>
       				<td width="16%"  class="se_cell_title"><%=text.get("BD_004.T_BD_TYPE")%></td> <%-- 입찰방법 --%>
       				<td width="20%"  class="se_cell_data" colspan="3">
       					<%=BD_TYPE_TEXT %>&nbsp;/&nbsp;<%=BD_KIND_TEXT %>&nbsp;/&nbsp;<%=BD_METHOD_TEXT %>
       				</td>
		  		</tr>
<!-- 
		  		<tr>
       				<td width="16%"  class="se_cell_title"><%=text.get("BD_004.T_BD_ELGIBILITY")%></td> <%-- 입찰참가자격 --%>
       				<td width="20%"  class="se_cell_data" colspan="3">
						<%=BD_ELIGIBILITY %>
       				</td>
		  		</tr>
 -->		  				  		
	      	</table>
			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				<TR>
					<td style="padding:5 5 5 0" align="right">
					<TABLE cellpadding="2" cellspacing="0">
						<TR>
						<%
						if( !SUITABLE_FLAG.equals("Y") ){ %>
					  	  	<td><script language="javascript">btn("javascript:doComfirm()","<%=text.get("BD_004.BTN_COMFIRM")%>")</script></td>
					  	<%} %>
					  	  	<td><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>")</script></td>
					
					  	</TR>
				    </TABLE>
				  	</td>
				</TR>
			</TABLE>
         
			</td>
		  </tr>
	</table>
</form>
</s:header>
<%-- START GRID BOX 그리기 --%>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- END GRID BOX 그리기 --%>
<s:footer/>

</body>
</html>
