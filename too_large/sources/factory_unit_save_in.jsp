<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%> --%>
<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_119");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");

    String cur_date = SepoaDate.getShortDateString(); 
    String cur_time = SepoaDate.getShortTimeString(); 
    String status = "C"; 
%>

<%-- <html>
<head>
<title></title> --%>
<%
	String[] args = {
		//JspUtil.nullToEmpty(house_code                                 )
		  JSPUtil.paramCheck(request.getParameter("company_code")            )//company_code
		, JSPUtil.paramCheck(request.getParameter("plant_code")              )//plant_code
		//, JSPUtil.paramCheck(status                                          )//status
		, JSPUtil.paramCheck(request.getParameter("plant_name_loc")          )//plant_name_loc 
		, JSPUtil.paramCheck(request.getParameter("plant_name_eng")          )//plant_name_eng
		, JSPUtil.paramCheck(request.getParameter("country")                 )//country
		, JSPUtil.paramCheck(request.getParameter("dept")                    )//dept
		, JSPUtil.paramCheck(request.getParameter("logistics_area")          )//logistics_area
		, JSPUtil.paramCheck(request.getParameter("irs_no")                  )//irs_no
		, JSPUtil.paramCheck(request.getParameter("pr_location")             )//pr_location
		, JSPUtil.paramCheck(request.getParameter("industry_type")           )//industry_type
		, JSPUtil.paramCheck(request.getParameter("business_type")           )//business_type
		, JSPUtil.paramCheck(request.getParameter("biz_name_loc")            )//biz_name_loc
		, JSPUtil.paramCheck(request.getParameter("biz_name_eng")            )//biz_name_eng
		, JSPUtil.paramCheck(request.getParameter("attach_no")            	 )//attach_no
		, JSPUtil.paramCheck(cur_date                                        )//add_date
		, JSPUtil.paramCheck(cur_time                                        )//add_time
		, JSPUtil.paramCheck(user_id                                         )//add_user_id
		, JSPUtil.paramCheck(cur_date                                        )//change_date
		, JSPUtil.paramCheck(cur_time                                        )//change_time
		, JSPUtil.paramCheck(user_id                                         )//change_user_id
	};		
	String[] args1 = {		
//		  JspUtil.nullToEmpty(house_code                                     )
		  JSPUtil.paramCheck(request.getParameter("plant_code")              )//code_no
		, JSPUtil.paramCheck("4"                                             )//code_type
		, JSPUtil.paramCheck(request.getParameter("zip_code")                )//zip_code			
		, JSPUtil.paramCheck(request.getParameter("phone_no")                )//phone_no1
		, JSPUtil.paramCheck(request.getParameter("fax_no")                  )//fax_no
		, JSPUtil.paramCheck(request.getParameter("address_loc")             )//address_loc
		, JSPUtil.paramCheck(request.getParameter("address_eng")             )//address_eng
		, JSPUtil.paramCheck(request.getParameter("ceo_name_loc")            )//ceo_name_loc
	};

	String ins_flag = request.getParameter("dup_ins_flag");

	Object[] obj = {args, args1};
	String nickName   = "AD_118";
	String conType    = "TRANSACTION";
	String MethodName = "setInsertUpdate";
	
	if(ins_flag.equals("X"))
		MethodName = "setSave";
	
	sepoa.fw.srv.SepoaOut value = null;
	sepoa.fw.util.SepoaRemote ws = null;

	try 
	{
		ws = new sepoa.fw.util.SepoaRemote(nickName,conType,info);
		value = ws.lookup(MethodName, obj);
	}
	catch(SepoaServiceException wse)
	{
		Logger.err.println(info.getSession("ID"),this, " err = " + wse.getMessage());
	}
	catch(Exception e)
	{
		Logger.err.println(info.getSession("ID"),this, " err = " + e.getMessage());
	}
	finally
	{
		try
		{
			ws.Release();
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
		//alert("공장단위가 생성되었습니다.");
		alert("<%=text.get("AD_119.MSG_0119")%>");
		//parent.location.href = "factory_unit.jsp";
		location.href = "factory_unit.jsp";
	}
	else alert("error");
})();
</script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
 -->