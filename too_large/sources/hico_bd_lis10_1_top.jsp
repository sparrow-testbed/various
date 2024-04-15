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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%

	String buyer_house_code   = JSPUtil.nullToEmpty(request.getParameter("buyer_house_code"));
	//if (buyer_house_code.equals("")) buyer_house_code = "100";

	//WiseInfo info = new WiseInfo(buyer_house_code,"HOUSE_CODE="+buyer_house_code+"^@^ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String sg_refitem  = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));	//소싱 그룹 구분키
    String status      = JSPUtil.nullToEmpty(request.getParameter("status"));
    String irs_no      = JSPUtil.nullToEmpty(request.getParameter("irs_no"));
    String popup       = JSPUtil.nullToEmpty(request.getParameter("popup")); 
    
    Logger.debug.println(info.getSession("ID"), request, "#################### buyer_house_code : " + buyer_house_code );
    Logger.debug.println(info.getSession("ID"), request, "#################### vendor_code      : " + vendor_code      );
    Logger.debug.println(info.getSession("ID"), request, "#################### sg_refitem       : " + sg_refitem       );
    Logger.debug.println(info.getSession("ID"), request, "#################### status           : " + status           );
    Logger.debug.println(info.getSession("ID"), request, "#################### popup            : " + popup            );
    
    SepoaFormater wf        = null;
    SepoaFormater wf_sub    = null;
    SepoaOut value = null;
    SepoaRemote remote      = null;

	int count 	= -1;
	String sg_refitem2 = "";
	String lev1 = "";
	String lev2 = "";
	String eval_score = "";
	String IS_EXIST= "";
	String nickName= "s6006";
	String conType = "CONNECTION";
	String MethodName = "isSgExist2";
	String[] param = {vendor_code};

	try {
		remote = new SepoaRemote(nickName, conType, info);
	    value = remote.lookup(MethodName, param);

	    if(value.status == 1) {
	      wf = new SepoaFormater(value.result[0]);
	      
	      if(wf.getRowCount() > 0){
		      count 	= Integer.parseInt(wf.getValue("count", 0));
		      sg_refitem2 = wf.getValue("SG_REFITEM",0);
		      lev1 = wf.getValue("LEV1",0);
		      lev2 = wf.getValue("LEV2",0);
		      eval_score = wf.getValue("EVAL_SCORE",0);
	      }
	    }
	}catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
		
		Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
 		//e.printStackTrace();
	}finally{
		try{
			remote.Release();
		} catch(Exception e){}
	}
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
</head>
<script language="javascript">
//<!--

function init(){
		
	form1.s_type1.value = '<%=lev1%>';
	//MATERIAL_TYPE_Changed();
	doRequestUsingPOST( 'W001', '1' ,'s_type1', '<%=lev1%>' );
	
	<%
	String isDisabled = "";
	if(!"".equals(lev1)){
		isDisabled = "disabled";
	%>
		doRequestUsingPOST( 'W002', '2'+'#'+<%=lev1%> ,'s_type2', '<%=lev2%>' );
		doRequestUsingPOST( 'W002', '3'+'#'+<%=lev2%> ,'s_type3', '<%=sg_refitem2%>' );
	<%
	}
	%>
	
	
}


function initAjax(){
	doRequestUsingPOST( 'W001', '1' ,'s_type1', '' );
}

function nextAjax(type){
	
	var f = document.forms[0];
	if(type == '2'){
		
		var sg_refitem=f.s_type1.value;
		
		var s_type2_id = eval(document.getElementById('s_type2')); //id값 얻기
		s_type2_id.options.length = 0; //길이 0으로
		//s_type2_id.fireEvent("onchange"); //onchange 이벤트발생
		$(s_type2_id).trigger("onchange");
		
		if(sg_refitem.valueOf().length > 0) {
			// 공백인 option 하나 추가(전체 검색위해서)
			var nodePath = document.getElementById("s_type2");
			var ooption = document.createElement("option");
			
			ooption.text = "--------";
			ooption.value = "";
			nodePath.add(ooption);
			
			doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'s_type2', '<%=lev2%>' );
			//doRequestUsingPOST( 'SP9196', account_type ,'account_code', '' );
		}else {
			var nodePath = document.getElementById("s_type2");
			var ooption = document.createElement("option");
			
			ooption.text = "--------";
			ooption.value = "";
			nodePath.add(ooption);
		
		}
		
	}else if(type == '3'){
		var sg_refitem=f.s_type2.value;
		
		var s_type3_id = eval(document.getElementById('s_type3')); //id값 얻기
		s_type3_id.options.length = 0; //길이 0으로
		//s_type3_id.fireEvent("onchange"); //onchange 이벤트발생
		$(s_type3_id).trigger("onchange");
		
		
		if(sg_refitem.valueOf().length > 0) {
			// 공백인 option 하나 추가(전체 검색위해서)
			var nodePath = document.getElementById("s_type3");
			var ooption = document.createElement("option");
			
			ooption.text = "--------";
			ooption.value = "";
			nodePath.add(ooption);
			
			doRequestUsingPOST( 'W002', '3'+'#'+sg_refitem ,'s_type3', '<%=sg_refitem2%>' );
		}else{
			var nodePath = document.getElementById("s_type3");
			var ooption = document.createElement("option");
			
			ooption.text = "--------";
			ooption.value = "";
			nodePath.add(ooption);
		}
	}
}


function MATERIAL_TYPE_Changed()
{
	clearMATERIAL_CTRL_TYPE();
	clearMATERIAL_CLASS1();

	var id = "SL0121";
	var code = "2";

	var value = form1.s_type1.value;
	target = "MATERIAL_CTRL_TYPE";

	
	
	data = "/kr/master/sg/sou_bd_lis1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
	
    document.childFrame.location.href = data;
    
    //var buyer_house_code = "<%=buyer_house_code%>";
	//data = "/kr/master/sg/sou_bd_lis1_hidden_nonses.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value + "&buyer_house_code=" + buyer_house_code;

    // document.home_wk.location.href = data;

    //document.form1.target="lis10_wk"
  	//document.form1.method="post";
  	//document.form1.action = data;
  	//document.form1.submit();
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
	
	<%if(null != lev2 && !"".equals(lev2)){%>
	form1.s_type2.value = '<%=lev2%>';	
	MATERIAL_CTRL_TYPE_Changed();
	<%}%>
}

function setMATERIAL_CTRL_TYPE(name, value)
{
	var option1 = new Option(name, value, true);
	form1.s_type3.options[form1.s_type3.length] = option1;
	
	<%if(null != sg_refitem2 && !"".equals(sg_refitem2)){%>
	form1.s_type3.value = '<%=sg_refitem2%>';
	getScreeningList();
	<%}%>
}

function MATERIAL_CTRL_TYPE_Changed()
{
	clearMATERIAL_CLASS1();

	var id = "SL0121";
	var code = "3";

	var value = form1.s_type2.value;
	target = "MATERIAL_TYPE";
	
	data = "/kr/master/sg/sou_bd_lis1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    document.childFrame.location.href = data;

	//var buyer_house_code = "<%=buyer_house_code%>";

	//data = "/kr/master/sg/sou_bd_lis1_hidden_nonses.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value + "&buyer_house_code=" + buyer_house_code;

    //document.home_wk.location.href = data;
  	//document.form1.target="lis10_wk"
  	//document.form1.method="post";
  	//document.form1.action = data;
  	//document.form1.submit();
}

function setScreeningCrear()
{
	document.form2.target="lis10_body"
	document.form2.method="post";
	document.form2.action = "about:blank";
	document.form2.submit();
}



function getScreeningList() {
	getEvalScore(document.form1.s_type3.value);
	
	document.form2.sg_refitem.value = document.form1.s_type3.value;
	document.form2.target = "lis10_body"
	document.form2.method = "post";
	document.form2.action = "hico_bd_lis10_1_body.jsp";
	document.form2.submit();
}

function getEvalScore(sg_refitem){
	
	data = "/s_kr/admin/info/hico_bd_lis10_1_hidden.jsp?vendor_code=<%=vendor_code%>&sg_refitem="+sg_refitem;
    document.childFrame.location.href = data;
}
//-->
</script>

<body bgcolor="" text="#000000" leftmargin="0" topmargin="0" onload="javascript:init();">
<s:header popup="true">
<table border=0 cellpadding=0 cellspacing=0 width="100%">
	<tr>
		<td class="c_title">
			 <b>* 귀사가 제공하는 대표 소싱그룹을 하나만 설정하셔서 저장하여 주시기 바랍니다.</b>
<%--			 <b>소싱그룹을 선택하시면 Screening 과 CheckList 를 진행합니다.</b>--%>
		</td>
	</tr>
</table>
<br>
<form name="form1">
<input type="hidden" name="eval_score" value='<%=eval_score%>' readonly="readonly"/>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  						<tr>
								<td class="title_td" width="14%">소싱그룹 대분류</td>
								<td width="19%" class="data_td">
							    	<select id="s_type1" name="s_type1" class="inputsubmit" onchange="nextAjax(2);" <%=isDisabled %>>
							    		<option value="">--------
							    		</option>
							    	</select>								
<%-- 									<select name="s_type1" class="input_re" onChange="javacsript:MATERIAL_TYPE_Changed(); setScreeningCrear(); "> --%>
<!-- 										<option value="">선택</option> -->
<%-- 					<% --%>
<!-- //         					String listbox1 = ListBox(info, "SL0116", "#1#"+buyer_house_code, ""); -->
<!-- //         					out.println(listbox1); -->
<%-- 					%> --%>
<%-- 									</select> --%>
								</td>
								<td class="title_td" width="14%">소싱그룹 중분류</td>
								<td width="19%" class="data_td">
									<select id="s_type2" name="s_type2" class="inputsubmit" onchange="nextAjax(3);" <%=isDisabled %>>
							    		<option value="">--------
							    		</option>
							    	</select>								
<%-- 									<select name="s_type2" class="input_re" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed(); setScreeningCrear();"> --%>
<!-- 										<option value="">선택</option> -->
<%-- 									</select> --%>
								</td>
							</tr>
							<tr>
								<td class="title_td" width="14%">소싱그룹 소분류</td>
								<td width="19%" class="data_td" colspan="3">
							    	<select id="s_type3" name="s_type3" class="inputsubmit" onchange="getScreeningList();" <%=isDisabled %>>
							    		<option value="">--------
							    		</option>
							    	</select>								
<%-- 									<select name="s_type3" class="input_re" onChange="javacsript:getScreeningList();"> --%>
<!-- 										<option value="">선택</option> -->
<%-- 									</select> --%>
								</td>
							</tr>
<!-- 							<TR> -->
<!-- 								<td class="title_td" width="14%">평가점수</td> -->
<!-- 								<td width="19%" class="data_td" colspan="6"> -->
<%-- 									<input type="text" name="eval_score" value='<%=eval_score%>' readonly="readonly"/> --%>
<!-- 								</td> -->
<!-- 							</TR> -->
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>	
</form>
<form name="form2">
	<input type="hidden" name="sg_refitem" value="<%=sg_refitem%>">
	<input type="hidden" name="vendor_code" value="<%=vendor_code%>">
	<input type="hidden" name="status" value="<%=status%>">
	<input type="hidden" name="irs_no" value="<%=irs_no%>">
	<input type="hidden" name="buyer_house_code" value="<%=buyer_house_code%>">
	<input type="hidden" name="popup" value="<%=popup%>">
</form>
<iframe id="childFrame" name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
</body>
</html>


