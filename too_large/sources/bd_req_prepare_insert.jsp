<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_011");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_011";
	String grid_obj  = "GridObj";
	
	Config conf = new Configuration();
	
	boolean isSelectScreen = false;
 
    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String COST_STATUS   = JSPUtil.nullToEmpty(request.getParameter("COST_STATUS"));
	String BID_STATUS    = JSPUtil.nullToEmpty(request.getParameter("BID_STATUS"));
	String BID_TYPE      = JSPUtil.nullToEmpty(request.getParameter("BID_TYPE"));

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_NO             = "";
    String ANN_ITEM           = "";
    String ANN_DATE           = "";
    String CONT_TYPE1_TEXT_D  = "";
    String CONT_TYPE2_TEXT_D  = "";
    String CONT_TYPE1_TEXT_CS = "";
    String CONT_TYPE2_TEXT_CS = "";
    String CTRL_AMT           = "0";
    String CRYP_CERT          = "";
    String ESTM_FLAG          = "";

    String AMT                = "0";
    String ESTM_PRICE1_ENC    = "";
    String ESTM_PRICE1        = "0";

    String CERTV              = "";
    String TIMESTAMP          = "";
    String SIGN_CERT          = "";

	String COST_STATUS_TEXT		= "";
	String PR_AMT				= "0";
	String PR_AMT_NOVAT			= "0";
	String REQ_COMMENT			= "";
	String BASIC_AMT			= "";

	String ATTACH_NO			= "";
	String ATTACH_CNT			= "0";

	String ESTM_USER_ID			= "";
	String ESTM_USER_NAME 		= "";

    boolean sign_result       = false;  //서명검증

	Map map = new HashMap();
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_010", "CONNECTION","getBdReqPrepareHeader", obj);
	
	SepoaFormater wf1 = new SepoaFormater(value.result[0]); 
	SepoaFormater wf2 = new SepoaFormater(value.result[1]); 
	SepoaFormater wf3 = new SepoaFormater(value.result[2]); 
 

		if(wf1.getRowCount() > 0){

	        CONT_TYPE1                   = wf1.getValue("CONT_TYPE1"            ,0);
	        CONT_TYPE2                   = wf1.getValue("CONT_TYPE2"            ,0);
	        ANN_NO                       = wf1.getValue("ANN_NO"                ,0);
	        ANN_ITEM                     = wf1.getValue("ANN_ITEM"              ,0);
	        ANN_DATE                     = wf1.getValue("ANN_DATE"              ,0);
	        CONT_TYPE1_TEXT_D            = wf1.getValue("CONT_TYPE1_TEXT_D"     ,0);
	        CONT_TYPE2_TEXT_D            = wf1.getValue("CONT_TYPE2_TEXT_D"     ,0);
	        CONT_TYPE1_TEXT_CS           = wf1.getValue("CONT_TYPE1_TEXT_CS"     ,0);
	        CONT_TYPE2_TEXT_CS           = wf1.getValue("CONT_TYPE2_TEXT_CS"     ,0);
	        CTRL_AMT                     = wf1.getValue("CTRL_AMT"              ,0);
	        CRYP_CERT                    = wf1.getValue("CRYP_CERT"             ,0);
	        if (ANN_DATE.length() == 8) {
	            ANN_DATE = ANN_DATE.substring(0,4) + "/" + ANN_DATE.substring(4,6) + "/" + ANN_DATE.substring(6,8);
	        }
	        ESTM_FLAG                    = wf1.getValue("ESTM_FLAG"             ,0);
	        COST_STATUS                  = wf1.getValue("COST_STATUS"           ,0);

	        if(COST_STATUS.equals("EC")){
	        	COST_STATUS_TEXT = "확정";
	        }else{
	        	COST_STATUS_TEXT = "미확정";
	        }

	        if(CONT_TYPE2.equals("PQ") || CONT_TYPE2.equals("QE")){
	        	CONT_TYPE2_TEXT_D = CONT_TYPE2_TEXT_CS;
	        }

	    }

		if(wf2.getRowCount() > 0){
	        BASIC_AMT   		= wf2.getValue("BASIC_AMT"   		,0);
	        REQ_COMMENT   		= wf2.getValue("REQ_COMMENT"   		,0);
	        ESTM_PRICE1_ENC     = wf2.getValue("ESTM_PRICE1_ENC"    ,0);
	        ATTACH_NO           = wf2.getValue("ATTACH_NO"          ,0);
	        ATTACH_CNT          = wf2.getValue("ATTACH_CNT"         ,0);
	        ESTM_USER_ID        = wf2.getValue("ESTM_USER_ID"       ,0);
	        ESTM_USER_NAME      = wf2.getValue("ESTM_USER_NAME"     ,0);
		}else{
			if(wf3.getRowCount() > 0){
				BASIC_AMT   		= wf3.getValue("PR_AMT_NOVAT"       ,0);
			}
		}

		if(wf3.getRowCount() > 0){
        	PR_AMT              = wf3.getValue("PR_AMT"           	,0);
        	PR_AMT_NOVAT 		= wf3.getValue("PR_AMT_NOVAT"       ,0);
    	}

		if (BASIC_AMT.equals(""))    BASIC_AMT    = "0";
		if (PR_AMT.equals(""))       PR_AMT       = "0";
		if (PR_AMT_NOVAT.equals("")) PR_AMT_NOVAT = "0";
 
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  --> 
<Script language="javascript">
<!--

    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";

	var save_mode   = "";
	var button_flag = false;

    var date_flag;
	var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
  
	function getApprovalSend() {

        var ATTACH_NO           = document.forms[0].attach_no.value;
        var BASIC_AMT           = del_comma(document.forms[0].BASIC_AMT.value);
        var REQ_COMMENT         = document.forms[0].REQ_COMMENT.value;
        var ESTM_USER_ID        = document.forms[0].ESTM_USER_ID.value;
		var flag                = document.forms[0].approval_str.value;

        mode = "doSave";

        servletUrl = "/servlets/dt.bidd.ebd_pp_ins14"; //p1012

        GridObj.SetParam("mode", mode);

        GridObj.SetParam("BID_NO",        "<%=BID_NO%>"           );
        GridObj.SetParam("BID_COUNT",     "<%=BID_COUNT%>"        );
        GridObj.SetParam("ATTACH_NO", 	ATTACH_NO            	);
        GridObj.SetParam("BASIC_AMT",     BASIC_AMT             	);
        GridObj.SetParam("REQ_COMMENT",   REQ_COMMENT             );
        GridObj.SetParam("ESTM_USER_ID",  ESTM_USER_ID        	);
        GridObj.SetParam("FLAG",       	flag        			);

        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}
	
	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
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
		
		if (document.form1.attach_gubun.value == "wise"){
			GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;
		    
		    getApprovalSend();
		}
	}

    function setOnFocus(obj) {
    	blurCnt = 0;
        var target = eval("document.forms[0]." + obj.name);
        target.value = del_comma(target.value);
        target.select();
    }
	
	var blurCnt = 0;
    function setOnBlur(obj) {
    	if(blurCnt == 0){
    		var target = eval("document.forms[0]." + obj.name);

        	if(IsNumber(del_comma(target.value)) == false) {
            	alert("숫자를 입력하세요.");
            	target.value = "";
            	target.focus();
            	return;
        	}
        	target.value = parseFloat(target.value);
        	target.value = add_comma(target.value,0);
    		blurCnt = 1;
    	}    	
	}
 

	function getUser(){
<%-- 		//var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9113&function=D&values=<%=HOUSE_CODE%>&values=<%=COMPANY_CODE%>&values=&values="; --%>
		//Code_Search(url,'','','','','');
<%--         var url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9113&function=SP9113_getCode&values=<%=HOUSE_CODE%>&values=<%=COMPANY_CODE%>&values=&values="; --%>
//         Code_Search(url, 'SP9113', '', '', '', '');
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}

	function getAddUser(id, name) {
		document.forms[0].ESTM_USER_ID.value = id;
		document.forms[0].ESTM_USER_NAME.value = name;
	}

	function getVendor(){
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0232&function=D&values=<%=HOUSE_CODE%>&values=&values=";
		Code_Search(url,'','','','','');
	}

	function SP0232_getCode(VENDOR_CODE, VENDOR_NAME, IRS_NO, CEO_NAME_LOC) {
		var	checked_count =	0;
		var	rowcount = GridObj.GetRowCount();
		var	ck_vendor_code = "";
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		if(msg1 == "doQuery") {

        } else if(msg1 == "doData") { // 전송/저장시
            alert(GD_GetParam(GridObj,0));
            button_flag = false; // 버튼 action ...  action을 취할수있도록...
            location.href ="ebd_bd_lis12.jsp"
		}else if(msg1 == "t_header") {

		} else if(msg1 == "t_insert") {

        }
	}

//-->
</Script>



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
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_req_prepare_insert";

function init() {
	setGridDraw(); 
    doQuery();
}
	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    
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
    var pflag  = obj.getAttribute("pflag");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        if(pflag =="C"){
        	location.href="bd_req_prepare_list.jsp";
        }else{ 
            button_flag = false;
        }
        //doQuery();
    } else {
        alert(messsage);
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

// 조회
function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdReqPrepareInsert";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);

	for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
		GridObj.enableSmartRendering(true);
    	GridObj.selectRowById(GridObj.getRowId(i), false, true);
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");	
    	
	}		
    return true;
}

//★GRID CHECK BOX가 체크되었는지 체크해주는 공통 함수[필수]
function checkRows() {

 var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

 if( grid_array.length > 0 ) {
     return true;
 }

 alert("<%=text.get("MESSAGE.MSG_1001")%>");<%-- 대상건을 선택하십시오.--%>
 return false;

}
function doSave(flag) {

	if(!checkRows()) return;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    
    if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }

    if(LRTrim(document.forms[0].BASIC_AMT.value) == "") {
        alert("예상금액을 입력하세요.");
        button_flag = false;
        document.forms[0].BASIC_AMT.focus();
        return;
    }

    if(LRTrim(document.forms[0].ESTM_USER_ID.value) == "") {
        alert("내정가격 담당자를 입력하세요.");
        button_flag = false;
        document.forms[0].ESTM_USER_ID.focus();
        return;
    }

    if(flag == "P"){
        if(confirm("저장 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    }else if(flag == "C"){
        if(confirm("등록요청 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    }

    button_flag = true;
    
    document.forms[0].approval_str.value = flag;
    document.forms[0].BASIC_AMT.value = del_comma(document.forms[0].BASIC_AMT.value);

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=setReqPrepare";
 
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    myDataProcessor = new dataProcessor( G_SERVLETURL, params );
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
}

// 첨부파일
function setAttach(attach_key, arrAttrach, rowId,attach_count) {
	if(document.forms[0].isGridAttach.value == "true"){
		setAttach_Grid(attach_key, arrAttrach, attach_count);
		return;
	}
    var attachfilename  = arrAttrach + "";
    var result 			="";
	var attach_info 	= attachfilename.split(",");
	for (var i =0;  i <  attach_count; i ++)
    {
	    var doc_no 			= attach_info[0+(i*7)];
		var doc_seq 		= attach_info[1+(i*7)];
		var type 			= attach_info[2+(i*7)];
		var des_file_name 	= attach_info[3+(i*7)];
		var src_file_name 	= attach_info[4+(i*7)];
		var file_size 		= attach_info[5+(i*7)];
		var add_user_id 	= attach_info[6+(i*7)];

		if (i == attach_count-1)
			result = result + src_file_name;
		else
			result = result + src_file_name + ",";
	}
	document.forms[0].attach_no.value     	= attach_key;
	document.forms[0].attach_cnt.value     	= attach_count;
    document.getElementById("attach_no_text").innerHTML = "";
    document.forms[0].only_attach.value = "attach_no";
    //setAttach1();
}

function setAttach1() {
    var nickName        = "SIF_001";
    var conType         = "TRANSACTION";
    var methodName      = "getFileNames";
    var SepoaOut        = doServiceAjax( nickName, conType, methodName );
    
    if( SepoaOut.status == "1" ) { // 성공
        //alert("성공적으로 처리 하였습니다.");
        var test = (SepoaOut.result[0]).split("<%=conf.getString( "sepoa.separator.line" )%>");
        var test1 = test[1].split("<%=conf.getString( "sepoa.separator.field" )%>");
        
        setAttach2(test1[0]);
        
    } else { // 실패
<%--             alert("<%=text.get("MESSAGE.1002")%>"); --%>
    }
}

function setAttach2(result){
    var text  = result.split("||");
    var text1 = "";

    for( var i = 0; i < text.length ; i++ ){
        
        text1  += text[i] + "<br/>";
    }
    
    document.getElementById("attach_no_text").innerHTML = text1;
}


//그리드 파일첨부
function setAttach_Grid(attach_key, arrAttrach, attach_count) {
    var attachfilename  = arrAttrach + "";
    var result 			="";
	var attach_info 	= attachfilename.split(",");
	for (var i =0;  i <  attach_count; i ++)
    {
	    var doc_no 			= attach_info[0+(i*7)];
		var doc_seq 		= attach_info[1+(i*7)];
		var type 			= attach_info[2+(i*7)];
		var des_file_name 	= attach_info[3+(i*7)];
		var src_file_name 	= attach_info[4+(i*7)];
		var file_size 		= attach_info[5+(i*7)];
		var add_user_id 	= attach_info[6+(i*7)];

		if (i == attach_count-1)
			result = result + src_file_name;
		else
			result = result + src_file_name + ",";
	}
	GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO")).setValue(attach_key);
	GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO_CNT")).setValue(attach_count);
	document.forms[0].isGridAttach.value = "false";
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 

<form name="form1" method="post" >
	<input type="hidden" name="FLAG" value="">
	<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>">
	<input type="hidden" name="ANN_ITEM" id="ANN_ITEM" value="<%=ANN_ITEM%>">
	<input type="hidden" name="COST_STATUS" id="COST_STATUS" value="<%=COST_STATUS%>">
	<input type="hidden" name="BID_STATUS" id="BID_STATUS" value="<%=BID_STATUS%>">
	<input type="hidden" name="CERTV" value="">
	<input type="hidden" name="TIMESTAMP" value="">
	<input type="hidden" name="SIGN_CERT" value="">
	<input type="hidden" name="TMAX_RAND" value="">
	<input type="hidden" name="CRYP_CERT" value="<%=CRYP_CERT%>">
	<input type="hidden" name="H_BASIC_AMT" value="">
	<input type="hidden" name="ESTM_PRICE1_ENC" value="<%=ESTM_PRICE1_ENC%>">

	<input type="hidden" name="attach_gubun" 	value="body">  
	<input type="hidden" name="att_show_flag">
	<input type="hidden" name="attach_seq">	
	<input type="hidden" name="isGridAttach">
	<input type="hidden" name="only_attach" id="only_attach" value="">
	<input type="hidden" name="att_mode"  		value="">
	<input type="hidden" name="view_type"  		value="">
	<input type="hidden" name="file_type"  		value="">
	<input type="hidden" name="tmp_att_no" 		value="">
	<input type="hidden" name="approval_str"  	id="approval_str"  	value="">


<%@ include file="/include/sepoa_milestone.jsp"%>
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
    <colgroup>
        <col width="15%" />
        <col width="35%" />
        <col width="15%" />
        <col width="35%" />
    </colgroup>   
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      <td width="35%" class="data_td">&nbsp;
        <%=ANN_NO%>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 내정가격확정여부</td>
      <td width="35%" class="data_td">&nbsp;
        <%=COST_STATUS_TEXT%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고일자</td>
      <td class="data_td">&nbsp;
      <%=ANN_DATE%>
      </td>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰방법</td>
      <td class="data_td">&nbsp;
        <%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰건명</td>
      <td class="data_td">&nbsp;
        <%=ANN_ITEM%>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 예상금액</td>
      <td class="data_td">&nbsp;
        <%=SepoaMath.SepoaNumberType(Double.parseDouble(PR_AMT_NOVAT),"###,###,###,###,###.##")%>&nbsp;원&nbsp;(VAT 포함)
      </td>
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
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
				<%
    if(!BID_STATUS.equals("NB") && !BID_STATUS.equals("SB")) {
        if(!COST_STATUS.equals("EC")) {
%>
    	  			
	      			<TD><script language="javascript">btn("javascript:doSave('P')", "저 장")</script></TD>
	      			<TD><script language="javascript">btn("javascript:doSave('C')", "등록요청")</script></TD>
<%
        }
    }
%>
	      			<TD><script language="javascript">btn("javascript:history.back(-1)", "취 소")</script></TD>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
 
<s:grid screen_id="BD_011" grid_obj="GridObj" grid_box="gridbox"/>
<br>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 예정가격</td>
      	<td colspan="3" class="data_td">&nbsp;
		<%
		    if(COST_STATUS.equals("EC")) {
		%>
	        <input type="text" name="BASIC_AMT" id="BASIC_AMT" value="<%=SepoaMath.SepoaNumberType(Double.parseDouble(BASIC_AMT),"###,###,###,###,###.##")%>" readonly  style="text-align: right;"  >
		<%
		    } else {
		%>
        	<input type="text" name="BASIC_AMT" id="BASIC_AMT" value="<%=SepoaMath.SepoaNumberType(Double.parseDouble(BASIC_AMT),"###,###,###,###,###.##")%>" onblur="javascript:setOnBlur(this);" onFocus="javascript:setOnFocus(this);"   style="text-align: right;" >
		<%
		    }
		%>
        &nbsp;원&nbsp;(VAT포함)
      	</td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>      
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
        			<td class="data_td" id="attach_td_id" colspan="3">
        				<TABLE>
    		      			<TR>
    		      				<td><input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>"></td>
    	    	  				<td><script language="javascript">btn("javascript:attach_file(document.forms[0].attach_no.value,'TEMP');document.forms[0].attach_seq.value=1","파일첨부")</script></td>
    		      				<td><input type="text" name="attach_cnt" id="attach_cnt" size="3" readonly value="<%=ATTACH_CNT%>">
                                    <input type="text" size="5" readOnly value="<%=text.get("MESSAGE.file_count")%>" name="file_count">
                                </td>
                                <td width="170">
                                    <div id="attach_no_text"></div>
                                </td>
    						</TR>
						</TABLE>
        			</td> 
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; MEMO </td>
      	<td colspan="3" class="data_td">&nbsp;
		<%
		    if(COST_STATUS.equals("EC")) {
		%>
        	<textarea name="REQ_COMMENT" id="REQ_COMMENT" cols="85" rows="3"  readonly ><%=REQ_COMMENT%></textarea>
		<%
		    } else {
		%>
        	<textarea name="REQ_COMMENT" id="REQ_COMMENT" cols="85" rows="3"  onKeyUp="return chkMaxByte(4000, this, 'MEMO');"><%=REQ_COMMENT%></textarea>
		<%
		    }
		%>
      	</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  
    <!-- 예가담당자를 세팅하여 예가를 입력할 경우 -->
    <tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 내정가격 담당자<br>
      	</td>
      	<td colspan="3" class="data_td">&nbsp;
        	<input type="text" size="12" value="<%=ESTM_USER_ID%>" name="ESTM_USER_ID" id="ESTM_USER_ID"  readonly >
        	<a href="javascript:getUser()"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/query.gif" align="absmiddle" border="0"></a>
        	<input type="text" value="<%=ESTM_USER_NAME%>" name="ESTM_USER_NAME" id="ESTM_USER_NAME" size="20" readOnly >
        	
        	
        	
<%-- 			<input type="text" name="ESTM_USER_ID" id="ESTM_USER_ID" size="13" class="input_re"  value='<%=info.getSession("ID")%>' readOnly> --%>
<%--         	<a href="javascript:getUser()"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/query.gif" align="absmiddle" border="0"></a> --%>
<%-- 				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""> --%>
<%-- 			<input type="text" name="ESTM_USER_NAME" id="ESTM_USER_NAME" size="20" class="input_data2"  value='<%=info.getSession("NAME_LOC")%>'>        	 --%>
        	
        	
      	</td>
    </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	
</form>

<!---- END OF USER SOURCE CODE ----> 

<!---- TMAX ---->
<!-- 예가를 직접입력하는 경우 예가 암호화에 사용 -->
<form name="form2" action="/kr/certificate_wk_dis.jsp" method="post" target="child_frame" >
	<input type="hidden" 	name="function" value="doSignConfirm">
	<textarea name="signdata" style="display:none;"></textarea>
	<textarea name="vid_msg" style="display:none;"></textarea>
	<textarea name="plainText" style="display:none;"></textarea>	
	<textarea cols="50" name="CERTV" style="display:none;"></textarea><!-- 전자서명값-->
	<textarea cols="50" name="SIGN_CERT" style="display:none;"></textarea><!-- 전자서명 인증서번호-->
	<textarea cols="50" name="CRYP_CERT" style="display:none;"></textarea><!-- 전자서명 인증서번호-->	
	<textarea cols="50" name="TIMESTAMP" style="display:none;"></textarea><!-- TIMESTAMP-->
</form>
<iframe SRC="" NAME="child_frame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" style="width: 0px; height: 0px;"></iframe>
</s:header>
<s:footer/>
</body>
</html> 


