<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_200");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_200";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%
	String doc_no 	= JSPUtil.nullToEmpty(request.getParameter("doc_no"));
	String doc_seq 	= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));
	String doc_type = JSPUtil.nullToEmpty(request.getParameter("doc_type"));

%>
<script>

	function openAttachDownload(attach_no){
		var url = "/rMateFM/rMate_file_attach.jsp?file_type=APP&tmp_att_no=" + attach_no;
		window.open(url, "fileDownload","left=0,top=0,width=600,height=300,resizable=yes,scrollbars=yes");
		/*
		document.frm.action = url;
		document.frm.method = "POST";
		document.frm.target = "fileDownload";
		document.frm.submit();
		*/

	}

</script>
<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#dedede">
<%
   Object[] obj_remark = {doc_no, doc_seq, doc_type};

    SepoaOut value_remark = ServiceConnector.doService(info,"AP_001","CONNECTION","getSignOpinion",obj_remark);
    SepoaFormater wf_remark = new SepoaFormater(value_remark.result[0]);
    String sign_user 	= "";
 	String sign_remark 	= "";
 	String attach_no	= "";
    for(int i = 0 ; i< wf_remark.getRowCount() ; i++)
	{
		attach_no = "";
		sign_user 		=	wf_remark.getValue("SIGN_USER"	, i);
    	sign_remark 	=	wf_remark.getValue("SIGN_REMARK"	, i);
    	attach_no		=   wf_remark.getValue("ATTACH_NO"	, i);

%>
	  <tr>
	   <td class="title_td" width="30%" valign="top"><%=sign_user%></td>
	   <td class="data_td" width="*"><%=sign_remark.replaceAll("\n", "<br>")%></td>
	   <%
	   if(i == 0 && !"".equals(attach_no)){
	   %>
	   <td class="title_td" width="50%"><input type="text" class="input_data2" value="첨부파일" style="cursor:hand;color='blue';" onClick="openAttachDownload('<%=attach_no%>');" readOnly></td>
	   <%
	   }else {	
	   %>
	   <td class="data_td" width="20%"><input type="text" class="input_data2" readOnly></td>
	   <%
	   }
	   %>
	  </tr>
<%
	}
%>
</table>





