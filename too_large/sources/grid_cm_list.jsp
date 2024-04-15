<%--
공통팝업 - as of 13.11.11 ysh

개요 : 

1단계 : SP 와 MP로 구분된다.
SP는 하나만 선택 가능하고, MP는 2개 이상 선택 가능하다.
SP는 그리드 셀을 클릭해서 선택하는 방식이고,
MP는 좌측의 selected 체크 박스로 선택해서 [추가]버튼을 누르는 방식이다.(배열로 전달)

2단계 : 넘겨받는 value값에 따라서 사용자가 검색어입력이 가능할 수도 있고, 불가능 할 수도 있다.(검색어를 입력할 수 있는 부분이 감춰진다.)

3단계 : 넘겨받는 desc값에 따라서 넘겨받은 desc값으로 표시될 수 있고, 기본값으로 표시될 수도 있다. 

select * from slang where SCREEN_ID = 'P40_OEP' 의 결과로 3라인이 필요하다.
아래 추가
Insert into slang (SCREEN_ID,LANGUAGE,CODE,TYPE,CONTENTS,ADD_USER_ID,ADD_DATE,ADD_TIME,CHANGE_USER_ID,CHANGE_DATE,CHANGE_TIME,DEL_FLAG,COL_TYPE,COL_FORMAT,COL_WIDTH,COL_MAX_LEN,COL_ALIGN,COL_VISIBLE,SELECTED_YN,COL_SEQ,COL_COLOR,COL_COMBO,COL_SORT) values ('P40_OEP','KO','code','B','Code','Admin','20131106','171503',null,null,null,'N','ro',null,'200','200','center','true',null,1,'Lcolor',null,'str');
Insert into slang (SCREEN_ID,LANGUAGE,CODE,TYPE,CONTENTS,ADD_USER_ID,ADD_DATE,ADD_TIME,CHANGE_USER_ID,CHANGE_DATE,CHANGE_TIME,DEL_FLAG,COL_TYPE,COL_FORMAT,COL_WIDTH,COL_MAX_LEN,COL_ALIGN,COL_VISIBLE,SELECTED_YN,COL_SEQ,COL_COLOR,COL_COMBO,COL_SORT) values ('P40_OEP','KO','text1','B','Description1','Admin','20131106','171503',null,null,null,'N','ro',null,'200','200','center','true',null,2,'Lcolor',null,'str');
Insert into slang (SCREEN_ID,LANGUAGE,CODE,TYPE,CONTENTS,ADD_USER_ID,ADD_DATE,ADD_TIME,CHANGE_USER_ID,CHANGE_DATE,CHANGE_TIME,DEL_FLAG,COL_TYPE,COL_FORMAT,COL_WIDTH,COL_MAX_LEN,COL_ALIGN,COL_VISIBLE,SELECTED_YN,COL_SEQ,COL_COLOR,COL_COMBO,COL_SORT) values ('P40_OEP','KO','text2','B','Description2','Admin','20131106','171503',null,null,null,'N','ro',null,'200','200','center','true',null,3,'Lcolor',null,'str');

 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Main</title>

<!-- JSP내용 추가 start _____________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("P40_OEP");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "P40_OEP";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	////////////////////////////////
	String code 	= request.getParameter("code");														// 검색 조건1
    String function	= request.getParameter("function") == null ? "" : request.getParameter("function"); // 팝업에서 리스트 선택시 부모창에서 실행할 함수를 받아와서 여기서 실행한다.
    String width 	= request.getParameter("width") == null ? "540" : request.getParameter("width");	// 윈도우창 너비
    
    String[] values = request.getParameterValues("values");												// 검색 조건2
  	//decode 작업
  	if(values != null){  	
	  	for(int index = 0 ; index < values.length ; index++){
	  		values[index] =  java.net.URLDecoder.decode(values[index],"UTF-8");
	  	}
  	}
    String[] desc 	= request.getParameterValues("desc");												// 검색어(화면 상단에 표시할 텍스트)
    //decode 작업
	if(desc != null){
		for(int index = 0 ; index < desc.length ; index++){
			desc[index] =  java.net.URLDecoder.decode(desc[index],"UTF-8");
		}
	}
    String reject 	= request.getParameter("reject");
    
    String flag = "N";		// Y: 검색어를 화면에 표시, N: 검색어를 화면에 표시 하지 않음(사용자가 입력해서 검색 할 수 있는지 유무)
    String auto_flag = "";	// 팝업이 뜨자마자 자동으로 조회 될것인지 말것인지 구분
    String visibleYN	= request.getParameter("visibleYN");											// 새로 추가함
    if(visibleYN != null & "Y".equals(visibleYN)){
    	flag = "Y";
    	auto_flag = "Y";
    }
    
    /*
     * Single POPUP인지, Multi POPUP인지 구분 ______________________________________________________
     */
   	Object[] obj = {code};
	String nickName = "CO_012";
	String conType = "CONNECTION";

	String methodName = "getCodeFlag";
	SepoaRemote wr_type = null;
	SepoaOut type = null;
	SepoaOut column = null;
    
   	try
   	{
		wr_type = new SepoaRemote(nickName, conType,info);
		type = wr_type.lookup(methodName, obj);
		Logger.debug.println(info.getSession("ID"),"message = " + type.message);
   		Logger.debug.println(info.getSession("ID"),"status = " + type.status);
	} catch(Exception e) {
        Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
        Logger.debug.println(info.getSession("ID"),"message = " + type.message);
        Logger.debug.println(info.getSession("ID"),"status = " + type.status);
	} finally {
		wr_type.Release();
	}
    
	//Flag값을 가져온다. SP(SinglePOPUP)/MP(MultiPOPUP)
	SepoaFormater wf = new SepoaFormater(type.result[0]);	// 예) FLAG:SP, TEXT5:Y
	String s_type = wf.getValue("FLAG",0);								
	//팝업이 뜨자마자 자동으로 조회 될것인지 말것인지 구분
	auto_flag = wf.getValue("TEXT5",0);
	if(auto_flag.length() == 0) 
		auto_flag = "Y";

	if (values != null)  {	// values 파라미터값이 있을 경우
		for (int i = 0; i<values.length; i++)  {
			if (values[i] == null) 
				values[i] = "";
			if(values[i].length() == 0 || values[i].endsWith("/") ) 
			    flag = "Y";
		}
	
	    if ( values[values.length - 1].endsWith("/"))	//마지막 values값이 /로 끝나는 경우
	    {
	    	if (values[values.length - 1].length() == 1){		// 값이 "/"인 경우
	    		values[values.length - 1] = "";
	    	}else{ 												// 값이 "AAA/인" 경우(뒤의 /를 삭제한다.)
	    		values[values.length - 1] = values[values.length - 1].substring(0, values[values.length - 1].length() - 1);
	    	}
	    }
	    
    }else{
		//조회조건이 없는 팝업은 무조건 자동 조회다.(N이 아닐경우만)
    	values = new String[2];
    	values[0] = "";
    	values[1] = "";
    	if(!"N".equals(auto_flag)){
	    	auto_flag = "Y";
    	}
    }
    
	//자동,수동 조건은 매개변수로도 넘길 수 있다.
	auto_flag = request.getParameter("auto_flag") == null ? auto_flag : request.getParameter("auto_flag");	
	
	// desc 가 없으면 기본값 사용
	if(desc == null){
		desc = new String[2];
		desc[0] = "Code";
		desc[1] = "Name";
	}else{
		for (int i = 0; i<desc.length; i++)  {
			if (desc[i] == null || "".equals(desc[i])){
				if(i == 0){
					desc[i] = "Code";
				}else if(i == 1){
					desc[i] = "Name";
				}
			}
		}
	}
   	
    /*
     * (화면 상단 - 페이지 title) ______________________________________________________
     */
	String methodName2 = "getCodeMaster";
	SepoaRemote wr_title2 = null;
	SepoaOut title2 = null;

	try
	{
		wr_title2 = new SepoaRemote(nickName, conType,info);
		title2 = wr_title2.lookup(methodName2, obj);
		Logger.debug.println(info.getSession("ID"),"message = " + title2.message);
		Logger.debug.println(info.getSession("ID"),"status = " + title2.status);
	} catch(Exception e) {
        Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
        Logger.debug.println(info.getSession("ID"),"message = " + title2.message);
        Logger.debug.println(info.getSession("ID"),"status = " + title2.status);
	} finally {
		wr_title2.Release();
	}
	
	String masterDescription   ="" ;

	if(title2.status == 1) { // 성공적으로 조회
		SepoaFormater wf2 = new SepoaFormater(title2.result[0]);
		
		for(int i=0; i<wf2.getRowCount(); i++)
		{
			masterDescription  = wf2.getValue(i,2);
			masterDescription += "(" + wf2.getValue(i,1) + ")";
        }
	}
     
   	
    /*
     * 컬럼정보조회 - 컬럼의 헤더명 ______________________________________________________
     */
	String methodName3 = "getCodeColumn";
	SepoaRemote wr_column3 = null;
	SepoaOut column3 = null;
	try 
	{
		wr_column3 = new SepoaRemote(nickName, conType, info);
		column3 = wr_column3.lookup(methodName3, obj);
	} catch(Exception e) {
        Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
	} finally {
		wr_column3.Release();
	}
	SepoaFormater wf3 = new SepoaFormater(column3.result[0]);
	String tmp = wf3.getValue("TEXT3",0);		// 예) 고객번호#고객이름
	SepoaStringTokenizer st_column = new SepoaStringTokenizer(tmp,"#");
	int st_count = st_column.countTokens();				//컬럼의 개수
	ArrayList<String> colHeaderNames	= new ArrayList<String>();

	if (st_count != 0) {
		for(int j = 0; j<st_count; j++)  {
			colHeaderNames.add(st_column.nextToken());
		}
	}else{			
		//st_count == 0이면, 즉, DB에서 아무값도 가져오지 못했을때 기본값으로 셋팅
		st_count = 3;
		colHeaderNames.add("Code");
		colHeaderNames.add("Description(1)");
		colHeaderNames.add("Description(2)");
	}
%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language=javascript src="../js/lib/sec.js"></script><!-- 폴더 위치 변경됨,파일 추가됨 -->

<script language="javascript" src="../js/lib/jslb_ajax.js"></script><!-- 폴더 위치 변경됨 -->

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><!-- 파일 추가됨 -->


<Script language="javascript">
var GridObj = null;

	function setGridDraw()
    {
    	<%-- <%=grid_obj%>_setGridDraw(); --%>
    	//그리드 초기화 정보는 DB에서 가져오지 않고, 직접 구현하기 때문에 임의의 함수로 재정의 해서 사용한다.
    	GridObj_setGridDraw_custom();
    	GridObj.setSizes();
    
    	<%	if("Y".equals(auto_flag)){ %>
    		setTimeout(doQuery,500);		
    	<%	}%>
    }
	function makeRepeatString(str,endWith){
		if(endWith == null){
			endWith = false;	//기본값으로 사용하지 않는다.
		}else{
			endWith = true;		//true이면, 뒤에 한자리 숫자를 0부터 증가시키면서 덧붙인다.(columnIds로 사용하기 위해 unique로 만들어야 한다.)
		}
		var result = "";
		for(var i = 0 ; i < <%=st_count%> ; i++){		//헤더의 개수만큼
			if(endWith){
				result += str+i+",";		//str0,str1,str2
			}else{
				result += str+",";			//str,str,str
			}
		}
		return result.substring(0, result.length-1);	//뒤에 붙는 콤마는 제외
	}
	function GridObj_setGridDraw_custom()
    {
    	GridObj = new SepoaDhtmlXGridObject('gridbox');	// dhtmlXGridObject 생성자 함수를 sepoa_dhtmlXGridObject함수에서 상속받아서 사용한다.
		GridObj.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/imgs/");
<%
grid_header_style = "";
grid_col_color    = "";

for(int k = 0; k < colHeaderNames.size(); k++){
	grid_header_style  = grid_header_style + "'background-color:#dddee1;height: 20px;',";
	grid_col_color     = grid_col_color + "white,";
}

if(grid_header_style.length() > 0){
	grid_header_style = grid_header_style.substring(0, grid_header_style.length() - 1);
	grid_col_color    = grid_col_color.substring(0, grid_col_color.length() - 1);
}
%>
		 <%if("SP".equals(s_type)){%>
    		//싱글팝업
    		
	    	//밑의 값들은 들어오는 매개변수에 따라 변경시킨다.
			//GridObj.setHeader("<%=colHeaderNames.toString().substring(1, colHeaderNames.toString().length()-1)%>");		//"Code,Description1,Description2" //앞뒤 대괄호[]를 삭제한다.
			GridObj.setHeader("<%=colHeaderNames.toString().substring(1, colHeaderNames.toString().length()-1)%>", null, [<%=grid_header_style%>]);
			GridObj.setInitWidths(makeRepeatString("130"));
		    GridObj.setColAlign(makeRepeatString("center"));			//"center, center, center"
		    
		    //기본 그리드 특성은 (DB slang에 저장된 column name과 sql 쿼리의 별칭(alias)이 같아야 값이 그리드 셀에 대입이 된다.)
		    //그런데 공통팝업에 사용되는 쿼리에는 별칭을 사용하지 않고 있으며, 공통적인 DB slang도 사용하지 않기에
		    //임의의 text0, text1, text2 와 같이 단지 unique한 column name을 지정한 후 데이터를 순차적으로 대입하는 방식을 사용하였다.
			GridObj.setColumnIds(makeRepeatString("text",true));				//"text0,text1,text2"
		    GridObj.setColumnColor("<%=grid_col_color%>");
			GridObj.setColSorting(makeRepeatString("str"));				//"str,str,str"
			GridObj.setColTypes(makeRepeatString("ro"));				//"ro,ro,ro"
	
			GridObj.setColumnMinWidth(50,0);
	
			GridObj.attachEvent("onRowSelect",doOnRowSelected);
		
		<%}else{%>
			//멀티 팝업
			//GridObj.setHeader("선택,<%=colHeaderNames.toString().substring(1, colHeaderNames.toString().length()-1)%>");		//"선택,Code,Description1,Description2" //앞뒤 대괄호[]를 삭제한다.
			GridObj.setHeader("선택,<%=colHeaderNames.toString().substring(1, colHeaderNames.toString().length()-1)%>", null, [<%=grid_header_style%>]);		//"선택,Code,Description1,Description2" //앞뒤 대괄호[]를 삭제한다.
			GridObj.setInitWidths("40,"+makeRepeatString("200"));				//"200,200,200"
		    GridObj.setColAlign("center,",makeRepeatString("center"));			//"center, center, center"
		    
		    //기본 그리드 특성은 (DB slang에 저장된 column name과 sql 쿼리의 별칭(alias)이 같아야 값이 그리드 셀에 대입이 된다.)
		    //그런데 공통팝업에 사용되는 쿼리에는 별칭을 사용하지 않고 있으며, 공통적인 DB slang도 사용하지 않기에
		    //임의의 text0, text1, text2 와 같이 단지 unique한 column name을 지정한 후 데이터를 순차적으로 대입하는 방식을 사용하였다.
			//멀티 팝업의 경우 selected를 앞에 추가해 줘야 한다.
			GridObj.setColumnIds("selected,",makeRepeatString("text",true));		//"selected,text0,text1,text2"
		    GridObj.setColumnColor("");
			GridObj.setColSorting("str,"+makeRepeatString("str"));				//"str,str,str"
			GridObj.setColTypes("ch,"+makeRepeatString("ro"));				//"ro,ro,ro"
	
			GridObj.setColumnMinWidth(50,0);
		 
		<%}%>
		<%=grid_obj%>.attachEvent("onXLS",doQueryDuring);
		<%=grid_obj%>.attachEvent("onXLE",doQueryModalEnd);
		GridObj.setSkin("dhx_skyblue");	//3.6에서 변경해봄

		GridObj.init();
		document.form_footer.setGridDrawEnd.value = 'true';	// 그리드 초기화가 완료되면, 값을 true로 갱신한다.
    }
	function doQueryDuring()
	{
		var dim  = new Array(2);
		var win_width = 190;	//프로그레스바의 너비
		var win_height = 80;	//프로그레스바의 높이
 		var gridbox_temp = document.getElementById('gridbox');
 		var content_temp = document.getElementById('content');
		var content_temp_height="";
 		if(content_temp == null){	//popup일때 content가 없다.
 			content_temp_height = BwindowHeight();	//content 대신 창 전체 높이
 		}else{
 			content_temp_height = content_temp.offsetHeight;	//content의 높이 
 		}
 		var left = (parseInt(gridbox_temp.style.width) - win_width)/2;	//gridbox_temp.style.width 값에서 'px'문자를 제거하기 위해 parseInt함수를 사용.
 		var top = parseInt(content_temp_height) - parseInt(gridbox_temp.offsetHeight)/2 - win_height;
  		/* var left = (BwindowWidth() - parseInt(treebox.style.width) - win_width)/2;	
		var top  = (BwindowHeight() - win_height)/2; */  
		if(dhxWins == null) {
        	dhxWins = new dhtmlXWindows();
        	//dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxWindows/codebase/imgs/");
        	dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/imgs/");
  			dhxWins.enableAutoViewport(false);		//추가함
  			if(content_temp != null){	//popup일때 content가 없다.
			    dhxWins.attachViewportTo("content");	//추가함 - div id가 content인 영역안에서 window 효과를 나타낸다. (setModal 효과를 JSP내용안으로만 한정하기 위해)
  	 		}
        }
		if(prg_win == null) {
//			prg_win = dhxWins.createWindow("prg_win", left, top, 180, 73);
			//prg_win = dhxWins.createWindow("prg_win", left, top, win_width, win_height);
			prg_win = dhxWins.createWindow("prg_win", left, top, win_width, win_height);
			
			prg_win.setText("Please wait for a moment.");
			prg_win.button("close").hide();
			prg_win.button("minmax1").hide();
			prg_win.button("minmax2").hide();
			prg_win.button("park").hide();
			dhxWins.window("prg_win").setModal(true);
			prg_win.attachURL("<%=POASRM_CONTEXT_NAME%>/common/progress_ing.htm");
		} else {
			dhxWins.window("prg_win").setPosition(left,top);		//위치 이동 추가함
			dhxWins.window("prg_win").setModal(true);
		    dhxWins.window("prg_win").show();
		}
		<% if(!isRowsMergeable) { %>
	    	<%=grid_obj%>.enableSmartRendering(true);
	    <% } %>
		return true;
	}
	function doQueryModalEnd(GridObj, RowCnt)
	{
		var msg = GridObj.getUserData("", "message");
		
		if(dhxWins == null) {
        	dhxWins = new dhtmlXWindows();
        	//dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dthmlx/dhtmlxWindows/codebase/imgs/");
        }

		if(prg_win == null) {
			var top = BwindowWidth()/2 - 180;
			var left  = BwindowHeight()/2 - 73;
		
			prg_win = dhxWins.createWindow("prg_win", top, left, 180, 73);
			prg_win.setText("Please wait for a moment.");
			prg_win.button("close").hide();
			prg_win.button("minmax1").hide();
			prg_win.button("minmax2").hide();
			prg_win.button("park").hide();
			dhxWins.window("prg_win").setModal(true);
			prg_win.attachURL("<%=POASRM_CONTEXT_NAME%>/common/progress_ing.htm");
		}

		dhxWins.window("prg_win").setModal(false);
		dhxWins.window("prg_win").hide();
		dhtmlx_modal_cnt++;

		dhtmlx_end_row_id = GridObj.getRowsNum();
	    //document.getElementById("message").innerHTML = msg + " Rows : " + GridObj.getRowsNum();

		//document.formstyle.csvBuffer.value = GridObj.getUserData("", "excel_data");

		//조회 화면 전용일 경우에는 PageNavigation을 하지 않기 때문에 dhtmlx_end_row_id이 전체행의 값입니다.
		//<% if(isSelectScreen) { %>
		//	    dhtmlx_end_row_id = GridObj.getRowsNum();
		//	    document.getElementById("message").innerHTML = msg + " Rows : " + GridObj.getRowsNum();
		//<% } else { %>
		//	document.getElementById("message").innerHTML = msg;

		//	if(GridObj.getRowsNum() <= <%=page_count%>) {
		//		dhtmlx_end_row_id = GridObj.getRowsNum();
		//	} else {
		//		var page_cnt = parseInt("<%=page_count%>");
		//		dhtmlx_end_row_id = page_cnt;
		//	}
		//<% } %>

		dhtmlx_last_row_id = GridObj.getRowsNum();
		return true;
	}

	function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");

		if(status == "false") alert(msg);
		return true;
    }

	//SP일때 값 넘기기
    function doOnRowSelected(rowId,cellInd)
    {
    	var col0 = "";
    	var col1 = "";
    	var col2 = "";
    	var col3 = "";
    	var col4 = "";
    	var col5 = "";
    	var col6 = "";
    	var col7 = "";
    	var col8 = "";
    	var col9 = "";
<%    	
    	for(int i = 0 ; i < st_count ; i++){
    		out.println("col"+i+" = GridObj.cells(rowId, "+i+").getValue();");
    	}

		if (function.equals("D")) {
			out.println("parent.opener."+code+"_getCode( col0,col1,col2,col3,col4,col5,col6,col7,col8,col9 );" );
		}else if(!function.equals("N")){
    		out.println("parent.opener."+function+"( col0,col1,col2,col3,col4,col5,col6,col7,col8,col9 );" );
		}
    	
%>
		parent.close();
    }
  	//MP일때 값 넘기기
    function doReturnForMP(){
		if(!checkRows()) return;

		var grid_array = getGridChangedRows(GridObj, "selected");	//선택된 그리드 행번호 배열

		var result = new Array(grid_array);
		for(var i = 0 ; i < grid_array.length ; i++){	//행 개수
			result[i] = new Array(<%=st_count%>);
			for(var j = 0 ; j < <%=st_count%> ; j++){	//열 개수 
				result[i][j] = GridObj.cells(grid_array[i], j+1).getValue();	//(selected는 제외하므로 j+1로)
			}
		}
		parent.opener.<%=function%>(result);	//배열로 넘긴다.
		parent.close();
    }

    function doQuery()
	{
    	var str = "";
    	for(var i = 0 ; i < <%=values.length%> ; i++){
    		var temp = document.getElementById("values"+i);
    		str += temp.value+",";
    	}
    	str = str.substring(0,str.length-1);	//뒤의 콤마 삭제
    	<%if("SP".equals(s_type)){ %>
        	var grid_col_id = makeRepeatString("text",true);
        <%}else{%>
        	var grid_col_id = "selected,"+makeRepeatString("text",true);
        <%}%>
        
        var param = "code="+"<%=code%>";
        //param += "&values="+"<%=Arrays.toString(values).substring(1, Arrays.toString(values).length()-1) %>";		//배열인 values들을 콤바로 구분해서 보낸다. 앞뒤 대괄호[]는 삭제한다.
        param += "&values="+encodeUrl(str);
        param += "&mode=grid_cm_list_query&grid_col_id="+grid_col_id;

        //alert("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.util.grid_popup?"+param);
        GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.util.grid_popup",param);
		GridObj.clearAll(false);
	}
    

	function checkRows()
	{

		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("MESSAGE.1004")%>");
		return false;
	}

	function initAjax(){
		//doRequestUsingPOST( 'SL5001', 'M200' ,'type', '' );
	}

	function doSaveEnd(obj){	
		//
	}
	function doOnCellChange(){
		//이 함수가 없으면 에러난다.	
	}
	
	function KeyFunction(temp) {
		if(temp == "Enter") {
			if(event.keyCode == 13) {
				doQuery();
			}
		}
	}
</Script>
<!-- JSP내용 추가 end _______________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->
</head>
<body onload="setGridDraw();">
<s:header popup="true">
<!--타이틀시작--> 
<!--//타이틀끝--> 

<!-- JSP내용 추가 start _____________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->
<form name="form" onsubmit="return false">
<!-- <input type='text' name ='width'>
<input type='text' name ='height'> -->
<%
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = masterDescription;
%>

<div>
	<div>
		<%@ include file="/include/sepoa_milestone.jsp"%>
	</div>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>	
	<!-- flag가 Y인 경우 검색어와 텍스트박스를 화면에 보여준다.(사용자가 입력 가능). N일 경우 숨긴다.(value 값은 가져와야 하므로 숨김) -->
<% if("Y".equals(flag)){ %>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<%
		String descName = "";
		int j = 0;
		for(int i = 0 ; i<values.length ; i++){ 	//개발자가 desc를 values 개수보다 적게 입력하는 경우 오류를 방지
		%>
			<% if(!"".equals(values[i])){
			%>
				<input type="hidden" name="values<%=i %>" id="values<%=i %>" size="20" class="inputsubmit" value="<%=values[i]%>">								
			<% }else{ 
					if(j < desc.length){
						descName = desc[j];
					}else{
						descName = "text";
					}
			
					if(j < 2){	//input이 2개 초과되면, 숨긴다. 
			%>
						<td class='title_td'>&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=descName%></td>
						<td class='data_td'><input type="text" style="ime-mode:inactive" name="values<%=i %>" id="values<%=i %>" size="20" class="inputsubmit" value="<%=values[i]%>" onkeydown="JavaScript: KeyFunction('Enter');"></td>
			<%		}else{	%>
						<td class='title_td' style="display:none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=descName%></td>
						<td class='data_td' style="display:none;"><input type="text" name="values<%=i %>" id="values<%=i %>" size="20" class="inputsubmit" value="<%=values[i]%>" onkeydown="JavaScript: KeyFunction('Enter');"></td>												
			<%		}
				j++;
				}
		} %>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
	<div class="floatR">
		&nbsp;&nbsp;<script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>");  </script>	<!-- 조회 -->
	</div>
	<div  style="clear:both;"></div>
<%}else{ %>
	<div>
		<%for(int i = 0 ; i<values.length ; i++){ %>
			<input type="hidden" name="values<%=i %>" id="values<%=i %>" size="20" class="inputsubmit" value="<%=values[i]%>">
		<%} %>
	</div>
<%} %>
	<div>
<%-- 		<%@ include file="/include/include_bottom.jsp"%> --%>
	</div>
	
</div>
</form>
<!-- JSP내용 추가 end _______________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->


  <!-- Body End--> 
  <!-- Footer Start-->
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<div class='floatR'>
		<% if("MP".equals(s_type)){%>
		<script language="javascript">btn("javascript:doReturnForMP()","<%=text.get("BUTTON.add")%>");  </script>	<!-- 추가 -->
		<%} %>
		<script language="javascript">btn("javascript:parent.window.close()","<%=text.get("BUTTON.close")%>");</script><!-- 닫기 -->
</div>
<s:footer/>
<!-- Footer End-->
</body>
</html>