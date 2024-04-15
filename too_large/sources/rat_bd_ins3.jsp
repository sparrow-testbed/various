<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_002_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_002_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "";

%>
<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bid/ebd_bd_ins1.jsp -->
<!--
Title:        역경매_참가신청등록화면  <p>
 Description:  경매_참가신청등록화면 <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       Kim.D.H<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="AU_002_1";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>
<%

    String RA_NO        		   = JSPUtil.nullToEmpty(request.getParameter("ra_no"));   //역경매번호
    String RA_COUNT    		  	   = JSPUtil.nullToEmpty(request.getParameter("ra_count")); //차수
    String ANN_ITEM     		   = JSPUtil.nullToEmpty(request.getParameter("ann_item")); //역경매건명
    String VOTE_COUNT    		   = JSPUtil.nullToEmpty(request.getParameter("ra_count")); //차수
    String RA_TYPE1    			   = JSPUtil.nullToEmpty(request.getParameter("ra_type1")); //역경매방법
    String CHANGE_USER_NAME_LOC    = JSPUtil.nullToEmpty(request.getParameter("change_user_name_loc")); //담당자명
    String CHANGE_USER_ID          = JSPUtil.nullToEmpty(request.getParameter("change_user_id")); //담당자 ID 
    
    String OPEN_REQ_FROM_DATE      = JSPUtil.nullToEmpty(request.getParameter("OPEN_REQ_FROM_DATE")); //참가신청기간
    String OPEN_REQ_TO_DATE        = JSPUtil.nullToEmpty(request.getParameter("OPEN_REQ_TO_DATE")); //
    
    String EDITABLE				   = JSPUtil.nullToEmpty(request.getParameter("editable")); //수정가능여부
    
    String RA_TYPE1_LOC="";
    
    //지명경쟁일 경우 지정된 업체가 조회되어야함
	if("NC".equals(RA_TYPE1)) RA_TYPE1_LOC = "지명경쟁";
	
	//일반경쟁일 경우 업체를 등록해야함.
	if("GC".equals(RA_TYPE1)) RA_TYPE1_LOC = "일반경쟁";
	
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    //콤보세팅
// 	SepoaListBox SepoaListBox = new SepoaListBox();
//     String comboData = SepoaListBox.Table_ListBox(request, "SL0022", HOUSE_CODE + "#M977" , "#" , "@");
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<Script language="javascript">
<!--

    var RA_NO      				= "<%=RA_NO%>";
    var ANN_ITEM   				= "<%=ANN_ITEM%>";
    var VOTE_COUNT  			= "<%=VOTE_COUNT%>";
    var RA_TYPE1  				= "<%=RA_TYPE1%>";
    var CHANGE_USER_NAME_LOC  	= "<%=CHANGE_USER_NAME_LOC%>";
    var CHANGE_USER_ID  		= "<%=CHANGE_USER_ID%>";
    var RA_TYPE1_LOC 			= "<%=RA_TYPE1_LOC%>";
    var OPEN_REQ_FROM_DATE 		= "<%=OPEN_REQ_FROM_DATE%>";
    var OPEN_REQ_TO_DATE 		= "<%=OPEN_REQ_TO_DATE%>";
    var G_HOUSE_CODE 			= "<%=HOUSE_CODE%>";
    var G_CUR_ROW; //popup관련
	var mode;
	var button_flag = false;

    var date_flag;
	var Current_Row;

    var current_date 			= "<%=current_date%>";
    var current_time 			= "<%=current_time%>";

    var INDEX_SELECTED;
    var INDEX_VENDOR_CODE;
    var INDEX_VENDOR_NAME_LOC;
    var INDEX_CEO_NAME_LOC ;
    var INDEX_JOIN_FLAG;
    var INDEX_REG_FLAG;
    var INDEX_REG_FLAG_HIDDEN;
    var INDEX_VENDOR_CODE;
    var INDEX_BID_PARTICIPATION_FORM;
    var INDEX_CHANGE_FLAG;
        
	function setHeader() {

    <%if(!"N".equals(EDITABLE)){ %>
    <%  } else{ %>
    <%  }       %>

		
		//GridObj.SetColCellSortEnable("VENDOR_NAME_LOC"	,false);
		//GridObj.SetColCellSortEnable("CEO_NAME_LOC"		,false);
	<%if(!"N".equals(EDITABLE)){ %>
    <%  } %>
		//GridObj.SetColCellSortEnable("JOIN_FLAG"			,false);
		
        INDEX_SELECTED          		=  GridObj.GetColHDIndex("SELECTED");
        INDEX_BID_PARTICIPATION_FORM 	=  GridObj.GetColHDIndex("BID_PARTICIPATION_FORM");
        INDEX_VENDOR_NAME_LOC   		=  GridObj.GetColHDIndex("VENDOR_NAME_LOC");
        INDEX_VENDOR_CODE   			=  GridObj.GetColHDIndex("VENDOR_CODE");        
        INDEX_CEO_NAME_LOC      		=  GridObj.GetColHDIndex("CEO_NAME_LOC");
        INDEX_JOIN_FLAG         		=  GridObj.GetColHDIndex("JOIN_FLAG");
        INDEX_REG_FLAG          		=  GridObj.GetColHDIndex("REG_FLAG");
        INDEX_REG_FLAG_HIDDEN   		=  GridObj.GetColHDIndex("REG_FLAG_HIDDEN");
        INDEX_CHANGE_FLAG   			=  GridObj.GetColHDIndex("CHANGE_FLAG");
	}

    var thistime    = "<%=current_time%>".substring(0,2);
    var thisminute    = "<%=current_time%>".substring(2,4);

    function init() {
		setGridDraw();
		setHeader();
		doSelect();
    }

    function doSelect() {
        var mode   = "getJoinVendorList";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_ins3";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
		GridObj.strHDClickAction="sortmulti";
    	GridObj.clearAll(false);    	
    }
	
	/*
    팝업 관련 코드
  */
  function PopupManager(){
    window.open("/common/CO_014.jsp?callback=getRecv", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}

  function getRecv(code, text, ceo_name){
    var wise = GridObj;
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_VENDOR_CODE, code);
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_VENDOR_NAME_LOC, "<%=G_IMG_ICON%>" + "&"+text+"&"+text, "&");
    GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_CEO_NAME_LOC, ceo_name);
}

	function w_close(){
		opener.doSelect();
		window.close();
	}

  
	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		G_CUR_ROW = msg2;
		if(msg1 == "doQuery") {
			
			var wise = GridObj;
			var rowcount = wise.GetRowCount();
			
			for(var i = 0 ; i < rowcount; i++){
				var change_flag = wise.GetCellValue("CHANGE_FLAG",i);
				if(change_flag == '' || change_flag == 'N'){
					//GridObj.SetComboSelectedIndex('JOIN_FLAG',i,2);
				}
			}
			//GridObj.SetComboSelectedIndex('JOIN_FLAG',0,0);
			//GridObj.SetComboSelectedIndex('JOIN_FLAG',1,0);
			//alert(GridObj.GetMessage());
			
        } else if(msg1 == "doData") { // 전송/저장시
//             alert(GridObj.GetMessage());
            button_flag = false; // 버튼 action ...  action을 취할수있도록...
            opener.doSelect();
            window.close();
		}
		if(msg1 == "t_imagetext"){
			if(msg3 == INDEX_VENDOR_NAME_LOC){
				var vendor_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_VENDOR_CODE);
				if(vendor_code == "") return;
				window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=COMPANY_CODE%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
			}
			
			if(msg3 == INDEX_BID_PARTICIPATION_FORM) {
            	printBidParticipationForm(msg2);
            }
		}
	}

    function checkData() {
    	var wise = GridObj;
		rowcount = GridObj.GetRowCount();

		checked_count = 0;
		for(row = rowcount - 1; row >= 0; row--) {
                checked_count++;
	    }

        if(checked_count == 0) {
            alert("선택된 건이 없습니다.");
            return;
        }
        
        for(var i = 0 ; i < rowcount; i++){
        	var temp = wise.GetCellValue("SELECTED",i);
			if(temp == 1){
				var JOIN_FLAG = wise.GetCellValue("JOIN_FLAG",i);
				if(JOIN_FLAG == ""){
					alert("결과를 선택해야 합니다.");
					return;
				}
			}
        }

		return true;
    }
    
	function checkReg(){
		var wise = GridObj;
		var rowcount = wise.GetRowCount();
		
		for(var i = 0 ; i < rowcount; i++){
			var temp = wise.GetCellValue("SELECTED",i);
			if(temp == 1){
				var j_flag = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("JOIN_FLAG")).getValue());
				var r_flag = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("REG_FLAG")).getValue());
				if(r_flag == "N" && j_flag == "Y"){
					alert("참가신청을 하지 않은 업체는 적격판정을 할 수 없습니다.");
					return;
				}
			}
		}
		return true;
	}
	
	function doSpecSave() {
	
     	var wise = GridObj;
		
		if(!checkData())return; // checkbox
		
		if(!checkReg()) return; // 업체 참가여부
		
		if(!confirm("등록하시겠습니까?")) return;
		
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_ins3";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setJoinVendorReg";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);		

	}
	
		// 참가신청서 출력
	function printBidParticipationForm(idx){
	/*
		var checkedIndex = "";
		var checkedCnt   = 0;
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				checkedIndex = i;
				checkedCnt ++;
			}
		}
		
		if(checkedCnt != 1){
			alert("한 업체를 선택해주십시요.");
			return;
		}
	*/	
		var so_no 		= "<%=RA_NO%>";
		var so_count 	= "<%=RA_COUNT%>";
		var vendor_code = GridObj.GetCellValue("VENDOR_CODE", idx);
		var type 		= "RAT";	
	
		//type  입찰 : BID   견적 RFQ  역경매 RAT
		childFrame.location.href = "/report/iReportPrint.jsp?flag=BID_PARTICIPATION_FORM&so_no="+so_no+"&house_code=<%=info.getSession("HOUSE_CODE")%>&type="+type+"&so_count="+so_count+"&vendor_code="+vendor_code ;
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
        doSelect();
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
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header popup="true">
<!--내용시작-->

<form name="form1" >
	
	<input type="hidden" id="RA_NO"      			name="RA_NO"      			value="<%=RA_NO%>"/>
	<input type="hidden" id="ANN_ITEM"   			name="ANN_ITEM"   			value="<%=ANN_ITEM%>"/>
	<input type="hidden" id="VOTE_COUNT"  			name="VOTE_COUNT"  			value="<%=VOTE_COUNT%>"/>
	<input type="hidden" id="RA_TYPE1"  			name="RA_TYPE1"  			value="<%=RA_TYPE1%>"/>
	<input type="hidden" id="CHANGE_USER_NAME_LOC"  name="CHANGE_USER_NAME_LOC" value="<%=CHANGE_USER_NAME_LOC%>"/>
	<input type="hidden" id="CHANGE_USER_ID"  		name="CHANGE_USER_ID"  		value="<%=CHANGE_USER_ID%>"/>
	<input type="hidden" id="RA_TYPE1_LOC" 			name="RA_TYPE1_LOC" 		value="<%=RA_TYPE1_LOC%>"/>
	<input type="hidden" id="OPEN_REQ_FROM_DATE" 	name="OPEN_REQ_FROM_DATE" 	value="<%=OPEN_REQ_FROM_DATE%>"/>
	<input type="hidden" id="OPEN_REQ_TO_DATE" 		name="OPEN_REQ_TO_DATE" 	value="<%=OPEN_REQ_TO_DATE%>"/>
	<input type="hidden" id="G_HOUSE_CODE" 			name="G_HOUSE_CODE" 		value="<%=HOUSE_CODE%>"/>

 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
<!-- 			<td class="cell_title1" width="78%" align="left">&nbsp; -->
<%-- 	  			<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12">&nbsp; --%>
			<td height="20" align="left" class="title_page" vAlign="bottom">
	  			참가신청등록
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
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      		<td class="data_td">&nbsp;<%=RA_NO%></td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매건명</td>
      		<td class="data_td">&nbsp;<%=ANN_ITEM%></td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매방법</td>
      		<td class="data_td">&nbsp;<%=RA_TYPE1_LOC%></td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 담당자명</td>
      		<td class="data_td">&nbsp;<%=CHANGE_USER_NAME_LOC%></td>
    	</tr>
  	</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	  	
  	
  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td></td>
    	</tr>
  	</table>
	<script language="JavaScript" ></script>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30"></td>
	      	<td height="30">
	      		<div align="right">
	           		<table>
						<tr>
						<!--<td><script language="javascript">btn("javascript:LineInsert()",7,"행삽입")</script></td>
							<td><script language="javascript">btn("javascript:doDelete()",3,"삭 제")</script></td>					
						-->
						<%
							if(!"N".equals(EDITABLE)){
						%>
							<td><script language="javascript">btn("javascript:doSpecSave()","저 장")</script></td>
						<%
							}
						%>
							<td><script language="javascript">btn("javascript:w_close()","닫 기")</script></td>
						
						</tr>
					</table>
				</div>
	      	</td>
		</tr>
  	</table>
</form>
<!---- END OF USER SOURCE CODE ---->

</s:header>
<s:grid screen_id="AU_002_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<iframe name = "childFrame" src=""  width="0%" height="0" border=0 frameborder=0></iframe>


