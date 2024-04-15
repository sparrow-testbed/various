package sepoa.svc.admin;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.DBOpenException;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class AD_102 extends SepoaService
{
	//Message	msg	= new Message("FW");  // message 처리를	위해 전역변수 선언
	Message	msg	= null;

    public AD_102(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
        msg	= new Message(info, "MESSAGE");  // message 처리를	위해 전역변수 선언
        setVersion("1.0.0");
    }
	public String getConfig(String s)
	{
	    try
	    {
	        Configuration configuration = new Configuration();
	        s = configuration.get(s);
	        return s;
	    }
	    catch(ConfigurationException configurationexception)
	    {
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage());
	    }
	    catch(Exception exception)
	    {
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	    }
	    return null;
	}



	/**
	 * 회사정보 조회 메소드
	*  getMaintenance
	*  수정일 : 2013/02
	*/
    public sepoa.fw.srv.SepoaOut getMaintenance(Map< String, String > header){

        try{
        	String rtn = getMaintenace_ICOMCMGL(header);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0001"));
        }catch(Exception e){
            setStatus(0);
            setMessage(msg.getMessage("1002"));
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
        }
        return getSepoaOut();
    }

	/**
	 * 회사정보 조회 메소드
	*  getMaintenace_ICOMCMGL
	*  수정일 : 2013/02
	*/
    private String getMaintenace_ICOMCMGL(Map< String, String > header) throws Exception{

    	String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        try {
        	StringBuffer tSQL = new StringBuffer();
            tSQL.append( " SELECT COMPANY_CODE                   \n");
            tSQL.append( " , COMPANY_NAME_LOC                    \n");
            tSQL.append( " , COMPANY_NAME_ENG                    \n");
            tSQL.append( " , '' as HOUSE_CODE                          \n");
            tSQL.append( " FROM ICOMCMGL                         \n");
            tSQL.append( " where " + DB_NULL_FUNCTION + "(del_flag, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' \n ");

            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());

            rtn = sm.doSelect(new HashMap());
            if(rtn == null) throw new Exception("SQL Manager is Null");
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

	/**
	 * 회사정보 삭제 메소드
	*  setDelete
	*  수정일 : 2013/02
	*/
    public SepoaOut setDelete(List< Map<String, String>>gridData){


        try{
            int rtn = setDelete_Icomcmgl(gridData);
            if(rtn < 0)
				throw new Exception("UPDATE ICOMCMGL ERROR");

			Commit();
			setStatus(1);
			setMessage(msg.getMessage("0001"));

		}catch(Exception e){
			try
            {
                Rollback();
            }
            catch(Exception d)
            {
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            setStatus(0);
            setMessage(msg.getMessage("1002"));
		}

        return getSepoaOut();
    }
    
    
	/**
	 * 회사정보 삭제 메소드
	*  setDelete_Icomcmgl
	*  수정일 : 2013/02
	*/
    private int setDelete_Icomcmgl(List< Map<String, String>>gridData) throws Exception{

        int rtn = -1;
     	ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();
		Map<String,String> grid = null;
		String user_id=info.getSession("ID");
        String date = SepoaDate.getShortDateString();
        String time = SepoaDate.getShortTimeString();
		
        try {
         
            StringBuffer tSQL = new StringBuffer();
            ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
            for (int i = 0; i<gridData.size(); i++) {
            	 grid=(Map <String , String>) gridData.get(i);

            grid=(Map <String , String>) gridData.get(0);

            tSQL.append( " UPDATE ICOMCMGL SET 				\n");
			tSQL.append( " 	del_flag = '" + sepoa.fw.util.CommonUtil.Flag.Yes.getValue() + "', 					\n");
            tSQL.append( "  CHANGE_USER_ID = ?, 			\n");sm.addStringParameter(user_id);
            tSQL.append( "  CHANGE_DATE = ?,				\n");sm.addStringParameter(date);
            tSQL.append( "  CHANGE_TIME = ? 				\n");sm.addStringParameter(time);
            tSQL.append( " WHERE " + DB_NULL_FUNCTION + "(del_flag, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "' 			\n");
            tSQL.append( " 	AND COMPANY_CODE = ?  			\n");sm.addStringParameter(MapUtils.getString(grid, "COMPANY_CODE", ""));

            rtn=sm.doUpdate(tSQL.toString());
            }
            if(rtn == -1) throw new Exception("SQL Manager is Null");
            else Commit();
        }catch(DBOpenException e) {
                Rollback();
                throw new Exception("et_setInsert:"+e.getMessage());

        }

    return rtn;
    }

	/**
	 * 회사정보 등록 메소드
	*  setInsert
	*  수정일 : 2013/02
	*/
    public SepoaOut setInsert(Map< String, Object > allData){
    	
    	 Map< String, String >   headerData  = null;
         
        
        try
        {
        	//allData = SepoaDataMapper.getData( info, gdReq );
            headerData = MapUtils.getMap( allData, "headerData" );
            msg = new Message(info, "MESSAGE");
            
            headerData.put( "FOUNDATION_DATE", SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "FOUNDATION_DATE", "" ) ) );
            
            int rtn = et_setInsert(headerData);;
            int rtn2 = et_setInsert2(headerData);;
            
            setValue("Insert Row=" + rtn);
            setStatus(1);
            setMessage(msg.getMessage("0001"));
        }catch(Exception e)
        {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("1002"));
            Logger.err.println(this,e.getMessage());
            //log err
        }
        return getSepoaOut();
    } //setInsert() end
    
	/**
	 * 공장정보 등록 메소드
	*  et_setInsert
	*  수정일 : 2013/02
	*/
    private int et_setInsert(Map< String, String > header)throws Exception, DBOpenException {
  
    	int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String user_id=info.getSession("ID");
        String date = SepoaDate.getShortDateString();
        String time = SepoaDate.getShortTimeString();
        try {
        	    ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
                StringBuffer tSQL = new StringBuffer();

                tSQL.append("   INSERT INTO ICOMCMGL                 \n");
                tSQL.append("   (                                 \n");
                tSQL.append("   	  HOUSE_CODE                \n");
                tSQL.append("   	, COMPANY_CODE                \n");
                tSQL.append("   	, LANGUAGE                    \n");
                tSQL.append("   	, COMPANY_NAME_LOC            \n");
                tSQL.append("   	, COMPANY_NAME_ENG            \n");
                tSQL.append("   	, CUR                         \n");
                tSQL.append("   	, COUNTRY                     \n");
                tSQL.append("   	, CITY_CODE                   \n");
                tSQL.append("   	, IRS_NO                      \n"); 
                tSQL.append("   	, DUNS_NO                     \n");
                tSQL.append("   	, FOUNDATION_DATE             \n"); 
                //tSQL.append("   	, GROUP_COMPANY_CODE          \n"); 
                //tSQL.append("   	, GROUP_COMPANY_NAME       	  \n"); 
                tSQL.append("   	, CREDIT_RATING               \n");
                tSQL.append("   	, INDUSTRY_TYPE               \n");
                tSQL.append("   	, BUSINESS_TYPE               \n");
                tSQL.append("   	, TRADE_REG_NO                \n");
                tSQL.append("   	, TRADE_AGENCY_NO             \n");
                tSQL.append("   	, TRADE_AGENCY_NAME           \n");
                tSQL.append("   	, EDI_ID                      \n");
                tSQL.append("   	, EDI_QUALIFIER               \n");
                tSQL.append("   	, ADD_USER_ID                 \n");
                tSQL.append("   	, DEL_FLAG                    \n");
                tSQL.append("   	, ADD_DATE                    \n");
                tSQL.append("   	, ADD_TIME                    \n");
                tSQL.append("   	, ACCOUNT_CODE_SEPARATE       \n"); 
                tSQL.append("   	, INS_COM_CODE                \n");
                tSQL.append("   	, JIKIN_ATTACH_NO             \n");
                tSQL.append("   )                                 \n");
                tSQL.append("   VALUES                            \n");
                tSQL.append("   (                                 \n");
                tSQL.append("   	  ?                           \n");sm.addStringParameter(info.getSession("HOUSE_CODE"));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_CODE", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "LANGUAGE", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_NAME_LOC", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_NAME_ENG", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "CUR", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "COUNTRY", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "CITY_CODE", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "IRS_NO", "")); // 사업자 등록번호
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "DUNS_NO", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "FOUNDATION_DATE", ""));
                //tSQL.append("   	, ?                           \n");sm.addStringParameter(""); //???????
                //tSQL.append("   	, ?                           \n");sm.addStringParameter(""); //???????
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "CREDIT_RATING", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "INDUSTRY_TYPE", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "BUSINESS_TYPE", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "TRADING_REG_NO", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "TRADE_AGENCY_NO", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "TRADE_AGENCY_NAME", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "EDI_ID", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "EDI_QUALIFIER", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(user_id);
                tSQL.append("   	, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                         \n");
                tSQL.append("   	, ?                           \n");sm.addStringParameter(date);
                tSQL.append("   	, ?                           \n");sm.addStringParameter(time);
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "ACCOUNT_CIDE_SEPARATE", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "ins_com_code", ""));
                tSQL.append("   	, ?                           \n");sm.addStringParameter(MapUtils.getString(header, "JIKIN_ATTACH_NO", ""));
                tSQL.append("   )                                 \n");

                rtn=sm.doInsert(tSQL.toString());
                if(rtn == -1) throw new Exception("SQL Manager is Null");
                else Commit();
            }catch(DBOpenException e) {
                    Rollback();
                    throw new Exception("et_setInsert:"+e.getMessage());

            }

        return rtn;
    } //et_setInsert () end

	/**
	 * 공장정보 등록 메소드2
	*  et_setInsert2
	*  수정일 : 2013/02
	*/
    private int et_setInsert2(Map< String, String > header) throws Exception {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();

			tSQL.append("   INSERT INTO icomaddr              	    \n");
			tSQL.append("   (                                 	\n");
			tSQL.append("   	  HOUSE_CODE                	\n");
			tSQL.append("   	, CODE_NO                		\n");
			tSQL.append("   	, CODE_TYPE                    	\n");
			tSQL.append("   	, ADDRESS_LOC              		\n");
			tSQL.append("   	, ADDRESS_ENG              		\n");
			tSQL.append("   	, ZIP_CODE                 		\n");
			tSQL.append("   	, PHONE_NO1                 	\n");
			tSQL.append("   	, HOMEPAGE                 		\n");
			tSQL.append("   	, CEO_NAME_LOC                 	\n");
			tSQL.append("   )                                 	\n");
			tSQL.append("   VALUES                            	\n");
			tSQL.append("   (                                 	\n");
			tSQL.append("   	  ?                           	\n");sm.addStringParameter(info.getSession("HOUSE_CODE"));
			tSQL.append("   	, ?                           	\n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_CODE", ""));
			tSQL.append("   	, '1'                           \n");
			tSQL.append("   	, ?                           	\n");sm.addStringParameter(MapUtils.getString(header, "ADDRESS_LOC", ""));
			tSQL.append("   	, ?                           	\n");sm.addStringParameter(MapUtils.getString(header, "ADDRESS_ENG", ""));
			tSQL.append("   	, ?                           	\n");sm.addStringParameter(MapUtils.getString(header, "ZIP_CODE", ""));
			tSQL.append("   	, ?                           	\n");sm.addStringParameter(SepoaString.encString ( MapUtils.getString(header, "PHONE_NO", "") ,"PHONE"));
			tSQL.append("   	, ?                           	\n");sm.addStringParameter(MapUtils.getString(header, "HOMPAGE", ""));
			tSQL.append("   	, ?                           	\n");sm.addStringParameter(MapUtils.getString(header, "CEO_NAME", ""));
			tSQL.append("   )                                 	\n");

			  rtn=sm.doInsert(tSQL.toString());
			if(rtn == -1) throw new Exception("SQL Manager is Null");
			else Commit();
		}catch(DBOpenException e) {
		   Rollback();
		   throw new Exception("et_setInsert:"+e.getMessage());
		}

		return rtn;
	} //et_setInsert2() end
    
	//회사별프로세스 관리
     //KCTECH

     public sepoa.fw.srv.SepoaOut getDis2(String[] args){

        try
        {
            Message msg = new Message(info, "MESSAGE");
            String user_id = info.getSession("ID");
            String rtn = null;
            // Isvalue(); ....
            rtn = getDis2_ICOMCMGL(args, user_id);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0001"));
        }catch(Exception e)
        {
            setStatus(0);
            Message msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("1002"));
            Logger.err.println(this,e.getMessage());
        }
          return getSepoaOut();
    }
    private String getDis2_ICOMCMGL(String[] args, String user_id)
    throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( " SELECT                           														\n");
			tSQL.append( "  Z_EMAIL_SEND_FLAG               														\n");
			tSQL.append( "  , Z_SMS_SEND_FLAG               														\n");
            tSQL.append( "  , Z_MOLDING_AM_FLAG             														\n");
            tSQL.append( "  , Z_WORK_STAGE_FLAG             														\n");
            tSQL.append( "  , Z_DELIVERY_CONFIRM_FLAG       														\n");
            tSQL.append( "  , Z_ECREDIT_LINK_FLAG           														\n");
            tSQL.append( "  , Z_ECREDIT_URL                 														\n");
            tSQL.append( "  , Z_ECREDIT_ID                  														\n");
            tSQL.append( "  , Z_ECREDIT_PW                  														\n");
            tSQL.append( "  , Z_GR_TYPE                     														\n");
            tSQL.append( "  , Z_CODE1                 																\n");
            tSQL.append( "  , Z_CODE2                       														\n");
            tSQL.append( "  , Z_CODE3                       														\n");
            tSQL.append( "  , Z_CODE4                       														\n");
            tSQL.append( "  , Z_CLAIM_RATE   																		\n");
            tSQL.append( "  , GETICOMCODE(HOUSE_CODE,'M601',Z_AUTO_PO_TYPE,'TEXT1') AS Z_AUTO_PO_TYPE			   	\n");
            tSQL.append( "  , GETICOMCODE(HOUSE_CODE,'M601',Z_AUTO_PO_TYPE,'TEXT2') AS Z_AUTO_PO_TEXT			   	\n");
            tSQL.append( " FROM ICOMCMGL          \n");
            tSQL.append( " WHERE DEL_FLAG = ? </OPT> \n");
            tSQL.append( " <OPT=F,S> AND COMPANY_CODE = ? </OPT> \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
            rtn = sm.doSelect(args);
            if(rtn == null) throw new Exception("SQL Manager is Null");
            }catch(Exception e) {
                throw new Exception("getDis2_ICOMCMGL:"+e.getMessage());
            } finally{
            //Release();
        }
        return rtn;
    }
 	// company's process Z update
    public SepoaOut setZupdate(String[][] args){

        try
        {
            Message msg = new Message(info, "MESSAGE");

            int rtn = setZupdate_Icomcmgl(args);
            if(rtn == -1)
            {
                setValue(String.valueOf(rtn));
                setStatus(0);
                setMessage(msg.getMessage("1002"));
            }
            else if(rtn == 1 ){
                setValue(String.valueOf(rtn));
                setStatus(1);
                setMessage(msg.getMessage("0001"));
            }

        }catch(Exception e){
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            Message msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("1002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }
    private int setZupdate_Icomcmgl(String[][] str) throws Exception{
        int rtn = -1;
        try {
                String[] setType = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S",
                                    "S", "S", "S", "S", "S", "S","S","S"};

                StringBuffer tSQL = new StringBuffer();
                ConnectionContext ctx = getConnectionContext();

                tSQL.append("   UPDATE ICOMCMGL SET                            \n");
                tSQL.append("   	  Z_EMAIL_SEND_FLAG = ?                             \n");
                tSQL.append("   	, Z_SMS_SEND_FLAG = ?                     \n");
                tSQL.append("   	, Z_MOLDING_AM_FLAG = ?                     \n");
                tSQL.append("   	, Z_WORK_STAGE_FLAG = ?                                  \n");
                tSQL.append("   	, Z_DELIVERY_CONFIRM_FLAG = ?                              \n");
                tSQL.append("   	, Z_ECREDIT_LINK_FLAG = ?                            \n");
                tSQL.append("   	, Z_ECREDIT_URL = ?                               \n");
                tSQL.append("   	, Z_ECREDIT_ID = ?                              \n");
                tSQL.append("   	, Z_ECREDIT_PW = ?                      \n");
                tSQL.append("   	, Z_GR_TYPE = ?                   \n");
                tSQL.append("   	, Z_CODE1 = ?                   \n");
                tSQL.append("   	, Z_CODE2 = ?                        \n");
                tSQL.append("   	, Z_CODE3 = ?                        \n");
                tSQL.append("   	, Z_CODE4 = ?                        \n");
                tSQL.append("		, Z_AUTO_PO_TYPE = ?						\n");
                tSQL.append("		, Z_CLAIM_RATE = ?						   \n");
                tSQL.append("   WHERE HOUSE_CODE = ?                           \n");
                tSQL.append("   AND COMPANY_CODE = ?                           \n");

                SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());
                rtn = sm.doInsert(str, setType);
                Logger.err.println("rtn =" + rtn);
                if(rtn == -1) {

                                return rtn;
                              }
                else {
                        Commit();

                        }
            }catch(Exception e) {
                    Rollback();
                    throw new Exception("setZupdate_Icomcmgl:"+e.getMessage());
            }
        return rtn;
    }


    // icomcmgl display..... 회사단위 수정을 위한 조회
    public sepoa.fw.srv.SepoaOut getDis(String[] args){

        try
        {
            Message msg = new Message(info, "MESSAGE");
            String user_id = info.getSession("ID");
            String rtn = null;
            // Isvalue(); ....
            rtn = getDis_ICOMCMGL(args, user_id);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0001"));
        }catch(Exception e)
        {
            setStatus(0);
            Message msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("1002"));
            Logger.err.println(this,e.getMessage());
        }
          return getSepoaOut();
    }
    private String getDis_ICOMCMGL(String[] args, String user_id)
    throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( " SELECT                           \n");
			tSQL.append( "  LANGUAGE                        \n");
			tSQL.append( "  , " + SEPOA_DB_OWNER + "GETCODETEXT2('M013', LANGUAGE, '" + info.getSession("LANGUAGE") + "' ) LANGUAGE_NAME  \n");
            tSQL.append( "  , COMPANY_NAME_LOC              \n");
            tSQL.append( "  , COMPANY_NAME_ENG              \n");
            tSQL.append( "  , CUR                           \n");
            tSQL.append( "  , COUNTRY                       \n");
            tSQL.append( "  , " + SEPOA_DB_OWNER + "GETCODETEXT2('M001', COUNTRY, '" + info.getSession("LANGUAGE") + "' ) COUNTRY_NAME  \n");
            //tSQL.append( "  , COUNTRY_NAME                  \n");
            tSQL.append( "  , CITY_CODE                     \n");
            tSQL.append( "  , CITY_CODE_NAME                \n");
            tSQL.append( "  , ADDRESS_LOC                   \n");
            tSQL.append( "  , ADDRESS_ENG                   \n");
            tSQL.append( "  , ZIP_CODE                      \n");
            tSQL.append( "  , PHONE_NO                      \n");
            tSQL.append( "  , IRS_NO                        \n");
            tSQL.append( "  , DUNS_NO                       \n");
            tSQL.append( "  , HOMEPAGE                      \n");
            tSQL.append( "  , FOUNDATION_DATE               \n");
            tSQL.append( "  , GROUP_COMPANY_CODE            \n");
            tSQL.append( "  , GROUP_COMPANY_NAME            \n");
            tSQL.append( "  , CREDIT_RATING                 \n");
            tSQL.append( "  , INDUSTRY_TYPE                 \n");
            tSQL.append( "  , INDUSTRY_TYPE_NAME            \n");
            tSQL.append( "  , CEO_NAME                      \n");
            tSQL.append( "  , BUSINESS_TYPE                 \n");
            tSQL.append( "  , TRADE_REG_NO                  \n");
            tSQL.append( "  , ACCOUNT_CODE_SEPARATE         \n");
            tSQL.append( "  , TRADE_AGENCY_NO               \n");
            tSQL.append( "  , TRADE_AGENCY_NAME             \n");
            tSQL.append( "  , EDI_ID                        \n");
            tSQL.append( "  , EDI_QUALIFIER                 \n");
            tSQL.append( "  , INS_COM_CODE                  \n");
            tSQL.append( "  , INS_COM_CODE_NAME             \n");
//          tSQL.append( "  , '' JIKIN_ATTACH_NO            \n");
//          tSQL.append( "  , '' JIKIN_ATTACH_NO_COUNT      \n");
            tSQL.append( " FROM COMPANY_GENERAL_VW          \n");
            tSQL.append( " <OPT=F,S> WHERE COMPANY_CODE = ?  </OPT> \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
            rtn = sm.doSelect(args);
            if(rtn == null) throw new Exception("SQL Manager is Null");
            }catch(Exception e) {
                throw new Exception("getDis_ICOMCMGL:"+e.getMessage());
            } finally{
            //Release();
        }
        return rtn;
    }

 // company update
    public SepoaOut setUpdate(Map< String, Object > allData){

    	 Map< String, String >   headerData  = null;
        try
        {
            //Message msg = new Message(info, "MESSAGE");
            headerData = MapUtils.getMap( allData, "headerData" );
            
            headerData.put( "FOUNDATION_DATE" , SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "FOUNDATION_DATE", "" ) ) );

            int rtn = setUpdate_Icomcmgl(headerData);
            if(rtn == -1)
            {
                setValue(String.valueOf(rtn));
                setStatus(0);
                setMessage(msg.getMessage("1002"));
            }
            else
            {
            	int rtn2 = setUpdate_Icomaddr(headerData);
            	if(rtn2 == -1){
                    setValue(String.valueOf(rtn));
                    setStatus(0);
                    setMessage(msg.getMessage("1002"));
                }else{
                	setValue(String.valueOf(rtn));
                	setStatus(1);
                	setMessage(msg.getMessage("0001"));
                }
            }

        }catch(Exception e){
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            Message msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("1002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }
    private int setUpdate_Icomcmgl(Map< String, String > header) throws Exception{
        
   	 int rtn = -1;
   	 ConnectionContext ctx = getConnectionContext();
        String user_id=info.getSession("ID");
        String date = SepoaDate.getShortDateString();
        String time = SepoaDate.getShortTimeString();
       try {

	        	ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
	            StringBuffer tSQL = new StringBuffer();

               tSQL.append("   UPDATE ICOMCMGL SET                            	 	\n");
               tSQL.append("   	  LANGUAGE = ?                            	\n");sm.addStringParameter(MapUtils.getString(header, "LANGUAGE", ""));
               tSQL.append("   	, COMPANY_NAME_LOC = ?               	\n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_NAME_LOC", ""));
               tSQL.append("   	, COMPANY_NAME_ENG = ?               	\n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_NAME_ENG", ""));
               tSQL.append("   	, CUR = ?                                  		\n");sm.addStringParameter(MapUtils.getString(header, "CUR", ""));
               tSQL.append("   	, COUNTRY = ?                              	\n");sm.addStringParameter(MapUtils.getString(header, "COUNTRY", ""));
               tSQL.append("   	, CITY_CODE = ?                            		\n");sm.addStringParameter(MapUtils.getString(header, "CITY_CODE", ""));
               tSQL.append("   	, IRS_NO = ?                               		\n");sm.addStringParameter(MapUtils.getString(header, "IRS_NO", ""));
               tSQL.append("   	, DUNS_NO = ?                              	\n");sm.addStringParameter(MapUtils.getString(header, "DUNS_NO", ""));
               tSQL.append("   	, FOUNDATION_DATE = ?                     \n");sm.addStringParameter(MapUtils.getString(header, "FOUNDATION_DATE", ""));
               //tSQL.append("   	, GROUP_COMPANY_CODE = ?               \n");sm.addStringParameter("");
               //tSQL.append("   	, GROUP_COMPANY_NAME = ?              \n");sm.addStringParameter("");
               tSQL.append("   	, CREDIT_RATING = ?                        	\n");sm.addStringParameter(MapUtils.getString(header, "CREDIT_RATING", ""));
               tSQL.append("   	, INDUSTRY_TYPE = ?                        	\n");sm.addStringParameter(MapUtils.getString(header, "INDUSTRY_TYPE", ""));
               tSQL.append("   	, BUSINESS_TYPE = ?                        	\n");sm.addStringParameter(MapUtils.getString(header, "BUSINESS_TYPE", ""));
               tSQL.append("   	, TRADE_REG_NO = ?                         	\n");sm.addStringParameter(MapUtils.getString(header, "TRADING_REG_NO", ""));

               tSQL.append("   	, TRADE_AGENCY_NO =?                       \n");sm.addStringParameter(MapUtils.getString(header, "TRADE_AGENCY_NO", ""));
               tSQL.append("   	, TRADE_AGENCY_NAME = ?                    \n");sm.addStringParameter(MapUtils.getString(header, "TRADE_AGENCY_NO", ""));
               tSQL.append("   	, EDI_ID = ?                               \n");sm.addStringParameter(MapUtils.getString(header, "EDI_ID", ""));
               tSQL.append("   	, EDI_QUALIFIER = ?                        \n");sm.addStringParameter(MapUtils.getString(header, "EDI_QUALIFIER", ""));
            
               tSQL.append("   	, CHANGE_USER_ID = ?                    \n");sm.addStringParameter(user_id);
               tSQL.append("   	, del_flag = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'                				\n");
               tSQL.append("   	, CHANGE_DATE = ?      					\n");sm.addStringParameter(date);
               tSQL.append("   	, CHANGE_TIME = ?      					\n");sm.addStringParameter(time);
               //tSQL.append("   	, ACCOUNT_CODE_SEPARATE = ?        \n");sm.addStringParameter(MapUtils.getString(header, "ACCOUNT_NO_SEPARATE", ""));
               //tSQL.append("   	, INS_COM_CODE = ?                      \n");sm.addStringParameter(MapUtils.getString(header, "INS_COM_CODE", ""));
               
//             tSQL.append("   	, JIKIN_ATTACH_NO = ?                   \n");sm.addStringParameter(MapUtils.getString(header, "JIKIN_ATTACH_NO", ""));
               
               tSQL.append("   WHERE " + DB_NULL_FUNCTION + "(del_flag, '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "') = '" + sepoa.fw.util.CommonUtil.Flag.No.getValue() + "'	           \n");

               tSQL.append("   AND COMPANY_CODE = ?                           \n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_CODE", ""));

               rtn=sm.doInsert(tSQL.toString());

               if(rtn == -1) throw new Exception("SQL Manager is Null");
               else Commit();
           }catch(DBOpenException e) {
                   Rollback();
                   throw new Exception("setUpdate_Icomcmgl:"+e.getMessage());

           }

       return rtn;
   }

    private int setUpdate_Icomaddr(Map< String, String > header) throws Exception{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
		
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			StringBuffer tSQL = new StringBuffer();
			

			tSQL.append("   UPDATE icomaddr SET                   \n");
			tSQL.append("   	  ADDRESS_LOC 	= ?            \n");sm.addStringParameter(MapUtils.getString(header, "ADDRESS_LOC", ""));
			tSQL.append("   	, ADDRESS_ENG 	= ?            \n");sm.addStringParameter(MapUtils.getString(header, "ADDRESS_ENG", ""));
			tSQL.append("   	, ZIP_CODE 		= ?            \n");sm.addStringParameter(MapUtils.getString(header, "ZIP_CODE", ""));
			tSQL.append("   	, PHONE_NO1 	= ?            \n");sm.addStringParameter(SepoaString.encString ( MapUtils.getString(header, "PHONE_NO", "") ,"PHONE"));
			tSQL.append("   	, HOMEPAGE 		= ?            \n");sm.addStringParameter(MapUtils.getString(header, "HOMPAGE", ""));
			tSQL.append("   	, CEO_NAME_LOC 	= ?            \n");sm.addStringParameter(MapUtils.getString(header, "CEO_NAME", ""));
			tSQL.append("   WHERE  CODE_NO 		= ?            \n");sm.addStringParameter(MapUtils.getString(header, "COMPANY_CODE", ""));
			tSQL.append("   	AND CODE_TYPE 	= ?            \n");sm.addStringParameter("1");

            rtn=sm.doInsert(tSQL.toString());
            if(rtn == -1) throw new Exception("SQL Manager is Null");
            else Commit();
        }catch(DBOpenException e) {
                Rollback();
                throw new Exception("setUpdate_Icomcmgl:"+e.getMessage());

        }

    return rtn;
	}

/* 중복체크 */

    public SepoaOut getDuplicate(String[] args){
        Message msg = new Message(info, "MESSAGE");
        String user_id = info.getSession("ID");
        String rtn = null;
        try
        {
            Logger.debug.println(user_id,this,"######getDuplicate#######");
            // Isvalue(); ....
            rtn = String.valueOf(Check_Duplicate(args, user_id));
            Logger.debug.println(user_id,this,"duplicate-result= ===>"+rtn);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0001"));
        }catch(Exception e)
        {
            setStatus(0);
            setMessage(msg.getMessage("1002"));
            Logger.err.println(user_id,this,"Exception e =" + e.getMessage());
        }
          return getSepoaOut();
    }
    private int Check_Duplicate(String[] args, String user_id) throws Exception
    {
        String rtn = null;
        int count = 0;
        String[][] str = new String[1][2];

        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( " SELECT                                \n");
            tSQL.append( "  COUNT(*)                             \n");
            tSQL.append( " FROM ICOMCMGL                         	 \n");
            tSQL.append( " WHERE <OPT=F,S> COMPANY_CODE = ? </OPT> \n");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

            //String[] args = {house_code, company_code,operating_code};
            rtn = sm.doSelect(args);
            SepoaFormater wf = new SepoaFormater(rtn);
            str = wf.getValue();
            count = Integer.parseInt(str[0][0]);
            
            if(count > 0){
            	return count;
            }else{
            
	            tSQL.delete(0, tSQL.length());
	            tSQL.append( " SELECT                                \n");
	            tSQL.append( "  COUNT(*)                             \n");
	            tSQL.append( " FROM icomaddr                         	 \n");
	            tSQL.append( " WHERE <OPT=F,S> CODE_NO = ? </OPT> 	 \n");
	            tSQL.append( "   AND CODE_TYPE = '1' 				 \n");
	
	            sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
	
	            rtn = sm.doSelect(args);
	            SepoaFormater wf2 = new SepoaFormater(rtn);
	            str = wf2.getValue();
	            count = Integer.parseInt(str[0][0]);
            }

            if(rtn == null) throw new Exception("SQL Manager is Null");
            }catch(Exception e) {
                throw new Exception("Check_Duplicate:"+e.getMessage());
            } finally{
            //Release();
        }
        return count;
    }


/***** icomcmpt , company 에 partner 등록 *****/


    public sepoa.fw.srv.SepoaOut getMainternace_icomcmpt(String company_code){

        try
        {
            String user_id = info.getSession("ID");
            Logger.debug.println(user_id,this,"######getMaintenance_icomcmpt#######");
            String rtn = null;
            // Isvalue(); ....
            rtn = getMainternace_icomcmpt(user_id,company_code);

            Logger.debug.println("result"+rtn);

            setValue(rtn);
            setStatus(1);
            Message msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("0001"));
        }catch(Exception e)
        {
            setStatus(0);
            Message msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("1002"));
            Logger.err.println(this,e.getMessage());
            //log err
        }
          //return getValue();
          return getSepoaOut();
    }
    private String getMainternace_icomcmpt(String user_id, String company_code)
    throws Exception
    {
        String rtn = null;
        String house_code = info.getSession("HOUSE_CODE");
        ConnectionContext ctx = getConnectionContext();
        try {
            StringBuffer tSQL = new StringBuffer();

            tSQL.append( " select b.text2, a.partner_code,a.name_loc,a.name_eng ");
            tSQL.append( " from  icomcmpt a , icomcode b ");
            tSQL.append( " where a.house_code = '"+house_code+"'  ");
            tSQL.append( " <OPT=F,S> and company_code = ? </OPT> ");
            tSQL.append( " and a.status != 'D' and b.type ='M036' and a.house_code = b.house_code ");
            tSQL.append( " and a.partner_type = b.code ");

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

            String[] args = {company_code};
            rtn = sm.doSelect(args);
            if(rtn == null) throw new Exception("SQL Manager is Null");
            }catch(Exception e) {
                throw new Exception("getMaintenance_icomcmpt:"+e.getMessage());
            } finally{
            //Release();
        }
        return rtn;
    }



        /* 생성버튼을 누르면 테이블에 입력했던 값들을 DB에 넣어준다. */
    public SepoaOut setInsert_icomcmpt(String[][] args) {
        int rtn = -1;
        String status = "C";
        String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
        String add_date = SepoaDate.getShortDateString();
        String add_time = SepoaDate.getShortTimeString();
        Message msg = new Message(info, "MESSAGE");
        try {
            rtn = setInsert_icomcmpt(args, status, user_id, add_date, add_time, house_code);
            setValue("insertRow ==  " + rtn);
            setStatus(1);

            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
        }catch(Exception e) {
            setStatus(0);
            setMessage(msg.getMessage("1002"));  /* Message를 등록한다. */
        }
        return getSepoaOut();
    }

    private int setInsert_icomcmpt(String[][] args, String status, String user_id, String add_date, String add_time, String house_code) throws Exception, DBOpenException {
        int result =-1;
        String[] settype={"S","S","S","S","S"};
        ConnectionContext ctx = getConnectionContext();

        String user_name_loc = info.getSession("NAME_LOC");
        String user_name_eng = info.getSession("NAME_ENG");
        String user_dept = info.getSession("DEPARTMENT");


        try {
            StringBuffer tSQL = new StringBuffer();
            tSQL.append(" insert into icomcmpt (");
            tSQL.append(" company_code,partner_code,partner_type,name_loc,name_eng, status,add_date, add_time,  add_user_id, add_user_name_loc ,add_user_name_eng,add_user_dept ) ");
            tSQL.append(" values( ?, ?, ?, ?, ?,  'N',  '"+add_date+"', ");
            tSQL.append(" '"+add_time+"', '"+user_id+"' , '"+user_name_loc+"', '"+user_name_eng+"','"+user_dept+"'  ) ");

            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
            result = sm.doInsert(args,settype);
            Commit();
        }catch(Exception e) {
            Rollback();
            throw new Exception("et_co3_setInsert: " + e.getMessage());
        }
        return result;
    }

/** 삭제 **/


    public SepoaOut setDelete_icomcmpt(String[][] args){

        try
        {
            Message msg = new Message(info, "MESSAGE");
            String user_id = info.getSession("ID");
            Logger.debug.println(user_id,this,"######Delete#######");

            int rtn = setDelete_icomcmpt(args, user_id);
            if(rtn == -1)
            {
                // 한건도 없다는 말이네요....
                setValue(String.valueOf(rtn));
                setStatus(0);
                setMessage(msg.getMessage("1002"));
                //Logger.err.println(this,msg.getCode() +":"+msg.toString());
            }
            else
            {
                setValue(String.valueOf(rtn));
                setStatus(1);
                setMessage(msg.getMessage("0001"));
            }

        }catch(Exception e)
        {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            Message msg = new Message(info, "MESSAGE");
            setMessage(msg.getMessage("1002"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }
    private int setDelete_icomcmpt(String[][] args,String user_id) throws Exception, DBOpenException
    {
        int rtn = -1;
        String house_code = info.getSession("HOUSE_CODE");


        try {
                String[] setType = {"S", "S"};
                StringBuffer tSQL = new StringBuffer();
                ConnectionContext ctx = getConnectionContext();

                tSQL.append( " delete from icomcmpt ");
                tSQL.append( " WHERE house_code = '"+ house_code +"' and company_code = ? and partner_code = ? ");


                SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
                rtn = sm.doDelete(args, setType);
                if(rtn == -1) {
                                return rtn;
                              }
                else {
                        Commit();
                        }
            }catch(Exception e) {
                    Rollback();
                    throw new Exception("setDelete_Icomcmgl:"+e.getMessage());
            }
        return rtn;
    }



}
