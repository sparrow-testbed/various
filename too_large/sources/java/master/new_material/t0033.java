/**
===========================================================================================================
FUNCTION NAME   DESCRIPTION
===========================================================================================================
-----------------------------------------------------------------------------------------------------------
담당자 신규 통합 카탈로그 등록 요청 승인

[ confirm_bd_lis1_getQuery ]......................................  등록 요청 승인 목록
-----------------------------------------------------------------------------------------------------------
**/

package master.new_material;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

public class t0033 extends SepoaService {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////           Session 정보를 담기위한 변수             //////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    String add_date = "";
    String add_time = "";
    String change_user_dept = "";
    String status = "";
    String lang = "";
    String position = "";
    String operating_code = "";
    String working_area = "";
    String next_date = "";
    Message msg = null;

    String user_id		= info.getSession("ID");
    String house_code	= info.getSession("HOUSE_CODE");
    String plant_code	= info.getSession("PLANT_CODE");
    String location		= info.getSession("LOCATION_CODE");
    String location_name	= info.getSession("LOCATION_NAME");
    String vendor_code	= info.getSession("VENDOR_CODE");
    String department	= info.getSession("DEPARTMENT");
    String name_loc		= info.getSession("NAME_LOC");
    String name_eng		= info.getSession("NAME_ENG");
    String language		= info.getSession("LANGUAGE");
    String ctrl_code	= info.getSession("CTRL_CODE");
    String tel			= info.getSession("TEL");
    String email		= info.getSession("EMAIL");
    String add_user_dept = info.getSession("DEPARTMENT");
    String company_code = info.getSession("COMPANY_CODE");
    
    public t0033(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        setVersion("1.0.0");

        //Session 정보 조회
        position = info.getSession("POSITION");
        operating_code = info.getSession("LOCATION_CODE");
        working_area = info.getSession("WORKING_AREA");

        String[] plant_parse = null;
        plant_code = info.getSession("PLANT_CODE");

        add_date = SepoaDate.getShortDateString();
        add_time = SepoaDate.getShortTimeString();
        
        next_date = SepoaDate.addSepoaDateDay(add_date,1); 



        lang = info.getSession("LANGUAGE");
        ctrl_code = info.getSession("CTRL_CODE");
        msg = new Message(info,"p11_ctr");
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////   품목승인 조회  //////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    public SepoaOut confirm_bd_lis1_getQuery(String [] queryData) 
//    {
//        try {
//            String rtn = new String();
//            //Query 수행부분 Call
//            rtn = et_confirm_bd_lis1_getQuery(queryData);
//            msg.setArg("JOB","조회");
//            setMessage(msg.getMessage("0000"));
//            setValue(rtn);
//            setStatus(1);
//        }catch (Exception e){
//            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
//            msg.setArg("JOB","조회");
//            setMessage(msg.getMessage("0001"));
//            setStatus(0);
//        }
//        return getSepoaOut();
//    }
    
    public SepoaOut confirm_bd_lis1_getQuery(Map<String, String> param) {
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_confirm_bd_lis1_getQuery");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn    = ssm.doSelect(param); // 조회
			
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

    private String et_confirm_bd_lis1_getQuery(String [] queryData) throws Exception{
        String rtn = "";
        ConnectionContext ctx = getConnectionContext();
        
        try {
            //StringBuffer sql = new StringBuffer();
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("HOUSE_CODE", house_code);
            
//            sql.append(" SELECT                                                                                                  \n ");                                    
//            sql.append("              RHD.REQ_DATE,                                                                              \n ");
//            sql.append("              RHD.SPECIFICATION,                                                                         \n ");
//            sql.append("              RHD.DESCRIPTION_LOC,                                                                       \n ");
//            sql.append("              dbo.GETICOMCODE2('"+house_code+"','M183', RHD.REQ_TYPE) REQ_TYPE,                          	 \n "); 
//            sql.append("              RHD.REQ_TYPE as REQ_CODE,                                                                  \n "); 
//            sql.append("              (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE HOUSE_CODE = '"+house_code+"' AND USER_ID = RHD.REQ_USER_ID)\n "); 
//            sql.append("              as REQ_NAME_LOC,                                                                       	 \n "); 
//            sql.append("              dbo.GETICOMCODE2('"+house_code+"','M184',RHD.DATA_TYPE) DATA_TYPE,                         	 \n ");
//            sql.append("              RHD.CONFIRM_DATE,                                                                          \n ");
//            sql.append("              (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE HOUSE_CODE = '"+house_code+"' AND USER_ID = RHD.CONFIRM_USER_ID) CONFIRM_NAME_LOC,               \n ");
//            sql.append("              dbo.GETICOMCODE2('"+house_code+"','M185',RHD.CONFIRM_STATUS) CONFIRM_STATUS,               	 \n ");
//            sql.append("              RHD.CONFIRM_STATUS as CONFIRM_CODE,                                                        \n ");
//            sql.append("              RHD.REQ_ITEM_NO,                                                                           \n ");
//            sql.append("              RHD.IMAGE_FILE_PATH,                                                                       \n ");
//            sql.append("              RHD.ITEM_NO, ITEM_GROUP, REMARK,                                                                               \n ");
//            sql.append("              dbo.GETCOMPANYNAME(VDR.HOUSE_CODE, VDR.VENDOR_CODE, 'S', 'KR') VENDOR_NAME,                    \n ");
//            sql.append("              RHD.ITEM_GROUP, RHD.DATA_OCCUR_TYPE,                                                                       \n ");
//            sql.append("              CASE WHEN RHD.DATA_OCCUR_TYPE='L' THEN '통합'                                              \n ");
//            sql.append("                   WHEN RHD.DATA_OCCUR_TYPE='V' THEN '공급사'                                            \n ");
//            sql.append("                    ELSE '' END AS DATA_OCCUR_NAME,                                    					 \n ");
//            sql.append("              RHD.BASIC_UNIT,                                                                            \n ");
//            sql.append("			  RHD.Z_PURCHASE_TYPE,  		  															 \n ");
//            sql.append("			  RHD.DELIVERY_LT,       		  															 \n ");  
//            sql.append("			  RHD.QI_FLAG,        			  															 \n ");  
//            sql.append("			  RHD.DO_FLAG,        			  															 \n ");  
//            sql.append("			  RHD.Z_WORK_STAGE_FLAG,           															 \n ");
//            sql.append("			  RHD.Z_DELIVERY_CONFIRM_FLAG,     															 \n ");
//            sql.append("			  dbo.GETICOMCODE3('100','M602',RHD.Z_PURCHASE_TYPE) as Z_PURCHASE_TYPE_COLOR,					 \n ");
//            sql.append("			  RHD.REJECT_REMARK,           															 	 \n ");
//            sql.append("			  RHD.MAKER_NAME           															 	 \n ");
//            sql.append(" FROM      ICOMREHD RHD  LEFT OUTER JOIN                                                                 				 \n ");
//            sql.append("                          (SELECT USR.USER_ID,                                                           \n" );
//            sql.append("                                  USR.HOUSE_CODE,                                                        \n" );
//            sql.append("                                  NGL.VENDOR_CODE                                                        \n" );
//            sql.append("                             FROM ICOMLUSR USR ,ICOMVNGL NGL                                   \n" );
//            sql.append("                             WHERE USR.HOUSE_CODE = '"+house_code+"'                                     \n" );
//            sql.append("                               AND USR.HOUSE_CODE = NGL.HOUSE_CODE                                       \n" );
//            sql.append("                               AND USR.COMPANY_CODE = NGL.VENDOR_CODE                                    \n" );
//            sql.append("                           ) VDR                                                                         \n" );
//            sql.append("     ON  RHD.HOUSE_CODE = VDR.HOUSE_CODE                                                              \n" );
//            sql.append("     AND RHD.REQ_USER_ID = VDR.USER_ID                                                                \n" ); 
//            sql.append(" WHERE    RHD.HOUSE_CODE        =  '"+house_code+"'                                                      \n ");    
//            sql.append("   AND     RHD.STATUS <> 'D'                                                                             \n ");
//            sql.append("   AND     RHD.SIGN_STATUS = 'E'                                                                         \n ");
//            sql.append("   AND      RHD.DATA_OCCUR_TYPE   IN ('L','V')                                                           \n ");
//            sql.append("  <OPT=S,S> AND      RHD.REQ_DATE      >=      ?    </OPT>                                               \n ");
//            sql.append("  <OPT=S,S> AND      RHD.REQ_DATE      <=      ?    </OPT>                                               \n ");
//            sql.append("  <OPT=S,S> AND      (SELECT USER_NAME_LOC FROM ICOMLUSR WHERE HOUSE_CODE = '"+house_code+"' AND USER_ID = RHD.REQ_USER_ID) LIKE '%' + ? + '%'         </OPT>                                                                                                     \n ");
//            sql.append("  <OPT=S,S> AND      RHD.DESCRIPTION_LOC LIKE '%'+?+'%' </OPT>                                         \n ");
//            //sql.append("  <OPT=S,S> AND      RHD.REQ_TYPE  =      ?          </OPT>                                              \n ");
//            sql.append("  <OPT=S,S> AND      RHD.CONFIRM_STATUS = ?          </OPT>                                              \n ");
//            //sql.append("  <OPT=S,S> AND      RHD.DATA_TYPE      =      ?     </OPT>                                              \n ");
//            //sql.append("  <OPT=S,S> AND      RHD.DATA_OCCUR_TYPE      =      ?     </OPT>                                        \n ");
//            //sql.append("  <OPT=S,S> AND      RHD.ITEM_GROUP      =      ?     </OPT>                                        \n ");
//            //  sql.append(" ORDER BY  RHD.REQ_ITEM_NO DESC , RHD.CONFIRM_DATE DESC                                                  \n ");            
//            sql.append(" ORDER BY  RHD.REQ_DATE , RHD.CONFIRM_DATE DESC                                                  \n ");            

            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery()); 
            Logger.debug.println(info.getSession("ID"),this, wxp.getQuery());

            rtn = sm.doSelect(queryData);

            if(rtn == null) throw new Exception("SQL Manager is Null");
        }catch(Exception e) {
            throw new Exception("et_confirm_bd_lis1_getQuery ==========================================>"+e.getMessage());
        } finally{
        }
        return rtn;
    }      
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////   신규 등록 반려    ///////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    public SepoaOut confirm_bd_upd2_getUpdate( String [] args, String [] args2 ) 
//    {
//        String rtnupd = null;
//        String rtnCount = null;
//
//        try 
//        {
//            rtnCount = et_confirm_getCount(args);   //결재상태 체크
//            
//            if(rtnCount.equals("0"))
//            {
//                rtnupd = et_confirm_bd_upd2_getUpdate(args, args2);
//                //setValue(" 성공적으로 작업을 수행했습니다. ");
//    
//                if (rtnupd.equals("ERROR"))  //오류가 발생하였다.
//                {
//                    setMessage(msg.getMessage("0003"));
//                    setStatus(0);
//                } 
//                else 
//                {
//                    setValue(rtnupd);
//                    setStatus(1);
//                }
//            }
//            else
//            {
//               setMessage("이미결재 완료되었습니다.");
//               setStatus(3);
//            }
//            
//        }catch(Exception e)
//        {
//            Logger.err.println( info.getSession( "ID" ), this, "setUpdate Exception e =" + e.getMessage() );
//            setStatus(0);
//            Logger.err.println( info.getSession( "ID" ), this, e.getMessage() );
//        }
//        return getSepoaOut();
//    }
    
    @SuppressWarnings("unchecked")
	public SepoaOut confirm_bd_upd2_getUpdate(Map<String, Object> param) throws Exception {
    	ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
		String                    id       = info.getSession("ID");
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                sxp = new SepoaXmlParser(this, "et_confirm_bd_upd2_getUpdate");
                ssm = new SepoaSQLManager(id, this, ctx, sxp);
                
                ssm.doUpdate(gridInfo);
            }
			
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


    //승인,반려여부 체크
    private String et_confirm_getCount(String [] args) throws Exception
     {
         String rtn = null;
         String count = "";
         ConnectionContext ctx = getConnectionContext();
         
         try 
         {
             String req_item_no = args[0];

             //StringBuffer sql = new StringBuffer();
             SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
             wxp.addVar("HOUSE_CODE",  house_code);
             wxp.addVar("REQ_ITEM_NO", req_item_no);

//             sql.append("    SELECT COUNT(REQ_ITEM_NO)                                \n");
//             sql.append("    FROM ICOMREHD                                            \n");
//             sql.append("    WHERE HOUSE_CODE = '"+house_code+"'                      \n");
//             sql.append("      AND (CONFIRM_STATUS IN ('E','R')                       \n");
//             sql.append("           OR STATUS = 'D')                                  \n");
//             sql.append("      AND REQ_ITEM_NO = '"+ req_item_no +"'                  \n");
                                                                 
             
             SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery()); 
             Logger.err.println(info.getSession("ID"),this, wxp.getQuery());

             rtn = sm.doSelect((String[])null);
             
             SepoaFormater wf = new SepoaFormater(rtn);
             count = wf.getValue(0, 0);

             Logger.debug.println(user_id,this,"######check Duplicate###count####"+count);

             if(rtn == null) throw new Exception("SQL Manager is Null");
         }
         catch(Exception e) 
         {
             throw new Exception("et_confirm_getCount ==========================================>"+e.getMessage());
         } 
         finally
         {
         }
         return count;
     }
 
    
    private String et_confirm_bd_upd2_getUpdate(String [] args, String [] args2) throws Exception 
    {
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        
        //StringBuffer sql = null;        
        String returnString = "";
        SepoaFormater wf = null;
        
        String process_text  =  "";
        String item_no   =  "";

        int rtnUpd = 0;
		try 
        {
            String req_item_no = args[0];
            String z_remark = args2[0];
    
            /********************************************************************
                ICOMREHD(신규요청) 테이블에 UPDATE한다
            *********************************************************************/

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("Z_REMARK", z_remark);
            wxp.addVar("USER_ID", user_id);
            wxp.addVar("ADD_DATE", add_date);
            wxp.addVar("ADD_TIME", add_time);
            wxp.addVar("NAME_LOC", name_loc);
            wxp.addVar("HOUSE_CODE", house_code);
            wxp.addVar("REQ_ITEM_NO", req_item_no);
            
            sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery()); 
    
            rtnUpd = sm.doUpdate((String[][])null,null);
    
            if(rtnUpd < 1)
            {
                Rollback();
                returnString = "ERROR";
            }
            else
            {
                Commit();
                returnString = "OK";
                
            }
        }   

        catch( Exception e )
        {
            Rollback();
            returnString = "ERROR";
            Logger.err.println( info.getSession( "ID" ), this, "et_confirm_bd_upd2_setUpdate ERROR====>"+e.getMessage() );
        } 
        finally
        { 
        }   
        return returnString;  
    }  
  
    
    
    //품목마스트 수정
    public SepoaOut confirm_pp_upd3_getUpdate( String REQ_ITEM_NO, String[][] HeaderData, String[][] HeaderData2,  String ITEM_NO) {
        try
        {

            int rtn_cnt = et_confirm_pp_upd3_getUpdate(REQ_ITEM_NO, HeaderData); 
            int rtn_cnt1 = et_confirm_pp_upd3_getUpdate1(ITEM_NO, HeaderData2); 
            //int rtn_cnt1 =1;
            //if(DETAIL_FLAG.equals("Y")){
            //    rtn_cnt1 = et_confirm_pp_upd3_getUpdate2( REQ_ITEM_NO, setData);
            //}

            if(rtn_cnt < 1 || rtn_cnt1 < 1 )
            {
                Rollback();
                setStatus(0);
            	setMessage("수정중 에러가 발생하였습니다.");  /* Message를 등록한다. */
            }
            else
            {
                Commit();
                setStatus(1);
            	setMessage("수정되었습니다.");  /* Message를 등록한다. */
            }
        } 
        catch(Exception e) 
        {
            setStatus(0);
            setMessage("수정중 에러가 발생하였습니다.");
            Logger.err.println(this,e.getMessage());
            //log err
        }
        //Commit();
        return getSepoaOut();
    }
       
       
       private int et_confirm_pp_upd3_getUpdate(String REQ_ITEM_NO,String[][] HeaderData) throws Exception
       {

           int rtn = -1;

           ConnectionContext ctx = getConnectionContext();

           String sys_date = SepoaDate.getShortDateString();
           String sys_time = SepoaDate.getShortTimeString();
           String sort_seq = null;
           String[] type   = {"S","S","S","S","S","S","S","S","S","S"
           		              ,"S","S","S","S"   };
           try {

               //StringBuffer sql = new StringBuffer();
               SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       		   wxp.addVar("ADD_DATE",    add_date);
       		   wxp.addVar("ADD_TIME",    add_time);
       		   wxp.addVar("USER_ID",     user_id);
       		   wxp.addVar("NAME_LOC",    name_loc);
       		   wxp.addVar("HOUSE_CODE",  house_code);
       		   wxp.addVar("REQ_ITEM_NO", REQ_ITEM_NO);
               
               // ICOMREHD 등록
//               sql.append( "UPDATE ICOMREHD SET                         \n");
//               sql.append( "    DESCRIPTION_LOC    = ?                   \n");
//               sql.append( "    ,MAKER_NAME        = ?                   \n");
//               sql.append( "    ,MAKER_CODE        = ?                   \n");
//               sql.append( "    ,MODEL_NO          = ?                   \n");
//               sql.append( "    ,BASIC_UNIT        = ?                   \n");
//               sql.append( "    ,MATERIAL_TYPE     = ?                   \n");
//               sql.append( "    ,MATERIAL_CTRL_TYPE= ?                   \n");
//               sql.append( "    ,MATERIAL_CLASS1   = ?                   \n");
//               //sql.append( "    ,MATERIAL_CLASS2   = ?                   \n"); 
//               sql.append( "    ,APP_TAX_CODE      = ?                   \n");
//               sql.append( "    ,Z_ITEM_DESC       = ?                   \n");
//               sql.append( "    ,REMARK            = ?                   \n");
//               sql.append( "    ,ITEM_BLOCK_FLAG   = ?                   \n");
//               sql.append( "    ,MAKER_FLAG        = ?                   \n");
//               sql.append( "    ,MODEL_FLAG        = ?                   \n");
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
               throw new Exception("et_confirm_pp_upd3_getUpdate==========================================>"+e.getMessage());
           } finally{

           }
           return rtn;
       }
    
       private int et_confirm_pp_upd3_getUpdate1(String ITEM_NO,String[][] HeaderData2) throws Exception
       {

           int rtn = -1;

           ConnectionContext ctx = getConnectionContext();

           String sys_date = SepoaDate.getShortDateString();
           String sys_time = SepoaDate.getShortTimeString();
           String sort_seq = null;
           String[] type   = {"S","S","S","S","S","S","S","S","S","S"
           		              ,"S","S","S"    };
           try {

               //StringBuffer sql = new StringBuffer();
               SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
       		   wxp.addVar("ADD_DATE",    add_date);
       		   wxp.addVar("ADD_TIME",    add_time);
       		   wxp.addVar("USER_ID",     user_id);
       		   wxp.addVar("HOUSE_CODE",  house_code);
       		   wxp.addVar("ITEM_NO", ITEM_NO);

               // ICOMREHD 등록
//               sql.append( "UPDATE ICOMMTGL  SET                         \n");
//               sql.append( "    DESCRIPTION_LOC    = ?                   \n");
//               sql.append( "    ,MAKER_NAME        = ?                   \n");
//               sql.append( "    ,MAKER_CODE        = ?                   \n");
//               sql.append( "    ,MODEL_NO          = ?                   \n");
//               sql.append( "    ,BASIC_UNIT        = ?                   \n");
//               sql.append( "    ,MATERIAL_TYPE     = ?                   \n");
//               sql.append( "    ,MATERIAL_CTRL_TYPE= ?                   \n");
//               sql.append( "    ,MATERIAL_CLASS1   = ?                   \n"); 
//               sql.append( "    ,APP_TAX_CODE      = ?                   \n");
//               sql.append( "    ,Z_ITEM_DESC       = ?                   \n"); 
//               sql.append( "    ,ITEM_BLOCK_FLAG   = ?                   \n");
//               sql.append( "    ,MAKER_FLAG        = ?                   \n");
//               sql.append( "    ,MODEL_FLAG        = ?                   \n"); 
//               sql.append( "   ,CHANGE_DATE     = '"+add_date+"'        \n");
//               sql.append( "   ,CHANGE_TIME     = '"+add_time+"'        \n");
//               sql.append( "   ,CHANGE_USER_ID  = '"+user_id+"'         \n"); 
//               sql.append( "WHERE HOUSE_CODE =  '"+house_code+"'        \n");
//               sql.append( " AND ITEM_NO =  '"+ITEM_NO+"'       \n");
//               sql.append( " AND STATUS <>  'D'                         \n");

               SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx, wxp.getQuery());

               rtn = sm.doUpdate(HeaderData2, type);

           }catch(Exception e) {
               Rollback();
               throw new Exception("et_confirm_pp_upd3_getUpdate1==========================================>"+e.getMessage());
           } finally{

           }
           return rtn;
       }
       
       
       
    
}