<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("CT_001");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	String screen_id = "CT_001";//help 파일에 사용
	Configuration conf = new Configuration();
	String domain = conf.getString("sepoa.system.domain.name");
	
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
    String _rptName          = "020644/rpt_contract_miri_view"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line"); //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data"); //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
%>

<%/* Alice Editer Object css&js */%>
<link rel="stylesheet" type="text/css" HREF="/css/alice/alice.css">
<link rel="stylesheet" type="text/css" HREF="/css/alice/oz.css">

<%@ include file="/include/alice_cont_scripts.jsp"%>

<%/* Alice Editer Object 생성테그 */%>
<script type="text/javascript">
var alice;
Event.observe(window, "load", function() {
	alice = Web.EditorManager.instance("form_content",{type:'detail',width:'100%',height:'100%',family:'돋움',size:'12px'});
});
</script>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script language="javascript">
	var viewYN = "N";
	function setContractSave() {
		var contract_name = document.form1.contract_name.value;
		var contract_type = document.form1.contract_type.value;
		var remark		  = document.form1.remark.value;
		document.form1.form_content.value = alice.getContent();

		if(contract_name == "") {
			alert("계약서식이름을 작성하세요.");
			document.form1.contract_name.focus();
			return;
		}

		if(contract_type == "") {
			alert("계약종류을 선택하세요.");
			document.form1.contract_type.focus();
			return;
		}

		if(remark == "") {
			alert("계약서식설명을 작성하세요.");
			document.form1.remark.focus();
			return;
		}

		if(document.form1.form_content.value == "") {
			alert("계약내용을 작성하세요.");
			return;
		}
		
		if(viewYN == "N"){
			alert("미리보기 후 표준서식을 등록하세요.");
			return;
		}
		
		if (confirm("표준서식을 등록 하시겠습니까?")) {
			document.form1.method = "POST";
			document.form1.target = "childFrame";
			document.form1.action = "contract_form_regist_save.jsp";
			document.form1.submit();
		}
	}
	<%-- ClipReport4 리포터 호출 스크립트 --%>
	function clipPrint(rptAprvData,approvalCnt) {
		viewYN = "N";
		var contract_name = document.form1.contract_name.value;
		var contract_type = document.form1.contract_type.value;
		var remark		  = document.form1.remark.value;
		document.form1.form_content.value = alice.getContent();
		
		if(contract_name == "") {
			alert("계약서식이름을 작성하세요.");
			document.form1.contract_name.focus();
			return;
		}

		if(contract_type == "") {
			alert("계약종류을 선택하세요.");
			document.form1.contract_type.focus();
			return;
		}

		if(remark == "") {
			alert("계약서식설명을 작성하세요.");
			document.form1.remark.focus();
			return;
		}

		if(document.form1.form_content.value == "") {
			alert("계약내용을 작성하세요.");
			return;
		}
		
		var sRptData = "";
		var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
		var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
		var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
		//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
		/* sRptData += "";	//계약상태
		sRptData += rf;
		sRptData += "";
		
		sRptData += rf;
		sRptData += rf;
		sRptData += rf;
		sRptData += rd; */
		sRptData +="<html>";
		sRptData +="<head>";
		sRptData +="</head>";
		sRptData +="<body>";
		sRptData +=document.form1.form_content.value;
		sRptData +="</body>";
		sRptData +="</html>";
		//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
		document.form1.rptData.value = sRptData.replaceAll("\"","&quot");
	
		if(typeof(rptAprvData) != "undefined"){
			document.form1.rptAprvUsed.value = "Y";
			document.form1.rptAprvCnt.value = approvalCnt;
			document.form1.rptAprv.value = rptAprvData;
	    }
	    var url = "/ClipReport4/ClipViewer.jsp";
		//url = url + "?BID_TYPE=" + bid_type;	
	    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		document.form1.method = "POST";
		document.form1.action = url;
		document.form1.target = "ClipReport4";
		document.form1.submit(); 
		cwin.focus();
		viewYN = "Y";
	}
</Script>
</head>
<body leftmargin="15" topmargin="6">
<s:header>
<form name="form1" method="post">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot").replaceAll("\\\\", "￦")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
<input type="hidden" name="input_flag" value="I"> 
<input type="hidden" name="cont_private_flag" value="PU"> 
<%
// 	 thisWindowPopupFlag = "true";
// 	 thisWindowPopupScreenName = "표준서식작성";
%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
						<tr>
			  				<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						계약서식이름
        					</td>
        					<td height="24" class="data_td" colspan="3">
        						<input type="text" id="contract_name" name="contract_name" value="" style="width: 740px;" onKeyUp="return chkMaxByte(200, this, '계약서식이름')">
        					</td>
        					<td width=14% height="24" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						계약종류
        					</td>
        					<td width="20%" height="24" class="data_td" >
                				<select id="contract_type" name="contract_type" class="inputsubmit" >
									<option value="">----------------</option>
									<%
										String lg = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M899", "");
										out.println(lg);
									%>										
					
								</select>
        					</td>
			  			</tr>
						<tr>
							<td colspan="4" height="1" bgcolor="#dedede"></td>
						</tr>				  			
		      			<tr>
        					<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						작성자
        					</td>
        					<td width="20%" height="24" class="data_td">
        						<input type="text" id="user_name" name="user_name" value="<%=user_name%>" size="8" class="input_empty" readOnly>
        					</td>
        					<td width="13%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						작성일
        					</td>
        					<td width="20%" height="24" class="data_td">
        						<s:calendar id="add_date" default_value="<%=SepoaString.getDateSlashFormat(to_day)%>" format="%Y/%m/%d"/>
        					</td>        		
        					<td width="14%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						사용여부
        					</td>
        					<td width="20%" height="24" class="data_td">
	                			<select id="use_flag" name="use_flag" class="inputsubmit" >
									<option value="">----------------</option>
									<%
										String lg2 = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M898", "");
										out.println(lg2);
									%>			                
								</select>
        					</td>
			  			</tr>
						<tr>
							<td colspan="4" height="1" bgcolor="#dedede"></td>
						</tr>				  			
		      			<tr>
        					<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						서식설명
        					</td>
        					<td width="87%" height="24" class="data_td" colspan="5">
        						<textarea id="remark" name="remark" class="inputsubmit" cols="120%" rows="5px" ></textarea>
        					</td>
			  			</tr>
						<tr>
							<td colspan="4" height="1" bgcolor="#dedede"></td>
						</tr>				  			
		      			<tr>
        					<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						사유등록
        					</td>
        					<td width="87%" height="24" class="data_td" colspan="5">
        						<textarea name="cont_update_desc" class="inputsubmit" cols="120%" rows="5px" ></textarea>
        					</td>
			  			</tr>			  
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		
			
			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				<TR>
					<td style="padding:5 5 5 0" align="right">
						<TABLE cellpadding="2" cellspacing="0">
							<TR>
								<td><script language="javascript">btn("javascript:clipPrint()","미리보기")</script></td>
								<td><script language="javascript">btn("javascript:setContractSave()","서식등록")</script></td>
							</TR>
						</TABLE>
					</td>
				</TR>
			</TABLE>
			  
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr width="100%">
					<td class="div_data" style="word-break:break-all;">
						<textarea name="form_content" id="form_content" class="inputsubmit" cols="10" style="width:99%;height:100%" rows="50"></textarea>
					</td>
				</tr>
			</table> 

</form>
</s:header>
<s:footer/>
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>