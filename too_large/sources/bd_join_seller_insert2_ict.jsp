<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<title>입찰품목 기본요건</title>
</head>
<body>
					<% if(request.getParameter("flag").equals("1")){ %>
					<table width="840" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td height="1" colspan="2" bgcolor="#1e97d1"></td>
						</tr>
						<tr>
							<td height="29" bgcolor="#ebf5fa" class="bluebold">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;입찰품목 기본요건
							</td>
							<td align="right" bgcolor="#ebf5fa">&nbsp;</td>
						</tr>
						<tr>
							<td height="1" colspan="2" bgcolor="#c4d6e4"></td>
						</tr>
					</table>
					<% } %>
					<DIV id="divGrdBody" style='WIDTH: 845px; DISPLAY: block; HEIGHT: 600px; <% if(request.getParameter("flag").equals("1")){ %>OVERFLOW: auto <% } %>'>					
					<table width="840" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="100">
								<pre>
1. 입찰물품 기본사양 (제안 견적서 참조) 
2. 일반사항 
   가. 주식회사 우리은행(이하 “당행”이라 한다)가 정하는 입찰물품 기본요건은첫째, 입찰물품은         
       입찰물품 기본사양 및 제안서에 대한 제 기능 수행을 보장하여야 하며, 둘째, 문제가 있을 시는 공급사의 부담으로 조치하여야 한다.  
   나. 또한, 입찰물품은 현재 생산 중단된 물품이거나 생산중단 계획중인 물품이 아니어야 한다.  
   다. 물품의 입찰가격은 현장 인도가격(입찰유의서 제9조(입찰서의 작성))으로 하고  입찰가격
       에는 동 물품 운영에 필요한 모든 부품을 포함하여야 하며 향후 이와 관련된 당행의 추가비용 
       부담이 없음을 보장 하여야 한다.    
   라. 입찰물품의 인도는 당행이 지정하는 일시 및 장소에 설치하여 정상 가동 되어야 한다. 


폐사는 위 각 사항을 이의 없이 확인 및 수락하며 입찰에 참가하고자 한다. 
								</pre>								
							</td>
						</tr>
					</table>
					</DIV>


</body>
</html>