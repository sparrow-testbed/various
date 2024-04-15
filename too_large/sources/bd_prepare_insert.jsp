<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_013");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_013";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	Config conf = new Configuration();
	//boolean useXecureFlag = conf.getBoolean("wise.UseXecure");

	String PASSWORD		 = null;
    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
    String COST_STATUS   = JSPUtil.nullToEmpty(request.getParameter("COST_STATUS"));
	String BID_STATUS    = JSPUtil.nullToEmpty(request.getParameter("BID_STATUS"));
	String BID_TYPE      = JSPUtil.nullToEmpty(request.getParameter("BID_TYPE"));

    String HOUSE_CODE   	= info.getSession("HOUSE_CODE");
    String COMPANY_CODE 	= info.getSession("COMPANY_CODE");
    String USER_ID			= info.getSession("ID");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시??

    String CONT_TYPE1         	= "";
    String CONT_TYPE2         	= "";
    String ANN_NO             	= "";
    String ANN_ITEM           	= "";
    String ANN_DATE           	= "";
    String CONT_TYPE1_TEXT_D  	= "";
    String CONT_TYPE2_TEXT_D  	= "";
    String CONT_TYPE1_TEXT_CS  	= "";
    String CONT_TYPE2_TEXT_CS  	= "";
    String CTRL_AMT           	= "0";
    String CRYP_CERT          	= "";
    String ESTM_FLAG          	= "";
    String AMT                	= "0";
    String ESTM_PRICE1_ENC    	= "";
    String ESTM_PRICE1        	= "0";
    String FINAL_ESTM_PRICE	  	= "";
    String FINAL_ESTM_PRICE_ENC	="";
    String CERTV              	= "";
    String TIMESTAMP          	= "";
    String SIGN_CERT          	= "";
    String PR_AMT				= "0";
	String PR_AMT_NOVAT			= "0";
	String MEMO					= "";
	String BASIC_AMT			= "0";
	String ATTACH_NO			= "";
	String ATTACH_CNT			= "0";
	String PROM_CRIT			= "";
	String PROM_CRIT_NAME		= "";
	
	String ESTM_RATE			= "0";
	String ADD_USER_ID          = "";
	

    boolean sign_result = true;  //서명검증

	Map map = new HashMap();
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_012", "CONNECTION","getBdPrepareHeader", obj);
	  
		// 입찰 헤더 : ICOYBDHD
        SepoaFormater wf = new SepoaFormater(value.result[0]);
        // ICOYBDES : 예정가격 등록 테이블
        SepoaFormater wf2 = new SepoaFormater(value.result[1]);
		// 입찰 상세 : ICOYBDDT
		SepoaFormater wf3 = new SepoaFormater(value.result[2]);
		
        if(wf.getRowCount() > 0){
	        CONT_TYPE1				= wf.getValue("CONT_TYPE1"            ,0);
	        CONT_TYPE2				= wf.getValue("CONT_TYPE2"            ,0);
	        ANN_NO					= wf.getValue("ANN_NO"                ,0);
	        ANN_ITEM				= wf.getValue("ANN_ITEM"              ,0);
	        ANN_DATE                = wf.getValue("ANN_DATE"              ,0);
	        CONT_TYPE1_TEXT_D       = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
	        CONT_TYPE2_TEXT_D       = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);
	        CONT_TYPE1_TEXT_CS      = wf.getValue("CONT_TYPE1_TEXT_CS"    ,0);
	        CONT_TYPE2_TEXT_CS      = wf.getValue("CONT_TYPE2_TEXT_CS"    ,0);
	        CTRL_AMT                = wf.getValue("CTRL_AMT"              ,0);
	        CRYP_CERT               = wf.getValue("CRYP_CERT"             ,0);
	        PROM_CRIT	          	= wf.getValue("PROM_CRIT"        	  ,0);
	        PROM_CRIT_NAME          = wf.getValue("PROM_CRIT_NAME"        ,0);
			if (ANN_DATE.length() == 8) {
	            ANN_DATE = ANN_DATE.substring(0,4) + "/" + ANN_DATE.substring(4,6) + "/" + ANN_DATE.substring(6,8);
	        }
	        ESTM_FLAG				= wf.getValue("ESTM_FLAG"             ,0);
	        COST_STATUS				= wf.getValue("COST_STATUS"           ,0);
	    	
	        if(CONT_TYPE2.equals("PQ") || CONT_TYPE2.equals("QE")){
	        	CONT_TYPE2_TEXT_D = CONT_TYPE2_TEXT_CS;
	        }
	        
	        ADD_USER_ID             = wf.getValue("ADD_USER_ID"           ,0);	        
		}
        //Logger.err.println(info.getSession("ID"),this,"여기당 = " + COST_STATUS);
        
        /* COST_STATUS 값이 없을 때는 확정되지 않은 상태로 보고 ET 값을 기본 값으로 한다.
        *  예정가격등록요청을 하고 예정가격 처리를 하기 때문에 임시 저장된 예정가격이 있으므로 ET값을 넣어 둔다. 확정시 값은 EC
        */
        COST_STATUS = JSPUtil.nullToRef(COST_STATUS, "ET");
        
		if(wf2.getRowCount() > 0) {
	        if(COST_STATUS.equals("")) { // 신규 생성건 인 경우에는 BDES가 생성 전이므로, 값이 없다.
	            BASIC_AMT   		= wf2.getValue("BASIC_AMT"   ,0);
	            MEMO   				= wf2.getValue("REQ_COMMENT" ,0);
	            CERTV       		= wf2.getValue("CERTV"       ,0);
	            TIMESTAMP   		= wf2.getValue("TIMESTAMP"   ,0);
	            SIGN_CERT   		= wf2.getValue("SIGN_CERT"   ,0);
	            ESTM_PRICE1 		= wf2.getValue("ESTM_PRICE1_ENC",0);
	        } else {
		        BASIC_AMT   		= wf2.getValue("BASIC_AMT"   ,0);
		        MEMO   				= wf2.getValue("REQ_COMMENT" ,0);
			    ATTACH_NO   		= wf2.getValue("ATTACH_NO"   ,0);
			    ATTACH_CNT  		= wf2.getValue("ATTACH_CNT"  ,0);
		        CERTV       		= wf2.getValue("CERTV"       ,0);
		        TIMESTAMP   		= wf2.getValue("TIMESTAMP"   ,0);
		        SIGN_CERT   		= wf2.getValue("SIGN_CERT"   ,0);
		        ESTM_PRICE1 		= wf2.getValue("ESTM_PRICE1" ,0);
		        ESTM_PRICE1_ENC 	= wf2.getValue("ESTM_PRICE1_ENC" ,0);
		        FINAL_ESTM_PRICE	= wf2.getValue("FINAL_ESTM_PRICE" ,0);
		        FINAL_ESTM_PRICE_ENC= wf2.getValue("FINAL_ESTM_PRICE_ENC" ,0);
		        
		        /* 예정가격 복호화 후 검증 */
				PASSWORD = HOUSE_CODE+BID_NO+BID_COUNT+USER_ID;
				
				/* 2011.02.19 이대규 xecure 처리 부분 적용 */
				/*
				if(useXecureFlag) {
					EnvelopeData envelope 	= null;
					envelope = new EnvelopeData(new XecureConfig());
					
					if (!"".equals(envelope.keKeyDeEnvelopeData(PASSWORD.getBytes(),FINAL_ESTM_PRICE_ENC))) {
					  	FINAL_ESTM_PRICE = envelope.keKeyDeEnvelopeData(PASSWORD.getBytes(),FINAL_ESTM_PRICE_ENC);
						sign_result = true;
					}
				} else {
					EncDec crypt = new EncDec();
					ESTM_PRICE1 = crypt.decrypt(ESTM_PRICE1_ENC);
					FINAL_ESTM_PRICE = crypt.decrypt(FINAL_ESTM_PRICE_ENC);
					sign_result = true;
				}*/
	        }
		} else {
			BASIC_AMT = wf3.getValue("PR_AMT_NOVAT", 0);
		}
		
		if(wf3.getRowCount() > 0) {
	        PR_AMT			= wf3.getValue("PR_AMT"      , 0);
    	    PR_AMT_NOVAT	= wf3.getValue("PR_AMT_NOVAT", 0);
		}
		
		if (BASIC_AMT.equals(""))    BASIC_AMT    = "0";
		if (PR_AMT.equals(""))       PR_AMT       = "0";
		if (PR_AMT_NOVAT.equals("")) PR_AMT_NOVAT = "0";
		/*
		BASIC_AMT 		= "".equals(BASIC_AMT)? "0.00" : WiseString.formatNum(Double.parseDouble(BASIC_AMT),2);
		PR_AMT 			= "".equals(PR_AMT)? "0.00" : WiseString.formatNum(Double.parseDouble(PR_AMT),2);
		PR_AMT_NOVAT 	= "".equals(PR_AMT_NOVAT)? "0.00" : WiseString.formatNum(Double.parseDouble(PR_AMT_NOVAT),2);
		*/ 
   
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  --> 
<!--  
<SCRIPT language=javascript src="/include/attestation/TSToolkitConfig.js"></script>
<SCRIPT language=javascript src="/include/attestation/TSToolkitObject.js"></script>-->

<Script language="javascript">
<!--
    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";

	var save_mode   = "";
	var button_flag = false;

    var date_flag;
	var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
  
    function setHangulData() {
        changeMoney(document.forms[0].ESTM_PRICE_CONF.value, 7);
    }

    function setOnFocus(obj) {
        var target = eval("document.forms[0]." + obj.name);
        target.value = del_comma(target.value);
        target.select();
        
    }

    function setOnBlur(obj) {
        var target = eval("document.forms[0]." + obj.name);
        
        if($.trim(del_comma(target.value)) == ''){
        	target.value = 0;
        }

        if(IsNumber(del_comma(target.value)) == false) {
            target.value = "";
            alert("숫자를 입력하세요."); 
            target.focus();
            return;
        }
		if (target.value != "") {
        	target.value = parseFloat(target.value);
        }

        if(obj.name == "ESTM_PRICE_CONF") {
            if(LRTrim(document.forms[0].ESTM_PRICE.value) == "") {
                alert("내정가격을 먼저 입력하세요.");
                target.value = "";
                document.forms[0].ESTM_PRICE.focus();
                return;
            }

            if(document.forms[0].ESTM_PRICE_CONF.value == "") {
                return;
            }

            if(IsNumber(del_comma(document.forms[0].ESTM_PRICE.value)) == false) {
                alert("내정가격을 먼저 입력하세요.");
                target.value = "";
                document.forms[0].ESTM_PRICE.focus();
                return;
            } else {
				changeMoney(target.value, 7);
//                 if(parseFloat(del_comma(document.forms[0].ESTM_PRICE.value)) == parseFloat(del_comma(target.value))) {
//                     changeMoney(target.value, 7);
//                 } else {
//                     alert("확인가격이 내정가격과 동일하지 않습니다.\n\n다시 입력하세요.");
//                     document.forms[0].ESTM_PRICE_H.value = "";
//                     target.value = "";
//                     target.focus();
//                     return;
//                 }
            }
        }
        
        if(obj.name == "ESTM_PRICE"){
        	var basicPrice	= parseFloat(del_comma($("#BASIC_AMT").val())); 
        	var estmPrice 	= parseFloat(del_comma($("#ESTM_PRICE").val())); 
        	
        	//$("#ESTM_RATE").val(add_comma(100 - (100 / (basicPrice / (basicPrice - estmPrice))),2));
        	var tmp = 100 - (100 / (basicPrice / (basicPrice - estmPrice)));
        	
        	tmp = tmp.toString();
        	
        	if(tmp.indexOf(".") > 0){
        		tmp = tmp.substring(0, tmp.indexOf(".") + 3);
        	}else{
        		tmp += ".00";
        	}
        	
        	$("#ESTM_RATE").val(tmp);
        }
        
        if(obj.name == "ESTM_RATE"){
        	var basicPrice	= parseFloat(del_comma($("#BASIC_AMT").val())); 
        	var estmRate 	= parseFloat(del_comma($("#ESTM_RATE").val())); 
        	
        	$("#ESTM_PRICE").val(add_comma(basicPrice * (estmRate/100),0));
        }        

        target.value = add_comma(target.value,0);
    }

	function changeMoney(mon, sw)
	{
		var index=0;
		var i=0;
		var result="";
		var newResult="";

		var money = commaDel(mon);

		//alert(money);
		if(money==0){
			alert("값을 입력하세요");
			return false;
		}
		if(isNaN(Number(commaDel(mon)))){
			//alert("숫자로 입력하세요");
			if (sw != 0) {
				alert("숫자로 입력하세요");
				document.forms[0].ESTM_PRICE_CONF.value ="";
                document.forms[0].ESTM_PRICE_H.value ="";
			}
			return false;
		}
		if(money.length>16){
			alert("가용한 금액의 크기를 넘었습니다.");
			if (sw != 0) {
				document.forms[0].ESTM_PRICE_CONF.value ="";
                document.forms[0].ESTM_PRICE_H.value ="";
			}
			return false;
		}
		if(money.indexOf(".")>=0){
			//alert("정수로 입력하십시오");
			//return false;
		}
		if(money.indexOf("-")>=0){
			alert("양수로 입력하십시오");
			return false;
		}
		su = new Array("0","1","2","3","4","5","6","7","8","9");
		km = new Array("영","일","이","삼","사","오","육","칠","팔","구");
		danwi = new Array("","십","백","천","만","십","백","천","억","십","백","천","조");
		for(j=1;j<=money.length;j++){
			for(index=0;index<10;index++){
				money = money.replace(su[index],km[index]);
			}
		}
		for(index = money.length;index>0;index=index-1){
			result = money.substring(index-1,index);

			if(result=="영"){
				if(i<4 || i>8){
					result = "";
				}
				else if(i>=4 && i<8 && newResult.indexOf("만")<0){
					result = "만";
				}
				else if(i>=8 && i<12 && newResult.indexOf("억")<0){
					result = "억";
				}
				}else{
				result = result + danwi[i];
				//alert(danwi[i]);
			}
			i++;
			newResult = result + newResult;
			//alert(newResult);
		}
		for(j=1;j<newResult.length;j++){
			newResult = newResult.replace("영","");
		}
		if((newResult.indexOf("만")-newResult.indexOf("억"))==1)
			newResult = newResult.replace("만","");
		if((newResult.indexOf("억")-newResult.indexOf("조"))==1)
			newResult = newResult.replace("억","");

			if (sw == 7) {
				document.forms[0].ESTM_PRICE_H.value = newResult+" 원";
<%
    if(COST_STATUS.equals("EC")) {
%>
//				document.forms[0].ESTM_PRICE_CONF.value = commaDel(document.forms[0].ESTM_PRICE_CONF.value);
<%
    } else {
%>
// 				document.forms[0].ESTM_PRICE_CONF.value = commaDel(document.forms[0].ESTM_PRICE_CONF.value);
<%
    }
%>
			} else if (sw == 0) {
    			return newResult;
            }
	}

	function commaNum(num2)
	{
		var e1 = event.srcElement;
   		var num7="0123456789,";
   		event.returnValue = true;

   		for (var i=0;i<e1.value.length;i++)
   		if (-1 == num7.indexOf(e1.value.charAt(i)))
      		event.returnValue = false;

   		if (!event.returnValue) {
      		//e1.className="badvalue";
   		    alert("");
   		    //return;
   		} else {
      		e1.className="";
		}

		//var len=num2.value.length;
		var len=num2.length;
		var i;
		var buffer="";

		for(i=0;i<len;i++)
		{
		    if(num2.charAt(i)!=',')
		    {
		    	buffer=buffer+num2.charAt(i);
		    }
		}
		num2 = buffer;

		var temp;
		for ( var j=0 ; j < num2.length; j++ ) {

		}

		var num=parseInt(num2);

        if (num < 0) { num *= -1; var minus = true}
        else var minus = false

        var dotPos = (num+"").split(".")
        var dotU = dotPos[0]
        var dotD = dotPos[1]
        var commaFlag = dotU.length%3

        if(commaFlag) {
        	var out = dotU.substring(0, commaFlag)
        	if (dotU.length > 3) out += ","
        }
        else var out = ""

        for (var i=commaFlag; i < dotU.length; i+=3) {
            out += dotU.substring(i, i+3)
            if( i < dotU.length-3) out += ","
        }
		//alert(out);

		document.forms[0].ESTM_PRICE.value = out;

        if(minus) out = "-" + out
        if(dotD) return out + "." + dotD
        else return out
        //alert(out);
        document.forms[0].ESTM_PRICE_CONF.value = out;
	}

	function commaDel(num)
	{
		var len=num.length;
		var i;
		var buffer="";

		for(i=0;i<len;i++)
		{
			if(num.charAt(i)!=',')
			{
				buffer=buffer+num.charAt(i);
			}
		}
		return buffer;
	}
<%--
	function SignUseXecure(serverOrClient){	// 서버서명, 클라이언트 서명
		
  		var presigndata = "";
  		var sign 		= "";
  		var vid_msg		= "";
  		//전자서명
  		<%
  			Config conf = new Configuration();
  			boolean isDevelopment = conf.getBoolean("wise.development.flag");
  			String IRS_NO = "";
  			if(isDevelopment){
  				IRS_NO = "1234567890";
  			}else {
  				IRS_NO = info.getSession("IRS_NO");
  			}  			
  		%>
		
		if(serverOrClient == "client"){
			presigndata = setPreSignData("<%=BID_NO+BID_COUNT%>");
			sign = Sign_with_vid_web(0, presigndata, s, "<%=IRS_NO%>");		
			if(sign == "") return;		
			//식별번호(VID)
			vid_msg =  send_vid_info();
		}

		//서명검증
        document.form2.signdata.value 	= sign;
		document.form2.vid_msg.value 	= vid_msg;
		document.form2.plainText.value  = "<%=HOUSE_CODE+BID_NO+BID_COUNT+USER_ID%>" + parseFloat(del_comma(document.form1.ESTM_PRICE.value));
		
		document.attachFrame.setData();	//startUpload
	}

	function doSignConfirm(){
		
	<% 	if(useXecureFlag)
		{	%>
			document.form2.CERTV.value 		= child_frame.document.form1.CERTV.value;
			document.form2.SIGN_CERT.value	= child_frame.document.form1.SIGN_CERT.value;//.replace(/-----BEGIN CERTIFICATE-----\r\n/g, "").replace(/\r\n-----END CERTIFICATE-----\r\n/g,"");
			document.form2.CRYP_CERT.value 	= child_frame.document.form1.CRYP_CERT.value;//.replace(/-----BEGIN CERTIFICATE-----\r\n/g, "").replace(/\r\n-----END CERTIFICATE-----\r\n/g,"");
			document.form2.TIMESTAMP.value 	= child_frame.document.form1.TIMESTAMP.value;
	<%	}	
		else
		{	%>
			document.form2.CERTV.value 		= "";
			document.form2.SIGN_CERT.value	= "";
			document.form2.CRYP_CERT.value 	= "";
			document.form2.TIMESTAMP.value 	= "";
	<%	} %>
		document.form1.CERTV.value 		= document.form2.CERTV.value;
		document.form1.SIGN_CERT.value 	= document.form2.SIGN_CERT.value;
		document.form1.CRYP_CERT.value 	= document.form2.CRYP_CERT.value;
		document.form1.TIMESTAMP.value  = document.form2.TIMESTAMP.value
		
		        
        document.forms[0].action="ebd_wk_ins9.jsp";
        document.forms[0].method="POST";
        document.forms[0].target="child_frame";
        document.forms[0].submit();
	}
--%>	
	function setPreSignData(SignData) { 
        var presigndata = '';
        presigndata = SignData + "<%=info.getSession("COMPANY_CODE")%>" + "<%=info.getSession("ID")%>";
	    return presigndata;
    }

	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];
	
		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "P") {
			var protocol = location.protocol;
			var host     = location.host;
			var addr     = protocol +"//" +host;

			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

			f.method = "POST";
			f.target = "fileattach";
			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
			f.submit();
		} else if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;
		
		if (document.form1.attach_gubun.value == "wise"){
			GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;
		    <%--
			<%if(useXecureFlag) {%>
				document.form2.submit();
			<%} else {%>
				doSignConfirm();
			<%}%>
			--%>
		}
	}
//-->
</Script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_prepare_insert";

function init() {

	<%
	    	if(!COST_STATUS.equals("EC") && !COST_STATUS.equals("")) {
	    		
				if("".equals(ESTM_PRICE1) || ESTM_PRICE1 == null){
	 				ESTM_PRICE1 = "0.00";
	 				ESTM_RATE = "0.00";
	 			}else{
	 				ESTM_RATE = 100 - (100 / (Double.parseDouble(BASIC_AMT) / (Double.parseDouble(BASIC_AMT) - Double.parseDouble(ESTM_PRICE1)))) + "";	
	 			}
	    		
	%>
<%-- 				document.forms[0].ESTM_RATE.value = add_comma("<%=ESTM_RATE%>",0); --%>
<%-- 	        	document.forms[0].ESTM_PRICE.value = add_comma("<%=ESTM_PRICE1%>",0); --%>
				$("#ESTM_RATE").val(add_comma("<%=ESTM_RATE%>",2));
	        	$("#ESTM_PRICE").val(add_comma("<%=ESTM_PRICE1%>",0));
	<%
	    	}
	%>
	<%
	    	if(COST_STATUS.equals("EC")) {
	    		if(sign_result){
	    			
					if("".equals(FINAL_ESTM_PRICE) || FINAL_ESTM_PRICE == null){
						FINAL_ESTM_PRICE = "0.00";
		 				ESTM_RATE = "0.00";
		 			}else{
		 				ESTM_RATE = 100 - (100 / (Double.parseDouble(BASIC_AMT) / (Double.parseDouble(BASIC_AMT) - Double.parseDouble(FINAL_ESTM_PRICE)))) + "";
		 			}	    			
	%>
<%-- 					document.forms[0].ESTM_RATE.value = add_comma("<%=ESTM_RATE%>",0); --%>
<%-- 					document.forms[0].ESTM_PRICE.value = add_comma("<%=FINAL_ESTM_PRICE%>",0); --%>
<%-- 					document.forms[0].ESTM_PRICE_CONF.value = add_comma("<%=FINAL_ESTM_PRICE%>",0); --%>
					$("#ESTM_RATE").val(add_comma("<%=ESTM_RATE%>",2));
					$("#ESTM_PRICE").val(add_comma("<%=FINAL_ESTM_PRICE%>",0));
					$("#ESTM_PRICE_CONF").val(add_comma("<%=FINAL_ESTM_PRICE%>",0));
	        		setHangulData();
	<%
				} else {
	%>
					alert("내정가격이 변조되었습니다.");
					return;
	<%
				}
	    	}
	%>
	setGridDraw(); 
    doQuery();
}
	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
   
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    
    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

//조회
function doQuery() {
 	var cols_ids = "<%=grid_col_id%>";
 	var params = "mode=getBdPrepareInsert";
 	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
   
    return true;
}

function doSave(FLAG) {
    if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }
    button_flag = true;

    if(LRTrim(document.forms[0].ESTM_PRICE.value) == "" || LRTrim(document.forms[0].ESTM_PRICE.value) == "0") {
        alert("내정가격을 입력하세요.");
        button_flag = false;
        document.forms[0].ESTM_PRICE.focus();
        return;
    }

    if(LRTrim(document.forms[0].ESTM_PRICE_CONF.value) == "" || LRTrim(document.forms[0].ESTM_PRICE_CONF.value) == "0") {
        alert("확인가격을 입력하세요.");
        button_flag = false;
        document.forms[0].ESTM_PRICE_CONF.focus();
        return;
    }

    if(eval(del_comma(document.forms[0].ESTM_PRICE_CONF.value)) != eval(del_comma(document.forms[0].ESTM_PRICE.value)) ){
        alert("내정가격과 확인가격이 일치하지 않습니다.");
        document.forms[0].ESTM_PRICE_CONF.value = "";
        document.forms[0].ESTM_PRICE_CONF.focus();
        button_flag = false;
        return;
    }
	
	var basic_amt  = parseFloat("<%=BASIC_AMT%>");//예정가격
	var estm_price = parseFloat(del_comma(document.forms[0].ESTM_PRICE.value));//예정가격
	var min_basic_amt = basic_amt/2;
	var max_basic_amt = basic_amt + min_basic_amt;

	if(min_basic_amt > estm_price || max_basic_amt < estm_price){
		if(confirm("예정가격과 내정가격의 차이가 많이 납니다.\n\n그래도 등록하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
	}
	
    if(FLAG == "T") {
        if(confirm("임시저장 후 확정하셔야 내정가격이 확정됩니다.\n\n내정가격을 임시저장 하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    } else {
		if(confirm("내정가격을 확정하시겠습니까?") != 1) {
            button_flag = false;
            return;
        }
    }
    document.forms[0].BASIC_AMT.value = parseFloat(del_comma(document.forms[0].BASIC_AMT.value));
    document.forms[0].ESTM_PRICE.value = parseFloat(del_comma(document.forms[0].ESTM_PRICE.value));
    document.forms[0].ESTM_PRICE_CONF.value	= parseFloat(del_comma(document.forms[0].ESTM_PRICE_CONF.value));        
	document.forms[0].FLAG.value = FLAG;
	
	// 서버서명
		//SignUseXecure("server");
	/*
	암호화시 이용
    if (!Encrypt(f.ESTM_PRICE_CONF, f.CERTV, f.ESTM_PRICE_CONF_ENC, 'N')){
        button_flag = false;
        return;
    }
	*/
 
    var nickName    = "BD_012";
    var conType     = "TRANSACTION";
    var methodName  = "setPrepare";
    var SepoaOut    = doServiceAjax( nickName, conType, methodName );

    if( SepoaOut.status == "1" ) { // 성공
        alert( SepoaOut.message );
    } else { // 실패
        alert( SepoaOut.message );
    }
    
    location.href="bd_prepare_list.jsp";
}

// 첨부파일
function setAttach(attach_key, arrAttrach, attach_count) {
	if(document.forms[0].isGridAttach.value == "true"){
		setAttach_Grid(attach_key, arrAttrach, attach_count);
		return;
	}
    var attachfilename  = arrAttrach + "";
    var result 			="";
	var attach_info 	= attachfilename.split(",");
	for (var i =0;  i <  attach_count; i ++)
    {
	    var doc_no 			= attach_info[0+(i*7)];
		var doc_seq 		= attach_info[1+(i*7)];
		var type 			= attach_info[2+(i*7)];
		var des_file_name 	= attach_info[3+(i*7)];
		var src_file_name 	= attach_info[4+(i*7)];
		var file_size 		= attach_info[5+(i*7)];
		var add_user_id 	= attach_info[6+(i*7)];

		if (i == attach_count-1)
			result = result + src_file_name;
		else
			result = result + src_file_name + ",";
	}
	document.forms[0].attach_no.value     	= attach_key;
	document.forms[0].attach_cnt.value     	= attach_count;
    document.getElementById("attach_no_text").innerHTML = "";
    document.forms[0].only_attach.value = "attach_no";
    //setAttach1();
}

function setAttach1() {
    var nickName        = "SIF_001";
    var conType         = "TRANSACTION";
    var methodName      = "getFileNames";
    var SepoaOut        = doServiceAjax( nickName, conType, methodName );
    
    if( SepoaOut.status == "1" ) { // 성공
        //alert("성공적으로 처리 하였습니다.");
        var test = (SepoaOut.result[0]).split("<%=conf.getString( "sepoa.separator.line" )%>");
        var test1 = test[1].split("<%=conf.getString( "sepoa.separator.field" )%>");
        
        setAttach2(test1[0]);
        
    } else { // 실패
<%--             alert("<%=text.get("MESSAGE.1002")%>"); --%>
    }
}

function setAttach2(result){
    var text  = result.split("||");
    var text1 = "";

    for( var i = 0; i < text.length ; i++ ){
        
        text1  += text[i] + "<br/>";
    }
    
    document.getElementById("attach_no_text").innerHTML = text1;
}


//그리드 파일첨부
function setAttach_Grid(attach_key, arrAttrach, attach_count) {
    var attachfilename  = arrAttrach + "";
    var result 			="";
	var attach_info 	= attachfilename.split(",");
	for (var i =0;  i <  attach_count; i ++)
    {
	    var doc_no 			= attach_info[0+(i*7)];
		var doc_seq 		= attach_info[1+(i*7)];
		var type 			= attach_info[2+(i*7)];
		var des_file_name 	= attach_info[3+(i*7)];
		var src_file_name 	= attach_info[4+(i*7)];
		var file_size 		= attach_info[5+(i*7)];
		var add_user_id 	= attach_info[6+(i*7)];

		if (i == attach_count-1)
			result = result + src_file_name;
		else
			result = result + src_file_name + ",";
	}
	GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO")).setValue(attach_key);
	GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO_CNT")).setValue(attach_count);
	document.forms[0].isGridAttach.value = "false";
}

</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
  
<form name="form1">
	<input type="hidden" name="FLAG" id="FLAG" value="">
	<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>">
	<input type="hidden" name="ANN_ITEM" id="ANN_ITEM" value="<%=ANN_ITEM%>">
	<input type="hidden" name="COST_STATUS" id="COST_STATUS" value="<%=COST_STATUS%>">
	<input type="hidden" name="BID_STATUS"id="BID_STATUS" value="<%=BID_STATUS%>">
	<input type="hidden" name="PROM_CRIT"    id="PROM_CRIT"    value="<%=PROM_CRIT%>">
	<input type="hidden" name="CERTV"        id="CERTV"        value="">
	<input type="hidden" name="TIMESTAMP"    id="TIMESTAMP"    value="">
	<input type="hidden" name="SIGN_CERT"    id="SIGN_CERT"    value="">
	<input type="hidden" name="TMAX_RAND"    id="TMAX_RAND"    value="">
	<input type="hidden" name="CRYP_CERT"    id="CRYP_CERT"    value="<%=CRYP_CERT%>">
	<input type="hidden" name="H_ESTM_PRICE" id="H_ESTM_PRICE" value="">
	<input type="hidden" name="ESTM_PRICE_H" id="ESTM_PRICE_H" value="">
	<input type="hidden" name="ESTM_PRICE1_ENC" id="ESTM_PRICE1_ENC" value="<%=ESTM_PRICE1_ENC%>">

	<input type="hidden" name="attach_gubun" 	value="body"> 
	<input type="hidden" name="att_show_flag">
	<input type="hidden" name="attach_seq">	
	<input type="hidden" name="isGridAttach">
	<input type="hidden" name="only_attach" id="only_attach" value="">
	<input type="hidden" name="att_mode"  		value="">
	<input type="hidden" name="view_type"  		value="">
	<input type="hidden" name="file_type"  		value="">
	<input type="hidden" name="tmp_att_no" 		value="">
	<input type="hidden" name="approval_str"  	value="">
	
	<input type="hidden" name="ADD_USER_ID" id="ADD_USER_ID" value="<%=ADD_USER_ID%>"> 
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
    <colgroup>
        <col width="15%" />
        <col width="35%" />
        <col width="15%" />
        <col width="35%" />
    </colgroup>   
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      <td width="35%" colspan="3" class="data_td">&nbsp;
        <%=ANN_NO%>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고일자</td>
      <td width="35%" class="data_td">&nbsp;
      <%=ANN_DATE%>
      </td>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰방법</td>
      <td width="35%" class="data_td">&nbsp;
        <%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME %>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰건명</td>
      <td width="35%" class="data_td">&nbsp;
        <%=ANN_ITEM%>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 총예상금액</td>
      <td class="data_td">&nbsp;
        <%=SepoaMath.SepoaNumberType(Double.parseDouble(PR_AMT_NOVAT),"###,###,###,###,###.##")%>&nbsp;원&nbsp;(VAT 포함)
      </td>
	<!--
      <td class="cell_title" width="15%">배정예산</td>
      <td width="35%">&nbsp;
        <%//=WiseString.formatNum(Long.parseLong(PR_AMT))%>
      </td>
	-->
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
			        if(!COST_STATUS.equals("EC")) {
				%>
<%-- 	      			<TD><script language="javascript">btn("javascript:doSave('T')", "임시저장")</script></TD> --%>
	      			<TD><script language="javascript">btn("javascript:doSave('C')", "확 정")</script></TD>
				<%
			        }
				%>
	      			<TD><script language="javascript">btn("javascript:history.back(-1)", "취 소")</script></TD>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table> 


<s:grid screen_id="BD_013" grid_obj="GridObj" grid_box="gridbox"/>
<br>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    <tr>
      	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 예정가격</td>
      	<td class="data_td">&nbsp;
		<%
		    if(COST_STATUS.equals("EC")) {
		%>
	        <input type="text" name="BASIC_AMT" id="BASIC_AMT" value="<%=SepoaMath.SepoaNumberType(Double.parseDouble(BASIC_AMT),"###,###,###,###,###.##")%>" readonly  style="text-align: right;" >
		<%
		    } else {
		%>
        	<input type="text" name="BASIC_AMT" id="BASIC_AMT" value="<%=SepoaMath.SepoaNumberType(Double.parseDouble(BASIC_AMT),"###,###,###,###,###.##")%>" onblur="javascript:setOnBlur(this);" onFocus="javascript:setOnFocus(this);"  style="text-align: right;">
		<%
		    }
		%>
        &nbsp;원&nbsp;(VAT포함)
      	</td>
      	
      	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 요율</td>
      	<td class="data_td">&nbsp;
      	
		<%
		    if(COST_STATUS.equals("EC")) {
		%>
	        <input type="text" name="BASIC_RATE" id="BASIC_RATE" value="<%=SepoaMath.SepoaNumberType(Double.parseDouble(ESTM_RATE),"###,###,###,###,###.##")%>" readonly  style="text-align: right;background-color: #f6f6f6;border: 0px;"> %
		<%
		    } else {
		%>
        	<input type="text" name="ESTM_RATE" id="ESTM_RATE" value="<%=SepoaMath.SepoaNumberType(Double.parseDouble(ESTM_RATE),"###,###,###,###,###.##")%>" readonly  style="text-align: right;background-color: #f6f6f6;border: 0px;"> %
		<%
		    }
		%>      	
      	</td>      	
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	    
    <tr>
      	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 내정가격 <font color="red"><b>*</b></font> </td>
      	<td width="35%" class="data_td">&nbsp;
		<%
		    if(COST_STATUS.equals("EC")) { // 예가확정
		%>

        	<input type="text" name="ESTM_PRICE" id="ESTM_PRICE" class="input_re" value="" readonly  style="text-align: right;"  >
		<%
		    } else {
		%>
        	<input type="text" name="ESTM_PRICE" id="ESTM_PRICE" class="input_re" value="" onblur="javascript:setOnBlur(this);" onFocus="javascript:setOnFocus(this);"  style="text-align: right;" >
		<%
		    }
		%>
        &nbsp;원&nbsp;(VAT포함)
      	</td>
      	<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 확인가격 </td>
      	<td width="35%" class="data_td">&nbsp;
		<%
		    if(COST_STATUS.equals("EC")) {
		%>
	        <input type="text" name="ESTM_PRICE_CONF" id="ESTM_PRICE_CONF" class="input_re" value="" readonly style="text-align: right;"  >
		<%
			} else {
		%>
        	<input type="text" name="ESTM_PRICE_CONF" id="ESTM_PRICE_CONF" class="input_re" value="" onblur="javascript:setOnBlur(this);" onFocus="javascript:setOnFocus(this);" style="text-align: right;"  >
		<%
			}
		%>
        &nbsp;원&nbsp;(VAT포함)
      	<input type="hidden" name="ESTM_PRICE_CONF_ENC" id="ESTM_PRICE_CONF_ENC">
      	</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
		
		<td class="data_td" colspan="3" height="150" align="center">
			<table border="0" style="padding-top: 10px; width: 100%;">
				<tr>
					<td>
						<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
					</td>
				</tr>
			</table>
		</td>		
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  	
    <tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="6" align="absmiddle">&nbsp;&nbsp; MEMO</td>
      	<td colspan="3" class="data_td">&nbsp;
		<%
		    if(COST_STATUS.equals("EC")) {
		%>
        	<textarea name="REQ_COMMENT" id="REQ_COMMENT" cols="85" rows="5"  readonly ><%=MEMO%></textarea>
		<%
		    } else {
		%>
        	<textarea name="REQ_COMMENT" id="REQ_COMMENT" cols="85" rows="5"  onKeyUp="return chkMaxByte(4000, this, 'MEMO');"><%=MEMO%></textarea>
		<%
		    }
		%>
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
<%-- 
<form name="form2" action="/kr/certificate_wk_dis.jsp" method="post" target="child_frame">
	<input type="hidden" 	name="function" value="doSignConfirm">
	<textarea name="signdata" 	style="display:none;"></textarea>
	<textarea name="vid_msg" 	style="display:none;"></textarea>
	<textarea name="plainText" 	style="display:none;"></textarea>	
	<textarea name="CERTV" 		style="display:none;"></textarea><!-- 전자서명값-->
	<textarea name="SIGN_CERT" 	style="display:none;"></textarea><!-- 전자서명 인증서번호-->
	<textarea name="CRYP_CERT" 	style="display:none;"></textarea><!-- 전자서명 인증서번호-->	
	<textarea name="TIMESTAMP" 	style="display:none;"></textarea><!-- TIMESTAMP-->
</form>
--%>
<IFRAME SRC="" NAME="child_frame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></IFRAME>
</s:header>
<s:footer/>
</body>
</html> 