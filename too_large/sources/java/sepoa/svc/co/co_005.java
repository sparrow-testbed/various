/*jadclipse*/
// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) ansi radix(10) lradix(10)
// Source File Name:   CO_005.java
package sepoa.svc.co;

import java.util.HashMap;
import java.util.Map;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.log.LoggerWriter;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.*;


public class CO_005 extends SepoaService
{
    private String ID;

    public CO_005(String opt, SepoaInfo info) throws SepoaServiceException
    {
        super(opt, info);
        ID = this.info.getSession("ID");
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
            Logger.sys.println((new StringBuilder("getConfig error : ")).append(configurationexception.getMessage()).toString());
        }
        catch (Exception exception)
        {
            Logger.sys.println((new StringBuilder("getConfig error : ")).append(exception.getMessage()).toString());
        }

        return null;
    }

    public SepoaOut getUserMenu(SepoaInfo _info)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcGetUserMenu(_info);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
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

    private String[] svcGetUserMenu(SepoaInfo _info) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();

        try
        {
        	SepoaXmlParser sxp = new SepoaXmlParser();
        	SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
        	
        	//System.out.println("MENU_PROFILE_CODE="+_info.getSession("MENU_PROFILE_CODE"));
        	String MENU_PROFILE_CODE = _info.getSession("MENU_PROFILE_CODE");
        	
        	Map<String, String> map =  new HashMap<String, String>();
        	map.put("MENU_PROFILE_CODE",MENU_PROFILE_CODE);
        	
            rtn[0] = ssm.doSelect(map);
			
        }
        catch (Exception e)
        {
            rtn[1] = e.getMessage();
            
            Logger.debug.println(ID, this, e.getMessage());
        }

        return rtn;
    }

    public SepoaOut getUserMenuTree(SepoaInfo _info, String _menu_object_code)
    {
        try
        {
            String[] rtn = (String[]) null;
            setStatus(1);
            setFlag(true);
            rtn = svcGetUserMenuTree(_info, _menu_object_code);

            if (rtn[1] != null)
            {
                setMessage(rtn[1]);
                Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("_________ ")).append(rtn[1]).toString());
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

    private String[] svcGetUserMenuTree(SepoaInfo _info, String _menu_object_code) throws Exception
    {
        String[] rtn = new String[2];
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();

        try
        {
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            sql.append(" SELECT DISTINCT \n ");
            sql.append("    '' as lvl,  \t\n ");
            sql.append(" \tM.MENU_OBJECT_CODE,  \n ");
            sql.append("   \tM.MENU_FIELD_CODE,  \n ");
            sql.append("   \tM.MENU_PARENT_FIELD_CODE,  \n ");
            sql.append("   \tM.MENU_NAME,  \n ");
            sql.append("   \tM.SCREEN_ID,  \n ");
            sql.append("   \tM.MENU_LINK_FLAG,  \n ");
            sql.append("   \tM.CHILD_FLAG,  \n ");
            sql.append("   \tM.ORDER_SEQ,  \n ");
            sql.append("   \tM.USE_FLAG,  \n ");
            sql.append((new StringBuilder("   \t")).append(DB_NULL_FUNCTION).append("(M.MENU_LINK, '') AS MENU_LINK \n "));
//            sql.append("   convert(int, M.ORDER_SEQ)  \n ");

            sql.append(" FROM \n ");
            sql.append(" (SELECT  \n ");
            sql.append("   A.MENU_OBJECT_CODE,  \n ");
            sql.append("   A.MENU_FIELD_CODE,  \n ");
            sql.append("   A.MENU_PARENT_FIELD_CODE,  \n ");
            sql.append("   A.MENU_NAME,  \n ");
            sql.append("   A.SCREEN_ID,  \n ");
            sql.append("   A.MENU_LINK_FLAG,  \n ");
            sql.append("   A.CHILD_FLAG,  \n ");
            sql.append("   A.ORDER_SEQ,  \n ");
            sql.append("   A.USE_FLAG, \n ");
            sql.append("      \tB.MENU_LINK \n ");
            sql.append("    FROM  SMUGL C, SMULN A LEFT OUTER JOIN SMUID B \n ");
            sql.append(" ON A.SCREEN_ID = B.SCREEN_ID \n ");
            sql.append(sm.addFixString(" WHERE A.MENU_OBJECT_CODE = ? \n "));
            sm.addStringParameter(_menu_object_code);
            sql.append((new StringBuilder(" AND ")).append(DB_NULL_FUNCTION).append("(A.DEL_FLAG, 'N') = 'N'  \n ").toString());
            sql.append("     AND A.USE_FLAG = 'Y'  \n ");
            sql.append("     AND A.MENU_OBJECT_CODE = C.MENU_OBJECT_CODE \n ");
            sql.append((new StringBuilder("     AND ")).append(DB_NULL_FUNCTION).append("(C.DEL_FLAG, 'N') = 'N' \n ").toString());
            sql.append((new StringBuilder("     AND ")).append(DB_NULL_FUNCTION).append("(B.DEL_FLAG, 'N') = 'N') M, SMULN B \n ").toString());
            sql.append(" WHERE M.MENU_OBJECT_CODE = B.MENU_OBJECT_CODE \n ");
            sql.append((new StringBuilder(" \tAND ")).append(DB_NULL_FUNCTION).append("(B.DEL_FLAG, 'N') = 'N' \n ").toString());
            sql.append(" \tAND B.USE_FLAG = 'Y' \n ");
            sql.append(" \tAND CASE WHEN M.MENU_PARENT_FIELD_CODE = '*' THEN M.MENU_FIELD_CODE \n ");
            sql.append(" \tELSE M.MENU_PARENT_FIELD_CODE \n ");
            sql.append(" END = B.MENU_FIELD_CODE \n ");

            if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sql.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, cast(M.ORDER_SEQ as SIGNED) \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                sql.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, M.ORDER_SEQ \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sql.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, to_number(M.ORDER_SEQ) \n ");
            }

            rtn[0] = sm.doSelect(sql.toString());
        }
        catch (Exception e)
        {
            rtn[1] = e.getMessage();
            
            Logger.debug.println(ID, this, e.getMessage());
        }

        return rtn;
    }
}
