<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String dis_view 	= "";
	String ev_no 		= JSPUtil.nullToEmpty(request.getParameter("ev_no"));
	String ev_year 		= JSPUtil.nullToEmpty(request.getParameter("ev_year"));
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_004";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;

%>

<html>
	<head>
		<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;


//숫자체크  .이 연속으로 들어오는거 방지
function IsNumber2(num){
	var i;
	pcnt = 0;
	var tcnt = 0;

	for(i=0;i<num.length;i++){
		if (num.charAt(0) == '.'){
			return false;
		}
		if (num.charAt(i) == '.'){
			pcnt ++;
		}
		if(num.charAt(0) == '-'){
			if((num.charAt(i) < '0' || num.charAt(i) > '9') && (num.charAt(i) != '.' ||  pcnt>1) && i > 0){
				return false;
			}
		}else{
			if((num.charAt(i) < '0' || num.charAt(i) > '9') && (num.charAt(i) != '.' ||  pcnt>1)){
				return false;
			}
		}
	}
	return true;
}

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	
	function Init(){
		setGridObj(GridObj);
		setGridDraw();
		//setHeader();
		
	}
	
	function setGridObj(arg) {
		GridObj = arg;
	}
	
	
	
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	
    	GridObj.setSizes();
    	document.all.ev_item_visi2.style.display="none";
		document.all.ev_item_visi3.style.display="none";
    	
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
		var ev_seq	   = GridObj.getUserData("", "EV_SEQ")==null?"":GridObj.getUserData("", "EV_SEQ");
		var ev_year	   = GridObj.getUserData("", "EV_YEAR")==null?"":GridObj.getUserData("", "EV_YEAR");
		//var ev_m_item	   = GridObj.getUserData("", "EV_M_ITEM")==null?"":GridObj.getUserData("", "EV_M_ITEM");
		//var ev_d_item	   = GridObj.getUserData("", "EV_D_ITEM")==null?"":GridObj.getUserData("", "EV_D_ITEM");
		var ev_type	   = GridObj.getUserData("", "EV_TYPE")==null?"":GridObj.getUserData("", "EV_TYPE");
		var ev_unit	   = GridObj.getUserData("", "EV_UNIT")==null?"":GridObj.getUserData("", "EV_UNIT");
		//var ev_scope	   = GridObj.getUserData("", "EV_SCOPE")==null?"":GridObj.getUserData("", "EV_SCOPE");
		var ev_weight	   = GridObj.getUserData("", "EV_WEIGHT")==null?"":GridObj.getUserData("", "EV_WEIGHT");
		var ev_weight_point	   = GridObj.getUserData("", "EV_WEIGHT_POINT")==null?"":GridObj.getUserData("", "EV_WEIGHT_POINT");
		var ev_basic_point	   = GridObj.getUserData("", "EV_BASIC_POINT")==null?"":GridObj.getUserData("", "EV_BASIC_POINT");
		var ev_remark	   = GridObj.getUserData("", "EV_REMARK")==null?"":GridObj.getUserData("", "EV_REMARK");
		var attach_remark  = GridObj.getUserData("", "ATTACH_REMARK")==null?"":GridObj.getUserData("", "ATTACH_REMARK");
		var vn_display	   = GridObj.getUserData("", "VN_DISPLAY")==null?"Y":GridObj.getUserData("", "VN_DISPLAY");
		var money_use	   = GridObj.getUserData("", "MONEY_USE")==null?"":GridObj.getUserData("", "MONEY_USE");
		var ev_item	   = GridObj.getUserData("", "EV_ITEM")==null?"":GridObj.getUserData("", "EV_ITEM");
		var item_name1	   = GridObj.getUserData("", "ITEM_NAME1")==null?"":GridObj.getUserData("", "ITEM_NAME1");
		var item_name2	   = GridObj.getUserData("", "ITEM_NAME2")==null?"":GridObj.getUserData("", "ITEM_NAME2");
		var item_name3	   = GridObj.getUserData("", "ITEM_NAME3")==null?"":GridObj.getUserData("", "ITEM_NAME3");
		var cal_desc	   = GridObj.getUserData("", "CAL_DESC")==null?"":GridObj.getUserData("", "CAL_DESC");
		var EV_REQ_DESC = GridObj.getUserData("", "EV_REQ_DESC")==null?"":GridObj.getUserData("", "EV_REQ_DESC");
		var EV_REQSEQ = GridObj.getUserData("", "EV_REQSEQ")==null?"":GridObj.getUserData("", "EV_REQSEQ");
		
		var AVG_EV_NO = GridObj.getUserData("", "AVG_EV_NO")==null?"":GridObj.getUserData("", "AVG_EV_NO");
		var SUM_EV_NO = GridObj.getUserData("", "SUM_EV_NO")==null?"":GridObj.getUserData("", "SUM_EV_NO");
		var CAL_TYPE = GridObj.getUserData("", "CAL_TYPE")==null?"":GridObj.getUserData("", "CAL_TYPE");
		var AVG_VALUE = GridObj.getUserData("", "AVG_VALUE")==null?"":GridObj.getUserData("", "AVG_VALUE");
		var AUTO_CAL = GridObj.getUserData("", "AUTO_CAL")==null?"":GridObj.getUserData("", "AUTO_CAL");
		
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");

		if(status == "false") alert(msg);
		document.form1.ev_seq.value = ev_seq;
		//document.form1.ev_m_item.value = ev_m_item;
		//document.form1.ev_d_item.value = ev_d_item;
		document.form1.grade_item.value = GridObj.getRowsNum()=="0"?"":GridObj.getRowsNum();
		document.form1.ev_type.value = ev_type;
		document.form1.ev_unit.value = ev_unit;
		//document.form1.ev_scope.value = ev_scope;
		document.form1.ev_weight.value = ev_weight;
		document.form1.ev_weight_point.value = ev_weight_point;
		document.form1.ev_basic_point.value = ev_basic_point;
		document.form1.ev_remark.value = ev_remark;
		document.form1.attach_remark.value = attach_remark;
		document.form1.vn_display.value = vn_display;
		//document.form1.money_use.value = money_use;
		document.form1.ev_item.value = ev_item;
		document.form1.item_name1.value = item_name1;
		document.form1.item_name2.value = item_name2;
		document.form1.item_name3.value = item_name3;
		document.form1.cal_desc.value = cal_desc;
		document.form1.ev_req_desc.value = EV_REQ_DESC;
		document.form1.ev_reqseq.value = EV_REQSEQ;
		
		document.form1.avg_ev_no.value = AVG_EV_NO;
		document.form1.sum_ev_no.value = SUM_EV_NO;
		document.form1.cal_type.value = CAL_TYPE;
		document.form1.avg_value.value = AVG_VALUE;
		("Y" == AUTO_CAL)?document.form1.auto_cal.checked = true:"";
		
		var f = document.forms[0];
		if(vn_display == "Y" ){
			document.all.ev_item_visi.style.display="inline";
			document.all.ev_item_visi1.style.display="inline";
			document.all.ev_item_visi2.style.display="none";
			document.all.ev_item_visi3.style.display="none";
			f.auto_cal.checked= false;
		}else if(vn_display == "N" ){
			
			
			document.all.ev_item_visi.style.display="none";
			document.all.ev_item_visi1.style.display="none";
			document.all.ev_item_visi2.style.display="inline";
			document.all.ev_item_visi3.style.display="inline";
			f.auto_cal.checked= false;
			
		}
		
	/*	
		if(ev_type == "02"){
			GridObj.setColumnHidden(GridObj.getColIndexById("EV_MAX"), true);
    		GridObj.setColumnHidden(GridObj.getColIndexById("EV_MIN"), true);
		}
		*/
		return true;
    }

    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
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
			//alert("cellInd = " + cellInd);
			
			if( cellInd == 2 ){
				if(!IsNumber2(LRTrim( GridObj.cells(rowId, GridObj.getColIndexById("EV_MAX")).getValue() ))){
					alert("숫자만 입력 가능합니다.");
					return;
				}		
			
				var chk_ev_max = parseFloat( GridObj.cells(rowId, GridObj.getColIndexById("EV_MAX")).getValue() );

				
				for( var i = 1; i <= dhtmlx_last_row_id; i++ ){
					var max = parseFloat( GridObj.cells(i, GridObj.getColIndexById("EV_MAX")).getValue() );
					var min = parseFloat( GridObj.cells(i, GridObj.getColIndexById("EV_MIN")).getValue() );
					//alert("i = "+ i +", rowId = " + rowId + " , max = " + max + " , min = " + min);
					
					if( i < rowId ){
						if( rowId != 1 && ( isNaN(max) || isNaN(min) ) ){
							alert("순서대로 입력해주십시요.");
							return;
						}
					}
				
					if( rowId == i )	continue;
				
					if( !isNaN(max) && !isNaN(min) ){
						if( chk_ev_max > min ){
							alert(min + "의 값과 같거나 낮은 값을 입력하여 주십시요.");
							return;
						}
					}
				}
			}
			else if( cellInd == 3 ){
				if(!IsNumber2(LRTrim( GridObj.cells(rowId, GridObj.getColIndexById("EV_MIN")).getValue() ))){
					alert("숫자만 입력 가능합니다.");
					return;
				}
							
				var chk_ev_min = parseFloat( GridObj.cells(rowId, GridObj.getColIndexById("EV_MIN")).getValue() );
				
				for( var i = 1; i <= dhtmlx_last_row_id; i++ ){
					var max = parseFloat( GridObj.cells(i, GridObj.getColIndexById("EV_MAX")).getValue() );
					var min = parseFloat( GridObj.cells(i, GridObj.getColIndexById("EV_MIN")).getValue() );
					//alert("i = "+ i +", rowId = " + rowId + " , max = " + max + " , min = " + min);
					
					if( i <= rowId ){
						if( rowId != 1 && ( isNaN(max) || isNaN(min) ) ){
							alert("순서대로 입력해주십시요.");
							return;
						}
					}					
					
					if( rowId == i ){
						if( !isNaN(max) ){
							if( chk_ev_min > max ){
								alert(max + "의 값보다 낮은 값을 입력하여 주십시요.");
								return;
							}						
						}
					}
				}
			}
		    return true;
		}
		
		return false;
    }
    
    
    
    // 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 loadXML 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{
		
		
		var grid_col_id = "<%=grid_col_id%>";
		var f = document.forms[0];
		
	    var ev_no		= f.ev_no.value;  
		var ev_year 	= f.ev_year.value;
		var ev_m_item 	= f.ev_m_item.value;
		var ev_d_item 	= f.ev_d_item.value;
		
		if(ev_d_item==""){
			return;
		}

		
		var param = "";
		
		param += "&ev_no="+ev_no;
		param += "&ev_year="+ev_year;
		param += "&ev_m_item="+ev_m_item;
		param += "&ev_d_item="+ev_d_item;
		
		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_insert?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);
	}
	
	function doInsert() { 
   		
   		 <%=grid_obj%>.setCheckedRows(0, "true");
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
			{
				//<%=grid_obj%>.cells(row, cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
				<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("selected")).cell.wasChanged = true;
		    }
		if( !checkRows() )return;
		
		var f = document.forms[0];
		
		var ev_seq          = f.ev_seq.value;
		var ev_year         = f.ev_year.value;
		var ev_no           = f.ev_no.value;
		var ev_m_item       = f.ev_m_item.value;
		var ev_d_item       = f.ev_d_item.value;
		var grade_item      = f.grade_item.value;
		var ev_type         = f.ev_type.value;
		var ev_unit         = f.ev_unit.value;
		var ev_scope        = f.ev_scope.value;
		var ev_weight       = f.ev_weight.value;
		var ev_weight_point = f.ev_weight_point.value;
		var ev_basic_point  = f.ev_basic_point.value;
		var ev_remark       = f.ev_remark.value;
		var attach_remark   = f.attach_remark.value; // 첨부파일비고 (추가)
		var vn_display      = f.vn_display.value;
		var money_use       = "N";//f.money_use.value;
		var ev_item         = f.ev_item.value;
		var item_name1      = f.item_name1.value;
		var item_name2      = f.item_name2.value;
		var item_name3      = f.item_name3.value;
		var cal_desc        = f.cal_desc.value;
		var ev_req_desc     = f.ev_req_desc.value;
		var ev_reqseq       = f.ev_reqseq.value;
		var avg_ev_no       = f.avg_ev_no.value;
		var sum_ev_no       = f.sum_ev_no.value;
		var cal_type        = f.cal_type.value;
		var avg_value       = f.avg_value.value;
		var auto_cal        = (true == f.auto_cal.checked)? "Y" : "N";

	   	if(ev_m_item == ""){
	   		alert("대분류평가항목을 선택하세요.");
	   		f.ev_m_item.focus();
	   		return;
	   	}
	   	if(ev_d_item == ""){
	   		alert("중분류평가항목을 선택하세요.");
	   		f.ev_d_item.focus();
	   		return;
	   	}
	   	if(grade_item == ""){
	   		alert("평가단계를 선택하세요.");
	   		f.grade_item.focus();
	   		return;
	   	}
	   	if(ev_type == ""){
	   		alert("정량/정성을 선택하세요.");
	   		f.ev_type.focus();
	   		return;
	   	}
	   	if(ev_type == "01"){
		   	if(ev_unit == ""){
		   		alert("단위를 선택하세요.");
		   		f.ev_unit.focus();
		   		return;
		   	}
		   	if(ev_scope == ""){
		   		alert("범위를 선택하세요.");
		   		return;
		   	}
	    }
	   	if(ev_type == "02"){
		   	if( vn_display == "Y" ){
		   		alert("정성인 경우는 업체등록여부를 N으로 하셔야 합니다.");
		   		f.vn_display.focus();
		   		return;
		   	}
	    }		
		
	   	if(ev_basic_point == ""){
	   		alert("평가항목배점 을 입력하세요.");
	   		f.ev_basic_point.focus();
	   		return;
	   	}
	   	if(!IsNumber2(ev_basic_point)){
	   		alert("평가항목배점 는 숫자만 입력 가능합니다.");
	   		f.ev_basic_point.focus();
	   		return;
	   	}
	   	if(vn_display == ""){
	   		alert("업체등록여부를 선택하세요.");
	   		f.vn_display.focus();
	   		return;
	   	}
	//   	if(money_use == ""){
	//   		alert("금액여부를 선택하세요.");
	//   		return;
	//   	}
	   	if( vn_display == "Y" ){
		   	if(ev_item == ""){
		   		alert("항목수를 선택하세요.");
		   		f.ev_item.focus();
		   		return;
		   	}else {
		   	
			   	if(item_name1 == ""){
			   		alert("항목1을 입력하세요.");
			   		f.item_name1.focus();
			   		return;
			   	}
			   	if(item_name2 == "" && ev_item >= 2){
			   		alert("항목2을 입력하세요.");
			   		f.item_name2.focus();
			   		return;
			   	}
			   	if(item_name3 == "" && ev_item == 3){
			   		alert("항목3을 입력하세요.");
			   		f.item_name3.focus();
			   		return;
			   	}
		   	
		   	}
		   	if(ev_req_desc== ""){
		   		alert("평가요소(질문지)를 입력하세요.");
		   		f.ev_req_desc.focus();
		   		return;
		   	}
		   	auto_cal = "N";
	   	}else{
	   		ev_item = "";
	   		item_name1 = "";
	   		item_name2 = "";
	   		item_name3 = "";
	   	}
	   	
		if(auto_cal == "Y"){
			if(!IsNumber2(avg_value)){
	   			alert("연산값은 숫자만 입력 가능합니다.");
	   			f.avg_value.focus();
	   			return;
	   		}
			if(avg_ev_no == "" || sum_ev_no == "" || avg_value == "" ){
				alert("자동계산 체크시 평균점수 심사표, 연산값, 환산점수 심사표는 필수 입력 값입니다. ");
				f.avg_ev_no.focus();
				return;
			}
		}else{
		   avg_ev_no = "";
		   sum_ev_no = "";
		   avg_value = "";
		   cal_type  = "";
		}
	   	
	   	var grid_array    = getGridChangedRows(GridObj, "selected");
	   	var EV_POINT_TEMP = 0;
	   	
		for(var i = 0; i < grid_array.length; i++)
		{
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_ITEM_DESC")).getValue()) == "")
			{
				alert("평가요소를 입력하세요.");
				return;
			}
			if(ev_type == "01"){
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MAX")).getValue()) == "")
				{
					alert("MAX를 입력하세요.");
					return;
				}else{
					if(!IsNumber2(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MAX")).getValue()))){
						alert("MAX는 숫자만 입력 가능합니다.");
					return;
					}
				}
	
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MIN")).getValue()) == "")
				{
					alert("MIN을 입력하세요.");
					return;
				}else{
					if(!IsNumber2(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MIN")).getValue()))){
						alert("MIN은 숫자만 입력 가능합니다.");
					return;
					}
				}
			}else{
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MAX")).getValue()) != "")
				{
					alert("정성인 경우에는 MAX를 입력하지 않습니다.");
					GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MAX")).setValue("");
					return;
				}
	
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MIN")).getValue()) != "")
				{
					alert("정성인 경우에는 MIN을 입력하지 않습니다.");
					GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_MIN")).setValue("");
					return;
				}			
			}
			
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_POINT")).getValue()) == "")
			{
				alert("배점을 입력하세요.");
				return;
			}else{
				if(!IsNumber2(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_POINT")).getValue()))){
					alert("배점은 숫자만 입력 가능합니다.");
					return;
				}
				
				var EV_POINT = GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_POINT")).getValue();
				//alert("EV_POINT      = " + EV_POINT);
				//alert("EV_POINT_TEMP = " + EV_POINT_TEMP);
				if( parseInt( EV_POINT ) > parseInt( EV_POINT_TEMP ) ){
					EV_POINT_TEMP = EV_POINT;
				}
			}
			
		}
		
		//alert(EV_POINT_TEMP + " = " + ev_basic_point);
		
		// 기술평가는 평가요소배점과 평가항목배점이 같지 않아도 된다.
		if( ev_m_item != "ev11" ){
			if( EV_POINT_TEMP != ev_basic_point ){
				EV_POINT_TEMP = 0;
				alert( "평가항목배점점수와 평가요소의 가장 큰 배점점수가 같아야 합니다.(기술평가 제외)" );
				f.ev_basic_point.focus();
				return;
			}
		}
		
		var param = "";
		param += "&ev_seq="           + ev_seq;
		param += "&ev_year="          + ev_year;
		param += "&ev_no="            + ev_no;
		param += "&ev_m_item= "       + ev_m_item;
		param += "&ev_d_item= "       + ev_d_item;
		param += "&grade_item= "      + grade_item;
		param += "&ev_type= "         + ev_type;
		param += "&ev_unit= "         + ev_unit;
		param += "&ev_scope= "        + ev_scope;
		param += "&ev_weight= "       + ev_weight;
		param += "&ev_weight_point= " + ev_weight_point;
		param += "&ev_basic_point= "  + ev_basic_point;
		param += "&ev_remark= "       + encodeUrl(ev_remark);
		param += "&attach_remark= "   + encodeUrl(attach_remark);
		param += "&vn_display= "      + vn_display;
		param += "&money_use= "       + money_use;
		param += "&ev_item= "         + ev_item;
		param += "&item_name1= "      + encodeUrl(item_name1);
		param += "&item_name2= "      + encodeUrl(item_name2);
		param += "&item_name3= "      + encodeUrl(item_name3);
		param += "&cal_desc= "        + encodeUrl(cal_desc);
		param += "&ev_req_desc="      + encodeUrl(ev_req_desc);
		param += "&ev_reqseq="        + ev_reqseq;
		param += "&auto_cal="         + auto_cal;
		param += "&avg_ev_no="        + avg_ev_no;
		param += "&sum_ev_no="        + sum_ev_no;
		param += "&cal_type="         + cal_type;
		param += "&avg_value="        + avg_value;
		
	    if (confirm("<%=text.get("MESSAGE.1018")%>")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_insert?cols_ids="+cols_ids+"&mode=insert"+param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
	}
	
	function doDelete(){
		
		 <%=grid_obj%>.setCheckedRows(0, "true");
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
			{
				//<%=grid_obj%>.cells(row, cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
				<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("selected")).cell.wasChanged = true;
		    }
		    
		var f = document.forms[0];
		var ev_no = f.ev_no.value;
		var ev_year = f.ev_year.value;
		var ev_seq = f.ev_seq.value;
		
		if(ev_seq == ""){
			alert("해당 평가항목은 데이터가 존재하지 않습니다.");
			return;
		}
		
		var param= "";
		param += "&ev_no=" + ev_no;
		param += "&ev_year="+ev_year;
		param += "&ev_seq="+ev_seq;
		
		var grid_array = getGridChangedRows(GridObj, "selected");
		
	    if (confirm("<%=text.get("MESSAGE.1015")%>")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_insert?cols_ids="+cols_ids+"&mode=delete"+param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
	}
	
	

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length >= 1)
		{
			return true;
		}else if(grid_array.length == 0)
		{
			alert("<%=text.get("MESSAGE.1004")%>");
			return false;
		}
		
		alert("<%=text.get("MESSAGE.1006")%>");
		return false;
	}

	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'selected') return;
		GridObj.SetCellValue("selected", nRow, "1");
	}

	function initAjax(){
		doRequestUsingPOST( 'W202', '<%=to_day.substring(0,4)%>' ,'ev_m_item', '' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M050' ,'ev_type', '' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M051' ,'ev_unit', '' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M053' ,'ev_scope', 'AD' );
	}

	function nextAjax(){
		
		var f = document.forms[0];
				
				var sg_refitem=f.ev_m_item.value;
				
				var ev_d_item_id = eval(document.getElementById('ev_d_item')); //id값 얻기
				ev_d_item_id.options.length = 0; //길이 0으로
//				ev_d_item_id.fireEvent("onchange"); //onchange 이벤트발생
				$(ev_d_item_id).trigger("onchange");
				if(sg_refitem.valueOf().length > 0) {
					// 공백인 option 하나 추가(전체 검색위해서)
					var nodePath = document.getElementById("ev_d_item");
					var ooption = document.createElement("option");
					
					ooption.text = "--------";
					ooption.value = "";
					nodePath.add(ooption);
					
					doRequestUsingPOST( 'W203', sg_refitem+'#'+'<%=to_day.substring(0,4)%>' ,'ev_d_item', '' );
					//doRequestUsingPOST( 'SP9196', account_type ,'account_code', '' );
				}else {
					var nodePath = document.getElementById("ev_d_item");
					var ooption = document.createElement("option");
					
					ooption.text = "--------";
					ooption.value = "";
					nodePath.add(ooption);
				
				}
				
		
	}

	// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		var ev_seq   = obj.getAttribute("ev_seq");
		var reset   = obj.getAttribute("reset");

		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {
			alert(messsage);
			document.form1.ev_seq.value = ev_seq;
			if(reset == "Y"){
				page_reset();
			}
		} else {
			alert(messsage);
		}

		return false;
	}
	
	function doAddRow(line)
    {
    	var grid_array = getGridChangedRows(GridObj, "selected");
    	var rowcount = dhtmlx_last_row_id;
		GridObj.enableSmartRendering(false);
    	for(var row = rowcount ; row > 0; row--)
		{
			GridObj.deleteRow(row);
	    }
    	
		
   		dhtmlx_last_row_id = line ;
	
		for( i = 1 ; i <= line ; i++){
			GridObj.enableSmartRendering(true);
			GridObj.addRow(i, "", GridObj.getRowIndex(i));
	    	GridObj.selectRowById(i, false, true);
	    	GridObj.cells(i, GridObj.getColIndexById("selected")).cell.wasChanged = true;
			GridObj.cells(i, GridObj.getColIndexById("selected")).setValue("1");
	    	GridObj.cells(i, GridObj.getColIndexById("EV_ITEM_DESC")).setValue("");
	    	GridObj.cells(i, GridObj.getColIndexById("EV_MAX")).setValue("");
	    	GridObj.cells(i, GridObj.getColIndexById("EV_MIN")).setValue("");
	    	GridObj.cells(i, GridObj.getColIndexById("EV_POINT")).setValue("");
	    	
		} 
	
		
		dhtmlx_before_row_id = line;
    }
    
    function page_reset(){
    	var f = document.forms[0];
    	var ev_no = f.ev_no.value;
    	var ev_year = f.ev_year.value;
    	document.location.href="ev_sheet_insert.jsp?ev_no="+ev_no+"&ev_year="+ev_year;
    	
    	
    }
    
    function doCreate(){
    	
    	var f = document.forms[0];
    	
    	if(f.ev_seq.value == ""){
    		alert("평가항목이 되야지 질의서를 작성할 수 있습니다..");
    		return;
    	}
    	var url = "ev_sheet_insert_req.jsp";
		document.forms[0].method = "POST";
		document.forms[0].action = url;
		var req = window.open( url, 'sg_req', "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=700,left=0,top=0");
		document.forms[0].target = "sg_req";
		document.forms[0].submit();
		req.focus();
    	
    
    
    }
    
    function change_item(){
    	var f = document.forms[0];
    	
    	var ev_item = f.ev_item.value;
    	if(ev_item == '1'){
    		f.item_name2.value = "";
    		f.item_name3.value = "";
    	}else if(ev_item == '2'){
    		f.item_name3.value = "";
    	}
    
    }
    
    function searchSheet(part)
	{
		var f = document.forms[0];
	    
	    if(f.auto_cal.checked){
			if( part == "avg_ev_no" )
			{
					PopupCommon1("SP5003", "getavg_ev_no", "", "SHEET번호", "SHEET제목");
				
			}
			if( part == "sum_ev_no" )
			{
					PopupCommon1("SP5003", "getsum_ev_no", "", "SHEET번호", "SHEET제목");
				
			}
		}else{
			alert("심사표연결 유/무(자동계산)를 체크한 후 입력 가능 합니다.");
		}

	}
	
	function getavg_ev_no(code,text) {
		document.forms[0].avg_ev_no.value = code;
		document.forms[0].avg_ev_no_name.value = text;
	}
	
	function getsum_ev_no(code,text) {
		document.forms[0].sum_ev_no.value = code;
		document.forms[0].sum_ev_no_name.value = text;
	}
	
	function avg_value_chk(){
		var f = document.forms[0];
	    
	    if(!f.auto_cal.checked){
	     alert("심사표연결 유/무(자동계산)를 체크한 후 입력 가능 합니다.");
	     f.avg_value.value="";
	     return;
	    }
	    
	    if(!IsNumber2(f.avg_value.value)){
   			alert("연산값은 숫자만 입력 가능합니다.");
   			f.avg_value.value="";
   			return;
	   	}
	}
	
	function auto_cal_chk(){
	
	}

	function ev_item_visible(){
		var f = document.forms[0];
		var vn_display = f.vn_display.value;
		var auto_cal = (true == f.auto_cal.checked)?"Y":"N";
		if(vn_display == "Y" ){
			document.all.ev_item_visi.style.display="inline";
			document.all.ev_item_visi1.style.display="inline";
			document.all.ev_item_visi2.style.display="none";
			document.all.ev_item_visi3.style.display="none";
			
			f.auto_cal.checked= false;
		}else if(vn_display == "N" ){
			document.all.ev_item_visi.style.display="none";
			document.all.ev_item_visi1.style.display="none";
			document.all.ev_item_visi2.style.display="inline";
			document.all.ev_item_visi3.style.display="inline";

			f.auto_cal.checked= false;
		}
	}
	
	function vn_display_change(){
		var f          = document.forms[0];
		var ev_type    = f.ev_type.value;
		// 정성
		if( ev_type == "02" )		f.vn_display.value = "N";
		// 정량
		else if( ev_type == "01" )	f.vn_display.value = "Y";

		ev_item_visible();
	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="Init();initAjax();">
<s:header popup="true">
		<form id="form1" name="form1" action=""> 
		<input type="hidden" id="ev_no" 			name="ev_no" 			value="<%=ev_no %>" readonly="readonly">
		<input type="hidden" id="ev_year" 			name="ev_year" 			value="<%=ev_year %>" readonly="readonly">
		<input type="hidden" id="ev_seq" 			name="ev_seq" 			value="" readonly="readonly">
		<input type="hidden" id="ev_reqseq" 		name="ev_reqseq" 		value="" readonly="readonly">
		<input type="hidden" id="item_name3"  		name="item_name3"  		size="15" maxlength="15" class="inputsubmit" >
		<input type="hidden" id="ev_weight" 		name="ev_weight" 		value="N"> <!-- 가중치적용 -->				
		<input type="hidden" id="ev_weight_point" 	name="ev_weight_point" 	value="0"><!-- 가중치점수 -->
		
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr>
 		<td height="5"> </td>
	</tr>
	<tr>
		<td width="100%" valign="top">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
					<td width="15%" class="div_input">
			        	<div align="left">심사표제목</div>
			      	</td>
			      	<td width="75%" class="se_cell_data" colspan="5"> 
			      		<input type="text" id="ev_no_text" name="ev_no_text" class="input_empty" value="<%=ev_no%>" size="45" maxlength="100" readonly="readonly">
			        </td> 
				</tr>
				<tr>
					<td width="15%" class="div_input_re">
						대분류평가항목
					</td>
					<td width="18%" class="se_cell_data">
						<select id="ev_m_item" name="ev_m_item" class="inputsubmit" onchange="nextAjax();" >
							<option value="">
								--------
							</option>
							 
						</select>
					</td>
					<td width="15%" class="div_input_re">
						중분류평가항목
					</td>
					<td width="18%" class="se_cell_data">
						<select id="ev_d_item" name="ev_d_item" class="inputsubmit" onchange="doQuery();">
							<option value="">
								--------
							</option>
							
						</select>
					</td>
					<td width="15%" class="div_input_re">
						평가단계
					</td>
					<td width="18%" class="se_cell_data">
						<select id="grade_item" name="grade_item" class="inputsubmit" onchange="doAddRow(this.value);">
						<option value="">-----</option>
							<% 
								for(int i=1; i<8; i++)
								{
									out.println("<option value="+i+">"+i+"단계</option>");
								}
							%> 
					</td>
				</tr>
				<tr> 
					<td width="15%" class="div_input_re">
						정량/정성
					</td>
					<td width="18%" class="se_cell_data">
						<select id="ev_type" name="ev_type" class="inputsubmit" onchange="vn_display_change();">
							<option value="">
								전체
							</option>
							 
						</select>
					</td>
					<td width="15%" class="div_input">
						단위
					</td>
					<td width="18%" class="se_cell_data">
						<select id="ev_unit" name="ev_unit" class="inputsubmit" >
							<option value="">
								전체
							</option>
							
						</select>
					</td>
					<td width="15%" class="div_input">
						범위
					</td>
					<td width="18%" class="se_cell_data">
						<select id="ev_scope" name="ev_scope" class="inputsubmit" disabled="disabled">
							<option value="">
								전체
							</option>
							 
						</select>
					</td>
				</tr>
				<tr> 
					<td width="15%" class="div_input">
						평가항목배점
					</td>
					<td width="18%" class="se_cell_data">
						<input type="text" id="ev_basic_point" name="ev_basic_point"  size="15" maxlength="15" class="inputsubmit" >
					</td>
	      			<td width="15%" class="div_input">
						첨부파일비고
					</td>
					<td width="18%" class="se_cell_data" colspan="3">
						<input type="text" id="attach_remark" name="attach_remark"  size="80" maxlength="150" class="inputsubmit" >
					</td>					
				</tr> 
			    <tr>
			      <td width="15%" class="div_input">
						비고
					</td>
					<td width="18%" class="se_cell_data" colspan="5">
						<input type="text" id="ev_remark" name="ev_remark"  size="150" maxlength="150" class="inputsubmit" >
					</td>
				</tr>				
				<tr>
					<td height="15" class="se_cell_data" colspan="6"> </td>
				</tr>
				<tr> 
					<td width="15%" class="div_input_re">
						업체등록여부
					</td>
					<td width="18%" class="se_cell_data" colspan="5">
						<select id="vn_display" name="vn_display" class="inputsubmit" onchange="ev_item_visible()">
							 <option value="Y">Y</option> 
							<option value="N">N</option> 
						</select>
					</td>
<%-- 				<td width="15%" class="div_input">
						금액여부
					</td>
					<td width="18%" class="se_cell_data">
						<select name="money_use" class="inputsubmit" >
							<option value="">
								전체
							</option>
							<option value="Y">Y</option> 
							<option value="N">N</option> 
						</select>
					</td>
--%>					
					
				</tr>
				<tr id="ev_item_visi"> 
					<td width="15%" class="div_input">
						항목수
					</td>
					<td width="18%" class="se_cell_data">
						<select id="ev_item" name="ev_item" class="inputsubmit" onchange="change_item()">
							<option value="">
								전체
							</option>
							<option value="1">
								1
							</option>
							<option value="2">
								2
							</option>
						<%--	<option value="3">
								3
							</option> 
						 --%>
						</select>
					</td>
					<td width="15%" class="div_input">
						항목1
					</td>
					<td width="18%" class="se_cell_data">
						<input type="text" id="item_name1" name="item_name1"  size="15" maxlength="15" class="inputsubmit" >
					</td>
					<td width="15%" class="div_input">
						항목2
					</td>
					<td width="18%" class="se_cell_data" >
						<input type="text" id="item_name2" name="item_name2"  size="15" maxlength="15" class="inputsubmit" >
					</td>
				<%--	<td width="15%" class="div_input" style="visibility: hidden;">
						항목3
					</td>
					<td width="18%" class="se_cell_data" style="visibility: hidden;">
						<input type="text" name="item_name3"  size="15" maxlength="15" class="inputsubmit" >
					</td>
				 --%>
				</tr>
				<tr id="ev_item_visi1"> 
					<td width="15%" class="div_input">
						계산식
					</td>
					<td width="18%" class="se_cell_data" colspan="5">
						<input type="text" id="cal_desc" name="cal_desc"  size="150" maxlength="150" class="inputsubmit" >
					</td>
					
				</tr>
			</table>
			
				<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
		      		</td>
		    	</tr>
		  	</table>
		  	<table width="100%" border=0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB"  id="ev_item_visi2" >
		    	<tr> 
					<td width="25%" class="div_input">
						심사표연결 유/무(자동계산)
					</td>
					<td width="75%" class="se_cell_data" >
						<input type="checkbox" id="auto_cal" name="auto_cal" class="inputsubmit" onclick="auto_cal_chk(); ">  
					</td>
				</tr>
			</table>
			<table width="100%" border=0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB" id="ev_item_visi3" >
				<tr >
					<td width="30%" class="div_input" >
						(평균점수 심사표번호)
					</td>
					<td width="15%" class="div_input">
						(사칙연산 부호)	
					</td>
					<td width="10%" class="div_input">
						(연산 값)
					</td>
					<td width="45%" class="div_input">
						(환산점수 심사표번호)
						
					</td>
				</tr>
			
				<tr >
					<td width="30%" class="se_cell_data">
						<input type="text" id="avg_ev_no" name="avg_ev_no"  size="20" maxlength="20" class="inputsubmit" readonly="readonly">
						<a href="javascript:searchSheet('avg_ev_no')">
							<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
						</a>
						<input type="text" id="avg_ev_no_name" name="avg_ev_no_name" class="input_empty" size="30" readonly="readonly">
					</td>
					<td width="15%" class="se_cell_data">						
						<select id="cal_type" name="cal_type" class="inputsubmit" >
							<option value="+">
								+
							</option>
							<option value="-">
								-
							</option>
							<option value="*">
								*
							</option>
							<option value="/">
								/
							</option> 
						</select>
					</td>
					<td width="10%" class="se_cell_data">
						<input type="text" id="avg_value" name="avg_value"  size="15" maxlength="15" class="inputsubmit"  onkeyup="avg_value_chk();">
					</td>
					<td width="50%" class="se_cell_data">
						+ <input type="text" id="sum_ev_no" name="sum_ev_no"  size="20" maxlength="20" class="inputsubmit" readonly="readonly">
						<a href="javascript:searchSheet('sum_ev_no')">
							<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
						</a>
						<input type="text" id="sum_ev_no_name" name="sum_ev_no_name" class="input_empty" size="30" readonly="readonly">
					</td>
				</tr>
		  	</table>
			
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
		      		</td>
		    	</tr>
		  	</table>
		  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td  align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			   <td><script language="javascript">btn("javascript:page_reset()","초기화")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doInsert()","평가항목등록")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doDelete()","평가항목삭제")</script></td>
			    	  			 <%--  <td><script language="javascript">btn("javascript:doCreate()","질의서작성")</script></td> --%>
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
		  	<table width="100%" border=0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB" >
		    	<tr> 
					<td width="20%" class="div_input">
						평가요소(질문지)
					</td>
					<td width="80%" class="se_cell_data" >
						<input type="text" id="ev_req_desc" name="ev_req_desc"  size="150" maxlength="150" class="inputsubmit" >
					</td>
					
				</tr>
		  	</table>
		  	
		  	 <%--  <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
              <div id="pagingArea"></div>
             <%@ include file="/include/include_bottom.jsp"%> --%>
		</td>
	</tr>
</table>
</form>	
</s:header>
<s:grid screen_id="WO_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
