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
	
	
	String et_no    	= JSPUtil.nullToEmpty(request.getParameter("et_no")).trim();
	String rowId        = JSPUtil.nullToEmpty(request.getParameter("rowId")).trim();
	String callback     = request.getParameter("callback");
	
	
	String house_code	= info.getSession("HOUSE_CODE");
	
	
	String H_ETPL_NO            = "";
    String H_ETPL_SEQ           = "";
    String H_ETPL_NM            = "";
    String H_EVAL_YY            = "";
    String H_ES_CD              = "";
    String H_ES_VER             = "";
    String H_ES_NM              = "";	    
    String H_CSKD_GB            = "";
    String H_CSKD_GB_NM         = "";
    String H_GROUP1_CODE        = "";
    String H_GROUP1_NAME_LOC    = "";
    String H_GROUP2_CODE        = "";
    String H_GROUP2_NAME_LOC    = "";
    String H_VENDOR_CODE        = "";
    String H_VENDOR_NAME_LOC    = "";
    String H_ASC_SUM            = "";
    String H_REMARK             = "";
    String H_EVAL_USER_ID       = "";
    String H_EVAL_USER_NAME_LOC = "";
    String H_EVAL_DATE          = "";
    String H_EVAL_TIME          = "";
    String H_PRG_STS            = "";
    String H_PRG_STS_TXT        = "";
    
    Object[] obj1 = {et_no};
	SepoaOut value1 = ServiceConnector.doService(info, "EV_002", "CONNECTION","getTeInfoRst", obj1);
	SepoaFormater wf1  = new SepoaFormater(value1.result[0]);
	
	//DB에서 받아올값들 초기화
    if(wf1.getRowCount() > 0) {
    	H_ETPL_NO                   = JSPUtil.nullToEmpty(wf1.getValue("ETPL_NO",		0));
    	H_ETPL_SEQ                  = JSPUtil.nullToEmpty(wf1.getValue("ETPL_SEQ",		0));
    	H_ETPL_NM                   = JSPUtil.nullToEmpty(wf1.getValue("ETPL_NM",		0));
    	H_EVAL_YY                   = JSPUtil.nullToEmpty(wf1.getValue("EVAL_YY",		0));
    	H_ES_CD                     = JSPUtil.nullToEmpty(wf1.getValue("ES_CD",		0));
    	H_ES_VER                    = JSPUtil.nullToEmpty(wf1.getValue("ES_VER",		0));
    	H_ES_NM                     = JSPUtil.nullToEmpty(wf1.getValue("ES_NM",		0));
    	H_CSKD_GB                   = JSPUtil.nullToEmpty(wf1.getValue("CSKD_GB",		0));
    	H_CSKD_GB_NM                = JSPUtil.nullToEmpty(wf1.getValue("CSKD_GB_NM",		0));
    	H_GROUP1_CODE               = JSPUtil.nullToEmpty(wf1.getValue("GROUP1_CODE",		0));
    	H_GROUP1_NAME_LOC           = JSPUtil.nullToEmpty(wf1.getValue("GROUP1_NAME_LOC",		0));
    	H_GROUP2_CODE               = JSPUtil.nullToEmpty(wf1.getValue("GROUP2_CODE",		0));
    	H_GROUP2_NAME_LOC           = JSPUtil.nullToEmpty(wf1.getValue("GROUP2_NAME_LOC",		0));
    	H_VENDOR_CODE               = JSPUtil.nullToEmpty(wf1.getValue("VENDOR_CODE",		0));
    	H_VENDOR_NAME_LOC           = JSPUtil.nullToEmpty(wf1.getValue("VENDOR_NAME_LOC",		0));
    	H_ASC_SUM                   = JSPUtil.nullToEmpty(wf1.getValue("ASC_SUM",		0));
    	H_REMARK                    = JSPUtil.nullToEmpty(wf1.getValue("REMARK",		0));
    	H_EVAL_USER_ID              = JSPUtil.nullToEmpty(wf1.getValue("EVAL_USER_ID",		0));
    	H_EVAL_USER_NAME_LOC        = JSPUtil.nullToEmpty(wf1.getValue("EVAL_USER_NAME_LOC",		0));
    	H_EVAL_DATE                 = JSPUtil.nullToEmpty(wf1.getValue("EVAL_DATE",		0));
    	H_EVAL_TIME                 = JSPUtil.nullToEmpty(wf1.getValue("EVAL_TIME",		0));  
    	H_PRG_STS                   = JSPUtil.nullToEmpty(wf1.getValue("PRG_STS",		0));  
    	H_PRG_STS_TXT               = JSPUtil.nullToEmpty(wf1.getValue("PRG_STS_TXT",		0));  
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
			opener.<%=callback%>(<%=rowId%>);
			
			<%-- opener.GridObj.cells(<%=rowId%>, opener.GridObj.getColIndexById("ET_NO_SEL")).setValue("<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");			
			opener.GridObj.cells(<%=rowId%>, opener.GridObj.getColIndexById("ET_NO")).setValue("");
			opener.GridObj.cells(<%=rowId%>, opener.GridObj.getColIndexById("ASC_SUM")).setValue("");
			opener.GridObj.cells(<%=rowId%>, opener.GridObj.getColIndexById("EVAL_DATE")).setValue("");
			opener.GridObj.cells(<%=rowId%>, opener.GridObj.getColIndexById("EVAL_USER_ID")).setValue("");
			opener.GridObj.cells(<%=rowId%>, opener.GridObj.getColIndexById("EVAL_USER_NAME_LOC")).setValue(""); --%>
			alert(messsage);
			window.close();
			//topMenuClick("/kr/ev/cs_ev_list.jsp", "MUO141000004" , 4, '');
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
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="init();">
<s:header>
<form name="form">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="center" vAlign="bottom" style="font-weight:bold;font-size:22px;">
		기술 평가 (결과)
	</td>
</tr>
</table>
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
						 		<td height="24" width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 기술평가번호</td>
						 		<td height="24" width="30%" class="data_td" colspan="3"><%=et_no%></td>						 		
						 	</tr>						 	
							
							<tr>						
						 		<td height="24" width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 기술평가계획번호(항번)</td>
						 		<td height="24" width="30%" class="data_td"><%=H_ETPL_NO%>(<%=H_ETPL_SEQ%>)</td>
						 		<td height="24" width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 기술평가계획명</td>
						 		<td height="24" width="30%" class="data_td"><%=H_ETPL_NM%></td>	  				
						 	</tr>						 	
							<tr>						
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가표코드(버전)</td>
						 		<td height="24" class="data_td"><%=H_ES_CD%>(<%=H_ES_VER%>)</td>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가표명</td>
						 		<td height="24" class="data_td"><%=H_ES_NM%></td>	  				
						 	</tr>
						 	<tr>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공종</td>
						 		<td height="24" class="data_td"><%=H_GROUP1_NAME_LOC%></td>						 							 	
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체등급</td>
						 		<td height="24" class="data_td"><%=H_GROUP2_NAME_LOC%></td>	  				
						 	</tr>
						 	<tr>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공사업체</td>
						 		<td height="24" class="data_td"><%=H_VENDOR_NAME_LOC%></td>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가년도</td>
						 		<td height="24" class="data_td"><%=H_EVAL_YY%></td>						 				
						 	</tr>
						 	<tr>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 기술평가자</td>
						 		<td height="24" class="data_td"><%=H_EVAL_USER_NAME_LOC%></td>
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가일자</td>
						 		<td height="24" class="data_td" colspan="3"><%=H_EVAL_DATE%></td>				
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
		<TABLE cellpadding="0">
      		<TR>
   	  			<TD><script language="javascript">btn("javascript:doDelete()","기술평가 삭제")</script></TD>
   	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<table cellSpacing="0" cellPadding="0" cellpadding="0" cellspacing="0" border="1"  width="900px" style="border-style:solid;border-width:thin;">        
<%

String ES_CD     = "";
String ES_VER    = "";
String ES_SEQ    = "";
String GRP_GB_NM = "";
String GRP_GB_DM = "";
String GRP_GB    = "";
String EV_TXT    = "";
String ES_DM     = "";
String ASC_GD    = "";
String ASC_GD_NM = "";
String ASC1	     = "";
String ET_NO     = "";
String ET_SEQ    = "";



int rCnt         = 0;

try{     
		  	Object[] obj2 = {et_no};
			SepoaOut value2 = ServiceConnector.doService(info, "EV_002", "CONNECTION","getTeEvalRst", obj2);
				if(value2.flag){
					SepoaFormater wf2          = null;					   
					wf2 = new SepoaFormater(value2.result[0]);
					rCnt = wf2.getRowCount();
				    int cCnt         = 0;
				    cCnt  = wf2.getColumnCount();				   
				    String[] cn = new String[cCnt];
				    cn = wf2.getColumnNames();				    
					for(int i = 0; i < rCnt; i++){
						  
						ES_CD          = JSPUtil.nullToEmpty(wf2.getValue("ES_CD",		i));
						ES_VER         = JSPUtil.nullToEmpty(wf2.getValue("ES_VER",		i));
						ES_SEQ         = JSPUtil.nullToEmpty(wf2.getValue("ES_SEQ",		i));
						GRP_GB_NM      = JSPUtil.nullToEmpty(wf2.getValue("GRP_GB_NM",	i));
						GRP_GB_DM      = JSPUtil.nullToEmpty(wf2.getValue("GRP_GB_DM",	i));
						GRP_GB         = JSPUtil.nullToEmpty(wf2.getValue("GRP_GB",		i));
						EV_TXT         = JSPUtil.nullToEmpty(wf2.getValue("EV_TXT",		i));
						ES_DM          = JSPUtil.nullToEmpty(wf2.getValue("ES_DM",		i));
						ASC_GD         = JSPUtil.nullToEmpty(wf2.getValue("ASC_GD",		i));
						ASC_GD_NM      = JSPUtil.nullToEmpty(wf2.getValue("ASC_GD_NM",	i));
						ASC1	       = JSPUtil.nullToEmpty(wf2.getValue("ASC1",	    i));
						ET_NO          = JSPUtil.nullToEmpty(wf2.getValue("ET_NO",		i));
						ET_SEQ         = JSPUtil.nullToEmpty(wf2.getValue("ET_SEQ",		i));
												
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
								<td align="center" width="50px"  style="display:none;"></td>
								<td align="center" width="50px"  style="display:none;"></td>																					
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
								<td align="center" width="65px"><%=wf2.getValue(i,9)%> (<%=wf2.getValue(i,8)%>)</td>
								<td align="center"  width="65px"><%=wf2.getValue(i,10)%></td>
								<td align="center"  style="display:none;"><input type="text" id="<%=cn[11]+i%>" name="<%=cn[11]%>" value="<%=wf2.getValue(i,11)%>"  size=10  readOnly /></td>
								<td align="center"  style="display:none;"><input type="text" id="<%=cn[12]+i%>" name="<%=cn[12]%>" value="<%=wf2.getValue(i,12)%>"  size=10  readOnly /></td>																																								
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
								<td align="center" style="font-weight:700"><%=H_ASC_SUM%></td>	
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>			
						    </tr>
						    <tr height="33px">	
						    	<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center" >종합의견</td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>
								<td align="center"  colspan="4">
									<pre><div align="left"><%=H_REMARK%></div></pre>
								</td>
								<td align="center" style="display:none;"></td>
								<td align="center" style="display:none;"></td>															
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
	function doDelete(){
		
		var rowCnt;
		var nMaxRow2;
		var row_data;
		var obj_asc_gd;
		
		GridObj.clearAll();
		
		for(var i = 0; i < <%=rCnt%>; i++){
			
			rowCnt = i;
			dhtmlx_last_row_id = rowCnt + 1;
			nMaxRow = dhtmlx_last_row_id;
			row_data = "<%=grid_col_id%>";
			
			GridObj.enableSmartRendering(true);
			GridObj.addRow(nMaxRow, "", GridObj.getRowIndex(nMaxRow));
			GridObj.selectRowById(nMaxRow, false, true);
			GridObj.cells(nMaxRow, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
			
			GridObj.cells(nMaxRow, GridObj.getColIndexById("SEL")).setValue("1");
			
		}
		
		if('<%=info.getSession("ID")%>' != '<%=H_EVAL_USER_ID%>' 
	 	 		&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP210200001" 
	 			&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP150400001" ){
			alert("삭제 권한이  없습니다.\r\n\r\n삭제권한자 ( 평가자 , 총무팀장 )");
			return;
		}
		
		if('<%=H_PRG_STS%>' ==  "E" ){
			alert("기술평가 마감 되어 삭제가 불가합니다.");
			return;
		}
		
		if(confirm("삭제 하시겠습니까?") != 1) {
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
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.te_ev_wait_list";
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
		
		inputParam = inputParam + "H_ET_NO=<%=et_no%>";
		inputParam = inputParam + "&H_ETPL_NO=<%=H_ETPL_NO%>";
		inputParam = inputParam + "&H_ETPL_SEQ=<%=H_ETPL_SEQ%>";
				
		var form = fnGetDynamicForm("", inputParam, null);
		body.appendChild(form);
		
		params = "mode=setEtDelete";
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