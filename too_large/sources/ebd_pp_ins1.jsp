<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%

    String mode = request.getParameter("mode");

    String HOUSE_CODE = info.getSession("HOUSE_CODE");

    String BID_NO = "";
    String BID_COUNT = "";
    String SZDATE = "";
    String START_TIME = "";

    String END_TIME = "";
    String AREA = "";
    String PLACE = "";
    String notifier = "";

    String doc_frw_date = "";
    String resp = "";
    String comment = "";
    String ANNOUNCE_FLAG = "";
    String ANNOUNCE_TEL = "";

	String SCR_FLAG     = request.getParameter("SCR_FLAG");
	if(SCR_FLAG == null)    SCR_FLAG    ="I";


    if(mode.equals("I")) { //입력

    }

    else if(mode.equals("IM")) { //입력후 수정
        String m_BID_NO = request.getParameter("BID_NO");
        m_BID_NO = m_BID_NO.replaceAll("'","").replaceAll("<","").replaceAll(">","");

        String m_BID_COUNT = request.getParameter("BID_COUNT");
        String m_SZDATE = request.getParameter("SZDATE");
        String m_START_TIME = request.getParameter("START_TIME");

        String m_END_TIME = request.getParameter("END_TIME");
//        String m_AREA = request.getParameter("AREA");
        String m_PLACE = request.getParameter("PLACE");
//        String m_notifier = request.getParameter("notifier");
        String m_ANNOUNCE_FLAG = request.getParameter("ANNOUNCE_FLAG");
        String m_ANNOUNCE_TEL  = request.getParameter("ANNOUNCE_TEL");

//        String m_doc_frw_date = request.getParameter("doc_frw_date");
        String m_resp = request.getParameter("resp");
        String m_comment = request.getParameter("comment");

        if(m_BID_NO == null) m_BID_NO = "";
        if(m_BID_COUNT == null) m_BID_COUNT = "";
        if(m_SZDATE == null) m_SZDATE = "";
        if(m_START_TIME == null) m_START_TIME = "";

        if(m_END_TIME == null) m_END_TIME = "";
//        if(m_AREA == null) m_AREA = "";
        if(m_PLACE == null) m_PLACE = "";
//        if(m_notifier == null) m_notifier = "";
        if(m_ANNOUNCE_FLAG == null) m_ANNOUNCE_FLAG = "";
        if(m_ANNOUNCE_TEL == null) m_ANNOUNCE_TEL = "";

//        if(m_doc_frw_date == null) m_doc_frw_date = "";
        if(m_resp == null) m_resp = "";
        if(m_comment == null) m_comment = "";

        BID_NO = m_BID_NO;
        BID_COUNT = m_BID_COUNT;
        SZDATE = m_SZDATE;
        START_TIME = m_START_TIME;

        END_TIME = m_END_TIME;
//        AREA = m_AREA;
        PLACE = m_PLACE;
//        notifier = m_notifier;
        ANNOUNCE_FLAG = m_ANNOUNCE_FLAG;
        ANNOUNCE_TEL = m_ANNOUNCE_TEL;

//        doc_frw_date = m_doc_frw_date;
        resp = m_resp;
        comment = m_comment;
    }

    else if(mode.equals("M") || mode.equals("D")) { //수정, supply 상세조회
        BID_NO = request.getParameter("BID_NO");
        BID_COUNT = request.getParameter("BID_COUNT");

		/*      
		Object[] args = {BID_NO, BID_COUNT};
        SepoaOut rtn = null;
        SepoaRemote wr = null;

        String nickName = "BD_001";
        String MethodName = "getBidAnnounce";
        String conType = "CONNECTION";

        try {
            wr = new SepoaRemote(nickName, conType, info);
            rtn = wr.lookup(MethodName, args);
        }catch(Exception e) {
            Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());
        }finally{
            wr.Release();
        } */
        
        Map map = new HashMap();
        map.put("BID_NO", 		BID_NO);
        map.put("BID_COUNT", 	BID_COUNT);
        
        Object[] obj = {map};
        SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getBidAnnounce", obj);

        SepoaFormater wf = new SepoaFormater(value.result[0]);

            if(wf != null) {
                if(wf.getRowCount() > 0) { //데이타가 있는 경우
                    int n = 0;

                    BID_NO           = wf.getValue("BID_NO",              0);
                    BID_COUNT        = wf.getValue("BID_COUNT",           0);
                    SZDATE           = wf.getValue("ANNOUNCE_DATE",       0);
                    START_TIME       = wf.getValue("ANNOUNCE_TIME_FROM",  0);
                    END_TIME         = wf.getValue("ANNOUNCE_TIME_TO",    0);
//                    AREA             = wf.getValue("ANNOUNCE_AREA",       0);
                    PLACE            = wf.getValue("ANNOUNCE_PLACE",      0);
//                    notifier         = wf.getValue("ANNOUNCE_NOTIFIER",   0);
                    ANNOUNCE_FLAG    = wf.getValue("ANNOUNCE_FLAG",       0);
                    ANNOUNCE_TEL     = wf.getValue("ANNOUNCE_TEL",        0);
//                    doc_frw_date     = wf.getValue("DOC_FRW_DATE",        0);
                    resp             = wf.getValue("ANNOUNCE_RESP",       0);
                    comment          = wf.getValue("ANNOUNCE_COMMENT",    0);

                }
        }


    }
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">

    function doInsert() {
        var szdate = LRTrim(del_Slash(form1.date.value));
        var start_time 	= LRTrim(form1.start_time.value);
        var end_time 	= LRTrim(form1.end_time.value);

        if(szdate == "") {
            alert("개최일을 반드시 입력하셔야 합니다.");
            return;
        }
        var start_time = LRTrim(form1.start_time.value);
        if(start_time == "") {
            alert("시작시간은 반드시 입력하셔야 합니다.");
            return;
        }
        var end_time = LRTrim(form1.end_time.value);
        if(end_time == "") {
            alert("종료시간은 반드시 입력하셔야 합니다.");
            return;
        }

/*
        if (chkKorea(document.forms[0].area.value) > 10) {
            alert("지역은 10자 이내입니다.");
            document.forms[0].area.focus();
            return ;
        }
*/
        if (chkKorea(document.forms[0].place.value) > 100) {
            alert("장소는 50자 이내입니다.");
            document.forms[0].place.focus();
            return ;
        }
/*
        if (chkKorea(document.forms[0].notifier.value) > 30) {
            alert("공고자는 30자 이내입니다.");
            document.forms[0].notifier.focus();
            return ;
        }
*/
/*         if (chkKorea(document.forms[0].resp.value) > 30) {
            alert("담당자는 30자 이내입니다.");
            document.forms[0].resp.focus();
            return ;
        }

        if (!IsTel(document.forms[0].ANNOUNCE_TEL.value)) {
            alert("문의처는 전화번호 양식으로 입력해 주셔야 합니다.");
            document.forms[0].ANNOUNCE_TEL.focus();
            return ;
        }

        if (chkKorea(document.forms[0].comment.value) > 400) {
            alert("특기사항은 400자 이내입니다.");
            document.forms[0].comment.focus();
            return ;
        }
 */
        var to_day = new Date();
        var YEAR = to_day.getYear();
        var MONTH = to_day.getMonth() + 1;
        var DAY = to_day.getDate();

            if(MONTH < '10')// patch 판
                MONTH = "0"+MONTH.toString();// patch 판

            if(DAY < '10')// patch 판
                DAY = "0"+DAY.toString();// patch 판

            var today = YEAR.toString() + MONTH.toString() + DAY;
            if(LRTrim(szdate) < today) {
            alert("개최일은 오늘날짜 이후여야 합니다.");
            return;
        }


        if(!TimeCheck(start_time)){
			document.forms[0].start_time.focus();
			alert("설명회 시간을 확인하세요.");
			return;
		}

		if(!TimeCheck(end_time)){
			document.forms[0].end_time.focus();
			alert("설명회 시간을 확인하세요.");
			return;
		}
/*
        if(form1.doc_frw_date.value == "") {
            alert("문서발송일을 반드시 입력하셔야 합니다.");
            return;
        }
*/
        opener.setExplanation(szdate, document.form1.start_time.value, document.form1.end_time.value, document.form1.place.value);
        window.close();
    }

	function TimeCheck(str)
	{
	 var hh,mm;

	  if(str.length == 0)
		 return true;

	  if(IsNumber1(str)==false || str.length !=4 )
		return false;

	  hh=str.substring(0,2);
	  mm=str.substring(2,4);

	  if(parseInt(hh)<0 || parseInt(hh)>23)
		 return false;

	  if(parseInt(mm)<0 || parseInt(mm)>59)
		 return false;

	  return true;
	}

    function date1(year,month,day,week) {
        document.form1.date.value=year+month+day;
    }

    function date2(year,month,day,week) {
        document.form1.doc_frw_date.value=year+month+day;
    }

    function doCancle() {
    	if(confirm("설명회를 삭제 하시겠습니까?") == 1) {
        	opener.setExplanation("", "", "", "",  "", "", "", "");
	        window.close();
	    }
    }

</script>

</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" >

<!--	hidden	-->
<input type="hidden" name="BID_NO" value="<%=BID_NO%>">
<input type="hidden" name="BID_COUNT" value="<%=BID_COUNT%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>설명회 안내
	</td>
</tr>
</table>

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
      <td width="15%" class="title_td">
        <div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;개최일</div>
      </td>
      <td width="35%" class="data_td">
        <%-- <input type="text" name="date" size="20" class="input_re" maxlength=8 value="<%=SZDATE%>">
<%--         <a href="javascript:Calendar_Open('date1');"><img src="../../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0"></a> --%>
        <s:calendar id="date" default_value="" format="%Y/%m/%d"/>
      </td>
      <td width="15%" class="title_td">
        <div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;시간</div>
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="start_time" size="10" class="input_re" maxlength=4 value="<%=START_TIME%>">
        ~
        <input type="text" name="end_time" size="10" class="input_re" maxlength=4 value="<%=END_TIME%>">
         &nbsp&nbsp(ex : <b>1230</b>)
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">
        <div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;장소</div>
      </td>
      <td width="35%" class="data_td" colspan="3">
        <input type="text" name="place" id="place" size="70" class="inputsubmit" maxlength="150" value="<%=PLACE%>">
      </td>
    </tr>
  </table>

</td>
</tr>
</table>
</td>
</tr>
</table>
 
  
  <TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
						<TR>
							<TD height="30" align="right">
								<TABLE cellpadding="0">
									<TR>

<%
	if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {

    	if(!mode.equals("D")) {
%>
										<td>
        <script language="javascript">
			btn("javascript:doInsert()", "등 록");
		</script>
												</td>
												<td>
		<script language="javascript">
			btn("javascript:doCancle();", "취 소");
		</script>
		</td>
<%
    	}
	}
%>


										<td>
<script language="javascript">
	btn("javascript:window.close()", "닫 기");
</script>
										</td>
									</TR>
								</TABLE>
							</TD>
						</TR>
					</TABLE>
  </form>

<!---- END OF USER SOURCE CODE ---->

</body>
</html>