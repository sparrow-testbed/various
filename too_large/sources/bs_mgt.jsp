<%-- TOBE 2017-07-01 재무회계 입지대사 처리--%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("BS_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "BS_001";
	String grid_obj  = "GridObj";
	// 조회 전용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var PrcStatus = 0;
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
		return true;
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	
	var header_name = GridObj.getColumnId(cellInd);
	if(header_name == "MNG_BRNM" || header_name == "MNG_BRCD") {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		window.open("/common/CO_009.jsp?callback=getDemandGrid&vendor_serch=Y", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	
}
function getDemandGrid(code, text, addrLoc, addrLoc, igjmCd){
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.getColIndexById("MNG_BRCD"), igjmCd);  //조회된 일계정 세팅
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.getColIndexById("MNG_BRNM"), text);

}   
    



function doOnClickBr(){
	var url = "";
	var f = document.forms[0];
    window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}

function getDemand(code, text){
	//document.form1.demand_dept_name.value = text;
	document.form.dl_brcd.value = code;
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

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("BS_001.0006")%>");
		return false;
	}

	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'SELECTED') return;
		GridObj.SetCellValue("SELECTED", nRow, "1");
	}

	function initAjax(){
		doRequestUsingPOST( 'SL5001', 'M200' ,'type', '' );
		doRequestUsingPOST( 'SL5003', 'M013' ,'language', '' );
		doRequestUsingPOST( 'SL5001', 'HSCD' ,'house_code', '' );
	}

    // 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 post 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{
		var exe_dt   = document.form.exe_dt.value;   //실행일자
		var accd     = document.form.accd.value;     //계정과목코드
		var trn_stcd = document.form.trn_stcd.value; //실행취소구분 --거래상태코드
		var acct_dt  = document.form.acct_dt.value;  //회계일자
		var dl_brcd  = document.form.dl_brcd.value;  //일계점코드
		var grid_col_id = "<%=grid_col_id%>";
		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/admin.acc.bs_mgt","exe_dt=" +exe_dt+"&accd="+accd+"&trn_stcd="+trn_stcd+"&acct_dt="+acct_dt+"&dl_brcd="+ dl_brcd+"&mode=query&grid_col_id="+grid_col_id);
		
		
		GridObj.clearAll(false);
	}

	//BS실행  Web실행 로직
	function doBsPrcStart()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		if (grid_array.length > 1 )
		{
			alert("한건씩 처리하시기 바랍니다.");
			return;
		}
		else if (grid_array.length == 0 )
		{
			alert("처리할 대상이 없습니다.");
			return;
		}

		for(var i = 0; i < grid_array.length; i++)
		{
			<%-- 화면ID는 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EPS_STCD")).getValue()) == "00")
			{
				doBsPrcMsgSend();
				
			}
			else if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EPS_STCD")).getValue()) == "10")
			{   //WEB전문 전송
				doWebPrcMsgSend();
			}
			else
			{
				alert("실행대상건이 아닙니다.");
			}
		}


	}
	
	//BS실행전문 전송
	function   doBsPrcMsgSend()
	{
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
	    if (confirm("BS전문 전송하시겠습니까?")) {
	            var cols_ids = "<%=grid_col_id%>";
	            myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/admin.acc.bs_mgt?cols_ids="+cols_ids+"&mode=MakeBsPrcMsg");
	            sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);    
	    }

	}

	//BS실행후 WEB실행 전문수행한다.
	function doWebPrcMsgSend()
	{

		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
	    
		
		if (confirm("WEB실행전문 전송하시겠습니까?")) {
	            var cols_ids = "<%=grid_col_id%>";
	            myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_app?cols_ids="+cols_ids+"&mode=webSendBs001");
	            sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);        
	    }

	}
	
    //WEB실행 완료상태인 20으로 업데이트
	function doUpdatWebPrcStatus()
	{
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		for(var i = 0; i < grid_array.length; i++)
		{
		}
        var cols_ids = "<%=grid_col_id%>";
        myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/admin.acc.bs_mgt?cols_ids="+cols_ids+"&mode=UpdatWebPrcStatus");
        sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);

	
	}
	
	
	
//실행취소 BS취소  WEB 취소전문 전송
function doBSCanStart()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	if (grid_array.length > 1 )
	{
		alert("한건씩 처리하시기 바랍니다.");
		return;
	}
	else if (grid_array.length == 0 )
	{
		alert("처리할 대상이 없습니다.");
		return;
	}
	for(var i = 0; i < grid_array.length; i++)
	{
		<%-- 화면ID는 필수 입력으로 처리한다.--%>
		
		if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EPS_STCD")).getValue()) == "10")
		{
			//BS 취소전문 전송
			doBsCanMsgSend();
		}
		else if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EPS_STCD")).getValue()) == "20")
		{
			//BS 취소전문 전송
			doBsCanMsgSend();
		}
		
		else if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EPS_STCD")).getValue()) == "30")
		{   
		    //Web 취소 전문 전송
			doWebCanMsgSend();
		}
		else
	    {
			alert("BS실행취소대상이 아닙니다.");			
	    }
	}	

}
	


//BS 취소전문 전송
function doBsCanMsgSend()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
    if (confirm("BS 취소 전문 전송하시겠습니까?")) {
            var cols_ids = "<%=grid_col_id%>";
            myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/admin.acc.bs_mgt?cols_ids="+cols_ids+"&mode=MakeBsCanMsg");
            sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);        
    }

}




//BS취소후 WEB취소 전문수행한다.
function doWebCanMsgSend()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
    if (confirm("WEB실행전문 전송하시겠습니까?")) {
            var cols_ids = "<%=grid_col_id%>";
            myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_app?cols_ids="+cols_ids+"&mode=webSendBs001");
            sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);        
        
    }
    

    
}

//Web 취소전송결과 UPDATE
function doUpdatWebCanStatus()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
	{
		<%-- 화면ID는 필수 입력으로 처리한다.--
		if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("screen_id")).getValue()) == "")
		{
			alert("<%=text.get("BS_001.0001")%>");
			return;
		}
		--%>
	}
var cols_ids = "<%=grid_col_id%>";
myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/admin.acc.bs_mgt?cols_ids="+cols_ids+"&mode=UpdatWebCanStatus");
sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	

}



	
	// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
        var err_cd   = obj.getAttribute("test");
		var prc_step = obj.getAttribute( "STEP");
		var main_msg_txt = obj.getAttribute( "MAIN_MSG_TXT");
        document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		//BS실행 성고
		if(prc_step == "BsPrcSndOK")
		{
			//전송내역 인서트 10으로 되어있는 상태
			//web실행전문 실행
		    //if(!checkRows()) return;
		    //var grid_array = getGridChangedRows(GridObj, "SELECTED");
            //GridObj.cells(grid_array, GridObj.getColIndexById("EPS_STCD")).setValue("10");
			alert("BS실행 성공 거래내역을 확인하세요!!");			
            doQuery();			
		}
		
		else if(prc_step == "BsPrcSndErr")
		{
			alert("BS실행 실패 거래내역을 확인하고 다시 거래하세요!!");
			doQuery();
		}
		else if (prc_step == "WebPrcSendOK")
		{
			alert("Web실행 성공하였습니다 거래내역을 확인하세요");
			//상태코드 20 웹실행으로 update
			doUpdatWebPrcStatus();
			//처리상태 조회
		}
		else if( prc_step == "WebPrcSendErr")
		{
			alert("Web실행 실패하였습니다. 거래내역을 확인하고 다시 거래하세요!!");			
			//상태코드가 BS전송 10인상태
			//처리상태 조회
			doQuery();
		}
		//BS실행취소 성고
		else if ( prc_step == "BsCanSndOK")
		{
			alert("BS실행쉬소 성공. 거래내역을 확인하세요!!");			
		    if(!checkRows()) return;
		    var grid_array = getGridChangedRows(GridObj, "SELECTED");
            GridObj.cells(grid_array, GridObj.getColIndexById("EPS_STCD")).setValue("30");
			doQuery();			
		}
		//BS실행 취소 실폐
		else if (prc_step == "BsCanSndErr")
		{
			alert("BS실행취소 실패 거래내역을 확인하고 다시거래하세요!!");			
			//조회하고 끝남
			doQuery();			
		}
		//web실행 취소 성공
		else if( prc_step == "WebCanSndOK")
		{
			alert("Web실행취소 성공 거래내역을 확인히세요");			
			//상태코드를 web취소 성공 40으로 업데이트
			doUpdatWebCanStatus();
		}
		else if( prc_step == "WebCanSndErr")
	    {
			alert("Web실행취소 실패. 거래내역을 확인후 다시 거래하세요");
			//상태코드는 BS실행 취소 상태 조회후 종료
			doQuery();			
	    }
		else if ( prc_step == "WebPrcEnd" )
		{
			doQuery();			
		}
		else if ( prc_step == "WebCanEnd" )
		{
			doQuery();
		}
		else
		{
			alert("오류 [" + main_msg_txt + "]" );			

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
	function doDelete()
	{
		if(!checkRows())
				return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

	   	if (confirm("<%=text.get("MESSAGE.1015")%>")){
	   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
			var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/admin.acc.bs_mgt?cols_ids="+cols_ids+"&mode=delete");
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	   }
	}

	// 행추가 이벤트 입니다.
	function doAddRow()
    {

		dhtmlx_last_row_id++;
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";
    	
		GridObj.enableSmartRendering(true);
		GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("EXE_DT"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TDY_PVDT_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("BIZ_DIS"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRN_CODE"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("PRC_DT")).setValue("<%=SepoaString.getDateSlashFormat(to_day) %>");
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("EPS_STCD")).setValue("00");
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("OPR_NO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ORG_GLBL_ID"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("SLIP_NMGT_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRN_STCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("BKCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRN_EVNT_CD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("MAIN_ACC_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("MAIN_ACCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("UNI_CD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("FND_PDCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("CNSC_SQ_NO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRN_RCKN_DT"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("CSNO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("BKW_ACNO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("PDCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("BDSYS_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ATM_THRW_FD_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRF_AM_VRF_YN"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("NXDT_XCH_OBC_YN"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("PLRL_APPV_YN"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("CAN_TGT_TRN_LOG_SRNO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ACCT_DT"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("DL_BRCD")).setValue("020644");
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("DL_BRNM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("MNG_BRCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("MNG_BRNM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("PSTN_CCT_BRCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("IOFF_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ACC_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ACCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ACCD_NM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("JRNL_AM_TYCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ACI_DTL_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("ADJ_JRNL_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("RAP_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("SLIP_SCNT"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("CUCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRF_KRW_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("CUR_KRW_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("BCHK_KRW_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("OBC_KRW_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRF_FC_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRF_FC_XC_KRW_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("PSTN_FC_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("PSTN_FC_XC_KRW_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRN_WTHO_SB_RT"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("IOFF_SB_DSCD"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("SLIP_TRN_DT"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("SLIP_NO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("SLIP_RGS_SRNO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("TRN_LOG_SRNO"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("FX_TRN_LOSS_AM"));
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("FX_TRN_PFT_AM"));		
        GridObj.cells(nMaxRow2, GridObj.getColIndexById("CC_SRNO")).setValue("XXXXX");		
        
		dhtmlx_before_row_id = nMaxRow2;
    }
    
    // 행삭제시 호출 되는 함수 입니다.
    function doDeleteRow()
    {
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
    }
	function onRowDblClicked(){
		alert("dbclicked");
	}
	
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();">
<s:header>
<form name="form">
<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

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
		      <tr>
        		<td width="10" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실행일자</td>
        		<td width="20%" height="24" class="data_td">
                    <s:calendar id="exe_dt" default_value="<%=SepoaString.getDateSlashFormat(to_day) %>" format="%Y/%m/%d"/>
        		</td>



        		
        		<td width="10%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계정과목</td>
        		<td width="20%" height="24" class="data_td">
					<select name="accd" id="accd" class="inputsubmit">                          
						<option value="">전체</option>                  
						<option value="18364100000">기타유형자산</option>                  
						<option value="18351100000">차량운반구</option>                  
						<option value="18311100000">업무용토지</option>                  
						<option value="18321100000">업무용건물</option>                  
						<option value="18341100000">임차점포시설물</option>                  
						<option value="29097100000">복구충당부채</option>                  
					</select>                                         
				</td>
			  
        		<td width="10%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실행취소/구분</td>
        		<td width="30%" height="24" class="data_td">
					<select name="trn_stcd" id="trn_stcd" class="inputsubmit">
						<option value="">전체</option>                  
						<option value="00">BS실행전</option>
						<option value="10">BS실행</option>                  
						<option value="20">실행완료</option>                  
						<option value="30">BS취소</option>                  
						<option value="40">취소완료</option>                  
					</select>
				</td>
			  </tr>
			  <tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			  </tr>			  
		      
		      <tr>
		        <td width="10%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회계일자</td>
				<td width="20%" height="24" class="data_td">
                    <s:calendar id="acct_dt"  format="%Y/%m/%d"/>
				</td>

        		<td width="10%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;일계부점</td>
        		<td width="20%" height="24" class="data_td">
					<input type="text" name="dl_brcd" value="" length="15" >
				</td>

        		<td width="10%" height="24" class="title_td">&nbsp;&nbsp;&nbsp;</td>
        		<td width="30%" height="24" class="data_td">
				</td>


			  </tr>
			  </table>
			  
<%--               
             <%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		  </tr>
		</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doQuery()","조회")</script></td>
						  <td><script language="javascript">btn("javascript:doBsPrcStart()","실행")</script></td>
						  <td><script language="javascript">btn("javascript:doBSCanStart()","실행취소")</script></td>
						  <td><script language="javascript">btn("javascript:doAddRow()","행삽입")</script></td>
						  <td><script language="javascript">btn("javascript:doDeleteRow()","행삭제")</script></td>


					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>		
	</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=260"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>
