<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_237_02");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String screen_id = "RQ_237_02";

%>

<% String WISEHUB_PROCESS_ID="RQ_237_02";%>

<%

	int rw_cnt =0 ;
	int color = 1;
	
	Object[] obj = {};
	SepoaOut value = ServiceConnector.doService(info, "p1071", "CONNECTION", "getQuery_RFQNO", obj);


%>


<html>
<head>
<%@ include file="/include/include_css.jsp"%>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
<!--내용시작-->
  
  <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<form name="form" >
	 <tr> 	  
	 <td  height="22" class="c_title_1_p_c" width="*"> 
        <div align="center">견적요청명</div>
      </td>
      <td  height="22" class="c_title_1_p_c" width="25%"> 
        <div align="center">견적요청번호</div>
      </td>
      <td height="22" class="c_title_1_p_c" width="10%"> 
        <div align="center">차수</div>
      </td>
    </tr>

<%
    	SepoaFormater sf = new SepoaFormater(value.result[0]);
		rw_cnt = sf.getRowCount();

		if(rw_cnt == 0) {
%>

    <tr height="22" class="jtable_bottom2" >
        조회 값이 없습니다.
    </tr>

<%
		} else {
			for(int i=0; i<rw_cnt; i++)
			{
				if(i%2 == 0)
				color = 1;
				else
				color = 2;
%>
    <tr>
      <td  height="18" class="c_data_1_p_c">
        <div align="left"><a href="javascript:parent.opener.setRFQNO('<%=sf.getValue("RFQ_NO", i)%>','<%=sf.getValue("RFQ_COUNT", i)%>'),parent.window.close()"><%=sf.getValue("SUBJECT", i)%></a></div>
      </td>
      <td  height="18" class="c_data_1_p_c">
        <div align="center"><a href="javascript:parent.opener.setRFQNO('<%=sf.getValue("RFQ_NO", i)%>','<%=sf.getValue("RFQ_COUNT", i)%>'),parent.window.close()"><%=sf.getValue("RFQ_NO", i)%></a></div>
      </td>
      <td height="18" class="c_data_1_p_c">
        <div align="center"><a href="javascript:parent.opener.setRFQNO('<%=sf.getValue("RFQ_NO", i)%>','<%=sf.getValue("RFQ_COUNT", i)%>'),parent.window.close()"><%=sf.getValue("RFQ_COUNT", i)%></a></div>
      </td>
    </tr>
<%
			}
		}
%>


  </table>

</form>

</s:header>
<s:footer/>
</body>
</html>


