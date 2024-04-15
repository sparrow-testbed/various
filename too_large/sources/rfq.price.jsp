<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_232");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_232";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="RQ_232";%>

<%
	String house_code	= info.getSession("HOUSE_CODE");
	String rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count    = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	
	Object[] obj = {rfq_no, rfq_count};
	
	String 	vendor_name = "";
	String	tot_amt 	= "";
	String 	subject		= "";
	String	rfq_close	= "";
	
	SepoaOut valueH = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqPriceHeader", obj);
	SepoaFormater wfH = new SepoaFormater(valueH.result[0]);
	
	if(wfH != null && wfH.getRowCount() > 0){
		vendor_name = wfH.getValue("VENDOR_NAME"	, 0);
		tot_amt 	= wfH.getValue("TOT_AMT"		, 0);
		subject 	= wfH.getValue("SUBJECT"		, 0);
		rfq_close 	= wfH.getValue("RFQ_CLOSE_DATE"	, 0);
	}
	
	if(!"".equals(rfq_close)){
		rfq_close = rfq_close.substring(0, 4) + "년 " + rfq_close.substring(4, 6) + "월 " + rfq_close.substring(6, 8) + "일"; 	
	}

	SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqPriceList", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

%>

<html>
<head>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
function fnHtmlDowm(){
	$("#btn_td").html("");
 	Some.document.open("text/html","replace");
 	Some.document.write(document.documentElement.outerHTML) ;
	Some.document.close() ;
	Some.focus() ;
	Some.document.execCommand('SaveAs',false,'저장될 파일명');
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="center">
						<font style="font-size:50px; font-weight:bold; text-decoration:underline;">가 격 조 사 서</font>
					</td>
				</tr>
				<tr>
					<td align="center">
						<font style="font-size:20px;">(견적서 마감일자 : <%=rfq_close %>)</font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="120">
						<font style="font-size:25px;">&nbsp;&nbsp;■ 건   명 : <%=subject %></font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="40" align="left">
									<font style="font-size:20px;">&nbsp;&nbsp;○ 업체별 견적 가격</font>
								</td>
								<td height="40" align="right">
									<font style="font-size:15px;">(단위 : 원, 부가세 포함)&nbsp;</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="1" cellspacing="0" cellpadding="5">
						
							<!-- 헤더(업체명, 품명, 수량, 단가, 금액, 비고) start -->
							<tr bgcolor='#F0F0F0'>
								<td width="20%" height="40" align="center">
									<font style="font-size:20px;">업 체 명</font>
								</td>
								<td width="20%" height="40"  align="center">
									<font style="font-size:20px;">품 명</font>
								</td>
								<td width="15%" height="40"  align="center">
									<font style="font-size:20px;">수 량</font>
								</td>
								<td width="15%" height="40"  align="center">
									<font style="font-size:20px;">단 가</font>
								</td>
								<td width="15%" height="40"  align="center">
									<font style="font-size:20px;">금 액</font>
								</td>
								<td width="15%" height="40"  align="center">
									<font style="font-size:20px;">비고</font>
								</td>
							</tr>
							<!-- 헤더(업체명, 품명, 수량, 단가, 금액, 비고) end -->
							
							<!-- DB 조회 내용 start -->
							
<%
						int rowSpanCnt = 0;
						if(wf != null && wf.getRowCount() > 0){
							
							for(int i = 0 ; i < wf.getRowCount() ; i++){
								if(i > 0){
									if("1".equals(wf.getValue("ORDER_SEQ", i))){
										break;
									}
								}
								rowSpanCnt++;
							}
							
							
							for(int i = 0 ; i < wf.getRowCount() ; i++){
								
%>
							<tr <%= wf.getValue("ITEM_NAME", i).equals("") ? "bgcolor='#F0F0F0'" : "" %>>
<%
								if("1".equals(wf.getValue("ORDER_SEQ", i))){
%>
								<td width="20%" height="40" align="center" rowspan="<%=rowSpanCnt%>">
									<font style="font-size:16px;"><%=wf.getValue("VENDOR_NAME", i) %></font>
								</td>
<%
								}
%>							
								<td width="20%" height="40"  align="center">
									<font style="font-size:16px;"><%= wf.getValue("ITEM_NAME", i).equals("") ? "합   계" : wf.getValue("ITEM_NAME", i) %></font>
								</td>
								<td width="15%" height="40"  align="right">
									<font style="font-size:16px;"><%= SepoaMath.SepoaNumberType( wf.getValue("ITEM_QTY", i), "###,###,###,###,###,###") %></font>
								</td>
								<td width="15%" height="40"  align="right">
									<font style="font-size:16px;"><%= SepoaMath.SepoaNumberType( wf.getValue("UNIT_PRICE", i), "###,###,###,###,###,###") %></font>
								</td>
								<td width="15%" height="40"  align="right">
									<font style="font-size:16px;"><%= SepoaMath.SepoaNumberType( wf.getValue("SUPPLY_AMT", i), "###,###,###,###,###,###") %></font>
								</td>
								<td width="15%" height="40"  align="center">
									<font style="font-size:16px;"</font>
								</td>
							</tr>
<%								
							}
						}
%>							
							<!-- DB 조회 내용 end -->
							
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="30">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td>
			<table width="85%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="1" cellspacing="0" cellpadding="5">
							<tr>
								<td width="23%" height="40" align="center">
									<font style="font-size:20px;">● 최저견적업체 :</font>
								</td>
								<td width="42%" height="40" align="center">
									<font style="font-size:20px;"><%=vendor_name%></font>
								</td>
								<td width="35%" height="40" align="right">
									<font style="font-size:20px;"><%=SepoaMath.SepoaNumberType( tot_amt, "###,###,###,###,###,###") %></font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right" id="btn_td">
			</br>
			<input type="button" value="인쇄" onclick="javascript:window.print();">
			<input type="button" value="내PC에 저장" onclick="javascript:fnHtmlDowm();">
		</td>
	</tr>
</table>
<iframe id="Some" src="/sourcing/empty.htm"  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html>


