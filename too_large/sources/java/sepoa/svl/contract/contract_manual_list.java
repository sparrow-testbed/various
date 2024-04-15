package sepoa.svl.contract;

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
import tradesign.crypto.provider.JeTS;
import tradesign.crypto.cert.*;
import tradesign.pki.pkix.*;
import tradesign.crypto.MessageDigest;
import tradesign.pki.util.JetsUtil;

@SuppressWarnings("serial")
public class contract_manual_list extends HttpServlet {
	private static SepoaInfo info;

	public void init(ServletConfig config) throws ServletException {
		//System.out.println("Servlet call");
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
			String rawData = req.getParameter("WISEGRID_DATA");
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
			//System.out.println("mode="+mode);
			if (mode.equals("query")) {
				gdRes = getContractList(gdReq);
			} else if(mode.equals("delete")){
				gdRes = getContractDelete(gdReq);
			} else if(mode.equals("query2")){
				gdRes = getContractList2(gdReq);
			} else if(mode.equals("insert2")){
				gdRes = getContractInsert2(gdReq);			
			} else if(mode.equals("update2")){
				gdRes = getContractUpdate2(gdReq);
			} else if(mode.equals("delete2")){
				gdRes = getContractDelete2(gdReq);
			} 
		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
/*			e.printStackTrace();*/
		} finally {
			try {
				OperateGridData.write(req, res, gdRes, out);
			} catch (Exception e) {
				Logger.err.println("contract_manual_list: = " + e.getMessage());
			}
		}
	}
	
	public GridData getContractList(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {

   			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); 
   			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "getContractList");
   			
   			Object[] obj = {data};
   			SepoaOut value = ServiceConnector.doService(info, "MAN_001", "CONNECTION", "getContractList", obj);

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
            
            Config conf = new Configuration ( ) ;
            String POASRM_CONTEXT_NAME = conf.getString ( "sepoa.context.name" ) ;
            for ( int i = 0 ; i < rowCount ; i ++ ) {
                for ( int k = 0 ; k < grid_col_ary.length ; k ++ ) {
                    if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "SELECTED" ) ) {
                        gdRes.addValue ( "SELECTED" , "0" ) ;
                    }
                    else if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "PRE_FILE_NO_IMG" ) ) {
                        if ( "".equals(wf.getValue ( "PRE_FILE_NO" , i ).trim ( ) ) ) {
                            gdRes.addValue ( "PRE_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/blank.gif") ;
                        } else {
                            if ( "".equals ( wf.getValue ( "PRE_INS_PATH" , i ).trim ( ) ) ) {
                                gdRes.addValue ( "PRE_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" ) ;
                            } else {
                                gdRes.addColorValue ( "PRE_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" , "#F2FFF5" ) ;
                            }
                        }
                    }
                    else if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "CONT_FILE_NO_IMG" ) ) {
                        if ( "".equals(wf.getValue ( "CONT_FILE_NO" , i ).trim ( ) ) ) {
                            gdRes.addValue ( "CONT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/blank.gif") ;
                        } else {
                            if ( "".equals ( wf.getValue ( "CONT_INS_PATH" , i ).trim ( ) ) ) {
                                gdRes.addValue ( "CONT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" ) ;
                            } else {
                                gdRes.addColorValue ( "CONT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" , "#F2FFF5" ) ;
                            }
                        }
                    }
                    else if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "FAULT_FILE_NO_IMG" ) ) {
                        if ( "".equals(wf.getValue ( "FAULT_FILE_NO" , i ).trim ( ) ) ) {
                            gdRes.addValue ( "FAULT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/blank.gif") ;
                        } else {
                            if ( "".equals ( wf.getValue ( "FAULT_INS_PATH" , i ).trim ( ) ) ) {
                                gdRes.addValue ( "FAULT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" ) ;
                            } else {
                                gdRes.addColorValue ( "FAULT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" , "#F2FFF5" ) ;
                            }
                        }
                    } else {
                        gdRes.addValue ( grid_col_ary [ k ] , wf.getValue ( grid_col_ary [ k ] , i ) ) ;
                    }
                }
            }
            
        } catch ( Exception e ) {
            
            gdRes.setMessage ( message.get ( "MESSAGE.1002" ).toString ( ) ) ;
            gdRes.setStatus ( "false" ) ;
        }

		return gdRes;
	}
	public GridData getContractDelete(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

		try {
			gdRes.addParam("mode", "setPoInsert");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			Map<String,String> header = MapUtils.getMap(data,"headerData");
			SepoaOut value = ServiceConnector.doService(info, "MAN_001", "TRANSACTION","getContractDelete", obj);
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
	 
	
	
	public GridData getContractList2(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			String from_date		= JSPUtil.paramCheck(gdReq.getParam("from_date")).trim();
			String to_date			= JSPUtil.paramCheck(gdReq.getParam("to_date")).trim();
			String ctrl_person_id	= JSPUtil.paramCheck(gdReq.getParam("ctrl_person_id")).trim();
			String subject		    = JSPUtil.paramCheck(gdReq.getParam("subject")).trim();
			String seller_code		= JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");

			// EJB CALL
			Object[] obj = { from_date, to_date,  ctrl_person_id, subject, seller_code};
			SepoaOut value = ServiceConnector.doService(info, "MAN_001", "CONNECTION", "getContractList2", obj);

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
			String bd_amt = "";
			String bd_amt_enc = "";
			String rfq_type = "";
			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONTRACT_DATE")) {
						gdRes.addValue("CONTRACT_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RFQ_TYPE")) {
						
						rfq_type = wf.getValue(grid_col_ary[k], i);

						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONTRACT_AMT")) {

						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					
					}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
/*			e.printStackTrace();*/
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}

	public GridData getContractInsert2(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String rfq_number	= JSPUtil.paramCheck(gdReq.getParam("rfq_number")).trim();
			String rfq_count	= JSPUtil.paramCheck(gdReq.getParam("rfq_count")).trim();
			String seller_code	= JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
			String rfq_type		= JSPUtil.paramCheck(gdReq.getParam("rfq_type")).trim();
			String bd_kind		= JSPUtil.paramCheck(gdReq.getParam("bd_kind")).trim();
			String pr_no		= JSPUtil.paramCheck(gdReq.getParam("pr_no")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "squery");
			
			// EJB CALL
			Object[] obj = { rfq_number, rfq_count, seller_code, rfq_type, bd_kind, pr_no};
			SepoaOut value = ServiceConnector.doService(info, "MAN_001", "CONNECTION", "getContractInsert2", obj);
			
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
			
			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "1");
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
						gdRes.addValue("RD_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	
	public GridData getContractUpdate2(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String rfq_number	= JSPUtil.paramCheck(gdReq.getParam("rfq_number")).trim();
			String rfq_count	= JSPUtil.paramCheck(gdReq.getParam("rfq_count")).trim();
			String seller_code	= JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
			String rfq_type		= JSPUtil.paramCheck(gdReq.getParam("rfq_type")).trim();
			String bd_kind		= JSPUtil.paramCheck(gdReq.getParam("bd_kind")).trim();
			String pr_no		= JSPUtil.paramCheck(gdReq.getParam("pr_no")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "squery");
			
			// EJB CALL
			Object[] obj = { rfq_number, rfq_count, seller_code, rfq_type, bd_kind, pr_no};
			SepoaOut value = ServiceConnector.doService(info, "MAN_001", "CONNECTION", "getContractUpdate2", obj);
			
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
			
			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "1");
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
						gdRes.addValue("RD_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	
	public GridData getContractDelete2(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String rfq_number	= JSPUtil.paramCheck(gdReq.getParam("rfq_number")).trim();
			String rfq_count	= JSPUtil.paramCheck(gdReq.getParam("rfq_count")).trim();
			String seller_code	= JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
			String rfq_type		= JSPUtil.paramCheck(gdReq.getParam("rfq_type")).trim();
			String bd_kind		= JSPUtil.paramCheck(gdReq.getParam("bd_kind")).trim();
			String pr_no		= JSPUtil.paramCheck(gdReq.getParam("pr_no")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "squery");
			
			// EJB CALL
			Object[] obj = { rfq_number, rfq_count, seller_code, rfq_type, bd_kind, pr_no};
			SepoaOut value = ServiceConnector.doService(info, "MAN_001", "CONNECTION", "getContractDelete2", obj);
			
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
			
			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "1");
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
						gdRes.addValue("RD_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	
	 
        
}
