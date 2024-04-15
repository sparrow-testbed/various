<%--회원가입(사업자 등록번호 중복체크 hidden frame)--%>

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="I_s6006";%>
<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>

<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/filter_string_check.jsp"%>

<%SepoaInfo info = SepoaSession.getAllValue(request); %>

<%
    String sg_type = "";
    String irs_no 		= JSPUtil.nullToEmpty(request.getParameter("irs_no"));
    String resident_no 	= JSPUtil.nullToEmpty(request.getParameter("resident_no"));
    String mode 		= JSPUtil.nullToEmpty(request.getParameter("mode"));


	String rtn = "";

	try{
    	// filter_string_check.jsp : fsFilter_String_Check
		rtn = fsFilter_String_Check("00",irs_no);
    	if(!"".equals(rtn)) throw new Exception(rtn);
    	rtn = fsFilter_String_Check("00",resident_no);
    	if(!"".equals(rtn)) throw new Exception(rtn);
    	rtn = fsFilter_String_Check("00",mode);
    	if(!"".equals(rtn)) throw new Exception(rtn);
    	
    }
    catch(Exception e){
    	RequestDispatcher dispatcher = request.getRequestDispatcher("/include/error_msg.jsp?err_msg="+e.getMessage());
    	dispatcher.forward(request, response);
    }
    finally{
    }
    
    //EncDec enc = new EncDec();
    /*주민번호 일 경우엔 암호화 한다.*/
	//String resident_no_p = enc.encrypt(resident_no);

    String resident_no_p = resident_no;

	Object[] obj = { irs_no ,resident_no_p, mode};
	String alias = "I_s6006";
	String conType = "CONNECTION";
	String MethodName = "checkDupIrsNo";

	SepoaOut value = null;
	SepoaRemote remote = null;
	String result = "";
	String status = "";
	String job_status = "";
	String message = null;

    if( irs_no.length() > 0 || resident_no.length() > 0) {
        try {
    	 	remote = new SepoaRemote(alias, conType, info);
    	 	value = remote.lookup(MethodName, obj);
			
    		if(value.status != 0) {
    			SepoaFormater wf = new SepoaFormater(value.result[0]);
    			if(wf.getRowCount() > 0) {
    				job_status = wf.getValue(0, 1);
    				status = wf.getValue(0, 2);
    				if( job_status.equals("R") ) {//승인 반려된 업체인 경우
    					result = "R";
    				}else if( status.equals("C") ){
    				   result = "E";
    				}else if( status.equals("D") ){
    				    result = "Y";
    				}else{
    				    result = "N";
    			    	}
    			}else{
    			    result = "N";
    		        }
    		}
		} catch(SepoaServiceException wse) {
			
		} catch(Exception e) {
			
		} finally{
        	try {
    		    remote.Release();
    		} catch(Exception e) {}
		}
   	    if(result.equals("Y") || result.equals("E")) {
    	    MethodName = "checkSgType";
    	    Object[] obj2 = { irs_no};
    	    try {
	    	 	remote = new SepoaRemote(alias, conType, info);
	    	 	value = remote.lookup(MethodName, obj2);
				
	    		if(value.status != 0) {
	    			SepoaFormater wf = new SepoaFormater(value.result[0]);
    				if(wf.getRowCount() > 0) {
    					sg_type = wf.getValue(0, 0);
    		        }
	    		}
            } catch(SepoaServiceException wse) {
    	    	
            } catch(Exception e) {
                	
            } finally{
	        	try {
    			    remote.Release();
    			} catch(Exception e) {}
    	    }
	    }
    }
%>
<html>
<head>
<title>우리은행 IT전자입찰시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
<!--
		function Next()
		{
			var job_status = "<%=job_status%>";
			var msg = "";

			if("" == "<%=irs_no%>"){
				msg = "주민등록번호";
			}else {
				msg = "사업자 등록번호";
			}

			if(job_status == ""){ // ICOMVNGL_ICT 에 없으므로 신규업체
				parent.do_agree("<%=irs_no%>","<%=resident_no%>", "N", "<%=sg_type%>");
			}else if(job_status == "P"){ // 승인대기중
				alert("승인 대기중입니다.");
				return;
			}else if(job_status == "E"){ // 승인된업체
				alert("이미 사용중인 " + msg  + " 입니다.");
				return;
			}else if(job_status == "R"){ // 반려된경우
				if(confirm("반려되었습니다. 관리자에게 문의하십시오.\n재가입 신청을 진행하시겠습니까?"))
		    		parent.do_agree("<%=irs_no%>","<%=resident_no%>", "T", "<%=sg_type%>");
		    	return;
			}
			/*완전히 삭제된 경우 사용안함*/
			else if(job_status == "D"){ // 등록만 하고 아이디신청을 안한경우 또는 승인반려가 후 삭제된 경우
				if(confirm("신청 중 중단된 " + msg + " 입니다.\n계속 진행하시겠습니까?"))
		    		parent.do_agree("<%=irs_no%>","<%=resident_no%>", "T", "<%=sg_type%>");
		    		return;
		    }
		}
//-->
</script>
</head>
<body onload="Next();">

</body>
</html>
