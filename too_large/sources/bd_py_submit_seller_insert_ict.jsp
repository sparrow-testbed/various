<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	HashMap text = MessageUtil.getMessageMap( info, "MESSAGE", "BUTTON", "I_SBD_004" );
	
	String screen_id = "I_SBD_004";
	String grid_obj  = "GridObj";
	
	Config conf = new Configuration();
	boolean isSelectScreen = false;
 
    String BID_NO        = request.getParameter("BID_NO");      
    String BID_COUNT     = request.getParameter("BID_COUNT");   
    String VOTE_COUNT    = request.getParameter("VOTE_COUNT");   
    String MODE          = request.getParameter("MODE");   

    if(BID_NO == null) BID_NO ="";
    if(BID_COUNT == null) BID_COUNT ="";
    if(VOTE_COUNT == null) VOTE_COUNT ="";

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간 

    String VENDOR_CODE        = COMPANY_CODE;
    String ANN_NO             = "";
    String ANN_ITEM           = "";
    String CHANGE_USER_NAME_LOC= "";
    
    String VENDOR_NAME		    = "";
    String IRS_NO   		    = "";

    String ATTACH_NO          = "";
    String ATTACH_CNT          = "";
        
	Map< String, String >   mapData = new HashMap< String, String >();
	mapData.put( "BID_NO", BID_NO );
	mapData.put( "BID_COUNT", BID_COUNT );
	mapData.put( "VOTE_COUNT", VOTE_COUNT );
	
	Object[]    obj = { mapData };
	SepoaOut    so  = ServiceConnector.doService( info, "I_SBD_013", "CONNECTION", "getBDHeader", obj );
	SepoaFormater wf = new SepoaFormater( so.result[0] );

        ANN_NO                       = wf.getValue("ANN_NO"                ,0);
        ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
        CHANGE_USER_NAME_LOC         = wf.getValue("CHANGE_USER_NAME_LOC"  ,0);
        
        so  = ServiceConnector.doService( info, "I_SBD_013", "CONNECTION", "getBDHD_VnInfo", obj );
    	SepoaFormater wf2 = new SepoaFormater( so.result[0] );

        VENDOR_NAME         = wf2.getValue("VENDOR_NAME"        ,0);
        IRS_NO              = wf2.getValue("IRS_NO"             ,0);
        
        ATTACH_NO           = wf2.getValue("ATTACH_NO",0);
        ATTACH_CNT          = wf2.getValue("ATTACH_CNT",0);         
%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="../../css/body.css" type="text/css">

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 
<Script language="javascript">
<!--

    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";
    var VOTE_COUNT  = "<%=VOTE_COUNT%>";

    var mode;
    var button_flag = false;

    var date_flag;
    var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
     
 
    function setOnFocus(obj) {
        var target = eval("document.forms[0]." + obj.name);
        target.value = del_comma(target.value);
    }

    function setOnBlur(obj) {
        var target = eval("document.forms[0]." + obj.name);

        if(IsNumber(del_comma(target.value)) == false) {
            alert("숫자를 입력하세요.");
            target.value = "";
            target.focus();
            return;
        }
        
        target.value = add_comma(target.value,0);
    }
 
//-->
</Script>
 
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%-- <%@ include file="/include/sepoa_grid_common.jsp"%> --%>
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_py_submit_list_seller_ict";

function init() {
	//setGridDraw(); 
    doQuery();
    
	var nickName    = "I_SBD_004";
	var conType     = "CONNECTION";//TRANSACTION
	var methodName  = "getVNCP";
	var SepoaOut    = doServiceAjax( nickName, conType, methodName );
	 
  	if( SepoaOut.status == "1" ) { // 성공
  		
        var tmp = (SepoaOut.result[0]).split("<%=CommonUtil.getConfig( "sepoa.separator.line" )%>");
        var tmp1 = tmp[1].split("<%=CommonUtil.getConfig( "sepoa.separator.field" )%>");
        
        var resultArr = tmp1.toString().split(",");
  	}
    
}

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
        GridObj.setColumnHidden(GridObj.getColIndexById("AMT"), true);
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
		var header_name = GridObj.getColumnId(cellInd);
		 
    	
        return true;
    }
    
    return false;
}

	
	/*금액 소수점 무조건 버림*/
	function setAmt(value) {
		rlt = 0;
		if(value == "" || value == 0) return 0;

		rlt = Math.floor(new Number(value) * 1) / 1;

		return rlt;
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
        //alert(messsage);
        //doQuery();
        location.href="bd_price_list_seller.jsp";
    } else {
        //alert(messsage);
        location.href="bd_price_list_seller.jsp";
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

function doQuery() {

<%--     var cols_ids = "<%=grid_col_id%>"; --%>
//     var params = "mode=getBdItemDetail";
//     params += "&cols_ids=" + cols_ids;
//     params += dataOutput();
//     GridObj.post( G_SERVLETURL, params );
//     GridObj.clearAll(false);
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

function doSubmit() {

// 	if(!checkRows()) return;

//     var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
// 	var rowcount = grid_array.length;
     
		if(button_flag == true) {
            alert("작업이 진행중입니다.");
            return;
        }

		if(parseFloat(LRTrim(document.forms[0].attach_cnt.value))<=0||LRTrim(document.forms[0].attach_cnt.value)=="")
		{
   			alert("제출해야할 대금지급서류가 첨부되지 않았습니다.");
   			return;
		}
        var f = document.forms[0];

        var Message = "제출 하시겠습니까?";
        if(confirm(Message) != 1){
            button_flag = false;
            return;
        }else{

            button_flag = true;

        }
    	
    	$.post(
    		G_SERVLETURL,
    		{
    			bid_no      	: document.getElementById("bid_no").value,
    			bid_count      	: document.getElementById("bid_count").value,
    			VOTE_COUNT      : document.getElementById("VOTE_COUNT").value,
    			attach_no      	: document.getElementById("attach_no").value,
    			
    	    	mode            : "setBdPySubmit"
    		},
    		function(arg){
    			var result = arg.split("|");
    			
    			if(result[1] == "true"){
    				alert(result[0]);
	    			location.href="bd_py_submit_list_seller_ict.jsp";
    			}
    			
    			if(result[1] == "false"){
    				alert(result[0]);
    				location.href="bd_py_submit_list_seller_ict.jsp";
    			}
    		}
    	);        
        
    //SignData();
<%--     var cols_ids = "<%=grid_col_id%>"; --%>
//     var params = "mode=setBDAPinsert";
 
//     params += "&cols_ids=" + cols_ids;
//     params += dataOutput();
//     myDataProcessor = new dataProcessor( G_SERVLETURL, params );
//     sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
}

function doCancel() {

// 	if(!checkRows()) return;

//     var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
// 	var rowcount = grid_array.length;
     
		if(button_flag == true) {
            alert("작업이 진행중입니다.");
            return;
        }

		var f = document.forms[0];

        var Message = "제출취소 하시겠습니까?";
        if(confirm(Message) != 1){
            button_flag = false;
            return;
        }else{

            button_flag = true;

        }
    	
    	$.post(
    		G_SERVLETURL,
    		{
    			bid_no      	: document.getElementById("bid_no").value,
    			bid_count      	: document.getElementById("bid_count").value,
    			VOTE_COUNT      : document.getElementById("VOTE_COUNT").value,
    			attach_no      	: document.getElementById("attach_no").value,
    			
    	    	mode            : "setBdPySubmitCancel"
    		},
    		function(arg){
    			var result = arg.split("|");
    			
    			if(result[1] == "true"){
    				alert(result[0]);
	    			location.href="bd_py_submit_list_seller_ict.jsp";
    			}
    			
    			if(result[1] == "false"){
    				alert(result[0]);
    				location.href="bd_py_submit_list_seller_ict.jsp";
    			}
    		}
    	);        
        
    //SignData();
<%--     var cols_ids = "<%=grid_col_id%>"; --%>
//     var params = "mode=setBDAPinsert";
 
//     params += "&cols_ids=" + cols_ids;
//     params += dataOutput();
//     myDataProcessor = new dataProcessor( G_SERVLETURL, params );
//     sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
}

// 첨부파일
function setAttach(attach_key, arrAttrach, rowId, attach_count) {
    if(document.forms[0].isGridAttach.value == "true"){
        setAttach_Grid(attach_key, arrAttrach, attach_count);
        return;
    }
    var attachfilename  = arrAttrach + "";
    var result          ="";
    
    var attach_info     = attachfilename.split(",");

    for (var i =0;  i <  attach_count; i ++)
    {
        var doc_no          = attach_info[0+(i*7)];
        var doc_seq         = attach_info[1+(i*7)];
        var type            = attach_info[2+(i*7)];
        var des_file_name   = attach_info[3+(i*7)];
        var src_file_name   = attach_info[4+(i*7)];
        var file_size       = attach_info[5+(i*7)];
        var add_user_id     = attach_info[6+(i*7)];

        if (i == attach_count-1)
            result = result + src_file_name;
        else
            result = result + src_file_name + ",";
    }
    var attach_seq = document.form.attach_seq.value;
    if(attach_seq == 1){
        document.forms[0].attach_no.value       = attach_key;
        document.forms[0].attach_cnt.value      = attach_count;
        document.forms[0].only_attach.value     = "attach_no";
        setAttach1();
    }else if(attach_seq == 2){
        document.forms[0].attach_no2.value      = attach_key;
        document.forms[0].attach_cnt2.value     = attach_count;
        document.forms[0].only_attach.value     = "attach_no2";
        setAttach1();
    }
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
<%--             alert("<%=message.get("MESSAGE.1002")%>"); --%>
    }
}

function setAttach2(result){
    var text  = result.split("||");
    var text1 = "";

    for( var i = 0; i < text.length ; i++ ){
        
        text1  += text[i] + "<br/>";
    }
    document.getElementById("attach_no_text").innerHTML  = text1;
    document.getElementById("attach_no_text").style.height  = text.length*13;
}

function ankFg_onclick(flag){
	if(flag == 1){    			
		window.open("bd_join_seller_insert1_ict.jsp?flag=1",'bd_join_seller_insert_ict','width=850,height=660,left=40,top=20,resizable=yes')
	}else if(flag == 2){    			
		window.open("bd_join_seller_insert2_ict.jsp?flag=1",'bd_join_seller_insert_ict','width=850,height=660,left=40,top=20,resizable=yes')
	}else if(flag == 3){    			
		window.open("bd_join_seller_insert3_ict.jsp?flag=1",'bd_join_seller_insert_ict','width=850,height=660,left=40,top=20,resizable=yes')
	}    		
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 

<form id="form" name="form" >
<input type="hidden" name="SIGN_CERT" value="">
<input type="hidden" name="bid_no" 	  id="bid_no" 	         value="<%=BID_NO%>">                     
<input type="hidden" name="bid_count" 	  id="bid_count" 	 value="<%=BID_COUNT%>">                 
<input type="hidden" name="VOTE_COUNT" 	  id="VOTE_COUNT" 	 value="<%=VOTE_COUNT%>">   
<input type="hidden" name="att_show_flag">
<input type="hidden" name="attach_seq">	
<input type="hidden" name="isGridAttach">
<input type="hidden" name="only_attach" id="only_attach" value="">
<input type="hidden" name="VENDOR_CODE" id="VENDOR_CODE" value="<%=VENDOR_CODE%>">

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
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공문번호</td>
      <td width="35%" class="data_td">
        <%=ANN_NO%>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰(계약)명</td>
      <td width="35%" class="data_td">
        <%=ANN_ITEM%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자명</td>
      <td class="data_td" colspan="3">
      <%=CHANGE_USER_NAME_LOC%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대금지급서류 첨부<img src='/images/mail_point.gif'' border='0'></td>
      <td colspan="3" class="data_td">
                        <TABLE>
                        <TR>
                            <td><input type="hidden" name="attach_no" id="attach_no" readonly value="<%=ATTACH_NO%>"></td>
                            <td> 
                                <script language="javascript">btn("javascript:attach_file(document.forms[0].attach_no.value,'TEMP');document.forms[0].attach_seq.value=1","파일첨부" )</script>
                            
                            </td>
                            <td>
                                <input type="text" name="attach_cnt" id="attach_cnt" class="div_empty_num_no" size="2" readonly value="<%=ATTACH_CNT%>">
                                <input type="text" size="5" readOnly class="div_empty_no" value="<%=text.get("MESSAGE.file_count")%>" name="file_count">
                            </td>
                            <td width="170">
                                <div id="attach_no_text" style="display: none;"></div>
                           </td>
                        </TR>
                        </TABLE>
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
      <td width="98%" height="30">
        <div align="right">
        <table><tr>
         <% if("S".equals(MODE)){ %>
          <td><script language="javascript">btn("javascript:doSubmit()", "대금지급서류제출")</script></td>
         <% }else if("C".equals(MODE)){ %>          
          <td><script language="javascript">btn("javascript:doCancel()", "대금지급서류제출취소")</script></td>
          <% } %>         
		  </tr></table>  
        </div>
      </td>
    </tr>
  </table> 
<br>
</form>
<!---- END OF USER SOURCE CODE ----> 
</s:header>
 			<%-- START GRID BOX 그리기 --%>
<!--         <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div> -->
<!--               <div id="pagingArea"></div> -->
        <%-- END GRID BOX 그리기 --%>
<s:footer/>
</body>
</html>


