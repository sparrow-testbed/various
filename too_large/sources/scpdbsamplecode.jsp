
<%@ page contentType="text/html;charset=KSC5601" %>
<%@ page import="javax.sql.*, javax.naming.*, java.sql.*, java.net.URLDecoder, java.net.InetAddress" %>
<%@ page import="com.penta.scpdb.*" %>

<html>
<head>
<title>Penta SCP API Example</title>
<META http-equiv=Content-Type content="text/html; charset=euc-kr">
</head>
<body>
Penta SCP API Example <br>
<br>
<%
InetAddress inet = InetAddress.getLocalHost();
String hostName = "";
String hostAddress = "";
%>
hostName = <%=inet.getHostName()%><br>
hostAddress = <%=inet.getHostAddress()%><br>
user.name = <%=System.getProperty("user.name")%><br>
<br>
java.class.path = <%=System.getProperty("java.class.path")%><br>
java.library.path = <%=System.getProperty("java.library.path")%><br>
<br>
<%
    try
    {
      String strInputPlain = "123456-1234567";
      String strEnc  = "";
      String strDec  = "";
	
	  //strInputPlain2 = URLDecoder.decode(strInputPlain, "UTF-8");
	
      byte[] enc, ctx;
      byte[] dec;
      int ret;
      int encFileSize=0;
      int decFileSize=0;

/* DAMO SCP API
   ���� ���ϰ� Ű������ Ǯ �н� 
*/
      String iniPath         = "/app/damo3/scpdb_agent.ini";       //scpdb_agent.ini fullpath

/* DAMO SCP API 
   ScpDbAgent ��ü�� �����Ѵ� 
*/
      ScpDbAgent agt = new ScpDbAgent();

/* DAMO SCP API ret : 0,118(����) ������(����)
   API �� �ʱ�ȭ �Ѵ�
*/
      ret = agt.AgentInit( iniPath );
      System.out.println("[java] ret : " + ret );

/* DAMO SCP API ret : 0,118(����) ������(����)
   API �� �ٽ� �ʱ�ȭ �Ѵ�
*/
      //ret = agt.AgentReInit( iniPath );
      //System.out.println("[java] ret : " + ret );
%>
AgentInit ret = <%=ret%> <br>
<%
/* DAMO SCP API 
   Ű ���Ͽ��� ���ý�Ʈ�� �����´�
*/
      ctx = agt.AgentCipherCreateContextServiceID( "CBS", "Account" );

/* 
  DAMO SCP API : ����Ÿ�� NULL�̸� ��ȣȭ �Լ��� �������� �ʵ��� �Ѵ�.
*/
%>
strInputPlain = <%=strInputPlain%> <br>
<%
/* DAMO SCP API 
   encrypt function 
*/
      strEnc = agt.AgentCipherEncryptString( ctx, strInputPlain );
      System.out.println("[java] AgentCipherEncryptString : " + strEnc);
%>
AgentCipherEncryptString = <%=strEnc%> <br>
<%
/* 
  DAMO SCP API : ����Ÿ�� NULL�̸� ��ȣȭ �Լ��� �������� �ʵ��� �Ѵ�.
*/
/* DAMO SCP API 
   decrypt function
*/ 
      strDec = agt.AgentCipherDecryptString( ctx, strEnc );
      System.out.println("[java] AgentCipherDecryptString : " + strDec);
%>
AgentCipherDecryptString = <%=strDec%> <br>
<%
/* DAMO SCP API 
   encrypt function 
*/
      strEnc = agt.AgentCipherEncryptStringB64( ctx, strInputPlain );
      System.out.println("[java] AgentCipherEncryptStringB64 : " + strEnc);
%>
AgentCipherEncryptStringB64 = <%=strEnc%> <br>
<%
/* 
  DAMO SCP API : ����Ÿ�� NULL�̸� ��ȣȭ �Լ��� �������� �ʵ��� �Ѵ�.
*/
/* DAMO SCP API 
   decrypt function
*/ 
      strDec = agt.AgentCipherDecryptStringB64( ctx, strEnc );
      System.out.println("[java] AgentCipherDecryptStringB64 : " + strDec);
%>
AgentCipherDecryptStringB64 = <%=strDec%> <br>

<%
    }
    catch( ScpDbAgentException e )
    {
%>
<br>[D`Amo Exception]<br>
<%=e.toString()%>
<%
      System.out.println(e.toString());
	  System.out.println(e.returnedValue());
    }
%>
</body>
</html>


