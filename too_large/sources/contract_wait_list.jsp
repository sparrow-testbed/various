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
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_106");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	Config conf = new Configuration();
	String buyer_company_code = conf.getString("sepoa.buyer.company.code");
// 	String eprodomain = conf.getString("sepoa.initial.url");
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "CT_106";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list2";

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
    	
    	//var msg        = GridObj.getUserData("", "message");
    	//var status     = GridObj.getUserData("", "status");
		
		//if(status == "false") alert(msg);
		
		//return true;
    }
    
    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);
    	if( header_name == "CONTRACT_NUMBER"){
    		
			var	bid_type    = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());	
			var	bid_count   = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());	
			var	bid_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());	
			var	ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());	
			
			// bid_type : D (구매), C(공사)
			if( bid_type == "D" ){
<%-- 				window.open('<%=eprodomain%>/s_kr/bidding/bidd/ebd_bd_dis2_'+ann_version+'.jsp?BID_TYPE='+bid_type+'&BID_NO='+bid_no+'&BID_COUNT='+bid_count,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1000,height=600,left=0,top=0"); --%>
			}			
			else{
<%-- 				window.open('<%=eprodomain%>/s_kr/bidding/bidc/ebd_bd_dis2_'+ann_version+'.jsp?BID_TYPE='+bid_type+'&BID_NO='+bid_no+'&BID_COUNT='+bid_count,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1000,height=600,left=0,top=0");			 --%>
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
		} else if(stage==2) {
			
			
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

		alert("항목을 선택해 주세요.");
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
		var rewo_number = "";
		var rewo_seq = "";
		
		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {
			alert(messsage);
			
			getPersonAssignList();
			
		} else {
			alert(messsage);
		}

		return false;
	}
    
	function doSelect()
	{
		var from_date		= LRTrim(del_Slash(document.form.from_date.value));
		var to_date			= LRTrim(del_Slash(document.form.to_date.value));
		var ctrl_person_id	= LRTrim(document.form.ctrl_person_id.value);
		var subject   		= LRTrim(document.form.subject.value);
		var seller_code		= LRTrim(document.form.seller_code.value);
		
		if(LRTrim(from_date) == "" || LRTrim(to_date) == "" ) {
			alert("기간을 입력하세요.");
			return;
		}

		if(!checkDate(from_date)) {
			alert("기간을 확인하세요.");
			form.from_date.select();
			return;
		}

        if(!checkDate(to_date)) {
			alert("기간을 확인하세요.");
			form.to_date.select();
			return;
        }
		
		var param  = "&from_date="		+ encodeUrl(from_date);
		    param += "&to_date="		+ encodeUrl(to_date);
		    param += "&ctrl_person_id="	+ encodeUrl(ctrl_person_id);
		    param += "&subject="		+ encodeUrl(subject);
		    param += "&seller_code="	+ encodeUrl(seller_code);
		
		var grid_col_id = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=query&grid_col_id="+grid_col_id + param;
		//alert("SERVLETURL=="+SERVLETURL);
		GridObj.post(SERVLETURL);
		GridObj.clearAll(false);
	}
	
	function setContractInsert() {
		var contract_number		= "";
		var contract_count		= "";
		var cont_seller_code	= "";
		var cont_seller_name	= "";
		var rfq_type			= "";
		var	contract_amt		= "";
		var bd_kind				= "";
		var checked_count		= 0;
		var pr_no 				="";
		var cont_type1_text 	="";
		var cont_type2_text 	="";
		var x_purchase_qty      ="";
		var delv_place          ="";
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
			
			contract_number		= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONTRACT_NUMBER")).getValue());
			contract_count		= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONTRACT_COUNT")).getValue());
			cont_seller_code	= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_SELLER_CODE")).getValue());
			cont_seller_name	= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_SELLER_NAME")).getValue());
			contract_amt		= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONTRACT_AMT")).getValue());
			rfq_type			= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("RFQ_TYPE")).getValue());
			bd_kind				= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("BD_KIND")).getValue());
			ctrl_person_id		= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CTRL_PERSON_ID")).getValue());
			ctrl_person_name	= encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CTRL_PERSON_NAME")).getValue());
			pr_no	            = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_NO")).getValue());
			cont_type1_text	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE1_TEXT")).getValue());
			cont_type2_text	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE2_TEXT")).getValue());
			x_purchase_qty	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("X_PURCHASE_QTY")).getValue());
			delv_place   	    = encodeUrl(GridObj.cells(grid_array[i], GridObj.getColIndexById("DELV_PLACE")).getValue());
																								  
		}
		 
		//계약담당자는 사전에 지정이 안됨.2010.12.23 총무부요청사항
		//if(ctrl_person_id != '<=info.getSession("ID")>') {
		//	alert("계약 담당자가 아닙니다");
		//	return;
		//}
		
        if(checked_count > 1)  {
            alert(G_MSS2_SELECT);
            return;
        }

		if (confirm("계약서를 생성하시겠습니까?")) {
			var sTmpUrl = "";
			sTmpUrl = sTmpUrl + "contract_wait_list_insert.jsp";
			sTmpUrl = sTmpUrl + "?contract_number="  + contract_number;
			sTmpUrl = sTmpUrl + "&contract_count="   + contract_count;
			sTmpUrl = sTmpUrl + "&cont_seller_code=" + cont_seller_code;
			sTmpUrl = sTmpUrl + "&cont_seller_name=" + cont_seller_name;
			sTmpUrl = sTmpUrl + "&contract_amt="     + contract_amt;
			sTmpUrl = sTmpUrl + "&rfq_type="         + rfq_type;
			sTmpUrl = sTmpUrl + "&bd_kind="          + bd_kind;
			sTmpUrl = sTmpUrl + "&ctrl_person_id="   + ctrl_person_id;
			sTmpUrl = sTmpUrl + "&ctrl_person_name=" + ctrl_person_name;
			sTmpUrl = sTmpUrl + "&pr_no="            + pr_no;
			sTmpUrl = sTmpUrl + "&cont_type1_text="  + cont_type1_text;
			sTmpUrl = sTmpUrl + "&cont_type2_text="  + cont_type2_text;
			sTmpUrl = sTmpUrl + "&x_purchase_qty="   + x_purchase_qty;
			sTmpUrl = sTmpUrl + "&delv_place="       + delv_place;

			//alert(sTmpUrl);
			//return;
			location.href = sTmpUrl;

		}
	}
	
   function getCtrlPersonId() {
       	PopupCommon1("SP5004", "setCtrlPerson", "", "ID", "사용자명");
	}

	function setCtrlPerson(code, text1) {
	    document.forms[0].ctrl_person_id.value = code  ;
	    document.forms[0].ctrl_person_name.value = text1 ;
	}
	
	function getSellerCode() {
		PopupCommon2( "SP5001", "SP5001_getCode",  "", "", "업체코드", "업체명" );//업체코드,업체명
	}
	
	function SP5001_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = text1;
	}

	function initAjax() {
	}


</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();">
<s:header>
<form name="form">
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "계약대기현황";
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "true";
%>
    <%@ include file="/include/sepoa_milestone.jsp"%>
    
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%" class="se_cell_title">입찰마감일</td>
        		<td width="30%" class="se_cell_data">
        			<input type="text" name="from_date" size="8" maxlength="8" value="<%=SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), -30)%>">
				    <img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, from_date , 'yyyy/mm/dd')">
				    ~
				    <input type="text" name="to_date" size="8" maxlength="8" value="<%=SepoaDate.getShortDateString()%>">
				    <img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, to_date , 'yyyy/mm/dd')">
        		</td>
        		<td width="20%" class="se_cell_title">
        			계약담당자
        		</td>
        		<td width="30%" class="se_cell_data">
        			<input type="text" name="ctrl_person_id"  size="10" maxlength="30" onkeyup="delInputEmpty('ctrl_person_id', 'ctrl_person_name')">
					<a href="javascript:getCtrlPersonId()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
			        <input type="text" name="ctrl_person_name" size="6" readonly class="input_empty">
        		</td>
			  </tr>
		      <tr>
        		<td width="20%" class="se_cell_title">
        			입찰/견적명
        		</td>
        		<td width="30%" class="se_cell_data">
				    <input type="text" name="subject"/>
        		</td>
        		<td width="20%" class="se_cell_title">
        			업체명
        		</td>
        		<td width="30%" class="se_cell_data">
        			<input type="text" name="seller_code">
        			<a href="javascript:getSellerCode()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
        			<input type="text" name="seller_name" class="input_empty" readonly>
        		</td>              		
			  </tr>
		      </table>
			  <table cellpadding="0" cellspacing="0" border="0" width="100%">
				  <tr>
					<td style="padding:5 5 5 0" align="right">
					<table cellpadding="2" cellspacing="0">
					  <tr>
					  	  <td><script language="javascript">btn("javascript:doSelect()","조회")</script></td>
					  	  <td><script language="javascript">btn("javascript:setContractInsert()","계약생성")</script></td>
					  </tr>
				    </table>
				  </td>
			    </tr>
			  </table>
			</td>
		  </tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="CT_106" grid_box="gridbox" grid_obj="GridObj"></s:grid> 
<s:footer/>	
</body>
</html>