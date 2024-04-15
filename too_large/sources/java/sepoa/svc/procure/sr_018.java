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

public class SR_018 extends SepoaService {

    public SR_018(String opt, SepoaInfo info) throws SepoaServiceException {
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
    
	public SepoaOut getTempDetail(String e_template_refitem) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("e_template_refitem", e_template_refitem);
		
			sxp =  new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
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
	
	
	public SepoaOut getEvaDetail() {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			HashMap<String, String> no = new HashMap<String, String>();
			
		
			sxp =  new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
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
	
	
	
	
	public SepoaOut setTempInsert(Map<String, Object> data) throws Exception{

  		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
    	int rtnIns = 0;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		Message msg = null;
		double currVal = getCurrVal("icomveth", "e_template_refitem");
		String rtn= "";
		setMessage("성공");
		try {
			msg = new Message(info, "SR_010");
			
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			
			
			header.put("e_template_refitem", String.valueOf(currVal));
			
			SepoaStringTokenizer ts = new SepoaStringTokenizer(header.get("factor_param"),",");
			SepoaStringTokenizer as = new SepoaStringTokenizer(header.get("weight_param"),",");
			
			int row_cnt = ts.countTokens();
			
			
			List<Map<String, String>> list = new ArrayList<Map<String,String>>(); 
			
			
			for(int i=0; i<row_cnt; i++){
				Map<String, String> customheader = new HashMap<String, String>();
				
				customheader.put("e_template_refitem", header.get("e_template_refitem"));
				
				customheader.put("weight", as.nextToken());
				customheader.put("e_factor_refitem", ts.nextToken());
				
				
				
				list.add(customheader);
			}
			
			
			
			
			
			
		
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doInsert(header);
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doInsert(list);
					
			
			Commit();
			
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally {
		}

		return getSepoaOut();
  	}
  	
    
    public SepoaOut setTempUpdate(Map<String, Object> data) throws Exception{
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		int rtn=0;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		Message msg = null;
	
		setMessage("성공");
	
    	try{
    		msg = new Message(info, "SR_018");
			
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			
			SepoaStringTokenizer ts = new SepoaStringTokenizer(header.get("factor_param"),",");
			SepoaStringTokenizer as = new SepoaStringTokenizer(header.get("weight_param"),",");
			
			int row_cnt = ts.countTokens();
			
			List<Map<String, String>> list = new ArrayList<Map<String,String>>(); 
			for(int i=0; i<row_cnt; i++){
				Map<String, String> customheader = new HashMap<String, String>();
				
				customheader.put("e_template_refitem", header.get("e_template_refitem"));
				customheader.put("weight", as.nextToken());
				customheader.put("e_factor_refitem", ts.nextToken());
				list.add(customheader);
				
				
			}
			
    		sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doUpdate(header);
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doUpdate(list);
    		
    		

    		
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
	
	
    public double getCurrVal(String tableName, String columnName){
    	double currVal = 0;
  	    SepoaOut wo = currvalForMssql(tableName, columnName);
  	    try{
	  	    SepoaFormater wf2 = new SepoaFormater(wo.result[0]);
	  	    currVal = Double.parseDouble((wf2.getValue("CURRVAL",0)));
  	    } catch(Exception e){
  	    	currVal = 0;
  	    }
    	return currVal;
    }   
    
    public SepoaOut currvalForMssql(String tableName, String columnName){

        try{
             String rtn = "";
     		ConnectionContext ctx = getConnectionContext();
     		SepoaXmlParser sxp = null;
			SepoaSQLManager ssm = null;
     		String house_code = info.getSession("HOUSE_CODE");
     		String user_id = info.getSession("ID");
     		Map<String, String> header = new HashMap<String, String>();
     		
     		header.put("tableName",tableName);
     		header.put("columnName",columnName);
     		sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			
			

 			
 			rtn = ssm.doSelect(header);
     	
             setValue(rtn);
             setStatus(1);

         } catch(Exception e) {

             Logger.err.println("Exception e =" + e.getMessage());
             setStatus(0);
             Logger.err.println(this,e.getMessage());
         }
         return getSepoaOut();
     }
    
    


	public SepoaOut chkUpdateEvaTemp(String e_template_refitem) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("e_template_refitem", e_template_refitem);
		
			sxp =  new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
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
	
	
	
}