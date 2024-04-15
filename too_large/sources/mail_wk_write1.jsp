<%@ page contentType = "text/html; charset=UTF-8" %>
<%--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/master/partner/par_wk_ins2.jsp --%>
<%--
 Title:        partner create
 Description:  partner create
 Copyright:    Copyright (c)
 Company:      SEPOA SOFT<p>
 @author       eun pyo ,Lee<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
--%>
<%@ page import = "sepoa.fw.srv.SepoaOut" %>
<%-- <%@ include file="/include/sepoa_common.jsp" %> --%>

<%@ include file="/include/sepoa_session.jsp"%>
<%//@ include file="/include/wisetable_scripts.jsp"%>

<%-- <%@ include file="/include/sepoa_scripts.jsp"%> --%>
<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
    String user_id 			= info.getSession("ID");
    String user_name_loc 	= info.getSession("NAME_LOC");
    String user_name_eng 	= info.getSession("NAME_ENG");
    String user_dept 		= info.getSession("DEPARTMENT");
    String user_dept_name 	= info.getSession("DEPARTMENT_NAME_LOC");
    String company_code 	= info.getSession("COMPANY_CODE");
    String house_code 		= info.getSession("HOUSE_CODE");
    
    Vector multilang_id = new Vector();
	multilang_id.addElement("EM_001");
	HashMap stext = MessageUtil.getMessage(info, multilang_id);
%>

<%-- 
<html>
<head>
<title>Company change(General)</title> --%>


<%

        String choice = request.getParameter("choice");
        String companies = request.getParameter("companies");
        String subject = request.getParameter("subject");
        String text = request.getParameter("text1");
		String ATTACH_NO = request.getParameter("ATTACH_NO");
		
        String file = request.getParameter("file");
		String message = "";
		String altermessage ="";
		StringTokenizer companiestok = new StringTokenizer(companies,"@", false);

        int tokcount = companiestok.countTokens();

		int tokcount1 = 0;

        String[] com_code = new String[tokcount];
        String[][] com_code1 = new String[tokcount][tokcount1];

		if (choice.equals("A")) tokcount =1;


        // SMAIL 에 INSERT 하는 데이타.
        String[][] args = new String[1][7];

        // SSMSG 에 INSERT 하는 데이타.
        String[][] sendargs = new String[1][8];

        // SRMSG 에 INSERT 하는 데이타.
        String[][] revargs = new String[tokcount][5];

        args[0][0] = house_code;
        args[0][1] = company_code;
        args[0][2] = ""; //doc_no 가 들어갈 자리
        args[0][3] = subject;
        args[0][4] = text;
        args[0][5] = "";
        args[0][6] = ATTACH_NO;

        if (choice.equals("S"))
        {
			for( int i=0; i < tokcount; i++ ){

				revargs[i][0] = house_code;

				com_code[i] = companiestok.nextToken();

				StringTokenizer companiestok1 = new StringTokenizer(com_code[i],";", false);

				tokcount1 = companiestok1.countTokens();

				for(int k=1; k <= tokcount1; k++){

					revargs[i][k] = companiestok1.nextToken();
					//out.print("revargs["+i+"]["+ k + "]"+revargs[i][k]+"<br>");
				}

			}


         } else {
                revargs[0][0] = house_code;
                revargs[0][1] = "*";
                revargs[0][2] = "*";
                revargs[0][3] = "*";
                revargs[0][4] = "*";
         }

         sendargs[0][0] = house_code;
         sendargs[0][1] = company_code;
         sendargs[0][2] = "";//doc_no 가 들어갈 자리
         sendargs[0][3] = user_id;
         sendargs[0][4] = user_name_loc;
         sendargs[0][5] = user_name_eng;
         sendargs[0][6] = user_dept;
         sendargs[0][7] = user_dept_name;

         Object[] obj = {args,sendargs,revargs};
	    SepoaOut value = null;

         try {
	     	value = ServiceConnector.doService(info, "EM_001", "TRANSACTION","setInsertMAIL", obj);
	     	
           	if(value.status == 1)
				altermessage = value.result[0]==null ? "Nomessage" : value.result[0];
				Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
				Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);

         }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),request, " err = " + e.getMessage());
         
         }
         
         String message1 = (String)stext.get("EM_001.TEXT_004");
%>
<%-- [{
	"status":"<%=value.status%>",
	"message":"<%=message1%>",
	"altermessage":"<%=altermessage%>"
	
}] --%>
<Script language="javascript">

    (function Init()
    {
       if("<%=value.status%>" == "1")
        {
            //alert("메일을 성공적으로 보냈습니다.");
            alert("<%=stext.get("EM_001.TEXT_004")%>");
//            parent.body.location.href = "mail_bd_write1.jsp";
            location.href = "<%=request.getParameter("returnView")%>";
        }
        else alert("<%=altermessage%>");
    })();

</Script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html> -->
<%!

	public String nullChk( String str )
	{
		return ( str == null ) ? "Nomessage" : str;
	}

%>