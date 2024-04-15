package sepoa.svc.admin;

import sepoa.fw.cfg.*;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;

import sepoa.fw.log.Logger;

import sepoa.fw.msg.Message;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.*;

import sepoa.fw.util.SepoaDate;

public class AD_101 extends SepoaService
{
	//Message msg = new Message("STDCOMM"); // message 처리를 위해 전역변수 선언
	Message msg = null;

	public AD_101(String s, SepoaInfo info) throws SepoaServiceException
	{
		super(s, info);
		msg = new Message(info, "STDCOMM"); // message 처리를 위해 전역변수 선언
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

	public SepoaOut FindDNCT(String i_doc_type)
	{
		try
		{
			String rtn = et_FindDNCT(i_doc_type);
			setMessage(msg.getMessage("0000"));
			setValue(rtn);
			setStatus(1);
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	public String et_FindDNCT(String i_doc_type) throws Exception
	{
		String rtn = null;

		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");

			ConnectionContext ctx = getConnectionContext();

			StringBuffer sql = new StringBuffer();

			sql.append("	 SELECT                                        \n");
			sql.append("	       SEQ                                     \n");
			sql.append("	     , PREFIX_FORMAT                           \n");
			sql.append("	     , START_NO                                \n");
			sql.append("	     , END_NO                                  \n");
			sql.append("	     , YEAR_FLAG                               \n");
			sql.append("	     , MONTH_FLAG                              \n");
			sql.append("	     , DAY_FLAG                                \n");
			sql.append("	     , CURRENT_NO                              \n");
			sql.append("	     , MANUAL_FLAG                             \n");
			sql.append("	     , USE_FLAG                                \n");
			sql.append("	     , " + SEPOA_DB_OWNER + "GETUSERNAME(CHANGE_USER_ID, '" + info.getSession("HOUSE_CODE") + "', '" + info.getSession("LANGUAGE") + "') AS CHANGE_USER_NAME_LOC                    \n");
			sql.append("	     , CHANGE_DATE                             \n");
			sql.append("	     , DOC_TYPE                                \n");
			sql.append("	 FROM  SDCLN                                \n");
			sql.append("	 WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') = 'N'    \n");
			sql.append("	 <OPT=S,S>    AND  DOC_TYPE       =  ? </OPT>  \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			String[] as = { i_doc_type };
			rtn = sm.doSelect(as);
		}
		catch (Exception e)
		{
			throw new Exception("et_FindDNCT:" + e.getMessage());
		}

		return rtn;
	}

	public SepoaOut CreateDNCT(String[][] delData, String[][] setData)
	{
		try
		{
			int delrtn = et_RemoveDNCT(delData);
			int rtn = et_CreateDNCT(setData);
			setMessage(msg.getMessage("0000"));
			setValue("DNCT Create:" + rtn);
			setStatus(1);

			Commit();
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());

			try
			{
				Rollback();
			}
			catch (Exception d)
			{
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			setStatus(0);
			setMessage(msg.getMessage("0003"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private int et_CreateDNCT(String[][] setData) throws Exception
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

//			if (getConfig("sepoa.db.vendor").equals(""))
//			{
//				/* 원래 소스 버그 있음. mysql 보고 알아서 수정하세요. 이대규 */
//				tSQL.append(" INSERT  INTO  SDCLN                                                                                                    \n");
//				tSQL.append(" (                                                                                                                         \n");
//				tSQL.append("     HOUSE_CODE, DOC_TYPE, SEQ, PREFIX_FORMAT,                                                                \n");
//				tSQL.append("     START_NO, END_NO, YEAR_FLAG, MONTH_FLAG, DAY_FLAG,                                                                    \n");
//				tSQL.append("     CURRENT_NO, MANUAL_FLAG, USE_FLAG, STATUS, ADD_DATE,                                                                  \n");
//				tSQL.append("     ADD_TIME, CHANGE_DATE, CHANGE_TIME, ADD_USER_ID, CHANGE_USER_ID                                                   \n");
//				tSQL.append(" )                                                                                                                         \n");
//				tSQL.append(" VALUES                                                                                                                    \n");
//				tSQL.append(" (                                                                                                                         \n");
//				tSQL.append("     '" + house_code + "', ?, ?, ?,                                                                                     \n");
//				tSQL.append("     ?, ?, ?, ?, ?,                                                                                                        \n");
//				tSQL.append("     RPAD(?||");
//				tSQL.append("     DECODE(?,'Y',TO_CHAR(SYSDATE,'YYYY'),'')||");
//				tSQL.append("     DECODE(?,'Y',TO_CHAR(SYSDATE,'MM'),'')||");
//				tSQL.append("     DECODE(?,'Y',TO_CHAR(SYSDATE,'DD'),'')");
//				tSQL.append("     ,LENGTH(?||");
//				tSQL.append("     DECODE(?,'Y',TO_CHAR(SYSDATE,'YYYY'),'')||");
//				tSQL.append("     DECODE(?,'Y',TO_CHAR(SYSDATE,'MM'),'')||");
//				tSQL.append("     DECODE(?,'Y',TO_CHAR(SYSDATE,'DD'),''))+LENGTH(?),'0'),");
//				tSQL.append("       ?, ?, 'C', '" + cur_date + "',                                                                                      \n");
//				tSQL.append("     '" + cur_time + "', '" + cur_date + "', '" + cur_time + "', '" + user_id + "', '" + user_id + "'              \n");
//				tSQL.append(" )                                                                                                                         \n");
//				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//				String[] type =
//				{
//					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
//					"S", "S", "S", "S", "S", "S"
//				};
//				rtn = sm.doInsert(setData, type);
//			}
//			else if (getConfig("sepoa.db.vendor").equals("MSSQL"))
//			{
//				/* 원래 소스 버그 있음. mysql 보고 알아서 수정하세요. 이대규 */
//				tSQL.append(" INSERT  INTO  SDCLN                                                                                                    \n");
//				tSQL.append(" (                                                                                                                         \n");
//				tSQL.append("     HOUSE_CODE, DOC_TYPE, SEQ, PREFIX_FORMAT,                                                                \n");
//				tSQL.append("     START_NO, END_NO, YEAR_FLAG, MONTH_FLAG, DAY_FLAG,                                                                    \n");
//				tSQL.append("     CURRENT_NO, MANUAL_FLAG, USE_FLAG, STATUS, ADD_DATE,                                                                  \n");
//				tSQL.append("     ADD_TIME, CHANGE_DATE, CHANGE_TIME, ADD_USER_ID, CHANGE_USER_ID                                                   \n");
//				tSQL.append(" )                                                                                                                         \n");
//				tSQL.append(" VALUES                                                                                                                    \n");
//				tSQL.append(" (                                                                                                                         \n");
//				tSQL.append("     '" + house_code + "', ?, ?, ?,                                                                                     \n");
//				tSQL.append("     ?, ?, ?, ?, ?,                                                                                                        \n");
//				tSQL.append("     " + getConfig("sepoa.generator.db.selfuser") + "." + "RPAD( ? +                                                         \n");
//				tSQL.append("     CASE ? WHEN 'Y' THEN DATENAME(YYYY,GETDATE()) ELSE '' END +                                                           \n");
//				tSQL.append("     CASE ? WHEN 'Y' THEN DATENAME(MM,GETDATE()) ELSE '' END    +                                                          \n");
//				tSQL.append("     CASE ? WHEN 'Y' THEN DATENAME(DD,GETDATE()) ELSE '' END,                                                              \n");
//				tSQL.append("     LEN( ? +                                                                                                              \n");
//				tSQL.append("     CASE ? WHEN 'Y' THEN DATENAME(YYYY,GETDATE()) ELSE '' END +                                                           \n");
//				tSQL.append("     CASE ? WHEN 'Y' THEN DATENAME(MM,GETDATE()) ELSE '' END    +                                                          \n");
//				tSQL.append("     CASE ? WHEN 'Y' THEN DATENAME(DD,GETDATE()) ELSE '' END ) + LEN(?),'0'),                                              \n");
//				tSQL.append("       ?, ?, 'C', '" + cur_date + "',                                                                                      \n");
//				tSQL.append("     '" + cur_time + "', '" + cur_date + "', '" + cur_time + "', '" + user_id + "', '" + user_id + "'               \n");
//				tSQL.append(" )                                                                                                                         \n");
//				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//				String[] type =
//				{
//					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
//					"S", "S", "S", "S", "S", "S"
//				};
//				rtn = sm.doInsert(setData, type);
//			}
//			else if (getConfig("sepoa.db.vendor").equals("MYSQL"))
//			{
				String year = SepoaDate.getShortDateString().substring(0, 4);
				String month = SepoaDate.getShortDateString().substring(4, 6);
				String day = SepoaDate.getShortDateString().substring(6);
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				String prefix = ""; String year_flag = ""; String month_flag = "";
				String day_flag = ""; String start_number = ""; String end_number = "";
				String now_doc_number = ""; int dif_cnt = 0;

				for(int i = 0; i < setData.length; i++)
				{
					prefix = setData[i][8].trim(); year_flag = setData[i][9].trim(); month_flag = setData[i][10].trim();
					day_flag = setData[i][11].trim(); start_number = setData[i][3].trim(); end_number = setData[i][16].trim();
					now_doc_number = "";

					now_doc_number = prefix + (year_flag.equals("Y") ? year : "") +
									(month_flag.equals("Y") ? month : "") +
									(day_flag.equals("Y") ? day : "");
					dif_cnt = end_number.length() - start_number.length();

					for(int x = 0; x < dif_cnt; x++)
					{
						now_doc_number += "0";
					}

					now_doc_number += start_number;

					sm.removeAllValue();
					tSQL.append(" INSERT  INTO  SDCLN                                                                                                    \n");
					tSQL.append(" (                                                                                                                         \n");
					tSQL.append("     DOC_TYPE, SEQ, PREFIX_FORMAT,                                                                \n");
					tSQL.append("     START_NO, END_NO, YEAR_FLAG, MONTH_FLAG, DAY_FLAG,                                                                    \n");
					tSQL.append("     CURRENT_NO, MANUAL_FLAG, USE_FLAG, DEL_FLAG, ADD_DATE,                                                                  \n");
					tSQL.append("     ADD_TIME, CHANGE_DATE, CHANGE_TIME, ADD_USER_ID, CHANGE_USER_ID                                                   \n");
					tSQL.append(" )                                                                                                                         \n");
					tSQL.append(" VALUES                                                                                                                    \n");
					tSQL.append(" (                                                                                                                         \n");
					tSQL.append("     ?, ?, ?,                                                                                     \n");
					sm.addStringParameter(setData[i][0]);
					sm.addStringParameter(setData[i][1]);
					sm.addStringParameter(setData[i][2]);
					tSQL.append("     ?, ?, ?, ?, ?,                                                                                                        \n");
					sm.addStringParameter(setData[i][3]);
					sm.addStringParameter(setData[i][4]);
					sm.addStringParameter(setData[i][5]);
					sm.addStringParameter(setData[i][6]);
					sm.addStringParameter(setData[i][7]);
//					tSQL.append("     RPAD( concat(?,   \n");
//					sm.addStringParameter(setData[i][8]);
//					tSQL.append("     CASE ? WHEN 'Y' THEN '" + year + "' ELSE '' END ,                                                           \n");
//					sm.addStringParameter(setData[i][9]);
//					tSQL.append("     CASE ? WHEN 'Y' THEN '" + month + "' ELSE '' END    ,                                                          \n");
//					sm.addStringParameter(setData[i][10]);
//					tSQL.append("     CASE ? WHEN 'Y' THEN '" + day + "' ELSE '' END, substr(?, 1, 1)),                                                              \n");
//					sm.addStringParameter(setData[i][11]);
//					sm.addStringParameter(setData[i][3]);
//					tSQL.append("     LENGTH( concat(?,                                                                                                              \n");
//					sm.addStringParameter(setData[i][12]);
//					tSQL.append("     CASE ? WHEN 'Y' THEN '" + year + "' ELSE '' END ,                                                           \n");
//					sm.addStringParameter(setData[i][13]);
//					tSQL.append("     CASE ? WHEN 'Y' THEN '" + month + "' ELSE '' END    ,                                                          \n");
//					sm.addStringParameter(setData[i][14]);
//					tSQL.append("     CASE ? WHEN 'Y' THEN '" + day + "' ELSE '' END )) + (LENGTH(?)),'0'),                                              \n");
//					sm.addStringParameter(setData[i][15]);
//					sm.addStringParameter(setData[i][16]);
					tSQL.append("       ?, \n "); sm.addStringParameter(now_doc_number);
					tSQL.append("       ?, ?, 'N', '" + cur_date + "',                                                                                      \n");
					sm.addStringParameter(setData[i][17]);
					sm.addStringParameter(setData[i][18]);
					tSQL.append("     '" + cur_time + "', '" + cur_date + "', '" + cur_time + "', '" + user_id + "', '" + user_id + "'               \n");
					tSQL.append(" ) \n");
					sm.doInsert(tSQL.toString());
				}
//			}

			/*
			tSQL.append("RPAD(?||");
			tSQL.append("DECODE(?,'Y',TO_CHAR(SYSDATE,'YYYY'),'')||");
			tSQL.append("DECODE(?,'Y',TO_CHAR(SYSDATE,'MM'),'')||");
			tSQL.append("DECODE(?,'Y',TO_CHAR(SYSDATE,'DD'),'')");
			tSQL.append(",LENGTH(?||");
			tSQL.append("DECODE(?,'Y',TO_CHAR(SYSDATE,'YYYY'),'')||");
			tSQL.append("DECODE(?,'Y',TO_CHAR(SYSDATE,'MM'),'')||");
			tSQL.append("DECODE(?,'Y',TO_CHAR(SYSDATE,'DD'),''))+LENGTH(?),'0'),");
			*/

		}
		catch (Exception e)
		{
			throw new Exception("et_CreateDNCT:" + e.getMessage());
		}

		return rtn;
	}

	public SepoaOut SetDNCT(String[][] setData)
	{
		try
		{
			int rtn = et_SetDNCT(setData);
			setMessage(msg.getMessage("0000"));
			setValue("DNCT Update:" + rtn);
			setStatus(1);
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private int et_SetDNCT(String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String user_name_loc = info.getSession("NAME_LOC");
			String user_name_eng = info.getSession("NAME_ENG");
			String user_dept = info.getSession("DEPARTMENT");
			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			ConnectionContext ctx = getConnectionContext();

			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" UPDATE  SDCLN                                                                              \n");
			tSQL.append(" SET     CHANGE_DATE          = '" + cur_date + "',                                            \n");
			tSQL.append("         CHANGE_TIME          = '" + cur_time + "',                                            \n");
			tSQL.append("         CHANGE_USER_ID       = '" + user_id + "',                                             \n");
			tSQL.append("         DEL_FLAG               = 'N',                                                           \n");
			tSQL.append("         PREFIX_FORMAT        = ? ,                                                            \n");
			tSQL.append("         START_NO             = ? ,                                                            \n");
			tSQL.append("         END_NO               = ? ,                                                            \n");
			tSQL.append("         YEAR_FLAG            = ? ,                                                            \n");
			tSQL.append("         MONTH_FLAG           = ? ,                                                            \n");
			tSQL.append("         DAY_FLAG             = ? ,                                                            \n");
			tSQL.append("         CURRENT_NO           = ? ,                                                            \n");
			tSQL.append("         MANUAL_FLAG          = ? ,                                                            \n");
			tSQL.append("         USE_FLAG             =  ?                                                             \n");
			tSQL.append(" WHERE DOC_TYPE = ?    AND SEQ = ?   \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			String[] type =
			{
				"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S"
			};
			rtn = sm.doUpdate(setData, type);
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			throw new Exception("et_SetDNCT:" + e.getMessage());
		}

		return rtn;
	}

	public SepoaOut RemoveDNCT(String[][] setData)
	{
		try
		{
			int rtn = et_RemoveDNCT(setData);
			setMessage(msg.getMessage("0014"));
			setValue("DNCT Remove:" + rtn);
			setStatus(1);

			Commit();
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());

			try
			{
				Rollback();
			}
			catch (Exception d)
			{
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			setStatus(0);
			setMessage(msg.getMessage("0004"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private int et_RemoveDNCT(String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");

			ConnectionContext ctx = getConnectionContext();

			StringBuffer tSQL = new StringBuffer();

			tSQL.append(" DELETE  FROM  SDCLN                                                    \n");
			tSQL.append(" WHERE DOC_TYPE = ?  AND SEQ = ?     \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			String[] type = { "S", "S" };
			rtn = sm.doUpdate(setData, type);
		}
		catch (Exception e)
		{
			throw new Exception("et_RemoveDNCT:" + e.getMessage());
		}

		return rtn;
	}

	public SepoaOut RemoveAllDNCT(String[][] setData)
	{
		try
		{
			int rtn = et_RemoveAllDNCT(setData);
			setMessage(msg.getMessage("0014"));
			setValue("DNCT RemoveAll:" + rtn);
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

	private int et_RemoveAllDNCT(String[][] setData) throws Exception
	{
		int rtn = -1;

		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");

			ConnectionContext ctx = getConnectionContext();

			StringBuffer tSQL = new StringBuffer();

			tSQL.append(" DELETE  FROM  SDCLN                                       \n");
			tSQL.append(" WHERE DOC_TYPE = ?     \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			String[] type = { "S" };
			rtn = sm.doUpdate(setData, type);
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			throw new Exception("et_RemoveAllDNCT:" + e.getMessage());
		}

		return rtn;
	}
}
