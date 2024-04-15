<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ page import="java.io.*"%>
<%@ page import="java.security.*"%>
<%@ page import="java.security.cert.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%

//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_contract_detail_print"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

	Vector multilang_id = new Vector();
	multilang_id.addElement("CTS_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MASSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);

	String id = info.getSession("ID");
	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	
	String cont_no      = JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq  = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String cont_form_no = JSPUtil.nullToEmpty(request.getParameter("cont_form_no"));

	/* Object[] obj = { cont_no, cont_gl_seq };
	SepoaOut value = ServiceConnector.doService(info, "CTS_001", "CONNECTION", "getContractDetailSelect", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	for (int i = 0; i < wf.getRowCount(); i++) {
		CONT_CONTENT += wf.getValue("CONTENT", i);
	} */

	Object[] obj1 = { cont_no, cont_gl_seq };
	SepoaOut value1 = ServiceConnector.doService(info, "CT_021", "CONNECTION", "getContractContNoSelect", obj1);
	SepoaFormater wf2 = new SepoaFormater(value1.result[0]);

	String in_attach_no = ""; 
	
	String contractstatus	= "계약진행중";
	
	if (wf2.getRowCount() > 0) {
		in_attach_no                    = JSPUtil.nullToEmpty(wf2.getValue("ATTACH_NO", 0));                // 첨부파일 
	}
	String CONT_INS_VN = JSPUtil.nullToEmpty(wf2.getValue("CONT_INS_VN",0));//보증사구분 type = 'M225'
	String CONT_INS_NO = JSPUtil.nullToEmpty(wf2.getValue("CONT_INS_NO",0));//계약이행번호
	String FAULT_INS_NO = JSPUtil.nullToEmpty(wf2.getValue("FAULT_INS_NO",0));//하자이행번호
	String CONT_INS_FLAG = JSPUtil.nullToEmpty(wf2.getValue("CONT_INS_FLAG",0));//계약이행계약서 전송상태
	String FAULT_INS_FLAG = JSPUtil.nullToEmpty(wf2.getValue("FAULT_INS_FLAG",0));//하자이행계약서 전송상태
	String CONT_AMT = JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_AMT",0));//계약금액
	String SG_LEV1 = JSPUtil.nullToEmpty(wf2.getValue("SG_LEV1",0));//계약구분1
	String SG_LEV2 = JSPUtil.nullToEmpty(wf2.getValue("SG_LEV2",0));//계약구분1
	String SG_LEV3 = JSPUtil.nullToEmpty(wf2.getValue("SG_LEV3",0));//계약구분1
	

	Configuration conf = new Configuration();
	String domain = conf.getString("sepoa.system.domain.name");
	String screen_id = "CTS_003";
	
	
	String CONT_CONTENT = "";
	String CONT_CONTENT1 = "";

	
	Object[] obj2 = { cont_no, cont_gl_seq, "C" };
	SepoaOut value2  = ServiceConnector.doService(info, "CTS_001", "CONNECTION",  "getContractTotalSelect", obj2);
	SepoaFormater wf3  = new SepoaFormater(value2.result[0]); // CLOB
	SepoaFormater wf4 = new SepoaFormater(value2.result[1]); // DATA
		
	for(int j = 0; j < wf3.getRowCount(); j++)
	{
		CONT_CONTENT1 += wf3.getValue("CONTENT", j);
	}
	
	//계약서양식부
	CONT_CONTENT  = CONT_CONTENT1;
	
	for(int k = 0; k < wf4.getRowCount(); k++)
	{
		CONT_CONTENT1 += wf4.getValue("CONTENT", k);
	}
	
	CONT_CONTENT1 = CONT_CONTENT1.replaceAll("\"", "");
	CONT_CONTENT1 = CONT_CONTENT1.replaceAll("\r\n", "");
	//CONT_CONTENT1 = new String(CONT_CONTENT1.getBytes("UTF-8"));
	
	Logger.sys.println(">>>>>>> CONT_CONTENT1 = " + CONT_CONTENT1);
	Logger.sys.println(">>>>>>> CONT_CONTENT1.LENGTH() = " + CONT_CONTENT1.length());
	
	Object[] obj3 = { id }; // ICOMVNGL  업체일반 정보에서  인증서 키값 인증서발급기관 가져오기
	//SepoaOut value3  = ServiceConnector.doService(info, "CTS_001", "CONNECTION",  "getContractApproval", obj3); 
	//SepoaFormater wf5 = new SepoaFormater(value3.result[0]);
	
	String sign_value	= "";//wf5.getValue("SIGN_VALUE", 0);
	String sign_name	= "";//wf5.getValue("SIGN_NAME", 0);
	
	////////////////////////////////////////////////////////////////////
	
	String data = new String(CONT_CONTENT1);
	
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(contractstatus);	//계약상태
	_rptData.append(_RD);
	_rptData.append("<html>");
	_rptData.append("<head>");
	_rptData.append("</head>");
	_rptData.append("<body>");
	_rptData.append(CONT_CONTENT);////////////////////////////////////////////////////////////////////////////////////////
	_rptData.append("</body>");
	_rptData.append("</html>");
	//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////	
		
%>

<%
/* Alice Editer Object css&js */
%>
<link rel="stylesheet" type="text/css" HREF="../css/alice/alice.css">
<link rel="stylesheet" type="text/css" HREF="../css/alice/oz.css">

<%-- AnySign 클라이언트 팝업에서 인증서가 로딩이 안되는 오류 유발
<%@ include file="/include/alice_scripts.jsp"%>
--%>
</script>

<html>
<head>
<title>우리은행 전자구매시스템</title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache">
<%-- AnySign 솔루션으로 교체
<SCRIPT language=javascript src="../include/attestation/TSToolkitConfig.js"></script>
--%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<script language="javascript">


function help(){
	var url = "<%=domain%>/help/<%=screen_id%>.htm";
	var toolbar = 'no';
       var menubar = 'no';
       var status = 'yes';
       var scrollbars = 'yes';
       var resizable = 'yes';
       var title = "Help";
       var left = "100";
       var top = "100";
       var width = "800";
       var height = "600";
       var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
       code_search.focus();

}
	
	
function doPrint() {
	var cont_no      = "<%=cont_no%>";
	var cont_gl_seq  = "<%=cont_gl_seq%>";
    var cont_form_no = "<%=cont_form_no%>";
    
	var param  = "&cont_no="      + encodeUrl(cont_no);
		param += "&cont_gl_seq="  + encodeUrl(cont_gl_seq);
		param += "&cont_form_no=" + encodeUrl(cont_form_no);
	popUpOpen("contract_list_print.jsp?popup_flag=true"+param, 'CONTRACT_LIST_PRINT', '1000', '700');
	
}

function doRowSelect(cont_form_no, dont_form_no) {
	popUpOpen("contract_list_detail_pop.jsp?cont_no="+ "<%=cont_no%>" +"&cont_form_no="+cont_form_no +"&dont_form_no="+ dont_form_no, 'POP_UP', '800', '550');
}

function doRowSelectSuppiler(cont_form_no, dont_form_no) {
	var params = "";
    params += "&cont_form_no=" + encodeUrl(cont_form_no);
    params += "&dont_form_no=" + encodeUrl(dont_form_no);
	
	popUpOpen("document_form_regist_update.jsp?pagemove=Y&popup_flag=true&input_flag=U&flag=Y" + params, 'DONT_FORM_NAME', '800', '600');
}


	
function doSend() {
	var cont_no     = "<%=cont_no%>";
	var cont_gl_seq = "<%=cont_gl_seq%>";
	var save_flag   = "ST";
	var ct_flag   = "CC";

<%--    if("<%=info.getSession("LOGIN_FLAG")%>" == "Y") {--%>
<%--    	alert("공인인증서로 로그인 하지 않았습니다. \n등록된 인증서로 로그인하여 주세요.");--%>
<%--    	return;--%>
<%--    }--%>
	
    var cont_amt = parseInt(del_comma("<%=CONT_AMT%>"));
    var sg_type1 = "<%=SG_LEV1%>";
    
    if(sg_type1 == "8" || sg_type1 == "62"){
		if(cont_amt > 10000000){			
			if(LRTrim(document.form.stamp_tax_no.value) == "")  {
				alert("인지세번호를 입력하셔야 합니다.");
				document.form.stamp_tax_no.focus();
				return false;
			}	
				
			if(LRTrim(document.form.stamp_tax_amt_v.value) == "")  {
				alert("인지세금액을 입력하셔야 합니다.");
			    document.form.stamp_tax_amt_v.focus();
			    return false;
			}
			
			var stamp_tax_amt_v = parseInt(del_comma(form.stamp_tax_amt_v.value));
	
			if(cont_amt > 10000000 && cont_amt <= 30000000  && stamp_tax_amt_v != 20000){
				alert("계약금액 : 1천만원초과~3천만원이하\r\n인지세금액 : 2만원");
			    document.form.stamp_tax_amt_v.focus();
			    return false;
			}
			if(cont_amt > 30000000 && cont_amt <= 50000000  && stamp_tax_amt_v != 40000){
				alert("계약금액 : 3천만원초과~5천만원이하\r\n인지세금액 : 4만원");
			    document.form.stamp_tax_amt_v.focus();
			    return false;
			}
			if(cont_amt > 50000000 && cont_amt <= 100000000  && stamp_tax_amt_v != 70000){
				alert("계약금액 : 5천만원초과~1억원이하\r\n인지세금액 : 7만원");
			    document.form.stamp_tax_amt_v.focus();
			    return false;
			}
			if(cont_amt > 100000000 && cont_amt <= 1000000000  && stamp_tax_amt_v != 150000){
				alert("계약금액 : 1억원초과~10억원이하\r\n인지세금액 : 15만원");
			    document.form.stamp_tax_amt_v.focus();
			    return false;
			}
			if(cont_amt > 1000000000 && stamp_tax_amt_v != 350000){
				alert("계약금액 : 10억원초과\r\n인지세금액 : 35만원");
			    document.form.stamp_tax_amt_v.focus();
			    return false;
			}		
		}
    }
	
	
	
	

	if (confirm("전자서명 하시겠습니까?")) {
		var vendor_in_attach_no = document.form.vendor_in_attach_no.value;
		document.form.method = "POST";
		document.form.target = "childFrame";
		document.form.action = "contract_list_seller_create_send.jsp?cont_no="+ cont_no + "&save_flag="+ save_flag + "&cont_form_no="+ "<%=cont_form_no%>" + "&vendor_in_attach_no=" + vendor_in_attach_no + "&cont_gl_seq=" + cont_gl_seq+ "&ct_flag=" + ct_flag;    
		document.form.submit();
	}
}

function doList() {
	location.href = "contract_list_seller.jsp";
}


function chklogic(values, cont, dont) {
	var name = "";
	var cont_no = "<%=cont_no%>";
	var cont_form_no = cont;
	var dont_form_no = dont;
	
	if(values == true) {
		name = "Y";
	} else {
		name = "N";
	}
	
	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "contract_list_detail_send.jsp?flag=N&name="+ name +"&cont_no="+ cont_no +"&cont_form_no="+ cont_form_no +"&dont_form_no="+ dont_form_no;
	document.form.submit();
}

	function init() {
	}

	function fileDownPop(){
		var w_dim  = new Array(2);
		    w_dim  = ToCenter(400, 640);
		var w_top  = w_dim[0];
		var w_left = w_dim[1];
   		
   		var TYPE       = "NOT";
   		var attach_key = document.form.in_attach_no.value;
		var view_type  = "VI";
		var rowId      = "";

   		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');	
	}
	
	function filePop(){
   		var w_dim  = new Array(2);
		    w_dim  = ToCenter(400, 640);
		var w_top  = w_dim[0];
		var w_left = w_dim[1];
   		
   		var TYPE       = "NOT";
   		var attach_key = document.form.vendor_in_attach_no.value;
		var view_type  = "";
		var rowId      = "";
		
   		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach2",'left=' + w_left + ',top=' + w_top + ', width=620, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
	}	
	
    function setAttach(attach_key, arrAttrach, rowId, attach_count){

		document.form.vendor_in_attach_no.value  = attach_key;
		document.form.vendor_in_attach_cnt.value = attach_count;
    }	
	
	function doCONINF(){   
 
		if (confirm("서울보증보험으로 전송 하시겠습니까?")) { 
			document.form.send.value = "CONINF";
			document.form.method = "POST";
			document.form.target = "childFrame"; 
			document.form.action = "contract_list_buyer_send_bond.jsp"; 
			document.form.submit();
		} 
	}	
	
	function doFLRINF(){  
		if (confirm("서울보증보험으로 전송 하시겠습니까?")) { 
			document.form.send.value = "FLRINF";
			document.form.method = "POST";
			document.form.target = "childFrame"; 
			document.form.action = "contract_list_buyer_send_bond.jsp"; 
			document.form.submit();
		}
	}	
	
	function doRBONGU(bond_kind, bond_type_code){ 
		var cont_no = form.cont_no.value;
		var cont_gl_seq = form.cont_gl_seq.value;
		var bond_no = "";
		
		if(bond_kind == "002") bond_no = "<%=CONT_INS_NO%>";
		else bond_no = "<%=FAULT_INS_NO%>";
		
		if(bond_no != ""){
	 		var param  = "cont_no="	+  encodeUrl(cont_no); 
	 		  param  += "&cont_gl_seq=" +  encodeUrl(cont_gl_seq);
	 		  param  += "&bond_no=" +  encodeUrl(bond_no);
	 		  param  += "&bond_kind="	+  encodeUrl(bond_kind);
	 		  param  += "&bond_type_code="	+  encodeUrl(bond_type_code);
	 		var msg = "";
	 		  if(bond_type_code == "DD"){ 
	 		  	msg = "<%=text.get("CTS_003.MSG_001")%>";
	 		  }else{ 
	 		  	msg = "<%=text.get("CTS_003.MSG_002")%>";
	 		  }
			if (confirm(msg)) { 
				document.form.send.value = "RBONGU";
				document.form.method = "POST";
				document.form.target = "childFrame"; 
				document.form.action = "contract_list_buyer_send_bond.jsp?"+param; 
				document.form.submit();
			}
		}else{
			alert("해당 증권정보가 없습니다.");
			return;
		}
	}	
	function doBONVIEW(bond_type){
        var width = 1000;
    	var height = 900;
        var left = "";
		var top = "";
	
	    //화면 가운데로 배치
	    var dim = new Array(2);
	
		dim = ToCenter(height,width);
		top = dim[0];
		left = dim[1];
	
	    var toolbar = 'no'; 
	    var menubar = 'no';
	    var status = 'yes';
	    var scrollbars = 'yes';
	    var resizable = 'yes';
	    
		var cont_no = form.cont_no.value;
		var cont_gl_seq = form.cont_gl_seq.value;
		 
		var param  = "cont_no="	+  encodeUrl(cont_no); 
			param  += "&cont_gl_seq=" +  encodeUrl(cont_gl_seq);
			param  += "&bond_type=" +  encodeUrl(bond_type);
 		  
	    guarantee_pop = window.open("contract_guarantee_view.jsp?"+param, 'guarantee_pop', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	    guarantee_pop.focus();
	}	
	function fnSetComma(){
		$("#stamp_tax_amt_v").val(add_comma(del_comma($("#stamp_tax_amt_v").val()), 0));
		$("#stamp_tax_amt").val(del_comma($("#stamp_tax_amt_v").val()));
	}
	
	function onlyNumber(keycode){
		if(keycode >= 48 && keycode <= 57){
		}else {
			return false;
		}
		return true;
	}
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="init()">
<!--//전자서명 start -->
<form name='xecure'><input type=hidden name='p'></form>
<!-- script language='javascript' src='/XecureObject/xecureweb.js'></script-->
<!-- script language='javascript' src='/AnySign/anySign4PCInterface.js'></script-->
<script type="text/javascript">
document.write("<script type=\"text/javascript\" src=\"" + "/AnySign/anySign4PCInterface.js" + "?version=" + new Date().getTime() + "\"></scr"+"ipt>");
</script>
<script language='javascript'>
PrintObjectTag();
</script>

<script language='javascript'>
//alert(document.XecureWeb.GetVerInfo());
//document.writeln( accept_cert );
</script>

<script>
function fnAnySign(){
	
	var frm = document.form;
	var signedMsg = frm.signed_msg;
	
	frm.plain.value = "<%=data%>" + frm.vendor_in_attach_no.value;
	
	document.getElementById("btnSign").style.display = "none";
	Sign_with_option(0, frm.plain.value, SignDataCMS_callback);	
}

function SignDataCMS_callback(aResult) {	
	//var frm = document.form;
	//var signedMsg = frm.signed_msg;
	//signedMsg = aResult;
	
	//var save_flag   = "ST";
	//var ct_flag   = "CC";
	
	var frm = document.form;
	var signedMsg = frm.signed_msg;
	
    //document.getElementById ("form").signed_msg.value = aResult;
    signedMsg.value = aResult;
	
	if(signedMsg.value != ""){
		
		frm.method = "POST";
		frm.target = "childFrame";
		frm.action = "contract_list_seller_create_send_save.jsp";
		
		frm.submit();
			
	//if(signedMsg.value != ""){
    //if(aResult != ""){
    	//suc
//	     frm.mode.value   = "setXecureLogin";
//		 frm.browser_language.value = "KO";
//		 frm.method = "POST";
         //frm.target = "_self";	//"hiddenFrame";
         //frm.action = "/servlets/sepoa.svl.co.co_login_process";
//       frm.action = "/common/sign_result.jsp"
         //frm.action = "/XecureDemo/sign_result.jsp"
//       frm.submit();
	     //XecureSubmit(frm);
		
	}
	else{
		//fail
		alert("사용자 인증에 실패하였습니다.");
	}
}
	
	<%-- ClipReport4 리포터 호출 스크립트 --%>
	function clipPrint(rptAprvData,approvalCnt) {
		//alert(document.form.rptData.value);
		if(typeof(rptAprvData) != "undefined"){
			document.form.rptAprvUsed.value = "Y";
			document.form.rptAprvCnt.value = approvalCnt;
			document.form.rptAprv.value = rptAprvData;
	    }
	    var url = "/ClipReport4/ClipViewer.jsp";
		//url = url + "?BID_TYPE=" + bid_type;	
	    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		document.form.method = "POST";
		document.form.action = url;
		document.form.target = "ClipReport4";
		document.form.submit(); 
		cwin.focus();
	}

</script>
<!--//전자서명 end -->
<s:header>
<%-- AnySign 솔루션으로 교체
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
--%>
<form name="form" id="form" method=post>
<input type="hidden" id="cont_no"     name="cont_no"     value="<%=cont_no%>">
<input type="hidden" id="cont_gl_seq" name="cont_gl_seq" value="<%=cont_gl_seq%>">
<input type="hidden" id="save_flag"     name="save_flag"     value="ST">
<input type="hidden" id="ct_flag"     name="ct_flag"     value="CC">
<input type="hidden" id="sign_encode"     name="sign_encode"     value="C"> 
<input type="hidden" id="send"        name="send"        value="">
<input type="hidden" id="bond_no"     name="bond_no"     value="<%=FAULT_INS_NO%>">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
<textarea style="display:none" cols=120 rows=1 name='plain' id="plain"></textarea>
<textarea style="display:none" cols=120 rows=1 name='signed_msg' id="signed_msg"></textarea>

<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td style="padding:5 5 5 0" align="right" valign="bottom">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>
					<td id="btnSign" name="btnSign">
						<%--<script language="javascript">btn("javascript:doSend()","전자서명")</script>--%><script language="javascript">btn("javascript:fnAnySign()","전자서명")</script>
					</td>
					<td>
						<script language="javascript">btn("javascript:doList()","목록")</script>
					</td>
					<td>
						<script language="javascript">btn("javascript:window.clipPrint()", "출 력");</script>
						<%-- <script language="javascript">btn("javascript:doPrint()","인쇄")</script> --%>
					</td>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>
</br>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0"  bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" > 
				    		<tr>
		        				<td class="data_td" width="100%" colspan="2" >
     		    					<%=CONT_CONTENT%>
        						</td>
        	  				</tr>  
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</br>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"> 				    		   	  			
			  				<tr>	
			      				<td width="20%" height="24" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				파일보기
			      				</td>
								<td class="data_td" colspan="3" height="150" align="center">
									<table border="0" style="padding-top: 10px; width: 100%;">
										<tr>
											<td>
												<iframe id="attachFrm1" name="attachFrm1" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=in_attach_no%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
											</td>
										</tr>
									</table>
								</td>			      				
			  				</tr>	
							<tr>
								<td colspan="2" height="1" bgcolor="#dedede"></td>
							</tr>			  
							<tr>
								<td colspan="2">
									<table width="100%" border="0" cellspacing="0" cellpadding="1">
										<tr>
											<td width="20%" style="height: 24px;" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 
												인지세번호
											</td> 
											<td class="data_td" width="30%" style="height: 24px;">
												<input type="text" id="stamp_tax_no" name="stamp_tax_no" maxlength="50" style="ime-mode:disabled;">								
											</td>
											<td width="20%" style="height: 24px;" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 
												인지세금액
											</td> 
											<td class="data_td" width="30%" style="height: 24px;">
												<input type="text" id="stamp_tax_amt_v" name="stamp_tax_amt_v" maxlength="20" style="text-align: right;ime-mode:disabled;" onkeyup="javascript:fnSetComma();" onKeyPress="return onlyNumber(event.keyCode);">								
												<input type="hidden" id="stamp_tax_amt" name="stamp_tax_amt" maxlength="20" style="text-align: right;ime-mode:disabled;" onKeyPress="return onlyNumber(event.keyCode);">								
											</td>
										</tr>									
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2" height="1" bgcolor="#dedede"></td>
							</tr>			  
											
     	 	   				<tr>	
        	   					<td width="20%" height="24" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							업체파일등록
        						</td>
								<td class="data_td" >
									<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="15%">
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowid, attach_count) {
	document.getElementById("vendor_in_attach_no").value = attach_key;
	document.getElementById("attach_no_count").value = attach_count;
}

btn("javascript:attach_file(document.getElementById('vendor_in_attach_no').value, 'TEMP');", "파일등록");
</script>
											</td>
											<td>
												<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
												<input type="hidden" value="" name="vendor_in_attach_no" id="vendor_in_attach_no">
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
	</tr>
</table>

</form>
</s:header>		
<s:footer/>
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>
