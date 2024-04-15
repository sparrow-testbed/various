<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    Vector multilang_id = new Vector();
 
	HashMap text = MessageUtil.getMessageMap( info, "MESSAGE", "BUTTON", "SBD_002" );

	Config conf = new Configuration();
    String buyer_company_code = conf.getString("sepoa.buyer.company.code");
	String user_type  = info.getSession("USER_TYPE");
	String seller_code= "";
  
    String  current_date      = SepoaDate.getShortDateString();  
    String  current_time      = SepoaDate.getShortTimeString();  
     
    //Dthmlx Grid 전역변수들..
    String screen_id = "SBD_002";
    String grid_obj = "GridObj";
    // 조회용 화면인지 데이터 저장화면인지의 구분
    boolean isSelectScreen = false; 
    
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
 

    String VENDOR_NAME           = "";
    String IRS_NO                = "";
    String ADDRESS               = "";
    String TEL_NO                = "";
    String CEO_NAME_LOC          = "";
    String USER_NAME             = "";
    String USER_POSITION         = "";
    String USER_PHONE            = "";
    String USER_MOBILE           = "";
    String USER_EMAIL            = "";
    String PURCHASE_BLOCK_FLAG	 = "";
    String COMPANY_REG_NO        = "";
    String BDAP_CNT              = "";
    String ANN_NO                = "";
    String ANN_ITEM              = "";
    String CONT_TYPE2            = "";

	String TECH_DQ				 = "";
    String loading_flag          = "";
    String disp_current_date = current_date.substring(0, 4) + "년 " + current_date.substring(4, 6) + "월 " + current_date.substring(6, 8) + "일";
    TECH_DQ = "".equals(TECH_DQ) ? "0" : TECH_DQ;

    String BID_NO        = JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
    String BID_COUNT     = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
   
	Map< String, String >   mapData = new HashMap< String, String >();
	mapData.put( "BID_NO", BID_NO );
	mapData.put( "BID_COUNT", BID_COUNT );
 
    Object[]    obj = { mapData };
    SepoaOut    so  = ServiceConnector.doService( info, "SBD_002", "CONNECTION", "getBdRegister", obj );
    SepoaFormater wf = new SepoaFormater( so.result[0] );
    
    

    if(wf != null) {
        if(wf.getRowCount() > 0) { //데이타가 있는 경우
 
	        VENDOR_NAME                     = wf.getValue("VENDOR_NAME"      ,0);
	        IRS_NO                          = wf.getValue("IRS_NO"           ,0);
	        ADDRESS                         = wf.getValue("ADDRESS"          ,0);
	        TEL_NO                          = wf.getValue("TEL_NO"           ,0);
	        CEO_NAME_LOC                    = wf.getValue("CEO_NAME_LOC"     ,0);
	        COMPANY_REG_NO                  = wf.getValue("COMPANY_REG_NO"   ,0);
	        BDAP_CNT                        = wf.getValue("BDAP_CNT"         ,0);
	
	        USER_NAME                       = wf.getValue("USER_NAME"        ,0);
	        USER_POSITION                   = wf.getValue("USER_POSITION"    ,0);
	        USER_PHONE                      = wf.getValue("USER_PHONE"       ,0);
	        USER_MOBILE                     = wf.getValue("USER_MOBILE"      ,0);
	        USER_EMAIL                      = wf.getValue("USER_EMAIL"       ,0);
	        PURCHASE_BLOCK_FLAG				= wf.getValue("PURCHASE_BLOCK_FLAG",0);
	
	        wf = new SepoaFormater(so.result[1]);
	
	        ANN_NO                       = wf.getValue("ANN_NO"              ,0);
	        ANN_ITEM                     = wf.getValue("ANN_ITEM"            ,0);
	        CONT_TYPE2                   = wf.getValue("CONT_TYPE2"          ,0);
	        TECH_DQ						 = wf.getValue("TECH_DQ"          	 ,0);
	
	        wf = new SepoaFormater(so.result[2]);
	
	        loading_flag                 = wf.getValue(0, 0);
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

		<%
			if("Y".equals(PURCHASE_BLOCK_FLAG)){
		%>
			<script language="javascript" type="text/javascript">
				alert("거래가 중지되었습니다.\n담당자에게 문의하십시요.");
				history.back();
			</script>	
			
		<%
				return;
			}
		%>
<script language="javascript" type="text/javascript">
<!--

    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";

	var mode;
	var button_flag = false;

    var date_flag;
	var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";

    function doBidRegister() {
		/*
        if(button_flag == true) {
            alert("작업이 진행중입니다.");
            return;
        }
		*/
        button_flag = true;
		if(LRTrim(document.forms[0].USER_NAME.value) == "") {
			alert("담당자명을 입력하세요.");
			document.forms[0].USER_NAME.focus();
            return;
		}

		if(LRTrim(document.forms[0].USER_PHONE.value) == "") {
			alert("담당자 전화번호를 입력하세요.");
			document.forms[0].USER_PHONE.focus();
            return;
		}

		if(LRTrim(document.forms[0].USER_MOBILE.value) == "") {
			alert("담당자 핸드폰번호를 입력하세요.");
			document.forms[0].USER_MOBILE.focus();
            return;
		}

		if(LRTrim(document.forms[0].USER_EMAIL.value) == "") {
			alert("담당자 EMAIL 입력하세요.");
			document.forms[0].USER_EMAIL.focus();
            return;
		}

		re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
	    if(!re.test(document.forms[0].USER_EMAIL.value)) {
			alert("담당자 EMAIL 이 잘못되었습니다.");
			document.forms[0].USER_EMAIL.focus();
            return;
	    }

        if(!confirm("1단계 입찰서를 제출하시겠습니까?")) {
            button_flag = false;
            return;
        }
		 
 
  		<%
  			/**
  	 		 * (LP)총액													가격입찰 
  	 		 * (TE)2단계경쟁			첨부파일 비필수						기술점수 > 0 일때 첨부파일필수 
  	 		 * (NE)협상에의한계약	기술점수 > 0 일때 첨부파일필수			첨부파일 비필수
  	 		 */  	
  			// 협상에의한 계약	 기술점수 > 0  
  			if(!"LP".equals(CONT_TYPE2) && Double.parseDouble(TECH_DQ) > 0 ){
		%>
  				if(parseFloat(LRTrim(document.forms[0].attach_cnt.value))<=0||LRTrim(document.forms[0].attach_cnt.value)=="")
  				{
		   			alert("제출해야할 문서가 첨부되지 않았습니다.\n\n첨부된 문서는 1단계 평가에서 사용됩니다.");
           			return;
				}
		<%
			}
		%>
			setRegister(); 
	}

    function setRegister() {

        var nickName    = "SBD_002";
        var conType     = "TRANSACTION";
        var methodName  = "setBdAcceptInsert";
        var SepoaOut    = doServiceAjax( nickName, conType, methodName );

        if( SepoaOut.status == "1" ) { // 성공
            alert( SepoaOut.message );
            history.back(-1);
        } else { // 실패
            alert( SepoaOut.message );
        }
        /*
        document.forms[0].action="bd_accept_popup_save.jsp";
        document.forms[0].method="POST";
        document.forms[0].target="work";
        document.forms[0].submit();
        */
    }

    function init() {
        if("<%=loading_flag%>" == "N") {
            alert("입찰서 제출기간이 아닙니다.");
            history.back(-1);
        }
    }
 // 첨부파일
    function setAttach(attach_key, arrAttrach, rowId, attach_count) {
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

//-->
</Script>
</head>

<body bgcolor="#FFFFFF" text="#000000" onLoad="init();">
 <s:header>
<form name="form" method="post" action="">
	<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>">
	<input type="hidden" name="BDAP_CNT" id="BDAP_CNT" value="<%=BDAP_CNT%>">
 
	<input type="hidden" name="attach_gubun" value="body">  
	<input type="hidden" name="att_show_flag">
	<input type="hidden" name="attach_seq">	
	<input type="hidden" name="isGridAttach">
	<input type="hidden" name="only_attach" id="only_attach" value="">
	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
 
<%@ include file="/include/sepoa_milestone.jsp"%>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="5"> </td>
    </tr>
    <tr>
        <td width="100%" valign="top"><table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
            <table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>  
                <tr>
      <td width="15%" class="tit">공급업체명</td>
      <td class="" width="35%">&nbsp;
        <%=VENDOR_NAME%>
      </td>
      <td width="15%" class="tit">사업자등록번호</td>
      <td class="" width="35%">&nbsp;
        <%=IRS_NO%>
      </td>
    </tr>
    <tr>
      <td class="tit" width="15%">주소</td>
      <td class="" width="35%">&nbsp;
      <%=ADDRESS%>
      </td>
      <td class="tit" width="15%">전화번호</td>
      <td class="" width="35%">&nbsp;
      <%=TEL_NO%>
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">대표자</td>
      <td class="" width="35%" colspan="3">&nbsp;
        <%=CEO_NAME_LOC%>
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">담당자명</td>
      <td class="" width="35%">&nbsp;
        <input type="text" name="USER_NAME" id="USER_NAME" size="20" class="input_re" value="<%=USER_NAME%>" onKeyUp="return chkMaxByte(50, this, '담당자명');">
      </td>
      <td width="15%" class="tit">직위</td>
      <td class="" width="35%">&nbsp;
        <input type="text" name="USER_POSITION" id="USER_POSITION" size="20" class="inputsubmit" value="<%=USER_POSITION%>" onKeyUp="return chkMaxByte(20, this, '직위');">
      </td>
    </tr>
    <tr>
      <td class="tit" width="15%">전화번호</td>
      <td class="" width="35%">&nbsp;
        <input type="text" name="USER_PHONE" id="USER_PHONE" size="20" class="input_re" value="<%=USER_PHONE%>" style="ime-mode:disabled;" onKeyPress="checkNumberFormat('[0-9]', this)" onKeyUp="return chkMaxByte(20, this, '전화번호');">
      </td>
      <td class="tit" width="15%">핸드폰번호</td>
      <td class="" width="35%">&nbsp;
        <input type="text" name="USER_MOBILE" id="USER_MOBILE" size="20" class="input_re" value="<%=USER_MOBILE%>" style="ime-mode:disabled;" onKeyPress="checkNumberFormat('[0-9]', this)" onKeyUp="return chkMaxByte(20, this, '핸드폰');">
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">EMAIL</td>
      <td class="" width="35%" colspan="3">&nbsp;
        <input type="text" name="USER_EMAIL" id="USER_EMAIL" size="40" class="input_re" value="<%=USER_EMAIL%>" onKeyUp="return chkMaxByte(100, this, 'EMAIL');">
      </td>
    </tr>
    </table>
<br> 
	<table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td class="tit" width="15%">입찰공고번호</td>
      <td class="" width="85%">&nbsp;<%=ANN_NO%>
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">입찰건명</td>
      <td class="" width="85%">&nbsp;<%=ANN_ITEM%>
      </td>
    </tr> 
<tr>
	<td class="tit" width="15%">관련문서 첨부</td>
	<td class="" colspan="3" height="200"> 
        				<TABLE>
    		      			<TR>
    		      				<td><input type="hidden" name="attach_no" id="attach_no" value=""></td>
    	    	  				<td>	
    	    	  					<script language="javascript">
//     	    	  						btn("javascript:attach_file(document.forms[0].attach_no.value,'QTA');document.forms[0].attach_seq.value=1","파일첨부")
    	    	  						btn("javascript:attach_file(document.getElementById('attach_no').value, 'QTA');", "파일첨부");
    	    	  					</script>
    	    	  				</td>
<%--     		      				<td><input type="text" name="attach_cnt" id="attach_cnt" size="3" class="div_empty_num_no" readonly value="<%=ATTACH_CNT%>"> --%>
    		      				<td><input type="text" name="attach_cnt" id="attach_cnt" size="3" class="div_empty_num_no" readonly value="">
                                    <input type="text" size="5" readOnly class="div_empty_no" value="<%=text.get("MESSAGE.file_count")%>" name="file_count">
                                </td>
                                <td width="170">
                                    <div id="attach_no_text"></div>
                                </td>
    						</TR>
						</TABLE>
	</td>
</tr>
<!--
<%
//    }
%>
-->
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td></td>
    </tr>
  </table>

  <table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td></td>
    </tr>
  </table>
  <br>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr  align="center">
      <td>
본인은 위의 번호로 공고한 귀사의  입찰에 참가하고자 입찰유의서 및 입찰공고사항과 계약조건 등 <br>
입찰 및 계약에 필요한 모든 사항을 숙지하고 이를 승낙하며 관련 문서를 제출합니다.
      </td>
    </tr>
  </table>
<br>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr  align="center">
      <td>
<b>신청인 : <%=VENDOR_NAME%> </b>
      </td>
    </tr>
  </table>
  <br>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr  align="center">
      <td>
<b><%=disp_current_date%></b>
      </td>
    </tr>
	  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
	    	<tr>
	      		<td height="30" align="right">
					<TABLE cellpadding="0">
			      		<TR>
			      			<TD><script language="javascript">btn("javascript:doBidRegister()", "1단계입찰서제출")</script></TD>
	                        <td><script language="javascript">btn("javascript:history.back(-1)", "취 소")</script></td>
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