package sepoa.svc.procure;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.Session;

import mail.mail;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sms.SMS;
import wisecommon.SignRequestInfo;



public class PO_001 extends SepoaService
{

    Message msg = null/*new Message("KO","STDPO")*/;

    private String ctrl_code    = info.getSession( "CTRL_CODE" );

    public PO_001(String opt,SepoaInfo info) throws SepoaServiceException
    {
        super(opt,info);
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
    public String getConfig(String s)
	{
		try
		{
			Configuration configuration = new Configuration();
			s = configuration.get(s);

			return s;
		}
		catch (ConfigurationException configurationexception)
		{
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception)
		{
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}

		return null;
	}

    /**
	 * 검수 담당자 변경
	 * @param Transfer_person_id
	 * @param inv_no
	 * @return
	 */
	public SepoaOut charge_transfer( Map<String, Object> data ) {
		try {
			
			List<Map<String, String>> grid          = null;
			Map<String, String>       gridInfo      = null;
			Map<String, String> 	  header		= null;
			header = MapUtils.getMap(data, "headerData");
			grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			
			String Transfer_person_id = header.get("Transfer_person_id");
			String TAKE_TEL = header.get("TAKE_TEL");
			String[] po_no = new String[grid.size()];
			
			for(int i = 0 ; i < grid.size() ; i++ ){
				po_no[i] = grid.get(i).get("PO_NO");
			}

			Logger.debug.println(info.getSession("ID"), this, " Transfer_person_id ::" + Transfer_person_id);
			Logger.debug.println(info.getSession("ID"), this, " TAKE_TEL ::" + TAKE_TEL);
			int rtn = et_charge_transfer_doc(  Transfer_person_id, TAKE_TEL,   po_no);

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
	
	private int et_charge_transfer_doc( String Transfer_person_id, String TAKE_TEL, String[] po_no) throws Exception {

		ConnectionContext ctx = getConnectionContext();
		int rtn = 0;
		String house_code = info.getSession("HOUSE_CODE");
		String company_code = info.getSession("COMPANY_CODE");
		SepoaSQLManager sm = null;
		SepoaFormater wf = null;
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

		try {
			Logger.debug.println(info.getSession("ID"), this, "   inv_no.length  === > " + po_no.length);
			String[][] data = new String[po_no.length][];

            for(int	i =	0 ;	i <	po_no.length;	i++	) {
            	String[] tmp = {Transfer_person_id, TAKE_TEL, house_code, po_no[i]};
            	data [i] = tmp;
			}

//			sql.append("UPDATE ICOYIVHD                     \n");
//			sql.append("SET  INV_PERSON_ID = ?              \n");
//			sql.append("WHERE HOUSE_CODE = ?              \n");
//			sql.append("AND INV_NO   = ?                 \n");

			String[] type = { "S", "S", "S", "S"  };

				sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
			rtn = sm.doUpdate(data, type);


		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return rtn;
	}


/**
* 발주진행.
*/
//내  용 : 조회조건에 "청구부서"를 추가함
    
    public SepoaOut getPoTargetList(Map<String, Object> data){
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			header.put("from_date",SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "from_date", "")));
			header.put("to_date", SepoaString.getDateUnSlashFormat(MapUtils.getString(header, "to_date", "")));
			
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			sxp = new SepoaXmlParser(this, "getPoTargetList");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(header, customHeader));
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }

    /**
    * 직발주진행.
    */
        /*public SepoaOut getDiredtPoTargetSelect(String from_date
    						            , String to_date
    						            , String pr_no
    						            , String dept
    						            //, String ctrl_code
    						            ,String purchaser_id
    						            )
        {
            //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");

            try {

                String rtn = "";

    	        rtn = sel_getDiredtPoTargetSelect(from_date
    						              , to_date
    						              , pr_no
    						              , dept
    						              //, ctrl_code
    						              ,purchaser_id
    						              );

    			SepoaFormater wf = new SepoaFormater(rtn);
    			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
    			else {
    				setMessage(msg.getMessage("7000"));
    			}
                setValue(rtn);

                setStatus(1);

            }catch(Exception e)
            {
                Logger.err.println("Exception e =" + e.getMessage());
                setStatus(0);
                setMessage(msg.getMessage("7001"));
                Logger.err.println(this,e.getMessage());
            }
            return getSepoaOut();
        }

        private String sel_getDiredtPoTargetSelect(String from_date
                , String to_date
                , String pr_no
                , String dept
                //, String ctrl_code
                , String purchaser_id
                ) throws Exception
        {

    		String rtn = "";
    		String house_code = info.getSession("HOUSE_CODE");
    		String user_id = info.getSession("ID");

    		ConnectionContext ctx = getConnectionContext();

    		try {

    			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    			//wxp.addVar("ctrl_code", ctrl_code);
    			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
    			//String[] args = {house_code, exec_no, pr_no, from_date, to_date, dept, ctrl_code};
    			String[] args = {house_code, pr_no, from_date, to_date, dept, purchaser_id};

    			rtn = sm.doSelect(args);

    		}catch(Exception e) {
    			throw new Exception("sel_getDiredtPoTargetSelect:"+e.getMessage());
    		} finally{
    		}
    		return rtn;
    	}*/

    /*
     * 발주생성화면 품목정보조회
     */
 	public SepoaOut getPoInsert(Map<String, Object> data){
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");
    	setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		String rtn = "";
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			customHeader.put("exec_no", (String) data.get("exec_no"));
			customHeader.put("exec_seq", (String) data.get("exec_seq"));
			customHeader.put("exec_number", (String) data.get("exec_number"));
			customHeader.put("VENDOR_CODE",(String) data.get("VENDOR_CODE"));
			customHeader.put("PO_DIV_FLAG",(String) data.get("PO_DIV_FLAG"));
			Logger.debug.println("----------------------------> " + data.get("exec_seq"));
			sxp = new SepoaXmlParser(this, "getPoInsert");
//			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	rtn = ssm.doSelect(customHeader);
        	setValue(rtn);
        	
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
    }
    
    /*
     * 발주생성화면 품목정보조회
     
 	public SepoaOut getDirectPoCreateInfo(String pr_no, String vendor_code, String po_div_flag)
     {
         //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");

         try {

             String rtn = "";

 	        rtn = sel_getDirectPoCreateInfo(pr_no,vendor_code, po_div_flag);

 			SepoaFormater wf = new SepoaFormater(rtn);
 			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
 			else {
 				setMessage(msg.getMessage("7000"));
 			}
             setValue(rtn);

             setStatus(1);

         }catch(Exception e)
         {
             Logger.err.println("Exception e =" + e.getMessage());
             setStatus(0);
             setMessage(msg.getMessage("7001"));
             Logger.err.println(this,e.getMessage());
         }
         return getSepoaOut();
     }

    private String sel_getDirectPoCreateInfo(String pr_no, String vendor_code, String po_div_flag) throws Exception
    {


        String rtn = "";
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession("ID");

        ConnectionContext ctx = getConnectionContext();

        try {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            String[] args = {house_code,pr_no,vendor_code, po_div_flag};
			rtn = sm.doSelect(args);

        }catch(Exception e) {
        	throw new Exception("sel_getPoTargetSelect:"+e.getMessage());
        } finally{
        }
        return rtn;
    }

    *//**
     * 발주진행.
     *//*
    public SepoaOut getPoStatusSelect_B(String from_date
						             , String to_date
						             , String po_no
						             , String item_no
						             , String vendor_code
						             , String ctrl_person_id
						             , String dept
						             , String complete_mark
						             , String order_no
						             , String cust_name
						             , String wbs_name
						             , String po_name
						             , String ct_name
						             , String maker_name
						             , String req_dept
						            )
    {
        //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");

        try {

            String rtn = "";
	        rtn = sel_getPoStatusSelect_B(from_date
										, to_date
										, po_no
										, item_no
										, vendor_code
										, ctrl_person_id
										, dept
										, complete_mark
										, order_no
										, cust_name
							            , wbs_name
							            , po_name
							            , ct_name
							            , maker_name
							            , req_dept
										);

			SepoaFormater wf = new SepoaFormater(rtn);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
            setValue(rtn);

            setStatus(1);

        }catch(Exception e)
        {
            Logger.err.println("Exception e =" + e.getMessage());
            setStatus(0);
            setMessage(msg.getMessage("7001"));
            Logger.err.println(this,e.getMessage());
        }
        return getSepoaOut();
    }*/

    /*private String sel_getPoStatusSelect_B(String from_date
        	 , String to_date
        	 , String po_no
        	 , String item_no
        	 , String vendor_code
        	 , String ctrl_person_id
        	 , String dept
        	 , String complete_mark
        	 , String order_no
        	 , String cust_name
             , String wbs_name
             , String po_name
             , String ct_name
             , String maker_name
             , String req_dept
    		) throws Exception
	{

		//String cur_ctrl_code = DoWorkWithCtrl_code(ctrl_code);

		String rtn = "";
		String house_code = info.getSession("HOUSE_CODE");
		String user_id = info.getSession("ID");

		ConnectionContext ctx = getConnectionContext();
        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
        wxp.addVar("house_code", house_code);
        wxp.addVar("complete_mark", complete_mark);

		try {

//			sql.append(" 		   SELECT DT.PO_NO                                                                          \n");
//			sql.append(" 		   	  ,DT.ITEM_NO                                                                           \n");
//			sql.append(" 		   	  ,DT.DESCRIPTION_LOC                                                                   \n");
//			sql.append(" 			  ,DT.SPECIFICATION                 					   								\n");
//			sql.append(" 			  ,DT.MAKER_NAME                    					   								\n");
//			sql.append(" 			  ,DT.MAKER_CODE                 						   								\n");
//			sql.append(" 		   	  ,HD.PO_CREATE_DATE                                                                    \n");
//			sql.append(" 		   	  ,dbo.GETUSERNAMELOC(DT.HOUSE_CODE,DT.ADD_USER_ID) AS CHANGE_USER_NAME_LOC                 \n");
//			sql.append(" 		   	  ,DT.RD_DATE                                                                           \n");
//			sql.append(" 		   	  ,CNDT.CTR_NO                                                                          \n");
//			sql.append(" 		   	  ,HD.CUR                                                                               \n");
//			sql.append(" 		   	  ,DT.UNIT_PRICE                                                                        \n");
//			sql.append(" 		   	  ,DT.ITEM_AMT                                                                          \n");
//			sql.append(" 		   	  ,DT.CUSTOMER_PRICE                                                                    \n");
//			sql.append(" 		   	  ,DT.CUSTOMER_PRICE*DT.ITEM_QTY AS S_ITEM_AMT                                          \n");
//			sql.append(" 		   	  ,DT.DISCOUNT                                                                          \n");
//			sql.append(" 		   	  ,DT.UNIT_MEASURE                                                                      \n");
//			sql.append(" 		   	  ,DT.ITEM_QTY                                                                          \n");
//			sql.append(" 		   	  ,DT.GR_QTY	                                                                        \n");
//			sql.append(" 		   	  ,DT.VENDOR_CODE                                                                       \n");
//			sql.append(" 		   	  ,dbo.GETVENDORNAME(DT.HOUSE_CODE,DT.VENDOR_CODE) AS VENDOR_NAME                           \n");
//			sql.append(" 		   	  ,PRDT.PR_NO                                                                           \n");
//			sql.append(" 		   	  ,PRDT.UNIT_PRICE AS PR_PRICE                                                          \n");
//			sql.append(" 		   	  ,PRDT.PR_AMT                                                                          \n");
//			sql.append(" 		   	  ,PRHD.CUST_CODE                                                                       \n");
//			sql.append(" 		   	  ,HD.COMPLETE_MARK                                                                     \n");
//			sql.append(" 		   	  ,HD.SUBJECT                                                                    		\n");
//			sql.append(" 		   	  ,DT.QTA_NO                                                                    		\n");
//			sql.append(" 		   	  ,DT.EXEC_NO                                                                    		\n");
//			sql.append(" 		   	  ,HD.ORDER_NO                                                                    		\n");
//			sql.append(" 		   	  ,PRHD.PR_TYPE	                                                                        \n");
//			sql.append(" 		   FROM ICOYPODT DT, ICOYPOHD HD, ICOYPRDT PRDT, ICOYPRHD PRHD, ICOYCNDT CNDT               \n");
//			sql.append(" 		   WHERE DT.HOUSE_CODE 		= HD.HOUSE_CODE                                                 \n");
//			sql.append(" 		   AND   DT.PO_NO      		= HD.PO_NO                                                      \n");
//			sql.append(" 		   AND   PRHD.HOUSE_CODE 		=* DT.HOUSE_CODE                                               \n");
//			sql.append(" 		   AND   PRHD.PR_NO			=* DT.PR_NO                                               \n");
//			sql.append(" 		   AND   PRDT.HOUSE_CODE 		=* DT.HOUSE_CODE                                               \n");
//			sql.append(" 		   AND   PRDT.PR_NO			=* DT.PR_NO                                               \n");
//			sql.append(" 		   AND   PRDT.PR_SEQ			=* DT.PR_SEQ                                               \n");
//			sql.append(" 		   AND   CNDT.HOUSE_CODE 		=* DT.HOUSE_CODE                                               \n");
//			sql.append(" 		   AND   CNDT.EXEC_NO			=* DT.EXEC_NO                                               \n");
//			sql.append(" 		   AND   CNDT.EXEC_SEQ   		=* DT.EXEC_SEQ                                               \n");
//			sql.append(" 		   AND   HD.STATUS <> 'D'                                                                   \n");
//			sql.append(" 		   AND   DT.STATUS <> 'D'                                                                   \n");
//			sql.append(" <OPT=S,S> AND   DT.HOUSE_CODE   	= ? 													</OPT>  \n");
//			sql.append(" <OPT=S,S> AND   HD.PO_CREATE_DATE BETWEEN ? </OPT> <OPT=S,S> AND ? 						</OPT>  \n");
//			sql.append(" <OPT=S,S> AND   dbo.getDeptCodeByID(HD.HOUSE_CODE,HD.COMPANY_CODE,HD.ADD_USER_ID) = ?          </OPT>\n");
//			sql.append(" <OPT=S,S> AND   DT.PO_NO          	= ? 													</OPT>  \n");
//			sql.append(" <OPT=S,S> AND   DT.VENDOR_CODE    	= ? 													</OPT>  \n");
//			sql.append(" <OPT=S,S> AND   DT.ITEM_NO        	= ? 													</OPT>  \n");
//			sql.append(" <OPT=S,S> AND   DT.COMPLETE_MARK  	= ? 													</OPT>  \n");
//			sql.append(" <OPT=S,S> AND   PRHD.ORDER_NO	  	= ? 													</OPT>  \n");
//			sql.append(" <OPT=S,S> AND   HD.add_user_id	  	= ? 													</OPT>  \n");
//			sql.append(" 		  ORDER BY HD.CHANGE_DATE DESC, DT.PO_NO ASC, DT.PO_SEQ ASC                                 \n");


			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
			String[] args = {from_date, to_date, dept
			, po_no, vendor_code, item_no, order_no, ctrl_person_id
			, cust_name
            , wbs_name
            , po_name
            , ct_name
            , maker_name
            , req_dept
            };

			rtn = sm.doSelect(args);

		}catch(Exception e) {
			throw new Exception("sel_getPoStatusSelect:"+e.getMessage());
		} finally{
		}
		return rtn;
	}*/

    /*
     * 발주생성화면  추가사항 조회
     */
 	public SepoaOut getPoInsertInfo(String data) {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			Map<String, String> da =new HashMap(); 
			da.put("inv_no", data);
			
			sxp = new SepoaXmlParser(this, "getPoInsertInfo");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	setValue(ssm.doSelect(da));
        	
		}catch (Exception e){
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
 	
 	public SepoaOut setPoInsert(Map<String, Object> data) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			//Map<String, String> customHeader =  new HashMap<String, String>();
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			
			
			
			
			del_PO(header.get("PO_NO"));
			int rtn1 = in_ICOYPODT_DO(data); 
			int rtn2 = in_update_goods_group(header.get("PO_NO"));
			setValue("Insert Row="+rtn1);
			if(rtn1==0 || rtn2==0){
				Rollback();
                setStatus(0);
                setMessage(msg.getMessage("9003"));
                return getSepoaOut();
			}
			int dr = in_ICOYINDR(data);
			int rtnHD = in_ICOYPOHD_DO(data);
			int rtnPRDT = setPRDT(header.get("PO_NO"));
			if(rtnHD == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("4000"));
                return getSepoaOut();
			}
			
			updateCndt(header.get("PO_NO"));
			
			updatePodt(header.get("PO_NO"));
			
			/*if(header.get("SIGN_FLAG").equals("P"))
            {
				String company         =  info.getSession("COMPANY_CODE");
                String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
                String name_eng        =  info.getSession("NAME_ENG");
                String name_loc        =  info.getSession("NAME_LOC");
                String lang            =  info.getSession("LANGUAGE");
                
				wisecommon.SignRequestInfo sri = new wisecommon.SignRequestInfo();
				
				sri.setHouseCode(info.getSession("HOUSE_CODE"));
                sri.setCompanyCode(company);
                sri.setDept(info.getSession("DEPARTMENT"));
                sri.setReqUserId(info.getSession("ID"));
                sri.setDocType("POD");
                sri.setDocNo(header.get("PO_NO"));
                sri.setDocSeq("0");
                sri.setDocName(grid.get(0).get("SIGN_PERSON_ID"));
                sri.setItemCount(grid.size());
                sri.setSignStatus(header.get("SIGN_FLAG"));
                sri.setCur(grid.get(0).get("DELY_TERMS"));
                sri.setTotalAmt(Double.parseDouble(header.get("TTL_AMT")));

                sri.setSignString(header.get("approval_str")); // AddParameter 에서 넘어온 정보
                //int rtn =CreateApproval(info,sri);    //밑에 함수 실행
                if(rtn 1== 0) {
                    try {
                        Rollback();
                    } catch(Exception d) {
                        Logger.err.println(info.getSession("ID"),this,d.getMessage());
                    }
                    setStatus(0);
                    setMessage(msg.getMessage("0030"));
                    return getSepoaOut();
                }
                msg.setArg("PO_NO",po_no);
                setMessage("발주번호 "+po_no+"번으로 전송되었습니다.");
            }else if (header.get("SIGN_FLAG").equals("E")) {
    	    	String setData[][]	= {{header.get("PO_NO")}};
    			//발주품목의 RD_DATE 수정
    	    	setPODT(setData);
    			//구매요청의 PROCEEDING_FLAG 수정
    		}*/
			/*for(int i = 0; i < grid.size(); i++) {
				System.out.println("grid==="+grid);
				System.out.println("header===="+header);
			}*/
			//Rollback();
			
			
			if("P".equals(header.get("SIGN_FLAG"))){
				setPODCreateSignRequestInfo(header.get("PO_NO"), header.get("approval_str"), header.get("SUBJECT"), grid.size());
            }
			
			
            if(header.get("SIGN_FLAG").equals("T")){
            	setMessage("발주번호 "+header.get("PO_NO")+" 로 저장되었습니다.");
            }else if(header.get("SIGN_FLAG").equals("E")){
            	setMessage("발주번호 "+header.get("PO_NO")+" 로 해당 업체로 전송 되었습니다.");
            	
            	Map<String, String> smsParam = new HashMap<String, String>();
				
	  	    	smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
	  	    	smsParam.put("VENDOR_CODE", header.get("VENDOR_CODE"));
	  	    	smsParam.put("SUBJECT",     header.get("SUBJECT"));
				
				new SMS("NONDBJOB", info).po1Process(ctx, smsParam);
				new mail("NONDBJOB", info).po1Process(ctx, smsParam);
            }else if(header.get("SIGN_FLAG").equals("P")){
            	setMessage("발주번호 "+header.get("PO_NO")+" 로 결재요청 되었습니다.");
            }
            
            Commit();
			setStatus(1);
            setValue(header.get("PO_NO"));
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
 	
 	private void setPODCreateSignRequestInfo(String po_no, String pflag, String subject, int itemSize) {
		String              add_user_id       =  info.getSession("ID");
        String              house_code        =  info.getSession("HOUSE_CODE");
        String              company           =  info.getSession("COMPANY_CODE");
        String              add_user_dept     =  info.getSession("DEPARTMENT");
        int                 signRtn           = 0;

        SignRequestInfo sri = new SignRequestInfo();
        sri.setHouseCode(house_code);
        sri.setCompanyCode(company);
        sri.setDept(add_user_dept);
        sri.setReqUserId(add_user_id);
        sri.setDocType("POD");
        sri.setDocNo(po_no);
        sri.setDocSeq("0");
        sri.setDocName(subject);
        sri.setItemCount(itemSize);
        sri.setSignStatus("P");
        sri.setCur("KRW");
        sri.setTotalAmt(Double.parseDouble("0"));
        sri.setSignString(pflag); // AddParameter 에서 넘어온 정보
        
        try {
        	signRtn = CreateApproval(info,sri);    //밑에 함수 실행
        	
        	if(signRtn == 0) {
//        		System.out.println("Sign Rollback!");
        		Rollback();
        	}
			
		} catch (Exception e) {
			Logger.err.println("setPODCreateSignRequestInfo: = " + e.getMessage());
		}
	}
 	
 	private int CreateApproval(SepoaInfo info,SignRequestInfo sri) throws Exception
    {
        SepoaOut wo     = new SepoaOut();
        SepoaRemote ws  ;
        String nickName= "p6027";
        String conType = "NONDBJOB";
        String MethodName1 = "setConnectionContext";
        ConnectionContext ctx = getConnectionContext();

        try
        {
            Object[] obj1 = {ctx};
            String MethodName2 = "addSignRequest";
            Object[] obj2 = {sri};

            ws = new SepoaRemote(nickName,conType,info);
            ws.lookup(MethodName1,obj1);
            wo = ws.lookup(MethodName2,obj2);
        }catch(Exception e) {
//        	e.printStackTrace();
            Logger.err.println("approval: = " + e.getMessage());
        }
        return wo.status ;
    }	
 	
 	private int del_PO(String po_no) throws Exception{
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		
 		int rtn=-1;
 		try {
			Map<String, String> data = new HashMap(); 
			data.put("po_no", po_no);
        	sxp = new SepoaXmlParser(this, "del_PO_1");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn=ssm.doDelete(data);
			
			sxp = new SepoaXmlParser(this, "del_PO_2");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn=ssm.doDelete(data);
		}catch (Exception e){
			throw new Exception("del_PO:"+e.getMessage());
		}
 		
 		return rtn;
    }
 	
 	private int in_ICOYPODT_DO(Map<String, Object> data) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
 			
 			for(int i = 0; i < grid.size(); i++) {
 				String STR_FLAG         = "";
 				Map<String, String> header = MapUtils.getMap(data, "headerData");
 				
 				header.put("status", "C");
 				header.put("PO_SEQ",String.valueOf((i+1)*10));
 				header.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
 				header.put("SPACE", grid.get(i).get("SPACE"));
 				header.put("ITEM_NO", grid.get(i).get("ITEM_NO"));
 				header.put("MAKER_CODE",grid.get(i).get("MAKER_CODE"));
 				header.put("MAKER_NAME",grid.get(i).get("MAKER_NAME"));
 				header.put("UNIT_MEASURE",grid.get(i).get("UNIT_MEASURE"));
 				header.put("PO_QTY",grid.get(i).get("PO_QTY"));
 				header.put("UNIT_PRICE",grid.get(i).get("UNIT_PRICE"));
 				header.put("ITEM_AMT",grid.get(i).get("ITEM_AMT"));
 				header.put("RD_DATE",SepoaString.getDateUnSlashFormat(MapUtils.getString(grid.get(i), "RD_DATE", "")));
 				header.put("PRE_PO_NO",grid.get(i).get("PRE_PO_NO"));
 				header.put("PRE_PO_SEQ",grid.get(i).get("PRE_PO_SEQ"));
 				header.put("PR_DEPT",grid.get(i).get("PR_DEPT"));
 				header.put("PR_USER_ID",grid.get(i).get("PR_USER_ID"));
 				header.put("INFO_CREATE_TYPE","");
 				header.put("DELY_TO_ADDRESS",grid.get(i).get("DELY_TO_ADDRESS"));
 				header.put("DESCRIPTION_ENG","");
 				header.put("DESCRIPTION_LOC",grid.get(i).get("DESCRIPTION_LOC"));
 				header.put("SPECIFICATION",grid.get(i).get("SPECIFICATION"));
 				header.put("DELY_TO_LOCATION",grid.get(i).get("DELY_TO_LOCATION"));
 				if(grid.get(i).get("SPACE").equals("")){
 					STR_FLAG = "D";
 				}else{
 					STR_FLAG = "S";
 				}
 				header.put("STR_FLAG",STR_FLAG);
 				header.put("ACCOUNT_TYPE"," " );
 				header.put("Z_CODE2","");
 				header.put("Z_CODE3","");
 				header.put("QTA_NO",grid.get(i).get("QTA_NO"));
 				header.put("QTA_SEQ",grid.get(i).get("QTA_SEQ"));
 				header.put("PR_NO",grid.get(i).get("PR_NO"));
 				header.put("PR_SEQ",grid.get(i).get("PR_SEQ"));
 				header.put("EXEC_NO",grid.get(i).get("EXEC_NO"));
 				header.put("EXEC_SEQ",grid.get(i).get("EXEC_SEQ"));
 				header.put("CUSTOMER_PRICE",grid.get(i).get("CUSTOMER_PRICE"));
 				header.put("DISCOUNT", grid.get(i).get("DISCOUNT"));
 				header.put("CUST_CODE", grid.get(i).get("CUST_CODE"));
 				header.put("EXCHANGE_RATE", grid.get(i).get("EXCHANGE_RATE"));
 				header.put("PR_AMT", grid.get(i).get("PR_AMT"));
 				header.put("EXEC_AMT_KRW", grid.get(i).get("EXEC_AMT_KRW"));
 				header.put("ORDER_NO", grid.get(i).get("ORDER_NO"));
 				header.put("ORDER_SEQ", grid.get(i).get("ORDER_SEQ"));
 				header.put("WBS_NO", grid.get(i).get("WBS_NO"));
 				header.put("WBS_SUB_NO", grid.get(i).get("WBS_SUB_NO"));
 				header.put("WBS_TXT", grid.get(i).get("WBS_TXT"));
 				header.put("ORDER_COUNT", grid.get(i).get("ORDER_COUNT"));
 				header.put("WARRANTY", grid.get(i).get("WARRANTY"));
 				header.put("WBS_NAME", grid.get(i).get("WBS_NAME"));
 				
 				
 	        	sxp = new SepoaXmlParser(this, "in_ICOYPODT_DO");
 	        	sxp.addVar("language", info.getSession("LANGUAGE"));
 				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
 				rtn=ssm.doInsert(header);
 			}
 			
	 	}catch(Exception e) {
	    	throw new Exception("in_ICOYPODT:"+e.getMessage());
	    }
 		return rtn;
 	}
 	private int in_update_goods_group(String po_no) throws Exception{

    	int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try
		{
			Map<String, String> data = new HashMap(); 
			data.put("po_no", po_no);
        	sxp = new SepoaXmlParser(this, "in_update_goods_group_1");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf=new SepoaFormater(ssm.doSelect(data));
			if(sf.getRowCount() > 0){
				String goods_group = sf.getValue( 0, 0 );
				data.put("goods_group", goods_group);
				sxp = new SepoaXmlParser(this, "in_update_goods_group_2");
	        	sxp.addVar("language", info.getSession("LANGUAGE"));
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn=ssm.doUpdate(data);
			}
		}catch(Exception e)
		{
			throw new Exception("in_update_goods_group:"+e.getMessage());
		}
		return rtn;
 	}	
 	
 	private int in_ICOYINDR(Map<String, Object> data) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        try{
        	List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
        	for(int i = 0; i < grid.size(); i++) {
	        	Map<String, String> header = MapUtils.getMap(data, "headerData");
	        	
	        	header.put("PO_QTY", grid.get(i).get("PO_QTY"));
	        	header.put("ITEM_NO", grid.get(i).get("ITEM_NO"));
	        	sxp = new SepoaXmlParser(this, "in_ICOYINDR");
	        	sxp.addVar("language", info.getSession("LANGUAGE"));
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn=ssm.doUpdate(header);
        	}
        }catch(Exception e) {
            throw new Exception("in_ICOYINDR:"+e.getMessage());
        }
        return rtn;   
    }
 	
 	private int in_ICOYPOHD_DO(Map<String, Object> data) throws Exception
    {
        int rtn = -1;
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        ConnectionContext ctx = getConnectionContext();
        try{
        	List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
 			Map<String, String> header = MapUtils.getMap(data, "headerData");
 			header.put("STATUS", "C");
 			header.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
 			header.put("SPACE", grid.get(0).get("SPACE"));
 			header.put("ADD_USER_NAME", info.getSession("NAME_LOC"));
 			header.put("ORDER_NO", grid.get(0).get("ORDER_NO"));
        	
 			sxp = new SepoaXmlParser(this, "in_ICOYPOHD_DO");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn=ssm.doInsert(header);
        
        }catch(Exception e) {
            throw new Exception("in_ICOYPOHD_DO:"+e.getMessage());
        } finally{
        }
        return rtn;
        
    }
 	
 	private int setPRDT(String po_no) throws Exception{
 		int rtn=-1;
 		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        ConnectionContext ctx = getConnectionContext();
        try{
        	Map<String, String> data1 = new HashMap(); 
			data1.put("po_no", po_no);
        	sxp = new SepoaXmlParser(this, "setPRDT_1");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf=new SepoaFormater(ssm.doSelect(data1));
			for( int i = 0 ; i < sf.getRowCount(); i++ ){
				Map<String, String> data2 = new HashMap(); 
				String pr_no = sf.getValue( i,0 );
                String pr_seq = sf.getValue( i,1 );
                data2.put("pr_no", pr_no);
	        	data2.put("pr_seq", pr_seq);
	        	sxp = new SepoaXmlParser(this, "setPRDT_2");
	        	sxp.addVar("language", info.getSession("LANGUAGE"));
				ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
				rtn=ssm.doUpdate(data2);
			}
        	
        }catch(Exception e) {
        	throw new Exception("setPRDT:"+e.getMessage());
        }
        finally{
        }
 		return rtn;
 	 }
 	
 	private int updateCndt(String po_no) throws Exception{
 		int rtn=-1;
 		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        ConnectionContext ctx = getConnectionContext();
        String rtnSelect = null, _po_no = null, _po_seq = null, _exec_no = null, _exec_seq = null;
        try{
        	Map<String, String> data1 = new HashMap(); 
			data1.put("po_no", po_no);
        	sxp = new SepoaXmlParser(this, "updateCndt_1");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			sf=new SepoaFormater(ssm.doSelect(data1));
			if ( sf.getRowCount() > 0 ) {
				for (int i = 0; i < sf.getRowCount(); i++) {
					Map<String, String> data2 = new HashMap();
	            	_po_no = sf.getValue(i, 0);
	            	_po_seq = sf.getValue(i, 1);
	            	_exec_no = sf.getValue(i, 2);
	            	_exec_seq = sf.getValue(i, 3);
	            	 
					String pr_no = sf.getValue( i,0 );
	                String pr_seq = sf.getValue( i,1 );
	                data2.put("po_no", _po_no);
		        	data2.put("po_seq", _po_seq);
		        	data2.put("exec_no", _exec_no);
		        	data2.put("exec_seq", _exec_seq);
		        	sxp = new SepoaXmlParser(this, "updateCndt_2");
		        	sxp.addVar("language", info.getSession("LANGUAGE"));
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
					rtn=ssm.doUpdate(data2);
				}
			}
        }catch(Exception e) {
        	throw new Exception("updateCndt:"+e.getMessage());
        }
        finally{
        }
 		return rtn;
 	}
 	private int updatePodt(String po_no) throws Exception{
 		int rtn=-1;
 		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        ConnectionContext ctx = getConnectionContext();
        try{
        	Map<String, String> data = new HashMap();
    	 
	        data.put("po_no", po_no);
	    	sxp = new SepoaXmlParser(this, "updatePodt_1");
	    	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn=ssm.doUpdate(data);
        }catch(Exception e)
        {
            throw new Exception("updatePodt:"+e.getMessage());
        }
        return rtn;
 	}
 	
 	/*private int setPODT(String[][] setData) throws Exception{
 		int rtn=-1;
 		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        ConnectionContext ctx = getConnectionContext();
 		try{
 			Map<String, String> data = new HashMap();
 	    	
	        //data.put("po_no", po_no);
	    	sxp = new SepoaXmlParser(this, "setPODT");
	    	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn=ssm.doUpdate(data);
 		}catch(Exception e) {
     		throw new Exception("setPODT:"+e.getMessage());
     	} finally {
     	}
        return rtn;
 	}*/
    /*
     * 발주수정화면  추가사항 조회
     */
 	/*public SepoaOut getPoCreateInfo_2(String po_no)
     {
         //Message msg = new Message(info.getSession( "LANGUAGE" ),"STDPO");

         try {

             String rtn = "";

 	        rtn = sel_getPoCreateInfo_2(po_no);

 			SepoaFormater wf = new SepoaFormater(rtn);
 			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
 			else {
 				setMessage(msg.getMessage("7000"));
 			}
             setValue(rtn);

             setStatus(1);

         }catch(Exception e)
         {
             Logger.err.println("Exception e =" + e.getMessage());
             setStatus(0);
             setMessage(msg.getMessage("7001"));
             Logger.err.println(this,e.getMessage());
         }
         return getSepoaOut();
     }

    private String sel_getPoCreateInfo_2(String po_no) throws Exception
    {
        String rtn = "";
        String house_code = info.getSession("HOUSE_CODE");
        String user_id = info.getSession("ID");

        ConnectionContext ctx = getConnectionContext();

        try {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            wxp.addVar("house_code", info.getSession("HOUSE_CODE"));

            SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery());
            String[] args = {house_code, po_no};
			rtn = sm.doSelect(args);

        }catch(Exception e) {
        	throw new Exception("sel_getPoTargetSelect:"+e.getMessage());
        } finally{
        }
        return rtn;
    }*/

 	
 	public SepoaOut setPoInsertAll(String po_no, Map<String, String> grid) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		try {
			
			
			
			del_PO(po_no);
			grid.put("PO_NO", po_no);
			grid.put("PO_SEQ", "00001");
			grid.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
			int rtn1 = in_ICOYPODT_DO_all(grid); //podt insert
			int rtn2 = in_update_goods_group(po_no); 
			
			setValue("Insert Row="+rtn1);
			if(rtn1==0 || rtn2==0){
				Rollback();
                setStatus(0);
                setMessage(msg.getMessage("9003"));
                return getSepoaOut();
			}
			int dr = in_ICOYINDR_all(grid);
			
			int rtnHD = in_ICOYPOHD_DO_all(grid);
			
			int rtnPRDT = setPRDT(po_no);
			if(rtnHD == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("4000"));
                return getSepoaOut();
			}
			
			updateCndt(po_no);
			
			updatePodt(po_no);
			 
			
        	setMessage("발주번호 "+po_no+" 로 해당 업체로 전송 되었습니다.");
//        	System.out.println("발주번호 "+po_no+" 로 해당 업체로 전송 되었습니다.");
        	Map<String, String> smsParam = new HashMap<String, String>();
			
  	    	smsParam.put("HOUSE_CODE",  info.getSession("HOUSE_CODE"));
  	    	smsParam.put("VENDOR_CODE", grid.get("VENDOR_CODE"));
  	    	smsParam.put("SUBJECT",     grid.get("SUBJECT"));
			
			new SMS("NONDBJOB", info).po1Process(ctx, smsParam);
			new mail("NONDBJOB", info).po1Process(ctx, smsParam);
            
		    Commit();
			setStatus(1);
            setValue(po_no);
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

//  [R102204283448] [2022-05-06] (은행)전자구매 발주취소(연단가) 거래개선
//  위SR 개발로 인한 주석처리
// 	public SepoaOut setPoCancel(Map<String, String> grid) throws Exception  {
//		setStatus(1);
//		setFlag(true);
//		ConnectionContext ctx = getConnectionContext();
//		SepoaXmlParser sxp = null;
//		SepoaSQLManager ssm = null;
//		SepoaFormater sf = null;
//		Logger.err.println("===연단가발주 취소 서비스 시작===");
//		try {
//			sxp = new SepoaXmlParser( this, "sel_ICOYCNDT_cancel" );
//			ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
//			sf  = new SepoaFormater( ssm.doSelect( grid ) );
//			if(!sf.getValue("CNT", 0).equals("0")){
//				throw new Exception("해당 기안번호("+ grid.get("EXEC_NO") +")로 발주된 건이 존재합니다.");
//			}
//			grid.put("PO_SEQ", "00001");
//			grid.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
//			int rtn1 = in_ICOYPRDT_cancel(grid);
//			int rtn2 = in_ICOYCNHD_cancel(grid);
//			int rtn4 = in_ICOYCNDP_cancel(grid);
//			int rtn3 = in_ICOYCNDT_cancel(grid);
//			
//			setValue("Insert Row="+rtn1);
//			if(rtn1<0 || rtn2<0 || rtn3<0 || rtn4<0){
//				Rollback();
//                setStatus(0);
//                setMessage(msg.getMessage("9003"));
//                return getSepoaOut();
//			}
//
//        	setMessage("연단가발주 취소처리가 완료 되었습니다.");
////        	System.out.println("연단가발주 취소처리가 완료 되었습니다.");
//
//		    Commit();
//			setStatus(1);
//            setValue("");
//		}catch (Exception e){
//			try {
//                Rollback();
//            } catch(Exception d) {
//                Logger.err.println(userid,this,d.getMessage());
//            }
//			setFlag(false);
//			setMessage(e.getMessage().trim());
////            setValue(e.getMessage().trim());
//            setStatus(0);
//		}
//
//		return getSepoaOut();
//	}

//  [R102204283448] [2022-05-06] (은행)전자구매 발주취소(연단가) 거래개선
 	public SepoaOut setPoCancel(Map<String, Object> data) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		Logger.err.println("===연단가발주 취소 서비스 시작===");
		try {
			
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			for(int i = 0; i < grid.size(); i++) {
				Map<String, String> header = MapUtils.getMap(data, "headerData");
				header.put("PR_NO",grid.get(i).get("PR_NO"));
 				header.put("PR_SEQ",grid.get(i).get("PR_SEQ"));
 				header.put("EXEC_NO",grid.get(i).get("EXEC_NO"));
 				
				
				sxp = new SepoaXmlParser( this, "sel_ICOYCNDT_cancel" );
				ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
				sf  = new SepoaFormater( ssm.doSelect( header ) );
				if(!sf.getValue("CNT", 0).equals("0")){
					throw new Exception("해당 기안번호("+ grid.get(i).get("EXEC_NO") +")로 발주된 건이 존재합니다.");
				}
				int rtn1 = in_ICOYPRDT_cancel(header);
				int rtn2 = in_ICOYCNDT_cancel(header);			
				int rtn3 = in_ICOYCNHD_cancel(header);
				int rtn4 = in_ICOYCNDP_cancel(header);
				
				setValue("Insert Row="+rtn1);
				if(rtn1<0 || rtn2<0 || rtn3<0 || rtn4<0){
					Rollback();
	                setStatus(0);
	                setMessage(msg.getMessage("9003"));
	                return getSepoaOut();
				}
			}

        	setMessage("연단가발주 취소처리가 완료 되었습니다.");
//        	System.out.println("연단가발주 취소처리가 완료 되었습니다.");

		    Commit();
			setStatus(1);
            setValue("");
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			setFlag(false);
			setMessage(e.getMessage().trim());
//            setValue(e.getMessage().trim());
            setStatus(0);
		}

		return getSepoaOut();
	}
 	
 	private int in_ICOYPODT_DO_all(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 조회 인서트 한다. 			
			sxp = new SepoaXmlParser(this, "in_ICOYPODT_DO_all");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doInsert(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("in_ICOYPODT:"+e.getMessage());
	    }
 		return rtn;
 	}
 	
 	private int in_ICOYINDR_all(Map<String, String> grid) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        try{
        	//한로우씩 처리한다
    		sxp = new SepoaXmlParser(this, "in_ICOYINDR");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn=ssm.doUpdate(grid);
        	
        }catch(Exception e) {
            throw new Exception("in_ICOYINDR:"+e.getMessage());
        }
        return rtn;   
    }
 	
 	private int in_ICOYPOHD_DO_all(Map<String, String> grid) throws Exception
    {
        int rtn = -1;
        SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
        ConnectionContext ctx = getConnectionContext();
        try{
 			//header.put("STATUS", "C");
 			//header.put("COMPANY_CODE", info.getSession("COMPANY_CODE"));
 			//header.put("SPACE", grid.get(0).get("SPACE"));
 			//header.put("ADD_USER_NAME", info.getSession("NAME_LOC"));
 			//header.put("ORDER_NO", grid.get(0).get("ORDER_NO"));
        	
 			sxp = new SepoaXmlParser(this, "in_ICOYPOHD_DO_all");
        	sxp.addVar("language", info.getSession("LANGUAGE"));
			ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			rtn=ssm.doInsert(grid);
        
        }catch(Exception e) {
            throw new Exception("in_ICOYPOHD_DO:"+e.getMessage());
        } finally{
        }
        return rtn;
        
    }

 	private int in_ICOYPRDT_cancel(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 변경처리를 한다. 			
			sxp = new SepoaXmlParser(this, "in_ICOYPRDT_cancel");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("in_ICOYPRDT_cancel:"+e.getMessage());
	    }
 		return rtn;
 	}

 	private int in_ICOYCNHD_cancel(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 삭제처리를 한다. 			
			sxp = new SepoaXmlParser(this, "in_ICOYCNHD_cancel");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("in_ICOYCNHD_cancel:"+e.getMessage());
	    }
 		return rtn;
 	}

 	private int in_ICOYCNDT_cancel(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 삭제처리를 한다. 			
			sxp = new SepoaXmlParser(this, "in_ICOYCNDT_cancel");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("in_ICOYCNDT_cancel:"+e.getMessage());
	    }
 		return rtn;
 	}

 	private int in_ICOYCNDP_cancel(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 삭제처리를 한다. 			
			sxp = new SepoaXmlParser(this, "in_ICOYCNDP_cancel");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("in_ICOYCNDP_cancel:"+e.getMessage());
	    }
 		return rtn;
 	}
 	
 	public SepoaOut setExPoCancel(Map<String, String> grid) throws Exception  {
		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
		Logger.err.println("===발주취소(기안생성) 서비스 시작===");
		try {
			
//			grid.put("PO_SEQ", "00001");
//			grid.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		      
			sxp = new SepoaXmlParser( this, "sel_ICOYCNHD_expo_cancel" );
			ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
			sf  = new SepoaFormater( ssm.doSelect( grid ) );
			if(!sf.getValue("CNT", 0).equals("0")){
				throw new Exception("해당 기안번호("+ grid.get("EXEC_NO") +")로 발주된 건이 존재합니다.");
			}
			
			int rtn1 = up_ICOYCNHD_expo_cancel(grid);
			
			setValue("Insert Row="+rtn1);
			if(rtn1==0){
				Rollback();
                setStatus(0);
                setMessage(msg.getMessage("9003"));
                return getSepoaOut();
			}

        	setMessage("발주취소(기안생성) 처리가 완료 되었습니다.");
//        	System.out.println("발주취소(기안생성) 처리가 완료 되었습니다.");

		    Commit();
			setStatus(1);
            setValue("");
		}catch (Exception e){
			try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
			setFlag(false);
			setMessage(e.getMessage().trim());
//            setValue(e.getMessage().trim());
            setStatus(0);
		}

		return getSepoaOut();
	}
 	
 	private int up_ICOYCNHD_expo_cancel(Map<String, String> grid) throws Exception  {
 		ConnectionContext ctx = getConnectionContext();
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		SepoaFormater sf = null;
 		int rtn=-1;
 		try{
 			//대상건 삭제처리를 한다. 			
			sxp = new SepoaXmlParser(this, "up_ICOYCNHD_expo_cancel");
			sxp.addVar("language", info.getSession("LANGUAGE"));
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
        	
        	rtn=ssm.doUpdate(grid);
 			
	 	}catch(Exception e) {
	    	throw new Exception("up_ICOYCNHD_expo_cancel:"+e.getMessage());
	    }
 		return rtn;
 	}
}


