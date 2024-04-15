package admin.wisepopup;

import sepoa.fw.cfg.Config;
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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class p6032 extends SepoaService {

	String processId = "P60";

	String language = "KR"; // info.getSession("LANGUAGE"); Session객체가 없는 User을

	// 위한 Util제공을 위해 세션객체는 사용하지 않는다.

	// String user_id = "LEPPLE";//info.getSession("ID");
	String user_id = info.getSession("ID");

	Message msg = null;

	public p6032(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
		msg = new Message(info, processId);
	}

	public String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			s = configuration.get(s);
			return s;
		} catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : "
					+ configurationexception.getMessage());
		} catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		return null;
	}

	/**
	 * 메소드명 : getCodeFlag() Description : 1. 서비스될 타입 설정.
	 *
	 *
	 * 작성일 : 2001.08.03
	 */
	public SepoaOut getCodeFlag(String code) {
		String rtn = "";
		try {

			// Query ����κ� Call
			rtn = et_getCodeFlag(code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}

	/**
	 * 메소드명 : et_getCodeFlag Description : 1. 서비스될 타입 설정. Argument :
	 */

	private String et_getCodeFlag(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("house_code");

		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer sql = new StringBuffer();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("code", code);

//			sql.append(" SELECT FLAG, TEXT5 ");
//			sql.append(" FROM ICOMCODE ");
//			sql.append(" WHERE HOUSE_CODE = '" + house_code + "' AND TYPE = 'S000' AND CODE ='" + code + "'  ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			rtn = sm.doSelect((String[])null);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("et_getCodeFlag:" + e.getMessage());
		} 
		
		return rtn;
	}

	/** *************** Server popup **************** */

	public SepoaOut getCodeMaster(String code) {

		try {
			String rtn = "";

			// Query ����κ� Call
			rtn = et_getCodeMaster(code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			// Logger.err.println(info.getSession("ID"),this,e.getMessage());
		}
		return getSepoaOut();
	}

	/**
	 * 메소드명 : et_getCodeMaster Description : 제목 가져오기 Argument :
	 */

	private String et_getCodeMaster(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("house_code");
		ConnectionContext ctx = getConnectionContext();

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("code", code);

//			StringBuffer sql = new StringBuffer();
//			sql.append(" SELECT CODE, ISNULL(text1, ' '), ISNULL(text2,' ') ");
//			sql.append(" FROM ICOMCODE ");
//			sql.append(" WHERE HOUSE_CODE ='" + house_code
//					+ "' AND TYPE = 'S000' AND CODE ='" + code + "'  ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this,
					ctx, wxp.getQuery());

			rtn = sm.doSelect((String[])null);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("et_getCodeMaster:" + e.getMessage());
		} 
		
		return rtn;
	}

	/**
	 * 메소드명 : getCodeColumn() Description : 1. EP 코드 조회 ( oep_pp_lis3.jsp에서 호출 )
	 * 2. getCodeColumn() call 3. 헤더부분 값 가져오기 작성일 : 2001.08.03
	 */
	public SepoaOut getCodeColumn(String code) {
		String rtn = "";
		try {
			// Query ����κ� Call
			rtn = et_getCodeColumn(code);
			// Logger.debug.println("getCode","result====>"+rtn);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		} catch (Exception e) {
			
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}

	/**
	 * 메소드명 : et_getCodeColumn Description : 제목 가져오기 Argument :
	 */

	private String et_getCodeColumn(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("house_code");

		ConnectionContext ctx = getConnectionContext();

		try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
			wxp.addVar("code", code);

			//sql.append(" SELECT TEXT3 ");
			//sql.append(" FROM ICOMCODE ");
			//sql.append(" WHERE HOUSE_CODE = '" + house_code
			//		+ "' AND TYPE = 'S000' AND CODE ='" + code + "'  ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			rtn = sm.doSelect((String[])null);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			
			throw new Exception("et_getCodeColumn:" + e.getMessage());
		} 
		
		return rtn;
	}

	// /////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * 메소드명 : getCodeSearch() Description : 1. Code 코드 조회 ( oep_pp_lis2.jsp에서 호출 )
	 * 2. et_getCodeSearch() call
	 */

	public SepoaOut getCodeSearch(String code, // CODE_ID
			String[] values) { // 조회 DESCRIPTION

		try {
			String rtn = "";

			// Query 수행부분 Call
			rtn = et_getCodeSearch(code, values);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		} catch (Exception e) {
			
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(user_id, this, e.getMessage());
		}
		return getSepoaOut();
	}

	/**
	 * 메소드명 : et_getCodeSearch Description : Code 내용을 조회한다. Argument :
	 */

	private String et_getCodeSearch(String code, String[] values) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer sql = new StringBuffer();

			// Code ID로 등록된 Query문을 Select해 온다.
			String query = et_getCodeQuery(code);

			SepoaFormater wf = new SepoaFormater(query);

			query = wf.getValue("TEXT4", 0);

			String tmp = "";
			String tmp_s = ""; // 인자로 나눠진 앞부분을 담는다.
			String tmp_e = ""; // 인자로 나눠진 뒷부분을 담는다.

			if (values != null) {
				// 파라미터값 Set
				for (int i = 0; i < values.length; i++) {
					//Logger.debug.println(user_id, this, "여기 : " + values[i]);
					if (values[i] == null)
						values[i] = "";
					int index_start = query.indexOf("?");

					// 인자로 나눠진 앞부분
					tmp_s = query.substring(0, index_start);
					// 인자로 나눠진 뒷부분
					tmp_e = query.substring(index_start + 1);

					// 인자값인지, like문에 들어가는 인자값인지 구분한다.
					if (tmp_e.length() != 0)
						tmp = query.substring(index_start - 1, index_start + 2);
					// like문에 들어가는 인자값일 경우
					if (tmp.equals("%?%")) {
						query = tmp_s + values[i] + tmp_e;
					} else {
						query = tmp_s + " '" + values[i] + "' " + tmp_e;
					}
				}

			}

			// ROWNUM <= 500 에 관한내용 4.11 이 부분이 필요하지 낳을것이라 판단됨.
			// frame work에 숫자제한기능이 있음
			// query = addrownum(query);

			Logger.debug.println(user_id, this, ")))))))))))) query ===>"
					+ query);

			/*SP9113 사용자 검색 일 경우 추가  일반 계정 일 경우 super-admin 계정은 안보이게 한다.*/
			if("SP9113".equals(code)){
				Config conf = new Configuration();
				String admin_pro_file = conf.get("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
				if(!info.getSession("MENU_TYPE").equals(admin_pro_file)){
					query = query + " AND NVL(USR.MENU_PROFILE_CODE, ' ') != '"+admin_pro_file+"'";
				}
			}
			/*담당자조회()*/
			else if("SP0023".equals(code)){
				Config conf = new Configuration();
				String admin_pro_file = conf.get("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
				if(!info.getSession("MENU_TYPE").equals(admin_pro_file)){
					query = query + " AND EXISTS (SELECT *" +
							"			            FROM ICOMLUSR" +
							"					   WHERE HOUSE_CODE = BACP.HOUSE_CODE " +
							"                        AND USER_ID = BACP.CTRL_PERSON_ID" +
							"                        AND NVL(MENU_PROFILE_CODE, ' ') != '"+admin_pro_file+"' )";
				}
			}

			// long startTime = System.currentTimeMillis();// 시간체크 용
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, query);
			rtn = sm.doSelect((String[])null);
			// long endTime = System.currentTimeMillis();// 시간체크 용

			// Logger.debug.println(user_id,this,"DelayTime = " + (endTime -
			// startTime ));

			//Logger.debug.println(user_id, this, "rtn ========" + rtn+ "--------");
			// System.out.println("Final=======RTN==="+rtn);
			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
//			e.printStackTrace();
			// throw new Exception("et_getCodeSearch:"+stackTrace(e));
			Logger.err.println("Exception e =" + e.getMessage()); 
		}
		return rtn;
	}

	/**
	 * 메소드명 : et_getCodeQuery Description : 제목 가져오기 Argument :
	 */

	private String et_getCodeQuery(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("HOUSE_CODE");

		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("code", code);

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());

			rtn = sm.doSelect((String[])null);
			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			
			throw new Exception("et_getCodeQuery:" + e.getMessage());
		} 
		
		return rtn;
	}






	public SepoaOut getMainternace(String[] args) {

		try {
			String user_id = info.getSession("ID");
			String rtn = null;

			rtn = getMainternace(args, user_id);
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

	private String getMainternace(String[] args, String user_id)
			throws Exception {

		String rtn = null;
		String house_code = info.getSession("house_code");

		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code",house_code );
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());


			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("getMainternace:" + e.getMessage());
		} 
		
		
		return rtn;
	}


	public SepoaOut setDelete(String[][] setData) {
		try {
			String user_id = info.getSession("ID");
			int rtn = 0;

			setValue("Delete Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

			rtn = et_setDelete(setData, user_id);

			setValue("Delete Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));

		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0004"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private int et_setDelete(String[][] setData, String user_id)
			throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			String HOUSE_CODE = info.getSession("HOUSE_CODE");
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("HOUSE_CODE",HOUSE_CODE );
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			String[] type = { "S" };

			rtn = sm.doDelete(setData, type);
			if (rtn == -1)
				throw new Exception("SQL Manager is Null");
			else
				Commit();
		} catch (Exception e) {
			throw new Exception("et_setDelete:" + e.getMessage());
		} 
		
		return rtn;
	}



	public SepoaOut getCode(String[] args) {
		String user_id = info.getSession("ID");
		String house_code = info.getSession("house_code");

		try {
			String rtn = null;
			rtn = et_getCode(user_id, args, house_code);
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

	public String et_getCode(String user_id, String[] args, String house_code)
			throws Exception {
		String result = null;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

			wxp.addVar("args",args[0] );
			wxp.addVar("house_code",house_code );
			String mm = wxp.getQuery();
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,wxp.getQuery());
			result = sm.doSelect(args);
			if (result == null)
				throw new Exception("SQLManager is null");
		} catch (Exception ex) {
			throw new Exception("et_getCode()" + ex.getMessage());
		}
		return result;
	}

	public SepoaOut VerifyDB(String args) {
		boolean existwhere = false; // where 문이 있는지 여부
		boolean existorder = false; // order 문이 있는지 여부
		boolean existgroup = false; // group 문이 있는지 여부
		int index = 0;
		int indexwhere = 0;
		int indexorder = 0;
		int indexgroup = 0;
		String user_id = info.getSession("ID");
		String[] v = new String[10];
		String[] change = new String[2];
		String pargs = "";
		// ? -> ' '바꿈
		for (int i = 0; i < args.length(); i++)
			if (args.charAt(i) == '?') {
				change[0] = args.substring(0, i);
				change[1] = args.substring(i + 1, args.length());
				args = change[0] + " '' " + change[1];
			}

		indexwhere = args.lastIndexOf("WHERE");
		if (indexwhere == -1)
			;
		// where 없다.
		else { // where 있다.
			existwhere = true;
		}

		indexorder = args.lastIndexOf("ORDER BY");
		if (indexorder == -1 || indexorder < indexwhere) { // order이 not exist
			// 때
			;

		} else { // order 가 있다.

			existorder = true;

			v[1] = args.substring(0, indexorder);
			// ~order 전
			v[2] = args.substring(indexorder, args.length());
		}

		// GROUP BY 절이 오면 rownum = 1 을 이것 앞에 놓아야 한다.
		// order by는 group by 뒤에 위치됨으로 신경쓸 필요업다.
		indexgroup = args.lastIndexOf("GROUP BY");

		if (indexgroup == -1 || indexgroup < indexwhere) { // group이 not exist
			// 때
			;
		} else { // group이 있다.

			existgroup = true;

			v[1] = args.substring(0, indexgroup);
			// ~group 전
			v[2] = args.substring(indexgroup, args.length());
		}
		
		/*
		if ((existwhere == false)
				&& (existorder == false || existgroup == false))
			pargs = args + " WHERE ROWNUM = 1 ";
		if ((existwhere == true)
				&& (existorder == false || existgroup == false))
			pargs = args + " AND ROWNUM = 1 ";
		if ((existwhere == false) && (existorder == true || existgroup == true))
			pargs = v[1] + " WHERE ROWNUM = 1 " + v[2];
		if ((existwhere == true) && (existorder == true || existgroup == true))
			pargs = v[1] + " AND ROWNUM = 1 " + v[2];

		*/
		pargs = args;

		String rtn = null;
		try {
			rtn = VerifyDB(pargs, user_id);

			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}

	private String VerifyDB(String val, String user_id) throws Exception {
		String rtn = null;
		String resultv = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			StringBuffer tSQL = new StringBuffer();
			tSQL.append(val);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());
			rtn = sm.doSelect((String[])null);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
			resultv = "Verified SQL Successfully";
		} catch (Exception e) {
			// throw new Exception("Check_Duplicate:"+e.getMessage());
			resultv = e.getMessage();
		}

		return resultv;
	}





	public SepoaOut setSave(String[] setData) {
		try {
			String user_id = info.getSession("ID");
			String HOUSE_CODE = info.getSession("HOUSE_CODE");
			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();
			int rtn = et_setSave(setData, cur_date, cur_time, user_id,HOUSE_CODE);
			setValue("Insert Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}

	private int et_setSave(String[] setData, String cur_date, String cur_time,
			String user_id, String HOUSE_CODE) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("HOUSE_CODE",HOUSE_CODE );
			wxp.addVar("cur_date",cur_date );
			wxp.addVar("cur_time",cur_time );
			wxp.addVar("user_id",user_id );

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S" };
			String[][] tmp = new String[1][];
			tmp[0] = setData;

			rtn = sm.doInsert(tmp, type);
			if (rtn == -1)
				throw new Exception("SQL Manager is Null");
			else
				Commit();
			Commit();
		} catch (Exception e) {
			Rollback();
			throw new Exception("et_setSave:" + e.getMessage());
		} 
		
		return rtn;
	}



	public SepoaOut getDisplay(String args) {
		try {
			String user_id = info.getSession("ID");
			String rtn = null;

			rtn = getDisplay(args, user_id);
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

	private String getDisplay(String val, String user_id) throws Exception {

		String rtn = null;
		String house_code = info.getSession("house_code");

		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code",house_code );

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			String[] args = { val };
			rtn = sm.doSelect(args);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("getMainternace:" + e.getMessage());
		} 
		
		return rtn;
	}

	public SepoaOut setChange(String[] setData) {
		String user_id = info.getSession("ID");
		try {
			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();
			int rtn = et_setChange(setData, cur_date, cur_time, user_id);
			setValue("Change Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0002"));
		}
		return getSepoaOut();
	}

	private int et_setChange(String[] setData, String cur_date,
			String cur_time, String user_id) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {

			String HOUSE_CODE = info.getSession("HOUSE_CODE");

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("cur_date",cur_date );
			wxp.addVar("cur_time",cur_time );
			wxp.addVar("user_id",user_id );
			wxp.addVar("HOUSE_CODE",HOUSE_CODE );

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,wxp.getQuery());
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S" };
			String[][] tmp = new String[1][];
			tmp[0] = setData;

			rtn = sm.doInsert(tmp, type);
			Commit();
		} catch (Exception e) {
			// Rollback();
			throw new Exception("et_setSave:" + e.getMessage());
		} 
		
		return rtn;
	}

	public SepoaOut getPOPUP_Search(String sql) { // 조회 DESCRIPTION

		try {
			String rtn = "";

			// Query 수행부분 Call
			rtn = et_getPOPUP_Search(sql);

			SepoaFormater wf = new SepoaFormater(rtn);
			int rowCount = wf.getRowCount();

			if (rowCount != 0) {
				for (int i = 0; i < wf.getRowCount(); i++) {
					for (int j = 0; j < wf.getColumnCount(); j++) {
						rtn = wf.getValue(i, j);
					}
				}
			} else {
				rtn = "Not Defined";
			}// if

			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}

	/**
	 * 메소드명 : et_getPOPUP_Search Description : Code 내용을 조회한다. Argument :
	 */

	private String et_getPOPUP_Search(String sql) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql);
			rtn = sm.doSelect((String[])null);
			if (rtn == null)
				throw new Exception("SQL Manager is Null");

		} catch (Exception e) {
			throw new Exception("getPOPUP_Search:" + e.getMessage());
		} 
		
		return rtn;
	}


	public SepoaOut getDuplicate(String args) {

		String user_id = info.getSession("ID");
		String rtn = null;
		try {
			rtn = Check_Duplicate(args, user_id);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
		}
		return getSepoaOut();
	}

	private String Check_Duplicate(String val, String user_id) throws Exception {
		String rtn = null;
		String count = "";
		String[][] str = new String[1][2];

		ConnectionContext ctx = getConnectionContext();
		try {
			String house_code = info.getSession("HOUSE_CODE");

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code",house_code );

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx,wxp.getQuery());

			String[] args = { val };
			rtn = sm.doSelect(args);
			SepoaFormater wf = new SepoaFormater(rtn);
			str = wf.getValue();
			count = str[0][0];
			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("Check_Duplicate:" + e.getMessage());
		} 
		
		return count;
	}

	public SepoaOut getMenuName(String args) {
		try {
			String rtn = null;

			rtn = et_getMenuName(args);
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

	private String et_getMenuName(String url) throws Exception {

		String rtn = null;
		String house_code = info.getSession("house_code");

		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code",house_code );
			wxp.addVar("url",url );

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			rtn = sm.doSelect((String[])null);

			if (rtn == null)
				throw new Exception("SQL Manager is Null");
		} catch (Exception e) {
			throw new Exception("et_getMenuName:" + e.getMessage());
		} 
		
		
		return rtn;
	}
}
