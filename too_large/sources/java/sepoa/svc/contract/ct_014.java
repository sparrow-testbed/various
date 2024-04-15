package sepoa.svc.contract;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils ;

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
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class CT_014 extends SepoaService {

	private String ID = info.getSession("ID");
	private Message msg;

	public CT_014(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
		msg = new Message(info, "PU_005_BEAN");
	}

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
	
	//계약생성현황조회
	public SepoaOut getCreateList(Map<String, Object> data){

		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> header = MapUtils.getMap(data, "headerData");
		Map<String, String> customHeader =  new HashMap<String, String>();	
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			customHeader.put("company_code"  , info.getSession("COMPANY_CODE"));
			customHeader.put("language"      , info.getSession("LANGUAGE"));
			customHeader.put("from_cont_date", SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "from_cont_date", "") ) );
			customHeader.put("to_cont_date"  , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "to_cont_date", "") ) );
			
			sxp = new SepoaXmlParser(this, "getCreateList");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	setValue(ssm.doSelect(header,customHeader));
		} 
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	

 	public SepoaOut setDelete(Map<String, Object> data) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String> header = MapUtils.getMap(data, "headerData");

        	sxp = new SepoaXmlParser(this, "setDelete");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doUpdate(grid);
        	Commit();
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setStatus(0);
		}

		return getSepoaOut();
	}
}	