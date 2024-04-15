package dt.rat;

import java.util.*;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

import java.io.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rat_bd_ins1 extends HttpServlet {
	
	
	private static final long serialVersionUID = 1L;

	public void init(javax.servlet.ServletConfig config) throws ServletException {Logger.debug.println();}
	    
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
    		
    		if("getratbdupd1_1".equals(mode)){ // 역경매 대상 상세조회
    			gdRes = this.getratbdupd1_1(gdReq, info);
    		}
    		else if("getRADTDisplay".equals(mode)){ // 역경매 대상 품목 조회
    			gdRes = this.getRADTDisplay(gdReq, info);
    		}
    		else if("getPrDTDisplay_VAT".equals(mode)){ // 역경매 대상 품목 조회
    			gdRes = this.getPrDTDisplay_VAT(gdReq, info);
    		}
    		else if("setGonggoCreate".equals(mode)){ // 역경매 임시저장
    			gdRes = this.setGonggoCreate(gdReq, info);
    		}
    		else if("setGonggoConfirm".equals(mode)){ // 역경매 확정
    			gdRes = this.setGonggoConfirm(gdReq, info);
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
	private GridData getratbdupd1_1(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "p1008", "CONNECTION","getratbdupd1_1", obj);
	
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
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData getRADTDisplay(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p1008", "CONNECTION","getRADTDisplay", obj);
    		
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
    
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData getPrDTDisplay_VAT(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p1001", "CONNECTION","getPrDTDisplay_VAT", obj);
    		
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
    

	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setGonggoCreate(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p1008", "TRANSACTION", "setratbdins1_1",       obj);
    		
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
	private GridData setGonggoConfirm(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "p1008", "TRANSACTION", "setGonggoConfirm",       obj);
			
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

    public String checkNull(String value) {
        if(value == null) {value = null;}
        else if("".equals(value.trim())) { value = null;}
        return value;
    }

//    public void doQuery(WiseStream ws) throws Exception {
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        String mode = ws.getParam("mode");
//        Logger.debug.println(info.getSession("ID"), this, "################################111111111111111");
//
//        if(mode.equals("getPrDTDisplay_VAT")) {
//        	
//            String pr_no = ws.getParam("PR_NO");
//            String REQ_PR_SEQ   = ws.getParam("REQ_PR_SEQ");
//            String ITEM_FIND    = ws.getParam("ITEM_FIND");
//
//            if(pr_no == null)
//                pr_no = "";
//
//            if(REQ_PR_SEQ == null)
//                REQ_PR_SEQ = "";
//
//            if(ITEM_FIND == null)
//                ITEM_FIND = "";
//
//            Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!!!REQ_PR_SEQ============>"+REQ_PR_SEQ);
//            Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!!!PR_NO============>"+pr_no);
//
//            WiseOut out = getPrDTDisplay_VAT(info, pr_no, REQ_PR_SEQ, ITEM_FIND);
//
//            WiseFormater wf = ws.getWiseFormater(out.result[0]);
//
//            if(wf == null) { //����Ÿ ������ ��Ȯ���� �������
//                ws.setCode("M001");
//                ws.setMessage("����Ÿ ������ ��Ȯ���� �ʽ��ϴ�.");
//                ws.write();
//
//                return;
//            }
//
//            if(wf.getRowCount() == 0) { //����Ÿ�� ��� ���
//                ws.setCode("M001");
//                ws.setMessage("��ȸ�� ����Ÿ�� ����ϴ�.");
//                ws.write();
//
//                return;
//            }
//
////            wiseservlet.WiseCombo combo_d = new wiseservlet.WiseCombo();
////            String combo_CUR[][] = combo_d.getCombo(ws.getRequest(), "SL0034", info.getSession("HOUSE_CODE") + "#" +"M002#", null); // ���
//
//            for(int i=0; i<wf.getRowCount(); i++) { //����Ÿ�� �ִ� ���
////                int index_CUR = combo_d.getIndex( wf.getValue("CCY", i ) );
////                String tmp_CUR = wf.getValue( "CCY", i);
//
//                String[] check = {"true", ""};                                                                      //CheckBox
//                String[] img_item_no  = {"", wf.getValue("ITEM_NO",i), wf.getValue("ITEM_NO",i)};	
//                String[] img_pr_no = {"",wf.getValue("PR_NO",i),wf.getValue("PR_NO",i)};
//                String[] img_vendor_selected  = {"/kr/images/button/detail.gif", "", ""};
//                ws.addValue("SELECTED", check, "");                                                                      //üũ�ڽ�
//                
//                ws.addValue("PR_NO"				,	img_pr_no    						, "" );
//                ws.addValue("PR_SEQ"			,   wf.getValue("PR_SEQ"			,i) , "" );
//                ws.addValue("DESCRIPTION_LOC"	,  	wf.getValue("DESCRIPTION_LOC"   ,i) , "" );
//                ws.addValue("UNIT_MEASURE"		,   wf.getValue("UNIT_MEASURE"      ,i) , "" );
//                ws.addValue("SPECIFICATION"		,   wf.getValue("SPECIFICATION"     ,i) , "" );
//                ws.addValue("ITEM_NO"			,   img_item_no    						, "" );
//                ws.addValue("QTY"				,   wf.getValue("PR_QTY"            ,i) , "" );
////                ws.addValue("CUR",              combo_CUR, tmp_CUR, index_CUR );
//                ws.addValue("CUR"				,   wf.getValue("CCY"               ,i) , "" );
//                ws.addValue("UNIT_PRICE"		,   wf.getValue("UNIT_PRICE"        ,i) , "" );
//                ws.addValue("AMT"				,   wf.getValue("PR_AMT"         	,i) , "" );
//                ws.addValue("RD_DATE"			,   wf.getValue("RD_DATE"			,i) , "" );
//                ws.addValue("MAKER_CODE"		,   wf.getValue("MAKER_CODE"		,i) , "" );
//                ws.addValue("MAKER_NAME"		,   wf.getValue("MAKER_NAME"		,i) , "" );
//                ws.addValue("VENDOR_SELECTED",    img_vendor_selected                      , "" );
//                
//                /*
//                ws.addValue("PR_NO",            wf.getValue("PR_NO"             ,i)    , "" );
//                ws.addValue("PR_SEQ",           wf.getValue("PR_SEQ"            ,i)    , "" );
//                ws.addValue("DESCRIPTION_LOC",  wf.getValue("GDSNM"             ,i)    , "" );
//                ws.addValue("UNIT_MEASURE",     wf.getValue("UNIT"              ,i)    , "" );
//                ws.addValue("SPECIFICATION",     wf.getValue("DET"              ,i)    , "" );
//                ws.addValue("ITEM_NO",     wf.getValue("ITEM_NO"              ,i)    , "" );
//                ws.addValue("QTY",              wf.getValue("QTY"               ,i)    , "" );
////                ws.addValue("CUR",              combo_CUR, tmp_CUR, index_CUR );
//                ws.addValue("CUR",              wf.getValue("CCY"               ,i)    , "" );
//                ws.addValue("UNIT_PRICE",       wf.getValue("ASUMTNPRC"         ,i)    , "" );
//                ws.addValue("AMT",              wf.getValue("ASUMTNAMT"         ,i)    , "" );
//                */
//            }
//
//        } else if(mode.equals("getRADTDisplay")) {
//
//            String RA_NO       = ws.getParam("RA_NO");
//            String RA_COUNT    = ws.getParam("RA_COUNT");
//
//            Logger.debug.println(info.getSession("ID"), this, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//
//            if(RA_NO==null) RA_NO="";
//            if(RA_COUNT==null) RA_COUNT="";
//
//            WiseOut out = getBDDTDisplay(info, RA_NO, RA_COUNT);
//
//            Logger.debug.println(info.getSession("ID"), this, "out====================>"+out);
//            WiseFormater wf = ws.getWiseFormater(out.result[0]);
//
//            if(wf == null) { //����Ÿ ������ ��Ȯ���� �������
//                ws.setCode("M001");
//                ws.setMessage("����Ÿ ������ ��Ȯ���� �ʽ��ϴ�.");
//                ws.write();
//
//                return;
//            }
//
//            if(wf.getRowCount() == 0) { //����Ÿ�� ��� ���
//                ws.setCode("M001");
//                ws.setMessage("��ȸ�� ����Ÿ�� ����ϴ�.");
//                ws.write();
//
//                return;
//            }
//
////            wiseservlet.WiseCombo combo_d = new wiseservlet.WiseCombo();
////            String combo_CUR[][] = combo_d.getCombo(ws.getRequest(), "SL0034", info.getSession("HOUSE_CODE") + "#" +"M002#", null); // ���
//
//            for(int i=0; i<wf.getRowCount(); i++) { //����Ÿ�� �ִ� ���
////                int index_CUR = combo_d.getIndex( wf.getValue("CUR", i ) );
////                String tmp_CUR = wf.getValue( "CUR", i);
//
//                String[] check = {"true", ""};                                                                      //CheckBox
//                String[] img_item_no  = {"", wf.getValue("BUYER_ITEM_NO",i), wf.getValue("BUYER_ITEM_NO",i)};	
//                String[] img_pr_no = {"",wf.getValue("PR_NO",i),wf.getValue("PR_NO",i)};
//                String[] img_vendor_selected  = {"/kr/images/button/detail.gif", "", ""};
//                ws.addValue("SELECTED", check, "");                                                                      //üũ�ڽ�
//
//                ws.addValue("PR_NO",            img_pr_no    , "" );
//                ws.addValue("PR_SEQ",           wf.getValue("PR_SEQ"            ,i)    , "" );
//                ws.addValue("DESCRIPTION_LOC",  wf.getValue("DESCRIPTION_LOC"   ,i)    , "" );
//                ws.addValue("UNIT_MEASURE",     wf.getValue("UNIT_MEASURE"      ,i)    , "" );
//                ws.addValue("SPECIFICATION", wf.getValue("SPECIFICATION"        ,i)    , "" );
//                ws.addValue("ITEM_NO",       img_item_no    , "" );
//                ws.addValue("QTY",              wf.getValue("RA_QTY"            ,i)    , "" );
////                ws.addValue("CUR",              combo_CUR, tmp_CUR, index_CUR );
//                ws.addValue("CUR",           wf.getValue("CUR"        ,i)    , "" );
//                ws.addValue("UNIT_PRICE",       wf.getValue("UNIT_PRICE"        ,i)    , "" );
//                ws.addValue("AMT",              wf.getValue("PR_AMT"            ,i)    , "" );
//                ws.addValue("RD_DATE",          wf.getValue("RD_DATE"            ,i)    , "" );
//                ws.addValue("MAKER_CODE"		,   wf.getValue("MAKER_CODE"		,i) , "" );
//                ws.addValue("MAKER_NAME"		,   wf.getValue("MAKER_NAME"		,i) , "" );
//                ws.addValue("VENDOR_SELECTED",    img_vendor_selected                      , "" );
//                /*
//                ws.addValue("PR_NO",            wf.getValue("PR_NO"             ,i)    , "" );
//                ws.addValue("PR_SEQ",           wf.getValue("PR_SEQ"            ,i)    , "" );
//                ws.addValue("DESCRIPTION_LOC",  wf.getValue("DESCRIPTION_LOC"             ,i)    , "" );
//                ws.addValue("UNIT_MEASURE",     wf.getValue("UNIT_MEASURE"              ,i)    , "" );
//                ws.addValue("SPECIFICATION",     wf.getValue("SPECIFICATION"              ,i)    , "" );
//                ws.addValue("ITEM_NO",     img_item_no    , "" );
//                //ws.addValue("ITEM_NO",     wf.getValue("ITEM_NO"              ,i)    , "" );
//                ws.addValue("QTY",              wf.getValue("PR_QTY"               ,i)    , "" );
////                ws.addValue("CUR",              combo_CUR, tmp_CUR, index_CUR );
//                ws.addValue("CUR",              wf.getValue("CCY"               ,i)    , "" );
//                ws.addValue("UNIT_PRICE",       wf.getValue("UNIT_PRICE"         ,i)    , "" );
//                ws.addValue("AMT",              wf.getValue("PR_AMT"         ,i)    , "" );
//                */
//                
//            }
//        }
//
//        ws.setCode("M001");
//        ws.setMessage("���������� �۾��� �����Ͽ����ϴ�..");
//        ws.write();
//    }
//
//
//    public void doData(WiseStream ws) throws Exception{
//        //session ������ �����´�.
//        WiseInfo info   = WiseSession.getAllValue(ws.getRequest());
//        WiseFormater wf = ws.getWiseFormater();
//        Logger.debug.println(info.getSession("ID"), this, "############################################################");
//
//
//        String house_code       = info.getSession("HOUSE_CODE");
//        String company_code     = info.getSession("COMPANY_CODE");
//        String user_id          = info.getSession("ID");
//        String name_loc         = info.getSession("NAME_LOC");
//        String name_eng         = info.getSession("NAME_ENG");
//        String department       = info.getSession("DEPARTMENT");
//
//        WiseOut value = null;
//        String mode = ws.getParam("mode");
//        Logger.debug.println(info.getSession("ID"), this,"mode=========>"+mode );
//
//        String type             = ws.getParam("type");
//        String msg              = ws.getParam("msg");
//
//        String RA_NO            = ws.getParam("RA_NO");
//        String RA_COUNT         = ws.getParam("RA_COUNT");
//        String ANN_NO           = ws.getParam("ANN_NO");
//        String RA_FLAG          = ws.getParam("RA_FLAG");
//        String ANN_DATE         = ws.getParam("ANN_DATE");
//        String SUBJECT          = ws.getParam("SUBJECT");
//        String START_DATE       = ws.getParam("START_DATE");
//        String START_TIME       = ws.getParam("START_TIME");
//        String END_DATE         = ws.getParam("END_DATE");
//        String END_TIME         = ws.getParam("END_TIME");
//        String CUR              = ws.getParam("CUR");
//        String RESERVE_PRICE    = ws.getParam("RESERVE_PRICE");
//        String BID_DEC_AMT      = ws.getParam("BID_DEC_AMT");
//        String LIMIT_CRIT       = ws.getParam("LIMIT_CRIT");
//        String PROM_CRIT        = ws.getParam("PROM_CRIT");
//        String REMARK           = ws.getParam("REMARK");
//        String ATTACH_NO        = ws.getParam("ATTACH_NO");
//        String VENDOR_VALUES    = ws.getParam("VENDOR_VALUES");
//        String CTRL_CODE        = ws.getParam("CTRL_CODE");
//        String RA_TYPE1         = ws.getParam("RA_TYPE1");
//        String RA_TYPE2         = ws.getParam("RA_TYPE2");
//        String CREATE_TYPE      = ws.getParam("CREATE_TYPE");
//        String SHIPPER_TYPE     = ws.getParam("SHIPPER_TYPE");
//        String CREATE_FLAG      = ws.getParam("CREATE_FLAG");
//        String SIGN_STATUS      = ws.getParam("SIGN_STATUS");
//
//        String CONT_TYPE_TEXT   = ws.getParam("CONT_TYPE_TEXT");
//        String CONT_PLACE      	= ws.getParam("CONT_PLACE");
//        String BID_PAY_TEXT     = ws.getParam("BID_PAY_TEXT");
//        String BID_CANCEL_TEXT  = ws.getParam("BID_CANCEL_TEXT");
//        String BID_JOIN_TEXT  	= ws.getParam("BID_JOIN_TEXT");
//        String RA_ETC      		= ws.getParam("RA_ETC");
//        String LOCATION_VALUES  = ws.getParam("LOCATION_VALUES");
//        String FROM_LOWER_BND  	= ws.getParam("FROM_LOWER_BND");
//
//        //String RD_DATE  		= ws.getParam("RD_DATE");
//        String DELY_PLACE  		= ws.getParam("DELY_PLACE");
//        
//        String OPEN_REQ_FROM_DATE = ws.getParam("OPEN_REQ_FROM_DATE");
//        String OPEN_REQ_TO_DATE = ws.getParam("OPEN_REQ_TO_DATE");
//        
//        String PROM_CRIT_TYPE = ws.getParam("PROM_CRIT_TYPE");
//        
//        String approval_str = ws.getParam("approval_str");
//        String ModifyFlag = ws.getParam("ModifyFlag");
//        
//        Logger.debug.println(info.getSession("ID"), this, "######################3RA_NO ==>"+RA_NO);
//
//        type            = checkNull(type);
//        msg             = checkNull(msg);
//
//        RA_NO           = checkNull(RA_NO);
//        RA_COUNT        = checkNull(RA_COUNT);
//        ANN_NO          = checkNull(ANN_NO);
//        ANN_DATE        = checkNull(ANN_DATE);
//        SUBJECT         = checkNull(SUBJECT);
//        START_DATE      = checkNull(START_DATE);
//        START_TIME      = checkNull(START_TIME);
//        END_DATE        = checkNull(END_DATE);
//        END_TIME        = checkNull(END_TIME);
//        CUR             = checkNull(CUR);
//        RESERVE_PRICE   = checkNull(RESERVE_PRICE);
//        BID_DEC_AMT     = checkNull(BID_DEC_AMT);
//        LIMIT_CRIT      = checkNull(LIMIT_CRIT);
//        PROM_CRIT       = checkNull(PROM_CRIT);
//        REMARK          = checkNull(REMARK);
//        ATTACH_NO       = checkNull(ATTACH_NO);
//        VENDOR_VALUES   = null2Void(VENDOR_VALUES);
//        CTRL_CODE       = checkNull(CTRL_CODE);
//        RA_TYPE1        = checkNull(RA_TYPE1);
//        RA_TYPE2        = checkNull(RA_TYPE2);
//        CREATE_TYPE     = checkNull(CREATE_TYPE);
//        SHIPPER_TYPE    = checkNull(SHIPPER_TYPE);
//        CREATE_FLAG     = checkNull(CREATE_FLAG);
//        SIGN_STATUS     = checkNull(SIGN_STATUS);
//        CONT_TYPE_TEXT  = checkNull(CONT_TYPE_TEXT);
//        CONT_PLACE     	= checkNull(CONT_PLACE);
//        BID_PAY_TEXT    = checkNull(BID_PAY_TEXT);
//        BID_CANCEL_TEXT = checkNull(BID_CANCEL_TEXT);
//        BID_JOIN_TEXT   = checkNull(BID_JOIN_TEXT);
//        RA_ETC     		= checkNull(RA_ETC);
//        LOCATION_VALUES = null2Void(LOCATION_VALUES);
//        FROM_LOWER_BND 	= null2Void(FROM_LOWER_BND);
//
//        //RD_DATE 		= null2Void(RD_DATE);
//        DELY_PLACE 		= null2Void(DELY_PLACE);
//        
//        OPEN_REQ_FROM_DATE 		= null2Void(OPEN_REQ_FROM_DATE);
//        OPEN_REQ_TO_DATE 		= null2Void(OPEN_REQ_TO_DATE);
//        
//        PROM_CRIT_TYPE = checkNull(PROM_CRIT_TYPE);
//        
//        ModifyFlag = checkNull(ModifyFlag);
//
//        if(mode.equals("setGonggoCreate")) { // ������ ��
//            if(RA_COUNT == null) {
//                RA_COUNT = "1";
//            }
//
//            if(RA_NO == null) {
//                WiseOut wo1 = appcommon.getDocNumber(info,"RA");
//                RA_NO = wo1.result[0];
//                ANN_NO = RA_NO;
//            }
//          
//            String[] dataRAHD =   { house_code ,RA_NO ,RA_COUNT ,company_code ,user_id
//                                    ,name_loc ,name_eng ,department ,user_id ,name_loc
//                                    ,name_eng ,department ,SUBJECT ,SIGN_STATUS ,START_DATE
//                                    //,START_TIME ,END_DATE ,END_TIME 	,SIGN_STATUS,CREATE_TYPE
//                                    ,START_TIME ,END_DATE ,END_TIME 	,"P" 		,CREATE_TYPE
//                                    ,REMARK ,RESERVE_PRICE ,RESERVE_PRICE ,BID_DEC_AMT ,CUR
//                                    ,SHIPPER_TYPE ,"" ,CTRL_CODE ,RA_TYPE1 ,RA_TYPE2 ,"1"
//                                    ,type ,ANN_NO ,ANN_DATE ,LIMIT_CRIT ,PROM_CRIT_TYPE
//                                    ,ATTACH_NO,CONT_TYPE_TEXT,CONT_PLACE,BID_PAY_TEXT,BID_CANCEL_TEXT
//                                    ,BID_JOIN_TEXT,RA_ETC, FROM_LOWER_BND, DELY_PLACE,OPEN_REQ_FROM_DATE,OPEN_REQ_TO_DATE,PROM_CRIT};
//
//
//
//            String[][] dataRQSE = null;
//            String[][] dataBDRC = null;
//
//            int row_cnt =  0;
//            int row_cnt2 =  0;
//            StringTokenizer st = null;
//            if(RA_TYPE1.equals("NC")){
//                 st = new StringTokenizer(VENDOR_VALUES, "#", false);
//                 row_cnt = st.countTokens();
//            }
//            //Logger.debug.println(info.getSession("ID"), this, "######################VENDOR_VALUES ==>"+VENDOR_VALUES);
//            //Logger.debug.println(info.getSession("ID"), this, "######################3row_cnt ==>"+row_cnt);
//            if (row_cnt > 0) {
//                 //Logger.debug.println(info.getSession("ID"), this, "######################11111111111111111");
//                dataRQSE = new String[row_cnt][3];
//
//                for ( int k = 0 ; k < row_cnt ; k++ ) {
//                    StringTokenizer st1 = new StringTokenizer(st.nextToken().trim(), "@", false);
//                    //Logger.debug.println(info.getSession("ID"), this, "######################22222222222222222222222");
//                    String vendor_code  = st1.nextToken().trim();
//                    String vendor_name  = st1.nextToken().trim();
//
//                    String[] data_ven = { house_code ,vendor_code ,RA_NO ,RA_COUNT ,company_code
//                                         ,user_id ,/*name_loc ,name_eng ,department ,*/user_id
//                                         /*,name_loc ,name_eng, department, vendor_name*/};
//
//                    dataRQSE[k] = data_ven;
//                }
//            }
//
//            if(RA_TYPE1.equals("GC")){
//                 st = new StringTokenizer(LOCATION_VALUES, "#", false);
//                 row_cnt2 = st.countTokens();
//            }
//            if (row_cnt2 > 0) {
//                dataBDRC = new String[row_cnt2][3];
//                for ( int k = 0 ; k < row_cnt2 ; k++ ) {
//                    StringTokenizer st1 = new StringTokenizer(st.nextToken().trim(), "@", false);
//                    String code  = st1.nextToken().trim();
//                    String name  = st1.nextToken().trim();
//                    String[] data_ven = { house_code ,RA_NO ,RA_COUNT , code ,name };
//                    dataBDRC[k] = data_ven;
//                }
//            }
//
//
//
//            String[] DESCRIPTION_LOC    = wf.getValue("DESCRIPTION_LOC");
//            String[] UNIT_MEASURE       = wf.getValue("UNIT_MEASURE");
//            String[] QTY                = wf.getValue("QTY");
//            String[] CUR_DT             = wf.getValue("CUR");
//            String[] UNIT_PRICE         = wf.getValue("UNIT_PRICE");
//            String[] AMT                = wf.getValue("AMT");
//            String[] PR_NO_VALUE        = wf.getValue("PR_NO");
//            String[] PR_SEQ             = wf.getValue("PR_SEQ");
//
//            
//            String[] ITEM_NO             = wf.getValue("ITEM_NO");
//            String[] SPECIFICATION       = wf.getValue("SPECIFICATION");
//            String[] MAKER_CODE          = wf.getValue("MAKER_CODE");
//            String[] MAKER_NAME          = wf.getValue("MAKER_NAME");
//            
//            String[] RD_DATE             = wf.getValue("RD_DATE");
//            
//            String dataRADT[][] = new String[wf.getRowCount()][];
//            String dataPRDT[][] = new String[wf.getRowCount()][];
//
//
//            for (int i = 0; i < wf.getRowCount(); i++) {
//                String tmp_data[] = {
//
//                                    house_code,
//                                    RA_NO,
//                                    RA_COUNT,
//                                    user_id,
//                                    name_loc,
//                                    name_eng,
//                                    department,
//                                    user_id,
//                                    name_loc,
//                                    name_eng,
//                                    department,
//                                    String.valueOf(i+1),
//                                    DESCRIPTION_LOC[i],
//                                    QTY[i],
//                                    UNIT_MEASURE[i],
//                                    CUR_DT[i],
//                                    UNIT_PRICE[i],
//									//AMT[i],
//                                    PR_NO_VALUE[i],
//                                    PR_SEQ[i],
//                                    ITEM_NO[i],
//                                    SPECIFICATION[i],
//                                    RD_DATE[i],
//                                    MAKER_CODE[i],
//                                    MAKER_NAME[i],
//                };
//
//
//                dataRADT[i] = tmp_data;
//            }
//
//            for (int j = 0; j < wf.getRowCount(); j++) {
//                String tmp_data[] = {
//                                     house_code,
//                                     PR_NO_VALUE[j]
//                                     ,PR_SEQ[j]
//                                     };
//
//                dataPRDT[j] = tmp_data;
//            }
//            //Logger.err.println(info.getSession("ID"),this,"8888888888888888888888888888888888888888888888888888888888888888888" );
//             value = setGonggoCreate(info, dataRAHD, dataRADT, dataPRDT, dataRQSE, dataBDRC, approval_str, SIGN_STATUS, ModifyFlag);
//
//            String[] obj = new String[1];
//            ws.setMessage(value.message);
//            obj[0] = value.message;
//            //obj[1] = value.result[1];       // RA_NO
//            //obj[2] = value.result[2];       // RA_COUNT
//            //obj[3] = value.result[3];       // ann_no
//            //ws.setUserObject(obj);
///*
// * �ӽ����� �� ���� ��û or ���� �Ŀ� ������ �ٽ� ����
// * 
// */
//        
//        	
//        }else if(mode.equals("setGonggoModify")) { // ������ ����
//
//            /*String[] dataRAHD =
//            { user_id, name_loc ,name_eng ,department , SUBJECT ,SIGN_STATUS ,START_DATE
//             ,START_TIME ,END_DATE ,END_TIME ,"T", REMARK ,RESERVE_PRICE ,RESERVE_PRICE
//             ,BID_DEC_AMT ,CUR ,RA_TYPE1 , ANN_DATE ,LIMIT_CRIT ,ATTACH_NO};*/
//            String[] dataRAHD =
//                    { house_code ,RA_NO ,RA_COUNT ,company_code ,user_id
//                     ,name_loc ,name_eng ,department ,user_id ,name_loc
//                     ,name_eng ,department ,SUBJECT ,SIGN_STATUS ,START_DATE
//                     //,START_TIME ,END_DATE ,END_TIME ,SIGN_STATUS ,CREATE_TYPE
//                       ,START_TIME ,END_DATE ,END_TIME ,"P" 		,CREATE_TYPE
//                     ,REMARK ,RESERVE_PRICE ,RESERVE_PRICE ,BID_DEC_AMT ,CUR
//                     ,SHIPPER_TYPE ,"" ,CTRL_CODE ,RA_TYPE1 ,RA_TYPE2,"1"
//                     ,type ,ANN_NO ,ANN_DATE ,LIMIT_CRIT ,PROM_CRIT
//                     ,ATTACH_NO,CONT_TYPE_TEXT,CONT_PLACE,BID_PAY_TEXT,BID_CANCEL_TEXT
//                     ,BID_JOIN_TEXT,RA_ETC, FROM_LOWER_BND, DELY_PLACE};
//
//
//            String[][] dataRQSE = null;
//            String[][] dataBDRC = null;
//
//            int row_cnt =  0;
//            int row_cnt2 =  0;
//            StringTokenizer st = null;
//
//            if(RA_TYPE1.equals("NC")){
//                 st = new StringTokenizer(VENDOR_VALUES, "#", false);
//                 row_cnt = st.countTokens();
//            }
//
//            if (row_cnt > 0) {
//                dataRQSE = new String[row_cnt][3];
//
//                for ( int k = 0 ; k < row_cnt ; k++ ) {
//                    StringTokenizer st1 = new StringTokenizer(st.nextToken().trim(), "@", false);
//
//                    String vendor_code  = st1.nextToken().trim();
//                    String vendor_name  = st1.nextToken().trim();
//
//                    String[] data_ven = { house_code ,vendor_code ,RA_NO ,RA_COUNT ,company_code
//                                            ,user_id ,name_loc ,name_eng ,department ,user_id
//											,name_loc ,name_eng ,department, vendor_name};
//
//                    dataRQSE[k] = data_ven;
//                }
//            }
//
//            if(RA_TYPE1.equals("LC")){
//                 st = new StringTokenizer(LOCATION_VALUES, "#", false);
//                 row_cnt2 = st.countTokens();
//            }
//            if (row_cnt2 > 0) {
//                dataBDRC = new String[row_cnt2][3];
//
//                for ( int k = 0 ; k < row_cnt2 ; k++ ) {
//                    StringTokenizer st1 = new StringTokenizer(st.nextToken().trim(), "@", false);
//                    String code  = st1.nextToken().trim();
//                    String name  = st1.nextToken().trim();
//
//                    String[] data_ven = { house_code ,RA_NO ,RA_COUNT , code ,name };
//
//                    dataBDRC[k] = data_ven;
//                }
//            }
//
//            String[] DESCRIPTION_LOC    = wf.getValue("DESCRIPTION_LOC");
//            String[] UNIT_MEASURE       = wf.getValue("UNIT_MEASURE");
//            String[] QTY                = wf.getValue("QTY");
//            String[] CUR_DT             = wf.getValue("CUR");
//            String[] UNIT_PRICE         = wf.getValue("UNIT_PRICE");
//            String[] AMT                = wf.getValue("AMT");
//            String[] PR_NO_VALUE        = wf.getValue("PR_NO");
//            String[] PR_SEQ             = wf.getValue("PR_SEQ");
//            String[] ITEM_NO             = wf.getValue("ITEM_NO");
//            String[] SPECIFICATION             = wf.getValue("SPECIFICATION");
//
//            String dataRADT[][] = new String[wf.getRowCount()][];
//            String dataPRDT[][] = new String[wf.getRowCount()][];
//
//            for (int i = 0; i < wf.getRowCount(); i++) {
//                String tmp_data[] = {
//                                    house_code,
//                                    RA_NO,
//                                    RA_COUNT,
//                                    user_id,
//                                    name_loc,
//                                    name_eng,
//                                    department,
//                                    user_id,
//                                    name_loc,
//                                    name_eng,
//                                    department,
//                                    String.valueOf(i+1),
//                                    DESCRIPTION_LOC[i],
//                                    QTY[i],
//                                    UNIT_MEASURE[i],
//                                    CUR_DT[i],
//                                    UNIT_PRICE[i],
//                                    //AMT[i],
//                                    PR_NO_VALUE[i],
//                                    PR_SEQ[i],
//                                    ITEM_NO[i],
//                                    SPECIFICATION[i]
//                };
//
//
//                dataRADT[i] = tmp_data;
//            }
//
//            for (int j = 0; j < wf.getRowCount(); j++) {
//                String tmp_data[] = {
//                                     house_code,
//                                     PR_NO_VALUE[j]
//                                     ,PR_SEQ[j]
//                                     };
//
//                dataPRDT[j] = tmp_data;
//            }
//
//            value = setGonggoModify(info, dataRAHD, dataRADT, dataPRDT, dataRQSE, dataBDRC);
//
//            String[] obj = new String[3];
//            obj[0] = value.message;
//            obj[1] = value.result[1];       // RA_NO
//            obj[2] = value.result[2];       // RA_COUNT
//            ws.setUserObject(obj);
//        }
//        else if(mode.equals("setGonggoConfirm")) { // ����Ű�� Ȯ��
//        	String[][] dataRAHD = new String[1][];
//        	String[] temp_RAHD = {ANN_DATE, START_DATE, START_TIME, END_DATE, END_TIME, OPEN_REQ_FROM_DATE, OPEN_REQ_TO_DATE, house_code, RA_NO, RA_COUNT};
//        	dataRAHD[0] = temp_RAHD;
//            value = setGonggoConfirm(info, RA_NO, RA_COUNT, RA_FLAG, RA_TYPE1, dataRAHD);
//            
//            ws.setMessage(value.message);
//            String[] obj = new String[1];
//            obj[0] = value.message;
//            ws.setUserObject(obj);
//        }
//        else if(mode.equals("setDataToGW")) { // Groupware�� insert
//
//            value = setDataToGW(info, RA_NO, RA_COUNT, "������(����)", ANN_NO);
//
//            String[] obj = new String[1];
//            obj[0] = value.message;
//
//            ws.setUserObject(obj);
//        }
//        else if(mode.equals("setSignStatus")) { //  �����û ����('P')�� UPDATE�Ѵ�.
//            //String SIGN_STATUS      = ws.getParam("SIGN_STATUS");
//
//            value = setSignStatus(info, RA_NO, RA_COUNT, SIGN_STATUS);
//
//            String[] obj = new String[1];
//            obj[0] = value.message;
//
//            ws.setUserObject(obj);
//        }
//
//        ws.setCode(String.valueOf(value.status));
//        //ws.setMessage("���������� �����Ͽ����ϴ�.");
//
//        Logger.debug.println(info.getSession("ID"), this, "status===================================>"+String.valueOf(value.status));
//
//        ws.write();
//        
//		// SMS ���, MAIL ���
//        if("setGonggoConfirm".equals(mode)){
//        	// ������� �̸鼭 ��Ұ�? �ƴѰ��
//        	if("NC".equals(RA_TYPE1) && !RA_FLAG.startsWith("D")){
//        		try {
//        			String[][] args = new String[1][2];
//        			args[0][0] = RA_NO;
//        			args[0][1] = RA_COUNT;
//					
//					Object[] sms_args = {args};
//			        String sms_type = "";
//			        String mail_type = "";
//			        
//			        sms_type 	= "S00006";
//			        mail_type 	= "M00006";
//			        
//			        if(!"".equals(sms_type)){
//			        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
//			        }
//			        if(!"".equals(mail_type)){
//			        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
//			        }
//					
//				} catch (Exception e) {
//					Logger.debug.println("mail error = " + e.getMessage());
//					e.printStackTrace();
//				}
//        	}
//        	
//        	
//        }
//
//
//    }
//
//    public WiseOut getPrDTDisplay_VAT(WiseInfo info, String pr_no, String REQ_PR_SEQ, String ITEM_FIND) {
//        Object[] args = {pr_no, REQ_PR_SEQ, ITEM_FIND};
//        WiseOut rtn = null;
//        WiseRemote wr = null;
//
//        String nickName = "p1001";
//        String MethodName = "getPrDTDisplay_VAT";
//        String conType = "CONNECTION";
//
//        try {
//            wr = new WiseRemote(nickName, conType, info);
//            rtn = wr.lookup(MethodName, args);
//        }catch(Exception e) {
//            Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());
//        }finally{
//            try{
//                wr.Release();
//            }catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return rtn;
//    }
//
//    public WiseOut getBDDTDisplay(WiseInfo info, String RA_NO, String RA_COUNT) {
//        Object[] args = {RA_NO, RA_COUNT};
//        WiseOut rtn = null;
//        WiseRemote wr = null;
//
//        String nickName = "p1008";
//        String MethodName = "getRADTDisplay";
//        String conType = "CONNECTION";
//
//        try {
//            wr = new WiseRemote(nickName, conType, info);
//            rtn = wr.lookup(MethodName, args);
//        }catch(Exception e) {
//            Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());
//        }finally{
//            try{
//                wr.Release();
//            }catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return rtn;
//    }
//
//    public WiseOut setGonggoCreate(WiseInfo info, String[] dataRAHD, String[][] dataRADT, String[][] dataPRDT, String[][] dataRQSE, String[][] dataBDRC, String approval_str, String SIGN_STATUS, String ModifyFlag) {
//        String nickName= "p1008";
//        String conType = "TRANSACTION";
//        String MethodName = "setratbdins1_1";
//        WiseOut value = null;
//        WiseRemote wr = null;
//        String ebidding_no = null;  //��� ä��..
//
//        Object[] args = {dataRAHD, dataRADT, dataPRDT, dataRQSE, dataBDRC, approval_str, SIGN_STATUS, ModifyFlag};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,args);
//
//            Logger.err.println(info.getSession("ID"),this,"11111111111111111111111111^^11111111111111111111111111111111111111111");
//
//        } catch(Exception e) {
//        	try{
//                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
//                Logger.err.println("status = " + value.status + "  message = " + value.message);
//        		
//        	}catch(NullPointerException ne){
//    			ne.printStackTrace();
//    		}
//        } finally{
//            try {
//                wr.Release();
//            } catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//
//
//        return value;
//    }
//
//    public WiseOut setGonggoModify(WiseInfo info, String[] dataRAHD, String[][] dataRADT, String[][] dataPRDT, String[][] dataRQSE, String[][] dataBDRC) {
//
//        String nickName= "p1008";
//
//        String conType = "TRANSACTION";
//
//        String MethodName = "setGonggoModify_1";
//
//        //Logger.err.println(info.getSession("ID"),this,"222222222222222222222222222222--;;222222222222222222222222222222222222222"+ nickName + "  "+MethodName+ "  " +conType);
//
//        WiseOut value = null;
//        WiseRemote wr = null;
//        String ebidding_no = null;  //��� ä��..
//
//        Object[] args = {dataRAHD, dataRADT, dataPRDT, dataRQSE, dataBDRC};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,args);
//        } catch(Exception e) {
//        	try{
//                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
//                Logger.err.println("status = " + value.status + "  message = " + value.message);        		
//        	}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
//        } finally{
//            try {
//                wr.Release();
//            } catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//
//        return value;
//    }
//
//    public WiseOut setGonggoConfirm(WiseInfo info, String RA_NO, String RA_COUNT, String RA_FLAG, String RA_TYPE1, String[][] dataRAHD) {
//        String nickName= "p1008";
//        String conType = "TRANSACTION";
//        String MethodName = "setGonggoConfirm";
//
//        WiseOut value = null;
//        WiseRemote wr = null;
//        String ebidding_no = null;  //��� ä��..
//
//        Object[] args = {RA_NO, RA_COUNT, RA_FLAG, RA_TYPE1, dataRAHD};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,args);
//        } catch(Exception e) {
//        	try{
//                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
//                Logger.err.println("status = " + value.status + "  message = " + value.message);        		
//        	}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
//        } finally{
//            try {
//                wr.Release();
//            } catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return value;
//    }
//
//    public WiseOut setUGonggoCreate(WiseInfo info, String[] data, String[][] sendRADT, String[][] sendPRDT, String BASIC_AMT) {
//        String nickName= "p1009";
//        String conType = "TRANSACTION";
//        String MethodName = "setUGonggoCreate";
//
//        WiseOut value = null;
//        WiseRemote wr = null;
//        String ebidding_no = null;  //��� ä��..
//
//        Object[] args = {data, sendRADT, sendPRDT, BASIC_AMT};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,args);
//        } catch(Exception e) {
//        	try{
//                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
//                Logger.err.println("status = " + value.status + "  message = " + value.message);        		
//        	}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
//        } finally{
//            try {
//                wr.Release();
//            } catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return value;
//    }
//
//    public WiseOut setDataToGW(WiseInfo info, String RA_NO, String RA_COUNT, String FORM_NAME, String ANN_NO) {
//        String nickName= "p1009";
//        String conType = "TRANSACTION";
//        String MethodName = "setDataToGW";
//
//        WiseOut value = null;
//        WiseRemote wr = null;
//        String ebidding_no = null;  //��� ä��..
//
//        Object[] args = {RA_NO, RA_COUNT, FORM_NAME, ANN_NO};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,args);
//        } catch(Exception e) {
//        	try{
//                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
//                Logger.err.println("status = " + value.status + "  message = " + value.message);        		
//        	}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
//        } finally{
//            try {
//                wr.Release();
//            } catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return value;
//    }
//
//    public WiseOut setSignStatus(WiseInfo info, String RA_NO, String RA_COUNT, String SIGN_STATUS) {
//        String nickName= "p1009";
//        String conType = "TRANSACTION";
//        String MethodName = "setSignStatus";
//
//        WiseOut value = null;
//        WiseRemote wr = null;
//        String ebidding_no = null;  //��� ä��..
//
//        Object[] args = {RA_NO, RA_COUNT, SIGN_STATUS};
//
//        try {
//            wr = new wise.util.WiseRemote(nickName, conType, info);
//            value = wr.lookup(MethodName,args);
//        } catch(Exception e) {
//        	try{
//                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
//                Logger.err.println("status = " + value.status + "  message = " + value.message);        		
//        	}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
//        } finally{
//            try {
//                wr.Release();
//            } catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return value;
//    }
//
//    public String checkNull(String value) {
//        if(value == null) value = null;
//        else if(value.trim().equals("")) value = null;
//        return value;
//    }
//
//    public String null2Void(String pStr)  {
//        try {
//            if (pStr == null) {
//                return "";
//            } else {
//                return pStr.trim();
//            }
//        } catch (Exception e) {
//                  return "";
//       }
//    }

}
