<%@page import="org.apache.commons.collections.MapUtils"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date = to_day;
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_031");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);

	String screen_id = "CT_031";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = true;
	hashMap.put("session_user_id",info.getSession("ID"));
	Object[] obj = { hashMap };
	SepoaOut value = ServiceConnector.doService(info, "CT_031", "CONNECTION" , "getStockHeaderList" , obj);
	SepoaFormater stockSf = new SepoaFormater(value.result[0]);

	HashMap<String, String> headerHm = new HashMap<String, String>();
    for (int i = 0 ; i < stockSf.getColumnCount () ; i++ ){ //조회해온 내용을 포문을 돌려 headerHm(해쉬맵)에 저장한다
        headerHm.put ( stockSf.getColumnNames ()[i] , stockSf.getValue ( stockSf.getColumnNames ()[i] , 0 ).trim (  ) );
    }

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.stock_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	
    }

    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");

		if(status == "false") alert(msg);
		return true;
    }

    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
    	var header_name = GridObj.getColumnId(cellInd);
    	
    	if( header_name == "CONT_NUMBER")
		{
			var	cont_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NUMBER")).getValue());	
			var	cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
			
			if(cont_no != '') {
				
				var strParm = "cont_no=" + cont_no + "&cont_gl_seq=" + cont_gl_seq + "&cont_form_no=" + cont_no;
			 	popUpOpen("contract_detail_print.jsp?"+strParm, 'CONT_NO_DETAIL', '1080', '700');
			}
		} else if( header_name == "SELLER_COMPANY_NAME" ) {
			
			var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "SELLER_CODE");
			
			if(vendor_code != null && vendor_code != "") {
			
				var url    = '/s_kr/admin/info/ven_bd_con.jsp';
				var title  = '업체상세조회';
				var param  = 'popup=Y';
				param     += '&mode=irs_no';
				param     += '&vendor_code=' + vendor_code;
				popUpOpen01(url, title, '900', '700', param);
				
			}
			
		}
		   	
    }
    
    function doQuery(){
		var param  = dataOutput();
		var grid_col_id = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=query&grid_col_id="+grid_col_id;
		GridObj.post(SERVLETURL, param);
		GridObj.clearAll(false);
	}
	

	function initAjax(){
	}
	function getVendorCode(setMethod) { popupvendor(setMethod); }
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = desc1;
	}

	function popupvendor( fun )
	{
	    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}	
	
	//지우기
	function doRemove( type ){
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }  
	}

	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        doQuery();
	    }
	}

</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();doQuery();">
<s:header>
<form id="form" name="form"> 

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
	       							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
	       								계약일
	       							</td>
	       							<td width="30%"  class="data_td">
	       								<s:calendar id_from="from_date" id_to="to_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d" />
        							</td>
        							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								계약번호
        							</td>
        							<td width="30%"  class="data_td">
        								<input type="text" id="cont_no" name="cont_no"  size="20"onkeydown='entKeyDown()' style="ime-mode:inactive" >
        							</td>
			  					</tr>
				  				<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>			  					
			  					<tr>
        							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								업체명
        							</td>
							      	<td class="data_td" width="35%" colspan="3">
							      		<input type="text" name="seller_code" id="seller_code" size="12" class="inputsubmit" maxlength="10" readonly="readonly" onkeydown='entKeyDown()'>
							        	<a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
							        	<a href="javascript:doRemove('seller_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							        	<input type="text" name="seller_name" id="seller_name" size="20" readonly="readonly" onkeydown='entKeyDown()'>
							      	</td>        							
        		     		
			  					</tr>
			  					<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
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
			<td style="padding:5 5 5 0" align="right">
				<TABLE cellpadding="2" cellspacing="0">
					<TR>
						<td><script language="javascript">btn("javascript:doQuery()","조회")</script></td>
					</TR>
				</TABLE>
			</td>
		</TR>
	</TABLE>

	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
		      					<tr>	
	       							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
	       								성명
	       							</td>
	       							<td width="30%"  class="data_td">
	       								<%=MapUtils.getString(headerHm, "CEO_NAME_LOC", "정보가 존재하지 않습니다.") %>
        							</td>
        							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								사업자(주민)등록번호
        							</td>
        							<td width="30%"  class="data_td">
	       								<%=MapUtils.getString(headerHm, "IRS_NO", "정보가 존재하지 않습니다.") %>
        							</td>
			  					</tr>
				  				<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
			  					
			  					<tr>	
	       							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
	       								상호(대표자)
	       							</td>
	       							<td width="30%"  class="data_td" colspan="3">
	       								<%=MapUtils.getString(headerHm, "COMPANY_NAME_LOC", "정보가 존재하지 않습니다.") %>
        							</td>
        						</tr>
				  				<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
			  					<tr>	
	       							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
	       								사업장(본점) 또는 주소지
	       							</td>
	       							<td width="30%"  class="data_td" colspan="3">
	       								<%=MapUtils.getString(headerHm, "ADDRESS_LOC", "정보가 존재하지 않습니다.") %>
        							</td>
        						</tr>
				  				<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
			  					<tr>	
	       							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
	       								업태 / 종목
	       							</td>
	       							<td width="30%"  class="data_td">
	       								<%=MapUtils.getString(headerHm, "IB_TYPE", "정보가 존재하지 않습니다.") %>
        							</td>
        							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								전화번호
        							</td>
        							<td width="30%"  class="data_td">
	       								<%=MapUtils.getString(headerHm, "PHONE_NO1", "정보가 존재하지 않습니다.") %>
        							</td>
			  					</tr>
			  					<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
			
</form>
</s:header>
<s:grid screen_id="CT_031" grid_box="gridbox" grid_obj="GridObj"/>
<s:footer/>
</body>
