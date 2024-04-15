package dt.app;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;



import java.util.List;
import java.util.Map;
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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class app_bd_ins1 extends HttpServlet{
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
    		
    		if("getEXDTInfo".equals(mode)){
    			gdRes = this.getEXDTInfo(gdReq, info);
    		}
    		else if("getCNDPInfo".equals(mode)){
    			gdRes = this.getCNDPInfo(gdReq, info);
    		}
    		else if("setInsertEX".equals(mode)){
    			gdRes = this.setInsertEX(gdReq, info);
    		}
    		else if("getDetailItem".equals(mode)) {
    			gdRes = this.getDetailItem(gdReq, info);
    		}
    		else if("doSaveDocNo".equals(mode)) {
    			gdRes = this.doSaveDocNo(gdReq, info);
    		}
    		else if("doDeleteDocNo".equals(mode)) {
    			gdRes = this.doDeleteDocNo(gdReq, info);
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
    
    
    /**
     * 상세문서번호 저장 : 존재여부 체크 후 INSERT/UPDATE
     * @param gdReq
     * @param info
     * @return
     * @throws Exception
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData doSaveDocNo(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
	    Vector              multilangId = new Vector();
	    HashMap             message     = null;
	    SepoaOut            value       = null;
	    Map<String, Object> data        = null;
	    
	    multilangId.addElement("MESSAGE");
	    
		message = MessageUtil.getMessage(info, multilangId);
		
		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			
			data = SepoaDataMapper.getData(info, gdReq);
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "p1062", "TRANSACTION", "doSaveDocNo", obj);
			
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}
			else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		}
		catch(Exception e){
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
		
	    return gdRes;
    }
	
	/**
	 * 상세품목등록 삭제
	 * @param gdReq
	 * @param info
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData doDeleteDocNo(GridData gdReq, SepoaInfo info) throws Exception{
		GridData            gdRes       = new GridData();
		Vector              multilangId = new Vector();
		HashMap             message     = null;
		SepoaOut            value       = null;
		Map<String, Object> data        = null;
		
		multilangId.addElement("MESSAGE");
		
		message = MessageUtil.getMessage(info, multilangId);
		
		try {
			gdRes.addParam("mode", "doDelete");
			gdRes.setSelectable(false);
			
			data = SepoaDataMapper.getData(info, gdReq);
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "p1062", "TRANSACTION", "doDeleteDocNo", obj);
			
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}
			else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		}
		catch(Exception e){
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	

	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setInsertEX(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		List<Map<String, String>> grid          = null;
    		Map<String, String>       gridInfo      = null;
    		Map<String, String> 	  header		= null;
    		
    		header = MapUtils.getMap(data, "headerData");
    		grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    		
    		String house_code   	= info.getSession("HOUSE_CODE");
    		String add_user_id  	= info.getSession("ID");
    		String company_code 	= info.getSession("COMPANY_CODE");
    		String add_date     	= SepoaDate.getShortDateString();
    		String add_time     	= SepoaDate.getShortTimeString();
    		String pr_location  	= info.getSession("PR_LOCATION");
    
    		String exec_amt_krw    	= header.get("exec_amt_krw");
    		String dp_info    	   	= header.get("dp_info");
    		String exec_flag       	= header.get("exec_flag");
    		String ctrl_code       	= header.get("ctrl_code");
    		String attach_no       	= header.get("attach_no");
    		String pay_terms       	= header.get("pay_terms");
    		String dely_terms      	= header.get("dely_terms");
    		String subject         	= header.get("subject");
    		String remark          	= header.get("remark");
    		String ttl_item_qty    	= header.get("ttl_item_qty");
    		String cur             	= header.get("cur");
    		String sign_status     	= header.get("sign_status");
    		String approval_str    	= header.get("approval_str");
    		String ctrl_person_id  	= header.get("ctrl_person_id");
    		String create_type     	= header.get("create_type");
    		String pr_type     	   	= header.get("pr_type");
    		String valid_from_date 	= header.get("valid_from_date"  );
    		String valid_to_date   	= header.get("valid_to_date"	);
    		String po_type         	= header.get("po_type");
    		String ahead_flag      	= header.get("ahead_flag");
    		String exec_no		   	= header.get("exec_no");
    		String original_exec_no = header.get("exec_no");
    		String req_type			= header.get("req_type");	 // 사전품의 : B, 품의 : P
    		String pre_exec_no	   	= header.get("pre_exec_no"); // 구매품의 작성시의 사전품의번호
    		String del_pr_data 		= header.get("del_pr_data");	// 수정시 삭제된 품목들	 이미 견적을 탄놈들이라서  CNDT에 STATUS = 'D' 인 상태로 인서트되야한다.
    		String remain_pr_data   = header.get("remain_pr_data");// 조회된 데이터중 삭제되지않고 남아있는 데이터
    		String gridModifyFlag	= header.get("gridModifyFlag");// 그리드의 내용이 수정이 됐는지의 여부    
    		
    		// 2011.09.07 HMCHOI
    		// 변경품의서 작성인 경우 이전 품의번호를 저장한다.
    		String bf_exec_no	= header.get("bf_exec_no");
    		
    		String po_yn = header.get("po_yn");
    		
    		
    		ctrl_person_id 		= ctrl_person_id==null?add_user_id:ctrl_person_id;
    		//WiseFormater wf		= ws.getWiseFormater();
    		int iRowCount 		= grid.size();
    		
    		String[] ITEM_NO                   = new String[iRowCount];
    		String[] DESCRIPTION_LOC           = new String[iRowCount];
    		String[] SPECIFICATION             = new String[iRowCount];
    		String[] VENDOR_CODE               = new String[iRowCount];
    		String[] VENDOR_NAME               = new String[iRowCount];
    		String[] SETTLE_QTY                = new String[iRowCount];
    		String[] UNIT_MEASURE              = new String[iRowCount];
    		String[] CUR                       = new String[iRowCount];
    		String[] UNIT_PRICE                = new String[iRowCount];
    		String[] ITEM_AMT                  = new String[iRowCount];
    		String[] CONTRACT_FLAG             = new String[iRowCount];
    		String[] QUOTA_PERCENT             = new String[iRowCount];
    		String[] YEAR_QTY                  = new String[iRowCount];
    		String[] PURCHASE_COUNT            = new String[iRowCount];
    		                                   
    		String[] PR_NO                     = new String[iRowCount];
    		String[] PR_SEQ                    = new String[iRowCount];
    		String[] PR_USER_NAME              = new String[iRowCount];
    		String[] PREV_UNIT_PRICE           = new String[iRowCount];
    		String[] BID_TYPE                  = new String[iRowCount];
    		String[] BID_TYPE_TEXT             = new String[iRowCount];
    		String[] PURCHASE_PRE_PRICE        = new String[iRowCount];
    		String[] RD_DATE                   = new String[iRowCount];
    		String[] MOLDING_CHARGE            = new String[iRowCount];
    		String[] SHIPPER_TYPE              = new String[iRowCount];
    		String[] PURCHASE_CONV_RATE        = new String[iRowCount];
    		String[] PURCHASE_CONV_QTY         = new String[iRowCount];
    		String[] RFQ_NO                    = new String[iRowCount];
    		String[] RFQ_COUNT                 = new String[iRowCount];
    		String[] RFQ_SEQ                   = new String[iRowCount];
    		String[] QTA_NO                    = new String[iRowCount];
    		String[] QTA_SEQ                   = new String[iRowCount];
    		String[] SETTLE_TYPE               = new String[iRowCount];
    		String[] SETTLE_FLAG               = new String[iRowCount];
    		                                   
    		String[] DO_FLAG                   = new String[iRowCount];
    		String[] Z_WORK_STAGE_FLAG         = new String[iRowCount];
    		String[] Z_DELIVERY_CONFIRM_FLAG   = new String[iRowCount];
    		String[] DP_INFO				   = new String[iRowCount];
    		String[] VALID_FROM_DATE 		   = new String[iRowCount];
    		String[] VALID_TO_DATE   		   = new String[iRowCount];
    		String[] PAY_TERMS_HD   		   = new String[iRowCount];
    		String[] INSURANCE   			   = new String[iRowCount];
    		String[] CUSTOMER_PRICE   		   = new String[iRowCount];
    		String[] DISCOUNT   			   = new String[iRowCount];
    		                                  
    		String[] ITEM_VAT_AMT   		   = new String[iRowCount];
    		String[] AUTO_PO_FLAG   		   = new String[iRowCount];
    		String[] FROM_CONT_TYPE   		   = new String[iRowCount];
    		String[] PLANT_CODE   			   = new String[iRowCount];
    		String[] ROLE_CODE   			   = new String[iRowCount];
    		                                  
    		String[] PR_UNIT_PRICE   		   = new String[iRowCount];
    		String[] CHANGE_REASON   		   = new String[iRowCount];
    		                                  
    		String[] STD_PRICE_FLAG   		   = new String[iRowCount];
    		String[] MAINTENANCE_RATE   	   = new String[iRowCount];
    		String[] HUMAN_NO		   		   = new String[iRowCount];
    		String[] ASSOCIATION_GRADE   	   = new String[iRowCount];
    		String[] ENT_FROM_DATE   		   = new String[iRowCount];
    		String[] ENT_TO_DATE   			   = new String[iRowCount]; 		
    		String[] ITEM_DOC_NO   			   = new String[iRowCount]; 		
    		
    		if(iRowCount > 0){
    			for(int i = 0 ; i < iRowCount ; i++){
    				gridInfo = grid.get(i);
    				
    				ITEM_NO                	 [i]    = gridInfo.get("ITEM_NO");
    	    		DESCRIPTION_LOC        	 [i]    = gridInfo.get("DESCRIPTION_LOC");
    	    		SPECIFICATION          	 [i]    = "I".equals(pr_type)?gridInfo.get("SPECIFICATION"):gridInfo.get("SPACE");						//SPECIFICATION
    	    		VENDOR_CODE            	 [i]    = gridInfo.get("PO_VENDOR_CODE");
    	    		VENDOR_NAME            	 [i]    = gridInfo.get("VENDOR_NAME");
    	    		SETTLE_QTY             	 [i]    = gridInfo.get("QTY");
    	    		UNIT_MEASURE           	 [i]    = "I".equals(pr_type)?gridInfo.get("UNIT_MEASURE"):gridInfo.get("SPACE");
    	    		CUR                    	 [i]    = gridInfo.get("CUR");
    	    		UNIT_PRICE             	 [i]    = gridInfo.get("UNIT_PRICE");
    	    		ITEM_AMT               	 [i]    = gridInfo.get("ITEM_AMT");
    	    		CONTRACT_FLAG          	 [i]    = gridInfo.get("CONTRACT_FLAG");
    	    		QUOTA_PERCENT          	 [i]    = gridInfo.get("SPACE");						//QUOTA_PERCENT
    	    		YEAR_QTY               	 [i]    = gridInfo.get("SPACE");						//YEAR_QTY
    	    		PURCHASE_COUNT         	 [i]    = gridInfo.get("SPACE");						//PURCHASE_COUNT
    	    		                            
    	    		PR_NO                  	 [i]    = gridInfo.get("PR_NO");
    	    		PR_SEQ                 	 [i]    = gridInfo.get("PR_SEQ");
    	    		PR_USER_NAME           	 [i]    = gridInfo.get("ADD_USER_ID");   			//PR_USER_NAME
    	    		PREV_UNIT_PRICE        	 [i]    = gridInfo.get("SPACE");    					//PREV_UNIT_PRICE
    	    		BID_TYPE               	 [i]    = gridInfo.get("SPACE");   					//BID_TYPE
    	    		BID_TYPE_TEXT          	 [i]    = gridInfo.get("SPACE");						//BID_TYPE_TEXT
    	    		PURCHASE_PRE_PRICE     	 [i]    = gridInfo.get("SPACE");						//PURCHASE_PRE_PRICE
    	    		RD_DATE                	 [i]    = gridInfo.get("RD_DATE").replaceAll("\\/", "");					//RD_DATE
    	    		MOLDING_CHARGE         	 [i]    = gridInfo.get("SPACE");       				//MOLDING_CHARGE
    	    		SHIPPER_TYPE           	 [i]    = gridInfo.get("SPACE");         			//SHIPPER_TYPE
    	    		PURCHASE_CONV_RATE     	 [i]    = gridInfo.get("SPACE");   					//PURCHASE_CONV_RATE
    	    		PURCHASE_CONV_QTY      	 [i]    = gridInfo.get("SPACE");    					//PURCHASE_CONV_QTY
    	    		RFQ_NO                 	 [i]    = gridInfo.get("RFQ_NO");               		//RFQ_NO
    	    		RFQ_COUNT              	 [i]    = gridInfo.get("RFQ_COUNT");            		//RFQ_COUNT
    	    		RFQ_SEQ                	 [i]    = gridInfo.get("RFQ_SEQ");              		//RFQ_SEQ
    	    		QTA_NO                 	 [i]    = gridInfo.get("QTA_NO");               		//QTA_NO
    	    		QTA_SEQ                	 [i]    = gridInfo.get("QTA_SEQ");              		//QTA_SEQ
    	    		SETTLE_TYPE            	 [i]    = gridInfo.get("SPACE");          			//SETTLE_TYPE
    	    		SETTLE_FLAG            	 [i]    = gridInfo.get("SPACE");          			//SETTLE_FLAG
    	                                        
    	    		DO_FLAG               	 [i]    = gridInfo.get("SPACE");						//DO_FLAG
    	    		Z_WORK_STAGE_FLAG      	 [i]    = gridInfo.get("SPACE");         			//Z_WORK_STAGE_FLAG
    	    		Z_DELIVERY_CONFIRM_FLAG	 [i]    = gridInfo.get("SPACE");   					//Z_DELIVERY_CONFIRM_FLAG
    	    		DP_INFO					 [i]    = gridInfo.get("DP_INFO");
    	    		VALID_FROM_DATE 		 [i]    = gridInfo.get("VALID_FROM_DATE");
    	    		VALID_TO_DATE   		 [i]    = gridInfo.get("VALID_TO_DATE");
    	    		PAY_TERMS_HD   			 [i]    = gridInfo.get("PAY_TERMS_HD");
    	    		INSURANCE   			 [i]    = gridInfo.get("INSURANCE");
    	    		CUSTOMER_PRICE   		 [i]    = "I".equals(pr_type)?gridInfo.get("CUSTOMER_PRICE"):gridInfo.get("SPACE");
    	    		DISCOUNT   				 [i]    = "I".equals(pr_type)?gridInfo.get("DISCOUNT"):gridInfo.get("SPACE");
    	                                      
    	    		ITEM_VAT_AMT   			 [i]    = gridInfo.get("ITEM_VAT_AMT");
    	    		AUTO_PO_FLAG   			 [i]    = gridInfo.get("AUTO_PO_FLAG");
    	    		FROM_CONT_TYPE   		 [i]    = gridInfo.get("FROM_CONT_TYPE");
    	    		PLANT_CODE   			 [i]    = gridInfo.get("PLANT_CODE");
    	    		ROLE_CODE   			 [i]    = gridInfo.get("ROLE_CODE");
    	                                         
    	    		PR_UNIT_PRICE   		 [i]    = gridInfo.get("PR_UNIT_PRICE");
    	    		CHANGE_REASON   		 [i]    = gridInfo.get("CHANGE_REASON");
    	                                         
    	    		STD_PRICE_FLAG   		 [i]    = gridInfo.get("STD_PRICE_FLAG");
    	    		MAINTENANCE_RATE   		 [i]    = gridInfo.get("MAINTENANCE_RATE");
    	    		HUMAN_NO		   		 [i]    = gridInfo.get("HUMAN_NAME_LOC");
    	    		ASSOCIATION_GRADE   	 [i]    = gridInfo.get("ASSOCIATION_GRADE");
    	    		ENT_FROM_DATE   		 [i]    = gridInfo.get("ENT_FROM_DATE");
    	    		ENT_TO_DATE   			 [i]    = gridInfo.get("ENT_TO_DATE");    		    				
    	    		ITEM_DOC_NO   			 [i]    = gridInfo.get("DETAIL_DOC_NO");//상세문서번호
    			}
    		}
    		
    		
    		 SepoaOut wo  = null;
    		if("".equals(exec_no)){
    			wo		= DocumentUtil.getDocNumber(info,"EX");
    			exec_no = wo.result[0];
    		}
    		
    		String sign_user_id = "";
    		String sign_user_name = "";
    		if ("E".equals(sign_status)) {
    			sign_user_id = info.getSession("ID");
    			sign_user_name = info.getSession("NAME_LOC");
    		}
    		
    		String[][] objCNHD = {
    				{
    					 house_code 				//HOUSE_CODE
    					,exec_no  				//EXEC_NO
    					,"C"      				//STATUS
    					,add_date  			//ADD_DATE
    					,add_time  			//ADD_TIME
    					,ctrl_person_id  		//ADD_USER_ID
    					,add_date  			//CHANGE_DATE
    					,add_time  			//CHANGE_TIME
    					,ctrl_person_id 		//CHANGE_USER_ID
    					,company_code 	 		//COMPANY_CODE
    					,""		  			//BID_TYPE
    					,ttl_item_qty 			//TTL_ITEM_QTY
    					,exec_amt_krw 			//EXEC_AMT_KRW
    					,"" 					//EXEC_AMT_USD
    					,exec_flag		 		//EXEC_FLAG
    					,attach_no 			//ATTACH_NO
    					,sign_status				//SIGN_DATE
    					,sign_user_id			//SIGN_PERSON_ID
    					,"KRW".equals(CUR[0]) ? "D" : "O"			 		//SHIPPER_TYPE
    					,ctrl_code  			//CTRL_CODE
    					,""					//ADD_PAY_TERMS
    					,PAY_TERMS_HD[0]		//PAY_TERMS
    					,header.get("dely_terms")			//DELY_TERMS
    					,sign_status 			//SIGN_STATUS
    					,"" 					//EXCHGE_DATE
    					,"" 					//LC_OPEN_DATE
    					,"" 					//FOB_CHARGE
    					,subject 				//SUBJECT
    					,remark  				//REMARK
    					,""					//ANNOUNCE_COMMENT
    					,create_type           //CREATE_TYPE
    					,po_type               //PO_TYPE
    					
    					,ahead_flag			//AHEAD_FLAG
    					,pre_exec_no			//PRE_EXEC_NO
    					
    					,header.get("delay_remark")
    					,header.get("warranty_month")
    
    					,header.get("dely_to_location")
    					,header.get("dely_to_address")
    					,header.get("dely_to_user")
    					,header.get("dely_to_phone")
    					
    					,bf_exec_no			//bf_exec_no
    					
    					,po_yn
    				}
    		};
    
    		String[][] objCNDT 	= new String[iRowCount][];
    		String[][] objPRDT 	= new String[iRowCount][4];
    		for(int i=0;i<iRowCount;i++)
    		{
    			String[] TEMP_CNDT = {
    					  house_code //HOUSE_CODE
    					, exec_no//EXEC_NO
//    					, CommonUtil.lpad(String.valueOf(i+1),5,"0")//EXEC_SEQ
    					, exec_no//EXEC_NO
    					, VENDOR_CODE[i]     //VENDOR_CODE
    					, "C"                //STATUS
    					, add_date           //ADD_DATE
    					, add_time           //ADD_TIME
    					, ctrl_person_id     //ADD_USER_ID
    					, add_date           //CHANGE_DATE
    					, add_time           //CHANGE_TIME
    					, ctrl_person_id     //CHANGE_USER_ID
    					, company_code       //COMPANY_CODE
    					, PR_NO[i]           //PR_NO
    					, PR_SEQ[i]          //PR_SEQ
    					, RFQ_NO[i]          //RFQ_NO
    					, RFQ_COUNT[i]       //RFQ_COUNT
    					, RFQ_SEQ[i]         //RFQ_SEQ
    					, QTA_NO[i]          //QTA_NO
    					, QTA_SEQ[i]         //QTA_SEQ
    					, ITEM_NO[i]         //ITEM_NO
    					, UNIT_MEASURE[i]    //UNIT_MEASURE
    					, RD_DATE[i].replaceAll("\\/", "")         //RD_DATE
    					, UNIT_PRICE[i]      //UNIT_PRICE
    					, CUR[i]             //CUR
    					, ""		     	 //SETTLE_TYPE
    					, "Y"     			 //SETTLE_FLAG
    					, SETTLE_QTY[i]      //SETTLE_QTY
    					, CONTRACT_FLAG[i]   //CONTRACT_FLAG
    					, ""   				 //QUOTA_PERCENT
    					, ""                 //DP_NO
    					, ""                 //DP_SEQ
    					, ""                 //MANAGE_PRICE
    					, UNIT_PRICE[i]      //RESULT_PRICE
    					, "" 				 //ESTIMATE_PRICE
    					, ""		         //YEAR_QTY
    					, "01"               //PURCHASE_LOCATION
    					, AUTO_PO_FLAG[i]    //AUTO_PO_FLAG
    					, ""                 //CTR_NO
    					, valid_from_date    //VALID_FROM_DATE
    					, valid_to_date      //VALID_TO_DATE
    					, ""			  	 //MOLDING_CHARGE
    					, "" 				 //PREV_UNIT_PRICE
    					, ITEM_AMT[i]        //ITEM_AMT
    					, ""		         //PURCHASE_CONV_RATE
    					, ""		         //PURCHASE_CONV_QTY
    					, ""				 //DO_FLAG
                        , ""			 	 //Z_WORK_STAGE_FLAG
                        , ""				 //Z_DELIVERY_CONFIRM_FLAG
                        , INSURANCE[i]		 //INSURANCE_FLAG
                        , CUSTOMER_PRICE[i]  //CUSTOMER_PRICE
    					, DISCOUNT[i]   	 //DISCOUNT
    
    
    					, FROM_CONT_TYPE[i]	//FROM_CONT_TYPE
    					, ROLE_CODE[i]		//ROLE_CODE
    					, ITEM_VAT_AMT[i]	//ITEM_VAT_AMT
    					, !"".equals(HUMAN_NO[i]) ? ("".equals(PLANT_CODE[i]) ? "0000" : PLANT_CODE[i]) : PLANT_CODE[i]		//PLANT_CODE
    
    					, PR_UNIT_PRICE[i]	//PR_UNIT_PRICE
    					, CHANGE_REASON[i]	//CHANGE_REASON
    
    					, STD_PRICE_FLAG[i]
    					, MAINTENANCE_RATE[i]
    					, HUMAN_NO[i]
    					, ASSOCIATION_GRADE[i]
    					, ENT_FROM_DATE[i]
    					, ENT_TO_DATE[i]
    					, ITEM_DOC_NO[i]
    			};
    			objPRDT[i][0] = ctrl_person_id;
    			objPRDT[i][1] = house_code;
    			objPRDT[i][2] = PR_NO[i];
    			objPRDT[i][3] = PR_SEQ[i];
    
    			objCNDT[i] = TEMP_CNDT;
    		}    		
    		
    		Object[] obj = { sign_status, approval_str,exec_no, original_exec_no, SHIPPER_TYPE[0], cur, exec_amt_krw,  objCNHD, objCNDT ,dp_info , objPRDT, gridModifyFlag, del_pr_data, remain_pr_data, req_type};
    		//Object[] obj = {data};
    		
    		value = ServiceConnector.doService(info, "p1062", "TRANSACTION","setInsertEX", obj);
    		
    		if(value.flag) {
    			//System.out.println("value.message : " + value.message);
    			gdRes.setMessage("기안번호 "+exec_no+" 으로 저장되었습니다."); 
    			gdRes.setStatus("true");
    		}
    		else {
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
    		}
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }	       
    
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getDetailItem(GridData gdReq, SepoaInfo info) throws Exception{
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
	    
	    SepoaOut wo = null;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	
	    	
	    	String detail_doc_no = MapUtils.getString(header, "detail_doc_no");
			
			if( detail_doc_no == null || "".equals( detail_doc_no ) ) {//상세문서번호가 없으면
				wo = DocumentUtil.getDocNumber(info, "MTDS");
	 			detail_doc_no = wo.result[0];
			}
			
			header.put("DOC_NO", detail_doc_no);
			
			gdRes.addParam("detail_doc_no", detail_doc_no);
			gdRes.addParam("mode", "query");
	    	
	    	Object[] obj = {header};

	    	value = ServiceConnector.doService(info, "p1062", "CONNECTION","getDetailItem", obj);
	    	
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
			    				gdRes.addValue("SELECTED", "1");
			    			}
			    			else
			    			{
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

    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getEXDTInfo(GridData gdReq, SepoaInfo info) throws Exception{
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

	    	if("I".equals(header.get("pr_type"))){	//상품
	    		header.put("mode", "query");
	    	}else{									//용역
	    		header.put("mode", "insert");
	    	}
	    	value = ServiceConnector.doService(info, "p1062", "CONNECTION","getEXDTInfo", obj);
	    	
	
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
    							if("QTY".equals(gridColAry[k])){
    								gdRes.addValue("QTY", sf.getValue("PR_QTY", i));
    							}
    							else if("S_ITEM_AMT".equals(gridColAry[k])){
    								gdRes.addValue("S_ITEM_AMT", sf.getValue("CUSTOMER_ITEM_AMT", i));
    							}
    							else if("UNIT_PRICE".equals(gridColAry[k])){
    								gdRes.addValue("UNIT_PRICE", sf.getValue("PO_UNIT_PRICE", i));
    							}
    							else if("ITEM_AMT".equals(gridColAry[k])){
    								gdRes.addValue("ITEM_AMT", sf.getValue("PO_ITEM_AMT", i));
    							}
    							else if("SALE_PER_2".equals(gridColAry[k])){
    								gdRes.addValue("SALE_PER_2", sf.getValue("SALE_2", i));
    							}
    							else if("VALID_FROM_DATE".equals(gridColAry[k])){
    								gdRes.addValue("VALID_FROM_DATE", sf.getValue("CONTRACT_FROM_DATE", i));
    							}
    							else if("VALID_TO_DATE".equals(gridColAry[k])){
    								gdRes.addValue("VALID_TO_DATE", sf.getValue("CONTRACT_TO_DATE", i));
    							}
                                else if(gridColAry[k] != null && gridColAry[k].equals("GW_INF_NO")) {
			            		    gdRes.addValue(gridColAry[k], "<font color=blue>" + sf.getValue(gridColAry[k], i) + "</font>");
			            	    }else if(gridColAry[k] != null && gridColAry[k].equals("GW_INF_NO2")) {
			            		    gdRes.addValue(gridColAry[k], "<font color=blue>" + sf.getValue(gridColAry[k], i) + "</font>");
			            	    }
    							else{
    								gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
    							}
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
    				//gdRes.setMessage(message.get("MESSAGE.1001").toString());
    				value = ServiceConnector.doService(info,"p1062","CONNECTION","getCNDPInfoCont",obj);
    				
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
    	    						}else{
    	    							
    	    							
    	    							
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
    
	
//    public void doQuery(WiseStream ws) throws Exception
//    {
//        String mode 	= ws.getParam("mode");
//        String exec_no 	= ws.getParam("exec_no");
//        String pre_cont_seq = ws.getParam("pre_cont_seq");
//        String pre_cont_count = ws.getParam("pre_cont_count");
//		if(mode.equals("getEXDTInfo"))
//		{
//			getEXDTInfo(mode, ws);
//		}else if("getCNDPInfo".equals(mode)){
//			getCNDPInfo(exec_no, pre_cont_seq, pre_cont_count, ws);
//
//		}
//    }
//
//	/**
//	 * 품의생성시 디테일 내역을 조회한다.
//	 * <pre>
//	 * rfq_data_info를 만든다.
//	 *
//	 * </pre>
//	 * @param mode
//	 * @param ws
//	 * @throws Exception
//	 */
//	private void getEXDTInfo(String mode, WiseStream ws) throws Exception
//    {
//    	String pr_no    = ws.getParam("pr_no");
//        String pr_type  = ws.getParam("pr_type");
//        String pr_seq  = ws.getParam("pr_seq");
//        String pr_data = ws.getParam("pr_data");
//    	if(pr_type.equals("I")){
//        	getItemList(pr_data, ws);		//상품
//        }else{
////        	getServiceList(pr_no,pr_seq, ws);	//용역
//        }
//
//    }
//	private void getItemList(String pr_data ,WiseStream ws) throws Exception
//	{
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//
//        String house_code 	= info.getSession("HOUSE_CODE");
//        String company_code = info.getSession("COMPANY_CODE");
//
//
//
//        String rfq_data = "";
//        String[] args = {
//				house_code
//		};
//
//		String exec_no = ws.getParam("exec_no");
//		String editable = ws.getParam("editable");
//		String mode = "".equals(exec_no) ? "insert" : "update";
//		pr_data 	= "".equals(exec_no) ?  pr_data : exec_no;
//		Object[] obj = {args , pr_data, mode};
//		WiseOut value = ServiceConnector.doService(info,"p1062","CONNECTION","getEXDTInfo",obj);
//
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//
//		if(wf.getRowCount() == 0)
//		{
//	    	ws.setMessage(msg.getMessage("0008"));
//			ws.write();
//			return;
//  	    }
//
//        String icon_con_gla = "/kr/images/icon/detail.gif";
//
//        String combo_1Tmp[][] = {{"N","N"},{"Y","Y"}};
//        String combo_2Tmp[][] = {{"N","N"},{"Y","Y"}};
//        String combo_3Tmp[][] = {{"","선택"},{"N","N"},{"Y","Y"}};
//
//        wiseservlet.WiseCombo wisecombo = new wiseservlet.WiseCombo();
//        String cbo_FROM_CONT_TYPE[][] 	= wisecombo.getCombo(ws.getRequest(), "SL0022", house_code+"#M938", "");
//        String cbo_PLANT_CODE_1[][] 	= wisecombo.getCombo(ws.getRequest(), "SL0112", house_code+"#"+company_code, "");
//        String cbo_ROLE_CODE_1[][] 		= wisecombo.getCombo(ws.getRequest(), "SL0022", house_code+"#M939", "");
//        String cbo_grade_org[][]        = wisecombo.getCombo(ws.getRequest(), "SL0022", house_code+"#M169", "");
//
//        String cbo_grade[][] = new String[cbo_grade_org.length + 1][2];
//        cbo_grade[0][0] = "";
//        cbo_grade[0][1] = "";
//        for (int i = 0; i < cbo_grade_org.length; i++) {
//           	cbo_grade[i + 1][0] = cbo_grade_org[i][0];
//           	cbo_grade[i + 1][1] = cbo_grade_org[i][1];
//        }
//
//        String[][] cbo_PLANT_CODE = new String[cbo_PLANT_CODE_1.length+1][2];
//        System.arraycopy(cbo_PLANT_CODE_1, 0, cbo_PLANT_CODE, 1, cbo_PLANT_CODE_1.length);
//        if(editable.equals("N")){
//        	cbo_PLANT_CODE[0][0] = " ";	
//        }else{
//        	cbo_PLANT_CODE[0][0] = "선택";
//        }
//        cbo_PLANT_CODE[0][1] = "";
//
//        String[][] cbo_ROLE_CODE = new String[cbo_ROLE_CODE_1.length+1][2];
//        System.arraycopy(cbo_ROLE_CODE_1, 0, cbo_ROLE_CODE, 1, cbo_ROLE_CODE_1.length);
//        if(editable.equals("N")){
//        	cbo_ROLE_CODE[0][0] = " ";
//        }else{
//        	cbo_ROLE_CODE[0][0] = "선택";
//        }
//        cbo_ROLE_CODE[0][1] = "";
//
//		for(int i=0; i<wf.getRowCount(); i++)
//		{
//			String[] check = {"false", ""};
//			String[] img_pr_no 			= {"", wf.getValue("PR_NO",i)		  , wf.getValue("PR_NO",i)};
//			String[] img_item_no 		= {"", wf.getValue("ITEM_NO",i)		  , wf.getValue("ITEM_NO",i)};
//			String[] img_vendor_code 	= {"", wf.getValue("PO_VENDOR_CODE",i), wf.getValue("PO_VENDOR_CODE",i)};
//			String[] img_description_loc= {"", wf.getValue("DESCRIPTION_LOC",i)		  , wf.getValue("DESCRIPTION_LOC",i)};
//			String[] img_pay_terms 		= {icon_con_gla, wf.getValue("PAY_TERMS"        ,i), wf.getValue("PAY_TERMS"        ,i)};
//			String[] img_sourcing_no	= {"", wf.getValue("SOURCING_NO",i)		  , wf.getValue("SOURCING_NO",i)};
//
//
//			int iFROM_CONT_TYPEIndex	= CommonUtil.getComboIndex(cbo_FROM_CONT_TYPE, wf.getValue("FROM_CONT_TYPE",i));
//			int iPLANT_CODEIndex		= CommonUtil.getComboIndex(cbo_PLANT_CODE, wf.getValue("PLANT_CODE",i));
//			int iROLE_CODEIndex			= CommonUtil.getComboIndex(cbo_ROLE_CODE, wf.getValue("ROLE_CODE",i));
//			int iCONTRACT_FLAG			= CommonUtil.getComboIndex(combo_3Tmp, wf.getValue("CONTRACT_FLAG",i));
//			int iINSURANCE				= CommonUtil.getComboIndex(combo_1Tmp, wf.getValue("INSURANCE",i));
//    		int iGradeIndex             = CommonUtil.getComboIndex(cbo_grade, wf.getValue("ASSOCIATION_GRADE",i));
//
//			ws.addValue("SELECTED"              , check, "");
//			ws.addValue("PR_NO"           	    , img_pr_no							   , "");
//			ws.addValue("SUBJECT"   			, wf.getValue("SUBJECT"   			,i), "");
//			ws.addValue("PR_SUBJECT"   			, wf.getValue("PR_SUBJECT"   		,i), "");
//			ws.addValue("PR_ADD_USER_ID"     	, wf.getValue("PR_ADD_USER_ID"     	,i), "");
//			ws.addValue("PR_USER_NAME"     	    , wf.getValue("PR_USER_NAME"     	,i), "");
//			ws.addValue("ADD_USER_ID"     	    , wf.getValue("ADD_USER_ID"     	,i), "");
//			ws.addValue("USER_NAME"     	    , wf.getValue("USER_NAME"     		,i), "");
//			ws.addValue("PO_VENDOR_CODE"        , img_vendor_code					   , "");
//			ws.addValue("VENDOR_NAME"        	, wf.getValue("VENDOR_NAME"      	,i), "");
//			ws.addValue("ITEM_NO"       		, img_item_no						   , "");
//			ws.addValue("DESCRIPTION_LOC"       , img_description_loc					, "");
//			ws.addValue("SPECIFICATION"       	, wf.getValue("SPECIFICATION"     	,i), "");
//			ws.addValue("MAKER_NAME"       		, wf.getValue("MAKER_NAME"     		,i), "");
//			ws.addValue("MAKER_CODE"       		, wf.getValue("MAKER_CODE"     		,i), "");
//			ws.addValue("QTY"       		    , wf.getValue("PR_QTY"       		,i), "");
//			ws.addValue("UNIT_MEASURE"      	, wf.getValue("UNIT_MEASURE"      	,i), "");
//			ws.addValue("CUSTOMER_PRICE"        , wf.getValue("CUSTOMER_PRICE"      ,i), "");
//			ws.addValue("S_ITEM_AMT"        	, wf.getValue("CUSTOMER_ITEM_AMT"   ,i), "");
//			ws.addValue("UNIT_PRICE"          	, wf.getValue("PO_UNIT_PRICE"       ,i), "");
//			ws.addValue("ITEM_AMT"     			, wf.getValue("PO_ITEM_AMT"     	,i), "");
//			ws.addValue("DISCOUNT"     			, wf.getValue("DISCOUNT"     		,i), "");
//			ws.addValue("SALE_PER_2"          	, wf.getValue("SALE_2"          	,i), "");
//			ws.addValue("SALE_AMT"          	, wf.getValue("SALE_AMT"          	,i), "");
//			ws.addValue("PR_UNIT_PRICE"         , wf.getValue("PR_UNIT_PRICE"       ,i), "");
//			ws.addValue("PR_AMT"      		    , wf.getValue("PR_AMT"      		,i), "");
//			ws.addValue("RD_DATE"               , wf.getValue("RD_DATE"             ,i), "");
//			ws.addValue("VALID_FROM_DATE"       , wf.getValue("CONTRACT_FROM_DATE"  ,i), "");
//			ws.addValue("VALID_TO_DATE"   	    , wf.getValue("CONTRACT_TO_DATE"   	,i), "");
//			ws.addValue("PAY_TERMS"   	    	, img_pay_terms						   , "");
//			ws.addValue("PAY_TERMS_HD" 	    	, wf.getValue("PAY_TERMS_HD"        ,i), "");
//			ws.addValue("PAY_TERMS_HD_DESC"    	, ""						   		   , "");
//			ws.addValue("INSURANCE"   	    	, combo_1Tmp, "", iINSURANCE);
//            ws.addValue("CONTRACT_FLAG"         , combo_3Tmp, "", iCONTRACT_FLAG);
//            ws.addValue("SPACE"         		, ""								   , "");
//            ws.addValue("RFQ_NO"                , wf.getValue("RFQ_NO"              ,i), "");
//			ws.addValue("RFQ_COUNT"             , wf.getValue("RFQ_COUNT"           ,i), "");
//			ws.addValue("RFQ_SEQ"               , wf.getValue("RFQ_SEQ"             ,i), "");
//			ws.addValue("QTA_NO"                , wf.getValue("QTA_NO"              ,i), "");
//			ws.addValue("QTA_SEQ"               , wf.getValue("QTA_SEQ"             ,i), "");
//			ws.addValue("PR_SEQ"                , wf.getValue("PR_SEQ"              ,i), "");
//			ws.addValue("CUR"                	, wf.getValue("CUR"              	,i), "");
//			ws.addValue("DP_INFO"               , ""								   , "");
//			ws.addValue("WBS_NO"                , wf.getValue("WBS_NO"              ,i), "");
//			ws.addValue("WBS_NAME"              , wf.getValue("WBS_NAME"            ,i), "");
//
//			ws.addValue("AHEAD_FLAG"    		, wf.getValue("AHEAD_FLAG" 			, i), "" );
//			ws.addValue("CHANGE_REASON"    		, wf.getValue("CHANGE_REASON" 		, i), "" );
//			ws.addValue("SOURCING_NO"    		, img_sourcing_no						, "" );
//			ws.addValue("SOURCING_COUNT"    	, wf.getValue("SOURCING_COUNT" 		, i), "" );
//			ws.addValue("SOURCING_TYPE"    		, wf.getValue("SOURCING_TYPE" 		, i), "" );
//
//			ws.addValue("ITEM_VAT_AMT"    		, wf.getValue("ITEM_VAT_AMT" 			, i)					, "" );
//			ws.addValue("CLASS_GRADE"    		, wf.getValue("CLASS_GRADE" 		, i), "" );
//			ws.addValue("CLASS_SCORE"    		, wf.getValue("CLASS_SCORE" 		, i), "" );
//			ws.addValue("AUTO_PO_FLAG"         	, combo_1Tmp, "", "Y".equals(wf.getValue("AUTO_PO_FLAG", i)) ? 1 :  0);
//			ws.addValue("FROM_CONT_TYPE"        , cbo_FROM_CONT_TYPE	,"", iFROM_CONT_TYPEIndex);
//			ws.addValue("PLANT_CODE"         	, cbo_PLANT_CODE		,"", iPLANT_CODEIndex	);
//			ws.addValue("ROLE_CODE"         	, cbo_ROLE_CODE			,"", iROLE_CODEIndex	);
//			ws.addValue("ADD_DATE"    			, wf.getValue("ADD_DATE" 		, i), "" );
//			ws.addValue("CTRL_CODE"    			, wf.getValue("CTRL_CODE" 		, i), "" );
//			ws.addValue("PO_TYPE"    			, wf.getValue("PO_TYPE" 		, i), "" );
//			ws.addValue("REMARK"    			, wf.getValue("REMARK" 		, i), "" );
//			ws.addValue("ORIGIN_PR_SEQ"    		, "", "" ); // 품목삭제시 기존 PR_SEQ
//
//			ws.addValue("STD_PRICE_FLAG"    	, combo_2Tmp, "", "Y".equals(wf.getValue("STD_PRICE_FLAG", i)) ? 1 :  0);
//			ws.addValue("MAINTENANCE_RATE"  	, wf.getValue("MAINTENANCE_RATE" 	, i), "" );
//			ws.addValue("CONTRACT_DIV"      	, wf.getValue("CONTRACT_DIV" 		, i), "" );
//			ws.addValue("PREFERRED_BIDDER"  	, wf.getValue("PREFERRED_BIDDER" 		, i), "" );
//			ws.addValue("ITEM_GBN"  			, wf.getValue("ITEM_GBN" 		, i), "" ); // 계정그룹(01(I) : 상품, 02(S) : 용역)
//
//            String img_human = "";
//
//            String ITEM_NO_SUB = "";
//            if(wf.getValue("ITEM_NO", i).length() > 2){
//            	ITEM_NO_SUB = wf.getValue("ITEM_NO", i).substring(0, 2);
//            }
//
//            if ("I".equals(wf.getValue("ITEM_GBN", i)) || "S".equals(wf.getValue("ITEM_GBN", i))) {
//            	img_human = "";
//            } else {
//            	img_human = "/kr/images/icon/detail.gif";
//            }
//
//            String[] img_human_no   = {img_human, wf.getValue("HUMAN_NAME_LOC" ,i), wf.getValue("HUMAN_NO" ,i)};
//
//            ws.addValue("HUMAN_NAME_LOC"    , img_human_no                      , "" );
//			ws.addValue("ASSOCIATION_GRADE" , cbo_grade  	                    , "" , iGradeIndex);
//			ws.addValue("ENT_FROM_DATE"     , wf.getValue("ENT_FROM_DATE" 		, i), "" );
//			ws.addValue("ENT_TO_DATE"       , wf.getValue("ENT_TO_DATE" 		, i), "" );
//			ws.addValue("H_ATTACH_NO"       , wf.getValue("H_ATTACH_NO" 		, i), "" );
//
//			ws.addValue("ORDER_NO"       	, wf.getValue("ORDER_NO" 			, i), "" );
//			ws.addValue("ORDER_COUNT"       , wf.getValue("ORDER_COUNT" 		, i), "" );
//			ws.addValue("CUST_CODE"       	, wf.getValue("CUST_CODE" 			, i), "" );
//			ws.addValue("PRE_EXEC_NO"       , wf.getValue("PRE_EXEC_NO" 		, i), "" );
//
//			ws.addValue("DELAY_REMARK"       , wf.getValue("DELAY_REMARK" 		, i), "" );
//			ws.addValue("WARRANTY_MONTH"       , wf.getValue("WARRANTY_MONTH" 		, i), "" );
//			ws.addValue("DELY_TERMS"       , wf.getValue("DELY_TERMS" 		, i), "" );
//
//			ws.addValue("DELY_TO_LOCATION"       , wf.getValue("DELY_TO_LOCATION" 		, i), "" );
//			ws.addValue("DELY_TO_ADDRESS"       , wf.getValue("DELY_TO_ADDRESS" 		, i), "" );
//			ws.addValue("DELY_TO_USER"       , wf.getValue("DELY_TO_USER" 		, i), "" );
//			ws.addValue("DELY_TO_PHONE"       , wf.getValue("DELY_TO_PHONE" 		, i), "" );
//		}
//
//		ws.setMessage(value.message);
//		ws.write();
//    }
//
//	private void getCNDPInfo(String exec_no, String pre_cont_seq, String pre_cont_count, WiseStream ws) throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//
//        String house_code = info.getSession("HOUSE_CODE");
//
//		String[] args = {
//				house_code
//				, exec_no
//		};
//
//		Object[] obj = {args};
//		WiseOut value = null;
//		WiseFormater wf = null;
//		if(!exec_no.equals("")){
//			value = ServiceConnector.doService(info,"p1062","CONNECTION","getCNDPInfo",obj);
//			wf = ws.getWiseFormater(value.result[0]);
//		}else{
//		
//			//대금지급 data가 없고 && 변경계약이라면 기존 대급지급내역을 가져옵니다. 
//			if(!pre_cont_seq.equals("")){
//				HashMap<String, String> paramMap = new HashMap<String, String>();
//				paramMap.put("house_code", house_code);
//				paramMap.put("exec_no", exec_no);
//				paramMap.put("pre_cont_seq", pre_cont_seq);
//				paramMap.put("pre_cont_count", pre_cont_count);
//				Object[] objs = { paramMap };
//				value = ServiceConnector.doService(info,"p1062","CONNECTION","getCNDPInfoCont",objs);
//				wf = ws.getWiseFormater(value.result[0]);
//			}
//		}
//		try{
//			if(wf.getRowCount() == 0)
//			{
//		    	ws.setMessage(msg.getMessage("0008"));
//				ws.write();
//				return;
//	  	    }
//			
//			for(int i=0; i<wf.getRowCount(); i++)
//			{
//				String[] check = {"true", ""};
//				ws.addValue("SEL"				 , check						   	   , "");
//				ws.addValue("DP_SEQ"			 , wf.getValue("DP_SEQ"			    ,i), "");
//				ws.addValue("DP_TYPE"            , wf.getValue("DP_TYPE"            ,i), "");
//				ws.addValue("DP_TYPE_DESC"       , wf.getValue("DP_TYPE_DESC"       ,i), "");
//				ws.addValue("DP_PERCENT"         , wf.getValue("DP_PERCENT"         ,i), "");
//				ws.addValue("DP_AMT"             , wf.getValue("DP_AMT"             ,i), "");
//				ws.addValue("DP_PLAN_DATE"       , wf.getValue("DP_PLAN_DATE"       ,i), "");
//				ws.addValue("DP_PAY_TERMS"       , wf.getValue("DP_PAY_TERMS"       ,i), "");
//				ws.addValue("DP_PAY_TERMS_TEXT"  , wf.getValue("DP_PAY_TERMS_TEXT"  ,i), "");
//				ws.addValue("FIRST_DEPOSIT"      , wf.getValue("FIRST_DEPOSIT"      ,i), "");
//				ws.addValue("FIRST_PERCENT"      , wf.getValue("FIRST_PERCENT"      ,i), "");
//				ws.addValue("CONTRACT_DEPOSIT"   , wf.getValue("CONTRACT_DEPOSIT"   ,i), "");
//				ws.addValue("CONTRACT_PERCENT"   , wf.getValue("CONTRACT_PERCENT"   ,i), "");
//				ws.addValue("MENGEL_DEPOSIT"     , wf.getValue("MENGEL_DEPOSIT"     ,i), "");
//				ws.addValue("MENGEL_PERCENT"     , wf.getValue("MENGEL_PERCENT"     ,i), "");
//				ws.addValue("DP_DIV"     		 , wf.getValue("DP_DIV"    		 	,i), "");
//				ws.addValue("DP_CODE"     		 , wf.getValue("DP_CODE"    		,i), "");
//				ws.addValue("PRE_CONT_YN"     	 , wf.getValue("PRE_CONT_YN"    	,i), "");
//				ws.addValue("FIRST_METHOD"     	 , wf.getValue("FIRST_METHOD"    	,i), "");
//				ws.addValue("CONTRACT_METHOD"    , wf.getValue("CONTRACT_METHOD"   	,i), "");
//				ws.addValue("MENGEL_METHOD"      , wf.getValue("MENGEL_METHOD"    	,i), "");
//	
//			}
//	
//			ws.setMessage(value.message);
//			ws.write();
//		}catch(NullPointerException ne){
//			ne.printStackTrace();
//		}
//    }
//
//    private void getServiceList(String pr_no, String pr_seq, WiseStream ws) throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//
//        String house_code = info.getSession("HOUSE_CODE");
//
//
//        String rfq_data = "";
//        String[] args = {
//				house_code
//		};
//
//
//		Object[] obj = {args , pr_no,pr_seq, "insert"};
//
//		WiseOut value = ServiceConnector.doService(info,"p1062","CONNECTION","getEXDTInfo",obj);
//
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//
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
//
//		for(int i=0; i<wf.getRowCount(); i++)
//		{
//			String[] check = {"true", ""};
//			String[] img_pr_no 			= {"", wf.getValue("PR_NO",i)		  , wf.getValue("PR_NO",i)};
//			String[] img_item_no 		= {"", wf.getValue("ITEM_NO",i)		  , wf.getValue("ITEM_NO",i)};
//			String[] img_description_loc= {"", wf.getValue("DESCRIPTION_LOC",i)		  , wf.getValue("DESCRIPTION_LOC",i)};
//			String[] img_vendor_code 	= {"", wf.getValue("PO_VENDOR_CODE",i), wf.getValue("PO_VENDOR_CODE",i)};
//			String[] img_pay_terms 		= {icon_con_gla, "", ""};
//
//			ws.addValue("SELECTED"			, check, "");
//			ws.addValue("PR_NO"			    , img_pr_no							   , "");
//			ws.addValue("SUBJECT"			, wf.getValue("SUBJECT"   			,i), "");
//			ws.addValue("ADD_USER_ID"		, wf.getValue("ADD_USER_ID"     	,i), "");
//			ws.addValue("USER_NAME"		    , wf.getValue("USER_NAME"     		,i), "");
//			ws.addValue("PO_VENDOR_CODE"	, img_vendor_code					   , "");
//			ws.addValue("VENDOR_NAME"		, wf.getValue("VENDOR_NAME"      	,i), "");
//			ws.addValue("ITEM_NO"			, img_item_no						   , "");
//			ws.addValue("DESCRIPTION_LOC"	, img_description_loc				   , "");
//			ws.addValue("QTY"				, wf.getValue("PR_QTY"       		,i), "");
//			ws.addValue("UNIT_PRICE"		, wf.getValue("PO_UNIT_PRICE"      	,i), "");
//			ws.addValue("ITEM_AMT"			, wf.getValue("PO_ITEM_AMT"      	,i), "");
//			ws.addValue("TECHNIQUE_GRADE"	, wf.getValue("TECHNIQUE_GRADE"     ,i), "");
//			ws.addValue("PR_UNIT_PRICE"	    , wf.getValue("PR_UNIT_PRICE"   	,i), "");
//			ws.addValue("PR_AMT"			, wf.getValue("PR_AMT"       		,i), "");
//			ws.addValue("SALE_AMT"          , wf.getValue("SALE_AMT"          	,i), "");
//			ws.addValue("RD_DATE"			, wf.getValue("RD_DATE"     		,i), "");
//			ws.addValue("PAY_TERMS"		    , img_pay_terms						   , "");
//			ws.addValue("PAY_TERMS_HD"		, ""								   , "");
//			ws.addValue("PAY_TERMS_HD_DESC"	, ""								   , "");
//			ws.addValue("INPUT_FROM_DATE"	, wf.getValue("INPUT_FROM_DATE"     ,i), "");
//			ws.addValue("INPUT_TO_DATE"	    , wf.getValue("INPUT_TO_DATE"      	,i), "");
//			ws.addValue("CONTRACT_FLAG"	    , combo_1Tmp, "", 0);
//			ws.addValue("INSURANCE"		    , combo_1Tmp, "", 0);
//			ws.addValue("SPACE"			    , ""								   , "");
//			ws.addValue("DP_INFO"			, wf.getValue("DP_INFO"           	,i), "");
//			ws.addValue("CUR"				, wf.getValue("CUR"           		,i), "");
//			ws.addValue("PR_SEQ"			, wf.getValue("PR_SEQ"              ,i), "");
//            ws.addValue("RFQ_NO"            , wf.getValue("RFQ_NO"           	,i), "");
//            ws.addValue("RFQ_COUNT"         , wf.getValue("RFQ_COUNT"           ,i), "");
//            ws.addValue("RFQ_SEQ"           , wf.getValue("RFQ_SEQ"             ,i), "");
//			ws.addValue("QTA_NO"            , wf.getValue("QTA_NO"           	,i), "");
//			ws.addValue("QTA_SEQ"			, wf.getValue("QTA_SEQ"             ,i), "");
//			ws.addValue("SALE_PER_2"        , wf.getValue("SALE_2"          	,i), "");
//			ws.addValue("VALID_FROM_DATE"   , wf.getValue("CONTRACT_FROM_DATE"  ,i), "");
//			ws.addValue("VALID_TO_DATE"   	, wf.getValue("CONTRACT_TO_DATE"   	,i), "");
//
//		}
//
//		ws.setMessage(value.message);
//		ws.write();
//    }
//	public void doData(WiseStream ws) throws Exception
//	{
//		String mode = ws.getParam("mode");
//
//		//setInsertEX
//		if(mode.equals("setInsertEX"))
//		{
//			setInsertEX(ws, mode);
//
//		}
//	}
//
//	private void setInsertEX(WiseStream ws, String mode) throws Exception
//	{
//		WiseInfo info	    	= WiseSession.getAllValue(ws.getRequest());
//		String house_code   	= info.getSession("HOUSE_CODE");
//		String add_user_id  	= info.getSession("ID");
//		String company_code 	= info.getSession("COMPANY_CODE");
//		String add_date     	= WiseDate.getShortDateString();
//		String add_time     	= WiseDate.getShortTimeString();
//		String pr_location  	= info.getSession("PR_LOCATION");
//
//		String exec_amt_krw    	= ws.getParam("exec_amt_krw");
//		String dp_info    	   	= ws.getParam("dp_info");
//		String exec_flag       	= ws.getParam("exec_flag");
//		String ctrl_code       	= ws.getParam("ctrl_code");
//		String attach_no       	= ws.getParam("attach_no");
//		String pay_terms       	= ws.getParam("pay_terms");
//		String dely_terms      	= ws.getParam("dely_terms");
//		String subject         	= ws.getParam("subject");
//		String remark          	= ws.getParam("remark");
//		String ttl_item_qty    	= ws.getParam("ttl_item_qty");
//		String cur             	= ws.getParam("cur");
//		String sign_status     	= ws.getParam("sign_status");
//		String approval_str    	= ws.getParam("approval_str");
//		String ctrl_person_id  	= ws.getParam("ctrl_person_id");
//		String create_type     	= ws.getParam("create_type");
//		String pr_type     	   	= ws.getParam("pr_type");
//		String valid_from_date 	= ws.getParam("valid_from_date"  );
//		String valid_to_date   	= ws.getParam("valid_to_date"	);
//		String po_type         	= ws.getParam("po_type");
//		//String DP_INFO         = ws.getParam("DP_INFO");
//		String ahead_flag      	= ws.getParam("ahead_flag");
//		String exec_no		   	= ws.getParam("exec_no");
//		String original_exec_no = ws.getParam("exec_no");
//		String req_type			= ws.getParam("req_type");	 // 사전품의 : B, 품의 : P
//		String pre_exec_no	   	= ws.getParam("pre_exec_no"); // 구매품의 작성시의 사전품의번호
//
//		String del_pr_data 		= ws.getParam("del_pr_data");	// 수정시 삭제된 품목들	 이미 견적을 탄놈들이라서  CNDT에 STATUS = 'D' 인 상태로 인서트되야한다.
//		String remain_pr_data   = ws.getParam("remain_pr_data");// 조회된 데이터중 삭제되지않고 남아있는 데이터
//		String gridModifyFlag	= ws.getParam("gridModifyFlag");// 그리드의 내용이 수정이 됐는지의 여부
//		
//		// 2011.09.07 HMCHOI
//		// 변경품의서 작성인 경우 이전 품의번호를 저장한다.
//		String bf_exec_no		= ws.getParam("bf_exec_no");
//		
//		ctrl_person_id 		= ctrl_person_id==null?add_user_id:ctrl_person_id;
//		WiseFormater wf		= ws.getWiseFormater();
//		int iRowCount 		= wf.getRowCount();
//		
//		String[] ITEM_NO             = wf.getValue("ITEM_NO");
//		String[] DESCRIPTION_LOC     = wf.getValue("DESCRIPTION_LOC");
//		String[] SPECIFICATION       = pr_type.equals("I")?wf.getValue("SPECIFICATION"):wf.getValue("SPACE");						//SPECIFICATION
//		String[] VENDOR_CODE         = wf.getValue("PO_VENDOR_CODE");
//		String[] VENDOR_NAME         = wf.getValue("VENDOR_NAME");
//		String[] SETTLE_QTY          = wf.getValue("QTY");
//		String[] UNIT_MEASURE        = pr_type.equals("I")?wf.getValue("UNIT_MEASURE"):wf.getValue("SPACE");
//		String[] CUR                 = wf.getValue("CUR");
//		String[] UNIT_PRICE          = wf.getValue("UNIT_PRICE");
//		String[] ITEM_AMT            = wf.getValue("ITEM_AMT");
//		String[] CONTRACT_FLAG       = wf.getValue("CONTRACT_FLAG");
//		String[] QUOTA_PERCENT       = wf.getValue("SPACE");						//QUOTA_PERCENT
//		String[] YEAR_QTY            = wf.getValue("SPACE");						//YEAR_QTY
//		String[] PURCHASE_COUNT      = wf.getValue("SPACE");						//PURCHASE_COUNT
//		
//		String[] PR_NO               = wf.getValue("PR_NO");
//		String[] PR_SEQ              = wf.getValue("PR_SEQ");
//		String[] PR_USER_NAME        = wf.getValue("ADD_USER_ID");   				//PR_USER_NAME
//		String[] PREV_UNIT_PRICE     = wf.getValue("SPACE");    					//PREV_UNIT_PRICE
//		String[] BID_TYPE            = wf.getValue("SPACE");   						//BID_TYPE
//		String[] BID_TYPE_TEXT       = wf.getValue("SPACE");						//BID_TYPE_TEXT
//		String[] PURCHASE_PRE_PRICE  = wf.getValue("SPACE");						//PURCHASE_PRE_PRICE
//		String[] RD_DATE             = wf.getValue("RD_DATE");						//RD_DATE
//		String[] MOLDING_CHARGE      = wf.getValue("SPACE");       					//MOLDING_CHARGE
//		String[] SHIPPER_TYPE        = wf.getValue("SPACE");         				//SHIPPER_TYPE
//		String[] PURCHASE_CONV_RATE  = wf.getValue("SPACE");   						//PURCHASE_CONV_RATE
//		String[] PURCHASE_CONV_QTY   = wf.getValue("SPACE");    					//PURCHASE_CONV_QTY
//		String[] RFQ_NO              = wf.getValue("RFQ_NO");               		//RFQ_NO
//		String[] RFQ_COUNT           = wf.getValue("RFQ_COUNT");            		//RFQ_COUNT
//		String[] RFQ_SEQ             = wf.getValue("RFQ_SEQ");              		//RFQ_SEQ
//		String[] QTA_NO              = wf.getValue("QTA_NO");               		//QTA_NO
//		String[] QTA_SEQ             = wf.getValue("QTA_SEQ");              		//QTA_SEQ
//		String[] SETTLE_TYPE         = wf.getValue("SPACE");          				//SETTLE_TYPE
//		String[] SETTLE_FLAG         = wf.getValue("SPACE");          				//SETTLE_FLAG
//
//		String[] DO_FLAG                = wf.getValue("SPACE");						//DO_FLAG
//		String[] Z_WORK_STAGE_FLAG      = wf.getValue("SPACE");         			//Z_WORK_STAGE_FLAG
//		String[] Z_DELIVERY_CONFIRM_FLAG= wf.getValue("SPACE");   					//Z_DELIVERY_CONFIRM_FLAG
//		String[] DP_INFO				= wf.getValue("DP_INFO");
//		String[] VALID_FROM_DATE 		= wf.getValue("VALID_FROM_DATE");
//		String[] VALID_TO_DATE   		= wf.getValue("VALID_TO_DATE");
//		String[] PAY_TERMS_HD   		= wf.getValue("PAY_TERMS_HD");
//		String[] INSURANCE   			= wf.getValue("INSURANCE");
//		String[] CUSTOMER_PRICE   		= pr_type.equals("I")?wf.getValue("CUSTOMER_PRICE"):wf.getValue("SPACE");
//		String[] DISCOUNT   			= pr_type.equals("I")?wf.getValue("DISCOUNT"):wf.getValue("SPACE");
//
//		String[] ITEM_VAT_AMT   		= wf.getValue("ITEM_VAT_AMT");
//		String[] AUTO_PO_FLAG   		= wf.getValue("AUTO_PO_FLAG");
//		String[] FROM_CONT_TYPE   		= wf.getValue("FROM_CONT_TYPE");
//		String[] PLANT_CODE   			= wf.getValue("PLANT_CODE");
//		String[] ROLE_CODE   			= wf.getValue("ROLE_CODE");
//
//		String[] PR_UNIT_PRICE   		= wf.getValue("PR_UNIT_PRICE");
//		String[] CHANGE_REASON   		= wf.getValue("CHANGE_REASON");
//
//		String[] STD_PRICE_FLAG   		= wf.getValue("STD_PRICE_FLAG");
//		String[] MAINTENANCE_RATE   	= wf.getValue("MAINTENANCE_RATE");
//		String[] HUMAN_NO		   		= wf.getValue("HUMAN_NAME_LOC");
//		String[] ASSOCIATION_GRADE   	= wf.getValue("ASSOCIATION_GRADE");
//		String[] ENT_FROM_DATE   		= wf.getValue("ENT_FROM_DATE");
//		String[] ENT_TO_DATE   			= wf.getValue("ENT_TO_DATE");
//		
//		WiseOut wo  = null;
//		if("".equals(exec_no)){
//			wo		= appcommon.getDocNumber(info,"EX");
//			exec_no = wo.result[0];
//		}
//		
//		String sign_user_id = "";
//		String sign_user_name = "";
//		if (sign_status.equals("E")) {
//			sign_user_id = info.getSession("ID");
//			sign_user_name = info.getSession("NAME_LOC");
//		}
//		Logger.debug.println("",this,"여기당 : " + sign_status);
//		
//		String[][] objCNHD = {
//				{
//					 house_code 				//HOUSE_CODE
//					,exec_no  				//EXEC_NO
//					,"C"      				//STATUS
//					,add_date  			//ADD_DATE
//					,add_time  			//ADD_TIME
//					,ctrl_person_id  		//ADD_USER_ID
//					,add_date  			//CHANGE_DATE
//					,add_time  			//CHANGE_TIME
//					,ctrl_person_id 		//CHANGE_USER_ID
//					,company_code 	 		//COMPANY_CODE
//					,""		  			//BID_TYPE
//					,ttl_item_qty 			//TTL_ITEM_QTY
//					,exec_amt_krw 			//EXEC_AMT_KRW
//					,"" 					//EXEC_AMT_USD
//					,exec_flag		 		//EXEC_FLAG
//					,attach_no 			//ATTACH_NO
//					,sign_status				//SIGN_DATE
//					,sign_user_id			//SIGN_PERSON_ID
//					,"KRW".equals(CUR[0]) ? "D" : "O"			 		//SHIPPER_TYPE
//					,ctrl_code  			//CTRL_CODE
//					,""					//ADD_PAY_TERMS
//					,PAY_TERMS_HD[0]		//PAY_TERMS
//					,ws.getParam("dely_terms")			//DELY_TERMS
//					,sign_status 			//SIGN_STATUS
//					,"" 					//EXCHGE_DATE
//					,"" 					//LC_OPEN_DATE
//					,"" 					//FOB_CHARGE
//					,subject 				//SUBJECT
//					,remark  				//REMARK
//					,""					//ANNOUNCE_COMMENT
//					,create_type           //CREATE_TYPE
//					,po_type               //PO_TYPE
//					
//					,ahead_flag			//AHEAD_FLAG
//					,pre_exec_no			//PRE_EXEC_NO
//					
//					,ws.getParam("delay_remark")
//					,ws.getParam("warranty_month")
//
//					,ws.getParam("dely_to_location")
//					,ws.getParam("dely_to_address")
//					,ws.getParam("dely_to_user")
//					,ws.getParam("dely_to_phone")
//					
//					,bf_exec_no			//bf_exec_no
//				}
//		};
//
//		String[][] objCNDT 	= new String[iRowCount][];
//		String[][] objPRDT 	= new String[iRowCount][4];
//		for(int i=0;i<iRowCount;i++)
//		{
//			String[] TEMP_CNDT = {
//					  house_code //HOUSE_CODE
//					, exec_no//EXEC_NO
////					, CommonUtil.lpad(String.valueOf(i+1),5,"0")//EXEC_SEQ
//					, exec_no//EXEC_NO
//					, VENDOR_CODE[i]     //VENDOR_CODE
//					, "C"                //STATUS
//					, add_date           //ADD_DATE
//					, add_time           //ADD_TIME
//					, ctrl_person_id     //ADD_USER_ID
//					, add_date           //CHANGE_DATE
//					, add_time           //CHANGE_TIME
//					, ctrl_person_id     //CHANGE_USER_ID
//					, company_code       //COMPANY_CODE
//					, PR_NO[i]           //PR_NO
//					, PR_SEQ[i]          //PR_SEQ
//					, RFQ_NO[i]          //RFQ_NO
//					, RFQ_COUNT[i]       //RFQ_COUNT
//					, RFQ_SEQ[i]         //RFQ_SEQ
//					, QTA_NO[i]          //QTA_NO
//					, QTA_SEQ[i]         //QTA_SEQ
//					, ITEM_NO[i]         //ITEM_NO
//					, UNIT_MEASURE[i]    //UNIT_MEASURE
//					, RD_DATE[i]         //RD_DATE
//					, UNIT_PRICE[i]      //UNIT_PRICE
//					, CUR[i]             //CUR
//					, ""		     	 //SETTLE_TYPE
//					, "Y"     			 //SETTLE_FLAG
//					, SETTLE_QTY[i]      //SETTLE_QTY
//					, CONTRACT_FLAG[i]   //CONTRACT_FLAG
//					, ""   				 //QUOTA_PERCENT
//					, ""                 //DP_NO
//					, ""                 //DP_SEQ
//					, ""                 //MANAGE_PRICE
//					, UNIT_PRICE[i]      //RESULT_PRICE
//					, "" 				 //ESTIMATE_PRICE
//					, ""		         //YEAR_QTY
//					, "01"               //PURCHASE_LOCATION
//					, AUTO_PO_FLAG[i]    //AUTO_PO_FLAG
//					, ""                 //CTR_NO
//					, valid_from_date    //VALID_FROM_DATE
//					, valid_to_date      //VALID_TO_DATE
//					, ""			  	 //MOLDING_CHARGE
//					, "" 				 //PREV_UNIT_PRICE
//					, ITEM_AMT[i]        //ITEM_AMT
//					, ""		         //PURCHASE_CONV_RATE
//					, ""		         //PURCHASE_CONV_QTY
//					, ""				 //DO_FLAG
//                    , ""			 	 //Z_WORK_STAGE_FLAG
//                    , ""				 //Z_DELIVERY_CONFIRM_FLAG
//                    , INSURANCE[i]		 //INSURANCE_FLAG
//                    , CUSTOMER_PRICE[i]  //CUSTOMER_PRICE
//					, DISCOUNT[i]   	 //DISCOUNT
//
//
//					, FROM_CONT_TYPE[i]	//FROM_CONT_TYPE
//					, ROLE_CODE[i]		//ROLE_CODE
//					, ITEM_VAT_AMT[i]	//ITEM_VAT_AMT
//					, !"".equals(HUMAN_NO[i]) ? ("".equals(PLANT_CODE[i]) ? "0000" : PLANT_CODE[i]) : PLANT_CODE[i]		//PLANT_CODE
//
//					, PR_UNIT_PRICE[i]	//PR_UNIT_PRICE
//					, CHANGE_REASON[i]	//CHANGE_REASON
//
//					, STD_PRICE_FLAG[i]
//					, MAINTENANCE_RATE[i]
//					, HUMAN_NO[i]
//					, ASSOCIATION_GRADE[i]
//					, ENT_FROM_DATE[i]
//					, ENT_TO_DATE[i]
//			};
//			objPRDT[i][0] = ctrl_person_id;
//			objPRDT[i][1] = house_code;
//			objPRDT[i][2] = PR_NO[i];
//			objPRDT[i][3] = PR_SEQ[i];
//
//			objCNDT[i] = TEMP_CNDT;
//		}
//
//		// 그리드의 내용이 수정이 된경우에는
//		// 조회된 데이터 중 삭제된 데이터, 삭제되지않고 그리드에 남아있는 데이터(PR_NO, PR_SEQ가 있는 데이터) 들은 STATUS = 'D' 인 상태로 CNDT에 등록된다.
//		// 그리드에 남아있는 데이터(기존 + 추가된 데이터) 는 STATUS = 'C' 인 상태로 CNDT에 등록된다.
//		// 결론 : 수정된 경우 기존데이터를 삭제(STATUS = 'D')처리 하고 새로운 PR_SEQ로 등록한다.
//
//		Object[] obj = { sign_status, approval_str,exec_no, original_exec_no, SHIPPER_TYPE[0], cur, exec_amt_krw,  objCNHD, objCNDT ,dp_info , objPRDT, gridModifyFlag, del_pr_data, remain_pr_data, req_type};
//		WiseOut value = ServiceConnector.doService(info, "p1062", "TRANSACTION","setInsertEX", obj);
//
//        ws.setMessage(value.message);
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);;
//
//		ws.write();
//	}

}
