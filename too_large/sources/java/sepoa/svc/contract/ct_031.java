package sepoa.svc.contract;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDataMapper;

@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
public class CT_031 extends SepoaService {

	private String ID = info.getSession("ID");
	private HashMap msg = null;

	public CT_031(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
		try {
			msg = MessageUtil.getMessageMap(info, "CT_006");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
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

	public SepoaOut getStockHeaderList(HashMap<String, String> headerData) {

		ConnectionContext ctx = getConnectionContext();

		try {
			setStatus(1);
			setFlag(true);
			SepoaXmlParser sxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, sxp);
			setValue(ssm.doSelect(headerData));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	

	public SepoaOut getStockList(Map<String, Object> allData) {

		ConnectionContext ctx = getConnectionContext();

		Map headerData = MapUtils.getMap(allData,
				SepoaDataMapper.KEY_HEADER_DATA, null);
		try {
			setStatus(1);
			setFlag(true);
			SepoaXmlParser sxp = new SepoaXmlParser(this,
					new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"),
					this, ctx, sxp);
			setValue(ssm.doSelect(headerData));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}

}
