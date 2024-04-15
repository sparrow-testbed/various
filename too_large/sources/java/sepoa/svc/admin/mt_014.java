package sepoa.svc.admin;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DBUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sms.SMS;


public class MT_014 extends SepoaService
{
    private Message msg;

    public MT_014(String opt, SepoaInfo info) throws SepoaServiceException
    {
        super(opt, info);
        msg = new Message(info, "MT_014");
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

    public SepoaOut getSendNotice()
    {
        try
        {
            String rtn = DogetSendNotice();
            setStatus(1);
            setValue(rtn);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0200"));
        }

        return getSepoaOut();
    }

    private String DogetSendNotice() throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT SUBJECT  \n");
        tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = SNOTE.COMPANY_CODE),'') AS COMPANY_NAME  \t\n").toString());
        tSQL.append(" , ADD_DATE  \t\n");
        tSQL.append(" , ATTACH_NO  \t\n");
        tSQL.append(" , CONTENT   \t\n");
        tSQL.append(" , SEQ   \n");
        tSQL.append(" , NOTE_TYPE\n");
        tSQL.append(" , " + SEPOA_DB_OWNER + "getCodeText1('M222', GONGJI_GUBUN, '" + info.getSession("LANGUAGE") + "') GONGJI_GUBUN \n ");
        tSQL.append(" FROM SNOTE  \n");
        tSQL.append(" WHERE \n");
        tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(DEL_FLAG, 'N') <> 'Y' \t\n").toString());
        tSQL.append(" ORDER BY \t\n");
        tSQL.append(" SEQ DESC\n");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect(new HashMap());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    public SepoaOut getDataStore(Map< String, Object > allData)
    {
        try
        {
        	Map<String,String> headerData=new HashMap();
        	headerData = MapUtils.getMap( allData, "headerData" );
            //String rtn = DogetSupNotice(gubun, guest, company_code,dept_type);
        	String rtn = DogetDataStore(headerData.get("gubun"),headerData.get("guest"),headerData.get("company_code"),headerData.get("dept_type"),headerData.get("view_user_type"));
            setStatus(1);
            setValue(rtn);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0200"));
        }

        return getSepoaOut();
    }
    
    private String DogetDataStore(String gubun, String guest, String company_code,String dept_type,String view_user_type) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        String language = info.getSession("LANGUAGE");

        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT NOTE.SUBJECT  \n");
        tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = NOTE.COMPANY_CODE),'') AS COMPANY_NAME  \t\n").toString());
        tSQL.append(" , getCodeText1('M216', NOTE.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \t\n");
        tSQL.append(" , NOTE.ADD_DATE  \t\n");
        tSQL.append(" , NOTE.ATTACH_NO  \t\n");

        tSQL.append(" , (SELECT count(*) FROM SFILE X WHERE X.DOC_NO = NOTE.ATTACH_NO) AS ATTACH_NAME   \t\n");

        tSQL.append(" , NOTE.CONTENT   \t\n");
        tSQL.append(" , NOTE.SEQ   \n");
        tSQL.append(" , NOTE.NOTE_TYPE \n");

        tSQL.append(" , NOTE.GONGJI_GUBUN AS GONGJI_GUBUN_CODE \n");
        tSQL.append(" , getCodeText1('M222', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN  \n");
        tSQL.append(" , NOTE.VIEW_COUNT \n");
        tSQL.append(" , NOTE.PUBLISH_FLAG        \n");
        tSQL.append(" , NOTE.PUBLISH_FROM_DATE   \n");
        tSQL.append(" , NOTE.PUBLISH_TO_DATE     \n");
        tSQL.append(" , NOTE.ADD_USER_ID                     \n");
        tSQL.append(" , USMT.USER_NAME_LOC AS ADD_USER_NAME  \n");
        tSQL.append(" , NOTE.VIEW_USER_TYPE          \n");
        tSQL.append(" , GETCODETEXT2('Z001', NOTE.VIEW_USER_TYPE, 'KO') AS VIEW_USER_TYPE_TEXT          \n");
        tSQL.append(" FROM SDSHD NOTE, ICOMLUSR USMT \n");
        tSQL.append(" WHERE \n");
        tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(NOTE.DEL_FLAG, 'N') <> 'Y' \t\n").toString());
        tSQL.append("   AND NOTE.ADD_USER_ID = USMT.USER_ID \n ");
        String like_sql = "%" + guest + "%";

        if (!company_code.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.COMPANY_CODE = '")).append(company_code).append("'\t\n ").toString());
        }
        if (!dept_type.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.DEPT_TYPE = '")).append(dept_type).append("'\t\n ").toString());
        }

        if ((gubun.length() > 0) && (guest.length() > 0))
        {
            if (gubun.equals("S"))
            {
                tSQL.append("   AND upper(NOTE.SUBJECT) LIKE  '"+like_sql+"' \n ");
            }

            if (gubun.equals("U"))
            {
                tSQL.append("   AND upper(USMT.USER_NAME_LOC)  LIKE  '" + like_sql + "' \n ");
            }

            if (gubun.equals("D"))
            {
                tSQL.append(sm.addSelectString("   AND NOTE.ADD_DATE = ? \t\n "));
                sm.addStringParameter(guest);
            }

            if (gubun.equals("C"))
            {
                tSQL.append(" and exists (select 'x' from snotd notd where notd.seq = note.seq and \n ");
                tSQL.append("             upper(notd.content) like '" + like_sql + "') \n ");
            }
        }

//        tSQL.append("	AND NOTE.ADD_DATE between TO_CHAR(SYSDATE - 180, 'YYYYMMDD') and TO_CHAR(SYSDATE, 'YYYYMMDD') \n ");
        if ( !view_user_type.equals("X") ) {
        	tSQL.append("	AND NOTE.VIEW_USER_TYPE IN ( '" + view_user_type + "', 'X' ) \n ");
        }

        tSQL.append(" ORDER BY \t\n");
        tSQL.append(" SEQ DESC\n");

        

        try
        {
            rtn = sm.doSelect(tSQL.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public SepoaOut getSupNotice(Map< String, Object > allData)
    {
        try
        {
        	Map<String,String> headerData=new HashMap();
        	headerData = MapUtils.getMap( allData, "headerData" );
            //String rtn = DogetSupNotice(gubun, guest, company_code,dept_type);
        	String rtn = DogetSupNotice(headerData.get("gubun"),headerData.get("guest"),headerData.get("company_code"),headerData.get("dept_type"),headerData.get("view_user_type"));
            setStatus(1);
            setValue(rtn);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0200"));
        }

        return getSepoaOut();
    }

    private String DogetSupNotice(String gubun, String guest, String company_code,String dept_type,String view_user_type) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        String language = info.getSession("LANGUAGE");

        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT NOTE.SUBJECT  \n");
        tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = NOTE.COMPANY_CODE),'') AS COMPANY_NAME  \t\n").toString());
        tSQL.append(" , getCodeText1('M216', NOTE.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \t\n");
        tSQL.append(" , NOTE.ADD_DATE  \t\n");
        tSQL.append(" , NOTE.ATTACH_NO  \t\n");

        tSQL.append(" , (SELECT count(*) FROM SFILE X WHERE X.DOC_NO = NOTE.ATTACH_NO) AS ATTACH_NAME   \t\n");

        tSQL.append(" , NOTE.CONTENT   \t\n");
        tSQL.append(" , NOTE.SEQ   \n");
        tSQL.append(" , NOTE.NOTE_TYPE \n");

        tSQL.append(" , NOTE.GONGJI_GUBUN AS GONGJI_GUBUN_CODE \n");
        tSQL.append(" , getCodeText1('M222', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN  \n");
        tSQL.append(" , NOTE.VIEW_COUNT \n");
        tSQL.append(" , NOTE.PUBLISH_FLAG        \n");
        tSQL.append(" , NOTE.PUBLISH_FROM_DATE   \n");
        tSQL.append(" , NOTE.PUBLISH_TO_DATE     \n");
        tSQL.append(" , NOTE.ADD_USER_ID                     \n");
        tSQL.append(" , USMT.USER_NAME_LOC AS ADD_USER_NAME  \n");
        tSQL.append(" , NOTE.VIEW_USER_TYPE          \n");
        tSQL.append(" , GETCODETEXT2('Z001',NOTE.VIEW_USER_TYPE,'KO') AS VIEW_USER_TYPE_TEXT          \n");
        tSQL.append(" FROM SNOTE NOTE, ICOMLUSR USMT \n");
        tSQL.append(" WHERE \n");
        tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(NOTE.DEL_FLAG, 'N') <> 'Y' \t\n").toString());
        tSQL.append("   AND NOTE.ADD_USER_ID = USMT.USER_ID \n ");
        String like_sql = "%" + guest + "%";

        if (!company_code.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.COMPANY_CODE = '")).append(company_code).append("'\t\n ").toString());
        }
        if (!dept_type.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.DEPT_TYPE = '")).append(dept_type).append("'\t\n ").toString());
        }

        if ((gubun.length() > 0) && (guest.length() > 0))
        {
            if (gubun.equals("S"))
            {
                tSQL.append("   AND upper(NOTE.SUBJECT) LIKE  '"+like_sql+"' \n ");
            }

            if (gubun.equals("U"))
            {
                tSQL.append("   AND upper(USMT.USER_NAME_LOC)  LIKE  '" + like_sql + "' \n ");
            }

            if (gubun.equals("D"))
            {
                tSQL.append(sm.addSelectString("   AND NOTE.ADD_DATE = ? \t\n "));
                sm.addStringParameter(guest);
            }

            if (gubun.equals("C"))
            {
                tSQL.append(" and exists (select 'x' from snotd notd where notd.seq = note.seq and \n ");
                tSQL.append("             upper(notd.content) like '" + like_sql + "') \n ");
            }
        }

//        tSQL.append("	AND NOTE.ADD_DATE between TO_CHAR(SYSDATE - 180, 'YYYYMMDD') and TO_CHAR(SYSDATE, 'YYYYMMDD') \n ");
        if ( !view_user_type.equals("X") ) {
        	tSQL.append("	AND NOTE.VIEW_USER_TYPE IN ( '" + view_user_type + "', 'X' ) \n ");
        }

        tSQL.append(" ORDER BY \t\n");
        tSQL.append(" SEQ DESC\n");

        

        try
        {
            rtn = sm.doSelect(tSQL.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    public SepoaOut getSupFaq(Map< String, Object > allData)
    {
    	try
    	{
    		Map<String,String> headerData=new HashMap();
    		headerData = MapUtils.getMap( allData, "headerData" );
    		//String rtn = DogetSupNotice(gubun, guest, company_code,dept_type);
    		String rtn = DogetSupFaq(headerData.get("gubun"),headerData.get("guest"),headerData.get("company_code"),headerData.get("dept_type"),headerData.get("view_user_type"));
    		setStatus(1);
    		setValue(rtn);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		setStatus(0);
    		setMessage(msg.getMessage("0200"));
    	}
    	
    	return getSepoaOut();
    }
    
    private String DogetSupFaq(String gubun, String guest, String company_code,String dept_type,String view_user_type) throws Exception
    {
    	String rtn = null;
    	sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
    	ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    	String language = info.getSession("LANGUAGE");
    	
    	StringBuffer tSQL = new StringBuffer();
    	tSQL.append(" SELECT NOTE.SUBJECT  \n");
    	tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = NOTE.COMPANY_CODE),'') AS COMPANY_NAME  \t\n").toString());
    	tSQL.append(" , getCodeText1('M216', NOTE.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \t\n");
    	tSQL.append(" , NOTE.ADD_DATE  \t\n");
    	tSQL.append(" , NOTE.ATTACH_NO  \t\n");
    	
    	tSQL.append(" , (SELECT count(*) FROM SFILE X WHERE X.DOC_NO = NOTE.ATTACH_NO) AS ATTACH_NAME   \t\n");
    	
    	tSQL.append(" , NOTE.CONTENT   \t\n");
    	tSQL.append(" , NOTE.SEQ   \n");
    	tSQL.append(" , NOTE.NOTE_TYPE \n");
    	
    	tSQL.append(" , NOTE.GONGJI_GUBUN AS GONGJI_GUBUN_CODE \n");
    	tSQL.append(" , getCodeText1('M222', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN  \n");
    	tSQL.append(" , NOTE.VIEW_COUNT \n");
    	tSQL.append(" , NOTE.PUBLISH_FLAG        \n");
    	tSQL.append(" , NOTE.PUBLISH_FROM_DATE   \n");
    	tSQL.append(" , NOTE.PUBLISH_TO_DATE     \n");
    	tSQL.append(" , NOTE.ADD_USER_ID                     \n");
    	tSQL.append(" , USMT.USER_NAME_LOC AS ADD_USER_NAME  \n");
    	tSQL.append(" , NOTE.VIEW_USER_TYPE         \n");
    	tSQL.append(" , GETCODETEXT2( 'Z001', NOTE.VIEW_USER_TYPE, 'KO' ) AS VIEW_USER_TYPE_TEXT         \n");
    	tSQL.append(" FROM SFAQ NOTE, ICOMLUSR USMT \n");
    	tSQL.append(" WHERE \n");
    	tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(NOTE.DEL_FLAG, 'N') <> 'Y' \t\n").toString());
    	tSQL.append("   AND NOTE.ADD_USER_ID = USMT.USER_ID \n ");
    	String like_sql = "%" + guest + "%";
    	
    	if (!company_code.equals(""))
    	{
    		tSQL.append((new StringBuilder("   AND NOTE.COMPANY_CODE = '")).append(company_code).append("'\t\n ").toString());
    	}
    	if (!dept_type.equals(""))
    	{
    		tSQL.append((new StringBuilder("   AND NOTE.DEPT_TYPE = '")).append(dept_type).append("'\t\n ").toString());
    	}
    	
    	if ((gubun.length() > 0) && (guest.length() > 0))
    	{
    		if (gubun.equals("S"))
    		{
    			tSQL.append("   AND upper(NOTE.SUBJECT) LIKE  '"+like_sql+"' \n ");
    		}
    		
    		if (gubun.equals("U"))
    		{
    			tSQL.append("   AND upper(USMT.USER_NAME_LOC)  LIKE  '" + like_sql + "' \n ");
    		}
    		
    		if (gubun.equals("D"))
    		{
    			tSQL.append(sm.addSelectString("   AND NOTE.ADD_DATE = ? \t\n "));
    			sm.addStringParameter(guest);
    		}
    		
    		if (gubun.equals("C"))
    		{
    			tSQL.append(" and exists (select 'x' from snotd sfaqd where notd.seq = note.seq and \n ");
    			tSQL.append("             upper(notd.content) like '" + like_sql + "') \n ");
    		}
    	}
    	
    	if( !view_user_type.equals("X") ) {
    		tSQL.append("	AND NOTE.VIEW_USER_TYPE IN ( '" + view_user_type + "', 'X' ) \n ");
    	}
//    	tSQL.append("	AND NOTE.ADD_DATE between TO_CHAR(SYSDATE - 180, 'YYYYMMDD') and TO_CHAR(SYSDATE, 'YYYYMMDD') \n ");
    	
    	tSQL.append(" ORDER BY \t\n");
    	tSQL.append(" SEQ DESC\n");
    	
    	
    	
    	try
    	{
    		rtn = sm.doSelect(tSQL.toString());
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    public SepoaOut getSupNotice_seller(String gubun, String guest, String company_code,String dept_type)
    {
        try
        {
            String rtn = DogetSupNotice_seller(gubun, guest, company_code,dept_type);
            setStatus(1);
            setValue(rtn);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0200"));
        }

        return getSepoaOut();
    }

    private String DogetSupNotice_seller(String gubun, String guest, String company_code,String dept_type) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        String language = info.getSession("LANGUAGE");

        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT NOTE.SUBJECT  \n");
        tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = NOTE.COMPANY_CODE),'') AS COMPANY_NAME  \t\n").toString());
        tSQL.append(" , getCodeText1('M216', NOTE.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \t\n");
        tSQL.append(" , NOTE.ADD_DATE  \t\n");
        tSQL.append(" , NOTE.ATTACH_NO  \t\n");

        tSQL.append(" , (SELECT count(*) FROM SFILE X WHERE X.DOC_NO = NOTE.ATTACH_NO) AS ATTACH_NAME   \t\n");

        tSQL.append(" , NOTE.CONTENT   \t\n");
        tSQL.append(" , NOTE.SEQ   \n");
        tSQL.append(" , NOTE.NOTE_TYPE \n");

        tSQL.append(" , NOTE.GONGJI_GUBUN AS GONGJI_GUBUN_CODE \n");
        tSQL.append(" , getCodeText1('M222', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN  \n");
        tSQL.append(" , NOTE.VIEW_COUNT \n");
        tSQL.append(" , NOTE.PUBLISH_FLAG        \n");
        tSQL.append(" , NOTE.PUBLISH_FROM_DATE   \n");
        tSQL.append(" , NOTE.PUBLISH_TO_DATE     \n");
        tSQL.append(" , NOTE.ADD_USER_ID                     \n");
        tSQL.append(" , USMT.USER_NAME_LOC AS ADD_USER_NAME  \n");
        tSQL.append(" FROM SNOTE NOTE, ICOMLUSR USMT \n");
        tSQL.append(" WHERE \n");
        tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(NOTE.DEL_FLAG, 'N') <> 'Y' \t\n").toString());
        tSQL.append("   AND NOTE.ADD_USER_ID = USMT.USER_ID \n ");
        String like_sql = "%" + guest + "%";

        if (!company_code.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.COMPANY_CODE = '")).append(company_code).append("'\t\n ").toString());
        }else{
        	tSQL.append("AND (NOTE.COMPANY_CODE in (SELECT COMPANY_CODE FROM SSUPU WHERE SELLER_CODE = '"+info.getSession("COMPANY_CODE")+"')	OR NOTE.COMPANY_CODE is null)");
        }
        if (!dept_type.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.DEPT_TYPE = '")).append(dept_type).append("'\t\n ").toString());
        }

        if ((gubun.length() > 0) && (guest.length() > 0))
        {
            if (gubun.equals("S"))
            {
                tSQL.append("   AND upper(NOTE.SUBJECT) LIKE  '"+like_sql+"' \n ");
            }

            if (gubun.equals("U"))
            {
                tSQL.append("   AND upper(USMT.USER_NAME_LOC)  LIKE  '" + like_sql + "' \n ");
            }

            if (gubun.equals("D"))
            {
                tSQL.append(sm.addSelectString("   AND NOTE.ADD_DATE = ? \t\n "));
                sm.addStringParameter(guest);
            }

            if (gubun.equals("C"))
            {
                tSQL.append(" and exists (select 'x' from snotd notd where notd.seq = note.seq and \n ");
                tSQL.append("             upper(notd.content) like '" + like_sql + "') \n ");
            }
        }

        tSQL.append("	AND NOTE.ADD_DATE between TO_CHAR(SYSDATE - 180, 'YYYYMMDD') and TO_CHAR(SYSDATE, 'YYYYMMDD') \n ");

        tSQL.append(" ORDER BY \t\n");
        tSQL.append(" SEQ DESC\n");

        

        try
        {
            rtn = sm.doSelect(tSQL.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    public SepoaOut setInsertNotice(String[][] args)
    {
        try
        {
            int rtn = et_setInsertNotice(args);

            if (rtn < 1)
            {
                throw new Exception("INSERT SNOTE ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
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
        }

        return getSepoaOut();
    }

    private int et_setInsertNotice(String[][] args) throws Exception
    {
        int rtn = -1;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        SepoaFormater sf = null;
        StringBuffer tSQL = new StringBuffer();
        sm.removeAllValue();
        tSQL.delete(0, tSQL.length());
        tSQL.append(" SELECT " + DB_NULL_FUNCTION + "(MAX(SEQ), 0) + 1 cnt FROM SNOTE \n");
        sf = new SepoaFormater(sm.doSelect_limit(tSQL.toString()));

        int code_count = Integer.parseInt(sf.getValue("cnt", 0));
        sm.removeAllValue();
        tSQL.delete(0, tSQL.length());
        tSQL.append(" INSERT INTO SNOTE    \t        \n");
        tSQL.append(" (  \t\n");
        tSQL.append(" \t SEQ  \n");
        tSQL.append(" , SUBJECT  \t\n");
        tSQL.append(" , COMPANY_CODE\n");
        tSQL.append(" , CONTENT  \t\n");
        tSQL.append(" , ATTACH_NO  \t\n");
        tSQL.append(" , ADD_USER_ID  \n");
        tSQL.append(" , ADD_DATE  \t\n");
        tSQL.append(" , ADD_TIME  \t\n");
        tSQL.append(" , DEL_FLAG  \t\n");
        tSQL.append(" , NOTE_TYPE  \t\n");
        tSQL.append(" ) VALUES (   \t\n");
        tSQL.append((new StringBuilder(String.valueOf(code_count))).append(" \n").toString());
        tSQL.append(" , ?  \t\n");
        tSQL.append(" , ?  \t\n");
        tSQL.append(" , ?  \t\n");
        tSQL.append(" , ?  \t\n");
        tSQL.append(" , ?  \t\n");
        tSQL.append(" , ?  \t\n");
        tSQL.append(" , ?  \t\n");
        tSQL.append(" , ?   \n");
        tSQL.append(" , ?   \n");
        tSQL.append(" )   \t\n");

        try
        {
            SepoaSQLManager smt = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S" };
            rtn = smt.doInsert(args, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public SepoaOut getQuery_NOTICE_POP(String obj) throws Exception
    {
        String cnt2;
        String[] args = { obj };
        String rtn = et_getQuery_NOTICE_POP(args);
        setValue(rtn);

        SepoaFormater wf = new SepoaFormater(rtn);
        cnt2 = wf.getValue("ATTACH_NO", 0);

        if ((cnt2 == null) || cnt2.equals(""))
        {
            setValue("");
            setStatus(1);
            setMessage(msg.getMessage("0000"));

            return getSepoaOut();
        }

        try
        {
            String[] args2 = { cnt2 };
            String rtn2 = et_getFile_name(args2);
            setValue(rtn2);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

    private String et_getQuery_NOTICE_POP(String[] args) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT \t \t\n");
        tSQL.append("\tSUBJECT  \t\n");
        tSQL.append((new StringBuilder("\t, ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = SNOTE.COMPANY_CODE),'') AS COMPANY_NAME\t\n").toString());
        tSQL.append("\t, COMPANY_CODE\n");
        tSQL.append("\t, CONTENT \t\n");
        tSQL.append("\t, ATTACH_NO \n");
        tSQL.append("\t, SEQ \n");
        tSQL.append("     , NOTE_TYPE            \n");
        tSQL.append(" FROM SNOTE \t\n");
        tSQL.append(" <OPT=F,S> WHERE SEQ = ? </OPT>\n");
        tSQL.append((new StringBuilder(" AND ")).append(DB_NULL_FUNCTION).append("(DEL_FLAG, 'N') <> 'Y' \t\n").toString());

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect(args);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private String et_getFile_name(String[] args2) throws Exception
    {
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT \t \t\n");
        tSQL.append("\tSRC_FILE_NAME\n");
        tSQL.append(" FROM SFILE \t\n");
        tSQL.append(" <OPT=F,S> WHERE DOC_NO = ? </OPT>\n");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            rtn = sm.doSelect(args2);

            if (rtn == null)
            {
                throw new Exception("SQL Manager is Null");
            }
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public SepoaOut modify(String[][] args) throws Exception
    {
        try
        {
            int rtn = get_modify(args);

            if (rtn < 1)
            {
                throw new Exception("UPDATE SNOTE ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
        }

        return getSepoaOut();
    }

    public int get_modify(String[][] args) throws Exception
    {
        int rtn = 0;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        sql.append(" UPDATE                 \n");
        sql.append(" \tSNOTE            \n");
        sql.append(" SET                    \n");
        sql.append("    SUBJECT     = ?,    \n");
        sql.append("    COMPANY_CODE     = ?,    \n");
        sql.append("    CONTENT     = ?,    \n");
        sql.append("    ATTACH_NO   = ?,  \t\n");
        sql.append("    ADD_USER_ID = ?,    \n");
        sql.append("    DEL_FLAG   \t= ?\n");
        sql.append(" WHERE SEQ = ?          \n");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sql.toString());
            String[] type = { "S", "S", "S", "S", "S", "S", "S" };
            rtn = sm.doUpdate(args, type);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public SepoaOut DeleteSendNotice(String[][] setData)
    {
        try
        {
            int rtn = et_DeleteSendNotice(setData);

            if (rtn < 1)
            {
                throw new Exception("DELETE SNOTE ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
            setMessage(msg.getMessage("0200"));
        }

        return getSepoaOut();
    }

    private int et_DeleteSendNotice(String[][] setData) throws Exception
    {
        int rtn = -1;
        StringBuffer tSQL = new StringBuffer();
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        tSQL.append(" UPDATE SNOTE SET DEL_FLAG = 'Y' ");
        tSQL.append(" WHERE SEQ = ? ");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
            String[] setType = { "S" };
            rtn = sm.doInsert(setData, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

//#########################################  alice method   #####################################################


    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Delete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public SepoaOut DeleteSendFaq_New(String[][] setData)
    {
        try
        {
            int rtn1 = et_DeleteSendFaq_Faq(setData);

            if (rtn1 < 1)
            {
                throw new Exception("DELETE SNOTE ERROR");
            }

            int rtn2 = et_DeleteSendFaq_Faqd(setData);

            if (rtn2 < 1)
            {
                throw new Exception("DELETE SNOTE ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
            setMessage(msg.getMessage("0200"));
        }

        return getSepoaOut();
    }

    private int et_DeleteSendFaq_Faq(String[][] setData) throws Exception
    {
        int rtn = -1;
        StringBuffer sb = new StringBuffer();
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        sb.append(" UPDATE SFAQ SET DEL_FLAG = 'Y' ");
        sb.append(" WHERE SEQ = ? ");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
            String[] setType = { "S" };
            rtn = sm.doInsert(setData, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private int et_DeleteSendFaq_Faqd(String[][] setData) throws Exception
    {
        int rtn = -1;
        StringBuffer sb = new StringBuffer();
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        sb.append(" UPDATE SFAQD SET DEL_FLAG = 'Y' ");
        sb.append(" WHERE SEQ = ? ");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
            String[] setType = { "S" };
            rtn = sm.doInsert(setData, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    /**
     * 자료실 삭제
     * @param setData
     * @return
     */
    public SepoaOut DeleteSendDataStore_New(String[][] setData)
    {
    	try
    	{
    		int rtn1 = et_DeleteSendDataStore_Note(setData);
    		
    		if (rtn1 < 1)
    		{
    			throw new Exception("DELETE SDSHD ERROR");
    		}
    		
    		int rtn2 = et_DeleteSendDataStore_Notd(setData);
    		
    		if (rtn2 < 1)
    		{
    			throw new Exception("DELETE SDSDT ERROR");
    		}
    		
    		Commit();
    		setStatus(1);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
    		try
    		{
    			Rollback();
    		}
    		catch (Exception d)
    		{
    			Logger.err.println(info.getSession("ID"), this, d.getMessage());
    		}
    		
    		setStatus(0);
    		setMessage(msg.getMessage("0200"));
    	}
    	
    	return getSepoaOut();
    }
    
    private int et_DeleteSendDataStore_Note(String[][] setData) throws Exception
    {
    	int rtn = -1;
    	StringBuffer sb = new StringBuffer();
    	sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
    	sb.append(" UPDATE SDSHD SET DEL_FLAG = 'Y' ");
    	sb.append(" WHERE SEQ = ? ");
    	
    	try
    	{
    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
    		String[] setType = { "S" };
    		rtn = sm.doInsert(setData, setType);
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    private int et_DeleteSendDataStore_Notd(String[][] setData) throws Exception
    {
    	int rtn = -1;
    	StringBuffer sb = new StringBuffer();
    	sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
    	sb.append(" UPDATE SDSDT SET DEL_FLAG = 'Y' ");
    	sb.append(" WHERE SEQ = ? ");
    	
    	try
    	{
    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
    		String[] setType = { "S" };
    		rtn = sm.doInsert(setData, setType);
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    
    public SepoaOut DeleteSendNotice_New(String[][] setData)
    {
    	try
    	{
    		int rtn1 = et_DeleteSendNotice_Note(setData);
    		
    		if (rtn1 < 1)
    		{
    			throw new Exception("DELETE SNOTE ERROR");
    		}
    		
    		int rtn2 = et_DeleteSendNotice_Notd(setData);
    		
    		if (rtn2 < 1)
    		{
    			throw new Exception("DELETE SNOTE ERROR");
    		}
    		
    		Commit();
    		setStatus(1);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
    		try
    		{
    			Rollback();
    		}
    		catch (Exception d)
    		{
    			Logger.err.println(info.getSession("ID"), this, d.getMessage());
    		}
    		
    		setStatus(0);
    		setMessage(msg.getMessage("0200"));
    	}
    	
    	return getSepoaOut();
    }
    
    private int et_DeleteSendNotice_Note(String[][] setData) throws Exception
    {
    	int rtn = -1;
    	StringBuffer sb = new StringBuffer();
    	sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
    	sb.append(" UPDATE SNOTE SET DEL_FLAG = 'Y' ");
    	sb.append(" WHERE SEQ = ? ");
    	
    	try
    	{
    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
    		String[] setType = { "S" };
    		rtn = sm.doInsert(setData, setType);
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    private int et_DeleteSendNotice_Notd(String[][] setData) throws Exception
    {
    	int rtn = -1;
    	StringBuffer sb = new StringBuffer();
    	sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
    	sb.append(" UPDATE SNOTD SET DEL_FLAG = 'Y' ");
    	sb.append(" WHERE SEQ = ? ");
    	
    	try
    	{
    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
    		String[] setType = { "S" };
    		rtn = sm.doInsert(setData, setType);
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }

//  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PUP UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public SepoaOut getQuery_FAQ_POP_New(String obj) throws Exception
    {
        String cnt2;
        String[] args = { obj };
        
    	//카운트 업데이트
    	int rtnCnt = 0; 
    	String user_id = info.getSession("ID");
    	if(user_id.length()>0 && !"LOGIN".equals(user_id)){
    		rtnCnt = et_setNoticeViewCount("SFAQ", args);
    		Commit();
    	}

        String rtn = et_getQuery_FAQ_POP_New(args);
        setValue(rtn);

        SepoaFormater wf = new SepoaFormater(rtn);
        cnt2 = wf.getValue("ATTACH_NO", 0);

        if ((cnt2 == null) || cnt2.equals(""))
        {
            setValue("");
            setStatus(1);
            setMessage(msg.getMessage("0000"));

//            return getSepoaOut();
        }
        else
        {
	        try
	        {
	            String[] args2 = { cnt2 };
	            String rtn2 = et_getFile_name(args2);
	            setValue(rtn2);
	            setStatus(1);
	            setMessage(msg.getMessage("0000"));
	        }
	        catch (Exception e)
	        {
	            setStatus(0);
	            setMessage(msg.getMessage("0001"));
	            Logger.err.println(info.getSession("ID"), this, e.getMessage());
	        }
        }

        rtn = et_getQuery_FAQ_POP_New_contents(args);
        setValue(rtn);

        return getSepoaOut();
    }

    private String et_getQuery_FAQ_POP_New(String[] args) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        String language = info.getSession("LANGUAGE");
        try
        {
	        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	        String seq = args[0];
	        sm.removeAllValue();
	        sb.append(" SELECT  \t\n");
	        sb.append("\t  note.SUBJECT, note.DEPT_TYPE AS DEPT_TYPE_CODE  \t\n");
	        sb.append("\t, note.SEQ \n");
	        sb.append((new StringBuilder("\t, ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = note.COMPANY_CODE),'') AS COMPANY_NAME\t\n").toString());
	        sb.append("\t, getCodeText1('M216', note.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \n");
	        sb.append("\t, note.COMPANY_CODE \n");
	        sb.append("\t, note.ATTACH_NO \n");
	        sb.append("\t, note.NOTE_TYPE \n");
	        sb.append("\t, note.PUBLISH_FROM_DATE \n");
	        sb.append("\t, note.PUBLISH_TO_DATE \n");
	        
	        sb.append(" , NOTE.GONGJI_GUBUN \n");
	        sb.append(" , getCodeText1('M222', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN_DESC  \n");
	        sb.append(" , NOTE.VIEW_COUNT \n");
	        sb.append(" , NOTE.VIEW_USER_TYPE \n");

	        sb.append(" FROM SFAQ note \t\n");
	        sb.append(" WHERE 1 = 1 \n");
	        sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(seq);
	        sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
	        rtn = sm.doSelect(sb.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private String et_getQuery_FAQ_POP_New_contents(String[] args) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
        {
	        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	        String seq = args[0];
	        sm.removeAllValue();
	        sb.append(" SELECT CONTENT \t\n");
	        sb.append(" FROM sfaqd note \t\n");
	        sb.append(" WHERE 1 = 1 \n");
	        sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(seq);
	        sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
	        sb.append(" order by seq_seq \n ");
	        rtn = sm.doSelect(sb.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    /**
     * 자료실 조회
     * @param obj
     * @return
     * @throws Exception
     */
    public SepoaOut getQuery_dataStore_POP_New(String obj) throws Exception
    {
    	String cnt2;
    	String[] args = { obj };
    			
    	//카운트 업데이트
    	int rtnCnt = 0; 
    	String user_id = info.getSession("ID");
    	if(user_id.length()>0 && !"LOGIN".equals(user_id)){
    		rtnCnt = et_setDataStoreViewCount("SDSHD", args);
    		Commit();
    	}
    	String rtn = et_getQuery_DataStore_POP_New(args);
    	setValue(rtn);
    	
    	SepoaFormater wf = new SepoaFormater(rtn);
    	cnt2 = wf.getValue("ATTACH_NO", 0);
    	
    	if ((cnt2 == null) || cnt2.equals(""))
    	{
    		setValue("");
    		setStatus(1);
    		setMessage(msg.getMessage("0000"));
    		
//            return getSepoaOut();
    	}
    	else
    	{
    		try
    		{
    			String[] args2 = { cnt2 };
    			String rtn2 = et_getFile_name(args2);
    			setValue(rtn2);
    			setStatus(1);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch (Exception e)
    		{
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    			Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		}
    	}
    	
    	rtn = et_getQuery_DataStore_POP_New_contents(args);
    	setValue(rtn);
    	
    	return getSepoaOut();
    }
    
    private int et_setDataStoreViewCount(String bbs, String[] args) throws Exception {
		int rtn         = 0;
		ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb       = new StringBuffer();
    	
        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

	        String seq = args[0];
	        
	        sm.removeAllValue();
	        sb.delete(0,sb.length());
	        sb.append(" UPDATE                 		           \n");
	        sb.append(" "+bbs+"           			           \n");
	        sb.append(" SET                    		           \n");
	        sb.append("   VIEW_COUNT     	 = NVL(VIEW_COUNT,0)  + 1 \n"); 
	        sb.append(" WHERE SEQ = ?          		           \n"); sm.addNumberParameter(seq);
	        rtn = sm.doUpdate(sb.toString());


        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    	
	}
    
    private String et_getQuery_DataStore_POP_New(String[] args) throws Exception
    {
    	String rtn = null;
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	String language = info.getSession("LANGUAGE");
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		String seq = args[0];
    		sm.removeAllValue();
    		sb.append(" SELECT  \t\n");
    		sb.append("\t  DSHD.SUBJECT, DSHD.DEPT_TYPE AS DEPT_TYPE_CODE  \t\n");
    		sb.append("\t, DSHD.SEQ \n");
    		sb.append((new StringBuilder("\t, ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = DSHD.COMPANY_CODE),'') AS COMPANY_NAME\t\n").toString());
    		sb.append("\t, getCodeText1('M216', DSHD.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \n");
    		sb.append("\t, DSHD.COMPANY_CODE \n");
    		sb.append("\t, DSHD.ATTACH_NO \n");
    		sb.append("\t, DSHD.NOTE_TYPE \n");
    		sb.append("\t, DSHD.PUBLISH_FROM_DATE \n");
    		sb.append("\t, DSHD.PUBLISH_TO_DATE \n");
    		sb.append("\t, DSHD.VIEW_USER_TYPE \n");
    		
    		sb.append(" , DSHD.GONGJI_GUBUN \n");
    		sb.append(" , getCodeText1('M222', DSHD.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN_DESC  \n");
    		sb.append(" , DSHD.VIEW_COUNT \n");
    		
    		sb.append(" FROM SDSHD DSHD \t\n");
    		sb.append(" WHERE 1 = 1 \n");
    		sb.append(sm.addFixString(" AND DSHD.SEQ = ? \n")); sm.addStringParameter(seq);
    		sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
    		rtn = sm.doSelect(sb.toString());
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    private String et_getQuery_DataStore_POP_New_contents(String[] args) throws Exception
    {
    	String rtn = null;
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		String seq = args[0];
    		sm.removeAllValue();
    		sb.append(" SELECT CONTENT \t\n");
    		sb.append(" FROM SDSDT DSDT \t\n");
    		sb.append(" WHERE 1 = 1 \n");
    		sb.append(sm.addFixString(" AND DSDT.SEQ = ? \n")); sm.addStringParameter(seq);
    		sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
    		sb.append(" order by seq_seq \n ");
    		rtn = sm.doSelect(sb.toString());
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    
    public SepoaOut getQuery_NOTICE_POP_New(String obj) throws Exception
    {
    	String cnt2;
    	String[] args = { obj };
    			
    	//카운트 업데이트
    	int rtnCnt = 0; 
    	String user_id = info.getSession("ID");
    	if(user_id.length()>0 && !"LOGIN".equals(user_id)){
    		rtnCnt = et_setNoticeViewCount("SNOTE", args);
    		Commit();
    	}
    	String rtn = et_getQuery_NOTICE_POP_New(args);
    	setValue(rtn);
    	
    	SepoaFormater wf = new SepoaFormater(rtn);
    	cnt2 = wf.getValue("ATTACH_NO", 0);
    	
    	if ((cnt2 == null) || cnt2.equals(""))
    	{
    		setValue("");
    		setStatus(1);
    		setMessage(msg.getMessage("0000"));
    		
//            return getSepoaOut();
    	}
    	else
    	{
    		try
    		{
    			String[] args2 = { cnt2 };
    			String rtn2 = et_getFile_name(args2);
    			setValue(rtn2);
    			setStatus(1);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch (Exception e)
    		{
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    			Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		}
    	}
    	
    	rtn = et_getQuery_NOTICE_POP_New_contents(args);
    	setValue(rtn);
    	
    	return getSepoaOut();
    }
    
    private int et_setNoticeViewCount(String bbs, String[] args) throws Exception {
		int rtn         = 0;
		ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb       = new StringBuffer();
    	
        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

	        String seq = args[0];
	        
	        sm.removeAllValue();
	        sb.delete(0,sb.length());
	        sb.append(" UPDATE                 		           \n");
	        sb.append(" "+bbs+"           			           \n");
	        sb.append(" SET                    		           \n");
	        sb.append("   VIEW_COUNT     	 = NVL(VIEW_COUNT,0)  + 1 \n"); 
	        sb.append(" WHERE SEQ = ?          		           \n"); sm.addNumberParameter(seq);
	        rtn = sm.doUpdate(sb.toString());


        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    	
	}

	private String et_getQuery_NOTICE_POP_New(String[] args) throws Exception
    {
    	String rtn = null;
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	String language = info.getSession("LANGUAGE");
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		String seq = args[0];
    		sm.removeAllValue();
    		sb.append(" SELECT  \t\n");
    		sb.append("\t  note.SUBJECT, note.DEPT_TYPE AS DEPT_TYPE_CODE  \t\n");
    		sb.append("\t, note.SEQ \n");
    		sb.append((new StringBuilder("\t, ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = note.COMPANY_CODE),'') AS COMPANY_NAME\t\n").toString());
    		sb.append("\t, getCodeText1('M216', note.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \n");
    		sb.append("\t, note.COMPANY_CODE \n");
    		sb.append("\t, note.ATTACH_NO \n");
    		sb.append("\t, note.NOTE_TYPE \n");
    		sb.append("\t, note.PUBLISH_FROM_DATE \n");
    		sb.append("\t, note.PUBLISH_TO_DATE \n");
    		sb.append("\t, note.VIEW_USER_TYPE \n");
    		
    		sb.append(" , NOTE.GONGJI_GUBUN \n");
    		sb.append(" , getCodeText1('M222', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN_DESC  \n");
    		sb.append(" , NOTE.VIEW_COUNT \n");
    		
    		sb.append(" FROM SNOTE note \t\n");
    		sb.append(" WHERE 1 = 1 \n");
    		sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(seq);
    		sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
    		rtn = sm.doSelect(sb.toString());
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    private String et_getQuery_NOTICE_POP_New_contents(String[] args) throws Exception
    {
    	String rtn = null;
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		String seq = args[0];
    		sm.removeAllValue();
    		sb.append(" SELECT CONTENT \t\n");
    		sb.append(" FROM snotd note \t\n");
    		sb.append(" WHERE 1 = 1 \n");
    		sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(seq);
    		sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
    		sb.append(" order by seq_seq \n ");
    		rtn = sm.doSelect(sb.toString());
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }


//  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modify %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public SepoaOut modify_New_faq(String[][] args) throws Exception
    {
        try
        {
            int rtn1 = get_modify_Faqd(args);

            if (rtn1 < 1)
            {
                throw new Exception("UPDATE SNOTE ERROR");
            }

            int rtn2 = get_modify_Faq(args);

            if (rtn2 < 1)
            {
                throw new Exception("UPDATE SNOTE ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
        	
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
        }

        return getSepoaOut();
    }

    public int get_modify_Faqd(String[][] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			//String[][] args = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ}};
	        String content = args[0][2];
	        String seq = args[0][6];

	        sm.removeAllValue();
	        sb.append(" DELETE  SFAQD  WHERE SEQ = ?	\n"); sm.addStringParameter(seq);
	        sm.doDelete(sb.toString());

	        Vector v_cut_content = getSplitString(content, 1000);
	        for(int i = 1; i <= v_cut_content.size(); i++){

		        sm.removeAllValue();
		        sb.delete(0,sb.length());
		        sb.append(" INSERT INTO SFAQD    \t     \n");
		        sb.append(" (  			\t				\n");
		        sb.append("   SEQ  						\n");
		        sb.append(" , SEQ_SEQ  					\n");
		        sb.append(" , CONTENT  	\t				\n");
		        sb.append(" , DEL_FLAG  \t				\n");
		        sb.append(" ) VALUES ( 	\t				\n");
		        sb.append("   ?  						\n"); sm.addNumberParameter(seq);
		        sb.append(" , " + (new StringBuilder(String.valueOf(i))).append(" \t\n").toString());
		        sb.append(" , ?  		\t				\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i-1) );
		        sb.append(" , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'  		\t				\n");
		        sb.append(" )   		\t				\n");
		        rtn = sm.doInsert(sb.toString());
	        } //end for

	        Commit();
        }
        catch (Exception e)
        {
        	Rollback();
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public int get_modify_Faq(String[][] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

//String[][] obj = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ,DEPT_TYPE,GONGJI_GUBUN}};
	        String subject = args[0][0];
	        String company_code = args[0][1];
	        String attach_no = args[0][3];
	        String user_id = args[0][4];
	        String seq = args[0][6];
	        String dept_type = args[0][7];
	        String gongji_gubun = args[0][8];
	        String from_date = SepoaString.getDateUnSlashFormat(args[0][9]);
	        String to_date = SepoaString.getDateUnSlashFormat(args[0][10]);
	        String view_user_type = args[0][11];
	        //String publish_flag			= args[0][9];
	        //String publish_from_date	= args[0][10];
	        //String publish_to_date		= args[0][11];
	        
	        sm.removeAllValue();
	        sb.delete(0,sb.length());
	        sb.append(" UPDATE                 		\n");
	        sb.append(" \tSFAQ            			\n");
	        sb.append(" SET                    		\n");
//	        sb.append("    dept_type     	 = ?,   \n"); sm.addStringParameter(dept_type);
//	        sb.append("    gongji_gubun    	 = ?,   \n"); sm.addStringParameter(gongji_gubun);
	        sb.append("    SUBJECT     		 = ?,   \n"); sm.addStringParameter(subject);
	        sb.append("    COMPANY_CODE      = ?,   \n"); sm.addStringParameter(company_code);
	        sb.append("    ATTACH_NO   		 = ?,  	\n"); sm.addStringParameter(attach_no);
	        sb.append("    ADD_USER_ID 		 = ?,   \n"); sm.addStringParameter(user_id);
//	        sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(from_date);
//	        sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(to_date);
	        sb.append("    VIEW_USER_TYPE 	 = ?,   \n"); sm.addStringParameter(view_user_type);
	        //sb.append("    PUBLISH_FLAG 	 = ?,   \n"); sm.addStringParameter(publish_flag);
	        //sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_from_date));
	        //sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_to_date  ));
	        sb.append("    DEL_FLAG   	   \t= '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' 	\n");
	        sb.append(" WHERE SEQ = ?          		\n"); sm.addNumberParameter(seq);
	        rtn = sm.doUpdate(sb.toString());


        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    /**
     * 자료실 수정
     * @param args
     * @return
     * @throws Exception
     */
    public SepoaOut modify_DataStore_New(String[][] args) throws Exception
    {
    	try
    	{
    		int rtn1 = get_DataStore_Notd(args);
    		
    		if (rtn1 < 1)
    		{
    			throw new Exception("UPDATE SDSHD ERROR");
    		}
    		
    		int rtn2 = get_DataStore_Note(args);
    		
    		if (rtn2 < 1)
    		{
    			throw new Exception("UPDATE SDSDT ERROR");
    		}
    		
    		Commit();
    		setStatus(1);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
    		
    		try
    		{
    			Rollback();
    		}
    		catch (Exception d)
    		{
    			Logger.err.println(info.getSession("ID"), this, d.getMessage());
    		}
    		
    		setStatus(0);
    	}
    	
    	return getSepoaOut();
    }
    
    public int get_DataStore_Notd(String[][] args) throws Exception
    {
    	int rtn = 0;
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		//String[][] args = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ}};
    		String content = args[0][2];
    		String seq = args[0][6];
    		
    		sm.removeAllValue();
    		sb.append(" DELETE  SDSDT  WHERE SEQ = ?	\n"); sm.addStringParameter(seq);
    		sm.doDelete(sb.toString());
    		
    		Vector v_cut_content = getSplitString(content, 1000);
    		for(int i = 1; i <= v_cut_content.size(); i++){
    			
    			sm.removeAllValue();
    			sb.delete(0,sb.length());
    			sb.append(" INSERT INTO SDSDT    \t     \n");
    			sb.append(" (  			\t				\n");
    			sb.append("   SEQ  						\n");
    			sb.append(" , SEQ_SEQ  					\n");
    			sb.append(" , CONTENT  	\t				\n");
    			sb.append(" , DEL_FLAG  \t				\n");
    			sb.append(" ) VALUES ( 	\t				\n");
    			sb.append("   ?  						\n"); sm.addNumberParameter(seq);
    			sb.append(" , " + (new StringBuilder(String.valueOf(i))).append(" \t\n").toString());
    			sb.append(" , ?  		\t				\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i-1) );
    			sb.append(" , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'  		\t				\n");
    			sb.append(" )   		\t				\n");
    			rtn = sm.doInsert(sb.toString());
    		} //end for
    		
    		Commit();
    	}
    	catch (Exception e)
    	{
    		Rollback();
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    public int get_DataStore_Note(String[][] args) throws Exception
    {
    	int rtn = 0;
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
//String[][] obj = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ,DEPT_TYPE,GONGJI_GUBUN}};
    		String subject = args[0][0];
    		String company_code = args[0][1];
    		String attach_no = args[0][3];
    		String user_id = args[0][4];
    		String seq = args[0][6];
    		String dept_type = args[0][7];
    		String gongji_gubun = args[0][8];
    		String from_date = SepoaString.getDateUnSlashFormat(args[0][9]);
    		String to_date = SepoaString.getDateUnSlashFormat(args[0][10]);
    		String view_user_type = args[0][11];
    		//String publish_flag			= args[0][9];
    		//String publish_from_date	= args[0][10];
    		//String publish_to_date		= args[0][11];
    		
    		sm.removeAllValue();
    		sb.delete(0,sb.length());
    		sb.append(" UPDATE                 		\n");
    		sb.append(" \tSDSHD            			\n");
    		sb.append(" SET                    		\n");
//    		sb.append("    dept_type     	 = ?,   \n"); sm.addStringParameter(dept_type);
//    		sb.append("    gongji_gubun    	 = ?,   \n"); sm.addStringParameter(gongji_gubun);
    		sb.append("    SUBJECT     		 = ?,   \n"); sm.addStringParameter(subject);
    		sb.append("    COMPANY_CODE      = ?,   \n"); sm.addStringParameter(company_code);
    		sb.append("    ATTACH_NO   		 = ?,  	\n"); sm.addStringParameter(attach_no);
    		sb.append("    ADD_USER_ID 		 = ?,   \n"); sm.addStringParameter(user_id);
//    		sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(from_date);
//    		sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(to_date);
    		sb.append("    VIEW_USER_TYPE 	 = ?,   \n"); sm.addStringParameter(view_user_type);
    		//sb.append("    PUBLISH_FLAG 	 = ?,   \n"); sm.addStringParameter(publish_flag);
    		//sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_from_date));
    		//sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_to_date  ));
    		sb.append("    DEL_FLAG   	   \t= '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' 	\n");
    		sb.append(" WHERE SEQ = ?          		\n"); sm.addNumberParameter(seq);
    		rtn = sm.doUpdate(sb.toString());
    		
    		
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    
    public SepoaOut modify_New(String[][] args) throws Exception
    {
    	try
    	{
    		int rtn1 = get_modify_Notd(args);
    		
    		if (rtn1 < 1)
    		{
    			throw new Exception("UPDATE SDSHD ERROR");
    		}
    		
    		int rtn2 = get_modify_Note(args);
    		
    		if (rtn2 < 1)
    		{
    			throw new Exception("UPDATE SNOTE ERROR");
    		}
    		
    		Commit();
    		setStatus(1);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
    		
    		try
    		{
    			Rollback();
    		}
    		catch (Exception d)
    		{
    			Logger.err.println(info.getSession("ID"), this, d.getMessage());
    		}
    		
    		setStatus(0);
    	}
    	
    	return getSepoaOut();
    }
    
    public int get_modify_Notd(String[][] args) throws Exception
    {
    	int rtn = 0;
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		//String[][] args = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ}};
    		String content = args[0][2];
    		String seq = args[0][6];
    		
    		sm.removeAllValue();
    		sb.append(" DELETE  SNOTD  WHERE SEQ = ?	\n"); sm.addStringParameter(seq);
    		sm.doDelete(sb.toString());
    		
    		Vector v_cut_content = getSplitString(content, 1000);
    		for(int i = 1; i <= v_cut_content.size(); i++){
    			
    			sm.removeAllValue();
    			sb.delete(0,sb.length());
    			sb.append(" INSERT INTO SNOTD    \t     \n");
    			sb.append(" (  			\t				\n");
    			sb.append("   SEQ  						\n");
    			sb.append(" , SEQ_SEQ  					\n");
    			sb.append(" , CONTENT  	\t				\n");
    			sb.append(" , DEL_FLAG  \t				\n");
    			sb.append(" ) VALUES ( 	\t				\n");
    			sb.append("   ?  						\n"); sm.addNumberParameter(seq);
    			sb.append(" , " + (new StringBuilder(String.valueOf(i))).append(" \t\n").toString());
    			sb.append(" , ?  		\t				\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i-1) );
    			sb.append(" , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'  		\t				\n");
    			sb.append(" )   		\t				\n");
    			rtn = sm.doInsert(sb.toString());
    		} //end for
    		
    		Commit();
    	}
    	catch (Exception e)
    	{
    		Rollback();
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    public int get_modify_Note(String[][] args) throws Exception
    {
    	int rtn = 0;
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		
//String[][] obj = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ,DEPT_TYPE,GONGJI_GUBUN}};
    		String subject = args[0][0];
    		String company_code = args[0][1];
    		String attach_no = args[0][3];
    		String user_id = args[0][4];
    		String seq = args[0][6];
    		String dept_type = args[0][7];
    		String gongji_gubun = args[0][8];
    		String from_date = SepoaString.getDateUnSlashFormat(args[0][9]);
    		String to_date = SepoaString.getDateUnSlashFormat(args[0][10]);
    		String view_user_type = args[0][11];
    		//String publish_flag			= args[0][9];
    		//String publish_from_date	= args[0][10];
    		//String publish_to_date		= args[0][11];
    		
    		sm.removeAllValue();
    		sb.delete(0,sb.length());
    		sb.append(" UPDATE                 		\n");
    		sb.append(" \tSNOTE            			\n");
    		sb.append(" SET                    		\n");
//    		sb.append("    dept_type     	 = ?,   \n"); sm.addStringParameter(dept_type);
//    		sb.append("    gongji_gubun    	 = ?,   \n"); sm.addStringParameter(gongji_gubun);
    		sb.append("    SUBJECT     		 = ?,   \n"); sm.addStringParameter(subject);
    		sb.append("    COMPANY_CODE      = ?,   \n"); sm.addStringParameter(company_code);
    		sb.append("    ATTACH_NO   		 = ?,  	\n"); sm.addStringParameter(attach_no);
    		sb.append("    ADD_USER_ID 		 = ?,   \n"); sm.addStringParameter(user_id);
//    		sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(from_date);
//    		sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(to_date);
    		sb.append("    VIEW_USER_TYPE 	 = ?,   \n"); sm.addStringParameter(view_user_type);
    		//sb.append("    PUBLISH_FLAG 	 = ?,   \n"); sm.addStringParameter(publish_flag);
    		//sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_from_date));
    		//sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_to_date  ));
    		sb.append("    DEL_FLAG   	   \t= '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' 	\n");
    		sb.append(" WHERE SEQ = ?          		\n"); sm.addNumberParameter(seq);
    		rtn = sm.doUpdate(sb.toString());
    		
    		
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
//  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Insert %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public SepoaOut setInsertDataStore_New(String[][] args)
    {
        try
        {
            int rtn = et_setInsertDataStore_New(args);

            if (rtn < 1)
            {
                throw new Exception("INSERT SDSHD ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
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
        }

        return getSepoaOut();
    }
    
    private int et_setInsertDataStore_New(String[][] args) throws Exception
    {
        int rtn = -1;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			int cnt = 0;
			SepoaFormater sf = null;
			
	        String subject = args[0][0];
	        String company_code = args[0][1];
	        String dept_type = args[0][2];
	        String content = args[0][3];
	        String attach_no = args[0][4];
	        String user_id = args[0][5];
	        String current_date = args[0][6];
	        String current_time = args[0][7];
	        String del_flag = args[0][8];
	        String con_type = args[0][9];
	        String gongji_gubun = args[0][10];

	        String publish_flag = args[0][11];
	        String publish_from_date = args[0][12];
	        String publish_to_date = args[0][13];
	        String view_user_type = args[0][14];

	        sb.delete(0, sb.length()); 

	        sm.removeAllValue();
	        sb.append(" SELECT " + DB_NULL_FUNCTION + "(MAX(SEQ), 0) seq FROM SDSHD \n");
	        sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));

	        int max_seq = Integer.parseInt(sf.getValue("seq", 0));

 	        sm.removeAllValue();
	        sb.delete(0, sb.length());
	        sb.append(" INSERT INTO SDSHD    \t        \n");
	        sb.append(" (  \t\n");
	        sb.append(" 	SEQ  \n");
	        sb.append(" , SUBJECT  \t\n");
	        sb.append(" , COMPANY_CODE \n");
//	        sb.append(" , DEPT_TYPE \n");
	        sb.append(" , ATTACH_NO  \t\n");
	        sb.append(" , ADD_USER_ID  \n");
	        sb.append(" , ADD_DATE  \t\n");
	        sb.append(" , ADD_TIME  \t\n");
	        sb.append(" , DEL_FLAG  \t\n");
//	        sb.append(" , NOTE_TYPE  \t\n");
//	        sb.append(" , GONGJI_GUBUN  \t\n");
//	        sb.append(" , PUBLISH_FLAG  \t\n");
//	        sb.append(" , PUBLISH_FROM_DATE  \t\n");
//	        sb.append(" , PUBLISH_TO_DATE  \t\n");
	        sb.append(" , VIEW_USER_TYPE  \t\n");
	        sb.append(" ) VALUES (   \t\n");
	        sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \n").toString());
	        sb.append(" , ?  \t\n"); sm.addStringParameter(subject);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(company_code);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(dept_type);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(attach_no);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(user_id);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(current_date);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(current_time);
	        sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(con_type);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(gongji_gubun);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(publish_flag);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_from_date));
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_to_date));
	        sb.append(" , ?  \t\n"); sm.addStringParameter(view_user_type);
	        sb.append(" )   \t\n");
	        rtn = sm.doInsert(sb.toString());

	        Vector v_cut_content = getSplitString(content, 1000);
	        //세션 필터 체크에 의해서 content값이 없어질 수 있다.(태그 삭제 등)
	        //그럴 경우 content값이 없더라도 빈값을 insert 한다.(후에 수정,삭제 시 1row는 존재해야 하기 때문에)
	        if(v_cut_content.size() == 0){
	        	v_cut_content.add("");	
	        }
	        
	        for(int i = 0; i < v_cut_content.size(); i++){

		        sm.removeAllValue();
		        sb.delete(0,sb.length());
		        sb.append(" INSERT INTO SDSDT    \t        \n");
		        sb.append(" (  \t\n");
		        sb.append("   SEQ  \n");
		        sb.append(" , SEQ_SEQ  \n");
		        sb.append(" , CONTENT  \t\n");
		        sb.append(" , DEL_FLAG  \t\n");
		        sb.append(" ) VALUES (   \t\n");
		        sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \t\n").toString());
		        sb.append(" , " + (new StringBuilder(String.valueOf(i+1))).append(" \t\n").toString());
		        sb.append(" , ?  \t\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i) );
		        sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
		        sb.append(" )   \t\n");
		        sm.doInsert(sb.toString());

	        } //end for



//            SepoaSQLManager smt = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
//            String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S" };
//            rtn = smt.doInsert(args, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

//  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Insert %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public SepoaOut setInsertNotice_New(String[][] args)
    {
        try
        {
            int rtn = et_setInsertNotice_New(args);

            if (rtn < 1)
            {
                throw new Exception("INSERT SDSHD ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
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
        }

        return getSepoaOut();
    }

    private int et_setInsertNotice_New(String[][] args) throws Exception
    {
        int rtn = -1;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			int cnt = 0;
			SepoaFormater sf = null;
			
	        String subject = args[0][0];
	        String company_code = args[0][1];
	        String dept_type = args[0][2];
	        String content = args[0][3];
	        String attach_no = args[0][4];
	        String user_id = args[0][5];
	        String current_date = args[0][6];
	        String current_time = args[0][7];
	        String del_flag = args[0][8];
	        String con_type = args[0][9];
	        String gongji_gubun = args[0][10];

	        String publish_flag = args[0][11];
	        String publish_from_date = args[0][12];
	        String publish_to_date = args[0][13];
	        String view_user_type = args[0][14];

	        sb.delete(0, sb.length()); 

	        sm.removeAllValue();
	        sb.append(" SELECT " + DB_NULL_FUNCTION + "(MAX(SEQ), 0) seq FROM SNOTE \n");
	        sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));

	        int max_seq = Integer.parseInt(sf.getValue("seq", 0));

 	        sm.removeAllValue();
	        sb.delete(0, sb.length());
	        sb.append(" INSERT INTO SNOTE    \t        \n");
	        sb.append(" (  \t\n");
	        sb.append(" 	SEQ  \n");
	        sb.append(" , SUBJECT  \t\n");
	        sb.append(" , COMPANY_CODE \n");
//	        sb.append(" , DEPT_TYPE \n");
	        sb.append(" , ATTACH_NO  \t\n");
	        sb.append(" , ADD_USER_ID  \n");
	        sb.append(" , ADD_DATE  \t\n");
	        sb.append(" , ADD_TIME  \t\n");
	        sb.append(" , DEL_FLAG  \t\n");
//	        sb.append(" , NOTE_TYPE  \t\n");
//	        sb.append(" , GONGJI_GUBUN  \t\n");
//	        sb.append(" , PUBLISH_FLAG  \t\n");
//	        sb.append(" , PUBLISH_FROM_DATE  \t\n");
//	        sb.append(" , PUBLISH_TO_DATE  \t\n");
	        sb.append(" , VIEW_USER_TYPE  \t\n");
	        sb.append(" ) VALUES (   \t\n");
	        sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \n").toString());
	        sb.append(" , ?  \t\n"); sm.addStringParameter(subject);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(company_code);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(dept_type);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(attach_no);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(user_id);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(current_date);
	        sb.append(" , ?  \t\n"); sm.addStringParameter(current_time);
	        sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(con_type);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(gongji_gubun);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(publish_flag);
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_from_date));
//	        sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_to_date));
	        sb.append(" , ?  \t\n"); sm.addStringParameter(view_user_type);
	        sb.append(" )   \t\n");
	        rtn = sm.doInsert(sb.toString());

	        Vector v_cut_content = getSplitString(content, 1000);
	        //세션 필터 체크에 의해서 content값이 없어질 수 있다.(태그 삭제 등)
	        //그럴 경우 content값이 없더라도 빈값을 insert 한다.(후에 수정,삭제 시 1row는 존재해야 하기 때문에)
	        if(v_cut_content.size() == 0){
	        	v_cut_content.add("");	
	        }
	        
	        for(int i = 0; i < v_cut_content.size(); i++){

		        sm.removeAllValue();
		        sb.delete(0,sb.length());
		        sb.append(" INSERT INTO SNOTD    \t        \n");
		        sb.append(" (  \t\n");
		        sb.append("   SEQ  \n");
		        sb.append(" , SEQ_SEQ  \n");
		        sb.append(" , CONTENT  \t\n");
		        sb.append(" , DEL_FLAG  \t\n");
		        sb.append(" ) VALUES (   \t\n");
		        sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \t\n").toString());
		        sb.append(" , " + (new StringBuilder(String.valueOf(i+1))).append(" \t\n").toString());
		        sb.append(" , ?  \t\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i) );
		        sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
		        sb.append(" )   \t\n");
		        sm.doInsert(sb.toString());

	        } //end for



//            SepoaSQLManager smt = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
//            String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S" };
//            rtn = smt.doInsert(args, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    public SepoaOut setInsertFaq_New(String[][] args)
    {
    	try
    	{
    		int rtn = et_setInsertFaq_New(args);
    		
    		if (rtn < 1)
    		{
    			throw new Exception("INSERT SNOTE ERROR");
    		}
    		
    		Commit();
    		setStatus(1);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
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
    	}
    	
    	return getSepoaOut();
    }
    
    private int et_setInsertFaq_New(String[][] args) throws Exception
    {
    	int rtn = -1;
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		int cnt = 0;
    		SepoaFormater sf = null;
    		
    		String subject = args[0][0];
    		String company_code = args[0][1];
    		String dept_type = args[0][2];
    		String content = args[0][3];
    		String attach_no = args[0][4];
    		String user_id = args[0][5];
    		String current_date = args[0][6];
    		String current_time = args[0][7];
    		String del_flag = args[0][8];
    		String con_type = args[0][9];
    		String gongji_gubun = args[0][10];
    		
    		String publish_flag = args[0][11];
    		String publish_from_date = args[0][12];
    		String publish_to_date = args[0][13];
    		String view_user_type = args[0][14];
    		
    		sb.delete(0, sb.length()); 
    		
    		sm.removeAllValue();
    		sb.append(" SELECT " + DB_NULL_FUNCTION + "(MAX(SEQ), 0) seq FROM SFAQ \n");
    		sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
    		
    		int max_seq = Integer.parseInt(sf.getValue("seq", 0));
    		
    		sm.removeAllValue();
    		sb.delete(0, sb.length());
    		sb.append(" INSERT INTO SFAQ    \t        \n");
    		sb.append(" (  \t\n");
    		sb.append(" 	SEQ  \n");
    		sb.append(" , SUBJECT  \t\n");
    		sb.append(" , COMPANY_CODE \n");
    		sb.append(" , DEPT_TYPE \n");
    		sb.append(" , ATTACH_NO  \t\n");
    		sb.append(" , ADD_USER_ID  \n");
    		sb.append(" , ADD_DATE  \t\n");
    		sb.append(" , ADD_TIME  \t\n");
    		sb.append(" , DEL_FLAG  \t\n");
    		sb.append(" , NOTE_TYPE  \t\n");
    		sb.append(" , GONGJI_GUBUN  \t\n");
    		sb.append(" , PUBLISH_FLAG  \t\n");
    		sb.append(" , PUBLISH_FROM_DATE  \t\n");
    		sb.append(" , PUBLISH_TO_DATE  \t\n");
    		sb.append(" , VIEW_USER_TYPE  \t\n");
    		sb.append(" ) VALUES (   \t\n");
    		sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \n").toString());
    		sb.append(" , ?  \t\n"); sm.addStringParameter(subject);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(company_code);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(dept_type);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(attach_no);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(user_id);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(current_date);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(current_time);
    		sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(con_type);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(gongji_gubun);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(publish_flag);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_from_date));
    		sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_to_date));
    		sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(view_user_type));
    		sb.append(" )   \t\n");
    		rtn = sm.doInsert(sb.toString());
    		
    		Vector v_cut_content = getSplitString(content, 1000);
    		//세션 필터 체크에 의해서 content값이 없어질 수 있다.(태그 삭제 등)
    		//그럴 경우 content값이 없더라도 빈값을 insert 한다.(후에 수정,삭제 시 1row는 존재해야 하기 때문에)
    		if(v_cut_content.size() == 0){
    			v_cut_content.add("");	
    		}
    		
    		for(int i = 0; i < v_cut_content.size(); i++){
    			
    			sm.removeAllValue();
    			sb.delete(0,sb.length());
    			sb.append(" INSERT INTO SFAQD    \t        \n");
    			sb.append(" (  \t\n");
    			sb.append("   SEQ  \n");
    			sb.append(" , SEQ_SEQ  \n");
    			sb.append(" , CONTENT  \t\n");
    			sb.append(" , DEL_FLAG  \t\n");
    			sb.append(" ) VALUES (   \t\n");
    			sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \t\n").toString());
    			sb.append(" , " + (new StringBuilder(String.valueOf(i+1))).append(" \t\n").toString());
    			sb.append(" , ?  \t\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i) );
    			sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
    			sb.append(" )   \t\n");
    			sm.doInsert(sb.toString());
    			
    		} //end for
    		
    		
    		
//            SepoaSQLManager smt = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
//            String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S" };
//            rtn = smt.doInsert(args, setType);
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    
    public SepoaOut view_DataStore_Count(String[] args) throws Exception
    {
        try
        {
            int rtn1 = get_view_DataStore_Count(args);

            if (rtn1 < 1)
            {
                throw new Exception("UPDATE SNOTE ERROR");
            }


	        int rtn2 = get_Insert_DataStore_Notv(args);

	        if (rtn2 < 1)
	        {
	        	throw new Exception("UPDATE SNOTV ERROR");
	        }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
        }

        return getSepoaOut();
    }
    
    public int get_view_DataStore_Count(String[] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

	        String seq = args[0];

	        sm.removeAllValue();
	        sb.append(" UPDATE SDSHD SET VIEW_COUNT = VIEW_COUNT+1 WHERE SEQ = ?	\n"); sm.addStringParameter(seq);
	        rtn = sm.doUpdate(sb.toString());

        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    public int get_Insert_DataStore_Notv(String[] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

	        String seq = args[0];
	        String company_code = info.getSession("COMPANY_CODE");

		    sm.removeAllValue();
		    sb.delete(0,sb.length());
		    sb.append(" INSERT INTO SDSTV	\n");
		    sb.append(" (  \t\n");
		    sb.append("   SEQ  \n");
		    sb.append(" , SEQ_SEQ  \n");
		    sb.append(" , READ_USER_ID  \t\n");
		    sb.append(" , READ_DATE  \t\n");
		    sb.append(" , READ_TIME  \t\n");
		    sb.append(" , USER_TYPE  \t\n");
		    sb.append(" , COMPANY_CODE  \t\n");
		    sb.append(" , VIEW_IP_ADDRESS  \t\n");
		    sb.append(" ) VALUES (   \t\n");
		    sb.append("   ?   \n");sm.addNumberParameter(seq);
		    sb.append(" , (SELECT CASE WHEN COUNT(SEQ_SEQ) = 0 THEN 1 ELSE MAX(SEQ_SEQ)+1 END \n");
		    sb.append("    FROM SDSTV WHERE SEQ = ?) \n"); sm.addNumberParameter(seq);
		    if(company_code.length() > 0){
			    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("ID"));
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') FROM DUAL) \n");
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'HH24MISS') FROM DUAL) \n");
			    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("USER_TYPE").equals("S") ? "S":"B");
		    }else{
		    	sb.append(" , ? \n"); sm.addStringParameter("Portal");
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') FROM DUAL) \n");
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'HH24MISS') FROM DUAL) \n");
			    sb.append(" , ? \n"); sm.addStringParameter("P");
		    }
		    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("COMPANY_CODE"));
		    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("USER_IP"));
		    sb.append(" )   \t\n");
		    rtn = sm.doInsert(sb.toString());

        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    

    public SepoaOut view_Count(String[] args) throws Exception
    {
        try
        {
            int rtn1 = get_view_Count(args);

            if (rtn1 < 1)
            {
                throw new Exception("UPDATE SNOTE ERROR");
            }


	        int rtn2 = get_Insert_Notv(args);

	        if (rtn2 < 1)
	        {
	        	throw new Exception("UPDATE SNOTV ERROR");
	        }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
        }

        return getSepoaOut();
    }

    public int get_view_Count(String[] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

	        String seq = args[0];

	        sm.removeAllValue();
	        sb.append(" UPDATE SNOTE SET VIEW_COUNT = VIEW_COUNT+1 WHERE SEQ = ?	\n"); sm.addStringParameter(seq);
	        rtn = sm.doUpdate(sb.toString());

        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public int get_Insert_Notv(String[] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

	        String seq = args[0];
	        String company_code = info.getSession("COMPANY_CODE");

		    sm.removeAllValue();
		    sb.delete(0,sb.length());
		    sb.append(" INSERT INTO SNOTV	\n");
		    sb.append(" (  \t\n");
		    sb.append("   SEQ  \n");
		    sb.append(" , SEQ_SEQ  \n");
		    sb.append(" , READ_USER_ID  \t\n");
		    sb.append(" , READ_DATE  \t\n");
		    sb.append(" , READ_TIME  \t\n");
		    sb.append(" , USER_TYPE  \t\n");
		    sb.append(" , COMPANY_CODE  \t\n");
		    sb.append(" , VIEW_IP_ADDRESS  \t\n");
		    sb.append(" ) VALUES (   \t\n");
		    sb.append("   ?   \n");sm.addNumberParameter(seq);
		    sb.append(" , (SELECT CASE WHEN COUNT(SEQ_SEQ) = 0 THEN 1 ELSE MAX(SEQ_SEQ)+1 END \n");
		    sb.append("    FROM SNOTV WHERE SEQ = ?) \n"); sm.addNumberParameter(seq);
		    if(company_code.length() > 0){
			    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("ID"));
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') FROM DUAL) \n");
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'HH24MISS') FROM DUAL) \n");
			    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("USER_TYPE").equals("S") ? "S":"B");
		    }else{
		    	sb.append(" , ? \n"); sm.addStringParameter("Portal");
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') FROM DUAL) \n");
			    sb.append(" , (SELECT TO_CHAR(SYSDATE, 'HH24MISS') FROM DUAL) \n");
			    sb.append(" , ? \n"); sm.addStringParameter("P");
		    }
		    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("COMPANY_CODE"));
		    sb.append(" , ? \n"); sm.addStringParameter(info.getSession("USER_IP"));
		    sb.append(" )   \t\n");
		    rtn = sm.doInsert(sb.toString());

        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    /**
     * 자료실 조회수 카운트
     * @param _info
     * @param seq
     * @param user_name
     * @param company_name
     * @param user_gubun
     * @param user_ip
     * @param language
     * @return
     */
    public SepoaOut getDataStoreViewCountList(SepoaInfo _info, String seq, String user_name, String company_name, String user_gubun, String user_ip, String language)
    {
        try
        {
        	String[] rtn = null;
			setStatus(1);
			setFlag(true);

            rtn = et_getDataStoreViewCountList(_info, seq, user_name, company_name, user_gubun, user_ip, language);

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
    
    private String[] et_getDataStoreViewCountList(SepoaInfo _info, String seq, String user_name, String company_name, String user_gubun, String user_ip, String language) throws Exception
    {
    	String[] rtn = new String[2];
        ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" SELECT  \n ");
			sb.append("   SEQ_SEQ \n ");
			sb.append(" , " + DB_NULL_FUNCTION + "(" + SEPOA_DB_OWNER + "getUserName(READ_USER_ID,'" + language + "'), READ_USER_ID) USER_NAME \n ");
			sb.append(" , " + SEPOA_DB_OWNER + "getCompanyNameLoc(COMPANY_CODE, USER_TYPE) COMPANY_NAME \n ");
			sb.append(" , " + SEPOA_DB_OWNER + "getCodeText1('M726',USER_TYPE, '" + language + "') user_gubun \n ");
			sb.append(" , " + SEPOA_DB_OWNER + "getDateFormat(READ_DATE) " + DBUtil.getAndSeparator()+ " ' ' " + DBUtil.getAndSeparator()+ " " + SEPOA_DB_OWNER + "getTimeFormat(READ_TIME) view_date \n ");
			sb.append(" , VIEW_IP_ADDRESS USER_IP \n ");
			sb.append(" from SDSTV \n ");
			sb.append(sm.addSelectString(" where seq = ? \n "));sm.addStringParameter(seq);

			sb.append(sm.addSelectString(" and upper(" + SEPOA_DB_OWNER + "getUserName(READ_USER_ID,'" + language + "')) like upper('%'" + DBUtil.getAndSeparator()+ "  ?  " + DBUtil.getAndSeparator()+ " '%')  \n "));
			sm.addStringParameter(user_name);

			sb.append(sm.addSelectString(" and upper(" + SEPOA_DB_OWNER + "getCompanyNameLoc(COMPANY_CODE, USER_TYPE)) like upper('%'" + DBUtil.getAndSeparator()+ "  ?  " + DBUtil.getAndSeparator()+ " '%') \n "));
			sm.addStringParameter(company_name);

			sb.append(sm.addSelectString(" and upper(USER_TYPE) = upper(?) \n "));
			sm.addStringParameter(user_gubun);

			sb.append(sm.addSelectString(" and VIEW_IP_ADDRESS like '%'" + DBUtil.getAndSeparator()+ "  ?  " + DBUtil.getAndSeparator()+ " '%' \n "));
			sm.addStringParameter(user_ip);

			sb.append(" order by seq_seq desc \n ");
			Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

			rtn[0] = sm.doSelect(sb.toString());
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M726" );
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

        return rtn;
    }
    

    public SepoaOut getViewCountList(SepoaInfo _info, String seq, String user_name, String company_name, String user_gubun, String user_ip, String language)
    {
        try
        {
        	String[] rtn = null;
			setStatus(1);
			setFlag(true);

            rtn = et_getViewCountList(_info, seq, user_name, company_name, user_gubun, user_ip, language);

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

    private String[] et_getViewCountList(SepoaInfo _info, String seq, String user_name, String company_name, String user_gubun, String user_ip, String language) throws Exception
    {
    	String[] rtn = new String[2];
        ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sb.append(" SELECT  \n ");
			sb.append("   SEQ_SEQ \n ");
			sb.append(" , " + DB_NULL_FUNCTION + "(" + SEPOA_DB_OWNER + "getUserName(READ_USER_ID,'" + language + "'), READ_USER_ID) USER_NAME \n ");
			sb.append(" , " + SEPOA_DB_OWNER + "getCompanyNameLoc(COMPANY_CODE, USER_TYPE) COMPANY_NAME \n ");
			sb.append(" , " + SEPOA_DB_OWNER + "getCodeText1('M726',USER_TYPE, '" + language + "') user_gubun \n ");
			sb.append(" , " + SEPOA_DB_OWNER + "getDateFormat(READ_DATE) " + DBUtil.getAndSeparator()+ " ' ' " + DBUtil.getAndSeparator()+ " " + SEPOA_DB_OWNER + "getTimeFormat(READ_TIME) view_date \n ");
			sb.append(" , VIEW_IP_ADDRESS USER_IP \n ");
			sb.append(" from SNOTV \n ");
			sb.append(sm.addSelectString(" where seq = ? \n "));sm.addStringParameter(seq);

			sb.append(sm.addSelectString(" and upper(" + SEPOA_DB_OWNER + "getUserName(READ_USER_ID,'" + language + "')) like upper('%'" + DBUtil.getAndSeparator()+ "  ?  " + DBUtil.getAndSeparator()+ " '%')  \n "));
			sm.addStringParameter(user_name);

			sb.append(sm.addSelectString(" and upper(" + SEPOA_DB_OWNER + "getCompanyNameLoc(COMPANY_CODE, USER_TYPE)) like upper('%'" + DBUtil.getAndSeparator()+ "  ?  " + DBUtil.getAndSeparator()+ " '%') \n "));
			sm.addStringParameter(company_name);

			sb.append(sm.addSelectString(" and upper(USER_TYPE) = upper(?) \n "));
			sm.addStringParameter(user_gubun);

			sb.append(sm.addSelectString(" and VIEW_IP_ADDRESS like '%'" + DBUtil.getAndSeparator()+ "  ?  " + DBUtil.getAndSeparator()+ " '%' \n "));
			sm.addStringParameter(user_ip);

			sb.append(" order by seq_seq desc \n ");
			Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

			rtn[0] = sm.doSelect(sb.toString());
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M726" );
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

        return rtn;
    }

    private Vector getSplitString(String t1, int length)
    {
        Vector rt = new Vector();
        String ui = t1;

        int le = getLengthb(ui); //ui가 몇byte인지를 알아냄

        while (le > 0) //0byte보다 크다면
        {
            rt.addElement(getSubString(ui, 0, length)); //
            ui = getSubString(ui, length, le);
            le = getLengthb(ui);
        }

        return rt;
    }

    public int getLengthb(String str)
    {
        int rSize = 0;
        int len = 0;
        int ll = 0;

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }
        }

        return len;
    }

    private String getSubString(String str, int start, int end)
    {
        int rSize = 0;
        int len = 0;

        int ll = 0;
        StringBuffer ss = new StringBuffer();

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }

            if ((len > start) && (len <= end))
            {
                ss.append(str.charAt(rSize));
            }
        }

        return ss.toString();
    }
    public SepoaOut getNotice(String gubun, String guest, String company_code,String dept_type,String type)
    {
        try
        {
            String rtn = doNotice(gubun, guest, company_code, dept_type, type);
            setStatus(1);
            setValue(rtn);
            //성공적으로 수행 되었습니다.
            setMessage(msg.getMessage("0100").toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            //정상적으로 처리되지 않았습니다.
            setMessage(msg.getMessage("0200").toString());
        }

        return getSepoaOut();
    }
    
    private String doNotice(String gubun, String guest, String company_code,String dept_type,String type) throws Exception
    {
    	//gubun
		//S 제목
		//U 글쓴이
		//D 작성일
		//C 내용
    	
    	if("D".equals(gubun)){
    		guest = guest.replaceAll("-", "");
    	}
    	
        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        String language = info.getSession("LANGUAGE");
        String user_type = info.getSession("USER_TYPE");

        StringBuffer tSQL = new StringBuffer();
        tSQL.append(" SELECT NOTE.SUBJECT  \n");
        tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = NOTE.COMPANY_CODE),'') AS COMPANY_NAME  \t\n").toString());
        tSQL.append(" , " + SEPOA_DB_OWNER + "getCodeText1('M216', NOTE.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \t\n");
        tSQL.append(" , NOTE.ADD_DATE  \t\n");
        tSQL.append(" , NOTE.ATTACH_NO  \t\n");

        tSQL.append(" , (SELECT count(*) FROM SFILE X WHERE X.DOC_NO = NOTE.ATTACH_NO) AS ATTACH_NAME   \t\n");

        tSQL.append(" , NOTE.CONTENT   \t\n");
        tSQL.append(" , NOTE.SEQ   \n");
        tSQL.append(" , NOTE.NOTE_TYPE \n");

        tSQL.append(" , NOTE.GONGJI_GUBUN AS GONGJI_GUBUN_CODE \n");
        tSQL.append(" , " + SEPOA_DB_OWNER + "getCodeText1('M222', NOTE.GONGJI_GUBUN, 'KO')  AS GONGJI_GUBUN  \n");
        tSQL.append(" , NOTE.VIEW_COUNT \n");
        tSQL.append(" , NOTE.ADD_USER_ID \n");
        tSQL.append(" , USMT.USER_NAME_LOC AS ADD_USER_NAME \n");
        tSQL.append(" , NOTE.PUBLISH_FLAG \n");
        tSQL.append(" , NOTE.PUBLISH_FROM_DATE \n");
        tSQL.append(" , NOTE.PUBLISH_TO_DATE \n");

        tSQL.append(" FROM SNOTE NOTE, ICOMLUSR USMT \n");
        tSQL.append(" WHERE \n");
        tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(NOTE.DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') != '" + sepoa.fw.util.CommonUtil.Flag.Yes.getValue() + "' \t\n").toString());
        tSQL.append("   AND NOTE.ADD_USER_ID = USMT.USER_ID \n ");
        if(type.indexOf(",",1)>0){
        	type = type.replaceAll(",", "','");
        	tSQL.append("    AND NOTE.GONGJI_GUBUN IN ('"+type+"')	\n");
        }else{
        	tSQL.append(sm.addSelectString("    AND NOTE.GONGJI_GUBUN = ?	\n"));sm.addStringParameter(type);
        }
        
        
        String like_sql = "%" + guest + "%";

        if (!company_code.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.COMPANY_CODE = '")).append(company_code).append("'\t\n ").toString());
        }
        if (!dept_type.equals(""))
        {
            tSQL.append((new StringBuilder("   AND NOTE.DEPT_TYPE = '")).append(dept_type).append("'\t\n ").toString());
        }

        if ((gubun.length() > 0) && (guest.length() > 0))
        {
            if (gubun.equals("S"))
            {
                tSQL.append("   AND upper(NOTE.SUBJECT) LIKE  '"+like_sql+"' \n ");
            }

            if (gubun.equals("U"))
            {
                tSQL.append("   AND upper(USMT.USER_NAME_LOC)  LIKE  '" + like_sql + "' \n ");
            }

            if (gubun.equals("D"))
            {
                tSQL.append(sm.addSelectString("   AND NOTE.ADD_DATE = ? \t\n "));
                sm.addStringParameter(guest);
            }

            if (gubun.equals("C"))
            {
                tSQL.append(" and exists (select 'x' from snotd notd where notd.seq = note.seq and \n ");
                tSQL.append("             upper(notd.content) like '" + like_sql + "') \n ");
            }
        }

        if( "ORACLE".equals( SEPOA_DB_VENDOR ) ) {
            tSQL.append("	AND NOTE.ADD_DATE between TO_CHAR(SYSDATE - 180, 'YYYYMMDD') and TO_CHAR(SYSDATE, 'YYYYMMDD') \n ");
        } else if( "MSSQL".equals( SEPOA_DB_VENDOR ) ) {
            tSQL.append("   AND NOTE.ADD_DATE BETWEEN CONVERT( VARCHAR, DATEADD( MM, -3, GETDATE() ), 112 ) AND CONVERT( VARCHAR, GETDATE(), 112 ) \n ");
        } else if( "SYBASE".equals( SEPOA_DB_VENDOR ) ) {
            tSQL.append("   AND NOTE.ADD_DATE BETWEEN CONVERT( VARCHAR, DATEADD( MM, -3, GETDATE() ), 112 ) AND CONVERT( VARCHAR, GETDATE(), 112 ) \n ");
        }

        tSQL.append(" ORDER BY \t\n");
        tSQL.append(" SEQ DESC\n");

        try
        {
            rtn = sm.doSelect(tSQL.toString());
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M216", "M238" );
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    
    }
    
    
    
    
    
    
    public SepoaOut setInsertRpt_New(String[][] args)
    {
    	try
    	{
    		int rtn = et_setInsertRpt_New(args);
    		
    		if (rtn < 1)
    		{
    			throw new Exception("INSERT SNOTE ERROR");
    		}
    		
    		Commit();
    		setStatus(1);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
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
    	}
    	
    	return getSepoaOut();
    }
    
    private int et_setInsertRpt_New(String[][] args) throws Exception
    {
    	int rtn = -1;
    	
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sb = new StringBuffer();
    	
    	try
    	{
    		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    		int cnt = 0;
    		SepoaFormater sf = null;
    		
    		String subject = args[0][0];
    		String company_code = args[0][1];
    		String dept_type = args[0][2];
    		String content = args[0][3];
    		String attach_no = args[0][4];
    		String user_id = args[0][5];
    		String current_date = args[0][6];
    		String current_time = args[0][7];
    		String del_flag = args[0][8];
    		String con_type = args[0][9];
    		String gongji_gubun = args[0][10];
    		
    		String publish_flag = args[0][11];
    		String publish_from_date = args[0][12];
    		String publish_to_date = args[0][13];
    		String view_user_type = args[0][14];
    		
    		String department_name_loc =  args[0][15];
    		
    		sb.delete(0, sb.length()); 
    		
    		sm.removeAllValue();
    		sb.append(" SELECT " + DB_NULL_FUNCTION + "(MAX(SEQ), 0) seq FROM SRPT \n");
    		sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
    		
    		int max_seq = Integer.parseInt(sf.getValue("seq", 0));
    		
    		sm.removeAllValue();
    		sb.delete(0, sb.length());
    		sb.append(" INSERT INTO SRPT    \t        \n");
    		sb.append(" (  \t\n");
    		sb.append(" 	SEQ  \n");
    		sb.append(" , SUBJECT  \t\n");
    		sb.append(" , COMPANY_CODE \n");
    		sb.append(" , DEPT_TYPE \n");
    		sb.append(" , ATTACH_NO  \t\n");
    		sb.append(" , ADD_USER_ID  \n");
    		sb.append(" , ADD_DATE  \t\n");
    		sb.append(" , ADD_TIME  \t\n");
    		sb.append(" , DEL_FLAG  \t\n");
    		sb.append(" , NOTE_TYPE  \t\n");
    		sb.append(" , GONGJI_GUBUN  \t\n");
    		sb.append(" , PUBLISH_FLAG  \t\n");
    		sb.append(" , PUBLISH_FROM_DATE  \t\n");
    		sb.append(" , PUBLISH_TO_DATE  \t\n");
    		sb.append(" , VIEW_USER_TYPE  \t\n");
    		sb.append(" ) VALUES (   \t\n");
    		sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \n").toString());
    		sb.append(" , ?  \t\n"); sm.addStringParameter(subject);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(company_code);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(dept_type);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(attach_no);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(user_id);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(current_date);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(current_time);
    		sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(con_type);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(gongji_gubun);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(publish_flag);
    		sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_from_date));
    		sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(publish_to_date));
    		sb.append(" , ?  \t\n"); sm.addStringParameter(SepoaString.getDateUnSlashFormat(view_user_type));
    		sb.append(" )   \t\n");
    		rtn = sm.doInsert(sb.toString());
    		
    		Vector v_cut_content = getSplitString(content, 1000);
    		//세션 필터 체크에 의해서 content값이 없어질 수 있다.(태그 삭제 등)
    		//그럴 경우 content값이 없더라도 빈값을 insert 한다.(후에 수정,삭제 시 1row는 존재해야 하기 때문에)
    		if(v_cut_content.size() == 0){
    			v_cut_content.add("");	
    		}
    		
    		for(int i = 0; i < v_cut_content.size(); i++){
    			
    			sm.removeAllValue();
    			sb.delete(0,sb.length());
    			sb.append(" INSERT INTO SRPTD    \t        \n");
    			sb.append(" (  \t\n");
    			sb.append("   SEQ  \n");
    			sb.append(" , SEQ_SEQ  \n");
    			sb.append(" , CONTENT  \t\n");
    			sb.append(" , DEL_FLAG  \t\n");
    			sb.append(" ) VALUES (   \t\n");
    			sb.append((new StringBuilder(String.valueOf(max_seq+1))).append(" \t\n").toString());
    			sb.append(" , " + (new StringBuilder(String.valueOf(i+1))).append(" \t\n").toString());
    			sb.append(" , ?  \t\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i) );
    			sb.append(" , " + DB_NULL_FUNCTION + "( ? , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "')  \t\n"); sm.addStringParameter(del_flag);
    			sb.append(" )   \t\n");
    			sm.doInsert(sb.toString());
    			
    		} //end for
    		
			if ( rtn >= 1 && "1".equals(gongji_gubun) )
    		{
				Map<String, String> smsParam = new HashMap<String, String>();
				
	  	    	smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
	  	    	smsParam.put("DEPARTMENT_NAME_LOC", department_name_loc);
	  	    	
				new SMS("NONDBJOB", info).rptProcess(ctx, smsParam);
    		}
    		
//            SepoaSQLManager smt = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());
//            String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S" };
//            rtn = smt.doInsert(args, setType);
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    public SepoaOut getSupRpt(Map< String, Object > allData)
    {
    	try
    	{
    		Map<String,String> headerData=new HashMap();
    		headerData = MapUtils.getMap( allData, "headerData" );
    		//String rtn = DogetSupNotice(gubun, guest, company_code,dept_type);
    		String rtn = DogetSupRpt(headerData.get("gubun"),headerData.get("guest"),headerData.get("company_code"),headerData.get("dept_type"),headerData.get("gongji_gubun"));
    		setStatus(1);
    		setValue(rtn);
    		setMessage(msg.getMessage("0100"));
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		setStatus(0);
    		setMessage(msg.getMessage("0200"));
    	}
    	
    	return getSepoaOut();
    }
    
    private String DogetSupRpt(String gubun, String guest, String company_code,String dept_type,String gongji_gubun) throws Exception
    {
    	String rtn = null;
    	sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
    	ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
    	String language = info.getSession("LANGUAGE");
    	
    	StringBuffer tSQL = new StringBuffer();
    	tSQL.append(" SELECT NOTE.SUBJECT  \n");
    	tSQL.append((new StringBuilder(" , ")).append(DB_NULL_FUNCTION).append("((SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE = NOTE.COMPANY_CODE),'') AS COMPANY_NAME  \t\n").toString());
    	tSQL.append(" , getCodeText1('M216', NOTE.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \t\n");
    	tSQL.append(" , NOTE.ADD_DATE  \t\n");
    	tSQL.append(" , NOTE.ATTACH_NO  \t\n");
    	
    	tSQL.append(" , (SELECT count(*) FROM SFILE X WHERE X.DOC_NO = NOTE.ATTACH_NO) AS ATTACH_NAME   \t\n");
    	
    	tSQL.append(" , NOTE.CONTENT   \t\n");
    	tSQL.append(" , NOTE.SEQ   \n");
    	tSQL.append(" , NOTE.NOTE_TYPE \n");
    	
    	tSQL.append(" , NOTE.GONGJI_GUBUN AS GONGJI_GUBUN_CODE \n");
    	tSQL.append(" , getCodeText1('M222', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN  \n");
    	tSQL.append(" , NOTE.VIEW_COUNT \n");
    	tSQL.append(" , NOTE.PUBLISH_FLAG        \n");
    	tSQL.append(" , NOTE.PUBLISH_FROM_DATE   \n");
    	tSQL.append(" , NOTE.PUBLISH_TO_DATE     \n");
    	tSQL.append(" , NOTE.ADD_USER_ID                     \n");
    	tSQL.append(" , USMT.USER_NAME_LOC AS ADD_USER_NAME  \n");
    	tSQL.append(" , NOTE.VIEW_USER_TYPE         \n");
    	tSQL.append(" , GETCODETEXT2( 'Z001', NOTE.VIEW_USER_TYPE, 'KO' ) AS VIEW_USER_TYPE_TEXT         \n");
    	
    	tSQL.append(" , NOTE.GONGJI_GUBUN                                                                                                                                                         \n");
    	tSQL.append(" , (SELECT TEXT1 FROM SCODE WHERE TYPE='Z003' AND CODE = NOTE.GONGJI_GUBUN) GONGJI_GUBUN_TEXT                    \n");
    	 
    	tSQL.append(" FROM SRPT NOTE, ICOMLUSR USMT \n");
    	tSQL.append(" WHERE \n");
    	tSQL.append((new StringBuilder(" ")).append(DB_NULL_FUNCTION).append("(NOTE.DEL_FLAG, 'N') <> 'Y' \t\n").toString());
    	tSQL.append("   AND NOTE.ADD_USER_ID = USMT.USER_ID \n ");
    	String like_sql = "%" + guest + "%";
    	
    	if (!company_code.equals(""))
    	{
    		tSQL.append((new StringBuilder("   AND NOTE.COMPANY_CODE = '")).append(company_code).append("'\t\n ").toString());
    	}
    	if (!dept_type.equals(""))
    	{
    		tSQL.append((new StringBuilder("   AND NOTE.DEPT_TYPE = '")).append(dept_type).append("'\t\n ").toString());
    	}
    	
    	if ((gubun.length() > 0) && (guest.length() > 0))
    	{
    		if (gubun.equals("S"))
    		{
    			tSQL.append("   AND upper(NOTE.SUBJECT) LIKE  '"+like_sql+"' \n ");
    		}
    		
    		if (gubun.equals("U"))
    		{
    			tSQL.append("   AND upper(USMT.USER_NAME_LOC)  LIKE  '" + like_sql + "' \n ");
    		}
    		
    		if (gubun.equals("D"))
    		{
    			tSQL.append(sm.addSelectString("   AND NOTE.ADD_DATE = ? \t\n "));
    			sm.addStringParameter(guest);
    		}
    		
    		if (gubun.equals("C"))
    		{
    			tSQL.append(" and exists (select 'x' from snotd sfaqd where notd.seq = note.seq and \n ");
    			tSQL.append("             upper(notd.content) like '" + like_sql + "') \n ");
    		}
    	}
    	
    	if( !gongji_gubun.equals("") ) {
    		tSQL.append("	AND NOTE.GONGJI_GUBUN = '" + gongji_gubun + "' \n ");
    	}
//    	tSQL.append("	AND NOTE.ADD_DATE between TO_CHAR(SYSDATE - 180, 'YYYYMMDD') and TO_CHAR(SYSDATE, 'YYYYMMDD') \n ");
    	
    	tSQL.append(" ORDER BY \t\n");
    	tSQL.append(" SEQ DESC\n");
    	
    	
    	
    	try
    	{
    		rtn = sm.doSelect(tSQL.toString());
    	}
    	catch (Exception e)
    	{
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	
    	return rtn;
    }
    
    public SepoaOut modify_New_rpt(String[][] args) throws Exception
    {
        try
        {
            int rtn1 = get_modify_Rptd(args);

            if (rtn1 < 1)
            {
                throw new Exception("UPDATE SNOTE ERROR");
            }

            int rtn2 = get_modify_Rpt(args);

            if (rtn2 < 1)
            {
                throw new Exception("UPDATE SNOTE ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
        	
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
        }

        return getSepoaOut();
    }

    public int get_modify_Rptd(String[][] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			//String[][] args = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ}};
	        String content = args[0][2];
	        String seq = args[0][6];

	        sm.removeAllValue();
	        sb.append(" DELETE  SRPTD  WHERE SEQ = ?	\n"); sm.addStringParameter(seq);
	        sm.doDelete(sb.toString());

	        Vector v_cut_content = getSplitString(content, 1000);
	        for(int i = 1; i <= v_cut_content.size(); i++){

		        sm.removeAllValue();
		        sb.delete(0,sb.length());
		        sb.append(" INSERT INTO SRPTD    \t     \n");
		        sb.append(" (  			\t				\n");
		        sb.append("   SEQ  						\n");
		        sb.append(" , SEQ_SEQ  					\n");
		        sb.append(" , CONTENT  	\t				\n");
		        sb.append(" , DEL_FLAG  \t				\n");
		        sb.append(" ) VALUES ( 	\t				\n");
		        sb.append("   ?  						\n"); sm.addNumberParameter(seq);
		        sb.append(" , " + (new StringBuilder(String.valueOf(i))).append(" \t\n").toString());
		        sb.append(" , ?  		\t				\n"); sm.addStringParameter( (String)v_cut_content.elementAt(i-1) );
		        sb.append(" , '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'  		\t				\n");
		        sb.append(" )   		\t				\n");
		        rtn = sm.doInsert(sb.toString());
	        } //end for

	        Commit();
        }
        catch (Exception e)
        {
        	Rollback();
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    public int get_modify_Rpt(String[][] args) throws Exception
    {
        int rtn = 0;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

//String[][] obj = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ,DEPT_TYPE,GONGJI_GUBUN}};
	        String subject = args[0][0];
	        String company_code = args[0][1];
	        String attach_no = args[0][3];
	        String user_id = args[0][4];
	        String seq = args[0][6];
	        String dept_type = args[0][7];
	        String gongji_gubun = args[0][8];
	        String from_date = SepoaString.getDateUnSlashFormat(args[0][9]);
	        String to_date = SepoaString.getDateUnSlashFormat(args[0][10]);
	        String view_user_type = args[0][11];
	        //String publish_flag			= args[0][9];
	        //String publish_from_date	= args[0][10];
	        //String publish_to_date		= args[0][11];
	        
	        sm.removeAllValue();
	        sb.delete(0,sb.length());
	        sb.append(" UPDATE                 		\n");
	        sb.append(" \tSRPT            			\n");
	        sb.append(" SET                    		\n");
//	        sb.append("    dept_type     	 = ?,   \n"); sm.addStringParameter(dept_type);
            sb.append("    gongji_gubun    	 = ?,   \n"); sm.addStringParameter(gongji_gubun);
	        sb.append("    SUBJECT     		 = ?,   \n"); sm.addStringParameter(subject);
	        sb.append("    COMPANY_CODE      = ?,   \n"); sm.addStringParameter(company_code);
	        sb.append("    ATTACH_NO   		 = ?,  	\n"); sm.addStringParameter(attach_no);
	        sb.append("    ADD_USER_ID 		 = ?,   \n"); sm.addStringParameter(user_id);
//	        sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(from_date);
//	        sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(to_date);
	        sb.append("    VIEW_USER_TYPE 	 = ?,   \n"); sm.addStringParameter(view_user_type);
	        //sb.append("    PUBLISH_FLAG 	 = ?,   \n"); sm.addStringParameter(publish_flag);
	        //sb.append("    PUBLISH_FROM_DATE = ?,  	\n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_from_date));
	        //sb.append("    PUBLISH_TO_DATE 	 = ?,   \n"); sm.addStringParameter(SepoaString.getDateUnDashFormat(publish_to_date  ));
	        sb.append("    DEL_FLAG   	   \t= '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' 	\n");
	        sb.append(" WHERE SEQ = ?          		\n"); sm.addNumberParameter(seq);
	        rtn = sm.doUpdate(sb.toString());


        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    
    public SepoaOut getQuery_RPT_POP_New(String obj) throws Exception
    {
        String cnt2;
        String[] args = { obj };
        
    	//카운트 업데이트
    	int rtnCnt = 0; 
    	String user_id = info.getSession("ID");
    	if(user_id.length()>0 && !"LOGIN".equals(user_id)){
    		rtnCnt = et_setNoticeViewCount("SRPT", args);
    		Commit();
    	}

        String rtn = et_getQuery_RPT_POP_New(args);
        setValue(rtn);

        SepoaFormater wf = new SepoaFormater(rtn);
        cnt2 = wf.getValue("ATTACH_NO", 0);

        if ((cnt2 == null) || cnt2.equals(""))
        {
            setValue("");
            setStatus(1);
            setMessage(msg.getMessage("0000"));

//            return getSepoaOut();
        }
        else
        {
	        try
	        {
	            String[] args2 = { cnt2 };
	            String rtn2 = et_getFile_name(args2);
	            setValue(rtn2);
	            setStatus(1);
	            setMessage(msg.getMessage("0000"));
	        }
	        catch (Exception e)
	        {
	            setStatus(0);
	            setMessage(msg.getMessage("0001"));
	            Logger.err.println(info.getSession("ID"), this, e.getMessage());
	        }
        }

        rtn = et_getQuery_RPT_POP_New_contents(args);
        setValue(rtn);

        return getSepoaOut();
    }

    private String et_getQuery_RPT_POP_New(String[] args) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        String language = info.getSession("LANGUAGE");
        try
        {
	        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	        String seq = args[0];
	        sm.removeAllValue();
	        sb.append(" SELECT  \t\n");
	        sb.append("\t  note.SUBJECT, note.DEPT_TYPE AS DEPT_TYPE_CODE  \t\n");
	        sb.append("\t, note.SEQ \n");
	        sb.append((new StringBuilder("\t, ")).append(DB_NULL_FUNCTION).append("((SELECT VENDOR_NAME_LOC FROM ICOMVNGL WHERE VENDOR_CODE = note.COMPANY_CODE),'') AS COMPANY_NAME\t\n").toString());
	        sb.append("\t, getCodeText1('M216', note.DEPT_TYPE, '"+language+"')  AS DEPT_TYPE \n");
	        sb.append("\t, note.COMPANY_CODE \n");
	        sb.append("\t, note.ATTACH_NO \n");
	        sb.append("\t, note.NOTE_TYPE \n");
	        sb.append("\t, note.PUBLISH_FROM_DATE \n");
	        sb.append("\t, note.PUBLISH_TO_DATE \n");
	        
	        sb.append(" , NOTE.GONGJI_GUBUN \n");
	        sb.append(" , getCodeText1('Z003', NOTE.GONGJI_GUBUN, '"+language+"')  AS GONGJI_GUBUN_DESC  \n");
	        sb.append(" , NOTE.VIEW_COUNT \n");
	        sb.append(" , NOTE.VIEW_USER_TYPE \n");

	        sb.append(" FROM SRPT note \t\n");
	        sb.append(" WHERE 1 = 1 \n");
	        sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(seq);
	        sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
	        rtn = sm.doSelect(sb.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private String et_getQuery_RPT_POP_New_contents(String[] args) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
        {
	        ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	        String seq = args[0];
	        sm.removeAllValue();
	        sb.append(" SELECT CONTENT \t\n");
	        sb.append(" FROM SRPTD note \t\n");
	        sb.append(" WHERE 1 = 1 \n");
	        sb.append(sm.addFixString(" AND note.SEQ = ? \n")); sm.addStringParameter(seq);
	        sb.append(" AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') <> 'Y' \t\n");
	        sb.append(" order by seq_seq \n ");
	        rtn = sm.doSelect(sb.toString());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
    
    
    public SepoaOut DeleteSendRpt_New(String[][] setData)
    {
        try
        {
            int rtn1 = et_DeleteSendRpt_SRPT(setData);

            if (rtn1 < 1)
            {
                throw new Exception("DELETE SNOTE ERROR");
            }

            int rtn2 = et_DeleteSendRpt_SRPTD(setData);

            if (rtn2 < 1)
            {
                throw new Exception("DELETE SNOTE ERROR");
            }

            Commit();
            setStatus(1);
            setMessage(msg.getMessage("0100"));
        }
        catch (Exception e)
        {
            try
            {
                Rollback();
            }
            catch (Exception d)
            {
                Logger.err.println(info.getSession("ID"), this, d.getMessage());
            }

            setStatus(0);
            setMessage(msg.getMessage("0200"));
        }

        return getSepoaOut();
    }

    private int et_DeleteSendRpt_SRPT(String[][] setData) throws Exception
    {
        int rtn = -1;
        StringBuffer sb = new StringBuffer();
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        sb.append(" UPDATE SRPT SET DEL_FLAG = 'Y' ");
        sb.append(" WHERE SEQ = ? ");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
            String[] setType = { "S" };
            rtn = sm.doInsert(setData, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private int et_DeleteSendRpt_SRPTD(String[][] setData) throws Exception
    {
        int rtn = -1;
        StringBuffer sb = new StringBuffer();
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        sb.append(" UPDATE SRPTD SET DEL_FLAG = 'Y' ");
        sb.append(" WHERE SEQ = ? ");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sb.toString());
            String[] setType = { "S" };
            rtn = sm.doInsert(setData, setType);
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }





}
