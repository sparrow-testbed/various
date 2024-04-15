package supply.bidding.rat;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Config;
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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;

/*
 ------------------------------------------------------------------------------------------------------------
 FUNCTION                        PATH (견적관리>역경매>)       JSP 파일명    DESCRIPTION
 -------------------------------------------------------------------------------------------------------------
 setratbdins1_1                  역경매입찰진행		       	    rat_bd_ins1   역경매입찰

 getratbdlis1_1                  역경매현황         		rat_bd_lis1   역경매현황 내역조회
 getratbdins1_1                  역경매입찰위한 조회       	rat_bd_ins1   역경매입찰위한 조회
 getratbdlis2_1                  역경매결과       		    rat_bd_lis2   역경매결과조회
 --------------------------------------------------------------------------------------------------------------
*/
public class s2031 extends SepoaService
{

	String company_code  ="";

	String user_id		= info.getSession("ID");
	String house_code	= info.getSession("HOUSE_CODE");
	String plant_code	= info.getSession("PLANT_CODE");
	String operating_code	= info.getSession("OPERATING_CODE");
	String vendor_code	= info.getSession("COMPANY_CODE");
	String department	= info.getSession("DEPARTMENT");
	String name_loc		= info.getSession("NAME_LOC");
	String name_eng		= info.getSession("NAME_ENG");
	String language		= info.getSession( "LANGUAGE" );
	String ctrl_code	= info.getSession( "CTRL_CODE" );
	String tel		= info.getSession( "TEL" );
	String email		= info.getSession( "EMAIL" );

	Message msg = new Message(info, "supplier");

	public s2031(String opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
		setVersion("1.0.0");

	}

/**
 * 역경매입찰 >입찰
 **/
	public SepoaOut setratbdins1_1(Map<String, Object> data) {
		String rtn = "";
		Logger.err.println( info.getSession( "ID" ), this, "setratbdins1_1 start_________________________________" );
		
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;
		Map<String, String> 	  header		= null;
		header = MapUtils.getMap(data, "headerData");	
		
		try {
			
//			Logger.err.println( info.getSession( "ID" ), this, "pData _________________________________" +pData);
//			Logger.err.println( info.getSession( "ID" ), this, "dataRABD _________________________________" +dataRABD);
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			for(int i = 0 ; i < grid.size(); i++ ){
				gridInfo = grid.get(i);
				rtn = et_setratbdins1_1(header, gridInfo);
				Logger.err.println( info.getSession( "ID" ), this, "rtn _________________________________" +rtn);
			}

			if (rtn.equals("ERROR")) {
				setMessage(msg.getMessage("0003"));
				setStatus(0);
				try {
					Rollback();
				} catch (SepoaServiceException e1) {
					// TODO Auto-generated catch block
					Logger.err.println( info.getSession( "ID" ), this, "setratbdins1_1 SepoaServiceException e1 =" + e1.getMessage() );					
				}
			} else {
				setValue(rtn);
				setStatus(1);
				Commit();
			}
			
			
		} catch(Exception e) {
			
			Logger.err.println( info.getSession( "ID" ), this, "setratbdins1_1 Exception e =" + e.getMessage() );
			setStatus(0);
		}
		return getSepoaOut();
	}


/**
 * 역경매입찰 >입찰
 **/
	private String et_setratbdins1_1(Map<String, String> header, Map<String, String> gridInfo) throws Exception
	{	
        String rtnString = "";

		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

//		Logger.debug.println(info.getSession("ID"),this,"pData len:_____________" +pData.length);
		 
        String house_code = info.getSession("HOUSE_CODE");
        String ra_no      = header.get("ra_no");
        String ra_count   = header.get("ra_count");
        String bid_price  = header.get("bid_price");
        String bid_flag   = header.get("bid_flag");
        
        String count_day  = header.get("count_day");
        String count_hh   = header.get("count_hh");
        String count_mi   = header.get("count_mi");
        String count_ss   = header.get("count_ss");
        
        Logger.debug.println(info.getSession("ID"),this,"house_code:_____________" +house_code);
        Logger.debug.println(info.getSession("ID"),this,"ra_no:_____________" +ra_no);
        Logger.debug.println(info.getSession("ID"),this,"ra_count:_____________" +ra_count);
        Logger.debug.println(info.getSession("ID"),this,"bid_price:_____________" +bid_price);
        Logger.debug.println(info.getSession("ID"),this,"bid_flag:_____________" +bid_flag);
        Logger.debug.println(info.getSession("ID"),this,"count_day:_____________" +count_day);
        Logger.debug.println(info.getSession("ID"),this,"count_hh:_____________" +count_hh);
        Logger.debug.println(info.getSession("ID"),this,"count_mi:_____________" +count_mi);
        Logger.debug.println(info.getSession("ID"),this,"count_ss:_____________" +count_ss);
        
        String time_flag = "N";
        
		if(count_day.equals("0") && count_hh.equals("00") && Integer.parseInt(count_mi) < 2){
        	time_flag = "Y";
		}
        
		int rtnIns = 0;
	    String[] pChkData = {house_code, ra_no, ra_count};
	    SepoaXmlParser wxp = null;
		
	    Logger.debug.println(info.getSession("ID"),this,"here....");
	    
	    try {
			/* 역경매 완료여부를 확인 */
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			
			Logger.debug.println(info.getSession("ID"),this,"here....");

			String rtnStr = sm.doSelect(pChkData);
			SepoaFormater wf = new SepoaFormater(rtnStr);
			
			String ra_status     = ""; 
			String current_price = ""; 
			if(wf.getRowCount() > 0) {
				ra_status     = wf.getValue("RA_STATUS",0);
				current_price = wf.getValue("CURRENT_PRICE",0);
			}

			if (ra_status.equals("N")){
				rtnString = "END";
				return rtnString;
			}

			/* 역경매 금액 확인 */
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			rtnStr = sm.doSelect(pChkData);
			wf = new SepoaFormater(rtnStr);

			long vote_count    = 0;
			String min_bid_price = "0";
			if(wf.getRowCount() > 0) {
				vote_count    = Long.parseLong(wf.getValue("VOTE_COUNT",0));
				min_bid_price = wf.getValue("MIN_BID_PRICE",0);
			}
			
			bid_price            = bid_price.replaceAll(",", "");
			String cur_bid_price = bid_price;

			String check = "";
			
			/*
			 * vote_count 가 0일 경우는 입찰을 처음하는 경우
			 * check 를 first_bid로 수정해주고
			 * bid_flag는 N으로 수정해준다. 
			 * default 값은 Y
			 */
			if (vote_count == 0 ) {
				min_bid_price = cur_bid_price;
				check         = "first_bid";
				bid_flag	  = "N"; // Y이면 입찰을 1번이상 했음, N이면 입찰을 한번도 하지 않았음.
			}

			if ((Double.parseDouble(min_bid_price) == Double.parseDouble(cur_bid_price)) && !check.equals("first_bid")) {
			    rtnString = "EQU";
		        Logger.debug.println(info.getSession("ID"),this,"RA Return Status [" + ra_no + "]_1==>EQU");
			    return rtnString;
			}

			if (Double.parseDouble(min_bid_price) >= Double.parseDouble(cur_bid_price)) {
				//입찰한적이 있는지의 여부임..
				//업체가 입찰한적이 있으면 ICOYRAHD.BID_COUNT는 증가하지 않음...
				//time_flag 가 Y이면 시간을 2분 연장해줌.
                
                wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
                wxp.addVar("bid_flag",   bid_flag);
                wxp.addVar("time_flag",  time_flag);

	        	sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

	        	String[][] dataRAHD = {{bid_price, house_code, ra_no, ra_count, current_price}};
	        	String[] type_rahd  = { "S","S","S","S","S"};
			    
	        	rtnIns = sm.doUpdate(dataRAHD,type_rahd);

				if (rtnIns != 1) {
					rtnString = "DUP";
			        Logger.debug.println(info.getSession("ID"),this,"RA Return Status [" + ra_no + "]_2==>DUP");
					return rtnString;
				}
				
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");

			    sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());
			    
			    gridInfo.put("house_code"	, house_code);
			    gridInfo.put("vendor_code"	, vendor_code);
			    gridInfo.put("ra_no"		, ra_no);
			    gridInfo.put("ra_count"		, ra_count);
			    gridInfo.put("company_code"	, company_code);
			    gridInfo.put("user_id"		, user_id);
			    gridInfo.put("name_loc"		, name_loc);
			    gridInfo.put("name_eng"		, name_eng);
			    gridInfo.put("cur"			, header.get("cur"));
			    gridInfo.put("SETTLE_FLAG"	, "N");
			    rtnIns = sm.doInsert(gridInfo);
		    } else {
				rtnString = "DUP";
		        Logger.debug.println(info.getSession("ID"),this,"RA Return Status [" + ra_no + "]_3==>DUP:" + min_bid_price + ":" + cur_bid_price);
				return rtnString;
			}
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			rtnString = "ERROR";
		}
		
		return rtnString;
	}


/**
 * 역경매현황>조회(낙찰안된 건에 대한 조회임)
 **/

	public SepoaOut getratbdlis1_1(Map<String, String> header)
    {
		try {

			String rtn = "";
			rtn = et_getratbdlis1_1(header);
			if (rtn == null) rtn = "";
			setValue(rtn);

            rtn = et_getDBTime();
			setValue(rtn);

			setStatus(1);
		}catch(Exception e)
		{
			Logger.err.println("getratbdlis1_1 ======>>" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("002"));
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}



/**
 * 역경매현황>조회
 **/
	private String et_getratbdlis1_1(Map<String, String> header) throws Exception
    {
		String rtn = "";
   		ConnectionContext ctx = getConnectionContext();
   		
   		SepoaXmlParser wxp =null; 
   		SepoaSQLManager sm = null;
   			
		try {
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("company_code", vendor_code);
			wxp.addVar("vendor_code", vendor_code);
			wxp.addVar("house_code", house_code);
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

			rtn = sm.doSelect(header);

		}catch(Exception e) {
			Logger.debug.println(info.getSession("ID"),this,"et_getratbdlis1_1 = " + e.getMessage());
		} finally{

		}
		return rtn;
	}

	private String et_getDBTime() throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		
		/*
		sql.append(" SELECT to_char(sysdate, 'YYYYMMDDHH24MISS')              \n");
		sql.append("   FROM dual                                              \n");
		 */
		try {
			
			SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

			rtn = sm.doSelect((String[])null);
		} catch(Exception e) {
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


/**
 * 역경매입찰>로딩되면서 내역조회
 **/

	public SepoaOut getratbdins1_1(String[] pData) {
		String rtn = "";

		try {
			rtn = et_getratbdins1_1(pData);

			if( rtn != null ) {
				setValue(rtn);

				setStatus(1);
			}
		} catch(Exception e) {
			Logger.err.println("getratbdins1_1 ======>>" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("002"));
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}



/**
 * 역경매입찰>로딩되면서 내역조회
 **/
	private String et_getratbdins1_1(String[] pData) throws Exception {
		String rtn = "";
		String rtnStr = "";

   		ConnectionContext ctx = getConnectionContext();
   		SepoaXmlParser wxp = null;
   		SepoaSQLManager sm = null;
   		
   		Map<String, String> pCheck = new HashMap<String, String>();
   		pCheck.put("house_code"	, pData[1]);
   		pCheck.put("ra_no"		, pData[2]);
   		pCheck.put("ra_count"	, pData[3]);
   		pCheck.put("vendor_code", pData[0]);
   		
   		
   		try {
			
			/*
			 * ICOYRABD 테이블의 BID_SEQ를 조회
			 */
			wxp = new SepoaXmlParser(this, "et_checkMaxRABD");
			
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			
			rtnStr = sm.doSelect(pCheck);
			
			SepoaFormater wf = new SepoaFormater(rtnStr);
			
			String BID_SEQ = wf.getValue(0,0);
			
   			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());   			
   			wxp.addVar("BID_SEQ", BID_SEQ);
   			wxp.addVar("VENDOR_CODE", info.getSession("COMPANY_CODE"));   			
   			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

			rtn = sm.doSelect(pData);

		}catch(Exception e) {
			Logger.debug.println(info.getSession("ID"),this,"et_getratbdins1_1 = " + e.getMessage());
		} finally{

		}
		return rtn;
	}


/**
 * 역경매결과현황>조회
 **/

	public SepoaOut getratbdlis2_1(Map<String, String> header) {
		String rtn = "";

		try {
			rtn = et_getratbdlis2_1(header);

			if( rtn != null ) {
				setValue(rtn);
				setStatus(1);
			}
		} catch(Exception e) {
			Logger.err.println("getratbdlis2_1 ======>>" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("002"));
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}



/**
 * 역경매결과현황>조회
 **/
	private String et_getratbdlis2_1(Map<String, String> header) throws Exception {

		String rtn = "";

   		ConnectionContext ctx = getConnectionContext();

		try {
			int j =0;

   			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
   			wxp.addVar("vendor_code", vendor_code);
   			wxp.addVar("house_code", house_code);
   			
			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());

			rtn = sm.doSelect(header);

		}catch(Exception e) {
			Logger.debug.println(info.getSession("ID"),this,"et_getratbdlis2_1 = " + e.getMessage());
		} finally{

		}
		return rtn;
	}



/**
 *  지명업체리스트>조회
 **/

	public SepoaOut getratpplis3_1(String ra_no, String ra_count, String ra_seq) {

		try {

			String rtn = "";

			rtn = et_getratpplis3_1(ra_no, ra_count, ra_seq);

			if( rtn != null )
			{
				setValue(rtn);
				setStatus(1);
			}
		}catch(Exception e)
		{
			Logger.err.println("getratpplis3_1 ======>>" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("002"));
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}



/**
 *  지명업체리스트>조회
 **/

	private String et_getratpplis3_1(String ra_no, String ra_count, String ra_seq) throws Exception {

		String rtn = "";

   		ConnectionContext ctx = getConnectionContext();

		try {
			int j =0;
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());	
			wxp.addVar("house_code", house_code);
			wxp.addVar("ra_no", ra_no);
			wxp.addVar("ra_count", ra_count);
			
			/*	
			sql.append( "SELECT 	VENDOR_CODE, 			\n" );
			sql.append( "		VENDOR_NAME                     \n" );
			sql.append( "FROM	ICOYRQSE                        \n" );
			sql.append( "WHERE	HOUSE_CODE = '"+house_code+"'   \n" );
			sql.append( "AND	RFQ_NO = '"+ra_no+"'            \n" );
			sql.append( "AND	RFQ_COUNT = '"+ra_count+"'      \n" );
			sql.append( "AND	RFQ_SEQ = '"+ra_seq+"'          \n" );
			 */

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());


			rtn = sm.doSelect((String[])null);

			Logger.debug.println(info.getSession("ID"),this,"rtn==============>" + rtn);



		}catch(Exception e) {
			Logger.debug.println(info.getSession("ID"),this,"et_getratpplis3_1 = " + e.getMessage());
		} finally{

		}
		return rtn;
	}

	    // 기본정보 조회
    public SepoaOut getCompareDisplay(String RA_NO, String RA_COUNT)
    {
        String rtnData = null;
        try {

            rtnData = et_getBDHDDisplay(RA_NO, RA_COUNT);
            setValue(rtnData);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }
        return getSepoaOut();
    }

    private String et_getBDHDDisplay(String RA_NO, String RA_COUNT) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
        wxp.addVar("RA_NO", RA_NO);
        wxp.addVar("RA_COUNT", RA_COUNT);
        wxp.addVar("vendor_code", vendor_code);
        
        /*
        sql.append(" SELECT                                                     				\n");
        sql.append("        HD.RA_NO   					                         				\n");
        sql.append("        ,HD.RA_COUNT         		                         				\n");
        sql.append("        ,HD.SUBJECT                                							\n");
        sql.append("        ,GETICOMCODE2(HD.HOUSE_CODE, 'M989', HD.RA_TYPE1) AS RA_TYPE1_TEXT  \n");
        sql.append("        ,HD.RD_DATE                                       					\n");
        sql.append("        ,HD.DELY_PLACE                                     					\n");
        sql.append("        ,HD.CONT_STATUS                                         			\n");
        sql.append("        ,HD.CUR                                         					\n");
		sql.append( "       ,(SELECT SUM(BID_AMT) BID_PRICE                                   \n" );
		sql.append( "          FROM ICOYRABD BD, (SELECT MAX(BID_SEQ) BID_SEQ, RA_NO, HOUSE_CODE, RA_COUNT, VENDOR_CODE     \n" );
		sql.append( "          					    FROM ICOYRABD     \n" );
		sql.append( "          					   WHERE 1 = 1     \n" );
		sql.append( "          					     AND VENDOR_CODE =  '"+vendor_code+"'     \n" );
		sql.append( "          					     AND STATUS <> 'D'                                  \n" );
		sql.append( "          				       GROUP BY RA_NO, HOUSE_CODE, RA_COUNT, VENDOR_CODE) CH                                      \n" );
		sql.append( "         WHERE HOUSE_CODE  = HD.HOUSE_CODE                                 \n" );
		sql.append( "           AND RA_NO       = HD.RA_NO                                      \n" );
		sql.append( "           AND RA_COUNT    = HD.RA_COUNT                                   \n" );
		sql.append( "           AND VENDOR_CODE = '"+vendor_code+"'                             \n" );
		sql.append( "           AND STATUS      <> 'D') BID_PRICE                               \n" );
        sql.append(" FROM ICOYRAHD HD                              								\n");
        sql.append(" WHERE HD.HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'  \n");
        sql.append(" AND   HD.RA_NO     = '"+RA_NO+"'                         \n");
        sql.append(" AND   HD.RA_COUNT  = '"+RA_COUNT+"'                      \n");
        sql.append(" AND   HD.STATUS IN ('C', 'R')                              \n");
		*/
		
        try {
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

            rtn = sm.doSelect((String[])null);
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }


        // 기본정보 조회
    public SepoaOut getDetailDisplay(String[] data)
    {
        String HOUSE_CODE   = data[0];
        String RA_NO       = data[1];
        String RA_COUNT    = data[2];
        String VENDOR_CODE = data[3];
        String rtnData = null;
        try {

            // bdHD, bdPG --입찰일반정보
            rtnData = et_getDetailDisplay(HOUSE_CODE, RA_NO, RA_COUNT, VENDOR_CODE);
            setValue(rtnData);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        } catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }
        return getSepoaOut();
    }

    private String et_getDetailDisplay(String HOUSE_CODE, String RA_NO, String RA_COUNT, String VENDOR_CODE) throws Exception
    {

        ConnectionContext ctx = getConnectionContext();

        String rtn = "";
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("HOUSE_CODE", HOUSE_CODE);
        wxp.addVar("RA_NO", RA_NO);
        wxp.addVar("RA_COUNT", RA_COUNT);
        wxp.addVar("VENDOR_CODE", VENDOR_CODE);
        
        /*
        sql.append(" SELECT ROWNUM AS NO, BD.* FROM (            	\n");
		sql.append(" SELECT DESCRIPTION_LOC,                     	\n");
		sql.append("        UNIT_MEASURE,                        	\n");
        sql.append("        NVL(RA_QTY,0) AS RA_QTY,          		\n");
        sql.append("        CUR,                   					\n");
        sql.append("        NVL(SBID_PRICE,0) AS SBID_PRICE,    	\n");
        sql.append("        NVL(SBID_AMT,0) AS SBID_AMT,        	\n");
		sql.append("        HOUSE_CODE,                          	\n");
		sql.append("        RA_NO,                               	\n");
		sql.append("        RA_COUNT,                            	\n");
		sql.append("        RA_SEQ                               	\n");
		sql.append("        ,PR_NO                               	\n");
		sql.append("        ,PR_SEQ,SPECIFICATION,BUYER_ITEM_NO    	\n");
		sql.append("   FROM ICOYRADT                             	\n");
		sql.append("  WHERE 1 =1                                 	\n");
		sql.append("    AND HOUSE_CODE = '"+ HOUSE_CODE +"'      	\n");
		sql.append("    AND RA_NO = '"+ RA_NO+"'              	 	\n");
		sql.append("    AND RA_COUNT = '"+ RA_COUNT+"'           	\n");
		sql.append("  ORDER BY RA_SEQ                            	\n");
		sql.append("  )BD                                        	\n");
		sql.append("  ORDER BY ROWNUM                            	\n");
		*/

        try{
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

            rtn = sm.doSelect((String[])null);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    public SepoaOut setControlAmt(String[][] args, String[][] interfaceData)
    {
        try{

            int rtn = et_setControlAmt(args);

            if( rtn == -1 )
            {
                setStatus(0);
                setMessage(msg.getMessage("0036"));
                Rollback();
            }
            else
            {

           		//this.set_interface_flag(interfaceData); // 인터페이스제거

         		rtn = et_setControlAmt2(args);

            	if( rtn == -1 )
	            {
    	            setStatus(0);
        	        setMessage(msg.getMessage("0036"));
            	    Rollback();
            	}
            	else
            	{
                	setStatus(1);
                	setValue(rtn+"");
                	setMessage("저장되었습니다.");
                	Commit();
                }
            }
            Logger.debug.println(info.getSession("ID"),this,"service Message------------------>"+msg.getMessage("0000"));
        }catch(Exception e) {
            try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0036"));
        }

        return getSepoaOut();
    }
    
    /**
    * 입찰화면에서 해당 역경매건의 아이템 목록 조회
    **/

   	public SepoaOut getReAuctionList(Map<String, String> header) {
   		String rtn = "";

   		try {
   			rtn = et_getReAuctionList(header);
   			if( rtn != null ) {
   				setValue(rtn);
   				setStatus(1);
   			}
   			
   			rtn = et_getDBTime();
			setValue(rtn);

			setStatus(1);
   			
   			
   		} catch(Exception e) {
   			Logger.err.println("getReAuctionList ======>>" + e.getMessage());
   			setStatus(0);
   			setMessage(msg.getMessage("002"));
   			Logger.err.println(this,e.getMessage());
   		}
   		return getSepoaOut();
   	}
   	
   	
   	private String et_getReAuctionList(Map<String, String> header) throws Exception
    {

        ConnectionContext ctx = getConnectionContext();

        String rtn = "";
        
        SepoaXmlParser wxp = null;
        
        SepoaSQLManager sm = null;
//        String [] pChkData = {pData[0],pData[1],pData[2],vendor_code};
        
        try{
        	header.put("house_code", house_code);
        	
        	wxp = new SepoaXmlParser(this, "et_checkMaxRABD");
        	
        	sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			
        	String rtnStr = sm.doSelect(header);
			
        	SepoaFormater wf = new SepoaFormater(rtnStr);
			
        	String BID_SEQ = wf.getValue(0,0);
        	
        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("vendor_code", vendor_code);
        	wxp.addVar("BID_SEQ", BID_SEQ);
        	
            sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

            rtn = sm.doSelect(header);

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
   	

    private int et_setControlAmt(String[][] args) throws Exception
    {
        ConnectionContext ctx = getConnectionContext();

        int rtn = 0;

        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE ICOYRADT                        \n");
        sql.append(" SET SBID_PRICE = ?                     \n");
        sql.append(" , SBID_AMT = ?                     	\n");
        sql.append(" WHERE HOUSE_CODE = ?                   \n");
        sql.append("   AND RA_NO = ?                       \n");
        sql.append("   AND RA_COUNT    = ?                 \n");
        sql.append("   AND RA_SEQ    = ?                  \n");

        try{
            String[] type = {"S","S","S","S","S","S"};
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            rtn = sm.doUpdate(args,type);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {

        }
        return rtn;
    }

    private int et_setControlAmt2(String[][] args) throws Exception
    {
        ConnectionContext ctx = getConnectionContext();

        int rtn = 0;

        StringBuffer sql = new StringBuffer();

        sql.append(" UPDATE ICOYRAHD                         	\n");
        sql.append(" SET CONT_STATUS = 'Y'                     	\n");
        sql.append(" WHERE HOUSE_CODE = '"+args[0][2]+"'        \n");
        sql.append("   AND RA_NO = '"+args[0][3]+"'            \n");
        sql.append("   AND RA_COUNT    = '"+args[0][4]+"'      \n");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            rtn = sm.doUpdate((String[][])null,null);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }finally {

        }
        return rtn;
    }


    private void set_interface_flag(String[][] interfaceData) throws Exception{
        Connection   msconn    = getConnectionMSSQL();
        Statement    ps1       = msconn.createStatement();
        int          rtnIns    = 0;
        StringBuffer sql       = null;
        ResultSet    rs1       = null;
        String       vendor_ck = "";

        Logger.debug.println(info.getSession("ID"), this, "interfaceData.length = " + interfaceData.length);

        try {
        	for(int i=0; i < interfaceData.length; i++){
	            sql = new StringBuffer();
	            
	            sql.append( "UPDATE                                                 \n");
	            sql.append( "    PU_REQACT_DTAL                                     \n");
	            sql.append( "SET                                                    \n");
	            sql.append( "    GOODSNM  = '" + interfaceData[i][0] + "'          \n");
	            sql.append( "    ,QTY  = '" + interfaceData[i][1] + "'              \n");
	            sql.append( "    ,UPRICE  = '" + interfaceData[i][2] + "'           \n");
	            sql.append( "    ,AMNT  = '" + interfaceData[i][3] + "'             \n");
	            sql.append( "    ,WONAMNT  = '" + interfaceData[i][3] + "'          \n");
	            sql.append( "    ,CLIENTCD  = NVL((SELECT CLIENTCD FROM AC_CODE_CUST WHERE BIZNO = '" + interfaceData[i][4] + "' AND ROWNUM < 2 ), 'N')         \n");
				sql.append( "    ,UPDATEPP  = '9999999999999'          \n");
				sql.append( "    ,UPDATEDTTM  = TO_CHAR( SYSDATE, 'YYYYMMDDHH24MISS')          \n");
	            sql.append( "WHERE                                                  \n");
	            sql.append( "    YRMM || DCSSEQ = '" + interfaceData[i][5] + "'     \n");
	            sql.append( "    AND DCSORDR = '" + interfaceData[i][6] + "'      	\n");
	            sql.append( "    AND BIDREADYN = 'Y'      	\n");

            	Logger.debug.println(info.getSession("ID"), this, "UPDATE PU_REQACT_DTAL = " + sql.toString());
            	
	            rtnIns = ps1.executeUpdate(sql.toString());

	            sql = new StringBuffer();
	            
	            sql.append("  SELECT COUNT(*) AS COUNT           	 				\n");
            	sql.append("    FROM PU_REQACT_DTAL                       			\n");
	            sql.append( "WHERE                                                  \n");
	            sql.append( "    YRMM || DCSSEQ = '" + interfaceData[i][5] + "'     \n");
	            sql.append( "    AND CLIENTCD IS NULL      	\n");

            	Logger.debug.println(info.getSession("ID"), this, "SELECT COUNT(CLIENTCD) = " + sql.toString());
            	
            	rs1 = ps1.executeQuery(sql.toString());//쿼리결과값을 받는다.

            	while( rs1.next() ){
            		vendor_ck = rs1.getString("COUNT");
            	}

            	Logger.debug.println(info.getSession("ID"), this, "vendor_ck = " + vendor_ck);

		        if(vendor_ck.equals("0")){
		        	sql = new StringBuffer();
		        	
		            sql.append( "UPDATE                                                 \n");
		            sql.append( "    PU_REQUEST_ACT                                     \n");
		            sql.append( "SET                                                    \n");
		            sql.append( "    BIDDIV  = 'C_PUR_07_003'                         	\n");
		            sql.append( "    ,DELIVPLACE  = '" + interfaceData[i][7] + "'       \n");
		            sql.append( "    ,DELIVDAT  = '" + interfaceData[i][8] + "'         \n");
		            sql.append( "    ,PURMETHOD  = '" + interfaceData[i][9] + "'        \n");
		            sql.append( "    ,TTLAMNT  = '" + interfaceData[i][10] + "'         \n");
					sql.append( "    ,UPDATEPP  = '9999999999999'						\n");
					sql.append( "    ,UPDATEDTTM  = TO_CHAR( SYSDATE, 'YYYYMMDDHH24MISS')          \n");
		            sql.append( "WHERE                                                  \n");
		            sql.append( "    YRMM || DCSSEQ = '" + interfaceData[i][5] + "'     \n");
		            sql.append( "    AND ELECTSETLSTATE = 'C_INSA_38_001'     			\n");

	            	Logger.debug.println(info.getSession("ID"), this, "UPDATE PU_REQUEST_ACT = " + sql.toString());
	            	
		            rtnIns = ps1.executeUpdate(sql.toString());

		        }
	        
        	}
        	
        	Commit();
        	ps1.close();
        }
        catch(Exception e) {
            Rollback();
            
            Logger.debug.println("", this, "error = " + e.getMessage());
        }
        finally{
        	if(msconn != null){
//    	   		try{
    	   			msconn.close();
//    	   		}
//    	   		catch(Exception e){}
    	   	}
        }
    }

    static public Connection getConnectionMSSQL()
    throws Exception
    {
        Config conf         = new Configuration();
        String driver       = conf.get("Sepoa.interface.interfacedriver");
        String url          = conf.get("Sepoa.interface.interfaceurl");
        String user         = conf.get("Sepoa.interface.interfaceuser");
        String passwd       = conf.get("Sepoa.interface.interfacepassword");

        
        
        
        



        if (driver == null)
            throw new Exception("JDBC Driver 정보가 존재하지 않습니다.");

        if (url == null)
            throw new Exception("JDBC URL 정보가 존재하지 않습니다.");

        // driver에 해당하는 Class 로드
        Class.forName(driver);

        if (user != null && passwd != null) {
            return DriverManager.getConnection(url, user, passwd);
        }
        else {  // client, user, password 모두 null인 경우
            return DriverManager.getConnection(url);
        }
    }
    
    
    
    /*
	 * 역경매에 참여할 업체의 적격 여부 등록
	 * 
	 */
	
	 public SepoaOut setVendorReg(Map<String, Object> data) {
	        int rtn = 0;
	        String flag = "";
	        String check = "";
	        
			List<Map<String, String>> grid          = null;
			Map<String, String>       gridInfo      = null;
			Map<String, String> 	  header		= null;
			header = MapUtils.getMap(data, "headerData");	
			
			String RA_TYPE1 = header.get("RA_TYPE1");
	        
	        
	        try {
	        	
	        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	        	
	        	if(grid != null && grid.size() > 0){
	        		for(int i = 0 ; i < grid.size() ; i++){
	        			gridInfo = grid.get(i);
	        			gridInfo.put("REG_FLAG"		, "Y");
	        			gridInfo.put("JOIN_FLAG"	, "");
	        			gridInfo.put("VENDOR_CODE"	, header.get("vendor_code"));
	        			gridInfo.put("house_code"	, house_code);
//	        			gridInfo.put("company_code"	, company_code);
	        			gridInfo.put("company_code"	, "WOORI");
	        			
	        			
	        			//지명경쟁일때
	        			if("NC".equalsIgnoreCase(RA_TYPE1)){
	        				rtn = et_setJoinVendorUpd(gridInfo);
	        			}else{
	        				rtn = et_setJoinVendorReg(gridInfo); 
	        			}
	        		}
	        	}
	        	
            	
	        	if (rtn < 0) { //오류 발생
        			setMessage("참가신청 도중 ERROR가 발생했습니다.");
        			setStatus(0);
        		} else {
        			setMessage("참가신청 되었습니다.");
        			setStatus(1);
	            }
	        	
	        }catch(Exception e) {
	            Logger.err.println( info.getSession( "ID" ), this, "setratbdins1_1 Exception e =" + e.getMessage() );
	            setStatus(0);
	        }
	        return getSepoaOut();
	    }
	 
	 public SepoaOut setVendorReg_BACK(String[][] dataRQSE, String RA_TYPE1) {
	        int rtn = 0;
	        String flag = "";
	        String check = "";
	        try {
	        	
	        	//지명경쟁일때
	        	if("NC".equalsIgnoreCase(RA_TYPE1)){
//	            	rtn = et_setJoinVendorUpd(dataRQSE);
	            }else{
	            	
	            	flag = checkVendorReg(dataRQSE);
	            	
	            	SepoaFormater wf = new SepoaFormater(flag);
	            	
	            	check = wf.getValue(0, 0);
	            	
	            	/*
	            	 * 일반경쟁에서 참가신청서를 현업이 작성하고 참가여부를 선택할 경우
	            	 * 카운트가 0일 때 참가신청서가 존재하지 않아 값을 insert
	            	 * 0이 아니면 참가신청서는 존재 참가여부만 update
	            	 */
	            	if("0".equals(check)){ 
//	            		rtn = et_setJoinVendorReg(dataRQSE); 
	            	}else{
//	            		rtn = et_setJoinVendorUpd(dataRQSE);
	            	}
	            	
	            }
	        	
	        	if (rtn < 0) { //오류 발생
     			setMessage(msg.getMessage("0036"));
     			setStatus(0);
     		} else {
     			setMessage("참가신청 되었습니다.");
     			//setMessage(msg.getMessage("0037"));
     			setStatus(1);
	            }
	        	
	        	/*
	        	flag = checkVendorReg(dataRQSE);
	        	
	        	SepoaFormater wf = new SepoaFormater(flag);
	        	
	        	check = wf.getValue(0, 0);
	        	if("0".equals(check)){
	        		
	        		rtn = et_setJoinVendorReg(dataRQSE);
	        		
	        		
	        		
	        		if (rtn < 0) { //오류 발생
	        			setMessage(msg.getMessage("0036"));
	        			setStatus(0);
	        		} else {
	        			setMessage("참가신청 되었습니다.");
	        			//setMessage(msg.getMessage("0037"));
	        			setStatus(1);
		            }
	        	}else{
	        		setMessage("등록된 참가신청서가 존재합니다.");
     			setStatus(1);
	        	}
	        	*/
	        }catch(Exception e) {
	            Logger.err.println( info.getSession( "ID" ), this, "setratbdins1_1 Exception e =" + e.getMessage() );
	            setStatus(0);
	        }
	        return getSepoaOut();
	    }
	 
	 
	 	/*
		 * 지명경쟁 참가신청등록(지명경쟁)
		 */
		private int et_setJoinVendorUpd(Map<String, String> gridInfo) throws Exception
	    {

	        ConnectionContext ctx = getConnectionContext();
	        SepoaSQLManager sm = null;
	        
	        SepoaXmlParser wxp = null;
	        int rtnIns = 0;
	        
	        try {
	        	
	        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        	sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
	        	rtnIns = sm.doUpdate(gridInfo);
	            
	        	Commit();
	        }
	        catch(Exception e) {
	            Rollback();
	            rtnIns = -1;
	            Logger.debug.println(info.getSession("ID"),this,"et_setJoinVendorUpd = " + e.getMessage());
	        }

	        return rtnIns;

	    }

	 private String checkVendorReg(String [][] dataRQSE) throws Exception{
			
		 String house_code = dataRQSE[0][2];
		 String company_code = dataRQSE[0][3];
		 String rfq_no = dataRQSE[0][4];
		 String rfq_count = dataRQSE[0][5];
		 String change_user_id = dataRQSE[0][6];
		 String vendor_code = dataRQSE[0][7];
			
		 ConnectionContext ctx = getConnectionContext();

	     String rtn = "";
	        
			try{
				
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", house_code);
				wxp.addVar("company_code", company_code);
				wxp.addVar("rfq_no", rfq_no);
				wxp.addVar("rfq_count", rfq_count);
				wxp.addVar("change_user_id", change_user_id);
				wxp.addVar("vendor_code", vendor_code);
				
				SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,wxp.getQuery());

				rtn = sm.doSelect((String[])null);

			}catch(Exception e) {
				Logger.err.println(userid,this,e.getMessage());
				throw new Exception(e.getMessage());
			}
			return rtn;
	}
	 
	 
	 /*
	 * 일반경쟁 참가신청등록
	 */
	private int et_setJoinVendorReg(Map<String, String> gridInfo) throws Exception
	    {

	        ConnectionContext ctx = getConnectionContext();
	        SepoaSQLManager sm = null;
	        String rtn="";
	        SepoaXmlParser wxp = null;
	        int rtnIns = 0;
	        String add_user_id = gridInfo.get("CHANGE_USER_ID");
	        
	        try {
	        	
	        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        		wxp.addVar("add_user_id", add_user_id);
	        	sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
	        	rtnIns = sm.doInsert(gridInfo);
	        	
	            Commit();
	        }
	        catch(Exception e) {
	            Rollback();
	            rtnIns = -1;
	            Logger.debug.println(info.getSession("ID"),this,"et_setJoinVendorReg = " + e.getMessage());
	        }

	        return rtnIns;

	    }

	/**
	 * 역경매입찰 >입찰 최소입찰금액
	 **/
		public SepoaOut getRaMinPrice(Map<String, String> data) {
			String rtn = "";

			try {
				
				data.put("house_code", house_code);
				rtn = et_getRaMinPrice(data);

				setStatus(1);
				setValue(rtn);

	            Commit();
			} catch(Exception e) {
				setStatus(0);
				setMessage(msg.getMessage("0003"));
				Logger.err.println( info.getSession( "ID" ), this, "setratbdins1_1 Exception e =" + e.getMessage() );
			}
			return getSepoaOut();
		}

	/**
	 * 역경매입찰 >입찰
	 **/
		private String et_getRaMinPrice(Map<String, String> header) throws Exception
		{	
	        String rtnStr = null;

		    SepoaXmlParser wxp = null;
			SepoaSQLManager sm = null;
			
		    try {
				ConnectionContext ctx = getConnectionContext();

				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
				rtnStr = sm.doSelect(header);

			} catch(Exception e) {
				Logger.err.println(info.getSession("ID"),this,e.getMessage());
			}
			
			return rtnStr;
		}


/**********************************************************************************************************************************************************/
/**********************************************************************************************************************************************************/



}