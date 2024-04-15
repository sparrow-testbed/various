package sepoa.svl.procure;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
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
import xlib.cmc.OperateTreeData;
import xlib.cmc.TreeData;

public class sg_insert extends HttpServlet {

    public void init(ServletConfig config) throws ServletException {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res)throws IOException, ServletException {
		doPost(req, res);
	}

    public void doPost(HttpServletRequest req, HttpServletResponse res)
	        throws IOException, ServletException {

		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
	

        PrintWriter out = res.getWriter();
		TreeData tdReq = null;
		TreeData tdRes = null;
		try {
			tdReq = OperateTreeData.parse(req, res);
			String mode = tdReq.getParam("mode");
			//System.out.println("mode   ====  " + mode);
			if("doSave".equals(mode)) {
				tdRes = setNodeInsert(info, tdReq);
			}else if("doUpdate".equals(mode)){
				tdRes = setNodeUpdate(info, tdReq);
			}else if("doDelete".equals(mode)){
				tdRes = setNodeDelete(info, tdReq);
			}/*else if("deptQuery".equals(mode)){
				//tdRes = deptQuery(info, tdReq);
			}*/else {
				tdRes = getExpandTreeList(info, tdReq);
			}
		} catch (Exception e) {
			Logger.debug.println();
		} finally {			
			OperateTreeData.write(tdRes);		
		}
	}

    private TreeData getExpandTreeList(SepoaInfo info, TreeData tdReq) throws Exception{
		
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);

		TreeData tdRes = OperateTreeData.cloneResponseTreeData(tdReq);
		
		try {
			Node root = tdRes.getRootNode();
			Map<String, String> userData = null;
			Map<String, Node> cacheMap = new HashMap<String, Node>();
			Map<String, Node> cacheMapTmp = new HashMap<String, Node>();
			
			Object[] obj = {};
			SepoaOut value = ServiceConnector.doService(info, "SR_001", "CONNECTION", "getExpandTreeList", obj);
//			SepoaOut value = ServiceConnector.doService(info, "SR_001", "CONNECTION", "ExpandTree", obj);
			
			
			if(value.flag) {
			    tdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			    tdRes.setStatus("true");
			} else {
				tdRes.setMessage(value.message);
				tdRes.setStatus("false");
			    return tdRes;
			}
			
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			
			if (wf.getRowCount() == 0) {
			    tdRes.setMessage(message.get("MESSAGE.1001").toString()); 
			    return tdRes;
			}
			
			String curLevel = "0";
			for (int i = 0; i-1 < wf.getRowCount(); i++) {
				userData = new HashMap<String, String>();
				String sgRefitem = "";
				String parentSgRefitem = "";
				String levelCount = "";
				Node node1 = null;
				if(i==0){
					String SG_NAME="소싱그룹";
					sgRefitem = "0";
					parentSgRefitem = null;
					levelCount = "0";
					userData.put("sg_refitem","0");
					userData.put("sg_name","소싱그룹");
					userData.put("is_leaf","Y");
					userData.put("is_use","Y");
					userData.put("parent_sg_refitem", parentSgRefitem);
					userData.put("level_count",levelCount );
					node1 = tdRes.createNode(SG_NAME, userData);
					node1.setOpen("1");
				}else{
					sgRefitem = wf.getValue("SG_REFITEM",i-1);
					parentSgRefitem = wf.getValue("PARENT_SG_REFITEM",i-1);
					levelCount = wf.getValue("LEVEL_COUNT",i-1);
					//userData.put("house_code", wf.getValue("HOUSE_CODE",i));
					//userData.put("company_code", wf.getValue("COMPANY_CODE",i));
					userData.put("sg_refitem",wf.getValue("SG_REFITEM",i-1));
					userData.put("sg_name",wf.getValue("SG_NAME",i-1) );
					//userData.put("account_code",wf.getValue("ACCOUNT_CODE",i) );
					//userData.put("internalorder_code",wf.getValue("INTERNALORDER_CODE",i) );
					userData.put("is_leaf",wf.getValue("IS_LEAF",i-1) );
					userData.put("is_use",wf.getValue("IS_USE",i-1) );
					userData.put("parent_sg_refitem", parentSgRefitem);
					userData.put("level_count",levelCount );
					node1 = tdRes.createNode(wf.getValue("SG_NAME",i-1), userData);
					node1.setOpen("1");
				}
				
				
				if(!curLevel.equals(levelCount)) {
					curLevel = levelCount;
					cacheMap = cacheMapTmp;
					cacheMapTmp = new HashMap<String, Node>();
				}
				cacheMapTmp.put(sgRefitem, node1);
				Node parentNode = cacheMap.get(parentSgRefitem);
				
				if(parentNode == null) {
					tdRes.add(root, node1);
				} else {
					tdRes.add(parentNode, node1);
				}
			}
			
			
		} catch (Exception e) {
			
			throw new RuntimeException("Error is occured.", e);
		}
		return tdRes;
	}
    
    private TreeData setNodeInsert(SepoaInfo info, TreeData tdReq) throws Exception {
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message = MessageUtil.getMessage(info, multilang_id);

		TreeData tdRes = OperateTreeData.cloneResponseTreeData(tdReq);
		try {
			
			Map<String, String> data = new HashMap<String, String>();
			
			Node node = tdReq.getNode();
			String text = node.getText(); //category_name
			boolean flag=false;
			
			
			
			if(node.getDepth()>=5){
				tdRes.addUserData("sg_refitem", "");
				tdRes.addUserData("level_count", "");
				tdRes.addUserData("flag", "false_1");
				return tdRes;
			}else if(node.getDepth()<=1){
				tdRes.addUserData("sg_refitem", "");
				tdRes.addUserData("level_count", "");
				tdRes.addUserData("flag", "false_2");
				return tdRes;
			}
			
			List<UserData> userDataList = node.getUserdata();
			for(UserData ud : userDataList) {
				
			}
			Node parentNode = node.getParentNode();
			
			
			userDataList = parentNode.getUserdata();
			
			for(UserData ud : userDataList) {
				data.put(ud.getName(), ud.getValue());
				
				
			}

			
			String depth =Integer.toString(node.getDepth()-1);
			data.put("sg_name", node.getText());
			data.put("level_count",depth);
			
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "SR_001", "TRANSACTION", "setNodeInsert", obj);
			
			if(value.flag) {
				tdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				tdRes.setStatus("true");
			} else {
				tdRes.setMessage(value.message);
				tdRes.setStatus("false");
			}
			tdRes.addUserData("sg_refitem", value.result[0]);
			tdRes.addUserData("level_count", value.result[1]);
			tdRes.addUserData("flag", "true");
			//tdRes.addUserData("account_code", value.result[0]);
			//tdRes.addUserData("house_code", value.result[0]);

		} catch (Exception e) {
			tdRes.setStatus("false");
			tdRes.setMessage(e.getMessage());
		}
		
		return tdRes;
	}
    
    private TreeData setNodeUpdate(SepoaInfo info, TreeData tdReq) throws Exception {
		Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message = MessageUtil.getMessage(info, multilang_id);

		TreeData tdRes = OperateTreeData.cloneResponseTreeData(tdReq);
		try {
			
			Map<String, String> data = new HashMap<String, String>();
			
			Node node = tdReq.getNode();
			String text = node.getText(); //category_name
			
			//System.out.println("node_text : " + text);
			//System.out.println("node_depth : " + node.getDepth());	//category_level
			List<UserData> userDataList = node.getUserdata();
			for(UserData ud : userDataList) {
				data.put(ud.getName(), ud.getValue());
				
			}
			data.put("category_name", node.getText());
			
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "SR_001", "TRANSACTION", "setNodeUpdate", obj);
			if(value.flag) {
				tdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				tdRes.setStatus("true");
			} else {
				tdRes.setMessage(value.message);
				tdRes.setStatus("false");
			}
			tdRes.addUserData("sg_refitem", value.result[0]);
			tdRes.addUserData("level_count", value.result[1]);
			tdRes.addUserData("flag", "true");
		} catch (Exception e) {
			tdRes.setStatus("false");
			tdRes.setMessage(e.getMessage());
		}
		
		return tdRes;
	}
    
    private TreeData setNodeDelete(SepoaInfo info, TreeData tdReq) throws Exception {
		Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message = MessageUtil.getMessage(info, multilang_id);

		TreeData tdRes = OperateTreeData.cloneResponseTreeData(tdReq);
		int cnt = 0 ;
		try {
	
			Map<String, String> data = new HashMap<String, String>();
			List<Map<String, String>> dataList = null;
			Node node = tdReq.getNode();
			
			List<Node> child = node.getChildNodes();
			
			List<UserData> userDataList = node.getUserdata();
			for(UserData ud : userDataList) {
				data.put(ud.getName(), ud.getValue());
				
			}
			dataList = new ArrayList<Map<String,String>>();	
			dataList.add(data);
			
			
			for(Node no : child){
					data = new HashMap<String, String>();
					List<UserData> nodeUserDataList = no.getUserdata();
				for(UserData ud : nodeUserDataList) {
					data.put(ud.getName(), ud.getValue());
									
				}
				dataList.add(data);
				
			}
		
			Object[] obj = {dataList};
			SepoaOut value = ServiceConnector.doService(info, "SR_001", "TRANSACTION", "setNodeDelete", obj);
			
			if(value.flag) {
				tdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				tdRes.setStatus("true");
			} else {
				tdRes.setMessage(value.message);
				tdRes.setStatus("false");
			}
			tdRes.addUserData("sg_refitem", "");
			tdRes.addUserData("level_count", "");
			tdRes.addUserData("flag", "true");
		} catch (Exception e) {
			tdRes.setStatus("false");
			tdRes.setMessage(e.getMessage());
		}
		
		return tdRes;
	}
    
}
