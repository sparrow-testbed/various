package sepoa.svc.procure;
/**
*
* Copyright 2001-2001 ICOMPIA Co., Ltd. All Rights Reserved.
* This software is the proprietary information of ICOMPIA Co., Ltd.
* @version        1.0
*                                ���� ����ȸ/���� (�����ڹ���)
*                                                                 Andy Shin ...
*/


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
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;


public class PO_002 extends SepoaService {
        /*private Message msg = new Message("STDPO");
        
        private String HOUSE_CODE = info.getSession("HOUSE_CODE");
        private String lang = info.getSession("LANGUAGE");
        private Message msg_pr = new Message(lang,"STDPR");*/

    public PO_002(String opt,SepoaInfo info) throws SepoaServiceException {

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
    
	public SepoaOut getPoList(Map<String, Object> data) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			Map<String, String> customHeader =  new HashMap<String, String>();	//�좉퇋媛앹껜
			
			/*customHeader.put("start_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "start_date", "")));
			customHeader.put("end_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "end_date", "")));
			customHeader.put("add_user_id", MapUtils.getString(header, "add_user_id", ""));
			*/
			header.put("po_from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "po_from_date", "")));
			header.put("po_to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "po_to_date", "")));
			header.put("cont_from_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "cont_from_date", "")));
			header.put("cont_to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "cont_to_date", "")));
			
			
			sxp = new SepoaXmlParser(this, "getPoList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			sxp.addVar("HOUSE_CODE",info.getSession("HOUSE_CODE"));
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
	
	
	
	public SepoaOut getPoDetailHeader(String po_no) {
		
        /* TOBE 2017-07-01 총무부 글로벌 상수 */
        String default_gam_jumcd   = sepoa.svc.common.constants.DEFAULT_GAM_JUMCD;
        
        
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			
			HashMap<String, String> no = new HashMap<String, String>();
			no.put("po_no", po_no);
			
			/* TOBE 2017-07-01 총무부 글로벌 상수 */
			no.put("DEFAULT_GAM_JUMCD", default_gam_jumcd);
			
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
	
	
	
	public SepoaOut getPoDetailLine(Map<String, Object> data) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			Map<String, String> customHeader =  new HashMap<String, String>();	//�좉퇋媛앹껜
			
			sxp = new SepoaXmlParser(this, "getPoDetailLine");
			sxp.addVar("language", info.getSession("LANGUAGE"));
			
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	setValue(ssm.doSelect(header, customHeader));

		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	
	
	public SepoaOut setPoUpdate(Map<String, Object> data) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String user_id        = info.getSession("ID");
        String house_code     = info.getSession("HOUSE_CODE");
        String user_dept      = info.getSession("DEPARTMENT");
        String po_no		  = data.get("PO_NO").toString();
        String sign_status	  = data.get("SIGN_STATUS").toString();
        
		try {
		     int rtn1 = up_ICOYPODT_DO(data, ctx);
					setValue("Insert Row="+rtn1);
					Map<String, Object> prData = new HashMap<String, Object>();
					if(rtn1 == 0){
						Rollback();
						setStatus(0);
						//setMessage(msg.getMessage("9003"));
						return getSepoaOut();
					}
					Logger.debug.println(this, "==================up_ICOYPODT_DO");

				int rtnHD = up_ICOYPOHD_DO(data, ctx);
		            if(rtnHD == 0){
		                Rollback();
		                setStatus(0);
		                setFlag(false);
		                //setMessage(msg.getMessage("4000"));
		                return getSepoaOut();
		            }
		        Logger.debug.println(this, "==================up_ICOYPOHD_DO");
		        
	
	       
	        if ( !sign_status.equals("M") ) {
	        int rtnPRDT = setPRDT(data, ctx);
            if(rtnPRDT == 0){
                Rollback();
                setStatus(0);
                //setMessage(msg.getMessage("4000"));
                return getSepoaOut();
            }
            Logger.debug.println(this, "==================setPRDT");
	        }
	        
	        updateCndt(data, ctx);
			
	        if(sign_status.equals("P"))
            {
                String company        =  info.getSession("COMPANY_CODE");
                String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
    			String name_eng        =  info.getSession("NAME_ENG");
    			String name_loc        =  info.getSession("NAME_LOC");
    			String lang            =  info.getSession("LANGUAGE");
    			
    			wisecommon.SignRequestInfo sri = new wisecommon.SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(user_dept);
                sri.setReqUserId(user_id);
                //2010.12.08 swlee modify
                //sri.setDocType("BR");
                sri.setDocType("POD");
                sri.setDocNo(po_no);
                sri.setDocSeq("0");
               /* sri.setDocName(PohdData[0][22]);
                sri.setItemCount(PodtData.length);
                sri.setSignStatus(sign_status);
                sri.setCur(PohdData[0][14]);
                sri.setTotalAmt(Double.parseDouble(ttl_amt));

                sri.setSignString(approval); // AddParameter 에서 넘어온 정보
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn == 0)
                {
                    try
                    {
                        Rollback();
                    }
                    catch(Exception d)
                    {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.getMessage("0030"));
                    return getSepoaOut();
                }*/

                //msg.setArg("PO_NO",po_no);
                setMessage("발주번호 "+po_no+"번으로 전송되었습니다.");
            }
    		else if (sign_status.equals("E")) {
    	    	String setData[][]	= {{po_no}};
    			//발주품목의 RD_DATE 수정
    	    	setPODT(data, ctx);
    			//구매요청의 PROCEEDING_FLAG 수정
    			setPRDT(data, ctx);
    		}
        	
        	setStatus(1);
        	setValue(po_no);
        	
        	
    		if(sign_status.equals("T")){
    			setMessage("발주번호 "+po_no+" 로 저장되었습니다.");
    		}else if(sign_status.equals("E")){
    			setMessage("발주번호 "+po_no+" 로 해당 업체로 전송 되었습니다.");
    		}else if(sign_status.equals("P")){
    			setMessage("발주번호 "+po_no+" 로 결재요청 되었습니다.");
    		}
    		
    		Commit();
        	
		}catch (Exception e){
//			e.printStackTrace();
			try {
				Rollback();
			} catch (SepoaServiceException e1) {
//				e1.printStackTrace();
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
				
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}	
	

    private int up_ICOYPODT_DO(Map<String, Object> data, ConnectionContext ctx)  throws Exception
    {
    	int rtn = -1;
//        ConnectionContext ctx = getConnectionContext();
        setStatus(1);
        setFlag(true);
        
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	
        	
        	List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	
        	for(int i=0; i<grid.size(); i++){        	
        	String STR_FLAG = "";
        	Map<String, String> header = MapUtils.getMap(data, "headerData");
        	
        	header.put("SPACE", MapUtils.getString(data,"SPACE",""));
        	header.put("CHANGE_DATE", MapUtils.getString(data,"CHANGE_DATE",""));
        	header.put("STATUS",  MapUtils.getString(data,"STATUS"));
        	header.put("CHANGE_TIME", MapUtils.getString(data,"CHANGE_TIME",""));
        	header.put("CHANGE_USER_ID", MapUtils.getString(data,"CHANGE_USER_ID",""));
        	header.put("COMPANY_CODE", MapUtils.getString(data,"COMPANY_CODE",""));
        	
        	header.put("ITEM_AMT_KRW", MapUtils.getString(data,"ITEM_AMT_KRW",""));
        	header.put("PURCHASER_ID", MapUtils.getString(data,"PURCHASER_ID",""));
        	header.put("PURCHASER_NAME", MapUtils.getString(data,"PURCHASER_NAME",""));
        	header.put("RD_DATE", SepoaString.getDateUnSlashFormat(MapUtils.getString(grid.get(i),"RD_DATE","")));
        	if(MapUtils.getString(data,("SPACE"),"").equals("")){
					STR_FLAG = "D";
				}else{
					STR_FLAG = "S";
				}
        	header.put("STR_FLAG", STR_FLAG);
        	
        	sxp = new SepoaXmlParser(this, "up_ICOYPODT_DO");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	
        	
        	
        	rtn = ssm.doUpdate(grid,header);
        	
        	}
        	
        }catch(Exception e) {
        	try {
				Rollback();
			} catch (SepoaServiceException e1) {
			
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
				
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return rtn;
	}	
    
  private int up_ICOYPOHD_DO(Map<String, Object> data, ConnectionContext ctx) throws Exception
    {
    	int rtn = -1;
//        ConnectionContext ctx = getConnectionContext();
        setStatus(1);
        setFlag(true);
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {
        	String STR_FLAG = "";
        	Map<String, String> header = MapUtils.getMap(data, "headerData");
        	header.put("SPACE", MapUtils.getString(data,("SPACE"),""));
        	header.put("CHANGE_DATE", MapUtils.getString(data,"CHANGE_DATE",""));
        	header.put("STATUS", MapUtils.getString(data,"STATUS",""));
        	header.put("CHANGE_TIME", MapUtils.getString(data,"CHANGE_TIME",""));
        	header.put("CHANGE_USER_ID", MapUtils.getString(data,"CHANGE_USER_ID",""));
        	header.put("COMPANY_CODE", MapUtils.getString(data,"COMPANY_CODE",""));
        	header.put("SIGN_STATUS", MapUtils.getString(data,"SIGN_STATUS",""));
        	header.put("PO_TTL_AMT", MapUtils.getString(data,"PO_TTL_AMT",""));
        	header.put("PURCHASER_ID", MapUtils.getString(data,"PURCHASER_ID",""));
        	header.put("PURCHASER_NAME", MapUtils.getString(data,"PURCHASER_NAME",""));
        	header.put("TAKE_USER_NAME", MapUtils.getString(data,"TAKE_USER_NAME",""));
        	
        	
      
        	sxp = new SepoaXmlParser(this, "up_ICOYPOHD_DO");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	

        	rtn= ssm.doUpdate(header);
        	
        
        }catch(Exception e) {
        	try {
				Rollback();
			} catch (SepoaServiceException e1) {
			
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
				
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return rtn;
	}	
    
    

  
    private int setPRDT(Map<String, Object> data, ConnectionContext ctx) throws Exception
    {
    	int rtn = -1;
//        ConnectionContext ctx = getConnectionContext();
        
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		
		String user_id    = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");

	
        try {
        	
        	Map<String, String> header = MapUtils.getMap(data, "headerData");
        	
        	
        	   		
        	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
			String rtnSql = ssm.doSelect(header);
			sf = new SepoaFormater(rtnSql);
            	
			 
			 List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			 for( int i = 0 ; i < grid.size(); i++ )
	             {  	
				 String pr_no = sf.getValue( i,0 );
                 String pr_seq = sf.getValue( i,1 );

                 sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
                 sxp.addVar("house_code"	, house_code);
                 sxp.addVar("pr_no"		, pr_no);
                 sxp.addVar("pr_seq"		, pr_seq);
                 ssm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
                 ssm.doUpdate(grid.get(i));
             }
 
        	
        
        }catch(Exception e) {
//        	e.printStackTrace();
        	try {
				Rollback();
			} catch (SepoaServiceException e1) {
//				e1.printStackTrace();
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
				
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return rtn;
	}	
	
    

    private int setPRDT2(Map<String, Object> data) throws Exception
    {	
    	int rtn = -1;
        
        ConnectionContext ctx = getConnectionContext();
        
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		
		String user_id    = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
		
        try {

        	Map<String, String> header = MapUtils.getMap(data, "headerData");
        	
    			
        	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
			String rtnSql = ssm.doSelect(header);
			sf = new SepoaFormater(rtnSql);
            	
			 
			 List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			 for( int i = 0 ; i < grid.size(); i++ )
	         { 	
				 String pr_no = sf.getValue( i,0 );
                 String pr_seq = sf.getValue( i,1 );

                 sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
                 sxp.addVar("house_code"	, house_code);
                 sxp.addVar("pr_no"		, pr_no);
                 sxp.addVar("pr_seq"		, pr_seq);
                 ssm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp);
                 ssm.doUpdate(grid);
             }
 
        	
        
        }catch(Exception e) {
        	try {
				Rollback();
			} catch (SepoaServiceException e1) {
			
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
				
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return rtn;
	}	
    
/*
    public WiseOut CallNONDBJOB(ConnectionContext ctx, String serviceId, String MethodName, Object[] obj )
	{

		String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB

		wise.srv.WiseOut value = null;
		wise.util.WiseRemote wr	= null;

		//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
		try
		{

			wr = new wise.util.WiseRemote( serviceId, conType, info	);
			wr.setConnection(ctx);

			value =	wr.lookup( MethodName, obj );

		}catch(	WiseServiceException wse ) {
			try{
				Logger.err.println("wse	= "	+ wse.getMessage());
				Logger.err.println("message	= "	+ value.message);
				Logger.err.println("status = " + value.status);				
			}catch(NullPointerException ne){
        		ne.printStackTrace();
        	}
		}catch(Exception e)	{
			try{
				Logger.err.println("err	= "	+ e.getMessage());
				Logger.err.println("message	= "	+ value.message);
				Logger.err.println("status = " + value.status);				
			}catch(NullPointerException ne){
        		ne.printStackTrace();
        	}
		}

		return value;
	}
*/

    private int updateCndt(Map<String, Object> data, ConnectionContext ctx) throws Exception
    {
    	int rtn = -1;
//        ConnectionContext ctx = getConnectionContext();
        
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String rtnSelect = null, _po_no = null, _po_seq = null, _exec_no = null, _exec_seq = null;

		
        try {
        	
        	Map<String, String> header = MapUtils.getMap(data, "headerData");
        	
        	
    		
        	sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
			sxp.addVar("language", info.getSession("LANGUAGE"));			
			
			
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
			rtnSelect = ssm.doSelect(header);
			sf = new SepoaFormater(rtnSelect);
            	
		
			 if ( sf.getRowCount() > 0 ) {
	            	 List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	            for (int i = 0; i < grid.size(); i++) {
	    	            	    	
	            		_po_no = sf.getValue(i, 0);
		            	_po_seq = sf.getValue(i, 1);
		            	_exec_no = sf.getValue(i, 2);
		            	_exec_seq = sf.getValue(i, 3);
		
	            		sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
	            		sxp.addVar("po_no", _po_no);
	            		sxp.addVar("po_seq", _po_seq);
	            		sxp.addVar("exec_no", _exec_no);
	            		sxp.addVar("exec_seq", _exec_seq);
	            		ssm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sxp.getQuery());
		
	            		ssm.doUpdate(grid.get(i));
	            	}
	            }
			 
 
        	
        
        }catch(Exception e) {
        	try {
				Rollback();
			} catch (SepoaServiceException e1) {
			
				Logger.err.println(info.getSession("ID"), this, e.getMessage());
				
			}
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return rtn;
	}	
    
    private int setPODT(Map<String, Object> data, ConnectionContext ctx) throws Exception
 	{
 		int rtn = -1;
// 		ConnectionContext ctx = getConnectionContext();
 		
 		SepoaSQLManager sm = null;
 		SepoaFormater wf = null;
 		
 		String user_id    = info.getSession("ID");
 		String house_code = info.getSession("HOUSE_CODE");
 		
 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		
 		Map<String, String> paramMap = new HashMap<String, String>();
//     	wxp.addVar("house_code", house_code);
//     	wxp.addVar("getConfig", getConfig("wise.generator.db.selfuser"));
     	
     	try {

//         sql = new StringBuffer();
//         sql.append( " UPDATE ICOYPODT                                               \n" );
//         sql.append( " SET   RD_DATE = " +getConfig("wise.generator.db.selfuser") + "."+ "dateFormat(getdate(), 'YYYYMMDD')      \n" );
//          sql.append( " WHERE HOUSE_CODE = '"+house_code+"'                           \n" );
//         sql.append( "   AND PO_NO = ?                                               \n" );
//         sql.append( "   AND RD_DATE < " +getConfig("wise.generator.db.selfuser") + "."+ "dateFormat(getdate(), 'YYYYMMDD')      \n" );

     		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
     		
     		paramMap = MapUtils.getMap(data, "headerData");
     		paramMap.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
     		
     		//String[] type = { "S" };
     		rtn = sm.doUpdate(paramMap);
     	} catch(Exception e) {
     		throw new Exception("setPODT:"+e.getMessage());
     	} finally {
     	}
     	return rtn;
 	}
   

	 
/*****************************************************************/
} // END


