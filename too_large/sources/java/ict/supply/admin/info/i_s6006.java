/*
Title:             Partner Service Class  <p>
Description:       회사정보 Service Class  <p>
Copyright:         Copyright (c) <p>
Company:           ICOMPIA <p>
@author            shy<p>
@version           1.0.0
@Comment
*/

/**
======================================================================================================
FUNCTION NAME               DESCRIPTION
======================================================================================================


>>  사업자등록번호 존재여부 --- checkDupIrsNo, hico_bd_agree <<
- checkDupIrsNo             조회

>>  일반정보 --- hico_bd_lis0, hico_wk_ins <<
- getHicoBdLis0             조회
- insertHicoBdLis0          등록
- updateHicoBdLis0          수정

>>  공장현황 --- hico_bd_lis7  <<
- getHicoBdLis7             조회
- insertHicoBdLis7          등록
- deleteHicoBdLis7          삭제

>>  회사연혁 --- hico_bd_lis1  <<
- getHicoBdLis1             조회
- insertHicoBdLis1          등록
- deleteHicoBdLis1          삭제

>>  주요설비및대리점권 --- hico_bd_lis2  <<
- getHicoBdLis2             조회
- insertHicoBdLis2          등록
- deleteHicoBdLis2          삭제

>>  인허가및자격사항 --- hico_bd_lis3  <<
- getHicoBdLis3             조회
- insertHicoBdLis3          등록
- deleteHicoBdLis3          삭제

>>  취급품목 --- hico_bd_lis4  <<
- getHicoBdLis4             조회
- insertHicoBdLis4          등록
- deleteHicoBdLis4          삭제

>>  경영상태 --- hico_bd_lis5  <<
- getHicoBdLis5             조회
- insertHicoBdLis5          등록
- deleteHicoBdLis5          삭제

>>  담당자정보 --- hico_bd_lis6  <<
- getHicoBdLis6             조회
- insertHicoBdLis6          등록
- deleteHicoBdLis6          삭제

>>  일반정보 --- ven_pp_dis1 <<
- Getvenppdis1              조회


**/

package ict.supply.admin.info;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.commons.collections.MapUtils;

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

public class I_s6006 extends SepoaService
{
   String language = "";
   String serviceId = "I_s6006";

   Message msg = new Message(info, "STDCOMM");

   public I_s6006( String opt, SepoaInfo sinfo ) throws SepoaServiceException
   {
       super( opt, sinfo );
       setVersion( "1.0.0" );
   }

	/**
	* @Author     : 
	* @Description: checkDupIrsNo call
	* @Date   : 2004.03.17
	* @param : iris_no, resident_no, mode 
	**/
	public SepoaOut checkDupIrsNo(String irs_no, String resident_no, String mode) {
		
		String result;

		try {
				if(mode.equals("irs_no")){
					Logger.err.println("ihStone Step 001");
					result = SR_checkDupIrsNo(irs_no);
				}
				else{
					result = SR_checkDupResidentNo(resident_no);
				}
				setValue(result);
				setStatus(1);
				setMessage( "정상적으로 데이터가 조회되었습니다." );
				
		} catch(Exception e) {
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("조회중에 에러가 발생하였습니다.");
				Logger.err.println(this,e.getMessage());
		}
		
		return getSepoaOut();
	}

	
	
	
   	/**
   	* @methodName : SR_checkDupResidentNo
   	* @description : 사업자등록번호 중복체크
   	* @Author     : 
   	* @Description: SR_checkDupIrsNo call
   	* @Date   : 2010.02.23
   	* @param : iris_no, resident_no, mode
   	**/
   	
   	/* ICT 사용 */
   	private String SR_checkDupResidentNo(String resident_no) throws Exception, DBOpenException {
   		String result = null;
   		String house_code = info.getSession("HOUSE_CODE");
   		
   		try {
   			ConnectionContext ctx = getConnectionContext();

   			SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());

   			wxp.addVar("house_code", house_code);
   			wxp.addVar("resident_no", resident_no);
   			
   			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

   			result = sm.doSelect((String[])null);

   			if(result == null) throw new Exception("SQL Manager is Null");
   		
   		} catch(Exception e) {
   			throw new Exception("isDuplicateIrsNoExecute : " + e.getMessage());
   		}
   		return result;
   	}

   	
	/* ICT 사용 */
   	private String SR_checkDupIrsNo(String irs_no) throws Exception, DBOpenException {
   		String result = null;
   		String house_code = info.getSession("HOUSE_CODE");
   		
   		try {
   				ConnectionContext ctx = getConnectionContext();
   				
   				SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
   				
   				wxp.addVar("house_code", house_code);
   				wxp.addVar("irs_no", irs_no);
   				
   				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,wxp.getQuery());
   				
   				result = sm.doSelect((String[])null);
   				
   				if(result == null) throw new Exception("SQL Manager is Null");
   		
   		} catch(Exception e) {
   			throw new Exception("isDuplicateIrsNoExecute : " + e.getMessage());
   		}

   		return result;
   	}
   	
   	
   	/**
   	 * @Description : SgType 체크
   	 * @author : useonlyj
   	 * @date :2010-02-23
   	 * 
   	 * */
	public SepoaOut checkSgType(String irs_no) {
		String result;

		try {
			result = SR_checkSgType(irs_no);
			setValue(result);
			setStatus(1);
			setMessage( "정상적으로 데이터가 조회되었습니다." );

		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(this,e.getMessage());
		}

		return getSepoaOut();
	}

	private String SR_checkSgType(String irs_no) throws Exception, DBOpenException {
		String result = null;
        	String house_code = info.getSession("HOUSE_CODE");

        	try {
			  ConnectionContext ctx = getConnectionContext();
              SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
              wxp.addVar("irs_no", irs_no);
                  
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,wxp.getQuery());
			result = sm.doSelect((String[])null);
			if(result == null) throw new Exception("SQL Manager is Null");

	    	} catch(Exception e) {
			throw new Exception("SR_checkSgTypeNoExecute : " + e.getMessage());
		}
		return result;
	}
	
	public String parsingVendorCode(String vendor_code)throws Exception, DBOpenException {
		
		java.util.StringTokenizer st = new java.util.StringTokenizer(vendor_code,"::");
		String temp_vendor_code = st.nextToken();
		String flag="";
		String result="";
		if(st.hasMoreTokens()){
			flag = st.nextToken();
		}
		try{
			if(flag.equals("IRS_NO")){
				result=getVendorCode(temp_vendor_code);
				SepoaFormater wf = new SepoaFormater(result);
				if(wf.getRowCount()>0){temp_vendor_code=wf.getValue("VENDOR_CODE",0);}
			}
		}catch(Exception e){
			throw new Exception("isDuplicateIrsNoExecute : " + e.getMessage());
		}	
		return temp_vendor_code;
	}
	/*
	* 사업자 등록번호를 받아 vendor_code를 반환한다.
	*/
	public String getVendorCode(String vendor_code) throws Exception, DBOpenException {
		String result = null;
        String house_code = info.getSession("HOUSE_CODE");

        try {
            ConnectionContext ctx = getConnectionContext();

            SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("vendor_code", vendor_code);
			
			/*
            tSQL.append( " SELECT VENDOR_CODE FROM ICOMVNGL ");
            tSQL.append( " WHERE HOUSE_CODE = '"+house_code+"' ");
            tSQL.append( " AND IRS_NO = '" + vendor_code + "'");
			*/
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
            result = sm.doSelect((String[])null);
            if(result == null) throw new Exception("SQL Manager is Null");

        } catch(Exception e) {
            throw new Exception("isDuplicateIrsNoExecute : " + e.getMessage());
        }
        return result;
	}
	
	public SepoaOut getHicoBdLis0( String vendor_code,String year_c ){
        try
        {
            String rtn[] = null;
            String rtn1[] = null;
            String rtn2[] = null;
            String rtn3[] = null;
            String rtn4[] = null;
            String rtn5[] = null;
            String rtn6[] = null;
            String rtn7[] = null;
            String rtn8[] = null;
            String rtn9[] = null;
            String rtn10[] = null;
            String rtn11[] = null;
            String rtn12[] = null;
            
           	setStatus( 1 );
           	
			vendor_code = parsingVendorCode(vendor_code);
			
			rtn = SR_getHicoBdLis0( vendor_code );
            

            if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }

            rtn1 = SR_getHicoBdLis_1( vendor_code );
            if ( rtn1[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn1[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn1[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }

            rtn2 = SR_getHicoBdLis_2( vendor_code );
            if ( rtn2[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn2[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn2[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }

            rtn3 = SR_getHicoBdLis_3( vendor_code );
            if ( rtn3[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn3[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn3[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
            
             rtn4 = SR_getHicoBdLis_4( vendor_code );
            if ( rtn4[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn4[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn4[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
            
            rtn5 = SR_getHicoBdLis_5( vendor_code );
            if ( rtn5[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn5[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn5[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
            
            rtn6 = SR_getHicoBdLis_6( vendor_code );
            if ( rtn6[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn6[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn6[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
            
             rtn7 = SR_getHicoBdLis_7( vendor_code );
            if ( rtn7[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn7[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn7[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }

			rtn8 = SR_getHicoBdLis_8( vendor_code );
            if ( rtn8[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn8[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn8[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
            
            rtn9 = SR_getHicoBdLis_9( vendor_code );
            if ( rtn9[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn9[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn9[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
            
            rtn10 = SR_getHicoBdLis_10( vendor_code );
            if ( rtn10[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn10[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn10[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
            
             rtn11 = SR_getHicoBdLis_11( vendor_code );
            if ( rtn11[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn11[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn11[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }

			 rtn12 = SR_getHicoBdLis_12( vendor_code , year_c);
            if ( rtn12[ 1 ] != null ){  //오류가 발생하였다.
                setMessage( rtn12[ 1 ] );
                setStatus( 0 );
            }else{
                setValue(rtn12[0]);
                setMessage( "정상적으로 데이터가 조회되었습니다." );
            }
			
        }catch(Exception e){
            setStatus(0);
            setMessage("조회중에 에러가 발생하였습니다.");
            Logger.err.println(info.getSession( "ID" ),this,e.getMessage());
        }
        return getSepoaOut();
    }



    /**
    * <code>
    * 업체 일반정보 조회
    *<p>
    *   업체일반정보 조회
    *<p>
    * @since   v1.0, 2004/02/26
    * @author  SHYI(viruslsh@empal.com)
    * @param   args
    * @return  head 정보를 담은 배열 / Error Meassage
    * @throws
    * </code>
    */
    private String[] SR_getHicoBdLis0( String vendor_code ) throws Exception
    {
        String rtn[] = new String[ 2 ];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        String sysyear = String.valueOf(SepoaDate.getYear());//.toString();

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);

		/*
        sql.append("	SELECT																																														\n");
        sql.append("		V.VENDOR_CODE																																										\n");
        sql.append("		, dbo.GETICOMCODE2(V.HOUSE_CODE, 'M071',V.VENDOR_COND) AS VENDOR_COND	\n");
        sql.append("		,V.VENDOR_NAME_LOC,	V.VENDOR_NAME_ENG,													\n");
        sql.append("		(SELECT BANK_NAME_LOC FROM ICOMVNBK WHERE HOUSE_CODE = '"+house_code+"' AND VENDOR_CODE = '"+vendor_code+"') AS BANK_NAME_LOC\n");
        sql.append("		,V.IRS_NO, V.BUSINESS_TYPE																\n");
        sql.append("		,V.INDUSTRY_TYPE, V.FOUNDATION_DATE														\n");
        sql.append("		,V.COMPANY_REG_NO, V.MAIN_PRODUCT														\n");
        sql.append("		,D.HOMEPAGE, D.ZIP_CODE																	\n");
        sql.append("		,D.ADDRESS_LOC, D.CEO_NAME_LOC															\n");
        sql.append("		,SUBSTRing(V.RESIDENT_NO,1,6) AS RESIDENT_NO, D.PHONE_NO1									\n");
        sql.append("		,D.FAX_NO, D.PHONE_NO2, D.EMAIL 														\n");
        sql.append("		,V.EBIZ_FLAG,	V.CREDIT_RATING ,V.START_DATE   		     							\n");        
      
        sql.append("		,V.ATTACH_NO, V.ATTACH_NO2																\n");
        sql.append("		,(SELECT ISNULL(COUNT(*),0) FROM ICOMATCH WHERE DOC_NO = V.ATTACH_NO) AS ATTACH_COUNT		\n");
        sql.append("		,(SELECT ISNULL(COUNT(*),0) FROM ICOMATCH WHERE DOC_NO = V.ATTACH_NO2) AS ATTACH_COUNT2	\n");
        sql.append("		,dbo.GETICOMCODE1( V.HOUSE_CODE,'M086',MAIN_PRODUCT) AS TMAIN_PRODUCT						\n");
        sql.append("		,dbo.GETICOMBACP2( V.HOUSE_CODE,'CC','P',V.CTRL_CODE) CTRL_NAME								\n");
        sql.append("		,V.CTRL_CODE, V.VENDOR_COND AS VENDOR_COND_O											\n");
        sql.append("		,( SELECT ISNULL(F_CAPITAL1,0) / 100 FROM ICOMVNFC               	\n");	
		sql.append("		WHERE HOUSE_CODE = V.HOUSE_CODE                                 \n");
		sql.append("		AND VENDOR_CODE = V.VENDOR_CODE                                 \n");
		sql.append("		AND YEAR = ( SELECT MAX(YEAR) FROM ICOMVNFC                     \n");
		sql.append("					WHERE HOUSE_CODE = V.HOUSE_CODE                     \n");
		sql.append("					AND VENDOR_CODE = V.VENDOR_CODE ) ) AS F_CAPITAL1  	\n");
        sql.append("	FROM																\n");
        sql.append("		ICOMVNGL V, ICOMADDR D											\n");//ICOMVNET T, ICOMVNBK B,, ICOMVNFC F
        sql.append("	WHERE																\n");
        sql.append("		V.HOUSE_CODE = D.HOUSE_CODE										\n");
        sql.append("		AND V.VENDOR_CODE = D.CODE_NO									\n");
        sql.append("		AND V.HOUSE_CODE = '"+house_code+"'								\n");
        sql.append("		AND V.VENDOR_CODE = '"+vendor_code+"'							\n");
        sql.append("		AND D.CODE_TYPE = '2'											\n");
        */
        
        try {                                                                                   
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());                           
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }


	private String[] SR_getHicoBdLis_1( String vendor_code ) throws Exception
    {
        String rtn[] = new String[ 2 ];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		/*
        sql.append(" SELECT TEMP.SEQ, ISNULL(VNET.ETC_QTY,0) AS ETC_QTY,			\n");
        sql.append(" 	ISNULL(VNET.ETC_AMT,0) AS ETC_AMT,                			\n");
        sql.append(" 	ISNULL(VNET.ETC_QTY,0) + ISNULL(VNET.ETC_AMT,0) AS ETC_SUM,   \n");
        sql.append(" 	ISNULL(VNET.ETC_PERCENT,0) AS ETC_PERCENT          		\n");
		sql.append(" from (select '01' seq union all select '02' seq union all select '03' seq union all select '04' seq union all select '05' seq union all select '06' seq) TEMP left outer join ICOMVNET VNET \n");
		sql.append(" 	on temp.seq = vnet.seq and vnet.house_code = '"+house_code+"' and vnet.vendor_code = '"+vendor_code+"' and vnet.etc_info = '01' \n");
		sql.append(" ORDER BY TEMP.SEQ                                  \n");
		 */
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }

    private String[] SR_getHicoBdLis_2( String vendor_code ) throws Exception
    {
        String rtn[] = new String[ 2 ];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		/*
        sql.append(" SELECT '03' AS ETC_INFO, TEMP.SEQ, VNET.ETC_TEXT,	\n");
        sql.append(" 	ISNULL(VNET.ETC_AMT,0) AS ETC_AMT,                	\n");
        sql.append(" 	ISNULL(VNET.ETC_PERCENT,0) AS ETC_PERCENT          \n");
        sql.append(" from (select '01' seq union all select '02' seq union all select '03' seq ) TEMP left outer join ICOMVNET VNET \n");
        sql.append(" 	on temp.seq = vnet.seq and vnet.house_code = '"+house_code+"' and vnet.vendor_code = '"+vendor_code+"' and vnet.etc_info = '03' \n");
		sql.append(" UNION ALL											\n");
		sql.append(" SELECT '04' AS ETC_INFO, TEMP.SEQ, VNET.ETC_TEXT,	\n");
        sql.append(" 	ISNULL(VNET.ETC_AMT,0) AS ETC_AMT,                	\n");
        sql.append(" 	ISNULL(VNET.ETC_PERCENT,0) AS ETC_PERCENT          \n");
        sql.append(" from (select '01' seq union all select '02' seq union all select '03' seq ) TEMP left outer join ICOMVNET VNET \n");
        sql.append(" 	on temp.seq = vnet.seq and vnet.house_code = '"+house_code+"' and vnet.vendor_code = '"+vendor_code+"' and vnet.etc_info = '04' \n");
		*/
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }

    private String[] SR_getHicoBdLis_3( String vendor_code ) throws Exception
    {
        String rtn[] = new String[ 2 ];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		/*
        sql.append(" SELECT TEMP.SEQ, VNET.ETC_TEXT,			\n");
        sql.append(" 	ISNULL(VNET.ETC_QTY,0) AS ETC_QTY,         \n");
        sql.append(" 	ISNULL(VNET.ETC_AMT,0) AS ETC_AMT,         \n");
        sql.append(" 	ISNULL(VNET.ETC_PERCENT,0) AS ETC_PERCENT  \n");
        sql.append(" from (select '01' seq union all select '02' seq union all select '03' seq ) TEMP left outer join ICOMVNET VNET \n");
        sql.append(" 	on temp.seq = vnet.seq and vnet.house_code = '"+house_code+"' and vnet.vendor_code = '"+vendor_code+"' and vnet.etc_info = '02' \n");
		*/
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
    
    // 업체정보 추가 
    private String[] SR_getHicoBdLis_4( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		
		/*
		sql.append(" select date1,   title, remark,          \n");
        sql.append(" vendor_code, seq                        \n");
        sql.append(" from icomvnit                          \n");
        sql.append(" where house_code = '"+house_code+"'    \n");
        sql.append(" and vendor_code = '"+vendor_code+"'    \n");
        sql.append(" and info_type = 'CH'               \n");
        sql.append(" and status in ('C', 'R')               \n");
		*/       
	
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
    
	// 공장현황 추가 
	 private String[] SR_getHicoBdLis_5( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		
		/*
		sql.append(" select name_loc, zip_code,              \n");
        sql.append("    address_loc, plant_area,            \n");
        sql.append("    lease_flag, vendor_code, seq,       \n");
        sql.append("    phone_no, fax_no			        \n");
        sql.append(" from icomvnpl                          \n");
        sql.append(" where house_code = '"+house_code+"'    \n");
        sql.append(" and vendor_code = '"+vendor_code+"'    \n");
        sql.append(" and status in ('C', 'R')               \n");		       
		*/
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
	    
	// 주요설비 및 대리점권  추가 
	 private String[] SR_getHicoBdLis_6( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		/*
		sql.append(" select title, desc1, qty, date2,      	\n");
        sql.append("    date1, vendor_code, seq,      		\n");
        sql.append("    vendor_name_loc, country_name_loc	\n");
        sql.append(" from icomvnit                          \n");
        sql.append(" where house_code = '"+house_code+"'    \n");
        sql.append(" and vendor_code = '"+vendor_code+"'    \n");
        sql.append(" and info_type = 'FA'               	\n");
        sql.append(" and status in ('C', 'R')               \n");	       
		*/
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
    
    // 인허가 및 자격사항
	 private String[] SR_getHicoBdLis_7( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		
		/*
		sql.append(" select title, desc1, desc2, date1,     \n");
		sql.append("    date2, remark, vendor_code, seq     \n");
		sql.append(" from icomvnit                          \n");
		sql.append(" where house_code = '"+house_code+"'    \n");
		sql.append(" and vendor_code = '"+vendor_code+"'    \n");
		sql.append(" and info_type = 'QR'                   \n");
		sql.append(" and status in ('C', 'R')               \n");      
        */	       

        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
	
	 // 생산품목 추가
	 private String[] SR_getHicoBdLis_8( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		
		/*
		sql.append(" select desc1, desc2, unit_measure,      \n");
		sql.append("    capa, title, vendor_code, seq       \n");
		sql.append(" from icomvnit                          \n");
		sql.append(" where house_code = '"+house_code+"'    \n");
		sql.append(" and vendor_code = '"+vendor_code+"'    \n");
		sql.append(" and info_type = 'PI'					\n");
		sql.append(" and status in ('C', 'R')               \n");     
        */	       

        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
		
	
	// 소싱그룹정보
	 private String[] SR_getHicoBdLis_9( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("vendor_code", vendor_code);
		
		/*
		sql.append(" SELECT                                                             \n");
 		sql.append("			B.SG_NAME                                              \n");
 		sql.append("			,A.REQ_DATE                                             \n");
 		sql.append("			,A.SIGN_DATE                                            \n");
		sql.append(" 	FROM 	ICOMSGVN A, ICOMSGCN B, ICOMLUSR C                  	\n");
		sql.append(" 	WHERE   A.SG_REFITEM = B.SG_REFITEM                             \n");
		sql.append(" 	AND     A.HOUSE_CODE = B.HOUSE_CODE                             \n");
		sql.append(" 	AND     B.HOUSE_CODE *= C.HOUSE_CODE                          	\n");
		sql.append(" 	AND		B.LEVEL_COUNT = '3'                                     \n");
		sql.append("    AND     B.SG_CHARGE *= C.USER_ID                              	\n");
		sql.append("    AND     A.VENDOR_CODE = '"+vendor_code+"'						\n");
  	     */  

        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }	

	// 담당자정보
	 private String[] SR_getHicoBdLis_10( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code", house_code);
        wxp.addVar("vendor_code", vendor_code);
		
        /*
		sql.append(" select company_code, user_name,                                            \n");
		sql.append("     division, position, 					                                \n");
		sql.append("     phone_no, email, mobile_no, fax_no,                                    \n");
		sql.append("     vendor_code, seq,                                                      \n");
		sql.append("     dbo.geticomcode2('"+house_code+"','C002',position) as tposition,           \n");
		sql.append("     dbo.geticomcode2('"+house_code+"','M106',position) as tmanager_position    \n");
		sql.append("     from icomvncp                                                          \n");
		sql.append("     where house_code = '"+house_code+"'                                    \n");
		sql.append("     and vendor_code = '"+vendor_code+"'                                    \n");
		sql.append("     and status in ('C', 'R')                                               \n");
  	     */  
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
    
    // 은행정보
	 private String[] SR_getHicoBdLis_11( String vendor_code ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code", house_code);
        wxp.addVar("vendor_code", vendor_code);
		    /*
		 sql.append(" select                                  									\n");
         sql.append("      dbo.getIcomcode2('"+house_code+"','M001',BANK_COUNTRY)AS BANK_COUNTRY 	\n");
         sql.append("     ,BANK_NAME_LOC                      									\n");
         sql.append("     ,BRANCH_NAME_LOC                    									\n");
         sql.append("     ,BANK_ACCT                          									\n");
         sql.append("     ,DEPOSITOR_NAME                     									\n");
         sql.append(" from icomvnbk                           									\n");
         sql.append(" where house_code = '"+house_code+"'     									\n");
         sql.append(" and vendor_code = '"+vendor_code+"'		        						\n");       
         */
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
	
	// 경영정보
	 private String[] SR_getHicoBdLis_12( String vendor_code,String year_c ) throws Exception
    {
        String rtn[] = new String[2];
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession( "ID" );

        SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code", house_code);
        wxp.addVar("vendor_code", vendor_code);
        wxp.addVar("year_c", year_c);
       
		 /*   
		sql.append(" select year															\n");
		sql.append(" 	,s_sale_amt                                                         \n");
		sql.append(" 	,s_profit1                                                          \n");
		sql.append(" 	,s_profit3                                                          \n");
		sql.append(" 	,s_profit4                                                          \n");
		sql.append(" 	,f_property11+f_property12 as f_property_1 --고정자산               \n");
		sql.append(" 	,f_property11                                                       \n");
		sql.append(" 	,f_property12                                                       \n");
		sql.append(" 	,f_property21+f_property22+f_property23 as f_property_2 --유동자산  \n");
		sql.append(" 	,f_property21                                                       \n");
		sql.append(" 	,f_property22                                                       \n");
		sql.append(" 	,f_property23                                                       \n");
		sql.append(" 	,f_property24                                                       \n");
		sql.append(" 	,f_property25                                                       \n");
		sql.append(" 	,f_property11+f_property12+f_property21+f_property22+f_property23 as f_property_12 --자산총계(고정자산+유동자산)\n");
		sql.append(" 	,f_debt11																				\n");
		sql.append(" 	,f_debt21                                                                               \n");
		sql.append(" 	,f_debt22                                                                               \n");
		sql.append(" 	,f_debt23                                                                               \n");
		sql.append(" 	,f_debt11+f_debt21 as f_debt_1 -- 부채총계(유동부채+고정부채)                           \n");
		sql.append(" 	,f_capital1                                                                             \n");
		sql.append(" 	,f_capital2                                                                             \n");
		sql.append(" 	,f_capital3                                                                             \n");
		sql.append(" 	,f_capital4                                                                             \n");
		sql.append(" 	,f_capital5                                                                             \n");
		sql.append(" 	,f_capital1+f_capital2+f_capital4 as f_capital124 --자본총계(자본금+자본잉여금+자본조정)\n");
		sql.append(" 	,d_sale_amt                                                                             \n");
		sql.append(" 	,d_sale_amt/s_sale_amt*100 as d_sale_rate --당사의존도(직접거래/매출액*100)             \n");
		sql.append(" 	,i_sale_amt                                                                             \n");
		sql.append(" 	,i_sale_amt/s_sale_amt*100 as i_sale_rate                                               \n");
		sql.append(" 	,d_sale_amt+i_sale_amt as di_sale_amt --합계(직접거래+간접거래)                         \n");
		sql.append(" 	,(d_sale_amt+i_sale_amt)/s_sale_amt*100 as di_sale_rate                                 \n");
		sql.append("    ,vendor_code                            \n");
		sql.append(" from icomvnfc                              \n");
		sql.append(" where house_code = '"+house_code+"'        \n");
		sql.append(" and vendor_code = '"+vendor_code+"'        \n");
		sql.append(" and status in ('C', 'R')                   \n");
		sql.append(" and year between '"+year_c+"'-2 and '"+year_c+"'   \n");
		
		sql.append(" order by year desc                  		\n");     
         */
        try {
            sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            rtn[0] = sm.doSelect((String[])null);

            if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    }catch(Exception e) {
            Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        rtn[ 1 ] = e.getMessage();
    }
        return rtn;
    }
	
	
	    /**
	   * Author     : SHYI
	   * Description: SR_getAddrList call
	   * Add Date   : 2005.06.22
	   **/
	public SepoaOut getAddrList( String dong ){
		try
		{
			String rtn[] = null;
           		setStatus( 1 );

			rtn = SR_getAddrList( dong );

			if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
				setMessage( rtn[ 1 ] );
				setStatus( 0 );
			}else{
				setValue(rtn[0]);
	            		setMessage( "정상적으로 데이터가 조회되었습니다." );
			}

		}catch(Exception e){
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(info.getSession( "ID" ),this,e.getMessage());
		}
		return getSepoaOut();
	}



	/**
    * <code>
    * 우편번호 조회
    *<p>
    * 	우편번호 조회
    *<p>
    * @since   v1.0, 2004/02/22
    * @author  SHYI(viruslsh@empal.com)
    * @param   args
    * @return  head 정보를 담은 배열 / Error Meassage
    * @throws
    * </code>
    */
	private String[] SR_getAddrList( String dong ) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );
		
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("street1", dong);
		wxp.addVar("street2", dong);
		
		try {
			sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
			rtn[0] = sm.doSelect((String[])null);

			if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

   		}catch(Exception e) {
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
       		rtn[ 1 ] = e.getMessage();
   		}
		return rtn;
	}

	
	
	/* ICT 사용 */
	public SepoaOut getScrItem( String vendor_code){
		try
		{
			String rtn[] = null;
            
			setStatus( 1 );

			rtn = et_getScrItem( vendor_code );

			if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
				setMessage( rtn[ 1 ] );
				setStatus( 0 );
			}else{
				setValue(rtn[0]);
	            		setMessage( "정상적으로 데이터가 조회되었습니다." );
			}

		}catch(Exception e){
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(info.getSession( "ID" ),this,e.getMessage());
		}
		return getSepoaOut();
	}


	/* ICT 사용 */
	private String[] et_getScrItem( String vendor_code ) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;
		
		String user_id = info.getSession( "ID" );
		String house_code = info.getSession( "HOUSE_CODE" );
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", vendor_code);
		wxp.addVar("vendor_code", vendor_code);
		
		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//.toString());
			rtn[0] = sm.doSelect((String[])null);

			if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

    		}catch(Exception e) {
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
        		rtn[ 1 ] = e.getMessage();
    		}
		return rtn;
	}

	/* ICT 사용 */
	public SepoaOut getHicoBdLis3( Map<String, String> header  )
	{
       try
       {
           String rtn[] = null;
           setStatus( 1 );

           rtn = SR_getHicoBdLis3( header );
           if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
               setMessage( rtn[ 1 ] );
               setStatus( 0 );
           }

           setValue( rtn[ 0 ] );
       }
       catch( Exception e ){
           setStatus( 0 );
           setMessage( e.getMessage() );
           
       }
       return getSepoaOut();
   }

	
	
	/*품질인증  조회*/
	/* ICT 사용 */
   private String[] SR_getHicoBdLis3( Map<String, String> header ) throws Exception
   {
       String rtn[] = new String[ 2 ];
       ConnectionContext ctx = getConnectionContext();
       String house_code = info.getSession( "HOUSE_CODE" );
       String rtnSql = "";

       SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       wxp.addVar("house_code",house_code);
       wxp.addVar("vendor_code",header.get("vendor_code"));

       try
       {
           SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
           rtn[ 0 ] = sm.doSelect((String[])null);
       }
       catch(Exception e){
           Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
           rtn[ 1 ] = e.getMessage();
       }
       finally{}

       return rtn;
   }   //

   
   /* 품질인증 등록 , 삭제 */
   /* ICT 사용 */
   public SepoaOut insertHicoBdLis3( Map<String, Object> data){
       	String rtn[] = null;
       	int rtn1 = 0;
       
       	List<Map<String, String>> 	grid 		= null;
       	Map<String, String> 		gridInfo	= null;
       	Map<String, String> 	  	header		= null;       
       
       	try
       	{
   			header = MapUtils.getMap(data, "headerData");   
   			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
   			
   			if(grid != null && grid.size() > 0){
   				for(int i = 0 ; i < grid.size() ; i++){
   					gridInfo = grid.get(i);
   					
   					gridInfo.put("vendor_code", header.get("vendor_code"));
   					gridInfo.put("date1", gridInfo.get("date1").replaceAll("/", ""));
   					gridInfo.put("date2", gridInfo.get("date2").replaceAll("/", ""));
   					
   					if("I".equals(gridInfo.get("FLAG"))){
   						rtn = SR_insertHicoBdLis3( gridInfo);
   					}else{
   						rtn1 = SR_updateHicoBdLis3(gridInfo);
   					}
   				}
   			}

   			setMessage("저장되었습니다.");
   			setValue( "Update Row=" + rtn1 );
   			setStatus( 1 );

   			if (rtn1 == 0 && rtn != null && rtn[ 1 ] != null ){
   				setMessage( rtn[ 1 ] );
   				setStatus( 0 );
   			}
       	}
       	catch ( Exception e ){
       		Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
       		setStatus( 0 );
       	}
       	return getSepoaOut();
   	}
	
   /* ICT 사용 */
   private int SR_updateHicoBdLis3(Map<String, String> gridInfo) throws Exception
	{
   		int rtn = 0;
   		ConnectionContext ctx = getConnectionContext();
   		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		SepoaSQLManager sm = null;

    	try
    	{
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("add_date", add_date);
			wxp.addVar("add_time", add_time);
			wxp.addVar("user_id", user_id);

			gridInfo.put("house_code", house_code);
			
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
			sm.doUpdate(gridInfo);

			Commit();
	    }
    	catch(Exception e)
    	{
			throw new Exception("et_setVendorProject:"+e.getMessage());
	    }
    	finally
    	{
			//Release();
		}
		return rtn;
	}
	
/**
 * @title : 품질인증 등록 , 삭제 
 * */
   public SepoaOut updateSgvn( String sum_score , String vendor_sg_refitem)
   {
       int rtn1 = 0;
       try
       {
		   //rtn1 = SR_updateSgvn(sum_score,vendor_sg_refitem);
		   
		   setMessage("저장되었습니다.");
           setValue( "Update Row=" + rtn1 );
           setStatus( 1 );

           if (rtn1 == 0  ){
               setStatus( 0 );
           }
       }
       catch ( Exception e ){
           Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
           setStatus( 0 );
       }
       return getSepoaOut();
   }
   private int SR_updateSgvn(String sum_score,String vendor_sg_refitem) throws Exception
	{
  		int rtn = 0;
  		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		SepoaSQLManager sm = null;

   	try
   	{

   		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("user_id", user_id);
		wxp.addVar("sum_score",sum_score);
		wxp.addVar("vendor_sg_refitem",vendor_sg_refitem);	

			int upd_rtn = 0;
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
			upd_rtn = sm.doUpdate((String[][])null,null);
			if(upd_rtn<1)
				throw new Exception("no update icomvncp");
			rtn = upd_rtn;
			Commit();
	    }
   	catch(Exception e)
   	{
			throw new Exception("et_setVendorProject:"+e.getMessage());
	    }
   	finally
   	{
			//Release();
		}
		return rtn;
	}
   public SepoaOut updateSgvn1(String vendor_sg_refitem)
   {
       int rtn1 = 0;
       try
       {
		   //rtn1 = SR_updateSgvn1(vendor_sg_refitem);
		   
		   setMessage("저장되었습니다.");
           setValue( "Update Row=" + rtn1 );
           setStatus( 1 );

           if (rtn1 == 0  ){
               setStatus( 0 );
           }
       }
       catch ( Exception e ){
           Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
           setStatus( 0 );
       }
       return getSepoaOut();
   }
   private int SR_updateSgvn1(String vendor_sg_refitem) throws Exception
	{
  		int rtn = 0;
  		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		SepoaSQLManager sm = null;

   	try
   	{

   		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("user_id", user_id);
		wxp.addVar("vendor_sg_refitem",vendor_sg_refitem);	

			int upd_rtn = 0;
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
			upd_rtn = sm.doUpdate((String[][])null,null);
			if(upd_rtn<1)
				throw new Exception("no update icomvncp");
			rtn = upd_rtn;
			Commit();
	    }
   	catch(Exception e)
   	{
			throw new Exception("et_setVendorProject:"+e.getMessage());
	    }
   	finally
   	{
			//Release();
		}
		return rtn;
	}

   /* 품질인증 등록 */
   /* ICT 사용 */
   private String[] SR_insertHicoBdLis3( Map<String, String> gridInfo ) throws Exception
   {
       String returnString[] = new String[ 2 ];
       ConnectionContext ctx = getConnectionContext();
    
       String house_code =info.getSession("HOUSE_CODE")  ;
       String company_code =info.getSession("COMPANY_CODE");
       //String language =info.getSession("LANGUAGE");

       int rtnIns = 0;
       SepoaSQLManager sm = null;


       try
       {
    	   SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
           wxp.addVar("house_code", 	house_code);
           wxp.addVar("vendor_code", 	gridInfo.get("vendor_code"));
           wxp.addVar("user_id",		info.getSession("ID"));
           wxp.addVar("name_loc", 		info.getSession("NAME_LOC"));
           wxp.addVar("name_eng", 		info.getSession("NAME_ENG"));
           wxp.addVar("dept",			info.getSession("DEPT"));
               
           sm = new SepoaSQLManager( info.getSession("ID"), this, ctx,wxp.getQuery());// sql.toString() );
           rtnIns = sm.doInsert( gridInfo );

           Commit();
       }
       catch( Exception e )
       {
           Rollback();
           returnString[ 1 ] = e.getMessage();
       } finally{}

       return returnString;
   }  //



   /* ICT 사용 */
   public SepoaOut deleteHicoBdLis3( Map<String, Object> data){
       String rtn = null;
      	List<Map<String, String>> 	grid 		= null;
      	Map<String, String> 		gridInfo	= null;
      	Map<String, String> 	  	header		= null;              
       
       try
       {
    	   
  			header = MapUtils.getMap(data, "headerData");   
  			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			rtn = SR_deleteHicoBdLis3(header, grid);

           setStatus( 1 );
           
           
           
           if ( rtn.length() > 0 ){

               setMessage( rtn );
               setStatus( 0 );
           }
       }
       catch ( Exception e )
       {
    	   
           setStatus( 0 );
           setMessage( e.getMessage() );
           Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
       }
       return getSepoaOut();
   }

   /* 품질인증 삭제 */
   /* ICT 사용 */
   private String SR_deleteHicoBdLis3(Map<String, String> header, List<Map<String, String>> grid) throws Exception
   {
       String returnString = "";
       ConnectionContext ctx = getConnectionContext();

       String house_code =info.getSession("HOUSE_CODE")  ;
       //String company_code =info.getSession("COMPANY_CODE");
       //String language =info.getSession("LANGUAGE");

       //String rtnSql = "";
       int rtnIns = 0;
       SepoaSQLManager sm = null;
       String seq = "";

       try
       {
    	   
    	   SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    	   wxp.addVar("house_code"	, house_code);
    	   wxp.addVar("vendor_code", header.get("vendor_code"));
    	   wxp.addVar("mode2"		, "QR");
    	   
    	   
    	   if(grid != null && grid.size() > 0){
    		   Map <String, String> gridInfo = null;
    		   for(int i = 0 ; i < grid.size() ; i++){
    			   gridInfo = grid.get(i);
    			   gridInfo.put("vendor_code", header.get("vendor_code"));
    			   sm = new SepoaSQLManager( info.getSession( "ID" ), this, ctx,wxp.getQuery());// sql.toString() );
    			   rtnIns = sm.doUpdate(gridInfo);
    		   }
    	   }
    	   Commit();
       }
       catch( Exception e )
       {
    	   
    	   returnString = e.getMessage();
           Rollback();
       } finally{}
       
       
       
       return returnString;
   }

   public SepoaOut getItemInfo( String vendor_code, String mode  )
  {
      try
      {
          String rtn[] = null;
          setStatus( 1 );

          rtn = SR_getItemInfo( vendor_code , mode);
          if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
              setMessage( rtn[ 1 ] );
              Logger.debug.println( info.getSession( "ID" ), this, "_________ " + rtn[ 1 ] );
              setStatus( 0 );
          }

          setValue( rtn[ 0 ] );
      }
      catch( Exception e ){
          setStatus( 0 );
          setMessage( e.getMessage() );
          Logger.err.println( info.getSession("ID"), this, e.getMessage() );
      }
      return getSepoaOut();
  }
/**
  @Method Name :신규업체 등록 서비스 조회 
  @작성자  : shy
  @작성일  : 2004.02.25
  @작업내용: 
  @author useonlyj
**/
  private String[] SR_getItemInfo( String vendor_code ,String mode) throws Exception
  {
      String rtn[] = new String[ 2 ];
      ConnectionContext ctx = getConnectionContext();
      String house_code = info.getSession( "HOUSE_CODE" );
      String company_code = info.getSession( "COMPANY_CODE" );
      String rtnSql = "";
      SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("vendor_code", vendor_code);
		wxp.addVar("mode", mode);


      try
      {
          SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
          rtn[ 0 ] = sm.doSelect((String[]) null );
      }
      catch(Exception e){
          Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
          rtn[ 1 ] = e.getMessage();
      }
      finally{}

      return rtn;
  }   //

  public SepoaOut setItemInfo( String vendor_code, String[][] pSetData ,String[][] pSetData2 , String mode2)
  {
      int rtn1 = 0;
      try
      {
      	   rtn1 = SR_setItemInfo(vendor_code,pSetData, pSetData2, mode2);
		   
		   setMessage("저장되었습니다.");
          setValue( "Update Row=" + rtn1 );
          setStatus( 1 );
          
      }
      catch ( Exception e ){
          Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
          setStatus( 0 );
      }
      return getSepoaOut();
  }
  	/**
  	 * @description : 신규아이디 신청 - 서비스 등록
  	 * @date : 2010-03-09
  	 * @author : useonlyj 
  	 * */
	private int SR_setItemInfo(String vendor_code, String[][] ins_data, String[][] upd_data, String mode2) throws Exception
	{
  		int rtn = 0;
  		ConnectionContext ctx = getConnectionContext();
  		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		SepoaSQLManager sm = null;

   	try
   	{

   		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_update");
		wxp.addVar("add_date",	add_date);
		wxp.addVar("add_time", add_time);
		wxp.addVar("user_id",	user_id);
		wxp.addVar("mode2", mode2);

		String[] type_upd = {"S","S","S","S","N",
					 			"S","S","S","S","S","S", "S","S","S","S"};
			SepoaXmlParser wxp_insert = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_insert");
			wxp_insert.addVar("mode2", mode2);
			wxp_insert.addVar("house_code", house_code);
			wxp_insert.addVar("vendor_code",vendor_code);
			wxp_insert.addVar("add_date",	add_date);
			wxp_insert.addVar("add_time", add_time);
			wxp_insert.addVar("user_id",	user_id);
			
			String[] type_ins = {"S","S","S","S","S",
					 			"S","N","S","S","S","S","S","S","S"};

			int upd_rtn = 0;
			int ins_rtn = 0;
			if(upd_data.length > 0)
			{
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
				upd_rtn = sm.doUpdate(upd_data, type_upd);
				if(upd_rtn<1)
					throw new Exception("no update icomvnit");
			}
			if(ins_data.length > 0)
			{
				for(int i = 0 ; i < ins_data.length ; i++){
					String[][] setData = {ins_data[i]};
					sm = new SepoaSQLManager(user_id,this,ctx,wxp_insert.getQuery());//tSQL_ins.toString());
					ins_rtn = sm.doUpdate(setData, type_ins);
					if(ins_rtn<1)
						throw new Exception("no insert icomvnit");
					else
						Commit();
				}                                            
			}
			rtn = upd_rtn+ins_rtn;
			Commit();
	    }
   	catch(Exception e){
   		Rollback();
		throw new Exception("SR_setItemInfo:"+e.getMessage());
   	}
   	finally
   	{
			//Release();
	}
		return rtn;
	}
	/**
	   * Author     : SHYI
	   * Description: SR_getAddrList call
	   * Add Date   : 2005.06.22
	   * @description : Maker code 검색
	   * @date : 2010-03-09
	   * @author : useonlyj
	   **/
	public SepoaOut getCodeList( String type, String code, String text ){
		try
		{
			String rtn[] = null;
          setStatus( 1 );

			rtn = SR_getCodeList( type, code, text );

			if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
				setMessage( rtn[ 1 ] );
				setStatus( 0 );
			}else{
				setValue(rtn[0]);
	            setMessage( "정상적으로 데이터가 조회되었습니다." );
			}

		}catch(Exception e){
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(info.getSession( "ID" ),this,e.getMessage());
		}
		return getSepoaOut();
	}

	/**
   * <code>
   * 지역코드조회
   * @since   v1.0, 2004/02/22
   * @author  SHYI(viruslsh@empal.com)
   * @param   args
   * @return  head 정보를 담은 배열 / Error Meassage
   * @throws
   * </code>
   */
	private String[] SR_getCodeList( String type, String code, String text ) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );
		
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("type", type);
		wxp.addVar("house_code",house_code);
		wxp.addVar("code",code);
		wxp.addVar("text",text);
		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
			rtn[0] = sm.doSelect((String[])null);

			if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

  		}catch(Exception e) {
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
      		rtn[ 1 ] = e.getMessage();
  		}
		return rtn;
	}

  	public SepoaOut isSgExist( String vendor_code, String sg_refitem ){
		try
		{
			String rtn[] = null;
           		setStatus( 1 );

			rtn = SR_isSgExist( vendor_code, sg_refitem );

			if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
				setMessage( rtn[ 1 ] );
				setStatus( 0 );
			}else{
				setValue(rtn[0]);
	            		setMessage( "정상적으로 데이터가 조회되었습니다." );
			}

		}catch(Exception e){
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(info.getSession( "ID" ),this,e.getMessage());
		}
		return getSepoaOut();
	}



	private String[] SR_isSgExist( String vendor_code, String sg_refitem ) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code",	house_code);
		wxp.addVar("vendor_code",	vendor_code);
		wxp.addVar("sg_refitem", 	sg_refitem);
		
		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
			rtn[0] = sm.doSelect((String[])null);

			if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

   		}catch(Exception e) {
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
       		rtn[ 1 ] = e.getMessage();
   		}
		return rtn;
	}
	
	/* ICT 사용 */
	public SepoaOut isSgExist2( String vendor_code){
		try
		{
			String rtn[] = null;
           		setStatus( 1 );

			rtn = SR_isSgExist2( vendor_code);

			if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
				setMessage( rtn[ 1 ] );
				setStatus( 0 );
			}else{
				setValue(rtn[0]);
	            setMessage( "정상적으로 데이터가 조회되었습니다." );
			}

		}catch(Exception e){
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(info.getSession( "ID" ),this,e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private String[] SR_isSgExist2( String vendor_code) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code",	house_code);
		wxp.addVar("vendor_code",	vendor_code);
		
		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
			rtn[0] = sm.doSelect((String[])null);

			if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

   		}catch(Exception e) {
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
       		rtn[ 1 ] = e.getMessage();
   		}
		return rtn;
	}
	
	public SepoaOut getVendorSgNumber( String s_vendor_code ){
        try{
            String rtn = SR_getVendorSgNumber( s_vendor_code );
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
	}
	
	/**
	* Author     : SHYI
	* Description: SR_getScreenList call
	* Add Date   : 2005.06.22
	**/
	public SepoaOut getScreenItem( String s_factor_refitem ){
        try{
            String rtn = SR_getScreenItem( s_factor_refitem );
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
	}
	
	/**
	* Author     : SHYI
	* Description: SR_getScreenList call
	* Add Date   : 2005.06.22
	**/
	public SepoaOut getScreenSumValue( String s_factor_refitem , String s_template_refitem , String sVendor_sg_refitem){
        try{
            String rtn = SR_getScreenSumValue( s_factor_refitem ,s_template_refitem,sVendor_sg_refitem);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
	}

	private String SR_getVendorSgNumber( String s_vendor_code ) throws Exception{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("s_vendor_code",s_vendor_code);
//		
//		StringBuffer sql = new StringBuffer();
//
//		sql.append("select s_factor_item_refitem, item_name, seq from icomvsfd	\n");
//		sql.append("where house_code = '"+house_code+"' and s_factor_refitem = '" + s_factor_refitem + "' \n");
//		sql.append("	and use_flag = 'Y'  order by seq asc \n");


		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
			rtn = sm.doSelect((String[])null);
            if(rtn == null) throw new Exception("SQL Manager is Null");

        }catch(Exception e) {
            throw new Exception("et_getMainternace:"+e.getMessage());
        } finally{
        //Release();
        }
		return rtn;
	}
	/**
	* <code>
	* screening 평가 리스트 상세항목
	*<p>
	* 	screening 평가 리스트 상세항목
	*<p>
	* @since   v1.0, 2005/06/22
	* @author  SHYI(viruslsh@empal.com)
	* @param   args
	* @return  head 정보를 담은 배열 / Error Meassage
	* @throws
	* </code>
	*/
	private String SR_getScreenItem( String s_factor_refitem ) throws Exception{

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("s_factor_refitem",s_factor_refitem);
//		
//		StringBuffer sql = new StringBuffer();
//
//		sql.append("select s_factor_item_refitem, item_name, seq from icomvsfd	\n");
//		sql.append("where house_code = '"+house_code+"' and s_factor_refitem = '" + s_factor_refitem + "' \n");
//		sql.append("	and use_flag = 'Y'  order by seq asc \n");


		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
			rtn = sm.doSelect((String[])null);
            if(rtn == null) throw new Exception("SQL Manager is Null");

        }catch(Exception e) {
            throw new Exception("et_getMainternace:"+e.getMessage());
        } finally{
        //Release();
        }
		return rtn;
	}
	
	/**
	* <code>
	* screening 평가 리스트 상세항목
	*<p>
	* 	screening 평가 리스트 상세항목
	*<p>
	* @since   v1.0, 2005/06/22
	* @author  SHYI(viruslsh@empal.com)
	* @param   args
	* @return  head 정보를 담은 배열 / Error Meassage
	* @throws
	* </code>
	*/
	private String SR_getScreenSumValue( String s_factor_refitem ,String s_template_refitem,String sVendor_sg_refitem) throws Exception{
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("s_factor_refitem",s_factor_refitem);
		wxp.addVar("s_template_refitem",s_template_refitem);
		wxp.addVar("sVendor_sg_refitem",sVendor_sg_refitem);
//		
//		StringBuffer sql = new StringBuffer();
//
//		sql.append("select s_factor_item_refitem, item_name, seq from icomvsfd	\n");
//		sql.append("where house_code = '"+house_code+"' and s_factor_refitem = '" + s_factor_refitem + "' \n");
//		sql.append("	and use_flag = 'Y'  order by seq asc \n");


		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
			rtn = sm.doSelect((String[])null);
            if(rtn == null) throw new Exception("SQL Manager is Null");

        }catch(Exception e) {
            throw new Exception("et_getMainternace:"+e.getMessage());
        } finally{
        //Release();
        }
		return rtn;
	}

   	public SepoaOut getScreenList( String sg_refitem ){

        try{
            String rtn = SR_getScreenList( sg_refitem );
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
   	}
   	/**
   	 * @description : 신규업체등록 = 스크리닝 조회
   	 * @date : 2010-03-09
   	 * @author useonlyj
   	 * */
   	private String SR_getScreenList( String sg_refitem ) throws Exception {
   		String rtn = "";
   		ConnectionContext ctx = getConnectionContext();
   		SepoaSQLManager sm = null;

   		String house_code = info.getSession("HOUSE_CODE");
   		String user_id = info.getSession( "ID" );
   		
   		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("sg_refitem", sg_refitem);
		wxp.addVar("house_code", house_code);

   		try {
   			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
   			rtn = sm.doSelect((String[])null);
   			if(rtn == null) throw new Exception("SQL Manager is Null");

        }catch(Exception e) {
            throw new Exception("et_getMainternace:"+e.getMessage());
        } finally{
        //Release();
        }
   		return rtn;
   	}
   	
   	public SepoaOut updateVssi(String sVendor_sg_refitem)
    {
        int rtn1 = 0;
        try
        {
 		   rtn1 = SR_updateVssi(sVendor_sg_refitem);
 		   
 		   setMessage("저장되었습니다.");
            setValue( "Update Row=" + rtn1 );
            setStatus( 1 );

            if (rtn1 == 0  ){
                setStatus( 0 );
            }
        }
        catch ( Exception e ){
            Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
            setStatus( 0 );
        }
        return getSepoaOut();
    }
   	
   	private int SR_updateVssi(String sVendor_sg_refitem) throws Exception
	{
  		int rtn = 0;
  		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id    = info.getSession("ID");
		SepoaSQLManager sm = null;

   	try
   	{

   		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
   		wxp.addVar("house_code", house_code);
		wxp.addVar("user_id", user_id);
		wxp.addVar("sVendor_sg_refitem",sVendor_sg_refitem);	

			int upd_rtn = 0;
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
			upd_rtn = sm.doUpdate((String[][])null,null);
			if(upd_rtn<1)
				throw new Exception("no update icomvncp");
			rtn = upd_rtn;
			Commit();
	    }
   	catch(Exception e)
   	{
			throw new Exception("et_setVendorProject:"+e.getMessage());
	    }
   	finally
   	{
			//Release();
		}
		return rtn;
	}
   	
   	
   	/**
   	 * @description :ㅅ크리닝 항목 저장 
   	 * */
	public SepoaOut insertScrItem( String[][] pSetData, String[][] pData )
    {
    	String rtn[] = null;
    	try
    	{
    			if (pData != null) {
    	    	rtn = SR_insertScrItem( pSetData, pData );
    	    } else {
    	    	rtn = SR_insertScrItem2(pSetData);
    	    }
    	
    		Logger.debug.println( " rtn[ 0 ]=================================== " + rtn[0]  );
    		Logger.debug.println( " rtn[ 1 ]=================================== " + rtn[1]  );
    			
    			
    	    setMessage( rtn[ 0 ] );
    	    setValue( "Update Row=" + rtn );
    	    setStatus( 1 );
    	
    	    	
    	    
    	    
    	    if ( rtn[ 1 ] != null ){
    	        setMessage( rtn[ 1 ] );
    	        setStatus( 0 );
    	    }
    	}
    	catch ( Exception e ){
    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
    	    setStatus( 0 );
    	}
    	return getSepoaOut();
    }
	
	/**
	    @Method Name : SR_insertScrItem
	    @작성자  : 이수헌
	    @작성일  : 2004.02.25
	    @작업내용: 스크리닝결과 등록
	**/
	@SuppressWarnings("unchecked")
    private String[] SR_insertScrItem( String[][] pSetData, String[][] pData ) throws Exception
    {
        String returnString[] = new String[ 2 ];
        ConnectionContext ctx = getConnectionContext();
//        StringBuffer sql = new StringBuffer();
        String house_code   = info.getSession("HOUSE_CODE")  ;
        String company_code = info.getSession("COMPANY_CODE");
        //String language =info.getSession("LANGUAGE");
        
        String rtnSql = "";
        int rtnIns = 0;
        SepoaSQLManager sm = null;
        
        try
        {
        
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
			wxp.addVar("house_code", house_code);
        	
			    String[] type = { "S", "S", "S", "S", "S" };
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
			    rtnIns = sm.doInsert( pSetData, type );
			    
			    SepoaXmlParser wxp_v = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vssi");
				wxp_v.addVar("house_code", house_code);
			    
				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_v.getQuery());//sql.toString());
		        	    	
				String[] setType = {"S","S"};
		        	    	
				rtnIns = sm.doInsert(pData, setType);
				
//				Map map = new HashMap();
//				map.put("house_code  ".trim(), house_code  );
//				map.put("vendor_code ".trim(), pSetData[0][4] );
				
				//소싱정보등록시 기존에 승인된 업체일 경우 ICOMVNGL의 상태 컬럼을 UPDATE하지 않음
				SepoaXmlParser wxp_chk_status = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_chk_status" );
				wxp_chk_status.addVar("house_code", house_code);
				wxp_chk_status.addVar("vendor_code", pSetData[0][4]);
				
				sm = new SepoaSQLManager( info.getSession("ID"),this,ctx, wxp_chk_status.getQuery() );
				
				SepoaFormater sf1 = new SepoaFormater( sm.doSelect() );
				int exist_cnt1 = Integer.valueOf( sf1.getValue( "CNT", 0 ) );
				
				if( exist_cnt1 < 1 ) {
					
					SepoaXmlParser wxp_doConfirm = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_doConfirm" );
					wxp_doConfirm.addVar("house_code", house_code);
					wxp_doConfirm.addVar("vendor_code", pSetData[0][4]);
					
					sm = new SepoaSQLManager( info.getSession("ID"),this,ctx, wxp_doConfirm.getQuery() );
					
					rtnIns = sm.doUpdate();
					
				}
				
				
            	Commit();
        }
        catch( Exception e )
        {
        	Rollback();
        	returnString[ 1 ] = e.getMessage();
        } finally{}
        
        return returnString;
    }  

    private String[] SR_insertScrItem2( String[][] pSetData) throws Exception
    {
        String returnString[] = new String[ 2 ];
        ConnectionContext ctx = getConnectionContext();
        String house_code =info.getSession("HOUSE_CODE")  ;
        
        String rtnSql = "";
        int rtnIns = 0;
        SepoaSQLManager sm = null;
        
        try
        {
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code",house_code);
            	
          String[] type = { "S", "S", "S", "S", "S" };
		      sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
          rtnIns = sm.doInsert( pSetData, type );
        
         	Commit();
        }
        catch( Exception e )
        {
            	Rollback();
            	returnString[ 1 ] = e.getMessage();
        } finally{}
        
        return returnString;
    }
    
    /**
   	 * @description :ㅅ크리닝 항목 저장 
   	 * */

	public SepoaOut modifyVssi( String[][] pData )
    {
    	String rtn[] = null;
    	try
    	{
    	    	rtn = SR_modifyVssi(pData);
    	
    		Logger.debug.println( " rtn[ 0 ]=================================== " + rtn[0]  );    			
    			
    	    setMessage( rtn[0] );
    	    setValue( "Update Row=" + rtn[0] );
    	    setStatus( 1 );    	    
    	    
    	    if ( rtn[ 1 ] != null ){
    	        setMessage( rtn[ 1 ] );
    	        setStatus( 0 );
    	    }
    	}
    	catch ( Exception e ){
    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
    	    setStatus( 0 );
    	}
    	return getSepoaOut();
    }

	/**
	    @Method Name : SR_insertScrItem
	    @작성자  : 이수헌
	    @작성일  : 2004.02.25
	    @작업내용: 스크리닝결과 등록
	**/
    private String[] SR_modifyVssi( String[][] pData ) throws Exception
    {
        String returnString[] = new String[ 2 ];
        ConnectionContext ctx = getConnectionContext();
//        StringBuffer sql = new StringBuffer();
        String house_code =info.getSession("HOUSE_CODE")  ;
        String company_code =info.getSession("COMPANY_CODE");
        //String language =info.getSession("LANGUAGE");
        
        String rtnSql = "";
        int rtnIns = 0;
        SepoaSQLManager sm = null;
        
        try
        {
        
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
        	
			String[] type = { "S", "S", "S"};
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
			rtnIns = sm.doInsert( pData, type );
            	
            Commit();
        }
        catch( Exception e )
        {
            	Rollback();
            	returnString[ 1 ] = e.getMessage();
        } finally{}
        
        return returnString;
    }
   	
   	/**
   	 * @Description : 신용평가현황조회
   	 * @author : icompia
   	 * @date :2010-10-24
   	 * 
   	 * */
	public SepoaOut getVendorEvalList(Map<String, String> header) {
		String result;

		try {
			result = et_getVendorEvalList(header);
			setValue(result);
			setStatus(1);
			setMessage( "정상적으로 데이터가 조회되었습니다." );

		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(this,e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_getVendorEvalList(Map<String, String> header) throws Exception, DBOpenException {
		String result = null;
		String house_code = info.getSession("HOUSE_CODE");
		String vendor_code = info.getSession("COMPANY_CODE");

        try {
        	ConnectionContext ctx = getConnectionContext();
            SepoaXmlParser wxp = new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("house_code", house_code);
			
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,wxp.getQuery());
            header.put("vendor_code", vendor_code);
            
			result = sm.doSelect(header);
			if(result == null) throw new Exception("SQL Manager is Null");

        } catch(Exception e) {
			throw new Exception("et_getVendorEvalList : " + e.getMessage());
		}
		return result;
	}
	
	/* ICT 사용 */
	public SepoaOut getEvalScore( String vendor_code, String sg_refitem){
		try
		{
			String rtn[] = null;
           		setStatus( 1 );

			rtn = SR_getEvalScore( vendor_code, sg_refitem);

			if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
				setMessage( rtn[ 1 ] );
				setStatus( 0 );
			}else{
				setValue(rtn[0]);
	            setMessage( "정상적으로 데이터가 조회되었습니다." );
			}

		}catch(Exception e){
			setStatus(0);
			setMessage("조회중에 에러가 발생하였습니다.");
			Logger.err.println(info.getSession( "ID" ),this,e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private String[] SR_getEvalScore( String vendor_code, String sg_refitem) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession( "ID" );

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code",	house_code);
		wxp.addVar("vendor_code",	vendor_code);
		wxp.addVar("sg_refitem",	sg_refitem);
		
		try {
			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//sql.toString());
			rtn[0] = sm.doSelect((String[])null);

			if( rtn[ 0 ] == null ) rtn[ 1 ] =  "SQL Manager is Null";

   		}catch(Exception e) {
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
       		rtn[ 1 ] = e.getMessage();
   		}
		return rtn;
	}
	
	public SepoaOut getFISelectList( String vendor_code  )
	{
		try
		{
           String rtn[] = null;
           setStatus( 1 );

           rtn = SR_getFISelectList( vendor_code );
           if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
               setMessage( rtn[ 1 ] );
               setStatus( 0 );
           }

           setValue( rtn[ 0 ] );
		}
		catch( Exception e ){
           setStatus( 0 );
           setMessage( e.getMessage() );
           
		}
		return getSepoaOut();
	}
	
	private String[] SR_getFISelectList( String vendor_code ) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession( "HOUSE_CODE" );
		String rtnSql = "";
	
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code",house_code);
		wxp.addVar("vendor_code",vendor_code);
	
		try
		{
			SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
			rtn[ 0 ] = sm.doSelect( (String[])null );
		}
		catch(Exception e){
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
			rtn[ 1 ] = e.getMessage();
		}
		finally{}
	
		return rtn;
	} 
	
	public SepoaOut getISSelectList( String vendor_code  )
	{
		try
		{
           String rtn[] = null;
           setStatus( 1 );

           rtn = SR_getISSelectList( vendor_code );
           if ( rtn[ 1 ] != null ){  //오류가 발생하였다.
               setMessage( rtn[ 1 ] );
               setStatus( 0 );
           }

           setValue( rtn[ 0 ] );
		}
		catch( Exception e ){
           setStatus( 0 );
           setMessage( e.getMessage() );
           
		}
		return getSepoaOut();
	}
	
	private String[] SR_getISSelectList( String vendor_code ) throws Exception
	{
		String rtn[] = new String[ 2 ];
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession( "HOUSE_CODE" );
		String rtnSql = "";
	
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code",house_code);
		wxp.addVar("vendor_code",vendor_code);
	
		try
		{
			SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
			rtn[ 0 ] = sm.doSelect( (String[])null );
		}
		catch(Exception e){
			Logger.err.println( info.getSession( "ID" ), this, "Exception : " + e.getMessage() );
			rtn[ 1 ] = e.getMessage();
		}
		finally{}
	
		return rtn;
	} 
	
	public SepoaOut insertIF( String vendor_code, String[][] pSetData ,String[][] pSetData2)
   {
       String rtn[] = null;
       int rtn1 = 0;
       try
       {
       	   if(pSetData.length > 0)
           		rtn = SR_insertIF( vendor_code, pSetData);
           if(pSetData2.length > 0)
		   		rtn1 = SR_updateIF(pSetData2);
		   
		   setMessage("저장되었습니다.");
           setValue( "Update Row=" + rtn1 );
           setStatus( 1 );

           if (rtn1 == 0 && rtn != null && rtn[ 1 ] != null ){
               setMessage( rtn[ 1 ] );
               setStatus( 0 );
           }
       }
       catch ( Exception e ){
           Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
           setStatus( 0 );
       }
       return getSepoaOut();
   }
	private int SR_updateIF(String[][] upd_data) throws Exception
	{
   		int rtn = 0;
   		ConnectionContext ctx = getConnectionContext();
		String user_id    = info.getSession("ID");
		SepoaSQLManager sm = null;

    	try
    	{
    		

    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);
    		
			String[] type_upd = {"S","S","S","S","S",
								"S","S","S","S","S",
					 			"S","S","S","S"};

			int upd_rtn = 0;
			if(upd_data.length>0)
			{
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
				upd_rtn = sm.doUpdate(upd_data, type_upd);
				if(upd_rtn<1)
					throw new Exception("no update SR_updateIF");
			}
			rtn = upd_rtn;
			Commit();
	    }
    	catch(Exception e)
    	{
			throw new Exception("SR_updateIF:"+e.getMessage());
	    }
    	finally
    	{
			//Release();
		}
		return rtn;
	}
	
	private String[] SR_insertIF( String vendor_code, String[][] pSetData ) throws Exception
	{
       String returnString[] = new String[ 2 ];
       ConnectionContext ctx = getConnectionContext();
       String house_code =info.getSession("HOUSE_CODE")  ;

       String rtnSql = "";
       int rtnIns = 0;
       SepoaFormater wf = null;
       SepoaSQLManager sm = null;

       try
       {

               SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
               wxp.addVar("house_code", 	house_code);
               wxp.addVar("vendor_code", 	vendor_code);
               wxp.addVar("user_id",		info.getSession("ID"));
               
               String[] type = { "S", "S", "S", "S", "S", "S"
            		   			,"S", "S", "S", "S", "S", "S" 
               					};
            
            
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx,wxp.getQuery());// sql.toString() );
			rtnIns = sm.doInsert( pSetData, type );

//	           }   // end of for

           Commit();
       }
       catch( Exception e )
       {
           Rollback();
           returnString[ 1 ] = e.getMessage();
       } finally{}

       return returnString;
	}
	
	public SepoaOut deleteIF( String vendor_code, String[][] pSetData)
	{
       String rtn = null;
       try
       {
           rtn = SR_deleteIF( vendor_code, pSetData);

           setStatus( 1 );
           if ( rtn.length() > 0 ){

               setMessage( rtn );
               setStatus( 0 );
           }
       }
       catch ( Exception e )
       {
           setStatus( 0 );
           setMessage( e.getMessage() );
           Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
       }
       return getSepoaOut();
	}


	private String SR_deleteIF( String vendor_code, String[][] pSetData ) throws Exception
	{
       String returnString = "";
       ConnectionContext ctx = getConnectionContext();

       String house_code =info.getSession("HOUSE_CODE")  ;
	   String company_code =info.getSession("COMPANY_CODE");
	   //String language =info.getSession("LANGUAGE");
	
	   String rtnSql = "";
	   int rtnIns = 0;
	   SepoaSQLManager sm = null;
	   String year = "";
	
	   try
	   {
	       for ( int i = 0; i < pSetData.length; i++ )
	       {
	    	   	year      = pSetData[ i ][ 0 ].trim();
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", 	house_code);
				wxp.addVar("vendor_code", vendor_code);
				
				wxp.addVar("year", year);
	
				sm = new SepoaSQLManager( info.getSession( "ID" ), this, ctx,wxp.getQuery());// sql.toString() );
	            rtnIns = sm.doDelete( (String[][])null, null );
	       }
	
	       Commit();
	   }
       catch( Exception e )
       {
           returnString = e.getMessage();
           Rollback();
       } finally{}
	
	   return returnString;
	}
	
	
	public SepoaOut insertIS( String vendor_code, String[][] pSetData ,String[][] pSetData2)
   {
       String rtn[] = null;
       int rtn1 = 0;
       try
       {
       	   if(pSetData.length > 0)
           		rtn = SR_insertIS( vendor_code, pSetData);
           if(pSetData2.length > 0)
		   		rtn1 = SR_updateIS(pSetData2);
		   
		   setMessage("저장되었습니다.");
           setValue( "Update Row=" + rtn1 );
           setStatus( 1 );

           if (rtn1 == 0 && rtn != null && rtn[ 1 ] != null ){
               setMessage( rtn[ 1 ] );
               setStatus( 0 );
           }
       }
       catch ( Exception e ){
           Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
           setStatus( 0 );
       }
       return getSepoaOut();
   }
	private int SR_updateIS(String[][] upd_data) throws Exception
	{
   		int rtn = 0;
   		ConnectionContext ctx = getConnectionContext();
		String user_id    = info.getSession("ID");
		SepoaSQLManager sm = null;

    	try
    	{
    		

    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);
    		
			String[] type_upd = {"S","S","S","S","S",
								"S","S","S","S","S",
								"S","S","S"
					 			};

			int upd_rtn = 0;
			if(upd_data.length>0)
			{
				sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
				upd_rtn = sm.doUpdate(upd_data, type_upd);
				if(upd_rtn<1)
					throw new Exception("no update SR_updateIF");
			}
			rtn = upd_rtn;
			Commit();
	    }
    	catch(Exception e)
    	{
			throw new Exception("SR_updateIS:"+e.getMessage());
	    }
    	finally
    	{
			//Release();
		}
		return rtn;
	}
	
	private String[] SR_insertIS( String vendor_code, String[][] pSetData ) throws Exception
	{
       String returnString[] = new String[ 2 ];
       ConnectionContext ctx = getConnectionContext();

       String house_code =info.getSession("HOUSE_CODE")  ;

       String rtnSql = "";
       int rtnIns = 0;
       SepoaFormater wf = null;
       SepoaSQLManager sm = null;

       try
       {

               SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
               wxp.addVar("house_code", 	house_code);
               wxp.addVar("vendor_code", 	vendor_code);
               wxp.addVar("user_id",		info.getSession("ID"));
               
               String[] type = { "S", "S", "S", "S", "S"
            		   			,"S", "S", "S", "S", "S",
            		   			"S"
               					};
            
            
			sm = new SepoaSQLManager( info.getSession("ID"), this, ctx,wxp.getQuery());// sql.toString() );
			rtnIns = sm.doInsert( pSetData, type );

//		           }   // end of for

           Commit();
       }
       catch( Exception e )
       {
           Rollback();
           returnString[ 1 ] = e.getMessage();
       } finally{}

       return returnString;
	}
	
	public SepoaOut deleteIS( String vendor_code, String[][] pSetData)
	{
       String rtn = null;
       try
       {
           rtn = SR_deleteIS( vendor_code, pSetData);

           setStatus( 1 );
           if ( rtn.length() > 0 ){

               setMessage( rtn );
               setStatus( 0 );
           }
       }
       catch ( Exception e )
       {
           setStatus( 0 );
           setMessage( e.getMessage() );
           Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
       }
       return getSepoaOut();
	}


	private String SR_deleteIS( String vendor_code, String[][] pSetData ) throws Exception
	{
       String returnString = "";
       ConnectionContext ctx = getConnectionContext();

       String house_code =info.getSession("HOUSE_CODE")  ;
	   String company_code =info.getSession("COMPANY_CODE");
	   //String language =info.getSession("LANGUAGE");
	
	   String rtnSql = "";
	   int rtnIns = 0;
	   SepoaSQLManager sm = null;
	   String year = "";
	
	   try
	   {
	       for ( int i = 0; i < pSetData.length; i++ )
	       {
	    	   	year      = pSetData[ i ][ 0 ].trim();
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", 	house_code);
				wxp.addVar("vendor_code", vendor_code);
				
				wxp.addVar("year", year);
	
				sm = new SepoaSQLManager( info.getSession( "ID" ), this, ctx,wxp.getQuery());// sql.toString() );
	            rtnIns = sm.doDelete( (String[][])null, null );
	       }
	
	       Commit();
	   }
       catch( Exception e )
       {
           returnString = e.getMessage();
           Rollback();
       } finally{}
	
	   return returnString;
	}
	
	
	/* 영업담당자 정보 조회 */
	/* ICT 사용 */
	@SuppressWarnings("unchecked")
	public SepoaOut getVncp(Map<String, Object> data) throws Exception{ 
		ConnectionContext         ctx          = null;
		SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
		String                    id           = info.getSession("ID");
		Map<String, String> 	  header       = MapUtils.getMap( data, "headerData" );
		int                       rtn          = 0;
		      
		setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try{
			
			sxp = new SepoaXmlParser();
			
			Map map = new HashMap();
			map.put("house_code  ".trim(), MapUtils.getString( header, "house_code  ".trim() ) );
			map.put("vendor_code ".trim(), MapUtils.getString( header, "vendor_code ".trim() ) );
			
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp );
            
			SepoaFormater sf = new SepoaFormater( sm.doSelect(map) );
			
			setValue( String.valueOf( sf.getRowCount() ) );
			
			setMessage("성공적으로 조회하였습니다.");
			
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {
			
		}
		return getSepoaOut();
	}
	
	/* 신규가입 등록 */
	/* ICT 사용 */
	@SuppressWarnings("unchecked")
	public SepoaOut updateNewReg(Map<String, Object> data) throws Exception{ 
		ConnectionContext         ctx          = null;
		SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
		SepoaFormater             wf           = null;
		String                    id           = info.getSession("ID");
		Map<String, String> 	  header       = MapUtils.getMap( data, "headerData" );
		int                       rtn          = 0;
		
		String VNGL_SIGN = "";		
		String VNGL = "";
		String VNCP = "";
		
		setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try{
			
			
			Map map = new HashMap();
			map.put("house_code  ".trim(), MapUtils.getString( header, "house_code  ".trim() ) );
			map.put("vendor_code ".trim(), MapUtils.getString( header, "vendor_code ".trim() ) );
						
			sxp = new SepoaXmlParser(this, "et_chkVnglSign");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 		 
            wf = new SepoaFormater(ssm.doSelect(map));
            VNGL_SIGN = wf.getValue(0,0);            
            if(VNGL_SIGN.equals("Y")){
            	throw new Exception("이미 신규가입 신청을 하였습니다.");
            }
			
			sxp = new SepoaXmlParser(this, "et_chkVngl");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 		 
            wf = new SepoaFormater(ssm.doSelect(map));
            VNGL = wf.getValue(0,0);            
            if(!VNGL.equals("Y")){
            	throw new Exception("기본정보를 입력하셔야 신규가입이 가능합니다.\r\n\r\n※ 신규가입방법\r\n1.기본정보등록(저장) -> 2.영업담당등록(저장) -> 3.가입신청");
            }
            
            sxp = new SepoaXmlParser(this, "et_chkVncp");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 		 
            wf = new SepoaFormater(ssm.doSelect(map));
            VNCP = wf.getValue(0,0);            
            if(!VNCP.equals("Y")){
            	throw new Exception("영업담당을 입력하셔야 신규가입이 가능합니다.\r\n\r\n※ 신규가입방법\r\n1.기본정보등록(저장) -> 2.영업담당등록(저장) -> 3.가입신청");
            }
			
			
            sxp = new SepoaXmlParser(this, "et_updVngl");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 		 
			rtn = ssm.doUpdate(map);
            
			if(rtn <= 0){
				throw new Exception("신규가입 처리중 오류발생하였습니다.");
			}
			
            setValue( String.valueOf( rtn ) );
			
			setMessage("성공적으로 처리되었습니다.");
			
			Commit();
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {
			
		}
		return getSepoaOut();
	}
	
}
