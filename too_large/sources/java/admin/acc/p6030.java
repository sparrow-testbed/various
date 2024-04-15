//TOBE 2017-07-01 재무회계 입지대사 처리
package admin.acc;
import java.util.Map;
import java.util.Vector;






import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
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

public class p6030 extends SepoaService
{
	private String ID = info.getSession("ID");

	public p6030(String opt, SepoaInfo info) throws SepoaServiceException
	{
		super(opt, info);
		setVersion("1.0.0");
	}

	
	  private String getInfNo() throws Exception{
			SepoaOut wo     = DocumentUtil.getDocNumber(info, "RFC");
			String   result = wo.result[0];
			
			return result;
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
    //-----------------------------------------------------------
	// 함수명 : getBsCanList
	// 설명  : 화면 조회
	//-----------------------------------------------------------
	public SepoaOut getBsCanList(SepoaInfo info,  String exe_dt, String accd, String trn_stcd, String acct_dt, String dl_brcd)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_getBsCanList(info,  exe_dt, accd, trn_stcd, acct_dt, dl_brcd);

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

	private String[] et_getBsCanList(SepoaInfo info,  String exe_dt, String accd, String trn_stcd, String acct_dt, String dl_brcd) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();

		try
		{
        	SepoaXmlParser sxp = new SepoaXmlParser();
        	SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
        	
        	String[] args = new String[]{exe_dt, accd, trn_stcd, acct_dt, dl_brcd};
			rtn[0] = ssm.doSelect(args);

		
		}
		catch (Exception e)
		{
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	}

    //-----------------------------------------------------------
	// 함수명 : InsertBsPrcStatus
	// 설명  : BS실행 정상 (최초 실행시) insert
	//-----------------------------------------------------------
	public SepoaOut InsertBsPrcStatus(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_InsertBsPrcStatus(info, bean_args);

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

	private String[] et_InsertBsPrcStatus(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();

		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String biz_dis        = bean_info[i][0];
				String prc_dt         = bean_info[i][1].replaceAll("/", "");
				String acct_dt        = bean_info[i][2].replaceAll("/", "");
				String dl_brcd        = bean_info[i][3];
				String mng_brcd       = bean_info[i][4];
				String accd           = bean_info[i][5];
                String rap_dscd       = bean_info[i][6];
                String trf_krw_am     = bean_info[i][7].replaceAll(",", "");                     
                String tdy_pvdt_dscd  = bean_info[i][8];
                String slip_trn_dt    = bean_info[i][9];
                String slip_no        = bean_info[i][10];
                String slip_rgs_srno  = bean_info[i][11];
                String trn_log_srno   = bean_info[i][12];
                String fx_trn_loss_am = bean_info[i][13];
                String fx_trn_pft_am  = bean_info[i][14];
                String eps_stcd       = "10";
                String mng_brnm       = bean_info[i][15];
                
                String[] args = new String[]{ 
                		biz_dis
                		,prc_dt
                		,acct_dt
                		,dl_brcd
                		,mng_brcd
                		,accd
                		,rap_dscd
                		,trf_krw_am
                		,tdy_pvdt_dscd
                		,slip_trn_dt
                		,slip_no
                		,slip_rgs_srno
                		,trn_log_srno
                		,fx_trn_loss_am
                		,fx_trn_pft_am
                		,eps_stcd
                		,mng_brnm
				};

				String[] types = new String[]{
						"S","S","S","S","S"
					   ,"S","S","S","S","S"
					   ,"S","S","S","S","S"
					   ,"S","S"
					   };
				 


				SepoaXmlParser sxp = new SepoaXmlParser(this, "et_InsertBsPrcStatus");
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                ssm.doInsert(new String[][]{args}, types);				
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	}

	
    //-----------------------------------------------------------
	// 함수명 : InsertBsPrcStatusF
	// 설명  : BS실행 실패시 (최초 실행시) insert
	//-----------------------------------------------------------
	
	public SepoaOut InsertBsPrcStatusF(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_InsertBsPrcStatusF(info, bean_args);

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

	private String[] et_InsertBsPrcStatusF(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();

		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
		        String biz_dis            = bean_info[i][0];
		        String prc_dt             = bean_info[i][1].replaceAll("/", "");
		        String eps_stcd           = "00";
		        String acct_dt            = bean_info[i][3].replaceAll("/", "");
		        String dl_brcd            = bean_info[i][4];
		        String mng_brcd           = bean_info[i][5];
		        String accd               = bean_info[i][6];
		        String rap_dscd           = bean_info[i][7];
		        String trf_krw_am         = bean_info[i][8].replaceAll(",", "");
		        Logger.sys.println("trf_krw_am[" + trf_krw_am +"]");
		        String tdy_pvdt_dscd      = bean_info[i][9];
		        String slip_trn_dt        = bean_info[i][10];
		        String slip_no            = bean_info[i][11];
		        String slip_rgs_srno      = bean_info[i][12];
		        String trn_log_srno       = bean_info[i][13];
		        String fx_trn_loss_am     = bean_info[i][14];
		        String fx_trn_pft_am      = bean_info[i][15];			
		        String mng_brnm           = bean_info[i][16];
		        String[] args = new String[]{ 
						biz_dis
						,prc_dt
						,eps_stcd
						,acct_dt
						,dl_brcd
						,mng_brcd
						,accd
						,rap_dscd
						,trf_krw_am
						,tdy_pvdt_dscd
						,slip_trn_dt
						,slip_no
						,slip_rgs_srno
						,trn_log_srno
						,fx_trn_loss_am
						,fx_trn_pft_am
						,mng_brnm
				};
	        	
	        	String[] types = new String[]{"S","S","S","S","S"
						,"S","S","S","S","S"
						,"S","S","S","S","S"
						,"S","S"};

				SepoaXmlParser sxp = new SepoaXmlParser(this, "et_InsertBsPrcStatusF");
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
                ssm.doInsert(new String[][]{args}, types);				
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //
	

	
    //-----------------------------------------------------------
	// 함수명 : UpdateBsPrcStatusF
	// 설명  : BS실행 실패시 UPDATE (화면 조회후 BS실행 재전송)
	//-----------------------------------------------------------
	  public SepoaOut UpdateBsPrcStatusF(SepoaInfo info, String[][] bean_args)
	  {
	    try
	    {
	      String[] rtn = null;
	      setStatus(1);
	      setFlag(true);

	      rtn = et_UpdateBsPrcStatusF(info, bean_args);

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

	    private String[] et_UpdateBsPrcStatusF(SepoaInfo info, String[][] bean_info) throws Exception
	    {
	      String[] rtn = new String[2];
	      ConnectionContext ctx = getConnectionContext();
	      try
	      {
	        int cnt = 0;
	        SepoaFormater sf = null;

	        for (int i = 0; i < bean_info.length; i++)
	        {

                  String biz_dis        = bean_info[i][0];
                  String prc_dt         = bean_info[i][1];
                  String eps_stcd       = bean_info[i][2];
                  String acct_dt        = bean_info[i][3];
                  String dl_brcd        = bean_info[i][4];
                  String mng_brcd       = bean_info[i][5];
                  String accd           = bean_info[i][6];
                  String rap_dscd       = bean_info[i][7];
                  String trf_krw_am     = bean_info[i][8].replaceAll(",", "");
                  String tdy_pvdt_dscd  = bean_info[i][9];
	        	  String slip_trn_dt    = bean_info[i][10];
	              String slip_no        = bean_info[i][11];
	              String slip_rgs_srno  = bean_info[i][12];
	              String trn_log_srno   = bean_info[i][13];
	              String fx_trn_loss_am = bean_info[i][14];
	              String fx_trn_pft_am  = bean_info[i][15];
	              String cc_srno        = bean_info[i][16];
	              
	              
	              
	              String[] args = new String[]{
	                      biz_dis
	                      ,prc_dt
	                      ,eps_stcd
	                      ,acct_dt
	                      ,dl_brcd
	                      ,mng_brcd
	                      ,accd
	                      ,rap_dscd
	                      ,trf_krw_am
	                      ,tdy_pvdt_dscd
	                      ,slip_trn_dt
	                      ,slip_no
	                      ,slip_rgs_srno
	                      ,trn_log_srno
	                      ,fx_trn_loss_am
	                      ,fx_trn_pft_am
	                      ,cc_srno
	          };
	          String[] types = new String[]{"S","S","S","S","S"
	        		  ,"S","S","S","S","S"
	        		  ,"S","S","S","S","S"
	              ,"S","S"};
	          SepoaXmlParser sxp = new SepoaXmlParser(this, "et_UpdateBsPrcStatusF");
	          SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
	          ssm.doInsert(new String[][]{args}, types);
	        }
	        Commit();
	      }
	      catch (Exception e)
	      {
	        Rollback();
	        rtn[1] = e.getMessage();

	        Logger.debug.println(ID, this, e.getMessage());
	      }
	      finally
	      {
	      }
	      return rtn;
	    }

	
	    //-----------------------------------------------------------
		// 함수명 : UpdatBsCanStatus
		// 설명  : BS실행 취소 성공 UPDATE (BS 취소 처리 처리상태 30)
		//-----------------------------------------------------------
		public SepoaOut UpdatBsCanStatus(SepoaInfo info, String[][] bean_args)
		{
			try
			{
				String[] rtn = null;
				setStatus(1);
				setFlag(true);

				rtn = et_UpdatBsCanStatus(info, bean_args);

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

		private String[] et_UpdatBsCanStatus(SepoaInfo info, String[][] bean_info) throws Exception
		{
			String[] rtn = new String[2];
			ConnectionContext ctx = getConnectionContext();
			try
			{
				int cnt = 0;
				SepoaFormater sf = null;

				for (int i = 0; i < bean_info.length; i++)
				{
					String cc_srno               = bean_info[i][0 ];
					String eps_stcd              = bean_info[i][1 ];
					
					String[] args = new String[]{ 
				            eps_stcd, cc_srno
					};

					String[] types = new String[]{"S","S"};

					SepoaXmlParser sxp = new SepoaXmlParser(this, "et_UpdatBsCanStatus");
					SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
					ssm.doUpdate(new String[][]{args}, types);				
	                
				}

				Commit();
			}
			catch (Exception e)
			{
				Rollback();
				rtn[1] = e.getMessage();
				
				Logger.debug.println(ID, this, e.getMessage());
			}
			finally
			{
			}

			return rtn;
		} //
	
	public SepoaOut UpdatWebPrcStatus(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_UpdatWebPrcStatus(info, bean_args);

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
    //웹처리가 완료되면 해당 값은 20으로 업데이트한다
	private String[] et_UpdatWebPrcStatus(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String cc_srno               = bean_info[i][0 ];
				String eps_stcd              = "20";
				
				String[] args = new String[]{ 
			            eps_stcd, cc_srno
				};

				String[] types = new String[]{"S","S"};

				SepoaXmlParser sxp = new SepoaXmlParser(this, "et_UpdatWebPrcStatus");
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
				ssm.doUpdate(new String[][]{args}, types);				
                
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //




	
	//웹처리가 완료되면 해당 값은 40으로 업데이트한다	
	public SepoaOut UpdatWebCanStatus(SepoaInfo info, String[][] bean_args)
	{
		try
		{
			String[] rtn = null;
			setStatus(1);
			setFlag(true);

			rtn = et_UpdatWebCanStatus(info, bean_args);

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
    
	private String[] et_UpdatWebCanStatus(SepoaInfo info, String[][] bean_info) throws Exception
	{
		String[] rtn = new String[2];
		ConnectionContext ctx = getConnectionContext();
		try
		{
			int cnt = 0;
			SepoaFormater sf = null;

			for (int i = 0; i < bean_info.length; i++)
			{
				String cc_srno               = bean_info[i][0 ];
				String eps_stcd              = "40";
				
				String[] args = new String[]{ 
			            eps_stcd, cc_srno
				};

				String[] types = new String[]{"S","S"};

				SepoaXmlParser sxp = new SepoaXmlParser(this, "et_UpdatWebCanStatus");
				SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
				ssm.doUpdate(new String[][]{args}, types);				
                
			}

			Commit();
		}
		catch (Exception e)
		{
			Rollback();
			rtn[1] = e.getMessage();
			
			Logger.debug.println(ID, this, e.getMessage());
		}
		finally
		{
		}

		return rtn;
	} //		
	




	  
	  
	  //-----------------------------------------------------------
		// 함수명 : UpdateBsPrcStatus
		// 설명  : BS실행 성공  UPDATE (화면 조회후 BS실행 재전송)
		//-----------------------------------------------------------
		  public SepoaOut UpdateBsPrcStatus(SepoaInfo info, String[][] bean_args)
		  {
		    try
		    {
		      String[] rtn = null;
		      setStatus(1);
		      setFlag(true);

		      rtn = et_UpdateBsPrcStatus(info, bean_args);

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


		  private String[] et_UpdateBsPrcStatus(SepoaInfo info, String[][] bean_info) throws Exception
		  {
		    String[] rtn = new String[2];
		    ConnectionContext ctx = getConnectionContext();
		    try
		    {
		      int cnt = 0;
		      SepoaFormater sf = null;

		      for (int i = 0; i < bean_info.length; i++)
			      {

                    String biz_dis        = bean_info[i][0];
                    String prc_dt         = bean_info[i][1];
                    String acct_dt        = bean_info[i][2];
                    String dl_brcd        = bean_info[i][3];
                    String mng_brcd       = bean_info[i][4];
                    String accd           = bean_info[i][5];
                    String rap_dscd       = bean_info[i][6];
                    String trf_krw_am     = bean_info[i][7].replaceAll(",", "");
                    String tdy_pvdt_dscd  = bean_info[i][8];
                    String slip_trn_dt    = bean_info[i][9];
                    String slip_no        = bean_info[i][10];
		            String slip_rgs_srno  = bean_info[i][11];
		            String trn_log_srno   = bean_info[i][12];
		            String fx_trn_loss_am = bean_info[i][13];
		            String fx_trn_pft_am  = bean_info[i][14];
		            String cc_srno        = bean_info[i][15];
		            String[] args = new String[]{
		            		biz_dis
		            		,prc_dt
		            		,acct_dt
		            		,dl_brcd
		            		,mng_brcd
		            		,accd
		            		,rap_dscd
		            		,trf_krw_am
		            		,tdy_pvdt_dscd
		            		,slip_trn_dt
		            		,slip_no
		            		,slip_rgs_srno
		            		,trn_log_srno
		            		,fx_trn_loss_am
		            		,fx_trn_pft_am
		            		,cc_srno

		        };
		        String[] types = new String[]{ "S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
		        		,"S"
                };
		        SepoaXmlParser sxp = new SepoaXmlParser(this, "et_UpdateBsPrcStatus");
		        SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
		        ssm.doInsert(new String[][]{args}, types);
		      }
		      Commit();
		    }
		    catch (Exception e)
		    {
		      Rollback();
		      rtn[1] = e.getMessage();

		      Logger.debug.println(ID, this, e.getMessage());
		    }
		    finally
		    {
		    }
		    return rtn;
		  }
		    //-----------------------------------------------------------
		  // 함수명 : LogInsertSINFHD
		  // 설명  : SINFHD 로그  insert
		  //-----------------------------------------------------------
		  public SepoaOut LogInsertSINFHD(SepoaInfo info, String[][] bean_args)
		  {
		    try
		    {
		      String[] rtn = null;
		      setStatus(1);
		      setFlag(true);

		      rtn = et_LogInsertSINFHD(info, bean_args);

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

		  private String[] et_LogInsertSINFHD(SepoaInfo info, String[][] bean_info) throws Exception
		  {
		    String[] rtn = new String[2];
		    ConnectionContext ctx = getConnectionContext();

		    try
		    {
		      int cnt = 0;
		      SepoaFormater sf = null;

		      for (int i = 0; i < bean_info.length; i++)
		      {
		        String house_code      = bean_info[i][0];    //VARCHAR(10 BYTE),
		        String inf_no          = this.getInfNo();    //VARCHAR(20 BYTE),
		        String inf_type        = bean_info[i][2];    //VARCHAR(1 BYTE),
		        String inf_code        = bean_info[i][3];    //VARCHAR(20 BYTE),
		        String inf_date        = bean_info[i][4];    //VARCHAR(8 BYTE),
		        String inf_start_time  = bean_info[i][5];    //VARCHAR(8 BYTE),
		        String inf_end_time    = bean_info[i][6];    //VARCHAR(8 BYTE),
		        String inf_status      = bean_info[i][7];    //VARCHAR(1 BYTE),
		        String inf_reason      = bean_info[i][8];    //VARCHAR(4000 BYTE),
		        String inf_send        = bean_info[i][9];    //VARCHAR(1 BYTE),
		        String inf_id          = bean_info[i][10];   //VARCHAR(8 BYTE),
		        String inf_receive_no  = bean_info[i][11];   //VARCHAR(15 BYTE),
		        String old_inf_code    = bean_info[i][12];   //VARCHAR(10 BYTE)

		        String[] args = new String[]{
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

		        String[] types = new String[]{
		                     "S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		                    ,"S"
		             };
		        SepoaXmlParser sxp = new SepoaXmlParser(this, "et_LogInsertSINFHD");
		        SepoaSQLManager ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp.getQuery());
		                ssm.doInsert(new String[][]{args}, types);
		      }

		      Commit();
		    }
		    catch (Exception e)
		    {
		      Rollback();
		      rtn[1] = e.getMessage();

		      Logger.debug.println(ID, this, e.getMessage());
		    }
		    finally
		    {
		    }

		    return rtn;
		  }


			public SepoaOut insert_if_msg(Map<String, String> map) throws Exception
			{
				setStatus(1);
				setFlag(true);
				ConnectionContext ctx = getConnectionContext();
				Message msg = null;
				SepoaXmlParser sxp = null;
				SepoaSQLManager ssm = null;
				try{
					int rtn = -1;

					
					sxp = new SepoaXmlParser(this, "insert_if_msg"); 
					ssm = new SepoaSQLManager(info.getSession("ID"), this, ctx, sxp);
					
					rtn = ssm.doDelete(map);
					
					
					if(rtn<1){
						setStatus(0);
						Rollback();
						throw new Exception("UPDATE ICOMSCTM ERROR");
					}else{
						setStatus(1);
						Commit();
					}
					
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
