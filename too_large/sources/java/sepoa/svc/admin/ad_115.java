package sepoa.svc.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.DBOpenException;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DBUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;

public class AD_115 extends SepoaService
{
	private String ID = info.getSession("ID");
	//Message msg = new Message("STDCOMM"); // message 처리를 위해 전역변수 선언
	Message msg = null;

	public AD_115(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		msg = new Message(info, "STDCOMM"); // message 처리를 위해 전역변수 선언
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
	* MESSAGE 를 MAP 으로 받아 반환해 준다.
	* @param info
	* @return
	* @throws Exception
	*/
	public HashMap getMessageMap( SepoaInfo info ) throws Exception {
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	return MessageUtil.getMessage(info, multilang_id);
	} // end of method getMessageMap
	
	/**
	 * 직무코드 조회 메소드
	*  getMaintain
	*  수정일 : 2013/02
	*/
	public SepoaOut getMaintain(Map< String, String > header) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
	    HashMap mapMessage = getMessageMap( info );

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sb.append(" SELECT           \n ");
			sb.append(" " + SEPOA_DB_OWNER + "GETCODETEXT2('M080', CTRL_TYPE, '" + info.getSession("LANGUAGE") + "') AS  CTRL_TYPE_NAME, \n ");
			sb.append(" CTRL_CODE,       \n ");
			sb.append(" CTRL_NAME_LOC,    \n");
			sb.append(" CTRL_NAME_ENG,    \n");
			sb.append(" " + SEPOA_DB_OWNER + "GETUSERNAME('000', icombaco.ADD_USER_ID, 'LOC') AS ADD_USER_NAME_LOC,        \n ");
			sb.append(" " + SEPOA_DB_OWNER + "GETUSERNAME('000', icombaco.CHANGE_USER_ID, 'LOC') AS CHANGE_USER_NAME_LOC,  \n ");
			sb.append(" CTRL_TYPE        \n ");
			sb.append(" FROM ICOMBACO       \n ");
			sb.append(" WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'  \n ");
			sb.append(" <OPT=S,S> AND CTRL_TYPE = ? </OPT>                   \n ");sm.addStringParameter(MapUtils.getString(header, "i_ctrl_type", ""));
			sb.append(" <OPT=F,S> AND COMPANY_CODE = ? </OPT>                \n ");sm.addStringParameter(MapUtils.getString(header, "i_company_code", ""));
			
			if (getConfig("sepoa.db.vendor").equals("MYSQL"))
			{
				sb.append(" <OPT=S,S> AND CTRL_CODE LIKE UPPER(CONCAT('%' ,? , '%')) </OPT>     \n ");
				sm.addStringParameter(MapUtils.getString(header, "i_ctrl_code", ""));
			}
			else if (getConfig("sepoa.db.vendor").equals("ORACLE"))
			{
				sb.append(" <OPT=S,S> AND CTRL_CODE LIKE '%'" + DBUtil.getAndSeparator() + "?" + DBUtil.getAndSeparator() + "'%' </OPT>                      \n");
				sm.addStringParameter(MapUtils.getString(header, "i_ctrl_code", ""));
			}
			else if (getConfig("sepoa.db.vendor").equals("MSSQL"))
			{
				sb.append(" <OPT=S,S> AND CTRL_CODE LIKE '%' + ? + '%' </OPT>                    \n");
				sm.addStringParameter(MapUtils.getString(header, "i_ctrl_code", ""));
			}else if (getConfig("sepoa.db.vendor").equals("SYBASE"))
			{
				sb.append(" <OPT=S,S> AND CTRL_CODE LIKE '%' + ? + '%' </OPT>                    \n");
				sm.addStringParameter(MapUtils.getString(header, "i_ctrl_code", ""));
			}
			
			rtn[0] = sm.doSelect(sb.toString());
			setValue(rtn[0]);//SepoaOut객체에 쿼리 결과값을 셋팅한다.

            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M080" );
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return getSepoaOut();
	} // getMaintain() end

	private String SR_getCod2(String pType) throws Exception
	{
		String rtn = "";

		try
		{
			ConnectionContext ctx = getConnectionContext();
			String houseCode = info.getSession("HOUSE_CODE");
			String companyCode = info.getSession("COMPANY_CODE");

			StringBuffer sql = new StringBuffer();
			sql.append(" select code, ISNULL( text2, ' ' )                \n ");
			sql.append(" from scode                                 \n ");
			sql.append(" where house_code = '" + houseCode + "'        \n ");
			sql.append("   and type = '" + pType + "'                  \n ");
			sql.append("   and status in ( 'C', 'R' )                  \n ");
			sql.append("   and use_flag = 'Y'                          \n ");
			sql.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
			sql.append(" order by sort_seq, code                       \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sql.toString());
			rtn = sm.doSelect();

			if (rtn == null)
			{
				throw new Exception("SQL Manager is Null");
			}
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
			throw new Exception("SR_getCod2 : " + e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} // end of SR_getCod2

	/**
	 * 직무코드 등록 메소드
	*  setInsert
	*  수정일 : 2013/02
	*/
	public SepoaOut setInsert(List< Map<String, String>>gridData , Map< String, String > header) throws Exception, DBOpenException
	{

		ConnectionContext ctx = getConnectionContext();
		String user_id = info.getSession("ID");
		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		StringBuffer sb = new StringBuffer();
		Map<String,String> grid = null;
		String[] rtn = new String[2];

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < gridData.size(); i++)
			{
				grid=(Map <String , String>) gridData.get(i);

				SepoaOut et = et_confirmBACO(grid,header);
				
	            sm.removeAllValue();
	            sb.delete( 0, sb.length());

				sb.append(" INSERT INTO ICOMBACO             \n");
				sb.append(" (                             \n");
				sb.append(" 	  COMPANY_CODE            \n");
				sb.append(" 	, HOUSE_CODE	          \n");
				sb.append(" 	, CTRL_TYPE               \n");
				sb.append(" 	, CTRL_CODE               \n");
				sb.append(" 	, CTRL_NAME_LOC           \n");
				sb.append(" 	, CTRL_NAME_ENG           \n");
				sb.append(" 	, ADD_USER_ID             \n");
				sb.append(" 	, CHANGE_USER_ID          \n");
				//tSQL.append(" 	, STATUS              \n");
				sb.append(" 	, ADD_DATE                \n");
				sb.append(" 	, ADD_TIME                \n");
				sb.append(" 	, CHANGE_DATE             \n");
				sb.append(" 	, CHANGE_TIME             \n");
				sb.append(" )                             \n");
				sb.append(" VALUES                        \n");
				sb.append(" (                             \n");
				sb.append(" 	  ?                       \n");sm.addStringParameter(MapUtils.getString(header, "i_company_code", ""));
				sb.append(" 	, ?                       \n");sm.addStringParameter(info.getSession("HOUSE_CODE"));
				sb.append(" 	, ?                       \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_TYPE", ""));
				sb.append(" 	, ?                       \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_CODE", ""));
				sb.append(" 	, ?                       \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_NAME_LOC", ""));
				sb.append(" 	, ?                       \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_NAME_ENG", ""));
				sb.append(" 	, ?                  	  \n");sm.addStringParameter(user_id);
				sb.append(" 	, ?               		  \n");sm.addStringParameter(user_id);
				sb.append(" 	, ?                  	  \n");sm.addStringParameter(add_date);
				sb.append(" 	, ?                		  \n");sm.addStringParameter(add_time);
				sb.append(" 	, ?                 	  \n");sm.addStringParameter(add_date);
				sb.append(" 	, ?                   	  \n");sm.addStringParameter(add_time);
				sb.append(" )                             \n");

				sm.doInsert(sb.toString());
			} // FOR end

				Commit();
			 
			}catch (Exception e)
			{
				Rollback();
				rtn[1] = e.getMessage();
				
				Logger.debug.println(ID, this, e.getMessage());
			}
			finally
			{
			}

			return getSepoaOut();
	}//setInsert() end

	/**
	 * 직무코드 등록 전 중복방지를 위해 조회 
	*  et_confirmBACO
	*  수정일 : 2013/02
	*/

	public SepoaOut et_confirmBACO(Map<String, String> grid , Map< String, String > header) throws Exception
	{
		String[] rtn = new String[2];
		String result = null;
		StringBuffer sb = new StringBuffer();
		
		try
		{
			ConnectionContext ctx = getConnectionContext();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			String user_id = info.getSession("ID");
			

			StringBuffer sql = new StringBuffer();
			sb.append(" SELECT COUNT(*)                                      \n");
			sb.append(" FROM sbagl                         		             \n");
			sb.append(" WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'  \n");
			sb.append(" <OPT=F,S> AND COMPANY_CODE = ? </OPT>                \n");sm.addStringParameter(MapUtils.getString(header, "i_company_code", ""));
			sb.append(" <OPT=F,S> AND CTRL_TYPE = ? </OPT>                   \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_TYPE", ""));
			sb.append(" <OPT=F,S> AND CTRL_CODE = ? </OPT>                   \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_CODE", ""));

			rtn[0] = sm.doSelect(sb.toString());
			setValue(rtn[0]);//SepoaOut객체에 쿼리 결과값을 셋팅한다.
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return getSepoaOut();
	} // et_confirmBACO() end
	
	/*삭제하기 전에 담당자가 연결되어져 있는지를 조사한다. */
	public SepoaOut getCount(String[] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");

			String rtn = null;
			rtn = et_getCount(user_id, args, house_code);
			setValue(rtn);
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

	public String et_getCount(String user_id, String[] args, String house_code) throws Exception
	{
		String result = null;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			StringBuffer sql = new StringBuffer();
			sql.append(" SELECT COUNT(*) AS CNT FROM SBALN_DELETED  \n ");
			//sql.append(" WHERE HOUSE_CODE = '" + house_code + "'  \n ");
			sql.append(" WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, 'N') = 'N' \n ");
			sql.append(" <OPT=F,S> AND COMPANY_CODE = ? </OPT> \n ");
			sql.append(" <OPT=F,S> AND CTRL_TYPE = ? </OPT>    \n ");
			sql.append(" <OPT=F,S> AND CTRL_CODE = ? </OPT>    \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			result = sm.doSelect(args);

			if (result == null)
			{
				throw new Exception("SQLManager is null");
			}
		}
		catch (Exception ex)
		{
			throw new Exception("et_getCount()" + ex.getMessage());
		}

		return result;
	}

	/**
	    * 직무코드 삭제 
	    *  setDelete
	    *  수정일 : 2013/02
	    */
		public SepoaOut setDelete(List< Map<String, String>>gridData , Map< String, String > header) throws Exception, DBOpenException
		{
			
		    
		    int result = -1;
		    String user_id = info.getSession("ID");        
	        String status = "D"; //삭제된 field 의 status는 "D"이다.
	        String change_date = SepoaDate.getShortDateString();
	        String change_time = SepoaDate.getShortTimeString();
	        String[] rtn = new String[2];
	        ConnectionContext ctx = getConnectionContext();
	        Map<String,String> grid = null;

			try
			{
			    grid=(Map <String , String>) gridData.get(0);
	            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	            StringBuffer tSQL = new StringBuffer();


				for (int i = 0; i < gridData.size(); i++)
				{
				    grid=(Map <String , String>) gridData.get(i);
				

			    sm.removeAllValue();
			    tSQL.delete( 0, tSQL.length());
	            
				tSQL.append("    DELETE FROM ICOMBACO           \n");
				tSQL.append("    WHERE COMPANY_CODE = ?      \n");sm.addStringParameter(MapUtils.getString(header, "i_company_code", ""));
				tSQL.append("    AND CTRL_TYPE    = ?        \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_TYPE", ""));
				tSQL.append("    AND CTRL_CODE    = ?        \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_CODE", ""));

				
				sm.doDelete( tSQL.toString());
				}// for end
				
				Commit();
			}
			catch (Exception e)
			{
				Logger.err.println(info.getSession("ID"), this, "Exception=" + e.getMessage());
				throw new Exception("et_setDelete:" + e.getMessage());
				
			}

			return getSepoaOut();
		}

    /**
    * 직무코드 수정 
    *  setUpdate
    *  수정일 : 2013/02
    */
	public SepoaOut setUpdate(List< Map<String, String>>gridData , Map< String, String > header)
	{
		int rtn = -1;

		try
		{
			rtn = et_setUpdate(gridData , header);
			setValue("Change_Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
			Commit();
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception= " + e.getMessage());

			try
			{
				Rollback();
			}
			catch (Exception d)
			{
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			setStatus(0);
			setMessage(msg.getMessage("0002")); /* Message를 등록한다. */
		}

		return getSepoaOut();
	}

	private int et_setUpdate(List< Map<String, String>>gridData , Map< String, String > header) throws Exception, DBOpenException
	{

		int result = -1;
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		Map<String,String> grid = null;

		try
		{
			grid=(Map <String , String>) gridData.get(0);
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			String user_id = info.getSession("ID");
			String change_date = SepoaDate.getShortDateString();
			String change_time = SepoaDate.getShortTimeString();
			
			for(int i=0;  i < gridData.size(); i++ ){
				grid=(Map <String , String>) gridData.get(i);

			StringBuffer tSQL = new StringBuffer();
			
			
			sm.removeAllValue();
			tSQL.delete( 0, tSQL.length());

			tSQL.append(" UPDATE ICOMBACO                           \n");
			tSQL.append(" SET      DEL_FLAG = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'     			 \n");
			tSQL.append("         ,CHANGE_DATE     = ? 	 	     \n");sm.addStringParameter(change_date);
			tSQL.append("         ,CHANGE_TIME     = ?  		 \n");sm.addStringParameter(change_time);
			tSQL.append("         ,CTRL_NAME_LOC   = ?           \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_NAME_LOC", ""));
			tSQL.append("         ,CTRL_NAME_ENG   = ?           \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_NAME_ENG", ""));
			tSQL.append("         ,CHANGE_USER_ID  = ?           \n");sm.addStringParameter(user_id);
			tSQL.append(" WHERE COMPANY_CODE       = ?           \n");sm.addStringParameter(MapUtils.getString(header, "i_company_code", ""));
			//tSQL.append("   AND CTRL_TYPE        = ?           \n");sm.addStringParameter("R");
			tSQL.append("   AND CTRL_CODE          = ?           \n");sm.addStringParameter(MapUtils.getString(grid, "CTRL_CODE", ""));

			result=sm.doUpdate(tSQL.toString());
			
			
			 if(result == -1) throw new Exception("SQL Manager is Null");
             else Commit();

			} // FOR end
		}
		catch (Exception e)
		{
			throw new Exception("et_setUpdate: " + e.getMessage());
		}

		return result;
	}

	/**************************************************************************************************/
	/*********************************           직무담당자           *********************************/
	/*************************************************************************************************/

    /**
    *  직무담당자 조회 
    *  getMaintain1
    *  수정일 : 2013/02
    */


	public SepoaOut getMaintain1(Map<String , String > header) throws Exception
	{
		String result = null;
		String[] rtn = new String[2];

		try
		{
			ConnectionContext ctx = getConnectionContext();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			StringBuffer sql = new StringBuffer();
			sql.append("      SELECT																		                    \n");
			sql.append("	" + SEPOA_DB_OWNER + "GETCODETEXT2('M080',CTRL_TYPE, '" + info.getSession("LANGUAGE") + "') AS CTRL_TYPE_NAME	\n");
			sql.append("    , CTRL_CODE																                            \n");
			sql.append("    , " + SEPOA_DB_OWNER + "GETCTRLCODENAME('000',COMPANY_CODE,CTRL_TYPE,CTRL_CODE) AS CTRL_CODE_NAME	        \n");
			sql.append("    , CTRL_PERSON_ID														                            \n");
			sql.append("    , " + SEPOA_DB_OWNER + "GETUSERNAME('000', CTRL_PERSON_ID, 'LOC') AS CTRL_PERSON_NAME_LOC			        \n");
			sql.append("    , " + SEPOA_DB_OWNER + "GETADDRATTR2(CTRL_PERSON_ID, '3', 'PHONE_NO1') AS PHONE_NO				    \n");
			sql.append("    , COMPANY_CODE															                            \n");
			sql.append("    , CTRL_TYPE																                            \n");
			//sql.append("    , PLANT_CODE																                        \n");
			sql.append("    , DEL_FLAG																                            \n");
			//sql.append("    , PURCHASE_PART_TXT																                    \n");
			sql.append("      FROM ICOMBACP									\n");
			sql.append("      WHERE    1 = 1								\n");
			sql.append(sm.addFixString   (" 	AND COMPANY_CODE   = ?     	\n"));sm.addStringParameter( MapUtils.getString( header, "i_company_code", "" )); // 회사코드
			sql.append(sm.addSelectString(" AND CTRL_CODE      = ?     		\n"));sm.addStringParameter( MapUtils.getString( header, "i_ctrl_code", ""    )); // 직무코드
			sql.append(sm.addSelectString(" AND CTRL_TYPE      = ?     		\n"));sm.addStringParameter( MapUtils.getString( header, "i_ctrl_type", ""    )); // 직무형태			
			sql.append(" ORDER BY COMPANY_CODE, CTRL_CODE, CTRL_TYPE, CTRL_PERSON_ID, CTRL_PERSON_NAME_LOC DESC		\n");
			
			rtn[0] = sm.doSelect(sql.toString());
            setValue(rtn[0]);
            
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M080" );
		}
		catch (Exception ex)
		{
			throw new Exception("getMaintain1()" + ex.getMessage());
		}
		finally
		{
		}

		return getSepoaOut();
	}

    /**
    *  사용자 조회
    *  직무담당자 페이지 셀선택후 팝업창 
    *  getUserInfo
    *  수정일 : 2013/02
    */
	public SepoaOut getUserInfo(Map <String , String > header) throws Exception
	{
		//String result = null;
		String[] rtn = new String[2];

		try
		{
			ConnectionContext ctx = getConnectionContext();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			StringBuffer sql = new StringBuffer();
			sql.append("    SELECT COMPANY_CODE, USER_NAME_LOC, USER_ID,                                                         \n");
			sql.append("    (case when (" + SEPOA_DB_OWNER + "CNV_NULL(USER_TYPE,'NULL') = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "')                                  \n");
			sql.append("	then " + SEPOA_DB_OWNER + "getcodetext2('M106', POSITION, '" + info.getSession("LANGUAGE") + "')     \n");
			sql.append("    else " + SEPOA_DB_OWNER + "getcodetext2('M106',POSITION, '" + info.getSession("LANGUAGE") + "')      \n");
			sql.append("    end) AS POSITION,                                                                                    \n");
			sql.append("    DEPT,                                                                                                \n");
			//sql.append("  DEPT_NAME_LOC,                                                                                       \n");
			sql.append("    (case when (USER_TYPE in ('" + sepoa.svc.common.constants.UserType.Seller.getValue() + "', '" + sepoa.svc.common.constants.UserType.Partner.getValue() + "'))                                                                  \n");
			sql.append("    then " + SEPOA_DB_OWNER + "getcodetext2('M105', DEPT, '" + info.getSession("LANGUAGE") + "')         \n");
			sql.append("    else DEPT_NAME_LOC end) AS DEPT_NAME_LOC,                                                            \n");
			sql.append("    PHONE_NO                                                                                             \n");
			sql.append("    FROM USER_LIST_VW                                                                                    \n");
			sql.append("    WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                                                  \n");
//			sql.append(sm.addSelectString("    AND COMPANY_CODE  = ?               \n"));sm.addStringParameter( MapUtils.getString( header, "i_company_code", "" ));
			sql.append(sm.addSelectString("    AND UPPER(USER_ID)       = UPPER(?)               \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_id", "" ));
			
			if (getConfig("sepoa.db.vendor").equals("MYSQL"))
			{
				sql.append(sm.addSelectString(" AND USER_NAME_LOC LIKE UPPER(CONCAT('%' , ? , '%')) \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
			}
			else if (getConfig("sepoa.db.vendor").equals("ORACLE"))
			{
				sql.append(sm.addSelectString(" AND USER_NAME_LOC LIKE UPPER('%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%')       \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
			}
			else if (getConfig("sepoa.db.vendor").equals("SYBASE"))
			{
				sql.append(sm.addSelectString(" AND USER_NAME_LOC LIKE '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%'		       \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
			}
            else if (getConfig("sepoa.db.vendor").equals("MSSQL"))
            {
                sql.append(sm.addSelectString(" AND USER_NAME_LOC LIKE '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%'             \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
            }
			    sql.append("     <OPT=S,S>AND DEPT = ?  </OPT>                                      \n");sm.addStringParameter( MapUtils.getString( header, "i_dept", "" ) );
			
			rtn[0]=sm.doSelect(sql.toString());
			setValue(rtn[0]);

            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M105", "M106" );
		}
		catch (Exception ex)
		{
			throw new Exception("getUserInfo()==" + ex.getMessage());
		}

		return getSepoaOut();
	}

    /**
     * 직무코드 삭제 메소드
    *  setDelete1
    *  수정일 : 2013/02
    */
	public SepoaOut setDelete1(List<Map<String , String >>gridData) throws Exception
	{
		String [] rtn = new String[2];   
        String status = "D"; /*삭제된 field 의 status는 "D"이다.*/
        Map<String,String> grid = null;

		try
		{

			ConnectionContext ctx = getConnectionContext();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();
			
			for (int i=0; i < gridData.size(); i++){
			    
			    grid=(Map <String , String>) gridData.get(i);
			
			sm.removeAllValue();
			tSQL.delete( 0, tSQL.length());			

			tSQL.append(" DELETE FROM ICOMBACP               \n");
			tSQL.append(" WHERE COMPANY_CODE	= ?       \n");sm.addStringParameter( MapUtils.getString( grid, "COMPANY_CODE", "" ));
			tSQL.append("   AND CTRL_TYPE		= ?       \n");sm.addStringParameter( MapUtils.getString( grid, "CTRL_TYPE", "" ));
			tSQL.append("   AND CTRL_CODE		= ?       \n");sm.addStringParameter( MapUtils.getString( grid, "CTRL_CODE", "" ));
			tSQL.append("   AND CTRL_PERSON_ID	= ?       \n");sm.addStringParameter( MapUtils.getString( grid, "CTRL_PERSON_ID", "" ));

			 sm.doDelete( tSQL.toString());
			
			}
			Commit();
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "et_setDelete1=" + e.getMessage());
			throw new Exception("et_setDelete1:" + e.getMessage());
			
           
		}

		return getSepoaOut();
	}

    /**    
    *  직무 담당자 등록 
    *  setInsert1
    *  수정일 : 2013/02
     * @throws Exception 
    */
	public SepoaOut setInsert1(List< Map<String, String>>gridData , Map< String, String > header) throws Exception
	{
		int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        Map<String,String> grid = null;
        HashMap mapMessage = getMessageMap( info );
     

		try
		{	  
			

			for (int i = 0; i < gridData.size(); i++)
			{

			    grid=(Map <String , String>) gridData.get(i);
			    // 등록전 등록여부 조회
//			    int rtn_chk = chkBACPCnt(grid);
               
//                if (rtn_chk > 0)
//                {
//                    Rollback();
//                    setMessage(mapMessage.get( "MESSAGE.5016" ).toString());
//                    setStatus(0);
//
//                    return getSepoaOut();
//                }
			    
			    
			    /**
			     * 존재하면 update
			     * 존재하지 않으면 insert
			     */
			    int rtn_chk = chkBACPCnt(grid);
			}

//			grid=(Map <String , String>) gridData.get(0);
//			rtn = et_setInsert1(gridData);
//			setValue("insertRow ==  " + rtn);
			setStatus(1);
		    setMessage( mapMessage.get( "MESSAGE.0001" ).toString() );    //성공적으로 작업을 수행했습니다 

			Commit();
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception= " + e.getMessage());

			try
			{
				Rollback();
			}
			catch (Exception d)
			{
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}

			setStatus(0);
		    setMessage( mapMessage.get( "MESSAGE.1002" ).toString() );
		}

		return getSepoaOut();
	}

    /**    
    *  직무 담당자 등록 
    *  et_setInsert1
    *  수정일 : 2013/02
    */
	private int et_setInsert1(List< Map<String, String>>gridData) throws Exception, DBOpenException
	{
		int result = 0;
        String user_id = info.getSession("ID");
        String add_date = SepoaDate.getShortDateString();
        String add_time = SepoaDate.getShortTimeString();
        String status = "C"; /* 새로 생성된 것의 status는 "C"이다.*/

		try
		{
			
			ConnectionContext ctx = getConnectionContext();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();
	        Map<String,String> grid = null;
	        
            for (int i = 0; i < gridData.size(); i++)
            {
                grid=(Map <String , String>) gridData.get(i);

                sm.removeAllValue();
                tSQL.delete( 0, tSQL.length());
    			tSQL.append(" INSERT INTO ICOMBACP            	      \n");
    			tSQL.append(" (                                   \n");
    			tSQL.append(" 	  COMPANY_CODE                    \n");  // 회사코드
    			tSQL.append(" 	, HOUSE_CODE                      \n");  // 회사코드
    			tSQL.append(" 	, CTRL_CODE                       \n");  // 직무코드
    			tSQL.append(" 	, CTRL_TYPE                       \n");  // 직무형태
    			tSQL.append(" 	, CTRL_PERSON_ID                  \n");  // 직무담당자
    			//tSQL.append(" 	, PLANT_CODE                  	  \n");  // 사업장코드
    			//tSQL.append(" 	, PURCHASE_PART_TXT               \n");  // 담당분야
    			tSQL.append(" 	, DEL_FLAG                  	  \n");  // 삭제여부
    			tSQL.append(" 	, ADD_USER_ID                     \n");
    			tSQL.append(" 	, ADD_DATE                        \n");
    			tSQL.append(" 	, ADD_TIME                        \n");
    			tSQL.append(" 	, CHANGE_USER_ID                  \n");
    			tSQL.append(" 	, CHANGE_DATE                     \n");
    			tSQL.append(" 	, CHANGE_TIME                     \n");
    			tSQL.append(" )                                   \n");
    			tSQL.append(" VALUES                              \n");
    			tSQL.append(" (                                   \n");
    			tSQL.append(" 	  ?								  \n");sm.addStringParameter(MapUtils.getString( grid, "COMPANY_CODE", "" ));
    			tSQL.append(" 	, ?               			      \n");sm.addStringParameter(info.getSession("HOUSE_CODE"));
    			tSQL.append(" 	, ?                				  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_CODE", "" ));
    			tSQL.append(" 	, ?             				  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_TYPE", "" ));
    			tSQL.append(" 	, ?                				  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_PERSON_ID", "" ));
    			//tSQL.append(" 	, ?     		                  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_CODE", "" ).substring(1));
    			//tSQL.append(" 	, ?     		                  \n");sm.addStringParameter(MapUtils.getString( grid, "PURCHASE_PART_TXT", "" ));
    			tSQL.append(" 	, ?     		                  \n");sm.addStringParameter(sepoa.fw.util.CommonUtil.Flag.No.getValue());
    			tSQL.append(" 	, ?     		                  \n");sm.addStringParameter(user_id);
    			tSQL.append(" 	, ?   			                  \n");sm.addStringParameter(add_date);
    			tSQL.append(" 	, ?    		                      \n");sm.addStringParameter(add_time);
    			tSQL.append(" 	, ?    			                  \n");sm.addStringParameter(user_id);
    			tSQL.append(" 	, ?   			                  \n");sm.addStringParameter(add_date);
    			tSQL.append(" 	, ?   			                  \n");sm.addStringParameter(user_id);
    			tSQL.append(" )                                   \n");
    
    			sm.doInsert( tSQL.toString());
    			result++;
            }
		}
		catch (Exception e)
		{
			throw new Exception("et_setInsert: " + e.getMessage());
		}

		return result;
	}

    /**    
    *  직무 담당자 등록 전 조회 
    *  chkBACPCnt
    *  수정일 : 2013/02
    */
	public int chkBACPCnt(Map < String , String > grid) throws Exception
	{
		int result = -1;

		try
		{
			String user_id = info.getSession("ID");
			
			ConnectionContext ctx = getConnectionContext();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer sql = new StringBuffer();

			sql.append(" SELECT  COUNT(*) AS cnt  FROM ICOMBACP                            \n");
			sql.append(" WHERE  " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'    \n");
			sql.append(sm.addFixString("     AND  COMPANY_CODE   =  ?    \n"));sm.addStringParameter( MapUtils.getString( grid, "COMPANY_CODE", "" ));
			sql.append(sm.addFixString("     AND  CTRL_CODE      =  ?    \n"));sm.addStringParameter( MapUtils.getString( grid, "CTRL_CODE", "" ));
			sql.append(sm.addFixString("     AND  CTRL_TYPE      =  ?    \n"));sm.addStringParameter( MapUtils.getString( grid, "CTRL_TYPE", "" ));
			sql.append(sm.addFixString("     AND  CTRL_PERSON_ID =  ?    \n"));sm.addStringParameter( MapUtils.getString( grid, "CTRL_PERSON_ID", "" ));


			String rtn = sm.doSelect(sql.toString());

			if (rtn == null)
			{
				throw new Exception("SQLManager is null");
			}
			SepoaFormater wf = new SepoaFormater(rtn);
			//result = Integer.parseInt(wf.getValue(0, 0));
			
			if(Integer.parseInt(wf.getValue("cnt", 0)) > 0){
				//update
				sm.removeAllValue();
                sql.delete( 0, sql.length());
    			sql.append(" UPDATE ICOMBACP SET					\n");
    			//sql.append("      PURCHASE_PART_TXT = ?         \n");sm.addStringParameter(MapUtils.getString( grid, "PURCHASE_PART_TXT", "" ));
    			sql.append(" WHERE  " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'    \n");
    			sql.append("     AND  COMPANY_CODE   =  ?    \n");sm.addStringParameter( MapUtils.getString( grid, "COMPANY_CODE", "" ));
    			sql.append("     AND  CTRL_CODE      =  ?    \n");sm.addStringParameter( MapUtils.getString( grid, "CTRL_CODE", "" ));
    			sql.append("     AND  CTRL_TYPE      =  ?    \n");sm.addStringParameter( MapUtils.getString( grid, "CTRL_TYPE", "" ));
    			sql.append("     AND  CTRL_PERSON_ID =  ?    \n");sm.addStringParameter( MapUtils.getString( grid, "CTRL_PERSON_ID", "" ));
    			sm.doUpdate( sql.toString());
    			
			}else{
				//insertl
                sm.removeAllValue();
                sql.delete( 0, sql.length());
    			sql.append(" INSERT INTO ICOMBACP            	      \n");
    			sql.append(" (                                   \n");
    			sql.append(" 	  COMPANY_CODE                    \n");  // 회사코드
    			sql.append(" 	, HOUSE_CODE                      \n");  // 직무코드
    			sql.append(" 	, CTRL_CODE                       \n");  // 직무코드
    			sql.append(" 	, CTRL_TYPE                       \n");  // 직무형태
    			sql.append(" 	, CTRL_PERSON_ID                  \n");  // 직무담당자
    			//sql.append(" 	, PLANT_CODE                  	  \n");  // 사업장코드
    			//sql.append(" 	, PURCHASE_PART_TXT               \n");  // 담당분야
    			sql.append(" 	, DEL_FLAG                  	  \n");  // 삭제여부
    			sql.append(" 	, ADD_USER_ID                     \n");
    			sql.append(" 	, ADD_DATE                        \n");
    			sql.append(" 	, ADD_TIME                        \n");
    			sql.append(" 	, CHANGE_USER_ID                  \n");
    			sql.append(" 	, CHANGE_DATE                     \n");
    			sql.append(" 	, CHANGE_TIME                     \n");
    			sql.append(" )                                   \n");
    			sql.append(" VALUES                              \n");
    			sql.append(" (                                   \n");
    			sql.append(" 	  ?								  \n");sm.addStringParameter(MapUtils.getString( grid, "COMPANY_CODE", "" ));
    			sql.append(" 	, ?               			      \n");sm.addStringParameter(info.getSession("HOUSE_CODE"));
    			sql.append(" 	, ?                				  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_CODE", "" ));
    			sql.append(" 	, ?             				  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_TYPE", "" ));
    			sql.append(" 	, ?                				  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_PERSON_ID", "" ));
    			//sql.append(" 	, ?     		                  \n");sm.addStringParameter(MapUtils.getString( grid, "CTRL_CODE", "" ).substring(1));
    			//sql.append(" 	, ?     		                  \n");sm.addStringParameter(MapUtils.getString( grid, "PURCHASE_PART_TXT", "" ));
    			sql.append(" 	, ?     		                  \n");sm.addStringParameter(sepoa.fw.util.CommonUtil.Flag.No.getValue());
    			sql.append(" 	, ?     		                  \n");sm.addStringParameter(user_id);
    			sql.append(" 	, ?   			                  \n");sm.addStringParameter(SepoaDate.getShortDateString());
    			sql.append(" 	, ?    		                      \n");sm.addStringParameter(SepoaDate.getShortTimeString());
    			sql.append(" 	, ?    			                  \n");sm.addStringParameter(user_id);
    			sql.append(" 	, ?   			                  \n");sm.addStringParameter(SepoaDate.getShortDateString());
    			sql.append(" 	, ?   			                  \n");sm.addStringParameter(SepoaDate.getShortTimeString());
    			sql.append(" )                                   \n");
    			sm.doInsert( sql.toString());
				
			}
		}
		catch (Exception ex)
		{
			throw new Exception(ex.getMessage());
		}

		return result;
	}

	/**************************************************************************************************/
	/*********************************     직무/품목코드 연결         *********************************/
	/*************************************************************************************************/

	/* 처음에 maintain 화면 뜨고 쿼리하면 데이타를 가져와서 보여준다.*/
	public sepoa.fw.srv.SepoaOut getMaintain2(String[] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String rtn = null;
			rtn = et_getMaintain2(user_id, args, house_code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_getMaintain2(String user_id, String[] args, String house_code) throws Exception
	{
		String result = null;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			StringBuffer sql = new StringBuffer();

			/*sql.append(" select p.material_class1, c.text1, c.text2, p.purchase_location, d.text2 ");
			sql.append(" from icommcpm p, icomcode c, icomcode d ");
			sql.append(" where p.house_code = '"+house_code+"' ");
			sql.append(" and c.house_code = p.house_code ");
			sql.append(" and d.house_code = p.house_code ");
			sql.append(" <OPT=F,S> and p.company_code = ? </OPT> ");
			sql.append(" and c.type = 'M042' ");
			sql.append(" and d.type = 'M039' ");
			sql.append(" <OPT=F,S> and p.ctrl_code = ? </OPT> ");
			sql.append(" and p.ctrl_type = 'P' ");
			sql.append(" and c.code = p.material_class1 ");
			sql.append(" and d.code = p.purchase_location ");  */
			sql.append(" SELECT P.MATERIAL_CLASS1,                                                 \n");
			sql.append("   " + SEPOA_DB_OWNER + "GETICOMCODE1(P.HOUSE_CODE,'M042',P.MATERIAL_CLASS1) AS TEXT1,    \n");
			sql.append("   " + SEPOA_DB_OWNER + "GETICOMCODE2(P.HOUSE_CODE,'M042',P.MATERIAL_CLASS1) AS TEXT2,    \n");
			sql.append("   P.PURCHASE_LOCATION,                                                    \n");
			sql.append("   " + SEPOA_DB_OWNER + "GETICOMCODE2(P.HOUSE_CODE,'M039',P.PURCHASE_LOCATION) AS TEXT3   \n");
			sql.append(" FROM ICOMMCPM P                                                           \n");
			sql.append(" WHERE P.HOUSE_CODE = '" + house_code + "'                                     \n");
			sql.append(" <OPT=F,S> AND P.COMPANY_CODE = ? </OPT>                                   \n");
			sql.append(" <OPT=F,S> AND P.CTRL_CODE = ? </OPT>                                      \n");
			sql.append(" AND P.CTRL_TYPE = 'P'                                                     \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			result = sm.doSelect(args);

			if (result == null)
			{
				throw new Exception("SQLManager is null");
			}
		}
		catch (Exception ex)
		{
			throw new Exception("et_getMaintain()" + ex.getMessage());
		}

		return result;
	}

	/* 선택 박스에 체크된 Row를 삭제한다.*/
	public SepoaOut setDelete2(String[][] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			int rtn = -1;
			rtn = et_setDelete2(user_id, args, house_code);
			setValue("deleteRow ==  " + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			
			setStatus(0);
			setMessage(msg.getMessage("0001")); /* Message를 등록한다. */
		}

		return getSepoaOut();
	}

	private int et_setDelete2(String user_id, String[][] args, String house_code) throws Exception, DBOpenException
	{
		int rtn = -1;

		try
		{
			String[] settype = { "S", "S", "S", "S" }; /*SQL 문의 ?의 타입이다.*/
			ConnectionContext ctx = getConnectionContext();

			String add_date = SepoaDate.getShortDateString();
			String add_time = SepoaDate.getShortTimeString();
			String[][] logargs = new String[args.length][1];

			StringBuffer LogSQL = new StringBuffer();
			StringBuffer tSQL = new StringBuffer();

			//2002.08.30 ADMIN MODULE 삭제시 로그 테이블에 기록한다.
			String[] setLogType = { "S" };

			for (int i = 0; i < args.length; i++)
			{
				logargs[i][0] = house_code + "#" + args[i][3] + "#" + args[i][0] + "#" + args[i][1] + "#" + args[i][2] + "(HOUSE_CODE#COMPANY_CODE#MATERIAL_CLASS1#CTRL_CODE#CTRL_TYPE)";
			}

			LogSQL.append(" insert into icomdlog ");
			LogSQL.append(" values ( '" + add_date + "', '" + add_time + "','ICOMBACM', ? , '" + user_id + "' ) ");

			SepoaSQLManager smlog = new SepoaSQLManager(user_id, this, ctx, LogSQL.toString());
			rtn = smlog.doInsert(logargs, setLogType);

			tSQL.append(" delete from icombacm ");
			tSQL.append(" where material_class1 = ? and ctrl_code = ? and ctrl_type = ? ");
			tSQL.append(" and house_code = '" + house_code + "' and company_code = ? ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			rtn = sm.doDelete(args, settype);
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			Logger.err.println(info.getSession("ID"), this, "Exception=" + e.getMessage());
		}

		return rtn;
	}

	/*****************************생성 버튼을 누르면 뜨는 팝업화면**********************************************/

	/* 처음에 maintain 화면 뜨고 쿼리하면 데이타를 가져와서 보여준다.*/
	public sepoa.fw.srv.SepoaOut pp_getMaintain(String[] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String rtn = null;
			rtn = et_pp_getMaintain(user_id, args, house_code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_pp_getMaintain(String user_id, String[] args, String house_code) throws Exception
	{
		String result = null;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			StringBuffer sql = new StringBuffer();
			sql.append(" SELECT DISTINCT TEXT3, TEXT4, CODE, TEXT1, TEXT2                  \n");
			sql.append(" FROM ICOMCODE                                                     \n");
			sql.append(" WHERE HOUSE_CODE = '" + house_code + "'                               \n");
			sql.append(" AND TYPE ='M042'                                                  \n");
			sql.append(" <OPT=F,S> AND TEXT3 = ? </OPT>                                    \n");
			sql.append(" <OPT=S,S> AND TEXT4 = ? </OPT>                                    \n");
			//sql.append(" MINUS \n");
			sql.append(" AND NOT EXISTS                                                    \n");
			sql.append(" (                                                                 \n");
			sql.append(" SELECT DISTINCT A.TEXT3, A.TEXT4, A.CODE, A.TEXT1, A.TEXT2        \n");
			sql.append(" FROM ICOMCODE A, ICOMBACM B                                       \n");
			sql.append(" WHERE B.HOUSE_CODE = '" + house_code + "'                             \n");
			sql.append(" AND B.HOUSE_CODE = A.HOUSE_CODE                                   \n");
			sql.append(" AND A.TYPE = 'M042'                                               \n");
			sql.append(" AND A.CODE = B.MATERIAL_CLASS1                                    \n");
			sql.append(" )                                                                 \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			result = sm.doSelect(args);

			if (result == null)
			{
				throw new Exception("SQLManager is null");
			}
		}
		catch (Exception ex)
		{
			throw new Exception("et_pp_getMaintain()" + ex.getMessage());
		}

		return result;
	}

	/* 확인 버튼을 누르면 품목코드를 ICOMBACM 테이블에 넣어준다. */
	public SepoaOut pp_setInsert(String[][] args)
	{
		int rtn = -1;

		try
		{
			String status = "C";
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String add_date = SepoaDate.getShortDateString();
			String add_time = SepoaDate.getShortTimeString();

			rtn = et_pp_setInsert(args, status, user_id, add_date, add_time, house_code);
			setValue("insertRow ==  " + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception= " + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001")); /* Message를 등록한다. */
		}

		return getSepoaOut();
	}

	private int et_pp_setInsert(String[][] args, String status, String user_id, String add_date, String add_time, String house_code) throws Exception, DBOpenException
	{
		int result = -1;

		try
		{
			String[] settype = { "S", "S", "S", "S" };
			ConnectionContext ctx = getConnectionContext();

			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" insert into icombacm (");
			tSQL.append(" ctrl_code, ctrl_type, material_class1, status, add_user_id, ");
			tSQL.append(" add_date, add_time, house_code, company_code) ");
			tSQL.append(" values(?, ?, ?, '" + status + "', '" + user_id + "', '" + add_date + "', '" + add_time + "', ");
			tSQL.append(" '" + house_code + "', ? ) ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			result = sm.doInsert(args, settype);
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			throw new Exception("et_pp_setInsert: " + e.getMessage());
		}

		return result;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	/***********************************직무-공장-창고 연결**************************************************/

	//쿼리 버튼을 눌렀을때 수행되는 sql
	public sepoa.fw.srv.SepoaOut getQuery(String[] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String rtn = null;
			rtn = et_getQuery(user_id, args, house_code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_getQuery(String user_id, String[] args, String house_code) throws Exception
	{
		String result = null;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			StringBuffer sql = new StringBuffer();
			sql.append(" select ctrl_code, ctrl_name, plant_code, plant_name, str_code, str_name ");
			sql.append(" from ctrl_plant_str_vw ");
			sql.append(" where house_code = '" + house_code + "' ");
			sql.append(" <OPT=F,S> and company_code= ? </OPT> ");
			sql.append(" <OPT=F,S> and ctrl_type = ? </OPT> ");
			sql.append(" <OPT=F,S> and ctrl_code like '%'||?||'%' </OPT> ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			result = sm.doSelect(args);

			if (result == null)
			{
				throw new Exception("SQLManager is null");
			}
		}
		catch (Exception ex)
		{
			throw new Exception("et_getQuery()" + ex.getMessage());
		}

		return result;
	}

	/*새로 생성한 데이타가 기존에 있는 데이타인지 체크해준다.(직무-공장-창고 연결)
	public wise.srv.WiseOut cps_checkItem(String[] args) {
	        String user_id = info.getSession("ID");
	        String house_code = info.getSession("HOUSE_CODE");
	        String company_code = info.getSession("COMPANY_CODE");

	        try {
	            String rtn = null;
	            rtn = et_cps_checkItem(user_id,args,house_code,company_code);
	            setValue(rtn);
	            setStatus(1);
	            setMessage(msg.getMessage("0000"));
	        }catch(Exception e){
	            System.out.println("Eception e = " + e.getMessage());
	            setStatus(0);
	            setMessage(msg.getMessage("0001"));
	            Logger.err.println(info.getSession("ID"), this, e.getMessage());
	        }
	        return getWiseOut();
	    }

	    public String et_cps_checkItem(String user_id, String[] args, String house_code, String company_code) throws Exception {
	        String result = null;
	        ConnectionContext ctx = getConnectionContext();
	        try {
	                StringBuffer sql = new StringBuffer();
	                sql.append(" select count(*) ");
	                sql.append(" from icombasl ");
	                sql.append(" where house_code = '"+house_code +"' ");
	                sql.append(" and company_code = '"+company_code +"' ");
	                sql.append(" and status != 'D' ");
	                sql.append(" <OPT=F,S> and ctrl_code = ? </OPT> ");
	                sql.append(" <OPT=F,S> and plant_code  = ? </OPT> ");
	                sql.append(" <OPT=F,S> and str_code  = ? </OPT> ");

	                WiseSQLManager sm = new WiseSQLManager(user_id, this, ctx, sql.toString());
	                result = sm.doSelect(args);
	                if(result == null) throw new Exception("SQLManager is null");
	        }catch(Exception ex) {
	            throw new Exception("et_cps_checkItem()"+ ex.getMessage());
	        }
	        return result;
	    }   */

	//라인 insert를 하고 등록을 누르면 수행되는 sql
	public SepoaOut setInsert3(String[][] args)
	{
		int rtn = -1;

		try
		{
			String status = "C";
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String add_date = SepoaDate.getShortDateString();
			String add_time = SepoaDate.getShortTimeString();

			rtn = et_setInsert3(args, status, user_id, add_date, add_time, house_code);
			setValue("insertRow ==  " + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception= " + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001")); /* Message를 등록한다. */
		}

		return getSepoaOut();
	}

	private int et_setInsert3(String[][] args, String status, String user_id, String add_date, String add_time, String house_code) throws Exception, DBOpenException
	{
		int result = -1;

		try
		{
			String[] settype = { "S", "S", "S", "S", "S" };
			ConnectionContext ctx = getConnectionContext();

			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" insert into icombasl (");
			tSQL.append(" CTRL_CODE, CTRL_TYPE, PLANT_CODE, STR_CODE, company_code, status, ");
			tSQL.append(" add_user_id, add_date, add_time, change_user_id, change_date, change_time, house_code ) ");
			tSQL.append(" values(?, ?, ?, ?, ?, '" + status + "', '" + user_id + "', '" + add_date + "', '" + add_time + "', ");
			tSQL.append(" '" + user_id + "', '" + add_date + "', '" + add_time + "','" + house_code + "' ) ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			result = sm.doInsert(args, settype);
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			throw new Exception("et_setInsert: " + e.getMessage());
		}

		return result;
	}

	//선택 박스에 체크된 Row를 삭제한다.
	public SepoaOut setDelete3(String[][] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			int rtn = -1;

			rtn = et_setDelete3(user_id, args, house_code);
			setValue("deleteRow ==  " + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			Logger.err.println(info.getSession("ID"), this, "Exception= " + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001")); /* Message를 등록한다. */
		}

		return getSepoaOut();
	}

	private int et_setDelete3(String user_id, String[][] args, String house_code) throws Exception, DBOpenException
	{
		int rtn = -1;

		try
		{
			String[] settype = { "S", "S", "S", "S", "S" }; /*SQL 문의 ?의 타입이다.*/
			ConnectionContext ctx = getConnectionContext();

			String add_date = SepoaDate.getShortDateString();
			String add_time = SepoaDate.getShortTimeString();

			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" DELETE FROM ICOMBASL                  \n");
			tSQL.append(" WHERE HOUSE_CODE = '" + house_code + "'   \n");
			tSQL.append("   AND CTRL_CODE = ?                   \n");
			tSQL.append("   AND CTRL_TYPE = ?                   \n");
			tSQL.append("   AND PLANT_CODE = ?                  \n");
			tSQL.append("   AND STR_CODE = ?                    \n");
			tSQL.append("   AND COMPANY_CODE = ?                \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
			rtn = sm.doDelete(args, settype);
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			Logger.err.println(info.getSession("ID"), this, "Exception=" + e.getMessage());
		}

		return rtn;
	}

	/**************************************************************************************************/
	/*********************************     직무Type별 담당자 현황      *********************************/
	/*************************************************************************************************/

	/* 처음에 maintain 화면 뜨고 쿼리하면 데이타를 가져와서 보여준다.*/
	public sepoa.fw.srv.SepoaOut getTypeCtrl(String[] args)
	{
		try
		{
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String rtn = null;
			rtn = et_getTypeCtrl(user_id, args, house_code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		}
		catch (Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_getTypeCtrl(String user_id, String[] args, String house_code) throws Exception
	{
		String result = null;

		try
		{
			ConnectionContext ctx = getConnectionContext();

			StringBuffer sql = new StringBuffer();

			sql.append(" select company_code, ctrl_code, ctrl_person_id, ctrl_person_name_loc  \n ");
			sql.append(" from icombacp                         \n ");
			sql.append(" where house_code = '" + house_code + "'   \n ");
			sql.append(" <OPT=S,S> and CTRL_TYPE = ? </OPT>    \n ");
			sql.append(" <OPT=S,S> and CTRL_PERSON_ID like '%'||?||'%' </OPT> \n ");
			sql.append(" <OPT=S,S> and CTRL_CODE = ? </OPT>    \n ");
			sql.append(" <OPT=S,S> and CTRL_PERSON_NAME_LOC like '%'||?||'%' </OPT>    \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
			result = sm.doSelect(args);

			if (result == null)
			{
				throw new Exception("SQLManager is null");
			}
		}
		catch (Exception ex)
		{
			throw new Exception("et_getTypeCtrl()" + ex.getMessage());
		}

		return result;
	}

	public SepoaOut getCount2(String flag, String ctrl_type)
	{
		String rtn = null;

		try
		{
			rtn = et_getCount2(flag, ctrl_type);
			setValue(rtn);
			setStatus(1);
		}
		catch (Exception e)
		{
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getDefaultBacp faild");
			Logger.err.println(this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_getCount2(String flag, String ctrl_type) throws Exception
	{
		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		String user_id = info.getSession("ID");

		ConnectionContext ctx = getConnectionContext();
		StringBuffer tSQL = new StringBuffer();

		tSQL.append(" select count(*)                           			\n");
		tSQL.append("   from icombacp bacp                                 	\n");
		tSQL.append("  where bacp.house_code      = '" + house_code + "'        \n");
		tSQL.append("    and bacp.company_code    = '" + company_code + "'      \n");

		if (flag.equals("1"))
		{
			tSQL.append("    and bacp.ctrl_type       = '" + ctrl_type + "'     \n");
		}
		else
		{
			tSQL.append("    and bacp.ctrl_type in ( '" + ctrl_type + "' )    	\n");
		}

		tSQL.append("    and bacp.ctrl_person_id  = '" + user_id + "'           \n");

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL.toString());

		rtn = sm.doSelect();

		return rtn;
	}
}
