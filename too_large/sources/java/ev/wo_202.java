package ev;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class WO_202 extends SepoaService {
	private Message msg;

    public WO_202(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info,"p10_pra");
    }

	public String getConfig(String s){
	    try{
	        Configuration configuration = new Configuration();
	        
	        s = configuration.get(s);
	        
	        return s;
	    }
	    catch(ConfigurationException configurationexception){
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage());
	    }
	    catch(Exception exception){
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	    }
	    
	    return null;
	}

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

	@SuppressWarnings("unused")
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
	
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	private Map<String, Integer> evQeurySelectQueryCntYear(ConnectionContext connectionContext) throws Exception{
		Map<String, Integer> result        = new HashMap<String, Integer>();
		String               rtn           = null;
		String               cnt           = null;
		String               year          = null;
		SepoaFormater        sepoaFormater = null;
		int                  cntInt        = 0;
		int                  yearInt       = 0;
		
		rtn = this.select(connectionContext, "selectQueryCntYear", new HashMap<String, String>());
		
		sepoaFormater = new SepoaFormater(rtn);
		
		cnt     = sepoaFormater.getValue("CNT",  0);
		year    = sepoaFormater.getValue("YEAR", 0);
		cntInt  = Integer.parseInt(cnt);
		yearInt = Integer.parseInt(year);
		
		result.put("cntInt",  cntInt);
		result.put("yearInt", yearInt);
		
		return result;
	}
	
	private void evQeuryInsertQueryScode(ConnectionContext connectionContext, Map<String, Integer> queryCntYear) throws Exception{
		String               year           = null;
		String               id             = null;
		String               curDate        = null;
		String               curDateYear    = null;
		Map<String, String>  daoParam       = null;
		int                  cntInt         = 0;
		int                  yearInt        = 0;
		int                  curDateYearInt = 0;
		
		cntInt         = queryCntYear.get("cntInt");
		yearInt        = queryCntYear.get("yearInt");
		year           = Integer.toString(yearInt);
		curDate        = SepoaDate.getShortDateString();
		curDateYear    = curDate.substring(0,4);
		curDateYearInt = Integer.parseInt(curDateYear);
		id             = info.getSession("ID");
		
		if((cntInt > 0) && (yearInt < curDateYearInt)){
			daoParam = new HashMap<String, String>();
			
			daoParam.put("ADD_USER_ID", id);
			daoParam.put("ADD_DATE",    year);
			
			this.insert(connectionContext, "insertQueryScode", daoParam);
		}
	}
	
	private String evQuerySelectQueryList(ConnectionContext connectionContext, Map<String, String> param) throws Exception{
		String              result      = null;
		String              pEvGubun    = param.get("p_ev_gubun");
		String              pUseYn      = param.get("p_use_yn");
		String              curDate     = null;
		String              curDateYear = null;
		Map<String, String> daoParam    = new HashMap<String, String>();
		
		curDate        = SepoaDate.getShortDateString();
		curDateYear    = curDate.substring(0,4);
		
		daoParam.put("p_ev_gubun", pEvGubun);
		daoParam.put("ADD_DATE",   curDateYear);
		daoParam.put("p_use_yn",   pUseYn);
		
		result = this.select(connectionContext, "selectQeuryList", daoParam);
		
		return result;
	}

	public SepoaOut ev_query(Map<String, String> param) throws Exception{
		ConnectionContext    connectionContext = null;
		String               rtn               = null;
		Map<String, Integer> queryCntYear      = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			connectionContext = getConnectionContext();
			queryCntYear      = this.evQeurySelectQueryCntYear(connectionContext);
			
			this.evQeuryInsertQueryScode(connectionContext, queryCntYear);
			
			rtn = this.evQuerySelectQueryList(connectionContext, param);
			
			Commit();
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Rollback();
			
			setStatus(0);
			setFlag(false);
			setMessage(msg.getMessage("0001"));
			
			this.loggerExceptionStackTrace(e);
		}
		
		return getSepoaOut();
	}
	
	private void evInsertUpdate(ConnectionContext ctx, Map<String, String> header, Map<String, String> gridInfo) throws Exception{
		Map<String, String> daoParam = new HashMap<String, String>();
		String              useFlag  = gridInfo.get("USE_FLAG");
		String              text1    = gridInfo.get("TEXT1");
		String              code     = gridInfo.get("CODE");
		String              addDate  = gridInfo.get("ADD_DATE");
		String              type     = header.get("TYPE");
		
		daoParam.put("USE_FLAG", useFlag);
		daoParam.put("TEXT1",    text1);
		daoParam.put("TYPE",     type);
		daoParam.put("CODE",     code);
		daoParam.put("ADD_DATE", addDate);

		this.update(ctx, "updateScodeInfo", daoParam);
	}
	
	private void evInsertInsert(ConnectionContext ctx, Map<String, String> header, Map<String, String> gridInfo) throws Exception{
		Map<String, String> daoParam  = new HashMap<String, String>();
		String              type      = header.get("TYPE");
		String              id        = info.getSession("ID");
		String              houseCode = info.getSession("HOUSE_CODE");
		String              useFlag   = gridInfo.get("USE_FLAG");
		String              text1     = gridInfo.get("TEXT1");
		
		daoParam.put("TYPE",        type);
		daoParam.put("ADD_USER_ID", id);
		daoParam.put("USE_FLAG",    useFlag);
		daoParam.put("TEXT1",       text1);
		daoParam.put("HOUSE_CODE",  houseCode);
		
		this.insert(ctx, "insertScodeInfo", daoParam);
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut ev_insert(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
		Map<String, String>       header   = null;
		String                    code     = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx    = getConnectionContext();
			header = (Map<String, String>)data.get("header");
			grid   = (List<Map<String, String>>)data.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				code     = gridInfo.get("CODE");
                
				if("".equals(code) == false){
					this.evInsertUpdate(ctx, header, gridInfo);
				}
				else{
					this.evInsertInsert(ctx, header, gridInfo);
				}
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			
			this.loggerExceptionStackTrace(e);
		}

		return getSepoaOut();
    }
	
	private void evDeleteSelectSevlnCnt(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
		Map<String, String> daoParam      = new HashMap<String, String>();
		String              rtn           = null;
		String              cnt           = null;
		String              type          = gridInfo.get("TYPE");
		String              code          = gridInfo.get("CODE");
		SepoaFormater       sepoaFormater = null;
		
		daoParam.put("EV_M_ITEM", type);
		daoParam.put("EV_D_ITEM", code);
		
		rtn = this.select(ctx, "selectSevlnCnt", daoParam);
		
		sepoaFormater = new SepoaFormater(rtn);
		
		cnt = sepoaFormater.getValue("CNT", 0);
		
		if("0".equals(cnt) == false){
			throw new Exception("심사표로 등록이 되어있는 항목은 삭제할 수 없습니다.");
		}
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut ev_delete(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			grid = (List<Map<String, String>>)data.get("gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
				this.evDeleteSelectSevlnCnt(ctx, gridInfo);
				this.update(ctx, "deleteScodeInfo", gridInfo);
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			
			this.loggerExceptionStackTrace(e);
		}

		return getSepoaOut();
    }
}