package sepoa.fw.sms;

import java.util.ArrayList;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ParamSql;
import sepoa.fw.jtx.SepoaTransactionalResource;
import sepoa.fw.log.Logger;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaString;

public class SendSms {
	private static String SEPOA_DB_VENDOR   = CommonUtil.getConfig("sepoa.db.vendor");
	private static String SEPOA_DB_OWNER    = CommonUtil.getConfig("sepoa.db.owner") + ".";
	private static String DB_NULL_FUNCTION  = SEPOA_DB_OWNER.equals("ORACLE") ? "NVL" : "";

	public void setSmsData(ArrayList arList) throws Exception {
		SepoaTransactionalResource sepoa_tres = null;
		StringBuffer sqlsb = new StringBuffer();
		ParamSql ps;
		SmsSendVo	vo	= null;

		try
		{
			sepoa_tres = new SepoaTransactionalResource();
			sepoa_tres.getUserTransaction();
			ps = new ParamSql("SapR3Logger", sqlsb, sepoa_tres);

			for(int j = 0; j < arList.size(); j++)
			{
				vo = (SmsSendVo)arList.get( j );
				vo.setMessage(SepoaString.getSubString(vo.getMessage(), 0, 79));
				String sms_send_no = vo.getSend_user_id() + "-" + SepoaDate.getTimeStampString() + j;
				
				

				if(vo.getRecv_user_phone_no().trim().length() <= 0)
				{
					continue;
				}

				if(vo.getSend_user_phone_no().trim().length() <= 0)
				{
					Configuration configuration = new Configuration();
		            vo.setSend_user_phone_no(configuration.get("sepoa.sms.send.no"));
				}

				Configuration configuration = new Configuration();
	            String sms_send_flag = configuration.get("sepoa.sms.send.flag");
	            String sms_send_result = "Y";

	            if(sms_send_flag.equals("true"))
	            {
//	            	try
//	            	{
//		            	SmsDbServiceLocator loc = new SmsDbServiceLocator();
//			            SmsDbServiceSoap port = loc.getSmsDbServiceSoap();
//			            sms_send_result = port.sendMsg("JELWBP", vo.getRecv_user_phone_no(), vo.getSend_user_phone_no(), vo.getMessage());
//	            	} catch(Exception e)
//	            	{
//	            		e.printStackTrace();
//						Logger.debug.println("SendSMS Class", this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName()+" ERROR : " + e);
//						System.out.println(new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName() + " ERROR : " + e);
//						sms_send_result = "E";
//	            	}
	            }
	            else
	            {
	            	sms_send_result = "X";
	            }

				ps.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append(" INSERT INTO SSMSH		   \n");
				sqlsb.append(" (				   			\n");
				sqlsb.append(" SEND_NO, 				   \n");
				sqlsb.append(" SEND_USER_NAME ,			   \n");
				sqlsb.append(" SEND_USER_PHONE_NO ,		   \n");
				sqlsb.append(" RECV_USER_NAME 	,		   \n");
				sqlsb.append(" RECV_USER_PHONE_NO, 		   \n");
				sqlsb.append(" MESSAGE 			,	   \n");
				sqlsb.append(" SELLER_CODE 	,		   \n");
				sqlsb.append(" SEND_USER_ID ,			   \n");
				sqlsb.append(" SEND_DATE 	,		   \n");
				sqlsb.append(" SEND_TIME 	,		   \n");
				sqlsb.append(" SEND_COMPLETE_CODE 	,		   \n");

				if(sms_send_result.equals("Y") || sms_send_result.equals("X"))
				{
					sqlsb.append(" REAL_SEND_DATE 	,		   \n");
					sqlsb.append(" REAL_SEND_TIME 	,		   \n");
				}

				sqlsb.append(" REF_NO 		,		   \n");
				sqlsb.append(" REF_MODULE			   \n");
				sqlsb.append(" )VALUES(				   \n");
				sqlsb.append(" ?,				   \n");ps.addStringParameter(sms_send_no);
				sqlsb.append(" ?,				   \n");ps.addStringParameter(vo.getSend_user_name());
				sqlsb.append(" ?,				   \n");ps.addStringParameter(vo.getSend_user_phone_no());
				sqlsb.append(" ?,				   \n");ps.addStringParameter(vo.getRecv_user_name());
				sqlsb.append(" ?,				   \n");ps.addStringParameter(vo.getRecv_user_phone_no());
				sqlsb.append(" ?,				   \n");ps.addStringParameter(vo.getMessage());
				sqlsb.append(" ?,				   \n");ps.addStringParameter(vo.getSeller_code());
				sqlsb.append(" ?,					\n");ps.addStringParameter(vo.getSend_user_id());
				sqlsb.append(" ?,					\n");ps.addStringParameter(SepoaDate.getShortDateString());
				sqlsb.append(" ?,					\n");ps.addStringParameter(SepoaDate.getShortTimeString());
				sqlsb.append(" ?,					\n");ps.addStringParameter(sms_send_result);

				if(sms_send_result.equals("Y") || sms_send_result.equals("X"))
				{
					sqlsb.append(" ?,					\n");ps.addStringParameter(SepoaDate.getShortDateString());
					sqlsb.append(" ?,					\n");ps.addStringParameter(SepoaDate.getShortTimeString());
				}

				sqlsb.append(" ?,					\n");ps.addStringParameter(vo.getRef_no());
				sqlsb.append(" ?					\n");ps.addStringParameter(vo.getRef_module());
				sqlsb.append(" ) 					\n");

				ps.doInsert(sqlsb.toString());
			}

			sepoa_tres.getUserTransaction().commit();
		} catch(Exception e) {
			if (sepoa_tres != null) { sepoa_tres.getUserTransaction().rollback(); }
			//e.printStackTrace();
            Logger.sys.println("ALL", sqlsb, e.getMessage());
            throw new Exception(e.getMessage());
		} finally {
			if (sepoa_tres != null) { sepoa_tres.release(); }
		}
	}
}//END CLASS
