package sepoa.svc.admin;

import java.util.HashMap ;
import java.util.List ;
import java.util.Map ;

import org.apache.commons.collections.MapUtils ;

import sepoa.fw.cfg.Configuration ;
import sepoa.fw.cfg.ConfigurationException ;
import sepoa.fw.db.ConnectionContext ;
import sepoa.fw.db.DBOpenException ;
import sepoa.fw.db.ParamSql ;
import sepoa.fw.db.SepoaSQLManager ;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger ;
import sepoa.fw.msg.* ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.SepoaService ;
import sepoa.fw.srv.SepoaServiceException ;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.SepoaDate ;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaString ;

public class AD_132 extends SepoaService
{
  
    String company_code = "";
    String id = "";
    String depart = "";
    String position = "";
    String name_loc = "";
    String name_eng = "";
    String language = "";
    String country = "";
    String city = "";

//    Message msg = new Message("STDCOMM");
    //20131217 sendakun
    private HashMap msg = null;

    public AD_132(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
        setVersion("1.0.0");
        //20131217 sendakun
        try {
//            msg = new Message(info, "STDCOMM");
            //STDCOMM ->AD_133
            msg = MessageUtil.getMessageMap( info, "AD_133");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println(this,e.getMessage());
        }
        
        this.company_code 	    = info.getSession("COMPANY_CODE");
        this.id 				= info.getSession("ID");
        this.depart 			= info.getSession("DEPARTMENT");
        this.position 			= info.getSession("POSITION");
        this.name_loc 			= info.getSession("NAME_LOC");
        this.name_eng 			= info.getSession("NAME_ENG");
        this.language 			= info.getSession("LANGUAGE");
        this.country 			= info.getSession("COUNTRY");
        this.city 				= info.getSession("CITY");
	}

	public String getConfig(String s)
	{
		try
		{
			Configuration configuration = new Configuration();
			s = configuration.get(s);

			return s;
		}
		catch (ConfigurationException configurationexception)
		{
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception)
		{
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}

		return null;
	}

	
	
    /**
     * 신규사용자승인 page / 사용자 현황 page 조회 
    *  getMainternace
    *  수정일 : 2013/03
    *  C.S.H
    */

    public SepoaOut getMainternace(Map <String,String>header) throws Exception
    {
        String rtn = "";
        String user_id = info.getSession("ID");
        ConnectionContext ctx = getConnectionContext();

        // 사용자 ID, 사용자명, 부서코드, 직급, 전화번호, 메뉴명
        try
        {
            String sign_status = MapUtils.getString( header, "i_sign_status", "" );
        	StringBuffer tSQL = new StringBuffer();
        	ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
        	
            tSQL.append(" SELECT                                                                                                                           \n");
            tSQL.append("    USER_ID                                                                                                                       \n");
            tSQL.append("   ,USER_NAME_LOC                                                                                                                 \n");
            tSQL.append("   ,(CASE WHEN (" + SEPOA_DB_OWNER + "CNV_NULL(USER_TYPE,'NULL') = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "')                                                           					\n");
            tSQL.append("   THEN (SELECT vendor_NAME_LOC FROM ICOMVNGL WHERE VENDOR_CODE=ICOMLUSR.COMPANY_CODE)                                					\n");
			tSQL.append("   ELSE (SELECT COMPANY_NAME_LOC FROM ICOMCMGL WHERE COMPANY_CODE=ICOMLUSR.COMPANY_CODE)  END) AS COMPANY_NAME  							\n");
            tSQL.append("   ,"+DB_NULL_FUNCTION+"((SELECT PLANT_NAME_LOC FROM ICOMOGPL WHERE COMPANY_CODE=ICOMLUSR.COMPANY_CODE AND PLANT_CODE = ICOMLUSR.PLANT_CODE),'') AS PLANT_NAME                                    \n");
            tSQL.append("   ," + SEPOA_DB_OWNER + "getcodetext2('M104',WORK_TYPE, '" + info.getSession("LANGUAGE") + "') TEXT_WORK_TYPE                    \n");
//            tSQL.append("   ,(SELECT DEPT_NAME_LOC FROM icomogdp WHERE DEPT=ICOMLUSR.DEPT) AS DEPT_NAME                                                          \n");
            tSQL.append("   ,(SELECT DEPT_NAME_LOC FROM icomogdp WHERE DEPT=ICOMLUSR.DEPT AND COMPANY_CODE = ICOMLUSR.COMPANY_CODE) AS DEPT_NAME                                                          \n");
            tSQL.append("   ,(case when (" + SEPOA_DB_OWNER + "CNV_NULL(USER_TYPE,'NULL') = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "')                                                           \n");
            tSQL.append("	then POSITION                               \n");
            tSQL.append(" 	else " + SEPOA_DB_OWNER + "getcodetext2('M106',POSITION, '" + info.getSession("LANGUAGE") + "') end) AS POSITION               \n");
            tSQL.append("   ,(case when (" + SEPOA_DB_OWNER + "CNV_NULL(USER_TYPE,'NULL') = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "')                                                           \n");
            tSQL.append("   then " + SEPOA_DB_OWNER + "getcodetext2('M106', POSITION, '" + info.getSession("LANGUAGE") + "')                               \n");
            tSQL.append("   else " + SEPOA_DB_OWNER + "getcodetext2('M106',POSITION, '" + info.getSession("LANGUAGE") + "') end) AS MANAGER_POSITION       \n");
            tSQL.append("   ," + SEPOA_DB_OWNER + "getaddrattr2(user_id,'3','PHONE_NO1') AS PHONE_NO                                                        \n");
            tSQL.append("   ,(select max(smupd.MENU_NAME) AS MENU_NAME from smupd where (smupd.MENU_PROFILE_CODE = ICOMLUSR.MENU_PROFILE_CODE)) AS MENU_NAME  \n");
            tSQL.append("   ,case when '" + info.getSession("USER_TYPE") + "' in ('" + sepoa.svc.common.constants.UserType.Seller.getValue() + "', '" + sepoa.svc.common.constants.UserType.Partner.getValue() + "') then                                                           \n");
            tSQL.append("   case when " + DB_NULL_FUNCTION + "(menu_profile_code, ' ') = ' ' then '" + info.getSession("MENU_PROFILE_CODE") + "'           \n");
            tSQL.append("   else menu_profile_code end                                                  \n");
            tSQL.append("   else MENU_PROFILE_CODE                                                      \n");
            tSQL.append("   end as MENU_PROFILE_CODE                                                    \n");
            tSQL.append("   ,SIGN_STATUS                                                                \n");
            tSQL.append("   ,COMPANY_CODE                                                               \n");
            tSQL.append("   FROM  ICOMLUSR                                                                 \n");
            tSQL.append("   WHERE " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                         \n");
            tSQL.append(sm.addSelectString("    AND COMPANY_CODE = ?                                    \n"));sm.addStringParameter( MapUtils.getString( header, "i_company_code", "" ));
            
            if (SEPOA_DB_VENDOR.equals("ORACLE"))
    		{
            	tSQL.append(sm.addSelectString("  AND USER_ID LIKE ? || '%'                              \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_id", "" ));
	            tSQL.append(sm.addSelectString("  AND USER_NAME_LOC LIKE UPPER('%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%')          \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
    		}
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
    		{
            	tSQL.append(sm.addSelectString("  AND USER_ID LIKE ? + '%'                               \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_id", "" ));
	            tSQL.append(sm.addSelectString("  AND USER_NAME_LOC LIKE UPPER('%' + ? + '%')            \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
    		}
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
            	tSQL.append(sm.addSelectString("  AND USER_ID LIKE UPPER(CONCAT(? , '%'))                \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_id", "" ));
                tSQL.append(sm.addSelectString("  AND USER_NAME_LOC LIKE UPPER(CONCAT('%' , ? , '%'))    \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
            }
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                tSQL.append(sm.addSelectString("  AND USER_ID LIKE ? + '%'                               \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_id", "" ));
                tSQL.append(sm.addSelectString("  AND USER_NAME_LOC LIKE UPPER('%' + ? + '%')            \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_name_loc", "" ));
            }

            tSQL.append(sm.addSelectString("  AND DEPT = ?                         \n"));sm.addStringParameter( MapUtils.getString( header, "i_dept", "" )); // 사용자명
            
            
            //if(sepoa.svc.common.constants.UserType.Seller.getValue().equals(MapUtils.getString( header, "i_user_type", "" ))){
                tSQL.append(sm.addSelectString("  AND USER_TYPE = ?                    \n"));sm.addStringParameter( MapUtils.getString( header, "i_user_type", "" )); //사용자구분

            //}else {
             //   tSQL.append(sm.addSelectString("  AND USER_TYPE = ?                    \n"));sm.addStringParameter( sepoa.svc.common.constants.UserType.Partner.getValue()); //사용자구분
            //}
            tSQL.append(sm.addSelectString("  AND WORK_TYPE = ?                    \n"));sm.addStringParameter( MapUtils.getString( header, "i_work_type", "" )); //업무권한

            if(sign_status.equals("R"))
            	tSQL.append( " AND SIGN_STATUS = '" + sepoa.svc.common.constants.SignStatus.Rejected.getValue() + "'\n");		//R : 등록  A:승인
            else	
            	tSQL.append( " AND SIGN_STATUS = 'A'\n");		//R : 등록  A:승인

//        	tSQL.append( " AND ISNULL(EMP_STATUS,'J') = 'J'  \n");		//R : 등록  A:승인

           
            rtn = sm.doSelect(tSQL.toString());
            setValue(rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//            setMessage(msg.getMessage("0000"));
            
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());

            if(rtn == null) throw new Exception("SQL Manager is Null");
            
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M104", "M106" );
            }catch(Exception e) {
                setStatus(0);
                //조회중 에러가 발생 하였습니다.
//                setMessage(msg.getMessage("0001"));
               
                //조회중 에러가 발생 하였습니다.
                setMessage(msg.get("AD_133.MSG_0116").toString());
                
                throw new Exception("et_getMainternace:"+e.getMessage());
            } finally{
            //Release();
        }
        return getSepoaOut();
    }


    /**
     * 사용자 등록 
    *  setInsert
    *  수정일 : 2013/03
    *  C.S.H
    */
    public SepoaOut setInsert(Map< String, Object > allData){
        
       

        try
        {
           
        	Map< String, String >   headerData  = MapUtils.getMap( allData, "headerData" );
            
            int rtn = et_setInsert(allData);

            if(rtn > 0){
            	Commit();
            	setValue("Insert Row=" + rtn);
	            setStatus(1);
	            //성공적으로 작업을 수행했습니다.
//	            setMessage(msg.getMessage("0000"));
	            
	            //성공적으로 작업을 수행했습니다.
	            setMessage(msg.get("AD_133.MSG_0115").toString());
            }

        } catch(Exception e) {

            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            Logger.err.println(this,e.getMessage());
            //log err
        }
        return getSepoaOut();
    } //setInsert() end
    
    
    private int et_setInsert(Map <String , Object > header) throws Exception, DBOpenException
    {
    	
        String add_date = SepoaDate.getShortDateString();
        String add_time = SepoaDate.getShortTimeString();
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        

        try
        {

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            
            String user_type = MapUtils.getString( header, "user_type", ""         );
            // ICOMLUSR 테이블 등록
            
        	tSQL.append(" INSERT INTO ICOMLUSR                \n");
        	tSQL.append(" (                                \n");        
        	tSQL.append("   USER_ID                        \n");  // 사용자ID
        	tSQL.append(" , HOUSE_CODE                     \n");  // 사용자ID
        	tSQL.append(" , PASSWORD                       \n");  // 비밀번호
        	tSQL.append(" , USER_NAME_LOC                  \n");  // 사용자명
        	tSQL.append(" , USER_NAME_ENG                  \n");  // 사용자명(영문)
        	tSQL.append(" , COMPANY_CODE                   \n");  // 회사코드
        	tSQL.append(" , PLANT_CODE                     \n");  // 사업장코드
        	tSQL.append(" , DEPT                           \n");  // 부서코드
        	//tSQL.append(" , DEPT_NAME                      \n");  // 부서명
        	tSQL.append(" , RESIDENT_NO                    \n");  // 주민번호
        	tSQL.append(" , EMPLOYEE_NO                    \n");
        	tSQL.append(" , EMAIL                          \n");  // 이메일
        	tSQL.append(" , POSITION                       \n");  // 직위
        	tSQL.append(" , LANGUAGE                       \n");  // 언어
        	tSQL.append(" , TIME_ZONE                      \n");  
        	tSQL.append(" , COUNTRY                        \n");  // 국가
        	tSQL.append(" , CITY_CODE                      \n");   
        	tSQL.append(" , PR_LOCATION                    \n");  
        	tSQL.append(" , MANAGER_POSITION               \n");  // 직책
        	tSQL.append(" , USER_TYPE                      \n");  // 사용자구분
        	tSQL.append(" , WORK_TYPE                      \n");  // 업무권한
        	//tSQL.append(" , PLM_USER_FLAG                  \n");        
        	tSQL.append(" , DEL_FLAG                       \n");
        	tSQL.append(" , SIGN_STATUS                    \n");  // 등록시 STATUS 값 "R"
        	tSQL.append(" , ADD_DATE                       \n");
        	tSQL.append(" , ADD_TIME                       \n");
        	tSQL.append(" , ADD_USER_ID                    \n");
        	tSQL.append(" , CHANGE_USER_ID                 \n");
        	tSQL.append(" , LOGIN_NCY            		   \n");        	
        	tSQL.append(" ) VALUES (                       \n");      
        	tSQL.append("   ?                              \n");sm.addStringParameter( MapUtils.getString( header, "user_id", ""           ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter(info.getSession("HOUSE_CODE"));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( SepoaString.encString ( MapUtils.getString( header, "password", "" ) ,"PWD"));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "user_name_loc", ""     ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "user_name_eng", ""     ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter(info.getSession("COMPANY_CODE"));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "plant_code", sepoa.svc.common.constants.DEFAULT_PLANT_CODE      ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "dept", ""              ));
        	//tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "text_dept", ""         ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter("");   
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "employee_no", ""       ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( SepoaString.encString ( MapUtils.getString( header, "email", "" ) , "EMAIL"));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "position", ""          ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "language", ""          ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "time_zone", ""         ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "country", ""           ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "city_code", ""         ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "pr_location", ""       ));
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "manager_position", ""  ));
        	if(user_type.equals(sepoa.svc.common.constants.UserType.Seller.getValue())){
            	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "user_type", ""         ));
        	}else {
            	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "user_type", ""         ));
        	}
        	tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "work_type", ""         ));
        	//tSQL.append(" , ?                              \n");sm.addStringParameter( MapUtils.getString( header, "plm_user_flag", ""     ));        
        	tSQL.append(" , ?                              \n");sm.addStringParameter( "N" );
        	tSQL.append(" , ?  			                   \n");sm.addStringParameter( sepoa.svc.common.constants.SignStatus.Rejected.getValue() );
        	tSQL.append(" , ?                              \n");sm.addStringParameter( add_date );
        	tSQL.append(" , ?                              \n");sm.addStringParameter( add_time );
        	tSQL.append(" , ?                              \n");sm.addStringParameter( id );
        	tSQL.append(" , ?                              \n");sm.addStringParameter( add_date );
        	tSQL.append(" , ?                              \n");sm.addStringParameter( "Y" );
        	tSQL.append(" )                                \n");


            rtn = sm.doInsert(tSQL.toString());
            
            
            // icomaddr 테이블 등록                     
            sm.removeAllValue();
            tSQL.delete( 0, tSQL.length());
            
            tSQL.append(" INSERT INTO icomaddr                 \n");
            tSQL.append(" (                                 \n");       
            tSQL.append("   CODE_NO                         \n"); // 아이디
            tSQL.append(" , HOUSE_CODE                      \n"); // '3'
            tSQL.append(" , CODE_TYPE                       \n"); // '3'
            tSQL.append(" , ZIP_CODE                        \n"); // 
            tSQL.append(" , PHONE_NO1                       \n"); // 전화번호
            tSQL.append(" , FAX_NO                          \n"); // 팩스번호
            tSQL.append(" , HOMEPAGE                        \n"); // 홈페이지
            tSQL.append(" , ADDRESS_LOC                     \n"); // 주소
            tSQL.append(" , ADDRESS_ENG                     \n"); // 주소영문
            tSQL.append(" , CEO_NAME_LOC                    \n"); // 대표자성명
            tSQL.append(" , CEO_NAME_ENG                    \n"); // 대표자 성명 영문
            tSQL.append(" , EMAIL                           \n"); // 메일
            tSQL.append(" , ZIP_BOX_NO                      \n");
            tSQL.append(" , PHONE_NO2                       \n"); // 핸드폰번호
            tSQL.append(" ) VALUES (                        \n");          
            tSQL.append("   ?   		                    \n");sm.addStringParameter( MapUtils.getString( header, "user_id", ""         ));
            tSQL.append(" , ?   		                    \n");sm.addStringParameter(info.getSession("HOUSE_CODE"));
            tSQL.append(" , '3'   			                \n");// 기존 소스에도 default 값 3
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( MapUtils.getString( header, "zip_code", ""        ));
            tSQL.append(" , ?   	                   	    \n");sm.addStringParameter( SepoaString.encString ( MapUtils.getString( header, "phone_no0", ""       ), "PHONE"));
            tSQL.append(" , ?   	                      	\n");sm.addStringParameter( SepoaString.encString ( MapUtils.getString( header, "fax_no0", ""         ), "PHONE"));
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( "" );
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( MapUtils.getString( header, "address_loc", ""     ));
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( MapUtils.getString( header, "address_eng", ""     ));
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( "" );
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( "" );
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( SepoaString.encString ( MapUtils.getString( header, "email", ""           ), "EMAIL"));
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( "" );
            tSQL.append(" , ?   	                        \n");sm.addStringParameter( SepoaString.encString ( MapUtils.getString( header, "mobile_no0", ""      ), "PHONE"));
            tSQL.append(" )                                 \n");


            rtn = sm.doInsert(tSQL.toString());
           if(rtn < 1)
            	throw new Exception("ICOMADDR INSERT ERROR");


        } catch(DBOpenException e) {
                    Rollback();
                throw new Exception("et_setInsert:"+e.getMessage());
        }
        return rtn;
    } // et_setInsert() end

    
    
    public SepoaOut SendSMS(String[][] args){

        try
        {
            Logger.debug.println("CJERP111",this,"######SendSMS#######");

            int rtn = et_SendSMS(args);
            setValue("Insert Row=" + rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
          //성공적으로 작업을 수행했습니다.
          setMessage(msg.get("AD_133.MSG_0115").toString());

        } catch(Exception e) {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            Logger.err.println(this,e.getMessage());
            //log err
        }
        return getSepoaOut();
    }

    private int et_SendSMS(String[][] args) throws Exception, DBOpenException
    {
    	String status = "C";
        String add_date = SepoaDate.getShortDateString();
        String add_time = SepoaDate.getShortTimeString();
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        SepoaSQLManager sm = null;

        try
        {
        	tSQL = new StringBuffer();

        	tSQL.append(" INSERT INTO EM_TRAN(           		\n");
        	tSQL.append(" 	TRAN_PR                       		\n");
        	tSQL.append(" 	, TRAN_REFKEY              			\n");
        	tSQL.append(" 	, TRAN_ID                       	\n");
        	tSQL.append(" 	, TRAN_PHONE                  		\n");
        	tSQL.append(" 	, TRAN_CALLBACK               		\n");
        	tSQL.append(" 	, TRAN_STATUS                 		\n");
        	tSQL.append(" 	, TRAN_DATE                   		\n");
        	tSQL.append(" 	, TRAN_MSG                    		\n");
        	tSQL.append(" ) VALUES (                      		\n");
        	tSQL.append("   	EM_TRAN_PR.NEXTVAL@SMS_PRO    	\n");
        	tSQL.append(" 	, '70'      						\n");
        	tSQL.append(" 	, 'PRO'								\n");
        	tSQL.append(" 	, ?	-- TRAN_PHONE No      			\n");
        	tSQL.append(" 	, ?   	-- CALLBACK No      		\n");
        	tSQL.append(" 	, '1'                       		\n");
        	tSQL.append(" 	, sysdate                   		\n");
        	tSQL.append(" 	, ? 	-- TRAN_MSG           		\n");
        	tSQL.append(" )                             		\n");

            sm = new SepoaSQLManager("CJERP111",this,ctx,tSQL.toString());

            String[] setType = {"S","S","S" };

            rtn = sm.doInsert(args, setType);
            if(rtn < 1)
            	throw new Exception("EM_TRAN INSERT ERROR");

            Commit();

        } catch(DBOpenException e) {
                    Rollback();
                throw new Exception("et_setInsert:"+e.getMessage());
        }
        return rtn;
    }



    /**
    * 신규사용자승인 승인 
    *  setApproval
    *  수정일 : 2013/03
    *  C.S.H
    */
    public SepoaOut setApproval(List< Map<String, String>>gridData)throws Exception, DBOpenException 
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id= info.getSession( "ID" );
        String add_date = SepoaDate.getShortDateString();
        String add_time = SepoaDate.getShortTimeString();
        Map<String , String> grid = null;

        try {
            StringBuffer tSQL = new StringBuffer();
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            
            for (int i = 0; i < gridData.size(); i++)
            {
                grid=(Map <String , String>) gridData.get(i);
                
                sm.removeAllValue();
                tSQL.delete(0, tSQL.length());
                tSQL.append(sm.addFixString("SELECT USER_TYPE FROM ICOMLUSR WHERE USER_ID = ?  \n"));sm.addStringParameter( MapUtils.getString( grid, "USER_ID", "" ));
                SepoaFormater sf = new SepoaFormater(sm.doSelect( tSQL.toString()));
                
//                if( sepoa.svc.common.constants.UserType.Seller.getValue().equals(sf.getValue("USER_TYPE",0)) ) {
//	                sm.removeAllValue();
//	                tSQL.delete(0, tSQL.length());
//	                tSQL.append( "  SELECT JOB_STATUS FROM ICOMVNGL                     \n");
//	                tSQL.append(sm.addFixString(" WHERE SELLER_CODE IN (SELECT COMPANY_CODE FROM ICOMLUSR WHERE USER_ID = ?)  \n"));sm.addStringParameter( MapUtils.getString( grid, "USER_ID", "" ));
//	                sf = new SepoaFormater(sm.doSelect( tSQL.toString()));
//	                if( !sepoa.svc.common.constants.JobStatus.Approved.getValue().equals(sf.getValue(0,0)) ) {
//	                	throw new Exception("ID : "+MapUtils.getString( grid, "USER_ID", "" )+" (해당 사용자의 회사가 ERP 전송이 완료 되지 않았습니다.)");
//	                }
//                }
            	sm.removeAllValue();
                tSQL.delete( 0, tSQL.length());
                tSQL.append( "  UPDATE ICOMLUSR SET                            \n");
                tSQL.append( "    SIGN_STATUS       = 'A'                   \n");
                tSQL.append( "  , MENU_PROFILE_CODE = ?                     \n");sm.addStringParameter( MapUtils.getString( grid, "MENU_PROFILE_CODE", "" ));
                tSQL.append( " 	, CHANGE_DATE       = ?                     \n");sm.addStringParameter( add_date );
                tSQL.append( " 	, CHANGE_TIME       = ?                     \n");sm.addStringParameter( add_time );
                tSQL.append( " 	, CHANGE_USER_ID    = ?                     \n");sm.addStringParameter( user_id  );
                tSQL.append( " 	, PW_RESET_FLAG     = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                   \n");
                tSQL.append( " 	, PASS_CHECK_CNT    = 0                     \n");
                tSQL.append( " 	, PW_RESET_DATE     = ?                     \n");sm.addStringParameter( add_date );            
                tSQL.append( "    WHERE USER_ID     = ?                     \n");sm.addStringParameter( MapUtils.getString( grid, "USER_ID", "" ));
                sm.doUpdate( tSQL.toString());
            }
	        /*for (int i = 0; i < gridData.size(); i++)
	        {
	            grid=(Map <String , String>) gridData.get(i);
	               sm.removeAllValue();
	               tSQL.delete( 0, tSQL.length());   
	               tSQL.append("    UPDATE ICOMVNGL SET                                      \n");
	               tSQL.append("    MENU_PROFILE_CODE   = ?                               \n");sm.addStringParameter( MapUtils.getString( grid, "MENU_PROFILE_CODE", "" ));
	               tSQL.append("    WHERE                                                 \n");
	               tSQL.append("    VENDOR_CODE         =                                 \n");
	               tSQL.append("    (SELECT COMPANY_CODE FROM ICOMLUSR WHERE USER_TYPE = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "' \n");
	               tSQL.append("    AND USER_ID         = ?                               \n");sm.addStringParameter( MapUtils.getString( grid, "USER_ID", "" ));
	               tSQL.append("    )                                                     \n");
	               rtn = sm.doUpdate( tSQL.toString());
	        }*/
	        
	        
        	for (int i = 0; i < gridData.size(); i++) {
		           grid=(Map <String , String>) gridData.get(i);
	               sm.removeAllValue();
	               tSQL.delete( 0, tSQL.length());  
	               
	               
	               tSQL.append("    INSERT INTO ICOMBACP (                      			\n");
	               tSQL.append("    CTRL_PERSON_ID,                                  	\n");
	               tSQL.append("    HOUSE_CODE,                                  			\n");
	               tSQL.append("    ADD_DATE,                                  			\n");
	               tSQL.append("    ADD_TIME,                                  			\n");
	               tSQL.append("    ADD_USER_ID,                                  		\n");
	               tSQL.append("    DEL_FLAG,                                  			\n");
	               tSQL.append("    COMPANY_CODE,                                  		\n");
	               tSQL.append("    CTRL_CODE,                                  		\n");
	               tSQL.append("    CTRL_TYPE )                                 		\n");
	               //tSQL.append("    PLANT_CODE   )                              		\n");
	               tSQL.append("    VALUES (                                        	\n");
	               tSQL.append("    ?                                					\n");sm.addStringParameter( MapUtils.getString( grid, "USER_ID", "" ));
	               tSQL.append("    ,?                               					\n");sm.addStringParameter( info.getSession("HOUSE_CODE"));
	               tSQL.append("    ,?                               					\n");sm.addStringParameter( add_date );
	               tSQL.append("    ,?                               					\n");sm.addStringParameter( add_time );
	               tSQL.append("    ,?                                					\n");sm.addStringParameter( user_id );
	               tSQL.append("    ,'N'                               					\n");
	               tSQL.append("    ,?                               					\n");sm.addStringParameter( company_code );
	               tSQL.append("    ,'JA0'                               				\n");
	               tSQL.append("    ,'P'                               					\n");
	               //tSQL.append("    ,'A0'                              					\n");
	               tSQL.append("    )                                             		\n");
	               rtn = sm.doInsert( tSQL.toString());
	        }
	        
            //성공적으로 작업을 수행했습니다.
            //setMessage(msg.getMessage("0000"));
  
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());
            setStatus(1);
            Commit();
            
        }catch(Exception e) {
            setStatus(0);
            Rollback();
            
            setMessage(e.getMessage().trim());
            
        } finally{
            
        }
        return getSepoaOut();
    } //setApproval() end


    /**
    * 신규사용자승인 / 사용자 현황 삭제 
    *  setDelete
    *  수정일 : 2013/03
    *  C.S.H
    */
    public SepoaOut setDelete(List<Map < String , String >> gridData)throws Exception, DBOpenException
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        Map <String , String > grid = null;
        

        try
        {
            
            StringBuffer tSQL = new StringBuffer();
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            
            for(int i=0; i < gridData.size(); i++){
                
                grid = (Map<String , String >) gridData.get(i);
                
                // ICOMLUSR 테이블 삭제
                sm.removeAllValue();
                tSQL.delete( 0, tSQL.length());                
                
                tSQL.append( " DELETE FROM ICOMLUSR        \n");               
                tSQL.append( " WHERE USER_ID = ?        \n");sm.addStringParameter(MapUtils.getString( grid, "USER_ID", "" ));    
  
                rtn = sm.doDelete( tSQL.toString());
                
                // ICOMLUSR_MENU 테이블 삭제
              /*  sm.removeAllValue();
                tSQL.delete( 0, tSQL.length());                
                
                tSQL.append( " DELETE FROM ICOMLUSR_MENU        \n");               
                tSQL.append( " WHERE USER_ID = ?        \n");sm.addStringParameter(MapUtils.getString( grid, "USER_ID", "" ));    
  
                rtn = sm.doDelete( tSQL.toString());*/
                
            
                // icomaddr 테이블 삭제
                sm.removeAllValue();
                tSQL.delete( 0, tSQL.length());
                
                tSQL.append(" DELETE FROM icomaddr         \n");    			
    			tSQL.append(" WHERE CODE_NO    = ?      \n");sm.addStringParameter(MapUtils.getString( grid, "USER_ID", "" ));
    			tSQL.append(" AND CODE_TYPE    ='3'     \n");
			
    			rtn = sm.doDelete( tSQL.toString());
			
            } // for end


            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());
            Commit();
            
        }catch(DBOpenException e) {
            setStatus(0);
            setMessage(e.getMessage().trim());
            Rollback();
            throw new Exception("setUpdate:"+e.getMessage());
        }
        return getSepoaOut();
    }// setDelete() end
    
////////////////////////////////////////////////////////////////////////////////////////////////////////// 
//                                                                                                      //
//                       jsp에서 없는 로직. 주석처리 하였습니다. 2013.03.22 C.S.H                       //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////

   /* public SepoaOut setStatusD(String[][] args){

        try
        {
            Logger.debug.println(id,this,"######setStatusD#######");
            //Header Insert
            String add_date = SepoaDate.getShortDateString();
            String add_time = SepoaDate.getShortTimeString();

            int rtn = et_setStatusD(args,add_date, add_time, id);
            setValue("Update Row=" + rtn);
            setStatus(1);
            //setMessage(msg.getMessage("0000"));
            setMessage("성공적으로 삭제되었습니다.");
        }catch(Exception e) {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(e.getMessage().trim());
            //setMessage(msg.getMessage("0001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }

    private int et_setStatusD(String[][] args, String add_date, String add_time, String id)
                             throws Exception, DBOpenException {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();

    try {
                StringBuffer tSQL = new StringBuffer();
                StringBuffer tSQL1 = new StringBuffer();
                StringBuffer tSQL2 = new StringBuffer();


                tSQL.append( " UPDATE ICOMLUSR ");
                tSQL.append( " SET DEL_FlAG = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "', ");
                tSQL.append( " 	CHANGE_DATE = '"+add_date+"',  ");
                tSQL.append( " 	CHANGE_TIME = '"+add_time+"',  ");
                tSQL.append( " 	CHANGE_USER_ID = '"+id+"',  ");
                tSQL.append( " 	CHANGE_USER_NAME_LOC = '"+name_loc+"',  ");
                tSQL.append( " 	CHANGE_USER_NAME_ENG = '"+name_eng+"',  ");
                tSQL.append( " 	CHANGE_USER_DEPT = '"+depart+"'  ");
                //tSQL.append( " WHERE HOUSE_CODE = ? ");
                tSQL.append( " WHERE USER_ID = ? ");

                SepoaSQLManager sm = new SepoaSQLManager(id,this,ctx,tSQL.toString());

                //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
                String[] setType = {"S"};

                rtn = sm.doUpdate(args, setType);




                tSQL1.append( " DELETE FROM srulr ");
                //tSQL1.append( " WHERE HOUSE_CODE = ? ");
                tSQL1.append( " WHERE USER_ID = ? ");

                SepoaSQLManager sm1 = new SepoaSQLManager(id,this,ctx,tSQL1.toString());
                sm1.doDelete(args, setType);

                tSQL2.append( " DELETE FROM srulr ");
                //tSQL2.append( " WHERE HOUSE_CODE = ? ");
                tSQL2.append( " WHERE NEXT_SIGN_USER_ID = ? ");

                SepoaSQLManager sm2 = new SepoaSQLManager(id,this,ctx,tSQL2.toString());
                sm2.doDelete(args, setType);


                Commit();
        }catch(Exception e) {
                Rollback();
                throw new Exception("et_setSave:"+e.getMessage());
        } finally{}
        return rtn;
    }
*/


    /**
    * 사용자 등록 페이지
    * ID중복체크
    * getDuplicate
    * 수정일 : 2013/03
    */
    public SepoaOut getDuplicate(Map <String , String > allData){
        try
        {

            String cnt = null;
            Map< String, String >   headerData  = null;
            headerData = MapUtils.getMap( allData, "headerData" );
            
            
            cnt = Check_Duplicate(allData);
            
            setValue(cnt);
            if(  "0".equals( cnt )){
            setStatus(1);
            }else{
                setStatus(0);
            }
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());

        }catch(Exception e)
        {
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            
        }
          return getSepoaOut();
    }


    private String Check_Duplicate(Map <String , String> header)
    throws Exception
    {
        String cnt = null;
        ConnectionContext ctx = getConnectionContext();
        SepoaFormater wf= null;
        try
        {
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( "  SELECT                              \n");
            tSQL.append( " 	COUNT(*) AS CNT                     \n");
            tSQL.append( "  FROM 								\n");
            tSQL.append( " 	ICOMLUSR LUSR               			\n");
            tSQL.append( " 	WHERE  						        \n");
            tSQL.append(sm.addFixString( "   LUSR.USER_ID = ?   \n"));sm.addStringParameter( MapUtils.getString( header, "user_id", "" ));           

            wf = new SepoaFormater(sm.doSelect(tSQL.toString()));
            
            cnt = wf.getValue("CNT", 0);
            
         
           
        }
        catch(Exception e) {
                throw new Exception("Check_Duplicate:"+e.getMessage());
        }
        finally
        {

        }
        return cnt;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    /** ID 찾기 Buyer
     *  이부분은 Session이 없는 바깥쪽도 건드린다.
     */
    public SepoaOut FindID(String[] args){
        try
        {
            String rtn = null;
            rtn = et_FindID(args);
            setValue(rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());

        }catch(Exception e)
        {
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            Logger.err.println("JHYOON",this,"Exception e =" + e.getMessage());
        }
          return getSepoaOut();
    }


    private String et_FindID(String[] args)
    throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        try
        {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( " SELECT                                											\n");
            tSQL.append( " 	LUSR.USER_ID,                       										\n");
            tSQL.append( " 	ADDR.PHONE_NO2                       								\n");
            tSQL.append( " FROM 																				\n");
            tSQL.append( " 	ICOMLUSR LUSR, ICOMADDR ADDR              				\n");
            tSQL.append( " WHERE   																		\n");
            tSQL.append( " 	LUSR.HOUSE_CODE = ADDR.HOUSE_CODE					\n");
            tSQL.append( " 	AND LUSR.USER_ID = ADDR.CODE_NO						\n");
            tSQL.append( " <OPT=F,S> AND LUSR.HOUSE_CODE = ? </OPT> 			\n");
            tSQL.append( " <OPT=F,S> AND LUSR.EMPLOYEE_NO = ? </OPT> 		\n");
            tSQL.append( " <OPT=F,S> AND LUSR.USER_NAME_LOC = ? </OPT>  	\n");

            SepoaSQLManager sm = new SepoaSQLManager("JHYOON",this,ctx,tSQL.toString());

            rtn = sm.doSelect(args);
            if(rtn == null)
            	throw new Exception("SQL Manager is Null");
        }
        catch(Exception e) {
                throw new Exception("Check_Duplicate:"+e.getMessage());
        }
        finally
        {

        }
        return rtn;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    /** ID 찾기 Supplier
     *  이부분은 Session이 없는 바깥쪽도 건드린다.
     */
    public SepoaOut FindID1(String[] args){
        try
        {
            String rtn = null;
            rtn = et_FindID1(args);
            setValue(rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());

        }catch(Exception e)
        {
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            Logger.err.println("JHYOON",this,"Exception e =" + e.getMessage());
        }
          return getSepoaOut();
    }


    private String et_FindID1(String[] args)
    throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        try
        {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( " SELECT                                															\n");
            tSQL.append( " 	LUSR.USER_ID,                       														\n");
            tSQL.append( " 	ADDR.PHONE_NO2                       												\n");
            tSQL.append( " FROM 																								\n");
            tSQL.append( " 	ICOMADDR ADDR, ICOMLUSR LUSR, ICOMVNGL VNGL  			\n");
            tSQL.append( " WHERE   																						\n");
            tSQL.append( " 	ADDR.HOUSE_CODE = LUSR.HOUSE_CODE									\n");
            tSQL.append( " 	AND ADDR.CODE_NO = LUSR.USER_ID										\n");
            tSQL.append( " 	AND LUSR.HOUSE_CODE = VNGL.HOUSE_CODE							\n");
            tSQL.append( " 	AND LUSR.COMPANY_CODE = VNGL.VENDOR_CODE					\n");
            tSQL.append( " <OPT=F,S> AND ADDR.HOUSE_CODE = ? </OPT> 							\n");
            tSQL.append( " <OPT=F,S> AND VNGL.IRS_NO = ? </OPT> 									\n");
            tSQL.append( " <OPT=F,S> AND LUSR.USER_NAME_LOC LIKE '%'" + DBUtil.getAndSeparator() + "?" + DBUtil.getAndSeparator() + "'%' </OPT>  	\n");

            SepoaSQLManager sm = new SepoaSQLManager("JHYOON",this,ctx,tSQL.toString());

            rtn = sm.doSelect(args);
            if(rtn == null)
            	throw new Exception("SQL Manager is Null");
        }
        catch(Exception e) {
                throw new Exception("Check_Duplicate:"+e.getMessage());
        }
        finally
        {

        }
        return rtn;
    }



    /**
    * 사용자 현황 페이지
    * 수정 / 상세보기 화면 조회
    * 상세보기는 jsp 상에서 존재하지 않고 수정시에만 사용하고 있다. 2013.03 C.S.H
    * getDisplay
    * 수정일 : 2013/03
    */
    public sepoa.fw.srv.SepoaOut getDisplay(String[] args)
    {
    	String user_id = info.getSession("ID");
        try {
            String rtn = et_getDisplay(args);
            setValue(rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());
        }catch(Exception e){
            
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            Logger.err.println(user_id,this, e.getMessage());
        }
        return getSepoaOut();
    }

    public String et_getDisplay(String[] args) throws Exception
    {
    	String user_id = info.getSession("ID");
        
    	String result = null;
        ConnectionContext ctx = getConnectionContext();

        String company_code = info.getSession("COMPANY_CODE");
        try
        {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append(" SELECT                                                                         \n");
            tSQL.append("   PASSWORD                                                                     \n");
            tSQL.append(" , USER_NAME_LOC                                                                \n");
            tSQL.append(" , USER_NAME_ENG                                                                \n");
            tSQL.append(" , COMPANY_NAME_LOC                                                             \n");
            tSQL.append(" , DEPT_NAME_LOC                                                                \n");
            tSQL.append(" , RESIDENT_NO                                                                  \n");
            tSQL.append(" , EMPLOYEE_NO                                                                  \n");
            tSQL.append(" , PHONE_NO                                                                     \n");
            tSQL.append(" , EMAIL                                                                        \n");
            tSQL.append(" , PHONE_NO2 AS MOBILE_NO                                                       \n");
            tSQL.append(" , FAX_NO                                                                       \n");
            tSQL.append(" , POSITION                                                                     \n");
            tSQL.append(" , POSITION_NAME                                                                \n");
            tSQL.append(" , LANGUAGE_NAME                                                                \n");
            tSQL.append(" , TIME_ZONE                                                                    \n");
            tSQL.append(" , ZIP_CODE                                                                     \n");
            tSQL.append(" , COUNTRY_NAME                                                                 \n");
            //tSQL.append(" , PLM_USER_FLAG                                                                \n");

            if (SEPOA_DB_VENDOR.equals("MYSQL"))
    		{
            	tSQL.append(" , (SELECT (CASE SUBSTR(CODE, 1, 2) WHEN 'KR' THEN TEXT2 ELSE TEXT1 END) AS TEXT    \n");
    		}
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
    		{
            	tSQL.append(" , (SELECT (CASE SUBSTRING(CODE, 1, 2) WHEN 'KR' THEN TEXT2 ELSE TEXT1 END) AS TEXT  \n");
    		}
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                tSQL.append(" , (SELECT (CASE SUBSTRING(CODE, 1, 2) WHEN 'KR' THEN TEXT2 ELSE TEXT1 END) AS TEXT  \n");
            }
            else if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
            	tSQL.append(" , (SELECT DECODE( SUBSTR(CODE,1,2) , 'KR' , TEXT2 , TEXT1) AS TEXT         \n");
            }

            tSQL.append("    FROM SCODE                                                                  \n");
            tSQL.append("    WHERE TYPE = 'M004'                                                         \n");

            if (SEPOA_DB_VENDOR.equals("MYSQL") || SEPOA_DB_VENDOR.equals("ORACLE"))
    		{
            	tSQL.append("    AND SUBSTR(CODE ,1,2) = US.COUNTRY                                      \n");
            	tSQL.append("    AND SUBSTR(CODE ,3,2)   = US.CITY_CODE                                  \n");
    		}
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
    		{
            	tSQL.append("    AND SUBSTRING(CODE ,1,2) = US.COUNTRY                                   \n");
            	tSQL.append("    AND SUBSTRING(CODE ,3,2)   = US.CITY_CODE                               \n");
    		}
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                tSQL.append("    AND SUBSTRING(CODE ,1,2) = US.COUNTRY                                   \n");
                tSQL.append("    AND SUBSTRING(CODE ,3,2)   = US.CITY_CODE                               \n");
            }

            tSQL.append("    AND LANGUAGE = '" + info.getSession("LANGUAGE") + "'                        \n");
            tSQL.append("    AND USE_FLAG = '" + sepoa.fw.util.CommonUtil.Flag.Yes.getValue() + "'                                                          \n");
            tSQL.append("    AND " + DB_NULL_FUNCTION + "(DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' ) AS CITY_NAME            \n");
            tSQL.append(" , STATE                                                                        \n");
            tSQL.append(" , ADDRESS_LOC                                                                  \n");
            tSQL.append(" , ADDRESS_ENG                                                                  \n");
            tSQL.append(" , PR_LOCATION_NAME                                                             \n");
            tSQL.append(" , DEPT                                                                         \n");
            tSQL.append(" , CITY_CODE                                                                    \n");
            tSQL.append(" , PR_LOCATION                                                                  \n");
            tSQL.append(" , COMPANY_CODE                                                                 \n");
           // tSQL.append(" , PLANT_CODE                                                                 \n");
            tSQL.append(" , PLANT_NAME_LOC                                                         \n");
            tSQL.append(" , LANGUAGE                                                                     \n");
            tSQL.append(" , COUNTRY                                                                      \n");
            tSQL.append(" , MENU_PROFILE_CODE                                                            \n");
            tSQL.append(" , MENU_PROFILE_NAME                                                            \n");
            tSQL.append(" , MANAGER_POSITION                                                             \n");
            tSQL.append(" , MANAGER_POSITION_NAME                                                        \n");
            tSQL.append(" , USER_TYPE                                                                    \n");
            tSQL.append(" , TEXT_USER_TYPE                                                               \n");
            tSQL.append(" , WORK_TYPE                                                                    \n");
            tSQL.append(" , TEXT_WORK_TYPE                                                               \n");      
            tSQL.append(" , TIME_ZONE_NAME                                                               \n");
            tSQL.append(" , DEPT_NAME_LOC                                                                \n");
            tSQL.append(" , DEPT                                                                         \n");
           // tSQL.append(" , USER_JIKIN                                                                   \n");        
            tSQL.append(" , UC_YN                                                                         \n");
            
            
            tSQL.append(" FROM (                                    \n");
            tSQL.append(" SELECT                                    \n");
            tSQL.append(" 	  a.user_id AS USER_ID,                 \n");
            tSQL.append(" 	  a.PASSWORD AS PASSWORD,               \n");
            tSQL.append(" 	  a.user_name_loc AS USER_NAME_LOC,     \n");
            tSQL.append(" 	  a.USER_NAME_ENG AS USER_NAME_ENG,     \n");
            tSQL.append(" 	  a.COMPANY_CODE AS COMPANY_CODE,       \n");
            tSQL.append("     (case when (a.USER_TYPE = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "') then v.VENDOR_NAME_LOC else c.COMPANY_NAME_LOC end) AS COMPANY_NAME_LOC, \n ");
            tSQL.append("     (case when (a.USER_TYPE = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "') then v.VENDOR_NAME_ENG else c.COMPANY_NAME_ENG end) AS COMPANY_NAME_ENG, \n ");
            tSQL.append("     a.PLANT_CODE AS PLANT_CODE,       \n");
            tSQL.append("     (case when (a.USER_TYPE = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "') then '' else (select p.PLANT_NAME_LOC from ICOMOGPL p WHERE p.COMPANY_CODE = a.COMPANY_CODE AND p.PLANT_CODE = a.PLANT_CODE) end) AS PLANT_NAME_LOC, \n ");
            tSQL.append("     a.DEPT AS DEPT,                                                                                          \n");
           // tSQL.append("     (case when (a.USER_TYPE = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "') then A.DEPT_NAME     \n");
            tSQL.append("	  b.DEPT_NAME_LOC AS DEPT_NAME_LOC,                                                                                       \n");
            tSQL.append("     a.USER_TYPE AS USER_TYPE,                                                                                                         \n");
            tSQL.append("     (case when (a.USER_TYPE = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "') then " + SEPOA_DB_OWNER + "getcodetext2('M103',a.USER_TYPE, '" + info.getSession("LANGUAGE") + "') \n");
            tSQL.append("	  else c.COMPANY_NAME_LOC end) AS TEXT_USER_TYPE,                                                                                   \n");
            tSQL.append("     a.WORK_TYPE AS WORK_TYPE,                                                                                         \n");
            tSQL.append("     " + SEPOA_DB_OWNER + "getcodetext1('M104',a.WORK_TYPE, '" + info.getSession("LANGUAGE") + "') AS TEXT_WORK_TYPE,  \n");
            tSQL.append("     a.RESIDENT_NO AS RESIDENT_NO,a.EMPLOYEE_NO AS EMPLOYEE_NO,                                                        \n");
            tSQL.append("     d.PHONE_NO1 AS PHONE_NO,                                                                                          \n");
            tSQL.append("     d.EMAIL AS EMAIL,                                                                                                 \n");
            tSQL.append("     d.FAX_NO AS FAX_NO,                                                                                               \n");
            tSQL.append("     (case when (" + SEPOA_DB_OWNER + "CNV_NULL(a.USER_TYPE,'NULL') = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "') then " + SEPOA_DB_OWNER + "getcodetext2('M106',a.POSITION, '" + info.getSession("LANGUAGE") + "') \n ");
            tSQL.append("           else " + SEPOA_DB_OWNER + "getcodetext2('M106',a.POSITION, '" + info.getSession("LANGUAGE") + "') end) AS POSITION_NAME, \n ");
            tSQL.append("     a.MANAGER_POSITION AS MANAGER_POSITION, \n ");
            tSQL.append("     (case when (a.USER_TYPE = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "') then " + SEPOA_DB_OWNER + "getcodetext2('M107',a.MANAGER_POSITION, '" + info.getSession("LANGUAGE") + "')             \n ");
            tSQL.append("     else " + SEPOA_DB_OWNER + "getcodetext2('M107',a.MANAGER_POSITION, '" + info.getSession("LANGUAGE") + "') end) AS MANAGER_POSITION_NAME,             \n ");
            tSQL.append("     a.LANGUAGE AS LANGUAGE,                       \n");
            tSQL.append("     " + SEPOA_DB_OWNER + "getcodetext2('M013',a.LANGUAGE, '" + info.getSession("LANGUAGE") + "') AS LANGUAGE_NAME,        \n");
            tSQL.append("     a.TIME_ZONE AS TIME_ZONE,                     \n");
            tSQL.append("     d.ZIP_CODE AS ZIP_CODE,                       \n");
            tSQL.append("     a.COUNTRY AS COUNTRY,                         \n");
            tSQL.append("     " + SEPOA_DB_OWNER + "getcodetext2('M001',a.COUNTRY, '" + info.getSession("LANGUAGE") + "') AS COUNTRY_NAME,          \n");
            tSQL.append("     a.CITY_CODE AS CITY_CODE,a.STATE AS STATE,    \n");
            tSQL.append("     d.ADDRESS_LOC AS ADDRESS_LOC,                 \n");
            tSQL.append("     d.ADDRESS_ENG AS ADDRESS_ENG,                 \n");
            tSQL.append("     a.PR_LOCATION AS PR_LOCATION,                 \n");
            //tSQL.append("     a.PLM_USER_FLAG,                              \n");
            tSQL.append("     " + SEPOA_DB_OWNER + "getcodetext2('M062',a.PR_LOCATION, '" + info.getSession("LANGUAGE") + "') AS PR_LOCATION_NAME,  \n");
            tSQL.append("     a.MENU_PROFILE_CODE AS MENU_PROFILE_CODE,     \n");
            tSQL.append("     (select distinct smupd.MENU_NAME AS menu_name \n");
            tSQL.append("      from smupd \n ");
            tSQL.append("      where (smupd.MENU_PROFILE_CODE = a.MENU_PROFILE_CODE)) AS MENU_PROFILE_NAME,                                         \n");
            tSQL.append("     " + SEPOA_DB_OWNER + "getcodetext1('M075',a.TIME_ZONE, '" + info.getSession("LANGUAGE") + "') AS TIME_ZONE_NAME,      \n");
            tSQL.append("     d.PHONE_NO2 AS PHONE_NO2,                         \n");
            tSQL.append("     a.POSITION AS POSITION,                          \n");            
            tSQL.append("     NVL(a.UC_YN,'Y') AS UC_YN                                  \n");
                        
           // tSQL.append("     a.USER_JIKIN                                      \n");            
            tSQL.append("   from ICOMLUSR a left join icomogdp b                      \n");
            tSQL.append("     on a.COMPANY_CODE = b.COMPANY_CODE                \n");
            tSQL.append("    and a.DEPT = b.DEPT                                \n");
            tSQL.append("    and a.PR_LOCATION = b.PR_LOCATION                  \n");
            tSQL.append("    left join ICOMCMGL c                                  \n");
            tSQL.append("     on a.COMPANY_CODE = c.COMPANY_CODE                \n");
            tSQL.append("   left join ICOMVNGL v                                   \n");
            tSQL.append("     on a.COMPANY_CODE = v.vendor_CODE                 \n");
            tSQL.append("   left join icomaddr d                                   \n");
            tSQL.append("     on a.user_id = d.CODE_NO                          \n");
            tSQL.append("  WHERE UPPER(a.USER_ID) = UPPER('" + args[0] + "')                     \n");
            tSQL.append("    and '3' = d.CODE_TYPE                              \n");
            tSQL.append("    and " + DB_NULL_FUNCTION + "(c.DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' \n");
            tSQL.append("    and " + DB_NULL_FUNCTION + "(v.DEL_FLAG, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' \n");            

            if(sepoa.svc.common.constants.UserType.Seller.getValue().equals(info.getSession("USER_TYPE")) || sepoa.svc.common.constants.UserType.Partner.getValue().equals(info.getSession("USER_TYPE")) )
            {
            	tSQL.append(" and a.company_code = '" + info.getSession("COMPANY_CODE") + "' \n");
            }

            tSQL.append(" ) us  \n");
            
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            result = sm.doSelect();
            if(result == null) {
            	throw new Exception("SQLManager is null");
            }
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M001", "M004", "M103", "M104", "M105", "M106", "M107", "M013", "M062", "M075" );
        }catch(Exception ex) {
            throw new Exception("et_getDisplay()"+ ex.getMessage());
        }
        return result;
    }

    /**
    * 사용자 변경 페이지
    * 사용자 변경 팝업창에서 사용자의 상세정보를 조회한다.
    * getDisplay2
    * 수정일 : 2013/03
    */
    public sepoa.fw.srv.SepoaOut getDisplay2(String[] args)
    {
    	String user_id = info.getSession("ID");
        try {
            String rtn = et_getDisplay2(args);
            setValue(rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());
        }catch(Exception e){
            
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            Logger.err.println(user_id,this, e.getMessage());
        }
        return getSepoaOut();
    }

    public String et_getDisplay2(String[] args) throws Exception
    {
    	String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
    	String result = null;
        ConnectionContext ctx = getConnectionContext();

        String company_code = info.getSession("COMPANY_CODE");
        try
        {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append("	SELECT                             													\n");
            tSQL.append(" 	LUSR.PASSWORD                                     									\n");
            tSQL.append(" 	, LUSR.USER_NAME_LOC                              									\n");
            tSQL.append(" 	, LUSR.USER_NAME_ENG                              									\n");
            tSQL.append(" 	, LUSR.WORK_TYPE                              										\n");
            tSQL.append(" 	, LUSR.USER_TYPE	              													\n");
            tSQL.append("   , (case when lusr.user_type = '" + sepoa.svc.common.constants.UserType.Partner.getValue() + "' then 'Partner' when lusr.user_type = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "'          \n");
            tSQL.append("     then 'Supplier' else 'Buyer' end) AS USER_TYPE_LOC								\n");
            tSQL.append("  	, " + SEPOA_DB_OWNER + "getcodetext2('M104', lusr.work_type, '" + info.getSession("LANGUAGE") + "') AS WORK_TYPE_LOC    \n");
            tSQL.append("  	, LUSR.USER_ID                                    		\n");
            tSQL.append("  	, LUSR.COMPANY_CODE                               		\n");
            tSQL.append("  	, ADDR.PHONE_NO1                                  		\n");
            tSQL.append("  	, ADDR.EMAIL                                      		\n");
            tSQL.append("  	, ADDR.PHONE_NO2                                  		\n");
            tSQL.append("  	, ADDR.FAX_NO                                     		\n");
            tSQL.append(" FROM                                                		\n");
            tSQL.append(" 	ICOMLUSR LUSR, icomaddr ADDR                      			\n");
            tSQL.append(" WHERE                                               		\n");         
            tSQL.append(" 	LUSR.USER_ID = ADDR.CODE_NO                   			\n");           
            tSQL.append("    and code_type = '3'                                    \n");
            tSQL.append(" 	<OPT=F,S>  AND LUSR.USER_ID = ?    </OPT>               \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            result = sm.doSelect(args);
            if(result == null) {
            	throw new Exception("SQLManager is null");
            }
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M104" );
        }catch(Exception ex) {
            throw new Exception("et_getDisplay2()"+ ex.getMessage());
        }
        return result;
    }
    
    public SepoaOut setUserInfoUpdate(String program, String pwd, String[][] args_user, String[][] args_addr, String user_info_flag) {
        int rtn = -1;

        try {
        	        	
            if (program.equals("use_bd_upd2")) {
            	//로그인한사람의 정보조회한다
            	String[] args = {info.getSession("ID"), args_user[0][20]};
            	SepoaOut value = getCheck(args);
            	
            	if(value.status == 1){
        			//SepoaFormater wf = new SepoaFormater(value.result[0]);
        			String o_cnt = value.result[0];
        			
        			if("0".equals(o_cnt)){
        				//비밀번호가 틀림
        				setStatus(0);
                        setMessage(msg.get("AD_133.MSG_0118").toString());//비밀번호가 틀렸습니다.
        			}else{
        				//비밀번호가 맞음
        				rtn = et_setUserInfoUpdate2(pwd, args_user, args_addr, user_info_flag);
                		setValue("Change_Row=" + rtn);
                        setStatus(1);
                        setMessage(msg.get("AD_133.MSG_0115").toString());//성공적으로 작업을 수행했습니다.	
        			}
        		}else{
        			setStatus(0);
                    setMessage(msg.get("AD_133.MSG_0119").toString());//처리중 에러가 발생했습니다.
        		}
            } else { //
                //rtn = et_setUserInfoUpdate3(pwd,user_id, name_loc, name_eng, house_code, args, status, change_date, change_time);
            }
            
        }catch(Exception e) {
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
        }
        return getSepoaOut();
    }

    public SepoaOut setUserInfoUpdate2(String[][] args_user, String[][] args_addr) {

        int rtn = -1;

        try {

            rtn = et_setUserInfoUpdate4(args_user, args_addr);

            setValue("Change_Row=" + rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());

        } catch(Exception e) {
            
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
        }
        return getSepoaOut();
    }

    private int et_setUserInfoUpdate4(String[][] args_user, String[][] args_addr) throws Exception, DBOpenException {

        int result = -1;

        ConnectionContext ctx = getConnectionContext();
        String status       = "N";  /*수정된 항목의 status는 "R"이다.*/
        String user_id      = info.getSession("ID");
        String user_loc     = info.getSession("NAME_LOC");
        String user_eng     = info.getSession("NAME_ENG");
        String house_code   = info.getSession("HOUSE_CODE");
        String change_date  = SepoaDate.getShortDateString();
        String change_time  = SepoaDate.getShortTimeString();

        try {

            StringBuffer tSQL = new StringBuffer();

            tSQL.append( "UPDATE ICOMLUSR									         \n" );
            tSQL.append( "SET	 DEL_FLAG				    = '"+status+"'       \n" );
            tSQL.append( "		,CHANGE_USER_ID			= '"+user_id+"'          \n" );
            tSQL.append( "		,CHANGE_DATE			= '"+change_date+"'      \n" );
            tSQL.append( "		,CHANGE_TIME			= '"+change_time+"'      \n" );
            tSQL.append( "		,USER_NAME_ENG  			= ?                  \n" );
            tSQL.append( "		,EMAIL  			= ?                          \n" );
            tSQL.append( "		,PW_RESET_FLAG  			= '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                \n" );           
            tSQL.append( "  WHERE USER_ID = ?                                    \n" );


            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            String[] settype = { "S","S", "S" };
            
            args_user[0][1] = SepoaString.encString ( args_user[0][1] , "EMAIL" ); 
            result = sm.doUpdate(args_user,settype);

            if(result<1)
            	throw new Exception("icomaddr UPDATE ERROR");

			if (args_addr.length > 0)
			{
				if (args_addr[0].length == 4)
				{
					tSQL = new StringBuffer();
					tSQL.append(" UPDATE icomaddr SET                     \n");
					tSQL.append("   PHONE_NO1      = ?                 \n");
					tSQL.append("   , PHONE_NO2    = ?                 \n");
					tSQL.append("   , FAX_NO       = ?                 \n");				
					tSQL.append(" WHERE CODE_NO      = ?               \n");

					args_addr[0][0] = SepoaString.encString ( args_addr[0][0] , "PHONE" ); 
					args_addr[0][1] = SepoaString.encString ( args_addr[0][1] , "PHONE" ); 
					args_addr[0][2] = SepoaString.encString ( args_addr[0][2] , "PHONE" ); 
		            
					sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
					String[] settype2 = { "S","S","S","S" };

					result = sm.doUpdate(args_addr,settype2);
				} else if (args_addr[0].length == 5) {
					tSQL = new StringBuffer();
					tSQL.append(" UPDATE icomaddr SET                     \n");
					tSQL.append("   PHONE_NO1      = ?                 \n");
					tSQL.append("   , PHONE_NO2    = ?                 \n");
					tSQL.append("   , FAX_NO       = ?                 \n");
					tSQL.append("   , EMAIL        = ?                 \n");				
					tSQL.append(" WHERE CODE_NO    = ?                 \n");

					sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
					String[] settype2 = { "S","S","S","S","S" };
					args_addr[0][0] = SepoaString.encString ( args_addr[0][0] , "PHONE" ); 
					args_addr[0][1] = SepoaString.encString ( args_addr[0][1] , "PHONE" ); 
					args_addr[0][2] = SepoaString.encString ( args_addr[0][2] , "PHONE" ); 
					args_addr[0][3] = SepoaString.encString ( args_addr[0][3] , "EMAIL" ); 

					result = sm.doUpdate(args_addr,settype2);
				}
			}

			if(result<1)
            	throw new Exception("icomaddr UPDATE ERROR");
            Commit();

        }catch(Exception e) {
            Rollback();
            throw new Exception("et_setUserInfoUpdate: " + e.getMessage());
        }
        return result;
    }
    
    
    /**
    * 사용자 변경 페이지
    * 사용자 변경 팝업창에서 변경된 데이터를 UPDATE 한다.
    * et_setUserInfoUpdate2
    * 
    */
    private int et_setUserInfoUpdate2(String pwd, String[][] args_user, String[][] args_addr, String user_info_flag) throws Exception, DBOpenException {
        int result = -1;

        ConnectionContext ctx = getConnectionContext();
        String status       = "N";  /*수정된 항목의 status는 "R"이다.*/
        String user_id      = info.getSession("ID");
        String user_loc     = info.getSession("NAME_LOC");
        String user_eng     = info.getSession("NAME_ENG");
        String house_code   = info.getSession("HOUSE_CODE");
        String change_date  = SepoaDate.getShortDateString();
        String change_time  = SepoaDate.getShortTimeString();
        
        try {
        	ParamSql ssm = new ParamSql(info.getSession("ID"), this, ctx);
            //SimpleSession SS_hv = new SimpleSession();
            //String hashVal = SS_hv.Hash(pwd);

            StringBuffer tSQL = new StringBuffer();
            ssm.removeAllValue();
            tSQL.delete(0, tSQL.length());

            tSQL.append( "UPDATE ICOMLUSR                                  \n" );
            tSQL.append( "SET    DEL_FLAG               = '"+status+"'      \n" );
            tSQL.append( "      ,CHANGE_USER_ID         = '"+user_id+"'     \n" );
            tSQL.append( "      ,CHANGE_DATE            = '"+change_date+"' \n" );
            tSQL.append( "      ,CHANGE_TIME            = '"+change_time+"' \n" );
            
            //tSQL.append( "      ,DRM_ID                 = ?                 \n" );
            tSQL.append( "      ,WORK_TYPE              = '"+args_user[0][1]+"'                 \n" );
            tSQL.append( "      ,COMPANY_CODE           = '"+args_user[0][2]+"'                 \n" );
           // tSQL.append( "      ,PLANT_CODE           = ?                 \n" );
            if( !pwd.equals(""))
            {
                tSQL.append( "      ,PASSWORD           = '"+SepoaString.encString ( pwd , "PWD")+"'         \n" );
             
            }
            tSQL.append( "      ,USER_NAME_LOC          = '"+args_user[0][3]+"'                 \n" );
            tSQL.append( "      ,USER_NAME_ENG          = '"+args_user[0][4]+"'                 \n" );
            tSQL.append( "      ,DEPT                   = '"+args_user[0][5]+"'                 \n" );
            //tSQL.append( "      ,DEPT_NAME              = ?                 \n" );
            tSQL.append( "      ,RESIDENT_NO            = '"+args_user[0][6]+"'                 \n" );
            tSQL.append( "      ,EMPLOYEE_NO            = '"+args_user[0][7]+"'                 \n" );
            tSQL.append( "      ,EMAIL                  = '"+args_user[0][8]+"'                 \n" );
            tSQL.append( "      ,POSITION               = '"+args_user[0][9]+"'                 \n" );
            tSQL.append( "      ,MANAGER_POSITION       = '"+args_user[0][10]+"'                 \n" );
            tSQL.append( "      ,LANGUAGE               = '"+args_user[0][11]+"'                 \n" );
            tSQL.append( "      ,PR_LOCATION            = '"+args_user[0][12]+"'                 \n" );
            tSQL.append( "      ,TIME_ZONE              = '"+args_user[0][13]+"'                 \n" );
            tSQL.append( "      ,COUNTRY                = '"+args_user[0][14]+"'                 \n" );
            tSQL.append( "      ,CITY_CODE              = '"+args_user[0][15]+"'                 \n" );
            tSQL.append( "      ,STATE                  = '"+args_user[0][16]+"'                 \n" );
           
            tSQL.append( "      ,MENU_PROFILE_CODE      = '"+args_user[0][17]+"'                 \n" );
            tSQL.append( "      ,PASS_CHECK_CNT      = 0                 \n" );
            //tSQL.append( "      ,plm_user_flag          = ?                 \n" );
           // tSQL.append( "      ,USER_JIKIN             = ?                 \n" );            
            tSQL.append( "      ,UC_YN                  = '"+args_user[0][21]+"'                 \n" );
            
            if( !pwd.equals("") && ! sepoa.fw.util.CommonUtil.Flag.Yes.getValue().equals(user_info_flag) )
            {
           
            }

   
            tSQL.append( "  WHERE USER_ID = '"+args_user[0][19]+"'                                 \n" );


            /*SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            String[] settype = {
                    "S","S","S","S","S", "S","S","S","S","S",
                    "S","S","S","S","S", "S","S","S","S","S"
                    ,"S","S","S"
                    };*/
            
            args_user[0][8] = SepoaString.encString ( args_user[0][8] , "EMAIL" );
            //result = sm.doUpdate(args_user,settype);
            result= ssm.doUpdate(tSQL.toString());
            if(result<1)
                throw new Exception("ICOMLUSR UPDATE ERROR");

            /**
             * ICOMLUSR_MENU
             * */
            /*ParamSql pm0 = new ParamSql(info.getSession("ID"), this, ctx);
            tSQL = new StringBuffer();
            tSQL.delete(0, tSQL.length());
            tSQL.append( "UPDATE ICOMLUSR_MENU                             \n" );
            tSQL.append( "SET MENU_PROFILE_CODE     = ?                 \n" );pm0.addStringParameter(args_user[0][19]);
            tSQL.append( "WHERE USER_ID 			= ?                 \n" );pm0.addStringParameter(args_user[0][22]);
            result = pm0.doUpdate(tSQL.toString());
            if(result<1)
                throw new Exception("ICOMLUSR_menu UPDATE ERROR");*/
            
            ParamSql pm = new ParamSql(info.getSession("ID"), this, ctx);
            StringBuffer sql = new StringBuffer();
            String zip_code = ""; String phone_no1 = ""; String phone_no2 = "";
            String fax_no = ""; String address_loc = ""; String address_eng = "";
            String email = ""; String code_no = ""; String code_type = "";
            int icomaddr_cnt = 0;

            for(int i = 0; i < args_addr.length; i++)
            {
                zip_code = args_addr[i][0]; phone_no1 = args_addr[i][1]; phone_no2 = args_addr[i][2];
                fax_no = args_addr[i][3]; address_loc = args_addr[i][4]; address_eng = args_addr[i][5];
                email = args_addr[i][6]; code_no = args_addr[i][7]; code_type = args_addr[i][8];

                pm.removeAllValue();
                sql.delete(0, sql.length());
                sql.append(" SELECT COUNT(*) CNT FROM ICOMADDR         \n ");
                sql.append(pm.addFixString(" WHERE CODE_NO = ?      \n ")); pm.addStringParameter(code_no);
                sql.append(pm.addFixString("   AND CODE_TYPE = ?    \n ")); pm.addStringParameter(code_type);
                icomaddr_cnt = Integer.parseInt((new SepoaFormater(pm.doSelect(sql.toString())).getValue("cnt", 0)));

                if(icomaddr_cnt <= 0)
                {
                    pm.removeAllValue();
                    sql.delete(0, sql.length());
                    sql.append(" INSERT INTO ICOMADDR (    \n ");
                    sql.append("  ZIP_CODE              \n ");
                    sql.append(", PHONE_NO1             \n ");
                    sql.append(", PHONE_NO2             \n ");
                    sql.append(", FAX_NO                \n ");
                    sql.append(", ADDRESS_LOC           \n ");
                    sql.append(", ADDRESS_ENG           \n ");
                    sql.append(", EMAIL                 \n ");
                    sql.append(", CODE_NO               \n ");
                    sql.append(", CODE_TYPE             \n ");
                    sql.append(" ) VALUES (             \n ");
                    sql.append("  ?                     \n "); pm.addStringParameter(zip_code);
                    sql.append(" ,?                     \n "); pm.addStringParameter(SepoaString.encString ( phone_no1,"PHONE"));
                    sql.append(" ,?                     \n "); pm.addStringParameter(SepoaString.encString ( phone_no2,"PHONE"));
                    sql.append(" ,?                     \n "); pm.addStringParameter(SepoaString.encString ( fax_no,"PHONE"));
                    sql.append(" ,?                     \n "); pm.addStringParameter(address_loc);
                    sql.append(" ,?                     \n "); pm.addStringParameter(address_eng);
                    sql.append(" ,?                     \n "); pm.addStringParameter(SepoaString.encString ( email,"EMAIL"));
                    sql.append(" ,?                     \n "); pm.addStringParameter(code_no);
                    sql.append(" ,?                     \n "); pm.addStringParameter(code_type);
                    sql.append(" )                      \n ");
                    result = pm.doInsert(sql.toString());
                }
                else
                {
                    pm.removeAllValue();
                    sql.delete(0, sql.length());
                    sql.append(" UPDATE ICOMADDR SET              \n");
                    sql.append("     ZIP_CODE       = ?        \n"); pm.addStringParameter(zip_code);
                    sql.append("   , PHONE_NO1      = ?        \n"); pm.addStringParameter(SepoaString.encString (phone_no1  ,"PHONE"));
                    sql.append("   , PHONE_NO2      = ?        \n"); pm.addStringParameter(SepoaString.encString (phone_no2  ,"PHONE"));
                    sql.append("   , FAX_NO         = ?        \n"); pm.addStringParameter(SepoaString.encString (fax_no  ,"PHONE"));
                    sql.append("   , ADDRESS_LOC    = ?        \n"); pm.addStringParameter(address_loc);
                    sql.append("   , ADDRESS_ENG    = ?        \n"); pm.addStringParameter(address_eng);
                    sql.append("   , EMAIL          = ?        \n"); pm.addStringParameter(SepoaString.encString (email  ,"EMAIL"));                  
                    sql.append(" WHERE CODE_NO      = ?        \n"); pm.addStringParameter(code_no);
                    sql.append(" AND CODE_TYPE      = ?        \n"); pm.addStringParameter(code_type);
                    result = pm.doUpdate(sql.toString());
//                  sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                  String[] settype2 = {
//                          "S","S","S","S","S", "S","S","S","S"
//                          };
//
//                  result = sm.doUpdate(args_addr,settype2);
                }

                if(result<1)
                    throw new Exception("icomaddr UPDATE ERROR");
            }

            Commit();
        }catch(Exception e) {
            Rollback();
            throw new Exception("et_setUserInfoUpdate: " + e.getMessage());
        }
        return result;
    }//et_setUserInfoUpdate2() end
    
    
    
    

    private int et_setUserInfoUpdate3(String pwd, String user_id, String name_loc, String name_eng, String house_code, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
        int result = -1;
        if( pwd == null ) pwd = "";
        ConnectionContext ctx = getConnectionContext();

        try {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( "UPDATE ICOMLUSR									\n" );
            tSQL.append( "SET	 STATUS				    = '"+status+"'      \n" );
            tSQL.append( "		,CHANGE_USER_ID			= '"+user_id+"'     \n" );
            tSQL.append( "		,CHANGE_USER_NAME_LOC	= '"+name_loc+"'    \n" );
            tSQL.append( "		,CHANGE_USER_NAME_ENG	= '"+name_eng+"'    \n" );
            tSQL.append( "		,CHANGE_DATE			= '"+change_date+"' \n" );
            tSQL.append( "		,CHANGE_TIME			= '"+change_time+"' \n" );
            if( !pwd.equals("") )
            {
                tSQL.append( "		,PASSWORD				= '"+SepoaString.encString (pwd  ,"PWD")+"'        \n" );
            }
            tSQL.append( "		,USER_NAME_ENG			= ?                 \n" );
            tSQL.append( "		,PHONE_NO				= ?                 \n" );
            tSQL.append( "		,EMAIL					= ?                 \n" );
            tSQL.append( "		,MOBILE_NO				= ?                 \n" );
            tSQL.append( "		,FAX_NO					= ?                 \n" );
            tSQL.append( "		,CTRL_CODE  			= ?                 \n" );
            tSQL.append( "		,PW_RESET_FLAG          = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'               \n" );

            //tSQL.append( "		,SMILE_ID				= ?                 \n" );
            //tSQL.append( "		,SMILE_PW  			    = ?                 \n" );
            tSQL.append( "WHERE HOUSE_CODE = '"+house_code+"'               \n" );
            tSQL.append( "  AND USER_ID = ?                                 \n" );
            args[0][1] = SepoaString.encString ( args[0][1]  ,"PHONE");
            args[0][2] = SepoaString.encString ( args[0][2]  ,"EMAIL");
            args[0][3] = SepoaString.encString ( args[0][3]  ,"PHONE");
            args[0][4] = SepoaString.encString ( args[0][4]  ,"PHONE");
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            String[] settype = {"S","S","S","S","S","S","S"};

            result = sm.doUpdate(args,settype);
            Commit();
        }catch(Exception e) {
            Rollback();
            throw new Exception("et_setUserInfoUpdate: " + e.getMessage());
        }
        return result;
    }

/*수정한 항목들을 DB에 Update 해준다.*/
    public SepoaOut setUpdate(String[][] args) {
        int rtn = -1;
        String status = "R";  /*수정된 항목의 status는 "R"이다.*/
        String user_id = info.getSession("ID");
        String user_loc = info.getSession("NAME_LOC");
        String user_eng = info.getSession("NAME_ENG");
        String house_code = info.getSession("HOUSE_CODE");
        String change_date = SepoaDate.getShortDateString();
        String change_time = SepoaDate.getShortTimeString();

        try {
            rtn = et_setUpdate(user_id, name_loc, name_eng, house_code, args, status, change_date, change_time);
            setValue("Change_Row=" + rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());
        }catch(Exception e) {
            
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
        }
        return getSepoaOut();
    }

    private int et_setUpdate(String user_id, String name_loc, String name_eng, String house_code, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
        int result = -1;
        String[] settype = {"S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S",
                            "S","S","S","S","S","S"};

        ConnectionContext ctx = getConnectionContext();
        Logger.debug.println(user_id, this, "ctrl_code====>-----------" + args[0][29]);
        try {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" update ICOMLUSR set status = '"+status+"', ");
            tSQL.append(" change_date = '"+change_date+"', change_time = '"+change_time+"', change_user_id = '"+user_id+"', ");
            tSQL.append(" change_user_name_loc = '"+name_loc+"', change_user_name_eng = '"+name_eng+"', password =?, ");
            tSQL.append(" user_name_loc = ?, user_name_eng = ?, company_code = ?, dept = ?, resident_no =?, employee_no = ?, ");
            tSQL.append(" phone_no= ?, email = ?, mobile_no = ?, fax_no = ?, position = ?, language = ?, time_zone = ?, ");
            tSQL.append(" zip_code = ?, country = ?, city_code = ?, state = ?, address_loc = ?, address_eng = ?, pr_location = ? ,menu_profile_code = ?, ");
            tSQL.append(" manager_position = ? , user_type = ? , work_type = ?, ");
            tSQL.append(" user_first_name_eng = ? , user_last_name_eng = ?, ");
            tSQL.append(" city_name = ? , position_name = ? , ctrl_code = ? ");
            tSQL.append(" where house_code = '"+house_code+"' and user_id = ? ");



            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            result = sm.doUpdate(args,settype);
            Commit();
        }catch(Exception e) {
            Rollback();
            throw new Exception("et_setUpdate: " + e.getMessage());
        }
        return result;
    }

    public sepoa.fw.srv.SepoaOut getCheck(String[] args) {
        String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
        Logger.debug.println("LEPPLE", this, "service++++++++++++++++++++++++++");

        try {
            String rtn = null;
            rtn = et_getCheck(user_id, house_code, args);
            setValue(rtn);
            setStatus(1);
            //성공적으로 작업을 수행했습니다.
//          setMessage(msg.getMessage("0000"));
          
            //성공적으로 작업을 수행했습니다.
            setMessage(msg.get("AD_133.MSG_0115").toString());
        }catch(Exception e){
            
            setStatus(0);
            //조회중 에러가 발생 하였습니다.
//          setMessage(msg.getMessage("0001"));
         
            //조회중 에러가 발생 하였습니다.
            setMessage(msg.get("AD_133.MSG_0116").toString());
            Logger.err.println(user_id,this, e.getMessage());
        }
        return getSepoaOut();
    }

    public String et_getCheck(String user_id, String house_code, String[] args) throws Exception {
        String result = null;
        String count = "";
        String[][] str = new String[1][2];
        ConnectionContext ctx = getConnectionContext();

        try {
                StringBuffer tSQL = new StringBuffer();
                tSQL.append(" select count(*) ");
                tSQL.append(" from ICOMLUSR ");
                //tSQL.append(" where house_code = '"+house_code+"' ");
                tSQL.append(" <OPT=F,S> where user_id = ? </OPT> ");
                tSQL.append(" <OPT=F,S> and password = ? </OPT> ");

                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
                result = sm.doSelect(args);

                SepoaFormater wf = new SepoaFormater(result);
                str = wf.getValue();
                count = str[0][0];

            if(result == null) throw new Exception("SQL Manager is Null");
        }catch(Exception ex) {
            throw new Exception("et_getCheck()"+ ex.getMessage());
        }
        return count;
    }


    public SepoaOut getMenuobject(String[] args)
    {

        try
        {
            String user_id = info.getSession("ID");

            String sub_rtn = getMenuobject(args,user_id);
            SepoaFormater sub_wf = new SepoaFormater(sub_rtn);
            String menu_object = "";

            for(int j = 0 ; j < sub_wf.getRowCount() ; j++)
                    menu_object += 	sub_wf.getValue(j,0) + "<";

            setValue(menu_object);

            setStatus(1);
        }catch(Exception e)
        {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage("FindMUPD Failed");
            Logger.err.println(this,e.getMessage());

        }
        return getSepoaOut();


    }


    private String getMenuobject(String[] args,String user_id) throws Exception
    {

        String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        StringBuffer tSQL = new StringBuffer();

        tSQL.append( " SELECT MENU_OBJECT_CODE ");
        tSQL.append( " FROM   smupd ");
        //tSQL.append( " <OPT=F,S> WHERE  HOUSE_CODE = ? </OPT> " );
        tSQL.append( " <OPT=F,S> WHERE    MENU_PROFILE_CODE =  ? </OPT> " );


        SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
        rtn = sm.doSelect(args);
        return rtn;

    }

    public SepoaOut getPwdValidate(String[] args)
    {
        try
        {
            String user_id = info.getSession("ID");

            String sub_rtn = sel_getPwdValidate(args,user_id);

            setValue(sub_rtn);
            setStatus(1);
        }catch(Exception e)
        {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage("sel_getPwdValidate Failed");
            Logger.err.println(this,e.getMessage());

        }
        return getSepoaOut();
    }


    private String sel_getPwdValidate(String[] args,String user_id) throws Exception
    {

        String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        StringBuffer tSQL = new StringBuffer();

        //tSQL.append( " SELECT CASE COUNT(*) WHEN 0 THEN 'N' \n");
        //tSQL.append( " ELSE \n");
        tSQL.append( " SELECT DECODE(COUNT(*) , 0 , 'N'                                \n");
        tSQL.append( " ,DECODE( MAX(" + DB_NULL_FUNCTION + "(PW_RESET_FLAG,'N')) , 'N' , 'YN' , 'YY' ) ) \n");
        tSQL.append( " FROM   ICOMLUSR                                                                        \n");
        tSQL.append( " <OPT=S,S> WHERE  HOUSE_CODE = ?  </OPT>                                                \n");
        tSQL.append( " <OPT=S,S> AND    USER_ID = ?     </OPT>                                                 \n");
        /*
         * 비밀번호가 3개월이 지났는지는 사용. 2006.10.08
         */
        tSQL.append( " AND    TO_DATE((PW_RESET_DATE), 'YYYYMMDDHH24')+ 90 > SYSDATE                         \n");

        SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
        rtn = sm.doSelect(args);
        return rtn;

    }

    public SepoaOut getLastConnection(String[] args)
    {
        try
        {
            String sub_rtn = sel_getLastConnection(args);
            int insert_rtn = -1;

			Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> sub_rtn : " + sub_rtn);

            if(!sub_rtn.equals("")){
            	insert_rtn = et_insert_user_log(args);
            }

            setValue(sub_rtn);
            setStatus(1);

        } catch(Exception e) {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage("sel_getPwdValidate Failed");
            Logger.err.println(this,e.getMessage());

        }
        return getSepoaOut();
    }


    private String sel_getLastConnection(String[] args) throws Exception
    {

        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        String user_id = args[1];

        StringBuffer tSQL = new StringBuffer();

        tSQL.append( "SELECT                             					   						\n");
        tSQL.append( "	MAX(JOB_DATE" + DBUtil.getAndSeparator()+ "JOB_TIME" + DBUtil.getAndSeparator()+ "IP) AS INFO					\n");
        tSQL.append( "FROM                                  											\n");
        tSQL.append( "	USERLOG                             									\n");
        tSQL.append( " <OPT=S,S> WHERE  HOUSE_CODE = ?  </OPT>	 	\n");
        tSQL.append( " <OPT=S,S> AND    USER_ID = ?     </OPT>          		\n");

        SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
        rtn = sm.doSelect(args);
        return rtn;

    }

    private int et_insert_user_log(String[] args) throws Exception
    {

        String rtn = null;
        int insert_rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        SepoaFormater wf = null;
        String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
        String user_ip = info.getSession("USER_IP");
        String user_id2 = args[1];

        StringBuffer sql = new StringBuffer();

        sql.append( "SELECT                             					   						\n");
        sql.append( "	USER_NAME_LOC													\n");
        sql.append( "FROM                                  										\n");
        sql.append( "	ICOMLUSR		                     									\n");
        sql.append( " <OPT=S,S> WHERE  HOUSE_CODE = ?  </OPT>	 	\n");
        sql.append( " <OPT=S,S> AND    USER_ID = ?     </OPT>          		\n");

        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
        rtn = sm.doSelect(args);
        wf = new SepoaFormater(rtn);

        String user_name_loc = wf.getValue("USER_NAME_LOC", 0);

        sql = new StringBuffer();

        sql.append(" INSERT INTO USERLOG  								   	\n");
        sql.append(" (                      													\n");
        sql.append("      HOUSE_CODE,											    \n");
        sql.append("      NO,            													    \n");
        sql.append("      USER_ID,        											    \n");
        sql.append("      USER_NAME_LOC,    									    \n");
        sql.append("      PROGRAM,      											    \n");
        sql.append("      PROGRAM_DESC,    										\n");
        sql.append("      JOB_TYPE,           											\n");
        sql.append("      JOB_DATE,           											\n");
        sql.append("      JOB_TIME,           											\n");
        sql.append("      IP,                 													\n");
        sql.append("      PROCESS_ID,         										\n");
        sql.append("      METHOD_NAME         										\n");
        sql.append(" ) VALUES (               											\n");
        sql.append("      '"+house_code+"',											\n");
        sql.append("      USERLOG_NO.NEXTVAL,  								\n");
        sql.append("      '" + user_id2 + "',           									\n");
        sql.append("      '"+user_name_loc+"',										\n");
        sql.append("      'Login',            												\n"); // PROGRAM
        sql.append("      'Login',            												\n"); // PROGRAM_DESC
        sql.append("      'LI',               													\n"); // JOB_TYPE(LI:로그인, WK:작업, LO:로그아웃)
        sql.append("      TO_CHAR(SYSDATE,'YYYYMMDD'),    				\n"); // JOB_DATE
        sql.append("      TO_CHAR(SYSDATE,'HH24MISS'),    				\n"); // JOB_TIME
        sql.append("      '" + user_ip + "',                  							\n"); // IP
        sql.append("      'p0030',         													\n");
        sql.append("      'getLastConnection'              							\n");
        sql.append(" ) \n");

        sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
        insert_rtn = sm.doInsert();

        Commit();

        return insert_rtn;

    }

    public SepoaOut InsertLogoutInfo(String[] args)
    {
        try
        {
            String user_id = info.getSession("ID");
			int insert_rtn = -1;
            insert_rtn = et_InsertLogoutInfo(args);

            setValue("Insert Row=" + insert_rtn);
            setStatus(1);

        } catch(Exception e) {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage("InsertLogoutInfo Failed");
            Logger.err.println(this,e.getMessage());

        }
        return getSepoaOut();
    }

    private int et_InsertLogoutInfo(String[] args) throws Exception
    {

        int insert_rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id = info.getSession("ID");
        String house_code = args[0];
        String id = args[1];
        String user_name = args[2];
        String user_ip = args[3];

        StringBuffer sql = new StringBuffer();

        sql.append(" INSERT INTO USERLOG   							  	\n");
        sql.append(" (                        												\n");
        sql.append("      HOUSE_CODE,                 							\n");
        sql.append("      NO,                 											\n");
        sql.append("      USER_ID,            										\n");
        sql.append("      USER_NAME_LOC,           							\n");
        sql.append("      PROGRAM,            										\n");
        sql.append("      PROGRAM_DESC,       								\n");
        sql.append("      JOB_TYPE,           										\n");
        sql.append("      JOB_DATE,           										\n");
        sql.append("      JOB_TIME,           										\n");
        sql.append("      IP,                 												\n");
        sql.append("      PROCESS_ID,         									\n");
        sql.append("      METHOD_NAME         									\n");
        sql.append(" ) VALUES (               										\n");
        sql.append("      '"+house_code+"',										\n");
        sql.append("      USERLOG_NO.NEXTVAL,  							\n");
        sql.append("      '"+id+"',														\n");
        sql.append("      '"+user_name+"',										\n");
        sql.append("      'Logout',            											\n"); // PROGRAM
        sql.append("      'Logout',            											\n"); // PROGRAM_DESC
        sql.append("      'LO',               											\n"); // JOB_TYPE(LI:로그인, WK:작업, LO:로그아웃)
        sql.append("      TO_CHAR(SYSDATE,'YYYYMMDD'),    			\n"); // JOB_DATE
        sql.append("      TO_CHAR(SYSDATE,'HH24MISS'),    			\n"); // JOB_TIME
        sql.append("      '"+user_ip+"',												\n"); // IP
        sql.append("      'p0030',         												\n");
        sql.append("      'Logout'              										\n");
        sql.append(" ) \n");

        SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
        insert_rtn = sm.doInsert();

        Commit();

        return insert_rtn;

    }

    private int update(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doUpdate(param);
		
		return result;
	}
    
    private int setLogin_Pwd_History(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		String house_code      = info.getSession("HOUSE_CODE");
		param.put("house_code", house_code);
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doInsert(param);
		
		return result;
	}
    @SuppressWarnings("unchecked")
	public SepoaOut setPwdReset(Map<String, String> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			this.update(ctx, "et_setPwdReset", data);
			
			this.setLogin_Pwd_History(ctx, "setLogin_Pwd_History", data);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
    
    /**
    * 사용자 변경 페이지
    * 비밀번호 변경을 하면 가장먼저 ResetData 와 Flag 값등이 UPDATE 된다.
    * setPASS_CHECK_CNT   
    */

    public SepoaOut setPASS_CHECK_CNT(String i_user_id) {

        try
        {

            String change_date = SepoaDate.getShortDateString();
            String change_time = SepoaDate.getShortTimeString();

            int rtn = et_setPASS_CHECK_CNT(i_user_id, change_date);

            setStatus(1);
            //성공적으로 처리 되었습니다.
            setMessage(msg.get("AD_133.0117").toString());

        } catch(Exception e) {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(e.getMessage().trim());

            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }

    private int et_setPASS_CHECK_CNT(String i_user_id, String change_date )
                             throws Exception, DBOpenException {

       
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();

        try {

            StringBuffer tSQL = new StringBuffer();

            tSQL.append( "  UPDATE ICOMLUSR                                         \n");
            tSQL.append( "  SET                                                  \n");
            tSQL.append( "       PW_RESET_FLAG          = '" + sepoa.fw.util.CommonUtil.Flag.Yes.getValue() + "'                    \n");
            tSQL.append( "      ,PW_RESET_DATE          = '"+change_date+"'      \n");
            tSQL.append( "      ,PASS_CHECK_CNT         = TO_NUMBER('99')  \n");           
            tSQL.append( "  WHERE   USER_ID = 'NotChange"+i_user_id+"'                    \n");

            SepoaSQLManager sm = new SepoaSQLManager(id,this,ctx,tSQL.toString());

            rtn = sm.doUpdate();

            Commit();

        } catch(Exception e) {
                Rollback();
                throw new Exception("et_setPASS_CHECK_CNT:"+e.getMessage());
        } finally{}
        return rtn;
    }
    
    
    
    public SepoaOut setProfile(List< Map<String, String>>gridData)throws Exception, DBOpenException 
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id= info.getSession( "ID" );
        String add_date = SepoaDate.getShortDateString();
        String add_time = SepoaDate.getShortTimeString();
        Map<String , String> grid = null;

        try {
            StringBuffer tSQL = new StringBuffer();
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            
            for (int i = 0; i < gridData.size(); i++)
            {
                grid=(Map <String , String>) gridData.get(i);
                
               
            	sm.removeAllValue();
                tSQL.delete( 0, tSQL.length());
                tSQL.append( "  UPDATE ICOMLUSR SET                            \n");
                tSQL.append( "    SIGN_STATUS       = 'A'                   \n");
                tSQL.append( "  , MENU_PROFILE_CODE = ?                     \n");sm.addStringParameter( MapUtils.getString( grid, "MENU_PROFILE_CODE", "" ));
                tSQL.append( " 	, CHANGE_DATE       = ?                     \n");sm.addStringParameter( add_date );
                tSQL.append( " 	, CHANGE_TIME       = ?                     \n");sm.addStringParameter( add_time );
                tSQL.append( " 	, CHANGE_USER_ID    = ?                     \n");sm.addStringParameter( user_id  );
                tSQL.append( " 	, PW_RESET_FLAG     = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                   \n");
                tSQL.append( " 	, PASS_CHECK_CNT    = 0                     \n");
                tSQL.append( " 	, PW_RESET_DATE     = ?                     \n");sm.addStringParameter( add_date );            
                tSQL.append( "    WHERE USER_ID     = ?                     \n");sm.addStringParameter( MapUtils.getString( grid, "USER_ID", "" ));
                sm.doUpdate( tSQL.toString());
	        
	            rtn = sm.doInsert( tSQL.toString());
	            
	            //ICOMLUSR_MENU(백업용)
            	sm.removeAllValue();
                tSQL.delete( 0, tSQL.length());
                tSQL.append( "  UPDATE ICOMLUSR_MENU SET                            \n");
                tSQL.append( "   MENU_PROFILE_CODE = ?                     \n");sm.addStringParameter( MapUtils.getString( grid, "MENU_PROFILE_CODE", "" ));
                tSQL.append( "    WHERE USER_ID     = ?                     \n");sm.addStringParameter( MapUtils.getString( grid, "USER_ID", "" ));
                sm.doUpdate( tSQL.toString());
	        
	            rtn = sm.doInsert( tSQL.toString());
	        }
	        
            
            setMessage(msg.get("AD_133.MSG_0115").toString());
            setStatus(1);
            Commit();
            
        }catch(Exception e) {
            setStatus(0);
            Rollback();
            
            setMessage(e.getMessage().trim());
            
        } finally{
            
        }
        return getSepoaOut();
    } 
    public SepoaOut getDisplay3( String user_id ) {

        ConnectionContext       ctx     = getConnectionContext();
        StringBuffer            sbfs    = new StringBuffer();

        try {

            setStatus(1);
            setFlag(true);

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue();
            sbfs.delete(0, sbfs.length());
			sbfs.append(                  "select	\n");
			sbfs.append(                  "user_id	\n");
			sbfs.append(                  ",user_name_loc	\n");
			sbfs.append(                  ",user_name_eng	\n");
			sbfs.append(                  ",company_code	\n");
			sbfs.append(                  ",dept	\n");
			sbfs.append(                  ",cotel	\n");
			sbfs.append(                  ",email	\n");
			sbfs.append(                  ",position	\n");
			sbfs.append(                  ",position_name	\n");
			sbfs.append(                  ",menu_profile_code	\n");
			sbfs.append(                  "from ICOMLUSR usmt	\n");
			sbfs.append(                  "where 1=1	\n");
			sbfs.append(sm.addFixString("and upper(usmt.user_id) = upper(?) 	\n"));sm.addStringParameter(user_id);
            setValue( sm.doSelect( sbfs.toString() ) );

        } catch( Exception e ) {
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
            
        }

        return getSepoaOut();

    } // end of method
    
    public SepoaOut setUserInfo( Map allData ) {

        ConnectionContext       ctx     = getConnectionContext();
        StringBuffer            sbfs    = new StringBuffer();

        Map<String, String> header = null;
        
        try {
        	header                      = MapUtils.getMap( allData, "headerData", null);
        	
            setStatus(1);
            setFlag(true);

            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue();
            sbfs.delete(0, sbfs.length());
			sbfs.append(                  "update ICOMLUSR	\n");
			sbfs.append(                  "set user_name_loc = ?	\n");sm.addStringParameter(MapUtils.getString( header, "user_name_loc", "" ));
			sbfs.append(                  ",user_name_eng = ?	\n");sm.addStringParameter(MapUtils.getString( header, "user_name_eng", "" ));
			//sbfs.append(                  ",company_code = ?	\n");
			sbfs.append(                  ",dept = ?	\n");sm.addStringParameter(MapUtils.getString( header, "dept", "" ));
			sbfs.append(                  ",cotel = ?	\n");sm.addStringParameter(MapUtils.getString( header, "cotel", "" ));
			sbfs.append(                  ",email = ?	\n");sm.addStringParameter(MapUtils.getString( header, "email", "" ));
			sbfs.append(                  ",position = ?	\n");sm.addStringParameter(MapUtils.getString( header, "position", "" ));
			//sbfs.append(                  ",position_name	\n");
			//sbfs.append(                  ",menu_profile_code	\n");
			sbfs.append(                  "where 1=1	\n");
			sbfs.append(				  "and upper(user_id) = upper(?) 	\n");sm.addStringParameter(MapUtils.getString( header, "user_id", "" ));
			int rtn = sm.doUpdate( sbfs.toString() );

			Commit();
        } catch( Exception e ) {
        	try {
				Rollback();
			} catch (SepoaServiceException e1) {
				Logger.err.println( info.getSession( "ID" ), this, e1.getMessage() );
			}
            setStatus( 0 );
            setFlag( false );
            setMessage( e.getMessage() );
            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
            
        }

        return getSepoaOut();

    } // end of method
}

