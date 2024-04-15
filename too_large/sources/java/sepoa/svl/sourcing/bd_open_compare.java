/**
 * @파일명   : bd_price_list.java
 * @Location : sepoa.svl.sourcing
 * @생성일자 : 2009. 04. 24
 * @변경이력 :
 * @프로그램 설명 : 구매요청접수( 담당자배정 )
 */

package sepoa.svl.sourcing;
  
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
public class bd_open_compare extends HttpServlet {

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


			if ("getBdDetailCompare".equals(mode)) {
				gdRes = getBdDetailCompare(gdReq , info); 
			} else if ("setOrder".equals(mode)) {
				gdRes = setOrder(gdReq , info); 
			} else if ("setBdProcessSB".equals(mode)) {
				gdRes = setBdProcessSB(gdReq , info); 
			} else if ("setReBd".equals(mode)) {
				gdRes = setReBd(gdReq , info); 
			} else if ("setPriceScore".equals(mode)) {
				gdRes = setPriceScore(gdReq , info); 
			} else if ("getBdUnitDetail".equals(mode)) {
				gdRes = getBdUnitDetail(gdReq , info); 
			}
			
            
        } catch( Exception e ) {
            gdRes.setMessage( "Error: " + e.getMessage() );
            gdRes.setStatus( "false" );
            
        } finally {
            try {
                OperateGridData.write( req, res, gdRes, out );
            } catch( Exception e ) {
            	Logger.debug.println();
            }
        }
    }


    public GridData getBdDetailCompare( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "getBdDetailCompare" );
             
            Object[] obj = { headerData };
			SepoaOut value = ServiceConnector.doService(info, "BD_014", "CONNECTION", "getBdDetailCompare", obj);
 
			
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
        
    public GridData setOrder( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "setOrder" );
             
            Object[] obj = { headerData };
			SepoaOut value = ServiceConnector.doService(info, "BD_014", "CONNECTION", "setOrder", obj);
 
			
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

    public GridData setBdProcessSB( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "setBdProcessSB" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "BD_014", "CONNECTION", "setBdProcessSB", obj);
 
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

    public GridData setReBd( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "setReBd" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "BD_014", "CONNECTION", "setReBd", obj);
 
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

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setPriceScore(GridData gdReq, SepoaInfo info) throws Exception{
		GridData            gdRes       = new GridData();
		Vector              multilangId = new Vector();
		HashMap             message     = null;
		SepoaOut            value       = null;
		Map<String, Object> data        = null;
		
		multilangId.addElement("MESSAGE");
		
		message = MessageUtil.getMessage(info, multilangId);
		
		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			data = SepoaDataMapper.getData(info, gdReq);
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "BD_014", "TRANSACTION", "setPriceScore",       obj);
			
			String[] tmp = value.result;
			
			if(tmp != null && tmp.length > 0){
				for(int i = 0 ; i < tmp.length ; i++){
					Logger.debug.println();
				}
			}
			
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}
			else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		}
		catch(Exception e){
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
		
	public GridData getBdUnitDetail( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "getBdResultList" );
             
            Object[] obj = { headerData };
			SepoaOut value = ServiceConnector.doService(info, "BD_014", "CONNECTION", "getBdUnitDetail", obj);
 
			
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
