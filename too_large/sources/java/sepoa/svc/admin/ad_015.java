package sepoa.svc.admin;

import java.util.HashMap;
import java.util.Vector;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class AD_015 extends SepoaService
{
	private String ID = info.getSession("ID");

	public AD_015(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut getCodedQuery(SepoaInfo info, String type, String code, String language, String search)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodedQuery(info, type, code, language, search);

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

	private String[] et_getCodedQuery(SepoaInfo info, String type, String code, String language, String search) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" select 			\n ");
			sb.append("   type, 		\n ");
			sb.append("   language, 	\n ");
			sb.append("   code,			\n ");
			sb.append("   flag, 		\n ");
			sb.append("   text1, 		\n ");
			sb.append("   text2,		\n ");
			sb.append("   text3, 		\n ");
			sb.append("   text4, 		\n ");
			sb.append("   text5, 		\n ");
			sb.append("   text6, 		\n ");
			sb.append("   text7, 		\n ");
			sb.append("   sort_seq, 	\n ");
			sb.append("   flag, 		\n ");
			sb.append("   use_flag, 	\n ");
			sb.append("   add_user_id,	\n ");
			sb.append("   change_user_id, \n ");
			sb.append("   code AS CODE_HIDDEN , \n ");//추가
			if(SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				sb.append("   concat(getDateFormat(add_date), ' ', getTimeFormat(add_time)) add_date, \n ");
				sb.append("   concat(getDateFormat(change_date), ' ', getTimeFormat(change_time)) change_date \n ");
			}
			else if(SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(add_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(add_time) add_date, \n ");
				sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(change_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(change_time) change_date \n ");
			}
			else if(SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(add_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(add_time) add_date, \n ");
				sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(change_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(change_time) change_date \n ");
			}

			sb.append(" from scode  \n ");

			//코드값 조건
			if (code.length() > 0)
			{
				if(SEPOA_DB_VENDOR.equals("MSSQL"))
				{
					sb.append(sm.addFixString(" where  CHARINDEX(UPPER(code),UPPER(?))>0 \n "));
				}
				else
				{
					sb.append(sm.addFixString(" where  INSTR(UPPER(code),UPPER(?))>0 \n "));
				}
				sm.addStringParameter(code);
				sb.append(sm.addSelectString(" and type=?	\n "));
				sm.addStringParameter(type);
				sb.append(" and    		\n ");
			}
			else
			{
				sb.append(sm.addFixString(" where type=?  \n "));
				sm.addStringParameter(type);
				sb.append(" and    		  \n ");
			}

			if (!language.equals(""))
			{
				sb.append(sm.addSelectString(" language = ?  \n "));
				sm.addStringParameter(language);
				sb.append(" and    		  \n ");
			}

			if (!search.equals(""))
			{ //검색어 조건
				if(SEPOA_DB_VENDOR.equals("ORACLE"))
				{
					sb.append(" (	\n ");
					sb.append(sm.addSelectString("    upper(text1) like '%' || UPPER(?) || '%' 	\n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text2) like '%' || UPPER(?) || '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text4) like '%' || UPPER(?) || '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text5) like '%' || UPPER(?) || '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text6) like '%' || UPPER(?) || '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text7) like '%' || UPPER(?) || '%'  \n "));
					sm.addStringParameter(search);
				}
				else if(SEPOA_DB_VENDOR.equals("MYSQL"))
				{
					sb.append(" (	\n ");
					sb.append(sm.addSelectString("    upper(text1) like concat('%', UPPER(?), '%') 	\n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text2) like concat('%', UPPER(?), '%')  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text4) like concat('%', UPPER(?), '%')  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text5) like concat('%', UPPER(?), '%')  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text6) like concat('%', UPPER(?), '%')  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text7) like concat('%', UPPER(?), '%')  \n "));
					sm.addStringParameter(search);
				}
				else if(SEPOA_DB_VENDOR.equals("MSSQL"))
				{
					sb.append(" (	\n ");
					sb.append(sm.addSelectString("    upper(text1) like '%' + UPPER(?)+ '%' 	\n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text2) like '%' + UPPER(?)+ '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text4) like '%' + UPPER(?)+ '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text5) like '%' + UPPER(?)+ '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text6) like '%' + UPPER(?)+ '%'  \n "));
					sm.addStringParameter(search);

					sb.append(sm.addSelectString(" or upper(text7) like '%' + UPPER(?)+ '%'  \n "));
					sm.addStringParameter(search);
				}

				sb.append("  )  and  \n ");
			}

			//sb.append("USE_FLAG <> 'N'   \n ");
			sb.append("  " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' \n ");
			sb.append(" order by code 	  \n ");

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
	} //

	public SepoaOut getCodedInsert(SepoaInfo info, String type, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodedInsert(info, type, bean_args);
			
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

	private String[] et_getCodedInsert(SepoaInfo info, String type, String[][] bean_args) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_args.length; i++)
			{
				String language = bean_args[i][0];
				String code = bean_args[i][1];
				String text1 = bean_args[i][2];
				String text2 = bean_args[i][3];
				String text3 = bean_args[i][4];
				String text4 = bean_args[i][5];
				String text5 = bean_args[i][6];
				String text6 = bean_args[i][7];
				String text7 = bean_args[i][8];
				String flag = bean_args[i][9];
				String sort_seq = bean_args[i][10];
				String use_flag = bean_args[i][11];

				if(use_flag.equals("0"))
				{
					use_flag = "N";
				}
				else
				{
					use_flag = "Y";
				}

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" SELECT count(*) FROM SCODE \n ");
				sb.append(sm.addFixString(" WHERE CODE =?	 	  \n "));
				sm.addStringParameter(code);
				sb.append(sm.addFixString(" AND TYPE =? 	  \n "));
				sm.addStringParameter(type.toUpperCase());
				sb.append(sm.addFixString(" AND LANGUAGE =? 	  \n "));
				sm.addStringParameter(language.toUpperCase());
				sb.append(sm.addFixString(" AND HOUSE_CODE =? 	  \n "));
				sm.addStringParameter(info.getSession("HOUSE_CODE"));
				rtn[0] = sm.doSelect(sb.toString());
				
				SepoaFormater wf = new SepoaFormater(rtn[0]);
				int code_count = Integer.parseInt(wf.getValue(0, 0));
				
				if (code_count > 0)
				{
					Vector multilang_id = new Vector();
					multilang_id.addElement("AD_015_BEAN");
				    HashMap text = MessageUtil.getMessage(info,multilang_id);
				    rtn[1] = (String) text.get("AD_015_BEAN.exists_code");
					return rtn;
				} 

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" insert into scode \n ");
				sb.append(" ( 	\n ");
				sb.append("   HOUSE_CODE \n "); //0
				sb.append(" , LANGUAGE \n "); //0
				sb.append(" , TYPE \n "); //0
				sb.append(" , CODE \n "); //2
				sb.append(" , TEXT1 \n "); //3
				sb.append(" , TEXT2 \n "); //4
				sb.append(" , TEXT3 \n "); //5
				sb.append(" , TEXT4 \n "); //6
				sb.append(" , TEXT5 \n "); //7
				sb.append(" , TEXT6 \n "); //8
				sb.append(" , TEXT7 \n "); //9
				sb.append(" , FLAG \n "); //10
				sb.append(" , SORT_SEQ \n "); //11
				sb.append(" , ADD_DATE \n "); //12
				sb.append(" , ADD_TIME \n "); //13
				sb.append(" , ADD_USER_ID \n "); //16
				sb.append(" , USE_FLAG \n "); //18
				sb.append(" , DEL_FLAG \n ");

				sb.append(" ) values ( \n ");

				sb.append("  ?, \n "); //0
				sm.addStringParameter(info.getSession("HOUSE_CODE"));
				sb.append("  ?, \n "); //0
				sm.addStringParameter(language.toUpperCase());
				sb.append("  ?, \n "); //0
				sm.addStringParameter(type.toUpperCase());
				sb.append("  ?, \n "); //2
				sm.addStringParameter(code);
				sb.append("  ?, \n "); //3
				sm.addStringParameter(text1);
				sb.append("  ?, \n "); //4
				sm.addStringParameter(text2);
				sb.append("  ?, \n "); //5
				sm.addStringParameter(text3);
				sb.append("  ?, \n "); //6
				sm.addStringParameter(text4);
				sb.append("  ?, \n "); //7
				sm.addStringParameter(text5);
				sb.append("  ?, \n "); //8
				sm.addStringParameter(text6);
				sb.append("  ?, \n "); //9
				sm.addStringParameter(text7);
				sb.append("  ?, \n "); //10
				sm.addStringParameter(flag);
				sb.append("  ?, \n "); //11
				sm.addStringParameter(sort_seq.toUpperCase());
				sb.append("  ?, \n ");
				sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append("  ?, \n ");
				sm.addStringParameter(SepoaDate.getShortTimeString());
				sb.append("  ?,  \n "); //16
				sm.addStringParameter(info.getSession("ID"));
				sb.append("  ?,  \n "); //18
				sm.addStringParameter(use_flag);
				sb.append("  ?  \n ");
				sm.addStringParameter("N");

				sb.append(" ) \n ");
				sm.doInsert(sb.toString());
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

	public SepoaOut getCodedDelete(SepoaInfo info, String type, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodedDelete(info, type, bean_args);

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

	private String[] et_getCodedDelete(SepoaInfo info, String type, String[][] bean_args) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for(int i = 0; i < bean_args.length; i++)
            {
            	String language = bean_args[i][0];
	           	String code = bean_args[i][1];

	        	sm.removeAllValue();
	            sb.delete(0, sb.length());
	            sb.append(" delete from  SCODE   \n ");
	            sb.append(" where code = ? 	\n ");sm.addStringParameter(code);
	            sb.append(" and type = ?     	\n");sm.addStringParameter(type.toUpperCase());
	            sb.append(" and language = ?     	\n");sm.addParameter(language.toUpperCase());
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

	public SepoaOut getCodedModify(SepoaInfo info, String type, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodedModify(info, type, bean_args);

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

	private String[] et_getCodedModify(SepoaInfo info, String type, String[][] bean_args) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		SepoaFormater sf = null;

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for(int i = 0; i < bean_args.length; i++)
            {
            	 String use_flag = bean_args[i][0];
            	 String language = bean_args[i][1];
            	 String code = bean_args[i][2];
            	 String codeH = bean_args[i][3];
            	 String text1= bean_args[i][4];
            	 String text2 = bean_args[i][5];
            	 String text3= bean_args[i][6];
            	 String text4 = bean_args[i][7];
            	 String text5= bean_args[i][8];
            	 String text6 = bean_args[i][9];
            	 String text7= bean_args[i][10];
            	 String flag = bean_args[i][11];
            	 String sort = bean_args[i][12];

            	 sm.removeAllValue();
                 sb.delete(0, sb.length());
                 sb.append(" select count(*) cnt \n ");
                 sb.append(" from scode \n ");
                 sb.append(sm.addFixString(" where type = ? \n "));
                 sm.addStringParameter(type);

                 sb.append(sm.addFixString("   and code = ? \n "));
                 sm.addStringParameter(code);
                 sf = new SepoaFormater(sm.doSelect(sb.toString()));

                 if(Integer.parseInt(sf.getValue("cnt", 0)) <= 0)
                 {
 					Vector multilang_id = new Vector();
					multilang_id.addElement("AD_015_BEAN");
				    HashMap text = MessageUtil.getMessage(info,multilang_id);
				    rtn[1] = (String) text.get("AD_015_BEAN.not_exists_code") + " Code : " + code;
                 }
                 else
                 {
                	 sm.removeAllValue();
                     sb.delete(0, sb.length());
                     sb.append(" 	update scode set \n ");
                     sb.append(" 		TEXT1 = ?, \n "); sm.addStringParameter(text1);
                     sb.append(" 		TEXT2 = ?, \n "); sm.addStringParameter(text2);
                     sb.append(" 		TEXT3 = ?, \n "); sm.addStringParameter(text3);
                     sb.append(" 		TEXT4 = ?, \n "); sm.addStringParameter(text4);
                     sb.append(" 		TEXT5 = ?, \n "); sm.addStringParameter(text5);
                     sb.append(" 		TEXT6 = ?, \n "); sm.addStringParameter(text6);
                     sb.append(" 		TEXT7 = ?, \n "); sm.addStringParameter(text7);
                     sb.append(" 		FLAG = ?, 	 \n "); sm.addStringParameter(flag);
                     sb.append(" 		SORT_SEQ = ?, \n "); sm.addStringParameter(sort);
                     sb.append("        DEL_FLAG = 'N', \n ");
                     sb.append(" 		CHANGE_DATE = ?, \n "); sm.addStringParameter(SepoaDate.getShortDateString());
                     sb.append(" 		CHANGE_TIME = ?, \n "); sm.addStringParameter(SepoaDate.getShortTimeString());
                     sb.append(" 		CHANGE_USER_ID = ?, \n "); sm.addStringParameter(info.getSession("ID"));
                     sb.append(" 		USE_FLAG = ?, \n "); sm.addStringParameter(use_flag);
                     sb.append(" 		LANGUAGE = ? \n "); sm.addStringParameter(language);
                     sb.append(" where type = ? \n ");
                     sm.addStringParameter(type);

                     sb.append("   and code = ? \n ");
                     sm.addStringParameter(code);

                     sb.append("   and language = ? \n ");
                     sm.addStringParameter(language);
                     sm.doInsert(sb.toString());
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

}