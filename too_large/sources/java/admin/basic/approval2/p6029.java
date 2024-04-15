package	admin.basic.approval2;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

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
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.SepoaApproval;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignResponseInfo;

public class p6029 extends SepoaService {
		
	private Message msg; 
	
    public p6029(String opt, SepoaInfo info) throws SepoaServiceException{ 
        super(opt, info); 
        setVersion("1.0.0"); 
        msg = new Message(info,"FW");
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



	public String ComputebigDecimal(String value) {
		String bigValue	= "";
		if(!value.equals("")) {
			BigDecimal bValue =	new	BigDecimal(value);
			bigValue = bValue.toString();
		}
		//Logger.debug.println(	info.getSession("ID"), this, "bigDecimal 변환값========"+bigValue);
		return bigValue;

	}


//Mail

/* 문서형태, 문서상태, 내/외자 구분	조건을 입력하고	Query 버튼을 누르면	Data를 가져온다..(결재승인현황)	*/
	public SepoaOut	getAppMail(String doc_no) {
		try{
			String user_id = info.getSession("ID");
			String rtn = null;
			rtn	= et_getAppMail(doc_no);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}catch(Exception e){
			
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private	String et_getAppMail(String	doc_no)	throws Exception
	{
		String result =	null;
		ConnectionContext ctx =	getConnectionContext();
		String house_code =	info.getSession("HOUSE_CODE");

		try	{
			StringBuffer sql = new StringBuffer();

			sql.append(" select	a.doc_type,	a.doc_no,														\n");
			sql.append("	 decode(SUBSTRING(a.doc_seq,8,2),'AD','계약금','JD','중도금',						\n");
			sql.append("		 'RD','잔금','00','계획결재','01','결과결재',a.doc_seq),					\n");
			sql.append("	 a.app_stage, '' as	urgent,	a.shipper_type,	a.doc_seq, a.company_code,			\n");
			sql.append("	 (select c.sign_user_id	from icomsctp c											\n");
			sql.append("	 where a.house_code	= c.house_code and a.company_code =	c.company_code			\n");
			sql.append("	 and a.doc_type	= c.doc_type and a.doc_seq = c.doc_seq and a.doc_no	= c.doc_no	\n");
			sql.append("	 and c.sign_path_seq =	" +getConfig("sepoa.generator.db.selfuser") + "."+ "nvl(a.app_stage,0) + 2 )								\n");
 			sql.append(" from icomsctm a																	\n");
			sql.append("  where	a.house_code = '"+house_code+"'												\n");
			sql.append("  and a.doc_no = '"+doc_no+"'														\n");

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"), this,	ctx, sql.toString());
			result = sm.doSelect();

			if(result == null) throw new Exception("SQLManager is null");

		}catch(Exception ex) {
			throw new Exception("et_getMaintain4()"+ ex.getMessage());
		}
		return result;
	}





/**
 * 결재 승인 화면
 * @param args
 * @param proceeding_flag
 * @param operating_code
 * @return
 */
    public SepoaOut getMaintain(String[] args, String proceeding_flag, String person_app_status) {
    	try{
            String rtn = et_getMaintain(args, proceeding_flag, person_app_status);
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

	private	String et_getMaintain(String[] _args, String proceeding_flag, String person_app_status) throws Exception {
		String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        /*
         * 		String[] args = {house_code,
						 user_id,
						 doc_type,
						 doc_no,
						 app_status,
						 shipper_type,
						 ctrl_person_id,
						 from_date,
						 to_date
         * */
        int k=0;

        String house_code		= _args[k++];
        String user_id			= _args[k++];
        String doc_type			= _args[k++];
        String doc_no			= _args[k++];
        String app_status		= _args[k++];
        String shipper_type		= _args[k++];
        String ctrl_person_id	= _args[k++];
        String from_date		= _args[k++];
        String to_date			= _args[k++];
        String subject			= _args[k++];
        String add_user_name	= _args[k++];
        String sign_from_date	= _args[k++];
        String sign_to_date		= _args[k++];        


        wxp.addVar("user_id"			, user_id);
        wxp.addVar("app_status"			, app_status);
        wxp.addVar("proceeding_flag"	, proceeding_flag);
        wxp.addVar("person_app_status"	, person_app_status);

        // 대표이사 권한, 구매팀장 권한
        String MANAGER_POSITION = info.getSession("MANAGER_POSITION");
        String DEPARTMENT 		= info.getSession("DEPARTMENT");

        String CEO_ROLE					= "N";
        String PURCHASE_CAPTION_ROLE	= "N";

        if(			"40".equals(MANAGER_POSITION)
        		||  ("352".equals(DEPARTMENT) && "20".equals(MANAGER_POSITION))
          )
        {
        	CEO_ROLE = "Y";
        }

        if("352".equals(DEPARTMENT) && "20".equals(MANAGER_POSITION))
        {
        	PURCHASE_CAPTION_ROLE = "Y";
        }

        // 대표이사 여부
        wxp.addVar("is_ceo"				, CEO_ROLE);
        // 구매팀장
        wxp.addVar("is_purchase_captin"	, PURCHASE_CAPTION_ROLE);

        
        

        wxp.addVar("doc_type"				, doc_type);
        String[] args =  {house_code
//        				, doc_type
        				, doc_no
        				, shipper_type
        				, from_date
        				, to_date
        				, subject
        				, add_user_name
        				, sign_from_date
        				, sign_to_date
        				};

    try {
   	 Logger.debug.println(info.getSession("ID"),this,">>>>>>>>>>>>>>>>>>>>>>>>> args.length: " + args.length);
		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
        rtn = sm.doSelect(args);

	}catch(Exception e) {
        Logger.err.println(info.getSession("ID"),this,e.getMessage());
        throw new Exception(e.getMessage());
    }
    return rtn;
}

/**
 * 차기결재버튼을 눌렀을때 뜨는	Pop	up 화면에서. 결재자	지정하고 확인 누르면 DB	에 Update된다.
 * @param args1
 * @param args2
 * @param args3
 * @param doc_type
 * @param doc_no
 * @param app_stage
 * @return
 */

	public SepoaOut setUpdate(String[][]	args1,
								String[][] args2,
								String[][] args3,
								String[] doc_type,
								String[] doc_no,
								String[] doc_seq,
								String[] app_stage) {
		try {
        	int rtn = et_setUpdate(args1, args2, args3, doc_type, doc_no, doc_seq, app_stage);
        	if(rtn < 1)
				throw new Exception("UPDATE ICOMSCTM ERROR");

			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		}catch(Exception e){
			try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            setStatus(0);
            setMessage(msg.getMessage("0002"));
		}

        return getSepoaOut();
    }

	/*결재처리*/
	private	int	et_setUpdate(String[][]	args1,
								String[][] args2,
								String[][] args3,
								String[] doc_type,
								String[] doc_no,
								String[] doc_seq,
								String[] app_stage) throws Exception {

		int	result =-1;
		String rtn = "";
        String[] settype1={"S","S","S","S","S","S","S","S"};
		String[] settype2={"S","S","S","S","S","S","S","S","S","S"};
		String[] settype3={"S","S","S","S","S","S","S"};

		ConnectionContext ctx =	getConnectionContext();
		SepoaSQLManager sm =	null;
		SepoaSQLManager sm1 = null;
		SepoaSQLManager sm2 = null;

		String DBO = getConfig("sepoa.generator.db.selfuser") +  ".";

		try	{
			StringBuffer tSQL =	new	StringBuffer();

			// APP_STAGE = 현재 승인하는 사람의 SIGN_PATH_SEQ
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp.getQuery());
			result = sm.doUpdate(args1,settype1);

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
		  	sm1	= new SepoaSQLManager(info.getSession("ID"), this,	ctx, wxp.getQuery());
			result = sm1.doUpdate(args2,settype2);
/*
 				합의쪽 조건으로 아래에서 실행
		  	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
			sm2	= new SepoaSQLManager(info.getSession("ID"), this,	ctx, wxp.getQuery());
			result = sm2.doUpdate(args3,settype3);
*/

			/*
			  * 합의자는 순서없이 결재한다. *
			 기안시, 결재시 :   다음 PROCEEDING_FLAG = 'P' 의 SIGN_PATH_SEQ와의 차이가
			 								1이 아니면 중간에 PROCEEDING_FLAG = 'C' 협조자가 존재 차이만큼  SIGN_CHECK = 'Y' 업데이트 + 문자보내기
			 								1이면 SIGN_PATH_SEQ+1 에 							  (기존로직)SIGN_CHECK = 'Y' 업데이트 + 문자보내기
			 합의시			: 	다음 PROCEEDING_FLAG = 'P' 밑의 차수가
			     							모두 승인이 이루어 졌다면 			다음 PROCEEDING_FLAG = 'P' 의  SIGN_CHECK = 'Y' 업데이트 + 문자보내기
			     							하나라도 승인안된것이 있다면 		아무반응없다.
			 */

			String send_mail = "N";
			for(int i=0; i<doc_no.length; i++){
				send_mail = "N";
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
				wxp.addVar("house_code"				, info.getSession("HOUSE_CODE"));
				wxp.addVar("company_code"			, info.getSession("COMPANY_CODE"));
				wxp.addVar("doc_type"				, doc_type	[i]);
				wxp.addVar("doc_no"					, doc_no	[i]);
				wxp.addVar("doc_seq"				, doc_seq	[i]);
				wxp.addVar("current_sign_path_seq"	, app_stage	[i]);

				sm	= new SepoaSQLManager(info.getSession("ID"), this,	ctx, wxp.getQuery());
				String str_4 = sm.doSelect();

				SepoaFormater wf_4 = new SepoaFormater(str_4);
				String PROCEEDING_FLAG = wf_4.getValue("PROCEEDING_FLAG", 0);

				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_5");
				wxp.addVar("house_code"				, info.getSession("HOUSE_CODE"));
				wxp.addVar("company_code"			, info.getSession("COMPANY_CODE"));
				wxp.addVar("doc_type"				, doc_type	[i]);
				wxp.addVar("doc_no"					, doc_no	[i]);
				wxp.addVar("doc_seq"				, doc_seq	[i]);
				wxp.addVar("current_sign_path_seq"	, app_stage	[i]);	// 현재결재자
				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
				String str_5 = sm.doSelect();

				SepoaFormater wf_5 = new SepoaFormater(str_5);
				String GAP = wf_5.getValue("GAP", 0);
				String next_sign_path_seq_p = wf_5.getValue("next_sign_path_seq_p", 0);

				if("P".equals(PROCEEDING_FLAG)){
					// 1. 결재시
					if("".equals(GAP)){
						// 결재자 다음으로 모두 합의인경우, 모든 합의자 SIGN_CHECK = 'Y' 업데이트, 문자보내기  -- 그런일은 없다. 또는 마지막차수결재자 -- 결재완료로직이므로 상관없음
						wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_6_1");
						wxp.addVar("house_code"				, info.getSession("HOUSE_CODE"));
						wxp.addVar("company_code"			, info.getSession("COMPANY_CODE"));
						wxp.addVar("doc_type"				, doc_type	[i]);
						wxp.addVar("doc_no"					, doc_no	[i]);
						wxp.addVar("doc_seq"				, doc_seq	[i]);
						wxp.addVar("current_sign_path_seq"	, app_stage	[i]);	// 현재결재자
						sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
						int rtn_6_1 = sm.doUpdate();

					}else if("1".equals(GAP)){
						// 다음 PROCEEDING_FLAG = 'P' 와의 차이가 1 인경우 - 기존로직 유지
					  	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_6_2");
					  	wxp.addVar("house_code"				, info.getSession("HOUSE_CODE"));
						wxp.addVar("company_code"			, info.getSession("COMPANY_CODE"));
						wxp.addVar("doc_type"				, doc_type	[i]);
						wxp.addVar("doc_no"					, doc_no	[i]);
						wxp.addVar("doc_seq"				, doc_seq	[i]);
						wxp.addVar("next_sign_path_seq_p"	, Integer.parseInt(next_sign_path_seq_p));	// 다음 결재자(PROCEEDING_FLAG = 'P')
						sm	= new SepoaSQLManager(info.getSession("ID"), this,	ctx, wxp.getQuery());
						result = sm.doUpdate();

					}else {
						// 다음 PROCEEDING_FLAG = 'P' 와의 차이가 1 보다 큰경우 - 중간에 합의가 있는경우
						wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_6_3");
						wxp.addVar("house_code"				, info.getSession("HOUSE_CODE"));
						wxp.addVar("company_code"			, info.getSession("COMPANY_CODE"));
						wxp.addVar("doc_type"				, doc_type	[i]);
						wxp.addVar("doc_no"					, doc_no	[i]);
						wxp.addVar("doc_seq"				, doc_seq	[i]);
						wxp.addVar("current_sign_path_seq"	, app_stage	[i]);							// 현재결재자
						wxp.addVar("next_sign_path_seq_p"	, Integer.parseInt(next_sign_path_seq_p));	// 다음 결재자(PROCEEDING_FLAG = 'P')
						sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
						int rtn_6_3 = sm.doUpdate();

					}

					// 문자보내기
					send_mail = "Y";

				}else if("C".equals(PROCEEDING_FLAG)){
					// 2. 합의시
					if("".equals(GAP)){
						// 다음이 모두 합의인 경우 - 그럴일은 없다... 마지막은 항상 결재.
						// 아무반응 없다.
					}else {
						wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_7");
						wxp.addVar("house_code"				, info.getSession("HOUSE_CODE"));
						wxp.addVar("company_code"			, info.getSession("COMPANY_CODE"));
						wxp.addVar("doc_type"				, doc_type	[i]);
						wxp.addVar("doc_no"					, doc_no	[i]);
						wxp.addVar("doc_seq"				, doc_seq	[i]);
						wxp.addVar("next_sign_path_seq_p"	, Integer.parseInt(next_sign_path_seq_p));	// 다음 결재자(PROCEEDING_FLAG = 'P')
						sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
						String str_7 = sm.doSelect();

						SepoaFormater wf_7 = new SepoaFormater(str_7);
						String NOT_APPROVAL_CNT = wf_7.getValue("NOT_APPROVAL_CNT", 0);

						// 다음 PROCEEDING_FLAG = 'P' 밑의 차수가 모두 승인이 된경우 다음 PROCEEDING_FLAG = 'P' 의  SIGN_CHECK = 'Y' 업데이트
						if(Integer.parseInt(NOT_APPROVAL_CNT) == 0){
							wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_6_2");
							wxp.addVar("house_code"				, info.getSession("HOUSE_CODE"));
							wxp.addVar("company_code"			, info.getSession("COMPANY_CODE"));
							wxp.addVar("doc_type"				, doc_type	[i]);
							wxp.addVar("doc_no"					, doc_no	[i]);
							wxp.addVar("doc_seq"				, doc_seq	[i]);
							wxp.addVar("next_sign_path_seq_p"	, Integer.parseInt(next_sign_path_seq_p));	// 다음 결재자(PROCEEDING_FLAG = 'P')
							sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
							int rtn_6_2 = sm.doUpdate();

							// 문자보내기
							send_mail = "Y";
						}


					}

				}else {
					// 이쪽으론 절대 안옴.
				}

				if("Y".equals(send_mail)){
					// 차기결재자에게 SMS, 메일 보내기
					wxp = new SepoaXmlParser("mail/mail", "et_M30000");
					wxp.addVar("HOUSE_CODE"		, info.getSession("HOUSE_CODE"));
					wxp.addVar("COMPANY_CODE"	, info.getSession("COMPANY_CODE"));
					wxp.addVar("DOC_TYPE"		, doc_type	[i]);
					wxp.addVar("DOC_NO"			, doc_no	[i]);
					wxp.addVar("DOC_SEQ"		, doc_seq	[i]);
					sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
					String str_mail = sm.doSelect();

					SepoaFormater wf_mail = new SepoaFormater(str_mail);
					Map paramsMap = new HashMap();

					String subject	= "";
					String contents	= "";
					Configuration cfg = new sepoa.fw.cfg.Configuration();
					String system_name = new String(cfg.get("sepoa.system_name."+info.getSession("HOUSE_CODE")).getBytes("8859_1"), "euc-kr");

					String[][] TO		= new String[wf_mail.getRowCount()][];
					String[][] FROM		= new String[1][2];	// 기안자
					String MANAGER_POSITION = "";
					ArrayList SMSList = new ArrayList();

					for(int k=0; k<wf_mail.getRowCount(); k++){
						/*구매요청*/
						if("PR".equals(doc_type[i])){
							subject 	= "[검토 요청] 구매 요청서 "+ "\"" + wf_mail.getValue("SUBJECT", i) + "\"";
							contents =  "<a href='" + cfg.get("sepoa.host."+info.getSession("HOUSE_CODE"))+"' target='_blank' style='text-decoration=none;'>"+system_name+"</a>에 접속하여 검토 바랍니다.<br><br>";
							contents += "요청번호 : " + doc_no[i] + "<br>";
							contents += "요청명 : " + wf_mail.getValue("SUBJECT", i) + "<br>";
							contents += "작성자 : " + wf_mail.getValue("ADD_USER_NAME", i);
						}
						/*품의*/
						else if("EX".equals(doc_type[i])){
							subject 	= "[검토 요청] 구매 기안서 "+ "\"" + wf_mail.getValue("SUBJECT", i) + "\"";
							contents =  "<a href='" + cfg.get("sepoa.host."+info.getSession("HOUSE_CODE"))+"' target='_blank' style='text-decoration=none;'>"+system_name+"</a>에 접속하여 검토 바랍니다.<br><br>";
							contents += "품의번호 : " + doc_no[i] + "<br>";
							contents += "품의명 : " + wf_mail.getValue("SUBJECT", i) + "<br>";
							contents += "작성자 : " + wf_mail.getValue("ADD_USER_NAME", i);
						}
						/*검수요청*/
						else if("INV".equals(doc_type[i])){
							subject 	= "[검토 요청] 검수증 "+ "\"" + wf_mail.getValue("SUBJECT", i) + "\"";
							contents =  "<a href='" + cfg.get("sepoa.host."+info.getSession("HOUSE_CODE"))+"' target='_blank' style='text-decoration=none;'>"+system_name+"</a>에 접속하여 검토 바랍니다.<br><br>";
							contents += "검수번호 : " + doc_no[i] + "<br>";
							contents += "검수명 : " + wf_mail.getValue("SUBJECT", i) + "<br>";
							contents += "작성자 : " + wf_mail.getValue("ADD_USER_NAME", i);
						}
						else if("TAX".equals(doc_type[i])){
							subject 	= "[검토 요청] 세금계산서 "+ "\"" + wf_mail.getValue("SUBJECT", i) + "\"";
							contents =  "<a href='" + cfg.get("sepoa.host."+info.getSession("HOUSE_CODE"))+"' target='_blank' style='text-decoration=none;'>"+system_name+"</a>에 접속하여 검토 바랍니다.<br><br>";
							contents += "세금계산서번호 : " + doc_no[i] + "<br>";
							contents += "세금계산서명 : " + wf_mail.getValue("SUBJECT", i) + "<br>";
							contents += "작성자 : " + wf_mail.getValue("ADD_USER_NAME", i);
						}
						else if("CT".equals(doc_type[i])){
							subject 	= "[검토 요청] 계약서 "+ "\"" + wf_mail.getValue("SUBJECT", i) + "\"";
							contents =  "<a href='" + cfg.get("sepoa.host."+info.getSession("HOUSE_CODE"))+"' target='_blank' style='text-decoration=none;'>"+system_name+"</a>에 접속하여 검토 바랍니다.<br><br>";
							contents += "계약서번호 : " + doc_no[i] + "<br>";
							contents += "계약서명 : " + wf_mail.getValue("SUBJECT", i) + "<br>";
							contents += "작성자 : " + wf_mail.getValue("ADD_USER_NAME", i);
						} else {
							subject 	= "[검토 요청]  "+"\"" + wf_mail.getValue("SUBJECT", i) + "\"";
							contents =  "<a href='" + cfg.get("sepoa.host."+info.getSession("HOUSE_CODE"))+"' target='_blank' style='text-decoration=none;'>"+system_name+"</a>에 접속하여 검토 바랍니다.<br><br>";
							contents += "검토번호 : " + doc_no[i] + "<br>";
							contents += "검토명 : " + wf_mail.getValue("SUBJECT", i) + "<br>";
							contents += "작성자 : " + wf_mail.getValue("ADD_USER_NAME", i);
						}
//						subject 	= "결재문서가 수신되었습니다.";
//						contents 	= "문서명 : " +  wf_mail.getValue("SUBJECT", k) + "<BR>전자구매시스템[epro] : <a href='http://epro.ibksystem.co.kr' target='_blank' style='text-decoration=none;'>http://epro.ibksystem.co.kr/</a>";

						String[] tmep_TO = {wf_mail.getValue("EMAIL", k), wf_mail.getValue("SIGN_USER_NAME", k)};
						TO[k] = tmep_TO;
						FROM[0][0] =  wf_mail.getValue("ADD_USER_MAIL", k);
						FROM[0][1] =  wf_mail.getValue("ADD_USER_NAME", k);

						// IBKS 차기결재자가 사장님, 부사장님경우 SMS 발송한다. ==> 모든 차기결재자에게 SMS 전송
						//MANAGER_POSITION = wf_mail.getValue("MANAGER_POSITION", k);
						//if("35".equals(MANAGER_POSITION) || "40".equals(MANAGER_POSITION)){
							//SMSList.add(wf_mail.getValue("DEST_PHONE", k));
						//}
					}

					paramsMap.put("house_code"	, info.getSession("HOUSE_CODE"));
					paramsMap.put("subject"	, subject);		// 제목
					paramsMap.put("contents", contents);	// 내용
					paramsMap.put("HTMLContents", cfg.get("sepoa.mail.mailkrsimple.mailForm.path."+info.getSession("HOUSE_CODE")));	// 내용
					paramsMap.put("TO"		, TO);			// 수신자
					paramsMap.put("FROM"	, FROM);			// 보내는이

			        SepoaRemote ws_sms  	= null;
			        SepoaRemote ws_mail  = null;

					Object[] mail_args = {paramsMap};
					Object[] sms_args = new Object[1];

			        String sms_type = "";
			        String mail_type = "";

			        sms_type 	= "";
			        mail_type 	= "M30000";
			        if(SMSList.size() > 0){
			        	sms_type 	= "S30000";
			        	sms_args[0] = SMSList;
			        }


			        if(!"".equals(sms_type)){
			        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
			        }
			        if(!"".equals(mail_type)){

			        	ServiceConnector.doService(info, "mail", "NONDBJOB", mail_type, mail_args);


			        }
				}

			}

 		}catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return result;
    }

	/*
	* 메소드 : SendMail
	* 내용	 : 차기결재자 메일 보내기
	*/
	public int SendMail(String doc_no, String sign_path_seq, String	doc_type, String path)
	{
		Logger.debug.println(info.getSession("ID"),this,"SendMail(차기결재자)=====================");
		int	rtn	= 0;
		int	m=0;
		String house_code =	info.getSession("HOUSE_CODE");
		String company_code	= info.getSession("COMPANY_CODE");

		try{
			ConnectionContext ctx =	getConnectionContext();


			StringBuffer sql = new StringBuffer();

			sql.append(	"SELECT	DECODE(TP.PROCEEDING_FLAG,'C','합의요청','결재요청'),	 \n" );
			sql.append(	"		SR.EMAIL,												\n"	);
			sql.append(	"		SR.USER_NAME_LOC,										\n"	);
			sql.append(	"		LU.EMAIL,												\n"	);
			sql.append(	"		LU.USER_NAME_LOC,										\n"	);
			sql.append(	"		LU.PHONE_NO,											\n"	);
			sql.append(	"		SR.MANAGER_POSITION										\n"	);
			sql.append(	"FROM	ICOMSCTP TP, ICOMLUSR SR, ICOMLUSR LU, ICOMSCTM	TM		\n"	);
			sql.append(	"WHERE	TP.HOUSE_CODE	= '"+house_code+"'						\n"	);
			sql.append(	"  AND	TP.COMPANY_CODE	  =	'"+company_code+"'					\n"	);
			sql.append(	"  AND	TP.DOC_NO	= '"+doc_no+"'								\n"	);
			sql.append(	"  AND	TP.DOC_TYPE	= '"+doc_type+"'							\n"	);
			sql.append(	"  AND	TP.SIGN_PATH_SEQ = '"+sign_path_seq+"'					\n"	);
			sql.append(	"  AND	TP.HOUSE_CODE =	SR.HOUSE_CODE							\n"	);
			sql.append(	"  AND	TP.SIGN_USER_ID	= SR.USER_ID							\n"	);
			sql.append(	"  AND	SR.STATUS <> 'D'										\n"	);
			sql.append(	"  AND	TP.HOUSE_CODE =	TM.HOUSE_CODE							\n"	);
			sql.append(	"  AND	TP.COMPANY_CODE	= TM.COMPANY_CODE						\n"	);
			sql.append(	"  AND	TP.DOC_TYPE	= TM.DOC_TYPE								\n"	);
			sql.append(	"  AND	TP.DOC_NO =	TM.DOC_NO									\n"	);
			sql.append(	"  AND	TM.HOUSE_CODE =	LU.HOUSE_CODE							\n"	);
			sql.append(	"  AND	TM.ADD_USER_ID = LU.USER_ID								\n"	);
			sql.append(	"  AND	LU.STATUS <> 'D'										\n"	);

			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
			String rtnSel =	sm.doSelect();

			SepoaFormater wf	= new SepoaFormater(rtnSel);
			for( int i=0; i<wf.getRowCount(); i++ )
			{
				String DocName		= wf.getValue(i,0);
				String ReceiverMail	= wf.getValue(i,1);
				String ReceiverName	= wf.getValue(i,2);
				String SenderMail	= wf.getValue(i,3);
				String SenderName	= wf.getValue(i,4);
				String PhoneNo		= wf.getValue(i,5);
				String MPos			= wf.getValue(i,6);
				path = path	+ "&ReceiverName="+ReceiverName;

				//09,04,02,37만	MAIL을 보낸다.
				Logger.debug.println(info.getSession("ID"),this,"SenderMail====================="+SenderMail);
				Logger.debug.println(info.getSession("ID"),this,"SenderName====================="+SenderName);
				Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
				Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);
				Logger.debug.println(info.getSession("ID"),this,"PhoneNo====================="+PhoneNo);
				Logger.debug.println(info.getSession("ID"),this,"MPos====================="+MPos);

				if(	MPos.equals("09") || MPos.equals("04") || MPos.equals("02")	|| MPos.equals("37") )
				{
					Logger.debug.println(info.getSession("ID"),this,"임원이상한테만	나가는 메일	나가기 시작함돠------------------->>>>>");
					String [] args =  {doc_no, doc_type, DocName, SenderMail,SenderName,ReceiverMail,ReceiverName, PhoneNo,	SenderName.concat("님"), "", path};

					String serviceId = "SendMail";
					Object[] obj = { args };
					String conType = "NONDBJOB";
					String MethodName =	"mailCEO";

					SepoaOut value = null;
					SepoaRemote wr	= null;

					try
					{
						wr = new SepoaRemote( serviceId, conType, info	);
						wr.setConnection(ctx);

						value =	wr.lookup( MethodName, obj );
						Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);
						rtn	= value.status;

					}catch(	SepoaServiceException wse ) {
//						try{
							Logger.err.println("wse	= "	+ wse.getMessage());
//							Logger.err.println("message	= "	+ value.message);
//							Logger.err.println("status = " + value.status);							
//						}catch(NullPointerException ne){
//							
//						}
					}catch(Exception e)	{
//						try{
							Logger.err.println("err	= "	+ e.getMessage());
//							Logger.err.println("message	= "	+ value.message);
//							Logger.err.println("status = " + value.status);
//						}catch(NullPointerException ne){
//							
//						}
					}
					finally{
					}

				}
			}
		}catch(Exception ee	)
		{
			Logger.err.println("err	= "	+ ee.getMessage());
		}
		return rtn;
	}

	/*
	* 메소드 : SendMail_End
	* 내용	 : 결재상신자,중간결재자 메일 보내기
	*/
	public int sendmail_end(String[][] args)
	{
		Logger.debug.println(info.getSession("ID"),this,"SendMail=====================");
		int	rtn	= 0;
		int	m=0;
		String house_code =	info.getSession("HOUSE_CODE");
		String company_code	= info.getSession("COMPANY_CODE");
		String user_id = info.getSession("ID");
		String SenderMail =	info.getSession("EMAIL");
		String SenderName =	info.getSession("NAME_LOC");
		String PhoneNo	  =	info.getSession("TEL");

		try{
			ConnectionContext ctx =	getConnectionContext();

			StringBuffer sql = new StringBuffer();

			for(int	i=0; i<args.length;	i++)
			{
				String doc_no =	args[i][3].trim();
				String doc_type	= args[i][4].trim();


				sql	= new StringBuffer();
				sql.append(	"SELECT															\n"	);
				sql.append(	"		SR.EMAIL,												\n"	);
				sql.append(	"		SR.USER_NAME_LOC										\n"	);
				sql.append(	"FROM	ICOMSCTP TP, ICOMLUSR SR								\n"	);
				sql.append(	"WHERE	TP.HOUSE_CODE	= '"+house_code+"'						\n"	);
				sql.append(	"  AND	TP.COMPANY_CODE	  =	'"+company_code+"'					\n"	);
				sql.append(	"  AND	TP.DOC_NO	= '"+doc_no+"'								\n"	);
				sql.append(	"  AND	TP.DOC_TYPE	= '"+doc_type+"'							\n"	);
				sql.append(	"  AND	TP.HOUSE_CODE =	SR.HOUSE_CODE							\n"	);
				sql.append(	"  AND	TP.SIGN_USER_ID	= SR.USER_ID							\n"	);
				sql.append(	"  AND	TP.SIGN_USER_ID	<> '"+user_id+"'						\n"	);
				sql.append(	"  AND	SR.STATUS <> 'D'										\n"	);

				sql.append(	"UNION															\n"	);

				sql.append(	"SELECT															\n"	);
				sql.append(	"		SR.EMAIL,												\n"	);
				sql.append(	"		SR.USER_NAME_LOC										\n"	);
				sql.append(	"FROM	ICOMSCTM TP, ICOMLUSR SR								\n"	);
				sql.append(	"WHERE	TP.HOUSE_CODE	= '"+house_code+"'						\n"	);
				sql.append(	"  AND	TP.COMPANY_CODE	  =	'"+company_code+"'					\n"	);
				sql.append(	"  AND	TP.DOC_NO	= '"+doc_no+"'								\n"	);
				sql.append(	"  AND	TP.DOC_TYPE	= '"+doc_type+"'							\n"	);
				sql.append(	"  AND	TP.HOUSE_CODE =	SR.HOUSE_CODE							\n"	);
				sql.append(	"  AND	TP.ADD_USER_ID = SR.USER_ID							   \n" );
				sql.append(	"  AND	SR.STATUS <> 'D'										\n"	);

				SepoaSQLManager sm =	new	SepoaSQLManager(userid,this,ctx,sql.toString());
				String rtnSel =	sm.doSelect();

				SepoaFormater wf	= new SepoaFormater(rtnSel);

				for( int j=0; j<wf.getRowCount(); j++ )
				{
					String ReceiverMail	= wf.getValue(j,0);
					String ReceiverName	= wf.getValue(j,1);

					Logger.debug.println(info.getSession("ID"),this,"SenderMail====================="+SenderMail);
					Logger.debug.println(info.getSession("ID"),this,"SenderName====================="+SenderName);
					Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
					Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);
					Logger.debug.println(info.getSession("ID"),this,"PhoneNo====================="+PhoneNo);
					if(	ReceiverMail.equals("")	){
						Logger.debug.println(info.getSession("ID"),this,"ReceiverMail이	없어서 리턴합니다.====================");
						return rtn;
					}
					Logger.debug.println(info.getSession("ID"),this,"ReceiverMail이	있어서 계속	진행합니다..====================");

					String [] args1	=  {doc_no,	doc_type, "결재완료", SenderMail,SenderName,ReceiverMail,ReceiverName, PhoneNo,	SenderName.concat("님"), ""};

					String serviceId = "SendMail";
					Object[] obj = { args1 };
					String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB
					String MethodName =	"mailDomestic";				//NickName으로 연결된 Class에 정의된 Method	Name

					SepoaOut value = null;
					SepoaRemote wr	= null;

					//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
					try
					{
						wr = new SepoaRemote( serviceId, conType, info	);
						wr.setConnection(ctx);

						value =	wr.lookup( MethodName, obj );
						Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);

						rtn	= value.status;

					}catch(	SepoaServiceException wse ) {
//						try{
							Logger.err.println("wse	= "	+ wse.getMessage());
//							Logger.err.println("message	= "	+ value.message);
//							Logger.err.println("status = " + value.status);							
//						}catch(NullPointerException ne){
//							
//						}
					}catch(Exception e)	{
//						try{
							Logger.err.println("err	= "	+ e.getMessage());
//							Logger.err.println("message	= "	+ value.message);
//							Logger.err.println("status = " + value.status);							
//						}catch(NullPointerException ne){
//							
//						}
					}
					finally{
					}
				}

			}
		}catch(Exception ee	)
		{
			Logger.err.println("err	= "	+ ee.getMessage());
		}
		return rtn;
	}

    /////////////////////////////
    ///
    ///반려 메일 보내기
    ///
    /////////////////////////////
   /*
    	public int sendmail_reject(String[][] args)
	{
		Logger.debug.println(info.getSession("ID"),this,"SendMail=====================");
		int	rtn	= 0;
		int	m=0;
		String house_code =	info.getSession("HOUSE_CODE");
		String company_code	= info.getSession("COMPANY_CODE");
		String user_id = info.getSession("ID");
		String SenderMail =	info.getSession("EMAIL");
		String SenderName =	info.getSession("NAME_LOC");
		String PhoneNo	  =	info.getSession("TEL");

		try{
			ConnectionContext ctx =	getConnectionContext();

			StringBuffer sql = new StringBuffer();

			for(int	i=0; i<args.length;	i++)
			{
				String doc_no =	args[i][3].trim();
				String doc_type	= args[i][4].trim();


				sql	= new StringBuffer();
				sql.append(	"SELECT															\n"	);
				sql.append(	"		SR.EMAIL,												\n"	);
				sql.append(	"		SR.USER_NAME_LOC										\n"	);
				sql.append(	"FROM	ICOMSCTP TP, ICOMLUSR SR								\n"	);
				sql.append(	"WHERE	TP.HOUSE_CODE	= '"+house_code+"'						\n"	);
				sql.append(	"  AND	TP.COMPANY_CODE	  =	'"+company_code+"'					\n"	);
				sql.append(	"  AND	TP.DOC_NO	= '"+doc_no+"'								\n"	);
				sql.append(	"  AND	TP.DOC_TYPE	= '"+doc_type+"'							\n"	);
				sql.append(	"  AND	TP.HOUSE_CODE =	SR.HOUSE_CODE							\n"	);
				sql.append(	"  AND	TP.SIGN_USER_ID	= SR.USER_ID							\n"	);
				sql.append(	"  AND	TP.SIGN_USER_ID	<> '"+user_id+"'						\n"	);
				sql.append(	"  AND	SR.STATUS <> 'D'										\n"	);

				sql.append(	"UNION															\n"	);

				sql.append(	"SELECT															\n"	);
				sql.append(	"		SR.EMAIL,												\n"	);
				sql.append(	"		SR.USER_NAME_LOC										\n"	);
				sql.append(	"FROM	ICOMSCTM TP, ICOMLUSR SR								\n"	);
				sql.append(	"WHERE	TP.HOUSE_CODE	= '"+house_code+"'						\n"	);
				sql.append(	"  AND	TP.COMPANY_CODE	  =	'"+company_code+"'					\n"	);
				sql.append(	"  AND	TP.DOC_NO	= '"+doc_no+"'								\n"	);
				sql.append(	"  AND	TP.DOC_TYPE	= '"+doc_type+"'							\n"	);
				sql.append(	"  AND	TP.HOUSE_CODE =	SR.HOUSE_CODE							\n"	);
				sql.append(	"  AND	TP.ADD_USER_ID = SR.USER_ID							   \n" );
				sql.append(	"  AND	SR.STATUS <> 'D'										\n"	);

				SepoaSQLManager sm =	new	SepoaSQLManager(userid,this,ctx,sql.toString());
				String rtnSel =	sm.doSelect(null);

				SepoaFormater wf	= new SepoaFormater(rtnSel);

				for( int j=0; j<wf.getRowCount(); j++ )
				{
					String ReceiverMail	= wf.getValue(j,0);
					String ReceiverName	= wf.getValue(j,1);

					Logger.debug.println(info.getSession("ID"),this,"SenderMail====================="+SenderMail);
					Logger.debug.println(info.getSession("ID"),this,"SenderName====================="+SenderName);
					Logger.debug.println(info.getSession("ID"),this,"ReceiverMail====================="+ReceiverMail);
					Logger.debug.println(info.getSession("ID"),this,"ReceiverName====================="+ReceiverName);
					Logger.debug.println(info.getSession("ID"),this,"PhoneNo====================="+PhoneNo);
					if(	ReceiverMail.equals("")	){
						Logger.debug.println(info.getSession("ID"),this,"ReceiverMail이	없어서 리턴합니다.====================");
						return rtn;
					}
					Logger.debug.println(info.getSession("ID"),this,"ReceiverMail이	있어서 계속	진행합니다..====================");

					String [] args1	=  {doc_no,	doc_type, "결재완료", SenderMail,SenderName,ReceiverMail,ReceiverName, PhoneNo,	SenderName.concat("님"), ""};

					String serviceId = "SendMail";
					Object[] obj = { args1 };
					String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB
					String MethodName =	"mailDomestic";				//NickName으로 연결된 Class에 정의된 Method	Name

					SepoaOut value = null;
					SepoaRemote wr	= null;

					//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
					try
					{
						wr = new SepoaRemote( serviceId, conType, info	);
						wr.setConnection(ctx);

						value =	wr.lookup( MethodName, obj );
						Logger.debug.println(info.getSession("ID"),this,"value.status====================="+value.status);

						rtn	= value.status;

					}catch(	SepoaServiceException wse ) {
						Logger.err.println("wse	= "	+ wse.getMessage());
						Logger.err.println("message	= "	+ value.message);
						Logger.err.println("status = " + value.status);
					}catch(Exception e)	{
						Logger.err.println("err	= "	+ e.getMessage());
						Logger.err.println("message	= "	+ value.message);
						Logger.err.println("status = " + value.status);
					}
					finally{
					}
				}

			}
		}catch(Exception ee	)
		{
		}
		return rtn;
	}
	*/
	/////////////////////////////////////////
	///////////
	//////////  반려메일보내기 end
	///////////
	/////////////////////////////////////////

	public String[]	parseValue(String value,String dl) {
		String token = dl;
		if(value ==	null) return null;

		Vector v = new Vector();

		String subvalue;
		boolean	token_flag = true;
		int	start_token_count =	0;
		int	end_token_count	= 0;

		while(token_flag) {
			end_token_count	= value.indexOf(token, end_token_count);

			if(end_token_count == -1) token_flag = false;
			else {
					subvalue = value.substring(start_token_count, end_token_count);
					end_token_count	+= token.length();
					start_token_count =	end_token_count;
					v.addElement(subvalue);
				}
		}

			String[] szvalue = new String[v.size()];
			v.copyInto(szvalue);

			return szvalue;
	}


/**
 *  종료결재를 누르면 결재상태가	종료(E)로 setting 되고 결재	완료일자가 setting 되고, 결재단계 증가하고 차기결재자 아이디가.
 * (결재단계)번째 결재자로 들어가면서 초기화되고, 문서 상태도 변경(R)로	그리고 변경시간, 날짜, 변경자..	등등이 setting 됨.
 * @param args1
 * @param args2
 * @param args3
 * @param sri
 * @param doc_type
 * @return
 */

	public SepoaOut setEndApp(String[][] args1
							, String[][] args2
							, String[][] args3
							, SignResponseInfo sri
							, String doc_type){

		try	{
    		int	rtn	= -1;

    		SepoaOut	result = null;

    		ConnectionContext ctx =	getConnectionContext();

			rtn	= et_setEndApp(args1, args2, args3);

			if(rtn < 1)
				throw new Exception("UPDATE ICOMSCTM ERROR!!");

			result = setModeApp(ctx, doc_type,	sri);

			if(result.status ==	0) {
				try{
					setStatus(0);
					if(result.message == null || "".equals(result.message)){
						setMessage(msg.getMessage("0009"));					
					}else{
						setMessage(result.message);
					}
					
					Rollback();

				}catch(Exception e2) {
					Logger.err.println(info.getSession("ID"),this,e2.getMessage());
				}

			}else{
 	            setStatus(1);
	            setMessage(msg.getMessage("0005"));
				Commit();
			}

		}catch(Exception e){
			try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            setStatus(0);
            setMessage(msg.getMessage("0008"));
		}

        return getSepoaOut();
	}

	private int et_setKnttp(String[][] args1){

		int	result =-1;
 		try	{
			String rtn = "";

			String house_code =	"";
			String doc_no =	"";

			SepoaSQLManager sm =	null;

			ConnectionContext ctx =	getConnectionContext();

			for	( int i	= 0; i < args1.length; i++ )	{

				house_code 		= args1[i][0].trim();
	        	doc_no 			= args1[i][3].trim();

				StringBuffer tSQL1 = new StringBuffer();

				tSQL1.append(" SELECT	ISNULL(SALES_TYPE,'') AS SALES_TYPE 							\n");
				tSQL1.append(" FROM ICOYPRHD 								\n");
				tSQL1.append(" WHERE HOUSE_CODE	= '"+house_code+"'			\n");
				tSQL1.append(" 	AND PR_NO = '"+doc_no+"'				\n");

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	tSQL1.toString());

				rtn	= sm.doSelect();
				SepoaFormater wf1 = new SepoaFormater( rtn );
				String sales_type = wf1.getValue( 0, 0	);

				if(!sales_type.equals("A"))
				{
					result = 100;
				}
			}
		}catch(Exception e)	{
			result = -1;
			setMessage(e.getMessage());
		}
		return result;
	}

	private	int	et_setEndApp(String[][] args1, String[][] args2, String[][] args3) throws Exception {

		int	result =-1;
 		try	{
			String rtn = "";

			String house_code =	"";
			String company_code = "";
			String doc_type =	"";
			String doc_no =	"";
			String doc_seq	= "";

			String[] settype1={"S","S","S","S","S","S","S"};
			String[] settype2={"S","S","S","S","S","S","S","S","S","S"};


			SepoaSQLManager sm =	null;

			ConnectionContext ctx =	getConnectionContext();

			for	( int i	= 0; i < args1.length; i++ )	{

				house_code 		= args1[i][0].trim();
	        	company_code 	= args1[i][1].trim();
	        	doc_type 		= args1[i][2].trim();
	        	doc_no 			= args1[i][3].trim();
	        	doc_seq 		= args1[i][4].trim();

	        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

	        		wxp.addVar("house_code", house_code);
	        		wxp.addVar("company_code", company_code);
	        		wxp.addVar("doc_type", doc_type);
	        		wxp.addVar("doc_no", doc_no);
	        		wxp.addVar("doc_seq", doc_seq);

//				StringBuffer tSQL1 = new StringBuffer();
//
//				tSQL1.append(" SELECT APP_STATUS 							\n");
//				tSQL1.append(" FROM ICOMSCTM 								\n");
//				tSQL1.append(" WHERE HOUSE_CODE	= '"+house_code+"'			\n");
//				tSQL1.append(" 	AND COMPANY_CODE = '"+company_code+"'		\n");
//				tSQL1.append(" 	AND DOC_TYPE = '"+doc_type+"'				\n");
//				tSQL1.append(" 	AND DOC_NO = '"+doc_no+"'					\n");
//				tSQL1.append(" 	AND ISNULL(DOC_SEQ,0) = '"+doc_seq+"'		\n");

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp.getQuery());

				rtn	= sm.doSelect();
				SepoaFormater wf1 = new SepoaFormater( rtn );
				String approval_status = wf1.getValue( 0, 0	);

				if(!approval_status.equals("P"))
				{
					result = -1;
					setMessage(msg.getMessage("0007"));

					return result;
				}
			}

			SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
//			StringBuffer tSQL2 =	new	StringBuffer();
//
//			tSQL2.append(" UPDATE ICOMSCTM SET 			\n");
//			tSQL2.append(" 	STATUS = ? 					\n");
//			tSQL2.append(" ,	APP_STATUS = ? 				\n");
//			tSQL2.append(" WHERE HOUSE_CODE = ?  		\n");
//			tSQL2.append(" 	AND COMPANY_CODE = ?		\n");
//			tSQL2.append("  	AND DOC_TYPE = ? 			\n");
//			tSQL2.append("  	AND DOC_NO = ? 				\n");
//			tSQL2.append("  	AND ISNULL(DOC_SEQ,0) = ? 	\n");

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp1.getQuery().toString());
			result = sm.doUpdate(args2,settype1);

			wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
//			StringBuffer tSQL3 =	new	StringBuffer();
//
//			tSQL3.append(" UPDATE ICOMSCTP SET 			\n");
//			tSQL3.append(" 	SIGN_DATE = ? 				\n");
//			tSQL3.append(" ,SIGN_TIME = ?				\n");
//			tSQL3.append(" ,SIGN_REMARK = ?				\n");
//			tSQL3.append(" ,APP_STATUS = ?				\n");
//			tSQL3.append(" WHERE HOUSE_CODE	= ?  		\n");
//			tSQL3.append(" 	AND COMPANY_CODE = ?  		\n");
//			tSQL3.append("	AND DOC_TYPE = ? 			\n");
//			tSQL3.append("	AND DOC_NO = ? 				\n");
//			tSQL3.append("	AND ISNULL(DOC_SEQ,0) = ? 	\n");
//			tSQL3.append(" 	AND SIGN_PATH_SEQ = ? 		\n");

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp1.getQuery());

			result = sm.doUpdate(args3,settype2);

		}catch(Exception e)	{
			result = -1;
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception("et_setEndApp: " + e.getMessage());
		}
		return result;
	}

/**
 * 반려를 누르면 결재상태가	반려(R)로 setting 되고 문서	상태도 변경(R)로 그리고	변경시간, 날짜,	변경자.. 등등이	setting	됨.
 * @param args1
 * @param args2
 * @param args3
 * @param sri
 * @param doc_type
 * @return
 */
	public SepoaOut setRefund(String[][] args1
								, String[][] args2
								, String[][] args3
								, SignResponseInfo sri
								, String doc_type){
		Logger.debug.println(info.getSession("ID"),this,"#################123##########");

		try	{
			int	rtn	= -1;

			SepoaOut	result = null;

			ConnectionContext ctx =	getConnectionContext();
            Logger.debug.println(info.getSession("ID"),this,"doc_type0 ======================="+doc_type);

			rtn	= et_setRefund(args1, args2, args3);

			if(rtn < 1)
				throw new Exception("UPDATE ICOMSCTM ERROR");

			result = setModeApp(ctx, doc_type,	sri);

			if(result.status ==	0) {
				try{
					setStatus(0);
					setMessage(msg.getMessage("0009"));
					Rollback();

				}catch(Exception e2) {
					Logger.err.println(info.getSession("ID"),this,e2.getMessage());
				}

			}else{
 	            setStatus(1);
	            setMessage(msg.getMessage("0011"));
				Commit();
			}

		}catch(Exception e){
			try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            setStatus(0);
            setMessage(msg.getMessage("0008"));
		}

        return getSepoaOut();
	}

	private	int	et_setRefund(String[][] args1, String[][] args2, String[][] args3)	throws Exception{
		int	result =-1;
		SepoaXmlParser wxp = null;
		try	{
			String rtn = "";

			String house_code =	"";
			String company_code = "";
			String doc_type =	"";
			String doc_no =	"";
			String doc_seq	= "";

			String[] settype1={"S","S","S","S","S","S","S"};
			String[] settype2={"S","S","S","S","S","S","S","S","S","S"};


			SepoaSQLManager sm =	null;

			ConnectionContext ctx =	getConnectionContext();
			for	( int i	= 0; i < args1.length; i++ )	{

				house_code 		= args1[i][0].trim();
	        	company_code 	= args1[i][1].trim();
	        	doc_type 		= args1[i][2].trim();
	        	doc_no 			= args1[i][3].trim();
	        	doc_seq 		= args1[i][4].trim();

//	        	StringBuffer tSQL1 = new StringBuffer();
//
//				tSQL1.append(" SELECT APP_STATUS 							\n");
//				tSQL1.append(" FROM ICOMSCTM 								\n");
//				tSQL1.append(" WHERE HOUSE_CODE	= '"+house_code+"'			\n");
//				tSQL1.append(" 	AND COMPANY_CODE = '"+company_code+"'		\n");
//				tSQL1.append(" 	AND DOC_TYPE = '"+doc_type+"'				\n");
//				tSQL1.append(" 	AND DOC_NO = '"+doc_no+"'					\n");
//				tSQL1.append(" 	AND ISNULL(DOC_SEQ,0) = '"+doc_seq+"'		\n");

	        	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	        	wxp.addVar("house_code"		, house_code);
	        	wxp.addVar("company_code"	, company_code);
	        	wxp.addVar("doc_type"		, doc_type);
	        	wxp.addVar("doc_no"			, doc_no);
	        	wxp.addVar("doc_seq"		, doc_seq);

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp.getQuery());

				rtn	= sm.doSelect();
				SepoaFormater wf1 = new SepoaFormater( rtn );
				String approval_status = wf1.getValue( 0, 0	);

				if(!approval_status.equals("P"))
				{
					result = -1;
					setMessage(msg.getMessage("0010"));
					return result;
				}
			}

//			StringBuffer tSQL2 =	new	StringBuffer();
//
//			tSQL2.append(" UPDATE ICOMSCTM SET 				\n");
//			tSQL2.append(" 	STATUS = ? 						\n");
//			tSQL2.append(" ,	APP_STATUS = ? 				\n");
//			tSQL2.append(" WHERE HOUSE_CODE = ?  			\n");
//			tSQL2.append(" 	AND COMPANY_CODE = ?			\n");
//			tSQL2.append("  	AND DOC_TYPE = ? 			\n");
//			tSQL2.append("  	AND DOC_NO = ? 				\n");
//			tSQL2.append("  	AND ISNULL(DOC_SEQ,0) = ? 	\n");

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp.getQuery());
			result = sm.doUpdate(args2,settype1);

//			StringBuffer tSQL3 =	new	StringBuffer();
//
//			tSQL3.append(" UPDATE ICOMSCTP SET 			\n");
//			tSQL3.append(" 	SIGN_DATE = ? 				\n");
//			tSQL3.append(" ,SIGN_TIME = ?				\n");
//			tSQL3.append(" ,SIGN_REMARK = ?				\n");
//			tSQL3.append(" ,APP_STATUS = ?				\n");
//			tSQL3.append(" WHERE HOUSE_CODE	= ?  		\n");
//			tSQL3.append(" 	AND COMPANY_CODE = ?  		\n");
//			tSQL3.append("	AND DOC_TYPE = ? 			\n");
//			tSQL3.append("	AND DOC_NO = ? 				\n");
//			tSQL3.append("	AND ISNULL(DOC_SEQ,0) = ? 	\n");
//			//tSQL3.append(" 	AND SIGN_PATH_SEQ = ? + 1 	\n");
//			tSQL3.append(" 	AND SIGN_PATH_SEQ = ?  	    \n");
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp.getQuery());

			result = sm.doUpdate(args3,settype2);


		}catch(Exception e)	{
			result = -1;
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception("et_setEndApp: " + e.getMessage());
		}
		return result;
	}

/**
 * 종료결재나 반려된뒤에	각 운영모듈의 메소드를 불러준다.
 * @param ctx
 * @param doc_type
 * @param sri
 * @return
 * @throws Exception
 */
	private	SepoaOut	setModeApp(	ConnectionContext ctx, String doc_type,	SignResponseInfo sri) throws Exception
	{
		String[] pr_no     = sri.getDocNo();

		String[][] all_pr_no = new String[pr_no.length][1];

		for (int i = 0; i < pr_no.length; i++) {
            String Data[] = {pr_no[i]};
            all_pr_no[i] = Data;
        }

String aa = "a^b";
String ab = "ab";
int iaa = aa.indexOf("^");
int iab = ab.indexOf("^");
Logger.debug.println(info.getSession("ID"), this, "iaa..............................."+iaa);
Logger.debug.println(info.getSession("ID"), this, "iab..............................."+iab);

		SepoaApproval wa	= null;
		SepoaOut	value =	null;
		String user_id = info.getSession("ID");
		String doc_type_h =	"";
Logger.debug.println(info.getSession("ID"),this,"doc_type ======================="+doc_type);
		try	{
			if(doc_type.indexOf("^") == -1) doc_type_h =	doc_type;
			else {
				StringTokenizer	st1	= new StringTokenizer(doc_type,	"^");
				doc_type_h = st1.nextToken();
Logger.debug.println(info.getSession("ID"),this,"doc_type_h1 ======================="+doc_type_h);
			}
Logger.debug.println(info.getSession("ID"),this,"doc_type_h2 ======================="+doc_type_h);
			
			String conType = "NONDBJOB";
			String MethodName =	"Approval";
			String serviceId = doc_type_h;
			wa = new SepoaApproval( serviceId,	conType, info );
			wa.setConnection(ctx);

//			Object[] args =	{sri};
//			value =	wa.lookup( MethodName, args, info );
			Object[] args =	{sri};
			value =	wa.lookup( MethodName, args);

		}catch(Exception e)	{
			throw new Exception(e.getMessage());
		}finally{
		}

		return value;

	}


/***************************************************************************************************/
/******************************** 결재 순서, 결재 의견 조회	(결재 승인 화면	에서의 팝업	화면) ***************************************************/
/***************************************************************************************************/

/**
 * 문서형태, 문서상태, 내/외자 구분	조건을 입력하고	Query 버튼을 누르면	Data를 가져온다..(결재승인현황).
 * @param args
 * @return
 */
	public SepoaOut ViewSignPath(String[] args) {
    	try{
            String rtn = et_ViewSignPath(args);
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

	private	String et_ViewSignPath(String[] args) throws Exception {
		String rtn = null;
        ConnectionContext ctx = getConnectionContext();
//        StringBuffer sql = new StringBuffer();
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//        sql.append(" SELECT SIGN_PATH_SEQ                                                              	\n");
//        sql.append(" 	, dbo.GETUSERNAME(HOUSE_CODE, SIGN_USER_ID, 'LOC') AS SIGN_USER_NAME               	\n");
//        sql.append(" 	, SIGN_REMARK                                                                  	\n");
//        sql.append(" 	, dbo.GETICOMCODE1(HOUSE_CODE, 'M119',PROCEEDING_FLAG) AS PROCEEDING_FLAG_TEXT     	\n");
//        sql.append(" 	, dbo.GETICOMCODE1(HOUSE_CODE, 'M109', APP_STATUS) AS APP_STATUS_TEXT              	\n");
//        sql.append(" FROM ICOMSCTP                                                                     	\n");
//        sql.append(" WHERE                                                  							\n");
//        sql.append(" <OPT=F,S>         HOUSE_CODE   = ?    </OPT>         								\n");
//        sql.append(" <OPT=F,S>    AND  COMPANY_CODE = ?    </OPT>         								\n");
//        sql.append(" <OPT=F,S>    AND  DOC_TYPE       = ?    </OPT>         							\n");
//        sql.append(" <OPT=F,S>    AND  DOC_NO         = ?    </OPT>         							\n");
//        sql.append(" <OPT=F,S>    AND  DOC_SEQ        = ?    </OPT>         							\n");
//        sql.append(" ORDER BY  convert(numeric, SIGN_PATH_SEQ)               									\n");

        try {
       		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            rtn = sm.doSelect(args);
    	}catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }



/**
 * 결재자 목록 팝업.
 * @param args
 * @return
 */
	public SepoaOut	ViewSignPathMod(String[] args)
	{
		try{
            String rtn = et_ViewSignPathMod(args);
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

	private	String et_ViewSignPathMod(String[] args) throws Exception
	{
		String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//        StringBuffer sql = new StringBuffer();
//
//		sql.append(" SELECT SIGN_PATH_SEQ                                                			\n");
//		sql.append(" 	, dbo.GETICOMCODE1(HOUSE_CODE, 'M119', PROCEEDING_FLAG) AS PROCEEDING_FLAG      \n");
//		sql.append(" 	, SIGN_USER_ID                                                      		\n");
//		sql.append(" 	, dbo.GETUSERNAME(HOUSE_CODE,SIGN_USER_ID,'LOC') AS SIGN_USER_NAME      		\n");
//		sql.append(" 	, dbo.GETICOMCODE1(HOUSE_CODE, 'M109', ISNULL(APP_STATUS,'P')) AS APP_STATUS    \n");
//		sql.append(" 	, SIGN_REMARK                                                       		\n");
//		sql.append(" FROM ICOMSCTP                                                          		\n");
//		sql.append(" <OPT=F,S>WHERE HOUSE_CODE = ?      </OPT>                              		\n");
//		sql.append(" <OPT=F,S>	AND COMPANY_CODE = ?    </OPT>                              		\n");
//		sql.append(" <OPT=F,S>	AND DOC_TYPE = ?        </OPT>                              		\n");
//		sql.append(" <OPT=F,S>	AND DOC_NO = ?          </OPT>                              		\n");
//		sql.append(" <OPT=F,S>	AND DOC_SEQ = ?         </OPT>                              		\n");
//		sql.append(" ORDER BY convert(numeric, SIGN_PATH_SEQ)                                      		\n");

		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);
		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
		        throw new Exception(e.getMessage());
		    }
		    return rtn;
	}


    /**
     *  Method명     : setSCTPSave()
     *  호출 Method  : up_ICOMSCTP(), in_ICOMSCTP()
     *  Path         : 결재자 목록 - 저장
     *  JSP          : /kr/admin/basic/approval2/ap2_pp_lis7.jsp
     *  Servlet      : admin.basic.approval2.ap2_bd_lis2
     *  Description  : ICOMSCTP 에 Insert 또는 Update 한다.
     */
    public SepoaOut setSCTPSave( String[][] setInData, String[][] setUpData )
    {
        try {
            String user_id       = info.getSession("ID");

            if ( setUpData.length > 0 ) {
                int rtn_up = up_ICOMSCTP( setUpData, user_id );
                if ( rtn_up <= 0 ) {
                    throw new Exception("ICOMSCTP UPDATE Error") ;
                }
            }

            if ( setInData.length > 0 ) {
                int rtn_in = in_ICOMSCTP( setInData, user_id );
                if ( rtn_in <= 0 ) {
                    throw new Exception("ICOMSCTP INSERT Error") ;
                }
            }

            // 현재 결재자가 ICOMSCTM.next_sign_user_id 이므로 Update 할 필요는 없음 - Logic상 수정, 삭제 불가할 수 없음
//            int rtn_up = up_ICOMSCTM( setTmUpData, user_id );
//            if ( rtn_up <= 0 ) {
//                throw new Exception("ICOMSCTM UPDATE Error") ;
//            }

            Commit() ;
            setMessage(msg.getMessage("0000")) ;    //성공적으로 작업을 수행했습니다.
            setStatus(1);
        }
        catch(Exception e) {
            try {
                Rollback() ;
            }
            catch(Exception ex) { Logger.err.println(info.getSession("ID"), this, ex.getMessage()); }

            Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());
            setMessage(msg.getMessage("0002")); //수정중 에러가 발생 하였습니다.
            setStatus(0);
        }
        return getSepoaOut();
    }

    /*
     *
     */
    private int in_ICOMSCTP( String[][] setData, String user_id ) throws Exception
    {
        int rtn = -1;

        try {
            String house_code = info.getSession("HOUSE_CODE") ;

            ConnectionContext ctx = getConnectionContext();

            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" INSERT  INTO  ICOMSCTP (                                                              \n") ;
            tSQL.append("       HOUSE_CODE    , COMPANY_CODE, DOC_TYPE     , DOC_NO         , DOC_SEQ           \n") ;
            tSQL.append("     , SIGN_PATH_SEQ , SIGN_USER_ID, SIGN_POSITION, SIGN_M_POSITION, PROCEEDING_FLAG   \n") ;
            tSQL.append("     , SIGN_CHECK    , SIGN_REMARK                                                     \n") ;
//            tSQL.append("     , APP_STATUS    , SIGN_CHECK                                                      \n") ;
            tSQL.append(" )                                     \n") ;
            tSQL.append(" VALUES (                              \n") ;
            tSQL.append("       ?, ?, ?, ?, ?    \n") ;
            tSQL.append("     , ?, ?, ?, ?, 'P'                 \n") ;
//            tSQL.append("     , 'P', 'Y'                        \n") ;
            tSQL.append("     , 'Y', ?                          \n") ;
            tSQL.append(" )                                     \n") ;

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
                             "S","S","S","S","S"};
            rtn = sm.doInsert(setData, type);
        }
        catch(Exception e) {
            throw new Exception("in_ICOMSCTP:"+e.getMessage());
        }
        finally {
            //Release();
        }

        return rtn;
    }

    /*
     *
     */
    private int up_ICOMSCTP( String[][] setData, String user_id ) throws Exception
    {
        int rtn = -1;

        try {
            String house_code = info.getSession("HOUSE_CODE") ;

            ConnectionContext ctx = getConnectionContext();

            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" UPDATE  ICOMSCTP  SET             \n") ;
            tSQL.append("       SIGN_PATH_SEQ     =  ?      \n") ;
            tSQL.append("     , SIGN_USER_ID      =  ?      \n") ;
            tSQL.append("     , SIGN_POSITION     =  ?      \n") ;
            tSQL.append("     , SIGN_M_POSITION   =  ?      \n") ;
            tSQL.append("     , SIGN_REMARK       =  ?      \n") ;
            tSQL.append(" WHERE    HOUSE_CODE     =  ?      \n") ;
            tSQL.append("     AND  COMPANY_CODE   =  ?      \n") ;
            tSQL.append("     AND  DOC_TYPE       =  ?      \n") ;
            tSQL.append("     AND  DOC_NO         =  ?      \n") ;
            tSQL.append("     AND  DOC_SEQ        =  ?      \n") ;
            tSQL.append("     AND  SIGN_PATH_SEQ  =  ?      \n") ;

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
                             "S","S","S","S","S",
                             "S"};
            rtn = sm.doUpdate(setData, type);
        }
        catch(Exception e) {
            throw new Exception("up_ICOMSCTP:"+e.getMessage());
        }
        finally {
            //Release();
        }

        return rtn;
    }


    /*
     * ICOMSCTM 의 다음 결재자 Update
     * 현재 결재자가 ICOMSCTM.next_sign_user_id 이므로 Update 할 필요는 없음 - Logic상 수정, 삭제 불가할 수 없음
     */
    private int up_ICOMSCTM( String[][] setData, String user_id ) throws Exception
    {
        int rtn = -1;

        try {
            String house_code = info.getSession("HOUSE_CODE") ;

            ConnectionContext ctx = getConnectionContext();

            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" UPDATE  ICOMSCTM   SET                                                                                \n") ;
            tSQL.append("   NEXT_SIGN_USER_ID                                                                                   \n") ;
            tSQL.append("      =  ISNULL((SELECT  SIGN_USER_ID  FROM ICOMSCTP                                                   \n") ;
            tSQL.append("                 WHERE    HOUSE_CODE     =  ?    AND  COMPANY_CODE   =  ?                              \n") ;
            tSQL.append("                     AND  DOC_TYPE       =  ?    AND  DOC_NO         =  ?                              \n") ;
            tSQL.append("                     AND  DOC_SEQ        =  ?                                                          \n") ;
            tSQL.append("                     AND  SIGN_PATH_SEQ = (SELECT  MIN(SIGN_PATH_SEQ)  FROM ICOMSCTP                   \n") ;
            tSQL.append("                                           WHERE    HOUSE_CODE     =  ?     AND  COMPANY_CODE   =  ?   \n") ;
            tSQL.append("                                               AND  DOC_TYPE       =  ?     AND  DOC_NO         =  ?   \n") ;
            tSQL.append("                                               AND  DOC_SEQ        =  ?                                \n") ;
            tSQL.append("                                               AND  (APP_STATUS IS NULL  OR  APP_STATUS = 'P') )       \n") ;
            tSQL.append("                ), NEXT_SIGN_USER_ID)                                                                  \n") ;
            tSQL.append(" WHERE    HOUSE_CODE     =  ?    AND  COMPANY_CODE   =  ?                                              \n") ;
            tSQL.append("     AND  DOC_TYPE       =  ?    AND  DOC_NO         =  ?                                              \n") ;
            tSQL.append("     AND  DOC_SEQ        =  ?                                                                          \n") ;

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
                             "S","S","S","S","S",
                             "S","S","S","S","S"};
            rtn = sm.doUpdate(setData, type);
        }
        catch(Exception e) {
            throw new Exception("up_ICOMSCTM:"+e.getMessage());
        }
        finally {
            //Release();
        }

        return rtn;
    }

    /**
     *  Method명     : setSCTPDelete()
     *  호출 Method  : del_ICOMSCTP(), up_ICOMSCTP_Seq()
     *  Path         : 결재자 목록 - 삭제
     *  JSP          : /kr/admin/basic/approval2/ap2_pp_lis7.jsp
     *  Servlet      : admin.basic.approval2.ap2_bd_lis2
     *  Description  : ICOMSCTP 에 Insert 또는 Update 한다.
     */
    public SepoaOut setSCTPDelete( String[][] setDelData, String[][] setUpData )
    {
        try {
            String user_id       = info.getSession("ID");

            if ( setDelData.length > 0 ) {
                int rtn_del = del_ICOMSCTP( setDelData, user_id );
                if ( rtn_del <= 0 ) {
                    throw new Exception("ICOMSCTP DELETE Error") ;
                }
            }

            if ( setUpData.length > 0 ) {
                int rtn_up = up_ICOMSCTP_Seq( setUpData, user_id );
                if ( rtn_up <= 0 ) {
                    throw new Exception("ICOMSCTP UPDATE Error") ;
                }
            }

            // 현재 결재자가 ICOMSCTM.next_sign_user_id 이므로 Update 할 필요는 없음 - Logic상 수정, 삭제 불가할 수 없음
//            int rtn_up = up_ICOMSCTM( setTmUpData, user_id );
//            if ( rtn_up <= 0 ) {
//                throw new Exception("ICOMSCTM UPDATE Error") ;
//            }

            Commit() ;
            setMessage(msg.getMessage("0000")) ;    //성공적으로 작업을 수행했습니다.
            setStatus(1);
        }
        catch(Exception e)
        {
            try {
                Rollback() ;
            }
            catch(Exception ex) { Logger.err.println(info.getSession("ID"), this, ex.getMessage()); }

            Logger.err.println(info.getSession("ID"), this, "Exception e =" + e.getMessage());
            setMessage(msg.getMessage("0004")); //삭제중 에러가 발생 하였습니다.
            setStatus(0);
        }
        return getSepoaOut();
    }

    /*
     *
     */
    private int del_ICOMSCTP( String[][] setData, String user_id ) throws Exception
    {
        int rtn = -1;

        try {
            String house_code = info.getSession("HOUSE_CODE") ;

            ConnectionContext ctx = getConnectionContext();

            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" DELETE  FROM  ICOMSCTP            \n") ;
            tSQL.append(" WHERE    HOUSE_CODE     =  ?      \n") ;
            tSQL.append("     AND  COMPANY_CODE   =  ?      \n") ;
            tSQL.append("     AND  DOC_TYPE       =  ?      \n") ;
            tSQL.append("     AND  DOC_NO         =  ?      \n") ;
            tSQL.append("     AND  DOC_SEQ        =  ?      \n") ;
            tSQL.append("     AND  SIGN_PATH_SEQ  =  ?      \n") ;

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
                             "S"};
            rtn = sm.doUpdate(setData, type);
        }
        catch(Exception e) {
            throw new Exception("del_ICOMSCTP:"+e.getMessage());
        }
        finally {
            //Release();
        }

        return rtn;
    }

    /*
     *
     */
    private int up_ICOMSCTP_Seq( String[][] setData, String user_id ) throws Exception
    {
        int rtn = -1;

        try {
            String house_code = info.getSession("HOUSE_CODE") ;

            ConnectionContext ctx = getConnectionContext();

            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" UPDATE  ICOMSCTP  SET             \n") ;
            tSQL.append("     SIGN_PATH_SEQ     =  ?        \n") ;
            tSQL.append(" WHERE    HOUSE_CODE     =  ?      \n") ;
            tSQL.append("     AND  COMPANY_CODE   =  ?      \n") ;
            tSQL.append("     AND  DOC_TYPE       =  ?      \n") ;
            tSQL.append("     AND  DOC_NO         =  ?      \n") ;
            tSQL.append("     AND  DOC_SEQ        =  ?      \n") ;
            tSQL.append("     AND  SIGN_PATH_SEQ  =  ?      \n") ;

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
            //넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
            String[] type = {"S","S","S","S","S",
                             "S","S"};
            rtn = sm.doUpdate(setData, type);
        }
        catch(Exception e) {
            throw new Exception("up_ICOMSCTP_Seq:"+e.getMessage());
        }
        finally {
            //Release();
        }

        return rtn;
    }

	public SepoaOut getRequestMaintain(String[] args) {
    	try{
            String rtn = et_getRequestMaintain(args);
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

	private	String et_getRequestMaintain(String[] _args) throws Exception {

		int k=0;
		String house_code 		= _args[k++];
		String user_id 			= _args[k++];
		String doc_type 		= _args[k++];
		String doc_no	 		= _args[k++];
		String app_status 		= _args[k++];
		String ctrl_person_id 	= _args[k++];
		String from_date 		= _args[k++];
		String to_date 			= _args[k++];
		String subject 			= _args[k++];
		String sign_from_date 	= _args[k++];
		String sign_to_date 	= _args[k++];
		
		String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        String[] args = {
        					 house_code
        					,user_id
//        					,doc_type
        					,doc_no
        					,app_status
        					,ctrl_person_id
        					,from_date
        					,to_date
        					,subject
        					,sign_from_date
        					,sign_to_date
        				};

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("doc_type", doc_type);
		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);
		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}

	/**
	 *
	 * @param doc_type
	 * @param doc_no
	 * @param doc_seq
	 * @return
	 */
	public SepoaOut getRefApproval(String doc_type, String doc_no, String doc_seq)
	{
	    String result = null;

	    try {
	        result	= et_getRefApproval(doc_type, doc_no, doc_seq);
			setValue(result);
	        setStatus(1);
			setMessage(msg.getMessage("0000"));
	    } catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
	    }

	    return getSepoaOut();
	}

	/**
	 *
	 * @param doc_type
	 * @param doc_no
	 * @param doc_seq
	 * @return
	 * @throws Exception
	 */
	private String et_getRefApproval(String doc_type, String doc_no, String doc_seq) throws Exception {
	    String result = null;

		ConnectionContext ctx =	getConnectionContext();

		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company_code	= info.getSession("COMPANY_CODE");

		StringBuffer sql =	new	StringBuffer();

		sql.append(" SELECT                                                                                          \n");
		sql.append("      SCCC.COMPANY_CODE AS COMPANY_CODE                                                          \n");
		sql.append("     ," +getConfig("sepoa.generator.db.selfuser") +  "."+ "GETCOMPANYNAMELOC(LUSR.HOUSE_CODE,LUSR.COMPANY_CODE,LUSR.USER_TYPE) AS COMPANY_NAME \n");
 		sql.append("     ,LUSR.DEPT AS DEPT                                                                          \n");
		sql.append("     ,OGDP.NAME_LOC AS NAME_LOC                                                                  \n");
		sql.append("     ,SCCC.DOC_TYPE AS DOC_TYPE                                                                  \n");
		sql.append("     ,SCCC.DOC_NO AS DOC_NO                                                                      \n");
		sql.append("     ,SCCC.DOC_SEQ AS DOC_SEQ                                                                    \n");
		sql.append("     ,SCCC.SEQ AS SEQ                                                                            \n");
		sql.append("     ,LUSR.USER_ID AS USER_ID                                                                    \n");
		sql.append("     ,LUSR.USER_NAME_LOC AS USER_NAME_LOC                                                        \n");
		sql.append("     ,OGDP.NAME_LOC AS NAME_ENG                                                                  \n");
		sql.append("  FROM ICOMSCCC SCCC, ICOMLUSR LUSR                                                              \n");
		sql.append("       LEFT OUTER JOIN ICOMOGDP OGDP                                                             \n");
		sql.append("         ON OGDP.HOUSE_CODE = LUSR.HOUSE_CODE                                                    \n");
		sql.append("        AND OGDP.COMPANY_CODE = LUSR.COMPANY_CODE                                                \n");
		sql.append("        AND OGDP.DEPT = LUSR.DEPT                                                                \n");
		sql.append("        AND OGDP.STATUS != 'D'                                                                   \n");
//		sql.append("        AND OGDP.NAME_LOC LIKE 'CGV' + '%'                                                       \n");
		sql.append(" WHERE SCCC.HOUSE_CODE = '" + house_code + "'                                                    \n");
		sql.append("   AND SCCC.COMPANY_CODE = '" + company_code + "'                                                \n");
		sql.append("   AND SCCC.DOC_TYPE = '" + doc_type + "'                                                        \n");
		sql.append("   AND SCCC.DOC_NO = '" + doc_no + "'                                                            \n");
		sql.append("   AND SCCC.DOC_SEQ = '" + doc_seq + "'                                                          \n");
		sql.append("   AND SCCC.HOUSE_CODE = OGDP.HOUSE_CODE                                                         \n");
		sql.append("   AND SCCC.CC_USER_ID = LUSR.USER_ID                                                            \n");
		sql.append("   AND SCCC.STATUS = 'C'                                                                         \n");

		SepoaSQLManager sm =	new	SepoaSQLManager(user_id,	this, ctx, sql.toString());
		result = sm.doSelect();

		if(result == null) throw new Exception("SQLManager is null");

	    return result;
	}

	/**
	 *
	 * @param setData
	 * @return
	 */
	public SepoaOut setRefApproval(String[][] setData )
    {
        try {
            if(1 > et_setRefApproval(setData))
                throw new Exception ("setRefApproval insert error");

            Commit() ;
            setMessage(msg.getMessage("0000")) ;    //성공적으로 작업을 수행했습니다.
            setStatus(1);
        } catch(Exception e) {
            try {
                Rollback() ;
            }
            catch(Exception ex) { Logger.err.println(info.getSession("ID"), this, ex.getMessage()); }

            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setMessage(msg.getMessage("0002")); //수정중 에러가 발생 하였습니다.
            setStatus(0);
        }

        return getSepoaOut();
    }

	/**
	 *
	 * @param setData
	 * @return
	 * @throws Exception
	 */
    private int et_setRefApproval( String[][] setData) throws Exception
    {
        int rtn = -1;

        ConnectionContext ctx = getConnectionContext();

        try {
	        StringBuffer tSQL = new StringBuffer();

	        tSQL.append(" DELETE ICOMSCCC                              		\n");
	        tSQL.append("  WHERE HOUSE_CODE = '" + setData[0][0] + "'  		\n");
	        tSQL.append("    AND COMPANY_CODE = '" + setData[0][1] + "'     \n");
	        tSQL.append("    AND DOC_TYPE = '" + setData[0][2] + "'     	\n");
	        tSQL.append("    AND DOC_NO = '" + setData[0][3] + "'     		\n");
	        tSQL.append("    AND DOC_SEQ = '" + setData[0][4] + "'     		\n");

	        SepoaSQLManager rem = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());

			if (0 > rem.doInsert())
			    throw new Exception ("et_setRefApproval delete error");

	        for (int i = 0; i < setData.length; i++) {
	            tSQL = new StringBuffer();


	            tSQL.append(" INSERT INTO ICOMSCCC (                          \n");
				tSQL.append("         HOUSE_CODE                              \n");
				tSQL.append("       , COMPANY_CODE                            \n");
				tSQL.append("       , DOC_TYPE                                \n");
				tSQL.append("       , DOC_NO                                  \n");
				tSQL.append("       , DOC_SEQ                                 \n");
				tSQL.append("       , SEQ                                     \n");
				tSQL.append("       , STATUS                                  \n");
				tSQL.append("       , ADD_DATE                                \n");
				tSQL.append("       , ADD_TIME                                \n");
				tSQL.append("       , ADD_USER_ID                             \n");
				tSQL.append("       , ADD_USER_NAME_ENG                       \n");
				tSQL.append("       , ADD_USER_NAME_LOC                       \n");
				tSQL.append("       , ADD_USER_DEPT                           \n");
				tSQL.append("       , CC_USER_ID                              \n");
				tSQL.append("       , CONFIRM_DATE                            \n");
				tSQL.append("       , CONFIRM_TIME                            \n");
				tSQL.append(" )                                               \n");
				tSQL.append(" SELECT                                          \n");
				tSQL.append("        '" + setData[i][0] + "'                  \n");
				tSQL.append("       ,'" + setData[i][1] + "'                  \n");
				tSQL.append("       ,'" + setData[i][2] + "'                  \n");
				tSQL.append("       ,'" + setData[i][3] + "'                  \n");
				tSQL.append("       ,'" + setData[i][4] + "'                  \n");
				tSQL.append("       ," +getConfig("sepoa.generator.db.selfuser") +  "."+ "getCharSeq(" + (i+1) + ",6)       \n");
 				tSQL.append("       ,'C'                                      \n");
				tSQL.append("       ," +getConfig("sepoa.generator.db.selfuser") +  "."+ "dateFormat(getdate(),'YYYYMMDD')  \n");
 				tSQL.append("       ," +getConfig("sepoa.generator.db.selfuser") +  "."+ "dateFormat(getdate(),'HH24MISS')  \n");
 				tSQL.append("       ,'" + setData[i][5] + "'                  \n");
				tSQL.append("       ,'" + setData[i][6] + "'                  \n");
				tSQL.append("       ,'" + setData[i][7] + "'                  \n");
				tSQL.append("       ,'" + setData[i][8] + "'                  \n");
				tSQL.append("       ,'" + setData[i][9] + "'                  \n");
				tSQL.append("       ,NULL                                     \n");
				tSQL.append("       ,NULL                                     \n");

				SepoaSQLManager ins = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());
				rtn = ins.doInsert();
	        }
        } catch (Exception e) {
            throw new Exception (e.getMessage());
        }

        return rtn;
    }

    /**
	 *
	 * @param setData
	 * @return
	 */
	public SepoaOut updateRefApproval(String house_code, String company_code, String doc_type,
	        String doc_no, String doc_seq, String user_id)
    {
        try {
            if(1 > et_updateRefApproval(house_code, company_code, doc_type, doc_no, doc_seq, user_id))
                throw new Exception ("setRefApproval insert error");

            Commit() ;
            setMessage(msg.getMessage("0000")) ;    //성공적으로 작업을 수행했습니다.
            setStatus(1);
        } catch(Exception e) {
            try {
                Rollback() ;
            }
            catch(Exception ex) { Logger.err.println(info.getSession("ID"), this, ex.getMessage()); }

            Logger.err.println(info.getSession("ID"), this, e.getMessage());
            setMessage(msg.getMessage("0002")); //수정중 에러가 발생 하였습니다.
            setStatus(0);
        }

        return getSepoaOut();
    }

	/**
	 *
	 * @param setData
	 * @return
	 * @throws Exception
	 */
    private int et_updateRefApproval(String house_code, String company_code, String doc_type,
	        String doc_no, String doc_seq, String user_id) throws Exception
    {
        int rtn = -1;

        ConnectionContext ctx = getConnectionContext();

        try {
	        StringBuffer tSQL = new StringBuffer();

	        tSQL.append(" UPDATE ICOMSCCC                              					\n");
	        tSQL.append("    SET CONFIRM_DATE = " +getConfig("sepoa.generator.db.selfuser") +  "."+ "dateFormat(getdate(),'YYYYMMDD') \n");
 	        tSQL.append("       ,CONFIRM_TIME = " +getConfig("sepoa.generator.db.selfuser") +  "."+ "dateFormat(getdate(),'HH24MISS') \n");
 	        tSQL.append("  WHERE HOUSE_CODE = '" + house_code + "'  					\n");
	        tSQL.append("    AND COMPANY_CODE = '" + company_code + "'  				\n");
	        tSQL.append("    AND DOC_TYPE = '" + doc_type + "'     						\n");
	        tSQL.append("    AND DOC_NO = '" + doc_no + "'     							\n");
	        tSQL.append("    AND DOC_SEQ = '" + doc_seq + "'     						\n");
	        tSQL.append("    AND CC_USER_ID = '" + user_id + "'         				\n");

	        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());

			rtn = sm.doInsert();
        } catch (Exception e) {
            throw new Exception (e.getMessage());
        }

        return rtn;
    }

    /**
     *
     * @param house_code
     * @param company_code
     * @param user_id
     * @param from_date
     * @param to_date
     * @param doc_type
     * @param confirm_yn
     * @return
     */
    public SepoaOut getRefApprovalList(String house_code, String company_code, String user_id, String from_date, String to_date, String doc_type, String confirm_yn)
	{
	    String result = null;

	    try {
	        result	= et_getRefApprovalList(house_code, company_code, user_id, from_date, to_date, doc_type, confirm_yn);
			setValue(result);
	        setStatus(1);
			setMessage(msg.getMessage("0000"));
	    } catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
	    }

	    return getSepoaOut();
	}
    /**
	 *
	 * @param setData
	 * @return
	 * @throws Exception
	 */
    private String et_getRefApprovalList(String house_code, String company_code, String user_id, String from_date, String to_date, String doc_type, String confirm_yn)
    	throws Exception {
        String result = null;

        ConnectionContext ctx = getConnectionContext();

        try {
            StringBuffer tSQL = new StringBuffer();

	        tSQL.append(" SELECT                                                                                                           \n");
			tSQL.append(" 	   " +getConfig("sepoa.generator.db.selfuser") +  "."+ "GETICOMCODE1(SCTM.HOUSE_CODE,'M999',                                                                 \n");
 			tSQL.append(" 		 (CASE WHEN " +getConfig("sepoa.generator.db.selfuser") +  "."+ "CHARINDEX('^', SCTM.DOC_TYPE) = '0'                                                          \n");
 			tSQL.append(" 				THEN SCTM.DOC_TYPE ELSE SUBSTRING(SCTM.DOC_TYPE,1," +getConfig("sepoa.generator.db.selfuser") +  "."+ "CHARINDEX('^', SCTM.DOC_TYPE)-1)               \n");
 			tSQL.append(" 		 END)                                                                                                      \n");
			tSQL.append(" 	   ) AS DOC_TYPE_NM                                                                                            \n");
			tSQL.append("       ,(CASE WHEN (CASE WHEN " +getConfig("sepoa.generator.db.selfuser") +  "."+ "CHARINDEX('^', SCTM.DOC_TYPE) = '0'                                               \n");
 			tSQL.append(" 							THEN SCTM.DOC_TYPE                                                                     \n");
			tSQL.append(" 						ELSE SUBSTRING(SCTM.DOC_TYPE,1," +getConfig("sepoa.generator.db.selfuser") +  "."+ "CHARINDEX('^', SCTM.DOC_TYPE)-1) END) = 'EX'              \n");
 			tSQL.append("             	THEN " +getConfig("sepoa.generator.db.selfuser") +  "."+ "GETICOMCODE1(SCTM.HOUSE_CODE,'M150',                                                   \n");
 			tSQL.append(" 					(SELECT RFQ_TYPE FROM ICOYCNHD  WHERE HOUSE_CODE = SCTM.HOUSE_CODE  AND EXEC_NO = SCTM.DOC_NO))\n");
			tSQL.append("         	 ELSE ''                                                                                               \n");
			tSQL.append(" 	    END)  AS PLANT_TYPE                                                                                        \n");
			tSQL.append("       ,SCCC.DOC_NO                                                                                               \n");
			tSQL.append("       ,SCTM.SIGN_REMARK1 AS DOC_NAME                                                                             \n");
			tSQL.append("       ,(SELECT D.USER_NAME_LOC                                                                                   \n");
			tSQL.append("          FROM ICOMSCTP C                                                                                         \n");
			tSQL.append("           LEFT OUTER JOIN ICOMLUSR D                                                                             \n");
			tSQL.append("            ON C.HOUSE_CODE = D.HOUSE_CODE                                                                        \n");
			tSQL.append("           AND C.SIGN_USER_ID = D.USER_ID                                                                         \n");
			tSQL.append("          WHERE SCTM.HOUSE_CODE = C.HOUSE_CODE                                                                    \n");
			tSQL.append("            AND SCTM.COMPANY_CODE = C.COMPANY_CODE                                                                \n");
			tSQL.append("            AND SCTM.DOC_TYPE   = C.DOC_TYPE                                                                      \n");
			tSQL.append("            AND SCTM.DOC_SEQ    = C.DOC_SEQ                                                                       \n");
			tSQL.append("            AND SCTM.DOC_NO     = C.DOC_NO                                                                        \n");
			tSQL.append("            AND C.SIGN_PATH_SEQ = ( SELECT MAX(C.SIGN_PATH_SEQ)                                                   \n");
			tSQL.append("                                      FROM ICOMSCTP C                                                             \n");
			tSQL.append("                                     WHERE SCTM.HOUSE_CODE = C.HOUSE_CODE                                         \n");
			tSQL.append("                                       AND SCTM.COMPANY_CODE = C.COMPANY_CODE                                     \n");
			tSQL.append("                                       AND SCTM.DOC_TYPE   = C.DOC_TYPE                                           \n");
			tSQL.append("                                       AND SCTM.DOC_SEQ      = C.DOC_SEQ                                          \n");
			tSQL.append("                                       AND SCTM.DOC_NO     = C.DOC_NO  )                                          \n");
			tSQL.append("        ) AS LAST_SIGN_NAME                                                                                       \n");
			tSQL.append("       ,SCTM.ADD_USER_ID                                                                                          \n");
			tSQL.append("       ," +getConfig("sepoa.generator.db.selfuser") +  "."+ "NVL(SCCC.CONFIRM_DATE,'') AS CONFIRM_DATE                                                          \n");
 			tSQL.append("       ," +getConfig("sepoa.generator.db.selfuser") +  "."+ "NVL(SCCC.CONFIRM_TIME,'') AS CONFIRM_TIME                                                          \n");
 			tSQL.append("       ,SCCC.DOC_TYPE AS DOC_TYPE                                                                                 \n");
			tSQL.append("       ,SCCC.DOC_SEQ AS DOC_SEQ                                                                                   \n");
			tSQL.append("   FROM ICOMSCCC SCCC, ICOMSCTM SCTM                                                                              \n");
			tSQL.append("        LEFT OUTER JOIN ICOMLUSR LUSR                                                                             \n");
			tSQL.append("          ON SCTM.HOUSE_CODE = LUSR.HOUSE_CODE                                                                    \n");
			tSQL.append("         AND SCTM.ADD_USER_ID = LUSR.USER_ID                                                                      \n");
			tSQL.append("  WHERE SCCC.HOUSE_CODE = '" + house_code + "'                                                                    \n");
			tSQL.append("    AND SCCC.COMPANY_CODE = '" + company_code + "'                                                                \n");
			tSQL.append("    AND SCCC.CC_USER_ID = '" + user_id + "'                                                                       \n");
			tSQL.append("    AND SCCC.ADD_DATE BETWEEN '" + from_date + "' AND '" + to_date + "'                                           \n");
			if (doc_type != null && doc_type.trim().length() != 0)
			    tSQL.append("    AND SCCC.DOC_TYPE = '" + doc_type + "'                                                                    \n");
			if (confirm_yn.equals("Y"))
			    tSQL.append("    AND " +getConfig("sepoa.generator.db.selfuser") +  "."+ "NVL(SCCC.CONFIRM_DATE,'X') <> 'X'                                                              \n");
 			if (confirm_yn.equals("N"))
			    tSQL.append("    AND SCCC.CONFIRM_DATE IS NULL                                                                             \n");
			tSQL.append("    AND SCTM.HOUSE_CODE = SCCC.HOUSE_CODE                                                                         \n");
			tSQL.append("    AND SCTM.COMPANY_CODE = SCCC.COMPANY_CODE                                                                     \n");
			tSQL.append("    AND SCTM.DOC_TYPE = SCCC.DOC_TYPE                                                                             \n");
			tSQL.append("    AND SCTM.DOC_NO = SCCC.DOC_NO                                                                                 \n");
			tSQL.append("    AND SCTM.DOC_SEQ = SCCC.DOC_SEQ                                                                               \n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());
			result = sm.doSelect();

        } catch (Exception e) {
            Logger.debug.println(info.getSession("ID"), this, e.getMessage());
        }

        return result;
    }

/***************************************************************************************************/
/**************** 결재 순서, 결재 의견 조회	(결재 요청목록 화면	에서의 팝업	화면) *********************/
/***************************************************************************************************/

/* 문서형태, 문서상태, 내/외자 구분	조건을 입력하고	Query 버튼을 누르면	Data를 가져온다..(결재요청목록)	*/
	public SepoaOut	sctpSignRemark(String[]	args)
	{
		try{

			String user_id = info.getSession("ID");
			String rtn = null;

			rtn	= et_sctpSignRemark(user_id,  args);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));	 /*	Message를 등록한다.	*/
		}catch(Exception e){
			
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private	String et_sctpSignRemark(String	user_id,  String[] args) throws	Exception
	{
		String result =	null;
		ConnectionContext ctx =	getConnectionContext();
		try	{
			StringBuffer tSQL =	new	StringBuffer();

			tSQL.append(" select sign_path_seq,	user_name_loc, sign_remark	\n");
			tSQL.append(" from icomsctp	a, icomlusr	b						\n");
			tSQL.append(" <OPT=F,S>	where a.house_code = ?	</OPT>			\n");
			tSQL.append(" <OPT=F,S>	and	a.company_code = ? </OPT>			\n");
			tSQL.append(" <OPT=F,S>	and	doc_type =?	</OPT>					\n");
			tSQL.append(" <OPT=F,S>	and	doc_no =? </OPT>					\n");
			tSQL.append(" <OPT=F,S>	and	doc_seq	=? </OPT>					\n");
			tSQL.append(" and a.house_code = b.house_code(+)				\n");
			tSQL.append(" and a.sign_user_id = b.user_id(+)					\n");
			tSQL.append(" order	by to_number(sign_path_seq)					\n");

			SepoaSQLManager sm =	new	SepoaSQLManager(user_id,	this, ctx, tSQL.toString());
			result = sm.doSelect(args);
			if(result == null) throw new Exception("SQLManager is null");
		}catch(Exception ex) {
			throw new Exception("et_getMaintain4()"+ ex.getMessage());
		}
		return result;
	}



	/**
	 * 차기결재버튼을 눌렀을때 뜨는	Pop	up 화면에서. 결재자	지정하고 확인 누르면 DB	에 Update된다.
	 * @param args1
	 * @param args2
	 * @param args3
	 * @param doc_type
	 * @param doc_no
	 * @param app_stage
	 * @return
	 */

		public SepoaOut setInsert(String[][]	args1,
									String[][] args2,
									String[][] args3,
									String[] doc_type,
									String[] doc_no,
									String[] app_stage) {
			try {
	        	int rtn = et_setInsert(args1, args2, args3, doc_type, doc_no, app_stage);
	        	if(rtn < 1)
					throw new Exception("UPDATE ICOMSCTM ERROR");

				Commit();
				setStatus(1);
				setMessage(msg.getMessage("0000"));

			}catch(Exception e){
				try
	            {
	                Rollback();
	            }
	            catch(Exception d)
	            {
	                Logger.err.println(info.getSession("ID"),this,d.getMessage());
	            }
	            setStatus(0);
	            setMessage(msg.getMessage("0002"));
			}

	        return getSepoaOut();
	    }

		private	int	et_setInsert(String[][]	args1,
									String[][] args2,
									String[][] args3,
									String[] doc_type,
									String[] doc_no,
									String[] app_stage) throws Exception {

			int	result =-1;
			String rtn = "";
	        String[] settype1={"S","S","S","S","S","S","S","S"};
			String[] settype2={"S","S","S","S","S","S","S","S","S","S"};
			String[] settype3={"S","S","S","S","S","S","S","S","S","S","S","S"};

			ConnectionContext ctx =	getConnectionContext();
			SepoaSQLManager sm =	null;
			SepoaSQLManager sm1 = null;
			SepoaSQLManager sm2 = null;

			String DBO = getConfig("sepoa.generator.db.selfuser") +  ".";

			try	{
				/*
				for	( int i	= 0; i < args.length; i++ )	{
					String doc_type_value	= doc_type[i].trim();
					String[] cn	= null;
					if(doc_type_value.indexOf("^") > 0 ) {
						cn = parseValue(doc_type_value,"^");
						doc_type_value =	cn[0];
					}

					if(	doc_type_value.equals("POD") || doc_type_value.equals("EX")	)
					{
						String path	= "";
						if(	doc_type_value.equals("POD") )	path = "kr/dt/mail/po_bd_mail.jsp?po_no="+doc_no[i].trim();
						if(	doc_type_value.equals("EX") )	path = "kr/dt/mail/app_bd_mail.jsp?doc_no="+doc_no[i].trim();
								//doc_no,			sign_path_seq,					doc_type,
						SendMail(doc_no[i].trim(),	Integer.parseInt(app_stage[i])+2+"", doc_type[i].trim(), path);//문서번호,문서타입,차기결재자,path
					}
	 			}
	 			*/
//				StringBuffer tSQL =	new	StringBuffer();
//				StringBuffer tSQL1 = new StringBuffer();
//				StringBuffer tSQL2 = new StringBuffer();

				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

				// 차기결재자 정보 update
//				tSQL.append(" UPDATE ICOMSCTM SET 																\n");
//				tSQL.append(" 	NEXT_SIGN_USER_ID	= ?															\n");
//				tSQL.append(" , APP_STAGE	= ?	 																\n");
//				tSQL.append(" , STATUS = ? 																		\n");
//				tSQL.append(" WHERE HOUSE_CODE = ?																\n");
//				tSQL.append(" 	and COMPANY_CODE = ?															\n");
//				tSQL.append(" 	AND DOC_TYPE = ?  																\n");
//				tSQL.append(" 	AND DOC_NO = ?  																\n");
//				tSQL.append(" 	AND	ISNULL(DOC_SEQ,0) =	? 											\n");

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx,	wxp.getQuery());
				result = sm.doUpdate(args1,settype1);

				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

				//차기결재자 정보 update -  현 결재자 결재정보 update
//				tSQL1.append(" UPDATE ICOMSCTP SET 																\n");
//				tSQL1.append(" 	SIGN_DATE	= ?																	\n");
//				tSQL1.append(" , SIGN_TIME	= ?	 																\n");
//				tSQL1.append(" , SIGN_REMARK = ? 																\n");
//				tSQL1.append(" , APP_STATUS = ? 																\n");
//				tSQL1.append(" WHERE HOUSE_CODE = ?																\n");
//			  	tSQL1.append(" 	and COMPANY_CODE = ?															\n");
//			  	tSQL1.append(" 	AND DOC_TYPE = ?  																\n");
//			  	tSQL1.append(" 	AND DOC_NO = ?  																\n");
//			  	tSQL1.append(" 	AND	ISNULL(DOC_SEQ,0) =	? 											\n");
//			  	tSQL1.append(" 	AND SIGN_PATH_SEQ = ?  														\n");

			  	sm1	= new SepoaSQLManager(info.getSession("ID"), this,	ctx, wxp.getQuery());
				result = sm1.doUpdate(args2,settype2);

				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");

				// 선택한 차기결재자 정보 insert
//				tSQL2.append( " INSERT INTO ICOMSCTP(	\n " );
//				tSQL2.append( " HOUSE_CODE,             \n " );
//				tSQL2.append( " COMPANY_CODE,           \n " );
//				tSQL2.append( " DOC_TYPE,               \n " );
//				tSQL2.append( " DOC_NO,                 \n " );
//				tSQL2.append( " DOC_SEQ,                \n " );
//				tSQL2.append( " SIGN_PATH_SEQ,          \n " );
//				tSQL2.append( " PROCEEDING_FLAG,        \n " );
//				tSQL2.append( " APP_STATUS,             \n " );
//				tSQL2.append( " SIGN_CHECK,             \n " );
//				tSQL2.append( " SIGN_USER_ID,           \n " );
//				tSQL2.append( " SIGN_POSITION,          \n " );
//				tSQL2.append( " SIGN_M_POSITION        \n " );
//				tSQL2.append( " )VALUES(                \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ? + 1,                  \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?,                      \n " );
//				tSQL2.append( " ?                       \n " );
//				tSQL2.append( " )                       \n " );
			  	sm2	= new SepoaSQLManager(info.getSession("ID"), this,	ctx, wxp.getQuery());
				result = sm2.doInsert(args3,settype3);


	 		}catch(Exception e) {
	            Logger.err.println(info.getSession("ID"),this,e.getMessage());
	            throw new Exception(e.getMessage());
	        }
	        return result;
	    }


		public SepoaOut CallNONDBJOB(	ConnectionContext ctx, String serviceId, String MethodName, Object[] obj )
		{

			String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB

			SepoaOut value = null;
			SepoaRemote wr	= null;

			//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
			try
			{

				wr = new SepoaRemote( serviceId, conType, info	);
				wr.setConnection(ctx);

				value =	wr.lookup( MethodName, obj );

			}catch(	SepoaServiceException wse ) {
//				try{
					Logger.err.println("wse	= "	+ wse.getMessage());
//					Logger.err.println("message	= "	+ value.message);
//					Logger.err.println("status = " + value.status);
//				}catch(NullPointerException ne){
//					
//				}
			}catch(Exception e)	{
//				try{
					Logger.err.println("err	= "	+ e.getMessage());
//					Logger.err.println("message	= "	+ value.message);
//					Logger.err.println("status = " + value.status);					
//				}catch(NullPointerException ne){
//					
//				}
			}

			return value;
		}


		/**
		 * 결재 파일첨부 번호
		 * @param doc_no
		 * @return
		 */
		public SepoaOut getApprovalAttachNo(String doc_type, String doc_no) {
	    	try{
	            String rtn = et_getApprovalAttachNo(doc_type, doc_no);
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

		private	String et_getApprovalAttachNo(String doc_type, String doc_no) throws Exception {
			String rtn = null;
	        ConnectionContext ctx = getConnectionContext();
	        String[] args = {info.getSession("HOUSE_CODE") , doc_type , doc_no};
	        StringBuffer sql = new StringBuffer();

	        sql.append(" SELECT                                                       	\n");
	        sql.append(" ATTACH_NO														\n");
	        sql.append(" FROM ICOMSCTM                                                  \n");
	        sql.append(" WHERE                                                          \n");
	        sql.append(" <OPT=F,S>    HOUSE_CODE  =  ?         </OPT>        			\n");
	        sql.append(" <OPT=S,S>    AND DOC_TYPE = ?  	   </OPT> 					\n") ;
	        sql.append(" <OPT=S,S>    AND DOC_NO = ?           </OPT>                   \n") ;

	    try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
	        rtn = sm.doSelect(args);

		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}



		/**
		 * @param doc_no
		 * @return
		 */
		public SepoaOut getSignPath(String doc_no, String doc_type) {
	    	try{
	            String rtn = et_getSignPath(doc_no, doc_type);
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

		private	String et_getSignPath(String doc_no, String doc_type) throws Exception {
			String rtn = null;
	        ConnectionContext ctx = getConnectionContext();
	        String[] args = null;

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        	wxp.addVar("doc_no", doc_no);
	        	wxp.addVar("doc_type", doc_type);
	    try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);

		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}



		/**
		 * @param doc_no
		 * @return
		 * 합의관련 정보 조회
		 */
		public SepoaOut getSignAgree(String doc_no, String doc_type) {
	    	try{
	            String rtn = et_getSignAgree(doc_no, doc_type);
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

		private	String et_getSignAgree(String doc_no, String doc_type) throws Exception {
			String rtn = null;
	        ConnectionContext ctx = getConnectionContext();
	        String[] args = null;

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        	wxp.addVar("doc_no", doc_no);
	        	wxp.addVar("doc_type", doc_type);
	    try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);

		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}


		/**
		 * @param doc_no
		 * @return
		 * 합의관련 정보 조회
		 */
		public SepoaOut getSignAgree2(String doc_no, String doc_type, String doc_Seq) {
	    	try{
	            String rtn = et_getSignAgree2(doc_no, doc_type, doc_Seq);
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

		private	String et_getSignAgree2(String doc_no, String doc_type, String doc_seq) throws Exception {
			String rtn = null;
	        ConnectionContext ctx = getConnectionContext();
	        String[] args = null;

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        	wxp.addVar("doc_no", doc_no);
	        	wxp.addVar("doc_type", doc_type);
	        	wxp.addVar("doc_seq", doc_seq);
	    try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);

		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}


		/**
		 * @param doc_no
		 * @return
		 */
		public SepoaOut getSignPath2(String doc_no, String doc_type, String doc_seq) {
	    	try{
	            String rtn = et_getSignPath2(doc_no, doc_type, doc_seq);
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

		private	String et_getSignPath2(String doc_no, String doc_type, String doc_seq) throws Exception {
			String rtn = null;
	        ConnectionContext ctx = getConnectionContext();
	        String[] args = null;

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
        	wxp.addVar("doc_no", doc_no);
        	wxp.addVar("doc_type", doc_type);
        	wxp.addVar("doc_seq", doc_seq);
	    try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);

		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}

		/**
		 * 결재의견 가져오기
		 * @param doc_no
		 * @return
		 */
		public SepoaOut getSignOpinion(String doc_no, String doc_type) {
	    	try{
	            String rtn = et_getSignOpinion(doc_no, doc_type);
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

		private	String et_getSignOpinion(String doc_no, String doc_type) throws Exception {
			String rtn = null;
	        ConnectionContext ctx = getConnectionContext();
	        String[] args = null;
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        	wxp.addVar("doc_no", doc_no);
	        	wxp.addVar("doc_type", doc_type);

	    try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);

		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}

		/**
		 * 결재의견 가져오기 문서 시퀀스 예) 입찰차수 BID_COUNT
		 * @param doc_no
		 * @return
		 */
		public SepoaOut getSignOpinion2(String doc_no, String doc_seq, String doc_type) {
	    	try{
	            String rtn = et_getSignOpinion2(doc_no, doc_seq, doc_type);
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

		private	String et_getSignOpinion2(String doc_no, String doc_seq, String doc_type) throws Exception {
			String rtn = null;
	        ConnectionContext ctx = getConnectionContext();
	        String[] args = null;
	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        	wxp.addVar("doc_no", doc_no);
	        	wxp.addVar("doc_type", doc_type);
	        	wxp.addVar("doc_seq", doc_seq);


	    try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	        rtn = sm.doSelect(args);

		}catch(Exception e) {
	        Logger.err.println(info.getSession("ID"),this,e.getMessage());
	        throw new Exception(e.getMessage());
	    }
	    return rtn;
	}

		/**
	 * 초기메뉴순서
	 * @param doc_no
	 * @return
	 */
	public SepoaOut getMenuTitle(String house_code, String id, String menu_type) {
		try {
			String rtn = et_getMenuTitle(house_code, id, menu_type);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getMenuTitle(String house_code, String id, String menu_type)
			throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String[] args = null;

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("menu_type", menu_type);

//		stringbuffer.append(" SELECT C.CODE,P.MENU_OBJECT_CODE,P.ORDER_SEQ                          \n");
//		stringbuffer.append("   FROM                                                                \n");
//		stringbuffer.append("        (SELECT P.MODULE_TYPE,P.MENU_OBJECT_CODE,P.ORDER_SEQ           \n");
//		stringbuffer.append("           FROM ICOMMUPD P,ICOMMUHD  H                                 \n");
//		stringbuffer.append("          WHERE P.HOUSE_CODE        = H.HOUSE_CODE                     \n");
//		stringbuffer.append("            AND P.MENU_OBJECT_CODE  = H.MENU_OBJECT_CODE               \n");
//		stringbuffer.append("            AND H.USE_FLAG          = 'Y'                              \n");
//		stringbuffer.append("            AND P.HOUSE_CODE        = '" + house_code + "'             \n");
//		stringbuffer.append("            AND P.MENU_PROFILE_CODE = '" + menu_type + "') P,  \n");
//		stringbuffer.append("        (SELECT CODE,TEXT2                                             \n");
//		stringbuffer.append("           FROM ICOMCODE                                               \n");
//		stringbuffer.append("          WHERE HOUSE_CODE = '" + house_code + "'                      \n");
//		stringbuffer.append("            AND TYPE = 'M998'                                          \n");
//		stringbuffer.append("            AND CODE <> 'G') C                                         \n");
//		stringbuffer.append(" WHERE P.MODULE_TYPE       = C.CODE                                 \n");
//		stringbuffer.append("   AND P.MENU_OBJECT_CODE != 'MUO20020700003'                       \n");
//		stringbuffer.append(" ORDER BY P.ORDER_SEQ                       \n");

		try {

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


	// 결재선 변경
	public SepoaOut changeApprovalLine(String[][] deleteSCTP, String[][] insertSCTP, String[][] updateSCTM) {
		try	{

			int rtn = et_changeApprovalLine(deleteSCTP, insertSCTP, updateSCTM);

			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0014"));

		} catch(Exception e) {
			try{Rollback();}catch(Exception ee){ Logger.err.println(info.getSession("ID"),this,ee.getMessage()); }
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0015"));
		}
		return getSepoaOut();
	}

	private	int et_changeApprovalLine(String[][] deleteSCTP, String[][] insertSCTP, String[][] updateSCTM) throws Exception {
		int rtn = -1;
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser wxp	= null;
		SepoaSQLManager sm	= null;

		try{
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_deleteSCTP");
			sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type_DELETE = {"S","S","S","S","S","S"};
			rtn = sm.doDelete(deleteSCTP, type_DELETE);

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_insertSCTP");
			sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type_INSERT = { "S","S","S","S","S"
									,"S","S","S","S","S"
									,"S","S","S","S","S"
									};

			if(insertSCTP.length > 0){
				rtn = sm.doInsert(insertSCTP, type_INSERT);
			}
/*
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName() + "_updateSCTM");
			sm 	= new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			String[] type_UPDATE = {"S","S","S","S","S","S"};
        	rtn = sm.doUpdate(updateSCTM, type_UPDATE);
*/

		} catch(Exception e)	{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}

		return rtn;
	}




}
