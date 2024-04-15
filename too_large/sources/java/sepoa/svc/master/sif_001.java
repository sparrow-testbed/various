/******************************************************
 * 파일명       : SIF_001.java
 * 생성일자     : 2014.03.18
 * 작성자       : 김태봉
 * 화면명       : 신규업체 등록 ( 내자 )
 * 경로         : sepoa.svc.master 
 * 변경이력     : 기 등록 파일 수정.
 *                
 ******************************************************/


package sepoa.svc.master;

//import hanwha.htmlparser.beans.StringBean;

import java.io.PrintWriter ;
import java.net.HttpURLConnection ;
import java.net.URL ;
import java.net.URLEncoder ;
import java.util.ArrayList;
import java.util.HashMap ;
import java.util.List ;
import java.util.Map ;

import org.apache.commons.collections.MapUtils ;

//import com.org.json.JSONArray;
//import com.org.json.JSONObject;

//import org.json.simple.JSONArray;
//import org.json.simple.JSONObject;


import sepoa.fw.cfg.Configuration ;
import sepoa.fw.cfg.ConfigurationException ;
import sepoa.fw.db.ConnectionContext ;
import sepoa.fw.db.ParamSql ;
import sepoa.fw.log.Logger ;
import sepoa.fw.msg.* ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.SepoaService ;
import sepoa.fw.srv.SepoaServiceException ;
import sepoa.fw.util.DocumentUtil ;
//import sepoa.fw.util.DongAUtils;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaString ;
import sepoa.svc.common.constants ;
//import sepoa.svc.procure.PO_058 ;

@SuppressWarnings( { "unchecked", "unused", "rawtypes" } )
public class SIF_001 extends SepoaService {

    String _LANGUAGE     = "";
    String _COMPANY_CODE = "";
    String _USER_ID      = "";
    String _USER_TYPE    = "";
    
    //20131204 sendakun
    private HashMap msg                 = null;
    private String  _DEFAULT_SELLER_COMPANY_CODE = sepoa.svc.common.constants.DEFAULT_SELLER_COMPANY_CODE;
    private String  _DEFAULT_SELLER_USER_ID      = sepoa.svc.common.constants.DEFAULT_SELLER_USER_ID;
    

    public SIF_001( String opt, SepoaInfo info ) throws SepoaServiceException {
        super( opt, info );
        setVersion( "1.0.0" );

        /**
         * 컨버전 작업 후 해당 ajax 작업시  info 정보가 소실 되는 경우 발생.
         * 소실 되었을 경우 재 생성해줌.
         * 
         * -- 해당 사항은 가 session 생성 후 ajax 자업시 발생 됨.
         * 
         */
        //info = new DongAUtils().makeSepoaInfo( info , "" , "" , "" );
        
        _LANGUAGE     = info.getSession( "LANGUAGE"     );
        _COMPANY_CODE = info.getSession( "COMPANY_CODE" );
        _USER_ID      = info.getSession( "ID"           );
        _USER_TYPE    = info.getSession( "USER_TYPE"    );

        //sso 연계를 위한 우회방법(로그아웃 이후 실행하면, company_code에 null이 들어가서, sql의 fixdata인 경우 에러 발생
        if("".equals(_COMPANY_CODE)){
        	//_COMPANY_CODE = "ANONYMOUS";//오류만 방지할 뿐, 정확한 정보를 제시하진 않는다.
        	info = new SepoaInfo("000", "ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL");
        }
        //20131204 sendakun
        try {
            msg = MessageUtil.getMessageMap( info, "MESSAGE" );
        
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.sys.println( "SIF_001 error : " + e.getMessage() );
            
        }
        
    } // end of method SIF_001
    
    
    
    
    

    public String getConfig( String s ) {
        try {
            Configuration configuration = new Configuration();
            s = configuration.get( s );
            return s;
        } catch( ConfigurationException configurationexception ) {
            Logger.sys.println( "getConfig error : " + configurationexception.getMessage() );
        } catch( Exception exception ) {
            Logger.sys.println( "getConfig error : " + exception.getMessage() );
        }

        return null;

    } // end of method getConfig
    
    
    
    
    
    
    
    

    /**
     * 업체등록시 기존에 데이터 있는지 체크해서 SIGN_STATUS 값 가져오기
     *
     *
     *
     *
     *
     * @param irs_no
     * @return
     */
    public SepoaOut checkSellerCondition( String irs_no ) {

        ConnectionContext       ctx     = getConnectionContext();
        StringBuffer            sbfs    = new StringBuffer();

        try {

            setStatus(1);
            setFlag(true);

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue();
            sbfs.delete(0, sbfs.length());
            
            String rejected       = sepoa.svc.common.constants.JobStatus.Rejected.getValue();
            String tempSave       = sepoa.svc.common.constants.JobStatus.TempSave.getValue();

            sbfs.append(                  " SELECT SIGN_STATUS           \n" );
            sbfs.append(                  "   FROM SSUGL                 \n" );
            sbfs.append(                  "  WHERE 1 = 1                 \n" );
            sbfs.append(                  "    AND JOB_STATUS NOT IN (   \n" );
            sbfs.append( sm.addFixString( "                            ? \n" )); sm.addStringParameter( rejected                     );      // 반려 코드
            sbfs.append( sm.addFixString( "                          , ? \n" )); sm.addStringParameter( tempSave                     );      // 임시저장 코드
            sbfs.append(                  "                          )   \n" );                                                      
            sbfs.append( sm.addFixString( "   AND IRS_NO         = ?     \n" )); sm.addStringParameter( irs_no                       );
          //sbfs.append( sm.addFixString( "   AND COMPANY_CODE   = ?     \n" )); sm.addStringParameter( _DEFAULT_SELLER_COMPANY_CODE );      // 기본 공급업체 정보.
            
            setValue( sm.doSelect( sbfs.toString() ) );

        } catch( Exception e ) {
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
            
        }

        return getSepoaOut();

    } // end of method checkSellerCondition
    
    






    /**
     * 업체번호 채번
     *
     * @param irs_no
     * @return
     */
    public String getSellerCode( String irs_no ) {

        ConnectionContext ctx  = getConnectionContext();
        StringBuffer      sbfs = new StringBuffer();
        
        String result = "";
        String rtn    = "";

        SepoaFormater wf = null;
        
        try {

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue();
            sbfs.delete(0, sbfs.length());
            sbfs.append(sm.addFixString (  "SELECT GETSELLERCODE(?) AS SELLER_CODE FROM DUAL    \n") );sm.addStringParameter ( irs_no );

            result = sm.doSelect(sbfs.toString());
            wf     = new SepoaFormater( result );

            rtn = wf.getValue ( "SELLER_CODE" ,  0 );

        } catch( Exception e ) {
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
            
        }

        return rtn;

    } // end of method getSellerCode

    
    
    
    

    /**
     * map argment 로 받아 해당 key 에 해당하는 데이터를 ps 에 저장한다.
     * 
     * 
     * @param ps
     * @param dataType
     * @param map
     * @param Key
     * @param def
     * @throws Exception
     */
    public void setParamSql( ParamSql ps , String dataType , Map<String,String> map , String Key , String def ) throws Exception {
        String tempType = dataType.toUpperCase();
        String tempData = MapUtils.getString( map , Key , def ).trim();
        
        setParamSql( ps , dataType , tempData );
        
    } // end of method setParamSql
    
    
    


    /**
     * ParamSql 에 data 값을 세팅해 준다.
     * 
     * 
     * 
     * 
     * 
     * @param ps
     * @param dataType
     * @param data
     * @throws Exception
     */
    public void setParamSql( ParamSql ps , String dataType , String data ) throws Exception {
        String tempType = dataType.toUpperCase();
        String tempData = data.trim();
        
        if( "S".equals( tempType ) ){
            ps.addStringParameter( tempData ); 
            
        } else if( "N".equals( tempType ) ){
            ps.addNumberParameter( tempData );
            
        } // end if

    } // end of method setParamSql
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /**
     * 업체등록시 기존 데이터 불러오기
     * 
     * 
     * 
     * 
     * 
     *
     * @param headerData
     * @return
     */
    public SepoaOut getSellerEvalList1( Map< String, String > headerData ) {

        ConnectionContext       ctx     = getConnectionContext();
        StringBuffer            sbfs    = new StringBuffer();

        String tempSave       = sepoa.svc.common.constants.JobStatus.TempSave.getValue();
        String userTypeSeller = sepoa.svc.common.constants.UserType.Seller.getValue();
        String flagNo         = sepoa.fw.util.CommonUtil.Flag.No.getValue();

        String irs_no         = "";
        String seller_code    = "";
        String tempSelectId   = "";
        
        try {

            setStatus(1);
            setFlag(true);

            irs_no      = MapUtils.getString( headerData,   "irs_no",       "" );
            seller_code = MapUtils.getString( headerData,   "seller_code",  "" );

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            if(!_DEFAULT_SELLER_USER_ID.equals( _USER_ID )){
                if( userTypeSeller.equals( _USER_TYPE ) ){
                    tempSelectId = _USER_ID;

                } // end if

            } // end if

            sm.removeAllValue();
            sbfs.delete(0, sbfs.length());
            sbfs.append(                     " select /* SIF_001.getSellerEvalList1 */                                                                      \n" );
            sbfs.append(                     "        A.SIGN_STATUS                                                                                         \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M250', A.SIGN_STATUS , ? )          SIGN_STATUS_TEXT             \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M250', A.JOB_STATUS  , ? )          JOB_STATUS_TEXT              \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append(                     "      , A.JOB_STATUS                                                                                          \n" );
            sbfs.append(                     "      , A.IRS_NO                                                                                              \n" );
            sbfs.append(                     "      , A.IRS_NO_OLD                                                                                          \n" );
            sbfs.append(                     "      , A.CREDIT_RATING                                                                                       \n" );
            sbfs.append(                     "      , A.COMPANY_REG_NO                                                                                      \n" );
            sbfs.append(                     "      , A.SELLER_CODE                                                                                         \n" );
            sbfs.append(                     "      , A.SELLER_COND                                                                                         \n" );
            sbfs.append(                     "      , A.SELLER_NAME_LOC                                                                                     \n" );
            sbfs.append(                     "      , A.SELLER_NAME_ENG                                                                                     \n" );
            sbfs.append(                     "      , A.SHIPPER_TYPE                                                                                        \n" );
            sbfs.append(                     "      , A.BUSINESS_TYPE                                                                                       \n" );
            sbfs.append(                     "      , A.INDUSTRY_TYPE                                                                                       \n" );
            sbfs.append(                     "      , A.COUNTRY                                                                                             \n" );
            sbfs.append(                     "      , A.CITY_CODE                                                                                           \n" );
            sbfs.append(                     "      , A.CUR                                                                                                 \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M002', A.CUR, ? )                  CUR_TEXT                      \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append(                     "      , A.PURCHASE_NAME                                                                                       \n" );
            sbfs.append(                     "      , A.PURCHASE_CTRL_CODE                                                                                  \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCTRLCODENAME( ? , 'P', A.PURCHASE_CTRL_CODE )  PURCHASE_CTRL_CODE_NAME       \n" )); sm.addStringParameter( _COMPANY_CODE );
            sbfs.append(                     "      , A.PAY_TERMS                                                                                           \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M010', A.PAY_TERMS, ? )            PAY_TERMS_TEXT                \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append(                     "      , A.SOLE_PROPRIETOR_FLAG                                                                                \n" );
            sbfs.append(                     "      , A.FOUNDATION_DATE                                                                                     \n" );
            sbfs.append(                     "      , A.EVAL_DATE                                                                                           \n" );
            sbfs.append(                     "      , A.SELLER_TYPE                                                                                         \n" );
            sbfs.append(                     "      , A.PLANT_ZIP_CODE                                                                                      \n" );
            sbfs.append(                     "      , A.PLANT_ADDRESS                                                                                       \n" );
            sbfs.append(                     "      , A.PLANT_ADDRESS_TEXT                                                                                  \n" );
            sbfs.append(                     "      , A.MAIN_CUSTOMER                                                                                       \n" );
            sbfs.append(                     "      , A.MAIN_PRODUCT                                                                                        \n" );
            sbfs.append(                     "      , A.CTRL_CODE                                                                                           \n" );
            sbfs.append(                     "      , C.DEPT_NAME                                                                                           \n" );
            sbfs.append(                     "      , A.RESIDENT_NO                                                                                         \n" );
            sbfs.append(                     "      , A.IRS_NO_MAIN                                                                                         \n" );
            sbfs.append(                     "      , A.ACCOUNT_TYPE                                                                                        \n" );
            sbfs.append(                     "      , A.COMPANY_TYPE                                                                                        \n" );
            sbfs.append(                     "      , A.BIZ_CLASS1                                                                                          \n" );
            sbfs.append(                     "      , A.BIZ_CLASS2                                                                                          \n" );
            sbfs.append(                     "      , A.BIZ_CLASS3                                                                                          \n" );
            sbfs.append(                     "      , A.CUSTOMS_COMPANY_CODE                                                                                \n" );
            sbfs.append(                     "      , A.PURCHASE_BLOCK_STATUS                                                                               \n" );
            sbfs.append(                     "      , A.EMP_COUNT                                                                                           \n" );
            sbfs.append(                     "      , A.SALE_AMT                                                                                            \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCTRLCODENAME( ? , 'P', A.CTRL_CODE )           CTRL_NAME                     \n" )); sm.addStringParameter( _COMPANY_CODE );
            sbfs.append(                     "      , A.MENU_PROFILE_CODE                                                                                   \n" );
            sbfs.append(                     "      , (                                                                                                     \n" );
            sbfs.append(                     "         SELECT MAX( MUPD.MENU_NAME )                                                                         \n" );
            sbfs.append(                     "            FROM SMUPD MUPD                                                                                   \n" );
            sbfs.append(                     "           WHERE MUPD.MENU_PROFILE_CODE = A.MENU_PROFILE_CODE                                                 \n" );
            sbfs.append( sm.addFixString(    "             AND " + DB_NULL_FUNCTION + "( DEL_FLAG, ? )                                                      \n" )); sm.addStringParameter( flagNo );
            sbfs.append( sm.addFixString(    "                                                   = ?                                                        \n" )); sm.addStringParameter( flagNo );
            sbfs.append(                     "        )                                                                       MENU_PROFILE_CODE_LOC         \n" );
            sbfs.append(                     "      , B.ZIP_CODE                                                                                            \n" );
            sbfs.append(                     "      , B.ADDRESS_LOC                                                                                         \n" );
            sbfs.append(                     "      , B.ADDRESS_TEXT                                                                                        \n" );
            sbfs.append(                     "      , B.CEO_NAME_LOC                                                                                        \n" );
            sbfs.append(                     "      , B.CEO_NAME_ENG                                                                                        \n" );
            sbfs.append(                     "      , B.FAX_NO                                                                                              \n" );
            sbfs.append(                     "      , B.PHONE_NO1                                                                                           \n" );
            sbfs.append(                     "      , B.PHONE_NO2                                                                                           \n" );
            sbfs.append(                     "      , B.EMAIL                                                                                               \n" );
            sbfs.append(                     "      , B.HOMEPAGE                                                                                            \n" );
            sbfs.append(                     "      , C.USER_NAME_LOC                                                                                       \n" );
            sbfs.append(                     "      , C.USER_ID   SELLER_USER_ID                                                                            \n" );
            sbfs.append(                     "      , C.PASSWORD                                                                                            \n" );
            sbfs.append(                     "      , "+SEPOA_DB_OWNER+"GETFILENAMES( A.IRS_COPY_ATTACH_NO )                  IRS_COPY_ATTACH_NO_TEXT       \n" );
            sbfs.append(                     "      , A.IRS_COPY_ATTACH_NO                                                                                  \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.IRS_COPY_ATTACH_NO)        IRS_COPY_ATTACH_NO_COUNT      \n" );
            sbfs.append(                     "      , "+SEPOA_DB_OWNER+"GETFILENAMES( A.ATTACH_NO )                           ATTACH_NO_TEXT                \n" );
            sbfs.append(                     "      , A.ATTACH_NO                                                                                           \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.ATTACH_NO)                 ATTACH_NO_COUNT               \n" );
            sbfs.append(                     "      , A.COMPANY_INTRO_ATTACH_NO                                                                             \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.COMPANY_INTRO_ATTACH_NO)   COMPANY_INTRO_ATTACH_NO_COUNT \n" );
            sbfs.append(                     "      , A.SEAL_ATTACH_NO                                                                                      \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.SEAL_ATTACH_NO)            SEAL_ATTACH_NO_COUNT          \n" );
            sbfs.append(                     "      , C.PASSWORD                                                                                            \n" );
            sbfs.append(                     "      , A.COMPANY_CODE                                                                                        \n" );

            //sbfs.append(                     "      , D.BANK_CODE                                                                                           \n" );
            //sbfs.append(                     "      , D.BANK_ACCT                                                                                           \n" );
            //sbfs.append(                     "      , D.DEPOSITOR_NAME                                                                                      \n" );
            sbfs.append(                     "      , A.TAX_CAL_SHEET_FLAG                                                                                  \n" );
            
            sbfs.append(                     "   FROM SSUGL A                                                                                               \n" );
            //sbfs.append(                     "                 LEFT OUTER JOIN SSUBK D  ON A.SELLER_CODE    = D.SELLER_CODE                                \n" );
            sbfs.append(                     "      , SADDR B                                                                                               \n" );
            sbfs.append(                     "      , SUSMT C                                                                                               \n" );
            sbfs.append(                     "  WHERE 1 = 1                                                                                                 \n" );
            sbfs.append( sm.addSelectString( "   AND A.SELLER_CODE    = ?                                                                                   \n" )); sm.addStringParameter( seller_code );
            sbfs.append( sm.addSelectString( "   AND A.IRS_NO         = ?                                                                                   \n" )); sm.addStringParameter( irs_no );
            sbfs.append( sm.addFixString(    "   AND " + DB_NULL_FUNCTION + "( A.DEL_FLAG, ? )                                                              \n" )); sm.addStringParameter( flagNo );
            sbfs.append( sm.addFixString(    "                                           = ?                                                                \n" )); sm.addStringParameter( flagNo );
            sbfs.append(                     "   AND A.SELLER_CODE    = B.CODE_NO                                                                           \n" );
            sbfs.append(                     "   AND A.SELLER_CODE    = C.COMPANY_CODE                                                                      \n" );
            sbfs.append(                     "   AND B.CODE_TYPE      = '2'                                                                                 \n" );
            sbfs.append( sm.addSelectString( "   AND C.USER_ID        = ?                                                                                   \n" )); sm.addStringParameter( tempSelectId );

            setValue( sm.doSelect( sbfs.toString() ) );

            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M002", "M010", "M250" );

        } catch( Exception e ) {
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
        }

        return getSepoaOut();

    } // end of method getSellerEvalList1

    public SepoaOut getSellerEvalList1_sso( Map< String, String > headerData ) {

        ConnectionContext       ctx     = getConnectionContext();
        StringBuffer            sbfs    = new StringBuffer();

        String tempSave       = sepoa.svc.common.constants.JobStatus.TempSave.getValue();
        String userTypeSeller = sepoa.svc.common.constants.UserType.Seller.getValue();
        String flagNo         = sepoa.fw.util.CommonUtil.Flag.No.getValue();

        String irs_no         = "";
        String seller_code    = "";
        String tempSelectId   = "";
        String company_code_sso = "";
        try {

            setStatus(1);
            setFlag(true);

            irs_no      = MapUtils.getString( headerData,   "irs_no",       "" );
            seller_code = MapUtils.getString( headerData,   "seller_code",  "" );
            company_code_sso = MapUtils.getString( headerData,   "company_code_sso",  "" );

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            if(!_DEFAULT_SELLER_USER_ID.equals( _USER_ID )){
                if( userTypeSeller.equals( _USER_TYPE ) ){
                    tempSelectId = _USER_ID;

                } // end if

            } // end if

            sm.removeAllValue();
            sbfs.delete(0, sbfs.length());
            sbfs.append(                     " select /* SIF_001.getSellerEvalList1 */                                                                      \n" );
            sbfs.append(                     "        A.SIGN_STATUS                                                                                         \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M250', A.SIGN_STATUS , ? )          SIGN_STATUS_TEXT             \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M250', A.JOB_STATUS  , ? )          JOB_STATUS_TEXT              \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append(                     "      , A.JOB_STATUS                                                                                          \n" );
            sbfs.append(                     "      , A.IRS_NO                                                                                              \n" );
            sbfs.append(                     "      , A.IRS_NO_OLD                                                                                          \n" );
            sbfs.append(                     "      , A.CREDIT_RATING                                                                                       \n" );
            sbfs.append(                     "      , A.COMPANY_REG_NO                                                                                      \n" );
            sbfs.append(                     "      , A.SELLER_CODE                                                                                         \n" );
            sbfs.append(                     "      , A.SELLER_COND                                                                                         \n" );
            sbfs.append(                     "      , A.SELLER_NAME_LOC                                                                                     \n" );
            sbfs.append(                     "      , A.SELLER_NAME_ENG                                                                                     \n" );
            sbfs.append(                     "      , A.SHIPPER_TYPE                                                                                        \n" );
            sbfs.append(                     "      , A.BUSINESS_TYPE                                                                                       \n" );
            sbfs.append(                     "      , A.INDUSTRY_TYPE                                                                                       \n" );
            sbfs.append(                     "      , A.COUNTRY                                                                                             \n" );
            sbfs.append(                     "      , A.CITY_CODE                                                                                           \n" );
            sbfs.append(                     "      , A.CUR                                                                                                 \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M002', A.CUR, ? )                  CUR_TEXT                      \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append(                     "      , A.PURCHASE_NAME                                                                                       \n" );
            sbfs.append(                     "      , A.PURCHASE_CTRL_CODE                                                                                  \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCTRLCODENAME( ? , 'P', A.PURCHASE_CTRL_CODE )  PURCHASE_CTRL_CODE_NAME       \n" )); sm.addStringParameter(company_code_sso);
            sbfs.append(                     "      , A.PAY_TERMS                                                                                           \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCODETEXT1( 'M010', A.PAY_TERMS, ? )            PAY_TERMS_TEXT                \n" )); sm.addStringParameter( _LANGUAGE );
            sbfs.append(                     "      , A.SOLE_PROPRIETOR_FLAG                                                                                \n" );
            sbfs.append(                     "      , A.FOUNDATION_DATE                                                                                     \n" );
            sbfs.append(                     "      , A.EVAL_DATE                                                                                           \n" );
            sbfs.append(                     "      , A.SELLER_TYPE                                                                                         \n" );
            sbfs.append(                     "      , A.PLANT_ZIP_CODE                                                                                      \n" );
            sbfs.append(                     "      , A.PLANT_ADDRESS                                                                                       \n" );
            sbfs.append(                     "      , A.PLANT_ADDRESS_TEXT                                                                                  \n" );
            sbfs.append(                     "      , A.MAIN_CUSTOMER                                                                                       \n" );
            sbfs.append(                     "      , A.MAIN_PRODUCT                                                                                        \n" );
            sbfs.append(                     "      , A.CTRL_CODE                                                                                           \n" );
            sbfs.append(                     "      , C.DEPT_NAME                                                                                           \n" );
            sbfs.append(                     "      , A.RESIDENT_NO                                                                                         \n" );
            sbfs.append(                     "      , A.IRS_NO_MAIN                                                                                         \n" );
            sbfs.append(                     "      , A.ACCOUNT_TYPE                                                                                        \n" );
            sbfs.append(                     "      , A.COMPANY_TYPE                                                                                        \n" );
            sbfs.append(                     "      , A.BIZ_CLASS1                                                                                          \n" );
            sbfs.append(                     "      , A.BIZ_CLASS2                                                                                          \n" );
            sbfs.append(                     "      , A.BIZ_CLASS3                                                                                          \n" );
            sbfs.append(                     "      , A.CUSTOMS_COMPANY_CODE                                                                                \n" );
            sbfs.append(                     "      , A.PURCHASE_BLOCK_STATUS                                                                               \n" );
            sbfs.append(                     "      , A.EMP_COUNT                                                                                           \n" );
            sbfs.append(                     "      , A.SALE_AMT                                                                                            \n" );
            sbfs.append( sm.addFixString(    "      , " + SEPOA_DB_OWNER + "GETCTRLCODENAME( ? , 'P', A.CTRL_CODE )           CTRL_NAME                     \n" )); sm.addStringParameter(company_code_sso);
            sbfs.append(                     "      , A.MENU_PROFILE_CODE                                                                                   \n" );
            sbfs.append(                     "      , (                                                                                                     \n" );
            sbfs.append(                     "         SELECT MAX( MUPD.MENU_NAME )                                                                         \n" );
            sbfs.append(                     "            FROM SMUPD MUPD                                                                                   \n" );
            sbfs.append(                     "           WHERE MUPD.MENU_PROFILE_CODE = A.MENU_PROFILE_CODE                                                 \n" );
            sbfs.append( sm.addFixString(    "             AND " + DB_NULL_FUNCTION + "( DEL_FLAG, ? )                                                      \n" )); sm.addStringParameter( flagNo );
            sbfs.append( sm.addFixString(    "                                                   = ?                                                        \n" )); sm.addStringParameter( flagNo );
            sbfs.append(                     "        )                                                                       MENU_PROFILE_CODE_LOC         \n" );
            sbfs.append(                     "      , B.ZIP_CODE                                                                                            \n" );
            sbfs.append(                     "      , B.ADDRESS_LOC                                                                                         \n" );
            sbfs.append(                     "      , B.ADDRESS_TEXT                                                                                        \n" );
            sbfs.append(                     "      , B.CEO_NAME_LOC                                                                                        \n" );
            sbfs.append(                     "      , B.CEO_NAME_ENG                                                                                        \n" );
            sbfs.append(                     "      , B.FAX_NO                                                                                              \n" );
            sbfs.append(                     "      , B.PHONE_NO1                                                                                           \n" );
            sbfs.append(                     "      , B.PHONE_NO2                                                                                           \n" );
            sbfs.append(                     "      , B.EMAIL                                                                                               \n" );
            sbfs.append(                     "      , B.HOMEPAGE                                                                                            \n" );
            sbfs.append(                     "      , C.USER_NAME_LOC                                                                                       \n" );
            sbfs.append(                     "      , C.USER_ID   SELLER_USER_ID                                                                            \n" );
            sbfs.append(                     "      , C.PASSWORD                                                                                            \n" );
            sbfs.append(                     "      , "+SEPOA_DB_OWNER+"GETFILENAMES( A.IRS_COPY_ATTACH_NO )                  IRS_COPY_ATTACH_NO_TEXT       \n" );
            sbfs.append(                     "      , A.IRS_COPY_ATTACH_NO                                                                                  \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.IRS_COPY_ATTACH_NO)        IRS_COPY_ATTACH_NO_COUNT      \n" );
            sbfs.append(                     "      , "+SEPOA_DB_OWNER+"GETFILENAMES( A.ATTACH_NO )                           ATTACH_NO_TEXT                \n" );
            sbfs.append(                     "      , A.ATTACH_NO                                                                                           \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.ATTACH_NO)                 ATTACH_NO_COUNT               \n" );
            sbfs.append(                     "      , A.COMPANY_INTRO_ATTACH_NO                                                                             \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.COMPANY_INTRO_ATTACH_NO)   COMPANY_INTRO_ATTACH_NO_COUNT \n" );
            sbfs.append(                     "      , A.SEAL_ATTACH_NO                                                                                      \n" );
            sbfs.append(                     "      , (SELECT COUNT(*) FROM SFILE WHERE DOC_NO = A.SEAL_ATTACH_NO)            SEAL_ATTACH_NO_COUNT          \n" );
            sbfs.append(                     "      , C.PASSWORD                                                                                            \n" );
            sbfs.append(                     "      , A.COMPANY_CODE                                                                                        \n" );

            sbfs.append(                     "      , D.BANK_CODE                                                                                           \n" );
            sbfs.append(                     "      , D.BANK_ACCT                                                                                           \n" );
            sbfs.append(                     "      , D.DEPOSITOR_NAME                                                                                      \n" );
            sbfs.append(                     "      , A.TAX_CAL_SHEET_FLAG                                                                                  \n" );
            
            sbfs.append(                     "   FROM SSUGL A                                                                                               \n" );
            sbfs.append(                     "                 LEFT OUTER JOIN SSUBK D  ON A.SELLER_CODE    = D.SELLER_CODE                                \n" );
            sbfs.append(                     "      , SADDR B                                                                                               \n" );
            sbfs.append(                     "      , SUSMT C                                                                                               \n" );
            sbfs.append(                     "  WHERE 1 = 1                                                                                                 \n" );
            sbfs.append( sm.addSelectString( "   AND A.SELLER_CODE    = ?                                                                                   \n" )); sm.addStringParameter( seller_code );
            sbfs.append( sm.addSelectString( "   AND A.IRS_NO         = ?                                                                                   \n" )); sm.addStringParameter( irs_no );
            sbfs.append( sm.addFixString(    "   AND " + DB_NULL_FUNCTION + "( A.DEL_FLAG, ? )                                                              \n" )); sm.addStringParameter( flagNo );
            sbfs.append( sm.addFixString(    "                                           = ?                                                                \n" )); sm.addStringParameter( flagNo );
            sbfs.append(                     "   AND A.SELLER_CODE    = B.CODE_NO                                                                           \n" );
            sbfs.append(                     "   AND A.SELLER_CODE    = C.COMPANY_CODE                                                                      \n" );
            sbfs.append(                     "   AND B.CODE_TYPE      = '2'                                                                                 \n" );
            sbfs.append( sm.addSelectString( "   AND C.USER_ID        = ?                                                                                   \n" )); sm.addStringParameter( tempSelectId );

            setValue( sm.doSelect( sbfs.toString() ) );

            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M002", "M010", "M250" );

        } catch( Exception e ) {
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
        }

        return getSepoaOut();

    } // end of method getSellerEvalList1    
    
    
    
    
    
    










    
    /**
     * 업체등록 > 기본정보 탭 정보 입력
     *
     * @param allData
     * @return
     */
    public SepoaOut setSellerEvalList1( Map< String, Object >   allData ) throws Exception {

        ConnectionContext       ctx         = getConnectionContext();
        StringBuffer            sbfs        = new StringBuffer();
        StringBuffer            sbvl        = new StringBuffer();
        SepoaFormater           sf          = null;
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵

        int     rtn     = 0;
        boolean Change_flag=false;

        headerData = MapUtils.getMap( allData, "headerData");
        
        try {
            String buyer_plant_code    = sepoa.svc.common.constants.DEFAULT_PLANT_CODE;
            String sellerCondNewSeller = sepoa.svc.common.constants.SellerCond.NewSeller.getValue();
            String userTypeSeller      = sepoa.svc.common.constants.UserType.Seller.getValue();
            String commonUtilFlagNo    = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String commonUtilFlagYes   = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();

            String jobStatusTempSave   = sepoa.svc.common.constants.JobStatus.TempSave.getValue();  // 임시
            String jobStatusRejected   = sepoa.svc.common.constants.JobStatus.Rejected.getValue();  // 반려
            String jobStatusApproving  = sepoa.svc.common.constants.JobStatus.Approving.getValue(); // 진행중
            String jobStatusApproved   = sepoa.svc.common.constants.JobStatus.Approved.getValue(); 	// 승인완료

            String signStatusTempSave  = sepoa.svc.common.constants.SignStatus.TempSave.getValue(); // 임시
            String signStatusRejected  = sepoa.svc.common.constants.SignStatus.Rejected.getValue(); // 반려
            String signStatusApproveSuccess_Regist  = sepoa.svc.common.constants.SignStatus.ApproveSuccess_Regist.getValue(); // 승인완료
            
            String seller_code         = MapUtils.getString( headerData , "seller_code" , "" );
            String buyer_company_code  = seller_code;
            String susmtPassword       = SepoaString.encString ( MapUtils.getString( headerData,  "password"  , "" ).trim() , "PWD"   );
            String susmtEmail          = SepoaString.encString ( MapUtils.getString( headerData,  "email"     , "" ).trim() , "EMAIL" );
            String susmtPhoneNo1       = SepoaString.encString ( MapUtils.getString( headerData,  "phone_no1" , "" ).trim() , "PHONE" );
            String susmtPhoneNo2       = SepoaString.encString ( MapUtils.getString( headerData,  "phone_no2" , "" ).trim() , "PHONE" );
            String susmtFaxNo          = SepoaString.encString ( MapUtils.getString( headerData,  "fax_no"    , "" ).trim() , "PHONE" );
            String susmtMobileNo       = susmtPhoneNo2;
            String susmtUserType       = "R";
                                                                                                                                        
//            String bizClass1           = MapUtils.getString( headerData, "biz_class1", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass2           = MapUtils.getString( headerData, "biz_class2", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass3           = MapUtils.getString( headerData, "biz_class3", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass4           = MapUtils.getString( headerData, "biz_class4", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass5           = MapUtils.getString( headerData, "biz_class5", "" ).trim().equals( "true" ) ? "1":"0";
//            
            String strType             = "";
            String USER_ID             = info.getSession( "ID" );
            String nowDate             = SepoaDate.getShortDateString();
            String nowTime             = SepoaDate.getShortTimeString();

            // 사용자 id 가 없을 경우 user_id 는 업체 코드로 세팅.
            if( "".equals( USER_ID ) ){
                USER_ID = _DEFAULT_SELLER_USER_ID;
                
            } // end if
            
            
            ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

            // 업체번호가 없을경우 채번
            if( "".equals( seller_code ) ) {
                strType      = "INSERT";
                
                //seller_code  = getSellerCode ( MapUtils.getString( headerData, "irs_no", "" ) );
                //headerData.put( "seller_code", seller_code );

                //외자업체의 채번방식을 함께 사용
                SepoaOut    so  = DocumentUtil.getDocNumber( info, "CRE" );
                seller_code = so.result[0];
                headerData.put( "seller_code", seller_code);
                
                buyer_company_code = _DEFAULT_SELLER_COMPANY_CODE;

            } else {
                strType = "UPDATE";
                
            } // end if

         //   headerData.put( "foundation_date1", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "foundation_date", "" ) ) );
         //   headerData.put( "eval_date"       , SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "eval_date"      , "" ) ) );
            
            String house_code = "000";
            if( "INSERT".equals( strType ) ) {
                /* ********************************************************************************************************************************************************************
                 * SSUGL 에 데이터를 입력한다.
                 *  
                 * 
                 */
                // SSUGL 삭제 후 입력
                
            	
            	
            	ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                
                sbfs.append( "DELETE FROM SSUGL                 \n ");
                sbfs.append( "      WHERE COMPANY_CODE  = ?     \n "); setParamSql( ps , "S" , buyer_company_code                 );
                sbfs.append( "        AND IRS_NO        = ?     \n "); setParamSql( ps , "S" , headerData         , "irs_no" , "" );
                
                ps.doDelete( sbfs.toString() );
                
                
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbvl.delete( 0, sbvl.length() );
                
                sbfs.append( "INSERT INTO SSUGL (                  \n" );
                sbfs.append( "         HOUSE_CODE                  \n" );    sbvl.append( "    ?        \n" );setParamSql( ps , "S" , house_code);
                sbfs.append( "       , SELLER_CODE                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , seller_code                                    );
                sbfs.append( "       , ADD_DATE                    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , nowDate                                        );
                sbfs.append( "       , ADD_TIME                    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , nowTime                                        );
                sbfs.append( "       , ADD_USER_ID                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , USER_ID                                        );
                sbfs.append( "       , SELLER_TYPE                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "seller_type",                  "" );
                sbfs.append( "       , SELLER_COND                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , sellerCondNewSeller                            );
                sbfs.append( "       , SELLER_NAME_LOC             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "seller_name_loc",              "" );
                sbfs.append( "       , SELLER_NAME_ENG             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "seller_name_eng",              "" );
                sbfs.append( "       , COUNTRY                     \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "country",                      "" );
                sbfs.append( "       , CITY_CODE                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "city_code",                    "" );
                sbfs.append( "       , LANGUAGE                    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , "KO"                                           );
                sbfs.append( "       , DUNS_NO                     \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "duns_no",                      "" );
                sbfs.append( "       , IRS_NO                      \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "irs_no",                       "" );
                sbfs.append( "       , IRS_NO_OLD                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "irs_no_old",                   "" );
                sbfs.append( "       , IRS_CHANGE_DATE             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "current_date",                 "" );
                sbfs.append( "       , COMPANY_REG_NO              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "company_reg_no",               "" );
                sbfs.append( "       , FOUNDATION_DATE             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "foundation_date1",             "" );
                sbfs.append( "       , VAT_APP_TYPE                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "vat_app_type",                 "" );
                sbfs.append( "       , INDUSTRY_TYPE               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "industry_type",                "" );
                sbfs.append( "       , BUSINESS_TYPE               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "business_type",                "" );
                sbfs.append( "       , GROUP_COMPANY_CODE          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "group_company_code",           "" );
                sbfs.append( "       , GROUP_COMPANY_NAME          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "group_company_name",           "" );
                sbfs.append( "       , TRADE_REG_NO                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "trade_reg_no",                 "" );
                sbfs.append( "       , MAIN_PRODUCT                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "main_product",                 "" );
                sbfs.append( "       , CREDIT_RATING               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "credit_rating",                "" );
                sbfs.append( "       , SOLE_PROPRIETOR_FLAG        \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "sole_proprietor_flag",         "" );
                //sbfs.append( "       , RESIDENT_NO                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "resident_no",                  "" );
                sbfs.append( "       , EDI_FLAG                    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "edi_flag",                     "" );
                sbfs.append( "       , EDI_ID                      \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "edi_id",                       "" );
                sbfs.append( "       , EDI_QUALIFIER               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "edi_qualifier",                "" );
                sbfs.append( "       , CUSTOMS_COMPANY_CODE        \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "customs_company_code",         "" );
                sbfs.append( "       , PAYEE_FLAG                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "payee_flag",                   "" );
                sbfs.append( "       , SHIPPER_FLAG                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "shipper_flag",                 "" );
                sbfs.append( "       , PURCHASE_BLOCK_FLAG         \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , commonUtilFlagNo                               );
                sbfs.append( "       , FREE_EXPORT_COMPANY         \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "free_export_company",          "" );
                sbfs.append( "       , DISCOUNT_FLAG               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "discount_flag",                "" );
                sbfs.append( "       , PAY_TO_LOCATION             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "pay_to_location",              "" );
                sbfs.append( "       , JOB_STATUS                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , jobStatusTempSave                              ); // 등록일때는 임시저장상태
                sbfs.append( "       , SIGN_STATUS                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , signStatusTempSave                             ); // 등록일때는 임시저장상태
                sbfs.append( "       , SIGN_DATE                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "current_date",                 "" );
                sbfs.append( "       , SIGN_PERSON_ID              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "session_user_id",              "" );
                sbfs.append( "       , COMPANY_TYPE                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "company_type",                 "" );
                sbfs.append( "       , EVALUATION_FLAG             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "evaluation_flag",              "" );
                sbfs.append( "       , SHIPPER_TYPE                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "shipper_type",                 "" );
                sbfs.append( "       , SEARCH_KEY                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "search_key",                   "" );
                sbfs.append( "       , ATTACH_NO                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "attach_no",                    "" );
                sbfs.append( "       , ATTACH_NO2                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "attach_no2",                   "" );
                sbfs.append( "       , CTRL_CODE                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "ctrl_code",                    "" );
                sbfs.append( "       , ETAX_BILL_FLAG              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "etax_bill_flag",               "" );
                sbfs.append( "       , START_DATE                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "start_date",                   "" );
                sbfs.append( "       , EBIZ_FLAG                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "ebiz_flag",                    "" );
                sbfs.append( "       , DEL_FLAG                    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , commonUtilFlagNo                               ); // 삭제여부
                sbfs.append( "       , CITY_TEXT                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "city_text",                    "" );
                sbfs.append( "       , ATTACH_NO3                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "attach_no3",                   "" );
                sbfs.append( "       , CREDIT_RATING_PURCHASE      \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "credit_rating_purchase",       "" );
                sbfs.append( "       , CREDIT_RATING_WORK          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "credit_rating_work",           "" );
                sbfs.append( "       , PROGRESS_REMARK             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "progress_remark",              "" );
                sbfs.append( "       , ATTACH_NO4                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "attach_no4",                   "" );
                sbfs.append( "       , IRS_COPY_ATTACH_NO          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "irs_copy_attach_no",           "" );
                sbfs.append( "       , BANK_COPY_ATTACH_NO         \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "bank_copy_attach_no",          "" );
                sbfs.append( "       , PURCHASE_BLOCK_DESC         \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "purchase_block_desc",          "" );
                sbfs.append( "       , PURCHASE_BLOCK_USER         \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "purchase_block_user",          "" );
                sbfs.append( "       , PAY_TERMS                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "pay_terms",                    "" );
                sbfs.append( "       , NDA_COPY_ATTACH_NO          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "nda_copy_attach_no",           "" );
                sbfs.append( "       , DELY_TERMS                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "dely_terms",                   "" );
                sbfs.append( "       , CUR                         \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "cur",                          "" );
                sbfs.append( "       , PURCHASE_CTRL_CODE          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "purchase_ctrl_code",           "" );
                sbfs.append( "       , PURCHASE_NAME               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "purchase_name",                "" );
                sbfs.append( "       , MENU_PROFILE_CODE           \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "menu_profile_code",            "" );
                sbfs.append( "       , PLANT_ADDRESS               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "plant_address",                "" );
                sbfs.append( "       , PLANT_ZIP_CODE              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "plant_zip_code",               "" );
                sbfs.append( "       , DEALING_PRODUCT             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "dealing_product",              "" );
                sbfs.append( "       , MAIN_CUSTOMER               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "main_customer",                "" );
                sbfs.append( "       , MAKER_COMPANY_NAME          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "maker_company_name",           "" );
                sbfs.append( "       , SUPPLIER_COMPANY_NAME       \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "supplier_company_name",        "" );
                sbfs.append( "       , HQ_DAE_M2                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "hq_dae_m2",                    "" );
                sbfs.append( "       , HQ_GUN_M2                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "hq_gun_m2",                    "" );
                sbfs.append( "       , PLANT_DAE_M2                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "plant_dae_m2",                 "" );
                sbfs.append( "       , PLANT_GUN_M2                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "plant_gun_m2",                 "" );
                sbfs.append( "       , HQ_OWN_TYPE                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "hq_own_type",                  "" );
                sbfs.append( "       , PLANT_OWN_TYPE              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "plant_own_type",               "" );
                sbfs.append( "       , OTHER_PLANT_TEXT            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_text",             "" );
                sbfs.append( "       , OTHER_PLANT_DAE_M2          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_dae_m2",           "" );
                sbfs.append( "       , OTHER_PLANT_GUN_M2          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_gun_m2",           "" );
                sbfs.append( "       , OTHER_PLANT_OWN_TYPE        \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_own_type",         "" );
                sbfs.append( "       , MAIN_EQUIP_ATTACH_NO        \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "main_equip_attach_no",         "" );
                sbfs.append( "       , AGENT_COMPANY_NAME          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "agent_company_name",           "" );
                sbfs.append( "       , MAKER_COMPANY_FLAG          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "maker_company_flag",           "" );
                sbfs.append( "       , SUPPLIER_COMPANY_FLAG       \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "supplier_company_flag",        "" );
                sbfs.append( "       , AGENT_COMPANY_FLAG          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "agent_company_flag",           "" );
                sbfs.append( "       , COMPANY_INTRO_ATTACH_NO     \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "company_intro_attach_no",      "" );
                sbfs.append( "       , PRODUCT_INTRO_ATTACH_NO     \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "product_intro_attach_no",      "" );
                sbfs.append( "       , SELLER_EVALUATION_ATTACH_NO \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "seller_evaluation_attach_no",  "" );
                sbfs.append( "       , REAL_EVALUATION_ATTACH_NO   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "real_evaluation_attach_no",    "" );
                sbfs.append( "       , MATERIAL_AUDIT_ATTACH_NO    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "material_audit_attach_no",     "" );
                sbfs.append( "       , EVALUATION_ETC_ATTACH_NO    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "evaluation_etc_attach_no",     "" );
                sbfs.append( "       , SEAL_ATTACH_NO              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "seal_attach_no",               "" );
                sbfs.append( "       , MANDT                       \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , "0"                                            );
                sbfs.append( "       , COMPANY_CODE                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , _DEFAULT_SELLER_COMPANY_CODE                   );
                sbfs.append( "       , PLANT_CODE                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , buyer_plant_code                               );
                sbfs.append( "       , DEL_GLO_FLAG                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "del_glo_flag",                 "" );
                sbfs.append( "       , DEL_PUR_FLAG                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "del_pur_flag",                 "" );
                sbfs.append( "       , SIGN_TIME                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "current_time",                 "" );
                sbfs.append( "       , SUBCONTRACT_DATE            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "subcontract_date",             "" );
                sbfs.append( "       , COLLABORATE_DATE            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "subcontract_date",             "" );
                sbfs.append( "       , SAP_SEND_DATE               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "sap_send_date",                "" );
                sbfs.append( "       , SAP_SEND_STATUS             \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "sap_send_status",              "" );
                sbfs.append( "       , SUBCONTRACT_FLAG            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "subcontract_flag",             "" );
                sbfs.append( "       , SELLER_BASIC_TYPE           \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "seller_basic_type",            "" );
                sbfs.append( "       , MANUFACTURE_FLAG            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "manufacture_flag",             "" );
                sbfs.append( "       , PAYMENT_METHOD              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "payment_method",               "" );
                sbfs.append( "       , BILL_TYPE                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "bill_type",                    "" );
                sbfs.append( "       , RE_ACCOUNT                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "re_account",                   "" );
                sbfs.append( "       , CONTROL_DATA                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "control_data",                 "" );
                sbfs.append( "       , CASH_MANEGE_GROUP           \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "cash_manege_group",            "" );
                sbfs.append( "       , SELLER_CONTRACT_TYPE        \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "seller_contract_type",         "" );
                sbfs.append( "       , PURCHASE_TEL                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "purchase_tel",                 "" );
              //sbfs.append( "       , ACCOUNT_STATUS              \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "account_status",               "" );
              //sbfs.append( "       , ACCOUNT_REQ_DATE            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "account_req_date",             "" );
              //sbfs.append( "       , ACCOUNT_REQ_USER            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "account_req_user",             "" );
              //sbfs.append( "       , ACCOUNT_APP_DATE            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "account_app_date",             "" );
              //sbfs.append( "       , ACCOUNT_APP_USER            \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "account_app_user",             "" );
              //sbfs.append( "       , ACCOUNT_REJECT_REASON       \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "account_reject_reason",        "" );
                sbfs.append( "       , SIGN_VALUE                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "sign_value",                   "" );
                sbfs.append( "       , SIGN_NAME                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "sign_name",                    "" );
                sbfs.append( "       , PLANT_ADDRESS_TEXT          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "plant_address_text",           "" );
                sbfs.append( "       , E_RETURN                    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "e_return",                     "" );
                sbfs.append( "       , E_MESSAGE                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "e_message",                    "" );
                sbfs.append( "       , ATTACH_NO5                  \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "attach_no5",                   "" );
                sbfs.append( "       , EVAL_DATE                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "eval_date",                    "" );
                sbfs.append( "       , IRS_NO_MAIN                 \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "irs_no_main",                  "" );
                sbfs.append( "       , ACCOUNT_TYPE                \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "account_type",                 "" );
                sbfs.append( "       , BIZ_CLASS                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps,  "S" , headerData, "biz_class",                    "" );            
                 
                
                
                sbfs.append( "       , ACCOUNT_GROUP               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , "M001"                                         ); // 국내업체:M001, 해외업체:M002
                sbfs.append( "       , SAP_CRUD_FLAG               \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , "C"                                            ); // 생성:C, 변경:U, 삭제:D
                sbfs.append( "       , EMP_COUNT                   \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "emp_count",                    "" ); // 생성:C, 변경:U, 삭제:D
                sbfs.append( "       , SALE_AMT                    \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "N" , headerData, "sale_amt",                     "" ); // 생성:C, 변경:U, 삭제:D
                sbfs.append( "       , ADMIN_SUBMIT_FLAG           \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , commonUtilFlagYes                              );
                sbfs.append( "       , TAX_CAL_SHEET_FLAG          \n" );    sbvl.append( "  , ?        \n" );setParamSql( ps , "S" , headerData, "tax_cal_sheet_flag",           "" );
                sbfs.append( " ) VALUES (                          \n" );    sbvl.append( "  )          \n" );

                rtn = ps.doInsert( sbfs.toString() + sbvl.toString() );

                if( rtn <= 0 ) {
                    setStatus( 0 );
                    setFlag( false );
                    throw new Exception("SSUGL INSERT ERROR!");
                    
                }

                /* ********************************************************************************************************************************************************************
                 * 사용자 정보를 확인 후 해당 데이터를 insert 시킨다.
                 * 
                 * 기 등록 데이터는 전체 삭제.
                 * 
                 */
                         
                ps.removeAllValue();
                sbfs.delete(0, sbfs.length());
                sbfs.append( "DELETE FROM SUSMT              \n" );
                sbfs.append( "      WHERE COMPANY_CODE = ?   \n" ); setParamSql( ps , "S" , buyer_company_code                  );
                sbfs.append( "        AND USER_ID      = ?   \n" ); setParamSql( ps , "S" , headerData, "seller_user_id"   , "" );
                ps.doUpdate( sbfs.toString() );

                // SUSMT 입력
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbvl.delete( 0, sbvl.length() );
                
                sbfs.append( "INSERT INTO SUSMT (      \n" );
                sbfs.append( "       HOUSE_CODE        \n" );   sbvl.append( "    ?       \n" );setParamSql( ps , "S" , house_code);
                sbfs.append( "     , USER_ID           \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , headerData, "seller_user_id"   , "" );
                sbfs.append( "     , PASSWORD          \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , susmtPassword                       );
                sbfs.append( "     , USER_NAME_LOC     \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , headerData,  "user_name_loc"   , "" );
                sbfs.append( "     , USER_NAME_ENG     \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , headerData,  "user_name_eng"   , "" );
                sbfs.append( "     , COMPANY_CODE      \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , seller_code                         );
                sbfs.append( "     , PLANT_CODE        \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , buyer_plant_code                    );
                sbfs.append( "     , DEPT              \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , DEPT_NAME         \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , headerData,  "dept_name"       , "" );
                //sbfs.append( "     , RESIDENT_NO       \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , headerData,  "resident_no"     , "" );
                sbfs.append( "     , EMPLOYEE_NO       \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , EMAIL             \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , susmtEmail                          );
                sbfs.append( "     , POSITION          \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , LANGUAGE          \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , "KO"                                );
                sbfs.append( "     , TIME_ZONE         \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , "G08"                               );
                sbfs.append( "     , COUNTRY           \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , headerData,  "country"         , "" );
                sbfs.append( "     , CITY_CODE         \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , DEL_FLAG          \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , commonUtilFlagNo                    );
               // sbfs.append( "     , PR_LOCATION       \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , MANAGER_POSITION  \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , USER_TYPE         \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , userTypeSeller                      );
                sbfs.append( "     , WORK_TYPE         \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , "Z"                                 );
              //sbfs.append( "     , SIGN_STATUS       \n" );   sbvl.append( "  , ?       \n" );ps.addStringParameter(sepoa.svc.common.constants.SignStatus.Rejected.getValue()); // 임시저장 R
                sbfs.append( "     , SIGN_STATUS       \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , susmtUserType                       ); // 임시저장 R
                sbfs.append( "     , ADD_DATE          \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , nowDate                             );
                sbfs.append( "     , ADD_TIME          \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , nowTime                             );
                sbfs.append( "     , ADD_USER_ID       \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , USER_ID                             );
                sbfs.append( "     , MENU_PROFILE_CODE \n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , getConfig("sepoa.supplier.default.profile_code") );
                sbfs.append( "     ) VALUES (          \n" );   sbvl.append( "  )         \n" );

                rtn = ps.doInsert( sbfs.toString() + sbvl.toString() );
                
                if( rtn <= 0 ) {
                    setStatus( 0 );
                    setFlag( false );
                    throw new Exception("SUSMT INSERT ERROR!");
                }
                
                
                // SUSMT_MENU 입력(백업용)
                ps.removeAllValue();
                sbfs.delete(0, sbfs.length());
                sbfs.append( "DELETE FROM SUSMT_MENU              \n" );
                sbfs.append( "       WHERE USER_ID      = ?   		\n" ); setParamSql( ps , "S" , headerData, "seller_user_id"   , "" );
                ps.doDelete( sbfs.toString() );
                
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbvl.delete( 0, sbvl.length() );
                sbfs.append( "INSERT INTO SUSMT_MENU (  \n" );
                sbfs.append( "       USER_ID           	\n" );   sbvl.append( "    ?       \n" );setParamSql( ps , "S" , headerData, "seller_user_id"   , "" );
                sbfs.append( "     , PASSWORD			\n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , susmtPassword                       );
                sbfs.append( "     , MENU_PROFILE_CODE 	\n" );   sbvl.append( "  , ?       \n" );setParamSql( ps , "S" , getConfig("sepoa.supplier.default.profile_code") );
                sbfs.append( "     ) VALUES (          	\n" );   sbvl.append( "  )         \n" );
                rtn = ps.doInsert( sbfs.toString() + sbvl.toString() );
                
                if( rtn <= 0 ) {
                    setStatus( 0 );
                    setFlag( false );
                    throw new Exception("SUSMT_MENU INSERT ERROR!");
                }
                
            // UPDATE
            } else {
                
                
                /* ********************************************************************************************************************************************************************
                 * 현재 데이터가 승인 대기 중인지 확인한다.
                 * 
                 * 
                 */
            	sbfs.delete( 0, sbfs.length() );
                ps.removeAllValue();
                sbfs.append(                 " SELECT 			      	 \n" );
                sbfs.append(                 "        JOB_STATUS         \n" );
                sbfs.append(                 "      , SIGN_STATUS        \n" );
                sbfs.append(                 "      , ADMIN_SUBMIT_FLAG  \n" );
                sbfs.append(                 "   FROM SSUGL			   	 \n" );       
                sbfs.append(ps.addFixString( "  WHERE SELLER_CODE  = ?   \n" ));    setParamSql( ps , "S" , seller_code                  );
                sbfs.append(ps.addFixString( "    AND COMPANY_CODE = ?   \n" ));    setParamSql( ps , "S" , _DEFAULT_SELLER_COMPANY_CODE );
                
            	sf = new SepoaFormater(ps.doSelect( sbfs.toString() ));
            	
            	
            	/* 작업 직업 상태코드가 임시저장 또는 반려가 아니라면 승인 진행 중이므로 수정이 불가능 하다.
                 * 
                 */
                if( !jobStatusTempSave.equals( sf.getValue( "JOB_STATUS" , 0 ) ) && !jobStatusRejected.equals( sf.getValue( "JOB_STATUS" , 0 ) ) && !jobStatusApproved.equals( sf.getValue( "JOB_STATUS" , 0 ) ) ){
                    throw new Exception("입력사항에 대한 승인 대기중 입니다. 승인이 완료된 뒤에 수정이 가능합니다.(회계)1");

                } // end if

            	
                /* 결재(승인) 상태코드가 임시저장 또는 반려가 아니라면 승인 진행 중이므로 수정이 불가능 하다.
                 * 
                 */
            	if( !signStatusTempSave.equals( sf.getValue( "SIGN_STATUS" , 0 ) ) && !signStatusRejected.equals( sf.getValue( "SIGN_STATUS" , 0 ) ) && !signStatusApproveSuccess_Regist.equals( sf.getValue( "SIGN_STATUS" , 0 ) )){
                    throw new Exception("입력사항에 대한 승인 대기중 입니다. 승인이 완료된 뒤에 수정이 가능합니다.(회계)2");
            	    
                } // end if
            	
            	
                /* ********************************************************************************************************************************************************************
                 * SSUGL 의 값을 update 한다.
                 * 
                 * 
                 */
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbvl.delete( 0, sbvl.length() );
                
                sbfs.append( "UPDATE SSUGL                                  \n" );
                sbfs.append( "   SET CHANGE_DATE                 = ?        \n" );setParamSql( ps , "S" , nowDate                                        );
                sbfs.append( "     , CHANGE_TIME                 = ?        \n" );setParamSql( ps , "S" , nowTime                                        );
                sbfs.append( "     , CHANGE_USER_ID              = ?        \n" );setParamSql( ps , "S" , USER_ID                                        );
                sbfs.append( "     , SELLER_TYPE                 = ?        \n" );setParamSql( ps , "S" , headerData, "seller_type",                  "" );
                sbfs.append( "     , SELLER_COND                 = ?        \n" );setParamSql( ps , "S" , sellerCondNewSeller                            );
                sbfs.append( "     , SELLER_NAME_LOC             = ?        \n" );setParamSql( ps , "S" , headerData, "seller_name_loc",              "" );
                sbfs.append( "     , SELLER_NAME_ENG             = ?        \n" );setParamSql( ps , "S" , headerData, "seller_name_eng",              "" );
                sbfs.append( "     , COUNTRY                     = ?        \n" );setParamSql( ps , "S" , headerData, "country",                      "" );
                sbfs.append( "     , CITY_CODE                   = ?        \n" );setParamSql( ps , "S" , headerData, "city_code",                    "" );
                sbfs.append( "     , LANGUAGE                    = ?        \n" );setParamSql( ps , "S" , "KO"                                           );
                sbfs.append( "     , DUNS_NO                     = ?        \n" );setParamSql( ps , "S" , headerData, "duns_no",                      "" );
                sbfs.append( "     , IRS_NO                      = ?        \n" );setParamSql( ps , "S" , headerData, "irs_no",                       "" );
                sbfs.append( "     , IRS_NO_OLD                  = ?        \n" );setParamSql( ps , "S" , headerData, "irs_no_old",                   "" );
                sbfs.append( "     , IRS_CHANGE_DATE             = ?        \n" );setParamSql( ps , "S" , headerData, "current_date",                 "" );
                sbfs.append( "     , COMPANY_REG_NO              = ?        \n" );setParamSql( ps , "S" , headerData, "company_reg_no",               "" );
                sbfs.append( "     , FOUNDATION_DATE             = ?        \n" );setParamSql( ps , "S" , headerData, "foundation_date1",             "" );
                sbfs.append( "     , VAT_APP_TYPE                = ?        \n" );setParamSql( ps , "S" , headerData, "vat_app_type",                 "" );
                sbfs.append( "     , INDUSTRY_TYPE               = ?        \n" );setParamSql( ps , "S" , headerData, "industry_type",                "" );
                sbfs.append( "     , BUSINESS_TYPE               = ?        \n" );setParamSql( ps , "S" , headerData, "business_type",                "" );
                sbfs.append( "     , GROUP_COMPANY_CODE          = ?        \n" );setParamSql( ps , "S" , headerData, "group_company_code",           "" );
                sbfs.append( "     , GROUP_COMPANY_NAME          = ?        \n" );setParamSql( ps , "S" , headerData, "group_company_name",           "" );
                sbfs.append( "     , TRADE_REG_NO                = ?        \n" );setParamSql( ps , "S" , headerData, "trade_reg_no",                 "" );
                sbfs.append( "     , MAIN_PRODUCT                = ?        \n" );setParamSql( ps , "S" , headerData, "main_product",                 "" );
                sbfs.append( "     , CREDIT_RATING               = ?        \n" );setParamSql( ps , "S" , headerData, "credit_rating",                "" );
                sbfs.append( "     , SOLE_PROPRIETOR_FLAG        = ?        \n" );setParamSql( ps , "S" , headerData, "sole_proprietor_flag",         "" );
                //sbfs.append( "     , RESIDENT_NO                 = ?        \n" );setParamSql( ps , "S" , headerData, "resident_no",                  "" );
                sbfs.append( "     , EDI_FLAG                    = ?        \n" );setParamSql( ps , "S" , headerData, "edi_flag",                     "" );
                sbfs.append( "     , EDI_ID                      = ?        \n" );setParamSql( ps , "S" , headerData, "edi_id",                       "" );
                sbfs.append( "     , EDI_QUALIFIER               = ?        \n" );setParamSql( ps , "S" , headerData, "edi_qualifier",                "" );
                sbfs.append( "     , CUSTOMS_COMPANY_CODE        = ?        \n" );setParamSql( ps , "S" , headerData, "customs_company_code",         "" );
                sbfs.append( "     , PAYEE_FLAG                  = ?        \n" );setParamSql( ps , "S" , headerData, "payee_flag",                   "" );
                sbfs.append( "     , SHIPPER_FLAG                = ?        \n" );setParamSql( ps , "S" , headerData, "shipper_flag",                 "" );
                sbfs.append( "     , PURCHASE_BLOCK_FLAG         = ?        \n" );setParamSql( ps , "S" , commonUtilFlagNo                               );
                sbfs.append( "     , FREE_EXPORT_COMPANY         = ?        \n" );setParamSql( ps , "S" , headerData, "free_export_company",          "" );
                sbfs.append( "     , DISCOUNT_FLAG               = ?        \n" );setParamSql( ps , "S" , headerData, "discount_flag",                "" );
                sbfs.append( "     , PAY_TO_LOCATION             = ?        \n" );setParamSql( ps , "S" , headerData, "pay_to_location",              "" );
                //sbfs.append( "     , JOB_STATUS                  = ?        \n" );setParamSql( ps , "S" , jobStatusTempSave                              );  // 등록일때는 임시저장상태
                //sbfs.append( "     , SIGN_STATUS                 = ?        \n" );setParamSql( ps , "S" , signStatusTempSave                             );  // 등록일때는 임시저장상태
                sbfs.append( "     , SIGN_DATE                   = ?        \n" );setParamSql( ps , "S" , headerData, "current_date",                 "" );
                sbfs.append( "     , SIGN_PERSON_ID              = ?        \n" );setParamSql( ps , "S" , headerData, "session_user_id",              "" );
                sbfs.append( "     , COMPANY_TYPE                = ?        \n" );setParamSql( ps , "S" , headerData, "company_type",                 "" );
                sbfs.append( "     , EVALUATION_FLAG             = ?        \n" );setParamSql( ps , "S" , headerData, "evaluation_flag",              "" );
                sbfs.append( "     , SHIPPER_TYPE                = ?        \n" );setParamSql( ps , "S" , headerData, "shipper_type",                 "" );
                sbfs.append( "     , SEARCH_KEY                  = ?        \n" );setParamSql( ps , "S" , headerData, "search_key",                   "" );
                sbfs.append( "     , ATTACH_NO                   = ?        \n" );setParamSql( ps , "S" , headerData, "attach_no",                    "" );
                sbfs.append( "     , ATTACH_NO2                  = ?        \n" );setParamSql( ps , "S" , headerData, "attach_no2",                   "" );
                sbfs.append( "     , CTRL_CODE                   = ?        \n" );setParamSql( ps , "S" , headerData, "ctrl_code",                    "" );
                sbfs.append( "     , ETAX_BILL_FLAG              = ?        \n" );setParamSql( ps , "S" , headerData, "etax_bill_flag",               "" );
                sbfs.append( "     , START_DATE                  = ?        \n" );setParamSql( ps , "S" , headerData, "start_date",                   "" );
                sbfs.append( "     , EBIZ_FLAG                   = ?        \n" );setParamSql( ps , "S" , headerData, "ebiz_flag",                    "" );
                sbfs.append( "     , DEL_FLAG                    = ?        \n" );setParamSql( ps , "S" , commonUtilFlagNo                               );// 삭제여부
                sbfs.append( "     , CITY_TEXT                   = ?        \n" );setParamSql( ps , "S" , headerData, "city_text",                    "" );
                sbfs.append( "     , ATTACH_NO3                  = ?        \n" );setParamSql( ps , "S" , headerData, "attach_no3",                   "" );
                sbfs.append( "     , CREDIT_RATING_PURCHASE      = ?        \n" );setParamSql( ps , "S" , headerData, "credit_rating_purchase",       "" );
                sbfs.append( "     , CREDIT_RATING_WORK          = ?        \n" );setParamSql( ps , "S" , headerData, "credit_rating_work",           "" );
                sbfs.append( "     , PROGRESS_REMARK             = ?        \n" );setParamSql( ps , "S" , headerData, "progress_remark",              "" );
                sbfs.append( "     , ATTACH_NO4                  = ?        \n" );setParamSql( ps , "S" , headerData, "attach_no4",                   "" );
                sbfs.append( "     , IRS_COPY_ATTACH_NO          = ?        \n" );setParamSql( ps , "S" , headerData, "irs_copy_attach_no",           "" );
                sbfs.append( "     , BANK_COPY_ATTACH_NO         = ?        \n" );setParamSql( ps , "S" , headerData, "bank_copy_attach_no",          "" );
                sbfs.append( "     , PURCHASE_BLOCK_DESC         = ?        \n" );setParamSql( ps , "S" , headerData, "purchase_block_desc",          "" );
                sbfs.append( "     , PURCHASE_BLOCK_USER         = ?        \n" );setParamSql( ps , "S" , headerData, "purchase_block_user",          "" );
                sbfs.append( "     , PAY_TERMS                   = ?        \n" );setParamSql( ps , "S" , headerData, "pay_terms",                    "" );
                sbfs.append( "     , NDA_COPY_ATTACH_NO          = ?        \n" );setParamSql( ps , "S" , headerData, "nda_copy_attach_no",           "" );
                sbfs.append( "     , DELY_TERMS                  = ?        \n" );setParamSql( ps , "S" , headerData, "dely_terms",                   "" );
                sbfs.append( "     , CUR                         = ?        \n" );setParamSql( ps , "S" , headerData, "cur",                          "" );
                sbfs.append( "     , PURCHASE_CTRL_CODE          = ?        \n" );setParamSql( ps , "S" , headerData, "purchase_ctrl_code",           "" );
                sbfs.append( "     , PURCHASE_NAME               = ?        \n" );setParamSql( ps , "S" , headerData, "purchase_name",                "" );
                sbfs.append( "     , MENU_PROFILE_CODE           = ?        \n" );setParamSql( ps , "S" , headerData, "menu_profile_code",            "" );
                sbfs.append( "     , PLANT_ADDRESS               = ?        \n" );setParamSql( ps , "S" , headerData, "plant_address",                "" );
                sbfs.append( "     , PLANT_ZIP_CODE              = ?        \n" );setParamSql( ps , "S" , headerData, "plant_zip_code",               "" );
                sbfs.append( "     , DEALING_PRODUCT             = ?        \n" );setParamSql( ps , "S" , headerData, "dealing_product",              "" );
                sbfs.append( "     , MAIN_CUSTOMER               = ?        \n" );setParamSql( ps , "S" , headerData, "main_customer",                "" );
                sbfs.append( "     , MAKER_COMPANY_NAME          = ?        \n" );setParamSql( ps , "S" , headerData, "maker_company_name",           "" );
                sbfs.append( "     , SUPPLIER_COMPANY_NAME       = ?        \n" );setParamSql( ps , "S" , headerData, "supplier_company_name",        "" );
                sbfs.append( "     , HQ_DAE_M2                   = ?        \n" );setParamSql( ps , "S" , headerData, "hq_dae_m2",                    "" );
                sbfs.append( "     , HQ_GUN_M2                   = ?        \n" );setParamSql( ps , "S" , headerData, "hq_gun_m2",                    "" );
                sbfs.append( "     , PLANT_DAE_M2                = ?        \n" );setParamSql( ps , "S" , headerData, "plant_dae_m2",                 "" );
                sbfs.append( "     , PLANT_GUN_M2                = ?        \n" );setParamSql( ps , "S" , headerData, "plant_gun_m2",                 "" );
                sbfs.append( "     , HQ_OWN_TYPE                 = ?        \n" );setParamSql( ps , "S" , headerData, "hq_own_type",                  "" );
                sbfs.append( "     , PLANT_OWN_TYPE              = ?        \n" );setParamSql( ps , "S" , headerData, "plant_own_type",               "" );
                sbfs.append( "     , OTHER_PLANT_TEXT            = ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_text",             "" );
                sbfs.append( "     , OTHER_PLANT_DAE_M2          = ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_dae_m2",           "" );
                sbfs.append( "     , OTHER_PLANT_GUN_M2          = ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_gun_m2",           "" );
                sbfs.append( "     , OTHER_PLANT_OWN_TYPE        = ?        \n" );setParamSql( ps , "S" , headerData, "other_plant_own_type",         "" );
                sbfs.append( "     , MAIN_EQUIP_ATTACH_NO        = ?        \n" );setParamSql( ps , "S" , headerData, "main_equip_attach_no",         "" );
                sbfs.append( "     , AGENT_COMPANY_NAME          = ?        \n" );setParamSql( ps , "S" , headerData, "agent_company_name",           "" );
                sbfs.append( "     , MAKER_COMPANY_FLAG          = ?        \n" );setParamSql( ps , "S" , headerData, "maker_company_flag",           "" );
                sbfs.append( "     , SUPPLIER_COMPANY_FLAG       = ?        \n" );setParamSql( ps , "S" , headerData, "supplier_company_flag",        "" );
                sbfs.append( "     , AGENT_COMPANY_FLAG          = ?        \n" );setParamSql( ps , "S" , headerData, "agent_company_flag",           "" );
                sbfs.append( "     , COMPANY_INTRO_ATTACH_NO     = ?        \n" );setParamSql( ps , "S" , headerData, "company_intro_attach_no",      "" );
                sbfs.append( "     , PRODUCT_INTRO_ATTACH_NO     = ?        \n" );setParamSql( ps , "S" , headerData, "product_intro_attach_no",      "" );
                sbfs.append( "     , SELLER_EVALUATION_ATTACH_NO = ?        \n" );setParamSql( ps , "S" , headerData, "seller_evaluation_attach_no",  "" );
                sbfs.append( "     , REAL_EVALUATION_ATTACH_NO   = ?        \n" );setParamSql( ps , "S" , headerData, "real_evaluation_attach_no",    "" );
                sbfs.append( "     , MATERIAL_AUDIT_ATTACH_NO    = ?        \n" );setParamSql( ps , "S" , headerData, "material_audit_attach_no",     "" );
                sbfs.append( "     , EVALUATION_ETC_ATTACH_NO    = ?        \n" );setParamSql( ps , "S" , headerData, "evaluation_etc_attach_no",     "" );
                sbfs.append( "     , SEAL_ATTACH_NO              = ?        \n" );setParamSql( ps , "S" , headerData, "seal_attach_no",               "" );
                sbfs.append( "     , MANDT                       = ?        \n" );setParamSql( ps , "S" , "0"                                            );
                sbfs.append( "     , PLANT_CODE                  = ?        \n" );setParamSql( ps , "S" , buyer_plant_code                               );
                sbfs.append( "     , DEL_GLO_FLAG                = ?        \n" );setParamSql( ps , "S" , headerData, "del_glo_flag",                 "" );
                sbfs.append( "     , DEL_PUR_FLAG                = ?        \n" );setParamSql( ps , "S" , headerData, "del_pur_flag",                 "" );
                sbfs.append( "     , SIGN_TIME                   = ?        \n" );setParamSql( ps , "S" , headerData, "current_time",                 "" );
                sbfs.append( "     , SUBCONTRACT_DATE            = ?        \n" );setParamSql( ps , "S" , headerData, "subcontract_date",             "" );
                sbfs.append( "     , COLLABORATE_DATE            = ?        \n" );setParamSql( ps , "S" , headerData, "subcontract_date",             "" );
                sbfs.append( "     , SAP_SEND_DATE               = ?        \n" );setParamSql( ps , "S" , headerData, "sap_send_date",                "" );
                sbfs.append( "     , SAP_SEND_STATUS             = ?        \n" );setParamSql( ps , "S" , headerData, "sap_send_status",              "" );
                sbfs.append( "     , SUBCONTRACT_FLAG            = ?        \n" );setParamSql( ps , "S" , headerData, "subcontract_flag",             "" );
                sbfs.append( "     , SELLER_BASIC_TYPE           = ?        \n" );setParamSql( ps , "S" , headerData, "seller_basic_type",            "" );
                sbfs.append( "     , MANUFACTURE_FLAG            = ?        \n" );setParamSql( ps , "S" , headerData, "manufacture_flag",             "" );
                sbfs.append( "     , PAYMENT_METHOD              = ?        \n" );setParamSql( ps , "S" , headerData, "payment_method",               "" );
                sbfs.append( "     , BILL_TYPE                   = ?        \n" );setParamSql( ps , "S" , headerData, "bill_type",                    "" );
                sbfs.append( "     , RE_ACCOUNT                  = ?        \n" );setParamSql( ps , "S" , headerData, "re_account",                   "" );
                sbfs.append( "     , CONTROL_DATA                = ?        \n" );setParamSql( ps , "S" , headerData, "control_data",                 "" );
                sbfs.append( "     , CASH_MANEGE_GROUP           = ?        \n" );setParamSql( ps , "S" , headerData, "cash_manege_group",            "" );
                sbfs.append( "     , SELLER_CONTRACT_TYPE        = ?        \n" );setParamSql( ps , "S" , headerData, "seller_contract_type",         "" );
                sbfs.append( "     , PURCHASE_TEL                = ?        \n" );setParamSql( ps , "S" , headerData, "purchase_tel",                 "" );
              //sbfs.append( "     , ACCOUNT_STATUS              = ?        \n" );setParamSql( ps , "S" , headerData, "account_status",               "" );
              //sbfs.append( "     , ACCOUNT_REQ_DATE            = ?        \n" );setParamSql( ps , "S" , headerData, "account_req_date",             "" );
              //sbfs.append( "     , ACCOUNT_REQ_USER            = ?        \n" );setParamSql( ps , "S" , headerData, "account_req_user",             "" );
              //sbfs.append( "     , ACCOUNT_APP_DATE            = ?        \n" );setParamSql( ps , "S" , headerData, "account_app_date",             "" );
              //sbfs.append( "     , ACCOUNT_APP_USER            = ?        \n" );setParamSql( ps , "S" , headerData, "account_app_user",             "" );
              //sbfs.append( "     , ACCOUNT_REJECT_REASON       = ?        \n" );setParamSql( ps , "S" , headerData, "account_reject_reason",        "" );
                sbfs.append( "     , SIGN_VALUE                  = ?        \n" );setParamSql( ps , "S" , headerData, "sign_value",                   "" );
                sbfs.append( "     , SIGN_NAME                   = ?        \n" );setParamSql( ps , "S" , headerData, "sign_name",                    "" );
                sbfs.append( "     , PLANT_ADDRESS_TEXT          = ?        \n" );setParamSql( ps , "S" , headerData, "plant_address_text",           "" );
                sbfs.append( "     , E_RETURN                    = ?        \n" );setParamSql( ps , "S" , headerData, "e_return",                     "" );
                sbfs.append( "     , E_MESSAGE                   = ?        \n" );setParamSql( ps , "S" , headerData, "e_message",                    "" );
                sbfs.append( "     , ATTACH_NO5                  = ?        \n" );setParamSql( ps , "S" , headerData, "attach_no5",                   "" );
                sbfs.append( "     , EVAL_DATE                   = ?        \n" );setParamSql( ps , "S" , headerData, "eval_date",                    "" );
                sbfs.append( "     , IRS_NO_MAIN                 = ?        \n" );setParamSql( ps , "S" , headerData, "irs_no_main",                  "" );
                sbfs.append( "     , ACCOUNT_TYPE                = ?        \n" );setParamSql( ps , "S" , headerData, "account_type",                 "" );
                sbfs.append( "     , BIZ_CLASS                   = ?        \n" );setParamSql( ps,  "S" , headerData,"biz_class",                     "" );               
                sbfs.append( "     , ACCOUNT_GROUP               = ?        \n" );setParamSql( ps , "S" , "M001"                                         ); // 국내업체:M001, 해외업체:M002                                                                                    " );
                sbfs.append( "     , SAP_CRUD_FLAG               = ?        \n" );setParamSql( ps , "S" , "C"                                            ); // 생성:C, 변경:U, 삭제:D
                sbfs.append( "     , EMP_COUNT                   = ?        \n" );setParamSql( ps , "S" , headerData, "emp_count",                    "" ); // 생성:C, 변경:U, 삭제:D
                sbfs.append( "     , SALE_AMT                    = ?        \n" );setParamSql( ps , "N" , headerData, "sale_amt",                     "" ); // 생성:C, 변경:U, 삭제:D
                sbfs.append( "     , ADMIN_SUBMIT_FLAG           = ?        \n" );setParamSql( ps , "S" , commonUtilFlagYes                              );
                sbfs.append( "     , TAX_CAL_SHEET_FLAG          = ?        \n" );setParamSql( ps , "S" , headerData, "tax_cal_sheet_flag"          , "" );
                sbfs.append( " WHERE SELLER_CODE                 = ?        \n" );setParamSql( ps , "S" , seller_code                                    );
                sbfs.append( "   AND COMPANY_CODE                = ?        \n" );setParamSql( ps , "S" , _DEFAULT_SELLER_COMPANY_CODE                   );

                rtn = ps.doInsert( sbfs.toString() + sbvl.toString() );

                // SUSMT 입력
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbfs.append( "UPDATE SUSMT SET         	   \n" );
                //sbfs.append( "       USER_ID           = ? \n" ); setParamSql( ps , "S" , headerData, "seller_user_id"   , "" );
                sbfs.append( "       PASSWORD          = ? \n" ); setParamSql( ps , "S" , susmtPassword                       );
                sbfs.append( "     , USER_NAME_LOC     = ? \n" ); setParamSql( ps , "S" , headerData,  "user_name_loc"   , "" );
                sbfs.append( "     , USER_NAME_ENG     = ? \n" ); setParamSql( ps , "S" , headerData,  "user_name_eng"   , "" );
                //sbfs.append( "     , COMPANY_CODE      = ? \n" ); setParamSql( ps , "S" , seller_code                         );
                //sbfs.append( "     , PLANT_CODE        = ? \n" ); setParamSql( ps , "S" , buyer_plant_code                    );
                //sbfs.append( "     , DEPT              = ? \n" ); setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , DEPT_NAME         = ? \n" ); setParamSql( ps , "S" , headerData,  "dept_name"       , "" );
                //sbfs.append( "     , RESIDENT_NO       = ? \n" ); setParamSql( ps , "S" , headerData,  "resident_no"     , "" );
                //sbfs.append( "     , EMPLOYEE_NO       = ? \n" ); setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , EMAIL             = ? \n" ); setParamSql( ps , "S" , susmtEmail                          );
                //sbfs.append( "     , POSITION          = ? \n" ); setParamSql( ps , "S" , ""                                  );
                //sbfs.append( "     , LANGUAGE          = ? \n" ); setParamSql( ps , "S" , "KO"                                );
                //sbfs.append( "     , TIME_ZONE         = ? \n" ); setParamSql( ps , "S" , "G08"                               );
                sbfs.append( "     , COUNTRY           = ? \n" ); setParamSql( ps , "S" , headerData,  "country"         , "" );
                //sbfs.append( "     , CITY_CODE         = ? \n" ); setParamSql( ps , "S" , ""                                  );
                sbfs.append( "     , DEL_FLAG          = ? \n" ); setParamSql( ps , "S" , commonUtilFlagNo                    );
                //sbfs.append( "     , PR_LOCATION       = ? \n" ); setParamSql( ps , "S" , ""                                  );
                //sbfs.append( "     , MANAGER_POSITION  = ? \n" ); setParamSql( ps , "S" , ""                                  );
                //sbfs.append( "     , USER_TYPE         = ? \n" ); setParamSql( ps , "S" , userTypeSeller                      );
                //sbfs.append( "     , WORK_TYPE         = ? \n" ); setParamSql( ps , "S" , "Z"                                 );
                //sbfs.append( "     , SIGN_STATUS       = ? \n" ); setParamSql( ps , "S" , susmtUserType                       ); // 임시저장 R
                sbfs.append( "     , CHANGE_DATE         = ? \n" ); setParamSql( ps , "S" , nowDate                             );
                sbfs.append( "     , CHANGE_TIME         = ? \n" ); setParamSql( ps , "S" , nowTime                             );
                sbfs.append( "     , CHANGE_USER_ID      = ? \n" ); setParamSql( ps , "S" , USER_ID                             );
                //sbfs.append( "     , MENU_PROFILE_CODE = ? \n" ); setParamSql( ps , "S" , getConfig("sepoa.supplier.default.profile_code") );
                sbfs.append( "     WHERE COMPANY_CODE = ?    \n" ); setParamSql( ps , "S" , seller_code                         );
                //sbfs.append( "     AND PLANT_CODE = ?        \n" ); setParamSql( ps , "S" , buyer_plant_code                    );
                sbfs.append( "     AND USER_ID = ?		     \n" ); setParamSql( ps , "S" , headerData, "seller_user_id"   , "" );
                rtn = ps.doUpdate( sbfs.toString());

                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbfs.append( "UPDATE SUSMT_MENU   \n" );
                sbfs.append( "     SET PASSWORD = ?					\n" );setParamSql( ps , "S" , susmtPassword                       );
                sbfs.append( "     WHERE USER_ID = ?		    \n" ); setParamSql( ps , "S" , headerData, "seller_user_id"   , "" );
                rtn = ps.doUpdate( sbfs.toString());
            }

            
            ps.removeAllValue();
            sbfs.delete( 0, sbfs.length() );
            sbvl.delete( 0, sbvl.length() );
            sbfs.append( "DELETE FROM SSUBK       \n" );
            sbfs.append( " WHERE SELLER_CODE  = ? \n" ); ps.addStringParameter( seller_code        );
            sbfs.append( "   AND COMPANY_CODE = ? \n" ); ps.addStringParameter( buyer_company_code );
            
            
            ps.doDelete( sbfs.toString() );
            
            ps.removeAllValue();
            sbfs.delete( 0, sbfs.length() );
            sbvl.delete( 0, sbvl.length() );
            
            sbfs.append(" INSERT INTO SSUBK(      \n" );
            sbfs.append( "     HOUSE_CODE            \n" );sbvl.append( "    ?    \n" );setParamSql( ps , "S" , house_code);
            sbfs.append("   ,  COMPANY_CODE          \n"); sbvl.append( "  ,   ?  \n" );setParamSql( ps , "S" , buyer_company_code                  );                                                
            sbfs.append("   , SELLER_CODE           \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , seller_code                         );                    
           // sbfs.append("   , BANK_CODE             \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "bank_code"       , "" );              
           // sbfs.append("   , BANK_ACCT             \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "bank_acct"       , "" );              
            sbfs.append("   , DEPOSITOR_NAME        \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "depositor_name"  , "" );               
//          sbfs.append("   , BANK_COUNTRY          \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "COUNTRY"         , "" );              
//          sbfs.append("   , ADDRESS               \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "ADDRESS"         , "" );                
//          sbfs.append("   , OPEN_BANK_SIGN        \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "OPEN_BANK_SIGN"  , "" );            
//          sbfs.append("   , BANK_NAME_LOC         \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "BANK_NAME_LOC"   , "" );              
//          sbfs.append("   , BANK_NAME_ENG         \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "BANK_NAME_ENG"   , "" );              
//          sbfs.append("   , DEPOSITOR_NAME        \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "DEPOSITOR_NAME"  , "" );      
//          sbfs.append("   , BRANCH_CODE           \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "BRANCH_CODE"     , "" );             
//          sbfs.append("   , BRANCH_NAME_LOC       \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "BRANCH_NAME_LOC" , "" );         
//          sbfs.append("   , BRANCH_NAME_ENG       \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , headerData , "BRANCH_NAME_ENG" , "" );         
            sbfs.append("   , DEL_FLAG              \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , "N"                                 );                                                               
            sbfs.append("   , ADD_DATE              \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , nowDate                             );                                      
            sbfs.append("   , ADD_TIME              \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , nowTime                             );                                      
            sbfs.append("   , ADD_USER_ID           \n"); sbvl.append( "   , ?  \n" );setParamSql( ps , "S" , USER_ID                             );                                               
            sbfs.append(" ) VALUES (                \n"); sbvl.append( "   )    \n" );                                                                                                
            
            ps.doDelete( sbfs.toString() + sbvl.toString() );       



            
            
            
            /* ********************************************************************************************************************************************************************
             * 주소의 정보를 DELETE 입력 후 재 등록 처리.
             * 
             * 기 등록 SADDR(CODE_TYPE = 3) 삭제 후 입력
             * SADDR(CODE_TYPE = 3) 입력
             * SADDR 정보도 회사정보의 대표정보로 등록하게함(2013-11-28 변경)
             * 
             */
            
            ps.removeAllValue();
            sbfs.delete( 0, sbfs.length() );
            sbfs.append( " DELETE FROM SADDR    \n" );
            sbfs.append( "  WHERE CODE_NO   = ? \n" );  setParamSql( ps , "S" , headerData,  "seller_user_id" , "" );  
            sbfs.append( "    AND CODE_TYPE = ? \n" );  setParamSql( ps , "S" , "3"                                );
            
            ps.doDelete(sbfs.toString());
            

            ps.removeAllValue();
            sbfs.delete( 0, sbfs.length() );
            sbvl.delete( 0, sbvl.length() );

            sbfs.append( "INSERT INTO SADDR(     \n" );
            sbfs.append( "          HOUSE_CODE   \n" );  sbvl.append( "     ?   \n" );  setParamSql( ps , "S" , "000");
            sbfs.append( "        , CODE_NO      \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "seller_user_id" , "" );    
            sbfs.append( "        , CODE_TYPE    \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , "3"                                );                
            sbfs.append( "        , ZIP_CODE     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "zip_code"       , "" );          
            sbfs.append( "        , PHONE_NO1    \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtPhoneNo1                      );       
            sbfs.append( "        , FAX_NO       \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtFaxNo                         );          
            sbfs.append( "        , HOMEPAGE     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "homepage"       , "" );       
            sbfs.append( "        , ADDRESS_LOC  \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "address_loc"    , "" );       
            sbfs.append( "        , ADDRESS_TEXT \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "address_text"   , "" );       
            sbfs.append( "        , CEO_NAME_LOC \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "ceo_name_loc"   , "" );       
            sbfs.append( "        , EMAIL        \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtEmail                         );       
            sbfs.append( "        , ZIP_BOX_NO   \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , ""                                 );                
            sbfs.append( "        , PHONE_NO2    \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtPhoneNo2                      );       
            sbfs.append( "        , ADDRESS_ENG  \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "address_eng"    , "" );       
            sbfs.append( "        , CEO_NAME_ENG \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , ""                                 );                
            sbfs.append( "        , COMPANY_CODE \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , buyer_company_code                 );                           
            sbfs.append( "        , PLANT_CODE   \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , buyer_plant_code                   );
            sbfs.append( "        , ADD_DATE     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , nowDate                            );
            sbfs.append( "        , ADD_TIME     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , nowTime                            );
            sbfs.append( "        , ADD_USER_ID  \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , USER_ID                            );
            sbfs.append( "        ) VALUES (     \n" );  sbvl.append( "   )     \n" );

            ps.doInsert( sbfs.toString() + sbvl.toString() );


            
            
            
            /* ********************************************************************************************************************************************************************
             * 주소의 정보를 DELETE 입력 후 재 등록 처리.
             * 
             * 기 등록 SADDR(CODE_TYPE = 2) 삭제 후 입력
             * SADDR(CODE_TYPE = 2) 입력
             * 
             */
            ps.removeAllValue();
            sbfs.delete( 0, sbfs.length() );
            sbfs.append( " DELETE FROM SADDR    \n" );
            sbfs.append( "  WHERE CODE_NO   = ? \n" ); setParamSql( ps , "S" , seller_code );
            sbfs.append( "    AND CODE_TYPE = ? \n" ); setParamSql( ps , "S" , "2"         );
            
            ps.doDelete(sbfs.toString());
            

            ps.removeAllValue();
            sbfs.delete( 0, sbfs.length() );
            sbvl.delete( 0, sbvl.length() );

            sbfs.append( "INSERT INTO SADDR(     \n" );
            sbfs.append( "          HOUSE_CODE   \n" );  sbvl.append( "     ?   \n" );  setParamSql( ps , "S" , house_code                         );
            sbfs.append( "        , CODE_NO      \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , seller_code                        );    
            sbfs.append( "        , CODE_TYPE    \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , "2"                                );                
            sbfs.append( "        , ZIP_CODE     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "zip_code"       , "" );          
            sbfs.append( "        , PHONE_NO1    \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtPhoneNo1                      );       
            sbfs.append( "        , FAX_NO       \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtFaxNo                         );          
            sbfs.append( "        , HOMEPAGE     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "homepage"       , "" );       
            sbfs.append( "        , ADDRESS_LOC  \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "address_loc"    , "" );       
            sbfs.append( "        , ADDRESS_TEXT \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "address_text"   , "" );       
            sbfs.append( "        , CEO_NAME_LOC \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "ceo_name_loc"   , "" );       
            sbfs.append( "        , EMAIL        \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtEmail                         );       
            sbfs.append( "        , ZIP_BOX_NO   \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , ""                                 );                
            sbfs.append( "        , PHONE_NO2    \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , susmtPhoneNo2                      );       
            sbfs.append( "        , ADDRESS_ENG  \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , headerData,  "address_eng"    , "" );       
            sbfs.append( "        , CEO_NAME_ENG \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , ""                                 );                
            sbfs.append( "        , COMPANY_CODE \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , buyer_company_code                 );                           
            sbfs.append( "        , PLANT_CODE   \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , buyer_plant_code                   );
            sbfs.append( "        , ADD_DATE     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , nowDate                            );
            sbfs.append( "        , ADD_TIME     \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , nowTime                            );
            sbfs.append( "        , ADD_USER_ID  \n" );  sbvl.append( "   , ?   \n" );  setParamSql( ps , "S" , USER_ID                            );                    
            sbfs.append( "        ) VALUES (     \n" );  sbvl.append( "   )     \n" );
            
            ps.doInsert( sbfs.toString() + sbvl.toString() );

            
            
            
            /* ********************************************************************************************************************************************************************
             * 담당자정보(SSUPI)에 작성자를 기본으로 등록 (2013-11-29 추가)
             *
             * 수정일때는 담당자 정보를 생성하지 않는다
             * 
             */
            // seq 생성
            if( "INSERT".equals( strType ) ) {
                ps.removeAllValue();
                sbfs.delete(0, sbfs.length());
                
                sbfs.append(                  " SELECT " + DB_NULL_FUNCTION + "(MAX(TO_NUMBER(SEQ)),0)+ 1 \n ");
                sbfs.append(                  "   FROM SSUPI                                              \n ");
                sbfs.append( ps.addFixString( "  WHERE COMPANY_CODE = ?                                   \n ")); setParamSql( ps , "S" , buyer_company_code );
                sbfs.append( ps.addFixString( "    AND SELLER_CODE  = ?                                   \n ")); setParamSql( ps , "S" , seller_code        );
                
                sf = new SepoaFormater( ps.doSelect_limit( sbfs.toString() ) );
                String maxSeq = sf.getValue(0, 0);
                
                // seq 번호의 중복방지를 위해 데이터 삭제 후 재 등록 한다.
                ps.removeAllValue();
                sbfs.delete(0, sbfs.length());
                
                sbfs.append(" DELETE FROM SSUPI        \n");
                sbfs.append("  WHERE COMPANY_CODE = ?  \n");    setParamSql( ps , "S" , buyer_company_code );
                sbfs.append("    AND SELLER_CODE  = ?  \n");    setParamSql( ps , "S" , seller_code        );
                sbfs.append("    AND SEQ          = ?  \n");    setParamSql( ps , "S" , maxSeq             );
                
                ps.doDelete(sbfs.toString());
                
                
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbvl.delete( 0, sbvl.length() );
                sbfs.append(" INSERT INTO SSUPI (      \n ");
                sbfs.append( "     HOUSE_CODE          \n" );  sbvl.append("    ?    \n" );     setParamSql( ps , "S" , "000"                             );
                sbfs.append("    , COMPANY_CODE        \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , buyer_company_code                );    // 회사코드
                sbfs.append("    , PLANT_CODE          \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , buyer_plant_code                  );    // 사업장코드
                sbfs.append("    , SELLER_CODE         \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , seller_code                       );    // 채번한 번호
                sbfs.append("    , SEQ                 \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , maxSeq                            );    // SEQ
                sbfs.append("    , USER_NAME           \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , headerData,  "user_name_loc" , "" );    // 담당자 성명
                sbfs.append("    , DIVISION            \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , headerData,  "dept_name"     , "" );    // 부서
                sbfs.append("    , PHONE_NO            \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , susmtPhoneNo1                     );    // 전화 번호
                sbfs.append("    , EMAIL               \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , susmtEmail                        );    // 이메일
                sbfs.append("    , MOBILE_NO           \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , susmtMobileNo                     );    // 핸드폰 번호
                sbfs.append("    , FAX_NO              \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , susmtFaxNo                        );    // 팩스번호
                sbfs.append("    , DEL_FLAG            \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , commonUtilFlagNo                  );
                sbfs.append("    , TAX_PIC_FLAG        \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , commonUtilFlagNo                  );    // TAX_PIC_FLAG ~ FOREIGN_PIC_FLA 
                sbfs.append("    , SALES_PIC_FLAG      \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , commonUtilFlagNo                  );    // 처음등록시 N                       
                sbfs.append("    , QM_PIC_FLAG         \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , commonUtilFlagNo                  );    // 수정시에는 Y 로 된다.                 
                sbfs.append("    , SALES_TOP_PIC_FLAG  \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , commonUtilFlagNo                  );   
                sbfs.append("    , PP_PIC_FLAG         \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , commonUtilFlagNo                  );   
                sbfs.append("    , FOREIGN_PIC_FLAG    \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , commonUtilFlagNo                  );  
                sbfs.append("    , ADD_DATE            \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , nowDate                           );    // 등록일
                sbfs.append("    , ADD_TIME            \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , nowTime                           );    // 등록시간
                sbfs.append("    , ADD_USER_ID         \n ");  sbvl.append("  , ?    \n ");     setParamSql( ps , "S" , USER_ID                           );    // 등록자 ID   
                sbfs.append("   ) VALUES (             \n ");  sbvl.append("  )      \n ");
                
                ps.doInsert(sbfs.toString() + sbvl.toString() );
                
            } // end if
            
            setStatus( 1 );
            setFlag( true );
            setMessage( msg.get( "MESSAGE.0001" ).toString() );
            setValue( MapUtils.getString( headerData, "seller_code", "" ) );
            
            Commit();

        } catch( Exception e ) {
            Rollback();
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
//            e.printStackTrace( System.out );
            /*e.getCause().printStackTrace( System.out );*/
        }

        return getSepoaOut();

    } // end of method setSellerEvalList1


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /**
       @Method Name : getSellerEvalList2
       @설명 : 수주실적 조회
       @수정일 : 2013 . 03
       @
     **/
    public SepoaOut getSellerEvalList2(Map< String, String > header)
    {
        ConnectionContext ctx = getConnectionContext();
        setStatus(1);
        setFlag( true );
        
        try
        {
            ParamSql     ps      = new ParamSql( info.getSession( "ID" ), this, ctx );
            StringBuffer sql     = new StringBuffer();
            String       flagNo  = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String       flagYes = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();        

            sql.append(                     " SELECT SELLER_CODE                                       \n");
            sql.append(                     "      , SEQ                                               \n");
            sql.append(                     "      , BUSINESS_TYPE                                     \n");
            sql.append(                     "      , CUR                                               \n");
            sql.append(                     "      , ENT_FROM_DATE                                     \n");
            sql.append(                     "      , ENT_TO_DATE                                       \n");
            sql.append(                     "      , MAIN_CONT_NAME                                    \n");
            sql.append(                     "      , PROJECT_AMT                                       \n");
            sql.append(                     "      , PROJECT_NAME                                      \n");
            sql.append(                     "      , PROJECT_TYPE                                      \n");
            sql.append(                     "      , PROJECT_YEAR                                      \n");
            sql.append(                     "      , REMARK                                            \n");
            sql.append(                     "      , CUSTOMER_NAME                                     \n");
            sql.append(                     "      , ATTACH_NO                                         \n");
            sql.append(                     "      , ( SELECT COUNT(*)                                 \n");
            sql.append(                     "            FROM SFILE                                    \n");
            sql.append(                     "           WHERE DOC_NO = SSUPJ.ATTACH_NO                 \n");
            sql.append(                     "        )                                 ATTACH_NO_COUNT \n");
            sql.append(                     "   FROM SSUPJ                                             \n");
            sql.append( ps.addFixString(    "  WHERE " + DB_NULL_FUNCTION + "( DEL_FLAG , ? )          \n"));     setParamSql( ps , "S" , flagNo                      );
            sql.append( ps.addFixString(    "                                           = ?            \n"));     setParamSql( ps , "S" , flagNo                      );
            sql.append( ps.addSelectString( "    AND SELLER_CODE                        = ?            \n"));     setParamSql( ps , "S" , header , "seller_code" , "" );
            sql.append(                     " ORDER BY SEQ                                             \n");
            
            setValue( ps.doSelect( sql.toString() ) );

        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
            
        }

        return getSepoaOut();
        
    } // end of method setSellerEvalList1

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /**
       @Method Name : setSellerEvalList2
       @ 수주실적 등록
       @ 수정일 : 2013 . 03
       @
       
       기존 로직 제거
       delete -> insert 로 변경.
       
       max + 1 의 데이터 삭제.
       max + 1 로 insert 처리.
       
       grid 상에서 삭제 데이터는 delete flag update
       현재 화면상이나 로직상 해당 데이터 발생시 update 정상적으로 수행 되지 않음.
       
     **/
    public SepoaOut setSellerEvalList2(Map allData) throws Exception
    {
        ConnectionContext ctx                   = getConnectionContext();
        SepoaFormater sf                        = null;

        Map<String, String>         gridRowData        = null;
        Map<String, String>         header      = null;
        List<Map<String, String>>   gridData    = null;

        try
        {
            header                  = MapUtils.getMap(allData, "headerData", null);
            gridData                = (List<Map<String,String>>)MapUtils.getObject(allData, "gridData");

            ParamSql ps             = new ParamSql(info.getSession("ID"), this, ctx);
            StringBuffer sqlSq      = new StringBuffer();
            StringBuffer sqlVl      = new StringBuffer();


            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            sqlVl.delete(0, sqlVl.length());
            
            sqlSq.append(" DELETE FROM SSUPJ        \n");
            sqlSq.append("  WHERE SELLER_CODE = ?   \n"); setParamSql( ps , "S" , header , "seller_code" , "" );
            
            ps.doDelete( sqlSq.toString() );
            
            for (int i = 0 , index = 1; i < gridData.size(); i++, index++){
                gridRowData = (Map <String , String>) gridData.get(i);
                gridRowData.put( "ENT_FROM_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( gridRowData, "ENT_FROM_DATE", "" ) ) );
                gridRowData.put( "ENT_TO_DATE"  , SepoaString.getDateUnSlashFormat( MapUtils.getString( gridRowData, "ENT_TO_DATE"  , "" ) ) );

                ps.removeAllValue();
                sqlSq.delete(0, sqlSq.length());
                sqlVl.delete(0, sqlVl.length());
                
                sqlSq.append(" INSERT INTO SSUPJ  ( \n ");
                sqlSq.append("   SELLER_CODE        \n ");  sqlVl.append("   ?  \n "); setParamSql( ps , "S" , header     , "seller_code"      , "" ); // 회사코드
                sqlSq.append("   , SEQ              \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , "" + index                           ); // 항번
                sqlSq.append("   , BUSINESS_TYPE    \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "BUSINESS_TYPE"    , "" ); // 기업군
                sqlSq.append("   , CUR              \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "CUR"              , "" ); // 통화
                sqlSq.append("   , CUSTOMER_NAME    \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "CUSTOMER_NAME"    , "" ); // 고객사
                sqlSq.append("   , ENT_FROM_DATE    \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "ENT_FROM_DATE"    , "" ); // 수주시작일
                sqlSq.append("   , ENT_TO_DATE      \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "ENT_TO_DATE"      , "" ); // 수주종료일
                sqlSq.append("   , MAIN_CONT_NAME   \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "MAIN_CONT_NAME"   , "" ); // 주계약자
                sqlSq.append("   , PROJECT_AMT      \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "PROJECT_AMT"      , "" ); // 수주금액
                sqlSq.append("   , PROJECT_NAME     \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "PROJECT_NAME"     , "" ); // 프로젝트명
                sqlSq.append("   , PROJECT_TYPE     \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "PROJECT_TYPE"     , "" ); // 수주종류
                sqlSq.append("   , PROJECT_YEAR     \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "PROJECT_YEAR"     , "" ); // 년도
                sqlSq.append("   , REMARK           \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , gridRowData, "REMARK"           , "" ); // 수주내역
                sqlSq.append("   , ATTACH_NO_COUNT  \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , header     , "attach_no_count"  , "" ); // 첨부파일갯수
                sqlSq.append("   , ATTACH_NO        \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , header     , "attach_no"        , "" ); // 첨부파일
                sqlSq.append("   , ADD_DATE         \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , SepoaDate.getShortDateString()       ); // 등록일
                sqlSq.append("   , ADD_TIME         \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , SepoaDate.getShortTimeString()       ); // 등록시간
                sqlSq.append("   , ADD_USER_ID      \n ");  sqlVl.append(" , ?  \n "); setParamSql( ps , "S" , info.getSession("ID")                ); // 등록자 ID
                sqlSq.append(" ) VALUES (           \n ");  sqlVl.append(" )    \n "); 
                
                ps.doInsert( sqlSq.toString() + sqlVl.toString() );

            } // end of for
            
            Commit();
            setStatus(1);
            setFlag( true );
            
        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            Rollback();
            setMessage( e.getMessage() );
            
            
        } finally {
        }
        
        return getSepoaOut();
        
    } //setSellerEvalList2() end


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
       @Method Name : getSellerEvalList3
       @설명 : 품질인증 조회
       @수정일 : 2013 . 03
       @
     **/
    public SepoaOut getSellerEvalList3(Map< String, String > header)
    {
        ConnectionContext ctx = getConnectionContext();
        setStatus(1);
        setFlag( true );

        String       flagNo  = sepoa.fw.util.CommonUtil.Flag.No.getValue();
        String       flagYes = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();  
        
        try {
            ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );
            
            StringBuffer sql = new StringBuffer();
            
            sql.append(                     " SELECT SELLER_CODE                                       \n");
            sql.append(                     "      , SEQ                                               \n");
            sql.append(                     "      , PASS_DATE                                         \n");
            sql.append(                     "      , EXPIRE_DATE                                       \n");
            sql.append(                     "      , CERTI_NAME                                        \n");
            sql.append(                     "      , CERTI_AGENCY                                      \n");
            sql.append(                     "      , CERTI_NO                                          \n");
            sql.append(                     "      , ATTACH_NO                                         \n");
            sql.append(                     "      , REMARK                                            \n");
            sql.append(                     "      , ( SELECT COUNT(*)                                 \n");
            sql.append(                     "            FROM SFILE                                    \n");
            sql.append(                     "           WHERE DOC_NO = SSUCT.ATTACH_NO                 \n");
            sql.append(                     "        )                                 ATTACH_NO_COUNT \n");
            sql.append(                     "   FROM SSUCT                                             \n");
            sql.append( ps.addFixString(    "  WHERE " + DB_NULL_FUNCTION + "( DEL_FLAG , ? )          \n"));     setParamSql( ps , "S" , flagNo                      );
            sql.append( ps.addFixString(    "                                           = ?            \n"));     setParamSql( ps , "S" , flagNo                      );
            sql.append( ps.addSelectString( "    AND SELLER_CODE                        = ?            \n"));     setParamSql( ps , "S" , header , "seller_code" , "" );
            sql.append(                     " ORDER BY SEQ                                             \n");

            setValue( ps.doSelect( sql.toString() ) );

        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
            
        }

        return getSepoaOut();
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
       @Method Name : setSellerEvalList3
       @ 품질인증 등록
       @ 수정일 : 2013 . 03
       @
       
       delete -> insert 로 변경.
       
     **/
    public SepoaOut setSellerEvalList3(Map allData) throws Exception
    {
        ConnectionContext ctx                   = getConnectionContext();
        SepoaFormater sf                        = null;

        Map<String, String>         gridRowData = null;
        Map<String, String>         header      = null;
        List<Map<String, String>>   gridData    = null;

        try
        {
            header           = MapUtils.getMap(allData, "headerData", null);
            gridData         = (List<Map<String,String>>)MapUtils.getObject(allData, "gridData");

            ParamSql     ps    = new ParamSql(info.getSession("ID"), this, ctx);
            StringBuffer sqlSq = new StringBuffer();
            StringBuffer sqlVl = new StringBuffer();

            String       datePass = null;
            String       flagNo   = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String       flagYes  = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();  
            
            ps.removeAllValue();
            
            sqlSq.delete(0, sqlSq.length());
            sqlSq.append(" DELETE FROM SSUCT      \n");
            sqlSq.append("  WHERE SELLER_CODE = ? \n");ps.addStringParameter(MapUtils.getString(header, "seller_code", ""));
            
            ps.doDelete(sqlSq.toString());
            
            for (int i = 0, index = 1 ; i < gridData.size(); i++,index++){

                gridRowData = (Map <String , String>) gridData.get(i);

                gridRowData.put( "PASS_DATE"  , SepoaString.getDateUnSlashFormat( MapUtils.getString( gridRowData, "PASS_DATE"  , "" ) ) );
                gridRowData.put( "EXPIRE_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( gridRowData, "EXPIRE_DATE", "" ) ) );

                ps.removeAllValue();
                sqlSq.delete(0, sqlSq.length());
                sqlVl.delete(0, sqlVl.length());
                
                sqlSq.append(" INSERT INTO SSUCT  ( \n ");
                sqlSq.append("   SELLER_CODE        \n "); sqlVl.append("    ?  \n "); setParamSql( ps , "S" , header     , "seller_code"     , "" );  // 회사코드
                sqlSq.append(" , SEQ                \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , "" + index                          );  // 항번
                sqlSq.append(" , PASS_DATE          \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , gridRowData, "PASS_DATE"       , "" );  // 취득일자
                sqlSq.append(" , EXPIRE_DATE        \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , gridRowData, "EXPIRE_DATE"     , "" );  // 만료일자
                sqlSq.append(" , CERTI_NAME         \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , gridRowData, "CERTI_NAME"      , "" );  // 인증명
                sqlSq.append(" , CERTI_AGENCY       \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , gridRowData, "CERTI_AGENCY"    , "" );  // 인증기관
                sqlSq.append(" , CERTI_NO           \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , gridRowData, "CERTI_NO"        , "" );  // 인증번호 
                sqlSq.append(" , REMARK             \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , gridRowData, "REMARK"          , "" );  // 특기사항/비고
                sqlSq.append(" , ATTACH_NO          \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , header     , "attach_no"       , "" );  // 첨부파일
                sqlSq.append(" , ATTACH_NO_COUNT    \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , header     , "attach_no_count" , "" );  // 첨부파일 갯수
                sqlSq.append(" , ADD_DATE           \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , SepoaDate.getShortDateString()      );  // 등록일
                sqlSq.append(" , ADD_TIME           \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , SepoaDate.getShortTimeString()      );  // 등록시간
                sqlSq.append(" , ADD_USER_ID        \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , info.getSession("ID")               );  // 등록자 ID
                sqlSq.append(" , DEL_FLAG           \n "); sqlVl.append("  , ?  \n "); setParamSql( ps , "S" , flagNo                              );  
                sqlSq.append(" ) VALUES (           \n "); sqlVl.append("  )    \n ");
                
                ps.doInsert( sqlSq.toString() + sqlVl.toString() );

            } // end of for
            
            Commit();
            setStatus(1);
            setFlag( true );
            
        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            Rollback();
            setMessage( e.getMessage() );
            
            
        } finally {
        }
        
        return getSepoaOut();
        
    } //setSellerEvalList3() end

    
    
    
    
    
    
    
    
    
    
    

    
    
    /**
     * SERVICE 등록 조회
     * 호출 되는 파일 없음.
     * 
     * 
     * @param header
     * @return
     */
//    public SepoaOut getSellerEvalList4_popup(Map< String, String > header){
//        ConnectionContext ctx = getConnectionContext();
//        setStatus(1);
//        setFlag( true );
//        try
//        {
//            ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );
//            StringBuffer sql = new StringBuffer();
//            
//            sql.append(" SELECT " + SEPOA_DB_OWNER + "GETLEVELTEXT1('" + constants.LevelCode.FIRST.getValue() + "',MATERIAL_TYPE,'KO') AS SUPPLIER_TYPE                   , \n");
//            sql.append("        " + SEPOA_DB_OWNER + "GETLEVELTEXT1('" + constants.LevelCode.SECOND.getValue() + "',MATERIAL_CTRL_TYPE,'KO') AS CLASS1                    , \n");
//            sql.append("        " + SEPOA_DB_OWNER + "GETLEVELTEXT1('" + constants.LevelCode.THIRD.getValue() + "',MATERIAL_CLASS1,'KO') AS CLASS2                    , \n");
//            sql.append("        MAX(MATERIAL_CLASS2) AS CLASS3                  \n");
//            sql.append(" FROM SMTGL                                             \n");
//            sql.append(" WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'    \n");
//            sql.append( ps.addSelectString( "   AND SELLER_CODE    = ?          \n"));ps.addStringParameter( MapUtils.getString( header, "seller_code", "" ) );
//            sql.append(" AND MATERIAL_TYPE IS NOT NULL  \n");
//            sql.append(" GROUP BY MATERIAL_TYPE,MATERIAL_CTRL_TYPE,MATERIAL_CLASS1  \n");
//            sql.append(" ORDER BY MATERIAL_TYPE,MATERIAL_CTRL_TYPE,MATERIAL_CLASS1  \n");
//
//            setValue( ps.doSelect( sql.toString() ) );
//
//        }
//        catch (Exception e)
//        {
//            setStatus(0);
//            setFlag( false );
//            setMessage(e.getMessage());
//            Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
//        }
//
//        return getSepoaOut();
//        
//    } // end of method getSellerEvalList4_popup
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
       @Method Name : getSellerEvalList4
       @설명 : 서비스 조회
       @수정일 : 2013 . 03
       @
     **/
    public SepoaOut getSellerEvalList4(Map< String, String > header)
    {
        ConnectionContext ctx = getConnectionContext();
        setStatus(1);
        setFlag( true );

        String levelCodeFirst  = constants.LevelCode.FIRST.getValue();
        String levelCodeSecond = constants.LevelCode.SECOND.getValue();
        String levelCodeThird  = constants.LevelCode.THIRD.getValue();
        String levelCodeFour   = constants.LevelCode.FOUR.getValue();
        String levelCodeFive   = constants.LevelCode.FIVE.getValue();

        String flagNo          = sepoa.fw.util.CommonUtil.Flag.No.getValue();
        String flagYes         = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();  
        
        try
        {
            ParamSql     ps  = new ParamSql( info.getSession( "ID" ), this, ctx );
            StringBuffer sql = new StringBuffer();

            sql.append(                " SELECT *                                                                                                                \n");
            sql.append(                "   FROM (                                                                                                                \n");
            sql.append(ps.addFixString("   SELECT CASE WHEN SC.TYPE = ? THEN '1'                                                                                 \n"));    setParamSql( ps , "S" , levelCodeFirst  );
            sql.append(ps.addFixString("               WHEN SC.TYPE = ? THEN '2'                                                                                 \n"));    setParamSql( ps , "S" , levelCodeSecond );
            sql.append(ps.addFixString("               WHEN SC.TYPE = ? THEN '3'                                                                                 \n"));    setParamSql( ps , "S" , levelCodeThird  );
            sql.append(ps.addFixString("               WHEN SC.TYPE = ? THEN '4'                                                                                 \n"));    setParamSql( ps , "S" , levelCodeFour   );
            sql.append(                "               ELSE  '5'                                                                                                 \n");
            sql.append(                "          END                                                                                                AS LVL      \n");
            sql.append(                "        , SC.CODE  AS SG_CODE                                                                                            \n");
            sql.append(                "        , SC.TEXT1 AS SG_TEXT                                                                                            \n");
            sql.append(ps.addFixString("        , CASE SC.TYPE WHEN ?                                                                                            \n"));    setParamSql( ps , "S" , levelCodeFirst  );
            sql.append(                "                       THEN SC.TEXT1                                                                                     \n");
            sql.append(ps.addFixString("                       ELSE " + SEPOA_DB_OWNER + "GETLEVELTEXT1(?,SC.TEXT3,'KO')                                         \n"));    setParamSql( ps , "S" , levelCodeFirst  );
            sql.append(                "          END                                                                                                AS SG_CODE1 \n");
            sql.append(ps.addFixString("        , CASE SC.TYPE WHEN ?                                                                                            \n"));    setParamSql( ps , "S" , levelCodeSecond );
            sql.append(                "                       THEN SC.TEXT1                                                                                     \n");
            sql.append(ps.addFixString("                       ELSE " + SEPOA_DB_OWNER + "GETLEVELTEXT1(?,SC.TEXT3||SC.TEXT4,'KO')                               \n"));    setParamSql( ps , "S" , levelCodeSecond );
            sql.append(                "          END                                                                                                AS SG_CODE2 \n");
            sql.append(ps.addFixString("        , CASE SC.TYPE WHEN ?                                                                                            \n"));    setParamSql( ps , "S" , levelCodeThird  );
            sql.append(                "                       THEN SC.TEXT1                                                                                     \n");
            sql.append(ps.addFixString("                       ELSE " + SEPOA_DB_OWNER + "GETLEVELTEXT1(?,SC.TEXT3||SC.TEXT4||SC.TEXT5,'KO')                     \n"));    setParamSql( ps , "S" , levelCodeThird  );
            sql.append(                "          END                                                                                                AS SG_CODE3 \n");
            sql.append(ps.addFixString("        , CASE SC.TYPE WHEN ?                                                                                            \n"));    setParamSql( ps , "S" , levelCodeFour   );
            sql.append(                "                       THEN SC.TEXT1                                                                                     \n");
            sql.append(ps.addFixString("                       ELSE " + SEPOA_DB_OWNER + "GETLEVELTEXT1(?,SC.TEXT3||SC.TEXT4||SC.TEXT5||SC.TEXT6,'KO')           \n"));    setParamSql( ps , "S" , levelCodeFour   );
            sql.append(                "          END                                                                                                AS SG_CODE4 \n");
            sql.append(ps.addFixString("        , CASE SC.TYPE WHEN ?                                                                                            \n"));    setParamSql( ps , "S" , levelCodeFive   );
            sql.append(                "                       THEN SC.TEXT1                                                                                     \n");
            sql.append(ps.addFixString("                       ELSE " + SEPOA_DB_OWNER + "GETLEVELTEXT1(?,SC.TEXT3||SC.TEXT4||SC.TEXT5||SC.TEXT6||SC.TEXT7,'KO') \n"));    setParamSql( ps , "S" , levelCodeFive   );
            sql.append(                "          END                                                                                                AS SG_CODE5 \n");
            sql.append(                "        , CASE WHEN GSL.SG_CODE IS NULL THEN '0'                                                                         \n");
            sql.append(                "                                        ELSE '1'                                                                         \n");
            sql.append(                "          END                                                                                                AS SELECTED \n");
            sql.append(ps.addFixString("     FROM SLVEL SC LEFT OUTER JOIN SSGSL GSL ON GSL.COMPANY_CODE = ?                                                     \n"));    setParamSql( ps , "S" , header , "seller_code", "" );
            sql.append(                "                                            AND SC.CODE          =  GSL.SG_CODE                                          \n");
            sql.append(                "    WHERE SC.TYPE    IN (                                                                                                \n");
            sql.append(                "                          '______________________________________________'                                               \n");
            sql.append(ps.addFixString("                        , ?                                                                                              \n"));    setParamSql( ps , "S" , levelCodeFirst  );
            sql.append(ps.addFixString("                        , ?                                                                                              \n"));    setParamSql( ps , "S" , levelCodeSecond );
            sql.append(ps.addFixString("                        , ?                                                                                              \n"));    setParamSql( ps , "S" , levelCodeThird  );
            sql.append(ps.addFixString("                        , ?                                                                                              \n"));    setParamSql( ps , "S" , levelCodeFour   );
            sql.append(ps.addFixString("                        , ?                                                                                              \n"));    setParamSql( ps , "S" , levelCodeFive   );
            sql.append(                "                        )                                                                                                \n");
            sql.append(ps.addFixString("      AND SC.USE_FLAG = ?                                                                                                \n"));    setParamSql( ps , "S" , flagYes         );
            sql.append(ps.addFixString("      AND SC.DEL_FLAG = ?                                                                                                \n"));    setParamSql( ps , "S" , flagNo          );
            sql.append(                "    ORDER BY SC.CODE                                                                                                     \n");
            sql.append(                "        )                                                                                                                \n");
            
    		setValue( ps.doSelect( sql.toString() ) );

        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
            
        }

        return getSepoaOut();
        
    } // end of method getSellerEvalList4
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /**
       @Method Name : setSellerEvalList4
       @ 서비스 등록
       @ 수정일 : 2013 . 03
       @
     **/
    public SepoaOut setSellerEvalList4(Map allData) throws Exception
    {
        ConnectionContext ctx                   = getConnectionContext();
        SepoaFormater     sf                    = null;
        Map<String, String>         gridRowData = null;
        Map<String, String>         header      = null;
        List<Map<String, String>>   gridData    = null;
        
        try {
            header                  = MapUtils.getMap(allData, "headerData", null);
            gridData                = (List<Map<String,String>>)MapUtils.getObject(allData, "gridData");
            ParamSql ps             = new ParamSql(info.getSession("ID"), this, ctx);
            
            StringBuffer sqlSq      = new StringBuffer();
            StringBuffer sqlVl      = new StringBuffer();

            String       devPlant   = sepoa.svc.common.constants.DEFAULT_PLANT_CODE;
            String       flagNo     = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String       flagYes    = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();  
            
            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            
            sqlSq.append(" DELETE FROM SSGSL       \n");
            sqlSq.append("  WHERE SELLER_CODE = ?  \n");ps.addStringParameter(MapUtils.getString(header, "seller_code", ""));
            
            ps.doDelete(sqlSq.toString());
            
          //Logger.sys.println( "gridData.size() value ["+gridData.size()+"]");
            
            int dataLvl = 0;
            
            for (int i = 0; i < gridData.size(); i++){
                gridRowData = (Map <String , String>) gridData.get(i);
                
                ps.removeAllValue();
                sqlSq.delete(0, sqlSq.length());
                sqlVl.delete(0, sqlVl.length());

                dataLvl = Integer.parseInt( MapUtils.getString(gridRowData, "LVL", "0") );
                
                if( dataLvl < 2 ) {
                    continue;
                    
                } // end if
                
                sqlSq.append(" INSERT INTO SSGSL  ( \n ");
                sqlSq.append("   COMPANY_CODE       \n ");  sqlVl.append("   ?  \n ");    setParamSql( ps , "S" , header     , "seller_code", "" );
                sqlSq.append(" , PLANT_CODE         \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , devPlant                       );
                sqlSq.append(" , SELLER_CODE        \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , header     , "seller_code", "" );
                sqlSq.append(" , SG_CODE            \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , gridRowData, "SG_CODE"    , "" );
                sqlSq.append(" , SG_CODE1           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , gridRowData, "SG_CODE1"   , "" );
                sqlSq.append(" , SG_CODE2           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , gridRowData, "SG_CODE2"   , "" );
                sqlSq.append(" , SG_CODE3           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , gridRowData, "SG_CODE3"   , "" );
                sqlSq.append(" , SG_CODE4           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , gridRowData, "SG_CODE4"   , "" );
                sqlSq.append(" , SG_CODE5           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , gridRowData, "SG_CODE5"   , "" );
                sqlSq.append(" , ADD_DATE           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , SepoaDate.getShortDateString() );
                sqlSq.append(" , ADD_TIME           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , SepoaDate.getShortTimeString() );
                sqlSq.append(" , ADD_USER_ID        \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , info.getSession( "ID" )        );
                sqlSq.append(" , DEL_FLAG           \n ");  sqlVl.append(" , ?  \n ");    setParamSql( ps , "S" , flagNo                         );
                sqlSq.append(" ) VALUES (           \n ");  sqlVl.append(" )    \n ");                                                                               
                
                ps.doInsert(sqlSq.toString() + sqlVl.toString() );
                
            } // end of for

            Commit();
            setStatus(1);
            setFlag( true );
        
        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            Rollback();
            setMessage( e.getMessage() );
            
            
        } finally {
        }
                
        return getSepoaOut();
        
    } //setSellerEvalList4() end



    
    
    
    
    
    
    
    
    

    /**
       @Method Name : getSellerEvalList5
       @설명 : 담당자 조회
       @수정일 : 2013 . 03
       @
    **/
    public SepoaOut getSellerEvalList5(Map< String, String > header)
    {
        setStatus(1);
        setFlag( true );
        ConnectionContext ctx = getConnectionContext();
        try
        {
            
            String delFlag    = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String sellerCode = MapUtils.getString( header, "seller_code", "" );
            
            ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );
            StringBuffer sql = new StringBuffer();
            sql.append(                     " SELECT COMPANY_CODE                             \n");
            sql.append(                     "      , USER_NAME                                \n");
            sql.append(                     "      , DIVISION                                 \n");
            sql.append(                     "      , POSITION                                 \n");
            sql.append(                     "      , PHONE_NO                                 \n");
            sql.append(                     "      , EMAIL                                    \n");
            sql.append(                     "      , MOBILE_NO                                \n");
            sql.append(                     "      , FAX_NO                                   \n");
            sql.append(                     "      , SELLER_CODE                              \n");
            sql.append(                     "      , SEQ		                              \n");
            sql.append(                     "      , DEL_FLAG    	                          \n");
            sql.append(                     "      , ATTN_PIC_FLAG                            \n");
            sql.append(                     "   FROM SSUPI                                    \n");
            sql.append( ps.addFixString(    "  WHERE " + DB_NULL_FUNCTION + "( DEL_FLAG , ? ) \n"));     setParamSql( ps , "S" , delFlag    );
            sql.append( ps.addFixString(    "                                           = ?   \n"));     setParamSql( ps , "S" , delFlag    );
            sql.append( ps.addSelectString( "    AND SELLER_CODE                        = ?   \n"));     setParamSql( ps , "S" , sellerCode );            
            sql.append(                     "  ORDER BY SEQ                                   \n");

            setValue( ps.doSelect( sql.toString() ) );

        }
        catch (Exception e)
        {
            setStatus(0);
            setFlag( false );
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
        }

        return getSepoaOut();
        
    } // end of methdo getSellerEvalList5

    
    
    
    
    
    
    
    
    
    
    
    

    /**
       @Method Name : setSellerEvalList5
       @ 담당자정보 등록
       @ 수정일 : 2013 . 03
       @
    **/
    public SepoaOut setSellerEvalList5(Map allData) throws Exception
    {
        ConnectionContext ctx                   = getConnectionContext();
        SepoaFormater sf                        = null;

        Map<String, String>         gridRowData = null;
        Map<String, String>         header      = null;
        List<Map<String, String>>   gridData    = null;

        try {
            header                     = MapUtils.getMap(allData, "headerData", null);
            gridData                   = (List<Map<String,String>>)MapUtils.getObject(allData, "gridData");
                               
            
            ParamSql     ps            = new ParamSql(info.getSession("ID"), this, ctx);
            StringBuffer sqlSq         = new StringBuffer();
            StringBuffer sqlVl         = new StringBuffer();
                                       
            String       flagNo        = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String       flagYes       = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();  
            String       defPlant      = sepoa.svc.common.constants.DEFAULT_PLANT_CODE;
            String       ssuplPhoneNo  = "";
            String       ssupiEMail    = "";
            String       ssupiMobileNo = "";
            String       ssupiFaxNo    = "";
            String		 ATTN_PIC_FLAG = "";
            
            
            
            
            

            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // -------------------------------------------------------------------------------------------------------------------------------------------- SSUPI 초기화
            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            
            sqlSq.append(" DELETE FROM SSUPI      \n");
            sqlSq.append("  WHERE SELLER_CODE = ? \n");      setParamSql( ps , "S" , header , "seller_code" , "" );
            
            ps.doDelete(sqlSq.toString());


            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // ------------------------------------------------------------------------------------------------------------------------------------- 내외자 구분 값 조회
            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            sqlVl.delete(0, sqlVl.length());
            
            sqlSq.append(                " SELECT SHIPPER_TYPE    \n ");
            sqlSq.append(                "   FROM SSUGL           \n ");
            sqlSq.append(ps.addFixString("  WHERE SELLER_CODE = ? \n " )); setParamSql( ps , "S" , header , "seller_code" , "" );   // 핸드폰 번호
            
            sf = new SepoaFormater( ps.doSelect(sqlSq.toString() ) );
            
            
            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // -------------------------------------------------------------------------------------------------------------------- 내외자 구분 값에 따른 자동 승인 로직
            if( "O".equals( sf.getValue( "SHIPPER_TYPE" , 0 ) ) ){	//외자업체에서 자동 승인한다.
                //자동 승인
                ps.removeAllValue();
                sqlSq.delete(0, sqlSq.length());
                sqlSq.append(" UPDATE SSUGL SET SIGN_STATUS = '" + sepoa.svc.common.constants.SignStatus.ApproveSuccess_Regist.getValue() + "'      \n");
                sqlSq.append("  WHERE SELLER_CODE = ? \n");      setParamSql( ps , "S" , header , "seller_code" , "" );
                ps.doUpdate(sqlSq.toString());
                
            } // end if
            

            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // ---------------------------------------------------------------------------------------------------------------------------------------------------------
            // ------------------------------------------------------------------------------------------------------------------------------------- SSUPI 데이터 INSERT
            for (int i = 0, index = 1 ; i < gridData.size(); i++ , index++ ){
    
                gridRowData = (Map <String , String>) gridData.get(i);

                ssuplPhoneNo  = SepoaString.encString ( MapUtils.getString(gridRowData, "PHONE_NO" , "")  , "PHONE" );
                ssupiEMail    = SepoaString.encString ( MapUtils.getString(gridRowData, "EMAIL"    , "")  , "EMAIL" );
                ssupiMobileNo = SepoaString.encString ( MapUtils.getString(gridRowData, "MOBILE_NO", "")  , "PHONE" );
                ssupiFaxNo    = SepoaString.encString ( MapUtils.getString(gridRowData, "FAX_NO"   , "")  , "PHONE" );
                ATTN_PIC_FLAG = MapUtils.getString(gridRowData, "ATTN_PIC_FLAG"   , "");
                
                if("0".equals(ATTN_PIC_FLAG)){
                	ATTN_PIC_FLAG = "N";
                }else{
                	ATTN_PIC_FLAG = "Y";
                }
                
                ps.removeAllValue();
                sqlSq.delete(0, sqlSq.length());
                sqlVl.delete(0, sqlVl.length());
                
                sqlSq.append(" INSERT INTO SSUPI (            \n ");   
                sqlSq.append("   HOUSE_CODE,                  \n ");  sqlVl.append("    ?   \n ");  setParamSql( ps , "S" , "000");   
                sqlSq.append("   COMPANY_CODE,                \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , header, "seller_code"     , "" );   // 회사코드
                sqlSq.append("   PLANT_CODE,                  \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , defPlant                       );   // 사업장코드
                sqlSq.append("   SELLER_CODE,                 \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , header, "seller_code"     , "" );   // 채번한 번호
                sqlSq.append("   SEQ,                         \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , "" + index                     );   // SEQ
                sqlSq.append("   USER_NAME,                   \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , gridRowData, "USER_NAME"  , "" );   // 담당자 성명
                sqlSq.append("   DIVISION,                    \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , gridRowData, "DIVISION"   , "" );   // 부서
                sqlSq.append("   PHONE_NO,                    \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , ssuplPhoneNo                   );   // 전화 번호
                sqlSq.append("   EMAIL,                       \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , ssupiEMail                     );   // 이메일
                sqlSq.append("   MOBILE_NO,                   \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , ssupiMobileNo                  );   // 핸드폰 번호
                sqlSq.append("   FAX_NO,                      \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , ssupiFaxNo                     );   // 팩스번호
                sqlSq.append("   POSITION,                    \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , gridRowData, "POSITION"   , "" );   // 직위
                sqlSq.append("   DEL_FLAG,                    \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , flagNo                         );   
                sqlSq.append("   ADD_DATE,                    \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , SepoaDate.getShortDateString() );   // 등록일
                sqlSq.append("   ADD_TIME,                    \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , SepoaDate.getShortTimeString() );   // 등록시간
                sqlSq.append("   ADD_USER_ID,                 \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , info.getSession("ID")          );   // 등록자 ID
                sqlSq.append("   TAX_PIC_FLAG,                \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , flagNo                         );   // TAX_PIC_FLAG ~ FOREIGN_PIC_FLAG 까지는
                sqlSq.append("   SALES_PIC_FLAG,              \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , flagNo                         );   // 처음등록시 N
                sqlSq.append("   QM_PIC_FLAG,                 \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , flagNo                         );   // 수정시에는 Y 로 된다.
                sqlSq.append("   SALES_TOP_PIC_FLAG,          \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , flagNo                         );   
                sqlSq.append("   PP_PIC_FLAG,                 \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , flagNo                         );   
                sqlSq.append("   FOREIGN_PIC_FLAG,            \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , flagNo                         );
                sqlSq.append("   ATTN_PIC_FLAG             	  \n ");  sqlVl.append("  , ?   \n ");  setParamSql( ps , "S" , ATTN_PIC_FLAG				   );//발주서 메일 담당자
                sqlSq.append(" ) VALUES (                     \n ");  sqlVl.append("  )     \n ");
                
                ps.doInsert(sqlSq.toString() + sqlVl.toString() );
    
            } // end of for
            
            Commit();
            setStatus(1);
            setFlag( true );
            
        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            Rollback();
            setMessage( e.getMessage() );
            
            
        } finally {
        }
            
        return getSepoaOut();
        
     } //setSellerEvalList5() end



    
    
    
    
    
    
    
    
    
    
    
    /**
       @Method Name : getSellerEvalList6
       @설명 : 재무구조 조회
       @수정일 : 2013 . 03
       @
     **/
    public SepoaOut getSellerEvalList6(Map< String, String > headerData) 
    {
        ConnectionContext ctx = getConnectionContext();
        
        try {

            String flagNo      = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String flagYes     = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();  
        	String SELLER_CODE = "";

            ParamSql     ps  = new ParamSql( info.getSession( "ID" ), this, ctx );
            StringBuffer sql = new StringBuffer();
            
            sql.append(                     " SELECT SELLER_CODE                                                   \n");
            sql.append(                     "      , SEQ                                                           \n");
            sql.append(                     "      , TRUST_COMPANY_NAME                                            \n");
            sql.append(                     "      , BASIS_DATE                                                    \n");
            sql.append(                     "      , TRUST_RATE_CODE                                               \n");
            sql.append(                     "      , TRUST_COMPANY_SITE                                            \n");
            sql.append(                     "      , ATTACH_NO                                                     \n");
            sql.append(                     "      , "+SEPOA_DB_OWNER+"GETFILENAMES( ATTACH_NO ) ATTACH_NO_TEXT    \n");
            sql.append(                     "      , (SELECT COUNT(*)                                              \n");
            sql.append(                     "           FROM SFILE                                                 \n");
            sql.append(                     "          WHERE DOC_NO = SSUTR.ATTACH_NO                              \n");
            sql.append(                     "        )                                           ATTACH_NO_COUNT   \n");
            sql.append(                     "   FROM SSUTR                                                         \n");
            sql.append( ps.addFixString(    "  WHERE " + DB_NULL_FUNCTION + "( DEL_FLAG , ? )                      \n"));     setParamSql( ps , "S" , flagNo    );
            sql.append( ps.addFixString(    "                                           = ?                        \n"));     setParamSql( ps , "S" , flagNo    );
            sql.append( ps.addSelectString( "    AND SELLER_CODE                        = ?                        \n"));     setParamSql( ps , "S" , headerData, "seller_code", "" );            
            sql.append(                     "  ORDER BY SEQ                                                        \n");

            setValue( ps.doSelect( sql.toString() ) );
            setStatus(1);
            setFlag( true );
            
        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
            
        }

        return getSepoaOut();
        
    } // end of method getSellerEvalList6

    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /**
       @Method Name : setSellerEvalList6
       @ 재무구조 등록
       @ 수정일 : 2013 . 03
       @
     **/
    public SepoaOut setSellerEvalList6(Map allData) throws Exception
    {
        ConnectionContext ctx                   = getConnectionContext();
        SepoaFormater sf                        = null;

        Map<String, String>         gridRowData = null;
        Map<String, String>         header      = null;
        List<Map<String, String>>   gridData    = null;

        String SELLER_CODE        = "";
        String flagNo             = sepoa.fw.util.CommonUtil.Flag.No.getValue();
        String flagYes            = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
        String jobStatusReqTarget = sepoa.svc.common.constants.JobStatus.ReqTarget.getValue();
        
        try
        {

            ParamSql     ps    = new ParamSql(_USER_ID, this, ctx);
            StringBuffer sqlSq = new StringBuffer();
            StringBuffer sqlVl = new StringBuffer();
            
            header             = MapUtils.getMap(allData, "headerData", null);
            
            if("".equals(header.get("basis_date")) || "NULL".equals(header.get("basis_date")) ){
            	header.put( "basis_date", SepoaDate.getShortDateString());
            }else{
            	header.put( "basis_date", SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "basis_date", "" ) ) );
            }
            

            // seq 생성
            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            
            sqlSq.append(                  " SELECT " + DB_NULL_FUNCTION + "(MAX(TO_NUMBER(SEQ)),0)+ 1 \n" );
            sqlSq.append(                  "   FROM SSUTR                   \n " );
            sqlSq.append( ps.addFixString( "  WHERE SELLER_CODE = ?         \n " )); ps.addStringParameter(MapUtils.getString( header , "seller_code" , "")); // 회사코드
            
            sf = new SepoaFormater( ps.doSelect_limit( sqlSq.toString() ) );
            String maxSeq = sf.getValue(0, 0);

            // seq 번호의 중복방지를 위해 데이터 삭제 후 재 등록 한다.
            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            sqlSq.append(" DELETE FROM SSUTR          \n");
            sqlSq.append("    WHERE SELLER_CODE = ?   \n");ps.addStringParameter(MapUtils.getString(header, "seller_code", ""));
            sqlSq.append("      AND SEQ = ?           \n");ps.addStringParameter(maxSeq);
            //ps.doDelete(sql.toString());
            
            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            sqlVl.delete(0, sqlVl.length());
            sqlSq.append(" INSERT INTO SSUTR  (    \n ");
            sqlSq.append("     SELLER_CODE         \n ");  sqlVl.append("    ?  \n "); ps.addStringParameter(MapUtils.getString( header , "seller_code"       , "")); // 회사코드
            sqlSq.append("   , COMPANY_CODE        \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(_DEFAULT_SELLER_COMPANY_CODE                          ); // 항번
            sqlSq.append("   , SEQ                 \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(maxSeq                                                ); // 항번
            sqlSq.append("   , TRUST_COMPANY_NAME  \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(MapUtils.getString( header , "trust_company_name", "")); // 신용평가 기관명
            sqlSq.append("   , BASIS_DATE          \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(MapUtils.getString( header , "basis_date"        , "")); // 신용평가 기준일
            sqlSq.append("   , TRUST_RATE_CODE     \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(MapUtils.getString( header , "trust_rate_code"   , "")); // 신용평가 등급
            sqlSq.append("   , TRUST_COMPANY_SITE  \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(MapUtils.getString( header , "trust_company_site", "")); // 신용평가기관 사이트 주소
            sqlSq.append("   , ATTACH_NO           \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(MapUtils.getString( header , "attach_no"         , "")); // 신용평가서 자료첨부
            sqlSq.append("   , ADD_DATE            \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(SepoaDate.getShortDateString()                        ); // 등록일
            sqlSq.append("   , ADD_TIME            \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(SepoaDate.getShortTimeString()                        ); // 등록시간
            sqlSq.append("   , ADD_USER_ID         \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(_USER_ID                                              ); // 등록자 ID
            sqlSq.append("   , DEL_FLAG            \n ");  sqlVl.append("  , ?  \n "); ps.addStringParameter(flagNo                                                ); 
            sqlSq.append(" ) VALUES (              \n ");  sqlVl.append("  )    \n "); 
            

            ps.doInsert(sqlSq.toString() + sqlVl.toString() );
            
            
            // 등록된 데이터 이전의 데이터는 모두 DELETE 처리 해 준다.
            ps.removeAllValue();
            sqlSq.delete(0, sqlSq.length());
            sqlVl.delete(0, sqlVl.length());
            sqlSq.append(" UPDATE SSUTR                             \n ");
            sqlSq.append("   SET DEL_FLAG    = ?                    \n ");  ps.addStringParameter( flagYes                                         );
            sqlSq.append(" WHERE SELLER_CODE = ?                    \n ");  ps.addStringParameter( MapUtils.getString( header , "seller_code" , "")); // 회사코드
            sqlSq.append("   AND TO_NUMBER( SEQ ) < TO_NUMBER( ? )  \n ");  ps.addStringParameter( maxSeq                                          );

            ps.doUpdate( sqlSq.toString() );

            if( jobStatusReqTarget.equals( MapUtils.getString( header, "type", "" ) ) ){
                // 신청 완료 버튼일 경우에는 SSUGL 의 상태를  신청대상 으로 UPDATE
                ps.removeAllValue();
                sqlSq.delete(0, sqlSq.length());
                sqlSq.append(" UPDATE SSUGL            \n ");
                sqlSq.append("    SET JOB_STATUS   = ? \n ");  ps.addStringParameter( jobStatusReqTarget                               );
                sqlSq.append("  WHERE SELLER_CODE  = ? \n ");  ps.addStringParameter( MapUtils.getString( header , "seller_code" , "" )); // 회사코드
                sqlSq.append("    AND COMPANY_CODE = ? \n ");  ps.addStringParameter(_DEFAULT_SELLER_COMPANY_CODE                      ); // 항번

                ps.doUpdate( sqlSq.toString() );
                
            } // end if
            
            Commit();

            setValue(SELLER_CODE);
            setStatus(1);
            setFlag( true );
            
        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            Rollback();
            setMessage( e.getMessage() );
            
            
        } finally {
        }
        
        return getSepoaOut();
        
    } //setSellerEvalList6() end


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /**
    @Method Name : checkUserId
    @ 사용자ID 중복체크
    @ 생성일 : 2013 . 04.10 JTY
    @
     **/
    public SepoaOut checkUserId( Map<String, Object> allData ) throws Exception {
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();
        SepoaFormater sf = null;
        String  seller_user_id = "";

        Map<String, String> headerData  = null;

        try {
            ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);

            headerData  = MapUtils.getMap(allData, "headerData", null);
            // 등록여부 확인
            ps.removeAllValue();
            sqlsb.delete(0, sqlsb.length());
            sqlsb.append(                " SELECT                    \n");
            sqlsb.append(                "        COUNT(*)   AS  CNT \n");
            sqlsb.append(                "   FROM SUSMT              \n");
            sqlsb.append(                "  WHERE 1       = 1        \n");
            sqlsb.append(ps.addFixString("    AND USER_ID = ?        \n")); ps.addStringParameter(MapUtils.getString(headerData, "seller_user_id", ""));

            sf = new SepoaFormater(ps.doSelect_limit(sqlsb.toString()));
            int exist_cnt = Integer.parseInt(sf.getValue("CNT", 0));
            String rtn = "";
            if (exist_cnt < 1){
                rtn = "N";
                
            } else {
                rtn = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
                
            } // end if

            setStatus(1);
            setValue(rtn);
            setFlag( true );
            
            setMessage(msg.get("MESSAGE.4885").toString ( ));

        } catch (Exception e) {
            setStatus(0);
            setValue("0");
            setFlag( false );
            setMessage(e.getMessage());
        }

        return getSepoaOut();
        
    } // checkUserId
    
    /**
    @Method Name : checkMainIrsNo
    @ 본사 사업자등록번호 유효성체크
    @ 생성일 : 2013 . 04.10 JTY
    @
     **/
    public SepoaOut checkMainIrsNo( Map<String, Object> allData ) throws Exception {
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();
        SepoaFormater sf = null;
        String  seller_user_id = "";

        Map<String, String> headerData  = null;

        try {
            ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);

            headerData  = MapUtils.getMap(allData, "headerData", null);
            // 등록여부 확인
            ps.removeAllValue();
            sqlsb.delete(0, sqlsb.length());
            
            sqlsb.append(                " SELECT                                        \n");
            sqlsb.append(                "        COUNT(*)   AS  CNT                     \n");
            sqlsb.append(                "   FROM SSUGL                                  \n");
            sqlsb.append(                "  WHERE 1      = 1                             \n");
            sqlsb.append(ps.addFixString("    AND IRS_NO = ?                             \n")); ps.addStringParameter(MapUtils.getString(headerData, "irs_no_main", ""));
            sqlsb.append(                "    AND REPLACE(IRS_NO,'-','')!=SELLER_CODE    \n");

            sf = new SepoaFormater(ps.doSelect_limit(sqlsb.toString()));
            int exist_cnt = Integer.parseInt(sf.getValue("CNT", 0));
            String rtn = "";
            if (exist_cnt < 1){
                rtn = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();
            }
            else{
                rtn = "N";
                
            }

            setStatus(1);
            setValue(rtn);
            setFlag( true );
            setMessage(msg.get("MESSAGE.4885").toString());

        } catch (Exception e) {
            setStatus(0);
            setValue("0");
            setFlag( false );
            setMessage(e.getMessage());
        }

        return getSepoaOut();
    }



    /**
    @Method Name : getFileNames
    @ 첨부파일 리스트
    @ 생성일 : 2013 . 07.08 JTY
    @
     **/
    public SepoaOut getFileNames(  Map<String, Object> allData  ) throws Exception {
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sqlsb = new StringBuffer();
        SepoaFormater sf = null;
        Map<String, String> headerData  = null;

        try {
            ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
            headerData  = MapUtils.getMap(allData, "headerData", null);
            if ( MapUtils.getString ( headerData , MapUtils.getString ( headerData , "only_attach" , "") ) == null ||  "".equals ( MapUtils.getString ( headerData , MapUtils.getString ( headerData , "only_attach" , "") ).trim ( ) ) ){
                headerData.put ( MapUtils.getString ( headerData , "only_attach" ) , "Not" );
            }
            // 등록여부 확인
            ps.removeAllValue();
            sqlsb.delete(0, sqlsb.length());
            sqlsb.append(ps.addSelectString("SELECT " + SEPOA_DB_OWNER + "GETFILENAMES( ? ) AS DATA1 FROM DUAL \n"));
            ps.addStringParameter(MapUtils.getString(headerData, MapUtils.getString(headerData, "only_attach")));
            String result = ps.doSelect(sqlsb.toString());
            sf = new SepoaFormater(result);
            setValue(result);
            setStatus(1);
            setFlag( true );
            setMessage(msg.get("MESSAGE.4885").toString());
            
            if(sf.getRowCount() > 0){
            	if("".equals(sf.getValue("DATA1",0).trim())){
            		setStatus(0);
            		setFlag( false );
            		setValue("0");
            	}
            }else{
            	setStatus(0);
            	setFlag( false );
            	setValue("0");
            }

        } catch (Exception e) {
            setStatus(0);
            setValue("0");
            setFlag( false );
            setMessage(e.getMessage());
            
        }

        return getSepoaOut();
    }

//    /**
//     * SAP전송시 SAP 업체 정보 전달 및 인터페이스 테이블에 로그 기록
//     *
//     * @param allData
//     * @return
//     */
//    public SepoaOut setSellerConfirm( Map< String, Object > allData ) {
//
//        setStatus( 1 );
//        setFlag( true );
//        ConnectionContext   ctx = getConnectionContext();
//        SepoaFormater       sf  = null;
//        StringBuffer        sb  = new StringBuffer();
//
//        int intRtn  = 0;
//
//        Map< String, String > headerData = null;
//
//        try {
//
//            headerData = MapUtils.getMap( allData, "headerData", null );
//
//            ParamSql sm = new ParamSql( info.getSession( "ID" ), this, ctx );
//            String  buyer_company_code  = getConfig( "sepoa.buyer.company.code" );
//
//            // SSUGL 업데이트
//            sm.removeAllValue();
//            sb.delete( 0, sb.length() );
//            sb.append( "UPDATE SSUGL                                          \n" );
//            sb.append( "              SET SELLER_TYPE                 = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "seller_type",                  "" ) );
//            sb.append( "                , SELLER_NAME_LOC             = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "seller_name_loc",              "" ) );
//            sb.append( "                , SELLER_NAME_ENG             = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "seller_name_eng",              "" ) );
//            sb.append( "                , COUNTRY                     = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "country",                      "" ) );
//            sb.append( "                , CITY_CODE                   = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "city_code",                      "" ) );
//            sb.append( "                , IRS_NO                      = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "irs_no",                       "" ) );
//            sb.append( "                , FOUNDATION_DATE             = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "foundation_date", "" ).replaceAll("-", ""));
//            sb.append( "                , INDUSTRY_TYPE               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "industry_type",                "" ) );
//            sb.append( "                , BUSINESS_TYPE               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "business_type",                "" ) );
//            sb.append( "                , MAIN_PRODUCT                = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "main_product",                 "" ) );
//            sb.append( "                , RESIDENT_NO                 = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "resident_no",                  "" ) );
//            sb.append( "                , SHIPPER_TYPE                = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "shipper_type",                 "" ) );
//            sb.append( "                , PAY_TERMS                   = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "pay_terms",                    "" ) );
//            sb.append( "                , DELY_TERMS                  = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "dely_terms",                   "" ) );
//            sb.append( "                , CUR                         = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "cur",                          "" ) );
//            sb.append( "                , PURCHASE_CTRL_CODE          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "purchase_ctrl_code",           "" ) );
//            sb.append( "                , PURCHASE_NAME               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "purchase_name",                "" ) );
//            sb.append( "                , MENU_PROFILE_CODE           = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "menu_profile_code",            "" ) );
//            sb.append( "                , PLANT_ADDRESS               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "plant_address",                "" ) );
//            sb.append( "                , PLANT_ADDRESS_TEXT          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "plant_address_text",           "" ) );
//            sb.append( "                , PLANT_ZIP_CODE              = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "plant_zip_code",               "" ) );
//            sb.append( "                , DEALING_PRODUCT             = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "dealing_product",              "" ) );
//            sb.append( "                , MAIN_CUSTOMER               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "main_customer",                "" ) );
//            sb.append( "                , MAKER_COMPANY_NAME          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "maker_company_name",           "" ) );
//            sb.append( "                , SUPPLIER_COMPANY_NAME       = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "supplier_company_name",        "" ) );
//            sb.append( "                , AGENT_COMPANY_NAME          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "agent_company_name",           "" ) );
//            sb.append( "                , MAKER_COMPANY_FLAG          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "maker_company_flag",           "" ) );
//            sb.append( "                , SUPPLIER_COMPANY_FLAG       = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "supplier_company_flag",        "" ) );
//            sb.append( "                , AGENT_COMPANY_FLAG          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "agent_company_flag",           "" ) );
//            sb.append( "                , ATTACH_NO                   = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "attach_no",                    "" ) );
//            sb.append( "                , IRS_COPY_ATTACH_NO          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "irs_copy_attach_no",           "" ) );
//            sb.append( "                , BANK_COPY_ATTACH_NO         = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "bank_copy_attach_no",          "" ) );
//            sb.append( "                , NDA_COPY_ATTACH_NO          = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "nda_copy_attach_no",           "" ) );
//            sb.append( "                , COMPANY_INTRO_ATTACH_NO     = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "company_intro_attach_no",      "" ) );
//            sb.append( "                , SELLER_EVALUATION_ATTACH_NO = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "seller_evaluation_attach_no",  "" ) );
//            sb.append( "                , REAL_EVALUATION_ATTACH_NO   = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "real_evaluation_attach_no",    "" ) );
//            sb.append( "                , MATERIAL_AUDIT_ATTACH_NO    = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "material_audit_attach_no",     "" ) );
//            sb.append( "                , EVALUATION_ETC_ATTACH_NO    = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "evaluation_etc_attach_no",     "" ) );
//            sb.append( "                , SEAL_ATTACH_NO              = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "seal_attach_no",               "" ) );
//            sb.append( "                , SOLE_PROPRIETOR_FLAG        = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "sole_proprietor_flag",         "" ) );
//            sb.append( "                , COMPANY_REG_NO              = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "company_reg_no",               "" ) );
//            sb.append( "                , CREDIT_RATING               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "credit_rating",                "" ) );
//            sb.append( "                , CHANGE_DATE                 = ?     \n" );sm.addStringParameter(SepoaDate.getShortDateString());
//            sb.append( "                , CHANGE_TIME                 = ?     \n" );sm.addStringParameter(SepoaDate.getShortTimeString());
//            sb.append( "                , CHANGE_USER_ID              = ?     \n" );sm.addStringParameter(info.getSession("ID"));
//            sb.append( "                , PURCHASE_BLOCK_FLAG         = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "purchase_block_flag",          "" ) );
//            sb.append( "                , EVAL_DATE                   = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "eval_date",                    "" ) );
//            sb.append( "                , IRS_NO_MAIN                 = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "irs_no_main",                  "" ) );
//            sb.append( "                , ACCOUNT_TYPE                = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "account_type",                 "" ) );
//            sb.append( "                , BIZ_CLASS1                  = ?     \n" );sm.addStringParameter( (MapUtils.getString( headerData,    "biz_class1", "" ).equals( "true" )) ? "1":"0" );
//            sb.append( "                , BIZ_CLASS2                  = ?     \n" );sm.addStringParameter( (MapUtils.getString( headerData,    "biz_class2", "" ).equals( "true" )) ? "1":"0" );
//            sb.append( "                , BIZ_CLASS3                  = ?     \n" );sm.addStringParameter( (MapUtils.getString( headerData,    "biz_class3", "" ).equals( "true" )) ? "1":"0" );
//            sb.append( "                , BIZ_CLASS4                  = ?     \n" );sm.addStringParameter( (MapUtils.getString( headerData,    "biz_class4", "" ).equals( "true" )) ? "1":"0" );
//            sb.append( "                , BIZ_CLASS5                  = ?     \n" );sm.addStringParameter( (MapUtils.getString( headerData,    "biz_class5", "" ).equals( "true" )) ? "1":"0" );
//            sb.append( "            WHERE SELLER_CODE                 = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData,    "seller_code",                  "" ) );
//            sb.append( "              AND COMPANY_CODE                = ?     \n" );sm.addStringParameter( buyer_company_code );
//            sm.doUpdate(sb.toString());
//
//            // SUSMT 업데이트
//            sm.removeAllValue();
//            sb.delete( 0, sb.length() );
//            sb.append( "UPDATE SUSMT                                      \n" );
//            sb.append( "              SET USER_NAME_LOC           = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "user_name_loc",  "" ) );
//            sb.append( "                , USER_NAME_ENG           = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "user_name_eng",  "" ) );
//            sb.append( "                , USER_ID                 = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "seller_user_id", "" ) );
//            sb.append( "                , PASSWORD                = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "password", "" ) );
//            sb.append( "                , COMPANY_CODE            = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "seller_code", "" ) );
//            sb.append( "                , DEPT                    = ?     \n" );sm.addStringParameter( buyer_company_code );
//            sb.append( "                , DEPT_NAME               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "dept_name", "" ) );
//            sb.append( "                , RESIDENT_NO             = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "resident_no",      "" ) );
//            sb.append( "                , EMPLOYEE_NO             = ''    \n" );
//            sb.append( "                , EMAIL                   = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "email",            "" ) );
//            sb.append( "                , POSITION                = ''    \n" );
//            sb.append( "                , LANGUAGE                = ?     \n" );sm.addStringParameter( language );
//            sb.append( "                , TIME_ZONE               = 'G08' \n" );
//            sb.append( "                , COUNTRY                 = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "country",          "" ) );
//            sb.append( "                , CITY_CODE               = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "city_code",          "" ) );
//            sb.append( "                , USER_TYPE               = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "'   \n" );
//            sb.append( "                , WORK_TYPE               = 'Z'   \n" );
//            sb.append( "                , SIGN_STATUS             = ?   \n" );sm.addStringParameter(sepoa.svc.common.constants.SignStatus.Rejected.getValue()); // 임시저장 R
//            sb.append( "                , CHANGE_DATE             = ?     \n" );sm.addStringParameter(SepoaDate.getShortDateString());
//            sb.append( "                , CHANGE_TIME             = ?     \n" );sm.addStringParameter(SepoaDate.getShortTimeString());
//            sb.append( "                , CHANGE_USER_ID          = ?     \n" );sm.addStringParameter(info.getSession("ID"));
//            sb.append( "            WHERE COMPANY_CODE            = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "seller_code", "" ) );

//            sm.doUpdate(sb.toString());
//
//            // SADDR UPDATE(CODE_TYPE=3)
//            sm.removeAllValue();
//            sb.delete( 0, sb.length() );
//            sb.append( "UPDATE SADDR              \n" );
//            sb.append( "   SET EMAIL      = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "email", "" ) );
//            sb.append( " WHERE CODE_NO    = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "seller_code", "" ) );
//            sb.append( "   AND CODE_TYPE  = '3'   \n" );
//            sm.doUpdate( sb.toString() );
//
//            // SADDR UPDATE(CODE_TYPE=2)
//            sm.removeAllValue();
//            sb.delete( 0, sb.length() );
//            sb.append( "UPDATE SADDR                      \n" );
//            sb.append( "         SET HOMEPAGE      = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "homepage",     "" ) );
//            sb.append( "           , ZIP_CODE      = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "zip_code",     "" ) );
//            sb.append( "           , ADDRESS_LOC   = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "address_loc",  "" ) );
//            sb.append( "           , ADDRESS_TEXT  = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "address_text", "" ) );
//            sb.append( "           , CEO_NAME_LOC  = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "ceo_name_loc", "" ) );
//            sb.append( "           , PHONE_NO1     = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "phone_no1",    "" ) );
//            sb.append( "           , FAX_NO        = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "fax_no",       "" ) );
//            sb.append( "           , PHONE_NO2     = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "phone_no2",    "" ) );
//            sb.append( "           , ADDRESS_ENG   = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "address_eng",  "" ) );
//            sb.append( "           , CEO_NAME_ENG  = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "ceo_name_eng", "" ) );
//            sb.append( "           , EMAIL         = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "email",        "" ) );
//            sb.append( "       WHERE CODE_NO       = ?    \n" );sm.addStringParameter( MapUtils.getString( headerData,    "seller_code",  "" ) );
//            sb.append( "         AND CODE_TYPE     = '2'  \n" );
//            sm.doUpdate( sb.toString() );
//
//            String seller_cond = "";
//            if( "E".equals( MapUtils.getString( headerData, "type", "" ) ) ) {
//                seller_cond = sepoa.svc.common.constants.SellerCond.PPP.getValue();
//            } else {
//                seller_cond = sepoa.svc.common.constants.SellerCond.NewSeller.getValue();
//            }
//            sb.delete( 0, sb.length() );
//            sm.removeAllValue();
//            sb.append( "UPDATE SSUGL SET                  \n" );
//            sb.append( "       SELLER_COND        = ?     \n" );sm.addStringParameter( seller_cond );
//            if( "E".equals( MapUtils.getString( headerData, "type", "" ) ) ) {
//                sb.append( "     , SIGN_STATUS     = ?    \n" );sm.addStringParameter( sepoa.svc.common.constants.SignStatus.Approved.getValue() );
//            } else {
//
//            }
//            sb.append( " WHERE SELLER_CODE        = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "seller_code", "" ) );
//            sb.append( "    AND COMPANY_CODE      = ?     \n" );sm.addStringParameter( buyer_company_code );
//            sm.doUpdate( sb.toString() );
//
//            ///////////////////////////////
//
//            sm.removeAllValue();
//            sb.delete( 0, sb.length() );
//            sb.append( "SELECT ADDR.ADDRESS_LOC                 \n" );
//            sb.append( "     , SUGL.COUNTRY                     \n" );
//            sb.append( "     , ADDR.FAX_NO                      \n" );
//            sb.append( "     , ADDR.CEO_NAME_LOC                \n" );
//            sb.append( "     , SUGL.BUSINESS_TYPE               \n" );
//            sb.append( "     , SUGL.INDUSTRY_TYPE               \n" );
//            sb.append( "     , SUGL.ACCOUNT_GROUP               \n" );
//            sb.append( "     , SUGL.LANGUAGE                    \n" );
//            sb.append( "     , ADDR.PHONE_NO2                   \n" );
//            sb.append( "     , SUGL.SELLER_NAME_LOC             \n" );
//            sb.append( "     , ADDR.ZIP_CODE                    \n" );
//            sb.append( "     , SUGL.CITY_CODE                   \n" );
//            sb.append( "     , ADDR.EMAIL                       \n" );
//            sb.append( "     , SUGL.SELLER_NAME_LOC SEARCH_KEY  \n" );
//            sb.append( "     , SUGL.IRS_NO                      \n" );
//            sb.append( "     , SUGL.IRS_NO                      \n" );
//            sb.append( "     , SUGL.COMPANY_REG_NO              \n" );
//            sb.append( "     , ADDR.ADDRESS_TEXT                \n" );
//            sb.append( "     , ADDR.PHONE_NO1                   \n" );
//            sb.append( "     , SUGL.SELLER_CODE                 \n" );
//            sb.append( "     , SUGL.CUR                         \n" );
//            sb.append( "     , SUGL.SAP_CRUD_FLAG               \n" );
//            sb.append( "  FROM SSUGL SUGL                       \n" );
//            sb.append( "     , SADDR ADDR                       \n" );
//            sb.append( " WHERE 1 = 1                            \n" );
//            sb.append( sm.addFixString(     "   AND COMPANY_CODE     = ?             \n" ) );sm.addStringParameter( info.getSession( "BUYER_COMPANY_CODE" ) );
//            sb.append( sm.addSelectString(  "   AND SELLER_CODE      = ?             \n" ) );sm.addStringParameter( MapUtils.getString( headerData, "seller_code", "" ) );
//            sb.append( "   AND SUGL.SELLER_CODE = ADDR.CODE_NO  \n" );
//            sb.append( "   AND ADDR.CODE_TYPE   = '2'           \n" );
//            sf = new SepoaFormater( sm.doSelect( sb.toString() ) );
//
//            if( sf.getRowCount() > 0 ) {
//
//                SourceServiceServiceStub sourceServiceServiceStub = new SourceServiceServiceStub();
//
//                HttpTransportProperties.Authenticator auth = new HttpTransportProperties.Authenticator();
//                auth.setUsername( "EAIWEB" );

//                sourceServiceServiceStub._getServiceClient().getOptions().setProperty( HTTPConstants.AUTHENTICATE, auth );
//
//                INPUT_type0 input_type0 = new INPUT_type0();
//                input_type0.setCITY1        ( sf.getValue( "ADDRESS_LOC",       0 ) ); // (N)기본주소 // ADDRESS_LOC
//                input_type0.setCOUNTRY      ( sf.getValue( "COUNTRY",           0 ) ); // (N)국가코드 // COUNTRY
//                input_type0.setFAX_NUMBER   ( sf.getValue( "FAX_NO",            0 ) ); // (Y)팩스번호 // FAX_NO
//                input_type0.setJ_1KFREPRE   ( sf.getValue( "CEO_NAME_LOC",      0 ) ); // (Y)대표자이름(해외업체는 불필요) // CEO_NAME_LOC
//                input_type0.setJ_1KFTBUS    ( sf.getValue( "BUSINESS_TYPE",     0 ) ); // (Y)업태정보(해외업체는 불필요) // BUSINESS_TYPE
//                input_type0.setJ_1KFTIND    ( sf.getValue( "INDUSTRY_TYPE",     0 ) ); // (Y)업종정보(해외업체는 불필요) // INDUSTRY_TYPE
//                input_type0.setKTOKK        ( sf.getValue( "ACCOUNT_GROUP",     0 ) ); // (N)계정그룹(국내업체='M001', 해외업체='M002') // ACCOUNT_GROUP
//                input_type0.setLANGU        ( sf.getValue( "LANGUAGE",          0 ) ); // (N)언어코드('KO') // LANGUAGE
//                input_type0.setMOB_NUMBER   ( sf.getValue( "PHONE_NO2",         0 ) ); // (Y)이동전화번호 // PHONE_NO2
//                input_type0.setNAME1        ( sf.getValue( "SELLER_NAME_LOC",   0 ) ); // (N)회사명 // SELLER_NAME_LOC
//                input_type0.setPOST_CODE1   ( sf.getValue( "ZIP_CODE",          0 ) ); // (N)우편번호(해외업체는 불필요) // ZIP_BOX_NO
//                input_type0.setREGION       ( sf.getValue( "CITY_CODE",         0 ) ); // (Y)지역코드 // CITY_CODE
//                input_type0.setSMTP_ADDR    ( sf.getValue( "EMAIL",             0 ) ); // (Y)E-MAIL // EMAIL
//                input_type0.setSORT1        ( sf.getValue( "SEARCH_KEY",        0 ) ); // (N)회사명약어 // SEARCH_KEY
//                input_type0.setSORT2        ( sf.getValue( "IRS_NO",            0 ) ); // (N)사업자번호(- 뺀 값) // IRS_NO
//                input_type0.setSTCD2        ( sf.getValue( "IRS_NO",            0 ) ); // (Y)사업자번호(- 뺀 값) // IRS_NO
//                input_type0.setSTCD3        ( sf.getValue( "COMPANY_REG_NO",    0 ) ); // (Y)법인번호(해외업체는 불필요) // COMPANY_REG_NO
//                input_type0.setSTREET       ( sf.getValue( "ADDRESS_TEXT",      0 ) ); // (Y)상세주소(기본주소 추가될때) // ADDRESS_TEXT
//                input_type0.setTEL_NUMBER   ( sf.getValue( "PHONE_NO1",         0 ) ); // (Y)대표 전화번호 // PHONE_NO1
//                input_type0.setVENDOR_ID    ( sf.getValue( "SELLER_CODE",       0 ) ); // (N)공급업체 코드(구매포탈에서 관리하는 공급업체 코드) // SELLER_CODE
//                input_type0.setWAERS        ( sf.getValue( "CUR",               0 ) ); // (N)공급업체 통화코드 // CUR
//                input_type0.setZINDEX       ( sf.getValue( "SAP_CRUD_FLAG",     0 ) ); // (N)처리구분(포탈에서 생성:C, 변경:U, 삭제:D) // SAP_CRUD_FLAG
//
//                SourceData sourceData = new SourceData();
//                sourceData.setINPUT( input_type0 );
//
//                SourceMessage sourceMessage = new SourceMessage();
//                sourceMessage.setSourceMessage( sourceData );
//
//                SourceMessage_R sourceMessage_R = sourceServiceServiceStub.sourceService( sourceMessage );
//                SourceData_R sourceData_R = sourceMessage_R.getSourceMessage_R();
//
//                OUTPUT_type0 output_type0 = sourceData_R.getOUTPUT();
//
//                // 인터페이스 시 성공시 프로세스
//                if( "S".equals( output_type0.getIPS_ERROR_TYPE() ) ) {
//
//                    // 성공시 업체 정보 업데이트
//                    sm.removeAllValue();
//                    sb.delete( 0, sb.length() );
//                    sb.append( "UPDATE SSUGL SET SAP_CRUD_FLAG     = ?     \n" );sm.addStringParameter( "U" );
//                    sb.append( "           WHERE 1 = 1                  \n" );
//                    sb.append( "             AND COMPANY_CODE   = ?     \n" );sm.addStringParameter( info.getSession( "BUYER_COMPANY_CODE" ) );
//                    sb.append( "             AND SELLER_CODE    = ?     \n" );sm.addStringParameter( MapUtils.getString( headerData, "seller_code", "" ) );
//                    intRtn  = sm.doUpdate( sb.toString() );
//
//                // 인터페이스 중 오류
//                } else {
//
//                    // 오류나면 인터페이스 테이블에 저장이 안됨(수정요) / 무조건 저장하도록 수정해야 함...
//                    if( output_type0.getIPS_ERROR_TEXT() == null ) {
//                        throw new Exception( msg.getMessage( "0084" ) );
//                    } else {
//                        throw new Exception( output_type0.getIPS_ERROR_TEXT() );
//                    }
//
//                }
//
//                // 인터페이스 이후 인터페이스 테이블에 저장
//                CO_999 co_999 = new CO_999( "NONDBJOB", info );
//                co_999.setConnectionContext( ctx );
//
//                sm.removeAllValue();
//                sb.delete( 0, sb.length() );
//                sb.append( "INSERT INTO IF_XI_IPS_VENDOR_OUT (                          \n" );
//                sb.append( "                                   IF_XI_ID                 \n" );
//                sb.append( "                                 , ZINDEX                   \n" );
//                sb.append( "                                 , VENDOR_ID                \n" );
//                sb.append( "                                 , KTOKK                    \n" );
//                sb.append( "                                 , NAME1                    \n" );
//                sb.append( "                                 , SORT1                    \n" );
//                sb.append( "                                 , SORT2                    \n" );
//                sb.append( "                                 , CITY1                    \n" );
//                sb.append( "                                 , STREET                   \n" );
//                sb.append( "                                 , POST_CODE1               \n" );
//                sb.append( "                                 , COUNTRY                  \n" );
//                sb.append( "                                 , LANGU                    \n" );
//                sb.append( "                                 , REGION                   \n" );
//                sb.append( "                                 , TEL_NUMBER               \n" );
//                sb.append( "                                 , MOB_NUMBER               \n" );
//                sb.append( "                                 , FAX_NUMBER               \n" );
//                sb.append( "                                 , SMTP_ADDR                \n" );
//                sb.append( "                                 , STCD2                    \n" );
//                sb.append( "                                 , J_1KFREPRE               \n" );
//                sb.append( "                                 , J_1KFTBUS                \n" );
//                sb.append( "                                 , J_1KFTIND                \n" );
//                sb.append( "                                 , STCD3                    \n" );
//                sb.append( "                                 , WAERS                    \n" );
//                sb.append( "                                 , IPS_ERROR_TYPE           \n" );
//                sb.append( "                                 , IPS_ERROR_CLASS          \n" );
//                sb.append( "                                 , IPS_ERROR_ID             \n" );
//                sb.append( "                                 , IPS_ERROR_TEXT           \n" );
//                sb.append( "                                 , LIFNR                    \n" );
//                sb.append( "                                 , PICODE                   \n" );
//                sb.append( "                                 , PISTAT                   \n" );
//                sb.append( "                                 , PIDATE                   \n" );
//                sb.append( "                                 , PITIME                   \n" );
//                sb.append( "                                 , PIUSER                   \n" );
//                sb.append( "                                 , PIMSG                    \n" );
//                sb.append( "                                 )                          \n" );
//                sb.append( "                          VALUES (                          \n" );
//                sb.append( "                                   ?    -- IF_XI_ID         \n" );sm.addStringParameter( co_999.getIFSequence( "MMIF0010" ) );
//                sb.append( "                                 , ?    -- ZINDEX           \n" );sm.addStringParameter( sf.getValue( "SAP_CRUD_FLAG",     0 ) );
//                sb.append( "                                 , ?    -- VENDOR_ID        \n" );sm.addStringParameter( sf.getValue( "SELLER_CODE",       0 ) );
//                sb.append( "                                 , ?    -- KTOKK            \n" );sm.addStringParameter( sf.getValue( "ACCOUNT_GROUP",     0 ) );
//                sb.append( "                                 , ?    -- NAME1            \n" );sm.addStringParameter( sf.getValue( "SELLER_NAME_LOC",   0 ) );
//                sb.append( "                                 , ?    -- SORT1            \n" );sm.addStringParameter( sf.getValue( "SEARCH_KEY",        0 ) );
//                sb.append( "                                 , ?    -- SORT2            \n" );sm.addStringParameter( sf.getValue( "IRS_NO",            0 ) );
//                sb.append( "                                 , ?    -- CITY1            \n" );sm.addStringParameter( sf.getValue( "ADDRESS_LOC",       0 ) );
//                sb.append( "                                 , ?    -- STREET           \n" );sm.addStringParameter( sf.getValue( "ADDRESS_TEXT",      0 ) );
//                sb.append( "                                 , ?    -- POST_CODE1       \n" );sm.addStringParameter( sf.getValue( "ZIP_CODE",          0 ) );
//                sb.append( "                                 , ?    -- COUNTRY          \n" );sm.addStringParameter( sf.getValue( "COUNTRY",           0 ) );
//                sb.append( "                                 , ?    -- LANGU            \n" );sm.addStringParameter( sf.getValue( "LANGUAGE",          0 ) );
//                sb.append( "                                 , ?    -- REGION           \n" );sm.addStringParameter( sf.getValue( "CITY_CODE",         0 ) );
//                sb.append( "                                 , ?    -- TEL_NUMBER       \n" );sm.addStringParameter( sf.getValue( "PHONE_NO1",         0 ) );
//                sb.append( "                                 , ?    -- MOB_NUMBER       \n" );sm.addStringParameter( sf.getValue( "PHONE_NO2",         0 ) );
//                sb.append( "                                 , ?    -- FAX_NUMBER       \n" );sm.addStringParameter( sf.getValue( "FAX_NO",            0 ) );
//                sb.append( "                                 , ?    -- SMTP_ADDR        \n" );sm.addStringParameter( sf.getValue( "EMAIL",             0 ) );
//                sb.append( "                                 , ?    -- STCD2            \n" );sm.addStringParameter( sf.getValue( "IRS_NO",            0 ) );
//                sb.append( "                                 , ?    -- J_1KFREPRE       \n" );sm.addStringParameter( sf.getValue( "CEO_NAME_LOC",      0 ) );
//                sb.append( "                                 , ?    -- J_1KFTBUS        \n" );sm.addStringParameter( sf.getValue( "BUSINESS_TYPE",     0 ) );
//                sb.append( "                                 , ?    -- J_1KFTIND        \n" );sm.addStringParameter( sf.getValue( "INDUSTRY_TYPE",     0 ) );
//                sb.append( "                                 , ?    -- STCD3            \n" );sm.addStringParameter( sf.getValue( "COMPANY_REG_NO",    0 ) );
//                sb.append( "                                 , ?    -- WAERS            \n" );sm.addStringParameter( sf.getValue( "CUR",               0 ) );
//                sb.append( "                                 , ?    -- IPS_ERROR_TYPE   \n" );sm.addStringParameter( output_type0.getIPS_ERROR_TYPE()   );
//                sb.append( "                                 , ?    -- IPS_ERROR_CLASS  \n" );sm.addStringParameter( output_type0.getIPS_ERROR_CLASS()  );
//                sb.append( "                                 , ?    -- IPS_ERROR_ID     \n" );sm.addStringParameter( output_type0.getIPS_ERROR_ID()     );
//                sb.append( "                                 , ?    -- IPS_ERROR_TEXT   \n" );sm.addStringParameter( output_type0.getIPS_ERROR_TEXT()   );
//                sb.append( "                                 , ?    -- LIFNR            \n" );sm.addStringParameter( output_type0.getLIFNR()            );
//                sb.append( "                                 , ?    -- PICODE           \n" );sm.addStringParameter( output_type0.getPICODE()           );
//                sb.append( "                                 , ?    -- PISTAT           \n" );sm.addStringParameter( output_type0.getPISTAT()           );
//                sb.append( "                                 , ?    -- PIDATE           \n" );sm.addStringParameter( output_type0.getPIDATE()           );
//                sb.append( "                                 , ?    -- PITIME           \n" );sm.addStringParameter( output_type0.getPITIME()           );
//                sb.append( "                                 , ?    -- PIUSER           \n" );sm.addStringParameter( output_type0.getPIUSER()           );
//                sb.append( "                                 , ?    -- PIMSG            \n" );sm.addStringParameter( output_type0.getPIMSG()            );
//                sb.append( "                                 )                          \n" );
//                sm.doInsert( sb.toString() );
//
//            }
//
//            setMessage( msg.getMessage( "0001" ) );
//
//            Commit();
//
//        } catch( RemoteException e ) {
//            setFlag( false );
//            setStatus( 0 );
//            try {
//                Rollback();
//            } catch( Exception d ) {
//                Logger.err.println( info.getSession( "ID" ), this, d.getMessage() );
//            }
//            setMessage( msg.getMessage( "0084" ) );
//            e.printStackTrace();
//            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
//        } catch( Exception e ) {
//            setFlag( false );
//            setStatus( 0 );
//            try {
//                Rollback();
//            } catch( Exception d ) {
//                Logger.err.println( info.getSession( "ID" ), this, d.getMessage() );
//            }
//            e.printStackTrace();
//            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
//            setMessage( e.getMessage() );
//        }
//
//        return getSepoaOut();
//
//    }


    /**
    @Method Name : setSapInterFaceFor0230
    @ SAP Interface 0230 처리
    @ 수정일 : 2013 . 03
    @
  **/
    public SepoaOut setSapInterFaceFor0230(Map allData) throws Exception
    {
         ConnectionContext       ctx     = getConnectionContext();
         StringBuffer            sbfs    = new StringBuffer();
         SepoaFormater           sf      = null;

         SepoaOut                 so     = null;

         String  sap_id      = "";


         try {

             setStatus(1);
             setFlag(true);

             sap_id      = MapUtils.getString( allData, "sap_id", "" );

             ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
             sm.removeAllValue();

             sbfs.delete(0, sbfs.length());
             sbfs.append("SELECT '123456' as SAP_ID  ");
             sf = new SepoaFormater( sm.doSelect(  sbfs.toString() ) );


             /**************************************************
              * 인터페이스 시작
             PO_058 po_058  = new PO_058( "TRANSACTION", info );
             po_058.setConnectionContext( getConnectionContext() );
             so = po_058.setTaxIF( allData );

             if( so.status == 0 || !so.flag ) {                 /// Interface 실패시 //
                 Rollback();
                 setStatus( 0 );
                 setFlag( false );
                 setMessage( so.message );
                 throw new Exception(so.message);
             }
         **************************************************/
             setMessage ( (so != null)?so.message:"" );
             // 처리 내역에 따른 Table 저장




             /**************************************************
              * Step 2. 인터페이스 시작
              **************************************************/



         } catch( Exception e ) {
             setStatus( 0 );
             setFlag( false );
             setMessage( e.getMessage() );
             Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
         }

         return getSepoaOut();

    }
    
    
    
    
    
    
    
    /** ******************************************************************************************************************************
     *  ******************************************************************************************************************************
     *  ******************************************************************************************************************************
     *  ******************************************************************************************************************** 기타 작업
     *  
     */
    public SepoaOut getRemark( Map< String, String > headerData ) {
        setStatus( 1 );
        setFlag( true );
        ConnectionContext ctx = getConnectionContext();
        StringBuffer      sb  = new StringBuffer();

        Map< String, String > header = null;

        try {
            ParamSql sm = new ParamSql( info.getSession( "ID" ), this, ctx );
            sm.removeAllValue();
            sb.delete(0, sb.length());
            sb.append( "SELECT                                  \n" );
            sb.append( "     REMARK_2                           \n" );
            sb.append( " FROM SSUGL                             \n" );
            sb.append(sm.addFixString("WHERE SELLER_CODE = ?    \n" ));sm.addStringParameter( MapUtils.getString( headerData, "seller_code", "" ) );
            setValue(sm.doSelect( sb.toString() ));

        } catch( Exception e ) {
            setMessage( e.getMessage() );
            setStatus( 0 );
            setFlag( false );
            Logger.debug.println( this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e );
            

        } finally {
        }

        return getSepoaOut();
        
    } // end of methdo getRemark

    public SepoaOut setRemark( Map< String, String > alldata ) {
        setStatus( 1 );
        setFlag( true );
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();
        
        Map< String, String > header = null;

        String sign_status = "";

        try {
            ParamSql sm = new ParamSql( info.getSession( "ID" ), this, ctx );
            header = MapUtils.getMap( alldata, "headerData", null );


            sm.removeAllValue();
            sb.delete(0, sb.length());
            sb.append( "UPDATE SSUGL SET                     \n" );
            sb.append( "      REMARK_2     = ?             \n" );sm.addStringParameter(MapUtils.getString(header, "remark", ""));
            sb.append( "WHERE SELLER_CODE           = ?      \n" );sm.addStringParameter(MapUtils.getString(header, "seller_code", ""));
            sm.doUpdate( sb.toString() );

            Commit();
        } catch( Exception e ) {
            setMessage( e.getMessage() );
            setStatus( 0 );
            setFlag( false );
            Logger.debug.println( this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e );
            
        } finally {
        }

        return getSepoaOut();

    } // end of method setRemark
    
    
    
    
    
    
    
    
    
    /** ******************************************************************************************************************************
     *  ******************************************************************************************************************************
     *  ******************************************************************************************************************************
     *  **************************************************************************************************************** 우편번호 작업.
     *  
     */
    
    /**
     * 업체등록 우편번호 가져오기
     * Ajax 를 통해 해당 method 를 호출한다.
     * 해당 method 에서는 구 주소조회, 도로명주소조회 작업 수행 method 를 호출하여 return 한다.
     *
     *
     * @param info
     * @param header
     * @return
     * @throws Exception
     */
//    public SepoaOut callAjax_ZipCodeList( HashMap<String,HashMap> searchMap ) throws Exception {
//        HashMap searchData      = null;
//        String  searchFlagInput = "";
//        
//        try {
//            searchData      = searchMap.get( "headerData" );
//            searchFlagInput = searchData.get( "searchFlagInput" ).toString();
//
//            SepoaOut sepoaOut = new SepoaOut();
//            
//            if( "dong".equals( searchFlagInput ) ){
//                sepoaOut = callByOldZipCodeList( searchData );
//
//            } else if( "road".equals( searchFlagInput ) ){
//                sepoaOut = callByRoadZipCodeList( searchData );
//
//            } // end if
//            setFlag( sepoaOut.flag );
//            setMessage( sepoaOut.message );
//            setStatus( sepoaOut.status );
//            setValue( sepoaOut.result[0] );    
//        } catch( Exception e ) {
//            
//            setMessage( e.getMessage() );
//            setStatus( 0 );
//            setFlag( false );
//            Logger.debug.println( info.getSession( "ID" ), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e );
//            
//            
//        } finally {
//        }
//        return getSepoaOut();
//
//    } // end of method callAjax_ZipCodeList
    public SepoaOut callAjax_ZipCodeList( HashMap<String,HashMap> searchMap ) throws Exception {

        HashMap searchData      = null;

        String  searchFlagInput = "";

        try {
            searchData      = searchMap.get( "headerData" );
            searchFlagInput = searchData.get( "searchFlagInput" ).toString();

            SepoaOut sepoaOut = new SepoaOut();

            if( "dong".equals( searchFlagInput ) ){
                sepoaOut = callByOldZipCodeList( searchData );

            } else if( "road".equals( searchFlagInput ) ){
                sepoaOut = callByRoadZipCodeList( searchData );

            } // end if

            setFlag( sepoaOut.flag );
            setMessage( sepoaOut.message );
            setStatus( sepoaOut.status );
            setValue( sepoaOut.result[0] );

        } catch( Exception e ) {
//            e.printStackTrace();
            setMessage( e.getMessage() );
            setStatus( 0 );
            setFlag( false );
            Logger.debug.println( info.getSession( "ID" ), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e );
//            System.out.println( new Exception().getStackTrace()[0].getMethodName() + "=" + e );

        } finally {
        }

        return getSepoaOut();

    } // end of method callAjax_ZipCodeList
    
    
    
    
    

    /**
     * 업체등록 우편번호 가져오기
     * 구 주소값을 조회하여 json 방식으로 반환한다.
     * 해당 데이터는 기존 등록되어진 getZipCodeList 를 호출하여 사용한다.
     *
     *
     * @param info
     * @param header
     * @return
     * @throws Exception
     */
    public SepoaOut callByOldZipCodeList( HashMap<String, String> searchData ) throws Exception {
    	SepoaOut      sepoaOut     = null;
    	SepoaFormater sf           = null;
    	String        zipcode      = null;
        String        sido_name    = null;
        String        gugun_name   = null;
        String        dong_name    = null;
        String        bunji_name   = null;
        String        ree_name     = null;
        String        apt_name     = null;
        String        address      = null;
        String        address2     = null;
        StringBuffer  stringBuffer = new StringBuffer();
        int           i            = 0;
        int           iMax         = 0;
    	
        try {
        	searchData.put("search_name", searchData.get( "dong" ) );

            sepoaOut = getZipCodeList( info, searchData );

            sf = new SepoaFormater( sepoaOut.result[0] );
            
            iMax = sf.getRowCount();
            stringBuffer.append("{");

            for(i = 0; i < iMax ; i++ ){
            	zipcode     = sf.getValue("ZIP_CODE"  , i).trim();
                sido_name   = sf.getValue("SIDO_NAME" , i).trim();
                gugun_name  = sf.getValue("GUGUN_NAME", i).trim();
                dong_name   = sf.getValue("DONG_NAME" , i).trim();
                bunji_name  = sf.getValue("BUNJI_NAME", i).trim();
                ree_name    = sf.getValue("REE_NAME"  , i).trim();
                apt_name    = sf.getValue("APT_NAME"  , i).trim();
                
            	stringBuffer.append("{");
            	stringBuffer.append(	"zipcode:'").append(zipcode).append("',");
            	stringBuffer.append(	"sido_name:'").append(sido_name).append("',");
            	stringBuffer.append(	"gugun_name:'").append(gugun_name).append("',");
            	stringBuffer.append(	"dong_name:'").append(dong_name).append("',");
            	stringBuffer.append(	"bunji_name:'").append(bunji_name).append("',");
            	stringBuffer.append(	"ree_name:'").append(ree_name).append("',");
            	stringBuffer.append(	"ree_name:'").append(ree_name).append("',");
            	stringBuffer.append(	"apt_name:'").append(apt_name).append("'");
                stringBuffer.append("}");
                
                if(i != (iMax - 1)){
                	stringBuffer.append(",");
                }
            }
            
            stringBuffer.append("}");

            setFlag(sepoaOut.flag);
            setMessage(sepoaOut.message);
            setStatus(sepoaOut.status);
            setValue(stringBuffer.toString());
        }
        catch(Exception e){
            setMessage( e.getMessage() );
            setStatus( 0 );
            setFlag( false );
        }
        
        return getSepoaOut();
    } // end of method callByOldZipCodeList





    /**
     * 업체등록 우편번호 가져오기
     *
     * @param info
     * @param header
     * @return
     * @throws Exception
     */
    public SepoaOut getZipCodeList( SepoaInfo info, HashMap< String, String > header ) throws Exception {

        setStatus( 1 );
        setFlag( true );
        String[] rtn = new String[2];
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try {

            ParamSql sm = new ParamSql( info.getSession( "ID" ), this, ctx );

            String search_name = (String)header.get( "search_name" );

            String like_sql = "%" + search_name + "%";

            sm.removeAllValue();
            sb.delete( 0, sb.length() );
            sb.append( "SELECT ZIP_CODE                                                 \n" );
            sb.append( "     , SIDO_NAME                                                \n" );
            sb.append( "     , GUGUN_NAME                                               \n" );
            sb.append( "     , DONG_NAME                                                \n" );
            sb.append( "     , BUNJI_NAME                                               \n" );
            sb.append( "     , REE_NAME                                                 \n" );
            sb.append( "     , APT_NAME                                                 \n" );
            sb.append( "     , FULL_ADDR_NAME                                           \n" );
            sb.append( "  FROM SZIP                                                     \n" );
            sb.append( " WHERE 1 = 1                                                    \n" );
            sb.append( "   AND (                                                        \n" );
            sb.append( "            SIDO_NAME       LIKE '" + like_sql + "'             \n" );
            sb.append( "         OR GUGUN_NAME      LIKE '" + like_sql + "'             \n" );
            sb.append( "         OR DONG_NAME       LIKE '" + like_sql + "'             \n" );
            sb.append( "         OR REE_NAME        LIKE '" + like_sql + "'             \n" );
            sb.append( "         OR APT_NAME        LIKE '" + like_sql + "'             \n" );
            sb.append( "       )                                                        \n" );
            sb.append( "ORDER BY SIDO_NAME, GUGUN_NAME, DONG_NAME, REE_NAME, BUNJI_NAME \n" );

            // result
            rtn[0] = sm.doSelect( sb.toString() );
            setValue( rtn[0] );

        } catch( Exception e ) {
            
            setMessage( e.getMessage() );
            setStatus( 0 );
            setFlag( false );
            Logger.debug.println( info.getSession( "ID" ), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e );
            
        } finally {
        }

        return getSepoaOut();

    } // end of method getZipCodeList

    /**
     * 업체등록 우편번호 가져오기
     * 도로명  주소값을 조회하여 json 방식으로 반환한다.
     * 해당 데´터는 신규 생성된 method 를 호출 하여 생성한다.
     *
     *
     * @param info
     * @param header
     * @return
     * @throws Exception
     */
//    public SepoaOut callByRoadZipCodeList( HashMap<String, String> searchData ) throws Exception {
//
//        try {
//            SepoaOut sepoaOut = getRoadZipCodeList( searchData );
//
//            SepoaFormater sf = new SepoaFormater( sepoaOut.result[0] );
//
//            String zip_cd       = "";
//            String sido         = "";
//            String sigungu      = "";
//            String eupmyun      = "";
//            String road_nm      = "";            
//            String build_num1   = "";
//            String build_num2   = "";
//            String bedalcher_nm = "";
//            String build_nm     = "";
//            String dong_nm      = "";
//            String ri           = "";
//            String sido_eng     = "";
//            String road_nm_eng  = "";
//            String sigungu_eng  = "";
//            String country      = "";
//
//            //JSONArray  jsonArray  = new JSONArray();
//            //JSONObject jsonObject = null;
//
//             for( int i = 0 , iMax = sf.getRowCount() ; i < iMax ; i++ ){
//
//                 zip_cd       = sf.getValue("ZIP_CD"      , i);
//                 sido         = sf.getValue("SIDO"        , i);
//                 sigungu      = sf.getValue("SIGUNGU"     , i);
//                 eupmyun      = sf.getValue("EUPMYUN"     , i);
//                 road_nm      = sf.getValue("ROAD_NM"     , i);
//                 build_num1   = sf.getValue("BUILD_NUM1"  , i);
//                 build_num2   = sf.getValue("BUILD_NUM2"  , i);
//                 bedalcher_nm = sf.getValue("BEDALCHER_NM", i);
//                 build_nm     = sf.getValue("BUILD_NM"    , i);
//                 dong_nm      = sf.getValue("DONG_NM"     , i);
//                 ri           = sf.getValue("RI"          , i);
//                 sido_eng     = sf.getValue("SIDO_ENG"    , i);
//                 road_nm_eng  = sf.getValue("ROAD_NM_ENG" , i);
//                 sigungu_eng  = sf.getValue("SIGUNGU_ENG" , i);
//                 country      = sf.getValue("COUNTRY"     , i);
///*
//                jsonObject = new JSONObject();
//
//                jsonObject.put( "zip_cd"          , zip_cd       );
//                jsonObject.put( "sido"            , sido         );
//                jsonObject.put( "sigungu"         , sigungu      );
//                jsonObject.put( "eupmyun"         , eupmyun      );
//                jsonObject.put( "road_nm"         , road_nm      );
//                jsonObject.put( "build_num1"      , build_num1   );
//                jsonObject.put( "build_num2"      , build_num2   );
//                jsonObject.put( "bedalcher_nm"    , bedalcher_nm );
//                jsonObject.put( "build_nm"        , build_nm     );
//                jsonObject.put( "dong_nm"         , dong_nm      );
//                jsonObject.put( "ri"              , ri           );
//                jsonObject.put( "sido_eng"        , sido_eng     );
//                jsonObject.put( "road_nm_eng"     , road_nm_eng  );
//                jsonObject.put( "sigungu_eng"     , sigungu_eng  );
//                jsonObject.put( "country"         , country      );
//
//                jsonArray.put(jsonObject);
//*/
//            }
//
//            setFlag( sepoaOut.flag );
//            setMessage( sepoaOut.message );
//            setStatus( sepoaOut.status );
//            //setValue( jsonArray.toString() );
//
//        } catch( Exception e ) {
//            
//            setMessage( e.getMessage() );
//            setStatus( 0 );
//            setFlag( false );
//            Logger.debug.println( info.getSession( "ID" ), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e );
//            
//
//        } finally {
//        }
//
//        return getSepoaOut();
//
//    } // end of method callByOldZipCodeList
    private String getRemoveLineSeparator(String target) throws Exception{
    	target = target.replace(System.getProperty("line.separator"), "");
    	
    	return target;
    }
    
    public SepoaOut callByRoadZipCodeList( HashMap<String, String> searchData ) throws Exception {
    	SepoaOut      sepoaOut     = null;
    	SepoaFormater sf           = null;
    	String        zip_cd       = null;
        String        sido         = null;
        String        sigungu      = null;
        String        eupmyun      = null;
        String        road_nm      = null;            
        String        build_num1   = null;
        String        build_num2   = null;
        String        bedalcher_nm = null;
        String        build_nm     = null;
        String        dong_nm      = null;
        String        ri           = null;
        String        sido_eng     = null;
        String        road_nm_eng  = null;
        String        sigungu_eng  = null;
        String        country      = null;
        StringBuffer  stringBuffer = new StringBuffer();
        int           i            = 0;
        int           iMax         = 0;
    	
        try {
            sepoaOut = getRoadZipCodeList( searchData );

            sf = new SepoaFormater( sepoaOut.result[0] );

            iMax = sf.getRowCount();
            
            stringBuffer.append("[");
            
            for(i = 0; i < iMax ; i++ ){
                 zip_cd       = this.getRemoveLineSeparator(sf.getValue("ZIP_CD"      , i).trim());
                 sido         = this.getRemoveLineSeparator(sf.getValue("SIDO"        , i).trim());
                 sigungu      = this.getRemoveLineSeparator(sf.getValue("SIGUNGU"     , i).trim());
                 eupmyun      = this.getRemoveLineSeparator(sf.getValue("EUPMYUN"     , i).trim());
                 road_nm      = this.getRemoveLineSeparator(sf.getValue("ROAD_NM"     , i).trim());
                 build_num1   = this.getRemoveLineSeparator(sf.getValue("BUILD_NUM1"  , i).trim());
                 build_num2   = this.getRemoveLineSeparator(sf.getValue("BUILD_NUM2"  , i).trim());
                 bedalcher_nm = this.getRemoveLineSeparator(sf.getValue("BEDALCHER_NM", i).trim());
                 build_nm     = this.getRemoveLineSeparator(sf.getValue("BUILD_NM"    , i).trim());
                 dong_nm      = this.getRemoveLineSeparator(sf.getValue("DONG_NM"     , i).trim());
                 ri           = this.getRemoveLineSeparator(sf.getValue("RI"          , i).trim());
                 sido_eng     = this.getRemoveLineSeparator(sf.getValue("SIDO_ENG"    , i).trim());
                 road_nm_eng  = this.getRemoveLineSeparator(sf.getValue("ROAD_NM_ENG" , i).trim());
                 sigungu_eng  = this.getRemoveLineSeparator(sf.getValue("SIGUNGU_ENG" , i).trim());
                 country      = this.getRemoveLineSeparator(sf.getValue("COUNTRY"     , i).trim());
                 
                 stringBuffer.append("{");
                 stringBuffer.append(	"zip_cd:'").append(zip_cd).append("',");
                 stringBuffer.append(	"sido:'").append(sido).append("',");
                 stringBuffer.append(	"sigungu:'").append(sigungu).append("',");
                 stringBuffer.append(	"eupmyun:'").append(eupmyun).append("',");
                 stringBuffer.append(	"road_nm:'").append(road_nm).append("',");
                 stringBuffer.append(	"build_num1:'").append(build_num1).append("',");
                 stringBuffer.append(	"build_num2:'").append(build_num2).append("',");
                 stringBuffer.append(	"bedalcher_nm:'").append(bedalcher_nm).append("',");
                 stringBuffer.append(	"build_nm:'").append(build_nm).append("',");
                 stringBuffer.append(	"dong_nm:'").append(dong_nm).append("',");
                 stringBuffer.append(	"ri:'").append(ri).append("',");
                 stringBuffer.append(	"sido_eng:'").append(sido_eng).append("',");
                 stringBuffer.append(	"country:'").append(country).append("'");
                 stringBuffer.append("}");
                 
                 if(i != (iMax - 1)){
                	 stringBuffer.append(",");
                 }
            }
            
            stringBuffer.append("]");

            setFlag(sepoaOut.flag);
            setMessage(sepoaOut.message);
            setStatus(sepoaOut.status);
            setValue(stringBuffer.toString());

        } catch( Exception e ) {
            setMessage( e.getMessage() );
            setStatus( 0 );
            setFlag( false );
        }
        
        return getSepoaOut();
    }




    /**
     * 업체등록 도로명 우편번호 가져오기
     *
     * @param info
     * @param header
     * @return
     * @throws Exception
     */
    public SepoaOut getRoadZipCodeList( HashMap< String, String > header ) throws Exception {

        setStatus( 1 );
        setFlag( true );
        String[] rtn = new String[2];
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try {

            ParamSql sm = new ParamSql( info.getSession( "ID" ), this, ctx );

            String sido       = (String)header.get( "sido"       );
            String sigungu    = (String)header.get( "sigungu"    );
            String road_nm    = (String)header.get( "road_nm"    );
            String build_num1 = (String)header.get( "roadbuilding" );

            sm.removeAllValue();
            sb.delete( 0, sb.length() );

            sb.append(                   " SELECT NEW_ZIP_CD  ZIP_CD                     \n");
            sb.append(                   "      , SIDO                         \n");
            sb.append(                   "      , SIGUNGU                      \n");
            sb.append(                   "      , EUPMYUN                      \n");
            sb.append(                   "      , ROAD_NM                      \n");
            sb.append(                   "      , BUILD_NUM1                   \n");
            sb.append(                   "      , BUILD_NUM2                   \n");
            sb.append(                   "      , BEDALCHER_NM                 \n");
            sb.append(                   "      , BUILD_NM                     \n");
            sb.append(                   "      , DONG_NM                      \n");
            sb.append(                   "      , RI                           \n");
            sb.append(                   "      , SIDO_ENG                     \n");
            sb.append(                   "      , ROAD_NM_ENG                  \n");
            sb.append(                   "      , SIGUNGU_ENG                  \n");
            sb.append(                   "      , 'Korea' AS COUNTRY           \n");
            sb.append(                   "   FROM SZIP2                        \n");
            sb.append(                   "  WHERE 1=1                          \n");
            sb.append(sm.addFixString(   "    AND SIDO = ?                     \n")); sm.addStringParameter(sido      );
//            sb.append(sm.addSelectString("    AND REPLACE( SIGUNGU,' ','') = ? \n")); sm.addStringParameter(sigungu   );
            sb.append(sm.addSelectString("    AND SIGUNGU = ? \n")); sm.addStringParameter(sigungu   );     
            sb.append(sm.addSelectString("    AND ROAD_NM LIKE ? || '%' \n")); sm.addStringParameter(build_num1);            
//            sb.append(sm.addSelectString("    AND ( ROAD_NM LIKE '%' || ? || '%' \n")); sm.addStringParameter(build_num1);
//            sb.append(sm.addSelectString("          OR BUILD_NUM1 = ?          \n")); sm.addStringParameter(build_num1);
//            sb.append(sm.addSelectString("          OR BUILD_NUM2 = ? )        \n")); sm.addStringParameter(build_num1);
            sb.append(                   " ORDER BY ZIP_CD,SIDO,SIGUNGU,EUPMYUN,ROAD_NM,BUILD_NUM1,BUILD_NUM2                     \n");

            // result
            rtn[0] = sm.doSelect( sb.toString() );
            setValue( rtn[0] );

        } catch( Exception e ) {
            
            setMessage( e.getMessage() );
            setStatus( 0 );
            setFlag( false );
            Logger.debug.println( info.getSession( "ID" ), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e );
            
        } finally {
        }

        return getSepoaOut();

    } // end of method getRoadZipCodeList
        

///////////////////////////////////////////
    public SepoaOut setSellerEvalList7( Map< String, Object >   allData ) throws Exception {
		

        ConnectionContext       ctx         = getConnectionContext();
        StringBuffer            sbfs        = new StringBuffer();
        StringBuffer            sbvl        = new StringBuffer();
        SepoaFormater           sf          = null;
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵

        int     rtn     = 0;
        boolean Change_flag=false;

        headerData = MapUtils.getMap( allData, "headerData");
        
        try {
            String buyer_plant_code    = sepoa.svc.common.constants.DEFAULT_PLANT_CODE;
            String sellerCondNewSeller = sepoa.svc.common.constants.SellerCond.NewSeller.getValue();
            String userTypeSeller      = sepoa.svc.common.constants.UserType.Seller.getValue();
            String commonUtilFlagNo    = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String commonUtilFlagYes   = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();

            String jobStatusTempSave   = sepoa.svc.common.constants.JobStatus.TempSave.getValue();  // 임시
            String jobStatusRejected   = sepoa.svc.common.constants.JobStatus.Rejected.getValue();  // 반려
            String jobStatusApproving  = sepoa.svc.common.constants.JobStatus.Approving.getValue(); // 진행중
            String jobStatusApproved   = sepoa.svc.common.constants.JobStatus.Approved.getValue(); 	// 승인완료

            String signStatusTempSave  = sepoa.svc.common.constants.SignStatus.TempSave.getValue(); // 임시
            String signStatusRejected  = sepoa.svc.common.constants.SignStatus.Rejected.getValue(); // 반려
            String signStatusApproveSuccess_Regist  = sepoa.svc.common.constants.SignStatus.ApproveSuccess_Regist.getValue(); // 승인완료
            
            String seller_code         = MapUtils.getString( headerData , "seller_code" , "" );
            String buyer_company_code  = seller_code;
            String susmtPassword       = SepoaString.encString ( MapUtils.getString( headerData,  "password"  , "" ).trim() , "PWD"   );
            String susmtEmail          = SepoaString.encString ( MapUtils.getString( headerData,  "email"     , "" ).trim() , "EMAIL" );
            String susmtPhoneNo1       = SepoaString.encString ( MapUtils.getString( headerData,  "phone_no1" , "" ).trim() , "PHONE" );
            String susmtPhoneNo2       = SepoaString.encString ( MapUtils.getString( headerData,  "phone_no2" , "" ).trim() , "PHONE" );
            String susmtFaxNo          = SepoaString.encString ( MapUtils.getString( headerData,  "fax_no"    , "" ).trim() , "PHONE" );
            String susmtMobileNo       = susmtPhoneNo2;
            String susmtUserType       = "R";
                                                                                                                                        
//            String bizClass1           = MapUtils.getString( headerData, "biz_class1", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass2           = MapUtils.getString( headerData, "biz_class2", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass3           = MapUtils.getString( headerData, "biz_class3", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass4           = MapUtils.getString( headerData, "biz_class4", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass5           = MapUtils.getString( headerData, "biz_class5", "" ).trim().equals( "true" ) ? "1":"0";
//            
            String strType             = "";
            String USER_ID             = info.getSession( "ID" );
            String nowDate             = SepoaDate.getShortDateString();
            String nowTime             = SepoaDate.getShortTimeString();

            // 사용자 id 가 없을 경우 user_id 는 업체 코드로 세팅.
            if( "".equals( USER_ID ) ){
                USER_ID = _DEFAULT_SELLER_USER_ID;
                
            } // end if
            
            
            ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

            // 업체번호가 없을경우 채번
            if( "".equals( seller_code ) ) {
                strType      = "INSERT";
                
                //seller_code  = getSellerCode ( MapUtils.getString( headerData, "irs_no", "" ) );
                //headerData.put( "seller_code", seller_code );

                //외자업체의 채번방식을 함께 사용
                SepoaOut    so  = DocumentUtil.getDocNumber( info, "CRE" );
                seller_code = so.result[0];
                headerData.put( "seller_code", seller_code);
                
                buyer_company_code = _DEFAULT_SELLER_COMPANY_CODE;

            } else {
                strType = "UPDATE";
                
            } // end if
         //   headerData.put( "foundation_date1", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "foundation_date", "" ) ) );
         //   headerData.put( "eval_date"       , SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "eval_date"      , "" ) ) );
            
            String house_code = "000";
            String del_flag = "N";
            String sheet_kind = "02";
            String user_kind = "";
            String eval_no = "EV14090022";
                /* ********************************************************************************************************************************************************************
                 * SSUGL 에 데이터를 입력한다.
                 *  
                 * 
                 */
                // SSUGL 삭제 후 입력
                
            	
            	
            	ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                
                sbfs.append( "DELETE FROM SRGLN                 \n ");
                sbfs.append( "      WHERE SELLER_CODE   = ?     \n "); setParamSql( ps , "S" , headerData         , "seller_code" , "" );
                
                ps.doDelete( sbfs.toString() );
                
                
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbvl.delete( 0, sbvl.length() );
                
                sbfs.append( "INSERT INTO SRGLN (                  \n" ); 
                sbfs.append("   HOUSE_CODE         \n "); sbvl.append("    ?  \n "); setParamSql( ps , "S" , house_code); 
                sbfs.append(" , SELLER_CODE            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , seller_code);
//                sbfs.append(" , YEAR            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" ,  headerData, "year", "" );                
                sbfs.append(" , EVAL_NO            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" ,  eval_no);
                sbfs.append(" , EVAL_SEQ            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" ,  headerData, "eval_seq", "" );
                sbfs.append(" , SHEET_KIND            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , sheet_kind);
                sbfs.append(" , GRADE            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" ,  headerData, "grade", "" );
                sbfs.append(" , POINT            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" ,  headerData, "point", "" );
                sbfs.append(" , USER_KIND            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , user_kind);
                sbfs.append(" , ADD_DATE            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , nowDate);                
                sbfs.append(" , ADD_USER_ID            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , USER_ID);
                sbfs.append(" , CHANGE_DATE            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , nowDate);
                sbfs.append(" , CHANGE_USER_ID            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , USER_ID);
                sbfs.append(" , DEL_FLAG            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , del_flag);
                sbfs.append(" ) VALUES (            \n "); sbvl.append("  )    \n ");
              
              ps.doInsert( sbfs.toString() + sbvl.toString() );
            
            setStatus( 1 );
            setFlag( true );
            setMessage( msg.get( "MESSAGE.0001" ).toString() );
            setValue( MapUtils.getString( headerData, "seller_code", "" ) );
            
            Commit();

        } catch( Exception e ) {
            Rollback();
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
//            e.printStackTrace( System.out );
            /*e.getCause().printStackTrace( System.out );*/
        }

        return getSepoaOut();

    }
    	////////////////////////////////////
    public SepoaOut setSellerEvalList77( Map< String, Object >   allData ) throws Exception {
		

        ConnectionContext       ctx         = getConnectionContext();
        StringBuffer            sbfs        = new StringBuffer();
        StringBuffer            sbvl        = new StringBuffer();
        SepoaFormater           sf          = null;
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵

        int     rtn     = 0;
        boolean Change_flag=false;

        headerData = MapUtils.getMap( allData, "headerData");
        
        try {
            String buyer_plant_code    = sepoa.svc.common.constants.DEFAULT_PLANT_CODE;
            String sellerCondNewSeller = sepoa.svc.common.constants.SellerCond.NewSeller.getValue();
            String userTypeSeller      = sepoa.svc.common.constants.UserType.Seller.getValue();
            String commonUtilFlagNo    = sepoa.fw.util.CommonUtil.Flag.No.getValue();
            String commonUtilFlagYes   = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();

            String jobStatusTempSave   = sepoa.svc.common.constants.JobStatus.TempSave.getValue();  // 임시
            String jobStatusRejected   = sepoa.svc.common.constants.JobStatus.Rejected.getValue();  // 반려
            String jobStatusApproving  = sepoa.svc.common.constants.JobStatus.Approving.getValue(); // 진행중
            String jobStatusApproved   = sepoa.svc.common.constants.JobStatus.Approved.getValue(); 	// 승인완료

            String signStatusTempSave  = sepoa.svc.common.constants.SignStatus.TempSave.getValue(); // 임시
            String signStatusRejected  = sepoa.svc.common.constants.SignStatus.Rejected.getValue(); // 반려
            String signStatusApproveSuccess_Regist  = sepoa.svc.common.constants.SignStatus.ApproveSuccess_Regist.getValue(); // 승인완료
            
            String seller_code         = MapUtils.getString( headerData , "seller_code" , "" );
            String buyer_company_code  = seller_code;
            String susmtPassword       = SepoaString.encString ( MapUtils.getString( headerData,  "password"  , "" ).trim() , "PWD"   );
            String susmtEmail          = SepoaString.encString ( MapUtils.getString( headerData,  "email"     , "" ).trim() , "EMAIL" );
            String susmtPhoneNo1       = SepoaString.encString ( MapUtils.getString( headerData,  "phone_no1" , "" ).trim() , "PHONE" );
            String susmtPhoneNo2       = SepoaString.encString ( MapUtils.getString( headerData,  "phone_no2" , "" ).trim() , "PHONE" );
            String susmtFaxNo          = SepoaString.encString ( MapUtils.getString( headerData,  "fax_no"    , "" ).trim() , "PHONE" );
            String susmtMobileNo       = susmtPhoneNo2;
            String susmtUserType       = "R";
                                                                                                                                        
//            String bizClass1           = MapUtils.getString( headerData, "biz_class1", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass2           = MapUtils.getString( headerData, "biz_class2", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass3           = MapUtils.getString( headerData, "biz_class3", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass4           = MapUtils.getString( headerData, "biz_class4", "" ).trim().equals( "true" ) ? "1":"0";
//            String bizClass5           = MapUtils.getString( headerData, "biz_class5", "" ).trim().equals( "true" ) ? "1":"0";
//            
            String strType             = "";
            String USER_ID             = info.getSession( "ID" );
            String nowDate             = SepoaDate.getShortDateString();
            String nowTime             = SepoaDate.getShortTimeString();

            // 사용자 id 가 없을 경우 user_id 는 업체 코드로 세팅.
            if( "".equals( USER_ID ) ){
                USER_ID = _DEFAULT_SELLER_USER_ID;
                
            } // end if
            
            
            ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

            // 업체번호가 없을경우 채번
            if( "".equals( seller_code ) ) {
                strType      = "INSERT";
                
                //seller_code  = getSellerCode ( MapUtils.getString( headerData, "irs_no", "" ) );
                //headerData.put( "seller_code", seller_code );

                //외자업체의 채번방식을 함께 사용
                SepoaOut    so  = DocumentUtil.getDocNumber( info, "CRE" );
                seller_code = so.result[0];
                headerData.put( "seller_code", seller_code);
                
                buyer_company_code = _DEFAULT_SELLER_COMPANY_CODE;

            } else {
                strType = "UPDATE";
                
            } // end if
         //   headerData.put( "foundation_date1", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "foundation_date", "" ) ) );
         //   headerData.put( "eval_date"       , SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "eval_date"      , "" ) ) );
            
            String house_code = "000";
            String del_flag = "N";
            String sheet_kind = "02";
            String user_kind = "";
            String eval_no = "EV14090022";
                /* ********************************************************************************************************************************************************************
                 * SSUGL 에 데이터를 입력한다.
                 *  
                 * 
                 */
                // SSUGL 삭제 후 입력
                
            	
            	
            	ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                
                sbfs.append( "DELETE FROM SSUGL                 \n ");
                sbfs.append( "      WHERE SELLER_CODE   = ?     \n "); setParamSql( ps , "S" , headerData         , "seller_code" , "" );
                
                ps.doDelete( sbfs.toString() );
                
                
                ps.removeAllValue();
                sbfs.delete( 0, sbfs.length() );
                sbvl.delete( 0, sbvl.length() );
                
                sbfs.append( "UPDATE SSUGL (                  \n" ); 
                sbfs.append("   SET SG_NAME         \n "); sbvl.append("    ?  \n "); setParamSql( ps , "S" , house_code);                
                sbfs.append(" , AS_EVAL_POINT            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" ,  eval_no);
                sbfs.append(" , AS_PASS_FLAG            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" ,  headerData, "eval_seq", "" );
                sbfs.append(" , SHEET_KIND            \n "); sbvl.append("  , ?  \n "); setParamSql( ps , "S" , sheet_kind);
                sbfs.append( "      WHERE SELLER_CODE = ?   \n" ); setParamSql( ps , "S" , seller_code                  );
                sbfs.append( "        AND HOUSE_CODE        = ?   \n" ); setParamSql( ps , "S" , house_code);

              ps.doInsert( sbfs.toString() + sbvl.toString() );
            
            setStatus( 1 );
            setFlag( true );
            setMessage( msg.get( "MESSAGE.0001" ).toString() );
            setValue( MapUtils.getString( headerData, "seller_code", "" ) );
            
            Commit();

        } catch( Exception e ) {
            Rollback();
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
//            e.printStackTrace( System.out );
            /*e.getCause().printStackTrace( System.out );*/
        }

        return getSepoaOut();

    }
    	///////////////////////////////////
    	
    public SepoaOut getSellerEvalList7(Map< String, String > header)
    {
        ConnectionContext ctx = getConnectionContext();
        setStatus(1);
        setFlag( true );

        String       flagNo  = sepoa.fw.util.CommonUtil.Flag.No.getValue();
        String       flagYes = sepoa.fw.util.CommonUtil.Flag.Yes.getValue();  
        
        try {
            ParamSql ps = new ParamSql( info.getSession( "ID" ), this, ctx );

            StringBuffer sql = new StringBuffer();
            
            sql.append(                     " SELECT a.EVAL_SEQ                                          \n");            
            sql.append(                     "      , a.DESCRIPTION                                       \n");
            sql.append(                     "      , a.GRADE                                             \n");
            sql.append(                     "      , a.GRADE_TEXT                                        \n");
            sql.append(                     "      , a.POINT                                             \n");
            sql.append(                     "  , (select count(*) from (SELECT EVAL_SEQ from  SEVLN where eval_no = 'EV14090022' group by EVAL_SEQ) ) as cnt \n");
            sql.append(                     "  , (SELECT count(*) from  SEVLN where eval_no = 'EV14090022' and eval_seq=a.eval_seq )  as cnt2                \n");
            sql.append(                     "   FROM SEVLN a where eval_no = 'EV14090022'                                            \n");
//          sql.append( ps.addFixString(    "  WHERE EVAL_NO                                           \n"));setParamSql( ps , "S" , header , "eval_no" , "" );

            setValue( ps.doSelect( sql.toString() ) );

        } catch (Exception e) {
            setStatus(0);
            setFlag( false );
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
            
        }

        return getSepoaOut();
    }

}
