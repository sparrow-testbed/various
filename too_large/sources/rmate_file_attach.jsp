<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%
/**
 *========================================================
 *Copyright(c) 2010 ICOMPIA
 *
 *@File       : rMate_file_attach.jsp
 *
 *@FileName   : 첨부파일 관리
 *
 *Open Issues :
 *
 *Change history  :
 *@LastModifyDate : 2010. 06. 02
 *@LastModifier   : ICOMPIA
 *@LastVersion    : V 1.0.0
 *=========================================================
 */
 %>
 <%
 	String att_mode   = JSPUtil.nullToRef(request.getParameter("att_mode"), "R");
 	String view_type  = JSPUtil.nullToRef(request.getParameter("view_type"), "R");
 	String file_type  = JSPUtil.nullToRef(request.getParameter("file_type"), "");
 	String att_no     = JSPUtil.nullToRef(request.getParameter("tmp_att_no"), "");
 	String g_width    = JSPUtil.nullToRef(request.getParameter("width"), "");
 	String g_height   = JSPUtil.nullToRef(request.getParameter("height"), "");

	if (g_width.equals(""))  g_width  = "500";
	if (g_height.equals("")) g_height = "150";
	
	String cpage = "";
	
	if (view_type.equals("R")){
		cpage = "z_rMateFileDownloader.jsp";
	} else if (!att_no.equals("")) {
		cpage = "rMateFileUploaderUpdate.jsp";
	} else if (att_no.equals("")) {
		cpage = "rMateFileUploaderNew.jsp";
	}
%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<Script language="javascript">
<!--
	function setData() {
		document.attframe.startUpload();
	}

	//file attach result
	function uploadCompleteNewData(att_no, att_data) {
		document.f1.flag.value         = "C";
		document.f1.att_no.value       = att_no;
		document.f1.att_data.value     = att_data;
		document.f1.att_del_data.value = "";
	
		attachFileSave();
	}
	
	function uploadCompleteUpdateData(att_no, att_data, att_del_data) {
		document.f1.flag.value         = "U";
		document.f1.att_no.value       = att_no;
		document.f1.att_data.value     = att_data;
		document.f1.att_del_data.value = att_del_data;

    	attachFileSave();
	}

	function attachFileSave() {
		document.f1.method = "POST"; 
		document.f1.target = "attChildFrame";
		document.f1.action = "AttachFileManage.jsp";
		document.f1.submit();

	}

	function attachFileSaveResult(att_no, att_cnt) {
		document.f1.att_no.value = att_no;
		
		var att_data     = document.f1.att_data.value;
		var att_del_data = document.f1.att_del_data.value;

    	parent.setrMateFileAttach(att_no, att_cnt, att_data, att_del_data);
	}

//-->
</script>
<table width="98%" border="0" cellpadding="1" cellspacing="1">
<form name="f1" method="post" action="">
<input type="hidden" name="flag">
<input type="hidden" name="att_mode"  value="<%=att_mode%>">
<input type="hidden" name="file_type" value="<%=file_type%>">
<input type="hidden" name="att_no">
<input type="hidden" name="att_data">
<input type="hidden" name="att_del_data">
<tr>
	<td width="100%" class="c_data_1">
		<iframe name="attframe" src="/rMateFM/<%=cpage%>?file_type=<%=file_type%>&att_no=<%=att_no%>&att_mode=<%=att_mode%>" width="<%=g_width%>" height="<%=g_height%>" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
	</td>
</tr>
</form>
</table>
<iframe name="attChildFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="yes"> </iframe>
</html>