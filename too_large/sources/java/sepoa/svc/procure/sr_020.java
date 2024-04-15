package sepoa.svc.procure;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

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


public class SR_020 extends SepoaService{
	
  	String language 	= "";
  	String serviceId 	= "p0080";
	Message msg = new Message(info, "FW");

	//�뺣웾�됯� �뺣낫
	int SCORE_FIVE 		= 5;
	int SCORE_FOUR 		= 4;
	int SCORE_THREE 	= 3;
	int SCORE_TWO 		= 2;
	int SCORE_ONE 		= 1;
	//�낆껜 �좎젙 �됯� - �뺣웾�됯���ぉ 肄붾뱶
	String QUA_TUNKEY_NO_1  = "25";		//- �먭� �덇컧��
	String QUA_TUNKEY_NO_2  = "27";		//- �몃젰 �④� �곸젅��
	String QUA_TUNKEY_NO_3  = "37";		//- R&D �ъ옄鍮꾩쨷
	String QUA_TUNKEY_NO_4  = "50";		//- �좎슜 �됯� �깃툒
	String QUA_TUNKEY_NO_5  = "53";		//- 寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т
	//醫낇빀�됯� - �뺣웾�됯���ぉ 肄붾뱶
	String QUA_SCHEDULE_NO_1 = "85";	//�좎슜 �됯� �깃툒
	String QUA_SCHEDULE_NO_2 = "89";	//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�곗닔 
	String QUA_SCHEDULE_NO_3 = "113";	//�꾧툑�먮쫫�깃툒 
	String QUA_SCHEDULE_NO_4 = "55";	//�먭� �덇컧瑜�
	String QUA_SCHEDULE_NO_5 = "57";	//�몃젰�④� �곸젅��
	String QUA_SCHEDULE_NO_6 = "56";	//�ъ엯怨듭닔���곸젅��
	String QUA_SCHEDULE_NO_7 = "58";	//�ш굅�섏쓽��
	String QUA_SCHEDULE_NO_8 = "59";	//�ъ슜���덉쭏 留뚯”��
	String QUA_SCHEDULE_NO_9 = "60";	//寃곌낵臾��덉쭏
	String QUA_SCHEDULE_NO_10 = "61";	//�ъ엯�몃젰����썙��由щ뜑��
	String QUA_SCHEDULE_NO_11 = "62";	//�낅Т �깆떎��
	String QUA_SCHEDULE_NO_12 = "74";	//�곗닔 �몃젰 鍮꾩쑉
	String QUA_SCHEDULE_NO_13 = "75";	//湲곗닠��
	String QUA_SCHEDULE_NO_14 = "76";	//�곗뾽 �댄빐��
	String QUA_SCHEDULE_NO_15 = "77";	//�ъ엯�몃젰���먭꺽 �몄쬆
	String QUA_SCHEDULE_NO_16 = "78";	//�꾨줈�앺듃 �섑뻾�대젰
	String QUA_SCHEDULE_NO_17 = "81";	//�낅Т �묒“��
	String QUA_SCHEDULE_NO_18 = "82";	//湲곗닠吏�썝 �곹깭
	String QUA_SCHEDULE_NO_19 = "83";	//�낆같 �붿껌 ��퉬 �묒같��
	String QUA_SCHEDULE_NO_20 = "84";	//�ъ엯 �몃젰 �뺥솗��
	String QUA_SCHEDULE_NO_21 = "87";	//�뺢퇋吏�鍮꾩쑉
	
	//醫낇빀�됯�  - �뺣웾�됯���긽 �됯���ぉ 肄붾뱶
	String QUA_FACTOR_NO_1 = "1";			//�ъ엯�몃젰����썙��由щ뜑��
	String QUA_FACTOR_NO_2 = "2";			//�낅Т �깆떎��
	String QUA_FACTOR_NO_3 = "3";			//湲곗닠��
	String QUA_FACTOR_NO_4 = "4";			//�꾨줈�앺듃 �섑뻾�대젰
	String QUA_FACTOR_NO_5 = "5";			//�곗뾽 �댄빐��
	String QUA_FACTOR_NO_6 = "6";			//�ъ엯�몃젰���먭꺽�몄쬆
	String QUA_FACTOR_NO_7 = "7";			//寃곌낵臾��덉쭏
	String QUA_FACTOR_NO_9 = "9";			//�낅Т�묒“��
	String QUA_FACTOR_NO_10 = "10";			//湲곗닠吏�썝�곹깭
	String QUA_FACTOR_NO_11 = "11";			//�ъ엯 怨듭닔���곸젅��
	String QUA_FACTOR_NO_14 = "14";			//�ъ엯�몃젰 �뺥솗��
	String QUA_FACTOR_NO_15 = "15";			//�ъ슜���덉쭏 留뚯”��
	String QUA_FACTOR_NO_19 = "19";			//�ш굅���섏궗
	
	
  	public SR_020( String opt, SepoaInfo sinfo ) throws SepoaServiceException{
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
  	 * �됯��꾨즺 
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
				
			//�됯���긽 �낆껜 媛�졇�ㅺ린
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
			wxp.addVar("eval_refitem",eval_refitem );
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();
			wf =  new SepoaFormater(rtn);
			int cnt = wf.getRowCount();
			String[] eval_item_refitem = new String[cnt];
			
			for(int i=0; i < cnt; i++) 
			{
				eval_item_refitem[i] = wf.getValue(i, 0);//(0,0)�먯꽌 �섏젙
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
				 
    	    	//�대떦 �낆껜����븳 �됯� �꾨즺 - �먯닔遺�뿬
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_4");
				wxp.addVar("eval_score",eval_score );
				wxp.addVar("eval_refitem",eval_refitem );
				wxp.addVar("eval_item_refitem",eval_item_refitem[j] );
		    	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
		    	rtnIns = sm.doUpdate();
				 
			} // for
				
			//�뺣웾�됯� 泥섎━ -- �좎젙�됯�, 醫낇빀(�뺢린)�됯�
			Configuration configuration = new Configuration();                                
		    String sEvalTunkey = configuration.get("Sepoa.eval.tunkey"); //�꾧툒�낆껜 �좎젙�됯� 
		    String sEvalComp = configuration.get("Sepoa.eval.comp"); //醫낇빀�됯� 
			
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
			

    		//�낆같, 寃ъ쟻, ��꼍留��좎젙/�쒖븞 �됯� �곹깭 �낅뜲�댄듃
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
					String strEvalFlag = "C";	//�됯��꾨즺
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
  	 // �뺣웾�됯� 怨꾩궛 蹂�꼍�쇰줈 �명빐 �ъ슜 �덊븿.
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
  	    	
    	//1. �됯���ぉ 援ы븯湲�
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
  	    	
  	    	//2.�뺣웾 �됯� ��ぉ���덉쑝硫� �뺣웾�됯� 怨꾩궛
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
				int cnt = wf.getRowCount();			//�뺣웾�됯���踰ㅻ뜑��
				int factor_cnt = factor_num.length;	//�좏깮���⑺꽣��媛�닔
				int score_cnt = 0;  				//�꾩껜 猷⑦봽����븳 移댁슫�� =cnt * factor_cnt )
				int current_cnt = 0;				//珥앹젏 怨꾩궛���ъ슜�섎뒗 移댁슫��
				
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
  	    			
  	    			//�좏깮����ぉ���됯�媛믨뎄�섍린...	
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
  	    			//珥앹젏 �낅젰

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

				//�됯���긽�낆껜 �됯����뚯씠釉���젣
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1");
				wxp.addVar("i_eval_refitem", i_eval_refitem);
				 
	    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert();

				//�됯���긽�낆껜 �뚯씠釉���젣
	    		wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
				wxp.addVar("i_eval_refitem", i_eval_refitem);
				 
	    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert();

				//�됯��뚯씠釉���젣
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
	
	public SepoaOut getEvaluatorList(Map<String, Object> data)
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		Map<String, String> header = MapUtils.getMap(data, "headerData");

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String rtn = null;

		try
		{
			SepoaXmlParser wxp =  new SepoaXmlParser(this,"getEvaluatorList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp);
			rtn = sm.doSelect(header);
			setValue(rtn);
			setStatus(1);
			setFlag(true);
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
	
	public SepoaOut getEvalTempSelectedFactor(String e_template_refitem, String temp_type, String factor_type, String eval_valuer_refitem, String qnt_flag ) 
	{
		String rtn = null;
		try {
			rtn = SR_getEvalTempSelectedFactor( e_template_refitem, temp_type, factor_type, eval_valuer_refitem, qnt_flag );
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

	private String SR_getEvalTempSelectedFactor( String e_template_refitem, String temp_type, String factor_type, String eval_valuer_refitem, String qnt_flag ) throws Exception {
		String house_code 	= info.getSession("HOUSE_CODE");
    	
   		String rtn = null;
   		ConnectionContext ctx = getConnectionContext();
   		
   		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("e_template_refitem", e_template_refitem);
		wxp.addVar("eval_valuer_refitem", eval_valuer_refitem);
		wxp.addVar("qnt_flag", qnt_flag);				
		
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
		rtn = sm.doSelect();
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
	 * �쒖븞�됯���
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
	 * 媛쒕컻���됯� 議고쉶 
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
			//�됯��뚯씠釉��섏젙
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

				//�됯���긽�낆껜 �뚯씠釉���젣
				if(i == 0)
				{
					//�됯���긽�낆껜 �됯����뚯씠釉���젣  (�꾩튂蹂�꼍 2012-9-20)
					
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
				//�됯���긽�낆껜 �뚯씠釉��앹꽦
				
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_3");
				wxp.addVar("house_code", house_code);
				wxp.addVar("i_sg_refitem", i_sg_refitem);
				wxp.addVar("i_vendor_code", i_vendor_code);
				wxp.addVar("eval_refitem", eval_refitem);
    	    	
	    		sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
	    		rtnIns = sm.doInsert();
				
				//�됯����앹꽦�섍린
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
							value_data[j][0] = tmp_data;//遺�꽌肄붾뱶
						else if(k ==3)
							value_data[j][1] = tmp_data;//�됯��륤D
					}
				}

				String i_dept = "";
				String i_id = "";
				
	        	for ( int ii = 0; ii < row_cnt; ii++ )
	        	{
					i_dept 	= value_data[ii][0];
					i_id 	= value_data[ii][1];

					//�됯���긽�낆껜 �됯����뚯씠釉��앹꽦
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

				if(SetData[0][1].equals("Y"))//�됯� �쒗뵆由우씠 �뺣웾�됯� ��ぉ�쇰줈留�援ъ꽦�섏뼱 �덉쑝硫��먮룞�됯�
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

				//�됯��뚯씠釉��앹꽦
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

					//�됯���긽�낆껜 �뚯씠釉��앹꽦
					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2");
					wxp.addVar("house_code", house_code);
					wxp.addVar("i_sg_refitem", i_sg_refitem);
					wxp.addVar("i_vendor_code", i_vendor_code);
					wxp.addVar("max_eval_refitem", max_eval_refitem);

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
					rtnIns = sm.doInsert();

					//�됯����앹꽦�섍린
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
								value_data[j][0] = tmp_data;//遺�꽌肄붾뱶
							else if(k ==3)
								value_data[j][1] = tmp_data;//�됯��륤D
						}	
					}

					String i_dept = "";
					String i_id = "";

					for ( int ii = 0; ii < row_cnt; ii++ )
					{
						i_dept 	= value_data[ii][0];
						i_id 	= value_data[ii][1];

						//�됯���긽�낆껜 �됯����뚯씠釉��앹꽦
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
	    		//�쇰컲�쒗뵆由�1]/怨듬룞�쒗뵆由�2] �몄� 泥댄겕
	    		//�꾩옱 �쇰컲�쒗뵆由용쭔 �ъ슜.
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
				 
				//�됯���긽�낆껜(�꾩껜 �낆껜媛��꾨땲���대떦 �낆껜)����븳  �됯����꾩껜 �됯��щ� 泥댄겕 諛��됯��먯닔 怨꾩궛

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
    			
	    	    //�대떦 �낆껜����븳 �됯�媛��꾨즺 �섏뿀��寃쎌슦 
	  	    	if(is_complete ) 
	  	    	{
		  	    	//�대떦 �낆껜����븳 �됯� �꾨즺 - �먯닔遺�뿬
	  	    		wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_3");
					wxp.addVar("house_code", house_code);
					wxp.addVar("eval_score", eval_score);
					wxp.addVar("eval_refitem", eval_refitem);
					wxp.addVar("eval_item_refitem", eval_item_refitem);
					
			    	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
			    	rtnIns = sm.doUpdate();
		    	    	
			    	//************************************//
			    	//�됯� �꾩껜媛��꾨즺�섏뿀�붿� 泥댄겕
					if("IV".equals(doc_type)){	//寃�닔�붿껌 �됯���寃쎌슦 遺꾧린 泥섎━.
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
	    			
		  	    	//�꾩껜 �낆껜����븳 �됯�媛��꾨즺 �섏뿀��寃쎌슦 
		    		if(isAllComplete) 
		    		{
		    			//�뺣웾�됯� 泥섎━ -- �좎젙�됯�, 醫낇빀(�뺢린)�됯�
		    			 Configuration configuration = new Configuration();                                
		    		     String sEvalTunkey = configuration.get("Sepoa.eval.tunkey"); //�꾧툒�낆껜 �좎젙�됯� 
		    		     String sEvalComp = configuration.get("Sepoa.eval.comp"); //醫낇빀�됯� 
		    			
		    		     int isOk = 0;
		    		     if(templete_type.equals(sEvalTunkey)){
		    		    //	 isOk = setEvalTunkey(ctx, eval_refitem);
		    		     }else if(templete_type.equals(sEvalComp)){
		    		    //	 isOk = setEvalSchedule(ctx, eval_refitem);
		    		     }
							
		    			//�됯��곹깭[3:�됯��꾨즺] �낅뜲�댄듃
		    			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_5");
		    			wxp.addVar("house_code", house_code);
						wxp.addVar("eval_refitem", eval_refitem);				
						 
				    	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
				    	rtnIns = sm.doUpdate();
			    	    	
			    		returnString[0] = "all_complete";
			    	}else{
			    		returnString[0] = null;
			    	}
		    		
		    		//�낆같, 寃ъ쟻, ��꼍留��좎젙/�쒖븞 �됯� �곹깭 �낅뜲�댄듃
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
							strEvalFlag = "C";	//�됯��꾨즺
						}else{
							strEvalFlag = "P";	//�됯�吏꾪뻾以�
						}
//						try{
							if(wxp_ != null){ wxp_.addVar("eval_flag", strEvalFlag);			
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
		 * �좎젙�됯�[�뺣웾] 泥섎━
		 * 2010.08
		 * icompia swlee
		 */
		private int setEvalTunkey(ConnectionContext ctx, String eval_refitem) throws Exception 
		{
			int isOk = 0;
			SepoaFormater wf = null;
			
			// �꾧툒�낆껜 �좎젙�됯�[�뺣웾] �됯���긽�낆껜 �뺣낫 議고쉶
			String evalData[][] = getEvalTunkeyVendorInfo(ctx, eval_refitem);
			// �뺣웾�됯� �뺣낫 議고쉶
			String rtn = et_getEvalQuantityFactorList(ctx, eval_refitem);
			wf =  new SepoaFormater(rtn);    	    		
			String evalFactor = "";
			String evalWeight = "";
  			for(int i=0;i<wf.getRowCount();i++){
				evalFactor = wf.getValue("E_FACTOR_REFITEM", i);
				evalWeight = wf.getValue("WEIGHT", i);
				
				Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] E_FACTOR_REFITEM::"+evalFactor);
				
				if(evalFactor.equals(QUA_TUNKEY_NO_1)){		//�먭� �덇컧��
					evalData = getEvalVendorCalCost(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_2)){	//�몃젰 �④� �곸젅��
					evalData = getEvalVendorCalHumanUnitPrice(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_3)){	//R&D �ъ옄鍮꾩쨷
					evalData = getEvalVendorCalInvestWeight(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_4)){	//�좎슜 �됯� �깃툒
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_TUNKEY_NO_5)){	//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}
			}
  			
  			isOk = et_setEvalTunkey(ctx, evalData, eval_refitem);
  			Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] et_setEvalTunkey 寃곌낵 .. isOk ::"+isOk);
  			//if(isOk < 0){
  			//	throw new Exception("�뺣웾�됯� �뺣낫 �깅줉 以��ㅻ쪟媛�諛쒖깮�섏��듬땲��");
  	    	//}
				
	  		return isOk;
		}
		
		/*
		 * �뺣웾�됯� �뺣낫 �깅줉(icomvevl, icomvesi)
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
					//�좎슜�됯��깃툒 
					if(!"".equals(setData[i][5]) && !"".equals(setData[i][6]) && !"".equals(setData[i][8]) ){
						 cnt++;
					}
					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔
					if(!"".equals(setData[i][9]) && !"".equals(setData[i][10]) && !"".equals(setData[i][12]) ){
						 cnt++;
					}
					//�먭� �덇컧��
					if(!"".equals(setData[i][13]) && !"".equals(setData[i][14]) && !"".equals(setData[i][16]) ){
						 cnt++;
					}
					//�몃젰�④� �곸젅��
					if(!"".equals(setData[i][17]) && !"".equals(setData[i][18]) && !"".equals(setData[i][20]) ){
						 cnt++;
					}
					//R&D �ъ옄鍮꾩쨷 
					if(!"".equals(setData[i][21]) && !"".equals(setData[i][22]) && !"".equals(setData[i][24]) ){
						 cnt++;
					}
	    		}
				
	  	    	Logger.debug.println(info.getSession("ID"), this, "[et_setEvalTunkey]========INSERT INTO ICOMVESI .. COUNT ::" + cnt);
	
	  	    	String[][] tmpData2 = new String[cnt][];
	  	    	cnt = 0;
				for(int i=0;i<setData.length;i++){
					//�좎슜�됯��깃툒 
					if(!"".equals(setData[i][5]) && !"".equals(setData[i][6]) && !"".equals(setData[i][8]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][5]		//E_SELECTED_FACTOR
	  	    					, setData[i][6]		//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][8]) * (Integer.valueOf(setData[i][7]) / SCORE_FIVE))		//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
	  	    			tmpData2[cnt] = tempData;
	  	    			cnt++;
					}
					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔
					if(!"".equals(setData[i][9]) && !"".equals(setData[i][10]) && !"".equals(setData[i][12]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][9]		//E_SELECTED_FACTOR
	  	    					, setData[i][10]	//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][12]) * (Integer.valueOf(setData[i][11]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)	
						  	};
	  	    			tmpData2[cnt] = tempData;  
	  	    			cnt++;
					}
					//�먭� �덇컧��
					if(!"".equals(setData[i][13]) && !"".equals(setData[i][14]) && !"".equals(setData[i][16]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][13]	//E_SELECTED_FACTOR
	  	    					, setData[i][14]	//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][16]) * (Integer.valueOf(setData[i][15]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
	  	    			tmpData2[cnt] = tempData; 
	  	    			cnt++;
					}
					//�몃젰�④� �곸젅��
					if(!"".equals(setData[i][17]) && !"".equals(setData[i][18]) && !"".equals(setData[i][20]) ){
						String tempData[] = { 
	  	    					  house_code
	  	    					, setData[i][17]	//E_SELECTED_FACTOR
	  	    					, setData[i][18]	//SELECTED_SEQ
	  	    					, setData[i][1]		//EVAL_ITEM_REFITEM
	  	    					, setData[i][4]		//EVAL_VALUER_ID
	  	    					, house_code
	  	    					, String.valueOf(Integer.valueOf(setData[i][20]) * (Integer.valueOf(setData[i][19]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
	  	    			tmpData2[cnt] = tempData;
	  	    			cnt++;
					}
					//R&D �ъ옄鍮꾩쨷 
					if(!"".equals(setData[i][21]) && !"".equals(setData[i][22]) && !"".equals(setData[i][24]) ){
						String tempData[] = { 
		    					  house_code
		    					, setData[i][21]	//E_SELECTED_FACTOR
		    					, setData[i][22]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][4]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][24]) * (Integer.valueOf(setData[i][23]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
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
	    	   	
	    	   	//�뺣웾�됯� �먯닔 議고쉶
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
	  	    	
	  	    	//�뺣웾 �됯� �먯닔 �낅뜲�댄듃
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
		 * �뺣웾�됯� �뺣낫 議고쉶
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
		 * �좎젙�됯�[�뺣웾] 議고쉶
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
  	    					, wf.getValue(i, 2)		//�좎슜 �됯� �깃툒  [CREDIT_RATING]
  	    					, wf.getValue(i, 3)		//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔 [IRS_NO]
  	    					, "SYSTEM"				//eval_valuer_id[�뺣웾�됯���
  	    					, ""					//�좎슜 �됯� �깃툒				 E_FACTOR_REFITEM
  	    					, ""					//�좎슜 �됯� �깃툒 				�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//�좎슜 �됯� �깃툒 				媛�쨷移�[weight]
  	    					, ""					//�좎슜 �됯� �깃툒 �먯닔
  	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔	 E_FACTOR_REFITEM
  	    					
  	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔 	�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔	WEIGHT
  	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔 �먯닔
  	    					, ""					//�먭� �덇컧��				E_FACTOR_REFITEM
  	    					, ""					//�먭� �덇컧��				�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//�먭� �덇컧��				WEIGHT
  	    					, ""					//�먭� �덇컧���먯닔
  	    					, ""					//�몃젰�④� �곸젅��				E_FACTOR_REFITEM
  	    					, ""					//�몃젰�④� �곸젅��		 	�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//�몃젰�④� �곸젅��				WEIGHT
  	    					
  	    					, ""					//�몃젰�④� �곸젅���먯닔
  	    					, ""					//R&D �ъ옄鍮꾩쨷 				E_FACTOR_REFITEM
  	    					, ""					//R&D �ъ옄鍮꾩쨷			 	�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
  	    					, ""					//R&D �ъ옄鍮꾩쨷				WEIGHT
  	    					, ""					//R&D �ъ옄鍮꾩쨷  �먯닔
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
		 * �됯� FACTOR �몃� �쇰젴踰덊샇 議고쉶
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
		 * �좎젙�됯�[�뺣웾] - [�좎슜 �됯� �깃툒] , [寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔] 怨꾩궛 寃곌낵
		 * 2010.08
		 * icompia swlee
		 */
		private String[][] getEvalVendorCal(ConnectionContext ctx, String[][] setData, String evalFactor, String evalWeight) throws Exception 
		{
			String rtn[][] = null;
				
    		for(int i=0;i<setData.length;i++){
    			if(evalFactor.equals(QUA_TUNKEY_NO_4)){			//�좎젙�됯�-�좎슜 �됯� �깃툒
    				setData[i][5] = evalFactor;
    				setData[i][8] = String.valueOf(getCreditScore(setData[i][2], "", evalFactor));						//�됯��먯닔
    				setData[i][6] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][8] );			//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    				setData[i][7] = evalWeight; 
    			}else if(evalFactor.equals(QUA_TUNKEY_NO_5)){	//�좎젙�됯�-寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т
					setData[i][9] = evalFactor;
					int chkYear = 0;
					setData[i][12] = String.valueOf(getOwnerWorkScore(ctx, setData[i][3], chkYear));				//�됯��먯닔
					setData[i][10] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][12] );		//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
					setData[i][11] = evalWeight;
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_1)){	//醫낇빀�됯�-�좎슜 �됯� �깃툒
    				setData[i][5] = evalFactor;
    				setData[i][8] = String.valueOf(getCreditScore(setData[i][4], "", evalFactor));						//�됯��먯닔
    				setData[i][6] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][10] );			//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    				setData[i][7] = evalWeight; 
    			}else if(evalFactor.equals(QUA_SCHEDULE_NO_3)){	//醫낇빀�됯�-�꾧툑 �먮쫫 �깃툒
    				setData[i][22] = evalFactor;
    				setData[i][25] = String.valueOf(getCreditScore("", setData[i][23], evalFactor));						//�됯��먯닔
    				setData[i][23] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][27] );			//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    				setData[i][24] = evalWeight; 
    			}else if(evalFactor.equals(QUA_SCHEDULE_NO_2)){	//醫낇빀�됯�-寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т
					setData[i][11] = evalFactor;
					int chkYear = 1; 	//醫낇빀�됯���寃쎌슦 吏곸쟾�꾨룄 湲곗�.
					setData[i][14] = String.valueOf(getOwnerWorkScore(ctx, setData[i][5], chkYear));				//�됯��먯닔
					setData[i][12] = et_getEvalFactorItemInfo(ctx, evalFactor, setData[i][14] );		//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
					setData[i][13] = evalWeight;
				}
    			
    		}
    		rtn = setData;
	  	    		
			return rtn;
		}
		
		/*
		 * �먭� �덇컧��怨꾩궛 
		 */
		private String[][] getEvalVendorCalCost(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
		throws Exception 
		{
			String rtn[][] = null;
			Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCost] [�먭� �덇컧�� 怨꾩궛 START.");
			
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
  	    					setData[j][16] = vendorScore;										//�됯��먯닔
  	    					setData[j][14] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
  	    					setData[j][15] = evalWeight;
  	  	    			}	
  	    			}
				}
  	    	}else{
  	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCost] [�먭� �덇컧�� 怨꾩궛���곗씠���놁뒾.");
  	    	}
			
  	    	rtn = setData;
  	    		
			return rtn;
		}
		
		/*
		 * �몃젰 �④� �곸젅��怨꾩궛 
		 */
		private String[][] getEvalVendorCalHumanUnitPrice(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
		throws Exception  
		{
			String rtn[][] = null;
			Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [�몃젰 �④� �곸젅�� 怨꾩궛 START.");
			
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
  	    					setData[j][20] = vendorScore;										//�됯��먯닔
  	    					setData[j][18] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
  	    					setData[j][19] = evalWeight;
  	  	    			}	
  	    			}
				}
  	    	}else{
  	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [�몃젰 �④� �곸젅�� 怨꾩궛���곗씠���놁뒾.");
	  	    }
  	    		 
  	    	rtn = setData;
	  	    		
			return rtn;
		}
		

		/*
		 * R&D �ъ옄鍮꾩쨷 怨꾩궛 
		 */
		private String[][] getEvalVendorCalInvestWeight(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
		throws Exception  
		{
			String rtn[][] = null;
			Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalInvestWeight] [R&D �ъ옄鍮꾩쨷] 怨꾩궛 START.");
			
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
  	    					setData[j][24] = vendorScore;										//�됯��먯닔
  	    					setData[j][22] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
  	    					setData[j][23] = evalWeight;
  	  	    			}	
  	    			}
				}
  	    	}else{
  	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalInvestWeight] [R&D �ъ옄鍮꾩쨷] 怨꾩궛���곗씠���놁뒾.");
	  	    }
  	    		 
  	    	rtn = setData;
	  	    		
			return rtn;
		}
		
		/*
		 * �좎젙�됯�[�뺣웾] - �좎슜 �됯� �깃툒 �먯닔 由고꽩
		 * 2010.08
		 * icompia swlee
		 */
		private int getCreditScore(String compareCreditClass, String compareCashClass, String evalFactor) throws Exception {
			int iCashScore = 0;
			int iCreditScore = 0;
			int iRtn = 0;
			
			String[][] credit_Class = {	// �좎슜 �됯� �깃툒 
				{"NG1", "NG2"},									/* 0��*/
				{"CC", "C", "D"},								/* 1��*/
				{"B+", "B0", "B-", "CCC+", "CCC0", "CCC-"},		/* 2��*/
				{"BBB+", "BBB0", "BBB-", "BB+", "BB0", "BB-"},	/* 3��*/
				{"A+", "A0", "A-"},								/* 4��*/
				{"AAA", "AA+", "AA0", "AA-"}					/* 5��*/
			};	//�섏씠�ㅻ뵒�붾퉬
			
			String[][] cash_Class = {	// �꾧툑�먮쫫 �깃툒
					{""},										/* 0��*/
					{"C(CFR5)", "D(CFR6)", "E(NR1)", "E(NR2)"},	/* 1��*/ 
					{"C+(CFR4)"},								/* 2��*/
					{"B(CFR3)"}, 								/* 3��*/
					{"B+(CFR2)"},								/* 4��*/
					{"A(CFR1)"}									/* 5��*/
			};	//�섏씠�ㅻ뵒�붾퉬
			
			//�좎슜 �됯� �깃툒 
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
				Logger.debug.println( info.getSession("ID"), this, "[getCreditScore]�좎슜�됯��깃툒�먯닔::" +iRtn);
			}	 
			
			//�꾧툑�먮쫫 �깃툒
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
				Logger.debug.println( info.getSession("ID"), this, "[getCreditScore]�꾧툑�먮쫫�깃툒�먯닔::" +iRtn);
			}	 
			
			Logger.debug.println( info.getSession("ID"), this, "[getCreditScore].......iRtn::" +iRtn);
			return iRtn;
		}

	/*
	 * �좎젙�됯�[�뺣웾] - 怨듦툒�낆껜 寃쎌쁺��洹쇰Т�꾩닔  �먯닔 由고꽩
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
    		Logger.debug.println(info.getSession( "ID" ),this, "[getOwnerWorkScore] [洹쇱냽 �뺣낫] Work_Y::"+sWork_Y);
  			SepoaStringTokenizer st = new SepoaStringTokenizer(sWork_Y, "-", false);
		
  			int i = 0;
	  		while(st.hasMoreTokens()){
	  			if(i==0){
	  				sOwnerWork_YY = st.nextToken();
	  				Logger.debug.println(info.getSession( "ID" ),this, "[getOwnerWorkScore] 洹쇱냽�꾩닔::"+sOwnerWork_YY);
	  			}else{
	  				sOwnerWork_MM = st.nextToken().trim();
	  				Logger.debug.println(info.getSession( "ID" ),this, "[getOwnerWorkScore] 洹쇱냽��:"+sOwnerWork_MM);
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
  	 *  �좎젙�됯�[�뺣웾] - 怨듦툒�낆껜 寃쎌쁺��洹쇰Т�꾩닔 議고쉶
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
  	 * �좎젙�됯�[�뺣웾] - 怨듦툒�낆껜 �먭� �덇컧��議고쉶
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
  	 *  �좎젙�됯�[�뺣웾] - 怨듦툒�낆껜 �몃젰 �④� �곸젅��議고쉶
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
  	 *  �좎젙�됯�[�뺣웾] - R&D �ъ옄鍮꾩쨷 議고쉶
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
	 * 醫낇빀[�뺢린]�됯� -�뺣웾 泥섎━
	 * 2010.08
	 * icompia swlee
	 */
	private int setEvalSchedule(ConnectionContext ctx, String eval_refitem) throws Exception 
	{
		int isOk = 0;
		SepoaFormater wf = null;
		
		// 醫낇빀�됯�[�뺣웾] �됯���긽�낆껜 �뺣낫 議고쉶
		String evalData[][] = getEvalScheduleVendorInfo(ctx, eval_refitem);
		// �뺣웾�됯� �뺣낫 議고쉶
		String rtn = et_getEvalQuantityFactorList(ctx, eval_refitem);
		wf =  new SepoaFormater(rtn);    	    		
		String evalFactor = "";
		String evalWeight = "";
			for(int i=0;i<wf.getRowCount();i++){
				evalFactor = wf.getValue("E_FACTOR_REFITEM", i);
				evalWeight = wf.getValue("WEIGHT", i);
				
				Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] E_FACTOR_REFITEM::"+evalFactor);
				
				if(evalFactor.equals(QUA_SCHEDULE_NO_1)){	//�좎슜 �됯� �깃툒
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_2)){	//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_3)){	//�꾧툑�먮쫫�깃툒
					evalData = getEvalVendorCal(ctx, evalData, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_4)){	//�먭� �덇컧瑜�
					evalData = getEvalVendorCalCostRate(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_5)){	//�몃젰�④� �곸젅��
					evalData = getEvalVendorCalHumanUnitPriceYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_6)){	//�ъ엯怨듭닔���곸젅��
					evalData = getEvalVendorCalWorkDayAppropriacy(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_7)){	//�ш굅�섏쓽��
					evalData = getEvalVendorCalReBusinessYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_8)){	//�ъ슜���덉쭏 留뚯”��
					evalData = getEvalVendorCalQualitySatisfactionYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_9)){	//寃곌낵臾��덉쭏
					evalData = getEvalVendorCalProductQualityYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_10)){	//�ъ엯�몃젰����썙��由щ뜑��
					evalData = getEvalVendorCalTeamWorkYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_11)){	//�낅Т �깆떎��
					evalData = getEvalVendorCalWorkSincerityYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_12)){	//�곗닔 �몃젰 鍮꾩쑉
					evalData = getEvalVendorCalExceHumanRateYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_13)){	//湲곗닠��
					evalData = getEvalVendorCalTechSkillsYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_14)){	//�곗뾽 �댄빐��
					evalData = getEvalVendorCalIndustryCompYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_15)){	//�ъ엯�몃젰���먭꺽�몄쬆
					evalData = getEvalVendorCalHumanQualCertYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_16)){	//�꾨줈�앺듃 �섑뻾�대젰
					evalData = getEvalVendorCalProjectPerfHistoryYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_17)){	//�낅Т �묒“��
					evalData = getEvalVendorCalBusinessCoopYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_18)){	//湲곗닠吏�썝 �곹깭
					evalData = getEvalVendorCalTechSupportYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_19)){	//�낆같 �붿껌 ��퉬 �묒같��
					evalData = getEvalVendorCalBidRateYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_20)){	//�ъ엯 �몃젰 �뺥솗��
					evalData = getEvalVendorCalHumanAccuracyYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}else if(evalFactor.equals(QUA_SCHEDULE_NO_21)){	//�뺢퇋吏�鍮꾩쑉
					evalData = getEvalVendorCalRegularEmpRateYear(ctx, evalData, eval_refitem, evalFactor, evalWeight);
				}
				
			}
			
			//�깅줉 泥섎━ - �묒뾽 吏꾪뻾 以�
			isOk = et_setEvalSchedule(ctx, evalData, eval_refitem);
			Logger.debug.println(info.getSession( "ID" ),this, "[setEvalTunkey] et_setEvalTunkey 寃곌낵 .. isOk ::"+isOk);
			//if(isOk < 0){
			//	throw new Exception("�뺣웾�됯� �뺣낫 �깅줉 以��ㅻ쪟媛�諛쒖깮�섏��듬땲��");
	    	//}
			
  		return isOk;
	}
	

	/*
	 * 醫낇빀�됯�[�뺣웾] 議고쉶
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
	    					, wf.getValue(i, 2)		//醫낇빀�됯� �됯���긽 �쒖옉�쇱옄
	    					, wf.getValue(i, 3)		//醫낇빀�됯� �됯���긽 醫낅즺�쇱옄
	    					, wf.getValue(i, 4)		//�좎슜 �됯� �깃툒  [CREDIT_RATING]
	    					, wf.getValue(i, 5)		//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔 [WORK_Y]
	    					, "SYSTEM"				//eval_valuer_id[�뺣웾�됯���
	    					, ""					//�좎슜 �됯� �깃툒				 	E_FACTOR_REFITEM
	    					, ""					//�좎슜 �됯� �깃툒 					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�좎슜 �됯� �깃툒 					媛�쨷移�[weight]
	    					//10
	    					, ""					//�좎슜 �됯� �깃툒 �먯닔
	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔	 	E_FACTOR_REFITEM
	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔 		�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔		WEIGHT
	    					, ""					//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔 �먯닔
	    					, ""					//�먭� �덇컧瑜�					E_FACTOR_REFITEM
	    					, ""					//�먭� �덇컧瑜�					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�먭� �덇컧瑜�					WEIGHT
	    					, ""					//�먭� �덇컧瑜��먯닔
	    					, ""					//�몃젰�④� �곸젅��					E_FACTOR_REFITEM
	    					// 20
	    					, ""					//�몃젰�④� �곸젅��		 		�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�몃젰�④� �곸젅��					WEIGHT
	    					, ""					//�몃젰�④� �곸젅���먯닔
	    					, wf.getValue(i, 6)		//�꾧툑�먮쫫�깃툒
	    					, ""					//�꾧툑�먮쫫�깃툒				 	E_FACTOR_REFITEM
	    					, ""					//�꾧툑�먮쫫�깃툒 					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�꾧툑�먮쫫�깃툒 					媛�쨷移�[weight]
	    					, ""					//�꾧툑�먮쫫�깃툒�먯닔
	    					, ""					//�ъ엯怨듭닔���곸젅��				E_FACTOR_REFITEM
	    					, ""					//�ъ엯怨듭닔���곸젅��		 	�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					// 30
	    					, ""					//�ъ엯怨듭닔���곸젅��				WEIGHT
	    					, ""					//�ъ엯怨듭닔���곸젅���먯닔
	    					, ""					//�ш굅�섏쓽�� 					E_FACTOR_REFITEM
	    					, ""					//�ш굅�섏쓽��						�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�ш굅�섏쓽��						WEIGHT
	    					, ""					//�ш굅�섏쓽���먯닔
	    					, ""					//�ъ슜�먰뭹吏덈쭔議깅룄 				E_FACTOR_REFITEM
	    					, ""					//�ъ슜�먰뭹吏덈쭔議깅룄			 	�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�ъ슜�먰뭹吏덈쭔議깅룄 				WEIGHT
	    					, ""					//�ъ슜�먰뭹吏덈쭔議깅룄 �먯닔
	    					//40
	    					, ""					//寃곌낵臾��덉쭏 					E_FACTOR_REFITEM
	    					, ""					//寃곌낵臾��덉쭏			 			�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//寃곌낵臾��덉쭏 					WEIGHT
	    					, ""					//寃곌낵臾��덉쭏 �먯닔
	    					, ""					//�ъ엯�몃젰����썙��由щ뜑��		E_FACTOR_REFITEM
	    					, ""					//�ъ엯�몃젰����썙��由щ뜑��	�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�ъ엯�몃젰����썙��由щ뜑��		WEIGHT
	    					, ""					//�ъ엯�몃젰����썙��由щ뜑���먯닔
	    					, ""					//�낅Т �깆떎��					E_FACTOR_REFITEM
	    					, ""					//�낅Т �깆떎��		 			�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					//50
	    					, ""					//�낅Т �깆떎��					WEIGHT
	    					, ""					//�낅Т �깆떎���먯닔
	    					, ""					//�곗닔 �몃젰 鍮꾩쑉  					E_FACTOR_REFITEM
	    					, ""					//�곗닔 �몃젰 鍮꾩쑉 					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�곗닔 �몃젰 鍮꾩쑉 					WEIGHT
	    					, ""					//�곗닔 �몃젰 鍮꾩쑉 �먯닔
	    					, ""					//湲곗닠��	  					E_FACTOR_REFITEM
	    					, ""					//湲곗닠��						�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//湲곗닠��						WEIGHT
	    					, ""					//湲곗닠���먯닔
	    					//60
	    					, ""					//�곗뾽 �댄빐�� 					E_FACTOR_REFITEM
	    					, ""					//�곗뾽 �댄빐��					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�곗뾽 �댄빐��					WEIGHT
	    					, ""					//�곗뾽 �댄빐���먯닔
	    					, ""					//�ъ엯�몃젰���먭꺽�몄쬆 				E_FACTOR_REFITEM
	    					, ""					//�ъ엯�몃젰���먭꺽�몄쬆 				�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�ъ엯�몃젰���먭꺽�몄쬆 				WEIGHT
	    					, ""					//�ъ엯�몃젰���먭꺽�몄쬆 �먯닔
	    					, ""					//�꾨줈�앺듃 �섑뻾�대젰  				E_FACTOR_REFITEM
	    					, ""					//�꾨줈�앺듃 �섑뻾�대젰 				�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					//70
	    					, ""					//�꾨줈�앺듃 �섑뻾�대젰 				WEIGHT
	    					, ""					//�꾨줈�앺듃 �섑뻾�대젰 �먯닔
	    					, ""					//�낅Т �묒“�� 					E_FACTOR_REFITEM
	    					, ""					//�낅Т �묒“��					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�낅Т �묒“��					WEIGHT
	    					, ""					//�낅Т �묒“���먯닔
	    					, ""					//湲곗닠吏�썝 �곹깭  					E_FACTOR_REFITEM
	    					, ""					//湲곗닠吏�썝 �곹깭 					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//湲곗닠吏�썝 �곹깭 					WEIGHT
	    					, ""					//湲곗닠吏�썝 �곹깭 �먯닔
	    					//80
	    					, ""					//�낆같�붿껌��퉬�묒같�� 				E_FACTOR_REFITEM
	    					, ""					//�낆같�붿껌��퉬�묒같��				�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�낆같�붿껌��퉬�묒같��				WEIGHT
	    					, ""					//�낆같�붿껌��퉬�묒같���먯닔
	    					, ""					//�ъ엯�몃젰 �뺥솗�� 				E_FACTOR_REFITEM
	    					, ""					//�ъ엯�몃젰 �뺥솗��					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					, ""					//�ъ엯�몃젰 �뺥솗��					WEIGHT
	    					, ""					//�ъ엯�몃젰 �뺥솗���먯닔
	    					, ""					//�뺢퇋吏�鍮꾩쑉  					E_FACTOR_REFITEM
	    					, ""					//�뺢퇋吏�鍮꾩쑉 					�좏깮�쇰젴踰덊샇 [E_FACTOR_ITEM_REFITEM]
	    					//90
	    					, ""					//�뺢퇋吏�鍮꾩쑉 					WEIGHT
	    					, ""					//�뺢퇋吏�鍮꾩쑉 �먯닔

			  	};
	    			setData[i] = tmpData;  
	    		}
		}
	    	rtn = setData;
	    		
		return rtn;
	}
	
/*
 * 醫낇빀�됯� ��긽�낆껜 議고쉶 
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
	 * �뺣웾�됯� �뺣낫 �깅줉(icomvevl, icomvesi)
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
				//�좎슜�됯��깃툒 
				if(!"".equals(setData[i][7]) && !"".equals(setData[i][8]) && !"".equals(setData[i][10]) ){
					 cnt++;
				}
				//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔
				if(!"".equals(setData[i][11]) && !"".equals(setData[i][12]) && !"".equals(setData[i][14]) ){
					 cnt++;
				}
				//�먭� �덇컧瑜�
				if(!"".equals(setData[i][15]) && !"".equals(setData[i][16]) && !"".equals(setData[i][18]) ){
					 cnt++;
				}
				//�몃젰�④� �곸젅��
				if(!"".equals(setData[i][19]) && !"".equals(setData[i][20]) && !"".equals(setData[i][22]) ){
					 cnt++;
				}
				//�꾧툑 �먮쫫 �깃툒
				if(!"".equals(setData[i][24]) && !"".equals(setData[i][25]) && !"".equals(setData[i][27]) ){
					 cnt++;
				}
				//�ъ엯怨듭닔���곸젅��
				if(!"".equals(setData[i][28]) && !"".equals(setData[i][29]) && !"".equals(setData[i][31]) ){
					 cnt++;
				}
				//�ш굅���섏궗
				if(!"".equals(setData[i][32]) && !"".equals(setData[i][33]) && !"".equals(setData[i][35]) ){
					 cnt++;
				}
				//�ъ슜���덉쭏 留뚯”��
				if(!"".equals(setData[i][36]) && !"".equals(setData[i][37]) && !"".equals(setData[i][39]) ){
					 cnt++;
				}
				//寃곌낵臾��덉쭏 
				if(!"".equals(setData[i][40]) && !"".equals(setData[i][41]) && !"".equals(setData[i][43]) ){
					 cnt++;
				}
				//�ъ엯�몃젰����썙��由щ뜑��
				if(!"".equals(setData[i][44]) && !"".equals(setData[i][45]) && !"".equals(setData[i][47]) ){
					 cnt++;
				}
				//�낅Т �깆떎��
				if(!"".equals(setData[i][48]) && !"".equals(setData[i][49]) && !"".equals(setData[i][51]) ){
					 cnt++;
				}
				
				//�곗닔 �몃젰 鍮꾩쑉
				if(!"".equals(setData[i][52]) && !"".equals(setData[i][53]) && !"".equals(setData[i][55]) ){
					 cnt++;
				}
				//湲곗닠��
				if(!"".equals(setData[i][56]) && !"".equals(setData[i][57]) && !"".equals(setData[i][59]) ){
					 cnt++;
				}
				//�곗뾽 �댄빐��
				if(!"".equals(setData[i][60]) && !"".equals(setData[i][61]) && !"".equals(setData[i][63]) ){
					 cnt++;
				}
				//�ъ엯�몃젰���먭꺽�몄쬆
				if(!"".equals(setData[i][64]) && !"".equals(setData[i][65]) && !"".equals(setData[i][67]) ){
					 cnt++;
				}
				//�꾨줈�앺듃 �섑뻾�대젰
				if(!"".equals(setData[i][68]) && !"".equals(setData[i][69]) && !"".equals(setData[i][71]) ){
					 cnt++;
				}
				//�낅Т �묒“��
				if(!"".equals(setData[i][72]) && !"".equals(setData[i][73]) && !"".equals(setData[i][75]) ){
					 cnt++;
				}
				//湲곗닠吏�썝 �곹깭
				if(!"".equals(setData[i][76]) && !"".equals(setData[i][77]) && !"".equals(setData[i][79]) ){
					 cnt++;
				}
				//�낆같�붿껌��퉬�묒같��
				if(!"".equals(setData[i][80]) && !"".equals(setData[i][81]) && !"".equals(setData[i][83]) ){
					 cnt++;
				}
				//�ъ엯�몃젰 �뺥솗��
				if(!"".equals(setData[i][84]) && !"".equals(setData[i][85]) && !"".equals(setData[i][87]) ){
					 cnt++;
				}
				//�뺢퇋吏�鍮꾩쑉
				if(!"".equals(setData[i][88]) && !"".equals(setData[i][89]) && !"".equals(setData[i][91]) ){
					 cnt++;
				}
			
			}
			
		    Logger.debug.println(info.getSession("ID"), this, "[et_setEvalSchedule]========INSERT INTO ICOMVESI .. COUNT ::" + cnt);
	    	String[][] tmpData2 = new String[cnt][];
	    	cnt = 0;
			for(int i=0;i<setData.length;i++){
				//�좎슜�됯��깃툒 
				if(!"".equals(setData[i][7]) && !"".equals(setData[i][8]) && !"".equals(setData[i][10]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][7]		//E_SELECTED_FACTOR
		    					, setData[i][8]		//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][10]) * (Integer.valueOf(setData[i][9]) / SCORE_FIVE))		//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//寃쎌쁺�먯쓽 �대떦 �낆쥌 洹쇰Т�꾩닔
				if(!"".equals(setData[i][11]) && !"".equals(setData[i][12]) && !"".equals(setData[i][14]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][11]		//E_SELECTED_FACTOR
		    					, setData[i][12]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][14]) * (Integer.valueOf(setData[i][13]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)	
					  	};
		    		tmpData2[cnt] = tempData;  
		    		cnt++;
				}
				//�먭� �덇컧瑜�
				if(!"".equals(setData[i][15]) && !"".equals(setData[i][16]) && !"".equals(setData[i][18]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][15]	//E_SELECTED_FACTOR
		    					, setData[i][16]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][18]) * (Integer.valueOf(setData[i][17]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData; 
		    		cnt++;
				}
				//�몃젰�④� �곸젅��
				if(!"".equals(setData[i][19]) && !"".equals(setData[i][20]) && !"".equals(setData[i][22]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][19]	//E_SELECTED_FACTOR
		    					, setData[i][20]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][22]) * (Integer.valueOf(setData[i][21]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//�꾧툑 �먮쫫 �깃툒
				if(!"".equals(setData[i][24]) && !"".equals(setData[i][25]) && !"".equals(setData[i][27]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][24]	//E_SELECTED_FACTOR
		    					, setData[i][25]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][27]) * (Integer.valueOf(setData[i][26]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//�ъ엯怨듭닔���곸젅��
				if(!"".equals(setData[i][28]) && !"".equals(setData[i][29]) && !"".equals(setData[i][31]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][28]	//E_SELECTED_FACTOR
		    					, setData[i][29]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][31]) * (Integer.valueOf(setData[i][30]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//�ш굅���섏궗
				if(!"".equals(setData[i][32]) && !"".equals(setData[i][33]) && !"".equals(setData[i][35]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][32]	//E_SELECTED_FACTOR
		    					, setData[i][33]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][35]) * (Integer.valueOf(setData[i][34]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//�ъ슜���덉쭏 留뚯”��
				if(!"".equals(setData[i][36]) && !"".equals(setData[i][37]) && !"".equals(setData[i][39]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][36]	//E_SELECTED_FACTOR
		    					, setData[i][37]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][39]) * (Integer.valueOf(setData[i][38]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//寃곌낵臾��덉쭏 
				if(!"".equals(setData[i][40]) && !"".equals(setData[i][41]) && !"".equals(setData[i][43]) ){
					String tempData[] = { 
		    					  house_code
		    					, setData[i][40]	//E_SELECTED_FACTOR
		    					, setData[i][41]	//SELECTED_SEQ
		    					, setData[i][1]		//EVAL_ITEM_REFITEM
		    					, setData[i][6]		//EVAL_VALUER_ID
		    					, house_code
		    					, String.valueOf(Integer.valueOf(setData[i][43]) * (Integer.valueOf(setData[i][42]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
					  	};
		    		tmpData2[cnt] = tempData;
		    		cnt++;
				}
				//�ъ엯�몃젰����썙��由щ뜑��
				if(!"".equals(setData[i][44]) && !"".equals(setData[i][45]) && !"".equals(setData[i][47]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][44]	//E_SELECTED_FACTOR
			  					, setData[i][45]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][47]) * (Integer.valueOf(setData[i][46]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//�낅Т �깆떎��
				if(!"".equals(setData[i][48]) && !"".equals(setData[i][49]) && !"".equals(setData[i][51]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][48]	//E_SELECTED_FACTOR
			  					, setData[i][49]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][51]) * (Integer.valueOf(setData[i][50]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				
	
				//�곗닔 �몃젰 鍮꾩쑉
				if(!"".equals(setData[i][52]) && !"".equals(setData[i][53]) && !"".equals(setData[i][55]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][52]	//E_SELECTED_FACTOR
			  					, setData[i][53]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][55]) * (Integer.valueOf(setData[i][54]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//湲곗닠��
				if(!"".equals(setData[i][56]) && !"".equals(setData[i][57]) && !"".equals(setData[i][59]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][56]	//E_SELECTED_FACTOR
			  					, setData[i][57]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][59]) * (Integer.valueOf(setData[i][58]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//�곗뾽 �댄빐��
				if(!"".equals(setData[i][60]) && !"".equals(setData[i][61]) && !"".equals(setData[i][63]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][60]	//E_SELECTED_FACTOR
			  					, setData[i][61]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][63]) * (Integer.valueOf(setData[i][62]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//�ъ엯�몃젰���먭꺽�몄쬆
				if(!"".equals(setData[i][64]) && !"".equals(setData[i][65]) && !"".equals(setData[i][67]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][64]	//E_SELECTED_FACTOR
			  					, setData[i][65]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][67]) * (Integer.valueOf(setData[i][66]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//�꾨줈�앺듃 �섑뻾�대젰
				if(!"".equals(setData[i][68]) && !"".equals(setData[i][69]) && !"".equals(setData[i][71]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][68]	//E_SELECTED_FACTOR
			  					, setData[i][69]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][71]) * (Integer.valueOf(setData[i][70]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				
				//�낅Т �묒“��
				if(!"".equals(setData[i][72]) && !"".equals(setData[i][73]) && !"".equals(setData[i][75]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][72]	//E_SELECTED_FACTOR
			  					, setData[i][73]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][75]) * (Integer.valueOf(setData[i][74]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//湲곗닠吏�썝 �곹깭
				if(!"".equals(setData[i][76]) && !"".equals(setData[i][77]) && !"".equals(setData[i][79]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][76]	//E_SELECTED_FACTOR
			  					, setData[i][77]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][79]) * (Integer.valueOf(setData[i][78]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//�낆같�붿껌��퉬�묒같��
				if(!"".equals(setData[i][80]) && !"".equals(setData[i][81]) && !"".equals(setData[i][83]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][80]	//E_SELECTED_FACTOR
			  					, setData[i][81]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][83]) * (Integer.valueOf(setData[i][82]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//�ъ엯�몃젰 �뺥솗��
				if(!"".equals(setData[i][84]) && !"".equals(setData[i][85]) && !"".equals(setData[i][87]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][84]	//E_SELECTED_FACTOR
			  					, setData[i][85]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][87]) * (Integer.valueOf(setData[i][86]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
						  	};
			  		tmpData2[cnt] = tempData;
			  		cnt++;
				}
				//�뺢퇋吏�鍮꾩쑉
				if(!"".equals(setData[i][88]) && !"".equals(setData[i][89]) && !"".equals(setData[i][91]) ){
					String tempData[] = { 
			  					  house_code
			  					, setData[i][88]	//E_SELECTED_FACTOR
			  					, setData[i][89]	//SELECTED_SEQ
			  					, setData[i][1]		//EVAL_ITEM_REFITEM
			  					, setData[i][6]		//EVAL_VALUER_ID
			  					, house_code
			  					, String.valueOf(Integer.valueOf(setData[i][91]) * (Integer.valueOf(setData[i][90]) / SCORE_FIVE))	//SELECTED_SEQ_SCORE  :: �좏깮��ぉ �먯닔 * (媛�쨷移��됯���ぉ 理쒓퀬�먯닔)
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
		   	
		   	//�뺣웾�됯� �먯닔 議고쉶
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
		    	
		    	//�뺣웾 �됯� �먯닔 �낅뜲�댄듃
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
	 * 醫낇빀�됯�[�뺣웾]-�먭� �덇컧瑜�怨꾩궛 
	 */
	private String[][] getEvalVendorCalCostRate(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception 
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCostRate] [�먭� �덇컧瑜� 怨꾩궛 START.");
		
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
	    					setData[j][18] = vendorScore;										//�됯��먯닔
	    					setData[j][16] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
	    					setData[j][17] = evalWeight;
	  	    			}	
	    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalCostRate] [�먭� �덇컧瑜� 怨꾩궛���곗씠���놁뒾.");
	    	}
		
	    	rtn = setData;
	    		
		return rtn;
	}
  	

  	/*
  	 * 醫낇빀�됯�[�뺣웾]-�먭� �덇컧瑜�議고쉶
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
	 * 醫낇빀�됯�[�뺣웾]-�ъ엯怨듭닔���곸젅��怨꾩궛 
	 */
	private String[][] getEvalVendorCalWorkDayAppropriacy(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkDayAppropriacy] [�ъ엯怨듭닔���곸젅�� 怨꾩궛 START.");
		
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
	    					setData[j][31] = vendorScore;										//�됯��먯닔
	    					setData[j][29] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
	    					setData[j][30] = evalWeight;
	  	    			}	
	    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkDayAppropriacy] [�ъ엯怨듭닔���곸젅�� 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  醫낇빀�됯�[�뺣웾] - �ъ엯怨듭닔���곸젅��議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - �몃젰 �④� �곸젅��怨꾩궛 
	 */
	private String[][] getEvalVendorCalHumanUnitPriceYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [�몃젰 �④� �곸젅�� 怨꾩궛 START.");
		
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
    					setData[j][22] = vendorScore;										//�됯��먯닔
    					setData[j][20] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][21] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanUnitPrice] [�몃젰 �④� �곸젅�� 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}
	


  	/*
  	 *  醫낇빀�됯�[�뺣웾] - 怨듦툒�낆껜 �몃젰 �④� �곸젅��議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - �ш굅���섏궗 怨꾩궛 
	 */
	private String[][] getEvalVendorCalReBusinessYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalReBusinessYear] [�ш굅���섏궗]  怨꾩궛 START.");
		
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
    					setData[j][35] = vendorScore;										//�됯��먯닔
    					setData[j][33] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][34] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalReBusinessYear] [�ш굅���섏궗 ] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}
	

  	/*
  	 *  醫낇빀�됯�[�뺣웾] -   議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - �ъ슜���덉쭏 留뚯”��怨꾩궛 
	 */
	private String[][] getEvalVendorCalQualitySatisfactionYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalQualitySatisfactionYear] [�ъ슜���덉쭏 留뚯”�� 怨꾩궛 START.");
		
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
    					setData[j][39] = vendorScore;										//�됯��먯닔
    					setData[j][37] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][38] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalQualitySatisfactionYear] [�ъ슜���덉쭏 留뚯”��  怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    	rtn = setData;
  	    		
		return rtn;
	}
	

  	/*
  	 *  醫낇빀�됯�[�뺣웾] -  議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - 寃곌낵臾��덉쭏 怨꾩궛 
	 */
	private String[][] getEvalVendorCalProductQualityYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProductQualityYear] [寃곌낵臾��덉쭏] 怨꾩궛 START.");
		
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
    					setData[j][43] = vendorScore;										//�됯��먯닔
    					setData[j][41] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][42] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProductQualityYear] [寃곌낵臾��덉쭏]  怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	
 

	/*
	 * 醫낇빀�됯�[�뺣웾] - �ъ엯�몃젰����썙��由щ뜑��怨꾩궛 
	 */
	private String[][] getEvalVendorCalTeamWorkYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTeamWorkYear] [�ъ엯�몃젰����썙��由щ뜑�� 怨꾩궛 START.");
		
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
    					setData[j][47] = vendorScore;										//�됯��먯닔
    					setData[j][45] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][46] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTeamWorkYear] [�ъ엯�몃젰����썙��由щ뜑��] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	
 
	/*
	 * 醫낇빀�됯�[�뺣웾] - �낅Т �깆떎��怨꾩궛 
	 */
	private String[][] getEvalVendorCalWorkSincerityYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkSincerityYear] [�낅Т �깆떎�� 怨꾩궛 START.");
		
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
    					setData[j][51] = vendorScore;										//�됯��먯닔
    					setData[j][49] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][50] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalWorkSincerityYear] [�낅Т �깆떎��] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

	/*
	 * 醫낇빀�됯�[�뺣웾] - �곗닔 �몃젰 鍮꾩쑉 怨꾩궛 
	 */
	private String[][] getEvalVendorCalExceHumanRateYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalExceHumanRateYear] [�곗닔 �몃젰 鍮꾩쑉] 怨꾩궛 START.");
		
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
    					setData[j][55] = vendorScore;										//�됯��먯닔
    					setData[j][53] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][54] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalExceHumanRateYear] [�곗닔 �몃젰 鍮꾩쑉 ] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


  	/*
  	 *  醫낇빀�됯�[�뺣웾] - �곗닔 �몃젰 鍮꾩쑉  議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - 湲곗닠��怨꾩궛 
	 */
	private String[][] getEvalVendorCalTechSkillsYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSkillsYear] [湲곗닠�� 怨꾩궛 START.");
		
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
    					setData[j][59] = vendorScore;										//�됯��먯닔
    					setData[j][57] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][58] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSkillsYear] [湲곗닠��] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


	/*
	 * 醫낇빀�됯�[�뺣웾] - �곗뾽 �댄빐��怨꾩궛 
	 */
	private String[][] getEvalVendorCalIndustryCompYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalIndustryCompYear] [�곗뾽 �댄빐�� 怨꾩궛 START.");
		
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
    					setData[j][63] = vendorScore;										//�됯��먯닔
    					setData[j][61] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][62] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalIndustryCompYear] [�곗뾽 �댄빐��] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


	/*
	 * 醫낇빀�됯�[�뺣웾] - �ъ엯�몃젰���먭꺽�몄쬆 怨꾩궛 
	 */
	private String[][] getEvalVendorCalHumanQualCertYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanQualCertYear] [�ъ엯�몃젰���먭꺽�몄쬆] 怨꾩궛 START.");
		
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
    					setData[j][67] = vendorScore;										//�됯��먯닔
    					setData[j][65] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][66] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanQualCertYear] [�ъ엯�몃젰���먭꺽�몄쬆 ] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}


	/*
	 * 醫낇빀�됯�[�뺣웾] - �꾨줈�앺듃 �섑뻾�대젰 怨꾩궛 
	 */
	private String[][] getEvalVendorCalProjectPerfHistoryYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProjectPerfHistoryYear] [�꾨줈�앺듃 �섑뻾�대젰] 怨꾩궛 START.");
		
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
    					setData[j][71] = vendorScore;										//�됯��먯닔
    					setData[j][69] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][70] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalProjectPerfHistoryYear] [�꾨줈�앺듃 �섑뻾�대젰 ] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  醫낇빀�됯�[�뺣웾] - 湲곗닠�� �곗뾽�댄빐�� �ъ엯�몃젰���먭꺽�몄쬆, �꾨줈�앺듃�섑뻾�대젰  議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - �낅Т�묒“��怨꾩궛 
	 */
	private String[][] getEvalVendorCalBusinessCoopYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBusinessCoopYear] [�낅Т�묒“�� 怨꾩궛 START.");
		
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
    					setData[j][75] = vendorScore;										//�됯��먯닔
    					setData[j][73] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][74] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBusinessCoopYear] [�낅Т�묒“��] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	

	/*
	 * 醫낇빀�됯�[�뺣웾] - 湲곗닠吏�썝�곹깭 怨꾩궛 
	 */
	private String[][] getEvalVendorCalTechSupportYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSupportYear] [湲곗닠吏�썝�곹깭] 怨꾩궛 START.");
		
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
    					setData[j][79] = vendorScore;										//�됯��먯닔
    					setData[j][77] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][78] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalTechSupportYear] [湲곗닠吏�썝�곹깭 ] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}
	
	
  	/*
  	 *  醫낇빀�됯�[�뺣웾] - �낅Т�묒“�� 湲곗닠吏�썝�곹깭  議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - �ъ엯�몃젰 �뺥솗��怨꾩궛 
	 */
	private String[][] getEvalVendorCalHumanAccuracyYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanAccuracyYear] [�ъ엯�몃젰 �뺥솗�� 怨꾩궛 START.");
		
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
    					setData[j][87] = vendorScore;										//�됯��먯닔
    					setData[j][85] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][86] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalHumanAccuracyYear] [�ъ엯�몃젰 �뺥솗��] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  醫낇빀�됯�[�뺣웾] - �ъ엯�몃젰 �뺥솗�� 議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] - �낆같�붿껌 ��퉬 �묒같��怨꾩궛 
	 */
	private String[][] getEvalVendorCalBidRateYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBidRateYear] [�낆같�붿껌 ��퉬 �묒같�� 怨꾩궛 START.");
		
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
    					setData[j][83] = vendorScore;										//�됯��먯닔
    					setData[j][81] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][82] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalBidRateYear] [�낆같�붿껌 ��퉬 �묒같��] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  醫낇빀�됯�[�뺣웾] - �낆같�붿껌 ��퉬 �묒같��議고쉶
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
	 * 醫낇빀�됯�[�뺣웾] -  �뺢퇋吏�鍮꾩쑉 怨꾩궛 
	 */
	private String[][] getEvalVendorCalRegularEmpRateYear(ConnectionContext ctx, String[][] setData, String eval_refitem, String evalFactor, String evalWeight) 
	throws Exception  
	{
		String rtn[][] = null;
		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalRegularEmpRateYear] [�뺢퇋吏�鍮꾩쑉] 怨꾩궛 START.");
		
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
    					setData[j][91] = vendorScore;										//�됯��먯닔
    					setData[j][89] = et_getEvalFactorItemInfo(ctx, evalFactor, vendorScore);	//�됯��먯닔���대떦�섎뒗 icomvefd �뚯씠釉붿쓽 e_factor_item_refitem 媛�
    					setData[j][90] = evalWeight;
  	    			}	
    			}
			}
	    	}else{
	    		Logger.debug.println(info.getSession( "ID" ),this, "[getEvalVendorCalRegularEmpRateYear] [�뺢퇋吏�鍮꾩쑉 ] 怨꾩궛���곗씠���놁뒾.");
  	    }
	    		 
	    rtn = setData;
  	    		
		return rtn;
	}

  	/*
  	 *  醫낇빀�됯�[�뺣웾] - �뺢퇋吏�鍮꾩쑉  議고쉶
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
  	 * �뺣웾�됯� 寃곌낵 �됯���ぉ 議고쉶 
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
	
	public SepoaOut getEvaTempDetail(String e_template_refitem) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("e_template_refitem", e_template_refitem);
		
			sxp =  new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	setValue(ssm.doSelect(no));

		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
}