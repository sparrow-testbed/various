package sepoa.svc.admin;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class AD_118 extends SepoaService
{
	private String ID = info.getSession("ID");
//	Message msg = new Message("KO", "FW");
	Message msg = null;

	public AD_118(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		msg = new Message(info, "FW");
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

	/**
	 * 공장정보 조회
	*  getMainternace
	*  수정일 : 2013.02
	*/

	public SepoaOut getMainternace(Map< String, String > header)	throws Exception {
		
		
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		String[] rtn = new String[2];
		StringBuffer sb = new StringBuffer();
		try {
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

//          2013.10.21 최숙현 수정
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(                   "SELECT                                                                                                     \n");
			sb.append(                   "   PL.PLANT_CODE                                                                                           \n");
			sb.append(                   " , PL.PLANT_NAME_LOC                                                                                       \n");
			sb.append(                   " , PL.PLANT_NAME_ENG                                                                                       \n");
			sb.append(                   " , PL.DEPT                                                                                                 \n");
			sb.append(                   " , GETCODETEXT2('M062', PL.PR_LOCATION, '" + info.getSession("LANGUAGE") + "') AS PR_LOCATION_NAME     \n");
			sb.append(                   " , PL.COMPANY_CODE                                                                                         \n");
			sb.append(                   " , PL.PR_LOCATION                                                                                          \n");
			sb.append(                   " , PL.IRS_NO                                                                                               \n");
			sb.append(                   " , VW.ADDRESS_LOC                                                                                          \n");
			sb.append(                   " , VW.BUSINESS_TYPE                                                                                        \n");
			sb.append(                   " , VW.INDUSTRY_TYPE                                                                                        \n");
			sb.append(                   " FROM  SPLNT   PL                                                                                          \n");
			sb.append(                   "       LEFT OUTER JOIN PLANT_GENERAL_VW VW                                                                 \n");
			sb.append(                   "       ON PL.COMPANY_CODE = VW.COMPANY_CODE                                                                \n");
			sb.append(                   "       AND PL.PLANT_CODE = VW.PLANT_CODE                                                                   \n");
			sb.append(                   "       AND PL.COUNTRY = VW.COUNTRY                                                                         \n");
			sb.append(                   " WHERE 1 = 1                                                                                               \n");
			sb.append(sm.addFixString(   " AND PL.COMPANY_CODE     = ?                                                                               \n"));sm.addStringParameter(MapUtils.getString( header, "i_company_code" , "" ));
			sb.append(                   " AND " + DB_NULL_FUNCTION + "(PL.DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                                                      \n");
			
			rtn[0] = sm.doSelect(sb.toString()); 
			
			setValue(rtn[0]);

            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M062" );
		} catch (Exception e) {
			setMessage(e.getMessage());
			
			setFlag(false);
			Logger.debug.println(ID, this, new Exception().getStackTrace()[0].getClassName()+ "."+ new Exception().getStackTrace()[0].getMethodName()+ " ERROR:" + e);
			
		} finally {
		}
		return getSepoaOut();
		
	} // getMainternace() end

	/**
	*Save
	*/
	public SepoaOut setSave(String[] setData, String[] setData1)
	{
		try
		{
			String user_id = info.getSession("ID");
			Logger.debug.println(user_id, this, "######setSave#######");

			int rtn = et_setSave(setData, setData1);

			Logger.debug.println("Insert Row ===>" + rtn);
			setValue("Insert Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch (Exception e)
		{
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
			Logger.err.println(this, e.getMessage());

			//log err
		}

		return getSepoaOut();
	}

	private int et_setSave(String[] setData, String[] setData1) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");

		try
		{
			ConnectionContext ctx = getConnectionContext();
			SepoaSQLManager sm = null;

			StringBuffer tSQL = new StringBuffer();

			tSQL.append("INSERT INTO splnt \n");
			tSQL.append("(                    \n");
			tSQL.append("	 COMPANY_CODE      \n");
			tSQL.append("	,PLANT_CODE        \n");
			//tSQL.append("	,STATUS            \n");
			tSQL.append("	,DEL_FLAG 		   \n");
			tSQL.append("	,PLANT_NAME_LOC    \n");
			tSQL.append("	,PLANT_NAME_ENG    \n");
			tSQL.append("	,COUNTRY           \n");
			tSQL.append("	,DEPT              \n");
			tSQL.append("	,LOGISTICS_AREA    \n");
			tSQL.append("	,IRS_NO            \n");
			tSQL.append("	,PR_LOCATION       \n");
			tSQL.append("	,INDUSTRY_TYPE     \n");
			tSQL.append("	,BUSINESS_TYPE     \n");
			tSQL.append("	,BIZ_NAME_LOC      \n");
			tSQL.append("	,BIZ_NAME_ENG      \n");
			tSQL.append("	,ATTACH_NO         \n");
			tSQL.append("	,ADD_DATE          \n");
			tSQL.append("	,ADD_TIME          \n");
			tSQL.append("	,ADD_USER_ID       \n");
			tSQL.append("	,CHANGE_DATE       \n");
			tSQL.append("	,CHANGE_TIME       \n");
			tSQL.append("	,CHANGE_USER_ID    \n");
			tSQL.append(")                    \n");
			tSQL.append("VALUES               \n");
			tSQL.append("(                    \n");
			tSQL.append("	 ?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,'N'               \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append(")                    \n");

			sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());

			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] type =
			{
				"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
				"S", "S", "S", "S", "S", "S", "S"
			};

			String[][] tmp = new String[1][];
			tmp[0] = setData;

			rtn = sm.doInsert(tmp, type);

			if (rtn == -1)
			{
				throw new Exception("SQL Manager is Null");
			}

			tSQL = new StringBuffer();

			tSQL.append("INSERT INTO icomaddr \n");
			tSQL.append("(                    \n");
			tSQL.append("	 CODE_NO           \n");
			tSQL.append("	,CODE_TYPE         \n");
			tSQL.append("	,ZIP_CODE          \n");
			tSQL.append("	,PHONE_NO1         \n");
			tSQL.append("	,FAX_NO            \n");
			tSQL.append("	,ADDRESS_LOC       \n");
			tSQL.append("	,ADDRESS_ENG       \n");
			tSQL.append("	,CEO_NAME_LOC      \n");
			tSQL.append(")                    \n");
			tSQL.append("VALUES               \n");
			tSQL.append("(                    \n");
			tSQL.append("	 ?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append("	,?                 \n");
			tSQL.append(")                    \n");

			sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());

			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] type1 = { "S", "S", "S", "S", "S", "S", "S", "S" };

			String[][] tmp1 = new String[1][];
			tmp[0] = setData1;

			rtn = sm.doInsert(tmp, type1);

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			throw new Exception("et_setSave:" + e.getMessage());
		}
		finally
		{
			//Release();
		}

		return rtn;
	}

	/********************************************************************************************************/
	/**************************공장 코드 생성시 기존에 있는거면 Update 한다.***********************************/
	/********************************************************************************************************/
	public SepoaOut setInsertUpdate(String[] setData)
	{
		String user_id = info.getSession("ID");

		try
		{
			Logger.debug.println(user_id, this, "######setUpdate#######");

			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();
			String status = "C";

			int rtn = et_setInsertUpdate(setData, status, cur_date, cur_time, user_id);

			Logger.debug.println(user_id, this, "Change Row ===>" + rtn);
			setValue("Change Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch (Exception e)
		{
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0002"));

			//log err
		}

		return getSepoaOut();
	}

	private int et_setInsertUpdate(String[] setData, String status, String cur_date, String cur_time, String user_id) throws Exception
	{
		int rtn = -1;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			StringBuffer tSQL = new StringBuffer();

			tSQL.append(" UPDATE  splnt  SET                              \n");
			tSQL.append("       NAME_LOC      = ?                            \n");
			tSQL.append("     , NAME_ENG      = ?                            \n");
			tSQL.append("     , ADDRESS_LOC   = ?                            \n");
			tSQL.append("     , ADDRESS_ENG   = ?                            \n");
			tSQL.append("     , COUNTRY       = ?                            \n");
			tSQL.append("     , LOGISTICS_AREA    = ?                        \n");
			tSQL.append("     , ZIP_CODE      = ?                            \n");
			tSQL.append("     , BIZ_NAME_LOC  = ?                            \n");
			tSQL.append("     , BIZ_NAME_ENG  = ?                            \n");
			tSQL.append("     , ATTACH_NO     = ?                            \n");
			tSQL.append("     , IRS_NO        = ?                            \n");
			tSQL.append("     , DEPT      = ?                                \n");
			tSQL.append("     , PR_LOCATION       = ?                        \n");
			//tSQL.append("     , STATUS                = '" + status + "'   \n");
			tSQL.append("     , DEL_FLAG = 'N'								 \n");
			tSQL.append("     , ADD_DATE              = '" + cur_date + "'   \n");
			tSQL.append("     , ADD_TIME              = '" + cur_time + "'   \n");
			tSQL.append("     , ADD_USER_ID           = ?                    \n");
			tSQL.append("     , ADD_USER_NAME_LOC     = ?                    \n");
			tSQL.append("     , ADD_USER_NAME_ENG     = ?                    \n");
			tSQL.append("     , ADD_USER_DEPT         = ?                    \n");
			tSQL.append("     , CHANGE_DATE           = '" + cur_date + "'   \n");
			tSQL.append("     , CHANGE_TIME           = '" + cur_time + "'   \n");
			tSQL.append("     , CHANGE_USER_ID        = ''                   \n");
			tSQL.append("     , CHANGE_USER_NAME_LOC  = ''                   \n");
			tSQL.append("     , CHANGE_USER_NAME_ENG  = ''                   \n");
			tSQL.append("     , CHANGE_USER_DEPT      = ''                   \n");
			tSQL.append("     , PHONE_NO              = ?                    \n");
			tSQL.append("     , FAX_NO                = ?                    \n");
			tSQL.append("     , CEO_NAME_LOC          = ?                    \n");
			tSQL.append("     , INDUSTRY_TYPE         = ?                    \n");
			tSQL.append("     , BUSINESS_TYPE         = ?                    \n");
			tSQL.append("     , OPEN_DATE             = ?                    \n");
			tSQL.append("     , SEAT_QTY              = ?                    \n");
			tSQL.append("     , SCREEN_QTY            = ?                    \n");
			tSQL.append("     , DIRECT_COMMISION_FLAG = ?					 \n");
			tSQL.append("     , ACCOUNT_AREA          = ?					 \n");
			tSQL.append(" WHERE  COMPANY_CODE   = ?                            \n");
			tSQL.append(" AND  PLANT_CODE     = ?                            \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());

			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] type =
			{
				"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
				"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
				"S", "S", "S"
			};
			String[][] tmp = new String[1][];
			tmp[0] = setData;

			rtn = sm.doUpdate(tmp, type);
			Commit();
		}
		catch (Exception e)
		{
			//Rollback();
			throw new Exception("et_setInsertUpdate:" + e.getMessage());
		}
		finally
		{
			//Release();
		}

		return rtn;
	}

	/**
	*Change시 변경데이타
	* NAME_LOC
	* NAME_ENG
	* ADDRESS_LOC
	* ADDRESS_ENG
	* COUNTRY
	* LOGISTICS_AREA
	* ZIP_CODE
	* IRS_NO
	* CHANGE_DATE
	* CHANGE_TIME
	* CHANGE_USER_ID
	* CHANGE_USER_NAME_LOC
	* CHANGE_USER_NAME_ENG
	* CHANGE_USER_DEPT
	*/
	public SepoaOut setChange(String[] setData, String[] setData1)
	{
		String user_id = info.getSession("ID");

		try
		{
			Logger.debug.println(user_id, this, "######setUpdate#######");

			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();
			String status = "R";

			int rtn = et_setChange(setData, setData1);

			Logger.debug.println(user_id, this, "Change Row ===>" + rtn);
			setValue("Change Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch (Exception e)
		{
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0002"));

			//log err
		}

		return getSepoaOut();
	}

	private int et_setChange(String[] setData, String[] setData1) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");

		try
		{
			ConnectionContext ctx = getConnectionContext();
			SepoaSQLManager sm = null;

			StringBuffer tSQL = new StringBuffer();

			tSQL.append(" UPDATE  splnt  SET                         \n");
			tSQL.append("       PLANT_NAME_LOC    = ?                   \n");
			tSQL.append("     , PLANT_NAME_ENG    = ?                   \n");
			tSQL.append("     , COUNTRY           = ?                   \n");
			tSQL.append("     , IRS_NO            = ?                   \n");
			tSQL.append("     , BIZ_NAME_LOC      = ?                   \n");
			tSQL.append("     , BIZ_NAME_ENG      = ?                   \n");
			tSQL.append("     , ATTACH_NO	      = ?                   \n");
			tSQL.append("     , DEPT              = ?                   \n");
			tSQL.append("     , PR_LOCATION       = ?                   \n");
			tSQL.append("     , INDUSTRY_TYPE     = ?                   \n");
			tSQL.append("     , BUSINESS_TYPE     = ?                   \n");
			tSQL.append("     , CHANGE_DATE       = ?                   \n");
			tSQL.append("     , CHANGE_TIME       = ?                   \n");
			tSQL.append("     , CHANGE_USER_ID    = ?                   \n");
			tSQL.append("     , DEL_FLAG   		 = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'				\n");
			//tSQL.append(" WHERE    HOUSE_CODE     = ?                   \n");
			tSQL.append(" WHERE COMPANY_CODE       = ?                   \n");
			tSQL.append(" AND  PLANT_CODE         = ?                   \n");
			//tSQL.append(" AND PR_LOCATION         = ?                   \n");

			sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());

			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] type =
			{
				"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
				"S", "S"
			};
			String[][] tmp = new String[1][];
			tmp[0] = setData;
			rtn = sm.doUpdate(tmp, type);

			if (rtn < 1)
			{
				throw new Exception("update error");
			}

			tSQL = new StringBuffer();

			tSQL.append(" UPDATE  icomaddr  SET                             \n");
			tSQL.append("       ADDRESS_LOC           = ?                   \n");
			tSQL.append("     , ADDRESS_ENG           = ?                   \n");
			tSQL.append("     , ZIP_CODE              = ?                   \n");
			tSQL.append("     , PHONE_NO1             = ?                   \n");
			tSQL.append("     , FAX_NO                = ?                   \n");
			tSQL.append("     , CEO_NAME_LOC          = ?                   \n");
//			tSQL.append(" WHERE  HOUSE_CODE           = ?                   \n");
			tSQL.append("   WHERE  CODE_NO              = ?                   \n");
			tSQL.append("   AND  CODE_TYPE            = ?                   \n");

			sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());

			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] type1 = { "S", "S", "S", "S", "S", "S", "S", "S" };
			String[][] tmp1 = new String[1][];
			setData1[3] = SepoaString.encString (setData1[3]   ,"PHONE");
            setData1[4] = SepoaString.encString (setData1[4]   ,"PHONE");
			tmp1[0] = setData1;
			rtn = sm.doUpdate(tmp1, type1);

//			if (rtn < 1)
//			{
//				throw new Exception("update error");
//			}

			Commit();
		}
		catch (Exception e)
		{
			//Rollback();
			throw new Exception("et_setSave:" + stackTrace(e));
		}
		finally
		{
			//Release();
		}

		return rtn;
	}

	/**
	*Delete시 변경데이타
	* STATUS = "D" //C:Create, R:Replace, D:Delete
	* CHANGE_DATE
	* CHANGE_TIME
	* CHANGE_USER_ID
	* CHANGE_USER_NAME_LOC
	* CHANGE_USER_NAME_ENG
	* CHANGE_USER_DEPT
	* 삭제 버튼시 실행되는 메소드
	* 변경: 2013/02 
	*/

	public SepoaOut setDelete(List< Map<String, String>>gridData) throws Exception
	{
		
		ConnectionContext ctx = getConnectionContext();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		String USER_ID = info.getSession("ID");
		String CHANGE_DATE=SepoaDate.getShortDateString();
		String CHANGE_TIME=SepoaDate.getShortTimeString();
		
		
		
		Map<String,String> grid = null;
		
		try
		{
					
			grid=(Map <String , String>) gridData.get(0);
			StringBuffer tSQL = new StringBuffer();

			tSQL.append(" UPDATE splnt        		   		 \n");
			tSQL.append("   SET DEL_FLAG = '" + sepoa.fw.util.CommonUtil.Flag.Yes.getValue() + "'    		 \n"); 
			tSQL.append(" , CHANGE_DATE    = ?    		 \n");ps.addStringParameter(CHANGE_DATE);
			tSQL.append(" , CHANGE_TIME    = ?     		 \n");ps.addStringParameter(CHANGE_TIME);
			tSQL.append(" , CHANGE_USER_ID = ?   		 \n");ps.addStringParameter(USER_ID);
			//tSQL.append(" WHERE HOUSE_CODE = ?     \n");
			tSQL.append(" WHERE COMPANY_CODE = ?   \n");ps.addStringParameter(MapUtils.getString( grid, "COMPANY_CODE", "" ));	
            tSQL.append(" AND PLANT_CODE   = ?   		 \n");ps.addStringParameter(MapUtils.getString( grid, "PLANT_CODE", "" ));
            if(!"".equals(MapUtils.getString( grid, "PR_LOCATION", "" ))){
            	tSQL.append(" AND PR_LOCATION  = ?   		 \n");ps.addStringParameter(MapUtils.getString( grid, "PR_LOCATION", "" ));
            }

			//SepoaSQLManager sm = new SepoaSQLManager(USER_ID, this, ctx, tSQL.toString());

			//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
			//String[] type = { "S", "S", "S", "S", "S", "S", "S" };

			ps.doUpdate(tSQL.toString());

    		setFlag(true);
    		setMessage(msg.getMessage("0001"));
    		
    		setStatus(1);
    		Commit();
    	} 
    	catch (Exception e)
    	{
    		setStatus(0);
    		setFlag(false);
    		setMessage(e.getMessage());
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    		
//    		e.printStackTrace(System.out);
			
//			e.getCause().printStackTrace(System.out);
    	}
    	
    	return getSepoaOut();
	}

	/**
	*Display
	*/
	public SepoaOut getDisplay(String[] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			Logger.debug.println(user_id, this, "######getDisplay#######");

			String rtn = "";
			rtn = et_getDisplay(args, user_id);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch (Exception e)
		{
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_getDisplay(String[] args, String user_id) throws Exception
	{
		String rtn = "";

		try
		{
			ConnectionContext ctx = getConnectionContext();

            StringBuffer sql = new StringBuffer();
			sql.append(" SELECT                                 \n");
			sql.append("       PLANT_CODE                       \n");
			sql.append("     , PLANT_NAME_LOC                   \n");
			sql.append("     , PLANT_NAME_ENG                   \n");
			sql.append("     , ADDRESS_LOC                      \n");
			sql.append("     , ADDRESS_ENG                      \n");
			sql.append("     , COUNTRY                          \n");
			//sql.append("     , COUNTRY_NAME                     \n");
			sql.append( "  , " + SEPOA_DB_OWNER + "getcodetext2('M001',COUNTRY, '" + info.getSession("LANGUAGE") + "' ) COUNTRY_NAME  \n");
			sql.append("     , LOGISTICS_AREA                   \n");
			//sql.append("     , LOGISTICS_AREA_NAME              \n");
			sql.append( "  , " + SEPOA_DB_OWNER + "getcodetext2('M088',LOGISTICS_AREA, '" + info.getSession("LANGUAGE") + "' ) LOGISTICS_AREA_NAME  \n");
			sql.append("     , ZIP_CODE                         \n");
			sql.append("     , IRS_NO                           \n");
			sql.append("     , BIZ_NAME_LOC                     \n");
			sql.append("     , BIZ_NAME_ENG                     \n");
			sql.append("     , DEPT                             \n");
			sql.append("     , DEPT_NAME                        \n");
			sql.append("     , PR_LOCATION                      \n");
			//sql.append("     , PR_LOCATION_NAME                 \n");
			sql.append( "  , " + SEPOA_DB_OWNER + "getcodetext2('M062',PR_LOCATION, '" + info.getSession("LANGUAGE") + "' ) PR_LOCATION_NAME  \n");
			sql.append("     , PHONE_NO                         \n");
			sql.append("     , FAX_NO                           \n");
			sql.append("     , CEO_NAME_LOC                     \n");
			sql.append("     , INDUSTRY_TYPE                    \n");
			sql.append("     , BUSINESS_TYPE                    \n");
			sql.append("     , ATTACH_NO \n ");
			sql.append("     , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = PLANT_GENERAL_VW.ATTACH_NO) ATTACH_COUNT ");
			sql.append(" FROM  PLANT_GENERAL_VW                 \n");
			//sql.append(" <OPT=F,S> WHERE HOUSE_CODE  = ? </OPT> \n");
			sql.append(" <OPT=F,S> WHERE COMPANY_CODE  = ? </OPT> \n");
			sql.append(" <OPT=F,S> AND PLANT_CODE    = ? </OPT> \n");
			sql.append(" <OPT=S,S> AND PR_LOCATION   = ? </OPT> \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			rtn = sm.doSelect(args);

			if (rtn == null)
			{
				throw new Exception("SQL Manager is Null");
			}

            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M001", "M062", "M088" );
		}
		catch (Exception e)
		{
			throw new Exception("et_getMainternace:" + e.getMessage());
		}
		finally
		{
			//Release();
		}

		return rtn;
	}

	/* 중복체크 */
	public SepoaOut getDuplicate(String[] args)
	{
		String user_id = info.getSession("ID");
		String rtn = null;

		try
		{
			Logger.debug.println(user_id, this, "######getDuplicate#######");
			// Isvalue(); ....
			rtn = Check_Duplicate(args, user_id);

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

			tSQL.append(" SELECT " + DB_NULL_FUNCTION +"(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') ");
			tSQL.append(" FROM splnt ");
			tSQL.append(" <OPT=F,S> WHERE COMPANY_CODE = ? </OPT> ");
			tSQL.append(" <OPT=F,S> AND PLANT_CODE = ? </OPT> ");
			//tSQL.append(" <OPT=F,S> AND PR_LOCATION = ? </OPT> ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());

			//String[] args = {house_code, company_code,PLANT_CODE};
			rtn = sm.doSelect(args);

			SepoaFormater wf = new SepoaFormater(rtn);

			if (wf.getRowCount() == 0)
			{
				count = "X";
			}
			else
			{
				str = wf.getValue();
				count = str[0][0];
			}

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
