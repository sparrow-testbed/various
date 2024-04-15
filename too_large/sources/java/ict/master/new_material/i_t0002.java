/**
===========================================================================================================
FUNCTION NAME   DESCRIPTION
===========================================================================================================
-----------------------------------------------------------------------------------------------------------
[ newmtrl_bd_lis3_getQuery ]......................................  신규품번 신청접수 조회
[ newmtrl_bd_lis2_getQuery ]......................................  신규품번 등록현황 조회
[ newmtrl_bd_ins2_top_getQuery ]...............................  	신규품번등록 조회
[ newmtrl_bd_ins2_body_getQuery ].............................  	신규품번등록 제원내역 조회
[ newmtrl_bd_ins2_setInsert ].....................................  신규품번 신청접수 등록
[ newmtrl_bd_ins2_setRestore ]...................................   신규품번 신청접수 반려
[ newmtrl_bd_ins3_getQuery ].....................................   신규품번 조회
[ newmtrl_bd_ins3_setInsert ].....................................  신규품번 등록
-----------------------------------------------------------------------------------------------------------
**/

package ict.master.new_material;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import wisecommon.SignResponseInfo;

public class I_t0002 extends SepoaService {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////           Session 정보를 담기위한 변수             //////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private String lang = "";
    //private Message msg = null;
    private HashMap<String,String> msg = null;
    
    public I_t0002(String opt, SepoaInfo info) throws Exception {
        super(opt, info);
        setVersion("1.0.0");

        lang = info.getSession("LANGUAGE");
        //msg = new Message(lang,"p11_ctr");
        Vector multilang_id = new Vector();
    	multilang_id.addElement("p11_ctr");
        msg = MessageUtil.getMessage(info,multilang_id);
       
    }
    
    /**
     * 품목조회
     * @method getItemList
     * @since  2014-10-20
     * @modify 2014-10-20
     * @param 
     * @return Map
     * @throws Exception
     */
    public SepoaOut getItemList(Map<String, String> header) {  
    	try	{  
			String rtn = "";  
  
			//Query 수행부분 Call  
            //create_type 에 상관없이 조회 
			rtn	= et_getItemList(header);  
				
			setValue(rtn);  
			setStatus(1);  
  
		}catch (Exception e){  
			Logger.err.println(info.getSession("ID"),this,"Exception e ==============>"	+ e.getMessage());  
			setMessage(msg.get("0001"));  
			setStatus(0);  
		}  
		return getSepoaOut();  
    	
    }  
  
    /**
     * 품목 조회 쿼리
     * @method et_getItemList
     * @since  2014-10-20
     * @modify 2014-10-20
     * @param header
     * @return Map
     * @throws Exception
     * @desc   catalog_list_getQuery => et_getItemList 변경
     */
    private String et_getItemList(Map<String, String> header) throws Exception  
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
			
		  throw	new	Exception("et_getItemList=========>"+e.getMessage());  
		} finally{  
		}  
		return rtn; 
    	
    	
    }
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////   품목 등록요청     //////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//    public SepoaOut req_setInsert( String[][] setData) 
//    {
//        try
//        {
//            //String REQ_ITEM_NO =et_req_docnumber();
//        	
////        	SepoaOut wo = appcommon.getDocNumber(info,"IT");  // 품목요청번호생성
//        	SepoaOut wo = DocumentUtil.getDocNumber(info,"IT");
//        	
//        	String REQ_ITEM_NO = wo.result[0];
//
//            int rtn_cnt  = et_req_setInsert(setData, REQ_ITEM_NO);
//
//            if(rtn_cnt < 1) 
//                Rollback();
//            else Commit();
//            
//            setStatus(1);
//            setMessage("저장하였습니다.");  /* Message를 등록한다. */
//            
//        } catch(Exception e) {
//			try	{ 
//				Rollback(); 
//	            setStatus(0); 
//	            setMessage(msg.get("p11_ctr.0001"));
//	            Logger.err.println(this,e.getMessage()); 
//			} catch(Exception d) {  
//				
//			} 
//        }
//        //Commit();
//        return getSepoaOut();
//    }
    
    public SepoaOut req_setInsert(Map<String, String> param) throws Exception{
    	ConnectionContext ctx       = null;
        SepoaXmlParser    sxp       = null;
		SepoaSQLManager   ssm       = null;
		SepoaOut          wo        = DocumentUtil.getDocNumber(info,"IT");
		String            id        = info.getSession("ID");
		String            reqItemNo = wo.result[0];
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			sxp = new SepoaXmlParser(this, "et_req_setInsert");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			param.put("REQ_ITEM_NO", reqItemNo);
                
			ssm.doInsert(param);
			
			setMessage("저장하였습니다.");
			
			Commit();
		}
		catch(Exception e){
			
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(msg.get("p11_ctr.0001"));
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		finally {}

		return getSepoaOut();
    }
    
    
    private String et_req_docnumber() throws Exception{ 
    	
    	String rtn            = "";
        String house_code     = info.getSession("HOUSE_CODE");
        String company_code   = info.getSession("COMPANY_CODE");		 
        String user_id        = info.getSession("ID");
        ConnectionContext ctx = getConnectionContext();

        try 
        {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("house_code", house_code);            
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());

            rtn = sm.doSelect((String[])null);
            
            SepoaFormater wf = new SepoaFormater(rtn);
            
            rtn = wf.getValue(0,0);

            if(rtn == null) throw new Exception("SQLManager is null");
        }catch(Exception ex) {
            throw new Exception("et_req_docnumber"+ ex.getMessage());
        }

        return rtn;
    }    

    
    private int et_req_setInsert(String[][] setData, String REQ_ITEM_NO) throws Exception
    {
        String user_id      = info.getSession("ID");
        
        int rtn = -1;

        ConnectionContext ctx = getConnectionContext();
        
        String[] type   = {"S","S","S","S","S"
        		          ,"S","S","S","S","S"
        		          ,"S","S","S","S","S"
        		          ,"S","S","S","S","S"
        				  ,"S","S","S","S"   };
        				  
        try {

        	
            SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp1.addVar("REQ_ITEM_NO", REQ_ITEM_NO);
            
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp1.getQuery());
        	
        	rtn = sm.doInsert(setData, type);

        }catch(Exception e) {
            Rollback();
            throw new Exception("et_setBlock_item:"+e.getMessage());
        } finally{

        }
        return rtn;
    }   
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////   품목 등록요청 현황 - 조회   //////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    public SepoaOut newmtrl_bd_lis2_getQuery(String [] queryData) {
//        try {
//            String rtn = new String();
//            //Query 수행부분 Call
//            rtn = et_newmtrl_bd_lis2_getQuery(queryData);
//            msg.put("JOB","조회");
//            setMessage(msg.get("p11_ctr.0000"));
//            setValue(rtn);
//            setStatus(1);
//        }catch (Exception e){
//            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
//            msg.put("JOB","조회");
//            setMessage(msg.get("p11_ctr.0001"));
//            setStatus(0);
//        }
//        return getSepoaOut();
//    }    
    
    public SepoaOut newmtrl_bd_lis2_getQuery(Map<String, String> param) {
    	ConnectionContext ctx = null;
		String            rtn = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			rtn = this.select(ctx, "et_newmtrl_bd_lis2_getQuery", param);
			
			setValue(rtn);
			setMessage(msg.get("0000"));
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setMessage(msg.get("0001"));
		}
		
		return getSepoaOut();
    }


    private String et_newmtrl_bd_lis2_getQuery(String [] queryData) throws Exception
    {
        String rtn = "";
        String house_code   = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        
        ConnectionContext ctx = getConnectionContext();

        try 
        {
            	//StringBuffer sql = new StringBuffer();            
                SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
             	wxp.addVar("HOUSE_CODE", house_code);
             	
//                sql.append(" SELECT                                                                                                                                         \n ");
//                sql.append("              RHD.REQ_DATE,                                                            ;                                                         \n ");
//                sql.append("              RHD.ITEM_NO,                                                                                                                      \n ");
//                sql.append("              RHD.SPECIFICATION,                                                                                                                \n ");
//                sql.append("              RHD.BASIC_UNIT,                                                                                                                   \n ");
//                sql.append("              RHD.DESCRIPTION_LOC,                                                                                                              \n ");
//                sql.append("              dbo.GETICOMCODE2('"+house_code+"','M183', RHD.REQ_TYPE) REQ_TYPE,                           		\n ");
//                sql.append("              (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = RHD.REQ_USER_ID) REQ_NAME_LOC,                                                \n ");
//                sql.append("              dbo.GETICOMCODE2('"+house_code+"','M184',RHD.DATA_TYPE) DATA_TYPE,                                          \n ");
//                sql.append("              RHD.CONFIRM_DATE, RHD.DATA_TYPE AS H_DATA_TYPE,                                                                                                                \n ");
//                sql.append("              (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = RHD.CONFIRM_USER_ID) CONFIRM_NAME_LOC,                                        \n ");
//                sql.append("              dbo.GETICOMCODE2('"+house_code+"','M185',RHD.CONFIRM_STATUS) CONFIRM_STATUS,                            \n ");
//                sql.append("			  RHD.CONFIRM_STATUS AS CONFIRM_STATUS_FLAG,      \n ");
//                sql.append("              RHD.REQ_ITEM_NO, REMARK,                                                                                                                   \n ");
//                sql.append("              dbo.GETCOMPANYNAME(VDR.HOUSE_CODE, VDR.VENDOR_CODE, 'S', 'KR') VENDOR_NAME ,                           \n ");
//                sql.append("              RHD.REJECT_REMARK ,                                                                                                                  \n ");
//                sql.append("			  RHD.MAKER_NAME                   \n ");
//                sql.append(" FROM      ICOMREHD RHD  LEFT OUTER JOIN                                                                 \n ");
//                sql.append("                          (SELECT USR.USER_ID,                                                           \n" );
//                sql.append("                                  USR.HOUSE_CODE,                                                        \n" );
//                sql.append("                                  NGL.VENDOR_CODE,                                                       \n" );
//                sql.append("                                  dbo.GETCOMPANYNAME(NGL.HOUSE_CODE, NGL.VENDOR_CODE, 'S', 'KR') AS NAME_LOC                                                           \n" );
//                sql.append("                             FROM ICOMLUSR USR , ICOMVNGL NGL                                   \n" );
//                sql.append("                             WHERE USR.HOUSE_CODE = '"+house_code+"'                                     \n" );
//                sql.append("                               AND USR.HOUSE_CODE = NGL.HOUSE_CODE                                        \n" );
//                sql.append("                               AND USR.COMPANY_CODE = NGL.VENDOR_CODE                                    \n" );
//                sql.append("                           ) VDR                                                                         \n" );
//                sql.append("   ON  RHD.HOUSE_CODE = VDR.HOUSE_CODE                                                                  \n" );
//                sql.append("   AND RHD.REQ_USER_ID = VDR.USER_ID                                                                    \n" );
//                sql.append(" WHERE  RHD.HOUSE_CODE        =  '"+house_code+"'                                                       \n ");               
//                sql.append("   AND     RHD.STATUS <> 'D'                                                                                                                    \n ");
//
//                sql.append("  <OPT=S,S> AND      RHD.REQ_DATE      >=      ?    </OPT>                                                                                                  \n ");
//                sql.append("  <OPT=S,S> AND      RHD.REQ_DATE      <=      ?    </OPT>                                                                                                  \n ");
//                sql.append("  <OPT=S,S> AND      (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE HOUSE_CODE = '"+house_code+"' AND USER_ID = RHD.REQ_USER_ID) LIKE '%' + ? + '%'         </OPT>                                                                                                     \n ");
//                sql.append("  <OPT=S,S> AND      RHD.DESCRIPTION_LOC LIKE '%'+?+'%' </OPT>                                                                                                       \n ");
//                //sql.append("  <OPT=S,S> AND      RHD.REQ_TYPE  =      ?          </OPT>                                                                                                     \n ");
//                sql.append("  <OPT=S,S> AND      RHD.CONFIRM_STATUS = ?          </OPT>                                                                                                     \n ");
//                //sql.append("  <OPT=S,S> AND      RHD.DATA_TYPE      =      ?     </OPT>                                                                                                    \n ");
//                //sql.append("  <OPT=S,S> AND      RHD.INTEGRATED_BUY_FLAG   =      ?     </OPT>                                                                                                    \n ");
//                //sql.append("  <OPT=S,N> AND      RHD.ITEM_GROUP          =  ?     </OPT>                                                                                                    \n ");
//                sql.append(" ORDER BY  RHD.REQ_ITEM_NO DESC                                                                                              \n ");


            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
            Logger.err.println(info.getSession("ID"),this, wxp.getQuery());

            rtn = sm.doSelect(queryData);

            if(rtn == null) throw new Exception("SQL Manager is Null");
            
        }catch(Exception e) {
            throw new Exception("et_newmtrl_bd_lis2_getQuery ==========================================>"+e.getMessage());
        } finally{
        }
        return rtn;
    }

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////   품목 등록요청 현황 - 삭제   //////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//    public SepoaOut req_setDelete(String[][] args){ 
//        
//        try{ 
//            int rtn = et_req_setDelete(args); 
//           // if(rtn < 1)
//			//	throw new Exception("UPDATE ICOMCMGL ERROR");
//			
//			Commit();
//			setStatus(1);
//			setMessage("삭제하였습니다.");
//
//		}catch(Exception e){
//			try 
//            { 
//                Rollback(); 
//            } 
//            catch(Exception d) 
//            { 
//                Logger.err.println(info.getSession("ID"),this,d.getMessage()); 
//            } 
//            setStatus(0); 
//            setMessage(msg.get("p11_ctr.0002"));
//		}
//        
//        return getSepoaOut(); 
//    }
    
    @SuppressWarnings("unchecked")
	public SepoaOut req_setDelete(Map<String, Object> param) throws Exception{ 
    	ConnectionContext         ctx          = null;
        SepoaXmlParser            sxp          = null;
		SepoaSQLManager           ssm          = null;
		String                    id           = info.getSession("ID");
		List<Map<String, String>> svcParam     = (List<Map<String, String>>)param.get("svcParam");
		Map<String, String>       svcParamInfo = null;
		int                       svcParamSize = svcParam.size();
		int                       i            = 0;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			for(i = 0; i < svcParamSize; i++){
				sxp = new SepoaXmlParser(this, "et_req_setDelete");
	            ssm = new SepoaSQLManager(id, this, ctx, sxp);
	            
	            svcParamInfo = svcParam.get(i);
	            
	            ssm.doUpdate(svcParamInfo);
			}
			
			setMessage("삭제하였습니다.");
			
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
    
    private int et_req_setDelete(String[][] args) throws Exception{ 
        int rtn = -1; 
        try { 
            String[] setType = {"S", "S", "S", "S", "S",  "S"}; 
            
            //StringBuffer tSQL = new StringBuffer(); 
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
         	ConnectionContext ctx = getConnectionContext(); 
			
//            tSQL.append( " UPDATE ICOMREHD SET \n"); 
//			tSQL.append( " 	STATUS = ?, \n"); 
//            tSQL.append( "  CHANGE_USER_ID = ?, \n"); 
//            tSQL.append( "  CHANGE_DATE = ?, \n"); 
//            tSQL.append( "  CHANGE_TIME = ? \n"); 
//            tSQL.append( " WHERE HOUSE_CODE = ? \n"); 
////            tSQL.append( " 	AND COMPANY_CODE = ? \n");
//            tSQL.append( "  AND REQ_ITEM_NO = ? \n");
//            tSQL.append( "  AND STATUS <> 'D' \n");
            
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery()); 
            rtn = sm.doInsert(args, setType);  
            
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
    
    public SepoaOut getPjtCodeList(String pjt_code ) 
    {
        try 
        {
            String rtn = null;
            rtn = et_getPjtCodeList( pjt_code);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.get("0000"));
        }catch(Exception e){
            
            setStatus(0);
            setMessage(msg.get("0001"));
            Logger.err.println(info.getSession("ID"),this, e.getMessage());
        }
        return getSepoaOut();
    }
    
    public String et_getPjtCodeList( String pjt_code) throws Exception 
    {
        String result = null;
        String house_code   = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        String pr_location  = info.getSession("LOCATION_CODE");
        String user_id      = info.getSession("ID");
        ConnectionContext ctx = getConnectionContext();
		
        try 
        {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("HOUSE_CODE",   house_code);
            wxp.addVar("pjt_code",  pjt_code);

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            result = sm.doSelect((String[])null);
            if(result == null) throw new Exception("SQLManager is null");
        }catch(Exception ex) {
            throw new Exception("et_req_ins1_getQuery"+ ex.getMessage());
        }
        return result;
    }   
    
    public SepoaOut req_ins_getVnglList(String vendor_code ) 
    {
        try 
        {
            String rtn = null;
            rtn = et_req_ins_getVnglList( vendor_code);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.get("0000"));
        }catch(Exception e){
            
            setStatus(0);
            setMessage(msg.get("0001"));
            Logger.err.println(info.getSession("ID"),this, e.getMessage());
        }
        return getSepoaOut();
    }
    
    public String et_req_ins_getVnglList( String vendor_code) throws Exception 
    {
        String result = null;
        String house_code   = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        String pr_location  = info.getSession("LOCATION_CODE");
        String user_id      = info.getSession("ID");
        ConnectionContext ctx = getConnectionContext();
		
        try 
        {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("HOUSE_CODE",   house_code);
            wxp.addVar("vendor_code",  vendor_code);

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            result = sm.doSelect((String[])null);
            if(result == null) throw new Exception("SQLManager is null");
        }catch(Exception ex) {
            throw new Exception("et_req_ins1_getQuery"+ ex.getMessage());
        }
        return result;
    }    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////   품목 등록요청 현황 - 수정   //////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public SepoaOut req_ins_getReqList(String[] args) 
    {
        try 
        {
            String rtn = null;
            rtn = et_req_ins_getReqList( args);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.get("0000"));
        }catch(Exception e){
            
            setStatus(0);
            setMessage(msg.get("0001"));
            Logger.err.println(info.getSession("ID"),this, e.getMessage());
        }
        return getSepoaOut();
    }

    public String et_req_ins_getReqList( String[] args) throws Exception 
    {
        String result = null;
        String house_code = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        String pr_location    = info.getSession("LOCATION_CODE");
        String user_id    = info.getSession("ID");
        String item_no = args[0];
        ConnectionContext ctx = getConnectionContext();
		
        try 
        {
            //StringBuffer tSQL = new StringBuffer();	
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("HOUSE_CODE",   house_code);
            wxp.addVar("COMPANY_CODE", company_code);
            wxp.addVar("PR_LOCATION",  pr_location);
            
//            tSQL.append(" SELECT dbo.getIcomcode2('"+house_code+"','M122',MATERIAL_CLASS2) AS MATERIAL_CLASS2_NAME     \n");
//            tSQL.append("       ,ITEM_NO ,ITEM_GROUP     \n");
//            tSQL.append("       ,MATERIAL_TYPE ,MATERIAL_CTRL_TYPE, MATERIAL_CLASS1, MATERIAL_CLASS2     \n");
//            tSQL.append("       ,dbo.getIcomcode2('"+house_code+"','M042',MATERIAL_CLASS1) AS MATERIAL_CLASS1_NAME     \n");
//            tSQL.append("       ,dbo.getIcomcode2('"+house_code+"','M041',MATERIAL_CTRL_TYPE) AS MATERIAL_CTRL_TYPE_NAME     \n");
//            tSQL.append("      ,DESCRIPTION_LOC, BASIC_UNIT, REMARK, MAKER_NAME           \n");
//            tSQL.append("      ,'' AS PRODUCT_NAME                        \n");
//            tSQL.append("      ,ORIGIN_COUNTRY,MODEL_NO, '' AS RELEASE_FLAG , '' AS INTEGRATED_BUY_FLAG                     \n");
//            tSQL.append("      ,'' AS COMPANY_CODE_NAME           \n");
//            tSQL.append("      ,'' AS TAX_CODE                         \n");
//            tSQL.append("      ,dbo.getIcomcode2('"+house_code+"','M025',SHIPPER_TYPE) AS SHIPPER_TYPE_LOC                 \n");
//            tSQL.append("      ,IMAGE_FILE_PATH ,DRAWING_NO1           \n");
//            tSQL.append("   	,dbo.GETINFOPRICE2('"+house_code+"', '"+company_code+"', '"+pr_location+"', ITEM_NO) AS INFO_PRICE	\n");
//            tSQL.append("      ,dbo.getAttachFileName(IMAGE_FILE_PATH,'IMAGE','00000001') AS IMAGE_FILE_NAME  							\n");
//            tSQL.append("      ,OLD_ITEM_NO , Z_ITEM_DESC, ITEM_ABBREVIATION, SPECIFICATION, ITEM_NO                      \n");
//            tSQL.append("      ,'' AS ITEM_NAME                \n");
//            tSQL.append("      ,'' AS CATALOG_USER_ID                \n");
//            tSQL.append("      ,'' AS SOURCING_USER_ID              \n");
//            tSQL.append("      ,(SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = REQ_USER_ID) AS REQ_USER_ID                        \n");
//            tSQL.append("      ,REQ_DATE ,CONFIRM_DATE ,  MATERIAL_CLASS2 , DATA_TYPE AS DATA                 \n");
//            tSQL.append("      ,dbo.getIcomcode2('"+house_code+"','M183',REQ_TYPE) AS REQ_TYPE                         \n");
//            tSQL.append("      ,dbo.getIcomcode2('"+house_code+"','M185',CONFIRM_STATUS) AS CONFIRM_STATUS             \n");
//            tSQL.append("      ,dbo.getIcomcode2('"+house_code+"','M184',DATA_TYPE) AS DATA_TYPE                       \n");
//            tSQL.append("      ,(SELECT USER_NAME_LOC FROM ICOMLUSR WHERE USER_ID = CONFIRM_USER_ID) AS CONFIRM_USER_NAME              \n");
//            tSQL.append("      ,dbo.getIcomcode2('"+house_code+"','M037',ITEM_GROUP) AS Z_ITEM_GROUP              \n");
//            tSQL.append("      ,dbo.getIcomcode2('"+house_code+"','M602',Z_PURCHASE_TYPE) AS Z_PURCHASE_TYPE              \n");
//            tSQL.append("      ,Z_PURCHASE_TYPE AS Z_PURCHASE_TYPE_CODE              \n");
//            tSQL.append("      ,MAKER_NAME              \n");
//            tSQL.append("      ,PROXY_ITEM_NO              \n");
//            tSQL.append("      ,APP_TAX_CODE              \n");
//            tSQL.append("      ,DELIVERY_LT              \n");
//            tSQL.append("      ,dbo.getIcomcode2('"+house_code+"','M604',MARKET_TYPE) AS MARKET_TYPE              \n");
//            tSQL.append("      ,MARKET_TYPE AS Z_MARKET_TYPE_CODE              \n");
//            tSQL.append("		 ,MAKER_CODE, dbo.GETICOMCODE2('"+house_code+"','M199',MAKER_CODE) AS Z_MAKER_NAME  \n");
//            tSQL.append("		,'' AS ATTACH_INDEX																	\n");
//            tSQL.append("		,ITEM_BLOCK_FLAG																\n");
//            tSQL.append("		,MAKER_ITEM_NO																	\n");
//            tSQL.append("		,DO_FLAG																		\n"); 			        
//            tSQL.append("		,QI_FLAG																		\n");					
//            tSQL.append("		,Z_WORK_STAGE_FLAG																\n");	         
//            tSQL.append("		,Z_DELIVERY_CONFIRM_FLAG														\n");  
//            tSQL.append("      ,MAKER_FLAG              \n");
//            tSQL.append("      ,MODEL_FLAG              \n");
//            tSQL.append("      ,MODEL_NO              \n"); 
//            tSQL.append("      ,ATTACH_NO              \n"); 
//            tSQL.append("      , (SELECT COUNT(*) FROM ICOMATCH WHERE DOC_NO = ATTACH_NO) AS ATTACH_CNT       \n");  
//            tSQL.append(" FROM ICOMREHD                                                                       \n");
//            tSQL.append(" WHERE HOUSE_CODE = '"+house_code+"'                                        			\n");
//            tSQL.append(" <OPT=F,S>  AND REQ_ITEM_NO = ?                 </OPT>                               \n");
            
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            result = sm.doSelect(args);
            if(result == null) throw new Exception("SQLManager is null");
        }catch(Exception ex) {
            throw new Exception("et_req_ins1_getQuery"+ ex.getMessage());
        }
        return result;
    }    
    
    /**
	 * 신용등급 등록
	 * @method real_setUpdate_vngl
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-10-24
	 * @modify 2014-10-24
	 */
    public SepoaOut real_setUpdate_vngl(Map<String, String> header) 
    {
        try
        {               
            int rtn_cnt = et_real_setUpdate_vngl(header);

        	if(rtn_cnt < 1) {
        		Rollback();
            } else {
            	Commit();
            }
            
            setStatus(1);
            setMessage("수정하였습니다.");  /* Message를 등록한다. */
            
        } catch(Exception e) {
            setStatus(0);
            setMessage(msg.get("0001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }   
    
    /**
	 * 신용등급 등록
	 * @method real_setUpdate_vngl
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   ICOYRQDT
	 * @since  2014-10-24
	 * @modify 2014-10-24
	 */
    private int et_real_setUpdate_vngl(Map<String, String> header) throws Exception
    {
        String dept         	= info.getSession("DEPARTMENT");
        String name_loc    		= info.getSession("NAME_LOC");
        String name_eng     	= info.getSession("NAME_ENG");
        String user_id     		= info.getSession("ID");
        String house_code		= info.getSession("HOUSE_CODE");
        String add_date 		= SepoaDate.getShortDateString();
        String add_time 		= SepoaDate.getShortTimeString();
        
        //Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> VENDOR_CODE : " + VENDOR_CODE);

        int rtn = -1;

        ConnectionContext ctx = getConnectionContext();
        
        /*String [] Data1 = HeaderData[0]; 
        
        String [][] Real1 = new String[1][]; 
        
        Real1[0] = Data1; 
*/
        String sys_date = SepoaDate.getShortDateString();
        String sys_time = SepoaDate.getShortTimeString();
        String sort_seq = null;
        
        //String[] type1   = {"S","S"};
        			 
        try {

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
           /* wxp.addVar("SYS_DATE",    sys_date);
            wxp.addVar("SYS_TIME",    sys_time);
            wxp.addVar("USER_ID",     user_id);
            wxp.addVar("HOUSE_CODE",  house_code);
            wxp.addVar("VENDOR_CODE", VENDOR_CODE);*/
            header.put("SYS_DATE", sys_date);
            header.put("SYS_TIME", sys_time);
            header.put("USER_ID", user_id);
            
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

            rtn = sm.doUpdate(header);
            
        } catch(Exception e) {
            Rollback();
            throw new Exception("et_real_setUpdate_vngl:"+e.getMessage());
        } finally{

        }
        return rtn;
    }
    
//    public SepoaOut real_upd1_setInsert3(String REQ_ITEM_NO, String[][] HeaderData) 
//    {
//        try
//        {               
//            int rtn_cnt = et_real_upd1_setInsert3(REQ_ITEM_NO, HeaderData );
//
//        	if(rtn_cnt < 1) {
//        		Rollback();
//            } else {
//            	Commit();
//            }
//            
//            setStatus(1);
//            setMessage("수정하였습니다.");  /* Message를 등록한다. */
//            
//        } catch(Exception e) {
//            setStatus(0);
//            setMessage(msg.get("0001"));
//            Logger.err.println(this,e.getMessage());
//        }
//        return getSepoaOut();
//    }   
    
    public SepoaOut real_upd1_setInsert3(Map<String, String> param) throws Exception {
    	ConnectionContext ctx = null;
        SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            id  = info.getSession("ID");
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
            sxp = new SepoaXmlParser(this, "et_real_upd1_setInsert3");
            ssm = new SepoaSQLManager(id, this, ctx, sxp);
            
            ssm.doUpdate(param);
            
            setMessage("수정하였습니다.");
            
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
    
    
    
    private int et_real_upd1_setInsert3(String REQ_ITEM_NO, String[][] HeaderData ) throws Exception
    {
        String dept         	= info.getSession("DEPARTMENT");
        String name_loc    		= info.getSession("NAME_LOC");
        String name_eng     	= info.getSession("NAME_ENG");
        String user_id     		= info.getSession("ID");
        String house_code		= info.getSession("HOUSE_CODE");
        String add_date 		= SepoaDate.getShortDateString();
        String add_time 		= SepoaDate.getShortTimeString();
        
        Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>> REQ_ITEM_NO : " + REQ_ITEM_NO);

        int rtn = -1;

        ConnectionContext ctx = getConnectionContext();
        
        String [] Data1 = HeaderData[0]; 
        
        String [][] Real1 = new String[1][]; 
        
        Real1[0] = Data1; 

        String sys_date = SepoaDate.getShortDateString();
        String sys_time = SepoaDate.getShortTimeString();
        String sort_seq = null;
        
        String[] type1   = {	"S","S","S","S","S","S","S","S","S","S",
        						"S","S","N","S","S","S","S","S","S" };
        			 
        try {

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("SYS_DATE",    sys_date);
            wxp.addVar("SYS_TIME",    sys_time);
            wxp.addVar("USER_ID",     user_id);
            wxp.addVar("HOUSE_CODE",  house_code);
            wxp.addVar("REQ_ITEM_NO", REQ_ITEM_NO);
            
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

            rtn = sm.doUpdate(Real1, type1);
            
        } catch(Exception e) {
            Rollback();
            throw new Exception("et_real_upd1_setInsert3:"+e.getMessage());
        } finally{

        }
        return rtn;
    }
 

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////   품목승인팝업 - 승인  //////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private String select(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          result = null;
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
		result = ssm.doSelect(param);
		
		return result;
	}
    
    private int update(ConnectionContext ctx, String name, Map<String, String> param) throws Exception{
		String          id     = info.getSession("ID");
		SepoaXmlParser  sxp    = null;
		SepoaSQLManager ssm    = null;
		int             result = 0;
		
		sxp = new SepoaXmlParser(this, name);
		ssm = new SepoaSQLManager(id, this, ctx, sxp);
		
//		System.out.println("tytolee : >" + sxp.getQuery() + "<");
		
		result = ssm.doUpdate(param);
		
		return result;
	}
    
    private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if(str.equals("")){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
    
    private String realSetInsertItemNo(ConnectionContext ctx, String reqItemNo, String materialType) throws Exception{
    	String              result       = null;
    	String              houseCode    = info.getSession("HOUSE_CODE");
    	String              selectResult = null;
    	Map<String, String> param        = new HashMap<String, String>();
    	SepoaFormater       sf           = null;
    	
    	param.put("HOUSE_CODE",  houseCode);
    	param.put("REQ_ITEM_NO", reqItemNo);
    	
    	selectResult = this.select(ctx, "selectIcomrehdInfo", param);
    	
    	sf = new SepoaFormater(selectResult);
    	
    	result = sf.getValue("ITEM_NO", 0);
    	result = this.nvl(result);
    	
    	if("".equals(result)){
    		param.clear();
    		param.put("HOUSE_CODE",  houseCode);
        	param.put("MATERIAL_TYPE", materialType);
    		
        	selectResult = this.select(ctx, "et_item_seq", param);
        	
        	sf = new SepoaFormater(selectResult);
        	
        	result = sf.getValue("ITEM_NO", 0);
    	}
    	
    	return result;
    }
    
    private Map<String, String> realSetInsertParam01(String itemNo, String reqItemNo, String[] headerData) throws Exception{
    	Map<String, String> result        = new HashMap<String, String>();
    	String              confirmUserId = info.getSession("ID");
    	String              houseCode     = info.getSession("HOUSE_CODE");
    	
    	result.put("ITEM_NO",            itemNo);
    	result.put("DESCRIPTION_LOC",    headerData[0]);
    	result.put("MATERIAL_TYPE",      headerData[1]);
    	result.put("MATERIAL_CTRL_TYPE", headerData[2]);
    	result.put("MATERIAL_CLASS1",    headerData[3]);
    	result.put("MATERIAL_CLASS2",    headerData[4]);
    	result.put("BASIC_UNIT",         headerData[5]);
    	result.put("SPECIFICATION",      headerData[6]);
    	result.put("Z_ITEM_DESC",        headerData[7]);
    	result.put("ITEM_ABBREVIATION",  headerData[8]);
    	result.put("IMAGE_FILE_PATH",    headerData[9]);
    	result.put("ITEM_GROUP",         headerData[10]);
    	result.put("Z_PURCHASE_TYPE",    headerData[11]);
    	result.put("REMARK",             headerData[12]);
    	result.put("MAKER_CODE",         headerData[13]);
    	result.put("MAKER_NAME",         headerData[14]);
    	result.put("APP_TAX_CODE",       headerData[15]);
    	result.put("DELIVERY_LT",        headerData[16]);
    	result.put("MARKET_TYPE",        headerData[17]);
    	result.put("MODEL_NO",           headerData[18]);
    	result.put("MTART",              headerData[19]);
    	result.put("MATKL",              headerData[20]);
    	result.put("TAXKM",              headerData[21]);
    	result.put("BKLAS",              headerData[22]);
    	result.put("KTGRM",              headerData[23]);
    	result.put("ATTACH_NO",          headerData[24]);
    	result.put("MAKE_AMT_CODE",      headerData[25]);
    	result.put("CONFIRM_USER_ID",    confirmUserId);
    	result.put("HOUSE_CODE",         houseCode);
    	result.put("REQ_ITEM_NO",        reqItemNo);
    	
    	return result;
    }
    
    private Map<String, String> realSetInsertParam02(String reqItemNo) throws Exception{
    	Map<String, String> result    = new HashMap<String, String>();
    	String              id        = info.getSession("ID");
    	String              houseCode = info.getSession("HOUSE_CODE");
    	
    	result.put("USER_ID",     id);
    	result.put("HOUSE_CODE",  houseCode);
    	result.put("REQ_ITEM_NO", reqItemNo);
    	
    	return result;
    }
    
    public SepoaOut real_setInsert(String REQ_ITEM_NO, String MATERIAL_TYPE, String[][] HeaderData) {
    	ConnectionContext   ctx     = null;
    	String              itemNo  = null;
    	Map<String, String> param01 = null;
    	Map<String, String> param02 = null;
    	
        try {            
        	ctx     = getConnectionContext();
        	itemNo  = this.realSetInsertItemNo(ctx, REQ_ITEM_NO, MATERIAL_TYPE);
        	param01 = this.realSetInsertParam01(itemNo, REQ_ITEM_NO, HeaderData[0]);
        	
        	this.update(ctx, "et_real_setInsert_01", param01);
        	
        	param02 = this.realSetInsertParam02(REQ_ITEM_NO);
        	
        	this.update(ctx, "et_real_setInsert_02", param02);
        	          
            setStatus(1);
          	setMessage("승인되었습니다.");
          	
            Commit();
        }
        catch(Exception e){
            try{
                Rollback();
            }
            catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            
            setValue(e.getMessage().trim());
            setStatus(0);
            setMessage(e.getMessage().trim());
        }
        
        return getSepoaOut();
    }
    
/*
    public SepoaOut CallNONDBJOB(	ConnectionContext ctx, String serviceId, String MethodName, Object[] obj ) 
	{ 
  
		String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB 
		 
		wise.srv.SepoaOut value = null; 
		wise.util.WiseRemote wr	= null; 

		//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다. 
		try 
		{ 

			wr = new wise.util.WiseRemote( serviceId, conType, info	); 
			wr.setConnection(ctx); 

			value =	wr.lookup( MethodName, obj ); 
			 
		}catch(	SepoaServiceException wse ) { 
			Logger.err.println("wse	= "	+ wse.getMessage()); 
			Logger.err.println("message	= "	+ value.message); 
			Logger.err.println("status = " + value.status); 
		}catch(Exception e)	{ 
			Logger.err.println("err	= "	+ e.getMessage()); 
			Logger.err.println("message	= "	+ value.message); 
			Logger.err.println("status = " + value.status); 
		} 
			
		return value; 
	} 
*/
    
    public String et_item_seq( String MATERIAL_TYPE, ConnectionContext ctx){
    	/*
    	 * 	IBKS 품목번호 형시 : 품목대분류(SW/HW/SI//CX) + 000000
    	 * */
        String HOUSE_CODE 		= info.getSession("HOUSE_CODE");

        String rtn_str = "";
        SepoaFormater wf = null;

        String item_no = "";
        SepoaSQLManager sm = null;
        
    	try {         
    			//String MATERIAL_TYPE = MATERIAL_CLASS1.substring(0, 2);// SW/HW/SI/CX
    			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    			wxp.addVar("HOUSE_CODE",	HOUSE_CODE);
    			wxp.addVar("MATERIAL_TYPE",	MATERIAL_TYPE);
    			
    			sm = new SepoaSQLManager(info.getSession("ID"),this, ctx, wxp.getQuery());
    			rtn_str = sm.doSelect((String[])null); 
				wf		= new SepoaFormater(rtn_str); 
			   	item_no = wf.getValue("ITEM_NO", 0);
			   	
			   	
    	}catch(Exception e){
    		Logger.err.println(this,e.getMessage());
    	}
    	
    	return item_no;
    }

    private int et_real_setInsert(String REQ_ITEM_NO, String MATERIAL_TYPE, String[][] HeaderData, String item_no, ConnectionContext ctx ) throws Exception {
    	
        String dept         	= info.getSession("DEPARTMENT");
        String name_loc     	= info.getSession("NAME_LOC");
        String name_eng   		= info.getSession("NAME_ENG");
        String user_id      	= info.getSession("ID");
        String house_code 		= info.getSession("HOUSE_CODE");
        String add_date 		= SepoaDate.getShortDateString();
        String add_time 		= SepoaDate.getShortTimeString();

        int rtn = -1;

        String sys_date = SepoaDate.getShortDateString();
        String sys_time = SepoaDate.getShortTimeString();
        String sort_seq = null;
        SepoaSQLManager sm = null;
        String[] type   = {	"S","S","S","S","S","S","S","S","S","S",
        					"S","S","S","S","S","S","N","S","S","S",
        					"S","S","S","S","S","S"};	// 15
        
        try {
			                
    		SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_01");
    		wxp1.addVar("ITEM_NO",     item_no);
    		wxp1.addVar("USER_ID",     user_id);
    		wxp1.addVar("SYS_DATE",    sys_date);
    		wxp1.addVar("SYS_TIME",    sys_time);
    		wxp1.addVar("HOUSE_CODE",  house_code);
    		wxp1.addVar("REQ_ITEM_NO", REQ_ITEM_NO);    		

            sm = new SepoaSQLManager(user_id,this,ctx, wxp1.getQuery()); 
            rtn = sm.doUpdate(HeaderData, type);                                      
                                                                                      
            /********************************************************************     
                ICOMMTGL(카탈로그마스터) 테이블에 INSERT한다                          
            *********************************************************************/    
                                                                                      
            //tSQL = new StringBuffer();                                                
    		SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_02");
    		wxp2.addVar("ITEM_NO",     item_no);
    		wxp2.addVar("USER_ID",     user_id);
    		wxp2.addVar("ADD_DATE",    add_date);
    		wxp2.addVar("ADD_TIME",    add_time);
    		wxp2.addVar("HOUSE_CODE",  house_code);
    		wxp2.addVar("REQ_ITEM_NO", REQ_ITEM_NO);    
    		
            sm = new SepoaSQLManager(user_id,this,ctx, wxp2.getQuery()); 
            //rtn = sm.doInsert(null,null);
            rtn = sm.doInsert();
            
        } catch(Exception e) {
            Rollback();
            throw new Exception("et_real_setInsert:"+e.getMessage());
        } finally{

        }
        return rtn;
    }   
    
    
    /**
    @Method Name : req_ins3_setDelete
    @작성자  : ECHO
    @작성일  : 2005.11.14
    @작업내용: 공급사 승인요청 카탈로그 수정
  	*/       
    public SepoaOut catalog_list_getQuery(String INTEGRATED_BUY_FLAG, String COMPANY_CODE, String[] args, String mode, String start_row, String end_row) 
    {
        try 
        {
			String[] rtn = new String[2];
			setStatus(1);

			if(mode.equals("CNT"))
            {
	            rtn = et_catalog_list_getQuery_cnt(INTEGRATED_BUY_FLAG, COMPANY_CODE, args);
            }
            else
            {
	            rtn = et_catalog_list_getQuery_data(INTEGRATED_BUY_FLAG, COMPANY_CODE, args, start_row, end_row);
            }

			if(rtn[1] != null)
			{
				setMessage(rtn[1]);
				setStatus(0);
			}

			setValue(rtn[0]);

        }catch(Exception e){
            
            setStatus(0);
            setMessage(msg.get("0001"));
            Logger.err.println(info.getSession("ID"),this, e.getMessage());
        }
        return getSepoaOut();

    }

    public String[] et_catalog_list_getQuery_cnt(String INTEGRATED_BUY_FLAG, String COMPANY_CODE, String[] args) throws Exception 
    {
        String[] rtn = new String[2];
        String house_code = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");		 
        String user_id    = info.getSession("ID");
        ConnectionContext ctx = getConnectionContext();

        try 
        {
        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		wxp.addVar("HOUSE_CODE", house_code);
    		wxp.addVar("ARGS_1",     args[1]);

    		    		
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            rtn[0] = sm.doSelect(args);
            if(rtn[0] == null) throw new Exception("SQLManager is null");
        }catch(Exception ex) {
			rtn[1] = ex.getMessage();
			rtn[0] = "";
            throw new Exception("et_catalog_list_getQuery"+ ex.getMessage());
        }
        return rtn;
    }

    public String[] et_catalog_list_getQuery_data(String INTEGRATED_BUY_FLAG, String COMPANY_CODE, String[] args, String start_row, String end_row) throws Exception 
    {
        String[] rtn = new String[2];
        String house_code = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");		 
        String user_id    = info.getSession("ID");
        ConnectionContext ctx = getConnectionContext();

        try 
        {
         	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    		wxp.addVar("HOUSE_CODE", house_code);
    		wxp.addVar("ARGS_1",     args[1]);
    		wxp.addVar("START_ROW",  start_row);
    		
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp.getQuery());
            rtn[0] = sm.doSelect(args);
            if(rtn[0] == null) throw new Exception("SQLManager is null");
        }catch(Exception ex) {
			rtn[1] = ex.getMessage();
			rtn[0] = "";
            throw new Exception("et_catalog_list_getQuery"+ ex.getMessage());
        }
        return rtn;
    }  

    
    // 품목수정 real_pp_upd2.jsp
     public SepoaOut real_getReqList1(String[] args) 
    {
        try 
        {
            String rtn = null;
            rtn = et_real_getReqList1(args);
            
            Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>>>>>>> rtn : " + rtn);
            
            setValue(rtn);
            setStatus(1);
            setMessage(msg.get("0000"));
        }catch(Exception e){
            
            setStatus(0);
            setMessage(msg.get("0001"));
            Logger.err.println(info.getSession("ID"),this, e.getMessage());
        }
        return getSepoaOut();
    }

    public String et_real_getReqList1(String[] args) throws Exception   
    {
        String result = null;
        String house_code = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        String pr_location    = info.getSession("LOCATION_CODE");
        
        String user_id    = info.getSession("ID");
        
        ConnectionContext ctx = getConnectionContext();
        Map<String, String> sqlParam = new HashMap<String, String>();

        try {
            SepoaXmlParser wxp = new SepoaXmlParser(this, "et_real_getReqList1");
            sqlParam.put("house_code",   house_code);
    		sqlParam.put("company_code", company_code);
    		sqlParam.put("pr_location",  pr_location);
    		
            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, wxp);
            
            sqlParam.put("item_no", args[0]);
            
            result = sm.doSelect(sqlParam);
            
            if(result == null){
            	throw new Exception("SQLManager is null");
            }
            
        } catch(Exception ex) {
            throw new Exception("et_real_getReqList1"+ ex.getMessage());
        }
        return result;
    }

    
    public SepoaOut confirm_getUpdate( String REQ_ITEM_NO, String ITEM_NO, String REMARK, String ATTACH_NO, String[][] HeaderData) {
        try
        {
        	ConnectionContext ctx = getConnectionContext();
            int rtn_cnt = et_confirm_getUpdate(REQ_ITEM_NO, REMARK, HeaderData, ctx); 	//품목등록요청정보 수정(ICOMREHD)
            int rtn_cnt1 = et_confirm_getUpdate1(ITEM_NO, ATTACH_NO, HeaderData, ctx);  			//품목정보 수정(ICOMMTGL)
            Logger.err.println(userid, this, "ICOMREHD : " + rtn_cnt + ", ICOMMTGL : " + rtn_cnt1);
            //if(rtn_cnt < 1 || rtn_cnt1 < 1 )
            if(rtn_cnt1 < 1) {
                Rollback();
                setStatus(0);
            	setMessage("수정중 에러가 발생하였습니다.");  /* Message를 등록한다. */
            } else {
            	/*
            	Object[] obj = {"U",ITEM_NO};
            	SepoaOut value = CallNONDBJOB( ctx,  "ItemMaster", "sendSCI", obj);
            	
          		if(value.status == 0)
          			throw new Exception(value.message);
            	 */
          		Commit();
          		
                setStatus(1);
            	setMessage("수정되었습니다.");  /* Message를 등록한다. */
            }
        } catch(Exception e) {
        	try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setStatus(0);
            setMessage(e.getMessage().trim());
        }
        //Commit();
        return getSepoaOut();
    }
       
       
       private int et_confirm_getUpdate(String REQ_ITEM_NO, String REMARK, String[][] HeaderData, ConnectionContext ctx) throws Exception
       {

           int rtn = -1;

           String house_code = info.getSession("HOUSE_CODE");
           String name_loc  = info.getSession("NAME_LOC"); 
           String user_id   = info.getSession("ID");
           String add_date = SepoaDate.getShortDateString();
           String add_time = SepoaDate.getShortTimeString();
           String sort_seq = null;
           String[] type   = {"S","S","S","S","S","S","S","S","S","S","S"
           		              ,"S","S","S","S","S","S","S","S","S","S","S"};
           try {

               //StringBuffer sql = new StringBuffer();
               SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       		   wxp.addVar("ADD_DATE",    add_date);
       		   wxp.addVar("ADD_TIME",    add_time);
       		   wxp.addVar("USER_ID",     user_id);
       		   wxp.addVar("NAME_LOC",    name_loc);
       		   wxp.addVar("HOUSE_CODE",  house_code);
       		   wxp.addVar("REQ_ITEM_NO", REQ_ITEM_NO);
       		   wxp.addVar("REMARK",      REMARK);
       		   
       		   
               // ICOMREHD UPDATE
//               sql.append( "UPDATE ICOMREHD SET                         \n");
//               sql.append( "    DESCRIPTION_LOC    = ?                   \n");
//               sql.append( "    ,MAKER_NAME        = ?                   \n");
//               sql.append( "    ,MAKER_CODE        = ?                   \n");
//               sql.append( "    ,MODEL_NO          = ?                   \n");
//               sql.append( "    ,MATERIAL_TYPE     = ?                   \n");
//               sql.append( "    ,MATERIAL_CTRL_TYPE= ?                   \n");
//               sql.append( "    ,MATERIAL_CLASS1   = ?                   \n"); 
//               sql.append( "    ,APP_TAX_CODE      = ?                   \n");
//               sql.append( "    ,Z_ITEM_DESC       = ?                   \n"); 
//               sql.append( "    ,ITEM_BLOCK_FLAG   = ?                   \n");
//               sql.append( "    ,MAKER_FLAG        = ?                   \n");
//               sql.append( "    ,MODEL_FLAG        = ?                   \n");
//               sql.append( "    ,ITEM_ABBREVIATION        = ?            \n");
//               
//               sql.append( "    ,MTART       			 	= ?            \n");
//               sql.append( "    ,MATKL        			 	= ?            \n");
//               sql.append( "    ,ITEM_GROUP        			= ?            \n");
//               sql.append( "    ,TAXKM        				= ?            \n");
//               sql.append( "    ,KTGRM        				= ?            \n");
//               
//               sql.append( "   ,CHANGE_DATE     = '"+add_date+"'        \n");
//               sql.append( "   ,CHANGE_TIME     = '"+add_time+"'        \n");
//               sql.append( "   ,CHANGE_USER_ID  = '"+user_id+"'         \n");
//               sql.append( "   ,CHANGE_USER_NAME_LOC= '"+name_loc+"'    \n");
//               sql.append( "WHERE HOUSE_CODE =  '"+house_code+"'        \n");
//               sql.append( " AND REQ_ITEM_NO =  '"+REQ_ITEM_NO+"'       \n");
//               sql.append( " AND STATUS <>  'D'                         \n");

               SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

               rtn = sm.doUpdate(HeaderData, type);

           }catch(Exception e) {
              
        	   Rollback();
               throw new Exception("et_confirm_getUpdate==========================================>"+e.getMessage());
           } finally{

           }
           return rtn;
       }
    
       private int et_confirm_getUpdate1(String ITEM_NO, String ATTACH_NO, String[][] HeaderData, ConnectionContext ctx) throws Exception
       {

           int rtn = -1;

           String house_code = info.getSession("HOUSE_CODE");
           String name_loc  = info.getSession("NAME_LOC"); 
           String user_id   = info.getSession("ID");
           String add_date = SepoaDate.getShortDateString();
           String add_time = SepoaDate.getShortTimeString();
           String sort_seq = null;
           String[] type   = {"S","S","S","S","S","S","S","S","S","S","S"
		              ,"S","S","S","S","S","S","S","S","S","S","S"};
           try {

               //StringBuffer sql = new StringBuffer();
               SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       		   wxp.addVar("ADD_DATE",    add_date);
       		   wxp.addVar("ADD_TIME",    add_time);
       		   wxp.addVar("USER_ID",     user_id);
       		   wxp.addVar("ATTACH_NO",   ATTACH_NO);
       		   wxp.addVar("HOUSE_CODE",  house_code);
       		   wxp.addVar("ITEM_NO",     ITEM_NO);
       		
       		   
               // ICOMREHD UPDATE
//               sql.append( "UPDATE ICOMMTGL  SET                         \n");
//               sql.append( "    DESCRIPTION_LOC    = ?                   \n");
//               sql.append( "    ,MAKER_NAME        = ?                   \n");
//               sql.append( "    ,MAKER_CODE        = ?                   \n");
//               sql.append( "    ,MODEL_NO          = ?                   \n");
//               sql.append( "    ,MATERIAL_TYPE     = ?                   \n");
//               sql.append( "    ,MATERIAL_CTRL_TYPE= ?                   \n");
//               sql.append( "    ,MATERIAL_CLASS1   = ?                   \n"); 
//               sql.append( "    ,APP_TAX_CODE      = ?                   \n");
//               sql.append( "    ,Z_ITEM_DESC       = ?                   \n"); 
//               sql.append( "    ,ITEM_BLOCK_FLAG   = ?                   \n");
//               sql.append( "    ,MAKER_FLAG        = ?                   \n");
//               sql.append( "    ,MODEL_FLAG        = ?                   \n"); 
//               sql.append( "    ,ITEM_ABBREVIATION        = ?              \n");
//               sql.append( "    ,MTART       			 	= ?            \n");
//               sql.append( "    ,MATKL        			 	= ?            \n");
//               sql.append( "    ,ITEM_GROUP        			= ?            \n");
//               sql.append( "    ,TAXKM        				= ?            \n");
//               sql.append( "    ,KTGRM        				= ?            \n");
//               
//               sql.append( "   ,CHANGE_DATE     = '"+add_date+"'        \n");
//               sql.append( "   ,CHANGE_TIME     = '"+add_time+"'        \n");
//               sql.append( "   ,CHANGE_USER_ID  = '"+user_id+"'         \n"); 
//               sql.append( "WHERE HOUSE_CODE =  '"+house_code+"'        \n");
//               sql.append( " AND ITEM_NO =  '"+ITEM_NO+"'       \n");
//               sql.append( " AND STATUS <>  'D'                         \n");

               SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

               rtn = sm.doUpdate(HeaderData, type);

           }catch(Exception e) {
               Rollback();
               throw new Exception("et_confirm_getUpdate1==========================================>"+e.getMessage());
           } finally{

           }
           return rtn;
       }
       
   	public SepoaOut Approval(SignResponseInfo inf)
    { 
    	try 
        { 
	        String  ans = inf.getSignStatus(); 
	        
	        Logger.debug.println(userid,this,"inf.getSignStatus()===============>"+inf.getSignStatus()+"-------"); 	        

	        String[] pr_no     = inf.getDocNo(); 
	        String signuserid  = inf.getSignUserId(); 
	        String signdate    = inf.getSignDate(); 
	        String ctrl_reason = inf.getSignRemark(); 
	        
	        for(int i=0; i<pr_no.length; i++)
	        	Logger.debug.println(userid,this,"pr_no["+i+"]==>"+pr_no[i]); 
	        
	        if(!ctrl_reason.equals("")) { 
	            ctrl_reason = "결재반려@"+ctrl_reason ; 
	        } 
	        
	        String flag = ""; 
	        String dc_no = ""; 
	        String rtn_2 = ""; 
	        int res = -1;
	        
	        if(inf.getSignStatus() == null)
	        	ans = "xxxxxxxx"; 	 
 
            //완료: E, 반려 : R 로 처리 
            if(ans.equals("E")){
                flag = "E"; 
            }else if (ans.equals("R")){ 
                flag = "R"; 
            } 
            
            String[][] all_pr_no = new String[pr_no.length][1]; 
            
            for (int i = 0; i < pr_no.length; i++) {
                String Data[] = {pr_no[i]};
                all_pr_no[i] = Data;
                Logger.debug.println(info.getSession("ID"), this, "all_pr_no["+i+"]==================>"+all_pr_no[i][0]);
            }

            //결재취소
            if(ans.equals("D")) 
                res = et_setApping_return(all_pr_no); 
            else 
                res = et_setApping(flag,all_pr_no,ctrl_reason,signuserid,signdate); 
 
            setStatus(1); 
            
        } catch(Exception e) { 
            Logger.err.println("setSignStatus: = " + e.getMessage()); 
            setStatus(0); 
        } 
        return getSepoaOut(); 
    }
   	
    private int et_setApping_return(String[][] all_pr_no ) throws Exception 
    { 
        int rtn = -1; 
        
        try { 
        	
          String house_code = info.getSession("HOUSE_CODE"); 

          ConnectionContext ctx = getConnectionContext(); 
          SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
          	wxp.addVar("house_code", house_code);
//          StringBuffer sql = new StringBuffer(); 
//          sql.append(" UPDATE ICOMREHD SET                 \n"); 
//          sql.append("        Z_SIGN_STATUS = 'D'           \n"); 
//          sql.append(" WHERE HOUSE_CODE = '"+house_code+"' \n"); 
//          sql.append(" AND   STATUS != 'D'                 \n"); 
//          sql.append(" AND   REQ_ITEM_NO = ?                     \n"); 
          
          String[] type = {"S"}; 
          SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
          rtn = sm.doUpdate(all_pr_no, type); 
          
      } catch(Exception e) { 
          throw new Exception("setSIGN_STATUS:"+e.getMessage()); 
      }  
      return rtn; 
  }
  
  private int et_setApping(String flag,String[][] all_pr_no, String ctrl_reason,String signuserid,String signdate ) throws Exception 
    { 
        int rtn = -1; 
 
        try { 
        	
            String house_code = info.getSession("HOUSE_CODE"); 
     
            ConnectionContext ctx = getConnectionContext(); 

            String rtnSel =  getusername(signuserid); 
            SepoaFormater wf = new SepoaFormater(rtnSel);
            String signname = wf.getValue(0,0);
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            	wxp.addVar("flag", flag);
            	wxp.addVar("house_code", house_code);
            	
//            StringBuffer sql = new StringBuffer(); 
//            sql.append(" UPDATE ICOMREHD SET                     	\n");
//    		sql.append("        Z_SIGN_STATUS = '"+flag+"'           	\n");
//            sql.append(" WHERE HOUSE_CODE = '"+house_code+"'        \n"); 
//            sql.append(" AND   STATUS != 'D'                        \n"); 
//            sql.append(" AND   REQ_ITEM_NO = ?                            \n");
            
            String[] type = {"S"}; 
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
            rtn = sm.doUpdate(all_pr_no, type); 
            
        } catch(Exception e) { 
            throw new Exception("setSIGN_STATUS:"+e.getMessage()); 
        }           
        return rtn; 
    }
  
  private String getusername(String ls_id) throws Exception 
  { 
      String rtn = null; 
      ConnectionContext ctx = getConnectionContext(); 
      String house_code = info.getSession("HOUSE_CODE"); 
      String company = info.getSession("COMPANY_CODE"); 
      SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
      	wxp.addVar("house_code", house_code);
      	wxp.addVar("company", company);
      	wxp.addVar("ls_id", ls_id);
      	
//      StringBuffer sql = new StringBuffer(); 
//      sql.append(" select user_name_loc from icomlusr     \n"); 
//      sql.append(" where house_code = '"+house_code+"'    \n"); 
//      sql.append(" and   company_code ='"+company+"'      \n"); 
//      sql.append(" and   user_id = '"+ls_id+"'            \n"); 

      try { 
          SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
          rtn = sm.doSelect((String[])null); 
      } catch(Exception e) { 
          Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
          throw new Exception(e.getMessage()); 
      } 
      return rtn; 
  }
  
  
  public SepoaOut isCheckedSameItemName(String ITEM_NAME) {
      try {
          String rtn = "";

          rtn = et_isCheckedSameItemName(ITEM_NAME);
          setMessage(msg.get("0000"));
          setValue(rtn);
          setStatus(1);
      }catch (Exception e){
          Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
          setMessage(msg.get("0001"));
          setStatus(0);
      }
      return getSepoaOut();
  }    
  
  private String et_isCheckedSameItemName(String ITEM_NAME) throws Exception 
  { 
      String rtn = null; 
      ConnectionContext ctx = getConnectionContext(); 
      String HOUSE_CODE = info.getSession("HOUSE_CODE"); 
      
      SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
      	wxp.addVar("HOUSE_CODE", HOUSE_CODE);
      	wxp.addVar("ITEM_NAME", ITEM_NAME.replace(" ", "").toUpperCase());
      	

      try { 
          SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery()); 
          rtn = sm.doSelect((String[])null); 
      } catch(Exception e) { 
          Logger.err.println(info.getSession("ID"),this,e.getMessage()); 
          throw new Exception(e.getMessage()); 
      } 
      return rtn; 
  }
       
}