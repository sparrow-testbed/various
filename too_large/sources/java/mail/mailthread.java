package mail;

import java.util.Map;

import sepoa.fw.log.Logger;

public class MailThread extends Thread{
	Map paramsMap;
	String house_code;
	public MailThread(){

	}

	public MailThread(Map paramsMap, String house_code){
		this.paramsMap = paramsMap;
		this.house_code = house_code;
	}

	public void run() {
		try {
			
			new SendMail(paramsMap, house_code);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			Logger.err.println("MailThread: = " + e.getMessage());
		}
	}

}
