package dt.pr;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class pr1_bd_lis1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
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

			if("prQueryList".equals(mode)){ // 품목 마스터 조회
				gdRes = this.prQueryList(gdReq, info);
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
	private GridData prQueryList(GridData gdReq, SepoaInfo info) throws Exception{
        GridData            gdRes          = new GridData();
        SepoaFormater       sf             = null;
        SepoaOut            value          = null;
        Vector              v              = new Vector();
        HashMap             message        = null;
        Map<String, Object> allData        = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header         = null;
        String              gridColId      = null;
        String              addDateStart   = null;
        String              addDateEnd     = null;
        String[]            gridColAry     = null;
        int                 rowCount       = 0;
        
        v.addElement("MESSAGE");
        v.addElement("STDCOMM");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData      = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header       = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            addDateStart = SepoaString.getDateUnSlashFormat(header.get("add_date_start"));
            addDateEnd   = SepoaString.getDateUnSlashFormat(header.get("add_date_end"));
            gridColId    = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry   = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes        = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");
            
            header.put("add_date_start ".trim(), addDateStart );
            header.put("add_date_end   ".trim(), addDateEnd   );

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info, "p1001", "CONNECTION","prQueryList", obj);

            if(value.flag){ // 조회 성공
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
                
                return gdRes;
            }
            
            sf= new SepoaFormater(value.result[0]);
            
            rowCount = sf.getRowCount(); // 조회 건수

            if(rowCount == 0){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                
                return gdRes;
            }
            
            gdRes = this.getPrQueryList(sf, gridColAry, gdRes); // 조회한 그리드 결과를 조작
        }
        catch (Exception e){
        	gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    
    /**
     * String이 널일경우 "", 아닐경우 자기 자신 반환
     * @param string
     * @return
     * @throws Exception
     */
    private String nvl(String string) throws Exception{
    	String result = null;
    	
    	if(string == null){
    		result = "";
    	}
    	else{
    		result = string;
    	}
    	
    	return result;
    }
    
    /**
     * 그리드 결과 조작
     * 
     * @param sf
     * @param gridColAry
     * @param gdRes
     * @return GridData
     * @throws Exception
     */
    private GridData getPrQueryList(SepoaFormater sf, String[] gridColAry, GridData gdRes) throws Exception{
    	String returnReason     = null;
    	String gridColAryInfo   = null;
    	String gdResValue       = null;
    	int    i                = 0;
    	int    k                = 0;
    	int    rowCount         = sf.getRowCount();
    	int    gridColAryLength = gridColAry.length;
    	
    	for(i = 0; i < rowCount; i++) { 
            returnReason = sf.getValue("RETURN_REASON", i);
            returnReason = this.nvl(returnReason);
            
        	for(k = 0; k < gridColAryLength; k++){
        		gridColAryInfo = gridColAry[k];
        		gridColAryInfo = this.nvl(gridColAryInfo);
        		
            	if("SELECTED".equals(gridColAryInfo)) {
            		gdResValue = "0";
            	}
            	else if("RETURN_REASON".equals(gridColAryInfo)){
                    if("".equals(returnReason)){
                    	gdResValue = "";
                    }
                    else{
                    	gdResValue = "<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''> " +  returnReason;
                    }
            	}
            	else{
            		gdResValue = sf.getValue(gridColAryInfo, i);
            	}
            	
            	gdRes.addValue(gridColAryInfo, gdResValue);
            }
        }
    	
    	return gdRes;
    }
}