package sepoa.fw.util;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaInvoker;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaServiceException;

public class SepoaApproval
{
    private Object obj;
    private String nickName;
    private String guserId;

    public SepoaApproval(String s, String s1, SepoaInfo sepoainfo) throws Exception
    {
        obj = null;
        nickName = null;
        guserId = null;

        try
        {
            nickName = s;

            if (sepoainfo != null)
            {
                guserId = sepoainfo.getSession("ID");
            }

            String[] as = SepoaResource.getClass_Approval(s);
            obj = SepoaInvoker.loadClass(s, s1, sepoainfo, as);

            if (obj == null)
            {
                Logger.err.println("SYSTEM", this, " No Create Object");
                throw new Exception(" No Create Object");
            }
        }
        catch (Exception exception)
        {
            Logger.err.println("SYSTEM", this, exception.getMessage());
            throw new Exception(exception.getMessage());
        }
    }

    public SepoaOut lookup(String s, Object[] aobj)
    {
        SepoaOut sepoaout = null;

        if (guserId == null)
        {
            sepoaout = new SepoaOut();
            sepoaout.status = 0;
            sepoaout.message = "Session \uC815\uBCF4\uAC00 \uC5C6\uC2B5\uB2C8\uB2E4.";

            return sepoaout;
        }

        if (obj == null)
        {
            sepoaout = new SepoaOut();
            sepoaout.status = 0;
            sepoaout.message = "Sepoa Service lookup : No Create Object";
            sepoaout.result[0] = "";

            return sepoaout;
        }

        try
        {
            String[] as = SepoaResource.getMethod_Approval(nickName, s);
            sepoaout = SepoaInvoker.invoke(obj, s, aobj, as);
        }
        catch (SepoaServiceException sepoaserviceexception)
        {
            Logger.err.println("SYSTEM", this, sepoaserviceexception.getMessage());
            sepoaout = new SepoaOut();
            sepoaout.status = 0;
            sepoaout.message = sepoaserviceexception.getMessage();
            sepoaout.result[0] = "";
        }
        catch (Exception exception)
        {
            Logger.err.println("SYSTEM", this, exception.getMessage());
            sepoaout = new SepoaOut();
            sepoaout.status = 0;
            sepoaout.message = exception.getMessage();
            sepoaout.result[0] = "";
        }

        return sepoaout;
    }

    public void setConnection(ConnectionContext connectioncontext)
    {
        if (connectioncontext == null)
        {
            
            Logger.warn.println("SYSTEM", this, "Connection is Null");
        }
        else
        {
            Object[] aobj = { connectioncontext };

            try
            {
                SepoaInvoker.invoke(obj, "setConnectionContext", aobj, null);
            }
            catch (Exception exception)
            {
                Logger.err.println("SYSTEM", this, exception.getMessage());
            }
        }
    }
}
