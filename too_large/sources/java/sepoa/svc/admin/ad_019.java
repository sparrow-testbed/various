package sepoa.svc.admin;

import java.util.HashMap;
import java.util.Map;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class AD_019 extends SepoaService
{
	private String ID = info.getSession("ID");
	

	public AD_019(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}

	public SepoaOut getMenuList(SepoaInfo info, String module_type, String screen_name, String menu_link)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getMenuList(info, module_type, screen_name, menu_link);

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

	public String[] et_getMenuList(SepoaInfo info, String module_type, String screen_name, String menu_link) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		String language = info.getSession("LANGUAGE");

        try
        {
            String taskType = "CONNECTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
            
            Map map = new HashMap();
            map.put("language", language);
            map.put("module_type", module_type);
            map.put("screen_name", screen_name);
            map.put("menu_link", menu_link);
            
            SepoaXmlParser sxp = new SepoaXmlParser();
            SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
            rtn[0] = ssm.doSelect(map);

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

	public SepoaOut insertMenuList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_insertMenuList(info, bean_args);

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

	public String[] et_insertMenuList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				
				String module_type = bean_info[i][0];		//PK
				String screen_id = bean_info[i][1];			//PK
				String screen_name = bean_info[i][2];
				String use_flag = bean_info[i][3];
				String menu_link = bean_info[i][4];
				String autho_apply_flag = bean_info[i][5];
				String actual_menu_link = "";

	           	if(use_flag.equals("1"))
	           	{
	           		use_flag = "Y";
	           	}
	           	else
	           	{
	           		use_flag = "N";
	           	}

	           	if(autho_apply_flag.equals("1"))
	           	{
	           		autho_apply_flag = "Y";
	           	}
	           	else
	           	{
	           		autho_apply_flag = "N";
	           	}

	           	if(menu_link.indexOf("?") >= 0)
	           	{
	           		actual_menu_link = menu_link.substring(0, menu_link.indexOf("?"));
	           	}
	           	else
	           	{
	           		actual_menu_link = menu_link;
	           	}

	           	sm.removeAllValue();
                sb.delete(0, sb.length());

                sb.append(" select count(*) cnt \n ");
				sb.append(" from smuid \n ");
				sb.append(sm.addFixString(" where module_type = ? \n "));
				sm.addStringParameter(module_type);

				sb.append(sm.addFixString("   and screen_id = ? \n "));
				sm.addStringParameter(screen_id);

				sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));

//				존재하면 Update
				if(Integer.parseInt(sf.getValue("cnt", 0)) > 0)
				{
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" update smuid set \n ");
					sb.append(" 	screen_name = ?, \n "); sm.addStringParameter(screen_name);
					sb.append(" 	menu_link = ?, \n "); sm.addStringParameter(menu_link);
					sb.append(" 	use_flag = ?, \n "); sm.addStringParameter(use_flag);
					sb.append(" 	autho_apply_flag = ?, \n "); sm.addStringParameter(autho_apply_flag);
					sb.append(" 	actual_menu_link = ?, \n "); sm.addStringParameter(actual_menu_link);
					sb.append("     change_user_id = ?, \n "); sm.addStringParameter(info.getSession("ID"));
					sb.append("     change_date = ?, \n "); sm.addStringParameter(SepoaDate.getShortDateString());
					sb.append("     change_time = ?, \n "); sm.addStringParameter(SepoaDate.getShortTimeString());
					sb.append("     del_flag = 'N' \n ");
					sb.append(" where module_type = ? \n "); sm.addStringParameter(module_type);
					sb.append("   and screen_id = ? \n "); sm.addStringParameter(screen_id);
					//sb.append("   and code = ? \n "); sm.addParameter(code);
					sm.doUpdate(sb.toString());
				}
				else
				{
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" insert into smuid \n ");
					sb.append(" ( \n ");
					sb.append(" 	module_type,  \n ");
					sb.append(" 	screen_id,  \n ");
					sb.append(" 	screen_name,  \n ");
					sb.append(" 	menu_link,  \n ");
					sb.append(" 	use_flag,  \n ");
					sb.append(" 	autho_apply_flag,  \n ");
					sb.append(" 	add_user_id,  \n ");
					sb.append(" 	add_date,  \n ");
					sb.append(" 	add_time,  \n ");
					sb.append(" 	actual_menu_link,  \n ");
					sb.append(" 	del_flag \n ");
					sb.append(" ) \n ");
					sb.append(" values \n ");
					sb.append(" ( \n ");
					sb.append(" 	?,	 \n "); sm.addStringParameter(module_type);
					sb.append(" 	?,	 \n "); sm.addStringParameter(screen_id);
					sb.append(" 	?,	 \n "); sm.addStringParameter(screen_name);
					sb.append(" 	?,	 \n "); sm.addStringParameter(menu_link);
					sb.append(" 	?,	 \n "); sm.addStringParameter(use_flag);
					sb.append(" 	?,	 \n "); sm.addStringParameter(autho_apply_flag);
					sb.append(" 	?,	 \n "); sm.addStringParameter(info.getSession("ID"));
					sb.append(" 	?,	 \n "); sm.addStringParameter(SepoaDate.getShortDateString());
					sb.append(" 	?,	 \n "); sm.addStringParameter(SepoaDate.getShortTimeString());
					sb.append("     ?,   \n "); sm.addStringParameter(actual_menu_link);
					sb.append(" 	? \n "); sm.addStringParameter("N");
					sb.append(" )	 \n ");
					sm.doInsert(sb.toString());
				}
//                sb.append(" merge into smuid muid \n ");
//                sb.append(" using \n ");
//                sb.append(" ( select \n ");
//                sb.append(" 	? module_type, \n ");
//                sm.addParameter(module_type);
//
//                sb.append(" 	upper(?) screen_id, \n ");
//                sm.addParameter(screen_id);
//
//                sb.append(" 	? screen_name, \n ");
//                sm.addParameter(screen_name);
//
//                sb.append(" 	? use_flag, \n ");
//                sm.addParameter(use_flag);
//
//                sb.append(" 	? menu_link, \n ");
//                sm.addParameter(menu_link);
//
//                sb.append(" 	? autho_apply_flag, \n ");
//                sm.addParameter(autho_apply_flag);
//
//                sb.append(" 	to_char(sysdate, 'yyyymmdd') add_date, \n ");
//                sb.append(" 	to_char(sysdate, 'HH24MISS') add_time, \n ");
//                sb.append(" 	? add_user_id, \n ");
//                sm.addParameter(info.getSession("ID"));
//
//                sb.append(" 	? add_user_name_eng, \n ");
//                sm.addParameter(info.getSession("NAME_ENG"));
//
//                sb.append(" 	? add_user_name_loc \n ");
//                sm.addParameter(info.getSession("NAME_LOC"));
//
//                sb.append("   from dual ) data \n ");
//                sb.append(" on (data.screen_id = muid.screen_id )  \n ");
//                sb.append(" when matched then \n ");
//                sb.append(" 	update set \n ");
//                sb.append(" 		muid.module_type = data.module_type, \n ");
//                sb.append(" 		muid.screen_name = data.screen_name, \n ");
//                sb.append(" 		muid.use_flag = decode(data.use_flag,'1','Y','N'), \n ");
//                sb.append(" 		muid.menu_link = data.menu_link, \n ");
//                sb.append(" 		muid.actual_menu_link = case \n ");
//                sb.append(" 									when instr(menu_link,?) > 0 then \n ");
//                sm.addParameter("?");
//
//                sb.append(" 										substr(menu_link,0,instr(menu_link,?) -1) \n ");
//                sm.addParameter("?");
//                sb.append(" 									else \n ");
//                sb.append(" 										menu_link \n ");
//                sb.append(" 								end , \n ");
//                sb.append(" 		muid.autho_apply_flag = decode(data.autho_apply_flag,'1','Y','N'), \n ");
//                sb.append(" 		muid.add_user_id = data.add_user_id, \n ");
//                sb.append(" 		muid.add_user_name_loc = data.add_user_name_loc, \n ");
//                sb.append(" 		muid.add_user_name_eng = data.add_user_name_eng, \n ");
//                sb.append(" 		muid.add_date = data.add_date, \n ");
//                sb.append(" 		muid.add_time = data.add_time \n ");
//                sb.append(" when not matched then \n ");
//                sb.append(" 	insert ( \n ");
//                sb.append(" 		module_type, \n ");
//                sb.append(" 		screen_id, \n ");
//                sb.append(" 		screen_name, \n ");
//                sb.append(" 		use_flag, \n ");
//                sb.append(" 		menu_link, \n ");
//                sb.append(" 		actual_menu_link, \n ");
//                sb.append(" 		autho_apply_flag, \n ");
//                sb.append(" 		add_date, \n ");
//                sb.append(" 		add_time, \n ");
//                sb.append(" 		add_user_id, \n ");
//                sb.append(" 		add_user_name_eng, \n ");
//                sb.append(" 		add_user_name_loc ) \n ");
//                sb.append(" 	values ( \n ");
//                sb.append(" 		data.module_type, \n ");
//                sb.append(" 		data.screen_id, \n ");
//                sb.append(" 		data.screen_name, \n ");
//                sb.append(" 		decode(data.use_flag,'1','Y','N'), \n ");
//                sb.append(" 		data.menu_link, \n ");
//                sb.append(" 		case \n ");
//                sb.append(" 			when instr(data.menu_link,?) > 0 then \n ");
//                sm.addParameter("?");
//                sb.append(" 				substr(data.menu_link,0,instr(data.menu_link,?) -1) \n ");
//                sm.addParameter("?");
//                sb.append(" 			else \n ");
//                sb.append(" 				data.menu_link \n ");
//                sb.append(" 			end , \n ");
//                sb.append(" 		decode(data.autho_apply_flag,'1','Y','N'), \n ");
//                sb.append(" 		data.add_date, \n ");
//                sb.append(" 		data.add_time, \n ");
//                sb.append(" 		data.add_user_id, \n ");
//                sb.append(" 		data.add_user_name_eng, \n ");
//                sb.append(" 		data.add_user_name_loc) \n ");
//                Logger.debug.println(info.getSession("ID"), this, "soutmuhd======insert="+sb.toString());
//                sm.doUpdate(sb.toString());
            }

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
    }

    public SepoaOut deleteMenuList(SepoaInfo info, String[][] bean_args) throws Exception
    {
    	try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteMenuList(info, bean_args);

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

    public String[] et_deleteMenuList(SepoaInfo info, String[][] bean_info) throws Exception
    {
    	String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_info.length; i++)
			{
				String module_type = bean_info[i][0];
	           	String screen_id = bean_info[i][1];
	           	String screen_name = bean_info[i][2];
	           	String use_flag = bean_info[i][3];
	           	String menu_link = bean_info[i][4];

	           	sm.removeAllValue();
                sb.delete(0, sb.length());
                sb.append(" update  smuid set  \n ");
                sb.append(" del_flag = 'Y', \n ");
                sb.append(" change_date = ?, \n "); sm.addStringParameter(SepoaDate.getShortDateString());
                sb.append(" change_time = ?, \n "); sm.addStringParameter(SepoaDate.getShortTimeString());
                sb.append(" change_user_id = ? \n ");sm.addStringParameter(info.getSession("ID"));
                sb.append(" where screen_id = ? \n ");	sm.addStringParameter(screen_id);

                sm.doUpdate(sb.toString());
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
    }
}
