package dt.app;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class app_pp_dis4 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getCNDPInfo".equals(mode)){
    			gdRes = this.getCNDPInfo(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getCNDPInfo(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	    	
	    	value = ServiceConnector.doService(info,"p1062","CONNECTION","getCNDPInfo",obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			else{
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
			    			}
			    		}
			    	}
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}    
//	public void doQuery(WiseStream ws) throws Exception 
//    {
//         String mode = ws.getParam("mode");
//        String exec_no    = ws.getParam("exec_no");
//		
//		String pr_type  = ws.getParam("pr_type");
//        if(mode.equals("getCNDPInfo")){
//        	getCNDPInfo(exec_no, ws);
//        }else if(pr_type.equals("I")){
//    		getItemList(exec_no, ws);		//��ǰ
//        	
//        }else{
//        	getServiceList(exec_no, ws);	//�뿪
//        }
//    }
//    private void getCNDPInfo(String exec_no, WiseStream ws) throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//    	
//        String house_code = info.getSession("HOUSE_CODE");
//        
//		String[] args = {
//				house_code
//				, exec_no
//				
//		};
//		 
//		
//		Object[] obj = {args};
//		
//		WiseOut value = ServiceConnector.doService(info,"p1062","CONNECTION","getCNDPInfo",obj);
//    	
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//		if(wf.getRowCount() == 0) 
//		{
//	    	ws.setMessage(msg.getMessage("0008"));
//			ws.write();
//			return;
//  	    }
//		
//		for(int i=0; i<wf.getRowCount(); i++)
//		{
//			
//			String[] check = {"true", ""};
//			ws.addValue("SEL"				 , check						   	   , "");	
//			ws.addValue("DP_SEQ"			 , wf.getValue("DP_SEQ"			    ,i), ""); 
//			ws.addValue("DP_TYPE"            , wf.getValue("DP_TYPE"            ,i), ""); 
//			ws.addValue("DP_PERCENT"         , wf.getValue("DP_PERCENT"         ,i), "");
//			ws.addValue("DP_AMT"             , wf.getValue("DP_AMT"             ,i), "");   
//			ws.addValue("DP_PLAN_DATE"       , wf.getValue("DP_PLAN_DATE"       ,i), "");   
//			ws.addValue("DP_PAY_TERMS"       , wf.getValue("DP_PAY_TERMS"       ,i), "");   
//			ws.addValue("DP_PAY_TERMS_TEXT"  , wf.getValue("DP_PAY_TERMS_TEXT"  ,i), "");   
//			ws.addValue("FIRST_DEPOSIT"      , wf.getValue("FIRST_DEPOSIT"      ,i), "");   
//			ws.addValue("FIRST_PERCENT"      , wf.getValue("FIRST_PERCENT"      ,i), "");   
//			ws.addValue("CONTRACT_DEPOSIT"   , wf.getValue("CONTRACT_DEPOSIT"   ,i), "");   
//			ws.addValue("CONTRACT_PERCENT"   , wf.getValue("CONTRACT_PERCENT"   ,i), "");
//			ws.addValue("MENGEL_DEPOSIT"     , wf.getValue("MENGEL_DEPOSIT"     ,i), "");
//			ws.addValue("MENGEL_PERCENT"     , wf.getValue("MENGEL_PERCENT"     ,i), "");        
//			ws.addValue("DP_DIV"     		 , wf.getValue("DP_DIV"    		 	,i), "");
//			ws.addValue("DP_CODE"     		 , wf.getValue("DP_CODE"    		,i), "");
//			ws.addValue("PRE_CONT_YN"     	 , wf.getValue("PRE_CONT_YN"    	,i), "");	
//			ws.addValue("FIRST_METHOD"     	 , wf.getValue("FIRST_METHOD"    	,i), "");
//			ws.addValue("CONTRACT_METHOD"    , wf.getValue("CONTRACT_METHOD"   	,i), "");
//			ws.addValue("MENGEL_METHOD"      , wf.getValue("MENGEL_METHOD"    	,i), "");
//
//			
//			
//		}
//		
//		ws.setMessage(value.message);
//		ws.write();
//    }
//	/**
//	 * 품의생성시 디테일 내역을 조회한다.
//	 * <pre>
//	 * rfq_data_info 대신 ""이 들어간다. 주의할 것.
//	 * 
//	 * </pre>
//	 * @param mode
//	 * @param ws
//	 * @throws Exception
//	 */
//	private void getItemList(String exec_no, WiseStream ws) throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//    	
//        String house_code = info.getSession("HOUSE_CODE");
//        
//		String[] args = {
//				house_code
//				, exec_no
//				
//		};
//		 
//		
//		Object[] obj = {exec_no};
//		
//		WiseOut value = ServiceConnector.doService(info,"p1062","CONNECTION","getQTAInfo",obj);
//    	
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//		if(wf.getRowCount() == 0) 
//		{
//	    	ws.setMessage(msg.getMessage("0008"));
//			ws.write();
//			return;
//  	    }
//		
//        String icon_con_gla = "/kr/images/icon/detail.gif";
//		
//        String combo_1Tmp[][] = null;
//        combo_1Tmp = new String[2][2];
//        combo_1Tmp[0][0] = "N";
//        combo_1Tmp[0][1] = "N";
//        combo_1Tmp[1][0] = "Y";
//        combo_1Tmp[1][1] = "Y";
//		for(int i=0; i<wf.getRowCount(); i++)
//		{
//			String[] check = {"true", ""};
//			String[] img_pr_no 			= {"", wf.getValue("PR_NO",i)		  , wf.getValue("PR_NO",i)};
//			String[] img_item_no 		= {"", wf.getValue("ITEM_NO",i)		  , wf.getValue("ITEM_NO",i)};
//			String[] img_vendor_code 	= {"", wf.getValue("PO_VENDOR_CODE",i)	  , wf.getValue("PO_VENDOR_CODE",i)};			
//			String[] img_pay_terms 		= {icon_con_gla, "1", ""};
//			String[] img_sourcing_no 	= {"", wf.getValue("SOURCING_NO",i)	  , wf.getValue("SOURCING_NO",i)};
//			String[] img_sourcing_no2 	= {"", "RFQ".equals(wf.getValue("SOURCING_TYPE",i)) ? wf.getValue("QTA_NO",i) : ""	  , "RFQ".equals(wf.getValue("SOURCING_TYPE",i)) ? wf.getValue("QTA_NO",i) : ""};
//						
//			int insur = wf.getValue("INSURANCE"         ,i).equals("Y")?1:0;
//			int cont  = wf.getValue("CONTRACT_FLAG"     ,i).equals("Y")?1:0;
//			ws.addValue( "SELECTED"			 , check, "");
//			ws.addValue( "PR_NO"			 , img_pr_no						   , "");
//			ws.addValue( "SUBJECT"			 , wf.getValue("SUBJECT"   			,i), "");
//			ws.addValue( "SETTLE_FLAG"		 , wf.getValue("SETTLE_FLAG"   		,i), "");
//			ws.addValue( "ADD_USER_ID"		 , wf.getValue("USER_NAME"     		,i), "");
//			ws.addValue( "PO_VENDOR_CODE"	 , img_vendor_code					   , "");
//			ws.addValue( "VENDOR_NAME"		 , wf.getValue("VENDOR_NAME"      	,i), "");
//			ws.addValue( "ITEM_NO"			 , img_item_no						   , "");	
//			ws.addValue( "DESCRIPTION_LOC"	 , wf.getValue("DESCRIPTION_LOC"    ,i), "");
//			ws.addValue("SPECIFICATION"      , wf.getValue("SPECIFICATION"     	,i), ""); 
//			ws.addValue("MAKER_NAME"       	 , wf.getValue("MAKER_NAME"     	,i), "");
//			ws.addValue("MAKER_CODE"       	 , wf.getValue("MAKER_CODE"     	,i), "");    
//			ws.addValue( "QTY"				 , wf.getValue("PR_QTY"       		,i), "");   
//			ws.addValue( "UNIT_MEASURE"		 , wf.getValue("UNIT_MEASURE"      	,i), "");   
//			ws.addValue( "UNIT_PRICE"		 , wf.getValue("PO_UNIT_PRICE"      ,i), "");   
//			ws.addValue( "ITEM_AMT"			 , wf.getValue("PO_ITEM_AMT"        ,i), "");   
//			ws.addValue( "CUSTOMER_PRICE"	 , wf.getValue("CUSTOMER_PRICE"     ,i), "");   
//			ws.addValue( "S_ITEM_AMT"		 , wf.getValue("CUSTOMER_ITEM_AMT" 	,i), "");   
//			ws.addValue( "DISCOUNT"			 , wf.getValue("DISCOUNT"     		,i), "");
//			ws.addValue( "SALE_PER_2"		 , wf.getValue("SALE_2"          	,i), "");
//			ws.addValue("SALE_AMT"          , wf.getValue("SALE_AMT"          	,i), ""); 
//			ws.addValue( "PR_UNIT_PRICE"	 , wf.getValue("PR_UNIT_PRICE"         ,i), "");         
//			ws.addValue( "PR_AMT"			 , wf.getValue("PR_AMT"      		,i), "");
//			ws.addValue( "RD_DATE"			 , wf.getValue("RD_DATE"            ,i), "");
//			ws.addValue( "PAY_TERMS"		 , img_pay_terms					   , "");
//			ws.addValue( "PAY_TERMS_HD"		 , wf.getValue("PAY_TERMS"          ,i), "");
//			ws.addValue("PAY_TERMS_HD_DESC" , wf.getValue("PAY_TERMS_DESC"      ,i), ""); 
//			ws.addValue( "CONTRACT_FLAG"	 , wf.getValue("CONTRACT_FLAG"      ,i), "");     
//			ws.addValue( "INSURANCE"		 , wf.getValue("INSURANCE"      	,i), "");     		
//			ws.addValue( "VALID_FROM_DATE"	 , wf.getValue("VALID_FROM_DATE"    ,i), "");       
//            ws.addValue( "VALID_TO_DATE"	 , wf.getValue("VALID_TO_DATE"   	,i), ""); 
//            ws.addValue( "SPACE"			 , ""								   , "");
//            ws.addValue( "DP_INFO"			 , wf.getValue("DP_INFO"            ,i), ""); 
//			ws.addValue( "CUR"				 , wf.getValue("CUR"          		,i), ""); 
//			ws.addValue( "PR_SEQ"			 , wf.getValue("PR_SEQ"            	,i), ""); 
//			ws.addValue( "RFQ_NO"            , wf.getValue("RFQ_NO"             ,i), ""); 
//			ws.addValue( "RFQ_COUNT"         , wf.getValue("RFQ_COUNT"          ,i), ""); 
//			ws.addValue( "RFQ_SEQ"           , wf.getValue("RFQ_SEQ"            ,i), ""); 
//			//ws.addValue( "QTA_NO"            , wf.getValue("QTA_NO"             ,i), ""); 
//			ws.addValue( "QTA_NO"            , img_sourcing_no2					   , ""); 
//			ws.addValue( "QTA_SEQ"			 , wf.getValue("QTA_SEQ"           	,i), "");
//			ws.addValue( "EXEC_NO"           , wf.getValue("EXEC_NO"            ,i), ""); 
//			ws.addValue( "EXEC_SEQ"			 , wf.getValue("EXEC_SEQ"           ,i), "");			
//			ws.addValue( "SOURCING_NO"		 , img_sourcing_no					   , "");
//			ws.addValue( "SOURCING_COUNT"	 , wf.getValue("SOURCING_COUNT"     ,i), "");
//			ws.addValue( "SOURCING_TYPE"	 , wf.getValue("SOURCING_TYPE"      ,i), "");
//			ws.addValue( "SOURCING_VOTE_COUNT", wf.getValue("SOURCING_VOTE_COUNT"      ,i), "");			
//			ws.addValue( "DELY_TO_ADDRESS"	 , wf.getValue("DELY_TO_ADDRESS"    ,i), "");
//			ws.addValue( "WARRANTY"			 , wf.getValue("WARRANTY"           ,i), "");
//			
//			ws.addValue( "SOURCING_ANNOUNCE_FLAG", wf.getValue("SOURCING_ANNOUNCE_FLAG"      ,i), "");
//			ws.addValue( "ITEM_GBN"			, wf.getValue("ITEM_GBN"      ,i), "");
//		}
//		
//		ws.setMessage(value.message);
//		ws.write();
//    }
//	/**
//	 * 품의생성시 디테일 내역을 조회한다.
//	 * <pre>
//	 * rfq_data_info 대신 ""이 들어간다. 주의할 것.
//	 * 
//	 * </pre>
//	 * @param mode
//	 * @param ws
//	 * @throws Exception
//	 */
//	private void getServiceList(String exec_no, WiseStream ws) throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//    	
//        String house_code = info.getSession("HOUSE_CODE");
//        
//		String[] args = {
//				house_code
//				, exec_no
//				
//		};
//		 
//		
//		Object[] obj = {exec_no};
//		
//		WiseOut value = ServiceConnector.doService(info,"p1062","CONNECTION","getQTAInfo",obj);
//    	
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//		if(wf.getRowCount() == 0) 
//		{
//	    	ws.setMessage(msg.getMessage("0008"));
//			ws.write();
//			return;
//  	    }
//		
//        String icon_con_gla = "/kr/images/icon/detail.gif";
//		
//        String combo_1Tmp[][] = null;
//        combo_1Tmp = new String[2][2];
//        combo_1Tmp[0][0] = "N";
//        combo_1Tmp[0][1] = "N";
//        combo_1Tmp[1][0] = "Y";
//        combo_1Tmp[1][1] = "Y";
//		for(int i=0; i<wf.getRowCount(); i++)
//		{
//			String[] check = {"true", ""};
//			String[] img_pr_no 			= {"", wf.getValue("PR_NO",i)		  , wf.getValue("PR_NO",i)};
//			String[] img_item_no 		= {"", wf.getValue("ITEM_NO",i)		  , wf.getValue("ITEM_NO",i)};
//			String[] img_vendor_code 	= {"", wf.getValue("VENDOR_CODE",i)	  , wf.getValue("VENDOR_CODE",i)};
//			String[] img_pay_terms 		= {icon_con_gla, "1", ""};
//			int insur = wf.getValue("INSURANCE"         ,i).equals("Y")?1:0;
//			int cont  = wf.getValue("CONTRACT_FLAG"     ,i).equals("Y")?1:0;
//			ws.addValue( "SELECTED"			, check, "");
//			ws.addValue( "PR_NO"			, img_pr_no							   , "");
//			ws.addValue( "SUBJECT"			, wf.getValue("SUBJECT"				,i), "");
//			ws.addValue( "SETTLE_FLAG"		 , wf.getValue("SETTLE_FLAG"   		,i), "");
//			ws.addValue( "ADD_USER_ID"		, wf.getValue("ADD_USER_ID"			,i), "");
//			ws.addValue( "USER_NAME"		, wf.getValue("USER_NAME"			,i), "");
//			ws.addValue( "PO_VENDOR_CODE"	, img_vendor_code					   , "");
//			ws.addValue( "VENDOR_NAME"		, wf.getValue("VENDOR_NAME"			,i), "");	
//			ws.addValue( "ITEM_NO"			, img_item_no						   , "");   
//			ws.addValue( "DESCRIPTION_LOC"	, wf.getValue("DESCRIPTION_LOC"	    ,i), "");   
//			ws.addValue( "QTY"				, wf.getValue("PR_QTY"			    ,i), ""); 
//			ws.addValue( "UNIT_MEASURE"		 , wf.getValue("UNIT_MEASURE"      	,i), "");  
//			ws.addValue( "UNIT_PRICE"		, wf.getValue("Q_UNIT_PRICE"		,i), "");   
//			ws.addValue( "ITEM_AMT"			, wf.getValue("Q_ITEM_AMT"			,i), "");   
//			ws.addValue( "TECHNIQUE_GRADE"	, wf.getValue("TECHNIQUE_GRADE"	    ,i), "");   
//			ws.addValue( "PR_UNIT_PRICE"	, wf.getValue("PR_UNIT_PRICE"	    	,i), "");   
//			ws.addValue( "PR_AMT"			, wf.getValue("PR_AMT"			    ,i), "");
//			ws.addValue("SALE_AMT"          , wf.getValue("SALE_AMT"          	,i), ""); 
//			ws.addValue( "RD_DATE"			, wf.getValue("RD_DATE"			    ,i), "");
//			ws.addValue( "PAY_TERMS"		, img_pay_terms, "");         
//			ws.addValue( "PAY_TERMS_HD"		, wf.getValue("PAY_TERMS"		    ,i), "");
//			ws.addValue("PAY_TERMS_HD_DESC" , wf.getValue("PAY_TERMS_DESC"      ,i), ""); 
//			ws.addValue( "INPUT_FROM_DATE"	, wf.getValue("INPUT_FROM_DATE"	    ,i), "");
//			ws.addValue( "INPUT_TO_DATE"	, wf.getValue("INPUT_TO_DATE"	    ,i), "");
//			ws.addValue( "CONTRACT_FLAG"	, combo_1Tmp, "", insur);
//			ws.addValue( "INSURANCE"		, combo_1Tmp, "", cont); 
//			ws.addValue( "SPACE"			, ""								   , "");
//			ws.addValue( "DP_INFO"			, wf.getValue("DP_INFO"             ,i), "");
//            ws.addValue( "CUR"				, wf.getValue("CUR"           		,i), "");
//            ws.addValue( "PR_SEQ"			, wf.getValue("PR_SEQ"             	,i), "");
//            ws.addValue( "RFQ_NO"           , wf.getValue("RFQ_NO"              ,i), ""); 
//			ws.addValue( "RFQ_COUNT"        , wf.getValue("RFQ_COUNT"           ,i), ""); 
//			ws.addValue( "RFQ_SEQ"          , wf.getValue("RFQ_SEQ"             ,i), ""); 
//			ws.addValue( "QTA_NO"           , wf.getValue("QTA_NO"              ,i), ""); 
//			ws.addValue( "QTA_SEQ"			, wf.getValue("QTA_SEQ"             ,i), ""); 
//			ws.addValue( "EXEC_NO"          , wf.getValue("EXEC_NO"             ,i), ""); 
//			ws.addValue( "EXEC_SEQ"         , wf.getValue("EXEC_SEQ"           	,i), "");  
//			ws.addValue( "SALE_PER_2"		 , wf.getValue("SALE_2"          	,i), "");
//			ws.addValue( "ITEM_GBN"			, wf.getValue("ITEM_GBN"      ,i), "");
//		}
//		
//		ws.setMessage(value.message);
//		ws.write();
//    }
}
