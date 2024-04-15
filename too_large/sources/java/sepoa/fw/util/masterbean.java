package sepoa.fw.util;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;

public class MasterBean
{
	//protected final Log logger = LogFactory.getLog(getClass());
	SepoaInfo info = new SepoaInfo("100", "ID=" + "UPLOAD" + "^@^LANGUAGE=KO^@^NAME_LOC=SYSTEM^@^NAME_ENG=SYSTEM^@^COMPANY_CODE=PT^@^OPERATING_CODE=ALL^@^PLANT_CODE=ALL^@^DEPARTMENT=BATCH^@^");
	
	public MasterBean(){
	}
	

	  public Connection DBConnect()
	  {
	    Connection con = null;
	    Driver st_driver = null;
	    DataSource ds = null;
		try
	    {
	        Context initContext = new InitialContext();
	        Context envContext = (Context) initContext.lookup("java:comp/env");
	        
            Configuration configuration = new Configuration();
            String s = configuration.get("sepoa.app.weblogic.datasource");
            
	        ds = (DataSource) envContext.lookup(s);
	        
	        if (envContext == null) {
	            throw new Exception("Error: No Context");
	        }
	        if (ds == null) {
	            throw new Exception("Error: No DataSource");
	        }
	        
	        con = ds.getConnection();
	    }
	    catch(Exception e)
	    {
	    	st_driver = null;
	    	
	    }
//	 yh01 ��**********************************/

	    return con;
	  }	
	  
	  
	  public void DBClose(Connection con)
	  {
	    try
	    {
	    	if(con != null){
	    		con.close();
	    	}
	    }
	    catch(Exception e)
	    {
	    	con = null;
	    	
	    }
	  }	  	  



//**********************************************************************
//���� ��� �Ϲ�ȭ��Ų �Լ�
//**********************************************************************

// SELECT ���� ���� ���� ���� ���ȭ�� �Լ�
// nReturn�� �������� �޾ƿ� column������ ó���� 1�� �����ؼ� ī��Ʈ�Ѵ�.
public void executeSelectQuery(PreparedStatement pstmt, Vector rtnValue, int nReturn) throws Exception
{

ResultSet rset = null;

rset = pstmt.executeQuery();


// ���ͷ� ��� �޾ƿ�
while(rset.next())
{
  for(int i=1;i<=nReturn;i++) rtnValue.addElement(rset.getString(i));
}
}

// �Ϲ����� SQL�� ������ ���� ó�� �Լ�
// �� : DB����, SQL����, ��� ����, ������ �÷��� ��, ���� ����
public void generalSelect(Connection con, String sql, Vector rtnValue, int nReturn, Vector errorMsg) throws Exception
{
// ���� ������ ���� ����
PreparedStatement pstmt = null;
ResultSet rset = null;

try
{
  
  Logger.debug.println("MasterBean", this, sql);
  
  // ������ ����
  pstmt = con.prepareStatement(sql);
  executeSelectQuery(pstmt, rtnValue, nReturn);      
}
catch(SQLException e)
{
	
	Logger.debug.println("MasterBean", this, "�ڡڡڡڡ�"+new Exception().getStackTrace()[0].getMethodName()+"="+e);
  // ���� Exception�� ���ͷ� ����
  while(e!=null)
  {
    errorMsg.addElement(e);
    e = e.getNextException();
  }
}
finally
{
  if (rset!=null)  rset.close();
  if (pstmt!=null) pstmt.close();
}
}



public void executeSelectQueryNew(PreparedStatement pstmt, Vector rtnValue, int nReturn) throws Exception
{

ResultSet rset = null;

rset = pstmt.executeQuery();

ResultSetMetaData rsmd = rset.getMetaData();

String colName = null;
String colType = null;

//System.out.println("#rset.getRow()=>"+rset.getRow());
// ���ͷ� ��� �޾ƿ�
while(rset.next())
{
	
	
  //for(int i=1;i<=nReturn;i++) rtnValue.addElement(rset.getString(i));
	
    HashMap vo = new HashMap();
    
    for (int j = 1; j <= rsmd.getColumnCount(); j++) {
    	//System.out.println("#KKKKKKKKKKKKKKK"+rset.getString(j));
		 colName = rsmd.getColumnName(j);
		 colType = rsmd.getColumnTypeName(j);
         if (rset.getObject(j) != null){      
        	 vo.put(colName, rset.getString(j));
         } else {
        	 vo.put(colName, ""); 
         }
    }
    rtnValue.add(rtnValue.size(), vo);                 	
}
}

public void generalSelectNew(Connection con, String sql, Vector rtnValue, int nReturn, Vector errorMsg) throws Exception
{
// ���� ������ ���� ����
PreparedStatement pstmt = null;
ResultSet rset = null;

try
{
  Logger.debug.println("MasterBean", this, sql);
	
  // ������ ����
  pstmt = con.prepareStatement(sql);
  executeSelectQueryNew(pstmt, rtnValue, nReturn);      
}
catch(SQLException e)
{
	Logger.debug.println("MasterBean", this, "�ڡڡڡڡ�"+new Exception().getStackTrace()[0].getMethodName()+"="+e);
	
	
  // ���� Exception�� ���ͷ� ����
  while(e!=null)
  {
    errorMsg.addElement(e);
    e = e.getNextException();
  }
}
finally
{
  if (rset!=null)  rset.close();
  if (pstmt!=null) pstmt.close();
  //DBClose(con, errorMsg);  
}
}  

// ��� ���� String�� ��� ����ϴ� �Լ�
// 1���� ���� ���������� �������� ����, �ƴϸ� null�� ����
public String singleSelect(Connection con, String sql, Vector errorMsg) throws Exception
{
// ���� ������ ���� ����
PreparedStatement pstmt = null;
ResultSet rset = null;
String temp = null;

try
{
  // ������ ����
  pstmt = con.prepareStatement(sql);
  rset = pstmt.executeQuery();

           
  Logger.debug.println("MasterBean", this, sql);
  //System.out.println("��singleSelect().errorMsg.size() ="+errorMsg.size());   
  
  // ��Ʈ������ ����� �޴´�.
  if (rset.next()) temp = rset.getString(1);
  else temp = null;
}
catch(SQLException e)
{
	Logger.debug.println("MasterBean", this, "�ڡڡڡڡ�"+new Exception().getStackTrace()[0].getMethodName()+"="+e);
	
  // ���� Exception�� ���ͷ� ����
  while(e!=null)
  {
    errorMsg.addElement(e);
    e = e.getNextException();
  }
}
finally
{
  if (rset!=null)  rset.close();
  if (pstmt!=null) pstmt.close();
}

return temp;
}

// �Ϲ����� INSERT, UPDATE, DELETE ������ ó���ϴ� �Լ�
// retNum�� ����� row���� �޴´�.
public int generalExecute(Connection con, String sql, Vector errorMsg) throws Exception
{
// ���� ������ ���� ����
PreparedStatement pstmt = null;
ResultSet rset = null;
int retNum = 0;

try
{
	
	Logger.debug.println("MasterBean", this, sql);
  // ������ ����
  pstmt = con.prepareStatement(sql);
  retNum = pstmt.executeUpdate();
}
catch(SQLException e)
{
	Logger.debug.println("MasterBean", this, "�ڡڡڡڡ�"+new Exception().getStackTrace()[0].getMethodName()+"="+e);
	
  // ���� Exception�� ���ͷ� ����
  while(e!=null)
  {
    errorMsg.addElement(e);
    e = e.getNextException();
  }
}
finally
{
  if (rset!=null)  rset.close();
  if (pstmt!=null) pstmt.close();
}

return retNum;
}
 
}//END MAIN CLASS
