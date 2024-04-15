<!--
 Title:                 hico_tb_sg1.jsp <p>
 Description:           SUPPLY / ADMIN /  주소 리스트 <p>
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
<%
	String dong = JSPUtil.nullToEmpty(request.getParameter("dong"));
	String mode = JSPUtil.nullToEmpty(request.getParameter("mode"));
	String flag = JSPUtil.nullToEmpty(request.getParameter("flag"));			//작업모드 - popup 이면 신규등록
	
	/* 세션 ###################################################################################### */
   	SepoaInfo info = new SepoaInfo("000","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL");
	
    SepoaFormater wf = null;
	String[] args = {dong};
	
	String nickName= "s6006";
	String conType = "CONNECTION";
	String MethodName = "getAddrList";
	SepoaOut value = null; 
	SepoaRemote remote = null;
	
	try {
		remote = new SepoaRemote(nickName, conType, info);
		value = remote.lookup(MethodName, args);
		
		if(value.status == 1)
		{	
  				wf = new SepoaFormater(value.result[0]);
		}
	}catch(SepoaServiceException wse) {
	    Logger.err.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		Logger.err.println(info.getSession("ID"),request,"message = " + value.message);	
  			Logger.err.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
	    Logger.err.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	}finally{
		try{
			remote.Release();
		}catch(Exception e){}
	}
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
	
<script language="javascript">
	function selectAddr(zip, addr, addr2, city) {
		parent.selectAddr(zip, addr, addr2, city);
	}
</script>
</head>
<body bgcolor="#FFFFFF" leftMargin="0" topMargin="0">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="ccd5de">
      				<TR>
				        <TD width="20%" class="c_title_1" align="center"><b>우편번호</b></TD>
				        <TD width="*" 	class="c_title_1" align="center"><b>주소</b></TD>
        			</TR>
<%
	             	String zipcode = "";
	             	String city = "";
	             	String district = "";
	             	String street1 = "";
	             	String street2 = "";
	             	String housenumber1 = "";
	             	String housenumber2 = "";
	             	String address = "";
	             	String address2 = "";
	             	
	             	if(wf.getRowCount() > 0) {
	             		
		             	for(int i=0; i < wf.getRowCount(); i++) {
		             		zipcode = wf.getValue("ZIPCODE", i);
		    	    		city    = wf.getValue("city", i);
		    	    		district = wf.getValue("district", i);
		    	    		street1  = wf.getValue("street1", i);
		    	    		street2    = wf.getValue("street2", i);
		    	    		housenumber1 = wf.getValue("housenumber1", i);
		    	    		housenumber2  = wf.getValue("housenumber2", i);
		    	    		address = city + " " + district + " " + street1 + " " + street2 + " " + housenumber1 + housenumber2;
		    	    		address2 = city + " " + district + " " + street1 + " " + street2;
		    	    		
%>
		      			<TR>
			        		<TD class="c_data_1"><p align="center"><%=zipcode%></TD>
			        		<TD class="c_data_1"><div align="left">
			        		<a href="javascript:selectAddr('<%=zipcode%>', '<%=address%>', '<%=address2%>', '<%=city%>');"><%=address%></a>
			        		</div></TD>
		      			</TR>
<%
					}
				}
%>
	    			</table>

</body>
</html>
<script language="javascript">

</script>
