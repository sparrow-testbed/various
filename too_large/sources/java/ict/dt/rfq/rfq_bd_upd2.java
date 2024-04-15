package ict.dt.rfq;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rfq_bd_upd2 extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException{Logger.debug.println();}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
		doPost(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
		
		try{
			
			gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			
			if ("getRfqConfirmDetail".equals(mode)){ //견적요청 상세조회 - 업체선정 조회
				gdRes = getRfqConfirmDetail(gdReq,info);
			}else if ("doConfirm".equals(mode)) {
				gdRes = doConfirm(gdReq , info); 
			} 
	       		
		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
        	gdRes.setStatus("false"); 
        	
        } finally {
        	try {
        		OperateGridData.write(req, res, gdRes, out);
        	} catch (Exception e) {
        		Logger.debug.println();
        	}
        }
		
	
	}

	 public GridData getRfqConfirmDetail( GridData gdReq, SepoaInfo info ) throws Exception {

	        GridData gdRes = new GridData();
	        int rowCount = 0;
	        SepoaFormater wf = null;

	    
	        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );


	        Map< String, String >   allData     = null;
	        Map< String, String >   headerData  = null;
	        
	        String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

	        try {

	            allData     = SepoaDataMapper.getData( info, gdReq );
	            headerData  = MapUtils.getMap( allData, "headerData" );

	            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
	            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
	            gdRes = OperateGridData.cloneResponseGridData( gdReq );
	            gdRes.addParam( "mode", "getRfqConfirmDetail" );
	            
	            Object[] obj = { headerData };
				SepoaOut value = ServiceConnector.doService(info, "I_p1004", "CONNECTION", "getRfqConfirmDetail", obj);
	 
				
				if (value.flag) {
					gdRes.setMessage(message.get("MESSAGE.0001").toString());
					gdRes.setStatus("true");
				} else {
					gdRes.setMessage(value.message);
					gdRes.setStatus("false");
					return gdRes;
				}

				wf = new SepoaFormater(value.result[0]);
				rowCount = wf.getRowCount();
				
				if (rowCount == 0) {
					gdRes.setMessage(message.get("MESSAGE.1001").toString());
					return gdRes;
				}
	 

	            for( int i = 0; i < rowCount; i++ ) {
	                for( int k = 0; k < grid_col_ary.length; k++ ) {
	                    if( grid_col_ary[k] != null && grid_col_ary[k].equals( "SELECTED" ) ) {
	                        gdRes.addValue( "SELECTED", "0" ); 
	                    } else if(grid_col_ary[k] != null && grid_col_ary[k].equals( "ATTACH_NO" ) ) {
	                    	
							if("".equals(wf.getValue("ATTACH_NO", i))){
								gdRes.addValue(grid_col_ary[k],"");
							}else{
								gdRes.addValue(grid_col_ary[k],"<img src='/images/icon/icon_search.gif'/> " + wf.getValue("ATTACH_CNT", i));
							}                    	
	                    } else {
	                        gdRes.addValue( grid_col_ary[k], wf.getValue( grid_col_ary[k], i ) );
	                    }
	                }
	            }
	            
	        } catch (Exception e) {
				
				gdRes.setMessage(message.get("MESSAGE.1002").toString());
				gdRes.setStatus("false");
			}

			return gdRes;
		}
	 
	 	public GridData doConfirm( GridData gdReq, SepoaInfo info ) throws Exception {

	        GridData gdRes = new GridData();
	        int rowCount = 0;
	        SepoaFormater wf = null;

	    
	        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );


	        Map< String, String >   allData     = null;
	        Map< String, String >   headerData  = null;
	        
	        String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

	        try {

	            allData     = SepoaDataMapper.getData( info, gdReq );
	            headerData  = MapUtils.getMap( allData, "headerData" );

	            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
	            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
	            gdRes = OperateGridData.cloneResponseGridData( gdReq );
	            gdRes.setSelectable(false);
	            gdRes.addParam( "mode", "setBdStatus" );
	  
	            Object[] obj = { allData };
				SepoaOut value = ServiceConnector.doService(info, "I_p1004", "TRANSACTION", "doConfirm", obj);
	 
				if( value.flag ) {  
	                gdRes.setMessage( value.message );
	            	gdRes.setStatus( "true" );
	            } else {
	                gdRes.setMessage( value.message );
	                gdRes.setStatus( "false" );
	                return gdRes;
	            }
			} catch (Exception e) {
				
				gdRes.setMessage(message.get("MESSAGE.1002").toString());
				gdRes.setStatus("false");
			}

			return gdRes;
		}
	 
}
