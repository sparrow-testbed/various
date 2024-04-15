// Decompiled by Jad v1.5.7d. Copyright 2000 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/SiliconValley/Bridge/8617/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   ven_bd_ins6.java

package ict.supply.admin.info;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;
public class ven_bd_ins9_ict extends HttpServlet {
	
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
    	SepoaFormater sf = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		
    		
    		if("setVendorProject".equals(mode)){ 
    			gdRes = this.setVendorProject(gdReq, info);
    		}else if("getVendorProject".equals(mode)){
    			gdRes = this.getVendorProject(gdReq, info);
    		}else if("delVendorProject".equals(mode)){
    			gdRes = this.delVendorProject(gdReq, info);
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

    

	/* ICT 사용 */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getVendorProject(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "I_p0010", "CONNECTION", "getVendorProject", obj);
	
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
    
	
	/* ICT 사용 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setVendorProject(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "I_p0010", "TRANSACTION", "setVendorProject", obj);
			
			String[] tmp = value.result;
			
//			if(tmp != null && tmp.length > 0){
//				for(int i = 0 ; i < tmp.length ; i++){
//					
//				}
//			}
			
			
			if(value.flag) {
				gdRes.addParam("rtnVal", value.result[0]);
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
	
	/* ICT 사용 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData delVendorProject(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "I_p0010", "TRANSACTION", "delVendorProject", obj);
			
			String[] tmp = value.result;
			
//			if(tmp != null && tmp.length > 0){
//				for(int i = 0 ; i < tmp.length ; i++){
//					
//				}
//			}
			
			
			if(value.flag) {
				gdRes.addParam("rtnVal", value.result[0]);
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
    
//    public ven_bd_ins9()
//    {
//        msg = new Message("STDCOMM");
//    }
//
//    public void doQuery(WiseStream ws)
//        throws Exception
//    {
//        //WiseInfo info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        String house_code 		= info.getSession("HOUSE_CODE");
//        String user_id 			= info.getSession("ID");
//        String user_name_loc 	= info.getSession("NAME_LOC");
//        String user_name_eng 	= info.getSession("NAME_ENG");
//        String user_dept 		= info.getSession("DEPARTMENT");
//        String vendor_code 		= ws.getParam("vendor_code");
//        String PROJECT_TYPE 	= ws.getParam("PROJECT_TYPE");
//        String CUR 				= ws.getParam("CUR");
//        Object args[] = {
//            house_code, vendor_code
//        };
//        WiseOut value = ServiceConnector.doService(info, "p0010", "CONNECTION", "getVendorProject", args);
//        WiseFormater wf = ws.getWiseFormater(value.result[0]);
//        if(wf.getRowCount() == 0)
//        {
//            ws.setCode("M001");
//            ws.setMessage(msg.getMessage("0008"));
//            ws.write();
//            return;
//        }
//        
//        int	IDX_CUR			= ws.getColumnIndex("CUR");	
//        int	IDX_POSITION	= ws.getColumnIndex("PROJECT_YEAR");
//        int	IDX_PROJECT_TYPE= ws.getColumnIndex("PROJECT_TYPE");
//		String[][] combo_cur  			= getComboArray(CUR);
//		String[][] combo_project_type  	= getComboArray(PROJECT_TYPE);
//		
//        String[][] combo_year = new String[50][2];
//        int year = Integer.parseInt(WiseDate.getShortDateString().substring(0,4)); 
//        int count = 0;
//        for(int i = year ; i > year-50 ; i--){
//        	combo_year[count][0] = i+"";
//        	combo_year[count][1] = i+"";
//        	count++;
//        }              
//        	
//        for(int i = 0; i < wf.getRowCount(); i++)
//        {
//            String check[] = {"false", ""};
//            
//            ws.addValue("SEL"			, check								, "");
//            ws.addValue("PROJECT_NAME"	, wf.getValue("PROJECT_NAME"	, i), "");
//            ws.addValue("ENT_FROM_DATE"	, wf.getValue("ENT_FROM_DATE"	, i), "");
//            ws.addValue("ENT_TO_DATE"	, wf.getValue("ENT_TO_DATE"	    , i), "");
//            ws.addValue("CUSTOMER_NAME"	, wf.getValue("CUSTOMER_NAME"	, i), "");
//            ws.addValue("MAIN_CONT_NAME", wf.getValue("MAIN_CONT_NAME"  , i), "");
//            ws.addValue("PROJECT_AMT"	, wf.getValue("PROJECT_AMT"	    , i), "");
//            ws.addValue("HOUSE_CODE"	, wf.getValue("HOUSE_CODE"	    , i), "");
//            ws.addValue("VENDOR_CODE"	, wf.getValue("VENDOR_CODE"	    , i), "");
//            ws.addValue("SEQ"			, wf.getValue("SEQ"			    , i), "");
//            ws.addValue("FLAG"			, "U"								, "");
//            ws.addValue("REMARK"		, wf.getValue("REMARK"	    	, i), "");
//            String code1 = wf.getValue( "PROJECT_YEAR" 	, i);
//			String code2 = wf.getValue( "CUR" 			, i);
//			String code3 = wf.getValue( "PROJECT_TYPE"	, i);
//			//�޺��� addValue
//			ws.addValue(IDX_POSITION	,  combo_year			, "PROJECT_YEAR"  , getIndex(code1, combo_year));     
//			ws.addValue(IDX_CUR			,  combo_cur 			, "CUR"  		  , getIndex(code2, combo_cur));    
//			ws.addValue(IDX_PROJECT_TYPE,  combo_project_type 	, "PROJECT_TYPE"  , getIndex(code3, combo_project_type));                        
//        }
//
//        ws.setCode("M001");
//        ws.setMessage(value.message);
//        ws.write();
//    }
//    private String[][] getComboArray(String comboString){
//    	StringTokenizer st1 = new StringTokenizer(comboString,"#");
//        int st_count = st1.countTokens();
//        String[][] combo = new String[st_count][2];
//		for(int i = 0 ; i < st_count; i++){
//			StringTokenizer st2 = new StringTokenizer(st1.nextToken(),"&");
//			combo[i][0] = st2.nextToken();
//			combo[i][1] = st2.nextToken();
//		}
//		return combo;
//    }
//	private int getIndex(String code,String[][] payTerms_c){
//		int vSize = payTerms_c.length;
//		int index = 0;
//		for(int i = 0 ; i < vSize ; i++ ){
//			if(payTerms_c[i][1].equals(code))
//				index = i ;
//		}
//		return index;
//	}
//	
//    public void doData(WiseStream ws)
//        throws Exception
//    {
//    	System.out.println("ven_bd_ins9.java-doData====================================");
//        String mode = ws.getParam("mode");
//        if(mode.equals("setVendorProject"))
//            setVendorProject(ws, mode);
//        else
//        if(mode.equals("delVendorProject"))
//            delVendorProject(ws, mode);
//    }
//
//    private void setVendorProject(WiseStream ws, String mode)
//        throws Exception
//    {
//    	System.out.println("ven_bd_ins9.java-setVendorProject-01====================================");
//        //WiseInfo info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//    	WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        System.out.println("ven_bd_ins9.java-setVendorProject-02====================================");
//        WiseFormater wf = ws.getWiseFormater();
//        
//        int iRowCount = wf.getRowCount();
//        String HOUSE_CODE 		= info.getSession("HOUSE_CODE");  
//        String VENDOR_CODE	    = ws.getParam("vendor_code"		);
//        String[] PROJECT_NAME	= wf.getValue("PROJECT_NAME"	);
//        String[] PROJECT_YEAR	= wf.getValue("PROJECT_YEAR"	);
//        String[] ENT_FROM_DATE  = wf.getValue("ENT_FROM_DATE"	);
//        String[] ENT_TO_DATE	= wf.getValue("ENT_TO_DATE"	    );
//        String[] CUSTOMER_NAME  = wf.getValue("CUSTOMER_NAME"	);
//        String[] MAIN_CONT_NAME = wf.getValue("MAIN_CONT_NAME"  );
//        String[] CUR			= wf.getValue("CUR"			    );
//        String[] PROJECT_AMT	= wf.getValue("PROJECT_AMT"	    );
//        String[] SEQ			= wf.getValue("SEQ"			    );
//        String[] FLAG			= wf.getValue("FLAG"			);	
//        String[] PROJECT_TYPE	= wf.getValue("PROJECT_TYPE"	);
//        String[] REMARK			= wf.getValue("REMARK"			);			
//        int ins_cnt = 0;                      
//        int upd_cnt = 0;                      
//        for(int i = 0; i < iRowCount; i++)
//            if(FLAG[i].equals("U"))
//                upd_cnt++;
//            else
//                ins_cnt++;
//
//        String ins_data[][] = new String[ins_cnt][];
//        String upd_data[][] = new String[upd_cnt][];
//        ins_cnt = 0;
//        upd_cnt = 0;
//        for(int i = 0; i < iRowCount; i++)
//            if(FLAG[i].equals("U"))
//            {
//                String upd_temp[] = {
//				                      PROJECT_NAME[i]	    
//				                    , PROJECT_YEAR[i]	    
//				                    , ENT_FROM_DATE[i]     
//				                    , ENT_TO_DATE[i]	    
//				                    , CUSTOMER_NAME[i]     
//				                    , MAIN_CONT_NAME[i]    
//				                    , CUR[i]			    
//				                    , PROJECT_AMT[i]
//				                    , PROJECT_TYPE[i]
//				                    , REMARK[i]	    
//				                    , HOUSE_CODE
//				                    , VENDOR_CODE
//				                    , SEQ[i]
//				                	};
//                upd_data[upd_cnt] = upd_temp;
//                upd_cnt++;
//            } else
//            {
//                String ins_temp[] = {
//                    				    HOUSE_CODE
//                    				  , VENDOR_CODE
//                    				  , PROJECT_NAME[i]	
//									  , PROJECT_YEAR[i]	
//									  , ENT_FROM_DATE[i]  
//									  , ENT_TO_DATE[i]	
//									  , CUSTOMER_NAME[i]  
//									  , MAIN_CONT_NAME[i] 
//									  , CUR[i]			
//									  , PROJECT_AMT[i]
//									  , PROJECT_TYPE[i]
//				                      , REMARK[i]	
//									};
//			    ins_data[ins_cnt] = ins_temp;
//                ins_cnt++;
//            }
//
//        Object obj[] = {ins_data, upd_data, VENDOR_CODE};
//        WiseOut value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "setVendorProject", obj);
//        ws.setCode("0000");
//        String userObj[] = {
//            mode, value.result[0]
//        };
//        ws.setUserObject(userObj);
//        ws.setMessage(value.message);
//        System.out.println("ven_bd_ins9.java-setVendorProject-03====================================");
//        ws.write();
//    }
//
//    public void delVendorProject(WiseStream ws, String mode)
//        throws Exception
//    {
//        //WiseInfo info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        WiseFormater wf = ws.getWiseFormater();
//        int iRowCount = wf.getRowCount();
//        String HOUSE_CODE = info.getSession("HOUSE_CODE");
//        String I_VENDOR_CODE = ws.getParam("vendor_code");
//        String SEQ[] = wf.getValue("SEQ");
//        String delData[][] = new String[iRowCount][];
//        for(int i = 0; i < iRowCount; i++)
//        {
//            String temp[] = {HOUSE_CODE, I_VENDOR_CODE, SEQ[i]};
//            delData[i] = temp;
//        }
//
//        Object obj[] = {delData};
//        WiseOut value = ServiceConnector.doService(info, "p0010", "TRANSACTION", "delVendorProject", obj);
//        ws.setCode("0000");
//        String userObj[] = {
//            mode, value.result[0]
//        };
//        ws.setUserObject(userObj);
//        ws.setMessage(value.message);
//        ws.write();
//    }
//    
//
//
//    Message msg;
}
