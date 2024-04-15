package sepoa.svc.admin;

import java.rmi.RemoteException;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

public class TS_202 extends SepoaService
{
	public TS_202(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut getData(String address) throws RemoteException
	{
		ConnectionContext ctx = getConnectionContext();

		try
		{
			String rtn = null;


			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			rtn = et_getData(sm, address);
			setValue(rtn);
			setStatus(1);
			Commit();
		}
		catch (sepoa.fw.srv.SepoaServiceException e)
		{
		    
			printDebug(info, "Exception e =" + e.toString());

			SepoaOut woEx = new SepoaOut();
			woEx.status = 0;
			woEx.message = e.toString();

			return woEx;
		}
		catch (Exception e)
		{
			try
			{
				Rollback();
			}
			catch (Exception et)
			{
				printDebug(info, "Exception e =" + et.toString());
			}
			printDebug(info, "Exception e =" + e.toString());
			SepoaOut woEx = new SepoaOut();
			woEx.status = 0;
			woEx.message = e.toString();

			return woEx;
		}
		finally
		{
			Release();
		}

		return getSepoaOut();
	}

	private String et_getData(ParamSql sm, String address) throws Exception
	{
		String rtn = null;

		StringBuffer tSQL = new StringBuffer();
		sm.removeAllValue();
		tSQL.append("	select num, name, age		\n ");
		tSQL.append("	from						\n ");
		tSQL.append("	(							\n ");
		tSQL.append("		select 'no1' as num, '홍길동' as name, '20' as age, 'SEOUL' as address from dual union all		\n ");
		tSQL.append("		select 'no2' as num, '박찬호' as name, '30' as age, 'SEOUL' as address from dual union all		\n ");
		tSQL.append("		select 'no3' as num, '박지성' as name, '40' as age, 'SEOUL' as address from dual union all		\n ");
		tSQL.append("		select 'no4' as num, '차범근' as name, '50' as age, 'DAEJEON' as address from dual union all		\n ");
		tSQL.append("		select 'no5' as num, '박주영' as name, '60' as age, 'ANYANG' as address from dual 				\n ");
		tSQL.append("	)																									\n ");
		tSQL.append("	where 1=1																							\n ");
		tSQL.append(sm.addFixString("	and address = ?			\n "));sm.addStringParameter(address);
		tSQL.append("	order by name																						\n ");
		
		rtn = sm.doSelect(tSQL.toString());

		return rtn;
	}

	/**
	 * Refactoring - Extract Method.
	 * */
	private void printDebug(SepoaInfo wi, String rtn)
	{
		Logger.debug.println(wi.getSession("ID"), this, "####" + rtn);
	}
}
