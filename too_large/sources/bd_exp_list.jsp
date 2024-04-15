<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%> 
<!--
Title:         e-bidding결과<p>
 Description:  e-bidding결과<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       csj<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->
  
<%
	String USER_NAME 	= info.getSession("NAME_LOC");
	String USER_ID		= info.getSession("ID");
    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateDay( to_day, -30 );
    String  to_date     = to_day;
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">


<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->


<script language="javascript">
<!--
    var mode;
    var server_time;
    var diff_time;

    var INDEX_SELECTED      ;
    var INDEX_ANN_NO        ;
    var INDEX_ANN_ITEM      ;
    var INDEX_ANN_DATE      ;
    var INDEX_ANNOUNCE_DATE	;
    var INDEX_ANNOUNCE_FLAG	;
    var INDEX_STATUS   		;
    var INDEX_BID_NO        ;
    var INDEX_BID_COUNT     ;
    var INDEX_BID_STATUS    ;
    var INDEX_CHANGE_USER_ID;
    var INDEX_CTRL_CODE     ;

    function setHeader() {


        GridObj.strHDClickAction="sortmulti"; 

        INDEX_SELECTED          =    GridObj.GetColHDIndex("SELECTED");
        INDEX_ANN_NO            =    GridObj.GetColHDIndex("ANN_NO");
        INDEX_ANN_ITEM          =    GridObj.GetColHDIndex("ANN_ITEM");
        INDEX_ANN_DATE          =    GridObj.GetColHDIndex("ANN_DATE");
        INDEX_APP_BEGIN_DATE    =    GridObj.GetColHDIndex("ANNOUNCE_DATE");
        INDEX_ANNOUNCE_FLAG     =    GridObj.GetColHDIndex("ANNOUNCE_FLAG");
       // INDEX_STATUS       		= 	 GridObj.GetColHDIndex("STATUS");
        INDEX_BID_NO            =    GridObj.GetColHDIndex("BID_NO");
        INDEX_BID_COUNT         =    GridObj.GetColHDIndex("BID_COUNT");
        INDEX_BID_STATUS        =    GridObj.GetColHDIndex("BID_STATUS");
        INDEX_CHANGE_USER_ID    =    GridObj.GetColHDIndex("CHANGE_USER_ID");
        INDEX_CTRL_CODE         =    GridObj.GetColHDIndex("CTRL_CODE");
    }
 
    function doSelect() {
 
		
        mode = "getAnnounceList";
        servletUrl = "/servlets/dt.bidd.ebd_bd_ins11";        //service : p1009

        GridObj.SetParam("mode"				, mode);
        GridObj.SetParam("FROM_DATE"			, from_date);
        GridObj.SetParam("TO_DATE"			, to_date);
        GridObj.SetParam("STATUS"			, STATUS);
        GridObj.SetParam("ANN_NO"			, ANN_NO);
        GridObj.SetParam("ANN_ITEM"			, ANN_ITEM);
        GridObj.SetParam("CHANGE_USER"	, CHANGE_USER);

        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
        GridObj.strHDClickAction="sortmulti";
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
        if(msg1 == "doQuery"){
       	    //server_time = GD_GetParam(GridObj,0);

       	    //clock("s");
        } else if(msg1 == "doData") {
            if (mode == "setCancelApp") {
                alert(GD_GetParam(GridObj,0));
                doSelect();
            }
        } else if (msg1 == "t_imagetext") {
            BID_NO      = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT   = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);
            //PR_NO       = WiseTable.getText(msg2, INDEX_PR_NO);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            }
        }
    }

    function start_announce_date(year,month,day,week) {
	    document.form1.start_announce_date.value = year+month+day;
    }

    function end_announce_date(year,month,day,week) {
	    document.form1.end_announce_date.value = year+month+day;
    }

     //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13) {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            doSelect();
        }
    }
     
    function SP0023_Popup() {
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
		CodeSearchCommon(url,'doc','0','0','570','530');
	}
	
	function SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
   		document.form1.CHANGE_USER.value = USER_ID;
   		document.form1.CHANGE_USER_NAME.value = USER_NAME_LOC;
	}
	
	// 직무권한 체크
	function checkUser() {
		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = true;

  		for(var row=0; row<GridObj.GetRowCount(); row++) {
  			if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
  				for( i=0; i<ctrl_code.length; i++ )
				{
  					if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)) {
  						flag = true;
  						break;
  					} else
  						flag = false;
  				}
  			}
  		}

		if (!flag)
			alert("작업을 수행할 권한이 없습니다.");

  		return flag;
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
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_exp_list";

	function init() {
		setGridDraw(); 
	}

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
		doQuery();
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

function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdExpList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
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
  
    if(status == "false") {
    	alert(msg); // 실패였다면 실패메세지를 뿌려준다.
    }else{ 
    	server_time     = GridObj.getUserData("", "bdtime"); 
    	 
	    clock("s");
	    
    }
    
    document.forms[0].START_ANNOUNCE_DATE.value = add_Slash( document.forms[0].START_ANNOUNCE_DATE.value );
    document.forms[0].END_ANNOUNCE_DATE.value   = add_Slash( document.forms[0].END_ANNOUNCE_DATE.value   );
    
    return true;
  
}

function clock(flag) {
	var day;
    var currentDate = new Date();
 
    if (flag == "s") { // Server Call
        var client_time = currentDate.getTime();
 
        diff_time   = client_time - server_time;
    }
 
    curDate = new Date(Date.parse(Date())- diff_time);
 
    yyyy    = curDate.getYear();
    mm      = curDate.getMonth()+1;
    dd      = curDate.getDate();
    hh      = curDate.getHours();
    mi      = curDate.getMinutes();
    ss      = curDate.getSeconds();

    if (mm < 10) mm = "0" + mm;
    if (dd < 10) dd = "0" + dd;
    if (hh < 10) hh = "0" + hh;
    if (mi < 10) mi = "0" + mi;
    if (ss < 10) ss = "0" + ss;

    switch(curDate.getDay()) {
        case 0: day = "일"; break;
        case 1: day = "월"; break;
        case 2: day = "화"; break;
        case 3: day = "수"; break;
        case 4: day = "목"; break;
        case 5: day = "금"; break;
        case 6: day = "토"; break;
    }

    document.form1.server_date.value = yyyy + "년" + mm + "월" + dd + "일(" + day + ") " + hh + "시" + mi + "분" + ss + "초";
    document.form1.h_server_date.value = "" + yyyy + mm + dd + hh + mi + ss;
    setTimeout('clock("c")', 1000);
}

// ★GRID CHECK BOX가 체크되었는지 체크해주는 공통 함수[필수]
function checkRows() {

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    if( grid_array.length > 0 ) {
        return true;
    }

    alert("<%=text.get("MESSAGE.MSG_1001")%>");<%-- 대상건을 선택하십시오.--%>
    return false;

}

function doInsAnnounce() {

    var frm = document.form1;
    var param = "?popup_flag=true&save_flag=update";
    if(!checkRows()) return;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>";

    if( grid_array.length > 1 ) {
        alert( "<%=text.get("PU_113.MSG_0003")%>" );
        return;
    }
    
    var rowcount = GridObj.GetRowCount();
    
    if(!checkUser()) return;
 
    for( var i = 0; i < grid_array.length; i++ ) { 

		   var BID_NO = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue());
		   var BID_COUNT = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue());
		   var BID_STATUS = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue()); 

            if(BID_STATUS == "CC") {
                alert("공고취소건 입니다.");
                return;
            }

           // url = "ebd_pp_ins16.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT
        
    }

    var url = "ebd_pp_ins16.jsp";
    
    //window.open(url,"ebd_pp_ins16","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=no,resizable=yes,width=600,height=500,left=0,top=0");

    frm.P_BID_NO.value = BID_NO;
    frm.P_BID_COUNT.value  = BID_COUNT; 
     
    popUpOpen( url + param, title, '600', '500' ); 
}

</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 
<form name="form1" >
<input type="hidden" name="P_BID_NO" id="P_BID_NO">
<input type="hidden" name="P_BID_COUNT" id="P_BID_COUNT">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
    <tr>
      <td width="15%" class="c_title_1">
        <div align="left">설명회 개최일자</div>
      </td>
      <td width="35%" class="c_data_1">
      <s:calendar id_from="START_ANNOUNCE_DATE"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="END_ANNOUNCE_DATE" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
        
      </td>
      <td class="c_title_1">등록여부</td>
      <td class="c_data_1">
        <select name="STATUS" id="STATUS" class="inputsubmit">
          <option value="">전체</option>
          <option value="Y">등록</option>
          <option value="N">미등록</option>
        </select>
      </td>
    </tr>
    <tr>
      <td class="c_title_1">
        <div align="left">공고번호</div>
      </td>
      <td class="c_data_1">
        <input type="text" name="ANN_NO" id="ANN_NO" size="20" maxlength="20" class="inputsubmit" onkeydown='entKeyDown()'>
      </td>
      <td class="c_title_1">입찰건명</td>
      <td class="c_data_1">
        <input type="text" style="ime-mode:active;width:95%"  name="ANN_ITEM" id="ANN_ITEM" maxlength="100" class="inputsubmit" onkeydown='entKeyDown()'>
      </td>
    <tr>
      <td class="c_title_1">
        <div align="left">현재시간</div>
      </td>
      <td class="c_data_1">
        <input type="text" name="server_date" class="input_data1" size="50" readonly>
        <input type="hidden" name="h_server_date" class="input_data1" size="50" readonly>
      </td>
      <td width="15%" class="c_title_1">입찰담당자</td>
      <td  width="35%" class="c_data_1"><b>
        <input type="text" name="CHANGE_USER" id="CHANGE_USER" size="20" maxlength="10" class="inputsubmit" value="<%=info.getSession("ID")%>"  onkeydown='entKeyDown()'>
		<a href="javascript:SP0023_Popup()">
			<img src="/images/button/query.gif" align="absmiddle" border="0" alt="">
		</a>
		<input type="text" name="CHANGE_USER_NAME" size="20" class="input_data2" readonly value='<%=info.getSession("NAME_LOC")%>'>
      </b></td>
    </tr>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="30">
        <div align="right">
			<table cellpadding="0">
			<tr>
				<td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
				<td><script language="javascript">btn("javascript:doInsAnnounce()", "결과등록")</script></td>
			</tr>
			</table>
		</div>
      </td>
    </tr>
  </table>
 

</form>

<!---- END OF USER SOURCE CODE ----> 

</s:header>
<s:grid screen_id="BD_003" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>


