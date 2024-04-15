package statistics;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
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
import wisecommon.SignRequestInfo;

public class p7008  extends SepoaService {
	private Message msg;

    public p7008(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info, "STDCOMM");
    }
    
	public String getConfig(String s){
		Configuration configuration = null;
		
	    try{
	        configuration = new Configuration();
	        
	        s = configuration.get(s);
	    }
	    catch(Exception exception){
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	        
	        s = null;
	    }
	    
	    return s;
	}
	
	/**
	 * 구매요청 진행현황
	 * @method prProceedingList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-11-24
	 * @modify 2014-11-24
	 */
			public SepoaOut prProceedingList(Map<String, String> header)
		    {
		        try
		        {
		            String rtn = et_prProceedingList(header);
		            setStatus(1);
		            setValue(rtn);

		            setMessage(msg.getMessage("0000"));

		        }catch(Exception e) {
		            Logger.err.println(userid,this,e.getMessage());
		            setStatus(0);
		            setMessage(msg.getMessage("0001"));
		        }
		        return getSepoaOut();
		    }

			/**
			 * 구매요청 진행현황 쿼리
			 * @method et_prProceedingList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */		    
			private String et_prProceedingList(Map<String, String> header) throws Exception
		    {
		        String rtn = null;
		        ConnectionContext ctx = getConnectionContext();

		        StringBuffer tSQL = new StringBuffer();
		        //String house_code = info.getSession("HOUSE_CODE");
		        String dept       = info.getSession("DEPARTMENT");
		        String bid_div    = header.get("bid_div");
		        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		        
		        //wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		         wxp.addVar("BID_DIV",       bid_div);
		        
		        try{
		            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

		            rtn = sm.doSelect(header);

		        }catch(Exception e) {
		            Logger.debug.println(userid,this,e.getMessage());
		            Logger.debug.println(userid,this,tSQL.toString());
		            throw new Exception(e.getMessage());
		        }
		        return rtn;
		    }
			
			@SuppressWarnings("rawtypes")
			private void sysOutMap(Map map) throws Exception{
			    Iterator value       = map.values().iterator();
			    Iterator key         = map.keySet().iterator();
			    Object   valueObject = null;
			              
			    Logger.debug.println();
			    
			    while(value.hasNext()){
			    	valueObject = value.next();
			    	
			    	if(valueObject != null){
			    		Logger.debug.println("map key : >" + key.next() + "<, value : >" + valueObject.toString() + "< value is String : >" + (valueObject instanceof String) + "<");  
			    	}
			    	else{
			    		Logger.debug.println("map key : >" + key.next() + "<, value : null");
			    	}
			    }
			    
			    Logger.debug.println();
			}
			
			private int gl_setStaPubInsert_M(Map<String, String> param) throws Exception{
		    	ConnectionContext ctx = getConnectionContext();
		    	SepoaXmlParser    sxp = null;
				SepoaSQLManager   ssm = null;
		        int               rtn = 0;
		        
		        try{
		        	
		        	
		            sxp = new SepoaXmlParser(this, "gl_setStaPubInsert_M");
//		            System.out.println("sql = "+sxp.getQuery());
		            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);		         
//			        System.out.println("CO_NO ========" +param.get("CO_NO"));
		            rtn = ssm.doInsert(param); 
//		            System.out.println("CO_NO ========" +param.get("CO_NO"));
		            

		            
		        }
		        catch(Exception e){
//		        	e.printStackTrace();
		            Logger.err.println(info.getSession("ID"),this,e.getMessage());
		            throw new Exception(e.getMessage());
		        }
		        
		        return rtn;
		    }	
			
			private int gl_setStaPubInsert_D(Map<String, String> param) throws Exception{
				ConnectionContext ctx = getConnectionContext();
		    	SepoaXmlParser    sxp = null;
				SepoaSQLManager   ssm = null;
		        int               rtn = 0;
		        
		        try{
		            sxp = new SepoaXmlParser(this, "gl_setStaPubInsert_D");
//		            System.out.println("gl_setStaPubInsert.sql = "+sxp.getQuery());
		            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
//			        System.out.println("1..gl_setStaPubInsert.CO_NO ==" +param.get("CO_NO"));
//			        System.out.println("1..gl_setStaPubInsert.HOUSE_CODE ==" +param.get("HOUSE_CODE"));		                            
		            rtn = ssm.doInsert(param);
//			        System.out.println("2..gl_setStaPubInsert.CO_NO ==" +param.get("CO_NO"));
//			        System.out.println("2..gl_setStaPubInsert.HOUSE_CODE ==" +param.get("HOUSE_CODE"));
		        }
		        catch(Exception e){
		            Logger.err.println(info.getSession("ID"),this,e.getMessage());
		            throw new Exception(e.getMessage());
		        }
		        
		        return rtn;
		    }
			public SepoaOut setStaPubInsert(Map<String, Object> param) throws Exception{
				String                    add_user_id       =  info.getSession("ID");
		        String                    house_code        =  info.getSession("HOUSE_CODE");
		        String                    company_code      =  info.getSession("COMPANY_CODE");
		        String                    add_user_dept     =  info.getSession("DEPARTMENT");
		        String                    req_type          = null;
		        String                    strDocFlag        = "";
		        String                    pre_pjt_code      = null;
		        String                    prNo              = null;
		        String                    sign_status       = null;
		        String                    subject           = null;
		        String                    pr_tot_amt        = null;
		        String                    approval_str      = null;
		        String                    strMsgTemp        = null;
		        Map<String, String>       header            = MapUtils.getMap(param, "headerData"); // 조회 조건 조회
		        Map<String, String>       prHdCreateParam   = null;
		        Map<String, String>       prDtCreateParam   = null;
		        Map<String, String>       gridInfo          = null;
		        List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
		        List<Map<String, String>> prBrParamList     = null;
		        int                       hd_rtn            = 0;
		        int                       dt_rtn            = 0;
		        int                       gridSize          = grid.size();
		        int                       i                 = 0;
		        int                       prbr_rtn          = 0;
		        int                       prBrParamListSize = 0;

//		       this.sysoutMapInfo(header, "header");
//				
//				for(Map<String, String> gridInfo : grid){
//					this.sysoutMapInfo(gridInfo, "gridInfo");
//				}
		        
		        
				
//		    	req_type     = header.get("pr_gubun");
//		    	prNo         = header.get("prNo");
//		    	sign_status  = header.get("sign_status");
//		    	subject      = header.get("subject");
//		    	pr_tot_amt   = header.get("pr_tot_amt");
//		    	approval_str = header.get("approval_str");
		    	
//				if("P".equals(req_type)){
//					strDocFlag = "PR";
//				}
//				else if("B".equals(strDocFlag)){
//					strDocFlag = "BR";
//				}
		        
		        String sCo_no  = this.getSeq(header);
		        header.put("CO_NO", sCo_no);
//				System.out.println("setStaPubInsert : 11111=="+header.get("CO_NO") +"..."+header.get("HOUSE_CODE")+header.get("house_code"));
		        try{
		        	
					setStatus(1);
					setFlag(true);
		        	
		        	//prHdCreateParam = this.prHdCreateParam(header);
		        	sysOutMap(header);
		            hd_rtn          = this.gl_setStaPubInsert_M(header);
//		            System.out.println("gl_setStaPubInsert_M ....call ");
		            
//		            System.out.println("hd_rtn ==="+hd_rtn);
		            
		            if(hd_rtn < 1){
		            	throw new Exception("....");
		            }
//					     
		            for(i = 0; i < gridSize; i++){
		            	gridInfo        = grid.get(i);
		            	gridInfo.put("HOUSE_CODE", header.get("house_code"));
		            	gridInfo.put("CO_NO", header.get("CO_NO"));
		            	
		            	//prDtCreateParam = this.prDtCreateParam(header, gridInfo);
		                dt_rtn          = this.gl_setStaPubInsert_D(gridInfo);
		                
		                if(dt_rtn < 1){
		                	throw new Exception("...");
		                }
		            }
		            setStatus(1);
		            Commit();
		        }
		        catch(Exception e){
		            try{
		                Rollback();
		            }
		            catch(Exception d){
		                Logger.err.println(info.getSession("ID"),this,d.getMessage());
		            }
		            
		            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
		            setStatus(0);
		            setMessage(msg.getMessage("0001"));
		        }

		        return getSepoaOut();
			}
			
			
			private void alert(String string) {
				// TODO Auto-generated method stub
				
			}
			
			/**
			 * 조회 메소드
			 * 
			 * @param ctx
			 * @param name
			 * @param param
			 * @return String
			 * @throws Exception
			 */
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
			 * 조회 sample
			 * 
			 * @param header
			 * @return SepoaOut
			 */
			public String getSeq(Map<String, String> header){
				ConnectionContext ctx = null;
				String            rtn = null;
				String            rSeq = null;
				String            company_reg_no = null;
				String            rDate = null;
				
				try{
					setStatus(1);
					setFlag(true);
					
					ctx    = getConnectionContext();
					//header = this.getmyCatalogHeader(header);
					
					
					rtn    = this.select(ctx, "gl_getSeq", header);
					SepoaFormater sf  = new SepoaFormater(rtn);
					rSeq  = sf.getValue("SEQ", 0);
					rDate  = sf.getValue("RDATE", 0);
					company_reg_no = header.get("company_reg_no");

					
					setValue(rtn);
					setMessage(msg.getMessage("0000"));
				}
				catch(Exception e) {
					Logger.err.println(userid, this, e.getMessage());
					setStatus(0);
					setMessage(msg.getMessage("0001"));
				}
				

				return rDate+company_reg_no+rSeq;
			}
			/**
			 * 실적조회
			 * @method getStaPubList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */		    
		    public SepoaOut getStaPubList(Map<String, String> header)
			{
				try {

					//String house_code = info.getSession("HOUSE_CODE");
					String rtnHD = gl_getStaPubList(header);

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
		    /**
			 * 업체정보
			 * @method gl_getStaPubList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */	
		    private String gl_getStaPubList(Map<String, String> header) throws Exception
			{
				/////////////////////// 직무 코드 관련 처리
				//String cur_ctrl_code = DoWorkWithCtrl_code(ctrl_code);

				String rtn = "";
				ConnectionContext ctx = getConnectionContext();
				try {

					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//					wxp.addVar("SELECTED",	header.get("SELECTED"));
//					wxp.addVar("SUBJECT",		header.get("SUBJECT"));
//					wxp.addVar("CO_NO",	header.get("CO_NO"));
//					wxp.addVar("ITEM_NO",	header.get("ITEM_NO"));

//					System.out.println("sql = " +wxp.getQuery());
					@SuppressWarnings("deprecation")
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

					rtn = sm.doSelect(header);
					


				}catch(Exception e) {
					throw new Exception("gl_getStaPubList:"+e.getMessage());
				} finally {
				}
				return rtn;
			}				
			/**
			 * 업체정보 조회 
			 * @method getStaCompInfo
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */		    
		    public SepoaOut getStaCompInfo(Map<String, String> header)
			{
				try {

					//String house_code = info.getSession("HOUSE_CODE");
					String rtnHD = gl_getStaCompInfo(header);

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
		    
		    /**
			 * 업체정보
			 * @method gl_getStaCompInfo
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */	
		    private String gl_getStaCompInfo(Map<String, String> header) throws Exception
			{
				/////////////////////// 직무 코드 관련 처리
				//String cur_ctrl_code = DoWorkWithCtrl_code(ctrl_code);

				String rtn = "";
				ConnectionContext ctx = getConnectionContext();
				try {

					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//					wxp.addVar("SELECTED",	header.get("SELECTED"));
//					wxp.addVar("SUBJECT",		header.get("SUBJECT"));
//					wxp.addVar("CO_NO",	header.get("CO_NO"));
//					wxp.addVar("ITEM_NO",	header.get("ITEM_NO"));

//					System.out.println("sql = " +wxp.getQuery());
					@SuppressWarnings("deprecation")
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

					rtn = sm.doSelect(header);


				}catch(Exception e) {
					throw new Exception("gl_getStaCompInfo:"+e.getMessage());
				} finally {
				}
				return rtn;
			}			    
			/**
			 * 발주현황 
			 * @method getStaOrdList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */		    
		    public SepoaOut getStaOrdList(Map<String, String> header)
			{
				try {

					//String house_code = info.getSession("HOUSE_CODE");
					String rtnHD = gl_getStaOrdList(header);

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

		    /**
			 * 발주현황 쿼리
			 * @method gl_getStaOrdList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */	
		    private String gl_getStaOrdList(Map<String, String> header) throws Exception
			{
				/////////////////////// 직무 코드 관련 처리
				//String cur_ctrl_code = DoWorkWithCtrl_code(ctrl_code);

				String rtn = "";
				ConnectionContext ctx = getConnectionContext();
				try {

					String addStr = "";
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					
					if(!"".equals(header.get("po_no"))){
						addStr = "AND PO_NO NOT IN ("+header.get("po_no")+")";
					}
					
					wxp.addVar("addStr",	addStr);
//					wxp.addVar("SUBJECT",		header.get("SUBJECT"));
//					wxp.addVar("CO_NO",	header.get("CO_NO"));
//					wxp.addVar("ITEM_NO",	header.get("ITEM_NO"));


					@SuppressWarnings("deprecation")
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

					rtn = sm.doSelect(header);

				}catch(Exception e) {
					throw new Exception("bl_getPoList:"+e.getMessage());
				} finally {
				}
				return rtn;
			}	    
	
			
			/**
			 * 발주현황 
			 * @method getPoList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */		    
		    public SepoaOut getPoList(Map<String, String> header)
			{
				try {

					//String house_code = info.getSession("HOUSE_CODE");
					String rtnHD = bl_getPoList(header);

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

		    /**
			 * 발주현황 쿼리
			 * @method bl_getPoList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-24
			 * @modify 2014-11-24
			 */	
		    private String bl_getPoList(Map<String, String> header) throws Exception
			{
				/////////////////////// 직무 코드 관련 처리
				//String cur_ctrl_code = DoWorkWithCtrl_code(ctrl_code);

				String rtn = "";
				ConnectionContext ctx = getConnectionContext();
				try {

					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					wxp.addVar("HOUSE_CODE",	header.get("house_code"));
					wxp.addVar("po_status",		header.get("po_status"));
					wxp.addVar("confirm_flag",	header.get("confirm_flag"));
					wxp.addVar("cont_status",	header.get("cont_status"));
					wxp.addVar("complete_mark",	header.get("complete_mark"));
					wxp.addVar("BID_DIV",		header.get("bid_div"));

					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

					rtn = sm.doSelect(header);

				}catch(Exception e) {
					throw new Exception("bl_getPoList:"+e.getMessage());
				} finally {
				}
				return rtn;
			}
		    
		    
		  
		    /**
			 * 업체별 구매현황
			 * @method getStaProVendorList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public SepoaOut getStaProVendorList(Map<String, String> header) {
				String user_id = info.getSession("ID");
				try {
					String rtn = null;
					rtn = et_getStaProVendorList(user_id, header);  
					setValue(rtn);
					setStatus(1);
					setMessage(msg.getMessage("0000"));
				} catch (Exception e) {
					setStatus(0);
					setMessage(e.getMessage());
					Logger.err.println(user_id, this, e.getMessage());
				} finally {
					Release();
				}
				return getSepoaOut();
			}
			
			/**
			 * 업체별 구매현황 쿼리
			 * @method et_getStaProVendorList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public String et_getStaProVendorList(String user_id, Map<String, String> header) throws Exception { 
				String result = null;
				ConnectionContext ctx = getConnectionContext();
				
				try {
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					//wxp.addVar("house_code", house_code); 
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
					result = sm.doSelect(header);

					if (result == null)
						throw new Exception("SQLManager is null");
				} catch (Exception ex) {
					throw new Exception("et_getStaProVendorList()" + ex.getMessage());
				}
				return result;
			}		
			
			
			/**
			 * 고객/품목별 구매현황
			 * @method getStaProCustomerList2
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public SepoaOut getStaProCustomerList2(Map<String ,String> header) {
				String user_id = info.getSession("ID");
				try {
					String rtn = null;
					rtn = et_getStaProCustomerList2(header);  
					setValue(rtn);
					setStatus(1);
					setMessage(msg.getMessage("0000"));
				} catch (Exception e) {
					setStatus(0);
					setMessage(e.getMessage());
					Logger.err.println(user_id, this, e.getMessage());
				} finally {
					Release();
				}
				return getSepoaOut();
			}
			
			/**
			 * 고객/품목별 구매현황 쿼리
			 * @method et_getStaProCustomerList2
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public String et_getStaProCustomerList2(Map<String, String> header) throws Exception { 
				String result = null;
				ConnectionContext ctx = getConnectionContext();
				
				//wxp.addVar("house_code", house_code); 
				
				try {
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

					result = sm.doSelect(header);

					if (result == null)
						throw new Exception("SQLManager is null");
				} catch (Exception ex) {
					throw new Exception("et_getStaProCustomerList2()" + ex.getMessage());
				}
				return result;
			}
			
			/**
			 * //품목별 단가현황
			 * @method getStaUPItemList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public SepoaOut getStaUPItemList(Map<String, String> header) {
				String user_id = info.getSession("ID");
				try {
					String rtn = null;
					rtn = et_getStaUPItemList(header);  
					setValue(rtn);
					setStatus(1);
					setMessage(msg.getMessage("0000"));
				} catch (Exception e) {
					setStatus(0);
					setMessage(e.getMessage());
					Logger.err.println(user_id, this, e.getMessage());
				} finally {
					Release();
				}
				return getSepoaOut();
			}
			
			/**
			 * //품목별 단가현황 쿼리
			 * @method et_getStaUPItemList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public String et_getStaUPItemList(Map<String, String> header) throws Exception { 
				String result = null;
				ConnectionContext ctx = getConnectionContext();
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", info.getSession("house_code")); 
				wxp.addVar("flag",       header.get("flag")); 
//				wxp.addVar("from_date",  args[0]); 
//				wxp.addVar("to_date",    args[1]); 
				
				try {
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
					result = sm.doSelect(header);

					if (result == null)
						throw new Exception("SQLManager is null");
				} catch (Exception ex) {
					throw new Exception("et_getStaUPItemList()" + ex.getMessage());
				}
				return result;
			}

			
			/**
			 * //담당자별 Lead Time
			 * @method getStaLTUserList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public SepoaOut getStaLTUserList(Map<String, String> header) {
				String user_id = info.getSession("ID");
				try {
					String rtn = null;
					rtn = et_getStaLTUserList(header);  
					setValue(rtn);
					setStatus(1);
					setMessage(msg.getMessage("0000"));
				} catch (Exception e) {
					setStatus(0);
					setMessage(e.getMessage());
					Logger.err.println(user_id, this, e.getMessage());
				} finally {
					Release();
				}
				return getSepoaOut();
			}
			
			/**
			 * //담당자별 Lead Time 쿼리
			 * @method et_getStaLTUserList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public String et_getStaLTUserList(Map<String, String> header) throws Exception { 
				String result = null;
				ConnectionContext ctx = getConnectionContext();
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				///wxp.addVar("house_code", house_code); 
				wxp.addVar("flag",       header.get("flag")); 
				try {
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

					result = sm.doSelect(header);

					if (result == null)
						throw new Exception("SQLManager is null");
				} catch (Exception ex) {
					throw new Exception("et_getStaLTUserList()" + ex.getMessage());
				}
				return result;
			}
			
			
			
			/**
			 * //Process별 Lead Time 
			 * @method getStaLTProcessList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public SepoaOut getStaLTProcessList(Map<String, String> header) {
				String user_id = info.getSession("ID");
				try {
					String rtn = null;
					rtn = et_getStaLTProcessList(header);  
					setValue(rtn);
					setStatus(1);
					setMessage(msg.getMessage("0000"));
				} catch (Exception e) {
					setStatus(0);
					setMessage(e.getMessage());
					Logger.err.println(user_id, this, e.getMessage());
				} finally {
					Release();
				}
				return getSepoaOut();
			}
			

			/**
			 * //Process별 Lead Time 쿼리
			 * @method et_getStaLTProcessList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
			public String et_getStaLTProcessList(Map<String, String> header) throws Exception { 
				String result = null;
				ConnectionContext ctx = getConnectionContext();
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				//wxp.addVar("house_code", house_code); 
				
				String flag                 = "0";
				String material_type 		= header.get("material_type");
				String material_ctrl_type 	= header.get("material_ctrl_type");
				String material_class1      = header.get("material_class1");
				
				
				if (!material_class1.equals("")) {			//material_class1
					flag = "3";
				} else if (!material_ctrl_type.equals("")) {	//material_ctrl_type
					flag = "2";
				} else if (!material_type.equals("")) {	//material_type
					flag = "1";
				}

				wxp.addVar("flag", flag); 
				
//				header.put("flag", flag);
				
				try {
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
					result = sm.doSelect(header);

					if (result == null)
						throw new Exception("SQLManager is null");
				} catch (Exception ex) {
					throw new Exception("et_getStaLTProcessList()" + ex.getMessage());
				}
				return result;
			}

			
			/**
			 * //매입현황
			 * @method getPurchaseAmtList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
		    public SepoaOut getPurchaseAmtList(Map<String, String> header)
		    {
		        try
		        {
		            String rtn = et_getPurchaseAmtList(header);
		            setStatus(1);
		            setValue(rtn);

		            setMessage(msg.getMessage("0000"));

		        }catch(Exception e) {
		            Logger.err.println(userid,this,e.getMessage());
		            setStatus(0);
		            setMessage(msg.getMessage("0001"));
		        }
		        return getSepoaOut();
		    }
			
		    /**
			 * //매입현황 쿼리
			 * @method et_getPurchaseAmtList
			 * @param  header
			 * @return Map
			 * @throws Exception
			 * @desc   
			 * @since  2014-11-25
			 * @modify 2014-11-25
			 */	
		    private String et_getPurchaseAmtList(Map<String, String> header) throws Exception
		    {
		        String rtn = null;
		        ConnectionContext ctx = getConnectionContext();

		        StringBuffer tSQL = new StringBuffer();
		        //String house_code = info.getSession("HOUSE_CODE");
		        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		        
		        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		        
		        try{
		            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

		            rtn = sm.doSelect(header);
		            
		        }catch(Exception e) {
		            //Logger.debug.println(userid,this,e.getMessage());
		            //Logger.debug.println(userid,this,tSQL.toString());
		            throw new Exception(e.getMessage());
		        }
		        return rtn;
		    }

		    public SepoaOut getScoHeader(String co_no)
		    {
		    	try
		    	{
		    		String rtn = et_getScoHeader(co_no);
		    		setStatus(1);
		    		setValue(rtn);
		    		
		    		setMessage(msg.getMessage("0000"));
		    		
		    	}catch(Exception e) {
		    		Logger.err.println(userid,this,e.getMessage());
		    		setStatus(0);
		    		setMessage(msg.getMessage("0001"));
		    	}
		    	return getSepoaOut();
		    }
	
		    private String et_getScoHeader(String co_no) throws Exception
		    {
		    	String rtn = null;
		    	ConnectionContext ctx = getConnectionContext();
		    	
		    	StringBuffer tSQL = new StringBuffer();
		    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		    	wxp.addVar("co_no", co_no);
		    	
		    	try{
		    		SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
		    		rtn = sm.doSelect();
		    		
		    	}catch(Exception e) {
		    		throw new Exception(e.getMessage());
		    	}
		    	return rtn;
		    }
		    public SepoaOut getScoDetail(String co_no)
		    {
		    	try
		    	{
		    		String rtn = et_getScoDetail(co_no);
		    		setStatus(1);
		    		setValue(rtn);
		    		
		    		setMessage(msg.getMessage("0000"));
		    		
		    	}catch(Exception e) {
		    		Logger.err.println(userid,this,e.getMessage());
		    		setStatus(0);
		    		setMessage(msg.getMessage("0001"));
		    	}
		    	return getSepoaOut();
		    }
		    
		    private String et_getScoDetail(String co_no) throws Exception
		    {
		    	String rtn = null;
		    	ConnectionContext ctx = getConnectionContext();
		    	
		    	StringBuffer tSQL = new StringBuffer();
		    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		    	wxp.addVar("co_no", co_no);
		    	
		    	try{
		    		SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
		    		rtn = sm.doSelect();
		    		
		    	}catch(Exception e) {
		    		throw new Exception(e.getMessage());
		    	}
		    	return rtn;
		    }
			
			
	/*
	
		//유지보수 계약현황
		public sepoa.srv.SepoaOut getStaServiceContList(String[] args) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaServiceContList(user_id, args);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//유지보수 계약현황 
		public String et_getStaServiceContList(String user_id, String[] args) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaServiceContList()" + ex.getMessage());
			}
			return result;
		}
		
		//외주인원 투입현황
		public sepoa.srv.SepoaOut getStaDeveloperInputList(String[] args) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaDeveloperInputList(user_id, args);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//외주인원 투입현황 
		public String et_getStaDeveloperInputList(String user_id, String[] args) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaDeveloperInputList()" + ex.getMessage());
			}
			return result;
		}
		
		//기간별 투입현황 
		public sepoa.srv.SepoaOut getStaDeveloperList(String[] args) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaDeveloperList(user_id, args);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//기간별 투입현황  
		public String et_getStaDeveloperList(String user_id, String[] args) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaDeveloperList()" + ex.getMessage());
			}
			return result;
		}

		

		//고객/품목별 구매현황
		public sepoa.srv.SepoaOut getStaProCustomerList(String[] args) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaProCustomerList(user_id, args);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//고객/품목별 구매현황
		public String et_getStaProCustomerList(String user_id, String[] args) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaProCustomerList()" + ex.getMessage());
			}
			return result;
		}

		
		//업체별 단가현황(용역) 
		public sepoa.srv.SepoaOut getStaUPVendorList(String[] args, String flag) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaUPVendorList(user_id, args, flag);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//업체별 단가현황(용역) 
		public String et_getStaUPVendorList(String user_id, String[] args, String flag) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			wxp.addVar("flag",       flag); 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaUPVendorList()" + ex.getMessage());
			}
			return result;
		}

		//용역 표준단가 준수율 
		public sepoa.srv.SepoaOut getStaUPStandardList(String[] args) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaUPStandardList(user_id, args);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//용역 표준단가 준수율 
		public String et_getStaUPStandardList(String user_id, String[] args) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaUPStandardList()" + ex.getMessage());
			}
			return result;
		}

		

		
		//대금지급계획 Outlook 
		public sepoa.srv.SepoaOut getStaDPScheduleList(String[] args) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaDPScheduleList(user_id, args);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//대금지급계획 Outlook 
		public String et_getStaDPScheduleList(String user_id, String[] args) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			//from_date
			String f_date = args[0].substring(0, 6) + "01";

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			wxp.addVar("f_date",     f_date);	 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaDPScheduleList()" + ex.getMessage());
			}
			return result;
		}

		//신규 거래업체 등록현황
		public sepoa.srv.SepoaOut getStaNewlyVendorList(String[] args) {
			String user_id = info.getSession("ID");
			try {
				String rtn = null;
				rtn = et_getStaNewlyVendorList(user_id, args);  
				setValue(rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			} catch (Exception e) {
				setStatus(0);
				setMessage(e.getMessage());
				Logger.err.println(user_id, this, e.getMessage());
			} finally {
				Release();
			}
			return getSepoaOut();
		}
		
		//신규 거래업체 등록현황
		public String et_getStaNewlyVendorList(String user_id, String[] args) throws Exception { 
			String result = null;
			ConnectionContext ctx = getConnectionContext();
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code); 
			
			try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

				result = sm.doSelect(args);

				if (result == null)
					throw new Exception("SQLManager is null");
			} catch (Exception ex) {
				throw new Exception("et_getStaNewlyVendorList()" + ex.getMessage());
			}
			return result;
		}
		
		//프로젝트별 선정결과
		public SepoaOut getProjectSelectList(String[] args)
	    {
	        try
	        {
	            String rtn = et_getProjectSelectList(args);
	            setStatus(1);
	            setValue(rtn);

	            setMessage(msg.getMessage("0000"));

	        }catch(Exception e) {
	            Logger.err.println(userid,this,e.getMessage());
	            setStatus(0);
	            setMessage(msg.getMessage("0001"));
	        }
	        return getSepoaOut();
	    }
		
		//프로젝트별 선정결과
	    private String et_getProjectSelectList(String[] args) throws Exception
	    {
	        String rtn = null;
	        ConnectionContext ctx = getConnectionContext();

	        StringBuffer tSQL = new StringBuffer();
	        //String house_code = info.getSession("HOUSE_CODE");
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        
	        try{
	            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

	            rtn = sm.doSelect(args);

	        }catch(Exception e) {
	            Logger.debug.println(userid,this,e.getMessage());
	            Logger.debug.println(userid,this,tSQL.toString());
	            throw new Exception(e.getMessage());
	        }
	        return rtn;
	    }
	    
	    
*/
}
