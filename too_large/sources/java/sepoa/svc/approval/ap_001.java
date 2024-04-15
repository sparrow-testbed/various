package sepoa.svc.approval; 

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

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
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sms.SMS;
import ucMessage.UcMessage;
import wise.util.WiseApproval;
import wisecommon.SignResponseInfo;

public class AP_001 extends SepoaService {

    public AP_001(String opt, SepoaInfo info) throws SepoaServiceException {
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

	public SepoaOut getWaitList(Map<String, Object> data) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null; 
		SepoaSQLManager ssm = null;
		
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			Map<String, String> customHeader =  new HashMap<String, String>();	//�좉퇋媛앹껜
		
			
			  String MANAGER_POSITION = info.getSession("MANAGER_POSITION");
		        String DEPARTMENT 		= info.getSession("DEPARTMENT");

		        String CEO_ROLE					= "N";
		        String PURCHASE_CAPTION_ROLE	= "N";

		        if(			"40".equals(MANAGER_POSITION)
		        		||  ("352".equals(DEPARTMENT) && "20".equals(MANAGER_POSITION))
		          )
		        {
		        	CEO_ROLE = "Y";
		        }

		        if("352".equals(DEPARTMENT) && "20".equals(MANAGER_POSITION))
		        {
		        	PURCHASE_CAPTION_ROLE = "Y";
		        }
		        
		        String str="";
		        header.put("is_purchase_captin", PURCHASE_CAPTION_ROLE);
		        header.put("from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "from_date", "")));
				header.put("to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "to_date", "")));
				header.put("sign_from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "sign_from_date", "")));
				header.put("sign_to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "sign_to_date", "")));
				
		    if(CEO_ROLE.equals("Y")){ 
		    	if(header.get("app_status").equals("N")){
	        		/*1. 미결 : 본인이 결재를 해야할 건. */
	        		str += " AND SCTP.SIGN_USER_ID 	=  '"+info.getSession("ID")+"'";
	        		str += " AND SCTP.SIGN_CHECK 		=  'Y'";
	        		str += " AND SCTP.APP_STATUS IS NULL";
	        		str += " AND (SCTM.APP_STATUS = 'P' AND PROCEEDING_FLAG <> 'R')";
	        	}else if(header.get("app_status").equals("R")){
	        		/*2.
	        		CEO
	        		- 진행중 : 모든 결재건 중 최종결재자가까지 결재가 아직 안된 건들
	        		- 완료   : 모든 결재건 중 최종결재자 결재완료건
	        		- 반려   : 모든 결재건 중 반려건
	        		- VM, VN, SR 은 제외

	        		구매팀장
	        		- 진행중 : 모든 결재건 중 최종결재자가까지 결재가 아직 안된 건들
	        		- 완료   : 모든 결재건 중 최종결재자 결재완료건
	        		- 반려   : 모든 결재건 중 반려건
	        		- 모든문서를 보여준다.
	        	 */
	        		str += " AND SCTM.APP_STATUS = 'R'";
	        		if(PURCHASE_CAPTION_ROLE.equals("N")){
		        		str += " AND SCTM.DOC_TYPE NOT IN ('VM', 'VN', 'SR')";
		        	}
	        	}else if(header.get("app_status").equals("E")){
	        		/* 결제완료, 반려경우 같이 적용으로 변경(2012-08-14)*/
	        		str += " AND SCTM.APP_STATUS IN ('E','R')";
	        		if(PURCHASE_CAPTION_ROLE.equals("N")){
		        		str += " AND SCTM.DOC_TYPE NOT IN ('VM', 'VN', 'SR')";
		        	}
	        	}else if(header.get("app_status").equals("P")){
	        		/* 결제완료, 반려경우 같이 적용으로 변경(2012-08-14)*/
	        		str += "AND ((SCTM.APP_STATUS = 'P' AND PROCEEDING_FLAG <> 'R') OR (SCTM.APP_STATUS = 'E' AND PROCEEDING_FLAG = 'R') )";
	        		if(PURCHASE_CAPTION_ROLE.equals("N")){
		        		str += " AND SCTM.DOC_TYPE NOT IN ('VM', 'VN', 'SR')";
		        	}
	        	}else if(header.get("app_status").equals("")){
	        		str += " AND (";
	        		str += " ( SCTP.SIGN_USER_ID = '"+info.getSession("ID")+"'";
	        		str += " AND SCTP.SIGN_CHECK = 'Y'";
	        		str += " AND SCTP.APP_STATUS IS NULL";
	        		str += " AND ((SCTM.APP_STATUS = 'P' AND PROCEEDING_FLAG <> 'R') OR (SCTM.APP_STATUS = 'E' AND PROCEEDING_FLAG = 'R') ) )";
	        		str += " OR ( SCTM.APP_STATUS = 'R'";
	        		if(PURCHASE_CAPTION_ROLE.equals("N")){
		        		str += " AND SCTM.DOC_TYPE NOT IN ('VM', 'VN', 'SR')";
		        	}
	        		str += " ) OR ( SCTM.APP_STATUS = 'E'";
	        		if(PURCHASE_CAPTION_ROLE.equals("N")){
		        		str += " AND SCTM.DOC_TYPE NOT IN ('VM', 'VN', 'SR')";
		        	}
	        		str += " ) OR ( ((SCTM.APP_STATUS = 'P' AND PROCEEDING_FLAG <> 'R') OR (SCTM.APP_STATUS = 'E' AND PROCEEDING_FLAG = 'R') ) ";
	        		if(PURCHASE_CAPTION_ROLE.equals("N")){
		        		str += " AND SCTM.DOC_TYPE NOT IN ('VM', 'VN', 'SR')";
		        	}
	        		str += " ) )";
	        	}
		    	header.put("str", str);
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
				sxp.addVar("language", info.getSession("LANGUAGE"));
			
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	
	        	
	        	setValue(ssm.doSelect(header));
		    }
		    else{
		    	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				sxp.addVar("language", info.getSession("LANGUAGE"));
			
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	
	        	
	        	setValue(ssm.doSelect(header));	
		    	
		    }
		    
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
		
	public SepoaOut getSignPath(String doc_no, String doc_type, String doc_seq) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null; 
		SepoaSQLManager ssm = null;
		
		try {
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("doc_no", doc_no);
			no.put("doc_type", doc_type);
			no.put("doc_seq", doc_seq);
		   
			
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				sxp.addVar("language", info.getSession("LANGUAGE"));
			
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	
	        	setValue(ssm.doSelect(no));
		   
			    
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	

	public SepoaOut getSignAgree(String doc_no, String doc_type, String doc_seq) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null; 
		SepoaSQLManager ssm = null;
		
		try {
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("doc_no", doc_no);
			no.put("doc_type", doc_type);
			no.put("doc_seq", doc_seq);
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				sxp.addVar("language", info.getSession("LANGUAGE"));
			
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        
	        	setValue(ssm.doSelect(no));
		  
		    
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	
	

	public SepoaOut getSignPath2(String doc_no, String doc_type, String doc_seq) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null; 
		SepoaSQLManager ssm = null;
		
		try {
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("doc_no", doc_no);
			no.put("doc_type", doc_type);
			no.put("doc_seq", doc_seq);
			
			
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				sxp.addVar("language", info.getSession("LANGUAGE"));
			
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	
	        	setValue(ssm.doSelect(no));
		   
		    
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	
	public SepoaOut getSignAgree2(String doc_no, String doc_type, String doc_seq) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null; 
		SepoaSQLManager ssm = null;
		
		try {
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("doc_no", doc_no);
			no.put("doc_type", doc_type);
			no.put("doc_seq", doc_seq);
			
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				sxp.addVar("language", info.getSession("LANGUAGE"));
			
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        
	        	setValue(ssm.doSelect(no));
		  
		    
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	public SepoaOut getSignOpinion(String doc_no, String doc_seq, String doc_type) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null; 
		SepoaSQLManager ssm = null;
		
		try {
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("doc_no", doc_no);
			no.put("doc_type", doc_type);
			no.put("doc_seq", doc_seq);
		   
			
				sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				sxp.addVar("language", info.getSession("LANGUAGE"));
			
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	
	        	setValue(ssm.doSelect(no));
		   
		    
		    
		    
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	/**
	 * 결재 승인 (차기 결재자가 없는 경우)
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public SepoaOut setEndApp(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		Message msg = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		WiseApproval wa = null;
		SepoaOut value = null;
		String doc_type_h = "";
		Map<String, String> gridInfo = null;
		
		
		try{
			int rtn = -1;
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String> header = MapUtils.getMap(data, "headerData");

			String doc_type=grid.get(0).get("DOC_TYPE");
			String[] DOC_NO=new String[1];
			DOC_NO[0]=grid.get(0).get("DOC_NO");
			String[] DOC_SEQ=new String[1];
			DOC_SEQ[0]=grid.get(0).get("DOC_SEQ");
			String[] SHIPPER_TYPE=new String[1];
			SHIPPER_TYPE[0]=grid.get(0).get("SHIPPER_TYPE");
			String[] COMPANY_CODE=new String[1];
			COMPANY_CODE[0]=grid.get(0).get("COMPANY_CODE");			
			
			String sign_remark = header.get("remark");
			
			SignResponseInfo sri = new SignResponseInfo();
			
			//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
			Map<String, String> data1 =  new HashMap<String, String>();
			data1.put("DOC_TYPE",doc_type );
			data1.put("DOC_NO",DOC_NO[0] );
			data1.put("DOC_SEQ",DOC_SEQ[0] );
			sxp = new SepoaXmlParser(this, "getAddUserId"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(data1));
			String AddUserId="";
			if(sf != null  && sf.getRowCount() > 0) {
				AddUserId = sf.getValue("ADD_USER_ID", 0);
			}
			//////////////////////////////////////////////////////////////
			
			//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
			String ucline = CommonUtil.getConfig("sepoa.ucmessage.line");
			StringBuffer  sbMsg        = new StringBuffer();
			sbMsg.append("시 스 템  : 전자구매");
			sbMsg.append(ucline);						
			sbMsg.append("결재경로 : 결재 ▶▶ 상신함 ▶▶  상신내역"); 
			sbMsg.append(ucline);						
			sbMsg.append("문서번호 : ");
			sbMsg.append(DOC_NO[0]);
			sbMsg.append(ucline);						
			sbMsg.append("문 서 명  : ");				
			sbMsg.append(grid.get(0).get("SUBJECT"));	
			sbMsg.append(ucline);						
			sbMsg.append(ucline);			
			//////////////////////////////////////////////////////////////
			
			
			for(int i=0;i<grid.size();i++){
				
				gridInfo = grid.get(i); 
	            gridInfo.put("sign_remark", sign_remark);					
				sxp = new SepoaXmlParser(this, "setEndApp_1"); 
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doDelete(gridInfo);
				
				sxp = new SepoaXmlParser(this, "setEndApp_2"); 
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doDelete(gridInfo);
				
				sxp = new SepoaXmlParser(this, "setEndApp_3"); 
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doDelete(gridInfo);
			}
			
			
			if(rtn<1){
				throw new Exception("UPDATE ICOMSCTM ERROR");
			}
			
			sri.setHouseCode(info.getSession("HOUSE_CODE"));
			sri.setDocNo(DOC_NO);
			sri.setDocSeq(DOC_SEQ);
			sri.setSignUserId(info.getSession("ID"));
			sri.setShipperType(SHIPPER_TYPE);
			sri.setCompanyCode(COMPANY_CODE);
//			sri.setSignStatus("E");
			sri.setSignRemark(sign_remark);
			sri.setDocType(doc_type_h);
            
			
			
			if(doc_type.indexOf("^")== -1) doc_type_h = doc_type;
            else {
                StringTokenizer st1 = new StringTokenizer(doc_type, "^");
                doc_type_h = st1.nextToken();
            }
			Map<String, String> dataName =  new HashMap<String, String>();
			dataName.put("doc_type_h",doc_type_h );
			sxp = new SepoaXmlParser(this, "getMethodName"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(dataName));
			String Nick="";
			if(sf != null  && sf.getRowCount() > 0) {
				Nick = sf.getValue("TEXT3", 0);
			}
			
            String conType = "NONDBJOB";          //conType : CONNECTION/TRANSACTION/NONDBJOB
            String MethodName = Nick;   //NickName으로 연결된 Class에 정의된 Method Name //Approval_CT
            String serviceId = doc_type_h;
                        
            /*타입 저장*/
            sri.setDocType(doc_type_h);

            //경상비(결의번호채번) 품의 최종결재시
            if ("PAY".equals(doc_type_h) ) {
            	sri.setUser_trm_no(header.get("user_trm_no"));         
            	
            	String[] APP_STAGE=new String[1];
    			APP_STAGE[0]=grid.get(0).get("APP_STAGE");    		
    			sri.setAppStage(APP_STAGE);    			
			}
            
			if ("PAY".equals(doc_type_h) ) {
				 sri.setSignStatus("M");
			}else{
				 sri.setSignStatus("E");
			}
			
            wa = new wise.util.WiseApproval( serviceId, conType, info );
            wa.setConnection(ctx);
            Object[] args = {sri};
            value = wa.lookup( MethodName, args );
						
			if(value.status ==	0) {
				throw new Exception();

			}else{
 	            setStatus(1);
 	            setFlag(true);
 				//setMessage(msg.getMessage("0012"));
				Commit();
				
				//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
				if("PR".equals(doc_type_h)){  
					sbMsg.append("구매요청 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
	            }else if("RQ".equals(doc_type_h)){
	            	sbMsg.append("견적의뢰 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
  	            }else if("BID".equals(doc_type_h)){
  	            	sbMsg.append("입찰공고 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
  	            }else if("CT".equals(doc_type_h)){  	            
  	            	sbMsg.append("전자계약 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());					
				}else if("POD".equals(doc_type_h)){  	            
					sbMsg.append("발주 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());					
				}else if("PSB".equals(doc_type_h)){  	            
					sbMsg.append("자본예산지급 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());					
				}else if("PAY".equals(doc_type_h)){  	            
					sbMsg.append("경상비 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());					
				}else if("AR".equals(doc_type_h)){  	            
					sbMsg.append("계좌번호변경 결재 완료되었습니다.");
					UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());					
				}
				////////////////////////////////////////////////////////////////////////////////////////////////////////////					
			}
			
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	//차기결재자가 있을 경우
	public SepoaOut setUpdate(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		Message msg = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		WiseApproval wa = null;
		SepoaOut value = null;
		String doc_type_h = "";
		Map<String, String> gridInfo = null;
		
		try{
			int rtn = -1;
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			String doc_type=grid.get(0).get("DOC_TYPE");
			String[] DOC_NO=new String[1];
			DOC_NO[0]=grid.get(0).get("DOC_NO");
			String[] DOC_SEQ=new String[1];
			DOC_SEQ[0]=grid.get(0).get("DOC_SEQ");
			String[] SHIPPER_TYPE=new String[1];
			SHIPPER_TYPE[0]=grid.get(0).get("SHIPPER_TYPE");
			String[] COMPANY_CODE=new String[1];
			COMPANY_CODE[0]=grid.get(0).get("COMPANY_CODE");

			SignResponseInfo sri = new SignResponseInfo();
		
			String sign_remark = header.get("remark");
			
			//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
			Map<String, String> data1 =  new HashMap<String, String>();
			data1.put("DOC_TYPE",doc_type );
			data1.put("DOC_NO",DOC_NO[0] );
			data1.put("DOC_SEQ",DOC_SEQ[0] );
			sxp = new SepoaXmlParser(this, "getAddUserId"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(data1));
			String AddUserId="";
			if(sf != null  && sf.getRowCount() > 0) {
				AddUserId = sf.getValue("ADD_USER_ID", 0);
			}
			//////////////////////////////////////////////////////////////
						
			//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
			String ucline = CommonUtil.getConfig("sepoa.ucmessage.line");
			StringBuffer  sbMsg        = new StringBuffer();
			sbMsg.append("시 스 템  : 전자구매");
			sbMsg.append(ucline);						
			sbMsg.append("결재경로 : 결재 ▶▶ 결재함(승인자) ▶▶  결재할문서");
			sbMsg.append(ucline);						
			sbMsg.append("문서번호 : ");
			sbMsg.append(DOC_NO[0]);
			sbMsg.append(ucline);						
			sbMsg.append("문 서 명  : ");				
			sbMsg.append(grid.get(0).get("SUBJECT"));	
			sbMsg.append(ucline);						
			sbMsg.append(ucline);			
			//////////////////////////////////////////////////////////////
			
			for(int i=0;i<grid.size();i++){
			
			gridInfo = grid.get(i); 
            gridInfo.put("sign_remark", sign_remark);		
			sxp = new SepoaXmlParser(this, "setUpdate_1"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			sxp = new SepoaXmlParser(this, "setUpdate_2"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			sxp = new SepoaXmlParser(this, "setUpdate_3"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			sxp = new SepoaXmlParser(this, "setUpdate_4"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			sxp = new SepoaXmlParser(this, "setUpdate_5"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			
			sxp = new SepoaXmlParser(this, "setUpdate_6_1"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			
			sxp = new SepoaXmlParser(this, "setUpdate_6_2"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			sxp = new SepoaXmlParser(this, "setUpdate_6_3"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			sxp = new SepoaXmlParser(this, "setUpdate_7"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(gridInfo);
			
			}
			
			if(rtn<1){
				throw new Exception("UPDATE ICOMSCTM ERROR");
			}
			
			sri.setHouseCode(info.getSession("HOUSE_CODE"));
			sri.setDocNo(DOC_NO);
			sri.setDocSeq(DOC_SEQ);
			sri.setSignUserId(info.getSession("ID"));
			sri.setShipperType(SHIPPER_TYPE);
			sri.setCompanyCode(COMPANY_CODE);
			sri.setSignStatus("P");
			sri.setDocType(doc_type_h);
			sri.setSignRemark(sign_remark);
			
			if(doc_type.indexOf("^")== -1) doc_type_h = doc_type;
            else {
                StringTokenizer st1 = new StringTokenizer(doc_type, "^");
                doc_type_h = st1.nextToken();
            }
			Map<String, String> dataName =  new HashMap<String, String>();
			dataName.put("doc_type_h",doc_type_h );
			sxp = new SepoaXmlParser(this, "getMethodName"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(dataName));
			String Nick="";
			if(sf != null  && sf.getRowCount() > 0) {
				Nick = sf.getValue("TEXT3", 0);
			}
			
            String conType = "NONDBJOB";          //conType : CONNECTION/TRANSACTION/NONDBJOB
            String MethodName = Nick;   //NickName으로 연결된 Class에 정의된 Method Name
            String serviceId = doc_type_h;

            /*타입 저장*/
            sri.setDocType(doc_type_h);

            if("BID".equals(doc_type_h)){
            	//입찰공고의 경우 차기 결재자가 있으면 상태를 업데이트 하지 않도록 수정했음(2015.04.17.shim)
            	setStatus(1);
            }else{
            	wa = new wise.util.WiseApproval( serviceId, conType, info );
                wa.setConnection(ctx);
                Object[] args = {sri};
                value = wa.lookup( MethodName, args );	
                
                if(value.status ==	0) {
    				try{
    					setStatus(0);
    					//setMessage(msg.getMessage("0009"));
    					Rollback();

    				}catch(Exception e2) {
    					Logger.err.println(info.getSession("ID"),this,e2.getMessage());
    				}

    			}else{
     	            setStatus(1);
    	            //setMessage(msg.getMessage("0012"));
     	            
     	            String next_sign_user_id = MapUtils.getString(header , "next_sign_user_id", "");
     	            
     	            //R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
     	            if("BID".equals(MapUtils.getString(header , "doc_type", ""))){
     	            	Map<String, String>param = new HashMap<String, String>();     	 	           
     					param.put("USER_ID", next_sign_user_id);
     					param.put("BID_NO", MapUtils.getString(header, "doc_no", "") );     					
     					new SMS("NONDBJOB", info).bd4Process(ctx, param);
     					
     					sbMsg.append("입찰공고 결재 바랍니다.");
     					UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());     					
     	            }else if("PR".equals(MapUtils.getString(header , "doc_type", ""))){
     	            	sbMsg.append("구매요청 결재 바랍니다.");
    	            	UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());
    	            }else if("RQ".equals(MapUtils.getString(header , "doc_type", ""))){
    	            	sbMsg.append("견적의뢰 결재 바랍니다.");
    	            	UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());
    	            }else if("CT".equals(MapUtils.getString(header , "doc_type", ""))){    
    	            	sbMsg.append("전자계약 결재 바랍니다.");
    	            	UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());     	            					
    	            }else if("POD".equals(MapUtils.getString(header , "doc_type", ""))){    
    	            	sbMsg.append("발주 결재 바랍니다.");
    	            	UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());     	            					
    	            }else if("PSB".equals(MapUtils.getString(header , "doc_type", ""))){    
    	            	sbMsg.append("자본예산지급 결재 바랍니다.");
    	            	UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());     	            					
     	            }else if("PAY".equals(MapUtils.getString(header , "doc_type", ""))){    
     	            	sbMsg.append("경상비 결재 바랍니다.");
    	            	UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());     	            					
    	            }else if("AR".equals(MapUtils.getString(header , "doc_type", ""))){    
    	            	sbMsg.append("계좌번호변경 결재 바랍니다.");
    	            	UcMessage.DirectSendMessage(AddUserId, next_sign_user_id, sbMsg.toString());     	            					
    	            }
     	            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    			}
            }
            Commit();
			
			
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	
	
	public SepoaOut setInsert(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		Message msg = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		WiseApproval wa = null;
		SepoaOut value = null;
		String doc_type_h = "";
		try{
			int rtn = -1;
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			String doc_type=grid.get(0).get("DOC_TYPE");
			String[] DOC_NO=new String[1];
			DOC_NO[0]=grid.get(0).get("DOC_NO");
			String[] DOC_SEQ=new String[1];
			DOC_SEQ[0]=grid.get(0).get("DOC_SEQ");
			String[] SHIPPER_TYPE=new String[1];
			SHIPPER_TYPE[0]=grid.get(0).get("SHIPPER_TYPE");
			String[] COMPANY_CODE=new String[1];
			COMPANY_CODE[0]=grid.get(0).get("COMPANY_CODE");
			SignResponseInfo sri = new SignResponseInfo();
			
			sxp = new SepoaXmlParser(this, "setInsert_1"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(grid, true);
			
			sxp = new SepoaXmlParser(this, "setInsert_2"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(grid, true);
			
			sxp = new SepoaXmlParser(this, "setInsert_3"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(grid, true);
			
			if(rtn<1){
				throw new Exception("UPDATE ICOMSCTM ERROR");
			}
			
			sri.setHouseCode(info.getSession("HOUSE_CODE"));
			sri.setDocNo(DOC_NO);
			sri.setDocSeq(DOC_SEQ);
			sri.setSignUserId(info.getSession("ID"));
			sri.setShipperType(SHIPPER_TYPE);
			sri.setCompanyCode(COMPANY_CODE);
			sri.setSignStatus("E");
			sri.setDocType(doc_type_h);
			
			if(doc_type.indexOf("^")== -1) doc_type_h = doc_type;
            else {
                StringTokenizer st1 = new StringTokenizer(doc_type, "^");
                doc_type_h = st1.nextToken();
            }
			Map<String, String> dataName =  new HashMap<String, String>();
			dataName.put("doc_type_h",doc_type_h );
			sxp = new SepoaXmlParser(this, "getMethodName"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(dataName));
			String Nick="";
			if(sf != null  && sf.getRowCount() > 0) {
				Nick = sf.getValue("TEXT3", 0);
			}
			
            String conType = "NONDBJOB";          //conType : CONNECTION/TRANSACTION/NONDBJOB
            String MethodName = Nick;   //NickName으로 연결된 Class에 정의된 Method Name
            String serviceId = doc_type_h;

            /*타입 저장*/
            sri.setDocType(doc_type_h);

            wa = new wise.util.WiseApproval( serviceId, conType, info );
            wa.setConnection(ctx);
            Object[] args = {sri};
            value = wa.lookup( MethodName, args );
			
			
			if(value.status ==	0) {
				try{
					setStatus(0);
					//setMessage(msg.getMessage("0009"));
					Rollback();

				}catch(Exception e2) {
					Logger.err.println(info.getSession("ID"),this,e2.getMessage());
				}

			}else{
 	            setStatus(1);
	            //setMessage(msg.getMessage("0012")); 	                 
				Commit();
			}
			
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	
	
	public SepoaOut setRefund(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		Message msg = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		WiseApproval wa = null;
		SepoaOut value = null;
		String doc_type_h = "";
		Map<String, String> gridInfo = null;
		
		try{
			int rtn = -1;
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			String doc_type=grid.get(0).get("DOC_TYPE");
			String[] DOC_NO=new String[1];
			DOC_NO[0]=grid.get(0).get("DOC_NO");
			String[] DOC_SEQ=new String[1];
			DOC_SEQ[0]=grid.get(0).get("DOC_SEQ");
			String[] SHIPPER_TYPE=new String[1];
			SHIPPER_TYPE[0]=grid.get(0).get("SHIPPER_TYPE");
			String[] COMPANY_CODE=new String[1];
			COMPANY_CODE[0]=grid.get(0).get("COMPANY_CODE");
			SignResponseInfo sri = new SignResponseInfo();
			
			
			String sign_remark = header.get("remark");
			
			//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
			Map<String, String> data1 =  new HashMap<String, String>();
			data1.put("DOC_TYPE",doc_type );
			data1.put("DOC_NO",DOC_NO[0] );
			data1.put("DOC_SEQ",DOC_SEQ[0] );
			sxp = new SepoaXmlParser(this, "getAddUserId"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(data1));
			String AddUserId="";
			if(sf != null  && sf.getRowCount() > 0) {
				AddUserId = sf.getValue("ADD_USER_ID", 0);
			}
			//////////////////////////////////////////////////////////////
			
			//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
			String ucline = CommonUtil.getConfig("sepoa.ucmessage.line");
			StringBuffer  sbMsg        = new StringBuffer();
			sbMsg.append("시 스 템  : 전자구매");
			sbMsg.append(ucline);						
			sbMsg.append("결재경로 : 결재 ▶▶ 상신함 ▶▶  상신내역"); 
			sbMsg.append(ucline);						
			sbMsg.append("문서번호 : ");
			sbMsg.append(DOC_NO[0]);
			sbMsg.append(ucline);						
			sbMsg.append("문 서 명  : ");				
			sbMsg.append(grid.get(0).get("SUBJECT"));	
			sbMsg.append(ucline);						
			sbMsg.append(ucline);			
			//////////////////////////////////////////////////////////////
			
			for(int i=0;i<grid.size();i++){
			
				gridInfo = grid.get(i); 
	            gridInfo.put("sign_remark", sign_remark);		
	            
	            
				sxp = new SepoaXmlParser(this, "setRefund_1"); 
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doDelete(gridInfo);
				
				sxp = new SepoaXmlParser(this, "setRefund_2"); 
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doDelete(gridInfo);
				
				sxp = new SepoaXmlParser(this, "setRefund_3"); 
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn = ssm.doDelete(gridInfo);
			}
			if(rtn<1){
				throw new Exception("UPDATE ICOMSCTM ERROR");
			}
			
			sri.setHouseCode(info.getSession("HOUSE_CODE"));
			sri.setDocNo(DOC_NO);
			sri.setDocSeq(DOC_SEQ);
			sri.setSignUserId(info.getSession("ID"));
			sri.setShipperType(SHIPPER_TYPE);
			sri.setCompanyCode(COMPANY_CODE);
			sri.setSignStatus("R");
			sri.setDocType(doc_type_h);
			
			if(doc_type.indexOf("^")== -1) doc_type_h = doc_type;
            else {
                StringTokenizer st1 = new StringTokenizer(doc_type, "^");
                doc_type_h = st1.nextToken();
            }
			Map<String, String> dataName =  new HashMap<String, String>();
			dataName.put("doc_type_h",doc_type_h );
			sxp = new SepoaXmlParser(this, "getMethodName"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(dataName));
			String Nick="";
			if(sf != null  && sf.getRowCount() > 0) {
				Nick = sf.getValue("TEXT3", 0);
			}
            String conType = "NONDBJOB";          //conType : CONNECTION/TRANSACTION/NONDBJOB
            String MethodName = Nick;   //NickName으로 연결된 Class에 정의된 Method Name
            String serviceId = doc_type_h;

            /*타입 저장*/
            sri.setDocType(doc_type_h);

            wa = new wise.util.WiseApproval( serviceId, conType, info );
            wa.setConnection(ctx);
            Object[] args = {sri};
            value = wa.lookup( MethodName, args );
			
			
			if(value.status ==	0) {
				try{
					setStatus(0);
					//setMessage(msg.getMessage("0009"));
					Rollback();

				}catch(Exception e2) {
					Logger.err.println(info.getSession("ID"),this,e2.getMessage());
				}

			}else{
 	            setStatus(1);
	            //setMessage(msg.getMessage("0012"));
				Commit();
				
				//R102006115128 - [서비스개발] (변원상) 전자구매시스템 결재알림 시스템 개선
				if("PR".equals(doc_type_h)){
					sbMsg.append("구매요청 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
	            }else if("RQ".equals(doc_type_h)){
	            	sbMsg.append("견적의뢰 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
  	            }else if("BID".equals(doc_type_h)){
  	            	sbMsg.append("입찰공고 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
  	            }else if("CT".equals(doc_type_h)){  
  	            	sbMsg.append("전자계약 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
	            }else if("POD".equals(doc_type_h)){  
	            	sbMsg.append("발주 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
	            }else if("PSB".equals(doc_type_h)){  
	            	sbMsg.append("자본예산지급 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
	            }else if("PAY".equals(doc_type_h)){  
	            	sbMsg.append("경상비 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
	            }else if("AR".equals(doc_type_h)){  
	            	sbMsg.append("계좌번호변경 결재 반려되었습니다.");
	            	UcMessage.DirectSendMessage(info.getSession("ID"), AddUserId, sbMsg.toString());
	            }
				////////////////////////////////////////////////////////////////////////////////////////////////////////////		            
			}
			
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}

	
  	
	
}