<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
 
<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);

	
		
	Configuration conf = new Configuration();
	String domain = conf.getString("sepoa.system.domain.name");
	
	//String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	// 화면에 행머지기능을 사용할지 여부의 구분
	//boolean isRowsMergeable = false;
	
	// 한 화면 SCREEN_ID 기준으로 Buyer 화면일 경우에는 컬럼이 ReadOnly 이고 
	// Supplier 화면일 경우에 edit 일 경우에는 아래의 벡터 클래스에다가 컬럼명을 addElement 하시면 됩니다. 
	// 변환되는 컬럼타입 기준은 아래와 같습니다.
	// ed -> ro(EditBox -> ReadOnlyBox), 
	// edn, -> ron(NumberEditBox -> NumberReadOnlyBox), 
	// dhxCalendar -> ro(CalendarBox -> ReadOnlyBox), 
	// txt -> ro(TextBox -> ReadOnlyBox)
	// sepoa_grid_common.jsp 에서 컬럼타입을 변경 시켜 줍니다.
	// 참고로 Vector dhtmlx_read_cols_vec 객체는 sepoa_common.jsp에서 생성 시켜 줍니다.
	//dhtmlx_read_cols_vec.addElement("screen_id=ED");
	//dhtmlx_read_cols_vec.addElement("col_width");
	//dhtmlx_read_cols_vec.addElement("col_max_len");
	//dhtmlx_read_cols_vec.addElement("contents");
	//dhtmlx_back_cols_vec.addElement("code=rcolor");

	String cont_form_no	= JSPUtil.nullToEmpty(request.getParameter("cont_form_no"));
	String flag			= JSPUtil.nullToEmpty(request.getParameter("flag"));
	String view			= JSPUtil.nullToEmpty(request.getParameter("view"));

	String CONT_FORM_NO		 = "";
	String CONT_FORM_NAME	 = "";
	String CONT_DESC		 = "";
	String CONT_CONTENT		 = "";
	String CONT_TYPE		 = "";
	String OFFLINE_FLAG		 = "";
	String ADD_USER_ID		 = "";
	String ADD_DATE			 = "";
	String ADD_TIME			 = "";
	String CHANGE_USER_ID	 = "";
	String CHANGE_DATE		 = "";
	String CHANGE_TIME		 = "";
	String USE_FLAG			 = "";
	String CONT_PRIVATE_FLAG = "";
	String CONT_USER_ID      = "";
	String CONT_USER_NAME    = "";
	String CONT_STATUS       = "";
	String CONT_UPDATE_DESC  = "";
	
	Map<String, String> params = new HashMap<String,String>();
	
	params.put("cont_form_no", cont_form_no);
	params.put("flag", flag);
	
		Object[] obj = { params };
		SepoaOut value = ServiceConnector.doService(info, "CT_001", "CONNECTION","getContractSelect_head", obj);
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		SepoaFormater wf1 = new SepoaFormater(value.result[1]);
		//DB에서 받아올값들 초기화
	    if(wf.getRowCount() > 0) {
	    	CONT_FORM_NO	= JSPUtil.nullToEmpty(wf.getValue("CONT_FORM_NO",0));
	    	CONT_FORM_NAME	= JSPUtil.nullToEmpty(wf.getValue("CONT_FORM_NAME",0));
	    	CONT_DESC		= JSPUtil.nullToEmpty(wf.getValue("CONT_DESC",0));
	    	CONT_TYPE		= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE",0));
	    	OFFLINE_FLAG	= JSPUtil.nullToEmpty(wf.getValue("OFFLINE_FLAG",0));
	    	ADD_USER_ID		= JSPUtil.nullToEmpty(wf.getValue("ADD_USER_ID",0));
	    	ADD_DATE		= SepoaString.getDateSlashFormat(JSPUtil.nullToEmpty(wf.getValue("ADD_DATE",0)));
	    	ADD_TIME		= JSPUtil.nullToEmpty(wf.getValue("ADD_TIME",0));
	    	CHANGE_USER_ID	= JSPUtil.nullToEmpty(wf.getValue("CHANGE_USER_ID",0));
	    	CHANGE_DATE		= JSPUtil.nullToEmpty(wf.getValue("CHANGE_DATE",0));
	    	CHANGE_TIME		= JSPUtil.nullToEmpty(wf.getValue("CHANGE_TIME",0));
	    	USE_FLAG		= JSPUtil.nullToEmpty(wf.getValue("USE_FLAG",0));
	    	CONT_PRIVATE_FLAG = JSPUtil.nullToEmpty(wf.getValue("CONT_PRIVATE_FLAG",0));
	    	CONT_USER_ID 	= JSPUtil.nullToEmpty(wf.getValue("CONT_USER_ID",0));
	    	CONT_USER_NAME 	= JSPUtil.nullToEmpty(wf.getValue("CONT_USER_NAME",0));
	    	CONT_STATUS 	= JSPUtil.nullToEmpty(wf.getValue("CONT_STATUS",0));
	    	CONT_UPDATE_DESC= JSPUtil.nullToEmpty(wf.getValue("CONT_UPDATE_DESC",0));
		}

		if( wf1.getRowCount() > 0 ){
			CONT_CONTENT = wf1.getValue("CONTENT", 0);
		}
	
	String txt_use_yn  = "";
	String sel_use_yn  = "";
	String del_use_yn  = "";
	String classname   = "";
	
	if( "C".equals(CONT_STATUS) ){
		txt_use_yn = "readonly";
		classname  = "input_empty";
		sel_use_yn = "disabled";
	}
	
	if( "C".equals(CONT_STATUS) && "Y".equals(USE_FLAG) ){
		del_use_yn = "disabled";
	}
	
	
	String screen_id = "";
	if( "C".equals(CONT_STATUS) && "N".equals(USE_FLAG) && "PU".equals(CONT_PRIVATE_FLAG) )
		screen_id="CT_003_1";
	else
		screen_id="CT_003_2";
	
%>

<%/* Alice Editer Object css&js */%>
<link rel="stylesheet" type="text/css" HREF="/css/alice/alice.css">
<link rel="stylesheet" type="text/css" HREF="/css/alice/oz.css">

<%@ include file="/include/alice_cont_scripts.jsp"%>

<%/* Alice Editer Object 생성테그 */%>
<script type="text/javascript">
var alice;
Event.observe(window, "load", function() {
	alice = Web.EditorManager.instance("form_content",{type:'detail',width:'100%',height:'100%',family:'돋움',size:'12px'});
});
</script>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<Script language="javascript">
	var GridObj = null;
	var MenuObj = null;
	var row_id = 0;
	var filter_idx = 0;
	var combobox = null;
	var myDataProcessor = null;

    // 확정
    function setConfirm() {
		var contract_name    = document.form1.contract_name.value;
		var contract_type    = document.form1.contract_type.value;
		var remark		     = document.form1.remark.value;
		var cont_update_desc = document.form1.cont_update_desc.value;
		var use_flag         = document.form1.use_flag.value;
		
		document.form1.form_content.value = alice.getContent();
		//document.form.form_content.value = idEditorIframe.getHTML();
		
		document.form1.confirm.value = "Confirm";
		
		if( use_flag == "Y" ){
			alert( "사용여부가 미사용일 경우 확정하실 수 없습니다." );
			return;
		}
		
		if(contract_name == "") {
			alert("계약서식이름을 작성하세요.");
			document.form1.contract_name.focus();
			return;
		}

		if(contract_type == "") {
			alert("계약종류을 선택하세요.");
			document.form1.contract_type.focus();
			return;
		}

		if(remark == "") {
			alert("계약서식설명을 작성하세요.");
			document.form1.remark.focus();
			return;
		}
		
		if(cont_update_desc != "") {
			alert("사유등록은 확정후 수정 시 작성하실 수 있습니다.");
			document.form1.cont_update_desc.value = "";
			return;
		}		
		    	
		if (confirm("서식을 확정 하시겠습니까?")) {
			document.form1.method = "POST";
			document.form1.target = "childFrame";
			document.form1.action = "contract_form_regist_save.jsp";
			document.form1.submit();
		}    	
    }
    // 수정
    function setdocumentsSave() {
		var contract_name    = document.form1.contract_name.value;
		var contract_type    = document.form1.contract_type.value;
		var remark		     = document.form1.remark.value;
		var cont_update_desc = document.form1.cont_update_desc.value;
		
		document.form1.confirm.value      = "";
		document.form1.form_content.value = alice.getContent();
		//document.form.form_content.value = idEditorIframe.getHTML();
		
		<%if( "W".equals(CONT_STATUS) ){%>
			if(contract_name == "") {
				alert("계약서식이름을 작성하세요.");
				document.form1.contract_name.focus();
				return;
			}
	
			if(contract_type == "") {
				alert("계약종류을 선택하세요.");
				document.form1.contract_type.focus();
				return;
			}
	
			if(remark == "") {
				alert("계약서식설명을 작성하세요.");
				document.form1.remark.focus();
				return;
			}
			
			if(cont_update_desc != "") {
				alert("사유등록은 확정후 수정 시 작성하실 수 있습니다.");
				document.form1.cont_update_desc.value = "";
				return;
			}				
		<%}else{%>
			if( cont_update_desc == "" ) {
				alert("사유를 작성하여 주십시요.");
				document.form1.cont_update_desc.focus();
				return;
			}			
		<%}%>
		
		if (confirm("서식을 수정 하시겠습니까?")) {
			document.form1.method = "POST";
			document.form1.target = "childFrame";
			document.form1.action = "contract_form_regist_save.jsp";
			document.form1.submit();
		}
    }
    
	function windowClose() {
		<%if( "PU".equals(CONT_PRIVATE_FLAG) ){%> // 공통서식
			location.href = "contract_form_list.jsp";
		<%}else{%> // 개인서식
			location.href = "contract_private_list.jsp";
		<%}%>
	}
	
	// 계약서식으로 복사
	function setCopy(){
		if( confirm("표준서식을 임의서식으로 복사하시겠습니까?") ) {
			document.form1.method = "POST";
			document.form1.target = "childFrame";
			document.form1.action = "contract_copy.jsp";
			
			document.form1.submit();
		}		
	}
	
</Script>
</head>

<body leftmargin="15" topmargin="6">
<s:header popup="true">
<form id="form1" name="form1">
<input type="hidden" id="input_flag"         name="input_flag"         value="U"> 
<input type="hidden" id="cont_form_no"       name="cont_form_no"       value="<%=cont_form_no%>"> 
<input type="hidden" id="cont_status"        name="cont_status"        value="<%=CONT_STATUS%>"> 
<input type="hidden" id="cont_private_flag"  name="cont_private_flag"  value="<%=CONT_PRIVATE_FLAG%>">
<input type="hidden" id="confirm"            name="confirm"            value=""> 


<%
thisWindowPopupFlag = "true";
thisWindowPopupScreenName = "서식상세화면"; 
%>

<%@ include file="/include/sepoa_milestone.jsp"%>
    
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>    
    
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"> </td>
	</tr>
	<tr>
		<td width="100%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
			<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
			<tr>
				<td width="100%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  			<tr>
			  				<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						계약서식이름
        					</td>
        					<td height="24" class="data_td" colspan="3">
        						<input type="text" id="contract_name" name="contract_name" value="<%=CONT_FORM_NAME%>" class="<%=classname%>" size="60" <%=txt_use_yn%>>
        					</td>
        					<td width=14% height="24" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						계약종류
        					</td>
        					<td width="20%" height="24" class="data_td" >
                				<select id="contract_type" name="contract_type" class="inputsubmit" <%=sel_use_yn%>>
									<option value="">----------------</option>
									<%
										String lg = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M899", CONT_TYPE);
										out.println(lg);
									%>										
					
								</select>
        					</td>
			  			</tr>
						<tr>
							<td colspan="4" height="1" bgcolor="#dedede"></td>
						</tr>				  			
		      			<tr>
        					<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						작성자
        					</td>
        					<td width="20%" height="24" class="data_td">
        						<input type="text" id="user_name" name="user_name" value="<%=CONT_USER_NAME%>" size="8" class="input_empty" readonly="readonly">
        						<input type="hidden" id="user_id" name="user_id" value="<%=CONT_USER_ID%>" size="8" readonly="readonly">
        					</td>
        					<td width="13%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						작성일
        					</td>
        					<td width="20%" height="24" class="data_td">
        						<input type="text" name="add_date" value="<%=ADD_DATE%>" size="10" class="input_empty" readonly="readonly">
        					</td>        		
        					<td width="14%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						사용여부
        					</td>
        					<td width="20%" height="24" class="data_td">
	                			<select id="use_flag" name="use_flag" class="inputsubmit" <%=del_use_yn%>>
									<option value="">----------------</option>
									<%
										String lg2 = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M898", USE_FLAG);
										out.println(lg2);
									%>			                
								</select>
        					</td>
			  			</tr>
						<tr>
							<td colspan="4" height="1" bgcolor="#dedede"></td>
						</tr>				  			
		      			<tr>
        					<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						서식설명
        					</td>
        					<td width="87%" height="24" class="data_td" colspan="5">
        						<textarea id="remark" name="remark" class="inputsubmit" cols="120%" rows="5px" <%=sel_use_yn%>><%=CONT_DESC%></textarea>
        					</td>
			  			</tr>
						<tr>
							<td colspan="4" height="1" bgcolor="#dedede"></td>
						</tr>				  			
		      			<tr>
        					<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        						사유등록
        					</td>
        					<td width="87%" height="24" class="data_td" colspan="5">
        						<textarea name="cont_update_desc" class="inputsubmit" cols="120%" rows="5px" <%=del_use_yn%> disabled="disabled"><%=CONT_UPDATE_DESC%></textarea>
        					</td>
			  			</tr>			  
					</table>
				</td>
			</tr>
			</table>
			</td>
			</tr>
			</table>	
			  		

			  		<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
						<TR>
							<td style="padding:5 5 5 0" align="right">
								<TABLE cellpadding="2" cellspacing="0">
					  				<TR>
					  					<% if(view.equals("Y")) { %>
						  				<td><script language="javascript">btn("javascript:window.close()","닫기")</script></td>
					  					<% } else {%>
						  				<%if( "W".equals(CONT_STATUS) ){%> <!-- 작성중일때 -->
						  				<td><script language="javascript">btn("javascript:setConfirm()","확정")</script></td>
						  				<%}%>
						  				<%if( "C".equals(CONT_STATUS) && "N".equals(USE_FLAG) && "PU".equals(CONT_PRIVATE_FLAG) ){%> <!-- 확정이고 && 사용일때 && 공통서식일때 -->
						  				<td><script language="javascript">btn("javascript:setCopy()","복사")</script></td>
						  				<%}%>
						  				<%if( "C".equals(CONT_STATUS) && "Y".equals(USE_FLAG) ){ %> <!--( 확정이고 && 미사용일때 ) -->
						  				<%}else{%>
					  	  				<td><script language="javascript">btn("javascript:setdocumentsSave()","수정")</script></td>
					  	  				<%}%>
					  	  				<td><script language="javascript">btn("javascript:windowClose()","목록")</script></td>
					  					<% } %>
					  				</TR>
				    			</TABLE>
				  			</td>
			    		</TR>
			  		</TABLE>
			  
		 			<% if(view.equals("Y")) { %>
			   		<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				  		<tr>
	        				<td width="100%" height="24" align="center" class="title_td" >
	        					계약서식
	        				</td>
				  		</tr>
				  		<tr>
	        				<td width="100%" height="24" bgcolor="FFFFFF" colspan="2" style="word-break:break-all;">
					 		<div name="form_content" id="form_content" style="width:100%; height:550; overflow-x;hidden; overflow-y:scroll; word-break:break-all;"><%=CONT_CONTENT%></div>
					 		</td>
	        	  		</tr>
        	  		</table>
					<% } else {%>
			  		<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td width="100%" height="24" class="data_td" colspan="2">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr width="100%">
										<td class="div_data" style="word-break:break-all;">
							 				<textarea name="form_content" id="form_content" class="inputsubmit" cols="10" style="width:99%;height:100%" rows="50"><%=CONT_CONTENT%></textarea>
										</td>
									</tr>
								</table>
							</td>
						</tr>
			  		</table>
			  		<% } %>  
				</td>
		  	</tr>
		</table>
	</form>
</s:header>
<s:footer/>
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>