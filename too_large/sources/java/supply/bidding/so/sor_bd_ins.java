package supply.bidding.so;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import com.icompia.util.CommonUtil;

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

public class sor_bd_ins extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
 
    public void init(ServletConfig config) throws ServletException{Logger.debug.println();}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
        doPost(req, res);
    }
    
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
	        
	    SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);
	 
	    GridData gdReq = null;
	    GridData gdRes = new GridData();
	    req.setCharacterEncoding("UTF-8");
	    res.setContentType("text/html;charset=UTF-8");
	 
	    String mode = "";
	    PrintWriter out = res.getWriter();
	    
	    try{
	        
	        gdReq = OperateGridData.parse(req, res);
	        mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
	 
	            if ("getSoslnList".equals(mode)){                				// 실사서 입력대행 품목 조회
	                gdRes = getSoslnList(gdReq,info);
	            }else if("setSorInsert".equals(mode)){                           // 실사서 입력 대행 입력
	                gdRes = setSorInsert(gdReq, info);
	            }else if("setSorUpdate".equals(mode)){                           // 실사서 입력 대행 수정
	                gdRes = setSorUpdate(gdReq, info);
	            }
	            
	                
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

	/**
	 * 실사서 등록 
	 * getSoslnList
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-11-07
	 * @modify 2014-11-07
	 */
	@SuppressWarnings("unchecked")
	private GridData setSorInsert(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData                  gdRes           = new GridData();
	    HashMap                   message         = null;
	    SepoaOut                  value           = null;
	    Map<String, Object>       data            = null;
	    Map<String, String>       header          = null;
	    Map<String, String>       gridInfo        = null;
	    
	    Vector                    multilangId     = new Vector();
	    multilangId.addElement("MESSAGE");
	    message = MessageUtil.getMessage(info, multilangId);
	    
	    List<Map<String, String>> chkCreateData   = new ArrayList<Map<String, String>>();
	    
	    List<Map<String, String>> orlnData        = new ArrayList<Map<String, String>>();   //실사서 상세
	    List<Map<String, String>> orglData        = new ArrayList<Map<String, String>>();	//실사서 

	    List<Map<String, String>> oslnData        = new ArrayList<Map<String, String>>();									//실사요청상세
//	    List<Map<String, String>> osseData        = new ArrayList<Map<String, String>>();									//실사대상업체정보									
	    
	    List<Map<String, String>> osln_data      = null;
	    List<Map<String, String>> osse_data      = null;
	    
	    //List<Map<String, String>> rqepData        = new ArrayList<Map<String, String>>();	//원가정보
	    //List<Map<String, String>> rqpfData        = null;
	    
	    //List<Map<String, String>> qtepData        = null;									//실사단가
	    
	    Map<String, Object> paramData             = new HashMap<String, Object>();
	    
	   
	   
	        try {
	            gdRes        = OperateGridData.cloneResponseGridData(gdReq);
	            gdRes.addParam("mode", "doSave");
	            gdRes.setSelectable(false);
	            
	            data                        = SepoaDataMapper.getData(info, gdReq);
	            header                      = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
	            
	            //this.sysOutMap(data);
	            
	            String HOUSE_CODE           = info.getSession("HOUSE_CODE");

	            String SEND_FLAG            = header.get("send_flag");				//실사서 작성:N 제출:Y
	            String NET_AMT              = "0";//header.get("NET_AMT");
	            
	            String TTL_CHARGE           = header.get("ttl_charge");
	            String VENDOR_CODE          = header.get("vendor_code");
	            String SUBJECT              = header.get("subject");
	            String OSQ_NO               = header.get("osq_no");
	            String OSQ_COUNT            = header.get("osq_count");
	            String PAY_TERMS            = header.get("pay_terms");
	            
	            String COMPANY_CODE         = header.get("company_code");
	            String REMARK               = header.get("remark");
	            String OSQ_VAL_DATE         = header.get("osq_val_date");
	            String BID_REQ_TYPE         = header.get("bid_req_type");
	            String OSQ_ATTACH_NO      = header.get("osq_attach_no");
	            String real_pr_no      = header.get("real_pr_no");
	            
	            //다시 넣은 데이터를 soln sose데이터를 조합한다.
	            osln_data      = this.createOsObjGrid(gdReq, info, OSQ_NO, OSQ_COUNT, real_pr_no);
	    		osse_data     = this.createOsObjSosseData(gdReq, info, OSQ_NO);
	    		
	            Map<String, Object>       param   = null;
	            List<Map<String, String>> grid    = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	            int i                             = 0;
	            
	            long longTtlAmt                    = 0;

//	            int tmpQtepCnt = 0;
//	            int tmpRqepCnt = 0;
//	            int tmpRqpfCnt = 0;
	            
	            String doc_type = "OR";																			  // 실사서 QT
	            String seqSorNo = header.get("real_or_no"); //OR번호 설정
	           /* paramData.put("orglData"        , orglData);
	            paramData.put("orlnData"        , orlnData);
	            paramData.put("oslnData"        , oslnData);
	            paramData.put("osseData"        , osseData);*/
	            //for start
//	            for(i = 0; i < grid.size(); i++){
//	                //servletParam = new HashMap<String, Object>();
//	                
//	                gridInfo                   = grid.get(i);
//	                
//	                StringTokenizer st = new StringTokenizer(gridInfo.get("EP_UNIT_PRICE"),"##");  
//	                int st_cnt = st.countTokens();     
//	                
//	                for(int y=0; y<st_cnt; y++)  
//	                {  
//	                    tmpQtepCnt++;
//	                }
//	                
//	                if(gridInfo.get("PRICE_DOC").indexOf("$") > 0)  
//	                {  
//	                    StringTokenizer stoken1 = new StringTokenizer(gridInfo.get("PRICE_DOC"),"$");  
//	                    int stoken_cnt1 = stoken1.countTokens();  
//	    
//	                    for(int a=0; a<stoken_cnt1; a++)  
//	                    {  
//	                        tmpRqepCnt++;
//	                    }
//	                }
//	                if(gridInfo.get("ATTACH_NO").indexOf("$") > 0)  
//	                {  
//	                    StringTokenizer stoken1 = new StringTokenizer(gridInfo.get("ATTACH_NO"),"$");  
//	                    int stoken_cnt1 = stoken1.countTokens()/6;  
//	    
//	                    for(int a=0; a<stoken_cnt1; a++)  
//	                    {  
//	                        tmpRqpfCnt++;
//	                    }
//	                }   
//	            }
	            //for end
	            
	            //String qtepData[][] = new String[tmpQtepCnt][];
	            //String rqepData[][] = new String[tmpRqepCnt][];
	            //String rqpfData[][] = new String[tmpRqpfCnt][];
	            
	            String insert_flag = "Y";
	            //OR번호가 없으면 채번한다.
	            if(seqSorNo.length() == 0 || "".equals(seqSorNo)) {
	            	seqSorNo = this.setSorInsertOrNo(info, doc_type);                     //실사서번호 SEQ 생성 SORGL.OSQ_NO
	            } else {
	            	insert_flag = "N";
	            }
	            Logger.err.println("insert_flag================"+insert_flag);
//	            int insCntQtep = 0;
//	            int insCntRqep = 0;
//	            int insCntQtpf = 0;
	            
	            Map<String, String> tmp_chkCreateData = null;
	            
	            //for start
	            for(i = 0; i < grid.size(); i++){
	                
	            	tmp_chkCreateData = new HashMap<String, String>();
	                gridInfo                   = grid.get(i);
	                
//	                ITEM_AMT
	                
	                longTtlAmt += Long.parseLong( gridInfo.get("ITEM_AMT") );
	            
	                /*String[] tmp_chkdata = {OSQ_NO,OSQ_COUNT,OSQ_SEQ[i]};
	                chkCreateData[i] = tmp_chkdata;*/
	                                
	                tmp_chkCreateData.put("osq_no", 		OSQ_NO);
	                tmp_chkCreateData.put("osq_count", 		OSQ_COUNT);
	                tmp_chkCreateData.put("osq_seq", 		gridInfo.get("OSQ_SEQ"));
	                
	                
	                
	                chkCreateData.add(tmp_chkCreateData);
	               
	                
	                
	                
//	                String tmp_MOLDING_FLAG = "N";
//	                if(Double.parseDouble(JSPUtil.nullToRef(gridInfo.get("MOLDING_CHARGE"), "0")) > 0) {
//	                    tmp_MOLDING_FLAG = "Y";
//	                }
	                
	                /*if(BID_REQ_TYPE.equals("S")){       //입찰구분(S, I)  WORK 예정
	                
	                    StringTokenizer st_1 = new StringTokenizer(gridInfo.get("ATTACH_NO"),"$");  
	                    int st_cnt_1 = st_1.countTokens()/5;  
	                    
	                    Logger.debug.println(info.getSession("ID"),this,"st_cnt_1 ==============>" + st_cnt_1);
	                    
	                    rqpfData = this.setOrInsertRqpfData(info, gridInfo, seqSorNo, st_1, st_cnt_1, OSQ_NO, OSQ_COUNT, VENDOR_CODE);																					//실사......I DON'T NO           
	                
	                    gridInfo.put("ATTACH_NO","SO");          
	                }*/
	                
	                //String item_amt = gridInfo.get("ITEM_AMT");
	                
	                
	                
//	                if ((item_amt == null) || (item_amt.equals("")) || (Float.parseFloat(item_amt) == 0)) {
////	                  item_amt = gridInfo.get("UNIT_PRICE");
//	                    item_amt = gridInfo.get("OSQ_QTY");
//	                }
	                
	               // System.out.println("system.out:426=>"+NET_AMT+"|"+item_amt);

	                //NET_AMT = String.valueOf(Double.parseDouble(NET_AMT) + Double.parseDouble(item_amt));
	                
	               // System.out.println("system.out:430=>"+NET_AMT);
	                
	                
	                orlnData    = this.setOrInsertOrlnData(info, gridInfo, OSQ_NO, OSQ_COUNT, seqSorNo, VENDOR_CODE, i, orlnData);   //실사서 상세정보 ICOYQTDT
	                
	                
	                oslnData    = this.setOrInsertOslnData(info, gridInfo, OSQ_NO, OSQ_COUNT, oslnData, real_pr_no);                             //실사의뢰 상세정보 ICOYRQDT
	                
	                
//	                osseData    = this.setOrInsertOsseData(info, gridInfo, OSQ_NO, OSQ_COUNT, VENDOR_CODE);                          // 실사의뢰 대상업체 정보 ICOYRQSE
	                
	            }   //end for   

	            orglData = setOrInsertOrglData(info, gridInfo, OSQ_NO, OSQ_COUNT, seqSorNo, OSQ_VAL_DATE, SEND_FLAG, REMARK, TTL_CHARGE, OSQ_ATTACH_NO, VENDOR_CODE, real_pr_no, longTtlAmt);   //실사서 정보 SORGL
	            
	            
	           /* Object[] obj = {OSQ_NO, OSQ_COUNT, seqSorNo, chkCreateData, orglData
	            		, orlnData , oslnData, osseData, qtepData, rqepData, rqpfData};*/
	                            
	            paramData.put("SEND_FLAG"       , SEND_FLAG);
	            paramData.put("OSQ_NO"          , OSQ_NO);
	            paramData.put("OSQ_COUNT"       , OSQ_COUNT);	           	           
	            paramData.put("seqSorNo"        , seqSorNo);
	            paramData.put("VENDOR_CODE"       , VENDOR_CODE);	            
	            paramData.put("chkCreateData"   , chkCreateData);
	            paramData.put("orglData"        , orglData);
	            paramData.put("orlnData"        , orlnData);
	            paramData.put("oslnData"        , oslnData);
//	            paramData.put("osseData"        , osseData);
	            //os 쪽으로 넣을 데이터를 param에 추가한다.
	            paramData.put("osln_data"        , osln_data);
	            paramData.put("osse_data"        , osse_data);
//	            paramData.put("qtepData"        , qtepData);
//	            paramData.put("rqepData"        , rqepData);
//	            paramData.put("rqpfData"        , rqpfData);
	            
	            Object[] obj = {paramData, insert_flag};
	            value = ServiceConnector.doService(info, "s2041", "TRANSACTION", "setOrInsert", obj);

	            
	            if(value.flag) {
	                //gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            	gdRes.setMessage("실사작성번호  "+OSQ_NO+" 로 저장되었습니다."); 
	            	gdRes.setStatus("true");
	                
	            }
	            else {
	                gdRes.setMessage(value.message);
	                gdRes.setStatus("false");
	            }
	        
	            
	                
	            //===============================================================
	            
	            
	            /*if(""..equals(iSzdate) == false){
	                rqandata = this.setRfqCreateRqandata(info, rfqNo, iSzdate, header, rqandata);
	            }
	            
	            svcParam.put("pflag",       header.get("I_PFLAG"));
	            svcParam.put("create_type", iCreateType);
	            svcParam.put("osq_flag",    iRfgFlag);
	            svcParam.put("osq_type",    header.get("I_OSQ_TYPE"));
	            svcParam.put("osq_no",      rfqNo);
	            svcParam.put("prhddata",    prhddata);
	            svcParam.put("rqhddata",    rqhddata);
	            svcParam.put("rqandata",    rqandata);
	            
	            Object[] obj = {svcParam};
	            
	            value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRfqCreate", obj);
	            gdRes = this.setRfqCreateGdRes(value, message);*/
	        }
	        catch(Exception e){
	            
	        	gdRes = new GridData();
	            
	            gdRes.setMessage(message.get("MESSAGE.1002").toString());
	            gdRes.setStatus("false");
	        }
	        
	        return gdRes;
	}
	
    @SuppressWarnings({ "unchecked" })
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
    	return result;
    }
	private List<Map<String, String>> createOsObjGrid(GridData gdReq, SepoaInfo info, String osqNo, String  osqCount, String real_pr_no) throws Exception{
		List<Map<String, String>> result          = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid            = this.getGrid(gdReq, info);
		Map<String, String>       gridDataInfo    = null;
		Map<String, String>       gridInfo        = null;
		String                    id              = info.getSession("ID");
		String                    rdDate          = null;
		String                    osqSeq          = null;
		String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
		int                       gridSize        = grid.size();
		int                       i               = 0;
		
//		System.out.println("real_pr_no===="+real_pr_no);
		
		for(i = 0; i < gridSize; i++){
			gridDataInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			rdDate   = gridInfo.get("RD_DATE");
			rdDate   = rdDate.replaceAll("/", "");
			osqSeq   = Integer.toString(i + 1);
			
			gridDataInfo.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
			gridDataInfo.put("OSQ_NO",              osqNo);
			gridDataInfo.put("OSQ_COUNT",        osqCount);
			gridDataInfo.put("OSQ_SEQ",             osqSeq);
			gridDataInfo.put("STATUS",              "C");
			gridDataInfo.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
			gridDataInfo.put("PLANT_CODE",          "");
			gridDataInfo.put("OSQ_PROCEEDING_FLAG", "N");
			gridDataInfo.put("ADD_DATE",            shortDateString);
			gridDataInfo.put("ADD_TIME",            shortTimeString);
			gridDataInfo.put("ADD_USER_ID",         id);
			gridDataInfo.put("CHANGE_DATE",         shortDateString);
			gridDataInfo.put("CHANGE_TIME",         shortTimeString);
			gridDataInfo.put("CHANGE_USER_ID",      id);
			gridDataInfo.put("ITEM_NO",             gridInfo.get("ITEM_NO"));
			gridDataInfo.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
			gridDataInfo.put("RD_DATE",             rdDate);
			gridDataInfo.put("VALID_FROM_DATE",     "");
			gridDataInfo.put("VALID_TO_DATE",       "");
			gridDataInfo.put("PURCHASE_PRE_PRICE",  "");
			gridDataInfo.put("OSQ_QTY",             gridInfo.get("ITEM_QTY"));
			gridDataInfo.put("OSQ_AMT",             gridInfo.get("UNIT_PRICE"));
			gridDataInfo.put("BID_COUNT",           "0");
			gridDataInfo.put("CUR",                 "");
			gridDataInfo.put("PR_NO",               gridInfo.get("PR_NO"));
			gridDataInfo.put("PR_SEQ",              gridInfo.get("PR_SEQ"));
			gridDataInfo.put("SETTLE_FLAG",         "N");
			gridDataInfo.put("SETTLE_QTY",          "0");
			gridDataInfo.put("TBE_FLAG",            "");
			gridDataInfo.put("TBE_DEPT",            "");
			gridDataInfo.put("PRICE_TYPE",          "");
			gridDataInfo.put("TBE_PROCEEDING_FLAG", "");
			gridDataInfo.put("SAMPLE_FLAG",         "");
			gridDataInfo.put("DELY_TO_LOCATION",    "");
			gridDataInfo.put("ATTACH_NO",           gridInfo.get("ATTACH_NO"));
			gridDataInfo.put("SHIPPER_TYPE",        "");
			gridDataInfo.put("CONTRACT_FLAG",       "");
			gridDataInfo.put("COST_COUNT",          "");
			gridDataInfo.put("YEAR_QTY",            "");
			gridDataInfo.put("DELY_TO_ADDRESS",     gridInfo.get("DELY_TO_LOCATION"));
			gridDataInfo.put("MIN_PRICE",           "0");
			gridDataInfo.put("MAX_PRICE",           "0");
			gridDataInfo.put("STR_FLAG",            "");
			gridDataInfo.put("TBE_NO",              "");
			gridDataInfo.put("Z_REMARK",            gridInfo.get("REMARK"));
			gridDataInfo.put("TECHNIQUE_GRADE",     "");
			gridDataInfo.put("TECHNIQUE_TYPE",      "");
			gridDataInfo.put("INPUT_FROM_DATE",     "");
			gridDataInfo.put("INPUT_TO_DATE",       "");
			gridDataInfo.put("TECHNIQUE_FLAG",      "");
			gridDataInfo.put("SPECIFICATION",       gridInfo.get("SPECIFICATION"));
			gridDataInfo.put("MAKER_NAME",          "");
			gridDataInfo.put("MAKE_AMT_CODE",       gridInfo.get("MAKE_AMT_CODE"));
			gridDataInfo.put("P_ITEM_NO",       gridInfo.get("P_ITEM_NO"));
			gridDataInfo.put("REAL_PR_NO",       real_pr_no);
			gridDataInfo.put("DELY_TO_DEPT",       gridInfo.get("DELY_TO_DEPT"));
			
			gridDataInfo.put("P_SEQ",       gridInfo.get("P_SEQ"));
			gridDataInfo.put("WID",       gridInfo.get("WID"));
			gridDataInfo.put("HGT",       gridInfo.get("HGT"));
			
			result.add(gridDataInfo);
		}
		
		return result;
	}
	
	private List<Map<String, String>> createOsObjSosseData(GridData gdReq, SepoaInfo info, String osqNo) throws Exception{
		List<Map<String, String>> result      = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid        = this.getGrid(gdReq, info);
		Map<String, String>       gridInfo    = null;
		Map<String, String>       resultInfo  = null;
		String                    houseCode   = info.getSession("HOUSE_CODE");
		String                    id          = info.getSession("ID");
		String                    companyCode = info.getSession("COMPANY_CODE");
		String                    osqSeq      = null;
		String                    vendorCode  = null;
		int                       gridSize    = grid.size();
		int                       i           = 0;
		
		for(i = 0; i < gridSize; i++){
			resultInfo = new HashMap<String, String>();
			
			gridInfo   = grid.get(i);
			vendorCode = gridInfo.get("VENDOR_CODE");
			osqSeq     = Integer.toString(i + 1);
			
			resultInfo.put("HOUSE_CODE",   houseCode);
			resultInfo.put("OSQ_NO",       osqNo);
			resultInfo.put("OSQ_COUNT",    "1");
			resultInfo.put("OSQ_SEQ",      osqSeq);
//			resultInfo.put("VENDOR_CODE",  id);
//          C202212160016[2022-12-19] (은행)전자구매 실사서 제출 개선 			
			resultInfo.put("VENDOR_CODE",  companyCode);
			resultInfo.put("STATUS",       "C");
			resultInfo.put("COMPANY_CODE", companyCode);
			resultInfo.put("CONFIRM_FLAG", "S");
			resultInfo.put("ADD_USER_ID",  id);
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	/**
	 * 실사서 수정 
	 * getSoslnList
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-11-07
	 * @modify 2014-11-07
	 */
	private GridData setSorUpdate(GridData gdReq, SepoaInfo info) throws Exception {
			    GridData                  gdRes           = new GridData();
			    HashMap                   message         = null;
			    SepoaOut                  value           = null;
			    Map<String, Object>       data            = null;
			    Map<String, String>       header          = null;
			    Map<String, String>       gridInfo        = null;
			    
			    Vector                    multilangId     = new Vector();
			    multilangId.addElement("MESSAGE");
			    message = MessageUtil.getMessage(info, multilangId);
			    
			    List<Map<String, String>> chkCreateData   = new ArrayList<Map<String, String>>();
			    
			    //List<Map<String, String>> del_orlnData    = new ArrayList<Map<String, String>>();                                   //실사서 상세(삭제용) 삭제가 없으므로 사용할 필요 없음.
			    List<Map<String, String>> orlnData        = new ArrayList<Map<String, String>>();                                   //실사서 상세
			    List<Map<String, String>> orglData        = new ArrayList<Map<String, String>>();	                                //실사서 

			    List<Map<String, String>> oslnData        = new ArrayList<Map<String, String>>();									//실사요청상세
			    List<Map<String, String>> osseData        = new ArrayList<Map<String, String>>();									//실사대상업체정보									
			   
			    Map<String, Object> paramData             = new HashMap<String, Object>();
			   
			        try {
			            gdRes        = OperateGridData.cloneResponseGridData(gdReq);
			            gdRes.addParam("mode", "doSave");
			            gdRes.setSelectable(false);
			            
			            data                        = SepoaDataMapper.getData(info, gdReq);
			            header                      = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
			            
			            //this.sysOutMap(data);
			            
			            
			            String HOUSE_CODE           = info.getSession("HOUSE_CODE");

			            String SEND_FLAG            = header.get("send_flag");				//실사서 작성:N 제출:Y
			            String NET_AMT              = "0";//header.get("NET_AMT");
			            
			            String TTL_CHARGE           = header.get("ttl_charge");
			            String VENDOR_CODE          = header.get("vendor_code");
			            String SUBJECT              = header.get("subject");
			            String OSQ_NO               = header.get("osq_no");
			            String OSQ_COUNT            = header.get("osq_count");
			            String PAY_TERMS            = header.get("pay_terms");
			            
			            String COMPANY_CODE         = header.get("company_code");
			            String REMARK               = header.get("remark");
			            String OSQ_VAL_DATE         = header.get("osq_val_date");
			            String BID_REQ_TYPE         = header.get("bid_req_type");
			            String OSQ_ATTACH_NO        = header.get("osq_attach_no");
			            String real_pr_no        = header.get("real_pr_no");

			            
			            Map<String, Object>       param   = null;
			            List<Map<String, String>> grid    = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			            int i                             = 0;


			            int tmpQtepCnt = 0;
			            int tmpRqepCnt = 0;
			            int tmpRqpfCnt = 0;
			            
			            String doc_type = "OR";																			  // 실사서 QT
			            String seqSorNo                      = "";   									                   //실사서번호 SEQ 생성 SORGL.OSQ_NO
			            
			            long longTtlAmt                    = 0;
			           
			            
			            //for start
			            for(i = 0; i < grid.size(); i++){
			                
			                gridInfo                   = grid.get(i);
			               
			                seqSorNo				   = gridInfo.get("OR_NO");		//그리드에서 OR_NO값을 가져온다.
			                
			                StringTokenizer st = new StringTokenizer(gridInfo.get("EP_UNIT_PRICE"),"##");  
			                int st_cnt = st.countTokens();     
			                
			                for(int y=0; y<st_cnt; y++)  
			                {  
			                    tmpQtepCnt++;
			                }
			                
			                if(gridInfo.get("PRICE_DOC").indexOf("$") > 0)  
			                {  
			                    StringTokenizer stoken1 = new StringTokenizer(gridInfo.get("PRICE_DOC"),"$");  
			                    int stoken_cnt1 = stoken1.countTokens();  
			    
			                    for(int a=0; a<stoken_cnt1; a++)  
			                    {  
			                        tmpRqepCnt++;
			                    }
			                }
			                if(gridInfo.get("ATTACH_NO").indexOf("$") > 0)  
			                {  
			                    StringTokenizer stoken1 = new StringTokenizer(gridInfo.get("ATTACH_NO"),"$");  
			                    int stoken_cnt1 = stoken1.countTokens()/6;  
			    
			                    for(int a=0; a<stoken_cnt1; a++)  
			                    {  
			                        tmpRqpfCnt++;
			                    }
			                }   
			            }
			            //for end
			            
			            Map<String, String> tmp_chkCreateData = null;
			            
			            //for start
			            for(i = 0; i < grid.size(); i++){
			                
			            	tmp_chkCreateData = new HashMap<String, String>();
			                gridInfo                   = grid.get(i);
			                
			                longTtlAmt += Long.parseLong( gridInfo.get("ITEM_AMT") );
			            
			                /*String[] tmp_chkdata = {OSQ_NO,OSQ_COUNT,OSQ_SEQ[i]};
			                chkCreateData[i] = tmp_chkdata;*/
			                                
			                tmp_chkCreateData.put("osq_no", 		OSQ_NO);
			                tmp_chkCreateData.put("osq_count", 		OSQ_COUNT);
			                tmp_chkCreateData.put("osq_seq", 		gridInfo.get("OSQ_SEQ"));
			                
			                chkCreateData.add(tmp_chkCreateData);
			               
			                
			                orlnData    = this.setOrInsertOrlnData(info, gridInfo, OSQ_NO, OSQ_COUNT, seqSorNo, VENDOR_CODE, i, orlnData);   //실사서 상세정보 ICOYQTDT
			                
			                
			                oslnData    = this.setOrInsertOslnData(info, gridInfo, OSQ_NO, OSQ_COUNT, oslnData, real_pr_no);                             //실사의뢰 상세정보 ICOYRQDT
			                
			                
			                osseData    = this.setOrInsertOsseData(info, gridInfo, OSQ_NO, OSQ_COUNT, VENDOR_CODE);                          // 실사의뢰 대상업체 정보 ICOYRQSE
			                
			            }   //end for   
			                            
			            

			            orglData = setOrInsertOrglData(info, gridInfo, OSQ_NO, OSQ_COUNT, seqSorNo, OSQ_VAL_DATE, SEND_FLAG, REMARK, TTL_CHARGE, OSQ_ATTACH_NO, VENDOR_CODE, real_pr_no, longTtlAmt);   //실사서 정보 SORGL
			            
			            
			           /* Object[] obj = {OSQ_NO, OSQ_COUNT, seqSorNo, chkCreateData, orglData
			            		, orlnData , oslnData, osseData, qtepData, rqepData, rqpfData};*/
			                            
			            paramData.put("SEND_FLAG"       , SEND_FLAG);
			            paramData.put("OSQ_NO"          , OSQ_NO);
			            paramData.put("OSQ_COUNT"       , OSQ_COUNT);
			            paramData.put("seqSorNo"        , seqSorNo);
			            paramData.put("chkCreateData"   , chkCreateData);
			            paramData.put("orglData"        , orglData);
			            paramData.put("orlnData"        , orlnData);
			            paramData.put("oslnData"        , oslnData);
			            paramData.put("osseData"        , osseData);
//			            paramData.put("qtepData"        , qtepData);
//			            paramData.put("rqepData"        , rqepData);
//			            paramData.put("rqpfData"        , rqpfData);
			            
			            Object[] obj = {paramData};
			            value = ServiceConnector.doService(info, "s2041", "TRANSACTION", "setOrUpdate", obj);

			            
			            if(value.flag) {
			                //gdRes.setMessage(message.get("MESSAGE.0001").toString());
			            	gdRes.setMessage("실사작성번호  "+OSQ_NO+" 로 저장되었습니다."); 
			            	gdRes.setStatus("true");
			                
			            }
			            else {
			                gdRes.setMessage(value.message);
			                gdRes.setStatus("false");
			            }
			        
			            
			                
			            //===============================================================
			            
			            
			            /*if(""..equals(iSzdate) == false){
			                rqandata = this.setRfqCreateRqandata(info, rfqNo, iSzdate, header, rqandata);
			            }
			            
			            svcParam.put("pflag",       header.get("I_PFLAG"));
			            svcParam.put("create_type", iCreateType);
			            svcParam.put("osq_flag",    iRfgFlag);
			            svcParam.put("osq_type",    header.get("I_OSQ_TYPE"));
			            svcParam.put("osq_no",      rfqNo);
			            svcParam.put("prhddata",    prhddata);
			            svcParam.put("rqhddata",    rqhddata);
			            svcParam.put("rqandata",    rqandata);
			            
			            Object[] obj = {svcParam};
			            
			            value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRfqCreate", obj);
			            gdRes = this.setRfqCreateGdRes(value, message);*/
			        }
			        catch(Exception e){
			            
			        	gdRes = new GridData();
			            
			            gdRes.setMessage(message.get("MESSAGE.1002").toString());
			            gdRes.setStatus("false");
			        }
			        
			        return gdRes;
	}


	/**
	 * 실사요청내역조회 
	 * getSoslnList
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-11-07
	 * @modify 2014-11-07
	 */
	private GridData getSoslnList(GridData gdReq, SepoaInfo info) throws Exception {
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
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
            gridColAry = SepoaString.parser(gridColId, ",");
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
    
            gdRes.addParam("mode", "doQuery");
            //Object[] obj = {OSQ_NO, OSQ_COUNT, VENDOR_CODE , GROUP_YN};
            
            Object[] obj = {header};
    
            value = ServiceConnector.doService(info, "s2041", "CONNECTION", "getSoslnList", obj);
            
    
            if(value.flag){// 조회 성공
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
                
                sf= new SepoaFormater(value.result[0]);
                
                rowCount = sf.getRowCount(); // 조회 row 수
                //PR_NO             
        
                if(rowCount == 0){
                    gdRes.setMessage(message.get("MESSAGE.1001").toString());
                }
                else{
                    for (int i = 0; i < rowCount; i++){
                        for(int k=0; k < gridColAry.length; k++){
                            if("SELECTED".equals(gridColAry[k])){
                                gdRes.addValue("SELECTED", "0");
                            }else if("ATTACH_CNT".equals(gridColAry[k])){
                            	
                            	//if(!"".equals(sf.getValue(gridColAry[k], i))){
			    					gdRes.addValue(gridColAry[k], "<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''> " + sf.getValue(gridColAry[k], i));
			    				//}else{
			    				//	gdRes.addValue(gridColAry[k], "");
			    				//}
                            }else{
                                gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
                            }
                                                        
                            /*else if("ITEM_QTY".equals(gridColAry[k])){
                            	
                            	if(!"".equals(sf.getValue("PR_NO", i))){
                            
                            	}else{
			    				}
                            	gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
                            }*/
                            
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

	
	/**
	   * 실사서 입력 일련번호 생성
	   * setSorInsertOrNo
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-11-07
	   * @modify 2014-11-07
	   */
	private String setSorInsertOrNo(SepoaInfo info, String doc_type) {
	    String   result = null;
	    SepoaOut wo     = null;
	        
	    wo    = DocumentUtil.getDocNumber(info, doc_type);
	    result = wo.result[0];
	        
	    return result;
	}
	
	
	/**
	   * 실사서
	   * setOrInsertOrlnData
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setOrInsertOrlnData(SepoaInfo info, Map<String, String> gridInfo, String OSQ_NO, String OSQ_COUNT, String seqSorNo, String VENDOR_CODE, int i, List<Map<String, String>> orlnData) throws Exception{
	    //List<Map<String, String>> orlnData        = (List<Map<String, String>>)paramData.get("orlnData");
	    Map<String, String>       tmp_orlnData     = new HashMap<String, String>();
	    String                    id               = info.getSession("ID");
	    //int                       i                = 0;                                     
	    
	    tmp_orlnData.put("HOUSE_CODE"                           , info.getSession("HOUSE_CODE"));
	    tmp_orlnData.put("VENDOR_CODE"                          , VENDOR_CODE);    
	    tmp_orlnData.put("OR_NO"                                , seqSorNo);         
	    tmp_orlnData.put("OR_SEQ"                               , String.valueOf(i + 1));        
	    tmp_orlnData.put("STATUS"                               , "C");         
	    tmp_orlnData.put("COMPANY_CODE"                         , gridInfo.get("VENDOR_CODE"));   
	    tmp_orlnData.put("OSQ_NO"                               , OSQ_NO);         
	    tmp_orlnData.put("OSQ_COUNT"                            , OSQ_COUNT);      
	    tmp_orlnData.put("OSQ_SEQ"                              , gridInfo.get("OSQ_SEQ"));        
	    tmp_orlnData.put("ITEM_NO"                              , gridInfo.get("ITEM_NO"));        
	    tmp_orlnData.put("VENDOR_ITEM_NO"                       , gridInfo.get("VENDOR_ITEM_NO"));
	    tmp_orlnData.put("UNIT_MEASURE"                         , gridInfo.get("UNIT_MEASURE"));   					//단위
	    tmp_orlnData.put("UNIT_PRICE"                           , gridInfo.get("UNIT_PRICE"));     
	    tmp_orlnData.put("ITEM_QTY"                             , gridInfo.get("ITEM_QTY"));       
	    tmp_orlnData.put("ITEM_AMT"                             , gridInfo.get("ITEM_AMT"));     					//금액  
	    tmp_orlnData.put("DISCOUNT"                             , gridInfo.get("DISCOUNT"));    
	    tmp_orlnData.put("MAKER_CODE"                           , gridInfo.get("MAKER_CODE")     );
	    tmp_orlnData.put("MAKER_NAME"                           , gridInfo.get("MAKER_NAME"));     
	    tmp_orlnData.put("DELIVERY_LT"                          , gridInfo.get("DELIVERY_LT").replaceAll("/", "").replaceAll("-", ""));    
	    tmp_orlnData.put("DELY_TO_LOCATION"                     , gridInfo.get("DELY_TO_LOCATION"));    
	    tmp_orlnData.put("MOLDING_CHARGE"                       , gridInfo.get("MOLDING_CHARGE"));
	    tmp_orlnData.put("ATTACH_NO"                            , gridInfo.get("ATTACH_NO"));      
//	    tmp_orlnData.put("MOLDING_FLAG"                         , tmp_MPLDING_FLAG);   
	    tmp_orlnData.put("ADD_DATE"                             , SepoaDate.getShortDateString());       
	    tmp_orlnData.put("ADD_TIME"                             , SepoaDate.getShortTimeString());       
	    tmp_orlnData.put("ADD_USER_ID"                          , info.getSession("ID"));    
	    tmp_orlnData.put("CHANGE_DATE"                          , SepoaDate.getShortDateString());    
	    tmp_orlnData.put("CHANGE_TIME"                          , SepoaDate.getShortTimeString());    
	    tmp_orlnData.put("CHANGE_USER_ID"                       , info.getSession("ID"));
//	    tmp_orlnData.put("MOLDING_PROSPECTIVE_QTY"              , gridInfo.get("MOLDING_PROSPECTIVE_QTY"));
	    tmp_orlnData.put("DT_REMAKR"                            , gridInfo.get("DT_REMAKR"));
	    tmp_orlnData.put("CUSTOMER_PRICE"                       , gridInfo.get("CUSTOMER_PRICE"));
	    tmp_orlnData.put("HUMAN_NO"                             , gridInfo.get("HUMAN_NO"));
	    //tmp_orlnData.put("TECHNIQUE_GRADE"                      , gridInfo.get("TECHNIQUE_GRADE"));
	    tmp_orlnData.put("INPUT_FROM_DATE"                      , gridInfo.get("INPUT_FROM_DATE"));
	    tmp_orlnData.put("INPUT_TO_DATE"                        , gridInfo.get("INPUT_TO_DATE"));
	    tmp_orlnData.put("RATE"                                 , gridInfo.get("RATE"));
	    tmp_orlnData.put("SEC_VENDOR_CODE"                      , gridInfo.get("SEC_VENDOR_CODE"));
	    tmp_orlnData.put("ITEM_WIDTH"                      		, gridInfo.get("ITEM_WIDTH"));				//가로
	    tmp_orlnData.put("ITEM_HEIGHT"                      	, gridInfo.get("ITEM_HEIGHT"));				//세로
	    tmp_orlnData.put("MAKE_AMT_CODE"                      	, gridInfo.get("MAKE_AMT_CODE"));			//결정코드
	    
	    
	    
	    orlnData.add(tmp_orlnData);    
	        
	    return orlnData;
	}
	
	
	/**
	   * 실사의뢰 상세정보
	   * setOrInsertOslnData
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setOrInsertOslnData(SepoaInfo info, Map<String, String> gridInfo, String OSQ_NO, String OSQ_COUNT, List<Map<String, String>> oslnData, String real_pr_no) throws Exception{
	    //List<Map<String, String>> oslnData        = (List<Map<String, String>>)paramData.get("oslnData");
	    Map<String, String>       tmp_oslnData     = new HashMap<String, String>();
	    
	    tmp_oslnData.put("HOUSE_CODE"                           , info.getSession("HOUSE_CODE"));
	    tmp_oslnData.put("OSQ_NO"                               , OSQ_NO);         
	    tmp_oslnData.put("OSQ_COUNT"                            , OSQ_COUNT);      
	    tmp_oslnData.put("OSQ_SEQ"                              , gridInfo.get("OSQ_SEQ"));  
	    tmp_oslnData.put("REAL_PR_NO"                            , real_pr_no);      
	    
	    oslnData.add(tmp_oslnData);
	    
	    return oslnData;
	}
	
	
	
	/**
	   * 실사의뢰 대상업체정보
	   * setOrInsertOsseData
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setOrInsertOsseData(SepoaInfo info, Map<String, String> gridInfo, String OSQ_NO, String OSQ_COUNT, String VENDOR_CODE) {
	    
	    List<Map<String, String>> rqseData        = new ArrayList<Map<String, String>>();
	    Map<String, String>       tmp_rqsedata    = new HashMap<String, String>();
	    
	    tmp_rqsedata.put("HOUSE_CODE"                           , info.getSession("HOUSE_CODE"));
	    tmp_rqsedata.put("VENDOR_CODE"                          , VENDOR_CODE);
	    tmp_rqsedata.put("OSQ_NO"                               , OSQ_NO);         
	    tmp_rqsedata.put("OSQ_COUNT"                            , OSQ_COUNT);      
	    tmp_rqsedata.put("OSQ_SEQ"                              , gridInfo.get("OSQ_SEQ"));  
	    
	    rqseData.add(tmp_rqsedata);
	    
	    return rqseData;
	}
	
	/**
	   * 실사서 상세 
	   * setOrInsertORglData
	   * @param  info, gridInfo, seqSorNo, OR_VAL_DATE, NET_AMT, REMARK, TTL_CHARGE, ATTACH_NO
	   * @return orglData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setOrInsertOrglData(SepoaInfo info, Map<String, String> gridInfo
	                                                    , String OSQ_NO
	                                                    , String OSQ_COUNT
	                                                    , String seqSorNo
	                                                    , String OR_VAL_DATE
	                                                    , String SEND_FLAG
	                                                    , String REMARK
	                                                    , String TTL_CHARGE
	                                                    , String ATTACH_NO
	                                                    , String VENDOR_CODE
	                                                    , String real_pr_no
	                                                    , long longTtlAmt) {
	    
	    List<Map<String, String>> orglData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_orglData   = new HashMap<String, String>();
	
	    tmp_orglData.put("STATUS"                        , "R");
	    tmp_orglData.put("OR_VAL_DATE"                   , OR_VAL_DATE);
	    tmp_orglData.put("SEND_FLAG"                     , SEND_FLAG);
	    tmp_orglData.put("TTL_AMT"                       , String.valueOf( longTtlAmt ));
	    tmp_orglData.put("ADD_DATE"                      , SepoaDate.getShortDateString());
	    tmp_orglData.put("ADD_TIME"                      , SepoaDate.getShortTimeString());  
	    tmp_orglData.put("ADD_USER_ID"                   , info.getSession("ID"));
	    tmp_orglData.put("REMARK"                        , REMARK);
	    tmp_orglData.put("TTL_CHARGE"                    , TTL_CHARGE);
	    tmp_orglData.put("CUR"                           , gridInfo.get("CUR"));                    //CUR    
	    tmp_orglData.put("DEPART_PORT "                  , "");                                     //DEPART_PORT
	    tmp_orglData.put("ARRIVAL_PORT"                  , "");                                     //PAY_TERMS      
	    tmp_orglData.put("USANCE_DAYS"                   , "");                                     //USANCE_DAYS    
	    tmp_orglData.put("DELY_TERMS"                    , "");                                     //DELY_TERMS     
	    tmp_orglData.put("SHIPPING_METHOD"               , "");                                     //SHIPPING_METHOD
	    tmp_orglData.put("PAY_TEXT"                      , "");                                     // pay_text
	    tmp_orglData.put("ATTACH_NO"                     , ATTACH_NO);                        		// attach_no
	    tmp_orglData.put("DEPART_PORT"                   , "");                                     //DEPART_PORT
	    tmp_orglData.put(""                              , info.getSession("COMPANT_CODE"));
	    tmp_orglData.put("ARRIVAL_PORT"                  , "");                                     //ARRIVAL_PORT
	    tmp_orglData.put("HOUSE_CODE"                    , info.getSession("HOUSE_CODE"));
	    tmp_orglData.put("OR_NO"                        , seqSorNo);
	    tmp_orglData.put("VENDOR_CODE"                   , VENDOR_CODE);
	    tmp_orglData.put("OSQ_NO"                        , OSQ_NO);
	    tmp_orglData.put("OSQ_COUNT"                     , OSQ_COUNT);
	    tmp_orglData.put("REAL_PR_NO"                     , real_pr_no);
	            
	    orglData.add(tmp_orglData);
	    
	    return orglData;
	}
}