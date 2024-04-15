package ev;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;
//import erp.ERPInterface;

public class EV_001 extends SepoaService {
	Message msg = new Message(info, "IV_001");  // message 처리를 위해 전역변수 선언

	public EV_001(String opt, SepoaInfo info) throws SepoaServiceException {
    	super(opt, info);
		setVersion("1.0.0");
		Configuration configuration = null;

		try {
			configuration = new Configuration();
		} catch(ConfigurationException cfe) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + cfe.getMessage());
		} catch(Exception e) {
			Logger.err.println(info.getSession("ID"), this, "getConfig error : " + e.getMessage());
		}
    }

	/**
	 * @Method Name : getConfig
	 * @작성일 : 2011. 12. 10
	 * @작성자 :
	 * @변경이력 :
	 * @Method 설명 :
	 * @param s
	 * @return
	 */
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
	/* 공사평가대기 목록 */
	public SepoaOut getCsEvWaitList(Map<String, String> header) {
		try {
			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getCsEvWaitList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getCsEvWaitList(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getCsEvWaitList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getCsEvWaitList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	/* 공사평가 목록 */
	public SepoaOut getCsEvList(Map<String, String> header) {
		try {
			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getCsEvList(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getCsEvList(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getCsEvList");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getCsEvList:" + e.getMessage());
		} finally {
		}
		return rtn;
	}

	
	/* 공사정보 */
	public SepoaOut getCsInfo(String inv_no) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("inv_no", inv_no);
						String rtnHD = bl_getCsInfo(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/* 공사정보 */
	private String bl_getCsInfo(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getCsInfo");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getCsInfo:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	
	/* 공사평가표 */
	public SepoaOut getCsEvalSheet(String ev_gb, String inv_no, String cskd_gb, String vendor_code) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("ev_gb", ev_gb);
			customHeader.put("inv_no", inv_no);
			customHeader.put("cskd_gb", cskd_gb);
			customHeader.put("vendor_code", vendor_code);
			String rtnHD = bl_getCsEvalSheet(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getCsEvalSheet(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getCsEvalSheet");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getCsEvalSheet:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	
	
	
	
	
	
	
	/* 공사정보결과 */
	public SepoaOut getCsInfoRst(String ec_no) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("ec_no", ec_no);
						String rtnHD = bl_getCsInfoRst(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/* 공사정보결과 */
	private String bl_getCsInfoRst(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getCsInfoRst");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getCsInfoRst:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	
	/* 공사평가결과 */
	public SepoaOut getCsEvalRst(String ec_no) {
		try {
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
			customHeader.put("ec_no", ec_no);
			String rtnHD = bl_getCsEvalRst(customHeader);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	/* 공사평가결과 */
	private String bl_getCsEvalRst(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getCsEvalRst");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getCsEvalRst:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	
	
	
	
	
	
	
	
	
	
	@SuppressWarnings("unchecked")
	public SepoaOut setEcSave(Map<String, Object> param) throws Exception{
		String                    add_user_id       =  info.getSession("ID");
        String                    house_code        =  info.getSession("HOUSE_CODE");
        String                    company           =  info.getSession("COMPANY_CODE");
        String                    add_user_dept     =  info.getSession("DEPARTMENT");
        String                    ecNo              = null;
        String                    pr_tot_amt        = null;
        Map<String, String>       header            = MapUtils.getMap(param, "headerData"); // 조회 조건 조회
        Map<String, String>       ecHdCreateParam   = null;
        Map<String, String>       ecDtCreateParam   = null;
        Map<String, String>       gridInfo          = null;
        List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(param, "gridData");
        int                       hd_rtn            = 0;
        int                       dt_rtn            = 0;
        int                       iv_rtn            = 0;
        int                       gridSize          = grid.size();
        int                       i                 = 0;
        
    	ecNo         = header.get("EC_NO");
    	
        try{
        	ecHdCreateParam = this.ecHdCreateParam(header);
            hd_rtn          = this.et_setEcHDCreate(ecHdCreateParam);        
            if(hd_rtn < 1){
            	throw new Exception("공사평가 실패하였습니다.");
            }
            
            for(i = 0; i < gridSize; i++){
            	gridInfo        = grid.get(i);
            	ecDtCreateParam = this.ecDtCreateParam(header, gridInfo);
                dt_rtn          = this.et_setEcDTCreate(ecDtCreateParam);                
                if(dt_rtn < 1){
                	throw new Exception("공사평가 실패하였습니다.");
                }
            }
            
            iv_rtn          = this.et_setIvHDUpd(ecHdCreateParam);
            if(iv_rtn < 1){
            	throw new Exception("공사평가 실패하였습니다.");
            }
            
            setStatus(1);
            setFlag(true);
            setValue(ecNo);
            
            setMessage("평가번호(공사) - "+ecNo+" 번으로 생성되었습니다.");	

            Commit();
        }
        catch(Exception e){
            try{
                Rollback();
            }
            catch(Exception d){
                Logger.err.println(info.getSession("ID"),this,d.getMessage());
            }
            
            Logger.err.println(info.getSession("ID"),this,"XXXXXXXXXXXXXXXXX"+e.getMessage());
            setStatus(0);
            setFlag(false);
            setMessage("공사평가 실패하였습니다.");
        }

        return getSepoaOut();
	}
	
	private int et_setEcHDCreate(Map<String, String> param) throws Exception{
    	ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setEcHDCreate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doInsert(param);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	private int et_setEcDTCreate(Map<String, String> param) throws Exception{
		ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setEcDTCreate");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            
            rtn = ssm.doInsert(param);
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	private int et_setIvHDUpd(Map<String, String> param) throws Exception{
    	ConnectionContext ctx = getConnectionContext();
    	SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
        int               rtn = 0;
        
        try{
            sxp = new SepoaXmlParser(this, "et_setIvHDUpd");
            ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                            
            rtn = ssm.doInsert(param);
            
        }
        catch(Exception e){
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        
        return rtn;
    }
	
	/**
	 * et_setEcHDCreate 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> ecHdCreateParam(Map<String, String> header) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		
		result.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		result.put("EC_NO",               header.get("EC_NO"));
		result.put("INV_NO",              header.get("H_INV_NO"));
		result.put("CSKD_GB",             header.get("H_CSKD_GD"));
		result.put("VENDOR_CODE",         header.get("H_VENDOR_CODE"));
		result.put("ASC_SUM",             header.get("asc_sum"));
		result.put("REMARK",              header.get("remark"));		
		result.put("EVAL_USER_ID",        header.get("H_EVAL_USER_ID"));
		result.put("ATTACH_NO",           header.get("ATTACH_NO"));
		
		return result;
	}
	
	/**
	 * ecDtCreateParam 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param head
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> ecDtCreateParam(Map<String, String> header, Map<String, String> gridInfo) throws Exception{
		Map<String, String> result = new HashMap<String, String>();
		result.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		result.put("EC_NO",              header.get("EC_NO"));
		result.put("EC_SEQ",             gridInfo.get("EC_SEQ"));		
		result.put("ES_CD",              gridInfo.get("ES_CD"));
		result.put("ES_VER",             gridInfo.get("ES_VER"));
		result.put("ES_SEQ",             gridInfo.get("ES_SEQ"));
		result.put("ASC_GD",             gridInfo.get("ASC_GD"));
		result.put("ASC1",               gridInfo.get("ASC1"));
		
		return result;
	}
	
	public SepoaOut setEcDelete(Map<String, Object> data) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			sxp = new SepoaXmlParser(this, "bl_getICOYTRTX_FLAG");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			
			sf = new SepoaFormater( ssm.doSelect( grid.get(0) ) );
            
            if( !"0".equals( sf.getValue( "CNT" , 0 ) ) ){
                throw new Exception("해당 평가완료 건은  삭제 불가상태입니다.\r\n세금계산서 진행건이 존재합니다.");
                
            } // end if
			
			

        	sxp = new SepoaXmlParser(this, "setEchdDelete");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doDelete(grid);
        	
        	sxp = new SepoaXmlParser(this, "setEcdtDelete");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doDelete(grid);
        	
        	sxp = new SepoaXmlParser(this, "et_setIvHDUpd2");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	ssm.doUpdate(grid);
        	Commit();
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			setMessage(e.getMessage().trim());
            setValue(e.getMessage().trim());
            setFlag(false);
            setStatus(0);
		}

		return getSepoaOut();
	}
	
	/**
	 * 검수 담당자 변경
	 * @param Transfer_person_id
	 * @param inv_no
	 * @return
	 */
	public SepoaOut doEvalChg( Map<String, Object> data ) {
		try {
			
			List<Map<String, String>> grid          = null;
			Map<String, String>       gridInfo      = null;
			Map<String, String> 	  header		= null;
			header = MapUtils.getMap(data, "headerData");
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			String eval_user_id2 = header.get("eval_user_id2");
			String[] inv_no = new String[grid.size()];
			
			for(int i = 0 ; i < grid.size() ; i++ ){
				inv_no[i] = grid.get(i).get("INV_NO");
			}

			Logger.debug.println(info.getSession("ID"), this, " eval_user_id2 ::" + eval_user_id2);
			int rtn = et_doEvalChg(  eval_user_id2,   inv_no);
			
			setStatus(1);
			setValue(String.valueOf(rtn));
			
			setMessage("성공적으로 변경되었습니다.");
			Commit();
		} catch (Exception e) {
			try {
				Rollback();
			} catch (Exception d) {
				Logger.err.println(info.getSession("ID"), this, d.getMessage());
			}
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0002"));
		}
		return getSepoaOut();
	}
	
	private int et_doEvalChg( String Transfer_person_id, String[] inv_no) throws Exception {

		ConnectionContext ctx = getConnectionContext();
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		SepoaSQLManager sm = null;
		SepoaFormater wf = null;
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		try {
			Logger.debug.println(info.getSession("ID"), this, "   inv_no.length  === > " + inv_no.length);
			String[][] data = new String[inv_no.length][];

            for(int	i =	0 ;	i <	inv_no.length;	i++	) {
            	String[] tmp = {Transfer_person_id, house_code, inv_no[i]};
            	data [i] = tmp;
			}

//			sql.append("UPDATE ICOYIVHD                     \n");
//			sql.append("SET  INV_PERSON_ID = ?              \n");
//			sql.append("WHERE HOUSE_CODE = ?              \n");
//			sql.append("AND INV_NO   = ?                 \n");

			String[] type = { "S", "S", "S"  };

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(data, type);


		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	/* 공사평가 통계 */
	public SepoaOut getCsEvList2(Map<String, String> header) {
		try {
			header.put("from_date", SepoaString.getDateUnSlashFormat(header.get("from_date")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(header.get("to_date")));
			String rtnHD = bl_getCsEvList2(header);

			SepoaFormater wf = new SepoaFormater(rtnHD);
			if (wf.getRowCount() == 0)
				setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
			setStatus(1);
			setValue(rtnHD);
		} catch (Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
		}
		return getSepoaOut();
	}
	
	private String bl_getCsEvList2(Map<String, String>header)
			throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, "bl_getCsEvList2");
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);
			rtn = sm.doSelect(header);
		} catch (Exception e) {
			throw new Exception("bl_getCsEvList2:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
	
	
	
} // END

