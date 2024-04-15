package sepoa.svc.admin;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;


public class AD_014 extends SepoaService
{
	private String ID = info.getSession("ID");

	public AD_014(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}



	public SepoaOut getCodehQuery(SepoaInfo info, String code, String searchword)
    {
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodedQuery(info, code, searchword);

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

    public String[] et_getCodedQuery(SepoaInfo info, String code, String searchword) throws Exception
    {
    	String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" select 			\n ");
            sb.append("   type, 		\n ");
            sb.append("   code,			\n ");
            sb.append("   flag, 		\n ");
            sb.append("   text1, 		\n ");
            sb.append("   text2,		\n ");
            sb.append("   text3, 		\n ");
            sb.append("   text4, 		\n ");
            sb.append("   use_flag, 	\n ");
            sb.append("   add_user_id,	\n ");
            sb.append("   change_user_id, \n ");
            sb.append("   add_date, \n ");
            sb.append("   add_time, \n ");
            sb.append("   change_date, \n ");
            sb.append("   change_time  \n ");
            sb.append(" from SCODE  \n ");

            if (code.length() > 0){
            	if(SEPOA_DB_VENDOR.equals("MSSQL"))
            	{
            		sb.append(sm.addFixString(" where  CHARINDEX(UPPER(code),UPPER(?))>0 \n "));sm.addStringParameter(code.toUpperCase());
            	}
            	else
            	{
            		sb.append(sm.addFixString(" where  INSTR(UPPER(code),UPPER(?))>0 \n "));sm.addStringParameter(code.toUpperCase());
            	}
            	sb.append(sm.addSelectString(" and type=?	\n "));sm.addStringParameter("M000");
            	sb.append(" and    		\n ");
            }else{
            	sb.append(sm.addFixString(" where type=?  \n "));sm.addStringParameter("M000");
            	sb.append(" and    		  \n ");
            }

            if (searchword.length() > 0)
            {
            	sb.append(" (	\n ");
            	if(SEPOA_DB_VENDOR.equals("MSSQL"))
            	{
            		sb.append(sm.addSelectString("    upper(text2) like upper('%'+ ?+ '%')  \n "));
            		sm.addStringParameter(searchword);

            		sb.append(sm.addSelectString(" or upper(text3) like upper('%' +?+ '%')  \n "));
            		sm.addStringParameter(searchword);

            		sb.append(sm.addSelectString(" or upper(text1) like upper('%'+ ?+ '%')  \n "));
            		sm.addStringParameter(searchword);
            	}
            	if(SEPOA_DB_VENDOR.equals("MYSQL"))
            	{
            		sb.append(sm.addSelectString("    upper(text2) like upper('%' ,?, '%')  \n "));
            		sm.addStringParameter(searchword);

            		sb.append(sm.addSelectString(" or upper(text3) like upper('%' ,?, '%')  \n "));
            		sm.addStringParameter(searchword);

            		sb.append(sm.addSelectString(" or upper(text1) like upper('%' ,?, '%')  \n "));
            		sm.addStringParameter(searchword);
            	}
            	if(SEPOA_DB_VENDOR.equals("ORACLE"))
            	{
            		sb.append(sm.addSelectString("    upper(text2) like upper('%' || ? || '%')  \n "));
            		sm.addStringParameter(searchword);

            		sb.append(sm.addSelectString(" or upper(text3) like upper('%' ||?|| '%')  \n "));
            		sm.addStringParameter(searchword);

            		sb.append(sm.addSelectString(" or upper(text1) like upper('%'|| ?||'%')  \n "));
            		sm.addStringParameter(searchword);
            	}
                sb.append("  )  and  \n ");
            }
            //sb.append("     USE_FLAG <> 'N'   		\n ");
            sb.append("  " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' \n ");
            sb.append("  AND LANGUAGE = 'KO'	\n ");
            sb.append(sm.addFixString("  AND HOUSE_CODE = ?	\n "));
            sm.addStringParameter(info.getSession("HOUSE_CODE"));
//            sb.append("  AND " + DB_NULL_FUNCTION + "(use_flag, 'Y') = 'Y' \n ");
            sb.append(" order by code 		 	\n ");

            rtn[0] = sm.doSelect(sb.toString());

            if (rtn[0] == null)
            {
                rtn[1] = "SQL manager is Null";
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

    public SepoaOut getCodehDelete(SepoaInfo info, String[][] bean_info)
    {
    	try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodehDelete(info, bean_info);

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

    public String[] et_getCodehDelete(SepoaInfo info, String[][] bean_info) throws Exception
    {
    	String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for(int i = 0; i < bean_info.length; i++)
            {
				String code = bean_info[i][0];
           	 	String type = bean_info[i][1];

           	 	sm.removeAllValue();
                sb.delete(0, sb.length());

                sb.append(" delete from  SCODE  \n ");
                sb.append(" where code = ? 		\n ");sm.addParameter(code.toUpperCase());
                sb.append(" and type = ?    		\n ");sm.addParameter(type.toUpperCase());
                sb.append(" and LANGUAGE = 'KO'    		\n ");
                sb.append(" and HOUSE_CODE = ?    		\n ");sm.addStringParameter(info.getSession("HOUSE_CODE"));
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

    public SepoaOut getCodehInsert(SepoaInfo info, String code, String type, String text2, String text3, String note)
    {
    	try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodehInsert(info, code, type, text2, text3, note);

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

    private String[] et_getCodehInsert(SepoaInfo info, String code, String type, String text2, String text3, String note) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		String rtn_sql = "";
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

//			if (type.length() >= 0){
//	            sm.removeAllValue();
//	            sb.delete(0, sb.length());
//	            sb.append(" select 'M' || to_char(to_number(substr(max(code), 2, 4)) + 1, 'FM000') code from moldcode ");
//	            sb.append(sm.addFix(" where type = ? "));sm.addParameter("M000");
//	            sb.append(" and status <> 'D' ");
//
//	            rtn_sql = sm.doSelect(sb.toString());
//
//	            SepoaFormater wf = new SepoaFormater(rtn_sql);
//	            code = wf.getValue("code", 0);
//	            rtn[0] = code;
//            }

            sm.removeAllValue();
            sb.delete(0, sb.length());
            sb.append(" insert into SCODE \n ");
            sb.append(" ( \n ");
            sb.append("   HOUSE_CODE \n ");//0
            sb.append(" , TYPE \n ");//1
            sb.append(" , CODE \n ");//2
            sb.append(" , TEXT1 \n ");//4-1
            sb.append(" , TEXT2 \n ");//4-2
            sb.append(" , TEXT3 \n ");//5
            sb.append(" , TEXT4 \n ");//6
            sb.append(" , FLAG \n ");//7
            sb.append(" , USE_FLAG \n ");//8
            sb.append(" , DEL_FLAG \n ");//9
            sb.append(" , ADD_DATE \n ");//10
            sb.append(" , ADD_TIME \n ");//11
            sb.append(" , CHANGE_DATE \n ");//12
            sb.append(" , CHANGE_TIME \n ");//13
            sb.append(" , ADD_USER_ID \n ");//14
            sb.append(" , CHANGE_USER_ID \n ");//15
            sb.append(" , SORT_SEQ \n ");//16
            sb.append(" , LANGUAGE \n ");//17

            sb.append(" ) values ( \n ");

            sb.append("  ?, \n ");//1
            sm.addStringParameter(info.getSession("HOUSE_CODE"));
            sb.append("  ?, \n ");//1
            sm.addParameter("M000");
            sb.append("  ?, \n ");//2
            sm.addParameter(code.toUpperCase());
            sb.append("  ?, \n ");//3
            sm.addParameter(text2);
            sb.append("  ?, \n ");//4-2
            sm.addParameter(text2);
            sb.append("  ?, \n ");//5
            sm.addParameter(text3);
            sb.append("  ?, \n ");//6
            sm.addParameter(note);
            sb.append("  ?, \n ");//7
            sm.addParameter("M");
            sb.append("  ?, \n ");//8
            sm.addParameter("Y");
            sb.append("  ?, \n ");//9
            sm.addParameter("N");
            sb.append("  ?, \n "); sm.addParameter(SepoaDate.getShortDateString());
            sb.append("  ?, \n "); sm.addParameter(SepoaDate.getShortTimeString());
            sb.append("  ?, \n "); sm.addParameter(SepoaDate.getShortDateString());
            sb.append("  ?, \n "); sm.addParameter(SepoaDate.getShortTimeString());
            sb.append("  ?,  \n ");//14
            sm.addParameter(info.getSession("ID"));
            sb.append("  ?,  \n ");//15
            sm.addParameter(info.getSession("ID"));
            sb.append("  ?, \n ");//16
            sm.addParameter("1");
            sb.append("  'KO' \n ");//16
            sb.append(" ) \n ");
            sm.doInsert(sb.toString());

            rtn[0] = code;
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

    public SepoaOut getCodehUpdate(SepoaInfo info, String code, String type, String text2, String text3, String note, String use_flag)
    {
    	try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodehUpdate(info, code, type, text2, text3, note, use_flag);

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

    private String[] et_getCodehUpdate(SepoaInfo info, String code, String type, String text2, String text3, String note, String use_flag) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		SepoaFormater sf = null;
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
            sm.removeAllValue();
            sb.delete(0, sb.length());

			sb.append(" update SCODE \n ");
            sb.append(" set  \n ");

            sb.append(" TEXT2 = ?, \n ");//2
            sb.append(" TEXT3 = ?, \n ");//3
            sb.append(" TEXT4 = ?, \n ");//4
            sb.append(" use_flag = ?, \n ");//
            sb.append(" CHANGE_USER_ID = ?, \n ");//7
            sb.append(" CHANGE_DATE = ?, \n ");//5
            sb.append(" CHANGE_TIME = ? \n ");//6

            sm.addParameter(text2);
            sm.addParameter(text3);
            sm.addParameter(note);
            sm.addParameter(use_flag);
            sm.addParameter(info.getSession("ID"));
            sm.addParameter(SepoaDate.getShortDateString());
            sm.addParameter(SepoaDate.getShortTimeString());
            sb.append(" where type = ?  \n ");sm.addParameter(type.toUpperCase());
            sb.append(" and code = ? 	\n ");sm.addParameter(code.toUpperCase());
            sb.append(" and LANGUAGE = 'KO' 	\n ");

            //sm.doUpdateMore(sb.toString());
            sm.doUpdate(sb.toString());
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

    public SepoaOut getCodehList(SepoaInfo info, String code)
    {
    	try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getCodehList(info, code);

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

    private String[] et_getCodehList(SepoaInfo info, String code) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sb.append(" select 			\n ");
            sb.append("   type, 		\n ");
            sb.append("   code,			\n ");
            sb.append("   flag, 		\n ");
            sb.append("   text1, 		\n ");
            sb.append("   text2,		\n ");
            sb.append("   text3, 		\n ");
            sb.append("   text4, 		\n ");
            sb.append("   use_flag, 	\n ");
            sb.append("   add_user_id,	\n ");
            sb.append("   change_user_id, \n ");

            if(SEPOA_DB_VENDOR.equals("ORACLE"))
            {
            	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(add_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(add_time) add_date, \n ");
            	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(change_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(change_time) change_date \n ");
            }
            else if(SEPOA_DB_VENDOR.equals("MYSQL"))
            {
            	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(add_date) , ' ' , " + SEPOA_DB_OWNER + "getTimeFormat(add_time) add_date, \n ");
            	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(change_date) , ' ' , " + SEPOA_DB_OWNER + "getTimeFormat(change_time) change_date \n ");
            }
            else if(SEPOA_DB_VENDOR.equals("MSSQL"))
            {
            	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(add_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(add_time) add_date, \n ");
            	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(change_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(change_time) change_date \n ");
            }



            sb.append(" from SCODE  	\n ");

            if (code.length() > 0){
            	sb.append(sm.addFix(" where  code=? \n "));sm.addParameter(code);
            	sb.append(" and    \n ");
            }

            //sb.append(" USE_FLAG <> 'N' and	\n ");
            sb.append("  " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' \n ");
            sb.append("  AND LANGUAGE = 'KO' \n ");
            sb.append("  AND TYPE = 'M000' \n ");
            sb.append(" order by code  		\n ");
            rtn[0] = sm.doSelect(sb.toString());

            if (rtn[0] == null)
            {
                rtn[1] = "SQL manager is Null";
            }
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
