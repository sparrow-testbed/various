package sepoa.fw.util.tag;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.HtmlManipulator;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;

public class Header extends BodyTagSupport {
    private static final long serialVersionUID = 5585108383423684013L;

    private boolean popup = false;

    @SuppressWarnings({ "rawtypes"})
	public int doStartTag() throws JspException {
    	try{
    		HttpServletRequest  request                    = (HttpServletRequest)pageContext.getRequest();
    		HttpSession         session                    = pageContext.getSession();
    		SepoaInfo           info                       = null;
    		SepoaFormater       sf                         = null;
    		HashMap             text                       = null;
    		Map<String, String> leftMenuMap                = new LinkedHashMap<String, String>();
    		StringBuffer        sb1                        = new StringBuffer();
    		String              menuObjectCode             = null;
    		String              orderSeq                   = null;
    		String              moduleType                 = null;
    		String              leftMenu                   = null;
    		String              recentMenuObjectCodeImgurl = null;
    		String              topMenuTagRow              = null;
    		String              menuLink                   = null;
            boolean             isMenuSelect               = this.isMenuSelect();
            int                 i                          = 0;
            int                 rowCount                   = 0;
            
            this.setPopUpFlag();
            
            if(isMenuSelect){
                info     = SepoaSession.getAllValue(request);
                text     = this.getMessageText(info);
                sf       = this.getUserMenu(info);
                rowCount = sf.getRowCount();
                
                for(i = 0; i < rowCount; i++) {
                    menuObjectCode             = sf.getValue("MENU_OBJECT_CODE", i);
                    orderSeq                   = sf.getValue("ORDER_SEQ",        i);
                    moduleType                 = sf.getValue("MODULE_TYPE",      i);
                    menuLink                   = sf.getValue("MENU_LINK",        i);
                    recentMenuObjectCodeImgurl = this.getRecentMenuObjectCodeImgurl(text, moduleType);

                    if((i == 0) || ("1".equals(orderSeq))){
                    	session.setAttribute("RECENT_MENU_OBJECT_CODE",        menuObjectCode);
                    	session.setAttribute("RECENT_MENU_OBJECT_CODE_INDEX",  Integer.toString(i + 1));
                    	session.setAttribute("RECENT_MENU_OBJECT_CODE_IMGURL", recentMenuObjectCodeImgurl);
                    }
                    
                    leftMenu      = this.getLeftMenu(info, menuObjectCode);
                    topMenuTagRow = this.getTopMenuTagRow(moduleType, menuObjectCode, menuLink, text, i);
                    
                    leftMenuMap.put(menuObjectCode, leftMenu);
                    
                    sb1.append(topMenuTagRow);
                    
                    if(i != (rowCount - 1)){
                    	sb1.append("<td style=\"width:1px\"><IMG SRC=\"/images/top/div.gif\" WIDTH=\"1\" HEIGHT=\"11\" BORDER=\"0\" ALT=\"\"></td>");
                    }
                }
                
                session.setAttribute("MENU_TOP",  sb1.toString());
                session.setAttribute("LEFT_MENU", leftMenuMap);
            }

            pageContext.include("/common/header_start.jsp?popup=" + popup);
        }
    	catch (Exception e) {
            throw new JspException("IO Error : " + e.getMessage());
        }

        return EVAL_BODY_INCLUDE;
    }

    public int doAfterBody() throws JspException {
    	return EVAL_BODY_INCLUDE;
    }

    public int doEndTag() throws JspException {
        try {
            pageContext.include("/common/header_end.jsp");

        }
        catch (Exception e) {
            throw new JspException("IO Error : " + e.getMessage());
        }
        
        return EVAL_PAGE;
    }
    
    private void setPopUpFlag(){
    	HttpServletRequest request                = (HttpServletRequest)pageContext.getRequest();
    	String             popupFlagHeader        = null;
    	boolean            popupFlagHeaderBoolean = false;
    	
    	try{
    		popupFlagHeader = request.getParameter("popup_flag_header");
    		popupFlagHeader = JSPUtil.paramCheck(popupFlagHeader);
    		
    		if("".equals(popupFlagHeader) == false){
    			popupFlagHeaderBoolean = Boolean.parseBoolean(popupFlagHeader);
    			
    			this.setPopup(popupFlagHeaderBoolean);
    		}
    	}
    	catch(Exception e){
    		this.setPopup(false);
    	}
    }
    
    private boolean isMenuSelect(){
    	HttpSession session         = pageContext.getSession();
    	Object      menuTopSession  = session.getAttribute("MENU_TOP");
        Object      leftMenuSession = session.getAttribute("LEFT_MENU");
        String      loginId         = (String)session.getAttribute("ID");
    	boolean     result          = false;
    	
    	if((menuTopSession == null) && ("IF".equals(loginId))){
        	menuTopSession  = new Object();
        	leftMenuSession = new Object();
        }
        
        if(((menuTopSession == null) || (leftMenuSession == null)) && (loginId != null)){
        	result = true;
        }
        
        return result;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessageText(SepoaInfo info) throws Exception{
    	Vector  multilangId = new Vector();
    	HashMap result      = null;
    	
    	multilangId.addElement("CO_005");
        
    	result = MessageUtil.getMessage(info, multilangId);
    	
    	return result;
    }
    
    private SepoaFormater getUserMenu(SepoaInfo info) throws Exception{
    	Object[]      obj   = { info };
        SepoaOut      value = ServiceConnector.doService(info, "CO_005", "CONNECTION", "getUserMenu", obj);
        SepoaFormater sf    = new SepoaFormater(value.result[0]);
        
        return sf;
    }
    
    @SuppressWarnings("rawtypes")
	private String getRecentMenuObjectCodeImgurl(HashMap text, String moduleType){
    	String       result       = null;
    	StringBuffer stringBuffer = new StringBuffer();
    	
    	stringBuffer.append("CO_005.");
    	stringBuffer.append(moduleType);
    	stringBuffer.append("_1");
    	
    	result = stringBuffer.toString();
    	result = (String)text.get(result);
    	
    	return result;
    }

    private String getLeftMenu(SepoaInfo info, String menuObjectCode) throws Exception {
    	Object[]                            obj2         = {info, menuObjectCode};
        SepoaOut                            value        = ServiceConnector.doService(info, "CO_005", "CONNECTION", "getUserMenuTree", obj2);
        SepoaFormater                       sf           = new SepoaFormater(value.result[0]);
        LinkedHashMap<String, MenuDocument> rootFolder   = new LinkedHashMap<String, MenuDocument>();
        LinkedHashMap<String, MenuDocument> folderList   = new LinkedHashMap<String, MenuDocument>();
        int                                 tree_file_id = 0;
        
        for (int j = 0; j < sf.getRowCount(); j++) {
            String menu_field_code        = sf.getValue("MENU_FIELD_CODE", j);
            String menu_parent_field_code = sf.getValue("MENU_PARENT_FIELD_CODE", j);
            String child_flag             = sf.getValue("CHILD_FLAG", j);
            String menu_name              = HtmlManipulator.quoteHtml(sf.getValue("MENU_NAME", j));
            String menu_link              = sf.getValue("MENU_LINK", j) == null ? "" : sf.getValue("MENU_LINK", j);

            if (menu_parent_field_code.equals("*")) {
                MenuFolder f = new MenuFolder(menu_field_code, menu_name);
                
                rootFolder.put(menu_field_code, f);
                folderList.put(menu_field_code, f);
            }
            else{
            	if(child_flag.equals("Y")){
                    MenuFolder parent = (MenuFolder) folderList.get(menu_parent_field_code);

                    if(parent != null){
                        MenuFolder folder = new MenuFolder(menu_field_code, menu_name);
                        
                        parent.addDocument(menu_field_code, folder);
                        folderList.put(menu_field_code, folder);
                    }
                    else{
                        MenuFolder f = new MenuFolder(menu_field_code, menu_name);
                        
                        rootFolder.put(menu_field_code, f);
                        folderList.put(menu_field_code, f);
                    }
                }
            	else{
                    MenuFolder parent = (MenuFolder) folderList.get(menu_parent_field_code);
                    
                    if(parent != null){
                        parent.addDocument(tree_file_id++ + "", new MenuFile(menu_field_code, menu_name, menu_link));
                    }
                }
            }
        }

        StringBuffer sb = new StringBuffer();
        
        sb.append("<tree id='0'>");

        Iterator<Map.Entry<String, MenuDocument>> iter = rootFolder.entrySet().iterator();
        
        int i = 0;
        
        while (iter.hasNext()) {
            Map.Entry<String, MenuDocument> entry = (Map.Entry<String, MenuDocument>) iter.next();
            MenuFolder                      f     = (MenuFolder) entry.getValue();
            
            sb.append("<item text='").append(f.name).append("' id='").append(f.code).append("' open='1'");
            
            if(i == 0){
                sb.append(" call='1' select='1'");
            }
            
            sb.append(">");
            sb.append(new MenuDocument().getList(f));
            sb.append("</item>");
            
            i++;
        }

        sb.append("</tree>");
        
        return sb.toString();
    }
    
    @SuppressWarnings("rawtypes")
	private String getTopMenuTagRow(String type, String code, String link, HashMap text, int index){
    	StringBuffer topMenuString = new StringBuffer();
    	int          tagIndex      = index + 1;
    	
    	if("".equals(code) == false){
    		topMenuString.append("<td height=\"32\">");
    		topMenuString.append(	"<img ");
    		topMenuString.append(		"src=\"/images/button/").append(type).append(".gif\" ");
    		topMenuString.append(		"tabindex=").append(tagIndex).append(" ");
    		topMenuString.append(		"id='topMenuId").append(tagIndex).append("' ");
    		topMenuString.append(		"onclick=\"javascript:topMenuClick('").append(link).append("', '").append(code).append("', '").append(tagIndex).append("', '');\" ");
    		topMenuString.append(		"onMouseOver=\"javascript:topMenuMouseOver('").append(tagIndex).append("');\" ");
    		topMenuString.append(		"onMouseOut=\"javascript:topMenuMouseOut('").append(tagIndex).append("');\" ");
    		topMenuString.append(		"onFocus=\"javascript:this.blur();\" ");
    		topMenuString.append(		"style=\"cursor:hand\" ");
    		topMenuString.append(	">");
    		topMenuString.append("</td> ");    		
    	}
    	
    	return topMenuString.toString();
    }

    public boolean getPopup() {
        return popup;
    }

    public void setPopup(boolean popup) {
        this.popup = popup;
    }
}