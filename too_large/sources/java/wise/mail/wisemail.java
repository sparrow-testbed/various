package wise.mail;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;
import java.util.Vector;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Service;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.event.ConnectionEvent;
import javax.mail.event.TransportEvent;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import sepoa.fw.cfg.Configuration;

public class WiseMail
{
  Properties props = null;
  Message msg;
  InternetAddress cc;
  Session session;
  InternetAddress[] toAddr;
  String attachFilePath;
  Vector attachFiles;
  Vector addRecipientAddress;
  Vector addRecipientAddressName;
  Vector addReplyToAddress;
  String ccAddress;
  boolean ccFlag;
  String comment;
  boolean isHtml;
  String mailAdmin;
  String mailAdminName;
  String mailHost;
  String mailAuth;
  String mailId;
  String mailPw;
  String house_code;

  public WiseMail(String house_code)
    throws MailException
  {
	  this.house_code = house_code;
    this.props = null;
    this.msg = null;
    this.cc = null;
    this.session = null;
    this.toAddr = null;
    this.attachFilePath = "";
    this.attachFiles = null;
    this.addRecipientAddress = null;
    this.addRecipientAddressName = null;
    this.addReplyToAddress = null;
    this.ccAddress = null;

    this.ccFlag = true;
    this.comment = null;
    this.isHtml = false;
    this.mailAdmin = null;
    this.mailAdminName = null;
    this.mailHost = null;
    this.mailAuth = "false";
    this.mailId = null;
    this.mailPw = null;
    try
    {
      

      Configuration localConfiguration = new Configuration();

      this.mailHost 		= localConfiguration.get("wise.mail.host");
      this.mailAdmin 		= localConfiguration.get("wise.mail.admin."+house_code);
      this.mailAdminName	= new String((localConfiguration.get("wise.mail.admin.name."+house_code)).getBytes("8859_1"), "KSC5601");
      this.mailAuth 		= String.valueOf(localConfiguration.getBoolean("wise.mail.host.auth.flag"));
      this.mailId 			= localConfiguration.get("wise.mail.host.id");
      this.mailPw 			= localConfiguration.get("wise.mail.host.password");
      this.attachFilePath	= localConfiguration.get("wise.mail.attachPath");

      
      
      
      
      
      
      

      this.props = new Properties();
      this.props.put("mail.smtp.host", this.mailHost);

      this.session = Session.getDefaultInstance(this.props, null);
      this.session.setDebug(true);
      this.msg = new MimeMessage(this.session);
      this.msg.setSentDate(new Date());

      InternetAddress localInternetAddress = new InternetAddress(this.mailAdmin, this.mailAdminName, "EUC-KR");
      this.msg.setFrom(localInternetAddress);
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }

    
  }

  public void setHouseCode(String house_code)  throws MailException
{
	  this.house_code = house_code;
}

  public WiseMail(String paramString1, String paramString2, String paramString3, String paramString4, boolean paramBoolean) throws MailException
  {
    this.msg = null;
    this.cc = null;
    this.session = null;
    this.toAddr = null;
    this.attachFilePath = "";
    this.attachFiles = null;
    this.addRecipientAddress = null;
    this.addRecipientAddressName = null;
    this.addReplyToAddress = null;
    this.ccAddress = null;
    this.ccFlag = false;
    this.comment = null;
    this.isHtml = false;
    this.mailAdmin = null;
    this.mailAdminName = null;
    this.mailHost = null;
    this.mailHost = paramString1;
    this.mailAdmin = paramString2;
    this.mailAdminName = paramString3;
    this.ccFlag = paramBoolean;
    this.ccAddress = paramString4;
    this.mailAuth = "false";
    this.mailId = null;
    this.mailPw = null;
    try
    {
      Properties localProperties = new Properties();
      localProperties.put("mail.smtp.host", paramString1);
      this.session = Session.getDefaultInstance(localProperties, null);
      this.session.setDebug(false);
      this.msg = new MimeMessage(this.session);
      this.msg.setSentDate(new Date());
      InternetAddress localInternetAddress = new InternetAddress(paramString2, paramString3);
      this.msg.setFrom(localInternetAddress);
      if (paramBoolean)
      {
        InternetAddress[] arrayOfInternetAddress = { new InternetAddress(paramString4) };

        this.msg.setRecipients(Message.RecipientType.CC, arrayOfInternetAddress);
      }
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void send() throws MailException
  {
    setAttach();

    Transport localTransport = null;
    try
    {
      
      
      
      
      this.props.put("mail.smtp.auth", this.mailAuth);

      if (this.mailAuth.equals("true"))
      {
        

        this.msg.saveChanges();
        localTransport = this.session.getTransport("smtp");
        localTransport.connect(this.mailHost, this.mailId, this.mailPw);
        if(localTransport.isConnected()){
        	localTransport.sendMessage(this.msg, this.msg.getAllRecipients());
        	localTransport.close();
        }else {
        	

        }

      }
      else
      {
        
        
        Transport.send(this.msg);
      }
    }
    catch (MessagingException localMessagingException)
    {
      try
      {
        Thread.sleep(5L);
      } catch (InterruptedException localInterruptedException) {
      }
      throw new MailException(localMessagingException.getMessage());
    }
  }

  public void opened(ConnectionEvent paramConnectionEvent)
  {
     }

  public void disconnected(ConnectionEvent paramConnectionEvent) { }

  public void closed(ConnectionEvent paramConnectionEvent) { 
  }

  public void messageDelivered(TransportEvent paramTransportEvent)
  {
    
    
    Address[] arrayOfAddress = paramTransportEvent.getValidSentAddresses();
    
      
        
  }

  public void messageNotDelivered(TransportEvent paramTransportEvent) {
    
    
    Address[] arrayOfAddress = paramTransportEvent.getInvalidAddresses();
    
      
        
  }

  public void messagePartiallyDelivered(TransportEvent paramTransportEvent)
  {
  }

  public void setContent(Object paramObject, String paramString)
    throws MailException
  {
    try
    {
      this.msg.setContent(paramObject, paramString);
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Throwable localThrowable)
    {
      throw new MailException(localThrowable.getMessage());
    }
  }

  public void setContent(Multipart paramMultipart)
    throws MailException
  {
    
    try
    {
      this.msg.setContent(paramMultipart);
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Throwable localThrowable)
    {
      throw new MailException(localThrowable.getMessage());
    }
  }

  public void setFrom(String paramString) throws MailException
  {
    
    try
    {
      InternetAddress localInternetAddress = new InternetAddress(paramString);
      this.msg.setFrom(localInternetAddress);
    }
    catch (AddressException localAddressException)
    {
      throw new MailException(localAddressException.getMessage());
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
  }

  public void setFrom(String paramString1, String paramString2)
    throws MailException
  {
    try
    {
      
      InternetAddress localInternetAddress = new InternetAddress(paramString1, paramString2);
      this.msg.setFrom(localInternetAddress);
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void setHtmlContent(String paramString)
    throws MailException
  {
    this.isHtml = true;
    this.comment = paramString;
  }

  public void setRecipient(String paramString1, String paramString2) throws MailException
  {
    try
    {
      InternetAddress[] arrayOfInternetAddress = { new InternetAddress(paramString1, paramString2) };

      this.msg.setRecipients(Message.RecipientType.TO, arrayOfInternetAddress);
    }
    catch (AddressException localAddressException)
    {
      throw new MailException(localAddressException.getMessage());
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void setRecipients(String[][] paramArrayOfString)
    throws MailException
  {
    try
    {
      InternetAddress[] arrayOfInternetAddress = new InternetAddress[paramArrayOfString.length];
      for (int i = 0; i < paramArrayOfString.length; ++i)
      {
        for (int j = 0; j < paramArrayOfString[i].length; ++j)
        {
          arrayOfInternetAddress[i] = new InternetAddress(paramArrayOfString[i][0], paramArrayOfString[i][1]);
        }
      }

      this.msg.setRecipients(Message.RecipientType.TO, arrayOfInternetAddress);
    }
    catch (AddressException localAddressException)
    {
      throw new MailException(localAddressException.getMessage());
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void addReplyTo(String paramString)
  {
    if (this.addReplyToAddress == null)
      this.addReplyToAddress = new Vector();
    this.addReplyToAddress.addElement(paramString);
  }

  public void setReplyTo() throws MailException
  {
    try
    {
      if (this.addReplyToAddress != null)
      {
        InternetAddress[] arrayOfInternetAddress = new InternetAddress[this.addReplyToAddress.size()];

        for (int i = 0; i < this.addReplyToAddress.size(); ++i)
        {
          arrayOfInternetAddress[i] = new InternetAddress(this.addReplyToAddress.elementAt(i).toString());
        }

        this.msg.setReplyTo(arrayOfInternetAddress);

        this.addReplyToAddress = null;
      }

    }
    catch (AddressException localAddressException)
    {
      throw new MailException(localAddressException.getMessage());
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void setReplyTo(String[] paramArrayOfString) throws MailException
  {
    try
    {
      InternetAddress[] arrayOfInternetAddress = new InternetAddress[paramArrayOfString.length];
      for (int i = 0; i < paramArrayOfString.length; ++i)
      {
        arrayOfInternetAddress[i] = new InternetAddress(paramArrayOfString[i]);
      }

      this.msg.setReplyTo(arrayOfInternetAddress);
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void setRecipients(Vector paramVector) throws MailException
  {
    try
    {
      InternetAddress[] arrayOfInternetAddress = new InternetAddress[paramVector.size()];
      Enumeration localEnumeration = paramVector.elements();
      for (int i = 0; localEnumeration.hasMoreElements(); ++i)
      {
        String str = (String)localEnumeration.nextElement();
        arrayOfInternetAddress[i] = new InternetAddress(str);
      }

      this.msg.setRecipients(Message.RecipientType.TO, arrayOfInternetAddress);
    }
    catch (AddressException localAddressException)
    {
      throw new MailException(localAddressException.getMessage());
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void setSubject(String paramString) throws MailException
  {
    try
    {
      
      ((MimeMessage)this.msg).setSubject(paramString, "euc-kr");
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
  }

  public void setTextAndHtmlContent(String paramString1, String paramString2)
    throws MailException
  {
    try
    {
      MimeBodyPart localMimeBodyPart1 = new MimeBodyPart();
      localMimeBodyPart1.setDataHandler(new DataHandler(new ByteArrayDataSource(paramString2, "text/html; charset=euc-kr")));
      localMimeBodyPart1.setHeader("Content-Transfer-Encoding", "7bit");
      MimeBodyPart localMimeBodyPart2 = new MimeBodyPart();
      localMimeBodyPart2.setDataHandler(new DataHandler(new ByteArrayDataSource(paramString1, "text/plain; charset=euc-kr")));
      localMimeBodyPart2.setHeader("Content-Transfer-Encoding", "7bit");
      MimeMultipart localMimeMultipart = new MimeMultipart();
      localMimeMultipart.addBodyPart(localMimeBodyPart1);
      localMimeMultipart.addBodyPart(localMimeBodyPart2);
      localMimeMultipart.setSubType("alternative");
      
      this.msg.setContent(localMimeMultipart);
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void setTextContent(String paramString) throws MailException
  {
    this.isHtml = false;
    this.comment = paramString;
  }

  public void addRecipient(String paramString1, String paramString2)
  {
    if (this.addRecipientAddress == null)
      this.addRecipientAddress = new Vector();
    this.addRecipientAddress.addElement(paramString1);

    if (this.addRecipientAddressName == null)
      this.addRecipientAddressName = new Vector();
    this.addRecipientAddressName.addElement(paramString2);
  }

  public void setRecipient(String paramString)
    throws MailException
  {
    try
    {
      if (this.addRecipientAddress != null)
      {
        InternetAddress[] arrayOfInternetAddress = new InternetAddress[this.addRecipientAddress.size()];

        for (int i = 0; i < this.addRecipientAddress.size(); ++i)
        {
          arrayOfInternetAddress[i] = new InternetAddress(this.addRecipientAddress.elementAt(i).toString(), this.addRecipientAddressName.elementAt(i).toString());
        }

        if (paramString.equals("TO"))
          this.msg.setRecipients(Message.RecipientType.TO, arrayOfInternetAddress);
        if (paramString.equals("CC"))
          this.msg.setRecipients(Message.RecipientType.CC, arrayOfInternetAddress);
        if (paramString.equals("BCC")) {
          this.msg.setRecipients(Message.RecipientType.BCC, arrayOfInternetAddress);
        }
        this.addRecipientAddress = null;
        this.addRecipientAddressName = null;
      }
    }
    catch (AddressException localAddressException)
    {
      throw new MailException(localAddressException.getMessage());
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void addAttach(String paramString)
  {
    if (this.attachFiles == null) this.attachFiles = new Vector();
    this.attachFiles.addElement(paramString);
  }

  public void setAttach()
    throws MailException
  {
    try
    {
      MimeBodyPart localMimeBodyPart1;
      MimeMultipart localMimeMultipart;
      if (this.attachFiles == null)
      {
        if (this.isHtml)
        {
          this.msg.setDataHandler(new DataHandler(new ByteArrayDataSource(this.comment, "text/html; charset=euc-kr")));
          this.msg.setHeader("Content-Transfer-Encoding", "7bit");

          localMimeBodyPart1 = new MimeBodyPart();
          localMimeBodyPart1.setContent(this.comment, "text/html;charset=EUC-KR");
          localMimeMultipart = new MimeMultipart();
          localMimeMultipart.addBodyPart(localMimeBodyPart1);
          this.msg.setContent(localMimeMultipart);
        }
        else
        {
          this.msg.setContent(this.comment, "text/plain; charset=euc-kr");
          this.msg.setHeader("Content-Transfer-Encoding", "7bit");
        }
      }
      else
      {
        localMimeBodyPart1 = new MimeBodyPart();
        if (this.isHtml)
        {
          localMimeBodyPart1.setDataHandler(new DataHandler(new ByteArrayDataSource(this.comment, "text/html; charset=euc-kr")));
          localMimeBodyPart1.setHeader("Content-Transfer-Encoding", "7bit");
        }
        else
        {
          localMimeBodyPart1.setContent(this.comment, "text/plain; charset=euc-kr");
          localMimeBodyPart1.setHeader("Content-Transfer-Encoding", "7bit");
        }
        localMimeMultipart = new MimeMultipart();
        localMimeMultipart.addBodyPart(localMimeBodyPart1);
        for (int i = 0; i < this.attachFiles.size(); ++i)
        {
          MimeBodyPart localMimeBodyPart2 = new MimeBodyPart();
          FileDataSource localFileDataSource = new FileDataSource(this.attachFilePath + this.attachFiles.elementAt(i));
          localMimeBodyPart2.setDataHandler(new DataHandler(localFileDataSource));
          localMimeBodyPart2.setFileName(MimeUtility.encodeText(localFileDataSource.getName()));
          localMimeMultipart.addBodyPart(localMimeBodyPart2);
        }

        this.msg.setContent(localMimeMultipart);
      }
    }
    catch (MessagingException localMessagingException)
    {
      throw new MailException(localMessagingException.getMessage());
    }
    catch (Exception localException)
    {
      throw new MailException(localException.getMessage());
    }
  }

  public void setAttachFilePath(String paramString)
  {
    this.attachFilePath = paramString;
  }

  public void setMailHost(String paramString)
  {
    this.mailHost = paramString;
    this.props.put("mail.smtp.host", this.mailHost);
  }

  public void setMailAuth(String paramString)
  {
    this.mailAuth = paramString;
  }

  public void setMailId(String paramString)
  {
    this.mailId = paramString;
  }

  public void setMailPw(String paramString)
  {
    this.mailPw = paramString;
  }

  public void addRecipients(String _type, String[][] _addresses) throws MessagingException, UnsupportedEncodingException
  {
	  InternetAddress[] arrayInternetAddress = new InternetAddress[_addresses.length];
	  InternetAddress internetAddress = null;

	  for(int i=0; i<_addresses.length; i++){
		  internetAddress = new InternetAddress(_addresses[i][0], _addresses[i][1], "EUC-KR");
		  arrayInternetAddress[i] = internetAddress;
	  }

	  if("TO".equals(_type)){
		  this.msg.addRecipients(Message.RecipientType.TO, arrayInternetAddress);
	  }else if("CC".equals(_type)){
		  this.msg.addRecipients(Message.RecipientType.CC, arrayInternetAddress);
	  }else if("BCC".equals(_type)){
		  this.msg.addRecipients(Message.RecipientType.BCC, arrayInternetAddress);
	  }

  }


  class ByteArrayDataSource
    implements DataSource
  {
    private byte[] data;
    private String type;

    public InputStream getInputStream() throws IOException
    {
      if (this.data == null) {
        throw new IOException("no data");
      }
      return new ByteArrayInputStream(this.data);
    }

    public OutputStream getOutputStream()
      throws IOException
    {
      throw new IOException("cannot do this");
    }

    public String getContentType()
    {
      return this.type;
    }

    public String getName()
    {
      return "dummy";
    }

    ByteArrayDataSource(InputStream paramInputStream, String paramString)
    {
      this.type = paramString;
      try
      {
        int i;
        ByteArrayOutputStream localByteArrayOutputStream = new ByteArrayOutputStream();

        while ((i = paramInputStream.read()) != -1)
          localByteArrayOutputStream.write(i);
        this.data = localByteArrayOutputStream.toByteArray();
      }
      catch (IOException localIOException) {
    	  paramInputStream = null;
      }
    }

    ByteArrayDataSource(byte[] paramArrayOfByte, String paramString) {
      this.data = paramArrayOfByte;
      this.type = paramString;
    }

    ByteArrayDataSource(String paramString1, String paramString2)
    {
      try
      {
        this.data = paramString1.getBytes("KSC5601");
      } catch (UnsupportedEncodingException localUnsupportedEncodingException) {
    	  paramString1 = "";
      }
      this.type = paramString2;
    }
  }
}
