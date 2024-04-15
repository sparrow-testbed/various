<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_238_02");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String screen_id = "RQ_238_02";

%>

<% String WISEHUB_PROCESS_ID="RQ_238_02";%>
<%

	String RFQ_NO = JSPUtil.nullToEmpty(request.getParameter("RFQ_NO"));
	String RFQ_COUNT = JSPUtil.nullToEmpty(request.getParameter("RFQ_COUNT"));

 	int rw_cnt =0 ;
	int color = 1;

	Object[] obj = {RFQ_NO,RFQ_COUNT};
	
	SepoaOut value = ServiceConnector.doService(info, "p1071", "CONNECTION", "getQuery_RFQVENDOR", obj);

	SepoaFormater sf = null;

%>


<html>
<head>
<%@ include file="/include/include_css.jsp"%>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<!--내용시작-->
<form name="form" >
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<form name="form" >
	<tr> 
      <td  height="22" class="c_title_1_p_c" width="50%" align="center"> 
      <div align="center">업체코드</div>
       
      </td>
      <td height="22" class="c_title_1_p_c" width="50%" aling="center">
      <div align="center">업체명</div> 
        
      </td>
    </tr>


<%
	sf = new SepoaFormater(value.result[0]);

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
        <div align="center"><a href="javascript:parent.opener.setRFQvendor('<%=sf.getValue("R_NUM", i)%>','<%=sf.getValue("VENDOR_CODE", i)%>','<%=sf.getValue("NAME", i)%>','<%=rw_cnt%>'),parent.window.close()"><%=sf.getValue("VENDOR_CODE", i)%></a></div>
      </td>
      <td height="18" class="c_data_1_p_c">
        <div align="center"><a href="javascript:parent.opener.setRFQvendor('<%=sf.getValue("R_NUM", i)%>','<%=sf.getValue("VENDOR_CODE", i)%>','<%=sf.getValue("NAME", i)%>','<%=rw_cnt%>'),parent.window.close()"><%=sf.getValue("NAME", i)%></a></div>
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


