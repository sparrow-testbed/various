package admin.basic.approval2; 

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.DBOpenException;
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


public class p6011 extends SepoaService { 
	private Message msg; 
	
    public p6011(String opt, SepoaInfo info) throws SepoaServiceException{ 
        super(opt, info); 
        setVersion("1.0.0"); 
        msg = new Message(info,"FW");
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
 * 
 * @param args
 * @return
 */
	
    public SepoaOut getCountMainProcess() { 
    	try{ 
            
			String rtn_App    = null;
			String rtn_AppReq = null;
			String rtn_BrPr   = null;
			String rtn_Rfq    = null;
			String rtn_Bid    = null;
			String rtn_RA     = null;
			String rtn_Ex     = null;
			String rtn_Po     = null;
			String rtn_Ct     = null;
			String rtnIv      = null;
			String rtnVendor  = null;
			String rtnItem    = null;
			String rtnCsEv    = null;
			String rtnItem2    = null;
			String rtnPayOperateExpense  = null;
            String rtnPayOperate  = null;

			String rtn_Rfq_Sup= null;
			String rtn_Bid_Sup= null;
			String rtn_Rat_Sup= null;
			String rtn_Con_Sup= null;
			String rtn_Inv_Sup= null;
			String rtn_Not_Nml_Bid_Sup = null;
			String rtn_PurchaseBlockInfo = null;
			
			String from_date_1M = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), -1);
			String from_date_3M = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), -3);
			String to_date_1M = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), +1);
			String to_date      = SepoaDate.getShortDateString();
			
			if(!"S".equals(info.getSession("USER_TYPE"))){
				// 결재요청
				rtn_App = GetCountMainProcess_App(from_date_1M, to_date);
				setValue(rtn_App);
	
				// 결재상신
				rtn_AppReq = GetCountMainProcess_AppReq(from_date_1M, to_date);
				setValue(rtn_AppReq);
	
				
				
				// 사전지원,구매요청
				rtn_BrPr = GetCountMainProcess_BR_PR(from_date_1M, to_date);
				setValue(rtn_BrPr);
	
				// 견적진행
				rtn_Rfq = GetCountMainProcess_RFQ(from_date_1M, to_date);
				setValue(rtn_Rfq);
	
				// 품의대상
				rtn_Ex = GetCountMainProcess_EX(from_date_1M, to_date);
				setValue(rtn_Ex);
				
				// 발주대상
				rtn_Po = GetCountMainProcess_PO(from_date_3M, to_date);
				setValue(rtn_Po);
	
				// 검수대기
				rtnIv = GetCountMainProcess_IV(from_date_1M, to_date);
				setValue(rtnIv);
	
				// 업체승인대기
				rtnVendor = GetCountMainProcess_Vendor();
				setValue(rtnVendor);
		
				// 품목등록신청 
				rtnItem = GetCountMainProcess_Item(from_date_1M, to_date);
				setValue(rtnItem);
				
				// 공사평가대기
				rtnCsEv = GetCountMainProcess_CsEv();
				setValue(rtnCsEv);	
								
				// 경상비결의대상
				rtnPayOperateExpense = GetCountPayOperateExpense();
				setValue(rtnPayOperateExpense);								
				
				// 경상비집행대기
				rtnPayOperate = GetCountPayOperate();
				setValue(rtnPayOperate);	
				
				
				
/**						
			
			// 입찰
			rtn_Bid = GetCountMainProcess_BID(from_date_1M, to_date_1M);
			setValue(rtn_Bid);

			// 역경매
			rtn_RA = GetCountMainProcess_RA(from_date_1M, to_date);
			setValue(rtn_RA);

			// 계약대상
			rtn_Ct = GetCountMainProcess_CT(from_date_1M, to_date);
			setValue(rtn_Ct);
	
			rtnItem2 = GetCountMainProcess_Item2(from_date_1M, to_date);
			setValue(rtnItem2);
			
**/			
			
			//System.out.println("user_type =="+info.getSession("USER_TYPE"));
			
    		}
    		else{
				// 견적 공급사
				rtn_Rfq_Sup = GetCountMainProcess_RFQ_SUP(from_date_1M, to_date);
				setValue(rtn_Rfq_Sup);
							
				// 입찰 공급사
				rtn_Bid_Sup = GetCountMainProcess_BID_SUP(from_date_1M, to_date_1M);
				setValue(rtn_Bid_Sup);	
				
				// 역경매 공급사
				rtn_Rat_Sup = GetCountMainProcess_RAT_SUP(from_date_1M, to_date_1M);
				setValue(rtn_Rat_Sup);	
				
				// 계약 공급사
				rtn_Con_Sup = GetCountMainProcess_CON_SUP(from_date_1M, to_date);
				setValue(rtn_Con_Sup);	
				
				// 수주 공급사
				rtn_Inv_Sup = GetCountMainProcess_INV_SUP(from_date_1M, to_date);
				setValue(rtn_Inv_Sup);
				
				// 부적정입찰횟수(공사입찰)
				rtn_Not_Nml_Bid_Sup = GetCountMainProcess_NOT_NML_BID_SUP();				
				setValue(rtn_Not_Nml_Bid_Sup);
				
				// 입찰경고 , 입찰금지 알림
				rtn_PurchaseBlockInfo = GetPurchaseBlockInfo();				
				setValue(rtn_PurchaseBlockInfo);								
			}	
			
			
			setStatus(1); 
            setMessage(msg.getMessage("0000"));  
        }catch(Exception e){ 
            setStatus(0); 
            setMessage(msg.getMessage("0001")); 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    } 
 
	/**
	 * 결재요청
	 * 
	 * @Method Name : GetCountMainProcess_App
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_App(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, user_id, from_date, to_date};

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_App===>" + e.getMessage());
		}
		return rtn;
	}

	/**
	 * 결재상신
	 * 
	 * @Method Name : GetCountMainProcess_AppReq
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_AppReq(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, user_id, from_date, to_date };
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_AppReq:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 사전지원요청/구매요청
	 * 
	 * @Method Name : GetCountMainProcess_BR_PR
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_BR_PR(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		String ctrl_code = info.getSession("CTRL_CODE");
		String str = "";
		String spl = "";

		try {
			if( ctrl_code != null && ctrl_code.length() > 0 ){
				String[] strCtrl = ctrl_code.split("&");
				if(strCtrl != null && strCtrl.length > 0){
					for(int i = 0; i < strCtrl.length; i++){
						spl = "";
						Logger.debug.println("CTRL_CODE >> "+i+"== "+strCtrl[i]);
						if(i != strCtrl.length - 1){
							spl = ", ";
						}
						str = strCtrl[i] + spl;
					}
				}
				
			}
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("ctrl_code", "'"+ str + "'");
			wxp.addVar("ctrl_code1", str);
			wxp.addVar("user_id", user_id);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			
			String[] args = { house_code, from_date, to_date };
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_BR_PR:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 견적
	 * 
	 * @Method Name : GetCountMainProcess_RFQ_BID_RA
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_RFQ(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, from_date, to_date, user_id };
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_RFQ:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	

	/**
	 * 입찰
	 * 
	 * @Method Name : GetCountMainProcess_RFQ_BID_RA
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_BID(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, from_date, to_date, user_id };
			
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_BID:" + e.getMessage());
		} finally {
		}
		return rtn;
	}


	/**
	 * 역경매
	 * 
	 * @Method Name : GetCountMainProcess_RA
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_RA(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, from_date, to_date, user_id };
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_RA:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 품의대상
	 * 
	 * @Method Name : GetCountMainProcess_EX
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_EX(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String user_id    = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" 	, house_code);
			wxp.addVar("user_id"		, user_id);
			wxp.addVar("from_date"		, from_date);
			wxp.addVar("to_date"		, to_date);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			
			rtn = sm.doSelect();

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_EX:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 발주대상
	 * 
	 * @Method Name : GetCountMainProcess_PO
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_PO(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String user_id    = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String dept_id    = info.getSession("DEPARTMENT");
		String ctrl_code  = info.getSession("CTRL_CODE").replaceAll("&", "");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" 	, house_code);
			wxp.addVar("user_id"		, user_id);
//			wxp.addVar("dept_id"		, dept_id);
//			wxp.addVar("ctrl_code"	    , ctrl_code);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { from_date, to_date };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_PO:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 계약대상
	 * 
	 * @Method Name : GetCountMainProcess_CT
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_CT(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String user_id    = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, from_date, to_date, user_id };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_CT:" + e.getMessage());
		} finally {
		}

		return rtn;
	}
	
	/**
	 * 검수대기
	 * 
	 * @Method Name : GetCountMainProcess_IV
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_IV(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		String dept_id    = info.getSession("DEPARTMENT");

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

//			String[] args = { house_code, from_date, to_date, dept_id, user_id };
			String[] args = { house_code, from_date, to_date, user_id };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_IV:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * 업체승인대기
	 * 
	 * @Method Name : GetCountMainProcess_Vendor
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_Vendor() throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_Vendor:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 품목등록건수
	 * 
	 * @Method Name : GetCountMainProcess_Item
	 * @작성일 : 2010. 06. 01
	 * @작성자 : ICOMPIA
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_Item(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = {  house_code, from_date, to_date };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_Item:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * 공사평가대기
	 * 
	 * @Method Name : GetCountMainProcess_CsEv
	 * @작성일 : 2021. 07. 29
	 * @작성자 : 운영자
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_CsEv() throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, user_id };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_CsEv:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	private String GetCountMainProcess_Item2(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, user_id};

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_Item2:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
    
	
	/**
	 * 견적공급사
	 * 
	 * @Method Name : GetCountMainProcess_RFQ_SUP
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_RFQ_SUP(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		
		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		String vendor_code = info.getSession("COMPANY_CODE");
		Map<String, String> param = new HashMap<String, String>();
		
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			param.put("house_code", house_code);
			param.put("vendor_code"   , vendor_code);
			
			//String[] args = { house_code, house_code, user_id, house_code, user_id };
			rtn = sm.doSelect(param);
			
			if (rtn == null)
				throw new Exception("SQL Manager is Null");
			
		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_RFQ_SUP:" + e.getMessage());
		} finally {
		}
		return rtn;
	}


	/**
	 * 입찰
	 * 
	 * @Method Name : GetCountMainProcess_BID_SUP
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_BID_SUP(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code  = info.getSession("HOUSE_CODE");
		String user_id     = info.getSession("ID");
		String vendor_code = info.getSession("COMPANY_CODE");
		Map<String, String> param = new HashMap<String, String>();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			param.put("house_code"    , house_code);
			param.put("vendor_code"   , vendor_code);
			param.put("user_id"       , user_id);
			param.put("from_date"     , from_date);
			param.put("to_date"       , to_date);
			
			rtn = sm.doSelect(param);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_BID:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * 부적정입찰횟수(공사입찰)
	 * 
	 * @Method Name : GetCountMainProcess_NOT_NML_BID_SUP
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_NOT_NML_BID_SUP() throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code  = info.getSession("HOUSE_CODE");
		String user_id     = info.getSession("ID");
		String vendor_code = info.getSession("COMPANY_CODE");
		
		int cYear  = SepoaDate.getYear();
		int cMonth = SepoaDate.getMonth();
		
		String pn_ud = (cMonth < 7)?"0106":"0712";
		  
		Map<String, String> param = new HashMap<String, String>();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			param.put("house_code"    , house_code);
			param.put("vendor_code"   , vendor_code);
			param.put("pn_yy"         ,	"" + cYear);  
			param.put("pn_ud"         ,	pn_ud);     
			
			rtn = sm.doSelect(param);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_NOT_NML_BID:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * 업체 입찰경고,입찰금지 알림
	 * 
	 * @Method Name : GetPurchaseBlockInfo
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetPurchaseBlockInfo() throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code  = info.getSession("HOUSE_CODE");
		String user_id     = info.getSession("ID");
		String vendor_code = info.getSession("COMPANY_CODE");
		
		  
		Map<String, String> param = new HashMap<String, String>();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			param.put("house_code"    , house_code);
			param.put("vendor_code"   , vendor_code);
			
			rtn = sm.doSelect(param);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_NOT_NML_BID:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/**
	 * 역경매
	 * 
	 * @Method Name : GetCountMainProcess_RAT_SUP
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_RAT_SUP(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code  = info.getSession("HOUSE_CODE");
		String user_id     = info.getSession("ID");
		String vendor_code = info.getSession("COMPANY_CODE");
		Map<String, String> param = new HashMap<String, String>();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			//String[] args = { house_code, from_date, to_date, user_id };
			param.put("house_code"    , house_code);
			param.put("vendor_code"   , vendor_code);
			param.put("user_id"       , user_id);
			param.put("from_date"     , from_date);
			param.put("to_date"       , to_date);
			
			rtn = sm.doSelect(param);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_RAT:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 계약
	 * 
	 * @Method Name : GetCountMainProcess_CON_SUP
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_CON_SUP(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code  = info.getSession("HOUSE_CODE");
		String user_id     = info.getSession("ID");
		String vendor_code = info.getSession("COMPANY_CODE");
		Map<String, String> param = new HashMap<String, String>();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			//String[] args = { house_code, from_date, to_date, user_id };
			param.put("house_code"    , house_code);
			param.put("vendor_code"   , vendor_code);
			param.put("user_id"       , user_id);
			param.put("from_date"     , from_date);
			param.put("to_date"       , to_date);
			
			rtn = sm.doSelect(param);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_CON:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 수주
	 * 
	 * @Method Name : GetCountMainProcess_INV_SUP
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountMainProcess_INV_SUP(String from_date, String to_date) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code  = info.getSession("HOUSE_CODE");
		String user_id     = info.getSession("ID");
		String vendor_code = info.getSession("COMPANY_CODE");
		Map<String, String> param = new HashMap<String, String>();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			//String[] args = { house_code, from_date, to_date, user_id };
			param.put("house_code"    , house_code);
			param.put("vendor_code"   , vendor_code);
			param.put("user_id"       , user_id);
			param.put("from_date"     , from_date);
			param.put("to_date"       , to_date);
			
			rtn = sm.doSelect(param);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("GetCountMainProcess_INV:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
    
/*    private String et_getCountMainProcess(Map<String, String> header) throws Exception { 
        String rtn = ""; 
		ConnectionContext ctx =	getConnectionContext();  
		String id = info.getSession("USER_ID");
//		String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
		
		try	{  
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			//header.put("cur_date_time", cur_date_time);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			header.put("id", id);
			
			rtn	= sm.doSelect(header);  
  
			if(rtn == null)	throw new Exception("SQL Manager is	Null");  
		}catch(Exception e)	{  
			
		  throw	new	Exception("et_getItemList=========>"+e.getMessage());  
		} finally{  
		}  
		return rtn; 
    } */
    
	/**
	 * 경상비 결의대기
	 * 
	 * @Method Name : GetCountPayOperateExpense
	 * @작성일 : 2022. 11. 16
	 * @작성자 : 운영자
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountPayOperateExpense() throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		String dept       = info.getSession("DEPARTMENT");
		
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, dept };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountPayOperateExpense:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * 경상비 집행대기
	 * 
	 * @Method Name : GetCountPayOperate
	 * @작성일 : 2022. 11. 16
	 * @작성자 : 운영자
	 * @변경이력 :
	 * @Method 설명 :
	 * @return
	 * @throws Exception
	 */
	private String GetCountPayOperate() throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			String[] args = { house_code, user_id, house_code, user_id, house_code };

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("GetCountPayOperate:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
}