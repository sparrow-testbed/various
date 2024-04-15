<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ page import="javax.servlet.*"%>
<%
	response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "Thu, 01 Dec 1994 16:00:00 GMT");
%>
<%
	String grid_object_name_height = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("grid_object_name_height")));
%>
<script language='JavaScript'>
	function BwindowWidth() {
	 if (window.innerWidth) {
	 return window.innerWidth;
	 } else if (document.body && document.body.offsetWidth) {
	 return document.body.offsetWidth;
	 } else {
	 return 0;
	}
	}

	function BwindowHeight() {
	 if (window.innerHeight) {
	 return window.innerHeight;
	 } else if (document.body && document.body.offsetHeight) {
	 return document.body.offsetHeight;
	 } else {
	 return 0;
	}
	}

	function recal() {
 		/* document.form.height.value= document.body.clientHeight;
		document.form.width.value= document.body.clientWidth; */
		
	 //if (Width != BwindowWidth() || Height != BwindowHeight())
	 //{
<%
		sepoa.fw.util.SepoaStringTokenizer st = new SepoaStringTokenizer(grid_object_name_height, "#");
		String grid_object_name = "";
		String grid_height = "";

		while(st.hasMoreElements())
		{
			String token_string = (String) st.nextElement();
			int i = 0;

			sepoa.fw.util.SepoaStringTokenizer st_dt = new SepoaStringTokenizer(token_string, "=");

			while(st_dt.hasMoreElements())
			{
				String dt_token_string = (String) st_dt.nextElement();

				if(i == 0)
				{
					grid_object_name = dt_token_string;
				}
				else
				{
					grid_height = dt_token_string;
				}

				i++;
			}

			out.println("if(eval(document.body.clientHeight) > " + grid_height + ")");
			out.println("{");
//			out.println("	document.all['" + grid_object_name + "'].style.height = document.body.clientHeight - " + grid_height + ";");
			out.println(" if(document.getElementById('" + grid_object_name + "') != null ){ ");
			out.println(" 	var temp = document.body.clientHeight - " + grid_height + ";");
			out.println("   if(temp > 0){ ");
			out.println(" 		document.getElementById('" + grid_object_name + "').style.height = temp + 'px'; ");
			out.println(" 	}");
			out.println(" }");
			out.println(" if(document.getElementById('treeboxbox_tree') != null && document.getElementById('header') != null){ ");
			out.println("	var temp = document.body.clientHeight - parseInt(document.getElementById('header').offsetHeight) - 30 ");
			out.println("	if(temp > 0){ ");
			out.println(" 		document.getElementById('treeboxbox_tree').style.height = temp + 'px';");
			out.println("	}");
			out.println(" }");
			out.println("}");
		}
%>
	 	//window.history.go(0);
	 //}
	}

	// 네스케이프 NetScape
	if(!window.Width && window.innerWidth) {
	   // alert('Not available browser. We support only Internet Explorer.');
	   //return;
	   window.onresize = recal;
	   Width = BwindowWidth();
	   Height = BwindowHeight();
	  }

	// 익스플로우
	 if(!window.Width && document.body && document.body.offsetWidth) {
	   window.onresize = recal;
	   Width = BwindowWidth();
	   Height = BwindowHeight();
	 }
</script>
<%
		st = new SepoaStringTokenizer(grid_object_name_height, "#");
		grid_object_name = "";
		grid_height = "";

		while(st.hasMoreElements())
		{
			String token_string = (String) st.nextElement();
			int i = 0;

			sepoa.fw.util.SepoaStringTokenizer st_dt = new SepoaStringTokenizer(token_string, "=");

			while(st_dt.hasMoreElements())
			{
				String dt_token_string = (String) st_dt.nextElement();

				if(i == 0)
				{
					grid_object_name = dt_token_string;
				}
				else
				{
					grid_height = dt_token_string;
				}

				i++;
			}

			out.println("<script>");
			//document.all은 IE에서만 동작하는 특수한 메소드 이므로 사용하지 않도록 권장된다.HTML5에서
			//out.println(" document.all['" + grid_object_name + "'].style.height = document.body.clientHeight - " + grid_height + ";");
			out.println(" if(document.getElementById('" + grid_object_name + "') != null ){ ");
			out.println(" 	var temp = document.body.clientHeight - " + grid_height + ";");
			out.println("   if(temp > 0){ ");
			out.println(" 		document.getElementById('" + grid_object_name + "').style.height = temp + 'px'; ");
			out.println(" 	}");
			out.println(" }");
			out.println(" if(document.getElementById('treeboxbox_tree') != null && document.getElementById('header') != null){ ");
			out.println("	var temp = document.body.clientHeight - parseInt(document.getElementById('header').offsetHeight) - 30 ");
			out.println("	if(temp > 0){ ");
			out.println(" 		document.getElementById('treeboxbox_tree').style.height = temp + 'px';");
			out.println("	}");
			out.println(" }");
			out.println("</script>");
			
		}
%>
<form name="formstyle">
<input type="hidden" name="csvBuffer">
<input type="hidden" name="headText">
<input type="hidden" name="gridColids">
<input type="hidden" name="headWidth">
<input type="hidden" name="screen_id">
<input type="hidden" name="user_id">
</form>
