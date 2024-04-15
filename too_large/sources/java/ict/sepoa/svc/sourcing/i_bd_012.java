/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : BD_012.java
 *
 *@FileName : 예정가격 등록
 *
 *Open Issues :
 *
 *Change history
 *@LastModifier :
 *@LastVersion : 2013.01.24
 *=========================================================
 */ 

package ict.sepoa.svc.sourcing;


import java.util.HashMap ;
import java.util.List ;
import java.util.Map ;

import org.apache.commons.collections.MapUtils ;

import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.cfg.Configuration ;
import sepoa.fw.cfg.ConfigurationException ;
import sepoa.fw.db.ConnectionContext ;
import sepoa.fw.db.ParamSql ;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.SepoaService ;
import sepoa.fw.srv.SepoaServiceException ;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaString ;   

import java.util.StringTokenizer;
 
@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class I_BD_012 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_BD_012( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_BD_012: = " + e.getMessage());
        }
    }

    public String getConfig( String s ) {
        try {
            Configuration configuration = new Configuration();
            s = configuration.get( s );
            return s;
        } catch( ConfigurationException configurationexception ) {
            Logger.sys.println( "getConfig error : " + configurationexception.getMessage() );
        } catch( Exception exception ) {
            Logger.sys.println( "getConfig error : " + exception.getMessage() );
        }
        return null;
    }
    
    // 내정가격등록 리스트
	public SepoaOut getBdPrepareList(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdPrepareList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 

            headerData.put("HOUSE_CODE", house_code); 
            headerData.put("START_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "start_change_date", "" ) ) ); 
            headerData.put("END_CHANGE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData,  "end_change_date", "" ) ) ); 
            
            setValue(ssm.doSelect(headerData));
 
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }  
 
	// ICT 사용 : 내정가격 등록
	public SepoaOut getBdPrepareHeader(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

            headerData.put("HOUSE_CODE", house_code);  
			sxp = new SepoaXmlParser(this, "getBdPrepareHeader_BDHD");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
            setValue(ssm.doSelect(headerData));
            
			sxp = new SepoaXmlParser(this, "getBdPrepareHeader_BDSE");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
            setValue(ssm.doSelect(headerData));
            
			sxp = new SepoaXmlParser(this, "getBdPrepareHeader_BDDT");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
            setValue(ssm.doSelect(headerData));
            
			sxp = new SepoaXmlParser(this, "getBdPrepareHeader_BDVO");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);   
            setValue(ssm.doSelect(headerData));
 
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }  

	public SepoaOut getBdPrepareInsert(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String house_code   = info.getSession("HOUSE_CODE"); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

			sxp = new SepoaXmlParser(this, "getBdPrepareInsert");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
 
            headerData.put("HOUSE_CODE", house_code);  
            
            setValue(ssm.doSelect(headerData));
 
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }  
    
	// ICT사용 : 내정가격확정
	public SepoaOut setPrepare( Map< String, Object > allData ) throws Exception {

        ConnectionContext ctx	= getConnectionContext();
        String house_code		= info.getSession("HOUSE_CODE"); 
        String DEPT				= info.getSession("DEPARTMENT");
        String USER_ID			= info.getSession("ID");
        String NAME_LOC			= info.getSession("NAME_LOC");
        String NAME_ENG			= info.getSession("NAME_ENG");

		SepoaXmlParser	sxp = null;
		SepoaSQLManager ssm = null;
        SepoaOut    	so  = null;
        String 			rtn = "";

        Map< String, String >           headerData  = null;
        List< Map< String, String > >   gridData    = null;
        SepoaFormater					sf			= null;
        try {

            setFlag( true );
            setStatus( 1 );

            headerData  = MapUtils.getMap( allData, "headerData" );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData" );

            headerData.put("HOUSE_CODE", house_code);  
            headerData.put("DEPT", DEPT);  
            headerData.put("NAME_LOC", NAME_LOC);  
            headerData.put("NAME_ENG", NAME_ENG);   
            
            String STATUS_FLAG = MapUtils.getString( headerData, "FLAG")+MapUtils.getString( headerData, "COST_STATUS");
            String estm_input_amt = headerData.get("ESTM_PRICE_CONF");
            
            //내정가격 계산 start //제한적 최저가인경우만...
            // ICT에서는 제한적 최저가 없음. 모두 최저가
            if("B".equals(headerData.get("PROM_CRIT"))){
            	//sxp = new SepoaXmlParser(this, "et_getHEstmAmt");
                //ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                //rtn = ssm.doSelect(headerData);
                //sf = new SepoaFormater(rtn);
                //
                //String estm_h_amt = sf.getValue("VALAMT"	, 0); //상위 2%가격
                //String estm_c_amt = sf.getValue("VALAMT"	, 1); //선택 가격
                //String estm_l_amt = sf.getValue("LOWAMT"	, 1); //선택 하위 2%가격
                //
                //
                //if(Double.parseDouble(estm_c_amt) < Double.parseDouble(estm_input_amt)){
                //	headerData.put("ESTM_PRICE_TMP", estm_c_amt);
                //	sxp = new SepoaXmlParser(this, "et_getHEstmAmt_1");
                //	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
               	//    rtn = ssm.doSelect(headerData);
                //	sf = new SepoaFormater(rtn);                	
                //	
                //	estm_h_amt = sf.getValue("VALAMT"	, 0);
                //}
                //
                //headerData.put("estm_l_amt", estm_l_amt + "");
                //headerData.put("estm_c_amt", estm_c_amt + "");
                //headerData.put("estm_h_amt", estm_h_amt + "");
                //
                //sxp = new SepoaXmlParser(this, "et_getRandomAmt");
                //ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                //rtn = ssm.doSelect(headerData);
                //sf = new SepoaFormater(rtn);
                //
                //if(sf != null && sf.getRowCount() > 0){
                //	for(int i = 0 ; i < sf.getRowCount() ; i++){
                //		headerData.put("ESTM_PRICE" + (i+1), sf.getValue("RANDOM_AMT", i));
                //	}
                //}
                //
                //sxp = new SepoaXmlParser(this, "et_getChoiceAmt");
                //ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                //rtn = ssm.doSelect(headerData);
                //sf = new SepoaFormater(rtn);
                //
                //if(sf != null && sf.getRowCount() > 0){
                //	for(int i = 0 ; i < sf.getRowCount() ; i++){
                //		headerData.put("CHOIC_ESTM_PRICE" + (i+1), sf.getValue("CHOICE_AMT", i));
                //	}
                //}
                //
                //sxp = new SepoaXmlParser(this, "et_getEstmAmt");
                //ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                //rtn = ssm.doSelect(headerData);
                //sf = new SepoaFormater(rtn);
                //
                //headerData.put("FINAL_ESTM_PRICE", sf.getValue("FINAL_ESTM_PRICE", 0));
            }else{
            	headerData.put("ESTM_PRICE1"		, headerData.get("ESTM_PRICE"));
            	// 저장될 내정가격
            	headerData.put("FINAL_ESTM_PRICE"	, headerData.get("ESTM_PRICE"));
            }
            //내정가격 계산 end
            

            // ICT는 바로 확정.... 3번째 루틴
            if(STATUS_FLAG.equals("T") ) { //신규 저장일 경우에...
        		//setForecastSave  
    			sxp = new SepoaXmlParser(this, "et_setInsertBDES");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    			ssm.doInsert(headerData);
  
	    	} else if(STATUS_FLAG.equals("TET") ) { //수정 저장 경우에...
	    		//setForecastSave 
				sxp = new SepoaXmlParser(this, "et_setUpdateBDES");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    			ssm.doUpdate(headerData);
  
	    	} else if(STATUS_FLAG.equals("C")  || STATUS_FLAG.equals("CET")) { //신규 확정 경우에...수정 확정 경우에...
	    		//setForecastConfirm
	    		
	            headerData.put("COST_STATUS", "EC");  
	            
				sxp = new SepoaXmlParser(this, "et_setUpdateBDES");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
    			ssm.doUpdate(headerData);
				sxp = new SepoaXmlParser(this, "et_setConfirmBDES");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
    			ssm.doUpdate(headerData);
	   
	    	} 

			sxp = new SepoaXmlParser(this, "et_setBidStatusForecast");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
			ssm.doUpdate(headerData);
			
    		if(STATUS_FLAG.equals("T") || STATUS_FLAG.equals("TET")) {
                setMessage("저장 되었습니다.");
            } else   {
                setMessage("내정가격이 확정되었습니다.");
            }  
    		setStatus(1); 
            Commit();	
           
        }catch (Exception e){
//        	e.printStackTrace();
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            msg.put("JOB","조회");
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    }   
}//  
