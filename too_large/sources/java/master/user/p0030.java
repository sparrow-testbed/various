package master.user;

import java.util.HashMap;
import java.util.Map;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
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
import sepoa.fw.util.CryptoUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sms.SMS;
import wise.util.WiseEncrypt;

public class p0030 extends SepoaService {
	String house_code;
	String company_code;
	String id;
	String depart;
	String position;
	String name_loc;
	String name_eng;
	String language;
	String country;
	String city;
	Message msg;

	public p0030(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");

		this.house_code = info.getSession("HOUSE_CODE");
		this.company_code = info.getSession("COMPANY_CODE");
		this.id = info.getSession("ID");
		this.depart = info.getSession("DEPARTMENT");
		this.position = info.getSession("POSITION");
		this.name_loc = info.getSession("NAME_LOC");
		this.name_eng = info.getSession("NAME_ENG");
		this.language = info.getSession("LANGUAGE");
		this.country = info.getSession("COUNTRY");
		this.city = info.getSession("CITY");
		
		msg = new Message(info,"STDCOMM");
	}


	// 사용자정보 조회 (사용자정보수정-자동조회)
	public SepoaOut getDisplay2(String[] args) {
		String user_id = info.getSession("ID");
		try {
			String rtn = et_getDisplay2(args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(user_id, this, e.getMessage());
		}
		return getSepoaOut();
	}

	public String et_getDisplay2(String[] args) throws Exception {
		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String result = null;
		ConnectionContext ctx = getConnectionContext();

		String company_code = info.getSession("COMPANY_CODE");
		try {
			// StringBuffer tSQL = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("company_code", company_code);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			result = sm.doSelect(args);
			if (result == null)
				throw new Exception("SQLManager is null");
		} catch (Exception ex) {
			throw new Exception("et_getDisplay2()" + ex.getMessage());
		}
		return result;
	}

	
    public SepoaOut setPwdReset(String user_id, String user_sms_no, String password, String user_gubun, String sms_check_no)
    {
		try
		{
				Logger.debug.println(id,this,"sms_check_no:"+sms_check_no);
				//Header Insert
				//비밀번호 암호화한다.
				String encPassword = "";
				//SepoaEncrypt wiseEnc = new SepoaEncrypt();
				//encPassword = wiseEnc.getMD5(password);				
				encPassword = CryptoUtil.getSHA256(password);				
				
				String change_date = SepoaDate.getShortDateString();
				String change_time = SepoaDate.getShortTimeString();
				String count = et_CountId( user_id,  user_sms_no, user_gubun, sms_check_no);
	
				if (count.equals("0")) throw new Exception("사용자ID 혹은 SMS번호가 일치하지 않습니다.");
				
				et_setPwdReset(user_id, user_sms_no, password, encPassword, user_gubun);
				
				setValue(count);
				setStatus(1);
				setMessage("새로운 암호가 입력하신 SMS로 발송되었습니다.");
				
				Commit();
		
		}
		catch(Exception e)
		{
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage(e.getMessage().trim());
				
				Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
    }


    private int et_setPwdReset(String user_id, String user_sms_no, String password, String encPassword, String user_gubun) throws Exception, DBOpenException
	{

        // 총무부, ICT 여부
    	String house_code = info.getSession("HOUSE_CODE");

        int rtn = -1;
		String sqlRet = null;
		String exist_count = "";
		String pwd_count   = "";
		String pwd_time    = "";
		String use_count   = "";


        ConnectionContext ctx = getConnectionContext();

        try
        {
            StringBuffer tSQL = new StringBuffer();

            /*============================================================================*/
            /* SMS를 먼저 발송한다.                                                       */
            /*tSQL = new StringBuffer();
			tSQL.append("INSERT INTO SMS_TABLE( TR_SEQUENCE                                                    \n");	// Sequence Number
			tSQL.append("                     , TR_USER_ID                                                     \n");	// 사용자 ID
			tSQL.append("                     , TR_USER_NUM                                                    \n");	// 사용자 사원번호
			tSQL.append("                     , TR_COMP_CD                                                     \n");	// 계열사 CODE
			tSQL.append("                     , TR_PLACE                                                       \n");	// 부서(지점) CODE
			tSQL.append("                     , TR_BIZ_ID1                                                     \n");	// 업무(전송) 구분 코드 대
			tSQL.append("                     , TR_BIZ_ID2                                                     \n");	// 업무(전송) 구분 코드 중
			tSQL.append("                     , TR_CALLBACK                                                    \n");	// 회신 번호
			tSQL.append("                     , TR_DESTADDR                                                    \n");	// 착신 번호
			tSQL.append("                     , TR_SMSTYPE                                                     \n");	// SMS 구분 0: 일반 SMS, 1: CallBackUrl
			tSQL.append("                     , TR_SENDSTAT                                                    \n");	// 전송 상태 0:대기,1:전송중,2:완료
			tSQL.append("                     , TR_SENDDATE                                                    \n");	// 발송 요청일시
			tSQL.append("                     , TR_NET_ID                                                      \n");	// 착신 통신사
			tSQL.append("                     , TR_MSG                                                         \n");	// 전송 메시지
			tSQL.append("                     , TR_PRE_TIME                                                    \n");	// 작성시간
			tSQL.append("                     , TR_PRE_ID                                                      \n");	// 작성자
			tSQL.append("                     )                                                                \n");  
			tSQL.append(" VALUES                                                                               \n");
			tSQL.append("                     (                                                                \n");  
			tSQL.append("                       SMS_SEQUENCE.NEXTVAL                                           \n");	// Sequence Number
			tSQL.append("                     , 'FIND_PW'                                                      \n");	// 사용자 ID
			tSQL.append("                     , '" + user_id + "'                                              \n");	// 사용자 사원번호
			tSQL.append("                     , '001001'                                                       \n");	// 계열사 CODE
			tSQL.append("                     , '020644'                                                        \n");	// 부서(지점) CODE
			tSQL.append("                     , 'GEN'                                                          \n");	// 업무(전송) 구분 코드 대
			tSQL.append("                     , 'ELBID'                                                        \n");	// 업무(전송) 구분 코드 중
			tSQL.append("                     , '0231512212'                                                   \n");	// 회신 번호
			tSQL.append("                     , '" + user_sms_no + "'                                          \n");	// 착신 번호
			tSQL.append("                     , '0'                                                            \n");	// SMS 구분 0: 일반 SMS, 1: CallBackUrl
			tSQL.append("                     , '0'                                                            \n");	// 전송 상태 0:대기,1:전송중,2:완료
			tSQL.append("                     , SYSDATE                                                        \n");	// 발송 요청일시
			tSQL.append("                     , ''                                                             \n");	// 착신 통신사
			tSQL.append("                     , (select replace(Z.TEXT1,'password','" + password + "')         \n");	// 전송 메시지
			tSQL.append("                          from ICOMCODE Z                                             \n");
			tSQL.append("                         where HOUSE_CODE = '100'                                     \n");
			tSQL.append("                           and TYPE       = 'S005'                                    \n");
			tSQL.append("                           and CODE       = 'S19')                                    \n");
			tSQL.append("                     , SYSDATE                                                        \n");	// 작성시간
			tSQL.append("                     , 'ADMIN'                                                        \n");	// 작성자
			tSQL.append("                     )                                                                \n");

            SepoaSQLManager sm9 = new SepoaSQLManager(id, this, ctx, tSQL.toString());
            rtn = sm9.doInsert();
            
            if(rtn == -1)
            {
            	throw new Exception("SMS발송에 실패하였습니다.");
            }
            else
            {
            	Commit();
            }
*/

/*
			tSQL = new StringBuffer();
			// 저장된 비밀번호의 횟수 및 최소입력시간, 해당 비밀번호 사용여부를 조사한다.
			tSQL.append("select  case when pwd_count > 3 then 'T' else 'F' end as pwd_count                                         \n");
			tSQL.append("      , pwd_time                                                                                           \n");
			tSQL.append("      , case when use_count > 0 then 'T' else 'F' end as use_count                                         \n");
			tSQL.append("  from (                                                                                                   \n");
			tSQL.append("			select                                                                                          \n");
			tSQL.append("					 max(case when gubun = '1' then colValue1 end) as pwd_count                             \n");
			tSQL.append("					,max(case when gubun = '2' then colValue2 end) as pwd_time                              \n");
			tSQL.append("					,max(case when gubun = '3' then colValue1 end) as use_count                             \n");
			tSQL.append("			  from (                                                                                        \n");
			tSQL.append("						select 'T' as groupid, '1' as gubun, count(USER_ID) as colValue1, '' as colValue2   \n");
			tSQL.append("						  from ICOMPWDL                                                                     \n");
			tSQL.append("						 where HOUSE_CODE = '" + house_code  + "'                                           \n");
			tSQL.append("						   and USER_ID    = '" + user_id     + "'                                           \n");
			tSQL.append("					union all                                                                               \n");
			tSQL.append("						select 'T' as groupid, '2' as gubun, 0 as colValue1, min(ADD_DATE) as colValue2     \n");
			tSQL.append("						  from ICOMPWDL                                                                     \n");
			tSQL.append("						 where HOUSE_CODE = '" + house_code  + "'                                           \n");
			tSQL.append("						   and USER_ID    = '" + user_id     + "'                                           \n");
			tSQL.append("					union all                                                                               \n");
			tSQL.append("						select 'T' as groupid, '3' as gubun, count(USER_ID) as colValue1, '' as colValue2   \n");
			tSQL.append("						  from ICOMPWDL                                                                     \n");
			tSQL.append("						 where HOUSE_CODE = '" + house_code    + "'                                         \n");
			tSQL.append("						   and USER_ID    = '" + user_id       + "'                                         \n");
			tSQL.append("						   and PASSWORD   = '" + encPassword   + "'                                         \n");
			tSQL.append("				   ) A1                                                                                     \n");
			tSQL.append("			 group by groupid                                                                               \n");
			tSQL.append("       ) B1                                                                                                \n");

			SepoaSQLManager sm_t = new SepoaSQLManager(id, this, ctx, tSQL.toString());
			sqlRet = sm_t.doSelect();
			SepoaFormater wf = new SepoaFormater(sqlRet);
			pwd_count = wf.getValue("pwd_count", 0);
			pwd_time  = wf.getValue("pwd_time", 0);
			use_count = wf.getValue("use_count", 0);*/

			String TableName = "";
			
			if ("ICT".equals(user_gubun)){
				TableName = "ICOMLUSR_ICT";
			}else{
				TableName = "ICOMLUSR";
			}
            
            tSQL = new StringBuffer();
            tSQL.append( "  UPDATE " + TableName + "                      \n");
            tSQL.append( "     SET PASSWORD       = '" + encPassword + "' \n"); // 초기화 비밀번호.            
            tSQL.append( "        ,PASS_CHECK_CNT = '0'                   \n"); // 로그인 오류 횟수 초기화             
            tSQL.append( "        ,PW_RESET_FLAG  = 'Y'                   \n"); // 로그인 오류 횟수 초기화 
            tSQL.append( "        ,PW_RESET_DATE  = TO_CHAR(SYSDATE,'YYYYMMDD')           \n"); // 로그인 오류 횟수 초기화 
            tSQL.append( "   WHERE HOUSE_CODE = '" + house_code  + "'     \n");
            tSQL.append( "     AND USER_ID    = '" + user_id     + "'     \n");
            SepoaSQLManager sm = new SepoaSQLManager(id,this,ctx,tSQL.toString());
            rtn = sm.doUpdate();
            if(rtn == -1) throw new Exception("SQL Manager is Null");

/*
			// 4회 이상 변경된 경우라면 가장 먼저 발생된 이력을 삭제한다.
			if (pwd_count.equals("T") )
			{
				tSQL = new StringBuffer();
				tSQL.append(" delete ICOMPWDL");
				tSQL.append("  where HOUSE_CODE = '" + house_code  + "'   \n");
				tSQL.append("    and USER_ID    = '" + user_id     + "'   \n");
				tSQL.append("    and ADD_DATE   = '" + pwd_time    + "'   \n");

				SepoaSQLManager sm1 = new SepoaSQLManager(id,this,ctx,tSQL.toString());
				rtn = sm1.doDelete();
				if(rtn == -1) throw new Exception("SQL Manager is Null");
			
			*/
            /*============================================================================*/
            /* Password List 저장(개인 패스워드 4회이상 사용 방지)                        */
            /* 2008.08.19 code by ihStone                                                 */
            tSQL = new StringBuffer();
            
            tSQL.append(" INSERT INTO ICOMPWDL ( ");
            tSQL.append("          HOUSE_CODE,USER_ID,PASSWORD,ADD_DATE ) ");
            tSQL.append(" VALUES ( ");
            tSQL.append("           '" + house_code   + "'");
            tSQL.append("          ,'" + user_id      + "'");
            tSQL.append("          ,'" + encPassword  + "'");
            tSQL.append("          ,to_char(sysdate,'YYYY/MM/DD HH24:MI:SS') )");
            
            SepoaSQLManager sm2 = new SepoaSQLManager(id, this, ctx, tSQL.toString());
            rtn = sm2.doInsert();
            
            if(rtn == -1)
            {
            	throw new Exception("새로운 암호 설정에 실패하였습니다.");
            }
            else
            {
            	rtn = 1; //임시
            	
            	new SMS("NONDBJOB", info).pwReset(ctx, password, user_sms_no, user_gubun);
            	
            	Commit();
            }

        } catch(Exception e) {
                Rollback();
                throw new Exception("et_setPwdReset:"+e.getMessage());
        } finally{}
        return rtn;
    }
    
	private String et_CountId(String user_id, String user_sms_no, String user_gubun, String sms_check_no) throws Exception
    {
        String rtn = null;
        String count = "";
        ConnectionContext ctx = getConnectionContext();

        try
        {
            StringBuffer tSQL = new StringBuffer();
			tSQL.append(" select count(USER_ID)	as CNT                                                                                      \n");
			tSQL.append("   from                                                                                                            \n");
			tSQL.append("		(                                                                                                           \n");
			tSQL.append("			select	LUSR.USER_ID                                                                                    \n");
			tSQL.append("			  from                                                                                                  \n");
			tSQL.append("			  					ICOMLUSR	LUSR                                                                    \n");
			tSQL.append("			  		inner join	ICOMADDR	ADDR	on  LUSR.HOUSE_CODE                = ADDR.HOUSE_CODE            \n");
			tSQL.append("			  										and LUSR.USER_ID                   = ADDR.CODE_NO               \n");
			tSQL.append("			  										and replace(ADDR.PHONE_NO2,'-','') = '" + user_sms_no + "'      \n");
			tSQL.append("			  										and ADDR.CODE_TYPE                 = '3'                        \n");	// 사용자 주소정보
			tSQL.append("			 where 1=1                                                                                              \n");
			tSQL.append("			   and 'GAD'               = '" + user_gubun                    + "'                                    \n");
			tSQL.append("			   and LUSR.HOUSE_CODE     = '" + info.getSession("HOUSE_CODE") + "'                                    \n");
			tSQL.append("			   and LUSR.USER_ID        = '" + user_id                       + "'                                    \n");
			tSQL.append("			   and LUSR.SMS_CHECK_NO   = '" + sms_check_no                  + "'                                    \n");
			tSQL.append("			   and LUSR.SMS_CHECK_TIME > to_char(SYSDATE-(1/(24*60)*TO_NUMBER(3)),'YYYYMMDDHH24MISS')               \n");	// 발송시간 : 3분 유효
			tSQL.append("			   and LUSR.STATUS         not in ('D')                                                                 \n");
			tSQL.append("		union all                                                                                                   \n");
			tSQL.append("			select	LUSR.USER_ID                                                                                    \n");
			tSQL.append("			  from                                                                                                  \n");
			tSQL.append("			  					ICOMLUSR_ICT	LUSR                                                                \n");
			tSQL.append("			  		inner join	ICOMADDR_ICT	ADDR	on  LUSR.HOUSE_CODE                = ADDR.HOUSE_CODE        \n");
			tSQL.append("			  											and LUSR.USER_ID                   = ADDR.CODE_NO           \n");
			tSQL.append("			  											and replace(ADDR.PHONE_NO2,'-','') = '" + user_sms_no + "'  \n");
			tSQL.append("			  											and ADDR.CODE_TYPE                 = '3'                    \n");
			tSQL.append("			 where 1=1                                                                                              \n");
			tSQL.append("			   and 'ICT'               = '" + user_gubun                    + "'                                    \n");
			tSQL.append("			   and LUSR.HOUSE_CODE     = '" + info.getSession("HOUSE_CODE") + "'                                    \n"); 
			tSQL.append("			   and LUSR.USER_ID        = '" + user_id                       + "'                                    \n");
			tSQL.append("			   and LUSR.SMS_CHECK_NO   = '" + sms_check_no                  + "'                                    \n");
			tSQL.append("			   and LUSR.SMS_CHECK_TIME > to_char(SYSDATE-(1/(24*60)*TO_NUMBER(3)),'YYYYMMDDHH24MISS')               \n");
			tSQL.append("			   and LUSR.STATUS         not in ('D')                                                                 \n");
			tSQL.append("		) A1                                                                                                        \n");		
			
            SepoaSQLManager sm = new SepoaSQLManager("NEW_PW",this,ctx,tSQL.toString());                                                               
            rtn = sm.doSelect();
            
			SepoaFormater wf = new SepoaFormater(rtn);
			String[][] str = wf.getValue();
			count = str[0][0];
						
            if(rtn == null)                                    
            	throw new Exception("입력하신 정보와 일치하는 정보가 없습니다.");
        }
        catch(Exception e) {
            throw new Exception("Check_Duplicate:"+e.getMessage());
        }                                                       
        finally                                                 
        {                                                                                                                       
        }                                                       
        return count;                                             
    }                

	/*// 사용자정보 저장 버튼-1 (페스워드 update)  & 사용자현황-임시비밀번호(A73)
	public SepoaOut setPwdReset(String[] sel_user_id, String password) {

		try {
			Logger.debug.println(id, this, "######setPwdReset#######");
			// Header Insert
			String change_date = SepoaDate.getShortDateString();
			String change_time = SepoaDate.getShortTimeString();

			for(String user_id : sel_user_id){
				int rtn = et_setPwdReset(user_id, password, change_date, change_time, id);				
			}
			
			setStatus(1);
			setMessage("성공적으로 처리되었습니다.");

		} catch (Exception e) {
			
			setStatus(0);
			setMessage(e.getMessage().trim());

			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private int et_setPwdReset(String sel_user_id, String password, String change_date, String change_time, String id) throws Exception, DBOpenException {

		String house_code = info.getSession("HOUSE_CODE");

		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		try {

			// password 암호화.
			// SimpleSession SS_hv = new SimpleSession();
			// String hashVal = SS_hv.Hash(password);
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("change_date", change_date);
			wxp.addVar("password", password);
			wxp.addVar("house_code", house_code);
			wxp.addVar("sel_user_id", sel_user_id);

			// StringBuffer tSQL = new StringBuffer();
			// tSQL.append(
			// "  UPDATE ICOMLUSR                                         \n");
			// tSQL.append(
			// "  SET                                                     \n");
			// tSQL.append(
			// "       PW_RESET_FLAG          = 'Y'                       \n");
			// tSQL.append(
			// "      ,PW_RESET_DATE          = '"+change_date+"'         \n");
			// tSQL.append(
			// "      ,PASSWORD               = '"+password+"'   		  \n"); //
			// 초기화 비밀번호.
			// tSQL.append(
			// "      ,PASS_CHECK_CNT         = '0'                       \n");
			// tSQL.append( "  WHERE HOUSE_CODE = '"+house_code+"' ");
			// tSQL.append( "  AND   USER_ID = '"+sel_user_id+"'   ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			rtn = sm.doUpdate();

			Commit();

		} catch (Exception e) {
			Rollback();
			throw new Exception("et_setPwdReset:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
*/
	// 사용자정보 저장 버튼-2(일반정보)
	public SepoaOut setUserInfoUpdate2(String[][] args_user, String[][] args_addr) {

		int rtn = -1;

		try {

			rtn = et_setUserInfoUpdate4(args_user, args_addr);

			setValue("Change_Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */

		} catch (Exception e) {
			
			setStatus(0);
			setMessage(msg.getMessage("0001")); /* Message를 등록한다. */
		}
		return getSepoaOut();
	}

	private int et_setUserInfoUpdate4(String[][] args_user, String[][] args_addr) throws Exception, DBOpenException {

		int result = -1;

		ConnectionContext ctx = getConnectionContext();

		// String status = "R"; /*수정된 항목의 status는 "R"이다.*/
		// String user_id = info.getSession("ID");
		// // String user_loc = info.getSession("NAME_LOC");
		// // String user_eng = info.getSession("NAME_ENG");
		// String house_code = info.getSession("HOUSE_CODE");
		// String change_date = SepoaDate.getShortDateString();
		// String change_time = SepoaDate.getShortTimeString();

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_1");
			wxp.addVar("status", "R"); /* 수정된 항목의 status는 "R"이다. */
			wxp.addVar("user_id", info.getSession("ID"));
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("change_date", SepoaDate.getShortDateString());
			wxp.addVar("change_time", SepoaDate.getShortTimeString());

			// StringBuffer tSQL = new StringBuffer();
			// tSQL.append( "UPDATE ICOMLUSR										\n" );
			// tSQL.append( "SET	 STATUS				   		= '"+status+"'   	\n" );
			// tSQL.append( "		,CHANGE_USER_ID			= '"+user_id+"'     \n" );
			// tSQL.append( "		,CHANGE_DATE			= '"+change_date+"' \n" );
			// tSQL.append( "		,CHANGE_TIME			= '"+change_time+"' \n" );
			// tSQL.append( "		,USER_NAME_ENG  		= ?  		        \n" );
			// tSQL.append( "		,EMAIL  				= ?          	    \n" );
			// tSQL.append( "		,PW_RESET_FLAG  		= 'N'               \n" );
			// tSQL.append(
			// "WHERE HOUSE_CODE              = '"+house_code+"'  	\n" );
			// tSQL.append(
			// "  AND USER_ID = ?                                 	\n" );
			// SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
			// tSQL.toString());
			String[] settype = { "S", "S", "S" };

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			result = sm.doUpdate(args_user, settype);

			if (result < 1)
				throw new Exception("ICOMLUSR UPDATE ERROR");

			if (args_addr.length > 0) {

				if (args_addr[0].length == 4) {
					wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_2");
					wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
					// tSQL = new StringBuffer();
					// tSQL.append(" UPDATE ICOMADDR SET                 \n");
					// tSQL.append("   PHONE_NO1      = ?                \n");
					// tSQL.append("   , PHONE_NO2    = ?                \n");
					// tSQL.append("   , FAX_NO       = ?                \n");
					// tSQL.append(" WHERE HOUSE_CODE              = '"+house_code+"'  \n"
					// );
					// tSQL.append(" AND CODE_NO      = ?                  \n");
					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
					String[] settype2 = { "S", "S", "S", "S" };

					result = sm.doUpdate(args_addr, settype2);
				} else if (args_addr[0].length == 5) {
					wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_3");
					wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
					// tSQL = new StringBuffer();
					// tSQL.append(" UPDATE ICOMADDR SET                 \n");
					// tSQL.append("   PHONE_NO1      = ?                \n");
					// tSQL.append("   , PHONE_NO2    = ?                \n");
					// tSQL.append("   , FAX_NO       = ?                \n");
					// tSQL.append("   , EMAIL        = ?                \n");
					// tSQL.append(" WHERE HOUSE_CODE              = '"+house_code+"'  \n"
					// );
					// tSQL.append(" AND CODE_NO      = ?                  \n");
					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
					String[] settype2 = { "S", "S", "S", "S", "S" };

					result = sm.doUpdate(args_addr, settype2);
				}
			}

			if (result < 1)
				throw new Exception("ICOMADDR UPDATE ERROR");
			Commit();

		} catch (Exception e) {
			Rollback();
			throw new Exception("et_setUserInfoUpdate4: " + e.getMessage());
		}
		return result;
	}

	/**
	 * Insert 이부분은 바같족에서도 불리기에 Session정보가 없을 수도 있습니다. 그래서 임의로 user id를 테스트로
	 * 넣었습니다.
	 //사용자등록-등록(Z159)-insert  */
	public SepoaOut setInsert(String[][] args_user, String[][] args_addr, String makepw) {

		try {
			Logger.debug.println(info.getSession("ID"), this, "######setInsert#######");
			int rtn = et_setInsert(args_user, args_addr, makepw);

			if (rtn > 0) {
				Commit();
				setValue("Insert Row=" + rtn);
				setStatus(1);
				setMessage(msg.getMessage("0000"));
			}

		} catch (Exception e) {

			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
			// log err
		}
		return getSepoaOut();
	}
//사용자등록-등록(Z159)-insert
	private int et_setInsert(String[][] args_user, String[][] args_addr, String makepw) throws Exception, DBOpenException {
		String status = "C";
		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;

		try {

			// SimpleSession SS_hv = new SimpleSession();
			// String hashVal = SS_hv.Hash(makepw);

			Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> ICOMLUSR");

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_1");
			wxp.addVar("makepw", makepw);
			wxp.addVar("add_date", add_date);
			wxp.addVar("add_time", add_time);
			wxp.addVar("id", id);
			if ( args_user[0][16].equals("S")) {
				wxp.addVar("menu_profile_code", "MUP110300007");	
			} else {
			}
			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };
			rtn = sm.doInsert(args_user, setType);
			if (rtn < 1)
				throw new Exception("ICOMLUSR INSERT ERROR");
			
			Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> ICOMADDR");
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_2");
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			String[] setType2 = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };
			rtn = sm.doInsert(args_addr, setType2);
			if (rtn < 1)
				throw new Exception("ICOMADDR INSERT ERROR");

			Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>> setInsert 3");

		} catch (DBOpenException e) {
			Rollback();
			throw new Exception("et_setInsert:" + e.getMessage());
		}
		return rtn;
	}

    /*
     * 사용자승인 - 승인(버튼)
     * SIGN_STATUS = 'A'
     * MENU_PROFILE_CODE = ?
    */
	public SepoaOut setApproval(String[][] args){
		try {
			Logger.debug.println(id,this,"######setApproval#######");
			
			int rtn = et_setApproval(args);
			setValue("Update Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch(Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(e.getMessage().trim());
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}

	private int et_setApproval(String[][] args) throws Exception, DBOpenException {
            int rtn = -1;
            ConnectionContext ctx = getConnectionContext();
            SepoaSQLManager sm = null;
            try {
           	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
           	 wxp.addVar("add_date", SepoaDate.getShortDateString());
           	 wxp.addVar("add_time", SepoaDate.getShortTimeString());
           	 wxp.addVar("id", id);


//                StringBuffer tSQL = new StringBuffer();
//
//                tSQL.append( "  UPDATE ICOMLUSR SET                       \n");
//                tSQL.append( "    SIGN_STATUS = 'A'                       \n");
//                tSQL.append( "  	, MENU_PROFILE_CODE = ?                  \n");
//                tSQL.append( " 	, CHANGE_DATE = '"+add_date+"'           \n");
//                tSQL.append( " 	, CHANGE_TIME = '"+add_time+"'           \n");
//                tSQL.append( " 	, CHANGE_USER_ID = '"+id+"'              \n");
//                tSQL.append( " 	, PW_RESET_FLAG = 'N'             		 \n");
//                tSQL.append( " 	, PASS_CHECK_CNT = 0               		\n");
//                tSQL.append( " 	, PW_RESET_DATE = '"+add_date+"'       	\n");
//                tSQL.append( "  WHERE HOUSE_CODE = ?                     \n");
//                tSQL.append( "  AND USER_ID = ?                          \n");

                //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
                String[] setType = {"S","S","S"};
                Logger.debug.println(wxp.getQuery());

                sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
                rtn = sm.doUpdate(args, setType);

                /*기본직무세팅*/
                wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_CTRL");
              	wxp.addVar("add_date", SepoaDate.getShortDateString());
              	wxp.addVar("add_time", SepoaDate.getShortTimeString());
              	wxp.addVar("id", id);
              	wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
              	wxp.addVar("company_code", info.getSession("COMPANY_CODE"));
              	for (int j = 0; j < args.length; j++){
              		wxp.addVar("user_id", args[j][2]);
                    sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
                    rtn = sm.doUpdate();
              	}

                if(rtn<args.length)
                	throw new Exception("UPDATE ICOMLUSR ERROR - CHECK APPROVAL COUNT..");
                Commit();
            }catch(Exception e) {
                Rollback();
                throw new Exception("et_setApproval:"+e.getMessage());
            } finally{}
            return rtn;
        }



	/*
	 * 삭제 - 신규 사용자 승인에서의 삭제 ICOMLUSR, ICOMADDR(CODE_TYPE='3')
	  &사용자현황-삭제(A72) */
	public SepoaOut setDelete(String[][] args_user, String[][] args_addr) {

		try {
			Logger.debug.println(id, this, "######setDelete#######");

			int rtn = et_setDelete(args_user, args_addr, id);
			setValue("Delete Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(e.getMessage().trim());
			// setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
			// log err
		}
		return getSepoaOut();
	}
//	사용자현황-삭제(A72)
	private int et_setDelete(String[][] args_user, String[][] args_addr, String id) throws Exception, DBOpenException {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;
		String user_id = info.getSession("ID");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("user_id", user_id);

//			tSQL.append(" update ICOMLUSR set ");
//			tSQL.append("  status = 'D' ");
//			tSQL.append(" , change_user_id = '" + user_id + "' ");
//			tSQL.append(" , change_date = convert(varchar, getdate(), 112) ");
//			tSQL.append(" , change_time = substring(replace(convert(varchar, getdate(), 108), ':', ''), 1, 6) ");
//			tSQL.append(" WHERE HOUSE_CODE = ?      \n");
//			tSQL.append(" AND USER_ID = ? ");

			sm = new SepoaSQLManager(id, this, ctx, wxp.getQuery());

			String[] setType = { "S", "S" };
			rtn = sm.doDelete(args_user, setType);
			if (rtn < 1)
				throw new Exception(msg.getMessage("0004"));
			/*
			 * tSQL = new StringBuffer();
			 * tSQL.append(" DELETE FROM ICOMADDR      \n");
			 * tSQL.append(" WHERE HOUSE_CODE = ?      \n");
			 * tSQL.append(" AND CODE_NO      = ?      \n");
			 * tSQL.append(" AND CODE_TYPE    = '3'    \n");
			 *
			 * String[] setType2 = {"S","S"}; sm = new
			 * SepoaSQLManager(id,this,ctx,tSQL.toString()); rtn =
			 * sm.doDelete(args_addr, setType2); if(rtn < 1) throw new
			 * Exception(msg.getMessage("0004"));
			 */
			msg.setArg("RESULT", String.valueOf(rtn));
			setMessage(msg.getMessage("0013"));
			Commit();
		} catch (DBOpenException e) {
			Rollback();
			throw new Exception("et_setUpdate:" + e.getMessage());
		}
		return rtn;
	}

	/**
	 * 사용자 현황 조회에서의 삭제는 status ='D'로 하는 것이다.
	 */
	public SepoaOut setStatusD(String[][] args) {

		try {
			Logger.debug.println(id, this, "######setStatusD#######");
			// Header Insert
			String add_date = SepoaDate.getShortDateString();
			String add_time = SepoaDate.getShortTimeString();

			int rtn = et_setStatusD(args, add_date, add_time, id);
			setValue("Update Row=" + rtn);
			setStatus(1);
			// setMessage(msg.getMessage("0000"));
			setMessage("성공적으로 삭제되었습니다.");
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(e.getMessage().trim());
			// setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private int et_setStatusD(String[][] args, String add_date, String add_time, String id) throws Exception, DBOpenException {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			wxp.addVar("add_date", add_date);
			wxp.addVar("add_time", add_time);
			wxp.addVar("id", id);

//			tSQL.append(" UPDATE ICOMLUSR ");
//			tSQL.append(" SET STATUS = 'D', ");
//			tSQL.append(" 	CHANGE_DATE = '" + add_date + "',  ");
//			tSQL.append(" 	CHANGE_TIME = '" + add_time + "',  ");
//			tSQL.append(" 	CHANGE_USER_ID = '" + id + "',  ");
//			tSQL.append(" 	CHANGE_USER_NAME_LOC = '" + name_loc + "',  ");
//			tSQL.append(" 	CHANGE_USER_NAME_ENG = '" + name_eng + "',  ");
//			tSQL.append(" 	CHANGE_USER_DEPT = '" + depart + "'  ");
//			tSQL.append(" WHERE HOUSE_CODE = ? ");
//			tSQL.append(" AND USER_ID = ? ");

			SepoaSQLManager sm = new SepoaSQLManager(id, this, ctx, wxp.getQuery());

			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] setType = { "S", "S" };

			rtn = sm.doUpdate(args, setType);

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			wxp.addVar("id", id);

//			tSQL1.append(" DELETE FROM ICOMRULR ");
//			tSQL1.append(" WHERE HOUSE_CODE = ? ");
//			tSQL1.append(" AND USER_ID = ? ");

			SepoaSQLManager sm1 = new SepoaSQLManager(id, this, ctx, wxp.getQuery());
			sm1.doDelete(args, setType);

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");

//			tSQL2.append(" DELETE FROM ICOMRULR ");
//			tSQL2.append(" WHERE HOUSE_CODE = ? ");
//			tSQL2.append(" AND NEXT_SIGN_USER_ID = ? ");

			SepoaSQLManager sm2 = new SepoaSQLManager(id, this, ctx, wxp.getQuery());
			sm2.doDelete(args, setType);

			Commit();
		} catch (Exception e) {
			Rollback();
			throw new Exception("et_setSave:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	// /////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 *사용자등록-중복확인 버튼(Z159) 중복체크 이부분은 Session이 없는 바깥쪽도 건드린다.
	 */
	public SepoaOut getDuplicate(String[] args) {
		try {

			String rtn = null;
			// Isvalue(); ....
			rtn = Check_Duplicate(args, id);
			Logger.debug.println("JHYOON", this, "duplicate-result= ===>" + rtn);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println("JHYOON", this, "Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}

	private String Check_Duplicate(String[] args, String user_id) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//			tSQL.append(" SELECT                                											\n");
//			tSQL.append(" 	COUNT(*) AS CNT                       									\n");
//			tSQL.append(" FROM 																				\n");
//			tSQL.append(" 	ICOMLUSR LUSR, ICOMADDR ADDR               				\n");
//			tSQL.append(" WHERE   																		\n");
//			tSQL.append(" 	LUSR.HOUSE_CODE = ADDR.HOUSE_CODE  				\n");
//			tSQL.append(" 	AND LUSR.USER_ID = ADDR.CODE_NO  						\n");
//			tSQL.append(" <OPT=F,S> AND LUSR.HOUSE_CODE = ? </OPT> 			\n");
//			tSQL.append(" <OPT=F,S> AND LUSR.USER_ID = ? </OPT>      			\n");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			rtn = sm.doSelect(args);
			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("Check_Duplicate:" + e.getMessage());
		} finally {

		}
		return rtn;
	}

	// /////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * ID 찾기 Buyer 이부분은 Session이 없는 바깥쪽도 건드린다.
	 */
	public SepoaOut FindID(String[] args) {
		try {
			String rtn = null;
			rtn = et_FindID(args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println("JHYOON", this, "Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_FindID(String[] args) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		Map<String, String> param = new HashMap<String, String>();
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			param.put("house_code"     , args[0]);
			param.put("user_sabun"     , args[1]);
			param.put("user_name_loc"  , args[2]);
			
			rtn = sm.doSelect(param);
			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("Check_Duplicate:" + e.getMessage());
		} finally {

		}
		return rtn;
	}

	// /////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * ID 찾기 Supplier 이부분은 Session이 없는 바깥쪽도 건드린다.
	 */
	public SepoaOut FindID1(String[] args) throws Exception{
		try {
			String rtn = null;
			rtn = et_FindID1(args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println("FindID1", this, "Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}

	/* IC찾기 : 공통 */
	private String et_FindID1(String[] args) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		Map<String, String> param = new HashMap<String, String>();
		
		String get_vendor_code = "";
		String get_user_id     = "";
        String get_mobile_NO   = "";
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			
			param.put("house_code"     , args[0].toString());
			param.put("user_sabun"     , args[1].toString());
			param.put("user_name_loc"  , args[2].toString());
			param.put("irs_no"         , args[3].toString());
			param.put("vendor_sms_no"  , args[4].toString());
			param.put("user_gubun"     , args[5].toString());
			param.put("sms_check_no"   , args[7].toString());	// SMS 인증번호
			
			//Logger.err.println("arg0="+args[0].toString());
			//Logger.err.println("arg1="+args[1].toString());
			//Logger.err.println("arg2="+args[2].toString());
			//Logger.err.println("arg3="+args[3].toString());
			//Logger.err.println("arg4="+args[4].toString());
			//Logger.err.println("arg5="+args[5].toString());
			//Logger.err.println("arg6="+args[6].toString());
			//Logger.err.println("arg7="+args[7].toString());
			//Logger.err.println("arg8="+args[8].toString());

			rtn = sm.doSelect(param);

			SepoaFormater wf = new SepoaFormater(rtn);

			if (wf.getRowCount() > 0){
				get_vendor_code = wf.getValue("VENDOR_CODE", 0);
				get_user_id     = wf.getValue("USER_ID", 0);
				get_mobile_NO   = wf.getValue("MOBILE_NO", 0);
			}
			else
			{
				throw new Exception("사업자번호 혹은 SMS 정보가 일치하지 않습니다.");
			}

			// 승인되지 않은 상태
			//if (sign_status.equals("R")) throw new Exception("업체의 정보가 승인이전 상태입니다.");
			//throw new Exception("업체의 정보가 승인이전 상태입니다.");
			
			// 맞는 조건 없음
			//if(cntVendor.equals("0")) throw new Exception("사업자번호 혹은 SMS 정보가 일치하지 않습니다.");
			//if(rtn.equals("VENDOR_CODE@@@SIGN_STATUS@@@&&&")) throw new Exception("Null");
			
			//new SMS("NONDBJOB", info).idFind(ctx, wf.getValue("USER_ID", 0), args[4].toString());
			//par1 : db에 저장된 Key code
			//par2 : 전송될 String 
			//par3 : DB에 저장된 대치문자
			//par4 : 수신 Mobile No 
            new SMS("NONDBJOB", info).sms_send_common2(ctx, "ICT_SMS_08", get_user_id, "${id}", get_mobile_NO, args[5].toString());

			
			Commit();

		} catch (Exception e) {
			
			throw new Exception(e.getMessage());
		} 
		return rtn;
	}


	// ICT 공통 수정 : 인증번호 요청
	public SepoaOut ReqCheckNo(String[] args) throws Exception{
		try {
			String rtn = null;
			rtn = et_ReqCheckNo(args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println("FindID1", this, "Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}	
	
	// ICT 공통 수정 : 인증번호 요청
	private String et_ReqCheckNo(String[] args) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		Map<String, String> param = new HashMap<String, String>();
		
		String get_vendor_code = "";
		String get_user_id     = "";
        String get_mobile_NO   = "";
        String get_Random_NO   = "";
        int    rtn1 = -1;
        StringBuffer tSQL = new StringBuffer();
		
		try {
				
			String house_code = args[0].toString();
			String user_gubun = args[5].toString();
			String Query_Name = args[6].toString();	// ReqCheckNo_ID, ReqCheckNo_PW
			
			// 해당사업자번호, SMS번호를 이용하여 정상사용자여부 체크
			SepoaXmlParser wxp = new SepoaXmlParser(this, Query_Name);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			param.put("house_code"     , house_code);
			param.put("user_sabun"     , args[1].toString());
			param.put("user_name_loc"  , args[2].toString());
			param.put("irs_no"         , args[3].toString());
			param.put("vendor_sms_no"  , args[4].toString());
			param.put("user_gubun"     , user_gubun);
			param.put("user_id"        , args[9].toString());
			param.put("user_sms_no"    , args[10].toString());
			rtn = sm.doSelect(param);

			SepoaFormater wf = new SepoaFormater(rtn);
			// SMS번호와 사업자번호를 이용한 정보 조회
			if (wf.getRowCount() > 0){
				get_vendor_code = wf.getValue("VENDOR_CODE", 0);
				get_user_id     = wf.getValue("USER_ID", 0);
				get_mobile_NO   = wf.getValue("MOBILE_NO", 0);
				get_Random_NO   = wf.getValue("RND_CHK_NO", 0);		// 임시발생 인증번호
			}else{
				throw new Exception("사업자번호 혹은 SMS 정보가 일치하지 않습니다.");
			}

			// 인증번호 저장
			String table_name = "";
			if ("ICT".equals(user_gubun)){
				table_name = "ICOMLUSR_ICT";
			}else{
				table_name = "ICOMLUSR";
			}
			tSQL = new StringBuffer();
            tSQL.append( "update " + table_name + "                                     \n");
            tSQL.append( "   set SMS_CHECK_NO   = '" + get_Random_NO + "'               \n");
            tSQL.append( "     , SMS_CHECK_TIME = to_char(sysdate,'YYYYMMDDhh24miss')   \n");
            tSQL.append( " where 1=1                                                    \n");
            tSQL.append( "   and HOUSE_CODE     = '" + house_code  + "'                 \n");
            tSQL.append( "   and USER_ID        = '" + get_user_id + "'                 \n");

            sm = new SepoaSQLManager(id,this,ctx,tSQL.toString());
            rtn1 = sm.doUpdate();
            if(rtn1 == -1) throw new Exception("SMS인증번호 발송중 오류가 발생하였습니다.");

            new SMS("NONDBJOB", info).sms_send_common2(ctx, "ICT_SMS_10", get_Random_NO, "${CheckNo}", get_mobile_NO, user_gubun);

			Commit();

		} catch (Exception e) {
			
			throw new Exception(e.getMessage());
		} 
		return rtn;
	}
		
	
	
	/**  * 신규사용자승인-조회(A73)  Mainternace */
    public SepoaOut getMainternace(String sign_status, String[] args){

        try
        {
            Logger.debug.println(id,this,"######getMaintenance#######");

            String rtn = "";

            rtn = et_getMainternace(sign_status, args);

            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e)
        {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }

//신규사용자승인-조회(A73)
    private String et_getMainternace(String sign_status, String[] args) throws Exception
    {
        String rtn = "";
        ConnectionContext ctx = getConnectionContext();
//      String user_id = info.getSession("ID");

        // 사용자 ID, 사용자명, 부서코드, 직급, 전화번호, 메뉴명
        try
        {
        	Config conf = new Configuration();
       	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

            wxp.addVar("sign_status", sign_status);
    		wxp.addVar("menu_type", info.getSession("MENU_TYPE"));
    		wxp.addVar("menu_type_admin", conf.get("Sepoa.all_admin.profile_code."+info.getSession("HOUSE_CODE")));

            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());

            rtn = sm.doSelect(args);

            if(rtn == null) throw new Exception("SQL Manager is Null");
            }catch(Exception e) {
                throw new Exception("et_getMainternace:"+e.getMessage());
            } finally{
            //Release();
        }
        return rtn;
    }



    //사용자승인-상세정보		수정화면, 상세조회화면에서 기존에 데이타를 보여주는 쿼리문.
    /**
	 * 사용자 수정화면
	 * @method getDisplay
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-12-04
	 * @modify 2014-12-04
	 */
    public SepoaOut getDisplay(String[] args)
    {
    	String user_id = info.getSession("ID");
        try {
            String rtn = et_getDisplay(args);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(user_id,this, e.getMessage());
        }
        return getSepoaOut();
    }

    public String et_getDisplay(String[] args) throws Exception
    {
    	String result = null;
    	ConnectionContext ctx = getConnectionContext();

        try
        {
       	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       	 wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

       	  SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());

            result = sm.doSelect(args);
            if(result == null)
            	throw new Exception("SQLManager is null");
        }catch(Exception ex) {
            throw new Exception("et_getDisplay()"+ ex.getMessage());
        }
        return result;
    }
    
    /**
     * 사용자 프로파일 : admin 판단하기 위해 : kr/master/register/vendor_reg_lis2.jsp에서 사용
     * @param args
     * @return
     */
    public SepoaOut getUserMenuProfile(String[] args)
    {
    	String user_id = info.getSession("ID");
        try {
            String rtn = et_getUserMenuProfile(args);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(user_id,this, e.getMessage());
        }
        return getSepoaOut();
    }

    public String et_getUserMenuProfile(String[] args) throws Exception
    {
    	String result = null;
    	ConnectionContext ctx = getConnectionContext();

        try {
       	 	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       	 	//wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
       	 	//wxp.addVar("user_id", info.getSession("ID"));
       	 	SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
            
       	 	result = sm.doSelect(args);
            if(result == null)
            	throw new Exception("SQLManager is null");
        }catch(Exception ex) {
            throw new Exception("et_getUserMenuProfile()"+ ex.getMessage());
        }
        return result;
    }

	/* USER INFO 에서 수정한 항목들을 DB에 Update 해준다. */
//사용자현황-수정 > 사용자수정(팝업)-저장(S378)
	public SepoaOut setUserInfoUpdate(String program, String pwd, String[][] args_user, String[][] args_addr) {
		int rtn = -1;

		try {
			rtn = et_setUserInfoUpdate2(pwd, args_user, args_addr);
			setValue("Change_Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
		} catch (Exception e) {
			
			setStatus(0);
			setMessage(msg.getMessage("0001")); /* Message를 등록한다. */
		}
		return getSepoaOut();
	}
	
	//사용자현황-수정 > 사용자수정(팝업)-저장(S378)
	private int et_setUserInfoUpdate2(String pwd, String[][] args_user, String[][] args_addr) throws Exception, DBOpenException {
		int result = -1;

		ConnectionContext ctx = getConnectionContext();
//		String status = "R"; /* 수정된 항목의 status는 "R"이다. */
//		String user_id = info.getSession("ID");
//		String user_loc = info.getSession("NAME_LOC");
//		String user_eng = info.getSession("NAME_ENG");
//		String house_code = info.getSession("HOUSE_CODE");
		String change_date = SepoaDate.getShortDateString();
		String change_time = SepoaDate.getShortTimeString();

		try {
	       	 SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_01");
	       	 wxp.addVar("status"      , "R");
	       	 wxp.addVar("user_id"     , info.getSession("ID"));
	       	 wxp.addVar("user_loc"    , info.getSession("NAME_LOC"));
	       	 wxp.addVar("user_eng"    , info.getSession("NAME_ENG"));
	       	 wxp.addVar("house_code"  , info.getSession("HOUSE_CODE"));
	       	 wxp.addVar("change_date" , change_date);
	       	 wxp.addVar("change_time" , change_time);
	       	 wxp.addVar("pwd"         , pwd);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] settype = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };

			result = sm.doUpdate(args_user, settype);


			SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_02");
			if (result < 1)
				throw new Exception("ICOMLUSR UPDATE ERROR");

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp2.getQuery());
			String[] settype2 = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };

			result = sm.doUpdate(args_addr, settype2);
			Commit();
		} catch (Exception e) {
			Rollback();
			throw new Exception("et_setUserInfoUpdate: " + e.getMessage());
		}
		return result;
	}



//	private int et_setUserInfoUpdate3(String pwd, String user_id, String name_loc, String name_eng, String house_code, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//		int result = -1;
//		if (pwd == null)
//			pwd = "";
//		ConnectionContext ctx = getConnectionContext();
//
//		try {
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append("UPDATE ICOMLUSR									\n");
//			tSQL.append("SET	 STATUS				    = '" + status + "'      \n");
//			tSQL.append("		,CHANGE_USER_ID			= '" + user_id + "'     \n");
//			tSQL.append("		,CHANGE_USER_NAME_LOC	= '" + name_loc + "'    \n");
//			tSQL.append("		,CHANGE_USER_NAME_ENG	= '" + name_eng + "'    \n");
//			tSQL.append("		,CHANGE_DATE			= '" + change_date + "' \n");
//			tSQL.append("		,CHANGE_TIME			= '" + change_time + "' \n");
//			if (!pwd.equals("")) {
//				tSQL.append("		,PASSWORD				= '" + pwd + "'        \n");
//			}
//			tSQL.append("		,USER_NAME_ENG			= ?                 \n");
//			tSQL.append("		,PHONE_NO				= ?                 \n");
//			tSQL.append("		,EMAIL					= ?                 \n");
//			tSQL.append("		,MOBILE_NO				= ?                 \n");
//			tSQL.append("		,FAX_NO					= ?                 \n");
//			tSQL.append("		,CTRL_CODE  			= ?                 \n");
//			tSQL.append("		,PW_RESET_FLAG          = 'N'               \n");
//
//			// tSQL.append( "		,SMILE_ID				= ?                 \n" );
//			// tSQL.append( "		,SMILE_PW  			    = ?                 \n" );
//			tSQL.append("WHERE HOUSE_CODE = '" + house_code + "'               \n");
//			tSQL.append("  AND USER_ID = ?                                 \n");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//			String[] settype = { "S", "S", "S", "S", "S", "S", "S" };
//
//			result = sm.doUpdate(args, settype);
//			Commit();
//		} catch (Exception e) {
//			Rollback();
//			throw new Exception("et_setUserInfoUpdate: " + e.getMessage());
//		}
//		return result;
//	}
//
//	/* 수정한 항목들을 DB에 Update 해준다. */
//	public SepoaOut setUpdate(String[][] args) {
//		int rtn = -1;
//		String status = "R"; /* 수정된 항목의 status는 "R"이다. */
//		String user_id = info.getSession("ID");
//		String user_loc = info.getSession("NAME_LOC");
//		String user_eng = info.getSession("NAME_ENG");
//		String house_code = info.getSession("HOUSE_CODE");
//		String change_date = SepoaDate.getShortDateString();
//		String change_time = SepoaDate.getShortTimeString();
//
//		try {
//			rtn = et_setUpdate(user_id, name_loc, name_eng, house_code, args, status, change_date, change_time);
//			setValue("Change_Row=" + rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000")); /* Message를 등록한다. */
//		} catch (Exception e) {
//			System.out.println("Exception= " + e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0001")); /* Message를 등록한다. */
//		}
//		return getSepoaOut();
//	}
//
//	private int et_setUpdate(String user_id, String name_loc, String name_eng, String house_code, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//		int result = -1;
//		String[] settype = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };
//
//		ConnectionContext ctx = getConnectionContext();
//		Logger.debug.println(user_id, this, "ctrl_code====>-----------" + args[0][29]);
//		try {
//			StringBuffer tSQL = new StringBuffer();
//			tSQL.append(" update ICOMLUSR set status = '" + status + "', ");
//			tSQL.append(" change_date = '" + change_date + "', change_time = '" + change_time + "', change_user_id = '" + user_id + "', ");
//			tSQL.append(" change_user_name_loc = '" + name_loc + "', change_user_name_eng = '" + name_eng + "', password =?, ");
//			tSQL.append(" user_name_loc = ?, user_name_eng = ?, company_code = ?, dept = ?, resident_no =?, employee_no = ?, ");
//			tSQL.append(" phone_no= ?, email = ?, mobile_no = ?, fax_no = ?, position = ?, language = ?, time_zone = ?, ");
//			tSQL.append(" zip_code = ?, country = ?, city_code = ?, state = ?, address_loc = ?, address_eng = ?, pr_location = ? ,menu_profile_code = ?, ");
//			tSQL.append(" manager_position = ? , user_type = ? , work_type = ?, ");
//			tSQL.append(" user_first_name_eng = ? , user_last_name_eng = ?, ");
//			tSQL.append(" city_name = ? , position_name = ? , ctrl_code = ? ");
//			tSQL.append(" where house_code = '" + house_code + "' and user_id = ? ");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//			result = sm.doUpdate(args, settype);
//			Commit();
//		} catch (Exception e) {
//			Rollback();
//			throw new Exception("et_setUpdate: " + e.getMessage());
//		}
//		return result;
//	}
//
//	// 수정화면(POP UP)에서 ID와 PASSWORD를 체크하는 쿼리문.
//	public Sepoa.srv.SepoaOut getCheck(String[] args) {
//		String user_id = info.getSession("ID");
//		String house_code = info.getSession("HOUSE_CODE");
//		Logger.debug.println("LEPPLE", this, "service++++++++++++++++++++++++++");
//
//		try {
//			String rtn = null;
//			rtn = et_getCheck(user_id, house_code, args);
//			setValue(rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//		} catch (Exception e) {
//			System.out.println("Eception e = " + e.getMessage());
//			setStatus(0);
//			setMessage(msg.getMessage("0001"));
//			Logger.err.println(user_id, this, e.getMessage());
//		}
//		return getSepoaOut();
//	}
//
//	public String et_getCheck(String user_id, String house_code, String[] args) throws Exception {
//		String result = null;
//		String count = "";
//		String[][] str = new String[1][2];
//		ConnectionContext ctx = getConnectionContext();
//
//		try {
//			StringBuffer tSQL = new StringBuffer();
//			tSQL.append(" select count(*) ");
//			tSQL.append(" from icomlusr ");
//			tSQL.append(" where house_code = '" + house_code + "' ");
//			tSQL.append(" <OPT=F,S> and user_id = ? </OPT> ");
//			tSQL.append(" <OPT=F,S> and password = ? </OPT> ");
//
//			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//			result = sm.doSelect(args);
//
//			SepoaFormater wf = new SepoaFormater(result);
//			str = wf.getValue();
//			count = str[0][0];
//
//			if (result == null)
//				throw new Exception("SQL Manager is Null");
//		} catch (Exception ex) {
//			throw new Exception("et_getCheck()" + ex.getMessage());
//		}
//		return count;
//	}

//사용자현황-그리드에 프로파일명 클릭 팝업(A73--->S228)
	public SepoaOut getMenuobject(String[] args) {

		try {
			String user_id = info.getSession("ID");

			String sub_rtn = getMenuobject(args, user_id);
			SepoaFormater sub_wf = new SepoaFormater(sub_rtn);
			String menu_object = "";

			for (int j = 0; j < sub_wf.getRowCount(); j++)
				menu_object += sub_wf.getValue(j, 0) + "<";

			setValue(menu_object);

			setStatus(1);
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage("FindMUPD Failed");
			Logger.err.println(this, e.getMessage());

		}
		return getSepoaOut();

	}
//사용자현황-그리드에 프로파일명 클릭 팝업(A73--->S228)
	private String getMenuobject(String[] args, String user_id) throws Exception {

		String rtn = null;
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//		StringBuffer tSQL = new StringBuffer();
//
//		tSQL.append(" SELECT MENU_OBJECT_CODE ");
//		tSQL.append(" FROM   ICOMMUPD ");
//		tSQL.append(" <OPT=F,S> WHERE  HOUSE_CODE = ? </OPT> ");
//		tSQL.append(" <OPT=F,S> AND    MENU_PROFILE_CODE =  ? </OPT> ");

		SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
		rtn = sm.doSelect(args);
		return rtn;

	}


//
//	public SepoaOut getPwdValidate(String[] args) {
//		try {
//			Logger.debug.println("SSSSSSSSSSSSSSSSSSSSSSSSS");
//			String user_id = info.getSession("ID");
//
//			String sub_rtn = sel_getPwdValidate(args, user_id);
//
//			String sub_rtn1 = sel_getPwdCheck(args, user_id);
//
//			setValue(sub_rtn);
//			setValue(sub_rtn1);
//			setStatus(1);
//		} catch (Exception e) {
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage("sel_getPwdValidate Failed");
//			Logger.err.println(this, e.getMessage());
//
//		}
//		return getSepoaOut();
//	}
//
//	private String sel_getPwdValidate(String[] args, String user_id) throws Exception {
//
//		String rtn = null;
//		ConnectionContext ctx = getConnectionContext();
//
//		StringBuffer tSQL = new StringBuffer();
//		/*
//		 * //tSQL.append( " SELECT CASE COUNT(*) WHEN 0 THEN 'N' \n");
//		 * //tSQL.append( " ELSE \n"); tSQL.append(
//		 * " SELECT DECODE(COUNT(*) , 0 , 'N'                                \n"
//		 * ); tSQL.append(
//		 * " ,DECODE( MAX(ISNULL(PW_RESET_FLAG,'N')) , 'N' , 'YN' , 'YY' ) ) \n"
//		 * ); tSQL.append(
//		 * " FROM   ICOMLUSR                                                                        \n"
//		 * ); tSQL.append(
//		 * " <OPT=S,S> WHERE  HOUSE_CODE = ?  </OPT>                                                \n"
//		 * ); tSQL.append(
//		 * " <OPT=S,S> AND    USER_ID = ?     </OPT>                                                 \n"
//		 * );
//		 *
//		 * //비밀번호가 3개월이 지났는지는 사용. 2006.10.08 tSQL.append(
//		 * " AND    TO_DATE((PW_RESET_DATE), 'YYYYMMDDHH24')+ 90 > SYSDATE                         \n"
//		 * );
//		 */
//		tSQL.append("	SELECT CASE COUNT(*) 	\n");
//		tSQL.append("	         WHEN 0	\n");
//		tSQL.append("			   THEN 'N' \n");
//		tSQL.append("	         ELSE (case max(isnull(pw_reset_flag, 'N') )	\n");
//		tSQL.append("                   when 'N' then 'YN' \n");
//		tSQL.append("                     else 'YY'  \n");
//		tSQL.append("                   end   \n");
//		tSQL.append("                )  \n");
//		tSQL.append("          end    \n");
//		tSQL.append("    FROM   ICOMLUSR	\n");
//		tSQL.append("	<OPT=S,S> WHERE  HOUSE_CODE = ?  </OPT>	\n");
//		tSQL.append("	<OPT=S,S> AND    USER_ID = ?     </OPT>	\n");
//		// 비밀번호가 3개월이 지났는지는 사용. 2006.10.08
//		tSQL.append("	and convert(datetime, PW_RESET_DATE)+90 > getdate() \n");
//
//		SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//		rtn = sm.doSelect(args);
//		return rtn;
//
//	}
//
//	private String sel_getPwdCheck(String[] args, String user_id) throws Exception {
//
//		String rtn = null;
//		ConnectionContext ctx = getConnectionContext();
//
//		StringBuffer tSQL = new StringBuffer();
//		// tSQL.append(
//		// " SELECT  DECODE(LUSR.PASSWORD, VNGL.IRS_NO , 'Y','N') AS PWD_CHK               \n");
//		tSQL.append(" SELECT  case lusr.password when vngl.irs_no then 'Y' else 'N' end AS PWD_CHK               \n");
//		tSQL.append(" FROM ICOMLUSR LUSR, ICOMVNGL VNGL               \n");
//		tSQL.append(" <OPT=S,S> WHERE LUSR.HOUSE_CODE = ?  </OPT>                                                \n");
//		tSQL.append(" AND LUSR.HOUSE_CODE = VNGL.HOUSE_CODE               \n");
//		tSQL.append(" <OPT=S,S> AND LUSR.USER_ID = ?  </OPT>                                                \n");
//		tSQL.append(" AND LUSR.USER_ID = VNGL.VENDOR_CODE               \n");
//		tSQL.append(" AND LUSR.STATUS != 'D'               \n");
//		tSQL.append(" AND VNGL.STATUS != 'D'               \n");
//
//		/*
//		 * 비밀번호가 사업자번호와 같으면 바꾸도록
//		 */
//
//		SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//		rtn = sm.doSelect(args);
//		return rtn;
//
//	}
//
//	public SepoaOut getLastConnection(String[] args) {
//		try {
//			String sub_rtn = sel_getLastConnection(args);
//			int insert_rtn = -1;
//
//			Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> sub_rtn : " + sub_rtn);
//
//			if (!sub_rtn.equals("")) {
//				insert_rtn = et_insert_user_log(args);
//			}
//
//			setValue(sub_rtn);
//			setStatus(1);
//
//		} catch (Exception e) {
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage("sel_getPwdValidate Failed");
//			Logger.err.println(this, e.getMessage());
//
//		}
//		return getSepoaOut();
//	}
//
//	private String sel_getLastConnection(String[] args) throws Exception {
//
//		String rtn = null;
//		ConnectionContext ctx = getConnectionContext();
//		String user_id = args[1];
//
//		StringBuffer tSQL = new StringBuffer();
//
//		tSQL.append("SELECT                             					   						\n");
//		tSQL.append("	MAX(JOB_DATE+JOB_TIME+IP) AS INFO					\n");
//		tSQL.append("FROM                                  											\n");
//		tSQL.append("	USERLOG                             									\n");
//		tSQL.append(" <OPT=S,S> WHERE  HOUSE_CODE = ?  </OPT>	 	\n");
//		tSQL.append(" <OPT=S,S> AND    USER_ID = ?     </OPT>          		\n");
//
//		SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//		rtn = sm.doSelect(args);
//		return rtn;
//
//	}
//
//	private int et_insert_user_log(String[] args) throws Exception {
//
//		String rtn = null;
//		int insert_rtn = -1;
//		ConnectionContext ctx = getConnectionContext();
//		SepoaFormater wf = null;
//		String user_id = info.getSession("ID");
//		String house_code = info.getSession("HOUSE_CODE");
//		String user_ip = info.getSession("USER_IP");
//		String user_id2 = args[1];
//
//		StringBuffer sql = new StringBuffer();
//
//		sql.append("SELECT                             					   						\n");
//		sql.append("	USER_NAME_LOC													\n");
//		sql.append("FROM                                  										\n");
//		sql.append("	ICOMLUSR		                     									\n");
//		sql.append(" <OPT=S,S> WHERE  HOUSE_CODE = ?  </OPT>	 	\n");
//		sql.append(" <OPT=S,S> AND    USER_ID = ?     </OPT>          		\n");
//
//		SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
//		rtn = sm.doSelect(args);
//		wf = new SepoaFormater(rtn);
//
//		String user_name_loc = wf.getValue("USER_NAME_LOC", 0);
//
//		sql = new StringBuffer();
//
//		sql.append(" INSERT INTO USERLOG  								   	\n");
//		sql.append(" (                      													\n");
//		sql.append("      HOUSE_CODE,											    \n");
//		sql.append("      NO,            													    \n");
//		sql.append("      USER_ID,        											    \n");
//		sql.append("      USER_NAME_LOC,    									    \n");
//		sql.append("      PROGRAM,      											    \n");
//		sql.append("      PROGRAM_DESC,    										\n");
//		sql.append("      JOB_TYPE,           											\n");
//		sql.append("      JOB_DATE,           											\n");
//		sql.append("      JOB_TIME,           											\n");
//		sql.append("      IP,                 													\n");
//		sql.append("      PROCESS_ID,         										\n");
//		sql.append("      METHOD_NAME         										\n");
//		sql.append(" ) VALUES (               											\n");
//		sql.append("      '" + house_code + "',											\n");
//		sql.append("      USERLOG_NO.NEXTVAL,  								\n");
//		sql.append("      '" + user_id2 + "',           									\n");
//		sql.append("      '" + user_name_loc + "',										\n");
//		sql.append("      'Login',            												\n"); // PROGRAM
//		sql.append("      'Login',            												\n"); // PROGRAM_DESC
//		sql.append("      'LI',               													\n"); // JOB_TYPE(LI:로그인,
//																	// WK:작업,
//																	// LO:로그아웃)
//		sql.append("      TO_CHAR(SYSDATE,'YYYYMMDD'),    				\n"); // JOB_DATE
//		sql.append("      TO_CHAR(SYSDATE,'HH24MISS'),    				\n"); // JOB_TIME
//		sql.append("      '" + user_ip + "',                  							\n"); // IP
//		sql.append("      'p0030',         													\n");
//		sql.append("      'getLastConnection'              							\n");
//		sql.append(" ) \n");
//
//		sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
//		insert_rtn = sm.doInsert(null, null);
//
//		Commit();
//
//		return insert_rtn;
//
//	}
//
//	public SepoaOut InsertLogoutInfo(String[] args) {
//		try {
//			String user_id = info.getSession("ID");
//			int insert_rtn = -1;
//			insert_rtn = et_InsertLogoutInfo(args);
//
//			setValue("Insert Row=" + insert_rtn);
//			setStatus(1);
//
//		} catch (Exception e) {
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage("InsertLogoutInfo Failed");
//			Logger.err.println(this, e.getMessage());
//
//		}
//		return getSepoaOut();
//	}
//
//	private int et_InsertLogoutInfo(String[] args) throws Exception {
//
//		int insert_rtn = -1;
//		ConnectionContext ctx = getConnectionContext();
//		String user_id = info.getSession("ID");
//		String house_code = args[0];
//		String id = args[1];
//		String user_name = args[2];
//		String user_ip = args[3];
//
//		StringBuffer sql = new StringBuffer();
//
//		sql.append(" INSERT INTO USERLOG   							  	\n");
//		sql.append(" (                        												\n");
//		sql.append("      HOUSE_CODE,                 							\n");
//		sql.append("      NO,                 											\n");
//		sql.append("      USER_ID,            										\n");
//		sql.append("      USER_NAME_LOC,           							\n");
//		sql.append("      PROGRAM,            										\n");
//		sql.append("      PROGRAM_DESC,       								\n");
//		sql.append("      JOB_TYPE,           										\n");
//		sql.append("      JOB_DATE,           										\n");
//		sql.append("      JOB_TIME,           										\n");
//		sql.append("      IP,                 												\n");
//		sql.append("      PROCESS_ID,         									\n");
//		sql.append("      METHOD_NAME         									\n");
//		sql.append(" )SELECT               										\n");
//		sql.append("      '" + house_code + "',										\n");
//		sql.append("      (SELECT ISNULL(MAX(HOUSE_CODE),0) + 1 FROM USERLOG),  	    \n");
//		sql.append("      '" + id + "',														\n");
//		sql.append("      '" + user_name + "',										\n");
//		sql.append("      'Logout',            											\n"); // PROGRAM
//		sql.append("      'Logout',            											\n"); // PROGRAM_DESC
//		sql.append("      'LO',               											\n"); // JOB_TYPE(LI:로그인,
//																// WK:작업,
//																// LO:로그아웃)
//		sql.append("      convert(varchar, getdate(),112),    			\n"); // JOB_DATE
//		sql.append("      replace(convert(char(8),getdate(),108),':',''),    			\n"); // JOB_TIME
//		sql.append("      '" + user_ip + "',												\n"); // IP
//		sql.append("      'p0030',         												\n");
//		sql.append("      'Logout'              										\n");
//
//		SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
//		insert_rtn = sm.doInsert(null, null);
//
//		Commit();
//
//		return insert_rtn;
//
//	}
//
//	public SepoaOut setPASS_CHECK_CNT(String i_user_id) {
//
//		try {
//
//			String change_date = SepoaDate.getShortDateString();
//			String change_time = SepoaDate.getShortTimeString();
//
//			int rtn = et_setPASS_CHECK_CNT(i_user_id, change_date);
//
//			setStatus(1);
//			setMessage("성공적으로 처리되었습니다.");
//
//		} catch (Exception e) {
//			Logger.err.println("Exception e =" + e.getMessage());
//			setStatus(0);
//			setMessage(e.getMessage().trim());
//
//			Logger.err.println(this, e.getMessage());
//		}
//		return getSepoaOut();
//	}
//
//	private int et_setPASS_CHECK_CNT(String i_user_id, String change_date) throws Exception, DBOpenException {
//
//		String house_code = info.getSession("HOUSE_CODE");
//
//		int rtn = -1;
//		ConnectionContext ctx = getConnectionContext();
//
//		try {
//
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append("  UPDATE ICOMLUSR                                         \n");
//			tSQL.append("  SET                                                     \n");
//			tSQL.append("       PW_RESET_FLAG          = 'Y'                       \n");
//			tSQL.append("      ,PW_RESET_DATE          = '" + change_date + "'         \n");
//			tSQL.append("      ,PASS_CHECK_CNT         = '99'                       \n");
//			tSQL.append("  WHERE HOUSE_CODE = '" + house_code + "' ");
//			tSQL.append("  AND   USER_ID = '" + i_user_id + "'   ");
//
//			SepoaSQLManager sm = new SepoaSQLManager(id, this, ctx, tSQL.toString());
//
//			rtn = sm.doUpdate(null, null);
//
//			Commit();
//
//		} catch (Exception e) {
//			Rollback();
//			throw new Exception("et_setPASS_CHECK_CNT:" + e.getMessage());
//		} finally {
//		}
//		return rtn;
//	}
//
//	// /////////////////////////////////////////////////////////////////////////////////////////////
//	/**
//	 * 임의의 사용자 아이디 패스워드 가져오기 강제 세션을 만들기 위해 필요하다.
//	 */
//	public SepoaOut getAnonymousUser() {
//		try {
//			String rtn = null;
//			rtn = et_getAnonymousUser();
//			setValue(rtn);
//			setStatus(1);
//			setMessage(msg.getMessage("0000"));
//
//		} catch (Exception e) {
//			setStatus(0);
//			setMessage(msg.getMessage("0001"));
//			Logger.err.println("JHYOON", this, "Exception e =" + e.getMessage());
//		}
//		return getSepoaOut();
//	}
//
//	private String et_getAnonymousUser() throws Exception {
//		String rtn = null;
//		ConnectionContext ctx = getConnectionContext();
//		try {
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append(" SELECT TOP 1                             \n");
//			tSQL.append(" USER_ID, PASSWORD                      	\n");
//			tSQL.append(" FROM 								    \n");
//			tSQL.append(" ICOMLUSR             				\n");
//			SepoaSQLManager sm = new SepoaSQLManager("JHYOON", this, ctx, tSQL.toString());
//
//			rtn = sm.doSelect(null);
//			if (rtn == null)
//				throw new Exception("SQL Manager is Null");
//		} catch (Exception e) {
//			throw new Exception("et_getAnonymousUser:" + e.getMessage());
//		} finally {
//
//		}
//		return rtn;
//	}

}

