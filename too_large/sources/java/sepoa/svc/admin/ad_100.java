package sepoa.svc.admin;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaRemote;

public class AD_100 extends SepoaService
{
	//Message msg = new Message("STDCOMM"); // message 처리를 위해 전역변수 선언
	Message msg = null;

	public AD_100(String s, SepoaInfo sepoainfo) throws SepoaServiceException
	{
		super(s, sepoainfo);
		msg = new Message(sepoainfo, "STDCOMM");
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
		catch (ConfigurationException cfe)
		{
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
		}

		return null;
	}

	public SepoaOut FindDNMT(String i_change_user_id)
	{
		try
		{
			String rtn = et_FindDNMT(i_change_user_id);
			setMessage(msg.getMessage("0000"));
			setValue(rtn);
			setStatus(1);
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	public String et_FindDNMT(String i_change_user_id) throws Exception
	{
		String rtn = null;

		try
		{
			String user_id = info.getSession("ID");

			ConnectionContext ctx = getConnectionContext();

			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT   DOC_TYPE																\n");
			sql.append(" 		, DESCRIPTION                                                           \n");
			sql.append(" 		, " + SEPOA_DB_OWNER + "GETUSERNAME(" + DB_NULL_FUNCTION + "(CHANGE_USER_ID, ADD_USER_ID), '"+ info.getSession("HOUSE_CODE") + "' ,'" + info.getSession("LANGUAGE") + "' ) AS CHANGE_USER_NAME_LOC  \n");
			sql.append(" 		, CHANGE_DATE                                                           \n");
			sql.append(" 		, 'Y' AS FLAG				                                            \n");
			sql.append(" FROM SDCGL                                                                  \n");
			sql.append(" WHERE  " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') = 'N'                                          \n");
			sql.append(" <OPT=S,S>AND CHANGE_USER_ID = ?  </OPT>                                       \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			String[] args = { i_change_user_id };
			rtn = sm.doSelect(args);
		}
		catch (Exception e)
		{
			throw new Exception("et_FindDNMT:" + e.getMessage());
		}

		return rtn;
	}

	public SepoaOut CreateDNMT(String[][] setData)
	{
		try
		{
			int rtn = et_CreateDNMT(setData);
			setMessage(msg.getMessage("0000"));
			setValue("DNMT Create:" + rtn);
			setStatus(1);
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private int et_CreateDNMT(String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String user_name_loc = info.getSession("NAME_LOC");
			String user_name_eng = info.getSession("NAME_ENG");
			String user_dept = info.getSession("DEPARTMENT");
			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			StringBuffer tSQL = new StringBuffer();

			tSQL.append(" INSERT INTO SDCGL                                                                                                      \n");
			tSQL.append(" (                                                                                                                         \n");
			tSQL.append("     DOC_TYPE, DESCRIPTION, DEL_FLAG,                                                               \n");
			tSQL.append("     ADD_DATE, ADD_TIME, CHANGE_DATE, CHANGE_TIME, ADD_USER_ID                                                            \n");
			tSQL.append(" )                                                                                                                         \n");
			tSQL.append(" VALUES                                                                                                                    \n");
			tSQL.append(" (                                                                                                                         \n");
			tSQL.append("     ?, ?,  'N',                                                                                   \n");
			tSQL.append("     '" + cur_date + "', '" + cur_time + "', '" + cur_date + "', '" + cur_time + "', '" + user_id + "'                    \n");
			tSQL.append(" )                                                                                                                         \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			String[] type = { "S", "S" };
			rtn = sm.doInsert(setData, type);
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			throw new Exception("et_CreateDNMT:" + e.getMessage());
		}

		return rtn;
	}

	public SepoaOut RemoveDNMT(String[][] setData)
	{
		try
		{
			int rtn = et_RemoveDNMT(setData);
			setMessage(msg.getMessage("0014"));
			setValue("DNMT Remove:" + rtn);
			setStatus(1);
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0004"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private int et_RemoveDNMT(String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");

			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" DELETE  FROM  SDCGL                        \n");
			tSQL.append(" WHERE DOC_TYPE    = ?                       \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			String[] type = { "S" };
			rtn = sm.doUpdate(setData, type);

			String nickName = "AD_101";
			String conType = "NONDBJOB";
			String methodName = "setConnectionContext";
			Object[] obj = { ctx };
			String methodName1 = "RemoveAllDNCT";
			Object[] obj1 = { setData };

			SepoaRemote wr = null;
			wr = new SepoaRemote(nickName, conType, super.info);
			wr.lookup(methodName, obj);
			wr.lookup(methodName1, obj1);

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			throw new Exception("et_RemoveDNMT:" + e.getMessage());
		}

		return rtn;
	}
}
