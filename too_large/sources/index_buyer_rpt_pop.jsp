<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%if ("MUP150200001".equals( info.getSession("MENU_PROFILE_CODE"))  || "1".equals( info.getSession("BD_ADMIN")) ){%>
<%!
    public static String getStcTagParser(String str){
        String ws_result = "";
        
        if(str != null) {
            ws_result = SepoaString.replace(str,"--","");
            ws_result = SepoaString.replace(str,".0","");            
            ws_result = SepoaString.replace(ws_result,"<","&lt;");
            ws_result = SepoaString.replace(ws_result,">","&gt;");            
        }
        
        return ws_result;
    }

	public String TimeSubString(String str_time){
		String AH = "";
		String AM = "";
		String AFormat = "";

		if(str_time != ""){
			AH = str_time.substring(0,2);
			AM = str_time.substring(2,4);
			AFormat = AH+":"+AM;
		}
		
		return AFormat;
	}
	
	public String getPage_html(int tot_cnt, int pg_row, int now_pg, String type) {
		StringBuffer sb_html = new StringBuffer();
		int vw_pg_cnt = 5;                           //페이지당 선택할 htm 페이지 갯수([1],[2],[3],[4].....[10])
		int tot_pg_cnt = (tot_cnt/pg_row) + ((tot_cnt%pg_row) > 0 ? 1:0); //전체게시판Query되는 총 페이지 갯수 ( 전체row/한 화면의Row갯수)
		int prev_pg = now_pg - 1;                     //이전 페이지
		int next_pg = now_pg + 1;                     //다음 페이지
		int prev_pg_10 = 0;//now_pg - vw_pg_cnt;      //이전페이지 10
		int next_pg_10 = 0;//now_pg + vw_pg_cnt;      //다음페이지 10
		int vw_end_pg = 0;
		int vw_start_pg = 0; //보여줄 시작페이지

		if ((now_pg%vw_pg_cnt) == 0){
			vw_start_pg = now_pg - vw_pg_cnt + 1;
		}
		else{
			vw_start_pg = (now_pg/vw_pg_cnt) * vw_pg_cnt+1;
		}

		prev_pg_10 = vw_start_pg - vw_pg_cnt;         //이전 10페이지
		vw_end_pg  = ((vw_start_pg + vw_pg_cnt - 1) > tot_pg_cnt ? tot_pg_cnt : vw_start_pg + vw_pg_cnt - 1); //보여줄 마지막페이지
		next_pg_10 = ((tot_pg_cnt - vw_end_pg) > 0 ? vw_end_pg +1 : tot_pg_cnt); //다음 10페이지

		sb_html.append("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" height=\"30\" align=\"left\" >\n");
		sb_html.append("<tr>\n");
		sb_html.append("<td align=\"center\">\n");
	
		if(prev_pg_10 > 0){ //단위별 이동
			sb_html.append(" <a href=javascript:setPage_Change('").append(prev_pg_10).append("','").append(type).append("')><img src='/images/btn_first.gif' border='0' align='absmiddle'></a>&nbsp;");
		}
		
		if(prev_pg > 0){ //이전페이지 = 현재페이지-1
			sb_html.append(" <a href=javascript:setPage_Change('").append(prev_pg).append("','").append(type).append("')><img src='/images/btn_prev.gif' border='0' align='absmiddle'></a>&nbsp;\n");
		}
		
		for (int i = vw_start_pg; i <= vw_end_pg; i++) { //페이지 만큼 페이지 숫자생성
			if (((i - now_pg ) == 0) && (vw_end_pg > 1)) { //현재 페이지
				sb_html.append("<font color=#333333 style='font-size:8pt'>&nbsp;<span class='article_paging_sel'>").append(i).append("</span>&nbsp;</font>\n");
			}
	  
			if (( i - now_pg ) != 0) { //이동할 페이지
				sb_html.append("<a href=javascript:setPage_Change('").append(i).append("','").append(type).append("')>").append("<font color=#264E75  style='font-size:8pt'>&nbsp;").append(i).append("</font></a>&nbsp;");
			}
		}
    
		if (next_pg <= tot_pg_cnt) {
			sb_html.append("\n <a href=javascript:setPage_Change('").append(next_pg);
			sb_html.append("','").append(type).append("')>"+"<img src='/images/btn_next.gif' border='0' align='absmiddle'></a>&nbsp;\n");
		}

		if (vw_end_pg + 1 <= tot_pg_cnt) {
			sb_html.append(" <a href=javascript:setPage_Change('").append(vw_end_pg+1);
			sb_html.append("','").append(type).append("')><img src='/images/btn_end.gif' border='0' align='absmiddle'></a>&nbsp;\n");
		}

		sb_html.append("</td>\n");
		sb_html.append("</tr>\n");
		sb_html.append("</table>\n");

		return sb_html.toString();
	}
	
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if(str.equals("")){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
%>
<%
	String        tot_cnt_string = "";
	String        fpg_no         = this.nvl(request.getParameter("faq_page"), "1");
	SepoaFormater wf2_N          = null;
	SepoaFormater wf3_N          = null;
	SepoaOut      value11        = null;
	int           tot_cnt        = 0;
	int           pg_row         = 10;
	int           rec_cnt        = 0;
	int           rw_cnt         = 0;
	Object[]      obj2           = {fpg_no, Integer.toString(pg_row), "", "", "", "Q"};
	
	//if ("MUP150200001".equals( info.getSession("MENU_PROFILE_CODE")) ){
	
	SepoaOut value12 = ServiceConnector.doService(info, "CO_004", "CONNECTION", "getQuery_MAINRPT", obj2);
	wf2_N = new SepoaFormater(value12.result[0]);
	wf3_N = new SepoaFormater(value12.result[1]);

	rw_cnt = wf3_N.getRowCount();

	tot_cnt = Integer.parseInt(wf2_N.getValue(0,0));
	tot_cnt_string = wf2_N.getValue(0,0);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Main</title>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="/js/lib/sec.js"></script>
<script language="javascript" src="/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript">
function setPage_Change(page, type){
	var con_type = "Q";

	document.faqfrm.method = "post";
	document.faqfrm.action = "<%=request.getRequestURI()%>?faq_page=" + page;
	document.faqfrm.submit();
}
 
function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}

function goFaq(seq){
	var url = "/admin/rpt_list_popup_new_index.jsp?seq="+seq;

	CodeSearchCommon(url,'bulletin_list_popup_new','0','0','700','600');
}
</script>
</head>
<body>
	<form name="faqfrm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="center">
					<br/>
					<br/>
					<table width="800px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="left">			
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title_summary" >고객의 소리</td>
									</tr>
									<tr>
										<td align="left"  bgcolor="#d9d9d9" class="td_line"><img src="/images/line_summary.gif" width="48" height="3"></td>
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
		

		if(rw_cnt == 0) {
%>
												<tr>
													<td height="1" colspan="8" align="center" bgcolor="#dddddd"></td>
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
													<td height="1" colspan="8" align="center" bgcolor="#dddddd"></td>
												</tr>
												<tr>
													<td  height="28" align="center" class="lin01"><%=wf3_N.getValue(i,0)%></td>
													<td align="left" class="lin01">
														<%=wf3_N.getValue(i,12)%>
													</td>
													<td  class="pad02 lin01">
														<a href="javascript:goFaq('<%=wf3_N.getValue(i,1)%>');">
															<%=subject%>
														</a>
													</td>
													<td  align="center"  class="lin01">
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
%>
												<tr>
													<td height="1" colspan="8" align="center" bgcolor="#dddddd"></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
								<table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF" style="border-collapse:collapse;">
									<TR>
										<TD align="center" class="c_data_1_p_c">
<% 
	out.println(getPage_html(tot_cnt, pg_row, Integer.parseInt(fpg_no), "Q")); //페이지 번호
%> 
										</TD>
									</TR>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<input type="hidden" name="faq_page" value="<%=fpg_no%>">
	</form>
</body>
</html>
<%}else{ %>
<script language="JavaScript">
	alert("비정상 경로 접근 입니다.");
	self.close();
</script>
<%} %>
