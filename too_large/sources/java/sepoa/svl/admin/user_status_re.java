package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.raonsecure.touchen.KeyboardSecurity;

import sepoa.fw.msg.*;
import sepoa.fw.srv.*;
import sepoa.fw.util.*;
import sepoa.fw.log.*;
import sepoa.fw.ses.*;
import sepoa.svl.util.SepoaServlet;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings("serial")
public class user_status_re extends SepoaServlet {
    public void init(ServletConfig config) throws ServletException{
    	Logger.debug.println();
    }  
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
        doPost(req, res);
    }
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
        SepoaInfo   info  = null;
        GridData    gdReq = null;
        GridData    gdRes = new GridData();
        String      mode  = null;
        PrintWriter out   = null;
        
        try{
        	req.setCharacterEncoding("UTF-8");
            res.setContentType("text/html;charset=UTF-8");
            
            info  = SepoaSession.getAllValue(req);
            out   = res.getWriter();
        	gdReq = OperateGridData.parse(req, res);
            mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            if ("pwdReset".equals(mode)){
                gdRes = setPwdReset(gdReq , info);
            }           
        }
        catch (Exception e){
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
        }
        finally{
            try{
                OperateGridData.write(req, res, gdRes, out);
            }
            catch (Exception e){
            	Logger.debug.println();
            }
        }
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
    
    private Object[] doDataObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              password   = gdReq.getParam("password");
		String              selUserId  = gdReq.getParam("sel_user_id");
//		String password2 = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(,"password"));
		if(!"".equals(password)){
			password  = CryptoUtil.getSHA256(password);
		}
		resultInfo.put("password",    password);
		resultInfo.put("sel_user_id", selUserId);
		
		result[0] = resultInfo;
		
		return result;
	}
    
    @SuppressWarnings({ "rawtypes"})
    private GridData setPwdReset(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	Map<String, String> map =null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
    		obj      = this.doDataObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "AD_132", "TRANSACTION", "setPwdReset", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = message.get("MESSAGE.0001").toString();
    		}
    		else {
    			gdResMessage = value.message;
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
}