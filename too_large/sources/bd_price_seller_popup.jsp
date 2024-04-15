<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SBD_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SBD_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bid/ebd_bd_ins1.jsp -->
<!--
Title:        FrameWork ��� Sample��㈃(PROCESS_ID)  <p>
 Description:  媛�������� �����湲곕낯 Sample(議고�) ��� �����(��� 紐⑤�紐�� ��� 媛�����댁� 湲곗�) <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      ��� 紐⑤������ �대� �ы� 湲곗�
!-->

<% //PROCESS ID ��� %>
<% String WISEHUB_PROCESS_ID="SBD_004";%>

<% //�ъ� �몄� �ㅼ�  %>
<% String WISEHUB_LANG_TYPE="KR";%>

<!-- JSP import or useBean tags here. -->
<!-- Wisehub FrameWork 怨듯� 紐⑤� Import 遺��(臾댁“嫄��ъ�) -->
<%@ include file="/include/wisehub_common.jsp"%>
<%@ page import ="crosscert.Certificate,
                  crosscert.Verifier"%>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_auth.jsp" %>
<%@ include file="/include/wisetable_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wise_cert.jsp"%>

<!--  ��� �댄� �ㅽ�由쏀�  -->
<script language="javascript" src="/include/CC_Object.js"></script>
<script language="javascript" src="/include/init.js"></script>
<script language="javascript" src="/include/CC_fnc.js"></script>

<%

    String BID_NO        = request.getParameter("BID_NO");      
    String BID_COUNT     = request.getParameter("BID_COUNT");   
    String VOTE_COUNT    = request.getParameter("VOTE_COUNT");   

    if(BID_NO == null) BID_NO ="";
    if(BID_COUNT == null) BID_COUNT ="";
    if(VOTE_COUNT == null) VOTE_COUNT ="";

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//��� ��������
    String current_time = SepoaDate.getShortTimeString();//��� �������� 

    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_NO             = "";
    String ANN_ITEM           = "";
    String CHANGE_USER_NAME_LOC= "";
    String CONT_TYPE1_TEXT_D  = "";
    String CONT_TYPE2_TEXT_D  = "";

    String CRYP_CERT          = "";

    String loading_flag       = "Y";

%>
<%
    Object[] args = {BID_NO, BID_COUNT, VOTE_COUNT};

    WiseOut value = null;
    WiseRemote wr = null;
    String nickName = "p1009";
    String MethodName = "getBDHD_Vendor";
    String conType = "CONNECTION";
    WiseFormater wf = null;

    //�ㅼ����ㅽ���class��loading��� Method�몄���寃곌낵瑜�return��� 遺���대�.
    try {
        wr = new WiseRemote(nickName,conType,info);
        value = wr.lookup(MethodName,args);

        wf = new WiseFormater(value.result[0]);

        int rw_cnt = wf.getRowCount();

        CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
        CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
        ANN_NO                       = wf.getValue("ANN_NO"                ,0);
        ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
        CHANGE_USER_NAME_LOC         = wf.getValue("CHANGE_USER_NAME_LOC"  ,0);
        CONT_TYPE1_TEXT_D            = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
        CONT_TYPE2_TEXT_D            = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);

        CRYP_CERT                    = wf.getValue("CRYP_CERT"             ,0); //��같吏����媛�같愿� ������몄���
        if(!VOTE_COUNT.equals("1")) { // �ъ�李고� 寃쎌����, �대� ��껜媛���李⑥����ъ같����껜留���� ��������.
            wf = new WiseFormater(value.result[1]);

            loading_flag             = wf.getValue("CNT"     ,0);
        }

    }catch(Exception e) {
        Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
        Logger.dev.println(e.getMessage());
    }finally{
        wr.Release();
    } // finally ��
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG ���  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="../../css/body.css" type="text/css">

<!-- �ъ������ Script -->
<!-- HEADER START (JavaScript here)-->

<%@ include file="/include/wisehub_scripts.jsp"%>

<Script language="javascript">
<!--

    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";
    var VOTE_COUNT  = "<%=VOTE_COUNT%>";

    var mode;
    var button_flag = false;

    var date_flag;
    var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
    
    var INDEX_SELECTED;
    var INDEX_NO         ;
    var INDEX_DESCRIPTION_LOC;
    var INDEX_UNIT_MEASURE ;
    var INDEX_PR_QTY;

	function setHeader() {



		GridObj.SetColCellSortEnable(     "NO", false);
		GridObj.SetColCellSortEnable(     "DESCRIPTION_LOC",false);
		GridObj.SetColCellSortEnable(     "UNIT_MEASURE",false);
		GridObj.SetNumberFormat(            "PR_QTY",       "###,###,###,###,###,###");
		
        INDEX_SELECTED                =  GridObj.GetColHDIndex("SELECTED"); 

        INDEX_NO                      =  GridObj.GetColHDIndex("NO"); 
        INDEX_DESCRIPTION_LOC         =  GridObj.GetColHDIndex("DESCRIPTION_LOC");
        INDEX_UNIT_MEASURE            =  GridObj.GetColHDIndex("UNIT_MEASURE");
        INDEX_PR_QTY                  =  GridObj.GetColHDIndex("PR_QTY");
	}

    var thistime    = "<%=current_time%>".substring(0,2);
    var thisminute    = "<%=current_time%>".substring(2,4);

    function init() {
        if("<%=loading_flag%>" == "N") {
            alert("�댁�����같��� ������ ��� ��껜��媛�꺽��같��吏�� �����������.");
            history.back(-1);
        }

setGridDraw();
setHeader();
        doSelect();
    }

    function doSelect() {

    	mode = "getBDDTDisplay";

		servletUrl = "/servlets/supply.bidding.bidd.ebd_pp_ins1";

		GridObj.SetParam("mode", mode);

		GridObj.SetParam("BID_NO", "<%=BID_NO%>");
		GridObj.SetParam("BID_COUNT", "<%=BID_COUNT%>");

		GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti";

    }

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		if(msg1 == "doQuery") {

        } else if(msg1 == "doData") { // ���/�����            alert(GD_GetParam(GridObj,0));
            button_flag = false; // 踰�� action ...  action��痍⑦�������...
            location.href = "ebd_bd_lis1.jsp";
		} else if(msg1 == "t_imagetext") {

	    } else if(msg1 == "t_header") { 

		} else if(msg1 == "t_insert") {

        }
	}

	function POPUP_Open(url, title, left, top, width, height) {
        var toolbar = 'no';
        var menubar = 'no';
        var status = 'no';
        var scrollbars = 'yes';
        var resizable = 'no';
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();
	}

    function doBid() {
        if(button_flag == true) {
            alert("�����吏��以�����.");
            return;
        }

        button_flag = true;

        ;

        if(LRTrim(document.forms[0].BID_AMT.value) == "") {
            alert("��같湲������� ����⑥����.");
            button_flag = false;
            document.forms[0].BID_AMT.focus();
            return;
        }

        if(LRTrim(document.forms[0].BID_AMT_CONF.value) == "") {
            alert("���湲������� ����⑥����.");
            button_flag = false;
            document.forms[0].BID_AMT_CONF.focus();
            return;
        }

        if(document.forms[0].BID_AMT_CONF.value != document.forms[0].BID_AMT.value) {
            alert("��같湲��怨����湲�����쇱���� ������.");
            button_flag = false;
            document.forms[0].BID_AMT_CONF.value = "";
            return;
        }

        var Message = "��� ���寃�����?";
        if(confirm(Message) != 1){
            button_flag = false;
            return;
        }

        SignData();
    }
    
    function SignData() {
    	initCert();
    	var ret;
    	var signeddata, textin;
    	var userdn;
		f = document.forms[0];

    	userdn = document.CC_Object_id.GetUserDN();
    	if( userdn == null || userdn == "" ) { 
    		alert(" �ъ���DN �����痍⑥� ����듬���");
    		return false;
    	} else {
    			UserCert = document.CC_Object_id.CC_get_cert_local(userdn)
    			if (UserCert =="") {
    				alert("�몄���異�� �ㅽ�");
    				return false;
    			} else {
    				UserCert = Repalce_cert(UserCert);
    			}
    			getR = CC_Object_id.GetRFromKey(userdn, "");
    			if (getR == "") {
    				alert("二쇰�踰��/�ъ�����몃� ���������� �몄�������.");
    				return  false;
    			}
    			ret = CC_Object_id.ValidCert_VID(userdn, getR, '<%=info.getSession("IRS_NO")%>');
    			if (ret != "0")
    			{
    				alert("������ �ㅽ�濡���같��� ������ ������. �몄���� ������湲�諛�����.");
    				history.back(-1);
    				return false;
    			}
    			
    			var certv           = "";
    	        var timestamp       = current_date + current_time;
    	        var bid_amt_cert    = timestamp;
    	        var bid_amt_enc  = del_comma(document.forms[0].BID_AMT.value);
//    	        alert(userdn);
    	        bid_amt_enc = SymmEncryption(bid_amt_enc,"SEED",timestamp);
    	        if ( bid_amt_enc == "" || bid_amt_enc == null ) {
    	        	alert("������ �ㅽ�������.");
    	        	return;
    	        } else {
    	        	bid_amt_cert        += bid_amt_enc;	
    	        }
				
				signeddata = document.CC_Object_id.genSignature(userdn, "", "SHA1RSA", bid_amt_cert)
	    		if( signeddata == null || signeddata == "" ) {
	    			errmsg = document.CC_Object_id.GetErrorContent();
	    			errcode = document.CC_Object_id.GetErrorCode();
	    			alert( "SignData :"+errmsg );
	    			return  false;
	    		} else {
	    			
	    		}
    		
				mode = "doBid";
				servletUrl = "/servlets/supply.bidding.bidd.ebd_pp_ins1";

		        GridObj.SetParam("mode",             mode);
		        GridObj.SetParam("BID_NO",           "<%=BID_NO%>");
		        GridObj.SetParam("BID_COUNT",        "<%=BID_COUNT%>");
		        GridObj.SetParam("VOTE_COUNT",       "<%=VOTE_COUNT%>");

		        GridObj.SetParam("ATTACH_NO",        LRTrim(document.forms[0].ATTACH_NO.value));
		        GridObj.SetParam("BID_AMT_ENC",      bid_amt_enc);
		        GridObj.SetParam("CERTV",            signeddata);
		        GridObj.SetParam("TIMESTAMP",        timestamp);
		        GridObj.SetParam("SIGN_CERT",        UserCert);
		        GridObj.SetParam("TMAX_RAND",        bid_amt_cert);

		        GridObj.SetParam("privateMacAddr", iSysInfo.ActiveMacAddress);
		        GridObj.SetParam("privateHost", iSysInfo.ComputerName);
		        GridObj.SetParam("privateIp", iSysInfo.IP);
		        GridObj.SetParam("registeredIp", "<%=request.getRemoteAddr()==null ? "" : request.getRemoteAddr()%>");
		        
		        GridObj.bSendDataFuncDefaultValidate=false;
				GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
				GridObj.SendData(servletUrl, "ALL", "ALL");

    	}
    }

    function tmax_bid() {
        var certv           = "";
        var timestamp       = current_date + current_time;
        var bid_amt_cert    = timestamp;

        var bid_amt_enc  = del_comma(document.forms[0].BID_AMT.value);

        //�����        if ("ok" == certapp.encrypt(bid_amt_enc, document.forms[0].CRYP_CERT.value)) {    
            bid_amt_enc = certapp.getMessage();
        } else {
            alert("������ �ㅽ�������.");
//alert("certapp.encrypt:"+certapp.getMessage());
            return;
        }

        bid_amt_cert        += bid_amt_enc;

        //������
        if ("ok" == certapp.sign(bid_amt_cert)) {    
            certv    = certapp.getMessage();
        } else {
            alert("���������ㅽ�������.");
//alert("certapp.sign:"+certapp.getMessage());
            return;
        }

        var sign_cert = certapp.getSignCert();

        var tmax_rand = certapp.getRandom();
        mode = "doBid";
        servletUrl = "/servlets/supply.bidding.bidd.ebd_pp_ins1";

        GridObj.SetParam("mode",                 mode);
        GridObj.SetParam("BID_NO",               "<%=BID_NO%>"    );
        GridObj.SetParam("BID_COUNT",            "<%=BID_COUNT%>" );
        GridObj.SetParam("VOTE_COUNT",           "<%=VOTE_COUNT%>");

        GridObj.SetParam("ATTACH_NO",            LRTrim(document.forms[0].ATTACH_NO.value));
        GridObj.SetParam("BID_AMT_ENC",      bid_amt_enc);
        GridObj.SetParam("CERTV",            certv);
        GridObj.SetParam("TIMESTAMP",        timestamp);
        GridObj.SetParam("SIGN_CERT",        sign_cert);
        GridObj.SetParam("TMAX_RAND",        tmax_rand);


        GridObj.SetParam("privateMacAddr", iSysInfo.ActiveMacAddress);
        GridObj.SetParam("privateHost", iSysInfo.ComputerName);
        GridObj.SetParam("privateIp", iSysInfo.IP);
        GridObj.SetParam("registeredIp", "<%=request.getRemoteAddr()==null ? "" : request.getRemoteAddr()%>");
        
        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
    }


    function getAttach() {
        var frm = document.forms[0];
        if(LRTrim(frm.ATTACH_CNT.value) == "0" || LRTrim(frm.ATTACH_CNT.value) == "")
        {
            FileAttach('BD','','');
        } else {
            FileAttachChange('BD', frm.ATTACH_NO.value);
        }
    }

    function setAttach(attach_key, arrAttrach, attach_count) {
        var frm = document.forms[0];
        frm.ATTACH_NO.value = attach_key;
        frm.ATTACH_CNT.value = attach_count;
    }

    function setOnFocus(obj) {
        var target = eval("document.forms[0]." + obj.name);
        target.value = del_comma(target.value);
    }

    function setOnBlur(obj) {
        var target = eval("document.forms[0]." + obj.name);

        if(IsNumber(del_comma(target.value)) == false) {
            alert("�レ�瑜���������");
            target.value = "";
            target.focus();
            return;
        }

        if(obj.name == "BID_AMT_CONF") {
            if(LRTrim(document.forms[0].BID_AMT.value) == "") {
                alert("��같湲����癒쇱� ��������");
                target.value = "";
                document.forms[0].BID_AMT.focus();
                return;
            }

            if(document.forms[0].BID_AMT_CONF.value == "") {
                return;
            }

            if(IsNumber(del_comma(document.forms[0].BID_AMT.value)) == false) {
                alert("��같湲����癒쇱� ��������");
                target.value = "";
                document.forms[0].BID_AMT.focus();
                return;
            } else {
                if(parseFloat(del_comma(document.forms[0].BID_AMT.value)) == parseFloat(del_comma(target.value))) {
                    changeMoney(target.value, 7);
                } else {
                    alert("��같湲��怨���� 湲����������. \n�ㅼ� ��������");
                    document.forms[0].BID_AMT_H.value = "";
                    target.value = "";
                    target.focus();
                    return;
                }
            }
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
			alert("媛�� ��������);
			return false;
		}
		if(isNaN(Number(commaDel(mon)))){
			//alert("�レ�濡���������);
			if (sw != 0) {
				alert("�レ�濡���������);
				document.forms[0].BID_AMT_CONF.value ="";
                document.forms[0].BID_AMT_H.value ="";
			}
			return false;
		}
		if(money.length>13){
			alert("媛����湲�����ш린瑜�����듬���");
			if (sw != 0) {
				document.forms[0].BID_AMT_CONF.value ="";
                document.forms[0].BID_AMT_H.value ="";
			}
			return false;
		}
		if(money.indexOf(".")>=0){
			alert("���濡����������");
			return false;
		}
		if(money.indexOf("-")>=0){
			alert("���濡����������");
			return false;
		}
		su = new Array("0","1","2","3","4","5","6","7","8","9");
		km = new Array("��,"��,"��,"��,"��,"��,"��,"移�,"��,"援�);
		danwi = new Array("","��,"諛�,"泥�,"留�,"��,"諛�,"泥�,"��,"��,"諛�,"泥�,"議�);
		for(j=1;j<=money.length;j++){
			for(index=0;index<10;index++){
				money = money.replace(su[index],km[index]);
			}
		}
		for(index = money.length;index>0;index=index-1){
			result = money.substring(index-1,index);
			
			if(result=="��){			
				if(i<4 || i>8){
					result = "";				
				}
				else if(i>=4 && i<8 && newResult.indexOf("留�)<0){
					result = "留�;
				}
				else if(i>=8 && i<12 && newResult.indexOf("��)<0){
					result = "��;
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
			newResult = newResult.replace("��,"");
		}
		if((newResult.indexOf("留�)-newResult.indexOf("��))==1)
			newResult = newResult.replace("留�,"");
		if((newResult.indexOf("��)-newResult.indexOf("議�))==1)
			newResult = newResult.replace("��,"");
			
			if (sw == 7) {
				document.forms[0].BID_AMT_H.value = newResult + " ��;
//				document.forms[0].BID_AMT_H.size = newResult.length*2;
				document.forms[0].BID_AMT_CONF.value = commaDel(document.forms[0].BID_AMT_CONF.value);
					
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
		
		
		//var num2Total = Math.floor(num2 * 100  / 110);
		//document.forms[0].DasseVAT.value = num2Tota;
		//alert(num2noVAT);
				
		//alert(num2);
		
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
		
		document.forms[0].BID_AMT.value = out;
		
        if(minus) out = "-" + out 
        if(dotD) return out + "." + dotD 
        else return out  
        //alert(out);
        document.forms[0].BID_AMT_CONF.value = out;
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
//-->
</Script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid��JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox��JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 洹몃━���대┃ �대깽��������몄� �⑸��� rowId ����� ID�대ŉ cellInd 媛�� 而щ� �몃���媛��硫�// �대깽��泥�━��而щ�紐�怨������� 泥�━����ㅻ㈃ GridObj.getColIndexById("selected") == cellInd �대�寃�泥�━���硫��⑸���
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 洹몃━����ChangeEvent ������몄� �⑸���
// stage = 0 ������, 1 = ����댁����, 2 = �������� true �������������ŉ false ������댁�媛��濡�����⑸���
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 ������, 1 = ����댁����, 2 = �������� true �������������ŉ false ������댁�媛��濡�����⑸���
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// ���由우�濡��곗��곕� ��� 諛���� 諛���� 泥�━ 醫����� �몄� ��� �대깽�������
// ���由우���message, status, mode 媛�� �����㈃ 媛�� �쎌��듬���
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
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}

// ��� �������� ��� ����� ������ 蹂듭���� 踰���대깽�몃� doExcelUpload �몄��������// 蹂듭����곗��곌� 洹몃━��� Load �⑸���
// !!!! �щ＼,����댄����ы�由��ㅽ���釉���곗�������대┰蹂대������ ��렐 沅����留�������doExcelUpload �ㅽ������ 諛�� 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise洹몃━������ �ㅻ�諛����status��0���명����.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:init();;GD_setProperty(document.WiseGrid);" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--�댁����-->
<%@ include file="/include/us_template_start.jsp" flush="true" %>

<form name="form1" >
	<input type="hidden" name="CRYP_CERT" value="<%=CRYP_CERT%>">

  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="title_table_top">
    <tr >
      <td class="title_table_top" >

        ��같�����

      </td>
    </tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td></td>
    </tr>
  </table>

  <table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="15%" class="cell_title">怨듦�踰��</td>
      <td class="cell_data" width="85%">&nbsp;
        <%=ANN_NO%>
      </td>
    </tr>
    <tr>
      <td width="15%" class="cell1_title">��같嫄�?</td>
      <td class="cell1_data" width="85%">&nbsp;
        <%=ANN_ITEM%>
      </td>
    </tr>
    <tr>
      <td class="cell_title" width="15%"> ��같諛⑸�</td>
      <td class="cell_data" width="85%">&nbsp;
        <%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>
      </td>
    </tr>

    <tr>
      <td class="cell1_title" width="15%"> �대����</td>
      <td class="cell1_data" width="85%">&nbsp;
      <%=CHANGE_USER_NAME_LOC%>
      </td>
    </tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td></td>
    </tr>
  </table>
  <script language="JavaScript" >
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="30">
      </td>
      <td height="30">
      </td>
    </tr>
  </table>
  <script language="JavaScript" >
</script>
  <table width="98%" border="0" cellpadding="2" cellspacing="1" class="jtable_bgcolor">
	<%=WiseTable_Scripts("100%","200")%>
  </table>
  <script language="JavaScript" >
</script>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td class="cell_title" width="15%"> ��같湲�� (KRW)</td>
      <td class="cell_data" width="35%">&nbsp;
        <input type="text" name="BID_AMT" value="" onblur="javascript:setOnBlur(this);" onFocus="javascript:setOnFocus(this);" class="input_re_right">
            &nbsp;(VAT �ы�)
      </td>
      <td class="cell_title" width="15%"> ���泥⑤�</td>
      <td class="cell_data" width="35%">&nbsp;
        <a href="javascript:getAttach();"><img src="/kr/images/button/query.gif" border="0"></a>
        <input type="text" name="ATTACH_CNT" value="" class="input_data0" readonly="readonly">
        <input type="hidden" name="ATTACH_NO" value="">
      </td>
    </tr>
    <tr>
      <td class="cell1_title" width="15%"> ���湲�� (KRW)</td>
      <td class="cell1_data" width="35%">&nbsp;
        <input type="text" name="BID_AMT_CONF" value="" onblur="javascript:setOnBlur(this);" class="input_re_right">
            &nbsp;(VAT �ы�)
      </td>
      <td class="cell1_title" width="15%"></td>
      <td class="cell1_data" width="35%">
        <input type="text" name="BID_AMT_H" value="" readonly="readonly" size="40" class="input_data1">
      </td>
    </tr>
  </table>

  <table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="20%">
        <div align="left"></div>
      </td>
      <td width="80%" height="30">
        <div align="right">
          <a href="javascript:doBid()"><img src="../../images/button/butt_je_chul.gif" align="absmiddle" border="0"></a>
          <a href="javascript:history.back(-1)"><img src="../../images/button/butt_cancel.gif" align="absmiddle" border="0"></a>
        </div>
      </td>
    </tr>
  </table>
  <br>

</form>
<!---- END OF USER SOURCE CODE ---->
<%@ include file="/include/us_template_end.jsp" flush="true" %>

<OBJECT id="iSysInfo" classid="clsid:8DAA3668-D06F-48BC-9DC2-3626B5B57DEF" codebase="http://isulnara.com/myAPP/iSysInfoX/iSysInfo.CAB#version=1,0,0,4">
<param name="copyright" value="http://isulnara.com">

</s:header>
<s:grid screen_id="SBD_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


