<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_003_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_003_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--
 Title:        역경매 낙찰화면  <p>
 Description:  역경매의 낙찰 및 유찰처리.. <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment
!-->

<!-- FUNCTION LIST

-------------------------------------------------------------------------------------------------------
FUNCTION NAME      DESCRIPTION
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------

-->
<% String WISEHUB_PROCESS_ID="AU_003_1";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page import = "java.math.*"%>

<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");

    String ann_no        = "";
    String subject       = "";
    String ra_type1      = "";  //역경매타입1 (O:공개,C:지명)
    String ra_type1_text = "";
    String reserve_price = "";  //추정금액
    String ra_bid_price  = "";  //낙찰금액
    String bid_rate      = "";  //낙찰율
    String bid_diff      = "";  //차액
    String bid_dec_rate  = "";  //절감율
    String bid_desc      = "";

    String sb_vendor_code   = "";

    String rownum        = "";
    String vendor_code   = "";
    String bid_price     = "";
    String name_loc      = "";
    String ceo_name_loc  = "";
    String vngl_address  = "";
    String SETTLE_FLAG   = "";
	String BID_SEQ       = "";

    String create_flag  = JSPUtil.nullToRef(request.getParameter("CREATE_FLAG"),"C");  // C:생성, R:조회, P:출력

    String ra_no        = JSPUtil.nullToEmpty(request.getParameter("RA_NO"));
    String ra_count     = JSPUtil.nullToEmpty(request.getParameter("RA_COUNT"));
    String pr_no        = JSPUtil.nullToEmpty(request.getParameter("REQ_PR_NO"));

    String[] pData = {house_code, ra_no, ra_count};
  	Object[] args  = {pData};

    SepoaOut rtn   = null;
    SepoaRemote wr = null;

    String nickName   = "p1008";
    String conType    = "CONNECTION";
    String MethodName = "getratbdins4_1";
    //String MethodName = "getratbdins4_1";

    SepoaFormater wf   = null;
    try {
    	wr = new SepoaRemote(nickName,conType,info);

    	rtn = wr.lookup(MethodName,args);

    	wf = new SepoaFormater(rtn.result[0]);

    	if ((wf != null) && (wf.getRowCount() > 0)) {
            ann_no           = wf.getValue("ANN_NO"        , 0);
            subject          = wf.getValue("SUBJECT"       , 0);
            ra_type1         = wf.getValue("RA_TYPE1"      , 0);
            ra_type1_text    = wf.getValue("RA_TYPE1_TEXT" , 0);
            reserve_price    = wf.getValue("RESERVE_PRICE" , 0);
    	}

    	wf = new SepoaFormater(rtn.result[1]);
    	if ((wf != null) && (wf.getRowCount() > 0)) {               // 낙찰업체
            sb_vendor_code  = wf.getValue("VENDOR_CODE"    , 0);
            ra_bid_price    = wf.getValue("BID_PRICE"      , 0);
            name_loc        = wf.getValue("VENDOR_NAME_LOC"       , 0);
            ceo_name_loc    = wf.getValue("CEO_NAME_LOC"   , 0);
            vngl_address    = wf.getValue("VNGL_ADDRESS"   , 0);
            SETTLE_FLAG     = wf.getValue("SETTLE_FLAG"    , 0);
            BID_SEQ         = wf.getValue("BID_SEQ"    , 0);
    	}
    }catch(Exception e) {
    	Logger.dev.println(user_id, this, "servlet Exception = " + e.getMessage());
    }finally{
    	try{
    		wr.Release();
    	}catch(Exception e){}
    }

    if (!"".equals(ra_bid_price)) {

        double cal_ra_bid_price  = Double.parseDouble(ra_bid_price);
        double cal_reserve_price = Double.parseDouble(reserve_price);
        double cal_rate          = Math.round((cal_ra_bid_price / cal_reserve_price * 100) * 100);
        double cal_dec_rate      = (100 * 100) - cal_rate;

		if (cal_reserve_price == 0) {
			cal_rate     = 0;
			cal_dec_rate = 0;
		}
		
        bid_rate      = String.valueOf(cal_rate/100);

        bid_diff      = String.valueOf(Math.round(cal_reserve_price - cal_ra_bid_price));
        bid_dec_rate  = String.valueOf(cal_dec_rate/100) + "%";

        bid_rate      = bid_rate + "%";
        reserve_price = SepoaString.formatNum(Long.parseLong(reserve_price));
        ra_bid_price  = SepoaString.formatNum(Long.parseLong(ra_bid_price));
        bid_diff      = SepoaString.formatNum(Long.parseLong(bid_diff));

        bid_desc      = bid_diff + "&nbsp;(" + bid_dec_rate + ")";
    }

    int len = reserve_price.length() - ra_bid_price.length();
    for(int i = 0; i < len; i++) {
        ra_bid_price = "&nbsp;" + ra_bid_price;
    }
%>



<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script language="javascript">
<!--
    var mode;
    var button_flag  = false;

    var INDEX_ROWNUM ;
    var INDEX_VENDOR_CODE;
    var INDEX_NAME_LOC;
    var INDEX_CEO_NAME_LOC;
    var INDEX_VNGL_ADDRESS;
    var INDEX_BID_PRICE;
    var USER_NAME_LOC;
    var USER_ID;
    var PHONE_NO;
    var INDEX_SETTLE_FLAG;

    function init() {
		setGridDraw();
		setHeader();
        doSelect();
    }

    function setHeader() {

    	GridObj.strHDClickAction="sortmulti";
		
        INDEX_ROWNUM		= GridObj.GetColHDIndex("ROWNUM");
        INDEX_VENDOR_CODE	= GridObj.GetColHDIndex("VENDOR_CODE");
        INDEX_NAME_LOC		= GridObj.GetColHDIndex("NAME_LOC");
        INDEX_CEO_NAME_LOC  = GridObj.GetColHDIndex("CEO_NAME_LOC");
        INDEX_VNGL_ADDRESS  = GridObj.GetColHDIndex("VNGL_ADDRESS");
        INDEX_BID_PRICE		= GridObj.GetColHDIndex("BID_PRICE");
        INDEX_USER_NAME_LOC = GridObj.GetColHDIndex("USER_NAME_LOC");
        INDEX_USER_ID 		= GridObj.GetColHDIndex("USER_ID");
        INDEX_PHONE_NO		= GridObj.GetColHDIndex("PHONE_NO");        
        INDEX_SETTLE_FLAG   = GridObj.GetColHDIndex("SETTLE_FLAG");
    }


    //조회버튼을 클릭
    function doSelect() {

        var mode   = "gstRatTableData";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_ins4";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
		} else if(msg1 == "doData") {
			location.href = "javascript:history.back()";
	    } else if(msg1 == "t_imagetext") {
	    }
    }
    
-->
</Script>
	
<script language="javascript">
<!--

    //저장----------------------------------------
    function doSave(flag) {
		$("#BID_STATUS").val(flag);
        
		if(button_flag == true) {
            alert("작업이 진행중입니다.");
            return;
        }

        var Message = "역경매를 유찰 하시겠습니까?";

        if (flag == "SB") {
            if (document.form1.VENDOR_CODE.value == "") {
                alert("낙찰업체가 없습니다. 유찰하세요.");
                return;
            }

            if(<%=wf.getRowCount()%> <= 1) {
                alert("입찰업체가 없거나, 1개업체만 참여했을 경우에는\n유찰만 가능합니다.");
                return;
            }

            Message = "역경매를 낙찰 하시겠습니까?";
        }
        if(confirm(Message) != 1) {
                return;
        }
        
        $("#NB_REASON").val($("#cancle_text").val());
        $("#SR_ATTACH_NO").val($("#sr_attach_no").val());
        
		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;	
		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("SELECTED")).setValue("1");
        
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_ins4";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setratbdins4_1";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);

   }//doSave() End
    //--------------------------------------------

    function setCancelText(){
    	var type = "R"
    	url =  "/kr/dt/rat/rat_pp_ins20.jsp?TYPE="+type;
	    window.open( url , "rat_pp_ins20","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=no,resizable=no,width=680,height=420,left=0,top=0");
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>

<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<form name="form1" >
	<input type="hidden" id="RA_NO"        	name="RA_NO"        value="<%=ra_no%>">
	<input type="hidden" id="RA_COUNT"     	name="RA_COUNT"     value="<%=ra_count%>">
	<input type="hidden" id="PR_NO" 		name="PR_NO" 		value="<%=pr_no%>">
	<input type="hidden" id="VENDOR_CODE"	name="VENDOR_CODE"	value="<%=sb_vendor_code%>">
	<input type="hidden" id="BID_SEQ"		name="BID_SEQ"		value="<%=BID_SEQ%>">
	<input type="hidden" id="NB_REASON"		name="NB_REASON"	value="">
	<input type="hidden" id="BID_STATUS"	name="BID_STATUS"	value="">
	<input type="hidden" id="cancle_text"  	name="cancle_text" 	value="">
	<input type="hidden" id="sr_attach_no" 	name="sr_attach_no" value="">
	<input type="hidden" id="SR_ATTACH_NO" 	name="SR_ATTACH_NO" value="">

  
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      		<td width="20%" height="24" class="data_td"><%=ann_no%></td>
    	</tr>
		<tr>
			<td colspan="2" height="1" bgcolor="#dedede"></td>
		</tr>  	    	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매건명</td>
      		<td width="20%" height="24" class="data_td"><%=subject.replaceAll("\"", "&quot")%></td>
    	</tr>
		<tr>
			<td colspan="2" height="1" bgcolor="#dedede"></td>
		</tr>  	    	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매방법</td>
      		<td width="20%" height="24" class="data_td"><%=ra_type1_text%></td>
    	</tr>
  	</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	  	
  	
  	<br>
<%
    if("P".equals(create_flag) && "N".equals(SETTLE_FLAG)) {
%>
  	<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <b>유찰</b></td>
    	</tr>
  	</table>
<%
    } else {
%>



<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 낙찰업체</td>
      		<td width="20%" height="24" class="data_td"><%=name_loc%></td>
    	</tr>
		<tr>
			<td colspan="2" height="1" bgcolor="#dedede"></td>
		</tr>     	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 대표자명</td>
      		<td width="20%" height="24" class="data_td"><%=ceo_name_loc%></td>
    	</tr>
		<tr>
			<td colspan="2" height="1" bgcolor="#dedede"></td>
		</tr>     	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 주소</td>
      		<td width="20%" height="24" class="data_td"><%=vngl_address%></td>
    	</tr>
  	</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	  	
<%
    }
%>
  	<br>
	<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
    	<tr>
      		<td width="10%" class="title_td" style="text-align: center">구분</td>
      		<td width="30%" class="title_td" style="text-align: center">금액(VAT 포함)</td>
      		<td width="30%" class="title_td" style="text-align: center">낙찰가율</td>
      		<td width="30%" class="title_td" style="text-align: center">차액(A-B) 및 절감율</td>
    	</tr>
	</table>
	<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
    	<tr>
      		<td width="10%" class="data_td" style="text-align: center">예상금액(A)</td>
      		<td width="30%" class="data_td" align="right" ><%= SepoaMath.SepoaNumberType(reserve_price, "###,###,###,###,###,###,###") %></td>
<%
    if("P".equals(create_flag) && "N".equals(SETTLE_FLAG)) {
%>
			<td width="30%" class="data_td"></td>
			<td width="30%" class="data_td"></td>
<%
    } else {
%>
			<td width="30%" class="data_td" align="right" ><%=SepoaMath.SepoaNumberType(bid_rate, "###,###,###,###,###,###,###")%></td>
      		<td width="30%" class="data_td" align="right" ><%=bid_desc%></td>
<%
    }
%>
		</tr>
    	<tr>
      		<td width="10%" class="data_td" style="text-align: center">낙찰금액(B)</td>
<%
    if("P".equals(create_flag) && "N".equals(SETTLE_FLAG)) {
%>
      		<td width="30%" class="data_td"></td>

<%
    } else {
%>
      		<td width="30%" class="data_td" align="right" ><%=SepoaMath.SepoaNumberType(ra_bid_price, "###,###,###,###,###,###,###")%></td>

<%
    }
%>
      		<td width="30%" class="data_td"></td>
      		<td width="30%" class="data_td"></td>
    	</tr>
  	</table>
	<br>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
				    	<TD><script language="javascript">btn("javascript:doSave('SB')","낙 찰")</script></TD>
				      	<TD><script language="javascript">btn("javascript:setCancelText()","유 찰")</script></TD>
				      	<td><script language="javascript">btn("javascript:history.back(-1)","취 소")</script></td>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
</form>
<!---- END OF USER SOURCE CODE ---->

</s:header>
<s:grid screen_id="AU_003_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


