package sepoa.fw.mail;

import java.util.ArrayList;
import java.util.Vector;

import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.HtmlEmail;
import org.apache.commons.mail.MultiPartEmail;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaConnectionResource;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;

public class MailSendHistoryOld {

    /**
     * @param sender_id ������ ��� id
     * @param sender_name ������ ��� �̸�
     * @param sender_addr ������ ��� email �ּ�
     * @param contents ������ ����
     * @param m_to_values �޴� �����.
     * @param doc_type document type
     * @param doc_no document no
     */
    public String setMailSendHistory(String sender_id, String sender_name, String sender_addr, String contents, Vector m_to_values, String doc_type, String doc_no) throws Exception
    {
    	String m_mail_send_no = "";
        SepoaConnectionResource wiseconnectionresource = null;
        int rtnCnt = 0;
        SepoaInfo info = new SepoaInfo("100", "ID=MAIL^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPARTMENT=ALL^@^USER_IP=IP");

        try
        {
            wiseconnectionresource = new SepoaConnectionResource();
            SepoaConnectionResource wiseconnectionresource_1 = wiseconnectionresource;
            SepoaConnectionResource wiseconnectionresource_2 = wiseconnectionresource;
            String recv_mail_addr = "";
            SepoaSQLManager sm = null;
            String mail_send_no = sender_id + "-" + SepoaDate.getTimeStampString();

            for (int i = 0; i < m_to_values.size(); i++)
            {
                recv_mail_addr = (String) m_to_values.elementAt(i);
                String seq = Integer.toString(i + 1);

                StringBuffer stringbuffer = new StringBuffer();
                stringbuffer.append(" INSERT INTO SMAHI              \n");
                stringbuffer.append(" (                                 \n");
                stringbuffer.append("     MAIL_SEND_NO,                 \n");
                stringbuffer.append("     SEND_EMAIL,                   \n");
                stringbuffer.append("     RECEIPT_EMAIL,                \n");
                stringbuffer.append("     SEQ,                          \n");
                stringbuffer.append("     MAIL_SEND_TYPE,               \n");
                stringbuffer.append("     MAIL_SEND_DATE,               \n");
                stringbuffer.append("     MAIL_SEND_TIME,               \n");
                stringbuffer.append("     MAIL_SEND_STATUS,             \n");
                stringbuffer.append("     MAIL_RECV_STATUS,             \n");
                stringbuffer.append("     MAIL_CONFIRM_DATE,            \n");
                stringbuffer.append("     MAIL_CONFIRM_TIME,            \n");
                stringbuffer.append("     MAIL_SEND_REF_NO,             \n");
                stringbuffer.append("     MAIL_RECV_NAME,               \n");
                stringbuffer.append("     MAIL_SEND_NAME,               \n");
                stringbuffer.append("     MAIL_SEND_ID                  \n");
                stringbuffer.append(" )VALUES                           \n");
                stringbuffer.append(" (                                 \n");
                stringbuffer.append("     '" + mail_send_no + "', \n ");
                stringbuffer.append("     '" + sender_addr + "',            \n");
                stringbuffer.append("     '" + recv_mail_addr + "',         \n");
                stringbuffer.append("     '" + seq + "',                    \n");
                stringbuffer.append("     '" + doc_type + "',               \n");
                stringbuffer.append("     '" + SepoaDate.getShortDateString() + "', \n");
                stringbuffer.append("     '" + SepoaDate.getShortTimeString() + "', \n");
                stringbuffer.append("     'C',                          \n");
                stringbuffer.append("     '',                           \n");
                stringbuffer.append("     '',                           \n");
                stringbuffer.append("     '',                           \n");
                stringbuffer.append("     '" + doc_no + "',                 \n");
                stringbuffer.append("     '',                           \n");
                stringbuffer.append("     '" + sender_name + "',            \n");
                stringbuffer.append("     '" + sender_id + "'               \n");
                stringbuffer.append(" )                                 \n");

                SepoaSQLManager wisesqlmanager = new SepoaSQLManager(sender_id, stringbuffer, wiseconnectionresource_1, stringbuffer.toString());
                rtnCnt = wisesqlmanager.doInsert((String[][])null, null);
            } // for end

            Vector v_cut_contents = getSplitString(contents, 500);

            //System.out.println("contents==> " + contents);
            //System.out.println("v_cut_contents.size()==> " + v_cut_contents.size());

            for (int i = 0; i < v_cut_contents.size(); i++)
            {
                String cut_contents = (String) v_cut_contents.elementAt(i);

                //System.out.println("cut_contents===[" + i + "]==> " + cut_contents);

                String seq = Integer.toString(i + 1);

                StringBuffer stringbuffer_2 = new StringBuffer();
                stringbuffer_2.append(" INSERT INTO SMAHC              \n");
                stringbuffer_2.append(" (                                 \n");
                stringbuffer_2.append("     MAIL_SEND_NO,                 \n");
                stringbuffer_2.append("     SEQ,                          \n");
                stringbuffer_2.append("     MAIL_TEXT                     \n");
                stringbuffer_2.append(" )VALUES                           \n");
                stringbuffer_2.append(" (                                 \n");
                stringbuffer_2.append("     ?,                          \n");
                stringbuffer_2.append("     ?,                          \n");
                stringbuffer_2.append("     ?                           \n");
                stringbuffer_2.append(" )                               \n");

                SepoaSQLManager wisesqlmanager = new SepoaSQLManager(sender_id, stringbuffer_2, wiseconnectionresource_2, stringbuffer_2.toString());

                String[] type_mahc = { "S", "S", "S" };
                String[][] MAHC =
                {
                    { mail_send_no, seq, cut_contents }
                };
                rtnCnt = wisesqlmanager.doInsert(MAHC, type_mahc);
            } // for end

            m_mail_send_no = mail_send_no;



			MultiPartEmail email = new MultiPartEmail();


        }
        catch (Exception exception)
        {
        	//exception.printStackTrace();
            Logger.err.println("Exception e =" + exception.getMessage());
            throw new Exception(exception.getMessage());
        }
        finally
        {
        	if (wiseconnectionresource != null) { wiseconnectionresource.release(); }
        }

        return m_mail_send_no;
    }


    public String setMailSendHistory(MailSendVo vo) throws Exception
    {
    	String m_mail_send_no = "";
        SepoaConnectionResource wiseconnectionresource = null;
        int rtnCnt = 0;
        SepoaInfo info = new SepoaInfo("100", "ID=MAIL^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPARTMENT=ALL^@^USER_IP=IP");

        try
        {
            wiseconnectionresource = new SepoaConnectionResource();
            SepoaConnectionResource wiseconnectionresource_1 = wiseconnectionresource;
            SepoaConnectionResource wiseconnectionresource_2 = wiseconnectionresource;
            String recv_mail_addr = "";
            String recv_name = "";

            SepoaSQLManager sm = null;
            String mail_send_no = vo.getSender_id() + "-" + SepoaDate.getTimeStampString();

            //Get Config
            Configuration configuration = new Configuration();
			String send_mail_address = configuration.get("sepoa.send.mail.id");
			String smtp_server = configuration.get("sepoa.smtp.server");
			String encoding_set = configuration.get("sepoa.smtp.encoding.set");
			String authentication_flag = configuration.get("sepoa.smtp.authentication.flag");
			String smtp_user_id = configuration.get("sepoa.smtp.user_id");
			String smtp_password = configuration.get("sepoa.smtp.password");
			String send_mail_user_name = configuration.get("sepoa.send.mail.user.name");
			boolean smtp_send_flag = configuration.getBoolean("sepoa.smtp.send.flag");

			//Get Vo Attribute
            Vector  m_to_values = vo.getM_to_values();
            Vector  m_to_name_values = vo.getM_to_name_values();

            ArrayList  attachmentList =	vo.getAttachmentList();
            String _sender_email = "";
            String _sender_name = "";

            //Set Send Mail
            HtmlEmail  email = new HtmlEmail ();
            email.setHostName(smtp_server);
			email.setCharset(encoding_set);

			if("".equals(JSPUtil.nullChk(vo.getSender_addr())) || JSPUtil.nullChk(vo.getSender_addr()).indexOf("@") <= 0
					 || JSPUtil.nullChk(vo.getSender_addr()).indexOf(".") <= 0)
			{
				email.setFrom(send_mail_address, send_mail_user_name);
				_sender_email = send_mail_address;
				_sender_name = send_mail_user_name;
			}
			else
			{
				String domain = vo.getSender_addr().substring( vo.getSender_addr().indexOf("@") + 1 , vo.getSender_addr().length() );
				String cmd = "";

				if(domain.trim().length() > 0)
				{
					try
					{
						cmd = sepoa.fw.util.RunCommand.runCommand("nslookup -type=MX " + domain);
						if (cmd.indexOf("mail exchanger") != -1 )
						{
					        
							email.setFrom(vo.getSender_addr(), vo.getSender_name());
							_sender_email = vo.getSender_addr();
							_sender_name = vo.getSender_name();
						}
						else
						{
					        
					        Logger.debug.println(new Exception().getStackTrace()[0].getClassName(), this, "Mail Domain Error. Not found Domain Name in internet. --> " + domain);

					        email.setFrom(send_mail_address, send_mail_user_name);
							_sender_email = send_mail_address;
							_sender_name = send_mail_user_name;
						}
					}
					catch (Exception e)
					{
						//e.printStackTrace();
						Logger.debug.println(info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName()+" ERROR : " + e);
						
						email.setFrom(send_mail_address, send_mail_user_name);
						_sender_email = send_mail_address;
						_sender_name = send_mail_user_name;
					}
				}
				else
				{
					email.setFrom(send_mail_address, send_mail_user_name);
					_sender_email = send_mail_address;
					_sender_name = send_mail_user_name;
				}
			}

			email.setSubject(vo.getSubject());
			email.setAuthentication(smtp_user_id, smtp_password);
			email.setHtmlMsg(vo.getContents());
			ParamSql pm = new ParamSql(info.getSession("ID"), this, wiseconnectionresource_1);
			StringBuffer stringbuffer = new StringBuffer();
			int sended_mail_flag = 0;

            for (int i = 0; i < m_to_values.size(); i++)
            {
            	boolean check_mail_id_flag = true;
            	recv_mail_addr = (String) m_to_values.elementAt(i);
                recv_name = (String) m_to_name_values.elementAt(i);
                String seq = Integer.toString(i + 1);

                if("".equals(recv_mail_addr))
            	{
                	check_mail_id_flag = false;
                	continue;
            	}

                if(recv_mail_addr.indexOf(".") < 0)
            	{
                	check_mail_id_flag = false;
            	}

                if(recv_mail_addr.indexOf("@") < 0)
            	{
                	check_mail_id_flag = false;
            	}

                if("".equals(_sender_email))
            	{
                	check_mail_id_flag = false;
            	}

                if(_sender_email.indexOf(".") < 0)
            	{
                	check_mail_id_flag = false;
            	}

                if(_sender_email.indexOf("@") < 0)
            	{
                	check_mail_id_flag = false;
            	}

                if(check_mail_id_flag)
                {
                	sended_mail_flag++;
                }

                stringbuffer.delete(0, stringbuffer.length());
                pm.removeAllValue();
                stringbuffer.append(" INSERT INTO SMAHI              \n");
                stringbuffer.append(" (                                 \n");
                stringbuffer.append("     MAIL_SEND_NO,                 \n");
                stringbuffer.append("     SEND_EMAIL,                   \n");
                stringbuffer.append("     RECEIPT_EMAIL,                \n");
                stringbuffer.append("     SEQ,                          \n");
                stringbuffer.append("     MAIL_SEND_TYPE,               \n");
                stringbuffer.append("     MAIL_SEND_DATE,               \n");
                stringbuffer.append("     MAIL_SEND_TIME,               \n");
                stringbuffer.append("     MAIL_SEND_STATUS,             \n");
                stringbuffer.append("     MAIL_RECV_STATUS,             \n");
                stringbuffer.append("     MAIL_CONFIRM_DATE,            \n");
                stringbuffer.append("     MAIL_CONFIRM_TIME,            \n");
                stringbuffer.append("     MAIL_SEND_REF_NO,             \n");
                stringbuffer.append("     MAIL_RECV_NAME,               \n");
                stringbuffer.append("     MAIL_SEND_NAME,               \n");
                stringbuffer.append("     MAIL_SEND_ID                  \n");
                stringbuffer.append(" )VALUES                           \n");
                stringbuffer.append(" (                                 \n");
                stringbuffer.append("     ?, \n "); pm.addStringParameter(mail_send_no);
                stringbuffer.append("     ?, \n"); pm.addStringParameter(_sender_email);
                stringbuffer.append("     ?, \n"); pm.addStringParameter(recv_mail_addr);
                stringbuffer.append("     ?, \n"); pm.addNumberParameter(seq);
                stringbuffer.append("     ?, \n"); pm.addStringParameter(vo.getDoc_type());
                stringbuffer.append("     ?, \n"); pm.addStringParameter(SepoaDate.getShortDateString());
                stringbuffer.append("     ?, \n"); pm.addStringParameter(SepoaDate.getShortTimeString());
                stringbuffer.append("     ?, \n");

                if(smtp_send_flag && check_mail_id_flag)
                {
                	pm.addStringParameter("Y");
                }
                else
                {
                	pm.addStringParameter("N");
                }

                stringbuffer.append("     '', \n");
                stringbuffer.append("     '', \n");
                stringbuffer.append("     '', \n");
                stringbuffer.append("     ?, \n"); pm.addStringParameter(vo.getDoc_no());
                stringbuffer.append("     ?, \n"); pm.addStringParameter(recv_name);
                stringbuffer.append("     ?, \n"); pm.addStringParameter(_sender_name);
                stringbuffer.append("     ?  \n"); pm.addStringParameter(vo.getSender_id());
                stringbuffer.append(" )  \n");
//                rtnCnt = pm.doInsert(stringbuffer.toString()); // tytolee 임시 주석

                if(check_mail_id_flag)
                {
                	email.addTo(recv_mail_addr, recv_name);
                }
//                SepoaSQLManager wisesqlmanager = new SepoaSQLManager(vo.getSender_id(), stringbuffer, wiseconnectionresource_1, stringbuffer.toString());
//                rtnCnt = wisesqlmanager.doInsert(null, null);
            } // for end

            Vector v_cut_contents = getSplitString(vo.getContents(), 500);

            //System.out.println("contents==> " + contents);
            //System.out.println("v_cut_contents.size()==> " + v_cut_contents.size());

            if(sended_mail_flag > 0)
            {
	            for (int i = 0; i < v_cut_contents.size(); i++)
	            {
	                String cut_contents = (String) v_cut_contents.elementAt(i);

	                //System.out.println("cut_contents===[" + i + "]==> " + cut_contents);

	                String seq = Integer.toString(i + 1);

	                StringBuffer stringbuffer_2 = new StringBuffer();
	                stringbuffer_2.append(" INSERT INTO SMAHC              \n");
	                stringbuffer_2.append(" (                                 \n");
	                stringbuffer_2.append("     MAIL_SEND_NO,                 \n");
	                stringbuffer_2.append("     SEQ,                          \n");
	                stringbuffer_2.append("     MAIL_TEXT                     \n");
	                stringbuffer_2.append(" )VALUES                           \n");
	                stringbuffer_2.append(" (                                 \n");
	                stringbuffer_2.append("     ?,                          \n");
	                stringbuffer_2.append("     ?,                          \n");
	                stringbuffer_2.append("     ?                           \n");
	                stringbuffer_2.append(" )                               \n");

	                SepoaSQLManager wisesqlmanager = new SepoaSQLManager(vo.getSender_id(), stringbuffer_2, wiseconnectionresource_2, stringbuffer_2.toString());

	                String[] type_mahc = { "S", "S", "S" };
	                String[][] MAHC =
	                {
	                    { mail_send_no, seq, cut_contents }
	                };
//	                rtnCnt = wisesqlmanager.doInsert(MAHC, type_mahc); // tytolee 임시주석
	            } // for end
            }

            m_mail_send_no = mail_send_no;

            for (int i = 0; i < attachmentList.size(); i++)
            {
            	EmailAttachment attachment = new EmailAttachment();
            	EmailAttachmentVo attachVo = new EmailAttachmentVo();
            	attachVo = (EmailAttachmentVo)attachmentList.get( i );

            	attachment.setPath(attachVo.getPath());
    			attachment.setDisposition(EmailAttachment.ATTACHMENT);
    			attachment.setDescription(attachVo.getDescription());
    			attachment.setName(attachVo.getName());

    			email.attach(attachment);
            }

            /**
             * 2008.10.15 �̴��
             * properties �� ���� ��ۿ��� �߰�
             * sepoa.smtp.send.flag
             * ���� true �� ��쿡�� email �����.
             */
            if(sended_mail_flag > 0 && smtp_send_flag)
            {
            	email.send();
            }
        }
        catch (Exception exception)
        {
        	
        	//exception.printStackTrace();
            Logger.err.println("Exception e =" + exception.getMessage());
            throw new Exception(exception.getMessage());
        }
        finally
        {
        	if (wiseconnectionresource != null) { wiseconnectionresource.release(); }
        }

        return m_mail_send_no;
    }


    private Vector getSplitString(String t1, int length)
    {
        Vector rt = new Vector();
        String ui = t1;

        int le = getLengthb(ui);

        while (le > 0)
        {
            rt.addElement(getSubString(ui, 0, length));
            ui = getSubString(ui, length, le);
            le = getLengthb(ui);
        }

        return rt;
    }

    public int getLengthb(String str)
    {
        int rSize = 0;
        int len = 0;
        int ll = 0;

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }
        }

        return len;
    }

    private String getSubString(String str, int start, int end)
    {
        int rSize = 0;
        int len = 0;

        int ll = 0;
        StringBuffer ss = new StringBuffer();

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }

            if ((len > start) && (len <= end))
            {
                ss.append(str.charAt(rSize));
            }
        }

        return ss.toString();
    }
}
