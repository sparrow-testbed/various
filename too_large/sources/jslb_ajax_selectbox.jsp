<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="sepoa.fw.cfg.Configuration" %>
<%@ page import="sepoa.fw.msg.MessageUtil"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.*"%>
<%
	//AJAX Parcing Delimiter
	Configuration AjaxCon = new Configuration();
	String ajax_field = AjaxCon.getString("sepoa.separator.field");
	String ajax_line = AjaxCon.getString("sepoa.separator.line");
	String ajax_poasrm_context_name = AjaxCon.getString("sepoa.context.name");

	//Message
	//Vector ajax_multilang_id = new Vector();
	//ajax_multilang_id.addElement("AJAX");
    //HashMap ajaxtext = MessageUtil.getMessage(info,ajax_multilang_id);
%>

<script language="javascript">
	var insert_blank_line_flag = "";
	var GridObject = null;
//파라미터 생성
function createQueryString(code, param, selectbox_name, default_value) {
	var queryString = "&code=" + code + "&param=" + param+ "&selectbox_name=" + selectbox_name+ "&default_value=" + default_value;
	return queryString;
}


//비동기식으로 사용하던 것을 동기로 바꾼다.
function doRequestUsingPOST(code, param, selectbox_name, default_value, bAsync) {
	var queryString = createQueryString(code, param, selectbox_name, default_value);
	var url = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();


	if ( bAsync == false )
	{	// 동기모드로 실행
		sendRequest(parseResults,queryString,'POST', url , false, false);
	}
	else
	{
		sendRequest(parseResults,queryString,'POST', url , true, false);
	}
}

//동기식
function doRequestUsingPOST_Sync(code, param, selectbox_name, default_value) {
	var queryString = createQueryString(code, param, selectbox_name, default_value);
	var url = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();

	sendRequest(parseResults,queryString,'POST', url , false, false);
}

//비동기식
function doRequestUsingPOST_ASync(code, param, selectbox_name, default_value) {
	var queryString = createQueryString(code, param, selectbox_name, default_value);
	var url = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();


	//	alert(url);
	sendRequest(parseResults,queryString,'POST', url , true, false);
}

//JSP 콤보박스 셋팅
function parseResults(oj) {
    var result = oj.responseText;//Servlet에서 뿌린 리턴값
    var field = "<%=ajax_field%>"; //'▤▥';
    var line = "<%=ajax_line%>"; //'ªº';
    var subStr = result.split(line);//Row단위 딜리미터
	var ooption;//option element
	var selectbox_name = "";//select box id값
	var default_value ="";//기본 셋팅값
	var nodePath;//해당 select box Object
	var finalStr =new Array ;

		//alert(result);
	  for(var i=0 ; i < subStr.length ; i++){

		   if(i==0)
		   {
		   		finalStr = subStr[i].split(field);
		   		selectbox_name = finalStr[0];
		   		default_value = finalStr[1];
	   			nodePath = document.getElementById(selectbox_name);
		   }
		   else
		   {
		   		finalStr = subStr[i].split(field);

		   		/*********
		   		if((selectbox_name == 'select3')){
		   			writeInputBox(finalStr);
		   		}
				*********/

		   		ooption = document.createElement("option");

		   		if(finalStr[1] != null){
		   			ooption.text = finalStr[1].replace(/(^\s*)|(\s*$)/g, "");
		   		}else{
		   			ooption.text = finalStr[1];
		   		}

		   		ooption.value = finalStr[0];
		   		nodePath.add(ooption);//option tag를 한줄 추가한다

		   		if (finalStr[0] == default_value)
		   		{
					ooption.selected = true;//디폴트 값을 지정한다
				}
		   }
	  }//End for
}//End function

function doRequestUsingPOST_Grid(code, param, selectbox_name, default_value, blank_line_flag) {
	insert_blank_line_flag = blank_line_flag;
	var queryString = createQueryString(code, param, selectbox_name, default_value);
	var url = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();

	//alert(url);
//	sendRequest(parseResults_Grid,queryString,'POST', url , true, false);
	/* 2007.06.04 Daguri 마지막 두번째를 true --> false 로 처리 */
	sendRequest(parseResults_Grid,queryString,'POST', url , false, false);
}

function doRequestUsingPOST_dhtmlxGrid(code, param, selectbox_name, default_value, blank_line_flag, combobox) {
	insert_blank_line_flag = blank_line_flag;
	var queryString = createQueryString(code, param, selectbox_name, default_value);
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();

	/* 2007.06.04 Daguri 마지막 두번째를 true --> false 로 처리 */
	sendRequest(parseResults_dhtmlxGrid, queryString,'POST', url , false, false);
}

var currentGridObj = null;
function doRequestUsingPOST_MultidhtmlxGrid(code, param, selectbox_name, default_value, blank_line_flag, Grid_Object) {
	insert_blank_line_flag = blank_line_flag;
	var queryString = createQueryString(code, param, selectbox_name, default_value);
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();
	currentGridObj = Grid_Object;
	sendRequest(parseResults_MultidhtmlxGrid, queryString,'POST', url , false, false);
	GridObject = Grid_Object;
}

//JSP 콤보박스 셋팅
function parseResults_Grid(oj ) {
    var result = oj.responseText;//Servlet에서 뿌린 리턴값
    var field = "<%=ajax_field%>"; //'▤▥';
    var line = "<%=ajax_line%>"; //'ªº';
    var subStr = result.split(line);//Row단위 딜리미터
	var ooption;//option element
	var selectbox_name = "";//select box id값
	var default_value ="";//기본 셋팅값
	var nodePath;//해당 select box Object
	var finalStr =new Array ;

		//alert(result);
	  for(var i=0 ; i < subStr.length ; i++){

		   if(i==0)
		   {
		   		finalStr = subStr[i].split(field);
		   		selectbox_name = finalStr[0];
		   		default_value = finalStr[1];
		   }
		   else
		   {
		   		if(i== 1){
		   			document.WiseGrid.AddComboListValue(selectbox_name, "", "");
		   		}

		   		finalStr = subStr[i].split(field);

		   		if(finalStr[1] != null){
		   			//ooption.text = finalStr[1].replace(/(^\s*)|(\s*$)/g, "");
		   			document.WiseGrid.AddComboListValue(selectbox_name, finalStr[1].replace(/(^\s*)|(\s*$)/g, ""), finalStr[0]);
		   		}else{
		   			//ooption.text = finalStr[1];
		   			document.WiseGrid.AddComboListValue(selectbox_name, finalStr[1], finalStr[0]);
		   		}

		   }
	  }//End for
}//End function


//파라미터 생성
function GridCell_createQueryString(code, param, selectbox_name, default_value) {

    if(param == null || param.length < 1 || param == ''){
    	param = " ";
    }
	var queryString = "&code=" + code + "&param=" + param+ "&selectbox_name=" + selectbox_name+ "&default_value=" + default_value + "&vendor_flag=Y";
	return queryString;
}

function GridCell_Material_createQueryString(code, param, desc_name, unit_name, cur_row) {

    if(param == null || param.length < 1 || param == ''){
    	param = " ";
    }
	var queryString = "&code=" + code + "&param=" + param+ "&selectbox_name=" + desc_name + "<%=ajax_field%>" + unit_name + "&default_value="+cur_row + "&vendor_flag=Y";
	return queryString;
}

function GridCell_doRequestUsingPOST(code, param, selectbox_name, default_value, blank_line_flag) {
	var queryString = GridCell_createQueryString(code, param, selectbox_name, default_value);
	var url = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();
	sendRequest(GridCell_parseResults,queryString,'POST', url , true, false);
}

function GridCell_Material_doRequestUsingPOST(code, param, desc_name, unit_name, cur_row) {
	var queryString = GridCell_Material_createQueryString(code, param, desc_name, unit_name, cur_row);
	var url = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();
	sendRequest(GridCell_Material_parseResults,queryString,'POST', url , false, false);
}

//JSP 콤보박스 셋팅
function GridCell_parseResults(oj) {
    var result = oj.responseText;//Servlet에서 뿌린 리턴값
    var field = "<%=ajax_field%>"; //'▤▥';
    var line = "<%=ajax_line%>"; //'ªº';
    var subStr = result.split(line);//Row단위 딜리미터
	var ooption;//option element
	var selectbox_name = "";//select box id값
	var default_value ="";//기본 셋팅값
	var nodePath;//해당 select box Object
	var finalStr =new Array ;

	  for(var i=0 ; i < subStr.length ; i++){

		   if(i==0)
		   {
		   		finalStr = subStr[i].split(field);
		   		selectbox_name = finalStr[0];
		   		default_value = finalStr[1];

				if(subStr.length == 1){
					//alert("<%//=ajaxtext.get("AJAX.0001")%>");//업체가 존재하지 않습니다.
					//alert("Companies that do not exist.");//업체가 존재하지 않습니다.
					if(selectbox_name != null && 0 < selectbox_name.length && default_value != null && 0 < default_value.length){
						document.WiseGrid.SetCellValue(selectbox_name, default_value, "");
						document.WiseGrid.SetCellHiddenValue(selectbox_name, default_value, "");
					}
					return false;
				}
		   }
		   else
		   {
		   		finalStr = subStr[i].split(field);

		   		/****************************
		   		selectbox_name = Cell컬럼명
		   		default_value = 현재Row
		   		finalStr[0] = code
		   		finalStr[1] = value
		   		//finalStr[2] = 삭제여부(0이 아니면 삭제)
		   		//finalStr[3] = 정지여부
		   		****************************/

		   		/**********
		   		if(finalStr[2] != 0){
		  	  	  //alert("<%//=text.get("AJAX.0002")%>");
		  	  	  document.WiseGrid.SetCellValue(selectbox_name, default_value, "");
		  	  	  document.WiseGrid.SetCellHiddenValue(selectbox_name, default_value, "");
		  	  	  return false;
		   		}

		   		if(finalStr[3] != 0){
		  	  	  //alert("<%//=text.get("AJAX.0003")%>");
		  	  	  document.WiseGrid.SetCellValue(selectbox_name, default_value, "");
		  	  	  document.WiseGrid.SetCellHiddenValue(selectbox_name, default_value, "");
		  	  	  return false;
		   		}
		   		*********/

		   		if(finalStr[1] != null){
		   			document.WiseGrid.SetCellValue(selectbox_name, default_value, finalStr[1].replace(/(^\s*)|(\s*$)/g, ""));
		   			document.WiseGrid.SetCellHiddenValue(selectbox_name, default_value, finalStr[0]);
		   		}else{
					document.WiseGrid.SetCellValue(selectbox_name, default_value, finalStr[1]);
		   		}
		   }
	  }//End for
}//End function


//JSP 콤보박스 셋팅
function GridCell_Material_parseResults(oj) {
    var result = oj.responseText;//Servlet에서 뿌린 리턴값
    var field = "<%=ajax_field%>"; //'▤▥';
    var line = "<%=ajax_line%>"; //'ªº';
    var subStr = result.split(line);//Row단위 딜리미터
	var ooption;//option element
	var desc_name = "";
	var unit_name = "";
	var cur_row ="";//기본 셋팅값
	var nodePath;//해당 select box Object
	var finalStr =new Array ;
	
		
	  for(var i=0 ; i < subStr.length ; i++)
	  {
		   if(i==0)
		   {
		   		finalStr = subStr[i].split(field);
		   		
		   		desc_name = finalStr[0];
				unit_name = finalStr[1];
				cur_row   = parseInt(finalStr[2]);
				
				if(subStr.length == 1 && desc_name.length > 0 && unit_name.length > 0) {
		   			GridObj.cells(cur_row, GridObj.getColIndexById(desc_name)).setValue(" ");
			   		GridObj.cells(cur_row, GridObj.getColIndexById(unit_name)).setValue(" ");
			   		return false;
				}
		   }
		   else
		   {
		   		finalStr = subStr[i].split(field);
		   		GridObj.cells(cur_row, GridObj.getColIndexById(desc_name)).setValue(finalStr[1].replace(/(^\s*)|(\s*$)/g, ""));
		   		GridObj.cells(cur_row, GridObj.getColIndexById(unit_name)).setValue(finalStr[0].replace(/(^\s*)|(\s*$)/g, ""));
		   }
	  }//End for
}//End function

function parseResults_dhtmlxGrid(oj) {
    var result = oj.responseText;//Servlet에서 뿌린 리턴값
    var field = "<%=ajax_field%>"; //'▤▥';
    var line = "<%=ajax_line%>"; //'ªº';
    var subStr = result.split(line);//Row단위 딜리미터
	var ooption;//option element
	var selectbox_name = "";//select box id값
	var default_value ="";//기본 셋팅값
	var nodePath;//해당 select box Object
	var finalStr =new Array ;
	var combo_data = new Array();
	var combobox;
	
	//	alert(result);
	  for(var i=0 ; i < subStr.length ; i++) {

		   if(i==0)
		   {
		   		finalStr = subStr[i].split(field);
		   		selectbox_name = finalStr[0];
		   		default_value = finalStr[1];
		   		combobox = GridObj.getCombo(GridObj.getColIndexById(selectbox_name));
		   }
		   else
		   {
		   		if(i== 1){
		   			combobox.put("", "");
		   			//combobox.addOption([["", ""]]);
		   		}

		   		finalStr = subStr[i].split(field);
		   		if(finalStr[1] != null){
		   			//ooption.text = finalStr[1].replace(/(^\s*)|(\s*$)/g, "");
		   			combobox.put(finalStr[0], finalStr[1].replace(/(^\s*)|(\s*$)/g, ""));
		   			//combobox.addOption([[finalStr[0], finalStr[1].replace(/(^\s*)|(\s*$)/g, "")]]);
		   		} else {
		   			//ooption.text = finalStr[1];
		   			combobox.put(finalStr[0], finalStr[1]);
		   			//combobox.addOption([[finalStr[0], finalStr[1]]]);
		   		}
		   }
	  }//End for
}//End function

function parseResults_MultidhtmlxGrid(oj) {
    var result = oj.responseText;//Servlet에서 뿌린 리턴값
    var field = "<%=ajax_field%>"; //'▤▥';
    var line = "<%=ajax_line%>"; //'ªº';
    var subStr = result.split(line);//Row단위 딜리미터
	var ooption;//option element
	var selectbox_name = "";//select box id값
	var default_value ="";//기본 셋팅값
	var nodePath;//해당 select box Object
	var finalStr =new Array ;
	var combo_data = new Array();
	var combobox;
	
		//alert(result);
	  for(var i=0 ; i < subStr.length ; i++) {

		   if(i==0)
		   {
		   		finalStr = subStr[i].split(field);
		   		selectbox_name = finalStr[0];
		   		default_value = finalStr[1];
		   		combobox = currentGridObj.getCombo(currentGridObj.getColIndexById(selectbox_name));
		   }
		   else
		   {
		   		if(i== 1){
		   			combobox.put("", "");
		   			//combobox.addOption([["", ""]]);
		   		}

		   		finalStr = subStr[i].split(field);

		   		if(finalStr[1] != null){
		   			//ooption.text = finalStr[1].replace(/(^\s*)|(\s*$)/g, "");
		   			combobox.put(finalStr[0], finalStr[1].replace(/(^\s*)|(\s*$)/g, ""));
		   			//combobox.addOption([[finalStr[0], finalStr[1].replace(/(^\s*)|(\s*$)/g, "")]]);
		   		} else {
		   			//ooption.text = finalStr[1];
		   			combobox.put(finalStr[0], finalStr[1]);
		   			//combobox.addOption([[finalStr[0], finalStr[1]]]);
		   		}
		   }
	  }//End for
}//End function
</script>