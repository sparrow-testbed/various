<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%> --%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_119");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	String user_id       = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept     = info.getSession("DEPARTMENT");
	String house_code    = info.getSession("HOUSE_CODE");

    String cur_date = SepoaDate.getShortDateString(); 
    String cur_time = SepoaDate.getShortTimeString(); 
    String status = "R"; 
%>

<%-- <html>
<head>
<title></title> --%>
<%
	String company_code = request.getParameter("company_code");
	String plant_code   = request.getParameter("plant_code");

	String[] args = {
	
		  JSPUtil.paramCheck(request.getParameter("plant_name_loc")         )
		, JSPUtil.paramCheck(request.getParameter("plant_name_eng")         )
		, JSPUtil.paramCheck(request.getParameter("country")                )
		, JSPUtil.paramCheck(request.getParameter("irs_no")                 )
		, JSPUtil.paramCheck(request.getParameter("biz_name_loc")           )
		, JSPUtil.paramCheck(request.getParameter("biz_name_eng")           )
		, JSPUtil.paramCheck(request.getParameter("attach_no")            	)//attach_no
		, JSPUtil.paramCheck(request.getParameter("dept")                   )
		, JSPUtil.paramCheck(request.getParameter("pr_location")            )
		, JSPUtil.paramCheck(request.getParameter("industry_type")          )
		, JSPUtil.paramCheck(request.getParameter("business_type")          )
		, JSPUtil.paramCheck(cur_date                                       )
		, JSPUtil.paramCheck(cur_time                                       )
		, JSPUtil.paramCheck(user_id                                        )
//		, JSPUtil.paramCheck(status                                         )
//		, JSPUtil.paramCheck(house_code                                     )
		, JSPUtil.paramCheck(request.getParameter("company_code")           )
		, JSPUtil.paramCheck(request.getParameter("plant_code")             )
		, JSPUtil.paramCheck(request.getParameter("old_pr_location")        )
	};
	
	String[] args1 = {			
		  JSPUtil.paramCheck(request.getParameter("address_loc")            )
		, JSPUtil.paramCheck(request.getParameter("address_eng")            )
		, JSPUtil.paramCheck(request.getParameter("zip_code")               )
		, JSPUtil.paramCheck(request.getParameter("phone_no")               )
		, JSPUtil.paramCheck(request.getParameter("fax_no")                 )
		, JSPUtil.paramCheck(request.getParameter("ceo_name_loc")           )
//		, JSPUtil.paramCheck(house_code                                     )
		, JSPUtil.paramCheck(plant_code                                     )
		, JSPUtil.paramCheck("4"                                            )
	};

	Object[] obj = {args, args1};

	String nickName= "AD_118";
	String conType = "TRANSACTION";
	String MethodName = "setChange";
	sepoa.fw.srv.SepoaOut value = null;
	SepoaRemote remote = null;
	
	try {
		remote = new SepoaRemote(nickName, conType,info);
		value = remote.lookup(MethodName, obj);
	}catch(SepoaServiceException wse) {
		Logger.err.println(info.getSession("ID"),request, "wse = " + wse.getMessage());
	}catch(Exception e) {
		Logger.err.println(info.getSession("ID"),request, "e = " + e.getMessage());
	}finally{
		try{
			remote.Release();
		}catch(Exception e){}
	}	
%>
<%-- [{
	"status":"<%=value.status%>"
}] --%>

<Script language="javascript">
(function Init()
{
	if("<%=value.status%>" == "1")
	{
		//alert("공장단위가 수정되었습니다.");
		alert("<%=text.get("AD_119.MSG_0120")%>");
		//parent.location.href = "factory_unit.jsp";
		location.href = "factory_unit.jsp";
	}else alert ("error");
})();
</script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html> -->