<!--
 Title:                 hico_tb_sg1.jsp <p>
 Description:           SUPPLY / ADMIN /  screening <p>
 Copyright:             Copyright (c) <p>
 Company:               ICOMPIA <p>
 @author                SHYI<p>
 @version
 @Comment

-->
<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String vendor_code = JSPUtil.CheckInjection(request.getParameter("vendor_code"))==null?"":JSPUtil.CheckInjection(request.getParameter("vendor_code"));
	String irs_no      = JSPUtil.CheckInjection(request.getParameter("irs_no"))==null?"":JSPUtil.CheckInjection(request.getParameter("irs_no"));
	String sg_refitem = JSPUtil.CheckInjection(request.getParameter("sg_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_refitem")); //소싱 그룹 구분키
	String status     = JSPUtil.CheckInjection(request.getParameter("status"))==null?"":JSPUtil.CheckInjection(request.getParameter("status"));
    
	if("".equals(sg_refitem) || sg_refitem == null)
		sg_refitem = "0";

	String buyer_house_code   = JSPUtil.CheckInjection(request.getParameter("buyer_house_code"))==null?"":JSPUtil.CheckInjection(request.getParameter("buyer_house_code"));
	String popup       = JSPUtil.nullToEmpty(request.getParameter("popup"));
	//WiseInfo info = new WiseInfo(buyer_house_code,"HOUSE_CODE="+buyer_house_code+"^@^ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	SepoaFormater wf        = null;
	SepoaFormater wf_sub    = null;
	SepoaOut value = null;
	SepoaRemote remote      = null;

	int count 	= -1;
	String IS_EXIST= "";
	String nickName= "s6006";
	String conType = "CONNECTION";
	String MethodName = "isSgExist";
	String[] param = {vendor_code, sg_refitem};

	try {
		remote = new SepoaRemote(nickName, conType, info);
	    value = remote.lookup(MethodName, param);

	    if(value.status == 1) {
	      wf = new SepoaFormater(value.result[0]);
	      count 	= Integer.parseInt(wf.getValue("count", 0));
	      IS_EXIST 	= wf.getValue("IS_EXIST", 0);
	    }
	}catch(SepoaServiceException wse) {
		    Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		    Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		    Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
		    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		    
	}finally{
		    try{
		      remote.Release();
		    } catch(Exception e){}
	}

	String s_pass_cnt         = "0";
	String s_template_refitem = "";
	String c_template_refitem = "";
	String MAX_SCALE_COUNT	  = "";
	SepoaOut value_sub = null;
	String[] args = new String[1];
	if(count == 0) {
		args[0] = sg_refitem;
		MethodName = "getScreenList";

		try {
			remote = new SepoaRemote(nickName, conType, info);
	        value = remote.lookup(MethodName, args);

	        if(value.status == 1) {
				wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() > 0) {
		          	s_pass_cnt         = wf.getValue("PASS_CNT", 0);
		          	s_template_refitem = wf.getValue("S_TEMPLATE_REFITEM", 0);
		            c_template_refitem = wf.getValue("C_TEMPLATE_REFITEM", 0);
		            MAX_SCALE_COUNT	   = wf.getValue("MAX_SCALE_COUNT", 0);
				}
	        }
	    } catch(SepoaServiceException wse) {
	    	Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
	    	Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
	    	Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	    }catch(Exception e) {
	    	Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    	
	    } finally {
	    	try{
	       		remote.Release();
    		} catch(Exception e){}
	    }
	}

	int row_cnt = wf.getRowCount();
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

</head>
<script language="javascript">
//<!--
 	function setData(){
    	f = document.form1;
//    	var chk = "true";
		var chk_cnt  = 0;
    	var pass_cnt = '<%=s_pass_cnt%>';

    	for(i=0; i < f.answered_seq.length; i++) {
      		if(f.answered_seq[i].value == '') {
        		alert('모든항목을 빠짐없이 체크해주세요.');
        		return;
      		}
    	}

		if ( f.s_factor_refitem.length > 1 ){
			for(i=0; i < f.s_factor_refitem.length; i++) {
		    	if(f.answered_seq[i].value == f.required_seq[i].value) {
            		chk_cnt++;
            	}
        	}
        } else {
        	if(f.answered_seq.value == f.required_seq.value) {
            	chk_cnt++;
            }
        }
        if(chk_cnt >= pass_cnt){
            f.isSuccess.value = "true";
        }else{
            f.isSuccess.value = "false";
        }

//        alert("스크리닝 평가항목을 작성해 주셔서  감사합니다.\n전략구매팀 드림");
		var value = confirm('업체등록평가 정보를 저장하시겠습니까?');
		if(value){
	        f.action = "hico_scr_ins.jsp";
    	    f.submit();
		}
	}

  function setData2(){
  /*
  	alert("업체등록평가평가 항목이 없습니다.");
  	return;
  */
  // 소싱그룹 필수체크

  var f = document.form1;
  var s_type1 = parent.lis10_top.document.forms[0].s_type1.value; // 소싱대분류
  var s_type2 = parent.lis10_top.document.forms[0].s_type2.value; // 소싱중분류
  var s_type3 = parent.lis10_top.document.forms[0].s_type3.value; // 소싱소분류

  if(s_type1 == "" || s_type2 == "" || s_type3 == ""){
  	alert("소싱그룹 대분류,중분류,소분류를 모두 선택해주세요.");
  	return;
  }

  document.forms[0].s_type1.value = s_type1;
  document.forms[0].s_type2.value = s_type2;
  document.forms[0].s_type3.value = s_type3;

  var value = confirm('저장하시겠습니까?');
	if(value){
		f.action = "hico_scr_ins.jsp";
    	f.submit();
	}


<%--
    f = document.form1;

    f.isSuccess.value = "true";
    f.action = "hico_scr_ins.jsp";
    f.submit();
--%>
  }

  function checkData(cnt, value) {
    <%if(row_cnt==1){%>
    document.all.answered_seq.value = value;
    <%}else{%>
    document.all.answered_seq[cnt].value = value;
    <%}%>
  }

  function goPrev(file_name, page_id){
    // parent.home_top.goCreate(file_name, page_id);
    top.home_top.goCreate(file_name, page_id);
  }

  function init() {
	document.location.href	= "hico_bd_lis10_body1.jsp?vendor_code=<%=vendor_code%>&sg_refitem=<%=sg_refitem%>&status=<%=status%>&buyer_house_code=<%=buyer_house_code%>&popup=<%=popup%>"
	return;
<%--
    alert('이미 등록된 소싱그룹입니다.\n등록하시려면 다른 소싱그룹을 선택하세요.');
    return;
--%>
    //goPrev("hico_bd_lis12.jsp", 12);
  }

  function init2() {
<%
	if (sg_refitem.equals("")) {
%>
		return;
<%
	}
%>
    //goPrev("hico_bd_lis12.jsp", 12);
  }

function MATERIAL_TYPE_Changed()
{
  clearMATERIAL_CTRL_TYPE();
  clearMATERIAL_CLASS1();

  var id = "SL0121";
  var code = "2";

  var value = form1.s_type1.value;
  target = "MATERIAL_CTRL_TYPE";

  data = "/kr/master/sg/sou_bd_lis1_hidden_nonses.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    // document.home_wk.location.href = data;

    document.form1.target="home_wk"
    document.form1.method="post";
    document.form1.action = data;
    document.form1.submit();
}

function clearMATERIAL_CTRL_TYPE()
{
  if(form1.s_type2.length > 0)
  {
    for(i=form1.s_type2.length-1; i>=0;  i--) {
      form1.s_type2.options[i] = null;
    }
  }
}

function clearMATERIAL_CLASS1()
{
  if(form1.s_type3.length > 0)
  {
    for(i=form1.s_type3.length-1; i>=0;  i--)
    {
      form1.s_type3.options[i] = null;
    }
  }
}

function setMATERIAL_CLASS1(name, value)
{
  var option1 = new Option(name, value, true);
  form1.s_type2.options[form1.s_type2.length] = option1;
}

function setMATERIAL_CTRL_TYPE(name, value)
{
  var option1 = new Option(name, value, true);
  form1.s_type3.options[form1.s_type3.length] = option1;
}

function MATERIAL_CTRL_TYPE_Changed()
{
  clearMATERIAL_CLASS1();

  var id = "SL0121";
  var code = "3";

  var value = form1.s_type2.value;
  target = "MATERIAL_TYPE";

  data = "/kr/master/sg/sou_bd_lis1_hidden_nonses.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    //document.home_wk.location.href = data;
    document.form1.target="home_wk"
    document.form1.method="post";
    document.form1.action = data;
    document.form1.submit();
}

function NextPage()
{
	parent.parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','hide','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','show','m77','','hide');
	parent.parent.up.goPage('pl');
}
function BackPage()
{
	parent.parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide');
	parent.parent.up.goPage('qr');
}
function doConfirm()
{
	if(!confirm("아이디신청 하시겠습니까?"))
		return;

	var f = document.form1;

	f.mode.value= "doConfirm";
	f.method 	= "post"
	f.action 	= "hico_scr_ins.jsp";
    f.submit();


}

 //-->
</script>

<body bgcolor="" text="#000000" leftmargin="0" topmargin="0" <%if(count > 0) {%>onLoad="javascript:init();"<%}else if(count < 0){%>onLoad="javascript:init2();"<%}%>>
<s:header popup="true">
<%
	if(count == 0) {
%>
<form name="form1">
	<input type="hidden" name="s_type1">
	<input type="hidden" name="s_type2">
	<input type="hidden" name="s_type3">
	<input type="hidden" name="mode">

  <table border=1 cellpadding=0 cellspacing=0 width="100%">
        <tr>
          <table border=0 cellpadding=0 cellspacing=0 width="100%">
<%
    String s_factor_refitem = "";
    String factor_name      = "";
    String factor_type      = "";
    String scale_count      = "";
    String required_seq     = "";
    
    if (wf.getRowCount() > 0) {
%>
            <td colspan="<%=MAX_SCALE_COUNT%>" class="c_title">
            <strong> * "저장" 버튼을 클릭하여  업체등록평가를 완료하여 주십시요.</strong>
            </td>
          </tr>

          <input type="hidden" name="s_template_refitem" value="<%=s_template_refitem%>">
          <input type="hidden" name="c_template_refitem" value="<%=c_template_refitem%>">
          <input type="hidden" name="isSuccess">
          <input type="hidden" name="sg_refitem" value="<%=sg_refitem%>">
          <input type="hidden" name="vendor_code" value="<%=vendor_code%>">
           <input type="hidden" name="irs_no" value="<%=irs_no%>">
          <input type="hidden" name="status" value="<%=status%>">
          <input type="hidden" name="buyer_house_code" value="<%=buyer_house_code%>">
<%
		for(int i=0; i < row_cnt; i++) {
	        s_factor_refitem = wf.getValue("S_FACTOR_REFITEM", i);
	        factor_name      = wf.getValue("FACTOR_NAME", i);
	        factor_type      = wf.getValue("FACTOR_TYPE", i);
	        scale_count      = wf.getValue("SCALE_COUNT", i);
	        required_seq     = wf.getValue("REQUIRED_SEQ", i);

			//질문별 체크항목 조회
			MethodName = "getScreenItem";
	        args[0] = s_factor_refitem;
	        try {
				remote = new SepoaRemote(nickName, conType, info);
		        value_sub = remote.lookup(MethodName, args);
		        if(value_sub.status == 1) {
		            wf_sub = new SepoaFormater(value_sub.result[0]);
		        }
	        } catch(SepoaServiceException wse) {
		          Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		          Logger.debug.println(info.getSession("ID"),request,"message = " + value_sub.message);
		          Logger.debug.println(info.getSession("ID"),request,"status = " + value_sub.status);
	        } catch(Exception e) {
		          Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		          
	        } finally {
		          try {
			            remote.Release();
		          } catch(Exception e){}
	        }
%>
            <tr height=25 class="c_title_1">
            <td  colspan="<%=MAX_SCALE_COUNT%>">
            <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;<strong><%=factor_name%></strong>
            </td>
          </tr>
          <tr height=25 class="c_data_1">


<%
        String item_name = "";
        String seq = "";

        for(int j=0; j < wf_sub.getRowCount(); j++) {
          seq = wf_sub.getValue("seq", j);
          item_name = wf_sub.getValue("item_name", j);
%>
            <td  <%if(j == wf_sub.getRowCount()-1){%> colspan="<%=Integer.parseInt(MAX_SCALE_COUNT) - wf_sub.getRowCount() + 1%>" <%}%>>
              <img src="../../../images//supply/blank.gif" width="10" height="1">
              <input type="radio" name="radio_chk_<%=i%>" class="input_data1" onClick="javascript:checkData(<%=i%>, <%=seq%>);">
              <%=item_name%>
            </td>
<%
        }
%>
            <input type="hidden" name="s_factor_refitem" value="<%=s_factor_refitem%>"><!-- 문제번호-->
            <input type="hidden" name="answered_seq"><!--선택된 값이 담긴다.-->
            <input type="hidden" name="required_seq" value="<%=required_seq%>"><!-- 요구되는 기준값-->
<%
      }
%>
      </tr>
      </table>
    </td>
    </tr>
    <br><br>
    <tr>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="30">
      <tr>
        <td align="right">
          <TABLE>
          <TR>
          	<% if(popup == null || popup.equals("") || popup.equals("T") ){ %>
          		<%if(!(!popup.equals("T") && "Y".equals(IS_EXIST))){%>
          			<TD><script language="javascript">btn("javascript:setData()","저 장")</script></TD>
          		<%}%>
  					<TD><script language="javascript">btn("javascript:BackPage()","이 전")</script></TD>
  			<!--<TD><script language="javascript">btn("javascript:NextPage()",8,"다 음")</script></TD>-->
  				<%if(!popup.equals("T")){%>
  					<%if("Y".equals(IS_EXIST)){%>
		      			<!-- <TD><script language="javascript">btn("javascript:doConfirm()",21,"아이디신청")</script></TD> -->
		      		<%}%>
		      	<%}%>
  			<% } %>
          </TR>
          </TABLE>
        </td>
      </tr>
      </table>
    </tr>
<%
    } else {
    	if (!sg_refitem.equals("")) {
%>
      <tr height=25>
        <td colspan="5" class="cell1_data" align="center">
        <strong> "업체등록평가 항목이 없습니다."</strong>
          <input type="hidden" name="s_template_refitem" value="0">
          <input type="hidden" name="c_template_refitem" value="0">
          <input type="hidden" name="isSuccess">
          <input type="hidden" name="sg_refitem" value="<%=sg_refitem%>">
          <input type="hidden" name="vendor_code" value="<%=vendor_code%>">
          <input type="hidden" name="irs_no" value="<%=irs_no%>">
          <input type="hidden" name="status" value="<%=status%>">
          <input type="hidden" name="buyer_house_code" value="<%=buyer_house_code%>">
        </td>
      </tr>
      <br><br>
      <tr>
      <table width="98%" border="0" cellspacing="0" cellpadding="0" height="30">
          <tr>
 			<TD height="30" align="right">
<%
			//if(popup == null || popup.equals("") || popup.equals("T") || true ){
			if(popup == null || popup.equals("") || popup.equals("T") ){
%>
		<TABLE cellspacing="0" cellpadding="0">
		<TR>

			<!-- 최초등록시 스크린닝 없는 항목 선택시-->
			<%
				//if(!(!popup.equals("T") && "Y".equals(IS_EXIST)) || true){
				if(!(!popup.equals("T") && "Y".equals(IS_EXIST))){
			%>
			<!-- 
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
			<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:setData2();" class="btn">저장</a></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			 -->
			<TD><script language="javascript">btn("javascript:setData2()","저 장")</script></TD>
			
				<%}%>
			<TD><script language="javascript">btn("javascript:BackPage()","이 전")</script></TD>
			<TD><script language="javascript">btn("javascript:NextPage()","다 음")</script></TD>
			<!--
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
			<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:BackPage();" class="btn">이전</a></TD>
			<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			-->
<%
			if(!popup.equals("T")){
%>
				<%if("Y".equals(IS_EXIST)){%>
			<!--
				<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/btn_left.gif" width="10" height="25" /></TD>
				<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25"><a href="javascript:doConfirm();" class="btn">아이디s신청</a></TD>
				<TD width="10" align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>//btn_right.gif" width="10" height="25" /></TD>
			-->
			<%}%>
<%
			}
%>
		</TR>
		</TABLE>
<%
			}
%>
	</TD>
          </tr>
     </table>
    </tr>
<%
    	}
    }
%>
  </table>
<%
  }
%>
</form>
</s:header>
</body>
</html>


