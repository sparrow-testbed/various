package sepoa.svc.admin;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class AD_052 extends SepoaService
{
	private String ID = info.getSession("ID");

	public AD_052(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut searchSendSmsHistory(String from_date, String to_date,
											String seller_code, String send_recv,String sms_send, String message_recv)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_searchSendSmsHistory(from_date, to_date,seller_code,send_recv,sms_send,message_recv);

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

	private String[] et_searchSendSmsHistory(String from_date, String to_date,
											String seller_code, String send_recv, String sms_send, String message_recv) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");
		String company_code = info.getSession("COMPANY_CODE");
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" select 										 											\n ");
			sb.append("   	getDateFormat(ssmsh.send_date)   	send_date,										\n ");
			sb.append("   	getTimeFormat(ssmsh.send_time)		send_time,										\n ");
			sb.append("   	SEND_USER_NAME, 			SEND_USER_PHONE_NO,	 		RECV_USER_NAME,				\n ");
			sb.append("   	RECV_USER_PHONE_NO, 		SELLER_CODE,	 			getVendorName(seller_code) seller_name,		\n ");
			sb.append("   	MESSAGE AS content, 					SEND_USER_ID,	 			REF_NO,						\n ");
			sb.append("   	REF_MODULE, send_complete_code														\n ");
			sb.append(" from 																					\n ");
			sb.append("  	ssmsh																		\n ");
			sb.append(" where 1 = 1																				\n ");
			sb.append(sm.addSelectString(" and ssmsh.send_date  >= ? 											\n "));
			sm.addStringParameter(from_date);
			sb.append(sm.addSelectString(" and ssmsh.send_date <= ? 											\n "));
			sm.addStringParameter(to_date);
			sb.append(sm.addSelectString(" and ssmsh.seller_code = ? 											\n "));
			sm.addStringParameter(seller_code);
			String like_sql="";
			if(sms_send.length() > 0){
				like_sql="%"+sms_send+"%";
			}
			sb.append(sm.addSelectString(" and "+DB_NULL_FUNCTION+"("+send_recv+",'') like    ?  							\n "));
			sm.addStringParameter(like_sql);
			sb.append(sm.addSelectString(" and message = ? 																	\n "));
			sm.addStringParameter(message_recv);
			sb.append(" order by ssmsh.send_date desc, ssmsh.send_time desc									 				\n ");
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
}
