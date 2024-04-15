package sepoa.fw.mail;

public class EmailAttachmentVo {
	private String  path =	"";   
	private String  disposition =	"";   
	private String  description =	"";   
	private String  name =	"";
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDisposition() {
		return disposition;
	}
	public void setDisposition(String disposition) {
		this.disposition = disposition;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}   
}
