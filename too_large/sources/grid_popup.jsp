<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Main</title>



<%-- <script type="text/javascript" src="../js/lib/cssrefresh.js"></script> --%>
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
	String house_code = request.getParameter( "house_code" );
    String company_code = request.getParameter( "company_code" );
    String function = request.getParameter( "function" );
    String type = request.getParameter( "type" );
    String query = request.getParameter( "query");
    String arg = request.getParameter( "arg" );
    
	if ( house_code == null ) 		house_code = info.getSession( "HOUSE_CODE" );
	if ( company_code == null ) 	company_code = info.getSession( "COMPANY_CODE" );
	if ( query == null ) 			query = "Y";
	if ( arg == null ) 				arg = "Y";

    Logger.debug.println(info.getSession("ID"),"function=======>>"+function);
    
    //제목 불러오기
	Object[] obj = {house_code, company_code, type};
	String nickName = "CO_012";
	String conType = "CONNECTION";
	String methodName = "getEPCodeMaster";
	SepoaRemote w_remote = null;
	SepoaOut value = null;
	try {
			w_remote = new SepoaRemote(nickName, conType,info);
			value = w_remote.lookup(methodName, obj);
	}catch(Exception e){
        Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
        Logger.debug.println(info.getSession("ID"),"message = " + value.message);
        Logger.debug.println(info.getSession("ID"),"status = " + value.status);
	}
	finally
	{
   	    try{
 		    
			w_remote.Release();
			
		}catch(Exception e){
			Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
		}
	}
	
    String  masterDescription   ="" ;
    if(value.status == 1) { // 성공적으로 조회

		SepoaFormater wf = new SepoaFormater(value.result[0]);

		for(int i=0; i<wf.getRowCount(); i++)
		{
			masterDescription = wf.getValue(i,1);
			masterDescription += "(" + wf.getValue(i,2) + ")";
		}
	}
  
%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language=javascript src="../js/lib/sec.js"></script><!-- 폴더 위치 변경됨,파일 추가됨 -->

<script language="javascript" src="../js/lib/jslb_ajax.js"></script><!-- 폴더 위치 변경됨 -->

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><!-- 파일 추가됨 -->


<script language="javascript">
var GridObj = null;

	function setGridDraw()
    {
    	<%-- <%=grid_obj%>_setGridDraw(); --%>
    	//그리드 초기화 정보는 DB에서 가져오지 않고, 직접 구현하기 때문에 임의의 함수로 재정의 해서 사용한다.
    	GridObj_setGridDraw_custom();
    	
    	
    	GridObj.setSizes();
    }
	function GridObj_setGridDraw_custom()
    {
    	//GridObj = new dhtmlXGridObject('gridbox');
    	GridObj = new SepoaDhtmlXGridObject('gridbox');	// dhtmlXGridObject 생성자 함수를 sepoa_dhtmlXGridObject함수에서 상속받아서 사용한다.
		GridObj.setImagePath("/dhtmlx/dhtmlxGrid/codebase/imgs/");
    	
    	//밑의 값들은 들어오는 매개변수에 따라 변경시킨다.
		GridObj.setHeader("Code,Description1,Description2");
		GridObj.setInitWidths("200,200,200");
	    GridObj.setColAlign("center,center,center");
		GridObj.setColumnIds("code,text1,text2");
	    GridObj.setColumnColor("");
		GridObj.setColSorting("str,str,str");
		GridObj.setColTypes("ro,ro,ro");

		GridObj.setColumnMinWidth(50,0);

		GridObj.attachEvent("onRowSelect",doOnRowSelected);
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

    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, GridObj.getColIndexById("code")).getValue());
    	var code = GridObj.cells(rowId, GridObj.getColIndexById("code")).getValue();
    	var desc1 = GridObj.cells(rowId, GridObj.getColIndexById("text1")).getValue();
    	var desc2 = GridObj.cells(rowId, GridObj.getColIndexById("text2")).getValue();
    	var type = "<%=type%>";
<%
    	out.println("parent.opener."+function+"( code, desc1, desc2, type );" );
%>
		parent.close();
    }

    function doQuery()
	{
        var grid_col_id = "<%=grid_col_id%>";
        
        var param = "house_code="+"<%=house_code%>";
        param += "&company_code="+"<%=company_code%>";
        param += "&type="+"<%=type%>";
        param += "&pCode="+document.form.code.value;
        param += "&pDescription="+document.form.description.value;
        param += "&mode=grid_popup_query&grid_col_id="+grid_col_id;

        //alert("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.util.grid_popup?"+param);
        GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.util.grid_popup",param);
		GridObj.clearAll(false);
	}

	function initAjax(){
		//doRequestUsingPOST( 'SL5001', 'M200' ,'type', '' );
	}

	function doSaveEnd(obj)	{	
		//
	}
	function doOnCellChange(){
		//이 함수가 없으면 에러난다.	
	}

</script>
<!-- JSP내용 추가 end _______________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->
</head>
<body onload="initAjax();setGridDraw();doQuery();">
<s:header popup='true'>
<!--타이틀시작--> 
<!--//타이틀끝--> 

<!--내용시작-->
<div class="wrap_cont">

<!-- JSP내용 추가 start _____________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->
<form name="form">
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
	<div style="float:left;">
		<span class='title_td'>Code Like</span>
		<span class='data_td'><input type="text" name="code" size="20" class="inputsubmit"></span>
		<span class='title_td'>Description Like</span>
		<span class='data_td'><input type="text" name="description" size="20" class="inputsubmit"></span>
	</div>
	<div class='floatR'>
		<script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>");  </script>	<!-- 조회 -->
	</div>
	<div>
		<%-- <%@ include file="/include/include_bottom.jsp"%> --%>
	</div>

</div>
<%-- 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td height="5"></td>
	</tr>
	<tr>
		<td width="100%" align="left" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td>
			  			<%@ include file="/include/sepoa_milestone.jsp"%>
			  		</td>
				</tr>
			</table>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td height="5"></td></tr>
			</table>
			
			<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center" bgcolor="#DBDBDB">
		    <tr>
		      	<td class="title_td">Code Like</td>
		      	<td class="data_td">
		        	<input type="text" name="code" size="20" class="inputsubmit">
		      	</td>
		      	<td class="title_td">Description Like</td>
		      	<td class="data_td">
		        	<input type="text" name="description" size="20" class="inputsubmit">
		      	</td>
		    </tr>
		  	</table>
			
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			<TD><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>");  </script></TD>
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
			<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
			<div id="pagingArea"></div>
			<%@ include file="/include/include_bottom.jsp"%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			<TD><script language="javascript">btn("javascript:SetEmpty()","<%=text.get("BUTTON.initialization")%>");</script></TD><!-- 초기화 -->
								<TD><script language="javascript">btn("javascript:parent.window.close()","<%=text.get("BUTTON.close")%>");</script></TD><!-- 닫기 -->
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
		</td>
	</tr>
	</table> --%>
</form>
<!-- JSP내용 추가 end _______________________________________________________________________________________________ -->
<!-- ______________________________________________________________________________________________________________ -->
</div>
  <!-- Body End--> 
  <!-- Footer Start-->
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<div class='floatR'>
	<script language="javascript">btn("javascript:parent.window.close()","<%=text.get("BUTTON.close")%>");</script><!-- 닫기 -->
</div>  
<s:footer/>
  <!-- Footer End-->
</body>
</html>