package sepoa.svc.tax;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;
//import erp.ERPInterface;

public class TX_002 extends SepoaService {
	Message msg = new Message(info, "IV_001");  // message 처리를 위해 전역변수 선언

	public TX_002(String opt, SepoaInfo info) throws SepoaServiceException {
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
	public SepoaOut getTrList(Map<String, String> header) {
		try {
			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getTrList(header);

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
	
	private String bl_getTrList(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getTrList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getTrList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/*   반려사유 항목 조회 */
	public SepoaOut getTxViewReject_reason(String tax_no){
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getTxViewReject_reason(house_code, tax_no);

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
	
	private String bl_getTxViewReject_reason(String house_code, String tax_no)throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("tax_no"	   , tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect();
		} catch (Exception e) {
			throw new Exception("bl_getTxViewReject_reason:" + e.getMessage());
		} finally {
		}
		return rtn;	
	}	
	
	/* 세금계산서 상태 변경 */	
	public SepoaOut setProgressCode(String tax_no, String progress_code){
		int rtn = 0;
			
		 try {
			rtn = et_setProgressCode(tax_no, progress_code);

		}catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(userid, this, d.getMessage());
			}
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	/* 세금계산서 상태 변경 */	
	public SepoaOut setPayFinish(String[][] args, String  progress_code){
		int rtn = 0;
			
		 try {
			rtn = et_setProgressCodes(args, progress_code);
			 if(rtn == 0) {
	             try {
	                 Rollback();
	             } catch(Exception d) {
	                 Logger.err.println(info.getSession("ID"),this,d.getMessage());
	             }
	             setStatus(0);
	             setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
	             return getSepoaOut();
	         }else {
	        	 setStatus(1);
	             setValue(String.valueOf(rtn));
	        	 Commit();
	         }
		}catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(userid, this, d.getMessage());
			}
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}
	private int et_setProgressCodes(String [][] args, String  progress_code) throws Exception{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try {
			ConnectionContext ctx =	getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("progress_code"	, progress_code);
			SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
			

			String[] type1 = {"S","S","S","S"};
			rtn = sm.doUpdate(args, type1);
	

		} catch(Exception	e) {
			throw new Exception("et_setProgressCodes:"+e.getMessage());
		}
		
		return rtn;		
	}
	
	private int et_setProgressCode(String tax_no, String progress_code) throws Exception{
		String[] erpTax_result = new String[2];
		
		if(progress_code.equals("O")){ //공급사 발행 취소	
			// 정산 I / F
			// ERP로 넘기 데이터 가져오기 (삭제)
//			ERPInterface erpIF = new ERPInterface("CONNECTION",info);
//			erpTax_result = erpIF.erpTaxInsert(getERPTaxList(tax_no),"D");
		}		
		
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		String code = "";
		if ( progress_code.equals("OR") ) {
			code = "O";
		} else {
			code = progress_code;
		}
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String user_id = info.getSession("ID");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" 	, house_code);
			wxp.addVar("user_id"		, user_id);
			wxp.addVar("tax_no"			, tax_no);
			wxp.addVar("progress_code"	, code);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();
		
			
			
			if(progress_code.equals("O")){ //공급사 발행 취소	
				if(!erpTax_result[0].equals("2")){
			       	 setStatus(1);
			         setValue(String.valueOf(rtn));
			    	 Commit();					
				}else{
					Rollback();
					setStatus(0);
					setMessage(erpTax_result[1]);
				}	
			}else{
				setStatus(1);
		         setValue(String.valueOf(rtn));
		    	 Commit();	
			}
		
		}catch (Exception e) {
			throw new Exception("up_setProgressCode:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 세금계산서 운영사 반려사유 등록 */	
	public SepoaOut setBuyerRejectRemark(String tax_no, String buyerRejectRemark){
		int rtn = 0;
			
		 try {
			rtn = et_setBuyerRejectRemark(tax_no, buyerRejectRemark);
			 if(rtn == 0) {
	             try {
	                 Rollback();
	             } catch(Exception d) {
	                 Logger.err.println(info.getSession("ID"),this,d.getMessage());
	             }
	             setStatus(0);
	             setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
	             return getSepoaOut();
	         }else {
	        	 setStatus(1);
	             setValue(String.valueOf(rtn));
	        	 Commit();
	         }
		}catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(userid, this, d.getMessage());
			}
			setStatus(0);
			setMessage(e.getMessage());
			Logger.err.println(this, e.getMessage());
		}
		return getSepoaOut();
	}
	
	private int et_setBuyerRejectRemark(String tax_no, String buyerRejectRemark) throws Exception{
		
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String user_id = info.getSession("ID");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" 	, house_code);
			wxp.addVar("user_id"		, user_id);
			wxp.addVar("tax_no"			, tax_no);
			wxp.addVar("buyerRejectRemark"	, buyerRejectRemark);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();
			
		}catch (Exception e) {
			throw new Exception("et_setBuyerRejectRemark:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	// 세금계산서 발행대상 조회
	public SepoaOut getTxHD(String tax_no){
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getTxHD(house_code, tax_no);

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
	
	private String bl_getTxHD(String house_code, String tax_no)throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("tax_no"	   , tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect();
		} catch (Exception e) {
			throw new Exception("bl_getTxHD:" + e.getMessage());
		} finally {
		}
		return rtn;	
	}	

	public SepoaOut getTxDT(String tax_no){
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getTxDT(house_code, tax_no);

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
	
	private String bl_getTxDT(String house_code, String tax_no)throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("tax_no"	   , tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect();
		} catch (Exception e) {
			throw new Exception("bl_getTxDT:" + e.getMessage());
		} finally {
		}
		return rtn;	
	}	
	
	
	
	public SepoaOut setTxTaxAppNo(String tax_no, String tax_app_no, String tax_date, String attach_no, String progress_code)
	{
		String user_id		 = info.getSession("ID");
		int value = 0;
		try {

			value = et_setTxTaxAppNo(tax_no, tax_app_no, tax_date, attach_no);

			 if(value == 0) {
	             try {
	                 Rollback();
	             } catch(Exception d) {
	                 Logger.err.println(info.getSession("ID"),this,d.getMessage());
	             }
	             setStatus(0);
	             setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
	             return getSepoaOut();
	         }else {
	        	 setStatus(1);
	             setValue(String.valueOf(value));
	             
	            if(progress_code.equals("I")) 
	            	setMessage("전송 되었습니다.");
	            else
	            	setMessage("저장 되었습니다.");
	            
	        	 Commit();
	        	 
	         }
		}
		catch(Exception e) {

			try {
				Rollback();
			} catch(Exception re) {
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		return getSepoaOut();
	}
	

	private int et_setTxTaxAppNo(String tax_no, String tax_app_no, String tax_date, String attach_no) throws Exception{
		
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String user_id = info.getSession("ID");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" 	, house_code);
			wxp.addVar("user_id"		, user_id);
			wxp.addVar("tax_no"			, tax_no);
			wxp.addVar("tax_app_no"		, tax_app_no);
			wxp.addVar("tax_date"		, tax_date);
			wxp.addVar("attach_no"		, attach_no);			
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();
			
		}catch (Exception e) {
			throw new Exception("et_setTxTaxAppNo:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	public SepoaOut getTxList2(String from_date,String to_date,String tax_app_no,String progress_code,String tax_div){
		try {
			String rtn = bl_getTxList2(from_date, to_date,tax_app_no, progress_code, tax_div);

			SepoaFormater wf = new SepoaFormater(rtn);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtn);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();			
	}
	private String bl_getTxList2(String from_date,String to_date,String tax_app_no,String progress_code,String tax_div) throws Exception{
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			String house_code 	= info.getSession("HOUSE_CODE");
			String company_code = info.getSession("COMPANY_CODE");
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code"		, house_code);
			wxp.addVar("company_code"	, company_code);
			wxp.addVar("from_date"		, from_date);
			wxp.addVar("to_date"		, to_date);
			wxp.addVar("tax_app_no"		, tax_app_no);
			wxp.addVar("progress_code"	, progress_code);
			wxp.addVar("tax_div"		, tax_div);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { from_date, to_date,tax_app_no, progress_code, tax_div };
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			throw new Exception("bl_getTxList2:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	// 세금계산서 현황
	public SepoaOut getTaxList(String from_date, String to_date, 
								 String tax_from_date, String tax_to_date, 
								 String vendor_code,String progress_code ,String tax_div,
								 String tax_app_no, String sign_status, String ctrl_person_id){
		try {
			String rtn = bl_getTaxList(from_date, to_date, tax_from_date, tax_to_date, vendor_code, progress_code, 
										  tax_div, tax_app_no, sign_status, ctrl_person_id );

			SepoaFormater wf = new SepoaFormater(rtn);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtn);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();			
	}
	
	private String bl_getTaxList(String from_date, String to_date, 
			 String tax_from_date, String tax_to_date, 
			 String vendor_code, String progress_code ,String tax_div,
			 String tax_app_no, String sign_status, String ctrl_person_id) throws Exception{
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			String house_code 	= info.getSession("HOUSE_CODE");
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code"		, house_code);
			wxp.addVar("from_date"		, from_date);
			wxp.addVar("to_date"		, to_date);
			wxp.addVar("tax_from_date"	, tax_from_date);
			wxp.addVar("tax_to_date"	, tax_to_date);
			wxp.addVar("vendor_code"	, vendor_code);
			wxp.addVar("progress_code"	, progress_code);
			wxp.addVar("tax_div"		, tax_div);
			wxp.addVar("tax_app_no"		, tax_app_no);
			wxp.addVar("sign_status"	, sign_status);
			wxp.addVar("ctrl_person_id"	, ctrl_person_id);		
			
			if(progress_code.equals("PE")){
				progress_code = "";
			}

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { vendor_code, from_date, to_date, tax_from_date, tax_to_date, progress_code, tax_div, tax_app_no, sign_status, ctrl_person_id};
			rtn = sm.doSelect(args);
		} catch (Exception e) {
			throw new Exception("bl_getTaxList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
    public SepoaOut setApproval(String[] tax_no_list,String[] pay_end_date_list, String project,String sign_status,String approval_str){
		String user_id		 = info.getSession("ID");
		int value = 0;
		int index = 0 ;
		String prject_group = "";
		String tax_no_1 = tax_no_list[0];
		try {
			
			if(tax_no_list.length == 1){
				prject_group = project ;
			}else{
				prject_group = project + " 외 " +  (tax_no_list.length - 1) + " 건";
			}
			// 결제시 첫번째 문서번호로 그룹 설정
			et_setGroupApproval(tax_no_list, tax_no_1);
			
			for(String tax_no : tax_no_list){
				
				value += et_setApproval(tax_no, pay_end_date_list[index], sign_status);
				index++;
			}			

			if (value > 0 && sign_status.equals("P")){
            	
				String add_user_id     = info.getSession("ID");
				String house_code      = info.getSession("HOUSE_CODE");
				String company         = info.getSession("COMPANY_CODE");
				String add_user_dept   = info.getSession("DEPARTMENT");
			
				SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("TAX");
                sri.setDocNo(tax_no_1);
                sri.setDocSeq("0");
                sri.setDocName(prject_group);
                sri.setItemCount(value);
                sri.setSignStatus(sign_status);
                sri.setShipperType("D");
                sri.setCur("KRW");
                sri.setTotalAmt(0);
                sri.setSignString(approval_str);       // AddParameter 에서 넘어온 정보
                sri.setDocName("");
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                
                if(rtn == 0) {
                    try {
                        Rollback();
                    } catch(Exception d) {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
                    return getSepoaOut();
                }
            }
	
			 if(value == 0) {
	             try {
	                 Rollback();
	             } catch(Exception d) {
	                 Logger.err.println(info.getSession("ID"),this,d.getMessage());
	             }
	             setStatus(0);
	             setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
	             return getSepoaOut();
	         }
			 Commit();
		}
		catch(Exception e) {

			try {
				Rollback();
			} catch(Exception re) {
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		return getSepoaOut();    	
    }
    
    private int et_setGroupApproval(String[] tax_no_list, String tax_no)throws Exception{
    	
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		
		String  tax_no_str = " ";
		int index = 0 ;
		// 해당 세금계산서번호들 IN 절로 변환
		for(String tax_no_tmp : tax_no_list){
			if(index == tax_no_list.length - 1){
				tax_no_str += "'" + tax_no_tmp + "'" ;
			}else{
				tax_no_str += "'" + tax_no_tmp + "', ";
			}
			index++;
		}
		
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String user_id = info.getSession("ID");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" 	, house_code);
			wxp.addVar("user_id"		, user_id);
			wxp.addVar("tax_no"			, tax_no);
			wxp.addVar("tax_no_str"		, tax_no_str);	
			
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();
			
		}catch (Exception e) {
			throw new Exception("et_setApproval:" + e.getMessage());
		} finally {
		}
		return rtn;
    	
    }

	private int et_setApproval(String tax_no,String pay_end_date_list, String sign_status) throws Exception{
		
		int rtn = 0;
		ConnectionContext ctx = getConnectionContext();
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String user_id = info.getSession("ID");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" 		, house_code);
			wxp.addVar("user_id"			, user_id);
			wxp.addVar("tax_no"				, tax_no);
			wxp.addVar("pay_end_date_list"	, pay_end_date_list);
			wxp.addVar("sign_status"		, sign_status);			
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate();
			
		}catch (Exception e) {
			throw new Exception("et_setApproval:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
    
	/**
	 * 결재상신(결재모듈에 필요한 생성부분 : 그대로 갖다 쓴다.)
	 * @param info
	 * @param sri
	 * @return
	 */
	private int CreateApproval(SepoaInfo info,SignRequestInfo sri) throws Exception
    { 
        SepoaOut wo     		= new SepoaOut();
        SepoaRemote ws  		;
        String nickName		= "p6027";
        String conType 		= "NONDBJOB";
        String MethodName1 	= "setConnectionContext";
        ConnectionContext ctx = getConnectionContext();

        try {
            Object[] obj1 = {ctx};
            String MethodName2 = "addSignRequest";
            Object[] obj2 = {sri};

            ws = new SepoaRemote(nickName,conType,info);
            ws.lookup(MethodName1,obj1);
            wo = ws.lookup(MethodName2,obj2);
        }
        catch(Exception e) {
            Logger.err.println("approval: = " + e.getMessage());
        }
        
        return wo.status ;
    }
    
	/**
	 * <b> 결재를 승인한다.</b>
	 * <pre>
	 * et_Approval을 호출한다.
	 * </pre>
	 * @param inf
	 * @return
	 */
	public SepoaOut Approval(SignResponseInfo inf)
	{
		String user_id		 = info.getSession("ID");
		SepoaOut value = null;
		
		try {
			//Logger.debug.println(user_id, this, "start time = "+System.currentTimeMillis());
			value = et_Approval(inf);
			//Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
		}
		catch(Exception e) {
			//Logger.debug.println(user_id, this, "end time = "+System.currentTimeMillis());
			//Logger.debug.println(user_id, this, "***************Exception***************");
			//Logger.debug.println(user_id, this, "Exception Message = "+e.getMessage());
			//Logger.debug.println(user_id, this, "***************Exception***************");
			try {
				Rollback();
			} catch(Exception re) {
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		return value;
	}
	
	private SepoaOut et_Approval(SignResponseInfo inf) throws Exception
	{
		String user_id		 	= info.getSession("ID");
		String house_code	 	= info.getSession("HOUSE_CODE");
		Logger.debug.println(user_id,this,"############## p2055.Approval Start ################");
		
		String sign_status	= inf.getSignStatus();
		String doc_type     = inf.getDocType(); 
		String sign_date	= inf.getSignDate();
		String sign_user_id	= inf.getSignUserId();
		String progress_code  = sign_status;
		
		String[] DOC_NO	      = inf.getDocNo();
		
		Logger.debug.println(user_id,this,"############## Approval SignStatus ==> " + sign_status);

		
		if(sign_status.equals("E")){  // 모든결제가 완료시에  상태 승인으로 변경 세팅
			progress_code = "C";	
		}else if(sign_status.equals("D")){ //상신결재 취소시에 sign_status 값이 'D' 이지만 다시 결재할수 있도록 'T' 변경
			sign_status = "T";
		}
		
		for(int	i=0;i <	DOC_NO.length;i++)
		{
			SepoaOut value 	= getSignTaxList(DOC_NO[i]);
			SepoaFormater wf 	= new SepoaFormater(value.result[0]);
			
			String[][] objHD	= new String[wf.getRowCount()][];
			String[][] objHD2	= new String[wf.getRowCount()][];
			
			for(int j = 0 ; j < wf.getRowCount(); j++){
				String tax_no = wf.getValue("TAX_NO", j);
				String[] TEMP_HD_DATA = {
						  sign_status   // C 로 넘어오면 OK
						, sign_date
						, house_code
						, tax_no
					};				
					
				String[] TEMP_HD_DATA2 = {
						progress_code
						,house_code
						, tax_no
					};
				
				objHD[j] = TEMP_HD_DATA;
				objHD2[j] = TEMP_HD_DATA2;
			}
			setSignStatusUpdate(objHD,objHD2,sign_status);

		}
        						
		setStatus(1);
		setMessage("");
		
		//반려이거나 취소일 경우 여기서 끝낸다. sign_status != "E"
		if(!"E".equals(sign_status)) {
			return getSepoaOut();
		}else{
			for(int	i=0;i <	DOC_NO.length;i++)
			{     	
				String group_tax_no = DOC_NO[i];
				// 구매요청 상태 변경 
				// 구매요청현황 세금계산서 승인완료상태로 변경  -> X
    			String prev_pr_progress_flag = "V";
    			String pr_progress_flag = "X";
    			
    			
    			SepoaOut value 	= getSignTaxList(group_tax_no);
    			SepoaFormater wf 	= new SepoaFormater(value.result[0]);
    			
    			String[] erpTax_result = new String[2];
    			for(int j = 0 ; j < wf.getRowCount(); j++){
    				String tax_no = wf.getValue("TAX_NO", j);	    			 
	    			setPr_progress_flag(tax_no, prev_pr_progress_flag, pr_progress_flag);
					// 정산 I / F
	    			// ERP로 넘기 데이터 가져오기 (신규등록)
//	    			ERPInterface erpIF = new ERPInterface("CONNECTION",info);
//	    			erpTax_result = erpIF.erpTaxInsert(getERPTaxList(tax_no),"A");
	    			
	    			if(erpTax_result[0].equals("2")){
	 	    				break;
	 	    		}
    			}
    			
    			if(!erpTax_result[0].equals("2")){
    				Commit();
    			}else{
    				Rollback();
    				setStatus(0);
    				setMessage(erpTax_result[1]);
    			}
			}
			
		}
		
		return getSepoaOut();
	}
	private SepoaFormater getERPTaxList(String tax_no) throws Exception {
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("tax_no", tax_no);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect());	

		}catch (Exception e) {
			throw new Exception("getERPTaxList : " + e.getMessage());
		} finally {
		}
		return wf;
	}
	
	private int setPr_progress_flag(String doc_no, String prev_pr_progress_flag, String pr_progress_flag)throws Exception {
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		try {
			ConnectionContext ctx =	getConnectionContext();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			wxp.addVar("house_code", house_code);
			wxp.addVar("user_id", user_id);
			wxp.addVar("doc_no", doc_no);
			wxp.addVar("prev_pr_progress_flag", prev_pr_progress_flag);
			wxp.addVar("pr_progress_flag", pr_progress_flag);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			SepoaFormater wf1 = new SepoaFormater(sm.doSelect());
				
			//이전 문서아이템의 완료 갯수 조회
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			
			wxp.addVar("house_code", house_code);
			wxp.addVar("user_id", user_id);
			wxp.addVar("doc_no", doc_no);
			wxp.addVar("prev_pr_progress_flag", prev_pr_progress_flag);
			wxp.addVar("pr_progress_flag", pr_progress_flag);
			
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			SepoaFormater wf2 = new SepoaFormater(sm.doSelect());
			int tr_cnt = Integer.parseInt(wf1.getValue("TR_CNT", 0));
			int inv_cnt = Integer.parseInt(wf2.getValue("TX_CNT", 0));
			
			if( tr_cnt ==  inv_cnt ){
			
				// 이전 PR_PROGRESS_FLAG  유무 확인후 상태변경
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
				
				wxp.addVar("house_code", house_code);
				wxp.addVar("user_id", user_id);
				wxp.addVar("doc_no", doc_no);
				wxp.addVar("prev_pr_progress_flag", prev_pr_progress_flag);
				wxp.addVar("pr_progress_flag", pr_progress_flag);
				
				sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
				rtn = sm.doUpdate();
			}
			
		} catch (Exception e) {
			throw new Exception("setPr_progress_flag : " + e.getMessage());
		} finally {
		}		
		
		return rtn;
	}
	
	private	int setSignStatusUpdate(String[][] args, String[][] args2, String sign_status) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try {
			ConnectionContext ctx =	getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());
				
			String[] type1 = {"S","S","S","S"};
			rtn = sm.doUpdate(args, type1);
			
			if(sign_status.equals("E") || sign_status.equals("R")){  // 모든결재 완료시나 반려시 승인상태값 변경 
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

				String[] type2 = {"S","S","S"};
				rtn = sm.doUpdate(args2, type2);				
			}

		} catch(Exception	e) {
			throw new Exception("setSignStatusUpdate:"+e.getMessage());
		}
		
		return rtn;
	}	
	
	
	private	int setProgressUpdate(String[][] args) throws Exception
	{
		int rtn = -1;
		String user_id = info.getSession("ID");
		
		try {
			ConnectionContext ctx =	getConnectionContext();

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm =	new	SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

			String[] type1 = {"S","S","S","S"};
			rtn = sm.doUpdate(args, type1);

		} catch(Exception	e) {
			throw new Exception("setSignStatusUpdate:"+e.getMessage());
		}
		
		return rtn;
	}
	
	/*  결제대상 세금계산서 목록 조회 */
	public SepoaOut getSignTaxList(String group_tax_no) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getSignTaxList(house_code, group_tax_no);

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
	private String bl_getSignTaxList(String house_code, String group_tax_no)
			throws Exception {
		
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("group_tax_no", group_tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doSelect();
		} catch (Exception e) {
			throw new Exception("bl_getSignTaxList:" + e.getMessage());
		} finally {
		}
		return rtn;		
		
	}
	
	public SepoaOut tax_tgt(Map<String, Object> data) {
		
		SepoaXmlParser			  	wxp 		= null;
		Map<String, String> 	  	header		= null;
        Map<String, String> 	 	gridInfo	= null;
        List<Map<String, String>> 	grid        = null;
        
        ConnectionContext 		  	ctx 		= getConnectionContext();
        SepoaSQLManager 		  	sm 			= null;
		
		try {
			
			header = MapUtils.getMap(data, "headerData");
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			if(grid != null && grid.size() > 0){
				for(int i = 0 ; i < grid.size() ; i++){
					gridInfo = grid.get(i);
					gridInfo.put("house_code", info.getSession("HOUSE_CODE"));
					gridInfo.put("yn", header.get("yn"));
					wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					
					sm = new SepoaSQLManager(userid,this,ctx,(wxp != null)?wxp.getQuery():"");
					sm.doUpdate(gridInfo);
				}
			}
			Commit();
			setStatus(1);
		}
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}

} // END

