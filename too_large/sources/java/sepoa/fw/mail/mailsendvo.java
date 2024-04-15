package sepoa.fw.mail;

import java.util.ArrayList;
import java.util.Vector;

public class MailSendVo {
	private String  subject =	"";   
	private String  sender_id =	"";   
	private String  sender_name =	"";   
	private String  sender_addr =	"";   
	private String  contents =	"";   
	private Vector  m_to_values = new Vector();  
	private Vector  m_to_name_values = new Vector();  
	private String  doc_type =	"";   
	private String  doc_no =	"";   
	private String  mail_recv_name ="";   
	private ArrayList  attachmentList =	new ArrayList();
	public ArrayList getAttachmentList() {
		return attachmentList;
	}
	public void setAttachmentList(ArrayList attachmentList) {
		this.attachmentList = attachmentList;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getDoc_no() {
		return doc_no;
	}
	public void setDoc_no(String doc_no) {
		this.doc_no = doc_no;
	}
	public String getDoc_type() {
		return doc_type;
	}
	public void setDoc_type(String doc_type) {
		this.doc_type = doc_type;
	}
	public Vector getM_to_values() {
		return m_to_values;
	}
	public void setM_to_values(Vector m_to_values) {
		this.m_to_values = m_to_values;
	}
	public String getMail_recv_name() {
		return mail_recv_name;
	}
	public void setMail_recv_name(String mail_recv_name) {
		this.mail_recv_name = mail_recv_name;
	}
	public String getSender_addr() {
		return sender_addr;
	}
	public void setSender_addr(String sender_addr) {
		this.sender_addr = sender_addr;
	}
	public String getSender_id() {
		return sender_id;
	}
	public void setSender_id(String sender_id) {
		this.sender_id = sender_id;
	}
	public String getSender_name() {
		return sender_name;
	}
	public void setSender_name(String sender_name) {
		this.sender_name = sender_name;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public Vector getM_to_name_values() {
		return m_to_name_values;
	}
	public void setM_to_name_values(Vector m_to_name_values) {
		this.m_to_name_values = m_to_name_values;
	}   
}
