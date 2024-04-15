package dt.ebd;

import java.io.IOException;
import java.io.PrintWriter;
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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ebd_bd_lis4 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
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

			if("getReqBidItemList".equals(mode)){ // 품목 마스터 조회
				gdRes = this.getReqBidItemList(gdReq, info);
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
    private GridData getReqBidItemList(GridData gdReq, SepoaInfo info) throws Exception{
        GridData            gdRes        = new GridData();
        SepoaFormater       sf           = null;
        SepoaOut            value        = null;
        Vector              v            = new Vector();
        HashMap             message      = null;
        Map<String, Object> allData      = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header       = null;
        String              gridColId    = null;
        String              houseCode    = info.getSession("HOUSE_CODE");
        String[]            gridColAry   = null;
        int                 rowCount     = 0;
        
        v.addElement("MESSAGE");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData    = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header     = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");
            
            String add_date_start = SepoaString.getDateUnSlashFormat( MapUtils.getString( header , "add_date_start ".trim() ) );
            String add_date_end   = SepoaString.getDateUnSlashFormat( MapUtils.getString( header , "add_date_end   ".trim() ) );
            
            header.put("add_date_start ".trim(), add_date_start );
            header.put("add_date_end   ".trim(), add_date_end   );
            header.put("HOUSE_CODE     ".trim(), houseCode);

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info, "p1015","CONNECTION","getReqBidItemList",obj);

            if(value.flag){ // 조회 성공
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
                return gdRes;
            }
            
            sf= new SepoaFormater(value.result[0]);
            
            rowCount = sf.getRowCount(); // 조회 건수

            if(rowCount == 0){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                
                return gdRes;
            }
            
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
        catch (Exception e){
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    

//
//    public void doQuery(WiseStream ws) throws Exception 
//    {
//        String mode = ws.getParam("mode");
//		if(mode.equals("getReqBidItemList"))
//		{
//			getReqBidItemList(mode, ws);
//		}
//    }
//    
//    private void getReqBidItemList(String mode, WiseStream ws) throws Exception
//    {
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//    	Message msg = new Message("STDCOMM");
//    	
//        String house_code = info.getSession("HOUSE_CODE");
//        
//        String add_date_start	= ws.getParam("add_date_start");
//		String add_date_end		= ws.getParam("add_date_end"); 
//		String add_user_id		= ws.getParam("add_user_id");
//		String pr_no    		= ws.getParam("pr_no");  
//		String subject    		= ws.getParam("subject");
//		String pr_status    	= ws.getParam("pr_status");  
//		String create_type    	= ws.getParam("create_type"); 
//		String order_no    		= ws.getParam("order_no");  		
//		String purchaser_id    	= ws.getParam("purchaser_id");
//		String demand_dept    	= ws.getParam("demand_dept");
//		
//		
//		 
//		String[] args = {
//				  add_date_start
//				, add_date_end
//				, add_user_id
//				, pr_no 
//				, subject
//				, pr_status 
//				, create_type
//				, order_no
//				, purchaser_id
//				, demand_dept
//		};
//		  
//		WiseOut value = ServiceConnector.doService(info,"p1015","CONNECTION","getReqBidItemList",args);
//    	
//		WiseFormater wf = ws.getWiseFormater(value.result[0]);
//
//		String[] userObj = { mode , CommonUtil.getServerDate() };
//		
//		if(wf.getRowCount() == 0) 
//		{
//	    	ws.setUserObject(userObj);
//			ws.setMessage(msg.getMessage("0008"));
//			ws.write();
//			return;
//  	    }
//		
//			String IMG = "/kr/images/button/butt_query.gif";
//
//		for(int i=0; i<wf.getRowCount(); i++)
//		{
//				String[] SELECTED       = {"false", ""};
//				String[] IMG_PR_NO 		= {"",wf.getValue("PR_NO",i),wf.getValue("PR_NO",i)};
//				String[] POP			= {IMG,"",""};
//				String[] IMG_INFO 		= {IMG,wf.getValue("INFO_VENDOR",i),wf.getValue("INFO_VENDOR",i)}; 
//				String[] IMG_BID 		= {IMG,wf.getValue("BID_VENDOR",i),wf.getValue("BID_VENDOR",i)};
//				String[] IMG_ITEM_NO	= {"",wf.getValue("ITEM_NO",i),wf.getValue("ITEM_NO",i)};
//				   				
//                String PR_STATUS = wf.getValue("PR_STATUS", i);
//                String tmpPR_STATUS_FLAG = "";
//                String tmpPR_STATUS = "";
//
//                String[] pr_tmp = CommonUtil.getTokenData(PR_STATUS, "^");
//                tmpPR_STATUS		= pr_tmp[0];
//                tmpPR_STATUS_FLAG 	= pr_tmp[1]; 
//
//                wf.setValue("PR_STATUS", tmpPR_STATUS, i);
//                wf.setValue("PR_STATUS_FLAG", tmpPR_STATUS_FLAG, i); 
//
//				ws.addValue("SELECTED"				, SELECTED									, ""); 
//				ws.addValue("PR_STATUS"         	, wf.getValue("PR_STATUS"				, i), "");
//				ws.addValue("PR_STATUS_FLAG"    	, tmpPR_STATUS_FLAG							, "");                                                
//				ws.addValue("PR_TYPE_NAME"      	, wf.getValue("PR_TYPE_NAME"            , i), ""); 
//				ws.addValue("PR_NO"					, IMG_PR_NO									, "");																	
//				ws.addValue("SUBJECT"           	, wf.getValue("SUBJECT"         		, i), "");                                          
//				ws.addValue("ADD_DATE"          	, wf.getValue("ADD_DATE"                , i), "");                                          
//				ws.addValue("RETURN_HOPE_DAY" 		, wf.getValue("RETURN_HOPE_DAY"       	, i), "");    
//				ws.addValue("DEMAND_DEPT_NAME"  	, wf.getValue("DEMAND_DEPT_NAME"        , i), "");                                  
//				ws.addValue("ADD_USER_NAME"     	, wf.getValue("ADD_USER_NAME"           , i), "");                                                  
//				ws.addValue("ITEM_NO"           	, IMG_ITEM_NO								, ""); 
//				ws.addValue("DESCRIPTION_LOC"   	, wf.getValue("DESCRIPTION_LOC"         , i), "");  
//				ws.addValue("SPECIFICATION"   		, wf.getValue("SPECIFICATION"         	, i), "");    
//				ws.addValue("MAKER_NAME"   			, wf.getValue("MAKER_NAME"         		, i), "");    
//				ws.addValue("MAKER_CODE"   			, wf.getValue("MAKER_CODE"         		, i), "");                                        
//				ws.addValue("PURCHASER_ID"   		, wf.getValue("PURCHASER_ID"   			, i), "");                                        
//				ws.addValue("PURCHASER_NAME"   		, wf.getValue("PURCHASER_NAME"   		, i), "");    
//				ws.addValue("UNIT_MEASURE"     		, wf.getValue("UNIT_MEASURE"     		, i), "");                                          
//    
//				ws.addValue("PR_QTY"     		, wf.getValue("PR_QTY"     		, i), "");
//				ws.addValue("CUR"               	, wf.getValue("CUR"                     , i), "");                                                                                    
//				ws.addValue("UNIT_PRICE"     		, wf.getValue("UNIT_PRICE"     		, i), "");                                          
//				ws.addValue("EXPECT_AMT"     		, wf.getValue("EXPECT_AMT"     		, i), "");                                          
//				ws.addValue("PR_AMT"     		, wf.getValue("PR_AMT"     		, i), "");                                      
//				ws.addValue("PR_KRW_AMT"     		, wf.getValue("PR_KRW_AMT"     		, i), "");
//        
//        		if("".equals(wf.getValue("REC_VENDOR_NAME",i))){
//        			String[] REC_VENDOR_NAME =  {"",wf.getValue("REC_VENDOR_NAME",i),wf.getValue("REC_VENDOR_NAME",i)};
//    				ws.addValue("REC_VENDOR_NAME"   	, REC_VENDOR_NAME, "");    
//        		}else {
//        			String[] REC_VENDOR_NAME =  {IMG,wf.getValue("REC_VENDOR_NAME",i),wf.getValue("REC_VENDOR_NAME",i)};
//    				ws.addValue("REC_VENDOR_NAME"   	, REC_VENDOR_NAME, "");    
//        		}
//        
//				
//				
//				ws.addValue("CUST_NAME"         	, wf.getValue("CUST_NAME"               , i), "");     
//				                                	                                
//				ws.addValue("DEMAND_DEPT"   		, wf.getValue("DEMAND_DEPT"         	, i), "");                                        
//				ws.addValue("ADD_USER_ID"       	, wf.getValue("ADD_USER_ID"             , i), "");   
//				ws.addValue("REC_VENDOR_CODE"   	, wf.getValue("REC_VENDOR_CODE"         , i), "");   
//				ws.addValue("SIGN_STATUS"   		, wf.getValue("SIGN_STATUS"         	, i), "");   
//				ws.addValue("PR_TYPE"   			, wf.getValue("PR_TYPE"         		, i), "");   
//				ws.addValue("PLANT_CODE"   			, wf.getValue("PLANT_CODE"         		, i), "");    
//				ws.addValue("SHIPPER_TYPE"   		, wf.getValue("SHIPPER_TYPE"         	, i), "");    
//				ws.addValue("CTRL_CODE"   			, wf.getValue("CTRL_CODE"         		, i), "");      
//				ws.addValue("PR_SEQ"				, wf.getValue("PR_SEQ"         			, i), ""); 					
//				ws.addValue("DELY_TO_ADDRESS"		, wf.getValue("DELY_TO_ADDRESS"         , i), ""); 		    	
//				ws.addValue("DELY_TO_ADDRESS_NAME"	, wf.getValue("DELY_TO_ADDRESS_NAME"    , i), ""); 		
//				ws.addValue("DELY_TO_LOCATION"		, wf.getValue("DELY_TO_LOCATION"        , i), ""); 			
//				ws.addValue("DELY_TO_LOCATION_NAME"	, wf.getValue("DELY_TO_LOCATION_NAME"   , i), ""); 		
//				ws.addValue("RD_DATE"				, wf.getValue("RD_DATE"         		, i), ""); 				    	
//				ws.addValue("PURCHASE_LOCATION"		, wf.getValue("PURCHASE_LOCATION"       , i), ""); 		    	
//				ws.addValue("CTRL_NAME"				, wf.getValue("CTRL_NAME"         		, i), ""); 	
//				
//                if(tmpPR_STATUS_FLAG.equals("B")) 	{
//                	ws.addValue("INFO_VENDOR"			, IMG_INFO									, ""); 	
//					ws.addValue("BID_STATUS"		, "N", ""); 						    	
//				}else { 
//						ws.addValue("INFO_VENDOR"			, IMG_BID									, ""); 	
//						if(wf.getValue("BID_PR_NO",i).length() > 0) ws.addValue("BID_STATUS"		, "Y", "");  
//						else ws.addValue("BID_STATUS"		, "N", "");  
//				}
//							    	
//				ws.addValue("CREATE_TYPE"			, wf.getValue("CREATE_TYPE"         	, i), ""); 
//				ws.addValue("CREATE_TYPE_TEXT"		, wf.getValue("CREATE_TYPE_TEXT"        , i), ""); 
//				ws.addValue("REQ_TYPE"				, wf.getValue("REQ_TYPE"         		, i), "");   
//				ws.addValue("HUMAN_NAME_LOC"		, wf.getValue("HUMAN_NAME_LOC"         	, i), "");   
//				ws.addValue("TECHNIQUE_GRADE"		, wf.getValue("TECHNIQUE_GRADE"         , i), ""); 	
//				ws.addValue("TECHNIQUE_FLAG"		, wf.getValue("TECHNIQUE_FLAG"         	, i), ""); 	
//				ws.addValue("TECHNIQUE_TYPE"		, wf.getValue("TECHNIQUE_TYPE"         	, i), ""); 	
//				ws.addValue("BID_PR_NO"				, wf.getValue("BID_PR_NO"         		, i), ""); 		
//				ws.addValue("INPUT_FROM_DATE"		, wf.getValue("INPUT_FROM_DATE"         , i), ""); 		
//				ws.addValue("INPUT_TO_DATE"			, wf.getValue("INPUT_TO_DATE"         	, i), ""); 		
//				ws.addValue("ATTACH_NO"				, wf.getValue("ATTACH_NO"         		, i), ""); 		
//				ws.addValue("ATT_COUNT"				, wf.getValue("ATT_COUNT"         		, i), "");
//            	ws.addValue("ORDER_NO"				, wf.getValue("ORDER_NO"				, i), "");
//            	ws.addValue("CONFIRM_YN"			, wf.getValue("CONFIRM_YN"				, i), "");
//            	ws.addValue("CONFIRM_DATE"			, wf.getValue("CONFIRM_DATE"			, i), "");
//            	ws.addValue("CONFIRM_TIME"			, wf.getValue("CONFIRM_TIME"			, i), "");
//            	ws.addValue("CONFIRM_USER_ID"		, wf.getValue("CONFIRM_USER_ID"			, i), "");
//            	ws.addValue("CONFIRM_USER_NAME"		, wf.getValue("CONFIRM_USER_NAME"		, i), "");            	
//            	ws.addValue("IF_FLAG"				, wf.getValue("IF_FLAG"					, i), "");
//            	
//            	ws.addValue("PREFERRED_BIDDER_VENDOR_CODE"				, wf.getValue("PREFERRED_BIDDER_VENDOR_CODE"					, i), "");
//            	ws.addValue("PREFERRED_BIDDER_VENDOR_NAME"				, wf.getValue("PREFERRED_BIDDER_VENDOR_NAME"					, i), "");
//            	
//	
//		}
//		
//		ws.setUserObject(userObj);
//		ws.setMessage(value.message);
//		ws.write();
//    } 
//	
    
}

