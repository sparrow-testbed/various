<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%!
	public static String decode(String src)throws UnsupportedEncodingException
	{
		String returnString = src;
		returnString=new String(returnString.getBytes("KSC5601"),"8859_1");
		if (src.length()==returnString.length())
		returnString = src;
		return returnString;
	}

	public static String replaceString(String origin_data) throws Exception
	{
		String rtn_data = "";
		String a = "\"";
		String b = "\\\"";

		rtn_data = SepoaString.replaceString(origin_data, a, b);
		rtn_data = SepoaString.replaceString(origin_data, "'", "\\'");
		

		return rtn_data;
	}
%>

<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_010");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

    String explain_date     = SepoaString.getDateSlashFormat(JSPUtil.nullToEmpty(request.getParameter("explain_date")));
	String exp_from_hour    = JSPUtil.nullToEmpty(request.getParameter("exp_from_hour"));
    String exp_from_min     = JSPUtil.nullToEmpty(request.getParameter("exp_from_min"));
    String exp_to_hour      = JSPUtil.nullToEmpty(request.getParameter("exp_to_hour"));
    String exp_to_min       = JSPUtil.nullToEmpty(request.getParameter("exp_to_min"));
    String explain_area     = JSPUtil.nullToEmpty(request.getParameter("explain_area"));
    String explain_place    = JSPUtil.nullToEmpty(request.getParameter("explain_place"));
    String explain_flag     = JSPUtil.nullToEmpty(request.getParameter("explain_flag"));
    String explain_resp     = JSPUtil.nullToEmpty(request.getParameter("explain_resp"));
    String explain_tel      = JSPUtil.nullToEmpty(request.getParameter("explain_tel"));
    String explain_comment  = JSPUtil.nullToEmpty(request.getParameter("explain_comment"));
    
    String display_mode     = JSPUtil.nullToEmpty(request.getParameter("display_mode")); //D : detail
    
  //Dthmlx Grid 전역변수들..
  	String screen_id = "BD_010";
  	String grid_obj  = "GridObj";
  	// 조회용 화면인지 데이터 저장화면인지의 구분
  	boolean isSelectScreen = false;
    
    
    String readonly = "";
    String disabled = "";
    String className = "inputsubmit";

    if(display_mode.equals("D")){
    	readonly = "readonly";
        disabled = "disabled";
        className = "input_empty";
    }
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_explain_register";
 
	function initValue(){
		var f = document.forms[0];
		
		f.explain_date.value     = decodeUrl("<%=explain_date%>");
	    f.exp_from_hour.value    = decodeUrl("<%=exp_from_hour%>");
	    f.exp_from_min.value     = decodeUrl("<%=exp_from_min%>");
	    f.exp_to_hour.value      = decodeUrl("<%=exp_to_hour%>");
	    f.exp_to_min.value       = decodeUrl("<%=exp_to_min%>");
	    f.explain_area.value     = decodeUrl("<%=explain_area%>");
	    f.explain_place.value    = decodeUrl("<%=explain_place%>");
	    f.explain_flag.value     = decodeUrl("<%=explain_flag%>");
	    f.explain_resp.value     = decodeUrl("<%=explain_resp%>");
	    f.explain_tel.value      = decodeUrl("<%=explain_tel%>");
	    f.explain_comment.value  = decodeUrl("<%=explain_comment%>");
	}
	
	function checkData(){
		var f = document.forms[0];
		
		var explain_date     = LRTrim(del_Slash(f.explain_date.value));              //개최일
		var exp_from_hour    = LRTrim(f.exp_from_hour.value);             //시간
		var exp_from_min     = LRTrim(f.exp_from_min.value);
		var exp_to_hour      = LRTrim(f.exp_to_hour.value);
		var exp_to_min       = LRTrim(f.exp_to_min.value);
		var explain_area     = LRTrim(f.explain_area.value);              //지역
		var explain_place    = LRTrim(f.explain_place.value);             //장소
		var explain_flag     = LRTrim(f.explain_flag.value);              //참석필수여부
		var explain_resp     = LRTrim(f.explain_resp.value);              //담당자
		var explain_tel      = LRTrim(f.explain_tel.value);               //문의처
		var explain_comment  = LRTrim(f.explain_comment.value);           //특기사항
		
        
        if(!checkDate(explain_date)) {
            //alert("개최일을 확인하세요.");
             alert("<%=text.get("BD_010.MSG_002")%>");
            document.form.explain_date.select();
            return false;
        }
        
<%--        if(exp_from_hour == "" || exp_from_min == "" || exp_to_hour == "" || exp_to_min == ""){--%>
       if(exp_from_hour == "" ){  
        	//alert("시간을 확인하세요.");
            alert("<%=text.get("BD_010.MSG_003")%>");
            return false;
        }

       if(exp_from_min == "" ){  
        	//alert("시간을 확인하세요.");
            alert("<%=text.get("BD_010.MSG_003")%>");
            f.exp_from_min.select();
            return false;
        }
                
<%--        if(explain_area == ""){--%>
<%--        	//alert("장소를 선택하셔야 합니다.");--%>
<%--            alert("<%=text.get("BD_010.MSG_004")%>");--%>
<%--            document.form.explain_area.select();--%>
<%--            return false;--%>
<%--        }--%>
        
        if(explain_place == ""){
        	//alert("장소(상세)를 입력하셔야 합니다.");
            alert("<%=text.get("BD_010.MSG_005")%>");
            document.form.explain_place.select();
            return false;
        }
        
        if(explain_flag == ""){
        	//alert("참석필수여부를 선택하셔야 합니다.");
            alert("<%=text.get("BD_010.MSG_006")%>");
            document.form.explain_place.select();
            return false;
        }
        
        if(explain_resp == ""){
        	//alert("담당자를 입력하셔야 합니다.");
            alert("<%=text.get("BD_010.MSG_007")%>");
            document.form.explain_resp.select();
            return false;
        }
        
        if(explain_tel == ""){
        	//alert("문의처를 입력하셔야 합니다.");
            alert("<%=text.get("BD_010.MSG_008")%>");
            document.form.explain_tel.select();
            return false;
        }
        
        return true;
	}
	
	function save()
	{
		if(!checkData()) return;
		
		var f = document.forms[0];
		
		var explain_date     = del_Slash(f.explain_date.value)              //개최일
		var exp_from_hour    = f.exp_from_hour.value             //시간
		var exp_from_min     = f.exp_from_min.value
		var exp_to_hour      = f.exp_to_hour.value
		var exp_to_min       = f.exp_to_min.value
		var explain_area     = f.explain_area.value              //지역
		var explain_place    = f.explain_place.value             //장소
		var explain_flag     = f.explain_flag.value              //참석필수여부
		var explain_resp     = f.explain_resp.value              //담당자
		var explain_tel      = f.explain_tel.value               //문의처
		var explain_comment  = f.explain_comment.value           //특기사항


		if( getLength2Bytes(explain_place) > 100 )
		{
		
			alert("장소(상세)는 최대 길이 100 자를 초과할 수 없습니다.");
			return;
		}
		if (confirm("<%=text.get("BD_010.MSG_001")%>")) //저장하시겠습니까?
		{
            opener.setExplain(explain_date, exp_from_hour, exp_from_min, exp_to_hour, exp_to_min, explain_area, explain_place, explain_flag, explain_resp, explain_tel, explain_comment);
            window.close();
       	}
	}
	
	//입력 키검사..
	function checkMin(sFilter, name) {
		var sKey = String.fromCharCode(event.keyCode);
		var re = new RegExp(sFilter);

		// Enter는 키검사를 하지 않는다.
		if(sKey != "\r" && !re.test(sKey)) {
			event.returnValue = false;
		}
		
		if (document.getElementsByName(name)[0].value.length == 0) {
			if (parseInt(sKey) > 5) event.returnValue = false;
		}
	}
	
	function initAjax()
	{
<%--		doRequestUsingPOST( 'SL9000', 'M287' ,'explain_area', '' ); //장소--%>
    }

</Script>
</head>

<body topmargin="6" onload="initValue();initAjax();" >
<s:header popup="true">
<form name="form" action="">
<%
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = (String) text.get("BD_010.TEXT_001"); //사양설명회 등록
%>

<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	  <td width="100%" valign="top">

			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="DBDBDB">

				<tr>
					<td class="div_input" width="15%"><%=text.get("BD_010.EXPLAIN_DATE")%></td> <%-- 개최일 --%>
					<td class="div_data" width="35%">
						<input type="text" name="explain_date" id="explain_date" size="8" maxlength="8" class="<%=className%>" value="" >
					<% if(!display_mode.equals("D")){ %>
<!-- 						<img src="../images/button/butt_calender.gif" width="15" height="19" align="absmiddle" border="0" alt="" onClick="popUpCalendar(this, explain_date , 'yyyy/mm/dd')"> -->
					<% } %>
					</td>
					<td class="div_input"  ><%=text.get("BD_010.EXPLAIN_TIME")%></td> <%-- 시간 --%>
					<td class="div_data">
						<select name="exp_from_hour" class="inputsubmit">
							<%	for(int i = 0; i < 24; i++){ %>
								<% if(i < 10){%>
									<option value="<%="0"+i %>"><%="0"+i %></option>
								<% }else{ %>
									<option value="<%=i %>"><%=i %></option>
								<% } %>
							<%	} %>
						</select>
						<%=text.get("BD_010.HOUR")%> <%-- 시 --%>
						<input type="text" name="exp_from_min" id="exp_from_min" size="2" class="<%=className%>" maxLength="2" value="00" onKeyPress="checkMin('[0-9]', 'exp_from_min')" >
						<%=text.get("BD_010.MINUTE")%> <%-- 분 --%>
						
						<input type="hidden" name="exp_to_hour" id="exp_to_hour" value="00">
						<input type="hidden" name="exp_to_min" id="exp_to_min" value="00">
					</td>
				</tr>

				<tr>
					<td class="div_input"><%=text.get("BD_010.EXPLAIN_PLACE")%></td> <%-- 장소 --%>
					<td class="div_data">
						<input type = "hidden" name="explain_area" id="explain_area" size="10" value="">
<%--						<select name="explain_area" class="inputsubmit">--%>
<%--						</select>--%>
						<input type="text" name="explain_place" id="explain_place" maxlength="100" value="" class="<%=className%>" size="10" style="width : 100%" class="inputsubmit" >
					</td>
					<td class="div_input"  ><%=text.get("BD_010.EXPLAIN_FLAG")%></td> <%-- 참석필수여부 --%>
					<td class="div_data">
						<select name="explain_flag" class="inputsubmit">
							<option value="S">선택</option>
							<option value="R">필수</option> 
						</select>
					</td>
				</tr>

				<tr>
					<td class="div_input"  ><%=text.get("BD_010.EXPLAIN_RESP")%></td> <%-- 담당자 --%>
					<td class="div_data">
						<input type="text" name="explain_resp" id="explain_resp" size="10" value="" class="<%=className%>" >
					</td>
					<td class="div_input"  ><%=text.get("BD_010.EXPLAIN_TEL")%></td> <%-- 문의처 --%>
					<td class="div_data">
						<input type="text" name="explain_tel" id="explain_tel" value="" size="20" class="<%=className%>">
					</td>
				</tr>

				<tr>
					<td class="div_input"  ><%=text.get("BD_010.EXPLAIN_COMMENT")%></td> <%-- 특기사항 --%>
					<td class="div_data" colspan="3">
						<textarea name="explain_comment" class="<%=className%>" cols="100%" style="width : 99%;"></textarea>
					</td>
				</tr>
				
			</table>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    	<tr><td height="5"></td></tr>
		    </table>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
<%--				      		<% if(!display_mode.equals("D")){ %>--%>
								<TD><script language="javascript">btn("javascript:save()","<%=text.get("BUTTON.save")%>")   </script></TD>
<%--							<% } %>--%>
				      			<TD><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>")</script></TD>
			    	  			</TR>
				    </TABLE>
				  	</td>
			 	</TR>
			</TABLE>
			</td>
		</tr>
	</table>
    <div width="100%" height="250" id="supiFlameDiv" name="supiFlameDiv">
    	<iframe src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_botton_vi.jsp" name="supiFlame" id="supiFlame" width="100%" height="170px" border="0" scrolling="no" frameborder="0"></iframe>
    </div>
</form>

<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
 			<%-- START GRID BOX 그리기 --%>
        <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
              <div id="pagingArea"></div>
        <%-- END GRID BOX 그리기 --%>
<s:footer/>
</body>
</html>
			    	  		