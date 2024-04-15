package sepoa.svc.admin;

import java.util.StringTokenizer;

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
import sepoa.fw.util.SepoaString;

public class AD_021 extends SepoaService
{
	public AD_021(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}

	/**
	 * 조회
	 * */
	public SepoaOut selectMenuMuhd(String menu_name, String module_type, String menu_object_code)
	{

		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = processSelectMenuMuhd(menu_name, module_type, menu_object_code);

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

	/**
	 * et_FindMUHD
	 * */
	private String[] processSelectMenuMuhd(String strMenuName, String strModuleType, String strMenuObjectCode) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();
		String language = info.getSession("LANGUAGE");
		String user_id = info.getSession("ID");

		try
		{
			String taskType = "CONNECTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sql.delete(0, sql.length());

			String inStr = "";

			if (!strMenuObjectCode.equals(""))
			{
				

				inStr = SepoaString.str2in(strMenuObjectCode, "$");
				/*inStr = changeDelim(strMenuObjectCode,"<");*/
				
			}

			boolean blCheck = false;
			sql.append("SELECT MENU_OBJECT_CODE, MENU_NAME, MODULE_TYPE, ");
			sql.append(sm.addFixString(" 	   MENU_LINK, case when " + DB_NULL_FUNCTION + "(USE_FLAG, 'N') in ('Y', '1') then '1' else '0' end use_flag, " + SEPOA_DB_OWNER + "GETUSERNAME(ADD_USER_ID, '000', ?) ADD_USER_ID, ADD_DATE,'Y' AS DB_FLAG,INIT_SCREEN_ID "));
			sm.addStringParameter(language);
			sql.append("FROM SMUGL ");

			if (((strMenuName != null) && !strMenuName.trim().equals("")) || ((strModuleType != null) && !strModuleType.trim().equals("")) || (((strMenuObjectCode != null) && !strMenuObjectCode.trim().equals("")) && !inStr.equals("")))
			{
				sql.append("WHERE   ");
				sql.append(sm.addSelectString(" 	UPPER(MODULE_TYPE) = ? "));
				sm.addStringParameter(strModuleType);

				if ((strModuleType != null) && (strModuleType.length() > 0))
				{
					blCheck = true;
				}

				if (!inStr.equals(""))
				{
					if (blCheck)
					{
						sql.append("	AND MENU_OBJECT_CODE IN ( ").append(inStr).append(" ) AND USE_FLAG = 'Y' ");
					}
					else
					{
						sql.append("	MENU_OBJECT_CODE IN ( ").append(inStr).append(" ) AND USE_FLAG = 'Y' ");

						blCheck = true;
					}
				}

				if (blCheck)
				{
					if (SEPOA_DB_VENDOR.equals("ORACLE"))
					{
						sql.append(sm.addSelectString("	AND UPPER(MENU_NAME) LIKE  '%' || UPPER(?) || '%' "));
						sm.addStringParameter(strMenuName);
					}
					else if (SEPOA_DB_VENDOR.equals("MYSQL"))
					{
						sql.append(sm.addSelectString("	 AND UPPER(MENU_NAME) LIKE  upper(concat('%', ?, '%')) "));
						sm.addStringParameter(strMenuName);
					}
				}
				else
				{
					if (SEPOA_DB_VENDOR.equals("ORACLE"))
					{
						sql.append(sm.addSelectString("	UPPER(MENU_NAME) LIKE  '%' || UPPER(?) || '%' "));
						sm.addStringParameter(strMenuName);
					}
					else if (SEPOA_DB_VENDOR.equals("MYSQL"))
					{
						sql.append(sm.addSelectString("	UPPER(MENU_NAME) LIKE  upper(concat('%', ?, '%')) "));
						sm.addStringParameter(strMenuName);
					}
				}
			}

			sql.append(" \n  order by menu_object_code desc \n ");

			rtn[0] = sm.doSelect(sql.toString());
			

			if (rtn[0] == null)
			{
				rtn[1] = "SQL manager is Null";
			}
		}
		catch (Exception e)
		{
			Logger.debug.println(info.getSession("ID"), this, "=------------------ error.");
			rtn[1] = e.getMessage();
		}
		finally
		{
		}

		return rtn;
	}

	/**
	 * 입력
	 * */
	public SepoaOut insertMenuMuhd(String[][] setData)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = processInsertMenuMuhd(setData);

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

	/**
	 * et_CreateMUHD
	 * */
	private String[] processInsertMenuMuhd(String[][] straData) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		String user_id = info.getSession("ID");

		String user_name1 = info.getSession("NAME_LOC");
		String user_name2 = info.getSession("NAME_ENG");
		String user_dept = info.getSession("DEPARTMENT");
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();

		try
		{
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			String menu_name = "";
			String module_type = "";
			String menu_link = "";
			String use_flag = "";
			String init_screen_id = "";

			for (int a = 0; a < straData.length; a++)
			{
				sm.removeAllValue();
				sb.delete(0, sb.length());
				SepoaOut wo = DocumentUtil.getDocNumber(info,"MUO","H");
				String menu_object_code = "";

				if(wo.status == 1)
	            {
	            	menu_object_code = wo.result[0];
	            }
	            else
	            {
	            	menu_object_code = "M" + SepoaString.replace(SepoaString.replace(SepoaDate.getTimeStampString(), ":", ""), "-", "");
	            }

				menu_name = straData[a][0];
				module_type = straData[a][1];
				menu_link = straData[a][2];
				use_flag = straData[a][3];
				init_screen_id = straData[a][4];

				sb.append(" insert into smugl 		\n ");
				sb.append(" 	(MENU_OBJECT_CODE,  \n ");
				sb.append(" 	ADD_DATE,           \n ");
				sb.append(" 	ADD_TIME,           \n ");
				sb.append(" 	ADD_USER_ID,        \n ");
				sb.append(" 	MENU_NAME,          \n ");
				sb.append(" 	MODULE_TYPE,        \n ");
				sb.append(" 	MENU_LINK,          \n ");
				sb.append(" 	MENU_LINK_FLAG,     \n ");
				sb.append(" 	USE_FLAG,           \n ");
				sb.append(" 	DEL_FLAG,           \n ");
				sb.append(" 	INIT_SCREEN_ID      \n ");
				sb.append(" 	)                   \n ");
				sb.append(" values ( \n ");
				sb.append("   ?, \n "); sm.addParameter(menu_object_code);
				sb.append("   ?, \n "); sm.addParameter(SepoaDate.getShortDateString());
				sb.append("   ?, \n "); sm.addParameter(SepoaDate.getShortTimeString());
				sb.append("   ?, \n "); sm.addParameter(user_id);
				sb.append("   ?, \n "); sm.addParameter(menu_name);
				sb.append("   ?, \n "); sm.addParameter(module_type);
				sb.append("   ?, \n "); sm.addParameter(menu_link);
				sb.append("   ?, \n "); sm.addParameter("Y");
				sb.append("   case when " + DB_NULL_FUNCTION + "(?, 'N') in ('Y', '1') then 'Y' else 'N' end, \n "); sm.addParameter(use_flag);
				sb.append("   ?, \n "); sm.addParameter("N");
				sb.append("   ?  \n "); sm.addParameter(init_screen_id);
				sb.append(" ) \n ");
				sm.doInsert(sb.toString());
				/*
				strbufSql.append(" INSERT INTO SMUGL (MENU_OBJECT_CODE,MENU_NAME,");
				strbufSql.append(" MODULE_TYPE,MENU_LINK,MENU_LINK_FLAG,");
				strbufSql.append(" USE_FLAG,ADD_DATE,ADD_TIME,ADD_USER_ID,");
				strbufSql.append(" ADD_USER_DEPT,ADD_USER_NAME_ENG,ADD_USER_NAME_LOC,INIT_SCREEN_ID) ");
				strbufSql.append(" VALUES('M' || TO_CHAR(SYSDATE, 'YYMM') || MOLDMUHD_SEQ.NEXTVAL,?,?,?,'Y',?, ");
				strbufSql.append(" '" + cur_date + "','" + cur_time + "','" + user_id + "','" + user_dept + "','" + user_name2 + "','" + user_name1 + "',?) ");
				sm.addParameter();
				sm.addParameter(straData[a][1]);
				sm.addParameter(straData[a][2]);
				sm.addParameter(straData[a][3]);
				sm.addParameter(straData[a][4]);
				sm.doUpdate(strbufSql.toString());
				*/
			}

			Commit();

			/*
			strbufSql.append(" INSERT INTO ICOMMUHD( MENU_OBJECT_CODE,MENU_NAME,");
			strbufSql.append(" MODULE_TYPE,MENU_LINK,MENU_LINK_FLAG,");
			strbufSql.append(" USE_FLAG,ADD_DATE,ADD_TIME,ADD_USER_ID,");
			strbufSql.append(" ADD_USER_DEPT,ADD_USER_NAME_ENG,ADD_USER_NAME_LOC) ");
			strbufSql.append(" VALUES(?,?,?,?,'Y',?, ");
			strbufSql.append(" '"+cur_date+"','"+cur_time+"','"+user_id+"','"+user_dept+"','"+user_name2+"','"+user_name1+"') ");
			WiseSQLManager sm = new WiseSQLManager(user_id,this,ctx,strbufSql.toString());

			String[] type = {"S","S","S","S","S"};
			rtn = sm.doInsert(setData, type);
			Commit();*/
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
			
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}

	public SepoaOut deleteMenuMu(String[][] menu_object_code)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = processDeleteMu(menu_object_code);

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

	/**
	 * et_RemoveMUHD
	 * */
	private String[] processDeleteMu(String[][] straData) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String user_id = info.getSession("ID");

		try
		{
			String house_code = info.getSession("HOUSE_CODE");
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			StringBuffer strbufSql = new StringBuffer();

			for (int a = 0; a < straData.length; a++)
			{
				sm.removeAllValue();
				strbufSql.delete(0, strbufSql.length());
				strbufSql.append("DELETE FROM SMUGL ");
				strbufSql.append("WHERE  ");
				strbufSql.append(" 	MENU_OBJECT_CODE = ? ");
				sm.addParameter(straData[a][0]);
				sm.doDelete(strbufSql.toString());
			}

			sm.removeAllValue();
			strbufSql.delete(0, strbufSql.length());

			for (int a = 0; a < straData.length; a++)
			{
				sm.removeAllValue();
				strbufSql.delete(0, strbufSql.length());
				strbufSql.append("DELETE FROM SMULN ");
				strbufSql.append("WHERE  ");
				strbufSql.append("	MENU_OBJECT_CODE = ? ");
				sm.addParameter(straData[a][0]);
				sm.doDelete(strbufSql.toString());
			}

			sm.removeAllValue();
			strbufSql.delete(0, strbufSql.length());

			for (int a = 0; a < straData.length; a++)
			{
				sm.removeAllValue();
				strbufSql.delete(0, strbufSql.length());
				strbufSql.append("DELETE FROM SMUGL ");
				strbufSql.append("WHERE   ");
				strbufSql.append("	MENU_OBJECT_CODE = ? ");
				sm.addParameter(straData[a][0]);
				sm.doDelete(strbufSql.toString());
			}

			Commit();

		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
			
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}

	/**
	 * et_RemoveMUDT
	 * */

	/*private int et_RemoveMUDT(String house_code,String user_id,String[][] menu_object_code) throws Exception
	{

	        int rtn = -1;
	           ConnectionContext ctx = getConnectionContext();

	    try {

	                        StringBuffer tSQL = new StringBuffer();
	                        tSQL.append(" DELETE FROM ICOMMUDT ");
	                        tSQL.append(" WHERE  HOUSE_CODE = '"+house_code+"' " );
	                        tSQL.append(" AND    MENU_OBJECT_CODE = ? " );

	                        WiseSQLManager sm = new WiseSQLManager(user_id,this,ctx,tSQL.toString());

	                        String[] type = {"S"};
	                        rtn = sm.doDelete(menu_object_code, type);
	                        Commit();
	    }catch(Exception e) {
	                    Rollback();
	                        throw new Exception("et_DeleteMUDT:"+e.getMessage());
	        }

	        return rtn;

	}*/

	/**
	 * et_RemoveMUPD
	 * */

	/*private int et_RemoveMUPD(String house_code,String user_id,String[][] menu_object_code) throws Exception
	{

	        int rtn = -1;
	           ConnectionContext ctx = getConnectionContext();

	    try {

	                        StringBuffer tSQL = new StringBuffer();
	                        tSQL.append(" DELETE FROM ICOMMUPD ");
	                        tSQL.append(" WHERE  HOUSE_CODE = '"+house_code+"' " );
	                        tSQL.append(" AND    MENU_OBJECT_CODE = ? " );

	                        WiseSQLManager sm = new WiseSQLManager(user_id,this,ctx,tSQL.toString());

	                        String[] type = {"S"};
	                        rtn = sm.doDelete(menu_object_code, type);
	                        Commit();
	    }catch(Exception e) {
	                    Rollback();
	                        throw new Exception("et_DeleteMUPD:"+e.getMessage());
	        }

	        return rtn;

	}*/
	public SepoaOut updateMenuMuhd(String[][] setData)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = processUpdateMenuMuhd(setData);

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

	/**
	 * et_SetMUHD
	 * */
	private String[] processUpdateMenuMuhd(String[][] straData) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer strbufSql = new StringBuffer();
		String user_id = info.getSession("ID");

		try
		{

			String user_name1 = info.getSession("NAME_LOC");
			String user_name2 = info.getSession("NAME_ENG");
			String user_dept = info.getSession("DEPARTMENT");
			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			String menu_object_code = "";
			String menu_name = "";
			String module_type = "";
			String menu_link = "";
			String use_flag = "";
			String init_screen_id = "";

			for (int a = 0; a < straData.length; a++)
			{
				menu_object_code = straData[a][4];
				menu_name = straData[a][0];
				module_type = straData[a][1];
				menu_link = straData[a][2];
				use_flag = straData[a][3];
				init_screen_id = straData[a][5];

				sm.removeAllValue();
				strbufSql.delete(0, strbufSql.length());
				strbufSql.append(" UPDATE	SMUGL SET MENU_NAME = ? ,  \n"); sm.addParameter(menu_name);
				strbufSql.append(" 				     MODULE_TYPE = ?, \n"); sm.addParameter(module_type);
				strbufSql.append(" 				     MENU_LINK = ?, \n"); sm.addParameter(menu_link);
				strbufSql.append(" 				     USE_FLAG = case when " + DB_NULL_FUNCTION + "(?, 'N') in ('Y', '1') then 'Y' else 'N' end, \n"); sm.addParameter(use_flag);
				strbufSql.append(" 				     INIT_SCREEN_ID = ?, \n"); sm.addParameter(init_screen_id);
				strbufSql.append(" 					 ADD_DATE = ?, \n"); sm.addParameter(cur_date);
				strbufSql.append(" 					 ADD_TIME = ? , \n"); sm.addParameter(cur_time);
				strbufSql.append(" 					 ADD_USER_ID = ? \n"); sm.addParameter(user_id);
				strbufSql.append(" 			WHERE MENU_OBJECT_CODE = ? "); sm.addParameter(menu_object_code);

				sm.doUpdate(strbufSql.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
			
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}

	public SepoaOut copyMenu(String menu_object_code)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = processCopyMenu(menu_object_code);

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

	/**
	 * et_CopyMenu
	 * */
	private String[] processCopyMenu(String menu_object_code) throws Exception
	{
		String[] straResult = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String user_id = info.getSession("ID");
		
		try
		{
			String user_name1 = info.getSession("NAME_LOC");
			String user_name2 = info.getSession("NAME_ENG");
			String user_dept = info.getSession("DEPARTMENT");
			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();
			String new_menu_object_code = "";

            SepoaOut wo = DocumentUtil.getDocNumber(info,"MUO","H");
			//menu_object_code = "M" + SepoaString.replace(SepoaString.replace(SepoaDate.getTimeStampString(), ":", ""), "-", "");
            if(wo.status == 1)
            {
            	new_menu_object_code = wo.result[0];
            }
            else
            {
            	new_menu_object_code = "M" + SepoaString.replace(SepoaString.replace(SepoaDate.getTimeStampString(), ":", ""), "-", "");
            }

			StringBuffer strbufSql = new StringBuffer();

			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			strbufSql.delete(0, strbufSql.length());

			strbufSql.append(" INSERT INTO SMUGL ( \n");
			strbufSql.append(" ADD_DATE,  \n");
			strbufSql.append(" ADD_TIME,  \n");
			strbufSql.append(" MENU_OBJECT_CODE, \n");
			strbufSql.append(" MENU_NAME, \n");
			strbufSql.append(" MODULE_TYPE,  \n");
			strbufSql.append(" MENU_LINK,  \n");
			strbufSql.append(" MENU_LINK_FLAG,  \n");
			strbufSql.append(" USE_FLAG,  \n");
			strbufSql.append(" ORDER_SEQ,  \n");
			strbufSql.append(" ADD_USER_ID)  \n");
			strbufSql.append(" SELECT \n");
			strbufSql.append(" ?, \n");
			sm.addParameter(SepoaDate.getShortDateString());

			strbufSql.append(" ?, \n");
			sm.addParameter(SepoaDate.getShortTimeString());

			strbufSql.append(" ?, \n ");
			sm.addParameter(new_menu_object_code);

			strbufSql.append(" MENU_NAME, MODULE_TYPE, MENU_LINK, MENU_LINK_FLAG, USE_FLAG, ORDER_SEQ, \n ");

			strbufSql.append(" ? \n");
			sm.addParameter(user_id);

			strbufSql.append(" FROM SMUGL \n");
			strbufSql.append(" WHERE \n");
			strbufSql.append(" MENU_OBJECT_CODE = ? \n"); sm.addParameter(menu_object_code);

			sm.doInsert(strbufSql.toString());

			sm.removeAllValue();
			strbufSql.delete(0, strbufSql.length());

			strbufSql.append(" INSERT INTO SMULN ( \n");
			strbufSql.append(" ADD_DATE, \n");
			strbufSql.append(" ADD_TIME, \n");
			strbufSql.append(" MENU_OBJECT_CODE, \n");
			strbufSql.append(" MENU_FIELD_CODE, \n");
			strbufSql.append(" MENU_PARENT_FIELD_CODE, \n");
			strbufSql.append(" ORDER_SEQ, \n");
			strbufSql.append(" MENU_NAME, \n");
			strbufSql.append(" SCREEN_ID, \n");
			strbufSql.append(" MENU_LINK_FLAG, \n");
			strbufSql.append(" CHILD_FLAG, \n");
			strbufSql.append(" USE_FLAG, \n");
			strbufSql.append(" ADD_USER_ID) \n");


			strbufSql.append(" SELECT \n");
			strbufSql.append(" ?, \n");
			sm.addParameter(SepoaDate.getShortDateString());

			strbufSql.append(" ?, \n");
			sm.addParameter(SepoaDate.getShortTimeString());

			strbufSql.append(" ?, \n ");
			sm.addParameter(new_menu_object_code);

			strbufSql.append(" MENU_FIELD_CODE, MENU_PARENT_FIELD_CODE, ORDER_SEQ, MENU_NAME, SCREEN_ID, MENU_LINK_FLAG, CHILD_FLAG, USE_FLAG, \n");

			strbufSql.append(" ? \n");
			sm.addParameter(user_id);

			strbufSql.append(" FROM SMULN \n");
			strbufSql.append(" WHERE \n");
			strbufSql.append(" MENU_OBJECT_CODE = ? \n"); sm.addParameter(menu_object_code);

			sm.doInsert(strbufSql.toString());

			Commit();


		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
			
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}

	public String changeDelim(String str1, String str2)
	{
		String s2 = "";
		StringTokenizer st = new StringTokenizer(str1, str2);

		/*WiseStringTokenizer wisestringtokenizer = new WiseStringTokenizer(s, s1, false);*/
		int i = st.countTokens();
		String[] as = new String[i];

		for (int j = 0; j < i; j++)
		{
			as[j] = st.nextToken().trim();

			if (j == 0)
			{
				s2 = "'" + as[j] + "'";
			}
			else
			{
				s2 = s2 + ",'" + as[j] + "'";
			}
		}

		return s2;
	}
}
