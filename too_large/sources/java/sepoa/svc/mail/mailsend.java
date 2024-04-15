package sepoa.svc.mail;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.mail.MailSendHistory;
import sepoa.fw.mail.MailSendVo;
import sepoa.fw.mail.SimpleMailSend;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;

public class MAILSend extends SepoaService {
	
	public MAILSend(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        setVersion("1.0.0");
    }
	
	/**
	 * mailData 정보
	 *   HOUSE_CODE String
	 *   SELLER_CODE String
	 *     			
	 * @param mailData
	 * @param ctx
	 * @param mail_type
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut create(HashMap<String, String> mailData, ConnectionContext ctx, String mail_type) throws Exception {
		Logger.debug.println(info.getSession("ID"), this, "@@@@@@@@@@ Mail Interface Service start @@@@@@@@@@");
		
        setStatus(1);
        setFlag(true);
        
        SepoaOut mail = new SepoaOut();

        Map<String, String> getInfo = null;
        
        String mailsb = null;
        String type = mail_type;
        
        try {
        	
        	if("seller_approval".equals(type)) {//메일 타입 : 업체 승인
        		getInfo = getSellerInfo(mailData, ctx);
//        		mailData.put( "HOUSE_CODE" , send_mail   );//발신인메일
//        		mailData.put( "SELLER_CODE" , send_mail   );//발신인메일
//        		mailData.put( "SEND_MAIL" , send_mail   );//발신인메일
//        		mailData.put( "RECV_MAIL" , recv_mail   );//수신인메일
//        		mailData.put( "TITLE"     , mailTitle   );//제목
//        		mailData.put( "SIGN"      , img_url     );//서명
//        		mailData.put( "SEND_ID"   , send_id     );//발신인ID
//        		mailData.put( "RECV_NAME" , recv_name   );//수신인명
//        		mailData.put( "CONTENTS0" , recv_name   );//내용
        		
        		mailsb = seller_approval_mailContents(mailData, 2).toString();
        		mailData.put( "TYPE"   , type  );
        		mailData.put( "MAIL_SB", mailsb);
        		sendMail(mailData);
        	} else {
        		Logger.debug.println(info.getSession("ID"), this, "정의된 MAIL TYPE이 없습니다.");
        	}
        			
		} catch (Exception e) {
			
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally {
			Logger.debug.println(info.getSession("ID"), this, "@@@@@@@@@@ Mail Interface Service End @@@@@@@@@@");
		}
        
        return getSepoaOut();
	}

	/**
	 * 공급업체 승인시 메일 수신자와 발신자 데이터 세팅
	 * @param mailData
	 * @param ctx
	 * @return
	 * @throws Exception
	 */
	private HashMap<String, String> getSellerInfo(HashMap<String, String> mailData,	ConnectionContext ctx) throws Exception {
		
		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
		StringBuffer sqlsb = new StringBuffer();
		
		SepoaFormater sf = null;
		
		Configuration conf = new Configuration();
		String send_mail      = conf.get("sepoa.dev.smtp.server");
		String send_id        = conf.get("sepoa.dev.smtp.user_id");
		String img_url        = conf.get("sepoa.sign.img.url");
		
		String language = info.getSession("LANGUAGE");
		String recv_mail      = null;
		String recv_name      = null;
		String house_code_txt = null;
		String mail_user_id   = null;
		String mail_user_pw   = null;
		String mailTitle      = null;
		String[] mailContents = new String[2];//이메일 본문 행의 수만큼 배열 선언
		int i = 0;
		
		try {
			
			//MAIL 발송시 필요한 정보 조회
        	ps.removeAllValue();
        	sqlsb.delete(0, sqlsb.length());
        	sqlsb.append(" SELECT /* MAIL 발송에 필요한 정보 조회 */                                        \n");
        	sqlsb.append("   GETCODETEXT2('M289', SUGL.HOUSE_CODE, '"+language+"') AS HOUSE_CODE_TXT  \n");//하우스코드
        	sqlsb.append("  ,SUPI.EMAIL                                                               \n");//담당자EMAIL
        	sqlsb.append("  ,SUPI.USER_NAME                                                           \n");//담당자명
        	sqlsb.append("  ,USMT.USER_ID                                                             \n");//ID
        	sqlsb.append("  ,USMT.PASSWORD                                                            \n");//비밀번호
        	sqlsb.append(" FROM SSUGL SUGL                                                            \n");
        	sqlsb.append(" INNER JOIN SSUPI SUPI                                                      \n");
        	sqlsb.append("  ON SUPI.HOUSE_CODE = SUGL.HOUSE_CODE                                      \n");
        	sqlsb.append("  AND SUPI.SELLER_CODE = SUGL.SELLER_CODE                                   \n");
        	sqlsb.append(" INNER JOIN SUSMT USMT                                                      \n");
        	sqlsb.append("  ON SUGL.HOUSE_CODE = USMT.HOUSE_CODE                                      \n");
        	sqlsb.append("  AND SUGL.SELLER_CODE = USMT.COMPANY_CODE                                  \n");
        	sqlsb.append(" WHERE 1 = 1                                                                \n");
        	sqlsb.append(" AND SUGL.DEL_FLAG = 'N'                                                    \n");
        	sqlsb.append(" AND SUPI.DEL_FLAG = 'N'                                                    \n");
        	sqlsb.append(" AND USMT.DEL_FLAG = 'N'                                                    \n");
        	sqlsb.append(" AND SUGL.SIGN_STATUS = 'CE'                                                \n");//승인처리된 후에 이루어지는 작업이므로 CE로 조건을 건다
        	sqlsb.append(" AND SUGL.JOB_STATUS = 'E'                                                  \n");//승인처리된 후에 이루어지는 작업이므로 E로 조건을 건다
        	sqlsb.append(" AND SUGL.SELLER_BASIC_TYPE = 'Y'                                           \n");//시스템사용업체
        	sqlsb.append(" AND SUPI.EMAIL IS NOT NULL                                                 \n");
        	sqlsb.append(ps.addFixString(" AND SUGL.HOUSE_CODE = ?                                    \n"));ps.addStringParameter( MapUtils.getString ( mailData, "HOUSE_CODE  ".trim(), "" ) );
        	sqlsb.append(ps.addFixString(" AND SUGL.SELLER_CODE = ?                                   \n"));ps.addStringParameter( MapUtils.getString ( mailData, "SELLER_CODE ".trim(), "" ) );
        	
        	sf = new SepoaFormater(ps.doSelect(sqlsb.toString()));
        	
        	recv_mail         = sf.getValue( "EMAIL"          , 0 );
        	recv_name         = sf.getValue( "USER_NAME"      , 0 );
        	house_code_txt    = sf.getValue( "HOUSE_CODE_TXT" , 0 );
    		mail_user_id      = sf.getValue( "USER_ID"        , 0 );//ID
    		mail_user_pw      = sf.getValue( "PASSWORD"       , 0 );//PASSWORD
    		
    		mailTitle         = "["+ house_code_txt +"]전자구매시스템 업체 등록 통보";
    		mailContents[i++] = "귀사의 업체등록이 완료되었습니다. ID:["+ mail_user_id +"], PASSWORD:["+ mail_user_pw +"]";
    		mailContents[i]   = "로그인 후 사용자 등록 및 Password를 변경하시기 바랍니다.";
    		img_url += "mail_gumae_sign01.jpg"; 
        	
        	if(sf.getRowCount() > 0) {
        		
        		//MAIL 발송에 필요한 정보를 맵에 넣음
        		mailData.put( "SEND_MAIL" , send_mail   );//발신인메일
        		mailData.put( "RECV_MAIL" , recv_mail   );//수신인메일
        		mailData.put( "TITLE"     , mailTitle   );//제목
        		mailData.put( "SIGN"      , img_url     );//서명
        		mailData.put( "SEND_ID"   , send_id     );//발신인ID
        		mailData.put( "RECV_NAME" , recv_name   );//수신인명
        		
        		for (int j = 0; j < mailContents.length; j++) {
        			mailData.put( "CONTENTS"+(j+1) , mailContents[j] );
				}
        		
        	}
        	
		} catch (Exception e) {
			
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());			
		}
		
		return mailData;
	}
	
	/**
	 * 업체승인 메일 본문 작성
	 * @param mailValue
	 * @param contentSize
	 * @return
	 */
	private StringBuffer seller_approval_mailContents(HashMap<String, String> mailData, int contentSize) {
		
		String HAVB = "valign=\"middle\" bgcolor=\"dbe8ed\"";
		String Style = "style=\"font-size:12px;color:2C728A;font-weight:bold;border:1px solid #1C627A\"";//선이 있음
		String ContentsStyle = "style=\"font-size:12px;color:2C728A;font-weight:bold;border:0px solid #1C627A\"";//선이 없음
		StringBuffer html_contents = new StringBuffer();
		
    	try {
    		
    		html_contents.append("<table width=\"100%\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"158cb5\" bordercolorlight=\"158cb5\" bordercolordark=\"ffffff\" style=\"font-family:Arial;font-size:10pt;\">" + "\n");
        	html_contents.append("<col width=10%/><col width=90%/>\n");
        	
        	//발신인
        	html_contents.append(" <tr>" + "\n");
        	html_contents.append("  <td  align=\"center\" valign=\"middle\" "+Style+">발신인</td>" + "\n");
        	html_contents.append("  <td  align=\"left\" valign=\"middle\" "+Style+">"+ mailData.get("SEND_MAIL") +"</td>" + "\n");
        	html_contents.append(" </tr>" + "\n");
        	
        	
        	//수신인
        	html_contents.append(" <tr>" + "\n");
        	html_contents.append("  <td  align=\"center\" valign=\"middle\" "+Style+">수신인</td>" + "\n");
        	html_contents.append("  <td  align=\"left\" valign=\"middle\" "+Style+">"+ mailData.get("RECV_MAIL") +"</td>" + "\n");
        	html_contents.append(" </tr>" + "\n");
        	
        	//메일제목
        	html_contents.append(" <tr>" + "\n");
        	html_contents.append("  <td  align=\"center\" valign=\"middle\" "+Style+">제목</td>" + "\n");
        	html_contents.append("  <td  align=\"left\" valign=\"middle\" "+Style+">"+ mailData.get("TITLE") +"</td>" + "\n");
        	html_contents.append(" </tr>" + "\n");
        	
        	//메일본문
        	html_contents.append(" <tr>" + "\n");
        	html_contents.append("  <td align=\"center\" "+HAVB+" "+Style+">본문</td>" + "\n");
        	html_contents.append("  <td "+HAVB+" "+Style+">" + "\n");
        	html_contents.append("   <table width=\"100%\" border=\"0\" cellpadding=\"1\" cellspacing=\"0\" bordercolor=\"158cb5\" bordercolorlight=\"158cb5\" bordercolordark=\"ffffff\" style=\"font-family:Arial;font-size:10pt;\">" + "\n");
        	for(int i = 1 ; i <= contentSize ; i++) {//본문의 행의 수만큼 반복
	        	html_contents.append("    <tr>" + "\n");
	        	html_contents.append("     <td valign=\"middle\" height=\"25\" "+HAVB+" "+ContentsStyle+">"+ mailData.get("CONTENTS"+i) +"</td>" + "\n");
	        	html_contents.append("    </tr>" + "\n");
        	}
        	html_contents.append("   </table><br/>" + "\n");
        	html_contents.append("  </td>" + "\n");
        	html_contents.append(" </tr>" + "\n");
        	
        	//메일서명
        	html_contents.append(" <tr>" + "\n");
        	html_contents.append("  <td colspan=\"2\" align=\"left\" valign=\"middle\" "+Style+"><br/><br/>"+"<img src="+ mailData.get("SIGN") +"></img><br/><br/></td>" + "\n");
        	html_contents.append(" </tr>" + "\n");
        	html_contents.append("</table><br/>" + "\n");
        	
    	} catch(Exception e) {
    		
    		Logger.debug.println(info.getSession("ID"), this, e.getMessage());
    	}
    	
    	return html_contents;
	}
	
	/**
	 * 메일 보내기
	 * //        		mailData.put( "HOUSE_CODE" , send_mail   );//발신인메일
//        		mailData.put( "SELLER_CODE" , send_mail   );//발신인메일
//        		mailData.put( "SEND_MAIL" , send_mail   );//발신인메일
//        		mailData.put( "RECV_MAIL" , recv_mail   );//수신인메일
//        		mailData.put( "TITLE"     , mailTitle   );//제목
//        		mailData.put( "SIGN"      , img_url     );//서명
//        		mailData.put( "SEND_ID"   , send_id     );//발신인ID
//        		mailData.put( "RECV_NAME" , recv_name   );//수신인명
//        		mailData.put( "CONTENTS0" , recv_name   );//내용
 * mailData.put( "TYPE"   , type  );
        		mailData.put( "MAIL_SB", mailsb);
	*/
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private boolean sendMail(HashMap<String, String> mailData){

    	try {
			Vector v = new Vector();
			Vector v2 = new Vector();
			
			SimpleMailSend simple = new SimpleMailSend();
			
			String mail_title = mailData.get("TITLE");
			v.addElement(JSPUtil.nullChk(mailData.get("RECV_MAIL")));
			v2.addElement(JSPUtil.nullChk(mailData.get("RECV_NAME")));
			
	    	String contents =  simple.getSimpleMailHTML(mail_title, mailData.get("MAIL_SB"));
	    	
//	    	ArrayList marList = new ArrayList();
	    	MailSendHistory msh = new MailSendHistory();
	    	MailSendVo vo = new MailSendVo();
	    	
	    	vo.setContents(contents);
	    	
//	    	vo.setDoc_no(mailData.get("DOC_NO"));
	    	vo.setDoc_type(mailData.get("TYPE"));
	    	
	    	vo.setM_to_values(v);
	    	vo.setM_to_name_values(v2);
	    	
	    	vo.setSender_addr(mailData.get("SEND_MAIL"));
//	    	vo.setSender_id(mailData.get("SEND_ID"));
//	    	vo.setSender_name(mailData.get("SEND_NAME"));
	    	vo.setSubject(mail_title);
//	    	vo.setAttachmentList(marList);
	    	
    		msh.setMailSendHistory(vo);
    		return true;
		} catch (Exception e) {
			
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			return false;
		}
	}
}
