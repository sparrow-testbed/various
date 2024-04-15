<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	String cont_no 			= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("cont_no")));
	String from 			= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("from")));
	String house_code 		= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("house_code")));
	String company_code 	= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("company_code")));
	String dept_code 		= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("dept_code")));
	String auto_flag 		= "A";
	String req_user_id 		= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("req_user_id")));
	String doc_type 		= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("doc_type")));
	String fnc_name 		= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("fnc_name")));
	 
	System.out.println("///////app_aproval_list3.jsp//////");
	System.out.println("cont_no : "+cont_no); 
	System.out.println("from : "+from);
	System.out.println("house_code : "+house_code);
	System.out.println("company_code : "+company_code);
	System.out.println("dept_code : "+dept_code);
	System.out.println("auto_flag : "+auto_flag);
	System.out.println("req_user_id : "+req_user_id);
	System.out.println("doc_type : "+doc_type);
	System.out.println("fnc_name : "+fnc_name); 
	System.out.println("//////////////////////////////");
	
	String current_date = SepoaDate.getShortDateString();
    String current_time = SepoaDate.getShortTimeString();
    
    //SepoaDateListBox LB = new SepoaDateListBox();
	//SepoaListBox LB = new SepoaListBox();
	//String COMBO_M002     = LB.Table_ListBox(request, "SL0022",  "#M119" , "#" , "@");
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("PU_129_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "PU_129_2";
	String grid_obj  = "GridObj";
	
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<style>

.table{

    border-width: 1px 1px 1px 1px; border-style: solid;
    1px solid #cccccc;

}

</style>


<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/contract.app_aproval_list3";

var INDEX_SELECTED 		  		  = "";
var INDEX_SIGN_PATH_SEQ 		  = "";
var INDEX_USER_NAME_LOC 		  = "";
var INDEX_USER_POP 				  = "";
var INDEX_DEPT_NAME				  = "";
var INDEX_POSITION_NAME			  = "";
var INDEX_MANAGER_POSITION_NAME	  = "";
var INDEX_PROCEEDING_FLAG		  = "";
var INDEX_SIGN_USER_ID 			  = "";
var INDEX_SIGN_PATH_NO  		  = "";
var INDEX_POSITION		  		  = "";
var INDEX_MANAGER_POSITION		  = "";

 var EMPLOYEE_NO =""; 
	var	USER_NAME_LOC = "";
	var DEPT = "";
	var	DEPT_NAME ="";
	var	POSITION_NAME ="";
	var	POSITION ="";
	var	MANAGER_POSITION_NAME ="";
	var	FUNCTION ="";
	var TYPE ="";
	var DEL_TYPE="";
	
	

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
    	if(GridObj.getSelectedId() =='null' || GridObj.getSelectedId() == null){
    		alert("Row를 선택하여 주십시오.");
    		return;
    	}
    	    
    	if(1 < GridObj.getSelectedId().length){
   			alert("하나이상 선택하실 수 없습니다.");
  			return;
	 	}


    	var SIGN_PATH_SEQ       = LRTrim(GridObj.cells(GridObj.getSelectedId(), GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue());
    	 
    	//변경된  결재순서
    	var TEMP_SEQ = "";    	
    	var inc = 0;
    	if(SIGN_PATH_SEQ != '1'){
    		TEMP_SEQ = eval(SIGN_PATH_SEQ) - 1;
    	}else{
    		TEMP_SEQ = SIGN_PATH_SEQ;
    	}
    	
    	for(var i=0; i<GridObj.getRowsNum();i++)
	    {
	    	var CURR_SIGN_PATH_SEQ       = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue());
	    	 
	    	if(eval(CURR_SIGN_PATH_SEQ) == eval(TEMP_SEQ)){  //선택된 행의 번호 찾기    
	    		var CHANGE_SIGN_PATH_SEQ = eval(CURR_SIGN_PATH_SEQ) + 1; 
	    		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(CHANGE_SIGN_PATH_SEQ);   	
	    		inc++;
		    }	    	
	    }
	 
	    if(0 < eval(inc)){
		    //GridObj.moveRow(GridObj.getSelectedId(),"up");
		    GridObj.moveRowUp(GridObj.getSelectedId(),"up");
		    //선택한 행의 결재순서 변경
		    GridObj.cells(GridObj.getSelectedId(), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(TEMP_SEQ);   		    
	    }
    	
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	if(GridObj.getSelectedId() =='null' || GridObj.getSelectedId() == null){
    		alert("Row를 선택하여 주십시오.");
    		return;
    	}
    	    
    	if(1 < GridObj.getSelectedId().length){
    		alert("하나이상 선택하실 수 없습니다.");
    		return;
    	}

    	var SIGN_PATH_SEQ       = LRTrim(GridObj.cells(GridObj.getSelectedId(), GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue());

    	//변경된  결재순서
    	var TEMP_SEQ = eval(SIGN_PATH_SEQ) + 1;
    	var inc = 0;
    	for(var i=0; i<GridObj.getRowsNum();i++)
	    {
	    	var CURR_SIGN_PATH_SEQ       = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue());
	    	if(eval(CURR_SIGN_PATH_SEQ) == eval(TEMP_SEQ)){  //선택된 행의 번호 찾기
	    		var CHANGE_SIGN_PATH_SEQ = eval(CURR_SIGN_PATH_SEQ) - 1;
	    		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(CHANGE_SIGN_PATH_SEQ);   	
	    		inc++;
		    }	    	
	    }
	    /*
	    for(var i=0; i<GridObj.getRowsNum(); i++){
			var inc = i+1;
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(inc);
			GridObj.setRowId(i, inc);// 번호 변경한 행을  rowid도  변경해주기
		}
	    */
	    if(0 < eval(inc)){
	    
	    	//GridObj.moveRow(GridObj.getSelectedId(),"down");
	    	
	    	GridObj.moveRowDown(GridObj.getSelectedId(),"down");
	    	
		    //선택한 행의 결재순서 변경
		    GridObj.cells(GridObj.getSelectedId(), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(TEMP_SEQ);   	    	
		    //GridObj.setRowId(i, inc);
		}
    }
    
	//결재선 선택(approval_user.jsp에서 넘어온값)
    function getUser(user_id , user_name, dept,dept_name, posi, posi_code, manage_posi, manage_posi_code)
	{
		//EMPLOYEE_NO    사번
		//USER_NAME_LOC  결재자명
		//DEPT_NAME       부서
		//POSITION_NAME       직위
		//POSITION  직위코드
		//MANAGER_POSITION_NAME       직책
		//FUNCTION	직책코드
		
		
		EMPLOYEE_NO = user_id; 
		USER_NAME_LOC = user_name;
		DEPT = dept;
		DEPT_NAME =dept_name;
		POSITION_NAME =posi;
		POSITION =posi_code;
		MANAGER_POSITION_NAME =manage_posi;
		FUNCTION =manage_posi_code;
		
		if(!check_name()) return;	//결재자 중복체크
		
		var rowCnt = parseInt(GridObj.getRowsNum());
    	rowCnt++;
    	var nMaxRow2 = rowCnt;
    	
    	GridObj.enableSmartRendering(true);
    	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);

    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
    	
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(nMaxRow2);
    	
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("EMPLOYEE_NO")).setValue(user_id);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USER_NAME_LOC")).setValue(user_name);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("DEPT")).setValue(dept);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("DEPT_NAME")).setValue(dept_name);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("POSITION_NAME")).setValue(posi);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("POSITION")).setValue(posi_code);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("MANAGER_POSITION_NAME")).setValue(manage_posi);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("FUNCTION_CODE")).setValue(manage_posi_code);
    	
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("DEL_TYPE")).setValue("Y");	//새로 추가한 결재선은 삭제 가능 Y(기존의 삭제 불가 결재선은 X)
    	
	}
	
	function check_name(){ // 결재자가 중복 있는지 체크 
		var row_total_cnt = GridObj.getRowsNum();
		for(var i=0; i<row_total_cnt;i++) {	//차기결재자 중복체크
			var temp = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("USER_NAME_LOC")).getValue();
			if(temp == USER_NAME_LOC) {
				alert("<%=text.get("PU_129_1.MSG_0106")%>"); //이미 지정되어있는 차기결재자 입니다.
				return false;
			}
		}
				return true;
	}
	
	
	//결재선 선택 삭제
	function doDeleteRow()
    {
		//if(!checkRows_1()) return;
    	var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	var rowcount = grid_array.length;
    	
		for(var i=0 ;grid_array.length > i ; i++){ // 선택된 행만큼 반복 
			   if(GridObj.cells(grid_array[i], GridObj.getColIndexById("DEL_TYPE")).getValue() == "X"){ // del_type이 X인것은 삭제가 불가능하다.
			 	alert(" 삭제 할수 없습니다.");
			 	return;
			 }
		}
     
    	if(1 < grid_array.length){
    		alert("하나이상 선택하실 수 없습니다.");
    		return;
    	}
    	
    	var choice_sign_path_seq = "";
    	
    	//선택된 행을 찾는다.
    	for(var i=0; i<GridObj.getRowsNum();i++)
	    {
	    	if(LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).getValue()) == "1"){  //선택행 된 행의 번호 찾기
	    		choice_sign_path_seq = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue());
		    	}	    	
	    }
	    
	    GridObj.enableSmartRendering(false);
	   
    	for(var row = rowcount-1; row >= 0; row--)  // 선택된 행 삭제하기
		{ 
			GridObj.deleteRow(grid_array[row]);
	    }
		for(var i=0; i<GridObj.getRowsNum();i++)  // 선택된 행을 삭제후 선택한 행 보다 번호가 큰거를 찾아서  번호를 -1 해서 다시 정렬
	    {
	    	var SIGN_PATH_SEQ = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue());
	    	if(parseInt(choice_sign_path_seq) <= parseInt(SIGN_PATH_SEQ)){
	    		var inc_seq = parseInt(SIGN_PATH_SEQ) - parseInt(1);
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(inc_seq);
				GridObj.setRowId(i, inc_seq);  // 번호 변경한 행을  rowid도  변경해주기
	    	}	    	
	    }	    
    }
    
    
    function doDeleteRow2()
    {
		//if(!checkRows_1()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	var rowcount = grid_array.length;
    	if(GridObj.getSelectedId() =='null' || GridObj.getSelectedId() == null){
    		alert("Row를 선택하여 주십시오.");
    		return;
    	}
    	
    	if(1 < GridObj.getSelectedId().length){
   			alert("하나이상 선택하실 수 없습니다.");
  			return;
	 	}
	 	
    	var del_type = LRTrim(GridObj.cells(GridObj.getSelectedId(), GridObj.getColIndexById("DEL_TYPE")).getValue());
		if(del_type != "Y"){
			alert("기본결재선은 삭제하실 수 없습니다.");
			return;
		}
    	
		var result = GridObj.getSelectedId();
		var RowIdStr = result.split(",");
		var SeqStr =new Array ;
		
		for(var i=0 ; i < RowIdStr.length ; i++){
			SeqStr[i] = LRTrim(GridObj.cells(RowIdStr[i], GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue());
			//alert("RowIdStr["+i+"]"+RowIdStr[i]);
		}
		
		for(var i=0 ; i < RowIdStr.length ; i++){
			//alert("RowIdStr["+i+"]"+RowIdStr[i]);
		    GridObj.enableSmartRendering(false);
	    	GridObj.deleteRow(RowIdStr[i]);// 선택된 행 삭제하기   	 			
		}
		
		for(var i=0; i<GridObj.getRowsNum(); i++){
			var inc = i+1;
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(inc);
			GridObj.setRowId(i, inc);// 번호 변경한 행을  rowid도  변경해주기
		}
		
		doQuery();
	    
    }
    
    
    

    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");
		
		if(status == "false") {
			alert(msg);
			self.close();
		}
		else 
		{
		
			//위아래 행삽입 가능 TYPE : A
			//위로    행삽입 가능 TYPE : U
			//행삽입 불가 TYPE : X
			//삭제 불가능 DEL_TYPE : X
			
			for(var i=1; i<=GridObj.getRowsNum(); i++){
				GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("A");
				GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("Y");
			}
		
		/*
			if(GridObj.getRowsNum()-4 == 1){  // 1개일경우
			
				for(var i = 1; i <= GridObj.getRowsNum(); i++)
				{
					if(i==1){  // 첫번째는  행 삽입이 위 아래 둘다 가능하다  A     - 기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("A"); 
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else if(i==2){  // 두번째 행은  행삽입이 위로만 가능하다 U - 기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("U");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else{  // 첫 번째 두번째 외에는 행 삽입이 불가능하다 ..    - 기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("X");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}
				}
				
			}else if(GridObj.getRowsNum()-4 == 2){ // 2개 일경우
			
				for(var i = 1; i <= GridObj.getRowsNum(); i++)
				{
					if(i==1){  //  기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("U");  
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else if(i==2){  //  기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("B");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else if(i==3){  //  기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("U");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else{
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("X");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}
				}
			
			}else if(GridObj.getRowsNum()-4 > 2){  // 3개이상 경우
			
				for(var i = 1; i <= GridObj.getRowsNum(); i++)
				{
					if(i==1){  // 기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("U");  
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else if(i > 1 && i < GridObj.getRowsNum()-4  ){  //  기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("X");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else if(i == GridObj.getRowsNum()-4){  // 기존 데이터라서 삭제 불가 X
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("B");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else if(i == GridObj.getRowsNum()-4+1){
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("U");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");
					}else {
						GridObj.cells(i,GridObj.getColIndexById("TYPE")).setValue("X");
						GridObj.cells(i,GridObj.getColIndexById("DEL_TYPE")).setValue("X");					
					}
				}
			}
		*/
		}
		return true;
    }

	

	// 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 loadXML 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{	 
		var grid_col_id = "<%=grid_col_id%>";
		 
		GridObj.loadXML("<%=POASRM_CONTEXT_NAME%>/servlets/contract.app_aproval_list3?mode=query&grid_col_id="+grid_col_id+"&app_no=");																						

  		GridObj.clearAll(false);																																											
	}
	
	function init()
	{
		setGridDraw();
		doQuery();
//		deptframe.location.href='approval_dept.jsp?company_code=<%=info.getSession("COMPANY_CODE")%>';
	
//		userframe.location.href='approval_user.jsp?DEPT=<%=info.getSession("DEPARTMENT")%>';
		userframe.location.href='approval_user4.jsp?DEPT=<%=dept_code%>&DEPT_NAME='+encodeUrl("<%//=DEPT_NAME%>");
	}
	
	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("MESSAGE.1004")%>");
		return false;
	}
	
	
	function checkRows_1()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length == 1)
		{
			return true;
		}

		alert("한개의 행만 선택하세요.");
		return false;
	}
	


	function initAjax()
	{
	}
	
	// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
		var header_name = GridObj.getColumnId(cellInd);
		
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
		
		//document.getElementById("message").innerHTML = messsage;

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

		return false;
	}
	
	
	// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
	// 복사한 데이터가 그리드에 Load 됩니다.
	function doExcelUpload() {
		var bufferData = window.clipboardData.getData("Text");
		if(bufferData.length > 0) {
			GridObj.clearAll();
			GridObj.setCSVDelimiter("\t");
    		GridObj.loadCSVString(bufferData);
		}
		return;
	}
	


	//결재선 지정후 결재요청
    function doFinalApproval()
    {
    
    /*  // 테스트
		var text= "";
		alert(GridObj.getRowsNum()+"= 개");    	
    	for(var i=1; i<=GridObj.getRowsNum();i++)
	    {
	    	var a1=GridObj.cells(i, GridObj.getColIndexById("EMPLOYEE_NO")).getValue();
	    	var a2=GridObj.cells(i, GridObj.getColIndexById("USER_NAME_LOC")).getValue();
	    	var a3=GridObj.cells(i, GridObj.getColIndexById("DEPT")).getValue();
	    	var a4=GridObj.cells(i, GridObj.getColIndexById("DEPT_NAME")).getValue();
	    	var a5=GridObj.cells(i, GridObj.getColIndexById("DEPT_NAME")).getValue();
	    	var a6=GridObj.cells(i, GridObj.getColIndexById("POSITION_NAME")).getValue();
	    	var a7=GridObj.cells(i, GridObj.getColIndexById("POSITION")).getValue();
	    	var a8=GridObj.cells(i, GridObj.getColIndexById("MANAGER_POSITION_NAME")).getValue();
	    	var a9=GridObj.cells(i, GridObj.getColIndexById("FUNCTION")).getValue();
	    	var a10=GridObj.cells(i, GridObj.getColIndexById("DEL_TYPE")).getValue();
	    	var a11=GridObj.cells(i, GridObj.getColIndexById("TYPE")).getValue();
	    	
	    	text += a1 +" @ "+ a2 +" @ "+ a3 +" @ "+ a4 +" @ "+ a5 +" @ "+ a6 +" @ "+ a7 +" @ "+ a8 +" @ "+ a9 +" @ "+ a10 +" @ "+ a11 +" @ ";
	    	alert(text);
	    }
      */  
    
    
    	var from = "<%=from %>";
		var sign_string = "";
		//var ARGENT_FLAG = document.forms[0].ARGENT_FLAG.checked;
//		var remark = document.forms[0].remark.value;
		var remark = "";
	    var cnt1 = 0;
	    var cnt2 = 0;
	    	
		if (GridObj.getRowsNum() == 0){
			alert("<%=text.get("PU_129_1.MSG_0100")%>"); //결재순서를 지정해주세요
			return;
		}
//		var app_person 				= SepoaGridGetCellValueIndex(document.WiseGrid,0,INDEX_SIGN_USER_ID);
		var app_person				= "";
		
		var SIGN_PATH_SEQ 						= "";	//결재순서
		var EMPLOYEE_NO							= "";	//결재자 사번
		var USER_NAME_LOC 						= "";	//결재자 명
		//var DEPT 								= "";	//결재자 부서코드
		//var DEPT_NAME 							= "";	//결재자 부서명
		//var POSITION							= "";	//결재자 직위코드
		//var POSITION_NAME						= "";	//결재자 직위명
		//var FUNCTION							= "";	//결재자 직책코드
		//var MANAGER_POSITION_NAME				= "";	//결재자 직책
		
		var Sign_Path 							= "";	//결재선 목록
		
		
		var proceeding_flag 		= "P";	//요청상태
		var sign_user_id			= "";

//		if(ARGENT_FLAG == true) {
//			document.forms[0].ARGENT_FLAG_VALUE.value = "T";
//		}else{
//			document.forms[0].ARGENT_FLAG_VALUE.value = "F";
//		}
	
//		var ARGENT_FLAG = document.forms[0].ARGENT_FLAG_VALUE.value;	//긴급여부 체크박스
		var ARGENT_FLAG = "";
		
//		if(app_person == ""){
//			alert("<%=text.get("PU_129_1.MSG_0101")%>"); //결재자를 지정해주세요
//			return;
//		}


//	    SignPathSeqSetting();
	
	    var sps = new Array(GridObj.getRowsNum());

		for(var i=0; i<GridObj.getRowsNum();i++)
		{
		
			var SIGN_PATH_SEQ 						= "";	//결재순서
			var EMPLOYEE_NO							= "";	//결재자 사번
			var USER_NAME_LOC 						= "";	//결재자 명
			//var DEPT 								= "";	//결재자 부서코드
			//var DEPT_NAME 							= "";	//결재자 부서명
			var POSITION							= "";	//결재자 직위코드
			//var POSITION_NAME						= "";	//결재자 직위명
			var FUNCTION							= "";	//결재자 직책코드
			//var MANAGER_POSITION_NAME				= "";	//결재자 직책
		
		
			SIGN_PATH_SEQ 			= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).getValue();			//결재순서
			EMPLOYEE_NO 			= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("EMPLOYEE_NO")).getValue();			//결재자 사번
			USER_NAME_LOC 			= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("USER_NAME_LOC")).getValue();			//결재자 명
			//DEPT 					= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("DEPT")).getValue();					//결재자 부서코드
			//DEPT_NAME 				= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("DEPT_NAME")).getValue();				//결재자 부서명
			//POSITION 				= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("POSITION")).getValue();				//결재자 직위코드
			//POSITION_NAME 			= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("POSITION_NAME")).getValue();			//결재자 직위명
			//FUNCTION 				= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("FUNCTION_CODE")).getValue();			//결재자 직책코드
			//MANAGER_POSITION_NAME 	= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("MANAGER_POSITION_NAME")).getValue();	//결재자 직책


			if (EMPLOYEE_NO == "") continue;
			if (SIGN_PATH_SEQ == "") continue;
	
			//결재선 넘기는 값 (요청순번,사번,직위코드,직책코드)
			if(SIGN_PATH_SEQ == "1"){
			    sps[0]                 = SIGN_PATH_SEQ +" ,"+EMPLOYEE_NO +" #";
			}
			else{
			    sps[SIGN_PATH_SEQ - 1] = SIGN_PATH_SEQ +" ,"+EMPLOYEE_NO +" #";
			}
			
			//STRING TOKEZING
//	        if(sign_path_seq == "1"){
//			    sps[0]                 = sign_path_seq +" #"+sign_user_id +" #"+ position_code +" #"+ manager_position_code +" #"+ proceeding_flag +" #"+"Y"+" #$";
//			}
//			else{
//			    sps[sign_path_seq - 1] = sign_path_seq +" #"+sign_user_id +" #"+ position_code +" #"+ manager_position_code +" #"+ proceeding_flag +" #"+"N"+" #$";
//			}

	
//	        if(proceeding_flag == "C") {
//	            cnt1++;
//	        }
//	        if(proceeding_flag == "P") {
//	            cnt2++;
//	        }
		}
	
	    for( j=0; j<sps.length; j++ ){
	        Sign_Path += sps[j];
			//alert(Sign_Path);
	    }
	
//	    if(cnt1 > 2){
//	        alert("<%=text.get("PU_129_1.MSG_0102")%>"); //합의자는 2명까지 지정할 수 있습니다.
//	        return;
//	    }
//	    if(cnt2 > 5){
//	        alert("<%=text.get("PU_129_1.MSG_0103")%>"); //결재자는 5명까지 지정할 수 있습니다.
//	        return;
//	    }

	<% if ( from.equals("P") ) {	//from은 카드처리에서 결재선지정으로 하드코딩 P로 넘어왔다
	%>
			//opener.window.focus();
			parent.window.focus();
		    opener.parent.<%=fnc_name%>(Sign_Path);
		    window.close();
	<% } else {  %>
			//opener.window.focus();
			parent.window.focus();
		    opener.parent.<%=fnc_name%>("UrgentFlag==="+ARGENT_FLAG+"|||SignUserId==="+app_person+"|||SignRemark==="+remark+"|||auto_flag===<%=auto_flag%>|||strategy===|||Sign_Path==="+Sign_Path);
		    window.close();
	<% }         %>
	}
     
    function doQuery2(app_no)
	{	 
		var grid_col_id = "<%=grid_col_id%>"; 
		 
<%-- 		GridObj.loadXML("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.app_aproval_list3?mode=query&grid_col_id="+grid_col_id+"&app_no="+app_no);																						 --%>
		GridObj.loadXML("<%=POASRM_CONTEXT_NAME%>/servlets/contract.app_aproval_list3?mode=query&grid_col_id="+grid_col_id+"&app_no="+app_no);																						

  		GridObj.clearAll(false);																																											
	}
</script>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="init();">
<s:header popup="true">
<form  id="form" name="form1">
<input type="hidden" name="row" value="">
<input type="hidden" name="seq_chg" value="">
<input type="hidden" size="15" name="doc_type" value="<%=doc_type%>" readOnly>
<input type="hidden" size="15" name="req_user_id" value="<%=req_user_id%>">
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "평가자 지정";
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "true";
%>
<%@ include file="/include/sepoa_milestone.jsp"%>


<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
     	<td height="5"> </td>
  </tr>
  <tr width="100%" > 
     	<td width="100%" class=table>
     		<iframe id="userframe" name="userframe" src="approval_user4.jsp?DEPT=<%=dept_code%>&DEPT_NAME=''" width="620" height="300" marginwidth="0" marginheight="0" scrolling="no" frameborder='no' ></iframe>
     	</td>
  </tr>
  
  
  <tr>
    <td width="100%" valign="top" colspan="2">
	  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
		  <TR>
			<td align="left" style="padding:5 0 5 0">
			<TABLE cellpadding="2" cellspacing="0">
			  <TR>
			  
			  <TD><script language="javascript">btn("javascript:doMoveRowUp()","위로이동")</script></TD>	
			  <TD><script language="javascript">btn("javascript:doMoveRowDown()","아래로이동")</script></TD>	
			  <%--
			  <TD><script language="javascript">btn("javascript:doQuery()","초기화")</script></TD>
				<TD><script language="javascript">btn("javascript:doDeleteRow2()","<%=text.get("BUTTON.deleted")%>")</script></TD>	<!-- 삭제 -->
				--%>
				<TD><script language="javascript">btn("javascript:doDeleteRow()","<%=text.get("BUTTON.deleted")%>")</script></TD>	<!-- 삭제 -->
	   			<TD><script language="javascript">btn("javascript:doFinalApproval()","<%=text.get("BUTTON.save")%>")   </script></TD>	<!-- 저장 -->
	   			<TD><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>")</script></TD>	<!-- 닫기 -->
			     </TR>
			</TABLE>
			</td>
		  </TR>
		</TABLE>
		<s:grid screen_id="PU_129_2" grid_box="gridbox" grid_obj="GridObj"/>
<!-- 		<div id="gridbox" name="gridbox" width="100%" style="background-color:white;overflow:hidden"></div> -->
<!--         <div id="pagingArea"></div> -->
<%--         <%@ include file="/include/include_bottom.jsp"%>  --%>
	</td>
  </tr>
</table>
</form>

<%-- <jsp:include page="/include/window_height_resize_event.jsp" > --%>
<%-- <jsp:param name="grid_object_name_height" value="gridbox=380"/> --%>
<%-- </jsp:include> --%>

</s:header>
<s:footer/>
</body>
</html>
