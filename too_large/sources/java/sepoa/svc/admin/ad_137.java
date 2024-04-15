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

public class AD_137 extends SepoaService
{
	private String ID = info.getSession("ID");

	public AD_137(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}

	public SepoaOut getInterfaceInfoDetail(String if_number)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getInterfaceInfoGeneral(if_number);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);

			rtn = et_getInterfaceInfoParameter(if_number);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);

			rtn = et_getInterfaceInfoTableName(if_number);

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

	private String[] et_getInterfaceInfoTableName(String if_number) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append("	SELECT \n ");
			sb.append("    table_name, if_type, count(distinct row_number) row_number \n ");
			sb.append(" from sifld \n ");
			sb.append(" where 1 = 1 \n ");
			sb.append(sm.addSelectString("   and if_number = ? \n ")); sm.addStringParameter(if_number);
			sb.append(" group by table_name, if_type order by table_name, if_type desc \n ");
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
	} //

	public SepoaOut getInterfaceInfoColumnName(String if_number, String table_name, String if_type)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getInterfaceInfoColumnName(if_number, table_name, if_type);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);

			rtn = et_getInterfaceInfoColumnData2(if_number, table_name, if_type);

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

	private String[] et_getInterfaceInfoColumnName(String if_number, String table_name, String if_type) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append("	SELECT DISTINCT COLUMN_NAME \n ");
			sb.append(" from sifld \n ");
			sb.append(" where 1 = 1 \n ");
			sb.append(sm.addSelectString("   and if_number = ? \n ")); sm.addStringParameter(if_number);
			sb.append(sm.addSelectString("   and table_name = ? \n ")); sm.addStringParameter(table_name);
			sb.append(sm.addSelectString("   and if_type = ? \n ")); sm.addStringParameter(if_type);
			sb.append(" order by column_name \n ");
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
	} //

	private String[] et_getInterfaceInfoColumnData2(String if_number, String table_name, String if_type) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append("	SELECT row_number, column_name, data_value \n ");
			sb.append(" from sifld \n ");
			sb.append(" where 1 = 1 \n ");
			sb.append(sm.addSelectString("   and if_number = ? \n ")); sm.addStringParameter(if_number);
			sb.append(sm.addSelectString("   and table_name = ? \n ")); sm.addStringParameter(table_name);
			sb.append(sm.addSelectString("   and if_type = ? \n ")); sm.addStringParameter(if_type);
			sb.append(" order by row_number, column_name \n ");
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
	} //

	public SepoaOut getInterfaceInfoColumnData(String if_number, String table_name, String if_type, String row_number)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getInterfaceInfoColumnData(if_number, table_name, if_type, row_number);

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

	private String[] et_getInterfaceInfoColumnData(String if_number, String table_name, String if_type, String row_number) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" select \n ");
			sb.append(" 	a.column_name \n ");

			for(int i = 0; i < Integer.parseInt(row_number); i++)
			{
				sb.append("     , t" + i + ".data_value \n ");
			}

			sb.append(" from \n ");
			sb.append(" ( \n ");
			sb.append(" 	select DISTINCT COLUMN_NAME \n ");
			sb.append(" 	from sifld \n ");
			sb.append(sm.addFixString(" 	WHERE IF_NUMBER = ? \n ")); sm.addStringParameter(if_number);
			sb.append(sm.addFixString(" 	  and table_name = ? \n ")); sm.addStringParameter(table_name);
			sb.append(sm.addFixString(" 	  and if_type = ? \n ")); sm.addStringParameter(if_type);
			sb.append(" 	order by column_name \n ");
			sb.append(" ) a, \n ");

			for(int i = 0; i < Integer.parseInt(row_number); i++)
			{
				if( i > 0 )
				{
					sb.append(" , ");
				}

				sb.append(" ( \n ");
				sb.append(" 	select row_number, column_name, data_value \n ");
				sb.append(" 	from sifld \n ");
				sb.append(sm.addFixString(" 	WHERE IF_NUMBER = ? \n ")); sm.addStringParameter(if_number);
				sb.append(sm.addFixString(" 	  and table_name = ? \n ")); sm.addStringParameter(table_name);
				sb.append(sm.addFixString(" 	  and if_type = ? \n ")); sm.addStringParameter(if_type);
				sb.append(sm.addFixString(" 	  and row_number = ? \n ")); sm.addStringParameter(String.valueOf(i));
				sb.append(" 	order by row_number, column_name \n ");
				sb.append(" ) t" + i + " \n ");
			}

			sb.append(" where 1 = 1 \n ");

			for(int i = 0; i < Integer.parseInt(row_number); i++)
			{
				sb.append(" and a.column_name = t" + i + ".column_name \n ");
			}

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
	} //

	private String[] et_getInterfaceInfoParameter(String if_number) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append("	SELECT \n ");
			sb.append(" * \n ");
			sb.append(" from siflp \n ");
			sb.append(" where 1 = 1 \n ");
			sb.append(sm.addSelectString("   and if_number = ? \n ")); sm.addStringParameter(if_number);
			sb.append(" order by if_seq \n ");
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
	} //

	private String[] et_getInterfaceInfoGeneral(String if_number) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append("	SELECT \n ");
			sb.append(" * \n ");
			sb.append(" from siflm \n ");
			sb.append(" where 1 = 1 \n ");
			sb.append(sm.addSelectString("   and if_number = ? \n ")); sm.addStringParameter(if_number);
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
	} //

	public SepoaOut getInterfaceLogList(SepoaInfo info, String from_date, String to_date, String rfc_name, String user_name)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getInterfaceLogList(info, from_date, to_date, rfc_name, user_name);

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

	private String[] et_getInterfaceLogList(SepoaInfo info, String from_date, String to_date, String rfc_name, String user_name) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			String like_rfc_name = "";
			String like_user_name = "";

			if(rfc_name.length() > 0)
			{
				like_rfc_name = "%" + rfc_name + "%";
			}

			if(user_name.length() > 0)
			{
				like_user_name = "%" + user_name + "%";
			}

			sb.append(" select a.*, \n ");
			sb.append(" " + DB_NULL_FUNCTION + "((select max(ifld.row_number) + 1 from sifld ifld where ifld.if_number = a.if_number), 0) data_rows \n ");
			sb.append(" from ( \n ");
			sb.append("	SELECT \n ");
			sb.append(" * \n ");
			sb.append(" from siflm \n ");
			sb.append(" where 1 = 1 \n ");
			sb.append(sm.addSelectString("   and if_date >= ? \n ")); sm.addStringParameter(from_date);
			sb.append(sm.addSelectString("   and if_date <= ? \n ")); sm.addStringParameter(to_date);
			sb.append(sm.addSelectString("   and upper(rfc_name) like ? \n ")); sm.addStringParameter(like_rfc_name);
			sb.append(sm.addSelectString("   and upper(if_user_name_loc) like ? \n ")); sm.addStringParameter(like_user_name);
			sb.append("  ORDER BY if_date || if_time DESC, if_number desc  \n");
			sb.append(" ) a \n ");
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
	} //
}
