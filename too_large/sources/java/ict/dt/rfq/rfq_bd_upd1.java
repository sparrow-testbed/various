package ict.dt.rfq;

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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rfq_bd_upd1 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
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
    		
    		if("setRfqChange".equals(mode)){
    			gdRes = this.setRfqChange(gdReq, info);  // 업체 전송 수정 임시저장(rfq_flag:T) 업체전송(rfq_flag:B) 
    		}else if("getRfqDTDisplay".equals(mode)){
    			gdRes = this.getRfqDTDisplay(gdReq, info);
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
    
    //[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
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
            value        = ServiceConnector.doService(info, "I_p1004", "CONNECTION", "getRfqDTDisplay", obj);
            
            
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
   			
   			for (int i = 0; i < sf.getRowCount(); i++) {
   				for(int k=0; k < grid_col_ary.length; k++) {
   			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
   			    		gdRes.addValue("SELECTED", "0");
   			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CHANGE_DATE")) {
       	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(sf.getValue(grid_col_ary[k], i)));
                   	}else {
   			        	gdRes.addValue(grid_col_ary[k], sf.getValue(grid_col_ary[k], i));
   			        }
   				}
   			}
   			
            
//   			sf = new SepoaFormater(value.result[0]);
//   			
//   			if (sf.getRowCount() == 0) {
//   			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
//   			    return gdRes;
//   			}
//   			
//   			String img_name = "/kr/images/icon/detail.gif";
//            String desc = "N" ; 
//            String HOUSE_CODE = info.getSession("HOUSE_CODE");
//            
//        	SepoaCombo sepoacombo = new SepoaCombo();
//        	String cbo_cur[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0014", HOUSE_CODE+"#M002", "");
//        	String cbo_grade[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0022", HOUSE_CODE+"#M169", "");
//        	String cbo_flag[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0022", HOUSE_CODE+"#M181", "");
//        	String cbo_type[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0018", HOUSE_CODE+"#M170", "");
//        	String cbo_dely[][] = sepoacombo.getCombo(gdReq.getRequest(), "SL0022", HOUSE_CODE+"#M187", "");
//   			
//   			for (int i = 0; i < sf.getRowCount(); i++) {
//   				for(int k=0; k < grid_col_ary.length; k++) {
//   			    	
//   					String[] img_item_no = {"", sf.getValue("ITEM_NO" ,i), sf.getValue("ITEM_NO" ,i)};
//   	            	String img_cnt = sf.getValue("ATTACH_CNT" ,i);
//   					
//   	            	if("0".equals(sf.getValue("ATTACH_CNT" ,i))) {
//   	            		img_name = "";  img_cnt ="";
//   	            	} 
//   	            	String[] img_attach_no = {img_name, img_cnt, sf.getValue("ATTACH_NO" ,i)};
//   	            	
//   	            	img_name = "/kr/images/icon/detail.gif";
//   	            	
//   	            	if("0".equals(sf.getValue("VENDOR_CNT" ,i))) {
//   	            		img_name = "";
//   	            	} 
//   	            	
//   	            	String[] img_vendor_cnt = {img_name, sf.getValue("VENDOR_CNT" ,i), sf.getValue("VENDOR_CNT" ,i)};
//   	            	
//   	            	img_name = "/kr/images/icon/detail.gif";
//   	            	img_cnt = sf.getValue("COST_COUNT" ,i);
//   	            	if("0".equals(sf.getValue("COST_COUNT" ,i))) {
//   	            		img_name = "";  img_cnt ="";
//   	            	} 
//
//   	            	String[] img_cost_count = {img_name, img_cnt, sf.getValue("COST_COUNT" ,i)};
//   						img_name = "/kr/images/icon/detail.gif";
//   	            	if(!"".equals(sf.getValue("TBE_NO" ,i))) {
//   	            		desc = "Y";
//   	            	} 		
//   					String[] img_gisul = { img_name , desc , sf.getValue("TBE_NO" , i)  } ; 
//
//   	        		int iGradeIndex = CommonUtil.getComboIndex(cbo_grade, sf.getValue("TECHNIQUE_GRADE",i));
//   	        		int iFlagIndex = CommonUtil.getComboIndex(cbo_flag, sf.getValue("TECHNIQUE_FLAG",i));
//   	        		int iTypeIndex = CommonUtil.getComboIndex(cbo_type, sf.getValue("TECHNIQUE_TYPE",i));
//   	        		int iDelyIndex = CommonUtil.getComboIndex(cbo_dely, sf.getValue("DELY_TO_LOCATION",i));
//   	        		
//   					if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
//   			    		gdRes.addValue("SELECTED", "0");   			    			
//   			    	}else {
//   			        	gdRes.addValue(grid_col_ary[k], sf.getValue(grid_col_ary[k], i));
//   			        }
//   			    	
//   				}
//   			}
   		    
   		} catch (Exception e) {
   			
   		    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
   			gdRes.setStatus("false");
   	    }
   		
   		return gdRes;
	}
    
    //[R101807022454] [2018-11-30] [IT전자입찰시스템] 내외부 데이터 활용 표준 견적 DB 구축
    @SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
    private GridData setRfqChange(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes           = null;
    	HashMap                   message         = null;
    	SepoaOut                  value           = null;
    	Map<String, Object>       data            = null;
    	Map<String, Object>       svcParam        = null;
    	Map<String, String>       header          = null;
    	List<Map<String, String>> rqhddata        = null;    	
    	List<Map<String, String>> rqopdata        = new ArrayList<Map<String, String>>();
    	String                    signStatus      = null;
    	String                    iRfqStatus      = null;
    	String                    rfqNo           = null;
    	String                    rfqCount        = null;    	
    	String                    iCreateType     = null;
    	String                    iSzdate         = null;
    	String                    iRmkTxt         = null;
    	String                    iRfqCloseDate   = null;
    	
    	message = this.setRfqCreateMessage(info);

    	try {
    		data          = SepoaDataMapper.getData(info, gdReq);
    		header        = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
    		iRfqStatus    = header.get("I_RFQ_STATUS");
    		iCreateType   = header.get("I_CREATE_TYPE");
    		iRmkTxt       = header.get("I_RMK_TXT");
    		iRfqCloseDate = header.get("I_RFQ_CLOSE_DATE");
    		iRfqCloseDate = SepoaString.getDateUnSlashFormat(iRfqCloseDate);
    		iRmkTxt       = java.net.URLDecoder.decode(iRmkTxt,"UTF-8");
    		signStatus    = this.setRfqCreateSignStatus(iRfqStatus);
    		iRfqStatus    = this.setRfqCreateIRfgStatus(iRfqStatus);
    		rfqNo         = header.get("rfq_no");
    		rfqCount      = header.get("rfq_count");
    		rqhddata      = this.setRfqCreateRqhddata(info, header, rfqNo, rfqCount, iRfqStatus, signStatus);
    		rqopdata      = this.setRfqCreateRqopdata(info, header, rfqNo, rfqCount, rqopdata);
    		svcParam      = this.getGridInfoParamList(info, data, rfqNo, rfqCount);
    		
    		//System.out.println(gdReq.getParam("I_PFLAG"));
    		
    		svcParam.put("header",      header);    		
    		svcParam.put("pflag",       gdReq.getParam("I_PFLAG"));
    		svcParam.put("create_type", iCreateType);
    		svcParam.put("rfq_flag",    iRfqStatus);
    		svcParam.put("rfq_type",    header.get("I_RFQ_TYPE"));
    		svcParam.put("rfq_no",      rfqNo);
    		svcParam.put("rfqCount",    rfqCount);
    		svcParam.put("rqhddata",    rqhddata);
    		svcParam.put("rqopdata",    rqopdata);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "I_p1004", "TRANSACTION", "setRfqChange", obj);
    		gdRes = this.setRfqCreateGdRes(value, message);
    	}
    	catch(Exception e){
    		gdRes = new GridData();//결과를 XML형태로 보내주기 위해 생성
    		gdRes.setSelectable(false);//true : 커넥션 / false : 트랜잭션
    		
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
    	String                    rqdtSeq         = null;
    	String                    iCreateType     = header.get("I_CREATE_TYPE");
    	List<Map<String, String>> grid            = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	List<Map<String, String>> rqdtdata       = new ArrayList<Map<String, String>>();
    	int                       i               = 0;
    	int                       gridSize        = grid.size();
    	
    	for(i = 0; i < gridSize; i++){
			servletParam = new HashMap<String, Object>();
			
			gridInfo       = grid.get(i);
			rqdtSeq = String.valueOf(i + 1);
			
			
			switch(Integer.parseInt(gridInfo.get("ITEM_NO")))
		    {
		        case 1: // 'd'
		        	rqdtdata = this.setRfqCreateRqdtdata1(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;

		        case 2:
		        	rqdtdata = this.setRfqCreateRqdtdata2(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;

		        case 3:
		        	rqdtdata = this.setRfqCreateRqdtdata3(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;

		        case 4:
		        	rqdtdata = this.setRfqCreateRqdtdata4(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;

		        case 5:
		        	rqdtdata = this.setRfqCreateRqdtdata5(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;
		        case 6:
		        	rqdtdata = this.setRfqCreateRqdtdata6(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;
		        case 7:
		        	rqdtdata = this.setRfqCreateRqdtdata7(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;
		        case 8:
		        	rqdtdata = this.setRfqCreateRqdtdata8(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;
		        case 9:
		        	rqdtdata = this.setRfqCreateRqdtdata9(rqdtdata, gridInfo, info, rfqNo, rfqCount, rqdtSeq);   			
		            break;
		    }
			
			
		}
    	
//    	ICOYRQDT1_ICT
    	
    	result.put("rqdtdata",  rqdtdata);
    	
    	return result;
    }
    
    private List<Map<String, String>> setRfqCreateRqopdata(SepoaInfo info, Map<String, String> header, String rfqNo, String rfqCount, List<Map<String, String>> rqopdata) throws Exception{
    	String              vendorSelectedDatasInfo   = null;
    	String              vendorDatasFirstTrim      = null;
    	String              id                        = info.getSession("ID");
    	String              nameLoc                   = info.getSession("NAME_LOC");
    	String              shortDateString           = SepoaDate.getShortDateString();
		String              shortTimeString           = SepoaDate.getShortTimeString();
		
		String[]            vendorSelectedDatas       = CommonUtil.getTokenData(header.get("vendor_info"), "#");
				
		String[]            vendorDatas               = null;
		Map<String, String> tmpRqop                   = null;
		int                 vendorSelectedDatasLength = vendorSelectedDatas.length;
		int                 j                         = 0;
		String              rfqSeq                    = null;
    	
				
    	for(j = 0; j < vendorSelectedDatasLength; j++){
    		tmpRqop = new HashMap<String, String>();
    		
    		vendorSelectedDatasInfo = vendorSelectedDatas[j];
			vendorDatas             = CommonUtil.getTokenData(vendorSelectedDatasInfo, "@");
			vendorDatasFirstTrim    = vendorDatas[0].trim();
			
			rfqSeq = String.valueOf(j + 1);
			
			tmpRqop.put("RFQ_NO"          ,        rfqNo);
			tmpRqop.put("RFQ_COUNT"       ,        rfqCount);
			tmpRqop.put("RFQ_SEQ"         ,        rfqSeq);
			tmpRqop.put("STATUS"          ,        "C");
			tmpRqop.put("VENDOR_CODE"     ,        vendorDatasFirstTrim);
//			tmpRqop.put("MDL_ID"          ,        "");
//			tmpRqop.put("MDL_NM"          ,        "");
//			tmpRqop.put("ATTACH_NO"       ,        "");
			tmpRqop.put("ADD_USER_ID"     ,        id);
			tmpRqop.put("ADD_USER_NAME"   ,        nameLoc);
			tmpRqop.put("ADD_DATE"        ,        shortDateString);
			tmpRqop.put("ADD_TIME"        ,        shortTimeString);
			tmpRqop.put("CHANGE_USER_ID"  ,        id);
			tmpRqop.put("CHANGE_USER_NAME",        nameLoc);
			tmpRqop.put("CHANGE_DATE"     ,        shortDateString);
			tmpRqop.put("CHANGE_TIME"     ,        shortTimeString);
			
			
			rqopdata.add(tmpRqop);
		}
    	
		return rqopdata;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata1(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));
		rqdttemp.put("EQPM"                 ,"선택".equals(gridInfo.get("EQPM"               ))?"":gridInfo.get("EQPM"               ));
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));
		rqdttemp.put("OS"                   ,"선택".equals(gridInfo.get("OS"                 ))?"":gridInfo.get("OS"                 ));
		rqdttemp.put("CPU"                  ,gridInfo.get("CPU"                ));
		rqdttemp.put("MEM"                  ,gridInfo.get("MEM"                ));
		rqdttemp.put("INTERNALDISK_TYPE"    ,"선택".equals(gridInfo.get("INTERNALDISK_TYPE"  ))?"":gridInfo.get("INTERNALDISK_TYPE"  ));
		rqdttemp.put("INTERNALDISK_CPT_CN"  ,gridInfo.get("INTERNALDISK_CPT_CN"));
		rqdttemp.put("INTERNALDISK_CNT_CN"  ,gridInfo.get("INTERNALDISK_CNT_CN"));
		rqdttemp.put("NIC_TYPE"             ,"선택".equals(gridInfo.get("NIC_TYPE"           ))?"":gridInfo.get("NIC_TYPE"           ));
		rqdttemp.put("NIC_PORT_CN"          ,"선택".equals(gridInfo.get("NIC_PORT_CN"        ))?"":gridInfo.get("NIC_PORT_CN"        ));
		rqdttemp.put("NIC_CD_CN"            ,gridInfo.get("NIC_CD_CN"          ));
		rqdttemp.put("HBA_TYPE"             ,"선택".equals(gridInfo.get("HBA_TYPE"           ))?"":gridInfo.get("HBA_TYPE"           ));
		rqdttemp.put("HBA_PORT_CN"          ,"선택".equals(gridInfo.get("HBA_PORT_CN"        ))?"":gridInfo.get("HBA_PORT_CN"        ));
		rqdttemp.put("HBA_CD_CN"            ,gridInfo.get("HBA_CD_CN"          ));
		rqdttemp.put("CLUSTER_DIS"          ,"선택".equals(gridInfo.get("CLUSTER_DIS"        ))?"":gridInfo.get("CLUSTER_DIS"        ));
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata2(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));
		rqdttemp.put("EQPM"                 ,"선택".equals(gridInfo.get("EQPM"               ))?"":gridInfo.get("EQPM"               ));
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));			
		rqdttemp.put("PT_MK_YN"             ,"선택".equals(gridInfo.get("PT_MK_YN"           ))?"":gridInfo.get("PT_MK_YN"                 ));
		rqdttemp.put("PT_CN"                ,gridInfo.get("PT_CN"                ));		
		rqdttemp.put("CPU"                  ,gridInfo.get("CPU"                ));
		rqdttemp.put("MEM"                  ,gridInfo.get("MEM"                ));		
		rqdttemp.put("INTERNALDISK_TYPE"    ,"선택".equals(gridInfo.get("INTERNALDISK_TYPE"  ))?"":gridInfo.get("INTERNALDISK_TYPE"  ));
		rqdttemp.put("INTERNALDISK_CPT_CN"  ,gridInfo.get("INTERNALDISK_CPT_CN"));
		rqdttemp.put("INTERNALDISK_CNT_CN"  ,gridInfo.get("INTERNALDISK_CNT_CN"));		
		rqdttemp.put("NIC_TYPE"             ,"선택".equals(gridInfo.get("NIC_TYPE"           ))?"":gridInfo.get("NIC_TYPE"           ));
		rqdttemp.put("NIC_PORT_CN"          ,"선택".equals(gridInfo.get("NIC_PORT_CN"        ))?"":gridInfo.get("NIC_PORT_CN"        ));
		rqdttemp.put("NIC_CD_CN"            ,gridInfo.get("NIC_CD_CN"          ));		
		rqdttemp.put("HBA_TYPE"             ,"선택".equals(gridInfo.get("HBA_TYPE"           ))?"":gridInfo.get("HBA_TYPE"           ));
		rqdttemp.put("HBA_PORT_CN"          ,"선택".equals(gridInfo.get("HBA_PORT_CN"        ))?"":gridInfo.get("HBA_PORT_CN"        ));
		rqdttemp.put("HBA_CD_CN"            ,gridInfo.get("HBA_CD_CN"          ));		
		rqdttemp.put("CLUSTER_DIS"          ,"선택".equals(gridInfo.get("CLUSTER_DIS"        ))?"":gridInfo.get("CLUSTER_DIS"        ));
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata3(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));
		rqdttemp.put("EQPM"                 ,"선택".equals(gridInfo.get("EQPM"               ))?"":gridInfo.get("EQPM"               ));
		rqdttemp.put("EQPM_DIS"             ,"선택".equals(gridInfo.get("EQPM_DIS"               ))?"":gridInfo.get("EQPM_DIS"               ));
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));					
		rqdttemp.put("CACHE_MEM"            ,gridInfo.get("CACHE_MEM"          ));
		rqdttemp.put("DISK_TYPE"            ,"선택".equals(gridInfo.get("DISK_TYPE"  ))?"":gridInfo.get("DISK_TYPE"  ));
		rqdttemp.put("DISK_CPT_CN"          ,gridInfo.get("DISK_CPT_CN"            ));				
		rqdttemp.put("USABLE_CPT_CN"        ,gridInfo.get("USABLE_CPT_CN"));		
		rqdttemp.put("RAID"                 ,"선택".equals(gridInfo.get("RAID"           ))?"":gridInfo.get("RAID"           ));
		rqdttemp.put("FRONT_PROT_TYPE"      ,"선택".equals(gridInfo.get("FRONT_PROT_TYPE"        ))?"":gridInfo.get("FRONT_PROT_TYPE"        ));
		rqdttemp.put("FRONT_PROT_CNT_CN"    ,gridInfo.get("FRONT_PROT_CNT_CN"          ));		
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata4(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));		
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("PRD_DIS"              ,"선택".equals(gridInfo.get("PRD_DIS"  ))?"":gridInfo.get("PRD_DIS"  ));
		rqdttemp.put("EDITION_DIS"          ,"선택".equals(gridInfo.get("EDITION_DIS"  ))?"":gridInfo.get("EDITION_DIS"  ));
		rqdttemp.put("EQPM_DIS"             ,"선택".equals(gridInfo.get("EQPM_DIS"           ))?"":gridInfo.get("EQPM_DIS"           ));		
		rqdttemp.put("SA_YANG"               ,gridInfo.get("SA_YANG"             ));					
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));					
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata5(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));		
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("EDITION_DIS"          ,"선택".equals(gridInfo.get("EDITION_DIS"  ))?"":gridInfo.get("EDITION_DIS"  ));
		rqdttemp.put("EQPM_DIS"             ,"선택".equals(gridInfo.get("EQPM_DIS"           ))?"":gridInfo.get("EQPM_DIS"           ));		
		rqdttemp.put("SA_YANG"               ,gridInfo.get("SA_YANG"             ));					
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));					
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata6(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));		
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("EQPM_DIS"             ,"선택".equals(gridInfo.get("EQPM_DIS"           ))?"":gridInfo.get("EQPM_DIS"           ));		
		rqdttemp.put("SA_YANG"               ,gridInfo.get("SA_YANG"             ));					
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));					
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }

    private List<Map<String, String>> setRfqCreateRqdtdata7(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));		
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("EQPM_DIS"             ,"선택".equals(gridInfo.get("EQPM_DIS"           ))?"":gridInfo.get("EQPM_DIS"           ));		
		rqdttemp.put("SA_YANG"               ,gridInfo.get("SA_YANG"             ));					
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));					
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata8(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));		
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("EQPM_DIS"             ,"선택".equals(gridInfo.get("EQPM_DIS"           ))?"":gridInfo.get("EQPM_DIS"           ));		
		rqdttemp.put("SA_YANG"               ,gridInfo.get("SA_YANG"             ));					
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));					
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
    
    private List<Map<String, String>> setRfqCreateRqdtdata9(List<Map<String, String>> rqdt1data, Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rqdtSeq) throws Exception{
    	Map<String, String> rqdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		String              nameLoc         = info.getSession("NAME_LOC");
    	
		rqdttemp.put("RFQ_NO"               ,rfqNo);
		rqdttemp.put("RFQ_COUNT"            ,rfqCount);
		rqdttemp.put("RQDT_SEQ"             ,rqdtSeq);
		rqdttemp.put("STATUS"               ,"C");
		rqdttemp.put("ITEM_NO"              ,gridInfo.get("ITEM_NO"            ));
		rqdttemp.put("OP_DIS"               ,"선택".equals(gridInfo.get("OP_DIS"             ))?"":gridInfo.get("OP_DIS"             ));		
		rqdttemp.put("USG"                  ,gridInfo.get("USG"                ));
		rqdttemp.put("OS_DIS"             ,"선택".equals(gridInfo.get("OS_DIS"           ))?"":gridInfo.get("OS_DIS"           ));		
		rqdttemp.put("SA_YANG"               ,gridInfo.get("SA_YANG"             ));					
		rqdttemp.put("CNT_CN"               ,gridInfo.get("CNT_CN"             ));					
		rqdttemp.put("ETC"                  ,gridInfo.get("ETC"                ));
		
		rqdt1data.add(rqdttemp);
		
		return rqdt1data;
    }
        
    private List<Map<String, String>> setRfqCreateRqhddata(SepoaInfo info, Map<String, String> header, String rfqNo, String rfqCount ,String iRfqStatus, String signStatus) throws Exception{
    	List<Map<String, String>> rqhddata        = new ArrayList<Map<String, String>>();
    	Map<String, String>       rqhdtemp        = new HashMap<String, String>();
    	String                    id              = info.getSession("ID");
    	String                    nameLoc         = info.getSession("NAME_LOC");
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	
    	
    	rqhdtemp.put("PFLAG",         header.get("I_PFLAG"));
		rqhdtemp.put("RFQ_NO",        rfqNo);
		rqhdtemp.put("RFQ_COUNT",     rfqCount);
		rqhdtemp.put("RFQ_NM",        header.get("I_RFQ_NM"));
		rqhdtemp.put("BIZ_NO",        header.get("I_BIZ_NO"));
		rqhdtemp.put("STATUS",           "R");				
		rqhdtemp.put("RFQ_STATUS",    header.get("I_RFQ_STATUS"));
		rqhdtemp.put("ITEM_NO",       header.get("I_ITEM_NO"));
		rqhdtemp.put("ITEM_CN",       header.get("I_ITEM_CN"));
		
		rqhdtemp.put("RFQ_DATE",      shortDateString);
		rqhdtemp.put("RFQ_CLOSE_DATE",header.get("I_RFQ_CLOSE_DATE").replaceAll("/", ""));
		rqhdtemp.put("RFQ_CLOSE_TIME",header.get("I_RFQ_CLOSE_TIME"));		
		rqhdtemp.put("RMK_TXT",       header.get("I_RMK_TXT"));
		rqhdtemp.put("RFQ_ID"        ,header.get("I_RFQ_ID"));
		rqhdtemp.put("RFQ_NAME"      ,header.get("I_RFQ_NAME"));		
		
		rqhdtemp.put("SIGN_DATE",        shortDateString);
		rqhdtemp.put("SIGN_PERSON_ID",   id);
		rqhdtemp.put("SIGN_PERSON_NAME", nameLoc);
		rqhdtemp.put("SIGN_STATUS",      "E");
		
		rqhdtemp.put("ADD_USER_ID",   id);
		rqhdtemp.put("ADD_USER_NAME", nameLoc);
		rqhdtemp.put("ADD_DATE",      shortDateString);
		rqhdtemp.put("ADD_TIME",      shortTimeString);
		
		rqhdtemp.put("CHANGE_USER_ID",   id);
		rqhdtemp.put("CHANGE_USER_NAME", nameLoc);
		rqhdtemp.put("CHANGE_DATE",      shortDateString);
		rqhdtemp.put("CHANGE_TIME",      shortTimeString);
		
		rqhddata.add(rqhdtemp);
    	
    	return rqhddata;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap setRfqCreateMessage(SepoaInfo info) throws Exception{
    	Vector  multilangId = new Vector();
    	HashMap message     = null;
    	
    	multilangId.addElement("MESSAGE");
    	   
    	message = MessageUtil.getMessage(info, multilangId);
    	
    	return message;
    }
    
    @SuppressWarnings("rawtypes")
	private GridData setRfqCreateGdRes(SepoaOut value, HashMap message) throws Exception{
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
    
    private String setRfqCreateIRfgStatus(String iRfqStatus) throws Exception{
    	String result = null;
    	
    	iRfqStatus = this.nvl(iRfqStatus);
    	
    	if ("T".equals(iRfqStatus)) { // 작성중
    		result   = "T"; // 작성중
		}
		else if ("P".equals(iRfqStatus)) { // 업체전송
			result   = "B"; // 견적중
		}
		else { // 업체전송
			result   = "E"; // 견적마감
		}
    	
    	return result;
    }
    
    private String setRfqCreateSignStatus(String iRfqStatus) throws Exception{
    	String result = null;
    	
    	iRfqStatus = this.nvl(iRfqStatus);
    	
    	if ("T".equals(iRfqStatus)) { // 작성중
    		result = "T"; // 작성중
		}
		else if ("P".equals(iRfqStatus)) { // 결재요청
			result = "P"; // 결재중
		}
		else { // 업체전송
			result = "E"; // 결재완료
		}
    	
    	return result;
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