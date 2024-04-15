package sepoa.svl.contract;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
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

public class contract_wait_list extends HttpServlet
{

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
			if (mode.equals("query")) {
				gdRes = getContractWaitList(gdReq);
			} else if(mode.equals("squery")){
				gdRes = getContractWaitListInsert(gdReq);
			} else if(mode.equals("prquery")){
				gdRes = getPrContractWaitListInsert(gdReq);
			} else if(mode.equals("prmtquery")){
				gdRes = getPrMtContractWaitListInsert(gdReq);
			} else if(mode.equals("uquery")){
				gdRes = getContractCreateListUpdate(gdReq);
			} else if(mode.equals("insert")){
				gdRes = getContractInsert(gdReq);
			} else if(mode.equals("update")){
				gdRes = getContractUpdate(gdReq);
			} else if(mode.equals("setConfirm")){
				gdRes = setContractConfirm(gdReq);
			} else if(mode.equals("poCreate")){
				gdRes = setPoCreate(gdReq);
			} else if(mode.equals("changeinsert")){
				gdRes = setChangeInsert(gdReq);
			}

		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
/*			e.printStackTrace();*/
		} finally {
			try {
				OperateGridData.write(req, res, gdRes, out);
			} catch (Exception e) {
/*				e.printStackTrace();*/ mode = "";
			}
		}
	}
	
	public GridData getContractWaitList(GridData gdReq) throws Exception {
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
			SepoaOut value = ServiceConnector.doService(info, "CT_010", "CONNECTION", "getContractWaitList", obj);

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


					/*	if( rfq_type.equals("BD") )//
						{
							bd_amt_enc	= wf.getValue(grid_col_ary[k], i);
							bd_amt		= new String(JetsUtil.decodeBase64(bd_amt_enc.getBytes()));
							gdRes.addValue(grid_col_ary[k], bd_amt);
						}
						else*/
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

	public GridData getContractWaitListInsert(GridData gdReq) throws Exception {
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
			SepoaOut value = ServiceConnector.doService(info, "CT_010", "CONNECTION", "getContractWaitListInsert", obj);
			
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
	
	public GridData getPrContractWaitListInsert(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String pr_number	= JSPUtil.paramCheck(gdReq.getParam("pr_number")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "squery");
			
			// EJB CALL
			Object[] obj = { pr_number };
			SepoaOut value = ServiceConnector.doService(info, "CT_010", "CONNECTION", "getPrContractWaitListInsert", obj);
			
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
	
	public GridData getPrMtContractWaitListInsert(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String pr_number	= JSPUtil.paramCheck(gdReq.getParam("pr_number")).trim();
			String pr_seq		= JSPUtil.paramCheck(gdReq.getParam("pr_seq")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "squery");
			
			// EJB CALL
			Object[] obj = { pr_number, pr_seq };
			SepoaOut value = ServiceConnector.doService(info, "CT_010", "CONNECTION", "getPrMtContractWaitListInsert", obj);
			
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
	
	public GridData getContractCreateListUpdate(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String cont_no	   = JSPUtil.paramCheck(gdReq.getParam("cont_no")).trim();
			String cont_gl_seq = JSPUtil.paramCheck(gdReq.getParam("cont_gl_seq")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "uquery");
			
			// EJB CALL
			Object[] obj = { cont_no ,cont_gl_seq };
			SepoaOut value = ServiceConnector.doService(info, "CT_020", "CONNECTION", "getContractCreateListUpdate", obj);
			
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
	
    public GridData getContractInsert(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String exec_no				= JSPUtil.nullToEmpty(gdReq.getParam("exec_no")).trim();//����
        	
        	//System.out.println("exec_no1 : " + exec_no);
        	
        	String subject				= JSPUtil.nullToEmpty(gdReq.getParam("subject")).trim();//����
        	//String cont_gubun			= JSPUtil.nullToEmpty(gdReq.getParam("cont_gubun")).trim();//��౸��
        	String sg_type1				= JSPUtil.nullToEmpty(gdReq.getParam("sg_type1")).trim(); // 소싱그룹대분류
        	String sg_type2				= JSPUtil.nullToEmpty(gdReq.getParam("sg_type2")).trim(); // 소싱그룹중분류
        	String sg_type3				= JSPUtil.nullToEmpty(gdReq.getParam("sg_type3")).trim(); // 소싱그룹소분류
        	
        	//String property_yn			= JSPUtil.nullToEmpty(gdReq.getParam("property_yn")).trim();//�ڻ����
        	//String account_code			= JSPUtil.nullToEmpty(gdReq.getParam("account_code")).trim();//��d�ڵ�
        	//String account_name			= JSPUtil.nullToEmpty(gdReq.getParam("account_name")).trim();//��d��
        	String seller_code			= JSPUtil.nullToEmpty(gdReq.getParam("seller_code")).trim();//��ü�ڵ�
        	String seller_name			= JSPUtil.nullToEmpty(gdReq.getParam("seller_name")).trim();//��ü��
        	String sign_person_id		= JSPUtil.nullToEmpty(gdReq.getParam("sign_person_id")).trim();//������� id
        	String sign_person_name		= JSPUtil.nullToEmpty(gdReq.getParam("sign_person_name")).trim();//������� name
        	String cont_from			= JSPUtil.nullToEmpty(gdReq.getParam("cont_from")).trim();//���Ⱓ from
        	String cont_to				= JSPUtil.nullToEmpty(gdReq.getParam("cont_to")).trim();//���Ⱓ to
        	String cont_date			= JSPUtil.nullToEmpty(gdReq.getParam("cont_date")).trim();//�ۼ�����
        	String cont_add_date		= JSPUtil.nullToEmpty(gdReq.getParam("cont_add_date")).trim();//�������
        	
        	Logger.sys.println("cont_add_date1 = " + cont_add_date);
        	
        	String cont_type			= JSPUtil.nullToEmpty(gdReq.getParam("cont_type")).trim();//���~��
        	String ele_cont_flag		= JSPUtil.nullToEmpty(gdReq.getParam("ele_cont_flag")).trim();//���ڰ���ۼ�����
        	String assure_flag			= JSPUtil.nullToEmpty(gdReq.getParam("assure_flag")).trim();//�����
        	//String start_start_ins_flag	= JSPUtil.nullToEmpty(gdReq.getParam("start_start_ins_flag")).trim();//����ޱ�
        	String cont_process_flag	= JSPUtil.nullToEmpty(gdReq.getParam("cont_process_flag")).trim();//�����
        	String cont_amt				= JSPUtil.nullToEmpty(gdReq.getParam("cont_amt")).trim();//���ݾ�
        	String add_tax_flag			= JSPUtil.nullToEmpty(gdReq.getParam("add_tax_flag")).trim();
        	String cont_assure_percent	= JSPUtil.nullToEmpty(gdReq.getParam("cont_assure_percent")).trim();//��ຸ���(%)
        	String cont_assure_amt		= JSPUtil.nullToEmpty(gdReq.getParam("cont_assure_amt")).trim();//��ຸ���(��)
        	String fault_ins_percent	= JSPUtil.nullToEmpty(gdReq.getParam("fault_ins_percent")).trim();//���ں����(%)
        	String fault_ins_amt		= JSPUtil.nullToEmpty(gdReq.getParam("fault_ins_amt")).trim();//���ں����(��)
        	String fault_ins_term		= JSPUtil.nullToEmpty(gdReq.getParam("fault_ins_term")).trim();//���ں���Ⱓ
        	String pay_div_flag			= JSPUtil.nullToEmpty(gdReq.getParam("pay_div_flag")).trim();//��ޱ���
        	String bd_no				= JSPUtil.nullToEmpty(gdReq.getParam("bd_no")).trim();//����/�����ȣ
        	String bd_count				= JSPUtil.nullToEmpty(gdReq.getParam("bd_count")).trim();//����/�������
        	String amt_gubun			= JSPUtil.nullToEmpty(gdReq.getParam("amt_gubun")).trim();//�ݾױ���
        	String text_number			= JSPUtil.nullToEmpty(gdReq.getParam("text_number")).trim();//������ȣ
        	String delay_charge			= JSPUtil.nullToEmpty(gdReq.getParam("delay_charge")).trim();//��ü���2
        	//String delv_place			= JSPUtil.nullToEmpty(gdReq.getParam("delv_place")).trim();//��ǰ���
        	String remark				= JSPUtil.nullToEmpty(gdReq.getParam("remark")).trim();//���
        	String ctrl_demand_dept		= JSPUtil.nullToEmpty(gdReq.getParam("ctrl_demand_dept")).trim();//������ںμ�
        	String rfq_type				= JSPUtil.nullToEmpty(gdReq.getParam("rfq_type")).trim();
        	//String confirm_user_id		= JSPUtil.nullToEmpty(gdReq.getParam("confirm_user_id")).trim();
        	//String confirm_user_name		= JSPUtil.nullToEmpty(gdReq.getParam("confirm_user_name")).trim();
        	String pr_no 				= JSPUtil.nullToEmpty(gdReq.getParam("pr_no")).trim();
        	String cont_type1_text 	    = JSPUtil.nullToEmpty(gdReq.getParam("cont_type1_text")).trim();
        	String cont_type2_text 		= JSPUtil.nullToEmpty(gdReq.getParam("cont_type2_text")).trim();
        	String x_purchase_qty 		= JSPUtil.nullToEmpty(gdReq.getParam("x_purchase_qty")).trim();
        	String delv_place    		= JSPUtil.nullToEmpty(gdReq.getParam("delv_place")).trim();
        	String item_type    		= JSPUtil.nullToEmpty(gdReq.getParam("item_type")).trim();
        	String rd_date    			= JSPUtil.nullToEmpty(gdReq.getParam("rd_date")).trim();
        	String cont_total_gubun    	= JSPUtil.nullToEmpty(gdReq.getParam("cont_total_gubun")).trim();
        	String cont_price    		= JSPUtil.nullToEmpty(gdReq.getParam("cont_price")).trim();
        	
			gdRes.setSelectable(false);
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
						            {
						            		gdReq.getValue("ANN_ITEM",	i)
						            		,gdReq.getValue("delv_place",	i)
						            		,gdReq.getValue("bid_vendor_cnt",	i)
						            		,gdReq.getValue("ee_vendor_cnt",	i)
						            		,gdReq.getValue("join_vendor_cnt",	i)
						            		,gdReq.getValue("VENDOR_NAME",	i)
						            		,gdReq.getValue("ASUMTNAMT",	i)
						            		,gdReq.getValue("ESTM_PRICE",	i)
						            		,gdReq.getValue("FINAL_ESTM_PRICE_ENC",	i)
						            		,gdReq.getValue("SUM_AMT",	i)
						            		,gdReq.getValue("CUR",	i)
						            		,gdReq.getValue("VENDOR_CODE",	i)
						            		,gdReq.getValue("DLVRYDSREDATE",	i)
						            		

						            };

	            bean_args[i] = loop_data1;
	        }
	        Logger.sys.println("cont_add_date1-1 = " + cont_add_date);
	        Object[] obj = {
	        					subject, sg_type1,sg_type2,sg_type3, seller_code, seller_name, pr_no,
	        					sign_person_id, sign_person_name, cont_from, cont_to, cont_date,
	        					cont_add_date, cont_type, ele_cont_flag, assure_flag, 
	        					cont_process_flag, cont_amt, cont_assure_percent, cont_assure_amt, fault_ins_percent,
	        					fault_ins_amt, fault_ins_term, bd_no, bd_count,
				        		amt_gubun, text_number, delay_charge,  remark,
				        		ctrl_demand_dept, rfq_type, bean_args , cont_type1_text, cont_type2_text,
				        		x_purchase_qty, delv_place, add_tax_flag, 
				        		item_type, rd_date, cont_total_gubun, cont_price, exec_no, pay_div_flag
	        				};
	        
	    	SepoaOut value = ServiceConnector.doService(info, "CT_010", "TRANSACTION","getContractInsert", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
            
            gdRes.addParam("CONT_NO", value.result[0]);
            
        }
        catch (Exception e)
        {
        	gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "insert");
        
        return gdRes;
    }
    
    public GridData setPoCreate(GridData gdReq) throws Exception
    {
    	GridData gdRes = new GridData();
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	try
    	{
    		String po_no      		    = JSPUtil.nullToEmpty(gdReq.getParam("po_no")).trim();
    		String seller_code          = JSPUtil.nullToEmpty(gdReq.getParam("seller_code")).trim();  
    		
    		String cont_no				= JSPUtil.nullToEmpty(gdReq.getParam("cont_no")).trim();
    		String subject            	= JSPUtil.nullToEmpty(gdReq.getParam("subject")).trim(); 
    		String cont_date			= JSPUtil.nullToEmpty(gdReq.getParam("cont_add_date")).trim();
        	String cont_amt           	= JSPUtil.nullToEmpty(gdReq.getParam("cont_amt")).trim(); 
    		String sign_person_id     	= JSPUtil.nullToEmpty(gdReq.getParam("sign_person_id")).trim(); 
    		String sign_person_name   	= JSPUtil.nullToEmpty(gdReq.getParam("sign_person_name")).trim();
    		
    		String po_create_date      = SepoaDate.getShortDateString(); 
    		if( !"".equals(cont_date) ) po_create_date = cont_date;
    		String po_ttl_amt          = JSPUtil.nullToEmpty(gdReq.getParam("cont_amt")).trim();
    		String purchaser_id        = JSPUtil.nullToEmpty(gdReq.getParam("sign_person_id")).trim();  
    		String purchaser_name      = JSPUtil.nullToEmpty(gdReq.getParam("sign_person_name")).trim();
    		String demand_dept   	   = JSPUtil.nullToEmpty(gdReq.getParam("ctrl_demand_dept")).trim();
    		
    		String pay_div_flag       	= JSPUtil.nullToEmpty(gdReq.getParam("pay_div_flag")).trim(); 
    		String cont_process_flag  	= JSPUtil.nullToEmpty(gdReq.getParam("cont_process_flag")).trim();
    		String cont_gubun			= JSPUtil.nullToEmpty(gdReq.getParam("cont_gubun")).trim();
    		String qta_bd_no            = JSPUtil.nullToEmpty(gdReq.getParam("bd_no")).trim();
    		String qta_bd_count         = JSPUtil.nullToEmpty(gdReq.getParam("bd_count")).trim();
    		String cont_type          	= JSPUtil.nullToEmpty(gdReq.getParam("cont_type")).trim(); 
    		
    		
    		String[] setHdDate = { 
    								po_create_date, po_ttl_amt, purchaser_id, purchaser_name, demand_dept,
    								pay_div_flag, cont_process_flag, cont_gubun, qta_bd_no, qta_bd_count, cont_type
    							  };

    		
    		gdRes.setSelectable(false);
    		int row_count = gdReq.getRowCount();
    		String[][] bean_args = new String[row_count][];
    		
    		for (int i = 0; i < row_count; i++)
    		{
    			String[] loop_data1 =
						    			{
						    					
						    					gdReq.getValue("DESCRIPTION_LOC",	i)
						    					,gdReq.getValue("SPECIFICATION",	i)
						    					,gdReq.getValue("UNIT_MEASURE",	i)
						    					,gdReq.getValue("PR_NO",	i)
						    					,gdReq.getValue("PR_SEQ",	i)
						    					,SepoaString.getDateUnSlashFormat(gdReq.getValue("Z_DELIVERY_DATE", i))	
						    					,gdReq.getValue("SETTLE_QTY",	i)
						    					,gdReq.getValue("UNIT_PRICE",	i)
						    					,gdReq.getValue("ITEM_AMT",	i)
						    					,gdReq.getValue("DELV_PLACE",	i)
						    					,gdReq.getValue("PR_DEPT_TEXT", i)
												,gdReq.getValue("PR_USER_NAME", i)
												,gdReq.getValue("PR_USER_ID", i)
						    					,gdReq.getValue("PR_DEPT", i)
						    					,gdReq.getValue("MAKER",	i)
						    					,gdReq.getValue("YEAR_OF_MANUFACTURE",	i)
						    					,gdReq.getValue("ACCOUNTS_COURSES_CODE",	i)
						    					,gdReq.getValue("ACCOUNTS_COURSES_LOC",	i)
						    					,gdReq.getValue("ASSET_NUMBER",	i)
						    					,SepoaString.getDateUnSlashFormat(gdReq.getValue("RD_DATE", i))
						                        ,gdReq.getValue("PO_SEQ", i)
						    					,po_create_date
												,cont_no
												,subject
												,cont_amt
												,cont_date																		
												,sign_person_id
						    			};
    			
    			bean_args[i] = loop_data1;
    		}
    		
    		Object[] obj = {po_no, cont_no, seller_code, setHdDate,  bean_args };
    		SepoaOut value = ServiceConnector.doService(info, "CT_010", "TRANSACTION","setPoCreate", obj);
    		
    		if(value.flag)
    		{
    			gdRes.setMessage("���ֹ�ȣ ["+ value.result[0] +"]�� ��Ǿ�4ϴ�.");
    			gdRes.setStatus("true");
    			gdRes.addParam("CONT_NO", value.result[0]);
    		}
    		else
    		{
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
    		}
    		
    		
    		
    	}
    	catch (Exception e)
    	{
    		gdRes.setMessage(message.get("MESSAGE.1002").toString());
    		gdRes.setStatus("false");
    	}
    	
    	gdRes.addParam("mode", "setPoCreate");
    	
    	return gdRes;
    }
    
    public GridData getContractUpdate(GridData gdReq) throws Exception
    {
    	GridData gdRes = new GridData();
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	String subject				= JSPUtil.nullToEmpty(gdReq.getParam("subject")).trim();
    	//String cont_gubun			= JSPUtil.nullToEmpty(gdReq.getParam("cont_gubun")).trim();
    	String sg_type1				= JSPUtil.nullToEmpty(gdReq.getParam("sg_type1")).trim();
    	String sg_type2				= JSPUtil.nullToEmpty(gdReq.getParam("sg_type2")).trim();
    	String sg_type3				= JSPUtil.nullToEmpty(gdReq.getParam("sg_type3")).trim();
    	
    	//String property_yn			= JSPUtil.nullToEmpty(gdReq.getParam("property_yn")).trim();
    	//String account_code			= JSPUtil.nullToEmpty(gdReq.getParam("account_code")).trim();//��d�ڵ�
    	//String account_name			= JSPUtil.nullToEmpty(gdReq.getParam("account_name")).trim();//��d��
    	String seller_code			= JSPUtil.nullToEmpty(gdReq.getParam("seller_code")).trim();//��ü�ڵ�
    	String seller_name			= JSPUtil.nullToEmpty(gdReq.getParam("seller_name")).trim();//��ü��
    	String sign_person_id		= JSPUtil.nullToEmpty(gdReq.getParam("sign_person_id")).trim();//������� id
    	String sign_person_name		= JSPUtil.nullToEmpty(gdReq.getParam("sign_person_name")).trim();//������� name
    	String cont_from			= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty(gdReq.getParam("cont_from")).trim());//���Ⱓ from
    	String cont_to				= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty(gdReq.getParam("cont_to")).trim());//���Ⱓ to
    	String cont_date			= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty(gdReq.getParam("cont_date")).trim());//�ۼ�����
    	String cont_add_date		= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty(gdReq.getParam("cont_add_date")).trim());//�������
    	String cont_type			= JSPUtil.nullToEmpty(gdReq.getParam("cont_type")).trim();//���~��
    	String ele_cont_flag		= JSPUtil.nullToEmpty(gdReq.getParam("ele_cont_flag")).trim();//���ڰ���ۼ�����
    	String assure_flag			= JSPUtil.nullToEmpty(gdReq.getParam("assure_flag")).trim();//�����
    	//String start_start_ins_flag	= JSPUtil.nullToEmpty(gdReq.getParam("start_start_ins_flag")).trim();//����ޱ�
    	String cont_process_flag	= JSPUtil.nullToEmpty(gdReq.getParam("cont_process_flag")).trim();//�����
    	String cont_amt				= JSPUtil.nullToEmpty(gdReq.getParam("cont_amt")).trim();//���ݾ�
    	String add_tax_flag			= JSPUtil.nullToEmpty(gdReq.getParam("add_tax_flag")).trim();
    	
    	String cont_assure_percent	= JSPUtil.nullToEmpty(gdReq.getParam("cont_assure_percent")).trim();//��ຸ���(%)
    	String cont_assure_amt		= JSPUtil.nullToEmpty(gdReq.getParam("cont_assure_amt")).trim();//��ຸ���(��)
    	String fault_ins_percent	= JSPUtil.nullToEmpty(gdReq.getParam("fault_ins_percent")).trim();//���ں����(%)
    	String fault_ins_amt		= JSPUtil.nullToEmpty(gdReq.getParam("fault_ins_amt")).trim();//���ں����(��)
    	String pay_div_flag			= JSPUtil.nullToEmpty(gdReq.getParam("pay_div_flag")).trim();//��ޱ���
    	String fault_ins_term		= JSPUtil.nullToEmpty(gdReq.getParam("fault_ins_term")).trim();//���ں���Ⱓ
    	String bd_no				= JSPUtil.nullToEmpty(gdReq.getParam("bd_no")).trim();//����/�����ȣ
    	String bd_count				= JSPUtil.nullToEmpty(gdReq.getParam("bd_count")).trim();//����/�������
    	String amt_gubun			= JSPUtil.nullToEmpty(gdReq.getParam("amt_gubun")).trim();//�ݾױ���
    	String text_number			= JSPUtil.nullToEmpty(gdReq.getParam("text_number")).trim();//������ȣ
    	String delay_charge			= JSPUtil.nullToEmpty(gdReq.getParam("delay_charge")).trim();//��ü���2
    	//String delv_place			= JSPUtil.nullToEmpty(gdReq.getParam("delv_place")).trim();//��ǰ���
    	String remark				= JSPUtil.nullToEmpty(gdReq.getParam("remark")).trim();//���
    	String cont_no				= JSPUtil.nullToEmpty(gdReq.getParam("cont_no")).trim();//
    	//String confirm_user_id		= JSPUtil.nullToEmpty(gdReq.getParam("confirm_user_id")).trim();
    	//String confirm_user_name		= JSPUtil.nullToEmpty(gdReq.getParam("confirm_user_name")).trim();
    	String cont_gl_seq			= JSPUtil.nullToEmpty(gdReq.getParam("cont_gl_seq")).trim();//
    	String cont_type1_text		= JSPUtil.nullToEmpty(gdReq.getParam("cont_type1_text")).trim();//
    	String cont_type2_text		= JSPUtil.nullToEmpty(gdReq.getParam("cont_type2_text")).trim();//
    	String x_purchase_qty       = JSPUtil.nullToEmpty(gdReq.getParam("x_purchase_qty")).trim();
    	String delv_place    		= JSPUtil.nullToEmpty(gdReq.getParam("delv_place")).trim();//
    	String item_type    		= JSPUtil.nullToEmpty(gdReq.getParam("item_type")).trim();//
    	String rd_date    			= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty(gdReq.getParam("rd_date")).trim());//
    	String cont_total_gubun    	= JSPUtil.nullToEmpty(gdReq.getParam("cont_total_gubun")).trim();
    	String cont_price    		= JSPUtil.nullToEmpty(gdReq.getParam("cont_price")).trim();
    	
    	String before_cont_from			= JSPUtil.nullToEmpty(gdReq.getParam("before_cont_from")).trim();//���Ⱓ from
    	String before_cont_to			= JSPUtil.nullToEmpty(gdReq.getParam("before_cont_to")).trim();//���Ⱓ to
    	String before_cont_amt			= JSPUtil.nullToEmpty(gdReq.getParam("before_cont_amt")).trim();//���ݾ�
    	String before_item_type    		= JSPUtil.nullToEmpty(gdReq.getParam("before_item_type")).trim();//
    	try
    	{
    		
    		gdRes.setSelectable(false);
    		int row_count = gdReq.getRowCount();
    		String[][] bean_args = new String[row_count][];
    		
    		for (int i = 0; i < row_count; i++)
    		{
    			String[] loop_data1 =
						    			{
					    					gdReq.getValue("ANN_ITEM",	i)
						            		,gdReq.getValue("delv_place",	i)
						            		,gdReq.getValue("bid_vendor_cnt",	i)
						            		,gdReq.getValue("ee_vendor_cnt",	i)
						            		,gdReq.getValue("join_vendor_cnt",	i)
						            		,gdReq.getValue("VENDOR_NAME",	i)
						            		,gdReq.getValue("ASUMTNAMT",	i)
						            		,gdReq.getValue("ESTM_PRICE",	i)
						            		,gdReq.getValue("FINAL_ESTM_PRICE_ENC",	i)
						            		,gdReq.getValue("SUM_AMT",	i)
						            		,gdReq.getValue("CUR",	i)
						            		,gdReq.getValue("VENDOR_CODE",	i)
						            		,gdReq.getValue("DLVRYDSREDATE",	i)
						            		,gdReq.getValue("CONT_NO",	i)
						            		,gdReq.getValue("CONT_SEQ",	i)
						            		,gdReq.getValue("PR_NO",	i)
						    			};
    			
    			bean_args[i] = loop_data1;
    		}
    		
	        Object[] obj = {
					subject, sg_type1, sg_type2, sg_type3,  seller_code, seller_name,
					sign_person_id, sign_person_name, cont_from, cont_to, cont_date,
					cont_add_date, cont_type, ele_cont_flag, assure_flag, 
					cont_process_flag, cont_amt, cont_assure_percent, cont_assure_amt, fault_ins_percent,
					fault_ins_amt,  fault_ins_term, bd_no, bd_count,
	        		amt_gubun, text_number, delay_charge,  remark,
	        		cont_no,  bean_args , cont_gl_seq, cont_type1_text, cont_type2_text,
	        		delv_place, add_tax_flag, item_type, rd_date, cont_total_gubun, cont_price,
	        		before_cont_from, before_cont_to, before_cont_amt, before_item_type,pay_div_flag,
	        		x_purchase_qty
				};

	        
    		SepoaOut value = ServiceConnector.doService(info, "CT_020", "TRANSACTION","getContractUpdate", obj);
    		
    		if(value.flag)
    		{
    			gdRes.setMessage(message.get("MESSAGE.0001").toString());
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
    		gdRes.setMessage(message.get("MESSAGE.1002").toString());
    		gdRes.setStatus("false");
    	}
    	
    	gdRes.addParam("mode", "update");
    	return gdRes;
    }
    
    
    public GridData setContractConfirm(GridData gdReq) throws Exception
    {
    	GridData gdRes = new GridData();
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	String cont_no      = JSPUtil.paramCheck(gdReq.getParam("cont_no")).trim();
    	String cont_gl_seq  = JSPUtil.paramCheck(gdReq.getParam("cont_gl_seq")).trim();
    	String cont_date    = JSPUtil.paramCheck(gdReq.getParam("cont_date")).trim();
    	
    	try
    	{
			gdRes.setSelectable(false);

			Object[] obj = { cont_no, cont_date, cont_gl_seq };
    		
    		SepoaOut value = ServiceConnector.doService(info, "CT_020", "TRANSACTION","setContractConfirm", obj);
    		
    		if(value.flag)
    		{
    			gdRes.setMessage(message.get("MESSAGE.0001").toString());
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
    		gdRes.setMessage(message.get("MESSAGE.1002").toString());
    		gdRes.setStatus("false");
    	}
    	
    	gdRes.addParam("mode", "setConfirm");
    	return gdRes;
    }
    
    
    public GridData setChangeInsert(GridData gdReq) throws Exception
    {
    	GridData gdRes = new GridData();
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	String subject				= JSPUtil.nullToEmpty( gdReq.getParam("subject")			 ).trim();
    	//String cont_gubun			= JSPUtil.nullToEmpty( gdReq.getParam("cont_gubun")			 ).trim();
    	String sg_type1				= JSPUtil.nullToEmpty( gdReq.getParam("sg_type1")			 ).trim();
    	String sg_type2				= JSPUtil.nullToEmpty( gdReq.getParam("sg_type2")			 ).trim();
    	String sg_type3				= JSPUtil.nullToEmpty( gdReq.getParam("sg_type3")			 ).trim();
    	String seller_code			= JSPUtil.nullToEmpty( gdReq.getParam("seller_code")		 ).trim();
    	String seller_name			= JSPUtil.nullToEmpty( gdReq.getParam("seller_name")		 ).trim();
    	String sign_person_id		= JSPUtil.nullToEmpty( gdReq.getParam("sign_person_id")		 ).trim();
    	String sign_person_name		= JSPUtil.nullToEmpty( gdReq.getParam("sign_person_name")	 ).trim();
    	String cont_from			= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty( gdReq.getParam("cont_from")			 ).trim());
    	String cont_to				= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty( gdReq.getParam("cont_to")			 ).trim());
    	String before_cont_from		= JSPUtil.nullToEmpty( gdReq.getParam("before_cont_from")			 ).trim();
    	String before_cont_to		= JSPUtil.nullToEmpty( gdReq.getParam("before_cont_to")			 ).trim();
    	String cont_date			= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty( gdReq.getParam("cont_date")			 ).trim());
    	String cont_add_date		= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty( gdReq.getParam("cont_add_date")		 ).trim());
    	String cont_type			= JSPUtil.nullToEmpty( gdReq.getParam("cont_type")			 ).trim();
    	String ele_cont_flag		= JSPUtil.nullToEmpty( gdReq.getParam("ele_cont_flag")		 ).trim();
    	String assure_flag			= JSPUtil.nullToEmpty( gdReq.getParam("assure_flag")		 ).trim();
    	String cont_process_flag	= JSPUtil.nullToEmpty( gdReq.getParam("cont_process_flag")	 ).trim();
    	String cont_amt				= JSPUtil.nullToEmpty( gdReq.getParam("cont_amt")			 ).trim();
    	String before_cont_amt		= JSPUtil.nullToEmpty( gdReq.getParam("before_cont_amt")			 ).trim();
    	String cont_assure_percent	= JSPUtil.nullToEmpty( gdReq.getParam("cont_assure_percent") ).trim();
    	String cont_assure_amt		= JSPUtil.nullToEmpty( gdReq.getParam("cont_assure_amt")     ).trim();
    	String fault_ins_percent	= JSPUtil.nullToEmpty( gdReq.getParam("fault_ins_percent")   ).trim();
    	String fault_ins_amt		= JSPUtil.nullToEmpty( gdReq.getParam("fault_ins_amt")	     ).trim();
    	String fault_ins_term		= JSPUtil.nullToEmpty( gdReq.getParam("fault_ins_term")		 ).trim();
    	String bd_no				= JSPUtil.nullToEmpty( gdReq.getParam("bd_no")               ).trim();
    	String bd_count				= JSPUtil.nullToEmpty( gdReq.getParam("bd_count")            ).trim();
    	String amt_gubun			= JSPUtil.nullToEmpty( gdReq.getParam("amt_gubun")			 ).trim();
    	String text_number			= JSPUtil.nullToEmpty( gdReq.getParam("text_number")		 ).trim();
    	String delay_charge			= JSPUtil.nullToEmpty( gdReq.getParam("delay_charge")		 ).trim();
    	String remark				= JSPUtil.nullToEmpty( gdReq.getParam("remark")				 ).trim();
    	String ctrl_demand_dept	    = JSPUtil.nullToEmpty( gdReq.getParam("ctrl_demand_dept")	 ).trim();
    	String cont_no				= JSPUtil.nullToEmpty( gdReq.getParam("cont_no")			 ).trim();
    	String cont_gl_seq			= JSPUtil.nullToEmpty( gdReq.getParam("cont_gl_seq")		 ).trim();
    	String rfq_type  			= JSPUtil.nullToEmpty( gdReq.getParam("rfq_type")		     ).trim();
    	String cont_type1_text  	= JSPUtil.nullToEmpty( gdReq.getParam("cont_type1_text")	 ).trim();
    	String cont_type2_text  	= JSPUtil.nullToEmpty( gdReq.getParam("cont_type2_text")	 ).trim();
    	String delv_place  			= JSPUtil.nullToEmpty( gdReq.getParam("delv_place")	 ).trim();
    	String item_type  			= JSPUtil.nullToEmpty( gdReq.getParam("item_type")	 ).trim();
    	String before_item_type  	= JSPUtil.nullToEmpty( gdReq.getParam("before_item_type")	 ).trim();
    	String before_rd_date  		= JSPUtil.nullToEmpty( gdReq.getParam("before_rd_date")	 ).trim();
    	String rd_date  			= SepoaString.getDateUnSlashFormat(JSPUtil.nullToEmpty( gdReq.getParam("rd_date")	 ).trim());
    	String cont_total_gubun  	= JSPUtil.nullToEmpty( gdReq.getParam("cont_total_gubun")	 ).trim();
    	String cont_price  			= JSPUtil.nullToEmpty( gdReq.getParam("cont_price")	 ).trim();
    	String ttl_item_qty  		= JSPUtil.nullToEmpty( gdReq.getParam("ttl_item_qty")	 ).trim();
    	String exec_no  			= JSPUtil.nullToEmpty( gdReq.getParam("exec_no")	 ).trim();
    	String add_tax_flag			= JSPUtil.nullToEmpty(gdReq.getParam("add_tax_flag")).trim();  //부가세포함 / 면세    	
    	try
    	{
    		gdRes.setSelectable(false);
    		int row_count        = gdReq.getRowCount();
    		String[][] bean_args = new String[row_count][];
    		
    		for ( int i = 0; i < row_count; i++ ) {
    			String[] loop_data1 =
						    			{
					    					 gdReq.getValue("ANN_ITEM"             ,	i)
						            		,gdReq.getValue("delv_place"           ,	i)
						            		,gdReq.getValue("bid_vendor_cnt"       ,	i)
						            		,gdReq.getValue("ee_vendor_cnt"  	   ,	i)
						            		,gdReq.getValue("join_vendor_cnt"	   ,	i)
						            		,gdReq.getValue("VENDOR_NAME"          ,	i)
						            		,gdReq.getValue("ASUMTNAMT"            ,	i)
						            		,gdReq.getValue("ESTM_PRICE"     	   ,	i)
						            		,gdReq.getValue("FINAL_ESTM_PRICE_ENC" ,	i)
						            		,gdReq.getValue("SUM_AMT"              ,	i)
						            		,gdReq.getValue("CUR"                  ,	i)
						            		,gdReq.getValue("VENDOR_CODE"          ,	i)
						            		,gdReq.getValue("DLVRYDSREDATE"        ,	i)
						            		,gdReq.getValue("CONT_NO"              ,	i)
						            		,gdReq.getValue("CONT_SEQ"             ,	i)
						            		,gdReq.getValue("PR_NO"                ,	i)
						    			};
    			
    			bean_args[i] = loop_data1;
    		}
    		
	        Object[] obj = {
					subject, seller_code, seller_name,
					sign_person_id, sign_person_name, cont_from, cont_to, cont_date,
					cont_add_date, cont_type, ele_cont_flag, assure_flag, 
					cont_process_flag, cont_amt, cont_assure_percent, cont_assure_amt, fault_ins_percent,
					fault_ins_amt,  fault_ins_term, bd_no, bd_count,
	        		amt_gubun, text_number, delay_charge,  remark,
	        		cont_no,  bean_args, ctrl_demand_dept, cont_gl_seq, rfq_type, cont_type1_text, cont_type2_text,
	        		delv_place, item_type, before_item_type, rd_date, cont_total_gubun, cont_price,
	        		before_cont_from, before_cont_to, before_cont_amt, ttl_item_qty,
	        		sg_type1, sg_type2, sg_type3, before_rd_date, exec_no, add_tax_flag
				};
    		
    		SepoaOut value = ServiceConnector.doService(info, "CT_020", "TRANSACTION","setChangeInsert", obj);
    		
    		if(value.flag)
    		{
    			gdRes.setMessage(message.get("MESSAGE.0001").toString());
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
    		gdRes.setMessage(message.get("MESSAGE.1002").toString());
    		gdRes.setStatus("false");
    	}
    	
    	gdRes.addParam("mode", "update");
    	return gdRes;
    }
        
}
