package sepoa.svc.contract;

import java.io.File;
import java.security.MessageDigest ;
import java.util.HashMap ;
import java.util.Map ;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.collections.MapUtils ;

import kica.sgic.util.DataToXml ;
import kica.sgic.util.SGIxLinker ;
import kica.sgic.util.XmlToData ;
import sepoa.fw.cfg.Config ;
import sepoa.fw.cfg.Configuration ;
import sepoa.fw.cfg.ConfigurationException ;
import sepoa.fw.db.ConnectionContext ;
import sepoa.fw.db.ParamSql ;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.db.SepoaXmlParser;
import sepoa.fw.log.Logger ;
import sepoa.fw.msg.* ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.SepoaService ;
import sepoa.fw.srv.SepoaServiceException ;
import sepoa.fw.util.CommonUtil ;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.DocumentUtil ;
import sepoa.fw.util.JSPUtil ;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaMath;
import sepoa.fw.util.SepoaString;
import sepoa.svc.admin.AD_3123 ;
import sepoa.svc.sourcing.PU_112;
import signgate.sgic.xmlmanager.util.FileWriteUtil;
import tradesign.crypto.provider.JeTS ;
import tradesign.pki.pkix.SignedData ;
import tradesign.pki.pkix.X509Certificate ;
import tradesign.pki.util.JetsUtil ;
public class CT_001 extends SepoaService {

	private String ID = info.getSession("ID");
    //20131210 sendakun
    private HashMap msg = null;
	private SepoaFormater bondSf = null;
	public CT_001(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	    //20131210 sendakun
        try {
//            msg = new Message(info, "PU_005_BEAN");
            //PU_005_BEAN 자체가 없음 JSP SCREEN_ID CT_006 로 변경.
            msg = MessageUtil.getMessageMap( info, "CT_006");
        } catch ( Exception e ) {
            // TODO Auto-generated catch block
        	Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }
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
	
	//계약대상현황조회
	public SepoaOut getWaitList(Map<String, Object> data){

		setStatus(1);
		setFlag(true);
		ConnectionContext ctx = getConnectionContext();
		
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		
		try {
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
			sxp = new SepoaXmlParser(this, "getWaitList");
			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
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
	
	public SepoaOut setFail(String flag) {
		
		try {
			
			String messg = "";
				
			Rollback();
			setFlag(false);
			setStatus(0);
			
			//PU_005_BEAN 자체가 없음 아래 메시지 찾아서 CT_006에 등록하여 처리 해야함.
			if(flag.equals("insert")){
				messg = "0002";
			}else{
				messg = "0003";
			}
			
//			setMessage(msg.getMessage(messg));
//			Logger.debug.println(info.getSession("ID"),this, "BD_NO]"+msg.getMessage(messg));
			setMessage(msg.get(messg).toString());
			Logger.debug.println(info.getSession("ID"),this, "BD_NO]"+msg.get(messg).toString());
			
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
    public SepoaOut setCTInsert(  Map< String, Object > allData  ) throws Exception {

        ConnectionContext ctx              = getConnectionContext();
        StringBuffer      sb               = new StringBuffer();
        ParamSql          sm               = new ParamSql(info.getSession("ID"), this, ctx);
        SepoaOut          nb               = null;
        SepoaOut          sa               = null;
        SepoaFormater     sf               = null;
        SepoaFormater     signHashSf       = null;
        MessageDigest     md               = null; 
        SignedData        sd               = null;
        String            data             = null;
        Config            conf             = null;
        AD_3123           fileHashProcess  = null;
        SepoaOut          file_value       = null;
        X509Certificate[] certs            = null;
        String            CertDn[]         = null;
        String            Strcpvr[]        = null;
        String            HashStr          = ""; 
        String            tradesign_path   = "";
        String            file_msg         = "";
        String            Strb64_enc       = "";
        byte[]           result            = null;
        byte[]           b64_enc           = null;
		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
        try {
            setStatus(1);
            setFlag(true);
            Map<String, String>       headerData = MapUtils.getMap(allData, "headerData");
            // 저장 & 수정-------------------------------------------------------------------------------------------------------------------시작
            if("IU".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) ) || "BCC".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) )  || "BCU".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) ) ){ 
                headerData.put ( "ct_flag" , "CT" );
                if("BCC".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) )){
                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_count");
        			customHeader.put("cont_gl_seq", String.valueOf ( Integer.parseInt ( MapUtils.getString ( headerData , "cont_gl_seq"  , "1" ) ) + 1 ));
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	sf = new SepoaFormater(ssm.doSelect(headerData, customHeader));
                }

                customHeader.put( "cont_date                ".trim ( ), MapUtils.getString ( headerData , "cont_date                ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "current_date             ".trim ( ), MapUtils.getString ( headerData , "current_date             ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "cont_amt                 ".trim ( ), MapUtils.getString ( headerData , "cont_amt                 ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "del_flag                 ".trim ( ), MapUtils.getString ( headerData , "del_flag                 ".trim ( ) , sepoa.fw.util.CommonUtil.Flag.No.getValue()) ); 
                customHeader.put( "cont_from                ".trim ( ), MapUtils.getString ( headerData , "cont_from                ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "cont_to                  ".trim ( ), MapUtils.getString ( headerData , "cont_to                  ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "st_date                  ".trim ( ), MapUtils.getString ( headerData , "st_date                  ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "rd_date                  ".trim ( ), MapUtils.getString ( headerData , "rd_date                  ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "first_amt                ".trim ( ), MapUtils.getString ( headerData , "first_amt                ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "third_amt                ".trim ( ), MapUtils.getString ( headerData , "third_amt                ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_01            ".trim ( ), MapUtils.getString ( headerData , "second_amt_01            ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_02            ".trim ( ), MapUtils.getString ( headerData , "second_amt_02            ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_03            ".trim ( ), MapUtils.getString ( headerData , "second_amt_03            ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_04            ".trim ( ), MapUtils.getString ( headerData , "second_amt_04            ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_05            ".trim ( ), MapUtils.getString ( headerData , "second_amt_05            ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "first_amt_ratio          ".trim ( ), MapUtils.getString ( headerData , "first_amt_ratio          ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "third_amt_ratio          ".trim ( ), MapUtils.getString ( headerData , "third_amt_ratio          ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_ratio_01      ".trim ( ), MapUtils.getString ( headerData , "second_amt_ratio_01      ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_ratio_02      ".trim ( ), MapUtils.getString ( headerData , "second_amt_ratio_02      ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_ratio_03      ".trim ( ), MapUtils.getString ( headerData , "second_amt_ratio_03      ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_ratio_04      ".trim ( ), MapUtils.getString ( headerData , "second_amt_ratio_04      ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "second_amt_ratio_05      ".trim ( ), MapUtils.getString ( headerData , "second_amt_ratio_05      ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "first_amt_date           ".trim ( ), MapUtils.getString ( headerData , "first_amt_date           ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "third_amt_date           ".trim ( ), MapUtils.getString ( headerData , "third_amt_date           ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "second_amt_date_01       ".trim ( ), MapUtils.getString ( headerData , "second_amt_date_01       ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "second_amt_date_02       ".trim ( ), MapUtils.getString ( headerData , "second_amt_date_02       ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "second_amt_date_03       ".trim ( ), MapUtils.getString ( headerData , "second_amt_date_03       ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "second_amt_date_04       ".trim ( ), MapUtils.getString ( headerData , "second_amt_date_04       ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "second_amt_date_05       ".trim ( ), MapUtils.getString ( headerData , "second_amt_date_05       ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "pre_ins_amt              ".trim ( ), MapUtils.getString ( headerData , "pre_ins_amt              ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "pre_ins_percent          ".trim ( ), MapUtils.getString ( headerData , "pre_ins_percent          ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "pre_ins_date             ".trim ( ), MapUtils.getString ( headerData , "pre_ins_date             ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "cont_ins_amt             ".trim ( ), MapUtils.getString ( headerData , "cont_ins_amt             ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "cont_ins_percent         ".trim ( ), MapUtils.getString ( headerData , "cont_ins_percent         ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "cont_ins_from            ".trim ( ), MapUtils.getString ( headerData , "cont_ins_from            ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "cont_ins_to              ".trim ( ), MapUtils.getString ( headerData , "cont_ins_to              ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "fault_ins_amt            ".trim ( ), MapUtils.getString ( headerData , "fault_ins_amt            ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "fault_ins_percent        ".trim ( ), MapUtils.getString ( headerData , "fault_ins_percent        ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "discard_date             ".trim ( ), MapUtils.getString ( headerData , "discard_date             ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "send_date                ".trim ( ), MapUtils.getString ( headerData , "send_date                ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "sel_accept_date          ".trim ( ), MapUtils.getString ( headerData , "sel_accept_date          ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "buy_accept_date          ".trim ( ), MapUtils.getString ( headerData , "buy_accept_date          ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "cont_ttl_amt             ".trim ( ), MapUtils.getString ( headerData , "cont_ttl_amt             ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "cont_vat                 ".trim ( ), MapUtils.getString ( headerData , "cont_vat                 ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "pay_terms_date           ".trim ( ), MapUtils.getString ( headerData , "pay_terms_date           ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "delay_price              ".trim ( ), MapUtils.getString ( headerData , "delay_price              ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "delay_date1              ".trim ( ), MapUtils.getString ( headerData , "delay_date1              ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "delay_price1             ".trim ( ), MapUtils.getString ( headerData , "delay_price1             ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "delay_date2              ".trim ( ), MapUtils.getString ( headerData , "delay_date2              ".trim ( ) , "" ).replaceAll ( "-" , "" ) ); 
                customHeader.put( "delay_price2             ".trim ( ), MapUtils.getString ( headerData , "delay_price2             ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "item_qty1                ".trim ( ), MapUtils.getString ( headerData , "item_qty1                ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "unit_price1              ".trim ( ), MapUtils.getString ( headerData , "unit_price1              ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "item_amt1                ".trim ( ), MapUtils.getString ( headerData , "item_amt1                ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "item_qty2                ".trim ( ), MapUtils.getString ( headerData , "item_qty2                ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "unit_price2              ".trim ( ), MapUtils.getString ( headerData , "unit_price2              ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                customHeader.put( "item_amt2                ".trim ( ), MapUtils.getString ( headerData , "item_amt2                ".trim ( ) , "" ).replaceAll ( "," , "" ) ); 
                if("".equals ( MapUtils.getString ( headerData , "cont_number" , "" ).replaceAll ( " " , "" ) ) //계약번호가 없다면 1차 INSERT
                   || ("BCC".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) ) //
                   && "0".equals ( JSPUtil.nullToEmpty ( (sf != null)?sf.getValue ( "CNT" , 0 ):"" ) ) )
                   ){
                    if("BCC".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) )){
                        headerData.put ( "cont_number" , MapUtils.getString ( headerData , "cont_number" , "" ) );
                        headerData.put ( "cont_gl_seq" , String.valueOf ( Integer.parseInt ( MapUtils.getString ( headerData , "cont_gl_seq"  , "1" ) ) + 1 )  );
                    }else{
                        headerData.put ( "cont_number" , DocumentUtil.getDocNumber ( info , "CT" ).result[0] );
                        if("BCU".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) ) && "".equals ( MapUtils.getString ( headerData , "rfq_number" ) )){
                            headerData.put ( "cont_gl_seq" , "2" );
                        }else{
                            headerData.put ( "cont_gl_seq" , "1" );
                        }
                    }

                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_insert");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doInsert(headerData, customHeader);
                    setMessage (  MapUtils.getString ( headerData , "cont_number" , "" ) + msg.get("CT_006.0006"));//번의 계약서를 저장하였습니다.
                }else{ 
                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_update");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doUpdate(headerData, customHeader);
                    setMessage (  MapUtils.getString ( headerData , "cont_number" , "" ) + msg.get ( "CT_006.0007" ));//번의 계약서를 수정하였습니다.
                }

                if("SEND".equals (  MapUtils.getString ( headerData , "doc_type_send".trim ( ) , "" )  )){
                    headerData.put ( "ct_flag" , "CB" );
                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_update_send");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doUpdate(headerData, customHeader);
                    setMessage (  MapUtils.getString ( headerData , "cont_number" , "" ) + msg.get("CT_006.0008"));//번의 계약서를 업체에게 전송하였습니다.
                }
            }
            // 저장 & 수정-------------------------------------------------------------------------------------------------------------------끝
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            // 업체전송   -------------------------------------------------------------------------------------------------------------------시작
            else if("SS".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) )){
                headerData.put ( "ct_flag" , "CB" );
            	sxp = new SepoaXmlParser(this, "setCTInsert_contract_update_send");
            	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            	ssm.doUpdate(headerData, customHeader);
                setMessage (  MapUtils.getString ( headerData , "cont_number" , "" ) + msg.get("CT_006.0008"));//번의 계약서를 업체에게 전송하였습니다.
            }
            // 업체전송   -------------------------------------------------------------------------------------------------------------------끝
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            // 업체인증   -------------------------------------------------------------------------------------------------------------------시작
            else if("SA".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) )){
                sa = getContractDeaitl ( headerData ) ;       // 계약쿼리실행
                sf = new SepoaFormater ( sa.result [ 0 ] ) ; // 쿼리데이타 SepoaFormatter에 담음
                if ( sf.getRowCount ( ) > 0 ) {              // 계약데이타가 존재한다면
                    sb.append ( getContContent ( sf ) ) ;    // 계약데이타를 스트링 버퍼에 담음.
                    Logger.debug.println ( "SELLER_CONTRACT_INFO=|||" + sb.toString ( ) + "|||");
                } else {
                    new Exception ( msg.get ( "CT_006.0009" ).toString() ) ;//계약서 정보가 존재하지 않습니다.
                }
                if ( !"true".equals ( getConfig ( "sepoa.server.development.flag" ) ) ) {
                
                    Strb64_enc = "" ;
                    data = sb.toString();
                    conf = new Configuration ( ) ;
                    tradesign_path = conf.get ( "sepoa.tradesign.path" ) ;
                    JeTS.installProvider ( tradesign_path ) ;
                    JeTS.reInstallProvider ( tradesign_path ) ;
                    
                    md = MessageDigest.getInstance ( "HAS160" , "JeTS" ) ;
                    result = md.digest ( data.getBytes ( ) ) ;
                    HashStr = new String ( JetsUtil.encodeBase64 ( result ) ) ;
                    b64_enc = JetsUtil.encodeBase64 ( HashStr.getBytes ( ) ) ;
                    Strb64_enc = new String ( b64_enc ) ;
                    Logger.debug.println ( "SELLER_CONTRACT_INFO=|||" + Strb64_enc + "|||");
                    Logger.debug.println ( "SELLER_CONTRACT_INFO=|||" + Strb64_enc + "|||");

                    customHeader.put("sctsg_company_type", "SELLER"       );
                    customHeader.put("sctsg_sign_content", sb.toString ( ));
                    customHeader.put("sctsg_sign_data"   , Strb64_enc     );
                    
                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_signdata_insert");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doInsert(headerData, customHeader);
                    

                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_sign_delete");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doDelete(headerData, customHeader);
                	
                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_sign_insert");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doDelete(headerData, customHeader);
                }
                
                headerData.put ( "ct_flag" , "CC" );
            	sxp = new SepoaXmlParser(this, "setCTInsert_contract_update_seller_sign");
            	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            	ssm.doUpdate(headerData, customHeader);
                setMessage (  MapUtils.getString ( headerData , "cont_number" , "" ) + msg.get("CT_006.0010"));//번의 계약서를 인증을 완료하였습니다.
            }
            // 업체인증   -------------------------------------------------------------------------------------------------------------------끝
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ     
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ     
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            //-------------------------------------------------------------------------------------------------------------------------------ㅇ
            // 한화인증   -------------------------------------------------------------------------------------------------------------------시작
            else if("BA".equals ( MapUtils.getString ( headerData , "doc_type" , "IU" ) )){

    			sxp = new SepoaXmlParser(this, "setCTInsert_getContract_signData");
    			customHeader.put("house_code", info.getSession("HOUSE_CODE"));
            	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                signHashSf = new SepoaFormater ( ssm.doSelect(headerData, customHeader) );
                
                sb.delete(0, sb.length());
                sa = getContractDeaitl ( headerData ) ;
                sf = new SepoaFormater ( sa.result [ 0 ] ) ; // 계약쿼리실행
                if ( sf.getRowCount ( ) > 0 ) {
                    sb.append ( getContContent ( sf ) ) ; // 계약데이타 가져옴
                    Logger.debug.println ( "BUYER_CONTRACT_INFO=|||" + sb.toString ( ) + "|||");
                } else {
                    new Exception ( msg.get ( "CT_006.0009" ).toString() ) ;//계약서 정보가 존재하지 않습니다.
                }

                boolean signFlag = true;
                if ( !"true".equals ( getConfig ( "sepoa.server.development.flag" ) ) ) {

                    conf = new Configuration();
                    tradesign_path = conf.get("sepoa.tradesign.path"); 
                    JeTS.installProvider(tradesign_path) ;
                    JeTS.reInstallProvider ( tradesign_path ) ;
                    
                    
                    sd = new SignedData ( sb.toString ( ).getBytes ( ) , true ) ;
                    // 서명 암호화
                    sd.setsignCert ( JeTS.getServerSignCert ( 0 ) , JeTS.getServerSignPriKey ( 0 ) , JeTS.getServerSignKeyPassword ( 0 ) ) ;
                    byte [ ] signed_msg = sd.sign ( ) ;
                    certs = sd.verify ( ) ;
                    CertDn = new String [ certs.length ] ;
                    for ( int j = 0 ; j < certs.length ; j ++ ) {
                        CertDn [ j ] = certs [ j ].getSubjectDNStr ( ) ;
                    }

                    data = sb.toString();
                    md = MessageDigest.getInstance ( "HAS160" , "JeTS" ) ;
                    result = md.digest ( sb.toString ( ).getBytes ( ) ) ;
                    HashStr = new String ( JetsUtil.encodeBase64 ( result ) ) ;
                    b64_enc = JetsUtil.encodeBase64 ( HashStr.getBytes ( ) ) ;
                    // Base64 인코딩 데이타
                    Strb64_enc = new String ( b64_enc ) ;
                    Logger.debug.println ( "BUYER_CONTRACT_INFO=|||" + Strb64_enc + "|||");
                    Logger.debug.println ( "BUYER_CONTRACT_INFO=|||" + Strb64_enc + "|||");

                    customHeader.put("sctsg_company_type", "BUYER"       );
                    customHeader.put("sctsg_sign_content", sb.toString ( ));
                    customHeader.put("sctsg_sign_data"   , Strb64_enc     );
                    
                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_signdata_insert");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doInsert(headerData, customHeader);
                    
                    if(signHashSf.getRowCount ( ) > 0){
                        if(!signHashSf.getValue ( "SIGN_HASH" , 0 ).equals ( Strb64_enc )){
                            signFlag = false; 
                        }
                    }else{
                        //throw new Exception( "업체 Sign정보가 존재하지 않습니다." );
                    }
                }
                if(signFlag){
                    headerData.put ( "ct_flag" , "CD" );
                	sxp = new SepoaXmlParser(this, "setCTInsert_contract_update_buyer_sign");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doUpdate(headerData, customHeader);
                    setMessage (  MapUtils.getString ( headerData , "cont_number" , "" ) + msg.get ( "CT_006.0011" ));//번의 계약서를 인증하였습니다.
                }else{
                    setMessage (  MapUtils.getString ( headerData , "cont_number" , "" ) + msg.get("CT_006.0012"));//번의 계약서가 업체에서 인증했을 때와 \n내용이 달라 인증하는데 실패하였습니다.
                }
            }
            try{
                if(getSepoaOut ( ).result != null && sa != null){
                    sa.result[0] = "";
                }   
            }catch(Exception e){
            	Logger.err.println(info.getSession("ID"), this, e.getMessage());
            }
            setValue ( msg.get("CT_006.TEXT_0001_S").toString() );//완료
            // 한화인증   -------------------------------------------------------------------------------------------------------------------끝
            Commit();
        } catch (Exception e) {
            try {
                Rollback();
            } catch (SepoaServiceException e1) {
            	Logger.err.println(info.getSession("ID"), this, e1.getMessage());
            }
            
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            setValue ( msg.get("CT_006.TEXT_0002_S").toString() );//실패
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
	}
    private StringBuffer getContContent(SepoaFormater sf) throws Exception{
        StringBuffer sb = new StringBuffer ( );
        sb.delete(0, sb.length());
        sb.append( sf.getValue("COMPANY_CODE             ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_NUMBER              ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_GL_SEQ              ".trim() , 0) + "#");
        sb.append( sf.getValue("PO_NUMBER                ".trim() , 0) + "#");
        sb.append( sf.getValue("PO_COUNT                 ".trim() , 0) + "#");
        sb.append( sf.getValue("PROJECT_NAME             ".trim() , 0) + "#");
        sb.append( sf.getValue("SUBJECT                  ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_TYPE                ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_DATE                ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_ADD_DATE            ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_AMT                 ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_FROM                ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_TO                  ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_CODE              ".trim() , 0) + "#");
        sb.append( sf.getValue("RD_DATE                  ".trim() , 0) + "#");
        sb.append( sf.getValue("PAY_TERMS_TEXT           ".trim() , 0) + "#");
        sb.append( sf.getValue("REMARK                   ".trim() , 0) + "#");
        sb.append( sf.getValue("FIRST_AMT_RATIO          ".trim() , 0) + "#");
        sb.append( sf.getValue("THIRD_AMT_RATIO          ".trim() , 0) + "#");
        sb.append( sf.getValue("SECOND_AMT_RATIO_01      ".trim() , 0) + "#");
        sb.append( sf.getValue("FIRST_AMT_TIME           ".trim() , 0) + "#");
        sb.append( sf.getValue("THIRD_AMT_TIME           ".trim() , 0) + "#");
        sb.append( sf.getValue("SECOND_AMT_TIME_01       ".trim() , 0) + "#");
        sb.append( sf.getValue("PRE_INS_PERCENT          ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_INS_PERCENT         ".trim() , 0) + "#");
        sb.append( sf.getValue("FAULT_INS_PERCENT        ".trim() , 0) + "#");
        sb.append( sf.getValue("FAULT_INS_FROM           ".trim() , 0) + "#");
        sb.append( sf.getValue("ATTACH_NO                ".trim() , 0) + "#");
        sb.append( sf.getValue("ATTACH_NO1               ".trim() , 0) + "#");
        sb.append( sf.getValue("ATTACH_NO2               ".trim() , 0) + "#");
        sb.append( sf.getValue("ATTACH_NO3               ".trim() , 0) + "#");
        sb.append( sf.getValue("ATTACH_NO4               ".trim() , 0) + "#");
        sb.append( sf.getValue("BUYER_COMPANY_IRS_NO     ".trim() , 0) + "#");
        sb.append( sf.getValue("BUYER_COMPANY_NAME       ".trim() , 0) + "#");
        sb.append( sf.getValue("BUYER_COMPANY_ADDR       ".trim() , 0) + "#");
        sb.append( sf.getValue("BUYER_COMPANY_CEO_NAME   ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_COMPANY_IRS_NO    ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_COMPANY_NAME      ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_COMPANY_ADDR      ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_COMPANY_CEO_NAME  ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_AMT_TEXT            ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_TTL_AMT_TEXT        ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_TTL_AMT             ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_VAT_TEXT            ".trim() , 0) + "#");
        sb.append( sf.getValue("CONT_VAT                 ".trim() , 0) + "#");
        sb.append( sf.getValue("BUYER_COMPANY_ZIP_CODE1  ".trim() , 0) + "#");
        sb.append( sf.getValue("BUYER_COMPANY_ZIP_CODE2  ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_COMPANY_ZIP_CODE1 ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_COMPANY_ZIP_CODE2 ".trim() , 0) + "#");
        sb.append( sf.getValue("BUYER_COMPANY_ADDR2      ".trim() , 0) + "#");
        sb.append( sf.getValue("SELLER_COMPANY_ADDR2     ".trim() , 0) + "#");
        sb.append( sf.getValue("LOCATION                 ".trim() , 0) + "#");
        sb.append( sf.getValue("PAY_TERMS_DATE           ".trim() , 0) + "#");
        sb.append( sf.getValue("PAY_TERMS_SPEC_FLAG      ".trim() , 0) + "#");
        sb.append( sf.getValue("PERIOD_CHECK             ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_PRICE              ".trim() , 0) + "#");
        sb.append( sf.getValue("PRE_INS_PERCENT_TEXT     ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_DATE1              ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_PRICE1             ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_REMARK1            ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_DATE2              ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_PRICE2             ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_REMARK2            ".trim() , 0) + "#");
        sb.append( sf.getValue("DELAY_REMARK3            ".trim() , 0) + "#");
        sb.append( sf.getValue("CONFIRM_METHOD           ".trim() , 0) + "#");
        sb.append( sf.getValue("MUTUAL_DISTRICT          ".trim() , 0) + "#");
        sb.append( sf.getValue("PAY_TERMS_SPEC           ".trim() , 0) + "#");
        sb.append( sf.getValue("CONTRACT_EFFECT          ".trim() , 0) + "#");
        sb.append( sf.getValue("UNIT_MEASURE1            ".trim() , 0) + "#");
        sb.append( sf.getValue("ITEM_QTY1                ".trim() , 0) + "#");
        sb.append( sf.getValue("UNIT_PRICE1              ".trim() , 0) + "#");
        sb.append( sf.getValue("ITEM_AMT1                ".trim() , 0) + "#");
        sb.append( sf.getValue("DESCRIPTION2             ".trim() , 0) + "#");
        sb.append( sf.getValue("UNIT_MEASURE2            ".trim() , 0) + "#");
        sb.append( sf.getValue("ITEM_QTY2 UNIT_PRICE2    ".trim() , 0) + "#");
        sb.append( sf.getValue("ITEM_AMT2                ".trim() , 0) + "#");
        sb.append( sf.getValue("DESCRIPTION3             ".trim() , 0) + "#");
        sb.append( sf.getValue("PAY_TERMS_PERCENT        ".trim() , 0) + "#");
        AD_3123 fileHashProcess = new AD_3123 ( "NONDBJOB" , info ) ;
        fileHashProcess.setConnectionContext ( getConnectionContext ( ) ) ;
        SepoaOut file_value = fileHashProcess.fileCRC ( sf.getValue("CONT_NUMBER" , 0) , sf.getValue("CONT_GL_SEQ" , 0) , info ) ;
        String file_msg = "" ;
        if ( file_value.flag ) {
            file_msg = file_value.result [ 0 ] ;
            sb.append ( file_msg + "#" ) ;
        } else {
            file_msg = file_value.message ;
        }
        return sb;
    }
    /**
	 * 계약팝업 상세 조회
	 * @param header
	 * @return
	 */
    public SepoaOut getContractDeaitl(Map< String, String > header){
        
        ConnectionContext ctx           = getConnectionContext();
        SepoaFormater     sf            = null;
        StringBuffer      sb            = new StringBuffer();
        ParamSql          sm            = new ParamSql(info.getSession("ID"), this, ctx);
        String            language      = info.getSession("LANGUAGE");
        String            COMPANY_CODE  = info.getSession("COMPANY_CODE");
        String            IS_ADMIN_FLAG = info.getSession("IS_ADMIN_FLAG");

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
        try {
            setStatus(1);
            setFlag(true);
            String own_ctrl_code = info.getSession("OWN_CTRL_CODE_LIST");
            String is_admin_user = info.getSession("IS_ADMIN_USER");
            String ctrl_code     = CommonUtil.getCtrlCode(is_admin_user, own_ctrl_code,MapUtils.getString( header, "ctrl_code", "" ));

            if("".equals ( MapUtils.getString ( header , "cont_number" , "" ) ) || "BCC".equals ( MapUtils.getString ( header , "doc_type" , "" ) )){ // 계약번호가 없으면 P/O및 결의 테이블에 데이타를 가지고온다.
                if("BCC".equals ( MapUtils.getString ( header , "doc_type" , "" ) )){
                	customHeader.put("cont_gl_seq",  String.valueOf ( Integer.parseInt ( MapUtils.getString ( header , "cont_gl_seq"  , "1" ) ) - 1 )  );
                	sxp = new SepoaXmlParser(this, "getContractDeaitl_contract_count");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	sf = new SepoaFormater(ssm.doSelect(header, customHeader)) ;
                    header.put ( "po_number" , sf.getValue ( "PO_NUMBER" , 0 ) );
                    header.put ( "po_count" , sf.getValue ( "PO_COUNT" , 0 ) );
                }
                // 계약서종류
                // 1 / 공사계약서 ZPR4
                // 2 / 물품공급계약서 ZPR1
                // 3 / 용역도급계약서 ZPR2
                // 4 / 유지보수계약서 ZPR3
                // 5 / 단가계약서(일반/용역)
                // 6 / 물품공급계약서(단가계약)
                // 7 / 기타계약서
                if("".equals( MapUtils.getString ( header , "exec_no"    , ""  ) )){
                	sxp = new SepoaXmlParser(this, "getContractDeaitl_contract_getExecNumber");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	sf = new SepoaFormater(ssm.doSelect(header, customHeader)) ;
                	header.put("exec_no", sf.getValue(0, 0));
                }
                customHeader.put("zero","영원");
            	sxp = new SepoaXmlParser(this, "getContractDeaitl_waitDetail");
            	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                setValue(ssm.doSelect(header, customHeader));
            }else{ //계약번호가 있으면 계약 테이블에 데이타를 가지고온다.
            	customHeader.put("seller_sign", "업체서명완료");
            	customHeader.put("buyer_sign", "구매사서명완료");
            	sxp = new SepoaXmlParser(this, "getContractDeaitl");
            	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                setValue(ssm.doSelect(header, customHeader));
            }
            sepoa.fw.log.Log4Table2AccDate.UpdateSCODE_ACCDATE( ctx, "M421_1" );
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
    
    @ SuppressWarnings ( "unchecked" )
    /**
     * 보증보험 MAIN 메소드 (분기처리용) 
     * 벨리데이션 체크
     */
    public SepoaOut setContractBond(  Map< String, Object > allData  ) throws Exception {

        ConnectionContext ctx              = getConnectionContext();
        StringBuffer      sb               = new StringBuffer();
        ParamSql          sm               = new ParamSql(info.getSession("ID"), this, ctx);

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
        try {

            setStatus(1);
            setFlag(true);
            Map<String, String>       headerData = MapUtils.getMap(allData, "headerData");
            
            String cont_date        = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "cont_date        ".trim() ) );
            String cont_from_change = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "cont_from_change ".trim() ) );
            String cont_from        = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "cont_from        ".trim() ) );
            String rd_date          = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "rd_date          ".trim() ) );
            String pre_ins_date     = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "pre_ins_date     ".trim() ) );
            String cont_ins_from    = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "cont_ins_from    ".trim() ) );
            String cont_ins_to      = SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "cont_ins_to      ".trim() ) );
            
            headerData.put( "cont_date        ".trim(), cont_date        );
            headerData.put( "cont_from_change ".trim(), cont_from_change );
            headerData.put( "cont_from        ".trim(), cont_from        );
            headerData.put( "rd_date          ".trim(), rd_date          );
            headerData.put( "pre_ins_date     ".trim(), pre_ins_date     );
            headerData.put( "cont_ins_from    ".trim(), cont_ins_from    );
            headerData.put( "cont_ins_to      ".trim(), cont_ins_to      );

        	sxp = new SepoaXmlParser(this, "setContractBond_detailInfo");
        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
			Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
            bondSf = new SepoaFormater (ssm.doSelect(headerData, customHeader));
            
            /**
             *  Validation 체크 부분 ( 전송 및 최종응답서 송신여부                                     
             *  작업여부 ( 전송(SENDXML) / 최종응답서(FINALXML) / 보증증권 수신(RECVXML)                
             *  계약 - CONINF, 선급 - PREINF, 하자 - FLRINF                                  
             *  상태 - SEND 전송                                                           
             *  상태 - DD   취소                                                           
             *  상태 - AP   접수                                                           
             *  상태 - RE   거부                                                           
             *  상태 - DE   폐기                                                           
             *  상태 - G    보증증권 수신완료.                                                           
             */
            
            headerData.put ( "pre_ins_flag"   , bondSf.getValue ( "PRE_INS_FLAG"   , 0 ) );
            headerData.put ( "cont_ins_flag"  , bondSf.getValue ( "CONT_INS_FLAG"  , 0 ) );
            headerData.put ( "fault_ins_flag" , bondSf.getValue ( "FAULT_INS_FLAG" , 0 ) );
            
            if ( "SENDXML".equals ( MapUtils.getString ( headerData , "bondJobFalg" ) ) ) { // 전송
                if ( "PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) { // -------------------------------------------------------------------- 선급
                    if ( "SE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) { // ------------------------- 전송
                        throw new Exception ( "선급증권은 이미 전송하셨습니다." ) ;
                    } else if ( "AP".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) { // ------------------- 접수
                        throw new Exception ( "선급증권은 접수가 완료되었습니다." ) ;
                    } else if ( "RE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) { // ------------------- 거부
                        throw new Exception ( "선급증권은 거부상태입니다. 재발급 요청을 하시거나 지점에 전화하여 구두로 취소 후 시스템에서 다시 취소를 해주신 후 전송하시기 바랍니다." ) ;
                    } else if ( "G" .equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) { // ------------------- 증권수신
                        throw new Exception ( "선급증권을 받은 상태라 전송하실 수 없습니다." ) ;
                    } else { // ------------------ 취소 / 폐기 / 상태값이 없을때
                        // 선급증권 전송가능상태
                    }
                } else if ( "CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) { // ------------------------------------------------------------ 계약이행
                    if ( "SE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) { // ------------------------- 전송
                        throw new Exception ( "계약이행증권은 이미 전송하셨습니다." ) ;
                    } else if ( "AP".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) { // ------------------- 접수
                        throw new Exception ( "계약이행증권은 접수가 완료되었습니다." ) ;
                    } else if ( "RE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) { // ------------------- 거부
                        throw new Exception ( "계약이행증권은 거부상태입니다. 재발급 요청을 하시거나 지점에 전화하여 구두로 취소 후 시스템에서 다시 취소를 해주신 후 전송하시기 바랍니다." ) ;
                    } else if ( "G" .equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) { // ------------------- 증권수신
                        throw new Exception ( "계약이행증권을 받은 상태라 전송하실 수 없습니다." ) ;
                    } else { // ------------------ 취소 / 폐기 / 상태값이 없을때
                        // 계약이행증권 전송가능상태
                    }
                } else if ( "FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) { // ------------------------------------------------------------ 하자이행
                    if ( "SE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) { // ------------------------- 전송
                        throw new Exception ( "하자이행증권은 이미 전송하셨습니다." ) ;
                    } else if ( "AP".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) { // ------------------- 접수
                        throw new Exception ( "하자이행증권은 접수가 완료되었습니다." ) ;
                    } else if ( "RE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) { // ------------------- 거부
                        throw new Exception ( "하자이행증권은 거부상태입니다. 재발급 요청을 하시거나 지점에 전화하여 구두로 취소 후 시스템에서 다시 취소를 해주신 후 전송하시기 바랍니다." ) ;
                    } else if ( "G" .equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) { // ------------------- 증권수신
                        throw new Exception ( "하자이행증권을 받은 상태라 전송하실 수 없습니다." ) ;
                    } else { // ------------------ 취소 / 폐기 / 상태값이 없을때
                        // 하자이행증권 전송가능상태
                    }
                }
            }
            if ( "FINALXML".equals ( MapUtils.getString ( headerData , "bondJobFalg" ) ) ) { // 최종응답서
                if ( "PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) { // ------------------------------------------------------------------------------------ 선급
                    if ( "DD".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // -------------------------- 실행하는 명령 ( 취소 )
                        if ( "DD".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -------------------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "선급증권은 이미 취소처리가 완료되었습니다." ) ;
                        } else if ( "AP".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 접수 )
                            throw new Exception ( "선급증권이 발행되어있습니다. 반려 후 지점에 전화하여 구두로 취소후 시스템에서 다시 취소해주세요." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "선급증권은 폐기처리 되어 취소가 불가능합니다." ) ;
                        } else if ( "G" .equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 증권수신 )
                            throw new Exception ( "선급증권은 수신이 완료되어 취소가 불가능합니다." ) ;
                        }
                    } else if ( "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 접수 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "선급증권을 아직 수신하지 못한 상태라 접수가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "선급증권은 취소상태라 접수를 하지 못합니다." ) ;
                        } else if ( "AP".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 접수 )
                            throw new Exception ( "선급증권은 이미 접수처리 완료하였습니다." ) ;
                        } else if ( "RE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 반려 )
                            throw new Exception ( "선급증권은 반려되어 접수처리 할 수 없습니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "선급증권은 폐기되어 접수처리 할 수 없습니다." ) ;
                        }
                    } else if ( "RE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 거부 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "선급증권을 아직 수신하지 못한 상태라 거부가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "선급증권은 취소상태라 거부를 하지 못합니다." ) ;
                        } else if ( "RE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 반려 )
                            throw new Exception ( "선급증권은 이미 거부한 상태입니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "선급증권은 폐기되어 거부처리 할 수 없습니다." ) ;
                        }
                    } else if ( "DE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 폐기 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "선급증권을 아직 수신하지 못한 상태라 폐기가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "선급증권은 취소상태라 폐기 할 수 없습니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "pre_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "선급증권은 이미 폐기처리 되었습니다." ) ;
                        }
                    }
                } else if ( "CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) {// ------------------------------------------------------------------------------------ 계약이행
                    if ( "DD".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // -------------------------- 실행하는 명령 ( 취소 )
                        if ( "DD".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -------------------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "계약이행증권은 이미 취소처리가 완료되었습니다." ) ;
                        } else if ( "AP".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 접수 )
                            throw new Exception ( "계약이행증권이 발행되어있습니다. 반려 후 지점에 전화하여 구두로 취소후 시스템에서 다시 취소해주세요." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "계약이행증권은 폐기처리 되어 취소가 불가능합니다." ) ;
                        } else if ( "G" .equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 증권수신 )
                            throw new Exception ( "계약이행증권은 수신이 완료되어 취소가 불가능합니다." ) ;
                        }
                    } else if ( "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 접수 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "계약이행증권을 아직 수신하지 못한 상태라 접수가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "계약이행증권은 취소상태라 접수를 하지 못합니다." ) ;
                        } else if ( "AP".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 접수 )
                            throw new Exception ( "계약이행증권은 이미 접수처리 완료하였습니다." ) ;
                        } else if ( "RE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 반려 )
                            throw new Exception ( "계약이행증권은 반려되어 접수처리 할 수 없습니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "계약이행증권은 폐기되어 접수처리 할 수 없습니다." ) ;
                        }
                    } else if ( "RE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 거부 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "계약이행증권을 아직 수신하지 못한 상태라 거부가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "계약이행증권은 취소상태라 거부를 하지 못합니다." ) ;
                        } else if ( "RE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 반려 )
                            throw new Exception ( "계약이행증권은 이미 거부한 상태입니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "계약이행증권은 폐기되어 거부처리 할 수 없습니다." ) ;
                        }
                    } else if ( "DE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 폐기 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "계약이행증권을 아직 수신하지 못한 상태라 폐기가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "계약이행증권은 취소상태라 폐기 할 수 없습니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "cont_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "계약이행증권은 이미 폐기처리 되었습니다." ) ;
                        }
                    }
                } else if ( "FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) {// ------------------------------------------------------------------------------------ 하자이행
                    if ( "DD".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // -------------------------- 실행하는 명령 ( 취소 )
                        if ( "DD".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -------------------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "하자이행증권은 이미 취소처리가 완료되었습니다." ) ;
                        } else if ( "AP".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 접수 )
                            throw new Exception ( "하자이행증권이 발행되어있습니다. 반려 후 지점에 전화하여 구두로 취소후 시스템에서 다시 취소해주세요." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "하자이행증권은 폐기처리 되어 취소가 불가능합니다." ) ;
                        } else if ( "G" .equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 증권수신 )
                            throw new Exception ( "하자이행증권은 수신이 완료되어 취소가 불가능합니다." ) ;
                        }
                    } else if ( "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 접수 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "하자이행증권을 아직 수신하지 못한 상태라 접수가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "하자이행증권은 취소상태라 접수를 하지 못합니다." ) ;
                        } else if ( "AP".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 접수 )
                            throw new Exception ( "하자이행증권은 이미 접수처리 완료하였습니다." ) ;
                        } else if ( "RE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 반려 )
                            throw new Exception ( "하자이행증권은 반려되어 접수처리 할 수 없습니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "하자이행증권은 폐기되어 접수처리 할 수 없습니다." ) ;
                        }
                    } else if ( "RE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 거부 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "하자이행증권을 아직 수신하지 못한 상태라 거부가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "하자이행증권은 취소상태라 거부를 하지 못합니다." ) ;
                        } else if ( "RE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 반려 )
                            throw new Exception ( "하자이행증권은 이미 거부한 상태입니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "하자이행증권은 폐기되어 거부처리 할 수 없습니다." ) ;
                        }
                    } else if ( "DE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // ------------------ 실행하는 명령 ( 폐기 )
                        if ( "SE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------------현재상태 ( 전송 )
                            throw new Exception ( "하자이행증권을 아직 수신하지 못한 상태라 폐기가 불가능합니다." ) ;
                        } else if ( "DD".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 취소 )
                            throw new Exception ( "하자이행증권은 취소상태라 폐기 할 수 없습니다." ) ;
                        } else if ( "DE".equals ( MapUtils.getString ( headerData , "fault_ins_flag" ) ) ) {// -----------------------------------------현재상태 ( 폐기 )
                            throw new Exception ( "하자이행증권은 이미 폐기처리 되었습니다." ) ;
                        }
                    }
                }
            }
            
            //작업여부 ( 전송(SENDXML) / 최종응답서(FINALXML) / 보증증권 수신(RECVXML)
            if ( "SENDXML".equals ( MapUtils.getString ( headerData , "bondJobFalg" ) ) ) { //전송
                setSgix ( allData );
            }
            if ( "FINALXML".equals ( MapUtils.getString ( headerData , "bondJobFalg" ) ) ) { //최종응답서
                setSgixSendAfter ( allData ) ;
            }
            if ( "RECVXML".equals ( MapUtils.getString ( headerData , "bondJobFalg" ) ) ) { //보증증권 수신
                setSgixRecv ( allData ) ;
            }
            
            
            Commit();
        } catch (Exception e) {
            try {
                Rollback();
            } catch (SepoaServiceException e1) {
            	Logger.err.println(info.getSession("ID"), this, e1.getMessage());
            }
            
            setStatus(0);
            setFlag(false);
            setMessage(e.getMessage());
            Logger.err.println(info.getSession("ID"), this, e.getMessage());
        }

        return getSepoaOut();
    }

    /**
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     */
    /**
     * 서울보증보험에 XML 전문 송신
     * @param allData
     * @return
     * @throws Exception
     */
    
    @ SuppressWarnings ( "unchecked" )
    private SepoaOut setSgix ( Map < String , Object > allData ) throws Exception {
        
        Map < String , String > headerData = MapUtils.getMap ( allData , "headerData" ) ;
        ConnectionContext ctx = getConnectionContext ( ) ;
        ParamSql sm = new ParamSql ( info.getSession ( "ID" ) , this , ctx ) ;
        StringBuffer sb = new StringBuffer ( ) ;
        String sendinfo_conf = getConfig ( "sepoa.sgix.sendinfo.conf" ) ; /* 송신 시 사용하는 환경설정파일 */
        String templates_path = getConfig ( "sepoa.sgix.templates.path" ) ; /* 각 전문에 임시 템플릿 xml, 전문 MAP 파일 위치 경로 */

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
        try {
            /** XML 데이타 생성 시작 */
            DataToXml dataToXml = new DataToXml ( templates_path ,  MapUtils.getString ( headerData , "docTypeCode" ) ) ;
            HashMap < String , String > xmlHash = new HashMap < String , String > ( ) ;
            
            if ( dataToXml.getErrorCode ( ) != 0 ) {
                
                Logger.sys.println ( dataToXml.getErrorMsg ( ) ) ;
                return null ;
            }
            /**
             * 공통으로 쓰일 필드들 모음
             */
            String SYSDATE = SepoaDate.getShortDateString ( );
            String SYSTIME = SepoaDate.getShortTimeString ( );
            String INFTYPE = "";
            String INFTEXT = "";

            if("CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ))){ //계약
                INFTYPE = "002";
                INFTEXT = "계약정보통보서";
            }else if("PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ))){ //선급
                INFTYPE = "004";
                INFTEXT = "선금정보통보서";
            }else if("FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ))){ //하자
                INFTYPE = "003";
                INFTEXT = "하자정보통보서";
            }
            
            /** 
             * 모든 순서는 계약 >> 선급 >> 하자 순 세가지 나올때
             * 
             * XML 헤더
             * ---------------------------------------------------------------------문서코드
             * 계약 - CONINF, 선급 - PREINF, 하자 - FLRINF
             * ---------------------------------------------------------------------문서명
             * 계약 - 계약정보통보서, 선급 - 선금정보통보서, 하자 - 하자정보통보서
             * ---------------------------------------------------------------------상품구분코드
             * 계약 - 002, 선급 - 004, 하자 - 003
             * */
            String head_mesg_send = getConfig ( "sepoa.head_mesg_send" ) ;
            String head_mesg_recv = getConfig ( "sepoa.head_mesg_recv" ) ;
            String head_func_code = getConfig ( "sepoa.head_func_code" ) ;
            String head_mesg_type = MapUtils.getString ( headerData , "docTypeCode" ) ;
            String head_mesg_name = INFTEXT ;
            String head_mesg_vers = "1.0" ;
            String head_docu_numb = "004" + INFTYPE + bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 ) + " 00" ;
            String head_mang_numb = head_mesg_send + "." + SYSDATE + SYSTIME + ".12345.004" + INFTYPE + bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 ) + " 00" ;
            String head_refr_numb = "004" + INFTYPE + bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 ) + " 00" ;
            String head_titl_name = INFTEXT ;
            String head_orga_code = getConfig ( "sepoa.head_orga_code" ) ; 
            
            xmlHash.put ( "head_mesg_send" ,  head_mesg_send );  //[필수][필수][필수]송신자ID     : A+피보험자사업자번호+00 (총 13자리) 예) A104811234500
            xmlHash.put ( "head_mesg_recv" ,  head_mesg_recv );  //[필수][필수][필수]수신자ID     : z120811300200 (서울보증보험 ID로 총 13자리 고정값)
            xmlHash.put ( "head_func_code" ,  head_func_code );  //[필수][필수][필수]문서기능코드 : 9:원본,1:취소,53:테스트
            xmlHash.put ( "head_mesg_type" ,  head_mesg_type );  //[필수][필수][필수]문서코드     : 문서코드 상단정보참조 고정
            xmlHash.put ( "head_mesg_name" ,  head_mesg_name );  //[필수][필수][필수]문서명       : 문서명 상단정보참조 고정
            xmlHash.put ( "head_mesg_vers" ,  head_mesg_vers );  //[    ][    ][    ]문서버젼     : 1.0
            xmlHash.put ( "head_docu_numb" ,  head_docu_numb );  //[필수][필수][필수]문서번호     : 004+상품구분코드(3)피보험자 측 계약번호(차수 포함)+' '+차수(2)  예) 004002T2008100100 00
            xmlHash.put ( "head_mang_numb" ,  head_mang_numb );  //[필수][필수][필수]문서관리번호 : 송신기관코드(13)+'.'+SYSDATE(8)+SYSTIME(6)+'.12345.'+004+상품구분코드(3)+피보험자 측 계약번호(차수 포함) +' '+차수(2) 예) A120811300200.20080812105619.12345.004002T2008100100 00
            xmlHash.put ( "head_refr_numb" ,  head_refr_numb );  //[필수][필수][필수]참조번호     : 004+상품구분코드(3)+피보험자 측 계약번호(차수 포함)+' '+차수(2)  예) 004002T2008100100 00
            xmlHash.put ( "head_titl_name" ,  head_titl_name );  //[필수][필수][필수]문서명과 동일: "계약정보통보서,선금정보통보서" 로 고정
            xmlHash.put ( "head_orga_code" ,  head_orga_code );  //[필수][필수][필수]연계기관코드 : 피보험자 연계기관 코드 (서울보증보험에서 정의) 예)TGC
            
            if ( ! ( dataToXml.setData ( "head_mesg_send" , MapUtils.getString ( xmlHash , "head_mesg_send" ) )
            && dataToXml.setData ( "head_mesg_recv" , MapUtils.getString ( xmlHash , "head_mesg_recv" ) )
            && dataToXml.setData ( "head_func_code" , MapUtils.getString ( xmlHash , "head_func_code" ) )
            && dataToXml.setData ( "head_mesg_type" , MapUtils.getString ( xmlHash , "head_mesg_type" ) )
            && dataToXml.setData ( "head_mesg_name" , MapUtils.getString ( xmlHash , "head_mesg_name" ) )
            && dataToXml.setData ( "head_mesg_vers" , MapUtils.getString ( xmlHash , "head_mesg_vers" ) )
            && dataToXml.setData ( "head_docu_numb" , MapUtils.getString ( xmlHash , "head_docu_numb" ) )
            && dataToXml.setData ( "head_mang_numb" , MapUtils.getString ( xmlHash , "head_mang_numb" ) )
            && dataToXml.setData ( "head_refr_numb" , MapUtils.getString ( xmlHash , "head_refr_numb" ) )
            && dataToXml.setData ( "head_titl_name" , MapUtils.getString ( xmlHash , "head_titl_name" ) )
            && dataToXml.setData ( "head_orga_code" , MapUtils.getString ( xmlHash , "head_orga_code" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 헤더정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
                
            
            /** 
             * 보험계약정보
             * --------------------------------------------------------------------------------------------------------보험시작일자
             * 계약 - 계약체결일 정보가 있고 계약체결일자가 계약시작일자보다 먼저이면 계약체결일자가 보험 시작일자 임
             * 선급 - 공란 또는 계약시작일자 , 공란일 경우 보험가입신청일자를 보험시작일자로 세팅함
             * 하자 - 하자보수 책임 시작일과 동일 (종료일은 하자보수 책임종료일과 동일)
             * --------------------------------------------------------------------------------------------------------보험가입금액
             * 계약 - 계약금액 * 계약보증금율, 선급 - 선금지급(예정) 금액, 하자 - 계약금액 * 하자보증금율 
             * */
            String bond_kind_code = INFTYPE ;
            String bond_begn_date = bondSf.getValue ( "CONT_FROM " , 0 ) ;
            String bond_fnsh_date = bondSf.getValue ( "CONT_TO "   , 0 ) ;
            String bond_curc_code = "WON" ;
            String bond_penl_amnt = returnParseLong ( bondSf.getValue ( "CONT_AMT"   , 0 ) ) ;
            String bond_oper_code = "" ;
            String bond_appl_code = "10" ;
            
            xmlHash.put ( "bond_kind_code" ,  bond_kind_code );  //[필수][필수][필수]보험종목(상품)구분            : 001:입찰, 002:계약, 003:하자, 004:선금, 006:지급, 007:생활안정, 009:납세, 008:공사이행
            xmlHash.put ( "bond_begn_date" ,  bond_begn_date );  //[필수][    ][필수]보험시작일자                  : YYYYMMDD , 상단정보참조
            xmlHash.put ( "bond_fnsh_date" ,  bond_fnsh_date );  //[필수][필수][필수]보험종료일자                  : YYYYMMDD
            xmlHash.put ( "bond_curc_code" ,  bond_curc_code );  //[필수][필수][필수]보험가입금액 통화코드         : WON(원화), USD(미달러), EUR(유로화) 등
            xmlHash.put ( "bond_penl_amnt" ,  bond_penl_amnt );  //[필수][필수][필수]보험가입금액                  : 상단정보참조
            xmlHash.put ( "bond_oper_code" ,  bond_oper_code );  //[    ][    ][    ]조회 또는 등록 업무구분       : "INSERT"
            xmlHash.put ( "bond_appl_code" ,  bond_appl_code );  //[필수][필수][필수]신규 또는 변경(배서) 업무구분 : 10:신규,20:연장,60:증액,62:연장증액,70:감액,90:기타(그 외)

            if ( ! ( dataToXml.setData ( "bond_kind_code" , MapUtils.getString ( xmlHash , "bond_kind_code" ) )
            && dataToXml.setData ( "bond_begn_date" , MapUtils.getString ( xmlHash , "bond_begn_date" ) )
            && dataToXml.setData ( "bond_fnsh_date" , MapUtils.getString ( xmlHash , "bond_fnsh_date" ) )
            && dataToXml.setData ( "bond_curc_code" , MapUtils.getString ( xmlHash , "bond_curc_code" ) )
            && dataToXml.setData ( "bond_penl_amnt" , MapUtils.getString ( xmlHash , "bond_penl_amnt" ) )
            && dataToXml.setData ( "bond_oper_code" , MapUtils.getString ( xmlHash , "bond_oper_code" ) )
            && dataToXml.setData ( "bond_appl_code" , MapUtils.getString ( xmlHash , "bond_appl_code" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 보험정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
            
            /** 
             * 보험계약정보
             * 별다른 정보 없음 ^0^
             * */
            String cont_numb_text = bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 );
            String cont_name_text = bondSf.getValue ( "SUBJECT" , 0 );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "`" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "~" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "!" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "@" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "#" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "$" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "%" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "^" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "&" , "" );
                   cont_name_text = SepoaString.replaceString ( cont_name_text , "*" , "" );
            
            String cont_proc_type = "F07"; //나중에 다시 확인할것
            String cont_type_iden = "2";
            String cont_asgn_rate = "";
            String cont_news_divs = "1";
            String cont_plan_date = "";
            String cont_main_date = bondSf.getValue ( "CONT_DATE" , 0 );
            String cont_curc_code = "WON";
            String cont_main_amnt = returnParseLong ( bondSf.getValue ( "CONT_AMT"  , 0 ) );
            String forn_curc_code = "";
            String forn_main_amnt = "";
            String hist_bond_numb = "";
            
            xmlHash.put ( "cont_numb_text" ,  cont_numb_text );  //[필수][필수][필수]계약번호                 - 피보험자 측 계약번호 (계약내용에 대한 유일한 번호)
            xmlHash.put ( "cont_name_text" ,  cont_name_text );  //[필수][필수][필수]계약명                   - 특수문자 제외 예) '&', '^', ';', '@', '#', '*' 등
            xmlHash.put ( "cont_proc_type" ,  cont_proc_type );  //[필수][필수][필수]계약구분코드             - 별첨 코드sheet 의 코드
            xmlHash.put ( "cont_type_iden" ,  cont_type_iden );  //[필수][필수][필수]계약방식코드             - 1:공동, 2:단독, 3:분담
            xmlHash.put ( "cont_asgn_rate" ,  cont_asgn_rate );  //[    ][    ][    ]지분율                   
            xmlHash.put ( "cont_news_divs" ,  cont_news_divs );  //[필수][필수][필수]신규 또는 갱신 구분코드  - 1:신규계약, 2:갱신계약
            xmlHash.put ( "cont_plan_date" ,  cont_plan_date );  //[    ][    ][    ]준공예정일               - YYYYMMDD
            xmlHash.put ( "cont_main_date" ,  cont_main_date );  //[    ][    ][    ]계약체결일               - YYYYMMDD
            xmlHash.put ( "cont_curc_code" ,  cont_curc_code );  //[필수][필수][필수]원화 계약금액 통화코드   - WON
            xmlHash.put ( "cont_main_amnt" ,  cont_main_amnt );  //[필수][필수][필수]원화 계약금액 예)1500000 
            xmlHash.put ( "forn_curc_code" ,  forn_curc_code );  //[    ][    ][    ]외화 계약금액 통화 코드  - USD(미달러), EUR(유로화) 등
            xmlHash.put ( "forn_main_amnt" ,  forn_main_amnt );  //[    ][    ][    ]외화 계약금액 예)25600   
            xmlHash.put ( "hist_bond_numb" ,  hist_bond_numb );  //[    ][    ][    ]변경(배서) 대상 증권번호 - 기존에 발행되었던 신규(원) 증권번호(18자리) 예)100000200801111111 - 꼭 18자리 원증권번호이어야 함 - 기존 증권구분번호가 004003 /100000200800123456/ 00 라며 "/" 감싸져있는 부분이 원증권번호 18자리 임

            if ( ! ( dataToXml.setData ( "cont_numb_text" , MapUtils.getString ( xmlHash , "cont_numb_text" ) )
            && dataToXml.setData ( "cont_name_text" , MapUtils.getString ( xmlHash , "cont_name_text" ) )
            && dataToXml.setData ( "cont_proc_type" , MapUtils.getString ( xmlHash , "cont_proc_type" ) )
            && dataToXml.setData ( "cont_type_iden" , MapUtils.getString ( xmlHash , "cont_type_iden" ) )
            && dataToXml.setData ( "cont_asgn_rate" , MapUtils.getString ( xmlHash , "cont_asgn_rate" ) )
            && dataToXml.setData ( "cont_news_divs" , MapUtils.getString ( xmlHash , "cont_news_divs" ) )
            && dataToXml.setData ( "cont_plan_date" , MapUtils.getString ( xmlHash , "cont_plan_date" ) )
            && dataToXml.setData ( "cont_main_date" , MapUtils.getString ( xmlHash , "cont_main_date" ) )
            && dataToXml.setData ( "cont_curc_code" , MapUtils.getString ( xmlHash , "cont_curc_code" ) )
            && dataToXml.setData ( "cont_main_amnt" , MapUtils.getString ( xmlHash , "cont_main_amnt" ) )
            && dataToXml.setData ( "forn_curc_code" , MapUtils.getString ( xmlHash , "forn_curc_code" ) )
            && dataToXml.setData ( "forn_main_amnt" , MapUtils.getString ( xmlHash , "forn_main_amnt" ) )
            && dataToXml.setData ( "hist_bond_numb" , MapUtils.getString ( xmlHash , "hist_bond_numb" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중보험계약정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
            /** 
             * 계약이행정보
             * 별다른 정보 없음 ^0^
             * */
            
            if ( "CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) { // 계약
                
                String cont_begn_date = bondSf.getValue ( "CONT_FROM"        , 0 );
                String cont_fnsh_date = bondSf.getValue ( "CONT_TO"          , 0 );
                String cont_term_text = "";
                String cont_pric_rate = bondSf.getValue ( "CONT_INS_PERCENT" , 0 );
                String cont_unit_divs = "2";
                String cont_cnfm_code = "";
                String cont_cnfm_date = "";
                
                xmlHash.put ( "cont_begn_date" ,  cont_begn_date );  //[필수]계약 시작일자 - YYYYMMDD
                xmlHash.put ( "cont_fnsh_date" ,  cont_fnsh_date );  //[필수]계약 종료일자 - YYYYMMDD
                xmlHash.put ( "cont_term_text" ,  cont_term_text );  //[    ]계약기간 => 계약종료일자-계약시작일자(계약기간 총 일수)
                xmlHash.put ( "cont_pric_rate" ,  cont_pric_rate );  //[필수]계약보증금율 - 단가계약일 경우 0 으로 입력
                xmlHash.put ( "cont_unit_divs" ,  cont_unit_divs );  //[필수]단가계약여부 - 1:단가계약, 2:일반계약
                xmlHash.put ( "cont_cnfm_code" ,  cont_cnfm_code );  //[    ]무사고 확인 - Y:하자없음, N:하자있음
                xmlHash.put ( "cont_cnfm_date" ,  cont_cnfm_date );  //[    ]무사고 확인일자 - YYYYMMDD

                if ( ! ( dataToXml.setData ( "cont_begn_date" , MapUtils.getString ( xmlHash , "cont_begn_date" ) )
                && dataToXml.setData ( "cont_fnsh_date" , MapUtils.getString ( xmlHash , "cont_fnsh_date" ) )
                && dataToXml.setData ( "cont_term_text" , MapUtils.getString ( xmlHash , "cont_term_text" ) )
                && dataToXml.setData ( "cont_pric_rate" , MapUtils.getString ( xmlHash , "cont_pric_rate" ) )
                && dataToXml.setData ( "cont_unit_divs" , MapUtils.getString ( xmlHash , "cont_unit_divs" ) )
                //&& dataToXml.setData ( "cont_cnfm_code" , MapUtils.getString ( xmlHash , "cont_cnfm_code" ) )
                //&& dataToXml.setData ( "cont_cnfm_date" , MapUtils.getString ( xmlHash , "cont_cnfm_date" ) ) 
                ) )
                {
                    throw new Exception ( "XML전문 생성중 계약이행 정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
                }
            }
            /** 
             * 선급정보
             * 별다른 정보 없음 ^0^
             * */
            if ( "PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) { // 선급
                
                String prep_paym_type = "1";
                String prep_begn_date = bondSf.getValue ( "CONT_FROM"   , 0 );
                String prep_fnsh_date = bondSf.getValue ( "CONT_TO"     , 0 );
                String prep_term_text = "";
                String prep_paym_date = SepoaString.replaceString ( MapUtils.getString ( headerData , "pre_ins_date" ) , "-" , "") ;
                String prep_curc_code = "WON";
                String prep_paym_amnt = returnParseLong (bondSf.getValue ( "PRE_INS_AMT" , 0 ) ) ;
                String fpre_curc_code = "";
                String fpre_paym_amnt = "";
                String prep_pric_rate = "";
                
                xmlHash.put ( "prep_paym_type" ,  prep_paym_type );  //[필수]지급구분 - 1:직불(수요자), 2;대지급(채권자)
                xmlHash.put ( "prep_begn_date" ,  prep_begn_date );  //[필수]계약 시작일자 - YYYYMMDD
                xmlHash.put ( "prep_fnsh_date" ,  prep_fnsh_date );  //[필수]계약 종료일자 - YYYYMMDD
                xmlHash.put ( "prep_term_text" ,  prep_term_text );  //[    ]계약기간(일수) = 계약종료일자-계약시작일자(계약기간 총 일수)
                xmlHash.put ( "prep_paym_date" ,  prep_paym_date );  //[필수]선금지급(예정)일자 - YYYYMMDD
                xmlHash.put ( "prep_curc_code" ,  prep_curc_code );  //[필수]선금지급(예정)금액(원화) 통화코드 - WON(원화)
                xmlHash.put ( "prep_paym_amnt" ,  prep_paym_amnt );  //[필수]선금지급(예정)금액(원화) - 예)1500000
                xmlHash.put ( "fpre_curc_code" ,  fpre_curc_code );  //[    ]선금지급(예정)금액(외화) 통화코드 - USD(미달러), EUR(유로화) 등
                xmlHash.put ( "fpre_paym_amnt" ,  fpre_paym_amnt );  //[    ]선금지급(예정)금액(외화) - 예)260.55
                xmlHash.put ( "prep_pric_rate" ,  prep_pric_rate );  //[    ]선금율

                if ( ! ( dataToXml.setData ( "prep_paym_type" , MapUtils.getString ( xmlHash , "prep_paym_type" ) )
                && dataToXml.setData ( "prep_begn_date" , MapUtils.getString ( xmlHash , "prep_begn_date" ) )
                && dataToXml.setData ( "prep_fnsh_date" , MapUtils.getString ( xmlHash , "prep_fnsh_date" ) )
                && dataToXml.setData ( "prep_term_text" , MapUtils.getString ( xmlHash , "prep_term_text" ) )
                && dataToXml.setData ( "prep_paym_date" , MapUtils.getString ( xmlHash , "prep_paym_date" ) )
                && dataToXml.setData ( "prep_curc_code" , MapUtils.getString ( xmlHash , "prep_curc_code" ) )
                && dataToXml.setData ( "prep_paym_amnt" , MapUtils.getString ( xmlHash , "prep_paym_amnt" ) )
                && dataToXml.setData ( "fpre_curc_code" , MapUtils.getString ( xmlHash , "fpre_curc_code" ) )
                && dataToXml.setData ( "fpre_paym_amnt" , MapUtils.getString ( xmlHash , "fpre_paym_amnt" ) )
                && dataToXml.setData ( "prep_pric_rate" , MapUtils.getString ( xmlHash , "prep_pric_rate" ) ) ) )
                {
                    throw new Exception ( "XML전문 생성중 선급정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
                }
            }
            /** 
             * 하자정보
             * 별다른 정보 없음 ^0^
             * */
            if ( "FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) ) { // 하자
                
                String morg_begn_date = bondSf.getValue ( "FAULT_INS_FROM"    , 0 );
                String morg_fnsh_date = bondSf.getValue ( "FAULT_INS_TO"      , 0 );
                String morg_term_text = bondSf.getValue ( "FAULT_DATE_PERIOD" , 0 );
                String morg_pric_rate = bondSf.getValue ( "FAULT_INS_PERCENT" , 0 );
                String morg_cnfm_code = "";
                String morg_cnfm_date = "";
                
                xmlHash.put ( "morg_begn_date" ,  morg_begn_date );  //[필수]하자보수 책임시작일 - YYYYMMDD
                xmlHash.put ( "morg_fnsh_date" ,  morg_fnsh_date );  //[필수]하자보수 책임종료일 - YYYYMMDD
                xmlHash.put ( "morg_term_text" ,  morg_term_text );  //[필수]하자보수 책임기간 = 하자보수책임 종료일자-하자보수책임 시작일자(하자보수책임 총 일수) 
                xmlHash.put ( "morg_pric_rate" ,  morg_pric_rate );  //[필수]하자보증금율
                xmlHash.put ( "morg_cnfm_code" ,  morg_cnfm_code );  //[    ]무사고 확인 - Y:하자없음, N:하자있음 (하자보수 책임시작일로 부터 30일이상 경과시 필수항목)
                xmlHash.put ( "morg_cnfm_date" ,  morg_cnfm_date );  //[    ]무사고 확인일 - YYYYMMDD

                if ( ! ( dataToXml.setData ( "morg_begn_date" , MapUtils.getString ( xmlHash , "morg_begn_date" ) )
                && dataToXml.setData ( "morg_fnsh_date" , MapUtils.getString ( xmlHash , "morg_fnsh_date" ) )
                && dataToXml.setData ( "morg_term_text" , MapUtils.getString ( xmlHash , "morg_term_text" ) )
                && dataToXml.setData ( "morg_pric_rate" , MapUtils.getString ( xmlHash , "morg_pric_rate" ) )
                && dataToXml.setData ( "morg_cnfm_code" , MapUtils.getString ( xmlHash , "morg_cnfm_code" ) )
                && dataToXml.setData ( "morg_cnfm_date" , MapUtils.getString ( xmlHash , "morg_cnfm_date" ) ) ) )
                {
                    throw new Exception ( "XML전문 생성중 선급정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
                }
            }
            
            /** 
             * 채권자 정보
             * 별다른 정보 없음 ^0^
             * */
            String cred_exst_code = "" ;
            String cred_orga_name = bondSf.getValue ( "BUYER_COMPANY_NAME"     , 0 ) ;
            String cred_orps_divs = "O" ;
            String cred_orga_numb = "1101112204470" ;
            String cred_orps_iden = bondSf.getValue ( "BUYER_COMPANY_IRS_NO"   , 0 ) ;
            String cred_ownr_numb = "9919175029521" ;
            String cred_ownr_name = bondSf.getValue ( "BUYER_COMPANY_CEO_NAME" , 0 ) ;
            String cred_bond_hold = bondSf.getValue ( "BUYER_COMPANY_CEO_NAME" , 0 ) ;
            String cred_addn_name = "" ;
            String cred_orga_post = bondSf.getValue ( "BUYER_ZIP_CODE"         , 0 ) ;
            String cred_orga_addr = bondSf.getValue ( "BUYER_COMPANY_ADDR"     , 0 ) ;
            String cred_chrg_name = bondSf.getValue ( "BUYER_USER_NAME "       , 0 ) ;
            String cred_dept_name = bondSf.getValue ( "BUYER_DEPT_NAME"        , 0 ) ;
            String cred_phon_numb = SepoaString.replaceString ( SepoaString.decString ( bondSf.getValue ( "BUYER_PHONE_NO1" , 0 ) , "PHONE" ) , "-" , "" ) ;
            String cred_cell_phon = SepoaString.replaceString ( SepoaString.decString ( bondSf.getValue ( "BUYER_PHONE_NO2" , 0 ) , "PHONE" ) , "-" , "" ) ;
            String cred_send_mail = SepoaString.replaceString ( SepoaString.decString ( bondSf.getValue ( "BUYER_EMAIL"     , 0 ) , "EMAIL" ) , "&#64;" , "@");
            String cred_user_iden = head_mesg_send ;
            String cred_user_type = getConfig ( "sepoa.head_orga_code" ) ;
            
            xmlHash.put ( "cred_exst_code" ,  cred_exst_code );  //[    ]채권자 존재형태 구분 - 1:단독, 2:공동
            xmlHash.put ( "cred_orga_name" ,  cred_orga_name );  //[필수]기관명 - 피보험자 상호
            xmlHash.put ( "cred_orps_divs" ,  cred_orps_divs );  //[필수]개인/사업자 구분 코드 - O - 사업자, P - 개인
            xmlHash.put ( "cred_orga_numb" ,  cred_orga_numb );  //[필수]법인등록번호
            xmlHash.put ( "cred_orps_iden" ,  cred_orps_iden );  //[필수]사업자/주민등록번호  O인 경우 사업자번호, P인 경우 주민등록번호
            xmlHash.put ( "cred_ownr_numb" ,  cred_ownr_numb );  //[필수]대표자 주민등록번호
            xmlHash.put ( "cred_ownr_name" ,  cred_ownr_name );  //[필수]대표자 성명
            xmlHash.put ( "cred_bond_hold" ,  cred_bond_hold );  //[필수]채권자 명(상호)
            xmlHash.put ( "cred_addn_name" ,  cred_addn_name );  //[    ]채권기관 부가상호
            xmlHash.put ( "cred_orga_post" ,  cred_orga_post );  //[필수]회사 우편번호
            xmlHash.put ( "cred_orga_addr" ,  cred_orga_addr );  //[필수]회사 주소
            xmlHash.put ( "cred_chrg_name" ,  cred_chrg_name );  //[필수]담당자 이름
            xmlHash.put ( "cred_dept_name" ,  cred_dept_name );  //[필수]담당자 소속 부서
            xmlHash.put ( "cred_phon_numb" ,  cred_phon_numb );  //[필수]담당자 전화 번호
            xmlHash.put ( "cred_cell_phon" ,  cred_cell_phon );  //[필수]담당자 휴대전화 번호
            xmlHash.put ( "cred_send_mail" ,  cred_send_mail );  //[필수]담당자 e-Mail 주소
            xmlHash.put ( "cred_user_iden" ,  cred_user_iden );  //[필수]수신처 아이디 - 헤더정보의 전문송신기관 아이디
            xmlHash.put ( "cred_user_type" ,  cred_user_type );  //[필수]수신처TYPE - 헤더정보의 연계기관코드
            if ( ! ( dataToXml.setData ( "cred_orga_name" , MapUtils.getString ( xmlHash , "cred_orga_name" ) )
            && dataToXml.setData ( "cred_orps_divs" , MapUtils.getString ( xmlHash , "cred_orps_divs" ) )
            && dataToXml.setData ( "cred_orga_numb" , MapUtils.getString ( xmlHash , "cred_orga_numb" ) )
            && dataToXml.setData ( "cred_orps_iden" , MapUtils.getString ( xmlHash , "cred_orps_iden" ) )
            && dataToXml.setData ( "cred_ownr_numb" , MapUtils.getString ( xmlHash , "cred_ownr_numb" ) )
            && dataToXml.setData ( "cred_ownr_name" , MapUtils.getString ( xmlHash , "cred_ownr_name" ) )
            && dataToXml.setData ( "cred_bond_hold" , MapUtils.getString ( xmlHash , "cred_bond_hold" ) )
            && dataToXml.setData ( "cred_addn_name" , MapUtils.getString ( xmlHash , "cred_addn_name" ) )
            && dataToXml.setData ( "cred_orga_post" , MapUtils.getString ( xmlHash , "cred_orga_post" ) )
            && dataToXml.setData ( "cred_orga_addr" , MapUtils.getString ( xmlHash , "cred_orga_addr" ) )
            && dataToXml.setData ( "cred_chrg_name" , MapUtils.getString ( xmlHash , "cred_chrg_name" ) )
            && dataToXml.setData ( "cred_dept_name" , MapUtils.getString ( xmlHash , "cred_dept_name" ) )
            && dataToXml.setData ( "cred_phon_numb" , MapUtils.getString ( xmlHash , "cred_phon_numb" ) )
            && dataToXml.setData ( "cred_cell_phon" , MapUtils.getString ( xmlHash , "cred_cell_phon" ) )
            && dataToXml.setData ( "cred_send_mail" , MapUtils.getString ( xmlHash , "cred_send_mail" ) )
            && dataToXml.setData ( "cred_user_iden" , MapUtils.getString ( xmlHash , "cred_user_iden" ) )
            && dataToXml.setData ( "cred_user_type" , MapUtils.getString ( xmlHash , "cred_user_type" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 채권자 정보가 잘못되었습니다." + dataToXml.getErrorMsg() ) ;
            }
            /** 
             * 계약자 정보
             * 별다른 정보 없음 ^0^
             * */
            String appl_exst_code = "";
            String appl_orga_name = bondSf.getValue ( "SELLER_COMPANY_NAME"     , 0 );
            String appl_orps_divs = bondSf.getValue ( "SOLE"                    , 0 );
            String appl_orga_numb = "";
            String appl_orps_iden = bondSf.getValue ( "SOLE_NUMBER"             , 0 );
            String appl_ownr_numb = "1111111111111";
            if ( "P".equals ( appl_orps_divs ) ) {
                appl_orps_iden = MapUtils.getString ( headerData , "resident_no" );
                appl_ownr_numb = MapUtils.getString ( headerData , "resident_no" );
            }
            String appl_ownr_name = bondSf.getValue ( "SELLER_COMPANY_CEO_NAME" , 0 );
            String appl_addn_name = "";
            String appl_orga_post = bondSf.getValue ( "SELLER_ZIP_CODE"         , 0 );
            String appl_orga_addr = bondSf.getValue ( "SELLER_COMPANY_ADDR"     , 0 );
            String appl_chrg_name = bondSf.getValue ( "SELLER_USER_NAME"        , 0 );
            String appl_dept_name = bondSf.getValue ( "SELLER_DEPT_NAME"        , 0 );
            String appl_offc_phon = SepoaString.replaceString ( SepoaString.decString ( bondSf.getValue ( "SELLER_PHONE_NO1" , 0 ) , "PHONE" ) , "-" , "" ) ; 
            String appl_cell_phon = SepoaString.replaceString ( SepoaString.decString ( bondSf.getValue ( "SELLER_PHONE_NO2" , 0 ) , "PHONE" ) , "-" , "" ) ; 
            String appl_send_mail = SepoaString.replaceString ( SepoaString.decString ( bondSf.getValue ( "SELLER_EMAIL" , 0 )     , "EMAIL" ) , "&#64;" , "&");
            String appl_home_post = "";
            String appl_home_addr = "";
            String appl_home_phon = "";
            String appl_user_iden = head_mesg_send;
            String appl_user_type = getConfig ( "sepoa.head_orga_code" ) ;
            
            xmlHash.put ( "appl_exst_code" ,  appl_exst_code );  //[    ]계약자 존재 형태 구분 - 1:단독, 2:공동
            xmlHash.put ( "appl_orga_name" ,  appl_orga_name );  //[필수]기관명
            xmlHash.put ( "appl_orps_divs" ,  appl_orps_divs );  //[필수]구분코드 - O:사업자 P:개인
            xmlHash.put ( "appl_orga_numb" ,  appl_orga_numb );  //[    ]법인등록번호
            xmlHash.put ( "appl_orps_iden" ,  appl_orps_iden );  //[필수]사업자/주민등록번호  O인 경우 사업자번호, P인 경우 주민등록번호
            xmlHash.put ( "appl_ownr_numb" ,  appl_ownr_numb );  //[필수]대표자 주민등록번호 - 개인사업자일 경우 정확한 번호 필수 입력 - 법인인 경우는 13자리를 채우기만 하면됨 (예:1111111111111)
            xmlHash.put ( "appl_ownr_name" ,  appl_ownr_name );  //[필수]대표자 이름
            xmlHash.put ( "appl_addn_name" ,  appl_addn_name );  //[    ]계약업체 부가 상호
            xmlHash.put ( "appl_orga_post" ,  appl_orga_post );  //[    ]계약 회사 우편번호
            xmlHash.put ( "appl_orga_addr" ,  appl_orga_addr );  //[    ]계약 회사 주소
            xmlHash.put ( "appl_chrg_name" ,  appl_chrg_name );  //[    ]담당자 이름
            xmlHash.put ( "appl_dept_name" ,  appl_dept_name );  //[    ]담당자 소속 부서
            xmlHash.put ( "appl_offc_phon" ,  appl_offc_phon );  //[    ]담당자 전화 번호
            xmlHash.put ( "appl_cell_phon" ,  appl_cell_phon );  //[    ]담당자 휴대전화 번호
            xmlHash.put ( "appl_send_mail" ,  appl_send_mail );  //[    ]담당자 e-Mail 주소
            xmlHash.put ( "appl_home_post" ,  appl_home_post );  //[    ]자택 우편번호
            xmlHash.put ( "appl_home_addr" ,  appl_home_addr );  //[    ]자택 주소
            xmlHash.put ( "appl_home_phon" ,  appl_home_phon );  //[    ]자택 전화 번호
            xmlHash.put ( "appl_user_iden" ,  appl_user_iden );  //[필수]수신처 아이디 - 헤더정보의 전문송신기관
            xmlHash.put ( "appl_user_type" ,  appl_user_type );  //[필수]수신처 Type - 헤더정보의 연계기관코드
            if ( ! ( dataToXml.setData ( "appl_orga_name" , MapUtils.getString ( xmlHash , "appl_orga_name" ) )
            && dataToXml.setData ( "appl_orps_divs" , MapUtils.getString ( xmlHash , "appl_orps_divs" ) )
            && dataToXml.setData ( "appl_orga_numb" , MapUtils.getString ( xmlHash , "appl_orga_numb" ) )
            && dataToXml.setData ( "appl_orps_iden" , MapUtils.getString ( xmlHash , "appl_orps_iden" ) )
            && dataToXml.setData ( "appl_ownr_numb" , MapUtils.getString ( xmlHash , "appl_ownr_numb" ) )
            && dataToXml.setData ( "appl_ownr_name" , MapUtils.getString ( xmlHash , "appl_ownr_name" ) )
            && dataToXml.setData ( "appl_addn_name" , MapUtils.getString ( xmlHash , "appl_addn_name" ) )
            && dataToXml.setData ( "appl_orga_post" , MapUtils.getString ( xmlHash , "appl_orga_post" ) )
            && dataToXml.setData ( "appl_orga_addr" , MapUtils.getString ( xmlHash , "appl_orga_addr" ) )
            && dataToXml.setData ( "appl_chrg_name" , MapUtils.getString ( xmlHash , "appl_chrg_name" ) )
            && dataToXml.setData ( "appl_dept_name" , MapUtils.getString ( xmlHash , "appl_dept_name" ) )
            && dataToXml.setData ( "appl_offc_phon" , MapUtils.getString ( xmlHash , "appl_offc_phon" ) )
            && dataToXml.setData ( "appl_cell_phon" , MapUtils.getString ( xmlHash , "appl_cell_phon" ) )
            && dataToXml.setData ( "appl_send_mail" , MapUtils.getString ( xmlHash , "appl_send_mail" ) )
            && dataToXml.setData ( "appl_home_post" , MapUtils.getString ( xmlHash , "appl_home_post" ) )
            && dataToXml.setData ( "appl_home_addr" , MapUtils.getString ( xmlHash , "appl_home_addr" ) )
            && dataToXml.setData ( "appl_home_phon" , MapUtils.getString ( xmlHash , "appl_home_phon" ) )
            && dataToXml.setData ( "appl_user_iden" , MapUtils.getString ( xmlHash , "appl_user_iden" ) )
            && dataToXml.setData ( "appl_user_type" , MapUtils.getString ( xmlHash , "appl_user_type" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 계약자 정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
            /** 
             * 수요자 정보
             * 별다른 정보 없음 ^0^
             * */
            String mang_orga_name = "";
            String mang_orps_divs = "";
            String mang_orga_numb = "";
            String mang_orps_iden = "";
            String mang_ownr_numb = "";
            String mang_ownr_name = "";
            String mang_addn_name = "";
            String mang_orga_post = "";
            String mang_orga_addr = "";
            String mang_bond_hold = "";
            String mang_chrg_name = "";
            String mang_dept_name = "";
            String mang_phon_numb = "";
            String mang_cell_phon = "";
            String mang_send_mail = "";
            String mang_user_iden = "";
            String mang_user_type = "";
            
            xmlHash.put ( "mang_orga_name" ,  mang_orga_name );  //[    ]기관명
            xmlHash.put ( "mang_orps_divs" ,  mang_orps_divs );  //[    ]구분코드 - O:사업자 P:개인
            xmlHash.put ( "mang_orga_numb" ,  mang_orga_numb );  //[    ]법인등록번호
            xmlHash.put ( "mang_orps_iden" ,  mang_orps_iden );  //[    ]사업자/주민등록번호 - O인 경우 사업자번호, P인 경우 주민등록번호
            xmlHash.put ( "mang_ownr_numb" ,  mang_ownr_numb );  //[    ]대표자 주민등록번호
            xmlHash.put ( "mang_ownr_name" ,  mang_ownr_name );  //[    ]성명(대표자명)
            xmlHash.put ( "mang_addn_name" ,  mang_addn_name );  //[    ]수요(대행)업체 부가상호
            xmlHash.put ( "mang_orga_post" ,  mang_orga_post );  //[    ]회사 우편번호
            xmlHash.put ( "mang_orga_addr" ,  mang_orga_addr );  //[    ]회사 주소
            xmlHash.put ( "mang_bond_hold" ,  mang_bond_hold );  //[    ]채권자명
            xmlHash.put ( "mang_chrg_name" ,  mang_chrg_name );  //[    ]담당자명
            xmlHash.put ( "mang_dept_name" ,  mang_dept_name );  //[    ]담당자 소속 부서
            xmlHash.put ( "mang_phon_numb" ,  mang_phon_numb );  //[    ]담당자 전화 번호
            xmlHash.put ( "mang_cell_phon" ,  mang_cell_phon );  //[    ]담당자 휴대전화 번호
            xmlHash.put ( "mang_send_mail" ,  mang_send_mail );  //[    ]담당자 EMAIL 주소
            xmlHash.put ( "mang_user_iden" ,  mang_user_iden );  //[    ]수신처 아이디 - 헤더정보의 전문송신기관
            xmlHash.put ( "mang_user_type" ,  mang_user_type );  //[    ]수신처 Type - 헤더정보의 연계기관코드
            
            if ( ! ( dataToXml.setData ( "mang_orga_name" , MapUtils.getString ( xmlHash , "mang_orga_name" ) )
            && dataToXml.setData ( "mang_orps_divs" , MapUtils.getString ( xmlHash , "mang_orps_divs" ) )
            && dataToXml.setData ( "mang_orga_numb" , MapUtils.getString ( xmlHash , "mang_orga_numb" ) )
            && dataToXml.setData ( "mang_orps_iden" , MapUtils.getString ( xmlHash , "mang_orps_iden" ) )
            && dataToXml.setData ( "mang_ownr_numb" , MapUtils.getString ( xmlHash , "mang_ownr_numb" ) )
            && dataToXml.setData ( "mang_ownr_name" , MapUtils.getString ( xmlHash , "mang_ownr_name" ) )
            && dataToXml.setData ( "mang_addn_name" , MapUtils.getString ( xmlHash , "mang_addn_name" ) )
            && dataToXml.setData ( "mang_orga_post" , MapUtils.getString ( xmlHash , "mang_orga_post" ) )
            && dataToXml.setData ( "mang_orga_addr" , MapUtils.getString ( xmlHash , "mang_orga_addr" ) )
            && dataToXml.setData ( "mang_bond_hold" , MapUtils.getString ( xmlHash , "mang_bond_hold" ) )
            && dataToXml.setData ( "mang_chrg_name" , MapUtils.getString ( xmlHash , "mang_chrg_name" ) )
            && dataToXml.setData ( "mang_dept_name" , MapUtils.getString ( xmlHash , "mang_dept_name" ) )
            && dataToXml.setData ( "mang_phon_numb" , MapUtils.getString ( xmlHash , "mang_phon_numb" ) )
            && dataToXml.setData ( "mang_cell_phon" , MapUtils.getString ( xmlHash , "mang_cell_phon" ) )
            && dataToXml.setData ( "mang_send_mail" , MapUtils.getString ( xmlHash , "mang_send_mail" ) )
            && dataToXml.setData ( "mang_user_iden" , MapUtils.getString ( xmlHash , "mang_user_iden" ) )
            && dataToXml.setData ( "mang_user_type" , MapUtils.getString ( xmlHash , "mang_user_type" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 수요자 정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
                
            }
            
            Set < Entry < String , String >> xmlSet = xmlHash.entrySet ( ) ;
            for ( Entry < String , String > entry : xmlSet ) { // xmlHash 에들어있는데이타 로그로 확인
                Logger.debug.println ( "XML-DATA : " + entry.getKey ( ) + " - " + entry.getValue ( ) ) ;
            }

            
            String xmlDoc = dataToXml.getxmlData ( ) ;
            String infPath = sepoa.fw.util.CommonUtil.getConfig ( "sepoa.sgix." + MapUtils.getString ( headerData , "docTypeCode" ).toLowerCase ( ) + ".path" ) ; // XML파일 떨어지는 위치
            FileWriteUtil.genFileCreate ( infPath + MapUtils.getString ( headerData , "docTypeCode" ) + "-" + SYSDATE + SYSTIME + "-" + bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 ) + ".xml" , xmlDoc ) ;
            
            String reqXml = xmlDoc ;
            Logger.debug.println ( "Create XML Document : \n" + reqXml ) ;
        	customHeader.put("cont_number",  bondSf.getValue ( "CONT_NUMBER" , 0 ) );
        	customHeader.put("cont_gl_seq",  bondSf.getValue ( "CONT_GL_SEQ" , 0 ) );
        	customHeader.put("pre_ins_date", MapUtils.getString ( headerData , "pre_ins_date" ).replaceAll("-", "")  );
            if(true){// 테스트 환경구축 완료시 요 이프문 삭제
            	sxp = new SepoaXmlParser(this, "setSgix_flag_update");
            	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            	ssm.doUpdate(headerData, customHeader);
                Commit ( );

                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                ////////////////////////////////////////////////////////// 연계가능시 주석해제
                throw new Exception ("난 테스트 중인다 =0=");
            }
            SGIxLinker xLinker = new SGIxLinker ( sendinfo_conf , "send_jsp" , true ) ;
            boolean isOK = xLinker.doSendProcess ( reqXml , null ) ;
            if ( !isOK ) {
                throw new Exception ( xLinker.getErrorMsg ( ) ) ;
            } else {
                
                String recvXml = xLinker.getRecvXmlData ( ) ;
                Logger.debug.println ( "Response XML Document : \n" + recvXml ) ;
                XmlToData xmlToData = null ;
                xmlToData = new XmlToData ( xLinker.getTempPath ( ) , "RESPONSE" , recvXml ) ;
                
                if ( xmlToData.getErrorCode ( ) != 0 ) {
                    Logger.sys.println ( xmlToData.getErrorMsg ( ) ) ;
                }
                
                String res_cont_num = xmlToData.getData ( "res_cont_num" ) ;
                String respTypeCode = xmlToData.getData ( "res_info_code" ) ;
                String respTypeName = xmlToData.getData ( "res_info_typename" ) ;
                String respMesgText = xmlToData.getData ( "res_info_result" ) ;
                

            	
                if ( respTypeCode.equals ( "SA" ) ) {
                	sxp = new SepoaXmlParser(this, "setSgix_flag_update");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doUpdate(headerData, customHeader);
                } else { // 통보서전송 실패
                    throw new Exception ( respMesgText ) ;
                }
                
            }
            Commit ( ) ;
        } catch ( Exception e ) {
            Rollback ( ) ;
            
            Logger.err.println ( info.getSession ( "ID" ) , this , e.getMessage ( ) ) ;
            setFlag ( false ) ;
            setStatus ( 0 ) ;
            setMessage ( e.getMessage ( ) ) ;
        }
        
        return getSepoaOut ( ) ;
    }
    
    /**
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     */
    
    /**
     * 서울보증보험에 취소 / 거부 / 접수 XML문서 송신
     * @param allData
     * @return
     * @throws Exception
     */
    @ SuppressWarnings ( "unchecked" )
    private SepoaOut setSgixSendAfter ( Map < String , Object > allData ) throws Exception {
        
        Map < String , String > headerData = MapUtils.getMap ( allData , "headerData" ) ;
        ConnectionContext ctx = getConnectionContext ( ) ;
        ParamSql sm = new ParamSql ( info.getSession ( "ID" ) , this , ctx ) ;
        StringBuffer sb = new StringBuffer ( ) ;
        String sendinfo_conf = getConfig ( "sepoa.sgix.sendinfo.conf" ) ; /* 송신 시 사용하는 환경설정파일 */
        String templates_path = getConfig ( "sepoa.sgix.templates.path" ) ; /* 각 전문에 임시 템플릿 xml, 전문 MAP 파일 위치 경로 */

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
        try {
            /** XML 데이타 생성 시작 */
            DataToXml dataToXml = new DataToXml ( templates_path ,  "RBONGU" ) ;
            
            HashMap < String , String > xmlHash = new HashMap < String , String > ( ) ;
            
            if ( dataToXml.getErrorCode ( ) != 0 ) {
                
                Logger.sys.println ( dataToXml.getErrorMsg ( ) ) ;
                return null ;
            }
            /**
             * 공통으로 쓰일 필드들 모음
             */
            String SYSDATE = SepoaDate.getShortDateString ( );
            String SYSTIME = SepoaDate.getShortTimeString ( );
            String INFTYPE = "";
            String INFTEXT = "최종응답서";
            String REQTEXT = ""; // 취소 / 파기 / 접수 / 거부 TEXT저장
            
            String bonNumber = "";

            if("CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ))){ //계약
                INFTYPE = "002";
                if ( "DD".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//계약취소
                    bonNumber = bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 );
                    REQTEXT   = "취소";
                } else if ( "DE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//계약파기
                    bonNumber = bondSf.getValue ( "CONT_INS_NO" , 0 );
                    REQTEXT   = "파기";
                } else if ( "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//접수
                    bonNumber = bondSf.getValue ( "CONT_INS_NO" , 0 );
                    REQTEXT   = "접수";
                } else if ( "RE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//거부
                    bonNumber = bondSf.getValue ( "CONT_INS_NO" , 0 );
                    REQTEXT   = "거부";
                }
            }else if("PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ))){ //선급
                INFTYPE = "004";
                if ( "DD".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//계약취소
                    bonNumber = bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 );
                    REQTEXT   = "취소";
                } else if ( "DE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//계약파기
                    bonNumber = bondSf.getValue ( "PRE_INS_NO" , 0 );
                    REQTEXT   = "파기";
                } else if ( "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//접수
                    bonNumber = bondSf.getValue ( "PRE_INS_NO" , 0 );
                    REQTEXT   = "접수";
                } else if ( "RE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//거부
                    bonNumber = bondSf.getValue ( "PRE_INS_NO" , 0 );
                    REQTEXT   = "거부";
                }
            }else if("FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ))){ //하자
                INFTYPE = "003";
                if ( "DD".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//계약취소
                    bonNumber = bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 );
                    REQTEXT   = "취소";
                } else if ( "DE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//계약파기
                    bonNumber = bondSf.getValue ( "FAULT_INS_NO" , 0 );
                    REQTEXT   = "파기";
                } else if ( "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//접수
                    bonNumber = bondSf.getValue ( "FAULT_INS_NO" , 0 );
                    REQTEXT   = "접수";
                } else if ( "RE".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) {//거부
                    bonNumber = bondSf.getValue ( "FAULT_INS_NO" , 0 );
                    REQTEXT   = "거부";
                }
            }
            
            
            /** 
             * 모든 순서는 계약 >> 선급 >> 하자 순 세가지 나올때
             * 
             * XML 헤더
             * ---------------------------------------------------------------------문서코드
             * 계약 - CONINF, 선급 - PREINF, 하자 - FLRINF
             * ---------------------------------------------------------------------문서명
             * 계약 - 계약정보통보서, 선급 - 선금정보통보서, 하자 - 하자정보통보서
             * ---------------------------------------------------------------------상품구분코드
             * 계약 - 002, 선급 - 004, 하자 - 003
             * */
            String head_mesg_send = getConfig ( "sepoa.head_mesg_send" ) ;
            String head_mesg_recv = getConfig ( "sepoa.head_mesg_recv" ) ;
            String head_func_code = getConfig ( "sepoa.head_func_code" ) ;
            String head_mesg_type = "RBONGU" ;
            String head_mesg_name = INFTEXT ;
            String head_mesg_vers = "1.0" ;
            String head_docu_numb = "004" + INFTYPE + bonNumber + " 00" ;
            String head_mang_numb = head_mesg_send + "." + SYSDATE + SYSTIME + ".12345.004" + INFTYPE + bonNumber + " 00" ;
            String head_refr_numb = "004" + INFTYPE + bonNumber + " 00" ;
            String head_titl_name = INFTEXT ;
            String head_orga_code = getConfig ( "sepoa.head_orga_code" ) ; 

            xmlHash.put ( "head_mesg_send" ,  head_mesg_send );  //[필수]송신자ID : A+피보험자사업자번호+00 (총 13자리) 예) A104811234500
            xmlHash.put ( "head_mesg_recv" ,  head_mesg_recv );  //[필수]수신자ID : z120811300200(서울보증보험 ID로 총 13자리 고정값)
            xmlHash.put ( "head_func_code" ,  head_func_code );  //[필수]문서기능코드 : 9:원본,1:취소,53:테스트
            xmlHash.put ( "head_mesg_type" ,  head_mesg_type );  //[필수]문서코드: "RBONGU" 고정
            xmlHash.put ( "head_mesg_name" ,  head_mesg_name );  //[필수]문서명 : "최종응답서" 로 고정
            xmlHash.put ( "head_mesg_vers" ,  head_mesg_vers );  //[    ]문서버젼
            xmlHash.put ( "head_docu_numb" ,  head_docu_numb );  //[필수]문서번호:004+상품구분코드(3)+실증권번호(18) +' '+차수(2)   예) 004001100000200800000033 00 [단, 계약취소 인 경우:004+상품구분코드(3) +계약(공고)번호+' '+차수 2)]
            xmlHash.put ( "head_mang_numb" ,  head_mang_numb );  //[필수]문서관리번호 : 송신기관코드(13)+'.'+SYSDATE(8)+SYSTIME(6)+'.12345.'+004+상품구분코드(3)+증권번호(18)+' '+차수(2) 예) z120811300200.20080812105619.12345.004001100000200800000033 00 [단, 계약취소 인 경우는 증권번호 대신 계약(공고)번호를 넣는다.]
            xmlHash.put ( "head_refr_numb" ,  head_refr_numb );  //[필수]참조번호:004+상품구분코드(3)+실증권번호(18) +' '+차수(2)  예) 004001100000200800000033 00 [단, 계약취소 인 경우:004+상품구분코드(3) +계약(공고)번호+' '+차수(2)]
            xmlHash.put ( "head_titl_name" ,  head_titl_name );  //[필수]문서명과 동일
            xmlHash.put ( "head_orga_code" ,  head_orga_code );  //[필수]연계기관코드 : 피보험자 연계기관 코드 (서울보증보험에서 정의)
            
            if ( ! ( dataToXml.setData ( "head_mesg_send" , MapUtils.getString ( xmlHash , "head_mesg_send" ) )
            && dataToXml.setData ( "head_mesg_recv" , MapUtils.getString ( xmlHash , "head_mesg_recv" ) )
            && dataToXml.setData ( "head_func_code" , MapUtils.getString ( xmlHash , "head_func_code" ) )
            && dataToXml.setData ( "head_mesg_type" , MapUtils.getString ( xmlHash , "head_mesg_type" ) )
            && dataToXml.setData ( "head_mesg_name" , MapUtils.getString ( xmlHash , "head_mesg_name" ) )
            && dataToXml.setData ( "head_mesg_vers" , MapUtils.getString ( xmlHash , "head_mesg_vers" ) )
            && dataToXml.setData ( "head_docu_numb" , MapUtils.getString ( xmlHash , "head_docu_numb" ) )
            && dataToXml.setData ( "head_mang_numb" , MapUtils.getString ( xmlHash , "head_mang_numb" ) )
            && dataToXml.setData ( "head_refr_numb" , MapUtils.getString ( xmlHash , "head_refr_numb" ) )
            && dataToXml.setData ( "head_titl_name" , MapUtils.getString ( xmlHash , "head_titl_name" ) )
            && dataToXml.setData ( "head_orga_code" , MapUtils.getString ( xmlHash , "head_orga_code" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 헤더정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
            /**
             * 문서정보   
             */
            String docu_numb_text = bonNumber + " 00";
            String docu_kind_code = INFTYPE;
            String docu_issu_date = "";
            String docu_user_type = getConfig ( "sepoa.head_orga_code" ) ;
            
            xmlHash.put ( "docu_numb_text" ,  docu_numb_text ); //[필수]증권번호=>원증권번호(18) + ' ' + 차수(2) -증권구분번호가 004002100000200800123456 00 이었다면 빨간색 부분이 원증권번호 18자리이고 파란색 부분이 차수 2자리가 됨 [단, 게약 취소인경우는 계약번호(공고번호)가 들어감]
            xmlHash.put ( "docu_kind_code" ,  docu_kind_code ); //[필수]보험종목(상품)코드 : 001:입찰, 002:계약, 003:하자, 004:선금, 005:상품대금, 006:지급, 007:생활안정, 009:납세, 008:공사이행
            xmlHash.put ( "docu_issu_date" ,  docu_issu_date ); //[    ]작성일자 - YYYYMMDD
            xmlHash.put ( "docu_user_type" ,  docu_user_type ); //[필수]발신처 Type - 피보험자 연계기관 코드- 헤더정보의 연계기관코드와 동일 예)SKT, KTX등
            if ( ! ( dataToXml.setData ( "docu_numb_text" , MapUtils.getString ( xmlHash , "docu_numb_text" ) )
            && dataToXml.setData ( "docu_kind_code" , MapUtils.getString ( xmlHash , "docu_kind_code" ) )
            && dataToXml.setData ( "docu_issu_date" , MapUtils.getString ( xmlHash , "docu_issu_date" ) )
            && dataToXml.setData ( "docu_user_type" , MapUtils.getString ( xmlHash , "docu_user_type" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 헤더정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
            /**
             * 주요계약 정보
             */
            String cont_numb_text = bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 );
            String cont_main_name = bondSf.getValue ( "SUBJECT" , 0 ) ;
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "`" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "~" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "!" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "@" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "#" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "$" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "%" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "^" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "&" , "" );
                   cont_main_name = SepoaString.replaceString ( cont_main_name , "*" , "" );
            String cont_curc_code = "";
            String cont_main_amnt = "";
            
            xmlHash.put ( "cont_numb_text" ,  cont_numb_text ); //[필수]계약번호(공고번호) - 해당 증권에 사용되거나 사용된 계약(공고)번호(차수 포함된 계약번호만 정확히 기재)
            xmlHash.put ( "cont_main_name" ,  cont_main_name ); //[필수]계약명
            xmlHash.put ( "cont_curc_code" ,  cont_curc_code ); //[    ]계약금액 통화코드 - WON(원화), USD(미달러), EUR(유로화) 등
            xmlHash.put ( "cont_main_amnt" ,  cont_main_amnt ); //[    ]계약금액 - 예) 1500000
            if ( ! ( dataToXml.setData ( "cont_numb_text" , MapUtils.getString ( xmlHash , "cont_numb_text" ) )
            && dataToXml.setData ( "cont_main_name" , MapUtils.getString ( xmlHash , "cont_main_name" ) )
            && dataToXml.setData ( "cont_curc_code" , MapUtils.getString ( xmlHash , "cont_curc_code" ) )
            && dataToXml.setData ( "cont_main_amnt" , MapUtils.getString ( xmlHash , "cont_main_amnt" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 헤더정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
            /**
             * 계약저 정보
             * 계약자 정보(입찰정보의 계약취소(DD)인 경우 계약자 정보가 없는 경우는 상호, 번호, 대표자명은 모두 1로 채우면 됨)
             */
            String appl_orga_name = bondSf.getValue ( "SELLER_COMPANY_NAME"     , 0 );
            String appl_orps_divs = bondSf.getValue ( "SOLE"                    , 0 );
            String appl_orps_iden = bondSf.getValue ( "SOLE_NUMBER"             , 0 );
            String appl_ownr_name = bondSf.getValue ( "SELLER_COMPANY_CEO_NAME" , 0 );
            
            xmlHash.put ( "appl_orga_name" ,  appl_orga_name ); //[필수]계약자 상호
            xmlHash.put ( "appl_orps_divs" ,  appl_orps_divs ); //[필수]개인/사업자 구분 - O:사업자, P:개인
            xmlHash.put ( "appl_orps_iden" ,  appl_orps_iden ); //[필수]계약자 번호 : 개인/사업자구분코드가 'O'면 사업자번호 'P'면 주민등록번호
            xmlHash.put ( "appl_ownr_name" ,  appl_ownr_name ); //[필수]계약자 대표자명
            if ( ! ( dataToXml.setData ( "appl_orga_name" , MapUtils.getString ( xmlHash , "appl_orga_name" ) )
            && dataToXml.setData ( "appl_orps_divs" , MapUtils.getString ( xmlHash , "appl_orps_divs" ) )
            && dataToXml.setData ( "appl_orps_iden" , MapUtils.getString ( xmlHash , "appl_orps_iden" ) )
            && dataToXml.setData ( "appl_ownr_name" , MapUtils.getString ( xmlHash , "appl_ownr_name" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 헤더정보가 잘못되었습니다." ) ;
            }
            /**
             * 채권자 정보
             */
            String cred_bond_hold = bondSf.getValue ( "BUYER_COMPANY_NAME"     , 0 );
            xmlHash.put ( "cred_bond_hold" ,  cred_bond_hold ); //[필수]채권자 명 - 피보험자 상호(이름)
            if ( ! ( dataToXml.setData ( "cred_bond_hold" , MapUtils.getString ( xmlHash , "cred_bond_hold" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 헤더정보가 잘못되었습니다." ) ;
            }
            /**
             * 응답 정보
             * 응답 코드
             * DD:계약취소(기 계약내용 삭제-증권발행 전),
             * DE:계약파기(증권취소/해지-계약정보 삭제, 담당자거부)
             * AP:담당자접수(증권을 사용하겠다는 의미)
             * RE:담당자거부(증권내용에 이상이 있어서 증권을 사용하지 않겠다는 의미)
             * - 담당자접수(AP)와 담당자거부(RE)는 전자보증서 수신 시 기 계약내용과 수신한 보증서 내용을 시스템적으로 정확하게 체크 하였다면 거의 필요없는 기능이 됨)
             * - 전자 보증서 수신 후 리턴하는 시스템 응답(SA,SR) 
             */
            
            String resp_type_code = MapUtils.getString ( headerData , "docTypeFlag" );
            String resp_type_name = REQTEXT;
            String resp_mesg_text = MapUtils.getString ( headerData , "docTypeFlagMessage" );
            if ( "".equals ( resp_mesg_text ) ) {
                resp_mesg_text = REQTEXT;
            }
            xmlHash.put ( "resp_type_code" ,  resp_type_code ); //[필수]
            xmlHash.put ( "resp_type_name" ,  resp_type_name ); //[필수] 응답코드명 - 취소, 파기, 접수, 거부
            xmlHash.put ( "resp_mesg_text" ,  resp_mesg_text ); //[필수] 응답내용 - 접수 또는 거부 사유 기재
            if ( ! ( dataToXml.setData ( "resp_type_code" , MapUtils.getString ( xmlHash , "resp_type_code" ) )
            && dataToXml.setData ( "resp_type_name" , MapUtils.getString ( xmlHash , "resp_type_name" ) )
            && dataToXml.setData ( "resp_mesg_text" , MapUtils.getString ( xmlHash , "resp_mesg_text" ) ) ) )
            {
                throw new Exception ( "XML전문 생성중 헤더정보가 잘못되었습니다.\n" + dataToXml.getErrorMsg ( ) ) ;
            }
            
            Set < Entry < String , String >> xmlSet = xmlHash.entrySet ( ) ;
            for ( Entry < String , String > entry : xmlSet ) { // xmlHash 에들어있는데이타 로그로 확인
                Logger.debug.print ( "XML-DATA : " + entry.getKey ( ) + " - " + entry.getValue ( ) ) ;
            }
            
            String xmlDoc = dataToXml.getxmlData ( ) ;
            String infPath = sepoa.fw.util.CommonUtil.getConfig ( "sepoa.sgix." + MapUtils.getString ( headerData , "docTypeCode" ).toLowerCase ( ) + ".path" ) ; // XML파일 떨어지는 위치
            FileWriteUtil.genFileCreate ( infPath + MapUtils.getString ( headerData , "docTypeCode" ) + "-" + SYSDATE + SYSTIME + "-" + bondSf.getValue ( "CONT_NUMBER" , 0 ) + bondSf.getValue ( "CONT_GL_SEQ" , 0 ) + "_" + MapUtils.getString ( headerData , "docTypeFlag" ) +".xml" , xmlDoc ) ;
            
            String reqXml = xmlDoc ;
            Logger.debug.println ( "Create XML Document : \n" + reqXml ) ;
            if(true){// 테스트 환경구축 완료시 요 이프문 모두 삭제
            	
                if ( "CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && !"AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // 계약이고 접수가 아닐때
                	customHeader.put("docProgress", "CONINFNOTAP");
                }
                
                if ( "CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // 계약이고 접수일때
                	customHeader.put("docProgress", "CONINFAP");
                }
                
                if ( "PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && !"AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 선급이고 접수가 아닐때
                	customHeader.put("docProgress", "PREINFNOTAP");
                } 

                if ( "PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 선급이고 접수일때
                	customHeader.put("docProgress", "PREINFAP");
                }
                
                if ( "FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && !"AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 하자이고 접수가 아닐때
                	customHeader.put("docProgress", "FLRINFNOTAP");
                } 
                if ( "FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 하자이고 접수일때
                	customHeader.put("docProgress", "FLRINFAP");
                }
            	sxp = new SepoaXmlParser(this, "setSgixSendAfter_flag_update");
            	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
            	ssm.doUpdate(headerData, customHeader);
                Commit ( );
                throw new Exception ("난 테스트 중인다 =0=");
            }
            SGIxLinker xLinker = new SGIxLinker ( sendinfo_conf , "send_jsp" , true ) ;
            boolean isOK = xLinker.doSendProcess ( reqXml , null ) ;
            if ( !isOK ) {
                throw new Exception ( xLinker.getErrorMsg ( ) ) ;
            } else {
                
                String recvXml = xLinker.getRecvXmlData ( ) ;
                Logger.debug.println ( "Response XML Document : \n" + recvXml ) ;
                XmlToData xmlToData = null ;
                xmlToData = new XmlToData ( xLinker.getTempPath ( ) , "RESPONSE" , recvXml ) ;
                
                if ( xmlToData.getErrorCode ( ) != 0 ) {
                    Logger.sys.println ( xmlToData.getErrorMsg ( ) ) ;
                }
                
                String res_cont_num = xmlToData.getData ( "res_cont_num" ) ;
                String respTypeCode = xmlToData.getData ( "res_info_code" ) ;
                String respTypeName = xmlToData.getData ( "res_info_typename" ) ;
                String respMesgText = xmlToData.getData ( "res_info_result" ) ;
                
                if ( respTypeCode.equals ( "SA" ) ) {

                    if ( "CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && !"AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // 계약이고 접수가 아닐때
                    	customHeader.put("docProgress", "CONINFNOTAP");
                    }
                    
                    if ( "CONINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) ) ) { // 계약이고 접수일때
                    	customHeader.put("docProgress", "CONINFAP");
                    }
                    
                    if ( "PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && !"AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 선급이고 접수가 아닐때
                    	customHeader.put("docProgress", "PREINFNOTAP");
                    } 

                    if ( "PREINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 선급이고 접수일때
                    	customHeader.put("docProgress", "PREINFAP");
                    }
                    
                    if ( "FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && !"AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 하자이고 접수가 아닐때
                    	customHeader.put("docProgress", "FLRINFNOTAP");
                    } 
                    if ( "FLRINF".equals ( MapUtils.getString ( headerData , "docTypeCode" ) ) && "AP".equals ( MapUtils.getString ( headerData , "docTypeFlag" ) )  ) { // 하자이고 접수일때
                    	customHeader.put("docProgress", "FLRINFAP");
                    }
                	sxp = new SepoaXmlParser(this, "setSgixSendAfter_flag_update");
                	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                	ssm.doUpdate(headerData, customHeader);
                	
                } else { // 통보서전송 실패
                    throw new Exception ( respMesgText ) ;
                }
                setMessage ( respMesgText );;
                if ( "".equals ( respMesgText.trim ( ) ) ) {
                    setMessage ( "성공적으로 처리하였습니다." );
                }
            }
            Commit ( ) ;
        } catch ( Exception e ) {
            Rollback ( ) ;
            
            Logger.err.println ( info.getSession ( "ID" ) , this , e.getMessage ( ) ) ;
            setFlag ( false ) ;
            setStatus ( 0 ) ;
            setMessage ( e.getMessage ( ) ) ;
        }
        
        return getSepoaOut ( ) ;
    }
    
    
    /**
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     ****************************************************************************************************************************************************************************************************** 
     */
    
    /**
     * 보증보험에서 날려주는 보증보험 문서 벨리데이션 체크 및 저장
     * @param allData
     * @return
     */
    @ SuppressWarnings ( "unchecked" )
    private SepoaOut setSgixRecv ( Map < String , Object > allData ) {

        Map < String , String > headerData = MapUtils.getMap ( allData , "headerData" ) ;
        ConnectionContext ctx = getConnectionContext ( ) ;
        StringBuffer sb = new StringBuffer ( ) ;
        ParamSql sm = new ParamSql ( info.getSession ( "ID" ) , this , ctx ) ;

		SepoaXmlParser sxp = null;
		SepoaSQLManager ssm = null;
		Map<String, String> customHeader =  new HashMap<String, String>();	//신규객체
        try {
            headerData.put ( "bond_numb_text" , SepoaString.getSubString ( MapUtils.getString ( headerData , "bond_numb_text" ) , 6 , 24 ) ) ;
            
            if ( bondSf.getRowCount ( ) < 1 ) {
                setFlag ( false ) ;
                setStatus ( 0 ) ;
                setMessage ( "존재하지 않는 계약번호입니다." ) ;
            } else {
                String insFlag = "" ;
                String insAmt  = "" ;
                if ( MapUtils.getString ( headerData , "bond_type_kind" ).equals ( "CONGUA" ) ) { // 계약이행
                    insFlag = bondSf.getValue ( "CONT_INS_FLAG" , 0 ) ;
                    insAmt = returnParseLong ( bondSf.getValue ( "CONT_INS_AMT" , 0 ) ) ;
                } else if ( MapUtils.getString ( headerData , "bond_type_kind" ).equals ( "FLRGUA" ) ) {// 하자이행
                    insFlag = bondSf.getValue ( "FAULT_INS_FLAG" , 0 ) ;
                    insAmt = returnParseLong ( bondSf.getValue ( "FAULT_INS_AMT" , 0 ) ) ;
                } else { // 선급금
                    insFlag = bondSf.getValue ( "PRE_INS_FLAG" , 0 ) ;
                    insAmt = returnParseLong ( bondSf.getValue ( "PRE_INS_AMT" , 0 ) ) ;
                }
                
                if ( "G".equals ( insFlag ) ) {
                    setFlag ( false ) ;
                    setStatus ( 0 ) ;
                    setMessage ( "해당 계약번호에 대해서 증권정보가 이미 존재합니다." ) ;
                } else {
                    
                    String bond_penl_amnt_casting = returnParseLong ( MapUtils.getString ( headerData , "bond_penl_amnt" ) ) ;
                    Logger.sys.println ( "Recv =========================================================================================================== Recv " ) ;
                    Logger.sys.println ( "Recv ======= insAmt         = " + insAmt ) ;
                    Logger.sys.println ( "Recv ======= bond_penl_amnt = " + bond_penl_amnt_casting ) ;
                    Logger.sys.println ( "Recv =========================================================================================================== Recv " ) ;
                    
                    if ( !insAmt.equals ( bond_penl_amnt_casting ) && !MapUtils.getString ( headerData , "bond_type_kind" ).equals ( "PREGUA" ) ) 
                    {
                        setFlag ( false ) ;
                        setStatus ( 0 ) ;
                        setMessage ( "보증금액이 틀립니다." ) ;
                    }
                    else
                    {
                        File get_file = new File ( MapUtils.getString ( headerData , "bond_path" ) ) ;
                        long FileSize = 0 ;
                        String FileName = "" ;
                        
                        String TYPE = "ALUP" ;
                        String attach_key = "" ;
                        FileSize = get_file.length ( ) ;
                        String real_size = Long.toString ( FileSize ) ;
                        FileName = get_file.getName ( ) ;
                        attach_key = String.valueOf ( System.currentTimeMillis ( ) ) ;
                        String attach_seq = "0000001" ;
                        if ( bondSf.getValue ( "SOLE_NUMBER" , 0 ).trim ( ).equals ( MapUtils.getString ( headerData , "appl_orps_iden" ).trim ( ) ) ) {
                            setFlag ( false ) ;
                            setStatus ( 0 ) ;
                            setMessage ( "보험계약자 사업자번호 또는 주민등록번호정보가 틀립니다." ) ;
                        } else {

                        	customHeader.put("attach_key", attach_key);
                        	customHeader.put("attach_seq", attach_seq);
                        	customHeader.put("type"      , TYPE      );
                        	customHeader.put("FileName"  , FileName  );
                        	customHeader.put("real_size" , real_size );
                        	sxp = new SepoaXmlParser(this, "setCTInsert_contract_insert");
                        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                        	ssm.doInsert(headerData, customHeader);

                        	sxp = new SepoaXmlParser(this, "setSgixSendAfter_flag_update");
                        	ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
                        	ssm.doUpdate(headerData, customHeader);
                            
                            setFlag ( true ) ;
                            setStatus ( 1 ) ;
                            setMessage ( "수신업무가 정상적으로 수행되었습니다." ) ;
                            Commit ( ) ;
                            
                        } // 보험계약자 사업자번호 또는 주민등록번호정보 check
                    }// 보증금액 check
                }// 증권정보 check
            }// 계약번호 check
        } catch ( Exception e ) {
            try {
                Rollback ( ) ;
                
                setFlag ( true ) ;
                setStatus ( 1 ) ;
                setMessage ( "수신거부." ) ;
                
                throw new Exception ( "SQL Manager is Null" ) ;
            } catch ( Exception d ) {
                Logger.err.println ( info.getSession ( "ID" ) , this , d.getMessage ( ) ) ;
            }
            
            
            Logger.err.println ( info.getSession ( "ID" ) , this , e.getMessage ( ) ) ;
        }
        
        return getSepoaOut ( ) ;
    }
    /**
     * 스트링 type 숫자 long타입으로 변경후 소수점이 제거되면 다시 스트링 형태로 반환
     * @param temp
     * @return
     */
    private String returnParseLong ( String temp ) {
    
        long returnLong = 0 ;
        try {
            returnLong = Long.parseLong ( temp ) ;
        } catch ( Exception e ) {
            returnLong = ( long ) Double.parseDouble ( temp ) ;
        }
        return String.valueOf ( returnLong ) ;
    }
    
    public SepoaOut setConfirmSave(String cont_form_no, String contract_name, String contract_type, String remark, String content, String use_flag, String input_flag, String cont_private_flag, String cont_status, String cont_update_desc, String confirm) {
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	ParamSql ps = new ParamSql(this.info.getSession("ID"), this, ctx);
    	SepoaFormater sf = null;

    	int rtn = 0;
    	try {
    		ps.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
	        sqlsb.append("  UPDATE SCTMT SET   \n");
	        sqlsb.append("    CONT_FORM_NAME = ?  \n"); ps.addStringParameter(contract_name);
	        sqlsb.append("   ,CONT_DESC      = ?  \n"); ps.addStringParameter(remark);
	        sqlsb.append("   ,CONT_TYPE      = ?  \n"); ps.addStringParameter(contract_type);
	        sqlsb.append("   ,OFFLINE_FLAG   = ?  \n"); ps.addStringParameter("N");
	        sqlsb.append("   ,CHANGE_USER_ID = ?  \n"); ps.addStringParameter(this.info.getSession("ID"));
	        sqlsb.append("   ,CHANGE_DATE    = ?  \n"); ps.addStringParameter(SepoaDate.getShortDateString());
	        sqlsb.append("   ,CHANGE_TIME    = ?  \n"); ps.addStringParameter(SepoaDate.getShortTimeString());
	        sqlsb.append("   ,USE_FLAG       = ?  \n"); ps.addStringParameter(use_flag);
	        sqlsb.append("   ,CONT_STATUS    = ?  \n"); ps.addStringParameter("C");
	        sqlsb.append("  WHERE CONT_FORM_NO  = ?  \n"); ps.addNumberParameter(cont_form_no);
	        rtn = ps.doInsert(sqlsb.toString());

	        if (rtn == 0) {
	        	setStatus(0);
	        	throw new Exception("SQL Manager is Null");
	        }
	        setStatus(1);
	        Commit();
    	} catch (Exception e) {
    		try {
    			Rollback();
    		} catch (Exception d) {
    			Logger.err.println(this.info.getSession("ID"), this, d.getMessage());
    		}

//    		e.printStackTrace();
    		Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
    	}
    	return getSepoaOut();
    }    

    public SepoaOut setContractSave(String cont_form_no, String contract_name, String contract_type, String remark, String content, String use_flag, String input_flag, String cont_private_flag, String cont_status, String cont_update_desc) {
    	ConnectionContext ctx = getConnectionContext();
    	StringBuffer sqlsb = new StringBuffer();
    	ParamSql ps = new ParamSql(this.info.getSession("ID"), this, ctx);
    	SepoaFormater sf = null;

    	int rtn = 0;
    	try {
    		ps.removeAllValue();
    		sqlsb.delete(0, sqlsb.length());
	        sqlsb.append(" SELECT MAX(CONT_FORM_NO) +1 CNT FROM SCTMT ");
	        sf = new SepoaFormater(ps.doSelect_limit(sqlsb.toString()));

	        String cnt = sf.getValue("CNT", 0);
	        
	        if (cnt.length() > 0)
	        	cnt = sf.getValue("CNT", 0);
	        else {
	        	cnt = "1";
	        }

	        if (cont_private_flag.equals("")) {
	        	cont_private_flag = "PU";
	        }

	        Logger.sys.println("######  cont_private_flag = " + cont_private_flag);

	        content = content.replaceAll("\r\n", "");

	        ps.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());
	        if (input_flag.equals("I")) {
	        	sqlsb.append("  INSERT INTO SCTMT (       \n");
	        	sqlsb.append("    CONT_FORM_NO         \n");
	        	sqlsb.append("   ,CONT_FORM_NAME       \n");
	        	sqlsb.append("   ,CONT_DESC            \n");
	        	sqlsb.append("   ,CONT_TYPE            \n");
	          	sqlsb.append("   ,OFFLINE_FLAG         \n");
	          	sqlsb.append("   ,ADD_USER_ID          \n");
	          	sqlsb.append("   ,ADD_DATE             \n");
	          	sqlsb.append("   ,ADD_TIME             \n");
	            sqlsb.append("   ,CHANGE_USER_ID       \n");
	            sqlsb.append("   ,CHANGE_DATE          \n");
	            sqlsb.append("   ,CHANGE_TIME          \n");
	            sqlsb.append("   ,DEL_FLAG             \n");
	            sqlsb.append("   ,USE_FLAG             \n");
	            sqlsb.append("   ,CONT_PRIVATE_FLAG    \n");
	            sqlsb.append("   ,CONT_USER_ID         \n");
	            sqlsb.append("   ,CONT_STATUS          \n");
	            sqlsb.append("   ,CONT_UPDATE_DESC     \n");
	            sqlsb.append("  ) VALUES (             \n");
	            sqlsb.append("    ?                    \n"); ps.addNumberParameter(cnt);
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(contract_name);
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(remark);
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(contract_type);
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter("N");
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(this.info.getSession("ID"));
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(SepoaDate.getShortDateString());
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(SepoaDate.getShortTimeString());
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(this.info.getSession("ID"));
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(SepoaDate.getShortDateString());
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(SepoaDate.getShortTimeString());
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter("N");
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(use_flag);
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(cont_private_flag);
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(this.info.getSession("ID"));
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter("C");//등록시 바로 확정
	            sqlsb.append("   ,?                    \n"); ps.addStringParameter(cont_update_desc);
	            sqlsb.append("  )                         \n");
	
	            rtn = ps.doInsert(sqlsb.toString());

	            ps.removeAllValue();
	            sqlsb.delete(0, sqlsb.length());
	            sqlsb.append(" INSERT INTO SCTMT_FORM ( \n");
	            sqlsb.append("   SEQ     \n");
	            sqlsb.append("  ,SEQ_SEQ    \n");
	            sqlsb.append("  ,CONTENT    \n");
	            sqlsb.append("  ,DEL_FLAG    \n");
	            sqlsb.append("  ,USE_FLAG    \n");
	            sqlsb.append(" ) VALUES (     \n");
	            sqlsb.append("   ?      \n"); ps.addStringParameter(cnt);
	            sqlsb.append("  ,TO_CHAR(?, '000000') \n"); ps.addStringParameter("1");
	            sqlsb.append("  ,?      \n"); ps.addStringParameter(content);
	            sqlsb.append("  ,?      \n"); ps.addStringParameter("N");
	            sqlsb.append("  ,?      \n"); ps.addStringParameter("N");
	            sqlsb.append(" )       \n");
	            ps.doInsert(sqlsb.toString());
	        } else if ("C".equals(cont_status)) {
	        	ps.removeAllValue();
	        	sqlsb.delete(0, sqlsb.length());
	        	sqlsb.append("  UPDATE SCTMT SET   \n ");
	            sqlsb.append("    CONT_UPDATE_DESC = ? \n "); ps.addStringParameter(cont_update_desc);
	            sqlsb.append("   ,CHANGE_USER_ID = ?  \n "); ps.addStringParameter(this.info.getSession("ID"));
	            sqlsb.append("   ,CHANGE_DATE    = ?  \n "); ps.addStringParameter(SepoaDate.getShortDateString());
	            sqlsb.append("   ,CHANGE_TIME    = ?  \n "); ps.addStringParameter(SepoaDate.getShortTimeString());
	            sqlsb.append("   ,USE_FLAG       = ?  \n "); ps.addStringParameter(use_flag);
	            sqlsb.append("   ,CONT_DESC      = ?  \n "); ps.addStringParameter(remark);
	            sqlsb.append("  WHERE CONT_FORM_NO  = ?  \n "); ps.addNumberParameter(cont_form_no);
	            rtn = ps.doInsert(sqlsb.toString());
	            
	            ps.removeAllValue();
	            sqlsb.delete(0, sqlsb.length());
	            sqlsb.append("  DELETE FROM SCTMT_FORM  \n");
	            sqlsb.append("  WHERE SEQ  = ?    \n"); ps.addNumberParameter(cont_form_no);
	            rtn = ps.doInsert(sqlsb.toString());

	            ps.removeAllValue();
	            sqlsb.delete(0, sqlsb.length());
	            sqlsb.append(" INSERT INTO SCTMT_FORM ( \n");
	            sqlsb.append("   SEQ     \n");
	            sqlsb.append("  ,SEQ_SEQ    \n");
	            sqlsb.append("  ,CONTENT    \n");
	            sqlsb.append("  ,DEL_FLAG    \n");
	            sqlsb.append("  ,USE_FLAG    \n");
	            sqlsb.append(" ) VALUES (     \n");
	            sqlsb.append("   ?      \n"); ps.addStringParameter(cont_form_no);
	            sqlsb.append("  ,TO_CHAR(?, '000000') \n"); ps.addStringParameter("1");
	            sqlsb.append("  ,?      \n"); ps.addStringParameter(content);
	            sqlsb.append("  ,?      \n"); ps.addStringParameter("N");
	            sqlsb.append("  ,?      \n"); ps.addStringParameter(use_flag);
	            sqlsb.append(" )       \n");
	            rtn = ps.doInsert(sqlsb.toString());
	        } else {
	        	ps.removeAllValue();
	            sqlsb.delete(0, sqlsb.length());
	            sqlsb.append("  UPDATE SCTMT SET   \n");
	            sqlsb.append("    CONT_FORM_NAME = ?  \n"); ps.addStringParameter(contract_name);
	            sqlsb.append("   ,CONT_DESC      = ?  \n"); ps.addStringParameter(remark);
	            sqlsb.append("   ,CONT_TYPE      = ?  \n"); ps.addStringParameter(contract_type);
	            sqlsb.append("   ,OFFLINE_FLAG   = ?  \n"); ps.addStringParameter("N");
	            sqlsb.append("   ,CHANGE_USER_ID = ?  \n"); ps.addStringParameter(this.info.getSession("ID"));
	            sqlsb.append("   ,CHANGE_DATE    = ?  \n"); ps.addStringParameter(SepoaDate.getShortDateString());
	            sqlsb.append("   ,CHANGE_TIME    = ?  \n"); ps.addStringParameter(SepoaDate.getShortTimeString());
	            sqlsb.append("   ,USE_FLAG       = ?  \n"); ps.addStringParameter(use_flag);
	            sqlsb.append("  WHERE CONT_FORM_NO  = ?  \n"); ps.addNumberParameter(cont_form_no);
	            rtn = ps.doInsert(sqlsb.toString());
	
	            ps.removeAllValue();
	            sqlsb.delete(0, sqlsb.length());
	            sqlsb.append("  DELETE FROM SCTMT_FORM  \n");
	            sqlsb.append("  WHERE SEQ  = ?    \n"); ps.addNumberParameter(cont_form_no);
	            rtn = ps.doInsert(sqlsb.toString());

	            ps.removeAllValue();
	            sqlsb.delete(0, sqlsb.length());
	            sqlsb.append(" INSERT INTO SCTMT_FORM ( \n");
	            sqlsb.append("   SEQ     \n");
	            sqlsb.append("  ,SEQ_SEQ    \n");
	            sqlsb.append("  ,CONTENT    \n");
	            sqlsb.append("  ,DEL_FLAG    \n");
	            sqlsb.append("  ,USE_FLAG    \n");
	            sqlsb.append(" ) VALUES (     \n");
	            sqlsb.append("   ?      \n"); ps.addStringParameter(cont_form_no);
	            sqlsb.append("  ,TO_CHAR(?, '000000') \n"); ps.addStringParameter("1");
	            sqlsb.append("  ,?      \n"); ps.addStringParameter(content);
	            sqlsb.append("  ,?      \n"); ps.addStringParameter("N");
	            sqlsb.append("  ,?      \n"); ps.addStringParameter(use_flag);
	            sqlsb.append(" )       \n");
	            rtn = ps.doInsert(sqlsb.toString());
	        }

	        if (rtn == 0) {
	        	setStatus(0);
	        	throw new Exception("SQL Manager is Null");
	        }
	        setStatus(1);
	        Commit();
    	} catch (Exception e) {
    		try {
    			Rollback();
    		} catch (Exception d) {
    			Logger.err.println(this.info.getSession("ID"), this, d.getMessage());
    		}

//    		e.printStackTrace();
    		Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
    	}
    	return getSepoaOut();
    }

	public SepoaOut getContractList(SepoaInfo info, String cont_type, String cont_status, String use_flag, String cont_private_flag, String cont_form_name, String from_date, String to_date, String ctrl_person_id) {

		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		try {
			setStatus(1);
			setFlag(true);
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			sm.removeAllValue();
			sqlsb.delete(0, sqlsb.length());
			sqlsb.append("							SELECT  CONT_FORM_NO                   																	\n");
			sqlsb.append("								   ,CONT_FORM_NAME       																			\n");
			sqlsb.append("								   ,GETCODETEXT2('M899', CONT_TYPE, '" + info.getSession("LANGUAGE") + "' ) AS CONT_TYPE            \n");
			sqlsb.append("								   ,ADD_DATE             																			\n");
			sqlsb.append("								   ,GETUSERNAME('"+info.getSession("HOUSE_CODE")+"', CONT_USER_ID, 'LOC')                                         AS CONT_USER_NAME 		\n");
			sqlsb.append("								   ,GETCODETEXT2('M897', CONT_STATUS, 'KO' )                                AS CONT_STATUS    	    \n");
			sqlsb.append("								   ,GETCODETEXT2('M898', USE_FLAG, '"  + info.getSession("LANGUAGE") + "' ) AS USE_FLAG             \n");
			sqlsb.append("							FROM   SCTMT                																			\n");
			sqlsb.append("							WHERE  1=1               																				\n");
			sqlsb.append("							AND NVL(DEL_FLAG, 'N') = 'N'         																	\n");
			sqlsb.append(sm.addSelectString("		AND CONT_TYPE         = ?     																			\n")); sm.addStringParameter(cont_type);
			sqlsb.append(sm.addSelectString("		AND CONT_STATUS       = ?     																			\n")); sm.addStringParameter(cont_status);
			sqlsb.append(sm.addSelectString("		AND USE_FLAG          = ?      																			\n")); sm.addStringParameter(use_flag);
			sqlsb.append(sm.addSelectString("       AND CONT_PRIVATE_FLAG = ?         																		\n")); sm.addStringParameter(cont_private_flag);
			sqlsb.append(sm.addSelectString("       AND CONT_FORM_NAME LIKE '%' || ? || '%'         														\n")); sm.addStringParameter(cont_form_name);
			sqlsb.append(sm.addSelectString("       AND ADD_DATE         >= ?                                                                           	\n")); sm.addStringParameter(from_date);
			sqlsb.append(sm.addSelectString("       AND ADD_DATE         <= ?                                                                           	\n")); sm.addStringParameter(to_date);			
			sqlsb.append(sm.addSelectString("       AND ADD_USER_ID       = ?                                                                           	\n")); sm.addStringParameter(ctrl_person_id);
			sqlsb.append("		                    ORDER BY CONT_FORM_NO DESC																				\n");
			setValue(sm.doSelect(sqlsb.toString()));
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}

		return getSepoaOut();
	}
	
	public SepoaOut getDelete(String[][] bean_args) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();

		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);

			for (int i = 0; i < bean_args.length; i++)
			{
				String CONT_FORM_NO = bean_args[i][0];

				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SCTMT SET                   \n ");
				sqlsb.append("             DEL_FLAG     = 'Y'         \n ");
				sqlsb.append("     WHERE   CONT_FORM_NO = ?           \n "); sm.addStringParameter(CONT_FORM_NO);
				sm.doDelete(sqlsb.toString());
				
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				sqlsb.append("     UPDATE SCTMT_FORM SET           \n ");
				sqlsb.append("                  DEL_FLAG  = 'Y'    \n ");
				sqlsb.append("     WHERE             SEQ  = ?      \n "); sm.addStringParameter(CONT_FORM_NO);
				sm.doDelete(sqlsb.toString());
			}
			Commit();
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	public SepoaOut getContractSelect_head(Map<String, String> params) {
	    ConnectionContext ctx = getConnectionContext();
	    StringBuffer sqlsb = new StringBuffer();
	    try {
	    	setStatus(1);
	    	setFlag(true);
	    	
	    	String cont_form_no = params.get("cont_form_no");
	    	String flag 		= params.get("flag");

	    	ParamSql sm = new ParamSql(this.info.getSession("ID"), this, ctx);

	    	sm.removeAllValue();
	    	sqlsb.delete(0, sqlsb.length());

	        sqlsb.append("	SELECT  CONT_FORM_NO            \n");
	        sqlsb.append("	,       CONT_FORM_NAME          \n");
	        sqlsb.append("	,       CONT_DESC               \n");
	        sqlsb.append("	,       CONT_TYPE               \n");
	        sqlsb.append("	,       OFFLINE_FLAG            \n");
	        sqlsb.append("	,       ADD_USER_ID             \n");
	        sqlsb.append("  ,       ADD_DATE                \n");
	        sqlsb.append("  ,       ADD_TIME                \n");
	        sqlsb.append("  ,       CHANGE_USER_ID          \n");
	        sqlsb.append("  ,       CHANGE_DATE             \n");
	        sqlsb.append("  ,       CHANGE_TIME             \n");
	        sqlsb.append("  ,       USE_FLAG                \n");
	        sqlsb.append("  ,       CONT_PRIVATE_FLAG    	\n");
	        sqlsb.append("  ,       CONT_USER_ID  			\n");
	        sqlsb.append("  ,       GETUSERNAME('"+info.getSession("HOUSE_CODE")+"', CONT_USER_ID, 'LOC') AS CONT_USER_NAME \n");
	        sqlsb.append("  ,       CONT_STATUS  			\n");
	        sqlsb.append("  ,       CONT_UPDATE_DESC  		\n");
	        sqlsb.append("  FROM SCTMT                		\n");
	        sqlsb.append("  WHERE 1 = 1               		\n");
	        sqlsb.append(sm.addSelectString("  AND CONT_FORM_NO = ?      \n"));
	        sm.addStringParameter(cont_form_no);

	        setValue(sm.doSelect(sqlsb.toString()));

	        sm.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());

	        sqlsb.append("	SELECT	CONTENT		\n");
	        sqlsb.append("	FROM 	SCTMT_FORM	\n");
	        sqlsb.append("	WHERE 	1 = 1		\n");
	        sqlsb.append(sm.addSelectString(" AND SEQ = ?\n")); sm.addStringParameter(cont_form_no);
	        sqlsb.append("  AND 	NVL(DEL_FLAG, 'N') = 'N'	\n");
	        sqlsb.append("	ORDER BY SEQ_SEQ 	\n");
	        setValue(sm.doSelect(sqlsb.toString()));
	        
	    }
	    catch (Exception e) {
	    	setStatus(0);
	    	setFlag(false);
	    	setMessage(e.getMessage());
	    	Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
	    }
	    return getSepoaOut();
	}
	public SepoaOut setContractCopy(String cont_form_no, String contract_name, String contract_type, String remark, String content, String use_flag, String input_flag, String cont_private_flag, String cont_status, String cont_update_desc, String user_name)
	{
	    ConnectionContext ctx = getConnectionContext();
	    StringBuffer sqlsb = new StringBuffer();
	    ParamSql ps = new ParamSql(this.info.getSession("ID"), this, ctx);
	    SepoaFormater sf = null;

	    int rtn = 0;
	    try {
	    	ps.removeAllValue();
	    	sqlsb.delete(0, sqlsb.length());
	    	sqlsb.append(" SELECT MAX(CONT_FORM_NO) +1 CNT FROM SCTMT ");
	    	sf = new SepoaFormater(ps.doSelect_limit(sqlsb.toString()));

	    	String cnt = sf.getValue("CNT", 0);
	    	if (cnt.length() > 0)
	    		cnt = sf.getValue("CNT", 0);
	    	else {
	    		cnt = "1";
	    	}

	    	content = content.replaceAll("\r\n", "");
	    	String name = contract_name + "-" + SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) + "-" + user_name;

	    	ps.removeAllValue();
	    	sqlsb.delete(0, sqlsb.length());

	        sqlsb.append("  INSERT INTO SCTMT (              \n");
	        sqlsb.append("               CONT_FORM_NO         \n");
	        sqlsb.append("              ,CONT_FORM_NAME       \n");
	        sqlsb.append("              ,CONT_DESC            \n");
	        sqlsb.append("              ,CONT_TYPE            \n");
	        sqlsb.append("              ,OFFLINE_FLAG         \n");
	        sqlsb.append("              ,ADD_USER_ID          \n");
	        sqlsb.append("              ,ADD_DATE             \n");
	        sqlsb.append("              ,ADD_TIME             \n");
	        sqlsb.append("              ,CHANGE_USER_ID       \n");
	        sqlsb.append("              ,CHANGE_DATE          \n");
	        sqlsb.append("              ,CHANGE_TIME          \n");
	        sqlsb.append("              ,DEL_FLAG             \n");
	        sqlsb.append("              ,USE_FLAG             \n");
	        sqlsb.append("              ,CONT_PRIVATE_FLAG    \n");
	        sqlsb.append("              ,CONT_USER_ID      \n");
	        sqlsb.append("              ,CONT_STATUS          \n");
	        sqlsb.append("              )                                 \n");
	        sqlsb.append("              (                                 \n");
	        sqlsb.append("                 SELECT                            \n");
	        sqlsb.append("                        ?                    \n"); ps.addNumberParameter(cnt);
	        sqlsb.append("                       ,?          \n"); ps.addStringParameter(name);
	        sqlsb.append("                       ,CONT_DESC            \n");
	        sqlsb.append("                       ,CONT_TYPE            \n");
	        sqlsb.append("                       ,OFFLINE_FLAG         \n");
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter(this.info.getSession("ID"));
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter(SepoaDate.getShortDateString());
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter(SepoaDate.getShortTimeString());
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter(this.info.getSession("ID"));
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter(SepoaDate.getShortDateString());
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter(SepoaDate.getShortTimeString());
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter("N");
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter("N");
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter("PV");
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter(this.info.getSession("ID"));
	        sqlsb.append("                       ,?                    \n"); ps.addStringParameter("W");
	        sqlsb.append("              FROM        SCTMT                 \n");
	        sqlsb.append("              WHERE       1 = 1                 \n");
	        sqlsb.append("                  AND CONT_FORM_NO = ?              \n"); ps.addStringParameter(cont_form_no);
	        sqlsb.append("              )                                 \n");
	        rtn = ps.doInsert(sqlsb.toString());

	        ps.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());
	        sqlsb.append(" INSERT INTO SCTMT_FORM ( \n");
	        sqlsb.append("   SEQ     \n");
	        sqlsb.append("  ,SEQ_SEQ    \n");
	        sqlsb.append("  ,CONTENT    \n");
	        sqlsb.append("  ,DEL_FLAG    \n");
	        sqlsb.append("  ,USE_FLAG    \n");
	        sqlsb.append("     )          \n");
	        sqlsb.append("     (          \n");
	        sqlsb.append("   SELECT     \n");
	        sqlsb.append("           ?    \n"); ps.addStringParameter(cnt);
	        sqlsb.append("          ,SEQ_SEQ     \n");
	        sqlsb.append("          ,CONTENT  \n");
	        sqlsb.append("          ,?    \n"); ps.addStringParameter("N");
	        sqlsb.append("          ,?    \n"); ps.addStringParameter("N");
	        sqlsb.append("   FROM   SCTMT_FORM  \n");
	        sqlsb.append("   WHERE  SEQ = ?   \n"); ps.addStringParameter(cont_form_no);
	        sqlsb.append("     )      \n");
	        ps.doInsert(sqlsb.toString());

	        if (rtn == 0) {
	        	setStatus(0);
	        	throw new Exception("SQL Manager is Null");
	        }
	        setStatus(1);
	        Commit();
	    } catch (Exception e) {
	    	try {
	    		Rollback();
	    	} catch (Exception d) {
	    		Logger.err.println(this.info.getSession("ID"), this, d.getMessage());
	    	}

//	    	e.printStackTrace();
	    	Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
	    }
	    return getSepoaOut();
	}	

	public SepoaOut getContractSelect(String cont_no, String cont_form_no, String flag, String cont_gl_seq) {
		
		ConnectionContext ctx = getConnectionContext();
		StringBuffer sqlsb = new StringBuffer();
		
		try {
			setStatus(1);
			setFlag(true);
			
			ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
			
			if( "N".equals(flag) ){
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				
				sqlsb.append("					  SELECT CONTENT					\n ");
				sqlsb.append("					  FROM SCPMT					    \n ");
				sqlsb.append("					  WHERE 1 = 1						\n ");
				sqlsb.append(sm.addFixString("    AND CONT_NO     = ?				\n ")); sm.addStringParameter(cont_no);
				sqlsb.append(sm.addFixString("    AND CONT_GL_SEQ = ?				\n ")); sm.addStringParameter(cont_gl_seq);
				sqlsb.append("		  			  AND NVL(DEL_FLAG, 'N') = 'N'	    \n ");
				sqlsb.append("					  ORDER BY SEQ_SEQ 				    \n ");
				setValue(sm.doSelect(sqlsb.toString()));
				
			}else{
				sm.removeAllValue();
				sqlsb.delete(0, sqlsb.length());
				
				sqlsb.append("		              SELECT CONTENT				\n ");
				sqlsb.append("		              FROM SCTMT_FORM				\n ");
				sqlsb.append("		              WHERE 1 = 1					\n ");
				sqlsb.append(sm.addSelectString(" AND SEQ = ?		            \n ")); sm.addStringParameter(cont_form_no);
				sqlsb.append("		              AND NVL(DEL_FLAG, 'N') = 'N'	\n ");
				sqlsb.append("		              ORDER BY SEQ_SEQ 				\n ");
				setValue(sm.doSelect( sqlsb.toString() ));
			}
			
		} catch (Exception e) {
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		
		return getSepoaOut();
	}
	
	@SuppressWarnings("unchecked")
	public SepoaOut getChkFg(HashMap<String, String> param) throws Exception{ 
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "getChkInfo");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(param); // 조회
			setValue(rtn);
			
			sxp = new SepoaXmlParser(this, "getChkFg");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(param); // 조회
			
			setValue(rtn);
			setMessage("0");
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setFlag(false);
			setMessage("-999");
		}
		
		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut isChked(HashMap<String, String> param) throws Exception{ 
    	ConnectionContext ctx = null;
		SepoaXmlParser    sxp = null;
		SepoaSQLManager   ssm = null;
		String            rtn = null;
		String            id  = info.getSession("ID");
		
		try{
			setStatus(1);
			setFlag(true);
			
			
			ctx = getConnectionContext();
			
			sxp = new SepoaXmlParser(this, "isChked");
			ssm = new SepoaSQLManager(id, this, ctx, sxp);
			
			rtn = ssm.doSelect(param); // 조회
			
			setValue(rtn);
			setMessage("0");
		}
		catch(Exception e) {
			Logger.err.println(userid, this, e.getMessage());
			setStatus(0);
			setFlag(false);
			setMessage("-999");
		}
		
		return getSepoaOut();
    }
	
	@SuppressWarnings("unchecked")
	public SepoaOut setChk(HashMap<String, String> param) throws Exception{ 
		ConnectionContext ctx = getConnectionContext();
	    StringBuffer sqlsb = new StringBuffer();
	    ParamSql ps = new ParamSql(this.info.getSession("ID"), this, ctx);
	    SepoaFormater sf = null;
	   
	    String CONT_NO = param.get("CONT_NO");
	    String CONT_GL_SEQ = param.get("CONT_GL_SEQ");
	    String CHK_COMMENT1 = param.get("CHK_COMMENT1");
	    String CHK_FLAG1 = param.get("CHK_FLAG1");
	    String CHK_COMMENT2 = param.get("CHK_COMMENT2");
	    String CHK_FLAG2 = param.get("CHK_FLAG2");
	    String CHK_COMMENT3 = param.get("CHK_COMMENT3");
	    String CHK_FLAG3 = param.get("CHK_FLAG3");
	    String CHK_COMMENT4 = param.get("CHK_COMMENT4");
	    String CHK_FLAG4 = param.get("CHK_FLAG4");
	    
	    int rtn = 0;
	    try {	    		    	
	    	ps.removeAllValue();
	    	sqlsb.delete(0, sqlsb.length());	    	
	        sqlsb.append("  UPDATE SCPGL                                       \n");
	        sqlsb.append("  SET CHK_DATE = TO_CHAR(SYSDATE,'YYYYMMDD')         \n");
	        sqlsb.append("     ,CHK_TIME = TO_CHAR(SYSDATE,'HH24MISS')         \n");
	        sqlsb.append("     ,CHK_USER_ID = ?                                \n");ps.addStringParameter(this.info.getSession("ID"));
	        sqlsb.append("  WHERE COMPANY_CODE = ?		                       \n");ps.addStringParameter(this.info.getSession("COMPANY_CODE"));
	        sqlsb.append("  AND CONT_NO = ?                                    \n");ps.addStringParameter(CONT_NO);
	        sqlsb.append("  AND CONT_GL_SEQ = ?                                \n");ps.addStringParameter(CONT_GL_SEQ);
	        rtn = ps.doUpdate(sqlsb.toString());
	        if (rtn <= 0) {
	        	setStatus(0);
	        	setFlag(false);
	        	throw new Exception("SQL Manager is Null");
	        }

	        ps.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());
	        sqlsb.append("  DELETE FROM SCCHK                                  \n");
	        sqlsb.append("  WHERE COMPANY_CODE = ?		                       \n");ps.addStringParameter(this.info.getSession("COMPANY_CODE"));
	        sqlsb.append("  AND CONT_NO = ?                                    \n");ps.addStringParameter(CONT_NO);
	        sqlsb.append("  AND CONT_GL_SEQ = ?                                \n");ps.addStringParameter(CONT_GL_SEQ);
	        rtn = ps.doDelete(sqlsb.toString());
	        if (rtn < 0) {
	        	setStatus(0);
	        	setFlag(false);
	        	throw new Exception("SQL Manager is Null");
	        }
	        
	        ps.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());
	        sqlsb.append(" INSERT INTO SCCHK (        \n");
	        sqlsb.append("   COMPANY_CODE             \n");
	        sqlsb.append("  ,CONT_NO                  \n");
	        sqlsb.append("  ,CONT_GL_SEQ              \n");
	        sqlsb.append("  ,CHK_SEQ                  \n");
	        sqlsb.append("  ,CHK_COMMENT              \n");
	        sqlsb.append("  ,CHK_FLAG                 \n");
	        sqlsb.append("  )VALUES(                  \n");
	        sqlsb.append("         ?                  \n"); ps.addStringParameter(this.info.getSession("COMPANY_CODE"));
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_NO);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_GL_SEQ);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter("1");
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_COMMENT1);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_FLAG1);
	        sqlsb.append("     )                      \n");
	        rtn = ps.doInsert(sqlsb.toString());
	        if (rtn <= 0) {
	        	setStatus(0);
	        	setFlag(false);
	        	throw new Exception("SQL Manager is Null");
	        }
	        
	        ps.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());
	        sqlsb.append(" INSERT INTO SCCHK (        \n");
	        sqlsb.append("   COMPANY_CODE             \n");
	        sqlsb.append("  ,CONT_NO                  \n");
	        sqlsb.append("  ,CONT_GL_SEQ              \n");
	        sqlsb.append("  ,CHK_SEQ                  \n");
	        sqlsb.append("  ,CHK_COMMENT              \n");
	        sqlsb.append("  ,CHK_FLAG                 \n");
	        sqlsb.append("  )VALUES(                  \n");
	        sqlsb.append("         ?                  \n"); ps.addStringParameter(this.info.getSession("COMPANY_CODE"));
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_NO);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_GL_SEQ);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter("2");
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_COMMENT2);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_FLAG2);
	        sqlsb.append("     )                      \n");
	        rtn = ps.doInsert(sqlsb.toString());
	        if (rtn <= 0) {
	        	setStatus(0);
	        	setFlag(false);
	        	throw new Exception("SQL Manager is Null");
	        }
	        
	        ps.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());
	        sqlsb.append(" INSERT INTO SCCHK (        \n");
	        sqlsb.append("   COMPANY_CODE             \n");
	        sqlsb.append("  ,CONT_NO                  \n");
	        sqlsb.append("  ,CONT_GL_SEQ              \n");
	        sqlsb.append("  ,CHK_SEQ                  \n");
	        sqlsb.append("  ,CHK_COMMENT              \n");
	        sqlsb.append("  ,CHK_FLAG                 \n");
	        sqlsb.append("  )VALUES(                  \n");
	        sqlsb.append("         ?                  \n"); ps.addStringParameter(this.info.getSession("COMPANY_CODE"));
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_NO);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_GL_SEQ);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter("3");
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_COMMENT3);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_FLAG3);
	        sqlsb.append("     )                      \n");
	        rtn = ps.doInsert(sqlsb.toString());
	        if (rtn <= 0) {
	        	setStatus(0);
	        	setFlag(false);
	        	throw new Exception("SQL Manager is Null");
	        }
	        
	        ps.removeAllValue();
	        sqlsb.delete(0, sqlsb.length());
	        sqlsb.append(" INSERT INTO SCCHK (        \n");
	        sqlsb.append("   COMPANY_CODE             \n");
	        sqlsb.append("  ,CONT_NO                  \n");
	        sqlsb.append("  ,CONT_GL_SEQ              \n");
	        sqlsb.append("  ,CHK_SEQ                  \n");
	        sqlsb.append("  ,CHK_COMMENT              \n");
	        sqlsb.append("  ,CHK_FLAG                 \n");
	        sqlsb.append("  )VALUES(                  \n");
	        sqlsb.append("         ?                  \n"); ps.addStringParameter(this.info.getSession("COMPANY_CODE"));
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_NO);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CONT_GL_SEQ);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter("4");
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_COMMENT4);
	        sqlsb.append("        ,?                  \n"); ps.addStringParameter(CHK_FLAG4);
	        sqlsb.append("     )                      \n");
	        rtn = ps.doInsert(sqlsb.toString());
	        if (rtn <= 0) {
	        	setStatus(0);
	        	setFlag(false);
	        	throw new Exception("SQL Manager is Null");
	        }
	        
	        
	        setStatus(1);
			setFlag(true);
	        Commit();
	    } catch (Exception e) {
	    	try {
	    		Rollback();
	    		setStatus(0);
	        	setFlag(false);
	    	} catch (Exception d) {
	    		Logger.err.println(this.info.getSession("ID"), this, d.getMessage());
	    	}

//	    	e.printStackTrace();
	    	Logger.err.println(this.info.getSession("ID"), this, e.getMessage());
	    }
	    return getSepoaOut();
    }
	
}	
