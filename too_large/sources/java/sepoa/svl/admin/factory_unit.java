package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat ;
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
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings({ "unchecked", "serial" })
public class factory_unit extends HttpServlet
{

    public void init(ServletConfig config) throws ServletException
    {
    	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
	{
		doPost(req, res);
	}

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
    	
    	//System.out.println("doPost");
    	SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        String mode = "";
        PrintWriter out = res.getWriter();
        
        
        try
        {
        
            gdReq = OperateGridData.parse(req, res);//Request객체를 GridData형식으로 변환하는 Class
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            //넘어온 mode에 따라 각 메소드 실행
            if( "getSelect".equals( mode ) ) {
            	gdRes = getSelect(gdReq,info);
            }
            else if ("setDelete".equals( mode ))//상세조회
            {
            	gdRes = setDelete(gdReq,info);
            	
            }

           
           
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
            
        }
        finally
        {
            try
            {
                OperateGridData.write(req, res, gdRes, out);//결과값을 GRID에 Write한다.(XML포멧으로 GRID객체에 Write한다.)
            }
            catch (Exception e)
            {
            	Logger.debug.println();
            }
        }
    }


	/**
	 * 공장정보 조회
	*  getSelect
	*/
	public GridData getSelect( GridData gdReq, SepoaInfo info ) throws Exception {

        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
        multilang_id.addElement( "MESSAGE" );
        HashMap message = MessageUtil.getMessage( info, multilang_id );

        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵

        try {
        	
            allData = SepoaDataMapper.getData( info, gdReq );
            headerData = MapUtils.getMap( allData, "headerData" );
            

            //gridData = OperateGridData.;

            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "query" );

            Object[] obj = { headerData };
           
            
            SepoaOut value = ServiceConnector.doService( info, "AD_118", "CONNECTION", "getMainternace", obj );
           
       
            if( value.flag ) {
                gdRes.setMessage( message.get( "MESSAGE.0001" ).toString() );
                gdRes.setStatus( "true" );
            } else {
                gdRes.setMessage( value.message );
                gdRes.setStatus( "false" );
                
                return gdRes;
            }

            wf = new SepoaFormater( value.result[0] );
            
            rowCount = wf.getRowCount();
     
            if( rowCount == 0 ) {
                gdRes.setMessage( message.get( "MESSAGE.1001" ).toString() );
                return gdRes;
            }

            Config olConfxxxx = new Configuration();
            String POASRM_CONTEXT_NAME = olConfxxxx.getString( "sepoa.context.name" );

            for( int i = 0; i < rowCount; i++ ) {
                for( int k = 0; k < grid_col_ary.length; k++ ) {
                    if( grid_col_ary[k] != null && grid_col_ary[k].equals( "SELECTED" ) ) {
                        gdRes.addValue( "SELECTED", "0" );
                    } else if( grid_col_ary[k] != null && grid_col_ary[k].equals( "PO_CREATE_DATE" ) ) {
                        gdRes.addValue( "ADD_DATE", SepoaString.getDateSlashFormat( wf.getValue( grid_col_ary[k], i ) ) );
                    }else if( grid_col_ary[k] != null && grid_col_ary[k].equals( "IRS_NO" ) ) {
                        String irs_no = wf.getValue ( "IRS_NO" , i );
                        gdRes.addValue( "IRS_NO", irsDash(irs_no)  );
                    }else {
                        gdRes.addValue( grid_col_ary[k], wf.getValue( grid_col_ary[k], i ) );
                    }
                }
            }

        } catch( Exception e ) {
            
            
            gdRes.setMessage( message.get( "MESSAGE.1002" ).toString() );
            gdRes.setStatus( "false" );
        }

        return gdRes;

    } //getInfoList() end	
	
	
	
    public  String irsDash(String str) {
        
        String rtn = "";
        
        if (str==null || "".equals(str.toString())) {
            return rtn;
        }else{
            rtn = str.substring( 0, 3 ) + "-" +str.substring( 3, 5 ) + "-" + str.substring( 5, 10 );
        }

        return rtn;

      }
    
    

/*	//	등록, 변경, 삭제시 사용되는 Method 입니다. Method Name(doData)는 변경할 수 없습니다.
	public void doData(SepoaStream ws) throws Exception
	{
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		SepoaFormater wf = ws.getSepoaFormater();

		//Table에서 가져온 Data를 특정컬럼값으로 가져온다.
		String[] COMPANY_CODE = wf.getValue("COMPANY_CODE");
		String[] PLANT_CODE = wf.getValue("PLANT_CODE");
		String[] PR_LOCATION = wf.getValue("PR_LOCATION");

		//Sessing에서 가져올 User정보
		String st_house_code = info.getSession("HOUSE_CODE");
		String st_change_user_id = info.getSession("ID");

		String[][] setData = new String[wf.getRowCount()][];

		String cur_date = SepoaDate.getShortDateString();
		String cur_time = SepoaDate.getShortTimeString();

		for (int i = 0; i < wf.getRowCount(); i++)
		{
			String[] Data = 
			{
				sepoa.fw.util.CommonUtil.Flag.Yes.getValue(), cur_date, cur_time, st_change_user_id//, st_house_code,
				,COMPANY_CODE[i], PLANT_CODE[i], PR_LOCATION[i]
			};
			setData[i] = Data;
		}

		//해당클래스, 메소드, nickName, ConType을 Mapping한다. 
		SepoaOut value = setDelete(info, setData);
		
		if(value.flag) ws.setStatus(true);
        else ws.setStatus(false);
		
		//SepoaTable에 message를 전송할 수 있다. 또한 script에서 code와 message를 얻을 수 있다.
		ws.setMessage(value.message);

		//위에서 구성한 data를 SepoaTable로 전송한다.
		ws.write();
	}*/

	//framework에 접근하여 data을 추출하는 Method이다. 임의로 만들어서 사용하도록 한다.
    public GridData setDelete(GridData gdReq,SepoaInfo info) throws Exception
    {
    	
        GridData gdRes = new GridData();
        
        //Servlet에서 사용할 Message를 가져온다.
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵
        List< Map<String, String> >   gridData  = null; // gridData 데이터 받을 리스트
        //SepoaFormater wf = ws.getSepoaFormater();
        try
        {
            allData = SepoaDataMapper.getData( info, gdReq );
            headerData = MapUtils.getMap( allData, "headerData" );
            gridData  = (List< Map<String, String> >) MapUtils.getObject( allData, "gridData");

            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            
        	gdRes.setSelectable(false);//저장,삭제용인지 조회용인지 구분한다.(false: 저장,삭제용)
        	int row_count = gdReq.getRowCount();//JSP Grid에서 선택한 ROW수
	        String[][] bean_args = new String[row_count][];
	    
	        Object[] obj = {gridData};
	    
	    	SepoaOut value = ServiceConnector.doService(info, "AD_118", "TRANSACTION","setDelete", obj);

	    	//성공이라면
            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);//실패메세지를 셋팅
            	gdRes.setStatus("false");//상태를 실패로 셋팅
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "delete");//User Parameter셋팅
        return gdRes;
    }

    
    
}
