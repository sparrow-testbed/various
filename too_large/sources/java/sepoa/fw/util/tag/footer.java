package sepoa.fw.util.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

public class Footer extends BodyTagSupport {

    private static final long serialVersionUID = 4307545287550492533L;
    
    private boolean auto_resize = true;

    /**
     * TagSupport override
     */
    public int doStartTag() throws JspException {
        Config olConfxxxx = null;
        int rtn = 0;
        try {
            olConfxxxx = new Configuration();
        } catch (ConfigurationException e1) {
        	rtn = -1;
        }
        //String POASRM_CONTEXT_NAME = olConfxxxx.getString("sepoa.context.name");
        

        try {
        	if(auto_resize) {
        		pageContext.include("/common/footer.jsp");
        	} else {
        		pageContext.include("/common/footer_not_resize.jsp");
        	}
        } catch (Exception e) {
            
            throw new JspException("IO Error : " + e.getMessage());
        }
        // JSP컨테이너가 jsp의 페이지의 남은 부분 계속 진행
        return EVAL_PAGE;
    }

    public int doAfterBody() throws JspException {
        BodyContent bc = getBodyContent();
        
        return EVAL_BODY_INCLUDE;
    }

    public int doEndTag() throws JspException {
        // JSP컨테이너가 jsp의 페이지의 남은 부분 계속 진행
        return EVAL_PAGE;
    }

	public boolean isAuto_resize() {
		return auto_resize;
	}

	public void setAuto_resize(boolean auto_resize) {
		this.auto_resize = auto_resize;
	}
    
}
