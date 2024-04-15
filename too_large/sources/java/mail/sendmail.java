
package mail;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import wise.mail.WiseMail;
import wisecommon.appcommon;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;


public class SendMail extends WiseMail
{
    public SendMail(Map paramsMap, String house_code) throws Exception{
    	super(house_code);
    	sendMail(paramsMap);
    }

    public String getByHtml(String filename) throws IOException
    {
        File file = null;
        BufferedReader in = null;
        StringWriter out = null;
        String contents = "";
        char[] buf = new char[1024];
        int len = 0;

        try
        {
            file = new File(filename);

            if(file.exists())
            {
                in = new BufferedReader(new FileReader(file));
                out = new StringWriter();

                while((len = in.read(buf, 0, buf.length)) != -1)
                {
                    out.write(buf, 0, len);
                }

                contents = out.toString();
            }
        }
        catch(Exception e)
        {
        	Logger.err.println("SendMail: = " + e.getMessage());
        }
        finally{
        	if(in != null){
        		try{
        			in.close();
        		}
        		catch(Exception e){ Logger.err.println("SendMail: = " + e.getMessage()); }
        	}
        }

        return contents;
    }

    // 원문자열을 Replace시키는 메서드 입니다.(original 원문자열, source 바꾸고 싶은 문자열, dest 바뀔문자열)
    public static String replaceString(
        String original,
        String source,
        String dest) throws Exception
    {
        StringBuffer buf = new StringBuffer(original);
        String tmp = original;

        int index = 0;

        while((index = tmp.indexOf(source, index)) != -1)
        {
            tmp = new String(buf.replace(index, index + source.length(), dest));
            buf = new StringBuffer(tmp);
            index = index + dest.length();
        }

        return tmp;
    }

    /*
     * subject		: 제목
     * contents 	: 내용
     * HTMLContents : html로 되어있는 문서를 읽어서 보낼경우 c:/입찰요청건.html
     * TO 			: 수신자	예 {{"brabo486@icompia.com", "정상현"}, {"chodaez@icompia.com", "김대형"}}
     * CC 			: 참조자	예 {{"imcyber@icompia.com", "이성우"}, {"sjcosmos@icompia.com", "최승주"}}
     * BCC 			: 비밀참조	예 {{"reghab@icompia.com", "손정훈"}, {"gitea83@icompia.com", "이은정"}}
     * attach 		: 첨부파일	{c:/첨부파일01.txt, c:/첨부파일02.txt}
     * */
//  public synchronized void sendMail(Map paramsMap) throws Exception
    public void sendMail(Map paramsMap) throws Exception
    {
    	Configuration conf = new Configuration();
    	boolean useMail = conf.getBoolean("Sepoa.mail.use");
    	boolean product_flag = conf.getBoolean("Sepoa.mail.development.flag");
    	String test_email = conf.get("Sepoa.test.email");

    	if(useMail){
    		String house_code = (String)paramsMap.get("house_code");
    		String subject 		= paramsMap.get("subject") 		== null ? "" : (String)paramsMap.get("subject");
        	String contents 	= paramsMap.get("contents") 	== null ? "" : (String)paramsMap.get("contents");
        	String HTMLContents = paramsMap.get("HTMLContents") == null ? "" : (String)paramsMap.get("HTMLContents");

        	String[][] FROM 	= paramsMap.get("FROM")		== null ? new String[0][] 	: (String[][])paramsMap.get("FROM");
        	String[][] TO 		= paramsMap.get("TO")		== null ? new String[0][] 	: (String[][])paramsMap.get("TO");
        	String[][] CC 		= paramsMap.get("CC") 		== null ? new String[0][] 	: (String[][])paramsMap.get("CC");
        	String[][] BCC 		= paramsMap.get("BCC") 		== null ? new String[0][] 	: (String[][])paramsMap.get("BCC");
        	String[] attach		= paramsMap.get("attach") 	== null ? new String[0] 	: (String[])paramsMap.get("attach");

        	// 메일주소가 없는것들은 없앤다.
        	String EMAIL = "";
    		String NAME  = "";
    		ArrayList mailArrayList = new ArrayList();

        	for(int i=0; i<TO.length; i++){
        		EMAIL = TO[i][0];
        		NAME  = TO[i][1];
        		if(EMAIL != null && !"".equals(EMAIL) && NAME != null && !"".equals(NAME)){
        			Map mailMap = new HashMap();
        			mailMap.put("EMAIL", EMAIL);
        			mailMap.put("NAME" , NAME);


        			mailArrayList.add(mailMap);
        		}
        	}

        	String[][] REAL_TO = new String[mailArrayList.size()][2];
        	for(int i=0; i<mailArrayList.size(); i++){
        		Map mailMap = (Map)mailArrayList.get(i);
        		REAL_TO[i][0] = mailMap.get("EMAIL").toString();
        		REAL_TO[i][1] = mailMap.get("NAME").toString();
        	}

        	// 메일정보가 있는건이 하나도 없는 경우
        	if(REAL_TO.length == 0){
        		return;
        	}

        	try {

        		//0. 보내는이 설정
        		if(FROM.length > 0){
        			setFrom(FROM[0][0], FROM[0][1]);
        		}

        		//1. 제목설정
        		setSubject(subject);

        		//2. 본문설정
        		String content_send = getByHtml(HTMLContents);
        		content_send = replaceString(content_send, "$HOST_NAME$", conf.get("Sepoa.host."+house_code));
        		content_send = replaceString(content_send, "$SUBJECT$", subject);
        		content_send = replaceString(content_send, "$CONTENTS$", contents);

        		setHtmlContent(content_send);

        		/*운영환경이 아닐 경우 지정된 email로 전송*/
        		if(!product_flag){
        			String mail = "";
        			StringTokenizer st = new StringTokenizer(test_email,"#");
        			int count = st.countTokens();
        			REAL_TO  = new String[count][];
        			CC  = new String[count][];
        			BCC  = new String[count][];
        			for(int i = 0; i < count ; i++){
        				mail = st.nextToken();
            			REAL_TO[i] = new String[]{mail, "TEST"};
            			CC[i] = new String[]{mail, "TEST"};
            			BCC[i] = new String[]{mail, "TEST"};
        			}
        		}

        		//3. 수신자 설정
        		addRecipients("TO", REAL_TO);

        		//4. 참조자 설정
//        		addRecipients("CC", CC);

        		//5. 비밀참조 설정
//        		addRecipients("BCC", BCC);

        		//6. 첨부파일 설정
        		for(int i=0; i<attach.length; i++){
//        			addAttach(attach[i]);
        		}

        		//7. 메일보내기
        		send();
            }
            catch(Exception e){
            	
                throw new Exception(e.getMessage());
            }
            finally{
            }
    	}

    }

}
