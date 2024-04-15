package sepoa.svl.procure;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
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
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;


public class invoice_insert extends HttpServlet {
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// 세션 Object
        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		if ("getPoDetail".equals(mode))
       		{	
       			gdRes = getIvPoDetail(gdReq, info);		//조회
       		}else if("setIvInsert".equals(mode))
       		{
       			gdRes = setIvInsert(gdReq, info);
       		}else if("chkInvUserId".equals(mode)){
    			gdRes = this.chkInvUserId(gdReq, info);
    		}
  
        } catch (Exception e) { 
        	gdRes.setMessage("Error: " + e.getMessage());
        	gdRes.setStatus("false");
        	
        } finally {
        	try {
        		if("chkInvUserId".equals(mode)){
        			out.print(gdRes.getMessage());
        		}else{        			
        			OperateGridData.write(req, res, gdRes, out);            		
        		}
        		
        	} catch (Exception e) {
        		Logger.debug.println();
        	}
        }
    }
    
    
    private Map<String, String> getQuerySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result      = new HashMap<String, String>();
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	//String              companyCode = gdReq.getParam("company_code");
    	String              po_no    = gdReq.getParam("po_no");
    	String              inv_user_id    = gdReq.getParam("inv_user_id");
    	
    	
    	result.put("HOUSE_CODE",   houseCode);
    	//result.put("COMPANY_CODE", companyCode);
    	result.put("PO_NO",    po_no);
    	result.put("INV_USER_ID",    inv_user_id);
    	
    	return result;
    }
    
    private GridData chkInvUserId(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes   = new GridData();
	    SepoaOut            value   = null;
	    SepoaFormater       sf      = null;
	    Map<String, String> svcParm = this.getQuerySvcParam(gdReq, info);
	    String              message = null;
	
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParm};
	
	    	value   = ServiceConnector.doService(info, "IV_001", "CONNECTION","chkInvUserId", obj);
	    	sf = new SepoaFormater(value.result[0]);
	    	
	    	message = sf.getValue("CNT", 0);
	    	
	    	gdRes.setMessage(message);
	    	gdRes.setStatus(Boolean.toString(value.flag));
	    }
	    catch (Exception e){
	    	gdRes.setMessage("-999");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
       
	public GridData getIvPoDetail(GridData gdReq, SepoaInfo info) throws Exception {
		
		GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try {
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
				
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {data};
				// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
				SepoaOut value = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getIvPoDetail", obj);
				
				if(value.flag) {
				    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				    gdRes.setStatus("true");
				} else {
					gdRes.setMessage(value.message);
					gdRes.setStatus("false");
				    return gdRes;
				}
				
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	} else {
				        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
				        }
					}
				}
			    
			} catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		    }
			
			return gdRes;
			
		
	}

	/*****************************************************************************************************************
	   A.DP_CODE=3[잔금]일 경우
	      1. 검수요청수량 == (수량-누적검수수량) && 검수요청금액 == (지급금액-누적검수요청금액)
	      2. 1.이 아닐 경우
	         2.1 조건 충족 :: 검수요청수량 < (수량-누적검수수량) && 검수요청금액 < (지급금액-누적검수요청금액)
	             ==> ICOYCNDP에 데이터 추가(STATUS='T', DP_CODE='3')
	   B.ICOYCNDP에 DP_CODE='3'인 데이터가 여러개 존재 가능.
	     ==> STATUS='T'인 것 중 MAX(DP_SEQ)인 것이 최종 잔금임.
	******************************************************************************************************************/
	public GridData setIvInsert(GridData gdReq, SepoaInfo info) throws Exception {
//		Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
//		Map<String, String> header = MapUtils.getMap(data, "headerData");
        GridData gdRes = null;
		Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
		Map<String, String> headerData = MapUtils.getMap(data, "headerData");

		String inv_no     			= headerData.get("inv_no");

		if("".equals(inv_no)){
			gdRes = insertInv(info, gdReq);
			return gdRes;
		}else{
			//gdRes =updateInv(info, gdReq, inv_no);
			return gdRes;
		}
		

	}
	public GridData insertInv(SepoaInfo info, GridData gdReq)  throws Exception
	{
			GridData gdRes   		= new GridData();
		    Vector multilang_id 	= new Vector();
		    multilang_id.addElement("MESSAGE");
		    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
	try {
		Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
		Map<String, String> headerData = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
		ArrayList<Map<String,String>> gridData = (ArrayList<Map<String, String>>) MapUtils.getObject(data,SepoaDataMapper.KEY_GRID_DATA);

		gdRes.setSelectable(false);
//		SepoaFormater wf = gdReq.getSepoaFormater();
//    	String house_code			= info.getSession("HOUSE_CODE");
//    	String id					= info.getSession("ID");
    	String dept					= info.getSession("DEPARTMENT");
//    	String company_code			= info.getSession("COMPANY_CODE");
//
//		String po_no     			= gdReq.getParam("po_no"				);
//		String iv_no     			= gdReq.getParam("iv_no"				);
//		String SUBJECT				= gdReq.getParam("SUBJECT"				);
//		String DP_TYPE				= gdReq.getParam("DP_TYPE"				);
//		String DP_PAY_TERMS			= ws.getParam("DP_PAY_TERMS"		);
//		String IV_SEQ				= ws.getParam("IV_SEQ"				);
		String DP_AMT				= "";
//		String PO_TTL_AMT			= ws.getParam("PO_TTL_AMT"			);
//		String ADD_USER_ID			= ws.getParam("ADD_USER_ID"			);
//		String INV_DATE				= ws.getParam("INV_DATE"			);
//		String REMARK				= ws.getParam("REMARK"				);
//		String DP_PAY_TERMS_TEXT	= ws.getParam("DP_PAY_TERMS_TEXT"	);
//		String PO_CREATE_DATE		= ws.getParam("PO_CREATE_DATE"		);
		String DP_PERCENT			= "";
//		String DP_TEXT				= ws.getParam("DP_TEXT"				);
//		String INV_PERSON_ID		= ws.getParam("add_user_id"			);
//		String ATTACH_NO			= ws.getParam("ATTACH_NO"			);
//		String CTRL_CODE			= ws.getParam("CTRL_CODE"			);
//		String DP_CODE				= ws.getParam("DP_CODE"				);
//		String LAST_FLAG			= ws.getParam("LAST_FLAG"			);
//		String EXEC_NO				= ws.getParam("EXEC_NO"				);
//		String DP_SEQ				= ws.getParam("DP_SEQ"				);
		String DP_DIV_CODE			= headerData.get("dp_type");
//		String start_date			= ws.getParam("start_change_date"				);
//		String end_date				= ws.getParam("end_change_date"				);
//		String setivdtData[][]  = new String[gridData.size()][];
//
//		String[] ITEM_NO			= wf.getValue("ITEM_NO"			);
//		String[] DESCRIPTION_LOC	= wf.getValue("DESCRIPTION_LOC"	);
//		String[] RD_DATE			= wf.getValue("RD_DATE"			);
//		String[] UNIT_MEASURE	    = wf.getValue("UNIT_MEASURE"	);
//		String[] ITEM_QTY		    = wf.getValue("ITEM_QTY"		);  //수량
//		String[] UNIT_PRICE			= wf.getValue("UNIT_PRICE"		);
//		String[] ITEM_AMT		    = wf.getValue("ITEM_AMT"		);	//지급금액
//		String[] GR_QTY				= wf.getValue("GR_QTY"			);
//		String[] INV_QTY			= wf.getValue("INV_QTY"			);  //검수요청수량
//		String[] PO_SEQ				= wf.getValue("PO_SEQ"			);
//	    String[] INPUT_FROM_DATE	= wf.getValue("INPUT_FROM_DATE" );
//		String[] INPUT_TO_DATE		= wf.getValue("INPUT_TO_DATE"   );
//		String[] PR_USER_ID			= wf.getValue("PR_USER_ID" 		);
//		String[] PURCHASE_ID		= wf.getValue("PURCHASE_ID"   	);
//		String[] MAKER_CODE			= wf.getValue("MAKER_CODE"   	);
//		String[] MAKER_NAME			= wf.getValue("MAKER_NAME"   	);
//		String[] INV_AMT			= wf.getValue("INV_AMT"   		);	//검수요청금액
//		String[] INV_QTY_SUM		= wf.getValue("INV_QTY_SUM"   	);	//누적검수수량
//		String[] INV_AMT_SUM		= wf.getValue("INV_AMT_SUM" 	);	//누적검수요청금액
//		String[] DP_DIV				= wf.getValue("DP_DIV" 			);
//        
		double fInvAmt = 0.0;
		
		for (Map<String, String> map : gridData) {
			double test = Double.parseDouble(MapUtils.getString(map, "INV_AMT", "0.0"));
			fInvAmt += test;
		}
//		
//		for(int i=0;i<INV_AMT.length;i++){
//			fInvAmt += Float.valueOf(INV_AMT[i]);
//		}
		Logger.debug.println("SUM(INV_AMT) 검수요청금액::"+ String.valueOf(fInvAmt));

		double fDpAmt = 0;
		 /* *******************************************************************************
		  * DP_CODE=3&&LAST_FLAG='Y'[잔금] 처리
		  * 1.지급금액=누적검수요청금액+검수요청금액
		  * 2.수량=누적검수수량+검수요청수량
		  *   ==>1.과2.를 만족할 경우 잔금요청. 아니면 잔금요청 후 차액(지급금액-누적검수요청금액-검수요청금액), 잔여수량(수량-누적검수수량-검수요청수량)에 대한 잔금을 추가.
		  * 3.두 건중 한건은 만족하나 한건은 만족하지 않을 때...
		  *  ==> 만족하는 한건은 잔금요청, 만족하지 않은 한 건은 잔금요청 후 차액(지급금액-누적검수요청금액-검수요청금액), 잔여수량(수량-누적검수수량-검수요청수량)에 대한 잔금을 추가
		  ******************************************************************************* */
		int iNum = 0;
		int arrLength = gridData.size();
		String[] tDP_AMT = new String[arrLength] ;
		String[] tDP_DIV = new String[arrLength] ;

		Logger.debug.println(this, "************ 잔금 처리 ************");
		Logger.debug.println(this, "************************ DP_SEQ::" + headerData.get("DP_SEQ"));
		Logger.debug.println(this, "************************ DP_CODE::" + headerData.get("DP_CODE"));
		Logger.debug.println(this, "************************ DP_DIV_CODE::" + DP_DIV_CODE);
		Logger.debug.println(this, "************************ LAST_FLAG::" + headerData.get("LAST_FLAG"));
		if("3".equals(headerData.get("DP_CODE")) ){	//일시불 or 잔금
			if(("I".equals(headerData.get("DP_DIV_CODE"))) || ("Y".equals(headerData.get("LAST_FLAG")))){
				//Logger.debug.println(this, "************************ 여기0::" + arrLength);
				for(Map<String, String> map : gridData){
					String invAmtSum = MapUtils.getString(map, "INV_AMT_SUM", "0");
					//Logger.debug.println(this, "************************ 여기0-1::" + invAmtSum);
					String invAmt = MapUtils.getString(map, "INV_QTY_SUM", "0");	//누적검수수량
					//Logger.debug.println(this, "************************ 여기0-2::" + invAmt);

					if(invAmtSum.length()==0) {invAmtSum="0";}
					if(invAmt.length()==0){ invAmt="0";}
					//Logger.debug.println(this, "************************ 여기1::" + Float.valueOf(ITEM_AMT[i]));
					//Logger.debug.println(this, "************************ 여기2::" + Float.valueOf(invAmtSum)+Float.valueOf(INV_AMT[i]));
					//Logger.debug.println(this, "************************ 여기3::" + Float.valueOf(ITEM_QTY[i]));
					//Logger.debug.println(this, "************************ 여기4::" + Float.valueOf(invAmt)+Float.valueOf(INV_QTY[i]));
	   				if(Float.valueOf(MapUtils.getString(map,"ITEM_AMT", "0.0")) == (Float.valueOf(invAmtSum)+Float.valueOf(MapUtils.getString(map,"INV_AMT", "0.0")))
	   						&& Float.valueOf(MapUtils.getString(map,"ITEM_QTY", "0.0")) == (Float.valueOf(invAmt)+Float.valueOf(MapUtils.getString(map,"INV_QTY", "0.0")))){
	   					Logger.debug.println(this, "************ 정상 잔금 처리 ************");

	   				}else{
	   					//ICOYCNDP에 등록(STATUS='T', DP_CODE='3', DP_AMT=[지급금액-누적검수요청금액-검수요청금액])
	   					tDP_AMT[iNum] = String.valueOf(Float.valueOf(MapUtils.getString(map,"ITEM_AMT", "0"))- Float.valueOf(invAmtSum) - Float.valueOf(MapUtils.getString(map,"INV_AMT", "0.0")));
	   	   				tDP_DIV[iNum] = MapUtils.getString(map,"DP_DIV", "0");
		   				iNum++;
		   				Logger.debug.println(this, "************ 잔금 추가 ************");
	   				}
	   			}
			}
		}

		//DP_CODE=3&&LAST_FLAG='Y'[잔금] 처리
        //잔여금액이나 잔여 수량이 남았을 경우 처리 - 상품, 용역 구분처리
		int iarrVal = 0;
		String blnDpDiv_I = "false";
    	String blnDpDiv_S = "false";
    	String strDpCode = "3";
    	String strCnStatus = "T";	//ICOYCNDP의 Status를 "T"로 업데이트.
    	float fdpDiv_I = 0;
    	float fINV_Amt_I = 0;
    	float fdpDiv_S = 0;
    	float fINV_Amt_S = 0;
    	float fItemAmt_I = 0;
    	float fItemAmt_S = 0;
    	double fdpPercent_I = 0;
    	double fdpPercent_S = 0;

    	if(iNum>0){	//잔금을 쪼갤 경우
        	for (Map<String, String> map : gridData) {
        		if("I".equals(MapUtils.getString(map,"DP_DIV", "0"))){	//상품
        			fdpDiv_I += Float.valueOf(MapUtils.getString(map,"INV_AMT", "0.0"));		//ICOYCNDP[DP_AMT]
        			fItemAmt_I += Float.valueOf(MapUtils.getString(map,"ITEM_AMT", "0.0"));	//지급금액
        			fINV_Amt_I += Float.valueOf(MapUtils.getString(map,"INV_AMT", "0.0"));
        			blnDpDiv_I = "true";
        		}else{
        			fdpDiv_S += Float.valueOf(MapUtils.getString(map,"INV_AMT", "0.0"));		//ICOYCNDP[DP_AMT]
        			fItemAmt_S += Float.valueOf(MapUtils.getString(map,"ITEM_AMT", "0.0"));
        			fINV_Amt_S += Float.valueOf(MapUtils.getString(map,"INV_AMT", "0.0"));
        			blnDpDiv_S = "true";
        		}
    		}
        	fdpPercent_I = fINV_Amt_I/fItemAmt_I*100;
        	fdpPercent_S = fINV_Amt_S/fItemAmt_S*100;

        	Logger.debug.println(this, "************ 잔금  ************fdpPercent_I=="+fdpPercent_I+", fdpDiv_I=="+ String.valueOf(fdpDiv_I) +", ITEM_AMT=="+String.valueOf(fItemAmt_I));
        	Logger.debug.println(this, "************ 잔금  ************fdpPercent_S=="+fdpPercent_S+", fdpDiv_S=="+ String.valueOf(fdpDiv_S) +", ITEM_AMT=="+String.valueOf(fItemAmt_S));

        	if("true".equals(blnDpDiv_I) && "true".equals(blnDpDiv_S)){
        		iarrVal =1;
        	}
        	else if("true".equals(blnDpDiv_I) && "false".equals(blnDpDiv_S)){
        		iarrVal =0;
        		fdpPercent_S = 0;
        	}
        	else if("false".equals(blnDpDiv_I) && "true".equals(blnDpDiv_S)){
        		iarrVal =0;
        		fdpPercent_I = 0;
        	}
        }else{
        	if("I".equals(DP_DIV_CODE)){
        		fdpPercent_I = fInvAmt/Double.parseDouble(headerData.get("DP_AMT"))*100;
        	}else{
        		fdpPercent_S = fInvAmt/Double.parseDouble(headerData.get("DP_AMT"))*100;
        	}
        }
		
    	String[][] setcndpData = new String[iarrVal+1][];
    	headerData.put("strCnStatus", strCnStatus);
        headerData.put("strDpCode", strDpCode);
//    	if(blnDpDiv_I){
//        	String cndpData[] = { info.getSession("HOUSE_CODE")
//					, headerData.get("EXEC_NO")
//					, "I"
//					, strCnStatus
//					, info.getSession("HOUSE_CODE")
//					, headerData.get("po_no")
//					, "I"
//					, info.getSession("HOUSE_CODE")
//					, headerData.get("po_no")
//					, "I"
//					, strDpCode 						//DP_CODE[3:잔금]
//					, info.getSession("HOUSE_CODE")
//					, headerData.get("EXEC_NO")
//					, headerData.get("DP_SEQ")
//					, "I"						//DP_DIV[I:상품]
//				  	};
//        	setcndpData[0] = cndpData;
//    	}
//    	if(blnDpDiv_S){
//        	String cndpData[] = { house_code
//					, EXEC_NO
//					, "S"
//					, strCnStatus
//					,  house_code
//					, po_no
//					, "S"
//					,  house_code
//					, po_no
//					, "S"
//					, strDpCode 						//DP_CODE[3:잔금]
//					, house_code
//					, EXEC_NO
//					, DP_SEQ
//					, "S"						//DP_DIV[S:용역]
//				  	};
//        	setcndpData[iarrVal] = cndpData;
//    	}
    	
    	
		DP_AMT = "";
		DP_AMT = String.valueOf(fInvAmt);	//검수요청금액
		DP_PERCENT = "";
		if(fdpPercent_S ==0 ){
			//DP_PERCENT = String.valueOf(fdpPercent_I);
			DP_PERCENT = SepoaString.formatNum(fdpPercent_I);
		}else if(fdpPercent_I == 0 ){
			//DP_PERCENT = String.valueOf(fdpPercent_S);
			DP_PERCENT = SepoaString.formatNum(fdpPercent_S);
		}
		
        SepoaOut wo = DocumentUtil.getDocNumber(info,"IV");
        String  inv_no = wo.result[0];
        headerData.put("blnDpDiv_I", blnDpDiv_I);
        headerData.put("blnDpDiv_S", blnDpDiv_S);
        headerData.put("DP_AMT", DP_AMT);
        headerData.put("DP_PERCENT", DP_PERCENT);
        headerData.put("inv_no", inv_no);
//        String setivhdData[][]	={{ house_code 						//HOUSE_CODE
//									,inv_no							//INV_NO
//									,SUBJECT						//SUBJECT
//									,SepoaDate.getShortDateString()	//ADD_DATE
//									,SepoaDate.getShortTimeString()  //ADD_TIME
//									,id								//ADD_USER_ID
//									,dept 							//ADD_USER_DEPT
//									,company_code					//VENDOR_CODE
//									,DP_TYPE						//DP_TYPE
//									,DP_AMT							//DP_AMT
//									,DP_PAY_TERMS					//DP_PAY_TERMS
//									,DP_PAY_TERMS_TEXT				//DP_PAY_TERMS_TEXT
//									,PO_TTL_AMT						//PO_TTL_AMT
//									,PO_CREATE_DATE					//PO_CREATE_DATE
//									,"0"							//INV_AMT
//									,PR_USER_ID[0]					//INV_PERSON_ID
//									,INV_DATE						//INV_DATE
//									,REMARK							//REMARK
//									,PURCHASE_ID[0]					//PURCHARSE_ID
//									,IV_SEQ
//									,DP_PERCENT
//									,DP_TEXT
//									,ATTACH_NO
//									,CTRL_CODE
//									,DP_DIV_CODE
//									,start_date
//									,end_date
//									}};
//        
        int i = 0; //INV_SEQ 
        for (Map<String,String> map : gridData) {
        	
        	map.put("RD_DATE",SepoaString.getDateUnSlashFormat(map.get("RD_DATE")));
        	map.put("INV_NO",headerData.get("inv_no"));
        	map.put("IV_NO",headerData.get("iv_no"));
        	map.put("PO_NO",headerData.get("po_no"));
        	map.put("ADD_USER_ID",headerData.get("ADD_USER_ID"));
        	map.put("ADD_USER_DEPT",dept);
        	map.put("INV_SEQ", CommonUtil.lpad(String.valueOf(i),6,"0"));
        	i++;
		}
//        for (int i = 0; i<wf.getRowCount(); i++) {
//			String ivdtData[] = {house_code
//								,inv_no
//								,CommonUtil.lpad(String.valueOf(i),6,"0")
//								,iv_no
//								,po_no
//								,PO_SEQ[i]
//								,SepoaDate.getShortDateString()
//								,SepoaDate.getShortTimeString()
//								,id
//								,dept
//								,ITEM_NO[i]
//								,UNIT_MEASURE[i]
//								,ITEM_QTY[i]
//								,UNIT_PRICE[i]
//								,ITEM_AMT[i]
//								,RD_DATE[i]
//								,"0"
//								,INV_QTY[i]
//								,DESCRIPTION_LOC[i]
//								,INPUT_FROM_DATE[i]
//								,INPUT_TO_DATE[i]
//								,MAKER_CODE[i]
//								,MAKER_NAME[i]
//								,INV_AMT[i]
//								,INV_AMT[i]
//							  	};
//			setivdtData[i] = ivdtData;
//		}
       
        
        if(iNum == 0){
        	 setcndpData = null;
        }

		Object[] obj = {data};
		SepoaOut value = ServiceConnector.doService(info, "IV_001", "TRANSACTION", "setIvInsert", obj);
//		
		if(value.flag) {
			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			gdRes.setStatus("true");
		}else {
			gdRes.setMessage(value.message);
			gdRes.setStatus("false");
		}
	}catch (Exception e) {
//		e.printStackTrace();
		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
		gdRes.setStatus("false");
	}

		return gdRes;

//		ws.setUserObject(res);
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);

		/*검수요청 sms 보내기*/
		/*if(value.status == 1){
			//sendMail(info, inv_no);
			try{
				String[] args = {inv_no};
				Object[] sms_args = {args};
				ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00010", sms_args);
			} catch (Exception e) {
				Logger.debug.println("mail error = " + e.getMessage());
				e.printStackTrace();
			}
		}*/
//		ws.write();
	}

	public void updateInv(SepoaInfo info, SepoaStream ws, String inv_no) throws Exception {
		SepoaFormater wf = ws.getSepoaFormater();
    	String house_code			= info.getSession("HOUSE_CODE");
    	String id					= info.getSession("ID");
    	String dept					= info.getSession("DEPARTMENT");
    	String company_code			= info.getSession("COMPANY_CODE");

    	String[] INV_QTY			= wf.getValue("INV_QTY"			);
		String[] INV_SEQ			= wf.getValue("INV_SEQ"			);
	    String[] INPUT_FROM_DATE	= wf.getValue("INPUT_FROM_DATE" );
		String[] INPUT_TO_DATE		= wf.getValue("INPUT_TO_DATE"   );
		String[] INV_AMT			= wf.getValue("INV_AMT"   		);	//검수요청금액
		String ATTACH_NO			= ws.getParam("ATTACH_NO"	    );
		String PO_NO				= ws.getParam("po_no"	    	);
		String SUBJECT				= ws.getParam("SUBJECT"	    	);

		/*****************************************************************************************************/
		/*	2010.07.27  																					 */
		/*****************************************************************************************************/
		String[] INV_QTY_SUM		= wf.getValue("INV_QTY_SUM"   		);	//누적검수수량
		String[] INV_AMT_SUM		= wf.getValue("INV_AMT_SUM" 		);	//누적검수요청금액
		String[] DP_DIV				= wf.getValue("DP_DIV" 				);
		String[] ITEM_AMT		    = wf.getValue("ITEM_AMT"			);	//지급금액
		String[] ITEM_QTY		    = wf.getValue("ITEM_QTY"			);  //수량

		String DP_PERCENT			= ws.getParam("DP_PERCENT"			);
		String DP_AMT				= ws.getParam("DP_AMT"				);
		String DP_CODE				= ws.getParam("DP_CODE"				);
		String LAST_FLAG			= ws.getParam("LAST_FLAG"			);
		String EXEC_NO				= ws.getParam("EXEC_NO"				);
		String DP_SEQ				= ws.getParam("DP_SEQ"				);
		String DP_DIV_CODE			= ws.getParam("DP_DIV"				);
		String start_date			= ws.getParam("start_change_date"	);
		String end_date				= ws.getParam("end_change_date"		);

		float fInvAmt = 0;
		for(int i=0;i<INV_AMT.length;i++){
			fInvAmt += Float.valueOf(INV_AMT[i]);
		}
		Logger.debug.println("SUM(INV_AMT) 검수요청금액::"+fInvAmt);

		float fDpAmt = 0;
		 /* *******************************************************************************
		  * DP_CODE=3&&LAST_FLAG='Y'[잔금] 처리
		  * 1.지급금액=누적검수요청금액+검수요청금액
		  * 2.수량=누적검수수량+검수요청수량
		  *   ==>1.과2.를 만족할 경우 잔금요청. 아니면 잔금요청 후 차액(지급금액-누적검수요청금액-검수요청금액), 잔여수량(수량-누적검수수량-검수요청수량)에 대한 잔금을 추가.
		  * 3.두 건중 한건은 만족하나 한건은 만족하지 않을 때...
		  *  ==> 만족하는 한건은 잔금요청, 만족하지 않은 한 건은 잔금요청 후 차액(지급금액-누적검수요청금액-검수요청금액), 잔여수량(수량-누적검수수량-검수요청수량)에 대한 잔금을 추가
		  ******************************************************************************* */
		int iNum = 0;
		int arrLength = INV_AMT.length;
		String[] tDP_AMT = new String[arrLength] ;
		String[] tDP_DIV = new String[arrLength] ;

		Logger.debug.println(this, "************ 잔금 처리 ************");
		Logger.debug.println(this, "************************ DP_CODE::" + DP_CODE);
		Logger.debug.println(this, "************************ DP_DIV_CODE::" + DP_DIV_CODE);
		Logger.debug.println(this, "************************ LAST_FLAG::" + LAST_FLAG);
		if("3".equals(DP_CODE) ){	//일시불 or 잔금
			if(("I".equals(DP_DIV_CODE)) || ("Y".equals(LAST_FLAG))){
				for(int i=0;i<arrLength;i++){
					String invAmtSum = INV_AMT_SUM[i];
					String invAmt = INV_QTY_SUM[i];	//누적검수수량
					
					if(invAmtSum.length()==0){ invAmtSum="0";}
					if(invAmt.length()==0) {invAmt="0";}
					
	   				if(Float.valueOf(ITEM_AMT[i]) == (Float.valueOf(invAmtSum)+Float.valueOf(INV_AMT[i]))
	   						&& Float.valueOf(ITEM_QTY[i]) == (Float.valueOf(invAmt)+Float.valueOf(INV_QTY[i]))){
	   					Logger.debug.println(this, "************ 정상 잔금 처리 ************");
	   					
	   				}else{
	   					//ICOYCNDP에 등록(STATUS='T', DP_CODE='3', DP_AMT=[지급금액-누적검수요청금액-검수요청금액])
	   					tDP_AMT[iNum] = String.valueOf(Float.valueOf(ITEM_AMT[i])- Float.valueOf(invAmtSum) - Float.valueOf(INV_AMT[i]));
	   	   				tDP_DIV[iNum] = DP_DIV[i];
		   				iNum++;
		   				Logger.debug.println(this, "************ 잔금 추가 ************");
	   				}
	   			}
			}
		}

		 //DP_CODE=3&&LAST_FLAG='Y'[잔금] 처리
        //  잔여금액이나 잔여 수량이 남았을 경우 처리 - 상품, 용역 구분처리
		int iarrVal = 0;
		boolean blnDpDiv_I = false;
    	boolean blnDpDiv_S = false;
    	String strDpCode = "3";
    	String strCnStatus = "T";	//ICOYCNDP의 Status를 "T"로 업데이트.
    	float fdpDiv_I = 0;
    	float fINV_Amt_I = 0;
    	float fdpDiv_S = 0;
    	float fINV_Amt_S = 0;
    	float fItemAmt_I = 0;
    	float fItemAmt_S = 0;
    	float fdpPercent_I = 0;
    	float fdpPercent_S = 0;
    	if(iNum>0){
        	for (int i = 0; i<iNum; i++) {
        		if("I".equals(tDP_DIV[i])){	//상품
        			fdpDiv_I += Float.valueOf(tDP_AMT[i]);		//ICOYCNDP[DP_AMT]
        			fItemAmt_I += Float.valueOf(ITEM_AMT[i]);	//지급금액
        			fINV_Amt_I += Float.valueOf(INV_AMT[i]);
        			blnDpDiv_I = true;
        		}else{
        			fdpDiv_S += Float.valueOf(tDP_AMT[i]);		//ICOYCNDP[DP_AMT]
        			fItemAmt_S += Float.valueOf(ITEM_AMT[i]);
        			fINV_Amt_S += Float.valueOf(INV_AMT[i]);
        			blnDpDiv_S = true;
        		}
    		}

        	fdpPercent_I = fINV_Amt_I/fItemAmt_I*100;
        	fdpPercent_S = fINV_Amt_S/fItemAmt_S*100;

        	Logger.debug.println(this, "************ 잔금  ************fdpPercent_I=="+fdpPercent_I+", fdpDiv_I=="+fdpDiv_I+", ITEM_AMT=="+fItemAmt_I);
        	Logger.debug.println(this, "************ 잔금  ************fdpPercent_S=="+fdpPercent_S+", fdpDiv_S=="+fdpDiv_S+", ITEM_AMT=="+fItemAmt_S);

        	if(blnDpDiv_I && blnDpDiv_S){
        		iarrVal =1;
        	}
        	else if(blnDpDiv_I && blnDpDiv_S==false){
        		iarrVal =0;
        		fdpPercent_S = 0;
        	}
        	else if(blnDpDiv_I==false && blnDpDiv_S){
        		iarrVal =0;
        		fdpPercent_I = 0;
        	}

        }

    	String[][] setcndpData = new String[iarrVal+1][];

    	if(blnDpDiv_I){
    		String cndpData[] = { house_code
					, EXEC_NO
					, "I"
					, strCnStatus
					,  house_code
					, PO_NO
					, "I"
					,  house_code
					, PO_NO
					, "I"
					, strDpCode 						//DP_CODE[3:잔금]
					, house_code
					, EXEC_NO
					, DP_SEQ
					, "I"						//DP_DIV[S:용역]
				  	};
        	setcndpData[0] = cndpData;
    	}
    	if(blnDpDiv_S){
        	String cndpData[] = { house_code
					, EXEC_NO
					, "S"
					, strCnStatus
					,  house_code
					, PO_NO
					, "S"
					,  house_code
					, PO_NO
					, "S"
					, strDpCode 						//DP_CODE[3:잔금]
					, house_code
					, EXEC_NO
					, DP_SEQ
					, "S"						//DP_DIV[S:용역]
				  	};

        	setcndpData[iarrVal] = cndpData;
    	}

		DP_AMT = "";
		DP_AMT = String.valueOf(fInvAmt);	//검수요청금액
		DP_PERCENT = "";
		if(fdpPercent_S ==0 ){
			DP_PERCENT = String.valueOf(fdpPercent_I);
		}else if(fdpPercent_I == 0 ){
			DP_PERCENT = String.valueOf(fdpPercent_S);
		}

        String setivdtData[][]  = new String[wf.getRowCount()][];
        for (int i = 0; i<wf.getRowCount(); i++) {
			String ivdtData[] = {INV_QTY[i]
								,INPUT_FROM_DATE[i]
								,INPUT_TO_DATE[i]
								,id
								,dept
								,INV_AMT[i]
								,house_code
								,inv_no
								,INV_SEQ[i]
							  	};
			setivdtData[i] = ivdtData;
		}

		Object[] obj = {setivdtData, setcndpData, ATTACH_NO, PO_NO, SUBJECT, DP_PERCENT, start_date, end_date};
		SepoaOut value = ServiceConnector.doService(info, "s2050", "TRANSACTION", "updateInv", obj);

		String[] res = new String[1];
		res[0] = value.message;

		ws.setUserObject(res);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();

		/*검수요청 메일 보내기*/
		if(value.status == 1){
			sendMail(info, inv_no);
		}
	}

	public void sendMail(SepoaInfo info, String inv_no) throws Exception {
		try{
			Object[] sms_args = {inv_no};
	        String mail_type = "";

	        mail_type 	= "M00012";

	        if(!"".equals(mail_type)){
	        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
	        }
		}catch(Exception e){
			Logger.debug.println();
		}
	}
}
