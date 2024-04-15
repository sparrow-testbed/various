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
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_rfq_price"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(rfq_close);
	_rptData.append(_RF);
	_rptData.append(subject);
	
	_rptData.append(_RD);	
	
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
			_rptData.append(wf.getValue("VENDOR_NAME", i));
			_rptData.append(_RF);			
			_rptData.append(wf.getValue("ITEM_NAME", i).equals("") ? "합   계" : wf.getValue("ITEM_NAME", i));
			_rptData.append(_RF);
			_rptData.append(SepoaMath.SepoaNumberType( wf.getValue("ITEM_QTY", i), "###,###,###,###,###,###"));
			_rptData.append(_RF);
			_rptData.append(SepoaMath.SepoaNumberType( wf.getValue("UNIT_PRICE", i), "###,###,###,###,###,###"));
			_rptData.append(_RF);
			_rptData.append(SepoaMath.SepoaNumberType( wf.getValue("SUPPLY_AMT", i), "###,###,###,###,###,###"));
			_rptData.append(_RL);			
		}
	}
	_rptData.append(_RD);
	
	_rptData.append(vendor_name);
	_rptData.append(_RF);			
	_rptData.append(SepoaMath.SepoaNumberType( tot_amt, "###,###,###,###,###,###"));	
	//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////

%>

<html>
<head>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
function fnHtmlDowm(){
	var tmp = $("#btn_td").html();
	$("#btn_td").html("");
 	
	Some.document.open("text/html","replace");
 	Some.document.write(document.documentElement.outerHTML) ;
 	
	$("#btn_td").html(tmp);
 	
	Some.document.close() ;
	Some.focus() ;
	Some.document.execCommand('SaveAs',false,'저장될 파일명');
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData) {
	if(typeof(rptAprvData) != "undefined"){
		alert(rptAprvData);
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form.method = "POST";
	document.form.action = url;
	document.form.target = "ClipReport4";
	document.form.submit();
	cwin.focus();
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<form id="form" name="form" >
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<%--ClipReport4 hidden 태그 끝--%>
	
<table width="100%" border="0" cellspacing="0" cellpadding="10" id="btnTable">
	<tr>
		<td height="30"></td>
      	<td height="50" align=right>
			<table>
				<td>
					<script language="javascript">btn("javascript:clipPrint();", "출 력");</script>
				</td>
				<td>
					<script language="javascript">btn("javascript:window.close()","닫 기");</script>
				</td>
			</table>
		</td>
	</tr>
</table>		
		
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="10">
				<tr>
					<td align="center">
						<font style="font-size:35px; font-weight:bold; text-decoration:underline;" color="black">가 격 조 사 서</font>
					</td>
				</tr>
				<tr>
					<td align="center">
						<font style="font-size:15px;" color="black">(견적서 마감일자 : <%=rfq_close %>)</font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="10">
				<tr>
					<td height="120">
						<font style="font-size:20px;" color="black">&nbsp;&nbsp;■ 건   명 : <%=subject %></font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="10">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="40" align="left">
									<font style="font-size:15px;" color="black">&nbsp;&nbsp;○ 업체별 견적 가격</font>
								</td>
								<td height="40" align="right">
									<font style="font-size:12px;" color="black">(단위 : 원, 부가세 포함)&nbsp;</font>
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
			<table width="100%" border="0" cellspacing="0" cellpadding="10">
				<tr>
					<td>
						<table width="100%" border="1" cellspacing="0" cellpadding="2">
						
							<!-- 헤더(업체명, 품명, 수량, 단가, 금액, 비고) start -->
							<tr bgcolor='#F0F0F0'>
								<td width="20%" height="30" align="center">
									<font style="font-size:15px;" color="black">업 체 명</font>
								</td>
								<td width="20%" height="30"  align="center">
									<font style="font-size:15px;" color="black">품 명</font>
								</td>
								<td width="15%" height="30"  align="center">
									<font style="font-size:15px;" color="black">수 량</font>
								</td>
								<td width="15%" height="30"  align="center">
									<font style="font-size:15px;" color="black">단 가</font>
								</td>
								<td width="15%" height="30"  align="center">
									<font style="font-size:15px;" color="black">금 액</font>
								</td>
								<td width="15%" height="30"  align="center">
									<font style="font-size:15px;" color="black">비고</font>
								</td>
							</tr>
							<!-- 헤더(업체명, 품명, 수량, 단가, 금액, 비고) end -->
							
							<!-- DB 조회 내용 start -->
							
<%
						rowSpanCnt = 0;
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
								<td width="20%" height="30" align="center" rowspan="<%=rowSpanCnt%>">
									<font style="font-size:13px;" color="black"><%=wf.getValue("VENDOR_NAME", i) %></font>
								</td>
<%
								}
%>							
								<td width="20%" height="30"  align="center">
									<font style="font-size:13px;" color="black"><%= wf.getValue("ITEM_NAME", i).equals("") ? "합   계" : wf.getValue("ITEM_NAME", i) %></font>
								</td>
								<td width="15%" height="30"  align="right">
									<font style="font-size:13px;" color="black"><%= SepoaMath.SepoaNumberType( wf.getValue("ITEM_QTY", i), "###,###,###,###,###,###") %></font>
								</td>
								<td width="15%" height="30"  align="right">
									<font style="font-size:13px;" color="black"><%= SepoaMath.SepoaNumberType( wf.getValue("UNIT_PRICE", i), "###,###,###,###,###,###") %></font>
								</td>
								<td width="15%" height="30"  align="right">
									<font style="font-size:13px;" color="black"><%= SepoaMath.SepoaNumberType( wf.getValue("SUPPLY_AMT", i), "###,###,###,###,###,###") %></font>
								</td>
								<td width="15%" height="30"  align="center">
									<font style="font-size:13px;" color="black"></font>
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
			<table width="85%" border="0" cellspacing="0" cellpadding="10">
				<tr>
					<td>
						<table width="100%" border="1" cellspacing="0" cellpadding="2">
							<tr>
								<td width="23%" height="30" align="center">
									<font style="font-size:15px;" color="black">● 최저견적업체 :</font>
								</td>
								<td width="42%" height="30" align="center">
									<font style="font-size:15px;" color="black"><%=vendor_name%></font>
								</td>
								<td width="35%" height="30" align="right">
									<font style="font-size:15px;" color="black"><%=SepoaMath.SepoaNumberType( tot_amt, "###,###,###,###,###,###") %></font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="15"></td>
	</tr>
	<tr height="30">
		<td align="right" id="btn_td">
			
<!-- 			<table width="100%" border="0" cellspacing="0" cellpadding="10" id="btnTable">
				<tr>
					<td height="30"></td>
			      	<td height="50" align=right>
						<table>
							<td>
								<script language="javascript">btn("javascript:clipPrint();", "출 력");</script>
							</td>
							<td>
								<script language="javascript">btn("javascript:window.close()","닫 기");</script>
							</td>
						<tr>
	 							<td><input type="button" style="height: 20px;" value="인 쇄" 		onclick="javascript:clipPrint()"></td>
								<td><input type="button" style="height: 20px;" value="내PC에저장" 	onclick="javascript:fnHtmlDowm()"></td>
								<td><input type="button" style="height: 20px;" value="닫 기" 		onclick="javascript:window.close()"></td> 
							</tr>
						</table>
					</td>
				</tr>
			</table>	 -->		
			
		</td>
	</tr>
</table>
<iframe id="Some" src="/sourcing/empty.htm"  width="0%" height="0" border=0 frameborder=0></iframe>
</form>
</body>
</html>


