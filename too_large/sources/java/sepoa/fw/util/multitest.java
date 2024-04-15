package sepoa.fw.util;

import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

public class MultiTest extends SepoaService
{
    private String lang;

    public MultiTest(String opt, SepoaInfo info) throws SepoaServiceException
    {
        super(opt, info);
        lang = this.info.getSession("LANGUAGE");
        setVersion("1.0.0");
    }

    public SepoaOut getTest()
    {
        throw new Error("Unresolved compilation problem: \n\tMultiGipyo cannot be resolved\n");
    }

    public SepoaOut setInsert(String start_cnt, String end_cnt)
    {
        try
        {
            String rtn = "";
            rtn = et_getDelayQuery();
            setValue(rtn);
            setStatus(1);
            setMessage("\uC131\uACF5");
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);
            setMessage("\uC5D0\uB7EC");
        }

        return getSepoaOut();
    }

    public String et_getCnt()
    {
        StopWatch stopwatch = new StopWatch();
        Logger.dbwrap.println("TEST", this, "\n \uC804\uCCB4\uAC2F\uC218 start:elapsed[Count]=" + stopwatch.getElapsed());

        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        sql.append("  select count(*) from icoytest1   \n");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sql.toString());
            rtn = sm.doSelect((String[])null);

            StopWatch stopwatch1 = new StopWatch();
            Logger.dbwrap.println("TEST", this, "\n \uC804\uCCB4\uAC2F\uC218 end  :elapsed[Count]=" + stopwatch1.getElapsed());

            SepoaFormater wf = new SepoaFormater(rtn);

            if (wf.getRowCount() > 0)
            {
                rtn = wf.getValue(0, 0);
            }
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return rtn;
    }

    private int et_setInsert(String start_cnt, String end_cnt) throws Exception
    {
        StopWatch stopwatch = new StopWatch();
        Logger.dbwrap.println("TEST", this, "\n insert start  :elapsed[Count]=" + stopwatch.getElapsed());

        int rtn = 0;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        sql.append("  insert into icoytest2 (                                                        \n");
        sql.append("  \ttest_key, test1, test2, test3, test4, test5, test6                           \n");
        sql.append("  ) (                                                                            \n");
        sql.append("  select test_key, test1, test2, test3, test4, test5, test6                      \n");
        sql.append(" from (                                                                          \n");
        sql.append("  select  rownum as cnt,test_key, test1, test2, test3, test4, test5, test6       \n");
        sql.append("  from icoytest1                                                                 \n");
        sql.append("   ) tmp                                                                         \n");
        sql.append(" where  cnt between " + start_cnt + " and " + end_cnt + "                                \n");
        sql.append("     )                                                                           \n");

        try
        {
            SepoaSQLManager smdt = new SepoaSQLManager(info.getSession("ID"), this, ctx, sql.toString());
            rtn = smdt.doInsert((String[][])null, null);

            StopWatch stopwatch1 = new StopWatch();
            Logger.dbwrap.println("TEST", this, "\n insert end  :elapsed[Count]=" + stopwatch1.getElapsed());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }

    private String et_getDelayQuery() throws Exception
    {
        StopWatch stopwatch = new StopWatch();
        Logger.dbwrap.println("TEST", this, "\n DelayQuery start  :elapsed[Count]=" + stopwatch.getElapsed());

        String rtn = null;
        sepoa.fw.db.ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        sql.append(" select count(*) from  icomcode, icoyqtdp                                                       \n");

        try
        {
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sql.toString());
            rtn = sm.doSelect((String[])null);

            StopWatch stopwatch1 = new StopWatch();
            SepoaFormater wf = new SepoaFormater(rtn);

            if (wf.getRowCount() > 0)
            {
                rtn = wf.getValue(0, 0);
            }

            Logger.dbwrap.println("TEST", this, "\n DelayQuery end  :elapsed[Count]=" + stopwatch1.getElapsed());
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }

        return rtn;
    }
}
