<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp" %>
<%
 		Vector multilang_id = new Vector();
		multilang_id.addElement("BUTTON");
		multilang_id.addElement("QM_005");
		HashMap text = MessageUtil.getMessage(info, multilang_id);

        String house_code     = info.getSession("HOUSE_CODE");

        String qm_number          = JSPUtil.nullToEmpty(request.getParameter("qm_number"));
        Object[] obj = {qm_number};
        SepoaOut value = ServiceConnector.doService(info, "QM_005", "CONNECTION", "searchQmPirntInfo1", obj);

		String material_number = "";
		String description_eng = "";

        String notice_date = "";
        String return_due_date = "";
        String notice_type = "";
        String finish_date = "";
        String qm_user_id = "";
        String z_code1 = "";
        String temp_adjust_text = "";
        String plan_end_date = "";
        String CAUSE_TEXT = "";
        String ADJUST_TEXT = "";
        String benefit_text = "";
        String re_prevent_text = "";
        String re_prevent_end_date = "";
        String seller_name_loc = "";
        String bad_text = "";
		String END_DATE = "";
		String subject = "";
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		if(wf.getRowCount() > 0) {
			notice_date      	= wf.getValue("notice_date", 0);
			return_due_date  	= wf.getValue("return_due_date", 0);
			notice_type      	= wf.getValue("notice_type", 0);
			finish_date      	= wf.getValue("finish_date", 0);
			qm_user_id       	= wf.getValue("qm_user_id", 0);
			z_code1    		 	= wf.getValue("z_code1", 0);
			temp_adjust_text 	= wf.getValue("temp_adjust_text", 0);
			plan_end_date    	= wf.getValue("plan_end_date", 0);
			CAUSE_TEXT       	= wf.getValue("CAUSE_TEXT", 0);
			ADJUST_TEXT      	= wf.getValue("ADJUST_TEXT", 0);
			benefit_text     	= wf.getValue("benefit_text", 0);
			re_prevent_text  	= wf.getValue("re_prevent_text", 0);
			re_prevent_end_date = wf.getValue("re_prevent_end_date", 0);
			seller_name_loc     = wf.getValue("seller_name_loc", 0);
			bad_text	     	= wf.getValue("bad_text", 0);
			subject				= wf.getValue("subject", 0);
			material_number		= wf.getValue("material_number", 0);
			description_eng		= wf.getValue("description_eng", 0);
		}

%>

<%!
	public static String formatNumberQty(double d)
    {
        return (new DecimalFormat("###,###,###,###,##0.###")).format(d);
    }

	public static String formatNumberAmt(double d)
    {
        return (new DecimalFormat("###,###,###,###,##0.##")).format(d);
    }

	public static String formatNumberPrice(double d)
    {
        return (new DecimalFormat("###,###,###,###,##0.#####")).format(d);
    }

	public String convertDate(String dataData){
		String convert_year="";
		String convert_month ="";
		String convert_day="";
		if(dataData != null && dataData.length() ==8){
			convert_year = dataData.substring(0,4);
			convert_month = dataData.substring(4,6);
			convert_day = dataData.substring(6,8);
			dataData = convert_year+"/"+convert_month+"/"+convert_day;
		}
		return dataData;
	}

	public String convertTime(String dataData){
		String convert_hh="";
		String convert_mm ="";
		String convert_ss="";
		if(dataData != null && dataData.length() ==6){
			convert_hh = dataData.substring(0,2);
			convert_mm = dataData.substring(2,4);
			convert_ss = dataData.substring(4,6);
			dataData = convert_hh+":"+convert_mm+":"+convert_ss;
		}
		return dataData;
	}
%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body style="font-family:verdana,tahoma;">
<TABLE width="650" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="158cb5" bordercolordark="ffffff">
<TR>
	<TD align="center">
   <table width="630" border="1" cellpadding="0" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff">

   <tr>
      <td bgcolor="DEE2E3" height="5"></td>
   </tr>
   <tr>
      <td align="center"><table width="630" height="187" border="0" cellpadding="2" cellspacing="0" style="font-family:Arial;font-size:10pt;">
        <tr>
          <td width="367" height="104" align="center"><table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><img src="../images/logo_jel.gif" width="150" height="31" hspace="5" vspace="3" align="absmiddle"></td>
              <td><b style="font-size:27px;">시정조치요구서</b></td>
            </tr>
          </table><b style="font-size:20px;">CORRECTIVE ACTION REQUEST<br>
          (8 DISCIPLINE REPORT)</b></td>
          <td width="255" rowspan="2" align="right" valign="bottom"><table width="256" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
            <tr>
              <td align="center" bgcolor="#DBE8ED"><b>CAR NO.</b></td>
              <td align="center" bgcolor="#F1F1F1"><%=qm_number %>&nbsp;</td>
            </tr>
            <tr>
              <td align="center" bgcolor="#DBE8ED"><b>발 행 일 자</b><br>
                (ISSUE DATE)  </td>
              <td align="center" bgcolor="#F1F1F1"><%=convertDate(notice_date) %>&nbsp;</td>
            </tr>
            <tr>
              <td align="center" bgcolor="#DBE8ED"><b>회 신 기 한</b><br>
                (DUE DATE)</td>
              <td align="center" bgcolor="#F1F1F1"><%=convertDate(return_due_date) %>&nbsp;</td>
            </tr>
            <tr>
              <td align="center" bgcolor="#DBE8ED"><b>통 지 유 형</b></td>
              <td align="center" bgcolor="#F1F1F1"><%=notice_type %>&nbsp;</td>
            </tr>
            <tr>
              <td width="124" align="center" bgcolor="#DBE8ED"><strong>통지종결일</strong></td>
              <td width="123" align="center" bgcolor="#F1F1F1"><%=finish_date %>&nbsp;</td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td valign="bottom"><table width="370" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
            <tr>
              <td width="25%" height="50" align="center" bgcolor="#DBE8ED"><b style="font-size:12px;color:2C728A">시 정 조 치<br>
                조         직</b></td>
              <td colspan="3" align="center" bgcolor="#F1F1F1"><%=seller_name_loc %>&nbsp;</td>
              </tr>
            <tr>
              <td width="25%" align="center" bgcolor="#DBE8ED"><b style="font-size:12px;color:2C728A">의 뢰 부 서</b></td>
              <td width="25%" align="center" bgcolor="#F1F1F1">QC TEAM</td>
              <td width="25%" align="center" bgcolor="#DBE8ED"><b style="font-size:12px;color:2C728A">의 뢰 자</b></td>
              <td width="25%" align="center" bgcolor="#F1F1F1"><%=qm_user_id %>&nbsp;</td>
            </tr>

          </table></td>
          </tr>
      </table>        </td>
   </tr>
   </table>
   <table width="630" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
   <tr>
     <td width="30" rowspan="4" align="center" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">의<br>
     뢰<br>
     부<br>
     서</b></td>
     <td width="75" align="center" bgcolor="dbe8ed"><b style="font-size:12px;">프로세스명/ <br>
       Projcet명</b></td>
     <td width="177" align="center" bgcolor="#F1F1F1"><%=z_code1 %>&nbsp;</td>
     <td width="113" align="center" bgcolor="dbe8ed"><b style="font-size:12px">관 련 근 거<br>(참고문서 / ISO)
</b></td>
     <td width="203" align="center" bgcolor="#F1F1F1">JSP0805 부적합 관리 규정</td>
   </tr>


   <tr>
      <td align="center" bgcolor="dbe8ed"><b style="font-size:12px;">품목코드</b></td>
      <td  align="center" bgcolor="#F1F1F1">&nbsp;<%=material_number %>&nbsp;</td>

      <td align="center" bgcolor="dbe8ed"><b style="font-size:12px;">품명</b></td>
      <td  align="center" bgcolor="#F1F1F1">&nbsp;<%=description_eng %>&nbsp;</td>
   </tr>

   <tr>
      <td colspan="2" align="center" bgcolor="dbe8ed"><b style="font-size:12px;">부적합(NON-COMPLIANCE)</b></td>
      <td colspan="2" align="center" bgcolor="#F1F1F1">&nbsp;<%=subject %>&nbsp;</td>
      </tr>
	  <tr>
        <td height="100" colspan="4" bgcolor="#F1F1F1"><%=SepoaString.nToBr(bad_text) %>&nbsp;</td>
	    </tr>
   </table>
   <table width="630" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">

     <tr>
       <td height="30" colspan="2" align="center" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">임시조치 (CONTAINMENT ACTION)</b></td>
     </tr>
     <tr>
       <td width="509" height="100" rowspan="2" align="left" bgcolor="#F1F1F1"><%=SepoaString.nToBr(temp_adjust_text) %>&nbsp;</td>
       <td width="107" height="51" colspan="-2" align="center" bgcolor="#DBE8ED"><b style="font-size:12px;">Part입고예정일</b></td>
     </tr>

     <tr>
       <td height="57" align="center" bgcolor="#F1F1F1"><%=plan_end_date %>&nbsp;</td>
     </tr>
   </table>
   <table width="630" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
     <tr>
       <td height="30" align="center" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">원인분석 (DEFINE AND VERIFY ROOT CAUSES)
</b></td>
     </tr>
     <tr>
       <td height="60" align="left" bgcolor="#F1F1F1">
       <%
            Object[] obj2 = {qm_number};
        	SepoaOut value2 = ServiceConnector.doService(info, "QM_005", "CONNECTION", "searchQmPirntInfo2", obj2);
       		SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
       		for(int i = 0; i < wf2.getRowCount(); i++) {
       %>

       <%=wf2.getValue("CAUSE_TEXT", i) %><br>
       <%} %>


       </td>
       </tr>
<%--
     <tr>
       <td height="20" bgcolor="#E2EBED">*.첨부자료 (ATTACHMENTS)</td>
     </tr>
--%>
   </table>
   <table width="630" height="100" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
     <tr>
       <td height="30" colspan="2" align="center" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">근본대책 (CORRECTIVE ACTION)
</b></td>
       </tr>
     <tr>
       <td width="509" rowspan="2" align="left" bgcolor="#F1F1F1">&nbsp;
       <%
            Object[] obj3 = {qm_number};
        	SepoaOut value3 = ServiceConnector.doService(info, "QM_005", "CONNECTION", "searchQmPirntInfo3", obj3);
       		SepoaFormater wf3 = new SepoaFormater(value3.result[0]);
       		for(int i = 0; i < wf3.getRowCount(); i++) {
       		END_DATE = wf3.getValue("END_DATE", i);
       %>

       <%=wf3.getValue("ADJUST_TEXT", i) %><br>
       <%} %>
       </td>
       <td width="107" height="35" colspan="-2" align="center" bgcolor="#DBE8ED"><b style="font-size:12px;">완료일</b></td>
     </tr>

     <tr>
       <td height="35" align="center" bgcolor="#F1F1F1"><%=convertDate(END_DATE) %>&nbsp;</td>
     </tr>

<%--
     <tr>
       <td height="20" colspan="2" bgcolor="#E2EBED">*.첨부자료 (ATTACHMENTS)</td>
       </tr>
--%>
   </table>
   <table width="630" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
     <tr>
       <td height="30" colspan="2" align="center" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A">효과파악 (VERIFICATION OF EFFECTIVENESS)
</b></td>
       </tr>
     <tr>
       <td height="70" colspan="2" align="left" bgcolor="#F1F1F1"><%=SepoaString.nToBr(benefit_text) %>&nbsp;</td>
       </tr>

     <tr>
       <td colspan="2" align="center" bgcolor="dbe8ed"><b style="font-size:12px;color:2C728A"> 재발방지대책 (PREVENT RECURRENCE)</b></td>
       </tr>
     <tr>
       <td width="508" rowspan="2" align="left" bgcolor="F1F1F1"><%=SepoaString.nToBr(re_prevent_text) %>&nbsp;</td>
       <td width="108" height="49" align="center" bgcolor="DBE8ED"><b style="font-size:12px;">완료일</b></td>
     </tr>
     <tr>
       <td height="47" align="center" bgcolor="F1F1F1"><%=convertDate(re_prevent_end_date) %>&nbsp;</td>
     </tr>
<%--
     <tr>
       <td colspan="2" bgcolor="#E2EBED">*.첨부자료 (ATTACHMENTS)</td>
     </tr>
--%>
   </table>
   <table width="630" border="1" cellpadding="2" cellspacing="0" bordercolor="158cb5" bordercolorlight="158cb5" bordercolordark="ffffff" style="font-family:Arial;font-size:10pt;">
   <tr>
      <td height="30" align="center" width="10%">작 성</td><td align="right" width="23%">(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td height="30" align="center" width="10%">검 토</td><td align="right" width="23%">(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td height="30" align="center" width="10%">승 인</td><td align="right" width="24%">(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      </tr>
   </table>
   </TD>
</TR>
</TABLE>
<object id="label" viewastext  style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="../PrintCab/smsx.cab#Version=6,3,436,14"></object>
<script language="JavaScript">
    document.label.printing.header = "";
	document.label.printing.footer = "";
	document.label.printing.portrait = true;
	document.label.printing.leftMargin = 0;
	document.label.printing.topMargin = 0;
	document.label.printing.rightMargin = 0;
	document.label.printing.bottomMargin = 0;
	this.focus();
	document.label.printing.Print(true, window);
</script>
</body>
</html>
