<% //PROCESS ID 선언 %>
<%-- <% String WISEHUB_PROCESS_ID="PROCESSID001";%> --%>
<%-- <% String WISEHUB_PROCESS_ID="AU_001";%> --%>

<% //사용 언어 설정  %>
<%-- <% String WISEHUB_LANG_TYPE="KR";%> --%>

<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	request.setCharacterEncoding("EUC-KR");	
	int	   rowcnt =0;
	String MODE 		= JSPUtil.nullToEmpty(request.getParameter("MODE")); //setCancelGonggoCreate
	String RA_FLAG		= JSPUtil.nullToRef(request.getParameter("RA_FLAG"),"D");
	String BID_STATUS	= JSPUtil.nullToEmpty(request.getParameter("BID_STATUS"));
	String RA_NO		= JSPUtil.nullToEmpty(request.getParameter("RA_NO"));
	String RA_COUNT		= JSPUtil.nullToEmpty(request.getParameter("RA_COUNT"));
	String RA_TYPE1		= JSPUtil.nullToEmpty(request.getParameter("RA_TYPE1"));

	String ANN_NO		= JSPUtil.nullToEmpty(request.getParameter("ANN_NO"));
	String ANN_DATE		= JSPUtil.nullToEmpty(request.getParameter("ANN_DATE"));
	String ANN_ITEM	    = JSPUtil.nullToEmpty(request.getParameter("ANN_ITEM"));
	String BID_ETC		= JSPUtil.nullToEmpty(request.getParameter("BID_ETC"));
	String FLAG 		= JSPUtil.nullToEmpty(request.getParameter("FLAG")); //pflag
	String PR_NO    	= JSPUtil.nullToEmpty(request.getParameter("PR_NO"));

    // 인증관련
    String CERTV        = JSPUtil.nullToEmpty(request.getParameter("CERTV"));
    String TIMESTAMP    = JSPUtil.nullToEmpty(request.getParameter("TIMESTAMP"));
    String SIGN_CERT    = JSPUtil.nullToEmpty(request.getParameter("SIGN_CERT"));
    
    String approval_str = JSPUtil.nullToEmpty(request.getParameter("approval_str"));
    String ITEM_COUNT 	= JSPUtil.nullToEmpty(request.getParameter("ITEM_COUNT"));
    String TOTAL_AMT 	= JSPUtil.nullToEmpty(request.getParameter("TOTAL_AMT"));
%>
	
<%
    String RESULT = "";

    String nickName     = "p1008";			//wisehub.srv 에 등록된 Alias
    String conType      = "TRANSACTION";		//conType : CONNECTION/TRANSACTION/NONDBJOB
    String MethodName   = MODE;		//NickName 으로 연결된 Class에 정의된 Method Name
    SepoaOut rtn     	= null;
    SepoaRemote ws   	= null;

    if(MODE.equals("setGonggoConfirm")) {

		
        
		String[][] dataRAHD = new String[1][];
		String[] temp_RAHD = {ANN_DATE, ANN_DATE, "000000", ANN_DATE, "000000", ANN_DATE, ANN_DATE, info.getSession("HOUSE_CODE"), RA_NO, RA_COUNT};
        dataRAHD[0] = temp_RAHD;
        	
        Object[] args = {RA_NO, RA_COUNT, RA_FLAG, RA_TYPE1, dataRAHD};

		try {

%>

	
<%
			ws = new SepoaRemote(nickName,conType,info);
			rtn = ws.lookup(MethodName,args);

			if(rtn.status == 1){
				RESULT = rtn.message;
				Logger.debug.println(info.getSession("ID"),request,"status = " + rtn.status);

			}
			else
				RESULT = rtn.message;

        } catch(Exception e) {
			Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());
        } finally {
			ws.Release();
		}
        

    } else {
        String [] data = {	RA_FLAG,
                            BID_STATUS,
                            RA_NO,
                            RA_COUNT,
                            ANN_NO,
                            ANN_DATE,
                            ANN_ITEM,
                            BID_ETC,
                            FLAG,
                            ITEM_COUNT,
                            TOTAL_AMT,
                            approval_str                            
                        };

        Object[] args = {data};

        // 다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
        try {

            ws = new SepoaRemote(nickName,conType,info);
            rtn = ws.lookup(MethodName,args);

            if(rtn.status == 1){
                RESULT = "성공적으로 작업을 수행하였습니다";
                Logger.debug.println(info.getSession("ID"),request,"status = " + rtn.status);

            }
            else
                RESULT = "생성된 취소공지가 존재합니다";

        } catch(Exception e) {
            Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());
        } finally {
            ws.Release();
        }

	}


%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<script language="javascript">
<!--
	function init() {

	    alert("<%=RESULT%>");

        if(<%=rtn.status%> == "1") {
        /*
            var url = "<%//=G_groupware_info%>/cancel_bid_approval.htm";
            window.open( url , "GW_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=500,left=0,top=0");
		*/
            //top.MakeTabList("역경매등록현황","/kr/dt/rat/rat_bd_lis11.jsp");
            //parent.location.href = "rat_bd_lis11.jsp";
            parent.opener.doSelect();
            parent.close();
        }
	}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="javascript:init();">

<form name="form1" >
</form>
</body>
</noframes>
</html>
