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

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
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

public class ct_submit_list_ict  extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
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
    		
    		if("getCtBzList".equals(mode)){ // 조회 샘플
    			gdRes = this.getCtBzList(gdReq, info);
    		}else if ("getCtResultList".equals(mode)) {
				gdRes = getCtResultList(gdReq , info); 
			}else if ("saveBZ".equals(mode)){
                gdRes = this.saveBzList(gdReq, info);
            }else if ("deleteBZ".equals(mode)){
                gdRes = this.deleteBzList(gdReq, info);
            }else if ("saveCT".equals(mode)){
                gdRes = this.saveCtList(gdReq, info);
            }else if ("deleteCT".equals(mode)){
                gdRes = this.deleteCtList(gdReq, info);
            }else if ("setCtSubmit".equals(mode)) {
				gdRes = setCtSubmit(gdReq , info); 
            }else if ("getIvResultList".equals(mode)) {
				gdRes = getIvResultList(gdReq , info); 
			}else if ("setIvSubmit".equals(mode)) {
				gdRes = setIvSubmit(gdReq , info); 
            } 
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("setCtSubmit".equals(mode) || "setIvSubmit".equals(mode)){
        			out.print(gdRes.getMessage()+"|"+gdRes.getStatus());
        		}else{
        			OperateGridData.write( req, res, gdRes, out );
        		}
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    /**
     * 사업 리스트 조회
     * getCtBzList
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	private GridData getCtBzList(GridData gdReq, SepoaInfo info) throws Exception {
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
	    	value = ServiceConnector.doService(info, "I_CT_001", "CONNECTION","getCtBzList", obj);
	
	    	Config conf = new Configuration();
            String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
            
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
			    			if(colKey != null && "SELECTED".equals(colKey)){
			    				gdRes.addValue("SELECTED", "0");
			    			}else if(colKey != null && "CT_USER".equals(colKey)) {
			                    gdRes.addValue("CT_USER", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
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
	
	public GridData getCtResultList( GridData gdReq, SepoaInfo info ) throws Exception {

        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );


        Map< String, String >   allData     = null;
        Map< String, String >   headerData  = null;
        String biz_no = null;
        String        colKey           = null;
        
        
        String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

        Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
        
        try {

            allData     = SepoaDataMapper.getData( info, gdReq );
            headerData  = MapUtils.getMap( allData, "headerData" );
            biz_no = JSPUtil.CheckInjection(gdReq.getParam("biz_no")).trim();
            
            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "getCtResultList" );
             
            Object[] obj = { headerData, biz_no};
			SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "CONNECTION", "getCtResultList", obj);
 
			
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
                	colKey   = grid_col_ary[k];
                    if( colKey != null && "SELECTED".equals(colKey) ) {
                        gdRes.addValue( "SELECTED", "0" ); 
                    } else if(colKey != null && "VENDOR".equals(colKey)) {
	                    if("".equals(wf.getValue("BID_NO", i)) || "".equals(wf.getValue("VENDOR_CODE", i))){
	                    	gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
	                    }else{
	                    	gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
	                    }
	                } else if(colKey != null && "CT_ATTACH_NO".equals(colKey) ) {                    	
						//if("".equals(wf.getValue("ATTACH_NO", i))){
							//gdRes.addValue(grid_col_ary[k],"");
						//}else{
							gdRes.addValue(colKey,"<img src='/images/icon/icon_search.gif'/> " + wf.getValue("CT_ATTACH_CNT", i));
						//}						
                    } else {
                        gdRes.addValue( colKey, wf.getValue( grid_col_ary[k], i ) );
                    }                         
                }
            }
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}
	
	private GridData saveBzList(GridData gdReq, SepoaInfo info) throws Exception
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
	            		gdReq.getValue("CU", i), //gdReq.getHeader("screen_id").getValue(i)
	            		nullTrim(gdReq.getValue("PUM_NO", i)),
	            		gdReq.getValue("BIZ_NO", i),	            		
	            		nullTrim(gdReq.getValue("BIZ_NM", i)),
		                gdReq.getValue("CT_USER_ID", i),
		                gdReq.getValue("CT_USER_NAME", i),
		                gdReq.getValue("BIZ_STATUS", i)		                
	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "TRANSACTION","saveBzList", obj);

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
	
	public GridData deleteBzList(GridData gdReq, SepoaInfo info) throws Exception
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
	        		  gdReq.getValue("CU", i), //gdReq.getHeader("screen_id").getValue(i)
	        		  gdReq.getValue("BIZ_NO", i),
	        		  
	        		  gdReq.getValue("BIZ_NM", i),
	        		  gdReq.getValue("BIZ_STATUS", i)		      
	            };

	            bean_args[i] = loop_data2;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "TRANSACTION","deleteBzList", obj);

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
	
	private GridData saveCtList(GridData gdReq, SepoaInfo info) throws Exception
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
	            		gdReq.getValue("CU", i), 
	            		gdReq.getValue("BIZ_NO", i),	            		
		                gdReq.getValue("BIZ_SEQ", i),		                
		                gdReq.getValue("MATERIAL_CLASS1", i),
		                gdReq.getValue("MATERIAL_CLASS2", i),
		                nullTrim(gdReq.getValue("CT_NM", i)),
		                nullTrim(gdReq.getValue("VENDOR_CODE", i)),		                
	            		gdReq.getValue("BID_NO", i),	            		
		                gdReq.getValue("BID_COUNT", i),
		                nullTrim(gdReq.getValue("VENDOR_NAME", i))		                	            		
	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "TRANSACTION","saveCtList", obj);

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
	
	public GridData deleteCtList(GridData gdReq, SepoaInfo info) throws Exception
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
	        		  gdReq.getValue("CU", i), //gdReq.getHeader("screen_id").getValue(i)
	        		  gdReq.getValue("BIZ_NO", i),
	        		  gdReq.getValue("BIZ_SEQ", i)		      
	            };

	            bean_args[i] = loop_data2;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "TRANSACTION","deleteCtList", obj);

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
	
	public GridData setCtSubmit( GridData gdReq, SepoaInfo info ) throws Exception {
	    	
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
	    		gdRes.addParam( "mode", "setCtSubmit" );
	    		
	    		headerData.put("cu"             , gdReq.getParam("cu"              )); 
				headerData.put("biz_no"         , gdReq.getParam("biz_no"          )); 
				headerData.put("biz_seq"        , gdReq.getParam("biz_seq"         )); 
				headerData.put("bid_no"         , gdReq.getParam("bid_no"          )); 
				headerData.put("bid_count"      , gdReq.getParam("bid_count"       )); 
				headerData.put("vote_count"     , gdReq.getParam("vote_count"      )); 
				headerData.put("pum_no"         , nullTrim(gdReq.getParam("pum_no"          ))); 
				headerData.put("ann_no"         , gdReq.getParam("ann_no"          ));
				headerData.put("ct_nm"          , nullTrim(gdReq.getParam("ct_nm"           )));
				headerData.put("vendor_code"    , nullTrim(gdReq.getParam("vendor_code"     ))); 
				headerData.put("vendor_name"    , nullTrim(gdReq.getParam("vendor_name"     ))); 
				headerData.put("material_class1", gdReq.getParam("material_class1" )); 
				headerData.put("material_class2", gdReq.getParam("material_class2" )); 
				headerData.put("attach_no"      , gdReq.getParam("attach_no"       ));
	    		
	    		Object[] obj = { headerData };
	    		SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "CONNECTION", "setCtSubmit", obj);
	    		
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
	
	
	
	
	
	public GridData getIvResultList( GridData gdReq, SepoaInfo info ) throws Exception {

        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );


        Map< String, String >   allData     = null;
        Map< String, String >   headerData  = null;
        String biz_no = null;
        String        colKey           = null;
        
        
        String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

        Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
        
        try {

            allData     = SepoaDataMapper.getData( info, gdReq );
            headerData  = MapUtils.getMap( allData, "headerData" );
            biz_no = JSPUtil.CheckInjection(gdReq.getParam("biz_no")).trim();
            
            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "getIvResultList" );
             
            Object[] obj = { headerData, biz_no};
			SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "CONNECTION", "getIvResultList", obj);
 
			
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
                	colKey   = grid_col_ary[k];
                    if( colKey != null && "SELECTED".equals(colKey) ) {
                        gdRes.addValue( "SELECTED", "0" ); 
                    } else if(colKey != null && "VENDOR".equals(colKey)) {
	                    if("".equals(wf.getValue("BID_NO", i))){
	                    	gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
	                    }else{
	                    	gdRes.addValue("VENDOR", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
	                    }
	                } else if(colKey != null && "CT_ATTACH_NO".equals(colKey) ) {                    	
						//if("".equals(wf.getValue("ATTACH_NO", i))){
							//gdRes.addValue(grid_col_ary[k],"");
						//}else{
							gdRes.addValue(colKey,"<img src='/images/icon/icon_search.gif'/> " + wf.getValue("CT_ATTACH_CNT", i));
						//}						
	                } else if(colKey != null && "IV_ATTACH_NO".equals(colKey) ) {                    	
						//if("".equals(wf.getValue("ATTACH_NO", i))){
							//gdRes.addValue(grid_col_ary[k],"");
						//}else{
							gdRes.addValue(colKey,"<img src='/images/icon/icon_search.gif'/> " + wf.getValue("IV_ATTACH_CNT", i));
						//}						
                    } else {
                        gdRes.addValue( colKey, wf.getValue( grid_col_ary[k], i ) );
                    }                         
                }
            }
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}
	
	public GridData setIvSubmit( GridData gdReq, SepoaInfo info ) throws Exception {
    	
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
    		gdRes.addParam( "mode", "setCtSubmit" );
    		
    		headerData.put("cu"             , gdReq.getParam("cu"              )); 
			headerData.put("biz_no"         , gdReq.getParam("biz_no"          )); 
			headerData.put("biz_seq"        , gdReq.getParam("biz_seq"         )); 
			headerData.put("bid_no"         , gdReq.getParam("bid_no"          )); 
			headerData.put("bid_count"      , gdReq.getParam("bid_count"       )); 
			headerData.put("vote_count"     , gdReq.getParam("vote_count"      )); 
			headerData.put("pum_no"         , nullTrim(gdReq.getParam("pum_no"          ))); 
			headerData.put("ann_no"         , gdReq.getParam("ann_no"          ));
			headerData.put("ct_nm"          , gdReq.getParam("ct_nm"           ));
			headerData.put("vendor_code"    , nullTrim(gdReq.getParam("vendor_code"     ))); 
			headerData.put("material_class1", gdReq.getParam("material_class1" )); 
			headerData.put("material_class2", gdReq.getParam("material_class2" )); 
			headerData.put("attach_no"      , gdReq.getParam("attach_no"       ));
    		
    		Object[] obj = { headerData };
    		SepoaOut value = ServiceConnector.doService(info, "I_CT_001", "CONNECTION", "setIvSubmit", obj);
    		
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