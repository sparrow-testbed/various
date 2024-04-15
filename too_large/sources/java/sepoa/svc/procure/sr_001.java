/**
 Title:             Sourcing Group Class  <p>
 Description:       Sourcing Group Service Class  <p>
 Copyright:         Copyright (c) <p>
 Company:           ICOMPIA <p>
 @author            이수헌<p>
 @version           1.0.0
 @Comment

*/
package sepoa.svc.procure;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;



public class SR_001 extends SepoaService{
	String language 	= "";
	String serviceId 	= "p0050";
	String house_code = info.getSession("HOUSE_CODE");
    public SR_001(String opt,SepoaInfo sinfo) throws SepoaServiceException
    {
    	super( opt, sinfo );
    	setVersion( "1.0.0" );
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
     * 펼쳐진 트리 조회
     * @param parent_lev
     * @param current_lev
     * @return
     */
    public SepoaOut getExpandTreeList()	{
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try{
			/*String user_id = info.getSession("ID");*/
			sxp = new SepoaXmlParser(this, "getExpandTreeList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			setValue(ssm.doSelect(new HashMap()));
	
		}catch(Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		return getSepoaOut();
	}
    
    public SepoaOut setNodeInsert(Map<String, String> data) throws Exception {
		setStatus(1);
		setFlag(true);
		
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			//SepoaOut wo= DocumentUtil.getDocNumber(info, "CA");	//梨꾨쾲
			//String category_code = wo.result[0];
			
			Map<String, String> newMap = new HashMap<String, String>(); //蹂�꼍�섎뒗 留�
			//newMap.put("node_category_code", category_code);
			//newMap.put("category_code", MapUtils.getString(data, "category_code","0"));
			
//			System.out.println("data :: "+data);
			
			newMap.put("sg_name", data.get("sg_name"));
			newMap.put("sg_refitem", data.get("sg_refitem"));
			newMap.put("level_count", data.get("level_count"));
			if(data.get("level_count").equals("3")){
				newMap.put("leaf_flag", "Y");
			}else{
				newMap.put("leaf_flag", "N");
			}
			sxp = new SepoaXmlParser(this,"setNodeInsert");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doInsert(newMap);
			
			sxp = new SepoaXmlParser(this, "setNodeInsert_select");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	sf = new SepoaFormater(ssm.doSelect(newMap));
        	
        	String sg_refitem = "";
			if(sf != null  && sf.getRowCount() > 0) {
				sg_refitem = sf.getValue("sg_refitem", 0);
			}
			setValue(sg_refitem);
        	setValue(newMap.get("level_count"));
        	//setValue(ssm.doSelect(new HashMap()));
			
			
			
			Commit();
			
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
    public SepoaOut setNodeUpdate(Map<String, String> data) throws Exception {
		setStatus(1);
		setFlag(true);
		
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			Map<String, String> newMap = new HashMap<String, String>();
			newMap.put("sg_name", data.get("category_name"));
			newMap.put("sg_refitem", data.get("sg_refitem"));
			sxp = new SepoaXmlParser(this,"setNodeUpdate");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doUpdate(newMap);
			
			sxp = new SepoaXmlParser(this,"setNodeSelect");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf = new SepoaFormater(ssm.doSelect(newMap));
			String sg_refitem = "";
			String level_count = "";
			if(sf != null  && sf.getRowCount() > 0) {
				sg_refitem = sf.getValue("sg_refitem", 0);
			}
			if(sf != null  && sf.getRowCount() > 0) {
				level_count = sf.getValue("level_count", 0);
			}
			//setValue(data.get("sg_refitem"));
			setValue(sg_refitem);
			setValue(level_count);
			Commit();
			
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
    
    public SepoaOut setNodeDelete(List<Map<String, String>> dataList) throws Exception{
		setStatus(1);
		setFlag(true);
		
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			Map<String, String> newMap = new HashMap<String, String>();
			newMap.put("sg_refitem", dataList.get(0).get("sg_refitem"));
			
			//newMap.put("sg_refitem", data.get("sg_refitem"));
			sxp = new SepoaXmlParser(this,"setNodeDelete_1");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doUpdate(newMap);
			
			sxp = new SepoaXmlParser(this,"setNodeDelete_2");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doUpdate(dataList, true);
			
			/*sxp = new SepoaXmlParser(this,"setNodeSelect");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			setValue(ssm.doSelect(newMap));*/
						
			Commit();
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
    
    public SepoaOut getNodeInfo(Map<String, Object> data){
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf=null;
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			sxp = new SepoaXmlParser(this, "getNodeInfo");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	sf= new SepoaFormater(ssm.doSelect(header));
        	setValue(sf.getValue("SG_REFITEM", 0));
        	setValue(sf.getValue("SG_NAME", 0));
        	setValue(sf.getValue("DEFINITION", 0));
        	setValue(sf.getValue("VENDOR_SPECIAL_REMARK", 0));
        	setValue(sf.getValue("IS_NOTICE", 0));
        	setValue(sf.getValue("S_TEMP", 0));
        	setValue(sf.getValue("C_TEMP", 0));
        	setValue(sf.getValue("PURCHASE_CONDITION", 0));
        	setValue(sf.getValue("S_TEMPLATE_REFITEM", 0));
        	setValue(sf.getValue("C_TEMPLATE_REFITEM", 0));
        	setValue(sf.getValue("USER_ID", 0));
        	setValue(sf.getValue("USER_NAME_LOC", 0));
        	setValue(sf.getValue("TYPE", 0));
        	setValue(sf.getValue("ATTACH_NO", 0));
        	setValue(sf.getValue("FILE_NAME", 0));
        	/*sxp = new SepoaXmlParser(this, "getNodeInfo_1");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	sf= new SepoaFormater(ssm.doSelect(header));*/
        	
        	
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
    
    public SepoaOut setSgUpdate(Map<String, String> data) throws Exception {
		setStatus(1);
		setFlag(true);
		
		ConnectionContext ctx = getConnectionContext();

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			sxp = new SepoaXmlParser(this,"setSgUpdate");
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			ssm.doUpdate(header);
			
			Commit();
			
		} catch (Exception e) {
			Rollback();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
    
    
//==================================================== EPRO 소싱그룹 소스 추가 =====================================================
//    public SepoaOut ExpandTree(String parent_lev, String current_lev)
    public SepoaOut ExpandTree()
    {
    	try 
    	{
	        String[] rtn = (String[])null;
	        String user_id = this.info.getSession("ID");
	        String house_code = this.info.getSession("HOUSE_CODE");
	        rtn = et_ExpandTree(user_id);
	        setValue(rtn[0]);
	        setStatus(1);
    	} catch (Exception e) {
	        Logger.err.println("Exception e =" + e.getMessage());
	        setStatus(0);
	        setMessage("ExpandTree faild");
	        Logger.err.println(this, e.getMessage());
    	}
    	return getSepoaOut();
    }

    private String[] et_ExpandTree(String user_id) throws Exception {
    	String[] rtn = new String[2];
    	try
    	{
    		setStatus(1);
	        setFlag(true);
	
	        ConnectionContext ctx = getConnectionContext();
	        StringBuffer sb = new StringBuffer();
	        String language = this.info.getSession("LANGUAGE");
	        int add_date = SepoaDate.getYear();
	        int before_add_date = add_date - 1;
//	        System.out.println(add_date);
	        SepoaFormater sf = null;
	
	        ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);
	
	        sm.removeAllValue();
	        sb.delete(0, sb.length());
	        sb.append(" SELECT\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n");
	        sb.append("  count(*) cnt\t\t\t\t\t\t\t\t\t\t\t\t\n");
	        sb.append("\tFROM SSGGL ");
	        sb.append(" WHERE 1=1");
	        sb.append(sm.addSelectString(" AND SUBSTR(ADD_DATE,1,4) = ?")); sm.addStringParameter(add_date + "");
	        sb.append(" AND NVL(DEL_FLAG, 'N') = 'N'");
	        sb.append(" ORDER BY LEVEL_COUNT, SG_REFITEM");
	        sf = new SepoaFormater(sm.doSelect(sb.toString()));
	
	        if (Integer.parseInt(sf.getValue("cnt", 0)) > 0)
	        {
	        	sm.removeAllValue();
	        	sb.delete(0, sb.length());
	        	sb.append(" SELECT\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n");
	        	sb.append("  SG_REFITEM, SG_NAME, PARENT_SG_REFITEM,\t\t\t\t\t\t\t\t\t\n");
	        	sb.append("  LEVEL_COUNT , LEAF_FLAG AS IS_LEAF, USE_FLAG AS IS_USE\t\t\t\t\t\t\t\t\t\n");
	        	sb.append("\tFROM SSGGL ");
	        	sb.append(" WHERE 1=1 ");
	        	sb.append(" AND NVL(DEL_FLAG, 'N') = 'N' AND subStr(ADD_DATE,1,4) = '" + add_date + "'");
	        	sb.append(" AND USE_FLAG = 'Y' ");
	        	sb.append(" ORDER BY LEVEL_COUNT, SG_REFITEM");
	        	rtn[0] = sm.doSelect(sb.toString());
	        } else {
//	            System.out.println("=============================");
	            sm.removeAllValue();
	            sb.delete(0, sb.length());
	            sb.append(" insert into SSGGL \n ");
	            sb.append(" ( \n ");
	            sb.append(" \tSG_REFITEM,        \t\n ");
	            sb.append(" \tADD_DATE,          \t\n ");
	            sb.append(" \tADD_TIME,          \t\n ");
	            sb.append(" \tCHANGE_DATE,       \t\n ");
	            sb.append(" \tCHANGE_TIME,       \t\n ");
	            sb.append(" \tADD_USER_ID,       \t\n ");
	            sb.append(" \tSG_NAME,           \t\n ");
	            sb.append(" \tPARENT_SG_REFITEM, \t\n ");
	            sb.append("     LEVEL_COUNT,       \t \n");
	            sb.append("     DEFINITION,        \t \n");
	            sb.append("     LEAF_FLAG,         \t \n");
	            sb.append("     PURCHASE_CONDITION,\t \n");
	            sb.append("     NOTICE_FLAG,       \t \n");
	            sb.append("     USE_FLAG,          \t \n");
	            sb.append("     SG_CHARGE,         \t \n");
	            sb.append("     SG_TYPE,           \t \n");
	            sb.append("     DEL_FLAG           \t \n");
	            sb.append(" ) \n ");
	            
	            sb.append(" ( \n ");
	            sb.append(" \tselect \t \n ");
	            sb.append(" \tSG_REFITEM,        \t \n ");
	            sb.append(" \t?,          \t \n "); sm.addStringParameter(SepoaDate.getShortDateString());
	            sb.append(" \tADD_TIME,          \t \n ");
	            sb.append(" \tCHANGE_DATE,       \t \n ");
	            sb.append(" \tCHANGE_TIME,       \t \n ");
	            sb.append(" \tADD_USER_ID,       \t \n ");
	            sb.append(" \tSG_NAME,           \t \n ");
	            sb.append(" \tPARENT_SG_REFITEM, \t \n ");
	            sb.append(" \tLEVEL_COUNT,       \t \n ");
	            sb.append(" \tDEFINITION,        \t \n ");
	            sb.append(" \tLEAF_FLAG,         \t \n ");
	            sb.append(" \tPURCHASE_CONDITION,\t \n ");
	            sb.append(" \tNOTICE_FLAG,       \t \n ");
	            sb.append(" \tUSE_FLAG,          \t \n ");
	            sb.append(" \tSG_CHARGE,         \t \n ");
	            sb.append(" \tSG_TYPE,           \t \n ");
	            sb.append(" \tDEL_FLAG           \t \n ");
	            sb.append(" \tFROM SSGGL\t \n ");
	            sb.append(" \tWHERE subStr(ADD_DATE,1,4) = ?"); sm.addStringParameter((add_date - 1) + "");
	            sb.append(" )\t \n ");
	            sm.doInsert(sb.toString());
	            Commit();
	            
	            sm.removeAllValue();
	            sb.delete(0, sb.length());
	            sb.append(" SELECT \n");
	            sb.append("  SG_REFITEM, SG_NAME, PARENT_SG_REFITEM, \n");
	            sb.append("  LEVEL_COUNT, LEAF_FLAG AS IS_LEAF, USE_FLAG AS IS_USE \n");
	            sb.append(" FROM SSGGL ");
	            sb.append(" WHERE 1=1 ");
	            sb.append(" AND NVL(DEL_FLAG, 'N') = 'N' AND subStr(ADD_DATE,1,4) = '" + add_date + "'");
	            sb.append(" ORDER BY LEVEL_COUNT, SG_REFITEM");
	            rtn[0] = sm.doSelect(sb.toString());
	        }

    	}catch (Exception e) {
//	        e.printStackTrace();
	        setMessage(e.getMessage());
	        setStatus(0);
	        setFlag(false);
	        Logger.debug.println(info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//	        System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
    	}
    	return rtn;
    }
    
    public SepoaOut supplycompany_list(String company_code) throws Exception {
    	try
    	{
    		String[] rtn = new String[2];
    	    setStatus(1);
    	    setFlag(true);

    	    ConnectionContext ctx = getConnectionContext();
    	    StringBuffer sb = new StringBuffer();
    	    String language = this.info.getSession("LANGUAGE");
    	    int add_date = SepoaDate.getYear();
    	    int before_add_date = add_date - 1;
    	    SepoaFormater sf = null;
    	    SepoaFormater sf1 = null;

    	    ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);

    	    sm.removeAllValue();
    	    sb.delete(0, sb.length());
    	    sb.append(" SELECT\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n");
    	    sb.append("  count(*) cnt\t\t\t\t\t\t\t\t\t\t\t\t\n");
    	    sb.append("\tFROM SSGVN ");
    	    sb.append(" WHERE 1=1");
    	    sb.append(sm.addSelectString(" AND SUBSTR(ADD_DATE,1,4) = ?")); sm.addStringParameter(add_date+"");
    	    sb.append(" AND del_flag = 'N'");
    	    sf = new SepoaFormater(sm.doSelect(sb.toString()));

    	    if (Integer.parseInt(sf.getValue("cnt", 0)) > 0)
    	    {
    	    	sm.removeAllValue();
    	        sb.delete(0, sb.length());
    	        sb.append(" SELECT\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n");
    	        sb.append(" \tGETSGNAME1(PARENT1) AS sg_type1                                                                 \t\t\t\n");
    	        sb.append(" \t, GETSGNAME1(PARENT2) AS sg_type2\t\t\t\t\t\t\t\n");
    	        sb.append(" \t, GETSGNAME1(SG) AS sg_type3\t\t\t\t\t\t\t\t\n");
    	        sb.append(" \t, APPLY_FLAG                                                               \t\t\t\n");
    	        sb.append(" \t, SELLER_SG_REFITEM                                                               \t\t\t\n");
    	        sb.append(" \t, VENDOR_CODE                                                               \t\t\t\n");
    	        sb.append(" FROM                \t                                               \t\t\t\n");
    	        sb.append(" (                                                               \t\t             \t        \t\t\t\n");
    	        sb.append(" \tSELECT                                                       \t\t             \t        \t\t\t\n");
    	        sb.append(" \t\t   (SELECT PARENT_SG_REFITEM                             \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t   FROM SSGGL                                  \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t  WHERE SG_REFITEM = B.PARENT_SG_REFITEM\t             \t        \t\t\t\n");
    	        sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	        sm.addStringParameter(SepoaDate.getYear()+"");
    	        sb.append(" \t\t\t) AS PARENT1                      \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,B.PARENT_SG_REFITEM AS PARENT2                      \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.SG_REFITEM AS SG                                  \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.VENDOR_CODE AS VENDOR_CODE                          \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.SELLER_SG_REFITEM              \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,B.NOTICE_FLAG   \t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.APPLY_FLAG   \t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.DEL_FLAG   \t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \tFROM \tSSGGL B, SSGVN A          \t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \tWHERE\t1=1\t\t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \tAND     A.SG_REFITEM = B.SG_REFITEM                          \t\t             \t        \t\t\t\n");
    	        sb.append(" \tAND\t\tB.LEVEL_COUNT = '3'                                  \t             \t        \t\t\t\n");
    	        sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(B.ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	        sm.addStringParameter(SepoaDate.getYear()+"");
    	        sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(A.ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	        sm.addStringParameter(SepoaDate.getYear()+"");
    	        sb.append(" \tORDER BY PARENT1, PARENT2, SG, VENDOR_CODE                    \t\t             \t        \t\t\t\n");
    	        sb.append(" )                                                    \t\t             \t                                               \t\t\t\n");
    	        sb.append("WHERE\t1=1\t\t\t\t\t\t\t\t\t\t\n");
    	        sb.append("AND\t DEL_FLAG = 'N'\t\t\t\t\t\t\t\t\t\t\n");
    	        sb.append(sm.addSelectString("   AND  VENDOR_CODE  = ?                           \t\n")); sm.addStringParameter(company_code);
    	        sb.append("\n");

    	        Logger.debug.println(this.info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

    	        rtn[0] = sm.doSelect(sb.toString());
    	        setValue(rtn[0]);
    	    } else {
    	    	sm.removeAllValue();
    	        sb.delete(0, sb.length());
    	        sb.append(" SELECT\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n");
    	        sb.append("  count(*) cnt\t\t\t\t\t\t\t\t\t\t\t\t\n");
    	        sb.append("\tFROM SSGVN ");
    	        sb.append(" WHERE 1=1");
    	        sb.append(sm.addSelectString(" AND SUBSTR(ADD_DATE,1,4) = ?")); sm.addStringParameter((add_date - 1) + "");
    	        sb.append(" AND del_flag = 'N'");
    	        sf1 = new SepoaFormater(sm.doSelect(sb.toString()));
                
    	        if (sf1.getRowCount() <= 0) {
    	        	sm.removeAllValue();
	    	        sb.delete(0, sb.length());
	    	        sb.append(" INSERT INTO SSGVN\t(\t\t\t\t\n ");
	    	        sb.append(" \tSELLER_SG_REFITEM,\t\t\t\t\t\n ");
	    	        sb.append(" \tPROGRESS_STATUS,\t\t\t\t\t\n ");
	    	        sb.append(" \tREGISTRY_FLAG,\t\t\t\t\t\t\n ");
	    	        sb.append(" \tS_TEMPLATE_REFITEM,\t\t\t\t\t\n ");
	    	        sb.append(" \tC_TEMPLATE_REFITEM,\t\t\t\t\t\n ");
	    	        sb.append(" \tREQ_DATE,\t\t\t\t\t\t\t\n ");
	    	        sb.append(" \tVENDOR_CODE,\t\t\t\t\t\t\n ");
	    	        sb.append(" \tSG_REFITEM,\t\t\t\t\t\t\t\n ");
	    	        sb.append(" \tAPPLY_FLAG,\t\t\t\t\t\t\t\n ");
	    	        sb.append(" \tADD_DATE,\t\t\t\t\t\t\t\n ");
	    	        sb.append(" \tADD_USER_ID\t\t\t\t\t\t\t\n ");
	    	        sb.append(" ) \n ");
	
	    	        sb.append(" ( \n ");
	    	        sb.append(" \tselect \t \n ");
	    	        sb.append(" \tSELLER_SG_REFITEM,        \t \n ");
	    	        sb.append(" \tPROGRESS_STATUS,          \t \n ");
	    	        sb.append(" \tREGISTRY_FLAG,          \t \n ");
	    	        sb.append(" \tS_TEMPLATE_REFITEM,       \t \n ");
	    	        sb.append(" \tC_TEMPLATE_REFITEM,       \t \n ");
	    	        sb.append(" \tREQ_DATE,       \t \n ");
	    	        sb.append(" \tVENDOR_CODE,           \t \n ");
	    	        sb.append(" \tAPPLY_FLAG, \t \n ");
	    	        sb.append(" \t?,       \t \n "); sm.addStringParameter(add_date+"");
	    	        sb.append(" \tADD_USER_ID        \t \n ");
	    	        sb.append(" \tFROM SSGVN\t \n ");
	    	        sb.append(" \tWHERE subStr(ADD_DATE,1,4) = ?"); sm.addStringParameter((add_date - 1)+"");
	    	        sb.append(" )\t \n ");
	    	        sm.doInsert(sb.toString());
	    	        Commit();
    	        }

    	        sm.removeAllValue();
    	        sb.delete(0, sb.length());
    	        sb.append(" SELECT\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n");
    	        sb.append(" \tGETSGNAME1(PARENT1) AS sg_type1                                                                 \t\t\t\n");
    	        sb.append(" \t, GETSGNAME1(PARENT2) AS sg_type2\t\t\t\t\t\t\t\n");
    	        sb.append(" \t, GETSGNAME1(SG) AS sg_type3\t\t\t\t\t\t\t\t\n");
    	        sb.append(" \t, APPLY_FLAG                                                               \t\t\t\n");
    	        sb.append(" \t, SELLER_SG_REFITEM                                                               \t\t\t\n");
    	        sb.append(" FROM                \t                                               \t\t\t\n");
    	        sb.append(" (                                                               \t\t             \t        \t\t\t\n");
    	        sb.append(" \tSELECT                                                       \t\t             \t        \t\t\t\n");
    	        sb.append(" \t\t   (SELECT PARENT_SG_REFITEM                             \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t   FROM SSGGL                                  \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t  WHERE SG_REFITEM = B.PARENT_SG_REFITEM\t             \t        \t\t\t\n");
    	        sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	        sm.addStringParameter(SepoaDate.getYear()+"");
    	        sb.append(" \t\t\t) AS PARENT1                      \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,B.PARENT_SG_REFITEM AS PARENT2                      \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.SG_REFITEM AS SG                                  \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.VENDOR_CODE AS VENDOR_CODE                          \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.SELLER_SG_REFITEM              \t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,B.NOTICE_FLAG   \t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \t\t\t,A.APPLY_FLAG   \t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \tFROM \tSSGGL B, SSGVN A          \t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \tWHERE\t1=1\t\t\t\t\t             \t        \t\t\t\n");
    	        sb.append(" \tAND     A.SG_REFITEM = B.SG_REFITEM                          \t\t             \t        \t\t\t\n");
    	        sb.append(" \tAND\t\tB.LEVEL_COUNT = '3'                                  \t             \t        \t\t\t\n");
    	        sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(B.ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	        sm.addStringParameter(SepoaDate.getYear()+"");
    	        sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(A.ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	        sm.addStringParameter(SepoaDate.getYear()+"");
    	        sb.append(" \tORDER BY PARENT1, PARENT2, SG, VENDOR_CODE                    \t\t             \t        \t\t\t\n");
    	        sb.append(" )                                                    \t\t             \t                                               \t\t\t\n");
    	        sb.append("WHERE\t1=1\t\t\t\t\t\t\t\t\t\t\n");
    	        sb.append(sm.addSelectString("   AND  VENDOR_CODE  = ?                           \t\n")); sm.addStringParameter(company_code);
    	        sb.append("\n");
                
    	        Logger.debug.println(this.info.getSession("ID"), this, "MenuUpdate=" + sb.toString());
                
    	        rtn[0] = sm.doSelect(sb.toString());
    	        setValue(rtn[0]);
    	    }
	    } catch (Exception e) {
//	    	e.printStackTrace();
	    	setMessage(e.getMessage());
	    	setStatus(0);
	    	setFlag(false);
	    	Logger.debug.println(this.info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//	    	System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
	    }
    	return getSepoaOut();
    }
    
    public SepoaOut sg_addRowCheck(String sg_type1, String sg_type2, String sg_type3, String company_code, String company_name) throws Exception
    {
    	try
    	{
    		String[] rtn = new String[1];
	        setStatus(1);
	        setFlag(true);
	
	        ConnectionContext ctx = getConnectionContext();
	        StringBuffer sb = new StringBuffer();
	        ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);
	        SepoaFormater sf = null;
	
	        sm.removeAllValue();
	        sb.delete(0, sb.length());
	        sb.append("                      SELECT \t\t\t\t\t\t\t\t\t\n ");
	        sb.append("                               NVL(COUNT(*),0) CNT\t\t\t\t\n ");
	        sb.append("                      FROM     SSGVN\t\t\t\t\t\t\t\t\n ");
	        sb.append("                      WHERE    1=1\t\t\t\t\t\t\t\t\n ");
	        sb.append(sm.addFixString("      AND      VENDOR_CODE          = ?\t\t\t\n ")); sm.addStringParameter(company_code);
	        sb.append(sm.addFixString("      AND      SG_REFITEM           = ?\t\t\t\n ")); sm.addStringParameter(sg_type3);
	        sb.append(sm.addSelectString(" \t AND\t  SUBSTR(ADD_DATE,1,4) = ?          \n ")); sm.addStringParameter(SepoaDate.getYear()+"");
	        sb.append(" \t                 AND\t  DEL_FLAG             = 'N'        \n ");
	
	        sf = new SepoaFormater(sm.doSelect(sb.toString()));
	        rtn[0] = sf.getValue("CNT", 0);
	
	        setValue(rtn[0]);
    	} catch (Exception e) {
//	        e.printStackTrace();
	        setMessage(e.getMessage());
	        setStatus(0);
	        setFlag(false);
	        Logger.debug.println(this.info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//	        System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
    	}
    	return getSepoaOut();
    }
    
    

    public SepoaOut supplycompany_insert(String[][] bean_args, String company_code) throws Exception
    {
    	try
    	{
	    	String[] rtn = new String[2];
	        setStatus(1);
	        setFlag(true);
	
	        ConnectionContext ctx = getConnectionContext();
	        StringBuffer sb = new StringBuffer();
	        String language = this.info.getSession("LANGUAGE");
	        String House_code = this.info.getSession("HOUSE_CODE");
	        String ID = this.info.getSession("ID");
	        SepoaFormater sf = null;
	
	        ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);
	
	        for (int i = 0; i < bean_args.length; i++) {
	        	String sg_type1 = bean_args[i][0];
	        	String sg_type2 = bean_args[i][1];
	        	String sg_type3 = bean_args[i][2];
	        	String apply_flag = bean_args[i][3];
	        	String seller_sg_refitem = bean_args[i][4];
	
	        	sm.removeAllValue();
	        	sb.delete(0, sb.length());
	            sb.append(" SELECT \t\t\t\t\t\t\t\n ");
	            sb.append("      NVL(COUNT(*),0) CNT\t\t\n ");
	            sb.append(" FROM ssgvn\t\t\t\t\t\t\n ");
	            sb.append(" WHERE  1=1\t\t\t\t\t\t\t\t\n ");
	            sb.append(sm.addFixString("   AND  VENDOR_CODE = ?\t\t\t\t\t\n ")); sm.addStringParameter(company_code);
	            sb.append(sm.addFixString("   AND  SG_REFITEM = ?\t\t\t\t\t\n ")); sm.addStringParameter(sg_type3);
	            sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
	            sm.addStringParameter(SepoaDate.getYear()+"");
	
	            sf = new SepoaFormater(sm.doSelect(sb.toString()));
	
	            if (Integer.parseInt(sf.getValue("CNT", 0)) == 0)
	            {
		            sm.removeAllValue();
		            sb.delete(0, sb.length());
		            sb.append(" INSERT INTO ssgvn\t(\t\t\t\t\n ");
		            sb.append(" \tSELLER_SG_REFITEM,\t\t\t\t\t\n ");
		            sb.append(" \tPROGRESS_STATUS,\t\t\t\t\t\n ");
		            sb.append(" \tREGISTRY_FLAG,\t\t\t\t\t\t\n ");
		            sb.append(" \tS_TEMPLATE_REFITEM,\t\t\t\t\t\n ");
		            sb.append(" \tC_TEMPLATE_REFITEM,\t\t\t\t\t\n ");
		            sb.append(" \tREQ_DATE,\t\t\t\t\t\t\t\n ");
		            sb.append(" \tVENDOR_CODE,\t\t\t\t\t\t\n ");
		            sb.append(" \tSG_REFITEM,\t\t\t\t\t\t\t\n ");
		            sb.append(" \tAPPLY_FLAG,\t\t\t\t\t\t\t\n ");
		            sb.append(" \tADD_DATE,\t\t\t\t\t\t\t\n ");
		            sb.append(" \tADD_USER_ID\t\t\t\t\t\t\t\n ");
		            sb.append(" \t) VALUES (\t\t\t\t\t\t\t\n ");
		            sb.append(" \t( select max(to_number(SELLER_SG_REFITEM))+1 from ssgvn ),\t\t\t\t\n ");
		            sb.append(" \t'0',\t\t\t\t\t\t\t\t\n ");
		            sb.append(" \t'Y',\t\t\t\t\t\t\t\t\n ");
		            sb.append(" \t'1',\t\t\t\t\t\t\t\t\n ");
		            sb.append(" \t'0',\t\t\t\t\t\t\t\t\n ");
		            sb.append(" \t'" + SepoaDate.getShortDateString() + "',\t\t\n ");
		
		            sb.append(" \t'" + company_code + "',\t\t\t\t\t\n ");
		            sb.append(" \t'" + sg_type3 + "',\t\t\t\t\t\n ");
		            sb.append(" \t?,\t\t\t\t\t\t\t\t\t\n "); sm.addStringParameter(apply_flag);
		            sb.append(" \t?,\t\t\t\t\t\t\t\t\t\n "); sm.addStringParameter(SepoaDate.getShortDateString());
		            sb.append(" \t?\t\t\t\t\t\t\t\t\t\n "); sm.addStringParameter(ID);
		            sb.append(" \t)\t\t\t\t\t\t\t\t\t\n ");
		
		            sm.doInsert(sb.toString());
	            } else {
		            sm.removeAllValue();
		            sb.delete(0, sb.length());
		            sb.append(" UPDATE ssgvn\t\t\t\t\t\t\t\n ");
		            sb.append(" SET\t REGISTRY_FLAG   = 'Y',\t\t\t\t\n ");
		            sb.append(" \t \t APPLY_FLAG  = ?,\t\t\t\t\n "); sm.addStringParameter(apply_flag);
		            sb.append(" \t \t    DEL_FLAG = 'N'\t\t\t\t\n ");
		            sb.append(" WHERE  1=1\t\t\t\t\t\t\t\t\n ");
		            sb.append("   AND  SG_REFITEM = ?\t\t\t\t\t\n "); sm.addStringParameter(sg_type3);
		            sb.append("   AND  VENDOR_CODE = ?\t\t\t\t\t\n "); sm.addStringParameter(company_code);
		            sb.append("   AND\t\tSUBSTR(ADD_DATE,1,4) = ?                                  \t   \t\t\t\n");
		            sm.addStringParameter(SepoaDate.getYear()+"");
		            sm.doUpdate(sb.toString());
	            }
	        }
	        Commit();
    	} catch (Exception e) {
//	        e.printStackTrace();
	        setMessage(e.getMessage());
	        setStatus(0);
	        setFlag(false);
	        Logger.debug.println(this.info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//	        System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
    	}
    	return getSepoaOut();
    }
    
    public SepoaOut vendor_del_Check(String sg_type3, String vendor_code) throws Exception
    {
    	try
    	{
    		String[] rtn = new String[1];
    		setStatus(1);
    		setFlag(true);

            ConnectionContext ctx = getConnectionContext();
            StringBuffer sb = new StringBuffer();
            ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);
            SepoaFormater sf = null;
            String sql = "";
            
            sm.removeAllValue();
            sb.delete(0, sb.length());
            sb.append("\t\t\t\t\t\tSELECT COUNT(*) AS CNT                  \n ");
            sb.append("\t\t\t\t\t\tFROM   SINVN                            \n ");
            sb.append("\t\t\t\t\t\tWHERE  1=1                              \n ");
            sb.append("\t\t\t\t\t\tAND    NVL(DEL_FLAG,'N') = 'N'          \n ");
            sb.append(sm.addSelectString("\tAND    SG_REGITEM  = ?  \t\t\t\t\n ")); sm.addStringParameter(sg_type3);
            sb.append(sm.addSelectString("\tAND    VENDOR_CODE = ?  \t\t\t\t\n ")); sm.addStringParameter(vendor_code);
            
            sf = new SepoaFormater(sm.doSelect(sb.toString()));
            rtn[0] = sf.getValue("CNT", 0);
            
            setValue(rtn[0]);
    	} catch (Exception e) {
//    		e.printStackTrace();
    		setMessage(e.getMessage());
    		setStatus(0);
    		setFlag(false);
    	}
    	return getSepoaOut();
    }
    
    public SepoaOut supplycompany_delete(String[][] bean_args) throws Exception
    {
    	try
	    {
    		String[] rtn = new String[2];
	        setStatus(1);
	        setFlag(true);
            
	        ConnectionContext ctx = getConnectionContext();
	        StringBuffer sb = new StringBuffer();
	        String language = this.info.getSession("LANGUAGE");
	        String House_code = this.info.getSession("HOUSE_CODE");
	        String ID = this.info.getSession("ID");
	        SepoaFormater sf = null;
            
	        ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);
            
	        for (int i = 0; i < bean_args.length; i++) {
	        	String sg_type1 = bean_args[i][0];
	        	String sg_type2 = bean_args[i][1];
	        	String sg_type3 = bean_args[i][2];
	        	String apply_flag = bean_args[i][3];
	        	String seller_sg_refitem = bean_args[i][4];

	        	sm.removeAllValue();
	        	sb.delete(0, sb.length());
	        	sb.append(" UPDATE ssgvn\t\t\t\t\t\n ");
	        	sb.append(" \tSET DEL_FLAG = 'Y'\t\t\t\t\t\t\n ");
	        	sb.append(" \tWHERE 1=1\t\t\t\t\t\t\n ");
	        	sb.append(" \tAND SG_REFITEM = ?\t\t\t\t\n "); sm.addStringParameter(sg_type3);
	        	sb.append(" \tAND SELLER_SG_REFITEM = ?\t\t\n "); sm.addStringParameter(seller_sg_refitem);
	        	sb.append(" \tAND\t\tSUBSTR(ADD_DATE,1,4) = ?                                  \t   \t\t\t\n");
	        	sm.addStringParameter(SepoaDate.getYear()+"");
	        	sm.doDelete(sb.toString());
	        }

	        Commit();
	    } catch (Exception e) {
////	    	e.printStackTrace();
//	    	setMessage(e.getMessage());
	    	setStatus(0);
	    	setFlag(false);
	    	Logger.debug.println(this.info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//	    	System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
	    }
    	return getSepoaOut();
    }
    
    public SepoaOut sg_supplycompany_list_search(String company_code, String sg_type1, String sg_type2, String sg_type3) throws Exception {
    	try
    	{
    		String[] rtn = new String[2];
    	    setStatus(1);
    	    setFlag(true);

    	    ConnectionContext ctx = getConnectionContext();
    	    StringBuffer sb = new StringBuffer();
    	    String language = this.info.getSession("LANGUAGE");

    	    ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);

    	    sm.removeAllValue();
    	    sb.delete(0, sb.length());
    	    sb.append(" SELECT                                                                                                                 \n");
    	    sb.append("  \tGETSGNAME1(A.PARENT1) AS SG_TYPE1       \n");
    	    sb.append("  \t,GETSGNAME1(A.PARENT2) AS SG_TYPE2       \n");
    	    sb.append("  \t,GETSGNAME1(A.SG_REFITEM) AS SG_TYPE3       \n");
    	    sb.append("  \t, A.SG_REFITEM\t\t\t\t\t\t\t\t\t\t\t\t\t   \n");
    	    sb.append("  \t, A.APPLY_FLAG                                                                                                     \n");
    	    sb.append("  \t, A.VENDOR_CODE                                                                                                    \n");
    	    sb.append("  \t, B.VENDOR_NAME_LOC AS VENDOR_NAME_LOC                                                                                               \n");
    	    sb.append("  \t, A.seller_sg_refitem                                                                                              \n");
    	    sb.append("  FROM                                                                                                                  \n");
    	    sb.append("  (                                                                                                                     \n");
    	    sb.append("  \tSELECT                                                                                                             \n");
    	    sb.append("  \t\t   (SELECT PARENT_SG_REFITEM                                                                               \n");
    	    sb.append("  \t\t\t   FROM SSGGL                                                                                      \n");
    	    sb.append(" \t\t\t  WHERE SG_REFITEM = B.PARENT_SG_REFITEM\t             \t        \t\t\t\n");
    	    sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	    sm.addStringParameter(SepoaDate.getYear()+"");
    	    sb.append(" \t\t\t) AS PARENT1                      \t             \t        \t\t\t\n");
    	    sb.append("  \t\t\t,B.PARENT_SG_REFITEM AS PARENT2                                                                    \n");
    	    sb.append("  \t\t\t,A.SG_REFITEM                                                                                      \n");
    	    sb.append("  \t\t\t,A.VENDOR_CODE AS VENDOR_CODE                                                                      \n");
    	    sb.append("  \t\t\t,A.SELLER_SG_REFITEM                                                                               \n");
    	    sb.append("  \t\t\t,B.NOTICE_FLAG                                                                                     \n");
    	    sb.append("  \t\t\t,A.APPLY_FLAG                                                                                      \n");
    	    sb.append("             ,A.DEL_FLAG                                                                                            \n");
    	    sb.append("  \tFROM \tSSGGL B, SSGVN A                                                                                           \n");
    	    sb.append("  \tWHERE\t1=1                                                                                                        \n");
    	    sb.append("  \tAND     A.SG_REFITEM = B.SG_REFITEM                                                                                \n");
    	    sb.append("  \tAND\t\tB.LEVEL_COUNT = '3'                                                                                \n");
    	    sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(B.ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	    sm.addStringParameter(SepoaDate.getYear()+"");
    	    sb.append(sm.addSelectString(" \tAND\t\tSUBSTR(A.ADD_DATE,1,4) = ?                                  \t   \t\t\t\n"));
    	    sm.addStringParameter(SepoaDate.getYear()+"");
    	    sb.append("  \tORDER BY PARENT1, PARENT2, SG_REFITEM, VENDOR_CODE                                                                 \n");
    	    sb.append("  )A , ICOMVNGL B                                                                                                       \n");
    	    sb.append(" WHERE\t1=1                                                                                                        \n");
    	    sb.append(" AND A.VENDOR_CODE = B.VENDOR_CODE                                                                                      \n");
    	    sb.append(" AND\tA.DEL_FLAG ='N'                                                                                                        \n");
    	    sb.append(sm.addSelectString(" and a.PARENT1 = ?                                                                          \n"));
    	    sm.addStringParameter(sg_type1);
    	    sb.append(sm.addSelectString(" and a.PARENT2 = ?                                                                          \n"));
    	    sm.addStringParameter(sg_type2);
    	    sb.append(sm.addSelectString(" and a.sg_refitem = ?                                                                          \n"));
    	    sm.addStringParameter(sg_type3);
    	    sb.append(sm.addSelectString("   AND  A.VENDOR_CODE  = ?                           \t\n")); sm.addStringParameter(company_code);

    	    Logger.debug.println(this.info.getSession("ID"), this, "MenuUpdate=" + sb.toString());

    	    rtn[0] = sm.doSelect(sb.toString());

    	    setValue(rtn[0]);
    	} catch (Exception e) {
//    		e.printStackTrace();
    	    setMessage(e.getMessage());
    	    setStatus(0);
    	    setFlag(false);
    	    Logger.debug.println(this.info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//    	    System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
    	}
    	return getSepoaOut();
    }
    
    public SepoaOut sg_list_supplycompany_insert(String[][] bean_args) throws Exception {
    	try
    	{
    		String[] rtn = new String[2];
    	    setStatus(1);
    	    setFlag(true);

    	    ConnectionContext ctx = getConnectionContext();
    	    StringBuffer sb = new StringBuffer();
    	    String language = this.info.getSession("LANGUAGE");
    	    String House_code = this.info.getSession("HOUSE_CODE");
    	    String ID = this.info.getSession("ID");
    	    SepoaFormater sf = null;

    	    ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);

    	    for (int i = 0; i < bean_args.length; i++) {
    	    	String sg_type1 = bean_args[i][0];
    	        String sg_type2 = bean_args[i][1];
    	        String sg_type3 = bean_args[i][2];
    	        String vendor_code = bean_args[i][3];
    	        String vendor_name_loc = bean_args[i][4];
    	        String apply_flag = bean_args[i][5];
    	        String seller_sg_refitem = bean_args[i][6];

    	        sm.removeAllValue();
    	        sb.delete(0, sb.length());
    	        sb.append("                      SELECT \t\t\t\t\t\t\t\t\t\n ");
    	        sb.append("                               NVL(COUNT(*),0) CNT\t\t\t\t\n ");
    	        sb.append("                      FROM     SSGVN\t\t\t\t\t\t\t\t\n ");
    	        sb.append("                      WHERE    1=1\t\t\t\t\t\t\t\t\n ");
    	        sb.append(sm.addFixString("      AND      VENDOR_CODE          = ?\t\t\t\n ")); sm.addStringParameter(vendor_code);
    	        sb.append(sm.addFixString("      AND      SG_REFITEM           = ?\t\t\t\n ")); sm.addStringParameter(sg_type3);
    	        sb.append(sm.addSelectString(" \t AND\t  SUBSTR(ADD_DATE,1,4) = ?          \n ")); sm.addStringParameter(SepoaDate.getYear()+"");
    	        sb.append(" \t                 AND\t  DEL_FLAG             = 'N'        \n ");

    	        sf = new SepoaFormater(sm.doSelect(sb.toString()));

    	        if (Integer.parseInt(sf.getValue("CNT", 0)) == 0) {
    	        	sm.removeAllValue();
    	        	sb.delete(0, sb.length());
    	        	sb.append(" INSERT INTO SSGVN\t(\t\t\t\t                      \n ");
    	        	sb.append(" \t                  SELLER_SG_REFITEM\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,PROGRESS_STATUS\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,REGISTRY_FLAG\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,S_TEMPLATE_REFITEM\t\t\t\t  \n ");
    	            sb.append(" \t                 ,C_TEMPLATE_REFITEM\t\t\t\t  \n ");
    	            sb.append(" \t                 ,REQ_DATE\t\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,VENDOR_CODE\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,SG_REFITEM\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,APPLY_FLAG\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,ADD_DATE\t\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                 ,ADD_USER_ID\t\t\t\t\t\t  \n ");
    	            sb.append(" \t       ) VALUES (\t\t\t\t\t\t\t          \n ");
    	            sb.append(" \t                 (SELECT MAX(TO_NUMBER(SELLER_SG_REFITEM))+ 1 FROM SSGVN)   \t\t\t\t  \n ");
    	            sb.append(" \t                ,'0'\t\t\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                ,'Y'\t\t\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                ,'1'\t\t\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                ,'0'\t\t\t\t\t\t\t\t  \n ");
    	            sb.append(" \t                ,'" + SepoaDate.getShortDateString() + "' \n ");
    	            sb.append(" \t                ,'" + vendor_code + "'\t\t\t\t  \n ");
    	            sb.append(" \t                ,'" + sg_type3 + "'\t\t\t\t\t  \n ");
    	            sb.append(" \t                ,?\t\t\t\t\t\t\t\t\t  \n "); sm.addStringParameter(apply_flag);
    	            sb.append(" \t                ,?\t\t\t\t\t\t\t\t\t  \n "); sm.addStringParameter(SepoaDate.getShortDateString());
    	            sb.append(" \t                ,?\t\t\t\t\t\t\t\t\t  \n "); sm.addStringParameter(ID);
    	            sb.append(" \t       )\t\t\t\t\t\t\t\t\t          \n ");
    	            sm.doInsert(sb.toString());
    	        } else {
    	            sm.removeAllValue();
    	            sb.delete(0, sb.length());
    	            sb.append(" UPDATE SSGVN SET\t\t\t\t\t\t\t            \n ");
    	            sb.append("                   REGISTRY_FLAG       = 'Y'\t\t\t\t\n ");
    	            sb.append(" \t \t         ,APPLY_FLAG          = ?\t\t\t\t\n "); sm.addStringParameter(apply_flag);
    	            sb.append("        WHERE     1=1\t\t\t\t\t\t\t \t    \n ");
    	            sb.append("        AND       SG_REFITEM           = ?\t\t\t\t\n "); sm.addStringParameter(sg_type3);
    	            sb.append("        AND       VENDOR_CODE          = ?\t\t\t\t\n "); sm.addStringParameter(vendor_code);
    	            sb.append("        AND\t\t SUBSTR(ADD_DATE,1,4) = ?               \n "); sm.addStringParameter(SepoaDate.getYear()+"");
    	            sm.doUpdate(sb.toString());
    	        }
    	    }
    	    Commit();
    	} catch (Exception e) {
//    		e.printStackTrace();
    	    setMessage(e.getMessage());
    	    setStatus(0);
    	    setFlag(false);
    	    Logger.debug.println(this.info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//    	    System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
    	}
    	return getSepoaOut();
    }
   
    public SepoaOut sg_list_supplycompany_delete(String[][] bean_args) throws Exception {
    	
    	try
	    {
    		String[] rtn = new String[2];
    		setStatus(1);
    		setFlag(true);

    		ConnectionContext ctx = getConnectionContext();
	      	StringBuffer sb = new StringBuffer();
	      	String language = this.info.getSession("LANGUAGE");
	      	String House_code = this.info.getSession("HOUSE_CODE");
	      	String ID = this.info.getSession("ID");
	      	SepoaFormater sf = null;

	      	ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);

	      	for (int i = 0; i < bean_args.length; i++) {
	      		String sg_type1 = bean_args[i][0];
	      		String sg_type2 = bean_args[i][1];
	      		String sg_type3 = bean_args[i][2];
	      		String vendor_code = bean_args[i][3];
	      		String vendor_name_loc = bean_args[i][4];
	      		String apply_flag = bean_args[i][5];
	      		String seller_sg_refitem = bean_args[i][6];

	      		sm.removeAllValue();
	      		sb.delete(0, sb.length());
	      		sb.append("      UPDATE SSGVN SET \t\t\t\t\t                       \n ");
	      		sb.append(" \t                 DEL_FLAG             = 'Y'\t\t\t\t   \n ");
	        	sb.append(" \t        WHERE    1=1\t\t\t\t\t\t               \n ");
	        	sb.append(" \t        AND      SG_REFITEM           = ?\t\t\t\t   \n "); sm.addStringParameter(sg_type3);
	        	sb.append(" \t        AND      SELLER_SG_REFITEM    = ?\t\t           \n "); sm.addStringParameter(seller_sg_refitem);
	        	sb.append(" \t        AND\t\t SUBSTR(ADD_DATE,1,4) = ?                  \n "); sm.addStringParameter(SepoaDate.getYear()+"");

	        	sm.doDelete(sb.toString());
	      	}
	      	Commit();
	    }catch (Exception e){
//	    	e.printStackTrace();
	    	setMessage(e.getMessage());
	    	setStatus(0);
	    	setFlag(false);
	    	Logger.debug.println(this.info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
//	    	System.out.println(new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + " ERROR:" + e);
	    }
	    return getSepoaOut();
    }    
}