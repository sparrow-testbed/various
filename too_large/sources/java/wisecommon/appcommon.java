package wisecommon;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.DBOpenException;
import sepoa.fw.db.SepoaConnectionResource;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.jtx.SepoaTransactionalResource;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class appcommon {

	private appcommon() {
	}

	public static String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			s = configuration.get(s);
			return s;
		} catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		return null;
	}

	public static synchronized void LogOut(HttpServletRequest httpservletrequest) {
		setLogHistory(httpservletrequest, false);		// remain user's logout log.
		SepoaSession.invalidate(httpservletrequest);
	}

	/*
	 * �����ʿ��� ���������� �Ѿ�� ��� �α��� ���� ������ ��������.
	 */
	public static synchronized int LoginSales(HttpServletRequest httpservletrequest, String user_id, String pwd) {
		SepoaConnectionResource SepoaConnectionResource;
		SepoaConnectionResource = null;

		String conType = "";

		int login_ok = -100;

		try {
			SepoaConnectionResource SepoaConnectionResource1;
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource1 = SepoaConnectionResource;

			SepoaFormater SepoaFormater1;

			String login_result = et_Login(SepoaConnectionResource1, user_id, pwd, "100", conType);
			SepoaFormater1 = new SepoaFormater(login_result);

			String house_code   = SepoaFormater1.getValue("HOUSE_CODE", 0);
			String company_code = SepoaFormater1.getValue("COMPANY_CODE", 0);
			String dept         = SepoaFormater1.getValue("DEPT", 0);

			String plant_code = "";
			String plant_name_loc = "";
			String s10 = et_getPlant(SepoaConnectionResource1, house_code, company_code, dept, user_id);
			SepoaFormater SepoaFormater2 = new SepoaFormater(s10);

			for (int i2 = 0; i2 < SepoaFormater2.getRowCount(); i2++) {
				if (i2 >= 1) {
					plant_code = plant_code + "&";
					plant_name_loc = plant_name_loc + "&";
				}

				plant_code = plant_code + SepoaFormater2.getValue("PLANT_CODE", i2);
				plant_name_loc = plant_name_loc + SepoaFormater2.getValue("PLANT_NAME_LOC", i2);
			}
			String _plant_code         = plant_code;
			String pr_location         = SepoaFormater1.getValue("PR_LOCATION", 0);
			String user_name_loc       = SepoaFormater1.getValue("USER_NAME_LOC", 0);
			String user_name_eng       = SepoaFormater1.getValue("USER_NAME_ENG", 0);
			String department_name_loc = SepoaFormater1.getValue("DEPARTMENT_NAME_LOC", 0);
			String language            = SepoaFormater1.getValue("LANGUAGE", 0);
			String employee_no         = SepoaFormater1.getValue("EMPLOYEE_NO", 0);
			String phone_no            = SepoaFormater1.getValue("PHONE_NO", 0);
			String time_zone           = SepoaFormater1.getValue("TIME_ZONE", 0);
			String _user_id            = SepoaFormater1.getValue("USER_ID", 0);
			String position            = SepoaFormater1.getValue("POSITION", 0);
			String city_code           = SepoaFormater1.getValue("CITY_CODE", 0);
			String location_name       = SepoaFormater1.getValue("LOCATION_NAME", 0);
			String email               = SepoaFormater1.getValue("EMAIL", 0);
			String ctrl_code           = SepoaFormater1.getValue("CTRL_CODE", 0);
			String _plant_name_loc     = plant_name_loc;
			String menu_type           = SepoaFormater1.getValue("MENU_TYPE", 0);
			String user_type           = SepoaFormater1.getValue("USER_TYPE", 0);
			String manager_position    = SepoaFormater1.getValue("MANAGER_POSITION", 0);
			String company_name        = SepoaFormater1.getValue("COMPANY_NAME", 0);
			String user_ip             = httpservletrequest.getRemoteAddr();
			String country             = "";
			String purchase_location   = "";
			String irs_no              = "";

			if (house_code == null)				house_code = "";
			if (company_code == null)			company_code = "";
			if (dept == null)					dept = "";
			if (_plant_code == null)			_plant_code = "";
			if (pr_location == null)			pr_location = "";
			if (user_name_loc == null)			user_name_loc = "";
			if (user_name_eng == null)			user_name_eng = "";
			if (department_name_loc == null)	department_name_loc = "";
			if (language == null)				language = "";
			if (employee_no == null)			employee_no = "";
			if (phone_no == null)				phone_no = "";
			if (time_zone == null)				time_zone = "";
			if (_user_id == null)				_user_id = "";
			if (position == null)				position = "";
			if (city_code == null)				city_code = "";
			if (location_name == null)			location_name = "";
			if (email == null)					email = "";
			if (ctrl_code == null)				ctrl_code = "";
			if (_plant_name_loc == null)		_plant_name_loc = "";
			if (menu_type == null)				menu_type = "";
			if (user_type == null)				user_type = "";
			if (manager_position == null)		manager_position = "";
			if (company_name == null)			company_name = "";
			if (user_ip == null)				user_ip = "";

			SepoaSession.putValue(httpservletrequest, "HOUSE_CODE", house_code);
			SepoaSession.putValue(httpservletrequest, "COMPANY_CODE", company_code);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT", dept);
			SepoaSession.putValue(httpservletrequest, "PLANT_CODE", _plant_code);
			SepoaSession.putValue(httpservletrequest, "LOCATION_CODE", pr_location);
			SepoaSession.putValue(httpservletrequest, "NAME_LOC", user_name_loc);
			SepoaSession.putValue(httpservletrequest, "NAME_ENG", user_name_eng);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT_NAME_LOC", department_name_loc);
			SepoaSession.putValue(httpservletrequest, "LANGUAGE", language);
			SepoaSession.putValue(httpservletrequest, "COUNTRY", country);
			SepoaSession.putValue(httpservletrequest, "EMPLOYEE_NO", employee_no);
			SepoaSession.putValue(httpservletrequest, "TEL", phone_no);
			SepoaSession.putValue(httpservletrequest, "TIME_ZONE", time_zone);
			SepoaSession.putValue(httpservletrequest, "ID", _user_id);
			SepoaSession.putValue(httpservletrequest, "POSITION", position);
			SepoaSession.putValue(httpservletrequest, "CITY", city_code);
			SepoaSession.putValue(httpservletrequest, "LOCATION_NAME", location_name);
			SepoaSession.putValue(httpservletrequest, "EMAIL", email);
			SepoaSession.putValue(httpservletrequest, "CTRL_CODE", ctrl_code);
			SepoaSession.putValue(httpservletrequest, "PLANT_NAME", _plant_name_loc);
			SepoaSession.putValue(httpservletrequest, "MENU_TYPE", menu_type);
			SepoaSession.putValue(httpservletrequest, "USER_TYPE", user_type);
			SepoaSession.putValue(httpservletrequest, "PURCHASE_LOCATION", purchase_location);
			SepoaSession.putValue(httpservletrequest, "MANAGER_POSITION", manager_position);
			SepoaSession.putValue(httpservletrequest, "USER_IP", user_ip);
			SepoaSession.putValue(httpservletrequest, "IRS_NO", irs_no);
			SepoaSession.putValue(httpservletrequest, "COMPANY_NAME", company_name);
			SepoaSession.putValue(httpservletrequest, "AUTH_COMPANY_CODE", company_code);

			setLogHistory(httpservletrequest, true);
			SepoaConnectionResource.getConnection().commit();
		} catch (Exception ee) {
			try {
				if(SepoaConnectionResource != null){ SepoaConnectionResource.getConnection().rollback(); }
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				Logger.err.println("SQLException e =" + e.getMessage());				
			}

			return 0;
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return login_ok;
	}


	public static synchronized int Login(HttpServletRequest httpservletrequest, String user_id, String pwd) {
		SepoaConnectionResource SepoaConnectionResource;
		SepoaConnectionResource = null;

		String conType = "";

		int password_is_not_ok = 0;
		int login_ok = -100;

		try {
			SepoaConnectionResource SepoaConnectionResource1;
			SepoaFormater SepoaFormater;

			int login_fail_count = 0;
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource1 = SepoaConnectionResource;

			conType = httpservletrequest.getParameter("conType") == null ? "" : httpservletrequest.getParameter("conType");

			String check_cnt = "0";
			String check_loginNcy = "0"; 
			
			SepoaInfo info = SepoaSession.getAllValue(httpservletrequest);

			// ���̵� ���翩�� üũ �� �α��� ���� Ƚ���� �����´�.
			// 1. ���̵� ���翩�θ� üũ�Ͽ� ���̵� ������ ���� [-1]�� �����Ѵ�.
			// 2. �α��� ���� Ƚ���� 50�� �̻��̸� �α��� ������ ��Ȯ�ص� �α����� �ȵǵ��� ���´�.
			check_cnt = et_CheckCnt(SepoaConnectionResource1, user_id,pwd, info.getSession("HOUSE_CODE"));
			SepoaFormater = new SepoaFormater(check_cnt);

			if (SepoaFormater.getRowCount() < 1) {
				return -1; // ���̵� �������� �ʴ´�.
			}
			SepoaFormater SepoaFormater1;

			// �α��� ������ ��ġ�ϴ� ������ �����ϴ� �� Ȯ���Ѵ�.
			// house_code [100] �� ��Ƽ �Ͽ콺�� ��������� ���������� ������� �ʴ´�.
			// HOUSE_CODE �������� ����ASP
			String login_result = et_Login(SepoaConnectionResource1, user_id, pwd, info.getSession("HOUSE_CODE"), conType);
			SepoaFormater1 = new SepoaFormater(login_result);
			// ȸ�������� ���� ���� �������
			if (SepoaFormater1.getRowCount() < 1) {
				password_is_not_ok = et_CheckCnt_Plus(SepoaConnectionResource1, user_id, 1, info.getSession("HOUSE_CODE"));
				return 100; // ��й�ȣ ���� �߻��ϸ� 0 �Ǵ� 1�� ��ȯ�Ѵ�.
			}
			
			//���ٱ��� üũ
			check_loginNcy = et_CheckLoginNcy(SepoaConnectionResource1, info.getSession("HOUSE_CODE"), user_id, pwd);
			SepoaFormater = new SepoaFormater(check_loginNcy);
			
			if (SepoaFormater.getRowCount() < 1) {
				return -66; // ���ٱ����� ����
			}
			
			String house_code = SepoaFormater1.getValue("HOUSE_CODE", 0);
			String company_code = SepoaFormater1.getValue("COMPANY_CODE", 0);
			String password = SepoaFormater1.getValue("PASSWORD", 0);
			String dept = SepoaFormater1.getValue("DEPT", 0);

			int is_update = et_CheckCnt_Plus(SepoaConnectionResource1, user_id, 0, info.getSession("HOUSE_CODE"));

			String plant_code = "";
			String plant_name_loc = "";
			String s10 = et_getPlant(SepoaConnectionResource1, house_code, company_code, dept, user_id);
			SepoaFormater SepoaFormater2 = new SepoaFormater(s10);

			for (int i2 = 0; i2 < SepoaFormater2.getRowCount(); i2++) {
				if (i2 >= 1) {
					plant_code = plant_code + "&";
					plant_name_loc = plant_name_loc + "&";
				}

				plant_code = plant_code + SepoaFormater2.getValue("PLANT_CODE", i2);
				plant_name_loc = plant_name_loc + SepoaFormater2.getValue("PLANT_NAME_LOC", i2);
			}
			String _plant_code         = plant_code;
			String pr_location         = SepoaFormater1.getValue("PR_LOCATION", 0);
			String user_name_loc       = SepoaFormater1.getValue("USER_NAME_LOC", 0);
			String user_name_eng       = SepoaFormater1.getValue("USER_NAME_ENG", 0);
			String department_name_loc = SepoaFormater1.getValue("DEPARTMENT_NAME_LOC", 0);
			String language            = SepoaFormater1.getValue("LANGUAGE", 0);
			String employee_no         = SepoaFormater1.getValue("EMPLOYEE_NO", 0);
			String phone_no            = SepoaFormater1.getValue("PHONE_NO", 0);
			String time_zone           = SepoaFormater1.getValue("TIME_ZONE", 0);
			String _user_id            = SepoaFormater1.getValue("USER_ID", 0);
			String position            = SepoaFormater1.getValue("POSITION", 0);
			String city_code           = SepoaFormater1.getValue("CITY_CODE", 0);
			String location_name       = SepoaFormater1.getValue("LOCATION_NAME", 0);
			String email               = SepoaFormater1.getValue("EMAIL", 0);
			String ctrl_code           = SepoaFormater1.getValue("CTRL_CODE", 0);
			String _plant_name_loc     = plant_name_loc;
			String menu_type           = SepoaFormater1.getValue("MENU_TYPE", 0);
			String user_type           = SepoaFormater1.getValue("USER_TYPE", 0);
			String manager_position    = SepoaFormater1.getValue("MANAGER_POSITION", 0);
			String company_name        = SepoaFormater1.getValue("COMPANY_NAME", 0);
			String user_ip             = httpservletrequest.getRemoteAddr();
			String country             = "";
			String purchase_location   = "";
			String irs_no              = SepoaFormater1.getValue("IRS_NO", 0);
			String work_type              = SepoaFormater1.getValue("WORK_TYPE", 0);


			if (house_code == null)				house_code = "";
			if (company_code == null)			company_code = "";
			if (dept == null)					dept = "";
			if (_plant_code == null)			_plant_code = "";
			if (pr_location == null)			pr_location = "";
			if (user_name_loc == null)			user_name_loc = "";
			if (user_name_eng == null)			user_name_eng = "";
			if (department_name_loc == null)	department_name_loc = "";
			if (language == null)				language = "";
			if (employee_no == null)			employee_no = "";
			if (phone_no == null)				phone_no = "";
			if (time_zone == null)				time_zone = "";
			if (_user_id == null)				_user_id = "";
			if (position == null)				position = "";
			if (city_code == null)				city_code = "";
			if (location_name == null)			location_name = "";
			if (email == null)					email = "";
			if (ctrl_code == null)				ctrl_code = "";
			if (_plant_name_loc == null)		_plant_name_loc = "";
			if (menu_type == null)				menu_type = "";
			if (user_type == null)				user_type = "";
			if (manager_position == null)		manager_position = "";
			if (company_name == null)			company_name = "";
			if (user_ip == null)				user_ip = "";
			if (work_type == null)				work_type = "";

			SepoaSession.putValue(httpservletrequest, "HOUSE_CODE", house_code);
			SepoaSession.putValue(httpservletrequest, "COMPANY_CODE", company_code);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT", dept);
			SepoaSession.putValue(httpservletrequest, "PLANT_CODE", _plant_code);
			SepoaSession.putValue(httpservletrequest, "LOCATION_CODE", pr_location);
			SepoaSession.putValue(httpservletrequest, "NAME_LOC", user_name_loc);
			SepoaSession.putValue(httpservletrequest, "NAME_ENG", user_name_eng);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT_NAME_LOC", department_name_loc);
			SepoaSession.putValue(httpservletrequest, "LANGUAGE", language);
			SepoaSession.putValue(httpservletrequest, "COUNTRY", country);
			SepoaSession.putValue(httpservletrequest, "EMPLOYEE_NO", employee_no);
			SepoaSession.putValue(httpservletrequest, "TEL", phone_no);
			SepoaSession.putValue(httpservletrequest, "TIME_ZONE", time_zone);
			SepoaSession.putValue(httpservletrequest, "ID", _user_id);
			SepoaSession.putValue(httpservletrequest, "POSITION", position);
			SepoaSession.putValue(httpservletrequest, "CITY", city_code);
			SepoaSession.putValue(httpservletrequest, "LOCATION_NAME", location_name);
			SepoaSession.putValue(httpservletrequest, "EMAIL", email);
			SepoaSession.putValue(httpservletrequest, "CTRL_CODE", ctrl_code);
			SepoaSession.putValue(httpservletrequest, "PLANT_NAME", _plant_name_loc);
			SepoaSession.putValue(httpservletrequest, "MENU_TYPE", menu_type);
			SepoaSession.putValue(httpservletrequest, "USER_TYPE", user_type);
			SepoaSession.putValue(httpservletrequest, "PURCHASE_LOCATION", purchase_location);
			SepoaSession.putValue(httpservletrequest, "MANAGER_POSITION", manager_position);
			SepoaSession.putValue(httpservletrequest, "USER_IP", user_ip);
			SepoaSession.putValue(httpservletrequest, "IRS_NO", irs_no);
			SepoaSession.putValue(httpservletrequest, "WORK_TYPE", work_type);
			SepoaSession.putValue(httpservletrequest, "COMPANY_NAME", company_name);
			SepoaSession.putValue(httpservletrequest, "AUTH_COMPANY_CODE", company_code);


			setLogHistory(httpservletrequest, true);
			 
			SepoaConnectionResource.getConnection().commit();
		} catch (Exception ee) {
			try {
				if(SepoaConnectionResource != null){ SepoaConnectionResource.getConnection().rollback(); }
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				Logger.err.println("SQLException e =" + e.getMessage());
			}
			 
			return 0;
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}
		

		return login_ok;
	}

	public static synchronized int Login_Cert(HttpServletRequest httpservletrequest, String user_id) {
		return Login_Cert(httpservletrequest, user_id, null);
	}

	/**
	 * ������������ ���� �α���
	 */
	public static synchronized int Login_Cert(HttpServletRequest httpservletrequest, String user_id, String passwd)
	{
		SepoaConnectionResource SepoaConnectionResource = null;
		
		String conType 	= "";
		int login_ok 	= -100;
		try
		{
			SepoaConnectionResource 	= new SepoaConnectionResource();
			conType = httpservletrequest.getParameter("conType") == null ? "" : httpservletrequest.getParameter("conType");
			
			SepoaInfo info = SepoaSession.getAllValue(httpservletrequest);
			// �α��ν��� ����ڵ�Ϲ�ȣ�� ��ġ�ϴ� ������ �ִ��� �����Ѵ�.
			String login_result = et_Login_Cert(SepoaConnectionResource, info.getSession("HOUSE_CODE"), user_id, conType);
			SepoaFormater SepoaFormater = new SepoaFormater(login_result);
			
			// ��ġ�ϴ� ����ڰ� ��� ���
			if(SepoaFormater.getRowCount() == 0){
				return -1;
			}
			
			//���ٱ��� üũ
			String check_loginNcy = "0"; 
			check_loginNcy 	= et_CheckLoginNcy(SepoaConnectionResource, info.getSession("HOUSE_CODE"), user_id, "");
			SepoaFormater SepoaFormater2 	= new SepoaFormater(check_loginNcy);
			
			if (SepoaFormater2.getRowCount() == 0) {
				return -66; // ���ٱ����� ����
			}
			
			// ȸ�������� ���� ���� �������
			String house_code 	= SepoaFormater.getValue("HOUSE_CODE", 0);
			String company_code = SepoaFormater.getValue("COMPANY_CODE", 0);
			String password 	= SepoaFormater.getValue("PASSWORD", 0);
			String dept 		= SepoaFormater.getValue("DEPT", 0);

			String plant_code 		= "";
			String plant_name_loc 	= "";
			String s10 = et_getPlant(SepoaConnectionResource, house_code, company_code, dept, user_id);
			SepoaFormater SepoaFormater1 = new SepoaFormater(s10);
			for (int i2 = 0; i2 < SepoaFormater1.getRowCount(); i2++)
			{
				if (i2 >= 1) {
					plant_code 		= plant_code + "&";
					plant_name_loc 	= plant_name_loc + "&";
				}
				plant_code = plant_code + SepoaFormater1.getValue("PLANT_CODE", i2);
				plant_name_loc = plant_name_loc + SepoaFormater1.getValue("PLANT_NAME_LOC", i2);
			}
			String _plant_code         = plant_code;
			String pr_location         = SepoaFormater.getValue("PR_LOCATION", 0);
			String user_name_loc       = SepoaFormater.getValue("USER_NAME_LOC", 0);
			String user_name_eng       = SepoaFormater.getValue("USER_NAME_ENG", 0);
			String department_name_loc = SepoaFormater.getValue("DEPARTMENT_NAME_LOC", 0);
			String language            = SepoaFormater.getValue("LANGUAGE", 0);
			String employee_no         = SepoaFormater.getValue("EMPLOYEE_NO", 0);
			String phone_no            = SepoaFormater.getValue("PHONE_NO", 0);
			String time_zone           = SepoaFormater.getValue("TIME_ZONE", 0);
			String _user_id            = SepoaFormater.getValue("USER_ID", 0);
			String position            = SepoaFormater.getValue("POSITION", 0);
			String city_code           = SepoaFormater.getValue("CITY_CODE", 0);
			String location_name       = SepoaFormater.getValue("LOCATION_NAME", 0);
			String email               = SepoaFormater.getValue("EMAIL", 0);
			String ctrl_code           = SepoaFormater.getValue("CTRL_CODE", 0);
			String _plant_name_loc     = plant_name_loc;
			String menu_type           = SepoaFormater.getValue("MENU_TYPE", 0);
			String user_type           = SepoaFormater.getValue("USER_TYPE", 0);
			String manager_position    = SepoaFormater.getValue("MANAGER_POSITION", 0);
			String company_name        = SepoaFormater.getValue("COMPANY_NAME", 0);
			String user_ip             = httpservletrequest.getRemoteAddr();
			String country             = "";
			String purchase_location   = "";
			String irs_no              = SepoaFormater.getValue("IRS_NO", 0);
			String work_type           = SepoaFormater.getValue("WORK_TYPE", 0);
			
			if (house_code == null)			house_code 			= "";
			if (company_code == null)		company_code 		= "";
			if (dept == null)				dept 				= "";
			if (_plant_code == null)		_plant_code 		= "";
			if (pr_location == null)		pr_location 		= "";
			if (user_name_loc == null)		user_name_loc 		= "";
			if (user_name_eng == null)		user_name_eng 		= "";
			if (department_name_loc == null)department_name_loc = "";
			if (language == null)			language 			= "";
			if (employee_no == null)		employee_no 		= "";
			if (phone_no == null)			phone_no 			= "";
			if (time_zone == null)			time_zone 			= "";
			if (_user_id == null)			_user_id 			= "";
			if (position == null)			position 			= "";
			if (city_code == null)			city_code 			= "";
			if (location_name == null)		location_name 		= "";
			if (email == null)				email 				= "";
			if (ctrl_code == null)			ctrl_code 			= "";
			if (_plant_name_loc == null)	_plant_name_loc 	= "";
			if (menu_type == null)			menu_type 			= "";
			if (user_type == null)			user_type 			= "";
			if (manager_position == null)	manager_position 	= "";
			if (company_name == null)		company_name 		= "";
			if (user_ip == null)			user_ip 			= "";
			if (work_type == null)			work_type 			= "";

			SepoaSession.putValue(httpservletrequest, "HOUSE_CODE", house_code);
			SepoaSession.putValue(httpservletrequest, "COMPANY_CODE", company_code);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT", dept);
			SepoaSession.putValue(httpservletrequest, "PLANT_CODE", _plant_code);
			SepoaSession.putValue(httpservletrequest, "LOCATION_CODE", pr_location);
			SepoaSession.putValue(httpservletrequest, "NAME_LOC", user_name_loc);
			SepoaSession.putValue(httpservletrequest, "NAME_ENG", user_name_eng);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT_NAME_LOC", department_name_loc);
			SepoaSession.putValue(httpservletrequest, "LANGUAGE", language);
			SepoaSession.putValue(httpservletrequest, "COUNTRY", country);
			SepoaSession.putValue(httpservletrequest, "EMPLOYEE_NO", employee_no);
			SepoaSession.putValue(httpservletrequest, "TEL", phone_no);
			SepoaSession.putValue(httpservletrequest, "TIME_ZONE", time_zone);
			SepoaSession.putValue(httpservletrequest, "ID", _user_id);
			SepoaSession.putValue(httpservletrequest, "POSITION", position);
			SepoaSession.putValue(httpservletrequest, "CITY", city_code);
			SepoaSession.putValue(httpservletrequest, "LOCATION_NAME", location_name);
			SepoaSession.putValue(httpservletrequest, "EMAIL", email);
			SepoaSession.putValue(httpservletrequest, "CTRL_CODE", ctrl_code);
			SepoaSession.putValue(httpservletrequest, "PLANT_NAME", _plant_name_loc);
			SepoaSession.putValue(httpservletrequest, "MENU_TYPE", menu_type);
			SepoaSession.putValue(httpservletrequest, "USER_TYPE", user_type);
			SepoaSession.putValue(httpservletrequest, "PURCHASE_LOCATION", purchase_location);
			SepoaSession.putValue(httpservletrequest, "MANAGER_POSITION", manager_position);
			SepoaSession.putValue(httpservletrequest, "USER_IP", user_ip);
			SepoaSession.putValue(httpservletrequest, "IRS_NO", irs_no);
			SepoaSession.putValue(httpservletrequest, "WORK_TYPE", work_type);
			SepoaSession.putValue(httpservletrequest, "COMPANY_NAME", company_name);
			SepoaSession.putValue(httpservletrequest, "AUTH_COMPANY_CODE", company_code);

			setLogHistory(httpservletrequest, true);
			
			SepoaConnectionResource.getConnection().commit();
		}
		catch (Exception ee) {
			try {
				if(SepoaConnectionResource != null){ SepoaConnectionResource.getConnection().rollback(); }
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				Logger.err.println("SQLException ee =" + e.getMessage());
			}
			
			return 0;
		}
		finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}
		
		
		return login_ok;
	}

	public static synchronized String LoginCheck(HttpServletRequest httpservletrequest, String user_id) {
		SepoaConnectionResource SepoaConnectionResource;
		SepoaConnectionResource = null;
		String user_type="";

		try {
			SepoaConnectionResource SepoaConnectionResource1;
			SepoaFormater SepoaFormater;

			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource1 = SepoaConnectionResource;

			String check_user = "";

			check_user = et_checkUser_Type(SepoaConnectionResource1, user_id);

			SepoaFormater = new SepoaFormater(check_user);
			user_type = SepoaFormater.getValue("USER_TYPE", 0);

			} catch (Exception ee) {

			// TODO Auto-generated catch block
				Logger.err.println("Exception e =" + ee.getMessage());
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return user_type;
	}

	private static void setLogHistory(HttpServletRequest request, boolean isLogin) {

		SepoaConnectionResource wcr = null;
		ConnectionContext ctx = null;

		try {
			wcr = new SepoaConnectionResource();
			ctx = wcr.getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser("wisecommon/appcommon", "setLogHistory");
			SepoaInfo info = SepoaSession.getAllValue(request);

			String house_code = info.getSession("HOUSE_CODE");
			String user_id = info.getSession("ID").toUpperCase();
			String user_name_loc = info.getSession("NAME_LOC");

			String program = "wisecommon.appcommon";
			String programDesc = "common program";
			String job_type = "";

			// String ip = info.getSession("USER_IP");
			String ip = request.getRemoteAddr();
			String process_id = "appcommon";
			String methodName = "";
			if(isLogin) {
				job_type = "LI";
				methodName = "Login";
			} else {
				job_type = "LO";
				methodName = "Logout";
			}
			String user_type = info.getSession("USER_TYPE");

			String[][] parameter = {
				{ house_code, user_id, user_name_loc, program, programDesc, job_type, ip, process_id, methodName, user_type }
			};

			String[] type = { "S", "S", "S", "S", "S", "S", "S", "S", "S", "S" };

		SepoaSQLManager sqm = new SepoaSQLManager("appcommon", "setLogHistory", ctx, wxp.getQuery());
			int rtn = sqm.doInsert(parameter, type);
			ctx.getConnection().commit();
		} catch (Exception e) {
			try {
				if(ctx != null){ ctx.getConnection().rollback(); }
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				Logger.err.println("SQLException e =" + e1.getMessage());
			}
			
		} finally {
			if(wcr != null && wcr.isAliveConn()) {
				wcr.release();
			}
		}
	}

	/**
	 * ���̵� �н����� ���� �α����ϱ� ���� ���Ǹ���� ����
	 *
	 * @param httpservletrequest
	 * @param user_id
	 * @param pwd
	 * @return
	 */
	public static synchronized int Login(HttpServletRequest httpservletrequest)
	{
		SepoaConnectionResource SepoaConnectionResource = null;
		SepoaFormater SepoaFormater = null;
		
		String conType = "";
		int login_ok = -100;
		try {
			SepoaConnectionResource = new SepoaConnectionResource();
			conType = httpservletrequest.getParameter("conType") == null ? "" : httpservletrequest.getParameter("conType");

			// �α��� ������ ��ġ�ϴ� ������ �����ϴ� �� Ȯ���Ѵ�.
			// house_code [100] �� ��Ƽ �Ͽ콺�� ��������� ���������� ������� �ʴ´�.
			String login_result = et_Login(SepoaConnectionResource, "100", conType);
			SepoaFormater = new SepoaFormater(login_result);

			String house_code 	= SepoaFormater.getValue("HOUSE_CODE", 0);
			String company_code = SepoaFormater.getValue("COMPANY_CODE", 0);
			String dept 		= SepoaFormater.getValue("DEPT", 0);

			String plant_name_loc      = "";
			String pr_location         = SepoaFormater.getValue("PR_LOCATION", 0);
			String user_name_loc       = SepoaFormater.getValue("USER_NAME_LOC", 0);
			String user_name_eng       = SepoaFormater.getValue("USER_NAME_ENG", 0);
			String department_name_loc = SepoaFormater.getValue("DEPARTMENT_NAME_LOC", 0);
			String language            = SepoaFormater.getValue("LANGUAGE", 0);
			String employee_no         = SepoaFormater.getValue("EMPLOYEE_NO", 0);
			String phone_no            = SepoaFormater.getValue("PHONE_NO", 0);
			String time_zone           = SepoaFormater.getValue("TIME_ZONE", 0);
			String _user_id            = SepoaFormater.getValue("USER_ID", 0);
			String position            = SepoaFormater.getValue("POSITION", 0);
			String city_code           = SepoaFormater.getValue("CITY_CODE", 0);
			String location_name       = SepoaFormater.getValue("LOCATION_NAME", 0);
			String email               = SepoaFormater.getValue("EMAIL", 0);
			String ctrl_code           = SepoaFormater.getValue("CTRL_CODE", 0);
			String _plant_name_loc     = plant_name_loc;
			String menu_type           = SepoaFormater.getValue("MENU_TYPE", 0);
			String user_type           = SepoaFormater.getValue("USER_TYPE", 0);
			String manager_position    = SepoaFormater.getValue("MANAGER_POSITION", 0);
			String company_name        = SepoaFormater.getValue("COMPANY_NAME", 0);
			String user_ip             = httpservletrequest.getRemoteAddr();
			String country             = "";
			String purchase_location   = "";
			String irs_no              = SepoaFormater.getValue("IRS_NO", 0);
			String work_type           = SepoaFormater.getValue("WORK_TYPE", 0);

			if (house_code == null)				house_code = "";
			if (company_code == null)			company_code = "";
			if (dept == null)					dept = "";
			if (pr_location == null)			pr_location = "";
			if (user_name_loc == null)			user_name_loc = "";
			if (user_name_eng == null)			user_name_eng = "";
			if (department_name_loc == null)	department_name_loc = "";
			if (language == null)				language = "";
			if (employee_no == null)			employee_no = "";
			if (phone_no == null)				phone_no = "";
			if (time_zone == null)				time_zone = "";
			if (_user_id == null)				_user_id = "";
			if (position == null)				position = "";
			if (city_code == null)				city_code = "";
			if (location_name == null)			location_name = "";
			if (email == null)					email = "";
			if (ctrl_code == null)				ctrl_code = "";
			if (_plant_name_loc == null)		_plant_name_loc = "";
			if (menu_type == null)				menu_type = "";
			if (user_type == null)				user_type = "";
			if (manager_position == null)		manager_position = "";
			if (company_name == null)			company_name = "";
			if (user_ip == null)				user_ip = "";
			if (work_type == null)				work_type = "";

			SepoaSession.putValue(httpservletrequest, "HOUSE_CODE", house_code);
			SepoaSession.putValue(httpservletrequest, "COMPANY_CODE", company_code);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT", dept);
			SepoaSession.putValue(httpservletrequest, "PLANT_CODE", "");
			SepoaSession.putValue(httpservletrequest, "LOCATION_CODE", pr_location);
			SepoaSession.putValue(httpservletrequest, "NAME_LOC", user_name_loc);
			SepoaSession.putValue(httpservletrequest, "NAME_ENG", user_name_eng);
			SepoaSession.putValue(httpservletrequest, "DEPARTMENT_NAME_LOC", department_name_loc);
			SepoaSession.putValue(httpservletrequest, "LANGUAGE", language);
			SepoaSession.putValue(httpservletrequest, "COUNTRY", country);
			SepoaSession.putValue(httpservletrequest, "EMPLOYEE_NO", employee_no);
			SepoaSession.putValue(httpservletrequest, "TEL", phone_no);
			SepoaSession.putValue(httpservletrequest, "TIME_ZONE", time_zone);
			SepoaSession.putValue(httpservletrequest, "ID", _user_id);
			SepoaSession.putValue(httpservletrequest, "POSITION", position);
			SepoaSession.putValue(httpservletrequest, "CITY", city_code);
			SepoaSession.putValue(httpservletrequest, "LOCATION_NAME", location_name);
			SepoaSession.putValue(httpservletrequest, "EMAIL", email);
			SepoaSession.putValue(httpservletrequest, "CTRL_CODE", ctrl_code);
			SepoaSession.putValue(httpservletrequest, "PLANT_NAME", _plant_name_loc);
			SepoaSession.putValue(httpservletrequest, "MENU_TYPE", menu_type);
			SepoaSession.putValue(httpservletrequest, "USER_TYPE", user_type);
			SepoaSession.putValue(httpservletrequest, "PURCHASE_LOCATION", purchase_location);
			SepoaSession.putValue(httpservletrequest, "MANAGER_POSITION", manager_position);
			SepoaSession.putValue(httpservletrequest, "USER_IP", user_ip);
			SepoaSession.putValue(httpservletrequest, "IRS_NO", irs_no);
			SepoaSession.putValue(httpservletrequest, "WORK_TYPE", work_type);
			SepoaSession.putValue(httpservletrequest, "COMPANY_NAME", company_name);
			SepoaSession.putValue(httpservletrequest, "AUTH_COMPANY_CODE", company_code);

		} catch (Exception ee) {
			return 0;
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}
		return login_ok;
	}

	private static String et_CheckCnt(ConnectionContext connectioncontext, String user_id, String pwd, String house_code) throws Exception {
		String rlt = null;

		try {
			StringBuffer sql = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", new Exception().getStackTrace()[0].getMethodName());
			p.addVar("user_id", user_id);
			p.addVar("house_code", house_code);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, sql, connectioncontext, p.getQuery());
			rlt = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("et_CheckCnt:" + exception.getMessage());
		}

		return rlt;
	}
	
	private static String et_CheckLoginNcy(ConnectionContext connectioncontext, String house_code, String user_id, String pwd) throws Exception {
		String result = "";

		try {
			StringBuffer sql = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", new Exception().getStackTrace()[0].getMethodName());
			p.addVar("user_id", user_id);
			p.addVar("password", pwd);
			p.addVar("house_code", house_code);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, sql, connectioncontext, p.getQuery());
			result = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("et_CheckLoginNcy:" + exception.getMessage());
		}

		return result;
	}

	private static String et_checkUser_Type(ConnectionContext connectioncontext, String user_id) throws Exception {
		String rlt = null;

		try {
			StringBuffer sql = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", new Exception().getStackTrace()[0].getMethodName());
			p.addVar("user_id", user_id);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, sql, connectioncontext, p.getQuery());
			rlt = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("et_CheckCnt:" + exception.getMessage());
		}

		return rlt;
	}

	private static int et_CheckCnt_Plus(ConnectionContext connectioncontext, String user_id, int cnt, String house_code) throws Exception, DBOpenException {
		int rlt = -1;

		try {
			StringBuffer sql = new StringBuffer();
			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_CheckCnt_Plus");
			p.addVar("user_id", user_id);
			p.addVar("cnt", cnt);
			p.addVar("house_code", house_code);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, sql, connectioncontext, p.getQuery());
			rlt = SepoaSQLManager.doUpdate((String[][])null, (String[])null);
			connectioncontext.getConnection().commit();
		} catch (Exception e) {
			connectioncontext.getConnection().rollback();
			
		}
		return rlt;
	}

	private static String et_Login(ConnectionContext connectioncontext, String s, String s1, String s2, String s3) throws Exception {
		String s4 = null;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_Login1");
			p.addVar("user_id", s);
			p.addVar("password", s1);
			p.addVar("house_code", s2);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s, stringbuffer, connectioncontext, p.getQuery());
			s4 = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("Login:" + exception.getMessage());
		}
		return s4;
	}

	/**
	 * �н�������� ���� ���ϱ� ����
	 * MAIL SERVER���� ���� �Ŀ� �α����ϱ� ������ PASSWORD �ʿ� ����.
	 * @param connectioncontext
	 * @param s2
	 * @param s3
	 * @return
	 * @throws Exception
	 */
	private static String et_Login_Cert(ConnectionContext connectioncontext, String s, String s2, String s3) throws Exception {
		String s4 = null;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_Login_Cert");
			p.addVar("house_code", s);
			p.addVar("user_id", s2);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s, stringbuffer, connectioncontext, p.getQuery());
			s4 = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("Login:" + exception.getMessage());
		}
		return s4;
	}

	/**
	 * ���̵� �н����� ���� �α����ϱ� ���� ���� ���ϱ� ����.
	 *
	 * @param connectioncontext
	 * @param s2
	 * @param s3
	 * @return
	 * @throws Exception
	 */
	private static String et_Login(ConnectionContext connectioncontext, String s2, String s3) throws Exception {
		String s4 = null;
		try {

			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_Login2");

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager("SYSTEM", stringbuffer, connectioncontext, p.getQuery());
			s4 = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("Login:" + exception.getMessage());
		}
		return s4;
	}

	private static String et_getCtrlCode(ConnectionContext connectioncontext, String house_code, String company_code, String user_id) throws Exception {
		String rlt = null;

		try {
			StringBuffer sql = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getCtrlCode");
			p.addVar("house_code", house_code);
			p.addVar("company_code", company_code);
			p.addVar("user_id", user_id);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, sql, connectioncontext, p.getQuery());
			rlt = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("CtrlCode:" + exception.getMessage());
		}

		return rlt;
	}

	private static String et_getDocNumber(ConnectionContext ctx, String user_id, String house_code, String doc_type) throws Exception {
		String rtnString = null;

		try {
			StringBuffer sql = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getDocNumber");
			p.addVar("house_code", house_code);
			p.addVar("doc_type", doc_type);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, sql, ctx, p.getQuery());
			rtnString = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("getDocNumber:" + exception.getMessage());
		}

		return rtnString;
	}

	private static String et_getInitFlag(SepoaInfo SepoaInfo, ConnectionContext ctx, String house_code, String user_id) throws Exception {
		String rlt = null;

		try {
			StringBuffer sql = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getDocNumber");
			p.addVar("house_code", house_code);
			p.addVar("user_id", user_id);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, sql, ctx, p.getQuery());
			rlt = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("et_getInitFlag:" + exception.getMessage());
		}

		return rlt;
	}

	private static String et_getMenuList(ConnectionContext ctx, String house_code, String user_id, String menu_object_code) throws Exception {
		String s4 = null;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getMenuList_1");
			p.addVar("house_code", house_code);
			p.addVar("menu_object_code", menu_object_code);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, stringbuffer, ctx, p.getQuery());
			String s3 = SepoaSQLManager.doSelect((String[])null);

			SepoaFormater SepoaFormater = new SepoaFormater(s3);
			int i = SepoaFormater.getRowCount();
			String as[][] = new String[i][10];
			for (int j = 0; j < i; j++) {
				as[j][0] = SepoaFormater.getValue(j, 0); // menu_object_code
				as[j][1] = SepoaFormater.getValue(j, 1); // menu_field_code
				as[j][2] = SepoaFormater.getValue(j, 2); // menu_parent_field_code
				as[j][3] = SepoaFormater.getValue(j, 3); // menu_name
				as[j][4] = SepoaFormater.getValue(j, 4); // screen_id
				as[j][5] = SepoaFormater.getValue(j, 5); // menu_link_flag
				as[j][6] = SepoaFormater.getValue(j, 6); // child_flag
				as[j][7] = SepoaFormater.getValue(j, 7); // order_seq
				as[j][8] = SepoaFormater.getValue(j, 8); // use_flag
				as[j][9] = SepoaFormater.getValue(j, 9); // menu_link
			}

			stringbuffer.setLength(0);

			p = new SepoaXmlParser("wisecommon/appcommon", "et_getMenuList_2");
			p.addVar("house_code", house_code);
			p.addVar("menu_object_code", menu_object_code);

			SepoaSQLManager = new SepoaSQLManager(user_id, stringbuffer, ctx, p.getQuery());
			String s5 = SepoaSQLManager.doSelect((String[])null);

			SepoaFormater = new SepoaFormater(s5);
			String s6 = "";
			if (SepoaFormater.getRowCount() > 0)
				s6 = SepoaFormater.getValue(0, 0);

			Logger.debug.println("start_point=====>" + s6);
			s4 = call_menu(as, s6, true);
		} catch (Exception exception) {
			throw new Exception("getMenuList:" + exception.getMessage());
		}
		return s4;
	}

	private static String resultvalue = "";

	public static String call_menu(String menutree[][], String start_point, boolean flag) {
		String s_field = getConfig("wise.separator.field");
		String s_line = getConfig("wise.separator.line");

		String s1 = "";
		int cnt = 1;
		if (flag) {
			resultvalue = "A" + s_field + "B" + s_field + "C" + s_field + "D" + s_field + "E" + s_field + "F" + s_field + "G" + s_field + "H" + s_field + "I" + s_field + "J" + s_field + "K" + s_field + s_line;
			for (int j = 0; j < menutree.length; j++)
				if (menutree[j][1].equals(start_point)) {
					s1 = s1 + s1 + cnt + s_field + menutree[j][0] + s_field + menutree[j][1] + s_field + menutree[j][2] + s_field;
					s1 = s1 + menutree[j][3] + s_field + menutree[j][4] + s_field + menutree[j][5] + s_field;
					s1 = s1 + menutree[j][6] + s_field + menutree[j][7] + s_field + menutree[j][8] + s_field;
					s1 = s1 + menutree[j][9] + s_field + s_line;
					resultvalue = resultvalue + s1;
				}

		}
		for (int k = 0; k < menutree.length; k++) {
			String s2 = "";
			if (menutree[k][2].equals(start_point)) {
				cnt++;
				s2 = s2 + s2 + cnt + s_field + menutree[k][0] + s_field + menutree[k][1] + s_field + menutree[k][2] + s_field;
				s2 = s2 + menutree[k][3] + s_field + menutree[k][4] + s_field + menutree[k][5] + s_field;
				s2 = s2 + menutree[k][6] + s_field + menutree[k][7] + s_field + menutree[k][8] + s_field;
				s2 = s2 + menutree[k][9] + s_field + s_line;
				resultvalue = resultvalue + s2;
				call_menu(menutree, menutree[k][1], false);
			}
			if (k == menutree.length - 1)
				cnt--;
		}

		return resultvalue;
	}

	private static String et_getMenuList(ConnectionContext connectioncontext, String s, String s1, String s2, String s3) throws Exception {
		String s5 = null;
		ConnectionContext connectioncontext1 = connectioncontext;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getMenuList_3");
			p.addVar("menu_name", s3);
			p.addVar("menu_object_code", s2);
			p.addVar("house_code", s);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s1, stringbuffer, connectioncontext, p.getQuery());
			String s4 = SepoaSQLManager.doSelect((String[])null);

			SepoaFormater SepoaFormater = new SepoaFormater(s4);
			int i = SepoaFormater.getRowCount();
			String as[][] = new String[i][10];
			for (int j = 0; j < i; j++) {
				as[j][0] = SepoaFormater.getValue(j, 0);
				as[j][1] = SepoaFormater.getValue(j, 1);
				as[j][2] = SepoaFormater.getValue(j, 2);
				as[j][3] = SepoaFormater.getValue(j, 3);
				as[j][4] = SepoaFormater.getValue(j, 4);
				as[j][5] = SepoaFormater.getValue(j, 5);
				as[j][6] = SepoaFormater.getValue(j, 6);
				as[j][7] = SepoaFormater.getValue(j, 7);
				as[j][8] = SepoaFormater.getValue(j, 8);
				as[j][9] = SepoaFormater.getValue(j, 9);
			}

			stringbuffer.setLength(0);

			p = new SepoaXmlParser("wisecommon/appcommon", "et_getMenuList_4");
			p.addVar("menu_object_code", s2);
			p.addVar("house_code", s);

			SepoaSQLManager = new SepoaSQLManager(s1, stringbuffer, connectioncontext1, p.getQuery());
			String s6 = SepoaSQLManager.doSelect((String[])null);

			SepoaFormater = new SepoaFormater(s6);
			String s7 = "";
			if (SepoaFormater.getRowCount() > 0)
				s7 = SepoaFormater.getValue(0, 0);
			Logger.debug.println("start_point=====>" + s7);
			s5 = call_menu(as, s7, true);
		} catch (Exception exception) {
			throw new Exception("getMenuList:" + exception.getMessage());
		}
		return s5;
	}

	private static String et_getMenuList_MY(ConnectionContext connectioncontext, String s, String s1, String s2, String s3) throws Exception {
		String s5 = null;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getMenuList_MY1");
			p.addVar("menu_name", s3);
			p.addVar("menu_object_code", s2);
			p.addVar("user_id", s1);
			p.addVar("house_code", s);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s1, stringbuffer, connectioncontext, p.getQuery());
			String s4 = SepoaSQLManager.doSelect((String[])null);

			SepoaFormater SepoaFormater = new SepoaFormater(s4);
			int i = SepoaFormater.getRowCount();
			String as[][] = new String[i][10];
			for (int j = 0; j < i; j++) {
				as[j][0] = SepoaFormater.getValue(j, 0);
				as[j][1] = SepoaFormater.getValue(j, 1);
				as[j][2] = SepoaFormater.getValue(j, 2);
				as[j][3] = SepoaFormater.getValue(j, 3);
				as[j][4] = SepoaFormater.getValue(j, 4);
				as[j][5] = SepoaFormater.getValue(j, 5);
				as[j][6] = SepoaFormater.getValue(j, 6);
				as[j][7] = SepoaFormater.getValue(j, 7);
				as[j][8] = SepoaFormater.getValue(j, 8);
				as[j][9] = SepoaFormater.getValue(j, 9);
			}

			stringbuffer.setLength(0);

			p = new SepoaXmlParser("wisecommon/appcommon", "et_getMenuList_MY2");
			p.addVar("menu_name", s3);
			p.addVar("menu_object_code", s2);
			p.addVar("user_id", s1);
			p.addVar("house_code", s);

			SepoaSQLManager = new SepoaSQLManager(s1, stringbuffer, connectioncontext, p.getQuery());
			String s6 = SepoaSQLManager.doSelect((String[])null);

			SepoaFormater = new SepoaFormater(s6);
			String s7 = "";
			if (SepoaFormater.getRowCount() > 0)
				s7 = SepoaFormater.getValue(0, 0);
			Logger.debug.println("start_point=====>" + s7);
			s5 = call_menu(as, s7, true);
		} catch (Exception exception) {
			throw new Exception("getMenuList:" + exception.getMessage());
		}
		return s5;
	}

	private static String et_getMenuTitle(ConnectionContext ctx, String house_code, String user_id, String menu_profile_code) throws Exception {
		String s3 = null;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getMenuTitle");
			p.addVar("menu_profile_code", menu_profile_code);
			p.addVar("house_code", house_code);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, stringbuffer, ctx, p.getQuery());
			s3 = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("getMenuTitle:" + exception.getMessage());
		}

		return s3;
	}

	private static String et_getPlant(ConnectionContext connectioncontext, String s, String s1, String s2, String s3) throws Exception {
		String s4 = null;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getPlant");
			p.addVar("company_code", s1);
			p.addVar("house_code", s);
			p.addVar("dept", s2);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s3, stringbuffer, connectioncontext, p.getQuery());
			s4 = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("Plant:" + exception.getMessage());
		}

		return s4;
	}

	private static int et_getValidateProfile(ConnectionContext connectioncontext, String house_code, String user_id, String menu_profile_code, String menu_link) throws Exception {

		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getValidateProfile");
			p.addVar("menu_profile_code", menu_profile_code);
			p.addVar("house_code", house_code);
			p.addVar("menu_link", menu_link);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, stringbuffer, connectioncontext, p.getQuery());
			String s4 = SepoaSQLManager.doSelect((String[])null);
			SepoaFormater SepoaFormater = new SepoaFormater(s4);
			if (SepoaFormater.getRowCount() < 1)
				return 0;
		} catch (Exception exception) {
			throw new Exception("getValidateProfile:" + exception.getMessage());
		}

		return 1;
	}

	private static int et_setDocNumber(ConnectionContext connectioncontext, String user_id, String house_code, String doc_type, String current_no) throws Exception {
		int i = 0;
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_setDocNumber");
			p.addVar("current_no", current_no);
			p.addVar("house_code", house_code);
			p.addVar("doc_type", doc_type);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(user_id, stringbuffer, connectioncontext, p.getQuery());
			i = SepoaSQLManager.doUpdate((String[][])null, (String[])null);
		} catch (Exception exception) {
			throw new Exception("setDocNumber:" + exception.getMessage());
		}
		return i;
	}

	private static int et_setICOMMUMY_Init(SepoaInfo SepoaInfo, ConnectionContext connectioncontext, String s, String s1) throws Exception {
		int i = -1;
		String s2 = SepoaInfo.getSession("DEPARTMENT");
		String s3 = SepoaInfo.getSession("NAME_ENG");
		String s4 = SepoaInfo.getSession("NAME_LOC");
		String s5 = SepoaDate.getShortDateString();
		String s6 = SepoaDate.getShortTimeString();
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_setICOMMUMY_Init");
			p.addVar("house_code", s);
			p.addVar("user_id", s1);
			p.addVar("add_date", s5);
			p.addVar("add_time", s6);
			p.addVar("add_user_id", s1);
			p.addVar("add_user_dept", s2);
			p.addVar("add_user_name_eng", s3);
			p.addVar("add_user_name_loc", s4);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s1, stringbuffer, connectioncontext, p.getQuery());
			i = SepoaSQLManager.doInsert((String[][])null, (String[])null);
		} catch (Exception exception) {
			throw new Exception("et_setICOMMUMY_Init:" + exception.getMessage());
		}
		return i;
	}

	private static int et_setMenuDelete_MY(SepoaInfo SepoaInfo, ConnectionContext connectioncontext) throws Exception {
		int i = -1;
		String s = SepoaInfo.getSession("MENU_TYPE");
		String s1 = SepoaInfo.getSession("HOUSE_CODE");
		String s2 = SepoaInfo.getSession("ID");
		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_setMenuDelete_MY");
			p.addVar("menu_type", s);
			p.addVar("house_code", s1);
			p.addVar("user_id", s2);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s2, stringbuffer, connectioncontext, p.getQuery());
			i = SepoaSQLManager.doDelete((String[][])null, (String[])null);
		} catch (Exception exception) {
			throw new Exception("et_setMenuDelete_MY:" + exception.getMessage());
		}
		return i;
	}

	public static SepoaOut getDocNumber(SepoaInfo SepoaInfo, String doc_type) {
		SepoaOut SepoaOut = new SepoaOut();
		String as[] = new String[1];
		java.io.InputStream inputstream = null;
		try {
			Configuration configuration = new Configuration();

			//-------------------------------------------------------------------------------------------------------
			String s2 = "";
			URL url = null;
			URLConnection urlconnection = null;
			BufferedReader bufferedreader = null;
			
			try {
				s2 = configuration.get("wise.docnumber.murl_01");

				url = new URL(s2 + "?HOUSE_CODE=" + SepoaInfo.getSession("HOUSE_CODE") + "&DOC_TYPE=" + doc_type + "&INFO=ID=" + SepoaInfo.getSession("ID") + "^@^LANGUAGE=KO^@^NAME_LOC=DOC^@^NAME_ENG=DOC^@^");
				urlconnection = url.openConnection();  inputstream = urlconnection.getInputStream();
				bufferedreader = new BufferedReader(new InputStreamReader(inputstream));
			} catch (Exception e1) {
				
				Logger.err.println("[murl-Error 1 : " + s2 + " Next Try....");

				try {
					s2 = configuration.get("wise.docnumber.murl_02");

					url = new URL(s2 + "?HOUSE_CODE=" + SepoaInfo.getSession("HOUSE_CODE") + "&DOC_TYPE=" + doc_type + "&INFO=ID=" + SepoaInfo.getSession("ID") + "^@^LANGUAGE=KO^@^NAME_LOC=DOC^@^NAME_ENG=DOC^@^");
					urlconnection = url.openConnection();
					bufferedreader = new BufferedReader(new InputStreamReader(urlconnection.getInputStream()));
				} catch (Exception e2) {
					
					Logger.err.println("[murl-Error 2 : " + s2 + "");

					SepoaOut.status = -5;
					as[0] = e2.getMessage();
					SepoaOut.result = as;
					Logger.err.println("Exception e =" + e2.getMessage());
				}
			}
			//-------------------------------------------------------------------------------------------------------
			String s4 = "";  
			if(bufferedreader != null){ 
				for (int i = 0; (s4 = bufferedreader.readLine()) != null; i++){
					if (i == 0) {
						SepoaOut.status = Integer.parseInt(s4);
					} else {
						as[0] = s4; SepoaOut.result = as;
					}
				}
				bufferedreader.close();
			}			
		} catch (MalformedURLException malformedurlexception) {
			SepoaOut.status = -2;
			as[0] = malformedurlexception.getMessage();
			SepoaOut.result = as;
			Logger.err.println("Exception e =" + malformedurlexception.getMessage());
		} catch (IOException ioexception) {
			SepoaOut.status = -3;
			as[0] = ioexception.getMessage();
			SepoaOut.result = as;
			Logger.err.println("Exception e =" + ioexception.getMessage());
		} catch (Exception exception) {
			SepoaOut.status = -4;
			as[0] = exception.getMessage();
			SepoaOut.result = as;
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally { if(inputstream != null){ IOUtils.closeQuietly(inputstream); } }
		return SepoaOut;
	}

	public static SepoaOut getDocNumber(SepoaInfo SepoaInfo, String doc_type, String exp_no) {
		SepoaOut SepoaOut;
		String as[];
		SepoaOut = new SepoaOut();
		as = new String[1];
		java.io.InputStream inputstream = null;
		try {
			Configuration configuration = new Configuration();

			//-------------------------------------------------------------------------------------------------------
			String s3 = "";
			URL url = null;
			URLConnection urlconnection = null;
			BufferedReader bufferedreader = null;

			try {
				s3 = configuration.get("wise.docnumber.murl_01");

				url = new URL(s3 + "?HOUSE_CODE=" + SepoaInfo.getSession("HOUSE_CODE") + "&DOC_TYPE=" + doc_type + "&EXP_NO=" + exp_no + "&INFO=ID=" + SepoaInfo.getSession("ID") + "^@^LANGUAGE=KO^@^NAME_LOC=DOC^@^NAME_ENG=DOC^@^");
				urlconnection = url.openConnection();   inputstream = urlconnection.getInputStream();
				bufferedreader = new BufferedReader(new InputStreamReader(inputstream, "KSC5601"));
			} catch (Exception e1) {
				
				Logger.err.println("[murl-Error 1 : " + s3 + " Next Try....");

				try {
					s3 = configuration.get("wise.docnumber.murl_02");

					url = new URL(s3 + "?HOUSE_CODE=" + SepoaInfo.getSession("HOUSE_CODE") + "&DOC_TYPE=" + doc_type + "&EXP_NO=" + exp_no + "&INFO=ID=" + SepoaInfo.getSession("ID") + "^@^LANGUAGE=KO^@^NAME_LOC=DOC^@^NAME_ENG=DOC^@^");
					urlconnection = url.openConnection();
					bufferedreader = new BufferedReader(new InputStreamReader(urlconnection.getInputStream(), "KSC5601"));
				} catch (Exception e2) {
					
					Logger.err.println("[murl-Error 2 : " + s3 + "");

					SepoaOut.status = -5;
					as[0] = e2.getMessage();
					SepoaOut.result = as;
					Logger.err.println("Exception e =" + e2.getMessage());
				}
			}
			//-------------------------------------------------------------------------------------------------------
			String s4;
			if(bufferedreader != null){ 
				for (int i = 0; (s4 = bufferedreader.readLine()) != null; i++) {
					if (i == 0) {
						SepoaOut.status = Integer.parseInt(s4);
					} else {
						as[0] = s4;
						SepoaOut.result = as;
					}
				}
				bufferedreader.close();
			}
			return SepoaOut;
		} catch (MalformedURLException malformedurlexception) {
			SepoaOut.status = -2;
			as[0] = malformedurlexception.getMessage();
			SepoaOut.result = as;
			Logger.err.println("Exception e =" + malformedurlexception.getMessage());
		} catch (IOException ioexception) {
			SepoaOut.status = -3;
			as[0] = ioexception.getMessage();
			SepoaOut.result = as;
			Logger.err.println("Exception e =" + ioexception.getMessage());
		} catch (Exception exception) {
			SepoaOut.status = -4;
			as[0] = exception.getMessage();
			SepoaOut.result = as;
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally { if(inputstream != null){ IOUtils.closeQuietly(inputstream); } }
		return SepoaOut;
	}

	public static synchronized SepoaOut getDocNumberRemote(SepoaInfo SepoaInfo, String doc_type) {
		SepoaTransactionalResource SepoaTransactionalResource;
		SepoaOut SepoaOut;
		SepoaTransactionalResource = null;
		SepoaOut = new SepoaOut();

		try {
			SepoaTransactionalResource SepoaTransactionalResource1;
			String as[];
			SepoaFormater SepoaFormater;
			SepoaTransactionalResource = new SepoaTransactionalResource();
			SepoaTransactionalResource.getUserTransaction();
			SepoaTransactionalResource1 = SepoaTransactionalResource;
			as = new String[1];
			String house_code = SepoaInfo.getSession("HOUSE_CODE");
			String user_id = SepoaInfo.getSession("ID");
			as[0] = et_getDocNumber(SepoaTransactionalResource1, user_id, house_code, doc_type);
			SepoaFormater = new SepoaFormater(as[0]);

			if (SepoaFormater.getRowCount() < 1) {
				SepoaOut.message = "Data Not Found!";
				Logger.err.println(user_id, SepoaOut, SepoaOut.message);
				SepoaOut.result = as;
				SepoaOut.status = 0;
				SepoaTransactionalResource.getUserTransaction().rollback();
				SepoaOut SepoaOut3 = SepoaOut;
				SepoaOut SepoaOut1 = SepoaOut3;
				return SepoaOut1;
			}

			double doc_start_no = Double.parseDouble(SepoaFormater.getValue(0, 0));
			double doc_end_no   = Double.parseDouble(SepoaFormater.getValue(0, 1));
			int doc_end_no_length    = SepoaFormater.getValue(0, 1).length();
			String doc_current_no    = SepoaFormater.getValue(0, 2);
			String doc_prefix_format = SepoaFormater.getValue(0, 3);
			String tmp_prefix_format = SepoaFormater.getValue(0, 3);
			String doc_year_flag     = SepoaFormater.getValue(0, 4);
			String doc_month_flag    = SepoaFormater.getValue(0, 5);
			String doc_day_flag      = SepoaFormater.getValue(0, 6);
			String s8 = "";

			// ������ �����ȣ ���� - ������ �� ��ȣ ����, ������ �����ȣ����.
			/*
			 * doc_current_no.length() = "MUO200803 00001".length() = 14.
			 * doc_end_no.length() = "99999".length() = 5. 14 - 5 = 9.
			 */
			String doc_current_no_seq = SepoaFormater.getValue(0, 2).substring(SepoaFormater.getValue(0, 2).length() - doc_end_no_length, SepoaFormater.getValue(0, 2).length());
			double double_doc_current_no_seq = Double.parseDouble(doc_current_no_seq);

			if (double_doc_current_no_seq + 1.0D > doc_end_no) {
				SepoaOut.message = "Number Range Full!";
				Logger.err.println(user_id, SepoaOut, SepoaOut.message);
				SepoaOut.result = as;
				SepoaOut.status = 0;
				SepoaTransactionalResource.getUserTransaction().rollback();
				SepoaOut SepoaOut4 = SepoaOut;
				SepoaOut SepoaOut2 = SepoaOut4;
				return SepoaOut2;
			}

			for (int j = 0; j < doc_end_no_length; j++)
				s8 = s8 + "0";

			DecimalFormat decimalformat = new DecimalFormat(s8);
			/**
			 * ÷������ ä���� ��� prefix_format+house_code�� �־� �ߺ��� �����Ѵ�.
			 * 2012.03.07 HMCHOI
			 */
			if (tmp_prefix_format.equalsIgnoreCase("AT")) {
				doc_prefix_format = doc_prefix_format + house_code;
			}
			if (doc_year_flag.equals("Y")) {
				doc_prefix_format = doc_prefix_format + String.valueOf(SepoaDate.getYear()).substring(2,4);
			}
			if (doc_month_flag.equals("Y")) {
				DecimalFormat decimalformat1 = new DecimalFormat("00");
				doc_prefix_format = doc_prefix_format + decimalformat1.format(SepoaDate.getMonth());
			}
			if (doc_day_flag.equals("Y")) {
				DecimalFormat decimalformat2 = new DecimalFormat("00");
				doc_prefix_format = doc_prefix_format + decimalformat2.format(SepoaDate.getDay());
			}
			if (doc_current_no.indexOf(doc_prefix_format) == -1)
				doc_prefix_format = doc_prefix_format + decimalformat.format(doc_start_no);
			else
				doc_prefix_format = doc_prefix_format + decimalformat.format(double_doc_current_no_seq + 1.0D);
			
			et_setDocNumber(SepoaTransactionalResource1, user_id, house_code, doc_type, doc_prefix_format);
			SepoaOut.message = "Succeed Processing!";
			as[0] = doc_prefix_format;
			SepoaOut.result = as;
			SepoaOut.status = 1;
			SepoaTransactionalResource.getUserTransaction().commit();
		} catch (Exception exception) {
			Logger.err.println("Exception e =" + exception.getMessage());
			SepoaOut.status = 0;
			SepoaOut.message = exception.getMessage();
			try {
				if(SepoaTransactionalResource != null){ SepoaTransactionalResource.getUserTransaction().rollback(); }
			} catch (Exception exception1) {
				Logger.err.println("Exception e =" + exception1.getMessage());
			}
		}

		/*
		 * break MISSING_BLOCK_LABEL_752; local;
		 * SepoaTransactionalResource.release(); JVM INSTR ret 28; return
		 * SepoaOut;
		 */

		finally {
			if(SepoaTransactionalResource != null){ SepoaTransactionalResource.release(); }
		}
		return SepoaOut;
	}

	public static synchronized SepoaOut getDocNumberRemote(SepoaInfo SepoaInfo, String doc_type, String prefix_format_append) {
		SepoaTransactionalResource SepoaTransactionalResource;
		SepoaOut SepoaOut;
		SepoaTransactionalResource = null;
		SepoaOut = new SepoaOut();

		try {
			SepoaTransactionalResource SepoaTransactionalResource1;
			String as[];
			SepoaFormater SepoaFormater;
			SepoaTransactionalResource = new SepoaTransactionalResource();
			SepoaTransactionalResource.getUserTransaction();
			SepoaTransactionalResource1 = SepoaTransactionalResource;
			as = new String[1];
			String house_code = SepoaInfo.getSession("HOUSE_CODE");
			String user_id = SepoaInfo.getSession("ID");

			as[0] = et_getDocNumber(SepoaTransactionalResource1, user_id, house_code, doc_type);
			SepoaFormater = new SepoaFormater(as[0]);

			if (SepoaFormater.getRowCount() < 1) {
				SepoaOut.message = "Data Not Found!";
				Logger.err.println(user_id, SepoaOut, SepoaOut.message);

				SepoaOut.result = as;
				SepoaOut.status = 0;
				SepoaTransactionalResource.getUserTransaction().rollback();

				SepoaOut SepoaOut3 = SepoaOut;
				SepoaOut SepoaOut1 = SepoaOut3;

				return SepoaOut1;
			}

			int doc_end_no_length;
			String current_no; // current_no
			String prefix_format; // prefix_format
			String tmp_prefix_format;
			String year_flag; // year_flag
			String month_flag; // month_flag
			String day_flag; // day_flag
			String empty_string; // empty_string
			String _prefix_format_append;

			double doc_start_no = Double.parseDouble(SepoaFormater.getValue(0, 0));
			double doc_end_no = Double.parseDouble(SepoaFormater.getValue(0, 1));
			doc_end_no_length = SepoaFormater.getValue(0, 1).length();
			current_no = SepoaFormater.getValue(0, 2);
			prefix_format = SepoaFormater.getValue(0, 3); // prefix_format .5.
			tmp_prefix_format = SepoaFormater.getValue(0, 3); // prefix_format .5.
			year_flag = SepoaFormater.getValue(0, 4);
			month_flag = SepoaFormater.getValue(0, 5);
			day_flag = SepoaFormater.getValue(0, 6);

			empty_string = ""; // 9.
			_prefix_format_append = prefix_format; // 10.
			String doc_current_no_seq = SepoaFormater.getValue(0, 2).substring(SepoaFormater.getValue(0, 2).length() - doc_end_no_length, SepoaFormater.getValue(0, 2).length());
			double double_doc_current_no_seq = Double.parseDouble(doc_current_no_seq);

			if (double_doc_current_no_seq + 1.0D > doc_end_no) {
				SepoaOut.message = "Number Range Full!";
				Logger.err.println(user_id, SepoaOut, SepoaOut.message);

				SepoaOut.result = as;
				SepoaOut.status = 0;

				SepoaTransactionalResource.getUserTransaction().rollback();
				SepoaOut SepoaOut4 = SepoaOut;
				SepoaOut SepoaOut2 = SepoaOut4;

				return SepoaOut2;
			}

			for (int j = 0; j < doc_end_no_length; j++)
				empty_string = empty_string + "0";

			DecimalFormat decimalformat = new DecimalFormat(empty_string);
			_prefix_format_append = _prefix_format_append + prefix_format_append;
			/**
			 * ÷������ ä���� ��� prefix_format+house_code�� �־� �ߺ��� �����Ѵ�.
			 * 2012.03.07 HMCHOI
			 */
			if (tmp_prefix_format.equalsIgnoreCase("AT")) {
				prefix_format = prefix_format + house_code;
				_prefix_format_append = _prefix_format_append + house_code;
			}
			
			if (year_flag.equals("Y")) {
				prefix_format = prefix_format + String.valueOf(SepoaDate.getYear()).substring(2,4);
				_prefix_format_append = _prefix_format_append + String.valueOf(SepoaDate.getYear()).substring(2,4);
			}

			if (month_flag.equals("Y")) {
				DecimalFormat decimalformat1 = new DecimalFormat("00");
				prefix_format = prefix_format + decimalformat1.format(SepoaDate.getMonth());
				_prefix_format_append = _prefix_format_append + decimalformat1.format(SepoaDate.getMonth());
			}

			if (day_flag.equals("Y")) {
				DecimalFormat decimalformat2 = new DecimalFormat("00");
				prefix_format = prefix_format + decimalformat2.format(SepoaDate.getDay());
				_prefix_format_append = _prefix_format_append + decimalformat2.format(SepoaDate.getDay());
			}

			if (current_no.indexOf(prefix_format) == -1) {
				prefix_format = prefix_format + decimalformat.format(doc_start_no);
				_prefix_format_append = _prefix_format_append + decimalformat.format(doc_start_no);
			} else {
				prefix_format = prefix_format + decimalformat.format(double_doc_current_no_seq + 1.0D);
				_prefix_format_append = _prefix_format_append + decimalformat.format(double_doc_current_no_seq + 1.0D);
			}
			et_setDocNumber(SepoaTransactionalResource1, user_id, house_code, doc_type, prefix_format);
			SepoaOut.message = "Succeed Processing!";
			as[0] = _prefix_format_append.substring(1, _prefix_format_append.length());
			SepoaOut.result = as;
			SepoaOut.status = 1;
			SepoaTransactionalResource.getUserTransaction().commit();
		} catch (Exception exception) {
			Logger.err.println("Exception e =" + exception.getMessage());
			SepoaOut.status = 0;
			SepoaOut.message = exception.getMessage();
			try {
				if(SepoaTransactionalResource != null){ SepoaTransactionalResource.getUserTransaction().rollback(); }
			} catch (Exception exception1) {
				Logger.err.println("Exception e =" + exception1.getMessage());
			}
		} finally {
			if(SepoaTransactionalResource != null){ SepoaTransactionalResource.release(); }
		}

		return SepoaOut;
	}

	public static synchronized String getMenuList(String s, String s1, String s2) {
		SepoaConnectionResource SepoaConnectionResource = null;
		String s3 = "";

		try {
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource SepoaConnectionResource1 = SepoaConnectionResource;
			s3 = et_getMenuList(SepoaConnectionResource1, s, s1, s2);
		} catch (Exception exception) {
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return s3;
	}

	public static synchronized String getMenuList(String s, String s1, String s2, String s3) {
		SepoaConnectionResource SepoaConnectionResource = null;
		String s4 = "";

		try {
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource SepoaConnectionResource1 = SepoaConnectionResource;
			s4 = et_getMenuList(SepoaConnectionResource1, s, s1, s3, s2);
		} catch (Exception exception) {
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return s4;
	}

	public static synchronized String getMenuList_MY(SepoaInfo SepoaInfo, String s, String s1, String s2, String s3) {
		SepoaConnectionResource SepoaConnectionResource = null;
		String s4 = "";
		String s5 = "";
		boolean flag = false;
		byte byte0 = -1;
		byte byte1 = -1;

		try {
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource SepoaConnectionResource1 = SepoaConnectionResource;
			String s6 = et_getInitFlag(SepoaInfo, SepoaConnectionResource1, s, s1);
			SepoaFormater SepoaFormater = new SepoaFormater(s6);
			int i = Integer.parseInt(SepoaFormater.getValue(0, 0));

			if (i <= 0) {
				int j = et_setICOMMUMY_Init(SepoaInfo, SepoaConnectionResource1, s, s1);
			}

			int k = et_setMenuDelete_MY(SepoaInfo, SepoaConnectionResource1);
			s4 = et_getMenuList_MY(SepoaConnectionResource1, s, s1, s3, s2);
			SepoaConnectionResource.getConnection().commit();
		} catch (Exception exception) {
			try {
				if(SepoaConnectionResource != null){ SepoaConnectionResource.getConnection().rollback(); }
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				Logger.err.println("SQLException e =" + e.getMessage());
			}
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return s4;
	}

	public static synchronized String getMenuTitle(String s, String s1, String s2) {
		SepoaConnectionResource SepoaConnectionResource = null;
		String s3 = "";

		try {
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource SepoaConnectionResource1 = SepoaConnectionResource;
			s3 = et_getMenuTitle(SepoaConnectionResource1, s, s1, s2);
		} catch (Exception exception) {
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return s3;
	}

	public static synchronized int getValidateProfile(String s, String s1, String s2, String s3) {
		SepoaConnectionResource SepoaConnectionResource = null;
		int i = 0;

		try {
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource SepoaConnectionResource1 = SepoaConnectionResource;
			i = et_getValidateProfile(SepoaConnectionResource1, s, s1, s2, s3);
		} catch (Exception exception) {
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return i;
	}

	public static synchronized String getVendorMenuTitle(String s, String s1, String s2, String s3) {
		SepoaConnectionResource SepoaConnectionResource = null;
		String s4 = "";

		try {
			SepoaConnectionResource = new SepoaConnectionResource();
			SepoaConnectionResource SepoaConnectionResource1 = SepoaConnectionResource;
			s4 = et_getVendorMenuTitle(SepoaConnectionResource1, s, s1, s2, s3);
		} catch (Exception exception) {
			Logger.err.println("Exception e =" + exception.getMessage());
		} finally {
			if(SepoaConnectionResource != null){ SepoaConnectionResource.release(); }
		}

		return s4;
	}

	private static String et_getVendorMenuTitle(ConnectionContext connectioncontext, String s, String s1, String s2, String s3) throws Exception {
		String s4 = null;

		try {
			StringBuffer stringbuffer = new StringBuffer();

			SepoaXmlParser p = new SepoaXmlParser("wisecommon/appcommon", "et_getVendorMenuTitle");
			p.addVar("house_code", s);
			p.addVar("vendor_code", s1);
			p.addVar("menu_profile_code", s3);

			SepoaSQLManager SepoaSQLManager = new SepoaSQLManager(s2, stringbuffer, connectioncontext, p.getQuery());
			s4 = SepoaSQLManager.doSelect((String[])null);
		} catch (Exception exception) {
			throw new Exception("getMenuTitle:" + exception.getMessage());
		}

		return s4;
	}

}