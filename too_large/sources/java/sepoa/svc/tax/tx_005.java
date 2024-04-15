package sepoa.svc.tax; 

import java.util.List;
import java.util.Map;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
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
import sepoa.fw.util.SepoaRemote;
import wisecommon.SignRequestInfo;

public class TX_005 extends SepoaService {
	Message msg = new Message(info, "TX_005");  // message 처리를 위해 전역변수 선언

	public TX_005(String opt, SepoaInfo info) throws SepoaServiceException {
    	super(opt, info);
		setVersion("1.0.0");
    }
	
	private int insert(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doInsert(param);
		
		return result;
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
		Configuration configuration = null;
		
		try {
			configuration = new Configuration();
			
			s = configuration.get(s);
			
			return s;
		}
		catch(ConfigurationException configurationexception){
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception){
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		
		return null;
	}
	
	/**
	 * 자본예산지급 조회
	 * @method getPayList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-12-04
	 * @modify 2014-12-04
	 */
	public SepoaOut getPayList(Map<String, String> header){
		String            rtn      = null;
//		String            taxNoSeq = header.get("TAX_NO_SEQ");
		String            taxNo    = header.get("TAX_NO");
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		SepoaFormater     wf       = null;
		ConnectionContext ctx      = null;
		
		try {
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "et_getPayList");
			
//			wxp.addVar("TAX_NO_SEQ", taxNoSeq);
			wxp.addVar("TAX_NO", taxNo);
			
			sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			rtn = sm.doSelect(header);
	
			wf = new SepoaFormater(rtn);
			
			if(wf.getRowCount() == 0){
				setMessage(msg.getMessage("0000"));
			}
			else {
				setMessage(msg.getMessage("7000"));
			}
			
			setStatus(1);
			setValue(rtn);
		}
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			
			setStatus(0);
		}
		
		return getSepoaOut();			
	}
	
	/**
	 * 자본예산지급 조회
	 * @method getPayList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-12-04
	 * @modify 2014-12-04
	 */
	public SepoaOut getPayList2(Map<String, String> header){
		String            rtn      = null;
		String            pay_send_no = header.get("pay_send_no");
		
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		SepoaFormater     wf       = null;
		ConnectionContext ctx      = null;
		
		try {
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "et_getPayList2");
			
			wxp.addVar("pay_send_no", pay_send_no);
			
			sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			rtn = sm.doSelect(header);
	
			wf = new SepoaFormater(rtn);
			
			if(wf.getRowCount() == 0){
				setMessage(msg.getMessage("0000"));
			}
			else {
				setMessage(msg.getMessage("7000"));
			}
			
			setStatus(1);
			setValue(rtn);
		}
		catch (Exception e){
			Logger.err.println(userid, this, e.getMessage());
			
			setStatus(0);
		}
		
		return getSepoaOut();			
	}
	
	/**
	 * 공급사 유효성을 검사하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 */
	public SepoaOut selectValidVendor(Map<String, String> param){
		ConnectionContext ctx      = null;
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		String            result   = null;
//		String            taxNoSeq = param.get("taxNoSeq");
		String            taxNo    = param.get("taxNo");
		int               status   = 0;
		
		try{
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "selectValidVendor");
			
//			wxp.addVar("TAX_NO_SEQ", taxNoSeq);
			wxp.addVar("TAX_NO", taxNo);
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			result = sm.doSelect(param);
			status = 1;
			
			setValue(result);
		}
		catch(Exception e){
			status = 0;
			
			Logger.err.println(userid, this, e.getMessage());
		}
		
		setStatus(status);
		
		return getSepoaOut();
	}
	
	/**
	 * 공급사 유효성을 검사하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 */
	public SepoaOut selectValidVendor2(Map<String, String> param){
		ConnectionContext ctx      = null;
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		String            result   = null;
		//String            taxNoSeq = param.get("taxNoSeq");
		String            pay_send_no = param.get("PAY_SEND_NO");
		int               status   = 0;
		
		try{
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "selectValidVendor2");
			
			//wxp.addVar("TAX_NO_SEQ", taxNoSeq);
			wxp.addVar("PAY_SEND_NO", pay_send_no);
			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			result = sm.doSelect(param);
			status = 1;
			
			setValue(result);
		}
		catch(Exception e){
			status = 0;
			
			Logger.err.println(userid, this, e.getMessage());
		}
		
		setStatus(status);
		
		return getSepoaOut();
	}
	
	public SepoaOut selectValidIgjm(Map<String, String> param){
		ConnectionContext ctx      = null;
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		String            result   = null;
		String            taxNoSeq = param.get("taxNoSeq");
		int               status   = 0;
		
		try{
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "selectValidIgjm");
			
			wxp.addVar("TAX_NO_SEQ", taxNoSeq);
			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			result = sm.doSelect(param);
			status = 1;
			
			setValue(result);
		}
		catch(Exception e){
			status = 0;
			
			Logger.err.println(userid, this, e.getMessage());
		}
		
		setStatus(status);
		
		return getSepoaOut();
	}
	
	/**
	 * 입금금액 조회
	 * 
	 * @param param
	 * @return SepoaOut
	 */
	public SepoaOut selectSumDelyAmt(Map<String, String> param){
		ConnectionContext ctx      = null;
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		String            result   = null;
//		String            taxNoSeq = param.get("taxNoSeq");
		String            taxNo    = param.get("taxNo");
		int               status   = 0;
		
		try{
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "selectSumDelyAmt");
			
//			wxp.addVar("TAX_NO_SEQ", taxNoSeq);
			wxp.addVar("TAX_NO", taxNo);
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			result = sm.doSelect(param);
			status = 1;
			
			setValue(result);
		}
		catch(Exception e){
			status = 0;
			
			Logger.err.println(userid, this, e.getMessage());
		}
		
		setStatus(status);
		
		return getSepoaOut();
	}
	
	public SepoaOut selectSumDelyAmt2(Map<String, String> param){
		ConnectionContext ctx      = null;
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		String            result   = null;
		String            pay_send_no = param.get("PAY_SEND_NO");
		int               status   = 0;
		
		try{
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "selectSumDelyAmt2");
			
			wxp.addVar("PAY_SEND_NO", pay_send_no);
			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			result = sm.doSelect(param);
			status = 1;
			
			setValue(result);
		}
		catch(Exception e){
			status = 0;
			
			Logger.err.println(userid, this, e.getMessage());
		}
		
		setStatus(status);
		
		return getSepoaOut();
	}
	
	public SepoaOut selectSpy1gl(Map<String, String> param){
		ConnectionContext ctx      = null;
		SepoaXmlParser    wxp      = null;
		SepoaSQLManager   sm       = null;
		String            result   = null;
		String            pay_send_no = param.get("PAY_SEND_NO");
		int               status   = 0;
		
		try{
			ctx = getConnectionContext();
			
			wxp = new SepoaXmlParser(this, "selectSpy1gl");
			
			wxp.addVar("PAY_SEND_NO", pay_send_no);
			
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			
			result = sm.doSelect(param);
			status = 1;
			
			setValue(result);
		}
		catch(Exception e){
			status = 0;
			
			Logger.err.println(userid, this, e.getMessage());
		}
		
		setStatus(status);
		
		return getSepoaOut();
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut insetSpy1Info(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
		Map<String, String>       header   = null;
		int rtn = 0; 
		
		SepoaXmlParser  wxp0 = null;
		SepoaSQLManager ssm0  = null;
		SepoaFormater wf0 = null;
		
		SepoaXmlParser  wxp = null;
		SepoaSQLManager ssm  = null;
		SepoaFormater wf = null;
		int    validCnt = 0;
		try {
			setStatus(1);
			setFlag(true);
			
			ctx    = getConnectionContext();
			grid   = (List<Map<String, String>>)data.get("gridInfo");
			header = (Map<String, String>)data.get("headerInfo");
			String subject = header.get("VENDOR_NAME_LOC")+" / "+ header.get("DEPOSITOR_NAME");
			String approval_str = (String) data.get("approval_str");
			String pay_send_no = header.get("PAY_SEND_NO");
			
//			System.out.println("---------------------Subejct="+subject);
//			System.out.println("---------------------Approval_str="+approval_str);
//			System.out.println("---------------------Pay_send_no="+pay_send_no);
			/*==================================================================================================*/
			
			//세금계산서 원장의 총금액 과 지급문서의 품의금액(pumpumam) 동일한지 체크 
			String pay_amt = header.get("PAY_AMT");
			String tax_total = "";
			String inv_data = header.get("INV_DATA").replaceAll(",","','");
			wxp0 = new SepoaXmlParser(this, "et_getTaxTotal");
			wxp0.addVar("inv_data", inv_data);
			ssm0  = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp0.getQuery());					
			wf0 = new SepoaFormater(ssm0.doSelect());		    		
			if (wf0 != null && wf0.getRowCount() > 0){
				tax_total = wf0.getValue("TAX_TOTAL", 0);
			}	
    		if(!pay_amt.equals(tax_total)){
    			Rollback();
    			setFlag(false);
    			setStatus(0);
    			setMessage("세금계산서 총금액과 지급문서의 입금금액이 상이합니다.");
    			Logger.err.println(info.getSession("ID"), this, "세금계산서 총금액과 지급문서의 입금금액이 상이합니다.");
    			return getSepoaOut();		
    		}
		    ////////////////////////////////////////////////////////////
			
			
			//지불요청 진행여부 확인
//			String inv_data = header.get("INV_DATA").replaceAll(",","','");
			wxp = new SepoaXmlParser(this, "et_getSpy2glSpy1ln");
			wxp.addVar("inv_data1", inv_data);
			wxp.addVar("inv_data2", inv_data);
			ssm  = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());					
			wf = new SepoaFormater(ssm.doSelect());		    		
    		if(wf != null){
    			validCnt = wf.getRowCount();
    		}		    		
    		if(validCnt > 0){
    			Rollback();
    			setFlag(false);
    			setStatus(0);
    			setMessage("기진행된 지불요청이 존재하여 지급문서생성이 불가합니다.");
    			Logger.err.println(info.getSession("ID"), this, "기진행된 지불요청이 존재하여 지급문서생성이 불가합니다.");
    			return getSepoaOut();		
    		}
		    ////////////////////////////////////////////////////////////
			
			
			//결재선 저장
            SignRequestInfo sri = new  SignRequestInfo();
            sri.setCompanyCode(info.getSession("COMPANY_CODE"));
            sri.setDept(info.getSession("DEPARTMENT"));
            sri.setReqUserId(info.getSession("ID"));
            sri.setDocType("PSB");
            sri.setDocNo(pay_send_no);
            sri.setDocSeq("0");
            sri.setItemCount(1);
            sri.setSignStatus("P");								//SSCGL의 APP_STATUS
            //sri.setCur("KRW");
            //sri.setTotalAmt(Double.parseDouble(CONT_AMT));		//총 금액
            sri.setDocName(subject);						//SUBJECT
            sri.setSignString(approval_str); 					// AddParameter 에서 넘어온 정보
            rtn = CreateApproval(info, sri);
            
//            System.out.println("Sign : "+rtn);
//            System.out.println("결재라인인서트 성공(1) 실패(0)rtn : "+rtn);
            Logger.debug.println("결재선 지정후 자바단 로그(서비스단) : "+approval_str);
            
            if(rtn == 0 ){
				Rollback();
				setMessage("결재선 지정중 에러가 발생하였습니다.");
				setStatus(0);
				setFlag(false);
				Logger.err.println(info.getSession("ID"), this, "결재선 지정중 에러가 발생하였습니다.");
				return getSepoaOut();
			}
            
            
			/*==================================================================================================*/
			//문서생성
			this.insert(ctx, "insertSpy1glInfo", header);
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                this.insert(ctx, "insertSpy1lnInfo", gridInfo);
            }
			
			/*==================================================================================================*/
			//상태값업데이트
			//결재 헤더 테이블 상태값 변경
			StringBuffer sb = new StringBuffer();
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
 			//결재 헤더 테이블 상태값 변경
 			sm.removeAllValue();
			sb.delete(0, sb.length());
			//결재 헤더 테이블 상태값 변경
 			sm.removeAllValue();
			sb.delete(0, sb.length());
			sb.append(" UPDATE	ICOMSCTM 		--결재 헤더 테이블 상태값 변경(최종결재자면)				\n");
			sb.append("   SET  	APP_STATUS		= 'P',					\n");//E:완료, P:진행중, R:반려[M318]
			sb.append(" 		CHANGE_DATE		= ?,       				\n");sm.addStringParameter(SepoaDate.getShortDateString());
			sb.append(" 		CHANGE_TIME		= ?,        			\n");sm.addStringParameter(SepoaDate.getShortTimeString());
			sb.append(" 		CHANGE_USER_ID 	= ?      				\n");sm.addStringParameter(info.getSession("ID"));
	 		sb.append(" WHERE 1 = 1										\n");
	 		sb.append("   AND COMPANY_CODE  = ?							\n");sm.addStringParameter(info.getSession("COMPANY_CODE"));
			sb.append("   AND DOC_NO		= ?							\n");sm.addStringParameter(pay_send_no);
	 		sb.append("   AND DOC_TYPE		= ?							\n");sm.addStringParameter(sri.getDocType());
	 		int rtn1 = sm.doUpdate(sb.toString());
	 		if(rtn1 < 1){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage("입력중 에러가 발생하였습니다. 관리자한테 문의하여 주십시요.");
				Logger.err.println(info.getSession("ID"), this, "입력중 에러가 발생하였습니다. 관리자한테 문의하여 주십시요.");
				return getSepoaOut();
			}
 		  
			setStatus(1);
			setFlag(true);
			
			
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
	
	
	
	private int CreateApproval(SepoaInfo info,SignRequestInfo sri)   // 결재모듈에 필요한 생성부분
    {                                                                                // 그대로 갖다 쓴다.

        Logger.debug.println(info.getSession("ID"),this,"##### CreateApproval #####");

        SepoaOut wo     = null;
        SepoaRemote ws  = null;
        String nickName= "p6027";
//        String nickName= "CT_150";
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
            Logger.err.println("approval: = " + e.getMessage());
        }
        return (wo != null)?wo.status:null;
    }
}