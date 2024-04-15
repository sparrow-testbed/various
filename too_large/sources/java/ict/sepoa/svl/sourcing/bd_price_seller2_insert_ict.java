/**
 * @파일명   : bd_progress_list_seller.java
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
public class bd_price_seller2_insert_ict extends HttpServlet {

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


			if ("getBdItemDetail".equals(mode)) {
				gdRes = getBdItemDetail(gdReq , info); 
			}else if ("setBDAPinsert".equals(mode)) {
				gdRes = setBDAPinsert(gdReq , info); 
			}else if ("setBDAPjoin".equals(mode)) {
				gdRes = setBDAPjoin(gdReq , info); 
			}else if ("setBDAPjoin2".equals(mode)) {
				gdRes = setBDAPjoin2(gdReq , info); 
			}else if ("getRankQuery".equals(mode)){
				gdRes = getRankQuery(gdReq , info); 
			}else if ("getHistoryQuery".equals(mode)){
				gdRes = getHistoryQuery(gdReq , info); 
			}
        } catch( Exception e ) {
            gdRes.setMessage( "Error: " + e.getMessage() );
            gdRes.setStatus( "false" );
            
        } finally {
            try {
        		if("setBDAPjoin".equals(mode) || "setBDAPjoin2".equals(mode)){
        			out.print(gdRes.getMessage()+"|"+gdRes.getStatus());
        		}else{
        			OperateGridData.write( req, res, gdRes, out );
        		}
            } catch( Exception e ) {
            	Logger.debug.println();
            }
        }
    }


    public GridData getBdItemDetail( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "getBdItemDetail" );
             
            Object[] obj = { headerData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_002", "CONNECTION", "getBdItemDetail", obj);
 
			
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

    /* ICT 사용 : 입찰제출 : 투찰 */
    public GridData setBDAPinsert( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "setBDAPinsert" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "I_SBD_004", "TRANSACTION", "setBDAPinsert", obj);
 
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
    
    public GridData setBDAPjoin( GridData gdReq, SepoaInfo info ) throws Exception {
    	
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
    		gdRes.addParam( "mode", "setBDAPinsert" );
    		
    		headerData.put("ann_no"			, gdReq.getParam("ann_no")); 
    		headerData.put("ann_count"		, gdReq.getParam("ann_count")); 
    		headerData.put("BID_AMT"		, gdReq.getParam("BID_AMT").replaceAll("\\,", "")); 
    		headerData.put("attach_no"		, gdReq.getParam("attach_no")); 
    		headerData.put("USER_NAME"		, gdReq.getParam("USER_NAME")); 
    		headerData.put("USER_PHONE"		, gdReq.getParam("USER_PHONE")); 
    		headerData.put("USER_MOBILE"	, gdReq.getParam("USER_MOBILE")); 
    		headerData.put("USER_EMAIL"		, gdReq.getParam("USER_EMAIL")); 
    		headerData.put("USER_POSITION"	, gdReq.getParam("USER_POSITION")); 
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_SBD_009", "CONNECTION", "setBDAPjoin", obj);
    		
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
    
    public GridData setBDAPjoin2( GridData gdReq, SepoaInfo info ) throws Exception {
    	
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
    		gdRes.addParam( "mode", "setBDAPinsert" );
    		
    		headerData.put("bid_no"			, gdReq.getParam("bid_no")); 
    		headerData.put("bid_count"		, gdReq.getParam("bid_count")); 
    		headerData.put("VOTE_COUNT"		, gdReq.getParam("VOTE_COUNT")); 
    		headerData.put("BID_AMT"		, gdReq.getParam("BID_AMT").replaceAll("\\,", "")); 
    		headerData.put("attach_no"		, gdReq.getParam("attach_no")); 
    		headerData.put("USER_NAME"		, gdReq.getParam("USER_NAME")); 
    		headerData.put("COMPANY_CODE"	, gdReq.getParam("VENDOR_CODE")); 
    		headerData.put("USER_PHONE"		, gdReq.getParam("USER_PHONE")); 
    		headerData.put("USER_MOBILE"	, gdReq.getParam("USER_MOBILE")); 
    		headerData.put("USER_EMAIL"		, gdReq.getParam("USER_EMAIL")); 
    		headerData.put("USER_POSITION"	, gdReq.getParam("USER_POSITION")); 
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_SBD_004", "CONNECTION", "setBDAPjoin2", obj);
    		
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
    
    
    
    
    /* ICT 사용 */
    public GridData getRankQuery( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "getBdItemDetail" );
             
            Object[] obj = { headerData };
			SepoaOut value = ServiceConnector.doService(info, "I_SBD_004", "CONNECTION", "getRankQuery", obj);
 
			
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
    

    public GridData getHistoryQuery( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "getBdItemDetail" );
             
            Object[] obj = { headerData };
			SepoaOut value = ServiceConnector.doService(info, "I_SBD_004", "CONNECTION", "getHistoryQuery", obj);
 
			
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
}
