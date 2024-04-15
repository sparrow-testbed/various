package wise.util;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaInvoker;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaResource;


public class WiseApproval
{
  private Object obj = null;
  private String nickName = null;
  private String guserId = null;

  public WiseApproval(String paramString1, String paramString2, SepoaInfo paramWiseInfo)
    throws Exception
  {
    try
    {
      this.nickName = paramString1;
      if (paramWiseInfo != null) {
        this.guserId = paramWiseInfo.getSession("ID");
      }

      String[] arrayOfString = SepoaResource.getClass_Approval(paramString1);
      this.obj = SepoaInvoker.loadClass(paramString1, paramString2, paramWiseInfo, arrayOfString);
      if (this.obj == null) {
        Logger.err.println("SYSTEM", this, " No Create Object");
        throw new Exception(" No Create Object");
      }
    } catch (Exception localException) {
      Logger.err.println("SYSTEM", this, localException.getMessage());
      throw new Exception(localException.getMessage());
    }
  }

  public SepoaOut lookup(String paramString, Object[] paramArrayOfObject, SepoaInfo paramWiseInfo)
  {
	 SepoaOut localWiseOut = null;
    if (this.guserId == null)
    {
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = "Session ������ ����ϴ�.";
      return localWiseOut;
    }
    if (this.obj == null) {
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = "WiseService lookup : No Create Object";
      localWiseOut.result[0] = "";
      return localWiseOut;
    }

    try
    {
      String[] arrayOfString = SepoaResource.getMethod_Approval(this.nickName, paramString);
      localWiseOut = SepoaInvoker.invoke(this.obj, paramString, paramArrayOfObject, arrayOfString);
    }
    catch (SepoaServiceException localWiseServiceException) {
      Logger.err.println("SYSTEM", this, localWiseServiceException.getMessage());
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = localWiseServiceException.getMessage();
      localWiseOut.result[0] = "";
    }
    catch (Exception localException) {
      Logger.err.println("SYSTEM", this, localException.getMessage());
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = localException.getMessage();
      localWiseOut.result[0] = "";
    }
    return localWiseOut;
  }
  
  public SepoaOut lookup(String paramString, Object[] paramArrayOfObject)
  {
	  SepoaOut localWiseOut = null;
    if (this.guserId == null)
    {
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = "Session ������ ����ϴ�.";
      return localWiseOut;
    }
    if (this.obj == null) {
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = "WiseService lookup : No Create Object";
      localWiseOut.result[0] = "";
      return localWiseOut;
    }

    try
    {
      String[] arrayOfString = SepoaResource.getMethod_Approval(this.nickName, paramString);
      localWiseOut = SepoaInvoker.invoke(this.obj, paramString, paramArrayOfObject, arrayOfString);
    }
    catch (SepoaServiceException localWiseServiceException) {
      Logger.err.println("SYSTEM", this, localWiseServiceException.getMessage());
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = localWiseServiceException.getMessage();
      localWiseOut.result[0] = "";
    }
    catch (Exception localException) {
      Logger.err.println("SYSTEM", this, localException.getMessage());
      localWiseOut = new SepoaOut();
      localWiseOut.status = 0;
      localWiseOut.message = localException.getMessage();
      localWiseOut.result[0] = "";
    }
    return localWiseOut;
  }

  public void setConnection(ConnectionContext paramConnectionContext)
  {
    if (paramConnectionContext == null) {
      
      Logger.warn.println("SYSTEM", this, "Connection is Null");
    }
    else {
      Object[] arrayOfObject = { paramConnectionContext };
      try
      {
    	  SepoaInvoker.invoke(this.obj, "setConnectionContext", arrayOfObject, null);
      }
      catch (Exception localException) {
        Logger.err.println("SYSTEM", this, localException.getMessage());
      }
    }
  }
}
