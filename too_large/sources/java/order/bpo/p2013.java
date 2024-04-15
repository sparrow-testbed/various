package order.bpo;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class p2013 extends SepoaService{  
   //Session 정보를 담기위한 변수  

    String  lang                  = "KO";  
    private Message msg = null;  
    private String HOUSE_CODE = info.getSession("HOUSE_CODE");
  
    public p2013(String opt,SepoaInfo info) throws SepoaServiceException  
    {  
        super(opt, info);  
        setVersion("1.0.0");  
  
        //Session 정보 조회  
        msg = new Message(info,"STDPO");  
        
        
        /* private Message msg = new Message("STDPO");
        
        private String lang = info.getSession("LANGUAGE");
        private Message msg_pr = new Message(lang,"STDPR");
        */
    }
	
    public String getConfig(String s)                                                                
   	{                                                                                          
   	    try                                                                                    
   	    {                                                                                      
   	        Configuration configuration = new Configuration();                                 
   	        s = configuration.get(s);                                                          
   	        return s;                                                                          
   	    }                                                                                      
   	    catch(ConfigurationException configurationexception)                                   
   	    {                                                                                      
   	        Logger.sys.println("getConfig error : " + configurationexception.getMessage());  
   	    }                                                                                      
   	    catch(Exception exception)                                                             
   	    {                                                                                      
   	        Logger.sys.println("getConfig error : " + exception.getMessage());               
   	    }                                                                                      
   	    return null;                                                                           
   	}                                                                                  

    /**
	 * 평가생성
	 * @method setPoEval
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-11-14
	 * @modify 2014-11-14
	 */
    public SepoaOut setPoEval(String[] setData) throws Exception{
  		int irow = 0;
  		try{


  			//최종 검수요청일 경우 수행평가 생성.
  			String rtnEvlCode   = "";
  			String sEvalCode    = "";
  			String sEvalId      = "";
  			String evalResult   = "";
  			String sInv_No      = setData[0];
  			String subject      = setData[1];
  			rtnEvlCode          = bl_getEvalCode(sInv_No);
  			SepoaFormater wfevl = new SepoaFormater(rtnEvlCode);
  			
  			if(!(0 == wfevl.getRowCount())){
  				sEvalCode = wfevl.getValue("TEMPLATE_ITEM", 0);	                                //수행평가 템플릿코드
  				sEvalId   = wfevl.getValue("EVAL_ID", 0);		                                //선정평가 코드
  				irow      = setEvalInert(sInv_No, "", subject, "T", sEvalCode, sEvalId);		//평가여부 및 평가생성
  				
  			}else{
  				throw new Exception("평가템플릿을 가져올 수 없습니다.");
  			}
  			
  			evalResult = bl_getEvalResult(sInv_No+"|"+irow);							//평가결과
  			
  			SepoaFormater wfevr = new SepoaFormater(evalResult);
  			
  			String evalResultValue = "";
  			
  			if(!(0 == wfevr.getRowCount())){
  				String EVAL_VALUER_REFITEM = wfevr.getValue("EVAL_VALUER_REFITEM", 0);	
  				String EVAL_ITEM_REFITEM   = wfevr.getValue("EVAL_ITEM_REFITEM", 0);	
  				String EVAL_REFITEM        = wfevr.getValue("EVAL_REFITEM", 0);
  				String E_TEMPLATE_REFITEM  = wfevr.getValue("E_TEMPLATE_REFITEM", 0);
  				String TEMPLATE_TYPE       = wfevr.getValue("TEMPLATE_TYPE", 0);
  				
  				evalResultValue = EVAL_VALUER_REFITEM + "^" + EVAL_ITEM_REFITEM + "^" + EVAL_REFITEM+ "^" + E_TEMPLATE_REFITEM+ "^" + TEMPLATE_TYPE;
  			}
  			
  			Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 완료 [sEvalCode]::"+sEvalCode);
  			Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 완료 [sEvalId]::"+sEvalId);
  				
  			setValue(evalResultValue); 
  			setStatus(irow); 
  			setMessage(msg.getMessage("0000")); 
  			Commit(); 	
  		 } catch(Exception e) {

             Logger.err.println("Exception e =" + e.getMessage());
             setStatus(0);
             Logger.err.println(this,e.getMessage());
         }
  		return getSepoaOut(); 
  	}
    
    
    private String bl_getEvalCode(String inv_no) throws Exception
	{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		Map<String, String> param = new HashMap<String, String>();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			//wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			//wxp.addVar("inv_no", inv_no);
			param.put("inv_no", inv_no);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();

		}catch(Exception e) {
			throw new Exception(this+"bl_getEvalCode:"+e.getMessage());
		} finally {
		}
		return rtn;
	}
  
  private String bl_getEvalResult(String inv_no) throws Exception
 	{
 		String rtn = "";
 		ConnectionContext ctx = getConnectionContext();
 		String house_code = info.getSession("HOUSE_CODE");
 		
 		Map<String, String> param = new HashMap<String, String>();
 		
 		try {

 			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 			//wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 			//wxp.addVar("inv_no", inv_no);
 			param.put("inv_no", inv_no);
 			
 			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
 			rtn = sm.doSelect(param);

 		}catch(Exception e) {
 			throw new Exception(this+"bl_getEvalCode:"+e.getMessage());
 		} finally {
 		}
 		return rtn;
 	}
  
  
  /**
	 * 평가여부 및 평가생성
	 * @method setEvalInert
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-11-17
	 * @modify 2014-11-17
	 */
	 
	public int setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, String template_id,  String eval_id){
		int rtn = 0;
		Map<String, String> param = new HashMap<String, String>();
		param.put("doc_no"                , doc_no     );
		param.put("doc_count"             , doc_count  );
		param.put("eval_name"             , eval_name  );
		param.put("eval_flag"             , eval_flag  );
		param.put("template_id"           , template_id);
		param.put("eval_id"               , eval_id    );
		
		
		try{
			rtn = et_setEvalInert(param);

			setValue(String.valueOf(rtn));
			if(rtn==0){
				Rollback();
				setStatus(0);
				setMessage("평가정보 처리중 오류가 발생하였습니다.");
			}else{
				Commit();
				setStatus(1);
				setMessage("평가정보가 정상적으로 처리되었습니다.");
			}

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage("평가정보 처리중 오류가 발생하였습니다.");
		}
		return rtn;
	}

	 /**
		 * 평가여부 및 평가생성 쿼리
		 * @method et_setEvalInert
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-11-17
		 * @modify 2014-11-17
		 */
	private	int et_setEvalInert(Map<String, String> param) throws Exception
	{
		int rtn =  0;
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

	/*	Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_no]::"+doc_no);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_count]::"+doc_count);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_name]::"+eval_name);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_flag]::"+eval_flag);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [template_id]::"+template_id);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_id]::"+eval_id);*/
		String eval_flag = param.get("eval_flag");
		
		try{
			Integer eval_refitem = 0;
			if(!"N".equals(eval_flag)){	//평가제외가 아닐 경우 평가 생성.
				Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 START");
				String rtn1 =  et_setEvalInsert(param);

		         if("".equals(rtn1)){
		             Rollback();
		             setStatus(0);
		             setMessage(msg.getMessage("9003"));
		             return 0;
		         }

		         eval_refitem = Integer.valueOf(rtn1);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 상태 등록");

//			wxp.addVar("eval_flag", eval_flag);
//			wxp.addVar("eval_refitem", eval_refitem);
//			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
//			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doUpdate(param);
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


	private String et_setEvalInsert(Map<String, String> param) throws Exception
	{
		String returnString = "";
		ConnectionContext ctx = getConnectionContext();

		String user_id 		= info.getSession("ID");
		String house_code 	= info.getSession("HOUSE_CODE");

		int rtnIns         = 0;
		SepoaFormater wf   = null;
		SepoaSQLManager sm = null;
		
		
		
		String template_id = param.get("template_id");
		String eval_id     = param.get("eval_id");
		String evalname    = param.get("evalname");
		String doc_no      = param.get("doc_no");
		String doc_count   = param.get("doc_count");
		

		try
		{
			String auto = "N";
			String evaltemp_num	= template_id;
			String from_date  	= SepoaDate.getShortDateString();
			String to_date  	= SepoaDate.addSepoaDateDay(from_date, 5);
			String flag			= "2"; 	//eval_status[2]

			/*Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 템플릿코드::"+evaltemp_num);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_no]::"+doc_no);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_count]::"+doc_count);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[from_date]::"+from_date);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[to_date]::"+to_date);*/

			//평가자 조회
			String rtn2 = getEvalUser(param);	//getEvalUser(doc_no, doc_count);
			wf =  new SepoaFormater(rtn2);
			String[] eval_user_id = new String[wf.getRowCount()];
			String[] eval_user_dept = new String[wf.getRowCount()];
			for(int	i=0; i<wf.getRowCount(); i++) {
				eval_user_id[i] = wf.getValue("PROJECT_PM", i);
				eval_user_dept[i] = wf.getValue("PROJECT_DEPT", i);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자::"+eval_user_id[i]);
			}

			String eval = getConfig("sepoa.eval.human");

			String setData[][] = null;
			String rtn3 = "";
			if(eval.equals(eval_id)){
				//평가업체, 개발자 조회
				rtn3 = getEvalCompanyHuman(param);
				wf =  new SepoaFormater(rtn3);

				setData = new String[wf.getRowCount()*eval_user_id.length][];
				int kk=0;
				for(int	i=0; i<wf.getRowCount(); i++) {
					for(int j=0; j<eval_user_id.length; j++){
						Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i) + ",개발자::"+wf.getValue("HUMAN_NO", i));
						String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0", eval_user_id[j], eval_user_dept[j], wf.getValue("HUMAN_NO", i)};
						setData[kk] = Data;
						kk++;
					}
				}
			}else{
				//평가업체 조회
				rtn3 = getEvalCompany(param);
				wf =  new SepoaFormater(rtn3);

				setData = new String[wf.getRowCount()*eval_user_id.length][];
				int kk=0;
				for(int	i=0; i<wf.getRowCount(); i++) {
					for(int j=0; j<eval_user_id.length; j++){
						Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i));
						String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0", eval_user_id[j], eval_user_dept[j], ""};
						setData[kk] = Data;
						kk++;
					}
				}
			}

			//평가마스터 일련번호 조회
  		SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_0");
			wxp.addVar("house_code", house_code);
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	    	String rtn = sm.doSelect();
	    	wf =  new SepoaFormater(rtn);

	    	String max_eval_refitem = "";
	    	if(wf != null && wf.getRowCount() > 0) {
	    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
			}

			//평가테이블 생성 - ADD( 견적[RQ]/입찰[BD]/역경매[RA] 구분, 문서번호, 문서SEQ 등록)
	    	SepoaXmlParser wxp_1 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_1");

	    	Map<String, String> paramVal = new HashMap<String, String>();
	    	paramVal.put("max_eval_refitem" , max_eval_refitem );
	    	paramVal.put("evalname"         , evalname         );
	    	paramVal.put("flag"             , flag             );
	    	paramVal.put("evaltemp_num"     , evaltemp_num     );
	    	paramVal.put("fromdate"         , from_date         );
	    	paramVal.put("todate"           , to_date           );
	    	paramVal.put("auto"             , auto             );
	    	paramVal.put("user_id"          , user_id          );
	    	paramVal.put("doc_type"         , "PO"         );
	    	paramVal.put("doc_no"           , doc_no           );
	    	paramVal.put("doc_count"        , doc_count        );
	    	
	    	/*wxp_1.addVar("house_code", house_code);
	    	wxp_1.addVar("max_eval_refitem", max_eval_refitem);
	    	wxp_1.addVar("evalname"           , eval_name);
	    	wxp_1.addVar("flag"               , flag);
	    	wxp_1.addVar("evaltemp_num"        , evaltemp_num);
	    	wxp_1.addVar("fromdate"              , from_date);
	    	wxp_1.addVar("todate"              , to_date);
	    	wxp_1.addVar("auto"              , auto);
	    	wxp_1.addVar("user_id"            , user_id);
	    	wxp_1.addVar("DOC_TYPE"             , "PO");	//발주
	    	wxp_1.addVar("DOC_NO"                ,  doc_no);
	    	wxp_1.addVar("DOC_COUNT"            , doc_count);*/
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
			rtnIns = sm.doInsert(paramVal);
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가마스터 정보 저장 끝");

			String i_sg_refitem = "";
			String i_vendor_code = "";
			String i_value_id = "";
			String i_value_dept = "";
			String i_human_no = "";

			//평가대상업체 테이블 생성
			SepoaXmlParser wxp_2 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_2_1");
			Map<String, String> param_2 = new HashMap<String, String>(); 
			//평가대상업체 평가자 테이블 생성
			SepoaXmlParser wxp_3 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_3");
			Map<String, String> param_3 = new HashMap<String, String>(); 

			for ( int i = 0; i < setData.length; i++ )
			{
				i_vendor_code 	= setData[i][0];
				i_sg_refitem 	= setData[i][2];
				i_value_id 		= setData[i][3];
				i_value_dept 	= setData[i][4];
				i_human_no 		= setData[i][5];

				//평가대상업체 테이블 생성
				/*wxp_2.addVar("house_code", house_code);
				wxp_2.addVar("i_sg_refitem", i_sg_refitem);
				wxp_2.addVar("i_vendor_code", i_vendor_code);
				wxp_2.addVar("max_eval_refitem", max_eval_refitem);
				wxp_2.addVar("i_human_no", i_human_no);*/
				param_2.put("house_code",       house_code);
				param_2.put("i_sg_refitem",     i_sg_refitem);
				param_2.put("i_vendor_code",    i_vendor_code);
				param_2.put("max_eval_refitem", max_eval_refitem);
				param_2.put("i_human_no",       i_human_no);
				
				

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
				rtnIns = sm.doInsert(param_2);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 정보 저장 끝");

				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 ::"+i_value_id);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 부서 ::"+i_value_dept);

				String i_dept = "";
				String i_id = "";

				//평가대상업체 평가자 테이블 생성
				/*wxp_3.addVar("house_code", house_code);
				wxp_3.addVar("i_dept", i_value_dept);
				wxp_3.addVar("i_id", i_value_id);
				wxp_3.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));*/
				
				param_3.put("house_code", house_code);
				param_3.put("i_dept",     i_value_dept);
				param_3.put("i_id",       i_value_id);
				param_3.put("getCurrVal", String.valueOf(getCurrVal("icomvevd", "eval_item_refitem")));

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
				rtnIns = sm.doInsert(param_3);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가 평가자 정보 저장 끝");

				//평가일련번호를 리턴해 줌.
				returnString = max_eval_refitem;
			}

			//Commit();
		} catch( Exception e ) {
			Rollback();
			Logger.err.println(this, "Error ::"+e.getMessage());
			returnString = "";
		} finally { }

		return returnString;
	}
	
	public String getEvalUser(Map<String, String> param){
		String rtn = null;
		try{
			rtn = et_getEvalUser(param);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalUser(Map<String, String> param) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
//			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
//			wxp.addVar("doc_no", doc_no);
			
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(param);
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	
	
	 //* 평가 대상업체, 개발자 가져오기
	 //* 2010.07.
	 
	public String getEvalCompanyHuman(Map<String, String> param){
		String rtn = null;
		try{
			rtn = et_getEvalCompanyHuman(param);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalCompanyHuman(Map<String, String> param) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
//			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
//			wxp.addVar("doc_no", doc_no);

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(param);
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	
	 //* 평가 대상업체 가져오기
	 //* 2010.07.
	 
	public String getEvalCompany(Map<String, String> param){
		String rtn = null;
		try{
			rtn = et_getEvalCompany(param);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalCompany(Map<String, String> param) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
//			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
//			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(param);
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
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
		
					SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080","currvalForMssql");
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
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
 /* public SepoaOut getPoList(String[] args, String po_status, String confirm_flag, String cont_status, String complete_mark)
	{
		try {

			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getPoList(args, po_status, confirm_flag, cont_status, complete_mark);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
		else {
			setMessage(msg.getMessage("7000"));
		}

			setStatus(1);
			setValue(rtnHD);

		}catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}


  private String bl_getPoList(String[] args, String po_status, String confirm_flag, String cont_status, String complete_mark) throws Exception
	{
		/////////////////////// 직무 코드 관련 처리
		//String cur_ctrl_code = DoWorkWithCtrl_code(ctrl_code);

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("HOUSE_CODE",		HOUSE_CODE);
			wxp.addVar("po_status",		po_status);
			wxp.addVar("confirm_flag",	confirm_flag);
			wxp.addVar("cont_status",	cont_status);
			wxp.addVar("complete_mark",	complete_mark);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doSelect(args);

		}catch(Exception e) {
			throw new Exception("bl_getPoList:"+e.getMessage());
		} finally {
		}
		return rtn;
	}
  
 
  public SepoaOut setPoDelete(String[][] setPoData, String delPOno) throws ConfigurationException
  {
      Configuration sepoa_conf = new Configuration();
      boolean po_contract_use_flag = false;
      try {
      	po_contract_use_flag = sepoa_conf.getBoolean("sepoa.po.contract.use."+info.getSession("HOUSE_CODE")); //발주서계약 사용여부
      } catch (Exception e) {
      	po_contract_use_flag = false;
      }
      try {
          String user_id      = info.getSession("ID");
          String house_code   = info.getSession("HOUSE_CODE");
          String po_no 		= "";
          String podtString 	= "";
          String[] erpPo_result  = new String[2];
          //Logger.debug.println(this, "setPoDelete setPoData.length " + setPoData.length);
          String[][] setEcData = new String[setPoData.length][];
          for (int i = 0; i < setPoData.length; i++)
          {
          	po_no 		= setPoData[i][4];
              podtString 	= deletePODTList(po_no, house_code, user_id);
              
              String[] poData = {po_no, po_no};
              setEcData[i] = poData;
              
              SepoaFormater wf = new SepoaFormater(podtString);
              
              String[] purchase_location = wf.getValue("PURCHASE_LOCATION");
              String[] company_code      = wf.getValue("COMPANY_CODE");
              String[] pr_no             = wf.getValue("PR_NO");
              String[] pr_seq            = wf.getValue("PR_SEQ");
              String[] item_no           = wf.getValue("ITEM_NO");
              String[] po_seq            = wf.getValue("PO_SEQ");
              String[] vendor_code       = wf.getValue("VENDOR_CODE");
              String[] item_qty          = wf.getValue("ITEM_QTY");
              
              String drData[][]    = new String[wf.getRowCount()][];
              String prData[][]    = new String[wf.getRowCount()][];
              
              for (int j = 0; j<wf.getRowCount(); j++) {
                  String pData[] = {house_code, pr_no[j], pr_seq[j]};
                  prData[j] = pData;
                  String Data[] = {house_code
                  				,po_no
                  				,po_seq[j]
                  				,item_no[j]
                  				,purchase_location[j]
                  				,house_code
                  				,company_code[j]
                  				,purchase_location[j]
                  				,item_no[j]
                  				,vendor_code[j]};
                  drData[j] = Data;
              }
              int rtn_pr = up_icoyprdt(prData, user_id);
              int rtn_dr = del_ICOYPODR(drData, user_id);
              
              // I / F 발주
              ERPInterface erpIF = new ERPInterface("CONNECTION",info);
              erpPo_result = erpIF.erpPOInsert(getERPPOList(po_no),"D");
              
  			if(erpPo_result[0].equals("2")){
	    			break;
  			}
          }
			int rtn_dt = del_ICOYPODT(setPoData);
          int rtn_hd = del_ICOYPOHD(setPoData);
          // 2011.09.02 HMCHOI : 발주서 삭제 후 계약서 폐기
          if (po_contract_use_flag) {
          	int rtn_eh = del_ICOYECCT(setEcData);
          }
          
          if(!erpPo_result[0].equals("2")){
          	Commit();       
              setStatus(1);
              msg.setArg("po_no",delPOno);
              setMessage(msg.getMessage("9000"));
			}else{
				Rollback();
				setStatus(0);
				setMessage(erpPo_result[1]);
			}
          
      }catch(Exception e) {
          Logger.err.println("Exception e =" + e.getMessage());
          Logger.err.println("Exception e =" + e.getMessage());
          try {
              Rollback();
          } catch(Exception d) {
              Logger.err.println(userid,this,d.getMessage());
          }
          setValue(e.getMessage().trim());
          setStatus(0);
          setMessage(e.getMessage().trim());
      }
      return getSepoaOut();
  }

	private SepoaFormater getERPPOList(String po_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("po_no", po_no);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect());	

		}catch (Exception e) {
			throw new Exception("getERPPOList : " + e.getMessage());
		} finally {
		}
		return wf;
	}

  public SepoaOut CallNONDBJOB(ConnectionContext ctx, String serviceId, String MethodName, Object[] obj )
	{
		String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB

		SepoaOut value = null;
		SepoaRemote wr	= null;

		//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
		try
		{

			wr = new SepoaRemote( serviceId, conType, info	);
			wr.setConnection(ctx);

			value =	wr.lookup( MethodName, obj );

		}catch(	SepoaServiceException wse ) {
			try{
				Logger.err.println("wse	= "	+ wse.getMessage());
				Logger.err.println("message	= "	+ value.message);
				Logger.err.println("status = " + value.status);				
			}catch(NullPointerException ne){
      		ne.printStackTrace();
      	}

		}catch(Exception e)	{
			try{
				Logger.err.println("err	= "	+ e.getMessage());
				Logger.err.println("message	= "	+ value.message);
				Logger.err.println("status = " + value.status);				
			}catch(NullPointerException ne){
      		ne.printStackTrace();
      	}

		}

		return value;
	}


  private String deletePODTList(String po_no, String house_code, String user_id ) throws Exception
  {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append("     SELECT PURCHASE_LOCATION,COMPANY_CODE,PR_NO,PR_SEQ,ITEM_NO, PO_NO, PO_SEQ, VENDOR_CODE, ITEM_QTY   \n");
//			tSQL.append("     FROM ICOYPODT                                                                                      \n");
//			tSQL.append("     WHERE STATUS <> 'D'                                                                                \n");
//			tSQL.append("     <OPT=S,S>  AND HOUSE_CODE = ? </OPT>                                                               \n");
//			tSQL.append("     <OPT=S,S>  AND PO_NO      = ? </OPT>                                                               \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

			String[] Data = {house_code, po_no};
			rtn = sm.doSelect(Data);

		}catch(Exception e) {
			throw new Exception("deletePODTList:"+e.getMessage());
		} finally {
		}
		return rtn;
	}

  private int up_icoyprdt(String[][] prData, String user_id) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append(" UPDATE ICOYPRDT SET             \n");
//			tSQL.append("        PR_PROCEEDING_FLAG = 'B' \n");
//			tSQL.append(" WHERE  HOUSE_CODE      = ?      \n");
//			tSQL.append(" AND    PR_NO           = ?      \n");
//			tSQL.append(" AND    PR_SEQ          = ?      \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

			String[] type = {"S","S","S"};
			rtn = sm.doInsert(prData, type);
		}catch(Exception e) {
			throw new Exception("up_icoyprdt:"+e.getMessage());
		} finally{
		}
		return rtn;
	}

  private int del_ICOYPODR(String[][] drData, String user_id) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append(" UPDATE ICOYINDR SET                                                           \n");
//			tSQL.append("        CUM_PO_QTY = ISNULL(CUM_PO_QTY,0) - ISNULL((SELECT ISNULL(ITEM_QTY,0)           \n");
//			tSQL.append("                                              FROM ICOYPODT                    \n");
//			tSQL.append("                                              WHERE HOUSE_CODE        = ?      \n");
//			tSQL.append("                                                AND PO_NO             = ?      \n");
//			tSQL.append("                                                AND PO_SEQ            = ?      \n");
//			tSQL.append("                                                AND ITEM_NO           = ?      \n");
//			tSQL.append("                                                AND PURCHASE_LOCATION = ?),0)  \n");
//			tSQL.append(" WHERE STATUS <> 'D'                                                           \n");
//			tSQL.append("   AND HOUSE_CODE        = ?                                                   \n");
//			tSQL.append("   AND PURCHASE_LOCATION = ?                                                   \n");
//			tSQL.append("   AND ITEM_NO           = ?                                                   \n");
//			tSQL.append("   AND VENDOR_CODE       = ?                                                   \n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

			String[] type = {"S","S","S","S","S"
				        ,"S","S","S","S","S"};

			rtn = sm.doInsert(drData, type);
		} catch(Exception e) {
			throw new Exception("del_ICOYPODR:"+e.getMessage());
		} finally{
		}
		return rtn;
	}

  private int del_ICOYPODT(String[][] setData) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append(" UPDATE ICOYPODT SET                   \n");
//			tSQL.append("         STATUS                 = 'D'  \n");
//			tSQL.append("        ,CHANGE_DATE            = ?    \n");
//			tSQL.append("        ,CHANGE_TIME            = ?    \n");
//			tSQL.append("        ,CHANGE_USER_ID         = ?    \n");
//			tSQL.append(" WHERE HOUSE_CODE               = ?    \n");
//			tSQL.append("   AND PO_NO                    = ?    \n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			String[] type = {"S", "S", "S", "S", "S"};

			rtn = sm.doInsert(setData, type);
		} catch(Exception e) {
			throw new Exception("del_ICOYPODT:"+e.getMessage());
		} finally{
		}
		return rtn;
	}

  private int del_ICOYPOHD(String[][] setData) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append(" UPDATE ICOYPOHD SET                   \n");
//			tSQL.append("         STATUS                 = 'D'  \n");
//			tSQL.append("        ,CHANGE_DATE            = ?    \n");
//			tSQL.append("        ,CHANGE_TIME            = ?    \n");
//			tSQL.append("        ,CHANGE_USER_ID         = ?    \n");
//			tSQL.append(" WHERE HOUSE_CODE               = ?    \n");
//			tSQL.append("   AND PO_NO                    = ?    \n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			String[] type = {"S", "S", "S", "S", "S"};

			rtn = sm.doInsert(setData, type);
		} catch(Exception e) {
			throw new Exception("del_ICOYPOHD:"+e.getMessage());
		} finally{
		}
		return rtn;
	}
  
  *//**
   * 2011.09.02 HMCHOI
   * 발주서 계약인 경우 발주서 삭제 후 해당 계약서는 폐기처리분한다. 
   * @param setData
   * @return
   * @throws Exception
   *//*
  private int del_ICOYECCT(String[][] setData) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
			*//**
			 *	UPDATE ICOYECCT 
			 *	       SET STATUS = 'DD' 
			 *	 WHERE BID_NO = 'PO110405001' 
			 *	       AND CONT_COUNT = 
			 *	       (SELECT MAX (CONT_COUNT) 
			 *	         FROM ICOYECCT 
			 *	        WHERE BID_NO = 'PO110405001' 
			 *	       )
			 *//*
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type = {"S", "S"};

			rtn = sm.doInsert(setData, type);
		} catch(Exception e) {
			throw new Exception("del_ICOYECCT:"+e.getMessage());
		} finally{
		}
		return rtn;
	}
  
  public SepoaOut setPoCompleteMark(String[][] setPohdData, String[][] setPodtData, String delPOno){
      try {

          int rtn = -1;
          ConnectionContext ctx = getConnectionContext();

          SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

//          sql.append(" UPDATE ICOYPOHD                   \n");
//          sql.append(" SET  COMPLETE_MARK    = 'Y'       \n");
//          sql.append("     ,CHANGE_DATE      = ?         \n");
//          sql.append("     ,CHANGE_TIME      = ?         \n");
//          sql.append("     ,CHANGE_USER_ID   = ?         \n");
//          sql.append("     ,STATUS           = 'R'       \n");
//          sql.append(" WHERE HOUSE_CODE      = ?         \n");
//          sql.append(" AND   PO_NO           = ?         \n");

          SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

          String[] type_hd = {"S","S","S","S","S"};
          rtn = sm.doInsert(setPohdData, type_hd);

          wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

//          sql.append(" UPDATE ICOYPODT                   \n");
//          sql.append(" SET  COMPLETE_GR_MARK = 'Y'       \n");
//          sql.append("     ,CHANGE_DATE      = ?         \n");
//          sql.append("     ,CHANGE_TIME      = ?         \n");
//          sql.append("     ,CHANGE_USER_ID   = ?         \n");
//          sql.append("     ,STATUS           = 'R'       \n");
//          sql.append(" WHERE HOUSE_CODE      = ?         \n");
//          sql.append(" AND   PO_NO           = ?         \n");

          sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

          String[] type_dt = {"S","S","S","S","S"};
          rtn = sm.doInsert(setPodtData, type_dt);

          Commit();

          setStatus(1);
          msg.setArg("po_no",delPOno);
          setMessage(msg.getMessage("9061"));
      }catch(Exception e)
      {
          Logger.err.println("Exception e =" + e.getMessage());
          try {
              Rollback();
          } catch(Exception d) {
              Logger.err.println(info.getSession("ID"),this,d.getMessage());
          }
          setStatus(0);
          setMessage(msg.getMessage("9062"));
          Logger.err.println(this,e.getMessage());
      }
      return getSepoaOut();
  }
  
  public SepoaOut setPoEval(String[] setData){
		int irow = 0;
		try{


			//최종 검수요청일 경우 수행평가 생성.
			String rtnEvlCode = "";
			String sEvalCode = "";
			String sEvalId = "";
			String evalResult = "";
			String sInv_No = setData[0];
			rtnEvlCode = bl_getEvalCode(sInv_No);
			SepoaFormater wfevl = new SepoaFormater(rtnEvlCode);
			
			if(!(0 == wfevl.getRowCount())){
				sEvalCode = wfevl.getValue("TEMPLATE_ITEM", 0);	//수행평가 템플릿코드
				sEvalId = wfevl.getValue("EVAL_ID", 0);		//선정평가 코드
				irow = setEvalInert(sInv_No, "", setData[1], "T", sEvalCode, sEvalId);
				
			}else{
				throw new Exception("평가템플릿을 가져올 수 없습니다.");
			}
			
			evalResult = bl_getEvalResult(sInv_No);
			SepoaFormater wfevr = new SepoaFormater(evalResult);
			
			String evalResultValue = "";
			
			if(!(0 == wfevr.getRowCount())){
				String EVAL_VALUER_REFITEM = wfevr.getValue("EVAL_VALUER_REFITEM", 0);	
				String EVAL_ITEM_REFITEM = wfevr.getValue("EVAL_ITEM_REFITEM", 0);	
				String EVAL_REFITEM = wfevr.getValue("EVAL_REFITEM", 0);
				String E_TEMPLATE_REFITEM = wfevr.getValue("E_TEMPLATE_REFITEM", 0);
				String TEMPLATE_TYPE = wfevr.getValue("TEMPLATE_TYPE", 0);
				
				evalResultValue = EVAL_VALUER_REFITEM + "^" + EVAL_ITEM_REFITEM + "^" + EVAL_REFITEM+ "^" + E_TEMPLATE_REFITEM+ "^" + TEMPLATE_TYPE;
			}
			
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 완료 [sEvalCode]::"+sEvalCode);
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 완료 [sEvalId]::"+sEvalId);
				
			setValue(evalResultValue); 
			setStatus(irow); 
			setMessage(msg.getMessage("0000")); 
			Commit(); 	
		 } catch(Exception e) {

           Logger.err.println("Exception e =" + e.getMessage());
           setStatus(0);
           Logger.err.println(this,e.getMessage());
       }
		return getSepoaOut(); 
	}
  
  private String bl_getEvalCode(String inv_no) throws Exception
	{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("inv_no", inv_no);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn = sm.doSelect();

		}catch(Exception e) {
			throw new Exception(this+"bl_getEvalCode:"+e.getMessage());
		} finally {
		}
		return rtn;
	}
  
  private String bl_getEvalResult(String inv_no) throws Exception
 	{

 		String rtn = "";
 		ConnectionContext ctx = getConnectionContext();
 		String house_code = info.getSession("HOUSE_CODE");
 		try {

 			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 			wxp.addVar("inv_no", inv_no);

 			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
 			rtn = sm.doSelect();

 		}catch(Exception e) {
 			throw new Exception(this+"bl_getEvalCode:"+e.getMessage());
 		} finally {
 		}
 		return rtn;
 	}
  
  
	 * 평가 여부  및 평가 생성
	 * 2010.07.
	 
	public int setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, String template_id,  String eval_id){
		int rtn = 0;

		try{
			rtn = et_setEvalInert(doc_no, doc_count, eval_name, eval_flag, template_id, eval_id);

			setValue(String.valueOf(rtn));
			if(rtn==0){
				Rollback();
				setStatus(0);
				setMessage("평가정보 처리중 오류가 발생하였습니다.");
			}else{
				Commit();
				setStatus(1);
				setMessage("평가정보가 정상적으로 처리되었습니다.");
			}

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage("평가정보 처리중 오류가 발생하였습니다.");
		}
		return rtn;
	}


	private	int et_setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, String template_id, String eval_id) throws Exception
	{
		int rtn =  0;
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_no]::"+doc_no);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_count]::"+doc_count);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_name]::"+eval_name);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_flag]::"+eval_flag);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [template_id]::"+template_id);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_id]::"+eval_id);

		try{
			Integer eval_refitem = 0;
			if(!"N".equals(eval_flag)){	//평가제외가 아닐 경우 평가 생성.
				Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 START");
				String rtn1 =  et_setEvalInsert(doc_no, doc_count, eval_name, template_id, eval_id);

		         if("".equals(rtn1)){
		             Rollback();
		             setStatus(0);
		             setMessage(msg.getMessage("9003"));
		             return 0;
		         }

		         eval_refitem = Integer.valueOf(rtn1);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 상태 등록");

			wxp.addVar("eval_flag", eval_flag);
			wxp.addVar("eval_refitem", eval_refitem);
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doUpdate();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


	private String et_setEvalInsert(String doc_no, String doc_count, String eval_name, String template_id, String eval_id) throws Exception
	{
		String returnString = "";
		ConnectionContext ctx = getConnectionContext();

		String user_id 		= info.getSession("ID");
		String house_code 	= info.getSession("HOUSE_CODE");

		int rtnIns = 0;
		SepoaFormater wf = null;
		SepoaSQLManager sm = null;

		try
		{
			String auto = "N";
			String evaltemp_num	= template_id;
			String from_date  	= SepoaDate.getShortDateString();
			String to_date  	= SepoaDate.addSepoaDateDay(from_date, 5);
			String flag			= "2"; 	//eval_status[2]

			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 템플릿코드::"+evaltemp_num);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_no]::"+doc_no);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_count]::"+doc_count);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[from_date]::"+from_date);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[to_date]::"+to_date);

			//평가자 조회
			String rtn2 = getEvalUser(doc_no, doc_count);
			wf =  new SepoaFormater(rtn2);
			String[] eval_user_id = new String[wf.getRowCount()];
			String[] eval_user_dept = new String[wf.getRowCount()];
			for(int	i=0; i<wf.getRowCount(); i++) {
				eval_user_id[i] = wf.getValue("PROJECT_PM", i);
				eval_user_dept[i] = wf.getValue("PROJECT_DEPT", i);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자::"+eval_user_id[i]);
			}

			String eval = getConfig("sepoa.eval.human");

			String setData[][] = null;
			String rtn3 = "";
			if(eval.equals(eval_id)){
				//평가업체, 개발자 조회
				rtn3 = getEvalCompanyHuman(doc_no, doc_count);
				wf =  new SepoaFormater(rtn3);

				setData = new String[wf.getRowCount()*eval_user_id.length][];
				int kk=0;
				for(int	i=0; i<wf.getRowCount(); i++) {
					for(int j=0; j<eval_user_id.length; j++){
						Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i) + ",개발자::"+wf.getValue("HUMAN_NO", i));
						String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0", eval_user_id[j], eval_user_dept[j], wf.getValue("HUMAN_NO", i)};
						setData[kk] = Data;
						kk++;
					}
				}
			}else{
				//평가업체 조회
				rtn3 = getEvalCompany(doc_no, doc_count);
				wf =  new SepoaFormater(rtn3);

				setData = new String[wf.getRowCount()*eval_user_id.length][];
				int kk=0;
				for(int	i=0; i<wf.getRowCount(); i++) {
					for(int j=0; j<eval_user_id.length; j++){
						Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가업체::"+wf.getValue("VENDOR_CODE", i));
						String Data[] = { wf.getValue("VENDOR_CODE", i), "N", "0", eval_user_id[j], eval_user_dept[j], ""};
						setData[kk] = Data;
						kk++;
					}
				}
			}

			//평가마스터 일련번호 조회
  		SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_0");
			wxp.addVar("house_code", house_code);
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	    	String rtn = sm.doSelect();
	    	wf =  new SepoaFormater(rtn);

	    	String max_eval_refitem = "";
	    	if(wf != null && wf.getRowCount() > 0) {
	    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
			}

			//평가테이블 생성 - ADD( 견적[RQ]/입찰[BD]/역경매[RA] 구분, 문서번호, 문서SEQ 등록)
	    	SepoaXmlParser wxp_1 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_1");
	    	wxp_1.addVar("house_code", house_code);
	    	wxp_1.addVar("max_eval_refitem", max_eval_refitem);
	    	wxp_1.addVar("evalname", eval_name);
	    	wxp_1.addVar("flag", flag);
	    	wxp_1.addVar("evaltemp_num", evaltemp_num);
	    	wxp_1.addVar("fromdate", from_date);
	    	wxp_1.addVar("todate", to_date);
	    	wxp_1.addVar("auto", auto);
	    	wxp_1.addVar("user_id", user_id);
	    	wxp_1.addVar("DOC_TYPE", "PO");	//발주
	    	wxp_1.addVar("DOC_NO", doc_no);
	    	wxp_1.addVar("DOC_COUNT", doc_count);
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_1.getQuery() );
			rtnIns = sm.doInsert();
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가마스터 정보 저장 끝");

			String i_sg_refitem = "";
			String i_vendor_code = "";
			String i_value_id = "";
			String i_value_dept = "";
			String i_human_no = "";

			//평가대상업체 테이블 생성
			SepoaXmlParser wxp_2 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_2_1");

			//평가대상업체 평가자 테이블 생성
			SepoaXmlParser wxp_3 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_3");

			for ( int i = 0; i < setData.length; i++ )
			{
				i_sg_refitem 	= setData[i][2];
				i_vendor_code 	= setData[i][0];
				i_value_id 		= setData[i][3];
				i_value_dept 	= setData[i][4];
				i_human_no 		= setData[i][5];

				//평가대상업체 테이블 생성
				wxp_2.addVar("house_code", house_code);
				wxp_2.addVar("i_sg_refitem", i_sg_refitem);
				wxp_2.addVar("i_vendor_code", i_vendor_code);
				wxp_2.addVar("max_eval_refitem", max_eval_refitem);
				wxp_2.addVar("i_human_no", i_human_no);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_2.getQuery() );
				rtnIns = sm.doInsert();
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 정보 저장 끝");

				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 ::"+i_value_id);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 부서 ::"+i_value_dept);

				String i_dept = "";
				String i_id = "";

				//평가대상업체 평가자 테이블 생성
				wxp_3.addVar("house_code", house_code);
				wxp_3.addVar("i_dept", i_value_dept);
				wxp_3.addVar("i_id", i_value_id);
				wxp_3.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_3.getQuery() );
				rtnIns = sm.doInsert();
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가 평가자 정보 저장 끝");

				//평가일련번호를 리턴해 줌.
				returnString = max_eval_refitem;
			}

			//Commit();
		} catch( Exception e ) {
			Rollback();
			Logger.err.println(this, "Error ::"+e.getMessage());
			returnString = "";
		} finally { }

		return returnString;
	}
	
	public String getEvalUser(String doc_no, String doc_count){
		String rtn = null;
		try{
			rtn = et_getEvalUser(doc_no, doc_count);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalUser(String doc_no, String doc_count) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	
	 * 평가 대상업체, 개발자 가져오기
	 * 2010.07.
	 
	public String getEvalCompanyHuman(String doc_no, String doc_count){
		String rtn = null;
		try{
			rtn = et_getEvalCompanyHuman(doc_no, doc_count);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalCompanyHuman(String doc_no, String doc_count) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	
	 * 평가 대상업체 가져오기
	 * 2010.07.
	 
	public String getEvalCompany(String doc_no, String doc_count){
		String rtn = null;
		try{
			rtn = et_getEvalCompany(doc_no, doc_count);

		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0005"));
		}
		return rtn;
	}


	private	String et_getEvalCompany(String doc_no, String doc_count) throws Exception
	{


		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("doc_no", doc_no);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect();
		}catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	public double getCurrVal(String tableName, String columnName){
  	double currVal = 0;
	    SepoaOut wo = currvalForMssql(tableName, columnName);
	    try{
	  	    SepoaFormater wf2 = new SepoaFormater(wo.result[0]);
	  	    currVal = Double.parseDouble((wf2.getValue("CURRVAL",0)));
	    } catch(Exception e){

	    }
  	return currVal;
	 }
	
	public SepoaOut currvalForMssql(String tableName, String columnName){
	
	     try{
	          String rtn = "";
	  		ConnectionContext ctx = getConnectionContext();
	  		String house_code = info.getSession("HOUSE_CODE");
	  		String user_id = info.getSession("ID");
	
				SepoaXmlParser wxp =  new SepoaXmlParser("master/evaluation/p0080","currvalForMssql");
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
	}*/
	 
/*****************************************************************/
} // END
