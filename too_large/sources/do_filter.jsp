<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%
	String grid_col_id    = JSPUtil.nullToEmpty(request.getParameter("grid_col_id"));
	String grid_col_lable = JSPUtil.nullToEmpty(request.getParameter("grid_col_lable"));
	SepoaStringTokenizer col_ids = new SepoaStringTokenizer(grid_col_id, ",");
	SepoaStringTokenizer col_las = new SepoaStringTokenizer(grid_col_lable, ",");
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info, multilang_id);
%>	
<Script language="javascript">
	function doFilter()
	{
		var filter_column = document.form.filter_column.value;
		var filter_word   = document.form.filter_word.value;
		window.close();
		opener.doFilterSearch(filter_column, filter_word);
	}
	
	function enableEnterKey() {
		function onkeypress(e) {
			if(window.event.keyCode == 13 && window.event.srcElement.type != "textarea" && window.event.srcElement.type != "button") { // 13 : Enter
				doFilter();
			}
		}

		document.onkeypress = onkeypress;
	}

	enableEnterKey();
</script>
<html>
<form name="form">
<table width="500">
	<tr>
		<td>
		<fieldset style="width:500">
			<legend>Filter</legend>
			Column 
			<select name='filter_column'>
				<%
					while(col_ids.hasMoreElements()) {
				%>	
					<option value="<%=col_ids.nextElement()%>"><%=col_las.nextElement()%></option>
				<%
					}
				
				%>
			</select>
			<%=text.get("MESSAGE.3004")%>
			<input type="text" name="filter_word" value="" >
			<input type="button" name="a11" value="<%=text.get("MESSAGE.3003")%>" id="a11" onclick='javascript:doFilter()'><br/><br/>
		</fieldset>
		</td>
	</tr>
</table>
</form>