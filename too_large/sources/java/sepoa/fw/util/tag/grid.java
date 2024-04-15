package sepoa.fw.util.tag;

import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

public class Grid extends BodyTagSupport {

    private static final long serialVersionUID = 7888539391923883902L;

    private String screen_id = null;
    private String grid_obj = "GridObj";
    private String grid_box = "gridbox";
    private String height = null;
    private int grid_cnt = 1;

    private boolean select_screen = false;
    private boolean row_mergeable = false;

    //private String POASRM_CONTEXT_NAME = "";

    public Grid() {
        Config olConfxxxx = null;
        int rtn = 0;
        try {
            olConfxxxx = new Configuration();
        } catch (ConfigurationException e1) {
        	rtn = -1;
        }        
        //POASRM_CONTEXT_NAME = olConfxxxx.getString("sepoa.context.name");
    }

    /**
     * TagSupport override
     */
    public int doStartTag() throws JspException {
        try {
            ServletRequest request = pageContext.getRequest();

            request.setAttribute("SCREEN_ID", screen_id);
            request.setAttribute("GRID_OBJ", grid_obj);
            request.setAttribute("GRID_BOX", grid_box);
            request.setAttribute("GRID_CNT", grid_cnt);
            request.setAttribute("SELECT_SCREEN", select_screen);
            request.setAttribute("ROW_MERGEABLE", row_mergeable);
            
            StringBuffer sb = new StringBuffer();

            if (grid_cnt == 1) {
                pageContext.include("/include/sepoa_grid_common_tag.jsp");
            } else {
                pageContext.include("/include/sepoa_multi_grid_common_tag.jsp");
            }
            
            sb.append("<div style='padding-top:10px;'><div id='" + grid_box + "'");
            if (height != null) {
                sb.append(" height='" + height + "'");
            }
            sb.append(" name='" + grid_box + "'");
            sb.append(" width='100%' style='background-color:white;'></div></div>");
            
            
//            sb.append("<script>");
//            sb.append("($('#" + grid_box + "').size());");
//            sb.append("if($('#" + grid_box + "').size() == 0) {");
//            sb.append("  alert('create');");
//            sb.append("  document.write(\"<div id='" + grid_box + "'");
//            if (height != null) {
//                sb.append(" height='" + height + "'");
//            }
//            sb.append(" name='" + grid_box + "'");
//            sb.append(" width='100%' style='background-color:white;'></div>");
//            sb.append(" \");");
//            sb.append(" }");
//            sb.append("</script>");

            pageContext.getOut().write(sb.toString());
        } catch (Exception e) {
            
            throw new JspException("IO Error : " + e.getMessage());
        }

        return EVAL_BODY_INCLUDE;
    }

    public int doAfterBody() throws JspException {
        return EVAL_BODY_INCLUDE;
    }

    public int doEndTag() throws JspException {
        // JSP컨테이너가 jsp의 페이지의 남은 부분 계속 진행
        return EVAL_PAGE;
    }

    public String getScreen_id() {
        return screen_id;
    }

    public void setScreen_id(String screen_id) {
        this.screen_id = screen_id;
    }

    public String getGrid_obj() {
        return grid_obj;
    }

    public void setGrid_obj(String grid_obj) {
        this.grid_obj = grid_obj;
    }

    public String getGrid_box() {
        return grid_box;
    }

    public void setGrid_box(String grid_box) {
        this.grid_box = grid_box;
    }

    public int getGrid_cnt() {
        return grid_cnt;
    }

    public void setGrid_cnt(int grid_cnt) {
        this.grid_cnt = grid_cnt;
    }

    public boolean getSelect_screen() {
        return select_screen;
    }

    public void setSelect_screen(boolean select_screen) {
        this.select_screen = select_screen;
    }

    public boolean getRow_mergeable() {
        return row_mergeable;
    }

    public void setRow_mergeable(boolean row_mergeagle) {
        this.row_mergeable = row_mergeagle;
    }

    public String getHeight() {
        return height;
    }

    public void setHeight(String height) {
        this.height = height;
    }

}
