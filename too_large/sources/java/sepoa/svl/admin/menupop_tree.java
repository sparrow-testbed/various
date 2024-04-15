package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.tree.Node;
import sepoa.fw.util.tree.ObjectFactory;
import sepoa.fw.util.tree.Tree;
import sepoa.fw.util.tree.UserData;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class Menupop_tree extends HttpServlet {

    private static final long serialVersionUID = 1502537807560105153L;

    final public static String HREF = "href";
    final public static String USE_FLAG = "useflag";
    final public static String SCREEN_ID = "screenid";
    final public static String CHILD_FLAG = "childflag";
    final public static String MENU_NAME = "menuname";
    final public static String MENU_FIELD_CODE = "menufieldcode";
    final public static String MENU_PARENT_FIELD_CODE = "menuparentfieldcode";
    final public static String ORDER_SEQ = "orderseq";
    
    final public static String FLAG_TRUE = "1";

    public void init(ServletConfig config) throws ServletException {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {

        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        // String mode = "";
        PrintWriter out = res.getWriter();
        
        Tree tree = null;
        try {
            gdReq = OperateGridData.parse(req, res);
            // String status = JSPUtil.CheckInjection(gdReq.getParam("status"));

            // status에 따라 CRUD를 작성하려 하였으나 
            // 서비스측에서 이를 분류하여 작업하고 있다..
            // 여기서 할 일은 특별히 없다.
            
            tree = createTreeXml(info, gdReq, gdRes);
        } catch (Exception e) {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
            
        } finally {
            try {
                res.setCharacterEncoding("UTF-8");
                res.setContentType("text/xml;charset=UTF-8");

                // create JAXB context and instantiate marshaller
                JAXBContext context = JAXBContext.newInstance(Tree.class);
                Marshaller m = context.createMarshaller();
                m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
                m.marshal(tree, System.out);
                // Write to OutputStream.
                m.marshal(tree, out);

            } catch (Throwable e) {
            	Logger.debug.println();
            }
        }
    }

    /**
     * Tree의 구성
     * 
     * @param info
     * @param gdReq
     * @param gdRes
     * @return
     */
    public Tree createTreeXml(SepoaInfo info, GridData gdReq, GridData gdRes) {

        ObjectFactory of = new ObjectFactory();

        Tree tree = of.createTree();
        tree.setId("0");

        Map<String, Node> map = new HashMap<String, Node>();
        try {

            String menu_object_code = JSPUtil.paramCheck(gdReq.getParam("menu_object_code"));
            String menu_field_code = JSPUtil.paramCheck(gdReq.getParam("menu_field_code"));
            String menu_parent_field_code = JSPUtil.paramCheck(gdReq.getParam("menu_parent_field_code"));
            String menu_name = JSPUtil.paramCheck(gdReq.getParam("menu_name"));
            String screen_id = JSPUtil.paramCheck(gdReq.getParam("screen_id"));
            String menu_link_flag = JSPUtil.paramCheck(gdReq.getParam("menu_link_flag"));
            String child_flag = JSPUtil.paramCheck(gdReq.getParam("child_flag"));
            String order_seq = JSPUtil.paramCheck(gdReq.getParam("order_seq"));
            String use_flag = JSPUtil.paramCheck(gdReq.getParam("use_flag"));
            String status = JSPUtil.paramCheck(gdReq.getParam("status"));
            if (status == null || "".equals(status)){
                status = "B";
            }
            String sub_flag = JSPUtil.paramCheck(gdReq.getParam("sub_flag"));
            String folder_flag = JSPUtil.paramCheck(gdReq.getParam("folder_flag"));

            String menu_link = null;

            Object[] obj = { info, menu_object_code, menu_field_code, menu_parent_field_code, menu_name, screen_id, menu_link_flag, child_flag, order_seq, use_flag, status, sub_flag, folder_flag, "S" };

            SepoaOut so = ServiceConnector.doService(info, "AD_031", "CONNECTION", "expandTree", obj);
            SepoaFormater sf = new SepoaFormater(so.result[0]);
            for (int i = 0; i < sf.getRowCount(); i++) {
                menu_object_code = sf.getValue("MENU_OBJECT_CODE", i);
                menu_field_code = sf.getValue("MENU_FIELD_CODE", i);
                menu_parent_field_code = sf.getValue("MENU_PARENT_FIELD_CODE", i);
                menu_name = sf.getValue("MENU_NAME", i);
                screen_id = sf.getValue("SCREEN_ID", i);
                if(screen_id == null) {
                    screen_id = "";
                }
                menu_link_flag = sf.getValue("MENU_LINK_FLAG", i);
                child_flag = sf.getValue("CHILD_FLAG", i);
                order_seq = sf.getValue("ORDER_SEQ", i);
                use_flag = sf.getValue("USE_FLAG", i);
                menu_link = sf.getValue("MENU_LINK", i);

                status = null;
                sub_flag = null;
                folder_flag = null;

                Node item = of.createNode();
                item.setId(menu_field_code);
                item.setText(menu_name);
                
                if("N".equals(use_flag)) {
                    item.setLocked(FLAG_TRUE);
                }

                UserData ut = of.createUserData();
                ut.setName(USE_FLAG);
                ut.setValue(use_flag);
                item.getUserdata().add(ut);
                
                ut = of.createUserData();
                ut.setName(SCREEN_ID);
                ut.setValue(screen_id);
                item.getUserdata().add(ut);

                ut = of.createUserData();
                ut.setName(MENU_NAME);
                ut.setValue(menu_name);
                item.getUserdata().add(ut);

                ut = of.createUserData();
                ut.setName(CHILD_FLAG);
                ut.setValue(child_flag);
                item.getUserdata().add(ut);

                ut = of.createUserData();
                ut.setName(MENU_FIELD_CODE);
                ut.setValue(menu_field_code);
                item.getUserdata().add(ut);

                ut = of.createUserData();
                ut.setName(MENU_PARENT_FIELD_CODE);
                ut.setValue(menu_parent_field_code);
                item.getUserdata().add(ut);

                ut = of.createUserData();
                ut.setName(ORDER_SEQ);
                ut.setValue(order_seq);
                item.getUserdata().add(ut);

                if ("*".equals(menu_parent_field_code)) {
                    item.setCall(FLAG_TRUE);
                    item.setOpen(FLAG_TRUE);
                    item.setSelect(FLAG_TRUE);

                    tree.getItem().add(item);
                } else {
                    if ("Y".equals(child_flag)) {
                        item.setOpen(FLAG_TRUE);
                    } else {
                        ut = of.createUserData();
                        ut.setName(HREF);
                        ut.setValue(menu_link);
                        item.getUserdata().add(ut);
                    }

                    Node parentItem = map.get(menu_parent_field_code);
                    if (parentItem == null) {
                        // Parent 노드가 없단 건데..
                        // 정상적이라면 Parent노드가 먼저 읽혀들여질 것이므로 이런 경우는 없다.
                        // 다만 이쪽이 워낙 비정상적인게 많은 곳인지라... 굳이 이 문제를 해결하고자 한다면
                        // SQL을 수정하여 Parent부터 읽어들이게 하던지 이 루프를 한번 더 돌리자.
                        continue;
                    }
                    parentItem.getItem().add(item);
                }
                map.put(menu_field_code, item);

            }

        } catch (Exception e) {
            
            throw new RuntimeException("Error is occured.", e);
        }
        
        return tree;
    }
}
