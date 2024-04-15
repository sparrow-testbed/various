package sepoa.fw.util.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;

public class Button extends BodyTagSupport {

	private static final long serialVersionUID = -2525051170769672910L;

	private String disabled = null;

	private String onClick = null;

	private String text = null;

	public void setDisabled(String disabled) {
		this.disabled = disabled;
	}

	public void setOnClick(String onClick) {
		this.onClick = onClick;
	}

	public void setText(Object text) {
		this.text = String.valueOf(text);
	}

	/**
	 * TagSupport override
	 */
	public int doStartTag() throws JspException {
		return EVAL_BODY_BUFFERED;
	}

	public int doAfterBody() throws JspException {
//		BodyContent bc = getBodyContent();
//		System.out.println(bc);
		return EVAL_BODY_INCLUDE;
	}

	public int doEndTag() throws JspException {
		try {

			String buttonId = "jQueryButton_" + System.nanoTime();

			StringBuffer sb = new StringBuffer();
			if (disabled != null && "true".equals(disabled)
					&& "disabled".equals(disabled)) {
				sb.append("<a class='btn_big' href='#' disabled><span>" + text
						+ "</span></a>");
			} else {
				sb.append("<a class='btn_big' href='#' id='" + buttonId
						+ "' name='" + buttonId + "' style='cursor:pointer;cursor:hand;'><span>" + text
						+ "</span></a>");
				sb.append("<script type='text/javascript'> $(document).ready(function(){ $('#"
						+ buttonId + "').click(function(){ ");
//				sb.append("if(btnValidate()){ ");
				sb.append(onClick + ";");
//				sb.append("}");
				sb.append(" }); }); </script>");
			}

			pageContext.getOut().write(sb.toString());
		} catch (Exception e) {
			
			throw new JspException("IO Error : " + e.getMessage());
		}
		// JSP컨테이너가 jsp의 페이지의 남은 부분 계속 진행
		return EVAL_PAGE;
	}
}
