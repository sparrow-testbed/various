<%@page import="org.apache.commons.collections.MapUtils"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_103_02");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_103_02";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<% String WISEHUB_PROCESS_ID="SU_103_02";%>

<%
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String popup = JSPUtil.nullToEmpty(request.getParameter("popup"));
	String AR_NO      =  JSPUtil.nullToEmpty(request.getParameter("AR_NO"));
	
	
	String  to_day      	= SepoaDate.getShortDateString();
	String  from_date   	= SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateDay( to_day, -30 ) );
	String  to_date     	= SepoaString.getDateSlashFormat( to_day );
	 
	String VIEW_TYPE		= JSPUtil.nullToRef(request.getParameter("VIEW_TYPE"), "");	
	String view_content 	= JSPUtil.nullToEmpty(request.getParameter("view_content")); //View용 화면인지 확인 flag
	String SCR_FLAG 		= JSPUtil.nullToRef(request.getParameter("SCR_FLAG"), "I"); // 생성/수정/확정/상세조회 flag 
	String USER_ID 			= info.getSession("ID");
	
	String current_date 	= SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time 	= SepoaDate.getShortTimeString();//현재 시스템 시간
	
	
    Object[] args     = new Object[1];
    args[0] = AR_NO;
	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","req_ins_getVnglList3", args);
	SepoaFormater wf = new SepoaFormater(value.result[0]);  
	
	String ADD_USER_ID = "";
	String ADD_USER_NAME = "";	
	String VENDOR_CODE      = "";
	String VENDOR_NAME_LOC  = "";
	String P_BANK_CODE      = "";	
	String P_BANK_NAME      = "";
	String P_BANK_ACCT      = "";
	String P_DEPOSITOR_NAME = "";
	
	if(wf.getRowCount() > 0) {
		ADD_USER_ID          = wf.getValue("ADD_USER_ID"     		,   0);
		ADD_USER_NAME          = wf.getValue("ADD_USER_NAME"     		,   0);
		VENDOR_CODE          = wf.getValue("VENDOR_CODE"     		,   0);
		VENDOR_NAME_LOC  = wf.getValue("VENDOR_NAME_LOC"     		,   0);
		P_BANK_CODE                 = wf.getValue("P_BANK_CODE"     		,   0);
		P_BANK_NAME              = wf.getValue("P_BANK_NAME"     		,   0);
		P_BANK_ACCT           = wf.getValue("P_BANK_ACCT"     		,   0);
		P_DEPOSITOR_NAME  = wf.getValue("P_DEPOSITOR_NAME"     		,   0);
	}
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_vendor_ar_view"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(ADD_USER_NAME);
	_rptData.append(" (");
	_rptData.append(ADD_USER_ID);
	_rptData.append(")");
	_rptData.append(_RF);
	_rptData.append(VENDOR_CODE);
	_rptData.append(_RF);
	_rptData.append(VENDOR_NAME_LOC);
	_rptData.append(_RF);
	_rptData.append(P_BANK_NAME);
	_rptData.append(_RF);
	_rptData.append(P_DEPOSITOR_NAME);
	_rptData.append(_RF);
	_rptData.append(P_BANK_ACCT);
	//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
	 
%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" type="text/javascript">
function fnHtmlDown(){
	
	var print = "";
	var not_print_01 = $("#not_print_td_01").html();//출력물에는 보여주지 않을 요소 제거
	var not_print_02 = $("#not_print_td_02").html();//출력물에는 보여주지 않을 요소 제거
	var not_print_03 = $("#not_print_td_03").html();//출력물에는 보여주지 않을 요소 제거
	var not_print_04 = $("#not_print_td_04").html();//출력물에는 보여주지 않을 요소 제거
	
	$("#not_print_td_01").remove();
	$("#not_print_td_02").remove();
	$("#not_print_td_03").remove();
	$("#not_print_td_04").remove();
	
	print = $("#print_div").html();//출력물에 보여줄 요소 저장
// 	var tmp = $("#btn_td").html();
// 	$("#btn_td").html("");
 	
	Some.document.open("text/html","replace");
 	Some.document.write(print);
//  Some.document.write(document.documentElement.outerHTML) ;
 	
 	$("#not_print_td_01").html(not_print_01);//출력물에는 보여주지 않을 요소를 다시 복구
 	$("#not_print_td_02").html(not_print_02);//출력물에는 보여주지 않을 요소를 다시 복구
 	$("#not_print_td_03").html(not_print_03);//출력물에는 보여주지 않을 요소를 다시 복구
 	$("#not_print_td_04").html(not_print_04);//출력물에는 보여주지 않을 요소를 다시 복구
// 	$("#btn_td").html(tmp);
 	
	Some.document.close() ;
	Some.focus() ;
	Some.document.execCommand('SaveAs',false,'저장될 파일명');
	
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	if(typeof(rptAprvData) != "undefined"){
		document.form.rptAprvUsed.value = "Y";
		document.form.rptAprvCnt.value = approvalCnt;
		document.form.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "ClipReport4";
	document.form.submit(); 
}
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000">
<s:header popup="true">
	<!--내용시작-->
<div id="print_div">
<form id="form" name="form">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">		
	<%--ClipReport4 hidden 태그 끝--%>	
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
	<input type="hidden" name="house_code" id="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id" id="req_user_id" value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type" id="doc_type" value="AR">
	<input type="hidden" name="fnc_name" id="fnc_name" value="getApproval">
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>	
	

	
	<input type="hidden" name="pflag" id="pflag" />
	<input type="hidden" name="approval_str" id="approval_str" />
	<input type="hidden" name="sign_status" id="sign_status" value="N">                          
	

	<input type="hidden" name="app_line_id"  	id="app_line_id"  />
	<input type="hidden" name="app_line_seq" 	id="app_line_seq" />
	<input type="hidden" name="app_auto_flag" 	id="app_auto_flag" />
	<input type="hidden" name="app_line"     	id="app_line"     />
	<input type="hidden" name="Approval_str" 	id="Approval_str" />
	<input type="hidden" name="att_show_flag" 	id="att_show_flag">
	<input type="hidden" name="attach_seq"	  	id="attach_seq"	 >	
	<input type="hidden" name="isGridAttach"  	id="isGridAttach" >
	<input type="hidden" name="only_attach" 	id="only_attach" value="">
<% if(!"Y".equals(view_content)) { %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>계좌번호변경 상세
	</td>
</tr>
</table>
<%} %>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>		
<br>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td width="18%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청자
		</td>
		<td width="82%"  class="data_td"  colspan="3" >
			<input type="text" 		id="VENDOR_CODE" name="VENDOR_CODE" value='<%=ADD_USER_NAME+" ("+ADD_USER_ID+")" %>'  size="20" maxlength="30" class="input_data2" readOnly>					
		</td>       
    </tr>  
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
	<tr>
    	<td width="18%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드
		</td>
		<td width="32%"  class="data_td" >
			<input type="text" 		id="VENDOR_CODE" name="VENDOR_CODE" value='<%=VENDOR_CODE %>'  size="10" maxlength="20" class="input_data2" readOnly>					
		</td>
       <td width="18%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명
		</td>
		<td width="32%" class="data_td">
		    <input type="text" 		id="VENDOR_NAME_LOC" name="VENDOR_NAME_LOC" value='<%=VENDOR_NAME_LOC %>'  size="20" maxlength="50" class="input_data2" readOnly>							
		</td>     
    </tr>  
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;거래은행</td>
		<td class="data_td" colspan="3" >
			<input type="text" 		id="P_BANK_NAME" name="P_BANK_NAME" value='<%=P_BANK_NAME %>'  size="20" maxlength="50" class="input_data2" readOnly>			
		</td>
    </tr>  
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예금주</td>
		<td class="data_td">
			<input type="text" 		id="P_DEPOSITOR_NAME" name="P_DEPOSITOR_NAME" value='<%=P_DEPOSITOR_NAME %>'  size="20" maxlength="50" class="input_data2" readOnly>						
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계좌번호</td>
		<td class="data_td">
			<input type="text" 		id="P_BANK_ACCT" name="P_BANK_ACCT" value='<%=P_BANK_ACCT %>'  size="20" maxlength="50" class="input_data2" readOnly>						
		</td>
	</tr>   
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

</div>
<%-- 인쇄, 내PC에저장, 닫기 버튼 --%>
<% if(!"P".equals(VIEW_TYPE)){ %>	
<table height="10" width="99%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td align="right" id="btn_td">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="btnTable">
				<tr>
					<td height="10">&nbsp;</td>
			      	<td height="10" align="right">
						<table>
							<tr align="right">															
								<td><input type="button" style="height: 20px;" value="인 쇄" 		onclick="javascript:clipPrint()"></td>								
								<td><input type="button" style="height: 20px;" value="내PC에저장" 	onclick="javascript:fnHtmlDown()"></td>
								<td><input type="button" style="height: 20px;" value="닫 기" 		onclick="javascript:window.close()"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>			
		</td>
	</tr>
</table>
<% } %>
</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>

<div id="pagingArea"></div>

<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe id="Some" src="/sourcing/empty.htm"  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html> 