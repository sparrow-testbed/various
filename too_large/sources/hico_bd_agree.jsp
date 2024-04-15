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
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<title>우리은행 전자구매시스템</title>
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

	function do_agree(irs_no, resident_no,status, sg_type){
	    //alert("약관에 동의하셨습니다");
	    form1.irs_no.value 		= irs_no;
	    form1.resident_no.value = resident_no;
	    form1.status.value 		= status;
	    form1.sg_type.value 	= sg_type;
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
// 		if(checkObject()){
// 			alert("[ WiseGrid설치파일 ] 가 설치되어야 신규 아이디신청이 정상적으로 진행됩니다.");
// 			return;
// 		}
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
        
// 		if(LRTrim(document.form1.textarea3.value) != LRTrim(document.form1.textarea4.value)) {
// 			alert("상기의 서약문구와 일치하지 않습니다.");
// 			document.form1.textarea4.value="";
// 		    document.form1.textarea4.focus();
// 			return;
// 		}
        
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
        
        if (!document.getElementById('rdoWin7').checked && !document.getElementById('rdoWin10').checked)
    	{
    		alert("OS(운영체재)를 선택하세요.");
    		return;
    	}
        
		var mode = irsNo == "" ? "resident_no" : "irs_no";
		form1.mode.value = mode;
		this.hiddenframe.location.href="checkDupIrsNo.jsp?irs_no="+irsNo+"&resident_no="+residentNo+"&mode="+mode;
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
		//임시주석
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
//-->
</script>
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="bg_popup">
<iframe name="hiddenframe" src="checkDuplrsNo.jsp" width="0" height="0"></iframe>

<form name="form1" method="post" action="ven_bd_con.jsp">
<input type="hidden" name="status">
<input type="hidden" name="mode" value="">
<input type="hidden" name="sg_type">
  <tr>
    <td width="20">&nbsp;</td>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="8"></td>
      </tr>
      <tr>
        <td height="35" class="title_page"> 약관동의 (협력업체가 가입을 하실 경우 아래의 협력업체 이용약관에 대한 안내를 반드시 읽고 동의해 주십시오)
        </td>
      </tr>
    </table>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="3"></td>
	</tr>
</table>
      <table width="840" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="1" colspan="2" bgcolor="#1e97d1"></td>
        </tr>
        <tr>
          <td height="29" bgcolor="#ebf5fa" class="bluebold">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업자등록번호 확인</td>
          <td align="right" bgcolor="#ebf5fa">&nbsp;</td>
        </tr>
        <tr>
          <td height="1" colspan="2" bgcolor="#c4d6e4"></td>
        </tr>
      </table>
      <table width="840" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7f7f7">
        <tr>
          <td width="20" height="29"><img src="../../images//img/0.gif" width="10" height="1" border="0" align="absmiddle" /></td>
          <td width="110" class="gray">사업자등록번호</td>
          <td width="610" height="29" bgcolor="#FFFFFF" class="gray2"><table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>&nbsp;
                  <input type="text" name="irs_no" id="irs_no" class="input2" maxlength="10" style="width:120px;" /></td>
              <td>&nbsp; (개인, 법인 사업자 입력!) -없이 입력하여 주십시오. </td>
            </tr>
          </table></td>
        </tr>
        <tr style="display:none;">
          <td width="20" height="29"><img src="../../images//img/0.gif" width="10" height="1" border="0" align="absmiddle" /></td>
          <td width="110" class="gray">주민등록번호</td>
          <td width="610" height="29" bgcolor="#FFFFFF" class="gray2"><table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>&nbsp;
                  <input type="text" name="resident_no" id="resident_no" class="input2" maxlength="13" style="width:120px;" /></td>
              <td>&nbsp; (프리랜서만 입력!) -없이 입력하여 주십시오.</td>
            </tr>
          </table></td>
        </tr>
        <tr style="display:none;">
          <td width="20" height="29"><img src="../../images//img/0.gif" width="10" height="1" border="0" align="absmiddle" /></td>
          <td width="110" class="gray">운영체재(OS)구분</td>
          <td width="610" height="29" bgcolor="#FFFFFF" class="gray2"><table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>&nbsp;
              	<input value="win7" name="rdoWin" id="rdoWin7" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 7</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="win10" name="rdoWin" id="rdoWin10" type="radio" checked/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 10</span>    
              </td>
              <td>
            </tr>
          </table></td>
        </tr>
      </table>

      <table width="840" height="1" bgcolor="#1e97d1" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td></td>
        </tr>
      </table>
      <br />

<!-- 	<table width="98%" border="0" cellspacing="1" cellpadding="1"> -->
<!-- 		<tr class="c_data_1"> -->
<!-- 			<td> -->
<!-- 				<TABLE cellpadding="0"> -->
<!-- 					<TR> -->
<!-- 						<td><b> -->
<%-- 						<span class="left_red">LIG System Service를 사용하기 위해서는 설치파일을 다운로드 후 설치해 주시기바랍니다</span> --%>
<!-- 						</b></td> -->
<!-- 			    	</tr> -->
<!-- 			    	<tr> -->
<%-- 			    		<td><b><a href="/wiselight/setup.exe"><span class="bluebold">[ WiseGrid설치파일 ]</span></a></b></td> --%>
<!-- 					</TR> -->
<!-- 			     	</TABLE> -->
<!-- 			</td> -->
<!-- 		</tr> -->
<!-- 	</table> -->

      <table width="840" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="1" colspan="2" bgcolor="#1e97d1"></td>
        </tr>
        <tr>
          <td height="29" bgcolor="#ebf5fa" class="bluebold">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;우리은행 전자구매시스템 이용약관</td>
          <td align="right" bgcolor="#ebf5fa">&nbsp;</td>
        </tr>
        
        <tr>
          <td height="1" colspan="2" bgcolor="#c4d6e4"></td>
        </tr>
      </table>
      <table width="840" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="100"><textarea name="textarea" style="width:840px;height:300px;" readOnly>
제1조 (목적)

본 약관은 전자 구매 시스템 (이하 "시스템"이라 함) 을 운영하는 우리은행시스템과 본 시스템을 통해 입찰 및 발주 등의 구매 관련 업무에 참여하는 공급업체 간의 시스템 이용 조건 및 절차, 권리, 의무, 책임사항을 규정함을 목적으로 한다.


제2조 (용어의 정의)

1. "시스템"이란 우리은행시스템이 “공급업체”의 물품 또는 서비스를 상거래하고, 관련 부가 서비스를 제공하기 위하여 설정한 가상의 장소를 말한다.
2. ”공급업체”란 본 시스템에서 정한 절차에 따라 시스템 상에서의 업체 등록 요청에 대하여 우리은행시스템이 ”공급업체”로 등록한 업체를 말한다.
3. "신규 업체" 란 이 시스템에서 정한 절차에 따라 소정 양식을 제출하여 ”공급업체” 등록을 요청한 업체로서, 우리은행시스템의 심사를 거치기 전 단계에 있는 업체를 말한다.
4. "입찰"이란 우리은행시스템의 필요한 물품 또는 서비스에 대해 잠재적인 공급 의사를 가진 ”공급업체”에 대해 이를 시스템 상에 공지하고 견적을 접수하는 행위를 말한다.
5. "전자 서명" 이란 우리은행시스템의 전자 서명된 모든 구매 계약 문서에 대해 공급업체가 전자 서명을 함으로써 계약을 성립시키는 행위를 말한다. ”공급업체”의 전자 서명이 완료되면, 전자서명기본법에 따라 계약서 날인과 동일한 법적 효력을 갖게 된다.
6. "전자 계약서"란 우리은행시스템과 ”공급업체”간의 거래 조건을 우리은행시스템이 전자적 문서의 형태로
작성하여 시스템 상에서 제공하는 개별 구매 계약서를 말한다.
7. "공인인증서"란 전자서명기본법에 따라 공인인증기관이 발급하는 인증서를 말하며, 본 계약 체결을 위하여 “공급업체”가 전자서명을 하는 경우에 사용한다.
8. “사용자 아이디(ID)”라 함은 “공급업체”가 서비스를 이용하고, 우리은행시스템이 “공급업체”를 구분,
식별할 수 있도록, “공급업체”가 선정하고 “우리은행시스템”이 부여하는 문자와 숫자의 조합을 말한다.
9. “비밀번호”라 함은 “우리은행시스템”이 부여 받은 “사용자 아이디(ID)”와 동일한 회원임을 확인하고
권익을 보호받기 위하여, “공급업체”가 선정한 문자와 숫자의 조합을 말한다.


제3조 (약관의 명시 및 변경)

① 본 약관은 시스템의 업체 등록 신청 화면에 게시한다.
② 본 약관은 물품 또는 서비스 공급 업체가 시스템의 사용을 위해 본 약관에 동의하고, 우리은행시스템에서 ”공급업체” 등록 승인을 함으로써 효력이 발생한다.
③ 우리은행시스템은 본 시스템의 원활한 운영을 위해 전자 거래 기본법, 정보 통신망 이용 촉진 등에 관한 법률 등을 위배하지 않는 범위에서 본 약관을 수시로 개정할 수 있으며, 약관이 개정된 경우에는 적용 일자와 개정 사유를 본 시스템의 홈페이지에 명시하여 공고한다.
④ 개정된 약관은 개정 내용이 관계 법령에 위배되지 않고 별도의 경과 규정이 없는 한 개정 이전에 등록한 ”공급업체”에게도 적용된다.


제4조 (서비스의 내용 및 변경)

① 본 시스템에서 제공하는 서비스는 다음과 같다.
가. ”공급업체” 기본등록 요청 및 변경
나. 물품 또는 서비스의 입찰 및 견적 제출
다. ”공급업체”가 참여한 입찰의 진행 상황
라. 발주 및 검수확인서 등록 등 구매 계약의 진행 상황 및 세금 계산서 처리 현황
마. 기타 우리은행시스템이 제공하는 서비스
② 본 시스템에서 제공되는 서비스의 내용은 우리은행시스템의 사정에 의해 변경될 수 있다.


제5조 (서비스의 중단)

① 시스템은 다음의 경우에 서비스가 중단될 수 있다.
가. 본 시스템의 점검, 정보 통신 설비의 보수 점검, 교체 및 통신의 두절 등의 사유에 의한 서비스의 중단
나. 불가항력에 의한 서비스의 중단
② 서비스의 중단이 발생된 경우 또는 발생될 우려가 있을 경우에는, 조속한 시일 내에
”공급업체”들에게 서비스의 중단 사실과 중단 사유를 통지한다.
③ 우리은행시스템은 위 가.항의 사유에 의해 발생된 서비스의 중단으로 인해 발생된 ”공급업체”의 손해에 대하여 배상하지 않는다.


제6조 (약관 외 준칙)

본 약관에 명시되지 않은 사항은 전자 거래 기본법, 정보 통신망 이용 촉진 등에 관한 법률 및
기타 관련 법령의 규정 또는 상관례에 따른다.


제7조 (등록 신청)

사전 “공급업체” 등록 심사에 합격한 업체가 본 약관에 동의한다는 의사를 표시하고, 우리은행시스템이 정한 ”공급업체” 등록 요청 신청서 양식에 따라 시스템 상에서 등록을 신청한다.

제 8조 (개인 프로파일 입력)

①	개인 프로파일을 입력하고자 하는 "사용자"는 "회사"에서 요청하는 제반정보(이름, 주민등록번호,연락처 등)를 제공하여야 한다.
②	"사용자"는 반드시 본인의 이름과 주민등록번호를 제공하여야만 개인 프로파일을 입력할 수 있으며, 실명으로 등록하지 않은 "사용자"는 일체의 권리를 주장할 수 없다.
③	타인의 명의를 도용하여 이용신청을 한 회원의 모든 ID는 삭제되며, 관계법령에 따라 처벌을 받을 수 있다.
④	서비스 이용신청자는 1개의 주민번호에 대해 1건의 이용신청을 할 수 있다.


제 9조 (개인 프로파일 활용계약의 제한)

①	본 활용계약의 법률적 완전성을 보장하기 위하여 회사와 계약하고자 하는 "사용자"는 미성년자가 아닌자만 가능합니다. 만약, 활용계약의 성립 이후 타인의 주민등록번호 도용과 같은 방법으로 만 미성년자가 "사용자"로 등록된 것으로 확인될 경우 "회사"는 즉시 활용계약을 해지할 수 있다
②	"회사"는 다음 각 호의 1에 해당하는 사항을 인지하는 경우 동 활용신청을 해지할 수 있다.
가. 이름이 실명이 아닌 경우 
   나. 다른 사람의 명의를 사용하여 신청한 경우 
   다. 가입신청 및 프로파일의 내용을 허위로 기재한 경우 
   라. 기타 회사 소정의 이용신청요건을 충족하지 못하는 경우 


제 10조 (개인 프로파일 개인정보보호)

①	회사는 개인 프로파일의 개인정보보호를 위하여 노력해야 합니다. 개인정보보호에 관해서는 정보통신망 이용촉진 및 정보보호 등에 관한 법률에 따르고, 사이트에 "개인정보보호정책"을 고지한다.
②	회사는 사용자의 정보수집 시 구매계약 이행에 필요한 최소한의 정보를 수집한다.
다음 사항을 필수사항으로 하며 그 외 사항은 선택사항으로 한다.
   가. 성명         
   나. 주민등록번호
   다. 전화번호
   라. 휴대폰번호  
   마. 이메일
   바. 등급
   사. IT경력
   아. 현소속업체
   자. 현소속업체와의 관계
   차. 최종학력
   카. 재직상태

제 11조 (개인 프로파일 정보의 활용)

①	회사는 다음과 같은 목적으로 회원의 프로파일 정보를 활용할 수 있다.
가. 회사가 현재 필요한 인력을 조회, 추천, 검토하여 활용여부를 확정하고자 할 때
나. 회사가 제3의 회사(이하 "고객사")에게 현재 진행중인 프로젝트에 참여할 인력을 추천하여 고객사로부터 승인을 득하려고 할 때
다. 개인이 최초에 입력한 개인회원 프로파일의 정보를 보관 후 회사가 향후에 발생할 수 있는 인력의 필요 및 프로젝트 투입에 활용할 인력을조회, 추천, 검토, 활용여부를 확정하거나, 고객사에 추천 하여 승인을 득할 목적으로 활용하려고 할 때
②	회사에 제공된 개인 프로파일은 개인회원이 특정 건에 대하여 사용을 한정하지 않는 한 회사가 1항의 목적을 위하여 활용할 수 있다.


제 12조 (개인정보 및 프로파일 내용의 책임과 회사의 정보수정 / 삭제권한)

①	"사용자"는 개인정보 및 프로파일을 사실에 근거하여 성실하게 작성해야 하며, 만일 내용이 사실이 아니거나 부정확하게 작성되어 발생하는 모든 책임은 사용자에게 있다.
②	 모든 개인정보 및 프로파일의 관리와 작성은 회원 본인이 하는 것을 원칙으로 하며, 사용자는 언제든지 본인이 작성한 프로파일을 조회, 수정, 삭제할 수 있다.
③	"회사"는 "사용자"가 등록한 개인정보 및 개인이력 내용에 오자, 탈자 또는 사회적 통념에 어긋나는 문구가 있을 경우 사전 통지나 동의 없이 이를 언제든지 수정 또는 삭제할 수 있다.


제13조 (“공급업체” 탈퇴 및 자격의 상실)

① “공급업체”는 언제든지 시스템에 대하여 탈퇴를 요청할 수 있으며, 우리은행시스템은 즉시 ”공급업체” 탈퇴 처리를 한다. 이 경우, ”공급업체”는 전자우편 또는 기타 방법으로 탈퇴 의사를 통지하여야 하며, “사용자 ID” 및 “비밀번호”를 밝혀야 하고, 진행 중인 입찰 및 구매 계약 등에 대해서는 관련 상관례 또는 관련 법령에 따라 사후 처리를 진행하여야 한다.
단, ”공급업체” 탈퇴는 이미 성립된 거래에 대해서는 영향이 없다.
② “공급업체”가 다음 각 호의 사유에 해당하는 경우 당해 ”공급업체”의 회원 자격을 제한, 정지 또는 상실시킬 수 있다. 단, 이 경우 우리은행시스템은 당해 ”공급업체”에게 자격 제한 등의 사유를
통지하고 그에 대한 의견 기회를 부여한다. 자격을 상실시키는 경우에는 그 ”공급업체” 등록을 말소한다.

가. 등록 신청서의 기재 내용이 허위인 경우
나. 시스템을 통해 “공급업체” 스스로 결정한 의사 결정에 대하여 정당한 사유 없이 책임지지
아니한 경우
다. 컴퓨터 바이러스 등을 고의로 유포시켰을 경우
라. 시스템의 서비스 운영을 방해한 경우
마. 시스템을 이용하여 법령에 반하는 행위를 하는 경우
바. 시스템을 통하여 획득한 정보를 업무 외의 목적으로 이용하거나 부당하게 제3자에게 유출한
경우
사. 기타 전자 거래 질서의 확립을 위하여 회원으로서의 자격을 지속시키는 것이 부적절하다고
판단되는 경우
③ 이 경우, 손해배상의 문제는 별개로 한다.


제14조 (“공급업체”에 대한 통지)

① 우리은행시스템은 등록 신청 업체의 승인 여부와 “공급업체”에 대한 입찰 공고 기타의 통지에 대해 이를 ”공급업체”가 등록한 영업 담당자의 전자우편 주소로 통지할 수 있다.
② 전체 ”공급업체”에 대한 통지는 시스템 화면에 게시함으로써 갈음할 수 있다.


제15조 (거래의 방식)

① 시스템을 통한 물품 및 서비스의 거래는 입찰 형식을 원칙으로 하며, "우리은행시스템의
입찰공고 -> ”공급업체”의 입찰 -> 낙찰 (업체 선정) -> 재견적 요청 -> 최종 협의 및 마감" 순으로 진행하며, 우리은행시스템 전자계약서에 대해 ”공급업체”가 전자 서명을 행함으로써 거래가 성립된다.
② 입찰을 통해 거래가 성립되지 않는 물품 및 서비스의 거래는 구매 계약 전반에 대한 개별 협상을 통해 최종 계약 조건을 확정하고, 우리은행시스템의 전자서명 계약서에 대해 “공급업체”가 전자 서명을 행함으로써 거래가 성립된다.
③ 해당 ”공급업체”는 낙찰된 물품이나 서비스에 대해 계약 진행 상황, 전자 서명, 입고 및 검수 확인 및 송장 처리 정보 등의 추가 서비스를 활용할 수 있다.
④ “공급업체”로 등록된 회사는 판매가 가능한 물품 또는 서비스에 대해 우리은행시스템으로부터 입찰참여 요청을 받게 되며, ”공급업체”는 시스템이 제공하는 입찰 양식에 따라 입찰하여야 한다.
⑤ 입찰시 허위 등록 또는 오기로 인한 우리은행시스템 또는 ”공급업체”의 손해 또는 손실에 대한 책임은 전적으로 입찰한 ”공급업체”가 부담한다.
⑥ 이미 입찰을 완료한 입찰 건에 대한 취소 사유가 발생하였을 경우 취소 사유를 명시하여 우리은행시스템에 입찰의 취소를 요청하여야 하며, 우리은행시스템은 합리적인 수준에서 요청의 수락 여부를 결정한다.
단, 입찰의 취소로 인해 발생된 우리은행시스템의 손해는 “공급업체”에서 부담한다.
⑦ 우리은행시스템은 “공급업체”의 입찰이 있는 경우 낙찰 여부를 결정하여야 한다. 우리은행시스템은
입찰 ”공급업체”들 중에서 적절한 낙찰 업체가 없다고 판단하는 경우에는 유찰시킬 수 있다.
입찰 “공급업체”는 우리은행시스템의 유찰 결정에 대하여 이의를 제기할 수 없다.
⑧ 우리은행시스템에 의하여 낙찰 업체로 선정된 경우에는 당해 낙찰 업체는 우리은행시스템과의 협의를 거쳐 최소한 입찰 조건에 상응하는 물품 또는 서비스를 우리은행시스템에 제공하기 위한 최종 계약을
체결하여야 하며, 정당한 사유가 없는 한 낙찰을 거부하거나 최종계약의 체결을 거부할 수 없다.
⑨ 우리은행시스템낙찰에 따른 발주서를 전송하며, 이에 낙찰된 “공급업체”는 즉시 발주에 근거한 서비스를 제공해야 한다. “공급업체”가 5일 이내 회신이 없는 경우 발주처리가 완료된 것으로 판단하며, 그에 따른 납기지연 등의 피해가 발생할 경우 “공급업체”는 이에 따른 손해배상을 책임져야 한다.
⑩ 낙찰 받은 “공급업체”가 정당한 사유 없이 입찰을 취소하거나 낙찰에 대한 승인을 거부하는 경우, 우리은행시스템이 발주한 물품 또는 서비스의 제공을 거부하거나 지연하는 경우 및 우리은행시스템의 정당한 반품 등을 거부하는 경우, 약관 제8조 나.항에 기하여 서비스 신뢰도 또는 전자 상거래 질서의 훼손 등을 이유로 당해 ”공급업체”의 회원 자격을 상실시킬 수 있다. ”공급업체”의 위와 같은 행위로 인하여 우리은행시스템이 물적˙정신적 손해를 입은 경우, “공급업체”는 “우리은행시스템”에게 모든 손해를 배상해야 한다.


제16조 (“공급업체” 및 등록 신청자 정보의 보호)

① 우리은행시스템은 등록신청서에 기재된 정보 외의 정보를 수집하거나 회원에 관한 정보를 제3자에게 제공함에 있어서는, 반드시 당해 ”공급업체”의 동의를 받아야 하며, ”공급업체”는 거부할 수 있다.
② 우리은행시스템은 수집한 등록 신청 정보를 서비스 및 서비스의 기능 확대 외의 목적으로 사용하지 않으며, 그러한 목적 이외의 사용이나 ”공급업체”의 동의 없이 ”공급업체” 정보를 제3자에게 제공하지 아니한다.
③ 우리은행시스템은 다음과 같은 경우에는 ”공급업체” 및 등록 신청자의 동의 없이 “공급업체” 정보를 이용하거나 제3자에게 제공할 수 있다.
가. 배송 업무상 배송 업체에 배송에 필요한 최소한의 회원 정보를 제공하는 경우
나. 통계 작성, 홍보 자료, 학술 연구 또는 시장 조사를 위하여 필요한 경우로서 특정개인을 식별할 수 없는 형태로 제공하는 경우
다. 기타 법령에서 정보의 공개를 요구하거나 법령에 의하여 정보의 제공이 가능한 경우
④ 우리은행시스템은 “공급업체”가 탈퇴한 경우, 지체 없이 수집된 회원정보를 파기하는 등 필요한 조치를 취한다. 다만, 우리은행시스템은 “공급업체”에 대하여 이행하지 아니한 채무가 있는 경우, 그 
이행을 촉구함에 필요한 범위 내에서 당해 “공급업체”에 대한 회원 정보를 일시적으로 보유할 수 있다.


제 17조 ("사용자 아이디(ID)" 및 "사용자 비밀번호(Password)" 관리책임)

1. "사용자"는 "사용자 아이디(ID)"와 "사용자 비밀번호(Password)"를 통하여 "e-ProQ"에 접속함으로써 본 시스템을 이용할 수 있다. 
2. "사용자"는 "사용자 아이디(ID)"와 "사용자 비밀번호(Password)"를 스스로의 책임 아래 관리하여야 하며 "사용자 아이디(ID)"나 "사용자 비밀번호(Password)"를 타인에게 양도하거나 사용하게 할 수 없다. 
3. "우리은행시스템"은 "우리은행시스템"의 고의 또는 과실에 의하지 않은 "사용자아이디(ID)"나 "사용자 비밀번호(Password)"의 유출에 대하여 책임지지 않으며 이로 인하여 발생하는 어떠한 손해에 대하여도 책임지지 않는다.


제18조 (우리은행시스템의 의무)

① 시스템은 “공급업체”에 대하여 계속적이고 안정적인 서비스를 제공한다.
② 우리은행시스템은 서비스 제공 시스템을 운용 가능한 상태로 유지하여야 하며, 장애가 발생했을 때에는 지체 없이 이를 수리, 복구하여 ”공급업체”의 시스템 이용에 불편이 없도록 한다.
③ 우리은행시스템은 정보 보호, 보안 및 ”공급업체”에 대한 비밀 보장을 위하여 최선의 노력을 다한다.
④ 우리은행시스템은 “공급업체”로부터 제기되는 불만이 정당하다고 인정되는 경우에는 이를 지체 없이 처리한다. 다만, 즉시 처리가 곤란한 사정이 있는 경우 당해 “공급업체”에게 그 사유를 통보한다.


제19조 (”공급업체”의 의무)

① “사용자 ID”와 “비밀번호”에 관한 모든 관리 책임은 당해 ”공급업체”에게 있다.
② ”공급업체”는 “사용자 ID” 및 “비밀번호”를 타인에게 양도하거나 사용 승낙할 수 없다.
우리은행시스템은 회원에 의한 “사용자 ID” 또는 “비밀번호”의 양도, 유출, 사용 승낙으로 인한 어떠한
손실이나 손해에 대해서도 책임을 지지 않는다.
③ ”공급업체”는 “사용자 ID” 또는 “비밀번호”를 도난 당하거나 제3자가 무단 사용하고 있음을 인지한 경우에는 즉시 우리은행시스템 구매 담당자에게 통보하여야 하고, 우리은행시스템의 안내에 따라 “사용자 ID” 및 “비밀번호”의 변경 등을 협의하여야 한다. 이러한 도난 또는 무단 사용에 관한 통보 이전까지 발생한 “사용자 ID” 및 “비밀번호”의 사용에 따른 책임은 해당 ”공급업체”가 부담한다.
④ ”공급업체”는 자신의 공인인증서 및 공인인증서 사용에 필요한 암호가 분실, 훼손, 도난, 유출되거나 직거래업체 기타 제3자에 의해 부정하게 사용(이하 "부정사용") 되지 않도록 보관˙관리하여야 하고, 직원˙거래업체 기타 제3자를 대상으로 시스템 이용방법,주의사항등과 공인인증서 및 암호의 부정사용 방지를 위한 교육˙홍보를 실시하여야 한다.
⑤ “공급업체”는 그 외에도 다음의 각 호에 해당되는 활동을 해서는 안 된다.
1. 우리은행시스템이 제공하는 서비스를 통하여 얻은 정보를 사전승낙 없이 허가용도 이외의 목적으로
사용하거나 복제, 유통, 상업적으로 이용하는 행위
2. 타 “공급업체”나 제3자의 지적재산권을 침해하는 행위
3. 타 “공급업체”의 명예를 손상시키거나 고의적으로 불이익을 주는 행위
4. 범죄 행위를 목적으로 하거나 범죄행위를 교사하는 내용을 유포하는 행위 (기타 사회 질서에
위배되는 행위)
5. 우리은행시스템의 동의를 받지 않고 서비스 내용과 관련 없는 내용 및 광고 등을 권유하거나 게시 등 기타 다른 방법으로 전달하는 행위
6. 정보서비스를 위해하거나 혼란을 일으키는 해킹을 하거나 컴퓨터 바이러스 전염, 유포하는 행위
7. 기타 법률에 위배되는 행위


제20조 (저작권의 귀속 및 이용 제한)

우리은행시스템이 본 시스템에서 제공하는 서비스에 관한 저작권 및 기타 지적 재산권은 우리은행시스템에 귀속된다.
. "사용자"는 서비스를 이용하는 과정에서 얻은 정보를 "회사"의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 어떠한 방법에 의하여도 재화나 용역의 판매 이외의 다른 목적으로 이용하거나 제3자에게 이를 이용하게 하여서는 안됩니다. 


제21조 (회사의 면책)

① 우리은행시스템은 천재지변, 전쟁, 전력 공급 중단, 노사분규 또는 이에 준하는 불가항력의 상황으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 대한 책임이 면제된다.
② 우리은행시스템은 인터넷 이용자 또는 “공급업체”의 귀책 사유로 인한 서비스 이용 장애에 대해서는 책임을 지지 않는다.
③ 우리은행시스템은 “공급업체”간에 자발적으로 이루어진 정보 및 서비스 교류 등으로 인하여 발생한 손해에 대해서는 일체의 책임을 지지 않는다.
④ 우리은행시스템이 통제할 수 없는 시스템의 장애로 시스템 사용이 불가능하다고 판단될 경우 우리은행시스템은 입찰의 취소 및 재공고 입찰 등 필요한 조치를 취할 수 있다. 시스템의 장애는 시스템의 다운, 시스템에 연결된 모든 네트워크의 장애 등으로 본 시스템에 접속이 불가능하거나 관련 문서를 송신할 수 없는 경우 등을 말한다.
⑤ ④항의 시스템 장애가 아닌 ”공급업체”의 네트워크 또는 네트워크 서비스 업체의 장애, ”공급업체”의 시스템 다운 등의 사유로 ”공급업체”의 송신 정보가 본 시스템에 입력되지 않을 경우 ”공급업체”가 송신하지 아니한 것으로 본다.

제22조 (관할 법원)

우리은행시스템이 제공하는 서비스와 관련하여 “공급업체”에 발생한 분쟁에 대해 소송이 제기될 경우 그 관할 법원은 서울 지방 법원으로 한다.


제23조 (관련 규정 및 집행 절차 숙지)

시스템을 이용하는 “공급업체”는 본 약관 및 시스템 이용 매뉴얼, 일반 공지 내용을 숙지해야 하며 이를 위반함으로써 발생하는 불이익에 대한 책임은 ”공급업체”에게 있다.

제24조 (윤리경영 준수 의무)

①“공급업체는”는 상호 협력하여 공정하고 투명하게 업무를 처리하며, 부당한 금품 및 향응 제공, 불공정 계약행위 등 윤리에 어긋나는 행위를 일체 하지 않는다.
②“공급업체”는 “우리은행시스템”의 윤리강령 및 윤리경영 행동규범을 확인·숙지하여 “공급업체”와 관련된 사항을 준수하여야 하며 이를 위반하여, 다음 각 호에 해당하는 경우 제3항의 제재를 가할 수 있다.
 가. 부당한 금품 및 향응을 수수하거나 제공하는 경우
 나. 술, 골프 등의 접대 또는 물품을 협찬하는 경우
 다.“우리은행시스템”의 직원과 금전거래를 하는 경우
 라.“우리은행시스템”의 직원 또는“우리은행시스템”의 고객과 도박을 하는 경우
 마. 가공매입·매출 등 부정한 계약을 하는 경우
 바. 계약과 관련하여 담합, 변조, 위조 등 부정한 행위를 하는 경우
 사. 기타 “우리은행시스템”의 윤리경영 행동규범을 위반하는 경우
③“우리은행시스템”은 “공급업체”가 상기 제1항을 위반하거나 제2항의 각호에 해당하는 경우 계약을 즉시 해지할 수 있으며 사안의 경중에 따라 일정기간 거래를 정지할 수 있으며 “공급업체”는 이에 대해 이의를 제기하지 않는다.
“공급업체”는 상기 제3항과 별도로 “공급업체”가 상기 제1항을 위반하거나 제2항의 각 호로 인해 “우리은행시스템”에게 손해가 발생하는 경우 이를 배상하여야 한다. 특히 "공급업체"가 부정한 금품을 제공하거나 수취하는 경우에는 그 금품의 10배수에 해당하는 금액을 "우리은행시스템"에게 배상한다.

제25조 (기타)

본 약관에 위반되는 행위를 발견하거나 서비스 이용시 불편을 경험하신 “공급업체”들이 우리은행시스템에 연락하는 경우, 우리은행시스템은 지체 없이 필요한 조치를 취한다.

-끝-

부 칙

제 1조 이 약관은 2012년 8월 31일부터 시행한다.

          </textarea></td>
        </tr>
      </table>
      <br>
      <table width="840" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="1" colspan="2" bgcolor="#1e97d1"></td>
        </tr>
        <tr>
          <td height="29" bgcolor="#ebf5fa" class="bluebold">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;우리은행 전자구매시스템 윤리경영 준수 서약서</td>
          <td align="right" bgcolor="#ebf5fa">&nbsp;</td>
        </tr>
        
        <tr>
          <td height="1" colspan="2" bgcolor="#c4d6e4"></td>
        </tr>
      </table>
      <table width="840" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="100"><textarea name="textarea2" style="width:840px;height:150px;" readOnly>
당사는 투명하고 공정한 거래관계가 기업의 가치를 제고하고 상호발전을 이룬다는 것을 깊이 인식하고, 다음 사항을 준수할 것을 서약합니다.

1. 당사는 귀사의 윤리경영을 이해하고, 윤리강령, 윤리경영 행동규범을 확인·숙지하여 당사와 관련되는 사항을 준수하며, 다음 각 호와 같은 일체의 부정한 행위가 발생하지 않도록 하겠습니다.

가. 부당한 금품 및 향응을 수수하거나 제공하는 행위
나. 술, 골프 등의 접대 또는 물품을 협찬하는 행위
다. 귀사의 직원과 금전거래를 하는 행위
라. 귀사의 직원 또는 귀사의 고객과 도박을 하는 행위
마. 가공매입·매출 등 부정한 계약을 하는 행위
바. 계약과 관련하여 담합, 변조, 위조 등의 부정을 하는 행위
사. 기타 귀사의 윤리강령 및 윤리경영 행동규법을 위반하는 행위

2. 상기 사항을 위반할 시 귀사와 진행중인 계약의 해지, 진행예정인 계약의 취소 변경, 일정기간 거래 정지, 손해배상 등의 제재 조치가 취해질 수 있음을 인식합니다.

3. 상기 2항의 제재조치에 대해서 일체의 이의제기를 하지 않을 것을 확인 및 서약합니다.

          </textarea></td>
        </tr>
      </table>
      <br>
<!--       <table width="840" border="0" cellspacing="0" cellpadding="0"> -->
<!--         <tr> -->
<!--           <td height="1" colspan="2" bgcolor="#1e97d1"></td> -->
<!--         </tr>       -->
<!--       	<tr> -->
<!--           <td height="29" bgcolor="#ebf5fa" class="bluebold">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;서약문구</td> -->
<!--           <td align="right" bgcolor="#ebf5fa">&nbsp;</td> -->
<!--         </tr> -->
<!--         <tr> -->
<!--           <td height="1" colspan="2" bgcolor="#c4d6e4"></td> -->
<!--         </tr>         -->
<!--       	<tr> -->
<!--       		<td style="font-size:12;color:black;height:30px;"> -->
<!-- 				<b>당사는 투명하고 공정한 거래관계가 기업의 가치를 제고하고 상호발전을 이룬다는 것을 깊이 인식하고, 다음 사항을 준수할 것을 서약합니다.</b> -->
<!--         	<input type="hidden" name="textarea3" value="당사는 투명하고 공정한 거래관계가 기업의 가치를 제고하고 상호발전을 이룬다는 것을 깊이 인식하고, 다음 사항을 준수할 것을 서약합니다."> -->
<!--         	</td>        	 -->
<!--       	</tr> -->
<!--         <tr> -->
<!--           <td height="1" colspan="2" bgcolor="#c4d6e4"></td> -->
<!--         </tr>      	 -->
<!--       	<tr> -->
<!--       		<td style="color:red;height:30px;">*상기의 서약문구를 입력하여 주십시요.</td> -->
<!--       	</tr> -->
<!--         <tr> -->
<!--           <td> -->
<!--           	<textarea name="textarea4" style="width:840px;height:50px;"></textarea> -->
<!--           </td> -->
<!--         </tr> -->
<!--       </table> -->
      <table width="840" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="43" align="center"><table border="0" cellpadding="2" cellspacing="0">
              <tr>
		        <TD><script language="javascript">btn("javascript:doCheck()","동의합니다")</script></TD>
		        <TD><script language="javascript">btn("javascript:window.close()","동의하지 않습니다")</script></TD>
              </tr>
          </table></td>
        </tr>
      </table>
    </td>
    <td width="20">&nbsp;</td>
  </tr>
</form>
</table>
</body>
</html>