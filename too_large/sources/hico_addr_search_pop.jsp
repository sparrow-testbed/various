<!--
 Title:                 hico_tb_sg1.jsp <p>
 Description:           SUPPLY / ADMIN /  소싱그룹선택 <p>
 Copyright:             Copyright (c) <p>
 Company:               ICOMPIA <p>
 @author                SHYI<p>
 @version
 @Comment
-->
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>

<%
	/* 세션 ###################################################################################### */
    //wise.ses.WiseInfo info = info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL");
	SepoaInfo info = SepoaSession.getAllValue(request);
	
	String kubun = JSPUtil.nullToEmpty(request.getParameter("kubun"));
	Logger.debug.println("YPP",this, "kubun ----==================>"+kubun);
%>

<html> 
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">

	function doSelect(){
		var dong = document.forms[0].dong.value;
		if(isEmpty(dong)) {
			alert('찾고자하는 주소의 동(읍/면/리)을 입력해주시기 바랍니다.');
			return;
		}
		alert("twet");
		document.forms[0].mode.value = "search";
		document.forms[0].target = "list";
		document.forms[0].action = "hico_addr_search_frame.jsp";
		document.forms[0].submit();
	}
	
	function selectAddr(zip, addr, addr2, city) {
		opener.selectAddr(zip, addr, addr2, city);
		self.close(); 
	}
	
	//enter를 눌렀을때 event발생
	function entKeyDown()
	{
 			if(event.keyCode==13) {
  				doSelect();
 			}
 		}

</script>
</head>

              
                
<BODY>
		<table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">		
			<tr>
	        	<td valign="top" width=98%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
							우편번호 검색
							</td>
						</tr>
					</table> 
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="760" height="2" bgcolor="#0072bc"></td>
						</tr>
					</table>
					<br>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="left"><b>* 찾고자하는 주소의 동(읍/면/리)을 입력해주시기 바랍니다.</b></td>
						</tr>
						<tr>
							<td align="left"></td>
						</tr>
					</table>
				</td>
			</tr>		
		</table>
		
		<table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
		<form name="form1" method="post">
		<input type="hidden" name="mode">
			<tr>
				<td width="*">		
					<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
						<tr> 
							<td class="c_title_1" width="15%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;주소</td>          		
              				<td class="c_data_1"  width="*">
								<input type="text" name="dong" class="inputsubmit" style="width:98%;">												
								<input type="text" name="re" class="input_data2" style="width:0%" readOnly>
              				</td>	    	  								              								              			
        				</tr>
					</table>		
				</td>
				<td width="15%">		
					<table>
						<tr>
							<td>
								<script language="javascript">btn("javascript:doSelect()","조 회")    </script>
							</td>
						</tr>				
					</table>
				</td>
			</tr>
		</form>
		</table>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left">
					<iframe name="list" src="" width="100%" height="300" frameborder="0" style="margin-left:0;"></iframe>
				</td>	
			</tr>
		</table>       			
		<table width="100%">
			<tr>
				<td align="right" >
					<TABLE cellpadding="0">
		      			<TR>
	    	  				<TD><script language="javascript">btn("javascript:window.close()","닫 기")    </script></TD>
						</TR>
      				</TABLE>
				</td>
			</tr>
		</table>
</BODY> 
</HTML>
