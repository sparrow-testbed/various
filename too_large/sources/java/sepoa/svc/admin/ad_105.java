package sepoa.svc.admin;

import java.util.HashMap ;
import java.util.List ;
import java.util.Map ;

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
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.svc.common.constants ;

public class AD_105 extends SepoaService {
	
	private String ID = info.getSession("ID");
    //20131211 sendakun
    private HashMap msg = null;


	public AD_105(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	    //20131211 sendakun
        try {
//            msg = new Message(info, "MSG");
            msg = MessageUtil.getMessageMap( info, "AD_105","MESSAGE");
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
	
	
	public SepoaOut doQuery(Map< String, Object > allData) {
		
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
			sqlsb.append(" 			,TEXT3    AS LKIND            --레벨1			\n");
			sqlsb.append(" 			,(SELECT TEXT1 FROM SLVEL WHERE TYPE = '" + constants.LevelCode.FIRST.getValue() + "' AND CODE = DE.TEXT3)    AS LKIND_TXT            --레벨1			\n");
			sqlsb.append(" 			,TEXT4    AS CKIND            --레벨2 		\n");
			sqlsb.append(" 			,(SELECT TEXT1 FROM SLVEL WHERE TYPE = '" + constants.LevelCode.SECOND.getValue() + "' AND CODE = DE.TEXT3" + DBUtil.getAndSeparator()+ "DE.TEXT4)    AS CKIND_TXT            --레벨2 		\n");
			sqlsb.append(" 			,CODE    AS SKIND         --레벨3 		\n");
			sqlsb.append(" 			,TEXT1    AS SKIND_TXT         --레벨3명 		\n");
			sqlsb.append(" 			,SORT_SEQ                    --순서 		    \n");
			sqlsb.append(" FROM SLVEL DE              							\n");
			sqlsb.append(" WHERE "+DB_NULL_FUNCTION+"(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' 		\n");
            sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
			sqlsb.append(" AND TYPE = '" + constants.LevelCode.THIRD.getValue() + "'               						\n");
			sqlsb.append(ps.addSelectString(" AND UPPER(TEXT3) = UPPER(?)               						\n"));
			ps.addStringParameter(MapUtils.getString( headerData,    "LKIND",     "" ));
			sqlsb.append(ps.addSelectString(" AND UPPER(TEXT4) = UPPER(?)               						\n"));
			ps.addStringParameter(MapUtils.getString( headerData,    "CKIND",     "" ));
			
			//sqlsb.append(" ORDER BY CONVERT(INT,CODE)              				\n");
			/*
			코드에 문자가 들어가있어서 변경 
			if(SEPOA_DB_VENDOR.equals("ORACLE")){
				sqlsb.append(" ORDER BY TO_NUMBER(CODE)               				\n");
			}else{
				sqlsb.append(" ORDER BY CONVERT(NUMERIC,CODE)               				\n");
			}*/
			
			setValue(ps.doSelect(sqlsb.toString()));
			//성공적으로 회수 하였습니다.
//			setMessage(msg.getMessage("0004"));
			
			setMessage(msg.get("AD_105.0000").toString());
		} 
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			//처리 중 오류가 발생하였습니다.
			setMessage(msg.get("AD_105.0001").toString());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	
	
	public SepoaOut doRegist( Map< String, Object > allData ) {
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
		String SKIND = "";
		String SKIND_TXT = "";
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
			/**
			for(int i = 0; i < bean_args.length; i++){
				
				USE_FLAG 	= bean_args[i][0];
				if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
				else					 USE_FLAG = "N";
				LKIND       = bean_args[i][1];
				CKIND 	    = bean_args[i][2];
				SKIND 		= bean_args[i][3];
				SKIND_TXT 	= bean_args[i][4];
			**/
            for( int i = 0; i < gridData.size(); i++ ) {
            	
                gridRowData = gridData.get( i );	
				USE_FLAG 	= MapUtils.getString( gridRowData,    "USE_FLAG",    "" ); 
				if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
				else					 USE_FLAG = "N";
				LKIND       = MapUtils.getString( gridRowData,    "LKIND",    "" ) ;
				CKIND 	    = MapUtils.getString( gridRowData,    "CKIND",    "" ); 
				SKIND 	    = MapUtils.getString( gridRowData,    "SKIND",    "" ); 
				SKIND_TXT 	= MapUtils.getString( gridRowData,    "SKIND_TXT",    "" ) ;
				
				
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT COUNT(*) CNT       					\n");
				sqlsb.append("FROM SLVEL  									\n");
				sqlsb.append("WHERE TYPE = '" + constants.LevelCode.THIRD.getValue() + "'  							\n");
	            sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
				sqlsb.append(ps.addSelectString("AND CODE = ?  			    \n"));
				ps.addStringParameter(SKIND);
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
					//레벨3에 중복된 데이터를 입력하셨습니다.
					setMessage(msg.get("AD_105.0002").toString());
					return getSepoaOut();
				}
				
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT COUNT(*) CNT       					\n");
				sqlsb.append("FROM SLVEL  									\n");
				sqlsb.append("WHERE TYPE  = '" + constants.LevelCode.THIRD.getValue() + "'  							\n");
	            sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
				sqlsb.append(ps.addSelectString("AND   TEXT3 = ?  							\n"));
				ps.addStringParameter(LKIND);
				sqlsb.append(ps.addSelectString("AND   TEXT4 = ?  							\n"));
				ps.addStringParameter(CKIND);
				wf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
				if(wf.getRowCount()>0){
					CNT = wf.getValue("CNT",0);
				}

				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT MAX(TO_NUMBER(SORT_SEQ))+1 FROM SLVEL  \n");
				sqlsb.append(ps.addSelectString("WHERE TYPE = '" + constants.LevelCode.THIRD.getValue() + "' AND TEXT3 = ? 	  \n"));ps.addStringParameter(LKIND);
				sqlsb.append(ps.addSelectString("   	    	AND TEXT4 = ? 	  \n"));ps.addStringParameter(CKIND);
	            sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE")); 
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
                sqlsb.append("          ,  ?                                \n");				ps.addStringParameter(constants.LevelCode.THIRD.getValue());
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(SKIND);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(LANGUAGE);
				sqlsb.append("   	    ,?						\n");				ps.addStringParameter(ADD_DATE);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(ADD_TIME);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(ADD_USER_ID);
				if(CNT.equals("0")){
					sqlsb.append("   	    ,  '1' 	                    		\n");
				}else{
					if(SEPOA_DB_VENDOR.equals("ORACLE")){
						sqlsb.append("   	    ,  (SELECT MAX(SORT_SEQ)+1 FROM SLVEL WHERE TYPE = '" + constants.LevelCode.THIRD.getValue() + "' AND TEXT3 = ? 	  \n");ps.addStringParameter(LKIND);
                        sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE"));
						sqlsb.append("   	    	AND TEXT4 = ?) 	  \n");ps.addStringParameter(CKIND); 
					}else{
						sqlsb.append("   	    ,  ? 	                    		\n");ps.addStringParameter(SORT_SEQ);
					} 
				} 
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(USE_FLAG);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter(SKIND_TXT);
				sqlsb.append("   	    ,  ? 					\n");				ps.addStringParameter(SKIND_TXT);
                sqlsb.append("          ,  ?                    \n");ps.addStringParameter(LKIND);
                sqlsb.append("          ,  ?                    \n");ps.addStringParameter(CKIND);
                sqlsb.append("          ,  ?                                \n");ps.addStringParameter(SKIND.substring(5,7));	//A190102 라면 02만
                sqlsb.append("          ,  ?                                \n");ps.addStringParameter(SSKIND);
				sqlsb.append("   	    ,  ? 	                    		\n");				ps.addStringParameter("N");
				sqlsb.append("   	)                               		\n");
				
				ps.doInsert(sqlsb.toString());
				
				Map< String, String > CodeData = new HashMap< String, String >();
				CodeData.put("CODE_TYPE","C"      );
				CodeData.put("CODE"     ,SKIND    );
				CodeData.put("P_CODE"   ,LKIND+CKIND    );
				CodeData.put("CODE_NAME",SKIND_TXT);
				
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
                    MSG += "Code["+SKIND+"] "+msg.get("MESSAGE.0084")+"\n";
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
		String SKIND = "";
		String SKIND_TXT = "";

        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
		try {
			setStatus(1);
			setFlag(true);

            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );
			/**
			for(int i = 0; i < bean_args.length; i++){
				
				USE_FLAG 	= bean_args[i][0];
				if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
				else					 USE_FLAG = "N";
				LKIND       = bean_args[i][1];
				CKIND 	    = bean_args[i][2];
				SKIND 		= bean_args[i][3];
				SKIND_TXT 	= bean_args[i][4];
			**/
            for( int i = 0; i < gridData.size(); i++ ) {
            	
                gridRowData = gridData.get( i );	
				USE_FLAG 	= MapUtils.getString( gridRowData,    "USE_FLAG",    "" ); 
				if(USE_FLAG.equals("1")) USE_FLAG = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
				else					 USE_FLAG = "N";
				LKIND       = MapUtils.getString( gridRowData,    "LKIND",    "" ) ;
				CKIND 	    = MapUtils.getString( gridRowData,    "CKIND",    "" ); 
				SKIND 	    = MapUtils.getString( gridRowData,    "SKIND",    "" ); 
				SKIND_TXT 	= MapUtils.getString( gridRowData,    "SKIND_TXT",    "" ) ;
				
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("SELECT COUNT(*) AS CNT FROM SLVEL       					\n");
				sqlsb.append("WHERE TYPE = '" + constants.LevelCode.FOUR.getValue() + "'  						\n");
                sqlsb.append(ps.addSelectString("AND COMPANY_CODE = ?       \n"));ps.addStringParameter(info.getSession("COMPANY_CODE"));
                sqlsb.append(ps.addSelectString("AND CODE = ?             \n"));ps.addStringParameter(SKIND);
				
				int COUNT = 0;
				SepoaFormater temp_sf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
				if(temp_sf.getRowCount()>0){
					COUNT = Integer.parseInt(temp_sf.getValue("CNT",0));
				}
				
				if(COUNT>0){
				    //하위분류에 등록된 항목이 있어 삭제할수 없습니다.
					setMessage(msg.get ( "AD_105.0003" ).toString());
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
					sqlsb.append(ps.addSelectString("AND SG_CODE3 = ?  			    			\n"));
					ps.addStringParameter(SKIND);
					
					int COUNT2 = 0;
					SepoaFormater temp_sf1 = new SepoaFormater(ps.doSelect(sqlsb.toString()));
					if(temp_sf1.getRowCount()>0){
						COUNT2 = Integer.parseInt(temp_sf1.getValue("CNT",0));
					}
					
					if(COUNT2>0){
					    //공급업체에 연결된 항목이 있어 삭제할수 없습니다.
						setMessage(msg.get("AD_105.0004").toString());
						setStatus(0);
						setFlag(false);
						return getSepoaOut();
					}
				}
				
				
				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("DELETE FROM SLVEL       					\n");
				sqlsb.append("WHERE TYPE = '" + constants.LevelCode.THIRD.getValue() + "'  						\n");
                sqlsb.append("AND COMPANY_CODE = ?           \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
				sqlsb.append("AND CODE = ?  			    			\n");ps.addStringParameter(SKIND);
				sqlsb.append("AND TEXT1 = ?  			    			\n");ps.addStringParameter(SKIND_TXT);
				ps.doDelete(sqlsb.toString());
				
				Map< String, String > CodeData = new HashMap< String, String >();
				CodeData.put("CODE_TYPE","D"      );
				CodeData.put("CODE"     ,SKIND    );
				CodeData.put("P_CODE"   ,LKIND+CKIND    );
				CodeData.put("CODE_NAME",SKIND_TXT);
				
				// I/F
				SepoaOut value = setCodeInfo(CodeData);
				
				if(!value.flag){
					setFlag(false);
					setStatus(0);
					Rollback();
				}else{
					Commit();
				}
				setMessage(value.message);
				
				if(value.message.length()>0){
					MSG += value.message+"\n";
				}else{
                    //0084 : 인터페이스중 오류가 발생했습니다.
                    MSG += "Code["+SKIND+"] "+msg.get("MESSAGE.0084")+"\n";
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
		String SKIND = "";
		String SKIND_TXT = "";
		String SORT_SEQ = "";

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
				SKIND 	    = MapUtils.getString( gridRowData,    "SKIND",    "" );
				SKIND_TXT 	= MapUtils.getString( gridRowData,    "SKIND_TXT",    "" ) ;


				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("UPDATE SLVEL SET                \n");
				sqlsb.append("       CHANGE_DATE    = ?       \n"); ps.addStringParameter(ADD_DATE);
				sqlsb.append("      ,CHANGE_TIME    = ?       \n"); ps.addStringParameter(ADD_TIME);
				sqlsb.append("      ,CHANGE_USER_ID = ?       \n"); ps.addStringParameter(ADD_USER_ID);
				sqlsb.append("      ,USE_FLAG       = ?       \n"); ps.addStringParameter(USE_FLAG);
				sqlsb.append("      ,TEXT1          = ?       \n"); ps.addStringParameter(SKIND_TXT);
				sqlsb.append("      ,TEXT2          = ?       \n"); ps.addStringParameter(SKIND_TXT);
				sqlsb.append("      ,TEXT3          = ?       \n"); ps.addStringParameter(LKIND);
				sqlsb.append("      ,TEXT4          = ?       \n"); ps.addStringParameter(CKIND);
                sqlsb.append("      ,TEXT5          = ?       \n");ps.addStringParameter(SKIND.substring(5,7));
                sqlsb.append("      ,TEXT6          = ''       \n");
				sqlsb.append(" WHERE TYPE = '" + constants.LevelCode.THIRD.getValue() + "'            \n");
                sqlsb.append("   AND COMPANY_CODE = ?    \n");ps.addStringParameter(info.getSession("COMPANY_CODE"));
				sqlsb.append("   AND CODE = ?                 \n"); ps.addStringParameter(SKIND);
				ps.doUpdate(sqlsb.toString());
				
				Map< String, String > CodeData = new HashMap< String, String >();
				CodeData.put("CODE_TYPE","U"      );
				CodeData.put("CODE"     ,SKIND    );
				CodeData.put("P_CODE"   ,LKIND+CKIND    );
				CodeData.put("CODE_NAME",SKIND_TXT);
				
				// I/F
				SepoaOut value = setCodeInfo(CodeData);
				
				if(!value.flag){
					setFlag(false);
					setStatus(0);
					Rollback();
				}else{
					Commit();
				}
				setMessage(value.message);
				
				if(value.message.length()>0){
					MSG += value.message+"\n";
				}else{
                    //0084 : 인터페이스중 오류가 발생했습니다.
                    MSG += "Code["+SKIND+"] "+msg.get("MESSAGE.0084")+"\n";
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
}
