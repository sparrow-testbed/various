package sepoa.svc.admin;

import java.util.Map ;

import org.apache.commons.collections.MapUtils ;

import sepoa.fw.cfg.Configuration ;
import sepoa.fw.cfg.ConfigurationException ;
import sepoa.fw.db.ConnectionContext ;
import sepoa.fw.db.ParamSql ;
import sepoa.fw.log.Logger ;
import sepoa.fw.msg.* ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.SepoaService ;
import sepoa.fw.srv.SepoaServiceException ;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.SepoaString;


public class AD_028 extends SepoaService
{
	String language = "";
    String serviceId = "AD_028";
//    Message msg = new Message("FW");
    Message msg = null;

    public AD_028(String opt, SepoaInfo sinfo) throws SepoaServiceException
    {
        super(opt, sinfo);
        msg = new Message(sinfo, "FW");
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


    public SepoaOut updateUserList(SepoaInfo info, String[][] bean_args) throws Exception
    {
    	String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			setStatus(1);
			setFlag(true);

			rtn = et_updateUserList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
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

    public String[] et_updateUserList(SepoaInfo info, String[][] bean_info) throws Exception
    {
    	String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
        String language = info.getSession("LANGUAGE");


        try
        {
            String taskType = "TRANSACTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            for(int i = 0; i < bean_info.length; i++)
            {
            	 String user_id = bean_info[i][0];
            	 String user_type = bean_info[i][1];
            	 String authority_group = bean_info[i][2];

            	 sm.removeAllValue(); //초기화
                 sb.delete(0, sb.length()); //초기화
                 sb.append(" merge into soutusau usau \n ");
                 sb.append(" using \n ");
                 sb.append(" ( select \n ");
                 sb.append(" 	? user_id, \n ");
                 sm.addParameter(user_id);

                 sb.append(" 	? user_type, \n ");
                 sm.addParameter(user_type);

                 sb.append(" 	? authority_group, \n ");
                 sm.addParameter(authority_group);

                 if(SEPOA_DB_VENDOR.equals("ORACLE"))
                 {
                	 sb.append(" 	to_char(sysdate, 'yyyymmdd') add_date, \n ");
                	 sb.append(" 	to_char(sysdate, 'HH24MISS') add_time, \n ");
                 }
                 else if (SEPOA_DB_VENDOR.equals("MSSQL"))
                 {
                	 sb.append(" 	CONVERT(VARCHAR, getdate, 112) add_date, \n ");
                	 sb.append(" 	CONVERT(VARCHAR(8),getdate, 114) add_time, \n ");
                 }
                 sb.append(" 	? add_user_id, \n ");
                 sm.addParameter(info.getSession("ID"));

                 sb.append(" 	? add_user_name_eng, \n ");
                 sm.addParameter(info.getSession("NAME_ENG"));

                 sb.append(" 	? add_user_name_loc \n ");
                 sm.addParameter(info.getSession("NAME_LOC"));

                 sb.append("   from dual ) data \n ");
                 sb.append(" on (data.user_id = usau.user_id and \n ");
                 sb.append("     data.user_type = usau.user_type) \n ");
                 sb.append(" when matched then \n ");
                 sb.append(" 	update set \n ");
                 sb.append(" 		usau.authority_group = data.authority_group, \n ");
                 sb.append(" 		usau.change_user_id = data.add_user_id, \n ");
                 sb.append(" 		usau.change_user_name_loc = data.add_user_name_loc, \n ");
                 sb.append(" 		usau.change_user_name_eng = data.add_user_name_eng, \n ");
                 sb.append(" 		usau.change_date = data.add_date, \n ");
                 sb.append(" 		usau.change_time = data.add_time \n ");
                 sb.append(" when not matched then \n ");
                 sb.append(" 	insert ( \n ");
                 sb.append(" 		user_id, \n ");
                 sb.append(" 		user_type, \n ");
                 sb.append(" 		authority_group, \n ");
                 sb.append(" 		add_date, \n ");
                 sb.append(" 		add_time, \n ");
                 sb.append(" 		add_user_id, \n ");
                 sb.append(" 		add_user_name_eng, \n ");
                 sb.append(" 		add_user_name_loc ) \n ");
                 sb.append(" 	values ( \n ");
                 sb.append(" 		data.user_id, \n ");
                 sb.append(" 		data.user_type, \n ");
                 sb.append(" 		data.authority_group, \n ");
                 sb.append(" 		data.add_date, \n ");
                 sb.append(" 		data.add_time, \n ");
                 sb.append(" 		data.add_user_id, \n ");
                 sb.append(" 		data.add_user_name_eng, \n ");
                 sb.append(" 		data.add_user_name_loc) \n ");
                 sm.doUpdate(sb.toString());
            }

            Commit();
        }
        catch (Exception e)
        {
        	Rollback();
            Logger.debug.println(info.getSession("ID"), this, "=------------------ error.");
            rtn[1] = e.getMessage();
        }
        finally
        {

        }

        return rtn;
    }

    public SepoaOut getUserList(SepoaInfo info, String user_name, String company_name, String user_type, String user_id, String company_code, String role_code) throws Exception
    {
    	try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getUserList(info, user_name, company_name, user_type, user_id, company_code, role_code);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
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

    public String[] et_getUserList(SepoaInfo info, String user_name, String company_name, String user_type, String user_id, String company_code, String role_code) throws SepoaServiceException
    {
    	String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
        String language = info.getSession("LANGUAGE");
        boolean is_union_flag = false;
        String outer_text = "";

        if(role_code.length() <= 0) outer_text = "(+)";

        try
        {
            String taskType = "CONNECTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue(); //초기화
            sb.delete(0, sb.length()); //초기화

            if ( "".equals(user_type) || sepoa.svc.common.constants.UserType.BBB.getValue().equals(user_type) )
            {
            	is_union_flag = true;

                sb.append(" select /*+ rule */ \n ");
                sb.append("   'Buyer' user_type_text,'" + sepoa.svc.common.constants.UserType.BBB.getValue() + "' user_type, \n ");
                sb.append("   bumt.user_id user_id, \n ");
                sb.append("   bumt.user_name user_name_loc, \n ");
                sb.append("   bumt.user_name_eng user_name_eng, \n ");
                sb.append("   bumt.buyer_company company_code, \n ");
                sb.append("   bumt.company_name company_name_loc, \n ");
                sb.append("   bumt.company_name_eng company_name_eng, \n ");
                sb.append("   bumt.buyer_company gcs_code, \n ");

                if (language.equals("KO"))
                {
                    sb.append("   bumt.dept_name dept_name, \n ");
                    sb.append("   bumt.grade_name grade_name, \n ");
                    sb.append("   code.text2 country_name, \n ");
                }
                else
                {
                    sb.append("   bumt.dept_name_eng dept_name, \n ");
                    sb.append("   bumt.grade_name_eng grade_name, \n ");
                    sb.append("   code.text1 country_name, \n ");
                }

                sb.append("   bumt.office_tel_no tel_no, \n ");
                sb.append("   bumt.mobile_tel_no mobile_no, \n ");
                sb.append("   bumt.email email, \n ");
                if (SEPOA_DB_VENDOR.equals("MSSQL"))
                {
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(bumt.last_login_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(bumt.last_login_time) last_login_date_time, \n ");
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(bumt.add_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(bumt.add_time) add_date_time, \n ");
                }
                else if (SEPOA_DB_VENDOR.equals("MYSQL"))
                {
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(bumt.last_login_date) , ' ' , " + SEPOA_DB_OWNER + "getTimeFormat(bumt.last_login_time) last_login_date_time, \n ");
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(bumt.add_date) , ' ' , " + SEPOA_DB_OWNER + "getTimeFormat(bumt.add_time) add_date_time, \n ");
                }
                else if (SEPOA_DB_VENDOR.equals("ORACLE"))
                {
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(bumt.last_login_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(bumt.last_login_time) last_login_date_time, \n ");
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(bumt.add_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(bumt.add_time) add_date_time, \n ");
                }

                sb.append("   co1.text1 role_code, \n ");
                sb.append("   usau.authority_group \n ");
                sb.append(" from soutbumt bumt, soutusau usau, soutcode code, soutcode co1 \n ");
                sb.append(" where bumt.user_id = usau.user_id" + outer_text + " \n ");
                sb.append("   and usau.user_type" + outer_text + " = '" + sepoa.svc.common.constants.UserType.BBB.getValue() + "' \n ");
                if (SEPOA_DB_VENDOR.equals("MSSQL"))
                {
                	sb.append("   and upper(substring(bumt.language, 1, 2)) = code.code(+) \n ");
                }
                else
                {
                	sb.append("   and upper(substr(bumt.language, 1, 2)) = code.code(+) \n ");
                }
                sb.append("   and code.type(+) = 'M010' \n ");
                sb.append("   and co1.type(+) = 'M017' \n ");
                sb.append("   and co1.code(+) = usau.authority_group \n ");

                if (SEPOA_DB_VENDOR.equals("ORACLE"))
                {
                	sb.append(sm.addSelect("   and (upper(bumt.user_name) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' \n "));
                	sm.addParameter(user_name);
                	sb.append(sm.addSelect("       or upper(bumt.user_name_eng) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' ) \n "));
                	sm.addParameter(user_name);

                	sb.append(sm.addSelect("   and (upper(bumt.company_name) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' \n "));
                	sm.addParameter(company_name);
                	sb.append(sm.addSelect("       or upper(bumt.company_name_eng) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' ) \n "));
                	sm.addParameter(company_name);

                	sb.append(sm.addSelect("   and (upper(bumt.user_id) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' ) \n "));
                	sm.addParameter(user_id);
                }
                else if (SEPOA_DB_VENDOR.equals("MSSQL"))
                {
                	sb.append(sm.addSelect("   and (upper(bumt.user_name) like '%' + ? + '%' \n "));
                	sm.addParameter(user_name);
                	sb.append(sm.addSelect("       or upper(bumt.user_name_eng) like '%' + ? + '%' ) \n "));
                	sm.addParameter(user_name);

                	sb.append(sm.addSelect("   and (upper(bumt.company_name) like '%' + ? + '%' \n "));
                	sm.addParameter(company_name);
                	sb.append(sm.addSelect("       or upper(bumt.company_name_eng) like '%' + ? + '%' ) \n "));
                	sm.addParameter(company_name);

                	sb.append(sm.addSelect("   and (upper(bumt.user_id) like '%' + ? + '%' ) \n "));
                	sm.addParameter(user_id);
                }
                if (SEPOA_DB_VENDOR.equals("MYSQL"))
                {
                	sb.append(sm.addSelect("   and (upper(bumt.user_name) like '%' , ? , '%' \n "));
                	sm.addParameter(user_name);
                	sb.append(sm.addSelect("       or upper(bumt.user_name_eng) like '%' , ? , '%' ) \n "));
                	sm.addParameter(user_name);

                	sb.append(sm.addSelect("   and (upper(bumt.company_name) like '%' , ? , '%' \n "));
                	sm.addParameter(company_name);
                	sb.append(sm.addSelect("       or upper(bumt.company_name_eng) like '%' , ? , '%' ) \n "));
                	sm.addParameter(company_name);

                	sb.append(sm.addSelect("   and (upper(bumt.user_id) like '%' , ? , '%' ) \n "));
                	sm.addParameter(user_id);
                }

                sb.append(sm.addSelect("   and bumt.buyer_company = ? \n "));
                sm.addParameter(company_code);

                sb.append(sm.addSelect("   and usau.authority_group = ? \n "));
                sm.addParameter(role_code);
            }

            if ("".equals(user_type) || sepoa.svc.common.constants.UserType.Seller.getValue().equals(user_type))
            {
            	if(is_union_flag)
            	{
            		sb.append(" union all \n ");
            	}

                sb.append(" select /*+ rule */ \n ");
                sb.append("   'Supplier' user_type_text, '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "' user_type, \n ");
                sb.append("   sumt.user_id user_id, \n ");
                sb.append("   sumt.cn user_name_loc, \n ");
                sb.append("   sumt.engname user_name_eng, \n ");
                if (SEPOA_DB_VENDOR.equals("ORACLE"))
                {
                	sb.append("   decode(sumt.potential_company, '', sumt.seller_company, sumt.potential_company) company_code, \n ");
                }
                else if (SEPOA_DB_VENDOR.equals("MSSQL"))
                {
                	sb.append("   CASE WHEN sumt.potential company = '' THEN sumt.seller_company else sumt.potential_company END) company_code, \n");
                }
                sb.append("   sumt.kor_name company_name_loc, \n ");
                sb.append("   sumt.eng_name company_name_eng, \n ");
                sb.append("   sumt.seller_company gcs_code, \n ");
                sb.append("   code.text1 dept_name, \n ");
                sb.append("   '' grade_name, \n ");

                if(language.equals("KO"))
                {
                	sb.append("   code1.text2 country_name, \n ");
                }
                else
                {
                	sb.append("   code1.text1 country_name, \n ");
                }

                sb.append("   sumt.telephonenumber tel_no, \n ");
                sb.append("   sumt.mobile mobile_no, \n ");
                sb.append("   sumt.mail email, \n ");
                if(SEPOA_DB_VENDOR.equals("ORACLE"))
                {
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(sumt.last_login_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(sumt.last_login_time) last_login_date_time, \n ");
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(sumt.add_date) || ' ' || " + SEPOA_DB_OWNER + "getTimeFormat(sumt.add_time) add_date_time, \n ");
                }
                else if(SEPOA_DB_VENDOR.equals("MSSQL"))
                {
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(sumt.last_login_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(sumt.last_login_time) last_login_date_time, \n ");
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(sumt.add_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(sumt.add_time) add_date_time, \n ");
                }
                else if(SEPOA_DB_VENDOR.equals("MYSQL"))
                {
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(sumt.last_login_date) , ' ' , " + SEPOA_DB_OWNER + "getTimeFormat(sumt.last_login_time) last_login_date_time, \n ");
                	sb.append("   " + SEPOA_DB_OWNER + "getDateFormat(sumt.add_date) , ' ' , " + SEPOA_DB_OWNER + "getTimeFormat(sumt.add_time) add_date_time, \n ");
                }
                sb.append("   co1.text1 role_code, \n ");
                sb.append("   usau.authority_group \n ");
                sb.append(" from soutsumt sumt, soutusau usau, soutcode code, soutcode code1, soutcode co1 \n ");
                sb.append(" where sumt.user_id = usau.user_id" + outer_text + " \n ");
                sb.append("   and usau.user_type" + outer_text + " = '" + sepoa.svc.common.constants.UserType.Seller.getValue() + "' \n ");
                sb.append("   and code.type(+) = 'M018' \n ");
                sb.append("   and code.code(+) = sumt.department \n ");
                sb.append("   and code1.type(+) = 'M010' \n ");
                sb.append("   and code1.code(+) = sumt.countrycode \n ");
                sb.append("   and ISNULL(sumt.isdelete, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' \n ");
                sb.append("   and co1.type(+) = 'M017' \n ");
                sb.append("   and co1.code(+) = usau.authority_group \n ");

                if(SEPOA_DB_VENDOR.equals("ORACLE"))
                {
                	sb.append(sm.addSelect("   and (upper(sumt.cn) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' \n "));
                	sm.addParameter(user_name);
                	sb.append(sm.addSelect("       or upper(sumt.engname) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' ) \n "));
                	sm.addParameter(user_name);

                	sb.append(sm.addSelect("   and (upper(sumt.kor_name) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' \n "));
                	sm.addParameter(company_name);
                	sb.append(sm.addSelect("       or upper(sumt.eng_name) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' ) \n "));
                	sm.addParameter(company_name);

                	sb.append(sm.addSelect("   and (upper(sumt.user_id) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%' ) \n "));
                	sm.addParameter(user_id);
                }

                else if(SEPOA_DB_VENDOR.equals("MSSQL"))
                {
                	sb.append(sm.addSelect("   and (upper(sumt.cn) like '%' + ? + '%' \n "));
                	sm.addParameter(user_name);
                	sb.append(sm.addSelect("       or upper(sumt.engname) like '%' + ? + '%' ) \n "));
                	sm.addParameter(user_name);

                	sb.append(sm.addSelect("   and (upper(sumt.kor_name) like '%' + ? + '%' \n "));
                	sm.addParameter(company_name);
                	sb.append(sm.addSelect("       or upper(sumt.eng_name) like '%' + ? + '%' ) \n "));
                	sm.addParameter(company_name);

                	sb.append(sm.addSelect("   and (upper(sumt.user_id) like '%' + ? + '%' ) \n "));
                	sm.addParameter(user_id);
                }

                else if(SEPOA_DB_VENDOR.equals("MYSQL"))
                {
                	sb.append(sm.addSelect("   and (upper(sumt.cn) like '%' , ? , '%' \n "));
                	sm.addParameter(user_name);
                	sb.append(sm.addSelect("       or upper(sumt.engname) like '%' , ? , '%' ) \n "));
                	sm.addParameter(user_name);

                	sb.append(sm.addSelect("   and (upper(sumt.kor_name) like '%' , ? , '%' \n "));
                	sm.addParameter(company_name);
                	sb.append(sm.addSelect("       or upper(sumt.eng_name) like '%' , ? , '%' ) \n "));
                	sm.addParameter(company_name);

                	sb.append(sm.addSelect("   and (upper(sumt.user_id) like '%' , ? , '%' ) \n "));
                	sm.addParameter(user_id);
                }

                sb.append(sm.addSelect("   and (sumt.potential_company = ? \n "));
                sm.addParameter(company_code);
                sb.append(sm.addSelect("       or sumt.seller_company = ? )\n "));
                sm.addParameter(company_code);

                sb.append(sm.addSelect("   and usau.authority_group = ? \n "));
                sm.addParameter(role_code);
            }

            rtn[0] = sm.doSelect(sb.toString()); //결과값

            if (rtn[0] == null)
            {
                rtn[1] = "SQL manager is Null";
            }
        }
        catch (Exception e)
        {
            Logger.debug.println(info.getSession("ID"), this, "=------------------ error.");
            rtn[1] = e.getMessage();
        }
        finally
        {
        }

        return rtn;
    }


    
    /**
    * 사용자별 작업내역페이지 조회 메소드
    *  getJobList
    *  수정일 : 2013/03
    * 
    */
    public SepoaOut getJobList(Map<String , String >header) throws Exception
    {
        String[] rtn = new String[2];
        ConnectionContext ctx = getConnectionContext();
        StringBuffer sb = new StringBuffer();

        try
        {
            String from_date    = SepoaString.getDateUnSlashFormat(MapUtils.getString( header, "from_date", "" ));    // 시작일
            String to_date      = SepoaString.getDateUnSlashFormat(MapUtils.getString( header, "to_date", "" ));      // 종료일
            String module_name  = MapUtils.getString( header, "module_name", "" );  // 모듈명
            String job_type     = MapUtils.getString( header, "job_type", "" );     // 작업정보
            String user_name    = MapUtils.getString( header, "user_name", "" );    // 사용자명
            String method_name  = MapUtils.getString( header, "method_name", "" );  // 메소드명
            String user_id      = MapUtils.getString( header, "user_id", "" );      // 사용자 ID
            
            String taskType = "CONNECTION"; //Connection Type Setting[CONNECTION | TRANSACTION | NONDBJOB]
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

            sm.removeAllValue(); //초기화
            sb.delete(0, sb.length()); //초기화

            sb.append("     select                                                                                                                              \n ");
            sb.append("     ulog.user_id,                                                                                                                       \n ");
            sb.append("     ulog.user_name_loc user_name,                                                                                                       \n ");
            sb.append("     ulog.process_id module_name,                                                                                                        \n ");
            sb.append("     ulog.method_name,                                                                                                                   \n ");
            sb.append("     ulog.program_desc description,                                                                                                      \n "); 
            sb.append("     (case when ulog.JOB_TYPE = 'LI' then 'LOGIN' when ulog.job_type = 'LO' then 'LOGOUT' else '작업정보' end) AS job_type,              \n ");

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sb.append("     getDateFormat(ulog.job_date) || ' ' || getTimeFormat(ulog.job_time) job_date,                                                   \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sb.append("     concat(getDateFormat(ulog.job_date), ' ', getTimeFormat(ulog.job_time)) job_date,                                               \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                sb.append("     " + SEPOA_DB_OWNER + "getDateFormat(ulog.job_date)+ ' '+ " + SEPOA_DB_OWNER + "getTimeFormat(ulog.job_time) job_date,           \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                sb.append("     " + SEPOA_DB_OWNER + "getDateFormat(ulog.job_date)+ ' '+ " + SEPOA_DB_OWNER + "getTimeFormat(ulog.job_time) job_date,           \n ");
            }
            
            sb.append("     ulog.ip                                                                                                                             \n ");
            sb.append(" from sulog ulog, ICOMLUSR usmt                                                                                                             \n ");
            sb.append(" where process_id not in ('AjaxComBean', 'SystemAuthBean')                                                                               \n ");
            sb.append(" and ulog.user_id = usmt.user_id                                                                                                         \n ");

            sb.append(sm.addSelectString("   and job_date between ? and                                                                                         \n "));
            sm.addStringParameter(from_date);


            sb.append(sm.addSelectString("   ?                                                                                                                  \n "));
            sm.addStringParameter(to_date);

            Logger.debug.println(info.getSession("ID"), this, "SEPOA_DB_VENDOR : " + SEPOA_DB_VENDOR);

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                 sb.append("   and process_id || '|' || method_name || '|' ||job_type not in                                                                     \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sb.append("     and concat(process_id , '|' , method_name , '|' ,job_type) not in                                                                \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                sb.append("     and process_id + '|' + method_name + '|' +job_type not in                                                                        \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                sb.append("     and process_id + '|' + method_name + '|' +job_type not in                                                                        \n ");
            }

            sb.append("      ('LoginBean|Login|WK' , 'LoginBean|Logout|WK')                                                                                      \n ");

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sb.append(sm.addSelectString("   and upper(process_Id) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%'                                                                      \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sb.append(sm.addSelectString("   and upper(process_Id) like concat('%' , ? , '%')                                                                \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                sb.append(sm.addSelectString("   and upper(process_Id) like '%' + ? + '%'                                                                        \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                sb.append(sm.addSelectString("   and upper(process_Id) like '%' + ? + '%'                                                                        \n "));
            }

            sm.addStringParameter(module_name);
            sb.append(sm.addSelectString("   and job_type = ?                                                                                                    \n "));
            sm.addStringParameter(job_type);


            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sb.append(sm.addSelectString("   and upper(method_name) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%'                                                                     \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sb.append(sm.addSelectString("   and upper(method_name) like concat('%' , ? , '%')                                                               \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                sb.append(sm.addSelectString("   and upper(method_name) like '%' + ? + '%'                                                                        \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                sb.append(sm.addSelectString("   and upper(method_name) like '%' + ? + '%'                                                                        \n "));
            }
            
            sm.addStringParameter(method_name);


            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sb.append(sm.addSelectString("   and upper(ulog.user_name_loc) like '%' " + DBUtil.getAndSeparator() + " ? " + DBUtil.getAndSeparator() + " '%'                                                               \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                sb.append(sm.addSelectString("   and upper(ulog.user_name_loc) like '%' + ? + '%'                                                                 \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sb.append(sm.addSelectString("   and upper(ulog.user_name_loc) like UPPER(CONCAT('%' , ? , '%'))                                                  \n "));
            }
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                sb.append(sm.addSelectString("   and upper(ulog.user_name_loc) like UPPER(CONCAT('%' , ? , '%'))                                                  \n "));
            }
            
            sm.addStringParameter(user_name);
            sb.append(sm.addSelectString("   and upper(usmt.user_id) = ?                                                                                          \n "));
            sm.addStringParameter(user_id);

            if (SEPOA_DB_VENDOR.equals("ORACLE"))
            {
                sb.append(" order by getDateFormat(ulog.job_date) || ' ' || getTimeFormat(ulog.job_time) desc                                                     \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("MSSQL"))
            {
                sb.append(" order by dbo.getDateFormat(ulog.job_date) + ' ' + dbo.getTimeFormat(ulog.job_time) desc                                               \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("MYSQL"))
            {
                sb.append(" order by concat(getDateFormat(ulog.job_date) , ' ' , getTimeFormat(ulog.job_time)) desc                                               \n ");
            }
            else if (SEPOA_DB_VENDOR.equals("SYBASE"))
            {
                sb.append(" order by " + SEPOA_DB_OWNER + "getDateFormat(ulog.job_date) + ' ' + " + SEPOA_DB_OWNER + "getTimeFormat(ulog.job_time) desc                                               \n ");
            }

            rtn[0] = sm.doSelect(sb.toString()); 
            setValue( rtn[0] );
          
        }
        catch (Exception e)
        {
            setMessage(rtn[1]);
            Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
            setStatus(0);
            setFlag(false);
            Logger.debug.println(info.getSession("ID"), this, "=------------------ error.");
            rtn[1] = e.getMessage();
        }
        finally
        {
        }

        return getSepoaOut();
    }// getJobList() end
}
