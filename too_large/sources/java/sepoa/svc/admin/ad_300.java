package sepoa.svc.admin;

import java.util.HashMap;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;


public class AD_300 extends SepoaService
{
	private String ID = info.getSession("ID");
	private String lang = info.getSession("LANGUAGE");

	public AD_300(String opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
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
	    catch(ConfigurationException configurationexception)
	    {
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage());
	    }
	    catch(Exception exception)
	    {
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	    }
	    return null;
	}

	/**
	 * 업체창고매핑 삭제
	 * @param info
	 * @param inData
	 * @return
	 * @throws Exception
	 */
	public SepoaOut deleteModule(String[][] inData) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
        setFlag(true);
        setMessage("Success.");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			SepoaFormater sf = null;

            //매핑저장
            for (int i = 0; i < inData.length; i++)
            {
            	String module = inData[i][0];

				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE	SIFLH						\n");
				sb.append("   SET  	DEL_FLAG		= 'Y'		\n");
		 		sb.append(" WHERE 1 =1							\n");
				sb.append("   AND MODULE		= ?				\n");sm.addStringParameter(module);
    			sm.doUpdate(sb.toString());
            }//END FOR

            Commit();
		}
		catch (Exception e)
		{
			
            setFlag(false);
            setMessage(e.getMessage());
            Rollback();
            Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			
		}
		finally
		{
		}

		return getSepoaOut();
	}

	/**
	 * Module 저장
	 * @param info
	 * @param inData
	 * @return
	 * @throws Exception
	 */
	public SepoaOut setModule(String[][] inData) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
        setFlag(true);
        setMessage("Success.");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			SepoaFormater sf = null;


            //매핑저장
            for (int i = 0; i < inData.length; i++)
            {
            	int exist_cnt = 0;
                String module = inData[i][0];
                String last_execute_date = inData[i][1];
                String last_execute_time = inData[i][2];
                String module_name = inData[i][3];
                String rfc_name = inData[i][4];
                String process_id = inData[i][5];
                String method_name = inData[i][6];

    			//기존저장 유무
    			sm.removeAllValue();
    			sb.delete(0, sb.length());
    			sb.append(" SELECT                             	\n");
    			sb.append("     COUNT(*)   AS  CNT             	\n");
    			sb.append(" FROM   SIFLH                       	\n");
    			sb.append(" WHERE  	1 = 1  						\n");
    			sb.append(sm.addFixString(" 	AND MODULE   =   ?   		\n"));sm.addStringParameter(module);

    			sf = new SepoaFormater(sm.doSelect_limit(sb.toString()));
    			exist_cnt = Integer.parseInt( sf.getValue("CNT", 0) );

                if(exist_cnt < 1){
    				sm.removeAllValue();
    				sb.delete(0, sb.length());
    				sb.append(" INSERT INTO SIFLH( 	\n ");
    				sb.append("	MODULE,		\n ");
    				sb.append("	LAST_EXECUTE_DATE,		\n ");
    				sb.append("	LAST_EXECUTE_TIME ,		\n ");
    				sb.append("	MODULE_NAME ,			\n ");
    				sb.append("	RFC_NAME,			\n ");
    				sb.append("	process_id,			\n ");
    				sb.append("	method_name,			\n ");
    				sb.append(" DEL_FLAG       		\n");
    				sb.append(" )VALUES (   \n ");
    				sb.append(" 	?,	 \n ");sm.addStringParameter(module);
    				sb.append(" 	?,	 \n ");sm.addStringParameter(last_execute_date);
    				sb.append(" 	?,	 \n ");sm.addStringParameter(last_execute_time);
    				sb.append(" 	?,	 \n ");sm.addStringParameter(module_name);
    				sb.append(" 	?,	 \n ");sm.addStringParameter(rfc_name);
    				sb.append(" 	?,	 \n ");sm.addStringParameter(process_id);
    				sb.append(" 	?,	 \n ");sm.addStringParameter(method_name);
    				sb.append(" 	?	 \n ");sm.addStringParameter("N");
    				sb.append(" )	 \n ");
                    sm.doUpdate(sb.toString());
                }else{
    				sm.removeAllValue();
    				sb.delete(0, sb.length());
    				sb.append(" UPDATE	SIFLH						\n");
    				sb.append("   SET  	LAST_EXECUTE_DATE		= ?,		\n");sm.addStringParameter(last_execute_date);
    				sb.append(" 		LAST_EXECUTE_TIME		= ?,       	\n");sm.addStringParameter(last_execute_time);
    				sb.append(" 		MODULE_NAME		= ?,       	\n");sm.addStringParameter(module_name);
    				sb.append(" 		RFC_NAME		= ?,       	\n");sm.addStringParameter(rfc_name);
    				sb.append(" 		process_id		= ?,       	\n");sm.addStringParameter(process_id);
    				sb.append(" 		method_name		= ?,       	\n");sm.addStringParameter(method_name);
    				sb.append(" 		DEL_FLAG 		= 'N'      	\n");
    		 		sb.append(" WHERE 1 = 1							\n");
    				sb.append("   AND MODULE		= ?			\n");sm.addStringParameter(module);
        			sm.doUpdate(sb.toString());
                }
            }//END FOR

            Commit();
		}
		catch (Exception e)
		{
			
            setFlag(false);
            setMessage(e.getMessage());
            Rollback();
            Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			
		}
		finally
		{
		}

		return getSepoaOut();
	}


	/**
	 * Module List 조회
	 * @param info
	 * @param header
	 * @return
	 * @throws Exception
	 */
	public SepoaOut getModuleList(HashMap	header) throws Exception
	{
		setStatus(1);
		setFlag(true);
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		try
		{

			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			//get Params
			String module = (String) header.get("module");
			String module_name = (String) header.get("module_name");

			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" SELECT 	\n");
			sb.append(" 	A.MODULE,	\n");
			sb.append(" 	A.LAST_EXECUTE_DATE, 	\n");
			sb.append(" 	A.LAST_EXECUTE_TIME,	\n");
			sb.append(" 	A.MODULE_NAME, 	\n");
			sb.append(" 	A.RFC_NAME, 	\n");
			sb.append("     A.PROCESS_ID, \n ");
			sb.append("     A.METHOD_NAME \n ");
			sb.append(" FROM SIFLH A	\n");
			sb.append(" WHERE 1 = 1 	\n");
			sb.append(" 		AND " + DB_NULL_FUNCTION + "(A.DEL_FLAG,' ') <> 'Y'     \n");
			sb.append(sm.addSelectString(" 	AND UPPER(A.MODULE) = UPPER(?)     		\n"));sm.addStringParameter(module);
			sb.append(sm.addSelectString(" 	AND UPPER(A.module_name) = UPPER(?) \n"));sm.addStringParameter(module_name);
			sb.append(" ORDER BY A.MODULE		\n");

			//result
			rtn[0] = sm.doSelect(sb.toString());
			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
			
		}
		finally
		{
		}

		return getSepoaOut();
	}
}//END CLASS
