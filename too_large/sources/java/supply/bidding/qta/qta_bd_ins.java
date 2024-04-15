package supply.bidding.qta;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
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
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.icompia.util.CommonUtil;

public class qta_bd_ins extends HttpServlet {
    
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
	 
	            if ("getQuery_Cre_Qta_Detail".equals(mode)){                // 견적서 품목 조회
	                gdRes = getQuery_Cre_Qta_Detail(gdReq,info);
	            }else if("setQtInsert".equals(mode)){                           // 견적서 입력 
	                gdRes = setQtInsert(gdReq, info);
	            }else if("setQtUpdate".equals(mode)){                           // 견적서 수정
	                //gdRes = setQtUpdate(gdReq, info);
	            	Logger.debug.println();
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
	 * 견적입력 품목 조회
	 * setQtInsert
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private GridData getQuery_Cre_Qta_Detail(GridData gdReq, SepoaInfo info) throws Exception{
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
            //Object[] obj = {RFQ_NO, RFQ_COUNT, VENDOR_CODE , GROUP_YN};
                        
            Object[] obj = {header};
    
            value = ServiceConnector.doService(info, "s2021", "CONNECTION", "getQuery_Cre_Qta_Detail", obj);
            
    
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

/**
 * 견적입력
 * setQtInsert
 * @param  gdReq
 * @param  info
 * @return GridData
 * @throws Exception
 * @since  2014-10-07
 * @modify 2014-10-07
 */
@SuppressWarnings("null")
private GridData setQtInsert(GridData gdReq, SepoaInfo info) throws Exception {
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
    
    List<Map<String, String>> qtdtData        = new ArrayList<Map<String, String>>();
    List<Map<String, String>> qthdData        = new ArrayList<Map<String, String>>();

    List<Map<String, String>> rqdtData        = new ArrayList<Map<String, String>>();
    List<Map<String, String>> rqseData        = new ArrayList<Map<String, String>>();

    List<Map<String, String>> rqepData        = new ArrayList<Map<String, String>>();
    List<Map<String, String>> rqpfData        = new ArrayList<Map<String, String>>();
    
    List<Map<String, String>> qtepData        = new ArrayList<Map<String, String>>();
    
    Map<String, Object> paramData             = new HashMap<String, Object>();
   
    
    
    
        try {
            gdRes        = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "doSave");
            gdRes.setSelectable(false);
            
            data                        = SepoaDataMapper.getData(info, gdReq);
            header                      = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
            
            //iRfgFlag    = header.get("I_RFQ_FLAG");
            
            
            
            //this.sysOutMap(data);
            
            
            String SEND_FLAG           = header.get("send_flag");				//견적서 작성:N 제출:P
            String TTL_CHARGE           = header.get("ttl_charge");
            String NET_AMT              = "0";//header.get("NET_AMT");
            String HOUSE_CODE           = info.getSession("HOUSE_CODE");
            String VENDOR_CODE          = header.get("st_vendor_code");
            String SUBJECT              = header.get("subject");
            String RFQ_NO               = header.get("st_rfq_no");
            String RFQ_COUNT            = header.get("st_rfq_count");
            //String DELY_TERMS           = header.get("DELY_TERMS");
            String PAY_TERMS            = header.get("pay_terms");
            //String CUR                  = header.get("CUR");
            //String SHIPPING_METHOD      = header.get("SHIPPING_METHOD");
            //String USANCE_DAYS          = header.get("USANCE_DAYS");
            //String DEPART_PORT          = header.get("DEPART_PORT");
            //String ARRIVAL_PORT         = header.get("ARRIVAL_PORT");
            //String PRICE_TYPE           = header.get("PRICE_TYPE");
            String COMPANY_CODE         = header.get("company_code");
            String REMARK               = header.get("remark");
            String QTA_VAL_DATE         = SepoaString.getDateUnSlashFormat( header.get("qta_val_date") );
            String BID_REQ_TYPE         = header.get("bid_req_type");
            String H_QTA_ATTACH_NO      = header.get("qta_attach_no");

            
            Map<String, Object>       param   = null;
            List<Map<String, String>> grid    = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
            int i                             = 0;

           
            int tmpQtepCnt = 0;
            int tmpRqepCnt = 0;
            int tmpRqpfCnt = 0;
            
            String doc_type = "QT";																			  // 견적서 QT
            String seqQtaNo                      = this.setQtInsertQtaNo(info, doc_type);                     //견적서번호 SEQ 생성 ICOYQTHD.QTA_NO
           
            
            
            //for start
            for(i = 0; i < grid.size(); i++){
                //servletParam = new HashMap<String, Object>();
                
                gridInfo                   = grid.get(i);
            
               
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
                if(gridInfo.get("QTA_ATTACH_NO").indexOf("$") > 0)  
                {  
                    StringTokenizer stoken1 = new StringTokenizer(gridInfo.get("QTA_ATTACH_NO"),"$");  
                    int stoken_cnt1 = stoken1.countTokens()/6;  
    
                    for(int a=0; a<stoken_cnt1; a++)  
                    {  
                        tmpRqpfCnt++;
                    }
                }   
            }
            //for end
            
            //String qtepData[][] = new String[tmpQtepCnt][];
            //String rqepData[][] = new String[tmpRqepCnt][];
            //String rqpfData[][] = new String[tmpRqpfCnt][];
            
            int insCntQtep = 0;
            int insCntRqep = 0;
            int insCntQtpf = 0;
            

            
            Map<String, String> tmp_chkCreateData = null;
            
            //for start
            for(i = 0; i < grid.size(); i++){
                
            	tmp_chkCreateData = new HashMap<String, String>();
                gridInfo                   = grid.get(i);
            
                /*String[] tmp_chkdata = {RFQ_NO,RFQ_COUNT,RFQ_SEQ[i]};
                chkCreateData[i] = tmp_chkdata;*/
                                
                tmp_chkCreateData.put("rfq_no", 		RFQ_NO);
                tmp_chkCreateData.put("rfq_count", 		RFQ_COUNT);
                tmp_chkCreateData.put("rfq_seq", 		gridInfo.get("RFQ_SEQ"));
                
                
                
                chkCreateData.add(tmp_chkCreateData);
               
                String tmp_MOLDING_FLAG = "N";
                if(Double.parseDouble(JSPUtil.nullToRef(gridInfo.get("MOLDING_CHARGE"), "0")) > 0) {
                    tmp_MOLDING_FLAG = "Y";
                }
                
                if("S".equals(BID_REQ_TYPE)){       //입찰구분(S, I)  WORK 예정
                
                    StringTokenizer st_1 = new StringTokenizer(gridInfo.get("QTA_ATTACH_NO"),"$");  
                    int st_cnt_1 = st_1.countTokens()/5;  
                    
                    Logger.debug.println(info.getSession("ID"),this,"st_cnt_1 ==============>" + st_cnt_1);
                    
                    rqpfData = this.setQtInsertRqpfData(info, gridInfo, seqQtaNo, st_1, st_cnt_1, RFQ_NO, RFQ_COUNT, VENDOR_CODE);																					//견적......I DON'T NO           
                
                    gridInfo.put("QTA_ATTACH_NO","PF");          
                }
                
                String item_amt = gridInfo.get("ITEM_AMT");
                
                
                
                if ((item_amt == null) || ("".equals(item_amt)) || (Float.parseFloat(item_amt) == 0)) {
//                  item_amt = gridInfo.get("UNIT_PRICE");
                    item_amt = gridInfo.get("SUPPLY_AMT");
                }
                
                

                NET_AMT = String.valueOf(Double.parseDouble(NET_AMT) + Double.parseDouble(item_amt));
                
                
                
                
                qtdtData    = this.setQtInsertQtdtData(qtdtData, info, gridInfo, RFQ_NO, RFQ_COUNT, seqQtaNo, tmp_MOLDING_FLAG, item_amt, VENDOR_CODE, i);   //견적서 상세정보 ICOYQTDT
                //qtdtData[i] = tmp_qtdtdata;
                
                
                rqdtData    = this.setQtInsertRqdtData(rqdtData, info, gridInfo, RFQ_NO, RFQ_COUNT);                                         //견적의뢰 상세정보 ICOYRQDT
                //rqdtData[i] = tmp_rqdtdata;
                
                
                rqseData    = this.setQtInsertRqseData(rqseData, info, gridInfo, RFQ_NO, RFQ_COUNT, VENDOR_CODE);                                         // 견적의뢰 대상업체 정보 ICOYRQSE
                //rqseData[i] = tmp_rqsedata;
                
                
                
                String[] f_date = CommonUtil.StrToArray(gridInfo.get("EP_FROM_DATE"),"##");  
                String[] t_date = CommonUtil.StrToArray(gridInfo.get("EP_TO_DATE"),"##");  
                String[] f_qty = CommonUtil.StrToArray(gridInfo.get("EP_FROM_QTY"),"##");  
                String[] t_qty = CommonUtil.StrToArray(gridInfo.get("EP_TO_QTY"),"##");  
                String[] unit_price = CommonUtil.StrToArray(gridInfo.get("EP_UNIT_PRICE"),"##");  
  
                StringTokenizer st = new StringTokenizer(gridInfo.get("EP_UNIT_PRICE"),"##");  
                int st_cnt = st.countTokens();  
                
                Logger.debug.println(info.getSession("ID"),this,"st_cnt ==============>" + st_cnt);
                
                qtepData = this.setQtInsertQtepData(qtepData, info, gridInfo, seqQtaNo, st_cnt, f_qty, RFQ_NO, RFQ_COUNT, f_qty, t_qty, f_date, t_date, unit_price, VENDOR_CODE);		////견적의뢰상세 원가정보 ICOYQTEP
                
                
                
                
                
                
                //PRICE_DOC Start
                if(gridInfo.get("PRICE_DOC").indexOf("$") > 0)  
                {  
                    String[] unit_doc = CommonUtil.StrToArray(gridInfo.get("PRICE_DOC"), "$");  
                    StringTokenizer stoken1 = new StringTokenizer(gridInfo.get("PRICE_DOC"),"$");  
                    int stoken_cnt1 = stoken1.countTokens();  
                    
                   
                    rqepData = this.setQtInsertRqepData(rqepData, info, gridInfo, unit_doc, stoken_cnt1, RFQ_NO, RFQ_COUNT, VENDOR_CODE);  //견적의뢰상세 원가정보 ICOYRQEP
                   
                }
                
              //PRICE_DOC End
                
                
            }   //end for   
                            
            

            qthdData = setQtInsertQthdData(qthdData, info, gridInfo, RFQ_NO, RFQ_COUNT, seqQtaNo, QTA_VAL_DATE, NET_AMT, REMARK, TTL_CHARGE, H_QTA_ATTACH_NO, VENDOR_CODE, SEND_FLAG);   //견적서 정보 ICOYQTHD
            
            
           /* Object[] obj = {RFQ_NO, RFQ_COUNT, seqQtaNo, chkCreateData, qthdData
            		, qtdtData , rqdtData, rqseData, qtepData, rqepData, rqpfData};*/
                            
            paramData.put("SEND_FLAG"       , SEND_FLAG);
            paramData.put("RFQ_NO"          , RFQ_NO);
            paramData.put("RFQ_COUNT"       , RFQ_COUNT);
            paramData.put("seqQtaNo"        , seqQtaNo);
            paramData.put("chkCreateData"   , chkCreateData);
            paramData.put("qthdData"        , qthdData);
            paramData.put("qtdtData"        , qtdtData);
            paramData.put("rqdtData"        , rqdtData);
            paramData.put("rqseData"        , rqseData);
            paramData.put("qtepData"        , qtepData);
            paramData.put("rqepData"        , rqepData);
            paramData.put("rqpfData"        , rqpfData);
            
            Object[] obj = {paramData};
            value = ServiceConnector.doService(info, "s2021", "TRANSACTION", "setInsert_Qta_Cre", obj);

            //Object[] obj = {send_flag, RFQ_NO, RFQ_COUNT, QTA_NO, chkCreateData, qthdData
    		//		, qtdtData , rqdtData, rqseData, qtepData, rqepData, rqpfData};
    
            
            
            if(value.flag) {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
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
            svcParam.put("rfq_flag",    iRfgFlag);
            svcParam.put("rfq_type",    header.get("I_RFQ_TYPE"));
            svcParam.put("rfq_no",      rfqNo);
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
	 * 견적..I don't no
	 * setQtInsertRqpfData
	 * @param  info, gridInfo, seqQtaNo, st_1, st_cnt_1, RFQ_NO, RFQ_COUNT
	 * @return rqpfData
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private List<Map<String, String>> setQtInsertRqpfData(SepoaInfo info,
			Map<String, String> gridInfo, String seqQtaNo, StringTokenizer st_1, int st_cnt_1,
			String RFQ_NO, String RFQ_COUNT, String VENDOR_CODE) {
		
		List<Map<String, String>> rqpfData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_rqpfData   = new HashMap<String, String>();
		
	    
	    for(int k=0; k<st_cnt_1; k++)  {
	        String[][] dataPF = new String[st_cnt_1][6];   
	         dataPF[k][0] = st_1.nextToken().trim(); //human_no
	         dataPF[k][1] = st_1.nextToken().trim(); //name_loc
	         dataPF[k][2] = st_1.nextToken().trim(); //position
	         dataPF[k][3] = st_1.nextToken().trim(); //position_code
	         dataPF[k][4] = st_1.nextToken().trim(); //qty
	         dataPF[k][5] = st_1.nextToken().trim(); //unit_price   
	            
	         tmp_rqpfData.put("HOUSE_CODE"                , info.getSession("HOUSE_CODE") );
	         tmp_rqpfData.put("VENDOR_CODE"               , VENDOR_CODE);
	         tmp_rqpfData.put("QTA_NO"                    , seqQtaNo                      );
	         //tmp_rqpfData.put(""                        , 1);												//WORK 필요 String.valueOf(i + 1)
	         tmp_rqpfData.put("RFQ_NO"                    , RFQ_NO);
	         tmp_rqpfData.put("RFQ_COUNT"                 , RFQ_COUNT);
	         tmp_rqpfData.put("RFQ_SEQ"                   , gridInfo.get("RFQ_SEQ"));                        
	         //tmp_rqpfData.put(""                        , String.valueOf(k+1));
	         //tmp_rqpfData.put(""                        , dataPF[k][0]);
	         //tmp_rqpfData.put(""                        , dataPF[k][1]);
	         //tmp_rqpfData.put(""                        , dataPF[k][3]);
	//         tmp_rqpfData.put(""                        , dataPF[k][4]);
	//         tmp_rqpfData.put(""                        , dataPF[k][5]);
	         tmp_rqpfData.put("STATUS"                    , "C");                           				//  STATUS       
	         tmp_rqpfData.put("ADD_USER_ID"               , info.getSession("ID"));
	         tmp_rqpfData.put("ADD_DATE"                  , SepoaDate.getShortDateString());
	         tmp_rqpfData.put("ADD_TIME"                  , SepoaDate.getShortTimeString());   
	         tmp_rqpfData.put("CHANGE_USER_ID"            , info.getSession("ID")         );
	         tmp_rqpfData.put("CHANGE_DATE"               , SepoaDate.getShortDateString());
	         tmp_rqpfData.put("CHANGE_TIME"               , SepoaDate.getShortTimeString());
	
	         rqpfData.add(tmp_rqpfData);
	         //insCntQtpf++;
	
	         }  
		
		
		return rqpfData;
	}
	
	/**
	 * 견적의뢰상세 원가정보 ICOYQTEP
	 * setQtInsertQtepData
	 * @param  info, gridInfo, seqQtaNo, st_cnt, f_qty, RFQ_NO, RFQ_COUNT, f_qty, t_qty, f_date, t_date, unit_price
	 * @return qtepData
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private List<Map<String, String>> setQtInsertQtepData(List<Map<String, String>> qtepData, SepoaInfo info,
			Map<String, String> gridInfo, String seqQtaNo, int st_cnt, String[] f_qty,
			String RFQ_NO, String RFQ_COUNT, String[] f_qty2, String[] t_qty,
			String[] f_date, String[] t_date, String[] unit_price, String VENDOR_CODE) throws Exception {
		
//		List<Map<String, String>> qtepData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_qtepData   = new HashMap<String, String>();
	    
	    for(int y=0; y<st_cnt; y++)  
	    {  
	        String tmp_FROM_QTY    = JSPUtil.nullToRef(f_qty[y], "0");
	        String tmp_TO_QTY      = JSPUtil.nullToRef(t_qty[y], "0");       
	    
	        tmp_qtepData.put("HOUSE_CODE"                    , info.getSession("HOUSE_CODE"));
	        tmp_qtepData.put("QTA_NO"                        , seqQtaNo);
	        //tmp_qtepData.put(""                             , String.valueOf(1)          );		//1씩 증가 WORK 필요  String.valueOf(i+1)							
	        //tmp_qtepData.put(""                             , String.valueOf(y + 1)          );										
	        tmp_qtepData.put("COMPANY_CODE"                 , info.getSession("COMPANY_CODE"));										
	        //tmp_qtepData.put(""                             ,                                 );										
	        tmp_qtepData.put("VENDOR_CODE"                  , VENDOR_CODE);										
	        tmp_qtepData.put("STATUS"                       , "C");										
	        tmp_qtepData.put("RFQ_NO"                       , RFQ_NO);										
	        tmp_qtepData.put("RFQ_COUNT"                    , RFQ_COUNT);										
	        tmp_qtepData.put("RFQ_SEQ"                      , gridInfo.get("RFQ_SEQ"));										
	        tmp_qtepData.put("FROM_QTY"                     , tmp_FROM_QTY);										
	        tmp_qtepData.put("TO_QTY"                       , tmp_TO_QTY);										
	        tmp_qtepData.put(""                             , f_date[y].trim());										
	        tmp_qtepData.put(""                             , t_date[y].trim());										
	        tmp_qtepData.put("UNIT_PRICE"                   , unit_price[y]);										
	        //tmp_qtepData.put(""                             ,                                 );										
	        tmp_qtepData.put("ADD_DATE"                     , SepoaDate.getShortDateString());										
	        tmp_qtepData.put("ADD_TIME"                     , SepoaDate.getShortTimeString());										
	        tmp_qtepData.put("ADD_USER_ID"                  , info.getSession("ID"));										
	        tmp_qtepData.put("CHANGE_DATE"                  , SepoaDate.getShortDateString());										
	        tmp_qtepData.put("CHANGE_TIME"                  , SepoaDate.getShortTimeString());										
	        //tmp_qtepData.put(""                           ,                                );										
	        tmp_qtepData.put("CHANGE_USER_ID"               , info.getSession("ID"));										
	        
	        qtepData.add(tmp_qtepData);
	        //insCntQtep++;
	    }
		
		return qtepData;
	}
	
	/**
	   * //
	   * setQtInsertDelQtpfData
	   * @param  info, gridInfo, seqQtaNo
	   * @return delQtpfData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertDelQtpfData(SepoaInfo info,
	        Map<String, String> gridInfo, String seqQtaNo) {
	    
	    
	    List<Map<String, String>> delQtpfData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_delQtpfData   = new HashMap<String, String>();
	    
	    
	    tmp_delQtpfData.put("HOUSE_CODE"                    , info.getSession("HOUSE_CODE"));
	    tmp_delQtpfData.put("QTA_NO"                        , seqQtaNo);
	    tmp_delQtpfData.put("VENDOR_CODE"                   , gridInfo.get("VENDOR_CODE"));
	            
	    delQtpfData.add(tmp_delQtpfData);
	
	    return delQtpfData;
	}
	
	/**
	   * //견적의뢰상세 원가정보 ICOYQTEP
	   * setQtInsertDelQtepData
	   * @param  info, gridInfo, seqQtaNo
	   * @return delQtdtData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertDelQtepData(SepoaInfo info,
	        Map<String, String> gridInfo, String seqQtaNo) {
	    
	    
	    List<Map<String, String>> delQtepData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_delQtepData   = new HashMap<String, String>();
	    
	    
	    tmp_delQtepData.put("HOUSE_CODE"                    , info.getSession("HOUSE_CODE"));
	    tmp_delQtepData.put("QTA_NO"                        , seqQtaNo);
	    tmp_delQtepData.put("VENDOR_CODE"                   , gridInfo.get("VENDOR_CODE"));
	            
	    delQtepData.add(tmp_delQtepData);
	    
	    return delQtepData;
	}
	
	/**
	   * 견적서 상세정보 ICOYQTDT
	   * setQtInsertDelQtdtData
	   * @param  info, gridInfo, seqQtaNo
	   * @return delQtdtData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertDelQtdtData(SepoaInfo info,
	        Map<String, String> gridInfo, String seqQtaNo) {
	
	    List<Map<String, String>> delQtdtData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_delQtdtData   = new HashMap<String, String>();
	    
	    
	    tmp_delQtdtData.put("HOUSE_CODE"                    , info.getSession("HOUSE_CODE"));
	    tmp_delQtdtData.put("QTA_NO"                        , seqQtaNo);
	    tmp_delQtdtData.put("VENDOR_CODE"                   , gridInfo.get("VENDOR_CODE"));
	            
	    delQtdtData.add(tmp_delQtdtData);
	    
	    return delQtdtData;
	}
	
	/**
	   * 견적서 상세 
	   * setQtInsertQthdData
	   * @param  info, gridInfo, seqQtaNo, QTA_VAL_DATE, NET_AMT, REMARK, TTL_CHARGE, H_QTA_ATTACH_NO
	   * @return qthdData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertQthdData(List<Map<String, String>> qthdData
														, SepoaInfo info, Map<String, String> gridInfo
	                                                    , String RFQ_NO
	                                                    , String RFQ_COUNT
	                                                    , String seqQtaNo
	                                                    , String QTA_VAL_DATE
	                                                    , String NET_AMT
	                                                    , String REMARK
	                                                    , String TTL_CHARGE
	                                                    , String H_QTA_ATTACH_NO
	                                                    , String VENDOR_CODE
	                                                    , String SEND_FLAG) {
	    
//	    List<Map<String, String>> qthdData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_qthdData   = new HashMap<String, String>();
	
	    tmp_qthdData.put("STATUS"                        , "R");
	    tmp_qthdData.put("QTA_VAL_DATE"                  , QTA_VAL_DATE);
	    tmp_qthdData.put("NET_AMT"                       , NET_AMT);
	    tmp_qthdData.put("TTL_AMT"                       , NET_AMT);
	    tmp_qthdData.put("ADD_DATE"                      , SepoaDate.getShortDateString());
	    //tmp_qthdData.put(""                              , "");
	    tmp_qthdData.put("ADD_TIME"                      , SepoaDate.getShortTimeString());  
	    tmp_qthdData.put("ADD_USER_ID"                   , info.getSession("ID"));
	    tmp_qthdData.put("REMARK"                        , REMARK);
	    tmp_qthdData.put("TTL_CHARGE"                    , TTL_CHARGE);
	    tmp_qthdData.put("CUR"                           , gridInfo.get("CUR"));                    //CUR    
	    //tmp_qthdData.put(""                            , "" );                                    
	    tmp_qthdData.put("DEPART_PORT "                  , "");                                     //DEPART_PORT
	    //tmp_qthdData.put(""                              , "");                                   //ARRIVAL_PORT   
	    tmp_qthdData.put("ARRIVAL_PORT"                  , "");                                     //PAY_TERMS      
	    tmp_qthdData.put("USANCE_DAYS"                   , "");                                     //USANCE_DAYS    
	    tmp_qthdData.put("DELY_TERMS"                    , "");                                     //DELY_TERMS     
	    //tmp_qthdData.put(""                              , "");                                                    
	    tmp_qthdData.put("SHIPPING_METHOD"               , "");                                     //SHIPPING_METHOD
	    tmp_qthdData.put("PAY_TEXT"                      , "");                                     // pay_text
	    tmp_qthdData.put("ATTACH_NO"                     , H_QTA_ATTACH_NO);                        // attach_no
	    //tmp_qthdData.put(""                              , info.getSession("HOUSE_CODE"));
	    tmp_qthdData.put("DEPART_PORT"                   , "");                                     //DEPART_PORT
	    //tmp_qthdData.put(""                              , "");
	    tmp_qthdData.put(""                              , info.getSession("COMPANT_CODE"));
	    tmp_qthdData.put("ARRIVAL_PORT"                  , "");                                     //ARRIVAL_PORT
	    tmp_qthdData.put("HOUSE_CODE"                    , info.getSession("HOUSE_CODE"));
	    tmp_qthdData.put("QTA_NO"                        , seqQtaNo);
	    tmp_qthdData.put("VENDOR_CODE"                   , VENDOR_CODE);
	    tmp_qthdData.put("RFQ_NO"                        , RFQ_NO);
	    tmp_qthdData.put("RFQ_COUNT"                     , RFQ_COUNT);
	    tmp_qthdData.put("SEND_FLAG"                     , SEND_FLAG);
	            
	    qthdData.add(tmp_qthdData);
	    
	    return qthdData;
	}
	
	/**
	   * 견적의뢰상세 원가정보 ICOYRQEP
	   * setQtInsertRqepData
	   * @param  gdReq
	   * @param  info
	 * @param rFQ_COUNT
	 * @param rFQ_NO
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertRqepData(List<Map<String, String>> rqepData, SepoaInfo info, Map<String, String> gridInfo, String[] unit_doc, int stoken_cnt1, String RFQ_NO, String RFQ_COUNT, String VENDOR_CODE) {
//	    List<Map<String, String>> rqepData = new ArrayList<Map<String, String>>();
	    Map<String, String> tmp_rqepData   = new HashMap<String, String>();
	    
	     for(int a=0; a<stoken_cnt1; a++)  
	     {  
	         String[] tmp_doc = CommonUtil.StrToArray(unit_doc[a], "@");  
	         
	         String COST_PRICE_VALUE = tmp_doc[1];  
	         String COST_SEQ         = tmp_doc[2];  
	              
	         tmp_rqepData.put("COST_PRICE_VALUE"        , COST_PRICE_VALUE);
	         tmp_rqepData.put("HOUSE_CODE"              , info.getSession("HOUSE_CODE"));
	         tmp_rqepData.put("RFQ_NO"                  , RFQ_NO);
	         tmp_rqepData.put("RFQ_COUNT"               , RFQ_COUNT);
	         tmp_rqepData.put("RFQ_SEQ"                 , gridInfo.get("RFQ_SEQ"));
	         tmp_rqepData.put("VENDOR_CODE"             , VENDOR_CODE);
	         tmp_rqepData.put("COST_SEQ"                , COST_SEQ);
	
	         rqepData.add(tmp_rqepData);
	         
	         //insCntRqep++;
	         
	     }  
	    
	    
	    
	    return rqepData;
	}
	
	/**
	   * 견적의뢰 대상업체정보
	   * setQtInsertRqseData
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertRqseData(List<Map<String, String>> rqseData, SepoaInfo info, Map<String, String> gridInfo, String RFQ_NO, String RFQ_COUNT, String VENDOR_CODE) {
	    
//	    List<Map<String, String>> rqseData        = new ArrayList<Map<String, String>>();
	    Map<String, String>       tmp_rqsedata    = new HashMap<String, String>();
	    
	    tmp_rqsedata.put("HOUSE_CODE"                           , info.getSession("HOUSE_CODE"));
	    tmp_rqsedata.put("VENDOR_CODE"                          , VENDOR_CODE);
	    tmp_rqsedata.put("RFQ_NO"                               , RFQ_NO);         
	    tmp_rqsedata.put("RFQ_COUNT"                            , RFQ_COUNT);      
	    tmp_rqsedata.put("RFQ_SEQ"                              , gridInfo.get("RFQ_SEQ"));  
	    
	    rqseData.add(tmp_rqsedata);
	    
	    return rqseData;
	}
	
	/**
	   * 견적의뢰 상세정보
	   * setQtInsertRqdtData
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertRqdtData(List<Map<String, String>> rqdtData, SepoaInfo info, Map<String, String> gridInfo, String RFQ_NO, String RFQ_COUNT) {
	    //List<Map<String, String>> rqdtData        = new ArrayList<Map<String, String>>();
	    Map<String, String>       tmp_rqdtData     = new HashMap<String, String>();
	    
	    
	    
	    tmp_rqdtData.put("HOUSE_CODE"                           , info.getSession("HOUSE_CODE"));
	    tmp_rqdtData.put("RFQ_NO"                               , RFQ_NO);         
	    tmp_rqdtData.put("RFQ_COUNT"                            , RFQ_COUNT);      
	    tmp_rqdtData.put("RFQ_SEQ"                              , gridInfo.get("RFQ_SEQ"));  
	    
	    rqdtData.add(tmp_rqdtData);
	    
	    return rqdtData;
	}
	
	/**
	   * 견적서
	   * setQtInsertQtdtData
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private List<Map<String, String>> setQtInsertQtdtData(List<Map<String, String>> qtdtData, SepoaInfo info, Map<String, String> gridInfo, String RFQ_NO, String RFQ_COUNT, String seqQtaNo, String tmp_MPLDING_FLAG, String item_amt, String VENDOR_CODE, int i) {
	    Map<String, String>       tmp_qtdtdata     = new HashMap<String, String>();
	    String                    id               = info.getSession("ID");
	    //int                       i                = 0;                                     
	    
	    tmp_qtdtdata.put("HOUSE_CODE"                           , info.getSession("HOUSE_CODE"));
	    tmp_qtdtdata.put("VENDOR_CODE"                          , VENDOR_CODE);    
	    tmp_qtdtdata.put("QTA_NO"                               , seqQtaNo);         
	    tmp_qtdtdata.put("QTA_SEQ"                              , String.valueOf(i + 1));        
	    tmp_qtdtdata.put("STATUS"                               , "C");         
	    tmp_qtdtdata.put("COMPANY_CODE"                         , gridInfo.get("VENDOR_CODE"));   
	    tmp_qtdtdata.put("RFQ_NO"                               , RFQ_NO);         
	    tmp_qtdtdata.put("RFQ_COUNT"                            , RFQ_COUNT);      
	    tmp_qtdtdata.put("RFQ_SEQ"                              , gridInfo.get("RFQ_SEQ"));        
	    tmp_qtdtdata.put("ITEM_NO"                              , gridInfo.get("ITEM_NO"));        
	    tmp_qtdtdata.put("VENDOR_ITEM_NO"                       , gridInfo.get("VENDOR_ITEM_NO"));
	    tmp_qtdtdata.put("UNIT_MEASURE"                         , gridInfo.get("UNIT_MEASURE"));   
	    tmp_qtdtdata.put("UNIT_PRICE"                           , gridInfo.get("SUPPLY_PRICE"));     
	    tmp_qtdtdata.put("ITEM_QTY"                             , gridInfo.get("ITEM_QTY"));       
	    tmp_qtdtdata.put("ITEM_AMT"                             , gridInfo.get("SUPPLY_AMT"));   
	    tmp_qtdtdata.put("DISCOUNT"                             , gridInfo.get("DISCOUNT"));    
	    tmp_qtdtdata.put("MAKER_CODE"                           , gridInfo.get("MAKER_CODE")     );
	    tmp_qtdtdata.put("MAKER_NAME"                           , gridInfo.get("MAKER_NAME"));     
	    tmp_qtdtdata.put("DELIVERY_LT"                          , gridInfo.get("DELIVERY_LT").replaceAll("/", ""));    
	    tmp_qtdtdata.put("MOLDING_CHARGE"                       , gridInfo.get("MOLDING_CHARGE"));
	    tmp_qtdtdata.put("QTA_ATTACH_NO"                        , gridInfo.get("QTA_ATTACH_NO"));      
	    tmp_qtdtdata.put("MOLDING_FLAG"                         , tmp_MPLDING_FLAG);   
	    tmp_qtdtdata.put("ADD_DATE"                             , SepoaDate.getShortDateString());       
	    tmp_qtdtdata.put("ADD_TIME"                             , SepoaDate.getShortTimeString());       
	    tmp_qtdtdata.put("ADD_USER_ID"                          , info.getSession("ID"));    
	    tmp_qtdtdata.put("CHANGE_DATE"                          , SepoaDate.getShortDateString());    
	    tmp_qtdtdata.put("CHANGE_TIME"                          , SepoaDate.getShortTimeString());    
	    tmp_qtdtdata.put("CHANGE_USER_ID"                       , info.getSession("ID"));
	    tmp_qtdtdata.put("MOLDING_PROSPECTIVE_QTY"              , gridInfo.get("MOLDING_PROSPECTIVE_QTY"));
	    tmp_qtdtdata.put("DT_REMAKR"                            , gridInfo.get("DT_REMAKR"));
	    tmp_qtdtdata.put("CUSTOMER_PRICE"                       , gridInfo.get("CUSTOMER_PRICE"));
	    tmp_qtdtdata.put("HUMAN_NO"                             , gridInfo.get("HUMAN_NO"));
	    tmp_qtdtdata.put("TECHNIQUE_GRADE"                      , gridInfo.get("TECHNIQUE_GRADE"));
	    tmp_qtdtdata.put("INPUT_FROM_DATE"                      , gridInfo.get("INPUT_FROM_DATE"));
	    tmp_qtdtdata.put("INPUT_TO_DATE"                        , gridInfo.get("INPUT_TO_DATE"));
	    tmp_qtdtdata.put("RATE"                                 , gridInfo.get("RATE"));
	    tmp_qtdtdata.put("SEC_VENDOR_CODE"                      , gridInfo.get("SEC_VENDOR_CODE"));
	    tmp_qtdtdata.put("REMARK"                               , gridInfo.get("REMARK"));
	          
	    qtdtData.add(tmp_qtdtdata);    
	        
	    return qtdtData;
	}
	
	/**
	   * 견적서 입력 일련번호 생성
	   * setQtInsertQtaNo
	   * @param  gdReq
	   * @param  info
	   * @return GridData
	   * @throws Exception
	   * @since  2014-10-07
	   * @modify 2014-10-07
	   */
	private String setQtInsertQtaNo(SepoaInfo info, String doc_type) {
	    String   result = null;
	    SepoaOut wo     = null;
	        
	    wo    = DocumentUtil.getDocNumber(info, doc_type);
	    result = wo.result[0];
	        
	    return result;
	}
	

}
   /* public void doQuery(SepoaStream ws) throws Exception {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());

    	String HOUSE_CODE 	= info.getSession("HOUSE_CODE");
        String VENDOR_CODE  = ws.getParam("VENDOR_CODE");
        String RFQ_NO       = ws.getParam("RFQ_NO");
        String RFQ_COUNT    = ws.getParam("RFQ_COUNT");
        String GROUP_YN     = ws.getParam("GROUP_YN");

        Object[] obj = {VENDOR_CODE, RFQ_NO, RFQ_COUNT, GROUP_YN};
        SepoaOut value = ServiceConnector.doService(info, "s2021", "CONNECTION", "getQuery_Cre_Qta_Detail", obj);
        
        SepoaFormater wf = new SepoaFormater(value.result[0]);

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //결과값을 SepoaTable에서 조작가능하게 formatting한다.
        int row_cnt = wf.getRowCount();

        sepoaservlet.SepoaCombo sepoacombo = new sepoaservlet.SepoaCombo(); 
        String cbo_grade_org[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M169", "");
        String cbo_flag[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M181", "");
        String cbo_type[][] = sepoacombo.getCombo(ws.getRequest(), "SL0018", HOUSE_CODE+"#M170", "");
        	
        String cbo_grade[][] = new String[cbo_grade_org.length + 1][2];
        cbo_grade[0][0] = "";
        cbo_grade[0][1] = "";
        for (int i = 0; i < cbo_grade_org.length; i++) {
           	cbo_grade[i + 1][0] = cbo_grade_org[i][0];
           	cbo_grade[i + 1][1] = cbo_grade_org[i][1];
        }
        	
        if(row_cnt>0){
        	
        	String img_name = "";
            for(int i=0; i<row_cnt; i++) {

                String[] check = {"false", ""};
                String[] img_item_no    = {"",wf.getValue("ITEM_NO" ,i),wf.getValue("ITEM_NO" ,i)}; 
                
                String rfq_attach_cnt = "";
            	img_name = "/kr/images/icon/detail.gif";
                if (wf.getValue("RFQ_ATTACH_NO", i).equals("N")) {
                	img_name = "";
                } else {
                	rfq_attach_cnt = wf.getValue("RFQ_ATTACH_CNT", i);
                }
                String[] img_rfq_attach = {img_name, rfq_attach_cnt, wf.getValue("RFQ_ATTACH_NO", i)};
                
                String qta_attach_cnt = "";
            	img_name = "/kr/images/icon/detail.gif";
                if (wf.getValue("QTA_ATTACH_NO", i).equals("N")) {
                	img_name = "";
                } else {
                	qta_attach_cnt = wf.getValue("QTA_ATTACH_CNT", i);
                }
                String[] img_qta_attach = {img_name, qta_attach_cnt, wf.getValue("QTA_ATTACH_NO", i)};

                String tmp1 = wf.getValue("COST_COUNT", i);
                String tmp2 = "";
                if(tmp1.equals("0")) {
                    img_name = "";
                	tmp2 = "";
                } else {
                	img_name = "/kr/images/icon/detail.gif";
                    tmp2 = tmp1; 
                }

                String img_unit_price = "";
                if(wf.getValue("UNIT_PRICE_IMG", i).equals("N")) {
                	img_unit_price = "";
                } else {
                	img_unit_price = "/kr/images/icon/detail.gif";
                }           
                
                String[] img_qtep = {img_unit_price,"",wf.getValue("UNIT_PRICE_IMG", i)};      // 단가 이미지
                String[] img_cost_count = {img_name, tmp2, tmp1};

                String img_human = "";
                
                String ITEM_NO_SUB = "";                
                if(wf.getValue("ITEM_NO", i).length() > 2){
                	ITEM_NO_SUB = wf.getValue("ITEM_NO", i).substring(0, 2);
                }
                	            
                if ("HW".equals(ITEM_NO_SUB) || "SW".equals(ITEM_NO_SUB)) {
                	img_human = "";
                } else {
                	img_human = "/kr/images/icon/detail.gif";	                	
                } 
                String img_vendor = "/kr/images/icon/detail.gif";
                String[] img_human_no   = {img_human, wf.getValue("HUMAN_NAME_LOC" ,i), wf.getValue("HUMAN_NO" ,i)}; 

        		int iGradeIndex = CommonUtil.getComboIndex(cbo_grade, wf.getValue("TECHNIQUE_GRADE",i));
        		int iFlagIndex = CommonUtil.getComboIndex(cbo_flag, wf.getValue("TECHNIQUE_FLAG",i));
        		int iTypeIndex = CommonUtil.getComboIndex(cbo_type, wf.getValue("TECHNIQUE_TYPE",i));
        		
                ws.addValue("SELECTED"              , check                                      , "");         
                ws.addValue("ITEM_NO"               , img_item_no                                , "");
                ws.addValue("MATERIAL_CTRL_TYPE"    , wf.getValue("MATERIAL_CTRL_TYPE"          , i), "");
                ws.addValue("DESCRIPTION_LOC"       , wf.getValue("DESCRIPTION_LOC"          , i), ""); 
                ws.addValue("UNIT_MEASURE"          , wf.getValue("UNIT_MEASURE"             , i), "");
                ws.addValue("RFQ_QTY"               , wf.getValue("RFQ_QTY"                  , i), "");
                ws.addValue("ITEM_QTY"              , wf.getValue("ITEM_QTY"                 , i), "");
                
                ws.addValue("CUR"            		, wf.getValue("CUR"               		 , i), ""); 
				ws.addValue("CUSTOMER_PRICE"        , "0", "");
				ws.addValue("CUSTOMER_AMT"          , "0"										 , "");
				ws.addValue("SUPPLY_PRICE"          , "0", "");
				ws.addValue("SUPPLY_AMT"            , "0"										 , "");
                ws.addValue("ITEM_AMT"              , wf.getValue("ITEM_AMT"                 , i), "");
				ws.addValue("DISCOUNT"            	, "0"										 , "");
                ws.addValue("DELIVERY_LT"           , wf.getValue("DELIVERY_LT"              , i), "");
                
                ws.addValue("RD_DATE"               , wf.getValue("RD_DATE"                  , i), "");
                ws.addValue("DELY_TO_LOCATION_NAME" , wf.getValue("DELY_TO_LOCATION_NAME"    , i), "");
                ws.addValue("RFQ_ATTACH_NO"         , img_rfq_attach                             , "");
                ws.addValue("QTA_ATTACH_NO"         , img_qta_attach                             , "");
                ws.addValue("PRICE_DOC"             , img_cost_count                             , "");
                
                ws.addValue("SPECIFICATION"         , wf.getValue("SPECIFICATION"            , i), "");
                ws.addValue("VENDOR_ITEM_NO"        , wf.getValue("VENDOR_ITEM_NO"           , i), "");
                ws.addValue("BEFORE_PRICE"          , wf.getValue("BEFORE_PRICE"             , i), "");
                ws.addValue("YEAR_QTY"              , wf.getValue("YEAR_QTY"                 , i), "");
                ws.addValue("UNIT_PRICE_IMG"        , img_qtep                                   , "");
                ws.addValue("MOLDING_CHARGE"        , wf.getValue("MOLDING_CHARGE"           , i), "");
                ws.addValue("PURCHASER"             , wf.getValue("PURCHASER"                , i), "");
                ws.addValue("PURCHASER_PHONE"       , wf.getValue("PURCHASER_PHONE"          , i), "");
                ws.addValue("RFQ_SEQ"               , wf.getValue("RFQ_SEQ"                  , i), "");
                ws.addValue("MAKER_CODE"            , wf.getValue("MAKER_CODE"               , i), "");
                ws.addValue("MAKER_NAME"            , wf.getValue("MAKER_NAME"               , i), "");
                ws.addValue("EP_FROM_DATE"          , wf.getValue("EP_FROM_DATE"             , i), "");
                ws.addValue("EP_TO_DATE"            , wf.getValue("EP_TO_DATE"               , i), "");
                ws.addValue("EP_FROM_QTY"           , wf.getValue("EP_FROM_QTY"              , i), "");
                ws.addValue("EP_TO_QTY"             , wf.getValue("EP_TO_QTY"                , i), "");
                ws.addValue("EP_UNIT_PRICE"         , wf.getValue("EP_UNIT_PRICE"            , i), "");
                ws.addValue("DELY_TO_LOCATION"      , wf.getValue("DELY_TO_LOCATION"         , i), "");
                ws.addValue("SHIPPER_TYPE"          , wf.getValue("SHIPPER_TYPE"             , i), "");
                ws.addValue("MOLDING_FLAG"          , wf.getValue("MOLDING_FLAG"             , i), "");
                ws.addValue("MOLDING_PROSPECTIVE_QTY", wf.getValue("MOLDING_PROSPECTIVE_QTY"	, i), "");
                
	        	ws.addValue("TECHNIQUE_GRADE"       , cbo_grade  	, "" , iGradeIndex);
	        	ws.addValue("TECHNIQUE_FLAG"        , cbo_flag   	, "" , iFlagIndex);
	        	ws.addValue("TECHNIQUE_TYPE"        , cbo_type   	, "" , iTypeIndex);
				ws.addValue("INPUT_FROM_DATE"    	, wf.getValue("INPUT_FROM_DATE"			,i), "");
				ws.addValue("INPUT_TO_DATE"    		, wf.getValue("INPUT_TO_DATE"			,i), ""); 
//				ws.addValue("HUMAN_NAME_LOC"    	, wf.getValue("HUMAN_NAME_LOC"			,i), "");
				ws.addValue("HUMAN_NAME_LOC"    	, img_human_no, "");
				ws.addValue("REMARK"    			, wf.getValue("REMARK"				,i), "");  
				ws.addValue("CONTRACT_DIV"    		, wf.getValue("CONTRACT_DIV"			,i), "");
				ws.addValue("ITEM_GBN"	    		, wf.getValue("ITEM_GBN"			,i), "");
				ws.addValue("RATE"    				, wf.getValue("RATE"				,i), "");				
				ws.addValue("SEC_VENDOR_CODE"	    , wf.getValue("SEC_VENDOR_CODE"	,i), "");				
				ws.addValue("SEC_VENDOR_CODE_TEXT"	,  new String[]{img_vendor, "", wf.getValue("SEC_VENDOR_CODE_TEXT", i)}, "");
				ws.addValue("KTGRM"	    			, wf.getValue("KTGRM"	,i), "");												
				
            }
        }
        ws.setMessage(value.message);
        ws.write();
    }
 
/////////////////////////////#################////////////////////////////########################/////////////////////////

    public void doData(SepoaStream ws) throws Exception {
        //session 정보를 가져온다.
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());

        SepoaFormater wf = ws.getSepoaFormater();

        String mode = ws.getParam("mode");

        if(mode.equals("setQtInsert")) { // 견적서 생성
            String send_flag            = ws.getParam("SEND_FLAG");
            String TTL_CHARGE           = ws.getParam("TTL_CHARGE");
            String NET_AMT              = "0";//ws.getParam("NET_AMT");
            String VENDOR_CODE          = ws.getParam("VENDOR_CODE");
            String RFQ_NO               = ws.getParam("RFQ_NO");
            String RFQ_COUNT            = ws.getParam("RFQ_COUNT");
            String PAY_TERMS            = ws.getParam("PAY_TERMS");
            String COMPANY_CODE         = ws.getParam("COMPANY_CODE");
            String REMARK               = ws.getParam("REMARK");
            String QTA_VAL_DATE         = ws.getParam("QTA_VAL_DATE");
            String BID_REQ_TYPE         = ws.getParam("BID_REQ_TYPE");
            String H_QTA_ATTACH_NO      = ws.getParam("QTA_ATTACH_NO");
            
            String[] ITEM_NO                   	= wf.getValue("ITEM_NO");              
            String[] ITEM_QTY                   = wf.getValue("ITEM_QTY");
            String[] VENDOR_ITEM_NO             = wf.getValue("VENDOR_ITEM_NO");
            String[] UNIT_MEASURE               = wf.getValue("UNIT_MEASURE");
            String[] CUSTOMER_PRICE             = wf.getValue("CUSTOMER_PRICE");
            String[] UNIT_PRICE                 = wf.getValue("SUPPLY_PRICE");
            String[] ITEM_AMT                   = wf.getValue("SUPPLY_AMT");
            String[] DISCOUNT                   = wf.getValue("DISCOUNT");
            String[] DELIVERY_LT                = wf.getValue("DELIVERY_LT");
            String[] QTA_ATTACH_NO              = wf.getValue("QTA_ATTACH_NO");
            String[] PRICE_DOC                  = wf.getValue("PRICE_DOC");
            String[] MOLDING_CHARGE             = wf.getValue("MOLDING_CHARGE");
            String[] RFQ_SEQ                    = wf.getValue("RFQ_SEQ");
            String[] MAKER_CODE                 = wf.getValue("MAKER_CODE");
            String[] MAKER_NAME                 = wf.getValue("MAKER_NAME");
            String[] EP_FROM_DATE               = wf.getValue("EP_FROM_DATE");
            String[] EP_TO_DATE                 = wf.getValue("EP_TO_DATE");
            String[] EP_FROM_QTY                = wf.getValue("EP_FROM_QTY");
            String[] EP_TO_QTY                  = wf.getValue("EP_TO_QTY");
            String[] EP_UNIT_PRICE              = wf.getValue("EP_UNIT_PRICE");
            String[] MOLDING_PROSPECTIVE_QTY    = wf.getValue("MOLDING_PROSPECTIVE_QTY");            
            String[] CUR               			= wf.getValue("CUR");                  
            String[] DT_REMAKR         			= wf.getValue("REMARK");         
            String[] HUMAN_NO               	= wf.getValue("HUMAN_NAME_LOC");         
            String[] TECHNIQUE_GRADE            = wf.getValue("TECHNIQUE_GRADE");         
            String[] INPUT_FROM_DATE            = wf.getValue("INPUT_FROM_DATE");         
            String[] INPUT_TO_DATE            	= wf.getValue("INPUT_TO_DATE");         
            String[] RATE            			= wf.getValue("RATE");
            String[] SEC_VENDOR_CODE            = wf.getValue("SEC_VENDOR_CODE");

            String chkCreateData[][] = new String[wf.getRowCount()][];
            String qtdtData[][] = new String[wf.getRowCount()][];
            String rqdtData[][] = new String[wf.getRowCount()][];
            String rqseData[][] = new String[wf.getRowCount()][];

            int tmpQtepCnt = 0;
            int tmpRqepCnt = 0;
            int tmpRqpfCnt = 0;
            for(int i=0; i<wf.getRowCount(); i++) {
                StringTokenizer st = new StringTokenizer(EP_UNIT_PRICE[i],"##");  
                int st_cnt = st.countTokens();     
                
	            for(int y=0; y<st_cnt; y++) {  
	            	tmpQtepCnt++;
	            }
	            
	            if(PRICE_DOC[i].indexOf("$") > 0) {  
	                StringTokenizer stoken1 = new StringTokenizer(PRICE_DOC[i],"$");  
	                int stoken_cnt1 = stoken1.countTokens();  
	
	                for(int a=0; a<stoken_cnt1; a++)  
	                {  
	                	tmpRqepCnt++;
	                }
	            }
	            if(QTA_ATTACH_NO[i].indexOf("$") > 0) {  
	                StringTokenizer stoken1 = new StringTokenizer(QTA_ATTACH_NO[i],"$");  
	                int stoken_cnt1 = stoken1.countTokens()/6;  
	
	                for(int a=0; a<stoken_cnt1; a++)  
	                {  
	                	tmpRqpfCnt++;
	                }
	            }	            
            } 
            
            String qtepData[][] = new String[tmpQtepCnt][];
            String rqepData[][] = new String[tmpRqepCnt][];
            String rqpfData[][] = new String[tmpRqpfCnt][];
            
            SepoaOut	wo=appcommon.getDocNumber(info,"QT"); 
            String QTA_NO = wo.result[0];
            
            int insCntQtep = 0;
            int insCntRqep = 0;
            int insCntQtpf = 0;
            
            for (int i = 0; i<wf.getRowCount(); i++) {
            	
            	String[] tmp_chkdata = {RFQ_NO
            			               ,RFQ_COUNT
            			               ,RFQ_SEQ[i]
            			               };
            	
            	chkCreateData[i] = tmp_chkdata;
            	
            	String tmp_MOLDING_FLAG = "N";
            	if(Double.parseDouble(JspUtil.nullToRef(MOLDING_CHARGE[i], "0")) > 0) {
            		tmp_MOLDING_FLAG = "Y";
            	}
            	 
           	if(BID_REQ_TYPE.equals("S")){
            		 
            		StringTokenizer st_1 = new StringTokenizer(QTA_ATTACH_NO[i],"$");  
            		int st_cnt_1 = st_1.countTokens()/5;  
            		Logger.debug.println(info.getSession("ID"),this,"st_cnt_1 ==============>" + st_cnt_1); 
            		for(int k=0; k<st_cnt_1; k++)  {
				    	String[][] dataPF = new String[st_cnt_1][6];   
				        dataPF[k][0] = st_1.nextToken().trim();	//human_no
				        dataPF[k][1] = st_1.nextToken().trim(); //name_loc 
				        dataPF[k][2] = st_1.nextToken().trim(); //position 
				        dataPF[k][3] = st_1.nextToken().trim(); //position_code 
				        dataPF[k][4] = st_1.nextToken().trim(); //qty 
				        dataPF[k][5] = st_1.nextToken().trim(); //unit_price   
				        
				        String[] tmpTbse = { info.getSession("HOUSE_CODE") 
				            			 					,VENDOR_CODE    
				            			 					,QTA_NO         
								            			 	,String.valueOf(i + 1)   
				                                            ,RFQ_NO
            			               						,RFQ_COUNT
            			               						,RFQ_SEQ[i]                                
		                                            		,String.valueOf(k+1)   
				                                            ,dataPF[k][0] 
				                                            ,dataPF[k][1] 
				                                            ,dataPF[k][3]     
				                                            ,dataPF[k][4]       
				                                            ,dataPF[k][5]          
			                                 				,"C"                                         //  STATUS       
				                                            ,info.getSession("ID") 
				                                            ,SepoaDate.getShortDateString()
				                                            ,SepoaDate.getShortTimeString()   
				                                            ,info.getSession("ID") 
				                                            ,SepoaDate.getShortDateString()
				                                            ,SepoaDate.getShortTimeString() 
				                                            };
				        rqpfData[insCntQtpf]  = tmpTbse;   
				        insCntQtpf++; 
	 				}   
		            QTA_ATTACH_NO[i] = "PF";           
           		} 
            	 
            	String item_amt = ITEM_AMT[i];
            	            	
            	if ((item_amt == null) || (item_amt.equals("")) || (Float.parseFloat(item_amt) == 0)) {
            		item_amt = UNIT_PRICE[i];
            	}
            	
            	NET_AMT = String.valueOf(Double.parseDouble(NET_AMT) + Double.parseDouble(item_amt));
            	String[] tmp_qtdtdata = {info.getSession("HOUSE_CODE")
				            			 ,VENDOR_CODE    
				            			 ,QTA_NO         
				            			 ,String.valueOf(i + 1)        
				            			 ,"C"         
				            			 ,COMPANY_CODE   
				            			 ,RFQ_NO         
				            			 ,RFQ_COUNT      
				            			 ,RFQ_SEQ[i]        
				            			 ,ITEM_NO[i]        
				            			 ,VENDOR_ITEM_NO[i] 
				            			 ,UNIT_MEASURE[i]   
				            			 ,UNIT_PRICE[i]     
				            			 ,ITEM_QTY[i]       
				            			 ,item_amt   
				            			 ,DISCOUNT[i]    
				            			 ,MAKER_CODE[i]     
				            			 ,MAKER_NAME[i]     
				            			 ,DELIVERY_LT[i]    
				            			 ,MOLDING_CHARGE[i] 
				            			 ,QTA_ATTACH_NO[i]      
				            			 ,tmp_MOLDING_FLAG   
				            			 ,SepoaDate.getShortDateString()       
				            			 ,SepoaDate.getShortTimeString()       
				            			 ,info.getSession("ID")    
				            			 ,SepoaDate.getShortDateString()    
				            			 ,SepoaDate.getShortTimeString()    
				            			 ,info.getSession("ID") 
										 ,MOLDING_PROSPECTIVE_QTY[i]
 										 ,DT_REMAKR[i]
 										 ,CUSTOMER_PRICE[i]
 										 ,HUMAN_NO[i]
 										 ,TECHNIQUE_GRADE[i]
 			 							 ,INPUT_FROM_DATE[i]
 			 			 				 ,INPUT_TO_DATE[i]
 			 			 				 ,RATE[i]
 			 			 				 ,SEC_VENDOR_CODE[i]		 
						               };
	
            	qtdtData[i] = tmp_qtdtdata;
            	
            	String[] tmp_rqdtdata = {info.getSession("HOUSE_CODE")
            							,RFQ_NO
            							,RFQ_COUNT
            							,RFQ_SEQ[i]
            							};
            	
            	rqdtData[i] = tmp_rqdtdata;
            	
            	String[] tmp_rqsedata = {info.getSession("ID")
            							,info.getSession("HOUSE_CODE")
				            			,VENDOR_CODE
										,RFQ_NO
										,RFQ_COUNT
										,RFQ_SEQ[i]
										};

            	rqseData[i] = tmp_rqsedata;
            	
                String[] f_date = CommonUtil.StrToArray(EP_FROM_DATE[i],"##");  
                String[] t_date = CommonUtil.StrToArray(EP_TO_DATE[i],"##");  
                String[] f_qty = CommonUtil.StrToArray(EP_FROM_QTY[i],"##");  
                String[] t_qty = CommonUtil.StrToArray(EP_TO_QTY[i],"##");  
                String[] unit_price = CommonUtil.StrToArray(EP_UNIT_PRICE[i],"##");  
  
                StringTokenizer st = new StringTokenizer(EP_UNIT_PRICE[i],"##");  
                int st_cnt = st.countTokens();  
                Logger.debug.println(info.getSession("ID"),this,"st_cnt ==============>" + st_cnt); 
                for(int y=0; y<st_cnt; y++)  
                {  
                	String tmp_FROM_QTY    = JspUtil.nullToRef(f_qty[y], "0");
                	String tmp_TO_QTY      = JspUtil.nullToRef(t_qty[y], "0");
                	
                	String[] tmp_qtepdata = {info.getSession("HOUSE_CODE")
                							,QTA_NO
                							,String.valueOf(i + 1)
                							,String.valueOf(y + 1)
                							,COMPANY_CODE
                							
					            			,VENDOR_CODE
					            			,"C"
											,RFQ_NO
											,RFQ_COUNT
											,RFQ_SEQ[i]
											         
											,tmp_FROM_QTY
											,tmp_TO_QTY
											,f_date[y].trim()
											,t_date[y].trim()
											,unit_price[y]
											            
											,SepoaDate.getShortDateString()
											,SepoaDate.getShortTimeString()
											,info.getSession("ID")
											,SepoaDate.getShortDateString()
											,SepoaDate.getShortTimeString()
											
											,info.getSession("ID")
                							};
                	
                	qtepData[insCntQtep] = tmp_qtepdata;
                	
                	insCntQtep++;
                	
                }
                 
                if(PRICE_DOC[i].indexOf("$") > 0)  
                {  
                	String[] unit_doc = CommonUtil.StrToArray(PRICE_DOC[i], "$");  
                    StringTokenizer stoken1 = new StringTokenizer(PRICE_DOC[i],"$");  
                    int stoken_cnt1 = stoken1.countTokens();  
  
                    for(int a=0; a<stoken_cnt1; a++)  
                    {  
                        String[] tmp_doc = CommonUtil.StrToArray(unit_doc[a], "@");  
  
                        String COST_PRICE_VALUE = tmp_doc[1];  
                        String COST_SEQ         = tmp_doc[2];  
  
                        String[] tmp_rqepdata = {COST_PRICE_VALUE
                        						,info.getSession("HOUSE_CODE")
                        						,RFQ_NO
                        						,RFQ_COUNT
                        						,RFQ_SEQ[i]
                        						         
                        						,VENDOR_CODE
                        						,COST_SEQ
                        						};
                        rqepData[insCntRqep] = tmp_rqepdata;
                        insCntRqep++;
                        
                    }  
                }
                
            }
            
            String[][] qthdData
				              = {{ info.getSession("HOUSE_CODE")
				            	 ,VENDOR_CODE
				            	 ,QTA_NO
				            	 ,"C"
				            	 ,COMPANY_CODE
				            	 
				            	 ,QTA_VAL_DATE
				            	 ,NET_AMT             
				            	 ,NET_AMT             
				            	 ,SepoaDate.getShortDateString()            
				            	 ,SepoaDate.getShortTimeString()   
				            	 
				            	 ,info.getSession("ID")         
				            	 ,SepoaDate.getShortDateString()    
				            	 ,SepoaDate.getShortTimeString()        
				            	 ,info.getSession("ID")      
				            	 ,REMARK    
				            	 
				            	 ,TTL_CHARGE          
				            	 ,CUR[0]			//CUR                 
				            	 ,""			//DEPART_PORT         
				            	 ,""			//ARRIVAL_PORT        
				            	 ,PAY_TERMS 
				            	 
				            	 ,""			//USANCE_DAYS         
				            	 ,""			//DELY_TERMS          
				            	 ,""			//SHIPPING_METHOD     
				            	 ,""            // pay_text
				            	 ,H_QTA_ATTACH_NO // attach_no
				            	 
				            	 ,info.getSession("HOUSE_CODE")   
				            	 ,""			//DEPART_PORT
				            	 ,info.getSession("HOUSE_CODE") 
				            	 ,""			//ARRIVAL_PORT
				            	 ,RFQ_NO
				            	 
				            	 ,RFQ_COUNT
				            	 ,send_flag
				                 }};
              
            Object[] obj = {send_flag, RFQ_NO, RFQ_COUNT, QTA_NO, chkCreateData, qthdData
            				, qtdtData , rqdtData, rqseData, qtepData, rqepData, rqpfData};
            SepoaOut value = ServiceConnector.doService(info, "s2021", "TRANSACTION", "setInsert_Qta_Cre", obj);
            
            ws.setCode(String.valueOf(value.status));
            
            String[] res = new String[1];
			res[0] = value.message;
            ws.setUserObject(res);
            
            ws.write();
        } 

    } // doData 끝
    */
