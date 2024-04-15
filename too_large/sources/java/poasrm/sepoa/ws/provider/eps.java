package poasrm.sepoa.ws.provider;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.icompia.util.CommonUtil;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.GetStackTrace;

public class Eps {
	//////////////////////////////////////////////////////////////////////////////////////////////// 공통 start!
	final private String SUCESS             = "200"; // 성공
	final private String FAIL               = "400"; // 실패
	final private String SERVICE_FAIL       = "401"; // 서비스 처리 실패
	final private String REQUIRE_VALUE_FAIL = "402"; // 필수값 입력 없음
	final private String LONG_VALUE_FAIL    = "403"; // 길이제한 위배
	final private String CODE_VALUE_FAIL    = "404"; // 규약 코드 위배
	
	/**
	 * String 값이 null일 경우 ""을 반환하는 메소드
	 * 
	 * @param target (검사할 문자열)
	 * @return String
	 */
	private String nvl(String target){
		String result = null;
		
		result = this.nvl(target, ""); // String 값이 null일 경우 기본값을 반환하는 메소드
		
		return result;
	}
	
	/**
	 * String 값이 null일 경우 기본값을 반환하는 메소드
	 * 
	 * @param target (검사할 문자열)
	 * @param defaultValue (null일 경우 기본값)
	 * @return String
	 */
	private String nvl(String target, String defaultValue){
		String result = null;
		
		if(target == null){
			result = defaultValue;
		}
		else{
			result = target;
		}
		
		return result;
	}
	
	/**
	 * 문자열 유효성을 검사하는 메소드
	 * 
	 * @param target (검사할 문자열)
	 * @param isRequired (필수값 여부, true : 필수, false : 필수아님)
	 * @param maxLength (최대길이값, -1 : 무한)
	 * @throws Exception
	 */
	private void stringValid(String target, boolean isRequired, int maxLength) throws Exception{
		byte[] targetByteArray       = null;
		int    targetByteArrayLength = 0;
		
		target = this.nvl(target); // String 값이 null일 경우 기본값을 반환하는 메소드
		
		if(isRequired && ("".equals(target))){
			throw new Exception(this.REQUIRE_VALUE_FAIL);
		}
		
		if(maxLength > -1){
			targetByteArray       = target.getBytes();
			targetByteArrayLength = targetByteArray.length;
			
			if(targetByteArrayLength >  maxLength){
				throw new Exception(this.LONG_VALUE_FAIL);
			}
		}
	}
	
	/**
	 * 세포아 세션 정보를 반환하는 메소드
	 * 
	 * @return SepoaInfo
	 * @throws Exception
	 */
	private SepoaInfo getSepoaInfo() throws Exception{
		SepoaInfo result = new SepoaInfo("000", "ID=ADMIN^@^LANGUAGE=KO^@^NAME_LOC=구매담당자^@^NAME_ENG=ADMIN^@^DEPT=011^@^COMPANY_CODE=WOORI^@^DEPARTMENT=011^@^PLANT_CODE=1000^@^");
		
		return result;
	}
	
	/**
	 * 인터페이스 에러 코드를 반환하는 메소드
	 * 
	 * @param e
	 * @return String
	 */
	private String getErrorMessage(Exception e){
		String result = null;
		
		try{
			GetStackTrace getStackTrace = new GetStackTrace();
			SepoaInfo     sepoaInfo     = this.getSepoaInfo(); // 세포아 세션 정보를 반환하는 메소드
			String        stackTrace    = getStackTrace.stackTrace(e);
			String        id            = sepoaInfo.getSession("ID");
			
			Logger.err.println(id, this, stackTrace);
			
			result = e.getMessage();
			result = this.nvl(result);
			
			if(result.startsWith("4") == false){
				result = this.FAIL;
			}
		}
		catch(Exception e1){
			result = this.FAIL;
		}
		
		return result;
	}
	
	/**
	 * Exception의 StackTrace 내용을 String 객체로 반환하는 메소드
	 * 
	 * @author bitcube
	 * @param e (Exception, StackTrace 내용을 반환할 Exception)
	 * @return String
	 */
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		if(s.length() > 4000){
			s = s.substring(0, 4000);
		}
		
		return s;
	}
	
	/**
	 * 예외 정보를 logger로 출력하는 메소드
	 * 
	 * @param e
	 */
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	/**
	 * 인터페이스 처리전 로그 마스터 정보 등록
	 * 
	 * @param info : 세션정보
	 * @param infCode : 인터페이스 코드
	 * @param infSend : 인터페이스 전송상태
	 * @return String : 인터페이스 로그 번호 
	 * @throws Exception
	 */
	private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend, String USRUSRID) throws Exception{
		Map<String, String> param = new HashMap<String, String>();
		Object[]            obj   = new Object[1];
		SepoaOut            value = null;
		String              infNo = null;
		boolean             flag  = false;
		
		param.put("HOUSE_CODE", "000");
		param.put("INF_TYPE",   "W");
		param.put("INF_CODE",   infCode);
		param.put("INF_SEND",   infSend);
		param.put("INF_ID",     USRUSRID);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception(this.FAIL);
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
	
	
	
	/**
	 * 인터페이스 처리후 로그 마스터 정보 수정
	 * 
	 * @param info : 세션정보
	 * @param infCode : 인터페이스 코드
	 * @param infSend : 인터페이스 전송상태
	 * @return String : 인터페이스 로그 번호 
	 * @throws Exception
	 */
	private void updateSinfhdInfo(SepoaInfo info, String infNo, String status, String reason, String infReceiveNo){
		Map<String, String> param = new HashMap<String, String>();
		Object[]            obj   = new Object[1];
		
		try{
			param.put("STATUS",         status);
			param.put("REASON",         reason);
			param.put("HOUSE_CODE",     "000");
			param.put("INF_NO",         infNo);
			param.put("INF_RECEIVE_NO", infReceiveNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfhdInfo", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * 문자열을 특정 바이트 길이가 넘지 않도록 수정하는 메소드
	 * 
	 * @param target
	 * @param maxLength
	 * @return String
	 */
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
	
	/**
	 * 배열의 길이를 반환하는 메소드
	 * 
	 * @param array
	 * @return int
	 * @throws Exception
	 */
	private int getArrayLength(String[] array) throws Exception{
		int result = 0;
		
		if(array != null){
			result = array.length;
		}
		
		return result;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////공통 end!
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps003 start!
	/**
	 * eps003 웹서비스 파라미터를 맵 형태로 반환하는 메소드
	 * 
	 * @param MODE
	 * @param ITEM_CODE
	 * @param ITEM_NAME
	 * @param IMG_URL
	 * @param SPECIFICATION
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> eps003Param(
			String MODE,   String ITEM_CODE, String ITEM_NAME, String IMG_URL, String SPECIFICATION,
			String INF_NO, String USEDFLAG
		) throws Exception{
		Map<String, String> result        = new HashMap<String, String>();
		String              mode          = this.nvl(MODE);
		String              itemCode      = this.nvl(ITEM_CODE);
		String              itemName      = this.nvl(ITEM_NAME);
		String              imgUrl        = this.nvl(IMG_URL);
		String              specification = this.nvl(SPECIFICATION);
		String              rInfNo        = this.nvl(INF_NO);
		String              usedFlag      = this.nvl(USEDFLAG);
		
		result.put("mode",          mode);
		result.put("itemCode",      itemCode);
		result.put("itemName",      itemName);
		result.put("imgUrl",        imgUrl);
		result.put("specification", specification);
		result.put("rInfNo",        rInfNo);
		result.put("usedFlag",      usedFlag);
		
		return result;
	}
	
	/**
	 * <pre>
	 * 품목정보 인터페이스 데이터에 대한 유효성을 검사하는 메소드
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @param param
	 * @throws Exception
	 */
	private void eps003Valid(Map<String, String> param) throws Exception{
		String  mode          = param.get("mode");
		String  itemCode      = param.get("itemCode");
		String  itemName      = param.get("itemName");
		String  imgUrl        = param.get("imgUrl");
		String  specification = param.get("specification");
		String  rInfNo        = param.get("rInfNo");
		String  usedFlag      = param.get("usedFlag");
		boolean isDeleteFlag  = false;
		
		if(
			("C".equals(mode) == false) &&
			("U".equals(mode) == false) &&
			("D".equals(mode) == false)
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
		
		if("C".equals(mode)){
			isDeleteFlag = true;
		}
		
		this.stringValid(mode,          true,         2);
		this.stringValid(itemCode,      true,         30);
		this.stringValid(itemName,      isDeleteFlag, 500);
		this.stringValid(imgUrl,        false,        500);
		this.stringValid(specification, false,        256);
		this.stringValid(rInfNo,        true,         15);
		this.stringValid(usedFlag,      false,        1);
		
		if(
			("".equals(usedFlag) == false) &&
			("Y".equals(usedFlag) == false) &&
			("N".equals(usedFlag) == false) 
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
	}
	
	/**
	 * <pre>
	 * eps003 등록 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps003InsertIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result        = new Object[1];
		Map<String, String> resultInfo    = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              companyCode   = info.getSession("COMPANY_CODE");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              imgUrl        = param.get("imgUrl");
		String              specification = param.get("specification");
		String              usedFlag      = param.get("usedFlag");
		
		resultInfo.put("HOUSE_CODE",           houseCode);
		resultInfo.put("ITEM_NO",              itemCode);
		resultInfo.put("USER_ID",              id);
		resultInfo.put("DESCRIPTION_LOC",      itemName);
		resultInfo.put("SPECIFICATION",        specification);
		resultInfo.put("COMPANY_CODE",         companyCode);
		resultInfo.put("IMAGE_FILE_PATH",      imgUrl);
		resultInfo.put("THUMNAIL_FILE_PATH",   "");
		resultInfo.put("EFFECTIVE_START_DATE", "");
		resultInfo.put("EFFECTIVE_END_DATE",   "");
		resultInfo.put("PUB_NO",               "");
		resultInfo.put("REMARK",               "EPS003");
		resultInfo.put("MAXREQAMNT",           "");
		resultInfo.put("MINREQAMNT",           "");
		resultInfo.put("MINAMNT",              "");
		resultInfo.put("MLOBHOCD",             "");
		resultInfo.put("USEDFLAG",             usedFlag);
		resultInfo.put("MODEL",                "");
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps003 수정 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps003UpdateIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result        = new Object[1];
		Map<String, String> resultInfo    = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              nameLoc       = info.getSession("NAME_LOC");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              imgUrl        = param.get("imgUrl");
		String              specification = param.get("specification");
		String              usedFlag      = param.get("usedFlag");
		
		resultInfo.put("DESCRIPTION_LOC",      itemName);
		resultInfo.put("SPECIFICATION",        specification);
		resultInfo.put("IMAGE_FILE_PATH",      imgUrl);
		resultInfo.put("THUMNAIL_FILE_PATH",   "");
		resultInfo.put("EFFECTIVE_START_DATE", "");
		resultInfo.put("EFFECTIVE_END_DATE",   "");
		resultInfo.put("PUB_NO",               "");
		resultInfo.put("MAXREQAMNT",           "");
		resultInfo.put("MINREQAMNT",           "");
		resultInfo.put("MINAMNT",              "");
		resultInfo.put("MLOBHOCD",             "");
		resultInfo.put("CHANGE_USER_ID",       id);
		resultInfo.put("CHANGE_USER_NAME_LOC", nameLoc);
		resultInfo.put("HOUSE_CODE",           houseCode);
		resultInfo.put("ITEM_NO",              itemCode);
		resultInfo.put("USEDFLAG",             usedFlag);
		resultInfo.put("MODEL",                "");
				
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps003 삭제 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps003DeleteIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              itemCode   = param.get("itemCode");
		
		resultInfo.put("HOUSE_CODE", houseCode);
		resultInfo.put("ITEM_NO",    itemCode);
				
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * eps003 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	private void insertSinfep003Info(SepoaInfo info, Map<String, String> param, String infNo) throws Exception{
		Map<String, String> svcParam      = new HashMap<String, String>();
		String              mode          = param.get("mode");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              imgUrl        = param.get("imgUrl");
		String              specification = param.get("specification");
		String              usedFlag      = param.get("usedFlag");
		Object[]            obj           = new Object[1];
		SepoaOut            value         = null;
		boolean             isStatus      = false;
		
		svcParam.put("HOUSE_CODE",    "000");
		svcParam.put("INF_NO",        infNo);
		svcParam.put("INF_MODE",      mode);
		svcParam.put("ITEM_CODE",     itemCode);
		svcParam.put("ITEM_NAME",     itemName);
		svcParam.put("IMG_URL",       imgUrl);
		svcParam.put("SPECIFICATION", specification);
		svcParam.put("USEDFLAG",      usedFlag);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep003Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}
	
	/**
	 * eps003 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep003Info(SepoaInfo info, String[] result){
		Map<String, String> param       = new HashMap<String, String>();
		Object[]            obj         = new Object[1];
		String              infNo       = result[1];
		String              returnValue = result[0];
		
		try{
			param.put("RETURN",     returnValue);
			param.put("HOUSE_CODE", "000");
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep003Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : EPS003
	 * 인터페이스 명 : 품목정보(물류)
	 * 인터페이스 설명 : 물류시스템에서 생성 / 변경된 품목을 event 발생시 i/f한다. 물류 > 전자구매
	 * 
	 * ~. return 구조
	 *   !. (200 : 성공, 400 : 실패, 401 : 서비스 처리 실패, 402 : 필수값 입력 없음, 403 : 길이제한 위배, 404 : MODE 규약 코드 위배)
	 *   !. 인터페이스 번호
	 * </pre>
	 * 
	 * @param MODE (작업구분, varchar, 2, C : 신규생성, U : 수정)
	 * @param ITEM_CODE (품목코드, varchar, 30)
	 * @param ITEM_NAME (품목명, varchar, 500)
	 * @param IMG_URL (이미지 url, varchar, 500)
	 * @param SPECIFICATION (규격, varchar, 256)
	 * @param USRUSRID (사용자 행번, varchar, 8)
	 * @param USEDFLAG (사용여부, varchar, 1)
	 * @param INF_NO (인터페이스 번호, varchar, 15)
	 * @return String[]
	 */
	public String[] M01_REQ_ITEM(
			String MODE,     String ITEM_CODE, String ITEM_NAME, String IMG_URL, String SPECIFICATION,
			String USRUSRID, String USEDFLAG,  String INF_NO
		){
		String[]            result   = new String[2];
		String              method   = null;
		String              infNo    = null;
		String              status   = null;
		String              reason   = null;
		Object[]            obj      = null;
		SepoaOut            value    = null;
		SepoaInfo           info     = null;
		Map<String, String> param    = null;
		boolean             isStatus = false;
		
		try{
			info      = this.getSepoaInfo();
			param     = this.eps003Param(MODE, ITEM_CODE, ITEM_NAME, IMG_URL, SPECIFICATION, INF_NO, USEDFLAG);
			infNo     = this.insertSinfhdInfo(info, "EPS003", "R", USRUSRID);
			result[1] = infNo;
			
			this.insertSinfep003Info(info, param, infNo);
			this.eps003Valid(param);
			
			if("C".equals(MODE)){
				obj      = this.eps003InsertIcomrehdInfoObj(info, param);
				method   = "insertIcomrehdInfo";
			}
			else if("U".equals(MODE)){
				obj      = this.eps003UpdateIcomrehdInfoObj(info, param);
				method   = "updateIcomrehdInfo";
			}
			else if("D".equals(MODE)){
				obj      = this.eps003DeleteIcomrehdInfoObj(info, param);
				method   = "deleteIcomrehdInfo";
			}
			
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", method, obj);
    		isStatus = value.flag;
    		
    		if(isStatus == false) {
    			throw new Exception(this.SERVICE_FAIL); 
    		}
    		
			result[0] = this.SUCESS;
			status = "Y";
			reason = " ";
		}
		catch(Exception e){
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			status    = "N";
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, INF_NO);
		this.updateSinfep003Info(info, result);
		
		return result;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////eps003 end!
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps004 start!
	/**
	 * eps004 웹서비스 파라미터를 맵 형태로 반환하는 메소드
	 * 
	 * @param MODE
	 * @param ITEM_CODE
	 * @param ITEM_NAME
	 * @param IMG_URL
	 * @param SPECIFICATION
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> eps004Param(
			String MODE,   String ITEM_CODE, String ITEM_NAME, String IMG_URL, String MODEL,
			String INF_NO, String USEDFLAG
		) throws Exception{
		Map<String, String> result        = new HashMap<String, String>();
		String              mode          = this.nvl(MODE);
		String              itemCode      = this.nvl(ITEM_CODE);
		String              itemName      = this.nvl(ITEM_NAME);
		String              imgUrl        = this.nvl(IMG_URL);
		String              model         = this.nvl(MODEL);
		String              rInfNo        = this.nvl(INF_NO);
		String              usedFlag      = this.nvl(USEDFLAG);
		
		result.put("mode",          mode);
		result.put("itemCode",      itemCode);
		result.put("itemName",      itemName);
		result.put("imgUrl",        imgUrl);
		result.put("model",         model);
		result.put("rInfNo",        rInfNo);
		result.put("usedFlag",      usedFlag);
		
		return result;
	}
	
	/**
	 * <pre>
	 * 품목정보 인터페이스 데이터에 대한 유효성을 검사하는 메소드
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @param param
	 * @throws Exception
	 */
	private void eps004Valid(Map<String, String> param) throws Exception{
		String  mode          = param.get("mode");
		String  itemCode      = param.get("itemCode");
		String  itemName      = param.get("itemName");
		String  imgUrl        = param.get("imgUrl");
		String  model         = param.get("model");
		String  rInfNo        = param.get("rInfNo");
		String  usedFlag      = param.get("usedFlag");
		boolean isDeleteFlag  = false;
		
		if(
			("C".equals(mode) == false) &&
			("U".equals(mode) == false) &&
			("D".equals(mode) == false)
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
		
		if("C".equals(mode)){
			isDeleteFlag = true;
		}
		
		this.stringValid(mode,          true,         2);
		this.stringValid(itemCode,      true,         30);
		this.stringValid(itemName,      isDeleteFlag, 500);
		this.stringValid(imgUrl,        false,        500);
		this.stringValid(model,         false,        200);
		this.stringValid(rInfNo,        true,         15);
		this.stringValid(usedFlag,      false,        1);
		
		if(
			("".equals(usedFlag) == false) &&
			("Y".equals(usedFlag) == false) &&
			("N".equals(usedFlag) == false) 
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
	}
	
	/**
	 * <pre>
	 * eps004 등록 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps004InsertIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result        = new Object[1];
		Map<String, String> resultInfo    = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              companyCode   = info.getSession("COMPANY_CODE");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              imgUrl        = param.get("imgUrl");
		String              model         = param.get("model");
		String              usedFlag      = param.get("usedFlag");
		
		resultInfo.put("HOUSE_CODE",           houseCode);
		resultInfo.put("ITEM_NO",              itemCode);
		resultInfo.put("USER_ID",              id);
		resultInfo.put("DESCRIPTION_LOC",      itemName);
		resultInfo.put("SPECIFICATION",        "");
		resultInfo.put("COMPANY_CODE",         companyCode);
		resultInfo.put("IMAGE_FILE_PATH",      imgUrl);
		resultInfo.put("THUMNAIL_FILE_PATH",   "");
		resultInfo.put("EFFECTIVE_START_DATE", "");
		resultInfo.put("EFFECTIVE_END_DATE",   "");
		resultInfo.put("PUB_NO",               "");
		resultInfo.put("REMARK",               "EPS004");
		resultInfo.put("MAXREQAMNT",           "");
		resultInfo.put("MINREQAMNT",           "");
		resultInfo.put("MINAMNT",              "");
		resultInfo.put("MLOBHOCD",             "");
		resultInfo.put("USEDFLAG",             usedFlag);
		resultInfo.put("MODEL",                model);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps004 수정 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps004UpdateIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              id         = info.getSession("ID");
		String              nameLoc    = info.getSession("NAME_LOC");
		String              itemCode   = param.get("itemCode");
		String              itemName   = param.get("itemName");
		String              imgUrl     = param.get("imgUrl");
		String              model      = param.get("model");
		String              usedFlag   = param.get("usedFlag");
		
		resultInfo.put("DESCRIPTION_LOC",      itemName);
		resultInfo.put("SPECIFICATION",        "");
		resultInfo.put("IMAGE_FILE_PATH",      imgUrl);
		resultInfo.put("THUMNAIL_FILE_PATH",   "");
		resultInfo.put("EFFECTIVE_START_DATE", "");
		resultInfo.put("EFFECTIVE_END_DATE",   "");
		resultInfo.put("PUB_NO",               "");
		resultInfo.put("MAXREQAMNT",           "");
		resultInfo.put("MINREQAMNT",           "");
		resultInfo.put("MINAMNT",              "");
		resultInfo.put("MLOBHOCD",             "");
		resultInfo.put("CHANGE_USER_ID",       id);
		resultInfo.put("CHANGE_USER_NAME_LOC", nameLoc);
		resultInfo.put("HOUSE_CODE",           houseCode);
		resultInfo.put("ITEM_NO",              itemCode);
		resultInfo.put("USEDFLAG",             usedFlag);
		resultInfo.put("MODEL",                model);
				
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps004 삭제 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps004DeleteIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              itemCode   = param.get("itemCode");
		
		resultInfo.put("HOUSE_CODE", houseCode);
		resultInfo.put("ITEM_NO",    itemCode);
				
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * eps004 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	private void insertSinfep004Info(SepoaInfo info, Map<String, String> param, String infNo) throws Exception{
		Map<String, String> svcParam      = new HashMap<String, String>();
		String              mode          = param.get("mode");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              imgUrl        = param.get("imgUrl");
		String              model         = param.get("model");
		String              usedFlag      = param.get("usedFlag");
		Object[]            obj           = new Object[1];
		SepoaOut            value         = null;
		boolean             isStatus      = false;
		
		svcParam.put("HOUSE_CODE",    "000");
		svcParam.put("INF_NO",        infNo);
		svcParam.put("INF_MODE",      mode);
		svcParam.put("ITEM_CODE",     itemCode);
		svcParam.put("ITEM_NAME",     itemName);
		svcParam.put("IMG_URL",       imgUrl);
		svcParam.put("MODEL",         model);
		svcParam.put("USEDFLAG",      usedFlag);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep004Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}
	
	/**
	 * eps004 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep004Info(SepoaInfo info, String[] result){
		Map<String, String> param       = new HashMap<String, String>();
		Object[]            obj         = new Object[1];
		String              infNo       = result[1];
		String              returnValue = result[0];
		
		try{
			param.put("RETURN",     returnValue);
			param.put("HOUSE_CODE", "000");
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep004Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : eps004
	 * 인터페이스 명 : 품목정보(재산)
	 * 인터페이스 설명 : 재산관리 시스템에서 생성 / 변경된 품목을 event 발생시 i/f한다. 재산관리 > 전자구매
	 * 
	 * ~. result 구조
	 *   !. (200 : 성공, 400 : 실패, 401 : 서비스 처리 실패, 402 : 필수값 입력 없음, 403 : 길이제한 위배, 404 : MODE 규약 코드 위배)
	 *   !. 인터페이스 번호
	 * </pre>
	 * 
	 * @return String[]
	 */
	public String[] M02_REQ_ITEM(
//			String MODE,   String ITEM_CODE, String ITEM_NAME, String IMG_URL, String MODEL,
			String MODE,   String ITEM_CODE, String ITEM_NAME, String IMG_URL, String SPECIFICATION,
			String INF_NO, String USRUSRID,  String USEDFLAG
		){
		String[]            result   = new String[2];
		String              method   = null;
		String              infNo    = null;
		String              status   = null;
		String              reason   = null;
		SepoaOut            value    = null;
		SepoaInfo           info     = null;
		Object[]            obj      = null;
		Map<String, String> param    = null;
		boolean             isStatus = false;
		
		try{
			info      = this.getSepoaInfo();
//			param     = this.eps004Param(MODE, ITEM_CODE, ITEM_NAME, IMG_URL, MODEL, INF_NO, USEDFLAG);
			param     = this.eps004Param(MODE, ITEM_CODE, ITEM_NAME, IMG_URL, SPECIFICATION, INF_NO, USEDFLAG);
			infNo     = this.insertSinfhdInfo(info, "EPS004", "R", USRUSRID);
			result[1] = infNo;
			
			this.insertSinfep004Info(info, param, infNo);
			this.eps004Valid(param);
			
			if("C".equals(MODE)){
				obj      = this.eps004InsertIcomrehdInfoObj(info, param);
				method   = "insertIcomrehdInfo";
			}
			else if("U".equals(MODE)){
				obj      = this.eps004UpdateIcomrehdInfoObj(info, param);
				method   = "updateIcomrehdInfo";
			}
			else if("D".equals(MODE)){
				obj      = this.eps004DeleteIcomrehdInfoObj(info, param);
				method   = "deleteIcomrehdInfo";
			}
			
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", method, obj);
    		isStatus = value.flag;
    		
    		if(isStatus == false) {
    			throw new Exception(this.SERVICE_FAIL); 
    		}
    		
			result[0] = this.SUCESS;
			status    = "Y";
			reason    = " ";
		}
		catch(Exception e){
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			status    = "N";
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, INF_NO);
		this.updateSinfep004Info(info, result);
		
		return result;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////eps004 end!
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps005 start!
	private class Eps005Vo{
		private String itemCode;
		private String itemName;
		private String imgUrl1;
		private String imgUrl2;
		private String effectiveStartDate;
		private String effectiveEndDate;
		private String pubNo;
		private String specification;
		private String maxReqAmnt;
		private String minReqAmnt;
		private String minAmnt;
		private String mlobhoCd;
		private String usedFlag;
		
		public String getItemCode() {
			return itemCode;
		}
		public void setItemCode(String itemCode) {
			this.itemCode = itemCode;
		}
		public String getItemName() {
			return itemName;
		}
		public void setItemName(String itemName) {
			this.itemName = itemName;
		}
		public String getImgUrl1() {
			return imgUrl1;
		}
		public void setImgUrl1(String imgUrl1) {
			this.imgUrl1 = imgUrl1;
		}
		public String getImgUrl2() {
			return imgUrl2;
		}
		public void setImgUrl2(String imgUrl2) {
			this.imgUrl2 = imgUrl2;
		}
		public String getEffectiveStartDate() {
			return effectiveStartDate;
		}
		public void setEffectiveStartDate(String effectiveStartDate) {
			this.effectiveStartDate = effectiveStartDate;
		}
		public String getEffectiveEndDate() {
			return effectiveEndDate;
		}
		public void setEffectiveEndDate(String effectiveEndDate) {
			this.effectiveEndDate = effectiveEndDate;
		}
		public String getPubNo() {
			return pubNo;
		}
		public void setPubNo(String pubNo) {
			this.pubNo = pubNo;
		}
		public String getMaxReqAmnt() {
			return maxReqAmnt;
		}
		public void setMaxReqAmnt(String maxReqAmnt) {
			this.maxReqAmnt = maxReqAmnt;
		}
		public String getMinReqAmnt() {
			return minReqAmnt;
		}
		public void setMinReqAmnt(String minReqAmnt) {
			this.minReqAmnt = minReqAmnt;
		}
		public String getMinAmnt() {
			return minAmnt;
		}
		public void setMinAmnt(String minAmnt) {
			this.minAmnt = minAmnt;
		}
		public String getMlobhoCd() {
			return mlobhoCd;
		}
		public void setMlobhoCd(String mlobhoCd) {
			this.mlobhoCd = mlobhoCd;
		}
		public String getUsedFlag() {
			return usedFlag;
		}
		public void setUsedFlag(String usedFlag) {
			this.usedFlag = usedFlag;
		}
		public String getSpecification() {
			return specification;
		}
		public void setSpecification(String specification) {
			this.specification = specification;
		}
	}
	
	private List<Eps005Vo> eps005ParamVoList(
			String[] ITEM_CODE,            String[] ITEM_NAME,          String[] IMG_URL1,  String[] IMG_URL2,      String[] USEDFLAG,
			String[] EFFECTIVE_START_DATE, String[] EFFECTIVE_END_DATE, String[] PUB_NO,    String[] SPECIFICATION, String[] MLOBHOCD, 
			String[] MAXREQAMNT,           String[] MINREQAMNT,         String[] MINAMNT
		) throws Exception{
		List<Eps005Vo> eps005VoList     = new ArrayList<Eps005Vo>();
		Eps005Vo       eps005VoListInfo = null;
		int            i                = 0;
		int            itemCodeLength   = this.getArrayLength(ITEM_CODE);
		
		for(i = 0; i < itemCodeLength; i++){
			eps005VoListInfo = new Eps005Vo();
			
			eps005VoListInfo.setItemCode(this.nvl(ITEM_CODE[i]));
			eps005VoListInfo.setItemName(this.nvl(ITEM_NAME[i]));
			eps005VoListInfo.setImgUrl1(this.nvl(IMG_URL1[i]));
			eps005VoListInfo.setImgUrl2(this.nvl(IMG_URL2[i]));
			eps005VoListInfo.setUsedFlag(this.nvl(USEDFLAG[i]));
			eps005VoListInfo.setEffectiveStartDate(this.nvl(EFFECTIVE_START_DATE[i]));
			eps005VoListInfo.setEffectiveEndDate(this.nvl(EFFECTIVE_END_DATE[i]));
			eps005VoListInfo.setPubNo(this.nvl(PUB_NO[i]));
			eps005VoListInfo.setSpecification(this.nvl(SPECIFICATION[i]));
			eps005VoListInfo.setMlobhoCd(this.nvl(MLOBHOCD[i]));
			eps005VoListInfo.setMaxReqAmnt(this.nvl(MAXREQAMNT[i]));
			eps005VoListInfo.setMinReqAmnt(this.nvl(MINREQAMNT[i]));
			eps005VoListInfo.setMinAmnt(this.nvl(MINAMNT[i]));
			
			eps005VoList.add(eps005VoListInfo);
		}
		
		return eps005VoList;
	}
	
	/**
	 * eps005 파라미터를 생성하는 메소드
	 * 
	 * @param MODE
	 * @param ITEM_CODE
	 * @param ITEM_NAME
	 * @param IMG_URL1
	 * @param IMG_URL2
	 * @param EFFECTIVE_START_DATE
	 * @param EFFECTIVE_END_DATE
	 * @param PUB_NO
	 * @param SPECIFICATION
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, Object> eps005Param(
			String MODE,                   String[] ITEM_CODE,          String[] ITEM_NAME, String[] IMG_URL1,      String[] IMG_URL2,
			String[] EFFECTIVE_START_DATE, String[] EFFECTIVE_END_DATE, String[] PUB_NO,    String[] SPECIFICATION, String INF_NO,
			String[] MAXREQAMNT,           String[] MINREQAMNT,         String[] MINAMNT,   String[] MLOBHOCD,      String[] USEDFLAG
		) throws Exception{
		Map<String, Object> result                   = new HashMap<String, Object>();
		String              mode                     = this.nvl(MODE);
		String              rInfNo                   = this.nvl(INF_NO);
		List<Eps005Vo>      eps005VoList             = null;
		int                 itemCodeLength           = this.getArrayLength(ITEM_CODE);            
		int                 itemNameLength           = this.getArrayLength(ITEM_NAME);            
		int                 imgUrl1Length            = this.getArrayLength(IMG_URL1);             
		int                 imgUrl2Length            = this.getArrayLength(IMG_URL2);             
		int                 effectiveStartDateLength = this.getArrayLength(EFFECTIVE_START_DATE); 
		int                 effectiveEndDateLength   = this.getArrayLength(EFFECTIVE_END_DATE);   
		int                 pubNoLength              = this.getArrayLength(PUB_NO);               
		int                 specificationLength      = this.getArrayLength(SPECIFICATION);        
		int                 maxReqAmntLength         = this.getArrayLength(MAXREQAMNT);           
		int                 minReqAmntLength         = this.getArrayLength(MINREQAMNT);           
		int                 minAmntLength            = this.getArrayLength(MINAMNT);              
		int                 mloBhoCdLength           = this.getArrayLength(MLOBHOCD);             
		int                 usedFlagLength           = this.getArrayLength(USEDFLAG);             
		
		if(
			(itemCodeLength == 0)                        || 
			(itemCodeLength != itemNameLength)           ||
			(itemCodeLength != imgUrl1Length)            ||
			(itemCodeLength != imgUrl2Length)            ||
			(itemCodeLength != effectiveStartDateLength) ||
			(itemCodeLength != effectiveEndDateLength)   ||
			(itemCodeLength != pubNoLength)              ||
			(itemCodeLength != specificationLength)      ||
			(itemCodeLength != maxReqAmntLength)         ||
			(itemCodeLength != minReqAmntLength)         ||
			(itemCodeLength != minAmntLength)            ||
			(itemCodeLength != mloBhoCdLength)           ||
			(itemCodeLength != usedFlagLength)
		){
			throw new Exception(this.LONG_VALUE_FAIL);
		}
		
		eps005VoList = this.eps005ParamVoList(
			ITEM_CODE,            ITEM_NAME,          IMG_URL1, IMG_URL2,      USEDFLAG,
			EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, PUB_NO,   SPECIFICATION, MLOBHOCD,
			MAXREQAMNT,           MINREQAMNT,         MINAMNT
		);
		
		result.put("mode",         mode);
		result.put("rInfNo",       rInfNo);
		result.put("eps005VoList", eps005VoList);
		
		return result;
	}
	
	/**
	 * 품목정보(e홍보물) 입력값에 대한 유효성을 검사하는 메소드
	 * 
	 * @param param 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void eps005Valid(Map<String, Object> param) throws Exception{
		String         mode             = (String)param.get("mode");
		String         rInfNo           = (String)param.get("rInfNo");
		String         usedFlag         = null;
		List<Eps005Vo> eps005VoList     = (List<Eps005Vo>)param.get("eps005VoList");
		Eps005Vo       eps005VoListInfo = null;
		boolean        isDeleteFlag     = false;
		int            eps005VoListSize = eps005VoList.size();
		int            i                = 0;
		
		this.stringValid(mode, true, 2);
		
		if(
			("C".equals(mode) == false) &&
			("U".equals(mode) == false) &&
			("D".equals(mode) == false)
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
		
		if("C".equals(mode)){
			isDeleteFlag = true;
		}
		
		this.stringValid(rInfNo, true, 15);
		
		for(i = 0; i < eps005VoListSize; i++){
			eps005VoListInfo = eps005VoList.get(i);
			usedFlag         = eps005VoListInfo.getUsedFlag();
			
			this.stringValid(eps005VoListInfo.getItemCode(),           true,         30);
			this.stringValid(eps005VoListInfo.getItemName(),           isDeleteFlag, 500);
			this.stringValid(eps005VoListInfo.getImgUrl1(),            false,        500);
			this.stringValid(eps005VoListInfo.getImgUrl2(),            false,        500);
			this.stringValid(eps005VoListInfo.getEffectiveStartDate(), false,        8);
			this.stringValid(eps005VoListInfo.getEffectiveEndDate(),   false,        8);
			this.stringValid(eps005VoListInfo.getPubNo(),              false,        50);
			this.stringValid(eps005VoListInfo.getSpecification(),      false,        256);
			this.stringValid(eps005VoListInfo.getMaxReqAmnt(),         false,        15);
			this.stringValid(eps005VoListInfo.getMinReqAmnt(),         false,        15);
			this.stringValid(eps005VoListInfo.getMinAmnt(),            false,        15);
			this.stringValid(eps005VoListInfo.getMlobhoCd(),           false,        8);
			this.stringValid(usedFlag,                                 false,        1);
			
			if(
				("".equals(usedFlag)  == false) &&
				("Y".equals(usedFlag) == false) &&
				("N".equals(usedFlag) == false) 
			){
				throw new Exception(this.CODE_VALUE_FAIL);
			}
		}
	}
	
	/**
	 * <pre>
	 * eps004 등록 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private Object[] eps005InsertIcomrehdInfoObj(SepoaInfo info, Map<String, Object> param) throws Exception{
		Object[]                  result             = new Object[1];
		Map<String, Object>       resultInfo         = new HashMap<String, Object>();
		Map<String, String>       listInfo           = null;
		String                    houseCode          = info.getSession("HOUSE_CODE");
		String                    id                 = info.getSession("ID");
		String                    companyCode        = info.getSession("COMPANY_CODE");
		List<Eps005Vo>            eps005VoList       = (List<Eps005Vo>)param.get("eps005VoList");
		List<Map<String, String>> list               = new ArrayList<Map<String, String>>();
		Eps005Vo                  eps005VoListInfo   = null;
		int                       eps005VoListSize   = eps005VoList.size();
		int                       i                  = 0;
		
		for(i = 0; i < eps005VoListSize; i++){
			listInfo = new HashMap<String, String>();
			
			eps005VoListInfo = eps005VoList.get(i);
			
			listInfo.put("HOUSE_CODE",           houseCode);
			listInfo.put("ITEM_NO",              eps005VoListInfo.getItemCode());
			listInfo.put("USER_ID",              id);
			listInfo.put("DESCRIPTION_LOC",      eps005VoListInfo.getItemName());
			listInfo.put("SPECIFICATION",        eps005VoListInfo.getSpecification());
			listInfo.put("COMPANY_CODE",         companyCode);
			listInfo.put("IMAGE_FILE_PATH",      eps005VoListInfo.getImgUrl2());
			listInfo.put("THUMNAIL_FILE_PATH",   eps005VoListInfo.getImgUrl1());
			listInfo.put("EFFECTIVE_START_DATE", eps005VoListInfo.getEffectiveStartDate());
			listInfo.put("EFFECTIVE_END_DATE",   eps005VoListInfo.getEffectiveEndDate());
			listInfo.put("PUB_NO",               eps005VoListInfo.getPubNo());
			listInfo.put("REMARK",               "EPS005");
			listInfo.put("MAXREQAMNT",           eps005VoListInfo.getMaxReqAmnt());
			listInfo.put("MINREQAMNT",           eps005VoListInfo.getMinReqAmnt());
			listInfo.put("MINAMNT",              eps005VoListInfo.getMinAmnt());
			listInfo.put("MLOBHOCD",             eps005VoListInfo.getMlobhoCd());
			listInfo.put("USEDFLAG",             eps005VoListInfo.getUsedFlag());
			listInfo.put("MODEL",                "");
			
			list.add(listInfo);
		}
		
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps005 수정 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private Object[] eps005UpdateIcomrehdInfoObj(SepoaInfo info, Map<String, Object> param) throws Exception{
		Object[]                  result           = new Object[1];
		Map<String, Object>       resultInfo       = new HashMap<String, Object>();
		Map<String, String>       listInfo         = null;
		String                    houseCode        = info.getSession("HOUSE_CODE");
		String                    id               = info.getSession("ID");
		String                    nameLoc          = info.getSession("NAME_LOC");
		List<Map<String, String>> list             = new ArrayList<Map<String, String>>();
		List<Eps005Vo>            eps005VoList     = (List<Eps005Vo>)param.get("eps005VoList");
		Eps005Vo                  eps005VoListInfo = null;
		int                       eps005VoListSize = eps005VoList.size();
		int                       i                = 0;
		
		for(i = 0; i < eps005VoListSize; i++){
			listInfo = new HashMap<String, String>();
			
			eps005VoListInfo = eps005VoList.get(i);
			
			listInfo.put("DESCRIPTION_LOC",      eps005VoListInfo.getItemName());
			listInfo.put("SPECIFICATION",        eps005VoListInfo.getSpecification());
			listInfo.put("IMAGE_FILE_PATH",      eps005VoListInfo.getImgUrl2());
			listInfo.put("THUMNAIL_FILE_PATH",   eps005VoListInfo.getImgUrl1());
			listInfo.put("EFFECTIVE_START_DATE", eps005VoListInfo.getEffectiveStartDate());
			listInfo.put("EFFECTIVE_END_DATE",   eps005VoListInfo.getEffectiveEndDate());
			listInfo.put("PUB_NO",               eps005VoListInfo.getPubNo());
			listInfo.put("MAXREQAMNT",           eps005VoListInfo.getMaxReqAmnt());
			listInfo.put("MINREQAMNT",           eps005VoListInfo.getMinReqAmnt());
			listInfo.put("MINAMNT",              eps005VoListInfo.getMinAmnt());
			listInfo.put("MLOBHOCD",             eps005VoListInfo.getMlobhoCd());
			listInfo.put("CHANGE_USER_ID",       id);
			listInfo.put("CHANGE_USER_NAME_LOC", nameLoc);
			listInfo.put("HOUSE_CODE",           houseCode);
			listInfo.put("ITEM_NO",              eps005VoListInfo.getItemCode());
			listInfo.put("USEDFLAG",             eps005VoListInfo.getUsedFlag());
			listInfo.put("MODEL",                "");
			
			list.add(listInfo);
		}
		
		resultInfo.put("list", list);
				
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps005 삭제 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	imgUrl
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private Object[] eps005DeleteIcomrehdInfoObj(SepoaInfo info, Map<String, Object> param) throws Exception{
		Object[]                  result           = new Object[1];
		Map<String, Object>       resultInfo       = new HashMap<String, Object>();
		Map<String, String>       listInfo         = null;
		String                    houseCode        = info.getSession("HOUSE_CODE");
		List<Map<String, String>> list             = new ArrayList<Map<String, String>>();
		List<Eps005Vo>            eps005VoList     = (List<Eps005Vo>)param.get("eps005VoList");
		Eps005Vo                  eps005VoListInfo = null;
		int                       eps005VoListSize = eps005VoList.size();
		int                       i                = 0;
		
		for(i = 0; i < eps005VoListSize; i++){
			listInfo = new HashMap<String, String>();
			
			eps005VoListInfo = eps005VoList.get(i);
			
			listInfo.put("HOUSE_CODE", houseCode);
			listInfo.put("ITEM_NO",    eps005VoListInfo.getItemCode());	
			
			list.add(listInfo);
		}
		
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * eps005 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void insertSinfep005Info(SepoaInfo info, Map<String, Object> param, String infNo) throws Exception{
		Map<String, String>       svcParam         = new HashMap<String, String>();
		Map<String, String>       eps005PrInfo     = null;
		Map<String, Object>       objInfo          = new HashMap<String, Object>();
		String                    mode             = (String)param.get("mode");
		Object[]                  obj              = new Object[1];
		SepoaOut                  value            = null;
		List<Map<String, String>> eps005Pr         = new ArrayList<Map<String, String>>();
		List<Eps005Vo>            eps005VoList     = (List<Eps005Vo>)param.get("eps005VoList");
		Eps005Vo                  eps005VoListInfo = null;
		boolean                   isStatus         = false;
		int                       eps005VoListSize = eps005VoList.size();
		int                       i                = 0;
		
		svcParam.put("HOUSE_CODE", "000");
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		
		for(i = 0; i < eps005VoListSize; i++){
			eps005PrInfo = new HashMap<String, String>();
			
			eps005VoListInfo = eps005VoList.get(i);
			
			eps005PrInfo.put("HOUSE_CODE",           "000");
			eps005PrInfo.put("INF_NO",               infNo);
			eps005PrInfo.put("SEQ",                  Integer.toString(i));
			eps005PrInfo.put("ITEM_CODE",            eps005VoListInfo.getItemCode());
			eps005PrInfo.put("ITEM_NAME",            eps005VoListInfo.getItemName());
			eps005PrInfo.put("IMG_URL1",             eps005VoListInfo.getImgUrl1());
			eps005PrInfo.put("IMG_URL2",             eps005VoListInfo.getImgUrl2());
			eps005PrInfo.put("EFFECTIVE_START_DATE", eps005VoListInfo.getEffectiveStartDate());
			eps005PrInfo.put("EFFECTIVE_END_DATE",   eps005VoListInfo.getEffectiveEndDate());
			eps005PrInfo.put("PUB_NO",               eps005VoListInfo.getPubNo());
			eps005PrInfo.put("SPECIFICATION",        eps005VoListInfo.getSpecification());
			eps005PrInfo.put("MAXREQAMNT",           eps005VoListInfo.getMaxReqAmnt());
			eps005PrInfo.put("MINREQAMNT",           eps005VoListInfo.getMinReqAmnt());
			eps005PrInfo.put("MINAMNT",              eps005VoListInfo.getMinAmnt());
			eps005PrInfo.put("MLOBHOCD",             eps005VoListInfo.getMlobhoCd());
			eps005PrInfo.put("USEDFLAG",             eps005VoListInfo.getUsedFlag());
			
			eps005Pr.add(eps005PrInfo);
		}
		
		objInfo.put("eps005",   svcParam);
		objInfo.put("eps005Pr", eps005Pr);
		
		obj[0]   = objInfo;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep005Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}
	
	/**
	 * eps005 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep005Info(SepoaInfo info, String[] result){
		Map<String, String> param       = new HashMap<String, String>();
		Object[]            obj         = new Object[1];
		String              infNo       = result[1];
		String              returnValue = result[0];
		
		try{
			param.put("RETURN",     returnValue);
			param.put("HOUSE_CODE", "000");
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep005Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	
	
	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : EPS005
	 * 인터페이스 명 : 품목정보(e홍보물)
	 * 인터페이스 설명 : e홍보물시스템에서 생성 / 변경된 품목을 event 발생시 i/f한다. E홍보물 > 전자구매
	 * 
	 * ~. return 구조
	 *   !. (200 : 성공, 400 : 실패, 401 : 서비스 처리 실패, 402 : 필수값 입력 없음, 403 : 길이제한 위배, 404 : MODE 규약 코드 위배)
	 *   !. 인터페이스 번호
	 * </pre>
	 *
	 * @return String[]
	 */
	public String[] M03_REQ_ITEM(
			String   MODE,                 String[] ITEM_CODE,          String[] ITEM_NAME, String[] IMG_URL1,      String[] IMG_URL2,
			String[] EFFECTIVE_START_DATE, String[] EFFECTIVE_END_DATE, String[] PUB_NO,    String[] SPECIFICATION, String[] MAXREQAMNT,
			String[] MINREQAMNT,           String[] MINAMNT,            String[] MLOBHOCD,  String   USRUSRID,      String[] USEDFLAG,
			String   INF_NO
		){
		String[]            result   = new String[2];
		String              method   = null;
		String              infNo    = null;
		String              status   = null;
		String              reason   = null;
		SepoaInfo           info     = null;
		SepoaOut            value    = null;
		Map<String, Object> param    = null;
		Object[]            obj      = null;
		boolean             isStatus = false;
		
		try{
			info      = this.getSepoaInfo();
			param     = this.eps005Param(
				MODE,                 ITEM_CODE,          ITEM_NAME, IMG_URL1,      IMG_URL2,
				EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, PUB_NO,    SPECIFICATION, INF_NO,
				MAXREQAMNT,           MINREQAMNT,         MINAMNT,   MLOBHOCD,      USEDFLAG
			);

			infNo     = this.insertSinfhdInfo(info, "EPS005", "R", USRUSRID);
			result[1] = infNo;
			
			this.insertSinfep005Info(info, param, infNo);
			this.eps005Valid(param);
			
			if("C".equals(MODE)){
				obj      = this.eps005InsertIcomrehdInfoObj(info, param);
				method   = "insertIcomrehdList";
			}
			else if("U".equals(MODE)){
				obj      = this.eps005UpdateIcomrehdInfoObj(info, param);
				method   = "updateIcomrehdList";
			}
			else if("D".equals(MODE)){
				obj      = this.eps005DeleteIcomrehdInfoObj(info, param);
				method   = "deleteIcomrehdList";
			}
			
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", method, obj);
    		isStatus = value.flag;
    		
    		if(isStatus == false) {
    			throw new Exception(this.SERVICE_FAIL); 
    		}
    		
			result[0] = this.SUCESS;
			status    = "Y";
			reason    = " ";
		}
		catch(Exception e){
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			status    = "N";
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, INF_NO);
		this.updateSinfep005Info(info, result);
		
		return result;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////eps005 end!
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps006 start!
	/**
	 * eps006 웹서비스 파라미터를 맵 형태로 반환하는 메소드
	 * 
	 * @param MODE
	 * @param ITEM_CODE
	 * @param ITEM_NAME
	 * @param SPECIFICATION
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> eps006Param(String MODE, String ITEM_CODE, String ITEM_NAME, String SPECIFICATION, String INF_NO) throws Exception{
		Map<String, String> result        = new HashMap<String, String>();
		String              mode          = this.nvl(MODE);
		String              itemCode      = this.nvl(ITEM_CODE);
		String              itemName      = this.nvl(ITEM_NAME);
		String              specification = this.nvl(SPECIFICATION);
		String              rInfNo        = this.nvl(INF_NO);
		
		result.put("mode",          mode);
		result.put("itemCode",      itemCode);
		result.put("itemName",      itemName);
		result.put("specification", specification);
		result.put("rInfNo",        rInfNo);
		
		return result;
	}
	
	/**
	 * <pre>
	 * 품목정보 인터페이스 데이터에 대한 유효성을 검사하는 메소드
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	specification
	 * </pre>
	 * 
	 * @param param
	 * @throws Exception
	 */
	private void eps006Valid(Map<String, String> param) throws Exception{
		String  mode          = param.get("mode");
		String  itemCode      = param.get("itemCode");
		String  itemName      = param.get("itemName");
		String  specification = param.get("specification");
		String  rInfNo        = param.get("rInfNo");
		boolean isDeleteFlag  = false;
		
		if(
			("C".equals(mode) == false) &&
			("U".equals(mode) == false) &&
			("D".equals(mode) == false)
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
		
		if("C".equals(mode)){
			isDeleteFlag = true;
		}
		
		this.stringValid(mode,          true,         2);
		this.stringValid(itemCode,      true,         30);
		this.stringValid(itemName,      isDeleteFlag, 500);
		this.stringValid(specification, false,        256);
		this.stringValid(rInfNo,        true,         15);
	}
	
	/**
	 * <pre>
	 * eps006 등록 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps006InsertIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result        = new Object[1];
		Map<String, String> resultInfo    = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              companyCode   = info.getSession("COMPANY_CODE");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              specification = param.get("specification");
		
		resultInfo.put("HOUSE_CODE",           houseCode);
		resultInfo.put("ITEM_NO",              itemCode);
		resultInfo.put("USER_ID",              id);
		resultInfo.put("DESCRIPTION_LOC",      itemName);
		resultInfo.put("SPECIFICATION",        specification);
		resultInfo.put("COMPANY_CODE",         companyCode);
		resultInfo.put("IMAGE_FILE_PATH",      "");
		resultInfo.put("THUMNAIL_FILE_PATH",   "");
		resultInfo.put("EFFECTIVE_START_DATE", "");
		resultInfo.put("EFFECTIVE_END_DATE",   "");
		resultInfo.put("PUB_NO",               "");
		resultInfo.put("REMARK",               "EPS006");
		resultInfo.put("MAXREQAMNT",           "");
		resultInfo.put("MINREQAMNT",           "");
		resultInfo.put("MINAMNT",              "");
		resultInfo.put("MLOBHOCD",             "");
		resultInfo.put("USEDFLAG",             "");
		resultInfo.put("MODEL",                "");
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps006 수정 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps006UpdateIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result        = new Object[1];
		Map<String, String> resultInfo    = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              id            = info.getSession("ID");
		String              nameLoc       = info.getSession("NAME_LOC");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              specification = param.get("specification");
		
		resultInfo.put("DESCRIPTION_LOC",      itemName);
		resultInfo.put("SPECIFICATION",        specification);
		resultInfo.put("IMAGE_FILE_PATH",      "");
		resultInfo.put("THUMNAIL_FILE_PATH",   "");
		resultInfo.put("EFFECTIVE_START_DATE", "");
		resultInfo.put("EFFECTIVE_END_DATE",   "");
		resultInfo.put("PUB_NO",               "");
		resultInfo.put("MAXREQAMNT",           "");
		resultInfo.put("MINREQAMNT",           "");
		resultInfo.put("MINAMNT",              "");
		resultInfo.put("MLOBHOCD",             "");
		resultInfo.put("CHANGE_USER_ID",       id);
		resultInfo.put("CHANGE_USER_NAME_LOC", nameLoc);
		resultInfo.put("HOUSE_CODE",           houseCode);
		resultInfo.put("ITEM_NO",              itemCode);
		resultInfo.put("USEDFLAG",             "");
		resultInfo.put("MODEL",                "");
				
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps006 삭제 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	specification
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] eps006DeleteIcomrehdInfoObj(SepoaInfo info, Map<String, String> param) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              itemCode   = param.get("itemCode");
		
		resultInfo.put("HOUSE_CODE", houseCode);
		resultInfo.put("ITEM_NO",    itemCode);
				
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * eps006 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	private void insertSinfep006Info(SepoaInfo info, Map<String, String> param, String infNo) throws Exception{
		Map<String, String> svcParam      = new HashMap<String, String>();
		String              mode          = param.get("mode");
		String              itemCode      = param.get("itemCode");
		String              itemName      = param.get("itemName");
		String              imgUrl        = param.get("imgUrl");
		String              specification = param.get("specification");
		Object[]            obj           = new Object[1];
		SepoaOut            value         = null;
		boolean             isStatus      = false;
		
		svcParam.put("HOUSE_CODE",    "000");
		svcParam.put("INF_NO",        infNo);
		svcParam.put("INF_MODE",      mode);
		svcParam.put("ITEM_CODE",     itemCode);
		svcParam.put("ITEM_NAME",     itemName);
		svcParam.put("IMG_URL",       imgUrl);
		svcParam.put("SPECIFICATION", specification);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep006Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}
	
	/**
	 * eps006 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep006Info(SepoaInfo info, String[] result){
		Map<String, String> param       = new HashMap<String, String>();
		Object[]            obj         = new Object[1];
		String              infNo       = result[1];
		String              returnValue = result[0];
		
		try{
			param.put("RETURN",     returnValue);
			param.put("HOUSE_CODE", "000");
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep006Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : eps006
	 * 인터페이스 명 : 품목정보(I/T)
	 * 인터페이스 설명 : I/T 시스템에서 생성 / 변경된 품목을 event 발생시 i/f한다. SRMS > 전자구매
	 * 
	 * ~. return 구조
	 *   !. (200 : 성공, 400 : 실패, 401 : 서비스 처리 실패, 402 : 필수값 입력 없음, 403 : 길이제한 위배, 404 : MODE 규약 코드 위배)
	 *   !. 인터페이스 번호
	 * </pre>
	 * 
	 * @param MODE (작업구분, varchar, 2, C : 신규생성, U : 수정)
	 * @param ITEM_CODE (품목코드, varchar, 30)
	 * @param ITEM_NAME (품목명, varchar, 500)
	 * @param SPECIFICATION (규격, varchar, 256)
	 * @return String[] 
	 */
	public String[] M04_REQ_ITEM(String MODE, String ITEM_CODE, String ITEM_NAME, String SPECIFICATION, String INF_NO, String USRUSRID){
		String[]            result   = new String[2];
		String              method   = null;
		String              infNo    = null;
		String              status   = null;
		String              reason   = null;
		SepoaOut            value    = null;
		Object[]            obj      = null;
		SepoaInfo           info     = null;
		Map<String, String> param    = null;
		boolean             isStatus = false;
		
		try{
			info      = this.getSepoaInfo();
			param     = this.eps006Param(MODE, ITEM_CODE, ITEM_NAME, SPECIFICATION, INF_NO);
			infNo     = this.insertSinfhdInfo(info, "EPS006", "R", USRUSRID);
			result[1] = infNo;
			
			this.insertSinfep006Info(info, param, infNo);
			this.eps006Valid(param);
			
			if("C".equals(MODE)){
				obj      = this.eps006InsertIcomrehdInfoObj(info, param);
				method   = "insertIcomrehdInfo";
			}
			else if("U".equals(MODE)){
				obj      = this.eps006UpdateIcomrehdInfoObj(info, param);
				method   = "updateIcomrehdInfo";
			}
			else if("D".equals(MODE)){
				obj      = this.eps006DeleteIcomrehdInfoObj(info, param);
				method   = "deleteIcomrehdInfo";
			}
			
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", method, obj);
    		isStatus = value.flag;
    		
    		if(isStatus == false) {
    			throw new Exception(this.SERVICE_FAIL); 
    		}
    		
			result[0] = this.SUCESS;
			status    = "Y";
			reason    = " ";
		}
		catch(Exception e){
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			status    = "N";
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, INF_NO);
		this.updateSinfep006Info(info, result);
		
		return result;
	}

	/**
	 * 구매요청 상세
	 * 
	 * SRMS_SEQ : 순번
	 * ITEM_NO : 품목
	 * UNIT_MEASURE : 단위코드
	 * PR_QTY : 수량
	 * UNIT_PRICE : 단가
	 * PR_AMT : 금액
	 */
	public class M04_REQ_PR_DETAIL{
		private String SRMS_SEQ;
		private String ITEM_NO;
		private String PR_QTY;
		private String UNIT_PRICE;
		private String PR_AMT;

		public String getSRMS_SEQ() {
			return SRMS_SEQ;
		}
		
		public void setSRMS_SEQ(String sRMS_SEQ) {
			SRMS_SEQ = sRMS_SEQ;
		}
		
		public String getITEM_NO() {
			return ITEM_NO;
		}
		
		public void setITEM_NO(String iTEM_NO) {
			ITEM_NO = iTEM_NO;
		}
		
		public String getPR_QTY() {
			return PR_QTY;
		}
		
		public void setPR_QTY(String pR_QTY) {
			PR_QTY = pR_QTY;
		}
		
		public String getUNIT_PRICE() {
			return UNIT_PRICE;
		}
		
		public void setUNIT_PRICE(String uNIT_PRICE) {
			UNIT_PRICE = uNIT_PRICE;
		}
		
		public String getPR_AMT() {
			return PR_AMT;
		}
		
		public void setPR_AMT(String pR_AMT) {
			PR_AMT = pR_AMT;
		}
		
		public String toString(){
			String       result       = null;
			StringBuffer stringBuffer = new StringBuffer();

			stringBuffer.append("SRMS_SEQ : >").append(this.getSRMS_SEQ()).append("<\n");
			stringBuffer.append("ITEM_NO : >").append(this.getITEM_NO()).append("<\n");
			stringBuffer.append("PR_QTY : >").append(this.getPR_QTY()).append("<\n");
			stringBuffer.append("UNIT_PRICE : >").append(this.getUNIT_PRICE()).append("<\n");
			stringBuffer.append("PR_AMT : >").append(this.getPR_AMT()).append("<\n");

			result = stringBuffer.toString();

			return result;
		}
	}
	////////////////////////////////////////////////////////////////////////////////////////////////eps006 end!
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps0031 start!
	private class Eps0031Vo{
		private String itemCode;
		private String abolRsn;
		private String abolRsnEtc;
		private String abolDate;
		
		public String getItemCode() {
			return itemCode;
		}
		public void setItemCode(String itemCode) {
			this.itemCode = itemCode;
		}
		public String getAbolRsn() {
			return abolRsn;
		}
		public void setAbolRsn(String abolRsn) {
			this.abolRsn = abolRsn;
		}
		public String getAbolRsnEtc() {
			return abolRsnEtc;
		}
		public void setAbolRsnEtc(String abolRsnEtc) {
			this.abolRsnEtc = abolRsnEtc;
		}
		public String getAbolDate() {
			return abolDate;
		}
		public void setAbolDate(String abolDate) {
			this.abolDate = abolDate;
		}
	}
	
	private List<Eps0031Vo> eps0031ParamVoList(
			String[] ITEM_CODE,   String[] ABOL_RSN,  String[] ABOL_RSN_ETC,   String[] ABOL_DATE
		) throws Exception{
		List<Eps0031Vo> eps0031VoList     = new ArrayList<Eps0031Vo>();
		Eps0031Vo       eps0031VoListInfo = null;
		int            i                = 0;
		int            itemCodeLength   = this.getArrayLength(ITEM_CODE);
		
		for(i = 0; i < itemCodeLength; i++){			
			eps0031VoListInfo = new Eps0031Vo();
			
			eps0031VoListInfo.setItemCode(this.nvl(ITEM_CODE[i]));
			eps0031VoListInfo.setAbolRsn(this.nvl(ABOL_RSN[i]));
			eps0031VoListInfo.setAbolRsnEtc(this.nvl(ABOL_RSN_ETC[i]));
			eps0031VoListInfo.setAbolDate(this.nvl(ABOL_DATE[i]));
			
			eps0031VoList.add(eps0031VoListInfo);
		}
		
		return eps0031VoList;
	}
	
	/**
	 * eps0031 파라미터를 생성하는 메소드
	 * 
	 * @param MODE
	 * @param ITEM_CODE
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, Object> eps0031Param(
			String   MODE,          String[] ITEM_CODE,   String[] ABOL_RSN,  String[] ABOL_RSN_ETC,   String[] ABOL_DATE,					
			String   ABOL_REQ_USER_ID,      String   INF_NO
		) throws Exception{
		Map<String, Object> result                   = new HashMap<String, Object>();
		String              mode                     = this.nvl(MODE);
		String              rInfNo                   = this.nvl(INF_NO);
		String              abolReqUserId            = this.nvl(ABOL_REQ_USER_ID);
		List<Eps0031Vo>      eps0031VoList             = null;
		int                 itemCodeLength           = this.getArrayLength(ITEM_CODE);            
		int                 abolRsnLength            = this.getArrayLength(ABOL_RSN);            
		int                 abolRsnEtcLength         = this.getArrayLength(ABOL_RSN_ETC);             
		int                 abolDateLength           = this.getArrayLength(ABOL_DATE);             
		
		if(
			(itemCodeLength == 0)                        || 
			(itemCodeLength != abolRsnLength)           ||
			(itemCodeLength != abolRsnEtcLength)            ||
			(itemCodeLength != abolDateLength)
		){
			throw new Exception(this.LONG_VALUE_FAIL);
		}
		
		eps0031VoList = this.eps0031ParamVoList(
			ITEM_CODE,   ABOL_RSN,  ABOL_RSN_ETC,   ABOL_DATE
		);
		
		result.put("mode",         mode);
		result.put("rInfNo",       rInfNo);
		result.put("abolReqUserId",       abolReqUserId);
		result.put("eps0031VoList", eps0031VoList);
		
		return result;
	}
	
	/**
	 * eps0031 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void insertSinfep0031Info(SepoaInfo info, Map<String, Object> param, String infNo) throws Exception{
		Map<String, String>       svcParam         = new HashMap<String, String>();
		Map<String, String>       eps0031PrInfo     = null;
		Map<String, Object>       objInfo          = new HashMap<String, Object>();
		String                    mode             = (String)param.get("mode");
		String                    abolReqUserId    = (String)param.get("abolReqUserId");
		Object[]                  obj              = new Object[1];
		SepoaOut                  value            = null;
		List<Map<String, String>> eps0031Pr         = new ArrayList<Map<String, String>>();
		List<Eps0031Vo>            eps0031VoList     = (List<Eps0031Vo>)param.get("eps0031VoList");
		Eps0031Vo                  eps0031VoListInfo = null;
		boolean                  isStatus         = false;
		int                       eps0031VoListSize = eps0031VoList.size();
		int                       i                = 0;
		
		svcParam.put("HOUSE_CODE", "000");
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		svcParam.put("ABOL_REQ_USER_ID",   abolReqUserId);
		
		
		
		for(i = 0; i < eps0031VoListSize; i++){
			eps0031PrInfo = new HashMap<String, String>();
			
			eps0031VoListInfo = eps0031VoList.get(i);
			
			eps0031PrInfo.put("HOUSE_CODE",           "000");
			eps0031PrInfo.put("INF_NO",               infNo);
			eps0031PrInfo.put("SEQ",                  Integer.toString(i));
			eps0031PrInfo.put("ITEM_CODE",            eps0031VoListInfo.getItemCode());
			eps0031PrInfo.put("ABOL_RSN",             eps0031VoListInfo.getAbolRsn());
			eps0031PrInfo.put("ABOL_RSN_ETC",         eps0031VoListInfo.getAbolRsnEtc());
			eps0031PrInfo.put("ABOL_DATE",            eps0031VoListInfo.getAbolDate());
			
			eps0031Pr.add(eps0031PrInfo);
		}
		
		objInfo.put("eps0031",   svcParam);
		objInfo.put("eps0031Pr", eps0031Pr);
		
		obj[0]   = objInfo;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0031Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}
	
	/**
	 * 홍보물(e홍보물,안내장) 폐기정보 입력값에 대한 유효성을 검사하는 메소드
	 * 
	 * @param param 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void eps0031Valid(Map<String, Object> param) throws Exception{
		String         mode             = (String)param.get("mode");
		String         rInfNo           = (String)param.get("rInfNo");
		List<Eps0031Vo> eps0031VoList     = (List<Eps0031Vo>)param.get("eps0031VoList");
		Eps0031Vo       eps0031VoListInfo = null;
		boolean        isDeleteFlag     = false;
		int            eps0031VoListSize = eps0031VoList.size();
		int            i                = 0;
		
		this.stringValid(mode, true, 2);
		
		if(
			("C".equals(mode) == false) &&
			("U".equals(mode) == false) &&
			("D".equals(mode) == false)
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
		
		if("C".equals(mode)){
			isDeleteFlag = true;
		}
		
		this.stringValid(rInfNo, true, 15);
		
		for(i = 0; i < eps0031VoListSize; i++){
			eps0031VoListInfo = eps0031VoList.get(i);
			
			this.stringValid(eps0031VoListInfo.getItemCode(),           true,         30);
			this.stringValid(eps0031VoListInfo.getAbolRsn(),            isDeleteFlag,  4);
			this.stringValid(eps0031VoListInfo.getAbolRsnEtc(),         false,       150);
			this.stringValid(eps0031VoListInfo.getAbolDate(),           isDeleteFlag,  8);
		}
	}
	
	/**
	 * <pre>
	 * eps0031 등록 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")  
	private Object[] eps0031UpdateIcommtglAbolObj(SepoaInfo info, Map<String, Object> param) throws Exception{
		Object[]                  result             = new Object[1];
		Map<String, Object>       resultInfo         = new HashMap<String, Object>();
		Map<String, String>       listInfo           = null;
		String                    houseCode          = info.getSession("HOUSE_CODE");
		String                    id                 = info.getSession("ID");
		String                    companyCode        = info.getSession("COMPANY_CODE");
		String                    mode               = (String)param.get("mode");
		String                    abolReqUserId      = (String)param.get("abolReqUserId");		
		List<Eps0031Vo>            eps0031VoList       = (List<Eps0031Vo>)param.get("eps0031VoList");
		List<Map<String, String>> list               = new ArrayList<Map<String, String>>();
		Eps0031Vo                  eps0031VoListInfo   = null;
		int                       eps0031VoListSize   = eps0031VoList.size();
		int                       i                  = 0;
		
		for(i = 0; i < eps0031VoListSize; i++){
			listInfo = new HashMap<String, String>();
			
			eps0031VoListInfo = eps0031VoList.get(i);
			
			listInfo.put("HOUSE_CODE",           houseCode);
			listInfo.put("ITEM_NO",              eps0031VoListInfo.getItemCode());
			listInfo.put("USER_ID",              id);
			listInfo.put("ABOL_RSN",             eps0031VoListInfo.getAbolRsn());
			listInfo.put("ABOL_RSN_ETC",         eps0031VoListInfo.getAbolRsnEtc());
			listInfo.put("ABOL_DATE",            eps0031VoListInfo.getAbolDate());
			listInfo.put("ABOL_REQ_USER_ID",     abolReqUserId);
			
			list.add(listInfo);
		}
		
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * eps0031 삭제 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private Object[] eps0031DeleteIcommtglAbolObj(SepoaInfo info, Map<String, Object> param) throws Exception{
		Object[]                  result           = new Object[1];
		Map<String, Object>       resultInfo       = new HashMap<String, Object>();
		Map<String, String>       listInfo         = null;
		String                    houseCode        = info.getSession("HOUSE_CODE");
		List<Map<String, String>> list             = new ArrayList<Map<String, String>>();
		List<Eps0031Vo>            eps0031VoList     = (List<Eps0031Vo>)param.get("eps0031VoList");
		Eps0031Vo                  eps0031VoListInfo = null;
		int                       eps0031VoListSize = eps0031VoList.size();
		int                       i                = 0;
		
		for(i = 0; i < eps0031VoListSize; i++){
			listInfo = new HashMap<String, String>();
			
			eps0031VoListInfo = eps0031VoList.get(i);
			
			listInfo.put("HOUSE_CODE", houseCode);
			listInfo.put("ITEM_NO",    eps0031VoListInfo.getItemCode());	
			
			list.add(listInfo);
		}
		
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * eps0031 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep0031Info(SepoaInfo info, String[] result){
		Map<String, String> param       = new HashMap<String, String>();
		Object[]            obj         = new Object[1];
		String              infNo       = result[1];
		String              returnValue = result[0];
		
		try{
			param.put("RETURN",     returnValue);
			param.put("HOUSE_CODE", "000");
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0031Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : EPS0031
	 * 인터페이스 명 : 품목정보(e홍보물) - 폐기등록
	 * 인터페이스 설명 : e홍보물시스템에서 생성 / 변경된 품목을 event 발생시 i/f한다. E홍보물 > 전자구매
	 * 
	 * ~. return 구조
	 *   !. (200 : 성공, 400 : 실패, 401 : 서비스 처리 실패, 402 : 필수값 입력 없음, 403 : 길이제한 위배, 404 : MODE 규약 코드 위배)
	 *   !. 인터페이스 번호
	 * </pre>
	 *
	 * @return String[]
	 */
	public String[] M05_REQ_ITEM(
			String   MODE,          String[] ITEM_CODE,   String[] ABOL_RSN,  String[] ABOL_RSN_ETC,   String[] ABOL_DATE,					
			String   ABOL_REQ_USER_ID,      String   INF_NO
		){
	
		String[]            result   = new String[3];
		String              method   = null;
		String              infNo    = null;
		String              status   = null;
		String              reason   = null;
		SepoaInfo           info     = null;
		SepoaOut            value    = null;
		Map<String, Object> param    = null;
		Object[]            obj      = null;
		boolean             isStatus = false;
		
		try{
			info      = this.getSepoaInfo();
			param     = this.eps0031Param(
					MODE,          ITEM_CODE,   ABOL_RSN,  ABOL_RSN_ETC,   ABOL_DATE,					
					ABOL_REQ_USER_ID,      INF_NO
			);

			infNo     = this.insertSinfhdInfo(info, "EPS0031", "R", ABOL_REQ_USER_ID);
			result[1] = infNo;
			
			this.insertSinfep0031Info(info, param, infNo);
			this.eps0031Valid(param);
			
			if("C".equals(MODE)){
				obj      = this.eps0031UpdateIcommtglAbolObj(info, param);
				method   = "updateIcommtglAbolList";
			}
			/*else if("U".equals(MODE)){
				obj      = this.eps005UpdateIcomrehdInfoObj(info, param);
				method   = "updateIcomrehdList";
			}*/
			else if("D".equals(MODE)){
				obj      = this.eps0031DeleteIcommtglAbolObj(info, param);
				method   = "deleteIcommtglAbolList";
			}
			
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", method, obj);
    		isStatus = value.flag;
    		
    		if(isStatus == false) {
    			//throw new Exception(this.SERVICE_FAIL); 
    			throw new Exception(value.message);    		
    		}
    		
			result[0] = this.SUCESS;
			result[2] = "";
			status    = "Y";
			reason    = " ";
		}
		catch(Exception e){
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			result[2] = e.getMessage();
			status    = "N";
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, INF_NO);
		this.updateSinfep0031Info(info, result);
		
		return result;
	}
    ////////////////////////////////////////////////////////////////////////////////////////////////eps0031 end!

	
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps0032 start!
	private class Eps0032Vo{
		private String MLOBSMCD;
		private String OUTXSEQT;
		private String CENTERCD;
		private String OUTXAMNT;
		
		private String STATCODE;
		private String OUTXDATE;
		private String OUTXTIME;
		private String OUTXIDNT;
		
		public String getMLOBSMCD() {
			return MLOBSMCD;
		}
		public void setMLOBSMCD(String MLOBSMCD) {
			this.MLOBSMCD = MLOBSMCD;
		}		
		public String getOUTXSEQT() {
			return OUTXSEQT;
		}
		public void setOUTXSEQT(String OUTXSEQT) {
			this.OUTXSEQT = OUTXSEQT;
		}		
		public String getCENTERCD() {
			return CENTERCD;
		}
		public void setCENTERCD(String CENTERCD) {
			this.CENTERCD = CENTERCD;
		}		
		public String getOUTXAMNT() {
			return OUTXAMNT;
		}
		public void setOUTXAMNT(String OUTXAMNT) {
			this.OUTXAMNT = OUTXAMNT;
		}		
		public String getSTATCODE() {
			return STATCODE;
		}
		public void setSTATCODE(String STATCODE) {
			this.STATCODE = STATCODE;
		}
		public String getOUTXDATE() {
			return OUTXDATE;
		}
		public void setOUTXDATE(String OUTXDATE) {
			this.OUTXDATE = OUTXDATE;
		}		
		public String getOUTXTIME() {
			return OUTXTIME;
		}
		public void setOUTXTIME(String OUTXTIME) {
			this.OUTXTIME = OUTXTIME;
		}
		public String getOUTXIDNT() {
			return OUTXIDNT;
		}
		public void setOUTXIDNT(String OUTXIDNT) {
			this.OUTXIDNT = OUTXIDNT;
		}
	}
	
	/**
	 * eps0032 파라미터를 생성하는 메소드
	 * 
	 * @param MODE
	 * @param ITEM_CODE
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, Object> eps0032Param(
			String   MODE,          String[] MLOBSMCD,   String[] OUTXSEQT,  String[] CENTERCD,   String[] OUTXAMNT,					
			String[] STATCODE,      String[] OUTXDATE,   String[] OUTXTIME,  String[] OUTXIDNT,   String   INF_NO
		) throws Exception{
		Map<String, Object> result                   = new HashMap<String, Object>();
		String              mode                     = this.nvl(MODE);
		String              rInfNo                   = this.nvl(INF_NO);
		List<Eps0032Vo>      eps0032VoList             = null;
		int                 MLOBSMCDLength           = this.getArrayLength(MLOBSMCD);            
		int                 OUTXSEQTLength           = this.getArrayLength(OUTXSEQT);            
		int                 CENTERCDLength           = this.getArrayLength(CENTERCD);             
		int                 OUTXAMNTLength           = this.getArrayLength(OUTXAMNT);             
		
		int                 STATCODELength           = this.getArrayLength(STATCODE);             
		int                 OUTXDATELength           = this.getArrayLength(OUTXDATE);             
		int                 OUTXTIMELength           = this.getArrayLength(OUTXTIME);             
		int                 OUTXIDNTLength           = this.getArrayLength(OUTXIDNT);             
		
		if(
			(MLOBSMCDLength == 0)                        || 
			(MLOBSMCDLength != OUTXSEQTLength)           ||
			(MLOBSMCDLength != CENTERCDLength)           ||
			(MLOBSMCDLength != OUTXAMNTLength)           ||
			(MLOBSMCDLength != STATCODELength)           ||
			(MLOBSMCDLength != OUTXDATELength)           ||
			(MLOBSMCDLength != OUTXTIMELength)           ||
			(MLOBSMCDLength != OUTXIDNTLength)           
		){
			throw new Exception(this.LONG_VALUE_FAIL);
		}
		
		eps0032VoList = this.eps0032ParamVoList(
				MLOBSMCD,   OUTXSEQT,  CENTERCD,   OUTXAMNT,					
				STATCODE,   OUTXDATE,  OUTXTIME,   OUTXIDNT
		);
		
		result.put("mode",         mode);
		result.put("rInfNo",       rInfNo);
		result.put("eps0032VoList", eps0032VoList);
		
		return result;
	}
	
	private List<Eps0032Vo> eps0032ParamVoList(
			String[] MLOBSMCD,   String[] OUTXSEQT,  String[] CENTERCD,   String[] OUTXAMNT,					
			String[] STATCODE,   String[] OUTXDATE,  String[] OUTXTIME,   String[] OUTXIDNT
		) throws Exception{
		List<Eps0032Vo> eps0032VoList     = new ArrayList<Eps0032Vo>();
		Eps0032Vo       eps0032VoListInfo = null;
		int            i                = 0;
		int            MLOBSMCDLength   = this.getArrayLength(MLOBSMCD);
		
		for(i = 0; i < MLOBSMCDLength; i++){			
			eps0032VoListInfo = new Eps0032Vo();
			
			eps0032VoListInfo.setMLOBSMCD(this.nvl(MLOBSMCD[i]));
			eps0032VoListInfo.setOUTXSEQT(this.nvl(OUTXSEQT[i]));
			eps0032VoListInfo.setCENTERCD(this.nvl(CENTERCD[i]));
			eps0032VoListInfo.setOUTXAMNT(this.nvl(OUTXAMNT[i]));
			eps0032VoListInfo.setSTATCODE(this.nvl(STATCODE[i]));
			eps0032VoListInfo.setOUTXDATE(this.nvl(OUTXDATE[i]));
			eps0032VoListInfo.setOUTXTIME(this.nvl(OUTXTIME[i]));
			eps0032VoListInfo.setOUTXIDNT(this.nvl(OUTXIDNT[i]));
			
			eps0032VoList.add(eps0032VoListInfo);
		}
		
		return eps0032VoList;
	}
	
	/**
	 * eps0032 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void insertSinfep0032Info(SepoaInfo info, Map<String, Object> param, String infNo) throws Exception{
		Map<String, String>       svcParam         = new HashMap<String, String>();
		Map<String, String>       eps0032PrInfo     = null;
		Map<String, Object>       objInfo          = new HashMap<String, Object>();
		String                    mode             = (String)param.get("mode");
		Object[]                  obj              = new Object[1];
		SepoaOut                  value            = null;
		List<Map<String, String>> eps0032Pr         = new ArrayList<Map<String, String>>();
		List<Eps0032Vo>            eps0032VoList     = (List<Eps0032Vo>)param.get("eps0032VoList");
		Eps0032Vo                  eps0032VoListInfo = null;
		boolean                  isStatus         = false;
		int                       eps0032VoListSize = eps0032VoList.size();
		int                       i                = 0;
		
		svcParam.put("HOUSE_CODE", "000");
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		
		for(i = 0; i < eps0032VoListSize; i++){
			eps0032PrInfo = new HashMap<String, String>();
			
			eps0032VoListInfo = eps0032VoList.get(i);
			
			eps0032PrInfo.put("HOUSE_CODE",           "000");
			eps0032PrInfo.put("INF_NO",               infNo);
			eps0032PrInfo.put("SEQ",                  Integer.toString(i));
			eps0032PrInfo.put("MLOBSMCD",            eps0032VoListInfo.getMLOBSMCD());
			eps0032PrInfo.put("OUTXSEQT",            eps0032VoListInfo.getOUTXSEQT());
			eps0032PrInfo.put("CENTERCD",            eps0032VoListInfo.getCENTERCD());
			eps0032PrInfo.put("OUTXAMNT",            eps0032VoListInfo.getOUTXAMNT());
			eps0032PrInfo.put("STATCODE",            eps0032VoListInfo.getSTATCODE());
			eps0032PrInfo.put("OUTXDATE",            eps0032VoListInfo.getOUTXDATE());
			eps0032PrInfo.put("OUTXTIME",            eps0032VoListInfo.getOUTXTIME());
			eps0032PrInfo.put("OUTXIDNT",            eps0032VoListInfo.getOUTXIDNT());
			
			eps0032Pr.add(eps0032PrInfo);
		}
		
		objInfo.put("eps0032",   svcParam);
		objInfo.put("eps0032Pr", eps0032Pr);
		
		obj[0]   = objInfo;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0032Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}
	
	/**
	 * 홍보물(e홍보물,안내장) 일괄배부 입력값에 대한 유효성을 검사하는 메소드
	 * 
	 * @param param 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void eps0032Valid(Map<String, Object> param) throws Exception{
		String         mode             = (String)param.get("mode");
		String         rInfNo           = (String)param.get("rInfNo");
		List<Eps0032Vo> eps0032VoList     = (List<Eps0032Vo>)param.get("eps0032VoList");
		Eps0032Vo       eps0032VoListInfo = null;
		boolean        isDeleteFlag     = false;
		int            eps0032VoListSize = eps0032VoList.size();
		int            i                = 0;
		
		this.stringValid(mode, true, 2);
		
		if(
			("C".equals(mode) == false) &&
			("U".equals(mode) == false) &&
			("D".equals(mode) == false)
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
		
		if("C".equals(mode)){
			isDeleteFlag = true;
		}
		
		this.stringValid(rInfNo, true, 15);
		
		for(i = 0; i < eps0032VoListSize; i++){
			eps0032VoListInfo = eps0032VoList.get(i);
			
			this.stringValid(eps0032VoListInfo.getMLOBSMCD(),           true,         30);
			this.stringValid(eps0032VoListInfo.getOUTXSEQT(),           true,         10);
			this.stringValid(eps0032VoListInfo.getCENTERCD(),           isDeleteFlag,  6); //TOBE 2017-07-01 5-> 6
			this.stringValid(eps0032VoListInfo.getOUTXAMNT(),           isDeleteFlag,  15);
			this.stringValid(eps0032VoListInfo.getSTATCODE(),           true,         4);
			this.stringValid(eps0032VoListInfo.getOUTXDATE(),           isDeleteFlag,  8);
			this.stringValid(eps0032VoListInfo.getOUTXTIME(),           isDeleteFlag,  6);
			this.stringValid(eps0032VoListInfo.getOUTXIDNT(),           isDeleteFlag,  8);			
		}
	}
	
	/**
	 * <pre>
	 * eps0032 등록 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")  
	private Object[] eps0032InsertTbaif02Obj(SepoaInfo info, Map<String, Object> param) throws Exception{
		Object[]                  result             = new Object[1];
		Map<String, Object>       resultInfo         = new HashMap<String, Object>();
		Map<String, String>       listInfo           = null;
		String                    houseCode          = info.getSession("HOUSE_CODE");
		String                    id                 = info.getSession("ID");
		String                    companyCode        = info.getSession("COMPANY_CODE");
		String                    mode               = (String)param.get("mode");
		String                    abolReqUserId      = (String)param.get("abolReqUserId");		
		List<Eps0032Vo>            eps0032VoList       = (List<Eps0032Vo>)param.get("eps0032VoList");
		List<Map<String, String>> list               = new ArrayList<Map<String, String>>();
		Eps0032Vo                  eps0032VoListInfo   = null;
		int                       eps0032VoListSize   = eps0032VoList.size();
		int                       i                  = 0;
		
		for(i = 0; i < eps0032VoListSize; i++){
			listInfo = new HashMap<String, String>();
			
			eps0032VoListInfo = eps0032VoList.get(i);
			
			listInfo.put("HOUSE_CODE",           houseCode);
			listInfo.put("USER_ID",              id);			
			listInfo.put("MLOBSMCD",             eps0032VoListInfo.getMLOBSMCD());
			listInfo.put("OUTXSEQT",             eps0032VoListInfo.getOUTXSEQT());
			listInfo.put("CENTERCD",             eps0032VoListInfo.getCENTERCD());
			listInfo.put("OUTXAMNT",             eps0032VoListInfo.getOUTXAMNT());
			listInfo.put("STATCODE",             eps0032VoListInfo.getSTATCODE());
			listInfo.put("OUTXDATE",             eps0032VoListInfo.getOUTXDATE());
			listInfo.put("OUTXTIME",             eps0032VoListInfo.getOUTXTIME());
			listInfo.put("OUTXIDNT",             eps0032VoListInfo.getOUTXIDNT());
			
			list.add(listInfo);
		}
		
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * eps0032 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep0032Info(SepoaInfo info, String[] result){
		Map<String, String> param       = new HashMap<String, String>();
		Object[]            obj         = new Object[1];
		String              infNo       = result[1];
		String              returnValue = result[0];
		
		try{
			param.put("RETURN",     returnValue);
			param.put("HOUSE_CODE", "000");
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0032Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * <pre>
	 * eps0032 삭제 서비스 호출을 위한 파라미터를 생성하는 메소드
	 * 
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * </pre>
	 * 
	 * @return Object[]
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private Object[] eps0032DeleteTbaif02Obj(SepoaInfo info, Map<String, Object> param) throws Exception{
		Object[]                  result           = new Object[1];
		Map<String, Object>       resultInfo       = new HashMap<String, Object>();
		Map<String, String>       listInfo         = null;
		String                    houseCode        = info.getSession("HOUSE_CODE");
		String                    id                 = info.getSession("ID");
		List<Map<String, String>> list             = new ArrayList<Map<String, String>>();
		List<Eps0032Vo>            eps0032VoList     = (List<Eps0032Vo>)param.get("eps0032VoList");
		Eps0032Vo                  eps0032VoListInfo = null;
		int                       eps0032VoListSize = eps0032VoList.size();
		int                       i                = 0;
		
		for(i = 0; i < eps0032VoListSize; i++){
			listInfo = new HashMap<String, String>();
			
			eps0032VoListInfo = eps0032VoList.get(i);
			
			listInfo.put("HOUSE_CODE", houseCode);
			listInfo.put("USER_ID",              id);			
			listInfo.put("MLOBSMCD",    eps0032VoListInfo.getMLOBSMCD());	
			listInfo.put("OUTXSEQT",    eps0032VoListInfo.getOUTXSEQT());	
			listInfo.put("STATCODE",    eps0032VoListInfo.getSTATCODE());							
			listInfo.put("OUTXDATE",    eps0032VoListInfo.getOUTXDATE());
			listInfo.put("OUTXIDNT",    eps0032VoListInfo.getOUTXIDNT());
						
			list.add(listInfo);
		}
		
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : EPS0032
	 * 인터페이스 명 : 품목정보(e홍보물) - 일괄배부
	 * 인터페이스 설명 : e홍보물시스템에서 생성 / 변경된 품목을 event 발생시 i/f한다. E홍보물 > 전자구매
	 * 
	 * ~. return 구조
	 *   !. (200 : 성공, 400 : 실패, 401 : 서비스 처리 실패, 402 : 필수값 입력 없음, 403 : 길이제한 위배, 404 : MODE 규약 코드 위배)
	 *   !. 인터페이스 번호
	 * </pre>
	 *
	 * @return String[]
	 */
	public String[] M06_REQ_ITEM(
			String   MODE,          String[] MLOBSMCD,   String[] OUTXSEQT,  String[] CENTERCD,   String[] OUTXAMNT,					
			String[] STATCODE,      String[] OUTXDATE,   String[] OUTXTIME,  String[] OUTXIDNT,   String   INF_NO
		){
			
		String[]            result   = new String[3];
		String              method   = null;
		String              infNo    = null;
		String              status   = null;
		String              reason   = null;
		SepoaInfo           info     = null;
		SepoaOut            value    = null;
		Map<String, Object> param    = null;
		Object[]            obj      = null;
		boolean             isStatus = false;
		
		try{
			info      = this.getSepoaInfo();
			param     = this.eps0032Param(
					MODE,          MLOBSMCD,   OUTXSEQT,  CENTERCD,   OUTXAMNT,					
					STATCODE,      OUTXDATE,   OUTXTIME,  OUTXIDNT,   INF_NO
			);

			infNo     = this.insertSinfhdInfo(info, "EPS0032", "R", OUTXIDNT[0]);
			result[1] = infNo;
			
			this.insertSinfep0032Info(info, param, infNo);
			this.eps0032Valid(param);
			
			if("C".equals(MODE)){
				obj      = this.eps0032InsertTbaif02Obj(info, param);
				method   = "insertTbaif02List";
			}
			/*else if("U".equals(MODE)){
				obj      = this.eps005UpdateIcomrehdInfoObj(info, param);
				method   = "updateIcomrehdList";
			}*/
			else if("D".equals(MODE)){
				obj      = this.eps0032DeleteTbaif02Obj(info, param);
				method   = "deleteTbaif02List";
			}
			
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", method, obj);
    		isStatus = value.flag;
    		
    		if(isStatus == false) {
//    			throw new Exception(this.SERVICE_FAIL);    			
    			throw new Exception(value.message);    			
    		}
    		
			result[0] = this.SUCESS;
			result[2] = "";			
			status    = "Y";
			reason    = " ";
		}
		catch(Exception e){
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			result[2] = e.getMessage();			
			status    = "N";
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, INF_NO);
		this.updateSinfep0032Info(info, result);
		
		return result;	
	}

	
	////////////////////////////////////////////////////////////////////////////////////////////////eps0032 end!

	

	////////////////////////////////////////////////////////////////////////////////////////////////eps0011 start!	
	private Object[] eps011Obj(String SRMS_NO, String SUBJECT, String ADD_USER_ID, String ADD_USER_NAME, M04_REQ_PR_DETAIL[] detail, String infNo, SepoaInfo info) throws Exception{
		Map<String, String> prHd      = new HashMap<String, String>();
		Map<String, Object> svcParam  = new HashMap<String, Object>();
		Object[]            svcObject = new Object[1];
//		String              addUserId = CommonUtil.getConfig("sepoa.eps0011.userid");

		prHd.put("srmsNo",      SRMS_NO);
		prHd.put("subject",     SUBJECT);
		prHd.put("addUserId",   ADD_USER_ID);
		prHd.put("addUserName", ADD_USER_NAME);

		svcParam.put("info",   info);
		svcParam.put("prHd",   prHd);
		svcParam.put("detail", detail);
		svcParam.put("infNo",  infNo);

		svcObject[0] = svcParam;

		return svcObject;
	}

	/**
	 * eps0011 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	private void insertSinfep0011Info(SepoaInfo info, Object[] param) throws Exception{
		SepoaOut value    = null;
		boolean  isStatus = false;

		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0011Info", param);
		isStatus = value.flag;

		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}

	/**
	 * <pre>
	 * 구매요청 인터페이스 데이터에 대한 유효성을 검사하는 메소드
	 * param 맵 구조
	 * 	mode
	 * 	itemCode
	 * 	itemName
	 * 	specification
	 * </pre>
	 * 
	 * @param param
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void eps0011Valid(Object[] param) throws Exception{
		Map<String, Object> svcParam     = (Map<String, Object>)param[0];
		Map<String, String> prHd         = (Map<String, String>)svcParam.get("prHd");
		String              srmsNo       = prHd.get("srmsNo");
		String              subject      = prHd.get("subject");
		String              addUserId    = prHd.get("addUserId");
		String              addUserName  = prHd.get("addUserName");
		String              srmsSeq      = null;
		String              itemNo       = null;
		String              prQty        = null;
		String              unitPrice    = null;
		String              prAmt        = null;
		M04_REQ_PR_DETAIL[] detail       = (M04_REQ_PR_DETAIL[])svcParam.get("detail");
		M04_REQ_PR_DETAIL   detailInfo   = null;
		int                 detailLength = detail.length;
		int                 i            = 0;

		this.stringValid(srmsNo,      true, 20);
		this.stringValid(subject,     true, 500);
		this.stringValid(addUserId,   true, 20);
		this.stringValid(addUserName, true, 50);

		for(i = 0; i < detailLength; i++){
			detailInfo = detail[i];

			srmsSeq   = detailInfo.getSRMS_SEQ();
			itemNo    = detailInfo.getITEM_NO();
			prQty     = detailInfo.getPR_QTY();
			unitPrice = detailInfo.getUNIT_PRICE();
			prAmt     = detailInfo.getPR_AMT();

			this.stringValid(srmsSeq,   true, 6);
			this.stringValid(itemNo,    true, 50);
			this.stringValid(prQty,     true, 22);
			this.stringValid(unitPrice, true, 22);
			this.stringValid(prAmt,     true, 22);
		}
	}

	/**
	 * eps0011 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep0011Info(SepoaInfo info, String[] result){
		Map<String, String> param       = new HashMap<String, String>();
		Object[]            obj         = new Object[1];
		String              infNo       = result[1];
		String              returnValue = result[0];

		try{
			param.put("RETURN",     returnValue);
			param.put("HOUSE_CODE", "000");
			param.put("INF_NO",     infNo);

			obj[0] = param;

			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0011Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}

	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : eps0011
	 * 인터페이스 명 : 구매요청(I/T)
	 * 인터페이스 설명 : 구매요청(I/T)
	 * 
	 * ~. return 구조
	 *   !. (200 : 성공, 400 : 실패, 401 : 서비스 처리 실패, 402 : 필수값 입력 없음, 403 : 길이제한 위배)
	 *   !. 인터페이스 번호
	 * </pre>
	 * 
	 * @param SRMS_NO (번호, varchar, 20)
	 * @param SUBJECT (구매요청 제목, varchar, 500)
	 * @param USRUSRID (인터페이스 사용자 아이디, varchar, 8)
	 * @param detail (상세, 내부 M04_REQ_PR_DETAIL 클래스 참조)
	 * @return String[] 
	 */
	public String[] M04_REQ_PR(String SRMS_NO, String SUBJECT, String ADD_USER_ID, String ADD_USER_NAME, M04_REQ_PR_DETAIL[] detail){
		String[]  result    = new String[2];
		SepoaInfo info      = null;
		SepoaOut  value     = null;
		Object[]  svcObject = null;
		String    infNo     = null;
		String    status    = null;
		String    reason    = null;
		boolean   isStatus  = false;

		try{
			info      = this.getSepoaInfo();
			infNo     = this.insertSinfhdInfo(info, "EPS0011", "R", ADD_USER_ID);
			svcObject = this.eps011Obj(SRMS_NO, SUBJECT, ADD_USER_ID, ADD_USER_NAME, detail, infNo, info);
			result[1] = infNo;

			this.insertSinfep0011Info(info, svcObject);
			this.eps0011Valid(svcObject);

			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertIcoyInfo", svcObject);
			isStatus = value.flag;

			if(isStatus == false) {
				throw new Exception(this.SERVICE_FAIL); 
			}

			result[0] = this.SUCESS;
			status    = "Y";
			reason    = " ";
		}
		catch (Exception e) {
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			status    = "N";
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
		}

		this.updateSinfhdInfo(info, infNo, status, reason, SRMS_NO);
		this.updateSinfep0011Info(info, result);

		return result;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////eps0011 end!
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps0022 start!
	/**
	 * 파라미터를 맵으로 변환하는 메소드
	 * 
	 * @param DOC_NO
	 * @param STATUS
	 * @param GW_DOC_NO
	 * @param APP_DATE
	 * @param APP_TIME
	 * @param GW_TITLE
	 * @param DOC_LINK
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> EPS0022_2Param(
			String DOC_NO,   String STATUS,   String GW_DOC_NO,     String APP_DATE,        String APP_TIME,
			String GW_TITLE, String DOC_LINK, String REGISTER_DATE, String APPROVAL_PRO_ID, String APPROVAL_INS_ID
		) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		
		result.put("docNo",         DOC_NO);
		result.put("status",        STATUS);
		result.put("gwDocNo",       GW_DOC_NO);
		result.put("appDate",       APP_DATE);
		result.put("appTime",       APP_TIME);
		result.put("gwTitle",       GW_TITLE);
		result.put("docLink",       DOC_LINK);
		result.put("registerDate",  REGISTER_DATE);
		result.put("approvalProId", APPROVAL_PRO_ID);
		result.put("approvalInsId", APPROVAL_INS_ID);
		
		return result;
	}
	
	/**
	 * 입력값 유효성을 검사하는 메소드
	 * 
	 * @param param
	 * @throws Exception
	 */
	private void EPS0022_2Valid(Map<String, String> param) throws Exception{
		String  docNo         = param.get("docNo");
		String  status        = param.get("status");
		String  gwDocNo       = param.get("gwDocNo");
		String  appDate       = param.get("appDate");
		String  appTime       = param.get("appTime");
		String  gwTitle       = param.get("gwTitle");
		String  docLink       = param.get("docLink");
		String  registerDate  = param.get("registerDate");
		String  approvalProId = param.get("approvalProId");
		String  approvalInsId = param.get("approvalInsId");
		boolean isStatusE     = false;
		
		this.stringValid(docNo,   true, 30);
		this.stringValid(status,  true, 2);
		this.stringValid(gwDocNo, false, 30);
		this.stringValid(appDate, false, 8);
		this.stringValid(appTime, false, 6);
		this.stringValid(gwTitle, false, 500);
		this.stringValid(docLink, false, 1024);
		
		if(
			("P".equals(status) == false) &&
			("R".equals(status) == false) &&
			("E".equals(status) == false) &&
			("D".equals(status) == false)
		){
			throw new Exception(this.CODE_VALUE_FAIL);
		}
		
		if("E".equals(status)){
			isStatusE = true;
		}
		
		this.stringValid(registerDate,  isStatusE, 10);
		this.stringValid(approvalProId, isStatusE, 50);
		this.stringValid(approvalInsId, isStatusE, 50);
	}
	
	/**
	 * eps0022_2 로그 정보를 등록하는 메소드
	 * 
	 * @param info
	 * @param param
	 * @param infNo
	 * @throws Exception
	 */
	private void insertSinfep0022_2Info(SepoaInfo info, Map<String, String> param, String infNo) throws Exception{
		SepoaOut            value         = null;
		Object[]            svcParam      = new Object[1];
		Map<String, String> svcParamInfo  = new HashMap<String, String>();
		String              houseCode     = info.getSession("HOUSE_CODE");
		String              docNo         = param.get("docNo");
		String              status        = param.get("status");
		String              gwDocNo       = param.get("gwDocNo");
		String              appDate       = param.get("appDate");
		String              appTime       = param.get("appTime");
		String              gwTitle       = param.get("gwTitle");
		String              docLink       = param.get("docLink");
		String              registerDate  = param.get("registerDate");
		String              approvalProId = param.get("approvalProId");
		String              approvalInsId = param.get("approvalInsId");
		boolean             isStatus      = false;
		
		svcParamInfo.put("HOUSE_CODE",      houseCode);
		svcParamInfo.put("INF_NO",          infNo);
		svcParamInfo.put("DOC_NO",          docNo);
		svcParamInfo.put("STATUS",          status);
		svcParamInfo.put("GW_COD_NO",       gwDocNo);
		svcParamInfo.put("APP_DATE",        appDate);
		svcParamInfo.put("APP_TIME",        appTime);
		svcParamInfo.put("GW_TITLE",        gwTitle);
		svcParamInfo.put("DOC_LINK",        docLink);
		svcParamInfo.put("REGISTER_DATE",   registerDate);
		svcParamInfo.put("APPROVAL_PRO_ID", approvalProId);
		svcParamInfo.put("APPROVAL_INS_ID", approvalInsId);
		
		svcParam[0] = svcParamInfo;
		value       = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0022_2Info", svcParam);
		isStatus    = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
	}
	
	/**
	 * eps0022_2 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep0022_2Info(SepoaInfo info, String[] result){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("RETURN1",    result[0]);
			param.put("RETURN2",    result[1]);
			param.put("RETURN3",    result[2]);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     result[2]);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0022_2Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	/**
	 * 서비스 호출을 위한 파라미터 작성
	 * 
	 * @param param
	 * @param info
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] EPS0022_2Obj(Map<String, String> param, SepoaInfo info) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              status     = param.get("status");
		String              docNo      = param.get("docNo");
		String              id         = info.getSession("ID");
		
		resultInfo.put("STATUS",         status);
		resultInfo.put("CHANGE_USER_ID", id);
		resultInfo.put("DOC_NO",         docNo);
		
		result[0] = resultInfo;
				
		return result;
	}
	
	/**
	 * 예외에 대한 메세지 작성
	 * 
	 * @param e
	 * @return String
	 */
	private String eps0022_2ExceptionReason(Exception e){
		String result    = null;
		String errorCode = this.getErrorMessage(e);
		
		if(this.CODE_VALUE_FAIL.equals(errorCode)){
			result = "규약되지 않은 코드 정보입니다.";
		}
		else if(this.LONG_VALUE_FAIL.equals(errorCode)){
			result = "길이정보가 맞지 않는 정보입니다.";
		}
		else if(this.REQUIRE_VALUE_FAIL.equals(errorCode)){
			result = "필수값 정보를 확인하여 주십시오.";
		}
		else if(this.SERVICE_FAIL.equals(errorCode)){
			result = "서비스 수행 중 문제가 발생하였습니다.";
		}
		else if(this.FAIL.equals(errorCode)){
			result = "시스템 수행 중 문제가 발생하였습니다.";
		}
		else{
			result = "";
		}
		
		return result;
	}
	
	/**
	 * <pre>
	 * 업무명 : 전자구매
	 * 인터페이스 아이디 : EPS0022_2
	 * 인터페이스 명 : G/W 상태
	 * 인터페이스 설명 : G/W문서 상태 처리
	 * </pre>
	 * 
	 * @param DOC_NO
	 * @param STATUS
	 * @param GW_DOC_NO
	 * @param APP_DATE
	 * @param APP_TIME
	 * @param GW_TITLE
	 * @param DOC_LINK
	 * @return
	 */
	public String[] EPS0022_2(
			String DOC_NO,   String STATUS,   String GW_DOC_NO,     String APP_DATE,        String APP_TIME,
			String GW_TITLE, String DOC_LINK, String REGISTER_DATE, String APPROVAL_PRO_ID, String APPROVAL_INS_ID){
		String[]            result    = new String[3];
		String              infNo     = null;
		String              status    = null;
		String              reason    = null;
		SepoaInfo           info      = null;
		Map<String, String> param     = null;
		Object[]            svcObject = new Object[1];
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		try{
			info      = this.getSepoaInfo();
			infNo     = this.insertSinfhdInfo(info, "EPS0022", "R", " ");
			param     = this.EPS0022_2Param(DOC_NO, STATUS, GW_DOC_NO, APP_DATE, APP_TIME, GW_TITLE, DOC_LINK, REGISTER_DATE, APPROVAL_PRO_ID, APPROVAL_INS_ID);
			result[2] = infNo;
			
			this.insertSinfep0022_2Info(info, param, infNo);
			this.EPS0022_2Valid(param);
			
			svcObject = this.EPS0022_2Obj(param, info);
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateIcoyprdtGwStatusList", svcObject);
    		isStatus = value.flag;
    		
    		if(isStatus == false) {
    			throw new Exception(this.SERVICE_FAIL); 
    		}
    		
			status    = "Y";
			reason    = " ";
			
			result[0] = this.SUCESS;
			result[1] = reason;
		}
		catch(Exception e){
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
			
			result[0] = this.getErrorMessage(e);
			result[1] = this.eps0022_2ExceptionReason(e);
			result[2] = infNo;
			status    = "N";
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, " ");
		this.updateSinfep0022_2Info(info, result);
		
		return result;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////eps0022 end!
	
	////////////////////////////////////////////////////////////////////////////////////////////////eps0030 start!
	private Map<String, Object> eps0030param(
		String[] MODE,     String[] BSDEPTCD, String[] BSNDSEQT, String[]  MLOBSMCD, String[] OUTXAMNT,
		String   OUTXDATE, String   OUTXIDNT, String   INF_NO,   SepoaInfo info,     String   infNo
	) throws Exception{
		Map<String, Object>       result         = new HashMap<String, Object>();
		Map<String, String>       header         = new HashMap<String, String>();
		Map<String, String>       listInfo       = null;
		List<Map<String, String>> list           = new ArrayList<Map<String, String>>();
		String                    houseCode      = info.getSession("HOUSE_CODE");
		String                    modeInfo       = null;
		String                    bsDeptCdInfo   = null;
		String                    bsNdseQtInfo   = null;
		String                    mloBsmCdInfo   = null;
		String                    outxAmntInfo   = null;
		int                       modeLength     = this.getArrayLength(MODE);
		int                       bsDeptCdLength = this.getArrayLength(BSDEPTCD);
		int                       bsNdseQtLength = this.getArrayLength(BSNDSEQT);
		int                       mloBsmCdLength = this.getArrayLength(MLOBSMCD);
		int                       outxAmntLength = this.getArrayLength(OUTXAMNT);
		int                       i              = 0;
		
		if(
			(modeLength == 0) ||
			(modeLength != bsDeptCdLength) ||
			(modeLength != bsNdseQtLength) ||
			(modeLength != mloBsmCdLength) ||
			(modeLength != outxAmntLength)
		){
			Logger.err.println("eps0030param : modeLength "+modeLength);
			Logger.err.println("eps0030param : bsDeptCdLength "+bsDeptCdLength);
			Logger.err.println("eps0030param : bsNdseQtLength "+bsNdseQtLength);
			Logger.err.println("eps0030param : mloBsmCdLength "+mloBsmCdLength);
			Logger.err.println("eps0030param : outxAmntLength "+outxAmntLength);
			
			throw new Exception(this.LONG_VALUE_FAIL);
		}
		Logger.err.println("MODE==============="+MODE.toString());
		this.stringValid(OUTXDATE, true, 8);
		this.stringValid(OUTXIDNT, true, 8);
		this.stringValid(INF_NO,   true, 15);
		
		header.put("HOUSE_CDOE", houseCode);
		header.put("INF_NO",     infNo);
		header.put("OUTXDATE",   OUTXDATE);
		header.put("OUTXIDNT",   OUTXIDNT);
		header.put("REF_INF_NO", INF_NO);
		
		for(i = 0; i < modeLength; i++){
			listInfo = new HashMap<String, String>();
			
			modeInfo     = MODE[i];
			bsDeptCdInfo = BSDEPTCD[i];
			bsNdseQtInfo = BSNDSEQT[i];
			mloBsmCdInfo = MLOBSMCD[i];
			outxAmntInfo = OUTXAMNT[i];
			
			this.stringValid(modeInfo,     true, 1);
			this.stringValid(bsDeptCdInfo, true, 6); // TOBE 2017-07-01  길이 5->6 변경
			this.stringValid(bsNdseQtInfo, true, 12);
			this.stringValid(mloBsmCdInfo, true, 10);
			this.stringValid(outxAmntInfo, true, 15);
			
//			if(("U".equals(modeInfo) || "D".equals(modeInfo)) == false){
//				throw new Exception(this.CODE_VALUE_FAIL);
//			}
			
			if(!"U".equals(modeInfo) && !"D".equals(modeInfo)) {
				throw new Exception(this.CODE_VALUE_FAIL);
			}
			
			listInfo.put("HOUSE_CODE", houseCode);
			listInfo.put("INF_NO",     infNo);
			listInfo.put("SEQ",        Integer.toString(i));
			listInfo.put("INF_MODE",   modeInfo);
			listInfo.put("BSDEPTCD",   bsDeptCdInfo);
			listInfo.put("BSNDSEQT",   bsNdseQtInfo);
			listInfo.put("MLOBSMCD",   mloBsmCdInfo);
			listInfo.put("OUTXAMNT",   outxAmntInfo);
			
			list.add(listInfo);
		}
		
		result.put("header", header);
		result.put("list",   list);
		
		return result;
	}
	
	private Object[] insertSinfep0030(Map<String, Object> param, SepoaInfo info) throws Exception{
		Object[] result   = new Object[1];
		SepoaOut value    = null;
		boolean  isStatus = false;
		
		result[0] = param;
		
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0030", result);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(this.FAIL); 
		}
		
		return result;
	}
	
	/**
	 * eps0030 로그 정보를 수정하는 메소드
	 * 
	 * @param info
	 * @param result
	 * @throws Exception
	 */
	private void updateSinfep0030Info(SepoaInfo info, String[] result){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("RETURN1",    result[0]);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     result[1]);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0030Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	public String[] eps0030(
		String[] MODE,     String[] BSDEPTCD, String[] BSNDSEQT, String[] MLOBSMCD, String[] OUTXAMNT,
		String   OUTXDATE, String   OUTXIDNT, String   INF_NO
	){
		String[]            result    = new String[2];
		String              infNo     = null;
		String              status    = null;
		String              reason    = null;
		SepoaInfo           info      = null;
		Map<String, Object> param     = null;
		Object[]            svcObject = null;
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		try{
			info      = this.getSepoaInfo();
			infNo     = this.insertSinfhdInfo(info, "EPS0030", "R", " ");
			param     = this.eps0030param(MODE, BSDEPTCD, BSNDSEQT, MLOBSMCD, OUTXAMNT, OUTXDATE, OUTXIDNT, INF_NO, info, infNo);
			svcObject = this.insertSinfep0030(param, info);
			Logger.err.println("=========================================");
            Logger.err.println("svcObject=================================="+svcObject[0].toString());
            Logger.err.println("=========================================");
			
			value     = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateIOList", svcObject);
    		isStatus  = value.flag;
    		
    		if(isStatus == false) {
    			throw new Exception(this.SERVICE_FAIL); 
    		}
    		
			status    = "Y";
			reason    = " ";
			
			result[0] = this.SUCESS;
			result[1] = infNo;
		}
		catch(Exception e){
//			e.printStackTrace();
			reason    = this.getExceptionStackTrace(e);
			reason    = this.getStringMaxByte(reason, 4000);
			
			result[0] = this.getErrorMessage(e);
			result[1] = infNo;
			status    = "N";
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, INF_NO);
		this.updateSinfep0030Info(info, result);
		
		return result;
	}
	////////////////////////////////////////////////////////////////////////////////////////////////eps0030 end!
}