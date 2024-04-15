<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="sepoa.fw.srv.SepoaService"%>
<%@ page import="sepoa.fw.db.*"%>
<%--
[페이지 개요]
제목 : 파일 다운로드
작성일 : 2013년 11월 20일
작성자 : 유상훈
관련파일 : 
서블릿(sepoa.svl.util.file_download.jsp)

file_attach_2013.jsp 에서 다운로드 기능만 발췌해서 기술함.

 --%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/sepoa_common.jsp"%>

<link rel="stylesheet" href="../../css/common.css"/>
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
			present.location.href = url;
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

<link rel="stylesheet" href="../../css/layout.css"/>
<link rel="stylesheet" href="../../css/sec.css" type="text/css">
<script type="text/javascript" src="../../js/lib/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="../../js/lib/jquery.form.min.js"></script>	<!-- form의 fileupload를 위해 필요 -->
<script language=javascript src="../../js/lib/sec.js"></script><!-- 폴더 위치 변경됨,파일 추가됨 -->

<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<%
	//세션 없이 업로드/다운로드 가능한 페이지는 isSession을 false로 추가해준 페이지의 경우만 가능
	sepoa.fw.ses.SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(request);
	String server_name = "http://" + request.getServerName();
	String server_port = String.valueOf(request.getServerPort());
	
	if(! server_port.equals("80"))
	{
		server_name += ":" + server_port;
	}
	//String isSession =  JSPUtil.CheckInjection(request.getParameter("isSession"));		//false 인 경우 세션 체크하지 않는다.
	//[C202212160017][2022-12-22](은행)전자구매 Cross_Site Scripting 취약점 조치
	String isSession =  JSPUtil.CheckInjection3(request.getParameter("isSession"));		//false 인 경우 세션 체크하지 않는다.
	
	//세션이 없는 경우
	if(info.getSession("ID").trim().length() <= 0)
	{
		if("false".equals(isSession)){
			//isSession으로 지정해준 경우는 강제로 만들고
			String user_os_lang = (String)(session.getAttribute("USER_OS_LANGUAGE")) == null ? "KO" : (String)(session.getAttribute("USER_OS_LANGUAGE"));
			String company_code = (String)(session.getAttribute("COMPANY_CODE")) == null ? "WOORI" : (String)(session.getAttribute("COMPANY_CODE"));
			info = new SepoaInfo("100","COMPANY_CODE="+company_code+"^@^ID=SUPPLIER^@^LANGUAGE=" + user_os_lang + "^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^USER_TYPE=S^@^");			
		}else{
			//아닌 경우 
	%>
			<script>
				alert("Session closed.");
				//location.href="<%=(server_name + request.getContextPath())%>";	//메인 페이지로 이동
				sessionCloseF("<%=(server_name + request.getContextPath())%>");
			</script>
	<% 		
			return;	//중지
		}
	}
	
	//sepoa_session.jsp에 포함되어 있는 변수 정의
	String thisWindowPopupFlag = "true";
	String thisWindowPopupScreenName = "";
	
	//String type 		= JSPUtil.CheckInjection(request.getParameter("type"));		//CATALOG, NOT,,,
	//String attach_key 	= JSPUtil.CheckInjection(request.getParameter("attach_key"));
    //[C202212160017][2022-12-22](은행)전자구매 Cross_Site Scripting 취약점 조치
	String type 		= JSPUtil.CheckInjection3(request.getParameter("type"));		//CATALOG, NOT,,,
	String attach_key 	= JSPUtil.CheckInjection3(request.getParameter("attach_key"));
    
	
    // 다운로드인 경우 VI
    //String view_type =  JSPUtil.CheckInjection(request.getParameter("view_type"));		
	//[C202212160017][2022-12-22](은행)전자구매 Cross_Site Scripting 취약점 조치
	String view_type =  JSPUtil.CheckInjection3(request.getParameter("view_type"));	
	
    String isGrid = JSPUtil.nullToEmpty(request.getParameter("isGrid")); //그리드에서 파일첨부시 한로우씩 처리해주기위한 파라메터
    String gridRowId = JSPUtil.nullToEmpty(request.getParameter("gridRowId"));
    String gridColId = JSPUtil.nullToEmpty(request.getParameter("gridColId"));

	Vector multilang_id = new Vector();
	multilang_id.addElement("CO_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

    Config conf = new Configuration();
    String G_file_type = conf.get("sepoa.file.attach.type");			// zip;ppt;gul;jpg;doc;xls;gif;bmp;txt;hwp;pdf;docx;xlsx;pptx;png
    String[] file_type = G_file_type.split(";");
    //String G_not_file_type = conf.get("sepoa.file.attach.notType");	// 첨부해서는 안되는 확장자
    String conf_filesize = conf.get("sepoa.attach.maxsize");			// 15

    //sepoa_milestone 관련(화면 상단 타이틀 정의)
    String masterDescription = "";
    if("IN".equals(view_type)){
    	masterDescription = (String)text.get("CO_007.TXT_01");	//파일첨부
    }else{
    	masterDescription = (String)text.get("CO_007.TXT_13");	//첨부파일
    }
    
    // 다운로드인 경우, 이미 첨부 시도가 있었던 상황이기에 페이지를 리로딩 또는 새로 열었을때, 첨부기록이 남아 있어야 한다.다시 DB를 조회한다.
    Vector fileData = new Vector();
    int attach_seq = 1;
    if("VI".equals(view_type)){
    	if(attach_key != null && !"".equals(attach_key)){
	    	//DB에서 attach_key로 파일 데이터를 가져와야 한다.
	    	fileData = Attach_File_DataBase_Select(attach_key,info);  	
			if (fileData.size() > 0) {
				//마지막 DOC_SEQ 값을 가져와서 계속 추가할 때 사용하기 위해
	   		    Hashtable ht2 = (Hashtable)fileData.elementAt(fileData.size()-1);
				attach_seq = Integer.parseInt((String)ht2.get("DOC_SEQ"))+1;
			}
    	}
    }
%>

<%!
String innerHtml = "";
//select box에 option을 추가하기 위해 사용됨
private Vector Attach_File_DataBase_Select(String Attach_Key, SepoaInfo info) {

	Vector vt = new Vector();
	SepoaService ss = null;
    ConnectionContext ctx =  null;
    
    try{
    	ss = new SepoaService("CONNECTION", info) {};
    	ctx =  ss.getConnectionContext();
    	
    	StringBuffer Attach_Sql = new StringBuffer();
        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        sm.removeAllValue();
        
    	Attach_Sql.append(" SELECT FILE_SIZE 	\n"); 
    	Attach_Sql.append(" 	,DOC_NO 		\n");
    	Attach_Sql.append(" 	,DOC_SEQ 		\n");		
    	Attach_Sql.append(" 	,TYPE 			\n");		
    	Attach_Sql.append(" 	,DES_FILE_NAME 	\n");		
    	Attach_Sql.append(" 	,SRC_FILE_NAME 	\n");		
    	Attach_Sql.append(" 	,ADD_USER_ID 	\n");		
    	Attach_Sql.append(" FROM sfile 			\n"); 
    	Attach_Sql.append(" WHERE 1=1  			\n");  
    	Attach_Sql.append(sm.addFixString(" AND DOC_NO = ? \n"));sm.addStringParameter(Attach_Key);
    	Attach_Sql.append(" ORDER BY DOC_NO,DOC_SEQ \n");
		String rtn = sm.doSelect(Attach_Sql.toString());
		String inputId = "";
		
		SepoaFormater sf = new SepoaFormater(rtn);
		for(int i = 0 ; i < sf.getRowCount() ; i++){
			Hashtable ht = new Hashtable();
			ht.put("FILE_SIZE", sf.getValue("FILE_SIZE",i));
			ht.put("DOC_NO", sf.getValue("DOC_NO",i));
			ht.put("DOC_SEQ", sf.getValue("DOC_SEQ",i));
			ht.put("TYPE", sf.getValue("TYPE",i));
			ht.put("DES_FILE_NAME", sf.getValue("DES_FILE_NAME",i));
			ht.put("SRC_FILE_NAME", sf.getValue("SRC_FILE_NAME",i));
			ht.put("ADD_USER_ID", sf.getValue("ADD_USER_ID",i));
			// ht.put("ADD_USER_NAME",sf.getValue("ADD_USER_NAME",i));
			inputId = sf.getValue("DOC_NO",i) + sf.getValue("DOC_SEQ",i);
			
			vt.add(ht);
			innerHtml += "<input type='hidden' id='"+inputId+"_FILE_SIZE' 		name='"+inputId+"_FILE_SIZE' 		value='"+sf.getValue("FILE_SIZE",i)+"'/>";
			innerHtml += "<input type='hidden' id='"+inputId+"_DOC_NO' 			name='"+inputId+"_DOC_NO' 			value='"+sf.getValue("DOC_NO",i)+"'/>";
			innerHtml += "<input type='hidden' id='"+inputId+"_DOC_SEQ' 		name='"+inputId+"_DOC_SEQ' 		value='"+sf.getValue("DOC_SEQ",i)+"'/>";
			innerHtml += "<input type='hidden' id='"+inputId+"_TYPE' 			name='"+inputId+"_TYPE' 			value='"+sf.getValue("TYPE",i)+"'/>";
			innerHtml += "<input type='hidden' id='"+inputId+"_DES_FILE_NAME' 	name='"+inputId+"_DES_FILE_NAME' 	value='"+sf.getValue("DES_FILE_NAME",i)+"'/>";
			innerHtml += "<input type='hidden' id='"+inputId+"_SRC_FILE_NAME' 	name='"+inputId+"_SRC_FILE_NAME' 	value='"+sf.getValue("SRC_FILE_NAME",i)+"'/>";
		}
		
    }catch(Exception e){
        Logger.debug.println(info.getSession("ID"), this, e.getMessage());
    	
    }finally{
    	ss.Release();	
    	//보통은 doService를 이용하여 doService안에서 자동으로 db release가 일어나지만
    	//여기서는 doService는 이용하지 않고, 단지 connection만 사용하기에 별도로 release 작업이 필요하다. 
    }
	return vt;
}
%>

<script>

function init(){
	var innerHtml = "<%=innerHtml%>";
	$("#form1").append("<%=innerHtml%>");
	<%innerHtml = "";%>
}

//파일 다운로드(첨부된 파일이 존재할 때)
function download(){
	var count = document.form1.uploads.options.length;
	if(count < 1){
		//alert("파일을 선택하세요.");	// 파일을 선택하세요.
		return;
	}
	
	var selectBox = $("#uploads option:selected");	//select box중 선택된 option의 value값을 가져온다.(다중선택 하더라도 한줄만)
	//value 예시 : 1234567890123__1
	//value 예시 : 1234567890123__1
	var value = "";
	var doc_no = document.form1.attach_key.value;
	for(var i = 0 ; i<selectBox.length ; i++){
		if(selectBox[i].value == "NO"){
			continue;
		}
// 		value += selectBox[i].value.substring(selectBox[i].value.lastIndexOf("__")+2) + "_";
		value += selectBox[i].value+ "_";;
	}
	

	// NO:select box의 제목을 선택했을 때
	// undefined : 적절한 select box를 선택하지 않았을떄
	if (value=="NO" || value == "" || value == undefined) {
		alert("파일을 선택하세요.");	// 파일을 선택하세요.
		return;
	}
	
	var valueArr = value.split("_");
	
	for(var i = 0 ; i < valueArr.length-1 ; i++){
		
		var pDoc_no 		= $("#" + valueArr[i] + "_DOC_NO").val();
		var pSize 			= $("#" + valueArr[i] + "_FILE_SIZE").val();
		var pDoc_seq 		= $("#" + valueArr[i] + "_DOC_SEQ").val();
		var pfilename 		= $("#" + valueArr[i] + "_DES_FILE_NAME").val();
		var pRealfilename 	= $("#" + valueArr[i] + "_SRC_FILE_NAME").val();
		var pType	 		= $("#" + valueArr[i] + "_TYPE").val();
		var pExt	 		= pRealfilename.substring(pRealfilename.lastIndexOf(".")+1);
		
		var params = "";
		params += "?filename="+pfilename;
		params += "&realfilename="+pRealfilename;
		params += "&size="+pSize;
		params += "&type="+pType;
		params += "&doc_no="+pDoc_no+pDoc_seq;
		params += "&ext="+pExt;
		
	    var viewloc = "file_download.jsp" + params;
// 	    alert("viewloc="+viewloc);
	    location.href = viewloc;
	}
}

//화면닫기
function pageCancel(){
/* 	//첨부한 파일이 존재시 그냥 닫아버리면, 적용되지 않는다는 경고메시지 출력 필요
	var count = document.form1.uploads.options.length;
	if(count > 1){
		if(confirm("취소하시면 첨부한 파일이 적용되지 않습니다.\n 취소하시겠습니까?")){
			window.close();
		}
	}else{ */
		window.close();
//	}	
}

</script>
</head>
<body onload="javascript:init();" style="background-color: #F8F8F8" >
<form name="form1" id="form1" method="post" enctype="multipart/form-data">
<input type="hidden" name="view_type" value="<%=view_type%>">
<input type="hidden" name="attach_key" value="<%=attach_key%>">
<input type="hidden" name="attach_seq" value="<%=attach_seq%>">
<input type="hidden" name="type" value="<%=type%>">
<input type="hidden" name="isGrid" value="<%=isGrid%>">
<%
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = masterDescription;
%>
<table width="98%" border="0" cellspacing="0" cellpadding="0" style="background-color: #F8F8F8" >
  	<tr>
		<td valign="middle"  style="background-color: #F8F8F8" >
     		<select name="uploads" id="uploads" size="7" style="width:100%;" onclick="javascript:download();">
				<%
             		String fileSize = "0";
           			for(int i = 0 ; i < fileData.size() ; i++) {

             			Hashtable ht1 = (Hashtable)fileData.elementAt(i);
             			fileSize = (String)ht1.get("FILE_SIZE");
             			if (fileSize == null)fileSize = "0";
             			
             			fileSize = SepoaString.dFormat(fileSize);	//천단위 구분	
             
             			out.println("<OPTION VALUE='"+ht1.get("DOC_NO")+ht1.get("DOC_SEQ")+"'>");
             			out.println(ht1.get("SRC_FILE_NAME")+"("+fileSize+"Byte)</OPTION>\n");
           			}
             	%>
			</select>
		</td>
	</tr>
<!-- 	<TR> -->
<%-- 		<td align="right" style="background-color: #F8F8F8" ><script language="javascript">btn("javascript:download()","<%=text.get("BUTTON.download")%>");</script></td><!-- 다운로드 --> --%>
<!-- 	</TR>	 -->
</table>
<iframe id="downFrm" name="downFrm" style="display: none; "></iframe>
</form>
</body>
</html>