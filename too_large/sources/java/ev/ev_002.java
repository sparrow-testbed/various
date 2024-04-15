package ev;

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
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;
//import erp.ERPInterface;

public class EV_002 extends SepoaService {
	private String ID           = info.getSession( "ID" );
    private String HOUSE_CODE   = info.getSession( "HOUSE_CODE" );
    private String lang         = info.getSession( "LANGUAGE" );
    
	Message msg = new Message(info, "IV_001");  // message 처리를 위해 전역변수 선언

	public EV_002(String opt, SepoaInfo info) throws SepoaServiceException {
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

	/**
	 * @Method Name : getConfig
	 * @작성일 : 2011. 12. 10
	 * @작성자 :
	 * @변경이력 :
	 * @Method 설명 :
	 * @param s
	 * @return
	 */
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
	

	/* 평가 목록 */
	public SepoaOut getEvalSheetList(Map<String, String> header) {
		try {
			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getEvalSheetList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getEvalSheetList(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getEvalSheetList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getEvalSheetList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 평가표 헤드정보 */
	public SepoaOut getEvalSheetInfo(String es_cd, String es_ver) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("es_cd", es_cd);
			customHeader.put("es_ver", es_ver);
		    String rtnHD = bl_getEvalSheetInfo(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/* 평가표 헤드정보 */
	private String bl_getEvalSheetInfo(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getEvalSheetInfo");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getEvalSheetInfo:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 평가표 상세 */
	public SepoaOut getEvalSheetDesc(String es_cd, String es_ver) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("es_cd", es_cd);
			customHeader.put("es_ver", es_ver);
			String rtnHD = bl_getEvalSheetDesc(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getEvalSheetDesc(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getEvalSheetDesc");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getEvalSheetDesc:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 기술평가계획 목록 */
	public SepoaOut getEtplList(Map<String, String> header) {
		try {
			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getEtplList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getEtplList(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getEtplList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getEtplList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 기술평가계획1 */
	public SepoaOut getEtplOne(Map<String, String> args){
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		String            cur = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "bl_getEtplOne");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			rtn = ssm.doSelect(args); // 조회
			
			setValue(rtn);
			setValue(cur);
			setMessage(msg.getMessage("7000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0000"));
		}
		
		return getSepoaOut();
    }
	
	public SepoaOut deleteEtpl(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteEtpl(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
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
	
	private String[] et_deleteEtpl(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		try
		{
			int iRet = 0;
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CU                 = bean_info[i][0];				
        		String ETPL_NO            = bean_info[i][1];
        		String PRG_STS            = bean_info[i][2];
        		String PRG_STS_OLD        = bean_info[i][3];
                                            
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				if("".equals(CU)){
//					sxp = new SepoaXmlParser(this, "et_deleteBzList_ctivSelect");
//					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//
//					args = new String[]{ BIZ_NO };
//					sf = new SepoaFormater(ssm.doSelect_limit(args));
//
//					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
//						throw new Exception("해당사업번호로 등록된 계약건이 존재하는 경우 삭제 불가합니다.");
//					}
//					
//					sxp = new SepoaXmlParser(this, "et_deleteBzList_bdhdSelect");
//					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//
//					args = new String[]{ BIZ_NO };
//					sf = new SepoaFormater(ssm.doSelect_limit(args));
//
//					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
//						throw new Exception("해당사업번호로 진행중인 입찰공문이 존재하는 경우 삭제 불가합니다.");
//					}
//					
//					sxp = new SepoaXmlParser(this, "et_deleteBzList_rqhdselect");
//					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//
//					sf = new SepoaFormater(ssm.doSelect_limit(args));
//
//					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
//						throw new Exception("견적 진행상태가 [견적중 또는 견적마감] 인 경우 삭제 불가합니다.");
//					}
					
					sxp = new SepoaXmlParser(this, "et_getEtCnt2");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ HOUSE_CODE, ETPL_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					if(Integer.parseInt(sf.getValue("CNT", 0)) > 0){
						throw new Exception("기술평가 내역이 존재하여 삭제가 불가합니다.");
					}
					
					
					args = new String[]{ ID, ID, HOUSE_CODE, ETPL_NO};
					types = new String[]{"S","S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_deleteEtpl");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    iRet = ssm.doUpdate(new String[][]{args}, types);
                    
					if(iRet <= 0){
						throw new Exception("삭제 실패 하였습니다.");
					}
					
					sxp = new SepoaXmlParser(this, "et_deleteEtck2");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    iRet = ssm.doUpdate(new String[][]{args}, types);
                    
					if(iRet < 0){
						throw new Exception("삭제 실패 하였습니다.");
					}
									
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	public SepoaOut saveEtplList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_saveEtplList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
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
	
	private String[] et_saveEtplList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CU                = bean_info[i][0];				
        		String EVAL_YY           = bean_info[i][1];				
        		String ETPL_NO	         = bean_info[i][2];				
        		String ETPL_NM           = bean_info[i][3];
        		String PRG_STS           = bean_info[i][4];
        		
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				//존재하면 Update
				if("C".equals(CU)){
					
					PRG_STS = "T"; 
					
					if( ETPL_NO == null || "".equals( ETPL_NO ) || ETPL_NO.length() < 1 ) { 
		            	so        = DocumentUtil.getDocNumber( info, "EP" );  
		            	ETPL_NO = so.result[0];		                
		            }
																			     
					args = new String[]{ info.getSession("HOUSE_CODE") , EVAL_YY, ETPL_NO, PRG_STS, ETPL_NM, info.getSession("ID"), info.getSession("ID")};
					types = new String[]{"S","S","S","S","S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_insertEtpl");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doInsert(new String[][]{args}, types);
					
				}else{
					
					args = new String[]{ EVAL_YY, PRG_STS, ETPL_NM, info.getSession("ID"), info.getSession("ID"), info.getSession("HOUSE_CODE"), ETPL_NO};
				    types = new String[]{"S","S","S","S","S","S","S"};
					
					sxp = new SepoaXmlParser(this, "et_updateEtpl_"+PRG_STS);
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);
                    
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	public SepoaOut getEtplDtList(Map< String, String > headerData, String etpl_no)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {

			sxp = new SepoaXmlParser(this, "getEtplDtList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  

		
            headerData.put( "etpl_no", etpl_no ); 
            
            setValue(ssm.doSelect(headerData));
 
            setStatus(1);
            setFlag(true);
        }catch (Exception e){
            setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }
        return getSepoaOut();
    }
	
	public SepoaOut getEtplDtList2(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext(); 

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {

			sxp = new SepoaXmlParser(this, "getEtplDtList2");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
            
            setValue(ssm.doSelect(headerData));
 
            setStatus(1);
            setFlag(true);
        }catch (Exception e){
            setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }
        return getSepoaOut();
    }
	
	public SepoaOut saveEtplDt(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_saveEtplDt(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
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
	
	private String[] et_saveEtplDt(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				
				String CU                = bean_info[i][0];				
        		String ETPL_NO           = bean_info[i][1];				
        		String ETPL_SEQ          = bean_info[i][2];				
        		String ES_CD             = bean_info[i][3];				
        		String ES_VER            = bean_info[i][4];				
        		String CSKD_GB           = bean_info[i][5];				
        		String CSKD_GB_NM        = bean_info[i][6];				
        		String GROUP1_CODE       = bean_info[i][7];				
        		String EVAL_USER_NAMES   = bean_info[i][8];				
        		String EVAL_USER_IDS     = bean_info[i][9];				
        		String EVAL_USER_CNT     = bean_info[i][10];        		
        		String EVAL_USER_NAMES_OLD = bean_info[i][11];				
        		String EVAL_USER_IDS_OLD   = bean_info[i][12];				
        		String EVAL_USER_CNT_OLD   = bean_info[i][13];
        		
        		
        	    
        		String[]  EVAL_USER_NAME = EVAL_USER_NAMES.split(",");
        		String[]  EVAL_USER_ID   = EVAL_USER_IDS.split(",");
        		int       iCnt           = Integer.parseInt(EVAL_USER_CNT);
        		
        		SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				//존재하면 Update
				if("".equals(ETPL_SEQ)){
					
					sxp = new SepoaXmlParser(this, "et_maxEtplSeq");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
					
					args = new String[]{ HOUSE_CODE, ETPL_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));
					ETPL_SEQ = sf.getValue("ETPL_SEQ", 0);
					
					args = new String[]{ HOUSE_CODE, ETPL_NO, ETPL_SEQ, ES_CD, ES_VER, CSKD_GB, ("05".equals(CSKD_GB))?"04":CSKD_GB, CSKD_GB_NM, ID, ID};
					types = new String[]{"S","S","S","S","S","S","S","S","S","S"};
					
                    sxp = new SepoaXmlParser(this, "et_insertEtck");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doInsert(new String[][]{args}, types);
                    
                    for (int j = 0; j < iCnt; j++)
                    {
                    	if(j == 0){
	                    	args = new String[]{ HOUSE_CODE, ETPL_NO, ETPL_SEQ};
	    					types = new String[]{"S","S","S"};
	    					
	                        sxp = new SepoaXmlParser(this, "et_deleteEtcp");
	                        ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
	                        ssm.doDelete(new String[][]{args}, types);
                    	}
                    	
                        args = new String[]{ HOUSE_CODE, ETPL_NO, ETPL_SEQ, EVAL_USER_ID[j], EVAL_USER_NAME[j]};
    					types = new String[]{"S","S","S","S","S"};
    					
                        sxp = new SepoaXmlParser(this, "et_insertEtcp");
                        ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                        ssm.doDelete(new String[][]{args}, types);                    	
        			}       
				}else{
					// 공종별 평가자들을 수정하기전에  수정전 평가자들 중에서 기술평가한 내역이 있는지 확인   //////////////////////////////////////////////////////////////////////////////////////
					if(EVAL_USER_CNT_OLD != null && !"".equals(EVAL_USER_CNT_OLD)){
						
						String[] aEVAL_USER_NAMES = EVAL_USER_NAMES.split(",");		
		        		String[] aEVAL_USER_IDS = EVAL_USER_IDS.split(",");	
		        		
						String[] aEVAL_USER_NAMES_OLD = EVAL_USER_NAMES_OLD.split(",");		
		        		String[] aEVAL_USER_IDS_OLD = EVAL_USER_IDS_OLD.split(",");	
		        		
		        		StringBuffer EVAL_USER_NAMES_CHK = new StringBuffer();		
		        		StringBuffer EVAL_USER_IDS_CHK = new StringBuffer();		
		        		int ckbCnt = 0;
		        		
		        		for (int a = 0; a < Integer.parseInt(EVAL_USER_CNT_OLD); a++)
						{
		        			ckbCnt = 0;
		        			
		        			for (int b = 0; b < Integer.parseInt(EVAL_USER_CNT); b++)
							{
		        				if(!aEVAL_USER_IDS_OLD[a].equals(aEVAL_USER_IDS[b])){
		        					ckbCnt++;
		        				}
							}
		        			
		        			if(ckbCnt == Integer.parseInt(EVAL_USER_CNT)){
		        				EVAL_USER_NAMES_CHK.append(aEVAL_USER_NAMES_OLD[a]);		        						        				
		        				EVAL_USER_IDS_CHK.append(aEVAL_USER_IDS_OLD[a]);
		        				
		        				EVAL_USER_NAMES_CHK.append(",");
		        				EVAL_USER_IDS_CHK.append(",");
		        			}
						}
		        		
		        		if(EVAL_USER_IDS_CHK.length() > 0){
		        			String[] aEVAL_USER_NAMES_CHK = EVAL_USER_NAMES_CHK.toString().substring(0,EVAL_USER_NAMES_CHK.length()-1).split(",");	
			        		String[] aEVAL_USER_IDS_CHK= EVAL_USER_IDS_CHK.toString().substring(0,EVAL_USER_IDS_CHK.length()-1).split(",");	
			        		
			        		
			        		for (int c = 0; c < aEVAL_USER_IDS_CHK.length; c++)
							{
								sxp = new SepoaXmlParser(this, "et_getEtCnt");
								ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
								
								args = new String[]{ HOUSE_CODE, ETPL_NO, ETPL_SEQ, aEVAL_USER_IDS_CHK[c] };
								sf = new SepoaFormater(ssm.doSelect_limit(args));
								
								if(Integer.parseInt(sf.getValue("CNT", 0)) > 0){               
									throw new Exception(aEVAL_USER_NAMES_CHK[c] + "의 기술평가를 삭제후 진행하세요."); 
								}                                                              
							}
		        		}
					}
					// 공종별 평가자들을 수정하기전에  수정전 평가자들 중에서 기술평가한 내역이 있는지 확인   //////////////////////////////////////////////////////////////////////////////////////
					
					
					args = new String[]{ ES_CD, ES_VER, CSKD_GB, ("05".equals(CSKD_GB))?"04":CSKD_GB, CSKD_GB_NM, ID, ID, HOUSE_CODE, ETPL_NO, ETPL_SEQ};
					types = new String[]{"S","S","S","S","S","S","S","S","S","S"};
					
					sxp = new SepoaXmlParser(this, "et_updateEtck");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types); 
                    
                    for (int j = 0; j < iCnt; j++)
                    {
                    	if(j == 0){
	                    	args = new String[]{ HOUSE_CODE, ETPL_NO, ETPL_SEQ};
	    					types = new String[]{"S","S","S"};
	    					
	                        sxp = new SepoaXmlParser(this, "et_deleteEtcp");
	                        ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
	                        ssm.doDelete(new String[][]{args}, types);
                    	}
                    	
                        args = new String[]{ HOUSE_CODE, ETPL_NO, ETPL_SEQ, EVAL_USER_ID[j], EVAL_USER_NAME[j]};
    					types = new String[]{"S","S","S","S","S"};
    					
                        sxp = new SepoaXmlParser(this, "et_insertEtcp");
                        ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                        ssm.doDelete(new String[][]{args}, types);                    	
        			}       
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	public SepoaOut deleteEtck(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteEtck(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
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
	
	private String[] et_deleteEtck(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		
		SepoaOut    so  = null;
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CU               = bean_info[i][0];				
        		String ETPL_NO          = bean_info[i][1];
        		String ETPL_SEQ         = bean_info[i][2];
        		
        		String EVAL_USER_NAMES  = bean_info[i][3];
        		String EVAL_USER_IDS    = bean_info[i][4];
        		String EVAL_USER_CNT    = bean_info[i][5];
        		
        		String EVAL_USER_NAMES_OLD  = bean_info[i][6];
        		String EVAL_USER_IDS_OLD    = bean_info[i][7];
        		String EVAL_USER_CNT_OLD    = bean_info[i][8];
        		
				
				
				String[] args = null;
				String[] types = null;
				if("".equals(CU)){
//					sxp = new SepoaXmlParser(this, "et_deleteBzList_ctivSelect");
//					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
//
//					args = new String[]{ BIZ_NO };
//					sf = new SepoaFormater(ssm.doSelect_limit(args));
//
//					if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
//						throw new Exception("해당사업번호로 등록된 계약건이 존재하는 경우 삭제 불가합니다.");
//					}
					
					if(EVAL_USER_CNT_OLD != null && !"".equals(EVAL_USER_CNT_OLD)){
						String[] aEVAL_USER_NAMES_OLD = EVAL_USER_NAMES_OLD.split(",");		
		        		String[] aEVAL_USER_IDS_OLD = EVAL_USER_IDS_OLD.split(",");		
		        		for (int j = 0; j < Integer.parseInt(EVAL_USER_CNT_OLD); j++)
						{
							sxp = new SepoaXmlParser(this, "et_getEtCnt");
							ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
							
							args = new String[]{ HOUSE_CODE, ETPL_NO, ETPL_SEQ, aEVAL_USER_IDS_OLD[j] };
							sf = new SepoaFormater(ssm.doSelect_limit(args));
							
							if(Integer.parseInt(sf.getValue("CNT", 0)) > 0){               
								throw new Exception(aEVAL_USER_NAMES_OLD[j] + "의 기술평가를 삭제후 진행하세요."); 
							}                                                              
						}
					}
					
					
					
									
					args = new String[]{ ID, ID, HOUSE_CODE, ETPL_NO, ETPL_SEQ};
					types = new String[]{"S","S","S","S","S"};
    		
                    sxp = new SepoaXmlParser(this, "et_deleteEtck");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);
				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	
	/* 기술평가대기 목록 */
	public SepoaOut getEtEvWaitList(Map<String, String> header) {
		try {
//			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
//			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getEtEvWaitList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getEtEvWaitList(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getEtEvWaitList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getEtEvWaitList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 기술평가 헤드정보 */
	public SepoaOut getTeEvalInfo(String etpl_no, String etpl_seq, String vendor_code) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("etpl_no", etpl_no);
			customHeader.put("etpl_seq", etpl_seq);
			customHeader.put("vendor_code", vendor_code);
		    String rtnHD = bl_getTeEvalInfo(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/* 기술평가 헤드정보*/
	private String bl_getTeEvalInfo(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getTeEvalInfo");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getTeEvalInfo:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 기술평가표 */
	public SepoaOut getTeEvalSheet(String es_cd, String es_ver) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("es_cd", es_cd);
			customHeader.put("es_ver", es_ver);
//			customHeader.put("cskd_gb", cskd_gb);
//			customHeader.put("vendor_code", vendor_code);
			String rtnHD = bl_getTeEvalSheet(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getTeEvalSheet(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getTeEvalSheet");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getTeEvalSheet:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	
	
	
	
	@SuppressWarnings("unchecked")
	public SepoaOut setEtSave(Map<String, Object> param) throws Exception{
		String                    add_user_id       =  info.getSession("ID");
        String                    house_code        =  info.getSession("HOUSE_CODE");
        String                    company           =  info.getSession("COMPANY_CODE");
        String                    add_user_dept     =  info.getSession("DEPARTMENT");
        String                    etNo              = null;
        String                    pr_tot_amt        = null;
        Map<String, String>       header            = MapUtils.getMap(param, "headerData"); // 조회 조건 조회
        Map<String, String>       etHdCreateParam   = null;
        Map<String, String>       etDtCreateParam   = null;
        Map<String, String>       gridInfo          = null;
        List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
        int                       hd_rtn            = 0;
        int                       dt_rtn            = 0;
        int                       gridSize          = grid.size();
        int                       i                 = 0;
        
    	etNo         = header.get("ET_NO");
    	
        try{
        	etHdCreateParam = this.etHdCreateParam(header);
            hd_rtn          = this.et_setEtHDCreate(etHdCreateParam);        
            if(hd_rtn < 1){
            	throw new Exception("기술평가 실패하였습니다.");
            }
            
            for(i = 0; i < gridSize; i++){
            	gridInfo        = grid.get(i);
            	etDtCreateParam = this.etDtCreateParam(header, gridInfo);
                dt_rtn          = this.et_setEtDTCreate(etDtCreateParam);                
                if(dt_rtn < 1){
                	throw new Exception("기술평가 실패하였습니다.");
                }
            }
            
            setStatus(1);
            setFlag(true);
            setValue(etNo);
            
            setMessage(etNo);	

            Commit();
        }
        catch(Exception e){
            try{
                Rollback();
            }
            catch(Exception d){
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setFlag(false);
            setMessage("기술평가 실패하였습니다.");
        }

        return getSepoaOut();
	}
	
	/**
	 * et_setEtHDCreate 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> etHdCreateParam(Map<String, String> header) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		
		result.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		result.put("ET_NO",               header.get("ET_NO"));
		
		result.put("VENDOR_CODE",         header.get("H_VENDOR_CODE"));
		result.put("VENDOR_NAME_LOC",     header.get("H_VENDOR_NAME_LOC"));
		result.put("ETPL_NO",             header.get("H_ETPL_NO"));
		result.put("ETPL_SEQ",            header.get("H_ETPL_SEQ"));
		result.put("CSKD_GB",             header.get("H_CSKD_GB"));
		result.put("CSKD_GB_NM",          header.get("H_CSKD_GB_NM"));
		result.put("GROUP1_CODE",         header.get("H_GROUP1_CODE"));
		result.put("GROUP1_NAME_LOC",     header.get("H_GROUP1_NAME_LOC"));
		result.put("GROUP2_CODE",         header.get("H_GROUP2_CODE"));
		result.put("GROUP2_NAME_LOC",     header.get("H_GROUP2_NAME_LOC"));
		
		result.put("ASC_SUM",             header.get("asc_sum"));
		result.put("REMARK",              header.get("remark"));		
		result.put("EVAL_USER_ID",        header.get("H_EVAL_USER_ID"));
		
		return result;
	}
	
	/**
	 * etDtCreateParam 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param head
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> etDtCreateParam(Map<String, String> header, Map<String, String> gridInfo) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		result.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		result.put("ET_NO",              header.get("ET_NO"));
		result.put("ET_SEQ",             gridInfo.get("ET_SEQ"));		
		result.put("ES_CD",              gridInfo.get("ES_CD"));
		result.put("ES_VER",             gridInfo.get("ES_VER"));
		result.put("ES_SEQ",             gridInfo.get("ES_SEQ"));
		result.put("ASC_GD",             gridInfo.get("ASC_GD"));
		result.put("ASC1",               gridInfo.get("ASC1"));
		
		return result;
	}
	
	private int et_setEtHDCreate(Map<String, String> param) throws Exception{
    	ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setEtHDCreate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doInsert(param);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	private int et_setEtDTCreate(Map<String, String> param) throws Exception{
		ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setEtDTCreate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            rtn = ssm.doInsert(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	/* 기술정보결과 */
	public SepoaOut getTeInfoRst(String et_no) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("et_no", et_no);
			String rtnHD = bl_getTeInfoRst(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/* 기술정보결과 */
	private String bl_getTeInfoRst(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getTeInfoRst");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getTeInfoRst:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 기술평가결과 */
	public SepoaOut getTeEvalRst(String et_no) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("et_no", et_no);
			String rtnHD = bl_getTeEvalRst(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/* 기술평가결과 */
	private String bl_getTeEvalRst(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getTeEvalRst");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getTeEvalRst:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	public SepoaOut setEtDelete(Map<String, Object> data) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			sxp = new SepoaXmlParser(this, "bl_getETPL_CNT");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
			sf = new SepoaFormater( ssm.doSelect( header ) );
            
            if( "0".equals( sf.getValue( "CNT" , 0 ) ) ){
                throw new Exception("해당 기술평가 건은  삭제 불가상태입니다.");
                
            } // end if
			
        	sxp = new SepoaXmlParser(this, "setEthdDelete");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doDelete(header);
        	
        	sxp = new SepoaXmlParser(this, "setEtdtDelete");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doDelete(header);
        	
        	Commit();
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			setMessage(e.getMessage().trim());
            setValue(e.getMessage().trim());
            setFlag(false);
            setStatus(0);
		}

		return getSepoaOut();
	}
	
	/* 기술평가결과 목록 */
	public SepoaOut getEtEvRstList(Map<String, String> header) {
		try {
//			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
//			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getEtEvRstList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getEtEvRstList(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getEtEvRstList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getEtEvRstList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	/* 기술평가 통계 */
	public SepoaOut getEtEvList2(Map<String, String> header) {
		try {
			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getEtEvList2(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getEtEvList2(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getEtEvList2");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getEtEvList2:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
} // END

