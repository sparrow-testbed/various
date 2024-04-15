package sepoa.fw.util.tag;

class MenuFile extends MenuDocument {
	protected String code;
	protected String name;
	protected String path;

	protected MenuFile(String code, String name, String path) {
		this.code = code;
		this.name = name;
		if (path == null || path.equals("")) {
			this.path = "NULL";
		} else {
			this.path = path;
		}
	}
}