/**
 *========================================================
 *Copyright(c) 2013 SEPOA SOFT
 *
 *@File     : SBD_002.java
 *
 *@FileName : 업체 > 입찰공고조회
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
import java.util.Random ;

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
public class I_SBD_009 extends SepoaService {

    private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession("HOUSE_CODE"); //getConfig("cjfv.house_code");
    private String lang         = info.getSession( "LANGUAGE" );
    //20131212 sendakun
    private HashMap msg = null;

    public I_SBD_009( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );
        //20131212 sendakun
        try {
//            msg = new Message( info, "MESSAGE" );
            msg = MessageUtil.getMessageMap( info, "MESSAGE");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println("I_SBD_009: = " + e.getMessage());
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
 
	public SepoaOut setBDAPinsert(Map< String, Object > allData)
    {
        ConnectionContext ctx  = getConnectionContext(); 
        String company_code    = info.getSession("COMPANY_CODE"); 
        String USER_ID         = info.getSession("ID");
        String NAME_LOC        = info.getSession("NAME_LOC");
        String NAME_ENG        = info.getSession("NAME_ENG");
        String DEPT            = info.getSession("DEPARTMENT");

        Map< String, String >   headerData  = null;
        try {
            headerData = MapUtils.getMap( allData, "headerData" );
            headerData.put("HOUSE_CODE",    HOUSE_CODE); 
            headerData.put("COMPANY_CODE",  company_code); 
            headerData.put("ID", 			USER_ID);
            headerData.put("NAME_LOC", 		NAME_LOC);
            headerData.put("NAME_ENG", 		NAME_ENG); 
            headerData.put("DEPT", 			DEPT); 
            headerData.put("BID_NO", 		MapUtils.getString( headerData, "bid_no" )); 
            headerData.put("BID_COUNT", 	MapUtils.getString( headerData, "bid_count" )); 
  
            
            String status1         = et_chkBidVaild(headerData);   // 유효입찰공문인지 체크
            if (status1.equals("N")){
                setStatus(0);
                setMessage("투찰가능한 입찰건이 아닙니다.");
                return getSepoaOut();
            }
            
            String status2         = et_chkBidEndDate(headerData); // 입찰제출마감시간 체크
            if (status2.equals("N")){
                setStatus(0);
                setMessage("입찰제출마감 시간이 지났습니다.");
                return getSepoaOut();
            }

            String CONT_TYPE1      = headerData.get("CONT_TYPE1");
            String CONT_TYPE2      = headerData.get("CONT_TYPE2");	// RA:역경매(총액입찰), RC : 역경매(단가입찰)
            String PROM_CRIT       = headerData.get("PROM_CRIT");
            //String VENDOR_VOTE_SEQ = headerData.get("VENDOR_VOTE_SEQ");

            
            int rtn = 0;
            
            //입찰참가신청 : ICOYBDAP_ICT 변경 혹은 생성
            rtn = et_setBDAPinsert(headerData);	// ICOYBDAP_ICT 변경 혹은 생성

			//업체 투찰정보 : ICOYBDVO_ICT insert
            rtn = et_setBid(headerData);
			
			
            // 역경매인 경우...
            if ( "RA".equals(CONT_TYPE2) || "RC".equals(CONT_TYPE2) ){
            	// 순위정보 발생
            	rtn = et_setVendorRank(headerData);
            	// 입찰시간 변경
            	rtn = et_setBID_PG_CHANGE(headerData);
            }

            //ICOYBDVT : 상세 투찰 정보(ICT 사용하지 않음)
            //rtn = et_setBidBDVT(allData);

            setFlag( true );
            setStatus(1);
            setValue(rtn+""); 
            setMessage("입찰서가 정상적으로 제출되었습니다");

            Commit();
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage("");
            setFlag( false );
        }
        return getSepoaOut();
    }
	
	public SepoaOut setBDAPjoin(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		String company_code   = info.getSession("COMPANY_CODE"); 
		String USER_ID         = info.getSession("ID");
		String NAME_LOC        = info.getSession("NAME_LOC");
		String NAME_ENG        = info.getSession("NAME_ENG");
		String DEPT            = info.getSession("DEPARTMENT");
		
		try {
			headerData.put("HOUSE_CODE", HOUSE_CODE); 
			headerData.put("COMPANY_CODE", company_code); 
			headerData.put("ID", 			USER_ID);
			headerData.put("NAME_LOC", 		NAME_LOC);
			headerData.put("NAME_ENG", 		NAME_ENG); 
			headerData.put("DEPT", 			DEPT); 
			headerData.put("ANN_NO", 		MapUtils.getString( headerData, "ann_no" )); 
			headerData.put("ANN_COUNT", 	MapUtils.getString( headerData, "ann_count" )); 
			headerData.put("ATTACH_NO", 	MapUtils.getString( headerData, "attach_no" )); 
			
//			String status = et_chkJoinEndDate(headerData); // 입찰제출마감시간 체크
//			
//			if (status.equals("N")){
//				setFlag( false );
//				setStatus(0);
//				setMessage("서류제출마감 시간이 지났습니다.");
//				return getSepoaOut();
//			}
			
			String status2 = et_chkMagam(headerData); // 입찰공고마감 체크			
			if (status2.equals("Y")){
				setFlag( false );
				setStatus(0);
				setMessage("공고가 마감되어 제출이 불가합니다.");
				return getSepoaOut();
			}
			
			String status3 = et_chkBDAP2(headerData); // 최종결과 체크			
			if (status3.equals("Y")){
				setFlag( false );
				setStatus(0);
				setMessage("제출된 서류가 적합결정되어 다시 제출이 불가합니다.");
				return getSepoaOut();
			}
			
			
						
			int rtn = et_setBDAPinsert(headerData);

//			headerData.put("BID_AMT", 		MapUtils.getString( headerData, "BID_AMT" )); 
//			headerData.put("STATUS"	, 		"C"); 			
//			rtn = et_setQtee(headerData);
			
//			rtn = et_setBdat(headerData);
			
			rtn = et_setBdap(headerData);
			
			setFlag( true );
			setStatus(1);
			setValue(rtn+""); 
			setMessage("참가신청서가 정상적으로 제출되었습니다");
			
			Commit();
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage("");
			setFlag( false );
		}
		return getSepoaOut();
	}
	
	
	public SepoaOut setBDAPjoin2(Map< String, String > headerData)
	{
		ConnectionContext ctx = getConnectionContext(); 
		String company_code    = headerData.get("COMPANY_CODE"); 
		String USER_ID         = info.getSession("ID");
		String NAME_LOC        = info.getSession("NAME_LOC");
		String NAME_ENG        = info.getSession("NAME_ENG");
		String DEPT            = info.getSession("DEPARTMENT");
		
		try {
			headerData.put("HOUSE_CODE", HOUSE_CODE); 
			headerData.put("COMPANY_CODE",  company_code); 
			headerData.put("ID", 			USER_ID);
			headerData.put("NAME_LOC", 		NAME_LOC);
			headerData.put("NAME_ENG", 		NAME_ENG); 
			headerData.put("DEPT", 			DEPT); 
			headerData.put("BID_NO", 		MapUtils.getString( headerData, "bid_no" )); 
			headerData.put("BID_COUNT", 	MapUtils.getString( headerData, "bid_count" )); 
			
			String status = et_chkJoinEndDate(headerData); // 입찰제출마감시간 체크
			
			if (status.equals("N")){
				//setStatus(0);
				//setMessage("입찰제출마감 시간이 지났습니다.");
				//return getSepoaOut();
			}
			
			int rtn = et_setBDAPinsert(headerData);
			
			headerData.put("BID_AMT", 		MapUtils.getString( headerData, "BID_AMT" )); 
			headerData.put("STATUS"	, 		"C"); 			
			rtn = et_setQtee(headerData);
			
			headerData.put("ATTACH_NO", 	MapUtils.getString( headerData, "attach_no" )); 
			rtn = et_setBdat(headerData);
			
			setFlag( true );
			setStatus(1);
			setValue(rtn+""); 
			setMessage("참가신청서가 정상적으로 제출되었습니다");
			
			Commit();
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage("");
			setFlag( false );
		}
		return getSepoaOut();
	}
	

    private int et_setQtee(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        String rtnStr = "";
        int rtn = 0;
        String BDAP_CNT = "";
        String bdap_enable = "";
        String bdap_flag = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	
        	sxp = new SepoaXmlParser(this, "et_getQtee");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	rtnStr = ssm.doSelect(headerData);
        	
        	SepoaFormater sf = new SepoaFormater(rtnStr);
        	
        	if(sf.getRowCount() > 0 && Integer.parseInt(sf.getValue("CNT",0)) > 0){
        		sxp = new SepoaXmlParser(this, "et_updQtee");
        		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
        		rtn = ssm.doInsert(headerData); 
        	}else{
        		sxp = new SepoaXmlParser(this, "et_setQtee");
        		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
        		rtn = ssm.doInsert(headerData); 
        	}

            
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }	

    
    private int et_setBdap(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        String rtnStr = "";
        int rtn = 0;
        String BDAP_CNT = "";
        String bdap_enable = "";
        String bdap_flag = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	
        	sxp = new SepoaXmlParser(this, "et_setBdap");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	rtn = ssm.doUpdate(headerData); 
    
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }
    
    
    private int et_setBdat(Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	int rtn = 0;
    	String BDAP_CNT = "";
    	String bdap_enable = "";
    	String bdap_flag = "";
    	
    	SepoaXmlParser sxp = null;
    	SepoaSQLManager ssm = null;
    	try {
    		
    		sxp = new SepoaXmlParser(this, "et_delBdat");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		rtn = ssm.doInsert(headerData); 
    		
    		sxp = new SepoaXmlParser(this, "et_setBdat");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		rtn = ssm.doInsert(headerData); 
    		
    	}catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}finally {
    	}
    	return rtn;
    }	
	
    /* ICT 사용 */
    private String et_chkBidVaild( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        String rtn = null; 
        String value = null; 
        try { 
              
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkBidVaild");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			value = ssm.doSelect(headerData);
            SepoaFormater wf = new SepoaFormater(value);
            rtn = wf.getValue(0,0);
         
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    private String et_chkBidEndDate( Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        
        String rtn = null; 
        String value = null; 
        try { 
              
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkBidEndDate");
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			value = ssm.doSelect(headerData);
            SepoaFormater wf = new SepoaFormater(value);
            rtn = wf.getValue(0,0);
         
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    private String et_chkJoinEndDate( Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkJoinEndDate");
    		SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		value = ssm.doSelect(headerData);
    		SepoaFormater wf = new SepoaFormater(value);
    		rtn = wf.getValue(0,0);
    		
    	} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }
    
    private String et_chkMagam( Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkMagam");
    		SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		value = ssm.doSelect(headerData);
    		SepoaFormater wf = new SepoaFormater(value);
    		rtn = wf.getValue(0,0);
    		
    	} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }
    
    private String et_chkBDAP2( Map< String, String > headerData ) throws Exception 
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	String rtn = null; 
    	String value = null; 
    	try { 
    		
    		SepoaXmlParser sxp = new SepoaXmlParser(this, "et_chkBDAP2");
    		SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    		value = ssm.doSelect(headerData);
    		SepoaFormater wf = new SepoaFormater(value);
    		rtn = wf.getValue(0,0);
    		
    	} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}
    	return rtn;
    }
        
    /* ICT 사용 : 업체순위정보 생성 : 일단 무조건 생성 */
    private int et_setVendorRank(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        int rtn = 0;

        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
    		sxp = new SepoaXmlParser(this, "et_setVendorRank");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            rtn = ssm.doInsert(headerData);  

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    
    
    }

    /* ICT 사용 : 입찰시간 변경 */
    private int et_setBID_PG_CHANGE(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        int rtn = 0;

        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
    		
        	String strChangePG_YN = "";

        	// 입찰시간 변경 조건 발생여부 체크
        	sxp = new SepoaXmlParser(this, "et_chkChange_Condition_BDPG");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
    	 
            SepoaFormater wf = new SepoaFormater(ssm.doSelect(headerData));//입찰신청자료(BDAP)에 공급업체가 존재하는지 체크 

            strChangePG_YN = wf.getValue(0,0);

            if ("Y".equals(strChangePG_YN))
            {
            	// 입찰시간 변경(ICOYBDPG)
            	sxp = new SepoaXmlParser(this, "et_setBID_PG_CHANGE");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                rtn = ssm.doInsert(headerData);  

            	// 입찰시간 변경 로그 생성
            	sxp = new SepoaXmlParser(this, "et_setBID_PG_LOG");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                rtn = ssm.doInsert(headerData);  
            }
            
        	

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
        
    
    }   
    
    
    /* ICT 사용 */
    private int et_setBDAPinsert(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext(); 
        int rtn = 0;
        String BDAP_CNT = "";
        String bdap_enable = "";
        String bdap_flag = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

    		sxp = new SepoaXmlParser(this, "et_chkIsBDAP");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
		 
            SepoaFormater wf = new SepoaFormater(ssm.doSelect(headerData));//입찰신청자료(BDAP)에 공급업체가 존재하는지 체크 

            if(wf.getRowCount() == 0 ){
            	BDAP_CNT = null;
            } else {
            	BDAP_CNT = wf.getValue(0,0);
            }
            
            if(BDAP_CNT == null) {
                bdap_enable = "N";
                bdap_flag = "";
            } else {
                bdap_enable = BDAP_CNT.substring(0, 1);
                bdap_flag   = BDAP_CNT.substring(2, 3);
            }

            headerData.put("bdap_flag", bdap_flag);   

            if(bdap_enable.equals("Y")) { //  이미 bdap에 데이터가 들어가 있다.

        		sxp = new SepoaXmlParser(this, "et_setBDAPinsert_1");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                rtn = ssm.doUpdate(headerData);

            } else {
        		sxp = new SepoaXmlParser(this, "et_setBDAPinsert_2");
    			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
                rtn = ssm.doInsert(headerData); 
            }
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    /* ICT 사용 : 업체 투찰정보 */
    private int et_setBid(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        int rtn = 0;
 
        String value = et_chkBidESTM(headerData);
        SepoaFormater wf = new SepoaFormater(value);
		
        int estm_max  = Integer.parseInt(wf.getValue("ESTM_MAX", 0));
		int estm_vote = Integer.parseInt(wf.getValue("ESTM_VOTE", 0));
		String CHOICE_ESTM_NUM1 = "";
		String CHOICE_ESTM_NUM2 = "";
		String CHOICE_ESTM_NUM3 = "";
		String CHOICE_ESTM_NUM4 = "";
		int count=0;
		if (estm_max!=0) {
			Random generator = new Random();
			int[] namsu = new int[estm_vote];
			while(true) {
				int num = generator.nextInt(estm_max);
				num += 1;
				boolean check = true;
				for(int m=0;m<namsu.length;m++) {
					if (namsu[m]==num) check = false;					
				}
				if (check) {
					namsu[count] = num;
					count++;
				}
				if (count>=namsu.length) break;
			}
			if (namsu.length==4) {
				CHOICE_ESTM_NUM1 = String.valueOf(namsu[0]);
				CHOICE_ESTM_NUM2 = String.valueOf(namsu[1]);
				CHOICE_ESTM_NUM3 = String.valueOf(namsu[2]);
				CHOICE_ESTM_NUM4 = String.valueOf(namsu[3]);
			} else if (namsu.length==3) {
				CHOICE_ESTM_NUM1 = String.valueOf(namsu[0]);
				CHOICE_ESTM_NUM2 = String.valueOf(namsu[1]);
				CHOICE_ESTM_NUM3 = String.valueOf(namsu[2]);
			} else if (namsu.length==2) {
				CHOICE_ESTM_NUM1 = String.valueOf(namsu[0]);
				CHOICE_ESTM_NUM2 = String.valueOf(namsu[1]);
			} else if (namsu.length==1) {
				CHOICE_ESTM_NUM1 = String.valueOf(namsu[0]);
			}
		}
        headerData.put("CHOICE_ESTM_NUM1", 		CHOICE_ESTM_NUM1); 
        headerData.put("CHOICE_ESTM_NUM2", 		CHOICE_ESTM_NUM2); 
        headerData.put("CHOICE_ESTM_NUM3", 		CHOICE_ESTM_NUM3); 
        headerData.put("CHOICE_ESTM_NUM4", 		CHOICE_ESTM_NUM4); 


        headerData.put("BID_AMT", MapUtils.getString( headerData, "BID_AMT").replaceAll ( "," , "" ) ); 
 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
    		sxp = new SepoaXmlParser(this, "et_setBDVO_DELETE");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            rtn = ssm.doUpdate(headerData);  

            sxp = new SepoaXmlParser(this, "et_setBDVO_INSERT");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            rtn = ssm.doInsert(headerData);  


    		sxp = new SepoaXmlParser(this, "et_setBDVO_HIST");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            rtn = ssm.doInsert(headerData);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {
        }
        return rtn;
    }

    // ICT 사용
    private String et_chkBidESTM(Map< String, String > headerData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        String rtn = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	
    		sxp = new SepoaXmlParser(this, "et_chkBidESTM"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doSelect(headerData);

        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    
    private int et_setBidBDVT(Map< String, Object > allData ) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        Map< String, String >           headerData  = null;
        Map< String, String >           gridRowData = null;
        List< Map< String, String > >   gridData    = null;
        
    	int rtn = 0;
        int	intGridRowData  = 0;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
    	try {

            headerData  = MapUtils.getMap( allData, "headerData", null );
            gridData    = (List< Map< String, String > >)MapUtils.getObject( allData, "gridData", null );

    		sxp = new SepoaXmlParser(this, "et_setBidBDVT"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
            if( gridData != null && gridData.size() > 0 ) {

                intGridRowData  = gridData.size();

                for( int i = 0; i < intGridRowData; i++ ) {

                    gridRowData = gridData.get( i );
             
                    gridRowData.put( "HOUSE_CODE",	MapUtils.getString( headerData, "HOUSE_CODE" ) );
                    gridRowData.put( "BID_NO",	MapUtils.getString( headerData, "BID_NO" ) );
                    gridRowData.put( "BID_COUNT",	MapUtils.getString( headerData, "BID_COUNT" ) ); 
                    gridRowData.put( "VOTE_COUNT",	MapUtils.getString( headerData, "VOTE_COUNT" ) ); 
                    gridRowData.put( "COMPANY_CODE",	MapUtils.getString( headerData, "COMPANY_CODE" ) );
                    gridRowData.put( "ITEM_SEQ",	MapUtils.getString( gridRowData, "ITEM_SEQ","" ) ); 
                    gridRowData.put( "ID",	MapUtils.getString( headerData, "ID" ) ); 
                    
            		rtn = ssm.doInsert(gridRowData);
                }
            } 

    	}catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		throw new Exception(e.getMessage());
    	}finally {
    	}
    	
    	return rtn;
    }
	
    
    public SepoaOut getBDHD_VnInfo(Map< String, String > headerData)
    {
        ConnectionContext ctx = getConnectionContext(); 
        String company_code   = info.getSession("COMPANY_CODE"); 
 
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
 
        String rtnData = null;
        try {
            headerData.put("HOUSE_CODE", HOUSE_CODE); 
            headerData.put("COMPANY_CODE", company_code); 
            
    		sxp = new SepoaXmlParser(this, "getBDHD_VnInfo");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
            setValue( ssm.doSelect (headerData)); 
            setStatus(1); 
            setMessage("");
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage("");
        }
        return getSepoaOut();
    }  
    
    public SepoaOut getVNCP(Map< String, Object > allData)
    {
    	ConnectionContext ctx = getConnectionContext(); 
    	
    	SepoaXmlParser sxp = null;
    	SepoaSQLManager ssm = null;
    	
    	String rtnData = null;
    	try {
    		sxp = new SepoaXmlParser(this, "getVNCP");
    		ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
    		setValue( ssm.doSelect (MapUtils.getMap( allData, "headerData" ))); 
    		setStatus(1); 
    		setMessage("");
    	} catch(Exception e) {
    		Logger.err.println(userid,this,e.getMessage());
    		setStatus(0);
    		setMessage("");
    	}
    	return getSepoaOut();
    }  

    public SepoaOut getRankQuery(Map< String, String > headerData ) throws Exception 
    {
    	setStatus(1);
    	setFlag(true);
        ConnectionContext ctx = getConnectionContext();
        String rtn = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	headerData.put("HOUSE_CODE", HOUSE_CODE);

        	sxp = new SepoaXmlParser(this, "getRankQuery"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
			setValue(ssm.doSelect(headerData));
			
        } catch(Exception e) {
        	setStatus(0);
        	setFlag(false);
        	setMessage(e.getMessage());
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return getSepoaOut();
    }

    public SepoaOut getHistoryQuery(Map< String, String > headerData ) throws Exception 
    {
    	setStatus(1);
    	setFlag(true);
        ConnectionContext ctx = getConnectionContext();
        String rtn = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	
        	headerData.put("HOUSE_CODE", HOUSE_CODE);

        	sxp = new SepoaXmlParser(this, "getHistoryQuery"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
			setValue(ssm.doSelect(headerData));
			
        } catch(Exception e) {
        	setStatus(0);
        	setFlag(false);
        	setMessage(e.getMessage());
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return getSepoaOut();
    }
    
}//  
