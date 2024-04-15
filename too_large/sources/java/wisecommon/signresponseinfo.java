package wisecommon;

import sepoa.fw.util.SepoaDate;

public class SignResponseInfo {

	public SignResponseInfo() {
		HouseCode = "";
		DocType = "";
		SignUserId = "";
		SignStatus = "";
		SignDate = "";
		SignTime = "";
		SignRemark = "";
		SignDate = SepoaDate.getShortDateString();
		SignTime = SepoaDate.getShortTimeString();
		
		user_trm_no = "";		
	}

	public SignResponseInfo(String s, String as[], String as1[], String s1) {
		HouseCode = "";
		DocType = "";
		SignUserId = "";
		SignStatus = "";
		SignDate = "";
		SignTime = "";
		SignRemark = "";
		SignDate = SepoaDate.getShortDateString();
		SignTime = SepoaDate.getShortTimeString();
		HouseCode = s;
		DocNo = as;
		DocSeq = as1;
		SignStatus = s1;
		
		user_trm_no = "";		
	}

	public String getHouseCode() {
		return HouseCode;
	}

	public String[] getCompanyCode() {
		return CompanyCode;
	}

	public String[] getDept() {
		return Dept;
	}

	public String getDocType() {
		return DocType;
	}

	public String[] getDocNo() {
		return DocNo;
	}

	public String[] getDocSeq() {
		return DocSeq;
	}

	public String getSignUserId() {
		return SignUserId;
	}

	public String getSignStatus() {
		return SignStatus;
	}

	public String getSignDate() {
		return SignDate;
	}

	public String getSignTime() {
		return SignTime;
	}

	public String[] getShipperType() {
		return ShipperType;
	}

	public String getSignRemark() {
		return SignRemark;
	}
	
	public String[] getAppStage() {
		return AppStage;
	}
	
	
	

	public void setHouseCode(String s) {
		HouseCode = s;
	}

	public void setCompanyCode(String as[]) {
		CompanyCode = as;
	}

	public void setDept(String as[]) {
		Dept = as;
	}

	public void setDocType(String s) {
		DocType = s;
	}

	public void setDocNo(String as[]) {
		DocNo = as;
	}

	public void setDocSeq(String as[]) {
		DocSeq = as;
	}

	public void setSignUserId(String s) {
		SignUserId = s;
	}

	public void setSignStatus(String s) {
		SignStatus = s;
	}

	public void setShipperType(String as[]) {
		ShipperType = as;
	}

	public void setSignRemark(String s) {
		SignRemark = s;
	}
	
	public void setAppStage(String as[]) {
		AppStage = as;
	}
	

	private String HouseCode;
	private String CompanyCode[];
	private String Dept[];
	private String DocType;
	private String DocNo[];
	private String DocSeq[];
	private String SignUserId;
	private String SignStatus;
	private String SignDate;
	private String SignTime;
	private String ShipperType[];
	private String SignRemark;
	private String AppStage[];
	
	
	//단말정보 시작//////////////////////////////////////////////////
	private String user_trm_no;
	
	public void setUser_trm_no(String s) { user_trm_no = s; }
	
	public String getUser_trm_no() { return user_trm_no;     }
	//단말정보 끝////////////////////////////////////////////////////
	
}
