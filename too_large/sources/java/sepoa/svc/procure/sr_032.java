package sepoa.svc.procure;

import java.util.HashMap;
import java.util.Map;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaStringTokenizer;


public class SR_032 extends SepoaService{
	
  	String language 	= "";
  	String serviceId 	= "p0080";
	Message msg = new Message(info, "FW");

	//정량평가 정보
	int SCORE_FIVE 		= 5;
	int SCORE_FOUR 		= 4;
	int SCORE_THREE 	= 3;
	int SCORE_TWO 		= 2;
	int SCORE_ONE 		= 1;
	//업체 선정 평가 - 정량평가항목 코드
	String QUA_TUNKEY_NO_1  = "25";		//- 원가 절감액
	String QUA_TUNKEY_NO_2  = "27";		//- 인력 단가 적절성
	String QUA_TUNKEY_NO_3  = "37";		//- R&D 투자비중
	String QUA_TUNKEY_NO_4  = "50";		//- 신용 평가 등급
	String QUA_TUNKEY_NO_5  = "53";		//- 경영자의 해당 업종 근무
	//종합평가 - 정량평가항목 코드
	String QUA_SCHEDULE_NO_1 = "85";	//신용 평가 등급
	String QUA_SCHEDULE_NO_2 = "89";	//경영자의 해당 업종 근무연수 
	String QUA_SCHEDULE_NO_3 = "113";	//현금흐름등급 
	String QUA_SCHEDULE_NO_4 = "55";	//원가 절감률
	String QUA_SCHEDULE_NO_5 = "57";	//인력단가 적절성 
	String QUA_SCHEDULE_NO_6 = "56";	//투입공수의 적절성 
	String QUA_SCHEDULE_NO_7 = "58";	//재거래의사 
	String QUA_SCHEDULE_NO_8 = "59";	//사용자 품질 만족도
	String QUA_SCHEDULE_NO_9 = "60";	//결과물 품질
	String QUA_SCHEDULE_NO_10 = "61";	//투입인력의 팀워크/리더십
	String QUA_SCHEDULE_NO_11 = "62";	//업무 성실성
	String QUA_SCHEDULE_NO_12 = "74";	//우수 인력 비율
	String QUA_SCHEDULE_NO_13 = "75";	//기술력
	String QUA_SCHEDULE_NO_14 = "76";	//산업 이해도
	String QUA_SCHEDULE_NO_15 = "77";	//투입인력의 자격 인증
	String QUA_SCHEDULE_NO_16 = "78";	//프로젝트 수행이력
	String QUA_SCHEDULE_NO_17 = "81";	//업무 협조도
	String QUA_SCHEDULE_NO_18 = "82";	//기술지원 상태
	String QUA_SCHEDULE_NO_19 = "83";	//입찰 요청 대비 응찰율
	String QUA_SCHEDULE_NO_20 = "84";	//투입 인력 정확도
	String QUA_SCHEDULE_NO_21 = "87";	//정규직 비율
	
	//종합평가  - 정량평가대상 평가항목 코드
	String QUA_FACTOR_NO_1 = "1";			//투입인력의 팀워크/리더십
	String QUA_FACTOR_NO_2 = "2";			//업무 성실성
	String QUA_FACTOR_NO_3 = "3";			//기술력
	String QUA_FACTOR_NO_4 = "4";			//프로젝트 수행이력
	String QUA_FACTOR_NO_5 = "5";			//산업 이해도
	String QUA_FACTOR_NO_6 = "6";			//투입인력의 자격인증
	String QUA_FACTOR_NO_7 = "7";			//결과물 품질
	String QUA_FACTOR_NO_9 = "9";			//업무협조도
	String QUA_FACTOR_NO_10 = "10";			//기술지원상태
	String QUA_FACTOR_NO_11 = "11";			//투입 공수의 적절성
	String QUA_FACTOR_NO_14 = "14";			//투입인력 정확도
	String QUA_FACTOR_NO_15 = "15";			//사용자 품질 만족도
	String QUA_FACTOR_NO_19 = "19";			//재거래 의사
	
	
  	public SR_032( String opt, SepoaInfo sinfo ) throws SepoaServiceException{
      	super( opt, sinfo );
      	setVersion( "1.0.0" );
  	}
  	
  	public SepoaOut getEvabdlis1(String evalname, String status, String from_date, String to_date) 
  	{
		String rtn = null;

		try 
		{
			rtn = et_getEvabdlis1( evalname, status, from_date, to_date);

			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getTmpList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}
  	
  	private String et_getEvabdlis1(String evalname, String status, String from_date, String to_date) throws Exception 
	{
    	String house_code 	= info.getSession("HOUSE_CODE");
    	String user_id 		= info.getSession("ID");
   		String rtn = null;

   		ConnectionContext ctx = getConnectionContext();

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code",house_code );
		wxp.addVar("from_date",from_date );
		wxp.addVar("to_date",to_date );
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
        String[] data = {status, evalname};

		rtn = sm.doSelect(data);
		return rtn;

	}
  	
  	/*
  	 * 평가완료 
  	 */
  	public SepoaOut setEvabdcom1(String[][] eval_refitem) 
	{
		String rtn[] = null;

	   	try 
	   	{
    		rtn = et_setEvabdcom1(eval_refitem[0][0]);
    		
    		setValue( rtn[0] );
    		setStatus( 1 );
    		setMessage( rtn[ 0 ] );
    		
    		if ( rtn[ 1 ] != null )
    		{
    		    setMessage( rtn[ 1 ] );
    		    setStatus( 0 );
    		}
    	} catch ( Exception e ) 
    	{
    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
    	    setStatus( 0 );
    	}
    	
    	return getSepoaOut();
  	}
  	
  	private String[] et_setEvabdcom1(String eval_refitem) throws Exception
  	{
  		
    	String returnString[] = new String[ 2 ];
    	ConnectionContext ctx = getConnectionContext();
    	
    	String user_id = info.getSession("ID");
    	String house_code 	= info.getSession("HOUSE_CODE");
    	
    	int rtnIns = 0;
    	SepoaFormater wf = null;
    	SepoaSQLManager sm = null;
    	
		try
		{
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
			wxp.addVar("house_code",house_code );
			wxp.addVar("eval_refitem",eval_refitem );
			
 	    	sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
    	    String rtn = sm.doSelect();
    	    wf =  new SepoaFormater(rtn);
    	    
    	    String templete_type = "0";
			String doc_type = "";
  	    	String doc_no = "";
  	    	String doc_count = "";
	    		
  	    	if(wf != null && wf.getRowCount() > 0) {
	    		templete_type	= wf.getValue(0, 0);
				doc_type 		= wf.getValue(0, 1);
				doc_no 			= wf.getValue(0, 2);
				doc_count 		= wf.getValue(0, 3);
			}
		    String eval_score = "";
				
			//평가대상 업체 가져오기
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
			wxp.addVar("eval_refitem",eval_refitem );
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			wf =  new SepoaFormater(rtn);
			int cnt = wf.getRowCount();
			String[] eval_item_refitem = new String[cnt];
			
			for(int i=0; i < cnt; i++) 
			{
				eval_item_refitem[i] = wf.getValue(i, 0);//(0,0)에서 수정
			}
			
			SepoaXmlParser wxp_3 =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_3");
				
			for(int j=0; j < cnt; j++) 
			{
				
				eval_score = "0";
				wxp_3.addVar("eval_item_refitem",eval_item_refitem[j] );
				sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp_3.getQuery());
    	    	rtn = sm.doSelect();
				wf =  new SepoaFormater(rtn);
			
				if(wf != null && wf.getRowCount() > 0) 
				{
					double score = 0.0;
					int valuer_cnt = 0;
				
					for(valuer_cnt=0; valuer_cnt < wf.getRowCount(); valuer_cnt++) 
					{
	    	    		String str = wf.getValue("COMPLETE_MARK", valuer_cnt);		    	    	
	    	    		if(str.equals("Y")) 
	    	    		{
	    	    			score = score + Double.parseDouble(wf.getValue("SCORE", valuer_cnt));
	    	    		}
	    	    	}

					int ieval_score = (int)((score/(double)valuer_cnt)*100);
					double deval_score = (double)ieval_score/100.0;

	    	    	eval_score = String.valueOf(deval_score);
				}		    	    
				 
    	    	//해당 업체에 대한 평가 완료 - 점수부여
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_4");
				wxp.addVar("eval_score",eval_score );
				wxp.addVar("eval_refitem",eval_refitem );
				wxp.addVar("eval_item_refitem",eval_item_refitem[j] );
		    	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
		    	rtnIns = sm.doUpdate();
				 
			} // for
				
			//정량평가 처리 -- 선정평가, 종합(정기)평가
			Configuration configuration = new Configuration();                                
		    String sEvalTunkey = configuration.get("Sepoa.eval.tunkey"); //도급업체 선정평가 
		    String sEvalComp = configuration.get("Sepoa.eval.comp"); //종합평가 
			
			int isOk = 0;
			if(templete_type.equals(sEvalTunkey)){
			//	isOk =  setEvalTunkey(ctx, eval_refitem);
			}else if(templete_type.equals(sEvalComp)){
			//	isOk =  setEvalSchedule(ctx, eval_refitem);
			}
			
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_6");
			wxp.addVar("eval_refitem",eval_refitem );
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
			rtnIns = sm.doUpdate();
			

    		//입찰, 견적, 역경매 선정/제안 평가 상태 업데이트
    		SepoaXmlParser wxp_ =  null;
			if(!"".equals(doc_type)){
				if("BD".equals(doc_type)){
					wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_BD");
				}else if("RA".equals(doc_type)){
					wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_RA");
				}else if("RQ".equals(doc_type)){
					wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_RQ");
				}
//				try{
					String strEvalFlag = "C";	//평가완료
					if(wxp_ != null){ 
						wxp_.addVar("eval_flag", strEvalFlag);			
						wxp_.addVar("house_code", house_code);			
						wxp_.addVar("doc_no", doc_no);	
						wxp_.addVar("doc_count", doc_count);
						sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_.getQuery() );
				    	rtnIns = sm.doUpdate(); }
//				}catch(NullPointerException ne){
//					
//				}
			}
	    	
			
	       	returnString[0] = "all_complete";
    	    	
	       	Commit();
			
    	} catch( Exception e ) 
    	{
    	    Rollback();
    	    returnString[ 1 ] = e.getMessage();
    	}  finally { }

    	return returnString;
  	}  
  	
  	/*
  	 * ***************************************************************************************************************************************************
  	 // 2010.08
  	 // 정량평가 계산 변경으로 인해 사용 안함.
  	   ***************************************************************************************************************************************************
  	private String qntEvaluation_cjk(String eval_refitem, String ceval_item_refitem) throws Exception 
  	{
    	ConnectionContext ctx = getConnectionContext();
    	String user_id = info.getSession("ID");
    	
    	int rtnIns = 0;
    	String rtn = null;
    	String retArr = null;
    	SepoaFormater wf = null;
    	SepoaSQLManager sm = null;
  	    	
    	//1. 평가항목 구하기
    	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_7");
		wxp.addVar("eval_refitem",eval_refitem );
		
		 
		sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
        rtn = sm.doSelect();
  	    wf =  new SepoaFormater(rtn);
  	    	
    	String[] factor_num = null;
    	String[] weight = null;
	
//		if(wf != null && wf.getRowCount() > 0) 
		if(wf != null) 
		{
			int count = wf.getRowCount();
    		factor_num = new String[count];
    		weight = new String[count];
    		
    		for(int i=0; i < count; i++) 
    		{
    			factor_num[i] = wf.getValue(i, 0);
    			weight[i] = wf.getValue(i, 1);
    		}
  	    	
  	    	//2.정량 평가 항목이 있으면, 정량평가 계산
  	    	wf = null;
  	    	double factor_constant = 7.0;
  	    	String[] vendor_code = null;
  	    	String[] term = null;
  	    	String[] eval_item_refitem = null;
  	    	String[] eval_item_refitem2 = null;
  	    	String[] e_factor_refitem = null;
  	    	String[] eval_score = null;
  	    	String[] dstb_score = null;
  	    	String[] cnvt_score = null;
  	    	String[] returnScore = null;
  	    	
			
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_8");
			wxp.addVar("eval_refitem",eval_refitem );
			wxp.addVar("ceval_item_refitem",ceval_item_refitem );
			 
			sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
	        rtn = sm.doSelect();
    	    wf =  new SepoaFormater(rtn);
    	    	
			if(wf != null && wf.getRowCount() > 0) 
			{
				int cnt = wf.getRowCount();			//정량평가할 벤더수
				int factor_cnt = factor_num.length;	//선택된 팩터의 갯수
				int score_cnt = 0;  				//전체 루프에 대한 카운터( =cnt * factor_cnt )
				int current_cnt = 0;				//총점 계산시 사용되는 카운터
				
				vendor_code = new String[cnt];
				term = new String[cnt * factor_cnt];
				eval_item_refitem = new String[cnt * factor_cnt];
				eval_item_refitem2 = new String[cnt];
				eval_score = new String[cnt * factor_cnt];
				dstb_score = new String[cnt * factor_cnt];
				cnvt_score = new String[cnt * factor_cnt];
				e_factor_refitem = new String[cnt * factor_cnt];
				returnScore = new String[cnt];
			
  	    		for(int i=0; i < wf.getRowCount(); i++) 
  	    		{
 	    			vendor_code[i] = wf.getValue(i , 0);
  	    			eval_item_refitem2[i] = wf.getValue(i, 11);
  	    			
  	    			double qf_point = 0.0;
  	    			double df_point = 0.0;
  	    			double hf_point = 0.0;
  	    			double mf_point = 0.0;
  	    			double add 		= 0.0;
  	    			double total 	= 0.0;
  	    			
  	    			//선택된 항목의 평가값구하기...	
  	    			for(int j=0; j < factor_cnt; j++) 
  	    			{
  	    				e_factor_refitem[score_cnt] = factor_num[j];
  	    				term[score_cnt] = wf.getValue(i, 10);
  	    				eval_item_refitem[score_cnt] = wf.getValue(i, 11);
  	    				
  	    				int k = Integer.parseInt(factor_num[j]);

  	    				switch(k) 
  	    				{
  	    					case -1 :
  	    						
  	    						eval_score[score_cnt] = wf.getValue("QF_SCORE", i);
  	    						dstb_score[score_cnt] = wf.getValue("QF_DSCORE", i);
  	    						
  	    						double qf = Double.parseDouble(wf.getValue("QF_SCORE", i));
  	    						double qfd = Double.parseDouble(wf.getValue("QF_DSCORE", i));
  	    						qf_point = ((qf / qfd) * factor_constant) / 100 * Double.parseDouble(weight[j]);

								int iqf_point = (int)(qf_point*100);
								double dqf_point = (double)iqf_point/100.0;

  	    						cnvt_score[score_cnt] = String.valueOf(dqf_point);

  	    						break;
  	    					
  	    					case -2 :
  	    						
  	    						eval_score[score_cnt] = wf.getValue("DF_SCORE", i);
  	    						dstb_score[score_cnt] = wf.getValue("DF_DSCORE", i);
  	    						
  	    						double df = Double.parseDouble(wf.getValue("DF_SCORE", i));
  	    						double dfd = Double.parseDouble(wf.getValue("DF_DSCORE", i));
  	    						df_point = ((df / dfd) * factor_constant) / 100 * Double.parseDouble(weight[j]);

								int idf_point = (int)(df_point*100);
								double ddf_point = (double)idf_point/100.0;

  	    						cnvt_score[score_cnt] = String.valueOf(ddf_point);
  	    						break;
  	    					
  	    					case -3 :
  	    						
  	    						eval_score[score_cnt] = wf.getValue("HF_SCORE", i);
  	    						dstb_score[score_cnt] = wf.getValue("HF_DSCORE", i);
  	    						
  	    						double hf = Double.parseDouble(wf.getValue("HF_SCORE", i));
  	    						double hfd = Double.parseDouble(wf.getValue("HF_DSCORE", i));
  	    						hf_point = ((hf / hfd) * factor_constant) / 100 * Double.parseDouble(weight[j]);

								int ihf_point = (int)(hf_point*100);
								double dhf_point = (double)ihf_point/100.0;

  	    						cnvt_score[score_cnt] = String.valueOf(dhf_point);
  	    						break;
  	    					
  	    					case -4 :
  	    						
  	    						eval_score[score_cnt] = wf.getValue("MF_SCORE", i);
  	    						dstb_score[score_cnt] = wf.getValue("MF_DSCORE", i);
  	    						
  	    						double mf = Double.parseDouble(wf.getValue("MF_SCORE", i));
  	    						double mfd = Double.parseDouble(wf.getValue("MF_DSCORE", i));
  	    						mf_point = ((mf / mfd) * factor_constant) / 100 * Double.parseDouble(weight[j]);

								int imf_point = (int)(mf_point*100);
								double dmf_point = (double)imf_point/100.0;

  	    						cnvt_score[score_cnt] = String.valueOf(dmf_point);
  	    						break;
  	    					
  	    					case -5 :
  	    						
  	    						eval_score[score_cnt] = wf.getValue("ADD_SCORE", i);
  	    						dstb_score[score_cnt] = "0";
  	    						
  	    						add = Double.parseDouble(wf.getValue("ADD_SCORE", i)) / 100 * Double.parseDouble(weight[j]);

								int iadd = (int)(add*100);
								double dadd = (double)iadd/100.0;

  	    						cnvt_score[score_cnt] = String.valueOf(dadd);
  	    						break;
  	    					
  	    					
  	    				}
  	    				score_cnt++;

  	    			}
  	    			//총점 입력

					int iqf_point = (int)(qf_point*100);
					double dqf_point = (double)iqf_point/100.0;

					int idf_point = (int)(df_point*100);
					double ddf_point = (double)idf_point/100.0;

					int ihf_point = (int)(hf_point*100);
					double dhf_point = (double)ihf_point/100.0;

					int imf_point = (int)(mf_point*100);
					double dmf_point = (double)imf_point/100.0;

					int iadd = (int)(add*100);
					double dadd = (double)iadd/100.0;

  	    			total = dqf_point + ddf_point + dhf_point + dmf_point + dadd;

		    		retArr = String.valueOf(total);
  	    		}

				
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_9");
				
				 
				String[][] value = new String[score_cnt][6];
				
				for(int i=0; i < score_cnt; i++) 
				{
					value[i][0] = eval_item_refitem[i];
					value[i][1] = term[i];
					value[i][2] = e_factor_refitem[i];
					value[i][3] = eval_score[i];
					value[i][4] = dstb_score[i];
					value[i][5] = cnvt_score[i];
				}	
		    	
		    	String[] type = { "S", "S", "S", "S", "S", "S" };
			
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert( value, type );
	       	}
    	}
    	else
    	{
    		retArr = "0";
    	}	
  	    return retArr;
  	} 
  	*/
  	
  	public SepoaOut setEvabddel1(String[][] eval_refitem) 
  	{
    	String rtn[] = null;

    	try 
    	{
    		rtn = et_setEvabddel1(eval_refitem);
 
    		setMessage( rtn[ 0 ] );
    		setStatus( 1 );
    		
    		if ( rtn[ 1 ] != null )
    		{
    		    setMessage( rtn[ 1 ] );
    		    setStatus( 0 );
    		}
    	} catch ( Exception e ) {
    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
    	    setStatus( 0 );
    	}
    	return getSepoaOut();
  	}
	
  	private String[] et_setEvabddel1(String[][] eval_refitem) throws Exception 
  	{
    	String returnString[] = new String[ 2 ];
    	ConnectionContext ctx = getConnectionContext();
    	
    	String user_id = info.getSession("ID");
    	
    	int rtnIns = 0;
    	SepoaFormater wf = null;
    	SepoaSQLManager sm = null;
		
		try 
		{		
			String i_eval_refitem = "";

        	for ( int i = 0; i < eval_refitem.length; i++ )
			{
				i_eval_refitem = eval_refitem[i][0];

				//평가대상업체 평가자 테이블 삭제
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
				wxp.addVar("i_eval_refitem", i_eval_refitem);
				 
	    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert();

				//평가대상업체 테이블 삭제
	    		wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
				wxp.addVar("i_eval_refitem", i_eval_refitem);
				 
	    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert();

				//평가테이블 삭제
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_3");
				wxp.addVar("i_eval_refitem", i_eval_refitem);
				 
	    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert();

			}	

  	    	Commit();
  	    } catch( Exception e ) {
    	    Rollback();
    	    returnString[ 1 ] = e.getMessage();
    	} finally { }
  	  	
  	  	return returnString;
  	} 
  	
  	public SepoaOut getEvabdlis3(String eval_refitem) 
  	{
		String rtn = null;

		try 
		{
			rtn = et_getEvabdlis3( eval_refitem );

			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getTmpList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getEvabdlis3(String eval_refitem) throws Exception 
	{
    	String house_code 	= info.getSession("HOUSE_CODE");
    	String user_id 		= info.getSession("ID");
   		String rtn = null;

   		ConnectionContext ctx = getConnectionContext();

		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
 		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());

		rtn = sm.doSelect();
		return rtn;

	}
  	
	
public SepoaOut getEvalProperty(String eval_refitem){
		
		String rtn = null;
		try{
			
			String user_id = info.getSession("ID");
			
			rtn = SR_getEvalProperty( eval_refitem );
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getSgContentsNames faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}


	private String SR_getEvalProperty(String eval_refitem) throws Exception {

   		String rtn = null;
   		String house_code 	= info.getSession("HOUSE_CODE");
   		ConnectionContext ctx = getConnectionContext();
   		
   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
   		wxp.addVar("eval_refitem", eval_refitem);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());

		rtn = sm.doSelect();
		return rtn;
	}
	
	public SepoaOut getEvabdupd1(String eval_refitem)
	{
		String rtn = null;

		try
		{
			rtn = et_getEvabdupd1(eval_refitem);
			setValue(rtn);
			setStatus(1);
		}catch(Exception e){
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("ExpandTree faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();

	}

	private String et_getEvabdupd1(String eval_refitem) throws Exception
	{
   		String rtn = null;
   		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("house_code", house_code);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
                     
		rtn = sm.doSelect();
		return rtn;
	}
	
	public SepoaOut getEvabdupd2(String eval_item_refitem)
	{
		String rtn = null;

		try
		{
			rtn = et_getEvabdupd2(eval_item_refitem);
			setValue(rtn);
			setStatus(1);
		}catch(Exception e){
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("ExpandTree faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();

	}

	private String et_getEvabdupd2(String eval_item_refitem) throws Exception
	{
   		String rtn = null;
   		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
				
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("company_code", company_code);
		wxp.addVar("eval_item_refitem", eval_item_refitem);
		             
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
                     
		rtn = sm.doSelect();
		return rtn;
	}
	
	public SepoaOut getEvappins1(String USER_ID, String USER_NAME)
	{
		String rtn = null;

		try
		{
			rtn = et_getEvappins1(USER_ID, USER_NAME);
			setValue(rtn);
			setStatus(1);
		}catch(Exception e){
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("ExpandTree faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();

	}

	private String et_getEvappins1(String USER_ID, String USER_NAME) throws Exception
	{
   		String rtn = null;
   		ConnectionContext ctx = getConnectionContext();
		String house_code 	= info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("company_code", company_code);
		         
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
        String[] data = {USER_ID, USER_NAME};
                     
		rtn = sm.doSelect(data);
		return rtn;
	}
	
	public SepoaOut getEvaTemp(String e_template_refitem){
		
		try {
		    String user_id = info.getSession("ID");
		    String rtn = "";
		    rtn = et_getEvaTemp(user_id, e_template_refitem);
		    
		    setValue(rtn);
		    setStatus(1);
		    setMessage(msg.getMessage("0000"));
		} catch(Exception e) {
		    Logger.err.println("Exception e =" + e.getMessage());
		    setStatus(0);
		    setMessage(msg.getMessage("0001"));
		    Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}


	private String et_getEvaTemp(String user_id, String e_template_refitem) throws Exception {
	    
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		String house_code 	= info.getSession("HOUSE_CODE");
		
		try {
		    
		    SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("e_template_refitem", e_template_refitem);
			wxp.addVar("house_code", house_code);
		       
	     	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery()); 	
	     	rtn = sm.doSelect(); 
		     
		     if(rtn == null) throw new Exception("SQL Manager is Null");
		     	
		} catch(Exception e) {
		     throw new Exception("et_getEvaTemp:"+e.getMessage());
		} finally {
		     //Release();
		}
		return rtn;
	}
	
	public SepoaOut getEvabdlis4(String eval_refitem) 
  	{
		String rtn = null;

		try 
		{
			rtn = et_getEvabdlis4( eval_refitem );

			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getTmpList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getEvabdlis4(String eval_refitem) throws Exception 
	{
    	String house_code 	= info.getSession("HOUSE_CODE");
    	String user_id 		= info.getSession("ID");
   		String rtn = null;

   		ConnectionContext ctx = getConnectionContext();

		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());

		rtn = sm.doSelect();
		return rtn;

	}
	
	public SepoaOut getValuerList(String eval_item_refitem) 
	{
		String rtn = null;

		try 
		{
			String user_id = info.getSession("ID");
			
			rtn = SR_getValuerList( user_id, eval_item_refitem );
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvaluationVendorList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String SR_getValuerList( String user_id, String eval_item_refitem ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		ConnectionContext ctx = getConnectionContext();
				
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_item_refitem", eval_item_refitem);
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
	
	public SepoaOut getQntEvalTempSelectedFactor(String eval_item_refitem ) 
	{
		String rtn = null;

		try 
		{
			rtn = SR_getQntEvalTempSelectedFactor( eval_item_refitem  );
			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvalTempFactorList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String SR_getQntEvalTempSelectedFactor( String eval_item_refitem ) throws Exception 
	{
   		String rtn = null;
   		ConnectionContext ctx = getConnectionContext();
				
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("eval_item_refitem", eval_item_refitem);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
	
	public SepoaOut getEvaDetailList(Map<String, Object> data) 
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String rtn = null;
		String e_template_refitem = (String) data.get("e_template_refitem");
		String temp_type = (String) data.get("template_type");
		String factor_type = "";
		String eval_valuer_refitem = (String) data.get("eval_valuer_refitem");
		String qnt_flag = (String) data.get("qnt_flag");
		try {
			rtn = getEvaDetailList( e_template_refitem, temp_type, factor_type, eval_valuer_refitem, qnt_flag );
			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvaDetailList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String getEvaDetailList( String e_template_refitem, String temp_type, String factor_type, String eval_valuer_refitem, String qnt_flag ) throws Exception {
		String rtn = null;
   		ConnectionContext ctx = getConnectionContext();
   		Map<String, String> header = new HashMap<String, String>();
		header.put("e_template_refitem", e_template_refitem);
		header.put("temp_type", temp_type);
		header.put("factor_type", factor_type);
		header.put("eval_valuer_refitem", eval_valuer_refitem);
		header.put("qnt_flag", qnt_flag);

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,"getEvaDetailList");
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp);
		rtn = sm.doSelect(header);
		return rtn;
	}
	
	public SepoaOut getEvabdlis6(String vendor_code, String eval_name) 
  	{
		String rtn = null;

		try 
		{
			rtn = et_getEvabdlis6( vendor_code, eval_name );

			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvabdlis6 faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getEvabdlis6(String vendor_code, String eval_name ) throws Exception 
	{
    	String house_code 	= info.getSession("HOUSE_CODE");
    	String user_id 		= info.getSession("ID");
   		String rtn = null;

   		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());

        String[] data = {eval_name, vendor_code};
		rtn = sm.doSelect(data);

		return rtn;
	}
	
	public SepoaOut getEvabdlis2(String evalname) 
  	{
		String rtn = null;

		try 
		{
			rtn = et_getEvabdlis2( evalname );

			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getTmpList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getEvabdlis2(String evalname) throws Exception 
	{
    	String house_code 	= info.getSession("HOUSE_CODE");
    	String user_id 		= info.getSession("ID");
   		String rtn = null;

   		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("user_id", user_id);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
        String[] data = {evalname};

		rtn = sm.doSelect(data);
		return rtn;

	}
	
	public SepoaOut getEvaluationVendorList(String eval_refitem) {
		
		String rtn = null;
		try {
			
			String user_id = info.getSession("ID");
			
			rtn = SR_getEvaluationVendorList( user_id, eval_refitem );
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvaluationVendorList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}
	

	public SepoaOut getEvaluationVendorList_1(String eval_refitem, String user_id) {
		
		String rtn = null;
		try {
			
			rtn = SR_getEvaluationVendorList_1( user_id, eval_refitem );
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvaluationVendorList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}
	
	public SepoaOut getEvaluationVendorList_2(String eval_refitem) {
		
		String rtn = null;
		try {
			String user_id = info.getSession("ID");
			rtn = SR_getEvaluationVendorList_2( user_id, eval_refitem );
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvaluationVendorList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String SR_getEvaluationVendorList( String user_id, String eval_refitem ) throws Exception {

   		String rtn = null;
   		String house_code 	= info.getSession("HOUSE_CODE");
    	
   		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("user_id", user_id);
		
 		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
	
	/*
	 * 제안평가용 
	 */
	private String SR_getEvaluationVendorList_1( String user_id, String eval_refitem ) throws Exception {

   		String rtn = null;
   		String house_code 	= info.getSession("HOUSE_CODE");
    	
   		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("user_id", user_id);
		
 		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
	
	/*
	 * 개발자 평가 조회 
	 */
	private String SR_getEvaluationVendorList_2( String user_id, String eval_refitem ) throws Exception {
		
		String rtn = null;
		String house_code 	= info.getSession("HOUSE_CODE");
		
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("user_id", user_id);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}

	public SepoaOut getEvaluationValuerList(String eval_refitem) {
		
		String rtn = null;
		try {
			
			rtn = et_getEvaluationValuerList( eval_refitem );
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvaluationVendorList faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getEvaluationValuerList( String eval_refitem ) throws Exception {

   		String rtn = null;
   		String house_code 	= info.getSession("HOUSE_CODE");
    	
   		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
		
 		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
	
	public SepoaOut getEvabdlis5(String evalname, String vendor_code) 
  	{
		String rtn = null;

		try 
		{
			rtn = et_getEvabdlis5( evalname, vendor_code );

			setValue(rtn);
			setStatus(1);			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getEvabdlis5 faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getEvabdlis5(String evalname, String vendor_code) throws Exception 
	{
    	String house_code 	= info.getSession("HOUSE_CODE");
    	String user_id 		= info.getSession("ID");
   		String rtn = null;

   		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("user_id", user_id);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
        String[] data = {evalname, vendor_code};

		rtn = sm.doSelect(data);
		return rtn;

	}
	
	public SepoaOut setEvabdupd1(String[][] SetData, String eval_refitem, String fromdate, String todate, String flag)	
	{
    	String rtn[] = null;

    	try
    	{
    		rtn = et_setEvabdupd1(SetData, eval_refitem, fromdate, todate, flag);
    		
    		setValue( rtn[0] );
    		setStatus( 1 );
    		
    		if ( rtn[ 1 ] != null ) {
    		    setMessage( rtn[ 1 ] );
    		    setStatus( 0 );
    		}
    		
    	} catch ( Exception e ) {
    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
    	    setStatus( 0 );
    	}
    	return getSepoaOut();
	}

	private String[] et_setEvabdupd1(String[][] SetData, String eval_refitem, String fromdate, String todate, String flag) throws Exception 
	{
    	String returnString[] = new String[ 2 ];
    	ConnectionContext ctx = getConnectionContext();
    	
    	String user_id 		= info.getSession("ID");
    	String house_code 	= info.getSession("HOUSE_CODE");
    	
    	int rtnIns = 0;
    	SepoaFormater wf = null;
    	SepoaSQLManager sm = null;

		try 
		{
			//평가테이블 수정
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
			wxp.addVar("fromdate", fromdate);
			wxp.addVar("todate", todate);
			wxp.addVar("flag", flag);
			wxp.addVar("eval_refitem", eval_refitem);
			wxp.addVar("house_code", house_code);
			
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
    		rtnIns = sm.doInsert();
					
			String i_sg_refitem = "";
			String i_vendor_code = "";
			String i_value_id = "";
			String i_eval_item_refitem = "";

        	for ( int i = 0; i < SetData.length; i++ )
        	{
				i_sg_refitem = SetData[i][2];
				i_vendor_code = SetData[i][0];
				i_value_id 	= SetData[i][3];
				i_eval_item_refitem = SetData[i][4];

				//평가대상업체 테이블 삭제
				if(i == 0)
				{
					//평가대상업체 평가자 테이블 삭제  (위치변경 2012-9-20)
					
		    		wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_4");
					wxp.addVar("eval_refitem", eval_refitem);
					
					/*
					sql.append( " DELETE FROM ICOMVEVL  						\n " );
					sql.append( " WHERE  EVAL_ITEM_REFITEM = '"+i_eval_item_refitem+"'  \n " );
					*/
					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
		    		rtnIns = sm.doInsert();

					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
					wxp.addVar("eval_refitem", eval_refitem);
					
					/*
					sql.append( " DELETE FROM ICOMVEVD  							\n " );
					sql.append( " WHERE  EVAL_REFITEM = '"+eval_refitem+"'  			\n " );
					*/
					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
		    		rtnIns = sm.doInsert();
				}
				//평가대상업체 테이블 생성
				
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_3");
				wxp.addVar("house_code", house_code);
				wxp.addVar("i_sg_refitem", i_sg_refitem);
				wxp.addVar("i_vendor_code", i_vendor_code);
				wxp.addVar("eval_refitem", eval_refitem);
    	    	
	    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert();
				
				//평가자 생성하기
                SepoaStringTokenizer st = new SepoaStringTokenizer(i_value_id, "#", false);
                int row_cnt = st.countTokens();
                String[][] value_data = new String[row_cnt][2];

                for ( int j = 0 ; j < row_cnt ; j++ ) 
                {
                    SepoaStringTokenizer st1 = new SepoaStringTokenizer(st.nextToken().trim(), "@", false);
                    int row_cnt1 = st1.countTokens();

                    for ( int k = 0 ; k < row_cnt1 ; k++ ) 
                    {
                        String tmp_data = st1.nextToken().trim();
						
						if(k == 0)
							value_data[j][0] = tmp_data;//부서코드
						else if(k ==3)
							value_data[j][1] = tmp_data;//평가자ID
					}
				}

				String i_dept = "";
				String i_id = "";
				
	        	for ( int ii = 0; ii < row_cnt; ii++ )
	        	{
					i_dept 	= value_data[ii][0];
					i_id 	= value_data[ii][1];

					//평가대상업체 평가자 테이블 생성
					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_5");
					wxp.addVar("house_code", house_code);
					wxp.addVar("i_dept", i_dept);
					wxp.addVar("i_id", i_id);
					wxp.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));
					
		    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
		    		rtnIns = sm.doInsert();
				}
        	}	
        	
        	Commit();
    	} catch( Exception e ) {
    	    Rollback();
    	    returnString[ 1 ] = e.getMessage();
    	} finally { }

    	return returnString;
	}
	
	 public double getCurrVal(String tableName, String columnName){
	    	double currVal = 0;
	  	    SepoaOut wo = currvalForMssql(tableName, columnName);
	  	    try{
		  	    SepoaFormater wf2 = new SepoaFormater(wo.result[0]);
		  	    currVal = Double.parseDouble((wf2.getValue("CURRVAL",0)));
	  	    } catch(Exception e){
	  	    	currVal = 0;
	  	    }
	    	return currVal;
	    }
	 
	 public SepoaOut currvalForMssql(String tableName, String columnName){

         try{
              String rtn = "";
      		ConnectionContext ctx = getConnectionContext();
      		String house_code = info.getSession("HOUSE_CODE");
      		String user_id = info.getSession("ID");
      	
  			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("columnName", columnName);
			wxp.addVar("tableName", tableName);
			wxp.addVar("house_code", house_code);
  			
  			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
  			rtn = sm.doSelect();
      	
              setValue(rtn);
              setStatus(1);

          } catch(Exception e) {

              Logger.err.println("Exception e =" + e.getMessage());
              setStatus(0);
              Logger.err.println(this,e.getMessage());
          }
          return getSepoaOut();
      }    
	 
	 public SepoaOut getTmpList(String tmp_name)	{
			
			String rtn = null;
			try{
				
				String user_id = info.getSession("ID");
				
				rtn = SR_getTmpList( tmp_name);
				setValue(rtn);
				setStatus(1);
				
			} catch(Exception e) {
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("getTmpList faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();
		}

		private String SR_getTmpList(String tmp_name) throws Exception	{

	   		String rtn = null;
	   		String house_code = info.getSession("HOUSE_CODE");
	   		ConnectionContext ctx = getConnectionContext();
	   		
	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("tmp_name", tmp_name);
			if(tmp_name != null && !tmp_name.equals("")) {
				wxp.addVar("tmp_value", true);
	 		}
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());

			rtn = sm.doSelect();
			return rtn;
		}
		
		public SepoaOut getEvabdins1(String evaltemp_num, String sg_refitem, String mode_type)
		{
			String rtn = null;

			try
			{
				rtn = et_getEvabdins1(evaltemp_num, sg_refitem, mode_type);

				setValue(rtn);
				setStatus(1);
			}catch(Exception e){
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("ExpandTree faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();

		}

		private String et_getEvabdins1(String evaltemp_num, String sg_refitem, String mode_type) throws Exception
		{
	   		String rtn = null;
	   		ConnectionContext ctx = getConnectionContext();
			String house_code = info.getSession("HOUSE_CODE");
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("evaltemp_num", evaltemp_num);
			wxp.addVar("sg_refitem", sg_refitem);
			wxp.addVar("house_code", house_code);
			wxp.addVar("mode_type", mode_type);
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	                     
			rtn = sm.doSelect();
			return rtn;
		}
		public SepoaOut setEvabdins1(String[][] SetData, String evalname, String fromdate, String todate, String evaltemp_num,
				String flag)	
		{
			String rtn[] = null;

			try
			{
				rtn = et_setEvabdins1(SetData, evalname, fromdate, todate, evaltemp_num, flag);

				setValue( rtn[0] );
				setStatus( 1 );

				if ( rtn[ 1 ] != null ) {
					setMessage( rtn[ 1 ] );
					setStatus( 0 );
				}

			} catch ( Exception e ) {
				Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
				setStatus( 0 );
			}
			return getSepoaOut();
		}
		
		private String[] et_setEvabdins1(String[][] SetData, String evalname, String fromdate, String todate, String evaltemp_num,
				 String flag) throws Exception 
		{
			String returnString[] = new String[ 2 ];
			ConnectionContext ctx = getConnectionContext();
			
			String user_id 		= info.getSession("ID");
			String house_code 	= info.getSession("HOUSE_CODE");

			int rtnIns = 0;
			SepoaFormater wf = null;
			SepoaSQLManager sm = null;

			try 
			{
				String auto = "N";

				if(SetData[0][1].equals("Y"))//평가 템플릿이 정량평가 항목으로만 구성되어 있으면 자동평가
					auto = "N";
				else
					auto = "Y";

				
	    		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_0");
				wxp.addVar("house_code", house_code);

				sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	  	    	String rtn = sm.doSelect();
	  	    	wf =  new SepoaFormater(rtn);
		    	
	  	    	String max_eval_refitem = "";
		    	if(wf != null && wf.getRowCount() > 0) {
		    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
				}

				//평가테이블 생성
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
				wxp.addVar("house_code", house_code);
				wxp.addVar("max_eval_refitem", max_eval_refitem);
				wxp.addVar("evalname", evalname);
				wxp.addVar("flag", flag);
				wxp.addVar("evaltemp_num", evaltemp_num);
				wxp.addVar("fromdate", fromdate);
				wxp.addVar("todate", todate);
				wxp.addVar("auto", auto);
				wxp.addVar("user_id", user_id);
				wxp.addVar("DOC_TYPE", "");
				wxp.addVar("DOC_NO", "");
				wxp.addVar("DOC_COUNT", "");
				
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
				rtnIns = sm.doInsert();

				String i_sg_refitem = "";
				String i_vendor_code = "";
				String i_value_id = "";

				for ( int i = 0; i < SetData.length; i++ )
				{
					i_sg_refitem = SetData[i][2];
					i_vendor_code = SetData[i][0];
					i_value_id 	= SetData[i][3];

					//평가대상업체 테이블 생성
					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
					wxp.addVar("house_code", house_code);
					wxp.addVar("i_sg_refitem", i_sg_refitem);
					wxp.addVar("i_vendor_code", i_vendor_code);
					wxp.addVar("max_eval_refitem", max_eval_refitem);

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
					rtnIns = sm.doInsert();

					//평가자 생성하기
					SepoaStringTokenizer st = new SepoaStringTokenizer(i_value_id, "#", false);
					int row_cnt = st.countTokens();
					String[][] value_data = new String[row_cnt][2];

					for ( int j = 0 ; j < row_cnt ; j++ ) 
					{
						SepoaStringTokenizer st1 = new SepoaStringTokenizer(st.nextToken().trim(), "@", false);
						int row_cnt1 = st1.countTokens();

						for ( int k = 0 ; k < row_cnt1 ; k++ ) 
						{
							String tmp_data = st1.nextToken().trim();
	
							if(k == 0)
								value_data[j][0] = tmp_data;//부서코드
							else if(k ==3)
								value_data[j][1] = tmp_data;//평가자ID
						}	
					}

					String i_dept = "";
					String i_id = "";

					for ( int ii = 0; ii < row_cnt; ii++ )
					{
						i_dept 	= value_data[ii][0];
						i_id 	= value_data[ii][1];

						//평가대상업체 평가자 테이블 생성
						wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_3");
						wxp.addVar("house_code", house_code);
						wxp.addVar("i_dept", i_dept);
						wxp.addVar("i_id", i_id);
						wxp.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));

						sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
						rtnIns = sm.doInsert();
					}
				}	

				Commit();
			} catch( Exception e ) {
				Rollback();
				returnString[ 1 ] = e.getMessage();
			} finally { }

			return returnString;
		}
		
		public SepoaOut getEvalTempFactorList(String e_template_refitem, String temp_type, String factor_type) 
		{
			String rtn = null;
			try {
				rtn = SR_getEvalTempFactorList( e_template_refitem, temp_type, factor_type );
				setValue(rtn);
				setStatus(1);			
			} catch(Exception e) {
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("getEvalTempFactorList faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();
		}

		private String SR_getEvalTempFactorList( String e_template_refitem, String temp_type, String factor_type ) throws Exception 
		{
			String rtn = null;
			String house_code = info.getSession("HOUSE_CODE");

	   		ConnectionContext ctx = getConnectionContext();
	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("e_template_refitem", e_template_refitem);
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			return rtn;
		}
		
		
		public SepoaOut insertEvaluerScore(String[][] param1, String[][] param2) 
		{
	    	String rtn[] = null;
	    	
	    	try 
	    	{
	    		rtn = SR_insertEvaluerScore(param1, param2);
	    		
	    		setValue( rtn[0] );
	    		setStatus( 1 );
	    		
	    		if ( rtn[ 1 ] != null )
	    		{
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}
	    	} catch ( Exception e ) 
	    	{
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	
	    	return getSepoaOut();
	  	}

		
	  	private String[] SR_insertEvaluerScore(String[][] param1, String[][] param2) throws Exception 
	  	{
	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();
	    	
	    	
	    	String user_id = info.getSession("ID");
	    	
	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;
	    	
			try{
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
			   	String[] type1 = {"S", "S", "S", "S", "S" };
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	  	    	rtnIns = sm.doInsert( param1, type1 );
	  	    	  	    	
	  	    	wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
		    	String[] type2 = { "S", "S", "S", "S" };
	    	    sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    	   	rtnIns = sm.doInsert( param2, type2 );
	  	    	Commit();
	  	    		
	  	    } catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { }  	
	  	    return returnString;
	  	}  
	  	
	  	public SepoaOut checkComplete(String eval_item_refitem, String eval_refitem, String dept1, String dept2) 
	  	{
	    	String rtn[] = null;

	    	try 
	    	{
	    		rtn = SR_checkComplete(eval_item_refitem, eval_refitem, dept1, dept2);
	    		
	    		setValue( rtn[0] );
	    		setStatus( 1 );
	    		setMessage( rtn[ 0 ] );
	    		
	    		if ( rtn[ 1 ] != null )
	    		{
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}
	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}


	  	private String[] SR_checkComplete(String eval_item_refitem, String eval_refitem, String dept1, String dept2) throws Exception 
	  	{
	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();
	    		    	
	    	String user_id = info.getSession("ID");    	
	    	String house_code = info.getSession("HOUSE_CODE");    	
	   
	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

			try
			{
	    		String templete_type = "0";
	    		//일반템플릿[1]/공동템플릿[2] 인지 체크
	    		//현재 일반템플릿만 사용.
	    		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
				wxp.addVar("house_code", house_code);
				wxp.addVar("eval_refitem", eval_refitem);
				
				sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	  	    	String rtn = sm.doSelect();
	  	    	wf =  new SepoaFormater(rtn);
		    		
	  	    	String doc_type = "";
	  	    	String doc_no = "";
	  	    	String doc_count = "";
		    	if(wf != null && wf.getRowCount() > 0) {
		    		templete_type	= wf.getValue(0, 0);
					doc_type 		= wf.getValue(0, 1);
					doc_no 			= wf.getValue(0, 2);
					doc_count 		= wf.getValue(0, 3);
				}
			
				String eval_score = "";
				boolean is_complete = false;
				 
				//평가대상업체(전체 업체가 아니라 해당 업체)에 대한  평가자 전체 평가여부 체크 및 평가점수 계산

				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
				wxp.addVar("house_code", house_code);			
				wxp.addVar("eval_item_refitem", eval_item_refitem);			
				sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	    	    rtn = sm.doSelect();
				wf =  new SepoaFormater(rtn);
				
				is_complete = true;
				if(wf != null && wf.getRowCount() > 0) 
				{
					double score = 0.0;
					int valuer_cnt = 0;
					
					for(valuer_cnt=0; valuer_cnt < wf.getRowCount(); valuer_cnt++) 
					{
	    				String str = wf.getValue(valuer_cnt, 1);	//COMPLETE_MARK[Y/N]
	    				if(str.equals("N")) 
	    				{
	    					is_complete = false;
	    					break;
	    				} else if(str.equals("Y")) {
	    					score = score + Double.parseDouble(wf.getValue(valuer_cnt, 2));
	    				}
	    			}
					double ieval_score = (score/(double)valuer_cnt)*100;
					double deval_score = ieval_score/100.0;

	    	    	eval_score = String.valueOf(deval_score);
	    		}else{   
	    			is_complete = false;
	    		}
				Logger.debug.println(info.getSession( "ID" ),this, "[SR_checkComplete] is_complete="+is_complete);
    			
	    	    //해당 업체에 대한 평가가 완료 되었을 경우 
	  	    	if(is_complete ) 
	  	    	{
		  	    	//해당 업체에 대한 평가 완료 - 점수부여
	  	    		wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_3");
					wxp.addVar("house_code", house_code);
					wxp.addVar("eval_score", eval_score);
					wxp.addVar("eval_refitem", eval_refitem);
					wxp.addVar("eval_item_refitem", eval_item_refitem);
					
			    	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
			    	rtnIns = sm.doUpdate();
		    	    	
			    	//************************************//
			    	//평가 전체가 완료되었는지 체크
					if("IV".equals(doc_type)){	//검수요청 평가일 경우 분기 처리.
						wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_4_1");
					}else{
				    	wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_4");
					}
					
			    	wxp.addVar("house_code", house_code);
					wxp.addVar("eval_refitem", eval_refitem);			
					sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
					
		    	    rtn = sm.doSelect();
		    	    
		    	    wf =  new SepoaFormater(rtn);    	    		
		  	    	boolean isAllComplete = false;
	  	    	
		  	    	if(wf != null && wf.getRowCount() > 0) 
		  	    	{
						int num = Integer.parseInt(wf.getValue(0, 0));
					
						if(num == 0 ) {
							isAllComplete = true;
						}
					}
		  	    	Logger.debug.println(info.getSession( "ID" ),this, "[SR_checkComplete] isAllComplete="+isAllComplete);
	    			
		  	    	//전체 업체에 대한 평가가 완료 되었을 경우 
		    		if(isAllComplete) 
		    		{
		    			//정량평가 처리 -- 선정평가, 종합(정기)평가
		    			 Configuration configuration = new Configuration();                                
		    		     String sEvalTunkey = configuration.get("Sepoa.eval.tunkey"); //도급업체 선정평가 
		    		     String sEvalComp = configuration.get("Sepoa.eval.comp"); //종합평가 
		    			
		    		     int isOk = 0;
		    		     if(templete_type.equals(sEvalTunkey)){
		    		    //	 isOk = setEvalTunkey(ctx, eval_refitem);
		    		     }else if(templete_type.equals(sEvalComp)){
		    		    //	 isOk = setEvalSchedule(ctx, eval_refitem);
		    		     }
							
		    			//평가상태[3:평가완료] 업데이트
		    			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_5");
		    			wxp.addVar("house_code", house_code);
						wxp.addVar("eval_refitem", eval_refitem);				
						 
				    	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
				    	rtnIns = sm.doUpdate();
			    	    	
			    		returnString[0] = "all_complete";
			    	}else{
			    		returnString[0] = null;
			    	}
		    		
		    		//입찰, 견적, 역경매 선정/제안 평가 상태 업데이트
		    		SepoaXmlParser wxp_ =  null;
					if(!"".equals(doc_type)){
						if("BD".equals(doc_type)){
							wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_BD");
						}else if("RA".equals(doc_type)){
							wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_RA");
						}else if("RQ".equals(doc_type)){
							wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_RQ");
						}else if("IV".equals(doc_type)){
							wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_IV");
						}else if("PO".equals(doc_type)){
							wxp_ =  new SepoaXmlParser(this, "SR_checkComplete_PO");
						}
						String strEvalFlag = "";
						if(isAllComplete) {
							strEvalFlag = "C";	//평가완료
						}else{
							strEvalFlag = "P";	//평가진행중
						}
//						try{
						    if(wxp_ != null){  wxp_.addVar("eval_flag", strEvalFlag);			
											   wxp_.addVar("house_code", house_code);			
											   wxp_.addVar("doc_no", doc_no);	
											   wxp_.addVar("doc_count", doc_count);
											   sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_.getQuery() );
										       rtnIns = sm.doUpdate(); }
//						}catch(NullPointerException ne){
//							
//						}
					}
			    	
	  	    		Commit();
	    		}
	    	} catch( Exception e ) {
	    		Logger.err.println(info.getSession( "ID" ),this, "[SR_checkComplete] Exception e =" + e.getMessage());
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { 
	    		Logger.debug.println(info.getSession( "ID" ),this, "[SR_checkComplete] returnString[ 0 ]="+returnString[ 0 ]);
	    		Logger.debug.println(info.getSession( "ID" ),this, "[SR_checkComplete] returnString[ 1 ]="+returnString[ 1 ]);
	    	}  	

	    	return returnString;
	  	} 
	  	
	  	
	  	
	  	public SepoaOut getValuerList1(String eval_item_refitem, String user_id) 
		{
			String rtn = null;

			try 
			{
				rtn = SR_getValuerList1( user_id, eval_item_refitem );
				setValue(rtn);
				setStatus(1);
				
			} catch(Exception e) {
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("getEvaluationVendorList faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();
		}

		private String SR_getValuerList1( String user_id, String eval_item_refitem ) throws Exception 
		{
	   		String rtn = null;
			String house_code = info.getSession("HOUSE_CODE");

	   		ConnectionContext ctx = getConnectionContext();
	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("eval_item_refitem", eval_item_refitem);
			wxp.addVar("house_code", house_code);
			wxp.addVar("user_id", user_id);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			return rtn;
		}

	  	public SepoaOut getEvabdlis7(String eval_refitem)
		{
			String rtn = null;

			try 
			{
				rtn = et_getEvabdlis7(eval_refitem );
				setValue(rtn);
				setStatus(1);
				
			} catch(Exception e) {
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("getEvaluationVendorList faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();
		}

		private String et_getEvabdlis7(String eval_refitem ) throws Exception 
		{
	   		String rtn = null;
			String house_code = info.getSession("HOUSE_CODE");

	   		ConnectionContext ctx = getConnectionContext();
	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("eval_refitem", eval_refitem);
			wxp.addVar("house_code", house_code);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			return rtn;
		}
		
		/*
		 * 선정평가[정량] 처리
		 * 2010.08
		 * icompia swlee
		 */
		private int setEvalTunkey(ConnectionContext ctx, String eval_refitem) throws Exception 
		{
			int isOk = 0;
			SepoaFormater wf = null;
			
			// 도급업체 선정평가[정량] 평가대상업체 정보 조회
			String evalData[][] = getEvalTunkeyVendorInfo(ctx, eval_refitem);
			// 정량평가 정보 조회
			String rtn = et_getEvalQuantityFactorList(ctx, eval_refitem);
			wf =  new SepoaFormater(rtn);    	    		
			String evalFactor = "";
			String evalWeight = "";
  			for(int i=0;i<wf.getRowCount();i++){
				evalFactor = wf.getValue("E_FACTOR_REFITEM", i);
				evalWeight = wf.getValue("WEIGHT", i);
				
				Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] E_FACTOR_REFITEM::"+evalFactor);
				
				if(evalFactor.equals(QUA_TUNKEY_NO_1)){		//원가 절감액
					evalData = getEvalVendorCalCost(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_2)){	//인력 단가 적절성
					evalData = getEvalVendorCalHumanUnitPrice(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_3)){	//R&D 투자비중
					evalData = getEvalVendorCalInvestWeight(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_4)){	//신용 평가 등급
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_5)){	//경영자의 해당 업종 근무
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}
			}
  			
  			isOk = et_setEvalTunkey(ctx, evalData, eval_refitem);
  			Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] et_setEvalTunkey 결과 .. isOk ::"+isOk);
  			//if(isOk < 0){
  			//	throw new Exception("정량평가 정보 등록 중 오류가 발생하였습니다.");
  	    	//}
				
	  		return isOk;
		}
		
		/*
		 * 정량평가 정보 등록(icomvevl, icomvesi)
		 * 2010.08
		 * icompia swlee
		 */
	  	private int et_setEvalTunkey(ConnectionContext ctx, String[][] setData,  String eval_refitem) throws Exception 
	  	{
	    	String house_code = info.getSession("HOUSE_CODE");
	    	
	    	int rtnIns = 0;
	    	SepoaSQLManager sm = null;
	    	
	    	SepoaXmlParser wxp_1 =  new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaXmlParser wxp_2 =  new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			SepoaXmlParser wxp_3 =  new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
	    	
			if(0 < setData.length){
				String[][] tmpData = new String[setData.length][];
				for(int i=0;i<setData.length;i++){
	    			String tempData[] = { 
	    					  house_code
	    					, setData[i][4]		//EVAL_VALUER_ID
	    					, setData[i][1]		//EVAL_ITEM_REFITEM
					  	};
	    			tmpData[i] = tempData;  
	    		}
				
	  	    	int cnt = 0;
	  	    	for(int i=0;i<setData.length;i++){
					//신용평가등급 
					if(!"".equals(setData[i][5]) && !"".equals(setData[i][6]) && !"".equals(setData[i][8]) ){
						 cnt++;
					}
					//경영자의 해당 업종 근무년수
					if(!"".equals(setData[i][9]) && !"".equals(setData[i][10]) && !"".equals(setData[i][12]) ){
						 cnt++;
					}
					//원가 절감액
					if(!"".equals(setData[i][13]) && !"".equals(setData[i][14]) && !"".equals(setData[i][16]) ){
						 cnt++;
					}
					//인력단가 적절성
					if(!"".equals(setData[i][17]) && !"".equals(setData[i][18]) && !"".equals(setData[i][20]) ){
						 cnt++;
					}
					//R&D 투자비중 
					if(!"".equals(setData[i][21]) && !"".equals(setData[i][22]) && !"".equals(setData[i][24]) ){
						 cnt++;
					}
	    		}
				
	  	    	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalTunkey]========INSERT INTO ICOMVESI .. COUNT ::" + cnt);
	
	  	    	String[][] tmpData2 = new String[cnt][];
	  	    	cnt = 0;
				for(int i=0;i<setData.length;i++){
					//신용평가등급 
					if(!"".equals(setData[i][5]) && !"".equals(setData[i][6]) && !"".equals(setData[i][8]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][5]		//E_SELECTED_FACTOR
	  	    					, setData[i][6]		//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][8]) * (Integer.valueOf(setData[i][7]) / SCORE_FIVE))		//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
	  	    			tmpData2[cnt] = tempData;
	  	    			cnt++;
					}
					//경영자의 해당 업종 근무년수
					if(!"".equals(setData[i][9]) && !"".equals(setData[i][10]) && !"".equals(setData[i][12]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][9]		//E_SELECTED_FACTOR
	  	    					, setData[i][10]	//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][12]) * (Integer.valueOf(setData[i][11]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)	
						  	};
	  	    			tmpData2[cnt] = tempData;  
	  	    			cnt++;
					}
					//원가 절감액
					if(!"".equals(setData[i][13]) && !"".equals(setData[i][14]) && !"".equals(setData[i][16]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][13]	//E_SELECTED_FACTOR
	  	    					, setData[i][14]	//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][16]) * (Integer.valueOf(setData[i][15]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
	  	    			tmpData2[cnt] = tempData; 
	  	    			cnt++;
					}
					//인력단가 적절성
					if(!"".equals(setData[i][17]) && !"".equals(setData[i][18]) && !"".equals(setData[i][20]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][17]	//E_SELECTED_FACTOR
	  	    					, setData[i][18]	//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][20]) * (Integer.valueOf(setData[i][19]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
	  	    			tmpData2[cnt] = tempData;
	  	    			cnt++;
					}
					//R&D 투자비중 
					if(!"".equals(setData[i][21]) && !"".equals(setData[i][22]) && !"".equals(setData[i][24]) ){
						String tempData[] = { 
		    					  house_code
		    					, setData[i][21]	//E_SELECTED_FACTOR
		    					, setData[i][22]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][4]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][24]) * (Integer.valueOf(setData[i][23]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
		    			tmpData2[cnt] = tempData; 
						cnt++;
					}
	    		}
				
				//Insert ICOMVEVL
			   	String[] type1 = {"S", "S", "S" };
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
	  	    	rtnIns = sm.doInsert( tmpData, type1 );
	  	    	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalTunkey]========Insert ICOMVEVL.. RESULT::" + rtnIns);
		  	    	 
	  	    	//Insert ICOMVESI
	  	    	String[] type2 = { "S", "S", "S", "S", "S", "S", "S" };
	    	    sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
	    	   	rtnIns = sm.doInsert( tmpData2, type2 );
	    	   	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalTunkey]========Insert ICOMVESI.. RESULT::" + rtnIns);
	    	   	
	    	   	//정량평가 점수 조회
	    	   	String rtnScore = et_getEvalQuantityScore(eval_refitem, setData[0][4]);
	    	   	
	    	   	SepoaFormater wfScore =  new SepoaFormater(rtnScore);    	    		
				String[][] setScoreData = new String[wfScore.getRowCount()][];
	  	        
	  	    	for(int i=0;i<wfScore.getRowCount();i++){
	  	    		String tmpScoreData[] = { 
	  	    					  wfScore.getValue(i, 0)		//EVAL_ITEM_REFITEM
	  	    					, wfScore.getValue(i, 1)		//SCORE
	  	    	
				  	};
	  	    		setScoreData[i] = tmpScoreData;  
	  	    	}
	  	    	
	  	    	//정량 평가 점수 업데이트
	  	    	if(wfScore.getRowCount() > 0){
	  	    		for(int i=0;i<setScoreData.length;i++){
	  	    			wxp_3.addVar("house_code", house_code);
	  	    			wxp_3.addVar("eval_score", setScoreData[i][1]);
	  	    			wxp_3.addVar("eval_item_refitem", setScoreData[i][0]);
					
	  	    			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
	  	    			rtnIns = sm.doUpdate();
	  	    		}
	  	    	}
	  	    	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalTunkey]========UPDATE ICOMVESD .. EVAL_SCORE.. RESULT::" + rtnIns);
			}
	  	    return rtnIns;
	  	}  
	  	
	  	private String et_getEvalQuantityScore(String eval_refitem, String eval_valuer_id) throws Exception 
		{
			String rtn = "";
			
			String house_code = info.getSession("HOUSE_CODE");

	   		ConnectionContext ctx = getConnectionContext();
	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("eval_refitem", eval_refitem);
			wxp.addVar("eval_valuer_id", eval_valuer_id);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			
			return rtn;
		}
		
		/*
		 * 정량평가 정보 조회
		 */
		private String et_getEvalQuantityFactorList(ConnectionContext ctx, String eval_refitem) throws Exception 
		{
			String rtn = "";
			
			String house_code = info.getSession("HOUSE_CODE");

	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("eval_refitem", eval_refitem);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			
			return rtn;
		}
		
		/*
		 * 선정평가[정량] 조회
		 * 2010.08
		 * icompia swlee
		 */
		private String[][] getEvalTunkeyVendorInfo(ConnectionContext ctx, String eval_refitem) throws Exception 
		{
			String rtn[][] = null;
			SepoaFormater wf = null;

			String rtnString = et_getEvalVendorInfo(ctx, eval_refitem );

			wf =  new SepoaFormater(rtnString);    	    		
			String[][] setData = new String[wf.getRowCount()][];
  	        
  	    	if(wf != null && wf.getRowCount() > 0) 
  	    	{
  	    		for(int i=0;i<wf.getRowCount();i++){
  	    			String tmpData[] = { 
  	    					  wf.getValue(i, 0)		//VENDOR_CODE
  	    					, wf.getValue(i, 1)		//EVAL_ITEM_REFITEM
  	    					, wf.getValue(i, 2)		//신용 평가 등급  [CREDIT_RATING]
  	    					, wf.getValue(i, 3)		//경영자의 해당 업종 근무년수 [IRS_NO]
  	    					, "SYSTEM"				//eval_valuer_id[정량평가자]
  	    					, ""					//신용 평가 등급				 E_FACTOR_REFITEM
  	    					, ""					//신용 평가 등급 				선택일련번호 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//신용 평가 등급 				가중치 [weight]
  	    					, ""					//신용 평가 등급 점수
  	    					, ""					//경영자의 해당 업종 근무년수	 E_FACTOR_REFITEM
  	    					
  	    					, ""					//경영자의 해당 업종 근무년수 	선택일련번호 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//경영자의 해당 업종 근무년수	WEIGHT
  	    					, ""					//경영자의 해당 업종 근무년수 점수
  	    					, ""					//원가 절감액 				E_FACTOR_REFITEM
  	    					, ""					//원가 절감액 				선택일련번호 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//원가 절감액 				WEIGHT
  	    					, ""					//원가 절감액 점수
  	    					, ""					//인력단가 적절성 				E_FACTOR_REFITEM
  	    					, ""					//인력단가 적절성			 	선택일련번호 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//인력단가 적절성 				WEIGHT
  	    					
  	    					, ""					//인력단가 적절성 점수
  	    					, ""					//R&D 투자비중 				E_FACTOR_REFITEM
  	    					, ""					//R&D 투자비중			 	선택일련번호 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//R&D 투자비중				WEIGHT
  	    					, ""					//R&D 투자비중  점수
				  	};
  	    			setData[i] = tmpData;  
  	    		}
			}
  	    	rtn = setData;
  	    		
			return rtn;
		}
		
		private String et_getEvalVendorInfo(ConnectionContext ctx, String eval_refitem) throws Exception 
		{
			String rtn = null;
			String house_code = info.getSession("HOUSE_CODE");

	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("eval_refitem", eval_refitem);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			return rtn;
		}
		
		/*
		 * 평가 FACTOR 세부 일련번호 조회
		 * 2010.08
		 */
		private String et_getEvalFactorItemInfo(ConnectionContext ctx, String evalFactor, String item_score) throws Exception 
		{
			String rtn = null;
			String house_code = info.getSession("HOUSE_CODE");

	   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("e_factor_refitem", evalFactor);
			wxp.addVar("item_score", item_score);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			
			SepoaFormater wf =  new SepoaFormater(rtn);  
			rtn = "";
			if(wf != null && wf.getRowCount() > 0) 
  	    	{
				rtn = wf.getValue(0, 0);
			}
			return rtn;
		}
		
		/*
		 * 선정평가[정량] - [신용 평가 등급] , [경영자의 해당 업종 근무년수] 계산 결과
		 * 2010.08
		 * icompia swlee
		 */
		private String[][] getEvalVendorCal(ConnectionContext ctx, String[][] setData, String evalFactor, String evalWeight) throws Exception 
		{
			String rtn[][] = null;
				
    		for(int i=0;i<setData.length;i++){
    			if(evalFactor.equals(QUA_TUNKEY_NO_4)){			//선정평가-신용 평가 등급
    				setData[i][5] = evalFactor;
    				setData[i][8] = String.valueOf(getCreditScore(setData[i][2], "", evalFactor));						//평가점수
    				setData[i][6] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][8] );			//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값 
    				setData[i][7] = evalWeight; 
    			}else if(evalFactor.equals(QUA_TUNKEY_NO_5)){	//선정평가-경영자의 해당 업종 근무
					setData[i][9] = evalFactor;
					int chkYear = 0;
					setData[i][12] = String.valueOf(getOwnerWorkScore(ctx, setData[i][3], chkYear));				//평가점수
					setData[i][10] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][12] );		//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
					setData[i][11] = evalWeight;
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_1)){	//종합평가-신용 평가 등급
    				setData[i][5] = evalFactor;
    				setData[i][8] = String.valueOf(getCreditScore(setData[i][4], "", evalFactor));						//평가점수
    				setData[i][6] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][10] );			//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값 
    				setData[i][7] = evalWeight; 
    			}else if(evalFactor.equals(QUA_SCHEDULE_NO_3)){	//종합평가-현금 흐름 등급
    				setData[i][22] = evalFactor;
    				setData[i][25] = String.valueOf(getCreditScore("", setData[i][23], evalFactor));						//평가점수
    				setData[i][23] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][27] );			//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값 
    				setData[i][24] = evalWeight; 
    			}else if(evalFactor.equals(QUA_SCHEDULE_NO_2)){	//종합평가-경영자의 해당 업종 근무
					setData[i][11] = evalFactor;
					int chkYear = 1; 	//종합평가일 경우 직전년도 기준.
					setData[i][14] = String.valueOf(getOwnerWorkScore(ctx, setData[i][5], chkYear));				//평가점수
					setData[i][12] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][14] );		//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
					setData[i][13] = evalWeight;
				}
    			
    		}
    		rtn = setData;
	  	    		
			return rtn;
		}
		
		/*
		 * 원가 절감액 계산 
		 */
		private String[][] getEvalVendorCalCost(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
		throws Exception 
		{
			String rtn[][] = null;
			Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCost] [원가 절감액] 계산 START.");
			
			String rtnString = getReduceCost(ctx, eval_refitem);
			SepoaFormater wf =  new SepoaFormater(rtnString);   
			String vendorCode = "";
			String vendorScore = "";
			if(wf != null && wf.getRowCount() > 0) 
  	    	{
				for(int i=0;i<wf.getRowCount();i++){
					vendorCode = wf.getValue(i, 0);
  	    			vendorScore = wf.getValue(i, 1);
  	    			for(int j=0;j<setData.length;j++){
  	    				if(vendorCode.equals(setData[j][0])){
  	    					setData[j][13] = evalFactor;
  	    					setData[j][16] = vendorScore;										//평가점수
  	    					setData[j][14] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
  	    					setData[j][15] = evalWeight;
  	  	    			}	
  	    			}
				}
  	    	}else{
  	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCost] [원가 절감액] 계산할 데이터 없슴.");
  	    	}
			
  	    	rtn = setData;
  	    		
			return rtn;
		}
		
		/*
		 * 인력 단가 적절성 계산 
		 */
		private String[][] getEvalVendorCalHumanUnitPrice(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
		throws Exception  
		{
			String rtn[][] = null;
			Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [인력 단가 적절성] 계산 START.");
			
			String rtnString = getHumanUnitPriceAppropriacy(ctx, eval_refitem);
			SepoaFormater wf =  new SepoaFormater(rtnString); 
			String vendorCode = "";
			String vendorScore = "";
			if(wf != null && wf.getRowCount() > 0) 
  	    	{
				for(int i=0;i<wf.getRowCount();i++){
					vendorCode = wf.getValue(i, 0);
  	    			vendorScore = wf.getValue(i, 1);
  	    			for(int j=0;j<setData.length;j++){
  	    				if(vendorCode.equals(setData[j][0])){
  	    					setData[j][17] = evalFactor;
  	    					setData[j][20] = vendorScore;										//평가점수
  	    					setData[j][18] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
  	    					setData[j][19] = evalWeight;
  	  	    			}	
  	    			}
				}
  	    	}else{
  	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [인력 단가 적절성] 계산할 데이터 없슴.");
	  	    }
  	    		 
  	    	rtn = setData;
	  	    		
			return rtn;
		}
		

		/*
		 * R&D 투자비중 계산 
		 */
		private String[][] getEvalVendorCalInvestWeight(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
		throws Exception  
		{
			String rtn[][] = null;
			Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalInvestWeight] [R&D 투자비중] 계산 START.");
			
			String rtnString = getVendorInvestWeight(ctx, eval_refitem);
			SepoaFormater wf =  new SepoaFormater(rtnString); 
			String vendorCode = "";
			String vendorScore = "";
			if(wf != null && wf.getRowCount() > 0) 
  	    	{
				for(int i=0;i<wf.getRowCount();i++){
					vendorCode = wf.getValue(i, 0);
  	    			vendorScore = wf.getValue(i, 1);
  	    			for(int j=0;j<setData.length;j++){
  	    				if(vendorCode.equals(setData[j][0])){
  	    					setData[j][21] = evalFactor;
  	    					setData[j][24] = vendorScore;										//평가점수
  	    					setData[j][22] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
  	    					setData[j][23] = evalWeight;
  	  	    			}	
  	    			}
				}
  	    	}else{
  	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalInvestWeight] [R&D 투자비중] 계산할 데이터 없슴.");
	  	    }
  	    		 
  	    	rtn = setData;
	  	    		
			return rtn;
		}
		
		/*
		 * 선정평가[정량] - 신용 평가 등급 점수 린턴
		 * 2010.08
		 * icompia swlee
		 */
		private int getCreditScore(String compareCreditClass, String compareCashClass, String evalFactor) throws Exception {
			int iCashScore = 0;
			int iCreditScore = 0;
			int iRtn = 0;
			
			String[][] credit_Class = {	// 신용 평가 등급 
				{"NG1", "NG2"},									/* 0점 */
				{"CC", "C", "D"},								/* 1점 */
				{"B+", "B0", "B-", "CCC+", "CCC0", "CCC-"},		/* 2점 */
				{"BBB+", "BBB0", "BBB-", "BB+", "BB0", "BB-"},	/* 3점 */
				{"A+", "A0", "A-"},								/* 4점 */
				{"AAA", "AA+", "AA0", "AA-"}					/* 5점 */
			};	//나이스디엔비
			
			String[][] cash_Class = {	// 현금흐름 등급
					{""},										/* 0점 */
					{"C(CFR5)", "D(CFR6)", "E(NR1)", "E(NR2)"},	/* 1점 */ 
					{"C+(CFR4)"},								/* 2점 */
					{"B(CFR3)"}, 								/* 3점 */
					{"B+(CFR2)"},								/* 4점 */
					{"A(CFR1)"}									/* 5점 */
			};	//나이스디엔비
			
			//신용 평가 등급 
			if(!"".equals(compareCreditClass)){
				for(int k=0; k<credit_Class.length;k++){
					iCreditScore = k;
					for (int i = 0; i < credit_Class[k].length; i++) {
						if (compareCreditClass.equals(credit_Class[k][i])) {
							break;
						}
					}
				}
				iRtn = iCreditScore;
				Logger.debug.println( info.getSession("ID"), this, "[getCreditScore]신용평가등급점수::" +iRtn);
			}	 
			
			//현금흐름 등급
			if(!"".equals(compareCashClass)){
				for(int k=0; k<cash_Class.length;k++){
					iCashScore = k;
					for (int i = 0; i < cash_Class[k].length; i++) {
						if (compareCashClass.equals(cash_Class[k][i]) ) {
							break;
						}
					}
				}
				iRtn = iCashScore;
				Logger.debug.println( info.getSession("ID"), this, "[getCreditScore]현금흐름등급점수::" +iRtn);
			}	 
			
			Logger.debug.println( info.getSession("ID"), this, "[getCreditScore].......iRtn::" +iRtn);
			return iRtn;
		}

	/*
	 * 선정평가[정량] - 공급업체 경영자 근무년수  점수 린턴
	 * 2010.08
	 * icompia swlee
	 */
  	private int getOwnerWorkScore(ConnectionContext ctx, String irs_no, int chkYear) throws Exception {
  		int iOwnerWorkScore = 0;
  		String sWork_Y = "-";
  		String sOwnerWork_YY = "";
  		String sOwnerWork_MM = "";
  		int iOwnerWork_YY = 0;
  		String rtn = et_getOwnerWork(ctx, irs_no);
  		SepoaFormater wf =  new SepoaFormater(rtn);
    	int cnt = wf.getRowCount();
    	
    	if(cnt==0){
    		iOwnerWorkScore = 0;
    	}else{
    		sWork_Y = wf.getValue(0, 0);
    		Logger.debug.println(info.getSession( "ID" ),this, "[getOwnerWorkScore] [근속 정보] Work_Y::"+sWork_Y);
  			SepoaStringTokenizer st = new SepoaStringTokenizer(sWork_Y, "-", false);
		
  			int i = 0;
	  		while(st.hasMoreTokens()){
	  			if(i==0){
	  				sOwnerWork_YY = st.nextToken();
	  				Logger.debug.println(info.getSession( "ID" ),this, "[getOwnerWorkScore] 근속년수::"+sOwnerWork_YY);
	  			}else{
	  				sOwnerWork_MM = st.nextToken().trim();
	  				Logger.debug.println(info.getSession( "ID" ),this, "[getOwnerWorkScore] 근속월::"+sOwnerWork_MM);
	  			}
	  			i++;
	  		}
	  		iOwnerWork_YY = Integer.parseInt(sOwnerWork_YY);
	  		iOwnerWork_YY = iOwnerWork_YY - chkYear;
	  		
	  		if(10 <= iOwnerWork_YY-chkYear){
	  			iOwnerWorkScore = SCORE_FIVE;
	  		}else if(10 > iOwnerWork_YY && 7 <= iOwnerWork_YY){
	  			iOwnerWorkScore = SCORE_FOUR;
	  		}else if(7 > iOwnerWork_YY && 5 <= iOwnerWork_YY){
	  			iOwnerWorkScore = SCORE_THREE;
	  		}else if(5 > iOwnerWork_YY && 3 <= iOwnerWork_YY){
	  			iOwnerWorkScore = SCORE_TWO;
	  		}else if(3 > iOwnerWork_YY){
	  			iOwnerWorkScore = SCORE_ONE;
	  		}
    	}
  		 
  		return iOwnerWorkScore;
  	}
  	
  	/*
  	 *  선정평가[정량] - 공급업체 경영자 근무년수 조회
  	 */
  	private String et_getOwnerWork(ConnectionContext ctx, String irs_no ) throws Exception 
	{
   		String rtn = null;

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("irs_no", irs_no);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	
  	/*
  	 * 선정평가[정량] - 공급업체 원가 절감액 조회
  	 */
  	private String getReduceCost(ConnectionContext ctx, String eval_refitem ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	

  	/*
  	 *  선정평가[정량] - 공급업체 인력 단가 적절성 조회
  	 */
  	private String getHumanUnitPriceAppropriacy(ConnectionContext ctx, String eval_refitem ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	

  	/*
  	 *  선정평가[정량] - R&D 투자비중 조회
  	 */
  	private String getVendorInvestWeight(ConnectionContext ctx, String eval_refitem ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	


	/*
	 * 종합[정기]평가 -정량 처리
	 * 2010.08
	 * icompia swlee
	 */
	private int setEvalSchedule(ConnectionContext ctx, String eval_refitem) throws Exception 
	{
		int isOk = 0;
		SepoaFormater wf = null;
		
		// 종합평가[정량] 평가대상업체 정보 조회
		String evalData[][] = getEvalScheduleVendorInfo(ctx, eval_refitem);
		// 정량평가 정보 조회
		String rtn = et_getEvalQuantityFactorList(ctx, eval_refitem);
		wf =  new SepoaFormater(rtn);    	    		
		String evalFactor = "";
		String evalWeight = "";
			for(int i=0;i<wf.getRowCount();i++){
				evalFactor = wf.getValue("E_FACTOR_REFITEM", i);
				evalWeight = wf.getValue("WEIGHT", i);
				
				Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] E_FACTOR_REFITEM::"+evalFactor);
				
				if(evalFactor.equals(QUA_SCHEDULE_NO_1)){	//신용 평가 등급
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_2)){	//경영자의 해당 업종 근무
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_3)){	//현금흐름등급
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_4)){	//원가 절감률 
					evalData = getEvalVendorCalCostRate(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_5)){	//인력단가 적절성
					evalData = getEvalVendorCalHumanUnitPriceYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_6)){	//투입공수의 적절성
					evalData = getEvalVendorCalWorkDayAppropriacy(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_7)){	//재거래의사
					evalData = getEvalVendorCalReBusinessYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_8)){	//사용자 품질 만족도
					evalData = getEvalVendorCalQualitySatisfactionYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_9)){	//결과물 품질
					evalData = getEvalVendorCalProductQualityYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_10)){	//투입인력의 팀워크/리더십
					evalData = getEvalVendorCalTeamWorkYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_11)){	//업무 성실성
					evalData = getEvalVendorCalWorkSincerityYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_12)){	//우수 인력 비율
					evalData = getEvalVendorCalExceHumanRateYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_13)){	//기술력
					evalData = getEvalVendorCalTechSkillsYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_14)){	//산업 이해도
					evalData = getEvalVendorCalIndustryCompYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_15)){	//투입인력의 자격인증
					evalData = getEvalVendorCalHumanQualCertYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_16)){	//프로젝트 수행이력
					evalData = getEvalVendorCalProjectPerfHistoryYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_17)){	//업무 협조도
					evalData = getEvalVendorCalBusinessCoopYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_18)){	//기술지원 상태
					evalData = getEvalVendorCalTechSupportYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_19)){	//입찰 요청 대비 응찰율
					evalData = getEvalVendorCalBidRateYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_20)){	//투입 인력 정확도
					evalData = getEvalVendorCalHumanAccuracyYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_21)){	//정규직 비율
					evalData = getEvalVendorCalRegularEmpRateYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}
				
			}
			
			//등록 처리 - 작업 진행 중
			isOk = et_setEvalSchedule(ctx, evalData, eval_refitem);
			Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] et_setEvalTunkey 결과 .. isOk ::"+isOk);
			//if(isOk < 0){
			//	throw new Exception("정량평가 정보 등록 중 오류가 발생하였습니다.");
	    	//}
			
  		return isOk;
	}
	

	/*
	 * 종합평가[정량] 조회
	 * 2010.08
	 * icompia swlee
	 */
	private String[][] getEvalScheduleVendorInfo(ConnectionContext ctx, String eval_refitem) throws Exception 
	{
		String rtn[][] = null;
		SepoaFormater wf = null;

		String rtnString = et_getEvalScheduleVendorInfo(ctx, eval_refitem );

		wf =  new SepoaFormater(rtnString);    	    		
		String[][] setData = new String[wf.getRowCount()][];
	        
	    	if(wf != null && wf.getRowCount() > 0) 
	    	{
	    		for(int i=0;i<wf.getRowCount();i++){
	    			String tmpData[] = { 
	    					  wf.getValue(i, 0)		//VENDOR_CODE
	    					, wf.getValue(i, 1)		//EVAL_ITEM_REFITEM
	    					, wf.getValue(i, 2)		//종합평가 평가대상 시작일자
	    					, wf.getValue(i, 3)		//종합평가 평가대상 종료일자
	    					, wf.getValue(i, 4)		//신용 평가 등급  [CREDIT_RATING]
	    					, wf.getValue(i, 5)		//경영자의 해당 업종 근무년수 [WORK_Y]
	    					, "SYSTEM"				//eval_valuer_id[정량평가자]
	    					, ""					//신용 평가 등급				 	E_FACTOR_REFITEM
	    					, ""					//신용 평가 등급 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//신용 평가 등급 					가중치 [weight]
	    					//10
	    					, ""					//신용 평가 등급 점수
	    					, ""					//경영자의 해당 업종 근무년수	 	E_FACTOR_REFITEM
	    					, ""					//경영자의 해당 업종 근무년수 		선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//경영자의 해당 업종 근무년수		WEIGHT
	    					, ""					//경영자의 해당 업종 근무년수 점수
	    					, ""					//원가 절감률 					E_FACTOR_REFITEM
	    					, ""					//원가 절감률 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//원가 절감률 					WEIGHT
	    					, ""					//원가 절감률 점수
	    					, ""					//인력단가 적절성 					E_FACTOR_REFITEM
	    					// 20
	    					, ""					//인력단가 적절성			 		선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//인력단가 적절성 					WEIGHT
	    					, ""					//인력단가 적절성 점수
	    					, wf.getValue(i, 6)		//현금흐름등급
	    					, ""					//현금흐름등급				 	E_FACTOR_REFITEM
	    					, ""					//현금흐름등급 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//현금흐름등급 					가중치 [weight]
	    					, ""					//현금흐름등급점수
	    					, ""					//투입공수의 적절성 				E_FACTOR_REFITEM
	    					, ""					//투입공수의 적절성			 	선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					// 30
	    					, ""					//투입공수의 적절성 				WEIGHT
	    					, ""					//투입공수의 적절성 점수
	    					, ""					//재거래의사  					E_FACTOR_REFITEM
	    					, ""					//재거래의사 						선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//재거래의사 						WEIGHT
	    					, ""					//재거래의사 점수
	    					, ""					//사용자품질만족도 				E_FACTOR_REFITEM
	    					, ""					//사용자품질만족도			 	선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//사용자품질만족도 				WEIGHT
	    					, ""					//사용자품질만족도 점수
	    					//40
	    					, ""					//결과물 품질 					E_FACTOR_REFITEM
	    					, ""					//결과물 품질			 			선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//결과물 품질 					WEIGHT
	    					, ""					//결과물 품질 점수
	    					, ""					//투입인력의 팀워크/리더십 		E_FACTOR_REFITEM
	    					, ""					//투입인력의 팀워크/리더십		선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//투입인력의 팀워크/리더십 		WEIGHT
	    					, ""					//투입인력의 팀워크/리더십 점수
	    					, ""					//업무 성실성 					E_FACTOR_REFITEM
	    					, ""					//업무 성실성			 			선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					//50
	    					, ""					//업무 성실성 					WEIGHT
	    					, ""					//업무 성실성 점수
	    					, ""					//우수 인력 비율  					E_FACTOR_REFITEM
	    					, ""					//우수 인력 비율 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//우수 인력 비율 					WEIGHT
	    					, ""					//우수 인력 비율 점수
	    					, ""					//기술력 	  					E_FACTOR_REFITEM
	    					, ""					//기술력 						선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//기술력 						WEIGHT
	    					, ""					//기술력 점수
	    					//60
	    					, ""					//산업 이해도  					E_FACTOR_REFITEM
	    					, ""					//산업 이해도 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//산업 이해도 					WEIGHT
	    					, ""					//산업 이해도 점수
	    					, ""					//투입인력의 자격인증 				E_FACTOR_REFITEM
	    					, ""					//투입인력의 자격인증 				선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//투입인력의 자격인증 				WEIGHT
	    					, ""					//투입인력의 자격인증 점수
	    					, ""					//프로젝트 수행이력  				E_FACTOR_REFITEM
	    					, ""					//프로젝트 수행이력 				선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					//70
	    					, ""					//프로젝트 수행이력 				WEIGHT
	    					, ""					//프로젝트 수행이력 점수
	    					, ""					//업무 협조도  					E_FACTOR_REFITEM
	    					, ""					//업무 협조도 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//업무 협조도 					WEIGHT
	    					, ""					//업무 협조도 점수
	    					, ""					//기술지원 상태  					E_FACTOR_REFITEM
	    					, ""					//기술지원 상태 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//기술지원 상태 					WEIGHT
	    					, ""					//기술지원 상태 점수
	    					//80
	    					, ""					//입찰요청대비응찰율  				E_FACTOR_REFITEM
	    					, ""					//입찰요청대비응찰율 				선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//입찰요청대비응찰율 				WEIGHT
	    					, ""					//입찰요청대비응찰율 점수
	    					, ""					//투입인력 정확도  				E_FACTOR_REFITEM
	    					, ""					//투입인력 정확도 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//투입인력 정확도 					WEIGHT
	    					, ""					//투입인력 정확도 점수
	    					, ""					//정규직 비율  					E_FACTOR_REFITEM
	    					, ""					//정규직 비율 					선택일련번호 [E_FACTOR_ITEM_REFITEM]
	    					//90
	    					, ""					//정규직 비율 					WEIGHT
	    					, ""					//정규직 비율 점수

			  	};
	    			setData[i] = tmpData;  
	    		}
		}
	    	rtn = setData;
	    		
		return rtn;
	}
	
/*
 * 종합평가 대상업체 조회 
 */
	private String et_getEvalScheduleVendorInfo(ConnectionContext ctx, String eval_refitem) throws Exception 
	{
		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}


	/*
	 * 정량평가 정보 등록(icomvevl, icomvesi)
	 * 2010.08
	 * icompia swlee
	 */
  	private int et_setEvalSchedule(ConnectionContext ctx, String[][] setData,  String eval_refitem) throws Exception 
  	{
    	String house_code = info.getSession("HOUSE_CODE");
    	
    	int rtnIns = 0;
    	SepoaSQLManager sm = null;
    	
    	SepoaXmlParser wxp_1 =  new SepoaXmlParser(this, "et_setEvalTunkey_1");
		SepoaXmlParser wxp_2 =  new SepoaXmlParser(this, "et_setEvalTunkey_2");
		SepoaXmlParser wxp_3 =  new SepoaXmlParser(this, "et_setEvalTunkey_3");
    	
		 Logger.debug.println(info.getSession("ID"), this, "[et_setEvalSchedule]========setData.length ::" + setData.length);
	    	
		if(0 < setData.length){
			String[][] tmpData = new String[setData.length][];
			for(int i=0;i<setData.length;i++){
				String tempData[] = { 
						  house_code
						, setData[i][4]		//EVAL_VALUER_ID
						, setData[i][1]		//EVAL_ITEM_REFITEM
				  	};
				tmpData[i] = tempData;  
			}
			
		    	int cnt = 0;
		    	for(int i=0;i<setData.length;i++){
				//신용평가등급 
				if(!"".equals(setData[i][7]) && !"".equals(setData[i][8]) && !"".equals(setData[i][10]) ){
					 cnt++;
				}
				//경영자의 해당 업종 근무년수
				if(!"".equals(setData[i][11]) && !"".equals(setData[i][12]) && !"".equals(setData[i][14]) ){
					 cnt++;
				}
				//원가 절감률
				if(!"".equals(setData[i][15]) && !"".equals(setData[i][16]) && !"".equals(setData[i][18]) ){
					 cnt++;
				}
				//인력단가 적절성
				if(!"".equals(setData[i][19]) && !"".equals(setData[i][20]) && !"".equals(setData[i][22]) ){
					 cnt++;
				}
				//현금 흐름 등급
				if(!"".equals(setData[i][24]) && !"".equals(setData[i][25]) && !"".equals(setData[i][27]) ){
					 cnt++;
				}
				//투입공수의 적절성
				if(!"".equals(setData[i][28]) && !"".equals(setData[i][29]) && !"".equals(setData[i][31]) ){
					 cnt++;
				}
				//재거래 의사
				if(!"".equals(setData[i][32]) && !"".equals(setData[i][33]) && !"".equals(setData[i][35]) ){
					 cnt++;
				}
				//사용자 품질 만족도
				if(!"".equals(setData[i][36]) && !"".equals(setData[i][37]) && !"".equals(setData[i][39]) ){
					 cnt++;
				}
				//결과물 품질 
				if(!"".equals(setData[i][40]) && !"".equals(setData[i][41]) && !"".equals(setData[i][43]) ){
					 cnt++;
				}
				//투입인력의 팀워크/리더십 
				if(!"".equals(setData[i][44]) && !"".equals(setData[i][45]) && !"".equals(setData[i][47]) ){
					 cnt++;
				}
				//업무 성실성
				if(!"".equals(setData[i][48]) && !"".equals(setData[i][49]) && !"".equals(setData[i][51]) ){
					 cnt++;
				}
				
				//우수 인력 비율
				if(!"".equals(setData[i][52]) && !"".equals(setData[i][53]) && !"".equals(setData[i][55]) ){
					 cnt++;
				}
				//기술력
				if(!"".equals(setData[i][56]) && !"".equals(setData[i][57]) && !"".equals(setData[i][59]) ){
					 cnt++;
				}
				//산업 이해도
				if(!"".equals(setData[i][60]) && !"".equals(setData[i][61]) && !"".equals(setData[i][63]) ){
					 cnt++;
				}
				//투입인력의 자격인증
				if(!"".equals(setData[i][64]) && !"".equals(setData[i][65]) && !"".equals(setData[i][67]) ){
					 cnt++;
				}
				//프로젝트 수행이력
				if(!"".equals(setData[i][68]) && !"".equals(setData[i][69]) && !"".equals(setData[i][71]) ){
					 cnt++;
				}
				//업무 협조도
				if(!"".equals(setData[i][72]) && !"".equals(setData[i][73]) && !"".equals(setData[i][75]) ){
					 cnt++;
				}
				//기술지원 상태
				if(!"".equals(setData[i][76]) && !"".equals(setData[i][77]) && !"".equals(setData[i][79]) ){
					 cnt++;
				}
				//입찰요청대비응찰율
				if(!"".equals(setData[i][80]) && !"".equals(setData[i][81]) && !"".equals(setData[i][83]) ){
					 cnt++;
				}
				//투입인력 정확도
				if(!"".equals(setData[i][84]) && !"".equals(setData[i][85]) && !"".equals(setData[i][87]) ){
					 cnt++;
				}
				//정규직 비율
				if(!"".equals(setData[i][88]) && !"".equals(setData[i][89]) && !"".equals(setData[i][91]) ){
					 cnt++;
				}
			
			}
			
		    Logger.debug.println(info.getSession("ID"), this, "[et_setEvalSchedule]========INSERT INTO ICOMVESI .. COUNT ::" + cnt);
	    	String[][] tmpData2 = new String[cnt][];
	    	cnt = 0;
			for(int i=0;i<setData.length;i++){
				//신용평가등급 
				if(!"".equals(setData[i][7]) && !"".equals(setData[i][8]) && !"".equals(setData[i][10]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][7]		//E_SELECTED_FACTOR
		    					, setData[i][8]		//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][10]) * (Integer.valueOf(setData[i][9]) / SCORE_FIVE))		//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//경영자의 해당 업종 근무년수
				if(!"".equals(setData[i][11]) && !"".equals(setData[i][12]) && !"".equals(setData[i][14]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][11]		//E_SELECTED_FACTOR
		    					, setData[i][12]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][14]) * (Integer.valueOf(setData[i][13]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)	
					  	};
		    		tmpData2[cnt] = tempData;  
		    		cnt++;
				}
				//원가 절감률
				if(!"".equals(setData[i][15]) && !"".equals(setData[i][16]) && !"".equals(setData[i][18]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][15]	//E_SELECTED_FACTOR
		    					, setData[i][16]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][18]) * (Integer.valueOf(setData[i][17]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData; 
		    		cnt++;
				}
				//인력단가 적절성
				if(!"".equals(setData[i][19]) && !"".equals(setData[i][20]) && !"".equals(setData[i][22]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][19]	//E_SELECTED_FACTOR
		    					, setData[i][20]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][22]) * (Integer.valueOf(setData[i][21]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//현금 흐름 등급
				if(!"".equals(setData[i][24]) && !"".equals(setData[i][25]) && !"".equals(setData[i][27]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][24]	//E_SELECTED_FACTOR
		    					, setData[i][25]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][27]) * (Integer.valueOf(setData[i][26]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//투입공수의 적절성
				if(!"".equals(setData[i][28]) && !"".equals(setData[i][29]) && !"".equals(setData[i][31]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][28]	//E_SELECTED_FACTOR
		    					, setData[i][29]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][31]) * (Integer.valueOf(setData[i][30]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//재거래 의사
				if(!"".equals(setData[i][32]) && !"".equals(setData[i][33]) && !"".equals(setData[i][35]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][32]	//E_SELECTED_FACTOR
		    					, setData[i][33]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][35]) * (Integer.valueOf(setData[i][34]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//사용자 품질 만족도
				if(!"".equals(setData[i][36]) && !"".equals(setData[i][37]) && !"".equals(setData[i][39]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][36]	//E_SELECTED_FACTOR
		    					, setData[i][37]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][39]) * (Integer.valueOf(setData[i][38]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//결과물 품질 
				if(!"".equals(setData[i][40]) && !"".equals(setData[i][41]) && !"".equals(setData[i][43]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][40]	//E_SELECTED_FACTOR
		    					, setData[i][41]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][43]) * (Integer.valueOf(setData[i][42]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//투입인력의 팀워크/리더십 
				if(!"".equals(setData[i][44]) && !"".equals(setData[i][45]) && !"".equals(setData[i][47]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][44]	//E_SELECTED_FACTOR
			  					, setData[i][45]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][47]) * (Integer.valueOf(setData[i][46]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//업무 성실성
				if(!"".equals(setData[i][48]) && !"".equals(setData[i][49]) && !"".equals(setData[i][51]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][48]	//E_SELECTED_FACTOR
			  					, setData[i][49]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][51]) * (Integer.valueOf(setData[i][50]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				
	
				//우수 인력 비율
				if(!"".equals(setData[i][52]) && !"".equals(setData[i][53]) && !"".equals(setData[i][55]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][52]	//E_SELECTED_FACTOR
			  					, setData[i][53]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][55]) * (Integer.valueOf(setData[i][54]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//기술력
				if(!"".equals(setData[i][56]) && !"".equals(setData[i][57]) && !"".equals(setData[i][59]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][56]	//E_SELECTED_FACTOR
			  					, setData[i][57]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][59]) * (Integer.valueOf(setData[i][58]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//산업 이해도
				if(!"".equals(setData[i][60]) && !"".equals(setData[i][61]) && !"".equals(setData[i][63]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][60]	//E_SELECTED_FACTOR
			  					, setData[i][61]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][63]) * (Integer.valueOf(setData[i][62]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//투입인력의 자격인증
				if(!"".equals(setData[i][64]) && !"".equals(setData[i][65]) && !"".equals(setData[i][67]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][64]	//E_SELECTED_FACTOR
			  					, setData[i][65]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][67]) * (Integer.valueOf(setData[i][66]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//프로젝트 수행이력
				if(!"".equals(setData[i][68]) && !"".equals(setData[i][69]) && !"".equals(setData[i][71]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][68]	//E_SELECTED_FACTOR
			  					, setData[i][69]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][71]) * (Integer.valueOf(setData[i][70]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				
				//업무 협조도
				if(!"".equals(setData[i][72]) && !"".equals(setData[i][73]) && !"".equals(setData[i][75]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][72]	//E_SELECTED_FACTOR
			  					, setData[i][73]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][75]) * (Integer.valueOf(setData[i][74]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//기술지원 상태
				if(!"".equals(setData[i][76]) && !"".equals(setData[i][77]) && !"".equals(setData[i][79]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][76]	//E_SELECTED_FACTOR
			  					, setData[i][77]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][79]) * (Integer.valueOf(setData[i][78]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//입찰요청대비응찰율
				if(!"".equals(setData[i][80]) && !"".equals(setData[i][81]) && !"".equals(setData[i][83]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][80]	//E_SELECTED_FACTOR
			  					, setData[i][81]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][83]) * (Integer.valueOf(setData[i][82]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//투입인력 정확도
				if(!"".equals(setData[i][84]) && !"".equals(setData[i][85]) && !"".equals(setData[i][87]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][84]	//E_SELECTED_FACTOR
			  					, setData[i][85]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][87]) * (Integer.valueOf(setData[i][86]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//정규직 비율
				if(!"".equals(setData[i][88]) && !"".equals(setData[i][89]) && !"".equals(setData[i][91]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][88]	//E_SELECTED_FACTOR
			  					, setData[i][89]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][91]) * (Integer.valueOf(setData[i][90]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: 선택항목 점수 * (가중치/평가항목 최고점수)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
			}
			
			
			//Insert ICOMVEVL
		   	String[] type1 = {"S", "S", "S" };
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
		    	rtnIns = sm.doInsert( tmpData, type1 );
		    	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalSchedule]========Insert ICOMVEVL.. RESULT::" + rtnIns);
	  	    	 
		    	//Insert ICOMVESI
		    	String[] type2 = { "S", "S", "S", "S", "S", "S", "S" };
		    sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
		   	rtnIns = sm.doInsert( tmpData2, type2 );
		   	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalSchedule]========Insert ICOMVESI.. RESULT::" + rtnIns);
		   	
		   	//정량평가 점수 조회
		   	String rtnScore = et_getEvalQuantityScore(eval_refitem, setData[0][4]);
		   	
		   	SepoaFormater wfScore =  new SepoaFormater(rtnScore);    	    		
			String[][] setScoreData = new String[wfScore.getRowCount()][];
		        
		    	for(int i=0;i<wfScore.getRowCount();i++){
		    		String tmpScoreData[] = { 
		    					  wfScore.getValue(i, 0)		//EVAL_ITEM_REFITEM
		    					, wfScore.getValue(i, 1)		//SCORE
		    	
			  	};
		    		setScoreData[i] = tmpScoreData;  
		    	}
		    	
		    	//정량 평가 점수 업데이트
		    	if(wfScore.getRowCount() > 0){
		    		for(int i=0;i<setScoreData.length;i++){
		    			wxp_3.addVar("house_code", house_code);
		    			wxp_3.addVar("eval_score", setScoreData[i][1]);
		    			wxp_3.addVar("eval_item_refitem", setScoreData[i][0]);
				
		    			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
		    			rtnIns = sm.doUpdate();
		    		}
		    	}
		    	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalSchedule]========UPDATE ICOMVESD .. EVAL_SCORE.. RESULT::" + rtnIns);
		}   	
  	    return rtnIns;
  	}  
  	

	
	/*
	 * 종합평가[정량]-원가 절감률 계산 
	 */
	private String[][] getEvalVendorCalCostRate(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception 
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCostRate] [원가 절감률] 계산 START.");
		
		String rtnString = getReduceCostRate(ctx, eval_refitem, setData[0][2], setData[0][3]);
		SepoaFormater wf =  new SepoaFormater(rtnString);   
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
	    			vendorScore = wf.getValue(i, 1);
	    			for(int j=0;j<setData.length;j++){
	    				if(vendorCode.equals(setData[j][0])){
	    					setData[j][15] = evalFactor;
	    					setData[j][18] = vendorScore;										//평가점수
	    					setData[j][16] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
	    					setData[j][17] = evalWeight;
	  	    			}	
	    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCostRate] [원가 절감률] 계산할 데이터 없슴.");
	    	}
		
	    	rtn = setData;
	    		
		return rtn;
	}
  	

  	/*
  	 * 종합평가[정량]-원가 절감률 조회
  	 */
  	private String getReduceCostRate(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	
  	
	/*
	 * 종합평가[정량]-투입공수의 적절성 계산 
	 */
	private String[][] getEvalVendorCalWorkDayAppropriacy(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkDayAppropriacy] [투입공수의 적절성] 계산 START.");
		
		String rtnString = getHumanWorkDayAppropriacy(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_11);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
	    			vendorScore = wf.getValue(i, 1);
	    			for(int j=0;j<setData.length;j++){
	    				if(vendorCode.equals(setData[j][0])){
	    					setData[j][28] = evalFactor;
	    					setData[j][31] = vendorScore;										//평가점수
	    					setData[j][29] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
	    					setData[j][30] = evalWeight;
	  	    			}	
	    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkDayAppropriacy] [투입공수의 적절성] 계산할 데이터 없슴.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  종합평가[정량] - 투입공수의 적절성 조회
  	 */
  	private String getHumanWorkDayAppropriacy(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date, String e_selected_factor ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
   		wxp.addVar("e_selected_factor", e_selected_factor);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	

	/*
	 * 종합평가[정량] - 인력 단가 적절성 계산 
	 */
	private String[][] getEvalVendorCalHumanUnitPriceYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [인력 단가 적절성] 계산 START.");
		
		String rtnString = getHumanUnitPriceAppropriacyYear(ctx, eval_refitem, setData[0][2], setData[0][3]);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][19] = evalFactor;
    					setData[j][22] = vendorScore;										//평가점수
    					setData[j][20] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][21] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [인력 단가 적절성] 계산할 데이터 없슴.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}
	


  	/*
  	 *  종합평가[정량] - 공급업체 인력 단가 적절성 조회
  	 */
  	private String getHumanUnitPriceAppropriacyYear(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	

	/*
	 * 종합평가[정량] - 재거래 의사 계산 
	 */
	private String[][] getEvalVendorCalReBusinessYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalReBusinessYear] [재거래 의사]  계산 START.");
		
		String rtnString = getCalCommon01Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_19);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][32] = evalFactor;
    					setData[j][35] = vendorScore;										//평가점수
    					setData[j][33] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][34] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalReBusinessYear] [재거래 의사 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}
	

  	/*
  	 *  종합평가[정량] -   조회
  	 */
  	private String getCalCommon01Year(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date, String e_selected_factor ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		//wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("e_selected_factor", e_selected_factor);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	

	/*
	 * 종합평가[정량] - 사용자 품질 만족도 계산 
	 */
	private String[][] getEvalVendorCalQualitySatisfactionYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalQualitySatisfactionYear] [사용자 품질 만족도] 계산 START.");
		
		String rtnString = getCalCommon02Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_15);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][36] = evalFactor;
    					setData[j][39] = vendorScore;										//평가점수
    					setData[j][37] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][38] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalQualitySatisfactionYear] [사용자 품질 만족도]  계산할 데이터 없슴.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}
	

  	/*
  	 *  종합평가[정량] -  조회
  	 */
  	private String getCalCommon02Year(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date, String e_selected_factor ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		//wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);wxp.addVar("e_selected_factor", e_selected_factor);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}

	/*
	 * 종합평가[정량] - 결과물 품질 계산 
	 */
	private String[][] getEvalVendorCalProductQualityYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProductQualityYear] [결과물 품질] 계산 START.");
		
		String rtnString = getCalCommon01Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_7);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][40] = evalFactor;
    					setData[j][43] = vendorScore;										//평가점수
    					setData[j][41] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][42] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProductQualityYear] [결과물 품질]  계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	
 

	/*
	 * 종합평가[정량] - 투입인력의 팀워크/리더십 계산 
	 */
	private String[][] getEvalVendorCalTeamWorkYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTeamWorkYear] [투입인력의 팀워크/리더십] 계산 START.");
		
		String rtnString = getCalCommon02Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_1);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][44] = evalFactor;
    					setData[j][47] = vendorScore;										//평가점수
    					setData[j][45] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][46] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTeamWorkYear] [투입인력의 팀워크/리더십 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	
 
	/*
	 * 종합평가[정량] - 업무 성실성 계산 
	 */
	private String[][] getEvalVendorCalWorkSincerityYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkSincerityYear] [업무 성실성] 계산 START.");
		
		String rtnString = getCalCommon02Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_2);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][48] = evalFactor;
    					setData[j][51] = vendorScore;										//평가점수
    					setData[j][49] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][50] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkSincerityYear] [업무 성실성 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

	/*
	 * 종합평가[정량] - 우수 인력 비율 계산 
	 */
	private String[][] getEvalVendorCalExceHumanRateYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalExceHumanRateYear] [우수 인력 비율] 계산 START.");
		
		String rtnString = getCalExceHumanRateYear(ctx, eval_refitem, setData[0][2], setData[0][3]);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][52] = evalFactor;
    					setData[j][55] = vendorScore;										//평가점수
    					setData[j][53] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][54] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalExceHumanRateYear] [우수 인력 비율 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


  	/*
  	 *  종합평가[정량] - 우수 인력 비율  조회
  	 */
  	private String getCalExceHumanRateYear(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		//wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	

	/*
	 * 종합평가[정량] - 기술력 계산 
	 */
	private String[][] getEvalVendorCalTechSkillsYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSkillsYear] [기술력] 계산 START.");
		
		String rtnString = getCalCommon03Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_3);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][56] = evalFactor;
    					setData[j][59] = vendorScore;										//평가점수
    					setData[j][57] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][58] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSkillsYear] [기술력 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


	/*
	 * 종합평가[정량] - 산업 이해도 계산 
	 */
	private String[][] getEvalVendorCalIndustryCompYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalIndustryCompYear] [산업 이해도] 계산 START.");
		
		String rtnString = getCalCommon03Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_5);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][60] = evalFactor;
    					setData[j][63] = vendorScore;										//평가점수
    					setData[j][61] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][62] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalIndustryCompYear] [산업 이해도 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


	/*
	 * 종합평가[정량] - 투입인력의 자격인증 계산 
	 */
	private String[][] getEvalVendorCalHumanQualCertYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanQualCertYear] [투입인력의 자격인증] 계산 START.");
		
		String rtnString = getCalCommon03Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_6);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][64] = evalFactor;
    					setData[j][67] = vendorScore;										//평가점수
    					setData[j][65] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][66] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanQualCertYear] [투입인력의 자격인증 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


	/*
	 * 종합평가[정량] - 프로젝트 수행이력 계산 
	 */
	private String[][] getEvalVendorCalProjectPerfHistoryYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProjectPerfHistoryYear] [프로젝트 수행이력] 계산 START.");
		
		String rtnString = getCalCommon03Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_4);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][68] = evalFactor;
    					setData[j][71] = vendorScore;										//평가점수
    					setData[j][69] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][70] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProjectPerfHistoryYear] [프로젝트 수행이력 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  종합평가[정량] - 기술력, 산업이해도, 투입인력의 자격인증, 프로젝트수행이력  조회
  	 */
  	private String getCalCommon03Year(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date, String e_selected_factor ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("e_selected_factor", e_selected_factor);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	

	/*
	 * 종합평가[정량] - 업무협조도 계산 
	 */
	private String[][] getEvalVendorCalBusinessCoopYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBusinessCoopYear] [업무협조도] 계산 START.");
		
		String rtnString = getCalCommon04Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_9);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][72] = evalFactor;
    					setData[j][75] = vendorScore;										//평가점수
    					setData[j][73] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][74] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBusinessCoopYear] [업무협조도 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	

	/*
	 * 종합평가[정량] - 기술지원상태 계산 
	 */
	private String[][] getEvalVendorCalTechSupportYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSupportYear] [기술지원상태] 계산 START.");
		
		String rtnString = getCalCommon04Year(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_10);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][76] = evalFactor;
    					setData[j][79] = vendorScore;										//평가점수
    					setData[j][77] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][78] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSupportYear] [기술지원상태 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	
	
  	/*
  	 *  종합평가[정량] - 업무협조도, 기술지원상태  조회
  	 */
  	private String getCalCommon04Year(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date, String e_selected_factor ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("e_selected_factor", e_selected_factor);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	
  	

	/*
	 * 종합평가[정량] - 투입인력 정확도 계산 
	 */
	private String[][] getEvalVendorCalHumanAccuracyYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanAccuracyYear] [투입인력 정확도] 계산 START.");
		
		String rtnString = getCalHumanAccuracyYear(ctx, eval_refitem, setData[0][2], setData[0][3], QUA_FACTOR_NO_14);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][84] = evalFactor;
    					setData[j][87] = vendorScore;										//평가점수
    					setData[j][85] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][86] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanAccuracyYear] [투입인력 정확도 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  종합평가[정량] - 투입인력 정확도  조회
  	 */
  	private String getCalHumanAccuracyYear(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date, String e_selected_factor ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("e_selected_factor", e_selected_factor);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}


	/*
	 * 종합평가[정량] - 입찰요청 대비 응찰율 계산 
	 */
	private String[][] getEvalVendorCalBidRateYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBidRateYear] [입찰요청 대비 응찰율] 계산 START.");
		
		String rtnString = getCalBidRateYear(ctx, eval_refitem, setData[0][2], setData[0][3]);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][80] = evalFactor;
    					setData[j][83] = vendorScore;										//평가점수
    					setData[j][81] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][82] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBidRateYear] [입찰요청 대비 응찰율 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  종합평가[정량] - 입찰요청 대비 응찰율 조회
  	 */
  	private String getCalBidRateYear(ConnectionContext ctx, String eval_refitem, String eval_from_date, String eval_to_date ) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_from_date", eval_from_date);
		wxp.addVar("eval_to_date", eval_to_date);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}

  	
	/*
	 * 종합평가[정량] -  정규직 비율 계산 
	 */
	private String[][] getEvalVendorCalRegularEmpRateYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalRegularEmpRateYear] [정규직 비율] 계산 START.");
		
		String rtnString = getCalRegularEmpRateYear(ctx, eval_refitem);
		SepoaFormater wf =  new SepoaFormater(rtnString); 
		String vendorCode = "";
		String vendorScore = "";
		if(wf != null && wf.getRowCount() > 0) 
	    	{
			for(int i=0;i<wf.getRowCount();i++){
				vendorCode = wf.getValue(i, 0);
    			vendorScore = wf.getValue(i, 1);
    			for(int j=0;j<setData.length;j++){
    				if(vendorCode.equals(setData[j][0])){
    					setData[j][88] = evalFactor;
    					setData[j][91] = vendorScore;										//평가점수
    					setData[j][89] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//평가점수에 해당하는 icomvefd 테이블의 e_factor_item_refitem 값
    					setData[j][90] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalRegularEmpRateYear] [정규직 비율 ] 계산할 데이터 없슴.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  종합평가[정량] - 정규직 비율  조회
  	 */
  	private String getCalRegularEmpRateYear(ConnectionContext ctx, String eval_refitem) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
  	
  	
  	/*
  	 * 정량평가 결과 평가항목 조회 
  	 * 2010.09.03
  	 */
	public SepoaOut getQntEvalSelectedFactor(String e_template_refitem, String eval_refitem, String vendor_code) 
	{
		String rtn = null;

		try 
		{
			String user_id = info.getSession("ID");
			
			rtn = et_getQntEvalSelectedFactor( e_template_refitem, eval_refitem, vendor_code );
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getQntEvalSelectedFactor faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getQntEvalSelectedFactor(String e_template_refitem, String eval_refitem, String vendor_code) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		ConnectionContext ctx = getConnectionContext();
				
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("e_template_refitem", e_template_refitem);
		wxp.addVar("eval_refitem", eval_refitem);
		wxp.addVar("vendor_code", vendor_code);
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
	
	public SepoaOut getEvaVendorList(String eval_refitem) 
	{
		String rtn = null;

		try 
		{
			
			rtn = et_getEvaVendorList( eval_refitem);
			setValue(rtn);
			setStatus(1);
			
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("getQntEvalSelectedFactor faild");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getEvaVendorList(String eval_refitem) throws Exception 
	{
   		String rtn = null;
		String house_code = info.getSession("HOUSE_CODE");

   		ConnectionContext ctx = getConnectionContext();
				
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("eval_refitem", eval_refitem);

		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
		return rtn;
	}
}