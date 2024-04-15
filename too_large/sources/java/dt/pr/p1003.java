package dt.pr;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import wisecommon.appcommon;

import com.icompia.util.*;

/**
 * <code>
 * 조회한다.....
 *
 * <pre>
 * (#)dt/pr/p1003.java  01/06/27
 * Copyright 2001-2001 ICOMPIA Co., Ltd. All Rights Reserved.
 * This software is the proprietary information of ICOMPIA Co., Ltd.
 * @version        1.0
 * @author         송지용
 * 사용함수 리스트
 *
 * [ getCatalog ]....................품번마스터 검색 ==> 조회
 * [ getDivision ]...................품번마스터 검색 ==> 종가정보 가져오기(하나만)
 * [ getMultiDivision ].............청구/ 배분율(종가모두)
 * [ getMultiDivision_exec ].....구매 / 배분율(종가모두)
 * [ getmyCatalog ]................my catalog select
 * [ getprinventory ]...............품번마스터 검색(Inventory에서 넘어온 데이타 조회)
 * [ setDelete_myCatalog ]......my catalog delete
 * [ setInsert_myCatalog ].......my catalog insert
 * [ setselect_myCatalog ]......my catalog insert 전 select
 * [ getStoreHDCatalog ]....................매점품번마스터 검색 ==> HD 조회
 * [ getStoreCatalog ]....................매점품번마스터 검색 ==> DT 조회
 * [getLoi]           --------------------Loi
 * </code></pre>
 */
public class p1003 extends SepoaService{
    /*
    청구관리 - 청구 - 청구생성 - 카탈로그 - 조회  ==> getCatalog(
    ==> getMultiDivision (
    ==> getMultiDivision_exec (

    */
	private Message msg;

    public p1003(String opt, SepoaInfo info) throws SepoaServiceException{
        super(opt,info);
        
        setVersion("1.0.0");
        
        msg = new Message(info, "p10_pra");
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
	
	private Map<String, String> getCatalogHeader(Map<String, String> header){
		String houseCode       = info.getSession("HOUSE_CODE");
		String companyCode     = info.getSession("COMPANY_CODE");
		String prLocation      = info.getSession("LOCATION_CODE");
		String ctrlCode        = info.getSession("CTRL_CODE");
		
		if(ctrlCode.length() == 0) {
			ctrlCode = "P01";
		}
		
		String userId          = info.getSession("ID");
		String defaultCtrlCode = CommonUtil.getConfig("wise.default.ctrl_code");
		String addDate         = SepoaDate.getShortDateString();
		String description     = header.get("DESCRIPTION");
		String descriptionText = header.get("DESCRIPTION_TEXT");
		String itemNo          = header.get("ITEM_NO");
		String descriptionKey  = null;
		
		if(prLocation.equals("")){ // 고정값이라 넣어는 주어야 겠고 어떤 값을 넣어야 할지 몰라서 select * from ICOMBAPR 해서 조회된 PR_LOCATION 값을 넣었음
			prLocation = "01";
		}
		
		if("LOC".equals(description)){
			descriptionKey = "DESCRIPTION_LOC";
		}
		else{
			descriptionKey = "DESCRIPTION_ENG";
		}
		
		header.put("HOUSE_CODE",        houseCode);
		header.put("COMPANY_CODE",      companyCode);
		header.put("PR_LOCATION",       prLocation);
		header.put("CTRL_CODE",         ctrlCode);
		header.put("USER_ID",           userId);
		header.put("DEFAULT_CTRL_CODE", defaultCtrlCode);
		header.put("add_date",          addDate);
		header.put("ITEM_NO",           itemNo);
		header.put(descriptionKey,      descriptionText);
		
		return header;
	}
	
	
	 /**
	 * 액셀업로드 (ICOYPRCT 테이블 임시저장)
	 * MethodName : setExcelSavePurchaseLedgerInfo
	 * 작성일     : 2011. 03. 28
	 * Location   : sepoa.svc.master.MT_031.setExcelSavePurchaseLedgerInfo
	 * 서비스설명 : 엑셀등록
	 * 작성자     : 한영임
	 * 변경이력   :  
	 */
	public SepoaOut setExcelUpload(String[][] setData, String transaction_id) throws Exception {
		
		ConnectionContext         ctx          = null;
		SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
        SepoaXmlParser            sxp1         = null;
		SepoaSQLManager           ssm1         = null;
		SepoaXmlParser            sxp2         = null;
		SepoaSQLManager           ssm2         = null;
		String                    id           = info.getSession("ID");
		String                    curr_date    = SepoaDate.getShortDateString();
		String                    curr_time    = SepoaDate.getShortTimeString();
		Map<String, String>       map     	   = null;
		setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		String strMsg = "성공적으로 처리하였습니다.";
		
		try{
			
			String ITEM_NO			  = "";
			String QTY                = "";
			String VENDOR_CODE        = "";
			String RD_DATE			  = "";
			String DELY_TO_ADDRESS_CD = "";
			
			//등록
   		for(int i=0; i < setData.length; i++) {

   			ITEM_NO 	    	= setData[i][0];
   			QTY                 = setData[i][1];
   			VENDOR_CODE         = setData[i][2];
   			RD_DATE             = setData[i][3];
   			DELY_TO_ADDRESS_CD  = setData[i][4];
            
            map = new HashMap<String, String>();
            
            map.put("TRANSACTION_ID", transaction_id);
            map.put("ITEM_NO", ITEM_NO);
            map.put("QTY", QTY);
            map.put("VENDOR_CODE", VENDOR_CODE);
            map.put("RD_DATE", RD_DATE);
            map.put("DELY_TO_ADDRESS_CD", DELY_TO_ADDRESS_CD);
            map.put("ADD_DATE", curr_date);
            map.put("ADD_TIME", curr_time);
            map.put("ADD_USER_ID", id);
            
            //저장하기 전에 실제로 존재하는 품목인지 체크
            sxp1 = new SepoaXmlParser(this, "doChectItemNo");
			ssm1 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp1);
			SepoaFormater sf1 = new SepoaFormater(ssm1.doSelect(map));
			int exist_cnt1 = Integer.valueOf( sf1.getValue("CNT", 0) );
			if( exist_cnt1 < 1 ) {
				strMsg = "실제로 존재하지 않는 품목이 있으면 처리할 수 없습니다.("+ ITEM_NO +")";
				throw new Exception("########## ERROR : NOT FOUND ITEM_NO ##########");
			}
            
			//저장하기 전에 실제로 존재하는 업체인지 체크
            sxp2 = new SepoaXmlParser(this, "doChectVendorCode");
			ssm2 = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp2);
			SepoaFormater sf2 = new SepoaFormater(ssm2.doSelect(map));
			int exist_cnt2 = Integer.valueOf( sf2.getValue("CNT", 0) );
			if( exist_cnt2 < 1 ) {
				strMsg = "실제로 존재하지 않는 업체가 있으면 처리할 수 없습니다.("+ VENDOR_CODE +")";
				throw new Exception("########## ERROR : NOT FOUND VENDOR_CODE ##########");
			}

			
			//저장
			sxp = new SepoaXmlParser(this, "setExcelUpload");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            ssm.doInsert(map);
	            
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
	        if(strMsg != null && !"".equals(strMsg)) {
	        	setMessage(strMsg);
	        } else {
	        	setMessage(e.getMessage());
	        }
	    }
	    return getSepoaOut();
	}
	
	
    /**
     * 구매관리 > 구매요청 > 액셀업로드 > 조회<br>
     * 액셀업로드 카탈로그 조회
     * @param header
     * @return
     */
	public SepoaOut getExcelCatalog(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            cur = null;
		
        try{
        	setStatus(1);
			setFlag(true);
			
        	ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "getExcelCatalog");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
			header = this.getCatalogHeader(header);
        	rtn    = ssm.doSelect(header);
        	cur    = et_getcur();
        	
            setValue(rtn);
            setValue(cur);
            setMessage(msg.getMessage("0000"));
        }
        catch(Exception e){
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }
	

    /*
     * 카탈로그 쿼리 개요
     * 기본적으로 MTGL을 기본으로 한다.(구매지역은 OUTER JOIN)
     * 구매쪽 정보를 얻으려면
     * ICOMMCPM에 MATERIAL_CLASS1과 MTGL의 MATERIAL_CLASS1이 조인되어야한다.
     * ICOMBAPR.PR_LOCATION과 ICOMLUSR.PR_LOCATION을 조인하여 사용자와 연결된 구매지역을 가져온다.
     * ICOMMCPM의 PURCHASE_LOCATION과 ICOMBAPR.PURCHASE_LOCATION을 조인하여
     * 사용자와 연결된 구매지역과 품목 일반정보의 품목을 가져올 수 있다.
     */
	public SepoaOut getCatalog(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            cur = null;
		
        try{
        	setStatus(1);
			setFlag(true);
			
        	ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_getCatalog");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
			header = this.getCatalogHeader(header);
        	rtn    = ssm.doSelect(header);
        	cur    = et_getcur();
        	
            setValue(rtn);
            setValue(cur);
            setMessage(msg.getMessage("0000"));
        }
        catch(Exception e){
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }
	
	 /*
     * 실사 카탈로그 쿼리 개요
     * 기본적으로 MTGL을 기본으로 한다.(구매지역은 OUTER JOIN)
     * 구매쪽 정보를 얻으려면
     * ICOMMCPM에 MATERIAL_CLASS1과 MTGL의 MATERIAL_CLASS1이 조인되어야한다.
     * ICOMBAPR.PR_LOCATION과 ICOMLUSR.PR_LOCATION을 조인하여 사용자와 연결된 구매지역을 가져온다.
     * ICOMMCPM의 PURCHASE_LOCATION과 ICOMBAPR.PURCHASE_LOCATION을 조인하여
     * 사용자와 연결된 구매지역과 품목 일반정보의 품목을 가져올 수 있다.
     */
	public SepoaOut getCatalogSo(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            cur = null;
		
        try{
        	setStatus(1);
			setFlag(true);
			
        	ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_getCatalogSo");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
			header = this.getCatalogHeader(header);
        	rtn    = ssm.doSelect(header);
        	cur    = et_getcur();
        	
            setValue(rtn);
            setValue(cur);
            setMessage(msg.getMessage("0000"));
        }
        catch(Exception e){
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }

	
    
    public SepoaOut getCatalog2( String[] args )
    {
        try
        {
        	String rtn = et_getCatalog2( args );
            setValue(rtn);
            String cur = et_getcur();
            setValue(cur);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }
    
    private String et_getCatalog2( String[] args) throws Exception {

        String rtn = "";
        String rtn1= "";
        String add_date     = SepoaDate.getShortDateString();
        try
        {
            ConnectionContext ctx = getConnectionContext();
            String HOUSE_CODE     =  info.getSession("HOUSE_CODE");
            String COMPANY_CODE   =  info.getSession("COMPANY_CODE");
            String PR_LOCATION    =  info.getSession("LOCATION_CODE");
            String[] CTRL_CODE      =  info.getSession("CTRL_CODE").split("&");
            String USER_ID        =  info.getSession("ID");
            String DEFAULT_CTRL_CODE = CommonUtil.getConfig("wise.default.ctrl_code");
            
            
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
			wxp.addVar("CTRL_CODE", CTRL_CODE[0]);
			wxp.addVar("DEFAULT_CTRL_CODE", DEFAULT_CTRL_CODE);
			wxp.addVar("COMPANY_CODE", COMPANY_CODE);
			wxp.addVar("add_date", add_date);
			wxp.addVar("PR_LOCATION", PR_LOCATION);
			wxp.addVar("USER_ID", USER_ID);

            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx, wxp.getQuery());
            rtn = sm.doSelect(args);
        }catch(Exception e)
        {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    public SepoaOut getCatalog3( String[] args )
    {
        try
        {
        	String rtn = et_getCatalog3( args );
            setValue(rtn);
            String cur = et_getcur();
            setValue(cur);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }
    
    private String et_getCatalog3( String[] args) throws Exception {

        String rtn = "";
        String rtn1= "";
        String add_date     = SepoaDate.getShortDateString();
        try
        {
            ConnectionContext ctx = getConnectionContext();
            String HOUSE_CODE     =  info.getSession("HOUSE_CODE");
            String COMPANY_CODE   =  info.getSession("COMPANY_CODE");
            String PR_LOCATION    =  info.getSession("LOCATION_CODE");
            String[] CTRL_CODE      =  info.getSession("CTRL_CODE").split("&");
            String USER_ID        =  info.getSession("ID");
            String DEFAULT_CTRL_CODE = CommonUtil.getConfig("wise.default.ctrl_code");
            
            
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
			wxp.addVar("CTRL_CODE", CTRL_CODE[0]);
			wxp.addVar("DEFAULT_CTRL_CODE", DEFAULT_CTRL_CODE);
			wxp.addVar("COMPANY_CODE", COMPANY_CODE);
			wxp.addVar("add_date", add_date);
			wxp.addVar("PR_LOCATION", PR_LOCATION);
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
            
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx, wxp.getQuery());
            rtn = sm.doSelect(args);
        }catch(Exception e)
        {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    public SepoaOut getCatalog4( String item_no,
    		String vendor_code )
    {
        try
        {
        	String rtn = et_getCatalog4( item_no, vendor_code);
            setValue(rtn);
            String cur = et_getcur();
            setValue(cur);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }
        catch(Exception e)
        {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }

        return getSepoaOut();
    }
    
    private String et_getCatalog4( String item_no,
    		String vendor_code) throws Exception {

        String rtn = "";
        String rtn1= "";
      
        SepoaXmlParser wxp = null;

        String add_date     = SepoaDate.getShortDateString();
        try
        {
            ConnectionContext ctx = getConnectionContext();
            String HOUSE_CODE     =  info.getSession("HOUSE_CODE");
            String COMPANY_CODE   =  info.getSession("COMPANY_CODE");
            String PR_LOCATION    =  info.getSession("LOCATION_CODE");
            String[] CTRL_CODE      =  info.getSession("CTRL_CODE").split("&");
            String USER_ID        =  info.getSession("ID");
            String DEFAULT_CTRL_CODE = CommonUtil.getConfig("wise.default.ctrl_code");
            
            if ( "".equals(vendor_code) || " ".equals(vendor_code) ) {
            	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");	
            } else {
            	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
            	wxp.addVar("VENDOR_CODE", vendor_code);
            }
            
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
			wxp.addVar("CTRL_CODE", CTRL_CODE[0]);
			wxp.addVar("DEFAULT_CTRL_CODE", DEFAULT_CTRL_CODE);
			wxp.addVar("COMPANY_CODE", COMPANY_CODE);
			wxp.addVar("add_date", add_date);
			wxp.addVar("PR_LOCATION", PR_LOCATION);
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);
			wxp.addVar("ITEM_NO", item_no);
            
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx, wxp.getQuery());
            rtn = sm.doSelect((String[])null);
        }catch(Exception e)
        {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
//	
//    public SepoaOut getCatalog1(String material_type,
//                           String material_ctrl_type,
//                           String material_class1,
//                           String material_class2,
//                           String material_class3,
//                           String item_no,
//                           String description_loc,
//                           String description_eng,
//                           String specification)
//    {
//        try{
//            String rtn = et_getCatalog1(material_type,material_ctrl_type,material_class1,material_class2,material_class3,item_no,description_loc,description_eng,specification,"PR");
//            setValue(rtn);
//            String cur = et_getcur();
//            setValue(cur);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//    
//    
//    public SepoaOut getLoi(String material_type,
//                           String material_ctrl_type,
//                           String material_class1,
//                           String material_class2,
//                           String material_class3,
//                           String item_no,
//                           String description_loc,
//                           String description_eng,
//                           String vendor_code)
//    {
//        try{
//            String rtn = et_getLoi(material_type,material_ctrl_type,material_class1,material_class2,material_class3,item_no,description_loc,description_eng,vendor_code,"PR");
//            setValue(rtn);
//            String cur = et_getcur();
//            setValue(cur);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//	public SepoaOut getMBom( String[] args )
//    {
//        try
//        {
//        	Logger.debug.println(info.getSession("ID"),this, "getCatalog..................");
//        	String rtn = et_getMBom( args );
//            setValue(rtn);
//            String cur = et_getcur();
//            setValue(cur);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }
//        catch(Exception e)
//        {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//    private String et_getMBom( String[] args) throws Exception {
//
//        String rtn = null;
//        StringBuffer tSQL = new StringBuffer();
//        // "+DBOwner+"
//        String DBOwner      = CommonUtil.getConfig("wise.generator.db.selfuser"); //function 명 앞에..
//        String add_date     = SepoaDate.getShortDateString();
//        try
//        {
//            ConnectionContext ctx = getConnectionContext();
//            String HOUSE_CODE     =  info.getSession("HOUSE_CODE");
//            String COMPANY_CODE   =  info.getSession("COMPANY_CODE");
//            String PR_LOCATION    =  info.getSession("LOCATION_CODE");
//            String DEFAULT_CTRL_CODE = CommonUtil.getConfig("wise.default.ctrl_code");
//
//            tSQL.append(" SELECT                                                                                                                        \n");
//            tSQL.append("       MTGL.MATERIAL_TYPE AS MATERIAL_TYPE                                                                                     \n");
//            tSQL.append("     , MTGL.MATERIAL_CTRL_TYPE AS MATERIAL_CTRL_TYPE                                                                           \n");
//            tSQL.append("     , MTGL.MATERIAL_CLASS1 AS MATERIAL_CLASS1                                                                                 \n");
//            tSQL.append("     , MTGL.ITEM_NO AS ITEM_NO                                                                                                 \n");
//            tSQL.append("     , MTGL.DESCRIPTION_LOC AS DESCRIPTION_LOC                                                                                 \n");
//            tSQL.append("     , MTGL.DESCRIPTION_ENG  AS DESCRIPTION_ENG                                                                                \n");
//            tSQL.append("     , MTGL.SPECIFICATION AS SPECIFICATION                                                                                     \n");
//            tSQL.append("     , CTRL.CTRL_PERSON_ID                                                                                                     \n");
//            tSQL.append("     , "+DBOwner+".CNV_NULL(CTRL.CTRL_TYPE,'P')  AS CTRL_TYPE                                                                  \n");
//            tSQL.append("     , CTRL.PURCHASE_LOCATION                                                                                                  \n");
//            tSQL.append("     , MTGL.BASIC_UNIT  AS BASIC_UNIT                                                                                          \n");
//            tSQL.append("     , "+DBOwner+".CNV_NULL(CTRL.CTRL_CODE,'"+DEFAULT_CTRL_CODE+"')  AS CTRL_CODE                                              \n");
//            tSQL.append("     , "+DBOwner+".CNV_NULL(MTGL.ITEM_BLOCK_FLAG,'N') AS ITEM_BLOCK_FLAG                                                       \n");
//            tSQL.append("     , MTGL.HOUSE_CODE                                                                                                         \n");
//            tSQL.append("     , "+DBOwner+".getDeptCodeByID(CTRL.HOUSE_CODE,'"+COMPANY_CODE+"',CTRL.CTRL_PERSON_ID) AS PURCHASE_DEPT                    \n");
//            tSQL.append("     , CTRL.PR_LOCATION                                                                                                        \n");
//            tSQL.append("     , "+DBOwner+".GETUSERNAME(CTRL.HOUSE_CODE, CTRL.CTRL_PERSON_ID,'LOC') AS PURCHASER_NAME                                   \n");
//            tSQL.append("     , "+DBOwner+".GETICOMCODE2(CTRL.HOUSE_CODE, 'M039', CTRL.PURCHASE_LOCATION) AS PURCHASE_LOCATION_NAME                     \n");
//            tSQL.append("     , "+DBOwner+".getDeptNameByID(CTRL.HOUSE_CODE, '"+COMPANY_CODE+"', CTRL.CTRL_PERSON_ID) AS PURCHASE_DEPT_NAME             \n");
//            tSQL.append("     , "+DBOwner+".getCatalogListPrice(CTRL.HOUSE_CODE, CTRL.PURCHASE_LOCATION, MTGL.ITEM_NO, 0, '"+add_date+"') AS PREV_UNIT_PRICE \n");
//            tSQL.append("     , MBOM.rd_date AS DELIVERY_IT			\n");
//            tSQL.append("	  , MBOM.ITEM_QTY												\n");
//            tSQL.append(" FROM ICOZMBOM MBOM, ICOMMTGL MTGL LEFT OUTER JOIN                 \n");
//            tSQL.append("    ( SELECT                                                       \n");
//            tSQL.append("          DISTINCT  BACP.CTRL_PERSON_ID,                           \n");
//            tSQL.append("          MCPM.HOUSE_CODE,                                         \n");
//            tSQL.append("          MCPM.MATERIAL_CLASS1,                                    \n");
//            tSQL.append("          MCPM.CTRL_CODE,                                          \n");
//            tSQL.append("          "+DBOwner+".CNV_NULL(BAPR.PURCHASE_LOCATION,'00') AS PURCHASE_LOCATION, \n");
//            tSQL.append("          BAPR.PR_LOCATION,                                        \n");
//            tSQL.append("          MCPM.CTRL_TYPE                                           \n");
//            tSQL.append("      FROM   ICOMMCPM MCPM,                                        \n");
//            tSQL.append("             ICOMBACP BACP,                                        \n");
//            tSQL.append("             ICOMBAPR BAPR,                                        \n");
//            tSQL.append("             ICOMCODE CODE                                         \n");
//            tSQL.append("      WHERE    BAPR.HOUSE_CODE        =  '"+HOUSE_CODE+"'          \n");
//            tSQL.append("          AND  BAPR.PR_LOCATION       =  '"+PR_LOCATION+"'         \n");
//            tSQL.append("          AND  MCPM.HOUSE_CODE        =  BAPR.HOUSE_CODE           \n");
//            tSQL.append("          AND  MCPM.PURCHASE_LOCATION =  BAPR.PURCHASE_LOCATION    \n");
//            tSQL.append("          AND  BACP.HOUSE_CODE        =  MCPM.HOUSE_CODE           \n");
//            tSQL.append("          AND  MCPM.CTRL_CODE         =  BACP.CTRL_CODE            \n");
//            tSQL.append("          AND  MCPM.CTRL_TYPE         =  BACP.CTRL_TYPE            \n");
//            tSQL.append("          AND  BAPR.STATUS            IN ('C','R')                 \n");
//            tSQL.append("          AND  MCPM.STATUS            IN ('C','R')                 \n");
//            tSQL.append("          AND  BACP.STATUS            IN ('C','R')                 \n");
//            tSQL.append("          AND  CODE.HOUSE_CODE        =  '"+HOUSE_CODE+"'          \n");
//            tSQL.append("          AND  CODE.TYPE              =  'M042'                    \n");
//            tSQL.append("          AND  MCPM.MATERIAL_CLASS1   =  CODE.CODE                 \n");
//            tSQL.append("    ) CTRL                                                         \n");
//            tSQL.append("    ON    MTGL.HOUSE_CODE       = CTRL.HOUSE_CODE                  \n");
//            tSQL.append("    AND   MTGL.MATERIAL_CLASS1  = CTRL.MATERIAL_CLASS1             \n");
//            tSQL.append("WHERE  MBOM.HOUSE_CODE = MTGL.HOUSE_CODE                           \n");
// 			tSQL.append("	AND MBOM.ITEM_NO = MTGL.ITEM_NO									\n");
//            tSQL.append(" 	AND MBOM.HOUSE_CODE       = '"+HOUSE_CODE+"'                    \n");
//            tSQL.append("   <OPT=S,S> AND MTGL.MATERIAL_TYPE       =  ? </OPT>         		\n");
//            tSQL.append("   <OPT=S,S> AND MTGL.MATERIAL_CTRL_TYPE  =  ? </OPT>         		\n");
//            tSQL.append("   <OPT=S,S> AND MTGL.MATERIAL_CLASS1     =  ? </OPT>         		\n");
//            tSQL.append("   <OPT=S,S> AND MTGL.ITEM_NO             =  ? </OPT>         		\n");
//            tSQL.append("   <OPT=S,S> AND MTGL.DESCRIPTION_LOC     =  ? </OPT>         		\n");
//            tSQL.append("   <OPT=S,S> AND MTGL.DESCRIPTION_ENG     =  ? </OPT>         		\n");
//            tSQL.append("   <OPT=S,S> AND MTGL.SPECIFICATION       =  ? </OPT>         		\n");
//            tSQL.append("   <OPT=F,S> AND MBOM.Z_CODE1       	=  ? </OPT>         		\n");
//            tSQL.append("	AND NOT EXISTS ( SELECT HOUSE_CODE FROM ICOYPRDT              	\n");
// 			tSQL.append("			WHERE HOUSE_CODE = MTGL.HOUSE_CODE                      \n");
// 			tSQL.append("			AND ITEM_NO = MTGL.ITEM_NO                              \n");
// 			tSQL.append("		<OPT=F,S> 	AND Z_CODE1 =  ? </OPT>                         \n");
// 			tSQL.append("			AND STATUS <> 'D' )                                     \n");
//            tSQL.append(" 	AND MTGL.STATUS IN ('C','R')                                   	\n");
//            tSQL.append(" ORDER   BY   MATERIAL_TYPE,                                       \n");
//            tSQL.append("              MATERIAL_CTRL_TYPE,                                  \n");
//            tSQL.append("              MATERIAL_CLASS1,                                     \n");
//            tSQL.append("              ITEM_NO                                              \n");
//
//
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,tSQL.toString());
//            rtn = sm.doSelect(args);
//        }
//        catch(Exception e)
//        {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//
//
//
//    public SepoaOut getprinventory(String data)
//    {
//        try{
//        	String[] args = {null,null,null,data,null,null,null,null,null,"INV"};
//            String rtn = et_getCatalog(args);
//            setValue(rtn);
//            String cur = et_getcur();
//            setValue(cur);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//
//
//
//
//    public SepoaOut getStoreHDCatalog( String from_date, String to_date, String est_from_date, String est_to_date, String plant_code, String high_weekday_pt, String low_weekday_pt, String holiday_pt, String weekend_pt, String est_tot_ent_cnt ) {
//
//        try {
//            String rtn = et_getStoreHDCatalog( from_date, to_date, est_from_date, est_to_date, plant_code, high_weekday_pt, low_weekday_pt, holiday_pt, weekend_pt, est_tot_ent_cnt );
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }
//        catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//    private String et_getStoreHDCatalog( String from_date, String to_date, String est_from_date, String est_to_date, String plant_code, String high_weekday_pt, String low_weekday_pt, String holiday_pt, String weekend_pt, String est_tot_ent_cnt ) throws Exception {
//
//        String rtn = null;
//
//        try {
//            ConnectionContext ctx = getConnectionContext();
//            String user_id = info.getSession("ID");
////            String plant_code     =  info.getSession("PLANT_CODE");
////            String plant_code_in = "";
////            if(plant_code.indexOf("&") > 0 ) {
////                plant_code_in =   WiseString.str2in(plant_code,"&") ;
////            }
//
//            StringBuffer sql = new StringBuffer();
//            sql.append(" SELECT                                                                                                             \n") ;
//            sql.append("       ROUND(ISNULL(SUM(A.QTY_SALE),0),2)  AS  TOT_ENT_CNT                                                          \n") ;  // 총입장객수
//            sql.append("     , convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1))  AS  TOT_DAY                            \n") ;  // 총일수
//            sql.append("     , ROUND(ISNULL(SUM(A.QTY_SALE),0) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)),2)  AS  AVG_DAY_CNT    \n") ;  // 일평균관람객수
//            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+from_date+"','"+to_date+"')  AS HOLIDAY_CNT                                     \n") ;  // 공휴일수
//             sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+from_date+"','"+to_date+"')  AS HIGH_WEEKDAY_CNT                                \n") ;  // 성수기평일수
//             sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+from_date+"','"+to_date+"')  AS LOW_WEEKDAY_CNT                                 \n") ;  // 비수기평일수
//             sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+from_date+"','"+to_date+"')  AS WEEKEND_CNT                                     \n") ;  // 주말수
//         if ( est_tot_ent_cnt != null && est_tot_ent_cnt.trim().length() > 0 ) {
//            sql.append("     , ROUND(" + est_tot_ent_cnt + ",2)    AS  EST_TOT_ENT_CNT                               \n") ;  // 예상총관람객수
//            sql.append("     , ROUND(" + est_tot_ent_cnt + " / (datediff(day, '"+est_from_date+"', '"+est_to_date+"') + 1),2)   AS  EST_AVG_DAY_CNT  \n") ;  // 예상일평균관람객수
//        }
//        else {
//            sql.append("     , ROUND(( (ISNULL(SUM(A.QTY_SALE),0) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)))   \n") ;
//            sql.append("         * (   (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"') * "+holiday_pt+")                  \n") ;
//             sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"') * "+high_weekday_pt+")             \n") ;
//             sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"') * "+low_weekday_pt+")              \n") ;
//             sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"') * "+weekend_pt+") ) ),2)    AS  EST_TOT_ENT_CNT    \n") ;  // 예상총관람객수
//             sql.append("     , ROUND(( (ISNULL(SUM(A.QTY_SALE),0) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)))   \n") ;
//            sql.append("         * (   (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"') * "+holiday_pt+")                  \n") ;
//             sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"') * "+high_weekday_pt+")             \n") ;
//             sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"') * "+low_weekday_pt+")              \n") ;
//             sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"') * "+weekend_pt+") ) )              \n") ;
//             sql.append("         / (datediff(day, '"+est_from_date+"', '"+est_to_date+"') + 1),2)   AS  EST_AVG_DAY_CNT                     \n") ;  // 예상일평균관람객수
//        }
//            sql.append("     , convert(numeric,(datediff(day, '"+est_from_date+"', '"+est_to_date+"') + 1))  AS  EST_TOT_DAY                \n") ;  // 예상총일수
//            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"')  AS  EST_HOLIDAY_CNT                        \n") ;  // 예상공휴일수
//             sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"')  AS  EST_HIGH_WEEKDAY_CNT                   \n") ;  // 예상성수기평일수
//             sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"')  AS  EST_LOW_WEEKDAY_CNT                    \n") ;  // 예상비수기평일수
//             sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"')  AS  EST_WEEKEND_CNT                        \n") ;  // 예상주말수
//             sql.append(" FROM SMS.DIAS.dbo.STC_DCALC_PRICE  A, SMS.DIAS.dbo.STB_PRICE_DTL  B, SMS.DIAS.dbo.STB_PRICE  C                     \n") ;
//            sql.append(" WHERE    A.ID_PRICE    =  B.ID_PRICE            AND  A.CD_THEATER  =  '"+plant_code+"'                             \n") ;
//            sql.append("     AND  A.YMD_PLAY    BETWEEN '"+from_date+"'  AND  '"+to_date+"'                                                 \n") ;
//            sql.append("     AND  C.CD_PRICE    =  B.CD_PRICE                                                                               \n") ;
//
//
////            sql.append(" SELECT                                                                                                             \n") ;
////            sql.append("       " +getConfig("wise.generator.db.selfuser") +  "."+ "numberFormat(ROUND(ISNULL(SUM(A.QTY_SALE),0),2),2)  AS  TOT_ENT_CNT                                                                   \n") ;  // 총입장객수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "numberFormat(ROUND(ISNULL(SUM(A.QTY_SALE),0) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)),2),2)  AS  AVG_DAY_CNT    \n") ;  // 일평균관람객수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+from_date+"','"+to_date+"')  AS HOLIDAY_CNT                                     \n") ;  // 공휴일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+from_date+"','"+to_date+"')  AS HIGH_WEEKDAY_CNT                                \n") ;  // 성수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+from_date+"','"+to_date+"')  AS LOW_WEEKDAY_CNT                                 \n") ;  // 비수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+from_date+"','"+to_date+"')  AS WEEKEND_CNT                                     \n") ;  // 주말수
// //        if ( est_tot_ent_cnt != null && est_tot_ent_cnt.trim().length() > 0 ) {
////            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "numberFormat(ROUND(" + est_tot_ent_cnt + ",2),2)    AS  EST_TOT_ENT_CNT                               \n") ;  // 예상총관람객수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "numberFormat(ROUND(" + est_tot_ent_cnt + " / (datediff(day, '"+est_from_date+"', '"+est_to_date+"') + 1),2),2)   AS  EST_AVG_DAY_CNT  \n") ;  // 예상일평균관람객수
// //        }
////        else {
////            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "numberFormat(ROUND(( (ISNULL(SUM(A.QTY_SALE),0) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)))   \n") ;
// //            sql.append("         * (   (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"') * "+holiday_pt+")                  \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"') * "+high_weekday_pt+")             \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"') * "+low_weekday_pt+")              \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"') * "+weekend_pt+") ) ),2),2)    AS  EST_TOT_ENT_CNT    \n") ;  // 예상총관람객수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "numberFormat(ROUND(( (ISNULL(SUM(A.QTY_SALE),0) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)))  \n") ;
// //            sql.append("         * (   (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"') * "+holiday_pt+")                  \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"') * "+high_weekday_pt+")             \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"') * "+low_weekday_pt+")              \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"') * "+weekend_pt+") ) )              \n") ;
// //            sql.append("         / (datediff(day, '"+est_from_date+"', '"+est_to_date+"') + 1),2),2)   AS  EST_AVG_DAY_CNT                  \n") ;  // 예상일평균관람객수
////        }
////            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"')  AS  EST_HOLIDAY_CNT                        \n") ;  // 예상공휴일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"')  AS  EST_HIGH_WEEKDAY_CNT                   \n") ;  // 예상성수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"')  AS  EST_LOW_WEEKDAY_CNT                    \n") ;  // 예상비수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"')  AS  EST_WEEKEND_CNT                        \n") ;  // 예상주말수
// //            sql.append(" FROM SMS.DIAS.dbo.STC_DCALC_PRICE  A, SMS.DIAS.dbo.STB_PRICE_DTL  B, SMS.DIAS.dbo.STB_PRICE  C                     \n") ;
////            sql.append(" WHERE    A.ID_PRICE    =  B.ID_PRICE            AND  A.CD_THEATER  =  '"+plant_code+"'                             \n") ;
////            sql.append("     AND  A.YMD_PLAY    BETWEEN '"+from_date+"'  AND  '"+to_date+"'                                                 \n") ;
////            sql.append("     AND  C.CD_PRICE    =  B.CD_PRICE                                                                               \n") ;
//
////        if(plant_code_in.equals("")) {
////            sql.append("             AND  A.PLANT_CODE     =  '" + plant_code     + "'                                                      \n") ;
////        }
////        else {
////            sql.append("             AND  A.PLANT_CODE     IN (" + plant_code_in  + ")                                                      \n") ;
////        }
////            sql.append(" SELECT                                                                                                             \n") ;
////            sql.append("       SUM(A.QTY_SALE)  AS  TOT_ENT_CNT                                                                             \n") ;  // 총입장객수
////            sql.append("     , SUM(A.QTY_SALE) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1))  AS  AVG_DAY_CNT      \n") ;  // 일평균관람객수
////            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+from_date+"','"+to_date+"')  AS HOLIDAY_CNT                                     \n") ;  // 공휴일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+from_date+"','"+to_date+"')  AS HIGH_WEEKDAY_CNT                                \n") ;  // 성수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+from_date+"','"+to_date+"')  AS LOW_WEEKDAY_CNT                                 \n") ;  // 비수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+from_date+"','"+to_date+"')  AS WEEKEND_CNT                                     \n") ;  // 주말수
// //            sql.append("     , ( (SUM(A.QTY_SALE) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)))                   \n") ;
////            sql.append("         * (   (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"') * 1)                               \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"') * 1)                               \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"') * 1)                               \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"') * 1) ) )    AS  EST_TOT_ENT_CNT    \n") ;  // 전체예상일수
// //            sql.append("     , ( (SUM(A.QTY_SALE) / convert(numeric,(datediff(day, '"+from_date+"', '"+to_date+"') + 1)))                   \n") ;
////            sql.append("         * (   (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"') * 1)                               \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"') * 1)                               \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"') * 1)                               \n") ;
// //            sql.append("             + (" +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"') * 1) ) )                           \n") ;
// //            sql.append("         / (datediff(day, '"+est_from_date+"', '"+est_to_date+"') + 1)   AS  EST_AVG_DAY_CNT                        \n") ;  // 전체예상일평균관람객수
////            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HL','"+est_from_date+"','"+est_to_date+"')  AS  EST_HOLIDAY_CNT                        \n") ;  // 예상공휴일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('HW','"+est_from_date+"','"+est_to_date+"')  AS  EST_HIGH_WEEKDAY_CNT                   \n") ;  // 예상성수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('LW','"+est_from_date+"','"+est_to_date+"')  AS  EST_LOW_WEEKDAY_CNT                    \n") ;  // 예상비수기평일수
// //            sql.append("     , " +getConfig("wise.generator.db.selfuser") +  "."+ "getDayTypeCnt('WE','"+est_from_date+"','"+est_to_date+"')  AS  EST_WEEKEND_CNT                        \n") ;  // 예상주말수
// //            sql.append(" FROM SMS.DIAS.dbo.STC_DCALC_PRICE  A, SMS.DIAS.dbo.STB_PRICE_DTL  B, SMS.DIAS.dbo.STB_PRICE  C                     \n") ;
////            sql.append(" WHERE    A.ID_PRICE  =  B.ID_PRICE                                                                                 \n") ;
////            sql.append("     AND  C.CD_PRICE  =  B.CD_PRICE                                                                                 \n") ;
////            sql.append("     AND  A.YMD_PLAY  BETWEEN '"+from_date+"'  AND  '"+to_date+"'                                                   \n") ;
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//        }
//        catch(Exception e)
//        {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//
//    public SepoaOut getStoreCatalog(  String material_type  , String material_ctrl_type, String material_class , String item_no     , String description_loc
//                                   , String description_eng, String specification     , String str_bin_flag   , String company_code, String from_date
//                                   , String to_date        , String est_from_date     , String est_to_date    , String plant_code  , String high_weekday_pt
//                                   , String low_weekday_pt , String holiday_pt        , String weekend_pt     , String est_tot_ent_cnt
//                                   , String tot_day        , String est_tot_day       , String est_avg_day_cnt, String avg_day_cnt)
//    {
//        try {
//            String rtn = et_getStoreCatalog(   material_type  , material_ctrl_type, material_class , item_no     , description_loc
//                                             , description_eng, specification     , "PR"           , str_bin_flag, company_code
//                                             , from_date      , to_date           , est_from_date  , est_to_date , plant_code
//                                             , high_weekday_pt, low_weekday_pt    , holiday_pt     , weekend_pt  , est_tot_ent_cnt
//                                             , tot_day        , est_tot_day       , est_avg_day_cnt, avg_day_cnt);
//            setValue(rtn);
//            String cur = et_getcur();
//            setValue(cur);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }
//        catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//    private String et_getStoreCatalog(  String material_type  , String material_ctrl_type, String material_class , String item_no     , String description_loc
//                                      , String description_eng, String specification     , String status         , String str_bin_flag, String company_code
//                                      , String from_date      , String to_date           , String est_from_date  , String est_to_date , String plant_code
//                                      , String high_weekday_pt, String low_weekday_pt    , String holiday_pt     , String weekend_pt  , String est_tot_ent_cnt
//                                      , String tot_day        , String est_tot_day       , String est_avg_day_cnt, String avg_day_cnt
//                                     ) throws Exception {
//
//        String rtn = null;
//
//        Logger.debug.println(info.getSession("ID"), this, ")))))))) tot_day =>" + tot_day);
//        Logger.debug.println(info.getSession("ID"), this, ")))))))) est_tot_day =>" + est_tot_day);
//        Logger.debug.println(info.getSession("ID"), this, ")))))))) est_avg_day_cnt =>" + tot_day);
//        Logger.debug.println(info.getSession("ID"), this, ")))))))) avg_day_cnt =>" + avg_day_cnt);
//
//        double d_tot_day = tot_day == null ? 0 : Double.parseDouble(tot_day);
//        double d_est_tot_day = est_tot_day == null ? 0 : Double.parseDouble(est_tot_day);
//        double d_est_avg_day_cnt = est_avg_day_cnt == null ? 0 : Double.parseDouble(est_avg_day_cnt);
//        double d_avg_day_cnt = avg_day_cnt == null ? 0 : Double.parseDouble(avg_day_cnt);
//
//        try {
//            ConnectionContext ctx = getConnectionContext();
//            String house_code     =  info.getSession("HOUSE_CODE");
//            String location       =  info.getSession("LOCATION_CODE");
//            String cur_date       = SepoaDate.getShortDateString();
//
//            StringBuffer sql = new StringBuffer();
//// 구매예상수량 = (실적판매수량 / 실적일수) * 계획일수 (예산관람객수/실적관람객수) * 수율
//            sql.append(" SELECT                                                                                                                 \n") ;
//            sql.append("       MATERIAL_TYPE         , MATERIAL_CTRL_TYPE    , MATERIAL_CLASS1   , SO_ITEM_NO    , DESCRIPTION_LOC              \n") ;
//            sql.append("     , DESCRIPTION_ENG       , SPECIFICATION         , ITEM_NO                                                          \n") ;
//            sql.append("     , ISNULL((SELECT  SUM(IMMS.CUR_STOCK_QTY)  FROM ICOIIMMS IMMS, ICOMOGSL OGSL                                       \n") ;
//            sql.append("                WHERE   IMMS.HOUSE_CODE   =  '"+house_code+"'   AND IMMS.COMPANY_CODE =  '"+company_code+"'             \n") ;
//            sql.append("                    AND IMMS.PLANT_CODE   =  '"+plant_code+"'   AND IMMS.YEAR_MONTH   =  '"+cur_date.substring(0,6)+"'  \n") ;
//            sql.append("                    AND IMMS.ITEM_NO      =  M.GI_ITEM_NO       AND IMMS.STATUS       <> 'D'                            \n") ;
//            sql.append("                    AND OGSL.HOUSE_CODE   = IMMS.HOUSE_CODE     AND OGSL.COMPANY_CODE = IMMS.COMPANY_CODE               \n") ;
//            sql.append("                    AND OGSL.PLANT_CODE   = IMMS.PLANT_CODE     AND OGSL.STR_CODE     = IMMS.STR_LOCATION               \n") ;
//            sql.append("                    AND OGSL.REP_STR_CODE_FLAG = 'Y'            AND OGSL.STATUS       <> 'D' ),0)  AS  STOCK_QTY        \n") ;
//            sql.append("     , ISNULL((SELECT  SUM(ITEM_QTY - GR_QTY)  FROM ICOYPODT                                                            \n") ;
//            sql.append("                WHERE   HOUSE_CODE   =  '"+house_code+"'   AND COMPANY_CODE =  '"+company_code+"'                       \n") ;
//            sql.append("                    AND PLANT_CODE   =  '"+plant_code+"'   AND COMPLETE_GR_MARK =  'N'                                  \n") ;
//            sql.append("                    AND ITEM_NO      =  M.GI_ITEM_NO       AND STATUS       <> 'D' ),0)  AS  NON_STOCK_QTY              \n") ;
//            sql.append("     , EST_ORDER_QTY         , 0 EST_SALES_QTY       , ITEM_NO                                                          \n") ;
//            sql.append("     , (SELECT  NAME_LOC  FROM ICOMLUSR L,  ICOMOGDP O                                                                  \n") ;
//            sql.append("         WHERE    L.HOUSE_CODE    =  M.HOUSE_CODE        AND  O.HOUSE_CODE    =  L.HOUSE_CODE                           \n") ;
//            sql.append("             AND  O.COMPANY_CODE  =  L.COMPANY_CODE      AND  O.DEPT          =  L.DEPT                                 \n") ;
//            sql.append("             AND  L.USER_ID       =  M.CTRL_PERSON_ID  ) AS NAME_LOC                                                    \n") ;
//            sql.append("     , CTRL_PERSON_NAME_LOC  , CTRL_PERSON_ID                                                                           \n") ;
//            sql.append("     , (SELECT  DEPT  FROM ICOMLUSR                                                                                     \n") ;
//            sql.append("         WHERE   HOUSE_CODE = M.HOUSE_CODE                                                                              \n") ;
//            sql.append("             AND USER_ID    = M.CTRL_PERSON_ID ) AS DEPT                                                                \n") ;
//            sql.append("     , ITEM_BLOCK_FLAG       , BASIC_UNIT            , MAKER_CODE        , MAKER_NAME    , MAKER_ITEM_NO                \n") ;
//            sql.append("     , ''  AS  UNIT_PRICE    , ''  AS  VENDER_CODE   , ''  AS  VENDER_COUNT, ''  AS  VENDER_NAME, ''  AS  CUR           \n") ;
//            sql.append("     , (SELECT MAX(STR_CODE + '@' + PLANT_CODE) + '@' + CONVERT(CHAR, COUNT(STR_CODE)) FROM   ICOMMTSL                  \n") ;
//            sql.append("         WHERE    HOUSE_CODE     =  M.HOUSE_CODE         AND  COMPANY_CODE   =  M.COMPANY_CODE                          \n") ;
//            sql.append("             AND  PLANT_CODE     =  '" + plant_code     + "'                                                            \n") ;
//            sql.append("             AND  ITEM_NO        =   M.ITEM_NO           AND  STATUS         <> 'D'                                     \n") ;
//            sql.append("        GROUP BY   ITEM_NO                                                                                              \n") ;
//            sql.append("       ) AS STR_CODE                                                                                                    \n") ;
//            sql.append("     , ''  AS  OPERATING_CODE    , CTRL_CODE     , PURCHASE_LOCATION , MATERIAL_RAW_DESC , DRAWING_NO                   \n") ;
//            sql.append("     , IMAGE_FILE_PATH           , ''  AS  MOLDING_QTY  , ''  AS  SERVICE_TYPE                                          \n") ;
//            sql.append("     , M.YR_QTY                                                                                                         \n") ;
//            sql.append(" FROM                                                                                                                   \n") ;
//            sql.append("   (SELECT MAX(K.MATERIAL_TYPE) MATERIAL_TYPE        , MAX(K.MATERIAL_CTRL_TYPE) MATERIAL_CTRL_TYPE                     \n") ;
//            sql.append("         , MAX(K.MATERIAL_CLASS1) MATERIAL_CLASS1    , K.ITEM_NO         , MAX(K.DESCRIPTION_LOC) DESCRIPTION_LOC       \n") ;
//            sql.append("         , MAX(K.DESCRIPTION_ENG) DESCRIPTION_ENG    , MAX(K.SPECIFICATION) SPECIFICATION                               \n") ;
//            sql.append("         , MAX(K.CTRL_PERSON_NAME_LOC) CTRL_PERSON_NAME_LOC              , MAX(K.CTRL_PERSON_ID) CTRL_PERSON_ID         \n") ;
//            sql.append("         , MAX(K.MATERIAL_RAW_DESC) MATERIAL_RAW_DESC                    , MAX(K.BASIC_UNIT) BASIC_UNIT                 \n") ;
//            sql.append("         , MAX(K.MAKER_CODE) MAKER_CODE              , MAX(K.MAKER_NAME) MAKER_NAME                                     \n") ;
//            sql.append("         , MAX(K.MAKER_ITEM_NO) MAKER_ITEM_NO        , K.HOUSE_CODE      , MAX(K.CTRL_CODE) CTRL_CODE                   \n") ;
//            sql.append("         , MAX(K.ITEM_BLOCK_FLAG) AS ITEM_BLOCK_FLAG , MAX(K.PURCHASE_LOCATION) PURCHASE_LOCATION                       \n") ;
//            sql.append("         , MAX(K.DRAWING_NO) DRAWING_NO              , MAX(K.IMAGE_FILE_PATH) IMAGE_FILE_PATH                           \n") ;
//            sql.append("         , MAX(K.YR_QTY) YR_QTY                      , MAX(K.SO_ITEM_NO) SO_ITEM_NO                                     \n") ;
//            sql.append("         , K.GI_ITEM_NO                              , MAX(K.COMPANY_CODE) COMPANY_CODE                                 \n") ;
//            sql.append("         , SUM(ROUND(ISNULL((" +getConfig("wise.generator.db.selfuser") + "."+ "getcgvisoac('"+house_code+"','"+company_code+"','"+plant_code+"',k.SO_ITEM_NO,      \n") ;
//             sql.append("                                                '"+from_date+"','"+to_date+"')                                          \n") ;
//            sql.append("               / " + d_tot_day + " * " + d_est_tot_day + " * " + d_est_avg_day_cnt + "                                  \n") ;
//            sql.append("               / " + (d_avg_day_cnt == 0 ? 1 : 0) + " ) * k.YR_QTY, 0),0) )  AS  EST_ORDER_QTY                          \n") ;
//            sql.append("     FROM                                                                                                               \n") ;
//            sql.append("       (SELECT MTGL.MATERIAL_TYPE        , MTGL.MATERIAL_CTRL_TYPE   , MTGL.MATERIAL_CLASS1     , MTGL.ITEM_NO          \n") ;
//            sql.append("             , MTGL.DESCRIPTION_LOC      , MTGL.DESCRIPTION_ENG      , MTGL.SPECIFICATION                               \n") ;
//            sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_TYPE',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'P')  AS CTRL_TYPE  \n") ;
//             sql.append("             , MTGL.MATERIAL_RAW_DESC                                                                                   \n") ;
//            sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('PURCHASE_LOCATION',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'"+location+"')  AS PURCHASE_LOCATION   \n") ;
//             sql.append("             , MTGL.BASIC_UNIT           , MTGL.MAKER_CODE           , MTGL.MAKER_NAME          , MTGL.MAKER_ITEM_NO    \n") ;
//            sql.append("             , MTGL.HOUSE_CODE                                                                                          \n") ;
//            sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_CODE',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'P001')  AS CTRL_CODE   \n") ;
//             sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(MTGL.ITEM_BLOCK_FLAG,'N')  AS  ITEM_BLOCK_FLAG                                                \n") ;
//             sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_PERSON_ID',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'')  AS CTRL_PERSON_ID \n") ;
//             sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_PERSON_NAME_LOC',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'')  AS CTRL_PERSON_NAME_LOC \n") ;
//             sql.append("             , (CASE " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(MTGL.DRAWING_LINK_FLAG,'0') WHEN '0' THEN '' ELSE MTGL.DRAWING_NO1 END)  AS  DRAWING_NO \n") ;
//             sql.append("             , MTGL.IMAGE_FILE_PATH      , VCMT.YR_QTY               , VCMT.COMPANY_CODE        , VCMT.PLANT_CODE       \n") ;
//            sql.append("             , VCMT.SO_ITEM_NO                                           , VCMT.GI_ITEM_NO                              \n") ;
//            sql.append("         FROM  ICOMMTGL  MTGL, VWCGVCMT  VCMT                                                                           \n") ;
//            sql.append("         WHERE    MTGL.HOUSE_CODE    =  '"+house_code+"'                                                                \n") ;
//            sql.append("             AND  MTGL.STATUS        <> 'D'                                                                             \n") ;
//
//    if(status.equals("PR")) {
//        if(material_type != null && material_type.trim().length() > 0 ) {
//            sql.append("             AND  MTGL.MATERIAL_TYPE      = '" + material_type + "'                                                     \n") ;
//        }
//        if(material_ctrl_type != null && material_ctrl_type.trim().length() > 0 ) {
//            sql.append("             AND  MTGL.MATERIAL_CTRL_TYPE = '" + material_ctrl_type + "'                                                \n") ;
//        }
//        if(material_class != null && material_class.trim().length() > 0 ) {
//            sql.append("             AND  MTGL.MATERIAL_CLASS1    = '" + material_class + "'                                                    \n") ;
//        }
//    }
//    if(item_no != null) {
//        if(status.equals("PR")) {
//            sql.append("             AND  MTGL.ITEM_NO   LIKE '" + item_no + "%'                                                                \n") ;
//        }
//        else if(status.equals("INV")) {
//            item_no = WiseString.str2in(item_no,"@");
//            sql.append("             AND  MTGL.ITEM_NO   IN (" + item_no + ")                                                                   \n") ;
//        }
//    }
//        if(description_loc != null) {
//            description_loc =  WiseString.replace(description_loc,"'","''");
//            sql.append("             AND  MTGL.DESCRIPTION_LOC   LIKE '" + description_loc + "%'                                                \n") ;
//        }
//        if(description_eng != null) {
//            description_eng =  WiseString.replace(description_eng,"'","''");
//            sql.append("             AND  MTGL.DESCRIPTION_ENG   LIKE '" + description_eng + "%'                                                \n") ;
//        }
//        if(specification != null) {
//            specification =  WiseString.replace(specification,"'","''");
//            sql.append("             AND  MTGL.SPECIFICATION     LIKE '" + specification + "%'                                                  \n") ;
//        }
//            sql.append("             AND  MTGL.HOUSE_CODE    =  VCMT.HOUSE_CODE      AND  MTGL.ITEM_NO       =  VCMT.GI_ITEM_NO                 \n") ;
//            sql.append("             AND  '"+est_from_date+"'    BETWEEN  VCMT.START_DATE1  AND  VCMT.END_DATE1                                 \n") ;
//            sql.append("             AND  '"+est_from_date+"'    BETWEEN  VCMT.START_DATE2  AND  VCMT.END_DATE2                                 \n") ;
//            sql.append("             AND  VCMT.COMPANY_CODE  =  '"+company_code+"'                                                              \n") ;
//            sql.append("             AND  VCMT.PLANT_CODE    =  '" + plant_code     + "'                                                        \n") ;
//            sql.append("             AND  " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(MTGL.ITEM_GROUP,'001') IN ('001','004','005')                                              \n") ;
//             sql.append("       )  K                                                                                                             \n") ;
//            sql.append("   GROUP BY K.HOUSE_CODE, K.ITEM_NO, GI_ITEM_NO                                                                         \n") ;
//            sql.append("   )  M                                                                                                                 \n") ;
//            sql.append(" ORDER BY  MATERIAL_TYPE , MATERIAL_CTRL_TYPE , MATERIAL_CLASS1 , SO_ITEM_NO , ITEM_NO                                  \n") ;
//
///* 구매품목에 복수의 판매품목에 존재하는 경우 하나만 조회되도록 쿼리를 수정함.
//            sql.append(" SELECT                                                                                                                 \n") ;
//            sql.append("       MATERIAL_TYPE         , MATERIAL_CTRL_TYPE    , MATERIAL_CLASS1   , SO_ITEM_NO    , DESCRIPTION_LOC              \n") ;
//            sql.append("     , DESCRIPTION_ENG       , SPECIFICATION         , ITEM_NO                                                          \n") ;
//            sql.append("     , ISNULL((SELECT  SUM(IMMS.CUR_STOCK_QTY)  FROM ICOIIMMS IMMS, ICOMOGSL OGSL                                       \n") ;
//            sql.append("                WHERE   IMMS.HOUSE_CODE   =  '"+house_code+"'   AND IMMS.COMPANY_CODE =  '"+company_code+"'             \n") ;
//            sql.append("                    AND IMMS.PLANT_CODE   =  '"+plant_code+"'   AND IMMS.YEAR_MONTH   =  '"+cur_date.substring(0,6)+"'  \n") ;
//            sql.append("                    AND IMMS.ITEM_NO      =  M.GI_ITEM_NO       AND IMMS.STATUS       <> 'D'                            \n") ;
//            sql.append("                    AND OGSL.HOUSE_CODE   = IMMS.HOUSE_CODE     AND OGSL.COMPANY_CODE = IMMS.COMPANY_CODE               \n") ;
//            sql.append("                    AND OGSL.PLANT_CODE   = IMMS.COMPANY_CODE   AND OGSL.STR_CODE     = IMMS.STR_LOCATION               \n") ;
//            sql.append("                    AND OGSL.REP_STR_CODE_FLAG = 'Y'            AND OGSL.STATUS       <> 'D' ),0)  AS  STOCK_QTY        \n") ;
//            sql.append("     , ISNULL((SELECT  SUM(ITEM_QTY - GR_QTY)  FROM ICOYPODT                                                            \n") ;
//            sql.append("                WHERE   HOUSE_CODE   =  '"+house_code+"'   AND COMPANY_CODE =  '"+company_code+"'                       \n") ;
//            sql.append("                    AND PLANT_CODE   =  '"+plant_code+"'   AND COMPLETE_GR_MARK =  'N'                                  \n") ;
//            sql.append("                    AND ITEM_NO      =  M.GI_ITEM_NO       AND STATUS       <> 'D' ),0)  AS  NON_STOCK_QTY              \n") ;
//// 구매예상수량 = (실적판매수량 / 실적일수) * 계획일수 (예산관람객수/실적관람객수)
//// 판매예상수량 = (실적판매수량 / 실적일수) * 계획일수 (예산관람객수/실적관람객수) * 수율
////            sql.append("     , ROUND(ISNULL(((ISNULL((SELECT SUM(SALES_QTY) FROM CGVISOAC WHERE HOUSE_CODE = '"+house_code+"' AND COMPANY_CODE = '"+company_code+"' \n") ;
////            sql.append("                            AND PLANT_CODE = '"+plant_code+"' AND SALE_DATE  BETWEEN '"+from_date+"' AND '"+to_date+"' AND ITEM_NO = M.SO_ITEM_NO),0)  \n") ;
////            sql.append("                    / " +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('TOT_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"'))    \n") ;
// //            sql.append("                * " +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('EST_TOT_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"')     \n") ;
// //            sql.append("                * (" +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('EST_AVG_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"')    \n") ;
// //            sql.append("                    / " +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('AVG_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"'))) * M.YR_QTY, 0),0)   AS  EST_ORDER_QTY    \n") ;  //구매예상수량
// //            sql.append("     , ROUND(ISNULL(((ISNULL((SELECT SUM(SALES_QTY) FROM CGVISOAC WHERE HOUSE_CODE = '"+house_code+"' AND COMPANY_CODE = '"+company_code+"' \n") ;
////            sql.append("                            AND PLANT_CODE = '"+plant_code+"' AND SALE_DATE  BETWEEN '"+from_date+"' AND '"+to_date+"' AND ITEM_NO = M.SO_ITEM_NO),0)  \n") ;
////            sql.append("                    / " +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('TOT_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"'))    \n") ;
// //            sql.append("                * " +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('EST_TOT_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"')     \n") ;
// //            sql.append("                * (" +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('EST_AVG_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"')    \n") ;
// //            sql.append("                    / " +getConfig("wise.generator.db.selfuser") +  "."+ "getVisitEstCnt('AVG_DAY','"+from_date+"','"+to_date+"','"+est_from_date+"','"+est_to_date+"','"+plant_code+"',"+holiday_pt+","+high_weekday_pt+","+low_weekday_pt+","+weekend_pt+",'"+est_tot_ent_cnt+"'))),0),0)  AS  EST_SALES_QTY    \n") ;  //판매예상수량
//             sql.append("     , ROUND(ISNULL(((ISNULL((SELECT SUM(SALES_QTY) FROM CGVISOAC WHERE HOUSE_CODE = '"+house_code+"' AND COMPANY_CODE = '"+company_code+"' \n") ;
//            sql.append("                            AND PLANT_CODE = '"+plant_code+"' AND SALE_DATE  BETWEEN '"+from_date+"' AND '"+to_date+"' AND ITEM_NO = M.SO_ITEM_NO),0)  \n") ;
//            sql.append("                    / " + d_tot_day + ")    												\n") ;
//            sql.append("                * " + d_est_tot_day + "     												\n") ;
//            sql.append("                * (" + d_est_avg_day_cnt + "    											\n") ;
//            sql.append("                    / " + (d_avg_day_cnt == 0 ? 1 : 0) + ")) * M.YR_QTY, 0),0)   AS  EST_ORDER_QTY    	\n") ;  //구매예상수량
//            sql.append("     , ROUND(ISNULL(((ISNULL((SELECT SUM(SALES_QTY) FROM CGVISOAC WHERE HOUSE_CODE = '"+house_code+"' AND COMPANY_CODE = '"+company_code+"' \n") ;
//            sql.append("                            AND PLANT_CODE = '"+plant_code+"' AND SALE_DATE  BETWEEN '"+from_date+"' AND '"+to_date+"' AND ITEM_NO = M.SO_ITEM_NO),0)  \n") ;
//            sql.append("                    / " + d_tot_day + ")    												\n") ;
//            sql.append("                * " + d_est_tot_day + "     												\n") ;
//            sql.append("                * (" + d_est_avg_day_cnt + "    											\n") ;
//            sql.append("                    / " + (d_avg_day_cnt == 0 ? 1 : 0) + ")),0),0)  AS  EST_SALES_QTY    				\n") ;  //판매예상수량
//            sql.append("     , (SELECT  NAME_LOC  FROM ICOMLUSR L,  ICOMOGDP O                                                                  \n") ;
//            sql.append("         WHERE    L.HOUSE_CODE    =  M.HOUSE_CODE        AND  O.HOUSE_CODE    =  L.HOUSE_CODE                           \n") ;
//            sql.append("             AND  O.COMPANY_CODE  =  L.COMPANY_CODE      AND  O.DEPT          =  L.DEPT                                 \n") ;
//            sql.append("             AND  L.USER_ID       =  M.CTRL_PERSON_ID  ) AS NAME_LOC                                                    \n") ;
//            sql.append("     , CTRL_PERSON_NAME_LOC  , CTRL_PERSON_ID                                                                           \n") ;
//            sql.append("     , (SELECT  DEPT  FROM ICOMLUSR                                                                                     \n") ;
//            sql.append("         WHERE   HOUSE_CODE = M.HOUSE_CODE                                                                              \n") ;
//            sql.append("             AND USER_ID    = M.CTRL_PERSON_ID ) AS DEPT                                                                \n") ;
//            sql.append("     , ITEM_BLOCK_FLAG       , BASIC_UNIT            , MAKER_CODE        , MAKER_NAME    , MAKER_ITEM_NO                \n") ;
//            sql.append("     , ''  AS  UNIT_PRICE    , ''  AS  VENDER_CODE   , ''  AS  VENDER_COUNT, ''  AS  VENDER_NAME, ''  AS  CUR           \n") ;
//            sql.append("     , (SELECT                                                                                                          \n") ;
//            sql.append("             MAX(STR_CODE + '@' + PLANT_CODE) + '@' + CONVERT(CHAR, COUNT(STR_CODE))                                    \n") ;
//            sql.append("         FROM   ICOMMTSL                                                                                                \n") ;
//            sql.append("         WHERE    HOUSE_CODE     =  M.HOUSE_CODE         AND  COMPANY_CODE   =  M.COMPANY_CODE                          \n") ;
//            sql.append("             AND  PLANT_CODE     =  '" + plant_code     + "'                                                            \n") ;
//            sql.append("             AND  ITEM_NO        =   M.ITEM_NO           AND  STATUS         <> 'D'                                     \n") ;
//            sql.append("        GROUP BY   ITEM_NO                                                                                              \n") ;
//            sql.append("       ) AS STR_CODE                                                                                                    \n") ;
//            sql.append("     , ''  AS  OPERATING_CODE    , CTRL_CODE     , PURCHASE_LOCATION , MATERIAL_RAW_DESC , DRAWING_NO                   \n") ;
//            sql.append("     , IMAGE_FILE_PATH           , ''  AS  MOLDING_QTY  , ''  AS  SERVICE_TYPE                                          \n") ;
//            sql.append("     , M.YR_QTY                                                                                                         \n") ;
//            sql.append(" FROM                                                                                                                   \n") ;
//            sql.append("   ( SELECT                                                                                                             \n") ;
//            sql.append("           K.MATERIAL_TYPE   , K.MATERIAL_CTRL_TYPE  , K.MATERIAL_CLASS1     , K.ITEM_NO         , K.DESCRIPTION_LOC    \n") ;
//            sql.append("         , K.DESCRIPTION_ENG , K.SPECIFICATION       , K.CTRL_PERSON_NAME_LOC, K.CTRL_PERSON_ID  , K.MATERIAL_RAW_DESC  \n") ;
//            sql.append("         , K.BASIC_UNIT      , K.MAKER_CODE          , K.MAKER_NAME          , K.MAKER_ITEM_NO   , K.HOUSE_CODE         \n") ;
//            sql.append("         , K.CTRL_CODE       , K.ITEM_BLOCK_FLAG     , K.PURCHASE_LOCATION   , K.DRAWING_NO      , K.IMAGE_FILE_PATH    \n") ;
//            sql.append("         , K.YR_QTY          , K.SO_ITEM_NO          , K.GI_ITEM_NO          , K.COMPANY_CODE                           \n") ;
//            sql.append("     FROM                                                                                                               \n") ;
//            sql.append("       ( SELECT                                                                                                         \n") ;
//            sql.append("               MTGL.MATERIAL_TYPE                                        , MTGL.MATERIAL_CTRL_TYPE                      \n") ;
//            sql.append("             , MTGL.MATERIAL_CLASS1                                      , MTGL.ITEM_NO                                 \n") ;
//            sql.append("             , MTGL.DESCRIPTION_LOC                                      , MTGL.DESCRIPTION_ENG                         \n") ;
//            sql.append("             , MTGL.SPECIFICATION                                                                                       \n") ;
//            sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_TYPE',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'P')  AS CTRL_TYPE  \n") ;
//             sql.append("             , MTGL.MATERIAL_RAW_DESC                                                                                   \n") ;
//            sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('PURCHASE_LOCATION',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'"+location+"')  AS PURCHASE_LOCATION   \n") ;
//             sql.append("             , MTGL.BASIC_UNIT                                           , MTGL.MAKER_CODE                              \n") ;
//            sql.append("             , MTGL.MAKER_NAME                                           , MTGL.MAKER_ITEM_NO                           \n") ;
//            sql.append("             , MTGL.HOUSE_CODE                                                                                          \n") ;
//            sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_CODE',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'P001')  AS CTRL_CODE   \n") ;
//             sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(MTGL.ITEM_BLOCK_FLAG,'N')  AS  ITEM_BLOCK_FLAG                                                \n") ;
//             sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_PERSON_ID',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'')  AS CTRL_PERSON_ID \n") ;
//             sql.append("             , " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(" +getConfig("wise.generator.db.selfuser") +  "."+ "getCtrl('CTRL_PERSON_NAME_LOC',MTGL.HOUSE_CODE,VCMT.COMPANY_CODE,'"+location+"',MTGL.MATERIAL_CLASS1,'"+material_type+"'),'')  AS CTRL_PERSON_NAME_LOC \n") ;
//             sql.append("             , (CASE " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(MTGL.DRAWING_LINK_FLAG,'0') WHEN '0' THEN '' ELSE MTGL.DRAWING_NO1 END)  AS  DRAWING_NO \n") ;
//             sql.append("             , MTGL.IMAGE_FILE_PATH                                      , VCMT.YR_QTY                                  \n") ;
//            sql.append("             , VCMT.COMPANY_CODE                                         , VCMT.PLANT_CODE                              \n") ;
//            sql.append("             , VCMT.SO_ITEM_NO                                           , VCMT.GI_ITEM_NO                              \n") ;
//            sql.append("         FROM  ICOMMTGL  MTGL, VWCGVCMT  VCMT                                                                           \n") ;
//            sql.append("         WHERE    MTGL.HOUSE_CODE    =  '"+house_code+"'                                                                \n") ;
//            sql.append("             AND  MTGL.STATUS        <> 'D'                                                                             \n") ;
//    if(status.equals("PR")) {
//        if(material_type != null && material_type.trim().length() > 0 ) {
//            sql.append("             AND  MTGL.MATERIAL_TYPE      = '" + material_type + "'                                                     \n") ;
//        }
//        if(material_ctrl_type != null && material_ctrl_type.trim().length() > 0 ) {
//            sql.append("             AND  MTGL.MATERIAL_CTRL_TYPE = '" + material_ctrl_type + "'                                                \n") ;
//        }
//        if(material_class != null && material_class.trim().length() > 0 ) {
//            sql.append("             AND  MTGL.MATERIAL_CLASS1    = '" + material_class + "'                                                    \n") ;
//        }
//    }
//    if(item_no != null) {
//        if(status.equals("PR")) {
//            sql.append("             AND  MTGL.ITEM_NO   LIKE '" + item_no + "%'                                                                \n") ;
//        }
//        else if(status.equals("INV")) {
//            item_no = WiseString.str2in(item_no,"@");
//            sql.append("             AND  MTGL.ITEM_NO   IN (" + item_no + ")                                                                   \n") ;
//        }
//    }
//        if(description_loc != null) {
//            description_loc =  WiseString.replace(description_loc,"'","''");
//            sql.append("             AND  MTGL.DESCRIPTION_LOC   LIKE '" + description_loc + "%'                                                \n") ;
//        }
//        if(description_eng != null) {
//            description_eng =  WiseString.replace(description_eng,"'","''");
//            sql.append("             AND  MTGL.DESCRIPTION_ENG   LIKE '" + description_eng + "%'                                                \n") ;
//        }
//        if(specification != null) {
//            specification =  WiseString.replace(specification,"'","''");
//            sql.append("             AND  MTGL.SPECIFICATION     LIKE '" + specification + "%'                                                  \n") ;
//        }
//            sql.append("             AND  MTGL.HOUSE_CODE    =  VCMT.HOUSE_CODE      AND  MTGL.ITEM_NO       =  VCMT.GI_ITEM_NO                 \n") ;
//            sql.append("             AND  '"+est_from_date+"'    BETWEEN  VCMT.START_DATE1  AND  VCMT.END_DATE1                                 \n") ;
//            sql.append("             AND  '"+est_from_date+"'    BETWEEN  VCMT.START_DATE2  AND  VCMT.END_DATE2                                 \n") ;
//            sql.append("             AND  VCMT.COMPANY_CODE  =  '"+company_code+"'                                                              \n") ;
//            sql.append("             AND  VCMT.PLANT_CODE    =  '" + plant_code     + "'                                                        \n") ;
//            sql.append("             AND  " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(MTGL.ITEM_GROUP,'001') IN ('001','004','005')                                              \n") ;
//             sql.append("       )  K                                                                                                             \n") ;
//            sql.append("   )  M                                                                                                                 \n") ;
//            sql.append(" ORDER BY  MATERIAL_TYPE , MATERIAL_CTRL_TYPE , MATERIAL_CLASS1 , SO_ITEM_NO , ITEM_NO                                  \n") ;
//*/
//
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//        }
//        catch(Exception e)
//        {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//    
//      private String et_getLoi(String material_type,
//                               String material_ctrl_type,
//                               String material_class1,
//                               String material_class2,
//                               String material_class3,
//                               String item_no,
//                               String description_loc,
//                               String description_eng,
//                               String vendor_code,
//                               String status) throws Exception
//    {
//
//        String rtn = null;
//
//        try{
//            ConnectionContext ctx = getConnectionContext();
//            String house_code     =  info.getSession("HOUSE_CODE");
//            String company      = info.getSession("COMPANY_CODE");
//            String location     = info.getSession("LOCATION_CODE");
//
//            StringBuffer sql = new StringBuffer();
//
//            sql.append(" SELECT                                                                 \n");
//           
//            sql.append("    MATERIAL_TYPE,   MATERIAL_CTRL_TYPE, MATERIAL_CLASS1,               \n");//0~2
//            sql.append("    MATERIAL_CLASS2, MATERIAL_CLASS3,                                   \n");//3,4
//            sql.append("    ITEM_NO, DESCRIPTION_LOC, DESCRIPTION_ENG, SPECIFICATION,           \n");//5~8
//            sql.append("    (SELECT L.USER_NAME_LOC FROM ICOMLUSR L,ICOMOGDP O                         \n");
//            sql.append("      WHERE L.HOUSE_CODE    = '"+house_code+"'                          \n");
//            sql.append("        AND O.HOUSE_CODE    = L.HOUSE_CODE                              \n");
//            sql.append("        AND O.COMPANY_CODE  = L.COMPANY_CODE                            \n");
//            sql.append("        AND O.DEPT          = L.DEPT                                    \n");
//            sql.append("        AND L.USER_ID       = M.CTRL_PERSON_ID) AS PURCHASE_DEPT_NAME,  \n");//9
//            sql.append("    CTRL_PERSON_NAME_LOC                        AS PURCHASER_NAME,      \n");
//            sql.append("    CTRL_PERSON_ID                              AS PURCHASER_ID,        \n");//10,11
//            sql.append("    (SELECT DEPT FROM ICOMLUSR                                          \n");
//            sql.append("        WHERE HOUSE_CODE    = '"+house_code+"'                          \n");
//            sql.append("        AND USER_ID         = M.CTRL_PERSON_ID) AS PURCHASE_DEPT,       \n");//12
//            sql.append("    ITEM_BLOCK_FLAG,                                                    \n");//13
//            sql.append("    BASIC_UNIT,                                                         \n");//14
////            sql.append("    (SELECT MIN(                                                        \n");
////            sql.append("            CASE " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(PURCHASE_UNIT,'NULL') WHEN 'NULL' THEN BASIC_UNIT ELSE PURCHASE_UNIT END \n");
// //            sql.append("            )                                                           \n");
////            sql.append("       FROM ICOMMTOU MTOU WHERE MTOU.HOUSE_CODE='"+house_code+"'        \n");
////            sql.append("        AND MTOU.ITEM_NO = M.ITEM_NO )          AS BASIC_UNIT,          \n");//14
//            sql.append("    MAKER_CODE, MAKER_NAME, MAKER_ITEM_NO,                              \n");//15~17
//            sql.append("    '' AS UNIT_PRICE, '' AS VENDER_CODE, ''     AS VENDER_COUNT,        \n");//18~20
//            sql.append("    '' AS VENDER_NAME, '' AS CUR,                                       \n");//21~22
//            sql.append("    '' AS STR_CODE,                                                     \n");
//            sql.append("    '' AS OPERATING_CODE,CTRL_CODE, PURCHASE_LOCATION,                  \n");//24~26
//            sql.append("        DRAWING_NO,IMAGE_FILE_PATH                   \n");//27~29
//            sql.append("    ,PO_NO                                                               \n");//27
//            sql.append("    ,PO_SEQ                                                              \n");//27
//            sql.append("    ,VENDOR_NAME                                                              \n");//27
//            sql.append("    ,VENDOR_CODE                                                             \n");//27
//            sql.append(" FROM   \n");
//            sql.append("    (SELECT K.MATERIAL_TYPE, K.MATERIAL_CTRL_TYPE, K.MATERIAL_CLASS1, K.MATERIAL_CLASS2, K.MATERIAL_CLASS3, \n");
//            sql.append("        K.ITEM_NO, K.DESCRIPTION_LOC, K.DESCRIPTION_ENG, K.SPECIFICATION, K.CTRL_PERSON_NAME_LOC,           \n");
//            sql.append("        K.CTRL_PERSON_ID, K.BASIC_UNIT, K.MAKER_CODE, K.MAKER_NAME,                    \n");
//            sql.append("        K.MAKER_ITEM_NO, K.HOUSE_CODE, K.CTRL_CODE, K.ITEM_BLOCK_FLAG, K.PURCHASE_LOCATION,                 \n");
//            sql.append("        K.DRAWING_NO, K.IMAGE_FILE_PATH,K.PO_NO ,K.PO_SEQ,K.VENDOR_NAME,K.VENDOR_CODE                                                                    \n");
//            sql.append("    FROM    \n");
//            sql.append("        (SELECT                                                          \n");
//            sql.append("            MTGL.MATERIAL_TYPE AS MATERIAL_TYPE,                         \n");
//            sql.append("            MTGL.MATERIAL_CTRL_TYPE AS MATERIAL_CTRL_TYPE,               \n");
//            sql.append("            MTGL.MATERIAL_CLASS1    AS MATERIAL_CLASS1,                  \n");
//            sql.append("            MTGL.MATERIAL_CLASS2    AS MATERIAL_CLASS2,                  \n");
//            sql.append("            MTGL.MATERIAL_CLASS3    AS MATERIAL_CLASS3,                  \n");
//            sql.append("            MTGL.ITEM_NO            AS ITEM_NO,                          \n");
//            sql.append("            MTGL.DESCRIPTION_LOC    AS DESCRIPTION_LOC,                  \n");
//            sql.append("            MTGL.DESCRIPTION_ENG    AS DESCRIPTION_ENG ,                 \n");
//            sql.append("            MTGL.SPECIFICATION      AS SPECIFICATION,                    \n");
//            sql.append("            ''                      AS CTRL_TYPE,                        \n");
//            //sql.append("            MTGL.MATERIAL_RAW_DESC  AS MATERIAL_RAW_DESC,                \n");
//            sql.append("            ' '                     AS PURCHASE_LOCATION,                \n");
//            sql.append("            MTGL.BASIC_UNIT         AS BASIC_UNIT,                       \n");
//            sql.append("            MTGL.MAKER_CODE         AS MAKER_CODE,                       \n");
//            sql.append("            MTGL.MAKER_NAME         AS MAKER_NAME,                       \n");
//            sql.append("            MTGL.MAKER_ITEM_NO      AS MAKER_ITEM_NO,                    \n");
//            sql.append("            '100'                   AS HOUSE_CODE,                       \n");
//            sql.append("            ' '                     AS CTRL_CODE,                        \n");
//            sql.append("            isnull(MTGL.ITEM_BLOCK_FLAG,'N') AS ITEM_BLOCK_FLAG,            \n");
//             sql.append("            ' '                     AS CTRL_PERSON_ID ,                  \n");
//            sql.append("            ' '                     AS CTRL_PERSON_NAME_LOC ,            \n");
//            sql.append("            (CASE isnull(MTGL.DRAWING_LINK_FLAG,'0') WHEN '0' THEN '' ELSE MTGL.DRAWING_NO1 END) AS DRAWING_NO, \n");
//             sql.append("            MTGL.IMAGE_FILE_PATH AS IMAGE_FILE_PATH \n");//대표이미지
//           sql.append("            ,PODT.PO_NO  AS PO_NO                         \n");
//           sql.append("            ,PODT.PO_SEQ  AS PO_SEQ                         \n");
//            sql.append("            ,getVendorName('100',PODT.VENDOR_CODE) AS VENDOR_NAME                         \n");
//            sql.append("            ,PODT.VENDOR_CODE                         \n");
//            sql.append("        FROM ICOMMTGL MTGL, ICOYPODT PODT \n");
//            sql.append("        WHERE    MTGL.HOUSE_CODE        = '"+house_code+"'                      \n");
//             sql.append("                      AND MTGL.HOUSE_CODE = PODT.HOUSE_CODE                    \n"); 
//             sql.append("                      AND MTGL.ITEM_NO = PODT.ITEM_NO                           \n");
//              sql.append("                     AND PODT.Z_LOI_FLAG='Y'                                  \n"); 
//            if(status.equals("PR"))
//            {
//                if(material_type != null)
//                sql.append( "       AND  MTGL.MATERIAL_TYPE     = '"+material_type+"'                   \n");
//                if(material_ctrl_type != null)
//                sql.append( "       AND  MTGL.MATERIAL_CTRL_TYPE= '"+material_ctrl_type+"'              \n");
//                if(material_class1 != null)
//                sql.append( "       AND  MTGL.MATERIAL_CLASS1   = '"+material_class1+"'                 \n");
//                 if(material_class2 != null)
//                sql.append( "       AND  MTGL.MATERIAL_CLASS2   = '"+material_class2+"'                 \n");
//                 if(material_class3 != null)
//                sql.append( "       AND  MTGL.MATERIAL_CLASS3   = '"+material_class3+"'                 \n");
//            }
//            if(item_no != null)
//            {
//                if(status.equals("PR")) {
//                    sql.append("    AND  MTGL.ITEM_NO LIKE '"+item_no+"%'                              \n");
//                }
//                else if(status.equals("INV")){
//                    item_no = WiseString.str2in(item_no,"@");
//                    sql.append("    AND  MTGL.ITEM_NO IN ("+item_no+")                                  \n");
//                }
//            }
//            if(description_loc != null)
//            {
//                description_loc =  WiseString.replace(description_loc,"'","''");
//                sql.append("        AND  (MTGL.DESCRIPTION_LOC LIKE '%"+description_loc+"%'             \n");
//                sql.append("        OR   MTGL.DESCRIPTION_ENG LIKE '%"+description_eng+"%')             \n");
//            }
//          //  if(specification != null) {
//          //      specification =  WiseString.replace(specification,"'","''");
//          //      sql.append("        AND  MTGL.SPECIFICATION LIKE '%"+specification+"%'                  \n");
//         //   }
//            if(vendor_code!= null){
//            	sql.append("        AND  PODT.VENDOR_CODE LIKE '%"+vendor_code+"%'                  \n");
//            }
//            sql.append("            AND  MTGL.STATUS IN ('C','R')                                       \n");
//          
//            sql.append("     ) k \n");
//            sql.append(" ) m \n");
//
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//        }catch(Exception e) {
////            Logger.err.println(userid,this,stackTrace(e));
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//    private String et_getCatalog1(String material_type,
//                               String material_ctrl_type,
//                               String material_class1,
//                               String material_class2,
//                               String material_class3,
//                               String item_no,
//                               String description_loc,
//                               String description_eng,
//                               String specification,
//                               String status) throws Exception
//    {
//
//        String rtn = null;
//
//        try{
//            ConnectionContext ctx = getConnectionContext();
//            String house_code     =  info.getSession("HOUSE_CODE");
//            String company      = info.getSession("COMPANY_CODE");
//            String location     = info.getSession("LOCATION_CODE");
//
//            StringBuffer sql = new StringBuffer();
//
//            sql.append(" SELECT                                                                 \n");
//            sql.append("    MATERIAL_TYPE,   MATERIAL_CTRL_TYPE, MATERIAL_CLASS1,               \n");//0~2
//            sql.append("    MATERIAL_CLASS2, MATERIAL_CLASS3,                                   \n");//3,4
//            sql.append("    ITEM_NO, DESCRIPTION_LOC, DESCRIPTION_ENG, SPECIFICATION,           \n");//5~8
//            sql.append("    (SELECT L.USER_NAME_LOC FROM ICOMLUSR L,ICOMOGDP O                         \n");
//            sql.append("      WHERE L.HOUSE_CODE    = '"+house_code+"'                          \n");
//            sql.append("        AND O.HOUSE_CODE    = L.HOUSE_CODE                              \n");
//            sql.append("        AND O.COMPANY_CODE  = L.COMPANY_CODE                            \n");
//            sql.append("        AND O.DEPT          = L.DEPT                                    \n");
//            sql.append("        AND L.USER_ID       = M.CTRL_PERSON_ID) AS PURCHASE_DEPT_NAME,  \n");//9
//            sql.append("    CTRL_PERSON_NAME_LOC                        AS PURCHASER_NAME,      \n");
//            sql.append("    CTRL_PERSON_ID                              AS PURCHASER_ID,        \n");//10,11
//            sql.append("    (SELECT DEPT FROM ICOMLUSR                                          \n");
//            sql.append("        WHERE HOUSE_CODE    = '"+house_code+"'                          \n");
//            sql.append("        AND USER_ID         = M.CTRL_PERSON_ID) AS PURCHASE_DEPT,       \n");//12
//            sql.append("    ITEM_BLOCK_FLAG,                                                    \n");//13
//            sql.append("    BASIC_UNIT,                                                         \n");//14
////            sql.append("    (SELECT MIN(                                                        \n");
////            sql.append("            CASE " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(PURCHASE_UNIT,'NULL') WHEN 'NULL' THEN BASIC_UNIT ELSE PURCHASE_UNIT END \n");
// //            sql.append("            )                                                           \n");
////            sql.append("       FROM ICOMMTOU MTOU WHERE MTOU.HOUSE_CODE='"+house_code+"'        \n");
////            sql.append("        AND MTOU.ITEM_NO = M.ITEM_NO )          AS BASIC_UNIT,          \n");//14
//            sql.append("    MAKER_CODE, MAKER_NAME, MAKER_ITEM_NO,                              \n");//15~17
//            sql.append("    '' AS UNIT_PRICE, '' AS VENDER_CODE, ''     AS VENDER_COUNT,        \n");//18~20
//            sql.append("    '' AS VENDER_NAME, '' AS CUR,                                       \n");//21~22
//            sql.append("    '' AS STR_CODE,                                                     \n");
//            sql.append("    '' AS OPERATING_CODE,CTRL_CODE, PURCHASE_LOCATION,                  \n");//24~26
//            sql.append("        DRAWING_NO,IMAGE_FILE_PATH                   \n");//27~29
//            sql.append(" FROM   \n");
//            sql.append("    (SELECT K.MATERIAL_TYPE, K.MATERIAL_CTRL_TYPE, K.MATERIAL_CLASS1, K.MATERIAL_CLASS2, K.MATERIAL_CLASS3, \n");
//            sql.append("        K.ITEM_NO, K.DESCRIPTION_LOC, K.DESCRIPTION_ENG, K.SPECIFICATION, K.CTRL_PERSON_NAME_LOC,           \n");
//            sql.append("        K.CTRL_PERSON_ID, K.BASIC_UNIT, K.MAKER_CODE, K.MAKER_NAME,                    \n");
//            sql.append("        K.MAKER_ITEM_NO, K.HOUSE_CODE, K.CTRL_CODE, K.ITEM_BLOCK_FLAG, K.PURCHASE_LOCATION,                 \n");
//            sql.append("        K.DRAWING_NO, K.IMAGE_FILE_PATH                                                                     \n");
//            sql.append("    FROM    \n");
//            sql.append("        (SELECT MTGL.MATERIAL_TYPE  AS MATERIAL_TYPE,                    \n");
//            sql.append("            MTGL.MATERIAL_CTRL_TYPE AS MATERIAL_CTRL_TYPE,               \n");
//            sql.append("            MTGL.MATERIAL_CLASS1    AS MATERIAL_CLASS1,                  \n");
//            sql.append("            MTGL.MATERIAL_CLASS2    AS MATERIAL_CLASS2,                  \n");
//            sql.append("            MTGL.MATERIAL_CLASS3    AS MATERIAL_CLASS3,                  \n");
//            sql.append("            MTGL.ITEM_NO            AS ITEM_NO,                          \n");
//            sql.append("            MTGL.DESCRIPTION_LOC    AS DESCRIPTION_LOC,                  \n");
//            sql.append("            MTGL.DESCRIPTION_ENG    AS DESCRIPTION_ENG ,                 \n");
//            sql.append("            MTGL.SPECIFICATION      AS SPECIFICATION,                    \n");
//            sql.append("            ''                      AS CTRL_TYPE,                        \n");
//            //sql.append("            MTGL.MATERIAL_RAW_DESC  AS MATERIAL_RAW_DESC,                \n");
//            sql.append("            ' '                     AS PURCHASE_LOCATION,                \n");
//            sql.append("            MTGL.BASIC_UNIT         AS BASIC_UNIT,                       \n");
//            sql.append("            MTGL.MAKER_CODE         AS MAKER_CODE,                       \n");
//            sql.append("            MTGL.MAKER_NAME         AS MAKER_NAME,                       \n");
//            sql.append("            MTGL.MAKER_ITEM_NO      AS MAKER_ITEM_NO,                    \n");
//            sql.append("            '100'                   AS HOUSE_CODE,                       \n");
//            sql.append("            ' '                     AS CTRL_CODE,                        \n");
//            sql.append("            isnull(MTGL.ITEM_BLOCK_FLAG,'N') AS ITEM_BLOCK_FLAG,            \n");
//             sql.append("            ' '                     AS CTRL_PERSON_ID ,                  \n");
//            sql.append("            ' '                     AS CTRL_PERSON_NAME_LOC ,            \n");
//            sql.append("            (CASE isnull(MTGL.DRAWING_LINK_FLAG,'0') WHEN '0' THEN '' ELSE MTGL.DRAWING_NO1 END) AS DRAWING_NO, \n");
//             sql.append("            MTGL.IMAGE_FILE_PATH AS IMAGE_FILE_PATH \n");//대표이미지
//
//
//            sql.append("        FROM ICOMMTGL MTGL \n");
//            sql.append("        WHERE    MTGL.HOUSE_CODE        = '"+house_code+"'                      \n");
//            if(status.equals("PR"))
//            {
//                if(material_type != null)
//                sql.append( "       AND  MTGL.MATERIAL_TYPE     = '"+material_type+"'                   \n");
//                if(material_ctrl_type != null)
//                sql.append( "       AND  MTGL.MATERIAL_CTRL_TYPE= '"+material_ctrl_type+"'              \n");
//                if(material_class1 != null)
//                sql.append( "       AND  MTGL.MATERIAL_CLASS1   = '"+material_class1+"'                 \n");
//                 if(material_class2 != null)
//                sql.append( "       AND  MTGL.MATERIAL_CLASS2   = '"+material_class2+"'                 \n");
//                 if(material_class3 != null)
//                sql.append( "       AND  MTGL.MATERIAL_CLASS3   = '"+material_class3+"'                 \n");
//            }
//            if(item_no != null)
//            {
//                if(status.equals("PR")) {
//                    sql.append("    AND  MTGL.ITEM_NO LIKE '"+item_no+"%'                              \n");
//                }
//                else if(status.equals("INV")){
//                    item_no = WiseString.str2in(item_no,"@");
//                    sql.append("    AND  MTGL.ITEM_NO IN ("+item_no+")                                  \n");
//                }
//            }
//            if(description_loc != null)
//            {
//                description_loc =  WiseString.replace(description_loc,"'","''");
//                sql.append("        AND  (MTGL.DESCRIPTION_LOC LIKE '%"+description_loc+"%'             \n");
//                sql.append("        OR   MTGL.DESCRIPTION_ENG LIKE '%"+description_eng+"%')             \n");
//            }
//            if(specification != null) {
//                specification =  WiseString.replace(specification,"'","''");
//                sql.append("        AND  MTGL.SPECIFICATION LIKE '%"+specification+"%'                  \n");
//            }
//            sql.append("            AND  MTGL.STATUS IN ('C','R')                                       \n");
//          
//            sql.append("     ) k \n");
//            sql.append(" ) m \n");
//
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//            
//        }catch(Exception e) {
////            Logger.err.println(userid,this,stackTrace(e));
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//
//    public SepoaOut getmyCatalog( String material_type,
//                           String material_ctrl_type,
//                           String material_class1,
//                           String material_class2,
//                           String material_class3,
//                           String item_no,
//                           String description_loc,
//                           String description_eng,
//                           String specification)
//    {
//        try{
//
//            String rtn = et_getmyCatalog(material_type,material_ctrl_type,material_class1,material_class2,material_class3,item_no,description_loc,description_eng,specification);
//            setValue(rtn);
//            String cur = et_getcur();
//            setValue(cur);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//
////  Sunho add. 20050110.
//    protected String et_getPalntCode() throws Exception {
//        String rtn = null;
//
//        try
//        {
//            ConnectionContext ctx   = getConnectionContext();
//            String house_code     =  info.getSession("HOUSE_CODE");
//            StringBuffer sql        = new StringBuffer();
//            sql.append(" SELECT TEXT1                                                       \n") ;
//            sql.append("   FROM ICORCODE                                                    \n") ;
//            sql.append("  WHERE HOUSE_CODE = '" + house_code + "'                           \n") ;
//            sql.append("    AND TEXT2 = (SELECT DEPT                                        \n") ;
//            sql.append("                   FROM ICOMLUSR                                    \n") ;
//            sql.append("                  WHERE HOUSE_CODE = '" + house_code + "'           \n") ;
//            sql.append("                    AND USER_ID = '" + info.getSession("ID") + "')  \n") ;
//            sql.append("    AND COMPANY_CODE = '" + info.getSession("COMPANY_CODE") + "'    \n") ;
//            sql.append("    AND TYPE = 'C009'                                               \n") ;
//
//            Logger.err.println(info.getSession("ID"),this,sql.toString());
//
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//
//            Logger.err.println(info.getSession("ID"),this,rtn);
//
//        }
//        catch(Exception e)
//        {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//
//        return rtn;
//    }
//
//    private String et_getmyCatalog(String material_type,
//                                   String material_ctrl_type,
//                                   String material_class1,
//                                   String material_class2,
//                                   String material_class3,
//                                   String item_no,
//                                   String description_loc,
//                                   String description_eng,
//                                   String specification) throws Exception
//    {
//        String rtn = null;
//        ConnectionContext ctx = getConnectionContext();
//        String house_code     =  info.getSession("HOUSE_CODE");
//        String company      = info.getSession("COMPANY_CODE");
//        String location     = info.getSession("LOCATION_CODE");
//        String plant_code   = info.getSession("PLANT_CODE");
//
//        String plant_code_in = "";
//        if(plant_code.indexOf("&") > 0 ) plant_code_in =   WiseString.str2in(plant_code,"&") ;
//
//        StringBuffer sql = new StringBuffer();
//        sql.append(" SELECT \n");
//        sql.append("    material_type, material_ctrl_type, material_class1,         \n");
//        sql.append("    material_class2,material_class3, item_no,                   \n");
//        sql.append("    description_loc, description_eng, specification,            \n");
//        sql.append("    (select name_loc from icomlusr l,icomogdp o                 \n");
//        sql.append("    where  l.house_code = '"+house_code+"'                      \n");
//        sql.append("        and    o.house_code = l.house_code                      \n");
//        sql.append("        and    o.company_code = l.company_code                  \n");
//        sql.append("        and    o.dept = l.dept                                  \n");
//        sql.append("        and    l.user_id = m.ctrl_person_id) as name_loc,       \n");
//        sql.append("    ctrl_person_name_loc, ctrl_person_id,                       \n");
//        sql.append("    (SELECT dept from icomlusr where house_code='"+house_code+"'\n");
//        sql.append("        and user_id = m.ctrl_person_id) as dept,                \n");
//        sql.append("    item_block_flag,                                            \n");
//        sql.append("    basic_unit, maker_code, maker_name, maker_item_no,          \n");
//        sql.append("    '', '', '', '', '',                                         \n");
//        sql.append("    ( SELECT MAX(str_code+'@'+plant_code)+'@'+COUNT(str_code) \n");
//        sql.append("        FROM icommtsl                                           \n");
//        sql.append("        WHERE house_code = '"+house_code+"'                     \n");
//
//        if(plant_code_in.equals(""))
//            sql.append( "       and plant_code = '"+plant_code+"'                   \n");
//        else
//            sql.append( "       and plant_code in ("+plant_code_in+")               \n");
//        sql.append("            and item_no = m.item_no                             \n");
//        sql.append("            and status in ('C','R')                             \n");
//        sql.append("        GROUP BY item_no ) as str_code,                         \n");
//        sql.append("    '' as operating_code,ctrl_code, purchase_location,material_raw_desc, \n");
//        sql.append("    drawing_no, image_file_path                                 \n");
//		sql.append("    ,substring(GETSG_REFITEM(MTGL.HOUSE_CODE,MTGL.MATERIAL_CLASS2),2) AS SG_REFITEM                          \n");
//        sql.append(" FROM \n");// m start
//        sql.append("    (SELECT k.material_type, k.material_ctrl_type, k.material_class1,k.material_class2,k.material_class3, k.item_no, \n");
//        sql.append("        k.description_loc, k.description_eng , k.specification, k.ctrl_person_name_loc, \n");
//        sql.append("        k.ctrl_person_id,  k.material_raw_desc , k.basic_unit, k.maker_code,            \n");
//        sql.append("        k.maker_name, k.maker_item_no, k.house_code, k.item_block_flag ,                \n");
//        sql.append("        k.ctrl_code, k.purchase_location,                       \n");
//        sql.append("        k.drawing_no, k.image_file_path                         \n");
//        sql.append("    FROM \n");//k start
//        sql.append("        (SELECT mtgl.material_type AS material_type, mtgl.material_ctrl_type AS material_ctrl_type, \n");
//        sql.append("            mtgl.material_class1 AS material_class1,            \n");
//        sql.append("            mtgl.material_class2 AS material_class2,            \n");
//        sql.append("            mtgl.material_class3 AS material_class3, mtgl.item_no AS item_no, \n");
//
//        sql.append("            mtgl.description_loc AS description_loc, mtgl.description_eng  AS description_eng , \n");
//        sql.append("            mtgl.specification AS specification, " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(s.ctrl_type,'P')  AS ctrl_type, \n");
//         sql.append("            mtgl.material_raw_desc AS material_raw_desc,            \n");
//        sql.append("            " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(s.purchase_location,'"+location+"')   AS purchase_location,  \n");
//         sql.append("            mtgl.basic_unit  AS basic_unit, mtgl.maker_code AS maker_code, \n");
//        sql.append("            mtgl.maker_name AS maker_name, mtgl.maker_item_no AS maker_item_no, \n");
//        sql.append("            s.house_code AS house_code, " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(mtgl.item_block_flag,'N') AS item_block_flag, " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(s.ctrl_code,'')  AS ctrl_code, \n");
//         sql.append("            " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(s.ctrl_person_id, '') as ctrl_person_id , \n");
//         sql.append("            " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(s.ctrl_person_name_loc, '' ) as ctrl_person_name_loc, \n");
//         sql.append("            CASE " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(DRAWING_LINK_FLAG,'0') WHEN '0' THEN '' ELSE drawing_no1 END as drawing_no,          \n");
//         sql.append("            image_file_path as image_file_path  \n");
//        sql.append("        FROM icoymycl mycl, icommtgl mtgl \n");
//        sql.append("            LEFT OUTER JOIN (SELECT   distinct bacp.ctrl_person_id, bacp.ctrl_person_name_loc,  \n");
//        sql.append("                mcpm.house_code, mcpm.material_class1,mcpm.ctrl_code,           \n");
//        sql.append("                bapr.purchase_location,mcpm.ctrl_type                           \n");
//        sql.append("            FROM   icommcpm mcpm, icombacp bacp, icombapr bapr, icomcode code   \n");
//        sql.append("            WHERE  bapr.house_code = '"+house_code+"'                           \n");
//        sql.append("                AND  bapr.pr_location = '"+location+"'                          \n");
//        sql.append("                AND  mcpm.house_code = bapr.house_code                          \n");
//        sql.append("                AND  mcpm.purchase_location = bapr.purchase_location            \n");
//        sql.append("                AND  mcpm.house_code = bacp.house_code                          \n");
//        sql.append("                AND  mcpm.ctrl_code  = bacp.ctrl_code                           \n");
//        sql.append("                AND  mcpm.ctrl_type  = bacp.ctrl_type                           \n");
//        sql.append("                AND  bapr.status in ('C','R')                                   \n");
//        sql.append("                AND  mcpm.status in ('C','R')                                   \n");
//        sql.append("                AND  bacp.status in ('C','R')                                   \n");
//        sql.append("                and  mcpm.material_class1 = code.code                           \n");
//        sql.append("                and  code.house_code = '"+house_code+"'                         \n");
//        sql.append("                and  code.type = 'M042'                                         \n");
//        if(material_type != null)
//          sql.append( "             and  code.text3 = '"+material_type+"'                           \n");
//        sql.append("            ) s                                                                 \n");
//        sql.append("             ON    mtgl.house_code = s.house_code                               \n");
//        sql.append("            AND    mtgl.material_class1 = s.material_class1                     \n");
//        sql.append("        WHERE   mycl.house_code = '"+house_code+"'                              \n");
//        sql.append("            AND    mycl.user_id = '"+userid+"'                                  \n");
//        sql.append("            AND    mycl.house_code = mtgl.house_code                            \n");
//        sql.append("            AND    mycl.buyer_item_no = mtgl.item_no                            \n");
//        sql.append("            AND    mtgl.house_code = '"+house_code+"'                           \n");
//
//        if(material_type != null)
//        {sql.append("      and    mtgl.material_type = '"+material_type+"'                          \n");}
//        if(material_ctrl_type != null)
//        {sql.append("      and    mtgl.material_    if(material_class1 != null)                     \n");
//        sql.append("      and    mtgl.material_class1 = '"+material_class1+"'                       \n");}
//        if(material_class2 != null)
//        {sql.append("      and    mtgl.material_class2 = '"+material_class2+"'                      \n");}
//        if(material_class3 != null)
//        {sql.append("      and    mtgl.material_class3 = '"+material_class3+"'                      \n");}
//        if(item_no != null)
//        {sql.append("      and    mtgl.item_no like '"+item_no+"%'                                  \n");}
//        if(description_loc != null)
//        {
//          description_loc =  WiseString.replace(description_loc,"'","''");
//          sql.append("      and    mtgl.description_loc like '"+description_loc+"%' \n");
//        }
//        if(description_eng != null)
//        {
//           description_eng =  WiseString.replace(description_eng,"'","''");
//          sql.append("      and    mtgl.description_eng like '"+description_eng+"%' \n");
//        }
//        if(specification != null)
//        {
//          specification =  WiseString.replace(specification,"'","''");
//          sql.append("      and    mtgl.specification like '"+specification+"%' \n");
//        }
//        sql.append("        AND    mtgl.status in ('C','R') \n");
//        sql.append("        AND    " +getConfig("wise.generator.db.selfuser") + "."+ "isnull(mtgl.item_group,'001') in ('001','004','005') \n");
//
//        sql.append("        )  k \n");
//        sql.append("    ) m \n");
//
//
//        try{
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//
////RFQ생성 - 카탈로그 - 품번마스터 선택
//    public SepoaOut getDivision( String shipper_type,String[][] recvdata )
//    {
//        try{
//            if(recvdata.length > 0)
//            {
//                String division = "";
//                for(int i = 0 ; i < recvdata.length ; i++)
//                {
//                    division = et_getDivision(shipper_type,recvdata[i][0],recvdata[i][1]);
//                    setValue(division);
//                }
//
//            }
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getDivision(String shipper_type,String item_no,String purchase_location) throws Exception
//    {
//
//        String rtn = null;
//        ConnectionContext ctx = getConnectionContext();
//        String house_code     =  info.getSession("HOUSE_CODE");
//        String company      = info.getSession("COMPANY_CODE");
//        String location     = info.getSession("LOCATION_CODE");
//        StringBuffer sql = new StringBuffer();
//
//        sql.append(" SELECT A.UNIT_PRICE, A.VENDOR_CODE, A.CNT, A.VENDOR_NAME, A.CUR                            \n");
//        sql.append(" FROM                                                                                       \n");
//        sql.append("    (SELECT M.UNIT_PRICE AS UNIT_PRICE, M.VENDOR_CODE AS VENDOR_CODE,                 \n");
//        sql.append("        M.VENDOR_NAME AS VENDOR_NAME, C.CNT AS CNT,                                         \n");
//        sql.append("        (CASE (SIGN( (M.QUOTA_PERCENT / C.PERCENT1)                  \n");
//        sql.append("                  - (M.CUM_PO_QTY/C.QTY)))                            \n");
//        sql.append("            WHEN 1 THEN 1                                                                   \n");
//        sql.append("            ELSE 2                                                                          \n");
//        sql.append("        END) AS DIVISION,M.CUR                                                              \n");
//        sql.append("    FROM                                                                                    \n");
//        sql.append("        (SELECT N.VENDOR_CODE, I.UNIT_PRICE, N.CUM_PO_QTY,                                  \n");
//        sql.append("            N.QUOTA_PERCENT, GETVENDORNAME('100',I.VENDOR_CODE) VENDOR_NAME, I.CUR                                           \n");
//        sql.append("        FROM  ICOYINFO I,ICOYINDR N                                                         \n");
//        sql.append("        WHERE I.HOUSE_CODE         = N.HOUSE_CODE                                           \n");
//        sql.append("          AND I.COMPANY_CODE       = N.COMPANY_CODE                                         \n");
//        sql.append("          AND I.PURCHASE_LOCATION  = N.PURCHASE_LOCATION                                    \n");
//        sql.append("          AND I.ITEM_NO            = N.ITEM_NO                                              \n");
//        sql.append("          AND I.VENDOR_CODE        = N.VENDOR_CODE                                          \n");
//        sql.append("          AND I.HOUSE_CODE         = '"+house_code+"'                                       \n");
//        sql.append("          AND I.SHIPPER_TYPE       = '"+shipper_type+"'                                     \n");
//        sql.append("          AND RTRIM(I.PURCHASE_LOCATION) IN (SELECT PURCHASE_LOCATION                       \n");
//        sql.append("                                             FROM ICOMBAPR                                  \n");
//        sql.append("                                             WHERE HOUSE_CODE    = '"+house_code+"'         \n");
//        sql.append("                                               AND PR_LOCATION   = '"+location+"')          \n");
//        sql.append("          AND I.ITEM_NO         = '"+item_no+"'                                             \n");
//        sql.append("          AND I.STATUS IN ('C','R')                                                         \n");
//        sql.append("          AND N.STATUS IN ('C','R')                                                         \n");
//        sql.append("        ) M,                                                                                \n");
//        sql.append("        (SELECT (CASE isnull(SUM(CUM_PO_QTY),0) WHEN 0 THEN 1 ELSE SUM(CUM_PO_QTY) END) AS QTY,  \n");
//        sql.append("            (CASE isnull(SUM(QUOTA_PERCENT),0)                                              \n");
//        sql.append("                WHEN 0 THEN 1                                                               \n");
//        sql.append("                ELSE SUM(QUOTA_PERCENT)                                                     \n");
//        sql.append("             END) AS PERCENT1,                                                              \n");
//        sql.append("            COUNT(*) AS CNT                                                                 \n");
//        sql.append("        FROM (SELECT N.CUM_PO_QTY, N.QUOTA_PERCENT                                          \n");
//        sql.append("                FROM  ICOYINFO I,ICOYINDR N                                                 \n");
//        sql.append("                WHERE I.HOUSE_CODE         = N.HOUSE_CODE                                   \n");
//        sql.append("                  AND I.COMPANY_CODE       = N.COMPANY_CODE                                 \n");
//        sql.append("                  AND I.PURCHASE_LOCATION  = N.PURCHASE_LOCATION                            \n");
//        sql.append("                  AND I.ITEM_NO            = N.ITEM_NO                                      \n");
//        sql.append("                  AND I.VENDOR_CODE        = N.VENDOR_CODE                                  \n");
//        sql.append("                  AND I.HOUSE_CODE         = '"+house_code+"'                               \n");
//        sql.append("                  AND RTRIM(I.PURCHASE_LOCATION) IN (SELECT PURCHASE_LOCATION               \n");
//        sql.append("                                                     FROM ICOMBAPR                          \n");
//        sql.append("                                                     WHERE HOUSE_CODE    = '"+house_code+"' \n");
//        sql.append("                                                       AND PR_LOCATION   = '"+location+"')  \n");
//        sql.append("                  AND I.SHIPPER_TYPE    = '"+shipper_type+"'                                \n");
//        sql.append("                  AND I.ITEM_NO         = '"+item_no+"'                                     \n");
//        sql.append("                  AND I.STATUS IN ('C','R')                                                 \n");
//        sql.append("                  AND N.STATUS IN ('C','R')                                                 \n");
//        sql.append("            ) Z                                                                             \n");
//        sql.append("        ) C                                                                                 \n");
//        sql.append("       ORDER BY DIVISION                                                                    \n");
//        sql.append("   ) A                                                                                      \n");
//
//        try{
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//    public SepoaOut getMultiDivision (String shipper_type, String item_no,String operating_code)
//    {
//        try{
//            String rtn = et_getMultiDivision(shipper_type,item_no,operating_code);
//            setStatus(1);
//            setValue(rtn);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//    private String et_getMultiDivision(String shipper_type,String item_no,String operating_code) throws Exception
//    {
//        //청구 생성
//        String rtn = null;
//        ConnectionContext ctx = getConnectionContext();
//        String house_code     =  info.getSession("HOUSE_CODE");
//        String company      = info.getSession("COMPANY_CODE");
//        String location     = info.getSession("LOCATION_CODE");
//
//        StringBuffer sql = new StringBuffer();
//        sql.append(" select N.VENDOR_CODE,I.VENDOR_NAME,I.CUR,I.UNIT_PRICE \n");
//        sql.append(" from   ICOYINFO I,ICOYINDR N \n");
//        sql.append(" where  I.HOUSE_CODE=N.HOUSE_CODE \n");
//        sql.append(" and  I.OPERATING_CODE=N.OPERATING_CODE \n");
//        sql.append(" and  I.ITEM_NO=N.ITEM_NO \n");
//        sql.append(" and  I.VENDOR_CODE=N.VENDOR_CODE \n");
//        sql.append(" and  I.HOUSE_CODE = '"+house_code+"' \n");
//        sql.append(" and  RTRIM(I.OPERATING_CODE) IN (SELECT PURCHASE_LOCATION FROM ICOMBAPR WHERE HOUSE_CODE = '"+house_code+"' AND PR_LOCATION = '"+location+"') \n");
//        sql.append(" and  I.STATUS IN ('C','R') \n");
//        sql.append(" and  N.STATUS IN ('C','R') \n");
//        sql.append(" and  I.ITEM_NO = '"+item_no+"' \n");
//        sql.append(" and  I.SHIPPER_TYPE = '"+shipper_type+"' \n");
//        //    sql.append(" and  replace(convert(varchar, getdate(), 102), '.', '') BETWEEN I.VALID_FROM_DATE AND I.VALID_TO_DATE \n");05월 20일 석재가 막았어..
//
//        try{
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//
//    public SepoaOut getMultiDivision_exec (String shipper_type,String item_no,String operating_code,String pr_qty, String purchase_location)
//    {
//        try{
//            String rtn = et_getMultiDivision_exec(shipper_type,item_no,operating_code,pr_qty, purchase_location);
//            setStatus(1);
//            setValue(rtn);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            Logger.err.println(userid,this,e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//
//        return getSepoaOut();
//    }
//
//      private String et_getMultiDivision_exec(String shipper_type,String item_no,String operating_code,String pr_qty, String purchase_location) throws Exception
//    {
//        //청구검토목록
//        String rtn = null;
//        ConnectionContext ctx = getConnectionContext();
//        String house_code     =  info.getSession("HOUSE_CODE");
//        StringBuffer sql = new StringBuffer();
//        sql.append( "SELECT     N.VENDOR_CODE,                          \n" );
//        sql.append( "   I.VENDOR_NAME,                                  \n" );
//        sql.append( "   TO_CHAR(" +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(DECODE(I.PRICE_TYPE,'N',I.UNIT_PRICE,GETUNITPRICE(I.PRICE_TYPE,'"+house_code+"',I.PURCHASE_LOCATION,I.ITEM_NO,I.VENDOR_CODE,'"+pr_qty+"',N.CUM_PO_QTY)),0),'FM99,999,999,999,999,999.999') AS LAST_UNIT_PRICE,  \n") ;
//         sql.append( "   " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(DECODE(I.PRICE_TYPE,'N',I.UNIT_PRICE,GETUNITPRICE(I.PRICE_TYPE,'"+house_code+"',I.PURCHASE_LOCATION,I.ITEM_NO,I.VENDOR_CODE,'"+pr_qty+"',N.CUM_PO_QTY)),0) AS UNIT_PRICE, \n ");
//         sql.append( "   "+pr_qty+" * " +getConfig("wise.generator.db.selfuser") +  "."+ "isnull(DECODE(I.PRICE_TYPE,'N',I.UNIT_PRICE,GETUNITPRICE(I.PRICE_TYPE,'"+house_code+"',I.PURCHASE_LOCATION,I.ITEM_NO,I.VENDOR_CODE,'"+pr_qty+"',N.CUM_PO_QTY)),0) AS AMT, \n ");
//         sql.append( "   I.CUR                                           \n" );
//        //sql.append( "   DECODE(I.PRICE_TYPE,'N',I.UNIT_PRICE,           \n" );
//        //sql.append( "               ( SELECT  UNIT_PRICE                \n" );
//        //sql.append( "             FROM ICOYINPR                       \n" );
//        //sql.append( "             WHERE HOUSE_CODE = '"+house_code+"'             \n" );
//        //sql.append( "               AND PURCHASE_LOCATION = '"+purchase_location+"' \n" );
//        //sql.append( "               AND ITEM_NO = '"+item_no+"'                     \n" );
//        //sql.append( "               AND VENDOR_CODE = I.VENDOR_CODE                 \n" );
//        //sql.append( "               AND ("+pr_qty+"+N.CUM_PO_QTY) BETWEEN FROM_QTY AND TO_QTY))  AS UNIT_PRICE,   \n" );
//        //sql.append( " I.EXEC_NO,                                                                  \n" );
//        //sql.append( " N.QUOTA_PERCENT                                             \n" );
//
//        sql.append( " FROM   ICOYINFO I,ICOYINDR N                                  \n" );
//        sql.append( " WHERE  I.HOUSE_CODE=N.HOUSE_CODE                              \n" );
//        sql.append( " AND  I.PURCHASE_LOCATION=N.PURCHASE_LOCATION                  \n" );
//        sql.append( " AND  I.ITEM_NO=N.ITEM_NO                                      \n" );
//        sql.append( " AND  I.VENDOR_CODE=N.VENDOR_CODE                              \n" );
//        sql.append( " AND  I.HOUSE_CODE = '"+house_code+"'                          \n" );
//        sql.append( " AND  I.PURCHASE_LOCATION = '"+purchase_location+"'            \n" );
//        sql.append( " AND  I.STATUS IN ('C','R')                                    \n" );
//        sql.append( " AND  N.STATUS IN ('C','R')                                    \n" );
//        sql.append( " AND  I.ITEM_NO = '"+item_no+"'                                \n" );
//        sql.append( " AND  I.SHIPPER_TYPE = '"+shipper_type+"'                      \n" );
////      sql.append( " AND  replace(convert(varchar, getdate(), 102), '.', '') BETWEEN I.VALID_FROM_DATE AND I.VALID_TO_DATE    \n" ); 05월 20일 석재가 막았어..
//
//
//
//        try{
//            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
//            rtn = sm.doSelect(null);
//        }catch(Exception e) {
//        Logger.err.println(userid,this,e.getMessage());
//        throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
//
    private String et_getcur() throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        String house_code     =  info.getSession("HOUSE_CODE");
        StringBuffer sql = new StringBuffer();
        sql.append(" select code from scode\n");
        sql.append(" where type = 'M002'\n");
        sql.append(" and   house_code = '"+house_code+"'\n");
        sql.append(" and   use_flag = 'Y'\n");
        sql.append(" order by sort_seq\n");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx,sql.toString());
            rtn = sm.doSelect((String[])null);
        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

    public SepoaOut setDelete_myCatalog(String[][] delData)
    {
        //print(delData);
        int rtn = 0;
        try {
            rtn = et_setDelete_myCatalog(delData);

            setStatus(1);
            setValue(Integer.toString(rtn));

            if(rtn >= 0) setMessage("성공");

        }catch(Exception e){
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            Logger.err.println(this,e.getMessage());
        }

        return getSepoaOut();
    }

/**
 *메소드명  : et_setDelete_myCatalog()
 *Description : JTable update
**/
  private int et_setDelete_myCatalog(String[][] delData) throws Exception
  {
    int rtn = -1;
    SepoaFormater wf = null;
    SepoaSQLManager sm1 = null;
    ConnectionContext ctx = getConnectionContext();
    try {
        String house_code     =  info.getSession("HOUSE_CODE");
      StringBuffer sql = new StringBuffer();

      sql.append( " DELETE ICOYMYCL  \n" );
      sql.append( " WHERE HOUSE_CODE = '"+house_code+"'         \n" );
      sql.append( "   AND USER_ID = '"+userid+"'           \n" );
      sql.append( "   AND buyer_item_no = ?        \n" );

      SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
      String[] type = {"S"};
      rtn = sm.doUpdate(delData, type);

      Commit();
    }catch(Exception e) {
      Rollback();
      String serrMessage = e.getMessage();
      String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
      if(sdbErrorCode.equals("ORA-00001") == true){
        rtn = -1;
      } else throw new Exception("et_setDelete_myCatalog:"+e.getMessage());
    }
    return rtn;
  }
  
  public SepoaOut getCatalogMaster( String[] args )
  {
      try
      {
      	String rtn = et_getCatalogMaster( args );
          setValue(rtn);
          String cur = et_getcur();
          setValue(cur);
          setStatus(1);
          setMessage(msg.getMessage("0000"));
      }
      catch(Exception e)
      {
          Logger.err.println(userid,this,e.getMessage());
          setStatus(0);
          setMessage(msg.getMessage("0001"));
      }

      return getSepoaOut();
  }

  private String et_getCatalogMaster( String[] args) throws Exception {

      String rtn = "";
      String rtn1= "";
   
      String add_date     = SepoaDate.getShortDateString();
      try
      {
          ConnectionContext ctx = getConnectionContext();
          String HOUSE_CODE     =  info.getSession("HOUSE_CODE");
          
          SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("HOUSE_CODE", HOUSE_CODE);

          SepoaSQLManager sm = new SepoaSQLManager(userid,this,ctx, wxp.getQuery());
          rtn = sm.doSelect(args);
      }
      catch(Exception e) {
          Logger.err.println(userid,this,e.getMessage());
          throw new Exception(e.getMessage());
      }
      return rtn;
  }

//	public SepoaOut setPRCopy( String[][] data ,String addPrNo){
//		 String lang	= info.getSession("LANGUAGE");
//		 Message msg	= new Message(info, "STDRFQ");
//
//		if(	data == null)	{
//			setStatus(0);
//			setMessage(msg.getMessage("0005"));
//		}
//		else {
//			try	{
//				ConnectionContext ctx =	getConnectionContext();
//				
//				SepoaOut wo = null;
//			    wo = appcommon.getDocNumber(info, "PR");
//				String pr_no = wo.result[0];
//	            
//				int	rtn1 = et_setPRCopy(ctx, data, pr_no);
//				int	rtn2 = et_setPRDTCopy(ctx, data, pr_no);
//
//				if(!"".equals(addPrNo)){
//					int	rtn3 = et_setPRBRCopy(ctx, data, pr_no);
//				}
//				
//				if (rtn1 > 0 && rtn2 > 0) {
//					setStatus(1);
//					setValue(String.valueOf("1"));
//					setMessage("구매요청번호 [" + pr_no + "] 로 복사되었습니다.\n\n복사한 구매요청건을 수정한 후 구매요청 완료하세요.");
//					Commit();
//				} else {
//					setStatus(0);
//					setValue(String.valueOf("0"));
//					setMessage("복사에 실패하였습니다.");
//					Rollback();
//				}
//			} catch(Exception e) {
//				try	{
//					Rollback();
//				} catch(Exception d){
//					Logger.err.println(info.getSession("ID"),this,d.getMessage());
//				}
//				Logger.err.println(info.getSession("ID"),this,e.getMessage());
//				setStatus(0);
//				setMessage(msg.getMessage("0003"));
//			}
//		}
//		return getSepoaOut();
//	}
	
	public SepoaOut setPRCopy(Map<String, String> param){
		Message           msg         = new Message(info, "STDRFQ");
		ConnectionContext ctx         = getConnectionContext();
		SepoaOut          wo          = null;
		String            newPrNo     = null;
		String            id          = info.getSession("ID");
		String            deptCode    = info.getSession("DEPARTMENT");
        String            deptName    = info.getSession("DEPARTMENT_NAME_LOC");
        String            addPrNo     = param.get("addPrNo");
        int               rtnPrCopy   = 0;
        int               rtnPrDtCopy = 0;

		try	{
			wo      = DocumentUtil.getDocNumber(info, "PR");
			newPrNo = wo.result[0];
			
			param.put("NEW_PR_NO", newPrNo);
			param.put("USER_ID",   id);
			param.put("DEPT_CODE", deptCode);
			param.put("DEPT_NAME", deptName);
			
            rtnPrCopy   = this.setPRCopyDoInsert(ctx, "et_setPRCopy", param);
            rtnPrDtCopy = this.setPRCopyDoInsert(ctx, "et_setPRDTCopy", param);
            
            if(addPrNo == null){
            	addPrNo = "";
            }
			
			if("".equals(addPrNo) == false){
				this.setPRCopyDoInsert(ctx, "et_setPRBRCopy", param);
			}
			
			if((rtnPrCopy > 0) && (rtnPrDtCopy > 0)){
				setStatus(1);
				setValue(String.valueOf("1"));
				setMessage("구매요청번호 [" + newPrNo + "] 로 복사되었습니다.\n\n복사한 구매요청건을 수정한 후 구매요청 완료하세요.");
				Commit();
			}
			else{
				setStatus(0);
				setValue(String.valueOf("0"));
				setMessage("복사에 실패하였습니다.");
				Rollback();
			}
		}
		catch(Exception e) {
			try{
				Rollback();
			}
			catch(Exception d){
				Logger.err.println(info.getSession("ID"),this,d.getMessage());
			}
			
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			setStatus(0);
			setMessage(msg.getMessage("0003"));
		}
		
		return getSepoaOut();
	}
	
	private int setPRCopyDoInsert(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
		SepoaXmlParser    sxp         = null;
		SepoaSQLManager   ssm         = null;
		String            id          = info.getSession("ID");
		int               result      = 0;
		
		sxp = new SepoaXmlParser(this, methodName);
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        result = ssm.doInsert(param);
        
        return result;
	}

	private	int	et_setPRCopy(ConnectionContext ctx,String[][] data, String pr_no) throws Exception
	{
		int	rtn	= 0;
		try	{
            String HOUSE_CODE	= info.getSession("HOUSE_CODE");
            String USER_ID		= info.getSession("ID");
            String DEPT_CODE	= info.getSession("DEPARTMENT");
            String DEPT_NAME	= info.getSession("DEPARTMENT_NAME_LOC");
    		
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("HOUSE_CODE",	HOUSE_CODE);
        	wxp.addVar("PR_NO",			pr_no);
        	wxp.addVar("USER_ID", 		USER_ID);
        	wxp.addVar("DEPT_CODE", 	DEPT_CODE);
        	wxp.addVar("DEPT_NAME", 	DEPT_NAME);
        	
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
			
			String[] type =	{"S","S"};
			rtn	= sm.doUpdate(data,type);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

	private	int	et_setPRDTCopy(ConnectionContext ctx,String[][] data, String pr_no) throws Exception
	{
		int	rtn	= 0;
		try	{
            String HOUSE_CODE	= info.getSession("HOUSE_CODE");
            String USER_ID		= info.getSession("ID");
            String DEPT_CODE	= info.getSession("DEPARTMENT");
            String DEPT_NAME	= info.getSession("DEPARTMENT_NAME_LOC");
    		
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("HOUSE_CODE",	HOUSE_CODE);
        	wxp.addVar("PR_NO",			pr_no);
        	wxp.addVar("USER_ID", 		USER_ID);
        	wxp.addVar("DEPT_CODE", 	DEPT_CODE);
        	wxp.addVar("DEPT_NAME", 	DEPT_NAME);
			
        	SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
        	
			String[] type =	{"S","S"};
			rtn	= sm.doUpdate(data,type);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	private	int	et_setPRBRCopy(ConnectionContext ctx,String[][] data, String pr_no) throws Exception
	{
		int	rtn	= 0;
		try	{
            String HOUSE_CODE	= info.getSession("HOUSE_CODE");
            String USER_ID		= info.getSession("ID");
            String DEPT_CODE	= info.getSession("DEPARTMENT");
            String DEPT_NAME	= info.getSession("DEPARTMENT_NAME_LOC");
    		
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	wxp.addVar("HOUSE_CODE",	HOUSE_CODE);
        	wxp.addVar("PR_NO",			pr_no);
        	wxp.addVar("USER_ID", 		USER_ID);
        	wxp.addVar("DEPT_CODE", 	DEPT_CODE);
        	wxp.addVar("DEPT_NAME", 	DEPT_NAME);
			
        	SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
        	
			String[] type =	{"S","S"};
			rtn	= sm.doUpdate(data,type);
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	//반려건 카트로 되돌리기
	public SepoaOut doReturnCart(List<Map<String, String>> param){
		Message msg = new Message(info, "STDRFQ");
		ConnectionContext ctx = getConnectionContext();
		SepoaOut wo = null;
		SepoaFormater sf = null;
		String rtn = null;
		String id = info.getSession("ID");
		String house_code = info.getSession("HOUSE_CODE");
        int rtnPrDelete = 0;
        int rtnPrDtDelete = 0;
        int rtnSCTMDelete = 0;
        int rtnSCTPDelete = 0;
        int rtnCartInsert = 0;
        
        Map<String, String> gridInfo = null;
        Map<String, String> set_data = new HashMap<String, String>();

		try {
			
//			Logger.err.println("param============="+param.toString());
//			System.out.println("param============="+param.toString());
			//받은 리스트형식의 데이터를 for문 돌려서 map에 담는다.
			for(int i = 0; i < param.size(); i++) {
				gridInfo = param.get(i);
				
				gridInfo.put("USER_ID", id);
				gridInfo.put("HOUSE_CODE", house_code);
				
				//cart에 넣을 데이터를 추출하여 넣을 변수를 만든다.
				String item_no = "";	//품목코드
				String pr_qty = "";	//수량
				String pr_rd_date = "";	//요청일
				
				//필요한 데이터를 PR테이블에서 뽑아낸다.
				rtn = this.select(ctx, "selectPrInfo", gridInfo);
				
				//뽑은데이터를 sepoafomater에 담는다.
				sf = new SepoaFormater(rtn);
				
				//포매터에 담은 데이터의 row개수가 0보다 크면...
				if(sf.getRowCount() > 0) {
					//row만큼 for문을 돌려서...
					for(int j = 0; j < sf.getRowCount(); j++) {
						//포매터의 데이터를 변수로 담은 다음,
						item_no = sf.getValue("ITEM_NO", j);
						pr_qty = sf.getValue("PR_QTY", j);
						pr_rd_date = sf.getValue("RD_DATE", j);
						
						//최초에 만든 map에 담아서...
						set_data.put("HOUSE_CODE", house_code);
						set_data.put("USER_ID", id);
						set_data.put("ITEM_NO", item_no);
						set_data.put("PR_QTY", pr_qty);
						set_data.put("RD_DATE", pr_rd_date);
						
						//Cart에 넣는다.
						this.setCartDoInsert(set_data);
					}
				} else {
					throw new Exception("PR데이터의 품목이 존재하지 않습니다.");
				}
				
				//Cart에 다시 담았으면 생성했었던 PR데이터와 관련 결재테이블 데이터는 삭제한다.
				rtnPrDtDelete = this.PRDTDelete(ctx, "PRDTDelete", gridInfo);
				rtnPrDelete = this.PRHDDelete(ctx, "PRHDDelete", gridInfo);
				rtnSCTMDelete = this.SCTMDelete(ctx, "SCTMDelete", gridInfo);
				rtnSCTPDelete = this.SCTPDelete(ctx, "SCTPDelete", gridInfo);
			}
			
			Commit();
			setStatus(1);
			setValue(String.valueOf("1"));
			setMessage("처리를 완료하였습니다. 신청내역에서 품목을 확인하십시오.");
		}
		catch(Exception e) {
			try{
				Rollback();
			}
			catch(Exception d){
				Logger.err.println(info.getSession("ID"),this,d.getMessage());
			}
			
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			setStatus(0);
			setMessage(msg.getMessage("0003"));
		}
		
		return getSepoaOut();
	}
	
	//카드에 다시 담기(p1015.java 의 메서드와 동일한 방식)
	public SepoaOut setCartDoInsert(Map<String, String> data) throws Exception{
		try {
	        ConnectionContext ctx      = getConnectionContext();
			boolean isInsert = this.insertSprcartSelectSprCartInfo(ctx, data);
			
			setStatus(1);
			setFlag(true);
			
			if(isInsert){
				this.insert(ctx, "insertSprcartInfo", data);
			} else {
				this.update(ctx, "updateSprcartInfo", data);
			}
			
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
	
	//카트에 기존데이터가 있는지 확인
	private boolean insertSprcartSelectSprCartInfo(ConnectionContext ctx, Map<String, String> header) throws Exception{
    	String        rtn    = null;
    	String        cnt    = null;
    	SepoaFormater sf     = null;
    	boolean       result = false;
    	
    	rtn = this.select(ctx, "selectSprCartInfo", header);
    	
    	sf = new SepoaFormater(rtn);
    	
    	cnt = sf.getValue("CNT", 0);
    	
    	if("0".equals(cnt)){
    		result = true;
    	}
    	else{
    		result = false;
    	}
    	
    	return result;
    }
	
	//PR HD테이블 삭제
	private int PRHDDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
		SepoaXmlParser    sxp         = null;
		SepoaSQLManager   ssm         = null;
		String            id          = info.getSession("ID");
		int               result      = 0;
		
		sxp = new SepoaXmlParser(this, methodName);
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        result = ssm.doDelete(param);
        
        return result;
	}
	
	//PR DT테이블 삭제
	private int PRDTDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
		SepoaXmlParser    sxp         = null;
		SepoaSQLManager   ssm         = null;
		String            id          = info.getSession("ID");
		int               result      = 0;
		
		sxp = new SepoaXmlParser(this, methodName);
        ssm = new SepoaSQLManager(id, this, ctx, sxp);
        
        result = ssm.doDelete(param);
        
        return result;
	}
	
	//결재테이블 SCTM삭제
	private int SCTMDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
		SepoaXmlParser    sxp         = null;
		SepoaSQLManager   ssm         = null;
		String            id          = info.getSession("ID");
		int               result      = 0;
		
		sxp = new SepoaXmlParser(this, methodName);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doDelete(param);
		
		return result;
	}
	
	//결재테이블 SCTP삭제
	private int SCTPDelete(ConnectionContext ctx, String methodName, Map<String, String> param) throws Exception{
		SepoaXmlParser    sxp         = null;
		SepoaSQLManager   ssm         = null;
		String            id          = info.getSession("ID");
		int               result      = 0;
		
		sxp = new SepoaXmlParser(this, methodName);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doDelete(param);
		
		return result;
	}
	
	//select 쿼리 작동 메서드
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
		
		//insert 쿼리 작동 메서드
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
	    
		//update 쿼리 작동 메서드
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
	    
	    /*
	     * 품목조회(영업점) 쿼리 개요
	     * 기본적으로 MTGL을 기본으로 한다.(구매지역은 OUTER JOIN)
	     * 구매쪽 정보를 얻으려면
	     * ICOMMCPM에 MATERIAL_CLASS1과 MTGL의 MATERIAL_CLASS1이 조인되어야한다.
	     * ICOMBAPR.PR_LOCATION과 ICOMLUSR.PR_LOCATION을 조인하여 사용자와 연결된 구매지역을 가져온다.
	     * ICOMMCPM의 PURCHASE_LOCATION과 ICOMBAPR.PURCHASE_LOCATION을 조인하여
	     * 사용자와 연결된 구매지역과 품목 일반정보의 품목을 가져올 수 있다.
	     */
		public SepoaOut getCatalog5(Map<String, String> header){
			ConnectionContext ctx = null;
			SepoaXmlParser    sxp = null;
			SepoaSQLManager   ssm = null;
			String            rtn = null;
			String            cur = null;
			
	        try{
	        	setStatus(1);
				setFlag(true);
				
	        	ctx = getConnectionContext();
				
				sxp = new SepoaXmlParser(this, "et_getCatalog5");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
	        	
				header = this.getCatalogHeader(header);
	        	rtn    = ssm.doSelect(header);
	        	cur    = et_getcur();
	        	
	            setValue(rtn);
	            setValue(cur);
	            setMessage(msg.getMessage("0000"));
	        }
	        catch(Exception e){
	            Logger.err.println(userid,this,e.getMessage());
	            setStatus(0);
	            setMessage(msg.getMessage("0001"));
	        }

	        return getSepoaOut();
	    }
}


