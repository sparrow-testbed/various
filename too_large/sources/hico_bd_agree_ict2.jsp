<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%SepoaInfo info = SepoaSession.getAllValue(request); %>

<%
	String toDays = SepoaDate.getShortDateString();

	info = SepoaSession.getAllValue(request);
	// 2011.08.18 HMCHOI
	// 협력업체 신규회원 가입시에만 ID 및 기타 세션을 DUMP 세션으로 대치한다.
	//info = new WiseInfo(info.getSession("HOUSE_CODE"),"ID=IF^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	
	SepoaSession.putValue(request, "HOUSE_CODE", "000");
	SepoaSession.putValue(request, "MENU_PROFILE_CODE", "MUP141000002");
	SepoaSession.putValue(request, "ID", "IF");
	SepoaSession.putValue(request, "LANGUAGE", "KO");
	SepoaSession.putValue(request, "NAME_LOC", "SUPPLY");
	SepoaSession.putValue(request, "NAME_ENG", "SUPPLY");
	SepoaSession.putValue(request, "DEPT", "ALL");
	
	String FromSite = JSPUtil.nullToEmpty(request.getParameter("FromSite"));	// 총무부/ICT지원센터 구분
	
	//공급사,제조사 구분
	String gbGJ     = JSPUtil.nullToEmpty(request.getParameter("rdoGJ"));

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<title>우리은행 IT전자입찰시스템</title>
<script language="JavaScript">
//<!--
	var toDays = "<%=toDays%>";
	
	function MM_callJS(jsStr) { //v2.0
	    return eval(jsStr)
	}

	function not_agree(){
	    alert("약관에 동의하지 않으면 사용자 등록을 하실 수 없습니다");
	    return false;
	    window.close();
	}

	function do_agree(irs_no, resident_no, status, sg_type){
	    form1.irs_no.value 		= irs_no;
	    form1.resident_no.value = resident_no;
	    form1.status.value 		= status;
	    form1.sg_type.value 	= sg_type;	    
	    <% if("G".equals(gbGJ)){ %>
	    	form1.action            = "ven_bd_con_ict.jsp";
		<% }else if("J".equals(gbGJ)){ %>
			form1.action            = "ven_bd_con_j_ict.jsp";
		<% } %>					
	    form1.submit();
	}

	//사업자등록번호 체크
	function checkDupIrsNo() {

		//var url = "checkDupIrsNo.jsp";
		//var width = 400;
		//var height = 200;
		//var left = 250;
		//var top = 100;
	        //
		//var toolbar = 'no';
		//var menubar = 'no';
		//var status = 'yes';
		//var scrollbars = 'yes';
		//var resizable = 'no';
		//var Duplicate = window.open( url, 'Duplicate', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', location=no, menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

		//this.hiddenfram.location.href= "checkDupIrsNo.jsp?irs_no=" + ;
	}

	//사업자등록번호 체크
	function doCheck(){
	    var irs_no  	= form1.irs_no.value;
		var resident_no = form1.resident_no.value;
		var message ="";
		if(irs_no != "" && resident_no != ""){
			alert("한 가지만 입력해 주세요.");
			return;
		}
	    //'-' 제거
        var irsNo = delStr(irs_no);
        var residentNo = delStr(resident_no);
        form1.irs_no.value = irsNo;
        form1.resident_no.value = residentNo;
        
        
        <% if("G".equals(gbGJ)){ %>
	        if(residentNo != ""){
				if(!Resident_chk(residentNo.substring(0,6))){
					//alert("유효하지 않은 주민등록 번호 입니다.");
					return;
				}
				if(residentNo.substring(6,7)!= 1 && residentNo.substring(6,7)!= 2 ){
	
					alert("주민등록번호 7번째 자리는 1이나 2로 시작되는 번호만이 유효합니다.");
					document.form1.resident_no.value="";
				    document.form1.resident_no.focus();
					return;
				}
	
				if(!checkResidentNo(residentNo)){
					return;
				}
	
			}else{
		    	var message = isValidIrsNo(irs_no);
		    	if(message != "SUCCESS") {
					alert(message);
					return;
				}
		    }
		<% }else if("J".equals(gbGJ)){ %>
		    var irsNo = delStr(irs_no);
		    form1.irs_no.value = irsNo;
			if(!IsTel(irsNo)){
				alert(form1.irs_no.value);
				return;
			}
		<% } %>		
        
        /*
        if (!document.getElementById('rdoWin7').checked && !document.getElementById('rdoWin10').checked)
    	{
    		alert("OS(운영체재)를 선택하세요.");
    		return;
    	}
        */
        /*
        var win_gb = "";
    	if(document.getElementById('rdoWin7').checked){
    		win_gb = "win7";    
    	}else{
    		win_gb = "win10";
    	}
    	*/
        
        
		var mode = irsNo == "" ? "resident_no" : "irs_no";
		form1.mode.value = mode;
		this.hiddenframe.location.href="checkDupIrsNo_ict.jsp?irs_no="+irsNo+"&resident_no="+residentNo+"&mode="+mode;
	    //location.href="checkDupIrsNo.jsp?irs_no="+irsNo+"&resident_no="+residentNo+"&mode="+mode;
	}
	
	function os_un_select()
	{
		/*
		signform.rdoWin7.checked = false;
		signform.rdoWin10.checked = false;
		*/
		document.getElementById('rdoWin7').checked = false;
	    document.getElementById('rdoWin10').checked = false;
		
	    document.getElementById('divIrsNo').style.visibility = 'hidden';
	}
	
	function doAgr(){
	    if(!document.form1.ckbFg1.checked){
			alert("IT전자입찰시스템 이용 약관(필수)에 동의해 주세요.");
			document.form1.ckbFg1.focus();
			return;
		}
	    
	    /* if(!document.form1.ckbFg2.checked){
			alert("Clean계약 이행 확약서(필수)에 동의해 주세요.");
			document.form1.ckbFg2.focus();
			return;
		} */
	    
	    if(!document.form1.ckbFg3.checked){
			alert("개인정보처리방침(필수)에 동의해 주세요.");
			document.form1.ckbFg3.focus();
			return;
		}
	    
	    if(!document.form1.ckbFg4.checked){
			alert("개인정보 수집 및 이용(필수-사용자대리인용)에 동의해 주세요.");
			document.form1.ckbFg4.focus();
			return;
		}
	    
	    if(!document.form1.ckbFg5.checked){
			alert("개인정보 수집 및 이용(필수-영업담당자용)에 동의해 주세요.");
			document.form1.ckbFg5.focus();
			return;
		}
		
	    document.getElementById('divIrsNo').style.visibility = 'visible';	 
		//var mode = irsNo == "" ? "resident_no" : "irs_no";
		//form1.mode.value = mode;
		//this.hiddenframe.location.href="checkDupIrsNo_ict.jsp?irs_no="+irsNo+"&resident_no="+residentNo+"&mode="+mode;
	    //location.href="checkDupIrsNo.jsp?irs_no="+irsNo+"&resident_no="+residentNo+"&mode="+mode;
	}

	function isValidIrsNo(irs_no) {
		if(irs_no.length == 0) {
			return "사업자등록번호를 입력하셔야 합니다.";
		}
		if(!isNumberCommon(irs_no)) {
			return "사업자등록번호에 문자열이 들어있습니다. ";
		}
		if(!(irs_no.length == 10)) {
			return "사업자등록번호의 자리수가 틀립니다.(사업자등록번호 = 10자리)";
		}
		
		var err = isValidOffNum(irs_no);
		if( err == "false" )    return "유효한 사업자등록번호가 아닙니다.";

		return "SUCCESS";
	}

	/*
	*주민번호 앞자리 유효성 체크
	*/
	function Resident_chk(resident_no){

		var t_year =toDays.substring(2,4);

		var rNo_year = resident_no.substring(0,2);
		var rNo_month = resident_no.substring(2,4);
		var rNo_date = resident_no.substring(4,6);

		var i = 1;

		if(rNo_year=="00"||rNo_month=="00"||rNo_date=="00"){
			alert("주민번호 앞자리의 생년월일을 형식에 맞게 입력해 주세요.");
			document.form1.resident_no.value="";
			return false;
		}

		if(rNo_year.substring(0,1)=="0"){

			rNo_year = rNo_year.substring(1,3);
		}
		if (t_year.substring(2,3)=="0"){

			t_year =  t_year.substring(2,4);
		}
		if(rNo_year < 40){

			alert("주민번호 앞자리의 년도를 정확히 입력해 주세요.");
			document.form1.resident_no.value="";
			return false;
		}

		if(rNo_month.substring(0,1)=="0"){
			rNo_month = rNo_month.substring(1,3);

		}
		if(rNo_month > 12 || rNo_month < i){
			alert("주민번호 앞자리의 달을 형식에 맞게 입력해 주세요.");
			document.form1.resident_no.value="";
			return false;
		}
		if(rNo_date.substring(0,1)=="0"){
			rNo_date = rNo_date.substring(1,3);

		}
		if(rNo_date > 31 || rNo_date < i){
			alert("주민번호 앞자리의 날짜를 형식에 맞게 입력해 주세요.");
			document.form1.resident_no.value="";
			return false;
		}
		return true;
	}

	/*
	*주민번호 유효성 체크
	*/
	function CheckNum(birth, code)
	{
	 	var answer=0;
	 	var i=2;
 		var allcode=birth.concat(code); // 두개의 문자열을 하나로 만듭니다.

		// 공식에 의한 결과를 answer에 저장.
	 	for(var a=0;a<allcode.length-1;a++) {

	 	answer+=parseInt(allcode.charAt(a))*i;
	 	 i++;
	 	 if(i>9) i=2;
	 	}

	 	var error=((11-(answer%11))==code.charAt(code.length-1))?true:false;
		return error;
	}




	function isValidOffNum(input){
	        tmpStr = input;
	        tmpSum = new Number(0);
	        tmpMod = new Number(0);
	        resValue = new Number(0);
	        var intOffNo = new Array(0,0,0,0,0,0,0,0,0,0);
	        var strChkNum = new Array(1,3,7,1,3,7,1,3,5);

	        for(i = 0 ; i < 10 ; i ++){
	            intOffNo[i] = new Number(tmpStr.substring(i, i+1));
	        }
	        for(i = 0 ; i < 9 ; i ++){
	            tmpSum = tmpSum + (intOffNo[i]*strChkNum[i]);
	        }

	        tmpSum = tmpSum + ((intOffNo[8]*5)/10);
	        tmpMod = parseInt(tmpSum%10, 10);

	        if(tmpMod == 0){
	            resValue = 0;
	        }
	        else{
	            resValue = 10 - tmpMod;
	        }

	        if(resValue == intOffNo[9]){
	            return "true";
	        }else{
	            //alert('유효한 사업자등록번호가 아닙니다');
	            //input.select();
	            return "false";
	        }
    	}

    	function delStr(checkStr)
    	{
	        var str = "";
	        checkStr = checkStr.toString();
	        for (i = 0;i < checkStr.length;i++)
	        {
	            ch = checkStr.charAt(i);
	            if (ch != "-")
	            {
	                str = str + ch;
	            }
	        }
	        return str;
    	}
    	function checkObject(){
    		try
			{
				var xObj = new ActiveXObject("WiseGrid.WiseGridCtrl.1");

				if(xObj)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			catch(ex)
			{
				return true;
			}
    	}
    	
    	function ckbFgAll_onclick(){
    		if(document.forms[0].ckbFgAll.checked){
    			document.form1.ckbFg1.checked = true;
    			document.form1.ckbFg2.checked = true;
    			document.form1.ckbFg3.checked = true;
    			document.form1.ckbFg4.checked = true;
    			document.form1.ckbFg5.checked = true;
    		}else{
    			document.form1.ckbFg1.checked = false;
    			document.form1.ckbFg2.checked = false;
    			document.form1.ckbFg3.checked = false;
    			document.form1.ckbFg4.checked = false;
    			document.form1.ckbFg5.checked = false;
    		}    		
    	}
    	
    	function ankFg_onclick(flag){
    		if(flag == 1){    			
    			window.open("hico_bd_agree1_ict2.jsp?flag=1",'hico_bd_agree1_ict2','width=850,height=660,left=40,top=20,resizable=yes')
    		}else if(flag == 2){    			
    			window.open("hico_bd_agree2_ict2.jsp?flag=1",'hico_bd_agree1_ict2','width=850,height=660,left=40,top=20,resizable=yes')
    		}else if(flag == 3){    			
    			window.open("hico_bd_agree3_ict2.jsp?flag=1",'hico_bd_agree1_ict2','width=850,height=660,left=40,top=20,resizable=yes')
    		}else if(flag == 4){    			
    			window.open("hico_bd_agree4_ict2.jsp?flag=1",'hico_bd_agree1_ict2','width=850,height=660,left=40,top=20,resizable=yes')
    		}else if(flag == 5){    			
    			window.open("hico_bd_agree5_ict2.jsp?flag=1",'hico_bd_agree1_ict2','width=850,height=660,left=40,top=20,resizable=yes')
    		}    		
    	}
//-->
</script>
</head>

<body>

<form name="form1" method="post">
	<input type="hidden" name="status">
	<input type="hidden" name="mode" value="">
	<input type="hidden" name="sg_type">
	<input type="hidden" name="gbGJ" value="<%=gbGJ%>">
	<iframe name="hiddenframe" src="" width="0" height="0"></iframe>
			<div id="divIrsNo" style="POSITION:absolute; WIDTH:400px; HEIGHT:100px; VISIBILITY:hidden; TOP:300px; LEFT:250px;">
				<table style="BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid">
					<tr>
						<td align="middle" height="20" width="400" colspan="3">
							&nbsp;
						</td>						
					</tr>
					<tr>
						<td width="120" class="gray" align="right">
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<% if("G".equals(gbGJ)){ %>
									<td align="middle" >
										사업자등록번호&nbsp;&nbsp;
									</td>
									<% }else if("J".equals(gbGJ)){ %>
									<td align="middle" >
										핸드폰번호&nbsp;&nbsp;
									</td>
									<% } %>																	
								</tr>
								<tr>
									<td>&nbsp; </td>
								</tr>
							</table>
						
						</td>
						<td width="280" height="29" bgcolor="#FFFFFF" class="gray2" colspan="2">
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<% if("G".equals(gbGJ)){ %>
										&nbsp;<input type="text" name="irs_no" id="irs_no" class="input2" maxlength="10" style="width:120px;" />
										<% }else if("J".equals(gbGJ)){ %>
										&nbsp;<input type="text" name="irs_no" id="irs_no" class="input2" maxlength="11" style="width:120px;" />
										<% } %>	
									</td>									
								</tr>
								<tr>									
									<% if("G".equals(gbGJ)){ %>
									<td>&nbsp; (개인, 법인 사업자 입력!) -없이 입력하여 주십시오.</td>
									<% }else if("J".equals(gbGJ)){ %>
									<td>&nbsp; -없이 입력하여 주십시오. </td>
									<% } %>		
								</tr>								
							</table>
						</td>
					</tr>
					<tr style="display:none;">
						<td width="120" class="gray" align="right">주민등록번호</td>
						<td width="280" height="29" bgcolor="#FFFFFF" class="gray2" colspan="2">
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										&nbsp;<input type="text" name="resident_no" id="resident_no" class="input2" maxlength="13" style="width:120px;" />
									</td>									
								</tr>
								<tr>
									<td>&nbsp; (프리랜서만 입력!) -없이 입력하여 주십시오.</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="middle" height="20" width="400" colspan="3">
							&nbsp;
						</td>						
					</tr>
										
					<tr style="display:none;">
					    <td align="right">
					    	운영체재(OS)구분&nbsp;&nbsp;
						</td>		    			
						<td colspan="2">
							<input value="win7" name="rdoWin" id="rdoWin7" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 7</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input value="win10" name="rdoWin" id="rdoWin10" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 10</span>
						</td>				
					</tr>
					<tr style="display:none;">
						<td colspan="3">
							&nbsp;
						</td>
					</tr>	
					
					
							
					<tr>
						<td align="right" height="20" width="120">
							&nbsp;
						</td>						
						<td align="right" height="20" width="100">
							<script language="javascript">btn("javascript:doCheck();","확 인")</script>
						</td>
						<td align="left" height="20" width="180">
							<script language="javascript">btn("javascript:os_un_select();", "닫 기")</script>
						</td>						
					</tr>	
					<tr>
						<td align="middle" height="20" width="400" colspan="3">
							&nbsp;
						</td>						
					</tr>										
				</table>
			</div>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="bg_popup">
		<tr>
			<td width="20">&nbsp;</td>
			<td valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td height="8"></td>
					</tr>
					<tr>
						<td height="35" class="title_page">
							약관동의
						</td>
					</tr>
				</table>
				<table width="99%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td height="3"></td>
					</tr>
				</table>
				
									
				<table width="940" height="1" bgcolor="#1e97d1" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td></td>
					</tr>
				</table>				
				<br />
				<table width="940" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td height="1" colspan="4" bgcolor="#1e97d1"></td>
						</tr>
						<tr>
							<td height="29" width="200" bgcolor="#ebf5fa" class="bluebold">								
								&nbsp;&nbsp;전체 동의&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="ckbFgAll"  onclick="javascript:ckbFgAll_onclick();"/>								
							</td>
							<td width="120" bgcolor="#ebf5fa" class="bluebold"><script language="javascript">btn("javascript:doAgr()","동의합니다")</script></td>
							<td width="120"bgcolor="#ebf5fa" class="bluebold"><script language="javascript">btn("javascript:window.close()","동의하지 않습니다")</script></td>
							<td align="right" bgcolor="#ebf5fa">&nbsp;</td>
						</tr>
						<tr>
							<td height="1" colspan="4" bgcolor="#c4d6e4"></td>
						</tr>
				</table>
				<table width="99%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td height="3"></td>
					</tr>
				</table>
					<table width="940" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td height="1" colspan="4">&nbsp;</td>
						</tr>
						<tr>
							<td height="129" >
								<iframe src="hico_bd_agree1_ict2.jsp?flag=2" style="WIDTH: 800px; HEIGHT: 120px;BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid"></iframe>								
							</td>
							<td height="129" >&nbsp;&nbsp;동의&nbsp;&nbsp;<input type="checkbox" id="ckbFg1" name="ckbFg1" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td height="129" ><a id="ankFg1" href="#" onclick="javascript:ankFg_onclick(1);">전문보기</a></td>
							<td align="right">&nbsp;</td>
						</tr>
						<tr style="display:none;">
							<td height="1" colspan="4">&nbsp;</td>
						</tr>
						<tr style="display:none;">
							<td height="129" >
								<iframe src="hico_bd_agree2_ict2.jsp?flag=2" style="WIDTH: 800px; HEIGHT: 120px;BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid"></iframe>								
							</td>
							<td height="129" >&nbsp;&nbsp;동의&nbsp;&nbsp;<input type="checkbox" id="ckbFg2" name="ckbFg2" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td height="129" ><a id="ankFg1" href="#" onclick="javascript:ankFg_onclick(2);">전문보기</a></td>
							<td align="right">&nbsp;</td>
						</tr>
						<tr>
							<td height="1" colspan="4">&nbsp;</td>
						</tr>
						<tr>
							<td height="129" >
								<iframe src="hico_bd_agree3_ict2.jsp?flag=2" style="WIDTH: 800px; HEIGHT: 120px;BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid"></iframe>								
							</td>
							<td height="129" >&nbsp;&nbsp;동의&nbsp;&nbsp;<input type="checkbox" id="ckbFg3" name="ckbFg3" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td height="129" ><a id="ankFg1" href="#" onclick="javascript:ankFg_onclick(3);">전문보기</a></td>
							<td align="right">&nbsp;</td>
						</tr>
						<tr>
							<td height="1" colspan="4">&nbsp;</td>
						</tr>
						<tr>
							<td height="129" >
								<iframe src="hico_bd_agree4_ict2.jsp?flag=2" style="WIDTH: 800px; HEIGHT: 120px;BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid"></iframe>								
							</td>
							<td height="129" >&nbsp;&nbsp;동의&nbsp;&nbsp;<input type="checkbox" id="ckbFg4" name="ckbFg4" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td height="129" ><a id="ankFg1" href="#" onclick="javascript:ankFg_onclick(4);">전문보기</a></td>
							<td align="right">&nbsp;</td>
						</tr>
						<tr>
							<td height="1" colspan="4">&nbsp;</td>
						</tr>
						<tr>
							<td height="129" >
								<iframe src="hico_bd_agree5_ict2.jsp?flag=2" style="WIDTH: 800px; HEIGHT: 120px;BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid"></iframe>								
							</td>
							<td height="129" >&nbsp;&nbsp;동의&nbsp;&nbsp;<input type="checkbox" id="ckbFg5" name="ckbFg5" />&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td height="129" ><a id="ankFg1" href="#" onclick="javascript:ankFg_onclick(5);">전문보기</a></td>
							<td align="right">&nbsp;</td>
						</tr>
						<tr>
							<td height="1" colspan="4">&nbsp;</td>
						</tr>																				
					</table>					
				</td>
				<td width="20">&nbsp;</td>
			</tr>			
</form>			
</table>
</body>
</html>