// Decompiled by DJ v3.9.9.91 Copyright 2005 Atanas Neshkov  Date: 2007-11-14 ���� 1:02:07
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3)
// Source File Name:   SapInterface.java
package sepoa.fw.sapr3;

import com.sap.mw.jco.IRepository;
import com.sap.mw.jco.JCO;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ParamSql;

import sepoa.fw.jtx.SepoaTransactionalResource;
import sepoa.fw.log.*;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDate;

import java.io.PrintStream;

import java.util.ArrayList;
import java.util.Vector;


public class SapInterface
{
    IRepository repository;
    com.sap.mw.jco.JCO.Client client;
    com.sap.mw.jco.JCO.Table table;
    com.sap.mw.jco.JCO.Function function;
    Vector Tables;
    String dbpool;
    int poolsize;
    String pro_client;
    String userid;
    String passwd;
    String language;
    String hostname;
    String systemnumber;
    Vector m_param_names;
    Vector m_param_values;
    Vector m_result_values;
    Vector m_result_names;
    Vector m_tables;
    Vector m_add_datas;
    ArrayList al_iflm;
    ArrayList al_iflp;
    ArrayList al_iflt;
    ArrayList al_ifld;
    String if_number = "";
    String origin_if_number = "";
    int if_seq = 1;
    String info_user_id = "";
    String info_user_name_loc = "";

    public SapInterface()
    {
        Tables = new Vector();
        m_param_names = new Vector();
        m_param_values = new Vector();
        m_result_values = new Vector();
        m_result_names = new Vector();
        m_tables = new Vector();
        m_add_datas = new Vector();
        al_iflm = new ArrayList();
        al_iflp = new ArrayList();
        al_iflt = new ArrayList();
        al_ifld = new ArrayList();
        removeAllValue();
    }

    public com.sap.mw.jco.JCO.Table getTableData(String s)
    {
        table = function.getTableParameterList().getTable(s);
//        System.out.println("==============================================================");
//    	Logger.debug.println(info_user_id, this, "==============================================================");
//        System.out.println("getTableData ==> table_name : " + s);
//        System.out.println("getTableData ==> numberOfRows : " + table.getNumRows());
//        System.out.println("getTableData ==> numberOfCols : " + table.getNumColumns());
//        Logger.debug.println(info_user_id, this, "getTableData ==> table_name : " + s);
//        Logger.debug.println(info_user_id, this, "getTableData ==> numberOfRows : " + table.getNumRows());
//        Logger.debug.println(info_user_id, this, "getTableData ==> numberOfCols : " + table.getNumColumns());
        int column_count = 0;
//        System.out.println("==============================================================");
//    	Logger.debug.println(info_user_id, this, "==============================================================");

        for (int i = 0; i < table.getNumRows(); i++)
        {
        	table.setRow(i);
	        column_count = table.getNumColumns();

	        for (int ii = 0; ii < column_count; ii++)
	        {
//	            System.out.println(i + ", ��° Row, " + "getTableData() column name : " + table.getName(ii) + "\t\t\t\t\t\t\tValue : " + table.getString(table.getName(ii)));
//	            Logger.debug.println(info_user_id, this, i + ", ��° Row, " + "getTableData() column name : " + table.getName(ii) + "\t\t\t\t\t\t\tValue : " + table.getString(table.getName(ii)));

	            SifldVo sifld_vo = new SifldVo();
                sifld_vo.setColumn_name(table.getName(ii));
                sifld_vo.setData_value(table.getString(table.getName(ii)));
                sifld_vo.setIf_number(if_number);
                sifld_vo.setIf_type("RECEIVE");
                sifld_vo.setTable_name(s);
                sifld_vo.setRow_number(String.valueOf(i));
                al_ifld.add(sifld_vo);
	        }

//	        System.out.println("==============================================================");
//        	Logger.debug.println(info_user_id, this, "==============================================================");
        }

        return table;
    }

    public com.sap.mw.jco.JCO.ParameterList getExportParameter()
    {
        com.sap.mw.jco.JCO.ParameterList parameterlist = function.getExportParameterList();

        return parameterlist;
    }

    public com.sap.mw.jco.JCO.Structure getExportStructure(String structure_name)
    {
        com.sap.mw.jco.JCO.Structure parameterlist = function.getExportParameterList().getStructure(structure_name);

        return parameterlist;
    }

    public void removeAllValue()
    {
        m_param_values.removeAllElements();
        m_param_names.removeAllElements();
        m_result_values.removeAllElements();
        m_result_names.removeAllElements();
        m_tables.removeAllElements();
        m_add_datas.removeAllElements();
        insertLogData();
//        al_iflm.clear();
//        al_iflm.trimToSize();
//        al_iflp.clear();
//        al_iflp.trimToSize();
//        al_ifld.clear();
//        al_ifld.trimToSize();
//        al_iflt.clear();
//        al_iflt.trimToSize();

        Tables.removeAllElements();
    }

    public void addParam(String s, String s1)
    {
        m_param_values.addElement(s1);
        m_param_names.addElement(s);
    }

    public Vector getParamValues()
    {
        return m_param_values;
    }

    public Vector getParamNames()
    {
        return m_param_names;
    }

    public Vector getResultValues()
    {
        return m_result_values;
    }

    public Vector getResultNames()
    {
        return m_result_names;
    }

    public void addTableData(String s, String[][] as)
    {
        m_tables.addElement(s);
        m_add_datas.addElement(as);
    }

    public void release()
    {
    	try
    	{
	    	JCO.releaseClient(client);
	        
	        Logger.debug.println(info_user_id, this, "�������������������� SAP R/3 Release OK.....");
	        insertLogData();
		} catch(Exception e)
		{
			Logger.debug.println(info_user_id, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+", Line Number : " + new Exception().getStackTrace()[0].getLineNumber() + ", ERROR:" + e.getMessage());
			
		}
    }

    public void insertLogData()
    {
    	/*
         * SAP R/3 Log insert
         */
        SepoaTransactionalResource sepoa_tres = null;
		StringBuffer sql = new StringBuffer();
		StringBuffer data = new StringBuffer();
		ParamSql ps;

		try
		{
			sepoa_tres = new SepoaTransactionalResource();
			sepoa_tres.getUserTransaction();
			ps = new ParamSql(info_user_id, this, sepoa_tres);
			SifldVo ld_vo = null;
			boolean is_clean_flag = false;

			if(!(al_ifld == null))
			{
				try
				{
					ps.removeAllValue();
					sql.append(" insert into sifld ( \n ");
					sql.append(" if_number \n ");
					sql.append(" , if_type \n ");
					sql.append(" , table_name \n ");
					sql.append(" , column_name \n ");
					sql.append(" , data_value \n ");
					sql.append(" , row_number \n ");
					sql.append(" ) \n ");

					for(int i = 0; i < al_ifld.size(); i++)
					{
						ld_vo = (SifldVo) (al_ifld.get(i));
						data.delete(0, data.length());

						if(i > 0 && ! is_clean_flag)
						{
							data.append(" union all \n ");
						}

						is_clean_flag = false;
						data.append(" select \n ");

						data.append(" ? \n ");
						ps.addStringParameter(ld_vo.getIf_number());

						data.append(" , ? \n ");
						ps.addStringParameter(ld_vo.getIf_type());

						data.append(" , ? \n ");
						ps.addStringParameter(ld_vo.getTable_name());

						data.append(" , ? \n ");
						ps.addStringParameter(ld_vo.getColumn_name());

						data.append(" , ? \n ");
						ps.addStringParameter(ld_vo.getData_value());

						data.append(" , ? \n ");
						ps.addStringParameter(ld_vo.getRow_number());

						data.append(" from dual \n ");

						sql.append(data);

						if(i > 0 && (i % 500) == 0)
						{
							ps.doInsert(sql.toString());

							ps.removeAllValue();
							sql.delete(0, sql.length());
							sql.append(" insert into sifld ( \n ");
							sql.append(" if_number \n ");
							sql.append(" , if_type \n ");
							sql.append(" , table_name \n ");
							sql.append(" , column_name \n ");
							sql.append(" , data_value \n ");
							sql.append(" , row_number \n ");
							sql.append(" ) \n ");
							is_clean_flag = true;
							data.delete(0, data.length());
						}
					}

//					if(al_ifld.size() > 0)
					if(data.length() > 0)
					{
						//Logger.debug.println("dd", this, sql.toString());
						ps.doInsert(sql.toString());
					}
				} catch(Exception e)
				{
					Logger.debug.println(info_user_id, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+", Line Number : " + new Exception().getStackTrace()[0].getLineNumber() + ", ERROR:" + e.getMessage());
					
				}
			}

			if(!(al_iflm == null))
			{
				try
				{
					SiflmVo lm_vo = null;

					for(int i = 0; i < al_iflm.size(); i++)
					{
						lm_vo = (SiflmVo) (al_iflm.get(i));
						ps.removeAllValue();
						sql.delete(0, sql.length());
						data.delete(0, data.length());

						sql.append(" insert into siflm ( \n ");
						data.append(" ) values ( \n ");

						sql.append(" if_number \n ");
						data.append(" ? \n ");
						ps.addStringParameter(lm_vo.getIf_number());

						sql.append(" , if_date \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getIf_date());

						sql.append(" , if_time \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getIf_time());

						sql.append(" , rfc_name \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getRfc_name());

						sql.append(" , sap_system_id \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getSap_system_id());

						sql.append(" , sap_client_no \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getSap_client_no());

						sql.append(" , sap_user_id \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getSap_user_id());

						sql.append(" , sap_password \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getSap_password());

						sql.append(" , sap_language \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getSap_language());

						sql.append(" , sap_host_ip \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getSap_host_ip());

						sql.append(" , sap_system_no \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(lm_vo.getSap_system_no());

						sql.append(" , if_user_id \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(info_user_id);

						sql.append(" , if_user_name_loc \n ");
						data.append(" , ? \n ");
						ps.addStringParameter(info_user_name_loc);

						data.append(" ) \n ");

						sql.append(data);
						ps.doInsert(sql.toString());
					}
				} catch(Exception e)
				{
					Logger.debug.println(info_user_id, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+", Line Number : " + new Exception().getStackTrace()[0].getLineNumber() + ", ERROR:" + e.getMessage());
					
				}
			}

			if(! (al_iflp == null))
			{
				try
				{
					SiflpVo lp_vo = null;
					ps.removeAllValue();
					sql.delete(0, sql.length());
					sql.append(" insert into siflp ( \n ");
					sql.append(" if_number \n ");
					sql.append(" , if_seq \n ");
					sql.append(" , parameter_name \n ");
					sql.append(" , parameter_value \n ");
					sql.append(" ) \n ");

					for(int i = 0; i < al_iflp.size(); i++)
					{
						lp_vo = (SiflpVo) (al_iflp.get(i));
						data.delete(0, data.length());

						if(i > 0)
						{
							data.append(" union all \n ");
						}

						data.append(" select \n ");

						data.append(" ? \n ");
						ps.addStringParameter(lp_vo.getIf_number());

						data.append(" , ? \n ");
						ps.addStringParameter(lp_vo.getIf_seq());

						data.append(" , ? \n ");
						ps.addStringParameter(lp_vo.getParameter_name());

						data.append(" , ? \n ");
						ps.addStringParameter(lp_vo.getParameter_value());

						data.append(" from dual \n ");

						sql.append(data);
					}

					if(al_iflp.size() > 0)
					{
						ps.doInsert(sql.toString());
					}
				} catch(Exception e)
				{
					Logger.debug.println(info_user_id, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+", Line Number : " + new Exception().getStackTrace()[0].getLineNumber() + ", ERROR:" + e.getMessage());
					
				}
			}

			if(!(al_iflm == null))
			{
				if(al_iflm.size() > 0)
				{
					if_number = origin_if_number + "-" + String.valueOf(if_seq);
					if_seq++;
				}
			}

			sepoa_tres.getUserTransaction().commit();
			al_ifld.clear();
			al_iflm.clear();
			al_iflp.clear();
			al_iflt.clear();
			al_ifld.trimToSize();
			al_iflm.trimToSize();
			al_iflp.trimToSize();
			al_iflt.trimToSize();
		} catch(Exception e)
		{
			Logger.debug.println(info_user_id, this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+", Line Number : " + new Exception().getStackTrace()[0].getLineNumber() + ", ERROR:" + e.getMessage());
			
		}
		finally
		{
			if (sepoa_tres != null) { sepoa_tres.release(); }
		}
    }

    public void createPool(String s) throws Exception
    {
        try
        {
            Configuration configuration = new Configuration();

            Logger.debug.println("DK09.LEE", this, "sssssssss : " + s);

            if (s.equals("ACC"))
            {
                
                dbpool = configuration.get("sepoa.accsap.poolname");
                poolsize = Integer.parseInt(configuration.get("sepoa.accsap.poolsize"));
                pro_client = configuration.get("sepoa.accsap.client");
                userid = configuration.get("sepoa.accsap.userid");
                passwd = configuration.get("sepoa.accsap.passwd");
                language = configuration.get("sepoa.accsap.language");
                hostname = configuration.get("sepoa.accsap.hostname");
                systemnumber = configuration.get("sepoa.accsap.systemno");
            }
            else if (s.equals("PROD"))
            {
                
                dbpool = configuration.get("sepoa.prodsap.poolname");
                poolsize = Integer.parseInt(configuration.get("sepoa.prodsap.poolsize"));
                pro_client = configuration.get("sepoa.prodsap.client");
                userid = configuration.get("sepoa.prodsap.userid");
                passwd = configuration.get("sepoa.prodsap.passwd");
                language = configuration.get("sepoa.prodsap.language");
                hostname = configuration.get("sepoa.prodsap.hostname");
                systemnumber = configuration.get("sepoa.prodsap.systemno");
            }
            else if (s.equals("40B"))
            {
                
                dbpool = configuration.get("sepoa.40bsap.poolname");
                poolsize = Integer.parseInt(configuration.get("sepoa.40bsap.poolsize"));
                pro_client = configuration.get("sepoa.40bsap.client");
                userid = configuration.get("sepoa.40bsap.userid");
                passwd = configuration.get("sepoa.40bsap.passwd");
                language = configuration.get("sepoa.40bsap.language");
                hostname = configuration.get("sepoa.40bsap.hostname");
                systemnumber = configuration.get("sepoa.40bsap.systemno");
            }
            else
            {
                
                dbpool = configuration.get("sepoa.devsap.poolname");
                poolsize = Integer.parseInt(configuration.get("sepoa.devsap.poolsize"));
                pro_client = configuration.get("sepoa.devsap.client");
                userid = configuration.get("sepoa.devsap.userid");
                passwd = configuration.get("sepoa.devsap.passwd");
                language = configuration.get("sepoa.devsap.language");
                hostname = configuration.get("sepoa.devsap.hostname");
                systemnumber = configuration.get("sepoa.devsap.systemno");
            }

            Logger.debug.println("DK09.LEE", this, "dbpool : " + dbpool);
            Logger.debug.println("DK09.LEE", this, "poolsize : " + poolsize);
            Logger.debug.println("DK09.LEE", this, "pro_client : " + pro_client);
            Logger.debug.println("DK09.LEE", this, "userid : " + userid);
            Logger.debug.println("DK09.LEE", this, "passwd : " + passwd);
            Logger.debug.println("DK09.LEE", this, "language : " + language);
            Logger.debug.println("DK09.LEE", this, "hostname : " + hostname);
            Logger.debug.println("DK09.LEE", this, "systemnumber : " + systemnumber);

            com.sap.mw.jco.JCO.Pool pool = JCO.getClientPoolManager().getPool(dbpool);

            if (pool == null)
            {
                
                JCO.addClientPool(dbpool, poolsize, pro_client, userid, passwd, language, hostname, systemnumber);
            }

            repository = JCO.createRepository("MYRepository", dbpool);
        }
        catch (com.sap.mw.jco.JCO.Exception exception)
        {
            
            throw new Exception("createPool()==//" + exception.getMessage());
        }
        catch (Exception exception1)
        {
            
            throw new Exception("createPool()==//" + exception1.getMessage());
        }
    }

    public void excuteFunctionGetTable(String s, String s1) throws Exception
    {
        String s2 = dbpool;
        String s3 = "";
        String s5 = "";

        try
        {
            com.sap.mw.jco.IFunctionTemplate ifunctiontemplate = repository.getFunctionTemplate(s);
            function = new com.sap.mw.jco.JCO.Function(ifunctiontemplate);
            client = JCO.getClient(s2);

            com.sap.mw.jco.JCO.ParameterList parameterlist = function.getImportParameterList();

            for (int i = 0; i < m_param_names.size(); i++)
            {
                String s4 = (String) m_param_names.elementAt(i);
                String s6 = (String) m_param_values.elementAt(i);
                parameterlist.setValue(s6, s4);
            }

            synchronized (client)
            {
                client.execute(function);
            }

            com.sap.mw.jco.JCO.Table table1 = function.getTableParameterList().getTable(s1);

            if (table1.getNumRows() <= 0)
            {
                
            }
        }
        catch (Exception exception)
        {
            if (dbpool != null)
            {
                dbpool = null;
                release();
            }

            
            throw new Exception("getTableData()==//" + exception.getMessage());
        }
    }

    public void createPool(SepoaInfo info, String sapSystemId, String sapClient, String sapUserId, String sapPasswd, String sapLanguage, String sapHostName, String sapSystemNumber) throws Exception
    {
        try
        {
        	removeAllValue();

        	if(info == null)
        	{
                info = new SepoaInfo("100","ID=SAP R/3^@^LANGUAGE=" + "KO" + "^@^NAME_LOC=SAP R/3^@^NAME_ENG=SAP R/3^@^DEPT=ALL^@^");
        	}
        	else if(info.getSession("ID").trim().length() <= 0)
        	{
        		info = new SepoaInfo("100","ID=SAP R/3^@^LANGUAGE=" + "KO" + "^@^NAME_LOC=SAP R/3^@^NAME_ENG=SAP R/3^@^DEPT=ALL^@^");
        	}

        	info_user_id = info.getSession("ID");
        	info_user_name_loc = info.getSession("NAME_LOC");

            
            Logger.debug.println(info_user_id, this, "SAP createPool starting....");

            // release();
            Config conf = new Configuration();
            dbpool = "MSSQLPool_" + sapSystemId;
            poolsize = conf.getInt("sepoa.sap.default.poolsize");
            pro_client = sapClient;
            userid = sapUserId;
            passwd = sapPasswd;
            language = sapLanguage;
            hostname = sapHostName;
            systemnumber = sapSystemNumber;

            if (dbpool.trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : Pool Name is null !!");
            }

            if (String.valueOf(poolsize).trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : Pool size is null !!");
            }

            if (pro_client.trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : Client is null !!");
            }

            if (userid.trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : User id is null !!");
            }

            if (passwd.trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : Password is null !!");
            }

            if (language.trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : Language is null !!");
            }

            if (hostname.trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : Host Name is null !!");
            }

            if (systemnumber.trim().length() <= 0)
            {
                throw new Exception("SAP R/3 Exception : System Number is null !!");
            }

            JCO.Pool pool = JCO.getClientPoolManager().getPool(dbpool);

            // Add a connection pool to the specified system
            if (pool == null)
            {
                
                JCO.addClientPool(dbpool, // Alias for this pool
                    poolsize, // Max. number of connections
                    pro_client, // SAP client
                    userid, // userid
                    passwd, // password
                    language, // language
                    hostname, // host name
                    systemnumber); // systemnumber
                
                Logger.debug.println(info_user_id, this, "�������������������� SAP R/3 addClientPool() OK.....");
            }

            // Create a new repository
            repository = JCO.createRepository("MYRepository", dbpool);
            
            Logger.debug.println(info_user_id, this, "�������������������� SAP R/3 Connection OK.....");

            SepoaOut sp_out = DocumentUtil.getDocNumber(info,"RFC");//ä��
			if_number = sp_out.result[0];
			origin_if_number = if_number;
        }
        catch (JCO.Exception ex)
        {
            
            throw new Exception("createPool() : " + ex.getMessage());
        }
        catch (Exception e)
        {
            
            throw new Exception("createPool()==//" + e.getMessage());
        }
    }

    /**
     * @param s
     * @throws Exception
     */
    public synchronized void excuteFunction(String s) throws Exception
    {
        String s1 = dbpool;
        String s2 = "";
        String s4 = "";

        try
        {
            com.sap.mw.jco.IFunctionTemplate ifunctiontemplate = repository.getFunctionTemplate(s);
            function = new com.sap.mw.jco.JCO.Function(ifunctiontemplate);
            client = JCO.getClient(s1);
            com.sap.mw.jco.JCO.ParameterList parameterlist = function.getImportParameterList();

//            System.out.println("TransData ==> dbpool : " + dbpool);
//            System.out.println("TransData ==> function_name : " + s);
//            Logger.debug.println(info_user_id, this, "TransData ==> dbpool : " + dbpool);
//            Logger.debug.println(info_user_id, this, "TransData ==> function_name : " + s);

			SiflmVo siflm_vo = new SiflmVo();
			siflm_vo.setIf_number(if_number);
			siflm_vo.setIf_date(SepoaDate.getShortDateString());
			siflm_vo.setIf_time(SepoaDate.getShortTimeString());
			siflm_vo.setRfc_name(s);
			siflm_vo.setSap_client_no(pro_client);
			siflm_vo.setSap_host_ip(hostname);
			siflm_vo.setSap_language(language);
			siflm_vo.setSap_password(passwd);
			siflm_vo.setSap_system_id(dbpool);
			siflm_vo.setSap_system_no(systemnumber);
			siflm_vo.setSap_user_id(userid);
			al_iflm.add(siflm_vo);

            for (int i = 0; i < m_param_names.size(); i++)
            {
                String s3 = (String) m_param_names.elementAt(i);
                String s5 = (String) m_param_values.elementAt(i);
                parameterlist.setValue(s5, s3);
//                System.out.println("excuteFunction ==> parameter name : " + s3);
//                Logger.debug.println(info_user_id, this, "excuteFunction ==> parameter name : " + s3);
//                System.out.println("excuteFunction ==> parameter value : " + s5);
//                Logger.debug.println(info_user_id, this, "excuteFunction ==> parameter value : " + s5);

                SiflpVo siflp_vo = new SiflpVo();
                siflp_vo.setIf_number(if_number);
                siflp_vo.setIf_seq(String.valueOf(i));
                siflp_vo.setParameter_name(s3);
                siflp_vo.setParameter_value(s5);
                al_iflp.add(siflp_vo);
            }

            synchronized (client)
            {
                client.execute(function);
            }
        }
        catch (Exception exception)
        {
            if (dbpool != null)
            {
                dbpool = null;
                release();
            }

            
            throw new Exception("getTableData()==//" + exception.getMessage());
        }
    }

    /**
     * @param s
     * @throws Exception
     */
    public synchronized void transData(String s) throws Exception
    {
        try
        {
            com.sap.mw.jco.IFunctionTemplate ifunctiontemplate = repository.getFunctionTemplate(s);
            function = new com.sap.mw.jco.JCO.Function(ifunctiontemplate);
            client = JCO.getClient(dbpool);

			SiflmVo siflm_vo = new SiflmVo();
			siflm_vo.setIf_number(if_number);
			siflm_vo.setIf_date(SepoaDate.getShortDateString());
			siflm_vo.setIf_time(SepoaDate.getShortTimeString());
			siflm_vo.setRfc_name(s);
			siflm_vo.setSap_client_no(pro_client);
			siflm_vo.setSap_host_ip(hostname);
			siflm_vo.setSap_language(language);
			siflm_vo.setSap_password(passwd);
			siflm_vo.setSap_system_id(dbpool);
			siflm_vo.setSap_system_no(systemnumber);
			siflm_vo.setSap_user_id(userid);
			al_iflm.add(siflm_vo);

//            System.out.println("TransData ==> dbpool : " + dbpool);
//            System.out.println("TransData ==> function_name : " + s);
//            Logger.debug.println(info_user_id, this, "TransData ==> dbpool : " + dbpool);
//            Logger.debug.println(info_user_id, this, "TransData ==> function_name : " + s);

            com.sap.mw.jco.JCO.ParameterList parameterlist = function.getImportParameterList();

            for (int i = 0; i < m_param_names.size(); i++)
            {
                String s4 = (String) m_param_names.elementAt(i);
                String s6 = (String) m_param_values.elementAt(i);
                parameterlist.setValue(s6, s4);
//                System.out.println("TransData ==> parameter name : " + s4);
//                Logger.debug.println(info_user_id, this, "TransData ==> parameter name : " + s4);
//                System.out.println("TransData ==> parameter value : " + s6);
//                Logger.debug.println(info_user_id, this, "TransData ==> parameter value : " + s6);

                SiflpVo siflp_vo = new SiflpVo();
                siflp_vo.setIf_number(if_number);
                siflp_vo.setIf_seq(String.valueOf(i));
                siflp_vo.setParameter_name(s4);
                siflp_vo.setParameter_value(s6);
                al_iflp.add(siflp_vo);
            }

            int column_count = 0; int j= 0; int k = 0; String s1 = "";

            for (int i = 0; i < m_tables.size(); i++)
            {
                s1 = (String) m_tables.elementAt(i);
                String[][] as = (String[][]) m_add_datas.elementAt(i);
                com.sap.mw.jco.JCO.Table table1 = function.getTableParameterList().getTable(s1);

//                System.out.println("as ---> " + as[0].length);
//                System.out.println("s1 ---> " + s1);
//                Logger.debug.println(info_user_id, this, "as ---> " + as[0].length);
//                Logger.debug.println(info_user_id, this, "s1 ---> " + s1);

                j = as.length;
                k = table1.getFieldCount();
//                System.out.println("TransData ==> table_name : " + s1);
//                System.out.println("TransData ==> numberOfRows : " + j);
//                System.out.println("TransData ==> numberOfCols : " + k);
//                Logger.debug.println(info_user_id, this, "TransData ==> table_name : " + s1);
//                Logger.debug.println(info_user_id, this, "TransData ==> numberOfRows : " + j);
//                Logger.debug.println(info_user_id, this, "TransData ==> numberOfCols : " + k);

                column_count = table1.getNumColumns();

//                for (int ii = 0; ii < column_count; ii++)
//                {
//                    System.out.println("column name ; " + table1.getName(ii));
//                    Logger.debug.println(info_user_id, this, "column name ; " + table1.getName(ii));
//                }

                for (int l = 0; l < j; l++)
                {
                    table1.appendRow();

                    for (int i1 = 0; i1 < k; i1++)
                    {
                        table1.setValue(as[l][i1], i1);
//                        System.out.println("Column Name : " + table1.getName(i1) + " Row Index: " + l + ", Column Index : " + i1 + " --> " + as[l][i1]);
//                        Logger.debug.println(info_user_id, this, "Column Name : " + table1.getName(i1) + " Row Index: " + l + ", Column Index : " + i1 + " --> " + as[l][i1]);

                        SifldVo sifld_vo = new SifldVo();
                        sifld_vo.setColumn_name(table1.getName(i1));
                        sifld_vo.setData_value(as[l][i1]);
                        sifld_vo.setIf_number(if_number);
                        sifld_vo.setIf_type("SEND");
                        sifld_vo.setTable_name(s1);
                        sifld_vo.setRow_number(String.valueOf(l));
                        al_ifld.add(sifld_vo);
                    }

//                    System.out.println("==============================================================");
//                	Logger.debug.println(info_user_id, this, "==============================================================");
                }

//                System.out.println("Table Name ==============>" + s1);
//                System.out.println("Insert Count ============>" + table1.getNumRows());
//                Logger.debug.println(info_user_id, this, "Table Name ==============>" + s1);
//                Logger.debug.println(info_user_id, this, "Insert Count ============>" + table1.getNumRows());
            }

            synchronized (client)
            {
                client.execute(function);
            }

//            System.out.println("execute OK ============>" + function);
//            Logger.debug.println(info_user_id, this, "execute OK ============>" + function);
        }
        catch (Exception exception)
        {
            if (dbpool != null)
            {
                dbpool = null;
                release();
            }

            
            Logger.debug.println(info_user_id, this, "transData============Caught an exception: \n" + exception.getMessage());
            throw new Exception("transData() Exception" + exception.getMessage());
        }
    }

    /**
     * @param s
     * @param s1
     * @throws Exception
     */
    public synchronized void getTableDataColumnName(String s, String s1) throws Exception
    {
        String s2 = dbpool;
        String s3 = "";
        String s5 = "";

        try
        {
            com.sap.mw.jco.IFunctionTemplate ifunctiontemplate = repository.getFunctionTemplate(s);
            function = new com.sap.mw.jco.JCO.Function(ifunctiontemplate);
            client = JCO.getClient(s2);

            com.sap.mw.jco.JCO.ParameterList parameterlist = function.getImportParameterList();

            for (int i = 0; i < m_param_names.size(); i++)
            {
                String s4 = (String) m_param_names.elementAt(i);
                String s6 = (String) m_param_values.elementAt(i);
                parameterlist.setValue(s6, s4);
            }

            

            synchronized (client)
            {
                client.execute(function);
            }

            table = function.getTableParameterList().getTable(s1);
            
        }
        catch (Exception exception)
        {
            if (dbpool != null)
            {
                dbpool = null;
                release();
            }

            
            throw new Exception("getTableData()==//" + exception.getMessage());
        }
    }
}
