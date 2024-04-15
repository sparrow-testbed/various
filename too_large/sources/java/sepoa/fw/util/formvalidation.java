package sepoa.fw.util;

import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**
 * 매개변수 조작 대상이 되는 페이지에 사용될 폼 체크 클래스 폼을 화면에 표시되는 단계에서 변경되지 말아야할 매개변수를 세션에 등록하고
 * request에서 폼데이터를 받아오는 단계에서 세션에 등록된 폼데이터와 비교한다.
 * 
 * 
 * @author
 * @version 1.0
 * @see
 */
public class FormValidation {

	public static ThreadLocal<HttpServletRequest> tl = new ThreadLocal<HttpServletRequest>();

	/**
	 * 세션에 PK추가
	 * 
	 * @param request
	 * @param id
	 * @param key
	 * @param value
	 */
	public static void addKey(HttpServletRequest request, String id,
			String key, String value) {
		SessionFormInfo formInfo = SessionFormInfo.getSessionFormInfo(request,
				id);
		formInfo.addKey(request, key, value);
	}

	public static void resetKeyMap(HttpServletRequest request, String id) {
		SessionFormInfo.resetSessionFormInfo(request, id);
	}

	public static boolean checkForm() {
		return checkForm(null);
	}

	public static boolean checkForm(String id) {
		HttpServletRequest request = tl.get();
		if (request != null) {
			return checkForm(request, id);
		}
		return true;
	}
	
	public static boolean checkForm(String id, boolean reset) {
		HttpServletRequest request = tl.get();
		boolean res = checkForm(id);
		if(res && reset) {
			SessionFormInfo.resetSessionFormInfo(request, id);
		}
		return res;
	}

	/**
	 * 받은 리퀘스트로부터 폼데이터를 받아 검증하는 메소드. 일반 리퀘스트용
	 * 
	 * @param request
	 *            세션 및 정보를 얻기위한 리퀘스트
	 * @return boolean 검증 성공여부
	 * @exception
	 * @see
	 */
	@SuppressWarnings("unchecked")
	public static boolean checkForm(HttpServletRequest request, String id) {
		Map<String, String> parameterMap = new LinkedHashMap<String, String>();
		Enumeration<String> enu = request.getParameterNames();
		while (enu.hasMoreElements()) {
			String name = (String) enu.nextElement();
			parameterMap.put(name, request.getParameter(name));
		}
		boolean res = FormValidation.checkForm(request, parameterMap, id);
		return res;
	}

	/**
	 * 받은 리퀘스트로부터 폼데이터를 받아 검증하는 메소드. 폼키가 있는 경우 폼벨리데이션리스트로부터 특정 폼을 찾아 검증하고 없을 경우
	 * 전체 파라메터를 검색하여 검증한다.
	 * 
	 * @param request
	 *            세션 및 정보를 얻기위한 리퀘스트
	 * @return boolean 검증 성공여부
	 * @exception
	 * @see
	 */
	public static boolean checkForm(HttpServletRequest request,
			Map<String, String> parameterMap, String id) {

		SessionFormInfo sessionFormInfo = SessionFormInfo.getSessionFormInfo(
				request, id);
		return sessionFormInfo.checkForm(parameterMap);

	}
}
