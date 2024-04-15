package ev;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings("serial")
public class ev_vendor_result extends HttpServlet 
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException {
//        System.out.println("evdetail_mst :: Servlet Start");
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        info           = sepoa.fw.ses.SepoaSession.getAllValue(req);
        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode     = "";
        PrintWriter out = res.getWriter();
        try 
        {
            gdReq = OperateGridData.parse(req, res);
            mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
//            System.out.println("mode = " + mode); 
            // WO_203 = 집기류
            // WO_204 = 인쇄물
            // WO_205 = 간판류
            // WO_206 = 사무기기
            // WO_207 = 용도품
            // WO_208 = 시설동산
            // WO_209 = 공사
            // WO_210 = 통장류
            // WO_211 = 카드류
            // WO_212 = 금융IC카드 
            
            if( "WO_203".equals(mode) ){
            	gdRes = ev_query_203(gdReq);
            }
            else if( "WO_204".equals(mode) ){
            	gdRes = ev_query_204(gdReq);
            }
            else if( "WO_205".equals(mode) ){
            	gdRes = ev_query_205(gdReq);
            }
            else if( "WO_206".equals(mode) ){
            	gdRes = ev_query_206(gdReq);
            }
            else if( "WO_207".equals(mode) ){
            	gdRes = ev_query_207(gdReq);
            }
            else if( "WO_208".equals(mode) ){
            	gdRes = ev_query_208(gdReq);
            }
            else if( "WO_209".equals(mode) ){
            	gdRes = ev_query_209(gdReq);
            }
            else if( "WO_210".equals(mode) ){
            	gdRes = ev_query_210(gdReq);
            }
            else if( "WO_211".equals(mode) ){
            	gdRes = ev_query_211(gdReq);
            }
            else if( "WO_212".equals(mode) ){
            	gdRes = ev_query_212(gdReq);
            }            
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
//            e.printStackTrace();
        }
        finally
        {
            try
            {
                OperateGridData.write( req, res, gdRes, out );
            }
            catch (Exception e)
            {
//                e.printStackTrace();
            	Logger.debug.println();
            }
        }
    }
    
    public GridData ev_query_203(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_kind, sg_kind_1, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_203", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }
    
    public GridData ev_query_204(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_kind, sg_kind_1, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_204", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }
    
    public GridData ev_query_205(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_kind, sg_kind_1, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_205", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }

    public GridData ev_query_206(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_kind, sg_kind_1, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_206", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }
    
    public GridData ev_query_207(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_kind, sg_kind_1, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_207", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }
    
    public GridData ev_query_208(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_kind, sg_kind_1, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_208", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }    
    
    public GridData ev_query_209(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_kind, sg_kind_1, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_209", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }
    
    public GridData ev_query_210(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);
        
        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String sg_kind_2   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_2")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            
            Object[] obj   = { sg_kind, sg_kind_1, sg_kind_2, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_210", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }        	
        return gdRes;
    }
    
    public GridData ev_query_211(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);
        
        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String sg_kind_2   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_2")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            
            Object[] obj   = { sg_kind, sg_kind_1, sg_kind_2, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_211", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }        	
        return gdRes;
    }
    
    public GridData ev_query_212(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        ArrayList ht        = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);
        
        try
        {
        	String sg_kind     = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind")).trim();
        	String sg_kind_1   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_1")).trim();
        	String sg_kind_2   = JSPUtil.nullToEmpty(gdReq.getParam("sg_kind_2")).trim();
        	String ev_year     = JSPUtil.nullToEmpty(gdReq.getParam("ev_year")).trim();
            String grid_col_id = JSPUtil.nullToEmpty(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            
            Object[] obj   = { sg_kind, sg_kind_1, sg_kind_2, ev_year };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_203", "CONNECTION", "ev_query_212", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            
            if ( arr_list.size() == 0 ){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }            

            for ( int i = 0; i < arr_list.size(); i++ ) {
            	ht = (ArrayList) arr_list.get(i);	//hashtable형태로
            	for( int k = 0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else{
	                	gdRes.addValue( grid_col_ary[k], (String)ht.get(k-1) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }        	
        return gdRes;
    }    
}
