package supply.bidding.so;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
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
import ucMessage.UcMessage;

public class s2041 extends SepoaService {
	//Session 정보를 담기위한 변수  
		String status =	"";   
		
		private	String lang	= info.getSession("LANGUAGE");  
		private	Message	msg; 
	   
		public s2041(String	opt,SepoaInfo info) throws SepoaServiceException  
		{  
			 super(opt,info);
		     setVersion("1.0.0");
		     msg = new Message(info,"STDSO");
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
		 * 공급업체별 실사요청현황 조회
		 * @method getOsqReqList
		 * @param  header : start_date, end_date,	status,   bid_osq_type,  create_type
		 * @return SepoaOut
		 * @throws Exception
		 * @desc   
		 * @since  2014-11-07
		 * @modify 2014-11-07
		 */
		public SepoaOut getOsqReqList(Map<String, String> header) {  
			try	{  
				String rtn = "";  
	  
				//지명, 공개 모두 조회 & 실사서 제출 가능하게 변경함.
				rtn	= et_getOsqReqList(header);  
					
				setValue(rtn);  
				setStatus(1);  
	  
			}catch (Exception e){  
				Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage());  
				setMessage(msg.getMessage("0001"));  
				setStatus(0);  
			}  
			return getSepoaOut();  
		}  
	  
		/**
		 * 공급업체별 실사요청현황 조회 쿼리
		 * @method et_getOsqReqList
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   
		 * @since  2014-11-07
		 * @modify 2014-11-07
		 */
		private	String et_getOsqReqList(Map<String, String> header ) throws	Exception  
		{  
			
			
			String rtn = "";  
			ConnectionContext ctx =	getConnectionContext();  
			String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
			
			try	{  
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				header.put("cur_date_time", cur_date_time);
				wxp.addVar("osq_flag"     , header.get("osq_flag"));
				
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				rtn	= sm.doSelect(header);  
	  
				if(rtn == null)	throw new Exception("SQL Manager is	Null");  
			}catch(Exception e)	{  
			  throw	new	Exception("et_getOsqReqList=========>"+e.getMessage());  
			} finally{  
			}  
			return rtn;  
		}

		 /**
	     * 실사요청서 HD 조회
	     * @method getOsqReqHeader
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */  
  	  public SepoaOut getOsqReqHeader(String OSQ_NO,String OSQ_COUNT,String VENDOR_CODE)  
      {  
          try {  
              String rtn = "";  
    
              rtn = et_getOsqReqHeader(OSQ_NO, OSQ_COUNT, VENDOR_CODE);  
    
              setValue(rtn);  
              setStatus(1);  
          }catch (Exception e){  
              //Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
              setStatus(0);  
          }  
          return getSepoaOut();  
      }  
    
      private String et_getOsqReqHeader(String OSQ_NO,String OSQ_COUNT,String VENDOR_CODE) throws Exception  
      {  

          String rtn = "";  
          Map<String, String> param = new HashMap<String, String>();
    
          ConnectionContext ctx = getConnectionContext();  
          try {  
          		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
          		wxp.addVar("VENDOR_CODE", info.getSession("COMPANY_CODE"));
                  SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
    
                  //String[] args = {VENDOR_CODE, info.getSession("HOUSE_CODE"), OSQ_NO, OSQ_COUNT};  
                  param.put("vendor_code", 	VENDOR_CODE);
                  param.put("osq_no", 		OSQ_NO);
                  param.put("osq_count", 	OSQ_COUNT);
                  
                  rtn = sm.doSelect(param);  
    
                  if(rtn == null) throw new Exception("SQL Manager is Null");  
              }catch(Exception e) {  
                  throw new Exception("et_getOsqReqHeader=========>"+e.getMessage());  
              } finally{  
          }  
          return rtn;  
      }	    
    
      /**
       * 실사서 등록 품목 조회
       * @method getSoslnList
       * @since  2014-10-08
       * @modify 2014-10-08
       * @param header
       * @return Map
       * @throws Exception
       */
      public SepoaOut getSoslnList(Map<String, String> header) throws Exception  
      {  
      	ConnectionContext ctx                   = getConnectionContext();
  		SepoaXmlParser    sxp                   = null;
  		SepoaSQLManager   ssm                   = null;
  		String            rtn                   = null;
  		String            id                    = info.getSession("ID");
  		
  		try{
  			
  			setStatus(1);
  			setFlag(true);
  			
  			sxp = new SepoaXmlParser(this, "getSoslnList");
  			sxp.addVar("language", info.getSession("LANGUAGE"));
          	ssm = new SepoaSQLManager(id, this, ctx, sxp);
          	sxp.addVar("group_yn", 		header.get("group_yn"));
          	sxp.addVar("vendor_code", 	header.get("st_vendor_code"));
          	
          	rtn = ssm.doSelect(header);
          	setValue(rtn);
  		}
  		catch(Exception e) {
  			Logger.err.println(userid, this, e.getMessage());
  			setStatus(0);
  			setMessage(msg.getMessage("0001"));
  		}
  		
  		return getSepoaOut();
      }
      
      
  	//OSLN테이블 삭제
  	private int OSLNDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
  		SepoaXmlParser sxp = null;
  		SepoaSQLManager ssm = null;
  		String id = info.getSession("ID");
  		int result = 0;
  		
  		sxp = new SepoaXmlParser(this, methodName);
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
          
        result = ssm.doDelete(param);
          
        return result;
  	}
      
  	//OSSE테이블 삭제
  	private int OSSEDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
  		SepoaXmlParser sxp = null;
  		SepoaSQLManager ssm = null;
  		String id = info.getSession("ID");
  		int result = 0;
  		
  		sxp = new SepoaXmlParser(this, methodName);
  		ssm = new SepoaSQLManager(id, this, ctx, sxp);
  		
  		result = ssm.doDelete(param);
  		
  		return result;
  	}
  	
  	//ORGL테이블 삭제
  	private int ORGLDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
  		SepoaXmlParser sxp = null;
  		SepoaSQLManager ssm = null;
  		String id = info.getSession("ID");
  		int result = 0;
  		
  		sxp = new SepoaXmlParser(this, methodName);
  		ssm = new SepoaSQLManager(id, this, ctx, sxp);
  		
  		result = ssm.doDelete(param);
  		
  		return result;
  	}
  	
  	//ORLN테이블 삭제
  	private int ORLNDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
  		SepoaXmlParser sxp = null;
  		SepoaSQLManager ssm = null;
  		String id = info.getSession("ID");
  		int result = 0;
  		
  		sxp = new SepoaXmlParser(this, methodName);
  		ssm = new SepoaSQLManager(id, this, ctx, sxp);
  		
  		result = ssm.doDelete(param);
  		
  		return result;
  	}
  	
  	//OSLN테이블 Insert
  	private int setInsert_osln(ConnectionContext ctx, String methodName, List<Map<String, String>> osln_data) throws Exception{
  		SepoaXmlParser sxp = null;
  		SepoaSQLManager ssm = null;
  		String id = info.getSession("ID");
  		int result = 0;
  		Map<String, String> osln_data_set = null;
  		
  		try{  
  			
			for(int i = 0; i < osln_data.size(); i++){
				sxp = new SepoaXmlParser(this, methodName);
		  		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		  		osln_data_set = osln_data.get(i);
//		  		System.out.println("real_pr_no===="+osln_data_set.get("REAL_PR_NO"));
		  		result = ssm.doInsert(osln_data_set);
			}
			
		}catch(Exception e) {  
			
			Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
  		return result;
  	}
  	
  	//OSSE테이블 Insert
  	private int setInsert_osse(ConnectionContext ctx, String methodName, List<Map<String, String>> osse_data) throws Exception{
  		SepoaXmlParser sxp = null;
  		SepoaSQLManager ssm = null;
  		String id = info.getSession("ID");
  		int result = 0;
  		Map<String, String> osse_data_set = null;
  		
  		try{  
  			
  			for(int i = 0; i < osse_data.size(); i++){
  				sxp = new SepoaXmlParser(this, methodName);
  				ssm = new SepoaSQLManager(id, this, ctx, sxp);
  				osse_data_set = osse_data.get(i);
  				
  				result = ssm.doInsert(osse_data_set);
  			}
  			
  		}catch(Exception e) {  
  			
  			Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
  			throw new Exception(e.getMessage());  
  		}  
  		return result;
  	}
  	
  	
      /**
       * 실사 등록
       * @method setOrInsert
       * @since  2014-11-10
       * @modify 2014-11-10
       * @param header
       * @return Map
       * @throws Exception
       */
      @SuppressWarnings("unchecked")
  	public SepoaOut setOrInsert(Map<String, Object> param, String insert_flag) throws Exception{  
      	      	
  		  String send_flag                       = (String) param.get("SEND_FLAG");
      	  String add_user_id                     =  info.getSession("ID");
          String house_code                      =  info.getSession("HOUSE_CODE");
          String company_code                    =  info.getSession("COMPANY_CODE");

          String osq_no						     = (String) param.get("OSQ_NO");
          String osq_count					     = (String) param.get("OSQ_COUNT");
          
          String seq_or_no					     = (String) param.get("seqSorNo");
          String vendor_code                    = (String) param.get("VENDOR_CODE");
          
          List<Map<String, String>> chkCreateData= (List<Map<String, String>>)param.get("chkCreateData");
          List<Map<String, String>> orglData     = (List<Map<String, String>>)param.get("orglData");
          List<Map<String, String>> orlnData     = (List<Map<String, String>>)param.get("orlnData");
          List<Map<String, String>> oslnData     = (List<Map<String, String>>)param.get("oslnData");
//          List<Map<String, String>> osseData     = (List<Map<String, String>>)param.get("osseData");
          //서블릿에서 넘긴 os쪽 데이터를 리스트 형식으로 받는다.
          List<Map<String, String>> osln_data     = (List<Map<String, String>>)param.get("osln_data");
          List<Map<String, String>> osse_data     = (List<Map<String, String>>)param.get("osse_data");
          Map<String, String> os_delete_data     = new HashMap<String, String>();
          Map<String, String> or_delete_data     = new HashMap<String, String>();
          
          os_delete_data.put("HOUSE_CODE", house_code);
          os_delete_data.put("OSQ_NO", osq_no);
          os_delete_data.put("OSQ_COUNT", osq_count);
          
          or_delete_data.put("HOUSE_CODE", house_code);
          or_delete_data.put("OR_NO", seq_or_no);
          or_delete_data.put("VENDOR_CODE", vendor_code);
          
         
          ConnectionContext         ctx          = null;
          int                       rtn          = 0;  
  		
  			
  		try {  
  			
  			ctx = getConnectionContext();  
  			
  			String yn = et_getYN(osq_no, osq_count);  
  			SepoaFormater wf = new SepoaFormater(yn);  
  			String tmp = wf.getValue(0,0); // 실사마감일 체크 

  			
  			//실사마감일자가 맞지 않으면 return WORK 필요 임시주석
  			/*if(Integer.parseInt(tmp) == 0) {  
  				setMessage(msg.getMessage("0005"));  
  				setStatus(3);  
  				return getSepoaOut();  
  			}*/  
  			
  			
  			Map<String, String> chkCreateInfo = null;
  			Map<String, String> insert_osln_data = null;
  			Map<String, String> insert_osse_data = null;
  			
//  			System.out.println("chkCreateData==========="+chkCreateData.size());
  			
  			for(int i = 0 ; i < chkCreateData.size() ; i++) {
  				
//  				chkCreateInfo     = chkCreateData.get(i);
//  				
//  				String createFlag = et_getCreateFlag(chkCreateInfo.get("osq_no")
//  				    	                            ,chkCreateInfo.get("osq_count")
//  				    	                            ,chkCreateInfo.get("osq_seq"));
//  				
//  				wf = new SepoaFormater(createFlag);
//  				
//  				
//  				int qt_cnt = Integer.parseInt(wf.getValue(0,0));
//  				int rq_cnt = Integer.parseInt(wf.getValue(1,0));
  				
  				
  				//체크로직 자료 입력때문 임시 주석 WORK 필요 
  				/*if(!( qt_cnt == 0 && rq_cnt == 0)) {
  				    setMessage(msg.getMessage("0009"));  
  				    setStatus(3);  
  				    return getSepoaOut();
  				}*/
  			}
  			//업데이트가 N이면 기존 OR데이터가 존재하기 때문에 delete를 먼저 해준다.
  			if("N".equals(insert_flag)) {
  				this.ORGLDelete(ctx, "ORGLDelete", or_delete_data);
  				this.ORLNDelete(ctx, "ORLNDelete", or_delete_data);
  			}
  			//OSLN, OSSE데이터를 새로 새로 생성하기 위해서는 제일 처음 들어올때, 기존의 OSLN과 OSSE데이터를 삭제한다.
  			this.OSLNDelete(ctx, "OSLNDelete", os_delete_data);
  			this.OSSEDelete(ctx, "OSSEDelete", os_delete_data);
  			//지웠으면 다시 새로운 데이터를 insert한다.
  			rtn = setInsert_osln(ctx, "OSLNInsert" , osln_data);	//OSLN 데이터 재입력
  			rtn = setInsert_osse(ctx, "OSSEInsert" , osse_data);	//OSSE 데이터 재입력
  			
  			rtn = setInsert_orgl(ctx, seq_or_no, orglData);	//실사서 마스터 정보 입력
  			rtn = setInsert_orln(ctx, seq_or_no, orlnData);	//실사서 상세 정보 입력
  			
  			if (send_flag.equals("Y")) {
  				rtn = setUpdate_osgl_bid(ctx,info.getSession("HOUSE_CODE"),osq_no,osq_count);
  				rtn = setUpdate_osln_bid(ctx, oslnData);  
  			}
  			
  			// 업체 일반경쟁인경우 인서트, 지명경쟁인경우 업데이트		
  			//rtn = setUpdate_rqse_con_new(ctx, orglData[0][4], osseData);                      //WORK 필요
  			//rtn = setUpdate_rqse_con_new(ctx, info.getSession("VENDOR_CODE"), osseData);                      //WORK 필요
  			
  			/*if(qtepData.size() > 0) { 
  				Logger.debug.println(info.getSession("ID"),this,"qtepData==============>" + qtepData.size());  
  				rtn = set_qtEP_01(ctx, qtepData);  
  			}
  				
  			System.out.println("debug:272rqepData"+rqepData.size()+"|"+rqepData);
  			if(rqepData.size() > 0) {
  				Logger.debug.println(info.getSession("ID"),this,"rqepData==============>" + rqepData.size());  
  				ep_setCostUpdate(ctx, rqepData);
  			}
  				*/
  			//ICOYQTPF 테이블이 없음. WORK 필요
  			/*if(qtpfData.size() > 0) {
  				Logger.debug.println(info.getSession("ID"),this,"qtpfData==============>" + qtpfData.size());  
  				rtn = setProfile(ctx, qtpfData);
  			}*/
  			setStatus(1);  
  	//		msg.setArg("QTA_NO", QTA_NO);
  	//		setMessage(msg.getMessage("0010"));
  				
  			String send_msg = "실사서 번호 " + seq_or_no + " 가 작성되었습니다.";
  			if (send_flag.equals("Y")) {
  				send_msg = "실사서 번호 " + seq_or_no + " 가 제출되었습니다.";
  				
  				Map<String, String> selectParam = new HashMap<String, String>();
  				
  				selectParam.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
  				selectParam.put("OSQ_NO",     osq_no);
  				selectParam.put("OSQ_COUNT",  osq_count);
  				
  				String addUesrIdRtn = this.select(ctx, "selectSosglInfo", selectParam);
  				SepoaFormater sf = new SepoaFormater(addUesrIdRtn);
  				String addUserId = sf.getValue("ADD_USER_ID", 0);
  				
  				UcMessage.DirectSendMessage(addUserId, addUserId, info.getSession("DEPARTMENT_NAME_LOC") + "실사완료했습니다. 승인바랍니다.");
  			}
  			setMessage(send_msg);
  				
  			Commit();  
  		}catch(Exception e) {  
//  			e.printStackTrace();
  			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
  		}  
  			
  		return getSepoaOut();  
      }
      
      private String select(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
  		String          result = null;
  		String          id     = info.getSession("ID");
  		SepoaXmlParser  sxp    = null;
  		SepoaSQLManager ssm    = null;
  		
  		sxp = new SepoaXmlParser(this, name);
  		ssm = new SepoaSQLManager(id, this, ctx, sxp);
  		
  		result = ssm.doSelect(param); // 조회
  		
  		return result;
  	}
      
      /**
       * 실사 수정
       * @method setOrUpdate
       * @since  2014-11-14
       * @modify 2014-11-14
       * @param header
       * @return Map
       * @throws Exception
       */
      @SuppressWarnings("unchecked")
  	public SepoaOut setOrUpdate(Map<String, Object> param) throws Exception{  
  		
      	
      	      	
  		  String send_flag                       = (String) param.get("SEND_FLAG");
      	  String add_user_id                     =  info.getSession("ID");
          String house_code                      =  info.getSession("HOUSE_CODE");
          String company_code                    =  info.getSession("COMPANY_CODE");

          String osq_no						     = (String) param.get("OSQ_NO");
          String osq_count					     = (String) param.get("OSQ_COUNT");
          String seq_or_no					     = (String) param.get("seqSorNo");
          
          List<Map<String, String>> chkCreateData= (List<Map<String, String>>)param.get("chkCreateData");
          List<Map<String, String>> orglData     = (List<Map<String, String>>)param.get("orglData");
          List<Map<String, String>> orlnData     = (List<Map<String, String>>)param.get("orlnData");
          List<Map<String, String>> oslnData     = (List<Map<String, String>>)param.get("oslnData");
          List<Map<String, String>> osseData     = (List<Map<String, String>>)param.get("osseData");
         
          ConnectionContext         ctx          = null;
          int                       rtn          = 0;  
  		
  			
  		try {  
  			
  			ctx = getConnectionContext();  
  			
  			String yn = et_getYN(osq_no, osq_count);  
  			SepoaFormater wf = new SepoaFormater(yn);  
  			String tmp = wf.getValue(0,0); // 실사마감일 체크 

  			
  			//실사마감일자가 맞지 않으면 return WORK 필요 임시주석
  			/*if(Integer.parseInt(tmp) == 0) {  
  				setMessage(msg.getMessage("0005"));  
  				setStatus(3);  
  				return getSepoaOut();  
  			}*/  
  			
  			
  			Map<String, String> chkCreateInfo = null;
  			
  			for(int i = 0 ; i < chkCreateData.size() ; i++) {
  				
  				chkCreateInfo     = chkCreateData.get(i);
  				
  				String createFlag = et_getCreateFlag(chkCreateInfo.get("osq_no")
  				    	                            ,chkCreateInfo.get("osq_count")
  				    	                            ,chkCreateInfo.get("osq_seq"));
  				
  				
  				wf = new SepoaFormater(createFlag);
  				
  				
  				int qt_cnt = Integer.parseInt(wf.getValue(0,0));
  				int rq_cnt = Integer.parseInt(wf.getValue(1,0));
  				
  				
  				//체크로직 자료 입력때문 임시 주석 WORK 필요 
  				/*if(!( qt_cnt == 0 && rq_cnt == 0)) {
  				    setMessage(msg.getMessage("0009"));  
  				    setStatus(3);  
  				    return getSepoaOut();
  				}*/
  			}
  						
  			
  			rtn = setUpdate_orgl(ctx, seq_or_no, orglData);												//실사서 마스터 정보 입력
  			  
  			rtn = setUpdate_orln(ctx, seq_or_no, orlnData);												//실사서 상세 정보 입력
  			
  			
  			
  			if (send_flag.equals("Y")) {
  				rtn = setUpdate_osgl_bid(ctx,info.getSession("HOUSE_CODE"),osq_no,osq_count);
  				rtn = setUpdate_osln_bid(ctx, oslnData);  
  			}
  			
  			
  			
  			
  			setStatus(1);  
  	//		msg.setArg("QTA_NO", QTA_NO);
  	//		setMessage(msg.getMessage("0010"));
  				
  			String send_msg = "실사서 번호 " + seq_or_no + " 가 수정되었습니다.";
  			if (send_flag.equals("Y")) {
  				send_msg = "실사서 번호 " + seq_or_no + " 가 제출되었습니다.";
  			}
  			setMessage(send_msg);
  				
  			Commit();  
  		}catch(Exception e) {  
  			
  			try{  
  				Rollback();  
  			}catch(Exception e1){ setStatus(0);   }  
  			//Logger.err.println("Exception e =" + stackTrace(e));  
  			setStatus(0);  
  			setMessage(msg.getMessage("0012"));  
  			//Logger.err.println(this,stackTrace(e));  
  		}  
  			
  		return getSepoaOut();  
      }
      
      
      
      /**
       * 실사 등록 가능 여부 마감일 체크
       * @method et_getYN
       * @since  2014-11-10
       * @modify 2014-11-10
       * @param header
       * @return Map
       * @throws Exception
       */
      private String et_getYN(String OSQ_NO, String OSQ_COUNT) throws Exception  
      {  
          String rtn = "";  
          Map<String, String> data = new HashMap<String, String>();
          ConnectionContext ctx = getConnectionContext();  
          
          SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
          try{  
              SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
              //String[] data = {info.getSession("HOUSE_CODE"), OSQ_NO, OSQ_COUNT};
              data.put("osq_no",        OSQ_NO);
              data.put("osq_count",     OSQ_COUNT);
              
              rtn = sm.doSelect(data);  
          }catch(Exception e) {  
             //Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
              throw new Exception(e.getMessage());  
          }  
          return rtn;  
      }
      
      
      //ICOYQTDT
      private String et_getCreateFlag(String OSQ_NO, String OSQ_COUNT, String OSQ_SEQ) throws Exception  
      {  
          String rtn = "";  
          Map<String, String> data = new HashMap<String, String>();
          
          ConnectionContext ctx = getConnectionContext();  
          SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
     	  	 
          try{  
              SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
              
              data.put("osq_no",        OSQ_NO);
              data.put("osq_seq",       OSQ_SEQ);
              data.put("osq_count",     OSQ_COUNT);
               
              rtn = sm.doSelect(data);  
          }catch(Exception e) {  
              
        	  Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
              throw new Exception(e.getMessage());  
          }  
          return rtn;  
      }
      
      

      /**
       * 실사서 마스터 정보 입력(SORGL)
       * @method setInsert_orgl
       * @since  2014-10-08
       * @modify 2014-10-08
       * @param header
       * @return Map
       * @throws Exception
       */
  	 private int setInsert_orgl(ConnectionContext ctx, String seq_or_no, List<Map<String, String>> orglData) throws Exception{  
  		
  		SepoaXmlParser      wxp          = null;
  		SepoaSQLManager     sm           = null;
  		Map<String, String> orglDataInfo = null;
  		int	                rtn          = 0; 
  		int                 i            = 0;
  		
  		

  		int                 orglDataSize = orglData.size();

  		try{  
  		
  			for(i = 0; i < orglDataSize; i++){
  				
  				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()); 
  				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
  				
  				orglDataInfo = orglData.get(i);
  				//orglDataInfo.put("seq_or_no", seq_or_no);
  				rtn          = sm.doInsert(orglDataInfo);
  			}
  			
  		}catch(Exception e) {  
  			
  			Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
  			throw new Exception(e.getMessage());  
  		}  
  		return rtn;  
  	}
  	 

     /**
      * 실사서 마스터 정보 수정(SORGL)
      * @method setUpdate_orgl
      * @since  2014-11-14
      * @modify 2014-11-14
      * @param header
      * @return Map
      * @throws Exception
      */
 	 private int setUpdate_orgl(ConnectionContext ctx, String seq_or_no, List<Map<String, String>> orglData) throws Exception{  
 		
 		SepoaXmlParser      wxp          = null;
 		SepoaSQLManager     sm           = null;
 		Map<String, String> orglDataInfo = null;
 		int	                rtn          = 0; 
 		int                 i            = 0;
 		
 		int                 orglDataSize = orglData.size();

 		try{  
 		
 			for(i = 0; i < orglDataSize; i++){
 				
 				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()); 
 				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
 				
 				orglDataInfo = orglData.get(i);
 				//orglDataInfo.put("seq_or_no", seq_or_no);
 				rtn          = sm.doUpdate(orglDataInfo);
 			}
 			
 		}catch(Exception e) {  
 			
 			Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
 			throw new Exception(e.getMessage());  
 		}  
 		return rtn;  
 	}
 	 
  	
 	 
 	 /**
	     * 실사서 상세 정보 수정(SORLN)
	     * @method setUpdate_orln
	     * @since  2014-11-08
	     * @modify 2014-11-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */
	private int setUpdate_orln(  ConnectionContext ctx, String seq_or_no, List<Map<String, String>> orlnData) throws Exception{  

			SepoaXmlParser      wxp          = null;
			SepoaSQLManager     sm           = null;
			Map<String, String> orlnDataInfo = new HashMap<String, String>();
			int	                rtn          = 0; 
			int                 i            = 0;
			int                 orlnDataSize = orlnData.size();
			

			try{  
			
				
				for(i = 0; i < orlnDataSize; i++){
					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()); 
	  				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
	  					
					orlnDataInfo = orlnData.get(i);
					
					rtn          = sm.doUpdate(orlnDataInfo);
				}
			
			
			} catch(Exception e) {  
				
				Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
				throw new Exception(e.getMessage());  
			}  
			return rtn;  
		}

		
  	   /**
  	     * 실사서 상세 정보 입력(SORLN)
  	     * @method setInsert_orln
  	     * @since  2014-11-08
  	     * @modify 2014-11-08
  	     * @param header
  	     * @return Map
  	     * @throws Exception
  	     */
  		private int setInsert_orln(  ConnectionContext ctx, String seq_or_no, List<Map<String, String>> orlnData) throws Exception{  

  			SepoaXmlParser      wxp          = null;
  			SepoaSQLManager     sm           = null;
  			Map<String, String> orlnDataInfo = new HashMap<String, String>();
  			int	                rtn          = 0; 
  			int                 i            = 0;
  			int                 orlnDataSize = orlnData.size();
  			

  			try{  
  			
  				
  				for(i = 0; i < orlnDataSize; i++){
  					wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()); 
  	  				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
  	  					
  					orlnDataInfo = orlnData.get(i);
  					
  					rtn          = sm.doInsert(orlnDataInfo);
  				}
  			
  			
  			} catch(Exception e) {  
  				
  				Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
  				throw new Exception(e.getMessage());  
  			}  
  			return rtn;  
  		}

  		

		
		/**
	     * 실사서 마스터 수정(ICOYRQHD)
	     * @method setUpdate_rqhd_bid
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */		
		 private int setUpdate_osgl_bid (ConnectionContext ctx,  
							             String HOUSE_CODE,  
							             String OSQ_NO,  
							             String OSQ_COUNT)  throws Exception {  
			int rtn = -1;  
			Map<String, String> data = new HashMap<String, String>(); 
			SepoaXmlParser wxp = null; 
			SepoaSQLManager sm = null;  
			
			try {  
				
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				
				
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				//String[][] setData = {{info.getSession("HOUSE_CODE"), OSQ_NO, OSQ_COUNT}};
				data.put("osq_no",     OSQ_NO);
				data.put("osq_count",  OSQ_COUNT);
				rtn = sm.doUpdate(data);  
			
			}catch(Exception e) {  
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
				throw new Exception(e.getMessage());  
			}  
				return rtn;  
		}
		
		 /**
	     * 실사서 상세 수정(ICOYRQDT)
	     * @method setUpdate_rqdt_bid
	     * @since  2014-10-08
	     * @modify 2014-10-08
	     * @param header
	     * @return Map
	     * @throws Exception
	     */		
			private int setUpdate_osln_bid(ConnectionContext ctx, List<Map<String, String>> oslnData)  throws Exception{  
				
				int rtn                          = -1;  
				int i                            = 0;
				SepoaXmlParser wxp               = null;
				SepoaSQLManager sm               = null;
				
				Map<String, String> oslnDataInfo = null;
				
				
				
				try {  
					
					for(i = 0; i < oslnData.size() ; i++){
						
						wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
						sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
						
						oslnDataInfo = oslnData.get(i);
						rtn	= sm.doInsert(oslnDataInfo);
					}
					
				
				}catch(Exception e) {  
					
					Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
					throw new Exception(e.getMessage());  
				}  
				return rtn;  
			}				
		
			/**
		     * 
		     * @method setUpdate_qtHD_UP
		     * @since  2014-10-08
		     * @modify 2014-10-08
		     * @param header
		     * @return Map
		     * @throws Exception
		     */	
		    private	int	setUpdate_orgl(	ConnectionContext ctx, 
					List<Map<String, String>> orglData)throws	Exception{ 
				int	rtn	= 0; 
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				
				try{ 
				
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doUpdate(orglData); 
				
				}catch(Exception e)	{ 
				//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
					throw new Exception(e.getMessage()); 
				} 
				
				return rtn; 
				}

		    /**
		     * 
		     * @method setDelQTDT
		     * @since  2014-10-08
		     * @modify 2014-10-08
		     * @param header
		     * @return Map
		     * @throws Exception
		     */   
		private	int	setDelOrln(	ConnectionContext ctx, 
				List<Map<String, String>> delOrlnData)throws Exception{ 
			
			int	rtn	= 0; 

			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			
			try{ 	

				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(delOrlnData); 

			}catch(Exception e)	{ 
				//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
				throw new Exception(e.getMessage()); 
			} 
				return rtn; 
		}
		
		/**
		 * 실사포기
		 * @method setRejectOsq
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-11-07
		 * @modify 2014-11-07
		 */
		@SuppressWarnings("unchecked")
		public SepoaOut setRejectOsq(Map<String, Object> svcParam)  throws Exception {  
	    	
			List<Map<String, String>> grid          = null;
			Map<String, String>       gridInfo      = null;

			int	rtn_ins	= 0;
			int	rtn   	= 0;  
	    	
	        try	{  
	            
	        	grid = (List<Map<String, String>>)svcParam.get("gridData");
	        	
	        	for(int i=0; i<grid.size();i++){
	        		gridInfo = grid.get(i);
	        		rtn =	et_setRejectOsq(gridInfo);  //실사거부 SOSSE BID_FLAG = 'N'	
	        	      
	        		rtn = et_setRejectOsgl(gridInfo);	//실사거부 SOSGL OSQ_FLAG = 'D'
	        	}
	        	
	        	
	          setStatus(1);  
	          setValue(Integer.toString(rtn));  
	      
	          if(rtn >=	0) {
	             setMessage("실사포기가 완료됐습니다."); 
	          }  
	          else {  
	             setMessage("실사포기에 실패했습니다."); 
	          }   
	          Commit();  
	        }catch(Exception e){  
	            try {
	                Rollback();
	            } catch(Exception d) {
	                Logger.err.println(info.getSession("ID"),this,d.getMessage());
	            }

	            Logger.err.println("Exception	e =" + e.getMessage());  
	            setStatus(0);  
	        }
			return getSepoaOut();  
		}  
	  
		/**
		 * 실사포기  SOSSE 쿼리
		 * @method et_setRejectOsq
		 * @param  data
		 * @return Map
		 * @throws Exception
		 * @desc   
		 * @since  2014-11-12
		 * @modify 2014-11-12
		 */
		private	int	et_setRejectOsq	(Map<String, String> data) throws	Exception  
		{  
			int	rtn	= 0;  
			SepoaSQLManager sm =	null;  
			ConnectionContext ctx =	getConnectionContext();  
			
			try	{  
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				rtn	= sm.doUpdate(data);  
	  
			}catch(Exception e)	{  
				try{  
					Rollback();  
				}catch(Exception e1){ Logger.err.println(info.getSession("ID"),this,"et_setRejectOsq:==>"+e.getMessage());  }  
				Logger.err.println(info.getSession("ID"),this,"et_setRejectOsq:==>"+e.getMessage());  
				rtn	= -1;  
				throw new Exception("실사포기 에러......");  
			} 
			return rtn;  
		}
		

		/**
		 * 실사포기  SOSGL 쿼리
		 * @method et_setRejectOsgl
		 * @param  data
		 * @return Map
		 * @throws Exception
		 * @desc   
		 * @since  2014-11-12
		 * @modify 2014-11-12
		 */
		private	int	et_setRejectOsgl(Map<String, String> data) throws	Exception  
		{  
			int	rtn	= 0;  
			SepoaSQLManager sm =	null;  
			ConnectionContext ctx =	getConnectionContext();  
			
			try	{  
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				rtn	= sm.doUpdate(data);  
	  
			}catch(Exception e)	{  
				try{  
					Rollback();  
				}catch(Exception e1){ Logger.err.println(info.getSession("ID"),this,"et_setRejectOsgl:==>"+e.getMessage()); }  
					Logger.err.println(info.getSession("ID"),this,"et_setRejectOsgl:==>"+e.getMessage());  
					rtn	= -1;  
					throw new Exception("실사포기 에러......");  
			} 
			
			return rtn;  
		}
		

	    /**
	     * 실사서 결과현황 조회
	     * @method getCompanyOsqList
	     * @since  2014-11-11
	     * @modify 2014-11-11
	     * @param header
	     * @return Map
	     * @throws Exception
	     */ 
	  		public SepoaOut getCompanyOsqList(Map<String, String> data) {  
		        try {  
		            String rtn = "";  
		  
		            //Query 수행부분 Call  
		            //create_type 에 상관없이 조회 
		            rtn = et_getCompanyOsqList(data);  
		  
					SepoaFormater wf = new SepoaFormater(rtn);
					if(wf.getRowCount() == 0) setMessage(msg.getMessage("0011"));
					else {
						setMessage(msg.getMessage("0003"));
					}
		              
		            setValue(rtn);  
		            setStatus(1);  
		        }catch (Exception e){  
		            //Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
		            setMessage(msg.getMessage("0004"));  
		            setStatus(0);  
		        }  
		        return getSepoaOut();  
	  		}
	  	 
	  		/**
		     * 실사서 결과현황 쿼리
		     * @method et_getCompanyQtaList
		     * @since  2014-10-08
		     * @modify 2014-10-08
		     * @param header
		     * @return Map
		     * @throws Exception
		     */  
	  		private	String et_getCompanyOsqList(Map<String, String> data) throws Exception  
		    {  
		    	String rtn = "";  
				ConnectionContext ctx =	getConnectionContext();  
				String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
		        
		        try {  
		        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		        	//wxp.addVar("status", status);
		        	data.put("cur_date_time", cur_date_time);
		        	wxp.addVar("osq_flag"     , data.get("osq_flag"));

		        	
		            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
		            rtn	= sm.doSelect(data); 
					
		            if(rtn == null) throw new Exception("SQL Manager is Null");  
		        }catch(Exception e) {  
		            throw new Exception("et_getCompanyOsqList=========>"+e.getMessage());  
		        } finally{  
		        }  
		        return rtn;  
	  		}
	  		
	  		
	  		//실사서 결과팝업조회  
	  	    public SepoaOut getCompanyOsqListPopup(String vendor_code, String rfq_no, String rfq_count) {  
	  	        try {  
	  	            String rtn = "";  

	  	            rtn = et_getCompanyOsqListPopup(vendor_code, rfq_no, rfq_count);  
	  	            
	  				SepoaFormater wf = new SepoaFormater(rtn);
	  				if(wf.getRowCount() == 0) setMessage(msg.getMessage("0011"));
	  				else {
	  					setMessage(msg.getMessage("0003"));
	  				}
	  	            setValue(rtn);  
	  	            setStatus(1);  
	  	        }catch (Exception e){  
	  	          //  Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
	  	            setMessage(msg.getMessage("0004"));  
	  	            setStatus(0);  
	  	        }  
	  	        return getSepoaOut();  
	  	    }  
	  	  
	  	    private String et_getCompanyOsqListPopup(String vendor_code, String rfq_no, String rfq_count) throws Exception  
	  	    {  
	  	        String rtn = "";  
	  	        ConnectionContext ctx = getConnectionContext();  
	  	  
	  	        try {  
	  	        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
	  	            
	  	        	
	  	  			
	  	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	  	            String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, vendor_code};
	  	            rtn = sm.doSelect(data);  
	  	  
	  	            if(rtn == null) throw new Exception("SQL Manager is Null");  
	  	        }catch(Exception e) {  
	  	            throw new Exception("et_getCompanyOsqListPopup=========>"+e.getMessage());  
	  	        } finally{  
	  	        }  
	  	        return rtn;  
	  	    }  	    
	    
			
		
}
