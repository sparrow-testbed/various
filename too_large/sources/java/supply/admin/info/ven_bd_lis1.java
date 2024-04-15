/**
 *========================================================
 *Copyright(c) 2010 ICOMPIA
 *
 *@File       : ven_bd_lis1.java
 *
 *@FileName   : �ſ�����Ȳ
 *
 *Open Issues :
 *
 *Change history  : 
 *@LastModifyDate : 2010. 06. 24
 *@LastModifier   : ICOMPIA
 *@LastVersion    : V 1.0.0
 *=========================================================
 */

package supply.admin.info;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ven_bd_lis1 extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	public void init(javax.servlet.ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }
    

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	SepoaFormater sf = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getVendorEvalList".equals(mode)){ 
    			gdRes = this.getVendorEvalList(gdReq, info);
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
    

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getVendorEvalList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	
	    	header.put( "FROM_DATE ".trim() , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "FROM_DATE ".trim(), "" ) ) );
	    	header.put( "TO_DATE   ".trim() , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "TO_DATE   ".trim(), "" ) ) );
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "s6006", "CONNECTION", "getVendorEvalList", obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			else{
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
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
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}       
    
//
//	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
//		/*
//		XecureHttp xecure = new XecureHttp();
//    	ArrayList xecureList = xecure.xecureRequest(req, res);
//    	
//    	req = (HttpServletRequest)xecureList.get(0);
//    	res = (HttpServletResponse)xecureList.get(1);
//    	XecureServlet xservlet = (XecureServlet)xecureList.get(2);
//    	*/
//		
//		req.setCharacterEncoding("utf-8");
//		res.setContentType("text/html; charset=utf-8");
//		info = WiseSession.getAllValue(req);
//
//		GridData gdReq = new GridData();
//		GridData gdRes = new GridData();
//		PrintWriter out = res.getWriter();
//
//		try {
//			String rawData = req.getParameter("WISEGRID_DATA");
//			gdReq = OperateGridData.parse(rawData);
//			String mode = JspUtil.CheckInjection(gdReq.getParam("mode"));
//
//			if (mode.equals("getVendorEvalList")) {
//				gdRes = getStaServiceContList(gdReq);  //�������� �����Ȳ
//			}
//			
//		} catch (Exception e) {
//			gdRes.setMessage("Error: " + e.getMessage());
//			gdRes.setStatus("false");
//			e.printStackTrace();
//		} finally {
//			try {
//				//OperateGridData.write(gdRes, sw);
//				OperateGridData.write(gdRes, out);
//    			//System.out.println("====> ������ ����� Ŭ���̾�Ʈ���� �ѱ� �� : " + "WISEGRID_DATA=" + sw.toString());
//    			//out.write("WISEGRID_DATA=" + xservlet.csEncrypt(sw.toString()));
//    			//System.out.println("====> ������ ��� ��ȣȭ�Ͽ� Ŭ���̾�Ʈ���� �ѱ� �� : " + xservlet.csEncrypt(sw.toString()));
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//		}
//	}
//	
//	// �ſ�����Ȳ
//	private GridData getStaServiceContList(GridData gdReq) throws Exception {   //getUserAuthoMgt
//		GridData gdRes = new GridData();
//
//		try {
//			String from_date			= JspUtil.CheckInjection(gdReq.getParam("from_date"));
//			String to_date				= JspUtil.CheckInjection(gdReq.getParam("to_date"));
//			String vendor_code			= JspUtil.CheckInjection(gdReq.getParam("vendor_code"));
//			String vendor_name_loc		= JspUtil.CheckInjection(gdReq.getParam("vendor_name_loc"));
//
//			gdRes = OperateGridData.cloneResponseGridData(gdReq);
//			gdRes.addParam("mode", "getVendorEvalList");
//
//			String args[] = { from_date, to_date, vendor_name_loc, vendor_code};
//			Object[] param = { args };
//
//			WiseOut value = null;
//			WiseRemote ws = null;
//
//			try {
//				ws = new wise.util.WiseRemote("s6006", "CONNECTION", info);
//				value = ws.lookup("getVendorEvalList", param);
//			} catch (Exception e) {
//
//			} finally {
//				try {
//					ws.Release();
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//
//			try{
//				if (value.status == 0) { // false
//					gdRes.setMessage(value.message);
//					gdRes.setStatus("false");
//					return gdRes;
//				} else {
//					gdRes.setMessage(value.message);
//					gdRes.setStatus("true");
//				}				
//			}catch(NullPointerException ne){
//				ne.printStackTrace();
//			}
//
//			WiseFormater wf = new WiseFormater(value.result[0]);
//			int rowCount = wf.getRowCount();
//
//			if (rowCount == 0) {
//				gdRes.setMessage("��ȸ�� ���� ����ϴ�.");
//				return gdRes;
//			}
//
//			for (int i = 0; i < rowCount; i++) {
//				gdRes.getHeader("E_DATE").addValue(wf.getValue("E_DATE", i), "");
//				gdRes.getHeader("BIZ_NO").addValue(wf.getValue("BIZ_NO", i), "");
//				gdRes.getHeader("CORP_NO").addValue(wf.getValue("CORP_NO", i), "");
//				gdRes.getHeader("CMP_NM").addValue(wf.getValue("CMP_NM", i), "");
//				gdRes.getHeader("MGR_NM").addValue(wf.getValue("MGR_NM", i), "");
//				gdRes.getHeader("ESTAB_YMD").addValue(wf.getValue("ESTAB_YMD", i), "");
//				gdRes.getHeader("UTEL").addValue(wf.getValue("UTEL", i), "");
//				gdRes.getHeader("UFAX").addValue(wf.getValue("UFAX", i), "");
//				gdRes.getHeader("UZIP_CD").addValue(wf.getValue("UZIP_CD", i), "");
//				gdRes.getHeader("UADDR").addValue(wf.getValue("UADDR", i), "");
//				gdRes.getHeader("BANK_NM").addValue(wf.getValue("BANK_NM", i), "");
//				gdRes.getHeader("LASTGRD2").addValue(wf.getValue("LASTGRD2", i), "");
//				gdRes.getHeader("CASH_GRADE").addValue(wf.getValue("CASH_GRADE", i), "");
//				gdRes.getHeader("MON_GRADE").addValue(wf.getValue("MON_GRADE", i), "");
//				gdRes.getHeader("DNBGRD").addValue(wf.getValue("DNBGRD", i), "");
//				gdRes.getHeader("BZ_TYP").addValue(wf.getValue("BZ_TYP", i), "");
//				gdRes.getHeader("BZ_CND").addValue(wf.getValue("BZ_CND", i), "");
//				gdRes.getHeader("TYP").addValue(wf.getValue("TYP", i), "");
//			}
//			return gdRes;
//		} catch (Exception e) {
//			gdRes.setMessage("Error: " + e.getMessage());
//			gdRes.setStatus("false");
//			e.printStackTrace();
//		}
//		return gdRes;
//	}
}
