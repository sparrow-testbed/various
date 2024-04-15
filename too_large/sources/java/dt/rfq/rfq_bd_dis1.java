package dt.rfq;


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

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.icompia.util.CommonUtil;

public class rfq_bd_dis1 extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException{Logger.debug.println();}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
		doPost(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
		
		try{
			
			gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if ("getRfqDTDisplay".equals(mode)){			// 견적요청상세 조회
				gdRes = getRfqDTDisplay(gdReq,info);
			}	
			else if ("getVendorCode".equals(mode)){		// 
				Logger.debug.println();
				//gdRes = getVendorCode(gdReq,info);
       		}
			else if ("getHumtCnt".equals(mode)){		// 
				Logger.debug.println();
				//gdRes = getHumtCnt(gdReq,info);
       		}
       		/*else if (mode.equals("doDelete")){	// 삭제
       			gdRes = doDelete(gdReq, info);		
       		}
       		else if (mode.equals("doInsert")){		// 입력
       		
       			gdRes = doInsert(gdReq, info);
       		}
       		else if (mode.equals("doAddRow")){		//행추가	
       			gdRes = doAddRow(gdReq, info);		
       		}
       		else if (mode.equals("doQuery_DM")){	// 	
       			gdRes = doQuery_DM(gdReq, info);		
       		}*/
	       		
		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
        	gdRes.setStatus("false"); 
        	
        } finally {
        	try {
        		OperateGridData.write(req, res, gdRes, out);
        	} catch (Exception e) {
        		Logger.debug.println();
        	}
        }
	}
	

	private GridData getRfqDTDisplay(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
   	    Vector multilang_id 	= new Vector();
   	    multilang_id.addElement("MESSAGE");
   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
   	
		SepoaFormater       sf              = null;
        Map<String, Object> allData         = null; // 해더데이터와 그리드데이터 함께 받을 변수
        //Map<String, String> header          = null;
        SepoaOut            value           = null;
        String              grid_col_id     = null;
        String[]            grid_col_ary    = null;
        //int                 rowCount      = 0;
        
        try{
        	allData         = SepoaDataMapper.getData(info, gdReq);	// 파라미터로 넘어온 모든 값 조회
        	//header       = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
        	grid_col_id  = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "doQuery");
   			
            Object[] obj = {allData};
            // DB  : CONNECTION, TRANSACTION, NONDBJOB
            value        = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqDTDisplay", obj);
   			if(value.flag) {
   			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
   			    gdRes.setStatus("true");
   			} else {
   				gdRes.setMessage(value.message);
   				gdRes.setStatus("false");
   			    return gdRes;
   			}
   			
   			sf = new SepoaFormater(value.result[0]);
   			
   			if (sf.getRowCount() == 0) {
   			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
   			    return gdRes;
   			}
   			
   			String img_name = "/kr/images/icon/detail.gif";
            String desc = "N" ; 
            String HOUSE_CODE = info.getSession("HOUSE_CODE");
            
        	SepoaCombo sepoacombo = new SepoaCombo();
        	String cbo_cur[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0014", HOUSE_CODE+"#M002", "");
        	String cbo_grade[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0022", HOUSE_CODE+"#M169", "");
        	String cbo_flag[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0022", HOUSE_CODE+"#M181", "");
        	String cbo_type[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0018", HOUSE_CODE+"#M170", "");
        	String cbo_dely[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0022", HOUSE_CODE+"#M187", "");
   			
   			for (int i = 0; i < sf.getRowCount(); i++) {
   				for(int k=0; k < grid_col_ary.length; k++) {
   			    	
   					String[] img_item_no = {"", sf.getValue("ITEM_NO" ,i), sf.getValue("ITEM_NO" ,i)};
   	            	String img_cnt = sf.getValue("ATTACH_CNT" ,i);
   					
   	            	if("0".equals(sf.getValue("ATTACH_CNT" ,i))) {
   	            		img_name = "";  img_cnt ="";
   	            	} 
   	            	String[] img_attach_no = {img_name, img_cnt, sf.getValue("ATTACH_NO" ,i)};
   	            	
   	            	img_name = "/kr/images/icon/detail.gif";
   	            	
   	            	if("0".equals(sf.getValue("VENDOR_CNT" ,i))) {
   	            		img_name = "";
   	            	} 
   	            	
   	            	String[] img_vendor_cnt = {img_name, sf.getValue("VENDOR_CNT" ,i), sf.getValue("VENDOR_CNT" ,i)};
   	            	
   	            	img_name = "/kr/images/icon/detail.gif";
   	            	img_cnt = sf.getValue("COST_COUNT" ,i);
   	            	if("0".equals(sf.getValue("COST_COUNT" ,i))) {
   	            		img_name = "";  img_cnt ="";
   	            	} 

   	            	String[] img_cost_count = {img_name, img_cnt, sf.getValue("COST_COUNT" ,i)};
   						img_name = "/kr/images/icon/detail.gif";
   	            	if(!"".equals(sf.getValue("TBE_NO" ,i))) {
   	            		desc = "Y";
   	            	} 		
   					String[] img_gisul = { img_name , desc , sf.getValue("TBE_NO" , i)  } ; 

   	        		int iGradeIndex = CommonUtil.getComboIndex(cbo_grade, sf.getValue("TECHNIQUE_GRADE",i));
   	        		int iFlagIndex = CommonUtil.getComboIndex(cbo_flag, sf.getValue("TECHNIQUE_FLAG",i));
   	        		int iTypeIndex = CommonUtil.getComboIndex(cbo_type, sf.getValue("TECHNIQUE_TYPE",i));
   	        		int iDelyIndex = CommonUtil.getComboIndex(cbo_dely, sf.getValue("DELY_TO_LOCATION",i));
   	        		
   					if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
   			    		gdRes.addValue("SELECTED", "0");
   			    	//} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
       	            //	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
   					/*}else if(){
   					}else if(){
   					}else if(){
   					}else if(){
   					}else if(){
   					}else if(){
   					}else if(){*/
   	   			    		
   			    	}else {
   			        	gdRes.addValue(grid_col_ary[k], sf.getValue(grid_col_ary[k], i));
   			        }
   			    	
   				}
   			}
   		    
   		} catch (Exception e) {
   		    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
   			gdRes.setStatus("false");
   	    }
   		
   		return gdRes;
	}
	
	
	/*public void doQuery(SepoaStream ws) throws Exception {
		//get session
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    	String HOUSE_CODE = info.getSession("HOUSE_CODE");
		String mode = ws.getParam("mode");
		
		if(mode.equals("getRfqDTDisplay")) { 
			String rfq_no            	= ws.getParam("rfq_no");
			String rfq_count          	= ws.getParam("rfq_count");
			
			Object[] obj = {rfq_no, rfq_count};
			
            SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqDTDisplay", obj);
            
            SepoaFormater sf = ws.getSepoaFormater(value.result[0]);

            String img_name = "/kr/images/icon/detail.gif";
            String desc = "N" ; 
            
        	SepoaCombo sepoacombo = new SepoaCombo();
        	String cbo_cur[][] = sepoacombo.getCombo(ws.getRequest(), "SL0014", HOUSE_CODE+"#M002", "");
        	String cbo_grade[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M169", "");
        	String cbo_flag[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M181", "");
        	String cbo_type[][] = sepoacombo.getCombo(ws.getRequest(), "SL0018", HOUSE_CODE+"#M170", "");
        	String cbo_dely[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M187", "");
        	
            for(int i=0; i<sf.getRowCount(); i++) { //데이타가 있는 경우
            	
            	String[] img_item_no = {"", sf.getValue("ITEM_NO" ,i), sf.getValue("ITEM_NO" ,i)};
            	String img_cnt = sf.getValue("ATTACH_CNT" ,i);
            	if(sf.getValue("ATTACH_CNT" ,i).equals("0")) {
            		img_name = "";  img_cnt ="";
            	} 
            	String[] img_attach_no = {img_name, img_cnt, sf.getValue("ATTACH_NO" ,i)};
            	
            	img_name = "/kr/images/icon/detail.gif";
            	
            	if(sf.getValue("VENDOR_CNT" ,i).equals("0")) {
            		img_name = "";
            	} 
            	
            	String[] img_vendor_cnt = {img_name, sf.getValue("VENDOR_CNT" ,i), sf.getValue("VENDOR_CNT" ,i)};
            	
            	img_name = "/kr/images/icon/detail.gif";
            	img_cnt = sf.getValue("COST_COUNT" ,i);
            	if(sf.getValue("COST_COUNT" ,i).equals("0")) {
            		img_name = "";  img_cnt ="";
            	} 

            	String[] img_cost_count = {img_name, img_cnt, sf.getValue("COST_COUNT" ,i)};
					img_name = "/kr/images/icon/detail.gif";
            	if(!sf.getValue("TBE_NO" ,i).equals("")) {
            		desc = "Y";
            	} 		
				String[] img_gisul = { img_name , desc , sf.getValue("TBE_NO" , i)  } ; 

        		int iGradeIndex = CommonUtil.getComboIndex(cbo_grade, sf.getValue("TECHNIQUE_GRADE",i));
        		int iFlagIndex = CommonUtil.getComboIndex(cbo_flag, sf.getValue("TECHNIQUE_FLAG",i));
        		int iTypeIndex = CommonUtil.getComboIndex(cbo_type, sf.getValue("TECHNIQUE_TYPE",i));
        		int iDelyIndex = CommonUtil.getComboIndex(cbo_dely, sf.getValue("DELY_TO_LOCATION",i));
        	 
            	ws.addValue("ITEM_NO"             , img_item_no							   , "");      
            	ws.addValue("DESCRIPTION_LOC"     , sf.getValue("DESCRIPTION_LOC	" , i) , "");    
            	ws.addValue("SPECIFICATION"       , sf.getValue("SPECIFICATION      		" , i) , ""); 
            	ws.addValue("MAKER_NAME"       		, sf.getValue("MAKER_NAME      			" , i) , ""); 
            	ws.addValue("MAKER_CODE"       		, sf.getValue("MAKER_CODE      			" , i) , "");  
            	ws.addValue("UNIT_MEASURE"        , sf.getValue("UNIT_MEASURE		" , i) , "");    
            	ws.addValue("RFQ_QTY"             , sf.getValue("RFQ_QTY			" , i) , "");     
        		ws.addValue("CUR"                 , sf.getValue("CUR				" , i) , ""); 
        		    
            	ws.addValue("PURCHASE_PRE_PRICE"  , sf.getValue("PURCHASE_PRE_PRICE " , i) , "");      
            	ws.addValue("RFQ_AMT"             , sf.getValue("RFQ_AMT			" , i) , "");      
            	ws.addValue("RD_DATE"             , sf.getValue("RD_DATE			" , i) , "");    
            	ws.addValue("DELY_TO_ADDRESS"     , sf.getValue("DELY_TO_ADDRESS			" , i) , "");      
            	ws.addValue("WARRANTY"            , sf.getValue("WARRANTY			" , i) , "");    
            	
            	ws.addValue("ATTACH_NO"           , img_attach_no 						   , "");      
            	ws.addValue("VENDOR_CNT"          , img_vendor_cnt 						   , ""); 	
            	ws.addValue("REC_VENDOR_NAME"     , sf.getValue("REC_VENDOR_NAME    " , i) , "");
            	
            	if( sf.getValue("BID_REQ_TYPE" , i).equals("I"))ws.addValue("DELY_TO_LOCATION"    , cbo_dely  , "" , iDelyIndex);
            	else ws.addValue("DELY_TO_LOCATION"    , sf.getValue("DELY_TO_LOCATION				" , i) , ""); 
            	
            	ws.addValue("COST_COUNT"          , img_cost_count 						   , "");   
            	ws.addValue("REMARK" 			  , sf.getValue("Z_REMARK			" , i) , "");
            	         
            	ws.addValue("YEAR_QTY"            , sf.getValue("YEAR_QTY			" , i) , "");      
            	ws.addValue("GISUL_RFQ"           , img_gisul							   , "");   
            	ws.addValue("PLANT_CODE"          , sf.getValue("PLANT_CODE			" , i) , "");         
            	ws.addValue("PR_CHANGE_USER_NAME" , sf.getValue("PR_CHANGE_USER_NAME" , i) , "");     
            	ws.addValue("PR_NO"               , sf.getValue("PR_NO				" , i) , "");     
            	ws.addValue("PR_SEQ"              , sf.getValue("PR_SEQ				" , i) , "");     
            	ws.addValue("PURCHASE_LOCATION"   , sf.getValue("PURCHASE_LOCATION	" , i) , "");     
            	ws.addValue("CTRL_CODE"           , sf.getValue("CTRL_CODE			" , i) , "");     
            	ws.addValue("RFQ_SEQ"             , sf.getValue("RFQ_SEQ			" , i) , "");
            	ws.addValue("PROJECT_NAME"        , sf.getValue("PROJECT_NAME		" , i) , "");
  
	        	ws.addValue("TECHNIQUE_GRADE"       , cbo_grade , "" , iGradeIndex);
	        	ws.addValue("TECHNIQUE_FLAG"        , cbo_flag  , "" , iFlagIndex);
	        	ws.addValue("TECHNIQUE_TYPE"        , cbo_type  , "" , iTypeIndex);
				ws.addValue("INPUT_FROM_DATE"    	, sf.getValue("INPUT_FROM_DATE	" ,	i), "");
				ws.addValue("INPUT_TO_DATE"    		, sf.getValue("INPUT_TO_DATE	" ,	i), ""); 
				ws.addValue("HUMAN_NAME_LOC"    	, sf.getValue("HUMAN_NAME_LOC	" ,	i), "");
            }
            ws.setMessage(value.message);
            ws.write();
		}
	}*/
}

	
