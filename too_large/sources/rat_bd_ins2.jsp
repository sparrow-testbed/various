<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%

    String RA_FLAG		= JSPUtil.nullToRef(request.getParameter("RA_FLAG"),"D");
    String BID_STATUS   = JSPUtil.nullToRef(request.getParameter("BID_STATUS"),"");
    String RA_NO		= JSPUtil.nullToRef(request.getParameter("RA_NO"),"");         // 생성/수정/확정/상세조회
    String RA_COUNT	    = JSPUtil.nullToRef(request.getParameter("RA_COUNT"),"");         // 생성/수정/확정/상세조회
    String SCR_FLAG     = JSPUtil.nullToRef(request.getParameter("SCR_FLAG"),"I");         // 생성/수정/확정/상세조회 flag  // 저장 = 'T', 결재요청='P', 확정= 'C'

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    String ANN_NO           = "";
    String ANN_DATE         = current_date;
    String ANN_ITEM         = "";
    String BID_ETC          = "";
    String PR_NO            = "";
	String RA_TYPE1			= "";
	
	String ITEM_COUNT 		= "";
	String TOTAL_AMT 		= "";

    Object[] args = {RA_NO, RA_COUNT};

    SepoaOut value = null;
    SepoaRemote wr = null;
    String nickName = "p1008";
    String MethodName = "getRAHDDisplay";
    String conType = "CONNECTION";
    SepoaFormater wf = null;

    //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
    try {
        wr = new SepoaRemote(nickName,conType,info);
        value = wr.lookup(MethodName,args);

        wf = new SepoaFormater(value.result[0]);

        int rw_cnt = wf.getRowCount();

        ANN_NO                       = wf.getValue("ANN_NO"                ,0);

        if(SCR_FLAG.equals("U") || SCR_FLAG.equals("C")){ // 저장 = 'T', 결재요청='P', 확정= 'C'
            ANN_DATE                     = wf.getValue("ANN_DATE"          ,0);
		}

        ANN_ITEM                     = wf.getValue("SUBJECT"               ,0);

        if(SCR_FLAG.equals("U") || SCR_FLAG.equals("C") || SCR_FLAG.equals("V")){
            BID_ETC                      = wf.getValue("REMARK"            ,0);
		}

        PR_NO                        = wf.getValue("PR_NO"                 ,0);
		RA_TYPE1                        = wf.getValue("RA_TYPE1"           ,0);
		
		ITEM_COUNT					= String.valueOf(rw_cnt);
		TOTAL_AMT					= wf.getValue("TOTAL_AMT"           ,0);
    }catch(Exception e) {
        Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
        Logger.dev.println(e.getMessage());
    }finally{
        wr.Release();
    } // finally 끝

	
	String readOnly = "C".equals(SCR_FLAG) || "V".equals(SCR_FLAG) ? "readOnly" : "";
	String disabled = "C".equals(SCR_FLAG) || "V".equals(SCR_FLAG) ? "true" : "";
%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>


</head>
<Script language="javascript">
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

		var today   = "<%=current_date%>";

        if("<%=RA_FLAG%>" == "O") {
            if(LRTrim(document.form1.ANN_NO.value) == "") {
                alert("공고번호를 입력하세요. ");
                document.forms[0].ANN_NO.focus();
                return false;
            }
        }

        if(LRTrim( del_Slash( document.form1.ANN_DATE.value )) == "") {
            alert("공고일자를 입력하세요. ");
            document.forms[0].ANN_DATE.focus();
            return false;
        }

		if(parseInt(form1.ANN_DATE.value) < parseInt(today)) {
    		alert("공고일자는 오늘보다 크거나 같아야합니다. ");
    		form1.ANN_DATE.focus();
    		return false;
    	}

        if(!checkDateCommon(del_Slash( document.form1.ANN_DATE.value))){
            document.forms[0].ANN_DATE.select();
            alert("공고일자를 확인하세요.");
            return false;
        }

        if(LRTrim(document.form1.ANN_ITEM.value) == "") {
            alert("입찰건명을 입력하세요. ");
            document.forms[0].ANN_ITEM.focus();
            return false;
        }

        if(LRTrim(document.form1.BID_ETC.value) == "") {
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

	function Approval(pflag) {       // 저장 = 'T', 결재요청='P', 확정= 'C'
		
		if(button_flag == true) {
//            alert("작업이 진행중입니다.");
//            return;
		}

        button_flag = true;


        if (checkData() == false) {
			button_flag = false;
            return;
        }
		var f = document.forms[0];
    	f.sign_status.value = pflag;
    	document.forms[0].FLAG.value = pflag;
    	
		if(pflag == "P") {
	    	var house_code   = "<%=info.getSession("HOUSE_CODE")%>";
	    	var company_code = "<%=info.getSession("COMPANY_CODE")%>";
	    	var dept         = "<%=info.getSession("DEPARTMENT")%>";
	    	var user_id      = "<%=info.getSession("ID")%>";

			child_frame.location.href = "/kr/admin/basic/approval/approval.jsp?house_code="+house_code+"&company_code="+company_code+"&dept_code="+dept+"&req_user_id="+user_id+"&doc_type=RA&fnc_name=getApproval&amt=";
    	} else if ((pflag == 'T') || (pflag == 'C')) {
      		getApproval(pflag);
    	}
    	

       
    }
	
	function getApproval(approval_str){
		var sign_status = document.forms[0].sign_status.value;
    	document.forms[0].approval_str.value = approval_str;
    	
		 if(sign_status == "T") {
            if(confirm("저장 하시겠습니까?") != 1) {
                button_flag = false;
                return;
            }
        } else if(sign_status == "P") {
        
            if(confirm("결재상신 하시겠습니까?") != 1) {
                button_flag = false;
                return;
            }            
        } else if(sign_status == "C") {
            if(confirm("확정 하시겠습니까?") != 1) {
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

        var ANN_NO = document.form1.ANN_NO.value;
        var ANN_DATE = document.form1.ANN_DATE.value;
        var ANN_ITEM = document.form1.ANN_ITEM.value;
        var BID_ETC = document.form1.BID_ETC.value;
        

        document.forms[0].MODE.value = mode;        

        if("<%=SCR_FLAG%>" == "C") {          // 확정
            document.forms[0].action="rat_wk_ins2.jsp";
            document.forms[0].method="POST";
            document.forms[0].target="child_frame";
            document.forms[0].submit();



        } else {
            document.forms[0].action="rat_wk_ins2.jsp";
            document.forms[0].method="POST";
            document.forms[0].target="child_frame";
            document.forms[0].submit();


        }
	}
		
    function tmax_sign(cert_data) {
        var timestamp = current_date + current_time;
        var certv     = "";

        cert_data = timestamp + cert_data;


        document.forms[0].CERTV.value     = certv;
        document.forms[0].TIMESTAMP.value = timestamp;

        document.forms[0].action="ebd_wk_ins2.jsp";
        document.forms[0].method="POST";
        document.forms[0].target="child_frame";
        document.forms[0].submit();
    }
//-->
</Script>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0">

<form method="post" id="form1" name = "form1" >
	<input type="hidden" id="MODE" 			name="MODE" 		value="">
	<input type="hidden" id="FLAG" 			name="FLAG" 		value="">
	<input type="hidden" id="RA_NO" 		name="RA_NO" 		value="<%=RA_NO%>">
	<input type="hidden" id="RA_COUNT" 		name="RA_COUNT" 	value="<%=RA_COUNT%>">
	<input type="hidden" id="BID_STATUS" 	name="BID_STATUS" 	value="<%=BID_STATUS%>">
	<input type="hidden" id="RA_FLAG" 		name="RA_FLAG" 		value="<%=RA_FLAG%>">
	<input type="hidden" id="PR_NO" 		name="PR_NO" 		value="<%=PR_NO%>">
	<input type="hidden" id="RA_TYPE1" 		name="RA_TYPE1" 	value="<%=RA_TYPE1%>">
	<!--- 인증관련 -->
	<input type="hidden" id="CERTV" 		name="CERTV" 		value="">
	<input type="hidden" id="TIMESTAMP" 	name="TIMESTAMP" 	value="">
	<input type="hidden" id="SIGN_CERT" 	name="SIGN_CERT" 	value="">
	<input type="hidden" id="TMAX_RAND" 	name="TMAX_RAND" 	value="">
	<input type="hidden" id="sign_status" 	name="sign_status" 	value="">
	<input type="hidden" id="approval_str"	name="approval_str" value="">
	<input type="hidden" id="ITEM_COUNT" 	name="ITEM_COUNT" 	value="<%=ITEM_COUNT%>">
	<input type="hidden" id="TOTAL_AMT" 	name="TOTAL_AMT" 	value="<%=TOTAL_AMT%>">
	
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">역경매 취소 공고</td>
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
      		<td width="15%" class="title_td">
        		<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</div>
      		</td>
      		<td width="35%" class="data_td">
        		<input type="text" id="ANN_NO" name="ANN_NO" value="<%=ANN_NO%>" size="20" maxlength="14" class="inputsubmit" readOnly>
      		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  			
		<tr>
      		<td width="15%" class="title_td">
        		<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고일자</div>
			</td>
      		<td width="35%" class="data_td">
      			<s:calendar id="ANN_DATE" default_value="<%=SepoaString.getDateSlashFormat(ANN_DATE) %>" 	format="%Y/%m/%d"  disabled="<%=disabled %>" />
      		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  			
    	<tr>
      		<td width="15%" class="title_td">
        		<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매건명</div>
      		</td>
      		<td width="35%" class="data_td">
        		<input type="text" id="ANN_ITEM" name="ANN_ITEM" value="<%=ANN_ITEM%>" size="60" class="input_re" <%=readOnly%>>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  	    	
    	<tr>
      		<td width="15%" class="title_td" style="height: 200px;">
        		<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 취소사유</div>
      		</td>
      		<td width="35%" class="data_td" style="width: 98%; height: 200px; ">
        		<textarea id="BID_ETC" name="BID_ETC" cols="60" rows="5" maxlength="1000" class="input_re" style="width: 98%;height: 190px" <%=readOnly%>><%=BID_ETC%></textarea>
      		</td>
    	</tr>
  	</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		  	

 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
<%
    if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
%>
						<td><script language="javascript">btn("javascript:Approval('T')","저 장")</script></td>
						<td><script language="javascript">btn("javascript:Approval('P')","결재요청")</script></td>
				      			<%--<TD><script language="javascript">btn("javascript:top.MakeTabList('역경매공고','/kr/dt/rat/rat_bd_lis11.jsp')",7,"취 소")</script></TD>--%>
<%
    }
%>
<%
    if(SCR_FLAG.equals("C")) {
%>
						<TD><script language="javascript">btn("javascript:Approval('C')","확 정")</script></TD>
<%
    }
%>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
</form>

<IFRAME SRC="" id="child_frame" NAME="child_frame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
</IFRAME>

<!---- TMAX ---->
<!--
<OBJECT name="certapp" classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" WIDTH = 0 HEIGHT = 0 codebase="http://java.sun.com/update/1.5.0/jinstall-1_5_0_02-windows-i586.cab#Version=1,5,0,0">
<PARAM NAME="CODE" VALUE="com.tmax.SecretSessionContext.class">
<PARAM NAME="name" VALUE="certapp">
<PARAM NAME="type" VALUE="application/x-java-applet;jpi-version=1.5.0_02">
<PARAM NAME="MAYSCRIPT" VALUE="true">
</OBJECT>
-->

</body>
</html>
