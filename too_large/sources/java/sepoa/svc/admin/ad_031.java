package sepoa.svc.admin;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;

import sepoa.fw.log.Logger;

import sepoa.fw.msg.Message;

import sepoa.fw.ses.SepoaInfo;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;

import sepoa.fw.util.DocumentUtil;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

import java.rmi.RemoteException;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

public class AD_031 extends SepoaService
{
	private static String resultvalue_1 = "";
	//private String ID = info.getSession("ID");

	public AD_031(String opt, SepoaInfo info) throws SepoaServiceException
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

	public SepoaOut expandTree(SepoaInfo wi, String menu_object_code, String menu_field_code, String menu_parent_field_code, String menu_name, String screen_id, String menu_link_flag, String child_flag, String order_seq, String use_flag, String status, String sub_flag, String folder_flag, String flag) throws RemoteException
	{
		ConnectionContext ctx = getConnectionContext();

		try
		{
			String user_id = wi.getSession("ID");
			String house_code = wi.getSession("HOUSE_CODE");
			String rtn = null;

			String strMenuFieldCode;

			Vector multilang_id = new Vector();
			multilang_id.addElement("MESSAGE");
			//text = MessageUtil.getMessage(wi, multilang_id);
			

			//DaguriSql sm = new DaguriSql(wi.getSession("ID"), this, ws.getConnection("TRANSACTION", wi, this, "expandTree"));
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			

			if (status.equals("C"))
			{
				

				int seq = Integer.parseInt(order_seq);
				++seq;
				strMenuFieldCode = processMenuFieldDocNumber(wi, sm);
				printDebug(wi, "채번결과 :" + strMenuFieldCode);

				if (menu_parent_field_code.equals("*") && !menu_field_code.equals(""))
				{
					menu_parent_field_code = menu_field_code;
				}
				else if (folder_flag.equals("Y") && sub_flag.equals("Y"))
				{
					menu_parent_field_code = menu_field_code;
				}

				if (et_CreateNode(wi, sm, menu_object_code, strMenuFieldCode, menu_parent_field_code, menu_name, screen_id, menu_link_flag, child_flag, String.valueOf(seq), use_flag, status) == -1)
				{
					try
					{
						Rollback();
					}
					catch (Exception et)
					{
						printDebug(wi, "Exception e =" + et.toString());
					}

					setFlag(false);
					setMessage("Create Faild");
					setStatus(0);

					return getSepoaOut();
				}
			}
			else if (status.equals("D"))
			{
				

				if (et_RemoveNode(sm, house_code, user_id, menu_object_code, menu_field_code, use_flag) == -1)
				{
					try
					{
						Rollback();
					}
					catch (Exception et)
					{
						printDebug(wi, "Exception e =" + et.toString());
					}

					setFlag(false);
					setMessage("Remove Faild");
					setStatus(0);

					return getSepoaOut();
				}
			}
			else if (status.equals("R"))
			{
				

				if (et_SetNode(wi, sm, menu_object_code, menu_field_code, menu_parent_field_code, menu_name, screen_id, menu_link_flag, child_flag, use_flag, status) == -1)
				{
					try
					{
						Rollback();
					}
					catch (Exception et)
					{
						printDebug(wi, "Exception e =" + et.toString());
					}

					setFlag(false);
					setMessage("Update Faild");
					setStatus(0);

					return getSepoaOut();
				}
			}

			
			rtn = et_ExpandTree(sm, house_code, user_id, menu_object_code, flag);
			setValue(rtn);
			setStatus(1);
			Commit();
		}
		catch (sepoa.fw.srv.SepoaServiceException wse)
		{
		    
			printDebug(wi, "Exception e =" + wse.toString());

			SepoaOut woEx = new SepoaOut();
			woEx.status = 0;
			woEx.message = wse.toString();

			return woEx;
		}
		catch (Exception e)
		{
			try
			{
				Rollback();
			}
			catch (Exception et)
			{
				printDebug(wi, "Exception e =" + et.toString());
			}

			printDebug(wi, "Exception e =" + e.toString());

			SepoaOut woEx = new SepoaOut();
			woEx.status = 0;
			woEx.message = e.toString();

			return woEx;
		}
		finally
		{
			Release();
		}

		return getSepoaOut();
	}

	private String et_ExpandTree(ParamSql sm, String house_code, String user_id, String menu_object_code, String flag) throws Exception
	{
		String rtn = null;

		String addstr = "";
		StringBuffer tSQL = new StringBuffer();

		if (flag.equals("X"))
		{
			addstr = " AND   USE_FLAG = 'Y' ";
		}

		sm.removeAllValue();
		//		tSQL.append( " SELECT LEVEL,MENU_OBJECT_CODE,MENU_FIELD_CODE, \n ");
		//		tSQL.append( " 	   MENU_PARENT_FIELD_CODE,MENU_NAME,SCREEN_ID, \n ");
		//		tSQL.append( " 	   MENU_LINK_FLAG,CHILD_FLAG,ORDER_SEQ,USE_FLAG \n ");
		//		tSQL.append( " FROM MOLDMUDT ");
		//		tSQL.append( " CONNECT BY PRIOR MENU_FIELD_CODE = MENU_PARENT_FIELD_CODE \n ");
		//		tSQL.append("AND MENU_OBJECT_CODE = '"+menu_object_code+"'  \n ");
		//		/*tSQL.append(sm.addSelect( "AND MENU_OBJECT_CODE = ?  "));
		//		sm.addParameter(menu_object_code);*/
		//		tSQL.append(addstr);
		//		tSQL.append( " START WITH MENU_PARENT_FIELD_CODE = '*' \n ");
		//		tSQL.append("AND MENU_OBJECT_CODE = '"+menu_object_code+"'  \n ");
		//		/*tSQL.append(sm.addSelect( "AND MENU_OBJECT_CODE = ?  "));
		//		sm.addParameter(menu_object_code);*/
		//		tSQL.append(addstr);
		//		tSQL.append( " ORDER BY LEVEL,MENU_PARENT_FIELD_CODE,TO_NUMBER(ORDER_SEQ) \n ");
		tSQL.append(" SELECT distinct  \n ");
		tSQL.append("    '' as lvl,  	\n ");
		tSQL.append(" 	M.MENU_OBJECT_CODE,  \n ");
		tSQL.append("   	M.MENU_FIELD_CODE,  \n ");
		tSQL.append("   	M.MENU_PARENT_FIELD_CODE,  \n ");
		tSQL.append("   	M.MENU_NAME,  \n ");
		tSQL.append("   	M.SCREEN_ID,  \n ");
		tSQL.append("   	M.MENU_LINK_FLAG,  \n ");
		tSQL.append("   	M.CHILD_FLAG,  \n ");
		tSQL.append("   	M.ORDER_SEQ,  \n ");
		tSQL.append("   	M.USE_FLAG,  \n ");
		tSQL.append("   	" + DB_NULL_FUNCTION + "(M.MENU_LINK, '') menu_link \n ");
		tSQL.append(" FROM \n ");
		tSQL.append(" (SELECT  \n ");
		tSQL.append("   		A.MENU_OBJECT_CODE,  \n ");
		tSQL.append("   		A.MENU_FIELD_CODE,  \n ");
		tSQL.append("   		A.MENU_PARENT_FIELD_CODE,  \n ");
		tSQL.append("   		A.MENU_NAME,  \n ");
		tSQL.append("   		A.SCREEN_ID,  \n ");
		tSQL.append("   		A.MENU_LINK_FLAG,  \n ");
		tSQL.append("   		A.CHILD_FLAG,  \n ");
		tSQL.append("   		A.ORDER_SEQ,  \n ");
		tSQL.append("   		A.USE_FLAG, \n ");
		tSQL.append("      	B.MENU_LINK \n ");
		tSQL.append("    FROM  SMUGL C, SMULN A LEFT OUTER JOIN SMUID B \n ");
		tSQL.append(" ON A.SCREEN_ID = B.SCREEN_ID \n ");
		tSQL.append(sm.addFixString(" WHERE A.MENU_OBJECT_CODE = ? \n "));
		sm.addStringParameter(menu_object_code);

		tSQL.append(" AND " + DB_NULL_FUNCTION + "(A.DEL_FLAG, 'N') = 'N'  \n ");
		tSQL.append("     AND A.MENU_OBJECT_CODE = C.MENU_OBJECT_CODE \n ");
		tSQL.append("     AND " + DB_NULL_FUNCTION + "(C.DEL_FLAG, 'N') = 'N' \n ");
		tSQL.append("     AND " + DB_NULL_FUNCTION + "(B.DEL_FLAG, 'N') = 'N') M, SMULN B \n ");
		tSQL.append(" WHERE M.MENU_OBJECT_CODE = B.MENU_OBJECT_CODE \n ");
		tSQL.append(" 	AND " + DB_NULL_FUNCTION + "(B.DEL_FLAG, 'N') = 'N' \n ");
		tSQL.append(" 	AND CASE WHEN M.MENU_PARENT_FIELD_CODE = '*' THEN M.MENU_FIELD_CODE \n ");
		tSQL.append(" 			ELSE M.MENU_PARENT_FIELD_CODE \n ");
		tSQL.append(" 		END = B.MENU_FIELD_CODE \n ");
		tSQL.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, to_number(M.ORDER_SEQ) \n ");
	//	tSQL.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, cast(M.ORDER_SEQ as SIGNED) \n ");

		rtn = sm.doSelect(tSQL.toString());

		return rtn;
	}

	private int et_CreateNode(SepoaInfo wi, ParamSql sm, String menu_object_code, String menu_field_code, String menu_parent_field_code, String menu_name, String screen_id, String menu_link_flag, String child_flag, String order_seq, String use_flag, String status) throws Exception
	{
		int rtn = -1;
		String user_id = wi.getSession("ID");
		

		String user_name1 = wi.getSession("NAME_LOC");
		String user_name2 = wi.getSession("NAME_ENG");
		String user_dept = wi.getSession("DEPARTMENT");
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();

		try
		{
			StringBuffer tSQL2 = new StringBuffer();

			

			if (SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				tSQL2.append(" SELECT TO_NUMBER(ORDER_SEQ)+1 AS ORDER_SEQ,MENU_FIELD_CODE FROM SMULN	 \n ");
				tSQL2.append(sm.addFix(" WHERE MENU_OBJECT_CODE = ? 	\n "));
				sm.addParameter(menu_object_code);
				tSQL2.append(sm.addFix(" AND MENU_PARENT_FIELD_CODE= ? 	\n "));
				sm.addParameter(menu_parent_field_code);
				tSQL2.append(sm.addFix(" AND TO_NUMBER(ORDER_SEQ) >= ? 	\n "));
				sm.addParameter(order_seq);
				tSQL2.append(" ORDER BY MENU_PARENT_FIELD_CODE,TO_NUMBER(ORDER_SEQ)	\n ");
			}
			else if (SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				tSQL2.append(" SELECT CAST(ORDER_SEQ as SIGNED)+1 AS ORDER_SEQ, MENU_FIELD_CODE FROM SMULN	 \n ");
				tSQL2.append(sm.addFix(" WHERE MENU_OBJECT_CODE = ? 	\n "));
				sm.addParameter(menu_object_code);
				tSQL2.append(sm.addFix(" AND MENU_PARENT_FIELD_CODE= ? 	\n "));
				sm.addParameter(menu_parent_field_code);
				tSQL2.append(sm.addFix(" AND CAST(ORDER_SEQ as SIGNED) >= ? 	\n "));
				sm.addParameter(order_seq);
				tSQL2.append(" ORDER BY MENU_PARENT_FIELD_CODE, CAST(ORDER_SEQ as SIGNED)	\n ");
			}
			else if (SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				tSQL2.append(" SELECT ORDER_SEQ+1 AS ORDER_SEQ, MENU_FIELD_CODE FROM SMULN	 \n ");
				tSQL2.append(sm.addFix(" WHERE MENU_OBJECT_CODE = ? 	\n "));
				sm.addParameter(menu_object_code);
				tSQL2.append(sm.addFix(" AND MENU_PARENT_FIELD_CODE= ? 	\n "));
				sm.addParameter(menu_parent_field_code);
				tSQL2.append(sm.addFix(" AND ORDER_SEQ >= ? 	\n "));
				sm.addParameter(order_seq);
				tSQL2.append(" ORDER BY MENU_PARENT_FIELD_CODE,ORDER_SEQ	\n ");
			}

			String ret = sm.doSelect(tSQL2.toString());
			SepoaFormater wf = new SepoaFormater(ret);

			/**
			 * 이미 mudt에 코드가 존재하면
			 * update한다.
			 * */
			if (wf.getRowCount() > 0)
			{
				String[] seqs = wf.getValue("ORDER_SEQ");
				String[] codes = wf.getValue("MENU_FIELD_CODE");
				String[][] setData = new String[seqs.length][2];

				for (int i = 0; i < seqs.length; i++)
				{
					setData[i][0] = seqs[i];
					setData[i][1] = codes[i];
				}

				StringBuffer tSQL3 = new StringBuffer();

				for (int a = 0; a < seqs.length; a++)
				{
					sm.removeAllValue();
					tSQL3.delete(0, tSQL3.length());
					tSQL3.append(" UPDATE SMULN SET ORDER_SEQ= ? 	\n ");
					sm.addParameter(setData[a][0]);
					tSQL3.append(" WHERE MENU_OBJECT_CODE = ? 	\n ");
					sm.addParameter(menu_object_code);
					tSQL3.append(" AND   MENU_FIELD_CODE=?		\n ");
					sm.addParameter(setData[a][1]);
					rtn = sm.doUpdate(tSQL3.toString());
				}
			}

			sm.removeAllValue();

			StringBuffer tSQL1 = new StringBuffer();
			tSQL1.append(" 				INSERT 	\n ");
			tSQL1.append(" 			  INTO SMULN(MENU_OBJECT_CODE, \n ");
			tSQL1.append(" 	   		  MENU_FIELD_CODE,MENU_PARENT_FIELD_CODE, \n ");
			tSQL1.append(" 	   		  ORDER_SEQ,MENU_NAME,SCREEN_ID, \n ");
			tSQL1.append(" 	   		  MENU_LINK_FLAG,CHILD_FLAG, \n ");
			tSQL1.append(" 	   		  USE_FLAG,ADD_DATE,ADD_TIME, \n ");
			tSQL1.append(" 	   		  ADD_USER_ID, DEL_FLAG) \n ");
			tSQL1.append(" VALUES( ");
			tSQL1.append(" ? , ");
			sm.addParameter(menu_object_code);
			tSQL1.append(" ? , ");
			sm.addParameter(menu_field_code);
			tSQL1.append(" ? , ");
			sm.addParameter(menu_parent_field_code);
			tSQL1.append(" ? , ");
			sm.addParameter(order_seq);
			tSQL1.append(" ? , ");
			sm.addParameter(menu_name);
			tSQL1.append(" ? , ");
			sm.addParameter(screen_id);
			tSQL1.append(" ? , ");
			sm.addParameter(menu_link_flag);
			tSQL1.append(" ? , ");
			sm.addParameter(child_flag);
			tSQL1.append(" ? , ");
			sm.addParameter(use_flag);
			tSQL1.append(" ? , ");
			sm.addParameter(cur_date);
			tSQL1.append(" ? , ");
			sm.addParameter(cur_time);
			tSQL1.append(" ? , ");
			sm.addParameter(user_id);
			tSQL1.append(" ?  ");
			sm.addParameter("N");
			tSQL1.append("  ) \n ");

			rtn = sm.doInsert(tSQL1.toString());
		}
		catch (Exception e)
		{
			throw new Exception("et_CreateNode:" + e.getMessage());
		}

		return rtn;
	}

	private String processMenuFieldDocNumber(SepoaInfo wi, ParamSql sm) throws Exception
	{
		StringBuffer sql = new StringBuffer();
		String new_menu_field_code = "";
		setFlag(true);
		setMessage("Success.");

		try
		{
			//			sm.removeAllValue();
			//			sql.delete(0, sql.length());
			//
			//			if(SEPOA_DB_VENDOR.equals("ORACLE"))
			//			{
			//				sql.append( "SELECT 'F' || TO_CHAR(SYSDATE, 'YYMM') || MOLDMUDT_SEQ.NEXTVAL MENU_FIELD_CODE \n " );
			//				sql.append("FROM DUAL \n ");
			//				rtn[0] = sm.doSelect(sql.toString());
			//			}
			//			else if(SEPOA_DB_VENDOR.equals("MYSQL"))
			//			{
			//				rtn[0] = new_menu_object_code;
			//			}
			//
			//			if (rtn[0] == null)
			//			{
			//				rtn[1] = "SQL manager is Null";
			//			}
			SepoaOut wo = DocumentUtil.getDocNumber(info, "MUF", "H");

			//menu_object_code = "M" + SepoaString.replace(SepoaString.replace(SepoaDate.getTimeStampString(), ":", ""), "-", "");
			if (wo.status == 1)
			{
				new_menu_field_code = wo.result[0];
			}
			else
			{
				new_menu_field_code = "F" + SepoaString.replace(SepoaString.replace(SepoaDate.getTimeStampString(), ":", ""), "-", "");
			}
		}
		catch (Exception e)
		{
			
			printDebug(wi, e.toString());
			throw new Exception(e.getMessage());
		}

		return new_menu_field_code;
	}

	private int et_SetNode(SepoaInfo wi, ParamSql sm, String menu_object_code, String menu_field_code, String menu_parent_field_code, String menu_name, String screen_id, String menu_link_flag, String child_flag, String use_flag, String status) throws Exception
	{
		int rtn = -1;
		String user_id = wi.getSession("ID");

		String user_name1 = wi.getSession("NAME_LOC");
		String user_name2 = wi.getSession("NAME_ENG");
		String user_dept = wi.getSession("DEPARTMENT");
		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();

		try
		{
			StringBuffer tSQL2 = new StringBuffer();
			

			String ret = "";
			SepoaFormater wf = null;

			if (SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				tSQL2.append(" SELECT MENU_OBJECT_CODE,MENU_FIELD_CODE \n ");
				tSQL2.append(" FROM SMULN \n ");
				tSQL2.append(sm.addFix(" CONNECT BY PRIOR MENU_FIELD_CODE=MENU_PARENT_FIELD_CODE AND MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_object_code);
				tSQL2.append(sm.addFix(" START WITH MENU_FIELD_CODE= ?") + sm.addFix(" AND MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_field_code);
				sm.addParameter(menu_object_code);
				ret = sm.doSelect(tSQL2.toString());
				wf = new SepoaFormater(ret);

				if (wf.getRowCount() > 0)
				{
					String[] obj_codes = wf.getValue("MENU_OBJECT_CODE");
					String[] field_codes = wf.getValue("MENU_FIELD_CODE");
					String[][] setData = new String[obj_codes.length][2];

					for (int i = 0; i < obj_codes.length; i++)
					{
						setData[i][0] = obj_codes[i];
						setData[i][1] = field_codes[i];
					}

					StringBuffer tSQL3 = new StringBuffer();

					for (int a = 0; a < obj_codes.length; a++)
					{
						sm.removeAllValue();
						tSQL3.delete(0, tSQL3.length());
						tSQL3.append(" UPDATE SMULN SET USE_FLAG = ? \n ");
						sm.addParameter(use_flag);
						tSQL3.append(" WHERE MENU_OBJECT_CODE =?	\n ");
						sm.addParameter(setData[a][0]);
						tSQL3.append(" AND   MENU_FIELD_CODE=?	\n ");
						sm.addParameter(setData[a][1]);
						rtn = sm.doUpdate(tSQL3.toString());
					}
				}
			}
			else if (SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				StringBuffer tSQL = new StringBuffer();
				tSQL.append(" SELECT  distinct \n ");
				tSQL.append(" 	M.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   	M.MENU_FIELD_CODE,  \n ");
				tSQL.append("   	M.MENU_PARENT_FIELD_CODE  \n ");
				tSQL.append(" FROM \n ");
				tSQL.append(" (SELECT  \n ");
				tSQL.append("   		A.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   		A.MENU_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_PARENT_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_NAME,  \n ");
				tSQL.append("   		A.SCREEN_ID,  \n ");
				tSQL.append("   		A.MENU_LINK_FLAG,  \n ");
				tSQL.append("   		A.CHILD_FLAG,  \n ");
				tSQL.append("   		A.ORDER_SEQ,  \n ");
				tSQL.append("   		A.USE_FLAG, \n ");
				tSQL.append("      	B.MENU_LINK \n ");
				tSQL.append("    FROM  SMUGL C, SMULN A LEFT OUTER JOIN SMUID B \n ");
				tSQL.append(" ON A.SCREEN_ID = B.SCREEN_ID \n ");
				tSQL.append(sm.addFix(" WHERE A.MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_object_code);

				tSQL.append(" AND IFNULL(A.DEL_FLAG, 'N') = 'N'  \n ");
				tSQL.append("     AND A.MENU_OBJECT_CODE = C.MENU_OBJECT_CODE \n ");
				tSQL.append("     AND IFNULL(C.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append("     AND IFNULL(B.DEL_FLAG, 'N') = 'N') M, SMULN B \n ");
				tSQL.append(" WHERE M.MENU_OBJECT_CODE = B.MENU_OBJECT_CODE \n ");
				tSQL.append(" 	AND IFNULL(B.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append(" 	AND CASE WHEN M.MENU_PARENT_FIELD_CODE = '*' THEN M.MENU_FIELD_CODE \n ");
				tSQL.append(" 			ELSE M.MENU_PARENT_FIELD_CODE \n ");
				tSQL.append(" 		END = B.MENU_FIELD_CODE \n ");
				tSQL.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, cast(M.ORDER_SEQ as SIGNED) \n ");

				SepoaFormater sf = new SepoaFormater(sm.doSelect(tSQL.toString()));
				int size = sf.getRowCount();
				String[][] menutree = new String[size][3];

				for (int i = 0; i < size; i++)
				{
					menutree[i][0] = sf.getValue(i, 0);
					menutree[i][1] = sf.getValue(i, 1);
					menutree[i][2] = sf.getValue(i, 2);
				}

				//*  메뉴트리를 가져오기위한 시작점
				String start_point = menu_field_code;
				String vv = null;
				vv = call_menu_1(menutree, start_point, true);
				Logger.debug.println(info.getSession("ID"), this, "vv------>" + vv);

				SepoaFormater sf_m = new SepoaFormater(vv);

				for (int i = 0; i < sf_m.getRowCount(); i++)
				{
					sm.removeAllValue();
					tSQL.delete(0, tSQL.length());
					tSQL.append(" update smuln set use_flag = ? \n ");
					sm.addParameter(use_flag);

					tSQL.append(" where menu_object_code = ? \n ");
					sm.addParameter(sf_m.getValue("menu_object_code", i));

					tSQL.append("   and menu_field_code = ? \n ");
					sm.addParameter(sf_m.getValue("menu_field_code", i));
					sm.doUpdate(tSQL.toString());
				}
			}

			else if (SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				StringBuffer tSQL = new StringBuffer();
				tSQL.append(" SELECT  distinct \n ");
				tSQL.append(" 	M.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   	M.MENU_FIELD_CODE,  \n ");
				tSQL.append("   	M.MENU_PARENT_FIELD_CODE,  \n ");
				tSQL.append("   	M.ORDER_SEQ  \n ");
				tSQL.append(" FROM \n ");
				tSQL.append(" (SELECT  \n ");
				tSQL.append("   		A.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   		A.MENU_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_PARENT_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_NAME,  \n ");
				tSQL.append("   		A.SCREEN_ID,  \n ");
				tSQL.append("   		A.MENU_LINK_FLAG,  \n ");
				tSQL.append("   		A.CHILD_FLAG,  \n ");
				tSQL.append("   		A.ORDER_SEQ,  \n ");
				tSQL.append("   		A.USE_FLAG, \n ");
				tSQL.append("      	B.MENU_LINK \n ");
				tSQL.append("    FROM  SMUGL C, SMULN A LEFT OUTER JOIN SMUID B \n ");
				tSQL.append(" ON A.SCREEN_ID = B.SCREEN_ID \n ");
				tSQL.append(sm.addFix(" WHERE A.MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_object_code);

				tSQL.append(" AND ISNULL(A.DEL_FLAG, 'N') = 'N'  \n ");
				tSQL.append("     AND A.MENU_OBJECT_CODE = C.MENU_OBJECT_CODE \n ");
				tSQL.append("     AND ISNULL(C.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append("     AND ISNULL(B.DEL_FLAG, 'N') = 'N') M, SMULN B \n ");
				tSQL.append(" WHERE M.MENU_OBJECT_CODE = B.MENU_OBJECT_CODE \n ");
				tSQL.append(" 	AND ISNULL(B.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append(" 	AND CASE WHEN M.MENU_PARENT_FIELD_CODE = '*' THEN M.MENU_FIELD_CODE \n ");
				tSQL.append(" 			ELSE M.MENU_PARENT_FIELD_CODE \n ");
				tSQL.append(" 		END = B.MENU_FIELD_CODE \n ");
				tSQL.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, M.ORDER_SEQ \n ");

				SepoaFormater sf = new SepoaFormater(sm.doSelect(tSQL.toString()));
				int size = sf.getRowCount();
				String[][] menutree = new String[size][3];

				for (int i = 0; i < size; i++)
				{
					menutree[i][0] = sf.getValue(i, 0);
					menutree[i][1] = sf.getValue(i, 1);
					menutree[i][2] = sf.getValue(i, 2);
				}

				//*  메뉴트리를 가져오기위한 시작점
				String start_point = menu_field_code;
				String vv = null;
				vv = call_menu_1(menutree, start_point, true);
				Logger.debug.println(info.getSession("ID"), this, "vv------>" + vv);

				SepoaFormater sf_m = new SepoaFormater(vv);

				for (int i = 0; i < sf_m.getRowCount(); i++)
				{
					sm.removeAllValue();
					tSQL.delete(0, tSQL.length());
					tSQL.append(" update smuln set use_flag = ? \n ");
					sm.addParameter(use_flag);

					tSQL.append(" where menu_object_code = ? \n ");
					sm.addParameter(sf_m.getValue("menu_object_code", i));

					tSQL.append("   and menu_field_code = ? \n ");
					sm.addParameter(sf_m.getValue("menu_field_code", i));
					sm.doUpdate(tSQL.toString());
				}
			}
			sm.removeAllValue();

			StringBuffer tSQL1 = new StringBuffer();

			tSQL1.append(" UPDATE SMULN SET \n ");
			tSQL1.append(" MENU_NAME = ? , \n ");
			sm.addParameter(menu_name);
			tSQL1.append(" SCREEN_ID = ? , \n ");
			sm.addParameter(screen_id);
			tSQL1.append(" ADD_DATE = ? , \n ");
			sm.addParameter(cur_date);
			tSQL1.append(" ADD_TIME = ? , \n ");
			sm.addParameter(cur_time);
			tSQL1.append(" ADD_USER_ID = ? \n ");
			sm.addParameter(user_id);
			tSQL1.append(" WHERE MENU_OBJECT_CODE = ? \n ");
			sm.addParameter(menu_object_code);
			tSQL1.append(" AND   MENU_FIELD_CODE= ? \n ");
			sm.addParameter(menu_field_code);
			rtn = sm.doUpdate(tSQL1.toString());
		}
		catch (Exception e)
		{
			throw new Exception("Exception in UPDATE SMULN :" + e.getMessage());
		}

		return rtn;
	}

	public static String call_menu_1(String[][] menutree, String start_point, boolean flag) throws Exception
	{
		String re = "";
		int cnt = 1;
		Configuration config = new Configuration();
		String column_delimeter = config.getString("sepoa.separator.field");
		String row_delimeter = config.getString("sepoa.separator.line");

		//Logger.debug.println("call_menu start==================>");
		if (flag == true)
		{
			resultvalue_1 = "MENU_COUNT" + column_delimeter + "MENU_OBJECT_CODE" + column_delimeter + "MENU_FIELD_CODE" + column_delimeter + "MENU_PARENT_FIELD_CODE" + column_delimeter + row_delimeter;

			for (int i = 0; i < menutree.length; i++)
			{
				//Logger.debug.println("menutree[i][1]==================>"+menutree[i][1]);
				//Logger.debug.println("menutree==================>"+start_point);
				if (menutree[i][1].equals(start_point))
				{ //PK
					re += (re + cnt + column_delimeter + menutree[i][0] + column_delimeter + menutree[i][1] + column_delimeter + menutree[i][2] + column_delimeter + row_delimeter);
					resultvalue_1 += re;

					//Logger.debug.println("emp[i][0]===>"+emp[i][0]);
					//Logger.debug.println("1111aaa===>"+aaa);
					//v.add(re);
				}
			}
		} //end of if

		//Logger.debug.println("22222aaa===>"+aaa);
		for (int i = 0; i < menutree.length; i++)
		{
			re = "";

			//Logger.debug.println(user_id,this, "======="+emp[i][2]+"//"+emp_no);
			if (menutree[i][2].equals(start_point))
			{ //parent
				cnt = cnt + 1;
				re += (re + cnt + column_delimeter + menutree[i][0] + column_delimeter + menutree[i][1] + column_delimeter + menutree[i][2] + column_delimeter + row_delimeter);

				//v.add(re);
				resultvalue_1 += re;
				call_menu_1(menutree, menutree[i][1], false); //PK
			}

			if (i == (menutree.length - 1))
			{
				cnt = cnt - 1;
			}
		}

		return resultvalue_1;
	}

	private int et_RemoveNode(ParamSql sm, String house_code, String user_id, String menu_object_code, String menu_field_code, String use_flag) throws Exception
	{
		int rtn = -1;

		try
		{
			StringBuffer tSQL2 = new StringBuffer();
			

			String ret = "";
			SepoaFormater wf = null;

			if (SEPOA_DB_VENDOR.equals("ORACLE"))
			{
				tSQL2.append(" SELECT MENU_OBJECT_CODE,MENU_FIELD_CODE \n ");
				tSQL2.append(" FROM SMULN \n ");
				tSQL2.append(sm.addFix(" CONNECT BY PRIOR MENU_FIELD_CODE=MENU_PARENT_FIELD_CODE AND MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_object_code);
				tSQL2.append(sm.addFix(" START WITH MENU_FIELD_CODE= ?") + sm.addFix(" AND MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_field_code);
				sm.addParameter(menu_object_code);
				ret = sm.doSelect(tSQL2.toString());
				wf = new SepoaFormater(ret);

				if(wf.getRowCount() > 0){
					String[] obj_codes=wf.getValue("MENU_OBJECT_CODE");
					String[] field_codes=wf.getValue("MENU_FIELD_CODE");

					StringBuffer tSQL3 = new StringBuffer();
					for ( int a = 0; a < obj_codes.length; a++) {
						sm.removeAllValue();
						tSQL3.delete(0, tSQL3.length());
						tSQL3.append( " DELETE FROM SMULN \n ");
						tSQL3.append( " WHERE MENU_OBJECT_CODE = ? \n ");
						sm.addParameter(obj_codes[a]);
						tSQL3.append( " AND   MENU_FIELD_CODE = ? \n ");
						sm.addParameter(field_codes[a]);
						rtn = sm.doDelete(tSQL3.toString());
					}
				}
			}
			else if (SEPOA_DB_VENDOR.equals("MYSQL"))
			{
				StringBuffer tSQL = new StringBuffer();
				tSQL.append(" SELECT  distinct \n ");
				tSQL.append(" 	M.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   	M.MENU_FIELD_CODE,  \n ");
				tSQL.append("   	M.MENU_PARENT_FIELD_CODE  \n ");
				tSQL.append(" FROM \n ");
				tSQL.append(" (SELECT  \n ");
				tSQL.append("   		A.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   		A.MENU_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_PARENT_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_NAME,  \n ");
				tSQL.append("   		A.SCREEN_ID,  \n ");
				tSQL.append("   		A.MENU_LINK_FLAG,  \n ");
				tSQL.append("   		A.CHILD_FLAG,  \n ");
				tSQL.append("   		A.ORDER_SEQ,  \n ");
				tSQL.append("   		A.USE_FLAG, \n ");
				tSQL.append("      	B.MENU_LINK \n ");
				tSQL.append("    FROM  SMUGL C, SMULN A LEFT OUTER JOIN SMUID B \n ");
				tSQL.append(" ON A.SCREEN_ID = B.SCREEN_ID \n ");
				tSQL.append(sm.addFix(" WHERE A.MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_object_code);

				tSQL.append(" AND IFNULL(A.DEL_FLAG, 'N') = 'N'  \n ");
				tSQL.append("     AND A.MENU_OBJECT_CODE = C.MENU_OBJECT_CODE \n ");
				tSQL.append("     AND IFNULL(C.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append("     AND IFNULL(B.DEL_FLAG, 'N') = 'N') M, SMULN B \n ");
				tSQL.append(" WHERE M.MENU_OBJECT_CODE = B.MENU_OBJECT_CODE \n ");
				tSQL.append(" 	AND IFNULL(B.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append(" 	AND CASE WHEN M.MENU_PARENT_FIELD_CODE = '*' THEN M.MENU_FIELD_CODE \n ");
				tSQL.append(" 			ELSE M.MENU_PARENT_FIELD_CODE \n ");
				tSQL.append(" 		END = B.MENU_FIELD_CODE \n ");
				tSQL.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, cast(M.ORDER_SEQ as SIGNED) \n ");

				SepoaFormater sf = new SepoaFormater(sm.doSelect(tSQL.toString()));
				int size = sf.getRowCount();
				String[][] menutree = new String[size][3];

				for (int i = 0; i < size; i++)
				{
					menutree[i][0] = sf.getValue(i, 0);
					menutree[i][1] = sf.getValue(i, 1);
					menutree[i][2] = sf.getValue(i, 2);
				}

				//*  메뉴트리를 가져오기위한 시작점
				String start_point = menu_field_code;
				String vv = null;
				vv = call_menu_1(menutree, start_point, true);
				Logger.debug.println(info.getSession("ID"), this, "vv------>" + vv);
				SepoaFormater sf_m = new SepoaFormater(vv);

				for (int i = 0; i < sf_m.getRowCount(); i++)
				{
					sm.removeAllValue();
					tSQL.delete(0, tSQL.length());
					tSQL.append( " DELETE FROM SMULN \n ");
					tSQL.append( " WHERE MENU_OBJECT_CODE = ? \n ");
					sm.addParameter(sf_m.getValue("menu_object_code", i));

					tSQL.append( " AND   MENU_FIELD_CODE = ? \n ");
					sm.addParameter(sf_m.getValue("menu_field_code", i));

					rtn = sm.doDelete(tSQL.toString());
				}
			}

			else if (SEPOA_DB_VENDOR.equals("MSSQL"))
			{
				StringBuffer tSQL = new StringBuffer();
				tSQL.append(" SELECT  distinct \n ");
				tSQL.append(" 	M.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   	M.MENU_FIELD_CODE,  \n ");
				tSQL.append("   	M.MENU_PARENT_FIELD_CODE,  \n ");
				tSQL.append("   	M.ORDER_SEQ  \n ");
				tSQL.append(" FROM \n ");
				tSQL.append(" (SELECT  \n ");
				tSQL.append("   		A.MENU_OBJECT_CODE,  \n ");
				tSQL.append("   		A.MENU_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_PARENT_FIELD_CODE,  \n ");
				tSQL.append("   		A.MENU_NAME,  \n ");
				tSQL.append("   		A.SCREEN_ID,  \n ");
				tSQL.append("   		A.MENU_LINK_FLAG,  \n ");
				tSQL.append("   		A.CHILD_FLAG,  \n ");
				tSQL.append("   		A.ORDER_SEQ,  \n ");
				tSQL.append("   		A.USE_FLAG, \n ");
				tSQL.append("      	B.MENU_LINK \n ");
				tSQL.append("    FROM  SMUGL C, SMULN A LEFT OUTER JOIN SMUID B \n ");
				tSQL.append(" ON A.SCREEN_ID = B.SCREEN_ID \n ");
				tSQL.append(sm.addFix(" WHERE A.MENU_OBJECT_CODE = ? \n "));
				sm.addParameter(menu_object_code);

				tSQL.append(" AND ISNULL(A.DEL_FLAG, 'N') = 'N'  \n ");
				tSQL.append("     AND A.MENU_OBJECT_CODE = C.MENU_OBJECT_CODE \n ");
				tSQL.append("     AND ISNULL(C.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append("     AND ISNULL(B.DEL_FLAG, 'N') = 'N') M, SMULN B \n ");
				tSQL.append(" WHERE M.MENU_OBJECT_CODE = B.MENU_OBJECT_CODE \n ");
				tSQL.append(" 	AND ISNULL(B.DEL_FLAG, 'N') = 'N' \n ");
				tSQL.append(" 	AND CASE WHEN M.MENU_PARENT_FIELD_CODE = '*' THEN M.MENU_FIELD_CODE \n ");
				tSQL.append(" 			ELSE M.MENU_PARENT_FIELD_CODE \n ");
				tSQL.append(" 		END = B.MENU_FIELD_CODE \n ");
				tSQL.append(" ORDER BY M.MENU_PARENT_FIELD_CODE, M.ORDER_SEQ  \n ");

				SepoaFormater sf = new SepoaFormater(sm.doSelect(tSQL.toString()));
				int size = sf.getRowCount();
				String[][] menutree = new String[size][3];

				for (int i = 0; i < size; i++)
				{
					menutree[i][0] = sf.getValue(i, 0);
					menutree[i][1] = sf.getValue(i, 1);
					menutree[i][2] = sf.getValue(i, 2);
				}

				//*  메뉴트리를 가져오기위한 시작점
				String start_point = menu_field_code;
				String vv = null;
				vv = call_menu_1(menutree, start_point, true);
				Logger.debug.println(info.getSession("ID"), this, "vv------>" + vv);
				SepoaFormater sf_m = new SepoaFormater(vv);

				for (int i = 0; i < sf_m.getRowCount(); i++)
				{
					sm.removeAllValue();
					tSQL.delete(0, tSQL.length());
					tSQL.append( " DELETE FROM SMULN \n ");
					tSQL.append( " WHERE MENU_OBJECT_CODE = ? \n ");
					sm.addParameter(sf_m.getValue("menu_object_code", i));

					tSQL.append( " AND   MENU_FIELD_CODE = ? \n ");
					sm.addParameter(sf_m.getValue("menu_field_code", i));

					rtn = sm.doDelete(tSQL.toString());
				}
			}
		}
		catch (Exception e)
		{
			throw new Exception("Exception in et_RemoveNode:" + e.getMessage());
		}

		return rtn;
	}

	/**
	 * Refactoring - Extract Method.
	 * */
	private void printDebug(SepoaInfo wi, String rtn)
	{
		Logger.debug.println(wi.getSession("ID"), this, "####" + rtn);
	}
}
