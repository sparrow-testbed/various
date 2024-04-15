package ict.sepoa.svl.sourcing;

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
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class bd_result_list2_ict  extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getRfqBzList".equals(mode)){ // 조회 샘플
    			gdRes = this.getRfqBzList(gdReq, info);
    		}else if ("getBdResultList".equals(mode)) {
				gdRes = getBdResultList(gdReq , info); 
			}   		
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }

    
    /**
     * 사업 리스트 조회
     * getRfqBzList
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	private GridData getRfqBzList(GridData gdReq, SepoaInfo info) throws Exception {
		GridData            gdRes        = new GridData();
	    SepoaFormater       sf           = null;
	    SepoaOut            value        = null;
	    Vector              v            = new Vector();
	    HashMap             message      = null;
	    Map<String, Object> allData      = null;
	    Map<String, String> header       = null;
	    String              gridColId    = null;
	    String              addDateStart = null;
	    String              addDateEnd   = null;
	    String[]            gridColAry   = null;
	    int                 rowCount     = 0;
	    
	    String        colKey           = null;
	    String        colValue         = null;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData      = SepoaDataMapper.getData(info, gdReq);
	    	header       = MapUtils.getMap(allData, "headerData");
	    	gridColId    = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry   = SepoaString.parser(gridColId, ",");
	    	gdRes        = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	addDateStart = header.get("add_date_start");
	    	addDateEnd   = header.get("add_date_end");
	    	addDateStart = SepoaString.getDateUnSlashFormat(addDateStart);
	    	addDateEnd   = SepoaString.getDateUnSlashFormat(addDateEnd);
	
	    	header.put("add_date_start".trim(), SepoaString.getDateUnSlashFormat( addDateStart ) );
	    	header.put("add_date_end".trim(), SepoaString.getDateUnSlashFormat( addDateEnd   ) );
	    	header.put("DEPARTMENT", info.getSession("DEPARTMENT"));
	    	header.put("DEPARTMENT_NAME_LOC", info.getSession("DEPARTMENT_NAME_LOC"));
	    	
	    	gdRes.addParam("mode", "doQuery");
	
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "I_BD_027", "CONNECTION","getRfqBzList", obj);
	
	    	if(value.flag){// 조회 성공
//	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
//		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			colKey   = gridColAry[k];
			    			if("SELECTED".equals(colKey)){
			    				gdRes.addValue("SELECTED", "0");
			    			}else{
			    				gdRes.addValue(colKey, sf.getValue(colKey, i));
			    			}
			    		}
			    	}		    				    				    				    			  
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
//	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
	
	
	public GridData getBdResultList( GridData gdReq, SepoaInfo info ) throws Exception {

        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;

    
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );


        Map< String, String >   allData     = null;
        Map< String, String >   headerData  = null;
        String biz_no = null;
        
        String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

        try {

            allData     = SepoaDataMapper.getData( info, gdReq );
            headerData  = MapUtils.getMap( allData, "headerData" );
            biz_no = JSPUtil.CheckInjection(gdReq.getParam("biz_no")).trim();
            
            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "getBdResultList" );
             
            Object[] obj = { headerData, biz_no};
			SepoaOut value = ServiceConnector.doService(info, "I_BD_027", "CONNECTION", "getBdResultList", obj);
 
			
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