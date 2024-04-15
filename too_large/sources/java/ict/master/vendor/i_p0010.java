/**
===========================================================================================================
FUNCTION NAME        	화면명              DESCRIPTION
===========================================================================================================

setInsert_icomvngl		업체생성        	생성
setUpdate_icomvngl		업체수정        	수정
getDis_icomvngl			업체생성/업체수정  	조회
existVendorInfo			업체생성/업체수정  	담당자정보,은행정보 등록/수정시 check logic



 **/

package ict.master.vendor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import mail.mail;

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
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sms.SMS;
import wisecommon.SignRequestInfo;


public class I_p0010 extends SepoaService {
	Message msg = new Message(info, "STDCOMM");

	public I_p0010(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}

	/* Display _icomvngl */
	/* ICT 사용 */
	public SepoaOut getDis_icomvngl(String[] args, String mode) {

		try {
			String user_id = info.getSession("ID");
			String rtn = null;

			rtn = getDis_icomvngl(args, user_id, mode);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	/* 수정, 상세정보에 업체정보를 조회한다. */
	/* ICT 사용 */
	private String getDis_icomvngl(String[] args, String user_id, String mode)
			throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("company_code", company_code);
			wxp.addVar("mode", mode);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL.toString()
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("getDis_icomvngl:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}
	
	/* Save icomvngl INI 업체 생성 */
	/* ICT 사용 */
	public SepoaOut setInsert_icomvngl_j(String[][] args_vngl,
			String[][] args_addr, String vendor_code, String[][] args_vncp) {
		try {
			// Header Insert
			String status = "C";
			String add_time = SepoaDate.getShortTimeString();

			String rtn = et_setInsert_icomvngl_j(args_vngl, args_addr, vendor_code, args_vncp);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setValue(e.getMessage().trim());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private String et_setInsert_icomvngl_j(String[][] args_vngl, String[][] args_addr, String vendor_code, String[][] args_vncp) throws Exception, DBOpenException {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
		SepoaFormater             wf           = null;
		String                    id           = info.getSession("ID");
		String VNGL_SIGN = "";		
		
		try {
			Map map = new HashMap();
			map.put("house_code  ".trim(), "000" );
			map.put("vendor_code ".trim(), vendor_code );
						
			sxp = new SepoaXmlParser(this, "et_chkVnglSign");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 		 
            wf = new SepoaFormater(ssm.doSelect(map));
            VNGL_SIGN = wf.getValue(0,0);            
            if(VNGL_SIGN.equals("Y")){
            	throw new Exception("이미 신규가입 신청을 하였습니다.");
            }
			
			
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setInsert_icomvngl_vngl_j");
			
			wxp.addVar("vendor_code", vendor_code);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());// tSQL.toString());

			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] setType = {
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S",	"S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S" };

			rtn = sm.doInsert(args_vngl, setType);

			if (rtn < 0)
				throw new Exception("SQL Manager is Null");

			SepoaXmlParser wxp1 = new SepoaXmlParser(this, "et_setInsert_icomvngl_addr_j");

			//args_addr[0][9] = args_vngl[0][49];

			String[] setType2 = {
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S"};

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp1.getQuery());// tSQL.toString());
			rtn = sm.doInsert(args_addr, setType2);

			if (rtn < 0)
				throw new Exception("SQL Manager is Null");
			
			
			// 영업담당자 제조사
			SepoaXmlParser wxp2 = new SepoaXmlParser(this, "et_setInsert_icomvncp_j");
			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp2.getQuery());// tSQL.toString());

			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] setType3 = {
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S",	"S",
					"S" };

			rtn = sm.doInsert(args_vncp, setType3);

			if (rtn < 0)
				throw new Exception("SQL Manager is Null");

			Commit();

		} catch (Exception e) {
			Rollback();
			throw new Exception(e.getMessage());
		}

		return vendor_code; // 사업자 등록번호 리턴
	}

	/* Save icomvngl INI 업체 생성 */
	/* ICT 사용 */
	public SepoaOut setInsert_icomvngl(String[][] args_vngl,
			String[][] args_addr, String vendor_code) {
		try {
			// Header Insert
			String status = "C";
			String add_time = SepoaDate.getShortTimeString();

			String rtn = et_setInsert_icomvngl(args_vngl, args_addr, vendor_code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setValue(e.getMessage().trim());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private String et_setInsert_icomvngl(String[][] args_vngl, String[][] args_addr, String vendor_code) throws Exception, DBOpenException {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setInsert_icomvngl_vngl");
			
			wxp.addVar("vendor_code", vendor_code);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());// tSQL.toString());

			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] setType = {
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S",	"S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S"};

			rtn = sm.doInsert(args_vngl, setType);

			if (rtn == -1)
				throw new Exception("SQL Manager is Null");

			SepoaXmlParser wxp1 = new SepoaXmlParser(this, "et_setInsert_icomvngl_addr");

			args_addr[0][9] = args_vngl[0][48];

			String[] setType2 = {
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S",
					"S"};

			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp1.getQuery());// tSQL.toString());
			rtn = sm.doInsert(args_addr, setType2);

			if (rtn == -1)
				throw new Exception("SQL Manager is Null");

			Commit();

		} catch (Exception e) {
			Rollback();
			throw new Exception(e.getMessage());
		}

		return vendor_code; // 사업자 등록번호 리턴
	}

	/* ICT 사용 : 업체정보 수정 */

	public SepoaOut setUpdate_vngl_j(String[][] args_vngl, String[][] args_addr, String vendor_code, String[][] args_vngl_old, String[][] args_vncp) {

		String user_id = info.getSession("ID");
		try {
			if (args_vngl[0][0].equals("admin_upd")) {
				SepoaOut rtn = et_setUpdate_vngl_adm_j(args_vngl, vendor_code);// 업체에서
																			// 밴더수정시...
			} else {
				SepoaOut rtn = et_setUpdate_vngl_j(args_vngl, args_addr, vendor_code, args_vngl_old, args_vncp);
			}
			setValue(String.valueOf(vendor_code));
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
			setValue(e.getMessage().trim());
			setStatus(0);
			setMessage(msg.getMessage("0002"));
		}
		return getSepoaOut();
	}
	
	/**
	 * 구매사에서 업체수정시(제조사)
	 * 
	 * @Method Name : et_setUpdate_vngl_adm
	 * @작성일 : 2008. 12. 26
	 * @작성자 : wooman.choi
	 * @변경이력 : 조숙향
	 * @Method 설명 :
	 * @param args_vngl
	 * @param vendor_code
	 * @return
	 */
	private SepoaOut et_setUpdate_vngl_adm_j(String[][] args_vngl,
			String vendor_code) throws Exception, DBOpenException {
		int rtn = -1;
		String change_date = SepoaDate.getShortDateString();
		String change_time = SepoaDate.getShortTimeString();
		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");

		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("bank_code", args_vngl[0][1]);
			wxp.addVar("AKONT", args_vngl[0][2]);
			wxp.addVar("ZTERM", args_vngl[0][3]);
			wxp.addVar("ZWELS", args_vngl[0][4]);
			wxp.addVar("CHANGE_USER_ID", user_id);
			wxp.addVar("CHANGE_DATE", change_date);
			wxp.addVar("CHANGE_TIME", change_time);
			wxp.addVar("HOUSE_CODE", house_code);
			wxp.addVar("VENDOR_CODE", vendor_code);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());// .toString());
			rtn = sm.doUpdate((String[][])null, null);

			if (rtn == -1)
				throw new Exception("SQL Manager is Null");
			
			Map<String, String> smsParam = new HashMap<String, String>();
			
		    smsParam.put("HOUSE_CODE",  house_code);
		    smsParam.put("VENDOR_CODE", vendor_code);
			
			new SMS("NONDBJOB", info).rg2Process_ICT(ctx, smsParam);
			new mail("NONDBJOB", info).rg2Process(ctx, smsParam);
			/*
			 * String p_flag = "U"; String p_vendor_code = vendor_code;
			 * if(!p_vendor_code.substring(0, 2).equals("VM")){ Object[] obj =
			 * {p_flag,p_vendor_code}; SepoaOut value = CallNONDBJOB( ctx,
			 * "VendorMaster", "sendSCI", obj);
			 * 
			 * if(value.status == 0) throw new Exception(value.message); }
			 */
			Commit();

			setStatus(1);
			setMessage("승인되었습니다."); /* Message를 등록한다. */
		} catch (Exception e) {
			Rollback();
			throw new Exception(e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 업체정보 수정(제조사) */
	private SepoaOut et_setUpdate_vngl_j(String[][] args_vngl,
			String[][] args_addr, String vendor_code, String[][] args_vngl_old, String[][] args_vncp)
			throws Exception, DBOpenException {
		int rtn = -1;
		String change_date = SepoaDate.getShortDateString();
		String change_time = SepoaDate.getShortTimeString();
		String user_id = info.getSession("ID");

		ConnectionContext ctx = getConnectionContext();

		try {
			String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "N", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };
			String[] setType2 = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S"};
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setUpdate_vngl_vngl_j");
			wxp.addVar("user_id", user_id);
			wxp.addVar("change_date", change_date);
			wxp.addVar("change_time", change_time);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL.toString());

			rtn = sm.doUpdate(args_vngl, setType);
			if (rtn < 0)
				throw new Exception("SQL Manager is Null");

			args_addr[0][6] = args_vngl[0][40];
			
			SepoaXmlParser wxp1 = new SepoaXmlParser(this, "et_setUpdate_vngl_addr_j");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp1.getQuery());// tSQL.toString());
			rtn = sm.doUpdate(args_addr, setType2);
			if (rtn < 0)
				throw new Exception("SQL Manager is Null");
			
			SepoaXmlParser wxp11 = new SepoaXmlParser(this, "et_setUpdate_vngl_addr2_j");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp11.getQuery());// tSQL.toString());
			rtn = sm.doUpdate(args_addr, setType2);
			if (rtn < 0)
				throw new Exception("SQL Manager is Null");
			
			// 영업담당자 제조사
			SepoaXmlParser wxp2 = new SepoaXmlParser(this, "et_setUpdate_icomvncp_j");			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp2.getQuery());// tSQL.toString());
			// 넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
			String[] setType3 = {
					"S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S"};
			rtn = sm.doUpdate(args_vncp, setType3);
			if (rtn < 0)
				throw new Exception("SQL Manager is Null");
			
			
			StringBuffer sb = new StringBuffer();

			if (!args_vngl[0][0].equals(args_vngl_old[0][0])) {
				sb.append("회사명 ");
			}
			if (!args_vngl[0][7].equals(args_vngl_old[0][1])) {
				sb.append("업태 ");
			}
			if (!args_vngl[0][8].equals(args_vngl_old[0][2])) {
				sb.append("업종 ");
			}
			if (!args_vngl[0][12].equals(args_vngl_old[0][5])) {
				sb.append("작성자부서 ");
			}
			if (!args_vngl[0][13].equals(args_vngl_old[0][6])) {
				sb.append("작성자성명 ");
			}
			if (!args_vngl[0][21].equals(args_vngl_old[0][10])) {
				sb.append("거래은행 ");
			}
			if (!args_vngl[0][22].equals(args_vngl_old[0][11])) {
				sb.append("예금주 ");
			}
			if (!args_vngl[0][23].equals(args_vngl_old[0][12])) {
				sb.append("계좌번호 ");
			}
			if (!args_vngl[0][27].equals(args_vngl_old[0][13])) {
				sb.append("법인등록번호 ");
			}
			if (!args_addr[0][5].equals(args_vngl_old[0][3])) {
				sb.append("대표자명 ");
			}
			if (!args_addr[0][1].equals(args_vngl_old[0][4])) {
				sb.append("전화번호 ");
			}
			if (!args_addr[0][2].equals(args_vngl_old[0][9])) {
				sb.append("SMS 수신번호 ");
			}
			if (!args_vngl[0][39].equals(args_vngl_old[0][7])) {
				sb.append("작성자 연락처 ");
			}
			if (!args_vngl[0][40].equals(args_vngl_old[0][8])) {
				sb.append("작성자 이메일 ");
			}

			String change = sb.toString();

			

//			Object[] mail_args = { change, args_vngl[0][0] };
//			String mail_type = "M00015";
//
//			if (!"".equals(mail_type) && !change.equals("")) {
//				ServiceConnector.doService(info, "mail", "CONNECTION",
//						mail_type, mail_args);
//			}

			if (rtn == -1)
				throw new Exception("SQL Manager is Null");
			
			Map<String, String> smsParam = new HashMap<String, String>();
			
		    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
		    smsParam.put("VENDOR_CODE", vendor_code);
			
			new SMS("NONDBJOB", info).rg2Process_ICT(ctx, smsParam);
			new mail("NONDBJOB", info).rg2Process(ctx, smsParam);
			/*
			 * String p_flag = "U"; String p_vendor_code = args_vngl[0][35];
			 * if(!p_vendor_code.substring(0, 2).equals("VM")){ Object[] obj =
			 * {p_flag,p_vendor_code}; SepoaOut value = CallNONDBJOB( ctx,
			 * "VendorMaster", "sendSCI", obj);
			 * 
			 * if(value.status == 0) throw new Exception(value.message); }
			 */
			Commit();

			setStatus(1);
			setMessage("승인되었습니다."); /* Message를 등록한다. */
		} catch (Exception e) {
			Rollback();
			throw new Exception(e.getMessage());
		}
		return getSepoaOut();
	}

	
	
	/* ICT 사용 : 업체정보 수정 */

	public SepoaOut setUpdate_vngl(String[][] args_vngl, String[][] args_addr, String vendor_code, String[][] args_vngl_old) {

		String user_id = info.getSession("ID");
		try {
			if (args_vngl[0][0].equals("admin_upd")) {
				SepoaOut rtn = et_setUpdate_vngl_adm(args_vngl, vendor_code);// 업체에서
																			// 밴더수정시...
			} else {
				SepoaOut rtn = et_setUpdate_vngl(args_vngl, args_addr, vendor_code, args_vngl_old);
			}
			setValue(String.valueOf(vendor_code));
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
			setValue(e.getMessage().trim());
			setStatus(0);
			setMessage(msg.getMessage("0002"));
		}
		return getSepoaOut();
	}

	/**
	 * 구매사에서 업체수정시...
	 * 
	 * @Method Name : et_setUpdate_vngl_adm
	 * @작성일 : 2008. 12. 26
	 * @작성자 : wooman.choi
	 * @변경이력 : 조숙향
	 * @Method 설명 :
	 * @param args_vngl
	 * @param vendor_code
	 * @return
	 */
	private SepoaOut et_setUpdate_vngl_adm(String[][] args_vngl,
			String vendor_code) throws Exception, DBOpenException {
		int rtn = -1;
		String change_date = SepoaDate.getShortDateString();
		String change_time = SepoaDate.getShortTimeString();
		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");

		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("bank_code", args_vngl[0][1]);
			wxp.addVar("AKONT", args_vngl[0][2]);
			wxp.addVar("ZTERM", args_vngl[0][3]);
			wxp.addVar("ZWELS", args_vngl[0][4]);
			wxp.addVar("CHANGE_USER_ID", user_id);
			wxp.addVar("CHANGE_DATE", change_date);
			wxp.addVar("CHANGE_TIME", change_time);
			wxp.addVar("HOUSE_CODE", house_code);
			wxp.addVar("VENDOR_CODE", vendor_code);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());// .toString());
			rtn = sm.doUpdate((String[][])null, null);

			if (rtn == -1)
				throw new Exception("SQL Manager is Null");
			
			Map<String, String> smsParam = new HashMap<String, String>();
			
		    smsParam.put("HOUSE_CODE",  house_code);
		    smsParam.put("VENDOR_CODE", vendor_code);
			
			new SMS("NONDBJOB", info).rg2Process_ICT(ctx, smsParam);
			new mail("NONDBJOB", info).rg2Process(ctx, smsParam);
			/*
			 * String p_flag = "U"; String p_vendor_code = vendor_code;
			 * if(!p_vendor_code.substring(0, 2).equals("VM")){ Object[] obj =
			 * {p_flag,p_vendor_code}; SepoaOut value = CallNONDBJOB( ctx,
			 * "VendorMaster", "sendSCI", obj);
			 * 
			 * if(value.status == 0) throw new Exception(value.message); }
			 */
			Commit();

			setStatus(1);
			setMessage("승인되었습니다."); /* Message를 등록한다. */
		} catch (Exception e) {
			Rollback();
			throw new Exception(e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 업체정보 수정 */
	private SepoaOut et_setUpdate_vngl(String[][] args_vngl,
			String[][] args_addr, String vendor_code, String[][] args_vngl_old)
			throws Exception, DBOpenException {
		int rtn = -1;
		String change_date = SepoaDate.getShortDateString();
		String change_time = SepoaDate.getShortTimeString();
		String user_id = info.getSession("ID");

		ConnectionContext ctx = getConnectionContext();

		try {
			String[] setType = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "N", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };
			String[] setType2 = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S", "S" };
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setUpdate_vngl_vngl");
			wxp.addVar("user_id", user_id);
			wxp.addVar("change_date", change_date);
			wxp.addVar("change_time", change_time);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL.toString());

			rtn = sm.doUpdate(args_vngl, setType);

			args_addr[0][6] = args_vngl[0][40];
			
			SepoaXmlParser wxp1 = new SepoaXmlParser(this, "et_setUpdate_vngl_addr");
			sm = new SepoaSQLManager(user_id, this, ctx, wxp1.getQuery());// tSQL.toString());
			rtn = sm.doUpdate(args_addr, setType2);

			StringBuffer sb = new StringBuffer();

			if (!args_vngl[0][0].equals(args_vngl_old[0][0])) {
				sb.append("회사명 ");
			}
			if (!args_vngl[0][7].equals(args_vngl_old[0][1])) {
				sb.append("업태 ");
			}
			if (!args_vngl[0][8].equals(args_vngl_old[0][2])) {
				sb.append("업종 ");
			}
			if (!args_vngl[0][12].equals(args_vngl_old[0][5])) {
				sb.append("작성자부서 ");
			}
			if (!args_vngl[0][13].equals(args_vngl_old[0][6])) {
				sb.append("작성자성명 ");
			}
			if (!args_vngl[0][21].equals(args_vngl_old[0][10])) {
				sb.append("거래은행 ");
			}
			if (!args_vngl[0][22].equals(args_vngl_old[0][11])) {
				sb.append("예금주 ");
			}
			if (!args_vngl[0][23].equals(args_vngl_old[0][12])) {
				sb.append("계좌번호 ");
			}
			if (!args_vngl[0][27].equals(args_vngl_old[0][13])) {
				sb.append("법인등록번호 ");
			}
			if (!args_addr[0][5].equals(args_vngl_old[0][3])) {
				sb.append("대표자명 ");
			}
			if (!args_addr[0][1].equals(args_vngl_old[0][4])) {
				sb.append("전화번호 ");
			}
			if (!args_addr[0][2].equals(args_vngl_old[0][9])) {
				sb.append("SMS 수신번호 ");
			}
			if (!args_vngl[0][39].equals(args_vngl_old[0][7])) {
				sb.append("작성자 연락처 ");
			}
			if (!args_vngl[0][40].equals(args_vngl_old[0][8])) {
				sb.append("작성자 이메일 ");
			}

			String change = sb.toString();

			

//			Object[] mail_args = { change, args_vngl[0][0] };
//			String mail_type = "M00015";
//
//			if (!"".equals(mail_type) && !change.equals("")) {
//				ServiceConnector.doService(info, "mail", "CONNECTION",
//						mail_type, mail_args);
//			}

			if (rtn == -1)
				throw new Exception("SQL Manager is Null");
			
			Map<String, String> smsParam = new HashMap<String, String>();
			
		    smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
		    smsParam.put("VENDOR_CODE", vendor_code);
			
			new SMS("NONDBJOB", info).rg2Process_ICT(ctx, smsParam);
			new mail("NONDBJOB", info).rg2Process(ctx, smsParam);
			/*
			 * String p_flag = "U"; String p_vendor_code = args_vngl[0][35];
			 * if(!p_vendor_code.substring(0, 2).equals("VM")){ Object[] obj =
			 * {p_flag,p_vendor_code}; SepoaOut value = CallNONDBJOB( ctx,
			 * "VendorMaster", "sendSCI", obj);
			 * 
			 * if(value.status == 0) throw new Exception(value.message); }
			 */
			Commit();

			setStatus(1);
			setMessage("승인되었습니다."); /* Message를 등록한다. */
		} catch (Exception e) {
			Rollback();
			throw new Exception(e.getMessage());
		}
		return getSepoaOut();
	}

	public SepoaOut CallNONDBJOB(ConnectionContext ctx, String serviceId,
			String MethodName, Object[] obj) {

		String conType = "NONDBJOB"; // conType :
										// CONNECTION/TRANSACTION/NONDBJOB

		SepoaOut value = null;
		SepoaRemote wr = null;

		// 다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
		try {

			wr = new SepoaRemote(serviceId, conType, info);
			wr.setConnection(ctx);

			value = wr.lookup(MethodName, obj);

		} catch (SepoaServiceException wse) {
//			try{
				Logger.err.println("wse	= " + wse.getMessage());
//				Logger.err.println("message	= " + value.message);
//				Logger.err.println("status = " + value.status);				
//			}catch(NullPointerException ne){
//        		
//        	}
		} catch (Exception e) {
//			try{
				Logger.err.println("err	= " + e.getMessage());
//				Logger.err.println("message	= " + value.message);
//				Logger.err.println("status = " + value.status);				
//			}catch(NullPointerException ne){
//        		
//        	}
		}

		return value;
	}

	/*업체 수주 실적 조회*/
	/* ICT 사용 */
	public SepoaOut getVendorProject(Map<String, String> header) {
		try {
			String user_id = info.getSession("ID");

			String rtn = "";
			String rtn2 = "";
			rtn = et_getVendorProject(header);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private String et_getVendorProject(Map<String, String> header) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID") , this, ctx, wxp.getQuery());// .toString());
			
			header.put("house_code", info.getSession("HOUSE_CODE"));

			rtn = sm.doSelect(header);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("et_getVendorProject:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}

	/* 신규아이디 신청 - 수주실적 */
	/* ICT 사용 */
	public SepoaOut setVendorProject(Map<String, Object> data) {

        List<Map<String, String>> 	grid 		= null;
        Map<String, String> 		gridInfo	= null;
        Map<String, String> 	  	header		= null;
		
        try {
        	
    		header = MapUtils.getMap(data, "headerData");   
        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	
			String user_id = info.getSession("ID");

			int rtn = et_setVendorProject(header, grid);

			setValue(String.valueOf(rtn));
			setStatus(1);
			msg.setArg("RESULT", String.valueOf(rtn));
			setMessage(msg.getMessage("0012"));

		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			// setMessage(msg.getMessage("0003"));
			setMessage(e.getMessage().trim());

		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private int et_setVendorProject(Map<String, String> header, List<Map<String, String>> grid) throws Exception {
		int rtn = 0;
		
		
		
		ConnectionContext ctx = getConnectionContext();
		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String vendor_code = header.get("vendor_code");
		String user_id = info.getSession("ID");
		SepoaSQLManager sm = null;

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setVendorProject_insert");
			wxp.addVar("house_code", house_code);
			wxp.addVar("vendor_code", vendor_code);
			wxp.addVar("add_date", add_date);
			wxp.addVar("add_time", add_time);
			wxp.addVar("user_id", user_id);

			SepoaXmlParser wxpup = new SepoaXmlParser(this, "et_setVendorProject_update");
			wxpup.addVar("add_date", add_date);
			wxpup.addVar("add_time", add_time);
			wxpup.addVar("user_id", user_id);
			
			int upd_rtn = 0;
			
			if(grid != null && grid.size() > 0){
				Map<String, String> gridInfo = null;
				for(int i = 0 ; i < grid.size() ; i++){
					gridInfo = grid.get(i);
					gridInfo.put("house_code", house_code);
					gridInfo.put("vendor_code", vendor_code);
					gridInfo.put("ENT_FROM_DATE", gridInfo.get("ENT_FROM_DATE").replaceAll("/", ""));
					gridInfo.put("ENT_TO_DATE", gridInfo.get("ENT_TO_DATE").replaceAll("/", ""));
					
					
					if("I".equals(gridInfo.get("FLAG"))){
						Logger.debug.println("QUERY=" + wxp.getQuery());
						sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL.toString());
						rtn = sm.doInsert(gridInfo);
						if (rtn < 1) throw new Exception("no insert icomvncp");						
					}else{
						sm = new SepoaSQLManager(user_id, this, ctx, wxpup.getQuery());// tSQL_upd.toString());
						upd_rtn = sm.doUpdate(gridInfo);
						if (upd_rtn < 1) throw new Exception("no update icomvncp");						
					}
				}
			}

			rtn = rtn + upd_rtn;

			Commit();
		} catch (Exception e) {
			throw new Exception("et_setVendorProject:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}

	/* 신규업체 등록 - 수주 실적 삭제 */
	/* ICT 사용 */
	public SepoaOut delVendorProject(Map<String, Object> data) {
		
		
        List<Map<String, String>> 	grid 		= null;
        Map<String, String> 	  	header		= null;

		try {
			
    		header = MapUtils.getMap(data, "headerData");   
        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	
        	header.put("user_id", info.getSession("ID"));
        	header.put("house_code", info.getSession("HOUSE_CODE"));
			
			int rtn = et_delVendorProject(header, grid);
			setValue(String.valueOf(rtn));
			setStatus(1);
			msg.setArg("RESULT", String.valueOf(rtn));
			setMessage(msg.getMessage("0013"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0004"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private int et_delVendorProject(Map<String, String> header, List<Map<String, String>> grid)throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			String[] setType = { "S", "S", "S" };

			SepoaSQLManager sm = new SepoaSQLManager(header.get("user_id"), this, ctx, wxp.getQuery());// tSQL.toString());
			
			Map<String, String> gridInfo = null;
			
			if(grid != null && grid.size() > 0){
				for(int i = 0 ; i < grid.size(); i++){
					gridInfo = grid.get(i);
					gridInfo.put("house_code"	, header.get("house_code"));
					gridInfo.put("vendor_code"	, header.get("vendor_code"));
					rtn = sm.doDelete(grid.get(i));
				}
			}
			
			Commit();
		} catch (Exception e) {
			throw new Exception("et_delVendorProject:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	/* Mainternace -- 담당자..icomvncp */
	/* ICT 사용 */
	public SepoaOut getMainternace_icomvncp(Map<String, String>header) {
		try {
			String user_id = info.getSession("ID");

			String rtn = "";

			rtn = et_getMainternace_icomvncp(header);
			String rtnHD1 = getCode(header.get("house_code"), "M174");
			setValue(rtn);
			setValue(rtnHD1);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	/* 영업담당 조회 */
	/* ICT 사용 */
	private String et_getMainternace_icomvncp(Map<String, String>header)
			throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			SepoaSQLManager sm = new SepoaSQLManager(header.get("user_id") , this, ctx, wxp.getQuery());

			rtn = sm.doSelect(header);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("et_getMainternace_icomvncp:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}

	private String getCode(String house_code, String code) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("code", code);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());// tSQL.toString());

			rtn = sm.doSelect((String[])null);

		} catch (Exception e) {
			throw new Exception("getCode:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/* Save -- 담당자..icomvncp */
	/* ICT 사용 */
	public SepoaOut setSave_icomvncp(Map<String, Object> data) {
		
        List<Map<String, String>> 	grid 		= null;
        Map<String, String> 		gridInfo	= null;
        Map<String, String> 	  header		= null;

		try {
			
    		header = MapUtils.getMap(data, "headerData");   
        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	
			String user_id = info.getSession("ID");
			Logger.debug.println(user_id, this, "######setSave_icomvncp#######");

			int rtn = et_setSave_icomvncp(header, grid);

			setValue(String.valueOf(rtn));
			setStatus(1);
			msg.setArg("RESULT", String.valueOf(rtn));
			setMessage(msg.getMessage("0012"));

		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			// setMessage(msg.getMessage("0003"));
			setMessage(e.getMessage().trim());

		}
		return getSepoaOut();
	}

	/* 담당자 정보 입력, 수정 */
	/* ICT 사용 */
	private int et_setSave_icomvncp(Map<String, String>header, List<Map<String, String>> grid) throws Exception {
		int rtn = 0;
		String sRtn = "";
		String max_seq = "";
		String max_seq_BIZ_RPS_YN = "";
		ConnectionContext ctx = getConnectionContext();
		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		
		//Logger.debug.println(info.getSession("ID"), this, "et_setSave_icomvncp");
		
		SepoaSQLManager sm = null;

		//Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>>>> VENDOR_CODE : " + header.get("vendor_code"));

		try {			
			SepoaXmlParser wxp_s = new SepoaXmlParser(this,"et_get_icomvncp_max_seq");
			wxp_s.addVar("house_code", house_code);
			wxp_s.addVar("vendor_code", header.get("vendor_code"));
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setSave_icomvncp_insert");
			wxp.addVar("house_code", house_code);
			wxp.addVar("company_code", header.get("company_code"));
			wxp.addVar("vendor_code", header.get("vendor_code"));
			wxp.addVar("add_date", add_date);
			wxp.addVar("add_time", add_time);
			wxp.addVar("user_id", user_id);

			SepoaXmlParser wxp_u = new SepoaXmlParser(this, "et_setSave_icomvncp_update");
			wxp_u.addVar("add_date", add_date);
			wxp_u.addVar("add_time", add_time);
			wxp_u.addVar("user_id", user_id);
			
			SepoaXmlParser wxp_u2 = new SepoaXmlParser(this, "et_setPhone2_icomaddr_update");
			wxp_u2.addVar("house_code", house_code);
			wxp_u2.addVar("company_code", header.get("company_code"));
			wxp_u2.addVar("vendor_code", header.get("vendor_code"));
			
			SepoaXmlParser wxp_u3 = new SepoaXmlParser(this, "et_setPhone2_icomaddr_update2");
			wxp_u3.addVar("house_code", house_code);
			wxp_u3.addVar("company_code", header.get("company_code"));
			wxp_u3.addVar("vendor_code", header.get("vendor_code"));
			
			int upd_rtn = 0;
			int upd_rtn2 = 0;
			int upd_rtn3 = 0;
			int upd_rtn4 = 0;
			if(grid != null && grid.size() > 0){
				Map<String, String> gridList = null;
				String flag = "";
				for(int i = 0 ; i < grid.size() ; i++){
					gridList = grid.get(i);
					
					gridList.put("house_code", header.get("house_code"));
					gridList.put("company_code", header.get("company_code"));
					gridList.put("vendor_code", header.get("vendor_code"));
					
					if("I".equals(gridList.get("FLAG"))){
						sm = new SepoaSQLManager(user_id, this, ctx, wxp_s.getQuery());// tSQL.toString());
						sRtn = sm.doSelect((String[])null);
						SepoaFormater wf = new SepoaFormater(sRtn);
						
						max_seq = wf.getValue(0,0);
						wxp.addVar("max_seq", max_seq);
						sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL.toString());
						rtn = sm.doInsert(gridList);
						if (rtn < 1) throw new Exception("no insert icomvncp_ict");
						
						if("1".equals(gridList.get("BIZ_RPS_YN"))){
							max_seq_BIZ_RPS_YN = max_seq;
						}						
					}else{
						sm = new SepoaSQLManager(user_id, this, ctx, wxp_u.getQuery());// tSQL_upd.toString());
						upd_rtn = sm.doUpdate(gridList);
						if (upd_rtn < 1) throw new Exception("no update icomvncp_ict");
						
						if("1".equals(gridList.get("BIZ_RPS_YN"))){
							max_seq_BIZ_RPS_YN = gridList.get("SEQ");
						}	
					}
					
					if("1".equals(gridList.get("BIZ_RPS_YN"))){
						sm = new SepoaSQLManager(user_id, this, ctx, wxp_u2.getQuery());
						upd_rtn2 = sm.doUpdate(gridList);
						if (upd_rtn2 < 0) throw new Exception("no update icomaddr_ict");
						
						sm = new SepoaSQLManager(user_id, this, ctx, wxp_u3.getQuery());
						upd_rtn3 = sm.doUpdate(gridList);
						if (upd_rtn3 < 0) throw new Exception("no update icomaddr_ict");											
					}
				}
				
				if(!"".equals(max_seq_BIZ_RPS_YN)){
					SepoaXmlParser wxp_u4 = new SepoaXmlParser(this, "et_setSave_icomvncp_bizRpsYn");
					wxp_u4.addVar("house_code", house_code);
					wxp_u4.addVar("company_code", header.get("company_code"));
					wxp_u4.addVar("vendor_code", header.get("vendor_code"));	
					wxp_u4.addVar("SEQ", max_seq_BIZ_RPS_YN);	
					
					sm = new SepoaSQLManager(user_id, this, ctx, wxp_u4.getQuery());
					upd_rtn4 = sm.doUpdate((String[][])null, null);
					
					if (upd_rtn4 < 0) throw new Exception("no update icomaddr_ict");
					
				}
				
			}
			rtn = rtn + upd_rtn + upd_rtn2 + upd_rtn3 + upd_rtn4;
			Commit();
		} catch (Exception e) {
			throw new Exception("et_setSave_icomvncp:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}

	/* ICT 사용 */
	public SepoaOut setDelete_icomvncp(Map<String, Object> data) {
		
        List<Map<String, String>> 	grid 		= null;
        Map<String, String> 		gridInfo	= null;
        Map<String, String> 	  header		= null;

		try {
			String user_id = info.getSession("ID");
			Logger.debug.println(user_id, this, "######setDelete_icomvncp#######");
			
    		header = MapUtils.getMap(data, "headerData");   
        	grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");

			int rtn = et_setDelete_icomvncp(header, grid);

			setValue(String.valueOf(rtn));
			setStatus(1);
			msg.setArg("RESULT", String.valueOf(rtn));
			setMessage(msg.getMessage("0013"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0004"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private int et_setDelete_icomvncp(Map<String, String> header, List<Map<String, String>> grid) throws Exception {
		int rtn = -1;
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();
		String status = "D";
		String user_id = info.getSession("ID");

		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
			if(grid != null && grid.size() > 0){
				Map<String, String> gridInfo = null;

				for(int i = 0 ; i < grid.size() ; i++){
					gridInfo = grid.get(i);
					gridInfo.put("house_code", header.get("house_code"));
					gridInfo.put("vendor_code", header.get("vendor_code"));
					gridInfo.put("company_code", header.get("company_code"));
					SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL.toString());
					rtn = sm.doDelete(gridInfo);
				}
			}
			Commit();
		} catch (Exception e) {
			throw new Exception("et_setDelete_icomvncp:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	/**
	 * Change_icomvngl
	 * 
	 * @description : 신규업체 등록 아이디 신청
	 * @author useonlyj
	 * 
	 * 
	 */
	public SepoaOut doConfirm(Map<String, String> header) {
		String user_id = info.getSession("ID");
		try {

			
			
			SepoaOut wo2 = null;
			int rtn = et_doConfirm(header);
			setValue(String.valueOf(header.get("vendor_code")));
			setStatus(1);
			setMessage("아이디 신청이 완료되었습니다.");
		} catch (Exception e) {
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
			setValue(e.getMessage().trim());
			setStatus(0);
			setMessage(msg.getMessage("0002"));
		}
		return getSepoaOut();
	}

	private int et_doConfirm(Map<String, String> header) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		SepoaSQLManager sm = null;
		
		String house_code 	= info.getSession("HOUSE_CODE");
		String user_id 		= info.getSession("ID");
		String vendor_code 	= header.get("vendor_code");

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code"	, house_code);
			wxp.addVar("user_id"	, user_id);
			wxp.addVar("vendor_code", vendor_code);

			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// /tSQL_upd.toString());
			rtn = sm.doUpdate((String[][])null, null);
			if (rtn < 1)
				throw new Exception("et_doConfirm : ");

				// 업체아이디 신청시 업체등록평가정보 초기화 
			/*SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
				wxp2.addVar("house_code", house_code);
				wxp2.addVar("user_id", user_id);
				wxp2.addVar("vendor_code", vendor_code);
	
				SepoaSQLManager sm2 = new SepoaSQLManager(user_id, this, ctx, wxp2.getQuery());// /tSQL_upd.toString());
				int rtn2 = sm2.doUpdate((String[][])null, null);
					
				if (rtn2 < 1)
					throw new Exception("et_doConfirm_sgnv : ");*/

			Commit();
		} catch (Exception e) {
			throw new Exception("et_doConfirm:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}

	/**
	 * @description : Mainternace -- 업체현황조회.vendor_list_vw
	 * @date : 2010-03-10
	 * @author useonlyj
	 * 
	 */

	public SepoaOut getMainternace_vendor_list_vw(String[] args) {

		try {
			String rtn = et_getMainternace_vendor_list_vw(args);

			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	private String et_getMainternace_vendor_list_vw(String[] args)
			throws Exception {
		String rtn = "";
		String user_id = info.getSession("ID");
		ConnectionContext ctx = getConnectionContext();

		String[] argsData = { args[0], args[1], args[2], args[3], args[4],
				args[5], args[9] };

		String item_group = "";
		String qr_from = "";
		String qr_to = "";

		if (args.length == 8) {
			item_group = (args[5] == null) ? "" : args[5];
			qr_from = (args[6] == null) ? "" : args[6];
			qr_to = (args[7] == null) ? "" : args[7];
		}

		String check = "Y";
		if ((item_group.equals("")) && (qr_from.equals(""))
				&& (qr_to.equals(""))) {
			check = "N";
		}

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("check", check);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());// tSQL.toString());

			rtn = sm.doSelect((check.equals("N")) ? argsData : args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("et_getMainternace_vendor_list_vw:"
					+ e.getMessage());
		} finally {
		}
		return rtn;
	}

	/**
	 * Mainternace -- 업체현황조회.vendor_list_vw
	 */

	public SepoaOut getVendorList(String[] args) {

		try {
			String rtn = et_getVendorList(args);

			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getVendorList(String[] args) throws Exception {
		String rtn = "";
		String user_id = info.getSession("ID");
		ConnectionContext ctx = getConnectionContext();

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());// tSQL.toString());

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("et_getVendorList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	public SepoaOut setVendorApproval(String[][] vnglData, String sign_status,
			String approval, String vendor_code) {
		try {
			String user_id = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String company_code = info.getSession("COMPANY_CODE");
			String user_dept = info.getSession("DEPARTMENT");

			if (sign_status.equals("P")) {
				SignRequestInfo sri = new SignRequestInfo();
				sri.setHouseCode(house_code);
				sri.setCompanyCode(company_code);
				sri.setDept(user_dept);
				sri.setReqUserId(info.getSession("ID"));
				sri.setDocType("VM");
				sri.setDocNo(vendor_code);
				sri.setDocSeq("0");
				sri.setSignStatus("P");
				sri.setCur("KRW");
				sri.setTotalAmt(0.0);
				sri.setShipperType("D");
				sri.setItemCount(1);
				sri.setSignString(approval); // AddParameter 에서 넘어온 정보

				SepoaOut wo = CreateApproval(info, sri); // 밑에 함수 실행
				
				if (wo.status == 0) {
					throw new Exception(msg.getMessage("4000"));
				} else if (wo.status == 1) {

					int rtnSign = update_Vngl(vnglData);

					setValue("Insert Row=" + rtnSign);

					if (rtnSign == 0) {
						Rollback();
						setStatus(0);
						setMessage(msg.getMessage("4000"));
						return getSepoaOut();
					}
				}
			}

			Commit();
			setStatus(1);
			if (sign_status.equals("P")) {
				setMessage("업체코드가 결재요청 되었습니다.");
			} else {
				setMessage("업체코드가 저장 되었습니다.");
			}
		} catch (Exception e) {
			// if(!sign_status.equals("P")){
			try {
				Rollback();
			} catch (Exception e1) {
				Logger.err.println(this, e1.getMessage());
			}
			// }
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("4000"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	// 결재 상신을 위한 결재 공통모듈을 부른다.
	private SepoaOut CreateApproval(SepoaInfo info, SignRequestInfo sri) {

		SepoaOut wo = null;
		SepoaRemote ws = null;
		String nickName = "p6027";
		String conType = "NONDBJOB";
		String MethodName1 = "setConnectionContext";
		ConnectionContext ctx = getConnectionContext();
		try {
			Object[] obj1 = { ctx };
			String MethodName2 = "addSignRequest";
			Object[] obj2 = { sri };

			ws = new SepoaRemote(nickName, conType, info);
			ws.lookup(MethodName1, obj1);
			wo = ws.lookup(MethodName2, obj2);
		} catch (Exception e) {
			setStatus(0);
			
			Logger.err.println("approval: = " + e.getMessage());
		}
		return wo;
	}

	private int update_Vngl(String[][] upd_data) throws Exception {
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaSQLManager sm = null;

		try {

			// StringBuffer tSQL_upd = new StringBuffer();

			// tSQL_upd.append(" UPDATE ICOMVNGL SET                    			\n");
			// tSQL_upd.append("   REG_REMARK	 	 = ?                 			\n");
			// tSQL_upd.append(" , TECH_RISE	 	 = ?                 			\n");
			// tSQL_upd.append(" , CUSTOMER	 	 = ?                 			\n");
			// tSQL_upd.append(" , SIGN_STATUS	 	 = 'P'               			\n");
			// tSQL_upd.append(" , JOB_STATUS	 	 = 'P'               			\n");
			// tSQL_upd.append(" , CHANGE_DATE      = convert(varchar, getdate(),112)	\n");
			// tSQL_upd.append(" , CHANGE_TIME      = replace(convert(char(8),getdate(),108),':','')  \n");
			// tSQL_upd.append(" , CHANGE_USER_ID   = ?			     			\n");
			//
			// tSQL_upd.append(" , AKONT   = ?	--AKONT		     			\n");
			// tSQL_upd.append(" , ZTERM   = ?	--ZTERM		     			\n");
			// tSQL_upd.append(" , ZWELS   = ?	--ZWELS		     			\n");
			// tSQL_upd.append(" , BANK_CODE   = ? --HBKID			     			\n");
			//
			// tSQL_upd.append(" WHERE HOUSE_CODE   = ?                 			\n");
			// tSQL_upd.append(" AND VENDOR_CODE    = ?                 			\n");

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());

			String[] type_upd = { "S", "S", "S", "S", "S", "S", "S", "S", "S",
					"S" };

			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL_upd.toString());
			rtn = sm.doUpdate(upd_data, type_upd);
			if (rtn < 1)
				throw new Exception("update_Vngl : ");

			Commit();
		} catch (Exception e) {
			throw new Exception("et_setVendorProject:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}

	/**
	 * Mainternace -- 업체현황조회.vendor_list_vw
	 */

	public SepoaOut getVendorList2(String[] args) {

		try {
			String rtn = et_getVendorList2(args);

			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getVendorList2(String[] args) throws Exception {
		String rtn = "";
		String user_id = info.getSession("ID");
		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			// StringBuffer tSQL = new StringBuffer();
			// tSQL.append("			SELECT top 1 (CASE WHEN VG.JOB_STATUS = 'P' THEN                                      \n");
			// tSQL.append("							'승인대기'                                                      \n");
			// tSQL.append("						WHEN VG.JOB_STATUS = 'R' THEN                                       \n");
			// tSQL.append("							'반려'                                                          \n");
			// tSQL.append("						WHEN VG.JOB_STATUS = 'E' THEN                                       \n");
			// tSQL.append("							'승인'															\n");
			// tSQL.append("				   END) AS JOB_STATUS_DESC                                                  \n");
			// tSQL.append("				  ,VG.JOB_STATUS	                                                        \n");
			// tSQL.append("				  ,VG.VENDOR_CODE                                                           \n");
			// tSQL.append("				  ,dbo.GETVENDORNAME(VG.HOUSE_CODE, VG.VENDOR_CODE) AS VENDOR_NAME              \n");
			// tSQL.append("				  ,AR.CEO_NAME_LOC                                                          \n");
			// tSQL.append("				  ,VG.INDUSTRY_TYPE                                                         \n");
			// tSQL.append("				  ,VG.BUSINESS_TYPE                                                         \n");
			// tSQL.append("				  ,VG.CREDIT_RATING                                                         \n");
			// tSQL.append("				  ,VG.REMARK                                                                \n");
			// tSQL.append("				  ,dbo.GETICOMCODE1(VG.HOUSE_CODE, 'M100', VG.SIGN_STATUS) AS SIGN_STATUS_DESC  \n");
			// tSQL.append("				  ,VG.SIGN_STATUS                                                           \n");
			// tSQL.append("				  ,SP.SIGN_REMARK	                                                        \n");
			// tSQL.append("				  ,AR.ADDRESS_LOC                                                           \n");
			// tSQL.append("				  ,VG.SHIPPER_TYPE                                                          \n");
			// tSQL.append("				  ,VG.VENDOR_TYPE															\n");
			// tSQL.append("				  ,VG.IRS_NO																\n");
			// tSQL.append("				  ,VG.REG_REMARK															\n");
			// tSQL.append("				  ,VG.TECH_RISE		 														\n");
			// tSQL.append("				  ,(CASE WHEN VG.BIZ_CLASS1 = '1' THEN '상품' ELSE '' END)+		\n");
			// tSQL.append("				  (CASE WHEN (CASE WHEN VG.BIZ_CLASS1 = '1' THEN '상품' ELSE '' END) = '' THEN '' ELSE ', ' END)+		\n");
			// tSQL.append("				  (CASE WHEN VG.BIZ_CLASS2 = '1' THEN '용역' ELSE '' END)+		\n");
			// tSQL.append("				  (CASE WHEN (CASE WHEN VG.BIZ_CLASS2 = '1' THEN '상품' ELSE '' END) = '' THEN '' ELSE ', ' END)+		\n");
			// tSQL.append("				  (CASE WHEN VG.BIZ_CLASS3 = '1' THEN '유지보수' ELSE '' END)+		\n");
			// tSQL.append("				  (CASE WHEN (CASE WHEN VG.BIZ_CLASS3 = '1' THEN '유지보수' ELSE '' END) = '' THEN '' ELSE ', ' END)+		\n");
			// tSQL.append("				  (CASE WHEN VG.BIZ_CLASS4 = '1' THEN '공사' ELSE '' END) AS BIZ_CLASS4		\n");
			// tSQL.append("			FROM ICOMADDR AR, ICOMVNGL VG LEFT OUTER JOIN ICOMSCTP SP                       \n");
			// tSQL.append("			  ON VG.HOUSE_CODE 	    = SP.HOUSE_CODE                                         \n");
			// tSQL.append("			    AND VG.VENDOR_CODE	= SP.DOC_NO										        \n");
			// tSQL.append("			WHERE VG.HOUSE_CODE  = AR.HOUSE_CODE                                            \n");
			// tSQL.append("			  AND VG.VENDOR_CODE = AR.CODE_NO                                               \n");
			// tSQL.append("			  AND AR.CODE_TYPE = '2'                                                        \n");
			// tSQL.append("			  AND VG.STATUS <> 'D'                                                          \n");
			// tSQL.append("			  AND VG.JOB_STATUS 	!= 'D'                                            		\n");
			// tSQL.append("<OPT=S,S>	  AND VG.HOUSE_CODE 	= ?                                               </OPT>\n");
			// tSQL.append("<OPT=S,S>	  AND VG.ADD_DATE BETWEEN ? </OPT><OPT=S,S> AND ?                         </OPT>\n");
			// tSQL.append("<OPT=S,S>	  AND VG.VENDOR_CODE 	= ?                                               </OPT>\n");
			// tSQL.append("<OPT=S,S>	  AND VG.VENDOR_NAME_LOC LIKE '%' + ? + '%'                               </OPT>\n");
			// tSQL.append("<OPT=S,S>	  AND VG.JOB_STATUS 	= ?                                               </OPT>\n");
			// tSQL.append("<OPT=S,S>	  AND VG.SIGN_STATUS 	= ?												  </OPT>\n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,
					wxp.getQuery());

			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("et_getVendorList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/* ICT 사용 */
	public SepoaOut getMaxVedorCode() {

		try {
			String rtn = et_getMaxVedorCode();

			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private String et_getMaxVedorCode() throws Exception {
		String rtn = "";
		String user_id = info.getSession("ID");
		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

			rtn = sm.doSelect((String[])null);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("et_getMaxVedorCode:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/*
	 * 개발자현황 조회( icomhumt, icomvngl )
	 */

	public SepoaOut getVendor_human_list(String house_code, String vendor_code,
			String name_loc, String human_no, String regular_flag,
			String association_grade, String SKILL_TYPE, String SKILL_CODE,
			String PROJECT_CAREER, String level
	// ,String sg_refitem
	) {
		try {

			String rtnHD = et_getVendor_human_list(house_code, vendor_code,
					name_loc, human_no, regular_flag, association_grade,
					SKILL_TYPE, SKILL_CODE, PROJECT_CAREER, level
			// ,sg_refitem
			);

			setStatus(1);
			setValue(rtnHD);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage("조회된 내역이 없습니다.");
			else {
				setMessage(msg.getMessage("0000"));
			}

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	private String et_getVendor_human_list(String house_code,
			String vendor_code, String name_loc, String human_no,
			String regular_flag, String association_grade, String SKILL_TYPE,
			String SKILL_CODE, String PROJECT_CAREER, String level
	// ,String sg_refitem
	) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("SKILL_TYPE", SKILL_TYPE);
			wxp.addVar("SKILL_CODE", SKILL_CODE);
			wxp.addVar("PROJECT_CAREER", PROJECT_CAREER);
			wxp.addVar("level", level);

			/*
			 * tSQL.append("			SELECT                                  						\n")
			 * ;
			 * tSQL.append("				 HU.HOUSE_CODE                         						\n"
			 * );
			 * tSQL.append("				,HU.COMPANY_CODE                       						\n"
			 * );
			 * tSQL.append("				,HU.HUMAN_NO                           						\n"
			 * );
			 * tSQL.append("				,HU.STATUS                             						\n"
			 * );
			 * tSQL.append("				,HU.ADD_DATE                           						\n"
			 * );
			 * tSQL.append("				,HU.ADD_TIME                           						\n"
			 * );
			 * tSQL.append("				,HU.ADD_USER_ID                        						\n"
			 * );
			 * tSQL.append("				,HU.CHANGE_DATE                        						\n"
			 * );
			 * tSQL.append("				,HU.CHANGE_TIME                        						\n"
			 * );
			 * tSQL.append("				,HU.CHANGE_USER_ID                     						\n"
			 * );
			 * tSQL.append("				,HU.VENDOR_CODE                        						\n"
			 * );
			 * tSQL.append("				,HU.NAME_LOC                           						\n"
			 * );
			 * tSQL.append("				,HU.PHONE_NO                           						\n"
			 * );
			 * tSQL.append("				,HU.EMAIL                              						\n"
			 * );
			 * tSQL.append("				,HU.ZIP_CODE                           						\n"
			 * );
			 * tSQL.append("				,HU.ADDRESS_LOC                        						\n"
			 * );
			 * tSQL.append("				,HU.FINAL_GRADUATION                   						\n"
			 * ); tSQL.append("				,dbo.GETICOMCODE1('"+house_code+
			 * "','M172',HU.ASSOCIATION_GRADE) \n");
			 * tSQL.append("				  AS ASSOCIATION_GRADE										\n");
			 * tSQL.append
			 * ("				,dbo.GETICOMCODE1('"+house_code+"','M174',HU.POSITION)   		\n"
			 * ); tSQL.append("				  AS POSITION 												\n");
			 * tSQL.append("				,HU.FIRST_PROJECT_DATE                 						\n"
			 * );
			 * tSQL.append("				,HU.REMARK                             						\n"
			 * ); tSQL.append(
			 * "				,substring(HU.RESIDENT_NO,0,6) AS RESIDENT_NO                  \n"
			 * );
			 * tSQL.append("				,HU.MOBILE_NO                          						\n"
			 * );
			 * tSQL.append("				,HU.MILITARY_SERVICE                   						\n"
			 * );
			 * tSQL.append("				,HU.IT_WORK_PERIOD                   						\n");
			 * tSQL.append("				,HU.VENDOR_GRADE                     						\n");
			 * tSQL.append("				,dbo.GETICOMCODE1('"+house_code+
			 * "','M173',HU.REGULAR_FLAG) 		\n");
			 * tSQL.append("				  AS  REGULAR_FLAG                        					\n"
			 * );
			 * tSQL.append("				,HU.JOIN_DATE                          						\n"
			 * );
			 * tSQL.append("				,HU.FIRST_PROJECT_VENDOR               						\n"
			 * );
			 * tSQL.append("				,VN.VENDOR_CODE                          					\n"
			 * );
			 * tSQL.append("				,VN.VENDOR_NAME_LOC               							\n");
			 * tSQL.append(
			 * "			FROM ICOMHUMT HU,ICOMVNGL VN                          			\n"
			 * );
			 * tSQL.append("			WHERE HU.STATUS  <> 'D'                							\n"
			 * ); tSQL.append(
			 * "<OPT=S,S>	  AND HU.HOUSE_CODE   		= ?            	 		 	</OPT>\n"
			 * ); tSQL.append(
			 * "<OPT=S,S>	  AND HU.VENDOR_CODE  		= ?            	 		 	</OPT>\n"
			 * ); tSQL.append(
			 * "<OPT=S,S>    AND HU.HUMAN_NO     		= ?            	 		 	</OPT>\n"
			 * ); tSQL.append(
			 * "<OPT=S,S>    AND HU.REGULAR_FLAG 		= ?            	 		 	</OPT>\n"
			 * ); tSQL.append(
			 * "<OPT=S,S>    AND HU.ASSOCIATION_GRADE = ?            	  		 	</OPT>\n"
			 * ); tSQL.append(
			 * "<OPT=S,S>    AND HU.NAME_LOC	LIKE	'%' + ? + '%'	  		 	</OPT>\n"
			 * ); tSQL.append(
			 * "			  AND HU.HOUSE_CODE = VN.HOUSE_CODE                 			\n");
			 * tSQL.append(
			 * "			  AND HU.VENDOR_CODE = VN.VENDOR_CODE                 			\n"
			 * );
			 */

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());

			String[] args = { house_code, vendor_code, human_no, regular_flag,
					association_grade, name_loc
			// ,SKILL_TYPE
			// ,SKILL_CODE
			// ,level
			// ,sg_refitem
			};
			rtn = sm.doSelect(args);

		} catch (Exception e) {
			throw new Exception("et_getVendor_human_list:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/*
	 * 개발자현황 조회( icomhumt, icomvngl )
	 */

	public SepoaOut getVendor_human_list1(String house_code, String vendor_code) {
		try {

			String rtnHD = et_getVendor_human_list1(house_code, vendor_code);

			setStatus(1);
			setValue(rtnHD);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage("조회된 내역이 없습니다.");
			else {
				setMessage(msg.getMessage("0000"));
			}

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	private String et_getVendor_human_list1(String house_code,
			String vendor_code) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());

			String[] args = { house_code, vendor_code };
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			throw new Exception("et_getVendor_human_list1:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/* ICT 사용 */
	public SepoaOut getDis_icomvngl_2(String[] args, String mode) {

		try {
			String user_id = info.getSession("ID");
			String rtn = null;

			rtn = getDis_icomvngl_2(args, user_id, mode);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	/* ICT 사용 */
	private String getDis_icomvngl_2(String[] args, String user_id, String mode) throws Exception {
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("company_code", company_code);
			wxp.addVar("mode", mode);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());// tSQL.toString()
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("getDis_icomvngl:" + e.getMessage());
		} finally {
			// Release();
		}
		return rtn;
	}
	
	
	public SepoaOut getVendor_sourcing_list(Map<String, String> header) {
		try {

			String rtnHD = et_getVendor_sourcing_list(header);

			setStatus(1);
			setValue(rtnHD);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage("조회된 내역이 없습니다.");
			else {
				setMessage(msg.getMessage("0000"));
			}

		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	private String et_getVendor_sourcing_list(Map<String, String> header) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		
		String house_code 	= info.getSession("HOUSE_CODE");
		String vendor_code	= header.get("vendor_code");
		
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("vendor_code", vendor_code);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			header.put("house_code", house_code);
//			String[] args = { house_code, vendor_code };
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("et_getVendor_sourcing_list:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	//협력사 간편등록 
	public SepoaOut setVendorSimple(String vendor_no, String vendor_name, String ceo_name, 
			                       String zip_code,  String address_loc, String tel_no, 
			                       String  email_no, String business_type,String  industry_type) {
		try {

			int rtn = et_setVendorSimple(vendor_no, vendor_name, ceo_name, zip_code, address_loc, tel_no, email_no, business_type, industry_type);

			if(rtn == 4){
				setStatus(1);
				Commit();
			}else{
				setStatus(0);
				setMessage(msg.getMessage("0001"));				
			}
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	private int et_setVendorSimple(String vendor_no, String vendor_name, String ceo_name, 
            String zip_code,  String address_loc, String tel_no, 
            String  email_no, String business_type,String  industry_type) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		ConnectionContext ctx = getConnectionContext();
		try {
			
			//ICOMVNGL 데이터 생성
			SepoaXmlParser wxp1 = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName()+"_1");
			wxp1.addVar("house_code"  		, house_code   );
			wxp1.addVar("user_id"	 		, user_id      );
			wxp1.addVar("vendor_no"			, vendor_no    );
			wxp1.addVar("vendor_name"		, vendor_name  );
			wxp1.addVar("business_type"		, business_type);
			wxp1.addVar("industry_type"		, industry_type);
	
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp1.getQuery());
			rtn += sm.doInsert((String[][])null, null);

			// ICOMLUSR 데이터 생성
			SepoaXmlParser wxp2 = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName()+"_2");
			wxp2.addVar("house_code"  		, house_code   );
			wxp2.addVar("user_id"	 		, user_id      );
			wxp2.addVar("vendor_no"			, vendor_no    );
			wxp2.addVar("ceo_name"			, ceo_name     );
			wxp2.addVar("tel_no"			, tel_no	   );
			wxp2.addVar("email_no"			, email_no     );

			
			sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp2.getQuery());
			rtn += sm.doInsert((String[][])null, null);

			// ICOMADDR 데이터 생성
			SepoaXmlParser wxp3 = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName()+"_3");
			wxp3.addVar("house_code"  		, house_code   );
			wxp3.addVar("vendor_no"			, vendor_no    );
			wxp3.addVar("ceo_name"			, ceo_name     );
			wxp3.addVar("zip_code"			, zip_code     );
			wxp3.addVar("address_loc"		, address_loc  );
			wxp3.addVar("tel_no"			, tel_no	   );
			wxp3.addVar("email_no"			, email_no     );		
			sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp3.getQuery());
			rtn += sm.doInsert((String[][])null, null);

			// ICOMVNCP 데이터 생성
			SepoaXmlParser wxp4 = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName()+"_4");
			wxp4.addVar("house_code"  		, house_code   );
			wxp4.addVar("user_id"	 		, user_id      );
			wxp4.addVar("vendor_no"			, vendor_no    );
			wxp4.addVar("ceo_name"			, ceo_name     );
			
			sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp4.getQuery());
			rtn += sm.doInsert((String[][])null, null);
			
			
		} catch (Exception e) {
			throw new Exception("et_setVendorSimple :" + e.getMessage());
		} finally {
		}
		return rtn;
	}

}
