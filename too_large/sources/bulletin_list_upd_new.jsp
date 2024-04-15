<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	String SEQ = JSPUtil.nullToEmpty(request.getParameter("select_seq"));

	Vector multilang_id = new Vector();
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MT_014");
	multilang_id.addElement("MT_015");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
%>

<%
	//HTML에 쓰일 변수들
	String TITLE = String.valueOf(text.get("MT_014.MSG_0105"));//"공지사항 수정";
%>


<%/* Alice Editer Object css&js */%>
<link rel="stylesheet" type="text/css" HREF="../css/alice/alice.css">
<link rel="stylesheet" type="text/css" HREF="../css/alice/oz.css">

<%@ include file="/include/alice_scripts.jsp"%>

<%/* Alice Editer Object 생성테그 */%>
<script type="text/javascript">
var alice;
Event.observe(window, "load", function() {
	alice = Web.EditorManager.instance("CONTENT",{type:'detail',width:'100%',height:'100%',family:'돋움',size:'12px'});
});
</script>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
	
	

	<%@ include file="/include/code_common.jsp"%>
    <%@ include file="/include/include_css.jsp"%>
    <script language=javascript src="../js/lib/sec.js"></script>
    <%@ include file="/include/sepoa_scripts.jsp"%>
    

    <script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
    <script language="javascript">

//<!--

function Update()
{
	var F=document.forms[0];
	if (LRTrim(F.SUBJECT.value) == "")
	{
		//alert("제목은 필수 입력입니다.");
		alert("<%=text.get("MT_014.MSG_0103")%>");
		return;
	}
	
	if (LRTrim(F.VIEW_USER_TYPE.value) == "") {
		alert("사용자구분을 선택해주십시오.");
		F.VIEW_USER_TYPE.focus();
		
		return;
	}

	F.CONTENT.value = alice.getContent(); //aclie작성한 HTML내용을 CONTENT에 넣기


	if (LRTrim(F.CONTENT.value) == "")
	{
		//alert("내용은 필수 입력입니다.");
		alert("<%=text.get("MT_014.5000")%>");
		return;
	}

    F.method = "POST";
    F.target = "child_Work1";
    F.action = "bulletin_list_wk_upd_new.jsp?SEQ=<%=SEQ%>";

    F.submit();
    
    
    <%-- 
	var jqa = new jQueryAjax();
	jqa.action = "bulletin_list_wk_upd_new.jsp";
	jqa.data = "SEQ=<%=SEQ%>&CONTENT="+F.CONTENT.value;
	jqa.submit();
	--%>
}

function Cancel()
{
    if(!confirm("<%=text.get("MT_014.MSG_0104")%>"))//취소 하시겠습니까?
		return;

   	location.href = "bulletin_list_new.jsp";
}

/*
LEFT 메뉴 클릭시 페이지 이동하는 것과 같은 기능
url : jsp 경로
topMenuCode : 탑메뉴코드
topMenuSeq : 탑메뉴시퀀스
param : 파라미터
*/
function go_list(url, topMenuCode, topMenuSeq, param) {
	topMenuClick(url, topMenuCode, topMenuSeq, param);
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

	document.forms[0].ATTACH_NO.value     	= attach_key;
	document.forms[0].ATTACH_TITLE.value 	= result;
}
//첨부파일 추가하는 함수 끝



//-->

function pop_Chk_Changed(){
	var chk=document.form1.pop_chk.checked;
	<%String from_date = SepoaDate.getShortDateString();%>
	if(chk){
		document.form1.from_date.disabled=false;
		document.form1.to_date.disabled=false;
		document.form1.from_date.value="<%=SepoaString.getDateSlashFormat(from_date)%>";
		document.form1.to_date.value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(from_date,1))%>";
	}else{
		document.form1.from_date.disabled=true;
		document.form1.to_date.disabled=true;
		document.form1.from_date.value="";
		document.form1.to_date.value="";
	}
}
</script>


<%
    Object[] obj = {SEQ};

	SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION","getQuery_NOTICE_POP_New", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	//DB에서 받아올값들 초기화
    String SUBJECT = "";
    String COMPANY_CODE = "";
    String CONTENT = "";
    String ATTACH_NO = "";
	String FILE_NAME = "";
    String GONGJI_GUBUN = "";
    String GONGJI_GUBUN_DESC = "";
    String DEPT_TYPE = "";
    String FROM_DATE = "";
    String TO_DATE = "";
    String VIEW_USER_TYPE = "";

	if(wf.getRowCount() > 0) {
        for(int i=0;i<wf.getRowCount();i++){
            SUBJECT 	= JSPUtil.nullToEmpty(wf.getValue("SUBJECT",i));
            SEQ 		= JSPUtil.nullToEmpty(wf.getValue("SEQ",i));
            COMPANY_CODE= JSPUtil.nullToEmpty(wf.getValue("COMPANY_CODE",i));
//            CONTENT 	= JSPUtil.nullToEmpty(wf.getValue("CONTENT",i));
            ATTACH_NO 	= JSPUtil.nullToEmpty(wf.getValue("ATTACH_NO", i));
            GONGJI_GUBUN 	= JSPUtil.nullToEmpty(wf.getValue("GONGJI_GUBUN", i));
            GONGJI_GUBUN_DESC 	= JSPUtil.nullToEmpty(wf.getValue("GONGJI_GUBUN_DESC", i));
            DEPT_TYPE 	= JSPUtil.nullToEmpty(wf.getValue("DEPT_TYPE_CODE", i));
            FROM_DATE	= JSPUtil.nullToEmpty(wf.getValue("PUBLISH_FROM_DATE", i));
            TO_DATE	= JSPUtil.nullToEmpty(wf.getValue("PUBLISH_TO_DATE", i));
            VIEW_USER_TYPE	= JSPUtil.nullToEmpty(wf.getValue("VIEW_USER_TYPE", i));
            
        }
    }
	boolean date_flag=false;
	if(!FROM_DATE.equals("") && !TO_DATE.equals("")){
		date_flag=true;
	}
    
    wf = new SepoaFormater(value.result[2]);  //공지사항 내용

    for(int i = 0; i < wf.getRowCount(); i++)
    {
    	CONTENT += wf.getValue("CONTENT", i);
    }

    String s = value.result[1].toString();

	if(value.result[1]!=null && !s.equals("")){
		SepoaFormater wf2 = new SepoaFormater(value.result[1]);
		if(wf2.getRowCount() > 0) {
		    for(int i=0;i<wf2.getRowCount();i++){
		        if (i == wf2.getRowCount()-1)
					FILE_NAME 	+= JSPUtil.nullToEmpty(wf2.getValue("SRC_FILE_NAME",i));
				else
					FILE_NAME 	+= JSPUtil.nullToEmpty(wf2.getValue("SRC_FILE_NAME",i))+",";
		    }
		}
    }

%>


</head>

<body leftmargin="15" topmargin="6">
<s:header>
<form name="form1"  method="post">
<input type="hidden" name="SHIPPER_TYPE" iod="SHIPPER_TYPE" value = "D">
<input type="hidden" name=COMPANY_CODE id="COMPANY_CODE" value="<%=info.getSession("COMPANY_CODE")%>">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
   	 	<td height="5"> </td>
  </tr>
  <tr>
    <td width="100%" valign="top">
		<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
			<TR>
				<td style="padding:5 5 5 0">
				<TABLE cellpadding="2" cellspacing="0">
					  <TR>
						<td><script language="javascript">btn("javascript:Update();", "<%=text.get("BUTTON.update")%>")</script></td>
                    	<td><script language="javascript">btn("javascript:Cancel();", "<%=text.get("BUTTON.cancel")%>")</script></td>
	            	  </TR>
				    </TABLE>
			  </td>
		  	</TR>
		  	<tr>
	    	 	<td height="5"> </td>
		  </tr>
		</TABLE>
       	<!-- header start -->      
         <table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
			<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
			<tr>
			<td width="100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_015.MSG_0102")%></td>
		            <td class="data_td">
			        <input type="text" name="SUBJECT" id="SUBJECT" class="inputsubmit"  value="<%=SUBJECT%>" style="width:98%">
			      </td>
			    </tr>
			    <tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
			    <tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_015.MSG_8801")%></td>
		            <td class="data_td">
			        	<select name="VIEW_USER_TYPE" id="VIEW_USER_TYPE" class="input_re">
							<option value=""></option>
							<%
								String lb1 = ListBox(request, "SL0018" , info.getSession("HOUSE_CODE")+"#"+"Z001", VIEW_USER_TYPE);
								out.println(lb1);
							%>
						</select>
			      </td>
			    </tr>   
			    <%-- <tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
			    <tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_015.MSG_0106")%></td>
		            <td class="data_td">
			        	 <select name="DEPT_TYPE" id="DEPT_TYPE" class="input_re">
							<option value=""></option>
								<%
									String country = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") +"#M216", DEPT_TYPE);
								     	out.println(country);
								%>
						</select>
			      </td>
			    </tr>     
			    <tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
			    <tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_015.gongji_gubun")%></td>
		            <td class="data_td">
						<select name="GONGJI_GUBUN" id="GONGJI_GUBUN" class="input_re">
								<%

									String gongji = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE") +"#M222", GONGJI_GUBUN);
								     	out.println(gongji);
								%>
						</select>	
			      </td>
			    </tr> 			    
			    <tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
			    <tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;팝업여부</td>
		            <td class="data_td">
						<%if(!date_flag){ %>
					     <input type="checkbox" name="pop_chk" id="pop_chk" onChange="javacsript:pop_Chk_Changed();">
					     <s:calendar id_to="to_date"  default_to="" id_from="from_date" default_from="" format="%Y/%m/%d" disabled="true"/>
					     <%}else{ %>
					     <input type="checkbox" name="pop_chk" id="pop_chk" onChange="javacsript:pop_Chk_Changed();" checked="checked">
					     <s:calendar id_to="to_date"  default_to="<%=SepoaString.getDateSlashFormat(TO_DATE) %>" id_from="from_date" default_from="<%=SepoaString.getDateSlashFormat(FROM_DATE) %>" format="%Y/%m/%d" disabled="false"/>
					     <%} %>
			      </td>
			    </tr>  --%>				    
			    <tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
                <tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_015.MSG_0103")%></td>
		            <td class="data_td">
						 <TABLE >
		      			<TR>
		      				<td><input type="text" name="ATTACH_TITLE" id="ATTACH_TITLE" class="inputsubmit" size="80" readonly value="<%=FILE_NAME%>"></td>
							<td><script language="javascript">btn("javascript:attach_file(document.forms[0].ATTACH_NO.value,'NOT')","<%=text.get("MT_014.0004")%>")</script></td>
		      				<td><input type="hidden" readonly name="ATTACH_NO" id="ATTACH_NO" value="<%=ATTACH_NO%>"></td>
	    	  			</TR>
      					</TABLE>
			      </td>
			    </tr> 	 
                </table>
				</td>
				</tr>
				</table>
				</td>
				</tr>
				</table>
	    <!-- header end  -->
	    
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
	      <tr align="center">
	 	 	 <td class="jtable_bottom1"></td>
	 	  </tr>
	    </table>
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
	      <tr align="center">
	 	 	 <td >
	 	 	 <textarea name="CONTENT" id="CONTENT" class="inputsubmit" cols="10" style="width:99%;height:100%" rows="30"><%=CONTENT%></textarea>
	 	 	 </td>
	 	  </tr>
	    </table>
	    
	 </td>
  </tr>
</table>

</form>
<iframe id="child_Work1" name="child_Work1" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
<!-- <iframe id="child_Work1" name="child_Work1" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe> -->
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=250"/>
</jsp:include> --%>
</s:header>
<s:footer/>
</body>
</html>