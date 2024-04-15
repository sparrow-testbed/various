package sepoa.svc.contract;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

public class MAN_001 extends SepoaService {
	private String ID = info.getSession("ID");
	private Message msg;

	public MAN_001(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
		msg = new Message(info, "PO_002_BEAN");
	}

	public String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			s = configuration.get(s);

			return s;
		} catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : "
					+ configurationexception.getMessage());
		} catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}

		return null;
	}

	
	public SepoaOut getContractInsert(Map< String, Object > allData) throws Exception {
		ConnectionContext         ctx          = getConnectionContext();
		 SepoaXmlParser            sxp          = null;
		 SepoaSQLManager           ssm          = null;
		 String                    id           = info.getSession("ID");
		 Map<String, String> 	   header       = null;
		 int                       rtn          = 0;
	        
		 
		 try{
			 //setStatus(1);
			 setFlag(true);
			 header  = MapUtils.getMap( allData, "headerData" );
    		  
			 String cont_no = "";
			 SepoaOut wo = null;
			 wo = DocumentUtil.getDocNumber(info, "CP");
			 cont_no = wo.result[0];
			 header.put("cont_no",        cont_no);
			 header.put("ctrl_code",      info.getSession("CTRL_CODE"));
			 header.put("company_code",   info.getSession("COMPANY_CODE"));
			 header.put("add_user_id",    info.getSession("ID"));
			 header.put("add_date",       SepoaDate.getShortDateString());
			 header.put("add_time",       SepoaDate.getShortTimeString());
			 header.put("change_user_id", info.getSession("ID"));
			 header.put("change_date",    SepoaDate.getShortDateString());
			 header.put("change_time",    SepoaDate.getShortTimeString());
			 header.put("cont_date"	, header.get("cont_date").replaceAll("\\/", ""));
			 header.put("app_date"	, header.get("app_date").replaceAll("\\/", ""));
			 header.put("pr_date"	, header.get("pr_date").replaceAll("\\/", ""));
			 header.put("pay_date"	, header.get("pay_date").replaceAll("\\/", ""));
			 header.put("app_amt"	, header.get("app_amt").replaceAll("\\,", ""));
			 header.put("budget_amt"	, header.get("budget_amt").replaceAll("\\,", ""));
			 header.put("in_price_amt"	, header.get("in_price_amt").replaceAll("\\,", ""));
			 header.put("be_price_amt"	, header.get("be_price_amt").replaceAll("\\,", ""));
			 sxp = new SepoaXmlParser(this, "getContractInsert");
    		 ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			 rtn = ssm.doInsert(header);
			 if ( rtn < 0 ){
				 setMessage("비정상적으로 처리되었습니다.");
				 setStatus( 0 );				 
			 }else{
				 setMessage("[ 계약번호 : "+ cont_no + " ] 성공적으로 처리하였습니다.");
				 setValue(cont_no);
				 setStatus( 1 );			
			 }			 
			 Commit();
		 }catch(Exception e){
			 Rollback();
			 setStatus(0);
			 setFlag(false);
			 setMessage(e.getMessage());
			 Logger.err.println(info.getSession("ID"), this, e.getMessage());
		 }
		 finally {}
		 return getSepoaOut();
	}
	
	public SepoaOut getContractUpdate(Map< String, Object > allData) throws Exception {
		ConnectionContext         ctx          = getConnectionContext();
		 SepoaXmlParser            sxp          = null;
		 SepoaSQLManager           ssm          = null;
		 String                    id           = info.getSession("ID");
		 Map<String, String> 	   header       = null;
		 int                       rtn          = 0;
	        
		 
		 try{
			 setStatus(1);
			 setFlag(true);
			 header  = MapUtils.getMap( allData, "headerData" );
    		  
			 String cont_no = header.get("cont_no");
			 header.put("change_user_id", info.getSession("ID"));
			 header.put("change_date",    SepoaDate.getShortDateString());
			 header.put("change_time",    SepoaDate.getShortTimeString());
			 header.put("cont_date"	, header.get("cont_date").replaceAll("\\/", ""));
			 header.put("app_date"	, header.get("app_date").replaceAll("\\/", ""));
			 header.put("pr_date"	, header.get("pr_date").replaceAll("\\/", ""));
			 header.put("pay_date"	, header.get("pay_date").replaceAll("\\/", ""));
			 header.put("app_amt"	, header.get("app_amt").replaceAll("\\,", ""));
			 header.put("budget_amt"	, header.get("budget_amt").replaceAll("\\,", ""));
			 header.put("in_price_amt"	, header.get("in_price_amt").replaceAll("\\,", ""));
			 header.put("be_price_amt"	, header.get("be_price_amt").replaceAll("\\,", ""));
			 sxp = new SepoaXmlParser(this, "getContractUpdate");
    		 ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			 rtn = ssm.doInsert(header);
			 if ( rtn < 0 ){
				 setMessage("비정상적으로 처리되었습니다.");
				 setStatus( 0 );				 
			 }else{
				 setMessage("성공적으로 처리하였습니다.");
				 setValue(cont_no);
			 }			 
			 Commit();
		 }catch(Exception e){
			 Rollback();
			 setStatus(0);
			 setFlag(false);
			 setMessage(e.getMessage());
			 Logger.err.println(info.getSession("ID"), this, e.getMessage());
		 }
		 finally {}
		 return getSepoaOut();
	}
	
	public SepoaOut getContractDelete(Map<String, Object> data) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String> header = MapUtils.getMap(data, "headerData");

        	sxp = new SepoaXmlParser(this, "getContractDelete");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doUpdate(grid);
        	Commit();
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setStatus(0);
		}

		return getSepoaOut();
	}
	
	//계약생성현황조회
	public SepoaOut getContractList(Map<String, Object> allData){

		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> header = MapUtils.getMap(allData, "headerData");
		Map<String, String> customHeader =  new HashMap<String, String>();	
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			customHeader.put("company_code"  , info.getSession("COMPANY_CODE"));
			customHeader.put("language"      , info.getSession("LANGUAGE"));
			customHeader.put("from_cont_date", SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "from_cont_date", "") ) );
			customHeader.put("to_cont_date"  , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "to_cont_date", "") ) );
			
			sxp = new SepoaXmlParser(this, "getContractList");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	setValue(ssm.doSelect(header,customHeader));
		} 
		catch (Exception e)
		{
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	//계약생성상세조회
	public SepoaOut getContractUpdateSelect( String cont_no, String cont_gl_seq ) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		String language = info.getSession("LANGUAGE");

		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("    SELECT                               \n");
			sqlsb.append("    	 A.CONT_NO                           \n");
			sqlsb.append("    	,A.CONT_GL_SEQ                       \n");
			sqlsb.append("    	,A.SUBJECT                           \n");
			sqlsb.append("    	,A.CONT_GUBUN                        \n");
			sqlsb.append("    	,A.PROPERTY_YN                       \n");
			sqlsb.append("    	,A.SELLER_CODE                       \n");
			sqlsb.append("    	,GETCOMPANYNAMELOC('"+info.getSession("HOUSE_CODE")+"', A.SELLER_CODE, 'S') AS SELLER_NAME	\n");
			sqlsb.append("    	,A.SIGN_PERSON_ID                    \n");
			sqlsb.append("    	,A.SIGN_PERSON_NAME                  \n");
			sqlsb.append("    	,A.CONT_FROM                         \n");
			sqlsb.append("    	,A.CONT_TO                           \n");
			sqlsb.append("    	,A.CONT_DATE                         \n");
			sqlsb.append("    	,A.CONT_ADD_DATE                     \n");
			sqlsb.append("    	,A.CONT_TYPE                         \n");
			sqlsb.append("    	,A.ELE_CONT_FLAG                     \n");
			sqlsb.append("    	,A.ASSURE_FLAG                       \n");
			sqlsb.append("    	,A.START_START_INS_FLAG              \n");
			sqlsb.append("    	,A.CONT_PROCESS_FLAG                 \n");
			sqlsb.append("    	,A.CONT_AMT                          \n");
			sqlsb.append("    	,A.CONT_ASSURE_PERCENT               \n");
			sqlsb.append("    	,A.CONT_ASSURE_AMT                   \n");
			sqlsb.append("    	,A.FAULT_INS_PERCENT                 \n");
			sqlsb.append("    	,A.FAULT_INS_AMT                     \n");
			sqlsb.append("    	,A.PAY_DIV_FLAG                      \n");
			sqlsb.append("    	,A.FAULT_INS_TERM                    \n");
			sqlsb.append("    	,A.BD_NO                             \n");
			sqlsb.append("    	,A.BD_COUNT                          \n");
			sqlsb.append("    	,A.AMT_GUBUN                         \n");
			sqlsb.append("    	,A.TEXT_NUMBER                       \n");
			sqlsb.append("    	,A.DELAY_CHARGE                      \n");
			sqlsb.append("    	,A.DELV_PLACE                        \n");
			sqlsb.append("    	,A.REMARK                            \n");
			sqlsb.append("    	,A.CTRL_DEMAND_DEPT                  \n");
			sqlsb.append("    	,GETCODETEXT2('M286', A.CT_FLAG, 'KO') AS CT_FLAG_TEXT 		\n");
			sqlsb.append("    	,A.CT_FLAG					 	   \n");
			sqlsb.append("    	,A.CTRL_CODE                         \n");
			sqlsb.append("    	,A.COMPANY_CODE                      \n");
			sqlsb.append("    	,A.ACCOUNT_CODE                      \n");
			sqlsb.append("    	,A.ACCOUNT_NAME                      \n");
			sqlsb.append("    	,A.REJECT_REASON                      \n");
			sqlsb.append("    	,A.RFQ_TYPE                          \n");
			sqlsb.append("    	,A.CONT_TYPE1_TEXT                   \n");
			sqlsb.append("    	,A.CONT_TYPE2_TEXT                   \n");
			sqlsb.append("      ,(                                        \n ");
			sqlsb.append("         SELECT MAX( CONT_GL_SEQ )              \n ");
			sqlsb.append("         FROM   SCPGL                           \n ");
			sqlsb.append("         WHERE  CONT_NO            = A.CONT_NO  \n ");
			sqlsb.append("         AND    NVL(DEL_FLAG, 'N') = 'N'        \n ");
			sqlsb.append("       )      AS MAX_CONT_GL_SEQ				  \n ");
			sqlsb.append("    	,A.DELV_PLACE                             \n ");
			sqlsb.append("    	,A.SG_LEV1      	                      \n ");
			sqlsb.append("    	,A.SG_LEV2	                              \n ");
			sqlsb.append("    	,A.SG_LEV3  	                          \n ");
			sqlsb.append("    	,A.ADD_TAX_FLAG	                          \n ");
			sqlsb.append("    	,A.ITEM_TYPE	                          \n ");
			sqlsb.append("    	,A.RD_DATE	                          \n ");
			sqlsb.append("    	,A.CONT_TOTAL_GUBUN	                          \n ");
			sqlsb.append("    	,A.CONT_PRICE	                          \n ");
			sqlsb.append("    	,A.BEFORE_CONT_FROM	                          \n ");
			sqlsb.append("    	,A.BEFORE_CONT_TO	                          \n ");
			sqlsb.append("    	,A.BEFORE_CONT_AMT	                          \n ");
			sqlsb.append("    	,A.BEFORE_ITEM_TYPE	                          \n "); 
			sqlsb.append("    	,A.TTL_ITEM_QTY	                          \n "); 
			sqlsb.append("    	,A.EXEC_NO	                          \n "); 
			
			sqlsb.append("    	,A.REQ_DEPT \n ");
			sqlsb.append("    	,A.REQ_DEPT_NAME \n ");
			sqlsb.append("    	,A.APP_DATE \n ");
			sqlsb.append("    	,A.PREV_SIGN_PERSON_ID \n ");
			sqlsb.append("    	,A.PREV_SIGN_PERSON_NAME \n ");
			sqlsb.append("    	,A.APP_AMT \n ");
			sqlsb.append("    	,A.PR_DATE \n ");
			sqlsb.append("    	,A.BUDGET_AMT \n ");
			sqlsb.append("    	,A.PAY_DATE \n ");
			sqlsb.append("    	,A.IN_PRICE_AMT \n ");
			sqlsb.append("    	,A.BE_PRICE_AMT \n ");
			sqlsb.append("    	,A.APP_REMARK \n ");
			sqlsb.append("    	,A.AUTO_EXTEND_FLAG \n ");
			sqlsb.append("    	,A.ITEM_QTY \n ");
			sqlsb.append("    	,A.IN_ATTACH_NO \n ");
			sqlsb.append("    	,GETFILEATTCOUNT(A.IN_ATTACH_NO) AS IN_ATTACH_CNT \n ");
			/*sqlsb.append("		,(SELECT CONFIRM_USER_ID								\n");//�˼����� ���̵� �ҷ��1�
			sqlsb.append("		  FROM SPRGL											\n");
			sqlsb.append("		  WHERE NVL(DEL_FLAG, 'N') = 'N'						\n");
			sqlsb.append("		  AND PR_NUMBER = (SELECT PR_NO							\n");
			sqlsb.append("							 FROM SCPLN							\n");
			sqlsb.append("							 WHERE NVL(DEL_FLAG, 'N') = 'N'		\n");
			sqlsb.append(sm.addSelectString("		 AND CONT_NO = ?					\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("							 AND CONT_SEQ = '1')) CONFIRM_USER_ID  \n");
			sqlsb.append("		,(SELECT CONFIRM_USER_NAME								\n");//�˼����� �̸� �ҷ��1�
			sqlsb.append("		  FROM SPRGL											\n");
			sqlsb.append("		  WHERE NVL(DEL_FLAG,ㅊ 'N') = 'N'						\n");
			sqlsb.append("		  AND PR_NUMBER = (SELECT PR_NO							\n");
			sqlsb.append("							 FROM SCPLN							\n");
			sqlsb.append("							 WHERE NVL(DEL_FLAG, 'N') = 'N'		\n");
			sqlsb.append(sm.addSelectString("		 AND CONT_NO = ?					\n"));
			sm.addStringParameter(cont_no);
			sqlsb.append("							 AND CONT_SEQ = '1')) CONFIRM_USER_NAME  \n");*/
		
			sqlsb.append("    FROM SCPGL2      A                     \n");
			sqlsb.append("    WHERE NVL(A.DEL_FLAG, 'N') = 'N'       \n");
			sqlsb.append(sm.addSelectString("     AND A.CONT_NO = ?                   \n"));
			sm.addStringParameter(cont_no);
			sqlsb.append(sm.addSelectString("     AND A.CONT_GL_SEQ = ?                   \n"));
			sm.addStringParameter(cont_gl_seq);			
			sqlsb.append("    ORDER BY A.CONT_NO DESC                                 \n");
			setValue(sm.doSelect(sqlsb.toString()));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
		
	}

	  
}