<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_T04");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_T04";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="PR_T04";%>


<!-- Parameter정보 -->
<%
	String from = JSPUtil.nullToEmpty(request.getParameter("from"));
	String house_code = JSPUtil.nullToEmpty(request.getParameter("house_code"));
	String auto_flag = "A"; //상신자 지정 방식에는 자동 수동의 의미가 없다.
	String req_user_id = JSPUtil.nullToEmpty(request.getParameter("req_user_id"));
	String doc_type = JSPUtil.nullToEmpty(request.getParameter("doc_type"));
	String fnc_name = JSPUtil.nullToEmpty(request.getParameter("fnc_name"));
	String strategy = JSPUtil.nullToEmpty(request.getParameter("strategy"));
	String issue_type = JSPUtil.nullToEmpty(request.getParameter("issue_type"));
	String app_div = JSPUtil.nullToEmpty(request.getParameter("app_div"));
	String asset_type = JSPUtil.nullToEmpty(request.getParameter("asset_type"));

	String TITLE = "결재경로 상세정보";

	SepoaListBox LB = new SepoaListBox();
	String COMBO_M002 = LB.Table_ListBox(request, "SL0022", info.getSession("HOUSE_CODE") + "#M119", "#", "@");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
//<!--

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.approval2.ap2_pp_lis3";

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

function Init() {
setGridDraw();
setHeader();
}

/* 모든셀 편집 가능 */
function setHeader() {

	/* GridObj.AddHeader("SIGN_USER_ID",			"",			"t_text",		100,0,	false);
	GridObj.AddHeader("SIGN_PATH_NO",			"",			"t_text",		100,0,	false);
	GridObj.AddHeader("POSITION",				"",			"t_text",		100,0,	false);
	GridObj.AddHeader("MANAGER_POSITION",		"",			"t_text",		100,0,	false);
 */

	INDEX_SELECTED 					= GridObj.GetColHDIndex("SELECTED");
	INDEX_SIGN_PATH_SEQ 			= GridObj.GetColHDIndex("SIGN_PATH_SEQ");
	INDEX_USER_NAME_LOC 			= GridObj.GetColHDIndex("USER_NAME_LOC");
	INDEX_USER_POP 					= GridObj.GetColHDIndex("USER_POP");
	INDEX_DEPT_NAME					= GridObj.GetColHDIndex("DEPT_NAME");
	INDEX_POSITION_NAME				= GridObj.GetColHDIndex("POSITION_NAME");
	INDEX_MANAGER_POSITION_NAME		= GridObj.GetColHDIndex("MANAGER_POSITION_NAME");
	INDEX_PROCEEDING_FLAG			= GridObj.GetColHDIndex("PROCEEDING_FLAG");
	INDEX_SIGN_USER_ID 				= GridObj.GetColHDIndex("SIGN_USER_ID");
	INDEX_SIGN_PATH_NO  			= GridObj.GetColHDIndex("SIGN_PATH_NO");
	INDEX_POSITION		  			= GridObj.GetColHDIndex("POSITION");
	INDEX_MANAGER_POSITION  		= GridObj.GetColHDIndex("MANAGER_POSITION");

}

function Query(sign_path_no, sign_remark) {
	
	var sepoa = GridObj;
	var F = document.forms[0];

	F.remark.text 	=  sign_remark;
	F.remark.value 	=  sign_remark;

	/* GridObj.SetParam("mode", "getMaintain");
	GridObj.SetParam("sign_path_no",sign_path_no);
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(G_SERVLETURL);
	GridObj.strHDClickAction="sortmulti"; */

	$('#sign_path_no').val(sign_path_no);
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getMaintain";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);	
	
}

function doSave() {  
<%
	if (issue_type.equals("P")) {
%>
	    var attach_cnt = document.forms[0].attach_count.value;
    	if (attach_cnt < 1){
        	alert("첨부파일은 필수 입니다.");
        	return;
    	}
<%
	}
%>

	if (GridObj.GetRowCount() == 0){
		alert("결재순서를 지정해주세요");
		return;
	}

	var app_person	= GD_GetCellValueIndex(GridObj,0,INDEX_SIGN_USER_ID);
	if(app_person == ""){
		alert("결재자를 지정해주세요");
		return;
	}

    var cnt1 = 0; //합의자수 카운트
    var cnt2 = 0; //결재자수 카운트
    var cnt3 = 0; //수신자수 카운트
	var sign_path_seq 			= "";
	var sign_user_id			= "";
	var proceeding_flag 		= "";

	for(var i = 0; i < GridObj.GetRowCount();i++)	{
		//alert(GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_PATH_SEQ)+"|"+GD_GetCellValueIndex(GridObj,i,INDEX_PROCEEDING_FLAG));
		
		sign_path_seq 			= GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_PATH_SEQ);
		sign_user_id			= GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_USER_ID);
		proceeding_flag			= GD_GetCellValueIndex(GridObj,i,INDEX_PROCEEDING_FLAG);

		if(sign_user_id.length == 0) {
			alert("결재자를 지정해 주십시오.");
			return;
		}
		
		if ((sign_path_seq == "") || (sign_user_id == "")) continue;

        if(proceeding_flag == "C") cnt1++;
        if(proceeding_flag == "P") cnt2++;
		if(proceeding_flag == "R" ) cnt3++;
        
        if(i == GridObj.GetRowCount()-1){
        	if(proceeding_flag == 'C' || proceeding_flag == 'R'){
        		alert("마지막 결재순서는 요청상태가 결재만 가능합니다.");
        		return;
        	}
        }
	}

    if(cnt1 > 5){
        alert("합의자는 5명까지 지정할 수 있습니다.");
        return;
    }

    if(cnt2 > 5){
        alert("결재자는 5명까지 지정할 수 있습니다.");
        return;
    }
    
    if(cnt2 > 5){
        alert("수신자는 5명까지 지정할 수 있습니다.");
        return;
    }
 	// 결재자가 요청상태가 수신일 경우가 존재시 다른 결재자 요청상태가 존재 해야함 (2012-06-04)
    if(cnt3 == GridObj.GetRowCount()){
    	alert("요청상태가 결재 또는 합의가 존재해야 합니다.");
    	return;
    }
    
	//document.attachFrame.setData();	//startUpload
	
    getApprovalSend();
	
}

	function getApprovalSend() {
    	var cnt1 = 0; //합의자수 카운트
    	var cnt2 = 0; //결재자수 카운트

		var Sign_Path 				= "";
		var sign_path_seq 			= "";
		var sign_user_id			= "";
		var proceeding_flag 		= "";
		var position_code 			= "";
		var manager_position_code 	= "";
		var firstData_flag			= true;

		var app_person	= GD_GetCellValueIndex(GridObj,0,INDEX_SIGN_USER_ID);
		var attach_no   = document.forms[0].attach_no.value;
		var remark      = document.forms[0].remark.value;

		var ARGENT_FLAG = document.forms[0].argent_flag.checked;
		if(ARGENT_FLAG == true) {
			document.forms[0].argent_flag_value.value = "T";
		} else{
			document.forms[0].argent_flag_value.value = "F";
		}
		var ARGENT_FLAG = document.forms[0].argent_flag_value.value;

		//결재순서 setting
    	//SignPathSeqSetting();
    	var sps = new Array(GridObj.GetRowCount());
		for(var i = 0; i < GridObj.GetRowCount();i++)	{
			sign_path_seq 			= GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_PATH_SEQ);
			sign_user_id			= GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_USER_ID);
			proceeding_flag			= GD_GetCellValueIndex(GridObj,i,INDEX_PROCEEDING_FLAG);
			position_code 			= GD_GetCellValueIndex(GridObj,i,INDEX_POSITION);
			manager_position_code 	= GD_GetCellValueIndex(GridObj,i,INDEX_MANAGER_POSITION);

			if (sign_user_id == "") continue;
			if (sign_path_seq == "") continue;

			//STRING TOKEZING 할때 5개씩 파스하기위해 한칸씩 여유를 줌(NULL이면 파스할때 무시됨)
			if(proceeding_flag == 'R'){
				sps[sign_path_seq - 1] = sign_path_seq +" #"+sign_user_id +" #"+ position_code +" #"+ manager_position_code +" #"+ proceeding_flag +" #"+"Y"+" #$";
			}else{
				if(firstData_flag){
					sps[sign_path_seq - 1] = sign_path_seq +" #"+sign_user_id +" #"+ position_code +" #"+ manager_position_code +" #"+ proceeding_flag +" #"+"Y"+" #$";
					firstData_flag = false;
				}else{
					sps[sign_path_seq - 1] = sign_path_seq +" #"+sign_user_id +" #"+ position_code +" #"+ manager_position_code +" #"+ proceeding_flag +" #"+"N"+" #$";
				}
			}

			
//    	    	if(sign_path_seq == "1") {
// 			    sps[0] = sign_path_seq +" #"+sign_user_id +" #"+ position_code +" #"+ manager_position_code +" #"+ proceeding_flag +" #"+"Y"+" #$";  	    			
//    	    	} else {
// 			    sps[sign_path_seq - 1] = sign_path_seq +" #"+sign_user_id +" #"+ position_code +" #"+ manager_position_code +" #"+ proceeding_flag +" #"+"N"+" #$";
// 			}
		}

	    for( j=0; j<sps.length; j++ ){
    	    Sign_Path += sps[j];
    	}

<%-- 	    alert('<%=fnc_name%>'); --%>
	    //getApproval
        opener.window.focus();
<%
	
	if ( from.equals("P") ) {
%>
	    opener.parent.<%=fnc_name%>("UrgentFlag==="+ARGENT_FLAG+"|||SignUserId==="+app_person+"|||SignRemark==="+urlEncode(remark)+"|||auto_flag===<%=auto_flag%>|||strategy===<%=strategy%>|||attach_no==="+attach_no+"|||Sign_Path==="+Sign_Path);
<%
	} else {
%>
<%-- 		alert("UrgentFlag==="+ARGENT_FLAG+"|||SignUserId==="+app_person+"|||SignRemark==="+remark+"|||auto_flag===<%=auto_flag%>|||strategy===<%=strategy%>|||attach_no==="+attach_no+"|||Sign_Path==="+Sign_Path); --%>
	    opener.parent.<%=fnc_name%>("UrgentFlag==="+ARGENT_FLAG+"|||SignUserId==="+app_person+"|||SignRemark==="+urlEncode(remark)+"|||auto_flag===<%=auto_flag%>|||strategy===<%=strategy%>|||attach_no==="+attach_no+"|||Sign_Path==="+Sign_Path);
<%
	}
%>
	    window.close();
	}

/* 	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];

		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "P") {
			var protocol = location.protocol;
			var host     = location.host;
			var addr     = protocol +"//" +host;

			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

			f.method = "POST";
			f.target = "fileattach";
			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
			f.submit();
		} else if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;

		if (document.form1.attach_gubun.value == "sepoa"){
			GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;

		    getApprovalSend();
		}
	} */

function SignPathSeqSetting()
{
    var sepoa = GridObj;
    var spList =new Array(12);
    //98,98,05,05,09,09,04,04,02,02,37,37,
    //합의{C},결재(P)

	for(var a=0; a<GridObj.GetRowCount();a++)
	{
		var pflag	= GD_GetCellValueIndex(GridObj,a,INDEX_PROCEEDING_FLAG);
	    var mpcode = GD_GetCellValueIndex(GridObj,a,INDEX_MANAGER_POSITION);

	    if( mpcode == "98" && pflag == "C" )    spList[0] = a;
	    else if( mpcode == "98" && pflag == "P" )    spList[1] = a;
	    else if( mpcode == "05" && pflag == "C" )    spList[2] = a;
	    else if( mpcode == "05" && pflag == "P" )    spList[3] = a;
	    else if( mpcode == "09" && pflag == "C" )    spList[4] = a;
	    else if( mpcode == "09" && pflag == "P" )    spList[5] = a;
	    else if( mpcode == "04" && pflag == "C" )    spList[6] = a;
	    else if( mpcode == "04" && pflag == "P" )    spList[7] = a;
	    else if( mpcode == "02" && pflag == "C" )    spList[8] = a;
	    else if( mpcode == "02" && pflag == "P" )    spList[9] = a;
	    else if( mpcode == "37" && pflag == "C" )    spList[10] = a;
	    else if( mpcode == "37" && pflag == "P" )    spList[11] = a;
	}
	var cnt = "1";
    for( j=0; j<spList.length; j++ ){
        if( spList[j] != undefined ){
            GD_SetCellValueIndex(GridObj,spList[j], INDEX_SIGN_PATH_SEQ, cnt);
            cnt++;
        }
    }
	//동일한 결재순서가 존재할시 임의의 것으로 증가시켜준다.
    for(var i=0; i<GridObj.GetRowCount();i++)
    {
    	spath_seq = GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_PATH_SEQ);
        for(var j=0; j<GridObj.GetRowCount();j++)
        {
            if( j != i ){
    	        spath_seq2 = GD_GetCellValueIndex(GridObj,j,INDEX_SIGN_PATH_SEQ);
                if( spath_seq == spath_seq2 ){
                    for(var k=0; k<GridObj.GetRowCount();k++)
                    {
                        spath_seq3 = GD_GetCellValueIndex(GridObj,k,INDEX_SIGN_PATH_SEQ);
                        if( k != i && (eval(spath_seq3) >= eval(spath_seq)) ){
                            GD_SetCellValueIndex(GridObj,k, INDEX_SIGN_PATH_SEQ, eval(spath_seq3)+1);
                        }
                    }
                }
            }
        }
    }
}

/* JTable 에서 생성할 수 있도록 화면 전환이 된다.*/
function doAddRow() {
//	var sepoa = GridObj;
	var insert_flag = document.forms[0].insert_flag.value;
 		
	if (parseInt(GridObj.GetRowCount()) > 1)
	{
		alert("결재경로는 2단계 까지 입니다.");
		return;
	}
	
	for(var i=0; i<GridObj.GetRowCount();i++) {
		GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "false&", "&");
	}

	/* if(insert_flag == "off") { */
		
		dhtmlx_last_row_id++;
		
		var nMaxRow2 = dhtmlx_last_row_id;
		var row_data = "<%=grid_col_id%>";
		
		GridObj.enableSmartRendering(true);
		GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
		GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("USER_POP")).setValue("/images/icon/detail.gif");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(GridObj.GetRowCount()); 
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("PROCEEDING_FLAG")).setValue("P"); 
		
		dhtmlx_before_row_id = nMaxRow2;
		
		//document.forms[0].insert_flag.value = "on";
	/* }else {
		alert("한줄씩만 생성 가능합니다.");
		GridObj.cells(dhtmlx_last_row_id, GridObj.getColIndexById("SELECTED")).setValue("1");
		//GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SELECTED, "true&", "&");
	}    */
	<%-- var activeRow 	= GridObj.GetActiveRowIndex();
	var insertRow	= activeRow + 1;

	if(activeRow == -1){
		GridObj.addRow();
		insertRow = GridObj.GetRowCount()-1;
	}else {
		GridObj.AddRow();
		GridObj.InsertRow(insertRow);
		GridObj.DeleteRow(GridObj.GetRowCount()-1);
	}

	GD_SetCellValueIndex(GridObj,insertRow, 0, "false&", "&");
	GD_SetCellValueIndex(GridObj,insertRow, INDEX_USER_POP, G_IMG_ICON + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,insertRow, INDEX_PROCEEDING_FLAG, "<%= COMBO_M002 %>", "#", "@" );

	for(var i=0; i<GridObj.GetRowCount(); i++){
		GD_SetCellValueIndex(GridObj,i, INDEX_SIGN_PATH_SEQ, i+1);
	} --%>


	<%-- var iMaxRow = GridObj.GetRowCount();
   	GridObj.AddRow();

    GD_SetCellValueIndex(GridObj,iMaxRow, 0, "false&", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SIGN_PATH_SEQ, GridObj.GetRowCount());
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_USER_POP, G_IMG_ICON + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PROCEEDING_FLAG, "<%= COMBO_M002 %>", "#", "@" ); --%>





}

function doDeleteRow() {

	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{
		if("1" == GridObj.cells(grid_array[row], 0).getValue())
		{
			GridObj.deleteRow(grid_array[row]);
    	}
    }
	
	rowcount = GridObj.GetRowCount();
	
	//alert(GridObj.GetRowCount()+"|"+GridObj.getColIndexById("SIGN_PATH_SEQ"));
	 for(var i=0; i<GridObj.GetRowCount();i++) {
		 //alert("rowindex:"+GridObj.getRowIndex(GridObj.getRowId(i))+"|rowid:"+GridObj.getRowId(i)+"|"+GridObj.getColIndexById("SIGN_PATH_SEQ"));
				
		 GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(i+1); 
		
		
	}
	 
	/* var rowcount = GridObj.GetRowCount();
	if (rowcount < 1) return;

	var anw = confirm("삭제하시겠습니까?");
	if(anw == false) return;

	for(var row = rowcount - 1; row >= 0; row--)
	{
		alert(row+"|"+GridObj.cells(GridObj.getRowId(row), 0).getValue());
		 if("1" == GridObj.cells(GridObj.getRowId(row), 0).getValue()){
			GridObj.deleteRow(GridObj.getRowId(row));
    	} 
    }
	 */
	
	
	/* 	var sepoa = GridObj;

	var row_idx = checkedDataRow(INDEX_SELECTED);
	if (row_idx < 1) return;

	var anw = confirm("삭제하시겠습니까?");
	if(anw == false) return;

	for( var i = GridObj.GetRowCount()-1;i >= 0; i--){
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
		if(temp == true) GridObj.deleteRow(i);
	}

	for(var i=0; i<GridObj.GetRowCount();i++) {
		GD_SetCellValueIndex(GridObj,i, INDEX_SIGN_PATH_SEQ, i+1);
	} */

}



/* 생성,삭제하고 난 뒤에 첫 화면(쿼리된 화면)으로 돌아온다.*/
function JavaCall(msg1,msg2, msg3, msg4,msg5) {
	document.forms[0].row.value = msg2;

	if(msg1 == "doData"){
	    Query();
	}

	if(msg1 == "t_insert" && msg3 == "1" ){
	    document.forms[0].seq_chg.value += msg2+"^";
	}

	<%-- if( msg1 == "t_imagetext" ){

		url = "/kr/admin/sepoapopup/cod_cm_lis1.jsp?code=SP0210&function=getUser&values=<%=house_code%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=ID&desc=이름";
		CodeSearchCommon(url,'getUser','','','','');

    }  //밖에 if 문장 끝.. --%>
}

<%-- 결재자 선택 시 리턴함수--%>
function getUser(user_id , user_name, dept, posi, manage_posi,posi_code, manage_posi_code)
{
	//rowid = document.forms[0].row.value;
	/* var count = 0;
	var sepoa = GridObj; */
	//rowid = rowid - 1;
	var selectedId = GridObj.getSelectedId();
	var rowIndex   = GridObj.getRowIndex(selectedId);

	var chk_cnt = 0;
	for(var i=0; i<GridObj.GetRowCount();i++) {

		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_USER_ID);

		if(temp == user_id) {
			alert("이미 지정되어있는 차기결재자 입니다.");
			chk_cnt++;
		}
	}
	
	if(chk_cnt > 0) {
		return;
	}
	
	//if(rowid == 0) {
		GD_SetCellValueIndex(GridObj,rowIndex, INDEX_USER_NAME_LOC, user_name);
		GD_SetCellValueIndex(GridObj,rowIndex, INDEX_DEPT_NAME, dept);
		GD_SetCellValueIndex(GridObj,rowIndex, INDEX_POSITION_NAME, posi);
		GD_SetCellValueIndex(GridObj,rowIndex, INDEX_MANAGER_POSITION_NAME, manage_posi);
		GD_SetCellValueIndex(GridObj,rowIndex, INDEX_SIGN_USER_ID, user_id);
		GD_SetCellValueIndex(GridObj,rowIndex, INDEX_POSITION, posi_code);
		GD_SetCellValueIndex(GridObj,rowIndex, INDEX_MANAGER_POSITION, manage_posi_code);
	//}
}

function popopen()
{
	var url = "/kr/admin/basic/approval2/ap2_bd_lis1.jsp?flag=P";
    CodeSearchCommon(url,'ap2_bd_lis1','600','800','800','600');
}

//-->
</script>

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
	var header_name = GridObj.getColumnId(cellInd);
	document.forms[0].row.value = rowId;
	
	if( header_name == "USER_POP" ){
		
		//url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0210&function=getUser&values=<%=house_code%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=행번&desc=이름";
		//CodeSearchCommon(url,'getUser','','','','');
		window.open("/common/CO_008.jsp?callback=getUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }  
    
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    for(var i = 0 ; i < GridObj.GetRowCount(); i++){
	    GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("USER_POP")).setValue("/images/icon/detail.gif");
	    GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(i+1);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" text="#000000">

<s:header popup="true">
<!--내용시작-->
<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">결재요청</td>
</tr>
</table>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>


<form name="form1">
	<input type="hidden" name="row"          id="row"          value="0">
	<input type="hidden" name="seq_chg"      id="seq_chg"      value="">
	<input type="hidden" name="doc_type"     id="doc_type"     size="15"  value="<%=doc_type%>" readOnly>
	<input type="hidden" name="req_user_id"  id="req_user_id"  size="15"  value="<%=req_user_id%>">
                                                            
	<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
	<input type="hidden" name="att_mode"     id="att_mode"     value="">
	<input type="hidden" name="view_type"    id="view_type"    value="">
	<input type="hidden" name="file_type"    id="file_type"    value="">
	<input type="hidden" name="tmp_att_no"   id="tmp_att_no"   value="">
	<input type="hidden" name="sign_path_no" id="sign_path_no"   value="">
	<input type="hidden" name="insert_flag" id="insert_flag"  value="off">
   	

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td width="30%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재경로선택</td>
	<td width="35%" class="data_td" colspan="3">
		<input type="hidden" name="argent_flag"       id="argent_flag"    style="border: 0px;"   >
		<input type="hidden"   name="argent_flag_value" id="argent_flag_value" value="">
		<div align="left"><script language="javascript">btn("javascript:popopen()","결재경로")</script></div>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>	
<tr>
	<td  class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;상신의견
	</td>
	<td width="35%" class="data_td" colspan="3">
		<textarea name="remark" id="remark" value="" cols="70" rows="5" onKeyUp="return chkMaxByte(500, this, '상신의견');"></textarea>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>	
<tr>
	<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일
	</td>
	<td width="35%" class="data_td" colspan="3" height="30">
		<table>
			<tr>
				<td>
					<script language="javascript">
						function setAttach(attach_key, arrAttrach, rowId, attach_count) {
							document.getElementById("attach_no").value       = attach_key;
							document.getElementById("attach_no_count").value = attach_count;
						}
						btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일등록");
					</script>
				</td>
				<td>
					<input type="text" size="3" readOnly class="input_empty" name="attach_no_count" id="attach_no_count" value="0"  />
					<input type="hidden" name="attach_no" id="attach_no" value="" />
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30" align="right">
		<TABLE cellpadding="0">
			<TR>
				<TD><script language="javascript">btn("javascript:doAddRow()","결재자추가")    </script></TD>
				<TD><script language="javascript">btn("javascript:doDeleteRow()","결재자삭제")   </script></TD>
				<TD><script language="javascript">btn("javascript:doSave()","결재요청")   </script></TD>
				<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>

			</TR>
		</TABLE>
		</td>
	</tr>
</table>

</form>

</s:header>
<s:grid screen_id="PR_T04" grid_obj="GridObj" grid_box="gridbox" />
<s:footer/>
</body>
</html>


