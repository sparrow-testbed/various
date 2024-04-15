<%@ page contentType = "text/html; charset=UTF-8" %>
<%if ("MUP150200001".equals( info.getSession("MENU_PROFILE_CODE"))  || "1".equals( info.getSession("BD_ADMIN"))  ){%>
<%
    tot_cnt_string = "";
    tot_cnt = 0;
    pg_row = 5;
    rec_cnt = 0;
    String rpt_no    = JSPUtil.nullToRef(request.getParameter("faq_page"),"1");
    flag     = JSPUtil.nullToEmpty(request.getParameter("flag"));
    gubun    = JSPUtil.nullToEmpty(request.getParameter("gubun"));
    quest    = JSPUtil.nullToEmpty(request.getParameter("quest"));
    search   = JSPUtil.nullToEmpty(request.getParameter("search"));    
    con_type = JSPUtil.nullToRef(request.getParameter("con_type"),"Q");	// 'N'은 공지사항, 'Q'는 Q&A

    cnt      = JSPUtil.nullToEmpty(request.getParameter("cnt"));
    
    if (cnt.equals("")) cnt = "1";
    
    quest = quest.replaceAll("'","");
    quest = quest.replaceAll("&","");
    quest = quest.replaceAll("--","");

    rw_cnt =0 ;
    bg_class = "";
    
    module = "01";  // 01 : 국내사용자, 02 : 국외사용자

    Object[] obj5 = {rpt_no, String.valueOf(pg_row), gubun, quest, search, con_type}; // "M" 은 PR자료
    
    wf2_N = null;
    wf3_N = null;
%>
<script language="JavaScript">
function goRpt(seq){
	/*
	var module = "01"; // 01 : 국내사용자, 02 : 국외사용자
	var con_type = "<%=con_type%>";
	var url="/intro/sub/faq_view.jsp?seq="+seq+"&module="+module+"&con_type="+con_type+"&search=N";
	var width = 750;
	var height =750;
	var left = 0;
	var top = 0;
	var windowW = width;
	var windowH = height;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'no';
	var scrollbars = 'no';
	var resizable = 'no';
	var library = window.open( url, 'faq', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	*/
	var url = "/admin/rpt_list_popup_new_index.jsp?seq="+seq;

	CodeSearchCommon(url,'bulletin_list_popup_new','0','0','700','600');
}

function goList() {
	var con_type = "<%=con_type%>";
	location.href = "faq_list.jsp?con_type="+con_type;
}
    
function Create(){
	var con_type = "<%=con_type%>";
	location.href = "faq_bd_ins1.jsp?con_type="+con_type
}
    
function goNotice(flag) {
	var url="/intro/sub/faq_list.jsp?search=Y&con_type="+flag;
	var ret  = window.open( url, 'faq', 'left=0, top=0, width=750, height=700, toolbar=no, menubar=no, status=no, scrollbars=no, resizable=no');
}

function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}

function fnRptList(){
	var width  = '850';
	var height = '450';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];
	var url    = "/common/index_buyer_rpt_pop.jsp";
	var name   = "FAQ";
	var option = "top="+top+",left="+left+",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=yes";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}

</script>
<form name="faqfrm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="title_summary" onclick="fnRptList()" style="cursor:hand" >고객의 소리</td>
		</tr>
		<tr>
			<td align="left" bgcolor="#d9d9d9" class="td_line"><img src="/images/line_summary.gif" width="48" height="3"></td>
		</tr>
		<tr>
			<td valign="top">
				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">          
					<tr>
						<td width="5%" height="29" align="center" class="title_article"  bgcolor="#dddee1"> 번호</td>
						<td width="20%" align="center" class="title_article"  bgcolor="#dddee1">구분</td>													
						<td width="27%" align="center" class="title_article"  bgcolor="#dddee1">제목</td>
						<td width="15%" align="center" class="title_article"  bgcolor="#dddee1">공급사</td>
						<td width="9%" align="center" class="title_article"  bgcolor="#dddee1">글쓴이</td>
						<td width="8%" align="center" class="title_article"  bgcolor="#dddee1">파일첨부</td>
						<td width="8%" align="center" class="title_article"  bgcolor="#dddee1">날짜</td>
						<td width="8%" align="center" class="title_article"  bgcolor="#dddee1">시간</td>									
					</tr>
<%
	try {
		SepoaOut value15 = ServiceConnector.doService(info, "CO_004", "CONNECTION", "getQuery_MAINRPT", obj5);
    	wf2_N = new SepoaFormater(value15.result[0]);
    	wf3_N = new SepoaFormater(value15.result[1]);

    	rw_cnt = wf3_N.getRowCount();

		tot_cnt = Integer.parseInt(wf2_N.getValue(0,0));
		tot_cnt_string = wf2_N.getValue(0,0);

		if(rw_cnt == 0) {
%>
					<tr>
						<td height="1" colspan="6" align="center" bgcolor="#dddddd"></td>
					</tr>
					<tr>
						<td align="center"  colspan="6">게시물이 없습니다.</td>
					</tr>
<%
		}
		else{
			for(int i=0; i<rw_cnt; i++){
				String subject = wf3_N.getValue(i,2);
				
				subject = subject.length() > 30 ? subject.substring(0,30)+"(생략)..." : subject ;					
%>
					<tr>
						<td height="1" colspan="6" align="center" bgcolor="#dddddd"></td>
					</tr>
					<tr>
						<td  height="28" align="center" class="lin01"><%=wf3_N.getValue(i,0)%></td>
						<td align="left" class="lin01">
							<%=wf3_N.getValue(i,12)%>
						</td>
						<td  class="pad02 lin01">
							<a href="javascript:goRpt('<%=wf3_N.getValue(i,1)%>');">
								<%=subject%>
							</a>
						</td>
						<td align="center" class="lin01">
							<%=wf3_N.getValue(i,9)%>
						</td>
						<td align="center" class="lin01">
							<%=wf3_N.getValue(i,3)%>
						</td>
						<td align="center" class="lin01">
<%
				if(wf3_N.getValue(i,6).equals("Y")) {
%>
							<a href="javascript:fnFiledown('<%=wf3_N.getValue(i,7)%>');" onfocus="this.blur()">
								<img src="/images/ico_file.gif"/>
							</a>
<%-- 							<a href="javascript:rMateFileAttach('P','R','NOTIC','<%=wf3_N.getValue(i,7)%>');" onfocus="this.blur()"> --%>
<!-- 								<img src="/images/ico_file.gif"/> -->
<!-- 							</a> -->
<%
				}
%>		
							&ensp;
						</td>
						<td  align="center"  class="article_date">
							<%=wf3_N.getValue(i,4)%>
						</td>
						<td  align="center"  class="lin01">
							<%=wf3_N.getValue(i,8)%>
						</td>
					</tr>
<%
			}
		}
	}
	catch(Exception e){
		Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
		Logger.dev.println(e.getMessage());
	}
	finally{
		wr.Release();
	} // finally 끝
%>
					<tr>
						<td height="1" colspan="6" align="center" bgcolor="#dddddd"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<input type="hidden" name="faq_page" value="<%=rpt_no%>">
</form>
<%-- 
<table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF" style="border-collapse:collapse;">
	<TR>
		<TD align="center" class="c_data_1_p_c">
<% 
	out.println(getPage_html(tot_cnt, pg_row, Integer.parseInt(rpt_no), "Q")); //페이지 번호
%> 
		</TD>
	</TR>
</table>
--%>
<%}else{ %>
<script language="JavaScript">
	alert("비정상 경로 접근 입니다.");
	self.close();
</script>
<%} %>