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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import wise.util.WiseApproval;
import wisecommon.SignResponseInfo;


public class AP_008 extends SepoaService{
	
    public AP_008(String opt,SepoaInfo info) throws SepoaServiceException
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
    
    
	public SepoaOut getReportList(Map<String, Object> data)
	{
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			header.put("from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "from_date", "")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "to_date", "")));
			header.put("sign_from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "sign_from_date", "")));
			header.put("sign_to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "sign_to_date", "")));
			
			
			
			sxp = new SepoaXmlParser(this, "getReportList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header));
		}catch(Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();

	}
	
	public SepoaOut setReportCancel(Map<String, Object> data) throws Exception {
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
			
			sxp = new SepoaXmlParser(this, "setReportCancel_1"); 
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn = ssm.doDelete(grid, true);
			
			sxp = new SepoaXmlParser(this, "setReportCancel_2"); 
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
			sri.setSignStatus("D");
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
}