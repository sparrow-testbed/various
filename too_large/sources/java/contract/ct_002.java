package contract;

import java.sql.ResultSet;
import java.util.Map;
import java.util.Vector;
import java.util.HashMap;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;

public class CT_002 extends SepoaService
{
	private String ID = info.getSession("ID");

	public CT_002(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
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

	public SepoaOut getUser(String user_id, String user_name  ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_getUser( user_id, user_name );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	private String[] et_getUser(String user_id, String user_name  ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String cur_date       = SepoaDate.getShortDateString();
		String company_code   = info.getSession("COMPANY_CODE");
		String house_code	  = info.getSession("HOUSE_CODE");
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.append(" SELECT USER_ID						\n");
			sb.append(" 	,USER_NAME_LOC                  \n");
			sb.append(" FROM ICOMLUSR                       \n");
			sb.append("	WHERE HOUSE_CODE = '"+house_code+"' \n");
			sb.append("	AND USER_TYPE = 'WOORI'             \n");
			sb.append("	AND STATUS != 'D'                   \n");
			sb.append(sm.addSelectString("AND   USER_ID     LIKE '%' || ? || '%'	\n ")); sm.addStringParameter(user_id);
			sb.append(sm.addSelectString("AND   upper(USER_NAME_LOC)  LIKE '%' || upper(?)  || '%'	\n ")); sm.addStringParameter(user_name);
			
			straResult[0] = sm.doSelect( sb.toString() );
			if( straResult[0] == null )	straResult[1] = "SQL manager is Null";
		}
		catch (Exception e)
		{
			straResult[1] = e.getMessage();
			Logger.debug.println(info.getSession("ID"), this, "=---------et_getApprovalUser error.");
		}
		finally
		{
		}

		return straResult;
	}

	public SepoaOut getBaseApprovalSignPath(String user_id, String app_no ) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_getBaseApprovalSignPath( user_id, app_no );

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	private String[] et_getBaseApprovalSignPath(String user_id, String app_no ) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer(); 
		String cur_date       = SepoaDate.getShortDateString();
		String company_code   = info.getSession("COMPANY_CODE");
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue(); 
			sb.append("	SELECT count(*)					\n"); 
			sb.append("	FROM SALGL                                                 \n");
			sb.append("	WHERE 1=1                                                 \n");
			sb.append(sm.addSelectString("	AND  COMPANY_CODE =  ?  \n")); sm.addStringParameter(company_code);
			sb.append(sm.addSelectString("	AND ADD_USER_ID =  ?  \n")); sm.addStringParameter(info.getSession("ID"));
			String result = sm.doSelect( sb.toString() );
			SepoaFormater wf = new SepoaFormater(result);

			int cnt = Integer.parseInt(wf.getValue(0,0));
			if(cnt == 0){  
				sm.removeAllValue(); 
				sb.delete( 0, sb.length() );
				sb.append("	SELECT A.SIGN_USER_ID, A.SIGN_PATH_SEQ					\n");
				sb.append("			,B.USER_ID AS EMPLOYEE_NO			\n");
				sb.append("			,B.USER_NAME_LOC			\n"); 
				sb.append("	FROM SSCLN A, ICOMLUSR B                                                             \n");
				sb.append("	WHERE A.COMPANY_CODE = 'W100'                                             \n");
				sb.append("	AND A.DOC_TYPE = 'CT'                                                     \n");
				sb.append("	AND A.DOC_NO = ( SELECT MAX(B.DOC_NO)                                     \n");
				sb.append("					FROM SSCGL A, SSCLN B                   \n");
				sb.append("					WHERE A.COMPANY_CODE = B.COMPANY_CODE   \n");
				sb.append("					AND A.DOC_TYPE = B.DOC_TYPE             \n");
				sb.append("					AND A.DOC_NO = B.DOC_NO                 \n");
				sb.append(sm.addSelectString("AND   A.ADD_USER_ID = ? )           \n ")); sm.addStringParameter(user_id);
				sb.append("	AND A.COMPANY_CODE = B.COMPANY_CODE                                    \n");
				sb.append("	AND A.SIGN_USER_ID = B.USER_ID                                    \n");
				sb.append("	ORDER BY A.SIGN_PATH_SEQ                                                  \n");
			}else{ 
				sm.removeAllValue(); 
				sb.delete( 0, sb.length() );
				sb.append(" SELECT  									\n");
				sb.append("     APP_USER_ID  AS SIGN_USER_ID             \n");
				sb.append(" 	,APP_SEQ  AS SIGN_PATH_SEQ               	\n");
				sb.append(" 	,APP_USER_ID  AS EMPLOYEE_NO                  	\n");
				sb.append(" 	,getUserName(APP_USER_ID, 'KO') AS  USER_NAME_LOC          \n"); 
				sb.append(" FROM SALLN A, SALGL B                                		\n");
				sb.append("	WHERE 1=1                                                 \n");
				sb.append("	AND A.COMPANY_CODE = B.COMPANY_CODE                       \n");
				sb.append("	AND A.APP_NO = B.APP_NO                           \n");
				sb.append(sm.addSelectString("	AND  A.COMPANY_CODE =  ?  \n")); sm.addStringParameter(company_code);
				if(app_no.equals("")){
					sb.append("	AND B.DEFAULT_FLAG =  'Y'  \n");
				}else{
					sb.append(sm.addSelectString("	AND A.APP_NO =  ?  \n")); sm.addStringParameter(app_no);
				}
				sb.append(" ORDER BY A.APP_SEQ 		\n");
				
			}
			straResult[0] = sm.doSelect( sb.toString() );
			if( straResult[0] == null )	straResult[1] = "SQL manager is Null";
		}
		catch (Exception e)
		{
			straResult[1] = e.getMessage();
			Logger.debug.println(info.getSession("ID"), this, "=---------et_getBaseApprovalSignPath error.");
		}
		finally
		{
		}

		return straResult;
	}
 //결재요청
 	public SepoaOut setApproval(SepoaInfo info,  Map<String, String> header) throws Exception
	{
		try{
			int rtn = 0; 
			setStatus(1);
			setFlag(true);
			
			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			SepoaFormater sf = null;
			
			
			//getParam
			String CONT_NO = (String)header.get("CONT_NO");
			String CONT_GL_SEQ = (String)header.get("CONT_GL_SEQ");
			String APPROVAL_STR = (String)header.get("APPROVAL_STR"); 
			String CONT_AMT = (String)header.get("CONT_AMT"); 
			String HEADER_TEXT = (String)header.get("SUBJECT"); 

//            System.out.println("CONT_NO : "+CONT_NO);
//            System.out.println("CONT_GL_SEQ : "+CONT_GL_SEQ);
//            System.out.println("APPROVAL_STR : "+APPROVAL_STR);
//            System.out.println("CONT_AMT : "+CONT_AMT);
   //        System.out.println("HEADER_TEXT : "+HEADER_TEXT);
   //        System.out.println("COMPANY_CODE : "+info.getSession("COMPANY_CODE"));
   //        System.out.println("DEPARTMENT : "+info.getSession("DEPARTMENT"));
   //        System.out.println("ID : "+info.getSession("ID"));
			//결재선 저장
            SignRequestInfo sri = new  SignRequestInfo();
            sri.setCompanyCode(info.getSession("COMPANY_CODE"));
            sri.setDept(info.getSession("DEPARTMENT"));
            sri.setReqUserId(info.getSession("ID"));
            sri.setDocType("CT");
            sri.setDocNo(CONT_NO);
            sri.setDocSeq(CONT_GL_SEQ);
            //sri.setItemCount(bean_args.length);
            sri.setItemCount(1);
            sri.setSignStatus("P");								//SSCGL의 APP_STATUS
            sri.setCur("KRW");
            sri.setTotalAmt(Double.parseDouble(CONT_AMT));		//총 금액
            sri.setDocName(HEADER_TEXT);						//SUBJECT
            sri.setSignString(APPROVAL_STR); 					// AddParameter 에서 넘어온 정보
            rtn = CreateApproval(info, sri);
            
//            System.out.println("Sign : "+rtn);
//            System.out.println("결재라인인서트 성공(1) 실패(0)rtn : "+rtn);
            Logger.debug.println("결재선 지정후 자바단 로그(서비스단) : "+APPROVAL_STR);
            
            if(rtn == 0 ){
				Rollback();
				setMessage("결재선 지정중 에러가 발생하였습니다.");
				setStatus(0);
				setFlag(false);
				Logger.err.println(info.getSession("ID"), this, "결재선 지정중 에러가 발생하였습니다.");
				return getSepoaOut();
			}
            
            ////////////////////////////////////////////
            String[] rtn2 = new String[3];
            //setMessage(CONT_NO+"건 임시저장 성공");	//성공일때 SAP에서 넘겨주는 성공 메세지도 그리드에 같이 뿌려주자~ 
            ////////////////////////////////////////////
             
	 			//결재 헤더 테이블 상태값 변경
	 			sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE	ICOMSCTM		--결재 헤더 테이블 상태값 변경(최종결재자면)				\n");
				sb.append("   SET  	APP_STATUS		= 'P',					\n");//E:완료, P:진행중, R:반려[M318]
				sb.append(" 		CHANGE_DATE		= ?,       				\n");sm.addStringParameter(SepoaDate.getShortDateString());
				sb.append(" 		CHANGE_TIME		= ?,        			\n");sm.addStringParameter(SepoaDate.getShortTimeString());
				sb.append(" 		CHANGE_USER_ID 	= ?      				\n");sm.addStringParameter(info.getSession("EMPLOYEE_NO"));
		 		sb.append(" WHERE 1 = 1										\n");
		 		sb.append("   AND COMPANY_CODE  = ?							\n");sm.addStringParameter(info.getSession("COMPANY_CODE"));
    			sb.append("   AND DOC_NO		= ?							\n");sm.addStringParameter(CONT_NO);    			
    			sb.append("   AND DOC_SEQ		= ?							\n");sm.addStringParameter(CONT_GL_SEQ);    			
		 		sb.append("   AND DOC_TYPE		= ?							\n");sm.addStringParameter(sri.getDocType());
		 		int rtn1 = sm.doUpdate(sb.toString());
		 		if(rtn1 < 1){
					Rollback();
					setStatus(0);
					setFlag(false);
					setMessage("입력중 에러가 발생하였습니다. 관리자한테 문의하여 주십시요.");
					Logger.err.println(info.getSession("ID"), this, "입력중 에러가 발생하였습니다. 관리자한테 문의하여 주십시요.");
					return getSepoaOut();
				} 

	 			//결재 헤더 테이블 상태값 변경
	 			sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append(" UPDATE	SCPGL		 \n");
				sb.append("   SET  	SIGN_STATUS		= 'P',					\n");//E:완료, P:진행중, R:반려[M318]
				//sb.append(" 		CHANGE_DATE		= ?,       				\n");sm.addStringParameter(SepoaDate.getShortDateString());
				//sb.append(" 		CHANGE_TIME		= ?,        			\n");sm.addStringParameter(SepoaDate.getShortTimeString());
				//sb.append(" 		CHANGE_USER_ID 	= ?,      				\n");sm.addStringParameter(info.getSession("EMPLOYEE_NO"));
				sb.append(" 		DEL_FLAG 		= 'N'      				\n");
		 		sb.append(" WHERE 1 = 1										\n");
		 		sb.append("   AND CONT_NO		= ?							\n");sm.addStringParameter(CONT_NO);
		 		sb.append("   AND CONT_GL_SEQ		= ?							\n");sm.addStringParameter(CONT_GL_SEQ);
		 		 
		 		rtn1 = sm.doUpdate(sb.toString());
		 		if(rtn1 < 1){
					Rollback();
					setStatus(0);
					setFlag(false);
					setMessage("입력중 에러가 발생하였습니다. 관리자한테 문의하여 주십시요.");
					Logger.err.println(info.getSession("ID"), this, "입력중 에러가 발생하였습니다. 관리자한테 문의하여 주십시요.");
					return getSepoaOut();
				} 
	 		  
				setStatus(1);
				setFlag(true);
				Commit();

		}catch (Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	

	private int CreateApproval(SepoaInfo info,SignRequestInfo sri)   // 결재모듈에 필요한 생성부분
    {                                                                                // 그대로 갖다 쓴다.

        Logger.debug.println(info.getSession("ID"),this,"##### CreateApproval #####");

        SepoaOut wo     = null;
        SepoaRemote ws  = null;
        String nickName= "p6027";
//        String nickName= "CT_150";
        String conType = "NONDBJOB";
        String MethodName1 = "setConnectionContext";
        ConnectionContext ctx = getConnectionContext();

        try
        {
            Object[] obj1 = {ctx};
            String MethodName2 = "addSignRequest";
            Object[] obj2 = {sri};

            ws = new SepoaRemote(nickName,conType,info);
            ws.lookup(MethodName1,obj1);
            wo = ws.lookup(MethodName2,obj2);
        }catch(Exception e) {
            Logger.err.println("approval: = " + e.getMessage());
        }
        return (wo != null)?wo.status:null ;
    }
	
	/**
	 * <b>결재를 승인한다.</b>
	 * <pre>
	 * et_Approval을 호출한다.
	 * </pre>
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval(SignResponseInfo inf)
	{
		String user_id		 = info.getSession("EMPLOYEE_NO");
		SepoaOut value = null;
		
		try
		{
			
			Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
			
			value = et_Approval(inf);
			
			Commit();
		}
		catch(Exception e)
		{
			Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			Logger.debug.println(user_id, this, "***************Exception***************");
			Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
			Logger.debug.println(user_id, this, "***************Exception***************");
			try
			{
				Rollback();
			}
			catch(Exception re)
			{
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		
		return value;
	}
	
	
	private SepoaOut et_Approval(SignResponseInfo inf) throws Exception
	{
		String user_id		 = info.getSession("EMPLOYEE_NO");
		String house_code	 = info.getSession("HOUSE_CODE");
		String location_code = info.getSession("LOCATION_CODE");
		String department	 = info.getSession("DEPARTMENT");
		String name_loc		 = info.getSession("NAME_LOC");
		String name_eng		 = info.getSession("NAME_ENG");
		String language		 = info.getSession("LANGUAGE");
		String add_date     = SepoaDate.getShortDateString();
		String add_time     = SepoaDate.getShortTimeString();
		Logger.debug.println(user_id,this,"############## p2017.Approval Start ################");
		
		try
		{
			
			String sign_status	= inf.getSignStatus();
			String doc_type     = inf.getDocType(); // 품의에서 넘어	왔는지 계약금 쪽에서 넘어 왔는 Check.
			String sign_date	= inf.getSignDate();
			String sign_user_id	= inf.getSignUserId();
			
			String[] DOC_NO	      = inf.getDocNo();
			String[] DOC_SEQ	  = inf.getDocSeq();
			String[] SHIPPER_TYPE = inf.getShipperType();
			
			
			Logger.debug.println(user_id,this,"############## Approval SignStatus ==> " + sign_status);
			
			int	rtn_prdt = -1;
			int rtn_cnhd = -1;

			int iDocCount = DOC_NO.length;
			String[][] objCNHD	  =	new	String[iDocCount][];
			
			for(int	i=0;i <	DOC_NO.length;i++)
			{
				String[] TEMP_CNHD = {
					  sign_status
					, sign_date
					, sign_user_id
					, DOC_NO[i]
				};
				
				objCNHD[i] = TEMP_CNHD;
			}
			
			
			rtn_cnhd = setSignUpdate(objCNHD);
			setStatus(1);
			setMessage("");
			
			//반려이거나 취소일 경우 여기서 끝낸다.
			
		}
		catch(Exception	e)
		{
			throw new Exception("et_Approval error"+e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	
	public int setSignUpdate(String[][] args) throws Exception
	{
		int rtn = 0;
		
		try {
			setStatus(1);
			setFlag(true);
						
			ConnectionContext ctx = getConnectionContext();
			StringBuffer sb = new StringBuffer();
			String LN_COST_DEPT_CODE = "";
			String GL_ACCT_CODE = "";
			String POSTING_DATE = "";
			String C_AMT = "";
			 

			Commit();

		}catch (Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return rtn;
	}
	

	public SepoaOut getApprovalLine(String user_id) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_getApprovalLine( user_id);

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	private String[] et_getApprovalLine(String user_id) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String cur_date       = SepoaDate.getShortDateString();
		String company_code   = info.getSession("COMPANY_CODE");
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
			sb.append(" SELECT APP_NO									\n");
			sb.append(" 	,APP_NAME                                 	\n");
			sb.append(" 	,APP_DESC                                 	\n");
			sb.append(" 	,DEFAULT_FLAG                               \n");
			sb.append(" 	,'X' AS LINE_FLAG                           \n");
			sb.append(" FROM SALGL                                 		\n");
			sb.append("	WHERE COMPANY_CODE = '"+company_code+"'	        \n");
			sb.append("	AND USER_ID = '"+user_id+"'						\n");
			
			straResult[0] = sm.doSelect( sb.toString() );
			if( straResult[0] == null )	straResult[1] = "SQL manager is Null";
		}
		catch (Exception e)
		{
			straResult[1] = e.getMessage();
			Logger.debug.println(info.getSession("ID"), this, "=---------et_getApprovaLine error.");
		}
		finally
		{
		}

		return straResult;
	}


	public SepoaOut setApprovalLine(String[][] straData, String user_id) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_setApprovalLine(straData, user_id);

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}
			
			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	private String[] et_setApprovalLine(String[][] straData, String user_id) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;	
		SepoaFormater sf1     = null; 
		String add_date     = SepoaDate.getShortDateString();
		String add_time     = SepoaDate.getShortTimeString();
		String company_code   = info.getSession("COMPANY_CODE");
		
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < straData.length; i++)
			{

				SepoaOut wo = DocumentUtil.getDocNumber(info, "AL");
				String APP_NO = wo.result[0];

				sm.removeAllValue();
				sb.delete( 0, sb.length() );
				sb.append("	INSERT INTO SALGL (                    \n ");
				sb.append("   COMPANY_CODE	\n ");
				sb.append("   ,APP_NO            \n ");
				sb.append("   ,USER_ID           \n ");
				sb.append("   ,APP_NAME          \n ");
				sb.append("   ,APP_DESC          \n ");
				sb.append("   ,ADD_DATE          \n ");
				sb.append("   ,ADD_TIME          \n ");
				sb.append("   ,ADD_USER_ID       \n ");
				sb.append("   ,CHANGE_DATE       \n ");
				sb.append("   ,CHANGE_TIME       \n ");
				sb.append("   ,CHANGE_USER_ID    \n ");
				sb.append("   ,DEFAULT_FLAG      \n ");
				sb.append("  ) VALUES (                    \n "); 
				sb.append("	 ?        \n "); sm.addStringParameter(company_code);
				sb.append("	 ,?        \n "); sm.addStringParameter(APP_NO);
				sb.append("	 ,?        \n "); sm.addStringParameter(user_id); 
				sb.append("	 ,?        \n "); sm.addStringParameter(straData[i][0]);
				sb.append("	 ,?        \n "); sm.addStringParameter(straData[i][1]);
				sb.append("	 ,?        \n "); sm.addStringParameter(add_date);
				sb.append("	 ,?        \n "); sm.addStringParameter(add_time);
				sb.append("	 ,?        \n "); sm.addStringParameter(user_id); 
				sb.append("	 ,?        \n "); sm.addStringParameter(add_date);
				sb.append("	 ,?        \n "); sm.addStringParameter(add_time);
				sb.append("	 ,?        \n "); sm.addStringParameter(user_id); 
				sb.append("	 ,?        \n "); sm.addStringParameter(straData[i][2]);
				sb.append("	 )         \n ");
				sm.doInsert(sb.toString());
				 
			}
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}	


	public SepoaOut setApprovalLineDelete(String[][] straData) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_setApprovalLineDelete(straData);

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}
			
			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	private String[] et_setApprovalLineDelete(String[][] straData) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;	
		SepoaFormater sf1     = null;  
		String company_code   = info.getSession("COMPANY_CODE");
		String user_id   = info.getSession("ID");
		
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < straData.length; i++)
			{
 
				sm.removeAllValue();
				sb.delete( 0, sb.length() );
				sb.append("	DELETE FROM SALGL                    \n ");
				sb.append(" WHERE  COMPANY_CODE	= ? \n ");sm.addStringParameter(company_code);
				sb.append(" AND APP_NO  = ?           \n ");sm.addStringParameter(straData[i][0]);
				sb.append(" AND USER_ID  = ?          \n "); sm.addStringParameter(user_id);  
				sm.doDelete(sb.toString());

				sm.removeAllValue();
				sb.delete( 0, sb.length() );
				sb.append("	DELETE FROM SALLN                    \n ");
				sb.append(" WHERE  COMPANY_CODE	= ? \n ");sm.addStringParameter(company_code);
				sb.append(" AND APP_NO  = ?           \n ");sm.addStringParameter(straData[i][0]);
				//sb.append(" AND USER_ID  = ?          \n "); sm.addStringParameter(user_id);  
				sm.doDelete(sb.toString());
				 
			}
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}	


	public SepoaOut setApprovalLineUser(String[][] straData, String app_no) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;
			rtn = et_setApprovalLineUser(straData, app_no);

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}
			
			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	private String[] et_setApprovalLineUser(String[][] straData, String app_no) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		SepoaFormater sf      = null;	
		SepoaFormater sf1     = null; 
		String add_date     	= SepoaDate.getShortDateString();
		String add_time     	= SepoaDate.getShortTimeString();
		String company_code   	= info.getSession("COMPANY_CODE");
		String user_id			= info.getSession("ID");
		
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sb.delete( 0, sb.length() );
			sb.append("	DELETE FROM SALLN                    \n ");
			sb.append(" WHERE  COMPANY_CODE	= ? \n ");sm.addStringParameter(company_code);
			sb.append(" AND APP_NO  = ?           \n ");sm.addStringParameter(app_no);
			sm.doDelete(sb.toString());
			
			for (int i = 0; i < straData.length; i++)
			{ 
				sm.removeAllValue();
				sb.delete( 0, sb.length() );
				sb.append("	INSERT INTO SALLN (                    \n ");
				sb.append("   COMPANY_CODE	\n ");
				sb.append("   ,APP_NO            \n ");
				sb.append("   ,APP_SEQ            \n ");
				sb.append("   ,APP_USER_ID           \n "); 
				sb.append("   ,ADD_DATE          \n ");
				sb.append("   ,ADD_TIME          \n ");
				sb.append("   ,ADD_USER_ID       \n ");
				sb.append("   ,CHANGE_DATE       \n ");
				sb.append("   ,CHANGE_TIME       \n ");
				sb.append("   ,CHANGE_USER_ID    \n "); 
				sb.append("  ) VALUES (                    \n "); 
				sb.append("	 ?        \n "); sm.addStringParameter(company_code);
				sb.append("	 ,?        \n "); sm.addStringParameter(app_no); 
				sb.append("	 ,?        \n "); sm.addStringParameter(straData[i][0]);
				sb.append("	 ,?        \n "); sm.addStringParameter(straData[i][1]); 
				sb.append("	 ,?        \n "); sm.addStringParameter(add_date);
				sb.append("	 ,?        \n "); sm.addStringParameter(add_time);
				sb.append("	 ,?        \n "); sm.addStringParameter(user_id); 
				sb.append("	 ,?        \n "); sm.addStringParameter(add_date);
				sb.append("	 ,?        \n "); sm.addStringParameter(add_time);
				sb.append("	 ,?        \n "); sm.addStringParameter(user_id);  
				sb.append("	 )         \n ");
				sm.doInsert(sb.toString());
				 
			}
			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			straResult[1] = e.getMessage();
//			e.printStackTrace();
			Logger.debug.println(user_id, this, e.getMessage());
		}
		finally
		{
		}

		return straResult;
	}	

	public SepoaOut getApprovalLineUser(String app_no) {
		try
		{
			setStatus(1);
			setFlag(true);
			String[] rtn = null;

			rtn  = et_getApprovalLineUser( app_no);

			if (rtn[1] != null){
				setStatus(0);
				setFlag(false);				
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
			}

			setValue(rtn[0]);
		}
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	private String[] et_getApprovalLineUser(String app_no) throws Exception {
		String[] straResult   = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb       = new StringBuffer();
		String cur_date       = SepoaDate.getShortDateString();
		String company_code   = info.getSession("COMPANY_CODE");
		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			sm.removeAllValue();
 
			sb.append(" SELECT  									\n");
			sb.append("     APP_USER_ID  AS SIGN_USER_ID             \n");
			sb.append(" 	,APP_SEQ  AS SIGN_PATH_SEQ               	\n");
			sb.append(" 	,APP_USER_ID  AS EMPLOYEE_NO                  	\n");
			sb.append(" 	,getUserName(APP_USER_ID, 'KO') AS  USER_NAME_LOC          \n"); 
			sb.append(" 	,'Y' AS DEL_FALG          \n"); 
			sb.append(" FROM SALLN                                 		\n");
			sb.append("	WHERE COMPANY_CODE = '"+company_code+"'	        \n");
			sb.append("	AND APP_NO = '"+app_no+"'						\n");
			sb.append(" ORDER BY APP_SEQ 		\n");
			
			straResult[0] = sm.doSelect( sb.toString() );
			if( straResult[0] == null )	straResult[1] = "SQL manager is Null";
		}
		catch (Exception e)
		{
			straResult[1] = e.getMessage();
			Logger.debug.println(info.getSession("ID"), this, "=---------et_getApprovalLineUser error.");
		}
		finally
		{
		}

		return straResult;
	}
	
}