//TOBE 2017-07-01 재무회계 입지대사 처리
package admin.acc;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.ctc.wstx.util.StringUtil;
import com.ibm.wsdl.util.StringUtils;
import com.tcApi2.JTA45010200;
import com.tcComm2.ONCNF;

public class bs_mgt extends HttpServlet
{
	String globalMode;

	/* TOBE 2017-07-01 총무부 글로벌 상수 */
    String default_gam_jumcd   = sepoa.svc.common.constants.DEFAULT_GAM_JUMCD;
	
	public void init(ServletConfig config) throws ServletException
    {
      Logger.debug.println();
    }
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
  {
    doPost(req, res);
  }
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);
        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        String mode = "";
        PrintWriter out = res.getWriter();


        try
        {
        	String rawData = req.getParameter("WISEGRID_DATA");
            gdReq = OperateGridData.parse(req, res);
            globalMode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            String kor_value = JSPUtil.CheckInjection(gdReq.getParam("kor_value"));
            //조회
            if ("query".equals(mode))
            {
                gdRes = getBsCanList(gdReq, info);
            }
            //BS실행 전문 전송
            else if ("MakeBsPrcMsg".equals(mode))
            {
            	gdRes = SendBsMsg(gdReq, info);
                 
            }
            //Web실행 성공 상태코드  20업데이트
            else if ("UpdatWebPrcStatus".equals(mode))
            {
                gdRes = UpdatWebPrcStatus(gdReq, info);
            }
            //BS실행 취소 메시지 전송
            else if ("MakeBsCanMsg".equals(mode))
            {
              gdRes = SendBsCanMsg(gdReq, info);
            }
            //BS痍⑥냼 寃곌낵  �낅뜲�댄듃  �곹깭肄붾뱶 40
            else if ("UpdatWebCanStatus".equals(mode))
            {
              gdRes = UpdatWebCanStatus(gdReq, info);;
            }
        }
        catch (Exception e)
        {
        	gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
      	    
        }
        finally
        {
            try
            {
                OperateGridData.write(req, res, gdRes, out);
            }
            catch (Exception e)
            {

            	Logger.debug.println();
                         
            }
            gdRes.setMessage("Error: " );
            gdRes.setStatus("false");
        }
    }

  
    
    
    
    
    
    //조회
    public GridData getBsCanList(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
            String exe_dt   = gdReq.getParam("exe_dt").replaceAll("/", "");
            String accd     = gdReq.getParam("accd");
            String trn_stcd = gdReq.getParam("trn_stcd");
            String acct_dt  = gdReq.getParam("acct_dt").replaceAll("/", "");;
            String dl_brcd  = gdReq.getParam("dl_brcd");

            String grid_col_id = gdReq.getParam("grid_col_id");
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            //EJBquery CALL
            Object[] obj = {info, exe_dt, accd, trn_stcd, acct_dt, dl_brcd};
            SepoaOut value = ServiceConnector.doService(info, "p6030", "CONNECTION","getBsCanList", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
              gdRes.setMessage(message.get("MESSAGE.1002").toString());
              gdRes.setStatus("false");
                return gdRes;
            }

            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();

            if (rowCount == 0)
            {
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            for (int i = 0; i < rowCount; i++)
            {
              for(int k=0; k < grid_col_ary.length; k++)
                {
                if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                    gdRes.addValue("SELECTED", "0");
                  } else {
                    gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                  }
                }
            }

        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }

   

  //BS 싫행 취소 전문 전송
    public HashMap tcpJTA45010200(GridData gdReq, SepoaInfo info , String mode ) throws Exception{
        String result       = null;
        String slip_nmgt_dscd = null;                 //�꾪몴梨꾨쾲援щ텇肄붾뱶
        String trn_stcd = null;                       //嫄곕옒�곹깭肄붾뱶
        String bkcd = null;                           //��뻾肄붾뱶
        String trn_evnt_cd = null;                    //嫄곕옒�대깽�몄퐫��
        String main_acc_dscd = null;                  //二쇨퀎�뺢뎄遺꾩퐫��
        String main_accd = null;                      //二쇨퀎�뺢낵紐⑹퐫��
        String uni_cd = null;                         //�⑸룞肄붾뱶
        String fnd_pdcd = null;                       //��뱶�곹뭹肄붾뱶
        String cnsc_sq_no = null;                     //怨듭궗�뚯감踰덊샇
        String trn_rckn_dt = null;                    //嫄곕옒湲곗궛�쇱옄
        String csno = null;                           //怨좉컼踰덊샇
        String bkw_acno = null;                       //�꾪뻾怨꾩쥖踰덊샇
        String pdcd = null;                           //�곹뭹肄붾뱶
        String bdsys_dscd = null;                     //�ъ뾽遺�젣援щ텇肄붾뱶
        String atm_thrw_fd_dscd = null;               //�먮룞�붽린湲고닾�낆옄湲덇뎄遺꾩퐫��
        String trf_am_vrf_yn = null;                  //��껜湲덉븸寃�쬆�щ�
        String nxdt_xch_obc_yn = null;                //�듭씪援먰솚��젏沅뚯뿬遺�
        String plrl_appv_yn = null;                   //蹂듭닔寃곗옱�щ�
        String can_tgt_trn_log_srno = null;           //痍⑥냼��긽嫄곕옒濡쒓렇�쇰젴踰덊샇
        String filler = null;                         //�덈퉬
        String txt_loop_cnt = null;                   //諛섎났遺�“由쎄굔��
        String acct_dt = null;                        //�뚭퀎�쇱옄
        String dl_brcd = null;                        //痍④툒�먯퐫��
        String mng_brcd = null;                       //愿�━�먯퐫��
        String pstn_cct_brcd = null;                  //�ъ��섏쭛以묒젏肄붾뱶
        String ioff_dscd = null;                      //蹂몄��먭뎄遺꾩퐫��
        String acc_dscd = null;                       //怨꾩젙援щ텇肄붾뱶
        String accd = null;                           //怨꾩젙怨쇰ぉ肄붾뱶
        String jrnl_am_tycd = null;                   //遺꾧컻湲덉븸�좏삎肄붾뱶
        String aci_dtl_dscd = null;                   //怨꾩젙怨쇰ぉ�곸꽭援щ텇肄붾뱶
        String adj_jrnl_dscd = null;                  //議곗젙遺꾧컻援щ텇肄붾뱶
        String rap_dscd = null;                       //�낆�湲됯뎄遺꾩퐫��
        String slip_scnt = null;                      //�꾪몴留ㅼ닔
        String cucd = null;                           //�듯솕肄붾뱶
        String trf_krw_am = null;                     //��껜�먰솕湲덉븸
        String cur_krw_am = null;                     //�듯솕�먰솕湲덉븸
        String bchk_krw_am = null;                    //�먭린�욎닔�쒖썝�붽툑��
        String obc_krw_am = null;                     //��젏沅뚯썝�붽툑��
        String trf_fc_am = null;                      //��껜�명솕湲덉븸
        String trf_fc_xc_krw_am = null;               //��껜�명솕�섏궛�먰솕湲덉븸
        String pstn_fc_am = null;                     //�ъ��섏쇅�붽툑��
        String pstn_fc_xc_krw_am = null;              //�ъ��섏쇅�뷀솚�곗썝�붽툑��
        String trn_wtho_sb_rt = null;                 //嫄곕옒��낯�먮ℓ留ㅼ쑉
        String ioff_sb_dscd = null;                   //蹂몄��먮ℓ留ㅺ뎄遺꾩퐫��
        String filler2 = null;                        //�덈퉬�꾨뱶
        String opr_no = null;                         //議곌컖�먮쾲��
        String tdy_pwdt_dscd = null;                  //당일 전일 마감구분
        int    totalListCnt = 0;
        String gate_tot_size    = null;
        String enabler_tot_size = null;
        String data_tot_size    = null;
        HashMap test_return = new HashMap();
        String trn_log_srno= null;
        
        
        
        try{
          int row_count = gdReq.getRowCount();
          String[][] bean_args = new String[row_count][];

          for (int i = 0; i < row_count; i++)
          {
            acct_dt              = gdReq.getValue("ACCT_DT", i).replaceAll("/","");   //회계일자
            accd                 = gdReq.getValue("ACCD", i);      //계정과목코드
            rap_dscd             = gdReq.getValue("RAP_DSCD", i);  //다일전일구분
            trf_krw_am           = gdReq.getValue("TRF_KRW_AM", i).replaceAll(",", "");//금액
            mng_brcd             = gdReq.getValue("MNG_BRCD", i);  //일계점코;드
            opr_no               = gdReq.getValue("OPR_NO", i);     //조작자             
            trn_log_srno = gdReq.getValue("TRN_LOG_SRNO", i);     //거래로그 일련번호
            tdy_pwdt_dscd        = gdReq.getValue("TDY_PVDT_DSCD", i); 
          }

      JTA45010200 n02 = new JTA45010200(); //�꾨Ц�댁슜

      if( mode.equals("MakeBsPrcMsg") )
      {
    	  //전문 전체길이
          gate_tot_size    = String.format("%08d", n02.SEND.sysHdr.iTLen + n02.SEND.trnHdr.iTLen + n02.SEND.iTLen + 2 -8); //시스템 해더 전문길이
          data_tot_size    = String.format("%07d", n02.SEND.iTLen  -10); //데이터부 전문길이
    	  
      }
      else if( mode.equals("MakeBsCanMsg"))
      {
          gate_tot_size    = String.format("%08d", n02.SEND.sysHdr.iTLen + n02.SEND.trnHdr.iTLen + n02.SEND.iTlen2 + 2 -8); // 시스템해더 전문길이
          data_tot_size    = String.format("%07d", n02.SEND.iTlen2  -10); // 데이터부 전문길이
    	  
    	  
      }

        n02.SEND.sysHdr.ALL_TLM_LEN = gate_tot_size;
        n02.SEND.trnHdr.TRM_BRNO   = default_gam_jumcd;       //단발점코드
        n02.SEND.trnHdr.TRN_TRM_NO = "000000000000";          //단말번호
        n02.SEND.trnHdr.DL_BRCD    = default_gam_jumcd;       //취급접코드
        n02.SEND.trnHdr.OPR_NO     =  "8EEPS999";             //조작자
        n02.SEND.DAT_KDCD          = "DTI";                   //데이타헤더부 : (문자3)  데이
        n02.SEND.DAT_LEN           = data_tot_size;           //데이타헤더부 : (숫자7)  데이
        n02.SEND.SLIP_NMGT_DSCD    = "9";                     //전표채번구분코드
        n02.SEND.trnHdr.ACC_MOD_DSCD = tdy_pwdt_dscd;         //당일 전일 마감구분
        

        	
        	
        if ("MakeBsPrcMsg".equals(globalMode))
        {

            n02.SEND.trnHdr.CAN_TRN_DSCD = "N";                                                         //거래해더 취소거래구분코드 실행시 "N"           
        	
        	
        	n02.SEND.TRN_STCD             = "1";                                                        //거래상태코드
            n02.SEND.BKCD                 = " ";                                                        //은행코드
            n02.SEND.TRN_EVNT_CD          = "SGF450102";                                                //거래이벤트코드
            n02.SEND.MAIN_ACC_DSCD        = "10";                                                       //주계정구분코드
            n02.SEND.MAIN_ACCD            = "           ";                                              //주계정과목코드
            n02.SEND.UNI_CD               = "  ";                                                       //합동코드
            n02.SEND.FND_PDCD             = "             ";                                            //펀드상품코드
            n02.SEND.CNSC_SQ_NO           = "         ";                                                //공사회차번호
            n02.SEND.TRN_RCKN_DT          = "        ";                                                 //거래기산일자
            n02.SEND.CSNO                 = "         ";                                                //고객번호
            n02.SEND.BKW_ACNO             = "                    ";                                     //전행계좌번호
            n02.SEND.PDCD                 = "             ";                                            //상품코드
            n02.SEND.BDSYS_DSCD           = "  ";                                                       //사업부제구분코드
            n02.SEND.ATM_THRW_FD_DSCD     = "  ";                                                       //자동화기기투입자금구분코드
            n02.SEND.TRF_AM_VRF_YN        = "N";                                                        //대체금액검증여부
            n02.SEND.NXDT_XCH_OBC_YN      = "N";                                                        //익일교환타점권여부
            n02.SEND.PLRL_APPV_YN         = "N";                                                        //복수결재여부
            n02.SEND.CAN_TGT_TRN_LOG_SRNO = "                                                        "; //취소대상거래로그일련번호
            n02.SEND.FILLER               = "                    ";                                     //예비
            n02.SEND.TXT_LOOP_CNT         = "001";                                                      //반복부조립건수
            n02.SEND.ACCT_DT              = acct_dt;                                                    //회계일자
            n02.SEND.DL_BRCD              = default_gam_jumcd;                                          //취급점코드
            n02.SEND.MNG_BRCD             = mng_brcd;                                                   //관리점코드
            n02.SEND.PSTN_CCT_BRCD        = "      ";                                                   //포지션집중점코드
            n02.SEND.IOFF_DSCD            = "   ";                                                      //본지점구분코드
            n02.SEND.ACC_DSCD             = "10";                                                       //계정구분코드
            n02.SEND.ACCD                 = accd;                                                       //계정과목코드
            n02.SEND.JRNL_AM_TYCD         = "    ";                                                     //분개금액유형코드
            n02.SEND.ACI_DTL_DSCD         = "  ";                                                       //계정과목상세구분코드
            n02.SEND.ADJ_JRNL_DSCD        = " ";                                                        //조정분개구분코드
            n02.SEND.RAP_DSCD             = rap_dscd;                                                   //입지급구분코드
            n02.SEND.SLIP_SCNT            = "000000";                                                   //전표매수
            n02.SEND.CUCD                 = "KRW";                                                      //통화코드
            Logger.sys.println("KIM_TEST :: trf_krw_am[" + trf_krw_am + "]");
            
            
            n02.SEND.TRF_KRW_AM           = String.format("%018d",  Long.parseLong(trf_krw_am));       //대체원화금액            
                       
            Logger.sys.println("KIM_TEST ::  n02.SEND.TRF_KRW_AM[" +  n02.SEND.TRF_KRW_AM + "]");            
            n02.SEND.CUR_KRW_AM           = "000000000000000000";                                       //통화원화금액
            n02.SEND.BCHK_KRW_AM          = "000000000000000000";                                       //자기앞수표원화금액
            n02.SEND.OBC_KRW_AM           = "000000000000000000";                                       //타점권원화금액
            n02.SEND.TRF_FC_AM            = "000000000000000.000";                                      //대체외화금액
            n02.SEND.TRF_FC_XC_KRW_AM     = "000000000000000000";                                       //대체외화환산원화금액
            n02.SEND.PSTN_FC_AM           = "000000000000000.000";                                      //포지션외화금액
            n02.SEND.PSTN_FC_XC_KRW_AM    = "000000000000000000";                                       //포지션외화환산원화금액
            n02.SEND.TRN_WTHO_SB_RT       = "000000.000000";                                            //거래대본점매매율
            n02.SEND.IOFF_SB_DSCD         = " ";                                                        //본지점매매구분코드
            n02.SEND.FILLER2              = "                    ";                                     //예비필드
            
        }
        else if ("MakeBsCanMsg".equals(globalMode))
        {
            n02.SEND.trnHdr.CAN_TRN_DSCD = "C";                                                         //거래해더 취소거래구분코드 실행취소시 "C"           
        	n02.SEND.TRN_STCD             = "2";                                                        //거래상태코드
            n02.SEND.BKCD                 = " ";                                                        //은행코드
            n02.SEND.TRN_EVNT_CD          = "SGF450102";                                                //거래이벤트코드
            n02.SEND.MAIN_ACC_DSCD        = "10";                                                       //주계정구분코드
            n02.SEND.MAIN_ACCD            = "           ";                                              //주계정과목코드
            n02.SEND.UNI_CD               = "  ";                                                       //합동코드
            n02.SEND.FND_PDCD             = "             ";                                            //펀드상품코드
            n02.SEND.CNSC_SQ_NO           = "         ";                                                //공사회차번호
            n02.SEND.TRN_RCKN_DT          = "        ";                                                 //거래기산일자
            n02.SEND.CSNO                 = "         ";                                                //고객번호
            n02.SEND.BKW_ACNO             = "                    ";                                     //전행계좌번호
            n02.SEND.PDCD                 = "             ";                                            //상품코드
            n02.SEND.BDSYS_DSCD           = "  ";                                                       //사업부제구분코드
            n02.SEND.ATM_THRW_FD_DSCD     = "  ";                                                       //자동화기기투입자금구분코드
            n02.SEND.TRF_AM_VRF_YN        = "N";                                                        //대체금액검증여부
            n02.SEND.NXDT_XCH_OBC_YN      = "N";                                                        //익일교환타점권여부
            n02.SEND.PLRL_APPV_YN         = "N";                                                        //복수결재여부
            n02.SEND.CAN_TGT_TRN_LOG_SRNO = trn_log_srno;                                               //취소대상거래로그일련번호
            n02.SEND.FILLER               = "                    ";                                     //예비
            n02.SEND.TXT_LOOP_CNT         = "000";                                                      //반복부조립건수
        }

      Configuration conf = new Configuration();
      String send_ip     = conf.get("sepoa.interface.tcpip.ip");
      int send_port      = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));

      long time = System.currentTimeMillis();
      SimpleDateFormat txt_send_time = new SimpleDateFormat("yyyyMMddHHmmss");    
      String SendTime = txt_send_time.format(time);
      test_return.put("START_TIME", SendTime );          

      int iret = n02.sendMessage("JTA45010200",send_ip,send_port);      //媛쒕컻
      ONCNF.LOGDIR       = conf.get("sepoa.logger.dir");
      if(iret == ONCNF.D_OK) {
        n02.RECV.log(ONCNF.LOGNAME, "");
        
        test_return.put("RESULT"         , "OK"                    );
        test_return.put("SLIP_TRN_DT"    , n02.RECV.SLIP_TRN_DT    );		 
        test_return.put("SLIP_NO"        , n02.RECV.SLIP_NO        );		     
        test_return.put("SLIP_RGS_SRNO"  , n02.RECV.SLIP_RGS_SRNO  ); 
        test_return.put("TRN_LOG_SRNO"   , n02.RECV.TRN_LOG_SRNO   ); 
        test_return.put("REPT_UD_CST_CNT", n02.RECV.REPT_UD_CST_CNT); 
        test_return.put("FX_TRN_LOSS_AM" , n02.RECV.FX_TRN_LOSS_AM ); 
        test_return.put("FX_TRN_PFT_AM"  , n02.RECV.FX_TRN_PFT_AM  ); 
        
        test_return.put("MAIN_MSG_TXT"   , n02.RECV.msgHdr.MAIN_MSG_TXT);
        test_return.put("MSG_CD"         , n02.RECV.msgHdr.MSG_CD );
        
        result = "OK";
      }
      else if(iret == ONCNF.D_ECODE) { /// �꾨Ц�댁슜 �뺤긽 �ㅻ쪟�쇨꼍��...
        n02.eRECV.sysHdr.log();
        n02.eRECV.trnHdr.log();
        n02.eRECV.log(ONCNF.LOGNAME, "");

        test_return.put("RESULT"         , "ERR"                   );
        test_return.put("SLIP_TRN_DT"    , n02.RECV.SLIP_TRN_DT    );		 
        test_return.put("SLIP_NO"        , n02.RECV.SLIP_NO        );		     
        test_return.put("SLIP_RGS_SRNO"  , n02.RECV.SLIP_RGS_SRNO  ); 
        test_return.put("TRN_LOG_SRNO"   , n02.RECV.TRN_LOG_SRNO   ); 
        test_return.put("REPT_UD_CST_CNT", n02.RECV.REPT_UD_CST_CNT); 
        test_return.put("FX_TRN_LOSS_AM" , n02.RECV.FX_TRN_LOSS_AM ); 
        test_return.put("FX_TRN_PFT_AM"  , n02.RECV.FX_TRN_PFT_AM  ); 
        test_return.put("MAIN_MSG_TXT"   , n02.RECV.msgHdr.MAIN_MSG_TXT);
        test_return.put("MSG_CD"         , n02.RECV.msgHdr.MSG_CD );

      
      
      }
      else{
        Logger.err.println("ERR:(JTA45010200)�덉쇅�묐떟��諛쒖깮�섏뿀�듬땲��!!!.." + iret);
        test_return.put("RESULT"         , "ERR");
        test_return.put("SLIP_TRN_DT"    , " "  );		 
        test_return.put("SLIP_NO"        , " "  );		     
        test_return.put("SLIP_RGS_SRNO"  , " "  ); 
        test_return.put("TRN_LOG_SRNO"   , " "  ); 
        test_return.put("REPT_UD_CST_CNT", " "  ); 
        test_return.put("FX_TRN_LOSS_AM" , " "  ); 
        test_return.put("FX_TRN_PFT_AM"  , " "  ); 
        test_return.put("MAIN_MSG_TXT"   , n02.RECV.msgHdr.MAIN_MSG_TXT);
        test_return.put("MSG_CD"         , n02.RECV.msgHdr.MSG_CD );

        
        
      }
    }
    catch(Exception e){
      this.loggerExceptionStackTrace(e);

      test_return.put("RESULT", "ERR");
    }

    long time2 = System.currentTimeMillis();
    SimpleDateFormat txt_recv_time = new SimpleDateFormat("yyyyMMddHHmmss");    
    String RecvTime = txt_recv_time.format(time2);
   	test_return.put("END_TIME", RecvTime);    

    
    
    return test_return;
  }



  
    // WEB�ㅽ뻾 �곹깭�낅뜲�댄듃
    public GridData UpdatWebPrcStatus(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
          gdRes.setSelectable(false);
          //int row_count = gdReq.getHeader("screen_id").getRowCount();
          int row_count = gdReq.getRowCount();
          String[][] bean_args = new String[row_count][];

          for (int i = 0; i < row_count; i++)
          {
              String[] loop_data2 =
              {
                  gdReq.getValue("CC_SRNO", i)  // �쇰젴踰덊샇 議곌굔�쇰줈 �고깭肄붾뱶 �낅뜲�댄듃�쒕떎
              };

              bean_args[i] = loop_data2;
          }

          Object[] obj = {info, bean_args};
          SepoaOut value = ServiceConnector.doService(info, "p6030", "TRANSACTION","UpdatWebPrcStatus", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
              gdRes.setStatus("true");
            }
            else
            {
              gdRes.setMessage(message.get("MESSAGE.1002").toString());
              gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        gdRes.addParam("STEP", "WebPrcEnd");        

        return gdRes;
    }

    //Web�ㅽ뻾痍⑥냼 �곹깭 �낅뜲�댄듃
    public GridData UpdatWebCanStatus(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
          gdRes.setSelectable(false);
          //int row_count = gdReq.getHeader("screen_id").getRowCount();
          int row_count = gdReq.getRowCount();
          String[][] bean_args = new String[row_count][];

          for (int i = 0; i < row_count; i++)
          {
              String[] loop_data2 =
              {
                  gdReq.getValue("CC_SRNO", i)  // �쇰젴踰덊샇 議곌굔�쇰줈 �고깭肄붾뱶 �낅뜲�댄듃�쒕떎
              };

              bean_args[i] = loop_data2;
          }

          Object[] obj = {info, bean_args};
          SepoaOut value = ServiceConnector.doService(info, "p6030", "TRANSACTION","UpdatWebCanStatus", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
              gdRes.setMessage(message.get("MESSAGE.1002").toString());
              gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        
        gdRes.addParam("STEP", "WebCanEnd");        
        //gdRes.addParam("mode", "update");
        return gdRes;
    }


  private void loggerExceptionStackTrace(Exception e){
    String trace = this.getExceptionStackTrace(e);

    Logger.err.println(trace);
  }

  private String getExceptionStackTrace(Exception e){
    Writer      writer      = null;
    PrintWriter printWriter = null;
    String      s           = null;

    writer      = new StringWriter();
    printWriter = new PrintWriter(writer);

    e.printStackTrace(printWriter);

    s = writer.toString();

    return s;
  }

  
  

  private GridData SendBsMsg(GridData gdReq, SepoaInfo info) throws Exception
  {
  GridData gdRes = new GridData();
    Vector multilang_id = new Vector();
    multilang_id.addElement("MESSAGE");
    HashMap message = MessageUtil.getMessage(info,multilang_id);
    SepoaOut value = null;
    String              gdResMessage = null;
    String cc_srno = null;
    HashMap ret ;
    gdRes.setSelectable(false);
    int row_count = gdReq.getRowCount();
    String[][] bean_args = new String[row_count][];
    String          infNo           = null;
    int i;
	 String house_code      = null;
	 String inf_no          = null;
	 String inf_type        = null;
	 String inf_code        = null;
	 String inf_date        = null;
	 String inf_start_time  = null;
	 String inf_end_time    = null;
	 String inf_status      = null;
	 String inf_reason      = null;
	 String inf_send        = null;
	 String inf_id          = null;
	 String inf_receive_no  = null;
	 String old_inf_code    = null;
    
     String TXTSendTime = null;
     String TXTEndTime = null;
    try
    {
    	ret = this.tcpJTA45010200( gdReq, info , globalMode );
        //전문 전송시 SINFHD 로그를 남긴다
        TXTSendTime = (String) ret.get("START_TIME");
        TXTEndTime  = (String) ret.get("END_TIME");
        
  	    house_code = info.getSession("HOUSE_CODE");    

  	    
  	    
  	    
  	    inf_type = "T";       

  	    inf_date =  TXTSendTime.substring(0,8);
  	    inf_start_time =  TXTSendTime.substring(8,13);
  	    inf_end_time  = TXTEndTime.substring(8,13);
  	    //실패일경우
  	    if ( "ERR".equals(ret.get("RESULT")))
        {
  	  	    inf_code = "tcpJTA45010200Y";       
  	    	inf_status = "N";       	    	
  	  	    inf_reason = (String) ret.get("MAIN_MSG_TXT");    
  	  	    gdRes.addParam("MAIN_MSG_TXT", inf_reason);
        }
  	    else if ( "OK".equals(ret.get("RESULT")))
  	    {
  	  	    inf_code = "tcpJTA45010200N";         	    	
  	  	    inf_status = "Y";       	    	
  	  	    inf_reason = "";     
  	    	
  	    }
  	    inf_send = "S";       
  	    inf_id =   info.getSession("ID");       
  	    inf_receive_no  = (String) ret.get("MSG_CD");
  	    old_inf_code = "";   
        
        String [] SINFHD_DATA = {
       	     house_code     
       	     ,inf_no         
       	     ,inf_type       
       	     ,inf_code       
       	     ,inf_date       
       	     ,inf_start_time 
       	     ,inf_end_time   
       	     ,inf_status     
       	     ,inf_reason     
       	     ,inf_send       
       	     ,inf_id         
       	     ,inf_receive_no 
       	     ,old_inf_code   
        };
        bean_args[0] = SINFHD_DATA;
        Object[] objlog = {info, bean_args};
        value = ServiceConnector.doService(info, "p6030", "TRANSACTION","LogInsertSINFHD", objlog);
        if(value.flag)
        {
           gdRes.setMessage(message.get("MESSAGE.0001").toString());
           gdRes.setStatus("false");
        }
        else
        {
           gdRes.setMessage(message.get("MESSAGE.1002").toString());
           gdRes.setStatus("false");
        }
        
        if ( "ERR".equals(ret.get("RESULT")))
        {
          String[] rtn = null;
            for ( i = 0; i < row_count; i++)
            {
                cc_srno = gdReq.getValue("CC_SRNO", i);
            }
            //최초전송 채번안된 로우가 나감
            if ( cc_srno != null && cc_srno.equals("XXXXX") )
            {
                for ( i = 0; i < row_count; i++)
                {

                  String[] loop_data1 ={
                          gdReq.getValue("BIZ_DIS"   , i),
                          gdReq.getValue("PRC_DT"    , i),
                          gdReq.getValue("EPS_STCD"  , i),
                          gdReq.getValue("ACCT_DT"   , i),
                          gdReq.getValue("DL_BRCD"   , i),
                          gdReq.getValue("MNG_BRCD"  , i),
                          gdReq.getValue("ACCD"      , i),
                          gdReq.getValue("RAP_DSCD"  , i),
                          gdReq.getValue("TRF_KRW_AM", i).replaceAll(",", ""),
                          gdReq.getValue("TDY_PVDT_DSCD", i),
                          (String) ret.get("SLIP_TRN_DT"),
                          (String) ret.get("SLIP_NO"),
                          (String) ret.get("SLIP_RGS_SRNO"),
                          (String) ret.get("TRN_LOG_SRNO"),
                          (String) ret.get("FX_TRN_LOSS_AM"),
                          (String) ret.get("FX_TRN_PFT_AM"),
                          gdReq.getValue("MNG_BRNM", i)
                          
                  };
                  bean_args[i] = loop_data1;
                }

                Object[] obj = {info, bean_args};
                
                Logger.sys.println("TRF_KRW_AM[" + gdReq.getValue("TRF_KRW_AM", i).replaceAll(",", "") +"]");
                value = ServiceConnector.doService(info, "p6030", "TRANSACTION","InsertBsPrcStatusF", obj);
                if(value.flag)
                {
                   gdRes.setMessage(message.get("MESSAGE.0001").toString());
                   gdRes.setStatus("false");
                }
                else
                {
                   gdRes.setMessage(message.get("MESSAGE.1002").toString());
                   gdRes.setStatus("false");
                }
                gdRes.addParam("STEP", "BsPrcSndErr");
            }
            //전송실패한 로우를 다시 전송하였을 경우 업데이트
            else
            {
                for ( i = 0; i < row_count; i++)
                {
                  String[] loop_data1 ={
                          gdReq.getValue("BIZ_DIS"   , i),
                          gdReq.getValue("PRC_DT"    , i).replaceAll("/", ""),
                          gdReq.getValue("EPS_STCD"  , i),
                          gdReq.getValue("ACCT_DT"   , i).replaceAll("/", ""),
                          gdReq.getValue("DL_BRCD"   , i),
                          gdReq.getValue("MNG_BRCD"  , i),
                          gdReq.getValue("ACCD"      , i),
                          gdReq.getValue("RAP_DSCD"  , i),
                          gdReq.getValue("TRF_KRW_AM", i).replaceAll(",", ""),
                          gdReq.getValue("TDY_PVDT_DSCD", i),
                		  (String) ret.get("SLIP_TRN_DT"),
                          (String) ret.get("SLIP_NO"),
                          (String) ret.get("SLIP_RGS_SRNO"),
                          (String) ret.get("TRN_LOG_SRNO"),
                          (String) ret.get("FX_TRN_LOSS_AM"),
                          (String) ret.get("FX_TRN_PFT_AM"),
                          cc_srno
                  };
                  bean_args[i] = loop_data1;
                }

                Object[] obj = {info, bean_args};
                value = ServiceConnector.doService(info, "p6030", "TRANSACTION","UpdateBsPrcStatusF", obj);
                if(value.flag)
                {
                   gdRes.setMessage(message.get("MESSAGE.0001").toString());
                   gdRes.setStatus("false");
                }
                else
                {
                   gdRes.setMessage(message.get("MESSAGE.1002").toString());
                   gdRes.setStatus("false");
                }
                gdRes.addParam("STEP", "BsPrcSndErr");

            }

        }
        //정상정문수신 시 인서트 업데이트
        else if ( "OK".equals(ret.get("RESULT")))
        {
            for ( i = 0; i < row_count; i++)
            {
                cc_srno = gdReq.getValue("CC_SRNO", i);
            };
            //최초전송 성공시 인서트
            if ( cc_srno != null && cc_srno.equals("XXXXX") )
            {
                for ( i = 0; i < row_count; i++)
                {
                  String[] loop_data1 ={
                          gdReq.getValue("BIZ_DIS"   , i),
                          gdReq.getValue("PRC_DT"    , i).replaceAll("/", ""),
                          gdReq.getValue("ACCT_DT"   , i).replaceAll("/", ""),
                          gdReq.getValue("DL_BRCD"   , i),
                          gdReq.getValue("MNG_BRCD"  , i),
                          gdReq.getValue("ACCD"      , i),
                          gdReq.getValue("RAP_DSCD"  , i),
                          gdReq.getValue("TRF_KRW_AM", i).replaceAll(",", ""),
                          gdReq.getValue("TDY_PVDT_DSCD", i),
                          (String) ret.get("SLIP_TRN_DT"),
                          (String) ret.get("SLIP_NO"),
                          (String) ret.get("SLIP_RGS_SRNO"),
                          (String) ret.get("TRN_LOG_SRNO"),
                          (String) ret.get("FX_TRN_LOSS_AM"),
                          (String) ret.get("FX_TRN_PFT_AM"),
                           gdReq.getValue("MNG_BRNM", i)
                  };
                  bean_args[i] = loop_data1;
                }
                Object[] obj = {info, bean_args};
                value = ServiceConnector.doService(info, "p6030", "TRANSACTION","InsertBsPrcStatus", obj);
                if(value.flag)
                {
                   gdRes.setMessage(message.get("MESSAGE.0001").toString());
                   gdRes.setStatus("false");
                }
                else
                {
                   gdRes.setMessage(message.get("MESSAGE.1002").toString());
                   gdRes.setStatus("false");
                }
                gdRes.addParam("STEP", "BsPrcSndOK");

            }
            else
            {
                for ( i = 0; i < row_count; i++)
                {
                  String[] loop_data1 ={
                              gdReq.getValue("BIZ_DIS"   , i),
                              gdReq.getValue("PRC_DT"    , i).replaceAll("/", ""),
                              gdReq.getValue("ACCT_DT"   , i).replaceAll("/", ""),
                              gdReq.getValue("DL_BRCD"   , i),
                              gdReq.getValue("MNG_BRCD"  , i),
                              gdReq.getValue("ACCD"      , i),
                              gdReq.getValue("RAP_DSCD"  , i),
                              gdReq.getValue("TRF_KRW_AM", i).replaceAll(",", ""),
                              gdReq.getValue("TDY_PVDT_DSCD", i),
                		      (String) ret.get("SLIP_TRN_DT"),
                              (String) ret.get("SLIP_NO"),
                              (String) ret.get("SLIP_RGS_SRNO"),
                              (String) ret.get("TRN_LOG_SRNO"),
                              (String) ret.get("FX_TRN_LOSS_AM"),
                              (String) ret.get("FX_TRN_PFT_AM"),
                              cc_srno
                     };
                    bean_args[i] = loop_data1;
                }
                Object[] obj = {info, bean_args};
                value = ServiceConnector.doService(info, "p6030", "TRANSACTION","UpdateBsPrcStatus", obj);
                if(value.flag)
                {
                   gdRes.setMessage(message.get("MESSAGE.0001").toString());
                   gdRes.setStatus("false");
                }
                else
                {
                   gdRes.setMessage(message.get("MESSAGE.1002").toString());
                   gdRes.setStatus("false");
                }
                gdRes.addParam("STEP", "BsPrcSndOK");
            }
        }
    
    }catch(Exception e){
        gdRes.setMessage(message.get("MESSAGE.1002").toString());
        gdRes.setStatus("false");


    }
    return gdRes;
}
  //BS痍⑥냼 嫄곕옒
  private GridData SendBsCanMsg(GridData gdReq, SepoaInfo info) throws Exception
  {

	  GridData gdRes = new GridData();
      Vector multilang_id = new Vector();
      multilang_id.addElement("MESSAGE");
      HashMap message = MessageUtil.getMessage(info,multilang_id);
      SepoaOut value = null;
      String gdResMessage = null;
      HashMap ret  ;
      gdRes.setSelectable(false);
      int row_count = gdReq.getRowCount();
      String[][] bean_args = new String[row_count][];
      int i;

      
      String          infNo           = null;
  	 String house_code      = null;
  	 String inf_no          = null;
  	 String inf_type        = null;
  	 String inf_code        = null;
  	 String inf_date        = null;
  	 String inf_start_time  = null;
  	 String inf_end_time    = null;
  	 String inf_status      = null;
  	 String inf_reason      = null;
  	 String inf_send        = null;
  	 String inf_id          = null;
  	 String inf_receive_no  = null;
  	 String old_inf_code    = null;
      
       String TXTSendTime = null;
       String TXTEndTime = null;      
      
      
      
      
      
      
      try
    {
        ret = this.tcpJTA45010200( gdReq, info , globalMode);

        //전문 전송시 SINFHD 로그를 남긴다
        TXTSendTime = (String) ret.get("START_TIME");
        TXTEndTime  = (String) ret.get("END_TIME");
        
  	    house_code = info.getSession("HOUSE_CODE");    
  	    inf_type = "T";       

  	    inf_date =  TXTSendTime.substring(0,8);
  	    inf_start_time =  TXTSendTime.substring(8,14);
  	    inf_end_time  = TXTEndTime.substring(8,14);
        
  	    //실패일경우
  	    if ( "ERR".equals(ret.get("RESULT")))
        {
  	  	    inf_code = "tcpJTA45010200Y";       
  	    	inf_status = "N";       	    	
  	  	    inf_reason = (String) ret.get("MAIN_MSG_TXT");    
        }
  	    else if ( "OK".equals(ret.get("RESULT")))
  	    {
  	  	    inf_code = "tcpJTA45010200N";         	    	
  	  	    inf_status = "Y";       	    	
  	  	    inf_reason = "";     
  	    	
  	    }
  	    inf_send = "S";       
  	    inf_id =   info.getSession("ID");       
  	    inf_receive_no  = (String) ret.get("MSG_CD");
  	    old_inf_code = "";   
        
        String [] SINFHD_DATA = {
       	     house_code     
       	     ,inf_no         
       	     ,inf_type       
       	     ,inf_code       
       	     ,inf_date       
       	     ,inf_start_time 
       	     ,inf_end_time   
       	     ,inf_status     
       	     ,inf_reason     
       	     ,inf_send       
       	     ,inf_id         
       	     ,inf_receive_no 
       	     ,old_inf_code   
        };
        bean_args[0] = SINFHD_DATA;
        Object[] objlog = {info, bean_args};
        value = ServiceConnector.doService(info, "p6030", "TRANSACTION","LogInsertSINFHD", objlog);        
        if(value.flag)
        {
           gdRes.setMessage(message.get("MESSAGE.0001").toString());
           gdRes.setStatus("false");
        }
        else
        {
           gdRes.setMessage(message.get("MESSAGE.1002").toString());
           gdRes.setStatus("false");
        }        
        if ( "ERR".equals(ret.get("RESULT")))
        {
            for ( i = 0; i < row_count; i++)
            {
              String[] loop_data1 ={
                      gdReq.getValue("CC_SRNO", i)  // �쇰젴踰덊샇 議곌굔�쇰줈 �고깭肄붾뱶 �낅뜲�댄듃�쒕떎
                      ,gdReq.getValue("EPS_STCD", i)  //
              };
              bean_args[i] = loop_data1;
            }
            Object[] obj = {info, bean_args};
            value = ServiceConnector.doService(info, "p6030", "TRANSACTION","UpdatBsCanStatus", obj);
            if(value.flag)
            {
               gdRes.setMessage(message.get("MESSAGE.0001").toString());
               gdRes.setStatus("false");
            }
            else
            {
               gdRes.setMessage(message.get("MESSAGE.1002").toString());
               gdRes.setStatus("false");
            }
            gdRes.addParam("STEP", "BsCanSndErr");        
        }
        //�꾩넚寃곌낵媛��깃났�대㈃ �곹깭肄붾뱶瑜�30�쇰줈 �낅뜲�댄듃
        else if ( "OK".equals(ret.get("RESULT")))
        {
            for ( i = 0; i < row_count; i++)
            {
              String[] loop_data1 ={
                      gdReq.getValue("CC_SRNO", i)  // �쇰젴踰덊샇 議곌굔�쇰줈 �고깭肄붾뱶 �낅뜲�댄듃�쒕떎
                      ,"30"
              };
              bean_args[i] = loop_data1;
            }
            Object[] obj = {info, bean_args};
            value = ServiceConnector.doService(info, "p6030", "TRANSACTION","UpdatBsCanStatus", obj);
            if(value.flag)
            {
               gdRes.setMessage(message.get("MESSAGE.0001").toString());
               gdRes.setStatus("false");
            }
            else
            {
               gdRes.setMessage(message.get("MESSAGE.1002").toString());
               gdRes.setStatus("false");
            }

            gdRes.addParam("STEP", "BsCanSndOK");                
        
        }

        
        //gdRes.addParam("mode", "update");

    }
    catch(Exception e){
        gdRes.setMessage(message.get("MESSAGE.1002").toString());
        gdRes.setStatus("false");
    }
    return gdRes;
  }
  

  
}
