/**
 * @파일명   : bd_ann.java
 * @Location : sepoa.svl.sourcing
 * @생성일자 : 2009. 04. 24
 * @변경이력 :
 * @프로그램 설명 : 입찰공고생성
 */

package ict.sepoa.svl.sourcing;
  
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
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
public class bd_ann_ict extends HttpServlet {

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


			if ("getPrItemDetail".equals(mode)) {
				gdRes = getPrItemDetail(gdReq ,req, info); 
			}else if ("setAnnCreate".equals(mode)) {// 1.공고생성
				gdRes = setAnnCreate(gdReq , info);
			}else if ("getBdItemDetail".equals(mode)) {
				gdRes = getBdItemDetail(gdReq , info); 
			}else if ("setGonggoModify".equals(mode)) {//2.공고수정(결재요청)
				gdRes = setGonggoModify(gdReq , info); 
			}else if ("setGonggoConfirm".equals(mode)) {//확정(사용안함)
				gdRes = setGonggoConfirm(gdReq , info); 
			}else if ( "setApprovalRequest".equals(mode ) ) {//결재요청(사용안함)
                gdRes = setApprovalRequest ( gdReq , info ) ;
            }else if ( "setUGonggoCreate".equals(mode ) ) {//3.정정공고 생성
                gdRes = setUGonggoCreate ( gdReq , info ) ;
            }else if ( "setUGonggoModify".equals(mode ) ) {//4.정정공고 수정(결재요청)
                gdRes = setUGonggoModify ( gdReq , info ) ;
            }else if ( "setCopy".equals(mode) ) {//정정
                gdRes = setCopy ( gdReq , info ) ;
            }else if ( "chkApprRep".equals(mode) ) {//결재요청가능 여부 체크
                gdRes = chkApprRep ( gdReq , info ) ;
            }
			
			
			
			
			
            
            
        } catch( Exception e ) {
            gdRes.setMessage( "Error: " + e.getMessage() );
            gdRes.setStatus( "false" );
            
        } finally {
            try {
            	if("chkApprRep".equals(mode)){
        			out.print(gdRes.getMessage());
        		}else{        			
        			OperateGridData.write( req, res, gdRes, out );            		
        		}                
            } catch( Exception e ) {
            	Logger.debug.println();
                
            }
        }
    }


    public GridData getPrItemDetail( GridData gdReq, HttpServletRequest req, SepoaInfo info ) throws Exception {

        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;

        Map< String, String >   allData     = null;
        Map< String, String >   headerData  = null;
    
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );
 
        try {

            allData     = SepoaDataMapper.getData( info, gdReq );
            headerData  = MapUtils.getMap( allData, "headerData" );

            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq ); 
            gdRes.addParam( "mode", "getPrItemDetail" );
  
            Object[] obj = { headerData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "CONNECTION", "getPrItemDetail", obj);
  
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

			Logger.err.println("==rowCount="+rowCount);
			if (rowCount == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}
 

            for( int i = 0; i < rowCount; i++ ) {
                for( int k = 0; k < grid_col_ary.length; k++ ) {
                    if( grid_col_ary[k] != null && grid_col_ary[k].equals( "SELECTED" ) ) {
                        gdRes.addValue( "SELECTED", "0" ); 
                    } 
                    else if(grid_col_ary[k] != null && grid_col_ary[k].equals( "QTY" )) {
                    	gdRes.addValue( grid_col_ary[k], wf.getValue( "RFQ_QTY", i ) );
                    } 
                    else if(grid_col_ary[k] != null && grid_col_ary[k].equals( "UNIT_PRICE" )) {
                    	gdRes.addValue( grid_col_ary[k], wf.getValue( "PURCHASE_PRE_PRICE", i ) );
                    } 
                    else if(grid_col_ary[k] != null && grid_col_ary[k].equals( "AMT" )) {
                    	gdRes.addValue( grid_col_ary[k], wf.getValue( "RFQ_AMT", i ) );
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
   
    
    /* ICT 사용 : 입찰공고 작성 */
    public GridData setAnnCreate( GridData gdReq, SepoaInfo info ) throws Exception {

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
            
            //gdRes = OperateGridData.cloneResponseGridData( gdReq );

            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "setAnnCreate" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "TRANSACTION", "setAnnCreate", obj);
 
			if( value.flag ) { 
	            gdRes.addParam( "pflag", value.result[0] );
	            gdRes.addParam( "bid_no", value.result[1] );
	            gdRes.addParam( "bid_count", value.result[2] );
	            //gdRes.addParam( "ann_no", value.result[3] );
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
			SepoaOut value = ServiceConnector.doService(info, "BD_002", "CONNECTION", "getBdItemDetail", obj);
 
			
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
    
    
    /* ICT 사용 : 입찰공고 수정(결재요청) */
    public GridData setGonggoModify( GridData gdReq, SepoaInfo info ) throws Exception {

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
            //gdRes.setSelectable(false);
            gdRes.addParam( "mode", "setGonggoModify" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "TRANSACTION", "setGonggoModify", obj);
 
			if( value.flag ) { 
	            gdRes.addParam( "pflag", value.result[0] );
	            gdRes.addParam( "bid_no", value.result[1] ); 
	            gdRes.addParam( "bid_count", value.result[2] );
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
    
    
    /* ICT 사용 : 입찰공고 확정 */
    public GridData setGonggoConfirm( GridData gdReq, SepoaInfo info ) throws Exception {

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
            //gdRes.setSelectable(false);
            gdRes.addParam( "mode", "setGonggoConfirm" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "TRANSACTION", "setGonggoConfirm", obj);
 
			if( value.flag ) {  
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");            
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

    /**
     * 입찰 결제요청
     * 
     * @param gdReq
     * @return
     * @throws Exception
     */
    public GridData setApprovalRequest(GridData gdReq, SepoaInfo info) throws Exception {

        GridData gdRes = new GridData();

        //20131205 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵

        try
        {
             allData = SepoaDataMapper.getData( info, gdReq );
             
             gdRes.setSelectable(false);

            Object[] obj = {allData};
            SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "TRANSACTION", "setApprovalRequest", obj);
            
            if (value.flag) {
                gdRes.setMessage(value.message);
                gdRes.setStatus("true");
            } else {
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
            }
            
        } catch (Exception e) {
            
            gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
            gdRes.setStatus("false");
        
        }
        
        gdRes.addParam("mode", "save");
        return gdRes;
        
    }
    
    /* ICT 사용 : 정정공고 생성*/
    public GridData setUGonggoCreate( GridData gdReq, SepoaInfo info ) throws Exception {

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
            //gdRes = OperateGridData.cloneResponseGridData( gdReq );
            //gdRes.setSelectable(false);
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "setUGonggoCreate" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "TRANSACTION", "setUGonggoCreate", obj);
 
			if( value.flag ) { 
	            gdRes.addParam( "pflag", value.result[0] );
	            gdRes.addParam( "bid_no", value.result[1] );
	            gdRes.addParam( "bid_count", value.result[2] );
	            //gdRes.addParam( "ann_no", value.result[3] );
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
    

    /* ICT 사용 : 정정공고 수정(결재요청)*/
    public GridData setUGonggoModify( GridData gdReq, SepoaInfo info ) throws Exception {

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
            //gdRes = OperateGridData.cloneResponseGridData( gdReq );
            //gdRes.setSelectable(false);
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "setUGonggoModify" );
  
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "TRANSACTION", "setUGonggoModify", obj);
 
			if( value.flag ) { 
	            gdRes.addParam( "pflag", value.result[0] );
	            gdRes.addParam( "bid_no", value.result[1] );
	            gdRes.addParam( "bid_count", value.result[2] );
	            //gdRes.addParam( "ann_no", value.result[3] );
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
    
    
    public GridData setCopy( GridData gdReq, SepoaInfo info ) throws Exception {
    	
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
    		
    		headerData.put( "curr_version",  gdReq.getParam( "curr_version" ) );
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_BD_001", "TRANSACTION", "setFileCopy", obj);
    		
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
    
    private Map<String, String> getQuerySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result      = new HashMap<String, String>();
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	String              bid_no      = gdReq.getParam("bid_no");
    	String              bid_count   = gdReq.getParam("bid_count");
    	
    	
    	result.put("HOUSE_CODE",   houseCode);
    	result.put("BID_NO",    bid_no);
    	result.put("BID_COUNT",    bid_count);
    	
    	return result;
    }
    
    private GridData chkApprRep(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes   = new GridData();
	    SepoaOut            value   = null;
	    SepoaFormater       sf      = null;
	    Map<String, String> svcParm = this.getQuerySvcParam(gdReq, info);
	    String              message = null;
	
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParm};
	
	    	value   = ServiceConnector.doService(info, "I_BD_001", "CONNECTION","chkApprRep", obj);
	    	sf = new SepoaFormater(value.result[0]);
	    	
	    	message = sf.getValue("CNT", 0);
	    	
	    	gdRes.setMessage(message);
	    	gdRes.setStatus(Boolean.toString(value.flag));
	    }
	    catch (Exception e){
	    	gdRes.setMessage("-999");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
}
