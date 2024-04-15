<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%
	SepoaFormater sf = null;
	String [] header = null;
	StringBuffer exdsb = new StringBuffer();

	try {
		String headText = request.getParameter("headText") == null  ? "" : request.getParameter("headText");
		
		sf                = (SepoaFormater)request.getSession().getValue("excel_data");
		String gridColids = request.getParameter("gridColids") == null  ? "" : request.getParameter("gridColids");
		Vector grid_col_vec = null;
		String grid_col_name = "";
		String grid_ex_data  = "";
		
		if(sf != null && sf.getRowCount() > 0) {
			header = SepoaString.StrToArray(headText, CommonUtil.getConfig("sepoa.separator.field"));
			grid_col_vec = SepoaString.StrToVector(gridColids, CommonUtil.getConfig("sepoa.separator.field"));
			
			for(int j=0; j < grid_col_vec.size(); j++) {
				grid_col_name = (String)grid_col_vec.elementAt(j);
			}
			
			for(int i=0; i < header.length; i++) {
				if(i == 0) {
					exdsb.append("<table border=1 cellspacing=0 cellpadding=2 style=\"border:1px solid #000000;\"><tr><td align=left>"+header[i]+"</td>");
				} else {
					exdsb.append("<td align=left>" + header[i]+"</td>");
				}
			}

			if(header.length > 0) exdsb.append("</tr>");
			
			for(int k=0; k < sf.getRowCount(); k++)
			{
				exdsb.append("<tr>");
				for(int j=0; j < grid_col_vec.size(); j++) {
					grid_col_name = (String)grid_col_vec.elementAt(j);
					grid_ex_data  = sf.getValue(grid_col_name, k);
					exdsb.append("<td align=left>&nbsp;"+grid_ex_data+"</td>");
				}
				exdsb.append("</tr>");
			}
			
			if(sf.getRowCount() > 0) exdsb.append("</table>");

			out.println(exdsb.toString());
		}
	} catch(Exception e) {}
	finally {

	}
%>
<Script language="javascript">
	window.print();
</script>