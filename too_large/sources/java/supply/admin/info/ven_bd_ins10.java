/*
 Title:             hico_bd_lis3.java  <p>
 Description:       인허가및자격사항 Servlet<p>
 Copyright:         Copyright (c) <p>
 Company:           ICOMPIA <p>
 @author            SHYI<p>
 @version           1.0.0
 @Comment
*/

package supply.admin.info;
import java.io.IOException;
import java.io.PrintWriter;
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


public class ven_bd_ins10 extends HttpServlet {
	
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
    		
    		
    		
    		if("getHicoBdLis3".equals(mode)){ 
    			gdRes = this.getHicoBdLis3(gdReq, info);
    		}else if("insertHicoBdLis3".equals(mode)){
    			gdRes = this.insertHicoBdLis3(gdReq, info);
    		}else if("deleteHicoBdLis3".equals(mode)){
    			gdRes = this.deleteHicoBdLis3(gdReq, info);
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
	private GridData getHicoBdLis3(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "s6006", "CONNECTION", "getHicoBdLis3", obj);
	
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
			    			if("sel".equals(gridColAry[k])){
			    				gdRes.addValue("sel", "0");
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
    

	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData insertHicoBdLis3(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	
    	
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		Object[] obj = {data};

    		value = ServiceConnector.doService(info, "s6006", "TRANSACTION", "insertHicoBdLis3", obj);
    		
    		String[] tmp = value.result;
    		
//    		if(tmp != null && tmp.length > 0){
//    			for(int i = 0 ; i < tmp.length ; i++){
//    				
//    			}
//    		}
    		 
    		
    		if(value.flag) {
    			gdRes.addParam("rtnVal", value.result[0]);
    			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
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
	    
    
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData deleteHicoBdLis3(GridData gdReq, SepoaInfo info) throws Exception{
		GridData            gdRes       = new GridData();
		Vector              multilangId = new Vector();
		HashMap             message     = null;
		SepoaOut            value       = null;
		Map<String, Object> data        = null;
		
		
		
		multilangId.addElement("MESSAGE");
		
		message = MessageUtil.getMessage(info, multilangId);
		
		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			data = SepoaDataMapper.getData(info, gdReq);
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "s6006", "TRANSACTION", "deleteHicoBdLis3", obj);
			
			String[] tmp = value.result;
			
//			if(tmp != null && tmp.length > 0){
//				for(int i = 0 ; i < tmp.length ; i++){
//					
//				}
//			}
			
			
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
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
	
	
    
//    //조회시 사용되는 Method 입니다. Method Name(doQuery)는 변경할 수 없습니다.
//    public void doQuery( WiseStream ws ) throws Exception
//    {
//		//WiseInfo info = null;
//	    String language = "";
//	    String serviceId = "s6006";
//	    boolean isOk = true;
//	    String message = "";
//	    //wise.ses.WiseInfo info = null;
//        //info = new WiseInfo("100","HOUSE_CODE=100^@^ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        language = info.getSession( "LANGUAGE" );
//        String vendor_code = ws.getParam( "vendor_code" );
//        String msg_value = "";
//
//
//    	WiseOut value = getHicoBdLis3( info, vendor_code );
//        if ( value.status == 0 ){    //오류가 있었다면
//            isOk = false;
//            message = value.message;
//        }
//        else{
//            isOk = true;
//            message = "";
//        }
//
//        //조회중 오류가 발생하였다면...
//        if ( ! isOk )
//        {
//            msg_value = "조회중 오류가 발생하였습니다.";
//            ws.setMessage( msg_value );
//            String [] userObject = { message };
//            ws.setUserObject( userObject );
//            ws.write();
//            return;
//        }
//
//        //결과값을 WiseTable에서 조작가능하게 formatting한다.
//        WiseFormater wf = ws.getWiseFormater( value.result[0] );
//        if ( wf.getRowCount() == 0 )
//        {
//            msg_value = "데이터가 존재하지 않습니다.";
//            ws.setMessage( msg_value );
//            ws.write();
//            return;
//        }
//
//
//		int idx_sel         = ws.getColumnIndex("sel");
//		int idx_title       = ws.getColumnIndex("title");
//		int idx_desc1       = ws.getColumnIndex("desc1");
//		int idx_desc2       = ws.getColumnIndex("desc2");
//		int idx_date1       = ws.getColumnIndex("date1");
//		int idx_date2       = ws.getColumnIndex("date2");
//		int idx_remark      = ws.getColumnIndex("remark");
//	    int idx_vendor_code = ws.getColumnIndex("vendor_code");
//	    int idx_seq         = ws.getColumnIndex("seq");
//	    int idx_flag_h      = ws.getColumnIndex("flag_h");
//
//        String[][] combo1 = null;
//	    for ( int i = 0; i < wf.getRowCount(); i++ )
//        {
//        	String[] check = { "false", "" };
//            ws.addValue( idx_sel, check, "" );
//            ws.addValue( idx_title      , wf.getValue("title", i ), "" );
//    		ws.addValue( idx_desc1      , wf.getValue("desc1", i ), "" );
//    		ws.addValue( idx_desc2      , wf.getValue("desc2", i ), "" );
//    		ws.addValue( idx_date1      , wf.getValue("date1", i ), "" );
//    		ws.addValue( idx_date2      , wf.getValue("date2", i ), "" );
//    		ws.addValue( idx_remark     , wf.getValue("remark", i ), "" );
//    	    ws.addValue( idx_vendor_code , wf.getValue("vendor_code", i ), "" );
//    	    ws.addValue( idx_seq         , wf.getValue("seq", i ), "" );
//    	    ws.addValue( idx_flag_h      , "U", "" ); //DB에서 조회해 오는건과 화면에서 새로 만드는건과 구분하기위해...
//        }
//
//        msg_value = "데이터가 조회되었습니다.";
//        ws.setMessage( msg_value );
//        ws.write();
//
//    } // end of doQuery
//
//
//    /**
//        @Method Name : getEG
//        @작성자      : 이수헌
//        @작성일      : 2004.02.24
//        @작업내용    : 인허가및자격사항 조회
//    **/
//        public WiseOut getHicoBdLis3( WiseInfo info, String vendor_code )
//        {
//    	    String serviceId = "s6006";
//            Object[] args = { vendor_code };
//            String conType = "CONNECTION";          //conType : CONNECTION/TRANSACTION/NONDBJOB
//            String MethodName = "getHicoBdLis3";		//NickName으로 연결된 Class에 정의된 Method Name
//
//            wise.srv.WiseOut value = null;
//            wise.util.WiseRemote wr = null;
//
//            //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
//            try
//            {
//                wr = new wise.util.WiseRemote( serviceId, conType, info );
//                value = wr.lookup( MethodName, args );
//
//            }catch( WiseServiceException wse ) {
//            	wse.printStackTrace();
//            }catch(Exception e) {
//            	e.printStackTrace();
//            }
//            finally{
//                try{
//                    wr.Release();
//                }catch(Exception e){
//                	e.printStackTrace();
//                }
//            }
//            return value;
//        }   // end of getLcOpenList
//
//
//
//
//        public void doData( WiseStream ws ) throws Exception
//        {
//        	//WiseInfo info = null;
//    	    String language = "";
//    	    String serviceId = "s6006";
//    	    boolean isOk = true;
//    	    String message = "";
//
//            //info = WiseSession.getAllValue( ws.getRequest() );
//            //info = new WiseInfo("100","HOUSE_CODE=100^@^ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
//    	    WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//            WiseFormater wf = ws.getWiseFormater();
//
//            language = info.getSession( "LANGUAGE" );
//            String mode = ws.getParam( "mode" );
//            String mode2 = ws.getParam( "mode2" );
//            String vendor_code = ws.getParam( "vendor_code" );
//            String msg_value = "";
//
//    		if ( mode.equals( "insert" ) )
//            {
//                String[] title  = wf.getValue("title");
//                String[] desc1  = wf.getValue("desc1");
//                String[] desc2  = wf.getValue("desc2");
//                String[] date1  = wf.getValue("date1");
//                String[] date2  = wf.getValue("date2");
//                String[] remark = wf.getValue("remark");
//                String[] flag_h = wf.getValue("flag_h");
//                String[] seq 	= wf.getValue("seq");
//    			int ins_cnt = 0;
//            	int upd_cnt = 0;
//            	int iRowCount = wf.getRowCount();
//            	for(int i = 0; i < iRowCount; i++)
//            	    if(flag_h[i].equals("U"))
//            	        upd_cnt++;
//            	    else
//            	        ins_cnt++;
//            	String setData[][] = new String[ ins_cnt ][];
//                String setData2[][] = new String[ upd_cnt ][];
//                ins_cnt = 0;
//            	upd_cnt = 0;
//                for ( int i = 0; i < wf.getRowCount(); i++ )
//                {
//                	if(!(flag_h[i].equals("U"))){
//                    	String Data[] = { title[i], desc1[i], desc2[i], date1[i], date2[i], remark[i] };
//                    	setData[ ins_cnt ] = Data;
//                    	ins_cnt++;
//                	}else{
//                		String Data[] = { title[i]
//                						, desc1[i]
//                						, desc2[i]
//                						, date1[i]
//                						, date2[i]
//                						, remark[i]
//                						, info.getSession("HOUSE_CODE")
//                						, vendor_code
//                						, seq[i]};
//                    	setData2[ upd_cnt ] = Data;
//                    	upd_cnt++;
//                	}
//                }
//
//                WiseOut value = insertHicoBdLis3( info, vendor_code, setData, setData2);
//                if ( value.status == 0 ){    //오류가 있었다면
//    	            isOk = false;
//    	            message = value.message;
//    	        }
//    	        else{
//    	            isOk = true;
//    	            message = "";
//    	        }
//
//                //등록중 오류가 발생하였다면...
//                if ( ! isOk )
//                {
//                    msg_value = "등록중 오류가 발생하였습니다.";
//                    ws.setMessage( msg_value );
//                    String [] userObject = { message };
//                    ws.setUserObject( userObject );
//                    Logger.debug.println( info.getSession( "ID" ),  this, "++++++++++++++ 우씨 에러다 " + userObject[ 0 ] + " is ok " + isOk );
//                    ws.write();
//                    return;
//                }
//
//                msg_value = "등록을 완료하였습니다."; //
//                ws.setMessage( msg_value );
//                String [] userObject = { message };
//                ws.setUserObject( userObject );
//                ws.write();
//            }
//
//    		else if ( mode.equals( "delete" ) )
//            {
//                Logger.debug.println( info.getSession( "ID" ),  this, ">>>>> delete 왔다." );
//
//        	    String[] seq         = wf.getValue("seq");
//
//                String setData[][] = new String[ wf.getRowCount() ][];
//                for ( int i = 0; i < wf.getRowCount(); i++ )
//                {
//                    String Data[] = { seq[i] };
//                    setData[ i ] = Data;
//                }
//
//                WiseOut value = deleteHicoBdLis3( info, vendor_code, setData , mode2);
//                if ( value.status == 0 ){    //오류가 있었다면
//    	            isOk = false;
//    	            message = value.message;
//    	        }
//    	        else{
//    	            isOk = true;
//    	            message = "";
//    	        }
//
//                //삭제중 오류가 발생하였다면...
//                if ( ! isOk )
//                {
//                    msg_value = "삭제중 오류가 발생하였습니다.";
//                    ws.setMessage( msg_value );
//                    String [] userObject = { message };
//                    ws.setUserObject( userObject );
//                    Logger.debug.println( info.getSession( "ID" ),  this, "++++++++++++++ 우씨 에러다 " + userObject[ 0 ] + " is ok " + isOk );
//                    ws.write();
//                    return;
//                }
//
//                msg_value = "삭제를 완료하였습니다."; //
//                ws.setMessage( msg_value );
//                String [] userObject = { message };
//                ws.setUserObject( userObject );
//                ws.write();
//            }
//
//            ws.write();
//        }   // end of doData
//
//
//        /**
//            @Method Name : insertHicoBdLis3
//            @작성자  : 이수헌
//            @작성일  : 2004.02.25
//            @작업내용: 인허가및자격사항 등록
//        **/
//            public WiseOut insertHicoBdLis3( WiseInfo info, String vendor_code, String[][] SetData, String[][] SetData2 )
//            {
//        	    String serviceId = "s6006";
//                String conType = "TRANSACTION";
//                String MethodName = "insertHicoBdLis3";
//                Object[] obj = { vendor_code, SetData ,SetData2};
//                wise.srv.WiseOut value = null;
//                wise.util.WiseRemote wr = null;
//
//                //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
//                try
//                {
//                    wr = new wise.util.WiseRemote( serviceId, conType, info );
//                    value = wr.lookup( MethodName, obj );
//
//                }
//                catch(Exception e)
//                {
//                	try{
//                        Logger.err.println("err = " + e.getMessage());
//                        Logger.err.println("message = " + value.message);
//                        Logger.err.println("status = " + value.status);                		
//                	}catch(NullPointerException ne){
//                		ne.printStackTrace();
//                	}
//                }
//                finally{
//                    try{
//                        wr.Release();
//                    }catch(Exception e){
//                    	e.printStackTrace();
//                    }
//                }
//                return value;
//            }   // end of InsertHicoBdLis3
//
//            /**
//                @Method Name : deleteHicoBdLis3
//                @작성자  : 이수헌
//                @작성일  : 2004.02.25
//                @작업내용: 인허가및자격사항 삭제
//            **/
//                public WiseOut deleteHicoBdLis3( WiseInfo info, String vendor_code, String[][] SetData , String mode2)
//                {
//            	    String serviceId = "s6006";
//                    String conType = "TRANSACTION";
//                    String MethodName = "deleteHicoBdLis3";
//                    Object[] obj = { vendor_code, SetData, mode2 };
//                    wise.srv.WiseOut value = null;
//                    wise.util.WiseRemote wr = null;
//
//                    //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
//                    try
//                    {
//                        wr = new wise.util.WiseRemote( serviceId, conType, info );
//                        value = wr.lookup( MethodName, obj );
//
//                    }
//                    catch(Exception e)
//                    {
//                    	try{
//                            Logger.err.println("err = " + e.getMessage());
//                            Logger.err.println("message = " + value.message);
//                            Logger.err.println("status = " + value.status);                   		
//                    	}catch(NullPointerException ne){
//                    		ne.printStackTrace();
//                    	}
//                    }
//                    finally{
//                        try{
//                            wr.Release();
//                        }catch(Exception e){
//                        	e.printStackTrace();
//                        }
//                    }
//                    return value;
//                }   // end of deleteHicoBdLis3


}   // end of class                                                                                                       