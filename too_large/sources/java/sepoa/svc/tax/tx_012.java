package sepoa.svc.tax;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.lowagie.text.Header;
import com.tcApi.OT8601;
import com.tcApi.OT870100;
import com.tcComm.ONCNF;
import com.tcJun.LIST_OT8601R;
import com.tcLib.pvUtil;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;
//import erp.ERPInterface;

public class TX_012 extends SepoaService {
	Message msg = new Message(info, "TX_012");  // message 처리를 위해 전역변수 선언

	public TX_012(String opt, SepoaInfo info) throws SepoaServiceException {
    	super(opt, info);
		setVersion("1.0.0");
		Configuration configuration = null;

		try {
			configuration = new Configuration();
		} catch(ConfigurationException cfe) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
		}
    }

	/**
	 * @Method Name : getConfig
	 * @작성일 : 2011. 12. 10
	 * @작성자 :
	 * @변경이력 :
	 * @Method 설명 :
	 * @param s
	 * @return
	 */
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

	
	/*  거래명세서 목록 조회 */
	public SepoaOut getPayOperateExpenseList(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getPayOperateExpenseList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getPayOperateExpenseList(Map<String, String> header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getPayOperateExpenseList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	/*  거래명세서 목록 조회 */
	public SepoaOut getItemList(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getItemList(header);
			
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getItemList(Map<String, String> header) throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getPayOperateExpenseList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/*  거래명세서 목록 조회 */
	public SepoaOut getUserTrmNo(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getUserTrmNo(header);
			
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getUserTrmNo(Map<String, String> header) throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getUserTrmNo:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/*  거래명세서 목록 조회 */
	public SepoaOut getSpy2List(Map<String, String> header) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			header.put("house_code", house_code);
			
			String rtnHD = bl_getSpy2List(header);
			
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getSpy2List(Map<String, String> header) throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getSpy2List:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	/*  거래명세서 목록 조회 */
	public SepoaOut getOperateExpenseHeader(String tax_no) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			String rtnHD = bl_getOperateExpenseHeader(tax_no);
			
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getOperateExpenseHeader(String tax_no)
			throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("tax_no", tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect();
		} catch (Exception e) {
			throw new Exception("bl_getPayOperateExpenseList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	/*  거래명세서 목록 조회 */
	public SepoaOut getOperateExpenseDetail(String pay_act_no) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			String rtnHD = bl_getOperateExpenseDetail(pay_act_no);
			
			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getOperateExpenseDetail(String pay_act_no) throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("pay_act_no", pay_act_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect();
		} catch (Exception e) {
			throw new Exception("bl_getPayOperateExpenseList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut setApproval(Map<String, Object> data) throws Exception{
		
		ConnectionContext ctx = getConnectionContext();
		String	 pay_act_no = "";
		String   rtn        = null;
		Map<String, String> gridRowData        = null;
		List<Map<String, String>> girdData = null;
		
		SepoaOut so = new SepoaOut();
		
		try {
			
			Map<String, String> headerData = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			girdData = (List<Map<String,String>>)MapUtils.getObject(data, "gridData");
			
			for (int i = 0; i < girdData.size(); i++) {
				gridRowData = (Map <String , String>) girdData.get(i);
			}
			
			SepoaOut wo = DocumentUtil.getDocNumber(info,"PSA");
			pay_act_no = wo.result[0];
			String 	approval_str	= headerData.get("approval_str");
			String 	subject 		= "경상비지급_" + pay_act_no;
			int 	itemSize 		= Integer.parseInt(headerData.get("itemSize"));
			String    user_trm_no  = headerData.get("user_trm_no");
			
			headerData.put("pay_act_no"	, pay_act_no);
			headerData.put("act_date"	, headerData.get("act_date").replaceAll("\\/", ""));
			headerData.put("std_date"	, headerData.get("std_date").replaceAll("\\/", ""));
			headerData.put("ISU_DT"	    , (gridRowData != null)?gridRowData.get("ISU_DT").replaceAll("\\/", ""):"");
			headerData.put("RGS_DT"	    , (gridRowData != null)?gridRowData.get("RGS_DT").replaceAll("\\/", ""):"");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doInsert(headerData);

			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doInsert(headerData);
			
			//결재처리
//			rtn = setPAYCreateSignRequestInfo(pay_act_no, approval_str, subject, itemSize, user_trm_no);			
//			if("1".equals(rtn)){
//				Commit();
//			}else{
//				setFlag(false);
//				setStatus(0);
//				setMessage("실패");
//				Rollback();
//				throw new Exception();
//			}
			
			so = setPAYCreateSignRequestInfo_tobe(pay_act_no, approval_str, subject, itemSize, user_trm_no);
			if(so.status == 0){            
				setFlag(false);             
				setStatus(0);  				
				setMessage(msg.getMessage(so.message));           
				Rollback();                 
				throw new Exception();				                   
			}else{                          
				Commit();      
			}                               
			
		} catch (Exception e) {
			Logger.err.println("setApproval: = " + e.getMessage());
		}
		return getSepoaOut();
	}
	
	private String setPAYCreateSignRequestInfo(String pay_act_no, String approval_str, String subject, int itemSize, String user_trm_no) {
		String              add_user_id       =  info.getSession("ID");
        String              house_code        =  info.getSession("HOUSE_CODE");
        String              company           =  info.getSession("COMPANY_CODE");
        String              add_user_dept     =  info.getSession("DEPARTMENT");
        int                 signRtn           = 0;
        String              result            = "0";
        
        SignRequestInfo sri = new SignRequestInfo();
        sri.setHouseCode(house_code);
        sri.setCompanyCode(company);
        sri.setDept(add_user_dept);
        sri.setReqUserId(add_user_id);
        sri.setDocType("PAY");
        sri.setDocNo(pay_act_no);
        sri.setDocSeq("1");
        sri.setDocName(subject);
        sri.setItemCount(itemSize);
        sri.setSignStatus("P");
        sri.setCur("KRW");
        sri.setTotalAmt(Double.parseDouble("0"));
        sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
        sri.setUser_trm_no(user_trm_no);
        
        try {
        	signRtn = CreateApproval(info,sri);    //밑에 함수 실행
        	
        	if(signRtn == 0) {
        		Rollback();
        	}else{
        		result = "1"; 
        	}
			
		} catch (Exception e) {
			Logger.err.println("setPAYCreateSignRequestInfo: = " + e.getMessage());
		}
		return result;
	}
	
	private SepoaOut setPAYCreateSignRequestInfo_tobe(String pay_act_no, String approval_str, String subject, int itemSize, String user_trm_no) {
		String              add_user_id       =  info.getSession("ID");
        String              house_code        =  info.getSession("HOUSE_CODE");
        String              company           =  info.getSession("COMPANY_CODE");
        String              add_user_dept     =  info.getSession("DEPARTMENT");
        int                 signRtn           = 0;
        String              result            = "0";
        SepoaOut            so  = new SepoaOut();
        
        SignRequestInfo sri = new SignRequestInfo();
        sri.setHouseCode(house_code);
        sri.setCompanyCode(company);
        sri.setDept(add_user_dept);
        sri.setReqUserId(add_user_id);
        sri.setDocType("PAY");
        sri.setDocNo(pay_act_no);
        sri.setDocSeq("1");
        sri.setDocName(subject);
        sri.setItemCount(itemSize);
        sri.setSignStatus("P");
        sri.setCur("KRW");
        sri.setTotalAmt(Double.parseDouble("0"));
        sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
        sri.setUser_trm_no(user_trm_no);
        
        try {
        	so = CreateApproval_tobe(info,sri);    //밑에 함수 실행
        	
        	if(so.status == 0) {
        		Rollback();
        	}
			
		} catch (Exception e) {
			Logger.err.println("setPAYCreateSignRequestInfo: = " + e.getMessage());
		}
		return so;
	}

	
	private int CreateApproval(SepoaInfo info,SignRequestInfo sri) throws Exception
    {
        SepoaOut wo     = new SepoaOut();
        SepoaRemote ws  ;
        String nickName= "p6027";
        String conType = "NONDBJOB";
        String MethodName1 = "setConnectionContext";
        ConnectionContext ctx = getConnectionContext();

        try
        {
            Object[] obj1 = {ctx};
            String MethodName2 = "addSignRequest";
            Object[] obj2 = {sri};

            ws = new SepoaRemote(nickName,conType,info);
            ws.lookup(MethodName1,obj1);
            wo = ws.lookup(MethodName2,obj2);
        }catch(Exception e) {
            Logger.err.println("CreateApproval: = " + e.getMessage());
            Logger.sys.println("CreateApproval: = " + e.getMessage());
        }
        return wo.status ;
    }
	
	private SepoaOut CreateApproval_tobe(SepoaInfo info,SignRequestInfo sri) throws Exception
    {
        SepoaOut wo     = new SepoaOut();
        SepoaRemote ws  ;
        String nickName= "p6027";
        String conType = "NONDBJOB";
        String MethodName1 = "setConnectionContext";
        ConnectionContext ctx = getConnectionContext();

        try
        {
            Object[] obj1 = {ctx};
            String MethodName2 = "addSignRequest";
            Object[] obj2 = {sri};

            ws = new SepoaRemote(nickName,conType,info);
            ws.lookup(MethodName1,obj1);
            wo = ws.lookup(MethodName2,obj2);
        }catch(Exception e) {
            Logger.err.println("CreateApproval: = " + e.getMessage());
            Logger.sys.println("CreateApproval: = " + e.getMessage());
        }
        return wo ;
    }		
	
	
	public SepoaOut setPydtmApvNoUpdate(Map<String, String> data) {
		
		ConnectionContext ctx = getConnectionContext();
		String	 pay_act_no = "";
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doUpdate(data);
			
			Commit();
			//Rollback();
			
		} catch (Exception e) {
			Logger.err.println("setPydtmApvNoUpdate: = " + e.getMessage());
		}
		return getSepoaOut();
	}
	
	/*  책임자 지정 */
	public SepoaOut setSignerUpdate(Map<String, Object> data) throws Exception{
		
		ConnectionContext ctx = getConnectionContext();
		try {
			
			setStatus(1);
			setFlag(true);
			
			Map<String, String> headerData = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doUpdate(headerData);
			
			Commit();
			
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
//			e.printStackTrace();
			Logger.err.println("setSignerDefine: = " + e.getMessage());
		}
		return getSepoaOut();
	}
	
	/*  1차 책임자 승인 */
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy2glSigner1(Map<String, String> header) throws Exception{
		ConnectionContext ctx = getConnectionContext();
		try {
			
			setStatus(1);
			setFlag(true);
			
			//Map<String, String> headerData = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			//System.out.println("headerData:"+headerData);
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doUpdate(header);
			
			Commit();
			
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
//			e.printStackTrace();
			Logger.err.println("setSignerDefine: = " + e.getMessage());
		}
		return getSepoaOut();
    }
	
	public SepoaOut setExecuteNoUpdate(Map<String, String> data) throws Exception {
		
		ConnectionContext ctx = getConnectionContext();
		String	 pay_act_no = "";
		
		SepoaXmlParser wxp = null;
		SepoaSQLManager sm = null;
		
		try {
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doUpdate(data);
			
			Commit();
			
			
		} catch (Exception e) {
			Rollback();
			Logger.err.println("setExecuteNoUpdate: = " + e.getMessage());
		}
		return getSepoaOut();
	}
	
	public SepoaOut setSlipNoUpdate(Map<String, String> data) throws Exception {
		
		ConnectionContext ctx = getConnectionContext();
		String	 pay_act_no = "";
		
		SepoaXmlParser wxp = null;
		SepoaSQLManager sm = null;
		
		try {
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doUpdate(data);
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doUpdate(data);
			
			Commit();
			
			
		} catch (Exception e) {
			Rollback();
			Logger.err.println("setApproval: = " + e.getMessage());
		}
		return getSepoaOut();
	}

    //TOBE 2017-07-01 추가  경상비 경비집행완료 상태코드 업데이트
	public SepoaOut setSlipNoUpdateF(Map<String, String> data) throws Exception {
		
		ConnectionContext ctx = getConnectionContext();
		String	 pay_act_no = "";
		
		SepoaXmlParser wxp = null;
		SepoaSQLManager sm = null;
		
		try {
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			sm.doUpdate(data);
			
			Commit();
			
			
		} catch (Exception e) {
			Rollback();
			Logger.err.println("setApproval: = " + e.getMessage());
		}
		return getSepoaOut();
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateSpy2glExeTryDt(Map<String, String> data) throws Exception{
        ConnectionContext   ctx        = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
		   this.update(ctx, "updateSpy2glExeTryDt", data);
            
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
	
	private int update(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doUpdate(param);
		
		return result;
	}

	
} // END

