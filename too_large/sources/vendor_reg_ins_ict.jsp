<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="I_SU_102";%>

<%

	String mode                 = JSPUtil.nullToEmpty(request.getParameter("mode"));
	String status               = JSPUtil.nullToRef(request.getParameter("status"),"0");
	String vendor_code          = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));

	String sg_refitem           = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));
	String credit_grade         = JSPUtil.nullToEmpty(request.getParameter("credit_grade"));
	String fromdate             = JSPUtil.nullToEmpty(request.getParameter("fromdate"));
	String todate               = JSPUtil.nullToEmpty(request.getParameter("todate"));
	String recommender_id       = JSPUtil.nullToEmpty(request.getParameter("recommender_id"));
	String recom_reason         = JSPUtil.nullToEmpty(request.getParameter("recom_reason"));

	String approval_reason	    = JSPUtil.nullToEmpty(request.getParameter("approval_reason"));
	String attach_no 		    = JSPUtil.nullToEmpty(request.getParameter("attach_no"));
	String reject_reason 	    = JSPUtil.nullToEmpty(request.getParameter("reject_reason"));
	String purchase_block_flag 	= JSPUtil.nullToEmpty(request.getParameter("purchase_block_flag"));
	String purchase_block_note  = JSPUtil.nullToEmpty(request.getParameter("purchase_block_note"));
	
	String flag = JSPUtil.nullToEmpty(request.getParameter("flag"));

	// 결재관련
	String sign_flag    = JSPUtil.nullToEmpty(request.getParameter("sign_flag"));
	String approval     = JSPUtil.nullToEmpty(request.getParameter("approval"));

	int status_num = 0;
	
	SepoaOut value = null;
	SepoaRemote ws = null;
	
	String isPassed          = "";
	String chk_seq           = "";
	String factor_refitem    = "";
	String vendor_sg_refitem = "";
	
			
	Map<String, String> paramStr = new HashMap<String, String>();
		
		paramStr.put("status"              , status               );
		paramStr.put("fromdate"            , fromdate             );
		paramStr.put("todate"              , todate               );
		paramStr.put("credit_grade"        , credit_grade         );
		paramStr.put("recommender_id"      , recommender_id       );
		paramStr.put("recom_reason"        , recom_reason         );
		paramStr.put("approval_reason"     , approval_reason      );
		paramStr.put("reject_reason"       , reject_reason        );
		paramStr.put("attach_no"           , attach_no            );
		paramStr.put("vendor_code"         , vendor_code          );
		paramStr.put("sg_refitem"          , sg_refitem           );
		paramStr.put("purchase_block_flag" , purchase_block_flag  );
		paramStr.put("purchase_block_note" , purchase_block_note  );
		
		
	if(mode.equals("")) {		// status = 2(신용평가요청), status =3(신용평가완료) status = 4(실사통보)
		try{
			status_num = Integer.parseInt(status);
		}catch(Exception e) {}
		if(status_num > 0) {
			
			
		//	/* String nickName= "p0070";
		//	String conType = "TRANSACTION";
        //
		//	String MethodName = "updateProgStatus";
        //
		//	String param[][] = new String[1][9];
		//	param[0][0] = status;
		//	param[0][1] = fromdate;
		//	param[0][2] = todate;
		//	param[0][3] = recommender_id;
		//	param[0][4] = recom_reason;
        //
		//	param[0][5] = APPROVAL_REASON;
		//	param[0][6] = attach_no;
        //
		//	param[0][7] = vendor_code;
		//	param[0][8] = sg_refitem;
 		//	*/
		//	
 		//	Object[] obj = { vendor_code, status, credit_grade, sg_refitem, paramStr };
 		//	value = ServiceConnector.doService(info, "p0070", "TRANSACTION", "updateProgStatus", obj);
        //
		//	/* try {
		//		ws = new SepoaRemote(nickName, conType, info);
		//		value = ws.lookup(MethodName,obj);
		//	}catch(SepoaServiceException wse) {
		//		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		//		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		//	}catch(Exception e) {
		//	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		//	    e.printStackTrace();
		//	}finally{
		//		try{
		//			ws.Release();
		//		}catch(Exception e){}
		//	} */
		}

	}else if(mode.equals("doSave")) {		//저장
		//Object[] obj1      = { vendor_code, credit_grade, paramStr };
		//value    = ServiceConnector.doService(info, "p0070", "TRANSACTION", "updateInfo", obj1);
        //
		//
		///* String nickName= "p0070";
		//String conType = "TRANSACTION";
        //
		//String MethodName = "updateInfo";
        //
		//String param[][] = new String[1][8];
        //
		//param[0][0] = fromdate;
		//param[0][1] = todate;
		//param[0][2] = recommender_id;
		//param[0][3] = recom_reason;
        //
		//param[0][4] = APPROVAL_REASON;
		//param[0][5] = attach_no;
        //
		//param[0][6] = vendor_code;
		//param[0][7] = sg_refitem;
        //
		//Object[] obj = { vendor_code, credit_grade, param };
        //
		//try {
		//	ws = new SepoaRemote(nickName, conType, info);
		//	value = ws.lookup(MethodName,obj);
		//}catch(SepoaServiceException wse) {
		//	Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		//	Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		//}catch(Exception e) {
		//    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		//    e.printStackTrace();
		//}finally{
		//	try{
		//		ws.Release();
		//	}catch(Exception e){}
		//} */
	}else if(mode.equals("complete")) {	//실사완료

		//isPassed          = JSPUtil.nullToEmpty(request.getParameter("isPassed"));
		//chk_seq           = JSPUtil.nullToEmpty(request.getParameter("chk_seq"));
		//factor_refitem    = JSPUtil.nullToEmpty(request.getParameter("factor_refitem"));
		//vendor_sg_refitem = JSPUtil.nullToEmpty(request.getParameter("vendor_sg_refitem"));
		//
		//Object[] obj2 = { vendor_code, sg_refitem, isPassed, paramStr };
		//value    = ServiceConnector.doService(info, "p0070", "TRANSACTION", "setCheckList", obj2);
        //
		//
		///* String nickName= "p0070";
		//String conType = "TRANSACTION";
		//String MethodName = "setCheckList";
        //
		//String arr1[] = chk_seq.split(",");
		//String arr2[] = factor_refitem.split(",");
        //
		//String[][] param = new String[arr2.length][3];
		//for(int i=0; i < arr2.length; i++) {
		//	param[i][0] = arr2[i];
		//	param[i][1] = arr1[i];
		//	param[i][2] = vendor_sg_refitem;
		//}
        //
		//Object[] obj = { vendor_code, sg_refitem, isPassed, param };
        //
		//try {
		//	ws = new SepoaRemote(nickName, conType, info);
		//	value = ws.lookup(MethodName,obj);
		//}catch(SepoaServiceException wse) {
		//	Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		//	Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		//}catch(Exception e) {
		//    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		//    e.printStackTrace();
		//}finally{
		//	try{
		//		ws.Release();
		//	}catch(Exception e){}
		//} */
	}else if(mode.equals("register")) {  // 승인, 반려

		String is_registry = "";
		String sign_status = "";

		if(flag.equals("Y")) {
			// 승인
			is_registry = flag;
			sign_status = "A";
		}else if(flag.equals("R")){
			// 반려
			is_registry = flag;
			sign_status = "";
		}
		
		Object[] obj3 = { vendor_code, sg_refitem, is_registry, sign_status, credit_grade, paramStr};
		value    = ServiceConnector.doService(info, "I_p0070", "TRANSACTION", "setRegister", obj3);

		/* String nickName= "p0070";
		String conType = "TRANSACTION";
		String MethodName = "setRegister";

		

		String param[][] = new String[1][9];
		param[0][0] = fromdate;
		param[0][1] = todate;
		param[0][2] = recommender_id;
		param[0][3] = recom_reason;

		param[0][4] = APPROVAL_REASON;
		param[0][5] = attach_no;
		param[0][6] = REJECT_REASON;

		param[0][7] = vendor_code;
		param[0][8] = sg_refitem;

		Object[] obj = { vendor_code, sg_refitem, is_registry, sign_status, credit_grade, param};

		try {
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
		}catch(SepoaServiceException wse) {
			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
			Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		}catch(Exception e) {
		    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		    e.printStackTrace();
		}finally{
			try{
				ws.Release();
			}catch(Exception e){}
		} */
	}else if(mode.equals("approval")){	//결재요청


		//String is_registry = "";
		//String sign_status = "";
        //
		//is_registry = flag;
		//sign_status = sign_flag;
		//
		//Object[] obj4 = { vendor_code, sg_refitem, is_registry, sign_status, credit_grade, paramStr ,sign_flag, approval};
		//value    = ServiceConnector.doService(info, "p0070", "TRANSACTION", "setApproval", obj4);
		//
		///* String nickName= "p0070";
		//String conType = "TRANSACTION";
		//String MethodName = "setApproval";
        //
		//String is_registry = "";
		//String sign_status = "";
        //
		//is_registry = flag;
        //
		//sign_status = SIGN_FLAG;
        //
		//String param[][] = new String[1][9];
		//param[0][0] = fromdate;
		//param[0][1] = todate;
		//param[0][2] = recommender_id;
		//param[0][3] = recom_reason;
        //
		//param[0][4] = APPROVAL_REASON;
		//param[0][5] = attach_no;
		//param[0][6] = REJECT_REASON;
        //
		//param[0][7] = vendor_code;
		//param[0][8] = sg_refitem;
        //
		//Object[] obj = { vendor_code, sg_refitem, is_registry, sign_status, credit_grade, param ,SIGN_FLAG, APPROVAL};
        //
		//try {
		//	ws = new SepoaRemote(nickName, conType, info);
		//	value = ws.lookup(MethodName,obj);
		//}catch(SepoaServiceException wse) {
		//	Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		//	Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		//}catch(Exception e) {
		//    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		//    e.printStackTrace();
		//}finally{
		//	try{
		//		ws.Release();
		//	}catch(Exception e){}
		//} */


	}else if(mode.equals("block")){		//협력사 거래개시/중지
		
		Object[] obj5 = { paramStr };
		value    = ServiceConnector.doService(info, "I_p0070", "TRANSACTION", "setBlock", obj5);

    }else if(mode.equals("kg")){		//협력사 경고/경고해제
		
		Object[] obj5 = { paramStr };
		value    = ServiceConnector.doService(info, "I_p0070", "TRANSACTION", "setBlock", obj5);

	}else if(mode.equals("delete")){
		//sel_vendor_code
		vendor_sg_refitem = JSPUtil.nullToEmpty(request.getParameter("vendor_sg_refitem"));
		
		Object[] obj6 = { paramStr };
		value    = ServiceConnector.doService(info, "I_p0070", "TRANSACTION", "deleteProgVendor", obj6);
        
		
		/* String nickName= "p0070";
		String conType = "TRANSACTION";
		String MethodName = "deleteProgVendor";
        
		//String[] arg = vendor_sg_refitem.split(",");
		//String[][] param = new String[arg.length][1];
		//for(int i=0; i < arg.length; i++) {
		//	param[i][0] = arg[i];
		//}
		String[][] param = new String[1][1];
		param[0][0] = vendor_code;
		Object[] obj = { param };
        
		try {
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
		}catch(SepoaServiceException wse) {
			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
			Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		}catch(Exception e) {
		    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		    e.printStackTrace();
		}finally{
			try{
				ws.Release();
			}catch(Exception e){}
		} */
	}else if(mode.equals("delete_approval")){	// 협력사현황 삭제
		Object[] obj6 = { paramStr };
		value    = ServiceConnector.doService(info, "I_p0070", "TRANSACTION", "delete_approval", obj6);
	}else if(mode.equals("restore_approval")){	// 협력사현황 복구
		Object[] obj6 = { paramStr };
		value    = ServiceConnector.doService(info, "I_p0070", "TRANSACTION", "restore_approval", obj6);

	}else if(mode.equals("sscs")){		//협력사 거래개시/중지
		
		//Object[] obj7 = { paramStr };
		Object[] obj7 = {info,vendor_code};
		value    = ServiceConnector.doService(info, "CO_004", "TRANSACTION", "setScssProcess_ICT", obj7);

	}
	
	
	
	

%>
	<%if(value.message == null || value.message.equals("")){%>
		<%if(mode.equals("")){%>
			<%if(status_num == 2) {%>
				<script>alert('신용평가요청이 완료 되었습니다.');</script>
			<%}else if(status_num == 3) {%>
				<script>alert('신용평가가 완료 되었습니다.');</script>
			<%}else if(status_num == 4) {%>
				<script>alert('실사통보가 완료 되었습니다.');</script>
			<%}%>
			<script>parent.goRef();</script>
		<%}else if(mode.equals("doSave")){%>
				<script>alert('저장 되었습니다.');</script>
				<script>parent.document.location.reload();</script>
		<%}else if(mode.equals("complete")) {%>
				<script>alert('실사결과가 처리 되었습니다.');</script>
				<script>parent.goRef();</script>
		<%}else if(mode.equals("register")) {%>
			<%if(flag.equals("Y")){%>
					<script>alert('승인/등록 처리 되었습니다.');</script>
					<script>parent.goRef();</script>
			<%}else if(flag.equals("R")){%>
					<script>alert('반려 처리 되었습니다.');</script>
					<script>parent.doSelect();</script>
			<%}%>
			
		<%}else if(mode.equals("block")){%>
			<%
				if("Y".equals(purchase_block_flag)){
			%>
			<script>alert('거래중지 되었습니다.');</script>
			<%
			}else{
			%>
			<script>alert('거래개시 되었습니다.');</script>
			<%
			}
			%>
			<script>parent.doSelect();</script>
		<%}else if(mode.equals("kg")){%>
			<%
				if("K".equals(purchase_block_flag)){
			%>
			<script>alert('경고 되었습니다.');</script>
			<%
			}else{
			%>
			<script>alert('경고해제 되었습니다.');</script>
			<%
			}
			%>
			<script>parent.doSelect();</script>
		<%}else if(mode.equals("delete_approval")){%>
				<script>alert('삭제 되었습니다.');</script>
				<script>parent.doSelect();</script>
		<%}else if(mode.equals("restore_approval")){%>
				<script>alert('복구 되었습니다.');</script>
				<script>parent.doSelect();</script>
		<%}else if(mode.equals("delete")){%>
				<script>alert('삭제 되었습니다.');</script>
				<script>parent.doSelect();</script>
		<%}else if(mode.equals("approval")) {%>
			<%if(value.status == 1){%>
					<script>alert('업체코드가 결재요청 되었습니다.');</script>
			<%}else if(value.status == 0){%>
					<script>alert('결재 오류');</script>
			<%} %>
			<script>parent.goRef();</script>
		<%}else if(mode.equals("sscs")){%>
			<%
			 if(! value.flag){
			       String error_message = SepoaString.replace(SepoaString.replace(value.message, "\r", ""), "\n", "");
			       out.println("<script>");
			       out.println("alert(\"" + error_message + "\");");
			       out.println("</script>");
			 }else{
				   out.println("<script>");
			       out.println("alert('탈퇴처리 되었습니다.');");
			       out.println("</script>");
			 }

			%>
			<script>parent.doSelect();</script>
		<%} %>
	<%}else{%>
		<script>alert('작업수행을 하는데 실패했습니다.\n관리자에게 문의해주시기 바랍니다.');</script>
	<%}%>


