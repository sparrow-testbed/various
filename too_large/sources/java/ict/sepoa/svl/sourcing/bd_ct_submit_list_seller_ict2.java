/**
 * @파일명   : bd_price_list_seller_ict.java
 * @Location : sepoa.svl.sourcing
 * @생성일자 : 2009. 04. 24
 * @변경이력 :
 * @프로그램 설명 : 구매요청접수( 담당자배정 )
 */

package ict.sepoa.svl.sourcing;
  
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings({"unchecked", "serial"})
public class bd_ct_submit_list_seller_ict2 extends HttpServlet {

	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}

    public void doPost( HttpServletRequest req, HttpServletResponse res ) throws IOException, ServletException {

        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue( req );

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding( "UTF-8" );
        res.setContentType( "text/html;charset=UTF-8" );
        String mode = "";
        PrintWriter out = res.getWriter();

        try {

            gdReq = OperateGridData.parse( req, res );
            mode = JSPUtil.CheckInjection( gdReq.getParam( "mode" ) );


			if ("getBdCt2SubmitList".equals(mode)) {
				gdRes = getBdCt2SubmitList(gdReq , info); 
			}
			else if ("setBDCt2Submit".equals(mode)) {
					gdRes = setBDCt2Submit(gdReq , info); 
			}
			else if ("setBDCt2SubmitCancel".equals(mode)) {
				gdRes = setBDCt2SubmitCancel(gdReq , info); 
			}
            
            
        } catch( Exception e ) {
            gdRes.setMessage( "Error: " + e.getMessage() );
            gdRes.setStatus( "false" );
            
        } finally {
        	try {
        		if("setBDCt2Submit".equals(mode) || "setBDCt2SubmitCancel".equals(mode)){
        			out.print(gdRes.getMessage()+"|"+gdRes.getStatus());
        		}else{
        			OperateGridData.write( req, res, gdRes, out );
        		}
            } catch( Exception e ) {
            	Logger.debug.println();
            }
        }
    }
    
    public GridData getBdCt2SubmitList( GridData gdReq, SepoaInfo info ) throws Exception {
    	
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
    		gdRes.addParam( "mode", "getBdCt2SubmitList" );
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_SBD_012", "CONNECTION", "getBdCt2SubmitList", obj);
    		
    		
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
    				} 
    				else if(grid_col_ary[k] != null && grid_col_ary[k].equals( "ATTACH_NO" ) ) {
                    	
						//if("".equals(wf.getValue("ATTACH_NO", i))){
							//gdRes.addValue(grid_col_ary[k],"");
						//}else{
							gdRes.addValue(grid_col_ary[k],"<img src='/images/icon/icon_search.gif'/> " + wf.getValue("ATTACH_CNT", i));
						//}
						
                    }
    				
    				else {
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
    
    public GridData setBDCt2Submit( GridData gdReq, SepoaInfo info ) throws Exception {
    	
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
    		gdRes.addParam( "mode", "setBDCt2Submit" );
    		
    		headerData.put("bid_no"			, gdReq.getParam("bid_no")); 
    		headerData.put("bid_count"		, gdReq.getParam("bid_count")); 
    		headerData.put("VOTE_COUNT"		, gdReq.getParam("VOTE_COUNT")); 
    		headerData.put("attach_no"		, gdReq.getParam("attach_no")); 
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_SBD_012", "CONNECTION", "setBDCt2Submit", obj);
    		
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
    
public GridData setBDCt2SubmitCancel( GridData gdReq, SepoaInfo info ) throws Exception {
    	
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
    		gdRes.addParam( "mode", "setBDCt2SubmitCancel" );
    		
    		headerData.put("bid_no"			, gdReq.getParam("bid_no")); 
    		headerData.put("bid_count"		, gdReq.getParam("bid_count")); 
    		headerData.put("VOTE_COUNT"		, gdReq.getParam("VOTE_COUNT")); 
    		headerData.put("attach_no"		, gdReq.getParam("attach_no")); 
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_SBD_012", "CONNECTION", "setBDCt2SubmitCancel", obj);
    		
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
