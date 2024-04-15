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

import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class AD_036 extends SepoaService
{
	private String ID = info.getSession("ID");
	private String SEPOA_DB_VENDOR = "";
	private String DB_NULL_FUNCTION = "";

	public AD_036(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");

		Configuration configuration = null;

		try
		{
			configuration = new Configuration();
		}
		catch (ConfigurationException cfe)
		{
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
		}

		SEPOA_DB_VENDOR = (configuration != null)?configuration.getString("sepoa.db.vendor"):"";

		if (SEPOA_DB_VENDOR.equals("ORACLE"))
		{
			DB_NULL_FUNCTION = "NVL";
		}
		else if (SEPOA_DB_VENDOR.equals("MYSQL"))
		{
			DB_NULL_FUNCTION = "IFNULL";
		}
		else if (SEPOA_DB_VENDOR.equals("MSSQL"))
		{
			DB_NULL_FUNCTION = "NULLIF";
		}
	}

	/**
	 * Refactoring - Extract Method.
	 * */
	private void printDebug(SepoaInfo wi, String rtn)
	{
		Logger.debug.println(wi.getSession("ID"), this, rtn);
	}

	public SepoaOut selectFwrs(SepoaInfo wi, String strKindOfPrc, String strValue, String houseCode)
	{
		String user_id = wi.getSession("ID");

		/*SepoaService ws = new SepoaService();
		String[] straReturn = null;
		ws.setFlag(true);
		ws.setMessage("Success.");*/
		String[] straReturn = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straReturn = processSelectFwrs(wi, strKindOfPrc, strValue, houseCode);

			if (straReturn[1] != null)
			{
				setFlag(false);
				setMessage(straReturn[1]);
				printDebug(wi, straReturn[1]);
				setStatus(1);
			}

			setValue(straReturn[0]);
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
			printDebug(wi, e.toString());
		}

		return getSepoaOut();
	}

	public String[] processSelectFwrs(SepoaInfo wi, String strKindOfPrc, String strValue, String houseCode) throws Exception
	{
		//SepoaService ws = new SepoaService();
		String[] rtn = new String[2];

		StringBuffer sql = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		ConnectionContext ctx = getConnectionContext();

		try
		{
			String taskType = "CONNECTION";
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sql.delete(0, sql.length());

			sql.append("SELECT ");
			sql.append("    HOUSE_CODE, ");
			sql.append("    PROCESS_ID, ");
			sql.append("    METHOD, ");
			sql.append("    USE_FLAG, ");
			sql.append("    AUTHO_OBJECT_CODE, ");
			sql.append("    AUTHO_APPLY_FLAG, ");
			sql.append("    DESCRIPTION, ");
			sql.append("    START_DATE, ");
			sql.append("    END_DATE, ");
			sql.append("    ADD_DATE, ");
			sql.append("    GETUSERNAME(USER_ID, HOUSE_CODE, 'KO') ADD_USER_NAME, ");
			sql.append("    URL, \n ");
			sql.append("    SERVICE_CLASS \n ");

			sql.append("FROM ");
			sql.append("    SFRWK ");
			sql.append("WHERE 1=1 ");

			if (strKindOfPrc.equals("") && ! strValue.trim().equals(""))
			{
				if (SEPOA_DB_VENDOR.equals("ORACLE"))
				{
					sql.append(sm.addFix("    AND UPPER(PROCESS_ID) LIKE  '%'||UPPER(?)||'%'  "));
				}
				else if (SEPOA_DB_VENDOR.equals("MYSQL"))
				{
					sql.append(sm.addFix("    AND UPPER(PROCESS_ID) LIKE  CONCAT('%', UPPER(?),'%')  "));
				}

				sm.addParameter(strValue);

				if (SEPOA_DB_VENDOR.equals("ORACLE"))
				{
					sql.append(sm.addFix("    OR UPPER(METHOD) LIKE  '%'||UPPER(?)||'%'  "));
				}
				else if (SEPOA_DB_VENDOR.equals("MYSQL"))
				{
					sql.append(sm.addFix("    OR UPPER(METHOD) LIKE  CONCAT('%',UPPER(?),'%') "));
				}

				sm.addParameter(strValue);

				if (SEPOA_DB_VENDOR.equals("ORACLE"))
				{
					sql.append(sm.addFix("    OR UPPER(DESCRIPTION) LIKE  '%'||UPPER(?)||'%' "));
				}
				else if (SEPOA_DB_VENDOR.equals("MYSQL"))
				{
					sql.append(sm.addFix("    OR UPPER(DESCRIPTION) LIKE  CONCAT('%', UPPER(?),'%') "));
				}

				sm.addParameter(strValue);

				if (SEPOA_DB_VENDOR.equals("ORACLE"))
				{
					sql.append(sm.addFix("    OR UPPER(AUTHO_OBJECT_CODE) LIKE  '%'||UPPER(?)||'%' "));
				}
				else if (SEPOA_DB_VENDOR.equals("MYSQL"))
				{
					sql.append(sm.addFix("    OR UPPER(AUTHO_OBJECT_CODE) LIKE  CONCAT('%',UPPER(?),'%') "));
				}

				sm.addParameter(strValue);

				if (SEPOA_DB_VENDOR.equals("ORACLE"))
				{
					sql.append(sm.addFix("    OR UPPER(USER_ID) LIKE  '%'||UPPER(?)||'%' "));
				}
				else if (SEPOA_DB_VENDOR.equals("MYSQL"))
				{
					sql.append(sm.addFix("    OR UPPER(USER_ID) LIKE  CONCAT('%',UPPER(?),'%')  "));
				}

				sm.addParameter(strValue);
			}
			else if ( !(strKindOfPrc == null || "".trim().equals(strKindOfPrc)))
			{
				if (strKindOfPrc.equals("PID"))
				{
					if (SEPOA_DB_VENDOR.equals("ORACLE"))
					{
						sql.append(sm.addFix("    AND UPPER(PROCESS_ID) LIKE  '%'||UPPER(?)||'%' "));
					}
					else if (SEPOA_DB_VENDOR.equals("MYSQL"))
					{
						sql.append(sm.addFix("    AND UPPER(PROCESS_ID) LIKE  CONCAT('%', UPPER(?),'%') "));
					}

					sm.addParameter(strValue);
				}
				else if (strKindOfPrc.equals("MTD"))
				{
					if (SEPOA_DB_VENDOR.equals("ORACLE"))
					{
						sql.append(sm.addFix("    AND UPPER(METHOD) LIKE  '%'||UPPER(?)||'%' "));
					}
					else if (SEPOA_DB_VENDOR.equals("MYSQL"))
					{
						sql.append(sm.addFix("    AND UPPER(METHOD) LIKE  CONCAT('%',UPPER(?),'%') "));
					}

					sm.addParameter(strValue);
				}
				else if (strKindOfPrc.equals("DSC"))
				{
					if (SEPOA_DB_VENDOR.equals("ORACLE"))
					{
						sql.append(sm.addFix("    AND UPPER(DESCRIPTION) LIKE  '%'||UPPER(?)||'%' "));
					}
					else if (SEPOA_DB_VENDOR.equals("MYSQL"))
					{
						sql.append(sm.addFix("    AND UPPER(DESCRIPTION) LIKE  CONCAT('%', UPPER(?),'%') "));
					}

					sm.addParameter(strValue);
				}
				else if (strKindOfPrc.equals("POW"))
				{
					if (SEPOA_DB_VENDOR.equals("ORACLE"))
					{
						sql.append(sm.addFix("    AND UPPER(AUTHO_OBJECT_CODE) LIKE  '%'||UPPER(?)||'%' "));
					}
					else if (SEPOA_DB_VENDOR.equals("MYSQL"))
					{
						sql.append(sm.addFix("    AND UPPER(AUTHO_OBJECT_CODE) LIKE  CONCAT('%',UPPER(?),'%') "));
					}

					sm.addParameter(strValue);
				}
				else if (strKindOfPrc.equals("USR"))
				{
					if (SEPOA_DB_VENDOR.equals("ORACLE"))
					{
						sql.append(sm.addFix("    AND UPPER(USER_ID) LIKE  '%'||UPPER(?)||'%' "));
					}
					else if (SEPOA_DB_VENDOR.equals("MYSQL"))
					{
						sql.append(sm.addFix("    AND UPPER(USER_ID) LIKE  CONCAT('%',UPPER(?),'%') "));
					}

					sm.addParameter(strValue);
				}
			}
			else
			{
			}
			sql.append(sm.addSelectString(" AND HOUSE_CODE = ? "));
			sm.addStringParameter(houseCode);
			
			sql.append("    ORDER BY PROCESS_ID \n ");

			rtn[0] = sm.doSelect(sql.toString());

			if (rtn[0] == null)
			{
				rtn[1] = "SQL manager is Null";
			}
		}
		catch (Exception e)
		{
			printDebug(wi, e.toString());
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
				printDebug(info, e.toString());
			}
		}

		return rtn;
	}

	public SepoaOut insertFwrs(String[][] straData)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processInsertFwrs(straData);

			if (straResult[1] != null)
			{
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
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

	private String[] processInsertFwrs(String[][] setData) throws Exception
	{
		String[] straResult = new String[2];
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		String user_id = info.getSession("ID");
		String user_name1 = info.getSession("NAME_LOC");
		String user_name2 = info.getSession("NAME_ENG");
		String user_dept = info.getSession("DEPARTMENT");
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();
		ConnectionContext ctx = getConnectionContext();

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();

			for (int i = 0; i < setData.length; i++)
			{
				

				String house_code  = setData[i][0];		//PK
				String process_id	= setData[i][1];		//PK
				String method		= setData[i][2];		//PK
				String url			= setData[i][3];		
				String service_class= setData[i][4];		
				String use_flag		= setData[i][5];		
				String description	= setData[i][6];		
				String autho_apply_flag	 = setData[i][7];		
				String autho_object_code = setData[i][8];		
				String start_date 	= setData[i][9];		
				String end_date 	= setData[i][10];
				Logger.debug.print("process_id===>"+process_id);
				sm.removeAllValue();
				tSQL.delete(0, tSQL.length());
				tSQL.append("SELECT COUNT(*) FROM sfrwk \n");
				tSQL.append(sm.addSelect("WHERE house_code = ? \n"));sm.addParameter(house_code);
				tSQL.append(sm.addSelect("  AND process_id = ? \n"));sm.addParameter(process_id);
				tSQL.append(sm.addSelect("  AND method = ? \n"));sm.addParameter(method);
				
				String rtn = sm.doSelect(tSQL.toString());
				Logger.debug.print(tSQL.toString());
				
				
				SepoaFormater sf = new SepoaFormater(rtn);
				
				int count = Integer.parseInt(sf.getValue(0,0));
				
				if( count > 0 )
				{
					straResult[1] = "HOUSE_CODE : " + house_code + " PROCESS ID : "+ process_id + ", METHOD : "+method +" 는 이미 등록 되었습니다.\n 수정이나 삭제를 하여 주십시오.";
					return straResult;
					
				}
				sm.removeAllValue();
				tSQL.delete(0, tSQL.length());

				tSQL.append("INSERT INTO sfrwk (\n");
				tSQL.append("  HOUSE_CODE		\n");
				tSQL.append(", PROCESS_ID		\n");
				tSQL.append(", METHOD			\n");
				tSQL.append(", URL				\n");
				tSQL.append(", SERVICE_CLASS	\n");
				tSQL.append(", USE_FLAG			\n");
				tSQL.append(", DESCRIPTION		\n");
				tSQL.append(", AUTHO_APPLY_FLAG	\n");
				tSQL.append(", AUTHO_OBJECT_CODE\n");
				tSQL.append(", START_DATE		\n");
				tSQL.append(", END_DATE			\n");
						
				tSQL.append(", USER_ID			\n");
				tSQL.append(", ADD_DATE			\n");
				tSQL.append(", ADD_TIME			\n");
				tSQL.append(", VERSION)			\n");				
				tSQL.append(" values \n ");
				tSQL.append(" ( \n ");
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(house_code);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(process_id);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(method);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(url);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(service_class);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(use_flag);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(description);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(autho_apply_flag);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(autho_object_code);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(start_date);
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(end_date);
				
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(info.getSession("ID"));
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(SepoaDate.getShortDateString());
				tSQL.append(" 	?,	 \n "); sm.addStringParameter(SepoaDate.getShortTimeString());
				tSQL.append("   ?    \n "); sm.addStringParameter("1.0.0");
				tSQL.append(" )	 \n ");
				
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
				printDebug(info, e.toString());
			}
		}

		return straResult;
	}

	public SepoaOut deleteInsertFwrs(SepoaInfo wi, String[][] straData)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processDeleteInsertFwrs(wi, straData);

			if (straResult[1] != null)
			{
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
			}

			setValue(straResult[0]);
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] processDeleteInsertFwrs(SepoaInfo wi, String[][] straData) throws Exception
	{
		String[] straResult = new String[2];
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		ConnectionContext ctx = getConnectionContext();

		try
		{
			String strId = wi.getSession("ID");
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer strbufSQL = new StringBuffer();

			for (int i = 0; i < straData.length; i++)
			{

				
				String house_code  = straData[i][0];		//PK
				String process_id	= straData[i][1];		//PK
				String method		= straData[i][2];		//PK
				String url			= straData[i][3];		
				String service_class= straData[i][4];		
				String use_flag		= straData[i][5];		
				String description	= straData[i][6];		
				String autho_apply_flag	 = straData[i][7];		
				String autho_object_code = straData[i][8];		
				String start_date 	= straData[i][9];		
				String end_date 	= straData[i][10];
				
				sm.removeAllValue();
				strbufSQL.delete(0, strbufSQL.length());
				strbufSQL.append("DELETE FROM sfrwk \n");
				strbufSQL.append("WHERE PROCESS_ID = ?\n"); sm.addParameter(process_id);
				strbufSQL.append("  AND METHOD = ? \n"); sm.addParameter(method);
				strbufSQL.append("  AND HOUSE_CODE = ? \n"); sm.addParameter(house_code);
				
			
				sm.doDelete(strbufSQL.toString());
				
				sm.removeAllValue();
				strbufSQL.delete(0, strbufSQL.length());

				strbufSQL.append("INSERT INTO sfrwk (\n");
				strbufSQL.append("  HOUSE_CODE 		\n");
				strbufSQL.append(", PROCESS_ID		\n");
				strbufSQL.append(", METHOD			\n");
				strbufSQL.append(", URL				\n");
				strbufSQL.append(", SERVICE_CLASS	\n");
				strbufSQL.append(", USE_FLAG		\n");
				strbufSQL.append(", DESCRIPTION		\n");
				strbufSQL.append(", AUTHO_APPLY_FLAG	\n");
				strbufSQL.append(", AUTHO_OBJECT_CODE\n");
				strbufSQL.append(", START_DATE		\n");
				strbufSQL.append(", END_DATE		\n");
						
				strbufSQL.append(", USER_ID			\n");
				strbufSQL.append(", ADD_DATE		\n");
				strbufSQL.append(", ADD_TIME		\n");
				strbufSQL.append(", VERSION)		\n");				
				strbufSQL.append(" values \n ");
				strbufSQL.append(" ( \n ");
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(house_code);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(process_id);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(method);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(url);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(service_class);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(use_flag);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(description);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(autho_apply_flag);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(autho_object_code);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(start_date);
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(end_date);
				
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(info.getSession("ID"));
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(SepoaDate.getShortDateString());
				strbufSQL.append(" 	?,	 \n "); sm.addStringParameter(SepoaDate.getShortTimeString());
				strbufSQL.append("   ?    \n "); sm.addStringParameter("1.0.0");
				strbufSQL.append(" )	 \n ");
				
				sm.doInsert(strbufSQL.toString());
	
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
				printDebug(info, e.toString());
			}
		}

		return straResult;
	}

	public SepoaOut updateFwrs(SepoaInfo wi, String[][] straData)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processUpdateFwrs(wi, straData);

			if (straResult[1] != null)
			{
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
			}

			setValue(straResult[0]);
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] processUpdateFwrs(SepoaInfo wi, String[][] straData) throws Exception
	{
		String[] straResult = new String[2];
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		ConnectionContext ctx = getConnectionContext();

		String user_id = wi.getSession("ID");

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer strbufSQL = new StringBuffer();

			for (int i = 0; i < straData.length; i++)
			{

				String house_code = straData[i][0];		//PK
				String process_id	= straData[i][1];		//PK
				String method		= straData[i][2];		//PK
				String url			= straData[i][3];		
				String service_class= straData[i][4];		
				String use_flag		= straData[i][5];		
				String description	= straData[i][6];		
				String autho_apply_flag	 = straData[i][7];		
				String autho_object_code = straData[i][8];		
				String start_date 	= straData[i][9];		
				String end_date 	= straData[i][10];
				
				
				sm.removeAllValue();
				strbufSQL.delete(0, strbufSQL.length());
				strbufSQL.append("UPDATE sfrwk SET USE_FLAG = ?"); sm.addParameter(use_flag);
				strbufSQL.append("               , DESCRIPTION = ?"); sm.addParameter(description);
				strbufSQL.append("               , AUTHO_APPLY_FLAG = ?"); sm.addParameter(autho_apply_flag);
				strbufSQL.append("               , AUTHO_OBJECT_CODE = ?"); sm.addParameter(autho_object_code);
				strbufSQL.append("               , START_DATE = ? "); sm.addParameter(start_date);
				strbufSQL.append("               , END_DATE = ? "); sm.addParameter(end_date);
				strbufSQL.append("WHERE PROCESS_ID = ? "); sm.addParameter(process_id);
				strbufSQL.append("  AND METHOD = ?"); sm.addParameter(method);
				strbufSQL.append("  AND HOUSE_CODE = ?"); sm.addParameter(house_code);
				
			
				sm.doUpdate(strbufSQL.toString());
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
				printDebug(info, e.toString());
			}
		}

		return straResult;
	}

	public SepoaOut deleteFwrs(SepoaInfo wi, String[][] straDeleteKey)
	{
		String[] straResult = null;
		setFlag(true);
		setMessage("Success.");

		try
		{
			straResult = processDeleteFwrs(wi, straDeleteKey);

			if (straResult[1] != null)
			{
				setFlag(false);
				setMessage(straResult[1]);
				setStatus(1);
			}

			setValue(straResult[0]);
		}
		catch (Exception e)
		{
			setFlag(false);
			setMessage(e.getMessage());
		}

		return getSepoaOut();
	}

	private String[] processDeleteFwrs(SepoaInfo wi, String[][] straDeleteKey) throws Exception
	{
		String[] straResult = new String[2];
		StringBuffer sb = new StringBuffer();
		setFlag(true);
		setMessage("Success.");

		ConnectionContext ctx = getConnectionContext();

		String user_id = wi.getSession("ID");

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer strbufSQL = new StringBuffer();

			for (int i = 0; i < straDeleteKey.length; i++)
			{
				
				String house_code = straDeleteKey[i][0];		//PK
				String process_id	= straDeleteKey[i][1];		//PK
				String method		= straDeleteKey[i][2];		//PK
				
				
				
				sm.removeAllValue();
				strbufSQL.delete(0, strbufSQL.length());
				strbufSQL.append("DELETE FROM sfrwk ");
				strbufSQL.append("WHERE PROCESS_ID = ? ");
				strbufSQL.append(" 	AND   METHOD = ? ");
				strbufSQL.append(" 	AND   HOUSE_CODE = ? ");
				sm.addParameter(process_id);
				sm.addParameter(method);
				sm.addParameter(house_code);
				
				sm.doDelete(strbufSQL.toString());
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
				printDebug(info, e.toString());
			}
		}

		return straResult;
	}
}
