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
	
	
	String ec_no    	= JSPUtil.nullToEmpty(request.getParameter("ec_no")).trim();
	
	
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
	
	String ASC_SUM        = "";
    String REMARK         = "";
    
    String EVAL_DATE      = "";
    
    String ATTACH_NO      = "";
    
    Object[] obj1 = {ec_no};
	SepoaOut value1 = ServiceConnector.doService(info, "EV_001", "CONNECTION","getCsInfoRst", obj1);
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
    	ASC_SUM        = JSPUtil.nullToEmpty(wf1.getValue("ASC_SUM",		0));
    	REMARK         = JSPUtil.nullToEmpty(wf1.getValue("REMARK",		    0));    	
    	EVAL_DATE      = JSPUtil.nullToEmpty(wf1.getValue("EVAL_DATE",		0));
    	ATTACH_NO      = JSPUtil.nullToEmpty(wf1.getValue("ATTACH_NO",		0));    	
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
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="init();">
<s:header>
<form name="form">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="center" vAlign="bottom" style="font-weight:bold;font-size:22px;">
		공사 평가
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
						 		<td height="24" class="data_td"><%=EVAL_USER_NM%></td>	  				
						 		<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가일자</td>
						 		<td height="24" class="data_td"><%=SepoaString.getDateSlashFormat(EVAL_DATE) %></td>	  				
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
String EC_NO     = "";
String EC_SEQ    = "";



int rCnt         = 0;

try{     
		  	Object[] obj2 = {ec_no};
			SepoaOut value2 = ServiceConnector.doService(info, "EV_001", "CONNECTION","getCsEvalRst", obj2);
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
						EC_NO          = JSPUtil.nullToEmpty(wf2.getValue("EC_NO",		i));
						EC_SEQ         = JSPUtil.nullToEmpty(wf2.getValue("EC_SEQ",		i));
												
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
								<td align="center" style="font-weight:700"><%=ASC_SUM%></td>	
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
									<pre><div align="left"><%=REMARK%></div></pre>
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
								<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
								<td class="data_td" colspan="3" height="150" align="center">
									<table border="0" style="padding-top: 10px; width: 100%;">
										<tr>
											<td>
												<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
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