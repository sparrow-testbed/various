package sepoa.svc.tax;

import java.util.HashMap;
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
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sms.SMS;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;
//import erp.ERPInterface;

public class TX_003 extends SepoaService {
	Message msg = new Message(info, "TX_003");  // message 처리를 위해 전역변수 선언

	public TX_003(String opt, SepoaInfo info) throws SepoaServiceException {
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
	public SepoaOut getTrList(String from_date, String to_date, String vendor_code,
			                 String pay_no) {
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getTrList(house_code, from_date, to_date, vendor_code, pay_no);

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
	
	private String bl_getTrList(String house_code, String from_date,
								String to_date, String vendor_code, String pay_no)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", house_code);
			wxp.addVar("pay_no"	   , pay_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			String[] args = { house_code, from_date, to_date, vendor_code, pay_no };
			rtn = sm.doSelect(args);
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
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
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
	
	//세금계산서 발행
	public SepoaOut setTxData(Map<String, Object> data) throws SepoaServiceException
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		try {
			Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			Map<String, String> grid = MapUtils.getMap(data, SepoaDataMapper.KEY_GRID_DATA);
			int txrow = 0;
			int value = 0;
			String tax_no = header.get("tax_no");
			String tax_app_no = header.get("tax_app_no");
			String tax_date = header.get("tax_date");
			//String attach_no = header.get("attach_no");
			String req_dept = header.get("req_dept");
			String progress_code = header.get("progress_code");
			String house_code = info.getSession("HOUSE_CODE");
			
			String[] inv_no_arr = header.get("inv_no").split("\\,") ;
			String[] inv_seq_arr = header.get("inv_seq").split("\\,") ;
			String[] inv_data_arr = header.get("inv_data").split("\\,") ;
			String sign_status = "E";
			String pay_no = DocumentUtil.getDocNumber(info,"DCL").result[0];
			
			String status = header.get("status");
			
			String del_inv_no = "";
			String del_inv_seq = "";
			String inv_data = header.get("inv_data");
			
			String user_id = info.getSession("ID");
			SepoaXmlParser  wxp = null;
			SepoaSQLManager sm  = null;
			String getStr = "";
			String addStr = "";
			int    validCnt = 0;
			SepoaFormater wf = null;
			String PROGRESS_COD = "";
			String PROGRESS_CODE_TXT = "";
			Map<String, String> headerdata = new HashMap<String, String>();
			if("F".equals(progress_code)){
				//세금계산서 진행상태에 따른 파기가능 여부 체크
				wxp = new SepoaXmlParser(this, "et_getTaxProgressCode");
				headerdata.put("tax_no", header.get("tax_no"));
//				wxp.addVar("tax_no", header.get("tax_no"));
				sm  = new SepoaSQLManager(user_id,this,ctx, wxp);
				getStr = sm.doSelect(headerdata);
				wf = new SepoaFormater(getStr);		    		
	    		if(wf != null){
	    			if(wf.getRowCount() > 0){
	    				PROGRESS_COD = wf.getValue(0,0);
	    				PROGRESS_CODE_TXT = wf.getValue(0,1);
	    				if(!"-1".equals(PROGRESS_COD)){
	    					if(!("60".equals(PROGRESS_COD) || "99".equals(PROGRESS_COD) || PROGRESS_CODE_TXT.indexOf("전송오류") != -1  || PROGRESS_CODE_TXT.indexOf("전송대기") != -1  )){
	    						Rollback();
	    		    			setFlag(false);
	    		    			setStatus(0);
	    		    			setMessage("역발행의 경우 거부(반려) , 발급 취소 , 전송오류 , 전송대기 건만 파기 가능합니다.");
	    		    			return getSepoaOut();						
	    					} 					 
	    				}
	    			}else{
	    				Rollback();
		    			setFlag(false);
		    			setStatus(0);
		    			setMessage("파기대상건이 존재하지 않습니다.");
		    			return getSepoaOut();
	    			}
	    		}else{
    				Rollback();
	    			setFlag(false);
	    			setStatus(0);
	    			setMessage("파기대상건이 존재하지 않습니다.");
	    			return getSepoaOut();
    			}		    		
	    		
				//지불요청 진행여부 확인
				wxp = new SepoaXmlParser(this, "et_getSpy2glSpy1ln");
				wxp.addVar("tax_no1", header.get("tax_no"));
				wxp.addVar("tax_no2", header.get("tax_no"));
				sm  = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());					
				getStr = sm.doSelect();
				wf = new SepoaFormater(getStr);		    		
	    		if(wf != null){
	    			validCnt = wf.getRowCount();
	    		}		    		
	    		if(validCnt > 0){
	    			Rollback();
	    			setFlag(false);
	    			setStatus(0);
	    			setMessage("진행중인 지불요청이 존재하여 세금계산서 파기 불가합니다.");
	    			return getSepoaOut();		
	    		}
	    		
				if(inv_no_arr != null && inv_no_arr.length > 0){
					for(int i = 0 ; i < inv_no_arr.length ; i++){
						if(i == 0){
							del_inv_no = inv_no_arr[i];
							del_inv_seq = inv_seq_arr[i];
						}else{
							del_inv_no += "','" + inv_no_arr[i];   
							del_inv_no += "','" + inv_no_arr[i];
						}
					}
				}
				delInvTaxYn(ctx, inv_data);
				et_delTxData(ctx, del_inv_no,inv_data, header.get("tax_no"), status);
			}else{
				if(header.get("tax_no") == null || header.get("tax_no").equals("")){
					if(inv_no_arr != null && inv_no_arr.length > 0){
						up_setApprovalHD(ctx, inv_no_arr, pay_no, sign_status);
						int insrow1 = in_setApprovalHD(ctx, inv_no_arr, inv_data, pay_no, sign_status);
						
						if(insrow1 > 0){
							insrow1 += in_setApprovalDT(ctx, inv_data, pay_no);
							insrow1 += setInvTaxYn(ctx, inv_data);
						}
					}			
					header.put("pay_data", pay_no);
				}
				
				if("D".equals(progress_code)){
					//저장만
					txrow = et_setTxData(house_code, data, ctx);
					if(txrow == 3){
						setStatus(1);
					}
				}else if("I".equals(progress_code)){
					
					//지불요청 진행여부 확인
					wxp = new SepoaXmlParser(this, "et_getSpy2glSpy1ln_2");
					wxp.addVar("inv_data1", inv_data);
					wxp.addVar("inv_data2", inv_data);
					sm  = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());					
					getStr = sm.doSelect();
					wf = new SepoaFormater(getStr);		    		
		    		if(wf != null){
		    			validCnt = wf.getRowCount();
		    		}		    		
		    		if(validCnt > 0){
		    			Rollback();
		    			setFlag(false);
		    			setStatus(0);
		    			setMessage("진행중인 지불요청이 존재하여 세금계산서 전송 불가합니다.");
		    			return getSepoaOut();		
		    		}
				    ////////////////////////////////////////////////////////////
		    		
					if("".equals(tax_no)){
						value = et_setTxData(house_code, data, ctx);
					}else{
						value = setSubmitTax(tax_no, tax_app_no, tax_date, req_dept, progress_code, ctx);
					}
					
					//저장 전송 같이..
					if(value == 0) {
						try {
							Rollback();
							setStatus(0);
							setFlag(false);
							setMessage("전송 실패 하였습니다.");
						} catch(Exception d) {
//							d.printStackTrace();
							Logger.err.println(info.getSession("ID"),this,d.getMessage());							
							setStatus(0);
							setFlag(false);
							setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
							return getSepoaOut();
						}
					}else {
						setStatus(1);
						setValue(String.valueOf(value));
						
						if(progress_code.equals("I")) 
							setMessage("전송 되었습니다.");
						else
							setMessage("저장 되었습니다.");
					}
				}
			}

			Commit();
			//세금계산서 전송 END
			
			
		}catch(Exception e)
        {
//			e.printStackTrace();
        	Logger.err.println("Exception e =" + e.getMessage());
        	Rollback();
            setStatus(0);
            setFlag(false);
            setMessage("에러가 발생하였습니다." + e.getMessage());
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();			
	}
	
	//마이너스 세금계산서 발행
	public SepoaOut setPayCancel(Map<String, Object> data) throws SepoaServiceException
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext 			ctx 		= getConnectionContext();
		
		List<Map<String, String>> 	gridList 	= (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
		Map<String, String> 		gridInfo	= null;
		
		String 						inv_no		= "";
		String 						inv_seq		= "";
		String 						pay_no		= "";
		String 						tax_no		= "";
		String 						n_pay_no 	= "";
		String 						n_tax_no 	= "";
		
		String user_id = info.getSession("ID");
		SepoaXmlParser  wxp = null;
		SepoaSQLManager sm  = null;
		String getStr = "";
		String addStr = "";
		int    validCnt = 0;
		SepoaFormater wf = null;
		
		try {
			
			if(gridList != null && gridList.size() > 0){
				for(int i = 0 ; i < gridList.size() ; i++){
					gridInfo = gridList.get(i);
					
					n_pay_no = DocumentUtil.getDocNumber(info,"DCL").result[0];
					n_tax_no = DocumentUtil.getDocNumber(info,"TAX").result[0];
					
					inv_no 	= gridInfo.get("INV_NO");
					inv_seq = gridInfo.get("INV_SEQ");
					pay_no	= gridInfo.get("PAY_NO");
					tax_no	= gridInfo.get("TAX_NO");
					
					//지불요청 진행여부 확인
					wxp = new SepoaXmlParser(this, "et_getSpy2glSpy1ln");
					wxp.addVar("tax_no1", tax_no);
					wxp.addVar("tax_no2", tax_no);
					sm  = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());					
					getStr = sm.doSelect();
					wf = new SepoaFormater(getStr);		    		
		    		if(wf != null){
		    			validCnt = wf.getRowCount();
		    		}		    		
		    		if(validCnt > 0){
		    			Rollback();
		    			setFlag(false);
		    			setStatus(0);
		    			setMessage("진행중인 지불요청이 존재하여 세금계산서 취소발행이 불가합니다.");
		    			return getSepoaOut();		
		    		}
					
					//거래명세서 복사
					in_copyTrhd(ctx, pay_no, n_pay_no);
					in_copyTrdt(ctx, pay_no, n_pay_no, n_tax_no);

					//세금계산서 복사
					in_copyTxhd(ctx, tax_no, n_tax_no);
					in_copyTxdt(ctx, tax_no, n_tax_no);
					
					//TrusBill 정보 복사
					in_copySaleEbill(ctx, tax_no, n_tax_no);
					in_copyItemList(ctx, tax_no, n_tax_no);
				}
			}
			
			//et_setTxData(house_code, data, ctx);
			
			setStatus(1);
			//setValue(String.valueOf(value));
			setMessage("전송 되었습니다.");
			
			Commit();
		}catch(Exception e)
		{
//			e.printStackTrace();
			Logger.err.println("Exception e =" + e.getMessage());
			Rollback();
			setStatus(0);
			setMessage("에러가 발생하였습니다.");
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();			
	}
		
	private int in_copyTrhd(ConnectionContext ctx, String pay_no, String n_pay_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 (ICOYTRHD) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("pay_no"	, pay_no);
			data.put("n_pay_no"	, n_pay_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doInsert(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_copyTrhd :" + e.getMessage());
		} 
		return rtn;
	}	
	
	private int in_copyTrdt(ConnectionContext ctx, String pay_no, String n_pay_no, String n_tax_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 상세(ICOYTRDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("pay_no"	, pay_no);
			data.put("n_pay_no"	, n_pay_no);
			data.put("n_tax_no"	, n_tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doInsert(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_copyTrdt :" + e.getMessage());
		} 
		return rtn;
	}	
	
	private int in_copyTxhd(ConnectionContext ctx, String tax_no, String n_tax_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 세금계산서 (ICOYTXHD) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("tax_no"	, tax_no);
			data.put("n_tax_no"	, n_tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doInsert(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_copyTxhd :" + e.getMessage());
		} 
		return rtn;
	}		
	
	private int in_copyTxdt(ConnectionContext ctx, String tax_no, String n_tax_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 세금계산서 상세 (ICOYTXDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("tax_no"	, tax_no);
			data.put("n_tax_no"	, n_tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doInsert(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_copyTxdt :" + e.getMessage());
		} 
		return rtn;
	}		
	
	private int in_copySaleEbill(ConnectionContext ctx, String tax_no, String n_tax_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 전자세금계산서 (SALEEBILL) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("tax_no"	, tax_no);
			data.put("n_tax_no"	, n_tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doInsert(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_copySaleEbill :" + e.getMessage());
		} 
		return rtn;
	}		
	
	private int in_copyItemList(ConnectionContext ctx, String tax_no, String n_tax_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 전자세금계산서 품목정보 (ITEMLIST) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("tax_no"	, tax_no);
			data.put("n_tax_no"	, n_tax_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doInsert(data);
			rtn++;
		} catch (Exception e) {
			throw new Exception("in_copyItemList :" + e.getMessage());
		} 
		return rtn;
	}		
	
	private void setSaleEbill(Map<String, String> header, ConnectionContext ctx) throws SepoaServiceException {
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			header.put("PUBDATE"		, header.get("tax_date").replaceAll("\\-", ""));
			
//			String tax_div = "";
//			if(header.get("") != null && "".equals(header.get(""))){
//				tax_div = "";
//			}
//			header.put("CUSTOMS"		, tax_div);
			
			header.put("MEMID"			, "");
			header.put("MEMDEPTNAME"	, "");
			header.put("MEMNAME"		, header.get("company_admin1"));
			header.put("EMAIL"			, header.get("s_email"));
			header.put("TEL"			, header.get("s_tel"));
			header.put("COREGNO"		, header.get("company_dept1"));
			header.put("COTAXREGNO"		, "");
			header.put("CONAME"			, header.get("company_name1"));
			header.put("COCEO"			, header.get("company_ceo1"));
			header.put("COADDR"			, header.get("company_addr1"));
			header.put("COBIZTYPE"		, header.get("s_biz_type"));
			header.put("COBIZSUB"		, header.get("s_ind_type"));
			
			header.put("RECMEMID"		, CommonUtil.getConfig("sepoa.trus.loginid"));
			header.put("RECMEMDEPTNAME"	, "");
			header.put("RECMEMNAME"		, header.get("company_admin2"));
			header.put("RECEMAIL"		, header.get("b_email"));  
			header.put("RECTEL"			, header.get("b_tel"));    
			header.put("RECCOREGNO"		, header.get("company_dept2"));
			header.put("RECCOTAXREGNO"	, "");                         
			header.put("RECCONAME"		, header.get("company_name2"));
			header.put("RECCOCEO"		, header.get("company_ceo2")); 
			header.put("RECCOADDR"		, header.get("company_addr2"));
			header.put("RECCOBIZTYPE"	, header.get("b_biz_type"));   
			header.put("RECCOBIZSUB"	, header.get("b_ind_type"));   
			header.put("SUPPRICE"		, header.get("table_sample1").replaceAll("\\,", ""));
			header.put("TAX"			, header.get("table_sample2").replaceAll("\\,", ""));
			header.put("PUBSTATUS"		, "");
			header.put("SMS"			, "");
			header.put("REMARKS"	, header.get("remark"));   
			
			
			
			sm.doInsert(header);
		} catch (Exception e) {
//			e.printStackTrace();
        	Logger.err.println("setSaleEbill e =" + e.getMessage());
        	Rollback();
            setStatus(0);
            setMessage("에러가 발생하였습니다.");
            Logger.err.println(this,e.getMessage());
		}
	}
	
	private void setItemList(Map<String, String> header, List<Map<String, String>> grid , ConnectionContext ctx) throws SepoaServiceException {
		try {
			Map<String, String> gridInfo = null;
			if(grid != null && grid.size() > 0){
				for(int i = 0 ; i < grid.size() ; i++){
					gridInfo = grid.get(i);
					gridInfo.put("SEQID"		, header.get("RESSEQ") + String.format("%04d", i+1));
					gridInfo.put("DETAILSEQID"	, header.get("RESSEQ"));
					gridInfo.put("ITEMDATE"		, header.get("PUBDATE"));
					gridInfo.put("ITEMNAME"		, gridInfo.get("ITEM_NAME"));
					gridInfo.put("ITEMTYPE"		, gridInfo.get("SPEC"));
					gridInfo.put("ITEMQTY"		, gridInfo.get("QTY"));
					gridInfo.put("ITEMPRICE"	, gridInfo.get("PRICE"));
					gridInfo.put("ITEMSUPPRICE"	, gridInfo.get("SUPPLIER_PRICE"));
					gridInfo.put("ITEMTAX"		, gridInfo.get("TAX_PRICE"));
					gridInfo.put("ITEMREMARKS"	, gridInfo.get("REMARK"));
					
					SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
					SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
					sm.doInsert(gridInfo);
				}
			}
		} catch (Exception e) {
//			e.printStackTrace();
        	Logger.err.println("setItemList e =" + e.getMessage());
        	Rollback();
            setStatus(0);
            setMessage("에러가 발생하였습니다.");
            Logger.err.println(this,e.getMessage());
		}		
	}

	private int in_setApprovalHD(ConnectionContext ctx, String[] inv_no, String inv_data, String pay_no, String sign_status) throws Exception {
		int rtn = 0;
		String ctrl_code[] = info.getSession("CTRL_CODE").split("&");
		String job_status = "";
		String user_id = info.getSession("ID");
		if(sign_status.equals("E")){
			job_status = "V";
		}else {
			job_status = "N";
		}
		
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 헤더(ICOYTRHD) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
			String addSql = "";
			for(int i = 0 ; i < inv_no.length ; i++){
				if(i == 0){
					addSql = inv_no[i];
				}else{
					addSql += "','" + inv_no[i];
				}
			}
			wxp.addVar("inv_no", addSql);
			
			data.put("inv_data", inv_data);
			data.put("pay_no", pay_no);
			data.put("sign_status", sign_status);
			data.put("job_status", job_status);			
			data.put("ctrl_code", ctrl_code[0]);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doUpdate(data);
			rtn++; 
		} catch (Exception e) {
//			e.printStackTrace();
			throw new Exception("in_setApproval:" + e.getMessage());
		} finally {
		}

		return rtn;
	}
		
	private int in_setApprovalDT(ConnectionContext ctx, String inv_no, String pay_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 상세(ICOYTRDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("inv_no", inv_no);
			data.put("pay_no", pay_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doUpdate(data);
			rtn++;
		} catch (Exception e) {
//			e.printStackTrace();
			throw new Exception("in_setApproval:" + e.getMessage());
		} finally {
		}

		return rtn;
	}
	
	
	private int setInvTaxYn(ConnectionContext ctx, String inv_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 상세(ICOYTRDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("inv_no", inv_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			sm.doUpdate();
			rtn++;
		} catch (Exception e) {
//			e.printStackTrace();
			throw new Exception("setInvTaxYn:" + e.getMessage());
		} finally {
		}
		
		return rtn;
	}
	
	private int delInvTaxYn(ConnectionContext ctx, String inv_no) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 상세(ICOYTRDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("inv_no", inv_no);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			sm.doUpdate();
			rtn++;
		} catch (Exception e) {
			throw new Exception("delInvTaxYn:" + e.getMessage());
		} finally {
		}
		
		return rtn;
	}
	
	
	private int up_setApprovalHD(ConnectionContext ctx, String[] inv_no, String pay_no, String sign_status) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			// 1. 거래명세서 상세(ICOYTRDT) 등록
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			String addSql = "";
			for(int i = 0 ; i < inv_no.length ; i++){
				if(i == 0){
					addSql = inv_no[i];
				}else{
					addSql += "','" + inv_no[i];
				}
			}
			wxp.addVar("inv_no", addSql);
			
			//data.put("inv_no", inv_no);
			data.put("pay_no", pay_no);
			data.put("sign_status", sign_status);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			sm.doUpdate(data);
			rtn++;
		} catch (Exception e) {
//			e.printStackTrace();
			throw new Exception("up_setApprovalHD:" + e.getMessage());
		} finally {
		}

		return rtn;
	}	
	
	private int et_delTxData(ConnectionContext ctx, String inv_data, String del_inv_data, String tax_no, String status ) throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			wxp.addVar("inv_no", del_inv_data);
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			sm.doDelete((String[][])null, null);
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			wxp.addVar("inv_no", del_inv_data);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			sm.doDelete((String[][])null, null);
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
			wxp.addVar("inv_no", del_inv_data);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			sm.doDelete((String[][])null, null);
			
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_4");
			wxp.addVar("inv_no", del_inv_data);
			sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			sm.doDelete((String[][])null, null);
			
			if("60".equals(status)){
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_5");
				wxp.addVar("tax_no", tax_no);
				sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
				sm.doDelete((String[][])null, null);
			}
			
		} catch (Exception e) {
			throw new Exception("up_setApprovalHD:" + e.getMessage());
		} finally {
		}
		
		return rtn;
	}	
	
	public int et_setTxData(String house_code, Map<String, Object> data, ConnectionContext ctx) throws Exception{
    	Configuration con = new Configuration();
		Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
    	String tax_no = "";
		String tax_app_no 	= header.get("tax_app_no");
		String ktgrm	  	= header.get("ktgrm");
		String tax_date 	= header.get("tax_date");
		//String attach_no 	= header.get("attach_no");
		String req_dept 	= header.get("req_dept");
		String progress_code= "";
		int insrow1 = 0;
        String user_id        = info.getSession("ID");
        String pay_data = header.get("pay_data");
        String remark = header.get("remark");
        try {
        		tax_no = header.get("tax_no");
        		// 거래명세서 발급완료시 세금계산서 테이블 데이터 등록
        		if("".equals(tax_no)){
        			SepoaOut wo = DocumentUtil.getDocNumber(info,"TAX");//세금계산서번호 생성
            		tax_no = wo.result[0];
            		progress_code = "V";
            		Map<String, String> headerdata = new HashMap<String, String>();
            		SepoaXmlParser wxp = new SepoaXmlParser(this, "in_setApprovalTXHD");
            		headerdata.put("pay_data", "AND TRDT.PAY_NO IN('"+pay_data+"')");
//            		headerdata.put("pay_data", "AND TRDT.PAY_NO || TRDT.PAY_SEQ IN('"+pay_data+"')");
            		headerdata.put("tax_no", tax_no);
            		headerdata.put("ktgrm" , ktgrm);
            		headerdata.put("progress_code", progress_code);
            		headerdata.put("remark", remark);
        			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
        			sm.doInsert(headerdata);
        			insrow1++;
            		if (insrow1 > 0) {
            			
                		SepoaXmlParser wxp2= new SepoaXmlParser(this, "in_setApprovalTXDT");
                		SepoaSQLManager sm2 = new SepoaSQLManager(user_id, this, ctx, wxp2);
                		sm2.doInsert(headerdata);
            			
            			insrow1++;
            			SepoaXmlParser wxp3 = new SepoaXmlParser(this, "update_setTRDT");
//                		headerdata.put("pay_data", "AND PAY_NO || PAY_SEQ IN('"+pay_data+"')");
                		headerdata.put("pay_data", "AND PAY_NO IN('"+pay_data+"')");
            			SepoaSQLManager sm3 = new SepoaSQLManager(user_id, this, ctx, wxp3);
            			sm3.doInsert(headerdata);
            			insrow1++;
            		}
            		
            		//역발행일 경우만 
        		}else{
        			//수정
        		}
        		if("I".equals(header.get("progress_code"))){
        			int value = 0;
        			progress_code = "I";
        			//value = setSubmitTax(tax_no, tax_app_no, tax_date, attach_no, progress_code, ctx);
        			value = setSubmitTax(tax_no, tax_app_no, tax_date, req_dept, progress_code, ctx);
        			
	        		if("RP".equals(header.get("tax_type"))){
	        			//세금계산서 SALEEBILL Insert
	        			header.put("RESSEQ"			, tax_no);
	        			setSaleEbill(header, ctx);
	        			//세금계산서 ITEMLIST Insert
	        			setItemList(header, (List<Map<String, String>>)MapUtils.getObject(data, "gridData"), ctx);  
	        			
	        			
	        			//세금계산서 전송 SMS 알림 START
	        			Logger.debug.println(info.getSession("ID"), this, "==================== 세금계산서 구분 : " + header.get("tax_type") );
	        			
	        			if( "RP".equals( header.get("tax_type") ) ) {//역발행이면 세금계산서 전송 알림 SMS START
	        				
	        				Map<String, String> param = new HashMap<String, String>();
	        				
	        				param.put("HOUSE_CODE", header.get("house_code"));//하우스코드
	        				param.put("TAX_NO",     tax_no);//세금계산서번호
//	        				param.put("MOBILE_NO",  header.get("s_tel"));//공급자 모바일번호
	        				param.put("MOBILE_NO",  header.get("s_mobile_no"));//공급자 모바일번호
	        					        	        				
	        				new SMS("NONDBJOB", info).tx1Process(ctx, param);
	        			
	        			}
	        			//세금계산서 전송 알림 SMS END
	        		}
        			
        			return value;
        		}
        		
        	}catch(Exception e) {
//        		e.printStackTrace();
                throw new Exception("in_setIvdp:"+e.getMessage());
            } finally{
        }
        return insrow1;
    }
	
	public int setSubmitTax(String tax_no, String tax_app_no, String tax_date, String req_dept, String progress_code,ConnectionContext ctx)
	{ 
		String user_id		 = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
		int value = 0;
		try {
			if(!tax_app_no.equals("")){
				progress_code = "C";
			}
			 Map<String, String> data = new HashMap<String, String>();
			 data.put("tax_no"			, tax_no);
			 data.put("tax_app_no"		, tax_app_no);
			 data.put("tax_date"		, tax_date.replaceAll("-", ""));
			 data.put("proc_dept"		, req_dept);
			 data.put("progress_code", progress_code);
			 SepoaXmlParser wxp = new SepoaXmlParser(this, "et_setTxTaxAppNo");
			 SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			 value = sm.doUpdate(data);
//				String[] erpTax_result = new String[2];
//				
//				if(progress_code.equals("O")){ //공급사 발행 취소	
//					// 정산 I / F
//					// ERP로 넘기 데이터 가져오기 (삭제)
//					ERPInterface erpIF = new ERPInterface("CONNECTION",info);
//					erpTax_result = erpIF.erpTaxInsert(getERPTaxList(tax_no),"D");
//				}		
//				
//				int rtn = 0;
//				ConnectionContext ctx = getConnectionContext();
//				String code = "";
//				if ( progress_code.equals("OR") ) {
//					code = "O";
//				} else {
//					code = progress_code;
//				}
		     SepoaXmlParser wxp2 = new SepoaXmlParser(this, "et_setProgressCode");
		     SepoaSQLManager sm2 = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp2);
		     sm2.doUpdate(data);
//		     if(progress_code.equals("O")){ //공급사 발행 취소	
//		     	if(!erpTax_result[0].equals("2")){
//		            	 setStatus(1);
//		              setValue(String.valueOf(rtn));
//		         	 Commit();					
//		     	}else{
//		     		Rollback();
//		     		setStatus(0);
//		     		setMessage(erpTax_result[1]);
//		     	}	
//		     }
		}catch(Exception e) {
			try {
				Rollback();
			} catch(Exception re) {
				Logger.debug.println(user_id, this, re.getMessage());
			}
		}
		return value;
	}
	
	// 세금계산서 발행대상 조회
	public SepoaOut getTxHD(Map<String, String> param){
		try {
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getTxHD(house_code, param);

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
	
	private String bl_getTxHD(String house_code, Map<String, String> param)throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
//			param.put("inv_no_str", param.get("inv_no_str"));
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("inv_data", param.get("inv_data"));
			wxp.addVar("inv_no_str", param.get("inv_no_str"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(param);
		} catch (Exception e) {
			throw new Exception("bl_getTxHD:" + e.getMessage());
		} finally {
		}
		return rtn;	
	}	

	public SepoaOut getTxDT(Map<String, String>header){
		try {
			String inv_data = "";
			inv_data = header.get("inv_data");
			String house_code = info.getSession("HOUSE_CODE");
			String rtnHD = bl_getTxDT(house_code, inv_data);

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
	
	private String bl_getTxDT(String house_code, String inv_data)throws Exception {
		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			Map<String, String> header = new HashMap<String, String>();
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getTxDT");
			wxp.addVar("inv_data", inv_data);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
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
			Map<String, String> data = new HashMap<String, String>();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("tax_no"			, tax_no);
			data.put("tax_app_no"		, tax_app_no);
			data.put("tax_date"		, tax_date);
			data.put("attach_no"		, attach_no);			
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
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

		
		if("E".equals(sign_status)){  // 모든결제가 완료시에  상태 승인으로 변경 세팅
			progress_code = "C";	
		}else if("D".equals(sign_status)){ //상신결재 취소시에 sign_status 값이 'D' 이지만 다시 결재할수 있도록 'T' 변경
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
		
		//반려이거나 취소일 경우 여기서 끝낸다.
//		if(sign_status != "E") {
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
			
			if("E".equals(sign_status) || "R".equals(sign_status)){  // 모든결재 완료시나 반려시 승인상태값 변경 
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
	
	public SepoaOut getPiInfo(String vendor_code) {
		
		ConnectionContext ctx = getConnectionContext();
		String rtnHD = "";
		try {
			String house_code = info.getSession("HOUSE_CODE");
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("vendor_code", vendor_code);
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtnHD = sm.doSelect();
			
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
} // END

