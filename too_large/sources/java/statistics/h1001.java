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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import wisecommon.SignRequestInfo;

public class h1001  extends SepoaService {
	private Message msg;

    public h1001(String opt, SepoaInfo info) throws SepoaServiceException {
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
	public SepoaOut getConData(Map< String, String > headerData)
	{
        ConnectionContext ctx = getConnectionContext();
        String rtn = "";

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

        	String house_code = headerData.get("house_code");
        	String con_number = headerData.get("con_number");
        	
//        	System.out.println("house_code===="+house_code);
//        	System.out.println("con_number===="+con_number);
        	
			sxp = new SepoaXmlParser(this, "getConData");
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
	 * 
	 * @method doSaveCon
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  2015-05-22
	 * @modify
	 */
	public SepoaOut doSaveCon(Map<String, Object> data) throws Exception{

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
			
			String house_code 	 		= "000";
			String con_number           = header.get("con_number");  
			String con_kind             = header.get("con_kind");    
			String own_kind             = header.get("own_kind");    
			String dept                 = header.get("dept");        
			String con_name             = header.get("con_name");    
			String pay_term             = header.get("pay_term");    
			String con_date             = header.get("con_date");    
			String made_date            = header.get("made_date");   
			String pay_date             = header.get("pay_date");    
			String own_name1            = header.get("own_name1");   
			String own_name2            = header.get("own_name2");   
			String own_name3            = header.get("own_name3");   
			String con_type1            = header.get("con_type1");   
			String vendor_code1         = header.get("vendor_code1");
			String pre_amt1             = header.get("pre_amt1");    
			String con_amt1             = header.get("con_amt1");    
			String con_type2            = header.get("con_type2");   
			String vendor_code2         = header.get("vendor_code2");
			String pre_amt2             = header.get("pre_amt2");    
			String con_amt2             = header.get("con_amt2");    
			String con_type3            = header.get("con_type3");   
			String vendor_code3         = header.get("vendor_code3");
			String pre_amt3             = header.get("pre_amt3");    
			String con_amt3             = header.get("con_amt3");    
			String con_type4            = header.get("con_type4");   
			String vendor_code4         = header.get("vendor_code4");
			String pre_amt4             = header.get("pre_amt4");    
			String con_amt4             = header.get("con_amt4");    
			String con_type5            = header.get("con_type5");   
			String vendor_code5         = header.get("vendor_code5");
			String pre_amt5             = header.get("pre_amt5");    
			String con_amt5             = header.get("con_amt5");    
			String con_type6            = header.get("con_type6");   
			String vendor_code6         = header.get("vendor_code6");
			String pre_amt6             = header.get("pre_amt6");    
			String con_amt6             = header.get("con_amt6");    
			String con_type7            = header.get("con_type7");   
			String vendor_code7         = header.get("vendor_code7");
			String pre_amt7             = header.get("pre_amt7");    
			String con_amt7             = header.get("con_amt7");    
			String con_type8            = header.get("con_type8");   
			String etc_amt1             = header.get("etc_amt1");    
			String etc_amt2             = header.get("etc_amt2");    
			String etc_amt3             = header.get("etc_amt3");    
			String etc_amt4             = header.get("etc_amt4");    
			String total_amt            = header.get("total_amt");   
			String pa_title             = header.get("pa_title");    
			String pa_name              = header.get("pa_name");     
			String boss_title           = header.get("boss_title");  
			String boss_name            = header.get("boss_name");   
			String remark               = header.get("remark");      
			String attach_no          = header.get("attach_no"); 
			String add_date 			= SepoaDate.getShortDateString();
			String add_time 			= SepoaDate.getShortTimeString();
			String add_user_id 			= info.getSession("ID");
			String change_date 			= SepoaDate.getShortDateString();
			String change_time 			= SepoaDate.getShortTimeString();
			String change_user_id 		= info.getSession("ID");
			
//			System.out.println("con_number====="+con_number);
//			System.out.println("con_number====="+con_number);
			if( con_number == null || "".equals( con_number ) || con_number.length() < 1 ) {
            	SepoaOut so = DocumentUtil.getDocNumber( info, "MC" );
            	con_number = so.result[0];
            }
//			System.out.println("con_number2====="+con_number);
			
			Map<String, String> temp = new HashMap<String, String>();
			temp.put("house_code", 		house_code);
			temp.put("con_number",        con_number);
			temp.put("con_kind",          con_kind);
			temp.put("own_kind",          own_kind);
			temp.put("dept",              dept);
			temp.put("con_name",          con_name);
			temp.put("pay_term",          pay_term);
			temp.put("con_date",          con_date.replaceAll("/", ""));
			temp.put("made_date",         made_date.replaceAll("/", ""));
			temp.put("pay_date",          pay_date.replaceAll("/", ""));
			temp.put("own_name1",         own_name1);
			temp.put("own_name2",         own_name2);
			temp.put("own_name3",         own_name3);
			temp.put("con_type1",         con_type1);
			temp.put("vendor_code1",      vendor_code1);
			temp.put("pre_amt1",          pre_amt1.replaceAll(",", ""));
			temp.put("con_amt1",          con_amt1.replaceAll(",", ""));
			temp.put("con_type2",         con_type2);
			temp.put("vendor_code2",      vendor_code2);
			temp.put("pre_amt2",          pre_amt2.replaceAll(",", ""));
			temp.put("con_amt2",          con_amt2.replaceAll(",", ""));
			temp.put("con_type3",         con_type3);
			temp.put("vendor_code3",      vendor_code3);
			temp.put("pre_amt3",          pre_amt3.replaceAll(",", ""));
			temp.put("con_amt3",          con_amt3.replaceAll(",", ""));
			temp.put("con_type4",         con_type4);
			temp.put("vendor_code4",      vendor_code4);
			temp.put("pre_amt4",          pre_amt4.replaceAll(",", ""));
			temp.put("con_amt4",          con_amt4.replaceAll(",", ""));
			temp.put("con_type5",         con_type5);
			temp.put("vendor_code5",      vendor_code5);
			temp.put("pre_amt5",          pre_amt5.replaceAll(",", ""));
			temp.put("con_amt5",          con_amt5.replaceAll(",", ""));
			temp.put("con_type6",         con_type6);
			temp.put("vendor_code6",      vendor_code6);
			temp.put("pre_amt6",          pre_amt6.replaceAll(",", ""));
			temp.put("con_amt6",          con_amt6.replaceAll(",", ""));
			temp.put("con_type7",         con_type7);
			temp.put("vendor_code7",      vendor_code7);
			temp.put("pre_amt7",          pre_amt7.replaceAll(",", ""));
			temp.put("con_amt7",          con_amt7.replaceAll(",", ""));
			temp.put("con_type8",         con_type8);
			temp.put("etc_amt1",          etc_amt1.replaceAll(",", ""));
			temp.put("etc_amt2",          etc_amt2.replaceAll(",", ""));
			temp.put("etc_amt3",          etc_amt3.replaceAll(",", ""));
			temp.put("etc_amt4",          etc_amt4.replaceAll(",", ""));
			temp.put("total_amt",         total_amt.replaceAll(",", ""));
			temp.put("pa_title",          pa_title);
			temp.put("pa_name",           pa_name);
			temp.put("boss_title",        boss_title);
			temp.put("boss_name",         boss_name);
			temp.put("remark",            remark);
			temp.put("attach_file",       attach_no);
			temp.put("add_date", 			add_date);
			temp.put("add_time", 			add_time);
			temp.put("add_user_id", 		add_user_id);
			temp.put("change_date", 		change_date);
			temp.put("change_time", 		change_time);
			temp.put("change_user_id", 	change_user_id);
			
			int cnt = 0;
			//순번가져오기
			Map map = new HashMap();
			map.put("house_code"		, house_code); 
			map.put("con_number"		, con_number); 
			sxp = new SepoaXmlParser(this, "getCheckDataSign");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp); 
			SepoaFormater wf = new SepoaFormater(ssm.doSelect(map));
			cnt = Integer.parseInt(wf.getValue("CNT", 0));
			
			Logger.err.println("=========cnt==========="+cnt);
			
			if(cnt==0){
				Logger.err.println("=========cnt===========ok");
				sxp = new SepoaXmlParser(this, "insertConData");
//				System.out.println(sxp.getQuery());
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				ssm.doInsert(temp);
				
			}else{
				sxp = new SepoaXmlParser(this, "updateConData");
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				ssm.doUpdate(temp);
			}
			
			Commit();
			
			setValue(house_code);
			setValue(con_number);
			
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
	 * 간판설치현황리스트 조회
	 * @method getSmaglList
	 * @param  header
	 * @return Map
	 * @throws Exception
	 * @desc   
	 * @since  
	 * @modify 
	 */
	public SepoaOut getConList(Map<String, String> header)
    {
        try
        {
            String rtn = et_getConList(header);
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
	private String et_getConList(Map<String, String> header) throws Exception
    {
        String rtn = null;
        ConnectionContext ctx = getConnectionContext();
        StringBuffer tSQL = new StringBuffer();
        SepoaSQLManager ssm = null;
        SepoaXmlParser wxp = new SepoaXmlParser(this, "getConList");
        
        try{
        	Logger.err.println("header=============="+header.toString());
        	
            wxp = new SepoaXmlParser(this, "getConList");
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
