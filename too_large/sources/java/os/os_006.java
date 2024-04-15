package os;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.oreilly.servlet.multipart.ExceededSizeException;

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

public class os_006 extends SepoaService {
	private Message msg;

    public os_006(String opt, SepoaInfo info) throws SepoaServiceException {
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
	
	public SepoaOut selectSoList(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "selectSoList");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(header);
			
			setValue(rtn);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		
		return getSepoaOut();
	}
	
	private int updateCompleteUpdateSosglInfo(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
//		String          id  = info.getSession("ID");
//		SepoaXmlParser  sxp = new SepoaXmlParser(this, "updateSosglInfo");
//		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
//		
//        ssm.doUpdate(gridInfo);
                
        SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "updateSosglInfo");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doUpdate(gridInfo);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
	}
	
	private int updateCompleteUpdateSoslnInfo(ConnectionContext ctx, Map<String, String> gridInfo, Map<String, String> prhd_data) throws Exception{
		
		Map<String, String> result = new HashMap<String, String>();
    	
        result.put("HOUSE_CODE",         			gridInfo.get("HOUSE_CODE"));
        result.put("OSQ_NO",         					gridInfo.get("OSQ_NO"));
        result.put("OSQ_COUNT",         			gridInfo.get("OSQ_COUNT"));
        result.put("PR_NO",         		            prhd_data.get("PR_NO"));
		

		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "updateSoslnInfo");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doUpdate(result);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
	}
	
	private int updateCompleteupdateSorglUpdate(ConnectionContext ctx, Map<String, String> gridInfo, Map<String, String> prhd_data) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
    	
        result.put("HOUSE_CODE",         			gridInfo.get("HOUSE_CODE"));
        result.put("OSQ_NO",         					gridInfo.get("OSQ_NO"));
        result.put("OSQ_COUNT",         			gridInfo.get("OSQ_COUNT"));
        result.put("PR_NO",         		            prhd_data.get("PR_NO"));
		      
        SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "updateSorglUpdate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doUpdate(result);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
	}
	
	private int updateCompleteupdateSorlnUpdate(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
//		String          id  = info.getSession("ID");
//		SepoaXmlParser  sxp = new SepoaXmlParser(this, "updateSorlnUpdate");
//		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
//		
//        ssm.doUpdate(gridInfo);
        
        SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "updateSorlnUpdate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doUpdate(gridInfo);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
	}
	
	private List<Map<String, String>> select_orgl_vendor(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		SepoaXmlParser            sxp        = null;
		SepoaSQLManager           ssm        = null;
		SepoaFormater             sf         = null;
		String                    id         = info.getSession("ID");
		String                    rtn        = null;
		String                    osqNo      = null;
		String                    osqSeq     = null;
		String                    osqCount   = null;
		String                    houseCode  = null;
		Map<String, String>       resultInfo = null;
		int                       rowCount   = 0;
		int                       i          = 0;
		
		sxp = new SepoaXmlParser(this, "select_orgl_vendor");
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		rtn = ssm.doSelect(gridInfo);
		
		sf = new SepoaFormater(rtn);
		
		rowCount = sf.getRowCount();
		
		for(i = 0; i < rowCount; i++){
			resultInfo = new HashMap<String, String>();
			
			resultInfo.put("PO_VENDOR",     sf.getValue("VENDOR_CODE", i));
			resultInfo.put("CHANGE_USER_ID", id);
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	private List<Map<String, String>> updateCompleteSelectSoslnList(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		SepoaXmlParser            sxp        = null;
		SepoaSQLManager           ssm        = null;
		SepoaFormater             sf         = null;
		String                    id         = info.getSession("ID");
		String                    rtn        = null;
		String                    osqNo      = null;
		String                    osqSeq     = null;
		String                    osqCount   = null;
		String                    houseCode  = null;
		Map<String, String>       resultInfo = null;
		int                       rowCount   = 0;
		int                       i          = 0;
		
		sxp = new SepoaXmlParser(this, "selectSoslnList");
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        rtn = ssm.doSelect(gridInfo);
        
        sf = new SepoaFormater(rtn);
        
        rowCount = sf.getRowCount();
        
        for(i = 0; i < rowCount; i++){
        	resultInfo = new HashMap<String, String>();
        	
        	osqNo     = sf.getValue("OSQ_NO",     i);
        	osqCount  = sf.getValue("OSQ_COUNT",  i);
        	osqSeq    = sf.getValue("OSQ_SEQ",    i);
        	houseCode = sf.getValue("HOUSE_CODE", i);
        	
        	resultInfo.put("OSQ_NO",         osqNo);
        	resultInfo.put("OSQ_COUNT",      osqCount);
        	resultInfo.put("OSQ_SEQ",        osqSeq);
        	resultInfo.put("HOUSE_CODE",     houseCode);
        	resultInfo.put("CHANGE_USER_ID", id);
        	
        	result.add(resultInfo);
        }
        
		return result;
	}
	
	private void updateCompleteUpdateComplete(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
		String          id  = info.getSession("ID");
		SepoaXmlParser  sxp = new SepoaXmlParser(this, "updateComplete");
		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
        ssm.doUpdate(gridInfo);
	}
	
	private int update_prdt_flag(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
//		String          id  = info.getSession("ID");
//		SepoaXmlParser  sxp = new SepoaXmlParser(this, "update_prdt_flag");
//		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
//		
//		ssm.doUpdate(gridInfo);
		
		
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "update_prdt_flag");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doUpdate(gridInfo);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
	}
	
	private int update_prhd(ConnectionContext ctx, Map<String, String> gridInfo) throws Exception{
//		String          id  = info.getSession("ID");
//		SepoaXmlParser  sxp = new SepoaXmlParser(this, "update_prhd");
//		SepoaSQLManager ssm = new SepoaSQLManager(id, this, ctx, sxp);
//		
//		
//		
//		ssm.doUpdate(gridInfo);
		
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "update_prhd");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doUpdate(gridInfo);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
	}
	
	
	
	// icoyprhd 업데이트 정보
	private Map<String, String> setting_prhd_data(SepoaFormater sf_2, SepoaFormater sf) throws Exception{
    	Map<String, String> result = new HashMap<String, String>();
    	    	
        result.put("HOUSE_CODE",         			sf_2.getValue("HOUSE_CODE", 0));
        result.put("PR_NO",         					sf_2.getValue("PR_NO", 0));
        result.put("STATUS",         				sf_2.getValue("STATUS", 0));
        result.put("COMPANY_CODE",         		sf_2.getValue("COMPANY_CODE", 0));
        result.put("PLANT_CODE",         			sf_2.getValue("PLANT_CODE", 0));
//        result.put("PR_TOT_AMT",         			sf_2.getValue("PR_TOT_AMT", 0));
        result.put("PR_TOT_AMT",         			sf.getValue("TTL_AMT",0));
        result.put("PR_TYPE",         				sf_2.getValue("PR_TYPE", 0));
        result.put("DEMAND_DEPT",         		sf_2.getValue("DEMAND_DEPT", 0));
        result.put("SIGN_STATUS",         		sf_2.getValue("SIGN_STATUS", 0));
        result.put("SIGN_DATE",         			sf_2.getValue("SIGN_DATE", 0));
        result.put("SIGN_PERSON_ID",         	sf_2.getValue("SIGN_PERSON_ID", 0));
        result.put("DEMAND_DEPT_NAME",      	sf_2.getValue("DEMAND_DEPT_NAME", 0));
        result.put("SIGN_PERSON_NAME",       	sf_2.getValue("SIGN_PERSON_NAME", 0));
        result.put("TEL_NO",         				sf_2.getValue("TEL_NO", 0));
        result.put("REMARK",         				sf_2.getValue("REMARK", 0));
        result.put("SUBJECT",         				sf_2.getValue("SUBJECT", 0));
        result.put("PR_LOCATION",         		sf_2.getValue("PR_LOCATION", 0));
        result.put("CTRL_DEPT",         			sf_2.getValue("CTRL_DEPT", 0));
        result.put("CTRL_FLAG",         			sf_2.getValue("CTRL_FLAG", 0));
        result.put("CTRL_DATE",         			sf_2.getValue("CTRL_DATE", 0));
        result.put("CTRL_PERSON_ID",         	sf_2.getValue("CTRL_PERSON_ID", 0));
        result.put("CTRL_REASON",         		sf_2.getValue("CTRL_REASON", 0));
        result.put("CTRL_DEPT_NAME",         	sf_2.getValue("CTRL_DEPT_NAME", 0));
        result.put("CTRL_PERSON_NAME",      	sf_2.getValue("CTRL_PERSON_NAME", 0));
        result.put("RECEIVE_TERM",         		sf_2.getValue("RECEIVE_TERM", 0));
        result.put("ORDER_NO",         			sf_2.getValue("ORDER_NO", 0));
        result.put("SALES_USER_DEPT",         	sf_2.getValue("SALES_USER_DEPT", 0));
        result.put("SALES_USER_ID",         		sf_2.getValue("SALES_USER_ID", 0));
        result.put("CONTRACT_HOPE_DAY",    	sf_2.getValue("CONTRACT_HOPE_DAY", 0));
        result.put("TAKE_USER_NAME",         	sf_2.getValue("TAKE_USER_NAME", 0));
        result.put("TAKE_TEL",         				sf_2.getValue("TAKE_TEL", 0));
        result.put("REC_REASON",         			sf_2.getValue("REC_REASON", 0));
        result.put("AHEAD_FLAG",         			sf_2.getValue("AHEAD_FLAG", 0));
        result.put("CONTRACT_FROM_DATE",  	sf_2.getValue("CONTRACT_FROM_DATE", 0));
        result.put("CONTRACT_TO_DATE",      	sf_2.getValue("CONTRACT_TO_DATE", 0));
        result.put("SHIPPER_TYPE",         		sf_2.getValue("SHIPPER_TYPE", 0));
        result.put("MAINTENANCE_TERM",      	sf_2.getValue("MAINTENANCE_TERM", 0));
        result.put("DELY_TO_CONDITION",      	sf_2.getValue("DELY_TO_CONDITION", 0));
        result.put("COMPUTE_REASON",         	sf_2.getValue("COMPUTE_REASON", 0));
        result.put("CUST_CODE",        	 		sf_2.getValue("CUST_CODE", 0));
        result.put("SALES_AMT",         			sf_2.getValue("SALES_AMT", 0));
        result.put("SALES_TYPE",        	 		sf_2.getValue("SALES_TYPE", 0));
        result.put("ORDER_NAME",         			sf_2.getValue("ORDER_NAME", 0));
        result.put("REQ_TYPE",         				sf_2.getValue("REQ_TYPE", 0));
        result.put("RETURN_HOPE_DAY",         	sf_2.getValue("RETURN_HOPE_DAY", 0));
        result.put("HARD_MAINTANCE_TERM",	sf_2.getValue("HARD_MAINTANCE_TERM", 0));
        result.put("SOFT_MAINTANCE_TERM", 	sf_2.getValue("SOFT_MAINTANCE_TERM", 0));
        result.put("ATTACH_NO",         			sf_2.getValue("ATTACH_NO", 0));
        result.put("CREATE_TYPE",         		sf_2.getValue("CREATE_TYPE", 0));
        result.put("EXPECT_AMT",         			sf_2.getValue("EXPECT_AMT", 0));
        result.put("BID_PR_NO",         			sf_2.getValue("BID_PR_NO", 0));
        result.put("CUST_NAME",         			sf_2.getValue("CUST_NAME", 0));
        result.put("PROJECT_FLAGCHAR",       	sf_2.getValue("PROJECT_FLAGCHAR", 0));
        result.put("ORDER_POSSIBLE_AMT",    	sf_2.getValue("ORDER_POSSIBLE_AMT", 0));
        result.put("USAGE",         					sf_2.getValue("USAGE", 0));
        result.put("DELIVERY_PLACE",         	sf_2.getValue("DELIVERY_PLACE", 0));
        result.put("DELIVERY_PLACE_INFO",    	sf_2.getValue("DELIVERY_PLACE_INFO", 0));
        result.put("PROJECT_DEPT",         		sf_2.getValue("PROJECT_DEPT", 0));
        result.put("PROJECT_PM",         			sf_2.getValue("PROJECT_PM", 0));
        result.put("BSART",         					sf_2.getValue("BSART", 0));
        result.put("CUST_TYPE",         			sf_2.getValue("CUST_TYPE", 0));
        result.put("VATYN",         					sf_2.getValue("VATYN", 0));
        result.put("REGDATE",         				sf_2.getValue("REGDATE", 0));
        result.put("CTRL_SIGN_STATUS",       	sf_2.getValue("CTRL_SIGN_STATUS", 0));
        result.put("INTROMTHD",         			sf_2.getValue("INTROMTHD", 0));
        result.put("REGPAYNM",         			sf_2.getValue("REGPAYNM", 0));
        result.put("REQDEPT",         				sf_2.getValue("REQDEPT", 0));
        result.put("IF_FLAG",         				sf_2.getValue("IF_FLAG", 0));
        result.put("ORDER_COUNT",         		sf_2.getValue("ORDER_COUNT", 0));
        result.put("WBS",         					sf_2.getValue("WBS", 0));
        result.put("WBS_NAME",         			sf_2.getValue("WBS_NAME", 0));
        result.put("DELY_TO_LOCATION",       	sf_2.getValue("DELY_TO_LOCATION", 0));
        result.put("DELY_TO_ADDRESS",         sf_2.getValue("DELY_TO_ADDRESS", 0));
        result.put("DELY_TO_DEPT",        	 	sf_2.getValue("DELY_TO_DEPT", 0));
        result.put("DELY_TO_USER",         		sf_2.getValue("DELY_TO_USER", 0));
        result.put("DELY_TO_PHONE",         	sf_2.getValue("DELY_TO_PHONE", 0));
        result.put("PC_FLAG",         				sf_2.getValue("PC_FLAG", 0));
        result.put("PC_REASON",         			sf_2.getValue("PC_REASON", 0));
        result.put("PRE_CONT_SEQ",         		sf_2.getValue("PRE_CONT_SEQ", 0));
        result.put("PRE_CONT_COUNT",         	sf_2.getValue("PRE_CONT_COUNT", 0));
	    
    	return result;
    }
	
	// icoyprhd 신규생성 정보
	private Map<String, String> prHdCreateParam(SepoaFormater sf) throws Exception{		
		String prNo = this.getPrNo(info, "PR");
    			
		Map<String, String> result = new HashMap<String, String>();
		
		result.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		result.put("PR_NO",               prNo);
		result.put("STATUS",              "C");
		result.put("COMPANY_CODE",        sf.getValue("COMPANY_CODE", 0));
		result.put("PLANT_CODE",         sf.getValue("DEPARTMENT", 0));
		result.put("PR_TOT_AMT",          sf.getValue("TTL_AMT",0));
		result.put("PR_TYPE",             "I");
		result.put("DEMAND_DEPT",         sf.getValue("DELY_TO_DEPT", 0));     
		result.put("SIGN_STATUS",         "E");
		result.put("SIGN_DATE",           SepoaDate.getShortDateString());
		result.put("SIGN_PERSON_ID",       sf.getValue("ID", 0));
		result.put("SIGN_PERSON_NAME",    sf.getValue("NAME_LOC", 0));
		result.put("DEMAND_DEPT_NAME",    sf.getValue("DELY_TO_ADDRESS", 0));
		result.put("REMARK",              sf.getValue("REMARK", 0));
		result.put("SUBJECT",             sf.getValue("SUBJECT", 0)); 
		result.put("PR_LOCATION",        sf.getValue("LOCATION_CODE", 0));
		result.put("ORDER_NO",            "");
		result.put("SALES_USER_DEPT",     sf.getValue("DEPARTMENT", 0));  // SepoaDate.getShortTimeString()
		result.put("SALES_USER_ID",        sf.getValue("ID", 0)); 
		result.put("CONTRACT_HOPE_DAY",   SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),7) );
		result.put("CUST_CODE",           "0000100000");
		result.put("CUST_NAME",           "기타(계획용)");
		result.put("EXPECT_AMT",          sf.getValue("TTL_AMT",0));
		result.put("SALES_TYPE",          "P");
		result.put("ORDER_NAME",          "");
		result.put("REQ_TYPE",            "P");
		result.put("RETURN_HOPE_DAY",      SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),7) );
		result.put("ATTACH_NO",           "");
		result.put("HARD_MAINTANCE_TERM", "");
		result.put("SOFT_MAINTANCE_TERM", "");
		result.put("CREATE_TYPE",         "PR");
		result.put("ADD_USER_ID",         sf.getValue("ID", 0)); 
		result.put("CHANGE_USER_ID",     sf.getValue("ID", 0)); 
		result.put("BSART",               "");
		result.put("CUST_TYPE",           "");
		result.put("ADD_DATE",            SepoaDate.getShortDateString());
		result.put("AHEAD_FLAG",          "N");
		result.put("CONTRACT_FROM_DATE",  "");
		result.put("CONTRACT_TO_DATE",    "");
		result.put("SALES_AMT",           "");
		result.put("PROJECT_PM",          "");
		result.put("ORDER_COUNT",         "");
		result.put("WBS",                 "");
		result.put("WBS_NAME",            "");
		result.put("DELY_TO_LOCATION",    "");
		result.put("DELY_TO_ADDRESS",     "");
		result.put("DELY_TO_USER",        "");
		result.put("DELY_TO_PHONE",       "");
		result.put("PC_FLAG",             "N");
		result.put("PC_REASON",           ""); 	
		result.put("PRE_CONT_SEQ",           ""); 	
		result.put("PRE_CONT_COUNT",           ""); 	
		
		return result;
	}

	private Map<String, String> setting_osln_group_data(SepoaFormater sf_3, Map<String, String> prhd_data, int z, String dely_addr, String dely_addr_code) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		
//		result.put("P_ITEM_NO",         	sf_3.getValue("P_ITEM_NO", 0));
//		result.put("ITEM_QTY",         		sf_3.getValue("ITEM_QTY", 0));
//		result.put("ITEM_AMT",         	sf_3.getValue("ITEM_AMT", 0));
//		result.put("KTGRM",         			sf_3.getValue("KTGRM", 0));
//		result.put("DESCRIPTION_LOC", 	sf_3.getValue("DESCRIPTION_LOC", 0));
//		result.put("BASIC_UNIT",         	sf_3.getValue("BASIC_UNIT", 0));
//		result.put("SPECIFICATION",         	sf_3.getValue("SPECIFICATION", 0));
		//sosln 데이터를 가져오기위한 변수
		
		//String pr_amt = String.valueOf(Double.parseDouble(sf_3.getValue("ITEM_QTY", z)) * Double.parseDouble(sf_3.getValue("ITEM_AMT", z)));
		String unit_price = String.valueOf(Double.parseDouble(sf_3.getValue("ITEM_AMT", z)) / Double.parseDouble(sf_3.getValue("ITEM_QTY", z)) );
		
		result.put("HOUSE_CODE",         prhd_data.get("HOUSE_CODE"));
		result.put("PR_NO",              prhd_data.get("PR_NO"));
		//result.put("PR_SEQ",             String.valueOf(z+1));
		result.put("STATUS",             prhd_data.get("STATUS"));
		result.put("COMPANY_CODE",       prhd_data.get("COMPANY_CODE"));
		result.put("PLANT_CODE",         prhd_data.get("PLANT_CODE"));
		result.put("ITEM_NO",            sf_3.getValue("ITEM_NO", z));
		result.put("PR_PROCEEDING_FLAG", "G");
		result.put("CTRL_CODE",          "P01");
		result.put("UNIT_MEASURE",      sf_3.getValue("BASIC_UNIT", z));
		result.put("PR_QTY",             sf_3.getValue("ITEM_QTY", z));
		result.put("CUR",                "KRW");
		result.put("UNIT_PRICE",         unit_price);
		result.put("PR_AMT",             sf_3.getValue("ITEM_AMT", z));
		result.put("RD_DATE",            sf_3.getValue("RD_DATE", z));
		result.put("ATTACH_NO",          "");
		result.put("REC_VENDOR_CODE",    "");
		result.put("DELY_TO_LOCATION",   "S100");
		result.put("REC_VENDOR_NAME",    "");
		result.put("DESCRIPTION_LOC",    sf_3.getValue("DESCRIPTION_LOC", z));
		result.put("SPECIFICATION",      sf_3.getValue("SPECIFICATION", z));
		result.put("MAKER_NAME",         "");
		result.put("MAKER_CODE",         "");
		result.put("REMARK",             "");
		result.put("PURCHASE_LOCATION",  "01");
		result.put("PURCHASER_ID",       info.getSession("ID"));
		result.put("PURCHASER_NAME",     info.getSession("ID"));	//insert시 함수돌린다.
		result.put("PURCHASE_DEPT",      prhd_data.get("SALES_USER_DEPT"));
		result.put("PURCHASE_DEPT_NAME", prhd_data.get("SALES_USER_DEPT"));	//insert시 함수돌린다.
		result.put("TECHNIQUE_GRADE",    "");
		result.put("TECHNIQUE_TYPE",     "");
		result.put("INPUT_FROM_DATE",    "");
		result.put("INPUT_TO_DATE",      "");
		result.put("ADD_USER_ID",        prhd_data.get("SALES_USER_ID"));
		result.put("CHANGE_USER_ID",     prhd_data.get("SALES_USER_ID"));
		result.put("KNTTP",              "P");
		result.put("ZEXKN",              "10");
		result.put("ORDER_NO",           "");
		result.put("ORDER_SEQ",          String.valueOf(z+1));
		result.put("WBS_NO",             "");
		result.put("WBS_SUB_NO",        "");
		result.put("WBS_TXT",            "");
		result.put("CONTRACT_DIV",       "");
		result.put("DELY_TO_ADDRESS",    dely_addr);
		result.put("WARRANTY",           "");
		result.put("EXCHANGE_RATE",      "1");
	    result.put("WBS_NAME",           "");
	    result.put("ORDER_COUNT",        "");
	    result.put("PRE_TYPE",           "");
	    result.put("PRE_PO_NO",          ""); 
	    result.put("PRE_PO_SEQ",         "");
	    result.put("ACCOUNT_TYPE",       sf_3.getValue("KTGRM", z));
	    result.put("ASSET_TYPE",         "");
	    result.put("DELY_TO_ADDRESS_CD"	,  dely_addr_code);
	    result.put("P_ITEM_NO",  "");
	    
	    result.put("BEFORE_CTRL_CODE",          "P01");
	    result.put("BID_STATUS",          "GB");
	    result.put("CONFIRM_QTY",           sf_3.getValue("ITEM_QTY", z));
	    result.put("DEMAND_DEPT",          dely_addr_code);
	    
		return result;
	}
	
	private int insert_prdt(ConnectionContext ctx, Map<String, String> param) throws Exception{
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "insert_prdt");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            rtn = ssm.doInsert(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	private String getPrNo(SepoaInfo info, String docType) throws Exception{
		SepoaOut wo   = DocumentUtil.getDocNumber(info, docType);
	    String   prNo = wo.result[0];
	    
	    return prNo;
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateComplete(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx           = null;
		List<Map<String, String>> grid          = (List<Map<String, String>>)data.get("gridData");
//		Map<String, String>          hdInfo       = (Map<String, String>)data.get("hdInfo");
		List<Map<String, String>> sosLnList     = null;
		Map<String, String>       gridInfo      = null;
		Map<String, String>       sosLnListInfo = null;
		int                       gridSize      = grid.size();
		int                       i             = 0;
		int                       sosLnListSize = 0;
		int                       j             = 0;
		int                       hd_rtn            = 0;
		int                       dt_rtn            = 0;
		int                       orln_rtn        = 0;
		int                       osgl_rtn        = 0;
		int                       osln_rtn        = 0;
		int                       orgl_rtn        = 0;
		//sosln 데이터를 가져오기위한 변수
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String rtn = null;
		String id = info.getSession("ID");
		Map<String, String>  pr_data =  new HashMap<String, String>();
		Map<String, String>  prdt_insert_data =  new HashMap<String, String>();
		Map<String, String>  osln_group_data =  new HashMap<String, String>();
		Map<String, String>  prhd_data =  new HashMap<String, String>();
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			for(i = 0; i < gridSize; i++) {
				gridInfo = grid.get(i);
				
//				System.out.println("gridInfo====="+gridInfo.toString());
				
				//최초에만 돌린다.
				if(i == 0) {
					
					//기존에 저장되어 있는 SOSLN 데이터를 모두 가져온다.
					sxp = new SepoaXmlParser(this, "get_sosln_list_new");
			        ssm = new SepoaSQLManager(id, this, ctx, sxp);
			        rtn = ssm.doSelect(gridInfo);
			        sf = new SepoaFormater(rtn);
			        
			        //SOSLN의 pr_no와 house_code를 Map에 담는다.			        
			        pr_data.put("HOUSE_CODE", sf.getValue("HOUSE_CODE", 0));
			        pr_data.put("PR_NO",      sf.getValue("PR_NO", 0));
			        			        
			        if(sf.getValue("PR_NO", 0) == null || sf.getValue("PR_NO", 0).equals("")){
			        	// 2월 16일 개발 하자//////////////////////////////////////////////////////////////////////////////////////////////////
			        	// 구매요청 없이 실사생성이 된경우 ICOYPRHD 신규생성			        	
			        	
			        	prhd_data  = this.prHdCreateParam(sf);
			        	hd_rtn          = this.insert_prhd(ctx,prhd_data);
			             
			            if(hd_rtn < 1){
			            	throw new Exception("구매요청 헤드정보 생성중 오류");
			            }			        				        				      			    
			        }else{			        	
			        	 //Map의 데이터로 PRHD 데이터를 모두 가져온다.
				        sxp = new SepoaXmlParser(this, "get_prhd_list");
				        ssm = new SepoaSQLManager(id, this, ctx, sxp);
				        SepoaFormater sf_2 = new SepoaFormater(ssm.doSelect(pr_data));
				        
				      //fomater의 데이터를 모두 Map에 넣는다.
				        prhd_data  = this.setting_prhd_data(sf_2, sf);
				        hd_rtn = this.update_prhd(ctx, prhd_data);
				        
				        if(hd_rtn < 1){
			            	throw new Exception("구매요청 헤드정보 갱신중 오류");
			            }			        				        				      
			        }
			        			        			       				        			       			      						
			        //Group할 데이터를 뽑는다. (기준: PR_NO,PR_SEQ 별)
			        sxp = new SepoaXmlParser(this, "get_osln_group_list");
			        ssm = new SepoaSQLManager(id, this, ctx, sxp);
			        SepoaFormater sf_3 = new SepoaFormater(ssm.doSelect(gridInfo));
			        			        
		  			//그룹핑된 개수 만큼 for문을 돌려서 prdt를 업데이트 혹은 새로생성한다.
		  			for(int z = 0; z < sf_3.getRowCount(); z++) {
		  				String pr_no = sf_3.getValue("PR_NO", z);
		  				String pr_seq = sf_3.getValue("PR_SEQ", z);
		  				String cnt = sf_3.getValue("CNT", z);
		  						  			    
		  		        String dely_addr = sf_3.getValue("DELY_TO_ADDRESS", z);
		  		        String dely_addr_code = sf_3.getValue("DELY_TO_DEPT", z);
		  				
		  		        //icoyprdt 데이타 생성
		  				osln_group_data = this.setting_osln_group_data(sf_3, prhd_data, z, dely_addr, dely_addr_code);
		  				osln_group_data.put("PO_VENDOR_CODE", sf_3.getValue("VENDOR_CODE", z));
		  				
		  				if("0".equals(cnt)){
		  					//insert
		  					osln_group_data.put("PR_PROCEEDING_FLAG", "E");
		  					dt_rtn = this.insert_prdt(ctx, osln_group_data);
		  					if(dt_rtn < 1){
				            	throw new Exception("구매요청 상세정보 생성중 오류");
				            }			      
		  				}else{
		  					//update
		  					osln_group_data.put("PR_NO", pr_no);
		  					osln_group_data.put("PR_SEQ", pr_seq);
		  					osln_group_data.put("DELY_TO_ADDRESS", dely_addr);
		  					
		  					
		  					dt_rtn = this.update_prdt_flag(ctx, osln_group_data);
		  					if(dt_rtn < 1){
				            	throw new Exception("구매요청 상세정보 갱신중 오류");
				            }			     
		  				}
		  			}
			       
				}
				
				// 여기소스 검증 필요/////////////////////////////////////////////////////////////////////
				osgl_rtn = this.updateCompleteUpdateSosglInfo(ctx, gridInfo);
				if(osgl_rtn < 1){
	            	throw new Exception("실사요청 마스타 갱신중 오류");
	            }
				
				osln_rtn = this.updateCompleteUpdateSoslnInfo(ctx, gridInfo, prhd_data);
				if(osgl_rtn < 1){
	            	throw new Exception("실사요청 상셍정보 갱신중 오류");
	            }
				
				
				
				
				orgl_rtn = this.updateCompleteupdateSorglUpdate(ctx, gridInfo, prhd_data);
				if(orgl_rtn < 1){
	            	throw new Exception("실사서 마스타 갱신중 오류");
	            }	
									
				orln_rtn = this.updateCompleteupdateSorlnUpdate(ctx, gridInfo);
				if(orln_rtn < 1){
	            	throw new Exception("실사서 상세정보 갱신중 오류");
	            }			
				//////////////////////////////////////////////////////////////////////////////////////////
				
            }
			Commit();
		} catch(Exception e) {
			Rollback();
//			e.printStackTrace();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
// [R101511059885] [2015-01-31] 실사요청시 업체 실사요청화면 개선요청
//	public SepoaOut updateComplete(Map<String, Object> data) throws Exception{
//        ConnectionContext         ctx           = null;
//		List<Map<String, String>> grid          = (List<Map<String, String>>)data.get("gridData");
//		List<Map<String, String>> sosLnList     = null;
//		Map<String, String>       gridInfo      = null;
//		Map<String, String>       sosLnListInfo = null;
//		int                       gridSize      = grid.size();
//		int                       i             = 0;
//		int                       sosLnListSize = 0;
//		int                       j             = 0;
//		//sosln 데이터를 가져오기위한 변수
//		SepoaXmlParser sxp = null;
//		SepoaSQLManager ssm = null;
//		SepoaFormater sf = null;
//		String rtn = null;
//		String id = info.getSession("ID");
//		Map<String, String>  pr_data =  new HashMap<String, String>();
//		Map<String, String>  prdt_insert_data =  new HashMap<String, String>();
//		Map<String, String>  osln_group_data =  new HashMap<String, String>();
//		Map<String, String>  prhd_data =  new HashMap<String, String>();
//        
//		try {
//			setStatus(1);
//			setFlag(true);
//			
//			ctx = getConnectionContext();
//			
//			for(i = 0; i < gridSize; i++) {
//				gridInfo = grid.get(i);
//				
//				System.out.println("gridInfo====="+gridInfo.toString());
//				
//				//최초에만 돌린다.
//				if(i == 0) {
//					//1. get_sosln_list_new에서 pr_no,house_code를 조회한다
//					//2. get_prhd_list에서 pr헤더정보를 조회해서 prhd_data에 담아둔다
//					//3. select_orgl_vendor에서 vendor_code를 조회해서 po_vendor에 담아둔다
//					//4. get_osln_group_list로 조회해서 개수 만큼 for문을 돌려서 prdt를 업데이트 혹은 새로생성한다.
//					//   pr_no, pr_seq 가 
//					//   있으면 prdt 의 데이타를 업데이트
//					//   없으면 prdt 에 데이타를 인서트
//					// 
//					
//					//기존에 저장되어 있는 SOSLN 데이터를 모두 가져온다.
//					sxp = new SepoaXmlParser(this, "get_sosln_list_new");
//			        ssm = new SepoaSQLManager(id, this, ctx, sxp);
//			        rtn = ssm.doSelect(gridInfo);
//			        sf = new SepoaFormater(rtn);
//			        
//			        //SOSLN의 pr_no와 house_code를 Map에 담는다.			        
//			        pr_data.put("HOUSE_CODE", sf.getValue("HOUSE_CODE", 0));
//			        pr_data.put("PR_NO",      sf.getValue("PR_NO", 0));
//			        
//			        //Map의 데이터로 PRHD 데이터를 모두 가져온다.
//			        sxp = new SepoaXmlParser(this, "get_prhd_list");
//			        ssm = new SepoaSQLManager(id, this, ctx, sxp);
//			        SepoaFormater sf_2 = new SepoaFormater(ssm.doSelect(pr_data));
//			        
//			        //fomater의 데이터를 모두 Map에 넣는다.
//			        prhd_data  = this.setting_prhd_data(sf_2);
//			        
//			        //Group할 데이터를 뽑는다. (기준: 모품코드 별, 단품 별)
//			        sxp = new SepoaXmlParser(this, "get_osln_group_list");
//			        ssm = new SepoaSQLManager(id, this, ctx, sxp);
//			        SepoaFormater sf_3 = new SepoaFormater(ssm.doSelect(gridInfo));
//			        
//			        //공급업체 코드 가져오기
//			        sxp = new SepoaXmlParser(this, "select_orgl_vendor");
//	  		        ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
//	  		        SepoaFormater sf_5 = new SepoaFormater(ssm.doSelect(gridInfo));
//	  		        
//	  		        String po_vendor = sf_5.getValue("VENDOR_CODE", 0);
//			        
//		  			
//		  			//그룹핑된 개수 만큼 for문을 돌려서 prdt를 업데이트 혹은 새로생성한다.
//		  			for(int z = 0; z < sf_3.getRowCount(); z++) {
//		  				String pr_no = sf_3.getValue("PR_NO", z);
//		  				String pr_seq = sf_3.getValue("PR_SEQ", z);
//		  				
//		  			    //그룹된 아이템번호의 납품주소를 가져온다.
//		  				Map<String, String> addr_data = new HashMap<String, String>();
//		  				Map<String, String> dt_update_data = new HashMap<String, String>();
//		  				addr_data.put("OSQ_NO",  sf_3.getValue("OSQ_NO", z));
//		  				addr_data.put("ITEM_NO", sf_3.getValue("P_ITEM_NO", z));
//		  				sxp = new SepoaXmlParser(this, "get_address_osln");
//		  		        ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
//		  		        SepoaFormater sf_4 = new SepoaFormater(ssm.doSelect(addr_data));
//		  				
//		  		        String dely_addr = sf_4.getValue("DELY_TO_ADDRESS", 0);
//		  		        String dely_addr_code = sf_4.getValue("DELY_TO_DEPT", 0);
//		  				
//		  				osln_group_data = this.setting_osln_group_data(sf_3, prhd_data, z, dely_addr, dely_addr_code);
//		  				osln_group_data.put("PO_VENDOR_CODE", po_vendor);
//		  				
//		  				if(pr_seq == null || "".equals(pr_seq)){
//		  					//insert
//		  					osln_group_data.put("PR_PROCEEDING_FLAG", "E");
//			  				this.insert_prdt(osln_group_data);
//		  				}else{
//		  					//update
//		  					osln_group_data.put("PR_NO", pr_no);
//		  					osln_group_data.put("PR_SEQ", pr_seq);
//		  					this.update_prdt_flag(ctx, osln_group_data);
//		  				}
//		  			}
//			       
//				}
//				
//				this.updateCompleteUpdateSosglInfo(ctx, gridInfo);
//				this.updateCompleteupdateSorlnUpdate(ctx, gridInfo);
//            }
//			Commit();
//		} catch(Exception e) {
//			Rollback();
//			e.printStackTrace();
//			setStatus(0);
//			setFlag(false);
//			setMessage(e.getMessage());
//			Logger.err.println(info.getSession("ID"), this, e.getMessage());
//		}
//
//		return getSepoaOut();
//    }
	
		
	//PRHD테이블 삭제
	private int PRHDDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String id = info.getSession("ID");
		int result = 0;
		
		sxp = new SepoaXmlParser(this, methodName);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doDelete(param);
		
		return result;
	}
	
  	//PRDT테이블 삭제
  	private int PRDTDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
  		SepoaXmlParser sxp = null;
  		SepoaSQLManager ssm = null;
  		String id = info.getSession("ID");
  		int result = 0;
  		
  		sxp = new SepoaXmlParser(this, methodName);
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
          
        result = ssm.doDelete(param);
          
        return result;
  	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateUnComplete(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = (List<Map<String, String>>)data.get("gridData");
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
		int                       gridSize = grid.size();
        
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			for(int i = 0; i < gridSize; i++) {
				gridInfo = grid.get(i);
				
				this.updateCompleteUpdateSosglInfo(ctx, gridInfo);
                this.updateCompleteupdateSorlnUpdate(ctx, gridInfo);
                
                sxp = new SepoaXmlParser(this, "updateUnComplete");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
                ssm.doUpdate(gridInfo);
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
	
	@SuppressWarnings("unchecked")
	public SepoaOut updateReject(Map<String, Object> data) throws Exception{
		ConnectionContext         ctx      = null;
		SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = (List<Map<String, String>>)data.get("gridData");
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
		int                       gridSize = grid.size();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ctx  = getConnectionContext();
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			for(int i = 0; i < gridSize; i++) {
				gridInfo = grid.get(i);
				
//				this.updateCompleteUpdateSosglInfo(ctx, gridInfo);
//				this.updateCompleteupdateSorlnUpdate(ctx, gridInfo);
				
				sxp = new SepoaXmlParser(this, "updateReject");
				ssm = new SepoaSQLManager(id, this, ctx, sxp);
				
				ssm.doUpdate(gridInfo);
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
	
	private int insert_prhd(ConnectionContext ctx, Map<String, String> param) throws Exception{
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "insert_prhd");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doInsert(param);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
}