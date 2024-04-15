package sepoa.svc.admin;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;

import sepoa.fw.log.Logger;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

import java.rmi.RemoteException;

public class AD_022 extends SepoaService
{
	public AD_022(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}

	/*
	 *        2007.03.07 프로파일관리(팝업)
	 */
	public SepoaOut getProfilePopQuery(SepoaInfo info, String menu_profile_code) throws Exception
	{
		String[] rtn = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			rtn = et_getProfilePopQuery(info, menu_profile_code);

			if (rtn[1] != null)
			{
				setFlag(false);
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "getProfilePopQuery_________ " + rtn[1]);
				setStatus(1);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	public String[] et_getProfilePopQuery(SepoaInfo info, String menu_profile_code) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		try
		{
			String taskType = "CONNECTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue(); //????
			sb.delete(0, sb.length()); //????

			sb.append(" select  	\n ");
			sb.append("   pfhd.PROFILE_NAME 	\n ");
			sb.append(" from moldpfhd pfhd, SMUAU muau  \n ");
			sb.append(" where pfhd.PROFILE_CODE = muau.AUTHO_PROFILE_CODE  	\n ");
			sb.append(sm.addFix(" and muau.MENU_PROFILE_CODE = ?	\n"));
			sm.addParameter(menu_profile_code);

			Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopQuery=> \n" + sb.toString());

			rtn[0] = sm.doSelect(sb.toString()); //???

			if (rtn[0] == null)
			{
				rtn[1] = "SQL manager is Null";
			}
		}
		catch (Exception e)
		{
			Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopQuery=------------------ error => " + e);
			rtn[1] = e.getMessage();
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.err.println("err	= "	+ e.getMessage());
			}
		}

		return rtn;
	}

	public SepoaOut getProfilePopUpdate(SepoaInfo info, String[][] bean_args, String menu_profile_code) throws Exception
	{
		String[] rtn = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			rtn = et_getProfilePopUpdate(info, bean_args, menu_profile_code);

			if (rtn[1] != null) //?7? ????????.
			{
				setFlag(false);
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopUpdate_________ " + rtn[1]);
				setStatus(1);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	public String[] et_getProfilePopUpdate(SepoaInfo info, String[][] bean_args, String menu_profile_code) throws Exception
	{
		String[] rtn = new String[2];
		StringBuffer sb = new StringBuffer();
		ConnectionContext ctx = getConnectionContext();

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_args.length; i++)
			{
				String autho_profiel_code = bean_args[i][0];

				sm.removeAllValue(); //????
				sb.delete(0, sb.length()); //????
										   // MENU???d??

				sb.append(" merge into SMUAU muau \n ");
				sb.append(" using \n ");
				sb.append(" ( select \n ");
				sb.append(" 	? MENU_PROFILE_CODE, \n ");
				sm.addParameter(menu_profile_code);
				sb.append(" 	? AUTHO_PROFILE_CODE, \n ");
				sm.addParameter(autho_profiel_code);
				sb.append(" 	to_char(sysdate, 'yyyymmdd') LAST_CHANGE_DATE, \n ");
				sb.append(" 	to_char(sysdate, 'HH24MISS') LAST_CHANGE_TIME, \n ");
				sb.append(" 	? LAST_CHANGE_USER_ID	 \n ");
				sm.addParameter(info.getSession("ID"));
				sb.append("   from dual ) data \n ");

				sb.append(" on (data.MENU_PROFILE_CODE = muau.MENU_PROFILE_CODE   \n ");
				sb.append(" 	  and data.AUTHO_PROFILE_CODE = muau.AUTHO_PROFILE_CODE ) \n ");
				sb.append(" when matched then \n ");

				sb.append(" 	update set \n ");
				sb.append(" 		muau.LAST_CHANGE_USER_ID = data.LAST_CHANGE_USER_ID, \n ");
				sb.append(" 		muau.LAST_CHANGE_DATE = data.LAST_CHANGE_DATE, \n ");
				sb.append(" 		muau.LAST_CHANGE_TIME = data.LAST_CHANGE_TIME \n ");

				sb.append(" when not matched then \n ");

				sb.append(" 	insert  \n ");
				sb.append(" 	(	MENU_PROFILE_CODE, \n ");
				sb.append(" 		AUTHO_PROFILE_CODE \n ");
				sb.append(" 	) values ( \n ");
				sb.append(" 		data.MENU_PROFILE_CODE, \n ");
				sb.append(" 		data.AUTHO_PROFILE_CODE \n ");
				sb.append(" 	)	 \n ");

				Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopUpdate-> \n" + sb.toString());
				sm.doUpdate(sb.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopUpdate=------------------ error.");
			rtn[1] = e.getMessage();
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopUpdate=------------------ error.");
				rtn[1] = e.getMessage();
			}
		}

		return rtn;
	}

	public SepoaOut getProfilePopDelete(SepoaInfo info, String[][] bean_args, String menu_profile_code) throws Exception
	{
		String[] rtn = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			rtn = et_getProfilePopDelete(info, bean_args, menu_profile_code);

			if (rtn[1] != null) //?7? ????????.
			{
				setFlag(false);
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopDelete_________ " + rtn[1]);
				setStatus(1);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	public String[] et_getProfilePopDelete(SepoaInfo info, String[][] bean_args, String menu_profile_code) throws Exception
	{
		String[] rtn = new String[2];
		StringBuffer sb = new StringBuffer();
		ConnectionContext ctx = getConnectionContext();
		setFlag(true);
		setMessage("Success.");

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_args.length; i++)
			{
				String autho_profile_code = bean_args[i][0];

				sm.removeAllValue(); //????
				sb.delete(0, sb.length()); //??d??
				sb.append(" delete from  SMUAU   \n ");
				sb.append(" where MENU_PROFILE_CODE = ? \n ");
				sm.addParameter(menu_profile_code);
				sb.append(" and AUTHO_PROFILE_CODE = ? \n ");
				sm.addParameter(autho_profile_code);

				sm.doUpdate(sb.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopDelete=------------------ error.");
			rtn[1] = e.getMessage();
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.debug.println(info.getSession("ID"), this, "et_getProfilePopDelete=------------------ error.");
				rtn[1] = e.getMessage();
			}
		}

		return rtn;
	}

	/**
	 * Refactoring - Extract Method.
	 * */
	private void printDebug(SepoaInfo wi, String rtn)
	{
		Logger.debug.println(wi.getSession("ID"), this, rtn);
	}

	public SepoaOut selectProfileMupd(String menu_name, String module_type)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			String user_id = info.getSession("ID");
			straResult = processSelectProfileMupd(user_id, menu_name, module_type);

			if (straResult[1] != null)
			{
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
				throw new Exception(straResult[1]);
			}

			setValue(straResult[0]);

			SepoaOut wo = getSepoaOut();
			SepoaFormater wf = new SepoaFormater(wo.result[0]);
			

			/*
			for (int i = 0; i < wf.getRowCount(); i++) {
			        String[] straSubResult = processSelectMuhd(wi,user_id, wf.getValue(i, 0));
			        if (straSubResult[1] != null) {
			    ws.setFlag(false);
			ws.setMessage(straSubResult[1]);
			printDebug(wi, straSubResult[1]);
			ws.setStatus(1);
			throw new Exception (straSubResult[1]);
			}
			        WiseFormater sub_wf = new WiseFormater(straSubResult[0]);
			        String menu_object = new String("");

			        for (int j = 0; j < sub_wf.getRowCount(); j++) {
			                menu_object += sub_wf.getValue(j, 0) + "<";
			        }
			        wf.setValue( menu_object);

			}

			System.out.println (ws.getWiseOut().result[0]);*/
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
			printDebug(info, e.toString());
		}

		return getSepoaOut();
	}

	private String[] processSelectProfileMupd(String user_id, String menu_name, String module_type) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		String strLanguage = info.getSession("LANGUAGE");

		try
		{
			String taskType = "CONNECTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sql.delete(0, sql.length());

			if (SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				sql.append(" SELECT  \n ");
				sql.append(" 	 MENU_PROFILE_CODE,MAX(MENU_NAME) MENU_NAME, MAX(DECODE(ORDER_SEQ,'1',MODULE_TYPE,'')) MODULE_TYPE  \n ");
				sql.append(sm.addFix("	    ,MAX(GETUSERNAME(ADD_USER_ID, '000',?)) ADD_USER_ID, MAX(ADD_DATE) ADD_DATE,'Y' AS DB_FLAG \n "));
				sm.addParameter(strLanguage);
				sql.append(" 	,MAX(getMenuObjectCodeList(MENU_PROFILE_CODE)) AS MENU_OBJECT_CODE	 \n ");
				sql.append("	,(select count(*) from SMUAU where menu_profile_code = SMUPD.menu_profile_code) AUTHO_GROUP  \n ");
				sql.append("FROM   SMUPD   \n ");

				if (((menu_name == null) || (menu_name.trim().length() < 1)) && ((module_type == null) || (module_type.trim().length() < 1)))
				{
				}
				else
				{
					sql.append("WHERE  \n ");
					sql.append(sm.addSelect("	UPPER(MENU_NAME) LIKE  '%'||? || '%'  \n "));
					sm.addParameter(menu_name);

					if ((menu_name != null) && (menu_name.trim().length() > 0) && (module_type != null) && (module_type.trim().length() > 0))
					{
						sql.append("	AND    ");
					}

					sql.append(sm.addSelect("	UPPER(MODULE_TYPE) = ?   \n "));
					sm.addParameter(module_type);
				}

				sql.append("GROUP BY MENU_PROFILE_CODE               \n ");
				straResult[0] = sm.doSelect(sql.toString());
			}
			else if (SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				sql.append(" SELECT \n ");
				sql.append(" MENU_PROFILE_CODE, \n ");
				sql.append(" MAX(MENU_NAME) as MENU_NAME, \n ");
				sql.append(" MAX(case when ORDER_SEQ = '1' then MODULE_TYPE else '' end) as MODULE_TYPE, \n ");
				sql.append(" MAX(dbo.GETUSERNAME(ADD_USER_ID, '000', 'KO')) as ADD_USER_ID, \n ");
				sql.append(" MAX(dbo.getMenuObjectCodeList(MENU_PROFILE_CODE)) AS MENU_OBJECT_CODE,	 \n ");
				sql.append(" MAX(ADD_DATE) as ADD_DATE, \n ");
				sql.append("  \n ");
				sql.append(" 'Y' AS DB_FLAG, \n ");
				sql.append("  \n ");
				sql.append(" (select count(*) from SMUAU where menu_profile_code = SMUPD.menu_profile_code) as AUTHO_GROUP \n ");
				sql.append(" FROM SMUPD \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");

				if (((menu_name == null) || (menu_name.trim().length() < 1)) && ((module_type == null) || (module_type.trim().length() < 1)))
				{
				}
				else
				{
					sql.append("WHERE  \n ");
					sql.append(sm.addSelect("	UPPER(MENU_NAME) LIKE  UPPER(CONCAT('%', ? , '%')  \n "));
					sm.addParameter(menu_name);

					if ((menu_name != null) && (menu_name.trim().length() > 0) && (module_type != null) && (module_type.trim().length() > 0))
					{
						sql.append("	AND    ");
					}

					sql.append(sm.addSelect("	UPPER(MODULE_TYPE) = ?   \n "));
					sm.addParameter(module_type);
				}

				sql.append(" GROUP BY MENU_PROFILE_CODE               \n ");
				sql.append(" order by menu_profile_code desc \n ");
				straResult[0] = sm.doSelect(sql.toString());
			}
			else if (SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				sql.append(" SELECT \n ");
				sql.append(" MENU_PROFILE_CODE, \n ");
				sql.append(" MAX(MENU_NAME) as MENU_NAME, \n ");
				sql.append(" MAX(case when ORDER_SEQ = '1' then MODULE_TYPE else '' end) as MODULE_TYPE, \n ");
				sql.append(" MAX(GETUSERNAME(ADD_USER_ID, '000', 'KO')) as ADD_USER_ID, \n ");
				sql.append(" MAX(getMenuObjectCodeList(MENU_PROFILE_CODE)) AS MENU_OBJECT_CODE,	 \n ");
				sql.append(" MAX(ADD_DATE) as ADD_DATE, \n ");
				sql.append("  \n ");
				sql.append(" 'Y' AS DB_FLAG, \n ");
				sql.append("  \n ");
				sql.append(" (select count(*) from SMUAU where menu_profile_code = SMUPD.menu_profile_code) as AUTHO_GROUP \n ");
				sql.append(" FROM SMUPD \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");
				sql.append("  \n ");

				if (((menu_name == null) || (menu_name.trim().length() < 1)) && ((module_type == null) || (module_type.trim().length() < 1)))
				{
				}
				else
				{
					sql.append("WHERE  \n ");
					sql.append(sm.addSelect("	UPPER(MENU_NAME) LIKE  UPPER(CONCAT('%', ? , '%')  \n "));
					sm.addParameter(menu_name);

					if ((menu_name != null) && (menu_name.trim().length() > 0) && (module_type != null) && (module_type.trim().length() > 0))
					{
						sql.append("	AND    ");
					}

					sql.append(sm.addSelect("	UPPER(MODULE_TYPE) = ?   \n "));
					sm.addParameter(module_type);
				}

				sql.append(" GROUP BY MENU_PROFILE_CODE               \n ");
				sql.append(" order by menu_profile_code desc \n ");
				straResult[0] = sm.doSelect(sql.toString());
			}

			/*sql.
			append("SELECT MAX(SYS_CONNECT_BY_PATH(MENU_OBJECT_CODE, '<')) MENU_OBJECT_CODE, ")
			append("           MAX(MENU_PROFILE_CODE) MENU_PROFILE_CODE,                         ")
			append("           MAX(MENU_NAME) MENU_NAME,                                         ")
			append("           MAX(DECODE(ORDER_SEQ,'1',MODULE_TYPE,'')),                        ")
			append("           MAX(ADD_USER_NAME_LOC),                                           ")
			append("           MAX(ADD_DATE),                                                    ")
			append("           MAX('Y') AS DB_FLAG                                               ")
			append("                                                                             ")
			append("FROM (                                                                   ")
			append("         SELECT                                                              ")
			append("                         MENU_PROFILE_CODE,                                           ")
			append("                        MENU_OBJECT_CODE,                                            ")
			append("                        MENU_NAME,                                                   ")
			append("                        ORDER_SEQ,                                                   ")
			append("                        MODULE_TYPE,                                                 ")
			append("                        ADD_USER_NAME_LOC,                                           ")
			append("                        ADD_DATE,                                                    ")
			append("                        RN,                                                          ")
			append("                        LAG(RN) OVER(ORDER BY RN) PRN                                ")
			append("         FROM (                                                              ")
			append("                   SELECT                                                         ")
			append("                                  MENU_PROFILE_CODE,                                       ")
			append("                                MENU_OBJECT_CODE,                                        ")
			append("                                MENU_NAME,                                               ")
			append("                                ORDER_SEQ,                                               ")
			append("                                MODULE_TYPE,                                             ")
			append("                                ADD_USER_NAME_LOC,                                       ")
			append("                                ADD_DATE,                                                ")
			append("                                ROW_NUMBER() OVER (ORDER BY MENU_PROFILE_CODE) RN        ")
			append("                  FROM MOLDMUPD                                                  ")
			append("                  ORDER BY MENU_PROFILE_CODE                                     ")
			append("         )                                                                   ")
			append(")                                                                        ")
			append("START WITH PRN IS NULL                                                   ")
			append("CONNECT BY                                                               ")
			append("                PRIOR RN = PRN                                                   ").append("\n");*/
			if (straResult[0] == null)
			{
				straResult[1] = "SQL Manager is Null";
			}
		}
		catch (Exception e)
		{
			printDebug(info, e.toString());
			straResult[1] = e.getMessage();
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.err.println("err	= "	+ e.getMessage());
			}
		}

		return straResult;
	}

	private String[] processSelectMuhd(SepoaInfo wi, String user_id, String menu_profile) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		try
		{
			String taskType = "CONNECTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sql.delete(0, sql.length());

			sql.append("SELECT MENU_OBJECT_CODE  \n ");
			sql.append("FROM   SMUPD          \n ");
			sql.append("WHERE  \n ");
			sql.append(sm.addFix("	MENU_PROFILE_CODE = ?   \n "));
			sm.addParameter(menu_profile);

			straResult[0] = sm.doSelect(sql.toString());

			if (straResult[0] == null)
			{
				straResult[1] = "SQL Manager is Null";
			}
		}
		catch (Exception e)
		{
			printDebug(wi, e.toString());
			straResult[1] = e.getMessage();
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.err.println("err	= "	+ e.getMessage());
			}
		}

		return straResult;
	}

	public SepoaOut insertProfileMupd(SepoaInfo wi, String[][] setData)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processInsertProfileMupd(wi, setData);

			if (straResult[1] != null)
			{
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
				Rollback();
			}

			setValue(straResult[0]);
		}
		catch (Exception e)
		{
			Logger.err.println("Exception e =" + e.getMessage());
			setFlag(false);
			setMessage(e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] processInsertProfileMupd(SepoaInfo wi, String[][] setData) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		String user_id = wi.getSession("ID");

		String company_code = wi.getSession("COMPANY_CODE");
		String user_name1 = wi.getSession("NAME_LOC");
		String user_name2 = wi.getSession("NAME_ENG");
		String user_dept = wi.getSession("DEPARTMENT");
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();

			for (int i = 0; i < setData.length; i++)
			{
				sm.removeAllValue();
				tSQL.delete(0, tSQL.length());
				tSQL.append(" INSERT  INTO SMUPD( \n ");
				tSQL.append(" MENU_PROFILE_CODE,MENU_OBJECT_CODE, \n ");
				tSQL.append(" MENU_NAME,MODULE_TYPE,ADD_DATE,ADD_TIME,ADD_USER_ID, \n ");
				tSQL.append(" ADD_USER_DEPT,ADD_USER_NAME_ENG,ADD_USER_NAME_LOC,ORDER_SEQ) \n ");
				tSQL.append(" (SELECT ?, MENU_OBJECT_CODE, \n ");
				sm.addParameter(setData[i][0]);
				tSQL.append(" ? ,MODULE_TYPE, \n ");
				sm.addParameter(setData[i][1]);
				tSQL.append(" ? ,");
				sm.addParameter(cur_date);
				tSQL.append(" ? ,");
				sm.addParameter(cur_time);
				tSQL.append(" ? ,");
				sm.addParameter(user_id);
				tSQL.append(" ? ,");
				sm.addParameter(user_dept);
				tSQL.append(" ? ,");
				sm.addParameter(user_name2);
				tSQL.append(" ? ,");
				sm.addParameter(user_name1);
				tSQL.append(" 	DECODE(MODULE_TYPE, ");
				tSQL.append(" ? , ");
				sm.addParameter(setData[i][3]);
				tSQL.append("	'1','') \n ");
				tSQL.append("	FROM MOLDMUHD \n ");
				tSQL.append("	WHERE \n ");
				tSQL.append(" 		MENU_OBJECT_CODE IN (").append(setData[i][2]).append(")) \n ");

				
				sm.doInsert(tSQL.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.toString();
			printDebug(wi, e.toString());
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.err.println("err	= "	+ e.getMessage());
			}
		}

		return straResult;
	}

	public SepoaOut directInsertProfileMupd(String[][] setData)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processDirectInsertProfileMupd(setData);

			if (straResult[1] != null)
			{
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
				Rollback();
			}

			setValue(straResult[0]);
		}
		catch (Exception e)
		{
			Logger.err.println("Exception e =" + e.getMessage());
			setFlag(false);
			setMessage(e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] processDirectInsertProfileMupd(String[][] setData) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		String user_id = info.getSession("ID");
		String company_code = info.getSession("COMPANY_CODE");
		String user_name1 = info.getSession("NAME_LOC");
		String user_name2 = info.getSession("NAME_ENG");
		String user_dept = info.getSession("DEPARTMENT");
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();

			SepoaOut wo = DocumentUtil.getDocNumber(info, "MUP", "H");
			String strMupdDocNumber = "";

			if (wo.status == 1)
			{
				strMupdDocNumber = wo.result[0];
			}
			else
			{
				strMupdDocNumber = "M" + SepoaString.replace(SepoaString.replace(SepoaDate.getTimeStampString(), ":", ""), "-", "");
			}

			for (int i = 0; i < setData.length; i++)
			{
				
				Logger.debug.println(info.getSession("ID"), this, "setData["+i+"][0]===>"+setData[i][0]);
				Logger.debug.println(info.getSession("ID"), this, "setData["+i+"][1]===>"+setData[i][1]);
				Logger.debug.println(info.getSession("ID"), this, "setData["+i+"][2]===>"+setData[i][2]);
				
				sm.removeAllValue();
				tSQL.delete(0, tSQL.length());
				tSQL.append(" INSERT  INTO SMUPD( \n ");
				tSQL.append(" MENU_PROFILE_CODE,\n ");
				tSQL.append(" MENU_OBJECT_CODE, \n ");
				tSQL.append(" MENU_NAME, \n ");
				tSQL.append(" MODULE_TYPE, \n ");
				tSQL.append(" ADD_DATE, \n ");
				tSQL.append(" ADD_TIME, \n ");
				tSQL.append(" ADD_USER_ID, \n ");
				tSQL.append(" DEL_FLAG,  \n ");
				tSQL.append(" ORDER_SEQ ) \n ");


				tSQL.append(" (SELECT ?, MENU_OBJECT_CODE, \n "); sm.addParameter(strMupdDocNumber);
				tSQL.append(" ? ,MODULE_TYPE, \n "); sm.addParameter(setData[i][0]);
				tSQL.append(" ? ,"); sm.addParameter(cur_date);
				tSQL.append(" ? ,"); sm.addParameter(cur_time);
				tSQL.append(" ? ,"); sm.addParameter(user_id);

				tSQL.append("   ?, \n "); sm.addParameter("N");
				tSQL.append(" 	case when MODULE_TYPE = ");
				tSQL.append(" ? then "); sm.addParameter(setData[i][2]);
				tSQL.append("	'1' else '' end \n ");
				tSQL.append("	FROM smugl \n ");
				tSQL.append("	WHERE \n ");
				tSQL.append(" 		MENU_OBJECT_CODE IN (").append(setData[i][1]).append(")) \n ");

				
				sm.doInsert(tSQL.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.toString();
			printDebug(info, e.toString());
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.err.println("err	= "	+ e.getMessage());
			}
		}

		return straResult;
	}

	public SepoaOut deleteProfileMupd(String[][] menu_profile_code)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processDeleteProfileMupd(menu_profile_code);

			if (straResult[1] != null)
			{
				Rollback();
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
			}
			else
			{
				Commit();
			}
		}
		catch (Exception e)
		{
			printDebug(info, e.toString());
			setFlag(false);
			setMessage(e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] processDeleteProfileMupd(String[][] menu_profile_code) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		String user_id = info.getSession("ID");

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer strbufSql = new StringBuffer();

			for (int a = 0; a < menu_profile_code.length; a++)
			{
				sm.removeAllValue();
				strbufSql.delete(0, strbufSql.length());
				strbufSql.append(" DELETE FROM SMUPD \n ");
				strbufSql.append(" WHERE  MENU_PROFILE_CODE = ? \n ");
				sm.addParameter(menu_profile_code[a][0]);
				sm.doDelete(strbufSql.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.toString();
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.err.println("err	= "	+ e.getMessage());
			}
		}

		return straResult;
	}

	public SepoaOut updateProfileMupd(String[][] setData)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processupdateProfileMupd(setData);

			if (straResult[1] != null)
			{
				Rollback();
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
			}
			else
			{
				Commit();
			}
		}
		catch (Exception e)
		{
			printDebug(info, e.toString());
			setFlag(false);
			setMessage(e.getMessage());
		}

		return getSepoaOut();
	}
	private String[] processupdateProfileMupd(String[][] setData) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		
		setFlag(true);
		setMessage("Success.");

		String user_id = info.getSession("ID");
		String company_code = info.getSession("COMPANY_CODE");
		String user_name1 = info.getSession("NAME_LOC");
		String user_name2 = info.getSession("NAME_ENG");
		String user_dept = info.getSession("DEPARTMENT");
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();

			String menu_profile_code = "";
			String menu_name = "";
			String module_type = "";
			String menu_object_code = "";

			for (int i = 0; i < setData.length; i++)
			{
				menu_name = setData[i][0];
				module_type = setData[i][1];
				menu_object_code = setData[i][2];
				menu_profile_code = setData[i][3];

				sm.removeAllValue();
				tSQL.delete(0, tSQL.length());
				tSQL.append(" DELETE FROM SMUPD \n ");
				tSQL.append(" WHERE  MENU_PROFILE_CODE = ? \n ");
				sm.addStringParameter(menu_profile_code);
				sm.doDelete(tSQL.toString());

				sm.removeAllValue();
				tSQL.delete(0, tSQL.length());
				tSQL.append(" INSERT  INTO SMUPD( \n ");
				tSQL.append(" MENU_PROFILE_CODE,\n ");
				tSQL.append(" MENU_OBJECT_CODE, \n ");
				tSQL.append(" MENU_NAME, \n ");
				tSQL.append(" MODULE_TYPE, \n ");
				tSQL.append(" ADD_DATE, \n ");
				tSQL.append(" ADD_TIME, \n ");
				tSQL.append(" ADD_USER_ID, \n ");
				tSQL.append(" DEL_FLAG,  \n ");
				tSQL.append(" ORDER_SEQ ) \n ");


				tSQL.append(" (SELECT ?, MENU_OBJECT_CODE, \n "); sm.addStringParameter(menu_profile_code);
				tSQL.append(" ? ,\n "); sm.addStringParameter(menu_name);
				tSQL.append(" MODULE_TYPE, \n "); 
				tSQL.append(" ? ,"); sm.addStringParameter(cur_date);
				tSQL.append(" ? ,"); sm.addStringParameter(cur_time);
				tSQL.append(" ? ,"); sm.addStringParameter(user_id);

				tSQL.append("   ?, \n "); sm.addStringParameter("N");
				tSQL.append(" 	case when MODULE_TYPE = ");
				tSQL.append(" ? then "); sm.addStringParameter(module_type);
				tSQL.append("	'1' else '' end \n ");
				tSQL.append("	FROM smugl \n ");
				tSQL.append("	WHERE \n ");
				tSQL.append(" 		MENU_OBJECT_CODE IN (").append(menu_object_code).append(")) \n ");

				sm.doInsert(tSQL.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.toString();
			printDebug(info, e.toString());
		}
		finally
		{
			try
			{
				Release();
			}
			catch (Exception e)
			{
				Logger.err.println("err	= "	+ e.getMessage());
			}
		}

		return straResult;
	}
}
