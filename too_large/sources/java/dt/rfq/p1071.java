 package	dt.rfq; 
 
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.commons.collections.MapUtils;

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

import com.icompia.util.CommonUtil;
 
public class p1071 extends SepoaService { 
 
	String lang	= ""; 
	Message	msg	= null; 
 
	public p1071(String	opt, SepoaInfo info)	throws SepoaServiceException	{ 
		super(opt, info); 
		setVersion("1.0.0"); 
 
		//String lang	= info.getSession("LANGUAGE"); 
		msg	= new Message(info,"STDQTA"); 
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

/**************************************************************************/ 
	public String checkNull(String value) { 
        if(value == null || value.trim().equals(""))
        	value = null;
        
		return value; 
	} 
 
	public SepoaOut	getQuery_RFQNO() 
	{ 
		String house_code =	info.getSession("HOUSE_CODE"); 
		String ctrl_code = "";//info.getSession("CTRL_CODE"); 
 
		String rtn = ""; 
		ConnectionContext ctx =	getConnectionContext(); 
		try	{ 
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 
			String[] args =	{CommonUtil.getCtrlCodes(ctrl_code), house_code}; 
			rtn	= sm.doSelect(args); 
 
			setValue(rtn); 
			setStatus(1); 
		}catch (Exception e){ 
			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage()); 
			setStatus(0); 
		} 
		return getSepoaOut(); 
	} 
	
	
	
	public SepoaOut getRfqHistory(Map<String, String> header) throws Exception {
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            rtn                   = null;
		String            id                    = info.getSession("ID");
		
		try{
			
			sxp = new SepoaXmlParser(this, "getRfqHistory");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	rtn = ssm.doSelect(header);
        	setValue(rtn);

		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * 조회전 조회 조건 셋팅
	 * @method getQtaDispDT
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	public SepoaOut getQtaDispDT(Map<String, String> header) throws Exception{ 
	    try{ 
            String rtn = et_getQtaDispDT(header); 
            setValue(rtn); 
            setStatus(1); 
            setMessage(msg.getMessage("0003"));  
        }catch(Exception e){ 
            setStatus(0); 
            setMessage(msg.getMessage("0005")); 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
        } 
        return getSepoaOut(); 
    }
    
    private String et_getQtaDispDT(Map<String, String> header) throws Exception { 
        String rtn = null; 
        ConnectionContext ctx = getConnectionContext(); 
        
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        StringBuffer sql = new StringBuffer();

		try {	
  
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
            Logger.err.println(info.getSession("ID"),this,sql.toString());  
  
            //String[] args = {info.getSession("HOUSE_CODE"), QTA_NO, VENDOR_CODE, VENDOR_CODE};
            rtn = sm.doSelect(header);  
		}catch(Exception e) { 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
            throw new Exception(e.getMessage()); 
        } 
        return rtn; 
	}
	
	
	
	/* public SepoaOut getRfqHistory (String[] args, String RFQ_FLAG){
	        try{
	        	String rtn = et_getRfqHistory(args, RFQ_FLAG);
	            setValue(rtn);
	            setStatus(1);
	            setMessage(msg.getMessage("0003"));
	        }catch(Exception e){
	            setStatus(0);
	            setMessage(msg.getMessage("0005"));
	            Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        }
	        return getSepoaOut();
	    }

		private	String et_getRfqHistory(String[] args, String RFQ_FLAG) throws Exception
		{
	    	String rtn = null;
			String ctrl_code	= info.getSession("CTRL_CODE"); 
			String purchaserUser_seperate=""; 
				StringTokenizer	st1	= new StringTokenizer(ctrl_code,"&",false); 
				int	count1 =  st1.countTokens(); 
	 
				for( int i =0; i< count1; i++ ) 
				{ 
					String tmp_ctrl_code = st1.nextToken(); 
	 
					if(	i == 0 ) 
						purchaserUser_seperate = tmp_ctrl_code; 
					else 
						purchaserUser_seperate += "','"+tmp_ctrl_code; 
	 
				} 
	        ConnectionContext ctx = getConnectionContext();
	        
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("purchaserUser_seperate", purchaserUser_seperate);
			wxp.addVar("RFQ_FLAG", RFQ_FLAG);


	 		try{
	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	            rtn = sm.doSelect(args);
	        }catch(Exception e) {
	            Logger.err.println(info.getSession("ID"),this,e.getMessage());
	            throw new Exception(e.getMessage());
	        }
	        return rtn;
	    }    
		*/
		
		/*public SepoaOut getQtaDispDT(String VENDOR_CODE, String QTA_NO) { 
		    try{ 
	            String rtn = et_getQtaDispDT(VENDOR_CODE, QTA_NO); 
	            setValue(rtn); 
	            setStatus(1); 
	            setMessage(msg.getMessage("0003"));  
	        }catch(Exception e){ 
	            setStatus(0); 
	            setMessage(msg.getMessage("0005")); 
	            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
	        } 
	        return getSepoaOut(); 
	    }
	    
	    private String et_getQtaDispDT(String VENDOR_CODE, String QTA_NO) throws Exception { 
	        String rtn = null; 
	        ConnectionContext ctx = getConnectionContext(); 
	        
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        StringBuffer sql = new StringBuffer();

			try {	
	  
	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
	            Logger.err.println(info.getSession("ID"),this,sql.toString());  
	  
	            String[] args = {info.getSession("HOUSE_CODE"), QTA_NO, VENDOR_CODE, VENDOR_CODE};  
	            rtn = sm.doSelect(args);  
			}catch(Exception e) { 
	            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
	            throw new Exception(e.getMessage()); 
	        } 
	        return rtn; 
		}*/
		
    public SepoaOut getRfqEP_qta(String rfq_no, String rfq_count, String rfq_seq, String vendor_code)   throws Exception  
    {  
        try{  
            String rtn = et_getRfqEP_qta(rfq_no,rfq_count,rfq_seq,vendor_code);

			SepoaFormater wf = new SepoaFormater(rtn);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0006"));
			else {
				setMessage(msg.getMessage("0003"));
			}
			
            setValue(rtn);  
            setStatus(1);  
  
        }catch(Exception e) {  
            setStatus(0);  
            setMessage(msg.getMessage("0005"));  
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
            throw new Exception(e.getMessage()); 
        }  
        return getSepoaOut();  
    }  

    private String et_getRfqEP_qta( String rfq_no,String rfq_count,String rfq_seq,String vendor_code) throws Exception  
    {  
        String rtn = null;  
        ConnectionContext ctx = getConnectionContext();  
  
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
         
        try{  
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, rfq_seq, vendor_code};
            rtn = sm.doSelect(data);  
        }catch(Exception e) {  
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
            throw new Exception(e.getMessage()); 
        }  
        return rtn;  
    }    
    
    public SepoaOut  getQuery_RFQVENDOR(String RFQ_NO, String RFQ_COUNT)
    {
        String house_code            =  info.getSession("HOUSE_CODE");
        String rtn = "";
        ConnectionContext ctx = getConnectionContext();
        try {
/*        	
            StringBuffer sql = new StringBuffer();

            sql.append(" SELECT  ROWNUM AS R_NUM,                                                   \n");
            sql.append("       TEMP.VENDOR_CODE,                                                    \n");
            sql.append("       TEMP.NAME                                                            \n");
            sql.append(" FROM(SELECT DISTINCT                                                       \n");
            sql.append("             RS.HOUSE_CODE,                                                 \n");
            sql.append("             RS.RFQ_NO,                                                     \n");
            sql.append("             RS.RFQ_COUNT,                                                  \n");
            sql.append("             RS.VENDOR_CODE,                                                \n");
            sql.append("             GETCOMPANYNAMELOC(RS.HOUSE_CODE, RS.VENDOR_CODE, 'S') AS NAME  \n");
            sql.append("      FROM ICOYRQSE RS                                                      \n");
            sql.append("    <OPT=S,S>  WHERE HOUSE_CODE = ? </OPT>                                  \n");
            sql.append("    <OPT=S,S>  AND   RFQ_NO     = ? </OPT>                                  \n");
            sql.append("    <OPT=S,N>  AND   RFQ_COUNT  = ? </OPT>                                  \n");
            sql.append("      ORDER BY RS.VENDOR_CODE) TEMP                                         \n");
*/            
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] args = {house_code, RFQ_NO, RFQ_COUNT};
            rtn = sm.doSelect(args);

            setValue(rtn);
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            setStatus(0);
        }
        return getSepoaOut();
    }	
    
    public SepoaOut getQtaCreateHD(String RFQ_NO, String RFQ_COUNT, String VENDOR_CODE) 
	{ 
		try	{ 
			SepoaFormater wf = null;
			String rtn = "";

			rtn = et_getFlagQTACreate(RFQ_NO, RFQ_COUNT, VENDOR_CODE);	
			wf = new SepoaFormater(rtn);	
			if(wf.getRowCount() > 0){
				if(Integer.parseInt(wf.getValue("QTA_CNT", 0)) == 0) {
					rtn	= et_getQtaCreateHDRFQ(RFQ_NO, RFQ_COUNT, VENDOR_CODE); 
				} else {
					rtn	= et_getQtaCreateHDQTA(RFQ_NO, RFQ_COUNT, VENDOR_CODE); 
				}
			}

			//Commit();
			setValue(rtn); 

		}catch (Exception e){ 
			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage()); 
	        //try{  
	        //    Rollback();  
	        //}catch(Exception e1){}  		
		}
		return getSepoaOut(); 
	} 
    
    private	String	chkRFQCntSecond(String RFQ_NO) throws Exception 
	{ 
		String rtn = ""; 
		ConnectionContext ctx =	getConnectionContext(); 
 
		try	{ 
/*			
			StringBuffer sql = new StringBuffer(); 
 
			sql.append("	SELECT	COUNT(*) AS RFQ_CNT   	        \n"); 
			sql.append("	FROM ICOYRQHD						    \n"); 
			sql.append("	<OPT=S,S> WHERE HOUSE_CODE = ?	</OPT>  \n"); 
			sql.append("	<OPT=S,S> AND	RFQ_NO     = ?	</OPT> 	\n"); 
			sql.append("	AND	RFQ_COUNT	 = 2				    \n"); 
*/ 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 
			String[] args =	{info.getSession("HOUSE_CODE"), RFQ_NO}; 
			rtn	= sm.doSelect(args); 
 
			if(rtn == null)	throw new Exception("SQL Manager is	Null"); 
		}catch(Exception e)	{ 
			throw new Exception("chkRFQCntSecond=========>"+e.getMessage()); 
		} finally{ 
		} 
		return rtn; 
	} 
    
    private	int	et_setAutoCreate(String RFQ_NO, String RFQ_COUNT)	throws Exception 
	{ 
 
		int	rtn	= -1; 
 
		ConnectionContext ctx =	getConnectionContext(); 
		try	{ 
 
			StringBuffer sql = new StringBuffer(); // RQHD INSERT 
 
			sql.append(" INSERT INTO ICOYRQHD (                    \n");           
			sql.append(" 		 HOUSE_CODE                        \n");           
			sql.append(" 		,RFQ_NO                            \n");           
			sql.append(" 		,RFQ_COUNT                         \n");           
			sql.append(" 		,STATUS                            \n");           
			sql.append(" 		,COMPANY_CODE                      \n");           
			sql.append(" 		,RFQ_DATE                          \n");           
			sql.append(" 		,RFQ_CLOSE_DATE                    \n");           
			sql.append(" 		,RFQ_CLOSE_TIME                    \n");           
			sql.append(" 		,RFQ_TYPE                          \n");           
			sql.append(" 		,SETTLE_TYPE                       \n");           
			sql.append(" 		,BID_TYPE                          \n");           
			sql.append(" 		,RFQ_FLAG                          \n");           
			sql.append(" 		,TERM_CHANGE_FLAG                  \n");           
			sql.append(" 		,CREATE_TYPE                       \n");           
			sql.append(" 		,BID_COUNT                         \n");           
			sql.append(" 		,CTRL_CODE                         \n");           
			sql.append(" 		,ADD_USER_ID                       \n");           
			sql.append(" 		,ADD_DATE                          \n");           
			sql.append(" 		,ADD_TIME                          \n");           
			sql.append(" 		,CHANGE_DATE                       \n");           
			sql.append(" 		,CHANGE_TIME                       \n");           
			sql.append(" 		,CHANGE_USER_ID                    \n");           
			sql.append(" 		,SUBJECT                           \n");           
			sql.append(" 		,REMARK                            \n");           
			sql.append(" 		,DOM_EXP_FLAG                      \n");           
			sql.append(" 		,ARRIVAL_PORT                      \n");           
			sql.append(" 		,USANCE_DAYS                       \n");           
			sql.append(" 		,SHIPPING_METHOD                   \n");           
			sql.append(" 		,PAY_TERMS                         \n");           
			sql.append(" 		,ARRIVAL_PORT_NAME                 \n");           
			sql.append(" 		,DELY_TERMS                        \n");           
			sql.append(" 		,PRICE_TYPE                        \n");           
			sql.append(" 		,SETTLE_COUNT                      \n");           
			sql.append(" 		,RESERVE_PRICE                     \n");           
			sql.append(" 		,CURRENT_PRICE                     \n");           
			sql.append(" 		,BID_DEC_AMT                       \n");           
			sql.append(" 		,TEL_NO                            \n");           
			sql.append(" 		,EMAIL                             \n");           
			sql.append(" 		,BD_TYPE                           \n");           
			sql.append(" 		,CUR                               \n");           
			sql.append(" 		,START_DATE                        \n");           
			sql.append(" 		,START_TIME                        \n");
			sql.append(" 		,SIGN_STATUS                       \n");
			sql.append(" 		,SIGN_PERSON_ID                    \n");
			sql.append(" 		,SIGN_DATE                         \n");

			
			sql.append(" 		,Z_SMS_SEND_FLAG                   \n");
			sql.append(" 		,Z_RESULT_OPEN_FLAG                \n");
			
			sql.append(" )                                         \n");
			sql.append(" SELECT                                    \n");
			sql.append(" 		 HOUSE_CODE                        \n");           
			sql.append(" 		,RFQ_NO                            \n");           
			sql.append(" 		,2                                 \n");   
			sql.append(" 		,STATUS                            \n");           
			sql.append(" 		,COMPANY_CODE                      \n");           
			sql.append(" 		,RFQ_DATE                          \n");           
			sql.append(" 		,RFQ_CLOSE_DATE                    \n");           
			sql.append(" 		,RFQ_CLOSE_TIME                    \n");           
			sql.append(" 		,RFQ_TYPE                          \n");           
			sql.append(" 		,SETTLE_TYPE                       \n");           
			sql.append(" 		,BID_TYPE                          \n");           
			sql.append(" 		,RFQ_FLAG                          \n");           
			sql.append(" 		,TERM_CHANGE_FLAG                  \n");           
			sql.append(" 		,CREATE_TYPE                       \n");           
			sql.append(" 		,BID_COUNT                         \n");           
			sql.append(" 		,CTRL_CODE                         \n");           
			sql.append(" 		,ADD_USER_ID                       \n");           
			sql.append(" 		,?                                 \n");    
			sql.append(" 		,?                                 \n");
			sql.append(" 		,?                                 \n");
			sql.append(" 		,?                                 \n");
			sql.append(" 		,CHANGE_USER_ID                    \n");           
			sql.append(" 		,SUBJECT                           \n");           
			sql.append(" 		,REMARK                            \n");           
			sql.append(" 		,DOM_EXP_FLAG                      \n");           
			sql.append(" 		,ARRIVAL_PORT                      \n");           
			sql.append(" 		,USANCE_DAYS                       \n");           
			sql.append(" 		,SHIPPING_METHOD                   \n");           
			sql.append(" 		,PAY_TERMS                         \n");           
			sql.append(" 		,ARRIVAL_PORT_NAME                 \n");           
			sql.append(" 		,DELY_TERMS                        \n");           
			sql.append(" 		,PRICE_TYPE                        \n");           
			sql.append(" 		,SETTLE_COUNT                      \n");           
			sql.append(" 		,RESERVE_PRICE                     \n");           
			sql.append(" 		,CURRENT_PRICE                     \n");           
			sql.append(" 		,BID_DEC_AMT                       \n");           
			sql.append(" 		,TEL_NO                            \n");           
			sql.append(" 		,EMAIL                             \n");           
			sql.append(" 		,BD_TYPE                           \n");           
			sql.append(" 		,CUR                               \n");           
			sql.append(" 		,START_DATE                        \n");           
			sql.append(" 		,START_TIME                        \n");
			sql.append(" 		,SIGN_STATUS                       \n");
			sql.append(" 		,SIGN_PERSON_ID                    \n");
			sql.append(" 		,?                                 \n");
			sql.append(" 		,Z_SMS_SEND_FLAG                   \n");
			sql.append(" 		,Z_RESULT_OPEN_FLAG                \n");

			sql.append(" FROM ICOYRQHD	                           \n");
			sql.append(" WHERE HOUSE_CODE	= ?                    \n");
			sql.append(" AND   RFQ_NO		= ?                    \n");
			sql.append(" AND   RFQ_COUNT  	= ?                    \n");
			
			SepoaSQLManager sm =	new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString()); 
			String[][] setRqhd = {{SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, SepoaDate.getShortDateString()
								, info.getSession("HOUSE_CODE")
								, RFQ_NO
								, RFQ_COUNT
								}};
			
			String[] type_rqhd = {"S", "S", "S", "S", "S"
								, "S", "S", "N"};
			rtn	= sm.doInsert(setRqhd, type_rqhd); 
 
			sql	= new StringBuffer();  // RQDT INSERT 
 
			sql.append("	 INSERT INTO ICOYRQDT (             \n");
			sql.append("	 		 HOUSE_CODE                 \n");
			sql.append("	 		,RFQ_NO                     \n");
			sql.append("	 		,RFQ_COUNT                  \n");
			sql.append("	 		,RFQ_SEQ                    \n");
			sql.append("	 		,STATUS                     \n");
			sql.append("	 		,COMPANY_CODE               \n");
			sql.append("	 		,PLANT_CODE                 \n");
			sql.append("	 		,RFQ_PROCEEDING_FLAG        \n");
			sql.append("	 		,ADD_DATE                   \n");
			sql.append("	 		,ADD_TIME                   \n");
			sql.append("	 		,ADD_USER_ID                \n");
			sql.append("	 		,CHANGE_DATE                \n");
			sql.append("	 		,CHANGE_TIME                \n");
			sql.append("	 		,CHANGE_USER_ID             \n");
			sql.append("	 		,ITEM_NO                    \n");
			sql.append("	 		,UNIT_MEASURE               \n");
			sql.append("	 		,RD_DATE                    \n");
			sql.append("	 		,VALID_FROM_DATE            \n");
			sql.append("	 		,VALID_TO_DATE              \n");
			sql.append("	 		,PURCHASE_PRE_PRICE         \n");
			sql.append("	 		,RFQ_QTY                    \n");
			sql.append("	 		,RFQ_AMT                    \n");
			sql.append("	 		,BID_COUNT                  \n");
			sql.append("	 		,CUR                        \n");
			sql.append("	 		,PR_NO                      \n");
			sql.append("	 		,PR_SEQ                     \n");
			sql.append("	 		,SETTLE_FLAG                \n");
			sql.append("	 		,SETTLE_QTY                 \n");
			sql.append("	 		,TBE_FLAG                   \n");
			sql.append("	 		,TBE_DEPT                   \n");
			sql.append("	 		,PRICE_TYPE                 \n");
			sql.append("	 		,TBE_PROCEEDING_FLAG        \n");
			sql.append("	 		,SAMPLE_FLAG                \n");
			sql.append("	 		,DELY_TO_LOCATION           \n");
			sql.append("	 		,ATTACH_NO                  \n");
			sql.append("	 		,SHIPPER_TYPE               \n");
			sql.append("	 		,CONTRACT_FLAG              \n");
			sql.append("	 		,COST_COUNT                 \n");
			sql.append("	 		,YEAR_QTY                   \n");
			sql.append("	 		,DELY_TO_ADDRESS            \n");
			sql.append("	 		,MIN_PRICE                  \n");
			sql.append("	 		,MAX_PRICE                  \n");
			sql.append("	 		,STR_FLAG                   \n");
			sql.append("	)                                   \n");
			sql.append("	SELECT                              \n");
			sql.append("	 		 HOUSE_CODE                 \n");
			sql.append("	 		,RFQ_NO                     \n");
			sql.append("	 		,2                          \n");
			sql.append("	 		,RFQ_SEQ                    \n");
			sql.append("	 		,STATUS                     \n");
			sql.append("	 		,COMPANY_CODE               \n");
			sql.append("	 		,PLANT_CODE                 \n");
			sql.append("	 		,RFQ_PROCEEDING_FLAG        \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,ADD_USER_ID                \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,CHANGE_USER_ID             \n");
			sql.append("	 		,ITEM_NO                    \n");
			sql.append("	 		,UNIT_MEASURE               \n");
			sql.append("	 		,RD_DATE                    \n");
			sql.append("	 		,VALID_FROM_DATE            \n");
			sql.append("	 		,VALID_TO_DATE              \n");
			sql.append("	 		,PURCHASE_PRE_PRICE         \n");
			sql.append("	 		,RFQ_QTY                    \n");
			sql.append("	 		,RFQ_AMT                    \n");
			sql.append("	 		,BID_COUNT                  \n");
			sql.append("	 		,CUR                        \n");
			sql.append("	 		,PR_NO                      \n");
			sql.append("	 		,PR_SEQ                     \n");
			sql.append("	 		,SETTLE_FLAG                \n");
			sql.append("	 		,SETTLE_QTY                 \n");
			sql.append("	 		,TBE_FLAG                   \n");
			sql.append("	 		,TBE_DEPT                   \n");
			sql.append("	 		,PRICE_TYPE                 \n");
			sql.append("	 		,TBE_PROCEEDING_FLAG        \n");
			sql.append("	 		,SAMPLE_FLAG                \n");
			sql.append("	 		,DELY_TO_LOCATION           \n");
			sql.append("	 		,ATTACH_NO                  \n");
			sql.append("	 		,SHIPPER_TYPE               \n");
			sql.append("	 		,CONTRACT_FLAG              \n");
			sql.append("	 		,COST_COUNT                 \n");
			sql.append("	 		,YEAR_QTY                   \n");
			sql.append("	 		,DELY_TO_ADDRESS            \n");
			sql.append("	 		,MIN_PRICE                  \n");
			sql.append("	 		,MAX_PRICE                  \n");
			sql.append("	 		,STR_FLAG                   \n");
			sql.append("	FROM ICOYRQDT                       \n");
			sql.append("	WHERE HOUSE_CODE = ?                \n");
			sql.append("	AND   RFQ_NO     = ?                \n");
			sql.append("	AND   RFQ_COUNT  = ?		 	    \n");
 
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString()); 
			String[][] setRqdt = {{SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, info.getSession("HOUSE_CODE")
								, RFQ_NO
								, RFQ_COUNT
								}};

			String[] type_rqdt = {"S", "S", "S", "S", "S"
								, "S", "N"};
			rtn	= sm.doInsert(setRqdt, type_rqdt); 
			
			sql	= new StringBuffer();  // RQOP INSERT 
			 
			sql.append("	 INSERT INTO ICOYRQOP (         \n");
			sql.append("	 		 HOUSE_CODE             \n");
			sql.append("	 		,RFQ_NO                 \n");
			sql.append("	 		,RFQ_COUNT              \n");
			sql.append("	 		,RFQ_SEQ                \n");
			sql.append("	 		,PURCHASE_LOCATION      \n");
			sql.append("	 		,VENDOR_CODE            \n");
			sql.append("	 		,STATUS                 \n");
			sql.append("	 		,ADD_USER_ID            \n");
			sql.append("	 		,ADD_DATE               \n");
			sql.append("	 		,ADD_TIME               \n");
			sql.append("	 		,CHANGE_DATE            \n");
			sql.append("	 		,CHANGE_TIME            \n");
			sql.append("	 		,CHANGE_USER_ID         \n");
			sql.append("	 )                              \n");
			sql.append("	 SELECT                         \n");
			sql.append("	 		 HOUSE_CODE             \n");
			sql.append("	 		,RFQ_NO                 \n");
			sql.append("	 		,2                      \n");
			sql.append("	 		,RFQ_SEQ                \n");
			sql.append("	 		,PURCHASE_LOCATION      \n");
			sql.append("	 		,VENDOR_CODE            \n");
			sql.append("	 		,STATUS                 \n");
			sql.append("	 		,ADD_USER_ID            \n");
			sql.append("	 		,?                      \n");
			sql.append("	 		,?                      \n");
			sql.append("	 		,?                      \n");
			sql.append("	 		,?                      \n");
			sql.append("	 		,CHANGE_USER_ID         \n");
			sql.append("	 FROM ICOYRQOP                  \n");
			sql.append("	 WHERE HOUSE_CODE = ?           \n");
			sql.append("	 AND   RFQ_NO     = ?           \n");
			sql.append("	 AND   RFQ_COUNT  = ?		 	\n");			 
 
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString()); 
			String[][] setRqop = {{SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, info.getSession("HOUSE_CODE")
								, RFQ_NO
								, RFQ_COUNT
								}};
			
			String[] type_rqop = {"S", "S", "S", "S", "S"
								, "S", "N"};
			rtn	= sm.doInsert(setRqop, type_rqop); 
 
			sql	= new StringBuffer();  // RQSE INSERT 
 
			sql.append("	 INSERT INTO ICOYRQSE (             \n");
			sql.append("	 		 HOUSE_CODE                 \n");
			sql.append("	 		,VENDOR_CODE                \n");
			sql.append("	 		,RFQ_NO                     \n");
			sql.append("	 		,RFQ_COUNT                  \n");
			sql.append("	 		,RFQ_SEQ                    \n");
			sql.append("	 		,STATUS                     \n");
			sql.append("	 		,COMPANY_CODE               \n");
			sql.append("	 		,CONFIRM_FLAG               \n");
			sql.append("	 		,CONFIRM_DATE               \n");
			sql.append("	 		,CONFIRM_USER_ID            \n");
			sql.append("	 		,BID_FLAG                   \n");
			sql.append("	 		,ADD_DATE                   \n");
			sql.append("	 		,ADD_USER_ID                \n");
			sql.append("	 		,ADD_TIME                   \n");
			sql.append("	 		,CHANGE_DATE                \n");
			sql.append("	 		,CHANGE_USER_ID             \n");
			sql.append("	 		,CHANGE_TIME                \n");
			sql.append("	 		,CONFIRM_TIME               \n");
			sql.append("	 )                                  \n");
			sql.append("	 SELECT                             \n");
			sql.append("	 		 HOUSE_CODE                 \n");
			sql.append("	 		,VENDOR_CODE                \n");
			sql.append("	 		,RFQ_NO                     \n");
			sql.append("	 		,2                          \n");
			sql.append("	 		,RFQ_SEQ                    \n");
			sql.append("	 		,STATUS                     \n");
			sql.append("	 		,COMPANY_CODE               \n");
			sql.append("	 		,CONFIRM_FLAG               \n");
			sql.append("	 		,CONFIRM_DATE               \n");
			sql.append("	 		,CONFIRM_USER_ID            \n");
			sql.append("	 		,BID_FLAG                   \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,ADD_USER_ID                \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,CHANGE_USER_ID             \n");
			sql.append("	 		,?                          \n");
			sql.append("	 		,CONFIRM_TIME               \n");
			sql.append("	 FROM ICOYRQSE                      \n");
			sql.append("	 WHERE  HOUSE_CODE = ?              \n");
			sql.append("	 AND    RFQ_NO     = ?              \n");
			sql.append("	 AND    RFQ_COUNT  = ?		        \n");
  
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString()); 
			String[][] setRqse = {{SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, info.getSession("HOUSE_CODE")
								, RFQ_NO
								, RFQ_COUNT
								}};
			
			String[] type_rqse = {"S", "S", "S", "S", "S"
								, "S", "N"};
			rtn	= sm.doInsert(setRqse, type_rqse); 
 
			sql	= new StringBuffer();  // RQEP INSERT 
 
			sql.append(" INSERT INTO ICOYRQEP (               \n");
			sql.append(" 		 HOUSE_CODE                   \n");
			sql.append(" 		,VENDOR_CODE                  \n");
			sql.append(" 		,RFQ_NO                       \n");
			sql.append(" 		,RFQ_COUNT                    \n");
			sql.append(" 		,RFQ_SEQ                      \n");
			sql.append(" 		,COST_SEQ                     \n");
			sql.append(" 		,STATUS                       \n");
			sql.append(" 		,COMPANY_CODE                 \n");
			sql.append(" 		,COST_PRICE_NAME              \n");
			sql.append(" 		,COST_PRICE_VALUE             \n");
			sql.append(" 		,ADD_DATE                     \n");
			sql.append(" 		,ADD_TIME                     \n");
			sql.append(" 		,ADD_USER_ID                  \n");
			sql.append(" 		,CHANGE_DATE                  \n");
			sql.append(" 		,CHANGE_TIME                  \n");
			sql.append(" 		,CHANGE_USER_ID               \n");
			sql.append(" )                                    \n");
			sql.append(" SELECT                               \n");
			sql.append(" 		 HOUSE_CODE                   \n");
			sql.append(" 		,VENDOR_CODE                  \n");
			sql.append(" 		,RFQ_NO                       \n");
			sql.append(" 		,2                            \n");
			sql.append(" 		,RFQ_SEQ                      \n");
			sql.append(" 		,COST_SEQ                     \n");
			sql.append(" 		,STATUS                       \n");
			sql.append(" 		,COMPANY_CODE                 \n");
			sql.append(" 		,COST_PRICE_NAME              \n");
			sql.append(" 		,COST_PRICE_VALUE             \n");
			sql.append(" 		,?                            \n");
			sql.append(" 		,?                            \n");
			sql.append(" 		,ADD_USER_ID                  \n");
			sql.append(" 		,?                            \n");
			sql.append(" 		,?                            \n");
			sql.append(" 		,CHANGE_USER_ID               \n");
			sql.append(" FROM ICOYRQEP                        \n");
			sql.append(" WHERE HOUSE_CODE = ?                 \n");
			sql.append(" AND   RFQ_NO     = ?                 \n");
			sql.append(" AND   RFQ_COUNT  = ?		          \n");

			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString()); 
			String[][] setRqep = {{SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, info.getSession("HOUSE_CODE")
								, RFQ_NO
								, RFQ_COUNT
								}};
			
			String[] type_rqep = {"S", "S", "S", "S", "S"
								, "S", "N"};
			rtn	= sm.doInsert(setRqep, type_rqep); 
 
			sql	= new StringBuffer();  // RQAN INSERT 
			 
			sql.append(" INSERT INTO ICOYRQAN (      \n");
			sql.append(" 		 HOUSE_CODE          \n");
			sql.append(" 		,RFQ_NO              \n");
			sql.append(" 		,RFQ_COUNT           \n");
			sql.append(" 		,STATUS              \n");
			sql.append(" 		,COMPANY_CODE        \n");
			sql.append(" 		,ANNOUNCE_DATE       \n");
			sql.append(" 		,ANNOUNCE_TIME_FROM  \n");
			sql.append(" 		,ANNOUNCE_TIME_TO    \n");
			sql.append(" 		,ANNOUNCE_HOST       \n");
			sql.append(" 		,ANNOUNCE_AREA       \n");
			sql.append(" 		,ANNOUNCE_PLACE      \n");
			sql.append(" 		,ANNOUNCE_NOTIFIER   \n");
			sql.append(" 		,ANNOUNCE_RESP       \n");
			sql.append(" 		,DOC_FRW_DATE        \n");
			sql.append(" 		,ADD_USER_ID         \n");
			sql.append(" 		,ADD_DATE            \n");
			sql.append(" 		,ADD_TIME            \n");
			sql.append(" 		,CHANGE_USER_ID      \n");
			sql.append(" 		,CHANGE_DATE         \n");
			sql.append(" 		,CHANGE_TIME         \n");
			sql.append(" 		,ANNOUNCE_COMMENT    \n");
			sql.append(" )                           \n");
			sql.append(" SELECT    					 \n");
			sql.append(" 		 HOUSE_CODE          \n");
			sql.append(" 		,RFQ_NO              \n");
			sql.append(" 		,2                   \n");
			sql.append(" 		,STATUS              \n");
			sql.append(" 		,COMPANY_CODE        \n");
			sql.append(" 		,ANNOUNCE_DATE       \n");
			sql.append(" 		,ANNOUNCE_TIME_FROM  \n");
			sql.append(" 		,ANNOUNCE_TIME_TO    \n");
			sql.append(" 		,ANNOUNCE_HOST       \n");
			sql.append(" 		,ANNOUNCE_AREA       \n");
			sql.append(" 		,ANNOUNCE_PLACE      \n");
			sql.append(" 		,ANNOUNCE_NOTIFIER   \n");
			sql.append(" 		,ANNOUNCE_RESP       \n");
			sql.append(" 		,DOC_FRW_DATE        \n");
			sql.append(" 		,ADD_USER_ID         \n");
			sql.append(" 		,?                   \n");
			sql.append(" 		,?                   \n");
			sql.append(" 		,CHANGE_USER_ID      \n");
			sql.append(" 		,?                   \n");
			sql.append(" 		,?                   \n");
			sql.append(" 		,ANNOUNCE_COMMENT    \n");
			sql.append(" FROM ICOYRQAN               \n");
			sql.append(" WHERE  HOUSE_CODE = ?       \n");
			sql.append(" AND    RFQ_NO     = ?       \n");
			sql.append(" AND    RFQ_COUNT  = ?		 \n");

			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString()); 
			String[][] setRqan = {{SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, SepoaDate.getShortDateString()
								, SepoaDate.getShortTimeString()
								, info.getSession("HOUSE_CODE")
								, RFQ_NO
								, RFQ_COUNT
								}};
			
			String[] type_rqan = {"S", "S", "S", "S", "S"
								, "S", "N"};
			rtn	= sm.doInsert(setRqan, type_rqan); 
			
			sql	= new StringBuffer();  // RQHD UPDATE (1Â÷°ÇÀ» CLOSE ÇÑ´Ù.) 
 
			sql.append(	"  UPDATE ICOYRQHD								\n"); 
			sql.append(	"  SET STATUS				= 'R',				\n"); 
			sql.append(	"	   RFQ_FLAG				= 'C'				\n"); 
			sql.append(	"	WHERE HOUSE_CODE	= ?						\n"); 
			sql.append(	"	AND	RFQ_NO			= ?						\n"); 
			sql.append(	"	AND	RFQ_COUNT		= 1						\n"); 
 
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
			
			String[][] setUpRqhd = {{info.getSession("HOUSE_CODE"), RFQ_NO}};
			String[] type_UpRqhd = {"S", "S"};
			rtn	= sm.doUpdate(setUpRqhd, type_UpRqhd); 
 
			sql	= new StringBuffer();  // RQDT ÀÇ SETTLE_FLAG UPDATE (1Â÷°ÇÀ» CLOSE	ÇÑ´Ù.) 
 
			sql.append(	"  UPDATE ICOYRQDT								\n"); 
			sql.append(	"  SET STATUS				= 'R',				\n"); 
			sql.append(	"	   SETTLE_FLAG			= 'D'				\n"); 
			sql.append(	"	WHERE HOUSE_CODE	= ?						\n"); 
			sql.append(	"	AND	RFQ_NO			= ?						\n"); 
			sql.append(	"	AND	RFQ_COUNT		= 1						\n"); 
 
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString()); 
			String[][] setUpRqdt = {{info.getSession("HOUSE_CODE"), RFQ_NO}};
			String[] type_UpRqdt = {"S", "S"};
			rtn	= sm.doUpdate(setUpRqdt, type_UpRqdt); 

		}catch(Exception e)	{ 
			throw new Exception("setAutoCreate:"+e.getMessage()); 
		} finally { 
 
		} 
 
		return rtn; 
	} 	
		 
    private	String	et_getFlagQTACreate(String RFQ_NO, String RFQ_COUNT, String VENDOR_CODE) throws Exception 
	{ 
		String rtn = ""; 
		ConnectionContext ctx =	getConnectionContext(); 
		try	{ 

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 
			String[] args =	{RFQ_NO, RFQ_COUNT, VENDOR_CODE, info.getSession("HOUSE_CODE")}; 
			rtn	= sm.doSelect(args); 
 
			if(rtn == null)	throw new Exception("SQL Manager is	Null"); 
		}catch(Exception e)	{ 
			throw new Exception("et_getFlagQTACreate=========>"+e.getMessage()); 
		} finally{ 
		} 
		return rtn; 
	} 
    
    private	String et_getQtaCreateHDRFQ(String RFQ_NO, String RFQ_COUNT, String VENDOR_CODE) throws Exception 
	{ 

		String rtn		= ""; 
		ConnectionContext ctx =	getConnectionContext(); 
 
		try	{ 
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 
			String[] args =	{VENDOR_CODE, info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT}; 
			rtn	= sm.doSelect(args); 
 
			if(rtn == null)	throw new Exception("SQL Manager is	Null"); 
		}catch(Exception e)	{ 
			throw new Exception("et_getQtaCreateHDRFQ=========>"+e.getMessage()); 
		} finally{ 
		} 
		return rtn; 
	} 
    
    private	String	et_getQtaCreateHDQTA(String RFQ_NO, String RFQ_COUNT, String VENDOR_CODE) throws Exception 
	{ 
		String rtn		= ""; 
 
		ConnectionContext ctx =	getConnectionContext(); 
 
		try	{
			/*
			StringBuffer sql = new StringBuffer(); 

	        sql.append("    SELECT                                                                                                                                           \n");
	        sql.append("             GETCOMPANYNAMELOC(QH.HOUSE_CODE, QH.VENDOR_CODE, 'S') AS VENDOR_NAME                                                                    \n");
	        sql.append("            ,RH.SUBJECT                                                                                                                              \n");
	        sql.append("            ,RH.COMPANY_CODE                                                                                                                         \n"); 
	        sql.append("            ,( SUBSTR(RH.RFQ_CLOSE_DATE||RH.RFQ_CLOSE_TIME,0,4) || '/'  || SUBSTR(RH.RFQ_CLOSE_DATE||RH.RFQ_CLOSE_TIME,5,2)  || '/'  ||              \n");
	        sql.append("               SUBSTR(RH.RFQ_CLOSE_DATE||RH.RFQ_CLOSE_TIME,7,2) || '  ' || SUBSTR(RH.RFQ_CLOSE_DATE||RH.RFQ_CLOSE_TIME,9,2)  || ':'                  \n");
	        sql.append("            || SUBSTR(RH.RFQ_CLOSE_DATE||RH.RFQ_CLOSE_TIME,11,2) )  AS RFQ_CLOSE_DATE_VIEW                                                           \n");
	        sql.append("            ,RH.RFQ_CLOSE_DATE                                                                                                                       \n");
	        sql.append("            ,RH.RFQ_CLOSE_TIME                                                                                                                       \n");
	        sql.append("            ,QH.DELY_TERMS                                                                                                                           \n");
	        sql.append("            ,GETICOMCODE2(QH.HOUSE_CODE,'M009',QH.DELY_TERMS) AS DELY_TERMS_TEXT                                                                     \n");
	        sql.append("            ,NVL(QH.PAY_TERMS, RH.PAY_TERMS) AS PAY_TERMS                                                                                            \n");
	        sql.append("            ,GETICOMCODE2(QH.HOUSE_CODE,'M010',NVL(QH.PAY_TERMS, RH.PAY_TERMS))  AS PAY_TERMS_TEXT                                                   \n");
	        sql.append("            ,QH.CUR                                                                                                                                  \n");
	        sql.append("            ,RH.SETTLE_TYPE                                                                                                                          \n");
	        sql.append("            ,GETICOMCODE2(RH.HOUSE_CODE,'M149',RH.SETTLE_TYPE) AS SETTLE_TYPE_TEXT                                                                   \n");
	        sql.append("            ,RH.TERM_CHANGE_FLAG                                                                                                                     \n");
	        sql.append("            ,SUBSTR(RD.VALID_FROM_DATE,0,4) || '/' || SUBSTR(RD.VALID_FROM_DATE,5,2) || '/' ||SUBSTR(RD.VALID_FROM_DATE,7,2) AS VALID_FROM_DATE_VIEW \n");
	        sql.append("            ,SUBSTR(RD.VALID_TO_DATE,0,4) || '/' || SUBSTR(RD.VALID_TO_DATE,5,2) || '/' ||SUBSTR(RD.VALID_TO_DATE,7,2) AS VALID_TO_DATE_VIEW         \n");
	        sql.append("            ,RH.RFQ_TYPE                                                                                                                             \n");
	        sql.append("            ,GETICOMCODE2(RH.HOUSE_CODE, 'M112', RH.RFQ_TYPE) AS RFQ_TYPE_TEXT                                                                       \n");
	        sql.append("            ,RD.PRICE_TYPE                                                                                                                           \n");
	        sql.append("            ,GETICOMCODE2(RH.HOUSE_CODE,'M059', RD.PRICE_TYPE) AS PRICE_TYPE_TEXT                                                                    \n");
	        sql.append("            ,QH.SHIPPING_METHOD                                                                                                                      \n");
	        sql.append("            ,GETICOMCODE2(QH.HOUSE_CODE,'M015',QH.SHIPPING_METHOD) AS SHIPPING_METHOD_TEXT                                                           \n");
	        sql.append("            ,QH.USANCE_DAYS                                                                                                                          \n");
	        sql.append("            ,GETICOMCODE2(QH.HOUSE_CODE, 'M033', QH.USANCE_DAYS) AS USANCE_DAYS_TEXT                                                                 \n");
	        sql.append("            ,QH.DEPART_PORT                                                                                                                          \n");
	        sql.append("            ,QH.DEPART_PORT_NAME                                                                                                                     \n");
	        sql.append("            ,QH.ARRIVAL_PORT                                                                                                                         \n");
	        sql.append("            ,QH.ARRIVAL_PORT_NAME                                                                                                                    \n");
	        sql.append("            ,RH.DOM_EXP_FLAG                                                                                                                         \n");
	        sql.append("            ,GETICOMCODE2(RH.HOUSE_CODE, 'M032', RH.DOM_EXP_FLAG) AS DOM_EXP_FLAG_TEXT                                                               \n");
	        sql.append("            ,RD.SHIPPER_TYPE                                                                                                                         \n");
	        sql.append("            ,GETICOMCODE2(RD.HOUSE_CODE,'M025',RD.SHIPPER_TYPE) AS SHIPPER_TYPE_TEXT                                                                 \n");
	        sql.append("            ,QH.QTA_VAL_DATE                                                                                                                         \n");
	        sql.append("            ,RH.REMARK AS RFQ_REMARK                                                                                                                 \n");
	        sql.append("            ,QH.REMARK AS REMARK                                                                                                                     \n");
	        sql.append("            ,(SELECT COUNT(*)                                                                                                                        \n");
	        sql.append("              FROM   ICOYRQAN                                                                                                                        \n");
	        sql.append("              WHERE  HOUSE_CODE = RH.HOUSE_CODE                                                                                                      \n");
	        sql.append("              AND    RFQ_NO     = RH.RFQ_NO                                                                                                          \n");
	        sql.append("              AND    RFQ_COUNT  = RH.RFQ_COUNT                                                                                                       \n");
	        sql.append("            ) AS   RQAN_CNT                                                                                                                          \n");
	        sql.append("            ,QH.QTA_NO                                                                                                                               \n");
	        sql.append("            ,(SELECT QTA_NO FROM ICOYQTHD                                                                                                            \n");
	        sql.append("             WHERE HOUSE_CODE = QH.HOUSE_CODE                                                                                                        \n");
	        sql.append("             AND   RFQ_NO     = QH.RFQ_NO                                                                                                            \n");
	        sql.append("             AND   RFQ_COUNT  = 1                                                                                                                    \n");
	        sql.append("             AND   VENDOR_CODE= QH.VENDOR_CODE) AS BEFORE_QTA_NO                                                                                     \n");
       		sql.append("          ,Z_SMS_SEND_FLAG                                                    \n");
       		sql.append("          ,Z_RESULT_OPEN_FLAG                                                \n");

       		sql.append("		,GETUSERNAMELOC(RH.HOUSE_CODE, RH.ADD_USER_ID) AS  ADD_USER_NAME	\n");
       		sql.append("		,RH.CREATE_TYPE														\n");
       		sql.append("		,RH.BID_REQ_TYPE													\n");	
       		sql.append("		,GETFILEATTCOUNT(RH.ATTACH_NO) AS RFQ_ATT_COUNT						\n");
       		sql.append("		,GETFILEATTCOUNT(QH.ATTACH_NO) AS QTA_ATTACH_CNT   					\n");
       		sql.append("		,RH.ATTACH_NO AS RFQ_ATTACH_NO										\n");	
       		sql.append(" 		,QH.ATTACH_NO AS QTA_ATTACH_NO										\n");
	        
	        sql.append("     FROM ICOYQTHD QH, ICOYQTDT QD, ICOYRQHD RH, ICOYRQDT RD                                                                                         \n");
	        sql.append("     WHERE QH.HOUSE_CODE  = QD.HOUSE_CODE                                                                                                            \n");
	        sql.append("     AND   QH.QTA_NO      = QD.QTA_NO                                                                                                                \n");
	        sql.append("     AND   QH.VENDOR_CODE = QD.VENDOR_CODE                                                                                                           \n");
	        sql.append("     AND   RH.HOUSE_CODE  = QH.HOUSE_CODE                                                                                                            \n");
	        sql.append("     AND   RH.RFQ_NO      = QH.RFQ_NO                                                                                                                \n");
	        sql.append("     AND   RH.RFQ_COUNT   = QH.RFQ_COUNT                                                                                                             \n");
	        sql.append("     AND   RH.HOUSE_CODE  = RD.HOUSE_CODE                                                                                                            \n");
	        sql.append("     AND   RH.RFQ_NO      = RD.RFQ_NO                                                                                                                \n");
	        sql.append("     AND   RH.RFQ_COUNT   = RD.RFQ_COUNT                                                                                                             \n");
	        sql.append("     AND   RD.HOUSE_CODE  = QD.HOUSE_CODE                                                                                                            \n");
	        sql.append("     AND   RD.RFQ_NO      = QD.RFQ_NO                                                                                                                \n");
	        sql.append("     AND   RD.RFQ_COUNT   = QD.RFQ_COUNT                                                                                                             \n");
	        sql.append("     AND   RD.RFQ_SEQ     = QD.RFQ_SEQ                                                                                                               \n");
	        sql.append("     AND   QH.STATUS      IN ('C', 'R')                                                                                                              \n");
	        sql.append("     AND   QD.STATUS      IN ('C', 'R')                                                                                                              \n");
	        sql.append("     AND   RH.STATUS      IN ('C', 'R')                                                                                                              \n");
	        sql.append("     AND   RD.STATUS      IN ('C', 'R')                                                                                                              \n");
	        sql.append("     AND   RH.RFQ_TYPE    IN ('MA', 'MI', 'SI')                                                                                                      \n");
	        sql.append("     AND   RH.SIGN_STATUS  = 'E'                                                                                                                     \n");
	        sql.append("     AND   RH.BID_TYPE     = 'RQ'                                                                                                                    \n");
	        sql.append("     AND   RH.RFQ_FLAG     = 'P'                                                                                                                     \n");
	        sql.append("     <OPT=S,S> AND   QH.RFQ_NO      = ? </OPT>                                                                                                       \n");
	        sql.append("     <OPT=S,N> AND   QH.RFQ_COUNT   = ? </OPT>                                                                                                       \n");
	        sql.append("     <OPT=S,S> AND   QH.VENDOR_CODE = ? </OPT>                                                                                                       \n");
	        sql.append("     <OPT=S,S> AND   QH.HOUSE_CODE  = ? </OPT>                                                                                                       \n");
	        sql.append("     AND   ROWNUM = 1                                                                                                                                \n");
*/	        
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
 
			String[] args =	{RFQ_NO, RFQ_COUNT, VENDOR_CODE, info.getSession("HOUSE_CODE")}; 
			rtn	= sm.doSelect(args); 
 
			if(rtn == null)	throw new Exception("SQL Manager is	Null"); 
		}catch(Exception e)	{ 
			throw new Exception("et_getQtaCreateHDQTA=========>"+e.getMessage()); 
		} finally{ 
		} 
		return rtn; 
	} 
    
    @SuppressWarnings("unchecked")
	public SepoaOut getQuery_Upd_Qta_Detail_Qta(Map<String, String> header) throws Exception  
    {
     					   
    	ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            rtn                   = null;
		String            id                    = info.getSession("ID");
		//Map<String, String> header              = null;
		Map<String, String> customHeader        = null;
		
		try{
			
			setStatus(1);
			setFlag(true);
			
			//header       = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
			//customHeader = new HashMap<String, String>();	
			
			sxp = new SepoaXmlParser(this, "getQuery_Upd_Qta_Detail_Qta");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(id, this, ctx, sxp);
        	//System.out.println("서비스ㅡ998ㅡㅡㅡ"+header);
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
    
    
   /* public SepoaOut getQuery_Upd_Qta_Detail_Qta(String RFQ_NO, String RFQ_COUNT,String VENDOR_CODE, String GROUP_YN)  
    {
     					   
        String rtn = new String();  
  
        ConnectionContext ctx = getConnectionContext();  
  
        try {  
        	SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("GROUP_YN", GROUP_YN);
        	
        	
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
            Logger.err.println(info.getSession("ID"),this,wxp.getQuery());  
  
            String[] args = {info.getSession("HOUSE_CODE"), RFQ_NO, RFQ_COUNT, VENDOR_CODE};  
            rtn = sm.doSelect(args);  
  
            setValue(rtn);  
            setStatus(1);  
        }catch (Exception e){  
           // Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + stackTrace(e));  
            setStatus(0);  
        }  
        return getSepoaOut();  
    }*/
    
    public SepoaOut	getQuery_RFQVENDOR_NEXT(String RFQ_NO, String RFQ_COUNT, String	nu_num,	String max_row)  throws Exception  
	{ 
		String rtn = ""; 
		ConnectionContext ctx =	getConnectionContext(); 
		String house_code = info.getSession("HOUSE_CODE");
             
		try	{ 

			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] data = {house_code, RFQ_NO, RFQ_COUNT, max_row, nu_num, nu_num};
			rtn = sm.doSelect(data); 

			setValue(rtn); 
			setStatus(1); 
		}catch (Exception e){ 
			setStatus(0); 
            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
            throw new Exception(e.getMessage()); 
		}finally { 

		} 
		     
		return getSepoaOut(); 
	} 
 }