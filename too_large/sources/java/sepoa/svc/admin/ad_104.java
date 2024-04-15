package sepoa.svc.admin;

import java.util.HashMap ;
import java.util.List ;
import java.util.Map ;
import java.util.Vector ;

import org.apache.commons.collections.MapUtils ;

import sepoa.fw.cfg.Configuration ;
import sepoa.fw.cfg.ConfigurationException ;
import sepoa.fw.db.ConnectionContext ;
import sepoa.fw.db.ParamSql ;
import sepoa.fw.log.Logger ;
import sepoa.fw.msg.* ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.SepoaService ;
import sepoa.fw.srv.SepoaServiceException ;
import sepoa.fw.msg.* ;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.svc.common.constants ;

public class AD_104 extends SepoaService {
	private String ID = info.getSession("ID");

	//20131211 sendakun
    private HashMap msg = null;

	public AD_104(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	    
		//20131211 sendakun
        try {
            msg = MessageUtil.getMessageMap( info, "MESSAGE","AD_104");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }
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

	public SepoaOut doQuery( Map< String, Object > allData) throws Exception {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		String language = info.getSession("LANGUAGE");
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME	= SepoaDate.getShortTimeString();
		String SELLER_CODE = info.getSession("COMPANY_CODE");

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;
		try {
			setStatus(1);
			setFlag(true);
            headerData  = MapUtils.getMap( allData, "headerData", null );
			
			ps.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append(" SELECT 												\n");
			sqlsb.append(" 			USE_FLAG	      			 --사용여부  		\n");
			sqlsb.append(" 			,TEXT3   AS LKIND            --레벨1			\n");
			sqlsb.append(" 			,(SELECT TEXT1 FROM SLVEL WHERE TYPE = '" + constants.LevelCode.FIRST.getValue() + "' AND CODE = DE.TEXT3)   AS LKIND_TXT            --레벨1			\n");
			sqlsb.append(" 			,CODE    AS CKIND            --레벨2 		\n");
			sqlsb.append(" 			,TEXT1  AS CKIND_TXT         --레벨2명 		\n");
			sqlsb.append(" 			,SORT_SEQ                    --순서 		    \n");
            sqlsb.append("          ,DEL_FLAG                   --삭제            \n");
            sqlsb.append("          ,ADD_USER_ID   --생성자            \n");
			sqlsb.append(" FROM SLVEL DE              							\n");
		    sqlsb.append(" WHERE 1=1 \n");
		    sqlsb.append(" AND "+DB_NULL_FUNCTION+"(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'    \n");
            sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE"));
            sqlsb.append(ps.addSelectString(" AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue());
			sqlsb.append(ps.addSelectString(" AND UPPER(TEXT3) = UPPER(?)               						\n"));
			ps.addStringParameter(MapUtils.getString( headerData,    "LKIND",     "" ));
			if(SEPOA_DB_VENDOR.equals("ORACLE")){
				sqlsb.append(" ORDER BY CODE               				\n");
			}else{
				//sqlsb.append(" ORDER BY CONVERT(INT,CODE)              				\n");
			} 
			
			setValue(ps.doSelect(sqlsb.toString()));
            setMessage( MessageUtil.getMessage( info, "MESSAGE.0001" ) );
		} 
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
            setMessage( MessageUtil.getMessage( info, "MESSAGE.1002" ) );
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut doRegist( Map< String, Object > allData ) throws Exception {
		String MSG = "";
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME	= SepoaDate.getShortTimeString();
		String LANGUAGE = info.getSession("LANGUAGE");
		
		String USE_FLAG = "";
		String LKIND = "";
		String CKIND = "";
		String CKIND_TXT = "";
        String SKIND        = "";
        String SSKIND       = "";
		String SORT_SEQ = "1";

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
		
		try {
			setStatus(1);
			setFlag(true);
            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

            for( int i = 0; i < gridData.size(); i++ ) {
            	
                gridRowData = gridData.get( i );	
				USE_FLAG 	= MapUtils.getString( gridRowData,    "USE_FLAG",    "" ); 
				if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
				else					 USE_FLAG = "N";
				LKIND       = MapUtils.getString( gridRowData,    "LKIND",    "" ) ;
				CKIND 	    = MapUtils.getString( gridRowData,    "CKIND",    "" ); 
				CKIND_TXT 	= MapUtils.getString( gridRowData,    "CKIND_TXT",    "" ) ;
				
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT COUNT(*) CNT       					\n");
                sqlsb.append(" FROM SLVEL    \n");
                sqlsb.append(" WHERE 1=1 \n");
                sqlsb.append(ps.addSelectString(" AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue());
	            sqlsb.append(ps.addSelectString(" AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
				sqlsb.append(ps.addSelectString(" AND CODE = ?  			    \n"));
				ps.addStringParameter(CKIND);
				SepoaFormater wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
				String CNT = "";
				if(wf.getRowCount()>0){
					CNT = wf.getValue("CNT",0);
				}
				
				if(!CNT.equals("0")){
					try {
						Rollback();
					} catch (SepoaServiceException e1) {
						Logger.err.println(info.getSession("ID"), this, e1.getMessage());
					}
					setStatus(0);
					setFlag(false);
					//setMessage("레벨2에 중복된 데이터를 입력하셨습니다.");
                    setMessage( msg.get( "MESSAGE.4002" ).toString().replace("{1}", CKIND) );
					return getSepoaOut();
				}
				
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT COUNT(*) CNT       					\n");
                sqlsb.append(" FROM SLVEL    \n");
                sqlsb.append(" WHERE 1=1 \n");
                sqlsb.append(ps.addSelectString(" AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue());
	            sqlsb.append(ps.addSelectString(" AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
				sqlsb.append(ps.addSelectString(" AND   TEXT3 = ?  				\n"));ps.addStringParameter(LKIND);
				wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
				if(wf.getRowCount()>0){
					CNT = wf.getValue("CNT",0);
				}

				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT MAX(TO_NUMBER(SORT_SEQ))+1   \n");
                sqlsb.append(" FROM SLVEL    \n");
                sqlsb.append(" WHERE 1=1 \n");
                sqlsb.append(ps.addSelectString(" AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue());
	            sqlsb.append(ps.addSelectString(" AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
                sqlsb.append(ps.addSelectString(" AND   TEXT3 = ?               \n"));ps.addStringParameter(LKIND);
				wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
				if(wf.getRowCount()>0){
					SORT_SEQ = wf.getValue(0,0);
				}
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("INSERT INTO SLVEL       					\n");
				sqlsb.append("		(                               		\n");
                sqlsb.append("           COMPANY_CODE           \n");
                sqlsb.append("          ,TYPE                           \n");
				sqlsb.append("   	    ,CODE                  		\n");
				sqlsb.append("   	    ,LANGUAGE                     		\n");
				sqlsb.append("   	    ,ADD_DATE                  		\n");
				sqlsb.append("   	    ,ADD_TIME             			\n");
				sqlsb.append("   	    ,ADD_USER_ID                  	 		\n");
				sqlsb.append("   	    ,SORT_SEQ             	     	\n");
				sqlsb.append("   	    ,USE_FLAG               			\n");
				sqlsb.append("   	    ,TEXT1                    		\n");
				sqlsb.append("   	    ,TEXT2                			\n");
                sqlsb.append("          ,TEXT3                          \n"); //레벨2
                sqlsb.append("          ,TEXT4                          \n"); //레벨3
                sqlsb.append("          ,TEXT5                          \n"); //레벨4
                sqlsb.append("          ,TEXT6                          \n"); //레벨5
				sqlsb.append("   	    ,DEL_FLAG               	    		\n");
				sqlsb.append("   	)                               		\n");
				sqlsb.append("VALUES                                			\n");
				sqlsb.append("		(                               		\n");
                sqlsb.append("             ?                               \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
                sqlsb.append("          ,  ?                                \n");				ps.addStringParameter(constants.LevelCode.SECOND.getValue());
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(CKIND);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(LANGUAGE);
				sqlsb.append("   	    ,?						\n");				ps.addStringParameter(ADD_DATE);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(ADD_TIME);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(ADD_USER_ID);
				if(CNT.equals("0")){
					sqlsb.append("   	    ,  '1' 	                    		\n");
				}else{
					if(SEPOA_DB_VENDOR.equals("ORACLE")){
						sqlsb.append("   	    ,  (SELECT MAX(SORT_SEQ)+1  \n");
		                sqlsb.append(" FROM SLVEL    \n");
		                sqlsb.append(" WHERE 1=1 \n");
		                sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE"));
                        sqlsb.append(ps.addSelectString("AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue()); 
                        sqlsb.append(ps.addSelectString("AND TEXT3 = ?)      \n"));ps.addStringParameter(LKIND);  
					}else{
						sqlsb.append("   	    ,  ? 	                    		\n");ps.addStringParameter(SORT_SEQ);
					} 
				}  
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(USE_FLAG);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(CKIND_TXT);
				sqlsb.append("   	    ,  ? 					\n");				ps.addStringParameter(CKIND_TXT);
                sqlsb.append("          ,  ?                    \n");ps.addStringParameter(LKIND);
                sqlsb.append("          ,  ?                    \n");ps.addStringParameter(CKIND);
                sqlsb.append("          ,  ?                                \n");ps.addStringParameter(SKIND);
                sqlsb.append("          ,  ?                                \n");ps.addStringParameter(SSKIND);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter("N");
				sqlsb.append("   	)                               		\n");
				
				ps.doInsert(sqlsb.toString());
				
				Map< String, String > CodeData = new HashMap< String, String >();
				CodeData.put("CODE_TYPE","C"      );
				CodeData.put("CODE"     ,CKIND    );
				CodeData.put("P_CODE"   ,LKIND    );
				CodeData.put("CODE_NAME",CKIND_TXT);
				
				// I/F
				SepoaOut value = setCodeInfo(CodeData);
				
				if(!value.flag){
					setFlag(false);
					setStatus(0);
					Rollback();
				}else{
					Commit();
				}
				
				if(value.message.length()>0){
					MSG += value.message+"\n";
				}else{
                    //0084 : 인터페이스중 오류가 발생했습니다.
                    MSG += "Code["+CKIND+"] "+msg.get("MESSAGE.0084")+"\n";
				}
            }//for end
            setMessage(MSG);
		} 
		catch (Exception e)
		{
			try {
				Rollback();
			} catch (SepoaServiceException e1) {
				Logger.err.println(info.getSession("ID"), this, e1.getMessage());
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut doDelete(Map< String, Object > allData) {
		String MSG = "";
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME	= SepoaDate.getShortTimeString();
		String LANGUAGE = info.getSession("LANGUAGE");
		
		String USE_FLAG = "";
		String LKIND = "";
		String CKIND = "";
		String CKIND_TXT = "";

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
		try {
			setStatus(1);
			setFlag(true);
            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

            for( int i = 0; i < gridData.size(); i++ ) {
            	
                gridRowData = gridData.get( i );	
				USE_FLAG 	= MapUtils.getString( gridRowData,    "USE_FLAG",    "" ); 
				if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
				else					 USE_FLAG = "N";
				LKIND       = MapUtils.getString( gridRowData,    "LKIND",    "" ) ;
				CKIND 	    = MapUtils.getString( gridRowData,    "CKIND",    "" ); 
				CKIND_TXT 	= MapUtils.getString( gridRowData,    "CKIND_TXT",    "" ) ;
				 
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT COUNT(*) AS CNT FROM SLVEL       					\n");
				sqlsb.append("WHERE TYPE = '" + constants.LevelCode.THIRD.getValue() + "'  						\n");
                sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
				sqlsb.append(ps.addSelectString("AND TEXT3+TEXT4 = ?  			 \n"));ps.addStringParameter(CKIND);
				
				int COUNT = 0;
				SepoaFormater temp_sf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
				if(temp_sf.getRowCount()>0){
					COUNT = Integer.parseInt(temp_sf.getValue("CNT",0));
				}
				
				if(COUNT>0){
				    //하위분류에 등록된 항목이 있어 삭제할수 없습니다.
                    setMessage(msg.get("AD_104.0000").toString());
					setStatus(0);
					setFlag(false);
					return getSepoaOut();
				}
				else{
					ps.removeAllValue();
					sqlsb.delete(0, sqlsb.length());
					sqlsb.append("SELECT COUNT(*) AS CNT FROM SSGSL       					\n");
					sqlsb.append("WHERE 1=1  						\n");
                    sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
					sqlsb.append(ps.addSelectString("AND SG_CODE2 = ?  			    			\n"));
					ps.addStringParameter(CKIND);
					
					int COUNT2 = 0;
					SepoaFormater temp_sf1 = new SepoaFormater(ps.doSelect(sqlsb.toString()));
					if(temp_sf1.getRowCount()>0){
						COUNT2 = Integer.parseInt(temp_sf1.getValue("CNT",0));
					}
					
					if(COUNT2>0){
					    //공급업체에 연결된 항목이 있어 삭제할수 없습니다.
                        setMessage(msg.get ( "AD_104.0001" ).toString());
						setStatus(0);
						setFlag(false);
						return getSepoaOut();
					}
				}

				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("DELETE FROM SLVEL       					\n");
                sqlsb.append(" WHERE 1=1 \n");
                sqlsb.append(" AND TYPE = ?       \n");ps.addStringParameter(constants.LevelCode.SECOND.getValue());
                sqlsb.append("AND COMPANY_CODE = ?           \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
				sqlsb.append("AND CODE = ?  			    			\n");ps.addStringParameter(CKIND);
				sqlsb.append("AND TEXT1 = ?  			    			\n");ps.addStringParameter(CKIND_TXT);
				ps.doDelete(sqlsb.toString());
				
				Map< String, String > CodeData = new HashMap< String, String >();
				CodeData.put("CODE_TYPE","D"      );
				CodeData.put("CODE"     ,CKIND    );
				CodeData.put("P_CODE"   ,LKIND    );
				CodeData.put("CODE_NAME",CKIND_TXT);
				
				// I/F
				SepoaOut value = setCodeInfo(CodeData);
				
				if(!value.flag){
					setFlag(false);
					setStatus(0);
					Rollback();
				}else{
					Commit();
				}
				if(value.message.length()>0){
					MSG += value.message+"\n";
				}else{
                    //0084 : 인터페이스중 오류가 발생했습니다.
                    MSG += "Code["+CKIND+"] "+msg.get("MESSAGE.0084")+"\n";
				}
				
            }//for end
            
            setMessage(MSG);
		} 
		catch (Exception e)
		{
			try {
				Rollback();
			} catch (SepoaServiceException e1) {
				Logger.err.println(info.getSession("ID"), this, e1.getMessage());
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	public SepoaOut doUpdate(Map< String, Object > allData) {
		String MSG = "";
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		
		String ADD_USER_ID = info.getSession("ID");
		String ADD_DATE = SepoaDate.getShortDateString();
		String ADD_TIME	= SepoaDate.getShortTimeString();
		String LANGUAGE = info.getSession("LANGUAGE");
		
		String USE_FLAG = "";
		String LKIND = "";
		String CKIND = "";
		String CKIND_TXT = "";
        String DEL_FLAG = "";

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
		try {
			setStatus(1);
			setFlag(true);
            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

            for( int i = 0; i < gridData.size(); i++ ) {
            	
                gridRowData = gridData.get( i );	
				USE_FLAG 	= MapUtils.getString( gridRowData,    "USE_FLAG",    "" ); 
				if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
				else					 USE_FLAG = "N";
				LKIND       = MapUtils.getString( gridRowData,    "LKIND",    "" );
				CKIND 	    = MapUtils.getString( gridRowData,    "CKIND",    "" );
				CKIND_TXT 	= MapUtils.getString( gridRowData,    "CKIND_TXT",    "" );
                DEL_FLAG       = MapUtils.getString( gridRowData,   "DEL_FLAG",         "" );

                ps.removeAllValue();
                sqlsb.delete(0, sqlsb.length());
                sqlsb.append("UPDATE SLVEL SET                \n");
                sqlsb.append("       CHANGE_DATE    = ?       \n"); ps.addStringParameter(ADD_DATE);
                sqlsb.append("      ,CHANGE_TIME    = ?       \n"); ps.addStringParameter(ADD_TIME);
                sqlsb.append("      ,CHANGE_USER_ID = ?       \n"); ps.addStringParameter(ADD_USER_ID);
                sqlsb.append("      ,USE_FLAG       = ?       \n"); ps.addStringParameter(USE_FLAG);
                sqlsb.append("      ,TEXT1          = ?       \n"); ps.addStringParameter(CKIND_TXT);
                sqlsb.append("      ,TEXT2          = ?       \n"); ps.addStringParameter(CKIND_TXT);
                sqlsb.append("      ,TEXT3          = ?       \n"); ps.addStringParameter(LKIND);
                sqlsb.append("      ,TEXT4          = ''       \n");
                sqlsb.append("      ,TEXT5          = ''       \n");
                sqlsb.append("      ,TEXT6          = ''       \n");
                sqlsb.append("      ,DEL_FLAG          = ?       \n"); ps.addStringParameter(DEL_FLAG);
                sqlsb.append(" WHERE 1=1 \n");
                sqlsb.append(" AND TYPE = ?       \n");ps.addStringParameter(constants.LevelCode.SECOND.getValue());
                sqlsb.append(" AND COMPANY_CODE = ?    \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
                sqlsb.append(" AND CODE = ?                 \n"); ps.addStringParameter(CKIND);
                ps.doUpdate(sqlsb.toString());

				Map< String, String > CodeData = new HashMap< String, String >();
				CodeData.put("CODE_TYPE","U"      );
				CodeData.put("CODE"     ,CKIND    );
				CodeData.put("P_CODE"   ,LKIND    );
				CodeData.put("CODE_NAME",CKIND_TXT);
				
				// I/F
				SepoaOut value = setCodeInfo(CodeData);
				
				if(!value.flag){
					setFlag(false);
					setStatus(0);
					Rollback();
				}else{
					Commit();
				}
				
				if(value.message.length()>0){
					MSG += value.message+"\n";
				}else{
                    //0084 : 인터페이스중 오류가 발생했습니다.
                    MSG += "Code["+CKIND+"] "+msg.get("MESSAGE.0084")+"\n";
				}
				
            }//for end
            
            setMessage(MSG);
		} 
		catch (Exception e)
		{
			try {
				Rollback();
			} catch (SepoaServiceException e1) {
				Logger.err.println(info.getSession("ID"), this, e1.getMessage());
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	 /**
     * 카테고리 변경시 I/F
     * 
     * @param headerData
     * @return
     */
    public SepoaOut setCodeInfo( Map< String, String > CodeData ) {
        String  strValue    = "";

        try {
            setStatus( 1 );
            setFlag( true );

//            MMIF0220 mmif0220    = new MMIF0220( "NONDBJOB", info );
//            mmif0220.setConnectionContext( getConnectionContext() );
//            SepoaOut value = mmif0220.main( CodeData );
            SepoaOut value = new SepoaOut();
            value.message = "Successed";
            value.status = 1;
            setMessage( value.message );
            setStatus(value.status);
            setFlag(value.flag);

        } catch( Exception e ) {
            setStatus( 0 );
            setFlag( false );
            //setMessage( e.getMessage() );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
        }

        return getSepoaOut();
    }


    public SepoaOut doSave( Map< String, Object > allData ) throws Exception {        
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();
        ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);

        String ADD_USER_ID = info.getSession("ID");
        String ADD_DATE = SepoaDate.getShortDateString();
        String ADD_TIME = SepoaDate.getShortTimeString();
        String LANGUAGE = info.getSession("LANGUAGE");
        
        String USE_FLAG = "";
        String LKIND = "";
        String CKIND = "";
        String CKIND_TXT = "";
        String SKIND        = "";
        String SSKIND       = "";
        String SORT_SEQ = "1";
        String DEL_FLAG = sepoa.fw.util.CommonUtil.Flag.No.getValue();
        String org_add_user_id = "";

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
        try {
            setStatus(1);
            setFlag(true);
            
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
            for( int i = 0; i < gridData.size(); i++ ) {
                
                gridRowData = gridData.get( i );


                USE_FLAG    = MapUtils.getString( gridRowData,    "USE_FLAG",    "" ); 
                if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
                else                     USE_FLAG = "N";
                LKIND       = MapUtils.getString( gridRowData,    "LKIND",    "" );
                CKIND       = MapUtils.getString( gridRowData,    "CKIND",    "" );
                CKIND_TXT   = MapUtils.getString( gridRowData,    "CKIND_TXT",    "" );
                DEL_FLAG       = (sepoa.fw.util.CommonUtil.Flag.Yes.getValue().equals(MapUtils.getString( gridRowData, "DEL_FLAG", "" ))) ? sepoa.fw.util.CommonUtil.Flag.Yes.getValue() : sepoa.fw.util.CommonUtil.Flag.No.getValue();
                org_add_user_id = MapUtils.getString( gridRowData,   "ADD_USER_ID",             "" );

                ps.removeAllValue();
                sqlsb.delete(0, sqlsb.length());
                sqlsb.append("SELECT COUNT(*) CNT                           \n");
                sqlsb.append(" FROM SLVEL    \n");
                sqlsb.append(" WHERE 1=1 \n");
                sqlsb.append(ps.addSelectString(" AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue());
                sqlsb.append(ps.addSelectString(" AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
                sqlsb.append(ps.addSelectString(" AND CODE = ?                  \n"));ps.addStringParameter(CKIND);
                SepoaFormater wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
                String CNT = "0";
                if(wf.getRowCount()>0){
                    CNT = wf.getValue("CNT",0);
                }
                if( "0".equals(CNT) || "".equals(org_add_user_id) ) {
                    // 삽입모드
                    ps.removeAllValue();
                    sqlsb.delete(0, sqlsb.length());
                    sqlsb.append("SELECT COUNT(*) CNT                           \n");
                    sqlsb.append(" FROM SLVEL    \n");
                    sqlsb.append(" WHERE 1=1 \n");
                    sqlsb.append(ps.addSelectString(" AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue());
                    sqlsb.append(ps.addSelectString(" AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
                    sqlsb.append(ps.addSelectString(" AND   TEXT3 = ?               \n"));ps.addStringParameter(LKIND);
                    wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
                    if(wf.getRowCount()>0){
                        CNT = wf.getValue("CNT",0);
                    }
                    ps.removeAllValue();
                    sqlsb.delete(0, sqlsb.length());
                    sqlsb.append("SELECT MAX(TO_NUMBER(SORT_SEQ))+1   \n");
                    sqlsb.append(" FROM SLVEL    \n");
                    sqlsb.append(" WHERE 1=1 \n");
                    sqlsb.append(ps.addSelectString(" AND TYPE = ?       \n"));ps.addStringParameter(constants.LevelCode.SECOND.getValue());
                    sqlsb.append(ps.addSelectString(" AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
                    sqlsb.append(ps.addSelectString(" AND   TEXT3 = ?               \n"));ps.addStringParameter(LKIND);
                    wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
                    if(wf.getRowCount()>0){
                        SORT_SEQ = wf.getValue(0,0);
                    }
                    ps.removeAllValue();
                    sqlsb.delete(0, sqlsb.length());
                    sqlsb.append("INSERT INTO SLVEL                         \n");
                    sqlsb.append("      (                                       \n");
                    sqlsb.append("           COMPANY_CODE           \n");
                    sqlsb.append("          ,TYPE                           \n");
                    sqlsb.append("          ,CODE                       \n");
                    sqlsb.append("          ,LANGUAGE                           \n");
                    sqlsb.append("          ,ADD_DATE                       \n");
                    sqlsb.append("          ,ADD_TIME                       \n");
                    sqlsb.append("          ,ADD_USER_ID                            \n");
                    sqlsb.append("          ,SORT_SEQ                       \n");
                    sqlsb.append("          ,USE_FLAG                           \n");
                    sqlsb.append("          ,TEXT1                          \n");
                    sqlsb.append("          ,TEXT2                          \n");
                    sqlsb.append("          ,TEXT3                          \n"); //레벨2
                    sqlsb.append("          ,TEXT4                          \n"); //레벨3
                    sqlsb.append("          ,TEXT5                          \n"); //레벨4
                    sqlsb.append("          ,TEXT6                          \n"); //레벨5
                    sqlsb.append("          ,DEL_FLAG                               \n");
                    sqlsb.append("      )                                       \n");
                    sqlsb.append("VALUES                                            \n");
                    sqlsb.append("      (                                       \n");
                    sqlsb.append("             ?                               \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter(constants.LevelCode.SECOND.getValue());
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter(LKIND+CKIND);
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter(LANGUAGE);
                    sqlsb.append("          ,?                      \n");               ps.addStringParameter(ADD_DATE);
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter(ADD_TIME);
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter(ADD_USER_ID);
                    
                    
                    if("0".equals(CNT)){
                        sqlsb.append("          ,  '1'                              \n");
                    }else{
                        if(SEPOA_DB_VENDOR.equals("ORACLE")){
                            sqlsb.append("          ,  (SELECT MAX(SORT_SEQ)+1  \n");
                            sqlsb.append(" FROM SLVEL    \n");
                            sqlsb.append(" WHERE 1=1 \n");
                            sqlsb.append(" AND COMPANY_CODE = ?       \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
                            sqlsb.append(" AND TYPE = ?       \n");ps.addStringParameter(constants.LevelCode.SECOND.getValue()); 
                            sqlsb.append(" AND TEXT3 = ?)      \n");ps.addStringParameter(LKIND);  
                        }else{
                            sqlsb.append("          ,  ?                                \n");ps.addStringParameter(SORT_SEQ);
                        } 
                    }  
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter(USE_FLAG);
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter(CKIND_TXT);
                    sqlsb.append("          ,  ?                    \n");               ps.addStringParameter(CKIND_TXT);
                    sqlsb.append("          ,  ?                    \n");ps.addStringParameter(LKIND);
                    sqlsb.append("          ,  ?                    \n");ps.addStringParameter(CKIND);	//A1901이라면 01만 넣는다.
//                    sqlsb.append("          ,  ?                    \n");ps.addStringParameter(CKIND.substring(3,5));	//A1901이라면 01만 넣는다.
                    sqlsb.append("          ,  ?                                \n");ps.addStringParameter(SKIND);
                    sqlsb.append("          ,  ?                                \n");ps.addStringParameter(SSKIND);
                    sqlsb.append("          ,  ?                                \n");               ps.addStringParameter("N");
                    sqlsb.append("      )                                       \n");
                    ps.doInsert(sqlsb.toString());
                } else {
                    // 수정모드
                    ps.removeAllValue();
                    sqlsb.delete(0, sqlsb.length());
                    sqlsb.append("UPDATE SLVEL SET                \n");
                    sqlsb.append("       CHANGE_DATE    = ?       \n"); ps.addStringParameter(ADD_DATE);
                    sqlsb.append("      ,CHANGE_TIME    = ?       \n"); ps.addStringParameter(ADD_TIME);
                    sqlsb.append("      ,CHANGE_USER_ID = ?       \n"); ps.addStringParameter(ADD_USER_ID);
                    sqlsb.append("      ,USE_FLAG       = ?       \n"); ps.addStringParameter(USE_FLAG);
                    sqlsb.append("      ,TEXT1          = ?       \n"); ps.addStringParameter(CKIND_TXT);
                    sqlsb.append("      ,TEXT2          = ?       \n"); ps.addStringParameter(CKIND_TXT);
                    sqlsb.append("      ,TEXT3          = ?       \n"); ps.addStringParameter(LKIND);
                    sqlsb.append("      ,TEXT4          = ''       \n");
                    sqlsb.append("      ,TEXT5          = ''       \n");
                    sqlsb.append("      ,TEXT6          = ''       \n");
                    sqlsb.append("      ,DEL_FLAG          = ?       \n"); ps.addStringParameter(DEL_FLAG);
                    sqlsb.append(" WHERE 1=1 \n");
                    sqlsb.append(" AND TYPE = ?       \n");ps.addStringParameter(constants.LevelCode.SECOND.getValue());
                    sqlsb.append(" AND COMPANY_CODE = ?    \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
                    sqlsb.append(" AND CODE = ?                 \n"); ps.addStringParameter(CKIND);
                    ps.doUpdate(sqlsb.toString());
                }
            }//for end

            Commit();
            setMessage( msg.get( "MESSAGE.0001" ).toString() );  //성공적으로 처리하였습니다
        } 
        catch (Exception e)
        {
            try {
                Rollback();
            } catch (SepoaServiceException e1) {
            	Logger.err.println(info.getSession("ID"), this, e1.getMessage());
            }
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }
        
        return getSepoaOut();
    }
}
