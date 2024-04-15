<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private String getDateSlashFormat(String target) throws Exception{
	String       result       = null;
	StringBuffer stringBuffer = new StringBuffer();
	
	stringBuffer.append(target.subSequence(0, 4)).append("/").append(target.substring(4, 6)).append("/").append(target.substring(6, 8));
	
	result = stringBuffer.toString();
	
	return result;
}
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_027");
	multilang_id.addElement("I_BD_028");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_027";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
    String to_time = SepoaDate.getShortTimeString();
	
    
%>
<%--
 Title:        	t0002  <p>
 Description:  	품목  목록<p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	DEV.Team Echo<p>
 @version      	1.0.0<p>
 @Comment       실제 제조업체의 공장 단위를 의미.<p>
 				소요량 관리의 기준이 된다.<p>
 				하나의 PlantUnit은 하나의 Company에 종속되나,여러개의 Operating Unit에 연결되어 질 수 있으므로,<p>
 				Plant를 개별로 생성후 OperatingUnit에 연결해 주는 Assign부분이 별도로 존재한다.<p>
--%>

<% String WISEHUB_PROCESS_ID="I_BD_027";%>

<%
    String house_code      = info.getSession("HOUSE_CODE");
    String company_code    = info.getSession("COMPANY_CODE");
    String company_code_nm = info.getSession("COMPANY_NAME");
    String user_id         = info.getSession("ID");
    String name_loc        = info.getSession("NAME_LOC");
    String dept            = info.getSession("DEPARTMENT");
    String ctrl_code       = info.getSession("CTRL_CODE");


    //첨부파일 보기 PATH
	//Config conf = new Configuration();
	//String server_name = conf.get("wise.ip.info");
	//String attach_path = CommonUtil.getConfig("wisehub.attach.view.IMAGE");
	String attach_path = "";
	String gate         = JSPUtil.nullToRef(request.getParameter("gate"),""); // 외부에서 접근하였을 경우 flag
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
<script language="javascript">
var GridObj = null;
var GridObj2 = null;

function Init()
{
	GridObj_setGridDraw();
	GridObj2_setGridDraw();
	GridObj.setSizes();
	GridObj2.setSizes();
}

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_result_list2_ict";

function doSelect()
{
	var add_date_start      = LRTrim(form1.add_date_start.value);
	var add_date_end        = LRTrim(form1.add_date_end.value);
   
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getRfqBzList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.postGrid( G_SERVLETURL, params );
    GridObj.clearAll(false);	
}

function viewImage(item_no, description_loc, specification, image_file_path) {
	var left = 187; var top = 134;
	var resizable = "yes";
	var toolbar = "no"; var menubar = "no"; var status = "no"; var scrollbars = "yes";
    var attachImageUrl = "<%=attach_path%>";

	var url = "mat_pp_dis3.jsp?source=" + attachImageUrl + "&doc_no=" + image_file_path + "&item_no=" + item_no + "&description_loc=" + description_loc + "&specification=" + specification;

	if(url != "") {
		var width = 100;
		var height = 100;

		var view = window.open(url, 'view', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		view.focus();
	}
}

function add_date_start(year,month,day,week) {
  		document.form1.add_date_start.value=year+month+day;
}

function add_date_end(year,month,day,week) {
  		document.form1.add_date_end.value=year+month+day;
}

</script>



<script language="javascript" type="text/javascript">
var MenuObj = null;
var myDataProcessor = null;

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    
    var left = 30;
    var top = 30;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'no';
    var width = "";
    var height = "";
    
    var biz_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "BIZ_NO")));
    document.forms[0].BIZ_NO.value = biz_no;
	var params = "mode=getBdResultList";
	params += "&biz_no=" + biz_no;
	var cols_ids = "SELECTED,NO,STATUS_TEXT,ANN_NO,VOTE_COUNT,ANN_ITEM,BID_END_DATE,CONT_TYPE1_TEXT,VENDOR_CODE,VENDOR_NAME,VENDOR_COUNT,VENDOR_COUNT2,SUM_AMT,REASON,BID_NO,BID_COUNT,CHANGE_USER_ID,STATUS,PR_NO,PREFERRED_BIDDER,CAN_CANCEL_BIDDING,ANNOUNCE_FLAG,PRINT_NO,CTRL_CODE,ANN_VERSION,BID_TYPE,FINAL_ESTM_PRICE,BIZ_NO,BIZ_NM,BZBG_AMT,MATERIAL_CLASS1,MATERIAL_CLASS1_TEXT,MATERIAL_CLASS2,MATERIAL_CLASS2_TEXT";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj2.postGrid( G_SERVLETURL, params );
    GridObj2.clearAll(false); 	   	 	
    /* var header_name = GridObj.getColumnId(cellInd);
	if(header_name == "SELECTED") {
	} else {
		var biz_no 		= encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "BIZ_NO")));
		var params = "mode=getBdResultList";
		params += "&biz_no=" + biz_no;
		var cols_ids = "SELECTED,NO,STATUS_TEXT,ANN_NO,VOTE_COUNT,ANN_ITEM,BID_END_DATE,CONT_TYPE1_TEXT,VENDOR_CODE,VENDOR_NAME,VENDOR_COUNT,VENDOR_COUNT2,SUM_AMT,REASON,BID_NO,BID_COUNT,CHANGE_USER_ID,STATUS,PR_NO,PREFERRED_BIDDER,CAN_CANCEL_BIDDING,ANNOUNCE_FLAG,PRINT_NO,CTRL_CODE,ANN_VERSION,BID_TYPE,FINAL_ESTM_PRICE,BIZ_NO,BIZ_NM,BZBG_AMT,MATERIAL_CLASS1,MATERIAL_CLASS1_TEXT,MATERIAL_CLASS2,MATERIAL_CLASS2_TEXT";
	    params += "&cols_ids=" + cols_ids;
	    params += dataOutput();
	    GridObj2.postGrid( G_SERVLETURL, params );
	    GridObj2.clearAll(false); 	   	 	   
	} */
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
function doSaveEnd(obj) {
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");
	var data_type= obj.getAttribute("data_type");

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

	return false;
}

function reload_page()
{
	doSelect();
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

	if(status == "false") alert(msg);
	GridObj2.clearAll();
	document.forms[0].BIZ_NO.value = "";
	return true;
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;	
}

function  setBIZNO(biz_no, biz_nm) {
    document.forms[0].biz_no.value = biz_no;
    document.forms[0].biz_nm.value = biz_nm;
}

function getBIZ_pop() {
    var url = "/ict/kr/dt/rfq/rfq_bzNo_pop_main.jsp";
    Code_Search(url,'사업명','0','0','500','500');
    
    //url, title, left, top, width, height
}

function doRemove( type ){
    if( type == "biz_no" ) {
    	document.forms[0].biz_no.value = "";
        document.forms[0].biz_nm.value = "";
    }  
}

function getCtrlBiz(code, text) {
	document.forms[0].biz_no.value = code;
    document.forms[0].biz_nm.value = text;
}

function PopupManager(part){
	var wise = GridObj;
	var url  = "";
	
	if(part == "biz_no") {
		//window.open("/common/CO_017_ict.jsp?callback=getCtrlBiz", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		
		url    = '/common/CO_017_ict.jsp';
		var title  = '사업명조회';
		var param  = 'popup=Y';
		param     += '&callback=getCtrlBiz';
		popUpOpen01(url, title, '450', '550', param);	
		
	}
}



/////////////////////////////////////////////

function GridObj2_doOnRowSelected(rowId,cellInd) {
	var header_name = GridObj2.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	if(header_name == "ANN_NO")
    {
        var bid_no = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_COUNT")).getValue());      
		var ann_version = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("ANN_VERSION")).getValue());
		var bid_type = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_TYPE")).getValue());
		
		var url = "/ict/sourcing/bd_ann_d_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'800','900');
    }else if(header_name == "ANN_ITEM"){
    	
        var bid_no = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_COUNT")).getValue());     
        var vote_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("VOTE_COUNT")).getValue());     
        //url =  "bd_open_compare_pop_ict.jsp?BID_NO="+bid_no+"&BID_COUNT="+bid_count+"&VOTE_COUNT="+vote_count;
        //doOpenPopup(url,'1100','700');
        
        var url    = '/ict/sourcing/bd_open_compare_pop_ict.jsp';
		var title  = '개찰결과';
		var param  = 'popup=Y';
		param     += '&BID_NO=' + bid_no;
		param     += '&BID_COUNT=' + bid_count;
		param     += '&VOTE_COUNT=' + vote_count;
		popUpOpen01(url, title, '1100', '700', param);   
        
    } else if(header_name == "VENDOR_NAME") {
    	
		var vendor_code = SepoaGridGetCellValueId(GridObj2, rowId, "VENDOR_CODE");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/ict/s_kr/admin/info/ven_bd_con_ict.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
    }else if( GridObj2.getColIndexById("VENDOR_COUNT") == cellInd || GridObj2.getColIndexById("VENDOR_COUNT2") == cellInd || GridObj2.getColIndexById("VENDOR_COUNT3") == cellInd){
        var bid_no = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_COUNT")).getValue());          	
        var vote_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("VOTE_COUNT")).getValue());          	
        
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].VOTE_COUNT.value = vote_count; 
	
        var url = "bd_pp_dis_ict.jsp?BID_NO=" + bid_no + "&BID_COUNT=" + bid_count + "&VOTE_COUNT=" + vote_count ;
		doOpenPopup(url,'800','350');
	}

}


function GridObj2_doQueryEnd() {
	var msg        = GridObj2.getUserData("", "message");
	var status     = GridObj2.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}
// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
function GridObj2_doOnCellChange(stage,rowId,cellInd) {
	var max_value = GridObj2.cells(rowId, cellInd).getValue();
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	} else if(stage==1) {
	} else if(stage==2) {
	    return true;
	}
	
	return false;    
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint() {
	if(document.forms[0].BIZ_NO.value == ""){
		alert("사업명을 지정하세요.");
		return;
	}
	
	if(GridObj2.getRowsNum() == 0){
		alert("지정된 사업명에 입찰결과가 존재하지 않습니다.");
		return;
	}
	
    var url = "bd_result_list2_rpt_ict.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit(); 
}


</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<s:header>
<%
	if("".equals(gate)){
%>
	<%@ include file="/include/sepoa_milestone.jsp" %>
<%
	}
%>
	<form name="form1">
		<input type="hidden" name="item_no" id="item_no">
		
		<input type="hidden" name="BIZ_NO"		id="BIZ_NO">
		<input type="hidden" name="BID_NO"		id="BID_NO">
		<input type="hidden" name="BID_COUNT"	id="BID_COUNT">
		<input type="hidden" name="VOTE_COUNT"	id="VOTE_COUNT">
		<input type="hidden" name="SCR_FLAG"					value="">
		<input type="hidden" name="BID_TYPE_C"	id="BID_TYPE_C"	value="D">
	
		
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;등록일자</td>
										<td width="35%" class="data_td" >
											<s:calendar id="add_date_start" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="add_date_end" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>    						
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
    									<td width="35%" class="data_td">
        									<select name="biz_status" id="biz_status" class="inputsubmit">
                                            <option value="" selected="selected">전체</option>
<%
	String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M660_ICT", "");
	out.println(listbox1);
%>          										     										
        									</select>
    									</td>    									    									    									    								
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>		
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명 / 사업번호</td>
										<td width="35%" class="data_td" colspan="3">
											<input type="text" name="txt_biz_nm" id="biz_nm" size="20">
											<a href="javascript:PopupManager('biz_no');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('biz_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>	
											<input type="text" name="txt_biz_no" id="biz_no" size="20">											
										</td>										
									</tr>																	
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:doSelect()","조 회");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:clipPrint()","출 력");
</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
</s:header>
<s:grid screen_id="I_BD_027" height="350px"/>
<s:grid screen_id="I_BD_028" grid_obj="GridObj2" grid_box="gridbox2" grid_cnt="2" height="300px"/>

<s:footer/>
</body>
</html>