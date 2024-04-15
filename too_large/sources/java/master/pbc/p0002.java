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

package master.pbc;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
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
import sepoa.fw.util.SepoaRemote;
import sms.SMS;
import wisecommon.SignRequestInfo;
import wisecommon.SignResponseInfo;

public class p0002 extends SepoaService {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////           Session 정보를 담기위한 변수             //////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private String lang = "";
    //private Message msg = null;
    private HashMap<String,String> msg = null;
    
    public p0002(String opt, SepoaInfo info) throws Exception {
        super(opt, info);
        setVersion("1.0.0");

        lang = info.getSession("LANGUAGE");
        //msg = new Message(lang,"p11_ctr");
        Vector multilang_id = new Vector();
    	multilang_id.addElement("p11_ctr");
        msg = MessageUtil.getMessage(info,multilang_id);
       
    }
    
    /**
     * 보유홍보물현황 조회
     * @method getItemList
     * @since  2017-02-28
     * @modify 2017-02-28
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
     * 보유홍보물현황 조회 쿼리
     * @method et_getItemList
     * @since  2017-02-28
     * @modify 2017-02-28
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
			SepoaSQLManager sm =	new	SepoaSQLManager(info.getSession("ID"),this,ctx,wxp);  
			
			rtn	= sm.doSelect(header);  
  
			if(rtn == null)	throw new Exception("SQL Manager is	Null");  
		}catch(Exception e)	{  
			
		  throw	new	Exception("et_getItemList=========>"+e.getMessage());  
		} finally{  
		}  
		return rtn;     	
    }       
    
    public SepoaOut saveItemList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_saveItemList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
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
    
    private String[] et_saveItemList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();

		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String CRUD               = bean_info[i][0];
				
        		String DEPT               = bean_info[i][1];
        		String ITEM_NO            = bean_info[i][2];
        		
                String CRE_GB             = bean_info[i][3];
                String DSTR_GB            = ("".equals(bean_info[i][4]))?"2":bean_info[i][4];
                
                String STK_USER_ID        = bean_info[i][5];
                String STK_USER_NAME_LOC  = bean_info[i][6];
                String STK_DATE           = bean_info[i][7].replaceAll("/", "");
                String STK_TIME           = bean_info[i][8];
                
                String NTC_YN             = ("".equals(bean_info[i][9]))?"N":bean_info[i][9];;
                String NTC_LOC            = bean_info[i][10];
                String NTC_LOC_ETC        = bean_info[i][11];		                
                String NTC_USER_ID        = bean_info[i][12];
                String NTC_USER_NAME_LOC  = bean_info[i][13];
                String NTC_DATE           = bean_info[i][14].replaceAll("/", "");
                String NTC_TIME           = bean_info[i][15];
                                
                String ABOL_YN            = ("".equals(bean_info[i][16]))?"N":bean_info[i][16];;;
                String ABOL_USER_ID       = bean_info[i][17];
                String ABOL_USER_NAME_LOC = bean_info[i][18];
                String ABOL_DATE          = bean_info[i][19].replaceAll("/", "");
                String ABOL_TIME          = bean_info[i][20];
                                             
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				
				String[] args = null;
				String[] types = null;
				//존재하면 Update
				if("C".equals(CRUD)){
					sxp = new SepoaXmlParser(this, "et_insertItem_select2");
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

					args = new String[]{ info.getSession("HOUSE_CODE"), DEPT, ITEM_NO };
					sf = new SepoaFormater(ssm.doSelect_limit(args));

					
					// (생성구분 - 시스템) 이고 (배부구분 - 일괄배부) 이고 (부점의 품목이 폐기되었다면) 이면
					if("1".equals(CRE_GB) && "1".equals(DSTR_GB) && Integer.parseInt(sf.getValue("cnt", 0)) > 0){
						args = new String[]{ CRE_GB, DSTR_GB, NTC_YN, NTC_LOC, NTC_LOC_ETC, NTC_USER_ID, 
								NTC_USER_NAME_LOC , NTC_DATE, NTC_TIME, ABOL_YN, ABOL_USER_ID, 
								ABOL_USER_NAME_LOC, ABOL_DATE, ABOL_TIME    , info.getSession("HOUSE_CODE"), DEPT, 
								ITEM_NO};
						types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};

	                    sxp = new SepoaXmlParser(this, "et_updateItem2");
	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
	                    ssm.doUpdate(new String[][]{args}, types);
						
					}else{
						sxp = new SepoaXmlParser(this, "et_insertItem_select");
						ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());

						args = new String[]{ info.getSession("HOUSE_CODE"), DEPT, ITEM_NO };
						sf = new SepoaFormater(ssm.doSelect_limit(args));

						if(Integer.parseInt(sf.getValue("cnt", 0)) > 0){
							throw new Exception("보유중인 품목을 중복등록 불가합니다. - " + ITEM_NO );
						}
						
						// SepoaDate.getShortDateString(), SepoaDate.getShortTimeString()
						args = new String[]{ 
								info.getSession("HOUSE_CODE"), DEPT, ITEM_NO, CRE_GB, DSTR_GB, 
								STK_USER_ID, STK_USER_NAME_LOC, SepoaDate.getShortDateString(), SepoaDate.getShortTimeString(), NTC_YN, 
								NTC_LOC, NTC_LOC_ETC, NTC_USER_ID, NTC_USER_NAME_LOC  , NTC_DATE, 
								NTC_TIME, ABOL_YN, ABOL_USER_ID, ABOL_USER_NAME_LOC, ABOL_DATE, 
								ABOL_TIME
						};
						types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};

	                    sxp = new SepoaXmlParser(this, "et_insertItem");
	                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
	                    ssm.doInsert(new String[][]{args}, types);
					}
					                    
				}else{
					args = new String[]{ DSTR_GB, NTC_YN, NTC_LOC, NTC_LOC_ETC, NTC_USER_ID, 
							NTC_USER_NAME_LOC , NTC_DATE, NTC_TIME, ABOL_YN, ABOL_USER_ID, 
							ABOL_USER_NAME_LOC, ABOL_DATE, ABOL_TIME    , info.getSession("HOUSE_CODE"), DEPT, 
							ITEM_NO};
					types = new String[]{"S","S","S","S","S","S","S","S","S","S","S","S","S","S","S","S"};

                    sxp = new SepoaXmlParser(this, "et_updateItem");
                    ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                    ssm.doUpdate(new String[][]{args}, types);

				}
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
    
    public SepoaOut deleteItemList(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_deleteItemList(info, bean_args);

			if (rtn[1] != null)
			{
				setMessage(rtn[1]);
				Logger.debug.println(info.getSession("ID"), this, "_________ " + rtn[1]);
				setStatus(0);
				setFlag(false);
			}

			setValue(rtn[0]);
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

	private String[] et_deleteItemList(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sb = new StringBuffer();

		try
		{
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_info.length; i++)
			{
				String CRUD = bean_info[i][0];
				String CRE_GB = bean_info[i][1];  
				String DEPT = bean_info[i][2];
				String ITEM_NO = bean_info[i][3];

				if("2".equals(CRE_GB)){
									
					sm.removeAllValue();
					sb.delete(0, sb.length());
					sb.append(" delete from ICOYPBHD \n ");
					sb.append(" where HOUSE_CODE = ? \n "); sm.addStringParameter(info.getSession("HOUSE_CODE"));
					sb.append("   and DEPT = ? \n "); sm.addStringParameter(DEPT);
					sb.append("   and ITEM_NO = ? \n "); sm.addStringParameter(ITEM_NO);
					sm.doUpdate(sb.toString());
					
				}
				
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(info.getSession("ID"), this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
}