
package master.register;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import mail.mail;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sms.SMS;
import wise.util.CEncrypt;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;

	public class p0070 extends SepoaService
	{

    	String language = "";
    	String serviceId = "p0070";
		Message msg = null; 

    	public p0070( String opt, SepoaInfo sinfo ) throws SepoaServiceException
    	{
        	super( opt, sinfo );
        	setVersion( "1.0.0" );
        	msg = new Message(info, "FW");
    	}
    	
    	
    	/**
    	 * 등록진행업체목록 조회
    	 * @method getVendorSgLst
    	 * @param  header
    	 * @return Map
    	 * @throws Exception
    	 * @desc   ICOYRQDT
    	 * @since  2014-10-23
    	 * @modify 2014-10-23
    	 */
         public SepoaOut getVendorSgLst(Map<String, String> header) {  
        	 try	{  
     			String rtn = "";  
       
     			//Query 수행부분 Call  
                 //create_type 에 상관없이 조회 
     			rtn	= et_getVendorSgLst(header);  
     				
     			setValue(rtn);  
     			setStatus(1);  
       
     		}catch (Exception e){  
     			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage());  
     			setMessage(msg.getMessage("0002"));
                setStatus(0);
     		}  
     		return getSepoaOut();  
         }
         
         /**
     	 * 등록진행업체목록 조회 쿼리
     	 * @method et_getVendorSgLst
     	 * @param  header
     	 * @return Map
     	 * @throws Exception
     	 * @desc   ICOYRQDT
     	 * @since  2014-10-23
     	 * @modify 2014-10-23
     	 */
    	 private String et_getVendorSgLst(Map<String, String> header) throws Exception  
    	    {  
    	    	
    			
    			String rtn = "";  
    			ConnectionContext ctx =	getConnectionContext();  
    			//String cur_date_time = SepoaDate.getShortDateString() + SepoaDate.getShortTimeString().substring(0,4);
    			
    			try	{  
    				
    				SepoaXmlParser wxp =  new SepoaXmlParser(this,new Exception().getStackTrace()[0].getMethodName());
    				//header.put("cur_date_time", cur_date_time);
    				SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());  
    				
    				rtn	= sm.doSelect(header);  
    	  
    				if(rtn == null)	throw new Exception("SQL Manager is	Null");  
    			}catch(Exception e)	{  
    				
    			  throw	new	Exception("et_getVendorSgLst=========>"+e.getMessage());  
    			} finally{  
    			}  
    			return rtn; 
    	 }
    	
    	
    	
    	
    	
//    	public SepoaOut getPrePjtCodeHeadLst(String[] args)
//		{              
//		 	try
//		 	{
//		   		String user_id = info.getSession("ID");
//		  		String rtn = "";
//
//		  		rtn = et_getPrePjtCodeHeadLst(user_id, args);
//
//		  		setValue(rtn);
//		  		setStatus(1);
//		  		setMessage(msg.getMessage("0000"));
//
//		  	} catch(Exception e) {
//	      		Logger.err.println("Exception e =" + e.getMessage());
//	      		setStatus(0);
//	      		setMessage(msg.getMessage("0001"));
//	      		Logger.err.println(this,e.getMessage());
//		  	}
//		  	return getSepoaOut();
//		}
    	
    	public SepoaOut getPrePjtCodeHeadLst(Map<String, String> header){              
    		ConnectionContext ctx       = null;
    		SepoaXmlParser    sxp       = null;
    		SepoaSQLManager   ssm       = null;
    		String            rtn       = null;
    		String            id        = info.getSession("ID");
    		String            houseCode = info.getSession("HOUSE_CODE");
    		
    		try{
    			setStatus(1);
    			setFlag(true);
    			
    			ctx = getConnectionContext();
    			
    			sxp = new SepoaXmlParser(this, "et_getPrePjtCodeHeadLst");
    			ssm = new SepoaSQLManager(id, this, ctx, sxp);
    			
    			header.put("house_code", houseCode);
    			
    			rtn    = ssm.doSelect(header); // 조회
    			
    			setValue(rtn);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch(Exception e) {
    			Logger.err.println(userid, this, e.getMessage());
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    		}
    		
    		return getSepoaOut();
		}


	  	private String et_getPrePjtCodeHeadLst(String user_id, String args[]) throws Exception{

	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");
	      	String pre_pjt_code = args[0];	
	      	String pr_no        = args[1];	
	      	String subject      = args[2];	

	      	try {

	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", house_code);
				wxp.addVar("pre_pjt_code",pre_pjt_code);
				wxp.addVar("pr_no",pr_no);
				wxp.addVar("subject",subject);
            	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
            	rtn = sm.doSelect((String[])null);

            	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getItemLst:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}
    	
	  	/**
	  	 * 업체평가 신용평가 요청/완료 
	  	 * updateProgStatus
	  	 * @param  gdReq
	  	 * @param  info
	  	 * @return GridData
	  	 * @throws Exception
	  	 * @since  2014-10-22
	  	 * @modify 2014-10-22
	  	 */
	  	public SepoaOut updateProgStatus(String vendor_code, String status, String grade, String sg_refitem, Map<String, String> param)
	  	{

	    	String rtn[] = null;
	    	try{

	    		rtn = SR_updateProgStatus(vendor_code, status, grade, sg_refitem, param);
	    		setMessage( rtn[0] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

	  	/**
	  	 * 업체평가 신용평가 요청/완료 쿼리 
	  	 * SR_updateProgStatus
	  	 * @param  gdReq
	  	 * @param  info
	  	 * @return GridData
	  	 * @throws Exception
	  	 * @since  2014-10-22
	  	 * @modify 2014-10-22
	  	 */
	  	private String[] SR_updateProgStatus(String vendor_code, String status, String grade, String sg_refitem, Map<String, String> param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();
//	    	StringBuffer sql = new StringBuffer();

	    	String user_id = info.getSession("ID");
	    	String house_code = info.getSession("HOUSE_CODE");

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

			try{

				if(status.equals("2") || status.equals("3")){		//신용평가 요청2/완료3

					SepoaXmlParser wxp_sgvn = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
//					wxp_sgvn.addVar("house_code",house_code);
//					wxp_sgvn.addVar("user_id",user_id);
//
//					String value[][] = new String[1][3];
//					value[0][0] = status;
//					value[0][1] = vendor_code;
//					value[0][2] = sg_refitem;
	    	    	//String[] type = { "S", "S", "S" };

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn.getQuery());//sql.toString() );
	  	    		rtnIns = sm.doUpdate(param);

	  	    		if(status.equals("3")){

	  	    			SepoaXmlParser wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vngl");

						String value1[][] = new String[1][2];
						value1[0][0] = grade;
						value1[0][1] = vendor_code;

				    	//String[] type1 = { "S", "S" };

						sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());// sql.toString() );
		    	    	rtnIns = sm.doUpdate( param);
					}

	    		}else if(status.equals("4")) {		//실사통보
	    			
					
	    			SepoaXmlParser wxp_sgvn_end = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn_end");
	    			//wxp_sgvn_end.addVar("house_code",house_code);
	    			//wxp_sgvn_end.addVar("user_id",user_id);

	    	    	//String[] type2 = { "S", "S", "S", "S", "S", "S", "S" ,"S", "S"};
	    			param.put("user_id", user_id);
					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx,wxp_sgvn_end.getQuery());// sql.toString() );
	  	    		rtnIns = sm.doUpdate(param);
/*
	  	    		SepoaXmlParser wxp_vngl_end = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vngl_end");
	  	    		wxp_vngl_end.addVar("house_code",house_code);

					String value[][] = new String[1][2];
					value[0][0] = grade;
					value[0][1] = vendor_code;

	    	    	String[] type3 = { "S", "S" };

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl_end.getQuery());//sql.toString() );
	  	    		rtnIns = sm.doUpdate( value, type3 );
*/
	    		}
	//Mail 발송 주석처리
	/*
	    		//mail & sms
	    		String dept = "";
	    		String s_mail = "";
	    		String s_name = "";
	    		String r_mail = "";
	    		String r_name = "";
	    		String phoneNo = "";


	    		String rtn = null;
	    		String sms_msg = "";
	    		String[] arg = null;


	          	if(status.equals("2")) {

	          		arg = getMailInfo(vendor_code, "신용평가요청", "LEVEL1", "");
	  	    		int sended = setMail( arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[10] );
	  	    		if(sended == 0) {
	  	    			throw new Exception();
	  	    		}
	  	    		sms_msg  = "귀사는 웅진씽크빅 업체등록 절차에 따라 신용평가가 필요합니다. 웅진씽크빅 " + arg[7];
	  	    		setSMS(sms_msg, arg[9]);

	  	    	}else if(status.equals("4")) {

	  	    		String term = param[0][1] + "~" + param[0][2];
	  	    		arg = getMailInfo(vendor_code, "실사평가", "LEVEL2", "");
	  	    		int sended = setMail( arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], term, arg[10] );
	  	    		if(sended == 0) {
	  	    			throw new Exception();
	  	    		}
	  	    		sms_msg = "귀사는 공급사 등록절차에 의거하여 실사를 받으셔야 합니다. 웅진씽크빅 " + arg[7];
	  	    		setSMS(sms_msg, arg[9]);

	  	    	}
	*/
	    		Commit();

	    	} catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { }

	    	return returnString;
	  	}
	  	
	  	/**
	  	 * 업체등록평가결과 저장 
	  	 * updateInfo
	  	 * @param  gdReq
	  	 * @param  info
	  	 * @return GridData
	  	 * @throws Exception
	  	 * @since  2014-10-22
	  	 * @modify 2014-10-22
	  	 */
	  	public SepoaOut updateInfo(String vendor_code, String grade, Map<String, String> param){

	    	String rtn[] = null;
	    	try{

	    		rtn = SR_updateInfo(vendor_code, grade, param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

	  	/**
	  	 * 업체등록평가결과 저장 쿼리
	  	 * updateInfo
	  	 * @param  gdReq
	  	 * @param  info
	  	 * @return GridData
	  	 * @throws Exception
	  	 * @since  2014-10-22
	  	 * @modify 2014-10-22
	  	 */
	  	private String[] SR_updateInfo(String vendor_code, String grade, Map<String, String> param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();

	    	String user_id = info.getSession("ID");
	    	String house_code = info.getSession("HOUSE_CODE");

	    	int rtn = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

			try{


				SepoaXmlParser wxp_sgvn = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
				//wxp_sgvn.addVar("house_code", house_code);
				//wxp_sgvn.addVar("user_id", user_id);

			    //String[] type2 = { "S", "S", "S", "S", "S", "S", "S", "S" };

				param.put("house_code", house_code);
				param.put("user_id",  user_id);
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn.getQuery()); //sql.toString() );
		    	rtn = sm.doUpdate( param);

		    	//SepoaXmlParser wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vngl");
				//wxp_vngl.addVar("house_code", house_code);

				// 신용등급, 현금흐름등급은 NiceDnb 의 값을 조회
/*
				String value[][] = new String[1][2];
				value[0][0] = grade;
				value[0][1] = vendor_code;

			    String[] type3 = { "S", "S" };

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());// sql.toString() );
	    	   	rtnIns = sm.doUpdate( value, type3 );
*/
	  	    	Commit();

	  	    	} catch( Exception e ) {
	  	    	    Rollback();
	  	    	    returnString[ 1 ] = e.getMessage();
	  	    	} finally { }

	  	    	return returnString;
	  	}


	  	
	  	
//    	public SepoaOut getPrePjtCodeLst(String[] args)
//		{
//		 	try
//		 	{
//		   		String user_id = info.getSession("ID");
//		  		String rtn = "";
//
//		  		rtn = et_getPrePjtCodeLst(user_id, args);
//
//		  		setValue(rtn);
//		  		setStatus(1);
//		  		setMessage(msg.getMessage("0000"));
//
//		  	} catch(Exception e) {
//	      		Logger.err.println("Exception e =" + e.getMessage());
//	      		setStatus(0);
//	      		setMessage(msg.getMessage("0001"));
//	      		Logger.err.println(this,e.getMessage());
//		  	}
//		  	return getSepoaOut();
//		}
    	
    	private String et_getPrePjtCodeLst(String user_id, String args[]) throws Exception{
	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");
	      	String pre_pjt_code = args[0];	
	      	String pr_no        = args[1];	
	      	String subject      = args[2];

	      	try {

	      		SepoaXmlParser wxp = new SepoaXmlParser(this, "et_getPrePjtCodeLst");
				wxp.addVar("house_code", house_code);
				wxp.addVar("",pre_pjt_code);
				wxp.addVar("pr_no",pr_no);
				wxp.addVar("subject",subject);
            	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp);
            	
            	rtn = sm.doSelect((String[])null);

            	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getItemLst:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}
    	
    	/**
    	 * <pre>
    	 * 사전지원 조회
    	 * 
    	 * ~. param 구조
    	 *   !. pre_pjt_code
    	 *   !. pr_no
    	 *   !. subject
    	 * </pre>
    	 * 
    	 * @param param
    	 * @return
    	 */
    	public SepoaOut getPrePjtCodeLst(Map<String, String> param){
    		ConnectionContext ctx        = null;
    		SepoaXmlParser    sxp        = null;
    		SepoaSQLManager   ssm        = null;
    		String            rtn        = null;
    		String            id         = info.getSession("ID");
    		String            house_code = info.getSession("HOUSE_CODE");
    		String            cur        = null;
    		
    		try{
    			setStatus(1);
    			setFlag(true);
    			
    			ctx = getConnectionContext();
    			
    			sxp = new SepoaXmlParser(this, "et_getPrePjtCodeLst");
    			ssm = new SepoaSQLManager(id, this, ctx, sxp);
    			
    			param.put("house_code", house_code);
    			
    			rtn    = ssm.doSelect(param); // 조회
    			
    			setValue(rtn);
    			setValue(cur);
    			setMessage(msg.getMessage("0000"));
    		}
    		catch(Exception e) {
    			Logger.err.println(userid, this, e.getMessage());
    			setStatus(0);
    			setMessage(msg.getMessage("0001"));
    		}
    		
    		return getSepoaOut();
    	}


	  	

		/*public SepoaOut getVendorSgLst(String[] args)
		{
		 	try
		 	{
		   		String user_id = info.getSession("ID");
		  		String rtn = "";

		  		rtn = et_getVendorSgLst(user_id, args);

		  		setValue(rtn);
		  		setStatus(1);
		  		setMessage(msg.getMessage("0000"));

		  	} catch(Exception e) {
	      		Logger.err.println("Exception e =" + e.getMessage());
	      		setStatus(0);
	      		setMessage(msg.getMessage("0001"));
	      		Logger.err.println(this,e.getMessage());
		  	}
		  	return getSepoaOut();
		}


	  	private String et_getVendorSgLst(String user_id, String args[]) throws Exception{

	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");
	      	String vendor_name = args[0];
	      	String progress_status = args[1];
	      	String screening_status = args[2];
	      	String checklist_status = args[3];
	      	//String sole_proprietor_flag = args[4];
	      	//String vendor_code = args[5];  	
	      	try {

	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("vendor_name", vendor_name);
				wxp.addVar("house_code", house_code);
				wxp.addVar("progress_status",progress_status);
				wxp.addVar("screening_status",screening_status);
				wxp.addVar("checklist_status",checklist_status);
				//wxp.addVar("sole_proprietor_flag",sole_proprietor_flag);
				//wxp.addVar("vendor_code",vendor_code);
				//wxp.addVar("company_code",info.getSession("COMPANY_CODE"));
				
            	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
            	rtn = sm.doSelect((String[])null);

            	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getItemLst:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}
*/

	  	public SepoaOut deleteProgVendor(Map<String, String> param){

	    	String rtn[] = null;
	    	try{

	    		rtn = SR_deleteProgVendor(param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "delete Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

		/**
		 * @description : 등록업체 진행목록- 삭제
		 * @date : 2010-03-10
		 * @author useonlyj
		 * */
	  	private String[] SR_deleteProgVendor(Map<String, String> param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();
//	    	String house_code = info.getSession("HOUSE_CODE");
//
//	    	String[][] value = new String[1][1];
//	    	value[0][0] = "N";

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

	    	String JOB_STATUS	  = "";
			try{

				/*
				is_registry = "Y"; //등록
				is_registry = "R"; //반려

				ICOMVNGL.JOB_STATUS = 'P'(아이디신청)  이거나 JOB_STATUS = 'E'(승인된업체가 다른 스크린닝을 요청한경우)
				ICOMVNGL.JOB_STATUS = 'P' 인경우에만 ICOMVNGL쪽에 업데이트 및 유저생성을 한다.
				ICOMVNGL.JOB_STATUS = 'E' 인경우에는 기존 소싱로직을 따른다.
		    	*/
				
				
				//String[] type1 = { "S" };

	    		SepoaXmlParser wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vngl");
		    	//wxp_vngl.addVar("house_code", house_code);
		    	//wxp_vngl.addVar("vendor_code", param[0][0]);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());//sql.toString() );
	    		rtnIns = sm.doDelete(param);

	    		wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
		    	//wxp_vngl.addVar("house_code", house_code);
		    	//wxp_vngl.addVar("vendor_code", param[0][0]);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());//sql.toString() );
	    		rtnIns = sm.doDelete(param);

	    		wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_addr");
		    	//wxp_vngl.addVar("house_code", house_code);
//		    	wxp_vngl.addVar("vendor_code", param[0][0]);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());//sql.toString() );
	    		rtnIns = sm.doDelete(param);

	    		wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vncp");
		    	//wxp_vngl.addVar("house_code", house_code);
//		    	wxp_vngl.addVar("vendor_code", param[0][0]);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());//sql.toString() );
	    		rtnIns = sm.doDelete(param);

	    		wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vnpj");
//		    	wxp_vngl.addVar("house_code", house_code);
//		    	wxp_vngl.addVar("vendor_code", param[0][0]);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());//sql.toString() );
	    		rtnIns = sm.doDelete(param);

	    		wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vnit");
//		    	wxp_vngl.addVar("house_code", house_code);
//		    	wxp_vngl.addVar("vendor_code", param[0][0]);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());//sql.toString() );
	    		rtnIns = sm.doDelete(param);

	    		/*
				SepoaXmlParser wxp_sgvn = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn.getQuery());//sql.toString() );
	    		rtnIns = sm.doUpdate( param, type1 );

	    		SepoaXmlParser wxp_vssi = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vssi");
	    		wxp_vssi.addVar("house_code", house_code);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx,wxp_vssi.getQuery());// sql.toString() );
	    		rtnIns = sm.doUpdate( param, type1 );

	    		SepoaXmlParser wxp_vcsi = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vcsi");
	    		wxp_vcsi.addVar("house_code", house_code);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vcsi.getQuery());//sql.toString() );
	    		rtnIns = sm.doUpdate( param, type1 );

	    		*/
	    		Commit();

	    	} catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { }

	    	return returnString;
	  	}
		/**
		 * @description : 등록 진행업체목록 - 팝업 조회
		 * @date - 2010-03-10
		 * @author useonlyj
		 * */
	  	public SepoaOut getVendorInfo(String vendor_code, String sg_refitem){
	  		
	     	try{

	     		String user_id = info.getSession("ID");
	      		String rtn = "";

	      		rtn = et_getVendorInfo(user_id, vendor_code, sg_refitem);

	      		setValue(rtn);
	      		setStatus(1);
	      		setMessage(msg.getMessage("0000"));

	      	} catch(Exception e) {
	      		Logger.err.println("Exception e =" + e.getMessage());
	      		setStatus(0);
	      		setMessage(msg.getMessage("0001"));
	      	}
	      	return getSepoaOut();
	  	}

	  	/**
		 * @description : 등록 진행업체목록 - 팝업 조회 쿼리
		 * @date - 2010-03-10
		 * @author useonlyj
		 * */
	  	private String et_getVendorInfo(String user_id, String vendor_code, String sg_refitem) throws Exception{

	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");

	      	try {

	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("vendor_code", vendor_code);
				wxp.addVar("sg_refitem", sg_refitem);*/

				String[] data = {house_code, vendor_code, sg_refitem};
	        	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
	        	rtn = sm.doSelect(data);

	        	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getVendorInfo:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}

		/**
		 * @desciption : 등록업체 팝업- 실사결과 조회
		 * @date : 2010-03-10
		 * @author useonlyj
		 * */
	  	public SepoaOut getVenChk(String vendor_code, String sg_refitem)
	  	{
	     	try
	     	{
	     		String user_id = info.getSession("ID");
	      		String rtn = "";

	      		rtn = et_getVenChk(user_id, vendor_code, sg_refitem);

	      		setValue(rtn);
	      		setStatus(1);
	      		setMessage(msg.getMessage("0000"));

	      	} catch(Exception e) {
	      		Logger.err.println("Exception e =" + e.getMessage());
	      		setStatus(0);
	      		setMessage(msg.getMessage("0001"));
	      	}
	      	return getSepoaOut();
	  	}


	  	private String et_getVenChk(String user_id, String vendor_code, String sg_refitem) throws Exception
	  	{
	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");

	      	try{

	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				/*wxp.addVar("house_code", house_code);
				wxp.addVar("vendor_code", vendor_code);
				wxp.addVar("sg_refitem", sg_refitem);*/
	      		
	      		
	          	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
	          	String[] data = {house_code, vendor_code, sg_refitem};
	          	rtn = sm.doSelect(data);

	          	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getItemLst:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}
	  	public SepoaOut getVenScrRst(String vendor_code, String sg_refitem)
	  	{
	     	try
	     	{
	     		String user_id = info.getSession("ID");
	      		String rtn = "";

	      		rtn = et_getVenScrRst(user_id, vendor_code, sg_refitem);

	      		setValue(rtn);
	      		setStatus(1);
	      		setMessage(msg.getMessage("0000"));

	      	} catch(Exception e)
	      	{
	      		Logger.err.println("Exception e =" + e.getMessage());
	      		setStatus(0);
	      		setMessage(msg.getMessage("0001"));
	      	}
	      	return getSepoaOut();
	  	}

	  	private String et_getVenScrRst(String user_id, String vendor_code, String sg_refitem) throws Exception
	  	{
	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");
	      	try
	      	{
	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				/*wxp.addVar("vendor_code", vendor_code);
				wxp.addVar("sg_refitem",sg_refitem);*/
	      		String[] data = {house_code, vendor_code, sg_refitem};
	          	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
	          	rtn = sm.doSelect(data);

	          	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getVenScrRst:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}


	  	public SepoaOut setRegister(String vendor_code, String sg_refitem, String is_registry, String sign_status, String credit_grade, Map<String ,String> param ){

	    	String rtn[] = null;
	    	try{

	    		rtn = SR_setRegister(vendor_code, sg_refitem, is_registry, sign_status, credit_grade, param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}



		/**
		 * @description : 스크리닝 결과 등록
		 * @date : 2010-03-11
		 * @author useonlyj
		 * */
	  	private String[] SR_setRegister(String vendor_code, String sg_refitem, String is_registry, String sign_status, String creditgrade, Map<String ,String> param ) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();

	    	String user_id = info.getSession("ID");
	    	String house_code = info.getSession("HOUSE_CODE");

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

	    	String JOB_STATUS	  = "";

	    	JOB_STATUS = (new SepoaFormater(getVendorJobStatus(vendor_code))).getValue("JOB_STATUS", 0);

	    	String[][] setData = new String[1][];
	    	String[]   temp = {vendor_code};
			try{

				setData[0] = temp;

				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("is_registry", is_registry);
	  	    	param.put("house_code"      , house_code);
	  	    	param.put("user_id"         , user_id);
	  	    	param.put("registry_flag"   , is_registry);
	  	    	
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
	  	    	rtnIns = sm.doUpdate(param);

	  	    	SepoaXmlParser wxp_sgvn = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn.getQuery());//sql.toString() );
	  	    	rtnIns = sm.doUpdate( param);	  	    	
	  	    	
		  	    if(is_registry.equals("R")){//업체 반려일 경우
		  	    	
		  	    	/*
		  	    	// 업체 소싱정보 삭제
		  	    	SepoaXmlParser wxp_vssi = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_VSSI_D");
					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vssi.getQuery());//sql.toString() );
		  	    	rtnIns = sm.doDelete(param);
		  	    	
		  	    	// 업체 소싱그룹연결정보 삭제
		  	    	SepoaXmlParser wxp_sgvn_d = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_SGVN_D");
					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn_d.getQuery());//sql.toString() );
		  	    	rtnIns = sm.doDelete(param);
		  	    	*/
		  	    	
		  	    	// 업체 상태변경
		  	    	SepoaXmlParser wxp_job = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_job");
					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_job.getQuery());//sql.toString() );
		  	    	rtnIns = sm.doUpdate(param); 
		  	    	
		  	    	//반려 알림 SMS 전송
		  	    	Map<String, String> smsParam = new HashMap<String, String>();
					
		  	    	smsParam.put("HOUSE_CODE",  house_code);
		  	    	smsParam.put("VENDOR_CODE", param.get("vendor_code"));
					
					new SMS("NONDBJOB", info).rg1Process(ctx, smsParam);
//					new mail("NONDBJOB", info).rg1Process(ctx, smsParam);
					
		  	    } else {//업체 승인일 경우
		  	    	
		  	    	String decryptPassword = com.icompia.util.CommonUtil.getRandomString(6, "NS");
		  	    	String encryptPassword = decryptPassword;
		  	    	
		  	    	rtnIns = createUser(ctx, param, encryptPassword);
		  	    	rtnIns = createMaker(ctx, param);
		  	    	//rtnIns = insertFreeCP(ctx, param);
//					rtnIns = setSGVN_STATUS(ctx,"Y",param);
		  	    	rtnIns = setSGVN_STATUS(ctx,"Y",param);
		  	    	
		  	    	rtnIns = setSIGN_STATUS(ctx, "E", param);
		  	    	
		  	    	//업체승인 후 업체코드 변환
		  	    	SepoaFormater new_vendor_sf= makeNewVendorCode(ctx);
		  	    	String old_vendor_code1 = new_vendor_sf.getValue("VENDOR_CODE1", 0);
		  	    	String old_vendor_code2 = new_vendor_sf.getValue("VENDOR_CODE2", 0);
		  	    	String new_vendor_code1 = "";
		  	    	String new_vendor_code2 = "";
		  	    	
		  	    	Logger.debug.println( info.getSession("ID"), this, "#################### old vendor_code1 : " + old_vendor_code1 );
		  	    	Logger.debug.println( info.getSession("ID"), this, "#################### old vendor_code2 : " + old_vendor_code2 );
		  	    	
		  	    	if("9999".equals(old_vendor_code2)) {
		  	    		if("A".equals(old_vendor_code1)) {
		  	    			new_vendor_code1 = "B";
		  	    		} else if("B".equals(old_vendor_code1)) {
		  	    			new_vendor_code1 = "C";
		  	    		} else if("C".equals(old_vendor_code1)) {
		  	    			new_vendor_code1 = "D";//업체코드가 C9999를 초과되어 생성되지 못할 것 같지만 에러가 날 수도 있기에 D로 변환되도록 처리함
		  	    		}
		  	    		new_vendor_code2 = "0001";
		  	    	} else {
		  	    		new_vendor_code1 = old_vendor_code1;
		  	    		new_vendor_code2 = SepoaString.getLpad( String.valueOf( Integer.valueOf( old_vendor_code2 ) + 1 ) , 4, "0" );
		  	    	}
		  	    	
		  	    	Logger.debug.println( info.getSession("ID"), this, "#################### new vendor_code1 : " + new_vendor_code1 );
		  	    	Logger.debug.println( info.getSession("ID"), this, "#################### new vendor_code2 : " + new_vendor_code2 );
		  	    	
		  	    	String new_vendor_code = new_vendor_code1 + new_vendor_code2;
		  	    		
		  	    	rtnIns = updateVendorCodeVNGL(ctx, param, new_vendor_code);//ICOMVNGL
		  	    	rtnIns = updateVendorCodeLUSR(ctx, param, new_vendor_code);//ICOMLUSR
		  	    	rtnIns = updateVendorCodeADDR(ctx, param, new_vendor_code);//ICOMADDR
		  	    	rtnIns = updateVendorCodeVNCP(ctx, param, new_vendor_code);//ICOMVNCP
		  	    	rtnIns = updateVendorCodeSGVN(ctx, param, new_vendor_code);//SSGVN
		  	    	rtnIns = updateVendorCodeVNPJ(ctx, param, new_vendor_code);//ICOMVNPJ : UPDATE 대상이 없어도 예외처리하지 않음
		  	    	rtnIns = updateVendorCodeVNIT(ctx, param, new_vendor_code);//ICOMVNIT : UPDATE 대상이 없어도 예외처리하지 않음		  
		  	    	
		  	    }
		  	    
	    		Commit();

	    	} catch( Exception e ) {
//	    		e.printStackTrace();
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally{}

	    	return returnString;
	  	}

	  	/*
	  	 * 등록대기업체 등록 결재 모듈
	  	 */
	  	public SepoaOut setApproval(String vendor_code, String sg_refitem, String is_registry, String sign_status, String credit_grade, Map<String, String> param, String sign_flag, String approval){
	    	String rtn[] = null;
	    	try{


	    			String user_id        = info.getSession("ID");
		            String house_code     = info.getSession("HOUSE_CODE");
		            String company_code   = info.getSession("COMPANY_CODE");
		            String user_dept      = info.getSession("DEPARTMENT");
		            
		            if("P".equals(sign_status)){
		                
		            	SignRequestInfo sri = new SignRequestInfo();
		                sri.setHouseCode(house_code);
		                sri.setCompanyCode(company_code);
		                sri.setDept(user_dept);
		                sri.setReqUserId(info.getSession("ID"));
		                sri.setDocType("VM");
		                sri.setDocNo(vendor_code);
		                
		                /*
		                 * DocSeq = sg_refitem  결재 승인에서 소싱정보가 업데이트 되기 때문에
		                 * 소싱정보를 결재 모듈로 넘겨줘야 할 필요성이 있음.
		                 * 업체 승인시에 docSeq를 사용하지 않음 그래서 소싱번호를 넘겨줌.
		                 */
		                 
		                sri.setDocSeq(sg_refitem);
		                sri.setSignStatus("P");
		                sri.setCur("KRW");
		                sri.setTotalAmt(0.0);
		                sri.setShipperType("D");
		                sri.setItemCount(1);
		                sri.setSignString(approval); // AddParameter 에서 넘어온 정보
		               
		               
		            	
		                SepoaOut wo = CreateApproval(info,sri);    //밑에 함수 실행
		            	 
		                if(wo.status == 0) {
		                	
		                	setStatus(100);
		                    throw new Exception(msg.getMessage("4000"));
		                } else if(wo.status == 1){
		                	
		                	rtn = SR_setApproval(vendor_code, sg_refitem, is_registry, sign_status, credit_grade, param);

		                	setMessage( rtn[ 0 ] );
		    	    		setValue( "update Row=" + rtn );
		    	    		setStatus( 1 );

		    	    		if ( rtn[ 1 ] != null ){
		    	    		    setMessage( rtn[ 1 ] );
		    	    		    setStatus( 0 );
		    	    		}
		                }
		            }
		           	Commit();
		            setStatus(1);
		            if(sign_status.equals("P")){
		            	setMessage("");
		        	}
	    	} catch ( Exception e ) {
	    	    try {
					Rollback();
				} catch (SepoaServiceException e1) {
					// TODO Auto-generated catch block
					Logger.err.println( info.getSession( "ID" ), this, "Exception e1 =" + e1.getMessage() );
				}
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

	  	private String[] SR_setApproval(String vendor_code, String sg_refitem, String is_registry, String sign_status, String credit_grade, Map<String, String> param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();

	    	String user_id = info.getSession("ID");
	    	String house_code = info.getSession("HOUSE_CODE");

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

	    	String JOB_STATUS	  = "";
	    	/*
			is_registry = "Y"; //등록
			is_registry = "R"; //반려

			ICOMVNGL.JOB_STATUS = 'P'(아이디신청)  이거나 JOB_STATUS = 'E'(승인된업체가 다른 스크린닝을 요청한경우)
			ICOMVNGL.JOB_STATUS = 'P' 인경우에만 ICOMVNGL쪽에 업데이트 및 유저생성을 한다.
			ICOMVNGL.JOB_STATUS = 'E' 인경우에는 기존 소싱로직을 따른다.
	    	*/

	    	JOB_STATUS = (new SepoaFormater(getVendorJobStatus(vendor_code))).getValue("JOB_STATUS", 0);

//	    	String[][] setData = new String[1][];
//	    	String[]   temp = {vendor_code};
			try{

//				setData[0] = temp;
				SepoaXmlParser wxp_sgvn = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
//				wxp_sgvn.addVar("house_code",house_code);
//				wxp_sgvn.addVar("user_id",user_id);

//		    	String[] type4 = { "S", "S", "S", "S", "S", "S", "S", "S", "S" };

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn.getQuery());//sql.toString() );
	  	    	param.put("user_id", user_id);
				
	  	    	rtnIns = sm.doUpdate(param);

	  	    	SepoaXmlParser wxp_sign = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sign");
//				wxp_sign.addVar("house_code",house_code);
//				wxp_sign.addVar("sign_status", sign_status);
				wxp_sign.addVar("is_registry", is_registry);

//		    	String[] type5 = { "S" };
	  	    	param.put("sign_status", sign_status);
	  	    	
	  	    	sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sign.getQuery());//sql.toString() );
	  	    	rtnIns = sm.doUpdate(param);
	  	    	
	  	    	

	    	} catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally{}

	    	return returnString;
	  	}

	  	private int setSGVN_STATUS(ConnectionContext ctx, String REG_FLAG, String[][] setData) throws Exception
		{
			int rtn = -1;

			try
			{
				String house_code = info.getSession("HOUSE_CODE");
	            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	            wxp.addVar("REG_FLAG", REG_FLAG);
	            wxp.addVar("house_code", house_code);

				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				String[] type = { "S"};

				rtn = sm.doUpdate(setData, type);

			}
			catch(Exception e)
			{
				String serrMessage  = e.getMessage();
				String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
				if(sdbErrorCode.equals("ORA-00001") == true)
				{
					rtn = -1;
				}
				else
				{
					throw new Exception("setSIGN_STATUS:"+e.getMessage());
				}
			} finally {	}
			return rtn;
		}
	  	
	  	private int setSGVN_STATUS(ConnectionContext ctx, String REG_FLAG, Map<String, String> setData) throws Exception
	  	{
	  		int rtn = -1;
	  		
	  		try
	  		{
	  			String house_code = info.getSession("HOUSE_CODE");
	  			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	  			wxp.addVar("REG_FLAG", REG_FLAG);
	  			wxp.addVar("house_code", house_code);
	  			
	  			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	  			
	  			String[] type = { "S"};
	  			
	  			rtn = sm.doUpdate(setData);
	  			
	  		}
	  		catch(Exception e)
	  		{
	  			String serrMessage  = e.getMessage();
	  			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
	  			if(sdbErrorCode.equals("ORA-00001") == true)
	  			{
	  				rtn = -1;
	  			}
	  			else
	  			{
	  				throw new Exception("setSIGN_STATUS:"+e.getMessage());
	  			}
	  		} finally {	}
	  		return rtn;
	  	}

	  	private int setSGVN_REJECT(ConnectionContext ctx, String REG_FLAG, String[][] setData) throws Exception
		{
			int rtn = -1;

			try
			{

				String house_code = info.getSession("HOUSE_CODE");
	            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	            wxp.addVar("REG_FLAG", REG_FLAG);
	            wxp.addVar("house_code", house_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				String[] type = { "S" , "S"};

				rtn = sm.doUpdate(setData, type);

			}
			catch(Exception e)
			{
				String serrMessage  = e.getMessage();
				String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
				if(sdbErrorCode.equals("ORA-00001") == true)
				{
					rtn = -1;
				}
				else
				{
					throw new Exception("setSIGN_STATUS:"+e.getMessage());
				}
			} finally {	}
			return rtn;
		}





	  	/*public SepoaOut updateInfo(String vendor_code, String grade, String[][] param){

	    	String rtn[] = null;
	    	try{

	    		rtn = SR_updateInfo(vendor_code, grade, param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

		*//**
		 * @description : 스크리닝 저장
		 * @date : 2010-03-11
		 * @author useonlyj
		 * *//*
	  	private String[] SR_updateInfo(String vendor_code, String grade, String[][] param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();

	    	String user_id = info.getSession("ID");
	    	String house_code = info.getSession("HOUSE_CODE");

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

			try{


				SepoaXmlParser wxp_sgvn = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
				wxp_sgvn.addVar("house_code", house_code);
				wxp_sgvn.addVar("user_id", user_id);

			    String[] type2 = { "S", "S", "S", "S", "S", "S", "S", "S" };

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn.getQuery()); //sql.toString() );
		    	rtnIns = sm.doUpdate( param, type2 );

		    	SepoaXmlParser wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vngl");
				wxp_vngl.addVar("house_code", house_code);

				// 신용등급, 현금흐름등급은 NiceDnb 의 값을 조회

				String value[][] = new String[1][2];
				value[0][0] = grade;
				value[0][1] = vendor_code;

			    String[] type3 = { "S", "S" };

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());// sql.toString() );
	    	   	rtnIns = sm.doUpdate( value, type3 );

	  	    	Commit();

	  	    	} catch( Exception e ) {
	  	    	    Rollback();
	  	    	    returnString[ 1 ] = e.getMessage();
	  	    	} finally { }

	  	    	return returnString;
	  	}

*/

	  	/*public SepoaOut updateProgStatus(String vendor_code, String status, String grade, String sg_refitem, String[][] param)
	  	{

	    	String rtn[] = null;
	    	try{

	    		rtn = SR_updateProgStatus(vendor_code, status, grade, sg_refitem, param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

		*//**
		 * @desription : 스크리닝 반려처리
		 * @date : 2010-03-11
		 * @author useonlyj
		 * *//*
	  	private String[] SR_updateProgStatus(String vendor_code, String status, String grade, String sg_refitem, String[][] param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();
//	    	StringBuffer sql = new StringBuffer();

	    	String user_id = info.getSession("ID");
	    	String house_code = info.getSession("HOUSE_CODE");

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

			try{

				if(status.equals("2") || status.equals("3")){

					SepoaXmlParser wxp_sgvn = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn");
					wxp_sgvn.addVar("house_code",house_code);
					wxp_sgvn.addVar("user_id",user_id);

					String value[][] = new String[1][3];
					value[0][0] = status;
					value[0][1] = vendor_code;
					value[0][2] = sg_refitem;
	    	    	String[] type = { "S", "S", "S" };

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_sgvn.getQuery());//sql.toString() );
	  	    		rtnIns = sm.doUpdate( value, type );

	  	    		if(status.equals("3")){

	  	    			SepoaXmlParser wxp_vngl = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vngl");

						String value1[][] = new String[1][2];
						value1[0][0] = grade;
						value1[0][1] = vendor_code;

				    	String[] type1 = { "S", "S" };

						sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl.getQuery());// sql.toString() );
		    	    	rtnIns = sm.doUpdate( value1, type1 );
					}

	    		}else if(status.equals("4")) {
//
	    			SepoaXmlParser wxp_sgvn_end = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_sgvn_end");
	    			wxp_sgvn_end.addVar("house_code",house_code);
	    			wxp_sgvn_end.addVar("user_id",user_id);

	    	    	String[] type2 = { "S", "S", "S", "S", "S", "S", "S" ,"S", "S"};

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx,wxp_sgvn_end.getQuery());// sql.toString() );
	  	    		rtnIns = sm.doUpdate( param, type2 );

	  	    		SepoaXmlParser wxp_vngl_end = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_vngl_end");
	  	    		wxp_vngl_end.addVar("house_code",house_code);

					String value[][] = new String[1][2];
					value[0][0] = grade;
					value[0][1] = vendor_code;

	    	    	String[] type3 = { "S", "S" };

					sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp_vngl_end.getQuery());//sql.toString() );
	  	    		rtnIns = sm.doUpdate( value, type3 );

	    		}
	//Mail 발송 주석처리
	
	    		//mail & sms
	    		String dept = "";
	    		String s_mail = "";
	    		String s_name = "";
	    		String r_mail = "";
	    		String r_name = "";
	    		String phoneNo = "";


	    		String rtn = null;
	    		String sms_msg = "";
	    		String[] arg = null;


	          	if(status.equals("2")) {

	          		arg = getMailInfo(vendor_code, "신용평가요청", "LEVEL1", "");
	  	    		int sended = setMail( arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8], arg[10] );
	  	    		if(sended == 0) {
	  	    			throw new Exception();
	  	    		}
	  	    		sms_msg  = "귀사는 웅진씽크빅 업체등록 절차에 따라 신용평가가 필요합니다. 웅진씽크빅 " + arg[7];
	  	    		setSMS(sms_msg, arg[9]);

	  	    	}else if(status.equals("4")) {

	  	    		String term = param[0][1] + "~" + param[0][2];
	  	    		arg = getMailInfo(vendor_code, "실사평가", "LEVEL2", "");
	  	    		int sended = setMail( arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], term, arg[10] );
	  	    		if(sended == 0) {
	  	    			throw new Exception();
	  	    		}
	  	    		sms_msg = "귀사는 공급사 등록절차에 의거하여 실사를 받으셔야 합니다. 웅진씽크빅 " + arg[7];
	  	    		setSMS(sms_msg, arg[9]);

	  	    	}
	
	    		Commit();

	    	} catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { }

	    	return returnString;
	  	}*/

	  	public SepoaOut getSgContentsList(String sg_refitem){

	     	try{

	     		String user_id = info.getSession("ID");
	      		String rtn = "";

	      		rtn = et_getSgContentsList(user_id, sg_refitem);

	      		setValue(rtn);
	      		setStatus(1);
	      		setMessage(msg.getMessage("0000"));

	      	} catch(Exception e) {
	      		Logger.err.println("Exception e =" + e.getMessage());
	      		setStatus(0);
	      		setMessage(msg.getMessage("0001"));
	      		Logger.err.println(this,e.getMessage());
	      	}
	      	return getSepoaOut();
	  	}

	  	/**
	  	 * @description :등록업체 목록 조회
	  	 * @date : 2010-03-11
	  	 * @author useonlyj
	  	 * */
	  	private String et_getSgContentsList(String user_id, String sg_refitem) throws Exception{

	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");


	      	try {

	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", house_code);
				wxp.addVar("sg_refitem", sg_refitem);


	      	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
	      	rtn = sm.doSelect((String[])null);

	      		if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getItemLst:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}

	  	public SepoaOut getRegVenLst(Map<String, String> header)
	  	{
	     	try
	     	{
	     		//String user_id = info.getSession("ID");
	      		String rtn = "";

	      		rtn = et_getRegVenLst(header);

	      		setValue(rtn);
	      		setStatus(1);
	      		setMessage(msg.getMessage("0000"));

	      	} catch(Exception e) {
	      		Logger.err.println("Exception e =" + e.getMessage());
	      		setStatus(0);
	      		setMessage(msg.getMessage("0001"));
	      		Logger.err.println(this,e.getMessage());
	      	}
	      	return getSepoaOut();
	  	}
/**
 * @desription : 등록업제 목록 조회
 * @date : 2010-03-11
 * @author useonlyj
 *
 * */
	  	private String et_getRegVenLst(Map<String, String> header) throws Exception
	  	{
	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String house_code = info.getSession("HOUSE_CODE");
	      	String user_id    = info.getSession("ID");
            String slevel     = "";
	      	/*String vendor_name	= param[0];
	      	String level 		= param[1];
	      	String sg_refitem 	= param[2];
	      	//String RESIDENT_NO 	= param[3];
			String IRS_NO 		= param[3];
			String CLASS_GRADE 	= param[4];
			String pjt_name 	= param[5];*/

	      	try
	      	{
	      		slevel = header.get("level");
	      		if(!slevel.equals("1") && !slevel.equals("2") && !slevel.equals("3"))
	      			slevel = "4";
	      			
	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	      		/*wxp.addVar("house_code", 	house_code);
	      		wxp.addVar("sg_refitem", 	sg_refitem);
	      		wxp.addVar("vendor_name", 	vendor_name);
	      		wxp.addVar("level", 		level);
	      		//wxp.addVar("RESIDENT_NO", 	RESIDENT_NO);
	      		wxp.addVar("IRS_NO", 		IRS_NO);
	      		wxp.addVar("CLASS_GRADE", 	CLASS_GRADE);
	      		wxp.addVar("pjt_name", 		pjt_name);
	      		//wxp.addVar("add_date_start", 		param[5]);
	      		//wxp.addVar("add_date_end", 		param[6]);
	      		*/
	      		wxp.addVar("slevel", 		slevel);
	      		
	          	SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());//tSQL.toString());
	          	rtn = sm.doSelect(header);

	          	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("et_getRegVenLst:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}

	  	/**
		 * 업체 거래 정지 결재
		 * @method setBlockApproval
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-28
		 * @modify 2014-10-28
		 */
	    public SepoaOut setBlockApproval(String SIGN_FLAG, String APPROVAL, String VENDOR_CODE)
		{
			try {
				String user_id               = info.getSession("ID");
				String house_code            = info.getSession("HOUSE_CODE");
				String company_code          = info.getSession("COMPANY_CODE");
				String user_dept             = info.getSession("DEPARTMENT");
				Map<String, String> paramMap = new HashMap<String, String>();
				
				
				//if(SIGN_FLAG.equals("P")){
				if(SIGN_FLAG.equals("E")){
					// 업체 거래정지 품의번호 채번
					/*
					SepoaOut wo          = appcommon.getDocNumber(info,"VN");
					String block_no      = wo.result[0];
					*/
					
					
					/*SignRequestInfo sri = new SignRequestInfo();
					sri.setHouseCode(house_code);
					sri.setCompanyCode(company_code);
					sri.setDept(user_dept);
					sri.setReqUserId(info.getSession("ID"));
					sri.setDocType("VN");
					sri.setDocNo(VENDOR_CODE);
					sri.setDocSeq("0");
					sri.setSignStatus("P");
					sri.setCur("KRW");
					sri.setTotalAmt(0.0);
					sri.setShipperType("D");
					sri.setItemCount(1);
					sri.setSignString(APPROVAL); // AddParameter 에서 넘어온 정보 APPROVAL : "save"
					System.out.println("debug:p0070:1652"+APPROVAL);
					
					SepoaOut wo = CreateApproval(info,sri);    //밑에 함수 실행 WORK 필요
					
					System.out.println("debug:p0070:1656"+wo.status);*/
					
					
//					if(wo.status == 0) {
//						throw new Exception(msg.getMessage("4000"));
//					} else if(wo.status == 1){
						String[][] param = {{"P", VENDOR_CODE}};
						paramMap.put("purchase_block_flag", "P");		//결재진행중
						paramMap.put("purchase_block_flag", "Y");		//중지
						paramMap.put("vendor_code", VENDOR_CODE);
						
						String[] rtn = SR_setBlock(paramMap);

						if ( rtn[ 1 ] != null ){
							Rollback();
							setStatus(0);
							setMessage(msg.getMessage("4000"));
							return getSepoaOut();
						}
					}
//				}

				Commit();
				setStatus(1);
				if(SIGN_FLAG.equals("P")){
					setMessage("거래정지가 결재요청 되었습니다.");
				}else{
					setMessage("거래정지가 저장 되었습니다.");
				}
				}catch(Exception e)
				{
					//if(!sign_status.equals("P")){
					try{
					Rollback();
					}catch(Exception e1){ Logger.err.println("Exception e1 =" + e1.getMessage()); }
					//}
					Logger.err.println("Exception e =" + e.getMessage());
					setStatus(0);
					setMessage(msg.getMessage("4000"));
					Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();
		}


	  //결재 상신을 위한 결재 공통모듈을 부른다.
		private SepoaOut CreateApproval(SepoaInfo info,SignRequestInfo sri) {

			SepoaOut value = null;
			SepoaRemote ws = null;
			
			
			Object[] obj = { sri };
 			value = ServiceConnector.doService(info, "p6027", "TRANSACTION", "addSignRequest", obj);

			
			/*
			String nickName= "p6027";
			String conType = "NONDBJOB";
			String MethodName1 = "setConnectionContext";
			ConnectionContext ctx = getConnectionContext();
			try {
				Object[] obj1 = {ctx};
				String MethodName2 = "addSignRequest";
				Object[] obj2 = {sri};

				ws = new SepoaRemote(nickName,conType,info);
				ws.lookup(MethodName1,obj1);
				wo=ws.lookup(MethodName2,obj2);
			}catch(Exception e) {
				setStatus(0);
				e.printStackTrace();
				Logger.err.println("approval: = " + e.getMessage());
			}*/
			return value;
		}

		public SepoaOut Approval(SignResponseInfo inf)
		{
			int rtnIns = 0;
			String rtn = "";
			Map<String, String> paramMap = new HashMap<String, String>();
			String sepoaSecretCode = null;
			
			try
			{
				String ans           = inf.getSignStatus();
				String doc_type 	 = inf.getDocType();
				String[] doc_no      = inf.getDocNo();
				String[] com_code    = inf.getCompanyCode();
				String[] doc_seq     = inf.getDocSeq();

				String flag    = "";
				String reg_no  = "";
				ConnectionContext ctx = getConnectionContext();

				SepoaOut value = null;
				String PURCHASE_BLOCK_FLAG ="";

				String decryptPassword = com.icompia.util.CommonUtil.getRandomString(6, "NS");
		    	String encryptPassword = decryptPassword;

		    	String mail_type = "";
		    	String sms_type = "";
		    	String[] erpVendor_result = new String[2];
				//업체승인시
				if("VM".equals(doc_type)){
					for(int j = 0 ; j < doc_no.length; j++){
						String[][] param = {{doc_no[j]}};
						String[][] param_sgvn = {{doc_no[j]}};
						if(ans.equals("E")){
							rtnIns = setSIGN_STATUS(ctx, "E", param);
							rtn    = getIrsNo_RegNo(ctx, param);
							reg_no = (new SepoaFormater(rtn)).getValue("REG_NO", 0);

							boolean secret_code = false;
					    	try {
					    		Configuration conf = new Configuration();
					    		
					    		sepoaSecretCode = conf.get("Sepoa.secret.code");
					    		
					    		if(sepoaSecretCode == null){
					    			sepoaSecretCode = "";
					    		}
					    		
					    		sepoaSecretCode = sepoaSecretCode.trim();
						    		
					    		if("true".equals(sepoaSecretCode)){
					    			secret_code = true;
					    		}
					    		else{
					    			secret_code = false;
					    		}
					    	} catch(Exception e) {
					    		throw e;
					    	}

					    	if(secret_code){
					    		//2011/11/23
					    		//비밀번호를 아이디와 동일하게 발급
					    		//CEncrypt encrypt = new CEncrypt("MD5", encryptPassword);
					    		CEncrypt encrypt = new CEncrypt("MD5", doc_no[j]);
					    		encryptPassword = encrypt.getEncryptData();
					    	}

							rtnIns = createUser(ctx, param, encryptPassword);
							rtnIns = createMaker(ctx, param);
							//rtnIns = insertFreeCP(ctx, param);
							rtnIns = setSGVN_STATUS(ctx,"Y",param_sgvn);

							/*승인 일 경우만 SMS&메일 전송*/
							//mail_type 	= "M00013";
							sms_type = "S00002";
							
							// 공급사정보 I / F
			    			// ERP로 넘기 데이터 가져오기 (신규등록)
//			    			ERPInterface erpIF = new ERPInterface("CONNECTION",info);
//			    			erpVendor_result = erpIF.erpVendorInsert(getERPVendorList(reg_no));
							
			    			if(erpVendor_result[0].equals("2")){
		 	    				break;
			    			}
						}else if(ans.equals("D")){
							rtnIns  = setSIGN_STATUS(ctx, "D", param);	// 취소
//							rtnIns  = setSGVN_REJECT(ctx, "R", param_sgvn);	// 반려
						}else {
							rtnIns  = setSIGN_STATUS(ctx, "R", param);	// 반려
						}
					}
	    			if(!"2".equals(erpVendor_result[0])){
						Commit();
						setStatus(1);
	    			}else{
	    				Rollback();
	    				setStatus(0);
	    				setMessage(erpVendor_result[1]);
	    			}
				}else{ //업체 거래정지일시

					if(ans.equals("E")){
						PURCHASE_BLOCK_FLAG = "Y"; // 구매정지/결재완료
						sms_type	= "S00004";
						mail_type 	= "M00004";
					} else{
						PURCHASE_BLOCK_FLAG = "N";	// 반려
						sms_type	= "S00003";
						mail_type 	= "M00003";
					}
					String[][] param = {{PURCHASE_BLOCK_FLAG, doc_no[0]}};
					
					paramMap.put("purchase_block_flag", PURCHASE_BLOCK_FLAG);
					paramMap.put("doc_no", doc_no[0]);
					
					value = setBlock(paramMap);

					if(ans.equals("E")){
//		    			sendSMS_MAIL(ctx, ans, args );
					}
					Commit();
					setStatus(1);
				}
		        // SMS 전송, MAIL 전송
/*
				String[] args 			= {doc_no[0]};
				Object[] sms_args 		= {args};
				Object[] vmE_sms_args 	= {args, decryptPassword}; 	// 업체승인시

		        String sms_type = "";
		        String mail_type = "";
		        if("VM".equals(doc_type)){
		        	if("E".equals(ans)){	// 업체등록승인
		        		sms_args = vmE_sms_args;
		        		sms_type	= "S00002";
		        	}else {					// 업체등록반려
		        		sms_type	= "S00003";
		        	}
		        }else if("VN".equals(doc_type)){
		        	if("E".equals(ans)){	// 거래중지 결재완료
		        		sms_type	= "S00004";
		        		mail_type 	= "M00004";
		        	}
		        }
		        if(!"".equals(sms_type)){
		        	ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, sms_args);
		        }
		        if(!"".equals(mail_type)){
		        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
		        }
*/
				/*업체승인 시*/
				if(!"".equals(mail_type)){
					ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, new Object[]{doc_no});
				}
				
				// SMS 전송
				if(!"".equals(sms_type)){
					String[] args 			= {doc_no[0]};
					Object[] vmE_sms_args 	= {args, decryptPassword}; 	// 업체승인시

					ServiceConnector.doService(info, "SMS", "TRANSACTION", sms_type, vmE_sms_args);
				}

			}
			catch(Exception e)
			{
				Logger.err.println("setSignStatus: = " + e.getMessage());
				setStatus(0);
			}

			return getSepoaOut();
		}
		
		private SepoaFormater getERPVendorList(String vendor_code) throws Exception {
			String house_code = info.getSession("HOUSE_CODE");
			String user_id = info.getSession("ID");
			SepoaFormater wf = null;
			try{
				ConnectionContext ctx =	getConnectionContext();
				//현재 문서아이템의 갯수 조회
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", house_code);
				wxp.addVar("vendor_code", vendor_code);
				
				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
				wf = new SepoaFormater(sm.doSelect((String[])null));	

			}catch (Exception e) {
				throw new Exception("getERPVendorList : " + e.getMessage());
			} finally {
			}
			return wf;
		}
		
		private String getIrsNo_RegNo(ConnectionContext ctx, String[][] pData) throws Exception {

		    String rtn = "";

		    try {

		    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
		    	wxp.addVar("vendor_code", pData[0][0]);
		    	wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

		    	SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

		    	rtn = sm.doSelect((String[])null);

		    }catch(Exception e) {
		        Logger.debug.println(info.getSession("ID"),this,"getIrsNo_RegNo = " + e.getMessage());
		    } finally{

		    }
		    return rtn;
		}

	  	public SepoaOut setBlock(Map<String, String> param){			//거래 개시

	  		
	    	String rtn[] = null;
	    	try{

	    		rtn = SR_setBlock(param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

	  	/**
	  	 *@description : 등록업체 목록 - 거래개시 
	  	 *@date : 2010-03-11
	  	 *@author useonlyj
	  	 * */

	  	private String[] SR_setBlock(Map<String, String> param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();
	    	String house_code = info.getSession("HOUSE_CODE");
	    	String user_id = info.getSession("ID");

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

			try{

				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				//wxp.addVar("house_code", house_code);

		    	//String[] type = { "S", "S" };
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
	    	   	rtnIns = sm.doUpdate(param);

	  	    	Commit();

	  	    } catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { }

	    	return returnString;
	  	}

	  	public SepoaOut updateCreditLevel(String[][] param){

	    	String rtn[] = null;
	    	try
	    	{
	    		rtn = SR_updateCreditLevel(param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}

		/**
		 * @description : 신용등급 일괄변경- 엑셀업로드
		 * @date : 2010-03-11
		 * @author useonlyj
		 * */
	  	private String[] SR_updateCreditLevel(String[][] param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();

	    	String user_id = info.getSession("ID");
	    	String house_code = info.getSession("HOUSE_CODE");


	    	int rtnIns = 0;
	    	SepoaSQLManager sm = null;

			try{
//	  	    	sql.append( " UPDATE ICOMVNGL SET		  	\n " );
//				sql.append( "        CREDIT_RATING = ?	  	\n " );
//				sql.append( " WHERE VENDOR_CODE = ? 	  	\n " );
//				sql.append( " 	AND HOUSE_CODE = '"+house_code+"'	\n " );

				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code",house_code);
		    	String[] type = { "S" , "S" };
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());//sql.toString() );
	    	   	rtnIns = sm.doUpdate( param, type );
	  	   		Commit();

	  	    } catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { }

	    	return returnString;
	  	}

		public SepoaOut getVenbdlis1(String vendor_code, String vendor_code_name)
		{
			String rtn = null;

			try
			{
				rtn = et_getVenbdlis1(vendor_code, vendor_code_name);
				setValue(rtn);
				setStatus(1);
			}catch(Exception e){
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("ExpandTree faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();

		}

		private String et_getVenbdlis1(String vendor_code, String vendor_code_name) throws Exception
		{
	   		String rtn = null;
	   		ConnectionContext ctx = getConnectionContext();
			String house_code = info.getSession("HOUSE_CODE");

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", house_code);
//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append("SELECT                                                          		\n");
//			tSQL.append("		A.VENDOR_CODE AS VENDOR_CODE,  									\n");
//			tSQL.append("		B.VENDOR_NAME_LOC AS NAME_LOC,  										\n");
//			tSQL.append("		dbo.GETSGNAME(A.PARENT1) AS S_TYPE1,                         		\n");
//			tSQL.append("		dbo.GETSGNAME(A.PARENT2) AS S_TYPE2,                         		\n");
//			tSQL.append("		dbo.GETSGNAME(A.SG) AS S_TYPE3,                              		\n");
//			tSQL.append("		dbo.GETSCREENNAME(A.S_TEMPLATE_REFITEM) AS S_TEMPLATE,  			\n");
//			tSQL.append("		dbo.GETICOMCODE2('"+house_code+"','M121',A.SCREENING_STATUS) AS S_RESULT,\n");
//			tSQL.append("		A.SG AS SG_REFITEM                              				\n");
//			tSQL.append("FROM                                                            		\n");
//			tSQL.append("(                                                               		\n");
//			tSQL.append("	SELECT                                                       		\n");
//			tSQL.append("		   (SELECT PARENT_SG_REFITEM                             		\n");
//			tSQL.append("			   FROM ICOMSGCN                                  		\n");
//			tSQL.append("			  WHERE SG_REFITEM = B.PARENT_SG_REFITEM) AS PARENT1,		\n");
//			tSQL.append("			B.PARENT_SG_REFITEM AS PARENT2,                      		\n");
//			tSQL.append("			A.SG_REFITEM AS SG,                                  		\n");
//			tSQL.append("			A.VENDOR_CODE AS VENDOR_CODE,                          		\n");
//			tSQL.append("			A.SCREENING_STATUS AS SCREENING_STATUS,              		\n");
//			tSQL.append("			A.S_TEMPLATE_REFITEM AS S_TEMPLATE_REFITEM					\n");
//			tSQL.append("	FROM 	ICOMSGVN A, ICOMSGCN B          							\n");
//			tSQL.append("	WHERE   A.SG_REFITEM = B.SG_REFITEM                          		\n");
//			tSQL.append("	AND		A.HOUSE_CODE = '"+house_code+"'								\n");
//			tSQL.append("	AND		A.HOUSE_CODE = B.HOUSE_CODE									\n");
//			tSQL.append("	AND		B.LEVEL_COUNT = '3'                                  		\n");
//			tSQL.append("	AND		A.S_TEMPLATE_REFITEM <> 0                  					\n");//MIGRATION OR BUYER INSERT DATA
//			tSQL.append("	--ORDER BY VENDOR_CODE                    							\n");
//			tSQL.append(") A, ICOMVNGL B                                                   		\n");
//			tSQL.append("WHERE	A.VENDOR_CODE = B.VENDOR_CODE									\n");
//			tSQL.append("AND	B.HOUSE_CODE = '"+house_code+"'									\n");
//	        tSQL.append(" <OPT=S,S>   AND  A.VENDOR_CODE  = ? </OPT>                           	\n");
//	        tSQL.append(" <OPT=S,S>   AND  B.VENDOR_NAME_LOC LIKE '%'+?+'%' </OPT>                  	\n");
//			tSQL.append("\n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	        String[] data = {vendor_code, vendor_code_name};

			rtn = sm.doSelect(data);
			return rtn;
		}

		public SepoaOut getVenbdlis2(String vendor_code, String vendor_code_name)
		{
			String rtn = null;

			try
			{
				rtn = et_getVenbdlis2(vendor_code, vendor_code_name);
				setValue(rtn);
				setStatus(1);
			}catch(Exception e){
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("ExpandTree faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();

		}

		private String et_getVenbdlis2(String vendor_code, String vendor_code_name) throws Exception
		{
	   		String rtn = null;
	   		ConnectionContext ctx = getConnectionContext();
			String house_code = info.getSession("HOUSE_CODE");

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				wxp.addVar("house_code", house_code);

//			StringBuffer tSQL = new StringBuffer();
//
//			tSQL.append("SELECT                                                          		\n");
//			tSQL.append("		A.VENDOR_CODE AS VENDOR_CODE,  									\n");
//			tSQL.append("		B.VENDOR_NAME_LOC AS NAME_LOC,  										\n");
//			tSQL.append("		dbo.GETSGNAME(A.PARENT1) AS S_TYPE1,                         		\n");
//			tSQL.append("		dbo.GETSGNAME(A.PARENT2) AS S_TYPE2,                         		\n");
//			tSQL.append("		dbo.GETSGNAME(A.SG) AS S_TYPE3,                              		\n");
//
//			tSQL.append("		C.TEMPLATE_NAME AS C_TEMPLATE,  								\n");
//			tSQL.append("		C.REQUIRE_SCORE AS SCORE,  										\n");
//			tSQL.append("		dbo.GETICOMCODE2('"+house_code+"','M121',A.CHECKLIST_STATUS) AS C_RESULT,\n");
//			tSQL.append("		A.SG AS SG_REFITEM                              				\n");
//			tSQL.append("FROM                                                            		\n");
//			tSQL.append("(                                                               		\n");
//			tSQL.append("	SELECT                                                       		\n");
//			tSQL.append("		   (SELECT PARENT_SG_REFITEM                             		\n");
//			tSQL.append("			   FROM ICOMSGCN                                  			\n");
//			tSQL.append("			  WHERE SG_REFITEM = B.PARENT_SG_REFITEM) AS PARENT1,		\n");
//			tSQL.append("			B.PARENT_SG_REFITEM AS PARENT2,                      		\n");
//			tSQL.append("			A.SG_REFITEM AS SG,                                  		\n");
//			tSQL.append("			A.VENDOR_CODE AS VENDOR_CODE,                          		\n");
//			tSQL.append("			A.CHECKLIST_STATUS AS CHECKLIST_STATUS,              		\n");
//			tSQL.append("			A.C_TEMPLATE_REFITEM AS C_TEMPLATE_REFITEM					\n");
//			tSQL.append("	FROM 	ICOMSGVN A, ICOMSGCN B          							\n");
//			tSQL.append("	WHERE   A.SG_REFITEM = B.SG_REFITEM                          		\n");
//			tSQL.append("	AND		A.HOUSE_CODE = '"+house_code+"'								\n");
//			tSQL.append("	AND		A.HOUSE_CODE = B.HOUSE_CODE 								\n");
//			tSQL.append("	AND		B.LEVEL_COUNT = '3'                                  		\n");
//			tSQL.append("	AND		A.C_TEMPLATE_REFITEM <> 0                  					\n");//MIGRATION OR BUYER INSERT DATA
//			tSQL.append("	AND		A.CHECKLIST_STATUS IS NOT NULL             					\n");//Direct Register DATA
//			tSQL.append("	--ORDER BY VENDOR_CODE                    							\n");
//			tSQL.append(") A, ICOMVNGL B, ICOMVCTH C                             				\n");
//			tSQL.append("WHERE	A.VENDOR_CODE = B.VENDOR_CODE									\n");
//			tSQL.append("AND	B.HOUSE_CODE = '"+house_code+"'									\n");
//			tSQL.append("AND	C.C_TEMPLATE_REFITEM = A.C_TEMPLATE_REFITEM						\n");
//	        tSQL.append(" <OPT=S,S>   AND  A.VENDOR_CODE  = ? </OPT>                           	\n");
//	        tSQL.append(" <OPT=S,S>   AND  B.VENDOR_NAME_LOC LIKE '%'+?+'%' </OPT>                  	\n");
///			tSQL.append("\n");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());
	        String[] data = {vendor_code, vendor_code_name};

			rtn = sm.doSelect(data);
			return rtn;
		}


		public SepoaOut getRecomenList(String user_name){

			String rtn = null;
			try{

				String user_id = info.getSession("ID");

				rtn = SR_getRecomenList(user_name);
				setValue(rtn);
				setStatus(1);

			} catch(Exception e) {
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("ExpandTree faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();
		}

		public String getCompanyCode() throws Exception{
			Configuration conf = new Configuration();
			return conf.get("Sepoa.company.code");
		}

		private String SR_getRecomenList(String user_name) throws Exception{

	   		String rtn = null;
	   		ConnectionContext ctx = getConnectionContext();

			String house_code = info.getSession("HOUSE_CODE");
	   		String addstr = "";
	   		Map<String, String> param = new HashMap<String, String>();

//	 		tSQL.append("SELECT USER_ID, USER_NAME_LOC FROM ICOMLUSR B 		\n");
//			tSQL.append("WHERE B.HOUSE_CODE = '" + house_code + "' 			\n");
//			tSQL.append("AND   B.USER_TYPE = '"+getCompanyCode()+"' 						\n");
//			tSQL.append("AND   B.STATUS IN ('C','R') 						\n");
//
//	 		if(user_name != null && !user_name.equals("")) {
//	 			tSQL.append("AND USER_NAME_LOC LIKE '%" + user_name + "%' 			\n");
//	 		}
//
//	 		tSQL.append("ORDER BY USER_NAME_LOC ASC 											\n");

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			//wxp.addVar("house_code", house_code);
			//wxp.addVar("USER_TYPE", getCompanyCode());
			
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession( "ID" ),this,ctx,wxp.getQuery());

			//String[] data = {user_name};
			param.put("user_name", user_name);
			rtn = sm.doSelect(param);
			return rtn;
		}


		public SepoaOut setCheckList(String vendor_code, String sg_refitem, String pass, Map<String, String> param){

	    	String rtn[] = null;
	    	try{

	    		rtn = SR_setCheckList(vendor_code, sg_refitem, pass, param);
	    		setMessage( rtn[ 0 ] );
	    		setValue( "update Row=" + rtn );
	    		setStatus( 1 );

	    		if ( rtn[ 1 ] != null ){
	    		    setMessage( rtn[ 1 ] );
	    		    setStatus( 0 );
	    		}

	    	} catch ( Exception e ) {
	    	    Logger.err.println( info.getSession( "ID" ), this, "Exception e =" + e.getMessage() );
	    	    setStatus( 0 );
	    	}
	    	return getSepoaOut();
	  	}


	  	private String[] SR_setCheckList(String vendor_code, String sg_refitem, String pass, Map<String, String> param) throws Exception{

	    	String returnString[] = new String[ 2 ];
	    	ConnectionContext ctx = getConnectionContext();
	    	StringBuffer sql = new StringBuffer();

	    	String user_id = info.getSession("ID");
	    	//String house_code = info.getSession("HOUSE_CODE");

	    	int rtnIns = 0;
	    	SepoaFormater wf = null;
	    	SepoaSQLManager sm = null;

			try{

//				sql.append( " UPDATE ICOMSGVN SET											\n ");
//				sql.append( "        PROGRESS_STATUS = 5, CHECKLIST_STATUS = ?, 		  	\n ");
//				sql.append( "   ADD_DATE = convert(varchar, getdate(),112), 			\n ");
//		  	    sql.append( "   ADD_USER_ID = '" + user_id + "'							\n ");
//				sql.append( " WHERE VENDOR_CODE = ? AND SG_REFITEM = ?  			 	  	\n ");
//				sql.append( " 	AND HOUSE_CODE = '"+house_code+"'							\n ");
//
//				String value[][] = new String[1][3];
//				value[0][0] = pass;
//				value[0][1] = vendor_code;
//				value[0][2] = sg_refitem;
				
				
				param.put("user_id",user_id);
				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+ "_1");
//				wxp.addVar("house_code", house_code);
//				wxp.addVar("user_id", user_id);

				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );

//			   	String[] type = { "S", "S", "S"};
		    	rtnIns = sm.doUpdate(param);

//		    	sql.delete(0, sql.length());

//		    	sql.append("INSERT INTO ICOMVCSI(HOUSE_CODE, C_SELECTED_ITEM_REFITEM, C_FACTOR_REFITEM, SELECTED_SEQ, VENDOR_SG_REFITEM) \n");
//				sql.append("VALUES('"+house_code+"',dbo.getMaxICOMVCSIseq(), ?, ?, ?) \n");

		    					
		    	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+ "_2");
//				wxp.addVar("house_code", house_code);

//				String[] type1 = { "S", "S", "S"};
				sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
		    	rtnIns = sm.doInsert(param);

		  	    Commit();

	  	    } catch( Exception e ) {
	    	    Rollback();
	    	    returnString[ 1 ] = e.getMessage();
	    	} finally { }

	  	   return returnString;
	  	}


	  	private int setSIGN_STATUS(ConnectionContext ctx, String JOB_STATUS, String[][] setData) throws Exception
		{
			int rtn = -1;

			try
			{


				String user_id    = info.getSession("ID");
				String house_code = info.getSession("HOUSE_CODE");
	            String cur_date   = SepoaDate.getShortDateString();
	            String cur_time   = SepoaDate.getShortTimeString();
	            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	            	wxp.addVar("JOB_STATUS", JOB_STATUS);
	            	wxp.addVar("cur_date", cur_date);
	            	wxp.addVar("user_id", user_id);
	            	wxp.addVar("house_code", house_code);


				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				String[] type = { "S" };

				rtn = sm.doInsert(setData, type);

			}
			catch(Exception e)
			{
				String serrMessage  = e.getMessage();
				String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
				if(sdbErrorCode.equals("ORA-00001") == true)
				{
					rtn = -1;
				}
				else
				{
					throw new Exception("setSIGN_STATUS:"+e.getMessage());
				}
			} finally {	}
			return rtn;
		}
	  	
	  	private int setSIGN_STATUS(ConnectionContext ctx, String JOB_STATUS, Map<String, String> setData) throws Exception
		{
			int rtn = -1;

			try
			{

				String addSql	  = "";
				String user_id    = info.getSession("ID");
				String house_code = info.getSession("HOUSE_CODE");
	            String cur_date   = SepoaDate.getShortDateString();
	            String cur_time   = SepoaDate.getShortTimeString();
	            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	/*wxp.addVar("JOB_STATUS", JOB_STATUS);
            	wxp.addVar("cur_date", cur_date);
            	wxp.addVar("user_id", user_id);
            	wxp.addVar("house_code", house_code);*/
            	
            	if("E".equals(JOB_STATUS)){
            		addSql = "SIGN_STATUS = 'E', JOB_STATUS = 'E', CLASS_GRADE = 'D', SIGN_DATE = '"+cur_date+"', SIGN_PERSON_ID = '"+user_id+"' , ";
            	}
            	else if("R".equals(JOB_STATUS)){
            		addSql = "JOB_STATUS = 'R', SIGN_STATUS = 'R',";
            	}
            	else if("D".equals(JOB_STATUS)){
            		addSql = "JOB_STATUS = 'P', SIGN_STATUS = '',";
            	}
            		
            	
	            Map<String, String> data =  new HashMap<String, String>();
	            wxp.addVar("addSql", addSql);
	            
	            data.put("JOB_STATUS", JOB_STATUS);
	            data.put("cur_date", cur_date);
	            data.put("user_id", user_id);
	            data.put("house_code", house_code);
	            data.put("vendor_code", setData.get("vendor_code"));
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				rtn = sm.doInsert(data);
				
				if("R".equals(JOB_STATUS)){
					Map<String, String> smsParam = new HashMap<String, String>();
					
		  	    	smsParam.put("HOUSE_CODE",  house_code);
		  	    	smsParam.put("VENDOR_CODE", setData.get("vendor_code"));
					
					new SMS("NONDBJOB", info).rg1Process(ctx, smsParam);
					new mail("NONDBJOB", info).rg1Process(ctx, smsParam);
				}
			}
			catch(Exception e)
			{
				String serrMessage  = e.getMessage();
				String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
				if(sdbErrorCode.equals("ORA-00001") == true)
				{
					rtn = -1;
				}
				else
				{
					throw new Exception("setSIGN_STATUS:"+e.getMessage());
				}
			} finally {	}
			return rtn;
		}

	  	private int createUser(ConnectionContext ctx, String[][] setData, String passwd) throws Exception
		{
			int rtn = -1;

			try
			{
				String user_id    = info.getSession("ID");
				String house_code = info.getSession("HOUSE_CODE");
	            String cur_date   = SepoaDate.getShortDateString();
	            String cur_time   = SepoaDate.getShortTimeString();
	            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	            wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
            	wxp.addVar("user_id", user_id);
            	wxp.addVar("passwd", passwd);
            	wxp.addVar("login_yn", 'Y');

				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				String[] type = { "S" };

				rtn = sm.doInsert(setData, type);
				if(rtn == 0 || rtn == -1)
	 				throw new Exception("입력된 데이타가 없습니다.");
			}
			catch(Exception e)
			{
				String serrMessage  = e.getMessage();
				String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
				if(sdbErrorCode.equals("ORA-00001") == true)
				{
					rtn = -1;
				}
				else
				{
					throw new Exception("createUser:"+e.getMessage());
				}
			} finally {	}
			return rtn;
		}
	  	
	  	
	  	
	  	private int createUser(ConnectionContext ctx, Map<String, String> setData, String passwd) throws Exception
	  	{
	  		int rtn = -1;
	  		
	  		try
	  		{
	  			String user_id    = info.getSession("ID");
	  			String house_code = info.getSession("HOUSE_CODE");
	  			String cur_date   = SepoaDate.getShortDateString();
	  			String cur_time   = SepoaDate.getShortTimeString();
	  			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	  			
	  			setData.put("house_code", info.getSession("HOUSE_CODE"));
	  			setData.put("user_id", user_id);                         
	  			setData.put("passwd", passwd);                           
	  			setData.put("login_yn", "Y");                            
	  			
	  			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	  			
	  			rtn = sm.doInsert(setData);
	  			if(rtn == 0 || rtn == -1)
	  				throw new Exception("입력된 데이타가 없습니다.");
	  		}
	  		catch(Exception e)
	  		{
	  			String serrMessage  = e.getMessage();
	  			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
	  			if(sdbErrorCode.equals("ORA-00001") == true)
	  			{
	  				rtn = -1;
	  			}
	  			else
	  			{
	  				throw new Exception("createUser:"+e.getMessage());
	  			}
	  		} finally {	}
	  		return rtn;
	  	}

	  	private int createMaker(ConnectionContext ctx, String[][] setData) throws Exception
		{
			int rtn = -1;

			try
			{

				String user_id    = info.getSession("ID");
				String house_code = info.getSession("HOUSE_CODE");
	            String cur_date   = SepoaDate.getShortDateString();
	            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	            	wxp.addVar("house_code", house_code);
	            	wxp.addVar("user_id", user_id);


				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

				String[] type = { "S" };

				rtn = sm.doInsert(setData, type);
				if(rtn == 0 || rtn == -1)
	 				throw new Exception("입력된 데이타가 없습니다.");
			}
			catch(Exception e)
			{
				String serrMessage  = e.getMessage();
				String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
				if(sdbErrorCode.equals("ORA-00001") == true)
				{
					rtn = -1;
				}
				else
				{
					throw new Exception("createUser:"+e.getMessage());
				}
			} finally {	}
			return rtn;
		}
	  
	  	private int createMaker(ConnectionContext ctx, Map<String, String> setData) throws Exception
	  	{
	  		int rtn = -1;
	  		
	  		try
	  		{
	  			
	  			String user_id    = info.getSession("ID");
	  			String house_code = info.getSession("HOUSE_CODE");
	  			String cur_date   = SepoaDate.getShortDateString();
	  			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	  			wxp.addVar("house_code", house_code);
	  			wxp.addVar("user_id", user_id);
	  			
	  			
	  			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	  			
	  			String[] type = { "S" };
	  			
	  			rtn = sm.doInsert(setData);
	  			if(rtn == 0 || rtn == -1)
	  				throw new Exception("입력된 데이타가 없습니다.");
	  		}
	  		catch(Exception e)
	  		{
	  			String serrMessage  = e.getMessage();
	  			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
	  			if(sdbErrorCode.equals("ORA-00001") == true)
	  			{
	  				rtn = -1;
	  			}
	  			else
	  			{
	  				throw new Exception("createUser:"+e.getMessage());
	  			}
	  		} finally {	}
	  		return rtn;
	  	}

	  	private int insertFreeCP(ConnectionContext ctx, String[][] setData) throws Exception
		{
			int rtn = -1;

			try
			{

				String user_id    = info.getSession("ID");
				String house_code = info.getSession("HOUSE_CODE");
				String company_code = info.getSession("COMPANY_CODE");

				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	wxp.addVar("house_code", house_code);
            	wxp.addVar("company_code", company_code);


            	SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());




				String[] type = { "S" };

				rtn = sm.doInsert(setData, type);
			}
			catch(Exception e)
			{
				String serrMessage  = e.getMessage();
				String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
				if(sdbErrorCode.equals("ORA-00001") == true)
				{
					rtn = -1;
				}
				else
				{
					throw new Exception("insertFreeCP:"+e.getMessage());
				}
			} finally {	}
			return rtn;
		}

	  	public SepoaOut getJobStatus(String vendor_code){

			String rtn = null;
			try{

				String user_id = info.getSession("ID");

				rtn = getVendorJobStatus(vendor_code);
				setValue(rtn);
				setStatus(1);

			} catch(Exception e) {
				Logger.err.println("Exception e =" + e.getMessage());
				setStatus(0);
				setMessage("ExpandTree faild");
				Logger.err.println(this,e.getMessage());
			}
			return getSepoaOut();
		}

	  	private String getVendorJobStatus(String VENDOR_CODE) throws Exception{

	      	String rtn = "";
	      	ConnectionContext ctx = getConnectionContext();
	      	String HOUSE_CODE 	= info.getSession("HOUSE_CODE");
	      	String USER_ID 		= info.getSession("ID");

	      	try {

	      		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				//wxp.addVar("HOUSE_CODE", HOUSE_CODE);
				//wxp.addVar("VENDOR_CODE", VENDOR_CODE);
	      		String[] data = {HOUSE_CODE, VENDOR_CODE};
	        	SepoaSQLManager sm = new SepoaSQLManager(USER_ID,this,ctx,wxp.getQuery());//tSQL.toString());
	        	rtn = sm.doSelect(data);

	        	if(rtn == null) throw new Exception("SQL Manager is Null");

	        } catch(Exception e) {
	                throw new Exception("getVendorJobStatus:"+e.getMessage());
	        } finally {
	            //Release();
	      	}
	      	return rtn;
	  	}
	  	
	  	/**
		 * 협력사 정보 수정
		 * @method setVendorReg
		 * @param  header
		 * @return Map
		 * @throws Exception
		 * @desc   ICOYRQDT
		 * @since  2014-10-24
		 * @modify 2014-10-24
		 */  	
  	public SepoaOut setVendorReg(Map<String, Object> data) throws Exception{ 
    	ConnectionContext         ctx          = null;
        SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
		String                    id           = info.getSession("ID");
		List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
		Map<String, String>       gridInfo     = null;
		int                       gridSize     = grid.size();
		int                       rtn          = 0;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		try{
	            
	       rtn = this.et_setVendorReg(ctx, grid);
	       setStatus( 1 );
			if ( rtn > 0 ){
				setMessage("비정상적으로 처리되었습니다.");
				setStatus( 0 );
			}
			setMessage("성공적으로 변경하였습니다.");
			Commit();
		}
		catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
    } 
	
	private int et_setVendorReg(ConnectionContext	ctx, List<Map<String, String>> grid) throws Exception { 
		int rtn = 0;
		
		try{
			SepoaXmlParser  wxp = new SepoaXmlParser(this, "et_setVendorReg");
			SepoaSQLManager sm  = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp); 

			rtn = sm.doUpdate(grid); 
		}
		catch(Exception e)	{ 
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
			
			throw new Exception(e.getMessage()); 
		} 

		return rtn;

    }
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체코드 자동채번
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private SepoaFormater makeNewVendorCode(ConnectionContext ctx) throws Exception
	{
		
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");
		SepoaFormater wf = null;
		try{
			Map<String, String> data =  new HashMap<String, String>();
			//현재 문서아이템의 갯수 조회
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			data.put("house_code", house_code);
			
			SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
			wf = new SepoaFormater(sm.doSelect(data));	

		}catch (Exception e) {
			throw new Exception("getERPPOList : " + e.getMessage());
		} finally {
		}
		return wf;
		
	}	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체마스터 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNGL(ConnectionContext ctx, Map<String, String> setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			
			Map<String, String> data =  new HashMap<String, String>();
			
			data.put("house_code", info.getSession("HOUSE_CODE"));
			data.put("user_id", user_id);
			data.put("vendor_code", setData.get("vendor_code"));
			data.put("new_vendor_code", new_vendor_code);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			//String[] type = { "S" };
			
			rtn = sm.doUpdate(data);

			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNGL:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 사용자 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeLUSR(ConnectionContext ctx, Map<String, String> setData, String new_vendor_code) throws Exception
	{
		int rtn = -1;

		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
            String cur_date   = SepoaDate.getShortDateString();
            String cur_time   = SepoaDate.getShortTimeString();
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
        	Map<String, String> data =  new HashMap<String, String>();
            
            data.put("house_code", info.getSession("HOUSE_CODE"));
            data.put("user_id", user_id);
            data.put("vendor_code", setData.get("vendor_code"));
            data.put("new_vendor_code", new_vendor_code);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			//String[] type = { "S" };

			rtn = sm.doUpdate(data);
			if(rtn == 0 || rtn == -1)
 				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeLUSR:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 주소 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeADDR(ConnectionContext ctx, Map<String, String> setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaFormater sf =null;
			Map<String, String> data =  new HashMap<String, String>();
			
			data.put("house_code", info.getSession("HOUSE_CODE"));
			data.put("user_id", user_id);
			data.put("vendor_code", setData.get("vendor_code"));
			data.put("new_vendor_code", new_vendor_code);
			
			SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
			SepoaSQLManager sm2 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp2.getQuery());
			sf = new SepoaFormater(sm2.doSelect(data));
			String cnt=sf.getValue("cnt", 0);
			
			if(cnt.equals("0")){
				SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
				SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp1.getQuery());
				rtn = sm1.doInsert(data);
			}
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			//String[] type = { "S" };
			
			rtn = sm.doUpdate(data);
			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
//			e.printStackTrace();
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeADDR:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNCP(ConnectionContext ctx, Map<String, String> setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData.get("vendor_code"));
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNCP:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeSGVN(ConnectionContext ctx, Map<String, String> setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData.get("vendor_code"));
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
			if(rtn == 0 || rtn == -1)
				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeSGVN:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNPJ(ConnectionContext ctx, Map<String, String> setData, String new_vendor_code) throws Exception
	{
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData.get("vendor_code"));
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
//			if(rtn == 0 || rtn == -1)
//				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNPJ:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
	
	
	/**
	 * 전자결재 > 업체승인 > 공급업체 코드 변경
	 * @param ctx
	 * @param setData
	 * @param passwd
	 * @return
	 * @throws Exception
	 */
	private int updateVendorCodeVNIT(ConnectionContext ctx, Map<String, String> setData, String new_vendor_code) throws Exception
	{
		
		int rtn = -1;
		
		try
		{
			String user_id    = info.getSession("ID");
			String house_code = info.getSession("HOUSE_CODE");
			String cur_date   = SepoaDate.getShortDateString();
			String cur_time   = SepoaDate.getShortTimeString();
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
				Map<String, String> data =  new HashMap<String, String>();
				
				data.put("house_code", info.getSession("HOUSE_CODE"));
				data.put("user_id", user_id);
				data.put("vendor_code", setData.get("vendor_code"));
				data.put("new_vendor_code", new_vendor_code);
				SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				
				//String[] type = { "S" };
				
				rtn = sm.doUpdate(data);
//			if(rtn == 0 || rtn == -1)
//				throw new Exception("입력된 데이타가 없습니다.");
		}
		catch(Exception e)
		{
			String serrMessage  = e.getMessage();
			String sdbErrorCode = serrMessage.substring(serrMessage.indexOf("ORA"),serrMessage.indexOf("ORA")+9);
			if(sdbErrorCode.equals("ORA-00001") == true)
			{
				rtn = -1;
			}
			else
			{
				throw new Exception("updateVendorCodeVNIT:"+e.getMessage());
			}
		} finally {	}
		return rtn;
	}
}