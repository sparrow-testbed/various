package catalog;

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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaString;

public class mycatalog extends SepoaService {
    private Message msg;

    /**
     * 생성자
     * 
     * @param opt
     * @param info
     * @throws SepoaServiceException
     */
    public mycatalog(String opt, SepoaInfo info) throws SepoaServiceException {
        super(opt, info);
        
        setVersion("1.0.0");
        
        msg = new Message(info,"p10_pra");
    }
    
    /**
     * ???
     * 
     * @param s
     * @return
     */
	public String getConfig(String s){
	    try{
	        Configuration configuration = new Configuration();
	        
	        s = configuration.get(s);
	        
	        return s;
	    }
	    catch(ConfigurationException configurationexception){
	        Logger.sys.println("getConfig error : " + configurationexception.getMessage());
	    }
	    catch(Exception exception){
	        Logger.sys.println("getConfig error : " + exception.getMessage());
	    }
	    
	    return null;
	}

	/**
	 * 마이 카테고리 정보 삭제하는 메소드가 아닐까?
	 * 
	 * @param data
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut setDelete_myCatalog(Map<String, Object> data) throws Exception{ // 변환 작업으로 인한 수정
        ConnectionContext         ctx           = null;
        SepoaXmlParser            sxp           = null;
		SepoaSQLManager           ssm           = null;
		List<Map<String, String>> grid          = null;
		Map<String, String>       gridInfo      = null;
		String                    houseCode     = info.getSession("HOUSE_CODE");
		String                    userId        = info.getSession("ID");
		String                    menuFieldCode = null;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			
			for(int i = 0; i < grid.size(); i++) {
                sxp = new SepoaXmlParser(this, "et_setDelete_myCatalog");
                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                
                gridInfo = grid.get(i);
                
                menuFieldCode = gridInfo.get("MENU_FIELD_CODE");
                
                if((menuFieldCode == null) || (menuFieldCode.equals(""))){
                	menuFieldCode = "*";
                }
                
                gridInfo.put("HOUSE_CODE",      houseCode);
                gridInfo.put("USER_ID",         userId);
                gridInfo.put("MENU_FIELD_CODE", menuFieldCode);
                                
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

	/**
	 * 마이카테고리 등록하는 메소드인듯?
	 * 
	 * @param data
	 * @return SepoaOut
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public SepoaOut getMyCatalogSelect_Insert(Map<String, Object> data) throws Exception{ // 변환 작업으로 인한 수정
        ConnectionContext         ctx      = null;
        SepoaXmlParser            sxp      = null;
		SepoaSQLManager           ssm      = null;
		List<Map<String, String>> grid     = null;
		Map<String, String>       gridInfo = null;
        
    	setStatus(1);
		setFlag(true);
		
		ctx = getConnectionContext();
		
		try {
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			for(int i = 0; i < grid.size(); i++) {
				gridInfo = grid.get(i);
				
                sxp = new SepoaXmlParser(this, "et_setInsert_myCatalog");
                ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                
                gridInfo.put("HOUSE_CODE",   info.getSession("HOUSE_CODE"));
                gridInfo.put("USER_ID",      info.getSession("ID"));
                gridInfo.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
                
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
	
	/**
	 * 조회전 조회 조건 셋팅
	 * 
	 * @param header
	 * @return Map
	 */
	private Map<String, String> getmyCatalogHeader(Map<String, String> header){
		String userId          = info.getSession("ID");
		String houseCode       = info.getSession("HOUSE_CODE");
		String companyCode     = info.getSession("COMPANY_CODE");
		String location        = info.getSession("LOCATION_CODE");
		String plantCode       = info.getSession("PLANT_CODE");
		String plantCodeIn     = "";
		String buyerItemNo     = header.get("BUYER_ITEM_NO");
		String description     = header.get("DESCRIPTION");
		String descriptionText = header.get("DESCRIPTION_TEXT");
		String descriptionKey  = null;
		
		if(plantCode.indexOf("&") > 0 ){
			plantCodeIn = SepoaString.str2in(plantCode, "&");
		}
		
		if("LOC".equals(description)){
			descriptionKey = "description_loc";
		}
		else{
			descriptionKey = "description_eng";
		}
		
		header.put("house_code",    houseCode);
		header.put("company_code",  companyCode);
		header.put("location",      location);
		header.put("plant_code",    plantCode);
		header.put("plant_code_in", plantCodeIn);
		header.put("user_id",       userId);
		header.put("item_no",       buyerItemNo);
		header.put(descriptionKey,  descriptionText);
		
		return header;
	}
	
	/**
	 * 나의 카탈로그 조회
	 * 
	 * @param header
	 * @return SepoaOut
	 */
	public SepoaOut getmyCatalog(Map<String, String> header){
		ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		String            cur = null;
		
		try{
			setStatus(1);
			setFlag(true);
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "et_getmyCatalog");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			header = this.getmyCatalogHeader(header); // 조회 조건 셋팅
			rtn    = ssm.doSelect(header); // 조회
			cur    = et_getcur();
			
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
    

    
//
//
//////////////////////////////////////////////////////////////////////////////////////////// 
	/**
	 *  메소드명     : getPoCreateCatalogSelect()
	 *  호출 Method  : et_getPoCreateCatalogSelect()
	 *  Path        : 『나의카탈로그(품번마스터)』 (외자) (발주생성(외자),발주수정(외자)) (조회)
	 *  JSP         : ⑴ 관련 파일
	 *                 ① /catalog/po1_pp_lis3.jsp  ==>  『나의카탈로그(품번마스터)』
	 *  Servlet     :  /catalog/mycat_pp_lis.java
	 *  Description : ⑴ 쓰이는 곳
	 *                 ① Ordering > 발주관리 > 발주 > 발주생성(외자)            ( /kr/order/bpo/po2_bd_ins1.jsp )
	 *                 ② Ordering > 발주관리 > 발주 > 발주현황 > 발주수정(외자) ( /kr/order/bpo/po3_bd_upd1.jsp )
	 *                ⑵ 『조회』 Button Click시 호출
	 *  Since       :  2003.08.01.~
	 */
	public SepoaOut getPoCreateCatalogSelect( String menu_field_code,
	                                         String item_no,
	                                         String description_loc,
	                                         String description_eng,
	                                         String specification,
	                                         String vendor_code,
	                                         String company_code,
	                                         String plant_code,
	                                         String sub_query_flag
	                                       )
	{
		try
		{
			String rtn = et_getPoCreateCatalogSelect( menu_field_code,
			                                          item_no,
			                                          description_loc,
			                                          description_eng,
			                                          specification,
			                                          vendor_code,
			                                          company_code,
			                                          plant_code,
			                                          sub_query_flag
			                                         );
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}
		catch(Exception e)
		{
			Logger.err.println(userid,this,e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0001"));
		}

		return getSepoaOut();
	}


	/**
	 *  메소드명     : et_getPoCreateCatalogSelect()
	 *  호출시키는는 Method  : getPoCreateCatalogSelect()
	 *  Path        : 『나의카탈로그(품번마스터)』 (외자) (발주생성(외자),발주수정(외자)) (조회)
	 *  Since       :  2003.08.01.~
	 */
	private String et_getPoCreateCatalogSelect( String menu_field_code,
	                                            String item_no,
	                                            String description_loc,
	                                            String description_eng,
	                                            String specification,
	                                            String vendor_code,
	                                            String company_code,
	                                            String plant_code,
	                                            String sub_query_flag
	                                          ) throws Exception
	{
		String rtn = null;

		String user_id        = info.getSession("ID");

		try
		{
			ConnectionContext ctx = getConnectionContext();

			String house_code   = info.getSession("HOUSE_CODE");
			String dept         = info.getSession("DEPARTMENT");


			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("dept", dept);
			wxp.addVar("user_id", user_id);
			wxp.addVar("house_code", house_code);
			wxp.addVar("company_code", company_code);
			wxp.addVar("plant_code", plant_code);
			wxp.addVar("menu_field_code", menu_field_code);
			wxp.addVar("item_no", item_no);
			wxp.addVar("description_loc", SepoaString.replace(description_loc,"'","''"));
			wxp.addVar("description_eng", SepoaString.replace(description_eng,"'","''"));
			wxp.addVar("specification", specification);
			wxp.addVar("vendor_code", vendor_code);
			wxp.addVar("sub_query_flag", sub_query_flag);

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			rtn = sm.doSelect((String[])null);

			if(rtn == null)
			{
				throw new Exception("SQL Manager is Null");
			}
		}
		catch(Exception e)
		{
			Logger.err.println(userid,this,e.getMessage());
			throw new Exception(e.getMessage());
		}
		return rtn;
	}

    private String et_getcur() throws Exception
    {
        String rtn = null;

        ConnectionContext ctx = getConnectionContext();
        StringBuffer sql = new StringBuffer();
        String house_code = info.getSession("HOUSE_CODE");

        sql.append(" SELECT CODE FROM SCODE              \n");
        sql.append(" WHERE TYPE         = 'M002'            \n");
        sql.append(" AND   HOUSE_CODE   = '"+house_code+"'  \n");
        sql.append(" AND   USE_FLAG     = 'Y'               \n");
        sql.append(" ORDER BY SORT_SEQ                      \n");

        try{
          SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
          rtn = sm.doSelect((String[])null);
        }catch(Exception e) {
          Logger.err.println(info.getSession("ID"),this,e.getMessage());
          throw new Exception(e.getMessage());
        }
        return rtn;
    }
}