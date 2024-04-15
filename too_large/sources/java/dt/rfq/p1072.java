package	dt.rfq; 
 
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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

 
 
/** 
 * <code> 
 * 
 * 업체선정	service  
 *  
 * <pre> 
 * (#)dt/pr/p1003.java	  01/06/27 
 * Copyright 2001-2001 ICOMPIA Co.,	Ltd. All Rights	Reserved. 
 * This	software is	the	proprietary	information	of ICOMPIA Co.,	Ltd. 
 * @version		   1.0 
 * @author		   송지용 
 * </code></pre> 
 */ 
 
/*** 
- 1. Doc Base 
 
1) getDocBaseQtaCompareHD			 Doc Base 업체선정화면 top조회			  qta_pp_ins1_1.jsp				 dt.rfq.qta_pp_ins1_1.java 
2) getDocBaseQtaCompareDT			 Doc Base 업체선정화면 bottom조회		  qta_pp_ins1_2.jsp				 dt.rfq.qta_pp_ins1_2.java 
3) setDocTotalSave					 Doc Base 업체선정(전체)				 qta_pp_ins1_2.jsp				dt.rfq.qta_pp_ins1_2.java 
4) setReturnToPR_DOC_ALL			 Doc Base 청구복구						 qta_pp_ins1_2.jsp				dt.rfq.qta_pp_ins1_2.java 
5) getDocBaseDetailHD				 Doc Base 품번별상세입력 HD	조회		  qta_pp_ins4.jsp 
6) getDocBaseDetailDT				 Doc Base 품번별상세입력 DT	조회		  qta_pp_ins4.jsp				 dt.rfq.qta_pp_ins4.java 
7) setDocDetailSave					 Doc Base 품번별상세입력				  qta_pp_ins4_hidden.jsp		 dt.rfq.qta_pp_ins4_hidden.java 
 
- 2. 업체선정대기목록 
 
1) getSettleVendor					 업체선정대기목록						   qta_bd_lis2.jsp				  dt.rfq.qta_bd_lis2.java 
2) setRFQClose						 견적마감하기							   qta_bd_lis2.jsp				  dt.rfq.qta_bd_lis2.java 
 
- 3. Item Base 
 
1) setReturnToPR_ItemBase			 Item Base 업체선정에서	청구복구		   qta_bd_ins2.jsp 
2) getQuery_getRfqSeq				 Item Base 업체선정에서	RFQ_SEQ	가져오기   qta_bd_ins2.jsp 
5) setItemTotalSave					 Item Base 업체선정						  qta_bd_ins2_hidden.jsp		 dt.rfq.qta_bd_ins2_hidden.java 
6) getItemBaseDetailHD				 Item Base 품번별상세입력 HD 조회		   qta_bd_ins6.jsp 
7) getItemBaseDetailDT				 Item Base 품번별상세입력 DT 조회		   qta_bd_ins6.jsp				   dt.rfq.qta_bd_ins6.java 
8) setItemDetailSave				 Item Base 품번별상세입력				  qta_pp_ins6.jsp				   dt.rfq.qta_bd_ins6.java

* getQtaCompareItem                  Item Base 업체선정화면 데이터 가져오기 
 
 
 
***/ 
public class p1072 extends SepoaService 
{ 
	private	String lang	  =	info.getSession("LANGUAGE"); 
	private	Message	msg;
 
	public p1072(String	opt,SepoaInfo info) throws SepoaServiceException 
	{ 
		super(opt,info); 
		setVersion("1.0.0");
		msg = new Message(info, "STDQTA");
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

	public SepoaOut getSettleVendor(Map<String, String> header) throws Exception {
		
		ConnectionContext ctx                   = getConnectionContext();
		SepoaXmlParser    sxp                   = null;
		SepoaSQLManager   ssm                   = null;
		String            rtn                   = null;
		String            id                    = info.getSession("ID");
		
		
	    
		try{
			
			sxp = new SepoaXmlParser(this, "getSettleVendor");
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
	 * 견적결과조회 선정취소
	 * @method setReturnToSettle2
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut setReturnToSettle2(Map<String, Object> param) throws Exception{
		int                       rtn            = 0;
		ConnectionContext         ctx            = null;
		
		List<Map<String, String>> qtdtData       = (List<Map<String, String>>)param.get("qtdtData");	//견적서 상세정보
		List<Map<String, String>> rqhdData       = (List<Map<String, String>>)param.get("rqhdData");	//견적의뢰 일반정보
		List<Map<String, String>> rqdtData       = (List<Map<String, String>>)param.get("rqdtData");	//견적의뢰 상세정보
		List<Map<String, String>> prdtData       = (List<Map<String, String>>)param.get("prdtData");	//구매요청 상세정보
		
			    
		try {
			ctx = getConnectionContext();  
			
			rtn = this.et_setReturnToSettle2_1(ctx, qtdtData);				//견적서 상세정보
	
			rtn += this.et_setReturnToSettle2_2(ctx, rqhdData);				//견적의뢰 일반정보
			
			rtn += this.et_setReturnToSettle2_3(ctx, rqdtData);				//견적의뢰 상세정보
			
			rtn += this.et_setReturnToSettle2_4(ctx, prdtData);				//구매요청 상세정보

			setStatus(1); 
			setValue(String.valueOf(rtn));
						
			Commit(); 
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
		
	}
	
	/**
	 * 견적결과조회 선정취소 실행
	 * @param ctx 
	 * @method et_setReturnToSettle2_4
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   (견적의뢰상세, 견적의뢰, 견적서, 구매요청 테이블 수정)
	 * @since  2014-10-14
	 * @modify 2014-10-14
	 */
	private int et_setReturnToSettle2_4(ConnectionContext ctx, List<Map<String, String>> prdtData) throws Exception {
		int rtn                          = -1;  
		SepoaXmlParser wxp               = null;
		SepoaSQLManager sm               = null;
		
		Map<String, String> prdtDataInfo = null;
		
		try {  
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			
			
			for(int i = 0; i < prdtData.size() ; i++){
				
				prdtDataInfo = prdtData.get(i);
				rtn	= rtn + sm.doInsert(prdtDataInfo);
			}
			
		}catch(Exception e) {  
			
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;
	}
	
	/**
	 * 견적결과조회 선정취소 실행
	 * @param ctx 
	 * @method et_setReturnToSettle2_2
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   (견적의뢰상세, 견적의뢰, 견적서, 구매요청 테이블 수정)
	 * @since  2014-10-14
	 * @modify 2014-10-14
	 */
	private int et_setReturnToSettle2_2(ConnectionContext ctx, List<Map<String, String>> rqhdData) throws Exception {
		int rtn                          = -1;  
		SepoaXmlParser wxp               = null;
		SepoaSQLManager sm               = null;
		
		Map<String, String> rqhdDataInfo = null;
		
		try {  
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			
			
			for(int i = 0; i < rqhdData.size() ; i++){
				
				rqhdDataInfo = rqhdData.get(i);
				rtn	= rtn + sm.doInsert(rqhdDataInfo);
			}
			
		}catch(Exception e) {  
			
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;
	}
	
	/**
	 * 견적결과조회 선정취소 실행
	 * @param ctx 
	 * @method et_setReturnToSettle2_3
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   (견적의뢰상세, 견적의뢰, 견적서, 구매요청 테이블 수정)
	 * @since  2014-10-14
	 * @modify 2014-10-14
	 */
	private int et_setReturnToSettle2_3(ConnectionContext ctx, List<Map<String, String>> rqdtData) throws Exception {
		int rtn                          = -1;  
		SepoaXmlParser wxp               = null;
		SepoaSQLManager sm               = null;
		
		Map<String, String> rqdtDataInfo = null;
		
		try {  
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			
			
			for(int i = 0; i < rqdtData.size() ; i++){
				
				rqdtDataInfo = rqdtData.get(i);
				rtn	= rtn + sm.doInsert(rqdtDataInfo);
			}
			
		}catch(Exception e) {  
			
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;
	}

	/**
	 * 견적결과조회 선정취소 실행
	 * @param ctx 
	 * @method et_setReturnToSettle2_1
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   (견적의뢰상세, 견적의뢰, 견적서, 구매요청 테이블 수정)
	 * @since  2014-10-14
	 * @modify 2014-10-14
	 */
	private int et_setReturnToSettle2_1(ConnectionContext ctx, List<Map<String, String>> qtdtData) throws Exception {
		int rtn                          = -1;  
		SepoaXmlParser wxp               = null;
		SepoaSQLManager sm               = null;
		
		Map<String, String> qtdtDataInfo = null;
		
		try {  
			wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			
			
			
			for(int i = 0; i < qtdtData.size() ; i++){
				
				
				qtdtDataInfo = qtdtData.get(i);
				rtn	= rtn + sm.doInsert(qtdtDataInfo);
			}
			
		}catch(Exception e) {  
			
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e));  
			throw new Exception(e.getMessage());  
		}  
		return rtn;  
	}
	
	/*
	
	private int et_setReturnToSettle2(Map<String, Object> param) throws Exception {
		
		ConnectionContext         ctx          = null;
		SepoaSQLManager           ssm	       = null;
		int                    rtn             = 0; 
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
		List<Map<String, String>> grid     	   = null;
		Map<String, String>       gridInfo     = null;
		String                    id           = info.getSession("ID");
		
		System.out.println("debug:214=>"+rtn);
		System.out.println("debug:215=>"+sxp.getQuery());
		
		
		  
		try{ 
			ctx = getConnectionContext();
			grid = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
			System.out.println("debug:2580=>"+grid.size());
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                sxp = new SepoaXmlParser(this, "et_setRFQExtends");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
//                gridInfo.put("HOUSE_CODE",   info.getSession("HOUSE_CODE"));
//                System.out.println("debug:2593=>"+gridInfo);
                ssm.doUpdate(gridInfo);
			}
			
			
			ssm	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			//String[] type_rqdt = {"S", "S", "N"};
			rtn	= ssm.doUpdate(rqdtData); //견적의뢰 상세정보
			System.out.println("debug:221=>"+rtn);
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			ssm	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			//String[] type_rqhd = {"S", "S"   };
			rtn	= ssm.doUpdate(rqhdData); //견적의뢰 일반정보
			System.out.println("debug:227=>"+rtn);
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
			ssm	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			//String[] type_qtdt = {"S", "S" };
			rtn	= ssm.doUpdate(qtdtData); //견적서 상세정보
			System.out.println("debug:233=>"+rtn);
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
			ssm	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			//String[] type_prdt = {"S", "S", "S" };
			rtn	= ssm.doUpdate(prdtData); //구매요청 상세정보
			System.out.println("debug:239=>"+rtn);
			
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	}*/
	
	/**
	 * 견적 비교 업체 선정
	 * @method setDocTotalSave
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc  
	 * @since  2014-10-13
	 * @modify 2014-10-13
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut setDocTotalSave(Map<String, Object> param)throws Exception{
			/*String[][] rqdtData
			, String[][] rqdtData_res
			, String[][] delrqopdata
			, String[][] rqopdata
			, String[][] qtdtData
			, String[][] prData
			, String     rfq_no
			, String     rfq_count*/
			
		int	rtn	                               = 0; 
		ConnectionContext         ctx          = getConnectionContext();
		String                    rfq_no       = (String)param.get("RFQ_NO");
		String                    rfq_count    = (String)param.get("RFQ_COUNT");
		List<Map<String, String>> rqdtData     = (List<Map<String, String>>)param.get("rqdtData");
		List<Map<String, String>> rqdtResData  = (List<Map<String, String>>)param.get("rqdtResData");
		List<Map<String, String>> delRqopData  = (List<Map<String, String>>)param.get("delRqopData");
		List<Map<String, String>> rqopData     = (List<Map<String, String>>)param.get("rqopData");
		List<Map<String, String>> qtdtData     = (List<Map<String, String>>)param.get("qtdtData");
		List<Map<String, String>> prData       = (List<Map<String, String>>)param.get("prData");

		
    	setStatus(1);
		setFlag(true);
		
		
		try 
		{ 

			rtn = et_setItemDetail_RQDT(ctx, rqdtData, rqdtResData);			// 견적의뢰 상세정보 플래그 수정 (ICOYRQDT)
			
			rtn += et_delRQOP(ctx, delRqopData);									// 견적의뢰 단가 구매지역 정보 자료 삭제 ICOYRQOP
			
			rtn += et_setRfqOPCreate(ctx, rqopData);						      //견적의뢰 단가 구매지역 정보 입력 (ICOYRQOP)
			
			rtn += et_setItemDetail_QTDT(ctx, qtdtData);							//견적서 상세정보 수정(ICOYQTDT)
			
			rtn += et_setItemRQHD_FlagUPDATE(ctx, rfq_no, rfq_count);				//견적의뢰 일반정보 플래그 수정(ICOYQTHD)
			
			rtn += et_setPRComfirm(ctx, prData); 
			
			setStatus(1); 
			setValue(String.valueOf(rtn)); 
			setMessage(msg.getMessage("0009")); 
			
			Commit();
		} catch(Exception e) { 
		try{ 
			Rollback(); 
		} catch (Exception d) { 
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"),this,"ERROR========>"+stackTrace(d)); 
		} 
		
		setStatus(0); 
		setMessage(msg.getMessage("0010")); 
		} 
		return getSepoaOut(); 
		
		}	
	
	
	/*public SepoaOut getSettleVendor (String start_date, 
			String end_date, 
			String rfq_no, 
			String settle_type, 
			String subejct,
			String ctrl_person_id,
			String bid_rfq_type) 
{ 
		
		try{ 
		
		String rtn = et_getSettleVendor(start_date,end_date,rfq_no,settle_type,subejct, ctrl_person_id,bid_rfq_type); 
		setValue(rtn);  
		setStatus(1); 
		SepoaFormater wf = new SepoaFormater(rtn);
		
		if(wf.getRowCount() == 0) setMessage(msg.getMessage("0006"));
		else {
		setMessage(msg.getMessage("0003"));
		}			
		}catch(Exception e)	{ 
		Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
		setStatus(0); 
		setMessage(msg.getMessage("0005")); 
		} 
		
		return getSepoaOut(); 
		} 
		
		private	String et_getSettleVendor(String start_date, 
					String end_date, 
					String rfq_no, 
					String settle_type, 
					String subejct,
					String ctrl_person_id,
					String bid_rfq_type) throws Exception 
		{ 
		
		String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
		
		String rtn = null; 
		ConnectionContext ctx =	getConnectionContext(); 
		
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		sxp.addVar("bid_rfq_type", bid_rfq_type.equals("PR"));
//		StringBuffer sql = new StringBuffer(); 
//		
//		sql.append(" SELECT  H.RFQ_NO                                    AS RFQ_NO,                             	\n");
//		sql.append("         H.RFQ_COUNT                                 AS RFQ_COUNT,                          	\n");
//		sql.append("         H.SUBJECT                                   AS SUBJECT,                            	\n");
//		sql.append("         dbo.GETICOMCODE2(H.HOUSE_CODE,'M149',H.SETTLE_TYPE) AS SETTLE_TYPE_TXT,                	\n");
//		sql.append("         substring(H.RFQ_CLOSE_DATE,0,4)+'/'+substring(H.RFQ_CLOSE_DATE,5,2)                    	\n");
//		sql.append(" 		+'/'+substring(H.RFQ_CLOSE_DATE,7,2)+'  '+substring(H.RFQ_CLOSE_DATE+H.RFQ_CLOSE_TIME,9,2)      \n");
//		sql.append(" 		+ ':' + substring(H.RFQ_CLOSE_DATE+H.RFQ_CLOSE_TIME,11,2) AS CLOSE_DATE,    			\n");
//		sql.append("         H.BID_COUNT                                 AS BIDDER,                             	\n");
//		sql.append("         dbo.GETUSERNAME(H.HOUSE_CODE, H.CHANGE_USER_ID ,'LOC') AS CHANGE_USER_NAME,            	\n");
//		sql.append("         H.CTRL_CODE                                 AS CTRL_CODE,                          	\n");
//		sql.append("         H.RFQ_TYPE                                  AS RFQ_TYPE,                           	\n");
//		sql.append("         H.SETTLE_TYPE                               AS SETTLE_TYPE,                         	\n");
//		sql.append("         H.BID_REQ_TYPE                               AS BID_REQ_TYPE                         	\n");
//		sql.append(" FROM    ICOYRQHD H                                                                         	\n");
//		sql.append(" <OPT=S,S> WHERE   H.HOUSE_CODE    = ?   </OPT>                                             	\n");
//		sql.append(" AND H.BID_TYPE          = 'RQ'                                                             	\n");
//		sql.append(" AND H.STATUS IN    ('C','R')                                                               \n");
//		sql.append(" AND H.RFQ_FLAG          = 'P'                                                              \n");
//		sql.append(" <OPT=S,S> AND    (cast(? as numeric(18)) >= cast(H.RFQ_CLOSE_DATE + H.RFQ_CLOSE_TIME as numeric(18))          \n");
//		sql.append("         OR (H.RFQ_TYPE IN ('MA','MI','SI')))      </OPT>                                   \n");
//		sql.append(" <OPT=S,S> AND H.SETTLE_TYPE    = ?  </OPT>                                                 \n");
//		sql.append(" <OPT=S,S> AND H.CHANGE_DATE    BETWEEN ? </OPT> <OPT=S,S> AND ? </OPT>                     \n");
//		sql.append(" <OPT=S,S> AND H.RFQ_NO            = ?    </OPT>                                            \n");
//		sql.append(" <OPT=S,S> AND H.CHANGE_USER_ID    = ?    </OPT>                                            \n");
//		if(bid_rfq_type.equals("PR")) sql.append(" AND H.BID_RFQ_TYPE  = 'PR'                                     \n");
//		else sql.append(" AND H.BID_RFQ_TYPE   IN ('PC','BD')                                       \n");
//		sql.append(" ORDER BY H.RFQ_NO DESC                                                                     \n"); 
		
		try{ 
		SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
		String[] data =	{info.getSession("HOUSE_CODE"), cur_date_time, settle_type, start_date
			, end_date, rfq_no, ctrl_person_id }; 
		rtn	= sm.doSelect(data); 
		}catch(Exception e)	{ 
		Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
		throw new Exception(e.getMessage()); 
		} 
		return rtn; 
		} 
		*/
//		청구복구(DOC ALL) 
		/*public SepoaOut setReturnToSettle2(String[][]	rqdtData, String[][] rqhdData, String[][] qtdtData, String[][] prdtData ) 
		{ 
			//String lang	  =	info.getSession("LANGUAGE"); 
			//Message msg = new Message(info, "STDQTA");
			try 
			{ 
				int	rtn	= et_setReturnToSettle2(rqdtData, rqhdData, qtdtData, prdtData); 
				setStatus(1); 
				setValue(String.valueOf(rtn)); 
				setMessage(msg.getMessage("0013")); 
				Commit(); 
	 
			}catch(Exception e)	{ 
				try{Rollback();}catch(Exception	d){Logger.err.println(info.getSession("ID"),this,d.getMessage());} 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage(msg.getMessage("0012")); 
			} 
			return getSepoaOut(); 
		} 
	 
		private	int	et_setReturnToSettle2(String[][]	rqdtData, String[][] rqhdData, String[][] qtdtData, String[][] prdtData) throws Exception 
		{ 
	 
			int	rtn	= 0; 
	 
			ConnectionContext ctx =	getConnectionContext(); 
	 
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

	  
			try{ 
				SepoaSQLManager smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				String[] type_rqdt = {"S", "S", "N"};
				rtn	= smdt.doUpdate(rqdtData, type_rqdt); 
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				String[] type_rqhd = {"S", "S"   };
				rtn	= smdt.doUpdate(rqhdData, type_rqhd); 
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
				smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				String[] type_qtdt = {"S", "S" };
				rtn	= smdt.doUpdate(qtdtData, type_qtdt); 
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
				smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				String[] type_prdt = {"S", "S", "S" };
				rtn	= smdt.doUpdate(prdtData, type_prdt); 
	  
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		}*/

	/**
	 * 견적의뢰 일반정보 플래그 수정(ICOYRQHD)
	 * @method et_setItemRQHD_FlagUPDATE
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-10-13
	 * @modify 2014-10-13
	 */
	private	int	et_setItemRQHD_FlagUPDATE(	ConnectionContext ctx, 
											String rfq_no, 
											String rfq_count)	throws Exception 
				{ 
				int	rtn	= 0; 
				
				SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				
	
				try{ 
					SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
					
					//String[][] setData = {{info.getSession("HOUSE_CODE"), rfq_no, rfq_count, 
					//				  info.getSession("HOUSE_CODE"), rfq_no, rfq_count}};
					
					//String[] type =	{ "S", "S", "N", "S", "S","N" }; 
					
					Map<String, String> setData = new HashMap<String, String>();
					setData.put("RFQ_NO", rfq_no);
					setData.put("RFQ_COUNT", rfq_count);

					rtn	= sm.doUpdate(setData); 
				
				}catch(Exception e)	{ 
					Logger.err.println(info.getSession("ID"),this,"ERROR==========>"+e.getMessage()); 
					throw new Exception(e.getMessage()); 
				} 
				return rtn; 
				} 
				
	/**
	 * 구매요청정보, 구매요청상세정보 플래그 수정(ICOYPRHD, ICOYPRDT)
	 * @method et_setPRComfirm
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2014-10-13
	 * @modify 2014-10-13
	 */
	private int et_setPRComfirm(ConnectionContext ctx, List<Map<String, String>> prData)throws	Exception 
	{ 
 
		int	   rtn	        = 0;  
		String signdate     = SepoaDate.getShortDateString();
			 
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

		try	{ 
			
			SepoaSQLManager sm =	null;  
			for(int i=0;i<prData.size();i++){
				sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());  
				rtn	= sm.doUpdate(prData.get(i)); 
			}
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			sxp.addVar("id", info.getSession("ID"));
//			sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			sxp.addVar("signdate", signdate);
			
            for(int i=0;i<prData.size();i++){
            	sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				rtn	= sm.doUpdate(prData.get(i)); 
			}
            
            
		} catch(Exception e) { 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	}
	
	
	 
	/**
	 * 견적서 상세정보 수정
	 * @method et_setItemDetail_QTDT
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYQTDT
	 * @since  2014-10-13
	 * @modify 2014-10-13
	 */
	private int et_setItemDetail_QTDT(ConnectionContext ctx, List<Map<String, String>> qtdtData)throws	Exception 
			{ 
			int	rtn	= 0; 
			
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			
			try{ 
			
			//String[] type =	{ "N", "N", "S", "S", "S", "S" 						,"S", "S", "N", "S", "S" }; 
			SepoaSQLManager sm =	null; 
			for(int i=0;i<qtdtData.size();i++){
				sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				rtn	= sm.doInsert(qtdtData.get(i));                                                      
			}			
			
			}catch(Exception e)	{ 
			//Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
			throw new Exception(e.getMessage()); 
			} 
			return rtn; 
	}
	
	/**
	 * 
	 * @method et_setRfqOPCreate
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @desc   견적의뢰 단가 구매지역 정보 입력 (ICOYRQOP)
	 * @since  2014-10-13
	 * @modify 2014-10-13
	 */
	private int et_setRfqOPCreate(ConnectionContext ctx,
			List<Map<String, String>> rqopData)  throws Exception                          
			{                                                                                              
        
			int	rtn	= 0;                                                                               
			//String house_code = info.getSession("HOUSE_CODE");     
			
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			//sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			SepoaSQLManager sm =	null;                                                                              
		                                                                               
			try	{                                                                                      
			//String[] type =	{"S","S","N","S","S","S","S","S","S","S" ,"S","S","S","S"};                                                         
				
				for(int i=0;i<rqopData.size();i++){
					sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
					rtn	= sm.doInsert(rqopData.get(i));                                                      
				}
			} catch(Exception e) {                                                                     
				Logger.err.println(info.getSession("ID"),this,e.getMessage());                         
			throw new Exception(e.getMessage());                                                   
			}                                                                                          
			return rtn;    
	}
	
	/**
	 * 견적의뢰 단가 구매지역 정보 자료 삭제 ICOYRQOP
	 * @method et_delRQOP
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private int et_delRQOP(ConnectionContext ctx, List<Map<String, String>> delRqopData) throws	Exception 
			{ 
			int	rtn	= 0; 
			
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	null; 
			
			try{ 
			
			//String[] type =	{ "S","S","N", "S", "S" }; 
			for(int i=0;i<delRqopData.size();i++){
				sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
				rtn	= sm.doDelete(delRqopData.get(i));
			}
			}catch(Exception e)	{ 
//				e.printStackTrace();
				Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
			throw new Exception(e.getMessage()); 
			} 
			return rtn; 
	}
	
	/**
	 * 견적의뢰 상세정보 플래스 수정
	 * @method et_setItemDetail_RQDT
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private int et_setItemDetail_RQDT(ConnectionContext ctx, List<Map<String, String>> rqdtData, List<Map<String, String>> rqdtResData) throws Exception {
		int	rtn	= 0; 
		Map<String, String> rqdtDataInfo = null;
		
		try{ 

			
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
		SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
		//rtn	= sm.doUpdate(rqdtData); 
		
		for(int i=0;i<rqdtData.size();i++){
			rqdtDataInfo = rqdtData.get(i);
			sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			rtn	= sm.doUpdate(rqdtDataInfo);
		}

		sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

		//String[] type_res =	{ "S", "S", "N", "S"}; 
			for(int i=0;i<rqdtResData.size();i++){
				sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
				rtn	= sm.doUpdate(rqdtResData.get(i)); 			
			}
		}catch(Exception e)	{ 
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"),this,stackTrace(e)); 
		throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	}
	/**
	 * 견적비교 업체조회
	 * @method getDocBaseQtaCompareHD
	 * @param header
	 * @return Map
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
		public SepoaOut getDocBaseQtaCompareHD (Map<String, String> header) 
		{ 
			try{ 
				String rtn = ""; 
				rtn	= et_getDocBaseQtaCompareHD(header); 
	 
				setValue(rtn); 
				setStatus(1); 
				SepoaFormater wf = new SepoaFormater(rtn);
				if(wf.getRowCount() == 0) setMessage(msg.getMessage("0006"));
				else {
					setMessage(msg.getMessage("0003"));
				} 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage(msg.getMessage("0005")); 
			} 
	 
			return getSepoaOut(); 
		} 
	  
		/**
		 * 견적비교 업체조회 METHOD
		 * @method et_getDocBaseQtaCompareHD
		 * @param header
		 * @return Map
		 * @throws Exception
		 * @since  2014-10-07
		 * @modify 2014-10-07
		 */
		private	String et_getDocBaseQtaCompareHD(Map<String, String>  header) throws	Exception 
		{ 
			String rtn = null; 
			ConnectionContext ctx =	getConnectionContext(); 
			
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			try{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				//String[] setData = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count};
				
				rtn	= sm.doSelect(header); 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 

		/**
		 * 견적조회 업체 비교 품목 조회
		 * @method getDocBaseQtaComparDT
		 * @param header
		 * @return Map
		 * @throws Exception
		 * @since  2014-10-07
		 * @modify 2014-10-07
		 */
		public SepoaOut getDocBaseQtaCompareDT(Map<String, String> header) 
		{ 
			try{ 
				String rtn = ""; 
				rtn	= et_getDocBaseQtaCompareDT(header); 
	 
				setValue(rtn); 
				setStatus(1); 
				SepoaFormater wf = new SepoaFormater(rtn);
				if(wf.getRowCount() == 0) setMessage(msg.getMessage("0006"));
				else {
					setMessage(msg.getMessage("0003"));
				} 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage(msg.getMessage("0005")); 
			} 
	 
			return getSepoaOut(); 
		} 
	
		/**
		 * 견적조회 업체 비교 품목 조회
		 * @method et_getDocBaseQtaCompareDT
		 * @param header
		 * @return Map
		 * @throws Exception
		 * @since  2014-10-07
		 * @modify 2014-10-07
		 */
		private	String et_getDocBaseQtaCompareDT(Map<String, String>  header) throws	Exception 
		{ 
			String rtn = null; 
			ConnectionContext ctx =	getConnectionContext(); 
			
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			try{ 
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
				//String[] setData = {info.getSession("HOUSE_CODE"), rfq_no, rfq_count};
				
				rtn	= sm.doSelect(header); 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
		
		public SepoaOut setReturnToPR_DOC_ALL(String[][]	rqdtData
				, String[][] rqhdData
				, String[][] prdt_data) 
			{ 
			try 
			{ 
			int	rtn	= et_setReturnToPR_DOC_ALL(rqdtData, rqhdData, prdt_data); 
			setStatus(1); 
			setValue(String.valueOf(rtn)); 
			setMessage(msg.getMessage("0014")); 
			Commit(); 
			
			}catch(Exception e)	{ 
			try{Rollback();}catch(Exception	d){Logger.err.println(info.getSession("ID"),this,d.getMessage());} 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0012")); 
			} 
			return getSepoaOut(); 
			} 
			
			private	int	et_setReturnToPR_DOC_ALL(String[][]	rqdtData
							, String[][] rqhdData
							, String[][] prdt_data) throws Exception 
			{ 
			
			int	rtn	= 0; 
			
			ConnectionContext ctx =	getConnectionContext(); 
			
			
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

			
			try{ 
			SepoaSQLManager smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			String[] type_rqdt = {"S", "S", "N"};
			rtn	= smdt.doUpdate(rqdtData, type_rqdt); 
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			SepoaSQLManager smhd	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			String[] type_rqhd = {"S", "S", "S", "S", "N"};
			rtn	= smhd.doUpdate(rqhdData, type_rqhd); 
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
			SepoaSQLManager smpr	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			String[] type_prdt =	{"S","S","S"}; 
			rtn	= smpr.doUpdate(prdt_data, type_prdt); 
			
			}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
			} 
			return rtn; 
			} 
			
			

				
				public SepoaOut setReturnToSettle(String[][]	rqdtData, String[][] qtdtData ) 
				{ 
					//String lang	  =	info.getSession("LANGUAGE"); 
					//Message msg = new Message("STDQTA");
					try 
					{ 
						int	rtn	= et_setReturnToSettle(rqdtData,qtdtData); 
						setStatus(1); 
						setValue(String.valueOf(rtn)); 
						setMessage(msg.getMessage("0013")); 
						Commit(); 
			 
					}catch(Exception e)	{ 
						try{Rollback();}catch(Exception	d){Logger.err.println(info.getSession("ID"),this,d.getMessage());} 
						Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
						setStatus(0); 
						setMessage(msg.getMessage("0012")); 
					} 
					return getSepoaOut(); 
				} 
			 
				private	int	et_setReturnToSettle(String[][]	rqdtData, String[][] qtdtData) throws Exception 
				{ 
			 
					int	rtn	= 0; 
			 
					ConnectionContext ctx =	getConnectionContext(); 
			 
					SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	  
					try{ 
						SepoaSQLManager smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
						String[] type_rqdt = {"S", "S", "N"};
						rtn	= smdt.doUpdate(rqdtData, type_rqdt); 
						sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
						smdt	= new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
						String[] type_qtdt = {"S", "S" };
						rtn	= smdt.doUpdate(qtdtData, type_qtdt); 
			  
					}catch(Exception e)	{ 
						Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
						throw new Exception(e.getMessage()); 
					} 
					return rtn; 
				}

	// ------------------------------------------------------------------------------
	public SepoaOut getQtaCompareItem(Map<String, String>  header) throws Exception{ 
		try	{ 
			String rtn = ""; 
			 
			rtn	= et_getQtaCompareItem(header); 
 
			SepoaFormater wf = new SepoaFormater(rtn);
			if(wf.getRowCount() == 0) 
					setMessage(msg.getMessage("0006"));
			else {
				setMessage(msg.getMessage("0003"));
			}
 
			setValue(rtn); 
			setStatus(1); 
		}catch (Exception e){ 
//			e.printStackTrace();
			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage()); 
 
			setMessage(msg.getMessage("0005"));
			setStatus(0); 
		} 
		return getSepoaOut(); 
	} 

	private	String et_getQtaCompareItem(Map<String, String>  header) throws Exception 
	{ 
		String rtn = ""; 
		ConnectionContext ctx =	getConnectionContext(); 

		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try	{ 

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
 
			//String[] args =	{info.getSession("HOUSE_CODE"), rfq_no, rfq_count}; 
			rtn	= sm.doSelect(header); 
 
			if(rtn == null)	throw new Exception("SQL Manager is	Null"); 
		}catch(Exception e)	{ 
			throw new Exception("et_getQtaCompareItem=========>"+e.getMessage()); 
		} finally{ 
		} 
		return rtn; 
	}
	
	/*public SepoaOut setItemDetailSave( String[][] rqdtData
			, String[][] rqdtData_res
			, String[][] delrqopdata
			, String[][] rqopdata
			, String[][] qtdtData
			, String[][] prData
			, String     rfq_no
			, String     rfq_count
			)
	{
		try { 
			int	rtn	= 0; 
			ConnectionContext ctx =	getConnectionContext(); 

			et_setItemDetail_RQDT(ctx, rqdtData, rqdtData_res);
			et_delRQOP(ctx, delrqopdata);
			
			if ((rqopdata != null) && (rqopdata.length > 0)) {
				et_setRfqOPCreate(ctx, rqopdata);
			}

			et_setItemDetail_QTDT(ctx, qtdtData);
			et_setItemRQHD_FlagUPDATE(ctx, rfq_no, rfq_count);

			et_setPRComfirm(ctx, prData); 
			setStatus(1); 
			setValue(String.valueOf(rtn)); 
			setMessage(msg.getMessage("0009")); 

			Commit();
			//Rollback();
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,"e.getMessage========>"+e.getMessage());
			try { 
				Rollback(); 
			} catch (Exception d) { 
				Logger.err.println(info.getSession("ID"),this,"d.getMessage========>"+d.getMessage()); 
			} 

			setStatus(0); 
			setMessage(msg.getMessage("0010")); 
		} 

		return getSepoaOut(); 
	}		*/							
				
	public SepoaOut setReturnToPR_ItemBase(String[][] prdtData, String[][] rqdtData, String[][] rqhdData, String[][] rqhdData_2) 
	{ 
		int	rtn	= 0; 
		try	{ 
 
			rtn	= et_setReturnToPR_ItemBase(prdtData, rqdtData, rqhdData, rqhdData_2); 
 
			setMessage(msg.getMessage("0011"));	// 청구복구	되었습니다. 
			setValue(Integer.toString(rtn)); 
			setStatus(1); 
 
			Commit();
			//Rollback();

		}catch(Exception e){ 
			try{Rollback();}catch(Exception	e1){ Logger.err.println("Exception e	=" + e1.getMessage()); } 
			Logger.err.println("Exception e	=" + e.getMessage()); 
 
			setMessage(msg.getMessage("0012"));	// 청구복구에 실패했습니다. 
			setStatus(0); 
			Logger.err.println(this,e.getMessage()); 
		} 
		return getSepoaOut(); 
	} 

	private	int	et_setReturnToPR_ItemBase(String[][] prdtData, String[][] rqdtData, String[][] rqhdData, String[][] rqhdData_2) throws Exception 
	{ 
 
		int	rtn	= -1; 

		ConnectionContext ctx =	getConnectionContext(); 
 
		try	{ 
	
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			String[] type =	{"S", "S", "S"}; 
			rtn	= sm.doUpdate(prdtData,type); 
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			String[] type_rq = {"S","S","S","S"};
			rtn	= sm.doUpdate(rqdtData,type_rq); 
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			String[] type_hd = {"S", "S", "S", "S", "N", "S", "S", "N"};
			rtn	= sm.doUpdate(rqhdData, type_hd);
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
			String[] type_hd_2 = {"S", "S", "S", "S", "S"};
			rtn	= sm.doUpdate(rqhdData_2, type_hd_2); 
 
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 

	

	/*
	 * 평가 템플릿 코드 가져오기
	 * 2010.07.
	 */
	public String getEvalTemplate(Integer eval_id){
		String rtn = null;
		try{
			rtn = et_getEvalTemplate(eval_id); 
					
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0005")); 
		} 
		return rtn; 
	}
	

	private	String et_getEvalTemplate(Integer eval_id) throws Exception 
	{ 
	
		
		String rtn = null; 
		ConnectionContext ctx =	getConnectionContext(); 
		
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{ 
			sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			sxp.addVar("code", eval_id.toString());
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			rtn	= sm.doSelect((String[])null); 
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	

	/*
	 * 평가 대상업체 가져오기
	 * 2010.07.
	 */
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
		
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{ 
			sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			sxp.addVar("doc_no", doc_no);
			sxp.addVar("doc_count", doc_count);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			rtn	= sm.doSelect((String[])null); 
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	

	/*
	 * 평가 대상업체, 개발자 가져오기
	 * 2010.07.
	 */
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
		
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{ 
			sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			sxp.addVar("doc_no", doc_no);
			sxp.addVar("doc_count", doc_count);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			rtn	= sm.doSelect((String[])null); 
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	
	/*
	 * 평가 담당자  가져오기
	 * 2010.07.
	 */
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
		
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		try{ 
			sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			sxp.addVar("doc_no", doc_no);
			sxp.addVar("doc_count", doc_count);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			rtn	= sm.doSelect((String[])null); 
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 

	/*
	 * 평가 여부  및 평가 생성
	 * 2010.07.
	 */
	public SepoaOut setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, Integer eval_id){
		try{

			int rtn = et_setEvalInert(doc_no, doc_count, eval_name, eval_flag, eval_id); 
			
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
		return getSepoaOut(); 
	}
	
  		
	private	int et_setEvalInert(String doc_no, String doc_count, String eval_name, String eval_flag, Integer eval_id) throws Exception 
	{ 
		int rtn =  0;
		ConnectionContext ctx =	getConnectionContext(); 
		SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_no]::"+doc_no);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [doc_count]::"+doc_count);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_name]::"+eval_name);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_flag]::"+eval_flag);
		Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 [eval_id]::"+eval_id);
		
		try{ 
			Integer eval_refitem = 0;
			if(!"N".equals(eval_flag)){	//평가제외가 아닐 경우 평가 생성.
				Logger.debug.println(info.getSession("ID"),this, "=========================평가 생성 START");
				String rtn1 =  et_setEvalInsert(doc_no, doc_count, eval_name, eval_id);
				
		         if("".equals(rtn1)){
		             Rollback();
		             setStatus(0);
		             setMessage(msg.getMessage("9003"));
		             return 0;
		         }
		         
		         eval_refitem = Integer.valueOf(rtn1);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================평가 상태 등록");
			
			sxp.addVar("eval_flag", eval_flag);
			sxp.addVar("eval_refitem", eval_refitem);
			sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			sxp.addVar("doc_no", doc_no);
			sxp.addVar("doc_count", doc_count);
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
			rtn	= sm.doUpdate((String[][])null, (String[])null); 
		}catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
			throw new Exception(e.getMessage()); 
		} 
		return rtn; 
	} 
	

	private String et_setEvalInsert(String doc_no, String doc_count, String eval_name, Integer eval_id) throws Exception 
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
			String evaltemp_num	= "";
			String from_date  	= "";
			String to_date  	= "";
			String flag			= "2"; 	//eval_status[2]
			 
			//템플릿코드 조회
			String rtn1 = getEvalTemplate(eval_id);
			wf =  new SepoaFormater(rtn1);
			if(wf != null && wf.getRowCount() > 0) {
				evaltemp_num 	= wf.getValue("text3", 0);
				from_date 		= wf.getValue("FROMDATE", 0);
				to_date 		= wf.getValue("TODATE", 0);
			}
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 템플릿코드::"+evaltemp_num);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_no]::"+doc_no);
			Logger.debug.println(info.getSession("ID"),this, "[et_setEvalInsert]=======[doc_count]::"+doc_count);
			
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
			if(eval.equals(eval_id.toString())){
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
    		SepoaXmlParser sxp =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_0");
			sxp.addVar("house_code", house_code);
			sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,sxp.getQuery());
  	    	String rtn = sm.doSelect((String[])null);
  	    	wf =  new SepoaFormater(rtn);
	    	
  	    	String max_eval_refitem = "";
	    	if(wf != null && wf.getRowCount() > 0) {
	    		max_eval_refitem = wf.getValue("MAX_EVAL_REFITEM", 0);
			}

			//평가테이블 생성 - ADD( 견적[RQ]/입찰[BD]/역경매[RA] 구분, 문서번호, 문서SEQ 등록)
	    	SepoaXmlParser sxp_1 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_1");
	    	sxp_1.addVar("house_code", house_code);
	    	sxp_1.addVar("max_eval_refitem", max_eval_refitem);
	    	sxp_1.addVar("evalname", eval_name);
	    	sxp_1.addVar("flag", flag);
	    	sxp_1.addVar("evaltemp_num", evaltemp_num);
	    	sxp_1.addVar("fromdate", from_date);
	    	sxp_1.addVar("todate", to_date);
	    	sxp_1.addVar("auto", auto);
	    	sxp_1.addVar("user_id", user_id);
	    	sxp_1.addVar("DOC_TYPE", "RQ");	//견적
	    	sxp_1.addVar("DOC_NO", doc_no);
	    	sxp_1.addVar("DOC_COUNT", doc_count);
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp_1.getQuery() );
			rtnIns = sm.doInsert((String[][])null, (String[])null );
			Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가마스터 정보 저장 끝");
			
			String i_sg_refitem = "";
			String i_vendor_code = "";
			String i_value_id = "";
			String i_value_dept = "";
			String i_human_no = "";

			//평가대상업체 테이블 생성
			SepoaXmlParser sxp_2 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_2_1");
			
			//평가대상업체 평가자 테이블 생성
			SepoaXmlParser sxp_3 =  new SepoaXmlParser("master/evaluation/p0080", "et_setEvabdins1_3");
			
			for ( int i = 0; i < setData.length; i++ )
			{
				i_sg_refitem 	= setData[i][2];
				i_vendor_code 	= setData[i][0];
				i_value_id 		= setData[i][3];
				i_value_dept 	= setData[i][4];
				i_human_no 		= setData[i][5];

				//평가대상업체 테이블 생성
				sxp_2.addVar("house_code", house_code);
				sxp_2.addVar("i_sg_refitem", i_sg_refitem);
				sxp_2.addVar("i_vendor_code", i_vendor_code);
				sxp_2.addVar("max_eval_refitem", max_eval_refitem);
				sxp_2.addVar("i_human_no", i_human_no);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp_2.getQuery() );
				rtnIns = sm.doInsert((String[][])null, (String[])null );
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가대상업체 정보 저장 끝");
				
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 ::"+i_value_id);
				Logger.debug.println(info.getSession("ID"),this, "=========================[평가] 평가자 부서 ::"+i_value_dept);
							
				String i_dept = "";
				String i_id = "";

				//평가대상업체 평가자 테이블 생성
				sxp_3.addVar("house_code", house_code);
				sxp_3.addVar("i_dept", i_value_dept);
				sxp_3.addVar("i_id", i_value_id);
				sxp_3.addVar("getCurrVal", getCurrVal("icomvevd", "eval_item_refitem"));

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp_3.getQuery() );
				rtnIns = sm.doInsert((String[][])null, (String[])null );
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
      	
  			SepoaXmlParser sxp =  new SepoaXmlParser("master/evaluation/p0080","currvalForMssql");
			sxp.addVar("columnName", columnName);
			sxp.addVar("tableName", tableName);
			sxp.addVar("house_code", house_code);
  			
  			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sxp.getQuery());
  			rtn = sm.doSelect((String[])null);
      	
              setValue(rtn);
              setStatus(1);

          } catch(Exception e) {

              Logger.err.println("Exception e =" + e.getMessage());
              setStatus(0);
              Logger.err.println(this,e.getMessage());
          }
          return getSepoaOut();
      }    
	  
	 
	 /*
		 * 인터뷰 선정 요청
		 * 2010.07.
		 */
		public SepoaOut setEvalInterview(String doc_no, String doc_count, String eval_name, String eval_flag){
			try{

				int rtn = et_setEvalInterview(doc_no, doc_count, eval_name, eval_flag); 
				
				setValue(String.valueOf(rtn));  
				if(rtn==0){
					Rollback();
					setStatus(0); 
					setMessage("인터뷰 선정 요청 처리중 오류가 발생하였습니다.");
				}else{
					Commit();
					setStatus(1); 
					setMessage("인터뷰 선정 요청이 정상적으로 처리되었습니다."); 
				}
			 	
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				setStatus(0); 
				setMessage("인터뷰 선정 요청 처리중 오류가 발생하였습니다."); 
			} 
			return getSepoaOut(); 
		}
		
	  		
		private	int et_setEvalInterview(String doc_no, String doc_count, String eval_name, String eval_flag) throws Exception 
		{ 
			int rtn =  0;
			ConnectionContext ctx =	getConnectionContext(); 
			SepoaXmlParser sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
			Logger.debug.println(info.getSession("ID"),this, "=========================인터뷰 선정 요청   [doc_no]::"+doc_no);
			Logger.debug.println(info.getSession("ID"),this, "=========================인터뷰 선정 요청   [doc_count]::"+doc_count);
			Logger.debug.println(info.getSession("ID"),this, "=========================인터뷰 선정 요청   [eval_flag]::"+eval_flag);
			
			try{ 
				
				sxp.addVar("eval_flag", eval_flag);
				sxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				sxp.addVar("doc_no", doc_no);
				sxp.addVar("doc_count", doc_count);
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery()); 
				rtn	= sm.doUpdate((String[][])null, (String[])null); 
			}catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
				throw new Exception(e.getMessage()); 
			} 
			return rtn; 
		} 
	 
/**********************************************************************************************************************************/ 
//////////////////////////////////////////////////////Common methods End//////////////////////////////////////////////////////////////// 
/**********************************************************************************************************************************/ 
 
} 
