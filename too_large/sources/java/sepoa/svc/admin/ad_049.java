package sepoa.svc.admin;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;

import sepoa.fw.log.Logger;

import sepoa.fw.mail.MailSendHistory;
import sepoa.fw.mail.MailSendVo;
import sepoa.fw.mail.SimpleMailSend;
import sepoa.fw.msg.Message;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

import java.util.ArrayList;

import sepoa.fw.sms.SendSms;
import sepoa.fw.sms.SmsSendVo;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

public class AD_049 extends SepoaService
{
	private String ID = info.getSession("ID");

	public AD_049(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}

	public String getConfig(String s)
	{
		try
		{
			Configuration configuration = new Configuration();
			s = configuration.get(s);

			return s;
		}
		catch (ConfigurationException configurationexception)
		{
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception)
		{
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}

		return null;
	}

	public SepoaOut searchSelerPiclList(String vendor_code, String user_type, String user_name )
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_searchSelerPiclList(vendor_code, user_type, user_name );

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] et_searchSelerPiclList(String vendor_code, String user_type, String user_name ) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" select  \n ");
			sb.append("   ssupi.seller_code, \n ");
//			sb.append("   getCompanyNameLoc(ssupi.seller_code, 'S') as seller_name, \n ");
			sb.append("   ICOMVNGL.vendor_name_loc seller_name, \n ");
			sb.append("   ssupi.user_name, \n ");
			sb.append("   ssupi.mobile_no, \n ");
			sb.append("   ssupi.email, \n ");
			sb.append("   ssupi.sales_top_pic_flag, \n ");
			sb.append("   ssupi.sales_pic_flag, \n ");
			sb.append("   ssupi.pp_pic_flag, \n ");
			sb.append("   ssupi.foreign_pic_flag, \n ");
			sb.append("   ssupi.qm_pic_flag, \n ");
			sb.append("   ssupi.tax_pic_flag, \n ");
			sb.append("   ssupi.other_pic_text \n ");
			sb.append(" from ssupi, ICOMVNGL \n ");
			sb.append(" where " + DB_NULL_FUNCTION + "(ssupi.del_flag, 'N') = 'N' \n ");
			sb.append("   and " + DB_NULL_FUNCTION + "(ICOMVNGL.del_flag, 'N') = 'N' \n ");
			sb.append(sm.addSelectString(" and upper(ssupi.seller_code) = upper(?) \n "));
			sm.addStringParameter(vendor_code);

			sb.append("   and ssupi.seller_code = ICOMVNGL.vendor_code \n ");
			sb.append("   and ICOMVNGL.sign_status = 'E' \n ");

			sb.append(sm.addFixString("   and ssupi.company_code = ? \n ")); sm.addStringParameter(info.getSession("COMPANY_CODE"));

			if(user_name.length()>0){
				String like_sql = "%"+user_name+"%";
				sb.append("  and upper(ssupi.user_name) like upper('"+like_sql+"')  \n ");
			}
			if(user_type.equals("1"))
			{
				sb.append(" and ssupi.sales_top_pic_flag = 'Y' \n ");
			}
			else if(user_type.equals("2"))
			{
				sb.append(" and ssupi.sales_pic_flag = 'Y' \n ");
			}
			else if(user_type.equals("3"))
			{
				sb.append(" and ssupi.pp_pic_flag = 'Y' \n ");
			}
			else if(user_type.equals("4"))
			{
				sb.append(" and ssupi.foreign_pic_flag = 'Y' \n ");
			}
			else if(user_type.equals("5"))
			{
				sb.append(" and ssupi.qm_pic_flag = 'Y' \n ");
			}
			else if(user_type.equals("6"))
			{
				sb.append(" and ssupi.tax_pic_flag = 'Y' \n ");
			}
			sb.append(" order by ssupi.seller_code, ssupi.user_name  \n ");
			Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

			rtn[0] = sm.doSelect(sb.toString());
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	}

	public SepoaOut getSenderPhoneNO(SepoaInfo info )
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getSenderPhoneNO(info );

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] et_getSenderPhoneNO(SepoaInfo info ) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" select  \n ");
			sb.append("   icomaddr.phone_no2 \n ");
			sb.append(" from icomaddr \n ");
			sb.append(" where  \n ");
			sb.append(sm.addSelectString(" code_no = ? \n "));
			sm.addStringParameter(info.getSession("ID"));
			sb.append("  and code_type = '3'  \n ");

			Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

			rtn[0] = sm.doSelect(sb.toString());
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	}

	public SepoaOut sendSms(String[][] bean_args , String content , String senderPhoneno)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_sendSms(bean_args,content,senderPhoneno);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] et_sendSms(String[][] bean_info,String content,String senderPhoneno) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();

		SendSms msh = new SendSms();
		ArrayList arList = new ArrayList();

		try
		{
			String user_name;
			String mobile_no;
			String seller_code;

			for (int i = 0; i < bean_info.length; i++)
			{
				user_name = bean_info[i][0];
				mobile_no = bean_info[i][1];
				seller_code = bean_info[i][2];

				if(mobile_no.length() > 0)
				{
					SmsSendVo vo = new SmsSendVo();
					Logger.debug.println(info.getSession("ID"), this, "Send Sms to " + mobile_no);

					vo.setMessage(content);
					vo.setRecv_user_name(user_name);
					vo.setRecv_user_phone_no(mobile_no);
					vo.setRef_module("SMS");
					vo.setRef_no("0123456789");
					vo.setSeller_code(seller_code);
					vo.setSend_user_id(info.getSession("ID"));
					vo.setSend_user_name(info.getSession("NAME_LOC"));
					vo.setSend_user_phone_no(senderPhoneno);

					arList.add(vo);
				}
			}

			msh.setSmsData(arList);
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //

	public SepoaOut sendMail(String[][] bean_args, String subject, String content)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_sendMail(bean_args, subject, content);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] et_sendMail(String[][] bean_info, String subject, String content) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		Vector v = new Vector();
        Vector v2 = new Vector();
    	ArrayList arList = new ArrayList();
    	MailSendHistory msh = new MailSendHistory();
    	MailSendVo vo = new MailSendVo();

		try
		{
			String user_name = "";
			String email = "";
			String seller_code = "";

			for (int i = 0; i < bean_info.length; i++)
			{
				user_name = bean_info[i][0];
				email = bean_info[i][1];
				seller_code = bean_info[i][2];

				if(email.length() > 0)
				{
			    	v.addElement(JSPUtil.nullChk(email));
			    	v2.addElement(JSPUtil.nullChk(user_name));
				}
			}

			if(v.size() > 0)
			{
				try
				{
			    	//Get Html Contents
	            	SimpleMailSend simple = new SimpleMailSend();
	            	String contents =  simple.getSimpleMailHTML(subject, SepoaString.nToBr(content));

	            	vo.setContents(contents);
	            	vo.setDoc_no("MAIL_SEND");
	            	vo.setDoc_type("MAIL");
	            	vo.setM_to_values(v);
	            	vo.setM_to_name_values(v2);
	            	vo.setSender_addr(info.getSession("EMAIL"));
	            	vo.setSender_id(info.getSession("ID"));
	            	vo.setSender_name(info.getSession("NAME_LOC"));
	            	vo.setSubject(subject);
	            	vo.setAttachmentList(arList);
					msh.setMailSendHistory(vo);
				}
				catch(Exception e)
				{
					
					Logger.debug.println(info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName()+" ERROR : " + e + "\n" + SepoaString.getStackTrace(e));
					
					throw new Exception(e.getMessage());
				}
			}
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //

}