<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%/* Alice Editer Object css&js */%>
<link rel="stylesheet" type="text/css" HREF="/css/alice/alice.css">
<link rel="stylesheet" type="text/css" HREF="/css/alice/oz.css">
<%@ include file="/include/alice_scripts.jsp"%>
<%/* Alice Editer Object 생성테그 */%>
<script type="text/javascript">
var alice;
Event.observe(window, "load", function() {
	alice = Web.EditorManager.instance("CONTENT",{type:'detail',width:'100%',height:'100%',family:'돋움',size:'12px'});
});	
</script>
<%
    Vector multilang_id = new Vector();
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("FQ_001");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info, multilang_id);

	//HTML에 쓰일 변수들
	String TITLE = String.valueOf(text.get("FQ_001.MSG_0104"));// "Q&A 작성";

	String load_flag = JSPUtil.CheckInjection( request.getParameter( "load_flag" ) ); // 'Y'는 저장 후 로드일 경우
	String con_type = JSPUtil.CheckInjection( request.getParameter( "con_type" ) ); // 'N'은 공지사항, 'Q'는 Q&A
	if(con_type == null) con_type = "";

	String SUBJECT = "";
    String CONTENT = "";
    String ATTACH_NO = "";
	String FILE_NAME = "";
		
	if( "Y".equals(load_flag) ) {
		response.sendRedirect("faq_list_new.jsp");
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>
<script language="javascript">
function init(){
	
}

function Create(){
	var F=document.forms[0];

	if (LRTrim(F.SUBJECT.value) == ""){
		//alert("제목은 필수 입력입니다.");
		alert("<%=text.get("FQ_001.MSG_0100")%>");
		
		return;
	}
	
	if (LRTrim(F.VIEW_USER_TYPE.value) == "") {
		alert("사용자구분을 선택해주십시오.");
		F.VIEW_USER_TYPE.focus();
		
		return;
	}
	
	F.CONTENT.value = alice.getContent(); //aclie작성한 HTML내용을 CONTENT에 넣기
	
	if (LRTrim(F.CONTENT.value) == ""){
		//alert("내용을 입력하세요.");
		alert("<%=text.get("FQ_001.MSG_5000")%>");
		
		return;
	}
	
 	var con_type = "<%=con_type%>";
 	
 	F.method = "POST";
    F.target = "childFrame";
    F.action = "faq_write_wk_new.jsp?con_type="+con_type;
    F.submit();
    
    <%--
 	var jqa = new jQueryAjax();
 	
	jqa.action = "faq_write_wk_new.jsp";
	//jqa.data = "con_type="+con_type+"&CONTENT="+F.CONTENT.value+"&pop_chk="+F.pop_chk.checked;
	jqa.data = "con_type="+con_type+"&CONTENT="+F.CONTENT.value;
	jqa.submit();
	--%>    
}


function pop_Chk_Changed(){
	var chk=document.form1.pop_chk.checked;
	
	<%String from_date = SepoaDate.getShortDateString();%>
	
	if(chk){
		document.form1.from_date.disabled=false;
		document.form1.to_date.disabled=false;
		document.form1.from_date.value="<%=SepoaString.getDateSlashFormat(from_date)%>";
		document.form1.to_date.value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(from_date,1))%>";
	}
	else{
		document.form1.from_date.disabled=true;
		document.form1.to_date.disabled=true;
		document.form1.from_date.value="";
		document.form1.to_date.value="";
	}
}

function Cancel(){
    if(!confirm("<%=text.get("FQ_001.MSG_0101")%>"))//취소 하시겠습니까?
    	return;
	var con_type = "<%=con_type%>";
    go_list('/admin/faq_list_new.jsp', 'MUO140100005', 7, '');
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
	document.forms[0].FILE_NAME.value = result;

}

function getHeight(){
	var height = document.body.clentHeight;
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


</script>
</head>
<body leftmargin="15" topmargin="6" >
<s:header>
	<form name="form1"  method="post">
		<input type="hidden" name="SHIPPER_TYPE" id="SHIPPER_TYPE" value = "D"/>
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
							<td style="padding:5 5 5 0" align="right">
								<TABLE cellpadding="2" cellspacing="0">
									<TR>
										<TD>
<script language="javascript">
btn("javascript:Create()","<%=text.get("BUTTON.insert")%>");
</script>
										</td>
										<td>
<script language="javascript">
btn("javascript:Cancel()", "<%=text.get("BUTTON.cancel")%>");
</script>
										</td>
									</TR>
								</TABLE>
							</td>
						</TR>
						<tr>
							<td height="5"> </td>
						</tr>
					</TABLE>      
					<table width="100%" border="0" cellspacing="0" cellpadding="1">
						<tr>
							<td>
								<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
									<tr>
										<td width="100%">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="15%" class="title_td">
														&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("FQ_001.MSG_0102")%>
													</td>
													<td class="data_td">
														<input type="text" name="SUBJECT" id="SUBJECT" class="inputsubmit" style="width:70%">
													</td>
												</tr>
												<tr>
													<td colspan="4" height="1" bgcolor="#dedede"></td>
												</tr>
												<tr>
													<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("FQ_001.MSG_8801")%></td>
										            <td class="data_td">
											        	<select name="VIEW_USER_TYPE" id="VIEW_USER_TYPE" class="input_re">
													 		<option value=""></option>
															<%
																String VIEW_USER_TYPE = ListBox(request, "SL0018" , info.getSession("HOUSE_CODE")+"#"+"Z001", "X");
																out.println(VIEW_USER_TYPE);
															%>
														</select>
											    </td>
												</tr>
												<tr>
													<td colspan="4" height="1" bgcolor="#dedede"></td>
												</tr> 
												<tr>
										        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("FQ_001.MSG_0103")%></td>
										            <td class="data_td">
														 <TABLE >
										      			<TR>
										      				<td>
										      				<script language="javascript">
																function setAttach(attach_key, arrAttrach, rowId, attach_count) {
																	document.getElementById("ATTACH_NO").value = attach_key;
																	document.getElementById("ATTACH_NO_COUNT").value = attach_count;
																}
																	
																btn("javascript:attach_file(document.getElementById('ATTACH_NO').value, 'TEMP');", "파일등록");
															</script>
										      				</td>
										      				<td>
																<input type="text" size="3" readOnly class="input_empty" value="0" name="ATTACH_NO_COUNT" id="ATTACH_NO_COUNT"/>
																<input type="hidden" value="" name="ATTACH_NO" id="ATTACH_NO">
															</td>
										      				<%-- <td><input type="text" name="FILE_NAME" id="FILE_NAME" class="inputsubmit" size="80" readonly"></td>
															<td><input type="hidden" name="ATTACH_NO" id="ATTACH_NO"><!--  attach_key     --></td>
													        <td><script language="javascript">btn("javascript:attach_file(document.forms[0].ATTACH_NO.value,'NOT')","<%=text.get("BUTTON.add-file")%>")</script></td> --%>
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
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr align="center">
							<td class="jtable_bottom1"></td>
						</tr>
					</table>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr align="center">
							<td >
								<textarea name="CONTENT" id="CONTENT" class="inputsubmit" cols="10" style="width:99%;height:650px;" rows="30"></textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:footer/>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>