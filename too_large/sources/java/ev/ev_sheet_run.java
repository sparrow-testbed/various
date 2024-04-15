package ev;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaString;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;


@SuppressWarnings("serial")
public class ev_sheet_run extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
//        System.out.println("Servlet call");
    	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
	{
		doPost(req, res);
	}

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
        info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        String mode = "";
        PrintWriter out = res.getWriter();
        

        try
        {
            String rawData = req.getParameter("WISEGRID_DATA");
            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            String kor_value = JSPUtil.CheckInjection(gdReq.getParam("kor_value"));
            
//            System.out.println("kor_value]"+kor_value);

            if ("query".equals(mode))
            {
                gdRes = a_24_list(gdReq);
            }else if ("query_pop".equals(mode))
            {
                gdRes = a_24_pop_list(gdReq);
            }else if ("doScore_Cal".equals(mode))
            {
                gdRes = a_24_doScore_Cal(gdReq);
            }else if ("insert".equals(mode))
            {
                gdRes = a_24_insert(gdReq);
            }else if ("cancel".equals(mode))
            {
                gdRes = a_24_cancel(gdReq);
            }
            
            
            
           
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
//            e.printStackTrace();
        }
        finally
        {
            try
            {
                OperateGridData.write(req, res, gdRes, out);
            }
            catch (Exception e)
            {
//                e.printStackTrace();
            	Logger.debug.println();
            }
        }
    }

    public GridData a_24_list(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        Hashtable ht = null;

        try
        {
        	String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();

        	
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            //EJB CALL
	        Object[] obj = { ev_no};
	    	SepoaOut value = ServiceConnector.doService(info, "WO_024", "CONNECTION","a_24_list", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            for (int i = 0; i < arr_list.size(); i++)
            {
            	ht = (Hashtable) arr_list.get(i);	//hashtable형태로
            	
            	 gdRes.addParam("SHEET_KIND", (String)ht.get("SHEET_KIND"));
            	 gdRes.addParam("SG_KIND", (String)ht.get("SG_KIND"));
            	 gdRes.addParam("PERIOD", (String)ht.get("PERIOD"));
            	 gdRes.addParam("USE_FLAG", (String)ht.get("USE_FLAG"));
            	 gdRes.addParam("EV_YEAR", (String)ht.get("EV_YEAR"));
            	 gdRes.addParam("SHEET_STATUS", (String)ht.get("SHEET_STATUS"));
            	 gdRes.addParam("ST_DATE" , SepoaString.getDateSlashFormat( (String)ht.get("ST_DATE") ));
            	 gdRes.addParam("END_DATE", SepoaString.getDateSlashFormat( (String)ht.get("END_DATE") ));
            }
            
            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();
            
            if (rowCount == 0)
            {
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            
            for (int i = 0; i < rowCount; i++)
            {
            	for(int k=0; k < grid_col_ary.length; k++)
                {
            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected")) {
                		gdRes.addValue("selected", "0");
                	}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("EV_DATE") ){
            			gdRes.addValue("EV_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("ST_DATE") ){
            			gdRes.addValue("ST_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("ET_DATE") ){
            			gdRes.addValue("ET_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}            		
            		else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }
        }
        catch (Exception e)
        {
//        	System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }

  
    
    public GridData a_24_pop_list(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
            String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
            String seller_code = JSPUtil.CheckInjection(gdReq.getParam("seller_code")).trim();
            String sg_regitem = JSPUtil.CheckInjection(gdReq.getParam("sg_regitem")).trim();
            String ev_date    = JSPUtil.CheckInjection(gdReq.getParam("ev_date")).trim();
            String reg_date_2    = JSPUtil.CheckInjection(gdReq.getParam("reg_date_2")).trim();
            String eval_id    = JSPUtil.CheckInjection(gdReq.getParam("eval_id")).trim();
            
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            //EJB CALL
	        //Object[] obj = {eval_no,sheet_kind,biz_type,period,use_flag,start_date,end_date};
            Object[] obj = {ev_no,ev_year,seller_code,sg_regitem, ev_date, reg_date_2, eval_id};
	    	SepoaOut value = ServiceConnector.doService(info, "WO_024", "CONNECTION","a_24_pop_list", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();
            
            if (rowCount == 0)
            {
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            String key_info = "";
            String key_ev_m_item = "";
            String key_ev_d_item = "";
            Vector merge_vec_ev_m_item = new Vector();
            Vector merge_vec_ev_d_item = new Vector();
            Vector merge_vec_ev_remark = new Vector();
            Vector merge_vec_grade_item = new Vector();
            Vector merge_vec_attach_txt = new Vector();
            Vector merge_vec_ev_basic_point = new Vector();
            Vector merge_vec_item_point_cal = new Vector();
            Vector merge_vec_real_score = new Vector();
            Vector merge_vec_score = new Vector();
            Vector merge_vec_item_point_score = new Vector();
            Vector merge_vec_selected = new Vector();
            Vector merge_vec_item_remark = new Vector();
            Vector merge_vec_attach_remark = new Vector();
            
            
            int cnt_ev_m_item= 0;
            int cnt_ev_d_item= 0;
            int cnt_select = 0;
            double score_tot = 0.00;
            double item_score_tot = 0.00;
            double basic_total = 0.00;
            double item_score_total = 0.00;
            double score_total = 0.00;
            boolean score_total_flag = true;
            boolean stage_flag= false;
            String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
            
            for (int i = 0; i < rowCount; i++)
            {
            	key_ev_m_item = wf.getValue("EV_M_ITEM", i);
            	key_ev_d_item = wf.getValue("EV_D_ITEM", i);
            	//score_tot	= Integer.parseInt(wf.getValue("SCORE", i));
            	
            	for(int k=0; k < grid_col_ary.length; k++)
                {
            		
            		if(i != rowCount-1){
	            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected")) {
	//            			 cnt_select = 0;
	//             			if(!merge_vec_selected.contains(key_ev_d_item)){
	//             				merge_vec_selected.addElement(key_ev_d_item);
	//             				for(int z=i; z < rowCount; z++){
	// 								
	// 								if(wf.getValue("EV_D_ITEM", i).equals(wf.getValue("EV_D_ITEM", z))){
	// 									cnt_select++;
	// 								}
	// 							}
	//             				gdRes.addRowSpanValue("selected", "0",cnt_select);
	//  						}else{
	  							gdRes.addValue("selected", "0");
	//  						}
	                	}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EV_M_ITEM")) {
	            			cnt_ev_m_item = 0;
	            			if(!merge_vec_ev_m_item.contains(key_ev_m_item)){
	            				merge_vec_ev_m_item.addElement(key_ev_m_item);
								for(int z=i; z < rowCount; z++){
									
									if(wf.getValue(grid_col_ary[k], i).equals(wf.getValue(grid_col_ary[k], z))){
										cnt_ev_m_item++;
									}
								}
								gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_m_item);
	//							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EV_D_ITEM")) {
	            			cnt_ev_d_item = 0;
	            			if(!merge_vec_ev_d_item.contains(key_ev_d_item)){
	            				merge_vec_ev_d_item.addElement(key_ev_d_item);
								for(int z=i; z < rowCount; z++){
									
									if(wf.getValue(grid_col_ary[k], i).equals(wf.getValue(grid_col_ary[k], z))){
										cnt_ev_d_item++;
									}
								}
								gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
	//							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EV_BASIC_POINT")) {
	            			if(!merge_vec_ev_basic_point.contains(key_ev_d_item)){
	            				merge_vec_ev_basic_point.addElement(key_ev_d_item);
	            				basic_total += Double.parseDouble(wf.getValue(grid_col_ary[k], i));						
								gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
	            				//gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            			
							
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ITEM_POINT_CAL")) {
	            			if(!merge_vec_item_point_cal.contains(key_ev_d_item)){
	            				merge_vec_item_point_cal.addElement(key_ev_d_item);
	            										
								gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ITEM_POINT_SCORE")) {
	            			item_score_tot = 0.00;
	            			for(int z=0; z < rowCount; z++){
								
								if(wf.getValue("EV_SEQ", i).equals(wf.getValue("EV_SEQ", z))){
									item_score_tot += Double.parseDouble(wf.getValue(grid_col_ary[k], z));
								}
							}	
	            			if(!merge_vec_item_point_score.contains(key_ev_d_item)){
	            				merge_vec_item_point_score.addElement(key_ev_d_item);
	            									
	            				item_score_total += item_score_tot;
								gdRes.addRowSpanValue(grid_col_ary[k], item_score_tot+"",cnt_ev_d_item);
	            				//gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            			
							
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ITEM_CHECK")) {
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						//	gdRes.addValue("ITEM_CHECK_CK", wf.getValue("ITEM_CHECK", i));
	 							
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ITEM_CHECK_CK")) {
	            				if("정성".equals(wf.getValue("EV_TYPE", i))){
	            					gdRes.addColorValue("ITEM_CHECK_CK", wf.getValue("ITEM_CHECK", i), "#ffff63");
//	            					gdRes.addCellColor("ITEM_CHECK_CK", wf.getValue("ITEM_CHECK", i),"#ffff63",true);
	            				}else{
	            					gdRes.addValue("ITEM_CHECK_CK", wf.getValue("ITEM_CHECK", i));
	            					
	            				}
								
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("REAL_SCORE")) {
	            			if(!merge_vec_real_score.contains(key_ev_d_item)){
	            				merge_vec_real_score.addElement(key_ev_d_item);
	            				
	            				if("정량".equals(wf.getValue("EV_TYPE", i))){
//	            					gdRes.addColorValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i), "#ffff63");
	            					gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
	            				}else{
	            					gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
	            				}						
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            			
	            			
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("SCORE")) {
	            			score_tot = 0.00;
	            			double score_temp = 0.00;
	            			for(int z=0; z < rowCount; z++){
								
								if(wf.getValue("EV_SEQ", i).equals(wf.getValue("EV_SEQ", z))){
										//score_tot += Double.parseDouble(wf.getValue(grid_col_ary[k], z));
										
										if(score_temp <= Double.parseDouble(wf.getValue(grid_col_ary[k], z))){
												score_temp = Double.parseDouble(wf.getValue(grid_col_ary[k], z));
												//Logger.debug.println("score_temp ==== "+  i +"====="+ score_temp);
										}
								}
							}	
	            			score_tot += score_temp;
	            			if(!merge_vec_score.contains(key_ev_d_item)){
	            				merge_vec_score.addElement(key_ev_d_item);
	            					score_total += score_tot;  // 전체 합계 ++
								gdRes.addRowSpanValue(grid_col_ary[k], score_tot+"",cnt_ev_d_item);
	            				//gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            			
							  
							  
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_IMG")) {
	            			String fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_a.gif";
						    if(!"".equals(wf.getValue("ATTACH_TXT", i))){ fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";}
						    
	            			if(!merge_vec_attach_txt.contains(key_ev_d_item)){
	            				merge_vec_attach_txt.addElement(key_ev_d_item);
														
	            				gdRes.addRowSpanValue(grid_col_ary[k], fileImg, cnt_ev_d_item);
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], fileImg);
	 						}
							
	            		}
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_REMARK")) {
						    
	            			if(!merge_vec_attach_remark.contains(key_ev_d_item)){
	            				merge_vec_attach_remark.addElement(key_ev_d_item);
														
	            				gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i), cnt_ev_d_item);
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
							
	            		}
	            		
	            		else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EV_REMARK")) {
	            			if(!merge_vec_ev_remark.contains(key_ev_d_item)){
	            				merge_vec_ev_remark.addElement(key_ev_d_item);
														
								gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            			
							
	            		}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ITEM_REMARK")) {
	            			if(!merge_vec_item_remark.contains(key_ev_d_item)){
	            				merge_vec_item_remark.addElement(key_ev_d_item);
														
								gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
	 						}else{
	 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	 						}
	            			
							
	            		}
	            		else {
	                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	                	}
	            		
            		}else{ // 합계로우만 따로 처리
            			gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            		}
	            }
            	
            	
            	
            }
            
            gdRes.addParam("basic_total", Double.toString(basic_total));
            gdRes.addParam("item_score_total", Double.toString(item_score_total));
            gdRes.addParam("score_total", Double.toString(score_total));
            gdRes.addParam("status", "true");
        }
        catch (Exception e)
        {
//        	System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
   
    
    public GridData a_24_doScore_Cal(GridData gdReq) throws Exception
    {
        GridData gdRes      = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);
        boolean pass_flag   = true;

        try
        {
        	gdRes.setSelectable(false);
        	String ev_no       = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
        	String ev_year     = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String seller_code = JSPUtil.CheckInjection(gdReq.getParam("seller_code")).trim();
        	String eval_id     = JSPUtil.CheckInjection(gdReq.getParam("eval_id")).trim();
        	
        	HashMap	header = new HashMap();		
          	header.clear();           	
          	header.put("ev_no"       , ev_no);
          	header.put("ev_year"     , ev_year);
          	header.put("seller_code" , seller_code);
          	header.put("eval_id"     , eval_id);
          	
        	int row_count        = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];
	        String gubun         = "";
	        
	        for( int i = 0; i < row_count; i++ ){
	        	if( "정량".equals(gdReq.getValue("EV_TYPE", i)) ){ // 정량
		        	if("0".equals(gdReq.getValue("REAL_SCORE", i)) || "".equals(gdReq.getValue("REAL_SCORE", i)) ){
		        		pass_flag = false; 
		        		gubun     = "실적(정량)";
		        	}	        		
	        	}
	        	else{
		        	//if( gdReq.getValue("ITEM_CHECK", i).equals("") ){
		        	//	pass_flag = false;
		        	//	gubun     = "실적1";
		        	//}		        
	        		Logger.debug.println();
	        	}
	        	Logger.sys.println("I= "+i+"   EV_TYPE = " + gdReq.getValue("EV_TYPE" , i) + "  ITEM_CHECK = " + gdReq.getValue("ITEM_CHECK" , i)+"  ITEM_CHECK1 = " + gdReq.getValue("ITEM_CHECK_CK" , i) + "  EV_SEQ     = " + gdReq.getValue("EV_SEQ" , i)+ "   EV_REQSEQ  = " + gdReq.getValue("EV_REQSEQ" , i));
	        /*	Logger.sys.println("REAL_SCORE = " + gdReq.getValue("REAL_SCORE" , i));
	        	Logger.sys.println("EV_SEQ     = " + gdReq.getValue("EV_SEQ" , i));
	        	Logger.sys.println("EV_REQSEQ  = " + gdReq.getValue("EV_REQSEQ" , i));
	        	Logger.sys.println("ITEM_CHECK = " + gdReq.getValue("ITEM_CHECK" , i));
	        	Logger.sys.println("EV_TYPE    = " + gdReq.getValue("EV_TYPE" , i));
	        	Logger.sys.println("EV_DSEQ    = " + gdReq.getValue("EV_DSEQ" , i));
	        	Logger.sys.println("ITEM_REMARK = " + gdReq.getValue("ITEM_REMARK" , i));
	        	Logger.sys.println("ATTACH_TXT = " + gdReq.getValue("ATTACH_TXT" , i));*/
	            String[] loop_data1 =
	            {
	            		gdReq.getValue("REAL_SCORE" , i), //실적
	            		gdReq.getValue("EV_SEQ"     , i), 
	            		gdReq.getValue("EV_REQSEQ"  , i),
	            		JSPUtil.convertStr(gdReq.getValue("ITEM_CHECK" , i)), //실적1
	            		gdReq.getValue("EV_TYPE"    , i), //정량/정성
	            		gdReq.getValue("EV_DSEQ"    , i),
	            		gdReq.getValue("ITEM_REMARK", i),
	            		gdReq.getValue("ATTACH_TXT" , i)
	            };
//	            System.out.println(gdReq.getValue("SCORE", i) +"=" +gdReq.getValue("EV_SEQ", i)+ "=" + gdReq.getValue("EV_REQSEQ", i)+ "=" +gdReq.getValue("ITEM_CHECK", i));
	            bean_args[i] = loop_data1;
	        }
	        
	        if(!pass_flag){
//	        	System.out.println("실패");
	        	gdRes.setMessage(gubun+"을 모두 입력하십시요.");
	        	gdRes.setStatus("false");
	        }else{
	        	Object[] obj = { bean_args,header, };
		    	SepoaOut value = ServiceConnector.doService(info, "WO_024", "TRANSACTION","a_24_doScore_Cal", obj);
	
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
	        

        }
        catch (Exception e)
        {
        	gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "doScore_Cal");
        return gdRes;
    }
    
    public GridData a_24_insert(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        boolean pass_flag = true;

        try
        {
        	gdRes.setSelectable(false);
        	String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
        	String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String seller_code = JSPUtil.CheckInjection(gdReq.getParam("seller_code")).trim();
        	String sg_regitem = JSPUtil.CheckInjection(gdReq.getParam("sg_regitem")).trim();
        	String item_score_total = JSPUtil.CheckInjection(gdReq.getParam("item_score_total")).trim();
        	String score_total = JSPUtil.CheckInjection(gdReq.getParam("score_total")).trim();
        	String eval_id = JSPUtil.CheckInjection(gdReq.getParam("eval_id")).trim();
        	
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	
        	HashMap	header = new HashMap();		
          	header.clear();           	
          	header.put("ev_no", ev_no);
          	header.put("ev_year", ev_year);
          	header.put("seller_code", seller_code);
          	header.put("sg_regitem", sg_regitem);
          	header.put("item_score_total", item_score_total); //업체배점합계
          	header.put("score_total",score_total); //점수합계
          	header.put("eval_id",eval_id); //점수합계
          	
        	int row_count        = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for( int i = 0; i < row_count; i++ ){
	        	
	            String[] loop_data1 =
	            {
	            		gdReq.getValue("REAL_SCORE" , i), //실적
	            		gdReq.getValue("EV_SEQ"     , i), 
	            		gdReq.getValue("EV_REQSEQ"  , i),
	            		gdReq.getValue("SCORE"      , i),
	            		gdReq.getValue("ITEM_CHECK" , i), //실적1
	            		gdReq.getValue("EV_TYPE"    , i), //정량/정성
	            		gdReq.getValue("EV_DSEQ"    , i),
	            		gdReq.getValue("EV_POINT_REL"   , i)
	            };
	            
	          
	            Logger.sys.println("EV_TYPE      = " + loop_data1[5]);
	            Logger.sys.println("REAL_SCORE   = " + loop_data1[0]);
	            Logger.sys.println("SCORE        = " + loop_data1[3]);
	            Logger.sys.println("EV_DSEQ      = " + loop_data1[6]);
	            Logger.sys.println("EV_POINT_REL = " + loop_data1[7]);
	            bean_args[i] = loop_data1;
	        }
	       for(int i = 0; i < row_count; i++){
	        Logger.sys.println("I= "+i+"   EV_TYPE = " + gdReq.getValue("EV_TYPE" , i) + "REAL_SCORE = " + gdReq.getValue("REAL_SCORE" , i) 
	        		+  "SCORE = " + gdReq.getValue("SCORE" , i) + "  ITEM_CHECK = " + gdReq.getValue("ITEM_CHECK" , i)+"  ITEM_CHECK1 = " + gdReq.getValue("ITEM_CHECK_CK" , i) + "  EV_SEQ     = " + gdReq.getValue("EV_SEQ" , i)+ "   EV_REQSEQ  = " + gdReq.getValue("EV_REQSEQ" , i));
	       }
	        Object[] obj = {bean_args,header};
		   	SepoaOut value = ServiceConnector.doService(info, "WO_024", "TRANSACTION","a_24_insert", obj);
	
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

        gdRes.addParam("mode", "doScore_Cal");
        return gdRes;
    }
    
    
        
    
    public GridData a_24_cancel(GridData gdReq) throws Exception {
    	GridData gdRes      = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage( info, multilang_id );

        try
        {
        	String to_year = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("to_year") ));
        	String ev_no   = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("ev_no") ));
        	
	        Object[] obj   = { to_year, ev_no };
	        SepoaOut value = ServiceConnector.doService(info, "WO_024", "TRANSACTION", "a_24_cancel", obj);
	        
	        if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
                gdRes.addParam("DELETE"       , "true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            	 gdRes.addParam("DELETE"       , "false");
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode"       , "insert");
        
        return gdRes;
    }
}
