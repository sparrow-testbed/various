<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_018_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_018_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
%>
<!-- 사용 언어 설정 -->
<% String WISEHUB_PROCESS_ID="BD_018_1";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>
<%
	String eval_refitem = JSPUtil.CheckInjection(request.getParameter("eval_refitem"))==null?"0":JSPUtil.CheckInjection(request.getParameter("eval_refitem"));  
	String evalname = JSPUtil.nullChk(request.getParameter("evalname"));  
	String EVAL_ID = JSPUtil.nullToRef(request.getParameter("EVAL_ID"), "7");         		
	String BID_NO = JSPUtil.nullChk(request.getParameter("BID_NO"));         		
	String BID_COUNT = JSPUtil.nullChk(request.getParameter("BID_COUNT"));         		

	String eval_user_id = "";	//제안평가 평가자 ID
	try {
	    eval_user_id = CommonUtil.getConfig("sepoa.eval.user_id");
	    
		}catch(Exception e) {
			Logger.err.println(info.getSession("ID"),request, " ConfigurationException: " + e.getMessage());
		}		
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="BD_018_2"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="2"/>
</jsp:include>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">
<!--
var INDEX_EVAL_VENDOR;  	
var INDEX_EVAL_USER;
  	
  	function Init(_gridObj) 
	{
	
		//if(_gridObj.name == "WiseGrid"){
			setGridDraw();
			setHeader();

			var from_date   = "<%=SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),0)%>";
			//from_date 		= from_date.substring(0,6).concat("01");

			var to_date     = "<%=SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), 5)%>";
			//var Lastday		= getLastDate(to_date.substring(0,6));
			//to_date 		= to_date.substring(0,6).concat(Lastday);

// 			document.form1.fromdate.value = from_date;
// 			document.form1.todate.value = to_date;
		
			//조회된 화면을 View한다.
			//getQuery();
		
		//}else if(_gridObj.name == "WiseGrid2"){
			setHeader2();
			getQuery2();
		//}
	}
 
	function setHeader() 
	{
		
	}

	function setHeader2() 
	{

		//GridObj_1.SetCRUDMode("CRUD", "생성", "수정", "삭제");
		INDEX_EVAL_VENDOR = GridObj_1.GetColHDIndex("EVAL_VALUER_DEPT_NAME");	
		INDEX_EVAL_USER = GridObj_1.GetColHDIndex("EVAL_VALUER_NAME");	
	}

	//Data Query해서 가져오기
	function getQuery() 
	{
// 		var servletUrl = "/servlets/master.evaluation.eval_bd_ins3";
// 		GridObj.SetParam("mode", "eval_list");
<%-- 		GridObj.SetParam("eval_user_id", "<%=eval_user_id%>"); --%>
// 		GridObj.SetParam("eval_refitem", document.form1.eval_refitem.value);
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(servletUrl);
// 		GridObj.strHDClickAction="sortmulti";
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.evaluation.eval_bd_ins3";
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=eval_list";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);		
		
	}
  	
  	//Data Query해서 가져오기
	function getQuery2() 
	{
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.evaluation.eval_bd_ins3";
		
		var cols_ids = GridObj_1_getColIds();
		var params = "mode=eval_user_list";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj_1.post( servletUrl, params );
		GridObj_1.clearAll(false);
		
		
// 		GridObj_1.SetParam("mode", "eval_user_list");
// 		GridObj_1.SetParam("eval_refitem", document.form1.eval_refitem.value);
// 		GridObj_1.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj_1.SendData(servletUrl);
// 		GridObj_1.strHDClickAction="sortmulti";
	}
	
function SetDefaultLines(_GridObj, iRows) {
	var GridObj = document.getElementById(_GridObj);
	
	for ( var i =0; i < iRows; i++)
		GridObj.AddRow();
		GridObj.MoveRow(0);
	
}

function LineInsert() {
	var newId = (new Date()).valueOf();
	GridObj_1.addRow(newId, "");
	GridObj_1.cells(newId, GridObj_1.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj_1.cells(newId, GridObj_1.getColIndexById("SELECTED")).setValue("1");
}
function LineDelete(){
	if(GridObj_1.GetRowCount() > 0){
		for(var i = GridObj_1.GetRowCount()-1 ; i >= 0 ; i--){
			GridObj_1.deleteRow(GridObj_1.getRowId(i));
			break;
		}
	}
}  	


function getLastDate(str)
{
    var yy,mm,ny,nm;
    var arr_d;
	var error = "99";

    if(str.length != 6)
    {
		alert("다음과 같은 형식으로 입력하십시요[200704]");
        return error;
    }

    yy = str.substring(0,4);// 년, 월을 문자열로 가지고 있는다.
    mm = str.substring(4,6);

    if(mm < '10')// patch 판
    {
        mm = mm.substring(1);// patch 판
    }

    ny = parseInt(yy);      // 년, 월을 정수형으로 가지고 있는다.
    nm = parseInt(mm);

    if(!(Number(yy)) || (ny < 1000) || (ny>9999))
    {
        alert('년도를 입력하시요.');
        return error;
    }

    if(!(Number(mm)) || (nm < 1) || (nm > 12))
    {
        alert('월을 입력하시요.');
        return error;
    }

    arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31')

    if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0)) 
    	arr_d[1] = 29;

	return arr_d[nm-1];
  }
  	
  	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
  	function JavaCall(msg1,msg2,msg3,msg4,msg5)
  	{
 		if(msg1 == "doQuery"){
 				if(GridObj.GetRowCount() !=0){
	    			document.getElementById("evalCreateTable").style.display="none";
// 	    			document.form1.attach_no.value = GridObj.cells(GridObj.getRowId(0), 13).getValue()
	    			//rMateFileAttach('S','R','EV',document.form1.attach_no.value);
	    		}
  		}	
		
		var eval_refitem 		= document.form1.eval_refitem.value;
		var eval_valuer_refitem = "";
		var complete 			= "";
		var e_template_refitem 	= "";
		var template_type 		= "";
		var eval_item_refitem 	= "";
		var vendor_name 		= "";
		var sg_name 			= "";
		var eval_id 			= "";
		var eval_name 			= "";
		var eval_dept_name 		= "";
		
		if(GridObj.GetRowCount() !=0){				
			eval_valuer_refitem = GD_GetCellValueIndex(GridObj,0, 9);
			complete 			= GD_GetCellValueIndex(GridObj,0, 5);
			e_template_refitem 	= GD_GetCellValueIndex(GridObj,0, 6);
			template_type 		= GD_GetCellValueIndex(GridObj,0, 7);
			eval_item_refitem 	= GD_GetCellValueIndex(GridObj,0, 8);
			vendor_name 		= GD_GetCellValueIndex(GridObj,0, 2);
			sg_name 			= GD_GetCellValueIndex(GridObj,0, 3);
			eval_id 			= GD_GetCellValueIndex(GridObj,0, 10);	//EVAL_VALUER_ID
			eval_name 			= GD_GetCellValueIndex(GridObj,0, 11);
			eval_dept_name 		= GD_GetCellValueIndex(GridObj,0, 12);
		}
		
		if(msg1 == "t_imagetext"){	  		 
			if(msg3 == '5'){
				if(complete == "미완료") 
				{
// 					var url = "eva_list_pop3.jsp?e_template_refitem=" + e_template_refitem + 
					var url = "/procure/eva_list_pop3.jsp?e_template_refitem=" + e_template_refitem + 
							  "&template_type=" + template_type +
						      "&eval_valuer_refitem=" + eval_valuer_refitem + 
						      "&eval_item_refitem=" + eval_item_refitem + 
						      "&eval_refitem="+eval_refitem +
						      "&eval_name="+eval_name +
						      "&eval_dept_name="+eval_dept_name +
						      "&vendor_name="+vendor_name;
					window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
				}else if(complete = "완료") {
// 					var url = "eva_pp_lis3.jsp?e_template_refitem=" + e_template_refitem + 
					var url = "/procure/eva_pp_lis3.jsp?e_template_refitem=" + e_template_refitem + 
							  "&template_type=" + template_type +
						      "&eval_item_refitem=" + eval_item_refitem + 
						      "&eval_refitem="+eval_refitem +
						      "&vendor_name="+ vendor_name +
						      "&user_id="+ eval_id +
						      "&eval_name="+ eval_name +
						      "&sg_name="+ sg_name;
					window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=650,left=0,top=0");
				}
			}else if(msg3 == '14'){	//평가점수
				var _GridObj = GridObj;
				 
				if(complete = "완료"){
					var msg = "평가자 [" + eval_dept_name + " " + eval_name + "]님의 평가 내용을 삭제하고 다시 평가 등록 하시겠습니까?";
					if (confirm(msg)){
						servletUrl = "/servlets/master.evaluation.eval_bd_ins3";; 
		
						_GridObj.SetParam("mode", "update");
						_GridObj.SetParam("eval_refitem", eval_refitem);
						_GridObj.SetParam("eval_item_refitem", eval_item_refitem);
						_GridObj.SetParam("eval_valuer_refitem", eval_valuer_refitem);
						_GridObj.SetParam("bid_no", "<%=BID_NO%>");
						_GridObj.SetParam("bid_count", "<%=BID_COUNT%>");
			
						_GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
						_GridObj.SendData(servletUrl, "ALL", "ALL");
					}
				}
			}
		}else if(msg1 == "doData"){
			alert("평가정보가 정상적으로 삭제 처리되었습니다.");
			getQuery();
		}
	}
  	
  	
function GridEndQuery(_gridObj)
{
	if(_gridObj.name == "WiseGrid2"){
	    
	    if(_gridObj.GetRowcount() == 0){
	    	document.getElementById("evalCreateTable").style.display="";
	    	SetDefaultLines("WiseGrid2", 5);
	    }else{
	    	//평가실행 후 평가데이터가 생성되었을 경우 업체정보를 보여준다.
	   		if(document.form1.eval_refitem.value==0){
	   			document.form1.eval_refitem.value =  _gridObj.GetParam(2);
	    	} 
	    }
	   getQuery();
	} 
	 
}
  	
	function onRefresh() {
		document.form1.refresh_flag.value="Y";
		getQuery();
	}
	
	function DoCreateEval(){
		var chk_cnt=0;
		var _GridObj = GridObj_1;
		
		for(row=0;row<_GridObj.GetRowCount(); row++) 
		{
			//for(i=row+1;i<_GridObj.GetRowCount();i++){
				
				var vendor_name 	= GridObj_1.cells(GridObj_1.getRowId(row), INDEX_EVAL_VENDOR).getValue();
				var user_name 		= GridObj_1.cells(GridObj_1.getRowId(row), INDEX_EVAL_USER).getValue();
				//var chk_vendor_name = GridObj_1.cells(GridObj_1.getRowId(i), INDEX_EVAL_VENDOR).getValue();
				//var chk_user_name 	= GridObj_1.cells(GridObj_1.getRowId(i), INDEX_EVAL_USER).getValue();
				
// 				alert(vendor_name + "/" + user_name);
				
 				if(vendor_name!="" && user_name != ""){
					chk_cnt++;
				}
				
// 				if(vendor_name== "" && chk_vendor_name=="" && user_name=="" && chk_user_name == ""){
// 				}else{
// 					if(vendor_name==chk_vendor_name && user_name == chk_user_name){
// 						//소속정보와 이름이 동일한 경우가 발생하면 아이디가 같기 때문에 제안평가결과에서 평가자별로 grouping되어 한명으로 보여지기 때문에 반드시 다르게 하여야 한다.
// 						alert("평가자 정보 중 소속정보와 이름 정보가 동일합니다.\n소속정보와 이름 중 하나를 다르게 하여 구분하여 주시기 바랍니다.");
// 						return;
// 					}
// 				}
			//}
		}
	
	
		for(row=_GridObj.GetRowCount()-1; row>=0; row--) 
		{
			if(GD_GetCellValueIndex(_GridObj, row, INDEX_EVAL_VENDOR)=="" && GD_GetCellValueIndex(_GridObj, row, INDEX_EVAL_USER) == ""){
				_GridObj.DeleteRow(row,true);
			}
		}
	
	
		if(chk_cnt == 0)
		{
			alert("평가자 정보가 없습니다. 평가자를  지정 후 평가 생성 하십시요.");
			return;
		}
		
		f = document.form1;
		var evalname = f.evalname.value;	
		var fromdate = f.fromdate.value;	
		var todate = f.todate.value;	
		var evaltemp_num = "<%=EVAL_ID%>";	
	
		if(evalname == "")
		{
			alert("평가명을 입력하십시요.");
			f.evalname.focus();
			return;
		}
	
// 		if(fromdate == "" || todate == "") 
// 		{
// 			alert("평가기간을 입력해 주세요.");
// 			return;
// 		}
		
// 		if(fromdate > todate ) 
// 		{
// 			alert("평가 시작일자가 종료일자보다 큽니다. 다시 입력해 주세요.");
// 			return;
// 		}
	
		if(evaltemp_num == "")
		{
			alert("제안평가 템플릿 코드가 없습니다. 템플릿 코드 확인 후 다시 생성 해 주십시요.");
			return;
		}
		
		Message = "제안 평가를 생성하시겠습니까?";
		 
		if(confirm(Message) != 1) 
		{
			return;
		}
		setEvalDataSend();
		//document.attachFrame.setData();	//startUpload
	}	
	function setEvalDataSend(){
		f = document.form1;
		var _GridObj = GridObj_1;
		var evalname = f.evalname.value;	
		var fromdate = f.fromdate.value;	
		var todate = f.todate.value;	
		var evaltemp_num = "<%=EVAL_ID%>";	
	
// 		if(f.attach_no.value ==""){
// 			alert("평가자의 평가 정보를 첨부파일로 등록해 주세요.");
// 			return;
// 		}
	
		//servletUrl = "/servlets/master.evaluation.eval_bd_ins3";
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.evaluation.eval_bd_ins3";
		$("#flag").val("2");
		
		var grid_array = getGridChangedRows(GridObj_1, "SELECTED");
		var cols_ids = GridObj_1_getColIds();
		var params;
		params = "?mode=create";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj_1, myDataProcessor, "SELECTED",grid_array);
		
	
// 		_GridObj.SetParam("mode", "create");
// 		_GridObj.SetParam("evalname", evalname);
<%-- 		_GridObj.SetParam("bid_no", "<%=BID_NO%>"); --%>
<%-- 		_GridObj.SetParam("bid_count", "<%=BID_COUNT%>"); --%>
// 		_GridObj.SetParam("fromdate", fromdate);
// 		_GridObj.SetParam("todate", todate);
// 		_GridObj.SetParam("eval_id", evaltemp_num);
// 		_GridObj.SetParam("flag", "2");	//평가진행중
// 		_GridObj.SetParam("attach_no", f.attach_no.value);
		
// 		_GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
// 		_GridObj.SendData(servletUrl, "ALL", "ALL");

	}
	
	function from_date(year,month,day,week) 
	{
		document.form1.fromdate.value=year+month+day;
	}

	function to_date(year,month,day,week) 
	{
		document.form1.todate.value=year+month+day;
	}
	 
	 
// 	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
// 		var f = document.forms[0];
	
// 		f.att_mode.value   = att_mode;
// 		f.view_type.value  = view_type;
// 		f.file_type.value  = file_type;
// 		f.tmp_att_no.value = att_no;

// 		if (att_mode == "P") {
// 			var protocol = location.protocol;
// 			var host     = location.host;
// 			var addr     = protocol +"//" +host;

// 			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

// 			f.method = "POST";
// 			f.target = "fileattach";
// 			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
// 			f.submit();
// 		} else if (att_mode == "S") {
// 			f.method = "POST";
// 			f.target = "attachFrame";
// 			f.action = "/rMateFM/rMate_file_attach.jsp";
// 			f.submit();
// 		}
// 	}
	

	 
//-->
</script>

<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var GridObj_1 = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    	
    	GridObj_1_setGridDraw();
    	GridObj_1.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid2,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
// 	JavaCall("t_imagetext", GridObj.getRowIndex(rowId), cellInd);
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
    	alert("성공적으로 처리 하였습니다.");
    	if(!isNaN(messsage)){
	        $("#eval_refitem").val(messsage);
    	}
        getQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	//JavaCall("doData");
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
    
    opener.doQuery();
    
    if("undefined" != typeof JavaCall) {
//     	JavaCall("doQuery");
    } 
    return true;
}

var setRow = "";
function getUser(rowId){
	setRow = rowId;
	//var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9113&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
	//Code_Search(url,'','','','','');
    var url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9113&function=SP9113_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
    Code_Search(url, 'SP9113', '', '', '', '');
}

function SP9113_getCode(id, name, emp_no, dept) {
	GridObj_1.cells(setRow, GridObj_1.getColIndexById("EVAL_VALUER_DEPT_NAME")).setValue(emp_no);
	GridObj_1.cells(setRow, GridObj_1.getColIndexById("EVAL_VALUER_NAME")).setValue(id);

}

///////////////////////////////////////////////////////////// Grid2 Script ////////////////////////////////////////////////////////

//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_1_doOnRowSelected(rowId,cellInd){
	
	var header_name = GridObj_1.getColumnId(cellInd);
	
	if( header_name == "EVAL_VALUER_NAME" ){
		getUser(rowId);
    }	
}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_1_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj_1.cells(rowId, cellInd).getValue();
	
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	}
	else if(stage==1) {
		return false;
	}
	else if(stage==2) {
		return true;
	}
}

//서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
//서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function GridObj_1_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("GridObj_1_message").innerHTML = messsage; // 아이디 주의

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	if(status == "true") {
		alert(messsage);
		
		doQuery();
	}
	else {
		alert(messsage);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doData");
	} 

	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_1_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj.clearAll();
		GridObj.setCSVDelimiter("\t");
		GridObj.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_1_doQueryEnd() {
	var msg        = GridObj_1.getUserData("", "message");
	var status     = GridObj_1.getUserData("", "status");
	
    if(GridObj.GetRowCount() == 0){
		document.getElementById("evalCreateTable").style.display="";
    	//SetDefaultLines("WiseGrid2", 5);
    }else{
    	//평가실행 후 평가데이터가 생성되었을 경우 업체정보를 보여준다.
   		if(document.form1.eval_refitem.value==0){
   			document.form1.eval_refitem.value = GridObj.GetParam(2);
    	} 
    }
   	getQuery();	

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}

// 트랜잭션용 함수
function GridObj_1_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_1, "Check"); // 선택 칼럼명에 맞춰서
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_1.getColIndexById("Check");// 선택 칼럼명에 맞춰서
	var gridObj_1Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_1);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_1_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		gridObj_1Cell = GridObj_1.cells(gridArrayInfo, checkColIndex);
		checked       = gridObj_1Cell.getValue();

		if(checked == "1") {
			isSetUpdated = true;
		}
		else {
			isSetUpdated = false;
		}
		
		myDataProcessor.setUpdated(gridArrayInfo, isSetUpdated);
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	GridObj_1_doQueryDuring();
}

function setEvalScore(){
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");
	}
	
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.evaluation.eval_bd_ins3";
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setEvalScore";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(servletUrl+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

</script>
</head>
<body onload="Init(GridObj);" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작-->
<form id="form1" name="form1" method="post">
	<input type="hidden" id="eval_user_id" 	 	name="eval_user_id" 	value="<%=eval_user_id%>">
	<input type="hidden" id="eval_refitem" 	 	name="eval_refitem" 	value="<%=eval_refitem%>">
	<input type="hidden" id="evaltemp_num" 	 	name="evaltemp_num" 	value="<%=EVAL_ID%>">
	<input type="hidden" id="flag" 	 			name="flag" 			value="">
	<input type="hidden" id="bid_no" 	 		name="bid_no" 			value="<%=BID_NO%>">
	<input type="hidden" id="bid_count" 	 	name="bid_count" 		value="<%=BID_COUNT%>">
<!-- 	<input type="hidden" id="attach_no" 		name="attach_no" 		value=""> -->
	<input type="hidden" id="attach_gubun" 	 	name="attach_gubun" 	value="body">
<!-- 	<input type="hidden" id="attach_count" 		name="attach_count" 	value=""> -->
	<input type="hidden" id="att_mode"   		name="att_mode"   		value="">
	<input type="hidden" id="view_type"  		name="view_type"  		value="">
	<input type="hidden" id="file_type"  		name="file_type"  		value="">
	<input type="hidden" id="tmp_att_no" 		name="tmp_att_no" 		value="">
	<input type="hidden" id="attach_view_flag" 	name="attach_view_flag"	value="C">
		
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
<%-- 	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle"> --%>
		제안평가 
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
	<td width="15%" class="title_td">
		<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가명</div>
	</td>
	<td width="35%" class="data_td">
		<input type=text size="40" value='<%=evalname%>' id="evalname" name="evalname" readonly >
	</td>
	<td width="15%" class="title_td">
		<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가기간</div>
	</td>
	<td width="35%" class="data_td">
		<s:calendar id="fromdate" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d"/>
		<s:calendar id="todate" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d"/>
	</td>
</tr>
<tr>
<!-- <tr> -->
<!-- 	<td colspan="2" height="1" bgcolor="#dedede"></td> -->
<!-- </tr>  	 -->
<!-- 	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td> -->
	
<!-- 	<td class="data_td" height="200" colspan="3"> -->
<!-- 	<table> -->
<!-- 		<tr> -->
<!-- 			<td> -->
<%-- 				<script language="javascript"> --%>
<!-- // 				function setAttach(attach_key, arrAttrach,row, attach_count) { -->
<!-- // 					alert(attach_count); -->
<!-- // 					document.getElementById("attach_no").value = attach_key; -->
<!-- // 					document.getElementById("attach_count").value = attach_count; -->
<!-- // 				} -->
<!-- // 				btn("javascript:attach_file(document.getElementById('attach_no').value, 'FILE');", "파일등록"); -->
<%-- 				</script> --%>
<!-- 			</td> -->
<!-- 			<td>	 -->
<!-- 				<input type="text" size="3" readOnly value="0" name="attach_count" id="attach_count"/> -->
<!-- 				<input type="hidden" value="" name="attach_no" id="attach_no">				 -->
<!-- 			</td> -->
<!-- 		</tr> -->
<!-- 	</table> -->
	
<!-- <!-- 		<iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe> --> 
<!-- 	</td> -->
<!-- 	</tr> -->
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	
  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<%-- 	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle"> --%>
	<td height="20" align="left" class="title_page" vAlign="bottom">
		평가자  정보
	</td>
</tr>
</table> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="right">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" id="evalCreateTable" style="display:none;">
			<tr align="right">
				<td align="right" width="658"><script language="javascript">btn("javascript:LineInsert()","행추가")</script></td>
				<td align="right"><script language="javascript">btn("javascript:LineDelete()","행삭제")</script></td>
				<td align="right"><script language="javascript">btn("javascript:DoCreateEval()","평가실행")</script></td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="5"></td>
	<!-- wisegrid 상단 bar -->
</tr>
<tr>
	<td align="right">
		<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div>
	</td>
</tr>
</table>

<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
<%-- 	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle"> --%>
		제안평가 대기
	</td>
</tr>
<TR align="right">
	<TD><script language="javascript">btn("javascript:setEvalScore();","평가점수 등록")</script></TD>
</TR>
</table> 
<iframe name="hiddenframe" src="" width="0" height="0"></iframe>  
</form> 
</s:header>
<s:grid screen_id="BD_018_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html> 
  
 


