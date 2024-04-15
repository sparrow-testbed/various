<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ page import="java.util.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.db.*"%>
<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.fw.cfg.*"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%@ include file="/include/sepoa_common.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ include file="/include/code_common.jsp"%>
<%
	String opcode           = request.getParameter("opcode");
    String subject          = request.getParameter("subject")           == null ? "" : request.getParameter("subject");
    String contents         = request.getParameter("contents")          == null ? "" : request.getParameter("contents");
    String user_name_loc    = request.getParameter("user_name_loc")     == null ? "" : request.getParameter("user_name_loc");
    String user_id          = request.getParameter("user_id")           == null ? "" : request.getParameter("user_id");
    String user_type        = request.getParameter("user_type")         == null ? "" : request.getParameter("user_type");
    String COMPANY          = request.getParameter("COMPANY")           == null ? "" : request.getParameter("COMPANY");
    String dept             = request.getParameter("dept")              == null ? "" : request.getParameter("dept");
    String dept_name_loc    = request.getParameter("dept_name_loc")     == null ? "" : request.getParameter("dept_name_loc");
    String to_company_code  = request.getParameter("to_company_code")   == null ? "" : request.getParameter("to_company_code");
    String to_company_name  = request.getParameter("to_company_name")   == null ? "" : request.getParameter("to_company_name");
%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("EM_001");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info, multilang_id);
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>


<%@ include file="/include/include_css.jsp"%>

<script language="javascript">

function init() {
    chageChoice();

    if ("<%=opcode%>" == "U") {
       setTo('<%=user_id%>','<%=user_type%>','<%=COMPANY%>','<%=user_name_loc%>','<%=dept%>','<%=dept_name_loc%>','<%=to_company_code%>','<%=to_company_name%>');
    }
}

function create_pop()
{
	//임시 - 글 등록되는지 확인하기 위해 임시 값 넣음(두 사람 선택한 경우)
/* 	
	form1.users.value = "NISY;SK1282;";
	form1.depts.value = "1000;NISY;PCT;염홍열;@1000;SK1282;PCT;박상길;@";
	form1.user_types.value = "1000;1000;";
	form1.dept.value = "PCT;PCT;";
	form1.dept_names.value = "생산지원팀;생산지원팀;";
	form1.companies.value = "1000;1000;";
	form1.company_names.value = "CAP;CAP;";
	form1.company_names1.value = "염홍열;박상길;";

	form1.companies.value = "1000;NISY;PCT;염홍열;@1000;SK1282;PCT;박상길;@";
	
	return; */
	
	
    var url = "mail_pp_ins2.jsp";
    var width = 1012;
    var height = 410;
    var left = 100;
    var top = 150;

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'no';
    var resizable = 'no';
    var help = window.open( url, 'create_pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

    function setTo(USER, USER_NAME, USER_TYPE, DEPT, DEPT_NAME, COMPANY_CODE, COMPANY_NAME)
	{
		linecount = 0;
		DEPT_SELECTED		= "";
		DEPT_NAME_SELECTED	= "";
		USER_SELECTED		= "";
		USER_NAME_SELECTED	= "";
		USER_TYPE_SELECTED	= "";
		USER_TYPE_SELECTED1	= "";
		COMPANY_CODE_SELECTED = "";
		COMPANY_NAME_SELECTED = "";
		DEPTDATA 			= "";

		USER_TYPE_SELECTED1 += USER_TYPE + ";";
		DEPTDATA += COMPANY_CODE + ";" + USER + ";"  + DEPT +";" + USER_TYPE + ";" ;
		DEPTDATA += "@";
		USER_SELECTED += USER + ";";
		USER_NAME_SELECTED += USER_NAME + ";";
		USER_TYPE_SELECTED += USER_TYPE + ";";
		DEPT_SELECTED += DEPT + ";";
		DEPT_NAME_SELECTED += DEPT_NAME + ";";
		COMPANY_CODE_SELECTED += COMPANY_CODE + ";";
		COMPANY_NAME_SELECTED += COMPANY_NAME + ";";

		SetMailRecevingUser(USER_SELECTED,DEPTDATA,USER_NAME_SELECTED,USER_TYPE_SELECTED1,DEPT_SELECTED,DEPT_NAME_SELECTED,COMPANY_CODE_SELECTED,COMPANY_NAME_SELECTED);

	}

function SetMailRecevingUser(users, depts,user_names,user_types,dept,dept_names,company_codes, company_names )
{
	//alert(users+","+ depts+","+user_names+","+user_types+","+dept+","+dept_names+","+company_codes+","+ company_names);

	form1.users.value = users;
	form1.depts.value = depts;
	form1.user_types.value = user_types;
	form1.dept.value = dept;
	form1.dept_names.value = dept_names;
	form1.companies.value = company_codes;
	form1.company_names.value = company_names;
	form1.company_names1.value = user_names;

	form1.companies.value = depts;

}

function Create()
{
    var opcode = "<%=opcode%>";

    if (LRTrim(document.form1.subject.value) == "")
    {
        //alert("제목은 필수 입력입니다.");
        alert("<%=text.get("EM_001.TEXT_001")%>");
        return;
    }

    var value = document.forms[0].choice.value;
    if (value == "S") {
        if (LRTrim(document.form1.companies.value) == "") {
            //alert("수신처는 필수 입력입니다.");
            alert("<%=text.get("EM_001.TEXT_002")%>");
            return;
        }
    }
    /*
    var url = "";
    
    if (opcode == "U") {
        url = url + "mail_wk_write1.jsp?returnView=mail_bd_get1.jsp";
    } else {
        url = url + "mail_wk_write1.jsp?returnView=mail_bd_write1.jsp";
    }

     document.form1.method = "POST";
    document.form1.target = "work";
    document.form1.action = url;
    document.form1.submit(); */
    
    var returnViewUrl = "";
    if (opcode == "U") {
    	returnViewUrl = "mail_bd_get1.jsp";
    } else {
    	returnViewUrl = "mail_bd_write1.jsp";
    }
    
	var jqa = new jQueryAjax();
	jqa.action = "mail_wk_write1.jsp";
	jqa.data = "returnView="+returnViewUrl;
	jqa.submit();

}

function Cancel()
{
    //정말로 취소 하시겠습니까?
    if (confirm("<%=text.get("EM_001.TEXT_003")%>") == true)
    {
        document.form1.action = "mail_bd_write1.jsp";
        document.form1.submit();
    }
}

function attachfiles()
{
    if (document.forms[0].file.value == "")
    FileAttach('MAIL','','');
    else     FileAttachChange('MAIL',document.forms[0].file.value);

}

function setAttach(attach_key, arrAttrach, attach_count) {


    var attachfilename  = arrAttrach + "";
    var result 			="";

	var attach_info 	= attachfilename.split(",");

	for (var i =0;  i <  attach_count; i ++)
    {
	    var doc_no 			= attach_info[0+(i*7)];
		var doc_seq 		= attach_info[1+(i*7)];
		var type 			= attach_info[2+(i*7)];
		var des_file_name 	= attach_info[3+(i*7)];
		var src_file_name 	= attach_info[4+(i*7)];
		var file_size 		= attach_info[5+(i*7)];
		var add_user_id 	= attach_info[6+(i*7)];

		if (i == attach_count-1)
			result = result + src_file_name;
		else
			result = result + src_file_name + ",";
	}

	document.forms[0].ATTACH_NO.value = attach_key;
	document.forms[0].chumbu.value = result;

}

function chageChoice() {
    var value = document.forms[0].choice.value;
	
    if (value == "S") {// 수신자 지정
        document.forms[0].user_names.style.visibility   = "visible";
//        document.forms[0].butt_add.style.visibility     = "visible";
//        document.forms[0].butt_add.width                = 0;

    } else { //전체
        document.forms[0].companies.value               = "hidden";
        document.forms[0].user_names.style.visibility   = "hidden";
//        document.forms[0].butt_add.style.visibility     = "hidden";
//        document.forms[0].butt_add.width                = 0;
    }

}

</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init()">
<s:header>
<form name="form1"  method="post">
<input type="hidden" name="SHIPPER_TYPE" id="SHIPPER_TYPE" value = "D">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/include_top.jsp"%>
	<tr>
		<td height="100%" valign="top">
		<table height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<%@ include file="/include/include_menu.jsp"%>

				<td width="10" height="100%" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_left.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="10" height="100%"></td>
				<td width="100%" align="center" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_top.gif); background-repeat:repeat-x; background-position:top; padding:5px;word-breakbreak-all">
				<table width="98%" border="0" cellspacing="0" cellpadding="0">

				<%@ include file="/include/sepoa_milestone.jsp"%>
<!------------------------------------------------------------------------------>
       <table width="100%" border="0" cellspacing="0" cellpadding="0">
	       <tr>
		        <td height="5"></td>
			          </tr>

          <tr>
            <td height="40"><table border="0" cellspacing="3" cellpadding="0">
                <tr>
					<TD><script language="javascript">btn("javascript:Create()","<%=text.get("BUTTON.insert")%>")</script></td>
                    <td><script language="javascript">btn("javascript:Cancel()", "<%=text.get("BUTTON.cancel")%>")</script></td>
	            </tr>
            </table></td>
          </tr>
        </table><!------------------------------------------------------------------------------>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr><td>
                 <input type="hidden" name="depts" id="depts">
			     <input type="hidden" name="users" id="users">
			     <input type="hidden" name="user_types" id="user_types">
			     <input type="hidden" name="user_names" id="user_names">
			     <input type="hidden" name="dept" id="dept">
			     <input type="hidden" name="dept_names" id="dept_names">
			     <input type="hidden" name="file" id="file">
          </td></tr>
          <tr>
            <td>
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <tr>
                  <td width="100%">
                  
                  <table width="100%" cellpadding="0" cellspacing="0" border="0">

                      <tr>
                        <td align="center">
                        
                        <table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				    <tr>
				      <td class="div_input_re" width="15%"><div align="center">
				        <%=text.get("EM_001.1001")%></div>
				      </td>
				      <td class="div_data" align="left">
				        <input type="text" name="subject" id="subject" class="inputsubmit" size=63 value="<%=subject%>">
				      </td>
				    </tr>
				    <tr>
				      <td class="div_input_re"><div align="center">
						<%=text.get("EM_001.1002")%></div>
					     </td>
				   	<td class="div_data" align="left">
						 <table><tr>
						 <td>
						 	<input type="text" name="company_names1" id="company_names1" class="inputsubmit" size="60" readonly >
			     		</td>
			     		<td>
					    <input type="hidden" name="choice" id="choice" class="inputsubmit" size="60" readonly value="S">
					    <input type="hidden" name="company_names" id="company_names" class="inputsubmit" size="60" readonly >
					    <input type="hidden" name="companies" id="companies" class="inputsubmit" size="63" readonly value=" ">
					    </td><td>
					    	<script language="javascript">btn("javascript:create_pop()","<%=text.get("EM_001.MESSAGE_RECEIVE")%>")</script>
					    <%-- 	<a href="javascript:create_pop()"><img name="butt_add" src="../images/butt_add_book.gif" align="absmiddle" border="0" width="0" height="0"></a>	--%>
					    </td></tr></table>
				    </td>
				    </tr>
				    <tr>
				      <td class="div_input" width="15%"><div align="center">
				        <%=text.get("EM_001.1003")%></div>
				      </td>
				      <td class="div_data" width="85%">
				        <TABLE >
		      			<TR>
		      				<td><input type="text" name="chumbu" id="chumbu" class="inputsubmit" size="80" readonly"></td>
							<td><input type="hidden" name="ATTACH_NO" id="ATTACH_NO"><!--  attach_key     --></td>
					        <td><script language="javascript">btn("javascript:attach_file(document.forms[0].ATTACH_NO.value,'MAIL')","<%=text.get("BUTTON.add-file")%>")</script></td>
	    	  			</TR>
      					</TABLE>
				      </td>
				    </tr>
				  </table>
				  <table width="100%" cellpadding="0" cellspacing="0" border="0">
				    <tr align="center">
						<td class="jtable_bottom1" colspan="2">
							<textarea name="text1" id="text1" class="inputsubmit" cols="10" style="width:100%" rows="25"></textarea>
						</td>
					</tr>
				   </table></td>
               </tr>
                      <%-- <%@ include file="/include/include_bottom.jsp"%> --%>
                  </table>
                 </td>
                </tr>
            </table></td>
          </tr>
    </table>    
</table>

</form>
<!-- <iframe name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe> -->
</s:header>
<s:footer/>
</body>

</html>
