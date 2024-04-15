package sepoa.fw.util.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;

public class Calendar extends BodyTagSupport {

	private static final long serialVersionUID = 8744648316949559103L;
	
	private String id = null;
	
	private String disabled = null;
	
	private String default_value= null;
	
	private String id_from = null;

	private String id_to = null;
	
	private String default_from = null;
	
	private String default_to = null;

	private String format = null;
	
	private String cssClass = null;

	public void setId(String id) {
		this.id = id;
	}
	
	public void setDisabled(String disabled) {
		this.disabled = disabled;
	}
	
	public void setDefault_value(String defaultValue) {
		this.default_value = defaultValue;
	}
	
	public void setId_from(String id_from) {
		this.id_from = id_from;
	}
	
	public void setDefault_from(String default_from) {
		this.default_from = default_from;
	}
	
	public void setDefault_to(String default_to) {
		this.default_to= default_to;
	}

	public void setId_to(String id_to) {
		this.id_to = id_to;
	}

	public void setFormat(String format) {
		this.format = format;
	}
	
	public void setCssClass(String cssClass) {
		this.cssClass = cssClass;
	}

	/**
	 * TagSupport override
	 */
	public int doStartTag() throws JspException {
		return EVAL_BODY_BUFFERED;
	}

	public int doAfterBody() throws JspException {
		BodyContent bc = getBodyContent();
		
		return EVAL_BODY_INCLUDE;
	}

	public int doEndTag() throws JspException {
		try {
			Config config = new Configuration();
			String POASRM_CONTEXT_NAME = config.get("sepoa.context.name");
			if (format == null || "".equals(format)) {
				format = "%Y%m%d";
			}
			
			if (cssClass == null || "".equals(cssClass)) {
				cssClass = "inputsubmit";
			}
			
			/*
			if (default_to == null || "".equals(default_to)) {
				default_to = SepoaDate.getShortDateString();
			}
			
			if (default_from == null || "".equals(default_from)) {
				default_from = SepoaDate.addSepoaDateMonth(default_to,  -3);
			}
			*/
			
			StringBuffer sb = new StringBuffer();
			int size = 8;
			if(id != null && !"".equals(id)) {
				size = (default_value == null ? size : default_value.length());
				sb.append("			<input type='text' name='" + id + "' id='" + id + "' size=" + size + " class='" + cssClass + "' maxlength='8' readonly style='width:80px;'>");	//*동아프로젝트에서는 모든 calendar에 readonly 적용
				sb.append("			<img src='").append(POASRM_CONTEXT_NAME).append("/images/button/butt_calender.gif' id='" + id + "_img' width='19' height='19' align='absmiddle' border='0' alt='' >\n");
				sb.append("<script language='javascript'>    													\n");
				sb.append("    var " + id + "_calendar;			\n");
				sb.append("    function init_" + id + "_Calendar() {											\n");
				sb.append("        " + id + "_calendar = new SepoaDhtmlXCalendarObject(['" + id + "']);				\n");
				sb.append("        " + id + "_calendar.setWeekStartDay(7);                  \n");	//week starts from ? // 1:Monday, 7:Sunday
				sb.append("        " + id + "_calendar.setSkin('dhx_skyblue');				\n");
				sb.append("        " + id + "_calendar.hideTime();						\n");
				sb.append("        " + id + "_calendar.setDateFormat('" + format + "');	\n");
				if(default_value != null && default_value.length() > 0) {
					sb.append("        byId('" + id + "').value = '" + default_value + "';	\n");
				}
				if("true".equals(disabled)) {
					sb.append("        byId('" + id + "').disabled = true;				\n");
				}
				sb.append("    }														\n");
				sb.append("    function byId(id) {										\n");
				sb.append("        return document.getElementById(id);					\n");
				sb.append("    }														\n");
		        sb.append("    byId('" + id + "_img').onclick = function(e){			\n");
		        sb.append("        (e||event).cancelBubble = true;						\n");
		        sb.append("        document.getElementById('"+id+"').click();			\n");
		        sb.append("    };														\n");
				sb.append("$(document).ready(function(){    													\n");
				sb.append("    init_" + id + "_Calendar(); 								\n");
		        sb.append("	});		    												\n");
				sb.append("</script>    												\n");
			} else {
				size = (default_from == null ? size : default_from.length());
				sb.append("			<input type='text' name='" + id_from + "' id='" + id_from + "' size=" + size + " class='" + cssClass + "' maxlength='8' ");
				sb.append("onclick=\"setSens_" + id_from + "_" + id_to + "('" + id_to + "', 'max');\" readonly style='width:80px;'>\n");//*동아프로젝트에서는 모든 calendar에 readonly 적용
				sb.append("			<img src='").append(POASRM_CONTEXT_NAME).append("/images/button/butt_calender.gif' id='" + id_from + "_img' width='19' height='19' align='absmiddle' border='0' alt='' >\n");
				sb.append("			~\n");
				size = (default_to == null ? size : default_to.length());
				sb.append("			<input type='text' name='" + id_to + "' id='" + id_to + "' size=" + size + " class='" + cssClass + "' maxlength='8' ");
				sb.append("onclick=\"setSens_" + id_from + "_" + id_to + "('" + id_from + "', 'min');\" readonly style='width:80px;'>\n");//*동아프로젝트에서는 모든 calendar에 readonly 적용
				sb.append("			<img src='").append(POASRM_CONTEXT_NAME).append("/images/button/butt_calender.gif' id='" + id_to + "_img' width='19' height='19' align='absmiddle' border='0' alt='' >\n");
				sb.append("<script language='javascript'>    													\n");
				sb.append("    var " + id_from + "_" + id_to + "_calendar;			\n");
				sb.append("    function init_" + id_from + "_" + id_to + "_Calendar() {								\n");
				sb.append("        " + id_from + "_" + id_to + "_calendar = new SepoaDhtmlXCalendarObject(['" + id_from + "', '" + id_to + "']);				\n");
				sb.append("        " + id_from + "_" + id_to + "_calendar.setWeekStartDay(7);                  \n");	//week starts from ? // 1:Monday, 7:Sunday
				sb.append("        " + id_from + "_" + id_to + "_calendar.setSkin('dhx_skyblue');				\n");
				sb.append("        " + id_from + "_" + id_to + "_calendar.hideTime();								\n");
				sb.append("        " + id_from + "_" + id_to + "_calendar.setDateFormat('" + format + "');					\n");
				if(default_from != null && default_from.length() > 0) {
					sb.append("        byId('" + id_from + "').value = '" + default_from + "';\n");
				}
				if(default_from != null && default_to.length() > 0) {
					sb.append("        byId('" + id_to + "').value = '" + default_to + "';	\n");
				}
				if("true".equals(disabled)) {
					sb.append("        byId('" + id_from + "').disabled = true;				\n");
					sb.append("        byId('" + id_to + "').disabled = true;				\n");
				}
				sb.append("    }														\n");
				sb.append("    function setSens_" + id_from + "_" + id_to + "(id, k) {								\n");
				sb.append("        if (k == 'min') {									\n");
				sb.append("		   		if(byId('"+id_from+"').value == \"\"){					\n");
				sb.append("					return;											\n");
				sb.append("				}													\n");
				sb.append("            " + id_from + "_" + id_to + "_calendar.setSensitiveRange(byId(id).value, null);\n");
				sb.append("        } else {												\n");
				sb.append("		   		if(byId('"+id_to+"').value == \"\"){				\n");
				sb.append("					return;											\n");
				sb.append("				}													\n");
				sb.append("            " + id_from + "_" + id_to + "_calendar.setSensitiveRange(null, byId(id).value);\n");
				sb.append("        }													\n");
				sb.append("    }														\n");
				sb.append("    function byId(id) {										\n");
				sb.append("        return document.getElementById(id);					\n");
				sb.append("    }														\n");
		        sb.append("    byId('" + id_from+ "_img').onclick = function(e){		\n");
		        sb.append("        (e||event).cancelBubble = true;						\n");
		        sb.append("        document.getElementById('"+id_from+"').click();		\n");
		        sb.append("    };														\n");
		        sb.append("    byId('" + id_to+ "_img').onclick = function(e){			\n");
		        sb.append("        (e||event).cancelBubble = true;						\n");
		        sb.append("        document.getElementById('"+id_to+"').click();		\n");
		        sb.append("    };														\n");
		        sb.append("$(document).ready(function(){    							\n");
		        sb.append("    init_" + id_from + "_" + id_to + "_Calendar(); 			\n");
		        sb.append("}); 			   												\n");
				sb.append("</script>    												\n");
			}

			pageContext.getOut().write(sb.toString());
		} catch (Exception e) {
			
			throw new JspException("IO Error : " + e.getMessage());
		}
		// JSP컨테이너가 jsp의 페이지의 남은 부분 계속 진행
		return EVAL_PAGE;
	}
}
