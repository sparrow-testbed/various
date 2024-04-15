<%@ page import="wise.cfg.Configuration" %>

<%@ page import="wise.db.WiseConnectionResource" %>
<%@ page import="wise.db.WiseSQLManager"%>
<%@ page import="wise.db.WiseXmlParser"%>
<%@ page import="wise.util.WiseFormater"%>

<%
	String houseCode   = info.getSession("HOUSE_CODE");
	String companyCode = info.getSession("COMPANY_CODE");

	String totalCnt = "0";
	String companyCnt = "0";
	String supplyCnt = "0";

	Configuration wise_conf = new Configuration();
	String maxCnt = wise_conf.getString("wise.max.user." + info.getSession("HOUSE_CODE"));
	
	WiseConnectionResource wiseconnectionresource;
	wiseconnectionresource = null;

	try{
		wiseconnectionresource = new WiseConnectionResource();
		String userCnt = "0";
		StringBuffer sql = new StringBuffer();
		try {
			WiseXmlParser p = new WiseXmlParser("master/user/p0030", "et_getAvailableUser");
			p.addVar("company_code", companyCode);
			p.addVar("house_code", houseCode);

			WiseSQLManager wisesqlmanager = new WiseSQLManager(info.getSession("USER_ID"), sql, wiseconnectionresource, p.getQuery());
			userCnt = wisesqlmanager.doSelect(null);
		} catch (Exception exception) {
			throw new Exception("et_CheckCnt:" + exception.getMessage());
		}
		
		WiseFormater wiseformater = new WiseFormater(userCnt);		
		//Logger.debug.println("userCnt:"+wiseformater.getValue("USER_CNT", 0));
		
		totalCnt = wiseformater.getValue("TOTAL_CNT", 0);
		companyCnt = wiseformater.getValue("COMPANY_CNT", 0);
		supplyCnt = wiseformater.getValue("SUPPLY_CNT", 0);
		
	}catch(Exception e){
		Logger.debug.println(e.getMessage());
	}
%>