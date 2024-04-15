<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String from            = JSPUtil.nullToEmpty(request.getParameter("from"));
	String house_code      = JSPUtil.nullToEmpty(request.getParameter("house_code"));
	String company_code    = JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String dept_code       = JSPUtil.nullToEmpty(request.getParameter("dept_code"));
	String req_user_id     = JSPUtil.nullToEmpty(request.getParameter("req_user_id"));
	String doc_type        = JSPUtil.nullToEmpty(request.getParameter("doc_type"));
	String doc_detail_type = JSPUtil.nullToEmpty(request.getParameter("doc_detail_type"));
	String fnc_name        = JSPUtil.nullToEmpty(request.getParameter("fnc_name"));
	String amt             = JSPUtil.nullToEmpty(request.getParameter("amt"));
	String issue_type      = JSPUtil.nullToEmpty(request.getParameter("issue_type"));
	String app_div         = JSPUtil.nullToEmpty(request.getParameter("app_div"));
	String asset_type      = JSPUtil.nullToEmpty(request.getParameter("asset_type"));

	if (doc_detail_type.equals(""))
		doc_detail_type = "X";
	if (amt.equals(""))
		amt = "0";
%>

<%
	String Sign_Type = "";
	String auto_flag = "";
	String STRATEGY_TYPE = "";

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

	String TITLE = "결재경로 상세정보";

	/* 결재 방식을 선택함 : 차기 결재방식 or 상신자 지정방식 */
	String[] args = { house_code, company_code, doc_type };
	Object[] obj = { args };
	SepoaOut value = ServiceConnector.doService(info, "p6028", "CONNECTION", "CheckSign_Type", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	int rowSign_Type = wf.getRowCount();

	if (rowSign_Type > 0) {
		Sign_Type = wf.getValue("SIGN_TYPE", 0);
	}

	//문서를 보고 자동 수동 여부를 체크하는 모듈
	String[] args2 = { doc_type, dept_code, company_code, house_code };
	//Object[] obj2 = { args2 };

	SepoaOut value2 = ServiceConnector.doService(info, "p6026", "CONNECTION", "autoDepCheck", args2);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);

	int row = wf2.getRowCount();

	if (row != 0) {
		STRATEGY_TYPE = wf2.getValue("STRATEGY_TYPE", 0); //결재전략형태
		if (wf2.getValue("AUTO_MANUAL_FLAG", 0).equals("T"))
			auto_flag = "A"; //결재형태(자동/수동)
		else
			auto_flag = "P";
	} else {
		// 부서단위 결재테이블에서 해당 문서타입이 없으면 회사단위결재테이블을 찾아본다.
		Logger.debug.println("LEPPLE", request, "부서단위테이블에 없음");
		String[] args3 = { doc_type, company_code, house_code };
		Object[] obj3 = { args3 };
		SepoaOut value3 = ServiceConnector.doService(info, "p6026",	"CONNECTION", "autoComCheck", obj3);
		SepoaFormater wf3 = new SepoaFormater(value3.result[0]);

		int row1 = wf3.getRowCount();
		if (row1 != 0) {
			STRATEGY_TYPE = wf3.getValue("STRATEGY_TYPE", 0); //결재전략형태
			if (wf3.getValue("AUTO_MANUAL_FLAG", 0).equals("T"))
				auto_flag = "A"; //결재형태(자동/수동)
			else
				auto_flag = "P";
		} else
			auto_flag = "E"; //여긴.. ERROR 처리 해야한다... 부서나 회사 두군데다 결재 전략이 없으면 ERROR
	}

%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">

//<!--

function Init(){
	var url = "";
	<%
	if (Sign_Type.equals("01")) {
	%> // 차기결재자 방식
		if("<%=auto_flag%>"=="A") {
			location.href = "/kr/admin/basic/approval/ap1_pp_lis1.jsp?from=<%=from %>&auto_flag=<%=auto_flag%>&strategy=<%=STRATEGY_TYPE%>&req_user_id=<%=req_user_id%>&dept_code=<%=dept_code%>&company_code=<%=company_code%>&house_code=<%=house_code%>&fnc_name=<%=fnc_name%>";
		}else if("<%=auto_flag%>"=="P") {
			PopupGeneral('/kr/admin/basic/approval2/ap2_pp_lis3.jsp?from=<%=from %>&doc_type=<%=doc_type%>&auto_flag=<%=auto_flag%>&strategy=<%=STRATEGY_TYPE%>&req_user_id=<%=req_user_id%>&dept_code=<%=dept_code%>&company_code=<%=company_code%>&house_code=<%=house_code%>&fnc_name=<%=fnc_name%>&issue_type=<%=issue_type%>&amt=<%=amt%>','pop_up','','','550','500');
		}else alert("결재전략에 등록하셔야합니다.");
	<%
	} else {
	%>
		url = "/kr/admin/basic/approval2/ap2_pp_lis3.jsp?from=<%=from %>&doc_type=<%=doc_type%>&strategy=<%=STRATEGY_TYPE%>&req_user_id=<%=req_user_id%>&dept_code=<%=dept_code%>&company_code=<%=company_code%>&house_code=<%=house_code%>&issue_type=<%=issue_type%>&fnc_name=<%=fnc_name%>&app_div=<%=app_div%>&asset_type=<%=asset_type%>"; 	
		PopupGeneral(url,"pop_up","50","50","700","550");
		//window.open(url,"pop_up","top=50,left=50,width=700,height=550,resizable=yes,status=yes,scrollbars = yes");
	<%
	}
	%>
}
//-->

</script>
</head>
<body bgcolor="#FFFFFF" onLoad="javascript:Init();">
</body>
</html>

