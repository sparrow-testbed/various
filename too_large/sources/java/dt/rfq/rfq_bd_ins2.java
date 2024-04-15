package dt.rfq;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.icompia.util.CommonUtil;

public class rfq_bd_ins2 extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException{Logger.debug.println();}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
		doPost(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		SepoaInfo info  = SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();
    	
    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getRfqDTDisplay".equals(mode)){						// 품목 그리드 조회
    			gdRes = this.getRfqDTDisplay(gdReq, info);
    		}else if("setRfqChange".equals(mode)){					// 업체 전송 수정 임시저장(rfq_flag:T) 업체전송(rfq_flag:E) 
    			gdRes = this.setRfqChange(gdReq, info);
    		}else if("setRfqItemDelete".equals(mode)){				// 견적요청정보 삭제
    			gdRes = this.setRfqItemDelete(gdReq, info);
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
     * 견적요청 정보 삭제 
     * setRfqItemDelete
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-10-20
     * @modify 2014-10-20
     */
	private GridData setRfqItemDelete(GridData gdReq, SepoaInfo info) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
     * 견적요청 업체 전송(저장 후 업체전송) 
     * setRfqChange
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-10-01
     * @modify 2014-10-01
     */
    @SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
	private GridData setRfqChange(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes       = null;
    	HashMap                   message     = null;
    	SepoaOut                  value       = null;
    	Map<String, Object>       data        = null;
    	Map<String, String>       header      = null;
    	String                    signStatus  = null;
    	String                    iRfgFlag    = null;
    	String                    prNo        = null;
    	String                    rfqNo       = null;
    	String                    rfqCount    = null;
    	String   				  onlyHeader  = null;
    	String                    iCreateType = null;
    	String                    iSzdate     = null;
    	String                    iRemark     = null;
    	List<Map<String, String>> prhddata    = null;
    	List<Map<String, String>> rqhddata    = null;    	
    	List<Map<String, String>> rqandata    = new ArrayList<Map<String, String>>();
    	Map<String, String>       delrqandata = new HashMap<String, String>();
    	Map<String, String>       delrqdtdata = new HashMap<String, String>(); 
		Map<String, String>       delrqsedata = new HashMap<String, String>(); 
		Map<String, String>       delrqopdata = new HashMap<String, String>(); 
		Map<String, String>       delrqepdata = new HashMap<String, String>(); 
		Map<String, String>       delprhddata = new HashMap<String, String>(); 
		Map<String, String>       delprdtdata = new HashMap<String, String>(); 
		Map<String, Object>       svcParam    = null;
    	Vector                    multilangId = new Vector();
    	
    	try {
    		multilangId.addElement("MESSAGE");
    		
        	message = MessageUtil.getMessage(info, multilangId);	
    		gdRes   = OperateGridData.cloneResponseGridData(gdReq);
    		
            gdRes.addParam("mode", "doSave");
            gdRes.setSelectable(false);
                        
    		data        = SepoaDataMapper.getData(info, gdReq);
    		header      = MapUtils.getMap(data, "headerData"); 			// 헤더 정보 조회
    		iRfgFlag    = header.get("I_RFQ_FLAG");						// 저장(T)/견적중(P)/결재중(B)
    		iCreateType = header.get("I_CREATE_TYPE");					// 생성구분
    		iSzdate     = header.get("I_SZDATE");						//	제안설명회 등록 여부 ICOYRQAN 
    		prNo        = header.get("I_PR_NO");
    		rfqNo       = header.get("I_RFQ_NO");
    		rfqCount    = header.get("I_RFQ_COUNT");
    		onlyHeader  = header.get("I_ONLYHEADER");					//y	: hearder N	: all
    		iRemark     = header.get("I_REMARK");
    		iRemark     = java.net.URLDecoder.decode(iRemark,"UTF-8");
    		header.put("I_REMARK", iRemark);
    		signStatus  = this.setRfqChangeSignStatus(iRfgFlag); 		// 결재상태:작성중(T)/결재중(P)/결재완료(E)
    		iRfgFlag    = this.setRfqChangeIRfgFlag(iRfgFlag);			// 진행상태:작성중(T)/결재중(B)/견적중(P)
    		rqhddata    = this.setRfqChangeRqhddata(info, header, rfqNo, rfqCount, iRfgFlag, signStatus);
    		prhddata    = this.setRfqChangePrhddata(info, header, rfqNo, rfqCount);
    		svcParam    = this.getGridInfoParamList(info, data, rfqNo, rfqCount);
    		
    		if("".equals(iSzdate) == false){							// 제안설명회 등록 여부 ICOYRQAN 
				rqandata    = this.setRfqChangeRqandata(info, rfqNo, rfqCount, iSzdate, header, rqandata);
			}
    		
    		int tmpRqanCnt = 0;
			if(!"".equals(iSzdate)) tmpRqanCnt = 1;
			
			
			//삭제 Map
			for(int i=0; i<tmpRqanCnt ; i++){
				delrqandata.put("rfq_no",    	rfqNo);
				delrqandata.put("rfq_count",    rfqCount);
			}
			
			delrqdtdata.put("rfq_no",    	rfqNo);                
			delrqdtdata.put("rfq_count",    rfqCount); 
			
			delrqsedata.put("rfq_no",   	rfqNo);                
			delrqsedata.put("rfq_count",    rfqCount);          
			
			delrqopdata.put("rfq_no",    	rfqNo);                
			delrqopdata.put("rfq_count",    rfqCount);          
			
			delrqepdata.put("rfq_no",    	rfqNo);                
			delrqepdata.put("rfq_count",    rfqCount);          
			
			if("MA".equals(iCreateType)) {
				
				delprhddata.put("pr_no",    	prNo);                
				
				delprdtdata.put("pr_no",    	prNo);               
			}
			
    		svcParam.put("pflag",       gdReq.getParam("I_PFLAG"));
    		svcParam.put("create_type", iCreateType);
    		svcParam.put("rfq_flag",    iRfgFlag);
    		svcParam.put("rfq_type",    header.get("I_RFQ_TYPE"));
    		svcParam.put("rfq_no",      rfqNo);
    		svcParam.put("rfq_count",   rfqCount);
    		svcParam.put("onlyheader",  onlyHeader );
    		svcParam.put("delrqdtdata", delrqdtdata  );
    		svcParam.put("delrqsedata", delrqsedata  );
    		svcParam.put("delrqopdata", delrqopdata );
    		svcParam.put("delrqepdata", delrqepdata  );
    		svcParam.put("delrqandata", delrqandata  );
    		svcParam.put("delprhddata", delprdtdata  );
    		
    		svcParam.put("prhddata",    prhddata );
    		svcParam.put("rqhddata",    rqhddata );
    		svcParam.put("rqandata",    rqandata);

    		//svcParam.put("prdtdata",  prdtdata );
    		//svcParam.put("rqdtdata",  rqdtdata );
    		//svcParam.put("rqsedata",    rqsedata);
    		//svcParam.put("rqopdata",    rqopdata);
    		//svcParam.put("rqepdata",    rqepdata);

   		              
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRfqChange", obj);
    		gdRes = this.setRfqChangeGdRes(value, message);
    		

    		/*
			Object[] obj = {pflag, create_type, rfq_flag, rfq_type, rfq_no, rfq_count,
							onlyheader, delrqdtdata, delrqsedata, delrqopdata, delrqepdata,
							delrqandata, delprhddata, delprdtdata, prhddata, prdtdata,
							rqhddata, rqdtdata, rqsedata, rqopdata, rqepdata, rqandata};
			
			WiseOut value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRfqChange", obj);

			String[] res = new String[1];
			res[0] = value.message;

			ws.setUserObject(res);
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);

			 
			ws.write();

    		 */    	
    		
    		// SMS 전송, MAIL 전송
			if (value.status == 1) {Logger.debug.println();
                /*if ("P".equals(rfq_flag) && "CL".equals(rfq_type)) // 지명경쟁, 전송 일 경우.
				{
					try {						
						String[][] args = new String[1][2];
						args[0][0] = rfq_no;
						args[0][1] = String.valueOf(rfq_count);

						Object[] sms_args = {args};
				        String sms_type = "";
				        String mail_type = "";
				        
				        sms_type 	= "S00006";
				        mail_type 	= "M00006";
				        
				        if(!"".equals(sms_type)){
				        	System.out.println("1111111");
				        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
				        }
				        if(!"".equals(mail_type)){
				        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
				        }
						
					} catch (Exception e) {
						Logger.debug.println("mail error = " + e.getMessage());
						e.printStackTrace();
					}
				}*/
			}
    		
    	}
    	catch(Exception e){
    		gdRes = new GridData();
    		
    		gdRes.setMessage((message != null)?message.get("MESSAGE.1002").toString():""); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
		
	}


	@SuppressWarnings("rawtypes")
	private GridData setRfqChangeGdRes(SepoaOut value, HashMap message) throws Exception{
    	GridData gdRes = new GridData();
    	
    	gdRes.addParam("mode", "doSave");
		gdRes.setSelectable(false);
		
    	if(value.flag) {
			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			gdRes.setStatus("true");
		}
		else {
			gdRes.setMessage(value.message);
			gdRes.setStatus("false");
		}
    	
    	return gdRes;
    }

        
    private String setRfqChangeIRfgFlag(String iRfgFlag) throws Exception{
    	String result = null;
    	
    	iRfgFlag = this.nvl(iRfgFlag);
    	
    	if ("T".equals(iRfgFlag)) { // 작성중
    		result   = "T"; // 작성중
		}
		else if ("P".equals(iRfgFlag) || "E".equals(iRfgFlag)) { // 결재요청
			result   = "B"; // 결재중
		}
		else { // 업체전송
			result   = "P"; // 견적중
		}
    	
    	return result;
    }
    

	private String setRfqChangeSignStatus(String iRfgFlag) throws Exception{
    	String result = "";
    	String sign_status = "";
    	
		if ("T".equals(iRfgFlag)) { // 작성중
			result = "T"; // 작성중
		} else if ("P".equals(iRfgFlag)) { // 결재요청
			result = "P"; // 결재중
		} else { // 업체전송
			result = "E"; // 결재완료
		}
    	
    	return result;
	   
	}

	/**
     * 견적요청 품목 정보 조회 
     * getRfqDTDisplay
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-09-03
     * @modify 2014-09-30
     */
 
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
	
    
    @SuppressWarnings("unchecked")
	private Map<String, Object> getGridInfoParamList(SepoaInfo info, Map<String, Object> data, String rfqNo, String rfqCount) throws Exception{
    	Map<String, String>       header          = MapUtils.getMap(data, "headerData");
    	Map<String, String>       gridInfo        = null;
    	Map<String, Object>       servletParam    = null;
    	Map<String, Object>       result          = new HashMap<String, Object>();
    	String                    dtTbeNo         = null;
    	String                    techniqueGrade  = null;
    	String                    techniqueType   = null;
    	String                    techniqueFlag   = null;
    	String                    tbeFlag         = "";
    	String                    iPrType         = header.get("I_PR_TYPE");
    	String                    rfqSeq          = null;
    	String                    shipperType     = header.get("I_SHIPPER_TYPE");
    	String                    iCreateType     = header.get("I_CREATE_TYPE");
    	String                    iCtrlCode       = header.get("I_CTRL_CODE");
    	List<Map<String, String>> grid            = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	List<Map<String, String>> chkdata         = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> prcfmdata       = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqdtdata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> prdtdata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqopdata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqsedata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqepdata        = new ArrayList<Map<String, String>>();
    	
		
		int i = 0;
		
    	for(i = 0; i < grid.size(); i++){
			servletParam = new HashMap<String, Object>();
			
			gridInfo       = grid.get(i);
			dtTbeNo        = gridInfo.get("TBE_NO");
			techniqueGrade = gridInfo.get("TECHNIQUE_GRADE");
			techniqueType  = gridInfo.get("TECHNIQUE_TYPE");
			techniqueFlag  = gridInfo.get("TECHNIQUE_FLAG");
			
			
			
			chkdata        = this.setRfqChangeChkdata(chkdata, gridInfo);
			prcfmdata      = this.setRfqChangePrcfmdata(info, prcfmdata, gridInfo);
			
			
			if("".equals(dtTbeNo)){
				tbeFlag = "Y";
			}
			
			if("I".equals(iPrType)){
				techniqueGrade = "";
				techniqueType  = "";
				techniqueFlag  = "";
			}
			
			
			rfqSeq = String.valueOf(i + 1);
			
			
			servletParam.put("info",           info);
			servletParam.put("rfqNo",          rfqNo);
			servletParam.put("rfqCount",       rfqCount);
			servletParam.put("rfqSeq",         rfqSeq);
			servletParam.put("gridInfo",       gridInfo);
			servletParam.put("tbeFlag",        tbeFlag);
			servletParam.put("shipperType",    shipperType);
			servletParam.put("techniqueGrade", techniqueGrade);
			servletParam.put("techniqueType",  techniqueType);
			servletParam.put("techniqueFlag",  techniqueFlag);
			servletParam.put("rqdtdata",       rqdtdata);
			
			
			
			if("MA".equals(iCreateType) == false){	//입력대행
				
				rqdtdata = this.setRfqChangeRqdtdataICreateTypeNotMA(servletParam);
			}
			else{	//지명,공개,수의
				
				
				rqdtdata = this.setRfqChangeRqdtdataICreateTypeMA(servletParam);
			}
			
			
			prdtdata = this.setRfqChangePrdtdata(prdtdata, gridInfo, info, iCtrlCode, rfqNo, rfqCount, rfqSeq);
			rqopdata = this.setRfqChangeRqopdata(info, rfqNo, rfqCount, rfqSeq, gridInfo, rqopdata);
			rqsedata = this.setRfqChangeRqsedata(info, gridInfo, rfqNo, rfqCount, rfqSeq, rqsedata);  
			
			
			rqepdata = this.setRfqChangeRqepdata(gridInfo, info, rfqNo, rfqCount, rfqSeq, rqepdata);
			
			
			
			
		}
    	
		
    	result.put("chkdata",   chkdata);
    	result.put("prcfmdata", prcfmdata);
    	result.put("rqdtdata",  rqdtdata);
    	result.put("prdtdata",  prdtdata);
    	result.put("rqopdata",  rqopdata);
    	result.put("rqsedata",  rqsedata);
    	result.put("rqepdata",  rqepdata);
    	
    	return result;
    }
    
    private List<Map<String, String>> setRfqChangeRqandata(SepoaInfo info, String rfqNo, String rfqCount, String iSzdate, Map<String, String> header, List<Map<String, String>> rqandata) throws Exception{
    	Map<String, String> rqantemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		
		rqantemp.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		rqantemp.put("RFQ_NO",             rfqNo);
		rqantemp.put("RFQ_COUNT",          rfqCount);
		rqantemp.put("STATUS",             "C");
		rqantemp.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
		rqantemp.put("ANNOUNCE_DATE",      iSzdate);
		rqantemp.put("ANNOUNCE_TIME_FROM", header.get("I_START_TIME"));
		rqantemp.put("ANNOUNCE_TIME_TO",   header.get("I_END_TIME"));
		rqantemp.put("ANNOUNCE_HOST",      header.get("I_HOST"));
		rqantemp.put("ANNOUNCE_AREA",      header.get("I_AREA"));
		rqantemp.put("ANNOUNCE_PLACE",     header.get("I_PLACE"));
		rqantemp.put("ANNOUNCE_NOTIFIER",  header.get("I_NOTIFIER"));
		rqantemp.put("ANNOUNCE_RESP",      header.get("I_RESP"));
		rqantemp.put("DOC_FRW_DATE",       header.get("I_DOC_FRW_DATE"));
		rqantemp.put("ADD_USER_ID",        id);
		rqantemp.put("ADD_DATE",           shortDateString);
		rqantemp.put("ADD_TIME",           shortTimeString);
		rqantemp.put("CHANGE_USER_ID",     id);
		rqantemp.put("CHANGE_DATE",        shortDateString);
		rqantemp.put("CHANGE_TIME",        shortTimeString);
		rqantemp.put("ANNOUNCE_COMMENT",   header.get("I_COMMENT"));

		rqandata.add(rqantemp);
		
		return rqandata;
    }
    
    private List<Map<String, String>> setRfqChangeRqepdata(Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rfqSeq, List<Map<String, String>> rqepdata) throws Exception{
    	String              dtPriceDoc                = gridInfo.get("PRICE_DOC");
		String              dtVendorSelectedReason    = gridInfo.get("VENDOR_SELECTED_REASON");
		String              vendorDatasFirstTrim      = null;
		String              index05Value              = null;
		String              shortDateString           = SepoaDate.getShortDateString();
		String              shortTimeString           = SepoaDate.getShortTimeString();
		String              id                        = info.getSession("ID");
		String              houseCode                 = info.getSession("HOUSE_CODE");
		String              companyCode               = info.getSession("COMPANY_CODE");
		String[]            costDatas                 = CommonUtil.getTokenData(dtPriceDoc, "$");
		String[]            vendorSelectedDatas       = CommonUtil.getTokenData(dtVendorSelectedReason, "#");
		String[]            vendorDatas               = null;
		Map<String, String> tmpRqep                   = null;
		int                 vendorSelectedDatasLength = vendorSelectedDatas.length;
		int                 j                         = 0;
		int                 k                         = 0;
		int                 costDatasLength           = costDatas.length;

		for(j = 0; j < vendorSelectedDatasLength; j++) {
			vendorDatas = CommonUtil.getTokenData(vendorSelectedDatas[j], "@");

			for (k = 0; k < costDatasLength / 2; k++) {
				tmpRqep = new HashMap<String, String>();
				
				vendorDatasFirstTrim = vendorDatas[0].trim();
				index05Value         = String.valueOf(k + 1);
				
				tmpRqep.put("HOUSE_CODE",       houseCode);
				tmpRqep.put("VENDOR_CODE",      vendorDatasFirstTrim);
				tmpRqep.put("RFQ_NO",           rfqNo);
				tmpRqep.put("RFQ_COUNT",        rfqCount);
				tmpRqep.put("RFQ_SEQ",          rfqSeq);
				tmpRqep.put("COST_SEQ",         index05Value);
				tmpRqep.put("STATUS",           "C");
				tmpRqep.put("COMPANY_CODE",     companyCode);
				tmpRqep.put("COST_PRICE_NAME",  costDatas[k * 2]);
				tmpRqep.put("COST_PRICE_VALUE", "");
				tmpRqep.put("ADD_DATE",         shortDateString);
				tmpRqep.put("ADD_TIME",         shortTimeString);
				tmpRqep.put("ADD_USER_ID",      id);
				tmpRqep.put("CHANGE_DATE",      shortDateString);
				tmpRqep.put("CHANGE_TIME",      shortTimeString);
				tmpRqep.put("CHANGE_USER_ID",   id);
				
				rqepdata.add(tmpRqep);
			}
		}
		
		return rqepdata;
    }
    
    private List<Map<String, String>> setRfqChangeRqsedata(SepoaInfo info, Map<String, String> gridInfo, String rfqNo, String rfqCount, String rfqSeq, List<Map<String, String>> rqsedata) throws Exception{
    	String              dtVendorSelectedReason  = gridInfo.get("VENDOR_SELECTED_REASON");
    	String              vendorSelectedDatasInfo = null;
    	String              vendorDatasFirstTrim    = null;
    	String              shortDateString         = SepoaDate.getShortDateString();
		String              shortTimeString         = SepoaDate.getShortTimeString();
		String              id                      = info.getSession("ID");
		String              houseCode               = info.getSession("HOUSE_CODE");
		String              companyCode             = info.getSession("COMPANY_CODE");
		String[]            vendorSelectedDatas     = CommonUtil.getTokenData(dtVendorSelectedReason, "#");
		String[]            vendorDatas             = null;
		Map<String, String> tmpRqse                 = null;
		int      vendorSelectedDatasLength          = vendorSelectedDatas.length;
		int      j                                  = 0;
		
		for(j = 0; j < vendorSelectedDatasLength; j++){
			tmpRqse = new HashMap<String, String>();
			
			vendorSelectedDatasInfo = vendorSelectedDatas[j];
			vendorDatas             = CommonUtil.getTokenData(vendorSelectedDatasInfo, "@");
			vendorDatasFirstTrim    = vendorDatas[0].trim();
			
			tmpRqse.put("HOUSE_CODE",      houseCode);
			tmpRqse.put("VENDOR_CODE",     vendorDatasFirstTrim);
			tmpRqse.put("RFQ_NO",          rfqNo);
			tmpRqse.put("RFQ_COUNT",       rfqCount);
			tmpRqse.put("RFQ_SEQ",         rfqSeq);
			tmpRqse.put("STATUS",          "C");
			tmpRqse.put("COMPANY_CODE",    companyCode);
			tmpRqse.put("CONFIRM_FLAG",    "S");
			tmpRqse.put("CONFIRM_DATE",    "");
			tmpRqse.put("CONFIRM_USER_ID", "");
			tmpRqse.put("BID_FLAG",        "");
			tmpRqse.put("ADD_DATE",        shortDateString);
			tmpRqse.put("ADD_USER_ID",     id);
			tmpRqse.put("ADD_TIME",        shortTimeString);
			tmpRqse.put("CHANGE_DATE",     shortDateString);
			tmpRqse.put("CHANGE_USER_ID",  id);
			tmpRqse.put("CHANGE_TIME",     shortTimeString);
			tmpRqse.put("CONFIRM_TIME",    "");
			
			rqsedata.add(tmpRqse);
		}
		
		return rqsedata;
    }
    
    private List<Map<String, String>> setRfqChangeRqopdata(SepoaInfo info, String rfqNo, String rfqCount, String rfqSeq, Map<String, String> gridInfo, List<Map<String, String>> rqopdata) throws Exception{
		
    	String              dtVendorSelectedReason    = gridInfo.get("VENDOR_SELECTED_REASON");
		String              vendorDatasFirstTrim      = null;
    	String              id                        = info.getSession("ID");
    	String              houseCode                 = info.getSession("HOUSE_CODE");
		String              shortDateString           = SepoaDate.getShortDateString();
		String              shortTimeString           = SepoaDate.getShortTimeString();
		String              dtPurchaseLocation        = gridInfo.get("PURCHASE_LOCATION");
		
		
		String[] vendorSelectedDatas = CommonUtil.getTokenData(dtVendorSelectedReason, "#");
		
		String[]            vendorDatas               = null;
		Map<String, String> tmpRqop                   = null;
		//int                 vendorSelectedDatasLength = vendorSelectedDatas.length;
		int                 j                         = 0;
		
		dtPurchaseLocation = JSPUtil.nullToRef(dtPurchaseLocation, "01");
		
    	for(j = 0; j < vendorSelectedDatas.length; j++){
    		
    		tmpRqop = new HashMap<String, String>();
    		
    		//vendorSelectedDatasInfo = vendorSelectedDatas[j];
			vendorDatas             = CommonUtil.getTokenData(vendorSelectedDatas[j], "@");
			vendorDatasFirstTrim    = vendorDatas[0].trim();
			tmpRqop.put("HOUSE_CODE",        houseCode);
			tmpRqop.put("RFQ_NO",            rfqNo);
			tmpRqop.put("RFQ_COUNT",         rfqCount);
			tmpRqop.put("RFQ_SEQ",           rfqSeq);
			tmpRqop.put("PURCHASE_LOCATION", dtPurchaseLocation);
			tmpRqop.put("VENDOR_CODE",       vendorDatasFirstTrim);
			tmpRqop.put("STATUS",            "C");
			tmpRqop.put("ADD_USER_ID",       id);
			tmpRqop.put("ADD_DATE",          shortDateString);
			tmpRqop.put("ADD_TIME",          shortTimeString);
			tmpRqop.put("CHANGE_DATE",       shortDateString);
			tmpRqop.put("CHANGE_TIME",       shortTimeString);
			tmpRqop.put("CHANGE_USER_ID",    id);
			
			rqopdata.add(tmpRqop);
		}
		
		return rqopdata;
    }
    
    private List<Map<String, String>> setRfqChangePrdtdata(List<Map<String, String>> prdtdata, Map<String, String> gridInfo, SepoaInfo info, String iCtrlCode, String rfqNo, String brfqCount, String rfqSeq) throws Exception{
    	Map<String, String> prdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		
		prdttemp.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		prdttemp.put("PR_NO",              rfqNo);
		prdttemp.put("PR_SEQ",             rfqSeq);
		prdttemp.put("STATUS",             "C");
		prdttemp.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
		prdttemp.put("PLANT_CODE",         info.getSession("DEPARTMENT"));
		prdttemp.put("ITEM_NO",            gridInfo.get("ITEM_NO"));
		prdttemp.put("SHIPPER_TYPE",       "D");
		prdttemp.put("PR_PROCEEDING_FLAG", "P");
		prdttemp.put("PURCHASE_LOCATION",  "01");
		prdttemp.put("CTRL_CODE",          iCtrlCode);
		prdttemp.put("UNIT_MEASURE",       gridInfo.get("UNIT_MEASURE"));
		prdttemp.put("PR_QTY",             gridInfo.get("RFQ_QTY"));
		prdttemp.put("CONFIRM_QTY",        "");
		prdttemp.put("CUR",                gridInfo.get("CUR"));
		prdttemp.put("LIST_PRICE",         "");
		prdttemp.put("UNIT_PRICE",         gridInfo.get("RFQ_AMT"));
		prdttemp.put("PR_AMT",             gridInfo.get("RFQ_AMT"));
		prdttemp.put("RD_DATE",            gridInfo.get("RD_DATE"));
		prdttemp.put("PURCHASER_ID",       "");
		prdttemp.put("PURCHASER_NAME",     "");
		prdttemp.put("ATTACH_NO",          gridInfo.get("ATTACH_NO"));
		prdttemp.put("YEAR_QTY",           "");
		prdttemp.put("PURCHASE_DEPT",      "");
		prdttemp.put("PURCHASE_DEPT_NAME", "");
		prdttemp.put("ADD_DATE",           shortDateString);
		prdttemp.put("ADD_USER_ID",        id);
		prdttemp.put("ADD_TIME",           shortTimeString);
		prdttemp.put("CHANGE_DATE",        shortDateString);
		prdttemp.put("CHANGE_USER_ID",     id);
		prdttemp.put("CHANGE_TIME",        shortTimeString);
		prdttemp.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
		prdttemp.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
		prdttemp.put("MAKER_CODE",         gridInfo.get("MAKER_CODE"));
		prdttemp.put("MAKER_NAME",         gridInfo.get("MAKER_NAME"));
		prdttemp.put("DELY_TO_ADDRESS",    gridInfo.get("DELY_TO_ADDRESS"));
		
		prdtdata.add(prdttemp);
		
		return prdtdata;
    }
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> setRfqChangeRqdtdataICreateTypeMA(Map<String, Object> param) throws Exception{
    	SepoaInfo                 info            = (SepoaInfo)param.get("info");
    	List<Map<String, String>> rqdtdata        = (List<Map<String, String>>)param.get("rqdtdata");
    	Map<String, String>       rqdttemp        = new HashMap<String, String>();
    	Map<String, String>       gridInfo        = (Map<String, String>)param.get("gridInfo");
    	String                    rfqSeq          = (String)param.get("rfqSeq");
    	String                    rfqNo           = (String)param.get("rfqNo");
    	String                    tbeFlag         = (String)param.get("tbeFlag");
    	String                    shipperType     = (String)param.get("shipperType");
    	String                    techniqueGrade  = (String)param.get("techniqueGrade");
    	String                    techniqueType   = (String)param.get("techniqueType");
    	String                    techniqueFlag   = (String)param.get("techniqueFlag");
		String                    shortDateString = SepoaDate.getShortDateString();
		String                    shortTimeString = SepoaDate.getShortTimeString();
		String                    id              = info.getSession("ID");
		String                    prSeq           = CommonUtil.lpad(rfqSeq, 5, "0");
		
		rqdttemp.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		rqdttemp.put("RFQ_NO",              rfqNo);
		rqdttemp.put("RFQ_COUNT",           "1");
		rqdttemp.put("RFQ_SEQ",             rfqSeq);
		rqdttemp.put("STATUS",              "C");
		rqdttemp.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		rqdttemp.put("PLANT_CODE",          gridInfo.get("PLANT_CODE"));
		rqdttemp.put("RFQ_PROCEEDING_FLAG", "N");
		rqdttemp.put("ADD_DATE",            shortDateString);
		rqdttemp.put("ADD_TIME",            shortTimeString);
		rqdttemp.put("ADD_USER_ID",         id);
		rqdttemp.put("CHANGE_DATE",         shortDateString);
		rqdttemp.put("CHANGE_TIME",         shortTimeString);
		rqdttemp.put("CHANGE_USER_ID",      id);
		rqdttemp.put("ITEM_NO",             gridInfo.get("ITEM_NO"));
		rqdttemp.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
		rqdttemp.put("RD_DATE",             gridInfo.get("RD_DATE"));
		rqdttemp.put("VALID_FROM_DATE",     "");
		rqdttemp.put("VALID_TO_DATE",       "");
		rqdttemp.put("PURCHASE_PRE_PRICE",  gridInfo.get("PURCHASE_PRE_PRICE"));
		rqdttemp.put("RFQ_QTY",             gridInfo.get("RFQ_QTY"));
		rqdttemp.put("RFQ_AMT",             gridInfo.get("RFQ_AMT"));
		rqdttemp.put("BID_COUNT",           "0");
		rqdttemp.put("CUR",                 gridInfo.get("CUR"));
		rqdttemp.put("PR_NO",               rfqNo);
		rqdttemp.put("PR_SEQ",              prSeq);
		rqdttemp.put("SETTLE_FLAG",         "N");
		rqdttemp.put("SETTLE_QTY",          "0");
		rqdttemp.put("TBE_FLAG",            tbeFlag);
		rqdttemp.put("TBE_DEPT",            "");
		rqdttemp.put("PRICE_TYPE",          "");
		rqdttemp.put("TBE_PROCEEDING_FLAG", "");
		rqdttemp.put("SAMPLE_FLAG",         "");
		rqdttemp.put("DELY_TO_LOCATION",    gridInfo.get("DELY_TO_LOCATION"));
		rqdttemp.put("ATTACH_NO",           gridInfo.get("ATTACH_NO"));
		rqdttemp.put("SHIPPER_TYPE",        shipperType);
		rqdttemp.put("CONTRACT_FLAG",       "");
		rqdttemp.put("COST_COUNT",          gridInfo.get("COST_COUNT"));
		rqdttemp.put("YEAR_QTY",            gridInfo.get("YEAR_QTY"));
		rqdttemp.put("DELY_TO_ADDRESS",     gridInfo.get("DELY_TO_ADDRESS"));
		rqdttemp.put("MIN_PRICE",           "0");
		rqdttemp.put("MAX_PRICE",           "0");
		rqdttemp.put("STR_FLAG",            gridInfo.get("STR_FLAG"));
		rqdttemp.put("TBE_NO",              gridInfo.get("TBE_NO"));
		rqdttemp.put("Z_REMARK",            gridInfo.get("REMARK"));
		rqdttemp.put("TECHNIQUE_GRADE",     techniqueGrade);
		rqdttemp.put("TECHNIQUE_TYPE",      techniqueType);
		rqdttemp.put("INPUT_FROM_DATE",     gridInfo.get("INPUT_FROM_DATE"));
		rqdttemp.put("INPUT_TO_DATE",       gridInfo.get("INPUT_TO_DATE"));
		rqdttemp.put("TECHNIQUE_FLAG",      techniqueFlag);
		rqdttemp.put("SPECIFICATION",       gridInfo.get("SPECIFICATION"));
		rqdttemp.put("MAKER_NAME",          gridInfo.get("MAKER_NAME"));
		
		rqdtdata.add(rqdttemp);
		
		return rqdtdata;
    }
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> setRfqChangeRqdtdataICreateTypeNotMA(Map<String, Object> param) throws Exception{
    	SepoaInfo                 info            = (SepoaInfo)param.get("info");
    	List<Map<String, String>> rqdtdata        = (List<Map<String, String>>)param.get("rqdtdata");
    	Map<String, String>       gridInfo        = (Map<String, String>)param.get("gridInfo");
    	HashMap<String, String>   rqdttemp        = new HashMap<String, String>();
		String                    shortDateString = SepoaDate.getShortDateString();
		String                    shortTimeString = SepoaDate.getShortTimeString();
		String                    id              = info.getSession("ID");
		String                    rfqSeq          = (String)param.get("rfqSeq");
    	String                    rfqNo           = (String)param.get("rfqNo");
    	String                    tbeFlag         = (String)param.get("tbeFlag");
    	String                    shipperType     = (String)param.get("shipperType");
    	String                    techniqueGrade  = (String)param.get("techniqueGrade");
    	String                    techniqueType   = (String)param.get("techniqueType");
    	String                    techniqueFlag   = (String)param.get("techniqueFlag");
		
    	
    	
		rqdttemp.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		rqdttemp.put("RFQ_NO",              rfqNo);
		rqdttemp.put("RFQ_COUNT",           "1");
		rqdttemp.put("RFQ_SEQ",             rfqSeq);
		rqdttemp.put("STATUS",              "C");
		rqdttemp.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		rqdttemp.put("PLANT_CODE",          gridInfo.get("PLANT_CODE"));
		rqdttemp.put("RFQ_PROCEEDING_FLAG", "N");
		rqdttemp.put("ADD_DATE",            shortDateString);
		rqdttemp.put("ADD_TIME",            shortTimeString);
		rqdttemp.put("ADD_USER_ID",         id);
		rqdttemp.put("CHANGE_DATE",         shortDateString);
		rqdttemp.put("CHANGE_TIME",         shortTimeString);
		rqdttemp.put("CHANGE_USER_ID",      id);
		rqdttemp.put("ITEM_NO",             gridInfo.get("ITEM_NO"));
		rqdttemp.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
		rqdttemp.put("RD_DATE",             gridInfo.get("RD_DATE"));
		rqdttemp.put("VALID_FROM_DATE",     "");
		rqdttemp.put("VALID_TO_DATE",       "");
		rqdttemp.put("PURCHASE_PRE_PRICE",  gridInfo.get("PURCHASE_PRE_PRICE"));
		rqdttemp.put("RFQ_QTY",             gridInfo.get("RFQ_QTY"));
		rqdttemp.put("RFQ_AMT",             gridInfo.get("RFQ_AMT"));
		rqdttemp.put("BID_COUNT",           "0");
		rqdttemp.put("CUR",                 gridInfo.get("CUR"));
		rqdttemp.put("PR_NO",               gridInfo.get("PR_NO"));
		rqdttemp.put("PR_SEQ",              gridInfo.get("PR_SEQ"));
		rqdttemp.put("SETTLE_FLAG",         "N");
		rqdttemp.put("SETTLE_QTY",          "0");
		rqdttemp.put("TBE_FLAG",            tbeFlag);
		rqdttemp.put("TBE_DEPT",            "");
		rqdttemp.put("PRICE_TYPE",          "");
		rqdttemp.put("TBE_PROCEEDING_FLAG", "");
		rqdttemp.put("SAMPLE_FLAG",         "");
		rqdttemp.put("DELY_TO_LOCATION",    gridInfo.get("DELY_TO_LOCATION"));
		rqdttemp.put("ATTACH_NO",           gridInfo.get("ATTACH_NO"));
		rqdttemp.put("SHIPPER_TYPE",        shipperType);
		rqdttemp.put("CONTRACT_FLAG",       "");
		rqdttemp.put("COST_COUNT",          gridInfo.get("COST_COUNT"));
		rqdttemp.put("YEAR_QTY",            gridInfo.get("YEAR_QTY"));
		rqdttemp.put("DELY_TO_ADDRESS",     gridInfo.get("DELY_TO_ADDRESS"));
		rqdttemp.put("MIN_PRICE",           "0");
		rqdttemp.put("MAX_PRICE",           "0");
		rqdttemp.put("STR_FLAG",            gridInfo.get("STR_FLAG"));
		rqdttemp.put("TBE_NO",              gridInfo.get("TBE_NO"));
		rqdttemp.put("Z_REMARK",            gridInfo.get("REMARK"));
		rqdttemp.put("TECHNIQUE_GRADE",     techniqueGrade);
		rqdttemp.put("TECHNIQUE_TYPE",      techniqueType);
		rqdttemp.put("INPUT_FROM_DATE",     gridInfo.get("INPUT_FROM_DATE"));
		rqdttemp.put("INPUT_TO_DATE",       gridInfo.get("INPUT_TO_DATE"));
		rqdttemp.put("TECHNIQUE_FLAG",      techniqueFlag);
		rqdttemp.put("SPECIFICATION",       gridInfo.get("SPECIFICATION"));
		rqdttemp.put("MAKER_NAME",          gridInfo.get("MAKER_NAME"));
		 

		rqdtdata.add(rqdttemp);
		
    	
    	return rqdtdata;
    }
    
    private List<Map<String, String>> setRfqChangePrcfmdata(SepoaInfo info, List<Map<String, String>> prcfmdata, Map<String, String> gridInfo) throws Exception{
    	Map<String, String>       prcfmtemp       = new HashMap<String, String>();
    	
    	prcfmtemp.put("DT_RFQ_QTY", gridInfo.get("RFQ_QTY"));
		prcfmtemp.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		prcfmtemp.put("DT_PR_NO",   gridInfo.get("PR_NO"));
		prcfmtemp.put("DT_PR_SEQ",  gridInfo.get("PR_SEQ"));
		
		prcfmdata.add(prcfmtemp);
		
    	return prcfmdata;
    }
    
    private List<Map<String, String>> setRfqChangeChkdata(List<Map<String, String>> chkdata, Map<String, String> gridInfo) throws Exception{
    	Map<String, String> chktemp = new HashMap<String, String>();
    	
    	chktemp.put("DT_ITEM_NO", gridInfo.get("ITEM_NO"));
		
		chkdata.add(chktemp);
		
		return chkdata;
    }
    
    private List<Map<String, String>> setRfqChangePrhddata(SepoaInfo info, Map<String, String> header, String rfqNo, String rfqCount) throws Exception{
    	List<Map<String, String>> prhddata        = new ArrayList<Map<String, String>>();
    	Map<String, String>       prhdtemp        = new HashMap<String, String>();
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	String                    id              = info.getSession("ID");
    	String                    nameLoc         = info.getSession("NAME_LOC");
    	String                    tel             = info.getSession("tel");
    	
    	prhdtemp.put("HOUSE_CODE",       info.getSession("HOUSE_CODE"));
		prhdtemp.put("PR_NO",            rfqNo);
		prhdtemp.put("STATUS",           "C");
		prhdtemp.put("COMPANY_CODE",     info.getSession("COMPANY_CODE"));
		prhdtemp.put("PLANT_CODE",       info.getSession("DEPARTMENT"));
		prhdtemp.put("PR_TYPE",          header.get("I_PR_TYPE"));
		prhdtemp.put("SIGN_STATUS",      "E");
		prhdtemp.put("SIGN_DATE",        shortDateString);
		prhdtemp.put("SIGN_PERSON_ID",   id);
		prhdtemp.put("SIGN_PERSON_NAME", nameLoc);
		prhdtemp.put("TEL_NO",           tel);
		prhdtemp.put("SUBJECT",          header.get("I_SUBJECT"));
		prhdtemp.put("REQ_TYPE",         "M");
		prhdtemp.put("ADD_DATE",         shortDateString);
		prhdtemp.put("ADD_TIME",         shortTimeString);
		prhdtemp.put("ADD_USER_ID",      id);
		prhdtemp.put("CHANGE_DATE",      shortDateString);
		prhdtemp.put("CHANGE_TIME",      shortTimeString);
		prhdtemp.put("CHANGE_USER_ID",   id);
		prhdtemp.put("DEMAND_DEPT_NAME", info.getSession("DEPARTMENT_NAME_LOC"));
		prhdtemp.put("DELY_TO_USER",     nameLoc);
		prhdtemp.put("DELY_TO_PHONE",    tel);
		
		prhddata.add(prhdtemp);
    	
    	return prhddata;
    }
    
    private List<Map<String, String>> setRfqChangeRqhddata(SepoaInfo info, Map<String, String> header, String rfqNo, String rfqCount, String iRfgFlag, String signStatus) throws Exception{
    	List<Map<String, String>> rqhddata        = new ArrayList<Map<String, String>>();
    	Map<String, String>       rqhdtemp        = new HashMap<String, String>();
    	String                    id              = info.getSession("ID");
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	
    	rqhdtemp.put("HOUSE_CODE",       info.getSession("HOUSE_CODE"));
		rqhdtemp.put("RFQ_NO",           rfqNo);
		rqhdtemp.put("RFQ_COUNT",        rfqCount);
		rqhdtemp.put("STATUS",           "C");
		rqhdtemp.put("COMPANY_CODE",     info.getSession("COMPANY_CODE"));
		rqhdtemp.put("RFQ_DATE",         shortDateString);
		rqhdtemp.put("RFQ_CLOSE_DATE",   header.get("I_RFQ_CLOSE_DATE"));
		rqhdtemp.put("RFQ_CLOSE_TIME",   header.get("I_RFQ_CLOSE_TIME"));
		rqhdtemp.put("RFQ_TYPE",         header.get("I_RFQ_TYPE"));
		rqhdtemp.put("PC_REASON",        header.get("I_PC_REASON"));
		rqhdtemp.put("SETTLE_TYPE",      header.get("I_SETTLE_TYPE"));
		rqhdtemp.put("BID_TYPE",         "RQ");
		rqhdtemp.put("RFQ_FLAG",         iRfgFlag);
		rqhdtemp.put("TERM_CHANGE_FLAG", "");
		rqhdtemp.put("CREATE_TYPE",      header.get("I_CREATE_TYPE"));
		rqhdtemp.put("BID_COUNT",        "0");
		rqhdtemp.put("CTRL_CODE",        header.get("I_CTRL_CODE"));
		rqhdtemp.put("ADD_USER_ID",      id);
		rqhdtemp.put("ADD_DATE",         shortDateString);
		rqhdtemp.put("ADD_TIME",         shortTimeString);
		rqhdtemp.put("CHANGE_DATE",      shortDateString);
		rqhdtemp.put("CHANGE_TIME",      shortTimeString);
		rqhdtemp.put("CHANGE_USER_ID",   id);
		rqhdtemp.put("SUBJECT",          header.get("I_SUBJECT"));
		rqhdtemp.put("REMARK",           header.get("I_REMARK"));
		rqhdtemp.put("DOM_EXP_FLAG",     "");
		rqhdtemp.put("ARRIVAL_PORT",     "");
		rqhdtemp.put("USANCE_DAYS",      "");
		rqhdtemp.put("SHIPPING_METHOD",  "");
		rqhdtemp.put("PAY_TERMS",        header.get("I_PAY_TERMS"));
		// HOUSE_CODE
		rqhdtemp.put("ARRIVAL_PORT_NAME",  "");
		rqhdtemp.put("DELY_TERMS",         header.get("I_DELY_TERMS"));
		rqhdtemp.put("PRICE_TYPE",         "");
		rqhdtemp.put("SETTLE_COUNT",       "0");
		rqhdtemp.put("RESERVE_PRICE",      "0");
		rqhdtemp.put("CURRENT_PRICE",      "0");
		rqhdtemp.put("BID_DEC_AMT",        "0");
		rqhdtemp.put("TEL_NO",             "");
		rqhdtemp.put("EMAIL",              "");
		rqhdtemp.put("BD_TYPE",            "");
		rqhdtemp.put("CUR",                "");
		rqhdtemp.put("START_DATE",         "");
		rqhdtemp.put("START_TIME",         "");
		rqhdtemp.put("sms_yn",             "");
		rqhdtemp.put("Z_RESULT_OPEN_FLAG", "");
		rqhdtemp.put("BID_REQ_TYPE",       header.get("I_PR_TYPE"));
		//CREATE_TYPE
		rqhdtemp.put("H_ATTACH_NO",        header.get("I_ATTACH_NO"));
		rqhdtemp.put("SIGN_STATUS",        signStatus);
		
		rqhddata.add(rqhdtemp);
    	
    	return rqhddata;
    }
    	
    private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if("".equals(str)){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
	
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
}
