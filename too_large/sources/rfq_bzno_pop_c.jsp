<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_RQ_237_02");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String screen_id = "I_RQ_237_02";

%>

<% String WISEHUB_PROCESS_ID="I_RQ_237_02";%>

<%

	int rw_cnt =0 ;
	int color = 1;
	
	String flag = JSPUtil.nullToRef(request.getParameter("flag"),""); 
	
	Object[] obj = {flag};
	SepoaOut value = ServiceConnector.doService(info, "I_p1002", "CONNECTION", "getQuery_BIZNO", obj);


%>


<html>
<head>
<%@ include file="/include/include_css.jsp"%>
</head>
<body  width="450" onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<!--내용시작-->
  
  <table width="450" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<form name="form" >
	 <tr> 	  
	 <td  height="22" class="c_title_1_p_c" width="*"> 
        <div align="center">사업명</div>
      </td>
      <td  height="22" class="c_title_1_p_c" width="25%"> 
        <div align="center">사업번호</div>
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
        <div align="left"><a href="javascript:parent.opener.setBIZNO('<%=sf.getValue("BIZ_NO", i)%>','<%=sf.getValue("BIZ_NM", i)%>'),parent.window.close()"><%=sf.getValue("BIZ_NM", i)%></a></div>
      </td>
      <td  height="18" class="c_data_1_p_c">
        <div align="center"><a href="javascript:parent.opener.setBIZNO('<%=sf.getValue("BIZ_NO", i)%>','<%=sf.getValue("BIZ_NM", i)%>'),parent.window.close()"><%=sf.getValue("BIZ_NO", i)%></a></div>
      </td>
    </tr>
<%
			}
		}
%>


  </table>

</form>
</body>
</html>


