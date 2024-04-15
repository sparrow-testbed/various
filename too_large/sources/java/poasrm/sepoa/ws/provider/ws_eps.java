package poasrm.sepoa.ws.provider;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import poasrm.sepoa.ws.provider.Eps.M04_REQ_PR_DETAIL;
import sepoa.fw.cfg.Configuration;
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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class ws_eps extends SepoaService {
	@SuppressWarnings("unused")
	private Message msg;

    public ws_eps(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info, "MA012");
    }
    
	public String getConfig(String s){
		Configuration configuration = null;
		
	    try{
	        configuration = new Configuration();
	        
	        s = configuration.get(s);
	    }
	    catch(Exception exception){
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	        
	        s = null;
	    }
	    
	    return s;
	}
	
	/**
	 * 테스트용 메소드
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	@Deprecated
	public SepoaOut insertTestEps003(Map<String, String> header) throws Exception{
        ConnectionContext ctx = null;
        SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            id  = info.getSession("ID");
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "insertTestEps003");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doInsert(header);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(id, this, e.getMessage());
		}

		return getSepoaOut();
    }
	
	/**
	 * 구매요청 번호를 채번하는 메소드
	 * 
	 * @return String
	 * @throws Exception
	 */
	private String getReqItemNo() throws Exception{
		SepoaOut wo        = DocumentUtil.getDocNumber(info,"IT");
		String   reqItemNo = wo.result[0];
		
		return reqItemNo;
	}
	
	/**
	 * 인터페이스 번호를 채번하는 메소드
	 * 
	 * @return String
	 * @throws Exception
	 */
	private String getInfNo() throws Exception{
		SepoaOut wo     = DocumentUtil.getDocNumber(info, "RFC");
		String   result = wo.result[0];
		
		return result;
	}
	
	/**
	 * 조회 메소드
	 * 
	 * @param ctx
	 * @param name
	 * @param param
	 * @return String
	 * @throws Exception
	 */
	private String select(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          result = null;
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doSelect(param); // 조회
		
		return result;
	}
	
	/**
	 * 등록 메소드
	 * 
	 * @param ctx
	 * @param name
	 * @param param
	 * @return int
	 * @throws Exception
	 */
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
	 * 수정 메소드
	 * 
	 * @param ctx
	 * @param name
	 * @param param
	 * @return int
	 * @throws Exception
	 */
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
	
	/**
	 * 삭제 메소드
	 * 
	 * @param ctx
	 * @param name
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	private int delete(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doDelete(param);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut insertIcomrehdList(Map<String, Object> header) throws Exception{
		ConnectionContext         ctx       = null;
		String                    reqItemNo = null;
		List<Map<String, String>> list      = null;
		Map<String, String>       listInfo  = null;
		int                       listSize  = 0;
		int                       i         = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx       = getConnectionContext();
			list      = (List<Map<String, String>>)header.get("list");
			listSize  = list.size();
			
			for(i = 0; i < listSize; i++){
				listInfo  = list.get(i);
				reqItemNo = this.getReqItemNo();
	            
				listInfo.put("REQ_ITEM_NO", reqItemNo);
	            
	            this.insert(ctx, "insertIcomrehdInfo", listInfo);	            
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * <pre>
	 * 구매요청 테이블에 데이터를 등록하는 메소드
	 * heder 구조
	 * 	HOUSE_CODE
	 * 	ITEM_NO
	 * 	USER_ID
	 * 	DESCRIPTION_LOC
	 * 	SPECIFICATION
	 * 	COMPANY_CODE
	 * 	IMAGE_FILE_PATH
	 * 	THUMNAIL_FILE_PATH
	 * 	EFFECTIVE_START_DATE
	 * 	EFFECTIVE_END_DATE
	 * 	PUB_NO
	 * </pre>
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertIcomrehdInfo(Map<String, String> header) throws Exception{
        ConnectionContext ctx       = null;
		String            reqItemNo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx       = getConnectionContext();
			reqItemNo = this.getReqItemNo();
            
            header.put("REQ_ITEM_NO", reqItemNo);
            
            this.insert(ctx, "insertIcomrehdInfo", header);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateIcomrehdList(Map<String, Object> header) throws Exception{
		ConnectionContext         ctx      = null;
		String                    id       = info.getSession("ID");
		SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> list     = null;
		Map<String, String>       listInfo = null;
        int                       result   = 0;
        int                       listSize = 0;
        int                       i        = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)header.get("list");
			listSize = list.size();
			
			for(i = 0; i < listSize; i++){
				listInfo = list.get(i);
				
				sxp = new SepoaXmlParser(this, "updateIcomrehdInfo");
				
				sxp.addVar("DESCRIPTION_LOC",      listInfo.get("DESCRIPTION_LOC"));
				sxp.addVar("SPECIFICATION",        listInfo.get("SPECIFICATION"));
				sxp.addVar("IMAGE_FILE_PATH",      listInfo.get("IMAGE_FILE_PATH"));
				sxp.addVar("THUMNAIL_FILE_PATH",   listInfo.get("THUMNAIL_FILE_PATH"));
				sxp.addVar("EFFECTIVE_START_DATE", listInfo.get("EFFECTIVE_START_DATE"));
				sxp.addVar("EFFECTIVE_END_DATE",   listInfo.get("EFFECTIVE_END_DATE"));
				sxp.addVar("PUB_NO",               listInfo.get("PUB_NO"));
				sxp.addVar("MAXREQAMNT",           listInfo.get("MAXREQAMNT"));
				sxp.addVar("MINREQAMNT",           listInfo.get("MINREQAMNT"));
				sxp.addVar("MINAMNT",              listInfo.get("MINAMNT"));
				sxp.addVar("MLOBHOCD",             listInfo.get("MLOBHOCD"));
				sxp.addVar("USEDFLAG",             listInfo.get("USEDFLAG"));
				sxp.addVar("MODEL",                listInfo.get("MODEL"));
				
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				
				result = ssm.doUpdate(listInfo);
				
				sxp = new SepoaXmlParser(this, "updateIcommtglInfo");
				
				sxp.addVar("DESCRIPTION_LOC",      listInfo.get("DESCRIPTION_LOC"));
				sxp.addVar("SPECIFICATION",        listInfo.get("SPECIFICATION"));
				sxp.addVar("IMAGE_FILE_PATH",      listInfo.get("IMAGE_FILE_PATH"));
				sxp.addVar("THUMNAIL_FILE_PATH",   listInfo.get("THUMNAIL_FILE_PATH"));
				sxp.addVar("EFFECTIVE_START_DATE", listInfo.get("EFFECTIVE_START_DATE"));
				sxp.addVar("EFFECTIVE_END_DATE",   listInfo.get("EFFECTIVE_END_DATE"));
				sxp.addVar("PUB_NO",               listInfo.get("PUB_NO"));
				sxp.addVar("MAXREQAMNT",           listInfo.get("MAXREQAMNT"));
				sxp.addVar("MINREQAMNT",           listInfo.get("MINREQAMNT"));
				sxp.addVar("MINAMNT",              listInfo.get("MINAMNT"));
				sxp.addVar("MLOBHOCD",             listInfo.get("MLOBHOCD"));
				sxp.addVar("USEDFLAG",             listInfo.get("USEDFLAG"));
				sxp.addVar("MODEL",                listInfo.get("MODEL"));
				
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				
				ssm.doUpdate(listInfo);
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	/**
	 * <pre>
	 * 구매요청 테이블에 데이터를 수정하는 메소드
	 * heder 구조
	 * 	DESCRIPTION_LOC
	 * 	SPECIFICATION
	 * 	IMAGE_FILE_PATH
	 * 	THUMNAIL_FILE_PATH
	 * 	EFFECTIVE_START_DATE
	 * 	EFFECTIVE_END_DATE
	 * 	PUB_NO
	 * 	CHANGE_USER_ID
	 * 	CHANGE_USER_NAME_LOC
	 * 	HOUSE_CODE
	 * 	ITEM_NO
	 * </pre>
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateIcomrehdInfo(Map<String, String> header) throws Exception{
		ConnectionContext ctx    = null;
		String            id     = info.getSession("ID");
		SepoaXmlParser    sxp    = null;
		SepoaSQLManager   ssm    = null;
        int               result = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "updateIcomrehdInfo");
			
			sxp.addVar("DESCRIPTION_LOC",      header.get("DESCRIPTION_LOC"));
			sxp.addVar("SPECIFICATION",        header.get("SPECIFICATION"));
			sxp.addVar("IMAGE_FILE_PATH",      header.get("IMAGE_FILE_PATH"));
			sxp.addVar("THUMNAIL_FILE_PATH",   header.get("THUMNAIL_FILE_PATH"));
			sxp.addVar("EFFECTIVE_START_DATE", header.get("EFFECTIVE_START_DATE"));
			sxp.addVar("EFFECTIVE_END_DATE",   header.get("EFFECTIVE_END_DATE"));
			sxp.addVar("PUB_NO",               header.get("PUB_NO"));
			sxp.addVar("MAXREQAMNT",           header.get("MAXREQAMNT"));
			sxp.addVar("MINREQAMNT",           header.get("MINREQAMNT"));
			sxp.addVar("MINAMNT",              header.get("MINAMNT"));
			sxp.addVar("MLOBHOCD",             header.get("MLOBHOCD"));
			sxp.addVar("USEDFLAG",             header.get("USEDFLAG"));
			sxp.addVar("MODEL",                header.get("MODEL"));
			
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			result = ssm.doUpdate(header);
			
			sxp = new SepoaXmlParser(this, "updateIcommtglInfo");
			
			sxp.addVar("DESCRIPTION_LOC",      header.get("DESCRIPTION_LOC"));
			sxp.addVar("SPECIFICATION",        header.get("SPECIFICATION"));
			sxp.addVar("IMAGE_FILE_PATH",      header.get("IMAGE_FILE_PATH"));
			sxp.addVar("THUMNAIL_FILE_PATH",   header.get("THUMNAIL_FILE_PATH"));
			sxp.addVar("EFFECTIVE_START_DATE", header.get("EFFECTIVE_START_DATE"));
			sxp.addVar("EFFECTIVE_END_DATE",   header.get("EFFECTIVE_END_DATE"));
			sxp.addVar("PUB_NO",               header.get("PUB_NO"));
			sxp.addVar("MAXREQAMNT",           header.get("MAXREQAMNT"));
			sxp.addVar("MINREQAMNT",           header.get("MINREQAMNT"));
			sxp.addVar("MINAMNT",              header.get("MINAMNT"));
			sxp.addVar("MLOBHOCD",             header.get("MLOBHOCD"));
			sxp.addVar("USEDFLAG",             header.get("USEDFLAG"));
			sxp.addVar("MODEL",                header.get("MODEL"));
			
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			ssm.doUpdate(header);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	/**
	 * <pre>
	 * 구매요청 테이블에 데이터를 삭제하는 메소드
	 * heder 구조
	 * 	HOUSE_CODE
	 * 	ITEM_NO
	 * </pre>
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut deleteIcomrehdList(Map<String, Object> header) throws Exception{
        ConnectionContext         ctx      = null;
        List<Map<String, String>> list     = null;
        Map<String, String>       listInfo = null;
        int                       result   = 0;
        int                       listSize = 0;
        int                       i        = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)header.get("list");
			listSize = list.size();
			
			for(i = 0; i < listSize; i++){
				listInfo = list.get(i);
				
				result = this.delete(ctx, "deleteIcomrehdInfo", listInfo);
			}
			
			if(result == 0){
				throw new Exception();
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	/**
	 * <pre>
	 * 구매요청 테이블에 데이터를 삭제하는 메소드
	 * heder 구조
	 * 	HOUSE_CODE
	 * 	ITEM_NO
	 * </pre>
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut deleteIcomrehdInfo(Map<String, String> header) throws Exception{
        ConnectionContext ctx    = null;
        int               result = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx    = getConnectionContext();
			result = this.delete(ctx, "deleteIcomrehdInfo", header);
			
			if(result == 0){
				throw new Exception();
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	/**
	 * 인터페이스 헤더 정보를 등록하는 메소드
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfhdInfo(Map<String, String> header) throws Exception{
		ConnectionContext ctx   = null;
		String            infNo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx   = getConnectionContext();
			infNo = this.getInfNo();
            
            header.put("INF_NO", infNo);
            
            this.insert(ctx, "insertSinfhdInfo", header);
			
			Commit();
			
			setValue(infNo);
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * 인터페이스 헤더 정보를 수정하는 메소드
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfhdInfo(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
            this.update(ctx, "updateSinfhdInfo", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0003에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep003Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep003Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0003에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep003Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep003Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0004에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep004Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep004Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0004에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep004Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep004Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0005에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertSinfep005Info(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		Map<String, String>       eps005       = null;
		Map<String, String>       eps005prInfo = null;
		List<Map<String, String>> eps005Pr     = null;
		int                       eps005PrSize = 0;
		int                       i            = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx          = getConnectionContext();
			eps005       = (Map<String, String>)param.get("eps005");
			eps005Pr     = (List<Map<String, String>>)param.get("eps005Pr");
			eps005PrSize = eps005Pr.size();
            
            this.insert(ctx, "insertSinfep005Info", eps005);
            
            for(i = 0; i < eps005PrSize; i++){
            	eps005prInfo = eps005Pr.get(i);
            	
            	this.insert(ctx, "insertSinfep005PrInfo", eps005prInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0005에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep005Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep005Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0031에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertSinfep0031Info(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		Map<String, String>       eps0031       = null;
		Map<String, String>       eps0031PrInfo = null;
		List<Map<String, String>> eps0031Pr     = null;
		int                       eps0031PrSize = 0;
		int                       i            = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx          = getConnectionContext();
			eps0031       = (Map<String, String>)param.get("eps0031");
			eps0031Pr     = (List<Map<String, String>>)param.get("eps0031Pr");
			eps0031PrSize = eps0031Pr.size();
            
            this.insert(ctx, "insertSinfep0031Info", eps0031);
            
            for(i = 0; i < eps0031PrSize; i++){
            	eps0031PrInfo = eps0031Pr.get(i);
            	
            	this.insert(ctx, "insertSinfep0031PrInfo", eps0031PrInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	
	/**
	 * eps0006에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep006Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep006Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0006에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep006Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep006Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	
	
	@SuppressWarnings("unchecked")
	public SepoaOut insertSinfep007(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		Map<String, String>       eps007       = null;
		Map<String, String>       eps007PrInfo = null;
		List<Map<String, String>> eps007Pr     = null;
		int                       eps007PrSize = 0;
		int                       i            = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx          = getConnectionContext();
			eps007       = (Map<String, String>)param.get("eps007");
			eps007Pr     = (List<Map<String, String>>)param.get("eps007Pr");
			eps007PrSize = eps007Pr.size();
            
            this.insert(ctx, "insertSinfep007Info", eps007);
            
            for(i = 0; i < eps007PrSize; i++){
            	eps007PrInfo = eps007Pr.get(i);
            	
            	this.insert(ctx, "insertSinfep007PrInfo", eps007PrInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0007에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep007Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep007Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0011 주요 정보를 저장하는 메소드
	 * 
	 * @param ctx
	 * @param prHd
	 * @param infNo
	 * @throws Exception
	 */
	private void insertSinfep0011InfoInsert(ConnectionContext ctx, Map<String, String> prHd, String infNo) throws Exception{
		Map<String, String> dbParam     = new HashMap<String, String>();
		String              houseCode   = info.getSession("HOUSE_CODE");
		String              srmsNo      = prHd.get("srmsNo");
		String              subject     = prHd.get("subject");
		String              addUserId   = prHd.get("addUserId");
		String              addUserName = prHd.get("addUserName");
		
		dbParam.put("HOUSE_CODE",    houseCode);
		dbParam.put("INF_NO",        infNo);
		dbParam.put("SRMS_NO",       srmsNo);
		dbParam.put("SUBJECT",       subject);
		dbParam.put("ADD_USER_ID",   addUserId);
		dbParam.put("ADD_USER_NAME", addUserName);

		this.insert(ctx, "insertSinfep0011Info", dbParam);
	}
	
	private void insertSinfep0011InfoPrInsert(ConnectionContext ctx, M04_REQ_PR_DETAIL[] detail, String infNo) throws Exception{
		Map<String, String> dbParam           = null;
		String              houseCode         = info.getSession("HOUSE_CODE");
		String              seq               = null;
		String              srmsSeq           = null;
		String              itemNo            = null;
		String              prQty             = null;
		String              prLocation        = null;
		String              rdDate            = null;
		String              purchaserId       = null;
		String              purchaserName     = null;
		String              purchaserDept     = null;
		String              purchaserDeptName = null;
		String              unitPrice         = null;
		String              prAmt             = null;
		M04_REQ_PR_DETAIL   detailInfo        = null;
		int                 detailLength      = detail.length;
		int                 i                 = 0;
		
		for(i = 0; i < detailLength; i++){
			dbParam = new HashMap<String, String>();
			
			seq           = Integer.toString(i + 1);
			detailInfo    = detail[i];
			srmsSeq       = detailInfo.getSRMS_SEQ();
			itemNo        = detailInfo.getITEM_NO();
			prQty         = detailInfo.getPR_QTY();
			unitPrice     = detailInfo.getUNIT_PRICE();
			prAmt         = detailInfo.getPR_AMT();
			
			dbParam.put("HOUSE_CODE", houseCode);
			dbParam.put("INF_NO",     infNo);
			dbParam.put("SEQ",        seq);
			dbParam.put("SRMS_SEQ",   srmsSeq);
			dbParam.put("ITEM_NO",    itemNo);
			dbParam.put("PR_QTY",     prQty);
			dbParam.put("UNIT_PRICE", unitPrice);
			dbParam.put("PR_AMT",     prAmt);
			
			this.insert(ctx, "insertSinfep0011InfoPr", dbParam);
		}
	}
	
	/**
	 * eps0011에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertSinfep0011Info(Map<String, Object> param) throws Exception{
		ConnectionContext   ctx    = null;
		Map<String, String> prHd   = (Map<String, String>)param.get("prHd");
		String              infNo  = (String)param.get("infNo");
		M04_REQ_PR_DETAIL[] detail = (M04_REQ_PR_DETAIL[])param.get("detail");
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			this.insertSinfep0011InfoInsert(ctx, prHd, infNo);
			this.insertSinfep0011InfoPrInsert(ctx, detail, infNo);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * 구매요청 번호를 조회하는 메소드
	 * 
	 * @param info
	 * @return String
	 * @throws Exception
	 */
	private String getPrNo(SepoaInfo info) throws Exception{
		SepoaOut wo   = DocumentUtil.getDocNumber(info, "PR");
	    String   prNo = wo.result[0];
	    
	    return prNo;
	}
	
	/**
	 * 구매요청 헤더를 생성하는 메소드
	 * 
	 * @param ctx
	 * @param info
	 * @param prHd
	 * @return String
	 * @throws Exception
	 */
	private String setPrHd(ConnectionContext ctx, SepoaInfo info, Map<String, String> prHd) throws Exception{
		Map<String, String> dbParam       = new HashMap<String, String>();
		String              department    = prHd.get("deptCode");
		String              id            = prHd.get("addUserId");
		String              prNo          = this.getPrNo(info);
		String              currentDate   = SepoaDate.getShortDateString();
		String              sevenDaysDate = SepoaDate.addSepoaDateDay(currentDate, 7);
		
		dbParam.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		dbParam.put("PR_NO",               prNo);
		dbParam.put("STATUS",              "C");
		dbParam.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		dbParam.put("PLANT_CODE",          department);
		dbParam.put("PR_TOT_AMT",          "0");
		dbParam.put("PR_TYPE",             "I");
		dbParam.put("DEMAND_DEPT",         prHd.get("deptCode"));
		dbParam.put("DEMAND_DEPT_NAME",    prHd.get("deptName"));
		dbParam.put("SIGN_STATUS",         "T");
		dbParam.put("SIGN_DATE",           currentDate);
		dbParam.put("SIGN_PERSON_ID",      id);
		dbParam.put("SIGN_PERSON_NAME",    info.getSession("NAME_LOC"));
		dbParam.put("REMARK",              "");
		dbParam.put("SUBJECT",             prHd.get("subject"));
		dbParam.put("PR_LOCATION",         "01");
		dbParam.put("ORDER_NO",            "");
		dbParam.put("SALES_USER_DEPT",     department);
		dbParam.put("SALES_USER_ID",       id);
		dbParam.put("CONTRACT_HOPE_DAY",   sevenDaysDate);
		dbParam.put("CUST_CODE",           "0000100000");
		dbParam.put("CUST_NAME",           "기타(계획용)");
		dbParam.put("EXPECT_AMT",          "0");
		dbParam.put("SALES_TYPE",          "P");
		dbParam.put("ORDER_NAME",          "");
		dbParam.put("REQ_TYPE",            "P");
		dbParam.put("RETURN_HOPE_DAY",     sevenDaysDate);
		dbParam.put("ATTACH_NO",           "");
		dbParam.put("HARD_MAINTANCE_TERM", "");
		dbParam.put("SOFT_MAINTANCE_TERM", "");
		dbParam.put("CREATE_TYPE",         "PR");
		dbParam.put("ADD_USER_ID",         id);
		dbParam.put("CHANGE_USER_ID",      id);
		dbParam.put("BSART",               "");
		dbParam.put("CUST_TYPE",           "");
		dbParam.put("ADD_DATE",            currentDate);
		dbParam.put("AHEAD_FLAG",          "N");
		dbParam.put("CONTRACT_FROM_DATE",  "");
		dbParam.put("CONTRACT_TO_DATE",    "");
		dbParam.put("SALES_AMT",           "");
		dbParam.put("PROJECT_PM",          "");
		dbParam.put("ORDER_COUNT",         "");
		dbParam.put("WBS",                 "");
		dbParam.put("WBS_NAME",            "");
		dbParam.put("DELY_TO_LOCATION",    "");
		dbParam.put("DELY_TO_ADDRESS",     "");
		dbParam.put("DELY_TO_USER",        "");
		dbParam.put("DELY_TO_PHONE",       "");
		dbParam.put("PC_FLAG",             "N");
		dbParam.put("PC_REASON",           "");
		
		this.insert(ctx, "insertIcoyPrHdInfo", dbParam);
		
		return prNo;
	}
	
	/**
	 * 구매요청 상품의 정보를 조회하는 메소드
	 * 
	 * @param ctx
	 * @param info
	 * @param itemNo
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> selectIcomMtglInfo(ConnectionContext ctx, SepoaInfo info, String itemNo) throws Exception{
		Map<String, String> result         = new HashMap<String, String>();
		Map<String, String> dbParam        = new HashMap<String, String>();
		String              houseCode      = info.getSession("HOUSE_CODE");
		String              selectResult   = null;
		String              ctrlCode       = null;
		String              basicUnit      = null;
		String              descriptionLoc = null;
		String              specification  = null;
		String              makerCode      = null;
		String              makerName      = null;
		String              ktgrm          = null;
		SepoaFormater       sepoaFormater  = null;
		int                 rowCount       = 0;
		
		dbParam.put("HOUSE_CODE",  houseCode);
		dbParam.put("PR_LOCATION", "01");
		dbParam.put("ITEM_NO",     itemNo);
		
		selectResult = this.select(ctx, "selectIcomMtglInfo", dbParam);
		
		sepoaFormater = new SepoaFormater(selectResult);
		rowCount      = sepoaFormater.getRowCount();
		
		if(rowCount == 0){
			throw new Exception();
		}
		
		ctrlCode       = sepoaFormater.getValue("CTRL_CODE",       0);
		basicUnit      = sepoaFormater.getValue("BASIC_UNIT",      0);
		descriptionLoc = sepoaFormater.getValue("DESCRIPTION_LOC", 0);
		specification  = sepoaFormater.getValue("SPECIFICATION",   0);
		makerCode      = sepoaFormater.getValue("MAKER_CODE",      0);
		makerName      = sepoaFormater.getValue("MAKER_NAME",      0);
		ktgrm          = sepoaFormater.getValue("KTGRM",           0);
		
		result.put("ctrlCode",       ctrlCode);
		result.put("basicUnit",      basicUnit);
		result.put("descriptionLoc", descriptionLoc);
		result.put("specification",  specification);
		result.put("makerCode",      makerCode);
		result.put("makerName",      makerName);
		result.put("ktgrm",          ktgrm);
		
		return result;
	}
	
	/**
	 * 구매요청 상세를 처리하는 메소드
	 * @param ctx
	 * @param info
	 * @param detailArray
	 * @param prNo
	 * @throws Exception
	 */
	private void setPrDt(ConnectionContext ctx, SepoaInfo info, M04_REQ_PR_DETAIL[] detailArray, String prNo, Map<String, String> prHd) throws Exception{
		Map<String, String> daParam           = new HashMap<String, String>();
		Map<String, String> icomMtglInfo      = null;
		String              id                = info.getSession("ID");
		String              itemNo            = null;
		String              monthAfter        = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), 1);
		String              deptCode          = prHd.get("deptCode");
		String              deptName          = prHd.get("deptName");
		M04_REQ_PR_DETAIL   detailArrayInfo   = null;
		int                 detailArrayLength = detailArray.length;
		int                 i                 = 0;
		
		if(detailArrayLength == 0){
			throw new Exception();
		}
		
		for(i = 0; i < detailArrayLength; i++){
			detailArrayInfo = detailArray[i];
			itemNo          = detailArrayInfo.getITEM_NO();
			icomMtglInfo    = this.selectIcomMtglInfo(ctx, info, itemNo);
			
			daParam.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
			daParam.put("PR_NO",               prNo);
			daParam.put("PR_SEQ",              String.valueOf((i + 1) * 10));
			daParam.put("STATUS",              "C");
			daParam.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
			daParam.put("PLANT_CODE",          info.getSession("PLANT_CODE"));
			daParam.put("ITEM_NO",             itemNo);
			daParam.put("PR_PROCEEDING_FLAG",  "P");
			daParam.put("CTRL_CODE",           icomMtglInfo.get("ctrlCode"));
			daParam.put("UNIT_MEASURE",        icomMtglInfo.get("basicUnit"));
			daParam.put("PR_QTY",              detailArrayInfo.getPR_QTY());
			daParam.put("CUR",                 "KRW");
			daParam.put("UNIT_PRICE",          detailArrayInfo.getUNIT_PRICE());
			daParam.put("PR_AMT",              detailArrayInfo.getPR_AMT());
			daParam.put("RD_DATE",             monthAfter);
			daParam.put("ATTACH_NO",           "");
			daParam.put("REC_VENDOR_CODE",     "");
			daParam.put("DELY_TO_ADDRESS_CD",  deptCode);
			daParam.put("REC_VENDOR_NAME",     "");
			daParam.put("DESCRIPTION_LOC",     icomMtglInfo.get("descriptionLoc"));
			daParam.put("SPECIFICATION",       icomMtglInfo.get("specification"));
			daParam.put("MAKER_NAME",          icomMtglInfo.get("makerName"));
			daParam.put("MAKER_CODE",          icomMtglInfo.get("makerCode"));
			daParam.put("REMARK",              "");
			daParam.put("PURCHASE_LOCATION",   "01");
			daParam.put("PURCHASER_ID",        "");
			daParam.put("PURCHASER_NAME",      "");
			daParam.put("PURCHASE_DEPT",       "");
			daParam.put("PURCHASE_DEPT_NAME",  "");
			daParam.put("TECHNIQUE_GRADE",     "");
			daParam.put("TECHNIQUE_TYPE",      "");
			daParam.put("INPUT_FROM_DATE",     "");
			daParam.put("INPUT_TO_DATE",       "");
			daParam.put("ADD_USER_ID",         id);
			daParam.put("CHANGE_USER_ID",      id);
			daParam.put("KNTTP",               "P");
			daParam.put("ZEXKN",               "01");
			daParam.put("ORDER_NO",            "");
			daParam.put("ORDER_SEQ",           Integer.toString(i + 1));
			daParam.put("WBS_NO",              "");
			daParam.put("WBS_SUB_NO",          "");
			daParam.put("WBS_TXT",             "");
			daParam.put("CONTRACT_DIV",        "");
			daParam.put("DELY_TO_ADDRESS",     deptName);
			daParam.put("WARRANTY",            "");
			daParam.put("EXCHANGE_RATE",       "1");
			daParam.put("WBS_NAME",            "");
			daParam.put("ORDER_COUNT",         "");
			daParam.put("PRE_TYPE",            "");
			daParam.put("PRE_PO_NO",           "");
			daParam.put("PRE_PO_SEQ",          "");
			daParam.put("ACCOUNT_TYPE",        icomMtglInfo.get("ktgrm"));
			daParam.put("ASSET_TYPE",          "");
			
			this.insert(ctx, "insertIcoyPrDtInfo", daParam);
		}
	}
	
	/**
	 * 사용자의 부서 정보를 조회
	 * 
	 * @param ctx
	 * @param info
	 * @param prHd
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> insertIcoyInfoSelectDeptInfo(ConnectionContext ctx, SepoaInfo info, Map<String, String> prHd) throws Exception{
		Map<String, String> dbParam        = new HashMap<String, String>();
		String              houseCode      = info.getSession("HOUSE_CODE");
		String              companyCode    = info.getSession("COMPANY_CODE");
		String              userId         = prHd.get("addUserId");
		String              deptInfoString = null;
		String              deptCode       = null;
		String              deptName       = null;
		SepoaFormater       sf             = null;
		
		dbParam.put("HOUSE_CODE",   houseCode);
		dbParam.put("COMPANY_CODE", companyCode);
		dbParam.put("USER_ID",      userId);
		
		deptInfoString = this.select(ctx, "selectDeptInfoByUserId", dbParam);
		
		sf = new SepoaFormater(deptInfoString);
		
		deptCode = sf.getValue("DEPT_CODE", 0);
		deptName = sf.getValue("DEPT_NAME", 0);
		
		prHd.put("deptCode", deptCode);
		prHd.put("deptName", deptName);
		
		return prHd;
	}
	
	/**
	 * eps0011 구매요청을 처리하는 메소드
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertIcoyInfo(Map<String, Object> param) throws Exception{
		SepoaInfo           info        = (SepoaInfo)param.get("info");
		Map<String, String> prHd        = (Map<String, String>)param.get("prHd");
		M04_REQ_PR_DETAIL[] detailArray = (M04_REQ_PR_DETAIL[])param.get("detail");
		ConnectionContext   ctx         = null;
		String              prNo        = null;
	    
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			prHd = this.insertIcoyInfoSelectDeptInfo(ctx, info, prHd);
			prNo = this.setPrHd(ctx, info, prHd);
			
			this.setPrDt(ctx, info, detailArray, prNo, prHd);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	/**
	 * eps0011에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0011Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0011Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0015에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertSinfep0015Info(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx                  = null;
		Map<String, String>       sinfEp0015Info       = null;
		Map<String, String>       sinfEp0015PrListInfo = null;
		List<Map<String, String>> sinfEp0015PrList     = null;
		int                       sinfEp0015PrListSize = 0;
		int                       i                    = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx                  = getConnectionContext();
			sinfEp0015Info       = (Map<String, String>)param.get("sinfEp0015Info");
			sinfEp0015PrList     = (List<Map<String, String>>)param.get("sinfEp0015PrList");
			sinfEp0015PrListSize = sinfEp0015PrList.size();
            
            this.insert(ctx, "insertSinfep0015Info", sinfEp0015Info);
            
            for(i = 0; i < sinfEp0015PrListSize; i++){
            	sinfEp0015PrListInfo = sinfEp0015PrList.get(i);
            	
            	this.insert(ctx, "insertSinfep0015PrInfo", sinfEp0015PrListInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0015에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0015Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0015Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0016에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertSinfep0016Info(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx                  = null;
		Map<String, String>       sinfEp0016Info       = null;
		Map<String, String>       sinfEp0016PrListInfo = null;
		List<Map<String, String>> sinfEp0016PrList     = null;
		int                       sinfEp0016PrListSize = 0;
		int                       i                    = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx                  = getConnectionContext();
			sinfEp0016Info       = (Map<String, String>)param.get("sinfEp0016Info");
			sinfEp0016PrList     = (List<Map<String, String>>)param.get("sinfEp0016PrList");
			sinfEp0016PrListSize = sinfEp0016PrList.size();
            
            this.insert(ctx, "insertSinfep0016Info", sinfEp0016Info);
            
            for(i = 0; i < sinfEp0016PrListSize; i++){
            	sinfEp0016PrListInfo = sinfEp0016PrList.get(i);
            	
            	this.insert(ctx, "insertSinfep0016PrInfo", sinfEp0016PrListInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0016에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0016Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0016Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0017에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0017Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0017Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0017에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0017Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0017Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0018에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0018Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0018Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0018에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0018Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0018Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0019에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0019Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0019Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0019에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0019Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0019Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0019에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0019_1Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0019_1Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0020에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0020Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0020Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0020에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0020Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0020Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0037에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0037Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0037Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0037에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0037Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0037Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0021에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0021Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0021Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0021에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0021Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0021Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0022_2에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0022_2Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0022_2Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0022_2에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0022_2Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0022_2Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0022_2에 대한 파라미터 로그를 수정하는 메소드
	 * 그룸웨어 품의완료문서 연결완료후 GW정보 업데이트
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0022_2GwInfo(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0022_2GwInfo", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0024에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0024Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.insert(ctx, "insertSinfep0024Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0024에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0024Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0024Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * eps0029에 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0029(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx      = null;
		Map<String, String>       header   = null;
		Map<String, String>       listInfo = null;
		List<Map<String, String>> list     = null;
		int                       listSize = 0;
		int                       i        = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			header   = (Map<String, String>)param.get("header");
			list     = (List<Map<String, String>>)param.get("list");
            listSize = list.size();
            
            this.insert(ctx, "insertSinfep0029Info", header);
            
            for(i = 0 ; i < listSize; i++){
            	listInfo = list.get(i);
            	
            	this.insert(ctx, "insertSinfep0029PrInfo", listInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	/**
	 * eps0029에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0029Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0029Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	} 
	
	/**
	 * eps0030에 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut insertSinfep0030(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx      = null;
		Map<String, String>       header   = null;
		Map<String, String>       listInfo = null;
		List<Map<String, String>> list     = null;
		int                       listSize = 0;
		int                       i        = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			header   = (Map<String, String>)param.get("header");
			list     = (List<Map<String, String>>)param.get("list");
            listSize = list.size();
            
            this.insert(ctx, "insertSinfep0030Info", header);
            
            for(i = 0 ; i < listSize; i++){
            	listInfo = list.get(i);
            	
            	this.insert(ctx, "insertSinfep0030PrInfo", listInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	/**
	 * eps0030에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0030Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0030Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	} 
	
	/**
	 * gwapppr에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertGwappprInfo(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		List<Map<String, String>> list         = null;
		Map<String, String>       listInfo     = null;
		Map<String, String>       data         = null;
		Map<String, String>       gridDataInfo = null;
		String                    infNo        = null;
		String                    houseCode    = null;
		String                    prNo         = null;
		String                    prSeq        = null;
		String                    id           = info.getSession("ID");
		String                    kind         = null;
		int                       listSize     = 0;
		int                       i            = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)param.get("list");
			listSize = list.size();
			data     = (Map<String, String>)param.get("data");
						  
			this.insert(ctx, "insertGwappInfo", data);
            
			for(i = 0; i < listSize; i++){
				gridDataInfo = new HashMap<String, String>();
				
				listInfo = list.get(i);
				this.insert(ctx, "insertGwappprInfo",      listInfo);
				
				listInfo  = list.get(i);
				infNo     = listInfo.get("INF_NO");
				houseCode = listInfo.get("HOUSE_CODE");
				prNo      = listInfo.get("PR_NO");
				prSeq     = listInfo.get("PR_SEQ");
				kind      = listInfo.get("kind");
				gridDataInfo.put("GW_STATUS",      "T");
				gridDataInfo.put("GW_INF_NO",      infNo);
				gridDataInfo.put("HOUSE_CODE",     houseCode);
				gridDataInfo.put("PR_NO",          prNo);
				gridDataInfo.put("PR_SEQ",         prSeq);
				gridDataInfo.put("CHANGE_USER_ID", id);
				
				
				if (kind.equals("B")){
					this.update(ctx, "updateIcoyprdtGwStatus2", gridDataInfo);
				}else{
					this.update(ctx, "updateIcoyprdtGwStatus", gridDataInfo);
				}
				
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut insertGwappprInfo2(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		List<Map<String, String>> list         = null;
		Map<String, String>       listInfo     = null;
		Map<String, String>       data         = null;
		Map<String, String>       gridDataInfo = null;
		String                    infNo        = null;
		String                    houseCode    = null;
		String                    prNo         = null;
		String                    prSeq        = null;
		String                    kind        = null;
		String                    id           = info.getSession("ID");
		int                       listSize     = 0;
		int                       i            = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)param.get("list");
			listSize = list.size();
			data     = (Map<String, String>)param.get("data");
			
			this.insert(ctx, "insertGwappInfo2", data);
            
			for(i = 0; i < listSize; i++){
				gridDataInfo = new HashMap<String, String>();
				
				listInfo = list.get(i);
				
				this.insert(ctx, "insertGwappprInfo",      listInfo);
				
				listInfo  = list.get(i);
				infNo     = listInfo.get("INF_NO");
				houseCode = listInfo.get("HOUSE_CODE");
				prNo      = listInfo.get("PR_NO");
				prSeq     = listInfo.get("PR_SEQ");
				kind      = listInfo.get("kind");
				gridDataInfo.put("GW_STATUS",      "T");
				gridDataInfo.put("GW_INF_NO",      infNo);
				gridDataInfo.put("HOUSE_CODE",     houseCode);
				gridDataInfo.put("PR_NO",          prNo);
				gridDataInfo.put("PR_SEQ",         prSeq);
				gridDataInfo.put("CHANGE_USER_ID", id);
				
				if (kind.equals("B")){
					this.update(ctx, "updateIcoyprdtGwStatus2", gridDataInfo);
				}else{
					this.update(ctx, "updateIcoyprdtGwStatus", gridDataInfo);
				}
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	@SuppressWarnings("unchecked")
	// 그룹웨어 품의완료문서 연결
	public SepoaOut insertGwappprInfo3(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		List<Map<String, String>> list         = null;
		Map<String, String>       listInfo     = null;
		Map<String, String>       data         = null;
		Map<String, String>       gridDataInfo = null;
		String                    infNo        = null;
		String                    houseCode    = null;
		String                    prNo         = null;
		String                    prSeq        = null;
		String                    kind        = null;
		String                    id           = info.getSession("ID");
		int                       listSize     = 0;
		int                       i            = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)param.get("list");
			listSize = list.size();
			data     = (Map<String, String>)param.get("data");
			
//			if (kind.equals("B")){
//				this.insert(ctx, "insertGwappInfo2", data);
//			}else{
//				this.insert(ctx, "insertGwappInfo", data);
//			}
			
            
			for(i = 0; i < listSize; i++){
				gridDataInfo = new HashMap<String, String>();
				
				listInfo = list.get(i);
				
				this.insert(ctx, "insertGwappprInfo",      listInfo);
				
				listInfo  = list.get(i);
				infNo     = listInfo.get("INF_NO");
				houseCode = listInfo.get("HOUSE_CODE");
				prNo      = listInfo.get("PR_NO");
				prSeq     = listInfo.get("PR_SEQ");
				kind      = listInfo.get("kind");
				gridDataInfo.put("GW_STATUS",      "E");
				gridDataInfo.put("GW_INF_NO",      infNo);
				gridDataInfo.put("HOUSE_CODE",     houseCode);
				gridDataInfo.put("PR_NO",          prNo);
				gridDataInfo.put("PR_SEQ",         prSeq);
				gridDataInfo.put("CHANGE_USER_ID", id);
				
				if(i == 0){
					if (kind.equals("B")){
						this.insert(ctx, "insertGwappInfo2", data);
					}else{
						this.insert(ctx, "insertGwappInfo", data);
					}
				}
				
				
				if (kind.equals("B")){
					this.update(ctx, "updateIcoyprdtGwStatus2", gridDataInfo);
				}else{
					this.update(ctx, "updateIcoyprdtGwStatus", gridDataInfo);
				}
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}

	
	public SepoaOut updateIcoyprdtGwStatusList(Map<String, String> data) throws Exception{
        ConnectionContext ctx             = null;
        SepoaFormater     sf              = null;
        String            gwappTypeResult = null;
        String            gwappType       = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx             = getConnectionContext();
			gwappTypeResult = this.select(ctx, "selectGwappTypeInfo", data);
			
			sf = new SepoaFormater(gwappTypeResult);
			
			gwappType = sf.getValue("TYPE", 0);
			
			if("P".equals(gwappType)){
				this.update(ctx, "updateIcoyprdtGwStatusList", data);
			}
			else if("G".equals(gwappType)){
				this.update(ctx, "updateIcoyprdtGwStatusList2", data);
			}
			else{
				throw new Exception();
			}
			
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
	
	public SepoaOut updateIOList(Map<String, Object> data) throws Exception{
		Logger.err.println("=========================io========start=======================");
		ConnectionContext ctx             = null;
		SepoaFormater     sf              = null;
		Map<String, String>       header   = null;
		List<Map<String, String>> list     = null;
		Map<String, String>       listInfo = null;
		String qty_result = null;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx     = getConnectionContext();
			
			header	= (Map<String, String>)data.get("header");
			list    = (List<Map<String, String>>)data.get("list");
			
			String house_code = header.get("HOUSE_CDOE");
            String inf_no = header.get("INF_NO");
            String outxdate = header.get("OUTXDATE");
            String outxidnt = header.get("OUTXIDNT");
            String ref_inf_no = header.get("REF_INF_NO");
            
            
            Logger.err.println("list size??=================================="+list.size());
            Logger.err.println("header=================================="+header.toString());
            Logger.err.println("list=================================="+list.toString());
            for(int y = 0; y < list.size(); y++) {
            	list.get(y).put("HOUSE_CODE", house_code);
            	list.get(y).put("OUTXDATE", outxdate);
            	list.get(y).put("OUTXIDNT", outxidnt);
            	list.get(y).put("REF_INF_NO", ref_inf_no);
//            	list.get(y).putAll(header);
            }
            
            Logger.err.println("listInfo==========ok========================");
			for(int z = 0; z < list.size(); z++){
				listInfo = list.get(z);
				String mode = listInfo.get("INF_MODE");
				//취소물량 프로세스 추가
				//mode가 D가 들어오면 기존에 있는 출고수량을 select하여 그만큼을 제한다.
				String plus_qty = "";
				if("D".equals(mode)) {
					qty_result = this.select(ctx, "selectIOOqty", listInfo);
					sf = new SepoaFormater(qty_result);
					
					String req_o_qty = sf.getValue("REQ_O_QTY", 0);	//현재 출고수량
					plus_qty = listInfo.get("OUTXAMNT");		//요청수량
					
					String result_qty = String.valueOf(Double.parseDouble(req_o_qty) - Double.parseDouble(plus_qty));
					
					listInfo.put("OUTXAMNT", result_qty);
				}
				
				Logger.err.println("update==========start========================");
				this.update(ctx, "updateIOList", listInfo);
				
				if("D".equals(mode)) {					
					this.delPBHD(ctx, listInfo.get("HOUSE_CODE"), listInfo.get("BSDEPTCD"), listInfo.get("MLOBSMCD"), plus_qty);
				}else{
					if(!"0".equals(listInfo.get("OUTXAMNT"))){
						this.setPBHD(ctx, listInfo.get("HOUSE_CODE"), listInfo.get("BSDEPTCD"), listInfo.get("MLOBSMCD"), listInfo.get("OUTXAMNT"), listInfo.get("BSNDSEQT"));
					}										
				}
			}
			
			Commit();
		}
		catch(Exception e){
//			e.printStackTrace();
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	private int setPBHD(ConnectionContext ctx, String house_code,String dept, String itemNo, String grQty, String bsndSeqt)throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("dept", dept);
			data.put("item_no", itemNo);
			data.put("gr_qty", grQty);
			data.put("bsndSeqt", bsndSeqt);
			//부점의 소유품목 유무조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			SepoaFormater wf1 = new SepoaFormater(sm.doSelect(data));
				
			int i_cnt = Integer.parseInt(wf1.getValue("CNT", 0));
			
			if( i_cnt ==  0 ){			
				// 소유품목으로 인식
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				sm.doUpdate(data);
				rtn++;
			}
			else{
				// 소유품목 갱신
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				sm.doUpdate(data);
				rtn++;
			}
			
		} catch (Exception e) {
			throw new Exception("setPBHD : " + e.getMessage());
		} finally {
		}		
		
		return rtn;
	}
	
	private int delPBHD(ConnectionContext ctx, String house_code,String dept, String itemNo, String grQty)throws Exception {
		int rtn = 0;
		String user_id = info.getSession("ID");
		try {
			Map<String, String> data = new HashMap<String, String>();
			data.put("house_code", house_code);
			data.put("dept", dept);
			data.put("item_no", itemNo);
			data.put("gr_qty", grQty);
			//부점의 소유품목 유무조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
			SepoaFormater wf1 = new SepoaFormater(sm.doSelect(data));
				
			String STK_QTY = wf1.getValue("STK_QTY", 0);
			
			if( STK_QTY.equals(grQty) ){			
				// 소유품목으로 인식
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				sm.doUpdate(data);
				rtn++;
			}
			else{
				// 소유품목 갱신
				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
				sm = new SepoaSQLManager(user_id, this, ctx, wxp);
				sm.doUpdate(data);
				rtn++;
			}
			
		} catch (Exception e) {
			throw new Exception("setPBHD : " + e.getMessage());
		} finally {
		}		
		
		return rtn;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateIcommtglAbolList(Map<String, Object> header) throws Exception{
		ConnectionContext         ctx      = null;
		String                    id       = info.getSession("ID");
		SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> list     = null;
		Map<String, String>       listInfo = null;
        int                       result   = 0;
        int                       listSize = 0;
        int                       i        = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)header.get("list");
			listSize = list.size();
			
			for(i = 0; i < listSize; i++){
				listInfo = list.get(i);
				
				sxp = new SepoaXmlParser(this, "updateIcommtglAbolInfo");
				
				sxp.addVar("HOUSE_CODE",         listInfo.get("HOUSE_CODE"));
				sxp.addVar("ITEM_NO",            listInfo.get("ITEM_NO"));
				sxp.addVar("ABOL_RSN",           listInfo.get("ABOL_RSN"));
				sxp.addVar("ABOL_RSN_ETC",       listInfo.get("ABOL_RSN_ETC"));
				sxp.addVar("ABOL_DATE",          listInfo.get("ABOL_DATE"));
				sxp.addVar("ABOL_REQ_USER_ID",   listInfo.get("ABOL_REQ_USER_ID"));
				
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				
				result = ssm.doUpdate(listInfo);
				
				
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	/**
	 * <pre>
	 * 구매요청 테이블에 데이터를 삭제하는 메소드
	 * heder 구조
	 * 	HOUSE_CODE
	 * 	ITEM_NO
	 * </pre>
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut deleteIcommtglAbolList(Map<String, Object> header) throws Exception{
        ConnectionContext         ctx      = null;
        List<Map<String, String>> list     = null;
        Map<String, String>       listInfo = null;
        int                       result   = 0;
        int                       listSize = 0;
        int                       i        = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)header.get("list");
			listSize = list.size();
			
			for(i = 0; i < listSize; i++){
				listInfo = list.get(i);
				
				result = this.delete(ctx, "deleteIcommtglAbolInfo", listInfo);
			}
			
			if(result == 0){
				throw new Exception();
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	/**
	 * eps0031에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0031Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0031Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	
	/**
	 * eps0032에 대한 파라미터 로그를 등록하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut insertSinfep0032Info(Map<String, Object> param) throws Exception{
		ConnectionContext         ctx          = null;
		Map<String, String>       eps0032       = null;
		Map<String, String>       eps0032PrInfo = null;
		List<Map<String, String>> eps0032Pr     = null;
		int                       eps0032PrSize = 0;
		int                       i            = 0;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx          = getConnectionContext();
			eps0032       = (Map<String, String>)param.get("eps0032");
			eps0032Pr     = (List<Map<String, String>>)param.get("eps0032Pr");
			eps0032PrSize = eps0032Pr.size();
            
            this.insert(ctx, "insertSinfep0032Info", eps0032);
            
            for(i = 0; i < eps0032PrSize; i++){
            	eps0032PrInfo = eps0032Pr.get(i);
            	
            	this.insert(ctx, "insertSinfep0032PrInfo", eps0032PrInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	
	
	@SuppressWarnings("unchecked")
	public SepoaOut insertTbaif02List(Map<String, Object> header) throws Exception{
		ConnectionContext         ctx      = null;
		String                    id       = info.getSession("ID");
		String                    houseCode = info.getSession("HOUSE_CODE");
		SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> list     = null;
		Map<String, String>       listInfo = null;
							
		Map<String, String> dbParam        = new HashMap<String, String>();
		String                    selectResult   = null;		
		SepoaFormater             sepoaFormater  = null;		
		int                       rowCount       = 0;
		
		String item_no;
		String item_nm;
		String item_block_flag;
		String usedflag;
		String abol_rsn;
		
		
        int                       result   = 0;
        int                       listSize = 0;
        int                       i        = 0;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)header.get("list");
			listSize = list.size();
			
			for(i = 0; i < listSize; i++){
				listInfo = list.get(i);
				
				
				dbParam.put("ITEM_NO",     listInfo.get("MLOBSMCD"));				
				selectResult = this.select(ctx, "getTbaif02_2011Cnt", dbParam);				
				sepoaFormater = new SepoaFormater(selectResult);
				rowCount      = sepoaFormater.getRowCount();
				
				if(rowCount > 0){
					throw new Exception(listInfo.get("MLOBSMCD") + " 품목은 이미 일괄배부 된건입니다.");
				}
				
				
				dbParam.put("HOUSE_CODE",  houseCode);
				selectResult = this.select(ctx, "getIcommtglInfo", dbParam);				
				sepoaFormater = new SepoaFormater(selectResult);
				rowCount      = sepoaFormater.getRowCount();
				
				if(rowCount == 0){
					throw new Exception(listInfo.get("MLOBSMCD") + " 품목은 전자구매시스템에서 품목승인 대기상태입니다.");
				}
				
							
				item_no         = sepoaFormater.getValue("ITEM_NO",       0);
				item_nm         = sepoaFormater.getValue("DESCRIPTION_LOC",      0);
				item_block_flag = sepoaFormater.getValue("ITEM_BLOCK_FLAG", 0);
				usedflag        = sepoaFormater.getValue("USEDFLAG",   0);
				abol_rsn        = sepoaFormater.getValue("ABOL_RSN",      0);
			
				if("Y".equals(item_block_flag)){
					throw new Exception(item_nm + " 품목은 전자구매시스템에서 구매정지 상태입니다.");
				}
				
				if("N".equals(usedflag)){
					throw new Exception(item_nm + " 품목은 전자구매시스템에서 사용안함 상태입니다.");
				}
				
				if(!"N".equals(abol_rsn)){
					throw new Exception(item_nm + " 품목은 전자구매시스템에서 폐기 상태입니다.");
				}								
				
				sxp = new SepoaXmlParser(this, "insertTbaif02List");
				
				sxp.addVar("MLOBSMCD",            listInfo.get("MLOBSMCD"));
				sxp.addVar("OUTXSEQT",            listInfo.get("OUTXSEQT"));
				sxp.addVar("CENTERCD",            listInfo.get("CENTERCD"));
				sxp.addVar("OUTXAMNT",            listInfo.get("OUTXAMNT"));
				sxp.addVar("STATCODE",            listInfo.get("STATCODE"));
				sxp.addVar("OUTXDATE",            listInfo.get("OUTXDATE"));
				sxp.addVar("OUTXTIME",            listInfo.get("OUTXTIME"));
				sxp.addVar("OUTXIDNT",            listInfo.get("OUTXIDNT"));
				
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				
				result = ssm.doUpdate(listInfo);
				
				
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	
	
	
	/**
	 * eps0032에 대한 파라미터 로그를 수정하는 메소드
	 * 
	 * @param param
	 * @return SepoaOut
	 * @throws Exception
	 */
	public SepoaOut updateSinfep0032Info(Map<String, String> param) throws Exception{
		ConnectionContext ctx = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
            
            this.update(ctx, "updateSinfep0032Info", param);
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
	}
	
	/**
	 * <pre>
	 * 구매요청 테이블에 데이터를 삭제하는 메소드
	 * heder 구조
	 * 	HOUSE_CODE
	 * 	ITEM_NO
	 * </pre>
	 * 
	 * @param header
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut deleteTbaif02List(Map<String, Object> header) throws Exception{
        ConnectionContext         ctx      = null;
        List<Map<String, String>> list     = null;
        Map<String, String>       listInfo = null;
        int                       result1   = 0;
        int                       result2   = 0;
        int                       listSize = 0;
        int                       i        = 0;
        
        String                    id       = info.getSession("ID");
		String                    houseCode = info.getSession("HOUSE_CODE");
		Map<String, String> dbParam        = new HashMap<String, String>();
		String                    selectResult   = null;		
		SepoaFormater             sepoaFormater  = null;		
		int                       rowCount       = 0;
		
		String outxdate;
		String outxidnt;
		String statcode;
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx      = getConnectionContext();
			list     = (List<Map<String, String>>)header.get("list");
			listSize = list.size();
			
			for(i = 0; i < listSize; i++){
				listInfo = list.get(i);
				
				dbParam.put("MLOBSMCD",     listInfo.get("MLOBSMCD"));				
				dbParam.put("OUTXSEQT",     listInfo.get("OUTXSEQT"));				
				dbParam.put("OUTXDATE",     listInfo.get("OUTXDATE"));				
				dbParam.put("OUTXIDNT",     listInfo.get("OUTXIDNT"));				
				selectResult = this.select(ctx, "getTbaif02Info", dbParam);				
				sepoaFormater = new SepoaFormater(selectResult);
				rowCount      = sepoaFormater.getRowCount();
				
				if(rowCount == 0){
					throw new Exception(listInfo.get("MLOBSMCD") + " 품목은 일괄배부된 품목이 아닙니다.");
				}
							
				statcode         = sepoaFormater.getValue("STATCODE",      0);
				outxdate         = sepoaFormater.getValue("OUTXDATE",      0);
				outxidnt         = sepoaFormater.getValue("OUTXIDNT",      0);
				
				if(!"2011".equals(statcode)){
					throw new Exception(listInfo.get("MLOBSMCD") + " 품목 - 이미 일괄배부취소 된 건입니다.");
				}
				
//				if(!listInfo.get("OUTXDATE").equals(outxdate)){
//					throw new Exception(listInfo.get("MLOBSMCD") + " 품목 - 당일 일괄배부건만 취소가 가능합니다.");
//				}
				
				if(!listInfo.get("OUTXIDNT").equals(outxidnt)){
					throw new Exception(listInfo.get("MLOBSMCD") + " 품목 - 일괄배부 실행자만 취소가 가능합니다.");
				}
				
				result1 = this.delete(ctx, "deleteTbaif02List", listInfo);
				
				result2 = this.delete(ctx, "deleteIcoyPbhdList", listInfo);
			}
			
			if(result1 < 0 || result2 < 0){
				throw new Exception();
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(e.getMessage());
		}

		return getSepoaOut();
    }
	


	
	

	  /* TOBE 2017-07-01 추가 EPS0033 재산관리 입지대사 */
	  
		/**
		 * eps0033에 대한 파라미터 로그를 등록하는 메소드
		 * 
		 * @param param
		 * @return SepoaOut
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		public SepoaOut insertSinfep0033Info(Map<String, Object> param) throws Exception{
			ConnectionContext         ctx                  = null;
			Map<String, String>       sinfEp0033Info       = null;
			Map<String, String>       sinfEp0033PrListInfo = null;
			List<Map<String, String>> sinfEp0033PrList     = null;
			int                       sinfEp0033PrListSize = 0;
			int                       i                    = 0;
	        
			try {
				setStatus(1);
				setFlag(true);
				
				ctx                  = getConnectionContext();
				sinfEp0033Info       = (Map<String, String>)param.get("sinfEp0033Info");
				sinfEp0033PrList     = (List<Map<String, String>>)param.get("sinfEp0033PrList");
				sinfEp0033PrListSize = sinfEp0033PrList.size();
	            
	            this.insert(ctx, "insertSinfep0033Info", sinfEp0033Info);
	            
	            for(i = 0; i < sinfEp0033PrListSize; i++){
	            	sinfEp0033PrListInfo = sinfEp0033PrList.get(i);
	            	
	            	this.insert(ctx, "insertSinfep0033PrInfo", sinfEp0033PrListInfo);
	            }
				
				Commit();
			}
			catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(e.getMessage());
			}

			return getSepoaOut();
		}
		
		/**
		 * eps0033에 대한 파라미터 로그를 수정하는 메소드
		 * 
		 * @param param
		 * @return SepoaOut
		 * @throws Exception
		 */
		public SepoaOut updateSinfep0033Info(Map<String, String> param) throws Exception{
			ConnectionContext ctx = null;
	        
			try {
				setStatus(1);
				setFlag(true);
				
				ctx = getConnectionContext();
	            
	            this.update(ctx, "updateSinfep0033Info", param);
				
				Commit();
			}
			catch(Exception e){
				Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(e.getMessage());
			}

			return getSepoaOut();
		}
		

	
}