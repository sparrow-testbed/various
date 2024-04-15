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
import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings({"unchecked", "serial"})
public class bd_qt_confirm_ict extends HttpServlet {

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

            if ("getHandList".equals(mode)) {
				gdRes = getHandList(gdReq , info); 
			}else if ("getBdQtConfirmList".equals(mode)) {
				gdRes = getBdQtConfirmList(gdReq , info); 
			}else if ("setBdQtConfirm".equals(mode)) {
				gdRes = setBdQtConfirm(gdReq , info); 
			}else if ("saveHndgList".equals(mode)){
                gdRes = this.saveHndgList(gdReq, info);
            }else if ("deleteHndgList".equals(mode)){
                gdRes = this.deleteHndgList(gdReq, info);
            }
            
            
        } catch( Exception e ) {
            gdRes.setMessage( "Error: " + e.getMessage() );
            gdRes.setStatus( "false" );
            
        } finally {
        	try {
        		if("setBDQTSubmit".equals(mode)){
        			out.print(gdRes.getMessage()+"|"+gdRes.getStatus());
        		}else{
        			OperateGridData.write( req, res, gdRes, out );
        		}
            } catch( Exception e ) {
            	Logger.debug.println();
            }
        }
    }
    
    public static String nullTrim(String value)
    {
        if(value != null){
        	if(value.trim().equals("")){
        		value = null;
        	}else{
        		value = value.trim();        		
        	}
        }
        
        return value;
    }
    
    
    public GridData getHandList( GridData gdReq, SepoaInfo info ) throws Exception {
    	
    	GridData gdRes = new GridData();
    	int rowCount = 0;
    	SepoaFormater wf = null;
    	
    	
    	HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );
    	
    	
    	Map< String, String >   allData     = null;
    	Map< String, String >   headerData  = null;
    	
    	String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();
    	
    	Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
    	
    	try {
    		
    		allData     = SepoaDataMapper.getData( info, gdReq );
    		headerData  = MapUtils.getMap( allData, "headerData" );
    		
    		String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
    		String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
    		gdRes = OperateGridData.cloneResponseGridData( gdReq );
    		gdRes.addParam( "mode", "getBdPriceList" );
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_BD_025", "CONNECTION", "getHandList", obj);
    		
    		
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
    		
    		//VOTE_COUNT
    		for( int i = 0; i < rowCount; i++ ) {
    			for( int k = 0; k < grid_col_ary.length; k++ ) {
    				if( grid_col_ary[k] != null && grid_col_ary[k].equals( "SELECTED" ) ) {
    					gdRes.addValue( "SELECTED", "0" ); 
    				} else if(grid_col_ary[k] != null && "BIZ".equals(grid_col_ary[k])) {
 	                    if("".equals(wf.getValue("VOTE_COUNT", i))){
 	                    	gdRes.addValue("BIZ", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
 	                    }else{
 	                    	gdRes.addValue("BIZ", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
 	                    }
    				} else if(grid_col_ary[k] != null && "VENDOR".equals(grid_col_ary[k])) {
 	                    if("".equals(wf.getValue("VOTE_COUNT", i))){
 	                    	if( "0".equals(wf.getValue("ATTACH_CNT", i)) && "0".equals(wf.getValue("ATTACH_CNT2", i)) && "0".equals(wf.getValue("ATTACH_CNT3", i)) ){
 	                    		gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
 	                    	}else{
 	                    		gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
 	                    	} 	    	                     	                    	
 	                    }else{
 	                    	gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
 	                    }
 	                } else if(grid_col_ary[k] != null && grid_col_ary[k].equals( "ATTACH_NO" ) ) {
                    	
						//if("".equals(wf.getValue("ATTACH_NO", i))){
							//gdRes.addValue(grid_col_ary[k],"");
						//}else{
							gdRes.addValue(grid_col_ary[k],"<img src='/images/icon/icon_search.gif'/> " + wf.getValue("ATTACH_CNT", i));
						//}
						
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
    
    public GridData getBdQtConfirmList( GridData gdReq, SepoaInfo info ) throws Exception {
    	
    	GridData gdRes = new GridData();
    	int rowCount = 0;
    	SepoaFormater wf = null;
    	
    	
    	HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );
    	
    	
    	Map< String, String >   allData     = null;
    	Map< String, String >   headerData  = null;
    	
    	String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();
    	
    	Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
    	
    	try {
    		
    		allData     = SepoaDataMapper.getData( info, gdReq );
    		headerData  = MapUtils.getMap( allData, "headerData" );
    		
    		String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
    		String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
    		gdRes = OperateGridData.cloneResponseGridData( gdReq );
    		gdRes.addParam( "mode", "getBdPriceList" );
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_BD_025", "CONNECTION", "getBdQtConfirmList", obj);
    		
    		
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
    		
    		//VOTE_COUNT
    		for( int i = 0; i < rowCount; i++ ) {
    			for( int k = 0; k < grid_col_ary.length; k++ ) {
    				if( grid_col_ary[k] != null && grid_col_ary[k].equals( "SELECTED" ) ) {
    					gdRes.addValue( "SELECTED", "0" ); 
    				} else if(grid_col_ary[k] != null && "BIZ".equals(grid_col_ary[k])) {
 	                    if("".equals(wf.getValue("VOTE_COUNT", i))){
 	                    	gdRes.addValue("BIZ", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
 	                    }else{
 	                    	gdRes.addValue("BIZ", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
 	                    }
    				} else if(grid_col_ary[k] != null && "VENDOR".equals(grid_col_ary[k])) {
 	                    if("".equals(wf.getValue("VOTE_COUNT", i))){
 	                    	if( "0".equals(wf.getValue("ATTACH_CNT", i)) && "0".equals(wf.getValue("ATTACH_CNT2", i)) && "0".equals(wf.getValue("ATTACH_CNT3", i)) ){
 	                    		gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
 	                    	}else{
 	                    		gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
 	                    	} 	    	                     	                    	
 	                    }else{
 	                    	gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
 	                    }
 	                } else if(grid_col_ary[k] != null && grid_col_ary[k].equals( "ATTACH_NO" ) ) {
                    	
						//if("".equals(wf.getValue("ATTACH_NO", i))){
							//gdRes.addValue(grid_col_ary[k],"");
						//}else{
							gdRes.addValue(grid_col_ary[k],"<img src='/images/icon/icon_search.gif'/> " + wf.getValue("ATTACH_CNT", i));
						//}
						
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
    
    /* ICT 사용 : 적격업체 저장*/
    public GridData setBdQtConfirm( GridData gdReq, SepoaInfo info ) throws Exception {

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
            gdRes.addParam( "mode", "setBdQtConfirm" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_025", "TRANSACTION", "setBdQtConfirm", obj);
 
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
    
    private GridData saveHndgList(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];
	        
	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
	            		gdReq.getValue("CRUD", i),
	            		gdReq.getValue("HD_GB", i),
	            		gdReq.getValue("BIZ_NO", i),
	            		nullTrim(gdReq.getValue("ANN_NO", i)),
		                nullTrim(gdReq.getValue("ANN_ITEM", i)),
		                gdReq.getValue("VENDOR_CODE", i),	            		
	            		nullTrim(gdReq.getValue("SETTLE_AMT", i)),
	            		gdReq.getValue("BID_NO", i),
	            		gdReq.getValue("H_VENDOR_CODE", i)	            		
	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "I_BD_025", "TRANSACTION","saveHndgList", obj);

            if(value.flag)
            {
                gdRes.setMessage("저장되었습니다.");
	            gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
        	gdRes.setMessage("저장중 오류가 발생하였습니다.");
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "save");
        return gdRes;
    }
    
    public GridData deleteHndgList(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	        		            String[] loop_data2 =
	            {
	        		  gdReq.getValue("CRUD", i), //gdReq.getHeader("screen_id").getValue(i)
	        		  gdReq.getValue("BID_NO", i),	        		  		      
	            };

	            bean_args[i] = loop_data2;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "I_BD_025", "TRANSACTION","deleteHndgList", obj);

            if(value.flag)
            {
                gdRes.setMessage("삭제 되었습니다.");
	            gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage("삭제중 오류가 발생하였습니다.");
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "delete");
        return gdRes;
    }
}
