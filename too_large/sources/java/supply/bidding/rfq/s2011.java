package	supply.bidding.rfq;  
  
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
 
  
////////////////////////  
/*  
getQuery_New_Rfq_List :	신규견적요청현황 (rfq_bd_lis1.jsp, rfq_bd_lis1.java)  
setRejectRfq		  :	신규견적요청현황에서 '입찰거부'	(rfq_bd_lis1.jsp, rfq_bd_lis1.java)  
getCurrentRfqList	  :	견적요청현황조회 (rfq_bd_lis2.jsp, rfq_bd_lis2.java)  
getRfqHDDisplay		  :	견적요청상세조회HD(rfq_bd_dis1.jsp,	rfq_bd_dis1.java)  
getRfqDTDisplay		  :	견적요청상세조회DT(rfq_bd_dis1.jsp,	rfq_bd_dis1.java)  
getQuery_RFQNO_pop	  :	견적요청번호 팝업(rfq_no_pop_c.jsp)--> 생성	화면일때만...  
getQuery_RFQNO_pop_Mod:	견적요청번호 팝업(rfq_no_pop_c.jsp)--> 수정	화면일때만...  
getQuery_RFQNO_pop_Dis:	견적요청번호 팝업(rfq_no_pop_c.jsp)--> 조회	화면일때만...  
  
getRfqHDDisplay_TYPE  :	견적요청 팝업 HD(rfq_pp_dis1.jsp)  
getRfqDTDisplay_TYPE  :	견적요청 팝업 DT(rfq_pp_dis1.jsp)  
  
*/  
////////////////////////  

public class s2011 extends SepoaService  
{  
	//Session 정보를 담기위한 변수  
	String status =	"";   
	
	private	String lang	= info.getSession("LANGUAGE");  
	private	Message	msg; 
   
	public s2011(String	opt,SepoaInfo info) throws SepoaServiceException  
	{  
		 super(opt,info);
	     setVersion("1.0.0");
	     msg = new Message(info,"STDRFQ");
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
	 * 신규견적요청현황일반/지명 견적
	 * @method getQuery_New_Rfq_List
	 * @param  header : start_date, end_date,	status,   bid_rfq_type,  create_type
	 * @return SepoaOut
	 * @throws Exception
	 * @desc   
	 * @since  2014-10-15
	 * @modify 2014-10-15
	 */
	public SepoaOut getQuery_New_Rfq_List(Map<String, String> header) {  
		try	{  
			String rtn = "";  
  
			//지명, 공개 모두 조회 & 견적서 제출 가능하게 변경함.
			rtn	= et_getQuery_New_Rfq_List(header);  
				
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
	 * 신규견적요청현황일반/지명 견적
	 * @method et_getQuery_New_Rfq_List
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-10-15
	 * @modify 2014-10-15
	 */
	private	String et_getQuery_New_Rfq_List(Map<String, String> header ) throws	Exception  
	{  
		
		
		
		String rtn = "";  
		ConnectionContext ctx =	getConnectionContext();  
		String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
		
		try	{  
			//String house_code  = info.getSession("HOUSE_CODE");
			//String vendor_code = info.getSession("COMPANY_CODE");
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			//wxp.addVar("house_code",    house_code);
			//wxp.addVar("vendor_code",   vendor_code);
			//wxp.addVar("status", status);
			//wxp.addVar("cur_date_time", cur_date_time);
			header.put("cur_date_time", cur_date_time);
			
			
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			//create_type = 'PC' 에서 PC/BD/AC 모두 가능하게 변경함.
			//String[] args =	{"", start_date, end_date ,cur_date_time,  bid_rfq_type};  
			
			rtn	= sm.doSelect(header);  
  
			if(rtn == null)	throw new Exception("SQL Manager is	Null");  
		}catch(Exception e)	{  
		  throw	new	Exception("et_getQuery_New_Rfq_List=========>"+e.getMessage());  
		} finally{  
		}  
		return rtn;  
	}

	/*public SepoaOut getQuery_New_Rfq_List(String start_date, String end_date, String status, String bid_rfq_type, String create_type ) {  
		try	{  
			String rtn = new String();  
  
			//지명, 공개 모두 조회 & 견적서 제출 가능하게 변경함.
			rtn	= et_getQuery_New_Rfq_List(start_date, end_date,	status,   bid_rfq_type,  create_type);  
				
			setValue(rtn);  
			setStatus(1);  
  
		}catch (Exception e){  
			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage());  
			setMessage(msg.getMessage("0001"));  
			setStatus(0);  
		}  
		return getSepoaOut();  
	}  
  
	//신규견적요청현황 일반/지명 견적Query  
	private	String et_getQuery_New_Rfq_List(String start_date, String end_date, String status, String bid_rfq_type, String create_type ) throws	Exception  
	{  
		String rtn = new String();  
		ConnectionContext ctx =	getConnectionContext();  
		String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
		
		try	{  
			String house_code  = info.getSession("HOUSE_CODE");
			String vendor_code = info.getSession("COMPANY_CODE");
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code",    house_code);
			wxp.addVar("vendor_code",   vendor_code);
			wxp.addVar("status", status);
			
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			//create_type = 'PC' 에서 PC/BD/AC 모두 가능하게 변경함.
			String[] args =	{"", start_date, end_date ,cur_date_time,  bid_rfq_type};  
			rtn	= sm.doSelect(args);  
  
			if(rtn == null)	throw new Exception("SQL Manager is	Null");  
		}catch(Exception e)	{  
		  throw	new	Exception("et_getQuery_New_Rfq_List=========>"+e.getMessage());  
		} finally{  
		}  
		return rtn;  
	}*/
	

	public SepoaOut getRfqHDDisplay_TYPE(String rfq_no, String rfq_count)  
	{  
		try{  
			String rtn = "";  
  
			int	confirm_cnt	= setUpdate_rqse_con(rfq_no, rfq_count);  
  
			String tmp_chk = Check_RFQ_TYPE(rfq_no,	rfq_count);  
			String flag	= "";  
  
			SepoaFormater wf1 = new SepoaFormater(tmp_chk);  
			flag = wf1.getValue(0,0);  
  
			rtn	= et_getRfqHDDisplay_TYPE(rfq_no,rfq_count);  
/*
			if(!flag.equals("OP")) {  
				rtn	= et_getRfqHDDisplay_TYPE(rfq_no,rfq_count);  
			} else {  
				rtn	= et_getRfqHDDisplay(rfq_no,rfq_count);  
			}  
*/  
			if(	confirm_cnt	> 0	) Commit();  
			else Rollback();  
  
			setValue(rtn);  
			setStatus(1);  
			setMessage(msg.getMessage("0000"));  
  
		}catch(Exception e)	{  
			try{  
				Rollback();  
			}catch(Exception ee){ setStatus(0); }  
  
			Logger.err.println(info.getSession("ID"),this,e.getMessage());  
			setStatus(0);  
			setMessage(msg.getMessage("0001"));  
		}  
		return getSepoaOut();  
	}  
  
  
	private	int	setUpdate_rqse_con (String RFQ_NO, String RFQ_COUNT)  throws Exception  
	{  
		int	rtn	= -1;  
  
		ConnectionContext ctx =	getConnectionContext();  
		SepoaSQLManager sm =	null;  
  
		try	{  

			String HOUSE_CODE	= info.getSession("HOUSE_CODE");  
			String VENDOR_CODE	= info.getSession("COMPANY_CODE");  
			String ADD_USER_ID	= info.getSession("ID");  
			String cur_date     = SepoaDate.getShortDateString();
			String cur_time     = SepoaDate.getShortTimeString();
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			  
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type = {"S", "S", "S", "S", "S"
							, "S", "N"};
			String[][] setData = {{cur_date, cur_time, ADD_USER_ID, HOUSE_CODE, VENDOR_CODE
									,RFQ_NO, RFQ_COUNT}};
			rtn	= sm.doUpdate(setData,type);  
  
		}catch(Exception e)	{  
			Logger.err.println(userid,this,e.getMessage());  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	
	private	String Check_RFQ_TYPE(String rfq_no, String	rfq_count)  
	throws Exception  
	{  
		String rtn = null;  
		ConnectionContext ctx =	getConnectionContext();  
 
		try	{  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());

			SepoaSQLManager sm =	new	SepoaSQLManager("JHYOON",this,ctx,wxp.getQuery());  
  
			String[] args =	{info.getSession("HOUSE_CODE"), rfq_no, rfq_count};  
			rtn	= sm.doSelect(args);  
			if(rtn == null)	throw new Exception("SQL Manager is	Null");  
		}catch(Exception e)	{  
			throw new Exception("Check_RFQ_TYPE:"+e.getMessage());  
		} finally{  
		}  
		return rtn;  
	}
	
	
	private	String et_getRfqHDDisplay_TYPE(	String rfq_no,String rfq_count)	throws Exception  
	{  
  
		String rtn = null;  
		ConnectionContext ctx =	getConnectionContext();  
  
		String company_code	= info.getSession("COMPANY_CODE");
		
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		
		try{  
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			String[] data = {company_code, info.getSession("HOUSE_CODE"), rfq_no, rfq_count};
			rtn	= sm.doSelect(data); 
			
		}catch(Exception e)	{  
			Logger.err.println(info.getSession("ID"),this,e.getMessage());  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	
	private	String et_getRfqHDDisplay( String rfq_no,String	rfq_count) throws Exception  
	{  
  
		String rtn = null;  
		ConnectionContext ctx =	getConnectionContext();  
		String house_code =	info.getSession("HOUSE_CODE");  
		String company_code	= info.getSession("COMPANY_CODE");  
  
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("getConfig", getConfig("sepoa.generator.db.selfuser"));
		wxp.addVar("house_code", house_code);
		wxp.addVar("rfq_count", rfq_count);
		wxp.addVar("rfq_no", rfq_no);
		wxp.addVar("rfq_count", rfq_count);
		
		try{  
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			rtn	= sm.doSelect((String[])null);  
		}catch(Exception e)	{  
			Logger.err.println(info.getSession("ID"),this,e.getMessage());  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	
	
	public SepoaOut getRfqDTDisplay_TYPE(Map<String, String> header)  
	{  
		try{  
			String rtn = "";  
  
			rtn	= et_getRfqDTDisplay(header);  
  
			setValue(rtn);  
			setStatus(1);  
			setMessage(msg.getMessage("0000"));  
		}catch(Exception e)	{  
			Logger.err.println(info.getSession("ID"),this,e.getMessage());  
			setStatus(0);  
			setMessage(msg.getMessage("0001"));  
		}  
		return getSepoaOut();  
	}  
  
	private	String et_getRfqDTDisplay(Map<String, String> header) throws Exception  
	{  
  
		String rtn = null;  
		ConnectionContext ctx =	getConnectionContext();  
  
		SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("group_yn", header.get("group_yn"));  
		wxp.addVar("company_code", info.getSession("COMPANY_CODE"));  

		try{  
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			//String[] data = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count};
			rtn	= sm.doSelect(header);  
		}catch(Exception e)	{  
			Logger.err.println(info.getSession("ID"),this,e.getMessage());  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	
	/**
	 * 견적포기
	 * @method setRejectRfq
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-11-07
	 * @modify 2014-11-07
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut setRejectRfq(Map<String, Object> svcParam)  throws Exception {  
    	
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;

		int	rtn_ins	= 0;
		int	rtn   	= 0;  
    	
        try	{  
            
        	grid = (List<Map<String, String>>)svcParam.get("gridData");
        	
        	for(int i=0; i<grid.size();i++){
        		gridInfo = grid.get(i);

        		
        		
        		if("OP".equals(gridInfo.get("RFQ_TYPE"))){        		
        			rtn_ins = et_setInsert_icoyrqse(gridInfo.get("RFQ_NO"),	gridInfo.get("RFQ_COUNT"));
        		}
        		
        		rtn =	et_setRejectRfq(gridInfo);  
        	      
        	}
        	
        	/*if(RFQ_TYPE.equals("OP")) {
                for(int i=0; i<setData.length; i++) {
                    int	rtn_ins	= et_setInsert_icoyrqse(setData[i][0],	setData[i][1], info.getSession("ID"));
                }
            }
            */
      //    rtn =	et_setRejectRfq(grid);  
      
          setStatus(1);  
          setValue(Integer.toString(rtn));  
      
          if(rtn >=	0) {
             setMessage("견적포기가 완료됐습니다."); //	"입찰거부가	완료됐습니다."  
          }  
          else {  
             setMessage("견적포기에 실패했습니다."); //	"입찰거부에	실패했습니다."  
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
  
	private	int	et_setRejectRfq	(Map<String, String> data) throws	Exception  
	{  
		int	rtn	= 0;  
		SepoaSQLManager sm =	null;  
		ConnectionContext ctx =	getConnectionContext();  
		//String house_code =	info.getSession("HOUSE_CODE");  
		//String company_code	= info.getSession("COMPANY_CODE");  
		
		try	{  
			
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			//wxp.addVar("date", SepoaDate.getShortDateString());  
			//wxp.addVar("time", SepoaDate.getShortTimeString());  
			//wxp.addVar("house_code", house_code);  
			//wxp.addVar("company_code", company_code);  
			
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			//String[] type =	{"S","S"};  
			rtn	= sm.doUpdate(data);  
  
		}catch(Exception e)	{  
			try{  
				Rollback();  
			}catch(Exception e1){ Logger.err.println(info.getSession("ID"),this,"et_setRejectRfq:==>"+e.getMessage());   }  
			Logger.err.println(info.getSession("ID"),this,"et_setRejectRfq:==>"+e.getMessage());  
			rtn	= -1;  
			throw new Exception("입찰거부 에러......");  
		} finally{  
		}  
		return rtn;  
	}
	
	
	private	int	et_setInsert_icoyrqse(String rfq_no, String	rfq_count) throws Exception	{  
		int	rtn	= -1;  
		ConnectionContext ctx =	getConnectionContext();  
		//String HOUSE_CODE =	info.getSession("HOUSE_CODE");  
		//String COMPANY_CODE	= info.getSession("COMPANY_CODE");  
		String result =	"";  
		int	cnt	= 0;  
		Map<String, String> param = new HashMap<String, String>();
  
		try	{  
			SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_1"); 
			
			SepoaSQLManager smcon = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			//String[] data = {info.getSession("HOUSE_CODE"), info.getSession("COMPANY_CODE"), rfq_no, rfq_count};
			param.put("rfq_no", 	rfq_no);
			param.put("rfq_count",  rfq_count);
			
			
			result = smcon.doSelect(param);
			
			SepoaFormater wf	= new SepoaFormater(	result );  
			cnt	= Integer.parseInt(	wf.getValue( 0,	0 )	);    
  
			if (cnt	== 0)  // ICOYRQSE에 data 없을때만 데이타 입력  
			{  
				wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName()+"_2"); 
				
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				//String[] type = {"S", "S", "S", "N"};
				//String[][]  setdata = {{info.getSession("COMPANY_CODE"),info.getSession("HOUSE_CODE"), rfq_no, rfq_count}};
				rtn	= sm.doInsert(param);  
			}  
  
		}catch(Exception e)	{  
			throw new Exception("et_setSave:"+e.getMessage());  
		} finally{}  
		return rtn;  
  
	}
  
}  
  
