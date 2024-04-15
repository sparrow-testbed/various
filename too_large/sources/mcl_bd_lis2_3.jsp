<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_011_3");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_011_3";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--
 Title:        	대분류 <p>
 Description:  	품목정보 > 품목관리 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	WELCHSY<p>
 @version      	1.0.0<p>
 @Comment       대분류 > 중분류 > 소분류 > 세분류를 관리한다.
!-->

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="MA_011_3";%>
<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>

<!-- 사용자 인증 부분 (Option 부분) Login TimeOut 체크 -->
<%@ include file="/include/wisehub_session.jsp" %>

<!-- JTable Scripts -->
<%@ include file="/include/wisehub_common.jsp"%>
<%@ include file="/include/wisetable_scripts.jsp"%>
<%@ include file="/include/wisehub_scripts.jsp"%>

<!-- Pop-up 화면  -->
<%@ include file="/include/code_common.jsp"%>


<%-- WiseGrid1 시작 --%>
<%-- WiseGrid1 종료 --%>

<%-- WiseGrid2 시작 --%>
<%-- WiseGrid2 종료 --%>

<%-- WiseGrid3 시작 --%>
<%-- WiseGrid3 종료 --%>

<%-- WiseGrid4 시작 --%>
<%-- WiseGrid4 종료 --%>

<%-- WiseGrid5 시작 --%>
<%-- WiseGrid5 종료 --%>

<%
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	
	/*Y일 경우 품목승인에서 넘어옴*/
	String app_flag          = JSPUtil.nullToEmpty(request.getParameter("app_flag"));
	
	String type    = "M040";
	String control = "M041";
	String class1  = "M042";
	String class2  = "M122";
	
    // "request 객체", "code name", "house_code#원하는code_type", "field 구분자", "line 구분자"
    WiseListBox LB = new WiseListBox();
    String lb_company_code = LB.Table_ListBox(request, "SL0088", house_code, "&" , "#");
    
    Logger.debug.println(info.getSession("ID"),this,"lb_company_code===>"+lb_company_code);
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
//<!--

var area_code_col = "";
var image_text_col = "";
var area_name_col = "";
var company_code_col = "";
var ctrl_code_col = "";
var image_text1_col = "";
var ctrl_name_loc = "";
var ctrl_type_col = "";

function Init() {
	document.forms[0].flag_grid1.value = "";
	document.forms[0].flag_grid2.value = "";
	document.forms[0].flag_grid3.value = "";
	document.forms[0].flag_grid4.value = "";
	document.forms[0].flag_grid5.value = "";
setGridDraw();
setHeader();
	Query();
}

function setHeader() {
	
	
	/* WiseGrid3 세팅 시작 */



	//9th

	
	GridObj3.SetColCellRadio("check", true);
	/* WiseGrid3 세팅 종료 */
	
	
}

function Query() {
	//var type = "=type ";
    var type="M040"
	document.forms[0].insert_flag.value = "off";
	servletURL = "/servlets/admin.basic.material.mty_lis1";
	GridObj1.SetParam("type",type);
	GridObj1.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj1.SendData(servletURL);
	GridObj1.strHDClickAction="sortmulti";
}

function Line_insert(gridNm, str) {
	var wise = gridNm;
	var insert_flag = document.forms[0].insert_flag.value;
	
	if(str == 'TR'){
		if(document.forms[0].top_code.value == ''){
			alert("대분류를 선택하고 오른쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
			return;
		}
	}else if(str == 'BR'){
		if(document.forms[0].middle_code.value == ''){
			alert("중분류를 선택하고 아래쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
			return;
		}
	}else if(str == 'BL'){
		if(document.forms[0].bottom_code.value == ''){
			alert("소분류를 선택하고 왼쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
			return;
		}
	}else if(str == 'WG'){
		if(document.forms[0].detail_code.value == ''){
			alert("세분류를 선택하고 아래쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
			return;
		}
	}

	for(var i=0; i < wise.GetRowCount();i++) {
		GD_SetCellValueIndex(wise,i, "0", "false&", "&"); //check_box true 로 setting
	}

	var top = "";
	var middle = "";
	var bottom = "";
	var detail = "";
	
	if(str == 'TL'){
		if(document.forms[0].flag_grid1.value != "Y"){
			wise.AddRow();
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "10", "D");
			
			document.forms[0].flag_grid1.value = "Y";	
		}else{
			alert("한 로우만 생성할 수 있습니다.");
			
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			
			return;
		}
	//TR : Top Right 상단 오른쪽화살표 (행추가시 기본값 세팅)
	}else if(str == 'TR'){
		if(document.forms[0].flag_grid2.value != "Y"){
			wise.AddRow();
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "13", "D");
			
			document.forms[0].flag_grid2.value = "Y";
			top = document.forms[0].top_code.value;
			
			//check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount() - 1, "0", "true&", "&"); 
			//사용여부를 true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount() - 1, "1", "true&", "&");
			//대분류코드 값 세팅
			GD_SetCellValueIndex(wise, wise.GetRowCount() - 1, "2", top); 
			
			//코드값(중분류) 자동생성
			workFrm.location.href = "/kr/admin/basic/material/mcl_bd_lis1_hidden.jsp?type=M041&idx="+ wise.GetRowCount() +"&item_code="+ top +"&gubun="+str;
			document.forms[0].insert_flag.value = "on";	
		}else{
			alert("한 로우만 생성할 수 있습니다.");
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			return;
		}
	}else if(str == 'BR'){
		if(document.forms[0].flag_grid3.value != "Y"){
			wise.AddRow();
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			
			document.forms[0].flag_grid3.value = "Y";
			top = document.forms[0].top_code.value;
			middle = document.forms[0].middle_code.value;
			
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //use_flag true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "2", top);
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "3","/kr/images/button/query.gif&null&null","&");
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "4", middle);
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "5","/kr/images/button/query.gif&null&null","&");
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "12", "D");
			
			workFrm.location.href = "mcl_bd_lis1_hidden.jsp?type=M042&idx=" + wise.GetRowCount() +"&item_code="+middle+"&gubun="+str;	
		}else{
			alert("한 로우만 생성할 수 있습니다.");
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			return;
		}
	}else if(str == 'BL'){
		if(document.forms[0].flag_grid4.value != "Y"){
			wise.AddRow();
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			
			document.forms[0].flag_grid4.value = "Y";
			top = document.forms[0].top_code.value;
			middle = document.forms[0].middle_code.value;
			bottom = document.forms[0].bottom_code.value;				
			
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "1", "true&", "&"); //use_flag true 로 setting
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "2", top);
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "4", "/kr/images/button/query.gif&null&null","&");
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "5", middle);
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "7", "/kr/images/button/query.gif&null&null","&");
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "8", bottom);
			GD_SetCellValueIndex(wise,wise.GetRowCount()-1, "10", "/kr/images/button/query.gif&null&null","&");
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "16", "D"); 
			workFrm.location.href = "mcl_bd_lis1_hidden.jsp?type=M122&idx="+ wise.GetRowCount() +"&item_code="+bottom+"&gubun="+str;
		}else{
			alert("한 로우만 생성할 수 있습니다.");
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "1", "true&", "&"); //사용여부를 true 로 setting
			return;
		}
	}else if(str == 'WG'){
		if(document.forms[0].flag_grid5.value != "Y"){
			for(var i=0; i < wise.GetRowCount();i++) {
				GD_SetCellValueIndex(wise, i, "0", "false&", "&"); //check_box true 로 setting
			}
			for(var i=0; i < wise.GetRowCount();i++) {
				if(GD_GetCellValueIndex(wise, i, area_code_col) == "ALL") {
					document.forms[0].region_flag.value = "A";
					alert("구매지역이 ALL 입니다.");
					return;
				}else {					
					if(GD_GetCellValueIndex(wise, i, area_code_col).length == 1) {
						document.forms[0].region_flag.value = GD_GetCellValueIndex(wise, i, area_code_col);
						document.forms[0].region_flag_count.value = "1";
					}else if(GD_GetCellValueIndex(wise, i, area_code_col).length == 2) {
						document.forms[0].region_flag.value = GD_GetCellValueIndex(wise, i, area_code_col);
						document.forms[0].region_flag_count.value = "2";
					}
				}
			} //for end
			document.forms[0].flag_grid5.value = "Y";
			
			top = document.forms[0].top_code.value;
			middle = document.forms[0].middle_code.value;
			bottom = document.forms[0].bottom_code.value;	
			detail = document.forms[0].detail_code.value;
			
			wise.AddRow();
			
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, "0", "true&", "&"); //check_box true 로 setting
			wise.AddImageList("image1","/kr/images/button/query.gif");	
			wise.SetCellImage("image1", wise.GetRowCount()-1,0);
			wise.SetCellValueIndex(image_text_col, wise.GetRowCount()-1,'');			
			GD_SetCellValueIndex(wise, wise.GetRowCount()-1, company_code_col, "<%=lb_company_code %>", "&" ,"#");
			wise.AddImageList("image2","/kr/images/button/query.gif");	
			wise.SetCellImage("image2", wise.GetRowCount()-1,0);
			wise.SetCellValueIndex(image_text1_col, wise.GetRowCount()-1,'');	
			
		}else{
			alert("한 로우만 생성할 수 있습니다.");
			//GD_SetCellValueIndex(wise, wise.GetRowCount() - 1, "0", "true&", "&"); //check_box true 로 setting
			return;
		}
		
		document.forms[0].event_location.value = str;
	}
}

function Create(gridNm, str) {
	var wise = gridNm;
	var sel_row = "";	

	/*등록할 항목이 선택되어져 있지 않은지 체크한다.*/
	for(var i=0; i < wise.GetRowCount();i++) {
		var temp = GD_GetCellValueIndex(wise,i,0);
		if(temp == "true") sel_row += i+"&" ;
	}

	if(sel_row == "") {
		alert("등록할 항목이 없습니다.");
		return;
	}else {
		if(str == 'TL'){
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 2) == "" ) {
				alert("대분류 코드는 필수입력사항입니다.");
				return;
			}
			
			workFrm.location.href = "mty_wk_ins1.jsp?type=M040&item_type=" + wise.getCellValue("mat_code", wise.GetRowCount() - 1)+"&gubun="+str;
			document.forms[0].flag_grid1.value = "";
		}else if(str == 'TR'){
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 4) == "" ) {
				alert("중분류코드는 필수입력사항입니다.");
				return;
			}
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 5) == "" ) {
				alert("중분류명은 필수입력사항입니다.");
				return;
			}
			workFrm.location.href = "mct_wk_ins1.jsp?control=<%=control %>&item_control="+GD_GetCellValueIndex(wise, wise.GetRowCount() - 1, 4)+"&gubun="+str;
			document.forms[0].flag_grid2.value = "";
		}else if(str == 'BR'){
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 6) == ""){
				alert("소분류코드는 필수입력사항입니다.");
				return;
			}
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 7) == ""){
				alert("소분류명은 필수입력사항입니다.");
				return;
			}
			
			workFrm.location.href = "mcl_wk_ins1.jsp?class1=<%=class1 %>&item_class="+GD_GetCellValueIndex(wise, wise.GetRowCount() - 1,6)+"&gubun="+str;
			document.forms[0].flag_grid3.value = "";
		}else if(str == 'BL'){
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 11) == ""){
				alert("세분류코드는 필수입력사항입니다.");
				return;
			}
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 12) == ""){
				alert("세분류명은 필수입력사항입니다.");
				return;
			}
			var item_class = GD_GetCellValueIndex(wise, wise.GetRowCount()-1, 11);
			workFrm.location.href = "mcl_wk_ins2.jsp?mclass2=<%=class2%>&item_class="+item_class+"&gubun="+str;
			document.forms[0].flag_grid4.value = "";
		}else if(str == 'WG'){
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, area_code_col).length < 1) {
				alert("팝업화면을 뛰워서 구매지역코드를 선택해야 합니다.");
				return;
			}
			if(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, ctrl_code_col).length < 1) {
				alert("팝업화면을 뛰워서 직무코드를 선택해야 합니다.");
				return;
			}
			
			check_count(GD_GetCellValueIndex(wise, wise.GetRowCount()-1, company_code_col), GD_GetCellValueIndex(wise, wise.GetRowCount()-1, ctrl_code_col), str);
		}
	}
	
	document.forms[0].event_location.value = str;
}

/* 어떤 항목을 수정하고 체크한뒤 수정버튼을 누르면 DB에 반영된다.*/
function Change(gridNm, str) {
	var wise = gridNm;
	var val = 0;	
	if(str == "TL"){
		for(var i=0; i < wise.GetRowCount();i++) {			
			if(GD_GetCellValueIndex(wise, i, 0) == "true") {
				++val;
				if(GD_GetCellValueIndex(wise, i, 2) == ""){
					alert("대분류코드를 입력하세요.");
					//GridObj.MoveRow(row);
					return;
				}
				if(GD_GetCellValueIndex(wise, i, 3) == ""){
					alert("대분류명을 입력하세요.");
					//GridObj.MoveRow(row);
					return;
				}
				servletURL = "/servlets/admin.basic.material.mty_upd1";
				wise.SetParam("type", "<%=type%>");
				wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
				wise.SendData(servletURL, "ALL", "ALL");
				break;
			}
		}
		
		if(val == 0){
			alert("대분류를 선택하세요");
			return;
		}
	}else if(str == "TR"){
		for(var i=0; i < wise.GetRowCount();i++) {
			if(GD_GetCellValueIndex(wise, i, 0) == "true") {
				++val;
				if(GD_GetCellValueIndex(wise, i, 6) == ""){
					alert("중분류명을 입력하세요.");
					return;					
				}
				
				servletURL = "/servlets/admin.basic.material.mct_upd1";
				wise.SetParam("type", "<%=control %>");
				wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
				wise.SendData(servletURL, "ALL", "ALL");
				break;
			}
		}
		if(val == 0){
			alert("중분류를 선택하세요");
			return;
		}
	}else if(str == "BR"){
		for(var i=0; i < wise.GetRowCount();i++) {			
			if(GD_GetCellValueIndex(wise, i, 0) == "true") {
				++val;
				if(GD_GetCellValueIndex(wise, i, 7) == ""){
					alert("소분류명을 입력하세요.");
					//wise.MoveRow(row);
					return;
				}
								
				servletURL = "/servlets/admin.basic.material.mcl_upd1";
				wise.SetParam("mclass1", "<%=class1 %>");
				wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
				wise.SendData(servletURL, "ALL", "ALL");
				break;
			}
		}
		if(val == 0){
			alert("소분류를 선택하세요");
			return;
		}
	}else if(str == "BL"){
		for(var i=0; i < wise.GetRowCount();i++) {			
			if(GD_GetCellValueIndex(wise, i, 0) == "true") {
				++val;
				if(GD_GetCellValueIndex(wise, i, 11) == ""){
					alert("세분류명을 입력하세요.");
					//wise.MoveRow(row);
					return;
				}
				
				wise.SetParam("mclass2", "<%=class2 %>");
				servletURL = "/servlets/admin.basic.material.mcl_upd2";
				wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
				wise.SendData(servletURL, "ALL", "ALL");				
				break;
			}
		}
		
		if(val == 0){
			alert("세분류를 선택하세요");
			return;
		}
	}
	
	document.forms[0].event_location.value = str;
}

function Save(flag, str) {
	var wise = "";
	var typeName = "";
	var typeValue = "";
	var servletURL = "";
	
	if(str == "TL"){
		wise = GridObj1;
		typeName = "type";
		typeValue = "<%=type %>";
		servletURL = "/servlets/admin.basic.material.mty_ins1";
	}else if(str == "TR"){
		wise = GridObj2;
		typeName = "type";
		typeValue = "<%=control %>";
		servletURL = "/servlets/admin.basic.material.mct_ins1";
		
	}else if(str == "BR"){
		wise = GridObj3;
		typeName = "mclass1";
		typeValue = "<%=class1 %>";
		servletURL = "/servlets/admin.basic.material.mcl_ins1";
		
	}else if(str == "BL"){
		wise = GridObj4;
		typeName = "mclass2";
		typeValue = "<%=class2 %>";
		servletURL = "/servlets/admin.basic.material.mcl_ins2";
	}
	
	if(flag == 'Y') {		
		wise.SetParam(typeName, typeValue);
		wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
		wise.SendData(servletURL, "ALL", "ALL");
	}else {
		alert("이미 있는 데이타입니다.");
	}
}

/* 선택한 항목을 지운다. */
function Delete(gridNm, str) {
	var wise = gridNm;
	var del_row = "";

	/* 지울 항목이 선택되어져 있지 않은지 체크한다.*/
	for(var i=0; i < wise.GetRowCount();i++) {
		var temp = GD_GetCellValueIndex(wise,i,0);
		if(temp == "true") {
			del_row = i;
			break;
		}
	}

	if(del_row.length < 1){
		alert("항목을 선택해주세요.");
	}else{
		if(confirm("정말로 삭제하시겠습니까?")){
			if(str == "TL"){
				if(GD_GetCellValueIndex(wise, del_row, 2) != "" ){
					servletURL = "/servlets/admin.basic.material.mty_del1";
					wise.SetParam("type", "<%=type %>");
					wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
					wise.SendData(servletURL, "ALL", "ALL");
				}else{
					check_count(GD_GetCellValueIndex(wise, del_row, 2), "", str);
				}
			}else if(str == "TR"){
				var top_code = GD_GetCellValueIndex(wise, del_row, 2);
				var middle_code = GD_GetCellValueIndex(wise, del_row, 4);
				
				if(top_code != "" && middle_code != ""){
					servletURL = "/servlets/admin.basic.material.mct_del1";
					wise.SetParam("type", "<%=control%>");
					wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
					wise.SendData(servletURL, "ALL", "ALL");
					
				}else{
					check_count(GD_GetCellValueIndex(top_code, middle_code), "", str);
				}
			}else if(str == "BR"){
				var top_code = GD_GetCellValueIndex(wise, del_row, 2);
				var middle_code = GD_GetCellValueIndex(wise, del_row, 4);
				var bottom_code = GD_GetCellValueIndex(wise, del_row, 6);
				if(top_code != "" && middle_code != "" && bottom_code != ""){					
	            	wise.SetParam("mclass1", "<%=class1 %>");
					servletURL = "/servlets/admin.basic.material.mcl_del1";
					wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
					wise.SendData(servletURL, "ALL", "ALL");					
				}else{
					check_count(bottom_code, "", str);
				}
			}else if(str == "BL"){
				var top_code = GD_GetCellValueIndex(wise, del_row, 2);
				var middle_code = GD_GetCellValueIndex(wise, del_row, 5);
				var bottom_code = GD_GetCellValueIndex(wise, del_row, 8);
				var detail_code = GD_GetCellValueIndex(wise, del_row, 11);
				
				if(top_code != "" && middle_code != "" && bottom_code != "" && detail_code != "") {
					wise.SetParam("mclass2", "<%=class2 %>");
					servletURL = "/servlets/admin.basic.material.mcl_del2";
					wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
					wise.SendData(servletURL, "ALL", "ALL");
				}
			}else if(str == "WG"){
				//소분류
				var item_class    = document.forms[0].bottom_code.value.toUpperCase();
				//세분류
				var item_class2   = document.forms[0].detail_code.value.toUpperCase();

				servletURL = "/servlets/admin.basic.material.maa_del1";
				wise.SetParam("item_class2", item_class2);
				wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
				wise.SendData(servletURL, "ALL", "ALL");
			}
			
			document.forms[0].event_location.value = str;
		}
	}
}

function check_flag222222(gridNm, result) {
	var wise = gridNm;
	var type = "<%=type %>";

	if(result == "Y") {
		var anw = confirm("정말로 삭제하시겠습니까?");
		if(anw == true) {
			servletURL = "/servlets/admin.basic.material.mty_del1";
			GridObj1.SetParam("type", type);
			GridObj1.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj1.SendData(servletURL, "ALL", "ALL");
		}else return;
	}else alert("하위코드가 있으므로 삭제할 수 없습니다. ");
}


function check_flag(result) {
	var wise = GridObj5;
	var item_control = document.forms[0].middle_code.value;
	var item_class = document.forms[0].bottom_code.value;
	var item_class2 = document.forms[0].detail_code.value;
	
	var ctrl_type = "P";
	var type = "M122";

	if(result == "Y") {
		servletURL = "/servlets/admin.basic.material.maa_ins1";
		wise.SetParam("item_class2", item_class2);
		wise.SetParam("ctrl_type", ctrl_type);
		wise.SetParam("WISETABLE_DOQUERY_DODATA","1");
		wise.SendData(servletURL, "ALL", "ALL");
	}else {
		alert("존재하지 않는 코드입니다.");
		return;
	}
}

function check_count(code1, code2, str){
	document.forms[0].target = "workFrm";
	if(str == 'TL'){		
		document.forms[0].action = "/kr/admin/basic/material/cut_wk_lis1.jsp?de_type=<%=control %>&code1="+code1+"&code2="+code2;
		document.method = "post";
		document.forms[0].submit();
	}else if(str == 'TR'){
		
	}else if(str == 'BL'){
		
	}else if(str == 'BR'){
		
	}else if(str == 'WG'){
		document.forms[0].action = "/kr/admin/basic/material/maa_wk_lis2.jsp?company_code="+code1+"&ctrl_code="+code2;
		document.method = "get";
		
		document.forms[0].submit();
	}
}

function oneSelect2(max_row, msg1, msg2) {
	var noSelect = "";
	if (GridObj2.GetRowCount() == 0) {
		alert('선택된 데이터가 없습니다.');
		return;
	}
	if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj2,msg2,"0") == "false") 
		noSelect = "Y";
	
	for(var i=0;i<max_row;i++)  {
     	GD_SetCellValueIndex(GridObj2,i,"0","false", "&");
    }
	
   	if(msg1 != "t_header" && noSelect != "Y")
   		GD_SetCellValueIndex(GridObj2,msg2,"0","true", "&");
   	
   	Select2();
}

function oneSelect3(max_row, msg1, msg2) {
	var noSelect = "";
	if (GridObj3.GetRowCount() == 0) {
		alert('선택된 데이터가 없습니다.');
		return;
	}
	if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj3,msg2,"0") == "false") 
		noSelect = "Y";
	
	for(var i=0;i<max_row;i++)  {
     	GD_SetCellValueIndex(GridObj3,i,"0","false", "&");
    }
	
   	if(msg1 != "t_header" && noSelect != "Y")
   		GD_SetCellValueIndex(GridObj3,msg2,"0","true", "&");
   	
   	Select3();
}

function oneSelect4(max_row, msg1, msg2) {
	var noSelect = "";
	if (GridObj4.GetRowCount() == 0) {
		alert('선택된 데이터가 없습니다.');
		return;
	}
	if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj4,msg2,"0") == "false") 
		noSelect = "Y";
	
	for(var i=0;i<max_row;i++)  {
     	GD_SetCellValueIndex(GridObj4,i,"0","false", "&");
    }
	
   	if(msg1 != "t_header" && noSelect != "Y")
   		GD_SetCellValueIndex(GridObj4,msg2,"0","true", "&");
   	
   	Select4();
}

/* 삭제하고 난 뒤에 첫 화면(쿼리된 화면)으로 돌아온다.*/
function JavaCall(msg1,msg2, msg3, msg4, msg5){
	
 	if(msg1=="doData"){ 	
 		if(document.forms[0].event_location.value != ""){
 			if(document.forms[0].event_location.value == "TL"){
 				alert(GridObj1.Getmessage());
 				Query(); 				
 			}else if(document.forms[0].event_location.value == "TR"){
 				alert(GridObj2.Getmessage());
 				goRight();
 			}else if(document.forms[0].event_location.value == "BR"){
 				alert(GridObj3.Getmessage()); 				
 				goDown();
 			}else if(document.forms[0].event_location.value == "BL"){
 				alert(GridObj4.Getmessage());
 				goLeft(); 				
 			}else if(document.forms[0].event_location.value == "WG"){
 				alert(GridObj5.Getmessage());
 				goWorkItem(); 				
 			}
 		}
 	}
 	
 	if(document.forms[0].event_location.value="WG"){
 		
 		if(msg1 == "t_imagetext" && msg3 == image_text_col) {
 			var wise = GridObj5;
 	 		if(document.forms[0].flag_grid5.value == "Y") {
 	 			if( document.forms[0].region_flag.value == "" ) {
 	 				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=region_getCode&values=<%=house_code%>&values=M039&values=&values=";
 	 			}else {
 	 				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9135&function=region_getCode&values=<%=house_code%>&values=M039&values="+document.forms[0].region_flag_count.value+"&values=&values=";
 	 			}
 	 			//Code_Search(url,'','','','','');
 	 			CodeSearchCommon(url,'','','','','');
 	 		}else{
 	 			alert("생성시에만 누르실 수 있습니다.");
 	 		}
 	 	}else if(msg1 == "t_imagetext" && msg3 == image_text1_col) {
 	 		var wise = GridObj5;
 	 		if(wise.GetCellValue('area_code', msg2)==""){
 	 			alert("구매지역코드를 먼저 입력하세요");
 	 			return;
 	 		}
//  	 		document.forms[0].row.value = msg2;
 	 		if(document.forms[0].flag_grid5.value == "Y") {
 	 			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9079&function=D&values=<%=house_code%>&values="+wise.GetComboHiddenValue(wise.GetColHDKey(company_code_col),msg2)+"&values=P&values=&values=";
 	 			//Code_Search(url,'','','','','');
 	 			CodeSearchCommon(url,'','','','','');
 	 		}else{
 	 			alert("생성시에만 누르실 수 있습니다.");
 	 		}
 	 	}
 	}
}

function SP9079_getCode(a,b) {

	var wise = GridObj5;
	var row = wise.GetRowCount();

	GD_SetCellValueIndex(wise, row - 1, ctrl_code_col, a);
	GD_SetCellValueIndex(wise, row - 1, ctrl_name_loc, b);

}

//대분류를 선택하여 중분류를 조회한다.(왼쪽 --> 오른쪽)
function goRight(){
	var wise = GridObj1;
	var wise2 = GridObj2;

	var value = 0;
	var code = "";
	if(wise.GetRowCount() > 0){
		for(var i = 0; i < wise.GetRowCount(); i++){			
			if(GD_GetCellValueIndex(wise, i, "0") == "true"){
				if(GD_GetCellValueIndex(wise, i, "10") == 'Y'){
					++value;
					code = GD_GetCellValueIndex(wise, i, "2");	
				}else{
					alert("등록 후 선택하여주세요.");					
					return;					
				}
			}
		}
		
		if(value == 0){
			alert("대분류를 선택하세요.");
			return;
		}else if(value > 1){
			alert("대분류는 하나만 선택할 수 있습니다.");
			return;
		}	
		
		
		var type = "M041"
		document.forms[0].insert_flag.value = "off";
		document.forms[0].top_code.value = code;
		servletURL = "/servlets/admin.basic.material.mct_lis1";
		wise2.SetParam("type",type);
		wise2.SetParam("code",code);
		wise2.SetParam("WISETABLE_DOQUERY_DODATA","0");
		wise2.SendData(servletURL);
		wise2.strHDClickAction="sortmulti";		
		document.forms[0].flag_grid2.value = "";
	}else{
		alert("대분류가 없습니다.");
		return;
	}
}

//중분류를 선택하여 소분류를 조회한다.(상위 --> 하위)
function goDown(){
	var wise2= GridObj2;
	var wise3 = GridObj3;
	
	var item_type = "";
	
	var value = 0;
	var code = "";
	if(wise2.GetRowCount() > 0){
		for(var i = 0; i < wise2.GetRowCount(); i++){			
			if(GD_GetCellValueIndex(wise2, i, "0") == "true"){
				if(GD_GetCellValueIndex(wise2, i, "13") == 'Y'){
					++value;
					//대분류의 값을 가지고 온다.	
					item_type = GD_GetCellValueIndex(wise2, i, "2");
					//중분류의 값을 가지고 온다.
					code = GD_GetCellValueIndex(wise2, i, "4");	
				}else{
					alert("등록 후 선택하여주세요.");					
					return;					
				}
				
			}
		}
		
		if(value == 0){
			alert("중분류를 선택하세요.");
			return;
		}else if(value > 1){
			alert("중분류는 하나만 선택할 수 있습니다.");
			return;
		}
		
		var type = "M041"
		document.forms[0].middle_code.value = code;
		servletURL = "/servlets/admin.basic.material.mcl_lis1";
		wise3.SetParam("item_type", item_type);
		wise3.SetParam("item_control",code);
		wise3.SetParam("class1","M042");
		wise3.SetParam("WISETABLE_DOQUERY_DODATA","0");
		wise3.SendData(servletURL);
		wise3.strHDClickAction="sortmulti";
		document.forms[0].flag_grid3.value = "";
 	}else{
		alert("중분류가 없습니다.");
		return;
	}
}

//소분류를 선택하여 세분류를 조회한다.(오른쪽 --> 왼쪽)
function goLeft(){
	var wise3= GridObj3;
	var wise4 = GridObj4;
	
	var item_type = "";
	var item_control = "";
	var item_class1 = "";
	var value = 0;	
	if(wise3.GetRowCount() > 0){
		for(var i = 0; i < wise3.GetRowCount(); i++){
			if(GD_GetCellValueIndex(wise3, i, "0") == "true"){
				if(GD_GetCellValueIndex(wise3, i, "12") == 'Y'){
					++value;
					//대분류의 값을 가지고 온다.	
					item_type = GD_GetCellValueIndex(wise3, i, "2");
					//중분류의 값을 가지고 온다.
					item_control = GD_GetCellValueIndex(wise3, i, "4");
					//소분류의 값을 가지고 온다.
					item_class1 = GD_GetCellValueIndex(wise3, i, "6");
				}else{
					alert("등록 후 선택하여주세요.");					
					return;					
				}
			}
		}
		
		if(value == 0){
			alert("소분류를 선택하세요.");
			return;
		}else if(value > 1){
			alert("소분류는 하나만 선택할 수 있습니다.");
			return;
		}
		
		servletURL = "/servlets/admin.basic.material.mcl_lis2";
		document.forms[0].bottom_code.value = item_class1;
		wise4.SetParam("item_type", item_type);
		wise4.SetParam("item_control", item_control);
		wise4.SetParam("item_class1", item_class1);
		wise4.SetParam("mclass2", "M122");
		wise4.SetParam("WISETABLE_DOQUERY_DODATA","0");
		wise4.SendData(servletURL);
		wise4.strHDClickAction="sortmulti";	
		document.forms[0].flag_grid4.value = "";
 	}else{
		alert("소분류가 없습니다.");
		return;
	}
}

function goWorkItem(){
	var wise4 = GridObj4;
	var wise5 = GridObj5;
	var code = "";
	var value = "";
	if(document.forms[0].top_code.value == ""){
		alert("대분류를 선택하세요");
		return;
	}
	if(document.forms[0].middle_code.value == ""){
		alert("중분류를 선택하세요");
		return;
	}
	if(document.forms[0].bottom_code.value == ""){
		alert("소분류를 선택하세요");
		return;
	}
	
	if(wise4.GetRowCount() > 0){
		for(var i = 0; i < wise4.GetRowCount(); i++){
			if(GD_GetCellValueIndex(wise4, i, "0") == "true"){
				
				if(GD_GetCellValueIndex(wise4, i, "16") == 'Y'){
					++value;
					//세분류의 값을 가지고 온다.
					code = GD_GetCellValueIndex(wise4, i, "11");
				}else{
					alert("등록 후 선택하여주세요.");					
					return;					
				}
			}
		}
		
		if(value == 0){
			alert("세분류를 선택하세요.");
			return;
		}else if(value > 1){
			alert("세분류는 하나만 선택할 수 있습니다.");
			return;
		}

		var ctrl_type = "P";  //직무형태
		
		servletURL = "/servlets/admin.basic.material.maa_lis1";
		document.forms[0].detail_code.value = code;
		wise5.SetParam("item_class2", code);
		wise5.SetParam("ctrl_type", ctrl_type);
		wise5.SetParam("WISETABLE_DOQUERY_DODATA","0");
		wise5.SendData(servletURL);
		wise5.strHDClickAction="sortmulti";
		
		document.forms[0].flag_grid5.value = "";
	}else{
		alert("세분류가 없습니다.");
		return;
	}
}

function Select2(){
	var selected = 0;
	for(i = 0; i < GridObj2.GetRowCount(); i++)
	{
	    if(GD_GetCellValueIndex(GridObj2, i, INDEX_SEL)=="true")
	    {
	        var value1 = GridObj2.GetCellValue("mat_code", i);
	        var value2 = GridObj2.GetCellValue("cont_code", i);
	        var value3 = '';
	        var value4 = '';
	        var value5 = GridObj2.GetCellValue("mat_name1", i);
	        var value6 = '';
	        selected ++;
	    }
	}
	if(selected >1){
	    alert("한개만 선택하셔야 합니다.");
	    return;
	}else{
	    alert("선택되었습니다.");
	    parent.parent.opener.Category(value1,value2,value3,value4,value5,value6);
	    parent.parent.close();
	}
}

function Select3(){
	var selected = 0;
	for(i = 0; i < GridObj3.GetRowCount(); i++)
	{
	    if(GD_GetCellValueIndex(GridObj3, i, INDEX_SEL)=="true")
	    {
	        var value1 = GridObj3.GetCellValue("type", i);
	        var value2 = GridObj3.GetCellValue("control", i);
	        var value3 = GridObj3.GetCellValue("class", i);
	        var value4 = '';
	        var value5 = GridObj3.GetCellValue("loc", i);
	        var value6 = '';
	        selected ++;
	    }
	}
	if(selected >1){
	    alert("한개만 선택하셔야 합니다.");
	    return;
	}else{
	    alert("선택되었습니다.");
	    parent.parent.opener.Category(value1,value2,value3,value4,value5,value6);
	    parent.parent.close();
	}
}

function Select4(){
	var selected = 0;
	for(i = 0; i < GridObj4.GetRowCount(); i++)
	{
	    if(GD_GetCellValueIndex(GridObj4, i, INDEX_SEL)=="true")
	    {
	        var value1 = GridObj4.GetCellValue("type", i);
	        var value2 = GridObj4.GetCellValue("control", i);
	        var value3 = GridObj4.GetCellValue("class1", i);
	        var value4 = GridObj4.GetCellValue("class2", i);
	        var value5 = GridObj4.GetCellValue("loc", i);
	        var value6 = '';
	        selected ++;
	    }
	}
	if(selected >1){
	    alert("한개만 선택하셔야 합니다.");
	    return;
	}else{
	    alert("선택되었습니다.");
	    parent.parent.opener.Category(value1,value2,value3,value4,value5,value6);
	    parent.parent.close();
	}
}

function setClass(idx, item_control, str) {	
	if(str == "TR"){
		GD_SetCellValueIndex(GridObj2, idx - 1, "4", item_control);	
	}else if(str == "BR"){
		GD_SetCellValueIndex(GridObj3, idx - 1, "6", item_control);
	}else if(str == "BL"){
		GD_SetCellValueIndex(GridObj4, idx - 1, "11", item_control);
	}
    
}

function region_getCode(a,b) {
	var wise = GridObj5;

	//이미 있는 데이타를 가져오는지 확인한다.
	var count = 0;
	for(var i=0; i < wise.GetRowCount();i++) {
		var temp = GD_GetCellValueIndex(wise,i,area_code_col);
		if(temp == a) {
			count = count+1;
			break;
		}
	}

	if(count == 0) {
		GD_SetCellValueIndex(wise, wise.GetRowCount() - 1, area_code_col, a); //check_box true 로 setting
		GD_SetCellValueIndex(wise, wise.GetRowCount() - 1, area_name_col, b);		
	} else alert("이미 있는 데이타입니다.");
}

//-->
</script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
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
		GD_CellClick(document.WiseGrid5,strColumnKey, nRow);

    
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
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="GD_setProperty(document.WiseGrid1);;GD_setProperty(document.WiseGrid2);;GD_setProperty(document.WiseGrid3);;GD_setProperty(document.WiseGrid4);;Init();GD_setProperty(document.WiseGrid5);Init();">

<s:header>
<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  	<td class="cell_title1" width="78%" align="left">&nbsp;
	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12">
	  	시스템관리 > 기본정보 > 품목정보 > 카테고리 관리
	  	<//%@ include file="/include/sepoa_milestone.jsp" %>
	  	</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" action="">
<input type="hidden" size="5" value="off" name="insert_flag" class="inputsubmit">
<input type="hidden" size="5" value="" name="count" class="inputsubmit">

<%--분류코드 히든값 세팅 --%>
<input type="hidden" name="top_code">
<input type="hidden" name="middle_code">
<input type="hidden" name="bottom_code">
<input type="hidden" name="detail_code">
<%--조회버튼클릭 플래그 --%>
<input type="hidden" name="flag_grid1">
<input type="hidden" name="flag_grid2">
<input type="hidden" name="flag_grid3">
<input type="hidden" name="flag_grid4">
<input type="hidden" name="flag_grid5">
<%--이벤트발생 플래그 --%>
<input type="hidden" name="event_location">

<input type="hidden" value="" name="region_flag">
<input type="hidden" value="" name="region_flag_count">
	<tr>
		<td height="5px"></td>
	</tr>
  	<tr>
  		<td width="48%" align="right">
  		<%
			if(!"Y".equals(app_flag)){
			%>  		
			<TABLE cellpadding="0">
	      	<TR>
				<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
					<TD width='25' align='left'><img src='/images/btn_left26.gif' width='25' height='23' /></TD>
					<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Line_insert(GridObj1, 'TL')" class='btn'>행삽입</a></TD>
					<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
				</table></TD>
				<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
					<TD width='25' align='left'><img src='/images/btn_left6.gif' width='25' height='23' /></TD>
					<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Create(GridObj1, 'TL')" class='btn'>등 록</a></TD>
					<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
				</table></TD>
				<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
					<TD width='25' align='left'><img src='/images/btn_left43.gif' width='25' height='23' /></TD>
					<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Change(GridObj1, 'TL')" class='btn'>수 정</a></TD>
					<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
				</table></TD>
				<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
					<TD width='25' align='left'><img src='/images/btn_left3.gif' width='25' height='23' /></TD>
					<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Delete(GridObj1, 'TL')" class='btn'>삭 제</a></TD>
					<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
				</table></TD>
   	  		</TR>
  			</TABLE>
  			<%
			}
		%>
  		</td>
  		<td width="4%"></td>
  		<td width="48%" align="right">
			<TABLE cellpadding="0">
	      		<TR>
					<%
					if("Y".equals(app_flag)){
					%>
					<TD><script language="javascript">btn("javascript:goRight()",2,"조 회")</script></TD>
					<!--
					<TD><script language="javascript">btn("javascript:oneSelect2()",13,"선 택")</script></TD>
					<TD><script language="javascript">btn("javascript:window.close()",36,"닫 기")</script></TD>
					-->
					<%
					}else{
					%>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left26.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Line_insert(GridObj2, 'TR')" class='btn'>행삽입</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left6.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Create(GridObj2, 'TR')" class='btn'>등 록</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left43.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Change(GridObj2, 'TR')" class='btn'>수 정</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left3.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Delete(GridObj2, 'TR')" class='btn'>삭 제</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
		  			<%
  					}
  					%>  		
    	  		</TR>
  			</TABLE>
  		</td>
  	</tr>
    <tr>
	    <td align="center"><%=WiseTable_Scripts("100%","200", "", "", "WiseGrid1")%></td>
	    <td align="center"><a href="javascript:goRight()"><img src="/images/hwasalpyo_right.png" border="0" width="27px" height="31px" /></a></td>
	    <td align="center" valign="top"><%=WiseTable_Scripts("100%","200", "", "", "WiseGrid2")%></td>
    </tr>
    <tr>
    	<td height="40px" colspan="2"></td>
    	<td align="center" valign="middle"><a href="javascript:goDown()"><img src="/images/hwasalpyo_down.png" border="0" width="27px" height="31px" /></a></td>
    </tr>
    <tr>
	    <td align="right">
			<TABLE cellpadding="0">
	      		<TR>
					<%
					if("Y".equals(app_flag)){
					%>
					<TD><script language="javascript">btn("javascript:goLeft()",2,"조 회")</script></TD>
					<TD><script language="javascript">btn("javascript:oneSelect4()",13,"선 택")</script></TD>
					<TD><script language="javascript">btn("javascript:window.close()",36,"닫 기")</script></TD>
					<%
					}else{
					%>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left26.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Line_insert(GridObj4, 'BL')" class='btn'>행삽입</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left6.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Create(GridObj4, 'BL')" class='btn'>등 록</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left43.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Change(GridObj4, 'BL')" class='btn'>수 정</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left3.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Delete(GridObj4, 'BL')" class='btn'>삭 제</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<%
					}
				%>
    	  		</TR>
  			</TABLE>	    
	    </td>
	    <td></td>
	    <td align="right">
			<TABLE cellpadding="0">
	      		<TR>
					<%
					if("Y".equals(app_flag)){
					%>
					<TD><script language="javascript">btn("javascript:goDown()",2,"조 회")</script></TD>
					<!--
					<TD><script language="javascript">btn("javascript:oneSelect3()",13,"선 택")</script></TD>
					<TD><script language="javascript">btn("javascript:window.close()",36,"닫 기")</script></TD>
					-->
					<%
					}else{
					%>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left26.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Line_insert(GridObj3, 'BR')" class='btn'>행삽입</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left6.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Create(GridObj3, 'BR')" class='btn'>등 록</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left43.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Change(GridObj3, 'BR')" class='btn'>수 정</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
					<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
						<TD width='25' align='left'><img src='/images/btn_left3.gif' width='25' height='23' /></TD>
						<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Delete(GridObj3, 'BR')" class='btn'>삭 제</a></TD>
						<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
					</table></TD>
  					<%
					}
					%>
    	  		</TR>
  			</TABLE>
	    </td>
    </tr>    
    <tr>
	    <td align="center"><%=WiseTable_Scripts("100%","200", "", "", "WiseGrid4")%></td>
	    <td align="center"><a href="javascript:goLeft()"><img src="/images/hwasalpyo_left.png" border="0" width="27px" height="31px" /></a></td>
	    <td align="center"><%=WiseTable_Scripts("100%","200", "", "", "WiseGrid3")%></td>
    </tr>
<%
	if(!"Y".equals(app_flag)){
	%>    
    <tr>
    	<td colspan="3" align="center" valign="bottom" height="50px"><a href="javascript:goWorkItem();"><img src="/images/hwasalpyo_down.png" border="0" width="27px" height="31px" /></a></td>
    </tr>
    <%-- 직무 연결 시작 --%>
    <tr>
    	<td colspan="3">
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>  	
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
								<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
									<TD width='25' align='left'><img src='/images/btn_left26.gif' width='25' height='23' /></TD>
									<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Line_insert(GridObj5, 'WG')" class='btn'>행삽입</a></TD>
									<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
								</table></TD>
								<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
									<TD width='25' align='left'><img src='/images/btn_left6.gif' width='25' height='23' /></TD>
									<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Create(GridObj5, 'WG')" class='btn'>등 록</a></TD>
									<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
								</table></TD>
								<TD><table cellpadding='0' cellspacing='0' border='0'><tr>
									<TD width='25' align='left'><img src='/images/btn_left3.gif' width='25' height='23' /></TD>
									<TD background='/images/btn_bg.gif' class='btn' height='23'><a href="javascript:Delete(GridObj4, 'WG')" class='btn'>삭 제</a></TD>
									<TD width='3' align='left'><img src='/images/btn_right.gif' width='3' height='23' /></TD></tr>
								</table></TD>
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
	  		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		 		<tr>
					<td height="1" class="cell"></td>
				<!-- wisegrid 상단 bar -->
				</tr>
		    	<tr>
				    <td align="center">
				  		<%=WiseTable_Scripts("100%","200", "", "", "WiseGrid5")%>
					</td>
		    	</tr>
		  	</table>
    	</td>
    </tr>    
    <%-- 직무 연결 종료 --%>
    <%
	}
%>
    
  </table>
</form>
<iframe name="workFrm" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>

</s:header>
<s:grid screen_id="MA_011_3" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


