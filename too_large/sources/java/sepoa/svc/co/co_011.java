package sepoa.svc.co;

import javax.servlet.http.HttpServletRequest;

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
import sepoa.fw.util.SepoaFormater;

public class CO_011 extends SepoaService
{
    private String ID = info.getSession("ID");

    public CO_011(String opt, SepoaInfo info) throws SepoaServiceException
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

    public SepoaOut checkUrl(SepoaInfo _info, String _urlPath, String _thisWindowPopupFlag, String _thisWindowInitMenuObjectCode, String _thisWindowPopupScreenName)
    {
        try
        {
            String[] rtn = null;
            setStatus(1);
            setFlag(true);

            rtn = svcCheckUrl(_info, _urlPath, _thisWindowPopupFlag, _thisWindowInitMenuObjectCode, _thisWindowPopupScreenName);

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

    private String[] svcCheckUrl(SepoaInfo _info, String _urlPath, String _thisWindowPopupFlag, String _thisWindowInitMenuObjectCode, String _thisWindowPopupScreenName) throws Exception
    {
        String[] rtn = new String[2];
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        String id = info.getSession("ID");
        String user_type = info.getSession("USER_TYPE");

        if (id == null)
        {
            throw new Exception("Sessiond is null : id");
        }
        else if (_urlPath == null)
        {
            throw new Exception("urlPath is null");
        }

        try
        {
            /*
        	ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            sql.append(" select ( \n ");
            sql.append(" select 'x' \n ");
            sql.append(" from ICOMLUSR \n ");
            sql.append(sm.addFixString("  where user_id =  ?   \n "));sm.addStringParameter(id);

            sql.append("    and " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N'  \n ");
            sql.append("   and menu_profile_code in \n ");
            sql.append(" 	(select distinct menu_profile_code \n ");
            sql.append(" 	 from smupd \n ");
            sql.append(" 	  where  " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' and menu_object_code in \n ");
            */
        	
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            sql.append(" select ( \n ");
            sql.append(" select distinct 'x' \n ");
            sql.append(" from smupd \n ");
            sql.append(sm.addFixString("  where menu_profile_code =  ?   \n "));
            sm.addStringParameter(info.getSession("MENU_PROFILE_CODE"));
            sql.append(" 	  and " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' and menu_object_code in \n ");

            sql.append(" 	   ( \n ");
            sql.append(" 		select distinct menu.menu_object_code \n ");
            sql.append(" 		from smuln menu \n ");
            sql.append(" 		 where  " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' and screen_id in \n ");
            sql.append(" 		  (select distinct screen_id \n ");
            sql.append(" 		   from smuid \n ");
            sql.append(" 		    where " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' and  use_flag in ('Y', '1')  \n ");
            sql.append(sm.addFixString(" 		      and actual_menu_link = ?)  \n "));
            sm.addStringParameter(_urlPath);

           // sql.append(" 		) \n ");
            sql.append(" 	) \n ");
            sql.append(" ) autho, \n ");
            sql.append(" ( \n ");

            if(SEPOA_DB_VENDOR.equals("MSSQL"))
            {
            	sql.append("    select top 1 'x' chk \n ");
            }
            else
            {
            	sql.append("    select 'x' chk \n ");
            }

            sql.append("    from smuid id, smuln ln \n ");
            sql.append("     where " + DB_NULL_FUNCTION + "(id.del_flag, 'N') = 'N' and id.use_flag in ('Y', '1')  \n ");
            sql.append("       and " + DB_NULL_FUNCTION + "(ln.del_flag, 'N') = 'N' and id.screen_id = ln.screen_id  \n ");
            sql.append(sm.addFixString("       and id.actual_menu_link = ?  \n "));
            sm.addStringParameter(_urlPath);

            sql.append("      and " + DB_NULL_FUNCTION + "(id.autho_apply_flag, 'Y') = 'Y' \n ");

            if(SEPOA_DB_VENDOR.equals("MYSQL"))
            {
            	sql.append("      limit 1 \n ");
            }
            else if(SEPOA_DB_VENDOR.equals("ORACLE"))
            {
            	sql.append("      and rownum <= 1 \n ");
            }

            sql.append("  ) chk, \n ");
            sql.append(" ( \n ");

            if(SEPOA_DB_VENDOR.equals("MSSQL"))
            {
            	sql.append("    select top 1 screen_id \n ");
            }
            else
            {
            	sql.append("    select screen_id \n ");
            }

            sql.append("    from smuid \n ");
            sql.append("     where " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' and use_flag in ('Y', '1')  \n ");
            sql.append(sm.addFixString("       and actual_menu_link = ?  \n "));
            sm.addStringParameter(_urlPath);

            if(SEPOA_DB_VENDOR.equals("MYSQL"))
            {
            	sql.append("      limit 1 \n ");
            }
            else if(SEPOA_DB_VENDOR.equals("ORACLE"))
            {
            	sql.append("      and rownum <= 1 \n ");
            }

            sql.append("  ) screen_id, \n ");
            sql.append(" 0 menu_order, \n ");

            /* �̰� ��𿡼� ��� ó���ұ�......? */
            if(_thisWindowPopupScreenName.trim().length() > 0)
            {
            	sql.append(sm.addFixString(" (select ? from dual) popup_screen_name "));
            }
            else if(_thisWindowPopupFlag.toLowerCase().equals("true"))
            {
            	sql.append("  ( \n ");

            	if(SEPOA_DB_VENDOR.equals("MSSQL"))
                {
                	sql.append("    select top 1 screen_name \n ");
                }
                else
                {
                	sql.append("    select screen_name \n ");
                }

            	sql.append("	     from smuid \n ");
            	sql.append("	      where " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' and use_flag in ('Y', '1') \n ");
            	sql.append(sm.addFixString("	           and actual_menu_link = ? \n "));  sm.addStringParameter(_urlPath);
//            	sql.append(sm.addSelectString("            and module_type = (select module_type from smugl where menu_object_code = ? ) \n "));
//            	sm.addStringParameter(_thisWindowInitMenuObjectCode);

            	if(SEPOA_DB_VENDOR.equals("MYSQL"))
                {
                	sql.append("      limit 1 \n ");
                }
                else if(SEPOA_DB_VENDOR.equals("ORACLE"))
                {
                	sql.append("      and rownum <= 1 \n ");
                }

            	sql.append("  ) popup_screen_name \n ");
            }
            else
            {
            	sql.append(" '' popup_screen_name \n ");
            }

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				sql.append(" from dual \n ");
			}

            rtn[0] = sm.doSelect(sql.toString());

            if (rtn[0] == null)
            {
                
                rtn[1] = "sql Manager is Null ==> SystemAuthBean.et_checkUrl() Result is null";
            }
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
