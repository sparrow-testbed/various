package sepoa.fw.util;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.jtx.SepoaTransactionalResource;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.DecimalFormat;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;

public class DocumentUtil
{
	private static String SEPOA_DB_VENDOR = "";
	private static String SEPOA_DB_OWNER = "";
	private static String DB_NULL_FUNCTION = "";

	private DocumentUtil()
	{

	}



	public static String getConfig(String s)
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

	//public static SepoaOut getDocNumber(SepoaInfo sepoainfo, String s)
	public static SepoaOut getDocNumber1(SepoaInfo sepoainfo, String s)
	{
		Object obj = null;
		Object obj1 = null;
		SepoaOut sepoaout = new SepoaOut();
		String[] as = new String[1];
		String s2 = "";    java.io.InputStream inputstream = null;

		try
		{
			Configuration configuration = new Configuration();
			String s3 = configuration.get("sepoa.docnumber.murl");
			Logger.debug.println("s3 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$=======" + s3);
			String s4 = sepoainfo.getSession("ID");
			URL url = new URL(s3 + "?HOUSE_CODE=" + sepoainfo.getSession("HOUSE_CODE") + "&DOC_TYPE=" + s + "&INFO=" +  URLEncoder.encode("ID=" + sepoainfo.getSession("ID") + "^@^LANGUAGE=KO^@^NAME_LOC=DOC^@^NAME_ENG=DOC^@^"));

			URLConnection urlconnection = url.openConnection(); inputstream = urlconnection.getInputStream(); BufferedReader bufferedreader = new BufferedReader(new InputStreamReader(inputstream));
//			BufferedReader bufferedreader = new BufferedReader(new InputStreamReader(urlconnection.getInputStream()));
			String s5;

			for (int i = 0; (s5 = bufferedreader.readLine()) != null; i++)
			{
				if (i == 0)
				{
					sepoaout.status = Integer.parseInt(s5);
				}
				else
				{
					as[0] = s5;
					sepoaout.result = as;
				}
			}

			bufferedreader.close();
		}
		catch (MalformedURLException malformedurlexception)
		{
			sepoaout.status = -2;
			as[0] = malformedurlexception.getMessage();
			sepoaout.result = as;
			Logger.err.println("Exception e =" + malformedurlexception.getMessage());
		}
		catch (IOException ioexception)
		{
			sepoaout.status = -3;
			as[0] = ioexception.getMessage();
			sepoaout.result = as;
			Logger.err.println("Exception e =" + ioexception.getMessage());
		}
		catch (Exception exception)
		{
			sepoaout.status = -4;
			as[0] = exception.getMessage();
			sepoaout.result = as;
			Logger.err.println("Exception e =" + exception.getMessage());
		}
        finally{ if(inputstream != null){ IOUtils.closeQuietly(inputstream); } }
		return sepoaout;
	}

	public static SepoaOut getDocNumber(SepoaInfo sepoainfo, String s, String s2)
	{
		Object obj = null;
		Object obj1 = null;
		SepoaOut sepoaout = new SepoaOut();
		String[] as = new String[1];
		String s3 = "";    java.io.InputStream inputstream = null;

		if(sepoainfo == null)
		{
			sepoainfo = new SepoaInfo("100", "ID=DocNumber^@^COMPANY_CODE=C100^@^LANGUAGE=KO^@^DEPARTMENT=SYSTEM^@^NAME_LOC=SYSTEM^@^NAME_ENG=SYSTEM^@^");
		}

		try
		{
			Configuration configuration = new Configuration();
			String s4 = configuration.get("sepoa.docnumber.murl");
			URL url = new URL(s4 + "?HOUSE_CODE=" + sepoainfo.getSession("HOUSE_CODE") + "&DOC_TYPE=" + s + "&EXP_NO=" + s2 + "&INFO=ID=" + sepoainfo.getSession("ID") + "^@^LANGUAGE=KO^@^NAME_LOC=DOC^@^NAME_ENG=DOC^@^");
			URLConnection urlconnection = url.openConnection(); inputstream = urlconnection.getInputStream(); BufferedReader bufferedreader = new BufferedReader(new InputStreamReader(inputstream, "KSC5601"));
//			BufferedReader bufferedreader = new BufferedReader(new InputStreamReader(urlconnection.getInputStream(), "KSC5601"));
			String s5;

			for (int i = 0; (s5 = bufferedreader.readLine()) != null; i++)
			{
				if (i == 0)
				{
					sepoaout.status = Integer.parseInt(s5);
				}
				else
				{
					as[0] = s5;
					sepoaout.result = as;
				}
			}

			bufferedreader.close();

			return sepoaout;
		}
		catch (MalformedURLException malformedurlexception)
		{
			sepoaout.status = -2;
			as[0] = malformedurlexception.getMessage();
			sepoaout.result = as;
			Logger.err.println("Exception e =" + malformedurlexception.getMessage());
		}
		catch (IOException ioexception)
		{
			sepoaout.status = -3;
			as[0] = ioexception.getMessage();
			sepoaout.result = as;
			Logger.err.println("Exception e =" + ioexception.getMessage());
		}
		catch (Exception exception)
		{
			sepoaout.status = -4;
			as[0] = exception.getMessage();
			sepoaout.result = as;
			Logger.err.println("Exception e =" + exception.getMessage());
		}
		finally{ if(inputstream != null){ IOUtils.closeQuietly(inputstream); } }
		return sepoaout;
	}
	
	public static synchronized SepoaOut getDocNumberRemote(SepoaInfo sepoainfo, String s){
		return getDocNumber(sepoainfo, s);
	}

	//public static synchronized SepoaOut getDocNumberRemote(SepoaInfo sepoainfo, String s)
	public static synchronized SepoaOut getDocNumber(SepoaInfo sepoainfo, String s)
	{
		SepoaTransactionalResource sepoatransactionalresource = null;
		Object obj = null;
		SepoaOut sepoaout = new SepoaOut();

		try
		{
			sepoatransactionalresource = new SepoaTransactionalResource();
			sepoatransactionalresource.getUserTransaction();

			SepoaTransactionalResource sepoatransactionalresource1 = sepoatransactionalresource;
			String[] as = new String[1];
			String s2 = sepoainfo.getSession("HOUSE_CODE");
			String s3 = sepoainfo.getSession("ID");
			as[0] = et_getDocNumber(sepoatransactionalresource1, s3, s2, s);

			SepoaFormater sepoaformater = new SepoaFormater(as[0]);

			if (sepoaformater.getRowCount() < 1)
			{
				sepoaout.message = "Data Not Found!";
				Logger.err.println(s3, sepoaout, sepoaout.message);
				sepoaout.result = as;
				sepoaout.status = 0;
				sepoatransactionalresource.getUserTransaction().rollback();

				SepoaOut sepoaout3 = sepoaout;
				SepoaOut sepoaout1 = sepoaout3;

				return sepoaout1;
			}

			double d = Double.parseDouble(sepoaformater.getValue(0, 0));
			double d1 = Double.parseDouble(sepoaformater.getValue(0, 1));
			int i = sepoaformater.getValue(0, 1).length();
			String s4 = sepoaformater.getValue(0, 2);
			String s5 = sepoaformater.getValue(0, 3);
			String s6 = sepoaformater.getValue(0, 4);
			String s7 = sepoaformater.getValue(0, 5);
			String s8 = sepoaformater.getValue(0, 6);
			String s9 = "";
			String s10 = sepoaformater.getValue(0, 2).substring(sepoaformater.getValue(0, 2).length() - i, sepoaformater.getValue(0, 2).length());
			double d2 = Double.parseDouble(s10);

			if ((d2 + 1.0D) > d1)
			{
				sepoaout.message = "Number Range Full!";
				Logger.err.println(s3, sepoaout, sepoaout.message);
				sepoaout.result = as;
				sepoaout.status = 0;
				sepoatransactionalresource.getUserTransaction().rollback();

				SepoaOut sepoaout4 = sepoaout;
				SepoaOut sepoaout2 = sepoaout4;

				return sepoaout2;
			}

			for (int j = 0; j < i; j++)
			{
				s9 = s9 + "0";
			}

			DecimalFormat decimalformat = new DecimalFormat(s9);
			Configuration conf = new Configuration();

			if (s6.equals("Y"))
			{
				/**
				 * 2009.04.27 �̴��
				 * �⵵ ä�� ���
				 */
				String year_type = conf.get("sepoa.document.generation.year.type");

				if(year_type.equals("FULL"))
				{
					s5 = s5 + String.valueOf(SepoaDate.getYear());
				}
				else if(year_type.equals("SHORT"))
				{
					s5 = s5 + String.valueOf(SepoaDate.getYear()).substring(2);
				}
			}

			if (s7.equals("Y"))
			{
				DecimalFormat decimalformat1 = new DecimalFormat("00");
				s5 = s5 + decimalformat1.format(SepoaDate.getMonth());
			}

			if (s8.equals("Y"))
			{
				DecimalFormat decimalformat2 = new DecimalFormat("00");
				s5 = s5 + decimalformat2.format(SepoaDate.getDay());
			}

			if (s4.indexOf(s5) == -1)
			{
				s5 = s5 + decimalformat.format(d);
			}
			else
			{
				s5 = s5 + decimalformat.format(d2 + 1.0D);
			}

			et_setDocNumber(sepoatransactionalresource1, s3, s2, s, s5);
			sepoaout.message = "Succeed Processing!";
			as[0] = s5;
			sepoaout.result = as;
			sepoaout.status = 1;
			sepoatransactionalresource.getUserTransaction().commit();
		}
		catch (Exception exception1)
		{
			Logger.err.println("Exception e =" + exception1.getMessage());
			sepoaout.status = 0;
			sepoaout.message = exception1.getMessage();

			try
			{
				if(sepoatransactionalresource != null) { sepoatransactionalresource.getUserTransaction().rollback(); }
			}
			catch (Exception _ex)
			{
				Logger.err.println("Exception e =" + _ex.getMessage());
			}
		}
		finally
		{
			if(sepoatransactionalresource != null) { sepoatransactionalresource.release(); }
		}

		return sepoaout;
	}

	private static String et_getDocNumber(ConnectionContext connectioncontext, String s, String s1, String s2) throws Exception
	{
		String s4 = null;
		Configuration configuration =  new Configuration();

		SEPOA_DB_VENDOR = configuration.getString("sepoa.db.vendor");
		SEPOA_DB_OWNER = configuration.getString("sepoa.db.owner") + ".";

		if (SEPOA_DB_VENDOR.equals("ORACLE"))
		{
			DB_NULL_FUNCTION = "NVL";
			SEPOA_DB_OWNER = "";
		}
		else if (SEPOA_DB_VENDOR.equals("MYSQL"))
		{
			DB_NULL_FUNCTION = "IFNULL";
			SEPOA_DB_OWNER = "";
		}
		else if (SEPOA_DB_VENDOR.equals("MSSQL"))
		{
			DB_NULL_FUNCTION = "ISNULL";
		}
		try
		{
			StringBuffer stringbuffer = new StringBuffer();

			stringbuffer.append(" SELECT START_NO,END_NO,CURRENT_NO,PREFIX_FORMAT,YEAR_FLAG,MONTH_FLAG,DAY_FLAG   \n");
			stringbuffer.append(" FROM  sdcln   \n");
			stringbuffer.append(" WHERE DOC_TYPE = '" + s2 + "' \n");
			stringbuffer.append(" AND   USE_FLAG = 'Y' AND " + DB_NULL_FUNCTION + "(del_flag, 'N') = 'N'  \n");

			SepoaSQLManager sepoasqlmanager = new SepoaSQLManager(s, stringbuffer, connectioncontext, stringbuffer.toString());
			s4 = sepoasqlmanager.doSelect((String[])null);
		}
		catch (Exception exception)
		{
			throw new Exception("getDocNumber:" + exception.getMessage());
		}

		return s4;
	}

	public static synchronized SepoaOut getDocNumberRemote(SepoaInfo sepoainfo, String s, String s2)
	{
		SepoaTransactionalResource sepoatransactionalresource = null;
		Object obj = null;
		SepoaOut sepoaout = new SepoaOut();

		try
		{
			sepoatransactionalresource = new SepoaTransactionalResource();
			sepoatransactionalresource.getUserTransaction();

			SepoaTransactionalResource sepoatransactionalresource1 = sepoatransactionalresource;
			String[] as = new String[1];
			String s3 = sepoainfo.getSession("HOUSE_CODE");
			String s4 = sepoainfo.getSession("ID");
			as[0] = et_getDocNumber(sepoatransactionalresource1, s4, s3, s);

			SepoaFormater sepoaformater = new SepoaFormater(as[0]);

			if (sepoaformater.getRowCount() < 1)
			{
				sepoaout.message = "Data Not Found!";
				Logger.err.println(s4, sepoaout, sepoaout.message);
				sepoaout.result = as;
				sepoaout.status = 0;
				sepoatransactionalresource.getUserTransaction().rollback();

				SepoaOut sepoaout3 = sepoaout;
				SepoaOut sepoaout1 = sepoaout3;

				return sepoaout1;
			}

			double d = Double.parseDouble(sepoaformater.getValue(0, 0));
			double d1 = Double.parseDouble(sepoaformater.getValue(0, 1));
			int i = sepoaformater.getValue(0, 1).length();
			String s5 = sepoaformater.getValue(0, 2);
			String s6 = sepoaformater.getValue(0, 3);
			String s7 = sepoaformater.getValue(0, 4);
			String s8 = sepoaformater.getValue(0, 5);
			String s9 = sepoaformater.getValue(0, 6);
			String s10 = "";
			String s11 = s6;
			String s12 = sepoaformater.getValue(0, 2).substring(sepoaformater.getValue(0, 2).length() - i, sepoaformater.getValue(0, 2).length());
			double d2 = Double.parseDouble(s12);

			if ((d2 + 1.0D) > d1)
			{
				sepoaout.message = "Number Range Full!";
				Logger.err.println(s4, sepoaout, sepoaout.message);
				sepoaout.result = as;
				sepoaout.status = 0;
				sepoatransactionalresource.getUserTransaction().rollback();

				SepoaOut sepoaout4 = sepoaout;
				SepoaOut sepoaout2 = sepoaout4;

				return sepoaout2;
			}

			for (int j = 0; j < i; j++)
			{
				s10 = s10 + "0";
			}

			DecimalFormat decimalformat = new DecimalFormat(s10);
			Configuration conf = new Configuration();

			//2007.06.12 �̴��
			//s11 = s11 + s2;

			if (s7.equals("Y"))
			{
				/**
				 * 2009.04.27 �̴��
				 * �⵵ ä�� ���
				 */
				String year_type = conf.get("sepoa.document.generation.year.type");

				if(year_type.equals("FULL"))
				{
					s6 = s6 + String.valueOf(SepoaDate.getYear());
					s11 = s11 + String.valueOf(SepoaDate.getYear());
				}
				else if(year_type.equals("SHORT"))
				{
					s6 = s6 + String.valueOf(SepoaDate.getYear()).substring(2);
					s11 = s11 + String.valueOf(SepoaDate.getYear()).substring(2);
				}
			}

			if (s8.equals("Y"))
			{
				DecimalFormat decimalformat1 = new DecimalFormat("00");
				s6 = s6 + decimalformat1.format(SepoaDate.getMonth());
				s11 = s11 + decimalformat1.format(SepoaDate.getMonth());
			}

			if (s9.equals("Y"))
			{
				DecimalFormat decimalformat2 = new DecimalFormat("00");
				s6 = s6 + decimalformat2.format(SepoaDate.getDay());
				s11 = s11 + decimalformat2.format(SepoaDate.getDay());
			}

			if (s5.indexOf(s6) == -1)
			{
				s6 = s6 + decimalformat.format(d);
				s11 = s11 + decimalformat.format(d);
			}
			else
			{
				s6 = s6 + decimalformat.format(d2 + 1.0D);
				s11 = s11 + decimalformat.format(d2 + 1.0D);
			}

			et_setDocNumber(sepoatransactionalresource1, s4, s3, s, s6);
			sepoaout.message = "Succeed Processing!";

			//2007.06.12 �̴��
			//as[0] = s11.substring(1, s11.length());

			as[0] = s11;
			sepoaout.result = as;
			sepoaout.status = 1;
			sepoatransactionalresource.getUserTransaction().commit();
		}
		catch (Exception exception1)
		{
			Logger.err.println("Exception e =" + exception1.getMessage());
			sepoaout.status = 0;
			sepoaout.message = exception1.getMessage();

			try
			{
				if(sepoatransactionalresource != null) { sepoatransactionalresource.getUserTransaction().rollback(); }
			}
			catch (Exception _ex)
			{
				Logger.err.println("Exception e =" + _ex.getMessage());
			}
		}
		finally
		{
			if(sepoatransactionalresource != null) { sepoatransactionalresource.release(); }
		}

		return sepoaout;
	}

	private static int et_setDocNumber(ConnectionContext connectioncontext, String s, String s1, String s2, String s4) throws Exception
	{
		int i = 0;

		try
		{
			StringBuffer stringbuffer = new StringBuffer();
			stringbuffer.append(" UPDATE sdcln ");
			stringbuffer.append(" SET CURRENT_NO= '" + s4 + "' ");
			stringbuffer.append(" WHERE DOC_TYPE = '" + s2 + "' ");
			stringbuffer.append(" AND   USE_FLAG = 'Y' ");

			SepoaSQLManager sepoasqlmanager = new SepoaSQLManager(s, stringbuffer, connectioncontext, stringbuffer.toString());
			i = sepoasqlmanager.doUpdate();
		}
		catch (Exception exception)
		{
			throw new Exception("setDocNumber:" + exception.getMessage());
		}

		return i;
	}
}
