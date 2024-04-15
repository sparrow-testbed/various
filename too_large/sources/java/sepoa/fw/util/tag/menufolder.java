package sepoa.fw.util.tag;

import java.util.LinkedHashMap;

class MenuFolder extends MenuDocument {
	protected String code;
	protected String name;
	protected LinkedHashMap<String, MenuDocument> subfolder = new LinkedHashMap<String, MenuDocument>();

	protected MenuFolder(String code, String name) {
		this.code = code;
		this.name = name;
	}

	public void addDocument(String code, MenuDocument document) {
		this.subfolder.put(code, document);
		document.parent = this;
	}
}