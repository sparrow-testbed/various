<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_T04");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_T04";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="PR_T04";%>
<%
    String code     = JSPUtil.nullToEmpty(request.getParameter("code"));	//CODE ID
    if (code.indexOf("'") >= 0 || code.indexOf("%") >= 0 || code.indexOf("!") >= 0 || code.indexOf("-") >= 0 || code.indexOf("#") >= 0) {
		return;
	}
    
    String function = JSPUtil.nullToEmpty(request.getParameter("function"));	//CODE ID
    if (function.indexOf("'") >= 0 || function.indexOf("%") >= 0 || function.indexOf("!") >= 0 || function.indexOf("-") >= 0 || function.indexOf("#") >= 0) {
		return;
	}
    
    //N : Null Return되는 값없이 조회만 할 경우
	 //D : 기본적으로 제공하는 Function Name을 이용
	 //"function name" : User가 정한 Function Name으로 연결한다.

	    //SQL문에 Mapping될 Value
	    String[] values = JSPUtil.koForArray(request.getParameterValues("values"));
		
	    String[] desc = new String[2];

	    String flag = "N"; //POPUP 조회시, 코드/Desc로 조회할 코드값이 있을 경우 "Y" 없을 경우 "N"
	    if (values != null)  {	//파라미터값이 있을 경우
	    		for (int i = 0; i < values.length; i++)  {
	    		   Logger.debug.println(info.getSession("ID"),this,"여기 values["+i+"]===>"+values[i]);
	    		   if (values[i] == null) values[i] = "";
	    		   if(values[i].length() == 0 || values[i].endsWith("/") ) flag = "Y";
	    		   
	    		   if (values[i].indexOf("'") >= 0 || values[i].indexOf("%") >= 0 || values[i].indexOf("!") >= 0 || values[i].indexOf("-") >= 0 || values[i].indexOf("#") >= 0) {
	    				return;
	    		   }
			}//for
	    }//if


	    if ( values[values.length - 1].endsWith("/"))
	    {
				//조회 조건 TEXT
	    	//desc = JSPUtil.koForArray(request.getParameterValues("desc"));
				desc = request.getParameterValues("desc");
	    	if (values[values.length - 1].length() == 1)
	    		values[values.length - 1] = "";
	    	else values[values.length - 1] = values[values.length - 1].substring(0, values[values.length - 1].length() - 1);
	    }

	    String[] topvalues = new String[values.length];

	    //values[]을 copy 해서 topvalues를 만든다.
	    for (int i=0; i < values.length; i++)
	    	topvalues[i] = values[i];

	    // 조회조건이 있다면 조회조건이 보여지는 부분에는 value값으로 ""넣어준다.
	    // 처음 팝업을 띄운후 다시 조회가 가능하게 하기위함
	    // value 숫자를 맞추기 위함

	    if (flag.equals("Y"))
	    {
	    	topvalues[topvalues.length -1] = "";
	    	topvalues[topvalues.length -2] = "";
	    }

	    //Width
	    String width = JSPUtil.nullToEmpty(request.getParameter("width"));
	    if (width == null || "".equals(width))	width = "540";

		//Single POPUP인지, Multi POPUP인지 구분
       	Object[] obj = {code};
		String nickName = "p6032";
		String conType = "CONNECTION";

		String methodName = "getCodeFlag";

		SepoaRemote wr_type = null;
//		SepoaRemote wr_column = null;

		SepoaOut type = null;
		SepoaOut column = null;

	   	try {
			wr_type = new SepoaRemote(nickName, conType,info);
			type = wr_type.lookup(methodName, obj);
			Logger.debug.println(info.getSession("ID"),"message = " + type.message);
	   		Logger.debug.println(info.getSession("ID"),"status = " + type.status);
        } catch(Exception e) {
        	
	        Logger.debug.println(info.getSession("ID"),"e = " + e.getMessage());
	        Logger.debug.println(info.getSession("ID"),"message = " + type.message);
	        Logger.debug.println(info.getSession("ID"),"status = " + type.status);
		} finally {
				wr_type.Release();
		}

		//Flag값을 가져온다. SP(SinglePOPUP)/MP(MultiPOPUP)
		SepoaFormater wf = new SepoaFormater(type.result[0]);
		String s_type = wf.getValue("FLAG",0);

		//팝업이 뜨자마자 자동으로 조회 될것인지 말것인지 구분
		String auto_flag = wf.getValue("TEXT5",0);
		Logger.debug.println(info.getSession("ID"),"-- auto_flag = " + auto_flag);
		if(auto_flag.length() == 0) auto_flag = "Y";

		//조회조건이 없는 팝업은 무조건 자동 조회다.
		if (topvalues[topvalues.length -1] != "")
			auto_flag = "Y";

 		for (int i = 0; i<desc.length; i++)  {
			if (desc[i] == null) desc[i] = "";

		}

		String urlTop_Sp = "cod_sp_lis3.jsp?code="+code+"&function="+function+"&width="+width+"&flag="+flag;		//Single POPUP top URL
		String urlCenter_Sp = "cod_sp_lis2.jsp?code="+code+"&function="+function+"&width="+width+"&flag="+flag+"&auto_flag="+auto_flag;	//Single POPUP center URL

		String urlTop_Mp = "cod_mp_lis3.jsp?code="+code+"&function="+function+"&width="+width+"&flag="+flag;		//Multi POPUP top URL
		String urlCenter_Mp = "cod_mp_lis2.jsp?code="+code+"&function="+function+"&width="+width+"&flag="+flag+"&auto_flag="+auto_flag;	//Multi POPUP center URL

    	String urlTop = "";			//POPUP top
		String urlCenter = "";		//POPUP Center
		String urlBottom = "";		//POPUP Bottom

		if (values != null)  {	//파라미터값이 있을 경우
	    	for (int i = 0; i<values.length; i++)  {
			 	if (s_type.equals("SP")) { //Single POPUP일 경우
		    	  	 	urlTop_Sp     += "&values="+topvalues[i];
		   			    urlCenter_Sp += "&values="+values[i];
		   		} else {
		    	   		if (values[i] != null && values[i].length() != 0) urlTop_Mp += "&values="+topvalues[i];
		   			        urlCenter_Mp += "&values="+values[i];
		   		}//if
			}//for
		}//if



		for (int i = 0; i<desc.length; i++)  {
			if (s_type.equals("SP")) { //Single POPUP일 경우
		   	   urlTop_Sp += "&desc="+URLEncoder.encode(desc[i], "UTF-8");

			} else {
		    	   urlTop_Mp += "&desc="+URLEncoder.encode(desc[i], "UTF-8");

			}//if
		}//for

		if (s_type.equals("SP")) { //Single POPUP일 경우
   			urlTop = urlTop_Sp;
   			urlCenter = urlCenter_Sp;
   			urlBottom = "cod_sp_lis4.jsp?code="+code+"&function="+function+"&width="+width;
		} else if (s_type.equals("MP")){	//Multi POPUP일 경우
   			urlTop = urlTop_Mp;
   			urlCenter = urlCenter_Mp;
   			urlBottom = "cod_mp_lis4.jsp?code="+code+"&function="+function;
		}

%>

<html>
<head>
<title>Code Search</title>

<% if (flag.equals("Y"))  { %>
<frameset rows="135,*,30" cols="*" frameborder="no" border="0" framespacing="0">
<% } else { %>
<frameset rows="80,*,30" cols="*" frameborder="no" border="0" framespacing="0">
<% } %>
	<frame src="<%=urlTop%>"   name="top" SCROLLING="no" >
	<frame src="<%=urlCenter%>" name="center" SCROLLING="auto">
	<frame src="<%=urlBottom%>" SCROLLING="no">
</frameset>
<noframes></noframes>
</html>