package dt.rfq;

import java.util.StringTokenizer;

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

public class p1005 extends SepoaService {
	
	
	private boolean bDebug = true;
	private Message msg;

	public p1005(String opt, SepoaInfo info) throws SepoaServiceException {
		 super(opt,info);
	        setVersion("1.0.0");
	        msg = new Message(info,"STDRFQ");

	        Configuration configuration = null;
	        
	        try {
				configuration = new Configuration();
			} catch(ConfigurationException cfe) {
				Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
			} catch(Exception e) {
				Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
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
	 * 견적서 접수.
	 * @param args
	 * @return
	 */ 
		   public SepoaOut getRfqReceive (String[] args){ 
		        try{ 
		        	String rtn = et_getRfqReceive(args); 
		            setValue(rtn); 
		            setStatus(1); 
		            setMessage(msg.getMessage("0000"));  
		        }catch(Exception e){ 
		            setStatus(0); 
		            setMessage(msg.getMessage("0001")); 
		            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
		        } 
		        return getSepoaOut(); 
		    } 
		    
		    private String et_getRfqReceive(String[] args) throws Exception 
		    { 
		    	String rtn = null; 
				String purchaserUser_seperate = null;
				String ctrl_code = info.getSession("CTRL_CODE");
				
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

		        
		        try{ 
		            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		            rtn = sm.doSelect(args); 
		        }catch(Exception e) { 
		            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
		            throw new Exception(e.getMessage()); 
		        } 
		        return rtn; 
		    } 
		    public SepoaOut ReturnToPR_DOC_ALL(String rfq_no,String rfq_count,String[][] prdt_data, String[][] rqhd) 
		    { 
		        try 
		        { 
		 
		            int rtn = et_ReturnToPR_DOC_ALL(rfq_no,rfq_count,prdt_data,rqhd); 
		            setStatus(1); 
		            setValue(String.valueOf(rtn)); 
		            setMessage(msg.getMessage("0017")); 
		            Commit();
		            
		        }catch(Exception e) { 
		            try{Rollback();}catch(Exception d){Logger.err.println(info.getSession("ID"),this,d.getMessage());} 
		            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
		            setStatus(0); 
		            setMessage(msg.getMessage("0003")); 
		        } 
		        return getSepoaOut(); 
		    } 
		 
		    private int et_ReturnToPR_DOC_ALL(String rfq_no,String rfq_count,String[][] prdt_data, String[][] rqhd) throws Exception 
		    { 
		        String house_code   = info.getSession("HOUSE_CODE"); 
		 
		        int rtn = 0; 
		        ConnectionContext ctx = getConnectionContext(); 
		 
		        try{
		        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");	     
		            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		            String[][] RqdtData = {{info.getSession("HOUSE_CODE"), rfq_no, rfq_count}};
		            String[] typeRqdt = {"S", "S", "N"};
		            rtn = sm.doUpdate(RqdtData, typeRqdt); 
		            
		            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
		            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		            String[][] RqhdData = {{info.getSession("HOUSE_CODE"), rfq_no, rfq_count}};
		            String[] typeRqhd = {"S", "S", "N"};
		            rtn = sm.doUpdate(RqhdData, typeRqhd); 
		            
		            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
		            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 	            
		            String[] typePrdt = {"S", "S", "S"};
		            rtn = sm.doUpdate(prdt_data, typePrdt); 
		            
		            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
		            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		            String[] typeRqhd_4 = {"S", "S", "S", "S", "S"};
		            rtn = sm.doUpdate(rqhd, typeRqhd_4);
		            
		        }catch(Exception e) { 
		            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
		            throw new Exception(e.getMessage()); 
		        } 
		        return rtn; 
		    } 
		 
		    
		    public SepoaOut getQuery_Max_RFQ_Count(String RFQ_NO) 
		    { 
		        try 
		        { 
		            String rtn = null; 
		            rtn = et_getQuery_Max_RFQ_Count(RFQ_NO); 
		            setStatus(1); 
		            setValue(String.valueOf(rtn)); 
		            setMessage(msg.getMessage("0000")); 
		        }catch(Exception e) { 
		            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
		            setStatus(0); 
		            setMessage(msg.getMessage("0001")); 
		        } 
		        return getSepoaOut(); 
		    } 
		    
		    private String  et_getQuery_Max_RFQ_Count(String RFQ_NO) throws Exception 
		    { 
		        String rtn = ""; 
		        ConnectionContext ctx = getConnectionContext(); 
		        
		        try { 
		        	
		        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		 
//		            sql.append(" SELECT MAX(RFQ_COUNT)+1 AS RE_RFQ_COUNT   \n");
//		            sql.append(" FROM ICOYRQDT                             \n");
//		            sql.append(" <OPT=S,S> WHERE HOUSE_CODE = ? </OPT>     \n");
//		            sql.append(" <OPT=S,S> AND   RFQ_NO     = ? </OPT>     \n");
		 
		            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
		 
		            String[] args = {info.getSession("HOUSE_CODE"), RFQ_NO}; 
		            rtn = sm.doSelect(args); 
		 
		            if(rtn == null) throw new Exception("SQL Manager is Null"); 
		        }catch(Exception e) { 
		            throw new Exception("et_getQuery_Max_RFQ_Count=========>"+e.getMessage()); 
		        } finally{ 
		        } 
		        return rtn; 
		    } 
		    
		    public SepoaOut re_setRfqCreate(String rfq_type,
					String rfq_flag,
					String rfq_no,
					String rfq_count,
					String re_rfq_count,
					String[][] newRqhdData,
					String[][] newRqdtData,
					String[][] newRqseData,
					String[][] newRqopData,
					String[][] newRqepData,
					String[][] newRqanData
					) 
				{ 
				try {  
				
				ConnectionContext ctx =	getConnectionContext(); 
				int rtn = et_re_setRfqHDCreate(ctx, newRqhdData);		
				
				if(newRqanData.length > 0) {
				int rqan = et_re_setRfqANCreate(ctx, newRqanData);
				}	
				
				rtn = et_re_setRfqDTCreate(ctx, newRqdtData);
				
				if(!rfq_type.equals("OP")) {
				rtn = et_re_setRfqSECreate(ctx, newRqseData);
				rtn = et_re_setRfqOPCreate(ctx, newRqopData);
				
				Logger.err.println(info.getSession("ID"),this,"====================="+newRqepData.length); 
				if(newRqepData.length > 0) {
				int rqep = et_re_setRfqEPCreate(ctx, newRqepData);
				}
				}
				
				rtn = et_re_complete(ctx, rfq_no, rfq_count);
				
				if(rfq_flag.equals("P"))
				{ 
				int signup = temp_Approval(ctx, rfq_no, re_rfq_count, "E"); 
				} 
				else 
				{ 
				int signup = temp_Approval(ctx, rfq_no, re_rfq_count, "T"); 
				} 				
				
				setStatus(1); 
				setValue(String.valueOf(rtn)); 
				msg.setArg("RFQ_NO",rfq_no); 
				setMessage(msg.getMessage("0016")); 
				
					Commit();
				} catch(Exception e) { 
				try	{ 
					Rollback(); 
				} catch(Exception d) {  
					Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
				} 
				setStatus(0); 
				} 
				return getSepoaOut();  
				
				}
		    private	int et_re_setRfqHDCreate(	ConnectionContext ctx, 
					String[][] rqhddata) throws	Exception 
				{ 
				int	rtn	= 0; 
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
				try{ 
				
				String[] type =	{ "S","S","N","S","S"
					, "S","S","S","S","S"
					, "S","S","S","S","S"
					, "S","S","S","S","S"
					, "S","S","S","S","S"
					, "S","N","S","S","S"
					, "S","S","S","N","N"
					, "N","N","S","S","S"
					, "S","S","S","S","S"
					, "S","S","S","S"
					}; 
				
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(rqhddata,type); 
				
				}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
				} 
				return rtn; 
				}
		    private	int et_re_setRfqANCreate(ConnectionContext	ctx, 
					String[][] rqandata 
					) throws Exception 
				{ 
				
				int rtn = 0;
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
//				sql.append(" INSERT INTO ICOYRQAN (      \n");
//				sql.append(" 		 HOUSE_CODE          \n");
//				sql.append(" 		,RFQ_NO              \n");
//				sql.append(" 		,RFQ_COUNT           \n");
//				sql.append(" 		,STATUS              \n");
//				sql.append(" 		,COMPANY_CODE        \n");
//				sql.append(" 		,ANNOUNCE_DATE       \n");
//				sql.append(" 		,ANNOUNCE_TIME_FROM  \n");
//				sql.append(" 		,ANNOUNCE_TIME_TO    \n");
//				sql.append(" 		,ANNOUNCE_HOST       \n");
//				sql.append(" 		,ANNOUNCE_AREA       \n");
//				sql.append(" 		,ANNOUNCE_PLACE      \n");
//				sql.append(" 		,ANNOUNCE_NOTIFIER   \n");
//				sql.append(" 		,ANNOUNCE_RESP       \n");
//				sql.append(" 		,DOC_FRW_DATE        \n");
//				sql.append(" 		,ADD_USER_ID         \n");
//				sql.append(" 		,ADD_DATE            \n");
//				sql.append(" 		,ADD_TIME            \n");
//				sql.append(" 		,CHANGE_USER_ID      \n");
//				sql.append(" 		,CHANGE_DATE         \n");
//				sql.append(" 		,CHANGE_TIME         \n");
//				sql.append(" 		,ANNOUNCE_COMMENT    \n");
//				sql.append(" ) VALUES (                  \n");
//				sql.append(" 		 ?                   \n");  //  HOUSE_CODE
//				sql.append(" 		,?                   \n");  //  RFQ_NO
//				sql.append(" 		,?                   \n");  //  RFQ_COUNT
//				sql.append(" 		,?                   \n");  //  STATUS
//				sql.append(" 		,?                   \n");  //  COMPANY_CODE
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_DATE
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_TIME_FROM
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_TIME_TO
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_HOST
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_AREA
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_PLACE
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_NOTIFIER
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_RESP
//				sql.append(" 		,?                   \n");  //  DOC_FRW_DATE
//				sql.append(" 		,?                   \n");  //  ADD_USER_ID
//				sql.append(" 		,?                   \n");  //  ADD_DATE
//				sql.append(" 		,?                   \n");  //  ADD_TIME
//				sql.append(" 		,?                   \n");  //  CHANGE_USER_ID
//				sql.append(" 		,?                   \n");  //  CHANGE_DATE
//				sql.append(" 		,?                   \n");  //  CHANGE_TIME
//				sql.append(" 		,?                   \n");  //  ANNOUNCE_COMMENT
//				sql.append(" )                           \n");
				
				try{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				String[] type =	{"S","S","N","S","S"
						,"S","S","S","S","S"
						,"S","S","S","S","S"
						,"S","S","S","S","S"
						,"S"
						}; 
				
				rtn = sm.doInsert(rqandata,type); 
				}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
				} 
				
				return rtn;
				} 
		    private	int	et_re_setRfqDTCreate(ConnectionContext	ctx, 
					String[][] rqdtdata) throws	Exception 
				{ 
				
				int	rtn	= 0; 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//				StringBuffer sql = new StringBuffer(); 
//				
//				sql.append(" INSERT INTO ICOYRQDT (         \n");
//				sql.append(" 		 HOUSE_CODE             \n");
//				sql.append(" 		,RFQ_NO                 \n");
//				sql.append(" 		,RFQ_COUNT              \n");
//				sql.append(" 		,RFQ_SEQ                \n");
//				sql.append(" 		,STATUS                 \n");
//				sql.append(" 		,COMPANY_CODE           \n");
//				sql.append(" 		,PLANT_CODE             \n");
//				sql.append(" 		,RFQ_PROCEEDING_FLAG    \n");
//				sql.append(" 		,ADD_DATE               \n");
//				sql.append(" 		,ADD_TIME               \n");
//				sql.append(" 		,ADD_USER_ID            \n");
//				sql.append(" 		,CHANGE_DATE            \n");
//				sql.append(" 		,CHANGE_TIME            \n");
//				sql.append(" 		,CHANGE_USER_ID         \n");
//				sql.append(" 		,ITEM_NO                \n");
//				sql.append(" 		,UNIT_MEASURE           \n");
//				sql.append(" 		,RD_DATE                \n");
//				sql.append(" 		,VALID_FROM_DATE        \n");
//				sql.append(" 		,VALID_TO_DATE          \n");
//				sql.append(" 		,PURCHASE_PRE_PRICE     \n");
//				sql.append(" 		,RFQ_QTY                \n");
//				sql.append(" 		,RFQ_AMT                \n");
//				sql.append(" 		,BID_COUNT              \n");
//				sql.append(" 		,CUR                    \n");
//				sql.append(" 		,PR_NO                  \n");
//				sql.append(" 		,PR_SEQ                 \n");
//				sql.append(" 		,SETTLE_FLAG            \n");
//				sql.append(" 		,SETTLE_QTY             \n");
//				sql.append(" 		,TBE_FLAG               \n");
//				sql.append(" 		,TBE_DEPT               \n");
//				sql.append(" 		,PRICE_TYPE             \n");
//				sql.append(" 		,TBE_PROCEEDING_FLAG    \n");
//				sql.append(" 		,SAMPLE_FLAG            \n");
//				sql.append(" 		,DELY_TO_LOCATION       \n");
//				sql.append(" 		,ATTACH_NO              \n");
//				sql.append(" 		,SHIPPER_TYPE           \n");
//				sql.append(" 		,CONTRACT_FLAG          \n");
//				sql.append(" 		,COST_COUNT             \n");
//				sql.append(" 		,YEAR_QTY               \n");
//				sql.append(" 		,DELY_TO_ADDRESS        \n");
//				sql.append(" 		,MIN_PRICE              \n");
//				sql.append(" 		,MAX_PRICE              \n");
//				sql.append(" 		,STR_FLAG               \n");
//				sql.append("        ,Z_REMARK            \n");	 	
//				sql.append("		, TECHNIQUE_GRADE		\n");
//				sql.append("		, TECHNIQUE_TYPE 		\n");
//				sql.append("		, INPUT_FROM_DATE		\n");
//				sql.append("		, INPUT_TO_DATE 		\n"); 
//				sql.append("		, SPECIFICATION 		\n"); 
//				sql.append("		, MAKER_NAME 			\n"); 
//				sql.append(" ) VALUES (                     \n");
//				sql.append(" 		 ?                      \n");//  HOUSE_CODE           
//				sql.append(" 		,?                      \n");//  RFQ_NO               
//				sql.append(" 		,?                      \n");//  RFQ_COUNT            
//				sql.append(" 		,?                      \n");//  RFQ_SEQ              
//				sql.append(" 		,?                      \n");//  STATUS               
//				sql.append(" 		,?                      \n");//  COMPANY_CODE         
//				sql.append(" 		,?                      \n");//  PLANT_CODE           
//				sql.append(" 		,?                      \n");//  RFQ_PROCEEDING_FLAG  
//				sql.append(" 		,?                      \n");//  ADD_DATE             
//				sql.append(" 		,?                      \n");//  ADD_TIME             
//				sql.append(" 		,?                      \n");//  ADD_USER_ID          
//				sql.append(" 		,?                      \n");//  CHANGE_DATE          
//				sql.append(" 		,?                      \n");//  CHANGE_TIME          
//				sql.append(" 		,?                      \n");//  CHANGE_USER_ID       
//				sql.append(" 		,?                      \n");//  ITEM_NO              
//				sql.append(" 		,?                      \n");//  UNIT_MEASURE         
//				sql.append(" 		,?                      \n");//  RD_DATE              
//				sql.append(" 		,?                      \n");//  VALID_FROM_DATE      
//				sql.append(" 		,?                      \n");//  VALID_TO_DATE        
//				sql.append(" 		,?                      \n");//  PURCHASE_PRE_PRICE   
//				sql.append(" 		,?                      \n");//  RFQ_QTY              
//				sql.append(" 		,?                      \n");//  RFQ_AMT              
//				sql.append(" 		,?                      \n");//  BID_COUNT            
//				sql.append(" 		,?                      \n");//  CUR                  
//				sql.append(" 		,?                      \n");//  PR_NO                
//				sql.append(" 		,dbo.lpad(?, 5, '0')    \n");//  PR_SEQ               
//				sql.append(" 		,?                      \n");//  SETTLE_FLAG          
//				sql.append(" 		,?                      \n");//  SETTLE_QTY           
//				sql.append(" 		,?                      \n");//  TBE_FLAG             
//				sql.append(" 		,?                      \n");//  TBE_DEPT             
//				sql.append(" 		,?                      \n");//  PRICE_TYPE           
//				sql.append(" 		,?                      \n");//  TBE_PROCEEDING_FLAG  
//				sql.append(" 		,?                      \n");//  SAMPLE_FLAG          
//				sql.append(" 		,?                      \n");//  DELY_TO_LOCATION     
//				sql.append(" 		,?                      \n");//  ATTACH_NO            
//				sql.append(" 		,?                      \n");//  SHIPPER_TYPE         
//				sql.append(" 		,?                      \n");//  CONTRACT_FLAG        
//				sql.append(" 		,?                      \n");//  COST_COUNT           
//				sql.append(" 		,?                      \n");//  YEAR_QTY             
//				sql.append(" 		,?                      \n");//  DELY_TO_ADDRESS      
//				sql.append(" 		,?                      \n");//  MIN_PRICE            
//				sql.append(" 		,?                      \n");//  MAX_PRICE            
//				sql.append(" 		,?                      \n");//  STR_FLAG
//				sql.append(" 		,?                      \n");//  Z_REMARK
//				sql.append("		,? 						\n");//TECHNIQUE_GRADE	
//				sql.append("		,? 						\n");//TECHNIQUE_TYPE 	
//				sql.append("		,? 						\n");//INPUT_FROM_DATE	
//				sql.append("		,? 						\n");//INPUT_TO_DATE 	
//				sql.append("		,?  					\n"); //SPECIFICATION
//				sql.append("		,?  					\n"); 	 //MAKER_NAME
//				sql.append(" )                              \n");    
				
				try{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				
				String[] type =	{"S","S","N","S","S"
						,"S","S","S","S","S"
						,"S","S","S","S","S"
						,"S","S","S","S","N"
						,"N","N","N","S","S"
						,"S","S","N","S","S"
						,"S","S","S","S","S"
						,"S","S","N","N","S"
						,"N","N","S","S","S"
						,"S","S","S","S","S" 
						}; 
				rtn	= sm.doInsert(rqdtdata,type); 
				
				}catch(Exception e)	{ 
				Logger.debug.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
				} 
				return rtn; 
				} 
		    
		    private	int	et_re_setRfqSECreate(ConnectionContext	ctx,String[][]	rqsedata ) throws Exception 
				{ 
				
				int	rtn	= 0; 
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
//				sql.append(" INSERT INTO ICOYRQSE (      \n");
//				sql.append(" 		 HOUSE_CODE          \n");
//				sql.append(" 		,VENDOR_CODE         \n");
//				sql.append(" 		,RFQ_NO              \n");
//				sql.append(" 		,RFQ_COUNT           \n");
//				sql.append(" 		,RFQ_SEQ             \n");
//				sql.append(" 		,STATUS              \n");
//				sql.append(" 		,COMPANY_CODE        \n");
//				sql.append(" 		,CONFIRM_FLAG        \n");
//				sql.append(" 		,CONFIRM_DATE        \n");
//				sql.append(" 		,CONFIRM_USER_ID     \n");
//				sql.append(" 		,BID_FLAG            \n");
//				sql.append(" 		,ADD_DATE            \n");
//				sql.append(" 		,ADD_USER_ID         \n");
//				sql.append(" 		,ADD_TIME            \n");
//				sql.append(" 		,CHANGE_DATE         \n");
//				sql.append(" 		,CHANGE_USER_ID      \n");
//				sql.append(" 		,CHANGE_TIME         \n");
//				sql.append(" 		,CONFIRM_TIME        \n");
//				sql.append(" ) VALUES (                  \n");
//				sql.append(" 		 ?                   \n");   // HOUSE_CODE
//				sql.append(" 		,?                   \n");   // VENDOR_CODE
//				sql.append(" 		,?                   \n");   // RFQ_NO
//				sql.append(" 		,?                   \n");   // RFQ_COUNT
//				sql.append(" 		,?                   \n");   // RFQ_SEQ
//				sql.append(" 		,?                   \n");   // STATUS
//				sql.append(" 		,?                   \n");   // COMPANY_CODE
//				sql.append(" 		,?                   \n");   // CONFIRM_FLAG
//				sql.append(" 		,?                   \n");   // CONFIRM_DATE
//				sql.append(" 		,?                   \n");   // CONFIRM_USER_ID
//				sql.append(" 		,?                   \n");   // BID_FLAG
//				sql.append(" 		,?                   \n");   // ADD_DATE
//				sql.append(" 		,?                   \n");   // ADD_USER_ID
//				sql.append(" 		,?                   \n");   // ADD_TIME
//				sql.append(" 		,?                   \n");   // CHANGE_DATE
//				sql.append(" 		,?                   \n");   // CHANGE_USER_ID
//				sql.append(" 		,?                   \n");   // CHANGE_TIME
//				sql.append(" 		,?                   \n");   // CONFIRM_TIME
//				sql.append(" )                           \n");                          
				
				try{ 
				
				String[] type =	{"S","S","S","N","S"
					,"S","S","S","S","S"
					,"S","S","S","S","S"
					,"S","S","S"
					}; 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				rtn	= sm.doInsert(rqsedata,type); 
				}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
				} 
				return rtn; 
				} 
				
				private	int et_re_setRfqEPCreate(ConnectionContext	ctx, 
							String[][] rqepdata 
							) throws Exception 
				{ 
				
				int rtn = 0;
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
//				sql.append(" INSERT INTO ICOYRQEP (    \n");
//				sql.append(" 		 HOUSE_CODE        \n");
//				sql.append(" 		,VENDOR_CODE       \n");
//				sql.append(" 		,RFQ_NO            \n");
//				sql.append(" 		,RFQ_COUNT         \n");
//				sql.append(" 		,RFQ_SEQ           \n");
//				sql.append(" 		,COST_SEQ          \n");
//				sql.append(" 		,STATUS            \n");
//				sql.append(" 		,COMPANY_CODE      \n");
//				sql.append(" 		,COST_PRICE_NAME   \n");
//				sql.append(" 		,COST_PRICE_VALUE  \n");
//				sql.append(" 		,ADD_DATE          \n");
//				sql.append(" 		,ADD_TIME          \n");
//				sql.append(" 		,ADD_USER_ID       \n");
//				sql.append(" 		,CHANGE_DATE       \n");
//				sql.append(" 		,CHANGE_TIME       \n");
//				sql.append(" 		,CHANGE_USER_ID    \n");
//				sql.append(" ) VALUES (                \n");
//				sql.append(" 		 ?                 \n");   // HOUSE_CODE
//				sql.append(" 		,?                 \n");   // VENDOR_CODE
//				sql.append(" 		,?                 \n");   // RFQ_NO
//				sql.append(" 		,?                 \n");   // RFQ_COUNT
//				sql.append(" 		,?                 \n");   // RFQ_SEQ
//				sql.append(" 		,dbo.lpad(?, 6, '0') \n");   // COST_SEQ
//				sql.append(" 		,?                 \n");   // STATUS
//				sql.append(" 		,?                 \n");   // COMPANY_CODE
//				sql.append(" 		,?                 \n");   // COST_PRICE_NAME
//				sql.append(" 		,?                 \n");   // COST_PRICE_VALUE
//				sql.append(" 		,?                 \n");   // ADD_DATE
//				sql.append(" 		,?                 \n");   // ADD_TIME
//				sql.append(" 		,?                 \n");   // ADD_USER_ID
//				sql.append(" 		,?                 \n");   // CHANGE_DATE
//				sql.append(" 		,?                 \n");   // CHANGE_TIME
//				sql.append(" 		,?                 \n");   // CHANGE_USER_ID
//				sql.append(" )                         \n");
				
				try{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				String[] type =	{"S","S","S","N","S"
					,"S","S","S","S","S"
					,"S","S","S","S","S"
					,"S"
					}; 
				
				rtn = sm.doInsert(rqepdata,type); 
				}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
				} 
				
				return rtn;
				} 
				
				
				private	int	et_re_setRfqOPCreate(ConnectionContext	ctx, 
						String[][] rqopdata) throws Exception 
				{ 
				
				int	rtn	= 0; 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
//				sql.append(" INSERT INTO ICOYRQOP (       \n");
//				sql.append(" 		 HOUSE_CODE           \n");
//				sql.append(" 		,RFQ_NO               \n");
//				sql.append(" 		,RFQ_COUNT            \n");
//				sql.append(" 		,RFQ_SEQ              \n");
//				sql.append(" 		,PURCHASE_LOCATION    \n");
//				sql.append(" 		,VENDOR_CODE          \n");
//				sql.append(" 		,STATUS               \n");
//				sql.append(" 		,ADD_USER_ID          \n");
//				sql.append(" 		,ADD_DATE             \n");
//				sql.append(" 		,ADD_TIME             \n");
//				sql.append(" 		,CHANGE_DATE          \n");
//				sql.append(" 		,CHANGE_TIME          \n");
//				sql.append(" 		,CHANGE_USER_ID       \n");
//				sql.append(" ) VALUES (                   \n");
//				sql.append(" 		 ?                    \n");      // HOUSE_CODE
//				sql.append(" 		,?                    \n");      // RFQ_NO
//				sql.append(" 		,?                    \n");      // RFQ_COUNT
//				sql.append(" 		,?                    \n");      // RFQ_SEQ
//				sql.append(" 		,?                    \n");      // PURCHASE_LOCATION
//				sql.append(" 		,?                    \n");      // VENDOR_CODE
//				sql.append(" 		,?                    \n");      // STATUS
//				sql.append(" 		,?                    \n");      // ADD_USER_ID
//				sql.append(" 		,?                    \n");      // ADD_DATE
//				sql.append(" 		,?                    \n");      // ADD_TIME
//				sql.append(" 		,?                    \n");      // CHANGE_DATE
//				sql.append(" 		,?                    \n");      // CHANGE_TIME
//				sql.append(" 		,?                    \n");      // CHANGE_USER_ID
//				sql.append(" )                            \n");
				
				try	{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				String[] type =	{"S","S","N","S","S"
							,"S","S","S","S","S"
							,"S","S","S"}; 
				rtn	= sm.doInsert(rqopdata,type); 
				Logger.debug.println(info.getSession("ID"),this, "rtn==//"+rtn+"//");
				} catch(Exception e) { 
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
				throw new Exception(e.getMessage()); 
				} 
				return rtn; 
				} 

				
				   private int et_re_complete(ConnectionContext ctx, 
	                       String rfq_no,String rfq_count ) throws Exception 
				{ 
				int rtn = 0; 
				
				try{
					
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
				
//				    sql.append(" UPDATE  ICOYRQHD SET RFQ_FLAG = 'C' \n");
//				    sql.append(" WHERE HOUSE_CODE =     ?            \n");
//				    sql.append(" AND   RFQ_NO     =     ?            \n");
//				    sql.append(" AND   RFQ_COUNT  =     ?            \n");
				    
				    SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				    String[][] args = {{info.getSession("HOUSE_CODE"), rfq_no, rfq_count}};
				    String[] type   = {"S", "S", "N"};
				    rtn = sm.doInsert(args,type); 
				    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				    
//				    sql.append(" UPDATE  ICOYRQDT                  \n");
//				    sql.append(" SET     SETTLE_FLAG     = 'D',    \n");
//				    sql.append("         RFQ_PROCEEDING_FLAG = 'D' \n");
//				    sql.append(" WHERE HOUSE_CODE   =     ?        \n");
//				    sql.append(" AND   RFQ_NO       =     ?        \n");
//				    sql.append(" AND   RFQ_COUNT    =     ?        \n");
//				    sql.append(" AND   SETTLE_FLAG <> 'Y'          \n");
				    
				    sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
				    rtn = sm.doInsert(args,type); 
				}catch(Exception e) { 
				    Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				    throw new Exception(e.getMessage()); 
				} 
				return rtn; 
				} 
				   
				private	int	temp_Approval(ConnectionContext	ctx, String	rfq_no,	String rfq_count, String flag) throws Exception 
					{ 
						int	rtn	= 0; 
						SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
						
//						sql.append(" UPDATE	ICOYRQHD						\n");
//						sql.append("   SET  SIGN_STATUS		= ?				\n");			
//						sql.append("	   ,SIGN_PERSON_ID	= ?			    \n");
//						sql.append("	   ,SIGN_DATE		= ?				\n");	
//				 		sql.append(" WHERE HOUSE_CODE		= ?	            \n");
//						sql.append("   AND RFQ_NO			= ?				\n");			
//						sql.append("   AND RFQ_COUNT		= ?				\n");		
//						sql.append("   AND STATUS			IN ('C', 'R')	\n");						
				 
						try	{ 
							SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
							String[] type = {"S", "S", "S", "S", "S"
											,"N"};
							
							String[][] signUpdata = {{flag, info.getSession("ID"), SepoaDate.getShortDateString(), info.getSession("HOUSE_CODE"), rfq_no,
													rfq_count	}};
							
							rtn	= sm.doUpdate(signUpdata, type); 
				 
						} catch(Exception e) { 
							Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
							throw new Exception(e.getMessage()); 
						} 
						return rtn; 
					} 
				
				  public SepoaOut re_getVendorList_all (String rfq_no,String rfq_count,String bid_flag) 
				    { 
				        try{ 
				 
				            String rtn = et_re_getVendorList_all(rfq_no,rfq_count,bid_flag); 
				            setValue(rtn); 
				            setStatus(1); 
				            setMessage(msg.getMessage("0000")); 
				        }catch(Exception e) { 
				            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				            setStatus(0); 
				            setMessage(msg.getMessage("0001")); 
				        } 
				 
				        return getSepoaOut(); 
				    } 
				 
				    private String et_re_getVendorList_all(String rfq_no,String rfq_count,String bid_flag) throws Exception 
				    { 
				        String rtn = null; 
				        ConnectionContext ctx = getConnectionContext(); 
				        
				        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				        wxp.addVar("bid_flag", bid_flag.equals("Y"));
				        try{ 
				        	SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				            String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count};
				            rtn = sm.doSelect(data); 
				        }catch(Exception e) { 
				            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				            throw new Exception(e.getMessage()); 
				        } 
				        return rtn; 
				    } 
	/*
		public SepoaOut ReturnToPR_ITEM(String rfq_no
									,String rfq_count
						    		,String item_no
						    		,String pr_no
						    		,String pr_seq
						    		,String rfq_seq
						    		,String rowcount)
	*/
	    public SepoaOut ReturnToPR_ITEM(		    
	    								 String[][] prdt
	    								,String[][] rqdt 
	    								,String[][] rqhd
	    								,String[][] rqhd_2
	    							  )
		{ 
			try { 
				ConnectionContext ctx = getConnectionContext(); 
				
				int rtn 	= et_ReturnToPR_ITEM_PR(ctx,prdt); 
				int rtn1 	= et_ReturnToPR_ITEM_RFQ(ctx,rqdt); 
				//if(rowcount.equals("1")) et_ReturnToPR_ITEM_ALL(ctx,rfq_no,rfq_count); 
				int rtm2 	= et_ReturnToPR_ITEM_ALL(ctx,rqhd,rqhd_2);
				
				setStatus(1); 
				setValue(String.valueOf(rtn1)); 
				setMessage(msg.getMessage("0017"));
				
				Commit();
			}catch(Exception e) { 
				try{Rollback();}catch(Exception d){Logger.err.println(info.getSession("ID"),this,d.getMessage());} 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage(msg.getMessage("0003")); 
			} 
				return getSepoaOut(); 
		} 

	    private int et_ReturnToPR_ITEM_PR(ConnectionContext ctx,String[][] prdt) throws Exception 
	    { 
	        int rtn = 0; 
	 
	        try{ 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 

	            String[] type = {"S", "S", "S"};

	            rtn = sm.doUpdate(prdt, type); 
	        }catch(Exception e) { 
	            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
	            throw new Exception(e.getMessage()); 
	        } 
	        return rtn; 
	    } 
	 
	    private int et_ReturnToPR_ITEM_RFQ(ConnectionContext ctx, 
	                                     String[][] rqdt) throws Exception 
	    { 

	        int rtn = 0; 
	 
	        try{ 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 

	            String[] type = {"S", "S", "N", "S"};

	            rtn = sm.doUpdate(rqdt, type); 
	        }catch(Exception e) { 
	            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
	            throw new Exception(e.getMessage()); 
	        } 
	        return rtn; 
	    } 
	 
	    private int et_ReturnToPR_ITEM_ALL(ConnectionContext ctx,String[][] rqhd, String[][] rqhd_2) throws Exception 
	    { 
	        int rtn = 0; 
	 
	        try{ 
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
	            String[] type = {"S", "S", "N","S", "S", "N"};
	            rtn = sm.doUpdate(rqhd, type); 
	            
	            
	            wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
	            sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	            String[] type_2 = {"S", "S", "S","S","S"};
	            rtn = sm.doUpdate(rqhd_2, type_2); 
	            
	            
	        }catch(Exception e) { 
	            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
	            throw new Exception(e.getMessage()); 
	        } 
	        return rtn; 
	    } 
	    
	    //업체선정결과보기(상세) 
	    public SepoaOut getVendorList (String rfq_no,String rfq_count,String rfq_seq,String bid_flag) 
	    { 
	        try{ 
	 
	            String rtn = et_getVendorList(rfq_no,rfq_count,rfq_seq, bid_flag); 
	            setValue(rtn); 
	            setStatus(1); 
	            setMessage(msg.getMessage("0000")); 
	        }catch(Exception e) { 
	            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
	            setStatus(0); 
	            setMessage(msg.getMessage("0001")); 
	        } 
	 
	        return getSepoaOut(); 
	    } 
	 
	    private String et_getVendorList(String rfq_no,String rfq_count,String rfq_seq,String bid_flag) throws Exception 
	    { 
	        String house_code   = info.getSession("HOUSE_CODE"); 
	 
	        String rtn = null; 
	        ConnectionContext ctx = getConnectionContext(); 
	        StringBuffer sql = new StringBuffer(); 
	        
	        sql.append("         SELECT VENDOR_CODE,                      \n");
	        sql.append("                GETCOMPANYNAMELOC(S.HOUSE_CODE, S.VENDOR_CODE, 'S') AS VENDOR_NAME,  \n");
	        sql.append("                ' ' AS DIS,                       \n");
	        sql.append("                ' ' AS NO,                        \n");
	        sql.append("                ' ' AS NAME                       \n");
	        sql.append("         FROM   ICOYRQSE S                        \n");
	        sql.append("         WHERE  STATUS IN ('C','R')               \n");
	        sql.append("        <OPT=S,S> AND    HOUSE_CODE  = ?  </OPT>  \n");
	        sql.append("        <OPT=S,S> AND    RFQ_NO      = ?  </OPT>  \n");
	        sql.append("        <OPT=S,S> AND    RFQ_COUNT   = ?  </OPT>  \n");
	        sql.append("        <OPT=S,S> AND    RFQ_SEQ     = ?  </OPT>  \n");
	        
	        if(bid_flag.equals("Y")){ 
	            sql.append(" AND CNV_NULL(BID_FLAG,'Y') <> 'N'       			\n");
	        } 
	 
	        try{ 
	            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
	            
	            String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count, rfq_seq};
	            rtn = sm.doSelect(data); 
	        }catch(Exception e) { 
	            Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
	            throw new Exception(e.getMessage()); 
	        } 
	        return rtn; 
	    } 
	

}
