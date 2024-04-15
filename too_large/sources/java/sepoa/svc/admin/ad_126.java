/*jadclipse*/
// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) ansi radix(10) lradix(10)
// Source File Name:   AD_126.java
package sepoa.svc.admin;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;

import sepoa.fw.log.Logger;
import sepoa.fw.log.LoggerWriter;

import sepoa.fw.msg.Message;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.*;

import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;


public class AD_126 extends SepoaService
{
    Message msg;

    public AD_126(String opt, SepoaInfo info) throws SepoaServiceException
    {
        super(opt, info);
        msg = new Message(info, "FW");
        setVersion("1.0.0");
    }

    public SepoaOut getMainternace(String DEPT, String I_COMPANY_CODE, String DEPT_NAME_LOC, String DEPT_NAME_ENG, String PR_LOCATION_NAME, String PR_LOCATION)
    {
        try
        {
            String user_id = info.getSession("ID");
            Logger.debug.println(user_id, this, "######getMainternace#######");

            String rtn = "";
            rtn = et_getMainternace(DEPT, I_COMPANY_CODE, DEPT_NAME_LOC, DEPT_NAME_ENG, PR_LOCATION_NAME, PR_LOCATION);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            Logger.err.println((new StringBuilder("Exception e =")).append(e.getMessage()).toString());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(this, e.getMessage());
        }

        return getSepoaOut();
    }

    private String et_getMainternace(String DEPT, String I_COMPANY_CODE, String DEPT_NAME_LOC, String DEPT_NAME_ENG, String PR_LOCATION_NAME, String PR_LOCATION) throws Exception
    {
        String rtn = "";
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        sm.removeAllValue();

        try
        {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" SELECT DEPT                                   \t\n");
            tSQL.append("      , DEPT_NAME_LOC                               \n");
            tSQL.append("      , DEPT_NAME_ENG                               \n");
            tSQL.append((new StringBuilder("      , ")).append(SEPOA_DB_OWNER).append("GETCODETEXT2('M062',PR_LOCATION, '" + info.getSession("LANGUAGE") + "') AS PR_LOCATION_NAME\t\n").toString());
            tSQL.append("      , PR_LOCATION                            \n");
            tSQL.append(" FROM  icomogdp WHERE                                \n");
            tSQL.append((new StringBuilder("  ")).append(DB_NULL_FUNCTION).append("(DEL_FLAG, 'N') = 'N'                       \n").toString());

            if (I_COMPANY_CODE.length() > 0)
            {
                tSQL.append((new StringBuilder(" AND COMPANY_CODE = '")).append(I_COMPANY_CODE).append("'       \n").toString());
            }

            if (PR_LOCATION.length() > 0)
            {
                tSQL.append((new StringBuilder(" AND PR_LOCATION = '")).append(PR_LOCATION).append("'           \n").toString());
            }

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                if (DEPT.length() > 0)
                {
                    tSQL.append((new StringBuilder(" AND DEPT LIKE '%' || UPPER('")).append(DEPT).append("') || '%'   \n").toString());
                }

                if ((DEPT_NAME_LOC.length() > 0) || (DEPT_NAME_ENG.length() > 0))
                {
                    tSQL.append((new StringBuilder(" AND  DEPT_NAME_LOC LIKE '%' || UPPER('")).append(DEPT_NAME_LOC).append("') || '%' OR DEPT_NAME_ENG LIKE '%' || '").append(DEPT_NAME_ENG).append("' || '%'  \n").toString());
                }
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                if (DEPT.length() > 0)
                {
                    tSQL.append((new StringBuilder(" AND DEPT LIKE UPPER(CONCAT('%' , '")).append(DEPT).append("' , '%'))   \n").toString());
                }

                if ((DEPT_NAME_LOC.length() > 0) || (DEPT_NAME_ENG.length() > 0))
                {
                    tSQL.append((new StringBuilder(" AND  DEPT_NAME_LOC LIKE UPPER(CONCAT('%' , '")).append(DEPT_NAME_LOC).append("' , '%')) OR DEPT_NAME_ENG LIKE UPPER(CONCAT('%' , ").append(DEPT_NAME_ENG).append(" , '%'))  </OPT> \n").toString());
                }
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                if (DEPT.length() > 0)
                {
                    tSQL.append((new StringBuilder("AND DEPT LIKE UPPER('%''")).append(DEPT).append("''%')\n").toString());
                }

                if ((DEPT_NAME_LOC.length() > 0) || (DEPT_NAME_ENG.length() > 0))
                {
                    tSQL.append((new StringBuilder("AND  DEPT_NAME_LOC LIKE UPPER('%''")).append(DEPT_NAME_LOC).append("''%') OR DEPT_NAME_ENG LIKE UPPER('%''").append(DEPT_NAME_ENG).append("''%') \n").toString());
                }
            }

            rtn = sm.doSelect(tSQL.toString());

            if (rtn == null)
            {
                throw new Exception("SQL Manager is Null");
            }
        }
        catch (Exception e)
        {
            throw new Exception((new StringBuilder("et_getMainternace:")).append(e.getMessage()).toString());
        }

        return rtn;
    }

    public SepoaOut setSave(String[] setData) throws Exception
    {
        try
        {
            String user_id = info.getSession("ID");
            Logger.debug.println(user_id, this, "######setSave#######");

            int rtn = 1;
            int row = et_setSave(setData);
            setValue((new StringBuilder("Insert Row=")).append(rtn).toString());
            setStatus(1);
            setMessage(msg.getMessage("0000"));

            if (rtn == 1)
            {
                Commit();
            }
        }
        catch (Exception e)
        {
            Logger.err.println((new StringBuilder("Exception e =")).append(e.getMessage()).toString());
            setStatus(0);
            setMessage(msg.getMessage("0003"));
            Logger.err.println(this, e.getMessage());
            Rollback();
        }

        return getSepoaOut();
    }

    private int et_setSave(String[] setData) throws Exception
    {
        int rtn = -1;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        String user_id = info.getSession("ID");

        try
        {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" INSERT INTO icomogdp\n");
            tSQL.append(" (                        \n");
            tSQL.append("  COMPANY_CODE       \n");
            tSQL.append(" ,DEPT               \n");
            tSQL.append(" ,DEPT_NAME_LOC      \n");
            tSQL.append(" ,DEPT_NAME_ENG      \n");
            tSQL.append(" ,MANAGER_NAME       \n");
            tSQL.append(" ,MANAGER_POSITION   \n");
            tSQL.append(" ,PR_LOCATION        \n");
            tSQL.append(" ,MENU_PROFILE_CODE  \n");
            tSQL.append(" ,CTRL_DEPT_FLAG     \n");
            tSQL.append(" ,PHONE_NO           \n");
            tSQL.append(" ,FAX_NO             \n");
            tSQL.append(" ,MENU_TYPE          \n");
            tSQL.append(" ,SIGN_ATTACH_NO     \n");
            tSQL.append(" ,DEL_FLAG           \n");
            tSQL.append(" ,ADD_DATE           \n");
            tSQL.append(" ,ADD_TIME           \n");
            tSQL.append(" ,ADD_USER_ID        \n");
            tSQL.append(" )                        \n");
            tSQL.append(" VALUES                   \n");
            tSQL.append(" (                        \n");
            tSQL.append("  ?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" ,?                  \n");
            tSQL.append(" )                        \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            String[] type =
            {
                "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
                "S", "S", "S", "S"
            };
            String[][] tmp = new String[1][];
            tmp[0] = setData;
            rtn = sm.doInsert(tmp, type);

            if (rtn == -1)
            {
                throw new Exception("SQL Manager is Null");
            }
        }
        catch (Exception exception)
        {
        	Logger.err.println(this, exception.getMessage());
        }

        return rtn;
    }

    public SepoaOut setChange(String[] setData)
    {
        String user_id = info.getSession("ID");

        try
        {
            Logger.debug.println(user_id, this, "######setUpdate#######");

            String cur_date = SepoaDate.getShortDateString();
            String cur_time = SepoaDate.getShortTimeString();
            String status = "R";
            int rtn = et_setChange(setData, status, cur_date, cur_time, user_id);
            setValue((new StringBuilder("Change Row=")).append(rtn).toString());
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            Logger.err.println(user_id, this, (new StringBuilder("Exception e =")).append(e.getMessage()).toString());
            setStatus(0);
            setMessage(msg.getMessage("0002"));
        }

        return getSepoaOut();
    }

    private int et_setChange(String[] setData, String status, String cur_date, String cur_time, String user_id) throws Exception
    {
        int rtn = -1;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();

        try
        {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" UPDATE icomogdp\n");
            tSQL.append(" SET   DEPT_NAME_LOC  \t= ? \n");
            tSQL.append(" \t   , DEPT_NAME_ENG= ? \n");
            tSQL.append(" \t   , MANAGER_NAME= ? \n");
            tSQL.append(" \t   , MANAGER_POSITION\t= ? \n");
            tSQL.append(" \t   , PR_LOCATION= ? \n");
            tSQL.append(" \t   , MENU_PROFILE_CODE\t= ? \n");
            tSQL.append(" \t   , CTRL_DEPT_FLAG= ? \n");
            tSQL.append(" \t   , PHONE_NO\t= ? \n");
            tSQL.append(" \t   , FAX_NO= ? \n");
            tSQL.append(" \t   , MENU_TYPE\t= ? \n");
            tSQL.append(" \t   , SIGN_ATTACH_NO\t= ? \n");
            tSQL.append(" \t   , DEL_FLAG= ? \n");
            tSQL.append(" \t   , CHANGE_DATE= ? \n");
            tSQL.append(" \t   , CHANGE_TIME= ? \n");
            tSQL.append(" \t   , CHANGE_USER_ID= ? \n");
            tSQL.append("   WHERE COMPANY_CODE= ? \n");
            tSQL.append("   AND DEPT= ? \n");
            tSQL.append("   AND PR_LOCATION= ? \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            String[] type =
            {
                "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
                "S", "S", "S", "S", "S"
            };
            String[][] tmp = new String[1][];
            tmp[0] = setData;
            rtn = sm.doInsert(tmp, type);
            Commit();
        }
        catch (Exception e)
        {
            throw new Exception((new StringBuilder("et_setSave:")).append(e.getMessage()).toString());
        }

        return rtn;
    }

    public SepoaOut setDelete(String[][] setData) throws Exception
    {
        try
        {
            String user_id = info.getSession("ID");
            Logger.debug.println(user_id, this, "######setDelete#######");

            int rtn = 0;
            rtn = et_setDelete(setData);
            setValue((new StringBuilder("Delete Row=")).append(rtn).toString());
            setStatus(1);
            setMessage(msg.getMessage("0000"));
            Commit();
        }
        catch (Exception e)
        {
            Logger.err.println((new StringBuilder("Exception e =")).append(e.getMessage()).toString());
            setStatus(0);
            setMessage(msg.getMessage("0004"));
            Rollback();
            Logger.err.println(this, e.getMessage());
        }

        return getSepoaOut();
    }

    private int et_setDelete(String[][] setData) throws Exception
    {
        int rtn = -1;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        String user_id = info.getSession("ID");

        try
        {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" UPDATE icomogdp SET              \n");
            tSQL.append("     DEL_FLAG      = 'Y'              \n");
            tSQL.append("   , CHANGE_DATE = ?              \n");
            tSQL.append("   , CHANGE_TIME = ?              \n");
            tSQL.append("   , CHANGE_USER_ID = ?           \n");
            //            tSQL.append(" WHERE COMPANY_CODE = ?             \n");
            tSQL.append(" WHERE DEPT = ?                     \n");
            tSQL.append(" AND PR_LOCATION = ?              \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            String[] type = { "S", "S", "S", "S", "S" };
            rtn = sm.doInsert(setData, type);

            if (rtn == -1)
            {
                throw new Exception("SQL Manager is Null");
            }

            Commit();
        }
        catch (Exception e)
        {
            throw new Exception((new StringBuilder("et_setDelete:")).append(e.getMessage()).toString());
        }

        return rtn;
    }

    public SepoaOut getDis(String[] args)
    {
        try
        {
            String user_id = info.getSession("ID");
            Logger.debug.println(user_id, this, "######getDis#######");

            String rtn = "";
            rtn = getDis(args, user_id);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            Logger.err.println((new StringBuilder("Exception e =")).append(e.getMessage()).toString());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(this, e.getMessage());
        }

        return getSepoaOut();
    }

    private String getDis(String[] args, String user_id) throws Exception
    {
        String rtn = "";
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();

        try
        {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" SELECT                                 \n");
            tSQL.append("     DEPT_NAME_LOC                           \n");
            tSQL.append("   , DEPT                           \n");
            tSQL.append("   , '' SELECTED                           \n");
            tSQL.append("   , DEPT_NAME_ENG                           \n");
            tSQL.append("   , MANAGER_NAME                       \n");
            tSQL.append("   , MANAGER_POSITION                   \n");
            //tSQL.append("   , MANAGER_POSITION_NAME              \n");
            tSQL.append( "  , " + SEPOA_DB_OWNER + "getIcorCode1('C001', MANAGER_POSITION, '" + info.getSession("LANGUAGE") + "' ) MANAGER_POSITION_NAME  \n");
            tSQL.append("   , PR_LOCATION                        \n");
            //tSQL.append("   , PR_LOCATION_NAME                   \n");
            tSQL.append( "  , " + SEPOA_DB_OWNER + "getcodetext2('M062', PR_LOCATION, '" + info.getSession("LANGUAGE") + "' ) PR_LOCATION_NAME  \n");
            tSQL.append("   , MENU_PROFILE_CODE\t                 \n");
            tSQL.append("   , MENU_NAME                          \n");
            tSQL.append("   , CTRL_DEPT_FLAG                     \n");
            tSQL.append("   , PHONE_NO                           \n");
            tSQL.append("   , FAX_NO                             \n");
            tSQL.append("   , MENU_TYPE                          \n");
            tSQL.append("   , SIGN_ATTACH_NO                     \n");
            tSQL.append("   , SIGN_ATTACH_NO_COUNT               \n");
            tSQL.append(" FROM  DEPT_GENERAL_VW                  \n");
            tSQL.append(" <OPT=F,S> WHERE COMPANY_CODE = ? </OPT>  \n");
            tSQL.append(" <OPT=F,S> AND DEPT = ? </OPT>          \n");
            tSQL.append(" <OPT=F,S> AND PR_LOCATION = ? </OPT>   \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            rtn = sm.doSelect(args);

            if (rtn == null)
            {
                throw new Exception("SQL Manager is Null");
            }
        }
        catch (Exception e)
        {
            throw new Exception((new StringBuilder("et_getMainternace:")).append(e.getMessage()).toString());
        }

        return rtn;
    }

    public SepoaOut getDuplicate(String[] args)
    {
        String user_id = info.getSession("ID");
        String rtn = null;

        try
        {
            Logger.debug.println(user_id, this, "######getDuplicate#######");
            rtn = Check_Duplicate(args, user_id);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(user_id, this, (new StringBuilder("Exception e =")).append(e.getMessage()).toString());
        }

        return getSepoaOut();
    }

    private String Check_Duplicate(String[] args, String user_id) throws Exception
    {
        String rtn = null;
        String count = "";
        String[][] str = new String[1][2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();

        try
        {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" select DEL_FLAG \n");
            tSQL.append(" from icomogdp \n");
            tSQL.append(" <OPT=F,S> where company_code = ? </OPT> \n");
            tSQL.append(" <OPT=F,S> and dept = ? </OPT>        \n");
//            tSQL.append(" <OPT=F,S> and pr_location = ? </OPT> \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            rtn = sm.doSelect(args);

            SepoaFormater wf = new SepoaFormater(rtn);

            if (wf.getRowCount() == 0)
            {
                count = "X";
            }
            else
            {
                str = wf.getValue();
                count = str[0][0];
            }

            if (rtn == null)
            {
                throw new Exception("SQL Manager is Null");
            }
        }
        catch (Exception e)
        {
            throw new Exception((new StringBuilder("Check_Duplicate:")).append(e.getMessage()).toString());
        }

        return count;
    }
}
/***** DECOMPILATION REPORT *****

        DECOMPILED FROM: C:\Documents and Settings\cwb\바탕 화면\eclipse\workspace\Service/admin/AD_126.class


        TOTAL TIME: 31 ms


        JAD REPORTED MESSAGES/ERRORS:


        EXIT STATUS:        0


        CAUGHT EXCEPTIONS:

 ********************************/

//package sepoa.svc.admin;
//
//import sepoa.fw.approval.SignResponseInfo;
//
//import sepoa.fw.cfg.Configuration;
//import sepoa.fw.cfg.ConfigurationException;
//
//import sepoa.fw.db.ConnectionContext;
//import sepoa.fw.db.DBOpenException;
//import sepoa.fw.db.ParamSql;
//import sepoa.fw.db.SepoaSQLManager;
//
//import sepoa.fw.log.Logger;
//
//import sepoa.fw.msg.Message;
//
//import sepoa.fw.ses.SepoaInfo;
//
//import sepoa.fw.srv.SepoaOut;
//import sepoa.fw.srv.SepoaService;
//import sepoa.fw.srv.SepoaServiceException;
//
//import sepoa.fw.util.SepoaApproval;
//import sepoa.fw.util.SepoaDate;
//import sepoa.fw.util.SepoaFormater;
//
//import java.math.BigDecimal;
//
//import java.util.StringTokenizer;
//
//public class AD_126 extends SepoaService
//{
//
//	Message msg = new Message("KO", "FW");
//
//	public AD_126(String opt, SepoaInfo info) throws SepoaServiceException
//	{
//		super(opt, info);
//		setVersion("1.0.0");
//
//		Configuration configuration = null;
//
//		try
//		{
//			configuration = new Configuration();
//		}
//		catch (ConfigurationException cfe)
//		{
//			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
//		}
//		catch (Exception e)
//		{
//			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
//		}
//
//		SEPOA_DB_VENDOR = configuration.getString("sepoa.db.vendor");
//		SEPOA_DB_OWNER = configuration.getString("sepoa.db.owner") + ".";
//
//		if (SEPOA_DB_VENDOR.equals("ORACLE"))
//		{
//			DB_NULL_FUNCTION = "NVL";
//			SEPOA_DB_OWNER = "";
//		}
//		else if (SEPOA_DB_VENDOR.equals("MYSQL"))
//		{
//			DB_NULL_FUNCTION = "IFNULL";
//			SEPOA_DB_OWNER = "";
//		}
//		else if (SEPOA_DB_VENDOR.equals("MSSQL"))
//		{
//			DB_NULL_FUNCTION = "ISNULL";
//		}
//	}
//
//	public SepoaOut getMainternace(String DEPT, String I_COMPANY_CODE, String DEPT_NAME_LOC, String DEPT_NAME_ENG, String PR_LOCATION_NAME, String PR_LOCATION)
//	{
//		try
//		{
//			String user_id = info.getSession("ID");
//			Logger.debug.println(user_id, this, "######getMainternace#######");
//
//			String rtn = new String();
//			// Isvalue(); ....
//			rtn = et_getMainternace(DEPT, I_COMPANY_CODE, DEPT_NAME_LOC, DEPT_NAME_ENG, PR_LOCATION_NAME, PR_LOCATION);
//
//			setValue(rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//		}
//		catch (Exception e)
//		{
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0001"));
//			Logger.err.println(this, e.getMessage());
//		}
//
//		return getSepoaOut();
//	}
//
//	private String et_getMainternace(String DEPT, String I_COMPANY_CODE, String DEPT_NAME_LOC, String DEPT_NAME_ENG, String PR_LOCATION_NAME, String PR_LOCATION) throws Exception
//	{
//		String rtn = new String();
//		ConnectionContext ctx = getConnectionContext();
//		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
//		sm.removeAllValue();
//
//		try
//		{
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append(" SELECT DEPT                                   							\n");
//		//	tSQL.append("      , I_HOUSE_CODE                               						\n");
//		//	tSQL.append("      , SELECTED                               						\n");
//			tSQL.append("      , DEPT_NAME_LOC                               						\n");
//			tSQL.append("      , DEPT_NAME_ENG                               						\n");
//	//		tSQL.append("      , PR_LOCATION_NAME                               						\n");
//			tSQL.append("      , " + SEPOA_DB_OWNER + "GETCODETEXT2('M062',PR_LOCATION) AS PR_LOCATION_NAME	\n");
//			tSQL.append("      , PR_LOCATION                            \n");
//			tSQL.append(" FROM  icomogdp WHERE                                \n");
//		//  tSQL.append(" <OPT=F,S> WHERE HOUSE_CODE = ? </OPT>         \n");
//			tSQL.append("  " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') = 'N'                       \n");
//			if(I_COMPANY_CODE.length() > 0)
//			{
//				tSQL.append(" AND COMPANY_CODE = '" + I_COMPANY_CODE + "'       \n");
//			}
//			if(PR_LOCATION.length() > 0)
//			{
//				tSQL.append(" AND PR_LOCATION = '" + PR_LOCATION + "'           \n");
//			}
//
//
//			if (SEPOA_DB_VENDOR.equals("ORACLE"))
//			{
//				if(DEPT.length() > 0)
//				{
//					tSQL.append(" AND DEPT LIKE '%' || UPPER(" + DEPT + ") || '%'))   \n");
//				}
//				if(DEPT_NAME_LOC.length() > 0 || DEPT_NAME_ENG.length() > 0)
//				{
//					tSQL.append(" AND  DEPT_NAME_LOC LIKE '%' || UPPER(" + DEPT_NAME_LOC + ") || '%')) OR DEPT_NAME_ENG LIKE '%' || " + DEPT_NAME_ENG + " || '%'))  </OPT> \n");
//				}
//			}
//			else if (SEPOA_DB_VENDOR.equals("MYSQL"))
//			{
//				if(DEPT.length() > 0)
//				{
//					tSQL.append(" AND DEPT LIKE UPPER(CONCAT('%' , '" + DEPT + "' , '%'))   \n");
//				}
//				if(DEPT_NAME_LOC.length() > 0 || DEPT_NAME_ENG.length() > 0)
//				{
//					tSQL.append(" AND  DEPT_NAME_LOC LIKE UPPER(CONCAT('%' , '" + DEPT_NAME_LOC + "' , '%')) OR DEPT_NAME_ENG LIKE UPPER(CONCAT('%' , " + DEPT_NAME_ENG + " , '%'))  </OPT> \n");
//				}
//			}
//			else if (SEPOA_DB_VENDOR.equals("MSSQL"))
//			{
//				if(DEPT.length() > 0)
//				{
//					tSQL.append("AND DEPT LIKE UPPER('%''" + DEPT + "''%')\n");
//				}
//				if(DEPT_NAME_LOC.length() > 0 || DEPT_NAME_ENG.length() > 0)
//				{
//					tSQL.append("AND  DEPT_NAME_LOC LIKE UPPER('%''" + DEPT_NAME_LOC + "''%') OR DEPT_NAME_ENG LIKE UPPER('%''" + DEPT_NAME_ENG + "''%') \n");
//				}
//			}
///*
//			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
//
//			String[] args =
//			{
//					DEPT, DEPT_NAME_LOC, DEPT_NAME_ENG, PR_LOCATION_NAME, PR_LOCATION
//			}
//			rtn = sm.doSelect(args);
//*/
//			rtn = sm.doSelect(tSQL.toString());
//
//			if (rtn == null)
//			{
//				throw new Exception("SQL Manager is Null");
//			}
//		}
//		catch (Exception e)
//		{
//			throw new Exception("et_getMainternace:" + e.getMessage());
//		}
//		finally
//		{
//		}
//
//		return rtn;
//	}
//
//	public SepoaOut setSave(String[] setData) throws Exception
//	{
//		try
//		{
//			String user_id = info.getSession("ID");
//			Logger.debug.println(user_id, this, "######setSave#######");
//
//			int rtn = 1; //transaction 성공 여부를 체크한다. "-1"이면, Rollback "0"이상이면 Commit
//
//			//부서등록
//			int row = et_setSave(setData);
//
//			setValue("Insert Row=" + rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//
//			if (rtn == 1)
//			{
//				Commit();
//			}
//		}
//		catch (Exception e)
//		{
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0003"));
//			Logger.err.println(this, e.getMessage());
//			Rollback();
//		}
//
//		return getSepoaOut();
//	}
//
//	private int et_setSave(String[] setData) throws Exception
//	{
//		int rtn = -1;
//		ConnectionContext ctx = getConnectionContext();
//		String user_id = info.getSession("ID");
//
//		try
//		{
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append(" INSERT INTO icomogdp		\n");
//			tSQL.append(" (                        \n");
//			//tSQL.append(" 		 HOUSE_CODE         \n");
//			tSQL.append(" 		 COMPANY_CODE       \n");
//			tSQL.append(" 		,DEPT               \n");
//			tSQL.append(" 		,DEPT_NAME_LOC      \n");
//			tSQL.append(" 		,DEPT_NAME_ENG      \n");
//			tSQL.append(" 		,MANAGER_NAME       \n");
//			tSQL.append(" 		,MANAGER_POSITION   \n");
//			tSQL.append(" 		,PR_LOCATION        \n");
//			tSQL.append(" 		,MENU_PROFILE_CODE  \n");
//			tSQL.append(" 		,CTRL_DEPT_FLAG     \n");
//			tSQL.append(" 		,PHONE_NO           \n");
//			tSQL.append(" 		,FAX_NO             \n");
//			tSQL.append(" 		,MENU_TYPE          \n");
//			tSQL.append(" 		,DEL_FLAG           \n");
//			tSQL.append(" 		,ADD_DATE           \n");
//			tSQL.append(" 		,ADD_TIME           \n");
//			tSQL.append(" 		,ADD_USER_ID        \n");
//			tSQL.append(" )                        \n");
//			tSQL.append(" VALUES                   \n");
//			tSQL.append(" (                        \n");
//			//tSQL.append(" 		 ?                  \n");
//			tSQL.append(" 		 ?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" 		,?                  \n");
//			tSQL.append(" )                        \n");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//
//			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
//			String[] type =
//			{
//				"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
//				"S", "S", "S"
//			};
//			String[][] tmp = new String[1][];
//			tmp[0] = setData;
//
//			rtn = sm.doInsert(tmp, type);
//
//			if (rtn == -1)
//			{
//				throw new Exception("SQL Manager is Null");
//			}
//
//			//else Commit();
//			//Commit();
//		}
//		catch (Exception e)
//		{
//			//	Rollback();
//			//throw new Exception("et_setSave:"+e.getMessage());
//		}
//		finally
//		{
//			//Release();
//		}
//
//		return rtn;
//	}
//
//	public SepoaOut setChange(String[] setData)
//	{
//		String user_id = info.getSession("ID");
//
//		try
//		{
//			Logger.debug.println(user_id, this, "######setUpdate#######");
//
//			String cur_date = SepoaDate.getShortDateString();
//			String cur_time = SepoaDate.getShortTimeString();
//			String status = "R";
//
//			int rtn = et_setChange(setData, status, cur_date, cur_time, user_id);
//
//			setValue("Change Row=" + rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//		}
//		catch (Exception e)
//		{
//			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0002"));
//
//			//log err
//		}
//
//		return getSepoaOut();
//	}
//
//	private int et_setChange(String[] setData, String status, String cur_date, String cur_time, String user_id) throws Exception
//	{
//		int rtn = -1;
//		ConnectionContext ctx = getConnectionContext();
//
//		try
//		{
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append(" UPDATE icomogdp				\n");
//			tSQL.append(" SET   DEPT_NAME_LOC  	= ? \n");
//			tSQL.append(" 	   , DEPT_NAME_ENG		= ? \n");
//			tSQL.append(" 	   , MANAGER_NAME		= ? \n");
//			tSQL.append(" 	   , MANAGER_POSITION	= ? \n");
//			tSQL.append(" 	   , PR_LOCATION		= ? \n");
//			tSQL.append(" 	   , MENU_PROFILE_CODE	= ? \n");
//			tSQL.append(" 	   , CTRL_DEPT_FLAG		= ? \n");
//			tSQL.append(" 	   , PHONE_NO			= ? \n");
//			tSQL.append(" 	   , FAX_NO				= ? \n");
//			tSQL.append(" 	   , MENU_TYPE			= ? \n");
//			tSQL.append(" 	   , DEL_FLAG				= ? \n");
//			tSQL.append(" 	   , CHANGE_DATE		= ? \n");
//			tSQL.append(" 	   , CHANGE_TIME		= ? \n");
//			tSQL.append(" 	   , CHANGE_USER_ID		= ? \n");
//			//tSQL.append(" WHERE HOUSE_CODE			= ? \n");
//			tSQL.append("   WHERE COMPANY_CODE		= ? \n");
//			tSQL.append("   AND DEPT				= ? \n");
//			tSQL.append("   AND PR_LOCATION		= ? \n");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//
//			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
//			String[] type =
//			{
//				"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
//				"S", "S", "S", "S"
//			};
//
//			String[][] tmp = new String[1][];
//			tmp[0] = setData;
//
//			rtn = sm.doInsert(tmp, type);
//			Commit();
//		}
//		catch (Exception e)
//		{
//			//Rollback();
//			throw new Exception("et_setSave:" + e.getMessage());
//		}
//		finally
//		{
//			//Release();
//		}
//
//		return rtn;
//	}
//
//	public SepoaOut setDelete(String[][] setData) throws Exception
//	{
//		try
//		{
//			String user_id = info.getSession("ID");
//			Logger.debug.println(user_id, this, "######setDelete#######");
//
//			int rtn = 0;
//			rtn = et_setDelete(setData);
//
//			setValue("Delete Row=" + rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//
//			Commit();
//		}
//		catch (Exception e)
//		{
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0004"));
//			Rollback();
//			Logger.err.println(this, e.getMessage());
//		}
//
//		return getSepoaOut();
//	}
//
//	private int et_setDelete(String[][] setData) throws Exception
//	{
//		int rtn = -1;
//		ConnectionContext ctx = getConnectionContext();
//		String user_id = info.getSession("ID");
//
//		try
//		{
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append(" UPDATE icomogdp SET              \n");
//			tSQL.append("     DEL_FLAG      = 'Y'              \n");
//			tSQL.append("   , CHANGE_DATE = ?              \n");
//			tSQL.append("   , CHANGE_TIME = ?              \n");
//			tSQL.append("   , CHANGE_USER_ID = ?           \n");
//			//tSQL.append(" WHERE HOUSE_CODE = ?             \n");
//			//tSQL.append(" WHERE COMPANY_CODE = ?             \n");
//			tSQL.append(" WHERE DEPT = ?                     \n");
//			tSQL.append(" AND PR_LOCATION = ?              \n");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//
//			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
//			String[] type = { "S", "S", "S", "S", "S" };
//
//			rtn = sm.doInsert(setData, type);
//
//			if (rtn == -1)
//			{
//				throw new Exception("SQL Manager is Null");
//			}
//			else
//			{
//				Commit();
//			}
//		}
//		catch (Exception e)
//		{
//			throw new Exception("et_setDelete:" + e.getMessage());
//		}
//		finally
//		{
//		}
//
//		return rtn;
//	}
//
//	/*
//	        private int et_setDelete(String house_code, String company_code, String dept) throws Exception
//	        {
//	                   int rtn = -1;
//	                   ConnectionContext ctx = getConnectionContext();
//	            try {
//	                                StringBuffer tSQL = new StringBuffer();
//	                                tSQL.append( " DELETE ICOMOGDP ");
//	                                tSQL.append( " WHERE HOUSE_CODE = ?  ");
//	                                tSQL.append( " AND COMPANY_CODE = ?  ");
//	                                tSQL.append( " AND DEPT = ?  ");
//
//	                                SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());
//
//	                                //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
//	                                String[] type = {"S","S","S"}; //7th
//	                                String[][] param = new String[1][];
//	                                String[] tmp = {house_code, company_code, dept};
//	                                param[0] = tmp;
//
//	                                rtn = sm.doInsert(param, type);
//
//	                                if(rtn == -1) throw new Exception("SQL Manager is Null");
//	                                else Commit();
//	            }catch(Exception e) {
//	                                throw new Exception("et_setDelete:"+e.getMessage());
//	                    } finally{}
//	                return rtn;
//	        }
//	*/
//
//	public SepoaOut getDis(String[] args)
//	{
//		try
//		{
//			String user_id = info.getSession("ID");
//			Logger.debug.println(user_id, this, "######getDis#######");
//
//			String rtn = new String();
//			rtn = getDis(args, user_id);
//			setValue(rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//		}
//		catch (Exception e)
//		{
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0001"));
//			Logger.err.println(this, e.getMessage());
//		}
//
//		return getSepoaOut();
//	}
//
//	private String getDis(String[] args, String user_id) throws Exception
//	{
//		String rtn = new String();
//		ConnectionContext ctx = getConnectionContext();
//
//		try
//		{
//			StringBuffer tSQL = new StringBuffer();
//			tSQL.append(" SELECT                                 \n");
//			tSQL.append("     DEPT_NAME_LOC                           \n");
//			tSQL.append("   , DEPT                           \n");
//			tSQL.append("   , '' SELECTED                           \n");
//			tSQL.append("   , DEPT_NAME_ENG                           \n");
//			tSQL.append("   , MANAGER_NAME                       \n");
//			tSQL.append("   , MANAGER_POSITION                   \n");
//			tSQL.append("   , MANAGER_POSITION_NAME              \n");
//			tSQL.append("   , PR_LOCATION                        \n");
//			tSQL.append("   , PR_LOCATION_NAME                   \n");
//			tSQL.append("   , MENU_PROFILE_CODE	                 \n");
//			tSQL.append("   , MENU_NAME                          \n");
//			tSQL.append("   , CTRL_DEPT_FLAG                     \n");
//			tSQL.append("   , PHONE_NO                           \n");
//			tSQL.append("   , FAX_NO                             \n");
//			tSQL.append("   , MENU_TYPE                          \n");
//			tSQL.append(" FROM  DEPT_GENERAL_VW                  \n");
//			//tSQL.append(" <OPT=F,S> WHERE HOUSE_CODE = ? </OPT>  \n");
//			tSQL.append(" <OPT=F,S> WHERE COMPANY_CODE = ? </OPT>  \n");
//			tSQL.append(" <OPT=F,S> AND DEPT = ? </OPT>          \n");
//			tSQL.append(" <OPT=F,S> AND PR_LOCATION = ? </OPT>   \n");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//			rtn = sm.doSelect(args);
//
//			if (rtn == null)
//			{
//				throw new Exception("SQL Manager is Null");
//			}
//		}
//		catch (Exception e)
//		{
//			throw new Exception("et_getMainternace:" + e.getMessage());
//		}
//		finally
//		{
//			//Release();
//		}
//
//		return rtn;
//	}
//
//	public SepoaOut getDuplicate(String[] args)
//	{
//		String user_id = info.getSession("ID");
//		String rtn = null;
//
//		try
//		{
//			Logger.debug.println(user_id, this, "######getDuplicate#######");
//			// Isvalue(); ....
//			rtn = Check_Duplicate(args, user_id);
//
//			setValue(rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//		}
//		catch (Exception e)
//		{
//			setStatus(0);
//			setMessage(msg.getMessage("0001"));
//			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
//		}
//
//		return getSepoaOut();
//	}
//
//	private String Check_Duplicate(String[] args, String user_id) throws Exception
//	{
//		String rtn = null;
//		String count = "";
//		String[][] str = new String[1][2];
//
//		ConnectionContext ctx = getConnectionContext();
//
//		try
//		{
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append(" select DEL_FLAG \n");
//			tSQL.append(" from icomogdp \n");
//			//tSQL.append(" <OPT=F,S> where house_code = ? </OPT> \n");
//			tSQL.append(" <OPT=F,S> where company_code = ? </OPT> \n");
//			tSQL.append(" <OPT=F,S> and dept = ? </OPT>        \n");
//			tSQL.append(" <OPT=F,S> and pr_location = ? </OPT> \n");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//
//			//String[] args = {house_code, company_code,PLANT_CODE};
//			rtn = sm.doSelect(args);
//
//			SepoaFormater wf = new SepoaFormater(rtn);
//
//			if (wf.getRowCount() == 0)
//			{
//				count = "X";
//			}
//			else
//			{
//				str = wf.getValue();
//				count = str[0][0];
//			}
//
//			if (rtn == null)
//			{
//				throw new Exception("SQL Manager is Null");
//			}
//		}
//		catch (Exception e)
//		{
//			throw new Exception("Check_Duplicate:" + e.getMessage());
//		}
//		finally
//		{
//			//Release();
//		}
//
//		return count;
//	}
//}
