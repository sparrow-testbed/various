package sepoa.svc.admin;

import java.util.Vector;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;

import sepoa.fw.log.Logger;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class AD_051 extends SepoaService
{
	private String ID = info.getSession("ID");

	public AD_051(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut getMailSendHistoryList(String start_sign_date, String end_sign_date, String mail_send_no, String mail_send_search, String mail_send_search_word)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getMailSendHistoryList(info, start_sign_date, end_sign_date, mail_send_no, mail_send_search, mail_send_search_word);

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
	} // end getMailSendHistoryList()

	private String[] et_getMailSendHistoryList(SepoaInfo info, String start_sign_date, String end_sign_date, String mail_send_no, String mail_send_search, String mail_send_search_word) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" SELECT	\n ");
			sb.append("   mail_send_no, \n ");
			if(SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				sb.append("   concat(" + SEPOA_DB_OWNER + "getDateFormat(MAIL_SEND_DATE), ' ', " + SEPOA_DB_OWNER + "getTimeFormat(MAIL_SEND_TIME)) mail_send_date, \n ");
			}
			else if(SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(MAIL_SEND_DATE) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(MAIL_SEND_TIME) mail_send_date, \n ");
			}
			else if(SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(MAIL_SEND_DATE) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(MAIL_SEND_TIME) mail_send_date, \n ");
																												  //select to_char(sysdate, 'HH:MI:SS' ) from dual
			}
			sb.append("   mail_send_name, \n ");
			sb.append("   send_email, \n ");
			sb.append("   mail_send_id, \n ");
			sb.append("   mail_recv_name, \n ");
			sb.append("   receipt_email, \n ");
			sb.append("   mail_send_ref_no, \n ");
			sb.append("   mail_send_type, \n ");
			sb.append("   case when " + DB_NULL_FUNCTION + "(mail_send_status, 'N') in ('C', 'Y') then 'Yes' else 'No' end mail_send_status, ");
			sb.append("   seq \n ");
			sb.append(" FROM SMAHI \n ");
			sb.append(" WHERE ");

			sb.append(sm.addFixString(" UPPER(mail_send_date) BETWEEN ?")); sm.addStringParameter(start_sign_date);
			sb.append(sm.addFixString(" AND ?  \n ")); sm.addStringParameter(end_sign_date);


			if(SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				sb.append(sm.addSelectString(" AND (UPPER(mail_send_no) LIKE UPPER('%'||  ?  || '%'))  \n "));
			}
			else if(SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				sb.append(sm.addSelectString(" AND (UPPER(mail_send_no) LIKE UPPER('%'  ? '%'))  \n "));
			}
			else if(SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				sb.append(sm.addSelectString(" AND (UPPER(mail_send_no) LIKE UPPER('%' + ? + '%'))  \n "));
			}
			sm.addStringParameter(mail_send_no);

			if(SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				sb.append(sm.addSelectString(" AND (UPPER("+ mail_send_search +") LIKE UPPER('%'||  ?  || '%'))  \n "));
			}
			else if(SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				sb.append(sm.addSelectString(" AND (UPPER("+ mail_send_search +") LIKE UPPER('%'  ? '%'))  \n "));
			}
			else if(SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				sb.append(sm.addSelectString(" AND (UPPER("+ mail_send_search +") LIKE UPPER('%' + ? + '%'))  \n "));
			}
			sm.addStringParameter(mail_send_search_word);

			sb.append(" ORDER BY MAIL_SEND_DATE DESC,MAIL_SEND_time,  seq \n ");
			Logger.debug.println(info.getSession("ID"), this, "getMailSendHistoryList= \n" + sb.toString());

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
	} // end et_getMailSendHistoryList()

	public SepoaOut getMailSendHistoryText(String mail_send_no) throws Exception
    {
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getMailSendHistoryText(info, mail_send_no);

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
    } //end getMailSendHistoryText()

	private String[] et_getMailSendHistoryText(SepoaInfo info, String mail_send_no) throws Exception
    {
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" SELECT mail_text FROM smahc \n ");
			sb.append(sm.addFixString(" WHERE UPPER(mail_send_no) = UPPER(?) \n"));
			sm.addStringParameter(mail_send_no);
			sb.append(" ORDER BY seq  \n ");
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
    } //end et_getMailSendHistoryText()

} // end class