package dt.bidd;

import java.util.*;
import java.io.*;

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


public class ebd_bd_lis15 extends HttpServlet {

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
    		
    		if("getRestricLowest".equals(mode)){ // 참가신청등록
    			gdRes = this.getRestricLowest(gdReq, info);
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
	private GridData getRestricLowest(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "p1014", "CONNECTION","getRestricLowest", obj);
	
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
			    		   
							double basic_amt       = Double.parseDouble( checkNull(sf.getValue("BASIC_AMT"          , i)) );
			    			double estm_price      = Double.parseDouble( checkNull(sf.getValue("ESTM_PRICE"         , i)) );
			    			double rate            = ( estm_price / basic_amt ) * 100.0;
			    		
			    		    double bid_amt            = Double.parseDouble( checkNull(sf.getValue("BID_AMT"            , i)) );
			    			double settleaverageprice = Double.parseDouble( checkNull(sf.getValue("SETTLEAVERAGEPRICE" , i)) );
			    			double contrast = 0.0;
			    		
			    			if( bid_amt == 0.0 || settleaverageprice == 0.0 ){
			    				contrast = 0.0;
			    			}else{
			    				contrast = ( bid_amt - settleaverageprice );
			    			}		
			    			
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			
			    			else if("RATE".equals(gridColAry[k])){
			    				gdRes.addValue(gridColAry[k], rate + "");
			    			}
			    			
			    			else if("CONTRAST".equals(gridColAry[k])){
			    				gdRes.addValue(gridColAry[k], (int)contrast + "");
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
    
//    
//    public void doQuery(WiseStream ws) throws Exception {
//        //get session
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        Message msg   = new Message("KO","p1008");
//        String mode   = ws.getParam("mode");
//      
//        Logger.debug.println(info.getSession("ID"),this,"mode------------------>"+mode);
//               
//        if(mode.equals("getRestricLowest")) { //입찰결과
//            String from_date = ws.getParam("from_date");
//            String to_date	 = ws.getParam("to_date");
//			String gubun 	 = ws.getParam("gubun");
//            String[] pData   = { from_date, to_date, gubun };
//            
//			Logger.debug.println("from_date = " + from_date);
//			Logger.debug.println("to_date   = " + to_date);
//			Logger.debug.println("gubun     = " + gubun);
//
//            WiseOut out = getRestricLowest(info, pData);
//            
//            WiseFormater wf = ws.getWiseFormater(out.result[0]);
//            
//            if(wf == null) {
//                msg.getMessage("0001");
//                ws.setMessage("데이타 포맷이 정확하지 않습니다.");
//                ws.write();
//                return;
//            }
//            
//            if(wf.getRowCount() == 0) {
//                ws.setCode("M001");
//                ws.setMessage("조회된 데이타가 없습니다.");
//                ws.write();
//                return;
//            }
//
//            int INDEX_SELECTED             =    ws.getColumnIndex("SELECTED");
//            int INDEX_NO                   =    ws.getColumnIndex("NO");
//            int INDEX_ANN_ITEM             =    ws.getColumnIndex("ANN_ITEM");
//            int INDEX_BASIC_AMT            =    ws.getColumnIndex("BASIC_AMT");
//            int INDEX_ESTM_PRICE           =    ws.getColumnIndex("ESTM_PRICE");
//            int INDEX_RATE                 =    ws.getColumnIndex("RATE");
//            int INDEX_FINAL_ESTM_PRICE_ENC =    ws.getColumnIndex("FINAL_ESTM_PRICE_ENC");
//            int INDEX_AVERAGEPRICE         =    ws.getColumnIndex("AVERAGEPRICE");
//            int INDEX_BID_AMT              =    ws.getColumnIndex("BID_AMT");
//            int INDEX_SETTLEAVERAGEPRICE   =    ws.getColumnIndex("SETTLEAVERAGEPRICE");
//            int INDEX_CONTRAST             =    ws.getColumnIndex("CONTRAST");
//            
//			Logger.debug.println("INDEX_SELECTED     = " + INDEX_SELECTED);
//			Logger.debug.println("INDEX_CONTRAST     = " + INDEX_CONTRAST);
//            for( int i = 0; i < wf.getRowCount(); i++ ) { //데이타가 있는 경우
//				String[] img_check        = { "false", "" };
//   
//				double basic_amt       = Double.parseDouble( checkNull(wf.getValue("BASIC_AMT"          , i)) );
//				double estm_price      = Double.parseDouble( checkNull(wf.getValue("ESTM_PRICE"         , i)) );
//				double rate            = ( estm_price / basic_amt ) * 100.0;
//				//Logger.debug.println("### basic_amt			 = " + basic_amt);
//				//Logger.debug.println("### estm_price		 = " + estm_price);				
//				//Logger.debug.println("### rate               = " + rate);
//
//                double bid_amt            = Double.parseDouble( checkNull(wf.getValue("BID_AMT"            , i)) );
//				double settleaverageprice = Double.parseDouble( checkNull(wf.getValue("SETTLEAVERAGEPRICE" , i)) );
//				double contrast = 0.0;
//
//				if( bid_amt == 0.0 || settleaverageprice == 0.0 ){
//					contrast = 0.0;
//				}else{
//					contrast = ( bid_amt - settleaverageprice );
//				}
//
//				//Logger.debug.println("$$$ bid_amt            = " + bid_amt);
//				//Logger.debug.println("$$$ settleaverageprice = " + settleaverageprice);
//				//Logger.debug.println("$$$ contrast           = " + contrast);
//				//Logger.debug.println("$$$ contrast           = " + (int)contrast);
//				//Logger.debug.println("$$$ contrast           = " + String.valueOf(contrast));
//				//Logger.debug.println("$$$ contrast           = " + String.valueOf(contrast));
//
//                ws.addValue(INDEX_SELECTED             , img_check							      , "");
//                ws.addValue(INDEX_NO                   , wf.getValue("NO"					, i)  , "");
//                ws.addValue(INDEX_ANN_ITEM             , wf.getValue("ANN_ITEM"				, i)  , "");
//                ws.addValue(INDEX_BASIC_AMT            , wf.getValue("BASIC_AMT"            , i)  , "");
//				ws.addValue(INDEX_ESTM_PRICE           , wf.getValue("ESTM_PRICE"           , i)  , "");
//				ws.addValue(INDEX_RATE           	   , ""+rate								  , "");
//				ws.addValue(INDEX_FINAL_ESTM_PRICE_ENC , wf.getValue("FINAL_ESTM_PRICE_ENC" , i)  , "");
//				ws.addValue(INDEX_AVERAGEPRICE         , wf.getValue("AVERAGEPRICE"         , i)  , "");
//				ws.addValue(INDEX_BID_AMT              , wf.getValue("BID_AMT"              , i)  , "");
//				ws.addValue(INDEX_SETTLEAVERAGEPRICE   , wf.getValue("SETTLEAVERAGEPRICE"   , i)  , "");
//				ws.addValue(INDEX_CONTRAST             , ""+(int)contrast                         , "");
//			
//            }
//            ws.setCode("M001");
//            ws.setMessage("성공적으로 작업을 수행하였습니다..");
//            ws.write();
//			
//        }
//    }
//    
//    public WiseOut getRestricLowest(WiseInfo info, String[] pData) {
//        Object[] args = {pData};
//        
//        WiseOut rtn = null;
//        WiseRemote wr = null;
//        
//        String conType    = "CONNECTION";
//        String nickName   = "p1014";
//        String MethodName = "getRestricLowest";
//        
//        try {
//            wr = new WiseRemote(nickName, conType, info);
//            rtn = wr.lookup(MethodName, args);
//        }catch(Exception e) {
//            Logger.dev.println(info.getSession("ID"), this, "Servlet===>getratbdlis1_1 Exceptioin =====> " + e.getMessage());
//        }finally{
//            wr.Release();
//        }
//        
//        return rtn;
//    }
//  
//    /**********************************************************************************************************************************/
//    public void doData(WiseStream ws) throws Exception {
//        //get session
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        
//        //get Parameter
//        String mode = ws.getParam("mode");
//        WiseFormater wf = ws.getWiseFormater();
//        
//        
//        Logger.debug.println(info.getSession("ID"),this,"doData mode------------------>"+mode);
//    }
//    
    public String checkNull(String value) {
        if(value == null){ value = "0";}
        if("".equals(value.trim())){ value =  "0";}
        return value;
    }
    
}
/*******************************************************************************************************************************
 * END OF File
 *********************************************************************************************************************************/