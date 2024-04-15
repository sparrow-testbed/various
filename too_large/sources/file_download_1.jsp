<% // 소스 사용처 없음. 검색을 통한 확인 %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.db.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="sepoa.fw.util.*"%>

<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.fw.srv.SepoaService"%>

<%@ include file="/include/sepoa_session.jsp"%>


<%
	// Session 없으면 사용불가로 수정 : 2015.09.23
	String noSession =  JSPUtil.CheckInjection(request.getParameter("noSession"));		//yes 인 경우 세션 체크하지 않는다.
	sepoa.fw.ses.SepoaInfo info = null;
	if("yes".equals(noSession)){
		//메인화면과 같이 로그인하지 않은 상태(세션값이 없는 상태, 공지사항첨부파일)에서 파일을 다운 받기 위해
		//임시로 세션을 지정한다.
		SepoaSession.putValue(request, "ID", "guestTemporary");
		info = SepoaSession.getAllValue(request);
	}

	InputStream in = null;
	OutputStream os = null;

	Vector vt = new Vector();
	SepoaService ss = null;
 	ConnectionContext ctx =  null;
 
 try
 {
   	Config conf = new Configuration();
   	String down_root = conf.get("sepoa.attach.path.download");
	String att_file  = "";
	String doc_no    = JSPUtil.CheckInjection(request.getParameter("doc_no"));
	String seq    = JSPUtil.CheckInjection(request.getParameter("seq"));
	
	
	
	String file_name = "";
   	String filename  = "";
   	
   	ss = new SepoaService("CONNECTION", info) {};
   	ctx =  ss.getConnectionContext();
   	
   	StringBuffer Attach_Sql = new StringBuffer();
    ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    sm.removeAllValue();
   	Attach_Sql.append(" SELECT SRC_FILE_NAME 	\n"); 
   	Attach_Sql.append(" 	  ,DES_FILE_NAME 	\n");
   	Attach_Sql.append(" 	  ,TYPE	 			\n");		
   	Attach_Sql.append(" FROM SFILE 				\n"); 
   	Attach_Sql.append(" WHERE 1=1 				\n");
   	Attach_Sql.append(sm.addSelect(" AND DOC_NO = ? \n"));sm.addStringParameter(doc_no);
//oracle   	
   	Attach_Sql.append(sm.addSelect(" AND DOC_SEQ = lpad(?,'8','0') \n"));sm.addStringParameter(seq);
//ms-sql   	
//   	Attach_Sql.append(sm.addSelect(" AND DOC_SEQ = dbo.lpad(?,'8','0') \n"));sm.addStringParameter(seq);
   	Attach_Sql.append(" ORDER BY DOC_NO,DOC_SEQ \n");
	String rtn = sm.doSelect(Attach_Sql.toString());
	
	
	SepoaFormater sf = new SepoaFormater(rtn);
	file_name = sf.getValue("SRC_FILE_NAME",0);
	filename  = URLEncoder.encode(file_name, "UTF-8");

	String type = sf.getValue("TYPE",0);
	String desFileName = sf.getValue("DES_FILE_NAME",0);

	att_file  = conf.get("sepoa.attach.view."+type) + "/" + desFileName;
 
   	
   	File file = new File(down_root + att_file);
   	in = new FileInputStream(file);
   	
   	response.reset() ;
    response.setContentType("application/smnet");
   	response.setHeader ("Content-Type", "application/smnet; charset=UTF-8");
   	response.setHeader ("Content-Disposition", "attachment; filename="+filename+"\"" );
   	response.setHeader ("Content-Transfer-Encoding", "binary"); 
   	response.setHeader ("Content-Length", ""+file.length());
   	
   	os = response.getOutputStream();
   	
    byte b[] = new byte[(int)file.length()];
    int leng = 0;
    while( (leng = in.read(b)) > 0 ) {
     	os.write(b,0,leng);
     	os.flush();
    }

 } catch(Exception e) {
  	
  	response.sendRedirect("/errorPage/system_error.jsp");		
 } finally {
 	//보통은 doService를 이용하여 doService안에서 자동으로 db release가 일어나지만
 	//여기서는 doService는 이용하지 않고, 단지 connection만 사용하기에 별도로 release 작업이 필요하다.	 
	ss.Release();
	if(in !=null)try{in.close();}catch(Exception e){}
	if(os !=null)try{os.close();}catch(Exception e){}
 }
 %>
