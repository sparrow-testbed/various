<%--
Title:        FrameWork 적용 Sample화면(PROCESS_ID)  <p>
 Description:  개발자들에게 적용될 기본 Sample(조회) 작업 입니다.(현재 모듈명에 대한 간략한 내용 기술) <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
--%>

<% String WISEHUB_PROCESS_ID="PROCESSID001";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
String sg_refitem  = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));	//소싱 그룹 구분키
String status      = JSPUtil.nullToEmpty(request.getParameter("status"));
String irs_no      = JSPUtil.nullToEmpty(request.getParameter("irs_no"));
String popup       = JSPUtil.nullToEmpty(request.getParameter("popup")); 

SepoaFormater wf        = null;
SepoaFormater wf_sub    = null;
SepoaOut value = null;
SepoaRemote remote      = null;

int count 	= -1;
String eval_score = "";
String nickName= "s6006";
String conType = "CONNECTION";
String MethodName = "getEvalScore";
String[] param = {vendor_code, sg_refitem};

try {
	remote = new SepoaRemote(nickName, conType, info);
    value = remote.lookup(MethodName, param);

    if(value.status == 1) {
      wf = new SepoaFormater(value.result[0]);
      eval_score = wf.getValue("EVAL_SCORE",0);
    }
}catch(SepoaServiceException wse) {
	
	    Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
	    Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
	    Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
}catch(Exception e) {
	
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
// 	    e.printStackTrace();
}finally{
	    try{
	      remote.Release();
	    } catch(Exception e){}
}
%>

<script type="text/javascript">

parent.document.form1.eval_score.value = '<%=eval_score%>';

</script>