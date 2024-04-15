package sepoa.svc.procure;

import java.util.ArrayList;
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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaStringTokenizer;

public class DV_003 extends SepoaService {

    public DV_003(String opt, SepoaInfo info) throws SepoaServiceException {
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

    public SepoaOut getPoCreateInfo_2(String po_no) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("po_no", po_no);
			
			sxp = new SepoaXmlParser(this, "sel_getPoCreateInfo_2");
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
	
    

	public SepoaOut getPoDetailHeader(String po_no) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("po_no", po_no);
			
			sxp = new SepoaXmlParser(this, "getPoDetailHeader");
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
	
	
	public SepoaOut getPoCreateInfo(Map<String, Object> data) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			
			sxp = new SepoaXmlParser(this, "getPoCreateInfo");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header));

		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	 public SepoaOut setPoConfirm(Map<String, Object> data) throws Exception{
	    	setStatus(1);
			setFlag(true);
			ConnectionContext ctx = getConnectionContext();
			int rtn=0;
			SepoaXmlParser sxp = null;
			SepoaSQLManager ssm = null;
			SepoaFormater sf = null;
			Message msg = null;
			List<Map<String, String>> grid     = null;
			Map<String, String>       gridInfo = null;
		
			
		
	    	try{
	    		msg = new Message(info, "DV_003");
				
				Map<String, String> header = MapUtils.getMap(data, "headerData");
				sxp = new SepoaXmlParser(this, "setPoConfirm");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				ssm.doUpdate(header);

				//DT의 납품예정일 추가 프로세스(2015.02.21 next1210)
				String po_no = header.get("po_no");	//그리드데이터는 Po번호가 없기 때문에 header에서 빼내 변수로 가지고 있는다.
				
				grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");	//grid라는 리스트를 만들어 그리드데이터를 받는다.
				
				//for문을 그리드리스트사이즈만큼 돌린다.
				for(int i = 0; i < grid.size(); i++) {
					//for문을 돌리며 gridinfo에 맵형식으로 담는다.
					gridInfo = grid.get(i);
					
					//아까전에 header에서 빼낸 po번호를 gridinfo 맵에 추가시킨다.
					gridInfo.put("po_no", po_no);
					
					//update문을 돌린다.
					sxp = new SepoaXmlParser(this, "setPoConfirm_detail");
	                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	                ssm.doUpdate(gridInfo);
					
				}
	    		
	    		Commit();
	    	} catch ( Exception e ) {

	    		Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());

	    	}
	    	return getSepoaOut();
	  	}
	 

	 public SepoaOut setPoReject(Map<String, Object> data) throws Exception{
	    	setStatus(1);
			setFlag(true);
			ConnectionContext ctx = getConnectionContext();
			int rtn=0;
			SepoaXmlParser sxp = null;
			SepoaSQLManager ssm = null;
			SepoaFormater sf = null;
			Message msg = null;
		
			
		
	    	try{
	    		msg = new Message(info, "DV_003");
				
				Map<String, String> header = MapUtils.getMap(data, "headerData");
				
				
				
	    		sxp = new SepoaXmlParser(this, "setPoReject");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				ssm.doUpdate(header);
						
	    		

	    		
	    		Commit();
	    	} catch ( Exception e ) {

	    		Rollback();
				setStatus(0);
				setFlag(false);
				setMessage(e.getMessage());
				Logger.err.println(info.getSession("ID"), this, e.getMessage());

	    	}
	    	return getSepoaOut();
	  	}
	
	
}