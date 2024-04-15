package sepoa.svl.admin;

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
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class mat_sskind_list extends HttpServlet {

	private static SepoaInfo info;

	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		info = sepoa.fw.ses.SepoaSession.getAllValue(req);

		GridData gdReq = new GridData();
		GridData gdRes = new GridData();
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		String mode = "";
		PrintWriter out = res.getWriter();

		try {
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if ("doQuery".equals(mode)) {
				gdRes = doQuery(gdReq);		
			}
			else if ("doRegist".equals(mode)) {
				gdRes = doRegist(gdReq);	
			}
			else if("doDelete".equals(mode)){
				gdRes = doDelete(gdReq);
			}
			else if("doUpdate".equals(mode)){
				gdRes = doUpdate(gdReq);
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
	
	
	public GridData doQuery(GridData gdReq) throws Exception {
			GridData gdRes = new GridData();
			int rowCount = 0;
			SepoaFormater wf = null;

            //20131211 sendakun
            HashMap message = MessageUtil.getMessageMap( info, "MESSAGE","BUTTON", "AD_106" );

			Config conf = new Configuration();
			String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");

	        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵
	        Map< String, String >   headerData  = null; // Header 데이터 받을 맵
		try {

        	allData = SepoaDataMapper.getData( info, gdReq );
            headerData = MapUtils.getMap( allData, "headerData" );
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("cols_ids")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			
			//String LKIND = JSPUtil.nullToEmpty(gdReq.getParam("LKIND")).trim();
			//String CKIND = JSPUtil.nullToEmpty(gdReq.getParam("CKIND")).trim();
			//String SKIND = JSPUtil.nullToEmpty(gdReq.getParam("SKIND")).trim();

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");

			
			// EJB CALL
			//Object[] obj = {LKIND,CKIND,SKIND};
			Object[] obj = {allData};
			SepoaOut value = ServiceConnector.doService(info, "AD_106", "CONNECTION", "doQuery", obj);

			if (value.flag) {
                gdRes.setMessage(message.get("AD_106.TITLE").toString());
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

			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("USE_FLAG")) {
						if( sepoa.fw.util.CommonUtil.Flag.Yes.getValue().equals(wf.getValue(grid_col_ary[k], i)) ){
							gdRes.addValue("USE_FLAG", "1");
						}
						else {
							gdRes.addValue("USE_FLAG", "0");
						}
					}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("LKIND_SELECT")){
                    	gdRes.addValue("LKIND_SELECT", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
					}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CKIND_SELECT")){
                    	gdRes.addValue("CKIND_SELECT", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
					}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SKIND_SELECT")){
                    	gdRes.addValue("SKIND_SELECT", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");		
					}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
			gdRes.setStatus("false");
		}

		return gdRes;
	}
	
	public GridData doRegist(GridData gdReq) throws Exception {

		GridData gdRes = new GridData();

        //20131211 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

        Map< String, Object > allData     = null;
        Map< String, String > headerData  = null;
		try {
			gdRes.setSelectable(false);
            allData     = SepoaDataMapper.getData( info, gdReq );
			/**
			int row_count = gdReq.getRowCount();
			String[][] bean_args = new String[row_count][];
			
			
			for (int i = 0; i < row_count; i++) {
				String[] loop_data1 = { 
						gdReq.getValue("USE_FLAG", i)		
						,gdReq.getValue("LKIND", i)	
						,gdReq.getValue("CKIND", i)
						,gdReq.getValue("SKIND", i)
						,gdReq.getValue("SSKIND", i)
						,gdReq.getValue("SSKIND_TXT", i)
				};
				bean_args[i] = loop_data1;
			}
			
			Object[] obj = {bean_args};
			**/
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "AD_106", "TRANSACTION", "doRegist", obj);
			
			if (value.flag) {
				if ("".equals(value.message.trim())) {
				    //성공적으로 처리 하였습니다.
					gdRes.setMessage(message.get("MESSAGE.0001").toString());
				} else {
					gdRes.setMessage(value.message);
				}
				gdRes.setStatus("true");
			} else {
				if ("".equals(value.message.trim())) {
				    gdRes.setMessage(message.get("MESSAGE.0084").toString()); //인터페이스중 오류가 발생했습니다.
				} else {
					gdRes.setMessage(value.message);
				}
				gdRes.setStatus("false");
			}
			
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
			gdRes.setStatus("false");
		}
		return gdRes;
	}
	
	
	public GridData doDelete(GridData gdReq) throws Exception {

		GridData gdRes = new GridData();
		
        //20131211 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

        Map< String, Object > allData     = null;
        Map< String, String > headerData  = null;
		try {
			gdRes.setSelectable(false);
            allData     = SepoaDataMapper.getData( info, gdReq );
			/**
			int row_count = gdReq.getRowCount();
			String[][] bean_args = new String[row_count][];
			
			
			for (int i = 0; i < row_count; i++) {
				String[] loop_data1 = { 
						gdReq.getValue("USE_FLAG", i)		
						,gdReq.getValue("LKIND", i)	
						,gdReq.getValue("CKIND", i)
						,gdReq.getValue("SKIND", i)
						,gdReq.getValue("SSKIND", i)
						,gdReq.getValue("SSKIND_TXT", i)    
				};
				bean_args[i] = loop_data1;
			}
			
			Object[] obj = {bean_args};
			**/
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "AD_106", "TRANSACTION", "doDelete", obj);
			
			if (value.flag) {
				if ("".equals(value.message.trim())) {
					gdRes.setMessage(message.get("MESSAGE.0001").toString()); //성공적으로 처리하였습니다
				} else {
					gdRes.setMessage(value.message);
				}
				gdRes.setStatus("true");
			} else {
				if ("".equals(value.message.trim())) {
				    gdRes.setMessage(message.get("MESSAGE.0084").toString()); //인터페이스중 오류가 발생했습니다.
				} else {
					gdRes.setMessage(value.message);
				}
				gdRes.setStatus("false");
			}
			
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
			gdRes.setStatus("false");
		}
		return gdRes;
	}
	
	
	
	
	
	public GridData doUpdate(GridData gdReq) throws Exception {

		GridData gdRes = new GridData();
        //20131211 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

        Map< String, Object > allData     = null;
        Map< String, String > headerData  = null;
		try {
			gdRes.setSelectable(false);
            allData     = SepoaDataMapper.getData( info, gdReq );
			/**
			int row_count = gdReq.getRowCount();
			String[][] bean_args = new String[row_count][];
			
			
			for (int i = 0; i < row_count; i++) {
				String[] loop_data1 = { 
						gdReq.getValue("USE_FLAG", i)		
						,gdReq.getValue("LKIND", i)	
						,gdReq.getValue("CKIND", i)
						,gdReq.getValue("SKIND", i)
						,gdReq.getValue("SSKIND", i)
						,gdReq.getValue("SSKIND_TXT", i)
				};
				bean_args[i] = loop_data1;
			}
			
			Object[] obj = {bean_args};
			**/
            Object[] obj = { allData };
			SepoaOut value = ServiceConnector.doService(info, "AD_106", "TRANSACTION", "doUpdate", obj);
			
			if (value.flag) {
				if ("".equals(value.message.trim())) {
					gdRes.setMessage(message.get("MESSAGE.0001").toString()); //성공적으로 처리하였습니다
				} else {
					gdRes.setMessage(value.message);
				}
				gdRes.setStatus("true");
			} else {
				if ("".equals(value.message.trim())) {
				    gdRes.setMessage(message.get("MESSAGE.0084").toString()); //인터페이스중 오류가 발생했습니다.
				} else {
					gdRes.setMessage(value.message);
				}
				gdRes.setStatus("false");
			}
			
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
			gdRes.setStatus("false");
		}
		return gdRes;
	}
	
	
	
	
}

