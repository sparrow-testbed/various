<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
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
	SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "CONNECTION", "getQuery_ANN_NO2", obj);


%>


<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" type="text/javascript">
/*
함 수 명 : divGrdBody_onscroll
설    명 :  Head Grid 좌우 스코롤 제어
전달인수 : 
반 환 값 : 
예       : onscroll="divGrdBody_onscroll(document.all.divGrdBody, document.all.divGrdHead);"
*/
function divGrdBody_onscroll(divBody, divHead) 
{
	divHead.scrollLeft = divBody.scrollLeft;
}
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<!--내용시작-->
	<form name="form" >
	<table width="495px" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="left" class="se_cell_title">
			공고번호 조회
		</td>
	</tr>
	</table> 
	<table width="495px" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="495px" height="2" bgcolor="#0072bc"></td>
	</tr>
	<tr>
		<td height="20px"></td>
	</tr>
	</table>
	<table width="100%" border="0" cellpadding="1" cellspacing="1" >
	<tr><td>
	<DIV style="DISPLAY: block; OVERFLOW: hidden; WIDTH: 495px" id="divGrdHead">
	  <table border="0" cellpadding="1" cellspacing="1" width="495" > 
		 <tr> 	  
		 <td  height="22" class="c_title_1_p_c" width="*"> 
	        <div align="center">공고명</div>
	      </td>
	      <td  height="22" class="c_title_1_p_c" width="25%"> 
	        <div align="center">공고번호</div>
	      </td>
	      <td height="22" class="c_title_1_p_c" width="10%"> 
	        <div align="center">차수</div>
	      </td>
	    </tr>
    </table>
    </DIV>
    <DIV style="DISPLAY: block; OVERFLOW: auto; WIDTH: 495px; HEIGHT: 506px" onscroll="divGrdBody_onscroll(document.all.divGrdBody, document.all.divGrdHead);" id="divGrdBody">
    <table border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de" width="495">						
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
      <td  height="18" class="c_data_1_p_c" width="*">
        <div align="left"><a href="javascript:opener.setANN_NO2('<%=sf.getValue("ANN_NO2 ", i)%>','<%=sf.getValue("ANN_COUNT2", i)%>','<%=sf.getValue("ANN_ITEM2", i)%>'),parent.window.close()"><%=sf.getValue("ANN_ITEM2", i)%></a></div>
      </td>
      <td  height="18" class="c_data_1_p_c" width="25%">
        <div align="center"><a href="javascript:opener.setANN_NO2('<%=sf.getValue("ANN_NO2 ", i)%>','<%=sf.getValue("ANN_COUNT2", i)%>','<%=sf.getValue("ANN_ITEM2", i)%>'),parent.window.close()"><%=sf.getValue("ANN_NO2 ", i)%></a></div>
      </td>
      <td height="18" class="c_data_1_p_c" width="10%">
        <div align="center"><a href="javascript:opener.setANN_NO2('<%=sf.getValue("ANN_NO2 ", i)%>','<%=sf.getValue("ANN_COUNT2", i)%>','<%=sf.getValue("ANN_ITEM2", i)%>'),parent.window.close()"><%=sf.getValue("ANN_COUNT2", i)%></a></div>
      </td>
    </tr>
<%
			}
		}
%>
	</table>
    </DIV>
  </td></tr>
  </table>

</form>

</body>
</html>


