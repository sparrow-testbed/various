package	dt.app;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.fw.util.SepoaStringTokenizer;
import wisecommon.SignRequestInfo;


/**
 * 품의에 관한 모든 메서드를 다룬다
 * 단 품의결재승인에 관한 사항은 order.bpo.p2017을 참고한다.
 * @author tykim
 *
 */
public class p1062 extends SepoaService
{
	/**
	 * 발주생성 후 ICOYPRDT.PR_PROCEEDING_FLAG
	 * <pre>
	 * B로 업데이트한다.
	 * </pre>
	 */
	private String m_PO_PR_PROCEEDING_FLAG = "B";
	
	public p1062(String	opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
		setVersion("1.0.0");
	}

	/**
	 * 품의대기목록.
	 * <pre>
	 * -call method-
	 * et_getWaitList
	 * </pre>
	 * @param args
	 * @return
	 */
	public SepoaOut getWaitList(Map<String, String> header)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn = et_getWaitList(header);
			setValue(rtn);
 			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

	/**
	 * getWaitList에서 호출한다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
 	private	String et_getWaitList(Map<String, String>header) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		wxp.addVar("ctrl_code", header.get("ctrl_code"));
		wxp.addVar("pr_proceeding_flag", header.get("pr_proceeding_flag"));
		
		String addSql = "";
		
		
		
		if(!"".equals(header.get("ctrl_code"))){
			//AND	  DT.CTRL_CODE IN ($S{ctrl_code})	
			addSql = "AND	  DT.CTRL_CODE IN ('"+header.get("ctrl_code")+"')";
			wxp.addVar("ctrl_code_sql", addSql);
		}

		
		addSql = "";
		if(!"".equals(header.get("req_type"))){
			addSql = "AND   HD.REQ_TYPE IN ('"+header.get("req_type")+"','M')";
			wxp.addVar("req_type_sql", addSql);
		}
		
		
		header.put("house_code", info.getSession("HOUSE_CODE"));

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect(header);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	
 	/**
 	 * 상세품목등록 저장 : 존재여부 체크 후 INSERT/UPDATE
 	 * @param data
 	 * @return
 	 * @throws Exception
 	 */
	@SuppressWarnings("unchecked")
	public SepoaOut doSaveDocNo(Map<String, Object> data) throws Exception{
        ConnectionContext         ctx           = null;
		SepoaXmlParser            sxp1          = null;
		SepoaSQLManager           ssm1          = null;
		SepoaXmlParser            sxp2          = null;
		SepoaSQLManager           ssm2          = null;
		SepoaXmlParser            sxp3          = null;
		SepoaSQLManager           ssm3          = null;
		SepoaXmlParser            sxp4          = null;
		SepoaSQLManager           ssm4          = null;
		SepoaXmlParser            sxp5          = null;
		SepoaSQLManager           ssm5          = null;
		SepoaXmlParser            sxp6          = null;
		SepoaSQLManager           ssm6          = null;
		List<Map<String, String>> grid          = null;
		Map<String, String>       header        = null;
		Map<String, String>       gridInfo      = null;
		String                    houseCode     = info.getSession("HOUSE_CODE");
		String                    userId        = info.getSession("ID");
		String                    currDate      = SepoaDate.getShortDateString();
		String                    currTime      = SepoaDate.getShortTimeString();
		
		SepoaOut wo = null;
		String doc_no = null;
		
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			header = MapUtils.getMap(data, "headerData");
			
				
			
			
			//문서번호 체크 : 있으면 그대로 사용, 없으면 새로 채번
			doc_no = MapUtils.getString(header, "detail_doc_no", "");
			
			if( doc_no == null || "".equals(doc_no) ) {
				//문서번호 없으면 새로 채번
				wo = DocumentUtil.getDocNumber(info, "MTDS");
				doc_no = wo.result[0];
			}
			
			/*
			sxp1 = new SepoaXmlParser(this, "doSaveDocNo_01");
			ssm1 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp1);
			
			SepoaFormater sf1 = new SepoaFormater( ssm1.doSelect( header ) );
			
			int exist_cnt1 = Integer.valueOf( sf1.getValue("CNT", 0) );
			if(exist_cnt1 < 1) {
				//문서번호 없으면 새로 채번
				wo = DocumentUtil.getDocNumber(info, "MTDS");
				doc_no = wo.result[0];
			}
			*/
			
			header.put("DOC_NO", doc_no);
			
			
			// 상세품목등록 저장 (그리드 행의 수만큼 저장)
			for(int i = 0; i < grid.size(); i++) {
				
				gridInfo = grid.get(i);
				
				gridInfo.put("HOUSE_CODE",      houseCode);
            	gridInfo.put("USER_ID",         userId);
            	gridInfo.put("CURR_DATE",       currDate);
            	gridInfo.put("CURR_TIME",       currTime);
            	gridInfo.put("ITEM_STATUS",     "E" );
            	gridInfo.put("DOC_NO",          doc_no);
            	
            	// 실제 품목 존재여부 체크
                sxp2 = new SepoaXmlParser(this, "doSaveDocNo_02");
                ssm2 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp2);
                
                SepoaFormater sf2 = new SepoaFormater( ssm2.doSelect( gridInfo ) );
                
                int exist_cnt2 = Integer.valueOf( sf2.getValue("CNT", 0) );
                
                if(exist_cnt2 < 1) {// 실제 품목이 없으면 에러 처리
                	
                	throw new Exception("실제 품목코드["+ MapUtils.getString(gridInfo, "ITEM_NO") +"]가 존재하지 않습니다.");
                	
                } else {//실제 품목이 있으면 insert/update
                	
                	// 등록 전 ITEM_SEQ 채번
        			sxp3 = new SepoaXmlParser(this, "doSaveDocNo_03");
        			ssm3 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp3);
        			
        			SepoaFormater sf3 = new SepoaFormater( ssm3.doSelect( gridInfo ) );
        			
        			String max_item_seq = sf3.getValue("MAX_ITEM_SEQ", 0);
        			
        			if( MapUtils.getString(gridInfo, "ITEM_SEQ") == null || "".equals(MapUtils.getString(gridInfo, "ITEM_SEQ") ) ) {//그리드의 ITEM_SEQ가 없으면 최대값 ITEM_SEQ를 사용
        				gridInfo.put("ITEM_SEQ", max_item_seq );
//        				gridInfo.put("ITEM_SEQ", SepoaString.getLpad( String.valueOf(i + 1), 3, "0") );
        			}
        			
        			
        			// 데이터 유무 체크
        			sxp4 = new SepoaXmlParser(this, "doSaveDocNo_04");
        			ssm4 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp4);
        			
        			SepoaFormater sf4 = new SepoaFormater( ssm4.doSelect(gridInfo) );        			
        			
        			int exist_cnt4 = Integer.valueOf( sf4.getValue( "CNT", 0 ) );
        			
        			if( exist_cnt4 == 0 ) {
        				
        				// insert
        				sxp5 = new SepoaXmlParser(this, "doSaveDocNo_05");
        				ssm5 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp5);
        				
        				ssm5.doInsert(gridInfo);
        				
        			} else {
        				
        				// update
        				sxp6 = new SepoaXmlParser(this, "doSaveDocNo_06");
        				ssm6 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp6);
        				
        				ssm6.doUpdate(gridInfo);
        				
        			}
        			
                	
                }
                
            }
			
			Commit();
		}
		catch(Exception e){
			Rollback();
//			e.printStackTrace();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
    }
	
	
	@SuppressWarnings("unchecked")
	public SepoaOut doDeleteDocNo(Map<String, Object> data) throws Exception{
		ConnectionContext         ctx           = null;
		SepoaXmlParser            sxp           = null;
		SepoaSQLManager           ssm           = null;
		List<Map<String, String>> grid          = null;
		Map<String, String>       header        = null;
		Map<String, String>       gridInfo      = null;
		String                    houseCode     = info.getSession("HOUSE_CODE");
		String                    userId        = info.getSession("ID");
		String                    currDate      = SepoaDate.getShortDateString();
		String                    currTime      = SepoaDate.getShortTimeString();
		
		SepoaOut wo = null;
		String doc_no = null;
		
		setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			header = MapUtils.getMap(data, "headerData");
			
			
			//문서번호 체크 : 있으면 그대로 사용, 없으면 새로 채번
			doc_no = MapUtils.getString(header, "detail_doc_no", "");
			
			header.put("DOC_NO", doc_no);
			
			
			// 상세품목등록 저장 (그리드 행의 수만큼 저장)
			for(int i = 0; i < grid.size(); i++) {
				
				gridInfo = grid.get(i);
				
				gridInfo.put("HOUSE_CODE",      houseCode);
				gridInfo.put("USER_ID",         userId);
				gridInfo.put("CURR_DATE",       currDate);
				gridInfo.put("CURR_TIME",       currTime);
				gridInfo.put("DOC_NO",          doc_no);
				
				sxp = new SepoaXmlParser(this, "doDeleteDocNo");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				
				ssm.doDelete(gridInfo);
				
			}
			
			Commit();
		}
		catch(Exception e){
			Rollback();
//			e.printStackTrace();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}
		
		return getSepoaOut();
	}
 	
 	

	/**
	 * 액셀업로드 (ICOYBDVS 테이블 임시저장)
	 * MethodName : setExcelSavePurchaseLedgerInfo
	 * 작성일     : 2011. 03. 28
	 * Location   : sepoa.svc.master.MT_031.setExcelSavePurchaseLedgerInfo
	 * 서비스설명 : 엑셀등록
	 * 작성자     : 한영임
	 * 변경이력   :  
	 */
	public SepoaOut setExcelSavePurchaseLedgerInfo(String[][] setData, String house_code, String doc_no) throws Exception
 	{
		ConnectionContext ctx =	getConnectionContext();
 		
		SepoaFormater sf      = null;
		
		String result         = "";
		
 		StringBuffer sqlsb    = new StringBuffer();
 		StringBuffer datasb   = new StringBuffer();
 		ParamSql ps = new ParamSql(info.getSession("ID"), this, ctx);
 		
		String add_user_id    =  info.getSession("ID");
		String add_date       = SepoaDate.getShortDateString();
		String add_time       = SepoaDate.getShortTimeString();

		String HOUSE_CODE           = "";
		String DOC_NO               = "";
		String ITEM_SEQ             = "";
		
		String ITEM_NO              = "";
		String DESCRIPTION_LOC      = "";
		String UNIT_MEASURE         = "";
		String ITEM_QTY             = "";
		String UNIT_PRICE           = "";
		String ITEM_AMT             = "";
		String ITEM_STATUS          = "";
		
		int data_result = 0;
		int all_data_cnt = 0;

		try
      	{
      		setFlag(true);

    		Logger.debug.println("setData.length=="+setData.length);
    		
      		//등록
    		for(int i=0; i < setData.length; i++)
			{
/*
    			ITEM_NO          = setData[i][3];
    			DESCRIPTION_LOC  = setData[i][4];
    			UNIT_MEASURE     = setData[i][5];
    			ITEM_QTY         = setData[i][6];
    			UNIT_PRICE       = setData[i][7];
    			ITEM_AMT         = setData[i][8];
    			ITEM_STATUS      = setData[i][9];
  */  			
    			
    			ITEM_NO 		= setData[i][0];
    			ITEM_QTY        = setData[i][1];
    			UNIT_PRICE      = setData[i][2];
    			
    			/*
    			ps.removeAllValue();
    			sqlsb.delete(0, sqlsb.length());
      			sqlsb.append(" SELECT DESCRIPTION_LOC , UNIT_MEASURE  \n");
      			sqlsb.append(" FROM ICOMMTGL                   \n");
      			sqlsb.append(" WHERE ITEM_NO =  '"+ITEM_NO+"'  \n");
      			sqlsb.append("   AND STATUS IN ( 'C','R')      \n");
      			
      		
      			String rtnSel = ps.doSelect(String[]null);
      			sf = new SepoaFormater(rtnSel);
      			
      			*/
    			
    			String rtnSel = et_ITEMInfo(ITEM_NO);

      			sf = new SepoaFormater(rtnSel);
      			Logger.debug.println(" sf.getRowCount()=="+ sf.getRowCount());
  				
      			if( sf.getRowCount() > 0 ){
      				
      				UNIT_MEASURE    = sf.getValue(0,1);
      				DESCRIPTION_LOC = sf.getValue(0,0);
      				
      				Logger.debug.println("UNIT_MEASURE=="+ UNIT_MEASURE);
      				Logger.debug.println("DESCRIPTION_LOC=="+ DESCRIPTION_LOC);
      				
      	    		
      				ITEM_AMT = (Integer.parseInt(UNIT_PRICE) * Integer.parseInt(ITEM_QTY))+"";

      				Logger.debug.println("ITEM_AMT=="+ ITEM_AMT);

      				Logger.debug.println(" item_seq=="+  SepoaString.getLpad(String.valueOf(i+1), 3, "0"));
      				
	    			ps.removeAllValue();
	    			sqlsb.delete(0, sqlsb.length());
	      			sqlsb.append(" INSERT INTO ICOYBDVS ( \n");
	      			sqlsb.append("   HOUSE_CODE           \n");
	      			sqlsb.append("  ,DOC_NO               \n");
	      			sqlsb.append("  ,ITEM_SEQ             \n");
	      			sqlsb.append("  ,ITEM_NO              \n");
	      			sqlsb.append("  ,DESCRIPTION_LOC      \n");
	      			sqlsb.append("  ,UNIT_MEASURE         \n");
	      			sqlsb.append("  ,ITEM_QTY             \n");
	      			sqlsb.append("  ,UNIT_PRICE           \n");
	      			sqlsb.append("  ,ITEM_AMT             \n");
	      			sqlsb.append("  ,ITEM_STATUS          \n");
	      			sqlsb.append("  ,ADD_DATE             \n");
	      			sqlsb.append("  ,ADD_TIME             \n");
	      			sqlsb.append("  ,ADD_USER_ID          \n");
	      			sqlsb.append(" ) VALUES (             \n");
	      			sqlsb.append("   ?		              \n");ps.addStringParameter( house_code      );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( doc_no          );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( SepoaString.getLpad(String.valueOf(i+1), 3, "0") );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( ITEM_NO         );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( DESCRIPTION_LOC );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( UNIT_MEASURE    );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( ITEM_QTY        );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( UNIT_PRICE      );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( ITEM_AMT        );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( "T"  );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( add_date        );
	      			sqlsb.append("  ,?                    \n");ps.addStringParameter( add_time        );
	      			sqlsb.append("  ,?		              \n");ps.addStringParameter( add_user_id     );
	      			sqlsb.append(" )                      \n");
	      			data_result = ps.doInsert(sqlsb.toString());
	      			if(data_result > 0 ) all_data_cnt ++;
      			}
      			else{
      				
      				setMessage("[ " + ITEM_NO + " ]" +"품목코드가 존재하지 않습니다.");
      				setFlag(false);
      		        setStatus(0);
      				return  getSepoaOut();
      			}
			}
    		
    		setStatus(1);
    		
    		Commit();
	    	
    		if(setData.length != all_data_cnt) {
    			setMessage("엑셀업로드 결과 총 ["+String.valueOf(all_data_cnt)+"] 건이 변경 되었으며 총 ["+String.valueOf(setData.length - all_data_cnt)+"] 변경 실패하였습니다. ");
    		} else {
    			setMessage("엑셀업로드 결과 총 ["+String.valueOf(all_data_cnt)+"] 건이 변경 되었습니다.");
    		}
    		
    		Commit();
    		
	    } catch(Exception e) {
	        try { Rollback(); }
	        catch(Exception d) {
	            Logger.err.println(info.getSession("ID"),this,d.getMessage());
	        }

//	        e.printStackTrace();
	        Logger.err.println(info.getSession("ID"),this, e.getMessage());
	        setFlag(false);
	        setStatus(0);
	        setMessage(e.getMessage());
	    }

	    return getSepoaOut();
	}
 	
	
	
 	private	String et_ITEMInfo(String ITEM_NO) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("ITEM_NO", ITEM_NO);

		try {
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect((String[])null);//args);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
 	
 	
	/**
 	 * 품의를 생성한다.
 	 * <pre>
 	 * </pre>
 	 * @param sign_status
 	 * @param approval_str
 	 * @param ebidding_no
 	 * @param shipper_type
 	 * @param cur
 	 * @param objCNHD
 	 * @param objCNDT
 	 * @return
 	 * @throws Exception
 	 */
 	public SepoaOut setInsertEX(
			  String sign_status
			, String approval_str
			, String exec_no
			, String original_exec_no
			, String shipper_type
			, String cur
			, String exec_amt_krw
			, String[][] objCNHD
			, String[][] objCNDT
			, String dp_info
			, String[][] objPRDT
			, String gridModifyFlag
			, String del_pr_data
			, String remain_pr_data
			, String req_type
			) throws Exception
	{
		String add_user_id     =  info.getSession("ID");
		String house_code      =  info.getSession("HOUSE_CODE");
		String company         =  info.getSession("COMPANY_CODE");
		String add_user_dept   =  info.getSession("DEPARTMENT");
		String lang            =  info.getSession("LANGUAGE");

		String user_id         = info.getSession("ID");
      	Message msg = new Message(info, "STDRFQ");

      	
		
		
		
		
		
		
		
		
		
		
		
		
//		, String[][] objCNHD
//		, String[][] objPRDT
//		, String[][] objCNDT
      	

      	try
      	{
      		if(!"".equals(original_exec_no)){ // 품의수정시
      			String[][] params = {{house_code, original_exec_no}};
      			et_delEX(params);
          		et_delICOYCNDP(original_exec_no);
      		}


      		int rtn_rqhd = et_setICOYCNHD(objCNHD);
            if(rtn_rqhd<1)
            	throw new Exception("INSERT ICOYCNHD ERROR");

            // EXEC_NO를 가지고 STATUS = 'D' 이고 PR_SEQ 가 없는 건이 있는지를 먼저 조회 후 STASUS = 'D' 로 남겨진건이 없으면 남겨야한다.
            // 품의생성시 , 수정을 한경우 - 남겨야한다. --> 품의수정시 수정을 한경우, 안한경우 - STATUS = 'D' 가 아닌건들만 삭제 후 기존대로 재인서트
            // 품의생서시 수정을 안한경우 - 안남겨진다.
            // 품의생성시 수정을 안한경우 - 안넘겨진다. --> 품의수정시 수정을 안한경우 - 안남겨진다. --> 품의수정시 수정을 한경우 - 남겨야한다.
            
            // 소싱결과를 수정한 경우
            int rtn_cndt = -1;
            if("Y".equals(gridModifyFlag)){
            	String rtn_modified = et_getModified(exec_no);
                SepoaFormater wf = new SepoaFormater(rtn_modified);
                int STATUS_D_CNT 	= Integer.parseInt(wf.getValue("STATUS_D_CNT", 0));
                int PR_SEQ_NULL_CNT = Integer.parseInt(wf.getValue("PR_SEQ_NULL_CNT", 0));
                if(STATUS_D_CNT == 0 && PR_SEQ_NULL_CNT == 0){
                	// 1. 삭제된 데이터를 (del_pr_data)    STATUS = 'D' 인 상태로 인서트한다.
                	// 2. 기존데이터를(PR_SEQ가 있는 놈들)  STATUS = 'D' 인 상태로 인서트한다.
                	rtn_cndt = et_setICOYCNDT_UPDATE(del_pr_data, remain_pr_data, exec_no);
                }
            }
            
            int rtn_rqdt = et_setICOYCNDT(objCNDT);
            if(rtn_rqdt < 1) {
            	throw new Exception("INSERT ICOYCNDT ERROR");
            }
            
            if(rtn_rqdt == 1) {
            	int rtn_bdvs = et_setICOYBDVS_UPDATE(exec_no);
            }
            msg.setArg("EXEC_NO",exec_no);
            setStatus(1);
            setMessage(msg.getMessage("0066")); //품의번호가 저장되었습니다.
            
//            System.out.println("dp_info" + dp_info);
            
            //선급금정보
            if(dp_info != null && !dp_info.equals("")) {
            	int rtn_2 = -1;
				//첫번째 토큰 쪼개기
    			SepoaStringTokenizer st_2 = new SepoaStringTokenizer(dp_info, "$", false);
    			int cnts_2 = st_2.countTokens();
    			String[] mytoken_2 = new String[cnts_2];

    			for(int k=0;k<cnts_2;k++){
    			    mytoken_2[k] = st_2.nextToken().trim();
				    //두번재 토큰 쪼개기
    			    SepoaStringTokenizer st_3 = new SepoaStringTokenizer(mytoken_2[k], "||", false);
    			    int cnts_3 = st_3.countTokens();
    			    String[] mytoken_3 = new String[cnts_3];
            	    for(int j=0;j<cnts_3;j++){
    			        mytoken_3[j] = st_3.nextToken().trim();

    				}
            		String dp_seq          	= mytoken_3[0];
    				String dp_type	        = mytoken_3[1];
        			String dp_percent       = mytoken_3[2];
        			String dp_amt     		= mytoken_3[3];
        			String dp_pay_terms     = mytoken_3[4];
        			String dp_pay_terms_text= mytoken_3[5];
        			String FIRST_DEPOSIT	= mytoken_3[6];
					String FIRST_PERCENT    = mytoken_3[7];
					String CONTRACT_DEPOSIT = mytoken_3[8];
					String CONTRACT_PERCENT = mytoken_3[9];
					String MENGEL_DEPOSIT   = mytoken_3[10];
					String MENGEL_PERCENT   = mytoken_3[11];
					String DP_DIV   		= mytoken_3[12];
					String DP_CODE   		= mytoken_3[13];
					String DP_PLAN_DATE		= mytoken_3[14];
					String FIRST_METHOD		= mytoken_3[15];
					String CONTRACT_METHOD	= mytoken_3[16];
					String MENGEL_METHOD	= mytoken_3[17];
					String PRE_CONT_YN		= mytoken_3[18];

            		rtn_2 = et_setICOYCNDP(	dp_seq
											,dp_type
											,dp_percent
											,dp_amt
											,dp_pay_terms
											,dp_pay_terms_text
											,exec_no
            				            	,FIRST_DEPOSIT
											,FIRST_PERCENT
											,CONTRACT_DEPOSIT
											,CONTRACT_PERCENT
											,MENGEL_DEPOSIT
											,MENGEL_PERCENT
											,DP_DIV
											,DP_CODE
											,DP_PLAN_DATE.replaceAll("\\/", "").replaceAll("\\-", "")
											,PRE_CONT_YN
											,FIRST_METHOD
											,CONTRACT_METHOD
											,MENGEL_METHOD
            				            	);
            		if(rtn_2 < 0) {
            	        Logger.debug.println(user_id,this,"in_ICOYCNDP 생성시 에러(선급금정보)");
            	        throw new Exception("in_ICOYCNDP Error");
        			}
    			}
			}
            //info 정보를 만든다.(CNDT.AUTO_PO_FLAG 가 'Y' 인놈만.)-- 결재완료시에.
            //int rtn_info = et_setICOYINFO(exec_no);
            
            /* 작성완료상태 sign_status : 'E' 일 때는 품의 완료상태로
             * 그 외 결재상신, 저장 sign_status : 'P', 'T' 일때는 품의 저장 상태로 상태값을 지정합니다. 
             */
            String lsPrFlag = sign_status.equals("E") ? "B" : "A";
			int rtn1 = updatePR_PROCEEDING_FLAG(exec_no, lsPrFlag);
			
			/* #EX12. 결재 요청 처리가 없기에 결재요청을 사용하지 않습니다. ( 2012.06.25 )
			 *        단, Sepoa.properties에서 결재 옵션 수정시 아래 로직이 적용되어 결재 요청처리가 정상적으로 이루어집니다.
			 * */
            //결제요청
            // *변경내역* 
			if(sign_status.equals("P"))
            {
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("EX");
                sri.setDocName(objCNHD[0][27]);

                sri.setDocNo(exec_no);
                sri.setDocSeq("0");
                sri.setItemCount(objCNDT.length);
                sri.setSignStatus(sign_status);
                sri.setShipperType(shipper_type);
                sri.setCur(cur);
                sri.setTotalAmt(Double.parseDouble(exec_amt_krw));
                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
                int rtn = CreateApproval(info,sri);    //밑에 함수 실행

                if(rtn == 0) {
                    try {
                        Rollback();
                    } catch(Exception d) {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
                    return getSepoaOut();
                }
                setStatus(1);
                setFlag(true);
                setValue(exec_no);
                //msg.setArg("EXEC_NO",exec_no);
                setMessage("기안번호["+exec_no+"]으로 저장되었습니다."); //품의번호가 결재요청되었습니다.
            }
            Commit();
        } catch(Exception e) {
//        	System.out.println("eeeeeeeeeeeeeeeeeeeeeeeee");
//        	e.printStackTrace();
            try {
                Rollback();
            } catch(Exception d) {
//            	System.out.println("ddddddddddddddddddddddddddddddd");
//            	d.printStackTrace();	
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setFlag(false);
            setMessage(msg.getMessage("0003"));
        }
        return getSepoaOut();
	}

 	/*
	private SepoaOut et_Approval(SignResponseInfo inf) throws Exception
	{
		String user_id		 	= info.getSession("ID");
		String house_code	 	= info.getSession("HOUSE_CODE");
		String location_code 	= info.getSession("LOCATION_CODE");
		String department	 	= info.getSession("DEPARTMENT");
		String name_loc		 	= info.getSession("NAME_LOC");
		String name_eng		 	= info.getSession("NAME_ENG");
		String language		 	= info.getSession("LANGUAGE");
		String add_date     	= SepoaDate.getShortDateString();
		String add_time     	= SepoaDate.getShortTimeString();
		Logger.debug.println(user_id,this,"############## p1062.Approval Start ################");
		
		try {
			String sign_status	= inf.getSignStatus();
			String doc_type     = inf.getDocType(); // 품의에서 넘어	왔는지 계약금 쪽에서 넘어 왔는 Check.
			String sign_date	= inf.getSignDate();
			String sign_user_id	= inf.getSignUserId();
			
			String[] DOC_NO	      = inf.getDocNo();
			String[] DOC_SEQ	  = inf.getDocSeq();
			String[] SHIPPER_TYPE = inf.getShipperType();
			
			for(int	i=0;i <	DOC_NO.length;i++) {
				String[][] objPrdt = { {house_code, DOC_NO[i]} };
				String[][] objInfo = { {house_code, DOC_NO[i]} };
				String[][] objInfh = { {house_code, DOC_NO[i]} };
				String[] objExecInfo = {house_code, DOC_NO[i]};
				
				String rtn_mtgl="";
				String rtn_prtype="";
				*/
				/**
				 * 품의결재 승인시에
				 * 품의생성시 소싱결과에 대해서 수정이 있는경우  
				 * 1.CNDT 기존 PR_NO, PR_SEQ : STATUS = 'D'   인것들은 ICOYPRDT테이블에도 STATUS = 'D' 로 업데이트 쳐주고, PR_PROCEEDING_FLAG = 'R' 로 업데이트
				 * 2.CNDT 에 새로 추가된 건들은 PR_NO, STATUS != 'D' 의 것들을 MAX(PR_SEQ_ +10 로 CNDT에 업데이트하고 PRDT에 인서트한다.
				 */
				//1. 수정사항이 있는지 체크 CNDT.STASUS = 'D' AND CNDT.PR_SEQ IS NULL 인것이 있는지 찾는다.
				/*
 				String exec_no 		= DOC_NO[i];
				String rtn_modified = et_getModified(exec_no);
				
                SepoaFormater wf_modified = new SepoaFormater(rtn_modified);
                
                int STATUS_D_CNT 		= Integer.parseInt(wf_modified.getValue("STATUS_D_CNT", 0));
                int PR_SEQ_NULL_CNT 	= Integer.parseInt(wf_modified.getValue("PR_SEQ_NULL_CNT", 0));
                String REQ_TYPE			= wf_modified.getValue("REQ_TYPE", 0);
                String PREFERRED_BIDDER = wf_modified.getValue("PREFERRED_BIDDER", 0);
                
                if(STATUS_D_CNT != 0 && PR_SEQ_NULL_CNT != 0){
                	//2. ICOYPRDT 에 CNDT.STATUS = 'D' 인 PR_NO, PR_SEQ건에 대해서 PRDT.STATUS = 'D', PRDT.PR_PROCEEDING_FLAG = 'R' 로 업데이트
                	int rtn_updatePRDT = et_updatePRDT(exec_no);
                	//3. ICOYCNDT 에 CNDT.PR_SEQ 값을 MAX(PR_SEQ) + 10으로 업데이트한다.
                	int rtn_updateCNDT = et_updateCNDT(exec_no);
                	//4. ICOYPRDT 에 CNDT.STATUS != 'D' 가 아닌건들을 인서트한다.
                	int rtn_insertPRDT = et_insertPRDT(exec_no);
                }
                
                //우선협상품의인 경우에도 품의수정이 가능하므로 수정건만 반영하고  구매접수현황으로 보낸다.
                int rtn_prdt = -1;
				if("Y".equals(PREFERRED_BIDDER)){
					Logger.debug.println("============================= 우선협상품의결재최종승인 ===============================");
					//우선협상품의 : PR_PROCEEDING_FLAG = 'P'
					m_PO_PR_PROCEEDING_FLAG = "P";
					rtn_prdt = setPRDT(objPrdt);
					continue;
				}
				
				// PRDT 업데이트 일반품의 : PR_PROCEEDING_FLAG = 'B',     우선협상품의 : PR_PROCEEDING_FLAG = 'P'
				Logger.debug.println("============================= 일반품의결재최종승인 ===============================");
				m_PO_PR_PROCEEDING_FLAG = "B";
				rtn_prdt = setPRDT(objPrdt);
                
				//ICOMMTGL이 존재하는 경우에만 단가를 생성한다// 건수가 0 인경우도 존재할수 있음
				//품의생성시 품의구분이 단가계약일때 단가를 생성한다.
                rtn_mtgl = checkMtglItem(DOC_NO[i]);
                
                SepoaFormater  wf =  new SepoaFormater(rtn_mtgl);
                int iRowCount = wf.getRowCount();
                if(iRowCount>0) {
                	rtn_mtgl = wf.getValue("CNT", 0);
                }
			
                // ICOMMTGL이 존재하는 경우에만 단가를 생성한다 if end          		        		
                if(!rtn_mtgl.equals("0")){ // 사전지원단계의 정보도 가격정보로서 관리한다. 20100716			
                	//레벨별 단가삭제(DELETE ICOYINFO, ICOYINDR, ICOYINPR)
                	delInfoData(objExecInfo);
                	//새로운  단가생성(INSERT ICOYINFO, ICOYINDR)
                	createInfoData(objInfo);
                	//ICOYINFH(히스토리 테이블) 생성
                	createInfhData(objInfh);
                }
			}
		} catch(Exception e) {
			throw new Exception("et_Approval error"+e.getMessage());
		}
		
		return getSepoaOut();
	}
	*/
 	
 	/**
 	 * setInsertEX에서 호출한다.
 	 * <pre>
 	 * </pre>
 	 * @param args
 	 * @return
 	 * @throws Exception
 	 */
 	private int et_setICOYCNHD(String[][] args) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        String add_user_id  = info.getSession("ID");
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        
        try {
        	String[] type = {
        			 "S","S","S","S","S"
        			,"S","S","S","S","S"
        			,"S","N","N","N","S"
        			,"S","S","S","S","S"
        			,"S","S","S","S","S"
        			,"S","N","S","S","S"
        			,"S","S","S","S","S"
        			,"S","S","S","S","S"
        			,"S","S"
        		};
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doInsert(args,type);
        }
        catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

 	/**
 	 * setInsertEX에서 호출한다.
 	 * <pre>
 	 * 역경매일때 QUOTA_PERCENT가 NULL이 들어올 수 있다.
 	 * </pre>
 	 * @param args
 	 * @return
 	 * @throws Exception
 	 */
 	private int et_setICOYCNDT(String[][] args) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        String add_user_id  = info.getSession("ID");
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

        try {
        	String[] type = {
        			 "S","S","S","S","S" ,"S","S","S","S","S"
        			,"S","S","S","S","S" ,"N","S","S","S","S"
        			,"S","S","N","S","S" ,"S","N","S","N","S"
        			,"S","N","N","N","N" ,"S","S","S","S","S"
        			,"N","N","N","N","N" ,"S","S","S","S","N"
        			,"N","S","S","S","S" ,"S","S","S","S","S"
        			,"S","S","S","S"
        		};
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doInsert(args,type);
        } catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

 	
 	
 	/*
 	 * 조회된 기존 데이터중 삭제 되거나 남아있는건은 STATUS = 'D' 로 인서트한다.
 	 * */
 	private int et_setICOYBDVS_UPDATE(String exec_no) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        String add_user_id  = info.getSession("ID");
        
   

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code"		,info.getSession("HOUSE_CODE"));
        wxp.addVar("exec_no"		, exec_no);

        try {
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doUpdate((String[][])null,null);
        } catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
 	
 	
 	
 	/*
 	 * 조회된 기존 데이터중 삭제 되거나 남아있는건은 STATUS = 'D' 로 인서트한다.
 	 * */
 	private int et_setICOYCNDT_UPDATE(String del_pr_data, String remain_pr_data, String exec_no) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        String add_user_id  = info.getSession("ID");
        
        String[] del_pr_data_row = null;
		String[] del_pr_data_col = null;
		String[] remain_pr_data_row = null;
		String[] remain_pr_data_col = null;

		String inClause = "";
		if(!"".equals(del_pr_data)){
			del_pr_data_row =  del_pr_data.split(",");
			for(int i=0; i<del_pr_data_row.length; i++){
				del_pr_data_col = del_pr_data_row[i].split("-");
				inClause += "DT.PR_NO = '" + del_pr_data_col[0] + "' AND DT.PR_SEQ = '" + del_pr_data_col[1] + "'   OR   ";
			}
		}

		if(!"".equals(remain_pr_data)){
			remain_pr_data_row =  remain_pr_data.split(",");
			for(int i=0; i<remain_pr_data_row.length; i++){
				remain_pr_data_col = remain_pr_data_row[i].split("-");
				inClause += "DT.PR_NO = '" + remain_pr_data_col[0] + "' AND DT.PR_SEQ = '" + remain_pr_data_col[1] + "'   OR   ";
			}
		}

		int lastOR = inClause.lastIndexOf("OR");
		inClause = inClause.substring(0, lastOR);
		//Logger.debug.println("정상현 inClause : " + inClause);

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code"		,info.getSession("HOUSE_CODE"));
        wxp.addVar("pr_data"		, inClause);
        wxp.addVar("exec_no"		, exec_no);
        wxp.addVar("user_id"		, info.getSession("ID"));
        wxp.addVar("company_code"	, info.getSession("COMPANY_CODE"));

        try {
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doInsert((String[][])null,null);
        } catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

 	private int et_setICOYCNDP( String dp_seq
            ,String dp_type
            ,String dp_percent
            ,String dp_amt
            ,String dp_pay_terms
            ,String dp_pay_terms_text
            ,String exec_no
            ,String FIRST_DEPOSIT
            ,String FIRST_PERCENT
            ,String CONTRACT_DEPOSIT
            ,String CONTRACT_PERCENT
            ,String MENGEL_DEPOSIT
            ,String MENGEL_PERCENT
            ,String DP_DIV
            ,String DP_CODE
            ,String DP_PLAN_DATE
            ,String PRE_CONT_YN
            ,String FIRST_METHOD
			,String CONTRACT_METHOD
			,String MENGEL_METHOD
 	) throws Exception {
 		String house_code   = info.getSession("HOUSE_CODE");
 		String dept 	    = info.getSession("DEPARTMENT");
 		String dept_name    = info.getSession("DEPARTMENT_NAME_LOC");
 		String name_loc     = info.getSession("NAME_LOC");
 		String name_eng     = info.getSession("NAME_ENG");
 		String user_id      = info.getSession("ID");

 		ConnectionContext ctx = getConnectionContext();

 		String sys_date = SepoaDate.getShortDateString();
 		String sys_time = SepoaDate.getShortTimeString();

 		String rtn_value = "";

 		int rtn_1 = -1;

 		try {
 			dp_percent = dp_percent.equals("")?"0":dp_percent;
 			dp_amt = dp_amt.equals("")?"0":dp_amt;
 			FIRST_DEPOSIT=FIRST_DEPOSIT.equals("")?"0":FIRST_DEPOSIT;
 			FIRST_PERCENT=FIRST_PERCENT.equals("")?"0":FIRST_PERCENT;
 			CONTRACT_DEPOSIT=CONTRACT_DEPOSIT.equals("")?"0":CONTRACT_DEPOSIT;
 			CONTRACT_PERCENT=CONTRACT_PERCENT.equals("")?"0":CONTRACT_PERCENT;
 			MENGEL_DEPOSIT=MENGEL_DEPOSIT.equals("")?"0":MENGEL_DEPOSIT;
 			MENGEL_PERCENT=MENGEL_PERCENT.equals("")?"0":MENGEL_PERCENT;

 			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 			wxp.addVar("house_code", house_code);
 			wxp.addVar("exec_no", exec_no);
 			wxp.addVar("dp_seq", dp_seq);
 			wxp.addVar("sys_date", sys_date);
 			wxp.addVar("sys_time", sys_time);
 			wxp.addVar("user_id", user_id);
 			wxp.addVar("dept", dept);
 			wxp.addVar("dp_type", dp_type);
 			wxp.addVar("dp_percent", dp_percent);
 			wxp.addVar("dp_amt", dp_amt);
 			wxp.addVar("dp_pay_terms_text", dp_pay_terms_text);
 			wxp.addVar("dp_pay_terms", dp_pay_terms);
 			wxp.addVar("FIRST_DEPOSIT", FIRST_DEPOSIT);
 			wxp.addVar("FIRST_PERCENT", FIRST_PERCENT);
 			wxp.addVar("CONTRACT_DEPOSIT", CONTRACT_DEPOSIT);
 			wxp.addVar("CONTRACT_PERCENT", CONTRACT_PERCENT);
 			wxp.addVar("MENGEL_DEPOSIT", MENGEL_DEPOSIT);
 			wxp.addVar("MENGEL_PERCENT", MENGEL_PERCENT);
 			wxp.addVar("DP_DIV", DP_DIV);
 			wxp.addVar("DP_CODE", DP_CODE);
 			wxp.addVar("DP_PLAN_DATE", DP_PLAN_DATE);
 			wxp.addVar("PRE_CONT_YN", PRE_CONT_YN);
 			wxp.addVar("FIRST_METHOD", FIRST_METHOD);
 			wxp.addVar("CONTRACT_METHOD", CONTRACT_METHOD);
 			wxp.addVar("MENGEL_METHOD", MENGEL_METHOD);

 			SepoaSQLManager sm = null;
 			sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
 			rtn_1 = sm.doInsert((String[][])null, null);
 		} catch(Exception e) {
 			Rollback();
 			throw new Exception("in_ICOYCNDP:"+e.getMessage());
 		} finally{

 		}
 		return rtn_1;
	}


 	private int et_setICOYINFO(String EXEC_NO) throws Exception
	{
 		String HOUSE_CODE   = info.getSession("HOUSE_CODE");
 		ConnectionContext ctx = getConnectionContext();
 		int rtn_1 = -1;
 		try {
 			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
 			wxp.addVar("EXEC_NO", EXEC_NO);

 			SepoaSQLManager sm = null;
 			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
 			rtn_1 = sm.doInsert((String[][])null, null);

 		}catch(Exception e) {
 			Rollback();
 			throw new Exception("in_ICOYCNDP:"+e.getMessage());
 		} finally{

 		}
 		return rtn_1;
	}


 	/**
	 * 결재 정보를 요청한다.
	 * <pre>
	 * </pre>
	 * @param info
	 * @param sri
	 * @return
	 */
	private int CreateApproval(SepoaInfo info,SignRequestInfo sri) throws Exception  // 결재모듈에 필요한 생성부분 그대로 갖다 쓴다.
    { 
        Logger.debug.println(info.getSession("ID"),this,"##### CreateApproval #####");

        SepoaOut wo     = new SepoaOut();
        SepoaRemote ws  ;
        String nickName= "p6027";
        String conType = "NONDBJOB";
        String MethodName1 = "setConnectionContext";
        ConnectionContext ctx = getConnectionContext();

        try {
            Object[] obj1 = {ctx};
            String MethodName2 = "addSignRequest";
            Object[] obj2 = {sri};

            ws = new SepoaRemote(nickName,conType,info);
            ws.lookup(MethodName1,obj1);
            wo = ws.lookup(MethodName2,obj2);
        } catch(Exception e) {
            Logger.err.println("approval: = " + e.getMessage());
        }
        return wo.status ;
    }

	 /**
 	 * setInsertEX에서 호출한다.
 	 * 결재상신 OR 저장시 : 품의생성시 ICOYPRDT 의 PR_PROCEEDING_FLAG 를 A로 변경한다.
 	 * 결재없이 작성완료일 때 : 품의생성시 ICOYPRDT 의 PR_PROCEEDING_FLAG 를 B로 변경한다. ( 품의완료 상태 )
 	 * @param args
 	 * @throws Exception
 	 */
 	//private int updatePR_PROCEEDING_FLAG(String[][] args) throws Exception
	private int updatePR_PROCEEDING_FLAG(String exec_no, String pr_flag) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx 	= getConnectionContext();
        String lang            	=  info.getSession("LANGUAGE");
    	Message	msg	= new Message(info, "STDRFQ");

        String add_user_id  = info.getSession("ID");
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("exec_no", exec_no);
        wxp.addVar("user_id", info.getSession("ID"));
        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
        wxp.addVar("pr_flag",	pr_flag);

        try {
        	String[] type = {"S","S","S","S"};
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doUpdate((String[][])null,null);
            
            if(rtn < 1)
            	throw new Exception(msg.getMessage("0004"));
        } catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

 	/**
 	 * 품의생성시 헤더정보를 가져온다.
 	 * <pre>
 	 * </pre>
 	 * @param args
 	 * @return
 	 */
 	public SepoaOut getEXHDInfo(String[] args, String rfq_data)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try {
			String rtn = et_getEXHDInfo(args, rfq_data);
			setValue(rtn);
			
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

 	private	String et_getEXHDInfo(String[] args, String rfq_data) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("rfq_data", rfq_data);

		try {
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(args);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
 	
 	/**
 	 * 계약서를 결재요청합니다.
 	 * <pre>
 	 * </pre>
 	 * @param args
 	 * @return
 	 */
 	public SepoaOut getEXHDInfoForCont(String[] args, String rfq_data)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try {
			String rtn = et_getEXHDInfoFor(args, rfq_data, "CT");
			setValue(rtn);
			
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
 	
 	/**
 	 * 발주서를 결재요청합니다.
 	 * <pre>
 	 * </pre>
 	 * @param args
 	 * @return
 	 */
 	public SepoaOut getEXHDInfoForPo(String[] args, String rfq_data)
 	{
 		String lang = info.getSession("LANGUAGE");
 		Message msg = new Message(info, "STDCOMM");
 		
 		try {
 			String rtn = et_getEXHDInfoFor(args, rfq_data, "PO");
 			setValue(rtn);
 			
 			setStatus(1);
 			setMessage(msg.getMessage("0000"));
 		} catch(Exception e) {
 			Logger.err.println(info.getSession("ID"),this,e.getMessage());
 			setStatus(0);
 			setMessage(msg.getMessage("0001"));
 		}
 		return getSepoaOut();
 	}
 	
 	private	String et_getEXHDInfoFor(String[] args, String rfq_data, String type) throws	Exception
 	{
 		String rtn = null;
 		ConnectionContext ctx =	getConnectionContext();
 		String subQuery="";
 		
 		if(type.equals("CT")){
 			subQuery = "( SELECT BID_NO FROM ICOYECCT WHERE HOUSE_CODE ='" + info.getSession("HOUSE_CODE") + "' AND CONT_SEQ ='" +args[1]+ "' AND CONT_COUNT = '"+args[2]+"')" ;
 		}else if(type.equals("PO")){
 			subQuery = "( SELECT MAX(EXEC_NO) FROM ICOYPODT WHERE HOUSE_CODE ='" + info.getSession("HOUSE_CODE") + "' AND PO_NO ='" +args[1]+ "')" ;
 		}
 		
 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		wxp.addVar("rfq_data", rfq_data);
 		wxp.addVar("SUBQUERY", subQuery);
 		
 		String[] param = {info.getSession("HOUSE_CODE")};
 		try {
 			
 			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
 			rtn	= sm.doSelect(param);
 		} catch(Exception e) {
 			Logger.err.println(info.getSession("ID"),this,e.getMessage());
 			throw new Exception(e.getMessage());
 		}
 		return rtn;
 	}
 	
 	
 	/**
 	 * 상세품목등록 화면 조회
 	 * @param data
 	 * @return
 	 */
 	public SepoaOut getDetailItem(Map<String, String> data)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");
		
		String rtn="";

		try
		{
			
			rtn = et_getDetailItem(data);//상세품목등록 조회
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
 	
 	private	String et_getDetailItem(Map<String, String> data) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager sm = null;
		
		try
		{
			
			sxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			sm = new SepoaSQLManager(info.getSession("ID"), this , ctx, sxp.getQuery());

			rtn	= sm.doSelect(data);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
 	

 	/**
 	 * 품의 작성시 상세 내역을 호출한다.
 	 * et_getEXDTInfo를 호출한다.
 	 * @param args
 	 * @param rfq_dataQ
 	 * @return
 	 */
 	public SepoaOut getEXDTInfo(Map<String, String> header)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			
			String mode 	= "".equals(header.get("exec_no")) ? "insert" : "update";
			String pr_data 	= "".equals(header.get("exec_no")) ?  header.get("pr_data") : header.get("exec_no");
			
			header.put("mode"	, mode);
			header.put("pr_data", pr_data);
			
			
			
			String rtn="";
			//String mode = header.get("mode");
			if(mode.equals("insert")){
				rtn = et_getEXDTInfo(header);
			}else{
			 	rtn = et_getEXDTInfo_u(header);
			}
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}


 	/**
 	 * getEXDTInfo에서 호출한다.
 	 * 품의생성시에 디테일 내역을 조회한다.
 	 * 선정된 업체가 위로, 아닌 업체가 밑으로 나오게 되며 선정된 업체만 보여주고 싶을 경우
 	 * AND QTDT.SETTLE_FLAG = 'Y'로 추가한다.
 	 * IN 에서는 데이터를 바인딩 할 수 없다.
 	 * @param args
 	 * @param rfq_data
 	 * @return
 	 * @throws Exception
 	 */
 	private	String et_getEXDTInfo(Map<String, String> header) throws	Exception
	{
		String rtn = null;
		String condition = "";
		ConnectionContext ctx =	getConnectionContext();

		String[] pr_row = header.get("pr_data").split(",");
		for(int i=0; i<pr_row.length; i++){
			String[] pr_col = pr_row[i].split("-");
			
			if(i == pr_row.length -1){
				condition += "DT.PR_NO = '" + pr_col[0] + "' AND " + "DT.PR_SEQ = '" +  pr_col[1] + "'";
			}else {
				condition += "DT.PR_NO = '" + pr_col[0] + "' AND " + "DT.PR_SEQ = '" +  pr_col[1] + "'   OR   ";
			}
		}

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("pr_data", condition);
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect((String[])null);//args);

		}
		catch(Exception e)
		{
			
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	private	String et_getEXDTInfo_u(Map<String, String> header) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
   		String house_code   = info.getSession("HOUSE_CODE");

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("exec_no", header.get("exec_no"));

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect((String[])null);//args);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


 	/**
 	 * 대금지불 정보 조회
 	 */
 	public SepoaOut getCNDPInfo(Map<String, String> header)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn="";
			rtn = et_getCNDPInfo(header);
			setValue(rtn);
 			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
 	
 	/**
 	 * 대금지불정보 조회
 	 */
 	private	String et_getCNDPInfo(Map<String, String> header) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(header);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
 	
 	/**
 	 * 대금지불 정보 조회
 	 */
 	public SepoaOut getCNDPInfoSum(String[] args)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn="";
			rtn = et_getCNDPInfoSum(args);
			setValue(rtn);
 			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
 	
 	/**
 	 * 대금지불정보 조회
 	 */
 	private	String et_getCNDPInfoSum(String[] args) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(args);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
 	
 	
 	/**
 	 * 대금지불 정보 조회 ( 기존 계약 내역 )
 	 */
 	public SepoaOut getCNDPInfoCont(HashMap<String, String> paramMap)
 	{
 		String lang = info.getSession("LANGUAGE");
 		Message msg = new Message(info, "STDCOMM");
 		
 		try
 		{
 			String rtn="";
 			rtn = et_getCNDPInfoCont(paramMap);
 			setValue(rtn);
 			setStatus(1);
 			setMessage(msg.getMessage("0000"));
 		}
 		catch(Exception e)
 		{
 			Logger.err.println(info.getSession("ID"),this,e.getMessage());
 			setStatus(0);
 			setMessage(msg.getMessage("0001"));
 		}
 		return getSepoaOut();
 	}
 	
 	/**
 	 * 대금지불정보 조회( 기존 계약 )
 	 */
 	private	String et_getCNDPInfoCont(HashMap<String, String> paramMap) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code",     paramMap.get("house_code"));
        wxp.addVar("pre_cont_seq",   paramMap.get("pre_cont_seq"));
        wxp.addVar("pre_cont_count", paramMap.get("pre_cont_count"));

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect((String[])null);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	/**
	 * 품의현황을 조회한다.
	 * <pre>
	 * et_getEXList을 호출한다.
	 * </pre>
	 * @param args
	 * @return
	 */
	public SepoaOut getEXList(Map<String, String> header)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			header.put("house_code", info.getSession("HOUSE_CODE"));
			
			String rtn = et_getEXList( header);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	/**
	 * getEXList에서 호출한다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
 	private	String et_getEXList(Map<String, String> header) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
// 		Logger.err.println("★★★★★★★★★★★★★★★★★★★★"+args.length);

 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		wxp.addVar("ctrl_code", header.get("ctrl_code"));
 		wxp.addVar("PRBR", header.get("req_type"));
 		
		String addSql = "";
		if(!"".equals(header.get("ctrl_code"))){
			//AND	  DT.CTRL_CODE IN ($S{ctrl_code})	
			addSql = "AND CNHD.CTRL_CODE IN ('"+header.get("ctrl_code")+"')";
			wxp.addVar("ctrl_code_sql", addSql);
		}

		addSql = "";
		if(!"".equals(header.get("req_type"))){
			addSql = "AND PRHD.REQ_TYPE IN ('"+header.get("req_type")+"','M')";
			wxp.addVar("req_type_sql", addSql);
		}
 		

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(header);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	/**
 	 * 품의를 수정한다.
 	 * <pre>
 	 * </pre>
 	 * @param sign_status
 	 * @param approval_str
 	 * @param exec_no
 	 * @param shipper_type
 	 * @param cur
 	 * @param exec_amt_krw
 	 * @param objCNHD
 	 * @param objCNDT
 	 * @param objDelInfo
 	 * @return
 	 * @throws Exception
 	 */
 	public SepoaOut setUpdateEX(
			  String sign_status
			, String approval_str
			, String exec_no
			, String shipper_type
			, String cur
			, String exec_amt_krw
			, String[][] objCNHD
			, String[][] objCNDT
			, String[][] objDelInfo
			, String dp_info
			, String doc_seq
			) throws Exception
	{
 		String add_user_id     =  info.getSession("ID");
		String house_code      =  info.getSession("HOUSE_CODE");
		String company         =  info.getSession("COMPANY_CODE");
		String add_user_dept   =  info.getSession("DEPARTMENT");
		String lang            =  info.getSession("LANGUAGE");
		Message	msg	= new Message(info, "STDRFQ");

      	try
      	{
      		et_delEX(objDelInfo);
      		int rtn_rqhd = et_setICOYCNHD(objCNHD);
            if(rtn_rqhd<1)
            	throw new Exception("INSERT ICOYCNHD ERROR");
            int rtn_rqdt = et_setICOYCNDT(objCNDT);
            if(rtn_rqdt<1)
            	throw new Exception("INSERT ICOYCNDT ERROR");

            msg.setArg("EXEC_NO",exec_no);
            setStatus(1);
            setMessage(msg.getMessage("0066")); //품의번호가 저장되었습니다.
          	//
            //선급금정보
            //
            et_delICOYCNDP(exec_no);
            if(!dp_info.equals("")) {
            	int rtn_2 = -1;
            	//첫번째 토큰 쪼개기
    			SepoaStringTokenizer st_2 = new SepoaStringTokenizer(dp_info, "$", false);
    			int cnts_2 = st_2.countTokens();
    			String[] mytoken_2 = new String[cnts_2];
            	for(int k=0;k<cnts_2;k++){
            	    mytoken_2[k] = st_2.nextToken().trim();
            	    //두번재 토큰 쪼개기
    			    SepoaStringTokenizer st_3 = new SepoaStringTokenizer(mytoken_2[k], "||", false);
    			    int cnts_3 = st_3.countTokens();
    			    String[] mytoken_3 = new String[cnts_3];
            	    for(int j=0;j<cnts_3;j++){
    			        mytoken_3[j] = st_3.nextToken().trim();

    				}
    				String dp_seq          	= mytoken_3[0];
    				String dp_type	        = mytoken_3[1];
        			String dp_percent       = mytoken_3[2];
        			String dp_amt     		= mytoken_3[3];
        			String dp_pay_terms     = mytoken_3[4];
        			String dp_pay_terms_text= mytoken_3[5];
        			String FIRST_DEPOSIT	= mytoken_3[6];
					String FIRST_PERCENT    = mytoken_3[7];
					String CONTRACT_DEPOSIT = mytoken_3[8];
					String CONTRACT_PERCENT = mytoken_3[9];
					String MENGEL_DEPOSIT   = mytoken_3[10];
					String MENGEL_PERCENT   = mytoken_3[11];
					String DP_DIV   		= mytoken_3[12];
					String DP_CODE   		= mytoken_3[13];
					String DP_PLAN_DATE		= mytoken_3[14];
					String FIRST_METHOD		= mytoken_3[15];
					String CONTRACT_METHOD	= mytoken_3[16];
					String MENGEL_METHOD	= mytoken_3[17];
					String PRE_CONT_YN		= mytoken_3[18];

        			rtn_2 = et_setICOYCNDP(	dp_seq
											,dp_type
											,dp_percent
											,dp_amt
											,dp_pay_terms
											,dp_pay_terms_text
											,exec_no
            				            	,FIRST_DEPOSIT
											,FIRST_PERCENT
											,CONTRACT_DEPOSIT
											,CONTRACT_PERCENT
											,MENGEL_DEPOSIT
											,MENGEL_PERCENT
											,DP_DIV
											,DP_CODE
											,DP_PLAN_DATE
											,PRE_CONT_YN
											,FIRST_METHOD
											,CONTRACT_METHOD
											,MENGEL_METHOD
            				            	);
            	    if(rtn_2 < 0) {
            	        Logger.debug.println(add_user_id,this,"in_ICOYCNDP 생성시 에러(선급금정보)");
            	        throw new Exception("in_ICOYCNDP Error");
        			}
    			}

			}

            // *변경내역* 
            //  - LIGS는 품의시 결재처리를 하지 않습니다.
            if(sign_status.equals("P"))
            {
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("EX");
                sri.setDocNo(exec_no);
                sri.setDocSeq(doc_seq);
                sri.setItemCount(objCNDT.length);
                sri.setSignStatus(sign_status);
                sri.setShipperType(shipper_type);
                sri.setCur(cur);
                sri.setTotalAmt(Double.parseDouble(exec_amt_krw));
                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
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
                    setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
                    return getSepoaOut();
                }
                setStatus(1);
                setValue(exec_no);
                msg.setArg("EXEC_NO",exec_no);
                setMessage(msg.getMessage("0067")); //품의번호가 결재요청되었습니다.
            }
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0003"));
        }

        return getSepoaOut();
	}

 	/**
 	 * 품의 정보를 삭제한다.
 	 * <pre>
 	 * setUpdateEX에서 호출한다.
 	 *
 	 * </pre>
 	 * @param args
 	 * @return
 	 * @throws Exception
 	 */
 	private void et_delEX(String[][] args) throws Exception
    {
    	int rtn = 0;
    	String lang            =  info.getSession("LANGUAGE");
    	Message	msg	= new Message(info, "STDRFQ");

        ConnectionContext ctx = getConnectionContext();

        String add_user_id  = info.getSession("ID");

        SepoaXmlParser wxp_1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        SepoaXmlParser wxp_2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

        try
        {
        	String[] type = {
        			"S","S"
        		};

        	SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_1.getQuery());
            rtn = sm.doDelete(args,type);
            if(rtn<1)
            	throw new Exception(msg.getMessage("0002"));

            sm = new SepoaSQLManager(add_user_id, this, ctx, wxp_2.getQuery());
            rtn = sm.doDelete(args,type);
            if(rtn<1)
            	throw new Exception(msg.getMessage("0002"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }

    }

 	private int et_delICOYCNDP( String exec_no ) throws Exception
   	{
   		String house_code   = info.getSession("HOUSE_CODE");
   		String user_id		= info.getSession("ID");
   		ConnectionContext ctx = getConnectionContext();

		int rtn_1 = -1;

    	try {
    		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		wxp.addVar("house_code", house_code);
    		wxp.addVar("exec_no", exec_no);
    		/*
            StringBuffer tSQL = new StringBuffer();
            tSQL.append( "  DELETE ICOYCNDP         			 \n");
            tSQL.append( "  WHERE HOUSE_CODE = '"+house_code+"'  \n");
            tSQL.append( "  AND EXEC_NO      = '"+exec_no+"'     \n");
            */
            SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn_1 = sm.doDelete((String[][])null, null);

   		}catch(Exception e) {
    		Rollback();
			throw new Exception("in_ICOYCNDP:"+e.getMessage());
    	} finally{

		}
		return rtn_1;
	}

	/**
 	 * 품의를 삭제한다.
 	 * <pre>
 	 * 저장중인 데이터만 삭제할 수 있다.
 	 * et_setDeleteEx를 호출한다.
 	 * </pre>
 	 * @param exec_no
 	 * @param objCNHD
 	 * @return
 	 * @throws Exception
 	 */
 	public SepoaOut setDeleteEx(Map<String, Object> data) throws Exception
	{
		String lang =  info.getSession("LANGUAGE");
		Message	msg	= new Message(info, "STDRFQ");
		Map<String, String> header = null;
		Map<String, String> gridInfo  = null;
    	try
    	{
    		gridInfo = ((List<Map<String, String>>)MapUtils.getObject(data, "gridData")).get(0);
    		
    		gridInfo.put("house_code", info.getSession("HOUSE_CODE"));
    		gridInfo.put("add_user_id", info.getSession("ID"));
    		gridInfo.put("company_code", info.getSession("COMPANY_CODE"));
    		gridInfo.put("add_date", SepoaDate.getShortDateString());
    		gridInfo.put("add_time", SepoaDate.getShortTimeString());
    		
    		et_setDeleteEx(gridInfo);
    		
    		msg.setArg("EXEC_NO",gridInfo.get("EXEC_NO"));
            setStatus(1);
//            setMessage(msg.getMessage("0069")); //품의번호가 삭제되었습니다.
            setMessage("["+gridInfo.get("EXEC_NO")+"] 품의번호가 삭제되었습니다."); //품의번호가 삭제되었습니다.
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0003"));
        }

        return getSepoaOut();
	}

 	/**
 	 * setDeleteEx에서 호출한다.
 	 * @param args
 	 * @throws Exception
 	 */
 	private void et_setDeleteEx(Map<String, String> gridInfo) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        String lang            =  info.getSession("LANGUAGE");
        Message	msg	= new Message(info, "STDRFQ");

        String add_user_id  = info.getSession("ID");
        String house_code  = info.getSession("HOUSE_CODE");
        SepoaXmlParser wxp_1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        SepoaXmlParser wxp_2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
        SepoaXmlParser wxp_3 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_3");
//        wxp_3.addVar("house_code", house_code);

        /*
        StringBuffer tSQL = new StringBuffer();
        StringBuffer tSQL2 = new StringBuffer();
        StringBuffer tSQL3 = new StringBuffer();
        tSQL.append(" UPDATE ICOYCNHD SET      \n");
        tSQL.append("   STATUS = 'D'           \n");
        tSQL.append("   , CHANGE_USER_ID = ?   \n");
        tSQL.append("   , CHANGE_DATE = ?      \n");
        tSQL.append("   , CHANGE_TIME = ?      \n");
        tSQL.append(" WHERE HOUSE_CODE = ?     \n");
        tSQL.append(" AND EXEC_NO = ?          \n");

        tSQL2.append(" UPDATE ICOYCNDT SET      \n");
        tSQL2.append("   STATUS = 'D'           \n");
        tSQL2.append("   , CHANGE_USER_ID = ?   \n");
        tSQL2.append("   , CHANGE_DATE = ?      \n");
        tSQL2.append("   , CHANGE_TIME = ?      \n");
        tSQL2.append(" WHERE HOUSE_CODE = ?     \n");
        tSQL2.append(" AND EXEC_NO = ?          \n");

        tSQL3.append("	UPDATE ICOYPRDT SET                                     \n");
        tSQL3.append("		PR_PROCEEDING_FLAG = 'E'                            \n");
        tSQL3.append("		, CHANGE_USER_ID = ?                                \n");
        tSQL3.append("		, CHANGE_DATE = ?                                   \n");
        tSQL3.append("		, CHANGE_TIME = ?                                   \n");
        tSQL3.append("	WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'    \n");
        tSQL3.append("	  AND PR_NO		 = (SELECT MAX(PR_NO)                   \n");
        tSQL3.append("	  				    FROM ICOYCNDT                       \n");
        tSQL3.append("	  				    WHERE HOUSE_CODE = ?                \n");
        tSQL3.append("	  				      AND EXEC_NO	 = ?)				\n");
        */

        try
        {
        	String[] type = {
        			"S","S","S","S","S"
        		};
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp_1.getQuery());
            rtn = sm.doDelete(gridInfo);

            if(rtn<1)
            	throw new Exception(msg.getMessage("0004"));

            sm = new SepoaSQLManager(add_user_id, this, ctx, wxp_2.getQuery());
            rtn = sm.doDelete(gridInfo);

            if(rtn<1)
            	throw new Exception(msg.getMessage("0004"));

            sm = new SepoaSQLManager(add_user_id, this, ctx, wxp_3.getQuery());
            rtn = sm.doDelete(gridInfo);

            if(rtn<1)
            	throw new Exception(msg.getMessage("0004"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
    }

 	/**
	 * 품의히스토리현황을 조회한다.
	 * <pre>
	 * et_getEXHistoryList 호출한다.
	 * </pre>
	 * @param args
	 * @return
	 */
	public SepoaOut getEXHistoryList(String[] args, String ctrl_code)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn = et_getEXHistoryList(args,ctrl_code);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	/**
	 * getEXHistoryList 호출한다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
 	private	String et_getEXHistoryList(String[] args, String ctrl_code) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	    wxp.addVar("ctrl_code", ctrl_code);
	    /*
		StringBuffer tSQL = new StringBuffer();
		tSQL.append(" SELECT                                                                                          \n");
		tSQL.append("   HD.VERSION                                                                                	  \n");
		tSQL.append(" , HD.SIGN_STATUS                                                                                \n");
		tSQL.append(" , dbo.GETICOMCODE2(HD.HOUSE_CODE, 'M100', HD.SIGN_STATUS) AS SIGN_STATUS_TEXT           \n");
		tSQL.append(" , HD.EXEC_NO                                                                                    \n");
		tSQL.append(" , HD.SUBJECT                                                                                    \n");
		tSQL.append(" , HD.EXEC_FLAG                                                                                  \n");
		tSQL.append(" , dbo.GETICOMCODE2(HD.HOUSE_CODE, 'M035', HD.EXEC_FLAG) AS EXEC_FLAG_TEXT               \n");
		tSQL.append(" , HD.CHANGE_DATE                                                                                \n");
		tSQL.append(" , HD.SIGN_DATE                                                                                  \n");
		tSQL.append(" , (SELECT COUNT(DISTINCT VENDOR_CODE) FROM ICOYCNDT                                             \n");
		tSQL.append("    WHERE HOUSE_CODE = HD.HOUSE_CODE                                                             \n");
		tSQL.append("    AND EXEC_NO = HD.EXEC_NO                                                                     \n");
		tSQL.append("    AND SETTLE_FLAG = 'Y') AS SETTLE_VENDOR_COUNT                                                \n");
		tSQL.append(" , (SELECT MAX(CUR) FROM ICOYCNDT                                                                \n");
		tSQL.append("    WHERE HOUSE_CODE = HD.HOUSE_CODE                                                             \n");
		tSQL.append("    AND EXEC_NO = HD.EXEC_NO) AS CUR                                                             \n");
		tSQL.append(" , CAST(ROUND(HD.EXEC_AMT_KRW,1) AS DEC(22,0) )     AS EXEC_AMT_KRW                              \n");
		tSQL.append(" , HD.EXEC_AMT_USD                                                                               \n");
		tSQL.append(" , dbo.GETUSERNAMELOC(HD.HOUSE_CODE, HD.SIGN_PERSON_ID) AS SIGN_PERSON_ID                            \n");
		tSQL.append(" , HD.CTRL_CODE                                                                                  \n");
		tSQL.append(" , dbo.GETUSERNAMELOC(HD.HOUSE_CODE, HD.ADD_USER_ID) AS CTRL_NAME   								  \n");
		tSQL.append(" , HD.BID_TYPE                                                                                   \n");
		tSQL.append(" , (CASE HD.BID_TYPE                                                                             \n");
		tSQL.append("    WHEN 'EX' THEN '전자입찰'                                                                    \n");
		tSQL.append("    WHEN 'RA' THEN '역경매'                                                                      \n");
		tSQL.append("    WHEN 'RQ' THEN '견적'                                                                        \n");
		tSQL.append("    ELSE ''                                                                                      \n");
		tSQL.append("    END ) AS BID_TYPE_TEXT                                                                       \n");
		tSQL.append(" , HD.TTL_ITEM_QTY                                                                               \n");
		tSQL.append(" , dbo.getCNInfo(HD.HOUSE_CODE, HD.EXEC_NO, 'ITEM_COUNT') AS ITEM_COUNT                              \n");
		tSQL.append(" , HD.ATTACH_NO	                                                                              \n");
		tSQL.append(" , HD.REMARK       		                                                                      \n");
		tSQL.append(" , CP.PR_TYPE       		                                                                      \n");
		tSQL.append(" , CP.PR_TYPE_TEXT    		                                                                      \n");
//		tSQL.append(" , (SELECT DECODE(COUNT(*),0,'Y','N')                                                            \n");
//		tSQL.append("    FROM ICOYPODT                                                                                \n");
//		tSQL.append("    WHERE HOUSE_CODE = HD.HOUSE_CODE                                                             \n");
//		tSQL.append("      AND EXEC_NO    = HD.EXEC_NO                                                                \n");
//		tSQL.append("      AND STATUS     != 'D') AS DEL_FLAG														  \n");

		tSQL.append(" , ' ' AS DEL_FLAG														  \n");
		tSQL.append(" , HD.PO_TYPE                                                                                    \n");
		tSQL.append(" , dbo.GETICOMCODE2(HD.HOUSE_CODE, 'M204', HD.PO_TYPE) AS PO_TYPE_TEXT               				  \n");
		tSQL.append(" FROM ICOYCNHD_HIS HD, (SELECT DISTINCT CD.HOUSE_CODE											  \n");
		tSQL.append("						,CD.EXEC_NO                                                               \n");
		tSQL.append("						,PH.PR_TYPE                                                               \n");
		tSQL.append("						,dbo.GETICOMCODE2(PH.HOUSE_CODE, 'M138', PH.PR_TYPE) AS PR_TYPE_TEXT          \n");
		tSQL.append("				 	 FROM ICOYCNDT_HIS CD, ICOYPRHD PH                                            \n");
		tSQL.append("				 	 WHERE CD.HOUSE_CODE = PH.HOUSE_CODE                                          \n");
		tSQL.append("				 	   AND CD.PR_NO		 = PH.PR_NO                                               \n");
		tSQL.append("				 	   AND CD.STATUS <> 'D'                                                       \n");
		tSQL.append("				 	   AND PH.STATUS <> 'D') CP                               				  	  \n");
		tSQL.append("			WHERE HD.HOUSE_CODE = CP.HOUSE_CODE                                                   \n");
		tSQL.append("			  AND HD.EXEC_NO 	= CP.EXEC_NO													  \n");
		tSQL.append(" <OPT=F,S>   AND HD.HOUSE_CODE = ?         </OPT>                                                \n");
		tSQL.append(" <OPT=S,S>   AND HD.EXEC_NO = ?              </OPT>                                              \n");
		tSQL.append(" <OPT=F,S>   AND HD.CHANGE_DATE BETWEEN ?    </OPT>                                              \n");
		tSQL.append(" <OPT=F,S>   AND ?                           </OPT>                                              \n");
		tSQL.append(" 			  AND HD.CTRL_CODE IN ('"+ctrl_code+"')	                                              \n");
		tSQL.append(" <OPT=S,S>   AND HD.SIGN_STATUS = ?          </OPT>                                              \n");
		tSQL.append(" <OPT=S,S>   AND dbo.GETDEPTCODEBYID(HD.HOUSE_CODE, HD.COMPANY_CODE, HD.ADD_USER_ID) = ?       </OPT>\n");
		tSQL.append(" 			  AND HD.STATUS IN ('C','R')                                                          \n");
		*/
		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(args);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	public SepoaOut getQTAInfo( String exec_no)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn="";
			rtn = et_getQTAInfo(exec_no);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	/**
 	 * getEXDTInfo에서 호출한다.
 	 * <pre>
 	 * 품의생성시에 디테일 내역을 조회한다.
 	 * 선정된 업체가 위로, 아닌 업체가 밑으로 나오게 되며 선정된 업체만 보여주고 싶을 경우
 	 * AND QTDT.SETTLE_FLAG = 'Y'로 추가한다.
 	 * IN 에서는 데이터를 바인딩 할 수 없다.
 	 * </pre>
 	 * @param args
 	 * @param rfq_data
 	 * @return
 	 * @throws Exception
 	 */
 	private	String et_getQTAInfo(String exec_no) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("exec_no", exec_no);
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));


		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect((String[])null);//args);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	/**
 	 * @param doc_no
 	 * @return
 	 */
 	public SepoaOut getCndp(String doc_no, String dp_div) {
 		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");
 		try{

 			String rtn = et_getCndp(doc_no, dp_div);
 			setValue(rtn);
 			setStatus(1);
 			setMessage(msg.getMessage("0000"));
 		}catch(Exception e){
 			setStatus(0);
 			setMessage(msg.getMessage("0001"));
 			Logger.err.println(info.getSession("ID"),this,e.getMessage());
 		}
 		return getSepoaOut();
 	}

 	private	String et_getCndp(String doc_no, String dp_div) throws Exception {
 		String rtn = null;
 		ConnectionContext ctx = getConnectionContext();
 		String[] args = null;

 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 			wxp.addVar("doc_no", doc_no);
 			wxp.addVar("dp_div", dp_div);

 		try {

 			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
 			rtn = sm.doSelect(args);

 		}catch(Exception e) {
 			Logger.err.println(info.getSession("ID"),this,e.getMessage());
 			throw new Exception(e.getMessage());
 		}
 		return rtn;
 	}


 	public SepoaOut getRFQInfo( String exec_no)
	{
		String lang = info.getSession("LANGUAGE");
		//Message msg = new Message(info, "STDCOMM");

		try
		{
			String[] rtn= null;
			rtn = et_getRFQInfo(exec_no);
			Logger.debug.println("정상현 rtn[0] : " + rtn[0]);
			Logger.debug.println("정상현 rtn[1] : " + rtn[1]);
			setValue(rtn[0]);
 			setValue(rtn[1]);
			setStatus(1);
			//Logger.debug.println("정상현 : " + msg.getMessage("0000"));
			//setMessage("");

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			//setMessage("");
		}
		return getSepoaOut();
	}
	/**
 	 * getEXDTInfo에서 호출한다.
 	 * <pre>
 	 * 품의생성시에 디테일 내역을 조회한다.
 	 * 선정된 업체가 위로, 아닌 업체가 밑으로 나오게 되며 선정된 업체만 보여주고 싶을 경우
 	 * AND QTDT.SETTLE_FLAG = 'Y'로 추가한다.
 	 * IN 에서는 데이터를 바인딩 할 수 없다.
 	 * </pre>
 	 * @param args
 	 * @param rfq_data
 	 * @return
 	 * @throws Exception
 	 */
 	private	String[] et_getRFQInfo(String rfq_no) throws	Exception
	{
		String[] rtn = new String[2];
		String house_code = info.getSession("HOUSE_CODE");
		ConnectionContext ctx =	getConnectionContext();
		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
		wxp.addVar("rfq_no", rfq_no);
		wxp.addVar("house_code", house_code);
		/*
		tSQL.append(" SELECT VENDOR_CODE            							  \n");
		tSQL.append(" 		,dbo.GETVENDORNAME(HOUSE_CODE,VENDOR_CODE) AS VENDOR_NAME \n");
		tSQL.append(" FROM ICOYQTDT                 							  \n");
		tSQL.append(" WHERE RFQ_NO 		= '"+rfq_no+"'							  \n");
		tSQL.append("   AND HOUSE_CODE 	= '"+house_code+"'						  \n");
		tSQL.append("   AND STATUS  	IN ('C','R')							  \n");
		tSQL.append(" GROUP BY VENDOR_CODE,HOUSE_CODE							  \n");
		*/

		//입찰
		try {
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn[0] = sm.doSelect((String[])null);
			SepoaFormater wf = new SepoaFormater(rtn[0]);
			int rowCount = wf.getRowCount();
			StringBuffer tSQL2 = new StringBuffer();
			tSQL2.append("			SELECT   A.ITEM_NO 																								\n");
			tSQL2.append("					,A.DESCRIPTION_LOC                                                          							\n");
			tSQL2.append("					,A.SPECIFICATION                                                            							\n");
			tSQL2.append("					,A.MAKER_NAME                                                               							\n");
			tSQL2.append("					,NVL(A.RFQ_QTY,0) AS RFQ_QTY                                                                			\n");
			tSQL2.append("					,A.UNIT_MEASURE                                                             							\n");
			for (int i = 0; i < rowCount; i++) {
				tSQL2.append("					," + "NVL(B" + i + ".PRDT_UNIT_PRICE,0) AS " + "B" + i + "_CUSTOMER_PRICE							\n");
				tSQL2.append("					," + "NVL(B" + i + ".PR_AMT,0)   AS " + "B" + i + "_CUSTOMER_AMT                                   	\n");
				tSQL2.append("					," + "NVL(B" + i + ".UNIT_PRICE,0)     AS " + "B" + i + "_UNIT_PRICE                                \n");
				tSQL2.append("					," + "NVL(B" + i + ".ITEM_AMT,0)       AS " + "B" + i + "_ITEM_AMT                                  \n");
				tSQL2.append("					,NVL(ROUND(ROUND(" + "B" + i + ".DISCOUNT_RATE,2),5),0)  AS " + "B" + i + "_DISCOUNT_RATE           \n");
			}
			tSQL2.append("			FROM (SELECT RD.ITEM_NO                                                         								\n");
			tSQL2.append("			        	,RD.RFQ_NO                                                                                      	\n");
			tSQL2.append("			        	,RD.RFQ_SEQ	                                                                                      	\n");
			tSQL2.append("				        ,GETITEMDESC(RD.HOUSE_CODE, RD.ITEM_NO) AS DESCRIPTION_LOC          							\n");
			tSQL2.append("				        ,RD.SPECIFICATION                                                   								\n");
			tSQL2.append("				        ,RD.MAKER_NAME                                                      								\n");
			tSQL2.append("				        ,RD.RFQ_QTY                                                        									\n");
			tSQL2.append("				        ,RD.UNIT_MEASURE                                                    								\n");
			tSQL2.append("				  FROM ICOYRQDT RD                                                          								\n");
			tSQL2.append("				  WHERE RD.HOUSE_CODE  = '" + house_code + "'                                   							\n");
			tSQL2.append("				    AND RD.RFQ_NO      = '" + rfq_no + "'                                       							\n");
			tSQL2.append("				    AND RD.RFQ_COUNT   = (SELECT MAX(RFQ_COUNT)                             								\n");
			tSQL2.append("				    					    FROM ICOYRQHD                                   								\n");
			tSQL2.append("				    					    WHERE HOUSE_CODE = '" + house_code + "'             							\n");
			tSQL2.append("				    					      AND RFQ_NO     = '" + rfq_no + "')) A             							\n");
			for (int i = 0; i < rowCount; i++) {
				tSQL2.append("			,(SELECT QD.ITEM_NO                                                                           				\n");
				tSQL2.append("			        ,QD.RFQ_NO                                                                                      	\n");
				tSQL2.append("			        ,QD.RFQ_SEQ	                                                                                      	\n");
				tSQL2.append("			        ,QD.CUSTOMER_PRICE                                                                                  \n");
				tSQL2.append("			        ,ROUND(QD.CUSTOMER_PRICE * QD.ITEM_QTY,5)  AS CUSTOMER_AMT                                          \n");
				tSQL2.append("			        ,QD.UNIT_PRICE                                                                                      \n");
				tSQL2.append("			        ,QD.ITEM_AMT                                                                                        \n");
				tSQL2.append("			        ,ROUND((QD.CUSTOMER_PRICE * QD.ITEM_QTY - QD.ITEM_AMT)/ (CASE WHEN (QD.CUSTOMER_PRICE * QD.ITEM_QTY) = 0 THEN 1 ELSE (QD.CUSTOMER_PRICE * QD.ITEM_QTY) END) *100,5) AS DISCOUNT_RATE \n");
			  //tSQL2.append("			        ,CONVERT(NUMERIC(22,5),(QD.CUSTOMER_PRICE * QD.ITEM_QTY - QD.ITEM_AMT)/ (CASE WHEN (QD.CUSTOMER_PRICE * QD.ITEM_QTY) = 0 THEN 1 ELSE (QD.CUSTOMER_PRICE * QD.ITEM_QTY) END) *100) AS DISCOUNT_RATE \n");

				tSQL2.append("			        , PRDT.UNIT_PRICE PRDT_UNIT_PRICE                               									\n");
				tSQL2.append("			        , PRDT.PR_AMT                               														\n");
				tSQL2.append("			  FROM ICOYQTDT QD, ICOYRQDT RD, ICOYPRDT PRDT                                                              \n");
				tSQL2.append("			  WHERE QD.HOUSE_CODE  = RD.HOUSE_CODE                                                                      \n");
				tSQL2.append("			    AND QD.RFQ_NO      = RD.RFQ_NO                                                                          \n");
				tSQL2.append("			    AND QD.RFQ_SEQ     = RD.RFQ_SEQ                                                                         \n");
				tSQL2.append("			    AND QD.RFQ_count     = RD.RFQ_count                                                                     \n");
				tSQL2.append("			    AND QD.HOUSE_CODE  = '" + house_code + "'                                                               \n");
				tSQL2.append("			    AND QD.RFQ_NO      = '" + rfq_no + "'                                                                   \n");
				tSQL2.append("			    AND QD.VENDOR_CODE = '" + wf.getValue(i, 0) + "'                                                        \n");
				tSQL2.append("			    AND PRDT.HOUSE_CODE = RD.HOUSE_CODE                                                  					\n");
				tSQL2.append("			    AND PRDT.PR_NO = RD.PR_NO                                                  								\n");
				tSQL2.append("			    AND PRDT.PR_SEQ = RD.PR_SEQ                                                  							\n");
				tSQL2.append("			    AND QD.RFQ_COUNT   = (SELECT MAX(RFQ_COUNT)                                                             \n");
				tSQL2.append("			    					    FROM ICOYRQHD                                                                   \n");
				tSQL2.append("			    					    WHERE HOUSE_CODE = '" + house_code + "'                                         \n");
				tSQL2.append("			    					      AND RFQ_NO     = '" + rfq_no + "')) " + "B" + i + "							\n");
			}
			tSQL2.append("			WHERE A.RFQ_NO  = B0.RFQ_NO(+)																					\n");
			tSQL2.append("			  AND A.RFQ_SEQ = B0.RFQ_SEQ(+)																					\n");
			for (int i = 1; i < rowCount; i++) {
				tSQL2.append("			  AND A.RFQ_NO 	= B" + i + ".RFQ_NO(+)                                                                       \n");
				tSQL2.append("			  AND A.RFQ_SEQ = B" + i + ".RFQ_SEQ(+)                                                                      \n");
			}
			sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, tSQL2
					.toString());
			rtn[1] = sm.doSelect((String[])null);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	private	String et_getModified(String exec_no) throws Exception {
 		String rtn = null;
 		ConnectionContext ctx = getConnectionContext();
 		String[] args = null;

 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
 		wxp.addVar("exec_no", exec_no);

 		try {
 			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
 			rtn = sm.doSelect(args);
 		}catch(Exception e) {
 			Logger.err.println(info.getSession("ID"),this,e.getMessage());
 			throw new Exception(e.getMessage());
 		}
 		return rtn;
 	}

 	/**
	 * 통합품의대기현황을 조회한다.
	 * <pre>
	 * et_getTEXWaitList을 호출한다.
	 * </pre>
	 * @param args
	 * @return
	 */
	public SepoaOut getTEXWaitList(String[] args, String ctrl_code)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn = et_getTEXWaitList(args, ctrl_code);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	/**
	 * et_getgetTEXWaitList에서 호출한다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
 	private	String et_getTEXWaitList(String[] args, String ctrl_code) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
 		Logger.err.println("★★★★★★★★★★★★★★★★★★★★"+args.length);

 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 		wxp.addVar("ctrl_code", ctrl_code);

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(args);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


 	/**
	 * 통합품의현황을 조회한다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 */
	public SepoaOut getTEXList(String[] args)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn = et_getTEXList(args);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	/**
	 * et_getgetTEXWaitList에서 호출한다.
	 * <pre>
	 * </pre>
	 * @param args
	 * @return
	 * @throws Exception
	 */
 	private	String et_getTEXList(String[] args) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
 		Logger.err.println("★★★★★★★★★★★★★★★★★★★★"+args.length);

 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect(args);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}



 	/**
 	 * 통합품의 작성시 상세 내역을 호출한다.
 	 * et_getEXDTInfo를 호출한다.
 	 * @param args
 	 * @param rfq_dataQ
 	 * @return
 	 */
 	public SepoaOut getTEXDTInfo(String[] args, String exec_data, String mode)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn="";

			if(mode.equals("insert"))
				rtn = et_getTEXDTInfo(args, exec_data);
			else
			 	rtn = et_getTEXDTInfo_u(args, exec_data);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}


 	private	String et_getTEXDTInfo(String[] args, String exec_data) throws	Exception
	{
		String rtn = null;
		String condition = "";
		ConnectionContext ctx =	getConnectionContext();



		String[] exec_row = exec_data.split(",");
		for(int i=0; i<exec_row.length; i++){
			if(i == exec_row.length -1){
				condition += "'" + exec_row[i] + "'";
			}else {
				condition += "'" + exec_row[i] + "', ";
			}

		}
		

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("exec_data", condition);

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn	= sm.doSelect((String[])null);//args);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	private	String et_getTEXDTInfo_u(String[] args, String texec_no) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();
   		String house_code   = info.getSession("HOUSE_CODE");

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("house_code", house_code);
		wxp.addVar("texec_no", texec_no);

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect((String[])null);//args);
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


 	/**
 	 * 통합품의를 생성한다.
 	 * <pre>
 	 */
 	public SepoaOut setInsertTEX(
 			  String sign_status
 			, String approval_str
 			, String texec_no
 			, String original_texec_no
 			, String exec_amt_krw
 			, String[][] objTNHD
 			, String[][] objTNDT
			) throws Exception
	{
		String add_user_id     =  info.getSession("ID");
		String house_code      =  info.getSession("HOUSE_CODE");
		String company         =  info.getSession("COMPANY_CODE");
		String add_user_dept   =  info.getSession("DEPARTMENT");
		String lang            =  info.getSession("LANGUAGE");

		String user_id         = info.getSession("ID");
		Message	msg	= new Message(info, "STDRFQ");


      	try
      	{
      		if(!"".equals(original_texec_no)){ // 품의수정시
      			String[][] params = {{house_code, original_texec_no}};
      			et_delTEX(params);
      		}


      		int rtn_rqhd = et_setICOYTNHD(objTNHD);
            if(rtn_rqhd<1)
            	throw new Exception("INSERT ICOYTNHD ERROR");

            int rtn_rqdt = et_setICOYTNDT(objTNDT);
            if(rtn_rqdt<1)
            	throw new Exception("INSERT ICOYTNDT ERROR");

            msg.setArg("TEXEC_NO",texec_no);
            setStatus(1);
            setMessage(msg.getMessage("0074")); //통합품의번호가 저장되었습니다.

   			if(sign_status.equals("P"))
            {
                SignRequestInfo sri = new SignRequestInfo();
                sri.setHouseCode(house_code);
                sri.setCompanyCode(company);
                sri.setDept(add_user_dept);
                sri.setReqUserId(add_user_id);
                sri.setDocType("TEX");
                sri.setDocNo(texec_no);
                sri.setDocSeq("0");
                sri.setItemCount(objTNDT.length);
                sri.setSignStatus(sign_status);
                sri.setShipperType("D");
                sri.setCur("KRW");
                sri.setTotalAmt(Double.parseDouble(exec_amt_krw));
                sri.setSignString(approval_str); // AddParameter 에서 넘어온 정보
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
                    setMessage(msg.getMessage("0030")); //결재요청이 실패되었습니다.
                    return getSepoaOut();
                }
                setStatus(1);
                setValue(texec_no);
                msg.setArg("TEXEC_NO",texec_no);
                setMessage(msg.getMessage("0075")); //통합품의번호가 결재요청되었습니다.
            }
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0003"));
        }

        return getSepoaOut();
	}


 	/**
 	 * setInsertTEX에서 호출한다.
 	 * <pre>
 	 * </pre>
 	 * @param args
 	 * @return
 	 * @throws Exception
 	 */
 	private int et_setICOYTNHD(String[][] args) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        String add_user_id  = info.getSession("ID");

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

        try
        {
        	String[] type = {
        			 "S","S","S","S","S"
        			,"S","S","S","S","S"
        			,"S"
        		};

        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doInsert(args,type);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

 	/**
 	 * setInsertTEX에서 호출한다.
 	 * <pre>
 	 * </pre>
 	 * @param args
 	 * @return
 	 * @throws Exception
 	 */
 	private int et_setICOYTNDT(String[][] args) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();

        String add_user_id  = info.getSession("ID");
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

        try
        {
        	String[] type = {
        			  "S","S","S","S","S"
        			 ,"S","S","S"
        		};
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp.getQuery());
            rtn = sm.doInsert(args,type);
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }


 	/**
 	 * 통합품의 정보를 삭제한다.
 	 * <pre>
 	 * </pre>
 	 * @param args
 	 * @return
 	 * @throws Exception
 	 */
 	private void et_delTEX(String[][] args) throws Exception
    {
    	int rtn = 0;
    	String lang            =  info.getSession("LANGUAGE");
    	Message	msg	= new Message(info, "STDRFQ");

        ConnectionContext ctx = getConnectionContext();

        String add_user_id  = info.getSession("ID");

        SepoaXmlParser wxp_1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        SepoaXmlParser wxp_2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

        try
        {
        	String[] type = {
        			"S","S"
        		};

        	SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp_1.getQuery());
            rtn = sm.doDelete(args,type);
            if(rtn<1)
            	throw new Exception(msg.getMessage("0002"));

            sm = new SepoaSQLManager(add_user_id, this, ctx, wxp_2.getQuery());
            rtn = sm.doDelete(args,type);
            if(rtn<1)
            	throw new Exception(msg.getMessage("0002"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }

    }


 	/**
 	 * 통합품의를 삭제한다.
 	 * <pre>
 	 * 저장중인 데이터만 삭제할 수 있다.
 	 * </pre>
 	 * @return
 	 * @throws Exception
 	 */
 	public SepoaOut setDeleteTEX(
 				String texec_no
			,  	String[][] objTNHD
			) throws Exception
	{
		String lang =  info.getSession("LANGUAGE");
		Message	msg	= new Message(info, "STDRFQ");
    	try
    	{
    		et_setDeleteTEX(objTNHD);
    		msg.setArg("TEXEC_NO",texec_no);
            setStatus(1);
            setMessage(msg.getMessage("0076")); //통합품의번호가 삭제되었습니다.
            Commit();
        }
        catch(Exception e)
        {
            try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0003"));
        }

        return getSepoaOut();
	}

 	/**
 	 * setDeleteTEX에서 호출한다.
 	 * @param args
 	 * @throws Exception
 	 */
 	private void et_setDeleteTEX(String[][] args) throws Exception
    {
    	int rtn = 0;
        ConnectionContext ctx = getConnectionContext();
        String lang            =  info.getSession("LANGUAGE");
        Message	msg	= new Message(info, "STDRFQ");

        String add_user_id  = info.getSession("ID");
        String house_code  	= info.getSession("HOUSE_CODE");
        SepoaXmlParser wxp_1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        SepoaXmlParser wxp_2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

        try
        {
        	String[] type = {
        			"S","S","S","S","S"
        		};
        	SepoaSQLManager sm = new SepoaSQLManager(add_user_id, this, ctx, wxp_1.getQuery());
            rtn = sm.doDelete(args,type);

            if(rtn<1)
            	throw new Exception(msg.getMessage("0004"));

            sm = new SepoaSQLManager(add_user_id, this, ctx, wxp_2.getQuery());
            rtn = sm.doDelete(args,type);

            if(rtn<1)
            	throw new Exception(msg.getMessage("0004"));

            if(rtn<1)
            	throw new Exception(msg.getMessage("0004"));
        }
        catch(Exception e)
        {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
    }

 	public SepoaOut getEXDTInfo_2(String exec_no)
	{
		String lang = info.getSession("LANGUAGE");
		Message msg = new Message(info, "STDCOMM");

		try
		{
			String rtn="";

			rtn = et_getEXDTInfo_2(exec_no);
			setValue(rtn);
			rtn = et_getEXDTInfo_3(exec_no);
			setValue(rtn);

			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}

 	private	String et_getEXDTInfo_2(String exec_no) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("exec_no", exec_no);
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect((String[])null);//args);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	private	String et_getEXDTInfo_3(String exec_no) throws	Exception
	{
		String rtn = null;
		ConnectionContext ctx =	getConnectionContext();

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		wxp.addVar("exec_no", exec_no);
		wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		try
		{
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			rtn	= sm.doSelect((String[])null);//args);

		}
		catch(Exception e)
		{
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

 	public SepoaOut selectIcoyprdtGwList(Map<String, String> header){
		ConnectionContext ctx       = null;
		SepoaXmlParser    sxp       = null;
		SepoaSQLManager   ssm       = null;
		String            rtn       = null;
		String            id        = info.getSession("ID");
		String            houseCode = header.get("HOUSE_CODE");
		String            prNoSeq   = header.get("prNoSeq");
		Message           msg       = new Message(info, "STDCOMM");

		try {
			setStatus(1);
			setFlag(true);

			ctx = getConnectionContext();

			sxp = new SepoaXmlParser(this, "selectIcoyprdtGwList");

			sxp.addVar("HOUSE_CODE", houseCode);
			sxp.addVar("prNoSeq",    prNoSeq);

			ssm = new SepoaSQLManager(id, this, ctx, sxp);

			rtn = ssm.doSelect(header);

			setValue(rtn);
			setMessage((String) msg.getMessage("0000"));
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage((String) msg.getMessage("0001"));
		}

		return getSepoaOut();
	}
 	
 	private String select(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          result = null;
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doSelect(param);
		
		return result;
	}
 	
 	public SepoaOut selectGwPopUrl(Map<String, String> header){
		ConnectionContext ctx = null;
		String            rtn = null;
		Message           msg = new Message(info, "STDCOMM");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx    = getConnectionContext();
			rtn    = this.select(ctx, "selectGwPopUrl", header);
			
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
}