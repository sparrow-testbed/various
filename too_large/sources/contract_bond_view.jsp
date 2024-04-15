<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.ses.*"%> 
<%@ page import="sepoa.fw.srv.*" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="sepoa.fw.util.JSPUtil" %>
<%@ page import="signgate.sgic.xmlmanager.util.FileWriteUtil"%> 
<%@ include file="signgate_xlinker.jsp" %>

<%  
 	FileInputStream fis = null;
 
	SGIxLinker xLinker =  new SGIxLinker(this.recvinfo_conf, "recv_jsp", true);
			
	DecimalFormat df = new DecimalFormat("###,###,###,###,##0");
	
 	String POASRM_CONTEXT_NAME = "";
	String recvDocCode = "CONGUA"; 	 
	String recvXmlDoc = ""; 	 
	
	String cont_no	    = JSPUtil.nullToEmpty(request.getParameter("cont_no"));  //계약번호
	String cont_gl_seq  = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq")); //계약차슈
	String ins_flag     = JSPUtil.nullToEmpty(request.getParameter("ins_flag")); //보증서구분
	
	recvDocCode = ins_flag;  //보증서구분
 
    try
	{
   			Config conf = new Configuration();
			POASRM_CONTEXT_NAME = conf.get("sepoa.context.name");
 
			sepoa.fw.ses.SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(request);
		 	info = new SepoaInfo("100","ID="+cont_no+"^@^LANGUAGE=KO^@^NAME_LOC="+cont_no+"^@^NAME_ENG=HOMEPAGE^@^DEPT=ALL^@^");
		 	
			Object[] obj = {cont_no, cont_gl_seq, ins_flag};
		    SepoaOut value = ServiceConnector.doService(info, "CT_014", "CONNECTION","getBondPath", obj);
		    
			SepoaFormater wf  = new SepoaFormater(value.result[0]);  
			 
			if(wf.getValue(0, 0).length() == 0) {
				out.println("<Script language=\"javascript\" >");
				out.println("alert(\"서울금융보증보험에서 발행한 보증서가 존재하지 않습니다.\");");
				out.println("self.close();");
				out.println("</Script>");
			
			}else{
				    fis = new FileInputStream(wf.getValue(0, 0));
				    Reader rd = new InputStreamReader(fis);
				    int data; 
				    while((data=rd.read())  !=-1){
				    //System.out.println((char)data);
				    	recvXmlDoc += ""+(char)data;
		    		}
 
		        	 XmlToData xmlToData = new XmlToData(templates_path, recvDocCode, recvXmlDoc); 
		
					String subject = xmlToData.getData("head_mesg_name"); 
 
    %>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/TR/WD-xsl" xmlns="http://www.w3.org/TR/REC-html40">
<xsl:template match="/">
<html>
<head>
	<title>
		우리은행 전자구매시스템
	</title>
    <meta content="text/html; charset=euc-kr" http-equiv="Content-Type"/>
	<style type="text/css">
		BODY  {  scrollbar-3dlight-color:595959; scrollbar-arrow-color:ffffff; scrollbar-3dlight-color:595959; scrollbar-arrow-color:ffffff; scrollbar-base-color:CFCFCF; scrollbar-darkshadow-color:FFFFFF; scrollbar-face-color:CFCFCF; scrollbar-highlight-color:FFFFF; scrollbar-shadow-color:595959; margin:0 0 0 0; } 
		BODY,TD,SELECT,TEXTAREA,FORM,INPUT { font-family: "굴림"; font-size: 9pt; color: #3C3C3C; }
		.HEADLINE	{ font-family: "굴림체"; font-size: 23pt; font-weight: bold; color: #000000; vertical-align: bottom;}
		.fontb	  {   font-family: "굴림체"; line-height: 14pt; font-weight: bold; text-align: left;  vertical-align: bottom; color: #3C3C3C}
		.fontbc	  {   font-family: "굴림체"; line-height: 14pt; font-weight: bold; text-align: center;  vertical-align: middle; color: #3C3C3C}
		.text_text {  font-family: '굴림체'; font-size: 7pt; color: #000000}
		.text5 {  font-family: '굴림체'; font-size: 6pt; color: #000000}
		.text6 {  font-family: '굴림체'; font-size: 10pt; font-weight: bold;}
		.sub_title {  font-family: '굴림체'; font-size: 12pt; font-weight: bold}
	</style>
 
</head>
<body ondragstart="return false">
<object id="factory" style="display:none"
  classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814"
  codebase="/kr/ctr/ScriptX.cab#Version=6,2,433,9">
</object>
<xml id="xid"> </xml> 
<table width="750" border="0" cellspacing="0" cellpadding="0" background="<%=POASRM_CONTEXT_NAME%>/images/contract/xsl_back.jpg">
	<tr>
		<td width="35">&nbsp;</td>
		<td align="center">
			<table border="0" width="680" cellspacing="0" cellpading="0" height="95"> 
				<tr height="90">
					<td colspan="3" valign="top">
						<table border="0" height="55">
							<tr>
								<td>
								</td>
							</tr>
						</table>			
					</td>
				</tr>
				<tr> 
					<td width="74" rowspan="2" height="90">
						&nbsp; 
					</td> 
					<td align="center" class="headline" width="520" height="45">
					  이행(
                        <% if( xmlToData.getData("head_mesg_name").equals("계약보증서")){ %>
						
							계약
						<% }else if( xmlToData.getData("head_mesg_name").equals("하자보증서")){ %>
							하자
						<% }else if( xmlToData.getData("head_mesg_name").equals("선금급보증서")){ %>
							선금
						<% } %>
					  )보증보험증권
					</td>
					<td widtn="70" rowspan="2">&nbsp;</td>
				</tr> 
				<tr>
					<td align="center" class="sub_title" valign="top" width="500">
						(인터넷조회용)
					</td>
				</tr>
				<tr> 
					<td colspan="3" height="28" valign="bottom"> 
						<table width="600" border="0" cellspacing="0" cellpadding="0"> 
							<tr> 
								<td width="560" height="23" class="sub_title" valign="bottom">
									증권번호 제
									<%= xmlToData.getData("head_docu_numb").substring(6, 9)%>-<%= xmlToData.getData("head_docu_numb").substring(9, 12)%>-<%= xmlToData.getData("head_docu_numb").substring(12, 25)%>
									호
								 </td> 
							</tr> 
						</table> 
					</td> 
				</tr>
				<tr>
					<!--- 내용 시작 -->
					<td colspan="3">
						<table width="680" cellspacing="0" border="1" cellpadding="2" class="tr">
							<tr>
								<td width="15%" class="fontbc">보험계약자</td>
								<td width="35%" height="55">
								<%if( xmlToData.getData("appl_orps_divs").equals("O")){%>
						
								    &nbsp;<%= xmlToData.getData("appl_orps_iden").substring(0, 3)%>-<%= xmlToData.getData("appl_orps_iden").substring(3, 5)%>-<%= xmlToData.getData("appl_orps_iden").substring(5, 10)%>

						         <%}else if( xmlToData.getData("appl_orps_divs").equals("P")){%>
									&nbsp;<%= xmlToData.getData("appl_orps_iden").substring(0, 6)%>-<%= xmlToData.getData("appl_orps_iden").substring(6, 13)%>
									<%}%>
									<br />&nbsp;
									<%= xmlToData.getData("appl_orga_name")%>
									<br />&nbsp;
									<%= xmlToData.getData("appl_ownr_name")%>
								</td>
								<td width="15%" class="fontbc">피보험자</td>
								<td width="35%" colspan="2">&nbsp; 
								<%if( xmlToData.getData("cred_orps_divs").equals("O")){%>
						
								    <%= xmlToData.getData("cred_orps_iden").substring(0, 3)%>-<%= xmlToData.getData("cred_orps_iden").substring(3, 5)%>-<%= xmlToData.getData("cred_orps_iden").substring(5, 10)%>

						         <%}else if( xmlToData.getData("cred_orps_divs").equals("P")){%>
									<%= xmlToData.getData("cred_orps_iden").substring(0, 6)%>-<%= xmlToData.getData("cred_orps_iden").substring(6, 13)%>
									<%}%>
									
									<br />&nbsp;
									<%= xmlToData.getData("bond_hold_name")%>
								</td>
							</tr>
							<tr>
								<td class="fontbc" height="45">보험가입금액</td>
								<td colspan="2">&nbsp;金 <%= xmlToData.getData("bond_penl_text")%> 
									 整
									<br />&nbsp;\&nbsp;<%=df.format(Long.parseLong( xmlToData.getData("bond_penl_amnt")))%>-
									
									
							    </td>
								<td class="fontbc">보 험 료</td>
								<td align="right">\&nbsp;<%=df.format(Long.parseLong( xmlToData.getData("bond_prem_amnt")))%>-
									
								</td>
							</tr>
							<tr>
								<td class="fontbc" height="30">보 험 기 간</td>
								<td colspan="4">&nbsp;<%= xmlToData.getData("bond_begn_date").substring(0,4)%>  년 <%= xmlToData.getData("bond_begn_date").substring(4,6)%> 월 <%= xmlToData.getData("bond_begn_date").substring(6,8)%> 일
									 부터 
								<%= xmlToData.getData("bond_fnsh_date").substring(0,4)%>  년 <%= xmlToData.getData("bond_fnsh_date").substring(4,6)%> 월 <%= xmlToData.getData("bond_fnsh_date").substring(6,8)%> 일
								   까지
								</td>
							</tr>
							<tr>
								<td class="fontbc" height="30">보 증 내 용</td>
								<td colspan="4">&nbsp;<%= xmlToData.getData("bond_stat_text")%>
								</td>
							</tr>
							<tr>
								<td class="fontbc" height="70">특 별 약 관</td>  
								<td colspan="4">&nbsp;<%= xmlToData.getData("spcl_prov_text")%>
								</td>
							</tr>
							<tr>
								<td class="fontbc" height="70">특 기 사 항</td>
								<td colspan="4">&nbsp;<%= xmlToData.getData("spcl_cond_text")%>
									
								</td>
							</tr>
							<tr>
								<td colspan="5" align="center" height="190" valign="top">
									<!--- 주계약내용 시작 (이행계약) -->
                                    <% if( xmlToData.getData("head_mesg_name").equals("계약보증서")){ %>
									<table width="97%" border="0">
										<tr>
											<td class="text6" colspan="2">주계약내용</td>
										</tr>
										<tr>
											<td class="fontb" width="100">계약명</td>
											<td>
												<%= xmlToData.getData("cont_name_text")%>
											</td>
										</tr>
										<tr>
											<td class="fontb">계약기간</td>
											<td>
											<%if( xmlToData.getData("cont_begn_date").length()>=8){ %>
											      <%= xmlToData.getData("cont_begn_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_begn_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_begn_date").substring(6,8)%> 일 부터
											<%}%>
                                            <%if( xmlToData.getData("cont_fnsh_date").length()>=8){ %>
											      <%= xmlToData.getData("cont_fnsh_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_fnsh_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_fnsh_date").substring(6,8)%> 일 까지
											 <%}%>
											</td>
										</tr>
										<tr>
											<td class="fontb">계약체결일자</td>
											<td>
											<%if( xmlToData.getData("cont_main_date").length()>=8){ %>
											    <%= xmlToData.getData("cont_main_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_main_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_main_date").substring(6,8)%> 일
											<%}%>
												
											</td>
										</tr>
										<tr>
											<td class="fontb">계약금액</td>
											<td>\&nbsp;<%=df.format(Long.parseLong( xmlToData.getData("cont_main_amnt")))%>- 
											</td>
										</tr>
										<tr>
											<td class="fontb">계약보증금율</td>
											<td><%= xmlToData.getData("bond_pric_rate")%>
											      % 
											</td>
										</tr>
									</table>
									</xsl:if>																
									<!--- 주계약내용 끝 (이행계약) -->
								
									<!--- 주계약내용 시작 (이행하자) -->
				     <% }else if( xmlToData.getData("head_mesg_name").equals("하자보증서")){ %>
									<table width="97%" border="0">
										<tr>
											<td class="text6" colspan="2">주계약내용</td>
										</tr>
										<tr>
											<td class="fontb" width="100">계약명</td>
											<td>
												<%= xmlToData.getData("cont_name_text")%>
											</td>
										</tr>
										<tr>
											<td class="fontb">하자담보기간</td>
											<td>
											<%if(xmlToData.getData("morg_begn_date").length()>=8){ %>
											      <%= xmlToData.getData("morg_begn_date").substring(0,4)%>  년 <%= xmlToData.getData("morg_begn_date").substring(4,6)%> 월 <%= xmlToData.getData("morg_begn_date").substring(6,8)%> 일 부터
											<%}%>
                                            <%if( xmlToData.getData("morg_fnsh_date").length()>=8){ %>
											      <%= xmlToData.getData("morg_fnsh_date").substring(0,4)%>  년 <%= xmlToData.getData("morg_fnsh_date").substring(4,6)%> 월 <%= xmlToData.getData("morg_fnsh_date").substring(6,8)%> 일 까지
											 <%}%>
											</td>
										</tr>
										<tr>
											<td class="fontb">계약체결일자</td>
											<td>
											<%if( xmlToData.getData("cont_main_date").length()>=8){ %>
											    <%= xmlToData.getData("cont_main_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_main_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_main_date").substring(6,8)%> 일
											<%}%>
											</td>
										</tr>
										<tr>
											<td class="fontb">계약금액</td>
											<td>\&nbsp;<%=df.format(Long.parseLong( xmlToData.getData("cont_main_amnt")))%>- 
											</td>
										</tr>
										<tr>
											<td class="fontb">하자보증금율</td>
											<td><%= xmlToData.getData("bond_pric_rate")%> % 
											</td>
										</tr>
									</table>
									</xsl:if>

									</xsl:if>
									<!--- 주계약내용 끝 (이행하자) -->
									<!--- 주계약내용 시작 (선금급) -->
				     <% }else if( xmlToData.getData("head_mesg_name").equals("선금급보증서")){ %>
									<table width="97%" border="0">
										<tr>
											<td class="text6" colspan="2">주계약내용</td>
										</tr>
										<tr>
											<td class="fontb" width="100">계약명</td>
											<td>
												<%= xmlToData.getData("cont_name_text")%>
											</td>
										</tr>
										<tr>
											<td class="fontb">계약금액</td>
											<td>\&nbsp;<%=df.format(Long.parseLong( xmlToData.getData("cont_main_amnt")))%>- 
											</td>
										</tr>
										<tr>
											<td class="fontb">선금(전도자재액)액</td>
											<td>\&nbsp;<%=df.format(Long.parseLong( xmlToData.getData("cont_paym_amnt")))%>- 
											</td>
										</tr> 
										<tr>
											<td class="fontb">계약체결일자</td>
											<td>
											<%if( xmlToData.getData("cont_main_date").length()>=8){ %>
											    <%= xmlToData.getData("cont_main_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_main_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_main_date").substring(6,8)%> 일
											<%}%>
												
											</td>
										</tr>
										<tr>
											<td class="fontb">계약기간</td>
											<td>
											<%if( xmlToData.getData("cont_begn_date").length()>=8){ %>
											      <%= xmlToData.getData("cont_begn_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_begn_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_begn_date").substring(6,8)%> 일 부터
											<%}%>
                                            <%if( xmlToData.getData("cont_fnsh_date").length()>=8){ %>
											      <%= xmlToData.getData("cont_fnsh_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_fnsh_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_fnsh_date").substring(6,8)%> 일 까지
											 <%}%>
											</td>
										</tr>
										<tr>
											<td class="fontb">선금(전도자재)지급(예정)일</td>
											<td>
											<%--if( xmlToData.getData("cont_paym_date").length()>=8){ %>
											    <%= xmlToData.getData("cont_paym_date").substring(0,4)%>  년 <%= xmlToData.getData("cont_paym_date").substring(4,6)%> 월 <%= xmlToData.getData("cont_paym_date").substring(6,8)%> 일
											<%}--%>
												
											</td>
										</tr>
									</table>
									</xsl:if>

									</xsl:if>
									<!--- 주계약내용 끝 (선금급) -->
									<%}%> 

								</td>
							</tr>
						</table>
					</td>
					<!--- 내용 끝 -->
				</tr> 
				<tr>
					<td colspan="3" height="35" valign="bottom">
                        <% if( xmlToData.getData("head_mesg_name").equals("계약보증서")){ %>
						
						우리 회사는 이행(계약)보증보험 보통약관, 특별약관 및 이 증권에 기재된 내용에 따라 이행(계약)보증보험 계약을 체결하였음이 확실하므로 그 증으로 이 증권을 발행합니다.
						
						<% }else if( xmlToData.getData("head_mesg_name").equals("하자보증서")){ %>
						
						우리 회사는 이행(하자)보증보험 보통약관, 특별약관 및 이 증권에 기재된 내용에 따라 이행(하자)보증보험 계약을 체결하였음이 확실하므로 그 증으로 이 증권을 발행합니다.
						
						<% }else if( xmlToData.getData("head_mesg_name").equals("선금급보증서")){ %>
						
						우리 회사는 이행(선금)보증보험 보통약관, 특별약관 및 이 증권에 기재된 내용에 따라 이행(선금)보증보험 계약을 체결하였음이 확실하므로 그 증으로 이 증권을 발행합니다.
						
						<% } %>

				
					</td>
				</tr>
				<tr>
					<td colspan="3" height="30">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3">
						<table border="0">
							<tr>
								<td width="405">
									<table border="0">
										<tr>
											<td class="sub_title">※ 증권발급 사실 확인 안내<br/></td>
										</tr>
										<tr>
											<td><br/>발 급 부 서 : 
												<%= xmlToData.getData("bond_numb_text").substring(6, 9)%>
												<%= xmlToData.getData("issu_dept_name")%>
												(<%= xmlToData.getData("chrg_phon_text")%>)
											</td>
										</tr>
										<tr>
											<td>부&nbsp;&nbsp;&nbsp;서&nbsp;&nbsp;&nbsp;장 : 
												<%= xmlToData.getData("issu_dept_ownr")%>
											</td>
										</tr>
										<tr>
											<td>담&nbsp;&nbsp;&nbsp;당&nbsp;&nbsp;&nbsp;자 : 
												<%= xmlToData.getData("chrg_name_text")%>
											</td>
										</tr>
										<tr>
											<td>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : 
											<%= xmlToData.getData("issu_addr_txt1")%>
												<br /> 
						      					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<%= xmlToData.getData("issu_addr_txt2")%>
											</td>
										</tr> 
									</table>
								</td>
								<td valign="top">
									<table width="200">
										<tr>
											<td align="right">
											<%if( xmlToData.getData("docu_issu_date").length()>=8){ %>
											      <%= xmlToData.getData("docu_issu_date").substring(0,4)%>  년 <%= xmlToData.getData("docu_issu_date").substring(4,6)%> 월 <%= xmlToData.getData("docu_issu_date").substring(6,8)%> 일
											<%}%>
											</td>
										</tr>
										<tr>
											<td align="right">
												<%= xmlToData.getData("issu_addr_txt1")%><br /> 
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>			
					</td>
				</tr> 
			</table>  
		</td>
		<td width="38">&nbsp;</td>
	</tr>
</table> 
</body>
</html>
<% 
	 	
		}  
		
	 } catch(Exception e) {
	  	
	  	response.sendRedirect(POASRM_CONTEXT_NAME + "/errorPage/system_error.jsp");		
	 } finally {
		if(fis !=null)try{fis.close();}catch(Exception e){} 
	 }
%>