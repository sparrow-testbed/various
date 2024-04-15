package sepoa.svc.admin;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;

import sepoa.fw.log.Logger;

import sepoa.fw.msg.Message;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

import sepoa.fw.util.*;


public class AD_037 extends SepoaService
{
    private String ID = info.getSession("ID");
    private String SEPOA_DB_VENDOR = "";
    private String DB_NULL_FUNCTION = "";

    public AD_037(String opt, SepoaInfo info) throws SepoaServiceException
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
        Logger.debug.println(wi.getSession("ID"), this, "#####" + rtn);
    }

    public SepoaOut selectCommonModuleList(SepoaInfo wi, String[] straData)
    {
        String user_id = wi.getSession("ID");

        //WiseService ws = new WiseService();
        String[] straReturn = null;
        setFlag(true);
        setMessage("Success.");

        try
        {
            straReturn = processSelectMoldCode(wi, straData);

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

    private String[] processSelectMoldCode(SepoaInfo wi, String[] straData) throws Exception
    {
        //WiseService ws = new WiseService();
        String[] rtn = new String[2];

        StringBuffer sql = new StringBuffer();
        ConnectionContext ctx = getConnectionContext();
        setFlag(true);
        setMessage("Success.");

        try
        {
            String taskType = "CONNECTION";

            //DaguriSql sm = new DaguriSql(wi.getSession("ID"), this, ws.getConnection(taskType, wi, this, "processSelectMoldCode"));
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            sm.removeAllValue();
            sql.delete(0, sql.length());

            sql.append("SELECT 	\n");
            sql.append("    USE_FLAG, \n");
            sql.append("    CODE ID, \n");
            sql.append("    TEXT1 DESCRIPTION, \n");
            sql.append("    TEXT2 TITLE, \n");
            sql.append("    TEXT3 LIST_ITEM, \n");

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sql.append("    DECODE (FLAG, 'SP', 'POPUP', 'SL', 'COMBO', '') AS LIST_TYPE, \n");
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sql.append("    (CASE WHEN FLAG = 'SP' THEN 'POPUP' WHEN FLAG = 'SL' THEN 'COMBO' ELSE '' END) AS LIST_TYPE, \n");
            }

            sql.append("    TEXT4 IMAGE, \n");
            sql.append("    getCodeText1('M013', language, '" + info.getSession("LANGUAGE") + "') as language_text, \n ");
            sql.append("    language \n ");
            sql.append("FROM scode	\n");
            sql.append("WHERE TYPE = 'S000'		\n");

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sql.append(sm.addSelect("    AND upper(CODE) LIKE '%' || upper(?) || '%'  \n"));
                sm.addParameter(straData[0]);
                sql.append(sm.addSelect("    AND upper(FLAG) LIKE '%' || upper(?) || '%' \n"));
                sm.addParameter(straData[1]);
                sql.append(sm.addSelect("    AND ( upper(TEXT1) LIKE '%' || upper(?) || '%'  \n"));
                sm.addParameter(straData[2]);
                sql.append(sm.addSelect("    OR upper(TEXT2) LIKE '%' || upper(?) || '%'  \n"));
                sm.addParameter(straData[2]);
                sql.append(sm.addSelect("    OR upper(TEXT3) LIKE '%' || upper(?) || '%' ) \n"));
                sm.addParameter(straData[2]);
                sql.append(sm.addSelect("    AND upper(TEXT4) LIKE '%' || upper(?) || '%' \n"));
                sm.addParameter(straData[3]);
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sql.append(sm.addSelect("    AND upper(CODE) LIKE CONCAT('%' , upper(?) , '%')  \n"));
                sm.addParameter(straData[0]);
                sql.append(sm.addSelect("    AND upper(FLAG) LIKE CONCAT('%' , upper(?) , '%') \n"));
                sm.addParameter(straData[1]);
                sql.append(sm.addSelect("    AND ( upper(TEXT1) LIKE CONCAT('%' , upper(?) , '%')  \n"));
                sm.addParameter(straData[2]);
                sql.append(sm.addSelect("    OR upper(TEXT2) LIKE CONCAT('%' , upper(?) , '%')  \n"));
                sm.addParameter(straData[2]);
                sql.append(sm.addSelect("    OR upper(TEXT3) LIKE CONCAT('%' , upper(?) , '%' ) \n"));
                sm.addParameter(straData[2]);
                sql.append(sm.addSelect("    AND upper(TEXT4) LIKE CONCAT('%' , upper(?) , '%') \n"));
                sm.addParameter(straData[3]);
            }

            sql.append(sm.addSelectString("   and language = ? \n \n "));
            sm.addStringParameter(straData[4]);
            sql.append("    AND CODE != 'ID' \n");
            sql.append("	AND CODE != 'REVIEW' \n");
            sql.append("	AND TEXT4 IS NOT NULL   \n");
            sql.append("    AND " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') = 'N' \n");
            sql.append("ORDER BY CODE	\n");

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
            	printDebug(wi, e.toString());
            }
        }

        return rtn;
    }

    public SepoaOut selectCode(SepoaInfo wi, String[] straData)
    {
        //SepoaService ws = new WiseService();
        String[] straReturn = null;
        setFlag(true);
        setMessage("Success.");

        try
        {
            straReturn = processSelectCode(wi, straData);

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

    private String[] processSelectCode(SepoaInfo wi, String[] straData) throws Exception
    {
        //WiseService ws = new WiseService();
        String[] rtn = new String[2];

        StringBuffer sql = new StringBuffer();
        setFlag(true);
        setMessage("Success.");

        ConnectionContext ctx = getConnectionContext();

        try
        {
            String taskType = "CONNECTION";

            //DaguriSql sm = new DaguriSql(wi.getSession("ID"), this, ws.getConnection(taskType, wi, this, "processSelectCode"));
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue();
            sql.delete(0, sql.length());
            sql = new StringBuffer();

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sql.append("SELECT \n");
                sql.append(sm.addFix("    ? || CODE AS CODE \n"));
                sm.addParameter(straData[0]);
                sql.append("FROM 												\n");
                sql.append("    ( 												\n");
                sql.append("        SELECT 										\n");
                sql.append("            TRIM(TO_CHAR(ROWNUM,'0000')) AS CODE 	\n");
                sql.append("        FROM 										\n");
                sql.append("            scode 									\n");
                sql.append("        WHERE 										\n");
                sql.append("            TYPE ='S000' 							\n");
                sql.append("            AND  ROWNUM < 10000 					\n");
                sql.append("        MINUS 										\n");
                sql.append("        SELECT 										\n");
                sql.append("            SUBSTR(CODE,3) 							\n");
                sql.append("        FROM 										\n");
                sql.append("            scode 									\n");
                sql.append("        WHERE 										\n");
                sql.append("            TYPE ='S000' 							\n");
                sql.append(sm.addFix("            AND FLAG = ? 					\n"));
                sm.addParameter(straData[0]);
                sql.append("            AND CODE NOT IN('_SP0210','ID','REVIEW') \n");
                sql.append("    ) 												\n");
                sql.append("WHERE 												\n");
                sql.append("    ROWNUM < 2 										\n");

                rtn[0] = sm.doSelect(sql.toString());

                if (rtn[0] == null)
                {
                    //rtn[1] = "SQL manager is Null";
                    //rtn[0] = "Error===========>SQL Manager is Null";
                    //rtn[1] = "Error===========>SQL Manager is Null";
                    throw new Exception("SQL Manager is Null");
                }
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sql.append("SELECT 												\n");
                sql.append(sm.addFix("   CONCAT( ? , A.CODE) AS CODE 				\n"));
                sm.addParameter(straData[0]);
                sql.append("FROM 													\n");
                sql.append("    ( 													\n");
                sql.append("        SELECT 										\n");
                sql.append("            TRIM(TO_CHAR(ROWNUM,'0000')) AS CODE 		\n");
                sql.append("        FROM 											\n");
                sql.append("            scode 										\n");
                sql.append("        WHERE 											\n");
                sql.append("            TYPE ='S000' 								\n");
                sql.append("        LIMIT = 9999 									\n");
                sql.append("        MINUS 											\n");
                sql.append("        SELECT 										\n");
                sql.append("            SUBSTR(CODE,3) 							\n");
                sql.append("        FROM 											\n");
                sql.append("            scode 										\n");
                sql.append("        WHERE 											\n");
                sql.append("            TYPE ='S000' 								\n");
                sql.append(sm.addFix("            AND FLAG = ? 					\n"));
                sm.addParameter(straData[0]);
                sql.append("            AND CODE NOT IN('_SP0210','ID','REVIEW') 	\n");
                sql.append("    ) A												\n");
                sql.append("    limit 1 											\n");

                rtn[0] = sm.doSelect(sql.toString());

                if (rtn[0] == null)
                {
                    //rtn[0] = "Error===========>SQL Manager is Null";
                    //rtn[1] = "Error===========>SQL Manager is Null";
                    //rtn[1] = "SQL manager is Null";
                    throw new Exception("SQL Manager is Null");
                }
            }
        }
        catch (Exception e)
        {
            printDebug(wi, e.toString());
            //rtn[1] = e.getMessage();
            rtn[0] = "SQL Manager is Null";
            rtn[1] = "SQL Manager is Null";
        }
        finally
        {
            try
            {
                //Release();
            }
            catch (Exception e)
            {
            	printDebug(wi, e.toString());
            }
        }

        return rtn;
    }

    public SepoaOut testSql(SepoaInfo wi, String args)
    {
        //WiseService ws = new WiseService();
        String[] straReturn = null;
        setFlag(true);
        setMessage("Success.");

        boolean existwhere = false; // where 문이 있는지 여부
        boolean existorder = false; // order 문이 있는지 여부
        boolean existgroup = false; // group 문이 있는지 여부
        int index = 0;

        int indexwhere = 0;
        int indexorder = 0;
        int indexgroup = 0;

        String[] v = new String[10];
        String[] change = new String[2];

        args = SepoaString.replace(args, "select ", "select top 1 ");

        String pargs = "";

        // ?  -> ' '바꿈
        for (int i = 0; i < args.length(); i++)
            if (args.charAt(i) == '?')
            {
                change[0] = args.substring(0, i);
                change[1] = args.substring(i + 1, args.length());
                args = change[0] + " '' " + change[1];
            }

        //  rownum = 1 을 sql 에 붙이기 위한 작업
        indexwhere = args.lastIndexOf("WHERE");

        if (indexwhere == -1)
        {
            // where 없다.
        }
        else
        { //where 있다.
            existwhere = true;
        }

        indexorder = args.lastIndexOf("ORDER BY");

        if ((indexorder == -1) || (indexorder < indexwhere))
        {
             // order이 not exist 때
        }
        else
        { //order 가 있다.
            existorder = true;
            v[1] = args.substring(0, indexorder);
            //  ~order 전
            v[2] = args.substring(indexorder, args.length());
        }

        // GROUP BY 절이 오면 rownum = 1 을 이것 앞에 놓아야 한다.
        // order by는 group by 뒤에 위치됨으로 신경쓸 필요업다.
        indexgroup = args.lastIndexOf("GROUP BY");

        if ((indexgroup == -1) || (indexgroup < indexwhere))
        { // group이 not exist 때
            ;
        }
        else
        { //group이 있다.
            existgroup = true;
            v[1] = args.substring(0, indexgroup);
            //  ~group 전
            v[2] = args.substring(indexgroup, args.length());
        }

        if ((existwhere == false) && ((existorder == false) || (existgroup == false)))
        {
            pargs = args;
        }

        if ((existwhere == true) && ((existorder == false) || (existgroup == false)))
        {
            pargs = args;
        }

        if ((existwhere == false) && ((existorder == true) || (existgroup == true)))
        {
            pargs = v[1] + v[2];
        }

        if ((existwhere == true) && ((existorder == true) || (existgroup == true)))
        {
            pargs = v[1] + v[2];
        }

        String rtn = null;

        try
        {
            straReturn = testSqlFromDb(wi, pargs);

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

    private String[] testSqlFromDb(SepoaInfo wi, String val) throws Exception
    {
        String[] rtn = new String[2];
        ConnectionContext ctx = getConnectionContext();

        setFlag(true);
        setMessage("Success.");

        try
        {
            String taskType = "CONNECTION";
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            sm.removeAllValue();

            rtn[0] = sm.doSelect(val);

            if (rtn[0] == null)
            {
                throw new Exception("SQL Manager is Null");
            }

            rtn[0] = "Verified SQL Successfully";
        }
        catch (Exception e)
        {
            //printDebug(wi, e.toString());
            rtn[0] = "Error===========>SQL Manager is Null";
            rtn[1] = "Error===========>SQL Manager is Null";
        }
        finally
        {
            try
            {
                //Release();
            }
            catch (Exception e)
            {
                throw new Exception("SQL Manager is Null:" + e.getMessage());
            }
        }

        return rtn;
    }

    public SepoaOut insertCode(SepoaInfo wi, String[] straData)
    {
        String[] straReturn = null;
        setFlag(true);
        setMessage("Success.");

        try
        {
            straReturn = processInsertCode(wi, straData);

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

    private String[] processInsertCode(SepoaInfo wi, String[] setData) throws Exception
    {
        String[] rtn = new String[2];
        String strId = wi.getSession("ID");
        String strLanguage = wi.getSession("LANGUAGE");
        ConnectionContext ctx = getConnectionContext();
        setFlag(true);
        setMessage("Success.");

        try
        {
            String taskType = "TRANSACTION";
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue();

            StringBuffer sql = new StringBuffer();
            sql.append("INSERT INTO \n");
            sql.append("    scode ( \n");
            sql.append("    HOUSE_CODE, \n");
            sql.append("    LANGUAGE, \n");
            sql.append("    TYPE, \n");
            sql.append("    CODE, \n");
            sql.append("    TEXT2, \n");
            sql.append("    FLAG, \n");
            sql.append("    TEXT1, \n");
            sql.append("    TEXT3, \n");
            sql.append("    TEXT4, \n");
            sql.append("    DEL_FLAG, \n");
            sql.append("    ADD_DATE, \n");
            sql.append("    ADD_TIME, \n");
            sql.append("    ADD_USER_ID, \n");
            sql.append("    CHANGE_DATE, \n");
            sql.append("    CHANGE_TIME, \n");
            sql.append("    CHANGE_USER_ID, \n");
            sql.append("    USE_FLAG, \n");
            sql.append("    TEXT5 ) \n");
            //sql.append("    LANGUAGE ) \n");
            sql.append("VALUES ( \n");
            sql.append("    ? , \n");
            sm.addStringParameter(info.getSession("HOUSE_CODE"));
            sql.append("    ? , \n");
            sm.addStringParameter(setData[8]);
            sql.append("    'S000', \n");
            sql.append("    ?, \n");
            sm.addStringParameter(setData[0]);
            sql.append("    ?, \n");
            sm.addStringParameter(setData[1]);
            sql.append("    ?, \n");
            sm.addStringParameter(setData[2]);
            sql.append("    ?, \n");
            sm.addStringParameter(setData[3]);
            sql.append("    ?, \n");
            sm.addStringParameter(setData[4]);
            sql.append("    ?, \n");
            sm.addStringParameter(setData[5]);
            sql.append("    'N', \n");

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sql.append("    TO_CHAR(SYSDATE, 'YYMMDD'), \n");
                sql.append("    TO_CHAR(SYSDATE, 'HH24MISS'), \n");
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sql.append("    date_format( now() , '%Y%m%d'), \n");
                sql.append("    date_format( now() , '%H%i%S'), \n");
            }

            sql.append("    ?, \n");
            sm.addStringParameter(strId);

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sql.append("    TO_CHAR(SYSDATE, 'YYMMDD'), \n");
                sql.append("    TO_CHAR(SYSDATE, 'HH24MISS'), \n");
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sql.append("    date_format( now() , '%Y%m%d'), \n");
                sql.append("    date_format( now() , '%H%i%S'), \n");
            }

            sql.append("    ?, \n");
            sm.addStringParameter(strId);
            sql.append("    ?, \n");
            sm.addStringParameter(setData[6]);
            sql.append("    ? \n");
            sm.addStringParameter(setData[7]);
            //sql.append("    ? \n");
            //sm.addParameter(strLanguage);
            sql.append(") \n");

            int nResult = sm.doInsert(sql.toString());

            Commit();
        }
        catch (Exception e)
        {
            printDebug(wi, e.toString());
            //rtn[1] = e.getMessage();
            rtn[0] = "Error!!!";
            rtn[1] = "Error!!!";
        }
        finally
        {
            try
            {
                Release();
            }
            catch (Exception e)
            {
            	printDebug(wi, e.toString());
            }
        }

        return rtn;
    }

    public SepoaOut deleteCode(SepoaInfo wi, String[][] straData)
    {
        String[] straReturn = null;
        setFlag(true);
        setMessage("Success.");

        try
        {
            straReturn = processDeleteCode(wi, straData);

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

    private String[] processDeleteCode(SepoaInfo wi, String[][] straData) throws Exception
    {
        String[] rtn = new String[2];

        setFlag(true);
        setMessage("Success.");

        int nResult = 0;
        ConnectionContext ctx = getConnectionContext();

        try
        {
            String taskType = "TRANSACTION";
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            StringBuffer sql = new StringBuffer();

            for (int i = 0; i < straData.length; i++)
            {
                sm.removeAllValue();
                sql.delete(0, sql.length());

                sql.append("DELETE \n");
                sql.append("    FROM scode \n");
                sql.append("WHERE  \n");
                sql.append("     CODE =? \n");
                sm.addStringParameter(straData[i][0]);
                sql.append("     AND LANGUAGE = ? \n");
                sm.addStringParameter(straData[i][1]);
                sql.append("     AND TYPE = 'S000' \n");
                nResult = sm.doDelete(sql.toString());
            }

            Commit();
        }
        catch (Exception e)
        {
            Rollback();
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
            	printDebug(wi, e.toString());
            }
        }

        return rtn;
    }

    public SepoaOut selectCodeUseId(SepoaInfo wi, String strCode, String lang)
    {
        String[] straReturn = null;
        setFlag(true);
        setMessage("Success.");

        try
        {
            straReturn = processSelectCodeUseId(wi, strCode, lang);

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

    private String[] processSelectCodeUseId(SepoaInfo wi, String code, String lang) throws Exception
    {
        String[] straReturn = new String[2];

        setFlag(true);
        setMessage("Success.");

        ConnectionContext ctx = getConnectionContext();

        try
        {
            String taskType = "CONNECTION";
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            StringBuffer strbufSql = new StringBuffer();
            strbufSql.append("SELECT 		\n");
            strbufSql.append("    TEXT2, 	\n");
            strbufSql.append("    USE_FLAG, \n");
            strbufSql.append("    FLAG, 	\n");
            strbufSql.append("    TEXT1, 	\n");
            strbufSql.append("    TEXT3, 	\n");
            strbufSql.append("    TEXT4, 	\n");
            strbufSql.append("    TEXT5 	\n");
            strbufSql.append("FROM 			\n");
            strbufSql.append("    scode 	\n");
            strbufSql.append("WHERE 		\n");
            strbufSql.append("    TYPE = 'S000' \n");
            strbufSql.append(sm.addFixString("    AND CODE = ?  \n"));
            sm.addStringParameter(code);

            strbufSql.append(sm.addFixString("   and language = ? \n "));
            sm.addStringParameter(lang);
            straReturn[0] = sm.doSelect(strbufSql.toString());

            if (straReturn[0] == null)
            {
                straReturn[1] = "SQL manager is Null";
            }
        }
        catch (Exception e)
        {
            printDebug(wi, e.toString());
            straReturn[1] = e.getMessage();
        }
        finally
        {
            try
            {
                Release();
            }
            catch (Exception e)
            {
            	printDebug(wi, e.toString());
            }
        }

        return straReturn;
    }

    public SepoaOut updateCode(SepoaInfo wi, String[] straData)
    {
        String[] straReturn = null;
        setFlag(true);
        setMessage("Success.");

        try
        {
            straReturn = processUpdateCode(wi, straData);

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

    private String[] processUpdateCode(SepoaInfo wi, String[] straData) throws Exception
    {
        String[] straReturn = new String[2];

        setFlag(true);
        setMessage("Success.");

        ConnectionContext ctx = getConnectionContext();

        try
        {
            String strUserId = wi.getSession("ID");
            String taskType = "TRANSACTION";
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            StringBuffer sql = new StringBuffer();

            sql.append("UPDATE \n");
            sql.append("    scode \n");
            sql.append("SET \n");
            sql.append("     TEXT2 = ?, \n");
            sm.addStringParameter(straData[0]);
            sql.append("     USE_FLAG =? , \n");
            sm.addStringParameter(straData[1]);
            sql.append("     FLAG = ?, \n");
            sm.addStringParameter(straData[2]);
            sql.append("     TEXT1 = ?, \n");
            sm.addStringParameter(straData[3]);
            sql.append("     TEXT3 = ?, \n");
            sm.addStringParameter(straData[4]);
            sql.append("     TEXT4 = ?, \n");
            sm.addStringParameter(straData[5]);
            sql.append("     TEXT5 = ?, \n");
            sm.addStringParameter(straData[6]);

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sql.append("     CHANGE_DATE = to_char(sysdate, 'YYYYMMDD'), \n");
                sql.append("     CHANGE_TIME = to_char(sysdate, 'HH24MISS'), \n");
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sql.append("     CHANGE_DATE = date_format( now() , '%Y%m%d'), \n");
                sql.append("     CHANGE_TIME = date_format( now() , '%H%i%S'), \n");
            }

            sql.append("     CHANGE_USER_ID = ? \n");
            sm.addStringParameter(strUserId);
            //sql.append("     STATUS = 'R' \n");
            sql.append("WHERE \n");
            sql.append("     TYPE = 'S000' \n");
            sql.append("     AND CODE = ? \n");
            sm.addStringParameter(straData[7]);
            sql.append("     and language = ? \n ");
            sm.addStringParameter(straData[8]);

            sm.doUpdate(sql.toString());
            Commit();
        }
        catch (Exception e)
        {
            printDebug(wi, e.toString());
            straReturn[1] = e.getMessage();
        }
        finally
        {
            try
            {
                Release();
            }
            catch (Exception e)
            {
            	printDebug(wi, e.toString());
            }
        }

        return straReturn;
    }

    /* 중복체크 */
    public SepoaOut getDuplicate(String[] args)
    {
        Message msg = new Message(info, "FW");
        String user_id = info.getSession("ID");
        String rtn = null;

        try
        {
            Logger.debug.println(user_id, this, "######getDuplicate#######");
            // Isvalue(); ....
            rtn = Check_Duplicate(args, user_id);
            Logger.debug.println(user_id, this, "duplicate-result= ===>" + rtn);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
        }

        return getSepoaOut();
    }

    private String Check_Duplicate(String[] args, String user_id) throws Exception
    {
        String rtn = null;
        String count = "";
        String[][] str = new String[1][2];
        ConnectionContext ctx = getConnectionContext();

        try
        {
            StringBuffer tSQL = new StringBuffer();
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            tSQL.append(" SELECT                                \n");
            tSQL.append("  COUNT(*)                             \n");
            tSQL.append(" FROM scode                         \n");

            tSQL.append(" where " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N' \n ");
            tSQL.append(sm.addFixString(" AND CODE= ? \n "));
            sm.addStringParameter(args[0]);

            tSQL.append(sm.addFixString("  and language = ? \n "));
            sm.addStringParameter(args[1]);

            tSQL.append("   and type = 'S000' \n ");

            //String[] args = {house_code, company_code,operating_code};
            rtn = sm.doSelect(tSQL.toString());
            SepoaFormater wf = new SepoaFormater(rtn);
            str = wf.getValue();
            count = str[0][0];

            if (rtn == null)
            {
                throw new Exception("SQL Manager is Null");
            }
        }
        catch (Exception e)
        {
            throw new Exception("Check_Duplicate:" + e.getMessage());
        }
        finally
        {
            //Release();
        }

        return count;
    }
}
