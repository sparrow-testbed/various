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
<title>계약조건</title>
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
								&nbsp;&nbsp;계약조건
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
1. 주식회사 우리은행(이하 “당행”이라 한다)과 물품공급(유지보수)계약은 아래 사항을 포함하여 체결 하여야 한다.
2. 납품 기일 : 물품(유지보수)은 계약체결일로부터  당행이 지정하는 수량을 당행이 지정하는 일시 및 장소에 설치 하여 정상가동 되어야 한다.
3. (유지보수)기간 동안 일정 부분의 계약수량 증감이 발생할 수 있으며, 수량 증가의 경우 본 계약과 동일한 단가를 적용한다.
4. 낙찰금액(부가세별도 기준)이 단수(소수점이하) 발생시 그 금액에서 1,000원 미만 절사하여 계약금액을 계산 확정한다.
5. 계약일로부터 1년 이내 또는 계약기간 내에 추가 납품을 요청하는 경우 다음 각호의 조건으로 추가 납품하여야 한다. 
① 추가 납품 수량의 한도는 직전 낙찰수량의 1배 범위 내로 한다. 단, 낙찰자가 1배 범위 내를 초과하여 납품에 동의하는 경우 
   그 범위까지로 한다. 
② 추가 도입 물량가격은 직전 낙찰가격 또는 그 낙찰가격 이내로 납품하여야 한다.
6. 계약 체결 후 물품(유지보수)의 공급자가 당행이 유지보수 이행할 능력이 없다고 판단되는 경우에는 당행이 계약을 취소할 수 있으며, 
   공급자는 이에  대한 하등의 이의를 제기할 수 없다. 이 경우 계약보증금 및 차액보증금은 당행에 귀속된다. 
7. 계약 보증금은  계약금액의 10/100이상을  현금 또는 당행 계약사무지침에 의한 보증서(보증보험증권등)등으로 당행에 납부 하여야 한다. 
   단, 공사계약에 있어서 연대보증인이 없는 자가 낙찰된 경우에는 20/100 이상으로 한다. 
8. 차액보증금의 납부
① 내정가격의 100분의 85미만으로 낙찰된 경우 
   내정가격과 낙찰금액의 차액을 현금 또는 입찰유의서 5조에서 인정하는 보증서로 차액보증금으로서 계약보증금과 함께 납부하여야 한다. 
② 내정가격의 100분의 70미만으로 낙찰된 경우 
   내정가격과 낙찰금액과의 차액을 현금 또는 차액의 2배에 해당하는 금액을 입찰유의서 5조에서 인정하는 보증서등으로 차액보증금으로서 
   계약보증금과 함께 납부하여야 한다.
9. 위 7항, 8항의 보증기간은 계약기간의 개시일 이전부터 납입기간 만료일 30일 이후까지로 한다.
10.유지보수 의무를 지체한 때에는 지체상금으로서 계약금액에 당행 계약사무지침에서 정하는 
   지체상금률(1,000분의 1.5 이상 1,000분의 10이하)에 지체일수를 곱한 금액을 현금으로 납부 하여야 한다.	
11.대가의 지급은 당행 계약사무지침에 의거 검수 완료후 대가지급 청구를 받은 날부터 20일이내현금지급 하는 것을 원칙으로 한다.
12.입찰참가자 또는 계약체결당사자는 입찰 참가 시, 계약 체결 시 및 계약 체결 이후 등에도 파산, 화의, 회사정리 절차 및 
   그와 유사한 절차 등의 사유가 발생하거나, 부도, 가압류, 가처분, 압류 등에 해당하는 경우 입찰참가자 또는 계약체결 당사자가 
   될 수 없으며, 기존 계약을 해지할 수 있다. 
13.당행에 제공한 제품 등에 대하여 제3자로부터 특허, 저작권 또는 지적재산권의 침해청구가 있을 때, 제품 등 제공자는 
   자기 책임으로 당행을 방어하고, 그러한 침해 청구에 대한 법원의 최종 결정에 따라 총비용(변호사비용 포함) 및 손해배상금을 부담한다.
14.위 내용에도 불구하고 당행이 인정하는 경우 계약보증금, 차액보증금, 하자보수보증금 납부를면제할 수 있다.
15.계약에 관한 서식은 당행 표준서식을 사용 한다. 단, 당행이 인정하는 경우 상호 합의하에 별도 서식을 사용 할 수 있다.
16.당행의 민영화, 합병 및 분사 등 경영상의 사유 및 당행 관련 자회사의 서비스중단 요구로 당행이 
   본 계약을 지속하기 곤란하다고 판단한 경우 계약을 즉시 해지 할 수 있다.


폐사는 위 각 사항을 이의 없이 수락한다. 								
                                </pre>								
							</td>
						</tr>
					</table>
					</DIV>
</body>
</html>