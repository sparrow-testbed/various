<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    Vector multilang_id = new Vector();
 
	HashMap text = MessageUtil.getMessageMap( info, "MESSAGE", "BUTTON", "BD_001" );

	Config conf = new Configuration();
    String buyer_company_code = conf.getString("sepoa.buyer.company.code");
	String user_type  = info.getSession("USER_TYPE");
	String seller_code= "";
  
    String  current_date      = SepoaDate.getShortDateString();  
    String  current_time      = SepoaDate.getShortTimeString();  
     
    //Dthmlx Grid 전역변수들..
    String screen_id = "BD_001";
    String grid_obj = "GridObj";
    // 조회용 화면인지 데이터 저장화면인지의 구분
    boolean isSelectScreen = false; 
    
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
   
    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
	String BID_STATUS = JSPUtil.nullToEmpty(request.getParameter("BID_STATUS")); 
	String SCR_FLAG = JSPUtil.nullToEmpty(request.getParameter("SCR_FLAG")); 

    String ANN_NO           = "";
    String ANN_DATE         = "";
    String ANN_ITEM         = "";
    String BID_ETC          = "";
    String PR_NO            = "";
    String ITEM_COUNT		= "";
    String BASIC_AMT		= "";
    String BID_TYPE		= "";
    
	Map map = new HashMap();
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getPrHeaderDetail", obj);
	
    SepoaFormater wf = new SepoaFormater( value.result[0] );

    if(wf != null) {
        if(wf.getRowCount() > 0) { //데이타가 있는 경우

	        BID_TYPE					 = wf.getValue("BID_TYPE"                 ,0);
            ANN_NO                       = wf.getValue("ANN_NO"                ,0);
 
        if(SCR_FLAG.equals("U") || SCR_FLAG.equals("C"))
            ANN_DATE                     = wf.getValue("ANN_DATE"              ,0);

        ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);

        if(SCR_FLAG.equals("U") || SCR_FLAG.equals("C"))
            BID_ETC                      = wf.getValue("BID_ETC"               ,0);

	        PR_NO                        = wf.getValue("PR_NO"                 ,0);
	        ITEM_COUNT					 = wf.getValue("ITEM_COUNT"                 ,0);
	        BASIC_AMT					 = wf.getValue("BASIC_AMT"                 ,0);
        }
    }
     
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 
<script language="javascript" type="text/javascript">
<!--
<!--
var mode;
var button_flag = false;
var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var cert_data    = "";

var SCR_FLAG = "<%=SCR_FLAG%>";

function ANN_DATE(year,month,day,week) {
    document.forms[0].ANN_DATE.value=year+month+day;
}

function checkData() {

    if("<%=BID_TYPE%>" == "O") {
        if(LRTrim(document.forms[0].ANN_NO.value) == "") {
            alert("공고번호를 입력하세요. ");
            document.forms[0].ANN_NO.focus();
            return false;
        }
    }

    if(LRTrim(del_Slash(document.forms[0].ANN_DATE.value))== "") {
        alert("공고일자를 입력하세요. ");
        document.forms[0].RANN_DATE.focus();
        return false;
    }

    if(!checkDateCommon(del_Slash(document.forms[0].ANN_DATE.value))){
        document.forms[0].ANN_DATE.select();
        alert("공고일자를 확인하세요.");
        return false;
    }

    if(LRTrim(document.forms[0].ANN_ITEM.value) == "") {
        alert("입찰건명을 입력하세요. ");
        document.forms[0].ANN_ITEM.focus();
        return false;
    }

    if(LRTrim(document.forms[0].BID_ETC.value) == "") {
        alert("취소사유를 입력하세요. ");
        document.forms[0].BID_ETC.focus();
        return false;
    }

    if (parseInt(ANN_DATE) < parseInt(current_date)) {
        alert ("공고일자는 오늘보다 이후 날짜이어야 합니다.");
        return false;
    }

	return true;
}

function Approval(sign_status) {       // 저장 = 'T', 결재요청='P', 확정= 'C', 취소완료및확정 = 'E'
  

    if(LRTrim(document.forms[0].ANN_DATE.value) == "") {
        alert("공고일자를 입력하세요. ");
			button_flag = false;
        document.forms[0].ANN_DATE.focus();
        return ;
    }
    
    if (!checkData()) {
        button_flag = false;
    	return;
    }
	
	var f = document.forms[0];
	f.sign_status.value = sign_status;
	

	var sign_status = document.forms[0].sign_status.value;
	//document.forms[0].approval_str.value = approval_str;
	
	if(sign_status == "T") {
        if(confirm("임시저장 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    } else if(sign_status == "P") {
        if(confirm("결재상신 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    } else if(sign_status == "E") {
        if(confirm("해당 입찰건을 취소 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    }

    if("<%=SCR_FLAG%>" == "I")          // 생성
        mode = "setCancelGonggoCreate";
    if("<%=SCR_FLAG%>" == "U")           // 수정
        mode = "setCancelGonggoModify";
    if("<%=SCR_FLAG%>" == "C")           // 확정
        mode = "setGonggoConfirm";
 
    document.forms[0].MODE.value = mode;
    document.forms[0].FLAG.value = sign_status;
    
    document.forms[0].ANN_DATE.value = del_Slash( document.forms[0].ANN_DATE.value );
    
    if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }

    button_flag = true;
    
    var nickName    = "BD_001";
    var conType     = "TRANSACTION";
    var methodName  = "setCancelGonggo";
    var SepoaOut    = doServiceAjax( nickName, conType, methodName );

    if( SepoaOut.status == "1" ) { // 성공
        alert( SepoaOut.message );
		opener.doSelect();
        window.close();
    } else { // 실패
        alert( SepoaOut.message );
    }
    
    document.forms[0].ANN_DATE.value = add_Slash( document.forms[0].ANN_DATE.value );
    
	/*
    if("<//%=SCR_FLAG%>" == "C") {          // 확정
        cert_data = "<//%=BID_TYPE%>" + ANN_NO + ANN_DATE + ANN_ITEM +
                  BID_ETC + "<//%=BID_NO%>" + "<//%=BID_COUNT%>";
		//Sign(cert_data);
		// 서버서명
			SignUseXecure("server");
    } else {
        document.forms[0].action="ebd_wk_ins2.jsp";
        document.forms[0].method="POST";
        document.forms[0].target="child_frame";
        document.forms[0].submit();
    }*/
} 

<%--
function SignUseXecure(serverOrClient){	// 서버서명, 클라이언트 서명
	
	var presigndata = "";
		var sign 		= "";
		var vid_msg		= "";
		
	if(serverOrClient == "client"){
		presigndata = setPreSignData("<%=BID_NO+BID_COUNT%>");
		sign = Sign_with_vid_web(0, presigndata, s, "<%=ssn%>");		
		if(sign == "") return;		
		//식별번호(VID)
		vid_msg =  send_vid_info();
	}

	//서명검증
    document.form2.signdata.value 	= sign;
	document.form2.vid_msg.value 	= vid_msg;
	document.form2.plainText.value  = "<%=HOUSE_CODE+BID_NO+BID_COUNT+USER_ID%>";
	document.form2.submit();
}
--%>
function doSignConfirm(){
	document.form2.CERTV.value 		= child_frame.document.forms[0].CERTV.value;
	document.form2.SIGN_CERT.value	= child_frame.document.forms[0].SIGN_CERT.value;//.replace(/-----BEGIN CERTIFICATE-----\r\n/g, "").replace(/\r\n-----END CERTIFICATE-----\r\n/g,"");
	document.form2.CRYP_CERT.value 	= child_frame.document.forms[0].CRYP_CERT.value;//.replace(/-----BEGIN CERTIFICATE-----\r\n/g, "").replace(/\r\n-----END CERTIFICATE-----\r\n/g,"");
	document.form2.TIMESTAMP.value 	= child_frame.document.forms[0].TIMESTAMP.value;
	
	document.forms[0].CERTV.value 		= document.form2.CERTV.value;
	document.forms[0].SIGN_CERT.value	= document.form2.SIGN_CERT.value;
	document.forms[0].CRYP_CERT.value 	= document.form2.CRYP_CERT.value;
	document.forms[0].TIMESTAMP.value 	= document.form2.TIMESTAMP.value;
					
	document.forms[0].action="ebd_wk_ins2.jsp";
    document.forms[0].method="POST";
    document.forms[0].target="child_frame";
    document.forms[0].submit();		
}

function setPreSignData(SignData) { 
    var presigndata = '';
    presigndata = SignData + "<%=info.getSession("COMPANY_CODE")%>" + "<%=info.getSession("ID")%>";
    return presigndata;
}

function Sign(data)
{
var plainText, signMsg;
var nRet, certdn, storage;

	
 var timestamp = current_date + current_time;
 var certv		   = "111111111111111111111111111111111111111111";
 var sign_cert     = "222222222222222222222222222222222222222222";
 var cryp_cert     = "333333333333333333333333333333333333333333";
    
 cert_data = timestamp + cert_data;
 
// 서명할 문자열 데이타 설정.
plainText = cert_data;

// 모든 Condition 설정.
nRet = TSToolkit.SetConfig("test", CA_LDAP_INFO, CTL_INFO, POLICIES, 
						INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
						USING_CRL_CHECK, USING_ARL_CHECK);
if (nRet > 0)
{
	//alert(nRet + " : " + TSToolkit.GetErrorMessage());
	return false;
}

// 사용자가 자신의 인증서를 선택. 
nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
if (nRet > 0)
{
	alert(nRet + " : " + TSToolkit.GetErrorMessage());  //비밀번호오류
	return false;
}

nRet = TSToolkit.SignData(plainText); // 성공하면 0반환

if (nRet > 0) {
	alert(nRet + " : " + TSToolkit.GetErrorMessage());
	return false;
}
sign_cert = TSToolkit.OutData;
cryp_cert = TSToolkit.OutData;
certv = TSToolkit.GetSignerCert(1);
sign_cert = sign_cert.substr(0,4000);
cryp_cert = cryp_cert.substr(0,4000);
document.forms[0].CERTV.value     = certv;
document.forms[0].TIMESTAMP.value = timestamp;
document.forms[0].SIGN_CERT.value=sign_cert;
document.forms[0].CRYP_CERT.value=cryp_cert;

document.forms[0].action="ebd_wk_ins2.jsp";
document.forms[0].method="POST";
document.forms[0].target="child_frame";
document.forms[0].submit();		
}

function tmax_sign(cert_data) {
    var timestamp = current_date + current_time;
    var certv     = "";

    cert_data = timestamp + cert_data;

/*
    if ("ok" != certapp.sign(cert_data)) {
//        alert(certapp.getMessage());
        return;
    } else {
        certv    = certapp.getMessage();
    }

    var sign_cert = certapp.getSignCert();
    var tmax_rand = certapp.getRandom();
*/

    document.forms[0].CERTV.value     = certv;
    document.forms[0].TIMESTAMP.value = timestamp;
    //document.forms[0].SIGN_CERT.value = sign_cert;
    //document.forms[0].TMAX_RAND.value = tmax_rand;

    document.forms[0].action="ebd_wk_ins2.jsp";
    document.forms[0].method="POST";
    document.forms[0].target="child_frame";
    document.forms[0].submit();
}
//-->
</Script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<s:header popup="true">
<form name="form" method="post" action="">
<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>"> 
<input type="hidden" name="BID_STATUS" id="BID_STATUS" value="<%=BID_STATUS%>">
<input type="hidden" name="MODE" value="">
<input type="hidden" name="FLAG" id="FLAG" value=""> 
<input type="hidden" name="BID_TYPE" id="BID_TYPE" value="<%=BID_TYPE%>">
<input type="hidden" name="PR_NO" id="PR_NO" value="<%=PR_NO%>">
<input type="hidden" name="ITEM_COUNT" id="ITEM_COUNT" value="<%=ITEM_COUNT%>">
<input type="hidden" name="BASIC_AMT" id="BASIC_AMT" value="<%=BASIC_AMT%>">
<input type="hidden" name="sign_status" value="">
<input type="hidden" name="approval_str" value="">


<!--- 인증관련 -->
<input type="hidden" name="CERTV" value="">
<input type="hidden" name="TIMESTAMP" value="">
<input type="hidden" name="SIGN_CERT" value="">
<input type="hidden" name="CRYP_CERT" value="">
<input type="hidden" name="TMAX_RAND" value="">
 
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
  	<tr>
    	<td class='title_page'>
			취소 공고
    		&nbsp;
		</td> 
	</tr>
</table>
    
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
        						<td width="100%" valign="top">
            						<table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
                						<colgroup>
                    						<col width="15%" />
                    						<col width="35%" />
                    						<col width="15%" />
                    						<col width="35%" />	
                						</colgroup>  
                						<tr>
      										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공고번호</td>
      										<td class="data_td">&nbsp;
        										<input type="text" name="ANN_NO" id="ANN_NO" value="<%=ANN_NO%>" style="width:30%" readOnly>
      										</td>
    									</tr>
										<tr>
											<td colspan="2" height="1" bgcolor="#dedede"></td>
										</tr>       									
    									<tr>
      										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공고일자</td>
      										<td class="data_td">&nbsp;
												<s:calendar id="ANN_DATE" default_value=""  format="%Y/%m/%d"/>
      										</td>
    									</tr>
    									<tr>
											<td colspan="2" height="1" bgcolor="#dedede"></td>
										</tr>
    									<tr>
      										<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰건명</td>
      										<td class="data_td">&nbsp;
        										<input type="text" name="ANN_ITEM" id="ANN_ITEM" value="<%=ANN_ITEM%>" class="input_re" style="width:90%;" onKeyUp="return chkMaxByte(300, this, '입찰건명');">
      										</td>
    									</tr>
    									<tr>
											<td colspan="2" height="1" bgcolor="#dedede"></td>
										</tr>
    									<tr>
      										<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;취소사유</td>
      										<td class="data_td">&nbsp;
     											<textarea name="BID_ETC"  rows="5"  style="width:96%" onKeyUp="return chkMaxByte(1000, this, '취소사유');"><%=BID_ETC%></textarea>
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
<br>
 
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR> 
			  		<TD><script language="javascript">btn("javascript:Approval('C')", "취소공고")</script></TD> 
    	  		</TR>
			</TABLE>
		</td>
	</tr>
</table>
</form>
</s:header>
<s:footer/>
</body>
</html> 
