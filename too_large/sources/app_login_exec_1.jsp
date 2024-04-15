<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="sepoa.fw.util.TripleDes01" %>
<%@ page import="javax.servlet.RequestDispatcher"%>
<%@page import="org.json.JSONObject"%>
<%@include file="encrypt.jsp" %>

<%
/*******************************************************
**  업무서버에서 선언해야 할 변수- Start
**  필수 전달 Parameter 에 넘겨줘야 할 변수 선언 부
*******************************************************/
	String AP_URL = "http://업무서버 경로 및 포트/main.jsp";  // 세션의 SSOID를 이용하여 업무서버의 자체 세션을 생성하는 URL 호출
	String keyValue     = "Rnfqjf01$woorifg";              // 암호화 Key정보(16자리)
	// 임의의 키를 생성하여 적용 후 포탈에 이 로직이 포함된 URL과 암호화 키를 함께 전달해야 함
	// Examle) keyValue를 "1234567890123456"으로 변경하고 이 페이지의 URL이 http://apptest.example.com/oamsso/param/app_login_exec.jsp 인경우
	// 포탈팀에 암복호화 키이 "1234567890123456" 와 URL인 "http://apptest.example.com/oamsso/param/app_login_exec.jsp"를 전달한다.
/*******************************************************
**  업무서버에서 선언해야 할 변수- End
*******************************************************/

	// 전달 인자(변수)
	// - FINDATA : 암호화된 사용자 정보 - JSON 형태 {"ENT_CODE":"회사코드","USER_ID":"사번","REAL_UNIT_CODE":"점코드","UNIT_CODE":"부서코드"}
	String encryptValue = request.getParameter("FINDATA"); // 암호화된 사용자 정보
	String decStrAES = decryptAES(encryptValue, keyValue); // 암호화된 사용자정보 복호화 처리  
	JSONObject jsonObj = new JSONObject(decStrAES);

	String userID = jsonObj.get("USER_ID").toString();
	String ENT_CODE = jsonObj.get("ENT_CODE").toString(); // 회사코드
	String UNIT_CODE = jsonObj.get("UNIT_CODE").toString(); // 부서 코드
	String REAL_UNIT_CODE = jsonObj.get("REAL_UNIT_CODE").toString(); // 점코드
	
	// 복호화 된 사용자 정보 출력 : 운영 반영시 제거해야 함
	out.println("USER_ID : " + userID + "<BR>");
	out.println("ENT_CODE : " + ENT_CODE + "<BR>");
	out.println("UNIT_CODE : " + UNIT_CODE + "<BR>");
	out.println("REAL_UNIT_CODE : " + REAL_UNIT_CODE + "<BR><BR>");

	// 복호화한 SSOID 를 업무 Session에 기록한다.
	//session.setAttribute("SSOID", userID);
/*******************************************************
**  업무서버에서 선언해야 할 변수- Start
**  추가적으로 업무서버에서 사용할 세션 선언 부
*******************************************************/
	//session.setAttribute("ENT_CODE", ENT_CODE);
	//session.setAttribute("UNIT_CODE", UNIT_CODE);
	//session.setAttribute("REAL_UNIT_CODE", REAL_UNIT_CODE);
	
	
	SepoaSession.invalidate(request);
		/*house_code */
    String house_code = JSPUtil.nullToEmpty(request.getParameter("house_code"));
    //System.out.println("HouseCode : " + house_code);
    String url = "";
    Config conf = new Configuration("000");
    if(house_code == null || "".equals(house_code)){
            try {
                    house_code = conf.get(request.getServerName()+".house_code");
            } catch (Exception ex) {
                    house_code = "000";
            }
    }
    SepoaSession.putValue(request, "HOUSE_CODE", house_code);
    SepoaSession.putValue(request, "ID", "LOGIN");
    SepoaSession.putValue(request, "LANGUAGE", "KO");
    SepoaSession.putValue(request, "NAME_LOC", house_code);
    SepoaSession.putValue(request, "NAME_ENG", house_code);
	
/*******************************************************
**  업무서버에서 선언해야 할 변수- End
*******************************************************/
    //새로운 그룹웨어
	String param1 = "12345678"+JSPUtil.paramCheck(userID) + "20151214121212";	//==> To-BE 처리방법
	param1 = CryptoUtil.encryptText(param1);
	
    String FromSite = JSPUtil.paramCheck(request.getParameter("FromSite"));		// FromSite
	String requstUrl = request.getRequestURL().toString();
	StringTokenizer st = new StringTokenizer(requstUrl, "://");

	String protocol = "http";
	
	if(st.hasMoreTokens())
	{
	    protocol = st.nextToken();
	}

	AP_URL = protocol+"://" + request.getServerName();
	String aaserver_port = String.valueOf(request.getServerPort());
	
	if(!aaserver_port.equals("80"))
	{
		AP_URL += ":" + aaserver_port;
	}
	
	
	AP_URL += POASRM_CONTEXT_NAME+"/servlets/sepoa.svl.co.co_login_process";
	String _id = sepoa.fw.srv.Base64.base64Encode(param1);
	
	AP_URL += "?mode=setDirectLogin";
	AP_URL += "&param1="+_id;
	AP_URL += "&FromSite="+FromSite;

	// session에 SSOID를 기록 후 업무 세션을 시작하기 위한 준비를 한다.
	response.sendRedirect(AP_URL);
%>