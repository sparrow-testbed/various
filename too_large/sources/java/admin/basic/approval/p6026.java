package admin.basic.approval;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.DBOpenException;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.SepoaApproval;
import wisecommon.SignResponseInfo;


//기존에 wa.Release를 쓴 이유 모름 , 인수인계시 이런것 까지 다루지 않았음.
//2002.09.19 wa.Release 삭제됨
//framework 소스 수정에 의한 wa.Release 필요성을 못느낌
//vatzz용
public class p6026 extends SepoaService {
    Message msg;

    public p6026(String opt, SepoaInfo info) throws SepoaServiceException{
        super(opt, info);
        setVersion("1.0.0");
        msg = new Message(info, "FW");  // message 처리를 위해 전역변수 선언
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

//
//
//    public String ComputebigDecimal(String value) {
//        String bigValue = "";
//        if(!value.equals("")) {
//            BigDecimal bValue = new BigDecimal(value);
//            bigValue = bValue.toString();
//        }
//        //Logger.debug.println( info.getSession("ID"), this, "bigDecimal 변환값========"+bigValue);
//        return bigValue;
//
//    }
//
///***************************************************************************************************/
///******************************** 회사단위 결재정의**************************************************/
///***************************************************************************************************/
//
///* 처음에 maintain 화면 뜨고 쿼리하면 데이타를 가져와서 보여준다. (회사단위 결재정의)*/
//    public wise.srv.SepoaOut getMaintain(String[] args) {
//        try{
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getMaintain(user_id, args);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getMaintain(String user_id, String[] args) throws Exception {
//        String result = null;
//        ConnectionContext ctx = getConnectionContext();
//        try {
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" select doc_type, dbo.GETICOMCODE2(HOUSE_CODE, 'M999', doc_type) as doc_type_name, auto_manual_flag, strategy_type, remark ");
//                tSQL.append(" from icomrlcm ");
//                tSQL.append(" where status != 'D' ");  /*status 가 D(삭제)가 아닌 것만 가져온다*/
//                tSQL.append(" <OPT=F,S> and house_code = ? </OPT> ");
//                tSQL.append(" <OPT=F,S> and company_code = ? </OPT> ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(args);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getMaintain()"+ ex.getMessage());
//        }
//        return result;
//    }
//
///* Jtable에다 입력하구.. save 버튼을 누르면.. DB에 들어간다.. (회사단위 결재정의)*/
//    public SepoaOut setInsert(String[][] args) {
//        int rtn = -1;
//        String status = "C";  /* 새로 생성된 것의 status는 "C"이다.*/
//        String user_id = info.getSession("ID");
//        String add_date = WiseDate.getShortDateString();
//        String add_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setInsert(user_id, args, status, add_date, add_time);
//            setValue("insertRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setInsert(String user_id, String[][] args, String status, String add_date, String add_time) throws Exception, DBOpenException {
//        int result =-1;
//        String[] settype={"S","S","S","S","S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" insert into icomrlcm (");
//            tSQL.append(" house_code            ");
//            tSQL.append(" , company_code        ");
//            tSQL.append(" , doc_type            ");
//            tSQL.append(" , auto_manual_flag    ");
//            tSQL.append(" , strategy_type       ");
//            tSQL.append(" , remark              ");
//            tSQL.append(" , add_user_id         ");
//            tSQL.append(" , status              ");
//            tSQL.append(" , add_date            ");
//            tSQL.append(" , add_time)           ");
//            tSQL.append(" values( ?, ?, ?, ?, ?, ?, ?, '"+status+"', '"+add_date+"', '"+add_time+"') ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            result = sm.doInsert(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setInsert: " + e.getMessage());
//        }
//        return result;
//    }
//
///* 선택 박스에 체크된 Row를 삭제한다.(회사단위 결재정의) */
//    public SepoaOut setDelete(String[][] args) {
//        try {
//            String user_id = info.getSession("ID");
//            int rtn = -1;
//            String status = "D";   /*삭제된 field 의 status는 "D"이다.*/
//            String change_date = WiseDate.getShortDateString();
//            String change_time = WiseDate.getShortTimeString();
//            rtn = et_setDelete(user_id, args, status, change_date, change_time);
//            setValue("deleteRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setDelete(String user_id, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//        int rtn = -1;
//        String[] settype = {"S","S","S"};  /*SQL 문의 ?의 타입이다.*/
//        ConnectionContext ctx = getConnectionContext();
//        try{
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" delete from icomrlcm ");
//            tSQL.append(" where house_code = ? and company_code = ? and doc_type = ? ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            rtn = sm.doDelete(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            System.err.println("Exception="+e.getMessage());
//        }
//        return rtn;
//    }
//
///* Jtable에다 Change하구... save 버튼을 누르면.. DB에 들어간다.. (회사단위 결재정의) */
//    public SepoaOut setUpdate(String[][] args) {
//        int rtn = -1;
//        String status = "R";  /*수정된 항목의 status는 "R"이다.*/
//        String user_id = info.getSession("ID");
//        String change_date = WiseDate.getShortDateString();
//        String change_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setUpdate(user_id, args, status, change_date, change_time);
//            setValue("Change_Row=" + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setUpdate(String user_id, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//        int result = -1;
//        String[] settype = {"S","S","S","S","S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" update icomrlcm set status = '"+status+"', ");
//            tSQL.append(" change_date = '"+change_date+"', change_time = '"+change_time+"', ");
//            tSQL.append(" auto_manual_flag = ?, strategy_type = ?, remark = ?, change_user_id = ? ");
//            tSQL.append(" where house_code = ? and company_code = ? and doc_type = ? ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            result = sm.doUpdate(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setUpdate: " + e.getMessage());
//        }
//        return result;
//    }
//
///***************************************************************************************************/
///******************************** 부서단위 결재정의**************************************************/
///***************************************************************************************************/
// /* 처음에 maintain 화면 뜨고 쿼리하면 데이타를 가져와서 보여준다.(부서단위 결재정의) */
//    public wise.srv.SepoaOut getMaintain2(String[] args) {
//        try{
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getMaintain2(user_id, args);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getMaintain2(String user_id, String[] args) throws Exception {
//        String result = null;
//        String house_code = info.getSession("HOUSE_CODE");
//
//        ConnectionContext ctx = getConnectionContext();
//        try {
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" select doc_type, dbo.geticomcode1('"+house_code+"','M999',doc_type) doc_type_name, auto_manual_flag, strategy_type, remark as z_remark ");
//                tSQL.append(" from icomrldp ");
//                tSQL.append(" where status != 'D' ");  /*status 가 D(삭제)가 아닌 것만 가져온다*/
//                tSQL.append(" <OPT=F,S> and house_code = ? </OPT> ");
//                tSQL.append(" <OPT=F,S> and company_code = ? </OPT> ");
//                tSQL.append(" <OPT=F,S> and dept = ? </OPT> ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(args);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getMaintain2()"+ ex.getMessage());
//        }
//        return result;
//    }
//
///* Jtable에다 입력하구.. save 버튼을 누르면.. DB에 들어간다..(부서단위 결재정의)*/
//    public SepoaOut setInsert2(String[][] args) {
//        int rtn = -1;
//        String status = "C";  /* 새로 생성된 것의 status는 "C"이다.*/
//        String user_id = info.getSession("ID");
//        String add_date = WiseDate.getShortDateString();
//        String add_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setInsert2(user_id, args, status, add_date, add_time);
//            setValue("insertRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setInsert2(String user_id, String[][] args, String status, String add_date, String add_time) throws Exception, DBOpenException {
//        int result =-1;
//        String[] settype={"S","S","S","S","S","S","S","S","S","S","S","S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" insert into icomrldp (");
//            tSQL.append(" house_code, company_code, dept, doc_type, status,");
//            tSQL.append(" auto_manual_flag, strategy_type, add_date, add_time, add_user_id, ");
//            tSQL.append(" change_date, change_time,change_user_id,remark) ");
//            tSQL.append(" values(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, ?, ?, ?) ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            result = sm.doInsert(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setInsert2: " + e.getMessage());
//        }
//        return result;
//    }
//
///* 선택 박스에 체크된 Row를 삭제한다.(부서단위 결재정의) */
//    public SepoaOut setDelete2(String[][] args) {
//        try {
//            String user_id = info.getSession("ID");
//            int rtn = -1;
//            String status = "D";   /*삭제된 field 의 status는 "D"이다.*/
//            String change_date = WiseDate.getShortDateString();
//            String change_time = WiseDate.getShortTimeString();
//            rtn = et_setDelete2(user_id, args, status, change_date, change_time);
//            setValue("deleteRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setDelete2(String user_id, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//        int rtn = -1;
//        String[] settype = {"S","S","S","S"};  /*SQL 문의 ?의 타입이다.*/
//        ConnectionContext ctx = getConnectionContext();
//        try{
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" delete from icomrldp ");
//            tSQL.append(" where house_code = ? and company_code = ? ");
//            tSQL.append(" and dept = ? and doc_type = ? ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            rtn = sm.doDelete(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            System.err.println("Exception="+e.getMessage());
//        }
//        return rtn;
//    }
//
///* Jtable에다 Change하구... save 버튼을 누르면.. DB에 들어간다.. (부서단위 결재정의) */
//    public SepoaOut setUpdate2(String[][] args) {
//        int rtn = -1;
//        String status = "R";  /*수정된 항목의 status는 "R"이다.*/
//        String user_id = info.getSession("ID");
//        String change_date = WiseDate.getShortDateString();
//        String change_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setUpdate2(user_id, args, status, change_date, change_time);
//            setValue("Change_Row=" + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setUpdate2(String user_id, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//        int result = -1;
//        String[] settype = {"S","S","S","S","S","S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" update icomrldp set status = '"+status+"', ");
//            tSQL.append(" change_date = '"+change_date+"', change_time = '"+change_time+"', ");
//            //tSQL.append(" doc_type_name = ?, ");
//            tSQL.append(" auto_manual_flag = ?, strategy_type = ?, remark = ?, change_user_id = ? ");
//            tSQL.append(" where house_code = ? and company_code = ? and dept = ? and doc_type = ? ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            result = sm.doUpdate(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setUpdate: " + e.getMessage());
//        }
//        return result;
//    }
//
//
//
///***************************************************************************************************/
///************************************* 차기 결재자**************************************************/
///***************************************************************************************************/
//
///* 처음에 maintain 화면 뜨고 쿼리하면 데이타를 가져와서 보여준다.(차기결재자 등록) */
//    public wise.srv.SepoaOut getMaintain3() {
//        try{
//            String house_code = info.getSession("HOUSE_CODE");
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getMaintain3(house_code,user_id);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getMaintain3(String house_code, String user_id) throws Exception {
//        String result = null;
//        ConnectionContext ctx = getConnectionContext();
//        try {
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" select seq, next_sign_user_name, next_sign_user_id, ");
//                tSQL.append(" next_sign_position, next_sign_dept_name ");
//                tSQL.append(" from next_sign_user_vw  ");
//                tSQL.append(" where house_code = '"+house_code+"' ");
//                tSQL.append(" and user_id = '"+user_id+"' ");
//
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(null);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getMaintain3()=="+ ex.getMessage());
//        }
//        return result;
//    }
//
///* Line Insert를 하면 뜨는 팝업창에서 사용자 정보를 가져온다.(차기결재자 등록) */
//    public wise.srv.SepoaOut getUserInfo(String[] args) {
//        try{
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getUserInfo(user_id,args);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getUserInfo(String user_id,String[] args) throws Exception {
//        String result = null;
//        ConnectionContext ctx = getConnectionContext();
//
//        String house_code = "";
//        String company_code = "";
//        String id = "";
//        String name_loc = "";
//        String dept = "";
//
//        try {
//                house_code = args[0].trim();
//                company_code = args[1].trim();
//                id = args[2].trim();
//                name_loc = args[3].trim();
//                dept = args[4].trim();
//
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" SELECT COMPANY_CODE, USER_NAME_LOC, USER_ID, POSITION, ");
//                tSQL.append("        DEPT, NAME_LOC, PHONE_NO ");
//                tSQL.append(" FROM USER_POPUP_VW ");
//                tSQL.append(" WHERE HOUSE_CODE = '"+house_code+"' ");
//                //tSQL.append(" AND USER_ID != '"+user_id+"' ");
//                if(company_code.length() > 0) tSQL.append(" AND COMPANY_CODE = '"+company_code+"' ");
//                if ( id.length() > 0 ) tSQL.append(" AND USER_ID = '"+id+"' ");
//                if ( name_loc.length() > 0 ) tSQL.append(" AND USER_NAME_LOC = '"+name_loc+"' ");
//                if ( dept.length() > 0 ) tSQL.append(" AND DEPT = '"+dept+"' ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(null);
//                if(result == null) throw new Exception("SQLManager is null");
//
//        }catch(Exception ex) {
//            throw new Exception("et_getUserInfo()=="+ ex.getMessage());
//        }
//        return result;
//    }
//
//
///* Jtable에다 입력하구.. save 버튼을 누르면.. DB에 들어간다..(차기결재자 등록)*/
//    public SepoaOut setInsert3(String[][] args) {
//        int rtn = -1;
//        String user_id = info.getSession("ID");
//        String house_code = info.getSession("HOUSE_CODE");
//        String add_date = WiseDate.getShortDateString();
//        String add_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setInsert3(user_id, house_code, args, add_date, add_time);
//            setValue("insertRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setInsert3(String user_id, String house_code, String[][] args, String add_date, String add_time) throws Exception, DBOpenException {
//        int result =-1;
//        String[] settype={"S","S"};
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" insert into icomrulr (");
//            tSQL.append(" HOUSE_CODE, USER_ID, NEXT_SIGN_USER_ID, SEQ, STATUS, ");
//            tSQL.append(" ADD_DATE, ADD_TIME, ADD_USER_ID, CHANGE_DATE, CHANGE_TIME, CHANGE_USER_ID) ");
//            tSQL.append(" values('"+house_code+"', '"+user_id+"', ?, ?, 'C', ");
//            tSQL.append(" '"+add_date+"', '"+add_time+"', '"+user_id+"', ");
//            tSQL.append(" '"+add_date+"', '"+add_time+"', '"+user_id+"') ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            result = sm.doInsert(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setInsert3: " + e.getMessage());
//        }
//        return result;
//    }
//
///* 차기결재자 차수를 바꾸고 수정 버튼을 누른다.(차기결재자 ) */
//    public SepoaOut setUpdate3(String[][] args) {
//        int rtn = -1;
//        String user_id = info.getSession("ID");
//        String house_code = info.getSession("HOUSE_CODE");
//        String change_date = WiseDate.getShortDateString();
//        String change_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setUpdate3(user_id, args, house_code, change_date, change_time);
//            setValue("Change_Row=" + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setUpdate3(String user_id, String[][] args, String house_code, String change_date, String change_time) throws Exception, DBOpenException {
//        int result = -1;
//        String[] settype = {"S","S"};
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" update icomrulr set status = 'R', change_date = '"+change_date+"', ");
//            tSQL.append(" change_time = '"+change_time+"', seq = ? ");
//            tSQL.append(" where house_code = '"+house_code+"' and user_id = '"+user_id+"' ");
//            tSQL.append(" and next_sign_user_id = ? ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            result = sm.doUpdate(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setUpdate: " + e.getMessage());
//        }
//        return result;
//    }
//
///* 선택 박스에 체크된 Row를 삭제한다.(차기결재자 등록) */
//    public SepoaOut setDelete3(String[][] args) {
//        try {
//            String user_id = info.getSession("ID");
//            String house_code = info.getSession("HOUSE_CODE");
//            int rtn = -1;
//            rtn = et_setDelete3(user_id, house_code, args);
//            setValue("deleteRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setDelete3(String user_id, String house_code, String[][] args) throws Exception, DBOpenException {
//        int rtn = -1;
//        String[] settype = {"S"};  /*SQL 문의 ?의 타입이다.*/
//        ConnectionContext ctx = getConnectionContext();
//        try{
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" delete from icomrulr ");
//            tSQL.append(" where HOUSE_CODE = '"+house_code+"' and USER_ID = '"+user_id+"' ");
//            tSQL.append(" and NEXT_SIGN_USER_ID = ? ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            rtn = sm.doDelete(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            System.err.println("Exception="+e.getMessage());
//        }
//        return rtn;
//    }
//
//
///***************************************************************************************************/
///**************************************** 문서별 결재권한 *******************************************/
///***************************************************************************************************/
//
//
///* 쿼리버튼 누르면 데이타를 가져와서 보여준다. (문서별 결재권한)*/
//    public wise.srv.SepoaOut getMaintain6(String[] args) {
//        try{
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getMaintain6(user_id, args);
//            setValue(rtn);
//            setStatus(1);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(info.getSession("ID"),this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getMaintain6(String user_id, String[] args) throws Exception {
//        String result = null;
//
//        try {
//            String house_code = info.getSession("house_code");
//
//            ConnectionContext ctx = getConnectionContext();
//
//            StringBuffer tSQL = new StringBuffer();
//
//            tSQL.append(" SELECT DOC_TYPE, C.TEXT1, " +getConfig("wise.generator.db.selfuser") +  "."+ "GETICOMCODE2(C.HOUSE_CODE,'M035',DOC_DETAIL_TYPE) AS DOC_DETAIL_TYPE, SHIPPER_TYPE, PAY_CUR, \n");
//             tSQL.append("   MAX(MNG_PST_F), MAX(PAY_AMT_F), MAX(RAN_TYPE_F), MAX(MNG_PST_E), MAX(PAY_AMT_E), MAX(RAN_TYPE_E),  \n");
//            tSQL.append("   MAX(MNG_PST_D), MAX(PAY_AMT_D), MAX(RAN_TYPE_D), MAX(MNG_PST_C), MAX(PAY_AMT_C), MAX(RAN_TYPE_C),  \n");
//            tSQL.append("   MAX(MNG_PST_B), MAX(PAY_AMT_B), MAX(RAN_TYPE_B), MAX(MNG_PST_A), MAX(PAY_AMT_A), MAX(RAN_TYPE_A),DOC_DETAIL_CODE \n");
//            tSQL.append(" FROM  (SELECT DOC_TYPE, DOC_DETAIL_TYPE, SHIPPER_TYPE, PAY_CUR,                         \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '98' THEN '98' ELSE '' END AS MNG_PST_F,             \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '98' THEN AVAIL_PAY_AMT ELSE NULL END AS PAY_AMT_F,  \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '98' THEN RANGE_TYPE ELSE '' END AS RAN_TYPE_F,      \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '05' THEN '05' ELSE '' END AS MNG_PST_E,             \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '05' THEN AVAIL_PAY_AMT ELSE NULL END AS PAY_AMT_E,  \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '05' THEN RANGE_TYPE ELSE '' END AS RAN_TYPE_E,      \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '09' THEN '09' ELSE '' END AS MNG_PST_D,             \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '09' THEN AVAIL_PAY_AMT ELSE NULL END AS PAY_AMT_D,  \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '09' THEN RANGE_TYPE ELSE '' END AS RAN_TYPE_D,      \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '04' THEN '04' ELSE '' END AS MNG_PST_C,             \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '04' THEN AVAIL_PAY_AMT ELSE NULL END AS PAY_AMT_C,  \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '04' THEN RANGE_TYPE ELSE '' END AS RAN_TYPE_C,      \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '02' THEN '02' ELSE '' END AS MNG_PST_B,             \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '02' THEN AVAIL_PAY_AMT ELSE NULL END AS PAY_AMT_B,  \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '02' THEN RANGE_TYPE ELSE '' END AS RAN_TYPE_B,      \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '37' THEN '37' ELSE '' END AS MNG_PST_A,             \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '37' THEN AVAIL_PAY_AMT ELSE NULL END AS PAY_AMT_A,  \n");
//            tSQL.append("        CASE MANAGER_POSITION WHEN  '37' THEN RANGE_TYPE ELSE '' END AS RAN_TYPE_A,      \n");
//
//            /*
//            tSQL.append("        decode(manager_position,'98','98','') as mng_pst_f,              \n");
//            tSQL.append("        decode(manager_position,'98',AVAIL_PAY_AMT,'') as pay_amt_f,    \n");
//            tSQL.append("        decode(manager_position,'98',RANGE_TYPE,'') as ran_type_f,      \n");
//            tSQL.append("        decode(manager_position,'05','05','') as mng_pst_e,              \n");
//            tSQL.append("        decode(manager_position,'05',AVAIL_PAY_AMT,'') as pay_amt_e,    \n");
//            tSQL.append("        decode(manager_position,'05',RANGE_TYPE,'') as ran_type_e,      \n");
//            tSQL.append("        decode(manager_position,'09','09','') as mng_pst_d,              \n");
//            tSQL.append("        decode(manager_position,'09',AVAIL_PAY_AMT,'') as pay_amt_d,    \n");
//            tSQL.append("        decode(manager_position,'09',RANGE_TYPE,'') as ran_type_d,      \n");
//            tSQL.append("        decode(manager_position,'04','04','') as mng_pst_c,              \n");
//            tSQL.append("        decode(manager_position,'04',AVAIL_PAY_AMT,'') as pay_amt_c,    \n");
//            tSQL.append("        decode(manager_position,'04',RANGE_TYPE,'') as ran_type_c,      \n");
//            tSQL.append("        decode(manager_position,'02','02','') as mng_pst_b,              \n");
//            tSQL.append("        decode(manager_position,'02',AVAIL_PAY_AMT,'') as pay_amt_b,    \n");
//            tSQL.append("        decode(manager_position,'02',RANGE_TYPE,'') as ran_type_b,      \n");
//            tSQL.append("        decode(manager_position,'37','37','') as mng_pst_a,              \n");
//            tSQL.append("        decode(manager_position,'37',AVAIL_PAY_AMT,'') as pay_amt_a,    \n");
//            tSQL.append("        decode(manager_position,'37',RANGE_TYPE,'') as ran_type_a,      \n");
//            */
//            tSQL.append("        DOC_DETAIL_TYPE AS DOC_DETAIL_CODE                              \n");
//            tSQL.append("        FROM ICOMRLAM                                                   \n");
//            tSQL.append("        WHERE STATUS != 'D'                                             \n");
//            tSQL.append("        AND HOUSE_CODE = '"+house_code+"'                               \n");
//            tSQL.append("        <OPT=F,S> AND COMPANY_CODE = ? </OPT>                           \n");
//            /*tSQL.append("        <OPT=F,S> AND PURCHASE_LOCATION = ? </OPT> \n");*/
//            tSQL.append("        GROUP BY DOC_TYPE, DOC_DETAIL_TYPE, SHIPPER_TYPE, PAY_CUR,      \n");
//            tSQL.append("        MANAGER_POSITION, AVAIL_PAY_AMT, RANGE_TYPE) A, ICOMCODE C        \n");
//            tSQL.append(" WHERE C.HOUSE_CODE = HOUSE_CODE   \n");
//            tSQL.append(" AND C.TYPE = 'M999'               \n");
//            tSQL.append(" AND C.CODE = DOC_TYPE             \n");
//            tSQL.append(" GROUP BY DOC_TYPE, " +getConfig("wise.generator.db.selfuser") +  "."+ "GETICOMCODE2(C.HOUSE_CODE,'M035',DOC_DETAIL_TYPE), SHIPPER_TYPE, PAY_CUR, C.TEXT1,DOC_DETAIL_CODE \n");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            result = sm.doSelect(args);
//            if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getMaintain6()"+ ex.getMessage());
//        }
//        return result;
//    }
//
///* Jtable에다 입력하구.. save 버튼을 누르면.. DB에 들어간다.. (문서별 결재권한)*/
//    public SepoaOut setInsert6(String[][] args, String company_code, String purchase_location) {
//        try {
//            int rtn = -1;
//            String status = "C";  /* 새로 생성된 것의 status는 "C"이다.*/
//            String user_id = info.getSession("ID");
//            String add_date = WiseDate.getShortDateString();
//            String add_time = WiseDate.getShortTimeString();
//
//            rtn = et_setInsert6(user_id, args, status, add_date, add_time, company_code, purchase_location);
//            setValue("insertRow ==  " + rtn);
//            setStatus(1);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setInsert6(String user_id, String[][] args, String status, String add_date, String add_time, String company_code, String purchase_location)
//    throws Exception, DBOpenException
//    {
//        int result =-1;
//
//        try {
//            String house_code = info.getSession("HOUSE_CODE");
//            //String company_code = info.getSession("COMPANY_CODE");
//
//            int t = 0;
//
//            String doc_type = "";
//            String doc_detail = "";
//            String shipper_type = "";
//            String cur = "";
//            //String h_grade = "";
//            //String h_combo = "";
//            //String g_grade = "";
//            //String g_combo = "";
//            String f_grade = "";
//            String f_combo = "";
//            String e_grade = "";
//            String e_combo = "";
//            String d_grade = "";
//            String d_combo = "";
//            String c_grade = "";
//            String c_combo = "";
//            String b_grade = "";
//            String b_combo = "";
//            String a_grade = "";
//            String a_combo = "";
//
//            String[] settype={"S","S","S"};
//            ConnectionContext ctx = getConnectionContext();
//
//            SepoaSQLManager sm = null;
//            StringBuffer tSQL = new StringBuffer();
//
//            for ( int i = 0; i < args.length; i++ )
//            {
//                //company_code = args[ i ][ 0 ].trim();
//                doc_type = args[ i ][ 1 ].trim();
//                doc_detail = args[ i ][ 2 ].trim();
//                shipper_type = args[ i ][ 3 ].trim();
//                cur = args[ i ][ 4 ].trim();
//
//                //h_grade = ComputebigDecimal(args[ i ][ 5 ].trim());
//                //h_combo = args[ i ][ 6 ].trim();
//                //g_grade = ComputebigDecimal(args[ i ][ 7 ].trim());
//                //g_combo = args[ i ][ 8 ].trim();
//                f_grade = ComputebigDecimal(args[ i ][ 5 ].trim());
//                f_combo = args[ i ][ 6 ].trim();
//                e_grade = ComputebigDecimal(args[ i ][ 7 ].trim());
//                e_combo = args[ i ][ 8 ].trim();
//                d_grade = ComputebigDecimal(args[ i ][ 9 ].trim());
//                d_combo = args[ i ][ 10 ].trim();
//                c_grade = ComputebigDecimal(args[ i ][ 11 ].trim());
//                c_combo = args[ i ][ 12 ].trim();
//                b_grade = ComputebigDecimal(args[ i ][ 13 ].trim());
//                b_combo = args[ i ][ 14 ].trim();
//                a_grade = ComputebigDecimal(args[ i ][ 15 ].trim());
//                a_combo = args[ i ][ 16 ].trim();
//
//                String[] manager_position = new String[6];
//                String[] grade_amount = new String[6];
//                String[] amount_range = new String[6];
//
//                //if(!(h_grade.equals(""))) {
//                //  manager_position[t] = "H";
//                //  grade_amount[t] = h_grade;
//                //  amount_range[t] = h_combo;
//                //  t++;
//                //}
//                //if(!(g_grade.equals("")))  {
//                //  manager_position[t] = "G";
//                //  grade_amount[t] = g_grade;
//                //  amount_range[t] = g_combo;
//                //  t++;
//                //}
//                if(!(f_grade.equals(""))) {
//                    manager_position[t] = "98";
//                    grade_amount[t] = f_grade;
//                    amount_range[t] = f_combo;
//                    t++;
//                }
//
//                if(!(e_grade.equals(""))) {
//                    manager_position[t] = "05";
//                    grade_amount[t] = e_grade;
//                    amount_range[t] = e_combo;
//                    t++;
//                }
//
//                if(!(d_grade.equals(""))) {
//                    manager_position [t]= "09";
//                    grade_amount[t] = d_grade;
//                    amount_range[t] = d_combo;
//                    t++;
//                }
//
//                if(!(c_grade.equals(""))) {
//                    manager_position[t] = "04";
//                    grade_amount[t] = c_grade;
//                    amount_range[t] = c_combo;
//                    t++;
//                }
//
//                if(!(b_grade.equals(""))) {
//                    manager_position[t] = "02";
//                    grade_amount[t] = b_grade;
//                    amount_range[t] = b_combo;
//                    t++;
//                }
//
//                if(!(a_grade.equals(""))) {
//                    manager_position[t] = "37";
//                    grade_amount[t] = a_grade;
//                    amount_range[t] = a_combo;
//                    t++;
//                }
//
//                String[][] str = new String[t][3];
//                for(int r=0; r<t; r++) {
//                    str[r][0] = manager_position[r];
//                    str[r][1] = grade_amount[r];
//                    str[r][2] = amount_range[r];
//                }
//
//                if(doc_detail.equals("")){
//                    doc_detail = "X";
//                }
//
//
//                tSQL.append(" INSERT INTO ICOMRLAM(HOUSE_CODE, COMPANY_CODE, DOC_TYPE,   \n");
//                tSQL.append(" DOC_DETAIL_TYPE, SHIPPER_TYPE, MANAGER_POSITION, AVAIL_PAY_AMT,   \n");
//                tSQL.append(" RANGE_TYPE, PAY_CUR, STATUS, ADD_USER_ID, ADD_DATE, ADD_TIME)     \n");
//                tSQL.append(" values('"+house_code+"', '"+company_code +"', '"+doc_type+"',     \n");
//                tSQL.append(" '"+doc_detail+"', '"+shipper_type+"', ?, ?, ?, '"+cur+"',         \n");
//                tSQL.append(" '"+status+"','"+user_id+"', '"+add_date+"', '"+add_time+"')       \n");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doInsert(str,settype);
//
//            }//for end
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setInsert6: " + e.getMessage());
//        }
//        return result;
//    }
//
///* 수정하면 처리된다.. (문서별 결재권한)*/
//    public SepoaOut setUpdate6(String[][] args, String company_code, String purchase_location)
//    {
//        try {
//            int rtn = -1;
//            String user_id = info.getSession("ID");
//            String change_date = WiseDate.getShortDateString();
//            String change_time = WiseDate.getShortTimeString();
//
//            rtn = et_setUpdate6(user_id, args, change_date, change_time, company_code, purchase_location);
//            setValue("insertRow ==  " + rtn);
//            setStatus(1);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setUpdate6(String user_id, String[][] args, String change_date, String change_time, String company_code, String purchase_location)
//    throws Exception, DBOpenException {
//        int result =-1;
//
//        try {
//            String house_code = info.getSession("HOUSE_CODE");
//
//            int rtn_del = -1;
//            int t = 0;
//
//            String doc_type = "";
//            String doc_detail = "";
//            String shipper_type = "";
//            String cur = "";
//            //String h_grade = "";
//            //String h_combo = "";
//            //String g_grade = "";
//            //String g_combo = "";
//            String f_grade = "";
//            String f_combo = "";
//            String e_grade = "";
//            String e_combo = "";
//            String d_grade = "";
//            String d_combo = "";
//            String c_grade = "";
//            String c_combo = "";
//            String b_grade = "";
//            String b_combo = "";
//            String a_grade = "";
//            String a_combo = "";
//
//            String[] settype={"S","S","S"};
//            ConnectionContext ctx = getConnectionContext();
//            SepoaSQLManager sm = null;
//            StringBuffer tSQL = new StringBuffer();
//
//            for ( int i = 0; i < args.length; i++ ) {
//                //company_code = args[ i ][ 0 ].trim();
//                doc_type = args[ i ][ 1 ].trim();
//                doc_detail = args[ i ][ 2 ].trim();
//                shipper_type = args[ i ][ 3 ].trim();
//                cur = args[ i ][ 4 ].trim();
//                //h_grade = ComputebigDecimal(args[ i ][ 5 ].trim());
//                //h_combo = args[ i ][ 6 ].trim();
//                //g_grade = ComputebigDecimal(args[ i ][ 7 ].trim());
//                //g_combo = args[ i ][ 8 ].trim();
//                f_grade = ComputebigDecimal(args[ i ][ 5 ].trim());
//                f_combo = args[ i ][ 6 ].trim();
//                e_grade = ComputebigDecimal(args[ i ][ 7 ].trim());
//                e_combo = args[ i ][ 8 ].trim();
//                d_grade = ComputebigDecimal(args[ i ][ 9 ].trim());
//                d_combo = args[ i ][ 10 ].trim();
//                c_grade = ComputebigDecimal(args[ i ][ 11 ].trim());
//                c_combo = args[ i ][ 12 ].trim();
//                b_grade = ComputebigDecimal(args[ i ][ 13 ].trim());
//                b_combo = args[ i ][ 14 ].trim();
//                a_grade = ComputebigDecimal(args[ i ][ 15 ].trim());
//                a_combo = args[ i ][ 16 ].trim();
//
//                String[] manager_position = new String[6];
//                String[] grade_amount = new String[6];
//                String[] amount_range = new String[6];
//
//                //if(!(h_grade.equals(""))) {
//                //  manager_position[t] = "H";
//                //  grade_amount[t] = h_grade;
//                //  amount_range[t] = h_combo;
//                //  t++;
//                //}
//                //if(!(g_grade.equals("")))  {
//                //  manager_position[t] = "G";
//                //  grade_amount[t] = g_grade;
//                //  amount_range[t] = g_combo;
//                //  t++;
//                //}
//                if(!(f_grade.equals(""))) {
//                    manager_position[t] = "98";
//                    grade_amount[t] = f_grade;
//                    amount_range[t] = f_combo;
//                    t++;
//                }
//                if(!(e_grade.equals(""))) {
//                    manager_position[t] = "05";
//                    grade_amount[t] = e_grade;
//                    amount_range[t] = e_combo;
//                    t++;
//                }
//                if(!(d_grade.equals(""))) {
//                    manager_position [t]= "09";
//                    grade_amount[t] = d_grade;
//                    amount_range[t] = d_combo;
//                    t++;
//                }
//                if(!(c_grade.equals(""))) {
//                    manager_position[t] = "04";
//                    grade_amount[t] = c_grade;
//                    amount_range[t] = c_combo;
//                    t++;
//                }
//                if(!(b_grade.equals(""))) {
//                    manager_position[t] = "02";
//                    grade_amount[t] = b_grade;
//                    amount_range[t] = b_combo;
//                    t++;
//                }
//                if(!(a_grade.equals(""))) {
//                    manager_position[t] = "37";
//                    grade_amount[t] = a_grade;
//                    amount_range[t] = a_combo;
//                    t++;
//                }
//                String[][] str = new String[t][3];
//                for(int r=0; r<t; r++) {
//                    str[r][0] = grade_amount[r];
//                    str[r][1] = amount_range[r];
//                    str[r][2] = manager_position[r];
//                }
//
//                tSQL.append(" DELETE FROM ICOMRLAM                      \n");
//                tSQL.append(" WHERE HOUSE_CODE = '"+house_code+"'       \n");
//                tSQL.append("   AND COMPANY_CODE = '"+company_code +"'  \n");
//                tSQL.append("   AND DOC_TYPE = '"+doc_type+"'           \n");
//                tSQL.append("   AND DOC_DETAIL_TYPE = '"+doc_detail+"'  \n");
//                tSQL.append("   AND SHIPPER_TYPE = '"+shipper_type+"'   \n");
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                rtn_del = sm.doDelete( null, null );
//
//                tSQL = new StringBuffer();
//                tSQL.append(" INSERT INTO ICOMRLAM(HOUSE_CODE, COMPANY_CODE, DOC_TYPE,              \n");
//                tSQL.append(" DOC_DETAIL_TYPE, SHIPPER_TYPE,  AVAIL_PAY_AMT, RANGE_TYPE,            \n");
//                tSQL.append(" MANAGER_POSITION, PAY_CUR, STATUS, ADD_USER_ID, ADD_DATE, ADD_TIME)   \n");
//                tSQL.append(" values('"+house_code+"','"+company_code +"','"+doc_type+"',           \n");
//                tSQL.append(" '"+doc_detail+"', '"+shipper_type+"', ?, ?, ?, '"+cur+"',             \n");
//                tSQL.append(" 'R','"+user_id+"', '"+change_date+"', '"+change_time+"')              \n");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doInsert(str,settype);
//
//            }//for end
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setUpdate6: " + e.getMessage());
//        }
//        return result;
//    }
//
///* 선택 박스에 체크된 Row를 삭제한다.(문서별 결재권한) */
//    public SepoaOut setDelete6(String[][] args, String company_code, String purchase_location) {
//        try {
//            String user_id = info.getSession("ID");
//            String house_code = info.getSession("HOUSE_CODE");
//            //String company_code = info.getSession("COMPANY_CODE");
//            //String purchase_location = info.getSession("PURCHASE_LOCATION");
//
//            int rtn = -1;
//            rtn = et_setDelete6(user_id, house_code, company_code, purchase_location, args);
//            setValue("deleteRow ==  " + rtn);
//            setStatus(1);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            Message msg = new Message("FW");
//            setMessage(msg.getMessage("0001"));  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setDelete6(String user_id, String house_code, String company_code,
//                            String purchase_location, String[][] args) throws Exception, DBOpenException {
//        int rtn = -1;
//
//        try{
//            String[] settype = {"S","S","S","S"};
//            ConnectionContext ctx = getConnectionContext();
//
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" DELETE FROM ICOMRLAM                          \n");
//            tSQL.append(" WHERE HOUSE_CODE = '"+house_code+"'           \n");
//            tSQL.append("   AND COMPANY_CODE = '"+company_code+"'       \n");
//            tSQL.append("   AND DOC_TYPE = ? AND DOC_DETAIL_TYPE = ?    \n");
//            tSQL.append("   AND SHIPPER_TYPE = ? AND PAY_CUR = ?        \n");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            rtn = sm.doDelete(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            System.err.println("Exception="+e.getMessage());
//        }
//        return rtn;
//    }
//
//
//
//
///* 쿼리버튼 누르면 데이타를 가져와서 보여준다. (문서별 결재권한)*/
///*
//    public wise.srv.SepoaOut getMaintain6(String[] args) {
//        try{
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getMaintain6(user_id, args);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getMaintain6(String user_id, String[] args) throws Exception {
//        String result = null;
//        String house_code = info.getSession("house_code");
//
//        ConnectionContext ctx = getConnectionContext();
//        try {
//                StringBuffer tSQL = new StringBuffer();
//
//                tSQL.append(" select doc_type, c.text1, doc_detail_type, shipper_type, pay_cur, ");
//                tSQL.append("   max(mng_pst_h), max(pay_amt_h), max(ran_type_h), max(mng_pst_g), max(pay_amt_g), max(ran_type_g),  ");
//                tSQL.append("   max(mng_pst_f), max(pay_amt_f), max(ran_type_f), max(mng_pst_e), max(pay_amt_e), max(ran_type_e),  ");
//                tSQL.append("   max(mng_pst_d), max(pay_amt_d), max(ran_type_d), max(mng_pst_c), max(pay_amt_c), max(ran_type_c),  ");
//                tSQL.append("   max(mng_pst_b), max(pay_amt_b), max(ran_type_b), max(mng_pst_a), max(pay_amt_a), max(ran_type_a) ");
//                tSQL.append(" from  (select doc_type, doc_detail_type, shipper_type, pay_cur, ");
//                tSQL.append("        decode(manager_position,'H','H','') as mng_pst_h, ");
//                tSQL.append("        decode(manager_position,'H',AVAIL_PAY_AMT,'') as pay_amt_h, ");
//                tSQL.append("        decode(manager_position,'H',RANGE_TYPE,'') as ran_type_h, ");
//                tSQL.append("        decode(manager_position,'G','G','') as mng_pst_g, ");
//                tSQL.append("        decode(manager_position,'G',AVAIL_PAY_AMT,'') as pay_amt_g, ");
//                tSQL.append("        decode(manager_position,'G',RANGE_TYPE,'') as ran_type_g, ");
//                tSQL.append("        decode(manager_position,'F','F','') as mng_pst_f, ");
//                tSQL.append("        decode(manager_position,'F',AVAIL_PAY_AMT,'') as pay_amt_f, ");
//                tSQL.append("        decode(manager_position,'F',RANGE_TYPE,'') as ran_type_f, ");
//                tSQL.append("        decode(manager_position,'E','E','') as mng_pst_e, ");
//                tSQL.append("        decode(manager_position,'E',AVAIL_PAY_AMT,'') as pay_amt_e, ");
//                tSQL.append("        decode(manager_position,'E',RANGE_TYPE,'') as ran_type_e, ");
//                tSQL.append("        decode(manager_position,'D','D','') as mng_pst_d, ");
//                tSQL.append("        decode(manager_position,'D',AVAIL_PAY_AMT,'') as pay_amt_d, ");
//                tSQL.append("        decode(manager_position,'D',RANGE_TYPE,'') as ran_type_d, ");
//                tSQL.append("        decode(manager_position,'C','C','') as mng_pst_c, ");
//                tSQL.append("        decode(manager_position,'C',AVAIL_PAY_AMT,'') as pay_amt_c, ");
//                tSQL.append("        decode(manager_position,'C',RANGE_TYPE,'') as ran_type_c, ");
//                tSQL.append("        decode(manager_position,'B','B','') as mng_pst_b, ");
//                tSQL.append("        decode(manager_position,'B',AVAIL_PAY_AMT,'') as pay_amt_b, ");
//                tSQL.append("        decode(manager_position,'B',RANGE_TYPE,'') as ran_type_b, ");
//                tSQL.append("        decode(manager_position,'A','A','') as mng_pst_a, ");
//                tSQL.append("        decode(manager_position,'A',AVAIL_PAY_AMT,'') as pay_amt_a, ");
//                tSQL.append("        decode(manager_position,'A',RANGE_TYPE,'') as ran_type_a ");
//                tSQL.append("        from icomrlam ");
//                tSQL.append("        where status != 'D' ");
//                tSQL.append("        and house_code = '"+house_code+"' ");
//                tSQL.append("        <OPT=F,S> and company_code = ? </OPT>  ");
//                tSQL.append("        group by doc_type, doc_detail_type, shipper_type, pay_cur,  ");
//                tSQL.append("        manager_position, avail_pay_amt, range_type), icomcode c ");
//                tSQL.append(" where c.house_code = house_code ");
//                tSQL.append(" and c.type = 'M999' ");
//                tSQL.append(" and c.code = doc_type ");
//                tSQL.append(" group by doc_type, doc_detail_type, shipper_type, pay_cur, c.text1 ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(args);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getMaintain6()"+ ex.getMessage());
//        }
//        return result;
//    }
//
//// Jtable에다 입력하구.. save 버튼을 누르면.. DB에 들어간다.. (문서별 결재권한)
//    public SepoaOut setInsert6(String[][] args, String company_code, String purchase_location)
//    {
//        int rtn = -1;
//        String status = "C";
//        String user_id = info.getSession("ID");
//        String add_date = WiseDate.getShortDateString();
//        String add_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setInsert6(user_id, args, status, add_date, add_time);
//            setValue("insertRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setInsert6(String user_id, String[][] args, String status, String add_date, String add_time) throws Exception, DBOpenException {
//        String house_code = info.getSession("HOUSE_CODE");
//        int result =-1;
//        int t = 0;
//
//        String company_code  = "";
//        String doc_type = "";
//        String doc_detail = "";
//        String shipper_type = "";
//        String cur = "";
//        String h_grade = "";
//        String h_combo = "";
//        String g_grade = "";
//        String g_combo = "";
//        String f_grade = "";
//        String f_combo = "";
//        String e_grade = "";
//        String e_combo = "";
//        String d_grade = "";
//        String d_combo = "";
//        String c_grade = "";
//        String c_combo = "";
//        String b_grade = "";
//        String b_combo = "";
//        String a_grade = "";
//        String a_combo = "";
//
//        String[] settype={"S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//        SepoaSQLManager sm = null;
//        StringBuffer tSQL = new StringBuffer();
//
//        try {
//            for ( int i = 0; i < args.length; i++ ) {
//                company_code = args[ i ][ 0 ].trim();
//                doc_type = args[ i ][ 1 ].trim();
//                doc_detail = args[ i ][ 2 ].trim();
//                shipper_type = args[ i ][ 3 ].trim();
//                cur = args[ i ][ 4 ].trim();
//                h_grade = ComputebigDecimal(args[ i ][ 5 ].trim());
//                h_combo = args[ i ][ 6 ].trim();
//                g_grade = ComputebigDecimal(args[ i ][ 7 ].trim());
//                g_combo = args[ i ][ 8 ].trim();
//                f_grade = ComputebigDecimal(args[ i ][ 9 ].trim());
//                f_combo = args[ i ][ 10 ].trim();
//                e_grade = ComputebigDecimal(args[ i ][ 11 ].trim());
//                e_combo = args[ i ][ 12 ].trim();
//                d_grade = ComputebigDecimal(args[ i ][ 13 ].trim());
//                d_combo = args[ i ][ 14 ].trim();
//                c_grade = ComputebigDecimal(args[ i ][ 15 ].trim());
//                c_combo = args[ i ][ 16 ].trim();
//                b_grade = ComputebigDecimal(args[ i ][ 17 ].trim());
//                b_combo = args[ i ][ 18 ].trim();
//                a_grade = ComputebigDecimal(args[ i ][ 19 ].trim());
//                a_combo = args[ i ][ 20 ].trim();
//
//                String[] manager_position = new String[8];
//                String[] grade_amount = new String[8];
//                String[] amount_range = new String[8];
//
//                if(!(h_grade.equals(""))) {
//                    manager_position[t] = "H";
//                    grade_amount[t] = h_grade;
//                    amount_range[t] = h_combo;
//                    t++;
//                }
//                if(!(g_grade.equals("")))  {
//                    manager_position[t] = "G";
//                    grade_amount[t] = g_grade;
//                    amount_range[t] = g_combo;
//                    t++;
//                }
//                if(!(f_grade.equals(""))) {
//                    manager_position[t] = "F";
//                    grade_amount[t] = f_grade;
//                    amount_range[t] = f_combo;
//                    t++;
//                }
//                if(!(e_grade.equals(""))) {
//                    manager_position[t] = "E";
//                    grade_amount[t] = e_grade;
//                    amount_range[t] = e_combo;
//                    t++;
//                }
//                if(!(d_grade.equals(""))) {
//                    manager_position [t]= "D";
//                    grade_amount[t] = d_grade;
//                    amount_range[t] = d_combo;
//                    t++;
//                }
//                if(!(c_grade.equals(""))) {
//                    manager_position[t] = "C";
//                    grade_amount[t] = c_grade;
//                    amount_range[t] = c_combo;
//                    t++;
//                }
//                if(!(b_grade.equals(""))) {
//                    manager_position[t] = "B";
//                    grade_amount[t] = b_grade;
//                    amount_range[t] = b_combo;
//                    t++;
//                }
//                if(!(a_grade.equals(""))) {
//                    manager_position[t] = "A";
//                    grade_amount[t] = a_grade;
//                    amount_range[t] = a_combo;
//                    t++;
//                }
//
//                String[][] str = new String[t][3];
//                for(int r=0; r<t; r++) {
//                    str[r][0] = manager_position[r];
//                    str[r][1] = grade_amount[r];
//                    str[r][2] = amount_range[r];
//                }
//
//                tSQL.append(" insert into ICOMRLAM(HOUSE_CODE, COMPANY_CODE, DOC_TYPE, ");
//                tSQL.append(" DOC_DETAIL_TYPE, SHIPPER_TYPE, MANAGER_POSITION, AVAIL_PAY_AMT, ");
//                tSQL.append(" RANGE_TYPE, PAY_CUR, STATUS, ADD_USER_ID, ADD_DATE, ADD_TIME) ");
//                tSQL.append(" values('"+house_code+"', '"+company_code +"', '"+doc_type+"',  ");
//                tSQL.append(" '"+doc_detail+"', '"+shipper_type+"', ?, ?, ?, '"+cur+"', ");
//                tSQL.append(" '"+status+"','"+user_id+"', '"+add_date+"', '"+add_time+"') ");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doInsert(str,settype);
//
//            }//for end
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setInsert6: " + e.getMessage());
//        }
//        return result;
//    }
//
//// 수정하면 처리된다.. (문서별 결재권한)
//    public SepoaOut setUpdate6(String[][] args) {
//        int rtn = -1;
//        String user_id = info.getSession("ID");
//        String change_date = WiseDate.getShortDateString();
//        String change_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setUpdate6(user_id, args, change_date, change_time);
//            setValue("insertRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setUpdate6(String user_id, String[][] args, String change_date, String change_time) throws Exception, DBOpenException {
//
//        String house_code = info.getSession("HOUSE_CODE");
//        int rtn_del = -1;
//        int result =-1;
//        int t = 0;
//
//        String company_code  = "";
//        String doc_type = "";
//        String doc_detail = "";
//        String shipper_type = "";
//        String cur = "";
//        String h_grade = "";
//        String h_combo = "";
//        String g_grade = "";
//        String g_combo = "";
//        String f_grade = "";
//        String f_combo = "";
//        String e_grade = "";
//        String e_combo = "";
//        String d_grade = "";
//        String d_combo = "";
//        String c_grade = "";
//        String c_combo = "";
//        String b_grade = "";
//        String b_combo = "";
//        String a_grade = "";
//        String a_combo = "";
//
//        String[] settype={"S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//        SepoaSQLManager sm = null;
//        StringBuffer tSQL = new StringBuffer();
//
//
//        try {
//            for ( int i = 0; i < args.length; i++ ) {
//                company_code = args[ i ][ 0 ].trim();
//                doc_type = args[ i ][ 1 ].trim();
//                doc_detail = args[ i ][ 2 ].trim();
//                shipper_type = args[ i ][ 3 ].trim();
//                cur = args[ i ][ 4 ].trim();
//                h_grade = ComputebigDecimal(args[ i ][ 5 ].trim());
//                h_combo = args[ i ][ 6 ].trim();
//                g_grade = ComputebigDecimal(args[ i ][ 7 ].trim());
//                g_combo = args[ i ][ 8 ].trim();
//                f_grade = ComputebigDecimal(args[ i ][ 9 ].trim());
//                f_combo = args[ i ][ 10 ].trim();
//                e_grade = ComputebigDecimal(args[ i ][ 11 ].trim());
//                e_combo = args[ i ][ 12 ].trim();
//                d_grade = ComputebigDecimal(args[ i ][ 13 ].trim());
//                d_combo = args[ i ][ 14 ].trim();
//                c_grade = ComputebigDecimal(args[ i ][ 15 ].trim());
//                c_combo = args[ i ][ 16 ].trim();
//                b_grade = ComputebigDecimal(args[ i ][ 17 ].trim());
//                b_combo = args[ i ][ 18 ].trim();
//                a_grade = ComputebigDecimal(args[ i ][ 19 ].trim());
//                a_combo = args[ i ][ 20 ].trim();
//
//                String[] manager_position = new String[8];
//                String[] grade_amount = new String[8];
//                String[] amount_range = new String[8];
//
//                if(!(h_grade.equals(""))) {
//                    manager_position[t] = "H";
//                    grade_amount[t] = h_grade;
//                    amount_range[t] = h_combo;
//                    t++;
//                }
//                if(!(g_grade.equals("")))  {
//                    manager_position[t] = "G";
//                    grade_amount[t] = g_grade;
//                    amount_range[t] = g_combo;
//                    t++;
//                }
//                if(!(f_grade.equals(""))) {
//                    manager_position[t] = "F";
//                    grade_amount[t] = f_grade;
//                    amount_range[t] = f_combo;
//                    t++;
//                }
//                if(!(e_grade.equals(""))) {
//                    manager_position[t] = "E";
//                    grade_amount[t] = e_grade;
//                    amount_range[t] = e_combo;
//                    t++;
//                }
//                if(!(d_grade.equals(""))) {
//                    manager_position [t]= "D";
//                    grade_amount[t] = d_grade;
//                    amount_range[t] = d_combo;
//                    t++;
//                }
//                if(!(c_grade.equals(""))) {
//                    manager_position[t] = "C";
//                    grade_amount[t] = c_grade;
//                    amount_range[t] = c_combo;
//                    t++;
//                }
//                if(!(b_grade.equals(""))) {
//                    manager_position[t] = "B";
//                    grade_amount[t] = b_grade;
//                    amount_range[t] = b_combo;
//                    t++;
//                }
//                if(!(a_grade.equals(""))) {
//                    manager_position[t] = "A";
//                    grade_amount[t] = a_grade;
//                    amount_range[t] = a_combo;
//                    t++;
//                }
//                String[][] str = new String[t][3];
//                for(int r=0; r<t; r++) {
//                    str[r][0] = grade_amount[r];
//                    str[r][1] = amount_range[r];
//                    str[r][2] = manager_position[r];
//                }
//
//                tSQL.append(" delete from icomrlam ");
//                tSQL.append(" where HOUSE_CODE = '"+house_code+"' and COMPANY_CODE = '"+company_code +"' ");
//                tSQL.append(" and DOC_TYPE = '"+doc_type+"' and DOC_DETAIL_TYPE = '"+doc_detail+"' ");
//                tSQL.append(" and SHIPPER_TYPE = '"+shipper_type+"' ");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                rtn_del = sm.doDelete( null, null );
//
//                tSQL = new StringBuffer();
//
//                    tSQL.append(" insert into ICOMRLAM(HOUSE_CODE, COMPANY_CODE, DOC_TYPE, ");
//                    tSQL.append(" DOC_DETAIL_TYPE, SHIPPER_TYPE,  AVAIL_PAY_AMT, RANGE_TYPE, ");
//                    tSQL.append(" MANAGER_POSITION, PAY_CUR, STATUS, ADD_USER_ID, ADD_DATE, ADD_TIME) ");
//                    tSQL.append(" values('"+house_code+"', '"+company_code +"', '"+doc_type+"',  ");
//                    tSQL.append(" '"+doc_detail+"', '"+shipper_type+"', ?, ?, ?, '"+cur+"', ");
//                    tSQL.append(" 'R','"+user_id+"', '"+change_date+"', '"+change_time+"') ");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doInsert(str,settype);
//
//            }//for end
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            throw new Exception("et_setUpdate6: " + e.getMessage());
//        }
//        return result;
//    }
//
//// 선택 박스에 체크된 Row를 삭제한다.(문서별 결재권한)
//    public SepoaOut setDelete6(String[][] args) {
//        try {
//            String user_id = info.getSession("ID");
//            String house_code = info.getSession("HOUSE_CODE");
//            int rtn = -1;
//            rtn = et_setDelete6(user_id, house_code, args);
//            setValue("deleteRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setDelete6(String user_id, String house_code, String[][] args) throws Exception, DBOpenException {
//        int rtn = -1;
//        String[] settype = {"S","S","S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//        try{
//            StringBuffer tSQL = new StringBuffer();
//            tSQL.append(" delete from icomrlam ");
//            tSQL.append(" where HOUSE_CODE = '"+house_code+"' and company_code = ? ");
//            tSQL.append(" and doc_type = ? and doc_detail_type = ? ");
//            tSQL.append(" and shipper_type = ? and pay_cur = ? ");
//
//            SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//            rtn = sm.doDelete(args,settype);
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            System.err.println("Exception="+e.getMessage());
//        }
//        return rtn;
//    }
//*/
//
/**
 * 수동결재인지 자동결재인지 여부를 체크해준다 (부서단위 결재정의).
 * @param args
 * @return
 */
    public SepoaOut autoDepCheck (String[] args){
        try{
        	String rtn = et_autoDepCheck(args);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
        }
        return getSepoaOut();
    }


    private String et_autoDepCheck(String[] args) throws Exception {
    	//doc_type, dept_code, company_code, house_code
    	String rtn = null;
    	Map<String, String> param = new HashMap<String, String>();
        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//        tSQL.append(" SELECT DOC_TYPE  							\n ");
//        tSQL.append(" 	, AUTO_MANUAL_FLAG  					\n ");
//        tSQL.append(" 	, STRATEGY_TYPE  						\n ");
//        tSQL.append(" FROM ICOMRLDP                             \n ");
//        tSQL.append(" WHERE STATUS != 'D'                       \n ");
//        tSQL.append(" <OPT=F,S> AND DOC_TYPE = ? </OPT>         \n ");
//        tSQL.append(" <OPT=F,S> AND DEPT = ? </OPT>             \n ");
//        tSQL.append(" <OPT=F,S> AND COMPANY_CODE = ? </OPT>     \n ");
//        tSQL.append(" <OPT=F,S> AND HOUSE_CODE = ? </OPT>       \n ");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
            param.put("doc_type", args[0]);
            param.put("dept_code", args[1]);
            
            rtn = sm.doSelect(param);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }

/**
 * 수동결재인지 자동결재인지 여부를 체크해준다 (회사단위 결재정의).
 * @param args
 * @return
 */
    public SepoaOut autoComCheck (String[] args){
        try{
        	String rtn = et_autoComCheck(args);
            setValue(rtn);
            setStatus(1);
            setMessage(msg.getMessage("0000"));
        }catch(Exception e){
            setStatus(0);
            setMessage(msg.getMessage("0001"));
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
        }
        return getSepoaOut();
    }

    private String et_autoComCheck(String[] args) throws Exception {
    	String rtn = null;
        ConnectionContext ctx = getConnectionContext();

        SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

//        tSQL.append(" SELECT DOC_TYPE  									\n ");
//        tSQL.append(" 	, AUTO_MANUAL_FLAG  							\n ");
//        tSQL.append(" 	, STRATEGY_TYPE  								\n ");
//        tSQL.append(" FROM ICOMRLCM                                     \n ");
//        tSQL.append(" WHERE STATUS != 'D'                               \n ");
//        tSQL.append(" <OPT=F,S> AND DOC_TYPE = ? </OPT>                 \n ");
//        tSQL.append(" <OPT=F,S> AND COMPANY_CODE = ? </OPT>             \n ");
//        tSQL.append(" <OPT=F,S> AND HOUSE_CODE = ? </OPT>               \n ");

        try{
            SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx, wxp.getQuery());
            rtn = sm.doSelect(args);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,e.getMessage());
            throw new Exception(e.getMessage());
        }
        return rtn;
    }
//
///* 수동결재일때 로긴한 사용자와 관련되어있는 차기 결재자들을 DB에서 가져온다.*/
//    public wise.srv.SepoaOut getAppPerson() {
//        try{
//            String house_code = info.getSession("HOUSE_CODE");
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getAppPerson(house_code, user_id);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getAppPerson(String house_code,String user_id) throws Exception {
//        String result = null;
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" select NEXT_SIGN_USER_ID ");
//                tSQL.append(" from icomrulr ");
//                tSQL.append(" where house_code = '"+house_code+"' ");
//                tSQL.append(" and user_id = '"+user_id+"' ");
//                tSQL.append(" order by seq ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(null);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getAppPerson()"+ ex.getMessage());
//        }
//        return result;
//    }
//
///* 자동 결재일때 차기결재자를 따로 지정하지 않고 로긴한 사용자의 첫번째 차기 결재자를 DB에서 가져온다.*/
//    public wise.srv.SepoaOut getAppPerson2() {
//        try{
//            String house_code = info.getSession("HOUSE_CODE");
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getAppPerson2(house_code,user_id);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getAppPerson2(String house_code, String user_id) throws Exception {
//        String result = null;
//        ConnectionContext ctx = getConnectionContext();
//
//        try {
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" select next_sign_user_id ");
//                tSQL.append(" from icomrulr ");
//                tSQL.append(" where house_code = '"+house_code+"' ");
//                tSQL.append(" and user_id = '"+user_id+"' ");
//                tSQL.append(" and seq = (select min(seq) from icomrulr ");
//                tSQL.append(" where user_id = '"+user_id+"' ) ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(null);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getAppPerson2()"+ ex.getMessage());
//        }
//        return result;
//    }
//
///***************************************************************************************************/
///******************************** 결재 승인 화면 ***************************************************/
///***************************************************************************************************/
//
///* 문서형태, 문서상태, 내/외자 구분 조건을 입력하고 Query 버튼을 누르면 Data를 가져온다..(결재승인현황) */
//    public wise.srv.SepoaOut getMaintain4(String[] args) {
//        try{
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            String app_status = args[4];
//            rtn = et_getMaintain4(user_id, app_status, args);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getMaintain4(String user_id, String app_status, String[] args) throws Exception {
//        String result = null;
//        ConnectionContext ctx = getConnectionContext();
//        try {
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" select a.app_status, ");
//                tSQL.append(" geticomcode1(a.house_code,'M999',decode(instr(doc_type,'^'),'0',a.doc_type,substr(doc_type,1,instr(doc_type,'^')-1))), ");
//                tSQL.append(" a.doc_no, decode(substr(doc_seq,8,2),'AD','계약금','JD','중도금','RD','잔금', ");
//                tSQL.append(" '00','계획결재','01','결과결재',doc_seq), ");
//                tSQL.append(" a.item_count, b.user_name_loc, a.add_date, a.cur, a.ttl_amt, a.account_code, ");
//                tSQL.append(" a.sign_user_id1, a.sign_user_id2, a.sign_user_id3, a.sign_user_id4, ");
//                tSQL.append(" a.sign_user_id5, a.sign_user_id6, a.sign_user_id7, a.next_sign_user_id, ");
//                tSQL.append(" nvl(a.app_stage,0), a.argent_flag, a.shipper_type, a.sign_remark, ");
//                tSQL.append(" a.sign_remark1, a.sign_remark2, a.sign_remark3, a.sign_remark4, a.sign_remark5, ");
//                tSQL.append(" a.sign_remark6, a.sign_remark7, a.doc_seq, a.doc_type, a.conv_ttl_amt, a.company_code, a.strategy_type ");
//                tSQL.append(" from icomsctm a, icomlusr b ");
//                tSQL.append(" <OPT=F,S> where a.house_code = ? </OPT> ");
//                //tSQL.append(" <OPT=F,S> and a.company_code = ? </OPT> ");
//                tSQL.append(" and a.next_sign_user_id = '"+user_id+"' ");
//                tSQL.append(" and a.app_status != 'N' ");
//                tSQL.append(" <OPT=S,S> and decode(instr(doc_type,'^'),'0',a.doc_type,substr(doc_type,1,instr(doc_type,'^')-1)) = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.doc_no = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.app_status  = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.shipper_type = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.ctrl_person_id = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.add_date between ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and ? </OPT> ");
//                tSQL.append(" and a.house_code = b.house_code(+) ");
//                tSQL.append(" and a.add_user_id = b.user_id(+) ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(args);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getMaintain4()"+ ex.getMessage());
//        }
//        return result;
//    }
//
///*자기가 상신한 결재 문서를 볼 수 있다.*/
//    public wise.srv.SepoaOut getMaintain5(String[] args) {
//        try{
//            String user_id = info.getSession("ID");
//            String rtn = null;
//            rtn = et_getMaintain5(user_id, args);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e){
//            System.out.println("Eception e = " + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this, e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getMaintain5(String user_id, String[] args) throws Exception {
//        String result = null;
//        ConnectionContext ctx = getConnectionContext();
//        try {
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" select a.app_status, ");
//                tSQL.append(" geticomcode1(a.house_code,'M999',decode(instr(doc_type,'^'),'0',a.doc_type,substr(doc_type,1,instr(doc_type,'^')-1))), ");
//                tSQL.append(" a.doc_no, decode(substr(doc_seq,8,2),'AD','계약금','JD','중도금','RD','잔금', ");
//                tSQL.append(" '00','계획결재','01','결과결재',doc_seq), ");
//                tSQL.append(" a.item_count, a.add_date, a.cur, a.ttl_amt, a.account_code, a.sign_user_id1, ");
//                tSQL.append(" a.sign_user_id2, a.sign_user_id3, a.sign_user_id4, a.sign_user_id5, ");
//                tSQL.append(" a.sign_user_id6, a.sign_user_id7, next_sign_user_id, ");
//                tSQL.append(" nvl(a.app_stage,0), a.argent_flag, a.shipper_type, a.sign_remark, ");
//                tSQL.append(" a.sign_remark1, a.sign_remark2, a.sign_remark3, a.sign_remark4, ");
//                tSQL.append(" a.sign_remark5, a.sign_remark6, a.sign_remark7, doc_seq, a.doc_type, a.company_code, decode(a.app_status,'P',a.next_sign_user_id,'') ");
//                tSQL.append(" from icomsctm a, icomlusr b ");
//                tSQL.append(" <OPT=F,S> where a.house_code = ? </OPT> ");
//                //tSQL.append(" <OPT=F,S> and a.company_code = ? </OPT> ");
//                tSQL.append(" and a.add_user_id = '"+user_id+"' ");
//                tSQL.append(" and a.app_status != 'N' ");
//                tSQL.append(" <OPT=S,S> and decode(instr(doc_type,'^'),'0',a.doc_type,substr(doc_type,1,instr(doc_type,'^')-1)) = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.doc_no = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.app_status  = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.shipper_type = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.ctrl_person_id = ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and a.add_date between ? </OPT> ");
//                tSQL.append(" <OPT=S,S> and ? </OPT> ");
//                tSQL.append(" and a.house_code = b.house_code(+) ");
//                tSQL.append(" and a.add_user_id = b.user_id(+) ");
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doSelect(args);
//                if(result == null) throw new Exception("SQLManager is null");
//        }catch(Exception ex) {
//            throw new Exception("et_getMaintain5()"+ ex.getMessage());
//        }
//        return result;
//    }
//
///* 차기결재버튼을 눌렀을때 뜨는 Pop up 화면에서. 결재자 지정하고 확인 누르면 DB 에 Update된다..*/
//    public SepoaOut setUpdate4(String[][] args) {
//        int rtn = -1;
//        String status = "R";  /* 새로 생성된 것의 status는 "C"이다.*/
//        String user_id = info.getSession("ID");
//        String change_date = WiseDate.getShortDateString();
//        String change_time = WiseDate.getShortTimeString();
//
//        try {
//            rtn = et_setUpdate4(user_id, args, status, change_date, change_time);
//            setValue("updateRow ==  " + rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//        }catch(Exception e) {
//            System.out.println("Exception= " + e.getMessage());
//            setStatus(0);
//            setMessage(e.getMessage());  /* Message를 등록한다. */
//        }
//        return getSepoaOut();
//    }
//
//    private int et_setUpdate4(String user_id, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//        int result =-1;
//        String rtn = "";
//        String[] settype={"S","S","S","S","S","S","S","S","S","S"};
//        ConnectionContext ctx = getConnectionContext();
//        SepoaSQLManager sm = null;
//
//        String app_person = "";
//        String app_stage = "";
//        String remark = "";
//        String doc_no = "";
//        String doc_type = "";
//        String doc_seq = "";
//        String dom_exp_flag = "";
//        String dept_code = "";
//        String company_code = "";
//        String house_code = "";
//        String p_position = "";
//        String m_position = "";
//
//        try {
//
//            house_code = args[0][9].trim();  // house_code 는 session에서 가져온값
//
//            StringBuffer sql = new StringBuffer();
//            sql.append(" select position, manager_position ");
//            sql.append(" from icomlusr ");
//            sql.append(" where house_code = '"+house_code+"' ");
//            sql.append(" and user_id = '"+user_id+"' ");
//            sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
//            rtn = sm.doSelect(null);
//            WiseFormater wf = new WiseFormater( rtn );
//                    p_position = wf.getValue( 0, 0 );
//            m_position = wf.getValue( 0, 1 );
//            Logger.debug.println(user_id, this, "p_position******wf.getValue( 0, 0 )======"+p_position);
//            Logger.debug.println(user_id, this, "m_position******wf.getValue( 0, 1 )======"+m_position);
//
//            for ( int i = 0; i < args.length; i++ ) {
//
//                app_person = args[i][0].trim();
//                app_stage = args[i][1].trim();
//                remark = args[i][2].trim();
//                doc_no = args[i][3].trim();
//                doc_type = args[i][4].trim();
//                doc_seq = args[i][5].trim();
//                dom_exp_flag = args[i][6].trim();
//                dept_code = args[i][7].trim();
//                company_code = args[i][8].trim();
//
//
//
//
//
//
//                Logger.debug.println(user_id, this, "******setUpdate4***************");
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" update icomsctm set next_sign_user_id = '"+app_person+"', ");
//                if(app_stage.equals("0")) {
//                    tSQL.append(" sign_user_id1 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark1 = '"+remark+"', ");
//                    tSQL.append(" sign_date1 = '"+change_date+"', ");
//                    tSQL.append(" sign_time1 = '"+change_time+"', ");
//                    tSQL.append(" sign_position1 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position1 = '"+m_position+"', ");
//                }else if(app_stage.equals("1")) {
//                    tSQL.append(" sign_user_id2 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark2 = '"+remark+"', ");
//                    tSQL.append(" sign_date2 = '"+change_date+"', ");
//                    tSQL.append(" sign_time2 = '"+change_time+"', ");
//                    tSQL.append(" sign_position2 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position2 = '"+m_position+"', ");
//                }else if(app_stage.equals("2")) {
//                    tSQL.append(" sign_user_id3 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark3 = '"+remark+"', ");
//                    tSQL.append(" sign_date3 = '"+change_date+"', ");
//                    tSQL.append(" sign_time3 = '"+change_time+"', ");
//                    tSQL.append(" sign_position3 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position3 = '"+m_position+"', ");
//                }else if(app_stage.equals("3")) {
//                    tSQL.append(" sign_user_id4 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark4 = '"+remark+"', ");
//                    tSQL.append(" sign_date4 = '"+change_date+"', ");
//                    tSQL.append(" sign_time4 = '"+change_time+"', ");
//                    tSQL.append(" sign_position4 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position4 = '"+m_position+"', ");
//                }else if(app_stage.equals("4")) {
//                    tSQL.append(" sign_user_id5 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark5 = '"+remark+"', ");
//                    tSQL.append(" sign_date5 = '"+change_date+"', ");
//                    tSQL.append(" sign_time5 = '"+change_time+"', ");
//                    tSQL.append(" sign_position5 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position5 = '"+m_position+"', ");
//                }else if(app_stage.equals("5")) {
//                    tSQL.append(" sign_user_id6 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark6 = '"+remark+"', ");
//                    tSQL.append(" sign_date6 = '"+change_date+"', ");
//                    tSQL.append(" sign_time6 = '"+change_time+"', ");
//                    tSQL.append(" sign_position6 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position6 = '"+m_position+"', ");
//                }else {
//                    tSQL.append(" sign_user_id7 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark7 = '"+remark+"', ");
//                    tSQL.append(" sign_date7 = '"+change_date+"', ");
//                    tSQL.append(" sign_time7 = '"+change_time+"', ");
//                    tSQL.append(" sign_position7 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position7 = '"+m_position+"', ");
//                }
//
//                //app_stage를 7단계 이상 갈수 없게 한다.
//                if(Integer.parseInt(app_stage) < 7 )
//                    tSQL.append(" app_stage = "+(Integer.parseInt(app_stage)+1)+", ");
//                tSQL.append(" status = 'R' ");
//                tSQL.append(" where house_code = '"+house_code+"' and company_code = '"+company_code+"' and doc_no = '"+doc_no+"' and NVL(doc_seq,0) = '"+doc_seq+"' ");
//                tSQL.append(" and doc_type = '"+doc_type+"' ");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doUpdate(null,null);
//            }
//            Commit();
//        }catch(Exception e) {
//            Rollback();
//            setMessage(e.getMessage());
//            throw new Exception("et_setUpdate4: " + e.getMessage());
//
//        }
//        return result;
//    }
//
///* 반려를 누르면 결재상태가 반려(R)로 setting 되고 문서 상태도 변경(R)로 그리고 변경시간, 날짜, 변경자.. 등등이 setting 됨*/
//    public SepoaOut setRefund(String[][] args) {
//        int rtn = -1;
//        SepoaOut result = null;
//        String status = "R";  /* 새로 생성된 것의 status는 "C"이다.*/
//        String user_id = info.getSession("ID");
//        String change_date = WiseDate.getShortDateString();
//        String change_time = WiseDate.getShortTimeString();
//        SepoaApproval wa = null;
//        SignResponseInfo sri = new SignResponseInfo();
//        String[] doc_no = new String[args.length];
//        String[] doc_seq = new String[args.length];
//        String[] company_code = new String[args.length];
//        String[] shipper_type = new String[args.length];
//        String doc_type = "";
//        String remark = "";
//
//
//        try {
//            ConnectionContext ctx = getConnectionContext();
//            rtn = et_setRefund(ctx, user_id, args, status, change_date, change_time);
//
//            if(rtn > 0) { //sctm에 반려 처리는 성공.
//
//                sri.setHouseCode(args[0][9]);
//                //sri.setDept(args[0][7]);  부서부분 SignResponseInfo 에 setting하는 부분
//                sri.setDocType(args[0][4]);
//                sri.setSignRemark(args[0][2]);
//
//                for(int t=0; t<args.length; t++) {
//                    doc_no[t] = args[t][3];
//                    doc_seq[t] = args[t][5];
//                    shipper_type[t] = args[t][6];
//                    company_code[t] = args[t][8];
//                }
//                    sri.setDocNo(doc_no);
//                    sri.setDocSeq(doc_seq);
//                    sri.setSignUserId(user_id);
//                    sri.setCompanyCode(company_code);
//                    sri.setShipperType(shipper_type);
//                    sri.setSignStatus("R");
//            }
//            result = setModeApp(ctx,args[0][4], sri);
//
//            if(result.status == 0) {
//                try{
//                    setStatus(0);
//                    setMessage(result.message);
//                    Rollback();
//                }catch(Exception e2) {setMessage(e2.getMessage()); }
//                    Logger.debug.println(user_id, this, "롤백했음...");
//
//
//            }    //if 문
//
//            if(result.status == 1) {
//                setValue("updateRow ==  " + rtn);
//                setStatus(1);
//                Commit();
//                setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//            }
//            Logger.debug.println(user_id, this, "result===****=="+result);
//        }catch(Exception e) {
//            try{Rollback();}catch(Exception e1) {setMessage(e1.getMessage()); }
//            Logger.debug.println(user_id, this, " 반려(각모듈호출시)=="+e.getMessage());
//            setStatus(0);
//            setMessage(e.getMessage());  /* Message를 등록한다. */
//
//        }
//        return getSepoaOut();
//    }
//
//
//    private int et_setRefund(ConnectionContext ctx, String user_id, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//        int result =-1;
//        String rtn = "";
//        String[] settype={"S","S","S","S","S","S","S","S","S"};
//        SepoaSQLManager sm = null;
//
//        String app_person = "";
//        String app_stage = "";
//        String remark = "";
//        String doc_no = "";
//        String doc_type = "";
//        String doc_seq = "";
//        String dom_exp_flag = "";
//        String dept_code = "";
//        String company_code = "";
//        String house_code = "";
//        String p_position = "";
//        String m_position = "";
//
//        try {
//
//            house_code = args[0][9].trim(); // house_code 는 session에서 가져온값
//
//            StringBuffer sql = new StringBuffer();
//            sql.append(" select position, manager_position  ");
//            sql.append(" from icomlusr ");
//            sql.append(" where house_code = '"+house_code+"' ");
//            sql.append(" and user_id = '"+user_id+"' ");
//            sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
//            rtn = sm.doSelect(null);
//            WiseFormater wf = new WiseFormater( rtn );
//                    p_position = wf.getValue( 0, 0 );
//            m_position = wf.getValue( 0, 1 );
//
//            for ( int i = 0; i < args.length; i++ ) {
//
//                app_person = args[i][0].trim();
//                app_stage = args[i][1].trim();
//                remark = args[i][2].trim();
//                doc_no = args[i][3].trim();
//                doc_type = args[i][4].trim();
//                doc_seq = args[i][5].trim();
//                dom_exp_flag = args[i][6].trim();
//                dept_code = args[i][7].trim();
//                company_code = args[i][8].trim();
//
//
//
//
//                Logger.debug.println(user_id, this, "******et_setRefund***************");
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" update icomsctm set ");
//                if(app_stage.equals("0")) {
//                    tSQL.append(" sign_user_id1 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark1 = '"+remark+"', ");
//                    tSQL.append(" sign_date1 = '"+change_date+"', ");
//                    tSQL.append(" sign_time1 = '"+change_time+"', ");
//                    tSQL.append(" sign_position1 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position1 = '"+m_position+"', ");
//                }else if(app_stage.equals("1")) {
//                    tSQL.append(" sign_user_id2 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark2 = '"+remark+"', ");
//                    tSQL.append(" sign_date2 = '"+change_date+"', ");
//                    tSQL.append(" sign_time2 = '"+change_time+"', ");
//                    tSQL.append(" sign_position2 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position2 = '"+m_position+"', ");
//                }else if(app_stage.equals("2")) {
//                    tSQL.append(" sign_user_id3 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark3 = '"+remark+"', ");
//                    tSQL.append(" sign_date3 = '"+change_date+"', ");
//                    tSQL.append(" sign_time3 = '"+change_time+"', ");
//                    tSQL.append(" sign_position3 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position3 = '"+m_position+"', ");
//                }else if(app_stage.equals("3")) {
//                    tSQL.append(" sign_user_id4 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark4 = '"+remark+"', ");
//                    tSQL.append(" sign_date4 = '"+change_date+"', ");
//                    tSQL.append(" sign_time4 = '"+change_time+"', ");
//                    tSQL.append(" sign_position4 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position4 = '"+m_position+"', ");
//                }else if(app_stage.equals("4")) {
//                    tSQL.append(" sign_user_id5 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark5 = '"+remark+"', ");
//                    tSQL.append(" sign_date5 = '"+change_date+"', ");
//                    tSQL.append(" sign_time5 = '"+change_time+"', ");
//                    tSQL.append(" sign_position5 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position5 = '"+m_position+"', ");
//                }else if(app_stage.equals("5")) {
//                    tSQL.append(" sign_user_id6 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark6 = '"+remark+"', ");
//                    tSQL.append(" sign_date6 = '"+change_date+"', ");
//                    tSQL.append(" sign_time6 = '"+change_time+"', ");
//                    tSQL.append(" sign_position6 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position6 = '"+m_position+"', ");
//                }else {
//                    tSQL.append(" sign_user_id7 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark7 = '"+remark+"', ");
//                    tSQL.append(" sign_date7 = '"+change_date+"', ");
//                    tSQL.append(" sign_time7 = '"+change_time+"', ");
//                    tSQL.append(" sign_position7 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position7 = '"+m_position+"', ");
//                }
//                tSQL.append(" status = 'R', app_status = 'R' ");
//                tSQL.append(" where house_code = '"+house_code+"' and company_code = '"+company_code+"' and doc_no = '"+doc_no+"' and NVL(doc_seq,0) = '"+doc_seq+"' ");
//                tSQL.append(" and doc_type = '"+doc_type+"' ");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doUpdate(null,null);
//            }
//            //Commit();
//        }catch(Exception e) {
//            //Rollback();
//            setMessage(e.getMessage());
//            throw new Exception("et_setRefund: " + e.getMessage());
//        }
//        return result;
//    }
//
//
//
//
//    /**
//    * app_status
//    */
//    public SepoaOut CheckStatus(String[] args){
//
//        try
//        {
//            String user_id = info.getSession("ID");
//            Logger.debug.println(user_id,this,"######getMainternace#######");
//            String rtn = new String();
//            // Isvalue(); ....
//            rtn = et_CheckStatus( args, user_id);
//            Logger.debug.println(user_id,this,"result"+rtn);
//            setValue(rtn);
//
//            if (!rtn.equals("P"))
//            {
//                setMessage("결재가 이미 이루어졌습니다.");
//                setStatus(0);
//            }else {
//                setStatus(1);
//                setMessage(msg.getMessage("0000"));
//            }
//
//        }catch(Exception e)
//        {
//            Logger.err.println("Exception e =" + e.getMessage());
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(this,e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_CheckStatus(String[] args, String user_id) throws Exception
//    {
//        String app_status = new String();
//        String rtn = new String();
//        ConnectionContext ctx = getConnectionContext();
//        try {
//                StringBuffer tSQL = new StringBuffer();
//
//                tSQL.append(" select app_status ");
//                tSQL.append(" from icomsctm ");
//                tSQL.append("  <OPT=F,S> where house_code = ?   </OPT>  ");
//                tSQL.append("  <OPT=S,S> and company_code = ? </OPT>  ");
//                tSQL.append(" <OPT=S,S> and doc_type = ? </OPT> ");
//                tSQL.append("  <OPT=S,S> and doc_no = ? </OPT> ");
//                tSQL.append("  <OPT=S,S> and NVL(doc_seq,0) = ? </OPT> ");
//
//
//                SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
//
//                rtn = sm.doSelect(args);
//
//
//                WiseFormater wf = new WiseFormater( rtn );
//                        app_status = wf.getValue( 0, 0 );
//
//
//
//
//            if(rtn == null) throw new Exception("SQL Manager is Null");
//            }catch(Exception e) {
//                throw new Exception("et_getMainternace_icomvnpt:"+e.getMessage());
//            } finally{
//
//        }
//        return app_status;
//    }
//
//
//
//
//
//
//
//
///* 종료결재를 누르면 결재상태가 종료(E)로 setting 되고 결재 완료일자가 setting 되고, 결재단계 증가하고 차기결재자 아이디가 */
///* (결재단계)번째 결재자로 들어가면서 초기화되고, 문서 상태도 변경(R)로 그리고 변경시간, 날짜, 변경자.. 등등이 setting 됨*/
//    public SepoaOut setEndApp(String[][] args) {
//        int rtn = -1;
//        SepoaOut result = null;
//        String status = "R";  /* 새로 생성된 것의 status는 "C"이다.*/
//        String user_id = info.getSession("ID");
//        String change_date = WiseDate.getShortDateString();
//        String change_time = WiseDate.getShortTimeString();
//        SepoaApproval wa = null;
//        SignResponseInfo sri = new SignResponseInfo();
//        String[] doc_no = new String[args.length];
//        String[] doc_seq = new String[args.length];
//        String[] company_code = new String[args.length];
//        String[] shipper_type = new String[args.length];
//        String doc_type = "";
//
//        try {
//            ConnectionContext ctx = getConnectionContext();
//            rtn = et_setEndApp(ctx, user_id, args, status, change_date, change_time);
//
//            if(rtn > 0) { //sctm에 종료결재 처리는 성공.
//
//                sri.setHouseCode(args[0][9]);
//                //sri.setDept(args[0][7]);  부서부분 SignResponseInfo 에 setting하는 부분
//                sri.setDocType(args[0][4]);
//
//                for(int t=0; t<args.length; t++) {
//                    doc_no[t] = args[t][3];
//                    doc_seq[t] = args[t][5];
//                    shipper_type[t] = args[t][6];
//                    company_code[t] = args[t][8];
//                }
//                    sri.setDocNo(doc_no);
//                    sri.setDocSeq(doc_seq);
//                    sri.setSignUserId(user_id);
//                    sri.setShipperType(shipper_type);
//                    sri.setCompanyCode(company_code);
//                    sri.setSignStatus("E");
//            }
//            result = setModeApp(ctx,args[0][4], sri);
//            if(result.status == 0) {
//                try{
//                    setStatus(0);
//                    setMessage(result.message);
//                    Rollback();
//
//                }catch(Exception e2) {
//                    setMessage(e2.getMessage());
//                    Logger.debug.println(user_id, this, "롤백하다 catch.."+e2.getMessage());
//                }
//                    Logger.debug.println(user_id, this, "롤백했음...");
//
//
//            } //if 문
//
//            if(result.status == 1) {
//                setValue("updateRow ==  " + rtn);
//                setStatus(1);
//                Commit();
//                setMessage(msg.getMessage("0000"));  /* Message를 등록한다. */
//            }
//
//        }catch(Exception e) {
//            try{Rollback();}catch(Exception e1) {}
//            Logger.debug.println(user_id, this,"모듈 호출하다가 = " + e.getMessage());
//            setStatus(0);
//            setMessage(e.getMessage());  /* Message를 등록한다. */
//            return getSepoaOut();
//        }
//
//
//        return getSepoaOut();
//    }
//
//    private int et_setEndApp(ConnectionContext ctx, String user_id, String[][] args, String status, String change_date, String change_time) throws Exception, DBOpenException {
//        int result =-1;
//        String rtn = "";
//        String[] settype={"S","S","S","S","S","S","S","S","S"};
//        SepoaSQLManager sm = null;
//
//        String app_person = "";
//        String app_stage = "";
//        String remark = "";
//        String doc_no = "";
//        String doc_type = "";
//        String doc_seq = "";
//        String dom_exp_flag = "";
//        String dept_code = "";
//        String company_code = "";
//        String house_code = "";
//        String p_position = "";
//        String m_position = "";
//
//        try {
//
//
//            house_code = args[0][9].trim();// house_code 는 session에서 가져온값
//
//
//
//            StringBuffer sql = new StringBuffer();
//            sql.append(" select position, manager_position ");
//            sql.append(" from icomlusr ");
//            sql.append(" where house_code = '"+house_code+"' ");
//            sql.append(" and user_id = '"+user_id+"' ");
//            sm = new SepoaSQLManager(user_id, this, ctx, sql.toString());
//            rtn = sm.doSelect(null);
//            WiseFormater wf = new WiseFormater( rtn );
//                    p_position = wf.getValue( 0, 0 );
//            m_position = wf.getValue( 0, 1 );
//
//            for ( int i = 0; i < args.length; i++ ) {
//                app_person = args[i][0].trim();
//                app_stage = args[i][1].trim();
//                remark = args[i][2].trim();
//                doc_no = args[i][3].trim();
//                doc_type = args[i][4].trim();
//                doc_seq = args[i][5].trim();
//                dom_exp_flag = args[i][6].trim();
//                dept_code = args[i][7].trim();
//                company_code = args[i][8].trim();
//
//
//
//
//                Logger.debug.println(user_id, this, "******et_setEndApp***************");
//                StringBuffer tSQL = new StringBuffer();
//                tSQL.append(" update icomsctm set ");
//                if(app_stage.equals("0")) {
//                    tSQL.append(" sign_user_id1 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark1 = '"+remark+"', ");
//                    tSQL.append(" sign_date1 = '"+change_date+"', ");
//                    tSQL.append(" sign_time1 = '"+change_time+"', ");
//                    tSQL.append(" sign_position1 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position1 = '"+m_position+"', ");
//                }else if(app_stage.equals("1")) {
//                    tSQL.append(" sign_user_id2 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark2 = '"+remark+"', ");
//                    tSQL.append(" sign_date2 = '"+change_date+"', ");
//                    tSQL.append(" sign_time2 = '"+change_time+"', ");
//                    tSQL.append(" sign_position2 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position2 = '"+m_position+"', ");
//                }else if(app_stage.equals("2")) {
//                    tSQL.append(" sign_user_id3 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark3 = '"+remark+"', ");
//                    tSQL.append(" sign_date3 = '"+change_date+"', ");
//                    tSQL.append(" sign_time3 = '"+change_time+"', ");
//                    tSQL.append(" sign_position3 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position3 = '"+m_position+"', ");
//                }else if(app_stage.equals("3")) {
//                    tSQL.append(" sign_user_id4 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark4 = '"+remark+"', ");
//                    tSQL.append(" sign_date4 = '"+change_date+"', ");
//                    tSQL.append(" sign_time4 = '"+change_time+"', ");
//                    tSQL.append(" sign_position4 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position4 = '"+m_position+"', ");
//                }else if(app_stage.equals("4")) {
//                    tSQL.append(" sign_user_id5 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark5 = '"+remark+"', ");
//                    tSQL.append(" sign_date5 = '"+change_date+"', ");
//                    tSQL.append(" sign_time5 = '"+change_time+"', ");
//                    tSQL.append(" sign_position5 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position5 = '"+m_position+"', ");
//                }else if(app_stage.equals("5")) {
//                    tSQL.append(" sign_user_id6 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark6 = '"+remark+"', ");
//                    tSQL.append(" sign_date6 = '"+change_date+"', ");
//                    tSQL.append(" sign_time6 = '"+change_time+"', ");
//                    tSQL.append(" sign_position6 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position6 = '"+m_position+"', ");
//                }else {
//                    tSQL.append(" sign_user_id7 = '"+user_id+"', ");
//                    tSQL.append(" sign_remark7 = '"+remark+"', ");
//                    tSQL.append(" sign_date7 = '"+change_date+"', ");
//                    tSQL.append(" sign_time7 = '"+change_time+"', ");
//                    tSQL.append(" sign_position7 = '"+p_position+"', ");
//                    tSQL.append(" sign_m_position7 = '"+m_position+"', ");
//                }
//
//                //app_stage를 7단계 이상 갈수 없게 한다.
//                if(Integer.parseInt(app_stage) < 7 )
//                    tSQL.append(" app_stage = "+(Integer.parseInt(app_stage)+1)+", ");
//
//                tSQL.append(" status = 'R', app_status = 'E' ");
//                tSQL.append(" where house_code = '"+house_code+"' and company_code = '"+company_code+"' and doc_no = '"+doc_no+"' and NVL(doc_seq,0) = '"+doc_seq+"' ");
//                tSQL.append(" and doc_type = '"+doc_type+"' ");
//
//                sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
//                result = sm.doUpdate(null,null);
//            }
//            //Commit();
//        }catch(Exception e) {
//            //Rollback();
//            result = -1;
//            setMessage(e.getMessage());
//            throw new Exception("et_setUpdate4: " + e.getMessage());
//        }
//        return result;
//    }
//
/* 결재요청목록에서 결재취소 버튼을 누르면 DB에서 해당항목을 지운다. */
    public SepoaOut setCancel(String[][] args, SignResponseInfo sri, String doc_type) {
    	try {
    		int	rtn	= -1;
    		SepoaOut	result = null;
    		ConnectionContext ctx =	getConnectionContext();

        	rtn = et_setCancel(args);
        	if(rtn < 1)
				throw new Exception("UPDATE ICOMSCTM ERROR");

        	result = setModeApp(ctx, doc_type,	sri);

			if(result.status ==	0) {
				try{
					setStatus(0);
					setMessage(msg.getMessage("0009"));
					Rollback();

				}catch(Exception e2) {
					Logger.err.println(info.getSession("ID"),this,e2.getMessage());
				}

			}else{
 	            setStatus(1);
	            setMessage(msg.getMessage("0012"));
				Commit();
			}

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
            setMessage(msg.getMessage("0013"));
		}

        return getSepoaOut();
	}

    private int et_setCancel(String[][] args) throws Exception, DBOpenException {
        int rtn = -1;
        try	{
//        StringBuffer tSQL = new StringBuffer();
		ConnectionContext ctx = getConnectionContext();

		String[] settype={"S","S","S","S","S"};

		SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_1");

//		tSQL.append(" DELETE FROM ICOMSCTM 		\n");
//        tSQL.append(" WHERE DOC_NO = ? 			\n");
//        tSQL.append(" AND DOC_TYPE = ? 			\n");
//        tSQL.append(" AND DOC_SEQ = ? 			\n");
//        tSQL.append(" AND COMPANY_CODE = ? 		\n");
//        tSQL.append(" AND HOUSE_CODE = ? 		\n");

        SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
        rtn = sm.doDelete(args,settype);

        wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName()+"_2");
// 		StringBuffer tSQL2 =	new	StringBuffer();
//
//		tSQL2.append(" DELETE FROM ICOMSCTP 		\n");
//        tSQL2.append(" WHERE DOC_NO = ? 			\n");
//        tSQL2.append(" AND DOC_TYPE = ? 			\n");
//        tSQL2.append(" AND DOC_SEQ = ? 				\n");
//        tSQL2.append(" AND COMPANY_CODE = ? 		\n");
//        tSQL2.append(" AND HOUSE_CODE = ? 			\n");

        SepoaSQLManager sm1 = new SepoaSQLManager(info.getSession("ID"), this, ctx, wxp.getQuery());
        rtn = sm1.doDelete(args,settype);

		}catch(Exception e)	{
			rtn = -1;
			setMessage(e.getMessage());
			//Logger.err.println(info.getSession("ID"), this, stackTrace(e));
			throw new Exception("et_setEndApp: " + e.getMessage());
		}
		return rtn;
	}

/**
 * 종료결재나 반려된뒤에	각 운영모듈의 메소드를 불러준다.
 * @param ctx
 * @param doc_type
 * @param sri
 * @return
 * @throws Exception
 */
	private	SepoaOut	setModeApp(	ConnectionContext ctx, String doc_type,	SignResponseInfo sri) throws Exception
	{
		SepoaApproval wa = null;
        SepoaOut value = null;
        String doc_type_h = "";
        try {
            if(doc_type.indexOf("^")== -1) doc_type_h = doc_type;
            else {
                StringTokenizer st1 = new StringTokenizer(doc_type, "^");
                doc_type_h = st1.nextToken();
            }
            String conType = "NONDBJOB";          //conType : CONNECTION/TRANSACTION/NONDBJOB
            String MethodName = "Approval";   //NickName으로 연결된 Class에 정의된 Method Name
            String serviceId = doc_type_h;

            /*타입 저장*/
            sri.setDocType(doc_type_h);

            wa = new SepoaApproval( serviceId, conType, info );
            wa.setConnection(ctx);
            Object[] args = {sri};
            value = wa.lookup( MethodName, args );

        }catch(Exception e) {
            throw new Exception(e.getMessage());
        }

        return value;
    }

///**
// * 상세화면을 띄워줄 URL을 가져온다.
// * @param args
// * @return
// */
//    public wise.srv.SepoaOut getURL(String[] args) {
//    	try{
//            String rtn = et_getURL(args);
//            setValue(rtn);
//            setStatus(1);
//            setMessage(msg.getMessage("0000"));
//        }catch(Exception e){
//            setStatus(0);
//            setMessage(msg.getMessage("0001"));
//            Logger.err.println(info.getSession("ID"),this,e.getMessage());
//        }
//        return getSepoaOut();
//    }
//
//    private String et_getURL(String[] args) throws Exception {
//    	String rtn = null;
//        ConnectionContext ctx = getConnectionContext();
//        StringBuffer tSQL = new StringBuffer();
//
//        tSQL.append(" SELECT TEXT1 							\n");
//        tSQL.append(" FROM ICOMCODE 						\n");
//        tSQL.append(" WHERE TYPE = 'S004' 					\n");
//        tSQL.append(" <OPT=F,S> AND CODE = ? </OPT> 		\n");
//        tSQL.append(" <OPT=F,S> AND HOUSE_CODE = ? </OPT> 	\n");
//
//        try {
//    		SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,tSQL.toString());
//            rtn = sm.doSelect(args);
//    	}catch(Exception e) {
//            Logger.err.println(info.getSession("ID"),this,e.getMessage());
//            throw new Exception(e.getMessage());
//        }
//        return rtn;
//    }
//
}