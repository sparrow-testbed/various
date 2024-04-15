package sepoa.svc.admin;

import java.util.Vector;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
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

public class AD_018 extends SepoaService
{
	private String ID = info.getSession("ID");

	public AD_018(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut getMultilangList(SepoaInfo info, String screen_id, String language, String type, String contents, String house_code)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getMultilangList(info, screen_id, language, type, contents, house_code);

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

	private String[] et_getMultilangList(SepoaInfo info, String screen_id, String v_language, String type, String contents, String house_code) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();

		try
		{
        	SepoaXmlParser sxp = new SepoaXmlParser();
        	SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
        	
        	String[] args = new String[]{screen_id, v_language, type, contents, contents, house_code};

            rtn[0] = ssm.doSelect(args);
			
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
	} //

	public SepoaOut getMultilangContent(SepoaInfo info, Vector multilang_id, String language)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getMultilangContent(info, multilang_id, language);

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

	private String[] et_getMultilangContent(SepoaInfo info, Vector multilang_id, String language) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" select /*+ rule */ \n ");
			sb.append("   screen_id, \n ");
			sb.append("   language, \n ");
			sb.append("   code, \n ");
			sb.append("   type, \n ");
			sb.append("   contents, \n ");
			sb.append("   add_user_id, \n ");
			sb.append("   getDateFormat(add_date) || ' ' || getTimeFormat(add_time) add_date, \n ");
			sb.append("   " + DB_NULL_FUNCTION + "(del_flag, 'N') status \n ");
			sb.append(" from slang \n ");
			sb.append(" where screen_id in (  \n ");

			for (int i = 0; i < multilang_id.size(); i++)
			{
				if (i == (multilang_id.size() - 1))
				{
					sb.append("'" + multilang_id.elementAt(i) + "' \n");
				}
				else
				{
					sb.append("'" + multilang_id.elementAt(i) + "', ");
				}
			}

			sb.append("     )  and  language = '" + language + "'  \n ");
			sb.append("  and " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' \n ");
			sb.append(" order by screen_id, language, code, type  \n ");

			Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
			rtn[0] = sm.doSelect(sb.toString());
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

	public SepoaOut insertMultilang(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_insertMultilang(info, bean_args);

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

	private String[] et_insertMultilang(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();

		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String house_code = bean_info[i][0];
				String screen_id = bean_info[i][1];
				String language = bean_info[i][2];
				String code = bean_info[i][3];
				String type = bean_info[i][4];
				String contents = bean_info[i][5];
				String col_type     = bean_info[i][6];
				String col_format   = bean_info[i][7];
				String col_width    = bean_info[i][8];
				String col_max_len  = bean_info[i][9];
				String col_align    = bean_info[i][10];
				String col_visible  = bean_info[i][11];
				String selected_yn  = bean_info[i][12];
				String col_seq      = bean_info[i][13];
				String col_color    = bean_info[i][14];
				String col_combo    = bean_info[i][15];
				String col_sort     = bean_info[i][16];
				String status       = bean_info[i][17];

				SepoaXmlParser sxp = new SepoaXmlParser(this, "et_insertMultilang_select");
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

				String[] args = new String[]{ screen_id, language, code };
				sf = new SepoaFormater(ssm.doSelect_limit(args));

				String[] types = null;
				//존재하면 Update
				if(Integer.parseInt(sf.getValue("cnt", 0)) > 0)
				{
					
					args = new String[]{ house_code, type, contents, info.getSession("ID"), SepoaDate.getShortDateString(),
							SepoaDate.getShortTimeString(), col_type, col_format, col_width, col_width,
							col_max_len, col_align, col_visible, selected_yn, col_seq,
							col_color, col_combo, col_sort, screen_id, language, code };
					types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};

                    sxp = new SepoaXmlParser(this, "et_insertMultilang_update");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);
				}
				else
				{
					args = new String[]{ 
							house_code, screen_id, language, code, type, 
							contents, info.getSession("ID"), SepoaDate.getShortDateString(), SepoaDate.getShortTimeString(), col_type, 
							col_format, col_width, col_max_len, col_align  , col_visible, 
							selected_yn, col_seq, col_color, col_combo, col_sort, 
							"N"
					};
					types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};

                    sxp = new SepoaXmlParser(this, "et_insertMultilang_insert");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doInsert(new String[][]{args}, types);
				}
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
	} //

	public SepoaOut deleteMultilang(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteMultilang(info, bean_args);

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

	private String[] et_deleteMultilang(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_info.length; i++)
			{
				String screen_id = bean_info[i][0];
				String language = bean_info[i][1];
				String code = bean_info[i][2];

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" update slang set \n ");
				sb.append(" 	del_flag = 'Y', \n ");
				sb.append("		change_user_id = ?, \n "); sm.addStringParameter(info.getSession("ID"));
				sb.append("		change_date = ?, \n "); sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("		change_time = ? \n "); sm.addStringParameter(SepoaDate.getShortTimeString());
				sb.append(" where screen_id = ? \n "); sm.addStringParameter(screen_id);
				sb.append("   and language = ? \n "); sm.addStringParameter(language);
				sb.append("   and code = ? \n "); sm.addStringParameter(code);
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
	} //
}
