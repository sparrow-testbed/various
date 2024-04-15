<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>




<%
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_contract_detail_print"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////


	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_011");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	
	String cont_no		= JSPUtil.nullToEmpty(request.getParameter("cont_no")).trim();
	String cont_gl_seq	= JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq")).trim();
	String cont_form_no	= JSPUtil.nullToEmpty(request.getParameter("cont_form_no")).trim();
	String ct_flag		= JSPUtil.nullToEmpty(request.getParameter("ct_flag")).trim();
	String btn			= JSPUtil.nullToEmpty(request.getParameter("btn")).trim();
	String seller_flag	    = JSPUtil.nullToEmpty(request.getParameter("seller_flag")).trim();
	String seller_code_text	= JSPUtil.nullToEmpty(request.getParameter("seller_code_text")).trim();
	String exec_no			= JSPUtil.nullToEmpty(request.getParameter("exec_no")).trim();
	
	String CONT_CONTENT = "";
	
	String contractstatus	= "계약진행중";
	
	Logger.sys.println("cont_no      = " + cont_no);
	Logger.sys.println("cont_gl_seq  = " + cont_gl_seq);
	Logger.sys.println("cont_form_no = " + cont_form_no);
	Logger.sys.println("ct_flag      = " + ct_flag);
	Logger.sys.println("btn          = " + btn);
	Logger.sys.println("seller_code_text          = " + seller_code_text);
	Object[] obj       = {cont_no, cont_gl_seq};
	SepoaOut value     = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractFormSelectSCPMT", obj);
	SepoaFormater wf11 = new SepoaFormater(value.result[0]);
	
	if( wf11.getRowCount() > 0 ){
		CONT_CONTENT       = JSPUtil.nullToEmpty(wf11.getValue("CONTENT", 0));
	}
	
	Object[] obj1 = {cont_no, cont_gl_seq};
	SepoaOut value1 = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractContNoSelect", obj1);
	SepoaFormater wf2 = new SepoaFormater(value1.result[0]);
	String CONT_INS_VN = JSPUtil.nullToEmpty(wf2.getValue("CONT_INS_VN",0));//보증사구분 type = 'M225'
	String CONT_INS_NO = JSPUtil.nullToEmpty(wf2.getValue("CONT_INS_NO",0));//계약이행번호
	String FAULT_INS_NO = JSPUtil.nullToEmpty(wf2.getValue("FAULT_INS_NO",0));//하자이행번호
	String CONT_INS_FLAG = JSPUtil.nullToEmpty(wf2.getValue("CONT_INS_FLAG",0));//계약이행계약서 전송상태
	String FAULT_INS_FLAG = JSPUtil.nullToEmpty(wf2.getValue("FAULT_INS_FLAG",0));//하자이행계약서 전송상태

	String STAMP_TAX_NO = JSPUtil.nullToEmpty(wf2.getValue("STAMP_TAX_NO",0));//인지세번호
	String STAMP_TAX_AMT = JSPUtil.nullToEmpty(wf2.getValue("STAMP_TAX_AMT",0));//인지세금액

	String seller_code						= "";
	String in_attach_no						= "";
	String vendor_in_attach_no              = "";
	
    if(wf2.getRowCount() > 0) {
    	seller_code						= JSPUtil.nullToEmpty(wf2.getValue("seller_code",0));//업체코드
    	in_attach_no					= JSPUtil.nullToEmpty(wf2.getValue("ATTACH_NO",0));//첨부파일
    	vendor_in_attach_no				= JSPUtil.nullToEmpty(wf2.getValue("SE_ATTACH_NO",0));//업체첨부파일
	}

	String in_woori_sign_name		= "";//우리은행 싸인
	String in_vendor_sign_name		= "";//업체 싸인
	
	if( "CC".equals(ct_flag) || "CD".equals(ct_flag) ) { // 업체인증, 우리은행서명
	    Object[] obj2 = {"W100", seller_code};
		SepoaOut value2 = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractsignSelect", obj2);
		SepoaFormater wf3 = new SepoaFormater(value2.result[0]);
		
	    if(wf3.getRowCount() > 0) {
	    	if( "CC".equals(ct_flag) )   in_vendor_sign_name  = JSPUtil.nullToEmpty(wf3.getValue("VENDOR_SIGN_NAME",0));
	    	if( "CD".equals(ct_flag) )   {
	    		in_woori_sign_name	 = JSPUtil.nullToEmpty(wf3.getValue("WOORI_SIGN_NAME",0));
	    		in_vendor_sign_name  = JSPUtil.nullToEmpty(wf3.getValue("VENDOR_SIGN_NAME",0));
	    	}	
	    }	
    }
	Logger.sys.println("in_woori_sign_name  = " + in_woori_sign_name);
	Logger.sys.println("in_vendor_sign_name = " + in_vendor_sign_name);
	Logger.debug.println( info.getSession("ID"), this, "==================== in_woori_sign_name : " + in_woori_sign_name );
	Logger.debug.println( info.getSession("ID"), this, "==================== in_vendor_sign_name : " + in_vendor_sign_name );
																			
	if(in_vendor_sign_name.length()	> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<IMG height=60 src=\"https://dev.wooriepro.com/poasrm/sign/blank.gif\" width=60 name=vendor_sign>",		"<IMG name=vendor_sign src=https://dev.wooriepro.com/poasrm/sign/"+in_vendor_sign_name+" width=60 height=60>");
	if(in_woori_sign_name.length()	> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<IMG height=60 src=\"https://dev.wooriepro.com/poasrm/sign/blank.gif\" width=60 name=woori_sign>",		"<IMG name=woori_sign src=https://dev.wooriepro.com/poasrm/sign/"+in_woori_sign_name+" width=60 height=60>");
			
														
  	String screen_id="";
  	Configuration conf = new Configuration();
	String domain = conf.getString("sepoa.system.domain.name");
  	
  	
	if(btn.equals("send")) {
		screen_id = "CT_011_1";
	}
	else if(btn.equals("delete")) {
		screen_id = "CT_011_3";
	}
	else if(btn.equals("wori") || btn.equals("abol")) {
		screen_id = "CT_011_2";
	}
	else
		screen_id = "CT_011_4";
													                       
	//Logger.sys.println("CONT_CONTENT = " + CONT_CONTENT);
	
	
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

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<SCRIPT language=javascript src="../include/attestation/TSToolkitConfig.js"></script>
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
		var cont_form_no   = "<%=cont_form_no%>";
		var cont_no        = "<%=cont_no%>";
		var cont_gl_seq    = "<%=cont_gl_seq%>";
		var ct_flag        = "<%=ct_flag%>";
		
		var param = "&cont_form_no="        + encodeUrl(cont_form_no);
			param = param + "&cont_no="     + encodeUrl(cont_no);		
			param = param + "&cont_gl_seq=" + encodeUrl(cont_gl_seq);
			param = param + "&ct_flag="     + encodeUrl(ct_flag);
				
		popUpOpen("contract_list_print.jsp?popup_flag=true"+param, 'CONTRACT_LIST_PRINT', '1000', '700');
	}

	function setContractSave() {
		if (confirm("전자계약을 생성 하시겠습니까?")) {
			document.form.method = "POST";
			document.form.target = "childFrame";
			document.form.action = "contract_make_insert_save.jsp";
			document.form.submit();
		}
	}
	
	//업체전송
	function doSend() {
	
	
		if (confirm("전자계약을 전송 하시겠습니까?")) {
			
			document.form.send.value = "Y";
			document.form.method     = "POST";
			document.form.target     = "childFrame";
			document.form.action     = "contract_list_buyer_send.jsp";
			document.form.submit();
		}
	}
	
	function doDelete() {
		if (confirm("전자계약을 폐기 하시겠습니까?")) {
			document.form.send.value = "N";
			document.form.method     = "POST";
			document.form.target     = "childFrame";
			document.form.action     = "contract_list_buyer_send.jsp";
			document.form.submit();
		}
	}
	   
	function doSign() {
		if (confirm("우리은행서명 하시겠습니까?")) {
			document.getElementById("btnSign").style.display = "none";
			document.form.ct_flag.value = "CD";
			document.form.method = "POST";
			document.form.target = "childFrame";
			//document.form.action = "contract_list_buyer_create_send.jsp";//클라이언트
			document.form.action = "contract_list_buyer_create_send_server.jsp";//서버
			document.form.submit();
		}
	}
	
	function doSign2() {
		if (confirm("폐기서명 하시겠습니까?")) {
			document.getElementById("btnSign2").style.display = "none";
			document.form.ct_flag.value = "CD";
			document.form.method = "POST";
			document.form.target = "childFrame";
			//document.form.action = "contract_list_buyer_create_send.jsp";//클라이언트
			document.form.action = "contract_list_buyer_abol_send_server.jsp";//서버
			document.form.submit();			
		}
	}
	
	function goPage() {
		<%if("true".equals(seller_flag)){ %>
		location.href = "contract_list_seller_info.jsp";
		<%}else{%>
		location.href = "contract_list.jsp";
		<%}%>
	}

	function fileDownPop( gubun ){
		var w_dim  = new Array(2);
		    w_dim  = ToCenter(400, 640);
		var w_top  = w_dim[0];
		var w_left = w_dim[1];
   		
   		var TYPE       = "NOT";
   		var attach_key = "";
   		
   		if( gubun == "vendor" ) attach_key = document.form.vendor_in_attach_no.value;
   		else                    attach_key = document.form.in_attach_no.value;
   		
		var view_type  = "VI";
		var rowId      = "";

   		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');	
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
		 
	 		var param  = "cont_no="	+  encodeUrl(cont_no); 
	 		  param  += "&cont_gl_seq=" +  encodeUrl(cont_gl_seq);
	 		  param  += "&bond_no=" +  encodeUrl(bond_no);
	 		  param  += "&bond_kind="	+  encodeUrl(bond_kind);
	 		  param  += "&bond_type_code="	+  encodeUrl(bond_type_code);
	 		var msg = "";
	 		  if(bond_type_code == "DD"){ 
	 		  	msg = "<%=text.get("CT_011.MSG_001")%>";
	 		  }else{ 
	 		  	msg = "<%=text.get("CT_011.MSG_002")%>";
	 		  }
			if (confirm(msg)) { 
				document.form.send.value = "RBONGU";
				document.form.method = "POST";
				document.form.target = "childFrame"; 
				document.form.action = "contract_list_buyer_send_bond.jsp?"+param; 
				document.form.submit();
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
	
</Script>
<style>
.scroll {
	scrollbar-face-color: #E5E5E5;
	scrollbar-shadow-color: #E5E5E5;
	scrollbar-highlight-color: #E5E5E5;
	scrollbar-3dlight-color: #ffffff;
	scrollbar-darkshadow-color: #ffffff;
	scrollbar-track-color: #F8F8F8;
	scrollbar-arrow-color: #ffffff;
}

</style>
</head>

<body leftmargin="15" topmargin="6">
<s:header>
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
<form name="form">
<input type="hidden" id="exec_no"      		name="exec_no"      		value="<%=exec_no%>">
<input type="hidden" id="cont_no"      		name="cont_no"      		value="<%=cont_no%>">
<input type="hidden" id="cont_gl_seq"  		name="cont_gl_seq"  		value="<%=cont_gl_seq%>">
<input type="hidden" id="cont_form_no" 		name="cont_form_no" 		value="<%=cont_form_no%>">
<input type="hidden" id="seller_code"  		name="seller_code"  		value="<%=seller_code%>">
<input type="hidden" id="seller_code_text"  name="seller_code_text"  	value="<%=seller_code_text%>">
<input type="hidden" id="send"         		name="send"         		value="">
<input type="hidden" id="bond_no"      		name="bond_no"      		value="">
<input type="hidden" id="ct_flag"      		name="ct_flag"      		value="">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
<%
// 	String title        = "";
// 	thisWindowPopupFlag = "true";
	
// 	if( "N".equals(btn) )	title = "계약서조회";
// 	else	   				title = "계약서작성";
	
// 	thisWindowPopupScreenName = title; 
// 	//String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
// 	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

<%@ include file="/include/sepoa_milestone.jsp"%>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table> 

<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td style="padding:5 5 5 0">
			<%if(info.getSession("USER_TYPE").equals("S")){ %>
			<TABLE cellpadding="2" cellspacing="0">
				<TR> 
					<td><input type="button" onClick="javascript:doCONINF()" value="<%=text.get("CT_011.CONINF_SEND")%>" style="width:120; background-color:white;"></td>
					<td><input type="button" onClick="javascript:doRBONGU('002','DD')" value="<%=text.get("CT_011.RBONGU_002_DD")%>" style="width:120; background-color:white;"></td>
					<%if(ct_flag.equals("CL")) {%>
					<td><input type="button" onClick="javascript:doRBONGU('002','DE')" value="<%=text.get("CT_011.RBONGU_002_DE")%>" style="width:120; background-color:white;"></td> 
					<%}
					if(!CONT_INS_NO.equals("")){ %>
					<td><input type="button" onClick="javascript:doBONVIEW('002')" value="계약보증서보기" style="width:120; background-color:white;"></td> 
					<%} %>
				</TR>
				<TR> 
					<td><input type="button" onClick="javascript:doFLRINF()" value="<%=text.get("CT_011.FLRINF_SEND")%>" style="width:120; background-color:white;"></td>
					<td><input type="button" onClick="javascript:doRBONGU('003','DD')" value="<%=text.get("CT_011.RBONGU_003_DD")%>" style="width:120; background-color:white;"></td>
					<%if(ct_flag.equals("CL")) {%>
					<td><input type="button" onClick="javascript:doRBONGU('003','DE')" value="<%=text.get("CT_011.RBONGU_003_DE")%>" style="width:120; background-color:white;"></td> 
					<%}
					if(!FAULT_INS_NO.equals("")){ %>
					<td><input type="button" onClick="javascript:doBONVIEW('003')" value="하자보증서보기" style="width:120; background-color:white;"></td>  
					<%} %>
				</TR>
			</TABLE>
			<%} %>
		</td>
		<td style="padding:5 5 5 0" align="right" valign="bottom">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>  
					<td ><script language="javascript">btn("javascript:clipPrint()", "출 력");</script></td>
        			<%-- <td><script language="javascript">btn("javascript:doPrint()","인쇄")</script></td> --%> 
					<% if(btn.equals("send")) { %>
					<td><script language="javascript">btn("javascript:doSend()","전송")</script></td>
					<% }%>
					<% if(btn.equals("delete")) { %>
					<td><script language="javascript">btn("javascript:doDelete()","폐기")</script></td>
					<% }%>
					<% if(btn.equals("wori")) { %>
					<td id="btnSign" name="btnSign"><script language="javascript">btn("javascript:doSign()","우리은행서명")</script></td>
					<% }%>
					<% if(btn.equals("abol")) { %>
					<td id="btnSign2" name="btnSign2"><script language="javascript">btn("javascript:doSign2()","폐기서명")</script></td>
					<% }%>
					<% if(!seller_flag.equals("app")){ %>
					<td><script language="javascript">btn("javascript:goPage()","목록")</script></td>
					<% }%>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>
	    
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
				    		<tr>
		        				<td class="data_td" width="100%" style="height: 500px;" colspan="2" >
       		     					<%-- div style="width:100%; height:100%; overflow-x;scroll; overflow-y:scroll; word-break:break-all;" class="scroll" --%>
       		    						<%=CONT_CONTENT%>
       		       					<%-- /div --%>
        						</td>
        	  				</tr>  
							<tr>
								<td colspan="2" height="1" bgcolor="#dedede"></td>
							</tr>        	  				
			  				<tr>	
			      				<td width="20%" height="24" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				파일보기
			      				</td>
								<td width="80%" class="data_td" height="150" align="center">
									<table border="0" style="padding-top: 10px; width: 100%;">
										<tr>
											<td>
												<input type="hidden" id="in_attach_no" name="in_attach_no" value="<%=in_attach_no%>"/>
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
												<input type="text" id="stamp_tax_no" name="stamp_tax_no" maxlength="50" style="ime-mode:disabled;" value="<%=STAMP_TAX_NO%>">								
											</td>
											<td width="20%" style="height: 24px;" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 
												인지세금액
											</td> 
											<td class="data_td" width="30%" style="height: 24px;">
												<input type="text" id="stamp_tax_amt_v" name="stamp_tax_amt_v" maxlength="20" style="text-align: right;ime-mode:disabled;" onkeyup="javascript:fnSetComma();" onKeyPress="return onlyNumber(event.keyCode);" value="<%=SepoaMath.SepoaNumberType(STAMP_TAX_AMT, "###,###,###,###,###,###,###") %>">								
												<input type="hidden" id="stamp_tax_amt" name="stamp_tax_amt" maxlength="20" style="text-align: right;ime-mode:disabled;" onKeyPress="return onlyNumber(event.keyCode);"  value="<%=STAMP_TAX_AMT%>">								
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
        							업체파일보기
        						</td>
        						
								<td width="80%" class="data_td" height="150" align="center">
									<table border="0" style="padding-top: 10px; width: 100%;">
										<tr>
											<td>
												<input type="hidden" id="vendor_in_attach_no" name="vendor_in_attach_no" value="<%=vendor_in_attach_no%>"/>
												<iframe id="attachFrm2" name="attachFrm2" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=vendor_in_attach_no%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
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