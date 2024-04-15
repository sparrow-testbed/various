package sepoa.fw.util;

import java.io.Serializable;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionFormInfo implements Serializable {

	private static final long serialVersionUID = 6460357504927205134L;

	public static final String FORM_VALIDATION_DATA_KEY = "form_validation_data";

	public static final String FORM_VALIDATION_DEFAULT_ID = "form_validation_default_id";

	private String id = null;

	private HttpServletRequest request = null;

	private LinkedHashMap<String, String> map = null;

	public SessionFormInfo(String id) {
		this.id = id;
		map = new LinkedHashMap<String, String>();
	}

	@SuppressWarnings("unchecked")
	public static SessionFormInfo getSessionFormInfo(
			HttpServletRequest request, String id) {
		SessionFormInfo result = null;

		if (id == null) {
			id = SessionFormInfo.FORM_VALIDATION_DEFAULT_ID;
		}

		HttpSession session = request.getSession();
		Map<String, SessionFormInfo> map = (Map<String, SessionFormInfo>) session
				.getAttribute(SessionFormInfo.FORM_VALIDATION_DATA_KEY);
		if (map == null) {
			map = new HashMap<String, SessionFormInfo>();
			session.setAttribute(SessionFormInfo.FORM_VALIDATION_DATA_KEY, map);
		}
		result = map.get(id);
		if (result == null) {
			result = new SessionFormInfo(id);
			map.put(id, result);
		}

		return result;
	}

	@SuppressWarnings("unchecked")
	public static void resetSessionFormInfo(HttpServletRequest request,
			String id) {
		if (id == null) {
			id = SessionFormInfo.FORM_VALIDATION_DEFAULT_ID;
		}
		HttpSession session = request.getSession();
		Map<String, SessionFormInfo> map = (Map<String, SessionFormInfo>) session
				.getAttribute(SessionFormInfo.FORM_VALIDATION_DATA_KEY);
		if (map != null) {
			SessionFormInfo formInfo = map.get(id);
			if (formInfo != null) {
				map.remove(id);
			}
		}
	}

	public void validateRequest(HttpServletRequest request) {
		if (this.request != null && !this.request.equals(request)) {
			map.clear();
			this.request = request;
		}
	}

	public void addKey(HttpServletRequest request, String key, String value) {
		validateRequest(request);
		map.put(key, value);
	}

	public boolean checkForm(Map<String, String> parameterMap) {
		boolean result = true;
		Set<Entry<String, String>> entrySet = this.map.entrySet();
		for (Entry<String, String> entry : entrySet) {
			String key = entry.getKey();
			Object value = entry.getValue();
			Object mapValue = parameterMap.get(key);
			if (mapValue == null)
				mapValue = "";
			if (value == null)
				value = "";
			if (!mapValue.equals(value)) {
				result = false;
				
				break;
			}
			
		}

		return result;
	}
}
