package ev;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;

import sepoa.fw.log.Logger;

import sepoa.fw.msg.Message;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

public class WO_023 extends SepoaService
{
	private String ID = info.getSession("ID");

	public WO_023(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut a_23_list(String sg_kind, String ev_year, String sheet_status) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String language = info.getSession("LANGUAGE");
				Logger.sys.println("@@@@@@@@  sheet_status = " + sheet_status); // R 등록, C 확정
				
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("                     SELECT  EV_NO                                                             																		  \n");
				sb.append("                            ,SUBJECT                                                           																		  \n");
				sb.append("                            ,EV_YEAR                                                           																		  \n");
				sb.append("                            ,DECODE(CHANGE_USER_ID,'',ADD_USER_ID,CHANGE_USER_ID) AS ADD_ID    																		  \n");
				sb.append("                            ,CONVERT_DATE(DECODE(CHANGE_DATE,'',ADD_DATE,CHANGE_DATE)) AS ADD_DATE          															  \n");
				sb.append("                            ,SHEET_STATUS                                                      																		  \n");
				sb.append("                            ,getcodetext1('M222',SHEET_STATUS,'KO') AS SHEET_STATUS_TEXT       																		  \n");
				sb.append("                            ,(SELECT COUNT(*) AS CNT FROM SEVVN WHERE EV_NO = A.EV_NO AND EV_YEAR = A.EV_YEAR AND DEL_FLAG = 'N' AND EV_DATE IS NOT NULL) AS SHEET_START_CNT  \n");
				sb.append("                            ,getsgname2(sg_kind) AS SG_KIND                                                     														  \n");
				sb.append("                            ,( SELECT DECODE(COUNT(*),1,'Y','N') FROM   SINVN  WHERE EV_NO = A.EV_NO AND EV_YEAR = A.EV_YEAR AND NVL(DEL_FLAG,'N') = 'N' AND NVL(EV_FLAG,'N') = 'Y' AND ROWNUM < 2 AND ST_DATE IS NOT NULL )  AS VENDOR_CNT  			  	  \n");
				sb.append("                      FROM   SEVGL  A                                                      																			  \n");
				sb.append("                      WHERE  1=1                                                         																			  \n");
				sb.append("                      AND    NVL(DEL_FLAG,'N') ='N'                                                         																\n");
				sb.append(sm.addSelectString("   AND    EV_YEAR = ?					      																										  \n")); sm.addStringParameter(ev_year);
				if( "".equals(sheet_status) ){
					sb.append("                  AND SHEET_STATUS IN ( 'R','C' )					      																							  \n");
				}else{
					sb.append(sm.addSelectString("   AND SHEET_STATUS = ?					      																								  \n")); sm.addStringParameter(sheet_status);	
				}
				
				sb.append(sm.addSelectString("   AND SG_KIND = ?					      			                                                                                              \n")); sm.addStringParameter(sg_kind);
				
				Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

				rtn[0] = sm.doSelect(sb.toString());
			
				setValue(rtn[0]);
				
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}
	
	
	public SepoaOut a_23_decide(String[][] bean_args) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String language = info.getSession("LANGUAGE");

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				for (int i = 0; i < bean_args.length; i++)
				{
					String ev_no = bean_args[i][0];
					String ev_year = bean_args[i][1];
					
				
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" UPDATE  SEVGL SET         \n");
					
					sb.append(" 		SHEET_STATUS   = 'C'  		\n");
					sb.append(" 		,CHANGE_DATE   =? 		\n");sm.addStringParameter(SepoaDate.getShortDateString());
					sb.append(" 		,CHANGE_USER_ID =?		\n");sm.addStringParameter(info.getSession("ID"));
					sb.append(" 		WHERE  EV_NO = ?  		\n");sm.addStringParameter(ev_no);
					sb.append(" 		AND  EV_YEAR = ?  		\n");sm.addStringParameter(ev_year);
					sm.doUpdate(sb.toString());
					
					Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
					
				}

				sm.doUpdate(sb.toString());
				Commit();
				
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}
	
	public SepoaOut a_23_cancel(String[][] bean_args) throws Exception
	{
		try
		{
			String[] rtn = new String[2];
			setStatus(1);
			setFlag(true);

			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String language = info.getSession("LANGUAGE");

			
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				
				for (int i = 0; i < bean_args.length; i++)
				{
					String ev_no = bean_args[i][0];
					String ev_year = bean_args[i][1];
					
				
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" UPDATE  SEVGL SET         \n");
					
					sb.append(" 		SHEET_STATUS   = 'D'  		\n");
					sb.append(" 		,CHANGE_DATE   =? 		\n");sm.addStringParameter(SepoaDate.getShortDateString());
					sb.append(" 		,CHANGE_USER_ID =?		\n");sm.addStringParameter(info.getSession("ID"));
					sb.append(" 		WHERE  EV_NO = ?  		\n");sm.addStringParameter(ev_no);
					sb.append(" 		AND  EV_YEAR = ?  		\n");sm.addStringParameter(ev_year);
					sm.doUpdate(sb.toString());
					
					Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
					
					/*sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" UPDATE SINVN SET                    \n");
					sb.append("                DEL_FLAG = 'Y'       \n");
					sb.append(" 		WHERE  EV_NO    = ?  		\n");sm.addStringParameter(ev_no);
					sb.append(" 		AND    EV_YEAR  = ?  		\n");sm.addStringParameter(ev_year);
					sm.doDelete(sb.toString());
					
					Logger.debug.println(info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
					*/
					
					
				}

				Commit();
				
				
		}
		catch (Exception e)
		{
//			e.printStackTrace();
			setMessage(e.getMessage());
			setStatus(0);
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);
//			System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+" ERROR:"+e);

		}

		return getSepoaOut();
	}

}
