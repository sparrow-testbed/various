package sepoa.svc.approval;

import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaString;


public class AP_004 extends SepoaService{
	
    public AP_004(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
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
    
    
	public SepoaOut getCompleteList(Map<String, Object> data)
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			String MANAGER_POSITION = info.getSession("MANAGER_POSITION");
	        String DEPARTMENT 		= info.getSession("DEPARTMENT");
	        String CEO_ROLE					= "N";
	        String PURCHASE_CAPTION_ROLE	= "N";
	        
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			header.put("from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "from_date", "")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "to_date", "")));
			header.put("sign_from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "sign_from_date", "")));
			header.put("sign_to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "sign_to_date", "")));
			
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
	        header.put("is_purchase_captin", PURCHASE_CAPTION_ROLE);
	        //header.put("is_ceo", CEO_ROLE);
	        String str="";
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
	        	sxp = new SepoaXmlParser(this, "getProgressList_is_ceo");
				sxp.addVar("language", info.getSession("LANGUAGE"));
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	setValue(ssm.doSelect(header));
	        }else{
	        	sxp = new SepoaXmlParser(this, "getProgressList");
				sxp.addVar("language", info.getSession("LANGUAGE"));
	        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	setValue(ssm.doSelect(header));
	        }
		}catch(Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();

	}
}