<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("EV_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String G_IMG_ICON = "/images/ico_zoom.gif";

	Config conf = new Configuration();
	String buyer_company_code = conf.getString("sepoa.buyer.company.code");
	
	
	String ev_gb    	= JSPUtil.nullToEmpty(request.getParameter("ev_gb")).trim();
	String inv_no     	= JSPUtil.nullToEmpty(request.getParameter("inv_no")).trim();
	String inv_seq    	= JSPUtil.nullToEmpty(request.getParameter("inv_seq")).trim();
	String cskd_gb    	= JSPUtil.nullToEmpty(request.getParameter("cskd_gb")).trim();
	String vendor_code	= JSPUtil.nullToEmpty(request.getParameter("vendor_code")).trim();
	
	
	String house_code	= info.getSession("HOUSE_CODE");
	
	
	String SUBJECT        = "";
	String INV_PERSON_ID  = "";
	String INV_PERSON_NM  = "";
	String VENDOR_CODE    = "";
	String VENDOR_NAME    = "";
	String PO_TTL_AMT     = "";
	String INV_AMT        = "";
	String EVAL_USER_ID   = "";
	String EVAL_USER_NM   = "";
	String CSKD_GB        = "";
	String CSKD_GB_NM     = "";
	

	Object[] obj1 = {inv_no};
	SepoaOut value1 = ServiceConnector.doService(info, "EV_001", "CONNECTION","getCsInfo", obj1);
	SepoaFormater wf1  = new SepoaFormater(value1.result[0]);
	
	//DB에서 받아올값들 초기화
    if(wf1.getRowCount() > 0) {
    	SUBJECT        = JSPUtil.nullToEmpty(wf1.getValue("SUBJECT",		0));
    	INV_PERSON_ID  = JSPUtil.nullToEmpty(wf1.getValue("INV_PERSON_ID",	0));
    	INV_PERSON_NM  = JSPUtil.nullToEmpty(wf1.getValue("INV_PERSON_NM",	0));
    	VENDOR_CODE    = JSPUtil.nullToEmpty(wf1.getValue("VENDOR_CODE",	0));
    	VENDOR_NAME    = JSPUtil.nullToEmpty(wf1.getValue("VENDOR_NAME",	0));
    	PO_TTL_AMT     = JSPUtil.nullToEmpty(wf1.getValue("PO_TTL_AMT",		0));
    	INV_AMT        = JSPUtil.nullToEmpty(wf1.getValue("INV_AMT",		0));
    	EVAL_USER_ID   = JSPUtil.nullToEmpty(wf1.getValue("EVAL_USER_ID",	0));
    	EVAL_USER_NM   = JSPUtil.nullToEmpty(wf1.getValue("EVAL_USER_NM",	0));
    	CSKD_GB        = JSPUtil.nullToEmpty(wf1.getValue("CSKD_GB",		0));
    	CSKD_GB_NM     = JSPUtil.nullToEmpty(wf1.getValue("CSKD_GB_NM",		0));
    }
	
	
	
    
    //Logger.sys.println("FAULT_INS_TERM1 = " + FAULT_INS_TERM);
    
	

	// Dthmlx Grid 전역변수들..
	String screen_id = "EV_004";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="/js/lib/sec.js"></script>
<script language="javascript" src="/js/lib/jslb_ajax.js"></script>

<script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

var INDEX_SEL      	;
var INDEX_ES_CD    	;
var INDEX_ES_VER   	;
var INDEX_ES_SEQ   	;
var INDEX_GRP_GB_NM	;
var INDEX_GRP_GB_DM	;
var INDEX_GRP_GB   	;
var INDEX_EV_TXT   	;
var INDEX_ES_DM    	;
var INDEX_ASC_GD   	;
var INDEX_ASC1     	;

	function init()
	{
		setGridDraw();
		setHeader();
	}
	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw(){
	    <%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	return true;
	}
	
	
	function setHeader()
	{
		GridObj.bHDMoving 	= false;
		GridObj.bHDSwapping 	= false;
		GridObj.nHDLineSize   = 40;
		
		INDEX_SEL      			= GridObj.GetColHDIndex("SEL"		);
		INDEX_ES_CD    			= GridObj.GetColHDIndex("ES_CD"		);
		INDEX_ES_VER   			= GridObj.GetColHDIndex("ES_VER"		);
		INDEX_ES_SEQ   			= GridObj.GetColHDIndex("ES_SEQ"		);
		INDEX_GRP_GB_NM			= GridObj.GetColHDIndex("GRP_GB_NM"		);
		INDEX_GRP_GB_DM			= GridObj.GetColHDIndex("GRP_GB_DM"		);
		INDEX_GRP_GB   			= GridObj.GetColHDIndex("GRP_GB"		);
		INDEX_EV_TXT   			= GridObj.GetColHDIndex("EV_TXT"		);
		INDEX_ES_DM    			= GridObj.GetColHDIndex("ES_DM"		);
		INDEX_ASC_GD   			= GridObj.GetColHDIndex("ASC_GD"		);
		INDEX_ASC1     			= GridObj.GetColHDIndex("ASC1"		);		
	}

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp(){
		return true;
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown(){
    	return true;
    }
    
    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt){
  		return true;
    }
    
    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	return true;
    }
    
    // 그리드 셀 ChangeEvent 시점에 호출 됩니다.
    // stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    function doOnCellChange(stage,rowId,cellInd)
    {
    	var max_value = GridObj.cells(rowId, cellInd).getValue();
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
    	
			return true;
			
		} else if(stage==2) {
	    	var header_name = GridObj.getColumnId(cellInd);
			return true;
		}
		return false;
    }
    
    // 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SEL");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("항목을 선택하세요.");
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
			topMenuClick("/kr/ev/cs_ev_list.jsp", "MUO141000004" , 4, '');
		} else {
			alert(messsage);
		}

		return false;
	}
	
	function onlyNumber(keycode){
		if(keycode >= 48 && keycode <= 57){
		}else {
			return false;
		}
		return true;
	}
	
	//INPUTBOX 입력시 콤마 제거
	function setOnFocus(obj) {
	    var target = eval("document.forms[0]." + obj.name);
	    target.value = del_comma(target.value);
	}
	
	//INPUTBOX 입력 후 콤마 추가
	function setOnBlur(obj) {
	    var target = eval("document.forms[0]." + obj.name);
	    if(IsNumber(target.value) == false) {
	        alert("숫자를 입력하세요.");
	        return;
	    }
	    target.value = add_comma(target.value,0);
	}
	
	//INPUTBOX 입력 후 커서아웃시 소수점1자리까지만 유효
	function checkDelayCharge(obj) {
		obj.value = add_comma(obj.value, 1);
	}
	
	//파일첨부시 callback
	function setAttach(attach_key, arrAttrach, rowId, attach_count) {


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
		document.forms[0].ATTACH_NO.value = attach_key;
		document.forms[0].FILE_NAME.value = result;		
	}
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="init();">
<s:header>
<form name="form">
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<table width="900px" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
						 		<td height="24" width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공사명</td>
						 		<td height="24" width="35%" class="data_td"><%=SUBJECT%></td>
						 		<td height="24" width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체명</td>
						 		<td height="24" width="35%" class="data_td"><%=VENDOR_NAME%></td>	  				
						 	</tr>
						 	<tr>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공사금액</td>
						 		<td height="24" class="data_td"><%=INV_AMT%></td>						 							 	
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공종</td>
						 		<td height="24" class="data_td"><%=CSKD_GB_NM%></td>	  				
						 	</tr>
						 	<tr>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가담당</td>
						 		<td height="24" class="data_td" colspan="3"><%=EVAL_USER_NM%></td>		
						 	</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
	  		
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td style="padding:5 5 5 0" align="left">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>
					<td><script language="javascript">btn("javascript:doSave()","공 사 평 가")</script></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;평점&nbsp;&nbsp;:&nbsp;&nbsp;최우수(A) , 우수(B) , 보통(C) , 미흡(D) , 불량(E)</td>
					<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;첨부파일</td>
					<td>
						<input type="text" name="FILE_NAME" id="FILE_NAME" class="inputsubmit" size="50" readonly">
					</td>
					<td>
						<input type="hidden" name="ATTACH_NO" id="ATTACH_NO"><!--  attach_key     -->
						<script language="javascript">btn("javascript:attach_file(document.forms[0].ATTACH_NO.value,'TEMP')","<%=text.get("BUTTON.add-file")%>")</script>
					</td>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>	
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>



<table cellSpacing="0" cellPadding="0" cellpadding="0" cellspacing="0" border="1" style="border-style:solid;border-width:thin;">        
<%

String ES_CD     = "";
String ES_VER    = "";
String ES_SEQ    = "";
String GRP_GB_NM = "";
String GRP_GB_DM = "";
String GRP_GB    = "";
String EV_TXT    = "";
String ES_DM     = "";

int rCnt         = 0;

try{     
		  	Object[] obj2 = {ev_gb, inv_no, cskd_gb, vendor_code};
			SepoaOut value2 = ServiceConnector.doService(info, "EV_001", "CONNECTION","getCsEvalSheet", obj2);
				if(value2.flag){
					SepoaFormater wf2          = null;					   
					wf2 = new SepoaFormater(value2.result[0]);
					rCnt = wf2.getRowCount();
				    int cCnt         = 0;
				    cCnt  = wf2.getColumnCount();				   
				    String[] cn = new String[cCnt];
				    cn = wf2.getColumnNames();				    
					for(int i = 0; i < rCnt; i++){
						  
						ES_CD            = JSPUtil.nullToEmpty(wf2.getValue("ES_CD",		i));
						ES_VER           = JSPUtil.nullToEmpty(wf2.getValue("ES_VER",		i));
						ES_SEQ           = JSPUtil.nullToEmpty(wf2.getValue("ES_SEQ",		i));
						GRP_GB_NM        = JSPUtil.nullToEmpty(wf2.getValue("GRP_GB_NM",	i));
						GRP_GB_DM        = JSPUtil.nullToEmpty(wf2.getValue("GRP_GB_DM",	i));
						GRP_GB           = JSPUtil.nullToEmpty(wf2.getValue("GRP_GB",		i));
						EV_TXT           = JSPUtil.nullToEmpty(wf2.getValue("EV_TXT",		i));
						ES_DM            = JSPUtil.nullToEmpty(wf2.getValue("ES_DM",		i));
												
						if(i == 0){
%>
							<tr height="33px">							
								<td align="center" width="50px"  style="display:none;"></td>
								<td align="center" width="50px"  style="display:none;"></td>
								<td align="center" width="50px"  style="display:none;"></td>
								<td align="center" width="100px" style="background-color:yellow;font-weight:700">구분</td>
								<td align="center" width="50px"  style="display:none;"></td>
								<td align="center" width="50px"  style="display:none;"></td>
								<td align="center" width="600px" style="background-color:yellow;font-weight:700">평가내용</td>
								<td align="center" width="50px" style="background-color:yellow;font-weight:700">배점</td>
								<td align="center" width="130px" style="background-color:yellow;font-weight:700" colspan="2">평정</td>																						
							</tr>
<%                       }                                                %>
							<tr height="33px">	
								<td align="center"  style="display:none;"><input type="text" id="<%=cn[0]+i%>" name="<%=cn[0]%>" value="<%=wf2.getValue(i,0)%>"  size=10  readOnly /></td>
								<td align="center"  style="display:none;"><input type="text" id="<%=cn[1]+i%>" name="<%=cn[1]%>" value="<%=wf2.getValue(i,1)%>"  size=10  readOnly /></td>
								<td align="center"  style="display:none;"><input type="text" id="<%=cn[2]+i%>" name="<%=cn[2]%>" value="<%=wf2.getValue(i,2)%>"  size=10  readOnly /></td>
								<td align="center" ><%=wf2.getValue(i,3)%></td>
								<td align="center"  style="display:none;"><input type="text" id="<%=cn[4]+i%>" name="<%=cn[4]%>" value="<%=wf2.getValue(i,4)%>"  size=10  readOnly /></td>
								<td align="center"  style="display:none;"><input type="text" id="<%=cn[5]+i%>" name="<%=cn[5]%>" value="<%=wf2.getValue(i,5)%>"  size=10  readOnly /></td>
								<td align="left"   ><%=wf2.getValue(i,6)%></td>
								<td align="center" ><%=wf2.getValue(i,7)%></td>
								<td align="center" width="65px">
									<%
										out.print("<select id='asc_gd"+i+"' name='asc_gd' onChange='javacsript:asc_gd_Changed(this);'>");
									    out.print("<option value=''>선택</option>");									
										String comstr = ListBox(info, "SL0157", info.getSession("HOUSE_CODE") + "#" + ES_CD + "#" + ES_VER + "#" + ES_SEQ , "");
										out.print(comstr);
										out.print("</select> ");
										
									%>
								</td>
								<td align="center"  width="65px"><input type="text" id="asc1<%=i%>" name="asc1" size=10 style="text-align: right;border:0" readOnly /></td>																																	
   							</tr>														
<%              }                               %>
						    <tr height="33px">	
						    	<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center" colspan="2" style="font-weight:700">합계</td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="font-weight:700">100</td>
								<td align="center" style="font-weight:700"></td>
								<td align="center" style="font-weight:700"><input type="text" id="asc_sum" name="asc_sum" size=10 style="text-align: right;border:0" readOnly /></td>				
						    </tr>
						    <tr height="33px">	
						    	<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center" >종합의견</td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center"  colspan="4">
									<textarea name="remark" id="remark" cols="97" rows="10" style="width:99%;height:100%;" onKeyUp="return chkMaxByte(4000, this, '종합의견');"></textarea>								
								</td>												
						    </tr>					
<% 			     }else{                          %>
					<script>
						alert("<%=value2.message%>");
					</script>
<%
		         }	

}catch(Exception e){
	//e.printStackTrace();
	%>
	<script>
		alert("오류가 발생되었습니다. 관리자에게 문의하세요.");		
	</script>	
	<% 	
}
%>	
</table>
<script language="javascript">
	function asc_gd_Changed(obj)
	{
		var asc1_id = eval(document.getElementById('asc1'+ obj.id.substring(6))); //id값 얻기
		asc1_id.value = obj.value;
		var asc1_kid;
		var asc1_kid_value;
		var asc_sum = 0;
		for(var k = 0; k < <%=rCnt%>; k++){
			asc1_kid = eval(document.getElementById('asc1'+ k)); //id값 얻기
			asc1_kid_value = (asc1_kid.value == "")?"0":asc1_kid.value;
			asc_sum += parseInt(asc1_kid_value);		
		}
		document.getElementById('asc_sum').value = asc_sum;
	}
	
	function doSave() {
		
		//var wise = GridObj;
		//var iMaxRow = 0 ;
		
		var rowCnt;
		var nMaxRow2;
		var row_data;
		var obj_asc_gd;
		
		for(var k = 0; k < <%=rCnt%>; k++){
			obj_asc_gd = eval(document.getElementById('asc_gd'+ k));	
			if(obj_asc_gd.value == ""){
				alert("평점을 선택하세요.");
				obj_asc_gd.focus();
				return;
			}
		}
		
		GridObj.clearAll();
		
		for(var i = 0; i < <%=rCnt%>; i++){
			
			//rowCnt = parseInt(GridObj.getRowsNum());
			rowCnt = i;
			dhtmlx_last_row_id = rowCnt + 1;
			nMaxRow = dhtmlx_last_row_id;
			row_data = "<%=grid_col_id%>";
			
			GridObj.enableSmartRendering(true);
			GridObj.addRow(nMaxRow, "", GridObj.getRowIndex(nMaxRow));
			GridObj.selectRowById(nMaxRow, false, true);
			GridObj.cells(nMaxRow, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
			
			GridObj.cells(nMaxRow, GridObj.getColIndexById("SEL")).setValue("1");
			
			GridObj.cells(nMaxRow, GridObj.getColIndexById("ES_CD")).setValue(eval(document.getElementById('ES_CD'+ i)).value);
			GridObj.cells(nMaxRow, GridObj.getColIndexById("ES_VER")).setValue(eval(document.getElementById('ES_VER'+ i)).value);
			GridObj.cells(nMaxRow, GridObj.getColIndexById("ES_SEQ")).setValue(eval(document.getElementById('ES_SEQ'+ i)).value);
			
			GridObj.cells(nMaxRow, GridObj.getColIndexById("GRP_GB_DM")).setValue(eval(document.getElementById('GRP_GB_DM'+ i)).value);
			GridObj.cells(nMaxRow, GridObj.getColIndexById("GRP_GB")).setValue(eval(document.getElementById('GRP_GB'+ i)).value);
			
			obj_asc_gd = eval(document.getElementById('asc_gd'+ i));		
			GridObj.cells(nMaxRow, GridObj.getColIndexById("ASC_GD")).setValue(obj_asc_gd.options[obj_asc_gd.selectedIndex].text);
			
			GridObj.cells(nMaxRow, GridObj.getColIndexById("ASC1")).setValue(eval(document.getElementById('asc1'+ i)).value);
			
			//asc1_kid = eval(document.getElementById('asc1'+ k)); //id값 얻기
			//asc1_kid_value = (asc1_kid.value == "")?"0":asc1_kid.value;
			
			//iMaxRow = wise.GetRowCount();
			//GridObj.AddRow();
			
			//GD_SetCellValueIndex(GridObj,i+1, INDEX_SEL          ,			"0" );
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ES_CD    	,eval(document.getElementById('ES_CD'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ES_VER   	,eval(document.getElementById('ES_VER'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ES_SEQ   	,eval(document.getElementById('ES_SEQ'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_GRP_GB_NM	,eval(document.getElementById('ES_CD'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_GRP_GB_DM	,eval(document.getElementById('ES_CD'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_GRP_GB   	,eval(document.getElementById('ES_CD'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_EV_TXT   	,eval(document.getElementById('ES_CD'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ES_DM    	,eval(document.getElementById('ES_CD'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ASC_GD   	,eval(document.getElementById('asc1'+ i)).value);
			//GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ASC1     	,eval(document.getElementById('asc1'+ i)).value);
		}
		
		if(confirm("공사평가 하시겠습니까?") != 1) {
			return;
		}
		
		getApprovalSend();
	}
	
	function fnFormInputSet(inputName, inputValue) {
		var input = document.createElement("input");
		
		input.type  = "hidden";
		input.name  = inputName;
		input.id    = inputName;
		input.value = inputValue;
		
		return input;
	}

	/**
	 * 동적 form을 생성하여 반환하는 메소드
	 *
	 * @param url
	 * @param param
	 * @param target
	 * @return form
	 */
	function fnGetDynamicForm(url, param, target){
		var form           = document.createElement("form");	
		var paramArray     = param.split("&");
		var i              = 0;
		var paramInfoArray = null;

		if((target == null) || (target == "")){
			target = "_self";
		}
		
		for(i = 0; i < paramArray.length; i++){
			paramInfoArray = paramArray[i].split("=");
			var input = fnFormInputSet(paramInfoArray[0], paramInfoArray[1]);

			form.appendChild(input);
		}
		
		form.action = url;
		form.target = target;
		form.method = "post";

		return form;
	}
	
	function getApprovalSend(){
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.cs_ev_wait_list";
		var grid_array = getGridChangedRows(GridObj, "SEL");
		var params     = getApprovalSendParam();
		
		myDataProcessor = new dataProcessor(servletUrl, params);
		sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
	}

	function getApprovalSendParam(){
		var inputParam = "";
		var body       = document.getElementsByTagName("body")[0];
		var cols_ids   = "<%=grid_col_id%>";
		var params;

		inputParam = inputParam + "H_EV_GB=<%=ev_gb%>";
		inputParam = inputParam + "&H_INV_NO=<%=inv_no%>";
		inputParam = inputParam + "&H_INV_SEQ=<%=inv_seq%>";
		inputParam = inputParam + "&H_CSKD_GD=<%=cskd_gb%>";
		inputParam = inputParam + "&H_VENDOR_CODE=<%=vendor_code%>";
		inputParam = inputParam + "&H_EVAL_USER_ID=<%=EVAL_USER_ID%>";
		
		var form = fnGetDynamicForm("", inputParam, null);
		
		body.appendChild(form);
		
		params = "mode=setEcSave";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		params += inputParam;
		
		body.removeChild(form);
		
		return params;
	}

</script>
<div id="gridbox" name="gridbox" width="100%"  height="500px" style="background-color:white;display:none;"></div>
</form>
</body>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
</s:header>
<s:footer/>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>