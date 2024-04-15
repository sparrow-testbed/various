package sepoa.svl.tax; 

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import com.tcTest.tst_OT8701;
import com.woorifg.wpms.wpms_webservice.EPS0015_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0015_WSStub.EPS0015;
import com.woorifg.wpms.wpms_webservice.EPS0015_WSStub.EPS0015Response;
import com.woorifg.wpms.wpms_webservice.EPS0016_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0016_WSStub.EPS0016;
import com.woorifg.wpms.wpms_webservice.EPS0016_WSStub.EPS0016Response;
import com.woorifg.wpms.wpms_webservice.EPS0017_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017;
import com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response;
import com.woorifg.wpms.wpms_webservice.EPS0018_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0018_WSStub.EPS0018;
import com.woorifg.wpms.wpms_webservice.EPS0018_WSStub.EPS0018Response;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.ArrayOfString;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class pay_bd_ins1 extends HttpServlet{

	private static final long serialVersionUID = 1L;

	// sorry~
	public void init(ServletConfig config) throws ServletException {}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        SepoaInfo   info  = sepoa.fw.ses.SepoaSession.getAllValue(req); // 세션 Object
        GridData    gdReq = null;
        GridData    gdRes = new GridData();
        String      mode  = null;
        PrintWriter out   = null;
        
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        
        try {
        	out   = res.getWriter();
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		
       		if("getPayList".equals(mode)){	
       			gdRes = getPayList(gdReq, info); // 자본예산지급 조회
       		}
       		else if("getPayList2".equals(mode)){	
       			gdRes = getPayList2(gdReq, info); // 자본예산지급 조회
       		}
       		else if("getEps0019".equals(mode)){
       			gdRes = this.getEps0019(gdReq, info);
       		}
       		else if("getEps0021".equals(mode)){
       			gdRes = this.getEps0021(gdReq, info);
       		}
       		else if("getTcpResult".equals(mode)){
       			gdRes = this.getTcpResult(gdReq, info);
       		}
       		else if("getEps0015".equals(mode)){
       			gdRes = this.getEps0015(gdReq, info);
       		}
       		else if("getEps0016".equals(mode)){
       			gdRes = this.getEps0016(gdReq, info);
       		}
       		else if("getEps0017".equals(mode)){
       			gdRes = this.getEps0017(gdReq, info);
       		}
       		else if("getEps0018".equals(mode)){
       			gdRes = this.getEps0018(gdReq, info);
       		}
       		else if("insetSpy1Info".equals(mode)){
       			gdRes = this.insetSpy1Info(gdReq, info);
       		}
        }
        catch (Exception e) {
//        	e.printStackTrace();
        	
        	gdRes.setMessage("Error: " + e.getMessage());
        	gdRes.setStatus("false");
        }
        finally {
        	try {
        		if(
        			("getPayList".equals(mode)) || 
        			("getPayList2".equals(mode)) ||
        			("getEps0015".equals(mode)) || 
        			("getEps0016".equals(mode)) ||
        			("insetSpy1Info".equals(mode))
        		){
        			OperateGridData.write(req, res, gdRes, out);
        		}
        		else{
        			if(out != null){ out.print((gdRes.getMessage() != null)?gdRes.getMessage():""); }
        		}
        	}
        	catch (Exception e) {Logger.debug.println();}
        }
    }
    
    private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
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
    
    private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
    
    private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
    
    private String getStringMaxByte(String target, int maxLength){
    	byte[] targetByteArray       = target.getBytes();
    	int    targetByteArrayLength = targetByteArray.length;
    	int    targetLength          = 0;
    	
    	while(targetByteArrayLength > maxLength){
    		targetLength          = target.length();
    		targetLength          = targetLength - 1;
    		target                = target.substring(0, targetLength);
    		targetByteArray       = target.getBytes();
    		targetByteArrayLength = targetByteArray.length;
    	}
    	
    	return target;
    }
    
    private String getRemoveLineSeparator(String target) throws Exception{
    	target = target.replace(System.getProperty("line.separator"), "");
    	
    	return target;
    }
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
    
    private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes", "unused" })
	private void debugMap(Map map) throws Exception{
	    Iterator value       = map.values().iterator();
	    Iterator key         = map.keySet().iterator();
	    Object   valueObject = null;
	              
	    Logger.debug.println();
	    
	    while(value.hasNext()){
	    	valueObject = value.next();
	    	
	    	if(valueObject != null){
	    		Logger.debug.println("map key : >" + key.next() + "<, value : >" + valueObject.toString() + "< value is String : >" + (valueObject instanceof String) + "<");  
	    	}
	    	else{
	    		Logger.debug.println("map key : >" + key.next() + "<, value : null");
	    	}
	    }
	    
	    Logger.debug.println();
	}
    
//    private Object[] getPayListObj(GridData gdReq, SepoaInfo info) throws Exception{
//    	Object[]            result           = new Object[1];
//    	Map<String, String> header           = this.getHeader(gdReq, info);
//    	Map<String, String> resultInfo       = new HashMap<String, String>();
//    	String              taxNoParameter   = header.get("taxNoParameter");
//    	String              taxSeqParameter  = header.get("taxSeqParameter");
//    	String              taxNo            = null;
//    	String              taxSeq           = null;
//    	String              taxNoSeq         = null;
//    	String              houseCode        = info.getSession("HOUSE_CODE");
//    	String[]            taxNoArray       = taxNoParameter.split(",");
//    	String[]            taxSeqArray      = taxSeqParameter.split(",");
//    	StringBuffer        stringBuffer     = new StringBuffer();
//    	int                 taxNoArrayLength = taxNoArray.length;
//    	int                 i                = 0;
//    	int                 taxNoLastIndex   = taxNoArrayLength - 1;
//    	
//    	for(i = 0; i < taxNoArrayLength; i++){
//    		taxNo  = taxNoArray[i];
//    		taxSeq = taxSeqArray[i];
//    		
//    		stringBuffer.append("('").append(taxNo).append("', '").append(taxSeq).append("')");
//			
//			if(i != taxNoLastIndex){
//				stringBuffer.append(", ");
//			}
//    	}
//    	
//    	taxNoSeq = stringBuffer.toString();
//    	
//    	resultInfo.put("TAX_NO_SEQ", taxNoSeq);
//    	resultInfo.put("HOUSE_CODE", houseCode);
//    	
//    	result[0] = resultInfo;
//    	
//    	return result;
//    }
    
    private Object[] getPayListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result           = new Object[1];
    	Map<String, String> header           = this.getHeader(gdReq, info);
    	Map<String, String> resultInfo       = new HashMap<String, String>();
    	String              taxNoParameter   = header.get("taxNoParameter");
    	String              taxNo            = null;
    	String              houseCode        = info.getSession("HOUSE_CODE");
    	String[]            taxNoArray       = taxNoParameter.split(",");
    	StringBuffer        stringBuffer     = new StringBuffer();
    	int                 taxNoArrayLength = taxNoArray.length;
    	int                 i                = 0;
    	int                 taxNoLastIndex   = taxNoArrayLength - 1;
    	
    	for(i = 0; i < taxNoArrayLength; i++){
    		taxNo  = taxNoArray[i];
    		
    		stringBuffer.append("'").append(taxNo).append("'");
			
			if(i != taxNoLastIndex){
				stringBuffer.append(", ");
			}
    	}
    	
    	resultInfo.put("TAX_NO", stringBuffer.toString());
    	resultInfo.put("HOUSE_CODE", houseCode);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    private GridData getPayListGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
    	String[]            gridColAry       = this.getGridColArray(gdReq);
    	String              colKey           = null;
	    String              colValue         = null;
    	int                 i                = 0;
	    int                 k                = 0;
	    int                 rowCount         = sf.getRowCount();
	    int                 gridColAryLength = gridColAry.length;
	    
    	for (i = 0; i < rowCount; i++){
    		for(k = 0; k < gridColAryLength; k++){
    			colKey   = gridColAry[k];
    			colValue = sf.getValue(colKey, i);
    			
    			if("SELECTED".equals(gridColAry[k])){
    				gdRes.addValue("SELECTED", "1");
    			}
    			else{
    				gdRes.addValue(colKey, colValue);
    			}
    		}
    	}
    	
    	return gdRes;
    }
        
    /**
     * 자본예산지급 조회 
     * getPayList
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-12-04
     * @modify 2014-12-04
     */
	@SuppressWarnings("rawtypes")
	private GridData getPayList(GridData gdReq, SepoaInfo info) throws Exception{
		GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.getPayListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "TX_005", "CONNECTION", "getPayList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.getPayListGdRes(gdReq, gdRes, sf);
		    	}
		    	
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
		
	@SuppressWarnings("rawtypes")
	private GridData getPayList2(GridData gdReq, SepoaInfo info) throws Exception{
		GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
	    	Map<String, String> header = MapUtils.getMap(allData, "headerData");
	    	Object[] obj = {header};
	    	
	    	value    = ServiceConnector.doService(info, "TX_005", "CONNECTION", "getPayList2", obj);
	    	isStatus = value.flag;
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		    	if(rowCount != 0){
		    		gdRes = this.getPayListGdRes(gdReq, gdRes, sf);
		    	}
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
	private String getWebserviceId(SepoaInfo info) throws Exception{
		String id = info.getSession("ID");
		
		if("ADMIN".equals(id)){
			id = "EPROADM";
		}
		
		return id;
	}
	
	private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend) throws Exception{
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		String              infNo     = null;
		String              houseCode = info.getSession("HOUSE_CODE");
		String              id        = this.getWebserviceId(info);
		boolean             flag      = false;
		
		param.put("HOUSE_CODE",     houseCode);
		param.put("INF_TYPE",       "W");
		param.put("INF_CODE",       infCode);
		param.put("INF_SEND",       infSend);
		param.put("INF_ID",         id);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
	
	private void insertSinfep0019Info(SepoaInfo info, String infNo, EPS0019 eps0019) throws Exception{
		Map<String, String> svcParam  = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              mode      = eps0019.getMODE();
		String              bnkBnkCd  = eps0019.getBNKBNKCD();
		String              bmsBmsYy  = eps0019.getBMSBMSYY();
		String              sogSogCd  = eps0019.getSOGSOGCD();
		String              astAstGb  = eps0019.getASTASTGB();
		String              mngMngNo  = eps0019.getMNGMNGNO();
		String              bssBssNo  = eps0019.getBSSBSSNO();
		String              pumPumDt  = eps0019.getPUMPUMDT();
		String              pumPumAm  = eps0019.getPUMPUMAM();
		String              etcEtcNy  = eps0019.getETCETCNY();
		String              usrUsrId  = eps0019.getUSRUSRID();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		svcParam.put("HOUSE_CODE", houseCode);
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		svcParam.put("BNKBNKCD",   bnkBnkCd);
		svcParam.put("BMSBMSYY",   bmsBmsYy);
		svcParam.put("SOGSOGCD",   sogSogCd);
		svcParam.put("ASTASTGB",   astAstGb);
		svcParam.put("MNGMNGNO",   mngMngNo);
		svcParam.put("BSSBSSNO",   bssBssNo);
		svcParam.put("PUMPUMDT",   pumPumDt);
		svcParam.put("PUMPUMAM",   pumPumAm);
		svcParam.put("ETCETCNY",   etcEtcNy);
		svcParam.put("USRUSRID",   usrUsrId);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0019Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(); 
		}
	}
	
	private void updateSinfhdInfo(SepoaInfo info, String infNo, String status, String reason, String infReceiveNo){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("STATUS",         status);
			param.put("REASON",         reason);
			param.put("HOUSE_CODE",     houseCode);
			param.put("INF_NO",         infNo);
			param.put("INF_RECEIVE_NO", infReceiveNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfhdInfo", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	private EPS0019 getEps0019WebServiceEps0019(GridData gdReq, SepoaInfo info, String infNo) throws Exception{
		EPS0019 eps0019  = new EPS0019();
		String  bmsbmsyy = gdReq.getParam("bmsbmsyy");
		String  sogsogcd = gdReq.getParam("sogsogcd");
		String  astastgb = gdReq.getParam("astastgb");
		String  mngmngNo = gdReq.getParam("mngmngNo");
		String  bssbssno = gdReq.getParam("bssbssno");
		String  pumpumdt = gdReq.getParam("pumpumdt");
		String  pumpumam = gdReq.getParam("pumpumam");
		String  id       = this.getWebserviceId(info);
		
		pumpumam = pumpumam.replaceAll(",", "");
		pumpumdt = pumpumdt.replaceAll("/", "");
		
		eps0019.setMODE("S");
		eps0019.setBNKBNKCD("20");
		eps0019.setBMSBMSYY(bmsbmsyy);
		eps0019.setSOGSOGCD(sogsogcd);
		eps0019.setASTASTGB(astastgb);
		eps0019.setMNGMNGNO(mngmngNo);
		eps0019.setBSSBSSNO(bssbssno);
		eps0019.setPUMPUMDT(pumpumdt);
		eps0019.setPUMPUMAM(pumpumam);
		eps0019.setETCETCNY("ETC");
		eps0019.setUSRUSRID(id);
		eps0019.setINF_REF_NO(infNo);
		
		return eps0019;
	}
	
	private EPS0019 getEps0019WebServiceEps0019_2(GridData gdReq, SepoaInfo info, String infNo) throws Exception{		
		Map<String, String> header        = this.getHeader(gdReq, info);
    	
		EPS0019 eps0019  = new EPS0019();
		String  bmsbmsyy = header.get("bmsbmsyy");
		String  sogsogcd = header.get("sogsogcd");
		String  astastgb = header.get("astastgb");
		String  mngmngNo = header.get("mngmngNo");
		String  bssbssno = header.get("bssbssno");
		String  pumpumdt = header.get("pumpumdt");
		String  pumpumam = header.get("pumpumam");
		String  id       = this.getWebserviceId(info);
		
		pumpumam = pumpumam.replaceAll(",", "");
		pumpumdt = pumpumdt.replaceAll("/", "");
		
		eps0019.setMODE("S");
		eps0019.setBNKBNKCD("20");
		eps0019.setBMSBMSYY(bmsbmsyy);
		eps0019.setSOGSOGCD(sogsogcd);
		eps0019.setASTASTGB(astastgb);
		eps0019.setMNGMNGNO(mngmngNo);
		eps0019.setBSSBSSNO(bssbssno);
		eps0019.setPUMPUMDT(pumpumdt);
		eps0019.setPUMPUMAM(pumpumam);
		eps0019.setETCETCNY("ETC");
		eps0019.setUSRUSRID(id);
		eps0019.setINF_REF_NO(infNo);
		
		return eps0019;
	}
	
	private void updateSinfep0019Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		String              return3   = null;
		String              return4   = null;
		
		try{
			if("200".equals(code)){
				return3 = response[3];
				return4 = response[4];
			}
			else{
				return3 = "";
				return4 = "";
			}
			
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("RETURN4",    return3);
			param.put("RETURN5",    return4);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0019Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	private StringBuffer getEps0019WebService(GridData gdReq, SepoaInfo info) throws Exception{
		EPS_WSStub      epsWSStub       = null;
		EPS0019         eps0019         = null;
		EPS0019Response eps0019Response = null;
		ArrayOfString   arrayOfString   = null;
		String          infNo           = null;
		String          status          = null;
		String          reason          = null;
		String          code            = null;
		String          infReceiveNo    = null;
		String[]        response        = null;
		StringBuffer    stringBuffer    = null;
		
		try{
			epsWSStub = new EPS_WSStub();
			
			infNo   = this.insertSinfhdInfo(info, "EPS0019", "S");
			eps0019 = this.getEps0019WebServiceEps0019(gdReq, info, infNo);
			
			this.insertSinfep0019Info(info, infNo, eps0019);
			
			eps0019Response = epsWSStub.ePS0019(eps0019);
			arrayOfString   = eps0019Response.getEPS0019Result();
			response        = arrayOfString.getString();
			code            = response[0];
			infReceiveNo    = response[5];
			
			if("200".equals(code)){
				status = "Y";
				reason = "";
			}
			else{
				status = "N";
				reason = response[1];
			}
		}
		catch(Exception e){
			response = new String[3];
			
			status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			response[0] = "901";
			response[1] = reason;
			response[2] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
		this.updateSinfep0019Info(info, infNo, response);
		
		stringBuffer = this.getEps0019CodeJson(response);
		
		return stringBuffer;
	}
	
	private String[] getEps0019WebService2(GridData gdReq, SepoaInfo info) throws Exception{
		EPS_WSStub      epsWSStub       = null;
		EPS0019         eps0019         = null;
		EPS0019Response eps0019Response = null;
		ArrayOfString   arrayOfString   = null;
		String          infNo           = null;
		String          status          = null;
		String          reason          = null;
		String          code            = null;
		String          infReceiveNo    = null;
		String[]        response        = null;
		//StringBuffer    stringBuffer    = null;
		
		try{
			epsWSStub = new EPS_WSStub();
			
			infNo   = this.insertSinfhdInfo(info, "EPS0019", "S");
			eps0019 = this.getEps0019WebServiceEps0019_2(gdReq, info, infNo);
			
			this.insertSinfep0019Info(info, infNo, eps0019);
			
			eps0019Response = epsWSStub.ePS0019(eps0019);
			arrayOfString   = eps0019Response.getEPS0019Result();
			response        = arrayOfString.getString();
			code            = response[0];
			infReceiveNo    = response[5];
			
			if("200".equals(code)){
				status = "Y";
				reason = "";
			}
			else{
				status = "N";
				reason = response[1];
			}
		}
		catch(Exception e){
			response = new String[3];
			
			status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			response[0] = "901";
			response[1] = reason;
			response[2] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
		this.updateSinfep0019Info(info, infNo, response);
		
		//stringBuffer = this.getEps0019CodeJson(response);
		
		return response;
	}
	
	private StringBuffer getEps0019CodeJson(String[] response) throws Exception{
		String       code         = response[0];
		String       useMessage   = response[1];
		String       sysMessage   = response[2];
		StringBuffer stringBuffer = new StringBuffer();
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'").append(code).append("',");
		
		if("200".equals(code)){
			stringBuffer.append("year:'").append(useMessage).append("',");
			stringBuffer.append("number:'").append(sysMessage).append("',");
			stringBuffer.append("appNumber:'").append(response[3]).append("',");
			stringBuffer.append("appAmt:'").append(response[4]).append("'");
		}
		else{
			useMessage = this.getRemoveLineSeparator(useMessage);
			sysMessage = this.getRemoveLineSeparator(sysMessage);
			
			stringBuffer.append("useMessage:'").append(useMessage).append("',");
			stringBuffer.append("sysMessage:'").append(sysMessage).append("'");
		}
		
		stringBuffer.append("}");
		
		return stringBuffer;
	}
	
	private StringBuffer getExceptionJson(Exception e){
		StringBuffer stringBuffer = new StringBuffer();
		String       stackTrace   = this.getExceptionStackTrace(e);
		
		try{
			stackTrace = this.getRemoveLineSeparator(stackTrace);
		}
		catch(Exception e1){
			stackTrace = "";
		}
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'900',");
		stringBuffer.append(	"useMessage:'서블릿에러발생',");
		stringBuffer.append(	"sysMessage:'").append(stackTrace).append("'");
		stringBuffer.append("}");
		
		return stringBuffer;
	}
	
	private GridData getEps0019(GridData gdReq, SepoaInfo info) throws Exception{
		StringBuffer stringBuffer = null;
		String       result       = null;
		GridData     gdRes        = new GridData();
		
		try{
			stringBuffer = this.getEps0019WebService(gdReq, info);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			stringBuffer = this.getExceptionJson(e);
	    }
		
		result = stringBuffer.toString();
		
		gdRes.setMessage(result);
		
		return gdRes;
	}
	
	
	 private String[] getEps0019_1WebService2(SepoaInfo info, String bsmBsmYy, String bmsSrlNo, String appAppNo) throws Exception{
			EPS_WSStub      epsWSStub       = null;
			EPS0019_1         eps0019_1         = null;
			EPS0019_1Response eps0019_1Response = null;
			ArrayOfString   arrayOfString   = null;
			String          infNo           = null;
			String          status          = null;
			String          reason          = null;
			String          code            = null;
			String          infReceiveNo    = null;
			String[]        response        = null;
			//StringBuffer    stringBuffer    = null;
			
			try{
				epsWSStub = new EPS_WSStub();
				
				infNo   = this.insertSinfhdInfo(info, "EPS0019_1", "S");
				eps0019_1 = this.getEps0019_1WebServiceEps0019_1(info, infNo, bsmBsmYy, bmsSrlNo, appAppNo);
								
				this.insertSinfep0019_1Info(info, infNo, eps0019_1);
				
				eps0019_1Response = epsWSStub.ePS0019_1(eps0019_1);
				arrayOfString   = eps0019_1Response.getEPS0019_1Result();
				response        = arrayOfString.getString();
				code            = response[0];
				infReceiveNo    = response[3];
				
				if("200".equals(code)){
					status = "Y";
					reason = "";
				}
				else{
					status = "N";
					reason = response[1];
				}
			}
			catch(Exception e){
				response = new String[3];
				
				status = "N";
				reason = this.getExceptionStackTrace(e);
				reason = this.getStringMaxByte(reason, 4000);
				
				response[0] = "901";
				response[1] = reason;
				response[2] = reason;
				
				this.loggerExceptionStackTrace(e);
			}
			
			this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
			
			//stringBuffer = this.getEps0019CodeJson(response);
			
			return response;
		}
	 
	 private EPS0019_1 getEps0019_1WebServiceEps0019_1(SepoaInfo info, String infNo, String bsmBsmYy ,String bmsSrlNo, String appAppNo) throws Exception{		
			EPS0019_1 eps0019_1  = new EPS0019_1();
			String  id       = this.getWebserviceId(info);
			
//			MODE          작업구분         string / (고정형)1 D 예산 품의정보 삭제 필수 
//			BMSBMSYY  예산연도         string / (고정형)4  
//			BMSSRLNO  예산일련번호    string / (고정형)5   필수 
//			APPAPPNO  승인번호          string / (고정형)3   필수 
//			USRUSRID    사용자행번       string / (고정형)8   필수 
//			INF_REF_NO 인터페이스번호 string / (가변형)15 전자구매에서 생성한 인터페이스번호 필수 

			
			eps0019_1.setMODE("D");
			eps0019_1.setBMSBMSYY(bsmBsmYy);
			eps0019_1.setBMSSRLNO(bmsSrlNo);
			eps0019_1.setAPPAPPNO(appAppNo);
			eps0019_1.setUSRUSRID(id);
			eps0019_1.setINF_REF_NO(infNo);
			
			return eps0019_1;
		}
	 
	 private void insertSinfep0019_1Info(SepoaInfo info, String infNo, EPS0019_1 eps0019_1) throws Exception{
			Map<String, String> svcParam  = new HashMap<String, String>();
			String              houseCode = info.getSession("HOUSE_CODE");
			String              mode      = eps0019_1.getMODE();
			String              bmsBmsYy  = eps0019_1.getBMSBMSYY();
			String              bmsSrlNo  = eps0019_1.getBMSSRLNO();
			String              appAppNo  = eps0019_1.getAPPAPPNO();
			String              usrUsrId  = eps0019_1.getUSRUSRID();
			
			Object[]            obj       = new Object[1];
			SepoaOut            value     = null;
			boolean             isStatus  = false;
			
			svcParam.put("HOUSE_CODE", houseCode);
			svcParam.put("INF_NO",     infNo);
			svcParam.put("INF_MODE",   mode);
			svcParam.put("BMSBMSYY",   bmsBmsYy);
			svcParam.put("BMSBMSYY",   bmsBmsYy);
			svcParam.put("BMSSRLNO",   bmsSrlNo);
			svcParam.put("APPAPPNO",   appAppNo);
			svcParam.put("USRUSRID",   usrUsrId);
			
			obj[0]   = svcParam;
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0019_1Info", obj);
			isStatus = value.flag;
			
			if(isStatus == false) {
				throw new Exception(); 
			}
		}
	
	private EPS0021 getEps0021WebServiceEps0021(GridData gdReq, SepoaInfo info) throws Exception{
		EPS0021 eps0021        = new EPS0021();
		String  bdsBdsNo       = gdReq.getParam("bdsBdsNo");
		String  durtermy       = gdReq.getParam("durtermy");
		String  useUseVl       = gdReq.getParam("useUseVl");
		String  unqUnqNo       = null;
		String  id             = this.getWebserviceId(info);
		int     bdsBdsNoLength = bdsBdsNo.length();
		int     unqUnqNoIndex  = bdsBdsNoLength - 5;
		
		unqUnqNo = bdsBdsNo.substring(unqUnqNoIndex, bdsBdsNoLength);
		useUseVl = useUseVl.replace(",", "");
		
		eps0021.setMODE("S");
		eps0021.setUNQUNQNO(unqUnqNo);
		eps0021.setDURTERMY(durtermy);
		eps0021.setUSEUSEVL(useUseVl);
		eps0021.setUSRUSRID(id);
		
		return eps0021;
	}
	
	private void insertSinfep0021Info(SepoaInfo info, String infNo, EPS0021 eps0021) throws Exception{
		Map<String, String> svcParam  = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              mode      = eps0021.getMODE();
		String              unqUnqNo  = eps0021.getUNQUNQNO();
		String              durtermy  = eps0021.getDURTERMY();
		String              useUseVl  = eps0021.getUSEUSEVL();
		String              usrUsrId  = eps0021.getUSRUSRID();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		svcParam.put("HOUSE_CODE", houseCode);
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		svcParam.put("UNQUNQNO",   unqUnqNo);
		svcParam.put("DURTERMY",   durtermy);
		svcParam.put("USEUSEVL",   useUseVl);
		svcParam.put("USRUSRID",   usrUsrId);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0021Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(); 
		}
	}
	
	private void updateSinfep0021Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = null;
		
		try{
			if("300".equals(code)){
				return1 = "복구충당부채 기등록되어 있어 추가등록 불가";
			}
			else{
				return1 = response[1];
			}
			
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    response[2]);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0021Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	private StringBuffer getEps0021CodeJson(String[] response) throws Exception{
		String       code         = response[0];
		String       useMessage   = response[1];
		String       sysMessage   = response[2];
		StringBuffer stringBuffer = new StringBuffer();
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'").append(code).append("',");
		
		if("200".equals(code)){
			stringBuffer.append("dealDebt:'").append(useMessage).append("'");
		}
		else{
			useMessage = this.getRemoveLineSeparator(useMessage);
			sysMessage = this.getRemoveLineSeparator(sysMessage);
			
			stringBuffer.append("useMessage:'").append(useMessage).append("',");
			stringBuffer.append("sysMessage:'").append(sysMessage).append("'");
		}
		
		stringBuffer.append("}");
		
		return stringBuffer;
	}
	
	private StringBuffer getEps0021WebService(GridData gdReq, SepoaInfo info) throws Exception{
		EPS_WSStub      epsWSStub       = null;
		EPS0021         eps0021         = null;
		EPS0021Response eps0021Response = null;
		ArrayOfString   arrayOfString   = null;
		String          infNo           = null;
		String          status          = null;
		String          reason          = null;
		String          code            = null;
		String[]        response        = null;
		StringBuffer    stringBuffer    = null;
		
		try{
			epsWSStub = new EPS_WSStub();
			
			eps0021 = this.getEps0021WebServiceEps0021(gdReq, info);
			infNo   = this.insertSinfhdInfo(info, "EPS0021", "S");
			
			this.insertSinfep0021Info(info, infNo, eps0021);
			
			eps0021Response = epsWSStub.ePS0021(eps0021);
			arrayOfString   = eps0021Response.getEPS0021Result();
			response        = arrayOfString.getString();
			code            = response[0];
			
			if("200".equals(code)){
				status = "Y";
				reason = "";
			}
			else if("300".equals(code)){
				status      = "N";
				reason      = "복구충당부채 기등록되어 있어 추가등록 불가";
				response[1] = reason;
			}
			else{
				status = "N";
				reason = response[1];
			}
		}
		catch(Exception e){
			response = new String[3];
			
			status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			response[0] = "901";
			response[1] = reason;
			response[2] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, " ");
		this.updateSinfep0021Info(info, infNo, response);
		
		stringBuffer = this.getEps0021CodeJson(response);
		
		return stringBuffer;
	}
	
	private GridData getEps0021(GridData gdReq, SepoaInfo info) throws Exception{
		StringBuffer stringBuffer = null;
		String       result       = null;
		GridData     gdRes        = new GridData();
		
		try{
			stringBuffer = this.getEps0021WebService(gdReq, info);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			stringBuffer = this.getExceptionJson(e);
	    }
		
		result = stringBuffer.toString();
		
		gdRes.setMessage(result);
		
		return gdRes;
	}
	
	private GridData getTcpResult(GridData gdReq, SepoaInfo info) throws Exception{
		GridData     gdRes        = new GridData();
		StringBuffer stringBuffer = null;
		String       result       = null;
		
		try{
			tst_OT8701.main(null);
			
			stringBuffer = new StringBuffer();
			
			stringBuffer.append("{");
			stringBuffer.append(	"code:'200',");
			stringBuffer.append(	"useMessage:'호출성공',");
			stringBuffer.append(	"sysMessage:''");
			stringBuffer.append("}");
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			stringBuffer = this.getExceptionJson(e);
	    }
		
		result = stringBuffer.toString();
		
		gdRes.setMessage(result);
		
		return gdRes;
	}
	
	private EPS0015 getEps0015Eps0015(GridData gdReq, SepoaInfo info, String infNo) throws Exception{
		Map<String, String>          header        = this.getHeader(gdReq, info);
		Map<String, String>          gridInfo      = null;
		List<Map<String, String>>    grid          = this.getGrid(gdReq, info);
		EPS0015                      eps0015       = new EPS0015();
		String                       appAppYy      = header.get("appappyy");
		String                       pumPumNo      = header.get("bmssrlno");
		String                       appAppNo      = header.get("appappno");
		String                       appAppAm      = header.get("appappam");
		String                       jumJumCd      = null;
		String                       pmkPmkCd      = null;
		String                       mdlMdlNM      = null;
		String                       cnt           = null;
		String                       amt           = null;
		String                       buyBuyNm      = null;
		String                       id            = this.getWebserviceId(info);
		EPS0015_WSStub.ArrayOfString jumJumCdArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString pmkPmkCdArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString pmkSrlNoArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString mdlMdlNmArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString cntArray      = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString amtArray      = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString buyBuyNmArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString etcEtcNyArray = new EPS0015_WSStub.ArrayOfString();
		int                          gridSize      = grid.size();
		int                          i             = 0;
		
		appAppAm = appAppAm.replace(",", "");
		
		for(i = 0; i < gridSize; i++){
			gridInfo = grid.get(i);             
			jumJumCd = gridInfo.get("JUMJUMCD");
			pmkPmkCd = gridInfo.get("PMKPMKCD");
			mdlMdlNM = gridInfo.get("MDLMDLNM");
			cnt      = gridInfo.get("CNT");     
			amt      = gridInfo.get("AMT");     
			buyBuyNm = gridInfo.get("BUYBUYNM");
			
			jumJumCdArray.addString(jumJumCd);
			pmkPmkCdArray.addString(pmkPmkCd);
			pmkSrlNoArray.addString("1");
			mdlMdlNmArray.addString(mdlMdlNM);
			cntArray.addString(cnt);
			amtArray.addString(amt);
			buyBuyNmArray.addString(buyBuyNm);
			etcEtcNyArray.addString("");
		}
		
		eps0015.setMODE("C");
		eps0015.setBNKCD("20");
		eps0015.setPUMPUMYY(appAppYy);
		eps0015.setPUMPUMNO(pumPumNo);
		eps0015.setAPPAPPNO(appAppNo);
		eps0015.setAPPAPPAM(appAppAm);
		eps0015.setJUMJUMCD(jumJumCdArray);
		eps0015.setPMKPMKCD(pmkPmkCdArray);
		eps0015.setPMKSRLNO(pmkSrlNoArray);
		eps0015.setMDLMDLNM(mdlMdlNmArray);
		eps0015.setCNT(cntArray);
		eps0015.setAMT(amtArray);
		eps0015.setBUYBUYNM(buyBuyNmArray);
		eps0015.setETCETCNY(etcEtcNyArray);
		eps0015.setUSRUSRID(id);
		eps0015.setINF_REF_NO(infNo);
		
		return eps0015;
	}
	
	private Map<String, String> insertSinfep0015InfoSinfEp0015Info(EPS0015 eps0015, SepoaInfo info, String infNo) throws Exception{
		Map<String, String> sinfEp0015Info = new HashMap<String, String>();
		String              houseCode      = info.getSession("HOUSE_CODE");
		String              mode           = eps0015.getMODE();
		String              bnkCd          = eps0015.getBNKCD();
		String              pumPumYy       = eps0015.getPUMPUMYY();
		String              pumPumNo       = eps0015.getPUMPUMNO();
		String              appAppNo       = eps0015.getAPPAPPNO();
		String              appAppAm       = eps0015.getAPPAPPAM();
		String              usrUsrId       = eps0015.getUSRUSRID();
		
		sinfEp0015Info.put("HOUSE_CODE", houseCode);
		sinfEp0015Info.put("INF_NO",     infNo);
		sinfEp0015Info.put("INF_MODE",   mode);
		sinfEp0015Info.put("BNKCD",      bnkCd);
		sinfEp0015Info.put("PUMPUMYY",   pumPumYy);
		sinfEp0015Info.put("PUMPUMNO",   pumPumNo);
		sinfEp0015Info.put("APPAPPNO",   appAppNo);
		sinfEp0015Info.put("APPAPPAM",   appAppAm);
		sinfEp0015Info.put("USRUSRID",   usrUsrId);
		
		return sinfEp0015Info;
	}
	
	private List<Map<String, String>> insertSinfep0015InfoSinfEp0015PrList(EPS0015 eps0015, SepoaInfo info, String infNo) throws Exception{
		List<Map<String, String>>    sinfEp0015PrList     = new ArrayList<Map<String, String>>();
		EPS0015_WSStub.ArrayOfString jumJumCd             = eps0015.getJUMJUMCD();
		EPS0015_WSStub.ArrayOfString pmkPmkCd             = eps0015.getPMKPMKCD();
		EPS0015_WSStub.ArrayOfString pmkSrlNo             = eps0015.getPMKSRLNO();
		EPS0015_WSStub.ArrayOfString mdlMdlNm             = eps0015.getMDLMDLNM();
		EPS0015_WSStub.ArrayOfString cnt                  = eps0015.getCNT();
		EPS0015_WSStub.ArrayOfString amt                  = eps0015.getAMT();
		EPS0015_WSStub.ArrayOfString buyBuyNm             = eps0015.getBUYBUYNM();
		EPS0015_WSStub.ArrayOfString etcEtcNy             = eps0015.getETCETCNY();
		String[]                     jumJumCdArray        = jumJumCd.getString();
		String[]                     pmkPmkCdArray        = pmkPmkCd.getString();
		String[]                     pmkSrlNoArray        = pmkSrlNo.getString();
		String[]                     mdlMdlNmArray        = mdlMdlNm.getString();
		String[]                     cntArray             = cnt.getString();
		String[]                     amtArray             = amt.getString();
		String[]                     buyBuyNmArray        = buyBuyNm.getString();
		String[]                     etcEtcNyArray        = etcEtcNy.getString();
		String                       jumJumCdArrayInfo    = null;
		String                       pmkPmkCdArrayInfo    = null;
		String                       pmkSrlNoArrayInfo    = null;
		String                       mdlMdlNmArrayInfo    = null;
		String                       cntArrayInfo         = null;
		String                       amtArrayInfo         = null;
		String                       buyBuyNmArrayInfo    = null;
		String                       etcEtcNyArrayInfo    = null;
		String                       houseCode            = info.getSession("HOUSE_CODE");
		Map<String, String>          sinfEp0015PrListInfo = null;
		int                          etcEtcNyArrayLength  = etcEtcNyArray.length;
		int                          i                    = 0;
		
		for(i = 0; i < etcEtcNyArrayLength; i++){
			sinfEp0015PrListInfo = new HashMap<String, String>();
			
			jumJumCdArrayInfo = jumJumCdArray[i];
			pmkPmkCdArrayInfo = pmkPmkCdArray[i];
			pmkSrlNoArrayInfo = pmkSrlNoArray[i];
			mdlMdlNmArrayInfo = mdlMdlNmArray[i];
			cntArrayInfo      = cntArray[i];
			amtArrayInfo      = amtArray[i];
			buyBuyNmArrayInfo = buyBuyNmArray[i];
			etcEtcNyArrayInfo = etcEtcNyArray[i];
			
			sinfEp0015PrListInfo.put("HOUSE_CODE", houseCode);
			sinfEp0015PrListInfo.put("INF_NO",     infNo);
			sinfEp0015PrListInfo.put("SEQ",        Integer.toString(i));
			sinfEp0015PrListInfo.put("JUMJUMCD",   jumJumCdArrayInfo);
			sinfEp0015PrListInfo.put("PMKPMKCD",   pmkPmkCdArrayInfo);
			sinfEp0015PrListInfo.put("PMKSRLNO",   pmkSrlNoArrayInfo);
			sinfEp0015PrListInfo.put("MDLMDLNM",   mdlMdlNmArrayInfo);
			sinfEp0015PrListInfo.put("CNT",        cntArrayInfo);
			sinfEp0015PrListInfo.put("AMT",        amtArrayInfo);
			sinfEp0015PrListInfo.put("BUYBUYNM",   buyBuyNmArrayInfo);
			sinfEp0015PrListInfo.put("ETCETCNY",   etcEtcNyArrayInfo);
			
			sinfEp0015PrList.add(sinfEp0015PrListInfo);
		}
		
		return sinfEp0015PrList;
	}
	
	private void insertSinfep0015Info(EPS0015 eps0015, SepoaInfo info, String infNo) throws Exception{
		Object[]                  svcParamObj      = new Object[1];
		Map<String, Object>       svcParamObjInfo  = new HashMap<String, Object>();
		Map<String, String>       sinfEp0015Info   = this.insertSinfep0015InfoSinfEp0015Info(eps0015, info, infNo);
		List<Map<String, String>> sinfEp0015PrList = this.insertSinfep0015InfoSinfEp0015PrList(eps0015, info, infNo);
		SepoaOut                  value            = null;
		boolean                   flag             = false;
		
		svcParamObjInfo.put("sinfEp0015Info",   sinfEp0015Info);
		svcParamObjInfo.put("sinfEp0015PrList", sinfEp0015PrList);
		
		svcParamObj[0] = svcParamObjInfo;
		
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0015Info", svcParamObj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
	}
	
	private void updateSinfep0015Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0015Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	private String[] getEPS0015Result(EPS0015 eps0015) throws Exception{
		EPS0015Response              eps0015Response = new EPS0015_WSStub().ePS0015(eps0015);
		EPS0015_WSStub.ArrayOfString arrayOfString   = eps0015Response.getEPS0015Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
	
    private GridData getEps0015(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	String   gdResMessage = null;
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String[] result       = null;
    	EPS0015  eps0015      = null;
    	boolean  isStatus     = false;
    	
    	try {
    		infNo   = this.insertSinfhdInfo(info, "EPS0015", "S");
    		eps0015 = this.getEps0015Eps0015(gdReq, info, infNo);
    		
    		this.insertSinfep0015Info(eps0015, info, infNo);
    		
    		result       = this.getEPS0015Result(eps0015);
    		code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status       = "Y";
				reason       = "";
				isStatus     = true;
	    		gdResMessage = "자산등재되었습니다.";
    		}
    		else{
    			status       = "N";
				reason       = result[1];
    			isStatus     = false;
        		gdResMessage = "자산등재에 실패하였습니다.";
    		}
    	}
    	catch(Exception e){
    		result = new String[3];
    		
    		gdResMessage = "자산등재에 실패하였습니다.";
	    	isStatus     = false;
	    	status       = "N";
			reason       = this.getExceptionStackTrace(e);
			reason       = this.getStringMaxByte(reason, 4000);
			infReceiveNo = "";
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0015Info(info, infNo, result);
    	
    	gdRes.setSelectable(false);
		gdRes.addParam("mode", "doSave");
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    private EPS0016 getEps0016Eps0016(GridData gdReq, SepoaInfo info, String infNo) throws Exception{
    	EPS0016                      eps0016      = new EPS0016();
    	Map<String, String>          header       = this.getHeader(gdReq, info);
    	Map<String, String>          gridInfo     = null;
    	List<Map<String, String>>    grid         = this.getGrid(gdReq, info);
    	String                       appAppYy     = header.get("appappyy");
    	String                       bmsSrlNo     = header.get("bmssrlno");
    	String                       appAppNo     = header.get("appappno");
    	String                       appAppAm     = header.get("appappam");
    	String                       dosUnqNoInfo = null;
    	String                       updjbmtInfo  = null;
    	String                       id           = this.getWebserviceId(info);
    	EPS0016_WSStub.ArrayOfString dosUnqNo     = new EPS0016_WSStub.ArrayOfString();
    	EPS0016_WSStub.ArrayOfString updjbmt      = new EPS0016_WSStub.ArrayOfString();
    	EPS0016_WSStub.ArrayOfString etcEtcNy     = new EPS0016_WSStub.ArrayOfString();
    	int                          gridSize     = grid.size();
    	int                          i            = 0;
    	
    	appAppAm = appAppAm.replace(",", "");
    	
    	for(i = 0; i < gridSize; i++){
    		gridInfo     = grid.get(i);
    		dosUnqNoInfo = gridInfo.get("DOSUNQNO");
    		updjbmtInfo  = gridInfo.get("UPDJBMT");
    		
    		dosUnqNo.addString(dosUnqNoInfo);
    		updjbmt.addString(updjbmtInfo);
    		etcEtcNy.addString("");
    	}
    	    	
    	eps0016.setMODE("C");
    	eps0016.setBNKBNKCD("20");
    	eps0016.setPUMPUMYY(appAppYy);
    	eps0016.setPUMPUMNO(bmsSrlNo);
    	eps0016.setAPPAPPNO(appAppNo);
    	eps0016.setAPPAPPAM(appAppAm);
    	eps0016.setDOSUNQNO(dosUnqNo);
    	eps0016.setUPDJBMT(updjbmt);
    	eps0016.setETCETCNY(etcEtcNy);
    	eps0016.setUSRUSRID(id);
    	eps0016.setINF_REF_NO(infNo);
    	
    	return eps0016;
    }
    
    private Map<String, String> insertSinfep0016InfoSinfEp0016Info(EPS0016 eps0016, SepoaInfo info, String infNo) throws Exception{
    	Map<String, String> sinfEp0016Info = new HashMap<String, String>();
    	String              houseCode      = info.getSession("HOUSE_CODE");
    	String              mode           = eps0016.getMODE();
    	String              bnkBnkCd       = eps0016.getBNKBNKCD();
    	String              pumPumYy       = eps0016.getPUMPUMYY();
    	String              pumPumNo       = eps0016.getPUMPUMNO();
    	String              appAppNo       = eps0016.getAPPAPPNO();
    	String              appAppAm       = eps0016.getAPPAPPAM();
    	
    	sinfEp0016Info.put("HOUSE_CODE", houseCode);
    	sinfEp0016Info.put("INF_NO",     infNo);
    	sinfEp0016Info.put("INF_MODE",   mode);
    	sinfEp0016Info.put("BNKBNKCD",   bnkBnkCd);
    	sinfEp0016Info.put("PUMPUMYY",   pumPumYy);
    	sinfEp0016Info.put("PUMPUMNO",   pumPumNo);
    	sinfEp0016Info.put("APPAPPNO",   appAppNo);
    	sinfEp0016Info.put("APPAPPAM",   appAppAm);
    	
    	return sinfEp0016Info;
    }
    
    private List<Map<String, String>> insertSinfep0016InfoSinfEp0016PrList(EPS0016 eps0016, SepoaInfo info, String infNo) throws Exception{
    	List<Map<String, String>>    sinfEp0016PrList     = new ArrayList<Map<String, String>>();
    	EPS0016_WSStub.ArrayOfString dosUnqNo             = eps0016.getDOSUNQNO();
    	EPS0016_WSStub.ArrayOfString updjbmt              = eps0016.getUPDJBMT();
    	EPS0016_WSStub.ArrayOfString etcEtcNy             = eps0016.getETCETCNY();
    	String[]                     dosUnqNoArray        = dosUnqNo.getString();
    	String[]                     updjbmtArray         = updjbmt.getString();
    	String[]                     etcEtcNyArray        = etcEtcNy.getString();
    	String                       dosUnqNoArrayInfo    = null;
    	String                       updjbmtArrayInfo     = null;
    	String                       etcEtcNyArrayInfo    = null;
    	Map<String, String>          sinfEp0016PrListInfo = null;
    	String                       houseCode            = info.getSession("HOUSE_CODE");
    	int                          etcEtcNyArrayLength  = etcEtcNyArray.length;
    	int                          i                    = 0;
    	
    	for(i = 0; i < etcEtcNyArrayLength; i++){
    		sinfEp0016PrListInfo = new HashMap<String, String>();
    		
    		dosUnqNoArrayInfo = dosUnqNoArray[i];
    		updjbmtArrayInfo  = updjbmtArray[i];
    		etcEtcNyArrayInfo = etcEtcNyArray[i];
    		
    		sinfEp0016PrListInfo.put("HOUSE_CODE", houseCode);
    		sinfEp0016PrListInfo.put("INF_NO",     infNo);
    		sinfEp0016PrListInfo.put("SEQ",        Integer.toString(i));
    		sinfEp0016PrListInfo.put("DOSUNQNO",   dosUnqNoArrayInfo);
    		sinfEp0016PrListInfo.put("UPDJBMT",    updjbmtArrayInfo);
    		sinfEp0016PrListInfo.put("ETCETCNY",   etcEtcNyArrayInfo);
    		
    		sinfEp0016PrList.add(sinfEp0016PrListInfo);
    	}
    	
    	return sinfEp0016PrList;
    }
    
    private void insertSinfep0016Info(EPS0016 eps0016, SepoaInfo info, String infNo) throws Exception{
    	Object[]                  svcObj           = new Object[1];
    	Map<String, Object>       svcObjInfo       = new HashMap<String, Object>();
    	Map<String, String>       sinfEp0016Info   = this.insertSinfep0016InfoSinfEp0016Info(eps0016, info, infNo);
    	List<Map<String, String>> sinfEp0016PrList = this.insertSinfep0016InfoSinfEp0016PrList(eps0016, info, infNo);
    	SepoaOut                  value            = null;
    	boolean                   flag             = false;
    	
    	svcObjInfo.put("sinfEp0016Info",   sinfEp0016Info);
    	svcObjInfo.put("sinfEp0016PrList", sinfEp0016PrList);
    	
    	svcObj[0] = svcObjInfo;
    	
    	value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0016Info", svcObj);
    	flag  = value.flag;
    	
    	if(flag == false){
			throw new Exception();
		}
    }
    
    private String[] getEPS0016Result(EPS0016 eps0016) throws Exception{
		EPS0016Response              eps0016Response = new EPS0016_WSStub().ePS0016(eps0016);
		EPS0016_WSStub.ArrayOfString arrayOfString   = eps0016Response.getEPS0016Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
    
    private void updateSinfep0016Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0016Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private GridData getEps0016(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	String   gdResMessage = null;
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String[] result       = null;
    	EPS0016  eps0016      = null;
    	boolean  isStatus     = false;
    	
    	try {
    		infNo   = this.insertSinfhdInfo(info, "EPS0016", "S");
    		eps0016 = this.getEps0016Eps0016(gdReq, info, infNo);
    		
    		this.insertSinfep0016Info(eps0016, info, infNo);
    		
    		result       = this.getEPS0016Result(eps0016);
    		code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status       = "Y";
				reason       = "";
				isStatus     = true;
	    		gdResMessage = "자산등재되었습니다.";
    		}
    		else{
    			status       = "N";
				reason       = result[1];
    			isStatus     = false;
        		gdResMessage = "자산등재에 실패하였습니다.";
    		}
    	}
    	catch(Exception e){
    		result = new String[3];
    		
    		gdResMessage = "자산등재에 실패하였습니다.";
	    	isStatus     = false;
	    	status       = "N";
			reason       = this.getExceptionStackTrace(e);
			reason       = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0016Info(info, infNo, result);
    	
    	gdRes.setSelectable(false);
		gdRes.addParam("mode", "doSave");
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    private void insertSinfep0017Info(EPS0017 eps0017, SepoaInfo info, String infNo) throws Exception{
    	Object[]            svcObj         = new Object[1];
    	Map<String, String> sinfEp0017Info = new HashMap<String, String>();
    	SepoaOut            value          = null;
    	String              houseCode      = info.getSession("HOUSE_CODE");
    	String              mode           = eps0017.getMODE();
    	String              pumPumYy       = eps0017.getPUMPUMYY();
    	String              pumPumNo       = eps0017.getPUMPUMNO();
    	String              appAppNo       = eps0017.getAPPAPPNO();
    	String              appAppAm       = eps0017.getAPPAPPAM();
    	String              jumJumCd       = eps0017.getJUMJUMCD();
    	String              astAstGb       = eps0017.getASTASTGB();
    	String              unqUnqNo       = eps0017.getUNQUNQNO();
    	String              actActGb       = eps0017.getACTACTGB();
    	String              chgChgAm       = eps0017.getCHGCHGAM();
    	String              trnTrnGb       = eps0017.getTRNTRNGB();
    	String              usrUsrId       = eps0017.getUSRUSRID();
    	boolean             flag           = false;
    	
    	sinfEp0017Info.put("HOUSE_CODE", houseCode);
    	sinfEp0017Info.put("INF_NO",     infNo);
    	sinfEp0017Info.put("INF_MODE",   mode);
    	sinfEp0017Info.put("PUMPUMYY",   pumPumYy);
    	sinfEp0017Info.put("PUMPUMNO",   pumPumNo);
    	sinfEp0017Info.put("APPAPPNO",   appAppNo);
    	sinfEp0017Info.put("APPAPPAM",   appAppAm);
    	sinfEp0017Info.put("JUMJUMCD",   jumJumCd);
    	sinfEp0017Info.put("ASTASTGB",   astAstGb);
    	sinfEp0017Info.put("UNQUNQNO",   unqUnqNo);
    	sinfEp0017Info.put("ACTACTGB",   actActGb);
    	sinfEp0017Info.put("CHGCHGAM",   chgChgAm);
    	sinfEp0017Info.put("TRNTRNGB",   trnTrnGb);
    	sinfEp0017Info.put("USRUSRID",   usrUsrId);
    	
    	svcObj[0] = sinfEp0017Info;
    	
    	value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0017Info", svcObj);
    	flag  = value.flag;
    	
    	if(flag == false){
			throw new Exception();
		}
    }
    
    private EPS0017 getEps0017Eps0017(GridData gdReq, SepoaInfo info, String infNo) throws Exception{
    	EPS0017             result             = new EPS0017();
    	String              pumPumYy           = gdReq.getParam("appappyy"); 
    	String              pumPumNo           = gdReq.getParam("bmssrlno"); 
    	String              appAppNo           = gdReq.getParam("appappno"); 
    	String              appAppAm           = gdReq.getParam("appappam"); 
    	String              jumJumCd           = gdReq.getParam("jumjum_cd");
    	String              bdsBdsCd           = gdReq.getParam("bdsBdsCd"); 
    	String              trnTrnGb           = gdReq.getParam("deal_kind");
    	String              astAstGb           = bdsBdsCd.substring(0, 2);
    	String              bdsBdsNo           = null;
    	String              id                 = this.getWebserviceId(info);
    	int                 bdsBdsCdLength     = bdsBdsCd.length();
    	int                 bdsBdsNoStartIndex = bdsBdsCdLength - 5;
    	
    	appAppAm = appAppAm.replace(",", "");
    	bdsBdsNo = bdsBdsCd.substring(bdsBdsNoStartIndex, bdsBdsCdLength);
    	
    	result.setMODE("C");
    	result.setPUMPUMYY(pumPumYy);
    	result.setPUMPUMNO(pumPumNo);
    	result.setAPPAPPNO(appAppNo);
    	result.setAPPAPPAM(appAppAm);
    	result.setJUMJUMCD(jumJumCd);
    	result.setASTASTGB(astAstGb);
    	result.setUNQUNQNO(bdsBdsNo);
    	result.setACTACTGB("03");
    	result.setCHGCHGAM(appAppAm);
    	result.setTRNTRNGB(trnTrnGb);
    	result.setUSRUSRID(id);
    	result.setINF_REF_NO(infNo);
    	
    	return result;
    }
    
    private String[] getEPS0017Result(EPS0017 eps0017) throws Exception{
		EPS0017Response              eps0017Response = new EPS0017_WSStub().ePS0017(eps0017);
		EPS0017_WSStub.ArrayOfString arrayOfString   = eps0017Response.getEPS0017Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
    
    private void updateSinfep0017Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0017Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String getEps0017Json(String[] result){
		StringBuffer stringBuffer = new StringBuffer();
		String       code         = result[0];
		String       reason       = result[1];
		String       jsonResult   = null;
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'").append(code).append("',");
		stringBuffer.append(	"message:'").append(reason).append("'");
		stringBuffer.append("}");
		
		jsonResult = stringBuffer.toString();
		
		return jsonResult;
	}
    
    private GridData getEps0017(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	String   gdResMessage = null;
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String   astAstGb     = null;
    	String[] result       = new String[3];
    	EPS0017  eps0017      = null;
    	
    	try {
    		infNo    = this.insertSinfhdInfo(info, "EPS0017", "S");
    		eps0017  = this.getEps0017Eps0017(gdReq, info, infNo);
    		astAstGb = eps0017.getASTASTGB();
    		
    		this.insertSinfep0017Info(eps0017, info, infNo);
    		
    		if(
    			("10".equals(astAstGb) == false) &&
    			("20".equals(astAstGb) == false) &&
    			("30".equals(astAstGb) == false)
    		){
    			status = "N";
				reason = "토지, 건물, 임차점포시설물만 거래가능합니다.";
    			
    			result[0] = "901";
    			result[1] = "토지, 건물, 임차점포시설물만 거래가능합니다.";
    			result[2] = null;
    		}
    		else{
    			result       = this.getEPS0017Result(eps0017);
        		code         = result[0];
        		infReceiveNo = result[3];
        		
        		if("200".equals(code)){
        			status = "Y";
    				reason = "";
        		}
        		else{
        			status = "N";
    				reason = result[1];
        		}
    		}
    	}
    	catch(Exception e){
    		status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = "서블릿에서 에러가 발생하였습니다.";
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0017Info(info, infNo, result);
    	
    	gdResMessage = this.getEps0017Json(result);
    	
    	gdRes.setMessage(gdResMessage);
    	
    	return gdRes;
    }
    
    private EPS0018 getEps0018Eps0018(GridData gdReq, SepoaInfo info, String infNo) throws Exception{
    	EPS0018             eps0018            = new EPS0018();
    	String              pumPumYy           = gdReq.getParam("appappyy");
    	String              pumPumNo           = gdReq.getParam("bmssrlno");
    	String              appAppNo           = gdReq.getParam("appappno");
    	String              appAppAm           = gdReq.getParam("appappam");
    	String              jumJumCd           = gdReq.getParam("jumjum_cd");
    	String              bdsBdsCd           = gdReq.getParam("bdsBdsCd");
    	String              trnTrnGb           = gdReq.getParam("deal_kind");
    	String              durTerMy           = gdReq.getParam("use_kind");
    	String              useUseVl           = gdReq.getParam("deal_area");
    	String              astAstGb           = bdsBdsCd.substring(0, 2);
    	String              unqUnqNo           = null;
    	String              totBcbAm           = gdReq.getParam("deal_debt");
    	String              id                 = this.getWebserviceId(info);
    	int                 bdsBdsCdLength     = bdsBdsCd.length();
    	int                 unqUnqNoStartIndex = bdsBdsCdLength - 5;
    	
    	appAppAm = appAppAm.replace(",", "");
    	totBcbAm = totBcbAm.replace(",", "");
    	unqUnqNo = bdsBdsCd.substring(unqUnqNoStartIndex, bdsBdsCdLength);
    	
    	eps0018.setMODE("C");
    	eps0018.setPUMPUMYY(pumPumYy);
    	eps0018.setPUMPUMNO(pumPumNo);
    	eps0018.setAPPAPPNO(appAppNo);
    	eps0018.setAPPAPPAM(appAppAm);
    	eps0018.setJUMJUMCD(jumJumCd);
    	eps0018.setASTASTGB(astAstGb);
    	eps0018.setUNQUNQNO(unqUnqNo);
    	eps0018.setACTACTGB("03");
    	eps0018.setCHGCHGAM(appAppAm);
    	eps0018.setTRNTRNGB(trnTrnGb);
    	eps0018.setUSRUSRID(id);
    	eps0018.setDURTERMY(durTerMy);
    	eps0018.setUSEUSEVL(useUseVl);
    	eps0018.setTOTBCBAM(totBcbAm);
    	eps0018.setINF_REF_NO(infNo);
    	
    	return eps0018;
    }
    
    private void insertSinfep0018Info(EPS0018 eps0018, SepoaInfo info, String infNo) throws Exception{
    	Object[]            svcObj         = new Object[1];
    	Map<String, String> sinfEp0018Info = new HashMap<String, String>();
    	SepoaOut            value          = null;
    	String              houseCode      = info.getSession("HOUSE_CODE");
    	String              infMode        = eps0018.getMODE();
    	String              pumPumYy       = eps0018.getPUMPUMYY();
    	String              pumPumNo       = eps0018.getPUMPUMNO();
    	String              appAppNo       = eps0018.getAPPAPPNO();
    	String              appAppAm       = eps0018.getAPPAPPAM();
    	String              jumJumCd       = eps0018.getJUMJUMCD();
    	String              astAstGb       = eps0018.getASTASTGB();
    	String              unqUnqNo       = eps0018.getUNQUNQNO();
    	String              actActGb       = eps0018.getACTACTGB();
    	String              chgChgAm       = eps0018.getCHGCHGAM();
    	String              trnTrnGb       = eps0018.getTRNTRNGB();
    	String              usrUsrId       = eps0018.getUSRUSRID();
    	String              durTerMy       = eps0018.getDURTERMY();
    	String              useUseVl       = eps0018.getUSEUSEVL();
    	String              totBcbAm       = eps0018.getTOTBCBAM();
    	boolean             flag           = false;
    	
    	sinfEp0018Info.put("HOUSE_CODE", houseCode);
    	sinfEp0018Info.put("INF_NO",     infNo);
    	sinfEp0018Info.put("INF_MODE",   infMode);
    	sinfEp0018Info.put("PUMPUMYY",   pumPumYy);
    	sinfEp0018Info.put("PUMPUMNO",   pumPumNo);
    	sinfEp0018Info.put("APPAPPNO",   appAppNo);
    	sinfEp0018Info.put("APPAPPAM",   appAppAm);
    	sinfEp0018Info.put("JUMJUMCD",   jumJumCd);
    	sinfEp0018Info.put("ASTASTGB",   astAstGb);
    	sinfEp0018Info.put("UNQUNQNO",   unqUnqNo);
    	sinfEp0018Info.put("ACTACTGB",   actActGb);
    	sinfEp0018Info.put("CHGCHGAM",   chgChgAm);
    	sinfEp0018Info.put("TRNTRNGB",   trnTrnGb);
    	sinfEp0018Info.put("USRUSRID",   usrUsrId);
    	sinfEp0018Info.put("DURTERMY",   durTerMy);
    	sinfEp0018Info.put("USEUSEVL",   useUseVl);
    	sinfEp0018Info.put("TOTBCBAM",   totBcbAm);
		
    	svcObj[0] = sinfEp0018Info;
    	
    	value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0018Info", svcObj);
    	flag  = value.flag;
    	
    	if(flag == false){
			throw new Exception();
		}
    }
    
    private String[] getEPS0018Result(EPS0018 eps0018) throws Exception{
		EPS0018Response              eps0018Response = new EPS0018_WSStub().ePS0018(eps0018);
		EPS0018_WSStub.ArrayOfString arrayOfString   = eps0018Response.getEPS0018Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
    
    private void updateSinfep0018Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0018Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String getEps0018Json(String[] result){
		StringBuffer stringBuffer = new StringBuffer();
		String       code         = result[0];
		String       reason       = result[1];
		String       jsonResult   = null;
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'").append(code).append("',");
		stringBuffer.append(	"message:'").append(reason).append("'");
		stringBuffer.append("}");
		
		jsonResult = stringBuffer.toString();
		
		return jsonResult;
	}
    
    private GridData getEps0018(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	String   gdResMessage = null;
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String   astAstGb     = null;
    	String[] result       = new String[3];
    	EPS0018  eps0018      = null;
    	
    	try {
    		infNo    = this.insertSinfhdInfo(info, "EPS0018", "S");
    		eps0018  = this.getEps0018Eps0018(gdReq, info, infNo);
    		astAstGb = eps0018.getASTASTGB();
    		
    		this.insertSinfep0018Info(eps0018, info, infNo);
    		
    		if("30".equals(astAstGb) == false){
    			status = "N";
				reason = "임차점포시설물만 거래가능합니다.";
    			
    			result[0] = "901";
    			result[1] = "임차점포시설물만 거래가능합니다.";
    			result[2] = null;
    		}
    		else{
    			result       = this.getEPS0018Result(eps0018);
        		code         = result[0];
        		infReceiveNo = result[3];
        		
        		if("200".equals(code)){
        			status = "Y";
    				reason = "";
        		}
        		else{
        			status = "N";
    				reason = result[1];
        		}
    		}
    	}
    	catch(Exception e){
    		status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0018Info(info, infNo, result);
    	
    	gdResMessage = this.getEps0018Json(result);
    	
    	gdRes.setMessage(gdResMessage);
    	
    	return gdRes;
    }
    
    private String getReqPsNo(SepoaInfo info) throws Exception{
		SepoaOut wo        = DocumentUtil.getDocNumber(info, "PS");
		String   reqItemNo = wo.result[0];
		
		return reqItemNo;
	}
    
    private String insetSpy1InfoObjHeaderVendorTaxNoSeq(GridData gdReq, SepoaInfo info) throws Exception{
    	String              result              = null;
    	Map<String, String> header              = this.getHeader(gdReq, info);
    	String              taxNoParameter      = header.get("taxNoParameter");
    	String              taxSeqParameter     = header.get("taxSeqParameter");
    	String              taxNoArrayInfo      = null;
    	String              taxSeqArrayInfo     = null;
    	String[]            taxNoArray          = taxNoParameter.split(",");
    	String[]            taxSeqArray         = taxSeqParameter.split(",");
    	StringBuffer        stringBuffer        = new StringBuffer();
    	int                 i                   = 0;
    	int                 taxNoArrayLength    = taxNoArray.length;
    	int                 taxNoArrayLastIndex = taxNoArrayLength - 1;
    	
    	for(i = 0; i < taxNoArrayLength; i++){
    		taxNoArrayInfo  = taxNoArray[i];
    		taxSeqArrayInfo = taxSeqArray[i];
    		
    		stringBuffer.append("('").append(taxNoArrayInfo).append("', '").append(taxSeqArrayInfo).append("')");
			
			if(i != taxNoArrayLastIndex){
				stringBuffer.append(", ");
			}
    	}
    	
    	result = stringBuffer.toString();
    	
    	return result;
    }
    
    private String insetSpy1InfoObjHeaderVendorTaxNo(GridData gdReq, SepoaInfo info) throws Exception{
    	String              result              = null;
    	Map<String, String> header              = this.getHeader(gdReq, info);
    	String              taxNoParameter      = header.get("taxNoParameter");
    	String              taxNoArrayInfo      = null;
    	String[]            taxNoArray          = taxNoParameter.split(",");
    	StringBuffer        stringBuffer        = new StringBuffer();
    	int                 i                   = 0;
    	int                 taxNoArrayLength    = taxNoArray.length;
    	int                 taxNoArrayLastIndex = taxNoArrayLength - 1;
    	
    	for(i = 0; i < taxNoArrayLength; i++){
    		taxNoArrayInfo  = taxNoArray[i];
    		
    		stringBuffer.append("'").append(taxNoArrayInfo).append("'");
			
			if(i != taxNoArrayLastIndex){
				stringBuffer.append(", ");
			}
    	}
    	
    	result = stringBuffer.toString();
    	
    	return result;
    }
    
    private Map<String, String> insetSpy1InfoObjHeaderVendor(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result              = new HashMap<String, String>();
    	Map<String, String> vendorInfoParam     = new HashMap<String, String>();
//    	String              taxNoSeq            = this.insetSpy1InfoObjHeaderVendorTaxNoSeq(gdReq, info);
    	String              taxNo               = this.insetSpy1InfoObjHeaderVendorTaxNo(gdReq, info);
    	String              houseCode           = info.getSession("HOUSE_CODE");
    	String              sepoaOutResultInfo  = null;
    	String[]            sepoaOutResult      = null;
    	Object[]            vendorInfoPararmObj = new Object[1];
    	SepoaOut            sepoaOut            = null;
    	SepoaFormater       sepoaFormater       = null;
    	boolean             sepoaOutFlag        = false;
    	int                 rowCount            = 0;
    	
//    	vendorInfoParam.put("taxNoSeq",   taxNoSeq);
    	vendorInfoParam.put("taxNo",   taxNo);
    	vendorInfoParam.put("HOUSE_CODE", houseCode);
    	
    	vendorInfoPararmObj[0] = vendorInfoParam;
    	sepoaOut               = ServiceConnector.doService(info, "TX_005", "CONNECTION", "selectValidVendor", vendorInfoPararmObj);
    	
    	sepoaOutFlag = sepoaOut.flag;
		
		if(sepoaOutFlag){
			sepoaOutResult     = sepoaOut.result;
			sepoaOutResultInfo = sepoaOutResult[0];
			
			sepoaFormater = new SepoaFormater(sepoaOutResultInfo);
			
			rowCount = sepoaFormater.getRowCount();
			
			if(rowCount == 1){
				result.put("vendorCode",    sepoaFormater.getValue("VENDOR_CODE",     0));
				result.put("vendorNameLoc", sepoaFormater.getValue("VENDOR_NAME_LOC", 0));
				result.put("irsNo",         sepoaFormater.getValue("IRS_NO",          0));
				result.put("depositorName", sepoaFormater.getValue("DEPOSITOR_NAME",  0));
				result.put("bankName",      sepoaFormater.getValue("BANK_NAME",       0));
				result.put("bankAcct",      sepoaFormater.getValue("BANK_ACCT",       0));
				result.put("bankCode",      sepoaFormater.getValue("BANK_CODE",       0));
				
				sepoaOut           = ServiceConnector.doService(info, "TX_005", "CONNECTION", "selectSumDelyAmt", vendorInfoPararmObj);
				sepoaOutResult     = sepoaOut.result;
				sepoaOutResultInfo = sepoaOutResult[0];
				
				sepoaFormater = new SepoaFormater(sepoaOutResultInfo);
				
				result.put("sumDelyAmt", sepoaFormater.getValue("AMT", 0));
			}
		}
		else{
			throw new Exception();
		}
		
    	return result;
    }
    
    private Map<String, String> insetSpy1InfoObjHeader(GridData gdReq, SepoaInfo info, String psNo, String[] response) throws Exception{
    	Map<String, String> result        = new HashMap<String, String>();
    	Map<String, String> header        = this.getHeader(gdReq, info);
    	Map<String, String> vendorInfo    = this.insetSpy1InfoObjHeaderVendor(gdReq, info);
    	String              sumDelyAmt    = vendorInfo.get("sumDelyAmt");
    	String              signerFlag    = null;
    	String              signerSelect  = null;
    	String              appappam      = header.get("appappam");
    	String              dealDebt      = header.get("deal_debt");
    	String              dealArea      = header.get("deal_area");
    	String              beforeSignNo  = null;
    	int                 sumDelyAmtInt = Integer.parseInt(sumDelyAmt);
    	
    	if(sumDelyAmtInt >= 50000000){  //TOBE 2017-07-01  5천 초과 => 5천이상 
    		signerFlag   = "Y";
    		signerSelect = header.get("signerSelect");
    		
    		if(sumDelyAmtInt >= 200000000){  //TOBE 2017-07-01  > 1억 초과 => 2억 이상
    			beforeSignNo = header.get("signerBeforeSelect");
    		}
    		else{
    			beforeSignNo = null;
    		}
    	}
    	else{
    		signerFlag   = "N";
    		signerSelect = null;
    		beforeSignNo = null;
    	}
    	
    	appappam = appappam.replace(",", "");
    	dealDebt = this.nvl(dealDebt);
    	dealDebt = dealDebt.replace(",", "");
    	dealArea = this.nvl(dealArea);
    	dealArea = dealArea.replace(",", "");
    	
    	result.put("HOUSE_CODE",     info.getSession("HOUSE_CODE"));
    	result.put("PAY_SEND_NO",    psNo);
    	result.put("VENDOR_CODE",    vendorInfo.get("vendorCode"));
    	result.put("VENDOR_NAME_LOC",    vendorInfo.get("vendorNameLoc"));
    	result.put("DEPOSITOR_NAME", vendorInfo.get("depositorName"));
    	result.put("BANK_CODE",      vendorInfo.get("bankCode"));
    	result.put("BANK_ACCT",      vendorInfo.get("bankAcct"));
    	result.put("PAY_AMT",        sumDelyAmt);
    	result.put("SIGNER_FLAG",    signerFlag);
    	result.put("SIGNER_NO",      signerSelect);
    	result.put("WORK_KIND",      header.get("rdoWorkKindValue"));
    	result.put("BMSBMSYY",       header.get("bmsbmsyy"));
    	result.put("SOGSOGCD",       header.get("sogsogcd"));
    	result.put("ASTASTGB",       header.get("astastgb"));
    	result.put("MNGMNGNO",       header.get("mngmngNo"));
    	result.put("BSSBSSNO",       header.get("bssbssno"));
//    	result.put("APPAPPYY",       header.get("appappyy"));
    	result.put("APPAPPYY",        response[1]);
//    	result.put("BMSSRLNO",       header.get("bmssrlno"));
    	result.put("BMSSRLNO",       response[2]);
//    	result.put("APPAPPNO",       header.get("appappno"));
    	result.put("APPAPPNO",        response[3]);
//    	result.put("APPAPPAM",       appappam);
    	result.put("APPAPPAM",       response[4]);
    	result.put("JUMJUM_CD",      header.get("jumjum_cd"));
    	result.put("IGJM_CD",        null);
    	result.put("BDSBDSCD",       header.get("bdsBdsCd"));
    	result.put("BDSBDSNM",       header.get("bdsBdsNm"));
    	result.put("USE_KIND",       header.get("use_kind"));
    	result.put("DEAL_AREA",      dealArea);
    	result.put("DURABLE_YEAR",   null);
    	result.put("DEAL_DEBT",      dealDebt);
    	result.put("ACCOUNTKIND",    header.get("accountKindValue"));
    	result.put("DEAL_KIND",      header.get("deal_kind"));
    	result.put("TRM_RTN_SQNO",   header.get("trm_bno"));
    	result.put("USER_TRM_NO",    header.get("user_trm_no"));
    	result.put("STATUS_CD",      "00");
    	result.put("ADD_USER_ID",    info.getSession("ID"));
    	result.put("BEFORE_SIGN_NO", beforeSignNo);
    	result.put("INV_DATA",       header.get("inv_data"));
    	return result;
    }
    
    private List<Map<String, String>> insetSpy1InfoObjGrid(GridData gdReq, SepoaInfo info, String psNo) throws Exception{
    	List<Map<String, String>> result         = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> grid           = this.getGrid(gdReq, info);
    	Map<String, String>       gridInfo       = null;
    	Map<String, String>       resultInfo     = null;
    	String                    houseCode      = info.getSession("HOUSE_CODE");
    	String                    id             = info.getSession("ID");
    	String                    paySendSeq     = null;
    	String                    taxNo          = null;
    	String                    taxSeq         = null;
    	String                    delyToLocation = null;
    	String                    igjmCd         = null;
    	String                    itemNo         = null;
    	String                    qty            = null;
    	String                    unitPrice      = null;
    	String                    amt            = null;
    	String                    dosunqno       = null;
    	String                    modelNo        = null;
    	int                       i              = 0;
    	int                       gridSize       = grid.size();
    	
    	for(i = 0; i < gridSize; i++){
    		resultInfo = new HashMap<String, String>();
    		
    		paySendSeq     = Integer.toString(i + 1);
    		gridInfo       = grid.get(i);
    		taxNo          = gridInfo.get("TAX_NO");
    		taxSeq         = gridInfo.get("TAX_SEQ");
    		delyToLocation = gridInfo.get("DELY_TO_LOCATION");
    		igjmCd         = gridInfo.get("IGJM_CD");
    		itemNo         = gridInfo.get("ITEM_NO");
    		qty            = gridInfo.get("QTY");
    		unitPrice      = gridInfo.get("UNIT_PRICE");
    		amt            = gridInfo.get("AMT");
    		dosunqno       = gridInfo.get("DOSUNQNO");
    		modelNo        = gridInfo.get("MODEL_NO");
    		
    		resultInfo.put("HOUSE_CODE",   houseCode);
    		resultInfo.put("PAY_SEND_NO",  psNo);
    		resultInfo.put("PAY_SEND_SEQ", paySendSeq);
    		resultInfo.put("TAX_NO",       taxNo);
    		resultInfo.put("TAX_SEQ",      taxSeq);
    		resultInfo.put("JUMJUJMCD",    delyToLocation);
    		resultInfo.put("IGJMCD",       igjmCd);
    		resultInfo.put("PMKPMKCD",     itemNo);
    		resultInfo.put("CNT",          qty);
    		resultInfo.put("AMT",          unitPrice);
    		resultInfo.put("APPAPPAM",     amt);
    		resultInfo.put("DOSUNQNO",     dosunqno);
    		resultInfo.put("ADD_USER_ID",  id);
    		resultInfo.put("MODEL_NO",     modelNo);
    		
    		result.add(resultInfo);
    	}
    	
    	return result;
    }
    
    private Object[] insetSpy1InfoObj(GridData gdReq, SepoaInfo info, String[] response) throws Exception{
    	Object[]                  result     = new Object[1];
    	Map<String, Object>       resultInfo = new HashMap<String, Object>();
    	Map<String, String>       headerInfo = null;
    	String                    psNo       = this.getReqPsNo(info);
    	List<Map<String, String>> gridInfo   = null;
    	
    	headerInfo = this.insetSpy1InfoObjHeader(gdReq, info, psNo, response);
    	gridInfo   = this.insetSpy1InfoObjGrid(gdReq, info, psNo);
    	
    	resultInfo.put("headerInfo", headerInfo);
    	resultInfo.put("gridInfo",   gridInfo);
    	resultInfo.put("subject",    gdReq.getParam("SUBJECT"));
    	resultInfo.put("approval_str",    gdReq.getParam("APPROVAL_STR"));
    	result[0] = resultInfo;
    	
    	return result;    	    	
    }
    
    @SuppressWarnings({ "rawtypes"})
    private GridData insetSpy1Info(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	String[]        response        = null;
		
    	try {
    		
    		response = this.getEps0019WebService2(gdReq, info);
    		
//    		string[1] - 성공시 품의년도(BMSBMSYY,4자리) , 실패시 사용자 오류메세지</b><br>"
//    		string[2] - 성공시 품의번호(BMSSRLNO,5자리) , 실패시 시스템 오류메세지</b><br>"
//    		string[3] - 성공시 품의승인번호(APPAPPNO,3자리)</b><br>"
//    		string[4] - 성공시 품의승인금액</b><br>"
    		
    		if(!response[0].equals("200")){
    			gdRes.setMessage(response[1]+" - 에러코드:"+response[0]);
    		    gdRes.setStatus(Boolean.toString(false));
    		    gdRes.setSelectable(false);
        		gdRes.addParam("mode", "doSave");
    	    	
    	    	return gdRes;
    		}
     		
    		message  = this.getMessage(info);
    		obj      = this.insetSpy1InfoObj(gdReq, info, response);
    		value    = ServiceConnector.doService(info, "TX_005", "TRANSACTION", "insetSpy1Info", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = message.get("MESSAGE.0001").toString();
    		}
    		else {
    			gdResMessage = value.message;
    			
    			if(response[0].equals("200")){
    				this.getEps0019_1WebService2(info, response[1], response[2], response[3]);
        		}
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		isStatus     = false;
	    	if(response != null){
		    	if(response[0].equals("200")){
					this.getEps0019_1WebService2(info, response[1], response[2], response[3]);
	    		}
	    	}
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    
    
   
}