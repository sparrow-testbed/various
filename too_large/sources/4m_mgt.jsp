<%
/**
 * @파일명   : 4m_mgt.jsp
 * @생성일자 : 2009. 04. 24
 * @변경이력 :
 * @프로그램 설명 : 변경점사전신고서작성
 */
%>

<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>


<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("QM_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	String cp_number	= JSPUtil.nullToEmpty(request.getParameter("cp_number"));    
	String popup_flag	= JSPUtil.nullToEmpty(request.getParameter("popup_flag"));
	
	String language = info.getSession("LANGUAGE");

    String to_day = SepoaDate.getShortDateString();
	/* String from_date = WiseDate.addWiseDateDay(to_day,-30); */
	String from_date = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-3);
	String to_date = to_day;
	

	Config conf = new Configuration();
    String buyer_company_code = conf.getString("sepoa.buyer.company.code");
	
	String attach_count     = "0";
	String attach_no        = "";	
	
	String attach_count2     = "0";
	String attach_no2        = "";

	String user_id     = info.getSession("ID");
	String department = info.getSession("DEPARTMENT");
	String name_loc = info.getSession("NAME_LOC");
	String name_eng = info.getSession("NAME_ENG");
	String user_type    = info.getSession("USER_TYPE");
	
	boolean isSupplier = false;
	boolean isBuyer = false;

	/* 문서번호가 존재하는 경우 변경신고서 조회 */
	String material_number	= "";
	String cp_flag			= "";
	String seller_code		= "";
	String seller_name		= "";
	String cp_type			= "";
	String cp_type_name		= "";
	String description_loc	= "";
	String model			= "";
	String subject			= "";
	String cp_status		= "";
	String cp_status_name	= "";
	String ctrl_code		= "";
	String ctrl_name		= "";
	//String attach_no		= "";
	//String attach_count		= "";
	String app_date			= "";//승인일자
	String add_user_name	= "";
	String add_date			= "";//등록일
	//String attach_no2		= "";
	//String attach_count2	= "";
	String remark			= "";
	String cp_result		= "";
	String cp_result_hidden	= "";
	
	if( cp_number != "" )
	{
		cp_number = request.getParameter("cp_number"); 
		
		Object[] obj = {cp_number};
		
		SepoaOut value = ServiceConnector.doService(info, "QM_006", "CONNECTION","get4mQuery", obj);
		SepoaFormater sf = new SepoaFormater(value.result[0]);
		
		if( sf.getRowCount() == 1 )
		{
			cp_number = sf.getValue("CP_NUMBER",0);         
			material_number = sf.getValue("material_number",0);        
			cp_flag = sf.getValue("cp_flag",0);                       
			seller_code = sf.getValue("seller_code",0);                      
			seller_name = sf.getValue("seller_name",0);                 
			subject = sf.getValue("subject",0);           
			attach_no = sf.getValue("attach_no",0);                       
			attach_count = sf.getValue("attach_count",0);                       
			cp_type = sf.getValue("cp_type",0);                       
			cp_type_name = sf.getValue("cp_type_name",0);                         
			description_loc = sf.getValue("description_loc",0);       
			model = sf.getValue("model",0);                         
			cp_status = sf.getValue("cp_status",0);                      
			cp_status_name = sf.getValue("cp_status_name",0);                 
     			
			ctrl_code = sf.getValue("ctrl_code",0);
			ctrl_name = sf.getValue("ctrl_name",0);
			app_date = sf.getValue("app_date",0);
			attach_no2 = sf.getValue("attach_no2",0);                   
			attach_count2 = sf.getValue("attach_count2",0); 
			remark = sf.getValue("remark",0);;
			add_date = sf.getValue("add_date",0);
			add_user_name = sf.getValue("add_user_name",0);
			cp_result = sf.getValue("cp_result",0);
			cp_result_hidden = sf.getValue("cp_result_hidden",0);
		}
	
	}
	
		
	if(user_type.equals("S")){
		isSupplier = true;
		
		seller_code = info.getSession("COMPANY_CODE");
		seller_name = info.getSession("NAME_LOC");
	}
	else
		isBuyer = true;
	
	
	if( add_user_name.equals("") || add_date.equals("") ){
	
		add_user_name = name_loc;
		//add_date = SepoaDate.getFormatString("yyyy/MM/dd");	
		add_date=to_day;	
	}		
	
	add_date = SepoaString.getDateSlashFormat(add_date);
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="../js/sec.js"></script>
<script language="javascript" src="../ajaxlib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script src="../js/cal.js" language="javascript"></script>
<Script language="javascript">
	
	function init() {

	}
	
	function initAjax(){
	
		doRequestUsingPOST( 'SL5001', 'M512' ,'cp_type', '<%=cp_type%>' );<!--변경구분-->
		doRequestUsingPOST( 'SL5001', 'M514' ,'cp_result', '<%=cp_result%>' );<!--검토결과-->
		doRequestUsingPOST( 'SL5001', 'M513' ,'cp_status', '<%=cp_status%>' );<!--진행상태-->
	}
	
	<%
	/**
	 * @메소드명 : Material_Code
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 품목코드입력 후 품명 조회
	 */
	%>
	function Material_Code(){
	
		var material_number = document.forms[0].material_number.value;
		
		if( isEmpty(material_number) )
			return;
		
		document.forms[0].mode.value = "material";
		
		document.forms[0].action="4m_mgt_hidden.jsp";
		document.forms[0].method="post";
		document.forms[0].target="hIframe";
		document.forms[0].submit();		
		
		
	}	

	<%
	/**
	 * @메소드명 : doQuery
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 조회
	 */
	%>
	function doQuery() {
	
		var cp_number        = document.forms[0].cp_number.value;
		
		if(isEmpty(cp_number)) {
			alert("<%=text.get("QM_005.0007")%>");
			document.forms[0].cp_number.focus();
			return;
		}

		if( "<%=popup_flag%>" == "true" )
			location.href = "4m_mgt.jsp?cp_number="+encodeURIComponent(cp_number)+"&popup_flag=true";
		else
			parent.body.location.href = "4m_mgt.jsp?cp_number="+encodeURIComponent(cp_number);
			

	}

	<%
	/**
	 * @메소드명 : doSave
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 저장
	 */
	%>
	function doSave(flag) {
		
		var cp_status = document.forms[0].cp_status_hidden.value;
		var cp_result = document.forms[0].cp_result.value;
		var app_date = document.forms[0].app_date.value;

		if( <%=isBuyer%> ) 
		{
			flag = "P";//업체가 저장시 N, 전송 P 로 사용하는 값이므로 구매자인 경우는 P 로 설정한다.
			
			if( cp_status == "D" )//반려
			{
				alert("<%=text.get("QM_005.0011")%>"); <!--반려되어 저장할 수 없습니다.-->
				return;
			}

			if( cp_status == "E" )//검토완료
			{
				alert("<%=text.get("QM_005.0017")%>"); <!--검토완료되었습니다.-->
				return;
			}
						
			if( cp_status == "B" )//접수대기
			{
				alert("<%=text.get("QM_005.0016")%>"); <!--접수 후에 저장할 수 있습니다.-->
				return;
			}
						
			if( cp_status == "C" && isEmpty(cp_result) )//검토중
			{
				alert("<%=text.get("QM_005.0010")%>"); <!--검토결과를 입력하세요.-->
				return;
			}
				
			if( cp_result == "A" && isEmpty(app_date) )//검토결과 승인시 승인일자 입력
			{
				alert("<%=text.get("QM_005.0008")%>"); <!--승인일자를 입력하세요.-->
				document.forms[0].app_date.focus();
				return;
			}

			if(cp_result == "A" && !checkDateCommon(app_date)) {
				alert("<%=text.get("QM_005.0009")%>");<!--승인일자를 확인하세요.-->
				document.forms[0].app_date.focus();
				return;
			}
			
			document.forms[0].mode.value = "save";
		}
		
		if( <%=isSupplier%> ) 
		{
			
			if( cp_status != "" && cp_status != "A" )
			{
				alert("<%=text.get("QM_005.0013")%>"); <!--이미 전송되었습니다.-->
				return;
			}
		}
				
		if(!checkData()) return;
		
		var msg = "";
		
		if( <%=isSupplier%> ) 
		{
			if(flag == "N"){ <!--저장-->
				msg = "<%=text.get("MESSAGE.1018")%>";
				document.forms[0].mode.value = "save";
			}
			else{<!--전송-->
				msg = "<%=text.get("MESSAGE.1019")%>";
				document.forms[0].mode.value = "send";
			}	
		}
		else
		{
				msg = "<%=text.get("MESSAGE.1018")%>";
				document.forms[0].mode.value = "save";
		
		}
		
		if (confirm(msg)){
			
			
			document.forms[0].cp_flag.value = flag;
			
		    document.forms[0].method = "POST";
		    document.forms[0].target = "hIframe";
		    document.forms[0].action = "4m_mgt_hidden.jsp";
		    document.forms[0].submit();


		}
	}


	<%
	/**
	 * @메소드명 : doReceipt
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 저장
	 */
	%>
	function doReceipt(flag) {
		
		
		var cp_status = document.forms[0].cp_status_hidden.value;
		
		if( flag == "A" && cp_status != "B" )//접수대기
		{
			alert("<%=text.get("QM_005.0014")%>"); <!--상태가 접수대기인 경우 접수할 수 있습니다.-->
			return;		
		}

		if( flag == "R" && cp_status != "B" )//접수대기
		{
			alert("<%=text.get("QM_005.0015")%>"); <!--상태가 접수대기인 경우 반려할 수 있습니다.-->
			return;		
		}
				
		var msg = "";
		
		if(flag == "A"){ <!--접수-->
		
			msg = "<%=text.get("MESSAGE.1024")%>";
			document.forms[0].mode.value = "receipt";	
		}
		else{<!--반려-->
			msg = "<%=text.get("MESSAGE.1021")%>";
			document.forms[0].mode.value = "reject";	
		}
			
		if (confirm(msg)){					
		    document.forms[0].method = "POST";
		    document.forms[0].target = "hIframe";
		    document.forms[0].action = "4m_mgt_hidden.jsp";
		    document.forms[0].submit();
		}
	}

	<%
	/**
	 * @메소드명 : doDelete
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 삭제
	 */
	%>
	function doDelete() {
		
		
		var cp_status = document.forms[0].cp_status_hidden.value;
		
		if( cp_status != "A" )//등록
		{
			alert("<%=text.get("QM_005.0020")%>"); <!--진행상태가 등록인 경우 삭제할 수 있습니다.-->
			return;		
		}

		
		if (confirm("<%=text.get("MESSAGE.1015")%>")){	
			document.forms[0].mode.value = "delete";				
		    document.forms[0].method = "POST";
		    document.forms[0].target = "hIframe";
		    document.forms[0].action = "4m_mgt_hidden.jsp";
		    document.forms[0].submit();
		}
	}


	<%
	/**
	 * @메소드명 : checkData
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 저장시 Validation 체크
	 */
	%>
	function checkData() {
	
	 	material_number = document.forms[0].material_number.value;
	 	description_loc = document.forms[0].description_loc.value;
	 	model = document.forms[0].model.value;
	 	cp_type = document.forms[0].cp_type.value;
	 	subject = document.forms[0].subject.value;
	 	ctrl_code = document.forms[0].ctrl_code.value;
	 	remark = document.forms[0].remark.value;

	 	if(isEmpty(cp_type)){
		 	alert("<%=text.get("QM_005.0004")%>");<!--변경구분을 입력하세요.-->
		 	return false;
		}
			 	
	 	if(isEmpty(material_number)){
		 	alert("<%=text.get("QM_005.0001")%>");<!--Material Number 를 입력하세요.-->
		 	document.forms[0].material_number.focus();
		 	return false;
		}

	 	if(isEmpty(description_loc)){
		 	alert("<%=text.get("QM_005.0002")%>");<!--Description 을 입력하세요.-->
		 	document.forms[0].description_loc.focus();
		 	return false;
		}

	 	if(isEmpty(model)){
		 	alert("<%=text.get("QM_005.0003")%>");<!--Model 을 입력하세요.-->
		 	document.forms[0].model.focus();
		 	return false;
		}

	 	if(isEmpty(subject)){
		 	alert("<%=text.get("QM_005.0005")%>");<!--제목 을 입력하세요.-->
		 	document.forms[0].subject.focus();
		 	return false;
		}

		
	 	if(isEmpty(ctrl_code)){
		 	alert("<%=text.get("QM_005.0006")%>");<!--구매담당자 를 입력하세요.-->
		 	document.forms[0].ctrl_code.focus();
		 	return false;
		}
		
		if( getStringLength(subject) > 100 ){
			alert("<%=text.get("QM_005.0018")%>");<!--제목은 100바이트를 초과할 수 없습니다.-->
			return;
		}
				
		if( getStringLength(remark) > 200 ){
			alert("<%=text.get("QM_005.0019")%>");<!--비고는 200바이트를 초과할 수 없습니다.-->
			return;
		}
								
		return true;
	}
		


	function entKeyDown() {
	    if(event.keyCode==13) {
	        document.forms[0].SQL.value = document.forms[0].SQL.value +" ";
	    }
	}



	<%
	/**
	 * @메소드명 : SP0216_Popup
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 구매담당자 팝업
	 */
	%>
   function SP0216_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var buyer_company_code = '<%=user_type.equals("S") ? buyer_company_code : info.getSession("COMPANY_CODE")%>';

		var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP0216&function=SP0216_getCode&values=<%=buyer_company_code%>&values=&values=";
		//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		Code_Search(url, 'sp0216', '', '', '', '');
	}

	function SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
	
		document.forms[0].ctrl_code.value = ls_ctrl_code;
		document.forms[0].ctrl_name.value = ls_ctrl_name;
	
	}

	<%
	/**
	 * @메소드명 : SP0216_Popup
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 업체에서 첨부하는 첨부파일
	 */
	%>
	
	var kind_status = "";
	
	function goAttach(attach_no, kind){
		kind_status=kind;

		if( <%=isBuyer%> ){
			FileAttach('QM',document.forms[0].attach_no.value,'VI');
		}
		else{
			attach_file(attach_no, "QM");
		}
	}

	function setAttach(attach_key, arrAttrach, attach_count) {
		
		if(kind_status== 'S'){
			document.forms[0].attach_no.value = attach_key;
			document.forms[0].attach_count.value = attach_count;
		}
		else
		{
			document.forms[0].attach_no2.value = attach_key;
			document.forms[0].attach_count2.value = attach_count;
		}
	
	}

	<%
	/**
	 * @메소드명 : goAttach2
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 구매자가 첨부하는 첨부파일
	 */
	%>
	function goAttach2(attach_no, kind){
		kind_status=kind;

		if( <%=isSupplier%> ){
			FileAttach('QM',document.forms[0].attach_no2.value,'VI');
		}
		else{
			attach_file(attach_no, "QM");
		}
	}


	 
</Script>
</head>

<body leftmargin="15" topmargin="6" onLoad="init();initAjax();">
<form name="form1" method="post" action="">

<input type="hidden" name="cp_flag" value="N">
<input type="hidden" name="cp_result_hidden" value="<%=cp_result %>">
<input type="hidden" name="cp_status_hidden" value="<%=cp_status %>">
<input type="hidden" name="mode">
<input type="hidden" value="<%=attach_no%>" name="attach_no">
<input type="hidden" value="<%=attach_no2%>" name="attach_no2">

<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

<%@ include file="/include/sepoa_milestone.jsp"%>


	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td width="15%" height="24" class="se_cell_title"><%=text.get("QM_005.CP_NUMBER")%></td>
        		<td width="20%" height="24" class="se_cell_data"><input type="text" name="cp_number" value="<%=cp_number%>" length="15"></td>
        		<td width="15%" height="24" class="se_cell_title"><%=text.get("QM_005.CP_STATUS")%></td>
        		<td width="20%" height="24" class="se_cell_data">
					<select name="cp_status" class="inputsubmit" >
						<option value=""><%=text.get("QM_005.all")%></option>
					</select>
				</td>
			  </tr>
		    </table>
 			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0" align="right">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td>
					  	  <td><script language="javascript">btn("javascript:doSave('N')","<%=text.get("BUTTON.save")%>")</script></td>
							  
					  	  <% if(isSupplier ) { %>
							  <td><script language="javascript">btn("javascript:doDelete()","<%=text.get("BUTTON.deleted")%>")</script></td>
							  <td><script language="javascript">btn("javascript:doSave('P')","<%=text.get("BUTTON.send")%>")</script></td>
						  <% }
						  else
						  { 
						  %>
							  <td><script language="javascript">btn("javascript:doReceipt('A')","<%=text.get("BUTTON.receipt")%>")</script></td>
							  <td><script language="javascript">btn("javascript:doReceipt('R')","<%=text.get("BUTTON.reject")%>")</script></td>
						  
						  <%
						  } 
						  %>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			 </TABLE>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
			<tr>
        		<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.SELLER_CODE")%></td>
        		<td width="20%" height="24" class="div_data">
					<input name="seller_code" type="text" class="input_empty" value="<%=seller_code %>" size="30" maxlength="100">        		
        		</td>
				<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.SELLER_NAME")%></td>
        		<td width="20%" height="24" class="div_data">
					<input name="seller_name" type="text" class="input_empty" value="<%=seller_name %>" size="30" maxlength="100">        		
        		</td>
				<td width="15%" height="24" align="right" class="div_input_re"><%=text.get("QM_005.CP_TYPE")%></td>
        		<td width="20%" height="24" class="div_data">
					<select name="cp_type" class="inputsubmit">
						<option value=""><%=text.get("QM_005.all")%></option>
					</select>		
        		</td>
			</tr>	
			<tr>
        		<td width="15%" height="24" align="right" class="div_input_re"><%=text.get("QM_005.MATERIAL_NUMBER")%></td>
        		<td width="20%" height="24" class="div_data">
					<input name="material_number" type="text" onblur="Material_Code()" value="<%=material_number%>" class="input_re" size="20" maxlength="20">        		
        		</td>
				<td width="15%" height="24" align="right" class="div_input_re"><%=text.get("QM_005.DESCRIPTION_LOC")%></td>
        		<td width="20%" height="24" class="div_data">
					<input name="description_loc" type="text" class="input_re"  value=<%=description_loc%>&nbsp; size="30" maxlength="100">        		
        		</td>
				<td width="15%" height="24" align="right" class="div_input_re"><%=text.get("QM_005.MODEL")%></td>
        		<td width="20%" height="24" class="div_data">
					<input name="model" type="text" class="input_re" value="<%=model%>" size="30" maxlength="100">        		
        		</td>
			</tr>	
			<tr>
        		<td width="15%" height="24" align="right" class="div_input_re"><%=text.get("QM_005.SUBJECT")%></td>
        		<td width="85%" height="24" class="div_data" colspan="5">
					<textarea name="subject" align="left" style="width:98%" cols="100" rows="3"><%=subject%></textarea>
					    		
        		</td>
			</tr>	
			<tr>
        		<td width="15%" height="24" align="right" class="div_input_re"><%=text.get("QM_005.CTRL_CODE")%></td>
        		<td width="20%" height="24" class="div_data">
        			<input type="text" name="ctrl_code" size="7" value="<%=ctrl_code %>" maxlength="15" class="inputsubmit">
					<a href="javascript:SP0216_Popup()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
					<input type="text" name="ctrl_name" size="7" value="<%=ctrl_name %>" readonly class="input_empty" >
			
			
        		</td>
				<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.ATTACH_NO")%></td>
        		<td width="20%" height="24" class="div_data" colspan="3">
				<table cellpadding="0">
					<tr>
						<td><script language="javascript">btn("javascript:goAttach(document.forms[0].attach_no.value,'S')", "<%=text.get("QM_005.button_file")%>")</script></td>
						<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" value="<%=attach_count%>" name="attach_count"><%=text.get("QM_005.file_count")%></td>
					</tr>
				</table>
				</td>
			</tr>			
			<tr>
        		<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.CP_RESULT")%></td>
        		<td width="20%" height="24" class="div_data">
					<select name="cp_result" class="inputsubmit" <%if(isSupplier){ %>disabled<%} %>>
						<option value=""><%=text.get("QM_005.all")%></option>
					</select>	    		
        		</td>
				<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.APP_DATE")%></td>
        		<td width="20%" height="24" class="div_data">
        		    <input type="text" name="app_date" size="8" value="<%=app_date%>" readOnly class=<%if(isBuyer){%>"inputsubmit"<%}else {%>"inputempty"<%} %> maxlength="8">
				    <%if(isBuyer){%>
				    <img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, app_date , 'yyyy/mm/dd')">
					<%} %>
				</td>
				<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.ATTACH_NO")%></td>
        		<td width="20%" height="24" class="div_data">
				<table cellpadding="0">
					<tr>
						<td><script language="javascript">btn("javascript:goAttach2(document.forms[0].attach_no2.value,'B')", "<%=text.get("QM_005.button_file")%>")</script></td>
						<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" value="<%=attach_count2%>" name="attach_count2"><%=text.get("QM_005.file_count")%></td>
					</tr>
				</table>       		
        		</td>
			</tr>
			<tr>
        		<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.REMARK")%></td>
        		<td width="85%" height="24" class="div_data" colspan="5">
					<textarea style=width:98% <%if(isSupplier){ %>readOnly<%} %> name="remark" value="" cols="100" rows="3"><%=remark %></textarea>
			   </td>

			</tr>
			
			<tr>
        		<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.ADD_DATE")%></td>
        		<td width="20%" height="24" class="div_data">
					<input type="text" name="add_date" value="<%=add_date%>" size="8" maxlength="8" class="input_empty">
			        	    		
        		</td>
				<td width="15%" height="24" align="right" class="div_input"><%=text.get("QM_005.ADD_USER_NAME")%></td>
        		<td width="20%" height="24" class="div_data">
        			<input type="text" name="add_user_name" value="<%=add_user_name%>" size="20" maxlength="8" class="input_empty">
			    
        		</td>
				<td width="15%" height="24" align="right" class="div_input"></td>
        		<td width="20%" height="24" class="div_data">
        		</td>
			</tr>

			</td>
		  </tr>
		</table>
	</form>
</body>

<iframe name="hIframe" width="0" height="0" border="0">
</iframe>
</html>



