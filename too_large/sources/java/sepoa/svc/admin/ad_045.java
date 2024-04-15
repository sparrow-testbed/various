package sepoa.svc.admin;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.common.Constants;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DBUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class AD_045 extends SepoaService {

	 private String lang = "";
	 private Message msg = null;

    public AD_045( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );

        lang = info.getSession( "LANGUAGE" );
        msg = new Message( info, "AD_045" );
    }
	    

    /**
     * 조회 
     * 
     * @return
     * @throws
     */   
    public SepoaOut doQuery( Map< String, String > header ) throws Exception {

        ConnectionContext ctx = getConnectionContext();// ConnectionContext 객체를 가져온다.(생성은 extends한 SepoaService의 생성자에서 구현된다.)
        setStatus( 1 );
        setFlag( true );
        ParamSql sm = new ParamSql( info.getSession( "ID" ), this, ctx );
        String language = info.getSession ( "LANGUAGE" );
        StringBuffer sb = new StringBuffer();

        try {
            
            String from_date    = JSPUtil.getString ( header.get ( "from_date" ) ,"" ).replace ( "-" ,"" );
            String to_date      = JSPUtil.getString ( header.get ( "to_date" ) ,"" ).replace ( "-" ,"" );
            String type   = JSPUtil.getString ( header.get ( "type" ) , "" );
            String searchCode = JSPUtil.getString ( header.get ( "searchCode" ) ,"" );

            sm.removeAllValue();
            sb.delete( 0, sb.length() );

            if ( "001".equals ( type ) || "002".equals ( type ) ) {
                // SPRGL
                sb.append(                      " SELECT                                                                                   \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,PR_NUMBER  AS CODE                                                                    \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M301' , SIGN_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      " FROM SPRGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND PR_NUMBER like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    PR_NUMBER DESC                                                               \n");

            } else if ( "003".equals ( type ) ) {
                // SRQGL
                sb.append(                      " SELECT                                                                                    \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,RFQ_NUMBER  AS CODE                                                                  \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M639' , RFQ_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      "    ,'' AS YEAR                                                                                  \n");
                sb.append(                      " FROM SRQGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND RFQ_NUMBER like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    RFQ_NUMBER DESC                                                                \n");
                
            } else if ( "009".equals( type ) || "010".equals( type ) ) {
                // SDRGL
                sb.append(                      " SELECT                                                                                    \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,EXEC_NUMBER  AS CODE                                                                  \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M301' , SIGN_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      "    ,'' AS YEAR                                                                                  \n");
                sb.append(                      " FROM SDRGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND EXEC_NUMBER like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    EXEC_NUMBER DESC                                                                \n");

            } else if ( "013".equals ( type ) ) {
                // SIVGL
                sb.append(                      " SELECT                                                                                    \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,INV_NUMBER  AS CODE                                                                  \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M1012' , IV_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      "    ,'' AS YEAR                                                                                  \n");
                sb.append(                      " FROM SIVGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND INV_NUMBER like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    INV_NUMBER DESC                                                                \n");

            } else if ( "017".equals ( type ) ) {
                // SIVGL
                sb.append(                      " SELECT                                                                                    \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,INV_NUMBER  AS CODE                                                                  \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M516' , ASP_TAX_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      "    ,'' AS YEAR                                                                                  \n");
                sb.append(                      " FROM SIVGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND INV_NUMBER like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    INV_NUMBER DESC                                                                \n");

            } else if ( "021".equals ( type ) ) {
                // SPOGL
                sb.append(                      " SELECT                                                                                    \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,PO_NUMBER  AS CODE                                                                  \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M301' , SIGN_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      "    ,'' AS YEAR                                                                                  \n");
                sb.append(                      " FROM SPOGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND PO_NUMBER like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    PO_NUMBER DESC                                                                \n");
                
            } else if("031".equals ( type ) ){
                // SSUGL
                sb.append(                      " SELECT                                                                                    \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,SELLER_CODE  AS CODE                                                                  \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M110' , SIGN_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      "    ,EVAL_NO                                                                               \n");
                sb.append(                      " FROM SSUGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND SELLER_CODE like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    SELLER_CODE                                                               \n");

            } else if ( "037".equals ( type ) ) {
                // SRGGL
                sb.append(                      " SELECT                                                                                    \n");
                sb.append(                      "    '" + type + "' AS TYPE                                                          \n");
                sb.append(                      "    ,SELLER_CODE  AS CODE                                                                  \n");
                sb.append(                      "    ,dbo.GETCODETEXT1('M100' , SIGN_STATUS , '" + language + "') AS SIGN_STATUS            \n");
                sb.append(                      "    ,YEAR                                                                                  \n");
                sb.append(                      " FROM SRGGL                                                                                \n");
                sb.append(                      " WHERE 1 = 1                                                                               \n");
                sb.append(sm.addSelectString(   " AND SELLER_CODE like '%'" + DBUtil.getAndSeparator()+ "?" + DBUtil.getAndSeparator()+ "'%'  \n"));sm.addStringParameter (searchCode);
                sb.append(sm.addSelectString(   " AND ADD_DATE  BETWEEN  ?                                                                  \n"));sm.addStringParameter (from_date);
                sb.append(sm.addSelectString(   "               AND      ?                                                                  \n"));sm.addStringParameter (to_date);
                sb.append("               ORDER BY    SELLER_CODE                                                                \n");
                
            }

            setValue( sm.doSelect( sb.toString() ) );// SepoaOut객체에 쿼리 결과값을 셋팅한다.

            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M301", "M100", "M1012", "M639" );
        } catch( Exception e ) {
            setMessage( e.getMessage() );
            setFlag( false );
            
        } finally {
        }

        return getSepoaOut();

    }


	    /**
	     * 상태수정 
	     */   
	    public SepoaOut doSave( List< Map<String, String>>gridData , Map< String, String > header ) throws Exception {
	    	
	    	ConnectionContext ctx          = getConnectionContext();
	    	SepoaFormater sf               = null;
	    	String language                = info.getSession("LANGUAGE");
	    	StringBuffer sqlsb             = new StringBuffer();
	    	Map<String,String> grid = null;	    	
	    	
	    	try {
	    	    
	    	    String status = "";
	    	    String type = "";
	    	    String sub_status = "";
                String sign_status = "";
	    	    
	    		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
	    		
	    		if( gridData != null && gridData.size() > 0 ) {
	    		    
	    		    for( int i = 0; i < gridData.size(); i++ ) {
	    		        
	    		        grid   = (Map <String , String>)gridData.get( i );
	    		        type   = MapUtils.getString( grid, "TYPE", "" );
	    		        status = JSPUtil.getString ( header.get ( "status" ) , "" );
	    		        
	    		        if ( "001".equals( type ) ) {
                            // SPRGL
                            sqlsb.append("  UPDATE SPRGL SET                        \n");
                            sqlsb.append("      SIGN_STATUS     = ?                 \n");ps.addStringParameter (status);
                            sqlsb.append("  WHERE 1 = 1                             \n");
                            sqlsb.append("  AND PR_NUMBER       = ?                 \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                            ps.doUpdate ( sqlsb.toString ( ) );

                            if ( Constants.SignStatus.Approved.getValue().equals(status) ) {
                                // 결재 승인완료일때는 SPRLN.PR_STATUS = P 로 한다.
                                sub_status = sepoa.common.Constants.PRStatus.PurchaseRequest.getValue();
                                ps.removeAllValue ( );
                                sqlsb.delete ( 0 ,sqlsb.length ( ) );
                                sqlsb.append("  UPDATE SPRLN SET                        \n");
                                sqlsb.append("      PR_STATUS     = ?                 \n");ps.addStringParameter ( sub_status );
                                sqlsb.append("  WHERE 1 = 1                             \n");
                                sqlsb.append("  AND PR_NUMBER       = ?                 \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                            }

	    		        } else if ( "002".equals( type ) ) {
                            // SPRGL
                            if ( sepoa.common.Constants.SignStatus.TempSave.getValue().equals(status) ) {
                                ps.removeAllValue ( );
                                sqlsb.delete( 0, sqlsb.length() );
                                sqlsb.append( "DELETE FROM SRQSE    \n" );
                                sqlsb.append( " WHERE RFQ_NUMBER IN (SELECT RFQ_NUMBER FROM SRQLN WHERE PR_NUMBER = '" + MapUtils.getString (grid, "CODE" , "" ) + "')  \n" );
                                ps.doDelete( sqlsb.toString ( ) );
                                ps.removeAllValue ( );
                                sqlsb.delete( 0, sqlsb.length() );
                                sqlsb.append( "DELETE FROM SRQGL    \n" );
                                sqlsb.append( " WHERE RFQ_NUMBER IN (SELECT RFQ_NUMBER FROM SRQLN WHERE PR_NUMBER = '" + MapUtils.getString (grid, "CODE" , "" ) + "')  \n" );
                                ps.doDelete( sqlsb.toString ( ) );
                                ps.removeAllValue ( );
                                sqlsb.delete( 0, sqlsb.length() );
                                sqlsb.append( "DELETE FROM SRQLN    \n" );
                                sqlsb.append( " WHERE PR_NUMBER = '" + MapUtils.getString (grid, "CODE" , "" ) + "'  \n" );
                                ps.doDelete( sqlsb.toString ( ) );
                                
                                sub_status = sepoa.common.Constants.PRStatus.Estimating.getValue();
                                ps.removeAllValue ( );
                                sqlsb.delete ( 0 ,sqlsb.length ( ) );
                                sqlsb.append("  UPDATE SPRLN SET                        \n");
                                sqlsb.append("      PR_STATUS     = ?                 \n");ps.addStringParameter ( sub_status );
                                sqlsb.append("  WHERE 1 = 1                             \n");
                                sqlsb.append("  AND PR_NUMBER       = ?                 \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );

                                sub_status = sepoa.common.Constants.PRStatus.TTT.getValue();
                            }
                            sqlsb.append("  UPDATE SPRGL SET                        \n");
                            sqlsb.append("      SIGN_STATUS     = ?                 \n");ps.addStringParameter (status);
                            sqlsb.append("      , PR_STATUS     = ?                	\n");ps.addStringParameter (sub_status);
                            sqlsb.append("      , REQ_TYPE     = ?                	\n");ps.addStringParameter (sepoa.common.Constants.REQ_TYPE.Purch_req.getValue());
                            sqlsb.append("  WHERE 1 = 1                             \n");
                            sqlsb.append("  AND PR_NUMBER       = ?                 \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                            ps.doUpdate ( sqlsb.toString ( ) );


                        } else if ( "003".equals ( type ) ) {
                            // SRQGL
                            sqlsb.append("  UPDATE SRQGL SET                         \n");
                            sqlsb.append("      RFQ_STATUS    = ?                    \n");ps.addStringParameter (status);
                            sqlsb.append("  WHERE 1 = 1                              \n");
                            sqlsb.append("  AND RFQ_NUMBER    = ?                    \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                            ps.doUpdate ( sqlsb.toString ( ) );
                        
                        } else if ( "009".equals( type ) || "010".equals( type ) ) {
                            // SDRGL
                            sqlsb.append("  UPDATE SDRGL SET                         \n");
                            sqlsb.append("      SIGN_STATUS    = ?                    \n");ps.addStringParameter (status);
                            sqlsb.append("  WHERE 1 = 1                              \n");
                            sqlsb.append("  AND EXEC_NUMBER    = ?                    \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                            ps.doUpdate ( sqlsb.toString ( ) );

                            if ( sepoa.common.Constants.SignStatus.Approved.getValue().equals(status) ) {
                                // 결재 승인완료일때는 SPOGL.SIGN_STATUS = E 로 한다.
                                sub_status = sepoa.common.Constants.SignStatus.Approved.getValue();
                                
                                ps.removeAllValue ( );
                                sqlsb.delete ( 0 ,sqlsb.length ( ) );
                                sqlsb.append("  UPDATE SPOGL SET                         \n");
                                sqlsb.append("      SIGN_STATUS    = ?                    \n");ps.addStringParameter ( sub_status );
                                sqlsb.append("  WHERE 1 = 1                              \n");
                                sqlsb.append("  AND EXEC_NUMBER    = ?                    \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                            } else if ( sepoa.common.Constants.SignStatus.TempSave.getValue().equals(status) ) {
                                // 임시저장 일때는 SPDGL.SIGN_STATUS = E 로 한다.
                                sub_status = sepoa.common.Constants.SignStatus.TempSave.getValue();
                                
                                ps.removeAllValue ( );
                                sqlsb.delete ( 0 ,sqlsb.length ( ) );
                                sqlsb.append("  UPDATE SPOGL SET                         \n");
                                sqlsb.append("      SIGN_STATUS    = ?                    \n");ps.addStringParameter ( sub_status );
                                sqlsb.append("  WHERE 1 = 1                              \n");
                                sqlsb.append("  AND EXEC_NUMBER    = ?                    \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                                
                                ps.removeAllValue ( );
                                sqlsb.delete ( 0 ,sqlsb.length ( ) );
                                sqlsb.append("  DELETE FROM SIVGL                   \n");
                                sqlsb.append("  WHERE 1 = 1                              \n");
                                sqlsb.append("  AND PO_NUMBER = (SELECT PO_NUMBER FROM SPOGL WHERE EXEC_NUMBER = ?)           \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                                
                                ps.removeAllValue ( );
                                sqlsb.delete ( 0 ,sqlsb.length ( ) );
                                sqlsb.append("  DELETE FROM SIVLN                   \n");
                                sqlsb.append("  WHERE 1 = 1                              \n");
                                sqlsb.append("  AND PO_NUMBER = (SELECT PO_NUMBER FROM SPOGL WHERE EXEC_NUMBER = ?)           \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                                
                                ps.removeAllValue ( );
                                sqlsb.delete ( 0 ,sqlsb.length ( ) );
                                sqlsb.append("  DELETE FROM SIVSE                   \n");
                                sqlsb.append("  WHERE 1 = 1                              \n");
                                sqlsb.append("  AND PO_NUMBER = (SELECT PO_NUMBER FROM SPOGL WHERE EXEC_NUMBER = ?)           \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                            }

                        } else if ( "013".equals ( type ) ) {
                            // SIVGL
                            if ( sepoa.common.Constants.IVStatus.ExamCompleted.getValue().equals(status) ) {
                                // 결재 승인완료일때는 SIVGL.PAY_STATUS = T 로 한다.
                                sub_status = "T";//sepoa.common.Constants.PayS.PurchaseRequest.getValue();
                                sign_status = sepoa.common.Constants.SignStatus.Approved.getValue();
                                
                                sqlsb.append("  UPDATE SIVGL SET                         \n");
                                sqlsb.append("      IV_STATUS    = ?                     \n");ps.addStringParameter(status);
                                sqlsb.append("      , PAY_STATUS    = ?                     \n");ps.addStringParameter(sub_status);
                                sqlsb.append("      , SIGN_STATUS    = ?                     \n");ps.addStringParameter(sign_status);
                                sqlsb.append("  WHERE 1 = 1                              \n");
                                sqlsb.append("  AND INV_NUMBER    = ?                     \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                            } else {
                                sqlsb.append("  UPDATE SIVGL SET                      \n");
                                sqlsb.append("      IV_STATUS    = ?                     \n");ps.addStringParameter(status);
                                sqlsb.append("  WHERE 1 = 1                              \n");
                                sqlsb.append("  AND INV_NUMBER    = ?                     \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                                ps.doUpdate ( sqlsb.toString ( ) );
                            }

                        } else if ( "017".equals ( type ) ) {
                            // SIVGL
                            sqlsb.append("  UPDATE SIVGL SET                         \n");
                            sqlsb.append("      ASP_TAX_STATUS    = ?             \n");ps.addStringParameter(status);
                            sqlsb.append("  WHERE 1 = 1                              \n");
                            sqlsb.append("  AND INV_NUMBER    = ?                     \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                            ps.doUpdate ( sqlsb.toString ( ) );
                            
                        } else if ( "021".equals ( type ) ) {
                            // SPOGL
                            sqlsb.append("  UPDATE SPOGL SET                        \n");
                            sqlsb.append("      SIGN_STATUS    = ?                  \n");ps.addStringParameter (status);
                            sqlsb.append("  WHERE 1 = 1                             \n");
                            sqlsb.append("  AND PO_NUMBER    = ?                    \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                            ps.doUpdate ( sqlsb.toString ( ) );
                            
	    		        } else if ( "031".equals ( type ) ) {
	    		            // SSUGL
	    		            sqlsb.append("  UPDATE SSUGL SET                        \n");
	    		            sqlsb.append("      SIGN_STATUS     = ?                 \n");ps.addStringParameter( status );
	    		            sqlsb.append("  WHERE 1 = 1                             \n");
	    		            sqlsb.append("  AND SELLER_CODE     = ?                 \n");ps.addStringParameter(MapUtils.getString( grid, "CODE", "" ));
	    		            
	    		            ps.doUpdate ( sqlsb.toString ( ) );
	    		            
	    		        } else if ( "037".equals ( type ) ) {
	    		            // SRGGL
                            sqlsb.append("  UPDATE SRGGL SET                        \n");
                            sqlsb.append("      SIGN_STATUS    = ?                  \n");ps.addStringParameter (status);
                            sqlsb.append("  WHERE 1 = 1                             \n");
                            sqlsb.append("  AND SELLER_CODE    = ?                  \n");ps.addStringParameter (MapUtils.getString (grid, "CODE" , "" ));
                            sqlsb.append("  AND YEAR           = ?                  \n");ps.addStringParameter (MapUtils.getString (grid, "YEAR" , "" ));
                            ps.doUpdate ( sqlsb.toString ( ) );
	    		            
    	    		    }
	    		    }
	    		}

	    		Commit();
	    		setFlag ( true );
	    		setStatus ( 1 );
	    	}catch (Exception e)
	    	{
	    		Rollback();
	    		setStatus(0);
	    		setFlag(false);
	    		setMessage(e.getMessage());
	    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
	    	}
	    	return getSepoaOut();
	    }
	    
  
		public SepoaOut delMaterialReqDelete( Map allData ) throws Exception {
			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			Map<String, String>         grid        = null;
	        Map<String, String>         header      = null;
	        List<Map<String, String>>   gridData    = null;
			try {
			    gridData         = (List<Map<String,String>>)MapUtils.getObject(allData, "gridData");
			    grid             = (Map <String , String>) gridData.get(0);
				ParamSql sm      = new ParamSql(info.getSession("ID"), this, ctx);
					
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append( "UPDATE SMTGL_TEMP                            \n" );
                sb.append( "  SET DEL_FLAG = ?         \n");sm.addStringParameter( sepoa.fw.util.CommonUtil.Flag.Yes.getValue() );
//				sb.append(" DELETE FROM	SMTGL_TEMP 				\n");
				sb.append(" WHERE 1 = 1							\n");
				sb.append("   AND REQ_MATERIAL_NUMBER = ?		\n");sm.addStringParameter(MapUtils.getString( grid, "REQ_MATERIAL_NUMBER", "" ));//품목코드
				sm.doUpdate( sb.toString() );
					
				setValue(MapUtils.getString( grid, "REQ_MATERIAL_NUMBER", "" ));
				setFlag(true);//SepoaOut객체에 성공유무  FLAG를 셋팅한다.(성공:true, 실패:false)	
				setStatus(1);
				Commit();//저장 후 Commit를 수행한다.(Commit()메소드는 extends한 SepoaService에서 구현된다.)
			} catch (Exception e) {
				setFlag(false);//SepoaOut객체에 성공유무  FLAG를 셋팅한다.(성공:true, 실패:false)
				setMessage(e.getMessage());//SepoaOut객체에 에러메세지를 셋팅한다.
				Rollback();//에러 시 Rollback을 수행한다.(Rollback()메소드는 extends한 SepoaService에서 구현된다.)
				Logger.debug.println(info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName()+ "."+ new Exception().getStackTrace()[0].getMethodName()+ " ERROR:" + e);
			} finally {
			}
			return getSepoaOut();
		}
		
		
		
		 public SepoaOut Watch_doquery( Map< String, String > header ) throws Exception {

		        ConnectionContext ctx = getConnectionContext();// ConnectionContext 객체를 가져온다.(생성은 extends한 SepoaService의 생성자에서 구현된다.)
		        setStatus( 1 );
		        setFlag( true );
		        ParamSql sm = new ParamSql( info.getSession( "ID" ), this, ctx );
		        String language = info.getSession ( "LANGUAGE" );
		        StringBuffer sb = new StringBuffer();

		        try {
		            
		            String from_date    = JSPUtil.getString ( header.get ( "from_date" ) ,"" ).replace ( "-" ,"" );
		            String to_date      = JSPUtil.getString ( header.get ( "to_date" ) ,"" ).replace ( "-" ,"" );
		            String searchCode 	= JSPUtil.getString ( header.get ( "searchCode" ) ,"" );
		            String Process_ID 	= JSPUtil.getString ( header.get ( "Process_ID" ) ,"" );

		            sm.removeAllValue();
		            sb.delete( 0, sb.length() );

		                // SPRGL
		                sb.append(                      " SELECT                                    \n");
		                sb.append(                      " 	  INSTANCE_ID                           \n");
		                sb.append(                      " 	, NUMBER_                                \n");
		                sb.append(                      " 	, THIS_STATUS                           \n");
		                sb.append(                      " 	, GW_STATUS                             \n");
//		                sb.append(                      " 	, NUMBER                                \n");
		                sb.append(                      " FROM SSBMT                                \n");
		                sb.append(   					" WHERE 1=1                                 \n");
		                sb.append(sm.addSelectString(   " 	AND ADD_DATE  BETWEEN  ?	           	\n"));sm.addStringParameter (from_date);
		                sb.append(sm.addSelectString(   " 	AND   ?					 				\n"));sm.addStringParameter (to_date);
		                sb.append(sm.addSelectString(   " 	AND PROCESS_ID  LIKE ('%' || ? || '%')     \n"));sm.addStringParameter (Process_ID);
		                sb.append(sm.addSelectString(	" 	AND NUMBER_  LIKE ('%' || ? || '%')                        \n"));sm.addStringParameter (searchCode);
		                sb.append(   					" ORDER BY INSTANCE_ID DESC                                     \n");

		            setValue( sm.doSelect( sb.toString() ) );// SepoaOut객체에 쿼리 결과값을 셋팅한다.

		        } catch( Exception e ) {
		            setMessage( e.getMessage() );
		            setFlag( false );
		            
		        } finally {
		        }

		        return getSepoaOut();

		    }		
		
		
 public SepoaOut Watch_doSave( List< Map<String, String>>gridData , Map< String, String > header ) throws Exception {
    	
    	ConnectionContext ctx          = getConnectionContext();
    	SepoaFormater sf               = null;
    	String language                = info.getSession("LANGUAGE");
    	StringBuffer sqlsb             = new StringBuffer();
    	Map<String,String> grid = null;	    	
    	
    	try {
    	    
    	    String status = "";
    	    String type = "";
    	    String sub_status = "";
            String sign_status = "";
    	    
    		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
    		
    		if( gridData != null && gridData.size() > 0 ) {
    		    
    		    for( int i = 0; i < gridData.size(); i++ ) {
    		        
    		        grid   = (Map <String , String>)gridData.get( i );
    		        status = JSPUtil.getString ( header.get ( "status" ) , "" );
    		        
                        // SPRGL
                        sqlsb.append("  UPDATE SSBMT SET                        \n");
                        sqlsb.append("      GW_STATUS       = ?                 \n");ps.addStringParameter (status);
                        sqlsb.append("  WHERE 1 = 1                             \n");
                        sqlsb.append("  AND INSTANCE_ID     = ?                 \n");ps.addStringParameter (MapUtils.getString (grid, "INSTANCE_ID" , "" ));
                        sqlsb.append("  AND NUMBER_          = ?                 \n");ps.addStringParameter (MapUtils.getString (grid, "NUMBER" , "" ));
                        ps.doUpdate ( sqlsb.toString ( ) );

    		    }
    		}

    		Commit();
    		setFlag ( true );
    		setStatus ( 1 );
    	}catch (Exception e)
    	{
    		Rollback();
    		setStatus(0);
    		setFlag(false);
    		setMessage(e.getMessage());
    		Logger.err.println(info.getSession("ID"), this, e.getMessage());
    	}
    	return getSepoaOut();
    }
		
	
	}
