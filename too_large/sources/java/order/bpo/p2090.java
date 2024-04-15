/**
*
* Copyright 2001-2001 ICOMPIA Co., Ltd. All Rights Reserved.
* This software is the proprietary information of ICOMPIA Co., Ltd.
* @version        1.0
* Creater  : Andy Shin
* DESC     : 발주 중도종결(내자) 관련 Service
*/

package order.bpo;

import java.util.HashMap;
import java.util.Map;

import mail.SendMail;
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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
/*임시주석
import sms.SMS;
import mail.UserAuthentication;
import mail.mail;
import batch.jco.POTrans;
*/
import wisecommon.SignResponseInfo;


public class p2090 extends SepoaService {

    private Message msg =null;// new Message("STDPO");

    public p2090(String opt,SepoaInfo info) throws SepoaServiceException {
        super(opt,info);
        setVersion("1.0.0");
    } /** *Mainternace11 */

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
    //Header Query
    public SepoaOut getPOHeader(String po_no) {
        try {
            String rtn = "";

            rtn = et_getPOHeader(po_no);

			SepoaFormater wf = new SepoaFormater(rtn);
			/*if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}*/
            setValue(rtn);
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());

            setMessage(msg.getMessage("7004"));
            setStatus(0);
        }
        return getSepoaOut();
    }


    private String et_getPOHeader(String po_no) throws Exception
    {
        String rtn = "";
        ConnectionContext ctx = getConnectionContext();
        try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] args = {info.getSession("HOUSE_CODE"), po_no};

            rtn = sm.doSelect(args);

        }catch(Exception e) {
            Logger.err.println("et_getPOHeader=========>"+e.getMessage());
        } finally{
        }
        return rtn;
    }


    //발주수정시 Detail Query
    public SepoaOut getPOUPDDetail(String po_no) {
        try {
            String rtn = "";

            rtn = et_getPOUPDDetail(po_no);
			SepoaFormater wf = new SepoaFormater(rtn);
			/*if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}*/
            setValue(rtn);
            setStatus(1);
        }catch (Exception e){

			setMessage(msg.getMessage("7004"));
            setStatus(0);
        }
        return getSepoaOut();

    }


    private String et_getPOUPDDetail(String po_no) throws Exception
    {
        String rtn = "";
        ConnectionContext ctx = getConnectionContext();

        try {

			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] args = {info.getSession("HOUSE_CODE"), po_no};
            rtn = sm.doSelect(args);

        }catch(Exception e) {
            throw new Exception("et_getUPDPODetail=========>"+e.getMessage());
        }
        finally{
        }
        return rtn;
    }


    /***************************************************************************************************************
    * PID    : p2011.java
    * Create :
    * Change :
    * Source :
    * @ DR   :
    * @author
    ****************************************************************************************************************/

    public SepoaOut setPoDomCreateUpdate(String[][] PodtData,
                                        String[][] IndrData,
                                        String[][] PohdData,
                                        String sign_status,
                                        String company_code,
                                        String ttl_amt,
                                        String approval,
                                        String po_no
                                        )
    {
        try {

            int rtn1 = up_ICOYPODT_DO(PodtData);

            setValue("Insert Row="+rtn1);
			String[][] prData = new String[PodtData.length][3];
            if(rtn1 == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("9003"));
                return getSepoaOut();
            }

            int rtnHD = up_ICOYPOHD_DO(PohdData);
            if(rtnHD == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("4000"));
                return getSepoaOut();
            }

			int rtnPRDT = setPRDT(po_no);
            if(rtnPRDT == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("4000"));
                return getSepoaOut();
            }

            Object[] obj = {"U", po_no};

        	//SepoaOut value = CallNONDBJOB( ctx,  "POTrans", "sendSCI", obj);

      		//if(value.status == 0)
      		//	throw new Exception(value.message);

            int rtnU = upd_PIS_PO(PodtData);
            if(rtnU == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("4000"));
                return getSepoaOut();
            }


      		Commit();
            setStatus(1);
            updateCndt(po_no);

            if(sign_status.equals("P")){
            	setMessage("발주번호 "+po_no+" 로 결재요청 되었습니다.");
        	}else{
        		setMessage("발주번호 "+po_no+" 로 전송 되었습니다.");
        	}
        }catch(Exception e)
        {
        	try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setStatus(0);
            setMessage(e.getMessage().trim());
        }
        return getSepoaOut();
    }
    /* 발주중도종결 */
    /*
    public SepoaOut setPoIngStop	(
			    		String PR_USER_ID		,	String PR_USER_NAME	,	String VENDOR_CODE		,	String	VENDOR_NAME		,
			    		String CTRL_CODE		,
						String[] CUD_FG			,	String[] PR_NO		,	String[] PR_SEQ			,
						String[] PO_NO			,	String[] PO_SEQ		,
						String[] MATERIAL_TYPE	,
						String[] DELY_TO_ADDRESS,	String[] WARRANTY	,	String[] ITEM_NO		,	String[] DESCRIPTION_LOC,
						String[] MAKER_CODE		,	String[] MAKER_NAME	,	String[] SPECIFICATION	,	String[] PO_QTY			,	String[] OLD_PO_QTY			,
						String[] UNIT_MEASURE	,	String[] CUR		,	String[] EXCHANGE_RATE	,	String[] UNIT_PRICE		,
						String[] ITEM_AMT		,
						String[] PR_AMT			,	String[] WBS_NO		,	String[] WBS_NAME		,	String[] RD_DATE		,
						String[] ORDER_NO		,	String[] ORDER_COUNT,	String[] ORDER_SEQ		,	String[] CONTRACT_REMAIN
    							){

    	ConnectionContext 	ctx = 	getConnectionContext()	;
    	CallableStatement	cs	=	null					;
    	int ll_code		= 	0		;
    	String ls_msg	=	""		;
    	boolean	lb_fg	=	false	;
    	try {

    		cs	=	ctx.getConnection().prepareCall("{call PEPRO_PIS_SYNC(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)}");

    		for( int i = 0 ; i < CUD_FG.length ; i++ ){
    			Logger.sys.println("------------------------------------------------------------------");

    			Logger.sys.println(CUD_FG[i]);
    			Logger.sys.println(PR_NO[i]);
    			Logger.sys.println("PR_SEQ = " + PR_SEQ[i]);
    			Logger.sys.println(PO_NO[i]);
    			Logger.sys.println("PO_SEQ = " + PO_SEQ[i]);
    			Logger.sys.println(MATERIAL_TYPE[i]);
    			Logger.sys.println(DELY_TO_ADDRESS[i]);
    			Logger.sys.println(WARRANTY[i]);
    			Logger.sys.println(ITEM_NO[i]);
    			Logger.sys.println(DESCRIPTION_LOC[i]);
    			Logger.sys.println(MAKER_CODE[i]);
    			Logger.sys.println(MAKER_NAME[i]);
    			Logger.sys.println(SPECIFICATION[i]);
    			Logger.sys.println(Double.parseDouble(JspUtil.nullToRef(PO_QTY[i],"0")));
    			Logger.sys.println(Double.parseDouble(JspUtil.nullToRef(OLD_PO_QTY[i],"0")));
    			Logger.sys.println(UNIT_MEASURE[i]);
    			Logger.sys.println(CUR[i]);
    			Logger.sys.println(Double.parseDouble(JspUtil.nullToRef(EXCHANGE_RATE[i],"0")));
    			Logger.sys.println(Double.parseDouble(JspUtil.nullToRef(UNIT_PRICE[i],"0")));
    			Logger.sys.println(Double.parseDouble(JspUtil.nullToRef(ITEM_AMT[i],"0")));
    			Logger.sys.println(Double.parseDouble(JspUtil.nullToRef(PR_AMT[i],"0")));
    			Logger.sys.println(WBS_NO[i]);
    			Logger.sys.println(WBS_NAME[i]);
    			Logger.sys.println(RD_DATE[i]);
    			Logger.sys.println(ORDER_NO[i]);
    			Logger.sys.println(ORDER_COUNT[i]);
    			Logger.sys.println(ORDER_SEQ[i]);
    			Logger.sys.println(CONTRACT_REMAIN[i]);
    			Logger.sys.println("------------------------------------------------------------------");

    			cs.setString(1,CUD_FG[i]													);
    			cs.setString(2,PR_USER_ID													);
    			cs.setString(3,PR_USER_NAME													);
    			cs.setString(4,VENDOR_CODE													);
    			cs.setString(5,VENDOR_NAME													);
    			cs.setString(6,CTRL_CODE													);
    			cs.setString(7,PR_NO[i]														);
    			cs.setString(8,PR_SEQ[i]													);
    			cs.setString(9,PO_NO[i]														);
    			cs.setString(10,PO_SEQ[i]													);
    			cs.setString(11,MATERIAL_TYPE[i]											);
    			cs.setString(12,DELY_TO_ADDRESS[i]											);
    			cs.setString(13,WARRANTY[i]													);
    			cs.setString(14,ITEM_NO[i]													);
    			cs.setString(15,DESCRIPTION_LOC[i]											);
    			cs.setString(16,MAKER_CODE[i]												);
    			cs.setString(17,MAKER_NAME[i]												);
    		    cs.setString(18,SPECIFICATION[i]											);
    			cs.setDouble(19,Double.parseDouble(JspUtil.nullToRef(PO_QTY[i],"0"))		);
    			cs.setDouble(20,Double.parseDouble(JspUtil.nullToRef(OLD_PO_QTY[i],"0"))	);
    			cs.setString(21,UNIT_MEASURE[i]												);
    			cs.setString(22,CUR[i]														);
    			cs.setDouble(23,Double.parseDouble(JspUtil.nullToRef(EXCHANGE_RATE[i],"0"))	);
    			cs.setDouble(24,Double.parseDouble(JspUtil.nullToRef(UNIT_PRICE[i],"0"))	);
    			cs.setDouble(25,Double.parseDouble(JspUtil.nullToRef(ITEM_AMT[i],"0"))		);
    			cs.setDouble(26,Double.parseDouble(JspUtil.nullToRef(PR_AMT[i],"0"))		);
    			cs.setString(27,WBS_NO[i]													);
    			cs.setString(28,WBS_NAME[i]													);
    		    cs.setString(29,RD_DATE[i]													);
    			cs.setString(30,ORDER_NO[i]													);
    			cs.setString(31,ORDER_COUNT[i]												);
    			cs.setString(32,ORDER_SEQ[i]												);
    			cs.setString(33,CONTRACT_REMAIN[i]											);

    			cs.registerOutParameter(34,java.sql.Types.INTEGER);
    			cs.registerOutParameter(35,java.sql.Types.VARCHAR);

    			cs.execute();

    			ll_code	=	cs.getInt(34)		;
    			ls_msg	=	cs.getString(35)	;

    			if(ll_code!=0){
    				Rollback()			;	setStatus(0)		;
    				setMessage(ls_msg)	;	lb_fg	=	true	;
    				break				;
    			}
    		}
    		if(lb_fg==false) Commit();

    	}catch(Exception e){
        	try { Rollback(); } catch(Exception d) { Logger.err.println(userid,this,d.getMessage()); }
            setValue(e.getMessage().trim());
            setStatus(0);
            setMessage(e.getMessage().trim());
        }
        return getSepoaOut();

    }
    */

    public SepoaOut setPoIngStop(String po_no, String end_remark){
        try {
    			int rtn_dt = et_setPoIngStop(po_no, end_remark);

                Commit();
                setStatus(1);
            }catch(Exception e)
            {
                Logger.err.println("Exception e =" + e.getMessage());
                Logger.err.println("Exception e =" + e.getMessage());
                try {
                    Rollback();
                } catch(Exception d) {
                    Logger.err.println(userid,this,d.getMessage());
                }
                setValue(e.getMessage().trim());
                setStatus(0);
                setMessage(e.getMessage().trim());
            }
            return getSepoaOut();
        }

    private int et_setPoIngStop(String po_no, String end_remark) throws Exception
	{
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("po_no"		, po_no);
			wxp.addVar("house_code"		, info.getSession("HOUSE_CODE"));
			wxp.addVar("id"		, info.getSession("ID"));
			wxp.addVar("end_remark"		, end_remark);
			wxp.addVar("add_date"		, SepoaDate.getShortDateString());
			wxp.addVar("add_time"		, SepoaDate.getShortTimeString());

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

			/*검수요청건이 있을때 발주중도처리를 할 경우 반려 처리*/
			wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_setIvhd");
			wxp.addVar("po_no"		, po_no);
			wxp.addVar("house_code"		, info.getSession("HOUSE_CODE"));
			wxp.addVar("id"		, info.getSession("ID"));
			wxp.addVar("add_date"		, SepoaDate.getShortDateString());
			wxp.addVar("add_time"		, SepoaDate.getShortTimeString());

			sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();
		} catch(Exception e) {
			throw new Exception("et_setPoIngStop:"+e.getMessage());
		} finally{
		}
		return rtn;
	}

	// ************************************** podt Insert ****************************************//

    private int up_ICOYPODT_DO(String[][] setData
                            ) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        try {

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

                String[] type = {"S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "N","N","N","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","N",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","N","S","S",
                                 "S"
                                 };

                rtn = sm.doInsert(setData, type);

        }catch(Exception e) {
        	throw new Exception("in_ICOYPODT:"+e.getMessage());
        } finally{
        }
        return rtn;
    }

    private int up_ICOYPOHD_DO(String[][] PohdData) throws Exception
    {
        int rtn = -1;
		for(int i=0;i<PohdData.length;i++)
			for(int j=0;j<PohdData[i].length;j++)
				Logger.err.println("==================================="+i+"="+j+" : "+PohdData[i][j]);

        ConnectionContext ctx = getConnectionContext();
        try {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            String[] type = {"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "N"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				};
            rtn = sm.doInsert(PohdData ,type);
        }catch(Exception e) {
            throw new Exception("in_ICOYPOHD_DO:"+e.getMessage());
        } finally{
        }
        return rtn;
    }

	private int setPRDT(String po_no) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();

        SepoaSQLManager sm = null;
        SepoaFormater wf = null;

        String user_id    = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");

        try {

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
            wxp.addVar("house_code"	, house_code);
            wxp.addVar("po_no"		, po_no);
            sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            String rtnSql = sm.doSelect();
            wf = new SepoaFormater(rtnSql);

                for( int i = 0 ; i < wf.getRowCount(); i++ )
                {
                    String pr_no = wf.getValue( i,0 );
                    String pr_seq = wf.getValue( i,1 );

                    wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
                    wxp.addVar("house_code"	, house_code);
                    wxp.addVar("pr_no"		, pr_no);
                    wxp.addVar("pr_seq"		, pr_seq);

                    sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
                    rtn = sm.doInsert();
                }

        }catch(Exception e) {
            throw new Exception("setPRDT:"+e.getMessage());
        }
        finally{
        }
        return rtn;
    }//setPRDT end

    public SepoaOut CallNONDBJOB(ConnectionContext ctx, String serviceId, String MethodName, Object[] obj )
	{

		String conType = "NONDBJOB";					//conType :	CONNECTION/TRANSACTION/NONDBJOB

		SepoaOut value = null;
		SepoaRemote wr	= null;

		//다음은 실행할	class을	loading하고	Method호출수 결과를	return하는 부분이다.
		try
		{

			wr = new SepoaRemote( serviceId, conType, info	);
			wr.setConnection(ctx);

			value =	wr.lookup( MethodName, obj );

		}catch(	SepoaServiceException wse ) {
//			try{
				Logger.err.println("wse	= "	+ wse.getMessage());
//				Logger.err.println("message	= "	+ value.message);
//				Logger.err.println("status = " + value.status);				
//			}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
		}catch(Exception e)	{
//			try{
				Logger.err.println("err	= "	+ e.getMessage());
//				Logger.err.println("message	= "	+ value.message);
//				Logger.err.println("status = " + value.status);				
//			}catch(NullPointerException ne){
//        		ne.printStackTrace();
//        	}
		}

		return value;
	}


	private int updateCndt(String po_no) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        SepoaSQLManager sm = null;
        SepoaFormater wf = null;
        String rtnSelect = null, _po_no = null, _po_seq = null, _exec_no = null, _exec_seq = null;

        try
        {

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
            wxp.addVar("po_no", po_no);
            sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery());
            rtnSelect = sm.doSelect(  );
            wf = new SepoaFormater( rtnSelect );

            if ( wf.getRowCount() > 0 )
            {
            	_po_no = wf.getValue(0, 0);
            	_po_seq = wf.getValue(0, 1);
            	_exec_no = wf.getValue(0, 2);
            	_exec_seq = wf.getValue(0, 3);

                wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
                wxp.addVar("po_no", _po_no);
                wxp.addVar("po_seq", _po_seq);
                wxp.addVar("exec_no", _exec_no);
                wxp.addVar("exec_seq", _exec_seq);
                sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

                rtn = sm.doInsert();
            }

        }
        catch(Exception e)
        {
            throw new Exception("updateCndt:"+e.getMessage());
        }
        finally
        {
        }
        return rtn;
    }


/***************************************************************************************************************
*                        *********************  PO Create (내자)  *********************
* PID    : p2011.java
* Create : 01/09/22
* Change : 01/09/22
* Source : From Servlet
* @ DR   : /order/bpo/po1_bd_ins1.jsp
* @author Andy Shin
*                       ***************************************************************
****************************************************************************************************************/

    public SepoaOut setPoDomCreateInsert(String[][] PodtData,
                                        String[][] IndrData,
                                        String[][] PohdData,
                                        String sign_status,
                                        String company_code,
                                        String ttl_amt,
                                        String approval,
                                        String po_no,
                                        String vendor_code,
                                        String subject,
                                        String vendor_mobile_no,
                                        String vendor_email,
                                        String vendor_cp_name
                                        )
    {
    	SepoaOut wo = null;
        try {
            String user_id        = info.getSession("ID");
            String house_code     = info.getSession("HOUSE_CODE");
            String user_dept      = info.getSession("DEPARTMENT");

            ConnectionContext ctx = getConnectionContext();
            Logger.debug.println("p2011.setPoDomCreateInsert() del_PO BEFORE!!!! ");
			del_PO(po_no);		//update시 사용
			Logger.debug.println("p2011.setPoDomCreateInsert() del_PO() END!!!! ");
            int rtn1 = in_ICOYPODT_DO(PodtData);
            Logger.debug.println("p2011.setPoDomCreateInsert() in_ICOYPODT_DO() END!!!! ");
            int rtn2 = in_update_goods_group(po_no);
            Logger.debug.println("p2011.setPoDomCreateInsert() in_update_goods_group() END!!!! ");
            setValue("Insert Row="+rtn1);

            if(rtn1 == 0 || rtn2 == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("9003"));
                return getSepoaOut();
            }

            int dr = in_ICOYINDR(IndrData);
            Logger.debug.println("p2011.setPoDomCreateInsert() in_ICOYINDR() END!!!! ");
            int rtnHD = in_ICOYPOHD_DO(PohdData);
            Logger.debug.println("p2011.setPoDomCreateInsert() in_ICOYPOHD_DO() END!!!! ");
			int rtnPRDT = setPRDT(po_no);
            if(rtnHD == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("4000"));
                return getSepoaOut();
            }

            updateCndt(po_no);
            Logger.debug.println("p2011.setPoDomCreateInsert() updateCndt()!!!! ");

            Logger.debug.println("p2011.setPoDomCreateInsert() PIS Sytem PO정보 등록!! PO_NO ::"+PohdData[0][1].toString());


            //PIS시스템 발주정보 등록
            int iPIS = in_PIS_PO(house_code, PohdData[0][1].toString());
            if(iPIS == 0){
                Rollback();
                setStatus(0);
                setMessage(msg.getMessage("[I/F] PIS시스템에 발주정보 등록시 오류가 발생하였습니다."));
                return getSepoaOut();
            }

      			Commit();

      			setStatus(1);
      			setValue(po_no);

      			if(sign_status.equals("P")){
                	setMessage("발주번호 "+po_no+" 로 결재요청 되었습니다.");
                }else{
                	setMessage("발주번호 "+po_no+" 로 생성되었으며\n 해당 업체로 전송 되었습니다.");
                	//setMail(vendor_code, po_no, subject, vendor_mobile_no, vendor_email, vendor_cp_name);
                }

      		//}

        }catch(Exception e) {
        	try {
                Rollback();
            } catch(Exception d) {
                Logger.err.println(userid,this,d.getMessage());
            }
            setValue(e.getMessage().trim());
            setStatus(0);
//            setMessage(e.getMessage().trim());
        }
        return getSepoaOut();
    }

    private void sendMail(String vendor_code, String po_no, String subject, String vendor_mobile_no, String vendor_email, String vendor_cp_name){
    	String mailSubject = "IBK시스템에서 발주정보를 알려드립니다.";
		//String HTMLContents = "D:/IBK/workspace/epro/attfiles/MAIL/notice.html";
		String mailContents = "발주명 :"+subject;
		String[][] TO = {{"imcyber@icompia.com", "이성우"}};
		//String[] attach = {"D:/IBK/workspace/epro/attfiles/MAIL/notice.html"};
		String[] attach		= {};

    	try{
    		HashMap paramsMap = new HashMap();
			paramsMap.put("subject", mailSubject);
			//paramsMap.put("HTMLContents", HTMLContents);
			paramsMap.put("Contents", mailContents);
			paramsMap.put("TO", TO);
			//paramsMap.put("CC", TO);
			paramsMap.put("attach", attach);

			new SendMail(paramsMap, info.getSession("HOUSE_CODE"));
    	} catch(Exception d) {
            Logger.err.println(userid,this,d.getMessage());
        }
    }




/*
* 수정할때도 같은 서비스를 사용하기 때문에 반은 po_no로 한번 지워주는 로직 추가.
*/
    private int del_PO(String po_no) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        String house_code     = info.getSession("HOUSE_CODE");
        String[][] setData = {{house_code, po_no}};
    	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

        try {

            	wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

//                sql.append("	DELETE ICOYPOHD             \n");
//                sql.append("	WHERE HOUSE_CODE	=	?	\n");
//                sql.append("	AND   PO_NO			=	?	\n");

                SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

                String[] type = {"S","S"};
                rtn = sm.doInsert(setData, type);
                wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

//                sql1.append("	DELETE ICOYPODT             \n");
//                sql1.append("	WHERE HOUSE_CODE	=	?	\n");
//                sql1.append("	AND   PO_NO			=	?	\n");

                sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

                String[] type1 = {"S","S"};
                rtn = sm.doInsert(setData, type1);
        }catch(Exception e) {
        	throw new Exception("del_PO:"+e.getMessage());
        } finally{
        }
        return rtn;
    }

 // ************************************** podt Insert ****************************************//

    private int in_ICOYPODT_DO(String[][] setData
                            ) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        try {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

                String[] type = {"S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S","S",
                                 "S","S","S","S"
                                 };

                rtn = sm.doInsert(setData, type);

        }catch(Exception e) {
        	throw new Exception("in_ICOYPODT:"+e.getMessage());
        } finally{
        }
        return rtn;
    }

    private int in_update_goods_group(String po_no) throws Exception{

    	int rtn = -1;
			ConnectionContext ctx = getConnectionContext();
		try
		{

	        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	        wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
	        wxp.addVar("po_no", po_no);

//				sql.append( "	SELECT GL.GOODS_GROUP                        					\n");
//				sql.append( "		FROM ICOMMTGL GL, ICOYPODT DT             					\n");
//				sql.append( "	WHERE DT.HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'       \n");
//				sql.append( "	  AND DT.PO_NO      = '"+po_no+"'                               \n");
//				sql.append( "	  AND DT.STATUS     IN ('C','R')								\n");
//				sql.append( "	  AND GL.HOUSE_CODE = DT.HOUSE_CODE       						\n");
//				sql.append( "	  AND GL.ITEM_NO    = DT.ITEM_NO          						\n");
				SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
				String rtnSelect = sm.doSelect(  );
				SepoaFormater wf = new SepoaFormater( rtnSelect );

			if ( wf.getRowCount() > 0 )
			{
				String goods_group = wf.getValue( 0, 0 );

				wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
				wxp.addVar("goods_group", goods_group);
				wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
				wxp.addVar("po_no", po_no);
//				sql.append( "	UPDATE ICOYPODT                                               \n");
//				sql.append( "	   SET GOODS_GROUP = '" + goods_group + "'                    \n");
//				sql.append( "	WHERE HOUSE_CODE = '"+info.getSession("HOUSE_CODE")+"'        \n");
//				sql.append( "	  AND PO_NO      = '"+po_no+"'                                \n");
//				sql.append( "	  AND STATUS     IN ('C','R')								  \n");

				sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
				rtn = sm.doInsert();
			}
		}
		catch(Exception e)
		{
			throw new Exception("in_update_goods_group:"+e.getMessage());
		}
		finally
		{
		}
		return rtn;
	}

    private int in_ICOYINDR(String[][] IndrData) throws Exception
    {
        int rtn = -1;
        ConnectionContext ctx = getConnectionContext();
        try {

            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//            sql.append(" UPDATE ICOYINDR                                                 \n");
//            sql.append(" SET     CUM_PO_QTY            =  ISNULL(CUM_PO_QTY,0)+ ISNULL(? ,0)   \n");
//            sql.append("        ,STATUS                =  'R'                            \n");
//            sql.append("        ,CHANGE_DATE           = ?                               \n");
//            sql.append("        ,CHANGE_TIME           = ?                               \n");
//            sql.append("        ,CHANGE_USER_ID        = ?                               \n");
//            sql.append(" WHERE HOUSE_CODE         = ?                                    \n");
//            sql.append("   AND VENDOR_CODE        = ?                                    \n");
//            sql.append("   AND ITEM_NO            = ?                                    \n");
//            sql.append("   AND STATUS IN ('C', 'R')                                      \n");

            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

            String[] type = {"N","S","S","S","S"
            		        ,"S","S"};
            rtn = sm.doInsert(IndrData, type);
        }catch(Exception e) {
            throw new Exception("in_ICOYINDR:"+e.getMessage());
        } finally{

        }
        return rtn;
    }

    private int in_ICOYPOHD_DO(String[][] PohdData) throws Exception
    {
        int rtn = -1;
		for(int i=0;i<PohdData.length;i++)
			for(int j=0;j<PohdData[i].length;j++)
				Logger.err.println("==================================="+i+"="+j+" : "+PohdData[i][j]);

        ConnectionContext ctx = getConnectionContext();
        try {
            SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            String[] type = {"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S", "S", "S", "S", "S"
            				,"S"};
            rtn = sm.doInsert(PohdData ,type);
        }catch(Exception e) {
            throw new Exception("in_ICOYPOHD_DO:"+e.getMessage());
        } finally{
        }
        return rtn;
    }

    public SepoaOut getForeignPOHeaderU(String house_code, String po_no) {
        try {
            String rtn = "";

            rtn = et_getForeignPOHeaderU(house_code, po_no);

			SepoaFormater wf = new SepoaFormater(rtn);
			if(wf.getRowCount() == 0) setMessage(msg.getMessage("0000"));
			else {
				setMessage(msg.getMessage("7000"));
			}
            setValue(rtn);
            setStatus(1);
        }catch (Exception e){
            Logger.err.println(info.getSession("ID"),this,"Exception e ==============>" + e.getMessage());

            setMessage(msg.getMessage("7004"));
            setStatus(0);
        }
        return getSepoaOut();
    }


    private String et_getForeignPOHeaderU(String house_code,String po_no) throws Exception
    {
        String rtn = "";
        ConnectionContext ctx = getConnectionContext();
		StringBuffer sql=null;
        try {

        	SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
            // sql이 null로 선언돼있어서, 객체에 접근할수 없음.
            Logger.err.println(info.getSession("ID"),this,"");
            //Logger.err.println(info.getSession("ID"),this,sql.toString());

            String[] args = {info.getSession("HOUSE_CODE"), po_no};

            rtn = sm.doSelect(args);

        }catch(Exception e) {
            Logger.err.println("et_getPOHeader=========>"+e.getMessage());
        } finally{
        }
        return rtn;
    }

 // ************************************************
 // **************** 결재처리 **********************
 // ************************************************

    public SepoaOut Approval(SignResponseInfo inf)
    {
    	Logger.debug.println(info.getSession("ID"),this,"approval start !!!");
    	String ans = inf.getSignStatus();
    	String po_no = "";
    	String id = "I034";
    	String where = "";
    	Logger.debug.println(info.getSession("ID"),this,"111111111111111111111111==============>");
    	String[] doc_no = inf.getDocNo();
    	String[] com_code = inf.getCompanyCode();
    	String[] doc_seq = inf.getDocSeq();
    	
    	String setData[][]    = new String[doc_no.length][];
    	String setDataII[][]    = new String[doc_no.length][];
    	String flag    = "";
    	Logger.debug.println(info.getSession("ID"),this,"doc_no - length==============>"+doc_no.length);
    	for (int i = 0; i<doc_no.length; i++) {
    		String Data[]    = { doc_no[i] };
    		String DataII[]  = { com_code[i] , doc_no[i] };
    		setData[i]   = Data;
    		setDataII[i] = DataII;
    	}
    	
    	where = "PO_NO IN ("+po_no+")";
    	
    	int res  = -1;
    	int res1 = -1;
    	int res2 = -1;
    	int res3 = -1;
    	
    	try {
    		Logger.debug.println(info.getSession("ID"),this,"try start ----------------==============>");
    		if(ans.equals("E")) { // 완료
    			flag = "E";
    		} else if (ans.equals("R")) { // 반려
    			flag = "R";
    		} else if (ans.equals("D")) { // 취소
    			//flag = "D";
    			flag = "T";
    		}
    		Logger.debug.println(info.getSession("ID"),this,"setSIGN_STATUS start ==============>");
    		res  = setSIGN_STATUS(flag, setData);
    		
    		if(ans.equals("E"))
    		{
    			Logger.debug.println(info.getSession("ID"),this,"doc_no==============>"+doc_no);
    			//청구의 PROCEEDING_FLAG 수정
    			res3 = setPRDT(setData);
    			int cim_cnt = 0;
    			
    			//PO의 RD_DATE 현재일보다 작은 것 현재일로 UPDATE
    			setPODT(setData);//
    			/*
                for (int i = 0; i<doc_no.length; i++) {
                     where   = "HOUSE_CODE = '100' AND STATUS <> 'D' AND PO_NO = '"+doc_no[i]+"'";
                     Logger.debug.println(info.getSession("ID"),this,"ID==============>"+id);
                     Logger.debug.println(info.getSession("ID"),this,"WHERE==============>"+where);

                     SepoaOut wo = setICOTEPIF(info, id, where);
                     if( wo.status == 1){
                         Logger.debug.println(info.getSession("ID"),this,"========ICOTEPIF  "+doc_no[i]+"  INSERT OK");
                         cim_cnt++;
                         //setStatus(1);
                         //Commit();
                     }
                     else{
                         Logger.debug.println(info.getSession("ID"),this,"========ICOTEPIF  "+doc_no[i]+"  INSERT FAIL");
                         Logger.debug.println(info.getSession("ID"),this," wo.result[0] = " +wo.result[0]);
                         Logger.debug.println(info.getSession("ID"),this," wo.result[1] = " +wo.result[1]);
                         setMessage(wo.result[1]);
                         setStatus(0);
                         Rollback();
                         return getSepoaOut();
                     }
                 }
    			 */
                 //Logger.debug.println(info.getSession("ID"),this,"doc_no.length==============="+doc_no.length+" INSERT OK");
    			if( cim_cnt == cim_cnt )
    			{
    				setStatus(1);
    				Commit();
    			}
    		} else {
    			setStatus(1);
    			Commit();
    		}
    	} catch(Exception e) {
    		Logger.err.println("setSignStatus: = " + e.getMessage());
    		setStatus(0);
    	}
    	return getSepoaOut();
    }

 	private int setSIGN_STATUS(String FLAG, String[][] setData) throws Exception
 	{
 		int rtn = -1;
 		ConnectionContext ctx = getConnectionContext();
 		
 		String user_id    = info.getSession("ID");
 		String house_code = info.getSession("HOUSE_CODE");
 		SepoaSQLManager sm = null;
 		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
 		wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");

     	wxp.addVar("FLAG", FLAG);
     	wxp.addVar("getConfig", getConfig("Sepoa.generator.db.selfuser"));
     	wxp.addVar("user_id", user_id);
     	wxp.addVar("house_code", house_code);
     	
     	try {
//         sql.append( " UPDATE ICOYPOHD                                                    \n" );
//         sql.append( " SET SIGN_STATUS      ='"+FLAG+"',                                  \n" );
//         sql.append( "     SIGN_DATE      =" +getConfig("Sepoa.generator.db.selfuser") + "."+ "dateFormat(getdate(), 'YYYYMMDD'),      \n" );
//         sql.append( "     SIGN_PERSON_ID ='"+user_id+"'                                  \n" );
//         sql.append( " WHERE HOUSE_CODE = '"+house_code+"'                                \n" );
//         sql.append( "   AND po_no = ?                                                    \n" );

     		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
     		String[] type = { "S" };
     		rtn = sm.doInsert(setData, type);

//         sql = new StringBuffer();
//         sql.append( " UPDATE ICOYPODT                                                   \n" );
//         sql.append( " SET RD_DATE  = (CASE SIGN(RD_DATE - TO_CHAR(SYSDATE,'YYYYMMDD')) 	\n" );
//         sql.append( "                    WHEN 1 THEN RD_DATE                            \n" );
//         sql.append( "                    WHEN 0 THEN RD_DATE                            \n" );
//         sql.append( "                    WHEN -1 THEN TO_CHAR(SYSDATE,'YYYYMMDD')       \n" );
//         sql.append( "                END)                                               \n" );
//         sql.append( " WHERE HOUSE_CODE = '"+house_code+"'                               \n" );
//         sql.append( "   AND PO_NO = ?                                                   \n" );

     		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
     		rtn = sm.doInsert(setData, type);
     	} catch(Exception e) {
     		throw new Exception("######## setSIGN_STATUS ========> "+e.getMessage());
     	}
     	return rtn;
 	}
 	
 	// 발주 완료시 구매요청 상태값 변경
 	private int setPRDT(String[][] setData) throws Exception
 	{
 		int rtn = -1;
 		ConnectionContext ctx = getConnectionContext();
  		SepoaSQLManager sm = null;
 		SepoaFormater wf = null;
 		
 		String user_id    = info.getSession("ID");
 		String house_code = info.getSession("HOUSE_CODE");
 		
 		try {
 			for( int j = 0; j < setData.length ; j++ )
 			{
 				SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");
	          	
 				wxp.addVar("house_code", house_code);
	          	wxp.addVar("setData", setData[j][0]);
//             sql = new StringBuffer();
//             sql.append( "SELECT PR_NO, PR_SEQ                   \n" );
//             sql.append( "FROM   ICOYPODT                        \n" );
//             sql.append( "WHERE  HOUSE_CODE = '"+house_code+"'   \n" );
//             sql.append( "  AND  PO_NO = '"+setData[j][0]+"'     \n" );
//             sql.append( "  AND  STATUS <> 'D'                   \n" );

	          	sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
	          	String rtnSql = sm.doSelect();
	          	wf = new SepoaFormater(rtnSql);

	          	for( int i = 0 ; i < wf.getRowCount(); i++ )
	          	{
	          		String pr_no = wf.getValue( i,0 );
	          		String pr_seq = wf.getValue( i,1 );
	          		
	          		wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
                 	wxp.addVar("pr_no", pr_no);
              		wxp.addVar("pr_seq", pr_seq);
//                 sql = new StringBuffer();
//                 sql.append( " UPDATE ICOYPRDT            			\n" );
//                 sql.append( " SET    PR_PROCEEDING_FLAG = 'O'       \n" );
//                 sql.append( " WHERE  HOUSE_CODE = '"+house_code+"'  \n" );
//                 sql.append( "   AND  PR_NO = '"+pr_no+"'     		\n" );
//                 sql.append( "   AND  PR_SEQ = '"+pr_seq+"'       	\n" );

              		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
              		rtn = sm.doInsert();
	          	}
 			}
 		} catch(Exception e) {
 			throw new Exception("setPRDT:"+e.getMessage());
 		} finally {
 		}
 		return rtn;
 	}

 private int setPODT(String[][] setData) throws Exception
 {
     int rtn = -1;
     ConnectionContext ctx = getConnectionContext();

     SepoaSQLManager sm = null;
     SepoaFormater wf = null;

     String user_id    = info.getSession("ID");
     String house_code = info.getSession("HOUSE_CODE");
     SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
     	wxp.addVar("house_code", house_code);
     	wxp.addVar("getConfig", getConfig("Sepoa.generator.db.selfuser"));

     try {

//         sql = new StringBuffer();
//         sql.append( " UPDATE ICOYPODT                                               \n" );
//         sql.append( " SET   RD_DATE = " +getConfig("Sepoa.generator.db.selfuser") + "."+ "dateFormat(getdate(), 'YYYYMMDD')      \n" );
//          sql.append( " WHERE HOUSE_CODE = '"+house_code+"'                           \n" );
//         sql.append( "   AND PO_NO = ?                                               \n" );
//         sql.append( "   AND RD_DATE < " +getConfig("Sepoa.generator.db.selfuser") + "."+ "dateFormat(getdate(), 'YYYYMMDD')      \n" );

         sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
         String[] type = { "S" };
         rtn = sm.doInsert(setData, type);


     }catch(Exception e) {
         throw new Exception("setPODT:"+e.getMessage());
     }
     finally{
     }
     return rtn;
 }//setPODT end

/*
 * PIS시스템 발주정보 등록
 */
private int in_PIS_PO(String house_code, String po_no) throws Exception
{
	if(getConfig("Sepoa.scms.if_flag").equals("false"))
	{
		return 1;
	}

	int rtn = -1;
	ConnectionContext ctx = getConnectionContext();
    SepoaSQLManager sm = null;

    SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    wxp.addVar("house_code", house_code);
    wxp.addVar("po_no", po_no);

	try{
		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
        rtn = sm.doInsert();
	}catch(Exception e){
		throw new Exception("setPODT:"+e.getMessage());
    }
    finally{
    }

	return rtn;
}


/*
 * PIS시스템 발주정보 수정 - 납기요청일자, 무상보증기간, 납품상세
 */
private int upd_PIS_PO(String[][] setData) throws Exception
{
	int rtn = -1;
	ConnectionContext ctx = getConnectionContext();
    SepoaSQLManager sm = null;
    String sRdDate = setData[setData.length][18];
    String sDelyToAddress = setData[setData.length][23];
    String sWarranty = setData[setData.length][48];
    String sPoNo = setData[setData.length][50];
    String sPoSeq = setData[setData.length][51];

    SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
    wxp.addVar("DELY_TO_ADDRESS", sDelyToAddress);
    wxp.addVar("WARRANTY", sWarranty);
    wxp.addVar("PO_NO", sPoNo);
    wxp.addVar("PO_SEQ", sPoSeq);

	try{
		sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
        rtn = sm.doInsert();
	}catch(Exception e){
		throw new Exception("upd_PIS_PO:"+e.getMessage());
    }
    finally{
    }

	return rtn;
}

public SepoaOut setPoCancel(String hid_pr_no,String hid_pr_seq,String hid_exec_no,String hid_po_no){
	setStatus(1);
	setFlag(true);
	ConnectionContext ctx = getConnectionContext();
	SepoaXmlParser sxp = null;
	SepoaSQLManager ssm = null;
	SepoaFormater sf = null;
	
	try {
		HashMap<String, String> no = new HashMap<String, String>();
	    no.put("PO_NO", hid_po_no);
	
		sxp = new SepoaXmlParser( this, "sel_setPoCancel_1" );
		ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
		sf  = new SepoaFormater( ssm.doSelect( no ) );
		if(!sf.getValue("CNT", 0).equals("0")){
			throw new Exception("발주번호("+ hid_po_no +")로 검수 완료건이 존재합니다.");
		}
		
		int rtn1 = in_ICOYPRDT_cancel(hid_pr_no, hid_pr_seq);
		int rtn2 = in_ICOYCNHD_cancel(hid_exec_no);
		
		int rtn4 = in_ICOYCNDP_cancel(hid_exec_no);
		int rtn5 = in_ICOYPOHD_cancel(hid_po_no);
		int rtn6 = in_ICOYPODT_cancel(hid_po_no);
		int rtn7 = in_ICOYIVHD_cancel(hid_po_no);
		int rtn8 = in_ICOYIVDT_cancel(hid_po_no);
		
		int rtn3 = in_ICOYCNDT_cancel(hid_po_no);
		
		if(rtn1<0 || rtn2<0 || rtn3<0 || rtn4<0 || rtn5<0 || rtn6<0 || rtn7<0 || rtn8<0){
			Rollback();
	        setStatus(0);
	        setMessage(msg.getMessage("9003"));
	        return getSepoaOut();
		}

		setMessage("연단가발주 취소처리가 완료 되었습니다.");
	
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
//        setValue(e.getMessage().trim());
        setStatus(0);
	}

	return getSepoaOut();
}

	private int in_ICOYPRDT_cancel(String hid_pr_no, String hid_pr_seq) throws Exception  {
		int rtn1 = -1;
		ConnectionContext ctx1 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp1 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp1.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp1.addVar("hid_pr_no"	 , hid_pr_no);
			wxp1.addVar("hid_pr_seq" , hid_pr_seq);
			SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"),this,ctx1,wxp1.getQuery());

			rtn1 = sm1.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYPRDT_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn1;
 	}

 	private int in_ICOYCNHD_cancel(String hid_exec_no) throws Exception  {
		int rtn2 = -1;
		ConnectionContext ctx2 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp2 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp2.addVar("house_code"  , info.getSession("HOUSE_CODE"));
			wxp2.addVar("hid_exec_no" , hid_exec_no);
			SepoaSQLManager sm2 = new SepoaSQLManager(info.getSession("ID"),this,ctx2,wxp2.getQuery());

			rtn2 = sm2.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYCNHD_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn2;
 	}

 	private int in_ICOYCNDT_cancel(String hid_po_no) throws Exception  {
		int rtn3 = -1;
		ConnectionContext ctx3 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp3 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp3.addVar("house_code"  , info.getSession("HOUSE_CODE"));
			wxp3.addVar("hid_po_no" , hid_po_no);
			SepoaSQLManager sm3 = new SepoaSQLManager(info.getSession("ID"),this,ctx3,wxp3.getQuery());

			rtn3 = sm3.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYCNDT_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn3;
 	}

 	private int in_ICOYCNDP_cancel(String hid_exec_no) throws Exception  {
		int rtn4 = -1;
		ConnectionContext ctx4 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp4 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp4.addVar("house_code"  , info.getSession("HOUSE_CODE"));
			wxp4.addVar("hid_exec_no" , hid_exec_no);
			SepoaSQLManager sm4 = new SepoaSQLManager(info.getSession("ID"),this,ctx4,wxp4.getQuery());

			rtn4 = sm4.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYCNDP_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn4;
 	}

 	private int in_ICOYPOHD_cancel(String hid_po_no) throws Exception  {
		int rtn5 = -1;
		ConnectionContext ctx5 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp5 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp5.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp5.addVar("hid_po_no"  , hid_po_no);
			SepoaSQLManager sm5 = new SepoaSQLManager(info.getSession("ID"),this,ctx5,wxp5.getQuery());

			rtn5 = sm5.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYPOHD_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn5;
 	}
 	
 	private int in_ICOYPODT_cancel(String hid_po_no) throws Exception  {
		int rtn6 = -1;
		ConnectionContext ctx6 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp6 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp6.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp6.addVar("hid_po_no"	 , hid_po_no);
			SepoaSQLManager sm6 = new SepoaSQLManager(info.getSession("ID"),this,ctx6,wxp6.getQuery());

			rtn6 = sm6.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYPODT_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn6;
 	}
 	
 	private int in_ICOYIVHD_cancel(String hid_po_no) throws Exception  {
		int rtn7 = -1;
		ConnectionContext ctx7 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp7 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp7.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp7.addVar("hid_po_no"	 , hid_po_no);
			SepoaSQLManager sm7 = new SepoaSQLManager(info.getSession("ID"),this,ctx7,wxp7.getQuery());

			rtn7 = sm7.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYIVHD_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn7;
 	}
 	
 	private int in_ICOYIVDT_cancel(String hid_po_no) throws Exception  {
		int rtn8 = -1;
		ConnectionContext ctx8 = getConnectionContext();
		try {
			
			SepoaXmlParser wxp8 = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp8.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp8.addVar("hid_po_no"	 , hid_po_no);
			SepoaSQLManager sm8 = new SepoaSQLManager(info.getSession("ID"),this,ctx8,wxp8.getQuery());

			rtn8 = sm8.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_ICOYIVDT_cancel:"+e.getMessage());
		} 
		finally{
		}
		return rtn8;
 	}
 	
 	public SepoaOut setPoReturn(String hid_po_no){
 		try {
	 			   String rtnvalue = bl_getICOYIVHD_FLAG(hid_po_no);
	
		           if (!rtnvalue.equals("0")){
		            	setFlag(false);
		            	setStatus(0);
		                setMessage("해당 발주건은 검수완료건이 존재하여 발주대기로 환원이 안됩니다.");
		                return getSepoaOut();
		            }
		           
				    int rtn1 = in_setPoReturn_1(hid_po_no);
					int rtn2 = in_setPoReturn_2(hid_po_no);
					int rtn3 = in_setPoReturn_3(hid_po_no);
					int rtn4 = in_setPoReturn_4(hid_po_no);
					int rtn5 = in_setPoReturn_5(hid_po_no);
					int rtn6 = in_setPoReturn_6(hid_po_no);
					
					if(rtn1<0 || rtn2<0 || rtn3<0 || rtn4<0 || rtn5<0 || rtn6<0){
						Rollback();
						setFlag(false);
		            	setStatus(0);
			            setMessage("발주대기로 환원 처리중 오류발생");
			            return getSepoaOut();
					}
					
		 		    Commit();
		 		    setFlag(true);
	           	    setStatus(1);
		 	        setValue("");
		 	        setMessage("발주대기로 환원 되었습니다.");	 	  	
	 		}catch (Exception e){
	 			try {
	 	            Rollback();
	 	        } catch(Exception d) {
	 	            Logger.err.println(userid,this,d.getMessage());
	 	        }
	 	        setValue(e.getMessage().trim());
	 	        setFlag(false);
           	    setStatus(0);
	 	        setMessage(e.getMessage().trim());
	 		}
	
	 	return getSepoaOut();
 	}
 	
 	private String bl_getICOYIVHD_FLAG(String hid_po_no) throws Exception {

		String rtn = "";
		ConnectionContext ctx = getConnectionContext();
		try {
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code", info.getSession("HOUSE_CODE"));
		    wxp.addVar("po_no", hid_po_no);

			SepoaSQLManager sm = new SepoaSQLManager( info.getSession("ID"), this, ctx, wxp.getQuery() );
			String rtnSelect = sm.doSelect();
			SepoaFormater wf = new SepoaFormater( rtnSelect );
			
			if ( wf.getRowCount() > 0 )
			{
				rtn = wf.getValue( 0, 0 );
			}
					
		} catch (Exception e) {
			throw new Exception("bl_getICOYIVHD_FLAG:" + e.getMessage());
		} finally {
		}
		return rtn;
	}
 	
 	private int in_setPoReturn_1(String hid_po_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("po_no"	 , hid_po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_1:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setPoReturn_2(String hid_po_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("po_no"	 , hid_po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_2:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setPoReturn_3(String hid_po_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("po_no"	 , hid_po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_3:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setPoReturn_4(String hid_po_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("po_no"	 , hid_po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_4:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setPoReturn_5(String hid_po_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("po_no"	 , hid_po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_5:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setPoReturn_6(String hid_po_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("po_no"	 , hid_po_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_6:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	public SepoaOut setExPoCancel(String hid_pr_no,String hid_pr_seq,String hid_exec_no,String hid_po_no){
 		setStatus(1);
 		setFlag(true);
 		ConnectionContext ctx = getConnectionContext();
 		SepoaXmlParser sxp = null;
 		SepoaSQLManager ssm = null;
 		SepoaFormater sf = null;
 		
 		try {
 			HashMap<String, String> no = new HashMap<String, String>();
 		    no.put("exec_no", hid_exec_no);
 		
 			sxp = new SepoaXmlParser( this, "sel_setExPoCancel_1" );
 			ssm = new SepoaSQLManager( info.getSession("ID"), this, ctx, sxp );
 			sf  = new SepoaFormater( ssm.doSelect( no ) );
 			if(!sf.getValue("CNT", 0).equals("0")){
 				throw new Exception("기안번호("+ hid_exec_no +")로 검수 완료건이 존재합니다.");
 			}
 			
 			int rtn1 = in_setExPoCancel_1(hid_exec_no);
			int rtn2 = in_setExPoCancel_2(hid_exec_no);
			int rtn3 = in_setExPoCancel_3(hid_exec_no);
			int rtn4 = in_setExPoCancel_4(hid_exec_no);
			int rtn5 = in_setExPoCancel_5(hid_exec_no);
			int rtn6 = in_setExPoCancel_6(hid_exec_no);
			int rtn7 = in_setExPoCancel_7(hid_exec_no);
			
			if(rtn1<0 || rtn2<0 || rtn3<0 || rtn4<0 || rtn5<0 || rtn6<0 || rtn7<0){
				Rollback();
				setFlag(false);
            	setStatus(0);
	            setMessage("발주취소(기안생성) 처리중 오류발생");
	            return getSepoaOut();
			}

 			setMessage("발주취소(기안생성) 처리가 완료 되었습니다.");
 		
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
// 	        setValue(e.getMessage().trim());
 	        setStatus(0);
 		}

 		return getSepoaOut();
 	}
 	
 	private int in_setExPoCancel_1(String hid_exec_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no"	 , hid_exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_1:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setExPoCancel_2(String hid_exec_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no"	 , hid_exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_2:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setExPoCancel_3(String hid_exec_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no"	 , hid_exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_3:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setExPoCancel_4(String hid_exec_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no"	 , hid_exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_4:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setExPoCancel_5(String hid_exec_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no"	 , hid_exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_5:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setExPoCancel_6(String hid_exec_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no"	 , hid_exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_6:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
 	
 	private int in_setExPoCancel_7(String hid_exec_no) throws Exception  {
		int rtn = -1;
		ConnectionContext ctx = getConnectionContext();
		try {
			
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("house_code" , info.getSession("HOUSE_CODE"));
			wxp.addVar("exec_no"	 , hid_exec_no);
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());

			rtn = sm.doUpdate();

		}catch(Exception e) {
			throw new Exception("in_setPoReturn_7:"+e.getMessage());
		} 
		finally{
		}
		return rtn;
 	}
} // END
