package ev;

import java.util.HashMap;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class WO_031 extends SepoaService {
	public WO_031(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}

    public SepoaOut ev_query( String ev_no, String ev_year, String seller_code, String est_no ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			
			rtn  = et_ev_query( ev_no, ev_year, seller_code, est_no );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
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
	
	private String[] et_ev_query( String ev_no, String ev_year, String seller_code, String est_no ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("                 SELECT  EV_NO                               \n ");
			sb.append("                        ,EV_YEAR                             \n ");
			sb.append("                        ,SELLER_CODE                         \n ");
			sb.append("                        ,EST_NO                              \n ");
			sb.append("                        ,EST_SEQ                             \n ");
			sb.append("                        ,WORK_NAME                           \n ");
			sb.append("                        ,DEPT                                \n ");
			sb.append("                        ,PHONE                               \n ");
			sb.append("                        ,EMPLOYEE_SEQ                        \n ");
			sb.append("                        ,ADMIN_PART                          \n ");
			sb.append("                        ,PRODUCT_PART                        \n ");
			sb.append("                        ,SALES                               \n ");
			sb.append("                        ,PROFIT                              \n ");
			sb.append("                        ,SALES_DATE                          \n ");
			sb.append("                        ,MACHINE                             \n ");
			sb.append("                        ,PRODUCT                             \n ");
			sb.append("                        ,GOODS                               \n ");
			sb.append("                 FROM    SRGVD                               \n ");
			sb.append(sm.addFixString(" WHERE   EV_NO       = ?                     \n "));  sm.addStringParameter(ev_no);
			sb.append(sm.addFixString(" AND     EV_YEAR     = ?                     \n "));  sm.addStringParameter(ev_year);
			sb.append(sm.addFixString(" AND     SELLER_CODE = ?                     \n "));  sm.addStringParameter(seller_code);
			sb.append(sm.addSelectString(" AND  EST_NO      = ?                  	\n "));  sm.addStringParameter(est_no);
			sb.append("                 AND     DECODE(DEL_FLAG,NULL,'N', DEL_FLAG) = 'N'  \n ");
			sb.append("                 AND     DECODE(DEL_FLAG,NULL,'N', DEL_FLAG) = 'N'  \n ");
			straResult[0] = sm.doSelect( sb.toString() );
			if( straResult[0] == null )	straResult[1] = "SQL manager is Null";
		}
		catch (Exception e)
		{
			straResult[1] = e.getMessage();
			Logger.debug.println(info.getSession("ID"), this, "=------------------ error.");
		}
		finally
		{
		}

		return straResult;
	}
    
	public SepoaOut srgvn_tbl_insert( HashMap map ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_srgvn_tbl_insert( map );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
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
	
	private String[] et_srgvn_tbl_insert( HashMap map ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;	
		String user_id        = info.getSession("ID");
		String cur_date       = SepoaDate.getShortDateString();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete( 0, sb.length() );	
			Logger.sys.println("111");
			sb.append("                   SELECT  COUNT(*) AS CNT    \n ");
			sb.append("                   FROM    SRGVN              \n ");
			sb.append("                   WHERE   1=1                \n ");
			sb.append(sm.addSelectString("AND     EV_NO       = ?    \n ")); sm.addStringParameter((String)map.get("ev_no"));
			sb.append(sm.addSelectString("AND     EV_YEAR     = ?    \n ")); sm.addStringParameter((String)map.get("ev_year"));
			sb.append(sm.addSelectString("AND     SELLER_CODE = ?    \n ")); sm.addStringParameter((String)map.get("seller_code"));
			sb.append("                   AND     DECODE(DEL_FLAG,NULL,'N',DEL_FLAG) =  'N'    \n ");
			Logger.sys.println(sb.toString());
			sf = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
			if( Integer.parseInt(sf.getValue("CNT", 0)) != 0 ){
				sm.removeAllValue();
				sb.delete( 0, sb.length() );
				sb.append("UPDATE SRGVN SET                       \n ");
				sb.append("                INVEST_DATE    = ?     \n "); sm.addStringParameter((String)map.get("invest_date"));
				sb.append("               ,IRS_NO         = ?     \n "); sm.addStringParameter((String)map.get("irs_no"));
				sb.append("               ,ADDRESS_LOC    = ?     \n "); sm.addStringParameter((String)map.get("address_loc"));
				sb.append("               ,PHONE_NO       = ?     \n "); sm.addStringParameter((String)map.get("phone_no"));
				sb.append("               ,PLANT_ADDRESS  = ?     \n "); sm.addStringParameter((String)map.get("plant_address"));
				sb.append("               ,PHONE_NO1      = ?     \n "); sm.addStringParameter((String)map.get("phone_no1"));
				sb.append("               ,EST_DESC       = ?     \n "); sm.addStringParameter((String)map.get("est_desc"));
				sb.append("               ,ATTACH_NO      = ?     \n "); sm.addStringParameter((String)map.get("in_attach_no"));
				sb.append("               ,ATTACH_NO1     = ?     \n "); sm.addStringParameter((String)map.get("in_attach_cnt"));
				sb.append("               ,CHANGE_DATE    = ?     \n "); sm.addStringParameter(cur_date);
				sb.append("               ,CHANGE_USER_ID = ?     \n "); sm.addStringParameter(user_id);
				sb.append("          WHERE EV_NO          = ?     \n "); sm.addStringParameter((String)map.get("ev_no"));
				sb.append("          AND   EV_YEAR        = ?     \n "); sm.addStringParameter((String)map.get("ev_year"));
				sb.append("          AND   SELLER_CODE    = ?     \n "); sm.addStringParameter((String)map.get("seller_code"));
				sm.doUpdate(sb.toString());
				straResult[0] = "수정";
			}else{
				sm.removeAllValue();
				sb.delete( 0, sb.length() );			
				sb.append("INSERT INTO SRGVN (                   \n ");
				sb.append("                   EV_NO              \n ");
				sb.append("                  ,EV_YEAR            \n ");
				sb.append("                  ,SELLER_CODE        \n ");
				sb.append("                  ,EST_NO             \n ");
				sb.append("                  ,SUBJECT            \n ");
				sb.append("                  ,INVEST_DATE        \n ");
				sb.append("                  ,IRS_NO             \n ");
				sb.append("                  ,ADDRESS_LOC        \n ");
				sb.append("                  ,PHONE_NO           \n ");
				sb.append("                  ,PLANT_ADDRESS      \n ");
				sb.append("                  ,PHONE_NO1          \n ");
				sb.append("                  ,EST_DESC           \n ");
				sb.append("                  ,ATTACH_NO          \n "); 
				sb.append("                  ,ATTACH_NO1         \n ");		
				sb.append("                  ,ADD_DATE           \n ");
				sb.append("                  ,ADD_USER_ID        \n ");
				sb.append("                  ,RG_STATUS          \n ");
				sb.append("                 )                    \n ");
				sb.append("           VALUES(                    \n ");
				sb.append("                  ?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("ev_no")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("ev_year")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("seller_code")));
				sb.append("                 ,( SELECT DECODE(MAX(EST_NO),NULL,1,MAX(EST_NO)+1) AS CNT FROM SRGVN WHERE EV_NO = ? AND EV_YEAR = ? AND SELLER_CODE = ? ) \n "); 
																		sm.addStringParameter(JSPUtil.convertStr((String)map.get("ev_no")));
																		sm.addStringParameter(JSPUtil.convertStr((String)map.get("ev_year")));
																		sm.addStringParameter(JSPUtil.convertStr((String)map.get("seller_code")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("sheet_name")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("invest_date")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("irs_no")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("address_loc")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("phone_no")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("plant_address")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("phone_no1")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("est_desc")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("in_attach_no")));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr((String)map.get("in_attach_cnt"))); 
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr(cur_date));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr(user_id));
				sb.append("                 ,?                   \n "); sm.addStringParameter(JSPUtil.convertStr("W"));
				sb.append("                 )                    \n ");
				sm.doInsert(sb.toString());
				straResult[0] = "저장";
			}
			Commit();
			
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}
		return straResult;
	}
	
    public SepoaOut srgvn_tbl_select(String[] args) {
        try
        {
            String lang  = info.getSession("LANGUAGE");
            Message msg  = new Message(info, "STDCOMM");
            String rtnHD = et_srgvn_tbl_select( args );
            setStatus(1);
            setValue(rtnHD);
            setMessage(msg.getMessage("0000"));
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setStatus(0);

            String lang = info.getSession("LANGUAGE");
            Message msg = new Message(info, "p10_pra");

            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    } //End of prHDQueryDisplay()	
    
    private String et_srgvn_tbl_select(String[] args) throws Exception {
        String rtn = null;
        try
        {
            String user_id        = info.getSession("ID");
            String language       = info.getSession("LANGUAGE");
            ConnectionContext ctx = getConnectionContext();
            ParamSql sm           = new ParamSql(info.getSession("ID"), this, ctx);
            StringBuffer sql      = new StringBuffer();
            SepoaFormater sf      = null;
            
            sql.append("                    SELECT  EST_DESC 						    			  \n");
            sql.append("                           ,EST_NO 						    			      \n");
            sql.append("                           ,irs_no 						    			      \n");
            sql.append("                           ,address_loc 						    		  \n");
            sql.append("                           ,phone_no 						    			  \n");
            sql.append("                           ,plant_address 						    		  \n");
            sql.append("                           ,phone_no1 						    			  \n");
            sql.append("                           ,ATTACH_NO 						    			  \n");
            sql.append("                           ,ATTACH_NO1 						    			  \n");
            sql.append("                    FROM    SRGVN                                             \n");
            sql.append("                    WHERE " + DB_NULL_FUNCTION + "(del_flag, 'N') =  'N'      \n");
            sql.append(sm.addSelectString(" AND     EV_NO       = ?	             	                  \n")); sm.addStringParameter(args[0]);
            sql.append(sm.addSelectString(" AND     EV_YEAR     = ? 			                      \n")); sm.addStringParameter(args[1]);            
            sql.append(sm.addSelectString(" AND     SELLER_CODE = ? 			                      \n")); sm.addStringParameter(args[2]);
            sf = new SepoaFormater( sm.doSelect_limit( sql.toString() ) );
            
            // SRGVN 테이블에 정보가 저장되어 있나 확인 후 없으면 
            if( sf.getRowCount()  == 0 ){
				sm.removeAllValue();
				sql.delete( 0, sql.length() );
            	sql.append("				    SELECT											   \n ");
            	sql.append("				             ''                     AS EST_DESC        \n "); // 평가자의견
            	sql.append("				            ,''                     AS EST_NO          \n ");  
            	sql.append("				            ,IRS_NO                                    \n "); // 사업자등록번호
            	sql.append("				            ,B.ADDRESS_LOC AS address_loc     \n "); // 본사주소
            	sql.append("				            ,B.PHONE_NO1              AS phone_no        \n "); // 본사연락처
            	sql.append("				            ,''                     AS plant_address   \n "); // 공장주소
            	sql.append("				            ,''                     AS phone_no1       \n "); // 공장연락처
            	sql.append("				    FROM     ICOMVNGL A, ICOMADDR B                                 \n ");
				sql.append("				    WHERE   A.HOUSE_CODE = B.HOUSE_CODE(+) 		\n ");
				sql.append("				    AND		A.VENDOR_CODE = B.CODE_NO(+) 		\n ");
				sql.append("				    AND 	B.CODE_TYPE = '2' 					\n ");
            	sql.append(sm.addSelectString("	AND     VENDOR_CODE = ?                     \n ")); sm.addStringParameter(args[2]);
            	rtn = sm.doSelect(sql.toString());
            }else{
            	rtn = sm.doSelect(sql.toString());
            }
        }
        catch (Exception e)
        {
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
	public SepoaOut ev_insert( String[][] setData, String ev_no, String ev_year, String seller_code, String est_no, String sg_regitem ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_ev_insert( setData, ev_no, ev_year, seller_code, est_no, sg_regitem );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
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
	
	private String[] et_ev_insert( String[][] straData, String ev_no, String ev_year, String seller_code, String est_no, String sg_regitem ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;
		String user_id        = info.getSession("ID");
		String cur_date       = SepoaDate.getShortDateString();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("						SELECT DECODE(OFFLINE_FLAG,'Y',OFFLINE_FLAG,'N') AS OFFLINE_FLAG   	\n ");
			sb.append("						FROM   SEVVN                                                        \n ");
			sb.append(sm.addFixString("		WHERE  EV_NO       = ?                                              \n ")); sm.addStringParameter(ev_no);
			sb.append(sm.addFixString("		AND    EV_YEAR     = ?                                              \n ")); sm.addStringParameter(ev_year);
			sb.append(sm.addFixString("		AND    SG_REGITEM  = ?                                              \n ")); sm.addStringParameter(sg_regitem);
			sb.append(sm.addFixString("		AND    SELLER_CODE = ?                                              \n ")); sm.addStringParameter(seller_code);
			sf = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
			
			for (int a = 0; a < straData.length; a++)
			{
				//INSERT OR UPDATE
				if(straData[a][13] != null && !straData[a][13].equals("")){
					sm.removeAllValue();
					sb.delete( 0, sb.length() );					
					sb.append("UPDATE SRGVD SET  	                    \n ");
					sb.append("				     WORK_NAME      = ?     \n "); sm.addStringParameter(straData[a][0]);
					sb.append("				    ,DEPT           = ?     \n "); sm.addStringParameter(straData[a][1]);
					sb.append("				    ,PHONE          = ?     \n "); sm.addStringParameter(straData[a][2]);
					sb.append("				    ,EMPLOYEE_SEQ   = ?     \n "); sm.addStringParameter(straData[a][3]);
					sb.append("				    ,ADMIN_PART     = ?     \n "); sm.addStringParameter(straData[a][4]);
					sb.append("				    ,PRODUCT_PART   = ?     \n "); sm.addStringParameter(straData[a][5]);
					sb.append("				    ,SALES          = ?     \n "); sm.addStringParameter(straData[a][6]);
					sb.append("				    ,PROFIT         = ?     \n "); sm.addStringParameter(straData[a][7]);
					sb.append("				    ,SALES_DATE     = ?     \n "); sm.addStringParameter(JSPUtil.convertStr(straData[a][8]).replaceAll("/", ""));
					sb.append("				    ,MACHINE        = ?     \n "); sm.addStringParameter(straData[a][9]);
					sb.append("				    ,PRODUCT        = ?     \n "); sm.addStringParameter(straData[a][10]);
					sb.append("				    ,GOODS          = ?     \n "); sm.addStringParameter(straData[a][11]);
					sb.append("				    ,CHANGE_DATE    = ?     \n "); sm.addStringParameter(cur_date);
					sb.append("				    ,CHANGE_USER_ID = ?     \n "); sm.addStringParameter(user_id);
					sb.append("				    ,RG_STATUS      = ?     \n "); sm.addStringParameter("W"); 
					sb.append("		      WHERE  EV_NO          = ?     \n "); sm.addStringParameter(ev_no);
					sb.append("		      AND    EV_YEAR        = ?     \n "); sm.addStringParameter(ev_year);
					sb.append("		      AND    SELLER_CODE    = ?     \n "); sm.addStringParameter(seller_code);
					sb.append("		      AND    EST_NO         = ?     \n "); sm.addStringParameter(est_no);
					sb.append("		      AND    EST_SEQ        = ?     \n "); sm.addStringParameter(straData[a][13]);
//					System.out.println(sb.toString());
					sm.doUpdate(sb.toString());
				}
				else{
					sm.removeAllValue();
					sb.delete( 0, sb.length() );
					sb.append("INSERT INTO SRGVD(	              \n ");
					sb.append("				     EV_NO            \n ");
					sb.append("				    ,EV_YEAR          \n ");
					sb.append("				    ,SELLER_CODE      \n ");
					sb.append("				    ,EST_NO           \n ");
					sb.append("				    ,EST_SEQ          \n ");
					sb.append("				    ,WORK_NAME        \n ");
					sb.append("				    ,DEPT             \n ");
					sb.append("				    ,PHONE            \n ");
					sb.append("				    ,EMPLOYEE_SEQ     \n ");
					sb.append("				    ,ADMIN_PART       \n ");
					sb.append("				    ,PRODUCT_PART     \n ");
					sb.append("				    ,SALES            \n ");
					sb.append("				    ,PROFIT           \n ");
					sb.append("				    ,SALES_DATE       \n ");
					sb.append("				    ,MACHINE          \n ");
					sb.append("				    ,PRODUCT          \n ");
					sb.append("				    ,GOODS            \n ");
					sb.append("				    ,ADD_DATE         \n ");
					sb.append("				    ,ADD_USER_ID      \n ");
					sb.append("				    ,RG_STATUS        \n ");
					sb.append("                 )                 \n ");
					sb.append("  		 VALUES (                 \n ");
					sb.append("		             ?                \n "); sm.addStringParameter(ev_no);
					sb.append("				    ,?                \n "); sm.addStringParameter(ev_year);
					sb.append("				    ,?                \n "); sm.addStringParameter(seller_code);
					sb.append("				    ,?                \n "); sm.addStringParameter(est_no);
					sb.append("				    ,( SELECT DECODE(MAX(EST_SEQ),NULL,1,MAX(EST_SEQ)+1) FROM SRGVD WHERE EV_NO = ? AND EV_YEAR = ? AND SELLER_CODE = ? AND EST_NO = ? )   \n ");
																		 sm.addStringParameter(ev_no);
																		 sm.addStringParameter(ev_year);
																		 sm.addStringParameter(seller_code);
																		 sm.addStringParameter(est_no);
					sb.append("				    ,?                \n "); sm.addStringParameter(straData[a][0]);
					sb.append("				    ,?                \n "); sm.addStringParameter(straData[a][1]);
					sb.append("				    ,?                \n "); sm.addStringParameter(straData[a][2]);
					sb.append("				    ,?                \n "); sm.addNumberParameter(straData[a][3]);
					sb.append("				    ,?                \n "); sm.addNumberParameter(straData[a][4]);
					sb.append("				    ,?                \n "); sm.addNumberParameter(straData[a][5]);
					sb.append("				    ,?                \n "); sm.addNumberParameter(straData[a][6]);
					sb.append("				    ,?                \n "); sm.addNumberParameter(straData[a][7]);
					sb.append("				    ,?                \n "); sm.addStringParameter(JSPUtil.convertStr(straData[a][8]).replaceAll("/", ""));
					sb.append("				    ,?                \n "); sm.addStringParameter(straData[a][9]);
					sb.append("				    ,?                \n "); sm.addStringParameter(straData[a][10]);
					sb.append("				    ,?                \n "); sm.addStringParameter(straData[a][11]);
					sb.append("				    ,?                \n "); sm.addStringParameter(cur_date);
					sb.append("				    ,?                \n "); sm.addStringParameter(user_id);
					sb.append("				    ,?                \n "); sm.addStringParameter("W"); 
					sb.append("		           )                  \n "); 		
//					System.out.println(sb.toString());
					sm.doInsert(sb.toString());
					
					if( a == 0 && sf.getValue("OFFLINE_FLAG", 0).equals("N") ){
						sm.removeAllValue();
						sb.delete( 0, sb.length() );					
						sb.append("UPDATE SEVVN SET  	                   \n ");
						sb.append("				     OFFLINE_FLAG = 'Y'    \n "); 
						sb.append("		      WHERE  EV_NO        = ?      \n "); sm.addStringParameter(ev_no);
						sb.append("		      AND    EV_YEAR      = ?      \n "); sm.addStringParameter(ev_year);
						//sb.append("			  AND    SG_REGITEM   = ?      \n "); sm.addStringParameter(sg_regitem);
						sb.append("			  AND    SELLER_CODE  = ?      \n "); sm.addStringParameter(seller_code);
//						System.out.println(sb.toString());
						sm.doUpdate(sb.toString());
					}
				}
			}
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}
		return straResult;
	}
	
	public SepoaOut ev_delete(String[][] straData, String ev_no, String ev_year, String seller_code, String est_no, String sg_regitem ) {
		try
		{
			setStatus(1);
			setFlag(true);			
			String[] rtn = null;

			rtn = et_ev_delete(straData, ev_no, ev_year, seller_code, est_no, sg_regitem );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
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

	private String[] et_ev_delete( String[][] straData, String ev_no, String ev_year, String seller_code, String est_no, String sg_regitem ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;
		String user_id        = info.getSession("ID");

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for( int a = 0; a < straData.length; a++ ){
				sm.removeAllValue();
				sb.delete( 0, sb.length() );
				sb.append("UPDATE SRGVD SET                    \n ");
				sb.append("                  DEL_FLAG    = 'Y' \n "); 
				sb.append("           WHERE  EV_NO       = ?   \n ");  sm.addStringParameter(ev_no);
				sb.append("           AND    EV_YEAR     = ?   \n ");  sm.addStringParameter(ev_year);
				sb.append("           AND    SELLER_CODE = ?   \n ");  sm.addStringParameter(seller_code);		
				sb.append("           AND    EST_NO      = ?   \n ");  sm.addStringParameter(est_no); 			
				sb.append("           AND    EST_SEQ     = ?   \n ");  sm.addStringParameter(straData[a][13]);
//				System.out.println(sb.toString());
				sm.doDelete( sb.toString() );
			}
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("						SELECT COUNT(*) AS CNT     \n ");
			sb.append("						FROM   SRGVD               \n ");
			sb.append(sm.addFixString("     WHERE  EV_NO       = ?     \n "));  sm.addStringParameter(ev_no);
			sb.append(sm.addFixString("     AND    EV_YEAR     = ?     \n "));  sm.addStringParameter(ev_year);
			sb.append(sm.addFixString("     AND    SELLER_CODE = ?     \n "));  sm.addStringParameter(seller_code);		
			sb.append(sm.addFixString("     AND    EST_NO      = ?     \n "));  sm.addStringParameter(est_no); 
			sb.append("                     AND    DEL_FLAG    = 'N'   \n ");
//			System.out.println(sb.toString());
			sf = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
			
			if( sf.getValue("CNT", 0).equals("0") ){
				sm.removeAllValue();
				sb.delete( 0, sb.length() );					
				sb.append("UPDATE SEVVN SET  	                   \n ");
				sb.append("				     OFFLINE_FLAG = 'N'    \n "); 
				sb.append("		      WHERE  EV_NO        = ?      \n "); sm.addStringParameter(ev_no);
				sb.append("		      AND    EV_YEAR      = ?      \n "); sm.addStringParameter(ev_year);
				//sb.append("			  AND    SG_REGITEM   = ?      \n "); sm.addStringParameter(sg_regitem);
				sb.append("			  AND    SELLER_CODE  = ?      \n "); sm.addStringParameter(seller_code);
//				System.out.println(sb.toString());
				sm.doUpdate(sb.toString());				
			}
			
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}
	
    public SepoaOut srgvn_tbl_chk( String ev_no, String ev_year, String est_no, String seller_code ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			
			rtn  = et_srgvn_tbl_chk( ev_no, ev_year, seller_code, est_no );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
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
	
	private String[] et_srgvn_tbl_chk( String ev_no, String ev_year, String seller_code, String est_no ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;
		
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append("                    SELECT  COUNT(*) AS CNT                         	  \n ");
			sb.append("                    FROM    SRGVN                               		  \n ");
			sb.append(sm.addFixString("    WHERE   EV_NO       = ?                     		  \n "));  sm.addStringParameter(ev_no);
			sb.append(sm.addFixString("    AND     EV_YEAR     = ?                     		  \n "));  sm.addStringParameter(ev_year);
			sb.append(sm.addFixString("    AND     SELLER_CODE = ?                     		  \n "));  sm.addStringParameter(seller_code);
			sb.append(sm.addSelectString(" AND     EST_NO      = ?                  	 	  \n "));  sm.addStringParameter(est_no);
			sb.append("                    AND     DECODE(DEL_FLAG,NULL,'N', DEL_FLAG) = 'N'  \n ");
			sb.append("                    AND     DECODE(DEL_FLAG,NULL,'N', DEL_FLAG) = 'N'  \n ");
			sf = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
			straResult[0] = sf.getValue("CNT", 0);
		}
		catch (Exception e)
		{
			Logger.debug.println(info.getSession("ID"), this, "=------------------ error.");
		}
		finally
		{
		}

		return straResult;
	}	
}	

