<%-- UTF-8적용 지우지마세요 --%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.fw.ses.*" %>
<%@ page import="sepoa.fw.srv.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<script>
function sessionCloseF(url){
	//팝업은 모두 강제close시키고, 메인window는 초기 page로 이동시킨다.
	var count = 0;
	var present = window;
	while(true){
		var opr = getOpener(present);
		//temp.a();
		if(opr == undefined){
			//present현재 opener가 존재하지 않으면(main페이지)
			//present.location.href = url;
			parent.location.href = url;	//하단의 팝업메뉴 때문에 1단계 더...
			break;
		}else{
			//present현재 opener가 존재하면
			present.close();
		}
		present = opr;
		count++;
		if(count > 10){
			break; //혹시나 무한루프를 돌게 되면,,,
		}
	}
	function getOpener(p){
		return p['opener'];
	}
}
</script>
<%
	Config S_con = new Configuration();
	boolean S_devCheckFlag = S_con.getBoolean("sepoa.server.development.flag");
	String request_server_name = SepoaString.replace(request.getServerName(), ".", "");

	if(StringUtils.isNumeric(request_server_name) && !S_devCheckFlag)
	{	%>
		<script>
			alert("운영 장비에서는 IP 로 접속할 수 없습니다. Domain 으로 접속하시기 바랍니다.");
		</script>
	<%
		return;
	}

	sepoa.fw.ses.SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(request);
	request.setAttribute("SEPOA_INFO", info);
	String ssl_use_flag = "";
	try
	{
		Configuration conf_session_check = new Configuration();
		ssl_use_flag = conf_session_check.get("sepoa.system.ssl.use_flag").trim();
	}
	catch(Exception e)
	{
		
	}

	if(ssl_use_flag.equals("true"))
	{
		Logger.debug.println(info.getSession("ID"), request, "#####################################");
		Logger.debug.println(info.getSession("ID"), request, "############# SSL Mode ##############");
		Logger.debug.println(info.getSession("ID"), request, "#####################################");

		String requstUrl = request.getRequestURL().toString();
		StringTokenizer st = new StringTokenizer(requstUrl, "://");

		String protocol = "";
		if(st.hasMoreTokens())
		{
			protocol = st.nextToken();

			if(protocol.equals("http"))
			{
				Logger.debug.println(info.getSession("ID"), request, "#############################################################");
				Logger.debug.println(info.getSession("ID"), request, "############# Protocol Change : http ==> https ##############");
				Logger.debug.println(info.getSession("ID"), request, "#############################################################");
				String servlet_path = JSPUtil.CheckInjection(JSPUtil.nullChk(request.getServletPath()));
				String query_string = JSPUtil.CheckInjection(JSPUtil.nullChk(request.getQueryString()));

				String new_url = "https://" + request.getServerName();

				if(!servlet_path.equals(""))
				{
					new_url += servlet_path;
				}

				if(!query_string.equals(""))
				{
					new_url += "?" + query_string;
				}
%>
<script>
	location.href = "<%=new_url%>";
</script>
<%
				return;
			}
		}
	}

    String daguriScreenId = "";
	String server_name = "https://" + request.getServerName();
	String server_port = String.valueOf(request.getServerPort());

	if(! server_port.equals("80"))
	{
		server_name += ":" + server_port;
	}

	if(info.getSession("ID") == null)
	{
%>
		<script>
// 			alert("Session closed.");
			alert("세션이 끊겼습니다.");
			//top.location.href="<%=(server_name + request.getContextPath())%>";
			sessionCloseF("<%=(server_name + request.getContextPath())%>");
		</script>
<%
		return;
	}

	if(info.getSession("ID").trim().length() <= 0)
	{
%>
		<script>
// 			alert("Session closed.");
			alert("세션이 끊겼습니다.");
			//top.location.href="<%=(server_name + request.getContextPath())%>";
			sessionCloseF("<%=(server_name + request.getContextPath())%>");
		</script>
<%
		return;
	}

	//임시로 설정해제(기본은 세션이 끊어짐을 방지하기 위해, 주기적으로 임의의 page를 호출한다.)
	//String urlPathDaguri = "";
	String urlPathDaguri = JSPUtil.nullChk(request.getServletPath());
	String queryStringDaguri = JSPUtil.nullChk(request.getQueryString());
	String thisWindowPopupFlag = JSPUtil.CheckInjection(JSPUtil.nullChk(request.getParameter("popup_flag")))	;
	String thisWindowInitFlag = JSPUtil.paramCheck(request.getParameter("init_flag"));
	String thisWindowInitMenuObjectCode = JSPUtil.paramCheck(request.getParameter("init_menu_object_code"));
	String thisWindowPopupScreenName = "";

//	out.println("thisWindowInitFlag : " + thisWindowInitFlag);
//	out.println(" >>>>> : " + JSPUtil.paramCheck(request.getParameter("init_flag")));

	if(thisWindowInitFlag.equals("true"))
	{
		thisWindowPopupFlag = "true";
	}

    boolean isSeeDaguri = true;

	if(urlPathDaguri.length() > 0)
	{
	    SepoaOut valueDaguri = null;
	    SepoaFormater wfDaguri = null;

	    try
	    {
			Object[] obj = {info, urlPathDaguri, thisWindowPopupFlag, thisWindowInitMenuObjectCode, thisWindowPopupScreenName};
			valueDaguri = ServiceConnector.doService(info, "CO_011", "TRANSACTION","checkUrl", obj);

	        if (!valueDaguri.flag)
	        {
	            isSeeDaguri = false;
	        }
	        else
	        {
	            isSeeDaguri = true;
	        }

            wfDaguri = new SepoaFormater( valueDaguri.result[ 0 ] );

            if(wfDaguri.getRowCount() <= 0)
            {
            	isSeeDaguri = false;
            }
            else
            {
            	Logger.debug.println(info.getSession("ID"), request, "wfDaguri.getValue(CHK, 0): " + wfDaguri.getValue("CHK", 0));
            	Logger.debug.println(info.getSession("ID"), request, "wfDaguri.getValue(AUTHO, 0): " + wfDaguri.getValue("AUTHO", 0));

            	if(! wfDaguri.getValue("CHK", 0).equals("x"))
            	{
            		isSeeDaguri = true;
            	}
            	else
            	{
            		if(wfDaguri.getValue("AUTHO", 0).equals("x"))
            			isSeeDaguri = true;
            		else
            			isSeeDaguri = false;
            	}

            	daguriScreenId = wfDaguri.getValue("SCREEN_ID", 0).trim();
            	thisWindowPopupScreenName = wfDaguri.getValue("popup_screen_name", 0).trim();
            }

		}
	    catch(Exception e)
	    {
	        Logger.err.println( info.getSession("ID"), request, "e = " + e.getMessage() );
	    }
	    finally
	    {
	    		
	    }   // end of try
		if(!isSeeDaguri)
		{
		%>
			<script>
				//document.location.href="../errorPage/no_autho_en.jsp?flag=e1";
				sessionCloseF("/errorPage/no_autho_en.jsp?flag=e1");
			</script>
		<%
			return;
		}

	}


	//2014.09.19 현재시간 표현 추가(입찰에서 사용)
	
	String server_time = "";
	String YYYY = "";
	String MM = "";
	String DD = "";
	String HH = "";
	String MI = "";
	String SS = "";
	
   	String date = SepoaDate.getShortDateString();
   	String time = SepoaDate.getShortTimeString();
   	server_time = date + time;
   	YYYY = date.substring(0,4);
   	MM = date.substring(4,6);
   	DD = date.substring(6,8);
   	HH = time.substring(0,2);
   	MI = time.substring(2,4);
   	SS = time.substring(4,6);
%>

			<script>
				var YYYY = "<%=YYYY%>"; 
				var MM = "<%=String.valueOf(Integer.parseInt(MM)-1)%>"; 
				var DD = "<%=DD%>"; 
				var HH = "<%=HH%>"; 
				var MI = "<%=MI%>"; 
				var SS = "<%=SS%>"; 
				var date = new Date(YYYY , MM, DD, HH, MI, SS);
				function printDate()
				{
					var obj		= document.getElementById("id1");
					
					var yyyy	= date.getFullYear();
					var mm		= "0"+parseInt(date.getMonth()+1); 
					var dd		= "0"+date.getDate();
					var hour	= "0"+date.getHours();
					var minute	= "0"+date.getMinutes();
					var sec		= "0"+date.getSeconds();
					mm			= mm.substr(mm.length - 2, 2);
					dd			= dd.substr(dd.length - 2, 2);
					hour		= hour.substr(hour.length - 2, 2);
					minute		= minute.substr(minute.length - 2, 2);
					sec			= sec.substr(sec.length - 2, 2);

			        switch(date.getDay()) {
			            case 0: day = "일"; break;
			            case 1: day = "월"; break;
			            case 2: day = "화"; break;
			            case 3: day = "수"; break;
			            case 4: day = "목"; break;
			            case 5: day = "금"; break;
			            case 6: day = "토"; break;
			        }
			        
					var szTime = yyyy + "년" + mm + "월" + dd + "일(" + day + ") "+ hour + "시" + minute + "분" + sec + "초";
					var szTimes = yyyy + mm + dd + hour + minute + sec;
					
					if(obj.firstChild && obj.firstChild.nodeType == 3){
						obj.firstChild.nodeValue = szTime;
						document.forms[0].h_server_date.value = szTimes;
						
					}else{
						var objText = document.createTextNode(szTime);
						document.forms[0].h_server_date.value = szTimes;
						obj.appendChild(objText);
					}
					setTimeout("date.setTime(date.getTime()+1000);printDate();", 1000);
				}
				function printDateInput(objName)
				{
					var obj		= $('#' + objName);
					
					var yyyy	= date.getFullYear();
					var mm		= "0"+parseInt(date.getMonth()+1); 
					var dd		= "0"+date.getDate();
					var hour	= "0"+date.getHours();
					var minute	= "0"+date.getMinutes();
					var sec		= "0"+date.getSeconds();
					mm			= mm.substr(mm.length - 2, 2);
					dd			= dd.substr(dd.length - 2, 2);
					hour		= hour.substr(hour.length - 2, 2);
					minute		= minute.substr(minute.length - 2, 2);
					sec			= sec.substr(sec.length - 2, 2);

			        switch(date.getDay()) {
			            case 0: day = "일"; break;
			            case 1: day = "월"; break;
			            case 2: day = "화"; break;
			            case 3: day = "수"; break;
			            case 4: day = "목"; break;
			            case 5: day = "금"; break;
			            case 6: day = "토"; break;
			        }
			        
					var szTime = yyyy + "년" + mm + "월" + dd + "일(" + day + ") "+ hour + "시" + minute + "분" + sec + "초";
					var szTimes = yyyy + mm + dd + hour + minute + sec;
					
					if(obj.firstChild && obj.firstChild.nodeType == 3){
						obj.firstChild.nodeValue = szTime;
						document.forms[0].h_server_date.value = szTimes;
						
					}else{
						var objText = document.createTextNode(szTime);
						document.forms[0].h_server_date.value = szTimes;
						obj.val(szTime);
					}
					setTimeout("date.setTime(date.getTime()+1000);printDateInput('"+objName+"');", 1000);
				}

			</script>
