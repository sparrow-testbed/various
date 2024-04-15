package ev;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater; 

public class WO_033 extends SepoaService{

	public WO_033(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}

	public String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			s = configuration.get(s);

			return s;
		} catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : "+ configurationexception.getMessage());
		} catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}

		return null;
	}

	public SepoaOut ev_query( String sg_type1, String sg_type2, String sg_type3, String seller_code, String ev_flag, String ev_no  ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_ev_query( sg_type1, sg_type2, sg_type3, seller_code, ev_flag, ev_no );

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
	
	private String[] et_ev_query( String sg_type1, String sg_type2, String sg_type3, String seller_code, String ev_flag, String ev_no ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String cur_date       = SepoaDate.getShortDateString();
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("         SELECT E.VENDOR_CODE                                                  \n ");
			sb.append("               ,E.NAME_LOC AS VENDOR_NAME_LOC                                  \n "); 
			sb.append("         	  ,E.PARENT1                                                      \n "); 
			sb.append("         	  ,E.PARENT2                                                      \n "); 
			sb.append("         	  ,E.SG_REFITEM                                                   \n "); 
			sb.append("         	  ,F.SUBJECT                                                      \n ");
			sb.append("         	  ,F.ST_DATE                                                      \n ");
			sb.append("         	  ,F.END_DATE                                                     \n ");
			sb.append("         	  ,E.EV_NO                                                        \n ");
			sb.append("         	  ,E.EV_YEAR                                                      \n ");
			sb.append("         	  ,G.IN_REFITEM                                                   \n ");
			sb.append("         	  ,G.EV_FLAG                                                      \n ");
			sb.append("         	  ,E.SG_REFITEM_NUM                                               \n ");
			sb.append("         	  ,F.SHEET_STATUS                                                 \n ");
			sb.append("         	  ,F.PERIOD		                                                  \n ");
			sb.append("         FROM (                                                                \n ");
			sb.append("         	  SELECT  A.VENDOR_CODE                                           \n "); 
			sb.append("         		     ,B.VENDOR_NAME_LOC AS NAME_LOC                           \n "); 
			sb.append("         		     ,GETSGNAME2(A.PARENT1)      AS PARENT1                   \n "); 
			sb.append("         		     ,GETSGNAME2(A.PARENT2)      AS PARENT2                   \n "); 
			sb.append("         		     ,GETSGNAME2(A.SG_REFITEM)   AS SG_REFITEM                \n ");
			sb.append("         		     ,C.SG_REGITEM               AS SG_REFITEM_NUM            \n ");
			sb.append("         			 ,C.EV_NO                                                 \n "); 
			sb.append("         			 ,C.EV_YEAR                                               \n "); 
			sb.append("               FROM (                                                          \n ");                                                           
			sb.append("         		  	SELECT  (                                                 \n "); 
			sb.append("         			         SELECT PARENT_SG_REFITEM                         \n ");                                                      
			sb.append("         		  	   	     FROM   SSGGL                                     \n ");                                                 
			sb.append("         		 			 WHERE  SG_REFITEM = B.PARENT_SG_REFITEM          \n "); 
			sb.append(sm.addFixString("         	 AND	  SUBSTR(ADD_DATE,1,4) = ?                \n ")); sm.addStringParameter(cur_date.substring(0,4));
			sb.append("         				     )                    AS PARENT1                  \n ");    	             	        			
			sb.append("         		  			 ,B.PARENT_SG_REFITEM AS PARENT2                  \n ");                                                  
			sb.append("         		  			 ,A.SG_REFITEM                                    \n ");                                                  
			sb.append("         		  			 ,A.VENDOR_CODE       AS VENDOR_CODE              \n ");                                                        
			sb.append("         		  			 ,A.SELLER_SG_REFITEM                             \n ");                                                  
			sb.append("         		  			 ,B.NOTICE_FLAG                                   \n ");                                                  
			sb.append("         		  			 ,A.APPLY_FLAG                                    \n ");                                                  
			sb.append("         		             ,A.DEL_FLAG                                      \n "); 
			sb.append("         		  	FROM 	  SSGGL B                                         \n "); 
			sb.append("         			         ,SSGVN A                                         \n ");                                                 
			sb.append("         		  	WHERE	  1=1                                             \n ");                                                           
			sb.append("         		  	AND     A.SG_REFITEM           = B.SG_REFITEM             \n ");                                                                   
			sb.append("         		  	AND	    B.LEVEL_COUNT          = '3'                      \n "); 
			sb.append(sm.addFixString("     AND	    SUBSTR(B.ADD_DATE,1,4) = ?                        \n ")); sm.addStringParameter(cur_date.substring(0,4)); 
			sb.append(sm.addFixString("     AND	    SUBSTR(A.ADD_DATE,1,4) = ?                        \n ")); sm.addStringParameter(cur_date.substring(0,4));
			sb.append("         			ORDER BY  PARENT1                                         \n "); 
			sb.append("         			         ,PARENT2                                         \n "); 
			sb.append("         			    	 ,SG_REFITEM                                      \n "); 
			sb.append("         			  	     ,VENDOR_CODE                                     \n ");                            
			sb.append("         		   )         A                                                \n "); 
			sb.append("         		   ,ICOMVNGL B                                                \n "); 
			sb.append("         		   ,SEVVN    C                                                \n ");   
			sb.append("         		 WHERE	1=1                                                   \n ");                                                     
			sb.append("         		 AND	A.DEL_FLAG    = 'N'                                   \n ");
			sb.append("         		 AND    C.DEL_FLAG    = 'N'                                   \n ");
			sb.append("         		 AND	A.NOTICE_FLAG = 'Y'                                   \n "); 
			sb.append("         		 AND	A.APPLY_FLAG  = 'Y'                                   \n "); 
			sb.append("         		 AND    A.VENDOR_CODE = B.VENDOR_CODE                         \n "); 
			sb.append("         		 AND    A.SG_REFITEM  = C.SG_REGITEM                          \n "); 
			sb.append("         		 AND    A.VENDOR_CODE = C.SELLER_CODE                         \n ");
			sb.append("         		 AND    B.STATUS IN   ( 'C', 'R' )   						  \n ");
			sb.append(sm.addFixString("  AND    C.EV_YEAR     = ?                                     \n ")); sm.addStringParameter(cur_date.substring(0,4));
			if( !sg_type1.equals("") ){
				sb.append(sm.addFixString(" AND   A.PARENT1    = ?                               \n ")); sm.addStringParameter(sg_type1);
			}
			if( !sg_type2.equals("") ){
				sb.append(sm.addFixString(" AND   A.PARENT2    = ?                               \n ")); sm.addStringParameter(sg_type2);
			}
			if( !sg_type3.equals("") ){
				sb.append(sm.addFixString(" AND   A.SG_REFITEM = ?                               \n ")); sm.addStringParameter(sg_type3);
			}			
			sb.append("          	   )        E                                                \n "); 
			sb.append("                ,SEVGL   F                                                \n ");
			sb.append("         	   ,(                                                        \n ");
			sb.append("         		 SELECT  EV_YEAR                                         \n ");
			sb.append("         		        ,EV_NO                                           \n ");
			sb.append("         		        ,VENDOR_CODE                                     \n ");
			sb.append("         		        ,MAX(IN_REFITEM) AS IN_REFITEM                   \n ");
			sb.append("         		        ,MAX(EV_FLAG)    AS EV_FLAG                      \n ");
			sb.append("         		        ,SG_REGITEM                                      \n ");
			sb.append("         		FROM    SINVN                                            \n ");
			sb.append("         		WHERE   DEL_FLAG = 'N'                                   \n ");
			sb.append("         		GROUP BY VENDOR_CODE                                     \n ");
			sb.append("         		        ,EV_NO                                           \n ");
			sb.append("         		        ,EV_YEAR                                         \n ");
			sb.append("         		        ,SG_REGITEM                                      \n ");
			sb.append("         		    )        G                                           \n ");			
			sb.append("         WHERE E.EV_NO          = F.EV_NO                                 \n "); 
			sb.append("         AND   E.EV_YEAR        = F.EV_YEAR                               \n ");
			sb.append("         AND   E.EV_NO          = G.EV_NO(+)                              \n ");
			sb.append("         AND   E.EV_YEAR        = G.EV_YEAR(+)                            \n ");
			sb.append("         AND   E.VENDOR_CODE    = G.VENDOR_CODE(+)                        \n ");
			sb.append("         AND   E.SG_REFITEM_NUM = G.SG_REGITEM(+)                         \n ");
			sb.append(sm.addSelectString("AND   E.VENDOR_CODE = ?                                \n ")); sm.addStringParameter(seller_code);
			sb.append(sm.addSelectString("AND   G.EV_FLAG     = ?                                \n ")); sm.addStringParameter(ev_flag);
			sb.append(sm.addSelectString("AND   E.EV_NO       = ?                                \n ")); sm.addStringParameter(ev_no);
			sb.append("         AND   F.SHEET_STATUS   = 'C'                                     \n ");
			sb.append("         ORDER BY F.EV_NO                                     \n ");
			
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
	
	public SepoaOut ev_insert(String[][] straData, String p_start_setting, String p_ends_setting, String APPROVAL_STR) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_ev_insert(straData, p_start_setting, p_ends_setting, APPROVAL_STR);

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
	
	private String[] et_ev_insert( String[][] straData, String p_start_setting, String p_ends_setting, String APPROVAL_STR ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;	
		SepoaFormater sf1     = null;
		String user_id        = info.getSession("ID");
		String cur_date       = SepoaDate.getShortDateString();
		
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			//등록자별
        	String[] split_1 = APPROVAL_STR.split(" #");
        	
        	for( int k = 0; k < split_1.length; k++ ){
        		String[] split_2 = split_1[k].split(" ,");
        		Logger.sys.println("split_1["+k+"] = " + split_1[k]);
        		Logger.sys.println(" ");
        		Logger.sys.println("split_2.length = " + split_2.length);
				Logger.sys.println("split_2[0]     = " + split_2[0]);
				Logger.sys.println("split_2[1]     = " + split_2[1]);
        		//업체별
				for ( int a = 0; a < straData.length; a++ ){
					sm.removeAllValue();
					sb.delete( 0, sb.length() );
					sb.append("	UPDATE SINVN SET ST_DATE         = ?		\n "); sm.addStringParameter(p_start_setting);
					sb.append("	                ,ET_DATE         = ?        \n "); sm.addStringParameter(p_ends_setting);
					sb.append("	           WHERE VENDOR_CODE     = ?        \n "); sm.addStringParameter(straData[a][0]);
					sb.append("			   AND   EV_YEAR         = ?        \n "); sm.addStringParameter(straData[a][9]);
					sb.append("			   AND   EV_NO           = ?        \n "); sm.addStringParameter(straData[a][8]);
					sb.append("			   AND   SG_REGITEM      = ?	    \n "); sm.addNumberParameter(straData[a][12]);
					sm.doUpdate(sb.toString());	
					
					sm.removeAllValue();
					sb.delete( 0, sb.length() );
					sb.append("		                SELECT A.EV_SEQ                   	 \n ");
					sb.append("		                      ,B.EV_DSEQ                  	 \n ");
					sb.append("			                  ,C.EV_REQSEQ                	 \n ");
					sb.append("		                FROM   SEVLN   A                  	 \n ");
					sb.append("		                      ,SEVDT   B                  	 \n ");
					sb.append("			                  ,SSREQ   C                  	 \n ");
					sb.append(sm.addFixString("		WHERE  A.EV_NO    = ? 	 			 \n ")); sm.addStringParameter(straData[a][8]);
					sb.append(sm.addFixString("		AND    A.EV_YEAR  = ?	         	 \n ")); sm.addStringParameter(straData[a][9]);
					sb.append("		                AND    A.EV_NO    = B.EV_NO        	 \n ");
					sb.append("		                AND    A.EV_YEAR  = B.EV_YEAR      	 \n ");
					sb.append("		                AND    A.EV_SEQ   = B.EV_SEQ       	 \n ");
					sb.append("		                AND    A.EV_NO    = C.EV_NO        	 \n ");
					sb.append("		                AND    A.EV_YEAR  = C.EV_YEAR        \n ");
					sb.append("		                AND    A.EV_SEQ   = C.EV_SEQ         \n ");
					sb.append("		                AND    A.EV_SEQ   = C.EV_SEQ         \n ");
					sb.append("		                AND    A.DEL_FLAG = 'N'          	 \n ");
					sb.append("		                AND    B.DEL_FLAG = 'N'          	 \n ");
					sb.append("		                AND    C.DEL_FLAG = 'N'          	 \n ");
					
					sf = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
					//INSERT OR UPDATE
					for( int j = 0; j < sf.getRowCount(); j++ ){
//						System.out.println( "EV_SEQ     = " + sf.getValue("EV_SEQ", j) );
//						System.out.println( "EV_DSEQ    = " + sf.getValue("EV_DSEQ", j) );
//						System.out.println( "EV_REQSEQ  = " + sf.getValue("EV_REQSEQ", j) );
						
						sm.removeAllValue();
						sb.delete( 0, sb.length() );					
						sb.append("		                 SELECT COUNT(*) AS CNT                       \n ");
						sb.append("		                 FROM  SINVN                                  \n ");
						sb.append("		                 WHERE 1=1                                    \n "); 
						sb.append(sm.addSelectString("   AND   VENDOR_CODE     = ?                    \n ")); sm.addStringParameter(straData[a][0]);
						sb.append(sm.addSelectString("	 AND   EV_YEAR         = ?                    \n ")); sm.addStringParameter(straData[a][9]);
						sb.append(sm.addSelectString("	 AND   EV_NO           = ?                    \n ")); sm.addStringParameter(straData[a][8]);
						sb.append(sm.addSelectString("	 AND   EV_SEQ          = ?                    \n ")); sm.addStringParameter(sf.getValue("EV_SEQ", j));
						sb.append(sm.addSelectString("	 AND   EV_DSEQ         = ?                    \n ")); sm.addStringParameter(sf.getValue("EV_DSEQ", j));
						sb.append(sm.addSelectString("	 AND   EV_REQSEQ       = ?                    \n ")); sm.addStringParameter(sf.getValue("EV_REQSEQ", j));
						sb.append(sm.addSelectString("	 AND   SG_REGITEM      = ?	                  \n ")); sm.addNumberParameter(straData[a][12]);
						sb.append("		                 AND   DEL_FLAG        = 'N'	              \n ");
						sb.append(sm.addSelectString("	 AND   EVAL_ID         = ?	                  \n ")); sm.addStringParameter(split_2[1]);
						sf1 = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
						
						if( Integer.parseInt( sf1.getValue("CNT",0) ) > 0 ){
						//if( !straData[a][11].equals("") ){
							sm.removeAllValue();
							sb.delete( 0, sb.length() );
							sb.append("	UPDATE SINVN SET ST_DATE         = ?		\n "); sm.addStringParameter(p_start_setting);
							sb.append("	                ,ET_DATE         = ?        \n "); sm.addStringParameter(p_ends_setting);
							sb.append("					,EV_FLAG         = ?        \n "); sm.addStringParameter(straData[a][10]);
							sb.append("					,CHANGE_DATE     = ?        \n "); sm.addStringParameter(cur_date);
							sb.append("					,CHANGE_USER_ID  = ?        \n "); sm.addStringParameter(user_id);
							sb.append("					,REG_DATE        = ''       \n ");
							sb.append("	           WHERE VENDOR_CODE     = ?        \n "); sm.addStringParameter(straData[a][0]);
							sb.append("			   AND   EV_YEAR         = ?        \n "); sm.addStringParameter(straData[a][9]);
							sb.append("			   AND   EV_NO           = ?        \n "); sm.addStringParameter(straData[a][8]);
							sb.append("			   AND   EV_SEQ          = ?        \n "); sm.addStringParameter(sf.getValue("EV_SEQ", j));
							sb.append("			   AND   EV_DSEQ         = ?        \n "); sm.addStringParameter(sf.getValue("EV_DSEQ", j));
							sb.append("			   AND   EV_REQSEQ       = ?	    \n "); sm.addStringParameter(sf.getValue("EV_REQSEQ", j));
							sb.append("			   AND   SG_REGITEM      = ?	    \n "); sm.addNumberParameter(straData[a][12]);
							sb.append("			   AND   EVAL_ID         = ?	    \n "); sm.addStringParameter(split_2[1]);
							sm.doUpdate(sb.toString());	
						}
						else{
							sm.removeAllValue();
							sb.delete( 0, sb.length() );
							sb.append("	INSERT INTO SINVN (                    \n ");
							sb.append("	  				   IN_REFITEM          \n ");
							sb.append("					  ,VENDOR_CODE         \n ");
							sb.append("					  ,EV_YEAR             \n ");
							sb.append("					  ,EV_NO               \n ");
							sb.append("					  ,EV_SEQ              \n ");
							sb.append("					  ,EV_DSEQ             \n ");
							sb.append("					  ,EV_REQSEQ           \n ");
							sb.append("					  ,SG_REGITEM          \n ");
							sb.append("					  ,VENDOR_NAME         \n ");
							sb.append("	 				  ,ADD_DATE            \n ");
							sb.append("					  ,ADD_USER_ID         \n ");
							sb.append("	 				  ,ST_DATE             \n ");
							sb.append("					  ,ET_DATE             \n ");
							sb.append("					  ,EV_FLAG             \n ");
							sb.append("					  ,EVAL_ID             \n ");
							sb.append("					  )                    \n ");
							sb.append("			   VALUES (                    \n ");
							sb.append("			           ( SELECT DECODE(MAX(IN_REFITEM),NULL,1,MAX(IN_REFITEM)+1) AS CNT FROM SINVN )  \n ");  
							sb.append("			          ,?                   \n "); sm.addStringParameter(straData[a][0]);
							sb.append("			          ,?                   \n "); sm.addStringParameter(straData[a][9]);
							sb.append("			          ,?                   \n "); sm.addStringParameter(straData[a][8]);
							sb.append("			          ,?                   \n "); sm.addStringParameter(sf.getValue("EV_SEQ", j));
							sb.append("			          ,?                   \n "); sm.addStringParameter(sf.getValue("EV_DSEQ", j));
							sb.append("			          ,?                   \n "); sm.addStringParameter(sf.getValue("EV_REQSEQ", j));
							sb.append("			          ,?                   \n "); sm.addNumberParameter(straData[a][12]);
							sb.append("			          ,?                   \n "); sm.addStringParameter(straData[a][1]);
							sb.append("			          ,?                   \n "); sm.addStringParameter(cur_date);
							sb.append("			          ,?                   \n "); sm.addStringParameter(user_id);
							sb.append("			          ,?                   \n "); sm.addStringParameter(p_start_setting);
							sb.append("			          ,?                   \n "); sm.addStringParameter(p_ends_setting);
							sb.append("			          ,?                   \n "); sm.addStringParameter(straData[a][10]);
							sb.append("			          ,?                   \n "); sm.addStringParameter(split_2[1]);							
							sb.append("			          )                    \n ");
							sm.doInsert(sb.toString());
						}
						
					}
					
					if( k == 0 ){ // 업체마다 1번씩
			        	if(getConfig("sepoa.server.development.flag").equals("false")){
							sm.removeAllValue();
							sb.delete( 0, sb.length() );
							sb.append("           	  SELECT  B.VENDOR_CODE                                 \n");
							sb.append("           		     ,B.NAME_LOC                                \n");
							sb.append("                      ,C.MOBILE_NO                                   \n");
							sb.append("                 FROM ICOMVNGL B                                     \n");
							sb.append("                    , ICOMVNCP C                                     \n");
							sb.append("           		 WHERE	 B.HOUSE_CODE = C.HOUSE_CODE            \n");
							sb.append("           		 AND B.VENDOR_CODE = C.VENDOR_CODE              \n");
							sb.append(sm.addSelectString("   AND   B.VENDOR_CODE     = ? 	\n ")); sm.addStringParameter(straData[a][0]);
							sf = new SepoaFormater( sm.doSelect_limit( sb.toString() ) );
							//INSERT OR UPDATE
							for( int s = 0; s < sf.getRowCount(); s++ ){
								setSmsData(sf.getValue("MOBILE_NO", s));
							}
			        	}
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

	public SepoaOut ev_sms_query(String ev_no  ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_ev_sms_query( ev_no );

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
	
	private String[] et_ev_sms_query(String ev_no  ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String cur_date       = SepoaDate.getShortDateString();
		String company_code   = info.getSession("COMPANY_CODE");
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.append(" SELECT E.VENDOR_CODE						\n");
			sb.append(" 	,E.NAME_LOC  AS seller_name                                 \n");
			sb.append(" 	,F.SUBJECT                                                      \n");
			sb.append(" 	,E.EV_NO                                                        \n");
			sb.append(" 	,E.MOBILE_NO  AS seller_tel                                    \n");
			sb.append(" 	,getDateFormat(G.ST_DATE) AS ST_DATE                                                      \n");
			sb.append(" 	,getDateFormat(G.ET_DATE) AS ET_DATE                                                      \n");
			sb.append(" 	,'우리은행' AS  sender_name                                                        \n");
			sb.append(" 	,(SELECT PHONE_NO FROM              \n");
			sb.append(sm.addFixString("  ICOMCMGL WHERE COMPANY_CODE = ? \n ")); sm.addStringParameter(company_code);
			sb.append(" 	  )	AS sender_tel                    \n");                                               
			sb.append(" FROM (                                                              \n");
			sb.append("           	  SELECT  B.VENDOR_CODE                                 \n");
			sb.append("           		     ,B.NAME_LOC                                \n");
			sb.append("                      ,C.MOBILE_NO                                   \n");
			sb.append("           			 ,D.EV_YEAR                             \n");
			sb.append("           			 ,D.EV_NO                               \n");
			sb.append("                 FROM ICOMVNGL B                                     \n");
			sb.append("                    , ICOMVNCP C                                     \n");
			sb.append("           		   , SEVVN    D                                 \n");
			sb.append("           		 WHERE	 B.HOUSE_CODE = C.HOUSE_CODE            \n");
			sb.append("           		 AND B.VENDOR_CODE = C.VENDOR_CODE              \n");
			sb.append("           		 AND B.VENDOR_CODE = D.SELLER_CODE              \n");
			sb.append(sm.addFixString("  AND    D.EV_YEAR     = ?     )        E                   \n ")); sm.addStringParameter(cur_date.substring(0,4));
			sb.append("                  ,SEVGL   F                                         \n");
			sb.append("           	     ,( SELECT  EV_YEAR                                 \n");
			sb.append("           		        ,EV_NO                                  \n");
			sb.append("           		        ,VENDOR_CODE                            \n");
			sb.append("           		        ,max(ST_DATE)  as ST_DATE               \n");
			sb.append("           		        ,max(ET_DATE)  as ET_DATE               \n");
			sb.append("           		        ,MAX(EV_FLAG)    AS EV_FLAG             \n");
			sb.append("           			FROM    SINVN                           \n");
			sb.append("           			WHERE   DEL_FLAG = 'N'                  \n");
			sb.append("           			GROUP BY VENDOR_CODE                    \n");
			sb.append("           		        ,EV_NO                                  \n");
			sb.append("           		        ,EV_YEAR                                \n");
			sb.append("           		        ,SG_REGITEM                             \n");
			sb.append("           		    )        G                                  \n");
			sb.append("           WHERE E.EV_NO          = F.EV_NO                          \n");
			sb.append("           AND   E.EV_YEAR        = F.EV_YEAR                        \n");
			sb.append("           AND   E.EV_NO          = G.EV_NO(+)                       \n");
			sb.append("           AND   E.EV_YEAR        = G.EV_YEAR(+)                     \n");
			sb.append("           AND   E.VENDOR_CODE    = G.VENDOR_CODE(+)                 \n");
			sb.append("           AND   G.EV_FLAG     = 'Y'                                 \n");
			sb.append(sm.addSelectString("AND   E.EV_NO       = ?                                \n ")); sm.addStringParameter(ev_no);
			sb.append("           AND   F.SHEET_STATUS   = 'C'                              \n");
			sb.append("           ORDER BY F.EV_NO                                          \n");
 
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

	private void setSmsData( String mobile_no) throws Exception
	{

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		SepoaFormater sf = null; 
		ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

		sm.removeAllValue();
		sqlsb.delete(0, sqlsb.length());
		sqlsb.append("  SELECT										\n");
		sqlsb.append("  	 TEXT1                                  \n");
		sqlsb.append("  FROM  SCODE                       			\n");
		sqlsb.append("   WHERE TYPE = 'M314'	 					\n");
		sqlsb.append("  AND DEL_FLAG = 'N'                          \n");
		sqlsb.append("  AND CODE = 'EV'                             \n");
		sqlsb.append("  AND USE_FLAG = 'Y'                          \n");
		sf = new SepoaFormater(sm.doSelect(sqlsb.toString()));

		String message = sf.getValue("TEXT1", 0); 
		
		String hostname		   =    getConfig("sepoa.sms.hostname");
		int port		       =    Integer.parseInt(getConfig("sepoa.sms.port"));

		//SmsClient cl = new SmsClient(hostname, port, mobile_no, message);
	}
}	

