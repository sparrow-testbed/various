package sepoa.svl.sourcing;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rfq_req_sellersel_left extends HttpServlet {

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
			String rawData = req.getParameter("WISEGRID_DATA");
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
 
			if ("query".equals(mode)) {
				gdRes = getRfqVedorList(gdReq);
			} else if ("bottomQuery".equals(mode)) {
                gdRes = getBottomSupiList(gdReq);
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
	
	public GridData getRfqVedorList(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;

        //20131209 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

		try {
		    String seller_code = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "seller_code".trim() ) ) ).trim();
		    String name_loc    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "name_loc   ".trim() ) ) ).trim();
		    String type        = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "type       ".trim() ) ) ).trim();
		    String sg_code1    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "sg_code1   ".trim() ) ) ).trim();
		    String sg_code2    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "sg_code2   ".trim() ) ) ).trim();
		    String sg_code3    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "sg_code3   ".trim() ) ) ).trim();
		    String sg_code4    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "sg_code4   ".trim() ) ) ).trim();
		    String sg_code5    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "sg_code5   ".trim() ) ) ).trim();
		    String gp_code1    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "gp_code1   ".trim() ) ) ).trim();
		    String gp_code2    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "gp_code2   ".trim() ) ) ).trim();
		    String company_code    = JSPUtil.paramCheck ( JSPUtil.nullToEmpty ( gdReq.getParam ( "company_code   ".trim() ) ) ).trim();
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            name_loc = URLDecoder.decode( name_loc, "UTF-8" );


			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");
			
			HashMap < String , String > hashMap = new HashMap < String , String > ( );
			hashMap.put ( "seller_code".trim() , seller_code );
			hashMap.put ( "name_loc   ".trim() , name_loc    );
			hashMap.put ( "type       ".trim() , type        );
			hashMap.put ( "sg_code1   ".trim() , sg_code1    );
			hashMap.put ( "sg_code2   ".trim() , sg_code2    );
			hashMap.put ( "sg_code3   ".trim() , sg_code3    );
			hashMap.put ( "sg_code4   ".trim() , sg_code4    );
			hashMap.put ( "gp_code1   ".trim() , gp_code1    );
			hashMap.put ( "gp_code2   ".trim() , gp_code2    );
			hashMap.put ( "company_code   ".trim() , company_code    );

			// EJB CALL
			Object[] obj = { hashMap };
			SepoaOut value = ServiceConnector.doService(info, "PU_112", "CONNECTION", "getRfqVedorList", obj);

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
						gdRes.addValue("SELECTED", "0");
					} else {
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
	
	public GridData getBottomSupiList(GridData gdReq) throws Exception {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;

        //20131209 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

        try {
            String seller_code  = JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim().replaceAll ( "&#64;" , "@" );
            String rfq_no       = JSPUtil.paramCheck(gdReq.getParam("rfq_no")).trim();
            String rfq_count    = JSPUtil.paramCheck(gdReq.getParam("rfq_count")).trim();
            String sel_flag    = JSPUtil.paramCheck(gdReq.getParam("sel_flag")).trim();
            String method = "getBottomSupiList";
            
            if("BID".equals(sel_flag)) {method = "getBottomSupiList2";}
            
            String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
            String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            // EJB CALL
            Object[] obj = { seller_code , rfq_no , rfq_count, sel_flag };
            SepoaOut value = ServiceConnector.doService(info, "PU_112", "CONNECTION", method, obj);

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
                        if(wf.getValue ( "SUPI_ID", i ).indexOf ( wf.getValue ( "USER_SEQ", i ) ) != -1 ){
                            gdRes.addValue("SELECTED", "1");
                        }else{
                            gdRes.addValue("SELECTED", "0");
                        }
                    } else if (grid_col_ary[k] != null && grid_col_ary[k].equals("MOBILE_NO") ) {
                        gdRes.addValue("MOBILE_NO", SepoaString.decString ( wf.getValue(grid_col_ary[k], i) , "PHONE" ) );
                    } else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EMAIL") ) {
                        gdRes.addValue("EMAIL"    , SepoaString.decString ( wf.getValue(grid_col_ary[k], i) , "EMAIL" ) ) ;
                    } else {
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
 
}
