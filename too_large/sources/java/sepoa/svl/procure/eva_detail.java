package sepoa.svl.procure;

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

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;





public class eva_detail extends HttpServlet {

    public void init(ServletConfig config) throws ServletException {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res)
    	    throws IOException, ServletException
    		{
    			doPost(req, res);
    		}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
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

       		if ("getEvaList".equals(mode))
       		{	
       			gdRes = getEvaList(gdReq, info);		//조회
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
    
    public GridData getEvaList(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
			
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "getEvaList");
			
			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_023", "CONNECTION", "getEvaList", obj);
			
			if(value.flag) {
			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			    gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			    return gdRes;
			}
			
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			
			if (wf.getRowCount() == 0) {
			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			    return gdRes;
			}
			
			for (int i = 0; i < wf.getRowCount(); i++) {
				for(int k=0; k < grid_col_ary.length; k++) {
			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("sel")) {
			    		gdRes.addValue("sel", "0");
			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("vendor_name")) {
    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("name_loc", i));
                	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("valuer")) {
			    		gdRes.addValue(grid_col_ary[k], wf.getValue("cnt", i));
                	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("value_id")) {
                		
                		String value_id = "";
                        Object[] args = {wf.getValue("eval_item_refitem", i)};

                        SepoaOut value1 = null;
                        SepoaRemote wr = null;                        

                        String nickName = "SR_023";
                        String MethodName = "getEvabdupd2";  
                        String conType = "CONNECTION";

                        try {
                            wr = new SepoaRemote(nickName,conType,info);
                            value1 = wr.lookup(MethodName,args);
                            
                            SepoaFormater wf1 = new SepoaFormater(value1.result[0]);
                            
    						int row_cnt1 = wf1.getRowCount();

    						
    												
    						
    			            if(row_cnt1 > 0)
    			            {
    			                String code = "";
    			                String name = "";
    			                String name1 = "";
    			                String code1 = "";

    			                for(int ii=0; ii<row_cnt1; ii++) 
    			                {
    								code = wf1.getValue("DEPT" , ii);
    								name = wf1.getValue("DEPT_NAME" , ii);
    								name1 = wf1.getValue("USER_NAME" , ii);
    								code1 = wf1.getValue("EVAL_VALUER_ID" , ii);

    								value_id = value_id.concat(code).concat("@");	
    								value_id = value_id.concat(name).concat("@");	
    								value_id = value_id.concat(name1).concat("@");	
    								value_id = value_id.concat(code1).concat("@");	
    								value_id = value_id.concat("#");	
    							}
    						}	                       
                        }catch(Exception e) {
                            sepoa.fw.log.Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
                            sepoa.fw.log.Logger.dev.println(e.getMessage());
                        }finally{
                            try{
                                if(wr != null){ wr.Release(); }
                            }catch(Exception e){
                            	Logger.debug.println();
                            }
                        }
                        
                         
			            
			            gdRes.addValue("value_id",	value_id);       		
                	}else {
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
    
    
}
