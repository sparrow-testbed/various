package sepoa.svc.co;

import java.util.Arrays;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class CO_012 extends SepoaService {
	String processId = "P60";
	String language = "KO"; // info.getSession("LANGUAGE"); Session��ü�� ��� User��
							// ���� Util������ ���� ���ǰ�ü�� ������� �ʴ´�.

	// String user_id = "LEPPLE";//info.getSession("ID");
	String user_id = info.getSession("ID");

//	Message msg = new Message(language, processId);
	Message msg = null;

	public CO_012(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		msg = new Message(info, processId);
		setVersion("1.0.0");
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

	/* Display _icomptgl */
	public sepoa.fw.srv.SepoaOut getMainternace(String[] args) {
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
		String house_code = info.getSession("HOUSE_CODE");

		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" select                               \n ");
			tSQL.append(" use_flag,code,                       \n ");
			tSQL.append(" text1,text2,text3,flag ,text4        \n ");
			tSQL.append(" from scode                        \n ");
			tSQL.append(" where type = 'S000'               \n ");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
			tSQL.append("   and " + DB_NULL_FUNCTION +"(del_flag, 'N') = 'N' \n ");
			tSQL.append("   and house_code = '" + house_code + "' \n ");
			tSQL.append(" <OPT=F,S> and code like ? </OPT>     \n ");
			tSQL.append(" <OPT=F,S> and flag like ? </OPT>     \n ");
			tSQL.append(" <OPT=F,S> and  ( text1 like ? </OPT> \n ");
			tSQL.append(" <OPT=F,S> or     text2 like ? </OPT> \n ");
			tSQL.append(" <OPT=F,S> or text3 like ? </OPT>     \n ");
			tSQL.append(" <OPT=F,S> ) and text4 like ? </OPT>  \n ");
			tSQL.append("  and code != 'ID' and code != 'REVIEW'   \n ");
			tSQL.append("  order by code                           \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());
			rtn = sm.doSelect(args);

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			throw new Exception("getMainternace:" + e.getMessage());
		} finally {
			// Release();
		}

		return rtn;
	}

	/**
	 * �����˾� �ڵ� ���� �� ��ȸ
	 */
	public sepoa.fw.srv.SepoaOut getDisplay(String args) {
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
			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" select text2,use_flag ,flag,         \n ");
			tSQL.append("      text1,text3,text4,text5         \n ");
			tSQL.append(" from scode                        \n ");
			tSQL.append(" where type = 'S000'  and " + DB_NULL_FUNCTION +"(del_flag, 'N') = 'N' \n ");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
			tSQL.append(" <OPT=F,S> and code = ? </OPT>        \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());
			String[] args = { val };
			rtn = sm.doSelect(args);

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			throw new Exception("getMainternace:" + e.getMessage());
		} finally {
			// Release();
		}

		return rtn;
	}

	/**
	 * Save
	 */
	public SepoaOut setSave(String[] setData) {
		try {
			String user_id = info.getSession("ID");
			String HOUSE_CODE = info.getSession("HOUSE_CODE");

			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			/*
			 * setData : Table���� ������ Data status : C:Create, R:Replace, D:Delete
			 */
			int rtn = et_setSave(setData, cur_date, cur_time, user_id,
					HOUSE_CODE);

			setValue("Insert Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
			Logger.err.println(this, e.getMessage());

			// log err
		}

		return getSepoaOut();
	}

	private int et_setSave(String[] setData, String cur_date, String cur_time,
			String user_id, String HOUSE_CODE) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" INSERT INTO scode ");
			tSQL.append(" (TYPE ,CODE , TEXT2, FLAG, TEXT1, TEXT3, TEXT4,  ");
			tSQL.append(" ADD_DATE, ADD_TIME, ADD_USER_ID, ");
			tSQL.append(" CHANGE_DATE , CHANGE_TIME , CHANGE_USER_ID , ");
			tSQL.append(" USE_FLAG, TEXT5, DEL_FLAG, LANGUAGE ) ");
			tSQL.append(" VALUES ('S000' , ?, ?, ?, ?, ?, ?,  '" + cur_date
					+ "','" + cur_time + "','" + user_id + "' ,  ");
			tSQL.append(" '" + cur_date + "','" + cur_time + "','" + user_id
					+ "' , ?, ?, 'N', '" + info.getSession("LANGUAGE") + "'  ) ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());

			// �ѱ�� ����Ÿ�� type : String S, Number N(int, double ��� ����.)
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S" };

			String[][] tmp = new String[1][];
			tmp[0] = setData;

			rtn = sm.doInsert(tmp, type);

			if (rtn == -1) {
				throw new Exception("SQL Manager is Null");
			} else {
				Commit();
			}

			Commit();
		} catch (Exception e) {
			Rollback();
			throw new Exception("et_setSave:" + e.getMessage());
		} finally {
			// Release();
		}

		return rtn;
	}

	/**
	 * �˾� �ڵ��� ������ �����Ѵ�.
	 */
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

			// log err
		}

		return getSepoaOut();
	}

	private int et_setChange(String[] setData, String cur_date,
			String cur_time, String user_id) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		try {
			String HOUSE_CODE = info.getSession("HOUSE_CODE");

			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" UPDATE scode ");
			tSQL
					.append(" SET TEXT2 = ?, USE_FLAG =? ,FLAG = ?, TEXT1 = ?, TEXT3 = ?, TEXT4 = ?,  TEXT5 = ?, ");
			tSQL.append(" ADD_DATE = '" + cur_date + "', ADD_TIME = '"
					+ cur_time + "', ADD_USER_ID = '" + user_id + "', ");
			tSQL.append(" CHANGE_DATE = '" + cur_date + "', CHANGE_TIME = '"
					+ cur_time + "', CHANGE_USER_ID = '" + user_id
					+ "', DEL_FLAG = 'N' ");
			tSQL.append(" WHERE TYPE = 'S000'  ");
			tSQL.append(" AND CODE = ?  ");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());

			// �ѱ�� ����Ÿ�� type : String S, Number N(int, double ��� ����.)
			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S" };
			String[][] tmp = new String[1][];
			tmp[0] = setData;

			rtn = sm.doInsert(tmp, type);
			Commit();
		} catch (Exception e) {
			// Rollback();
			throw new Exception("et_setSave:" + e.getMessage());
		} finally {
			// Release();
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
			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" delete from scode ");
			tSQL.append(" where type = 'S000' ");
			tSQL.append(" and  CODE = ?  ");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());

			// �ѱ�� ����Ÿ�� type : String S, Number N(int, double ��� ����.)
			String[] type = { "S" };

			rtn = sm.doDelete(setData, type);

			if (rtn == -1) {
				throw new Exception("SQL Manager is Null");
			} else {
				Commit();
			}
		} catch (Exception e) {
			throw new Exception("et_setDelete:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	public SepoaOut setReview(String[] setData) {
		String user_id = info.getSession("ID");

		try {
			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			int rtn = setReview(setData, cur_date, cur_time, user_id);

			setValue("Change Row=" + rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println(user_id, this, "Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0002"));

			// log err
		}

		return getSepoaOut();
	}

	private int setReview(String[] setData, String cur_date, String cur_time,
			String user_id) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();

		try {
			String HOUSE_CODE = info.getSession("HOUSE_CODE");
			StringBuffer tSQL = new StringBuffer();
			tSQL.append(" update scode ");
			tSQL
					.append(" set text2 = ?, flag = ?, text1 = ?, text3 = ?, text4 = ?, use_flag =? , ");
			tSQL.append(" ADD_DATE = '" + cur_date + "', ADD_TIME = '"
					+ cur_time + "', ADD_USER_ID = '" + user_id + "', ");
			tSQL.append(" CHANGE_DATE = '" + cur_date + "', CHANGE_TIME = '"
					+ cur_time + "', CHANGE_USER_ID = '" + user_id + "' ");
			tSQL.append(" where type = 'S000'  ");
			tSQL.append(" and CODE = 'REVIEW'  ");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());

			// �ѱ�� ����Ÿ�� type : String S, Number N(int, double ��� ����.)
			String[] type = { "S", "S", "S", "S", "S", "S" };
			String[][] tmp = new String[1][];
			tmp[0] = setData;

			rtn = sm.doInsert(tmp, type);
			Commit();
		} catch (Exception e) {
			// Rollback();
			throw new Exception("et_setSave:" + e.getMessage());
		} finally {
			// Release();
		}

		return rtn;
	}

	/* �ߺ�üũ */
	public SepoaOut getDuplicate(String args) {
		String user_id = info.getSession("ID");
		String rtn = null;

		try {
			// Logger.debug.println(user_id,this,"######getDuplicate#######");
			// Isvalue(); ....
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
			StringBuffer tSQL = new StringBuffer();

			String HOUSE_CODE = info.getSession("HOUSE_CODE");
			tSQL.append(" select ");
			tSQL.append(" count(*) ");
			tSQL.append(" from scode ");
			tSQL.append(" where type = 'S000'  ");
			tSQL.append(" <OPT=F,S> and code = ? </OPT> ");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());

			String[] args = { val };
			rtn = sm.doSelect(args);

			SepoaFormater wf = new SepoaFormater(rtn);
			str = wf.getValue();
			count = str[0][0];

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			throw new Exception("Check_Duplicate:" + e.getMessage());
		} finally {
			// Release();
		}

		return count;
	}

	/**
	 * sql �� ��Ȯ���� Ȯ���ϱ� ���� �ʿ��� method
	 */
	public SepoaOut VerifyDB(String args) {
		boolean existwhere = false; // where ���� �ִ��� ����
		boolean existorder = false; // order ���� �ִ��� ����
		boolean existgroup = false; // group ���� �ִ��� ����

		int index = 0;

		int indexwhere = 0;
		int indexorder = 0;
		int indexgroup = 0;

		String user_id = info.getSession("ID");
		String[] v = new String[10];
		String[] change = new String[2];

		// Logger.debug.println(user_id,this,"args = " + args);
		String pargs = "";

		// ? -> ' '�ٲ�
		for (int i = 0; i < args.length(); i++) {
			if (args.charAt(i) == '?') {
				change[0] = args.substring(0, i);
				change[1] = args.substring(i + 1, args.length());
				args = change[0] + " '' " + change[1];
			}
		}

		// rownum = 1 �� sql �� ���̱� ���� �۾�
		indexwhere = args.lastIndexOf("WHERE");

		if (indexwhere == -1) {
			;
		}

		// where ���.
		else { // where �ִ�.
			existwhere = true;
		}

		indexorder = args.lastIndexOf("ORDER BY");

		if ((indexorder == -1) || (indexorder < indexwhere)) { // order�� not
																// exist ��
			;
		} else { // order �� �ִ�.
			existorder = true;

			v[1] = args.substring(0, indexorder);
			// ~order ��
			v[2] = args.substring(indexorder, args.length());
		}

		// GROUP BY ���� ���� rownum = 1 �� �̰� �տ� ���ƾ� �Ѵ�.
		// order by�� group by �ڿ� ��ġ������ �Ű澵 �ʿ����.
		indexgroup = args.lastIndexOf("GROUP BY");

		if ((indexgroup == -1) || (indexgroup < indexwhere)) { // group�� not
																// exist ��
			;
		} else { // group�� �ִ�.
			existgroup = true;

			v[1] = args.substring(0, indexgroup);
			// ~group ��
			v[2] = args.substring(indexgroup, args.length());
		}

		/*
		 * Logger.debug.println(user_id,this,"indexwhere = " + indexwhere);
		 * Logger.debug.println(user_id,this,"indexorder = " + indexorder);
		 * Logger.debug.println(user_id,this,"existwhere = " + existwhere);
		 * Logger.debug.println(user_id,this,"existorder = " + existorder);
		 * Logger.debug.println(user_id,this,"existgroup = " + existgroup);
		 */
		if ((existwhere == false)
				&& ((existorder == false) || (existgroup == false))) {
			pargs = args + " WHERE ROWNUM = 1 ";
		}

		if ((existwhere == true)
				&& ((existorder == false) || (existgroup == false))) {
			pargs = args + " AND ROWNUM = 1 ";
		}

		if ((existwhere == false)
				&& ((existorder == true) || (existgroup == true))) {
			pargs = v[1] + " WHERE ROWNUM = 1 " + v[2];
		}

		if ((existwhere == true)
				&& ((existorder == true) || (existgroup == true))) {
			pargs = v[1] + " AND ROWNUM = 1 " + v[2];
		}

		// Logger.debug.println(user_id,this,"pargs = " + pargs);
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
		String[][] str = new String[1][2];

		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer tSQL = new StringBuffer();

			tSQL.append(val);

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());

			rtn = sm.doSelect();

			SepoaFormater wf = new SepoaFormater(rtn);

			/*
			 *
			 * Statement stmt=ctx.createStatement(); ResultSet rs =
			 * stmt.executeQuery(tSQL.toString());
			 *
			 * while (rs.next()) {
			 *
			 * rtn = rs.getString(1).toString();
			 *  }
			 *
			 */

			// str = wf.getValue();
			// count = str[0][0];
			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}

			resultv = "Verified SQL Successfully";
		} catch (Exception e) {
			// throw new Exception("Check_Duplicate:"+e.getMessage());
			resultv = e.getMessage();
		}

		return resultv;
	}

	/* � �ڵ���� ������ �ʴ� �ڵ����� ã�Ƽ� �����ش�. */
	public sepoa.fw.srv.SepoaOut getCode(String[] args) {
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
			StringBuffer tSQL = new StringBuffer();
			/*
			 * �Ʒ� SQL �����ؾ� ��. 2007.05.31 �̴��
			 */
			tSQL.append(" 	select '" + args[0] + "'||code 													\n");
			tSQL.append("  	from (  																		\n");
			tSQL
					.append(" 		select LTRIM(RTRIM(to_char(rownum,'0000'))) as code 								\n");
			tSQL.append("  		from scode 																\n");
			tSQL.append("		where type ='S000' limit 10000 	\n");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
			tSQL.append(" 	minus 																			\n");
			tSQL.append("		select substr(code,3) 														\n");
			tSQL.append(" 		from scode 																\n");
			tSQL.append(" 		where type ='S000' 															\n");
			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
			tSQL.append(" <OPT=F,S> and flag = ? 	                   </OPT>								\n");
			tSQL.append(" 		)																			\n");
			tSQL.append(" 	limit 1															\n");

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL
					.toString());
			result = sm.doSelect(args);

			if (result == null) {
				throw new Exception("SQLManager is null");
			}
		} catch (Exception ex) {
			throw new Exception("et_getCode()" + ex.getMessage());
		}

		return result;
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
	 * �޼ҵ�� : et_getCodeMaster Description : ���� �������� Argument :
	 */
	private String et_getCodeMaster(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("house_code");
		String language = info.getSession("LANGUAGE");
		StringBuffer sql = new StringBuffer();

		ConnectionContext ctx = getConnectionContext();

		try {
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

    		sm.removeAllValue();
    		sql.delete(0, sql.length());
			sql.append(" SELECT CODE, " + DB_NULL_FUNCTION +"(text1, ' '), " + DB_NULL_FUNCTION +"(text2,' ') ");
			sql.append(" FROM scode ");
			sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code  + "' AND LANGUAGE = '"+language+"'  ");
			sql.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
			rtn = sm.doSelect(sql.toString());

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}

			SepoaFormater wf = new SepoaFormater(rtn);
            if(wf.getRowCount() <= 0)
            {
            	sm.removeAllValue();
            	sql.delete(0, sql.length());
            	sql.append(" SELECT CODE, nvl(text1, ' '), nvl(text2,' ') ");
            	sql.append(" FROM scode ");
            	sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "' AND LANGUAGE = 'KO'  ");
                rtn = sm.doSelect(sql.toString());
            }
		} catch (Exception e) {
			throw new Exception("et_getCodeMaster:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * �޼ҵ�� : getCodeColumn() Description : 1. EP �ڵ� ��ȸ ( oep_pp_lis3.jsp���� ȣ�� )
	 * 2. getCodeColumn() call 3. ����κ� �� �������� �ۼ��� : 2001.08.03
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
	 * �޼ҵ�� : et_getCodeColumn Description : ���� �������� Argument :
	 */
	private String et_getCodeColumn(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("house_code");
		String language = info.getSession("LANGUAGE");
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sql = new StringBuffer();

		try {
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

    		sm.removeAllValue();
    		sql.delete(0, sql.length());
			sql.append(" SELECT TEXT3 ");
			sql.append(" FROM scode ");
			sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "' AND LANGUAGE = '"+language+"'  ");
			rtn = sm.doSelect(sql.toString());

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}

			SepoaFormater wf = new SepoaFormater(rtn);
            if(wf.getRowCount() <= 0)
            {
        		sm.removeAllValue();
        		sql.delete(0, sql.length());
        		sql.append(" SELECT TEXT3 ");
        		sql.append(" FROM scode ");
        		sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "' AND LANGUAGE = 'KO'  ");
                rtn = sm.doSelect(sql.toString());
            }
		} catch (Exception e) {
			throw new Exception("et_getCodeColumn:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	// /////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * �޼ҵ�� : getCodeSearch() Description : 1. Code �ڵ� ��ȸ ( oep_pp_lis2.jsp���� ȣ�� )
	 * 2. et_getCodeSearch() call �ۼ��� : 2001.09.21
	 */
	public SepoaOut getCodeSearch(String code, // CODE_ID
			String[] values) { // ��ȸ DESCRIPTION

		try {
			String rtn = "";

			// Query ����κ� Call
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
	 * �޼ҵ�� : et_getCodeSearch Description : Code ������ ��ȸ�Ѵ�. Argument :
	 */
	private String et_getCodeSearch(String code, // CODE_ID
			String[] values) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			StringBuffer sql = new StringBuffer();

			// Code ID�� ��ϵ� Query���� Select�� �´�.
			String query = "";
			query = et_getCodeQuery(code);

			SepoaFormater wf = new SepoaFormater(query);

			query = "";
			query = wf.getValue("TEXT4", 0);

			// Logger.debug.println(user_id+">>>>>>>>>>>>>>>>>>>>>>>>",this,query);
			String tmp = "";
			String tmp_s = ""; // ���ڷ� ������ �պκ��� ��´�.
			String tmp_e = ""; // ���ڷ� ������ �޺κ��� ��´�.

			/**
			 * query���� ����ǥ?�� ������ŭ values�� �����ڰ� ������ ��� �ϴµ�(JSP����) �׷��� ���� ������ sql ���� �߻��Ѵ�.
			 * values�� ������ values�� ��(�⺻��)���� �ؼ� ��ȸ ����(where)�� ��ü��ȸ �ϴ� ���� �־ ����� �߻����� �ʵ��� �Ѵ�.
			 * ��� : ����ǥ?�� ������ŭ values�� �������� ������ ""������ ���� ?�� values�� ������ �����.
			 * as of 131108 ysh
			 * */
			int qCount = 0;	// query���� ����ǥ?���� 
			for(int index = 0 ; index < query.length(); index++){
				if(query.charAt(index) == '?'){
					qCount++;
				}
			}
			if(values == null){
				values = new String[0];
			}
			
			int v_count = values.length;	//values�� ����
			String[] temp = null;
			if(qCount > v_count){			//values�������� ����ǥ?������ ������
				temp = new String[qCount];
				System.arraycopy(values, 0, temp, 0, values.length);		//values ��ü ������ temp�� �����Ѵ�.
				for(int remain = v_count ; remain < qCount ; remain++){		//�����ϰ� ���� ��(qCount - v_count)�� ��""���� ä���.
					temp[remain] = ""; 
				}
				values = temp;
			}
			//qCount == v_count�� ���� �״�� ���� �ȴ�.
			//qCount < v_count�� ���� ������ qCount ������ŭ�� for�� ���⶧���� �����.(������ values�� ���õȴ�.)
			/**
			 * 
			 * */
			
/*			System.out.println("����values="+Arrays.toString(values));
			System.out.println("qCount="+qCount);
			System.out.println("v_count="+v_count);*/
			if (values != null) {
				// �Ķ���Ͱ� Set
				for (int i = 0; i < qCount ; i++) {
					if (values[i] == null) {
						values[i] = "";
					}
//					Logger.debug.println("values["+i+"]######===========>"+ values[i]);

					// Logger.debug.println(user_id+">>>>>>>>>>>>>>>>>>>>>>>>",this,"values["+i+"]==="+values[i]);
					// System.out.println("values["+i+"]==="+values[i]);
					int index_start = query.indexOf("?");
					// ���ڷ� ������ �պκ�
					tmp_s = query.substring(0, index_start);

//					Logger.debug.println("tmp_s==========>"+tmp_s);
					// ���ڷ� ������ �޺κ�
					tmp_e = query.substring(index_start + 1);
//					Logger.debug.println("tmp_e===========>"+tmp_e);
					// ���ڰ�����, like���� ���� ���ڰ����� �����Ѵ�.
					if (tmp_e.length() != 0) {
						tmp = query.substring(index_start - 1, index_start + 2);
					}
//					Logger.debug.println("query11111=============>" + tmp);
					// like���� ���� ���ڰ��� ���
					if (tmp.equals("%?%")) {
						query = tmp_s + values[i] + tmp_e;
//						Logger.debug.println("query222222==========="+ query);
						// System.out.println("query_%?%==="+query);
					} else {
						query = tmp_s + " '" + values[i] + "' " + tmp_e;
//						Logger.debug.println("query333333==========>"+ query);
					}
//					Logger.debug.println("query444444444==========>"+ query);

				}
//				Logger.debug.println("query55555555==========>"+ query);

			}
//			Logger.debug.println("query6666666==========>"+ query);


			// ROWNUM <= 500 �� ���ѳ��� 4.11 �� �κ��� �ʿ����� �������̶� �Ǵܵ�.
			// frame work�� �������ѱ���� ����
			// query = addrownum(query);
//			Logger.debug.println(user_id, this, ")))))))))))) query ===>"
//					+ query);

			// long startTime = System.currentTimeMillis();// �ð�üũ ��
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, query);
			rtn = sm.doSelect();
			// long endTime = System.currentTimeMillis();// �ð�üũ ��

			// Logger.debug.println(user_id,this,"DelayTime = " + (endTime -
			// startTime ));
			// Logger.debug.println(user_id, this, "rtn ========" + rtn +
			// "--------");

			// System.out.println("Final=======RTN==="+rtn);
			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			 throw new Exception("et_getCodeSearch:"+stackTrace(e));
		} finally {
		}

		return rtn;
	}

	/**
	 * ListBoxArr���� ȣ���Ѵ�.
	 *
	 * <pre>
	 * ��ȸ�ϰ����ϴ� �ڵ���� �Ѳ��� �����´�.
	 * et_getCodeSearchArr, et_getCodeQueryArr �� �̿��Ѵ�.
	 * </pre>
	 *
	 * @param code
	 * @param values
	 * @return
	 */
	public SepoaOut getCodeSearchArr(String[] codes, String[] params) {
		try {
			String rtn = "";

			for (int i = 0; i < codes.length; i++) {
				String[] values = CommonUtil.getTokenData(params[i], "#");
				rtn = et_getCodeSearchArr(codes[i], values);
				setValue(rtn);
			}

			setStatus(1);
			setMessage(msg.getMessage("0001"));
		} catch (Exception e) {
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(user_id, this, e.getMessage());
		}

		return getSepoaOut();
	}

	private String et_getCodeSearchArr(String code, String[] values)
			throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();

		try {
			String query = et_getCodeQuery(code);

			SepoaFormater wf = new SepoaFormater(query);
			query = wf.getValue("TEXT4", 0);

			String tmp = "";
			String tmp_s = ""; // ���ڷ� ������ �պκ��� ��´�.
			String tmp_e = ""; // ���ڷ� ������ �޺κ��� ��´�.

			if (values != null) {
				for (int i = 0; i < values.length; i++) {
					if (values[i] == null) {
						values[i] = "";
					}

					int index_start = query.indexOf("?");

					tmp_s = query.substring(0, index_start);
					tmp_e = query.substring(index_start + 1);

					if (tmp_e.length() != 0) {
						tmp = query.substring(index_start - 1, index_start + 2);
					}

					if (tmp.equals("%?%")) {
						query = tmp_s + values[i] + tmp_e;

						continue;
					}

					query = tmp_s + " '" + values[i] + "' " + tmp_e;
				}
			}

			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, query);
			rtn = sm.doSelect();

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			// throw new Exception("et_getCodeSearch:"+stackTrace(e));
			rtn = "";
		}

		return rtn;
	}

	// rownum <= 500 �߰��ϴ� �� ����
	private String addrownum(String args) {
		boolean existwhere = false; // where ���� �ִ��� ����
		boolean existorder = false; // order ���� �ִ��� ����
		boolean existgroup = false; // group ���� �ִ��� ����

		int index = 0;

		int indexwhere = 0;
		int indexorder = 0;
		int indexgroup = 0;

		String user_id = info.getSession("ID");
		String[] v = new String[10];
		String pargs = "";
		// rownum <= 500 �� sql �� ���̱� ���� �۾�
		indexwhere = args.lastIndexOf("WHERE");

		if (indexwhere == -1) {
			;
		}

		// where ���.
		else { // where �ִ�.
			existwhere = true;
		}

		indexorder = args.lastIndexOf("ORDER BY");

		if ((indexorder == -1) || (indexorder < indexwhere)) { // order�� not
																// exist ��
			;
		} else { // order �� �ִ�.
			existorder = true;

			v[1] = args.substring(0, indexorder);
			// ~order ��
			v[2] = args.substring(indexorder, args.length());
		}

		// GROUP BY ���� ���� rownum = 500 �� �̰� �տ� ���ƾ� �Ѵ�.
		// order by�� group by �ڿ� ��ġ������ �Ű澵 �ʿ����.
		indexgroup = args.lastIndexOf("GROUP BY");

		if ((indexgroup == -1) || (indexgroup < indexwhere)) { // group�� not
																// exist ��
			;
		} else { // group�� �ִ�.
			existgroup = true;

			v[1] = args.substring(0, indexgroup);
			// ~group ��
			v[2] = args.substring(indexgroup, args.length());
		}

		/*
		 * Logger.debug.println(user_id,this,"indexwhere = " + indexwhere);
		 * Logger.debug.println(user_id,this,"indexorder = " + indexorder);
		 * Logger.debug.println(user_id,this,"existwhere = " + existwhere);
		 * Logger.debug.println(user_id,this,"existorder = " + existorder);
		 * Logger.debug.println(user_id,this,"existgroup = " + existgroup);
		 */
		if ((existwhere == false)
				&& ((existorder == false) || (existgroup == false))) {
			pargs = args + " WHERE ROWNUM <= 500 ";
		}

		if ((existwhere == true)
				&& ((existorder == false) || (existgroup == false))) {
			pargs = args + " AND ROWNUM <= 500 ";
		}

		if ((existwhere == false)
				&& ((existorder == true) || (existgroup == true))) {
			pargs = v[1] + " WHERE ROWNUM <= 500 " + v[2];
		}

		if ((existwhere == true)
				&& ((existorder == true) || (existgroup == true))) {
			pargs = v[1] + " AND ROWNUM <= 500 " + v[2];
		}

		// Logger.debug.println("JHYOON",this,"pargs = " +
		// SepoaString.replace(pargs,"\n",""));
		return pargs;
	}

	/**
	 * �޼ҵ�� : et_getCodeQuery Description : ���� �������� Argument :
	 */
	private String et_getCodeQuery(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("HOUSE_CODE");
		String language = info.getSession("LANGUAGE");
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer sql = new StringBuffer();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

    		sm.removeAllValue();
    		sql.delete(0, sql.length());
			sql.append(" SELECT TEXT4 ");
			sql.append(" FROM scode ");
			sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "' AND LANGUAGE = '"+language+"' ");
			sql.append("   AND HOUSE_CODE IN ('" + house_code + "', '" + CommonUtil.DEFAULT_HOUSE_CODE + "') ");
			sql.append(" ORDER BY HOUSE_CODE DESC " );
			rtn = sm.doSelect(sql.toString());

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}

			//�ش� ����� �����Ͱ� ���� ���� ������ �ѱ��� �����͸� ������ �´�.
			SepoaFormater wf = new SepoaFormater(rtn);
        	if(wf.getRowCount() <= 0)
        	{
        		sm.removeAllValue();
        		sql.delete(0, sql.length());
        		sql.append(" SELECT TEXT4 ");
        		sql.append(" FROM scode ");
        		sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "' AND LANGUAGE = 'KO'  ");
                sql.append("   AND HOUSE_CODE IN ('" + house_code + "', '" + CommonUtil.DEFAULT_HOUSE_CODE + "') ");
                sql.append(" ORDER BY HOUSE_CODE DESC " );
                rtn = sm.doSelect(sql.toString());
        	}
		} catch (Exception e) {
			throw new Exception("et_getCodeQuery:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * �޼ҵ�� : getCodeFlag() Description : 1. ���񽺵� Ÿ�� ����.
	 *
	 *
	 * �ۼ��� : 2001.08.03
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
	 * �޼ҵ�� : et_getCodeFlag Description : 1. ���񽺵� Ÿ�� ����. Argument :
	 */
//	private String et_getCodeFlag(String code) throws Exception {
//		String rtn = new String();
//		String house_code = info.getSession("house_code");
//		String language = info.getSession("LANGUAGE");
//
//		ConnectionContext ctx = getConnectionContext();
//
//		try {
//			StringBuffer sql = new StringBuffer();
//			sql.append(" SELECT FLAG, TEXT5 ");
//			sql.append(" FROM scode ");
//			sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "'  ");
//
//			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
//					this, ctx, sql.toString());
//			String[] args = {};
//			rtn = sm.doSelect(null);
//
//			if (rtn == null) {
//				throw new Exception("SQL Manager is Null");
//			}
//		} catch (Exception e) {
//			throw new Exception("et_getCodeMaster:" + e.getMessage());
//		} finally {
//		}
//
//		return rtn;
//	}

	private String et_getCodeFlag(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("house_code");
		String language = info.getSession("LANGUAGE");
		ConnectionContext ctx = getConnectionContext();

		try {
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			StringBuffer sql = new StringBuffer();
    		sm.removeAllValue();
    		sql.delete(0, sql.length());
			sql.append(" SELECT FLAG, TEXT5 ");
			sql.append(" FROM scode ");
			sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "' AND LANGUAGE = '"+language+"'  ");
			rtn = sm.doSelect(sql.toString());

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}

			SepoaFormater wf = new SepoaFormater(rtn);

        	if(wf.getRowCount() <= 0)
        	{
        		sql.delete(0, sql.length());
        		sm.removeAllValue();
                sql.append(" SELECT FLAG, TEXT5 ");
                sql.append(" FROM scode ");
                sql.append(" WHERE TYPE = 'S000' AND CODE ='" + code + "' AND LANGUAGE = 'KO'  ");
                rtn = sm.doSelect(sql.toString());
        	}
		} catch (Exception e) {
			throw new Exception("et_getCodeMaster:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	/**
	 * ���� �ڵ� ��ȸ�� ���� ���ȴ�.
	 *
	 * @param code
	 * @return
	 */
	public SepoaOut getCodeFlagArr(String code) {
		String rtn = "";

		try {
			// Query ����κ� Call
			rtn = et_getCodeFlagArr(code);
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

	private String et_getCodeFlagArr(String code) throws Exception {
		String rtn = "";
		String house_code = info.getSession("house_code");

		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer sql = new StringBuffer();
			sql.append(" SELECT FLAG, TEXT5, CODE                    \n");
			sql.append(" FROM scode                               \n");
			sql.append(" WHERE TYPE = 'S000' AND CODE IN (" + code + ")  \n");
			sql.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, sql.toString());
			rtn = sm.doSelect();

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			throw new Exception("et_getCodeMaster:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	// /////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// �ڵ�POPUP Manual��ȸ�� Desc�� �����ش�.
	// /////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * �޼ҵ�� : getPOPUP_Search() Description : 1. Manual�� �Էµ� �ڵ�� �ش� Desc�� ��ȸ�Ѵ�.
	 * 2. getPOPUP_Search() call �ۼ��� : 2001.09.21
	 */
	public SepoaOut getPOPUP_Search(String sql) { // ��ȸ DESCRIPTION

		try {
			String rtn = "";

			// Query ����κ� Call
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
			} // if

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
	 * �޼ҵ�� : et_getPOPUP_Search Description : Code ������ ��ȸ�Ѵ�. Argument :
	 */
	private String et_getPOPUP_Search(String sql) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();

		try {
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, sql);
			rtn = sm.doSelect();

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			throw new Exception("getPOPUP_Search:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	public SepoaOut getEPCodeSearch(String house_code, String com_code,
			String type, String pCode, String pDescription) {
		try {
//			Logger.debug.println(info.getSession("ID"), this,
//					"=====EPCodeSearch Query=====");

			String rtn = "";

			// Query ����κ� Call
			rtn = et_getEPCodeSearch(house_code, com_code, type, pCode,
					pDescription);

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

	private String et_getEPCodeSearch(String house_code, String com_code,
			String type, String pCode, String pDescription) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();

		try {
			StringBuffer sql = new StringBuffer();
			String like_sql = "";
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sql.append(" SELECT code, " + DB_NULL_FUNCTION +"( text1, ' ' ) AS TEXT1, " + DB_NULL_FUNCTION +"( text2, ' ' ) AS TEXT2	\n ");
			sql.append(" FROM scode 														\n ");
			sql.append(sm.addSelectString(" where type= ? 												\n "));
			sm.addStringParameter(type);
			sql.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
			sql.append(" and house_code = '" + house_code + "' \n ");

			if (pCode.length() > 0)
			{
				like_sql = "%" + pCode + "%";
				sql.append(" and upper(" + DB_NULL_FUNCTION + "(code, ' ')) like upper('" + like_sql + "') \n ");


//				if(SEPOA_DB_VENDOR.equals("MYSQL"))
//				{
//					sql.append(sm.addSelectString(" and upper(" + DB_NULL_FUNCTION +"(code, ' ')) like upper('%' ? '%') 				\n "));
//				}
//				else if(SEPOA_DB_VENDOR.equals("MSSQL"))
//				{
//					sql.append(sm.addSelectString(" and upper(" + DB_NULL_FUNCTION +"(code, ' ')) like upper('%'+? +'%') 				\n "));
//				}
//
//				sm.addStringParameter(pCode);
			}

			if (pDescription.length() > 0) {
				like_sql = "%" + pDescription + "%";
				sql.append(" and ( upper(" + DB_NULL_FUNCTION + "(text1, ' ')) like upper('" + like_sql + "') \n ");
				sql.append("     or upper(" + DB_NULL_FUNCTION + "(text2, ' ')) like upper('" + like_sql + "') \n ");
				sql.append(" ) \n ");

//				if(SEPOA_DB_VENDOR.equals("MYSQL"))
//				{
//					sql.append(sm.addSelectString(" and (upper(" + DB_NULL_FUNCTION +"(text1, ' ')) like upper('%' ? '%')   	\n "));
//				}
//				else if(SEPOA_DB_VENDOR.equals("MSSQL"))
//				{
//					sql.append(sm.addSelectString(" and (upper(" + DB_NULL_FUNCTION +"(text1, ' ')) like upper('%'+ ? + '%')   	\n "));
//				}
//				sm.addStringParameter(pDescription);
//
//				if(SEPOA_DB_VENDOR.equals("MYSQL"))
//				{
//					sql.append(sm.addSelectString(" 	or upper(" + DB_NULL_FUNCTION +"(text2, ' ')) like upper('%' ? '%') )	\n "));
//				}
//				else if(SEPOA_DB_VENDOR.equals("MSSQL"))
//				{
//					sql.append(sm.addSelectString(" 	or upper(" + DB_NULL_FUNCTION +"(text2, ' ')) like upper('%' + ? + '%') )	\n "));
//				}
//				sm.addStringParameter(pDescription);
			}

//			sql.append("   and use_flag = 'Y'    												\n ");
			sql.append("   and " + DB_NULL_FUNCTION +"(del_flag, 'N') = 'N'										\n ");
			sql.append(" order by sort_seq, code 												\n ");

			rtn = sm.doSelect(sql.toString());

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			throw new Exception("et_getEPCodeSearch:" + e.getMessage());
		} finally {
		}

		return rtn;
	}

	public SepoaOut getEPCodeMaster(String house_code, String com_code,
			String type) {
		try {
			String rtn = "";
			rtn = et_getEPCodeMaster(house_code, com_code, type);
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

	private String et_getEPCodeMaster(String house_code, String com_code,
			String type) throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		Logger.debug.println("type============>"+type);
		try {
			StringBuffer sql = new StringBuffer();
//			Logger.debug.println(info.getSession("ID"), this,
//					"------------query start(EpCode_Master) !! --------------");
			sql.append(" select code, " + DB_NULL_FUNCTION +"( text1, ' ' ), " + DB_NULL_FUNCTION +"( text2, ' ' ) \n ");
			sql.append(" from scode 									\n ");
			sql.append(" where type = 'M000' and code ='" + type + "'  		\n ");
			sql.append("   and use_flag = 'Y'								\n ");
			sql.append("   and " + DB_NULL_FUNCTION +"(del_flag, 'N') = 'N'		\n ");
			sql.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, sql.toString());
			String[] args = {};
			rtn = sm.doSelect();

			if (rtn == null) {
				throw new Exception("SQL Manager is Null");
			}
		} catch (Exception e) {
			throw new Exception("et_getEPCodeMaster:" + e.getMessage());
		} finally {
		}

		return rtn;
	}
	//�׽�Ʈ
	/*	public static void main(String [] args){
		String[] values = new String[1];
		values[0] = "aaa";
		
		int qCount = 2;	//����ǥ�� 2����
		int v_count = values.length;	//1
		String[] values1 = null;
		if(qCount > v_count){
			values1 = new String[qCount];
			System.arraycopy(values, 0, values1, 0, values.length);
			for(int remain = v_count ; remain < qCount ; remain++){
				values1[remain] = "";	// values ���� �����ϰ�, qCount - v_count ��ŭ ��""���� ä���. 
			}
		}else if(qCount == v_count){
			//values�״�� ���� �ȴ�.
			values1 = values;
		}else if(qCount < v_count){
			//������ qCount ������ŭ�� for�� ���⶧���� �����.(values�� ���õȴ�.)
			values1 = values;
		}
		values[0] = "accc";
		System.out.println(Arrays.toString(values1));
	}*/
}