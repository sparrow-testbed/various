<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%@ page import="java.util.*"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_038");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String strCode = request.getParameter("code");
	String lang = request.getParameter("lang");
	String field = null;
	String line = null;
	SepoaOut value = null;
	String[][] str = new String[1][7];
	try {
		Config conf = new Configuration();
	    field = conf.get("sepoa.separator.field");
	    line  = conf.get("sepoa.separator.line");
		 /* Create Ejb Home */
		//CommonSql master;
		//Object objref = ServiceLocator.getInstance().WiseContext("CommonSql", info);
		//CommonSqlHome home = (CommonSqlHome) PortableRemoteObject.narrow(objref, CommonSqlHome.class);
		//master = home.create();

		/* change that 'how to ejb call' */
		//value = master.selectCodeUseId(info, strCode);
		//System.out.println ("##### Value-"+value.result[0]);
		//System.out.println (value.status + "|" + value.message + "|" + value.flag);
		Object[] obj = {info,strCode,lang};
		value = ServiceConnector.doService(info, "AD_037", "CONNECTION","selectCodeUseId", obj);

		if (value.status == 0) {
			SepoaFormater wf = new SepoaFormater(value.result[0], field, line);
			str = wf.getValue();
			
			for (int i=0;i<7;i++) {
				if (str[0][i] == null || str[0][i].equals("null")) {
					str[0][i] = "";
				}
				
			}
		} else {
%>
		<html>
			<script language='javascript'>
				alert('<%= value.message %>');
				self.close();
			</script>
		</html>
<%
			return;
		}

	} catch (Exception e) {
		Logger.debug.println(e.toString());

	}



%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<script language=javascript src="../js/cnkcl.js"></script>
<Script language="javascript">

function init() {
	if (document.form1.use_flag.value == "Y") {
        document.form1.use_flag2.checked = true;
    }
	if (document.form1.auto_select_flag.value == "Y") {
        document.form1.auto_select_flag2.checked = true;
    }
}


function settext() {
    var type = document.form1.type.value;
    if (type != "<%=str[0][2]%>") {
        //parent.work.location.href = "/kr/admin/wisepopup/get_bd_lis1.jsp?type="+type;
        //hIframe.location.href = "/dpos/admin/buy_admin_commonsqlpop7_mgt.jsp?type="+type;
        hIframe.location.href = "service_getcode_hidden.jsp?type="+type;
        document.form1.auto_flag.value = "Y";//자동 채번이다.
    } else {
        document.form1.id.value = "<%=strCode%>";
    }
}

function Save() {
	if(!checkData()) {
        return;
    }
	alert("popup 내용을 바꾸면 다른 여러 모듈에 영향이 감으로 전체공지 해주시기 바랍니다.");

	if (document.form1.use_flag2.checked == true) {
		document.form1.use_flag.value = "Y";
	} else {
        document.form1.use_flag.value = "N";
    }

	if (document.form1.auto_select_flag2.checked == true) {
		document.form1.auto_select_flag.value = "Y";
	} else {
        document.form1.auto_select_flag.value = "N";
    }

	document.form1.id.value = document.form1.id.value.toUpperCase();
	document.form1.Title.value = document.form1.Title.value.toUpperCase();
	document.form1.type.value = document.form1.type.value.toUpperCase();
	document.form1.Description.value = document.form1.Description.value.toUpperCase();
	document.form1.List_Item.value = document.form1.List_Item.value.toUpperCase();
	document.form1.SQL.value = document.form1.SQL.value.toUpperCase();

/*     document.form1.method = "POST";
    document.form1.target = "hIframe";
    //document.form1.action = "buy_admin_commonsqlpop_update2.jsp";
    document.form1.action = "service_commonsql_updateok.jsp";
    document.form1.submit(); */
    
	var jqa = new jQueryAjax();
	jqa.action = "service_commonsql_updateok.jsp";
	jqa.submit();
}

function review() {
	if (!checkData()) {
        return;
    }

	if (document.form1.use_flag2.checked == true) {
		document.form1.use_flag.value = "Y";
	} else {
        document.form1.use_flag.value = "N";
    }

	if (document.form1.auto_select_flag2.checked == true) {
		document.form1.auto_select_flag.value = "Y";
	} else {
        document.form1.auto_select_flag.value = "N";
    }

	document.form1.id.value = document.form1.id.value.toUpperCase();
	document.form1.Title.value = document.form1.Title.value.toUpperCase();
	document.form1.type.value = document.form1.type.value.toUpperCase();
	document.form1.Description.value = document.form1.Description.value.toUpperCase();
	document.form1.List_Item.value = document.form1.List_Item.value.toUpperCase();
	document.form1.SQL.value = document.form1.SQL.value.toUpperCase();
	type = document.form1.type.value;
	if (type != "SL" && type != "ML") {
	    alert("POPUP/LIST ID가 SL,ML일때만 미리보기가 가능합니다.");
	    return;
	}
	
	//pop_wk_rev1.jsp 페이지없음..?
 	document.form1.method = "POST";
    document.form1.target = "work";
    document.form1.action = "pop_wk_rev1.jsp";
    document.form1.submit();
}

function openreview(){
    /*type = document.form1.type.value;
    if (type == "SL" || type == "ML") {
        url = "/kr/admin/wisepopup/cod_pp_lis1.jsp?code=REVIEW";
    } else {
        url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=REVIEW&function=&values=";
    }

    var left = 50;
    var top = 100;
    var width = 750;
    var height = 500;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'no';
    var resizable = 'no';
    var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    doc.focus();*/
}

function checkData() {
 	id = document.form1.id.value;
 	Title = document.form1.Title.value;
 	type = document.form1.type.value;
 	Description = document.form1.Description.value;
 	List_Item =document.form1.List_Item.value;
 	SQL = document.form1.SQL.value;
 	if(isEmpty(id)){
	 	alert("<%=text.get("AD_038.MSG_0101")%>");
	 	document.form1.id.focus();
	 	return false;
	 }
 	if(isEmpty(Title)){
	 	alert("<%=text.get("AD_038.MSG_0102")%>");
	 	document.form1.Title.focus();
	 	return false;
	 }
	 if (type == "") {
	 	alert("<%=text.get("AD_038.MSG_0103")%>");
	 	document.form1.type.focus();
	 	return false;
	 }
        if ((type == "SP") || (type == "MP")) {
            if(isEmpty(List_Item)){
                alert("<%=text.get("AD_038.MSG_0104")%>");
                document.form1.List_Item.focus();
                return false;
            }
        }

 	 if (isEmpty(SQL)){
	 	alert("<%=text.get("AD_038.MSG_0105")%>");
	 	document.form1.SQL.focus();
	 	return false;
	 }
    if(!check_verify_flag()) return;
    return true;
}

function checkverify(flag) {
	document.form1.verify_flag.value = flag;
	if (flag == "ng") {
	  document.form1.SQL.select();
	}
}

function check_verify_flag() {
	flag = document.form1.verify_flag.value;
	if (flag == "ng") {
	  alert("<%=text.get("AD_038.MSG_0107")%>");
	  return false;
	}
	return true;
}

//Sql 검증하기
function verify() {
	document.form1.SQL.value = document.form1.SQL.value.toUpperCase();
	SQL = document.form1.SQL.value;
	if(isEmpty(SQL)){
	 	alert("<%=text.get("AD_038.MSG_0105")%>");
	 	document.form1.SQL.focus();
	 	return;
	}
	//SQL = urlEncode(SQL);
	//parent.work.location.href = "pop_wk_ver1.jsp?SQL="+SQL;
	//hIframe.location.href = "pop_wk_ver1.jsp?SQL="+SQL;
	//document.form1.action = "/dpos/admin/buy_admin_commonsqlpop4_mgt.jsp";
	
/* 	document.form1.action = "service_query_check.jsp";
	document.form1.method = "post";
	document.form1.target = "hIframe";
	document.form1.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "service_query_check.jsp";
	jqa.submit();
}


function urlEncode(src){
	var tgt = "";
	var c = "";
	for (var i = 0 ; i < src.length; i++) {
		c = src.charAt(i);
		if (c == '#')	tgt = tgt.concat("%23");
		else if (c == ' ')	tgt = tgt.concat("+");
		else if (c == '+')	tgt = tgt.concat("%2B");
		else if (c == '=')	tgt = tgt.concat("%3D");
		else if (c == '&')	tgt = tgt.concat("%26");
		else if (c == '%')	tgt = tgt.concat("%25");
		else if (c == '#')	tgt = tgt.concat("%23");
		else if (c == '"')	tgt = tgt.concat("%22");
		else if (c == '\'')	tgt = tgt.concat("%27");
		else if (c == ';')	tgt = tgt.concat("%3B");
		else if (c == ':')	tgt = tgt.concat("%3A");
		else 	tgt = tgt.concat("" + c);
	}

	return tgt;
}

function IsNumber2(num) {
    var i;
    if(num.length <= 0) {
        return false;
    }
    for(i=0;i<num.length;i++) {
        if((num.charAt(i) < '0' || num.charAt(i) > '9') )
        return false;
    }
    return true;
}

function isEmpty(a) {
    if (Trim(a) == '') return true;
    return false;
}

function Trim(a) {
    return(LTrim(RTrim(a)));
}

function LTrim(a) {
 var i;
 i = 0;
 while (a.substring(i, i+1) == ' ') i = i + 1;
 return a.substring(i);
}

function RTrim(a) {
    var b;
    var i = a.length - 1;
    while (i >= 0 && a.substring(i, i+1) == ' ') i = i - 1;
    return a.substring(0, i+1);
}

function chkKorea(chkstr) {
   var j, lng = 0;
   for (j=0; j<chkstr.length; j++) {
     if (chkstr.charCodeAt(j) > 255) {
       ++lng;
      }
     ++lng;
   }
    return lng;
}

function h_check(a) {
    var intErr
    var strValue = a;
    var retCode = 0
    var intErr = 0

    for (i = 0; i < strValue.length; i++) {
        var retCode = strValue.charCodeAt(i)
        var retChar = strValue.substr(i, 1).toUpperCase()
        retCode = parseInt(retCode)
        if ((retChar < "0" || retChar > "9")
               && (retChar < "A" || retChar > "Z")
               &&((retCode  > 255) || (retCode <  0) || (retCode == 32 ))) {
          intErr = -1;
            break;
        }
    }
    return (intErr);
 }

</Script>
</head>





<body leftmargin="15" topmargin="6" onLoad="init()">
<s:header popup="true">
<form name="form1" method="post" action="">
<input type="hidden" name="duplicate_flag" id="duplicate_flag" value="ng">
<input type="hidden" name="verify_flag" id="verify_flag" value="ng">
<input type="hidden" name="auto_flag" id="auto_flag" value="N">
<input type="hidden" name="lang" id="lang" value="<%=lang %>">
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
	    <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
		<tr>
		<td width="100%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
			<tr>
        		<td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0101")%></td>
        		<td width="80%" height="24" class="data_td" colspan="3">
					<input name="Title" id="Title" type="text" class="input_re" size="30" value="<%=str[0][0]%>" maxlength="100">        		
        		</td>
			</tr>	
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
        		<td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0104")%>
				</td>
        		<td width="30%" height="24" class="data_td">
                	
					<select name="type" id="type" class="input_re" onChange='settext()'>
						<option value=""></option>
						<option value="SP" <%= str[0][2].equals("SP") ? "selected" : "" %> >팝업</option>
						<option value="SL" <%= str[0][2].equals("SL") ? "selected" : "" %> >콤보리스트</option>
					</select>	
                </td>
        		<td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0102")%>
				<td width="20%" height="24" align="left" class="data_td">
				<input name="id" id="id" type="text" size="15" maxlength="20"  value='<%=strCode%>'readonly>
        		</script>
				</td>
        		
             </tr>
             <tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
		        <td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0103")%></td><%--사용유무--%>
				<td width="30%" height="24" class="data_td">
						<input name="use_flag2" id="use_flag2" type="checkbox" value="<%=str[0][1]%>" class="input_empty" checked>
						<input type="hidden" name="use_flag" id="use_flag" value="">
				</td>
		        <td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0105")%></td><%--설명 --%>
				<td width="30%" height="24" class="data_td">
						<input name="Description" id="Description" type="text" size="35" value='<%=str[0][3]%>' maxlength="300">
				</td>	
			</tr>	
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			  
			<tr>
		        <td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0106")%></td><%--자동조회여부--%>
				<td width="30%" height="24" class="data_td">
						<input name="auto_select_flag2" id="auto_select_flag2" type="checkbox" class="radio" value="" checked>
						<input type="hidden" name="auto_select_flag" id="auto_select_flag" value="<%=str[0][6]%>">
				</td>
		        <td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0107")%></td><%--조회결과컬럼 --%>
				<td width="30%" height="24" class="data_td">
						<input name="List_Item" id="List_Item" value='<%=str[0][4]%>' type="text" size="35" maxlength="300">
				</td>			  
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="20%" height="24" align="right" class="title_td"><%=text.get("AD_038.LB_0108")%> </td> <%--SQL--%>
				<td width="80%" height="24" class="data_td" colspan="3">
					<textarea name="SQL" id="SQL" rows="6"  style="width:96%"><%=str[0][5]%></textarea>
				</td>
			</tr>
			  
		</table>
		
		</td>
		  </tr>
		</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  	<td><script language="javascript">btn("verify()","<%=text.get("AD_038.BTN_0101")%>")</script></td>
                        	<td><script language="javascript">btn("Save()","<%=text.get("BUTTON.insert")%>")</script></td>
                        	<td><script language="javascript">btn("javascript:window.close();","<%=text.get("BUTTON.close")%>")</script></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
            
			</td>
		  </tr>
		</table>
	</form>
</body>

<!-- <iframe name="hIframe" width="0" height="0" border="0"> -->
</s:header>
<s:footer/>
</iframe>
</html>
