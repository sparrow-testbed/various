<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%SepoaInfo info = SepoaSession.getAllValue(request); %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<TITLE>우리은행 IT전자입찰시스템</TITLE>

<script type="text/javascript">

	function doCheck(sTmpFlag) {
		
		if (!document.getElementById('rdoG').checked && !document.getElementById('rdoJ').checked)
    	{
    		alert("공급사/제조사를 선택하세요.");
    		return;
    	}

		if(sTmpFlag == "G"){
		    location.href = "hico_bd_agree.jsp";
		}else if(sTmpFlag == "I"){
			if(confirm("우리은행 IT전략부와 거래를 위한\n업체등록 신청화면으로 이동합니다.\n신청하시겠습니까?") != 1){
				return;
			}
			//location.href = "/ict/s_kr/admin/info/hico_bd_agree_ict2.jsp";
			form2.submit();
		}
	}
	
	function un_select()
	{
		/*
		signform.rdoG.checked = false;
		signform.rdoJ.checked = false;
		*/
		document.getElementById('rdoG').checked = false;
	    document.getElementById('rdoJ').checked = false;
		
	    document.getElementById('divIrsNo').style.visibility = 'hidden';
	}
	
	function on_select(){
	    
	    document.getElementById('divIrsNo').style.visibility = 'visible';	 
		//var mode = irsNo == "" ? "resident_no" : "irs_no";
		//form1.mode.value = mode;
		//this.hiddenframe.location.href="checkDupIrsNo_ict.jsp?irs_no="+irsNo+"&resident_no="+residentNo+"&mode="+mode;
	    //location.href="checkDupIrsNo.jsp?irs_no="+irsNo+"&resident_no="+residentNo+"&mode="+mode;
	}


</script>

</head>

<body>
<form id="form2" name="form2" method="post" action="/ict/s_kr/admin/info/hico_bd_agree_ict2.jsp">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="bg_popup">
		<tr>
			<td width="20">&nbsp;</td>
			<td valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td height="8"></td>
					</tr>
					<tr>
						<td height="35" class="title_page">필수 확인사항</td>
					</tr>
				</table>
				<table width="99%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td height="3"></td>
					</tr>
				</table>
				<table width="850" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td height="1" colspan="2" bgcolor="#1e97d1"></td>
					</tr>
					<tr>
						<td height="29" bgcolor="#ebf5fa" class="bluebold">
							&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
							&nbsp;&nbsp;회원등록 신청전 아래 사항을 확인해주시기 바랍니다
						</td>
						<td align="right" bgcolor="#ebf5fa">&nbsp;</td>
					</tr>
					<tr>
						<td height="1" colspan="2" bgcolor="#c4d6e4"></td>
					</tr>
				</table>
				<table width="850" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="20">&nbsp;</td>
						<td>
							<br />
							1. 회원등록 매뉴얼을 다운로드해 주시기 바랍니다.<br />

							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="150">&nbsp; &nbsp;- 협력사용 매뉴얼</td>
									<td>
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td>
													<a href="vendorJoinManual_ict.zip"><font color="blue"><b>☞ 회원가입 매뉴얼 다운로드</b></font></a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>

							<br />
							2. 회원가입 등록시 기본정보 입력 후 아래의 자료를 <span class="bluebold">스캔</span>하여 파일을 첨부해 주시기 바랍니다.
							(기존 거래업체 포함)
							<br />

							<table>
								<tr>
									<td>&nbsp; &nbsp;- 법인사업자 : 사업자등록증, 회사소개서</td>
								</tr>								
							</table>
							
							<br />
							3. 필수입력사항&nbsp;:&nbsp;기본정보, 영업담당<br />							
							<br>
						</td>
					</tr>
					<tr>
						<td height="1" colspan="3" bgcolor="#1e97d1"></td>
					</tr>
				</table>
				<table width="850" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td height="43" align="center">
							<table border="0" cellpadding="2" cellspacing="0">
								<tr>																
									<td><script language="javascript">btn("javascript:on_select();","아이디 신청 (IT전략부)")</script></td>
									<%--<td><script language="javascript">btn("javascript:doCheck('I')","아이디 신청 (IT전략부)")</script></td>--%>
									<td>&nbsp;&nbsp;&nbsp;</td>
									<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<td width="20">&nbsp;</td>
		</tr>
		<tr>
			<td height="30">&nbsp;</td>
			<td valign="top">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<div id="divIrsNo" style="POSITION:absolute; WIDTH:400px; HEIGHT:100px; VISIBILITY:hidden; TOP:300px; LEFT:250px;">
		<table style="BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid">
			<tr>
				<td align="middle" height="20" width="400" colspan="3">
					&nbsp;
				</td>						
			</tr>									
			<tr>
			    <td align="right">
			    	공급사/제조사 구분&nbsp;&nbsp;
				</td>		    			
				<td colspan="2">
					<input value="G" name="rdoGJ" id="rdoG" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">공급사</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input value="J" name="rdoGJ" id="rdoJ" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">제조사</span>
				</td>				
			</tr>
			<tr>
				<td colspan="3">
					&nbsp;
				</td>
			</tr>																
			<tr>
				<td align="right" height="20" width="120">
					&nbsp;
				</td>						
				<td align="right" height="20" width="100">
					<script language="javascript">btn("javascript:doCheck('I');","확 인")</script>
				</td>
				<td align="left" height="20" width="180">
					<script language="javascript">btn("javascript:un_select();", "닫 기")</script>
				</td>						
			</tr>	
			<tr>
				<td align="middle" height="20" width="400" colspan="3">
					&nbsp;
				</td>						
			</tr>										
		</table>
	</div>
</form>
<form id="form1" name="form1" method="post" action="/intro/download.jsp">
	<input type="hidden" name="file_type">
	<input type="hidden" name="desc_file_name">
	<input type="hidden" name="src_file_name">
</form>
</body>
</html>
<iframe name = "downframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
