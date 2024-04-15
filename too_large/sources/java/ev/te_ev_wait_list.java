package ev;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class te_ev_wait_list extends HttpServlet
{
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// 세션 Object
        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		if("getEvalSheetList".equals(mode)){
       			gdRes = getEvalSheetList(gdReq, info);		//평가시트 목록조회
    		}else if("getEtplList".equals(mode)){
       			gdRes = getEtplList(gdReq, info);		//평가계획  목록조회
    		}else if ("deleteEtpl".equals(mode)){
                gdRes = this.deleteEtpl(gdReq, info);   //평가계획 삭제
            }else if("saveEtplList".equals(mode)){
       			gdRes = saveEtplList(gdReq, info);		//평가계획 저장
    		}else if("getEtplDtList".equals(mode)){
       			gdRes = getEtplDtList(gdReq, info);		//평가계획 공종별 목록조회
    		}else if("getEtplDtList2".equals(mode)){
       			gdRes = getEtplDtList2(gdReq, info);    //평가계획 공종별 목록조회(상세)
    		}else if ("saveEtplDt".equals(mode)){
                gdRes = this.saveEtplDt(gdReq, info);
            }else if ("deleteEtck".equals(mode)){
                gdRes = this.deleteEtck(gdReq, info);
            }else if("getEtEvWaitList".equals(mode)){
       			gdRes = getEtEvWaitList(gdReq, info);    //기술 평가대상 조회
    		}else if("setEtSave".equals(mode)){          //기술평가
    			gdRes = this.setEtSave(gdReq, info);
    		}else if ("setEtDelete".equals(mode)) {
				gdRes = setEtDelete(gdReq, info);
			}else if("getEtEvRstList".equals(mode)){
       			gdRes = getEtEvRstList(gdReq, info);    //기술 평가대상 조회
    		}else if("getEtEvList2".equals(mode)){
       			gdRes = getEtEvList2(gdReq, info);		//기술 평가 통계
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
    
    private GridData getEtEvList2(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
//				SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getCsEvWaitList",obj);
				SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION","getEtEvList2",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					   gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));				    
					}
				}
				
		 } catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		    }
			
			return gdRes;
		
	}

    
	private GridData getEvalSheetList(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
//				SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getCsEvWaitList",obj);
				SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION","getEvalSheetList",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	} else {
				        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
				        }
					}
				}
				
		 } catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		    }
			
			return gdRes;
		
	}
	
	private GridData getEtplList(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
//				SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getCsEvWaitList",obj);
				SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION","getEtplList",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	} else {
				        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
				        }
					}
				}
				
		 } catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		 }
			
		return gdRes;	
	}
	
	public GridData deleteEtpl(GridData gdReq, SepoaInfo info) throws Exception
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
	        		  gdReq.getValue("ETPL_NO", i),
	        		  gdReq.getValue("PRG_STS", i),
	        		  gdReq.getValue("PRG_STS_OLD", i)       		  
	            };

	            bean_args[i] = loop_data2;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "EV_002", "TRANSACTION","deleteEtpl", obj);

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
	
	private GridData saveEtplList(GridData gdReq, SepoaInfo info) throws Exception
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
	            		nullTrim(gdReq.getValue("EVAL_YY", i)),
	            		gdReq.getValue("ETPL_NO", i),	            		
	            		nullTrim(gdReq.getValue("ETPL_NM", i)),
	            		gdReq.getValue("PRG_STS", i)	            			            			            	
	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "EV_002", "TRANSACTION","saveEtplList", obj);

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
	
	public GridData getEtplDtList( GridData gdReq, SepoaInfo info ) throws Exception {

        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );


        Map< String, String >   allData     = null;
        Map< String, String >   headerData  = null;
        String etpl_no = null;
        String        colKey           = null;
        
        
        String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

        Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
        
        try {

            allData     = SepoaDataMapper.getData( info, gdReq );
            headerData  = MapUtils.getMap( allData, "headerData" );
            etpl_no = JSPUtil.CheckInjection(gdReq.getParam("etpl_no")).trim();
            
            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "getEtplDtList" );
             
            Object[] obj = { headerData, etpl_no};
			SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION", "getEtplDtList", obj);
 
			
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
                    } else if(colKey != null && "ES_CD_SEL".equals(colKey)) {
                    	gdRes.addValue("ES_CD_SEL", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
//	                    if("T".equals(wf.getValue("PRG_STS", i))){
//	                    	gdRes.addValue("ES_CD_SEL", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
//	                    }else{
//	                    	gdRes.addValue("ES_CD_SEL", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
//	                    }
	                } else if(colKey != null && "EVAL_USER_SEL".equals(colKey)) {
	                    if("T".equals(wf.getValue("PRG_STS", i))){
	                    	gdRes.addValue("EVAL_USER_SEL", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
	                    }else{
	                    	gdRes.addValue("EVAL_USER_SEL", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
	                    }
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
	
	public GridData getEtplDtList2( GridData gdReq, SepoaInfo info ) throws Exception {

        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );


        Map< String, String >   allData     = null;
        Map< String, String >   headerData  = null;
        String etpl_no = null;
        String        colKey           = null;
        
        
        String server_time = SepoaDate.getShortDateString()+SepoaDate.getShortTimeString();

        Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
        
        try {

            allData     = SepoaDataMapper.getData( info, gdReq );
            headerData  = MapUtils.getMap( allData, "headerData" );
            
            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "doQuery" );
             
            Object[] obj = { headerData};
			SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION", "getEtplDtList2", obj);
 
			
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
	
	private GridData saveEtplDt(GridData gdReq, SepoaInfo info) throws Exception
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
	            		gdReq.getValue("ETPL_NO", i),
	            		gdReq.getValue("ETPL_SEQ", i),
	            		gdReq.getValue("ES_CD", i),
	            		gdReq.getValue("ES_VER", i),
	            		gdReq.getValue("CSKD_GB", i),
	            		gdReq.getValue("CSKD_GB_NM", i),	            			            	
	            		gdReq.getValue("GROUP1_CODE", i),
	            		gdReq.getValue("EVAL_USER_NAMES", i),
	            		gdReq.getValue("EVAL_USER_IDS", i),
	            		gdReq.getValue("EVAL_USER_CNT", i),
	            		gdReq.getValue("EVAL_USER_NAMES_OLD", i),
		        		gdReq.getValue("EVAL_USER_IDS_OLD", i),
		        		gdReq.getValue("EVAL_USER_CNT_OLD", i)
	            		//nullTrim(gdReq.getValue("CT_NM", i)),
		                //nullTrim(gdReq.getValue("VENDOR_CODE", i)),		                	            			                	            		
	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "EV_002", "TRANSACTION","saveEtplDt", obj);

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
	
	public GridData deleteEtck(GridData gdReq, SepoaInfo info) throws Exception
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
	        		  gdReq.getValue("ETPL_NO", i),
	        		  gdReq.getValue("ETPL_SEQ", i),
	        		  gdReq.getValue("EVAL_USER_NAMES", i),
	        		  gdReq.getValue("EVAL_USER_IDS", i),
	        		  gdReq.getValue("EVAL_USER_CNT", i),
	        		  gdReq.getValue("EVAL_USER_NAMES_OLD", i),
	        		  gdReq.getValue("EVAL_USER_IDS_OLD", i),
	        		  gdReq.getValue("EVAL_USER_CNT_OLD", i)
	            };

	            bean_args[i] = loop_data2;
	        }

	        Object[] obj = {info, bean_args};
	    	SepoaOut value = ServiceConnector.doService(info, "EV_002", "TRANSACTION","deleteEtck", obj);

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
	
	private GridData getEtEvWaitList(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 String        colKey           = null;
		 
		 Config conf = new Configuration();
	     String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
				SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION","getEtEvWaitList",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				
				for( int i = 0; i < wf.getRowCount(); i++ ) {
	                for( int k = 0; k < grid_col_ary.length; k++ ) {
	                	colKey   = grid_col_ary[k];
	                    if( colKey != null && "SELECTED".equals(colKey) ) {
	                        gdRes.addValue( "SELECTED", "0" ); 
	                    } else if(colKey != null && "ET_NO_SEL".equals(colKey)) {
		                    if("".equals(wf.getValue("ET_NO", i))){
		                    	gdRes.addValue("ET_NO_SEL", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
		                    }else{
		                    	gdRes.addValue("ET_NO_SEL", POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif");
		                    }
		                } else {
	                        gdRes.addValue( colKey, wf.getValue( grid_col_ary[k], i ) );
	                    }                         
	                }
	            }
				
//				for (int i = 0; i < wf.getRowCount(); i++) {
//					for(int k=0; k < grid_col_ary.length; k++) {
//					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
//	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
//	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
//	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
//				    	} else {
//				        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
//				        }
//					}
//				}
				
		 } catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		    }
			
			return gdRes;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setEtSave(GridData gdReq, SepoaInfo info) throws Exception{
		GridData                  gdRes            = new GridData();
	    Vector                    multilangId      = new Vector();
	    HashMap                   message          = null;
	    SepoaOut                  value            = null;
	    Map<String, Object>       data             = null;
	    Map<String, String>       header           = null;
	    List<Map<String, String>> grid             = null;
	    
	    multilangId.addElement("MESSAGE");
	    
		message = MessageUtil.getMessage(info, multilangId);
		
		String     etNo             = null;
		
		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			
			etNo = this.getETNo(info);		
			
			data   = SepoaDataMapper.getData(info, gdReq);
			header = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
			header = this.getHeader(info, header, etNo); // 조회 조건 조작
			grid   = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			grid   = this.getGrid(header, grid, etNo); // 그리드 정보 조작
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "EV_002", "TRANSACTION", "setEtSave", obj);
			
			if(value.flag) {
				gdRes.setMessage(value.message); 
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
	
	private String getETNo(SepoaInfo info) throws Exception{
    	String   result = null;
    	SepoaOut wo2    = null;
    	
    	wo2    = DocumentUtil.getDocNumber(info, "ET");
    	result = wo2.result[0];
    	
    	return result;
    }
	
	/**
	 * 서비스에서 사용할 헤더의 정보를 조작하는 메소드
	 * 
	 * @param info
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> getHeader(SepoaInfo info, Map<String, String> header, String etNo) throws Exception{
		header.put("ET_NO",             etNo);
		return header;
	}
	
	/**
	 * 서비스에서 사용할 그리드 정보를 조작하는 메소드
	 * 
	 * @param grid
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> getGrid(Map<String, String> header, List<Map<String, String>> grid, String etNo) throws Exception{
		Map<String, String> gridInfo         = null;
		String              etSeq            = null;
		int                 i                = 0;
		int                 gridSize         = grid.size();
		
		for(i = 0; i < gridSize; i++){
			gridInfo         = grid.get(i);
			etSeq            = String.valueOf(i + 1);
			
			gridInfo.put("ET_NO",              etNo);
			gridInfo.put("ET_SEQ",             etSeq);
		}
		
		return grid;
	}
	
	public GridData setEtDelete(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

		try {
			gdRes.addParam("mode", "doDelete");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			Map<String,String> header = MapUtils.getMap(data,"headerData");
			SepoaOut value = ServiceConnector.doService(info, "EV_002", "TRANSACTION","setEtDelete", obj);
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}

        gdRes.addParam("mode", "delete");
        return gdRes;
    }
	
	private GridData getEtEvRstList(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 String colKey           = null;
		 
		 String[] CP_EVAL_USER_IDS = null;
		 String[] CP_EVAL_USER_IDS2 = null;
		 String[] EH_EVAL_INFOS    = null;
		 String[] EH_EVAL_INFOS2    = null;
		 
		 
		 
		 Config conf = new Configuration();
	     String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
				SepoaOut value = ServiceConnector.doService(info, "EV_002", "CONNECTION","getEtEvRstList",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				
				
				for( int i = 0; i < wf.getRowCount(); i++ ) {
					gdRes.addValue( "SELECTED", "0" );
					CP_EVAL_USER_IDS = SepoaString.parser(wf.getValue( "CP_EVAL_USER_IDS", i ), "^");
					EH_EVAL_INFOS = (wf.getValue( "EH_EVAL_INFOS", i ) != null && !"".equals(wf.getValue( "EH_EVAL_INFOS", i )))?SepoaString.parser(wf.getValue( "EH_EVAL_INFOS", i ), "^"):null;
					
					gdRes.addValue( "PRG_STS", wf.getValue( "PRG_STS", i ) );
					gdRes.addValue( "PRG_STS_TXT", wf.getValue( "PRG_STS_TXT", i ) );
					gdRes.addValue( "CP_EVAL_USER_IDS", wf.getValue( "CP_EVAL_USER_IDS", i ) );
					gdRes.addValue( "EH_EVAL_INFOS", wf.getValue( "EH_EVAL_INFOS", i ) );
					
					gdRes.addValue( "VENDOR_CODE", wf.getValue( "VENDOR_CODE", i ) );
					gdRes.addValue( "VENDOR_NAME_LOC", wf.getValue( "VENDOR_NAME_LOC", i ) );
					gdRes.addValue( "CSKD_GB", wf.getValue( "CSKD_GB", i ) );
					gdRes.addValue( "CSKD_GB_NM", wf.getValue( "CSKD_GB_NM", i ) );
					gdRes.addValue( "GROUP1_CODE", wf.getValue( "GROUP1_CODE", i ) );
					gdRes.addValue( "GROUP1_NAME_LOC", wf.getValue( "GROUP1_NAME_LOC", i ) );
					gdRes.addValue( "GROUP2_CODE", wf.getValue( "GROUP2_CODE", i ) );
					gdRes.addValue( "GROUP2_NAME_LOC", wf.getValue( "GROUP2_NAME_LOC", i ) );
					if(CP_EVAL_USER_IDS != null && CP_EVAL_USER_IDS.length >= 1){
						CP_EVAL_USER_IDS2 = SepoaString.parser(CP_EVAL_USER_IDS[0], "$");						
						EH_EVAL_INFOS2    = null;
						EH_EVAL_INFOS2 = getEH_EVAL_INFO(CP_EVAL_USER_IDS2[0], EH_EVAL_INFOS);
//						EH.EVAL_USER_ID||'$'||EH.EVAL_USER_NAME_LOC||'$'||EH.ET_NO||'$'||EH.EVAL_DATE||'$'||EH.ASC_SUM
						if(EH_EVAL_INFOS2 != null){
							gdRes.addValue( "ET_NO1", EH_EVAL_INFOS2[2]) ;
							gdRes.addValue( "EVAL_USER_ID1", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC1", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM1", EH_EVAL_INFOS2[4] );
							gdRes.addValue( "EVAL_DATE1", EH_EVAL_INFOS2[3] );
						}else{
							gdRes.addValue( "ET_NO1", "");
							gdRes.addValue( "EVAL_USER_ID1", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC1", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM1", "" );
							gdRes.addValue( "EVAL_DATE1", "" );
						}						
					}else{
						gdRes.addValue( "ET_NO1", "");
						gdRes.addValue( "EVAL_USER_ID1", "" );
						gdRes.addValue( "EVAL_USER_NAME_LOC1", "" );
						gdRes.addValue( "ASC_SUM1", "" );
						gdRes.addValue( "EVAL_DATE1", "" );
					}
                    
					if(CP_EVAL_USER_IDS != null && CP_EVAL_USER_IDS.length >= 2){
						CP_EVAL_USER_IDS2 = SepoaString.parser(CP_EVAL_USER_IDS[1], "$");
						EH_EVAL_INFOS2    = null;
						EH_EVAL_INFOS2 = getEH_EVAL_INFO(CP_EVAL_USER_IDS2[0], EH_EVAL_INFOS);
						if(EH_EVAL_INFOS2 != null){
							gdRes.addValue( "ET_NO2", EH_EVAL_INFOS2[2] );
							gdRes.addValue( "EVAL_USER_ID2", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC2", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM2", EH_EVAL_INFOS2[4] );
							gdRes.addValue( "EVAL_DATE2", EH_EVAL_INFOS2[3] );
						}else{
							gdRes.addValue( "ET_NO2", "");
							gdRes.addValue( "EVAL_USER_ID2", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC2", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM2", "" );
							gdRes.addValue( "EVAL_DATE2", "" );
						}						
					}else{
						gdRes.addValue( "ET_NO2", "");
						gdRes.addValue( "EVAL_USER_ID2", "" );
						gdRes.addValue( "EVAL_USER_NAME_LOC2", "" );
						gdRes.addValue( "ASC_SUM2", "" );
						gdRes.addValue( "EVAL_DATE2", "" );
					}
					
					if(CP_EVAL_USER_IDS != null && CP_EVAL_USER_IDS.length >= 3){
						CP_EVAL_USER_IDS2 = SepoaString.parser(CP_EVAL_USER_IDS[2], "$");
						EH_EVAL_INFOS2    = null;
						EH_EVAL_INFOS2 = getEH_EVAL_INFO(CP_EVAL_USER_IDS2[0], EH_EVAL_INFOS);
						if(EH_EVAL_INFOS2 != null){
							gdRes.addValue( "ET_NO3", EH_EVAL_INFOS2[2] );
							gdRes.addValue( "EVAL_USER_ID3", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC3", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM3", EH_EVAL_INFOS2[4] );
							gdRes.addValue( "EVAL_DATE3", EH_EVAL_INFOS2[3] );
						}else{
							gdRes.addValue( "ET_NO3", "");
							gdRes.addValue( "EVAL_USER_ID3", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC3", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM3", "" );
							gdRes.addValue( "EVAL_DATE3", "" );
						}						
					}else{
						gdRes.addValue( "ET_NO3", "");
						gdRes.addValue( "EVAL_USER_ID3", "" );
						gdRes.addValue( "EVAL_USER_NAME_LOC3", "" );
						gdRes.addValue( "ASC_SUM3", "" );
						gdRes.addValue( "EVAL_DATE3", "" );
					}
					
					if(CP_EVAL_USER_IDS != null && CP_EVAL_USER_IDS.length >= 4){
						CP_EVAL_USER_IDS2 = SepoaString.parser(CP_EVAL_USER_IDS[3], "$");
						EH_EVAL_INFOS2    = null;
						EH_EVAL_INFOS2 = getEH_EVAL_INFO(CP_EVAL_USER_IDS2[0], EH_EVAL_INFOS);
						if(EH_EVAL_INFOS2 != null){
							gdRes.addValue( "ET_NO4", EH_EVAL_INFOS2[2] );
							gdRes.addValue( "EVAL_USER_ID4", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC4", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM4", EH_EVAL_INFOS2[4] );
							gdRes.addValue( "EVAL_DATE4", EH_EVAL_INFOS2[3] );
						}else{
							gdRes.addValue( "ET_NO4", "");
							gdRes.addValue( "EVAL_USER_ID4", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC4", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM4", "" );
							gdRes.addValue( "EVAL_DATE4", "" );
						}
					}else{
						gdRes.addValue( "ET_NO4", "");
						gdRes.addValue( "EVAL_USER_ID4", "" );
						gdRes.addValue( "EVAL_USER_NAME_LOC4", "" );
						gdRes.addValue( "ASC_SUM4", "" );
						gdRes.addValue( "EVAL_DATE4", "" );
					}
					
					if(CP_EVAL_USER_IDS != null && CP_EVAL_USER_IDS.length >= 5){
						CP_EVAL_USER_IDS2 = SepoaString.parser(CP_EVAL_USER_IDS[4], "$");
						EH_EVAL_INFOS2    = null;
						EH_EVAL_INFOS2 = getEH_EVAL_INFO(CP_EVAL_USER_IDS2[0], EH_EVAL_INFOS);
						if(EH_EVAL_INFOS2 != null){
							gdRes.addValue( "ET_NO5", EH_EVAL_INFOS2[2] );
							gdRes.addValue( "EVAL_USER_ID5", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC5", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM5", EH_EVAL_INFOS2[4] );
							gdRes.addValue( "EVAL_DATE5", EH_EVAL_INFOS2[3] );
						}else{
							gdRes.addValue( "ET_NO5", "");
							gdRes.addValue( "EVAL_USER_ID5", CP_EVAL_USER_IDS2[0] );
							gdRes.addValue( "EVAL_USER_NAME_LOC5", CP_EVAL_USER_IDS2[1] ); 
							gdRes.addValue( "ASC_SUM5", "" );
							gdRes.addValue( "EVAL_DATE5", "" );
						}						
					}else{
						gdRes.addValue( "ET_NO5", "");
						gdRes.addValue( "EVAL_USER_ID5", "" );
						gdRes.addValue( "EVAL_USER_NAME_LOC5", "" );
						gdRes.addValue( "ASC_SUM5", "" );
						gdRes.addValue( "EVAL_DATE5", "" );
					}
					
					gdRes.addValue( "ETPL_NO", wf.getValue( "ETPL_NO", i ) );
					gdRes.addValue( "ETPL_SEQ", wf.getValue( "ETPL_SEQ", i ) );
					gdRes.addValue( "ETPL_NM", wf.getValue( "ETPL_NM", i ) );
					gdRes.addValue( "ES_CD", wf.getValue( "ES_CD", i ) );
					gdRes.addValue( "ES_VER", wf.getValue( "ES_VER", i ) );
					gdRes.addValue( "ES_NM", wf.getValue( "ES_NM", i ) );																				
				}
											
		 } catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		 }
			
	     return gdRes;
	}
	
	public static String[] getEH_EVAL_INFO(String EVAL_USER_ID, String[] EH_EVAL_INFOS)
    {
		String[] R_EH_EVAL_INFOS2 = null;
        String[] EH_EVAL_INFOS2 = null;
        
        if(EH_EVAL_INFOS != null){
	    	for(int i=0; i < EH_EVAL_INFOS.length; i++){
	        	EH_EVAL_INFOS2 = SepoaString.parser(EH_EVAL_INFOS[i], "$");
	        	if(EH_EVAL_INFOS2 != null){
	        		if(EVAL_USER_ID.equals(EH_EVAL_INFOS2[0])){
	        			R_EH_EVAL_INFOS2 = EH_EVAL_INFOS2;
	        		}
	        	}
	        }
	    }
        
        return R_EH_EVAL_INFOS2;
    }




}




