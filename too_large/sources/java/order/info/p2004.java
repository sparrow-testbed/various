/**
* Copyright 2001-2001 ICOMPIA Co., Ltd. All Rights Reserved.
* This software is the proprietary information of ICOMPIA Co., Ltd.
* @version        1.0
*/
package order.info;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class p2004 extends SepoaService
{
    Message msg;   
    String USER_ID        = "";
    String HOUSE_CODE     = "";
    String COMPANY_CODE   = "";
    
    public p2004(String opt,SepoaInfo info) throws SepoaServiceException {
        super(opt,info); 
        setVersion("1.0.0"); 
        
         USER_ID        = info.getSession("ID");
         HOUSE_CODE     = info.getSession("HOUSE_CODE");
         COMPANY_CODE   = info.getSession("COMPANY_CODE");
         msg            = new Message(info, "STDINFO"); 
    }

    /**
	 * 연간단가현황 조회
	 * @method getInfoList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-10-20
	 * @modify 2014-10-20
	 */
     public SepoaOut getInfoList2(Map<String, String> header) {  
    	 try	{  
 			String rtn = "";  
   
 			//Query 수행부분 Call  
             //create_type 에 상관없이 조회 
 			rtn	= et_getInfoList2(header);  
 				
 			setValue(rtn);  
 			setStatus(1);  
   
 		}catch (Exception e){  
 			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage());  
 			setMessage(msg.getMessage("0002"));
            setStatus(0);
 		}  
 		return getSepoaOut();  
     }
     
     /**
 	 * 연간단가현황 조회 쿼리
 	 * @method et_getInfoList
 	 * @param  header
 	 * @return Map
 	 * @throws Exception
 	 * @desc   ICOYRQDT
 	 * @since  2014-10-20
 	 * @modify 2014-10-20
 	 */
	 private String et_getInfoList2(Map<String, String> header) throws Exception  
	    {  
	    	
			
			String rtn = "";  
			ConnectionContext ctx =	getConnectionContext();  
			//String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
			
			try	{  
				
				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
				//header.put("cur_date_time", cur_date_time);
				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
				
				rtn	= sm.doSelect(header);  
	  
				if(rtn == null)	throw new Exception("SQL Manager is	Null");  
			}catch(Exception e)	{  
				
			  throw	new	Exception("et_getItemList=========>"+e.getMessage());  
			} finally{  
			}  
			return rtn; 
	 }
	 
	 /**
	 	 * 연간단가현황 단가 변경
	 	 * @method setUpdateInfo
	 	 * @param  header
	 	 * @return Map
	 	 * @throws Exception
	 	 * @desc   ICOYRQDT
	 	 * @since  2014-10-20
	 	 * @modify 2014-10-20
	 	 */
	 @SuppressWarnings("unchecked")
		public SepoaOut setUpdateInfo(Map<String, Object> data) throws Exception{ 
	    	ConnectionContext         ctx          = null;
	        SepoaXmlParser            sxp          = null;
			SepoaSQLManager           ssm          = null;
			String                    id           = info.getSession("ID");
			List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String>       gridInfo     = null;
			int                       gridSize     = grid.size();
			int                       rtn          = 0;
	        
	    	setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			try{
		            
		       rtn = this.et_setUpdateInfo(ctx, grid);
		       setStatus( 1 );
				if ( rtn > 0 ){
					setMessage("비정상적으로 처리되었습니다.");
					setStatus( 0 );
				}
				setMessage("성공적으로 변경하였습니다.");
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
	 	 * 연간단가현황 단가 변경 쿼리
	 	 * @method et_setUpdateInfo
	 	 * @param  header
	 	 * @return Map
	 	 * @throws Exception
	 	 * @desc   ICOYRQDT
	 	 * @since  2014-10-20
	 	 * @modify 2014-10-20
	 	 */
	 private	int et_setUpdateInfo(ConnectionContext	ctx, List<Map<String, String>> grid) throws Exception { 
			int rtn = 0;
			Map<String, String>       gridInfo     = null;
			String valid_to_date                   = "";
			try{
				SepoaXmlParser  sxp = new SepoaXmlParser(this, "et_setUpdateInfo");
				SepoaSQLManager ssm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
				//rtn = sm.doUpdate(grid); or
				for(int i = 0; i < grid.size(); i++){
		            gridInfo = grid.get(i);
		            valid_to_date = SepoaString.getDateUnSlashFormat(gridInfo.get("VALID_TO_DATE"));
		            gridInfo.put("VALID_TO_DATE", valid_to_date);
		            ssm.doUpdate(gridInfo);
				}
				
			}
			catch(Exception e)	{ 
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
				
				throw new Exception(e.getMessage()); 
			} 

			return rtn;
		} 
	    /**
	 	 * 연간단가현황 단가 삭제
	 	 * @method setUpdateInfo
	 	 * @param  header
	 	 * @return Map
	 	 * @throws Exception
	 	 * @desc   ICOYRQDT
	 	 * @since  2014-10-20
	 	 * @modify 2014-10-20
	 	 */
	 @SuppressWarnings("unchecked")
		public SepoaOut setDeleteInfo(Map<String, Object> data) throws Exception{ 
	    	ConnectionContext         ctx          = null;
	        SepoaXmlParser            sxp          = null;
			SepoaSQLManager           ssm          = null;
			String                    id           = info.getSession("ID");
			List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String>       gridInfo     = null;
			int                       gridSize     = grid.size();
			int                       i            = 0;
	        
	    	setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			try {
				for(i = 0; i < gridSize; i++){
					sxp = new SepoaXmlParser(this, "et_setDeleteInfo");
		            ssm = new SepoaSQLManager(id, this, ctx, sxp);
		            
		            gridInfo = grid.get(i);
		            
		            ssm.doUpdate(gridInfo);
				}
				
				setMessage("성공적으로 삭제되었습니다.");
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
	 
	 @SuppressWarnings("unused")
	 public SepoaOut getInfoData(Map<String, Object> allData) throws Exception{  
		 String rtn = "";  
		 ConnectionContext 		ctx 	= getConnectionContext();
		 Map<String, String> 	header 	= MapUtils.getMap( allData, "headerData" );
//		 System.out.println(header);
		 try{  
			 SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			 SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
			 rtn	= sm.doSelect(header);  
			 setValue(rtn);  
			 setStatus(1);  
		 }catch(Exception e)	{  
			 throw	new	Exception("et_getItemList=========>"+e.getMessage());  
		 }  
		 return getSepoaOut(); 
	 }	 
	 
	 
	 @SuppressWarnings("unchecked")
	 public SepoaOut setInsertInfo(Map<String, Object> data) throws Exception{ 
		 ConnectionContext         ctx          = null;
		 SepoaXmlParser            sxp          = null;
		 SepoaSQLManager           ssm          = null;
		 String                    id           = info.getSession("ID");
		 Map<String, String> 	   header       = MapUtils.getMap( data, "headerData" );
		 int                       rtn          = 0;
	        
		 setStatus(1);
		 setFlag(true);
			
		 ctx = getConnectionContext();
		 try{
		            
			 if("N".equals(header.get("updYn"))){
				 rtn = this.et_setInsertInfo(ctx, header);
			 }else{
				 List<Map<String, String>> grid = new ArrayList<Map<String,String>>();
				 
				 header.put("UNIT_PRICE"	, 	header.get("cont_price").replaceAll("\\,", ""));
				 header.put("VALID_TO_DATE"	,	header.get("cont_to_date").replaceAll("\\/", ""));
				 header.put("REMARK"		,	header.get("reason"));
				 header.put("VENDOR_CODE"	,	header.get("vendor_code"));
				 header.put("ITEM_NO"		,	header.get("item_no"));
				 
				 grid.add(0, header);
				 rtn = this.et_setUpdateInfo(ctx, grid) ;
			 }
			 
			 setStatus( 1 );
			 if ( rtn > 0 ){
				 setMessage("비정상적으로 처리되었습니다.");
				 setStatus( 0 );
			 }
			 setMessage("성공적으로 처리하였습니다.");
			 Commit();
		 }catch(Exception e){
			 Rollback();
			 setStatus(0);
			 setFlag(false);
			 setMessage(e.getMessage());
			 Logger.err.println(info.getSession("ID"), this, e.getMessage());
		 }
		 finally {}
		 return getSepoaOut();
	 } 
	 
	 private int et_setInsertInfo(ConnectionContext	ctx, Map<String, String> header) throws Exception { 
		 int rtn = 0;
		 try{
			 SepoaXmlParser  sxp = new SepoaXmlParser(this, "et_setInsertInfo");
			 SepoaSQLManager ssm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			 header.put("cont_price"	, header.get("cont_price").replaceAll("\\,", ""));
			 header.put("cont_from_date", header.get("cont_from_date").replaceAll("\\/", ""));
			 header.put("cont_to_date"	, header.get("cont_to_date").replaceAll("\\/", ""));
			 
			 ssm.doUpdate(header);
		 }
		 catch(Exception e)	{ 
			 Logger.err.println(info.getSession("ID"),this,e.getMessage());
			 throw new Exception(e.getMessage()); 
		 } 
		 return rtn;
	 } 	 
	 
	/*    *//**
	     * 작성자 : JUN.S.K
	     * 작성일 : 2003.09.18
	     * 경로   : /order/info/info2_bd_lis1.jsp
	     * 내용   : 구매정보레코드현황 조회
	     *//* 
	     public SepoaOut getInfoList2 (String FROM_DATE
	 					            , String TO_DATE
	 					            , String ITEM_NO
	 					            , String VENDOR_CODE
	 					            , String VENDOR_NAME
	 					            , String DESCRIPTION_LOC
	 					            , String CONT_SEQ
	 					            , String INFO_STAND_DATE)
	     {
	         try {
	             String rtn = et_getInfoList2(
	            		 FROM_DATE,TO_DATE, 
	            		 ITEM_NO, 
	            		 VENDOR_CODE, 
	            		 VENDOR_NAME, 
	            		 DESCRIPTION_LOC, 
	            		 CONT_SEQ, 
	            		 INFO_STAND_DATE);
	             
	             setStatus(1);
	             setValue(rtn);
	             
	 			SepoaFormater wf = new SepoaFormater(rtn);
	 			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0003"));
	 			else {
	 				setMessage(msg.getMessage("0004"));
	 			}
	         
	         }catch(Exception e) {
	             Logger.err.println(USER_ID,this,e.getMessage());
	             setMessage(msg.getMessage("0002"));
	             setStatus(0);
	         }
	         
	         return getSepoaOut();
	         
	     }
	     
	     
		 private String et_getInfoList2(String FROM_DATE
		         , String TO_DATE
		         , String ITEM_NO
		         , String VENDOR_CODE
		         , String VENDOR_NAME
		         , String DESCRIPTION_LOC
		         , String CONT_SEQ
		         , String INFO_STAND_DATE ) throws Exception 
		{

			String rtn = new String();
			ConnectionContext ctx = getConnectionContext();
			
			try {
			
	            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	            wxp.addVar("company_code", info.getSession("COMPANY_CODE"));
	            
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
				
				String args[] = {
						info.getSession("HOUSE_CODE"),
						ITEM_NO,
						VENDOR_CODE,
						VENDOR_NAME,
						DESCRIPTION_LOC,
						FROM_DATE,
						TO_DATE,
						CONT_SEQ,
						INFO_STAND_DATE,
						INFO_STAND_DATE
						};
				
				rtn = sm.doSelect(args);
				
				if(rtn == null) throw new Exception("SQL Manager is Null");
				
			}catch(Exception e) { 
					throw new Exception("et_getInfoList2:"+e.getMessage());
			} finally {
				
			} 
				
			return rtn;
		}
	 
	public SepoaOut setUpdateInfo(String[][] args ){
		String rtn = null;
		try{
			rtn = et_setUpdateInfo( args );
			setStatus( 1 );
			setMessage("성공적으로 변경하였습니다.");
			if ( rtn.length() > 0 ){
				setMessage("비정상적으로 처리되었습니다.");
				setStatus( 0 );
			}
		}catch ( Exception e ){
			setStatus( 0 );
			setMessage( e.getMessage() );
			Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
		}

		return getSepoaOut();
	}

	private String et_setUpdateInfo( String [][] args ) throws Exception{

		String returnString = new String();
		ConnectionContext ctx = getConnectionContext();

		String rtnSql = "";
		int rtnIns = 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());		
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		wxp.addVar("company_code", info.getSession("COMPANY_CODE"));
		wxp.addVar("user_id", info.getSession("ID"));

		try{
			String [] type = {"S", "S", "S", "S", "S", "S", "S"};
			SepoaSQLManager sm = new SepoaSQLManager( info.getSession( "ID" ), this, ctx, wxp.getQuery() );
			rtnIns = sm.doUpdate(args, type);
			Commit();
		}catch( Exception e ){
			returnString = e.getMessage();
			Rollback();
		} finally{}

		return returnString;
	}


	
	* 연간단가를 삭제합니다.
	

	public SepoaOut setDeleteInfo(String[][] args ){

		int rtn = 0;
		try{
			rtn = et_setDeleteInfo( args );
			//Logger.err.println( "여기입니다1.......", this, Integer.toString(rtn) );
			if (rtn > 0) {
				setStatus( 1 );
				setMessage("성공적으로 삭제되었습니다.");
			} else {
				setStatus( 0 );
				setMessage("비정상적으로 처리되었습니다.\n\n기존에 등록된 계약단가가 있는지 확인하세요.");
			}
		}catch ( Exception e ){
			setStatus( 0 );
			setMessage( e.getMessage() );
			Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
		}

		return getSepoaOut();
	}

	private int et_setDeleteInfo( String [][] args ) throws Exception{

		String returnString = new String();
		ConnectionContext ctx = getConnectionContext();

		String rtnSql = "";
		int rtnIns = 0;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());		
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		wxp.addVar("company_code", info.getSession("COMPANY_CODE"));
		wxp.addVar("user_id", info.getSession("ID"));

		try{
			String [] type = {"S", "S"};
			SepoaSQLManager sm = new SepoaSQLManager( info.getSession( "ID" ), this, ctx, wxp.getQuery() );
			rtnIns = sm.doUpdate(args, type);
			//Logger.err.println( "여기입니다2.......", this, Integer.toString(rtnIns) );
			Commit();
		}catch( Exception e ){
			returnString = e.getMessage();
			//Logger.err.println( "여기입니다3.......", this, returnString );
			Rollback();
		} finally{}

		return rtnIns;
	}


	public SepoaOut setInsertInfo(String[][] args ){

		String rtn = null;
		try{

			rtn = et_setInsertInfo( args );

			setStatus( 1 );

			setMessage("성공적으로 등록하였습니다.");

			if ( rtn.length() > 0 ){
					
				if(rtn.equals("plant_code")){
				setMessage("플랜트 코드가 유효하지 않습니다.");
				setStatus( 0 );
				}else if(rtn.equals("item_no")){
				setMessage("아이템 코드가 유효하지 않습니다.");
				setStatus( 0 );
				}else{
				setMessage("비정상적으로 처리되었습니다.");
				setStatus( 0 );
				}
				

				setMessage("비정상적으로 처리되었습니다.");
				setStatus( 0 );
			}

			Commit();

		}catch ( Exception e ){
			setStatus( 0 );
			setMessage( e.getMessage() );
			Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
		}

		return getSepoaOut();
	}


	*//**
	* 단가정보를 생성한다.
	*
	* <pre>
	* ICOYINFO, ICOYINDR을 생성한다.
	* ICOYINDR.CUM_PO_QTY는 나중에 업데이트함에 유의한다.
	* </pre>
	*
	* @param args
	* @throws Exception
	*//*
	private String et_setInsertInfo(String[][] args) throws Exception {
		int rtn = -1;
		String returnString = new String();
		String user_id = info.getSession("ID");
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser wxp2 = null;

		
		* ICOYINPR은 관리안하므로 주석 SepoaXmlParser wxp3 = new SepoaXmlParser(this, new
		* Exception().getStackTrace()[0].getMethodName()+"_3");
		* wxp3.addVar("m_PO_PRICE_TYPE1", m_PO_PRICE_TYPE1);
		* wxp3.addVar("m_PO_PRICE_TYPE2", m_PO_PRICE_TYPE2);
		

		try {
			연간단가 체크로직
			SepoaXmlParser wxp_valid = null;
			SepoaSQLManager sm_valid = null;
			SepoaFormater wf_plant = null;

			SepoaXmlParser wxp_item_no = null;
			SepoaSQLManager sm_item_no = null;
			SepoaFormater wf_item_no = null;

			
			for (int m = 0; m < args.length; m++) {

			wxp_valid = new SepoaXmlParser(this, "et_getPlantList");
			wxp_valid.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
			wxp_valid.addVar("COMPANY_CODE", info.getSession("COMPANY_CODE"));
			wxp_valid.addVar("PLANT_CODE", args[m][6]);

			sm_valid = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp_valid.getQuery());
			String rtn_plant = sm_valid.doSelect(null);

			wf_plant = new SepoaFormater(rtn_plant);

			if(wf_plant.getRowCount() == 0){
				returnString = "plant_code";
				return returnString;
			}

			wxp_item_no = new SepoaXmlParser(this, "et_getItemList");
			wxp_item_no.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
			wxp_item_no.addVar("COMPANY_CODE", info.getSession("COMPANY_CODE"));
			wxp_item_no.addVar("ITEM_NO", args[m][0]);

			sm_item_no = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp_item_no.getQuery());

			String rtn_item_no = sm_item_no.doSelect(null);

			wf_item_no = new SepoaFormater(rtn_item_no);

			if(wf_item_no.getRowCount() == 0){
				returnString = "item_no";
				return returnString;
			}

		}
	

			SepoaSQLManager sm = null;
			String[] type1 = { "S", "S", "S", "S", "S", "S"};
			for (int m = 0; m < args.length; m++) {
			wxp2 = new SepoaXmlParser(this, "et_getIcoyinfo");
			wxp2.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
			wxp2.addVar("COMPANY_CODE", info.getSession("COMPANY_CODE"));
			wxp2.addVar("ITEM_NO", args[m][0]);
			wxp2.addVar("VENDOR_CODE", args[m][1]);
			wxp2.addVar("VALID_FROM_DATE", args[m][3]);
//			wxp2.addVar("PLANT_CODE", args[m][6]);

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp2.getQuery());
			String rtn2 = sm.doSelect(null);

			SepoaFormater wf = new SepoaFormater(rtn2);

			*//*****************************************************************************************
			* 기존 생성된 데이터의 유효시작일자가 새로 생성하는 데이터의 유효시작일보다 작을경우
			* 기존 데이터의 유효마감일자를 새로 생성하는 데이터의 유효시작일자 보다 하루전으로 UPDATE 후 새로운 연간단가 저장
			*
			* 기존 생성된 데이터의 유효시작일자가 새로 생성하는 데이터의 유효시작일과 같거나 클 경우는 기존데이터에 삭제 후 새로운 연간단가 저장
			*//*

			for (int i = 0; i < wf.getRowCount(); i++) {
				if("Y".equals(wf.getValue("DEL_FLAG", i))){
					wxp2 = new SepoaXmlParser(this, "et_delInfo");
					wxp2.addVar("HOUSE_CODE", wf.getValue("HOUSE_CODE", i));
					wxp2.addVar("COMPANY_CODE", wf.getValue("COMPANY_CODE", i));
					wxp2.addVar("PURCHASE_LOCATION", wf.getValue("PURCHASE_LOCATION", i));
					wxp2.addVar("ITEM_NO", wf.getValue("ITEM_NO", i));
					wxp2.addVar("VENDOR_CODE", wf.getValue("VENDOR_CODE", i));
//					wxp2.addVar("PLANT_CODE", wf.getValue("PLANT_CODE", i));
//					wxp2.addVar("SEQ", wf.getValue("SEQ", i));

					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp2.getQuery());

					rtn = sm.doDelete(null, null);
				}else{
					wxp2 = new SepoaXmlParser(this, "et_preInfoUpdate");
					wxp2.addVar("HOUSE_CODE", wf.getValue("HOUSE_CODE", i));
					wxp2.addVar("COMPANY_CODE", wf.getValue("COMPANY_CODE", i));
					wxp2.addVar("PURCHASE_LOCATION", wf.getValue("PURCHASE_LOCATION", i));
					wxp2.addVar("ITEM_NO", wf.getValue("ITEM_NO", i));
					wxp2.addVar("VENDOR_CODE", wf.getValue("VENDOR_CODE", i));
//					wxp2.addVar("PLANT_CODE", wf.getValue("PLANT_CODE", i));
//					wxp2.addVar("SEQ", wf.getValue("SEQ", i));
					wxp2.addVar("VALID_FROM_DATE", args[m][3]);

					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp2.getQuery());

					rtn = sm.doUpdate(null, null);
				}
			}

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_1");

			wxp.addVar("HOUSE_CODE", info.getSession("HOUSE_CODE"));
			wxp.addVar("COMPANY_CODE", info.getSession("COMPANY_CODE"));
			wxp.addVar("ITEM_NO", args[m][0]);
			wxp.addVar("VENDOR_CODE", args[m][1]);
			wxp.addVar("BASIC_UNIT", args[m][2]);
			wxp.addVar("VALID_FROM_DATE", args[m][3]);
			wxp.addVar("VALID_TO_DATE", args[m][4]);
			wxp.addVar("UNIT_PRICE", args[m][5]);
//			wxp.addVar("PLANT_CODE", args[m][6]);
			wxp.addVar("USER_ID", user_id);
//			wxp.addVar("CONT_SEQ", args[m][7]);

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doInsert(null, null);

			if (rtn < 1)
				throw new Exception("INSERT ICOYINFO ERROR");
			}

		} catch (Exception e) {
			returnString = e.getMessage();
			Rollback();
			throw new Exception(e.getMessage());
		}

		return returnString;
	}	 */
	 
	 
	 
	 
	 /**
	 * 액셀업로드 (ICOYBDVS 테이블 임시저장)
	 * MethodName : setExcelSavePurchaseLedgerInfo
	 * 작성일     : 2011. 03. 28
	 * Location   : sepoa.svc.master.MT_031.setExcelSavePurchaseLedgerInfo
	 * 서비스설명 : 엑셀등록
	 * 작성자     : 한영임
	 * 변경이력   :  
	 */
	public SepoaOut setExcelSaveInfo2ItemMgt(String[][] setData, String transaction_id) throws Exception
 	{
		ConnectionContext         ctx          = null;
        SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
		String                    id           = info.getSession("ID");
		int                       rtn          = 0;
		Map<String, String>       map     	   = null;
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		try{
			String ITEM_NO			= "";
			String VENDOR_CODE      = "";
			String BASIC_UNIT		= "";
			String VALID_FROM_DATE  = "";
			String VALID_TO_DATE    = "";
			String UNIT_PRICE       = "";
			
			//등록
    		for(int i=0; i < setData.length; i++){
 
    			ITEM_NO 		= setData[i][0];
    			VENDOR_CODE     = setData[i][1];
    			BASIC_UNIT      = setData[i][2];
    			VALID_FROM_DATE = setData[i][3];
    			VALID_TO_DATE   = setData[i][4];
    			UNIT_PRICE      = setData[i][5];
    			
    			sxp = new SepoaXmlParser(this, "setExcelSaveInfo2ItemMgt");
	            ssm = new SepoaSQLManager(id, this, ctx, sxp);
	            map = new HashMap<String, String>();
	            map.put("TRANSACTION_ID", transaction_id);
	            map.put("ITEM_NO", ITEM_NO);
	            map.put("VENDOR_CODE", VENDOR_CODE);
	            map.put("BASIC_UNIT", BASIC_UNIT);
	            map.put("VALID_FROM_DATE", VALID_FROM_DATE);
	            map.put("VALID_TO_DATE", VALID_TO_DATE);
	            map.put("UNIT_PRICE", UNIT_PRICE);
	            
	            rtn = ssm.doUpdate(map);
	            
    		}
	       
    		setStatus( 1 );
    		/*if ( rtn > 0 ){
    			setMessage("비정상적으로 처리되었습니다.");
    			setStatus( 0 );
    		}else{
				setMessage("성공적으로 변경하였습니다.");
			}*/
    		
    		Commit();
    		
	    } catch(Exception e) {
	        try { Rollback(); }
	        catch(Exception d) {
	            Logger.err.println(info.getSession("ID"),this,d.getMessage());
	        }

//	        e.printStackTrace();
	        Logger.err.println(info.getSession("ID"),this, e.getMessage());
	        setFlag(false);
	        setStatus(0);
	        setMessage(e.getMessage());
	    }

	    return getSepoaOut();
	}
	
	/**
 	 * 연단가등록팝업 화면 조회
 	 * @param data
 	 * @return
 	 */
 	public SepoaOut getInfo2ItemMgt(Map<String, String> data)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");
		
		String rtn="";

		try
		{
			
			rtn = et_getInfo2ItemMgt(data);//상세품목등록 조회
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
 	private	String et_getInfo2ItemMgt(Map<String, String> data) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager sm = null;
		
		try
		{
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"), this , ctx, sxp.getQuery());

			rtn	= sm.doSelect(data);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
 	
 	/**
 	 * 연단가품목등록 저장 : 존재여부 체크 후 INSERT/UPDATE
 	 * @param data
 	 * @return
 	 * @throws Exception
 	 */
	@SuppressWarnings("unchecked")
	public SepoaOut doSaveInfo2ItemMgt(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx           = null;
		SepoaXmlParser            sxp1          = null;
		SepoaSQLManager           ssm1          = null;
		SepoaXmlParser            sxp2          = null;
		SepoaSQLManager           ssm2          = null;
		SepoaXmlParser            sxp3          = null;
		SepoaSQLManager           ssm3          = null;
		SepoaXmlParser            sxp4          = null;
		SepoaSQLManager           ssm4          = null;
		SepoaXmlParser            sxp5          = null;
		SepoaSQLManager           ssm5          = null;
		SepoaXmlParser            sxp6          = null;
		SepoaSQLManager           ssm6          = null;
		List<Map<String, String>> grid          = null;
		Map<String, String>       header        = null;
		Map<String, String>       gridInfo      = null;
		String                    houseCode     = info.getSession("HOUSE_CODE");
		String                    companyCode   = info.getSession("COMPANY_CODE");
		String                    userId        = info.getSession("ID");
		String                    currDate      = SepoaDate.getShortDateString();
		String                    currTime      = SepoaDate.getShortTimeString();
		
		SepoaOut wo = null;
		String doc_no = null;
		
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			header = MapUtils.getMap(data, "headerData");
			
			// 상세품목등록 저장 (그리드 행의 수만큼 저장)
			for(int i = 0; i < grid.size(); i++) {
				
				gridInfo = grid.get(i);
				
				gridInfo.put("HOUSE_CODE",      houseCode);
				gridInfo.put("COMPANY_CODE",    companyCode);
            	gridInfo.put("USER_ID",         userId);
            	gridInfo.put("CURR_DATE",       currDate);
            	gridInfo.put("CURR_TIME",       currTime);
            	gridInfo.put("PURCHASE_LOCATION",     "01" );
            	gridInfo.put("ADD_DATE",     	currDate );
            	gridInfo.put("ADD_TIME",     	currTime );
            	gridInfo.put("ADD_USER_ID",  	userId );
            	
            	// 실제 품목 존재여부 체크
                sxp2 = new SepoaXmlParser(this, "doCheckInfo");
                ssm2 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp2);
                SepoaFormater sf2 = new SepoaFormater( ssm2.doSelect( gridInfo ) );
                
                int exist_cnt2 = Integer.valueOf( sf2.getValue("CNT", 0) );
                if(exist_cnt2 == 0) {// 실제 품목이 없으면 인서트

                	// insert
    				sxp5 = new SepoaXmlParser(this, "doInfo2ItemMgtInsert");
    				ssm5 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp5);
    				ssm5.doInsert(gridInfo);
                	
                } 
                
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
//			e.printStackTrace();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut doDeleteInfo2ItemMgt(Map<String, Object> data) throws Exception{
		ConnectionContext         ctx           = null;
		SepoaXmlParser            sxp           = null;
		SepoaSQLManager           ssm           = null;
		List<Map<String, String>> grid          = null;
		Map<String, String>       header        = null;
		Map<String, String>       gridInfo      = null;
		String                    houseCode     = info.getSession("HOUSE_CODE");
		String                    userId        = info.getSession("ID");
		String                    currDate      = SepoaDate.getShortDateString();
		String                    currTime      = SepoaDate.getShortTimeString();
		
		SepoaOut wo = null;
		String doc_no = null;
		
		setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			header = MapUtils.getMap(data, "headerData");
			
			sxp = new SepoaXmlParser(this, "doDeleteInfo2ItemMgt");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			ssm.doDelete(header);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
//			e.printStackTrace();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}
		
		return getSepoaOut();
	}
}
