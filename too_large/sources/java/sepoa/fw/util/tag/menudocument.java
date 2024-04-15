package sepoa.fw.util.tag;

import java.util.Iterator;
import java.util.Map;

/**
 * 폴더와 파일 구분 처리 위한 클래스
 * 
 * @author user
 * 
 */
class MenuDocument {
	protected MenuDocument parent;

	protected String getList(MenuFolder folder) {

		StringBuffer sb = new StringBuffer();

		Iterator<Map.Entry<String, MenuDocument>> iter = folder.subfolder
				.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry<String, MenuDocument> entry = (Map.Entry<String, MenuDocument>) iter
					.next();
			// String key = (String)entry.getKey();
			MenuDocument value = (MenuDocument) entry.getValue();

			if (value instanceof MenuFolder) {
				MenuFolder temp = (MenuFolder) value;
				sb.append("<item text='" + temp.name + "' id='" + temp.code
						+ "' open='1'>");
				sb.append(getList((MenuFolder) value));
				sb.append("</item>");
			} else if (value instanceof MenuFile) {
				MenuFile file = (MenuFile) value;
				sb.append("<item text='" + file.name + "' id='" + file.code
						+ "'>");
				sb.append("<userdata name='href'>" + file.path + "</userdata>");
				sb.append("</item>");
			} else {
				new Exception();
			}
		}
		return sb.toString();
	}
}