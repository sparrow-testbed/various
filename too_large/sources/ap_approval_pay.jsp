<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<!-- Parameter 정보/Session 정보 -->
<%

	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));

	String app_type 	= JSPUtil.nullToEmpty(request.getParameter("app_type"));

	String TITLE = "결재팝업화면";
	
	String doc_no 	= JSPUtil.nullToEmpty(request.getParameter("doc_no"));
	String doc_seq 	= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));
	String doc_type 	= JSPUtil.nullToEmpty(request.getParameter("doc_type"));
	String app_stage 	= JSPUtil.nullToEmpty(request.getParameter("app_stage"));
	String next_sign_user_id 	= JSPUtil.nullToEmpty(request.getParameter("next_sign_user_id"));
		
%>

<html>
	<head>
		<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>


<!-- TOBE 2017-07-01 통합단말 수신 이벤트 -->
<script language="JavaScript" for=XFramePLUS event="onqrecvcopydata(strQueueKeyIndex)">
	recvLinkData(strQueueKeyIndex);
</script>

		<script language="javascript">
//<!--


var INDEX_SELECTED		    = "";
var INDEX_DOC_NO	        = "";
var INDEX_APP_STAGE	    	= "";
var INDEX_ARGENT_FLAG		= "";
var INDEX_DOC_TYPE	        = "";
var INDEX_DOC_TYPE_TEXT     = "";
var INDEX_SHIPPER_TYPE		= "";
var INDEX_DOC_SEQ	        = "";
var INDEX_COMPANY_CODE		= "";
var INDEX_NEXT_SIGN_USER_ID	= "";
var INDEX_SUBJECT			= "";

/* TOBE 2017-07-01 추가 */
var strSourceSystem = "EPS";	// 송신 시스템 코드
//- (통합단말) UTM(리얼), UTM_D(개발), UTM_T(테스트), UTM_Y(연수)
var strTargetSystem = "UTM";    // 수신 시스템 코드 



function Init() {

	/* TOBE 2017-07-01 추가 */
	var nResult = XFramePLUS.StartCopyData(true, strSourceSystem);// WM_COPYDATA 메시지를 수신하기 위한 윈도우 생성{필수}
	if(nResult != 1) {alert("수신 윈도우 생성 시 오류 발생");}	
	
	setGridDraw();
	GetBrowserInfo(document.form1)
	setHeader();
	setValue();

}


/* ASIS 2017-07-01
function GetBrowserInfo(form){
	try{
		var ret = WooriDeviceForOcx.OpenDevice();
		var msg;
		
		if( ret == 0 ){
			ret = WooriDeviceForOcx.GetTerminalInfo(30);
			
			if( ret == 0 ){
				msg = WooriDeviceForOcx.GetResult();
				var arr = msg.split('');
				
				if(arr.length > 0 && arr[0].length==10){
					if(arr[1] == ""){
						alert("통합 단말에서 사용자 정보를 조회할 수 없습니다.");
						window.close();
					}
					$('#bk_cd').val(arr[0].substr(0,5));
					$('#br_cd').val(arr[0].substr(5,1));
					$('#trm_bno').val(arr[0].substr(6,3));
					$('#user_trm_no').val(arr[0].substr(0,10) + arr[1]);
					$('#txtBrowserInfo').val(arr[0]);
					$('#execute_no').val(arr[1]);
					$("#txtMnno").val(arr[1]);
				}
				else{
					alert("통합 단말 정보가 올바르지 않습니다.");
					window.close();
					
				}
			}
			else{
				msg = WooriDeviceForOcx.GetErrorMsg(ret);
				
				alert(msg);
				window.close();
			}
			
			WooriDeviceForOcx.CloseDevice();
		}
		else{
			msg = WooriDeviceForOcx.GetErrorMsg(ret);
			
			alert(msg);
			
			window.close();
		}
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		window.close();
	}	
}
*/


/* TOBE 2017-07-01 통합단말 사용자정보 */
function GetBrowserInfo(form){
	try{	
		// 우선적으로 데이터를 클리어한다
		XFramePLUS.clear(key);
		var key = XFramePLUS.GetQueueKeyIndex(strSourceSystem, "ZZZZZ");
		
		// 공통부(헤더)의 데이터를 채운다
		XFramePLUS.AddStr(key, "SOURCE_SYS"    , strSourceSystem ); // 송신하는 시스템코드 {필수}
		XFramePLUS.AddStr(key, "USER_ID"       , '<%=user_id%>'  ); // 행번 {필수}
 		XFramePLUS.AddStr(key, "BROWSER_INFO"  , "TRUE"          ); // 단말정보
		
		//메모리에 누적된 데이터를 확인
 		//alert(XFramePLUS.Command(key));
		//alert(XFramePLUS.Data(key));
		
 		// 송신
		var nResult = XFramePLUS.QMergeSend(strTargetSystem, key); //연결 시스템 코드 (수신대상)
		if(nResult != 1) {	alert("통합단말 데이터 송신 시 오류 발생");	}
		
		// 송신 후  데이터를 클리어한다
		XFramePLUS.clear(key);
		
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		window.close();
	}	
}


//TOBE 2017-07-01 통합단말 수신 이벤트 발생시 호출
function recvLinkData(strQueueKeyIndex)
{
		
		/*통합단말에서 받은 DATA 담을 변수*/
		var strTargetSystem, userId, strScreenNo;
		var arrSendSeq    = new Array();
		var arrSendData   = new Array();
		
		/*통합단말에서 받은 DATA 변수에 set*/
		var nCnt = XFramePLUS.RCount(strQueueKeyIndex);
		var strCmd  = "", strData = "", strCmdAll  = "", strDataAll = "", strBrowserInfo = "", strFingerPrint = "";
		
		for(var i = 0; i < nCnt ; i++){
			
			strCmd  = XFramePLUS.RCommand(strQueueKeyIndex, i); //수신 받은 데이터의 항목명
			strData = XFramePLUS.RData(strQueueKeyIndex, i);    //수신 받은 데이터의 값
			
			strCmdAll  += strCmd +"|";                          //수신항목명   확인용 ROW조립
			strDataAll += strData +"|";                         //수신데이터값 확인용 ROW조립
			
			if(strCmd == "SOURCE_SYS"){                         //시스템코드
				strTargetSystem = strData;
			}
			else if(strCmd == "USER_ID"){                       //사용자행번
				userId = strData;
			}
			else if(strCmd == "SCREEN_NO"){                     //거래화면일련번호
				strScreenNo = strData;
			}
			else if(strCmd.substr(0,1) == "S"){
				arrSendSeq.push( strCmd.substr(1,4) );
				arrSendData.push( strData );
			}
		}
		 
     //alert(strQueueKeyIndex); // 테스트 확인용 오픈시 제거
     //alert(strCmdAll);        // 테스트 확인용 오픈시 제거
     //alert(strDataAll);       // 테스트 확인용 오픈시 제거

     XFramePLUS.RClear(strQueueKeyIndex); // 수신 받은 데이터 삭제
	
}


function setHeader() {

	INDEX_SELECTED		    = GridObj.GetColHDIndex("SELECTED");
	INDEX_DOC_NO	    	= GridObj.GetColHDIndex("DOC_NO");
	INDEX_SUBJECT	        = GridObj.GetColHDIndex("SUBJECT");
	INDEX_APP_STAGE   		= GridObj.GetColHDIndex("APP_STAGE");
	INDEX_ARGENT_FLAG     	= GridObj.GetColHDIndex("ARGENT_FLAG");
	INDEX_DOC_TYPE     		= GridObj.GetColHDIndex("DOC_TYPE");
	INDEX_DOC_TYPE_TEXT     = GridObj.GetColHDIndex("DOC_TYPE_TEXT");
	INDEX_SHIPPER_TYPE	    = GridObj.GetColHDIndex("SHIPPER_TYPE");
	INDEX_DOC_SEQ	        = GridObj.GetColHDIndex("DOC_SEQ");
	INDEX_COMPANY_CODE	    = GridObj.GetColHDIndex("COMPANY_CODE");
	INDEX_NEXT_SIGN_USER_ID	= GridObj.GetColHDIndex("NEXT_SIGN_USER_ID");

}

function setValue()
{
	
	var max = parent.opener.row_id;
// 	var max = parent.opener.GridObj.getSelectedRowId('SELECTED');
	var i ,				doc_no, 	app_stage, 		argent_flag,		doc_type  , text_doc_type;
	var shipper_type,	doc_seq, 	company_code, 	next_sign_user_id,  subject;
	var j = "0";
	var P = parent.opener.GridObj;
	

	for(i =0; i <1; i++)
	{
		var temp = parent.opener.row_id;
		
		if(temp!=0) {
			
			doc_no 				= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_DOC_NO);

		
			/*
			 기존 : 현결재단계 = 이전결재단계 + 1
			 합의가 추가되면서  현결재단계 = 이전결재단계 + 1 이 아니다.
			 //app_stage 			= parseInt(GD_GetCellValueIndex(P,i,parent.opener.INDEX_APP_STAGE))+1;
			*/
			app_stage 			= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_SIGN_PATH_SEQ);
			argent_flag 		= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_ARGENT_FLAG);
			doc_type 			= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_DOC_TYPE);
			text_doc_type		= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_DOC_TYPE_TEXT);
			subject 			= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_SUBJECT);
			shipper_type 		= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_SHIPPER_TYPE);
			doc_seq 			= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_DOC_SEQ);
			company_code 		= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_COMPANY_CODE);
			next_sign_user_id 	= GD_GetCellValueIndex(P,max-1,parent.opener.INDEX_NEXT_SIGN_USER_ID);
			
			
			GridObj.AddRow();
			
			GD_SetCellValueIndex(GridObj,j,INDEX_SELECTED,			"true&", "&");
			GD_SetCellValueIndex(GridObj,j,INDEX_DOC_NO,				doc_no);
			GD_SetCellValueIndex(GridObj,j,INDEX_SUBJECT,				subject);
			GD_SetCellValueIndex(GridObj,j,INDEX_APP_STAGE,			app_stage);
			if(argent_flag=="T"){
				GD_SetCellValueIndex(GridObj,j,INDEX_ARGENT_FLAG,		"긴급");
			}else{
				GD_SetCellValueIndex(GridObj,j,INDEX_ARGENT_FLAG,		"");
			}
			GD_SetCellValueIndex(GridObj,j,INDEX_DOC_TYPE,			doc_type);
			GD_SetCellValueIndex(GridObj,j,INDEX_DOC_TYPE_TEXT,			text_doc_type);
			GD_SetCellValueIndex(GridObj,j,INDEX_SHIPPER_TYPE,		shipper_type);
			GD_SetCellValueIndex(GridObj,j,INDEX_DOC_SEQ,			doc_seq);
			GD_SetCellValueIndex(GridObj,j,INDEX_COMPANY_CODE,		company_code);
			GD_SetCellValueIndex(GridObj,j,INDEX_NEXT_SIGN_USER_ID,	next_sign_user_id);
			
			
			$('#doc_no').val(doc_no);
			$('#doc_type').val(doc_type);
			$('#next_sign_user_id').val(next_sign_user_id);
	
			j++;
		}
	}
	
	
}

function Confirm() {
	
	<%--opener.payFrm. doSaveOT8602('<%=doc_no%>','<%=doc_seq%>','<%=doc_type%>','<%=app_stage%>','<%=next_sign_user_id%>',document.forms[0].remark.value);--%>
	//return;
	

	for(var i = 0; i < GridObj.getRowsNum(); i++)
	{
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED"); 
	var remark = document.forms[0].remark.value;
	var app_type = document.forms[0].app_type.value;
	
	if('<%=app_type%>'=='R' && remark == ""){
		alert("반려사유를 적으셔야 합니다.");
		return;
	}

	//더블 클릭 방지용
	if( document.forms[0].confirm_flag.value == "Y" ){
		return;
	}



	document.forms[0].confirm_flag.value = "Y";

    <%-- GridObj.SetParam("mode", 	"app_end");
	GridObj.SetParam("remark",	remark);
    GridObj.SetParam("app_type",	'<%=app_type%>');

    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL");
    GridObj.strHDClickAction="sortmulti"; --%>
    
    var cols_ids = "<%=grid_col_id%>";
 	var params = "mode=setAppUpdate";
    params += "&cols_ids="+cols_ids;
    params += "&remark="+remark;
    params += "&app_type="+app_type;
 	params += dataOutput();
 	
 	
    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_wait_list" , params);
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array ); 
}

function JavaCall(msg1,msg2, msg3, msg4,msg5) {
	//alert("msg1=" +msg1+"msg2="+msg2+"msg3="+msg3+"msg4="+msg4+"msg5="+msg5);
	if(msg1=="doData") {

		if(GD_GetParam(GridObj,0) == "1") {
			opener.Query("close");
			window.close();
		}else {
			alert(GridObj.GetMessage());
		}
	}
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
    	/* GridObj.setColumnHidden(GridObj.getColIndexById("APP_STATUS_TEXT"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("DOC_NO"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("ITEM_COUNT"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("ADD_USER_NAME"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("SIGN_REMARK"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("SIGN_DATE"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("ADD_DATE"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("SIGN_PATH"), true);
    	GridObj.setColumnHidden(GridObj.getColIndexById("ATTACH_NO"), true); 
    	GridObj.setColumnHidden(GridObj.getColIndexById("ARGENT_FLAG"), false); 
    	GridObj.setColumnHidden(GridObj.getColIndexById("NEXT_SIGN_USER_ID"), false);   */
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
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
		opener.Query("close");
		window.close();
        //doQuery();
    } else {
        alert(messsage);
    }
//     if("undefined" != typeof JavaCall) {
//     	JavaCall("doData");
//     } 

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
<body onload="Init();" bgcolor="#FFFFFF" text="#000000" >
<s:header popup="true">

<!--내용시작-->
<%
   String title_title = "";
   String remark_title = "";

     if(app_type.equals("R")) {
        title_title = "결재 반려";
        remark_title = "반려 의견";
     }else if(app_type.equals("E")) {
        title_title = "결재 승인";
        remark_title = "승인 의견";
     }else {
        title_title = "결재 상신";
        remark_title = "상신 의견";
     }
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'><%=title_title%>
	</td>
</tr>
</table>

<form name="form1">
<input type="hidden"  value="N" name="confirm_flag" id="confirm_flag">
<input type="hidden"  name="app_type"           id="app_type"    value="<%=app_type%>" >
<input type="hidden"  name="doc_no"             id="doc_no"      value="" >
<input type="hidden"  name="doc_type"           id="doc_type"    value="" >
<input type="hidden"  name="next_sign_user_id"  id="next_sign_user_id" value="" >

<input type="hidden"    id="bk_cd"              name="bk_cd"            value="">
<input type="hidden"    id="br_cd"              name="br_cd"            value="">
<input type="hidden"    id="trm_bno"          name="trm_bno"          value="">
<input type="hidden"    id="user_trm_no"      name="user_trm_no"      value="">
<input type="hidden"    id="txtBrowserInfo"   name="txtBrowserInfo"   value="">
<INPUT type="hidden"  id="txtLevel"            name="txtLevel"         value="10">
<INPUT type="hidden"  id="txtManagerList"   name="txtManagerList"   value="">

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<div style="display:none">
<s:grid screen_id="AP_001" grid_obj="GridObj" grid_box="gridbox" height="100" />
</div>
  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>

	    	  			<TD><script language="javascript">btn("javascript:Confirm()","확 인")    </script></TD>
						<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>

	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td width="78%" class="cell3_title"><b><%=remark_title%></b>
  		</td>
	</tr>
	<tr>
  		<td height="5" bgcolor="#FFFFFF"></td>
	</tr>
</table>

<table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#407bbc" style="border-collapse:collapse;">

<tr>
		<td class="c_data_1_p">
     			<div align="left">
   				<textarea name="remark" id="remark" value="" cols="100" rows="5" style="width:98%; height: 60px; ime-mode:active;" onKeyUp="return chkMaxByte(500, this, '<%=remark_title%>');"></textarea>
    				</div>
		</td>
</tr>
</table>

</form>
</s:header>
<s:footer/>
<!-- ASIS 2017-07-01 
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
</OBJECT>
-->
<!-- TOBE 2017-07-01 -->
<object ID="XFramePLUS" CLASSID="CLSID:D6091B5A-D59C-454b-83A4-FA489E94BE0B" width=0 height=0 VIEWASTEXT></object>

	</body>
</html>


