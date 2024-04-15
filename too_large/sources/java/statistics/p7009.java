package statistics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import wisecommon.SignRequestInfo;

public class p7009  extends SepoaService {
	private Message msg;

    public p7009(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info, "STDCOMM");
    }
    
	public String getConfig(String s){
		Configuration configuration = null;
		
	    try{
	        configuration = new Configuration();
	        
	        s = configuration.get(s);
	    }
	    catch(Exception exception){
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	        
	        s = null;
	    }
	    
	    return s;
	}
	
	/**
	 * 설치현황조회
	 * @method getSignDate
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2015-02-12
	 * @modify 
	 */
	public SepoaOut getSignDate(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String rtn = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

        	String house_code = headerData.get("house_code");
        	String branches_code = headerData.get("branches_code");
        	String item_no = headerData.get("item_no");
        	String key_no = headerData.get("key_no");
        	String io_number = headerData.get("io_number");
        	
//        	System.out.println("house_code===="+house_code);
//        	System.out.println("branches_code===="+branches_code);
//        	System.out.println("item_no===="+item_no);
//        	System.out.println("key_no===="+key_no);
//        	System.out.println("io_number===="+io_number);
        	
			sxp = new SepoaXmlParser(this, "getSignDate");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);  
            rtn = ssm.doSelect(headerData);
            
            setValue(rtn);
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());
            setMessage("");
            setStatus(0);
        }
        return getSepoaOut();
    } 
	
	/**
	 * 설치현황등록
	 * @method doSaveSign
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2015-02-11
	 * @modify
	 */
	public SepoaOut doSaveSign(Map<String, Object> data) throws Exception{

  		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		Message msg = null;
		int rtn=0;
		setMessage("성공적으로 처리되었습니다.");
		try {
			msg = new Message(info, "SR_008");
			
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			String house_code = "000";
			String branches_code = header.get("branches_code");
			String branches_name = header.get("branches_name");
			String item_no = header.get("item_no");
			String item_name = header.get("item_name");
			String confirm_from_date = header.get("confirm_from_date");
			String confirm_to_date = header.get("confirm_to_date");
			String specification = header.get("specification");
			String stick_location = header.get("stick_location");
			String signform = header.get("signform");
			String sign_attach_no_count = header.get("sign_attach_no_count");
			String attach_no = header.get("attach_no");
			String install_store = header.get("install_store");
			String install_store_phone = header.get("install_store_phone");
			String key_no = header.get("key_no");
			String remove_flag = header.get("remove_flag");
			String remark = header.get("remark");
			String io_number = header.get("io_number");
			String save_flag = header.get("save_flag");
			
//			System.out.println("branches_code===="+branches_code);
//			System.out.println("branches_name===="+branches_name);
//			System.out.println("item_no===="+item_no);
//			System.out.println("item_name===="+item_name);
//			System.out.println("confirm_from_date===="+confirm_from_date);
//			System.out.println("confirm_to_date===="+confirm_to_date);
//			System.out.println("specification===="+specification);
//			System.out.println("stick_location===="+stick_location);
//			System.out.println("signform===="+signform);
//			System.out.println("sign_attach_no_count===="+sign_attach_no_count);
//			System.out.println("attach_no===="+attach_no);
//			System.out.println("install_store===="+install_store);
//			System.out.println("install_store_phone===="+install_store_phone);
//			System.out.println("key_no===="+key_no);
//			System.out.println("remove_flag===="+remove_flag);
//			System.out.println("remark===="+remark);
//			System.out.println("io_number===="+io_number);
//			System.out.println("save_flag===="+save_flag);
			
			String add_date = SepoaDate.getShortDateString();
			String add_time = SepoaDate.getShortTimeString();
			String add_user_id = info.getSession("ID");
			String change_date = SepoaDate.getShortDateString();
			String change_time = SepoaDate.getShortTimeString();
			String change_user_id = info.getSession("ID");
			
			header.put("house_code", house_code);
			header.put("add_date", add_date);
			header.put("add_time", add_time);
			header.put("add_user_id", add_user_id);
			header.put("change_date", change_date);
			header.put("change_time", change_time);
			header.put("change_user_id", change_user_id);
			header.put("del_flag", "N");
			
			//순번가져오기
			Map map = new HashMap();
			map.put("house_code"		, house_code); 
			map.put("key_no"		, key_no); 
			map.put("branches_code"    , branches_code); 
			map.put("item_no"		, item_no);
			map.put("io_number"		, io_number);
			sxp = new SepoaXmlParser(this, "getCheckDataSign");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater sf_sign = new SepoaFormater(ssm.doSelect(map));
			io_number = sf_sign.getValue("IO_NUMBER_NEW", 0);
			
			//구한 순번을 넣기
			header.put("io_number", io_number);
			
			sxp = new SepoaXmlParser(this, "insertSignData");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doInsert(header);
			
			Commit();
			
			setValue(house_code);
			setValue(key_no);
			setValue(branches_code);
			setValue(item_no);
			setValue(io_number);
			
		} catch (Exception e) {
//			e.printStackTrace();
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		} finally {
		}

		return getSepoaOut();
  	}
	
	
	/**
	 * 공급업체 : 간판설치현황관리 조회 가능여부 체크
	 * @param header
	 * @return
	 */
	public SepoaOut checkVendor(Map<String, String> header)
    {
        try
        {
            String rtn = et_checkVendor(header);
            setStatus(1);
            setFlag(true);
            setValue(rtn);

            setMessage(msg.getMessage("0000"));

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setFlag(false);
            setMessage(msg.getMessage("0001"));
        }
        return getSepoaOut();
    }
	
	/**
	 * 공급업체 : 간판설치현황관리 조회 가능여부 체크
	 * @param header
	 * @return
	 * @throws Exception
	 */
	private String et_checkVendor(Map<String, String> header) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        SepoaSQLManager ssm = null;
        SepoaXmlParser wxp = null;
        
        try{
        	
            wxp = new SepoaXmlParser(this, "et_checkVendor");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);  
            rtn = ssm.doSelect(header);
            
        }catch(Exception e) {
            Logger.debug.println(userid,this,e.getMessage());
            Logger.debug.println(userid,this,tSQL.toString());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
	
	
	/**
	 * 간판설치현황리스트 조회
	 * @method getSmaglList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  
	 * @modify 
	 */
	public SepoaOut getSmaglList(Map<String, String> header)
    {
        try
        {
            String rtn = et_getSmaglList(header);
            setStatus(1);
            setValue(rtn);

            setMessage(msg.getMessage("0000"));

        }catch(Exception e) {
            Logger.err.println(userid,this,e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("0001"));
        }
        return getSepoaOut();
    }

	/**
	 * 구매요청 진행현황 쿼리
	 * @method et_getSmaglList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since 
	 * @modify
	 */		    
	private String et_getSmaglList(Map<String, String> header) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        SepoaSQLManager ssm = null;
        SepoaXmlParser wxp = new SepoaXmlParser(this, "getSmaglList");
        
        try{
        	
            wxp = new SepoaXmlParser(this, "getSmaglList");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);  
            rtn = ssm.doSelect(header);

        }catch(Exception e) {
            Logger.debug.println(userid,this,e.getMessage());
            Logger.debug.println(userid,this,tSQL.toString());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
	/**
	 * 간판설치현황리스트 조회
	 * @method getSmaglList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  
	 * @modify 
	 */
	public SepoaOut getSmaglListHistory(SepoaInfo info, String house_code, String key_no, String branches_code, String item_no, String io_number)
	{
		try
		{
			Map map = new HashMap();
			map.put("house_code", house_code);
			map.put("key_no", key_no);
			map.put("branches_code", branches_code);
			map.put("item_no", item_no);
			map.put("io_number", io_number);
			
			String rtn = et_getSmaglListHistory(map);
			setStatus(1);
			setValue(rtn);
			
			setMessage(msg.getMessage("0000"));
			
		}catch(Exception e) {
//			e.printStackTrace();
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}
		return getSepoaOut();
	}
	
	/**
	 * 간판설치현황히스토리 조회
	 * @method et_getSmaglListHistory
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since 
	 * @modify
	 */		    
	private String et_getSmaglListHistory(Map map) throws Exception
	{
		String rtn = null;
		ConnectionContext ctx = getConnectionContext();
		StringBuffer tSQL = new StringBuffer();
		SepoaSQLManager ssm = null;
		SepoaXmlParser wxp = new SepoaXmlParser(this, "getSmaglListHistory");
		
		try{
			
			wxp = new SepoaXmlParser(this, "getSmaglListHistory");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp);  
			rtn = ssm.doSelect(map);
			
		}catch(Exception e) {
//			e.printStackTrace();
			Logger.debug.println(userid,this,e.getMessage());
			Logger.debug.println(userid,this,tSQL.toString());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}
	
	/**
	 * 간판설치현황 삭제
	 * @method et_getSmaglListHistory
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since 
	 * @modify
	 */
	public SepoaOut doDelete(Map<String, Object> data) throws Exception {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		String sign_path_no = null;
		try{
			List<Map<String,String>>grid=(List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	        
			sxp = new SepoaXmlParser(this, "doDelete");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doDelete(grid);
			
			Commit();
		}catch(Exception e){
			Rollback();
			setStatus(0);
			setFlag(false);
			
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
}
