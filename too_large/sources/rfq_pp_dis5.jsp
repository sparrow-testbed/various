<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
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
	String WISEHUB_PROCESS_ID="RQ_232";

	String rfq_no = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	String count = JSPUtil.nullToEmpty(request.getParameter("count"));

	Object[] obj = {rfq_no, rfq_count};
	
	SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqAnnounce", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	String RFQ_NO = "";
	String SUBJECT = "";
	String RFQ_COUNT = "";
	String ANNOUNCE_DATE_VIEW = "";
	String ANNOUNCE_TIME_VIEW = ""; 
	String HOST = "";
	String AREA = "";
	String PLACE = "";
	String notifier = "";
	String doc_frw_date = "";
	String resp = "";
	String comment = "";
	
	if(wf != null) {
		if(wf.getRowCount() > 0) { //데이타가 있는 경우
			int n = 0;

			RFQ_NO 				= wf.getValue("RFQ_NO", 0);
			SUBJECT 			= wf.getValue("SUBJECT", 0);
			RFQ_COUNT 			= wf.getValue("RFQ_COUNT", 0);
			ANNOUNCE_DATE_VIEW	= wf.getValue("ANNOUNCE_DATE_VIEW", 0); 
			ANNOUNCE_TIME_VIEW	= wf.getValue("ANNOUNCE_TIME_VIEW", 0);
			HOST 				= wf.getValue("ANNOUNCE_HOST", 0);
			AREA 				= wf.getValue("ANNOUNCE_AREA", 0);
			PLACE 				= wf.getValue("ANNOUNCE_PLACE", 0);
			notifier 			= wf.getValue("ANNOUNCE_NOTIFIER", 0);
			doc_frw_date 		= wf.getValue("DOC_FRW_DATE_VIEW", 0);
			resp 				= wf.getValue("ANNOUNCE_RESP", 0);
			comment 			= wf.getValue("ANNOUNCE_COMMENT", 0);
		}
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">제안설명회 안내</td>
		</tr>
	</table> 
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
		      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
  	<form name="form1" >
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
										<td width="35%" class="data_td" colspan="3"><%=RFQ_NO%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>    
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명</td>
										<td width="35%" class="data_td" colspan="3">
											<%=SUBJECT%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;개최일자</td>
										<td width="35%" class="data_td">
											<%=ANNOUNCE_DATE_VIEW%>&nbsp;
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;시간</td>
										<td width="35%" class="data_td">
											<%=ANNOUNCE_TIME_VIEW%>&nbsp;
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지역</td>
										<td width="35%" class="data_td">
											<%=AREA%>&nbsp;
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;장소</td>
										<td width="35%" class="data_td">
											<%=PLACE%>&nbsp;
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공고자</td>
										<td width="35%" class="data_td">
											<%=notifier%>&nbsp;
										</td>
										<td width="17%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자/문의처</td>
										<td width="33%" class="data_td" >
											<%=resp%>&nbsp;
										</td>  
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr> 
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
										<td colspan="3" class="data_td">
											<textarea name="comment" cols="73" style="width: 98%;" maxlength=400 rows="5" readonly><%=comment%></textarea>
										</td>
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
<%--<s:grid screen_id="RQ_232" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>