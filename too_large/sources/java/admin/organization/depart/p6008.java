package admin.organization.depart; 
 

import java.util.Map;

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

public class p6008 extends SepoaService 
{ 
 
	public p6008(String opt,SepoaInfo info) throws SepoaServiceException 
	{ 
		super(opt,info); 
		setVersion("1.0.0"); 
	}
	Message msg = new Message(info,"FW"); 
 
 
	/** 
	* depart search
	*/ 
	public SepoaOut getMainternace(Map<String, String> header)
	{ 
		try 
		{ 
	        String user_id = info.getSession("ID"); 
			Logger.debug.println(user_id,this,"######getMainternace#######"); 
			String rtn = ""; 
			// Isvalue(); .... 
			rtn = et_getMainternace(header); 
 
			setValue(rtn); 
			setStatus(1); 
			setMessage(msg.getMessage("0000")); 
		}catch(Exception e) 
		{ 
		    Logger.err.println("Exception e =" + e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0001")); 
			Logger.err.println(this,e.getMessage()); 
		} 
		return getSepoaOut(); 
	} 
 
 
	private String et_getMainternace(Map<String, String> header) throws Exception 
	{ 
		String rtn = ""; 
		ConnectionContext ctx = getConnectionContext();
		header.put("I_HOUSE_CODE", info.getSession("HOUSE_CODE"));
		
		try 
		{
			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
			wxp.addVar("dept_name", header.get("I_DEPT_NAME"));
			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,wxp.getQuery());
			
			
			 
			rtn = sm.doSelect(header); 
 
			if(rtn == null) throw new Exception("SQL Manager is Null"); 
    	}
		catch(Exception e) 
		{ 
			throw new Exception("et_getMainternace:"+e.getMessage()); 
    	} 
		finally
    	{ 
		 
		} 
		return rtn; 
	} 
 
	
	/**
	 * depart save 
	 */
	// before save - 부서코드 중복체크
	public SepoaOut getDuplicate(String[] args){ 
 
		String user_id = info.getSession("ID"); 
		String rtn = null; 
		try 
		{ 
			Logger.debug.println(user_id,this,"######getDuplicate#######"); 
			// Isvalue(); .... 
			rtn = Check_Duplicate(args, user_id); 
 
			setValue(rtn); 
			setStatus(1); 
 			setMessage(msg.getMessage("0000")); 
		}catch(Exception e) 
		{ 
			setStatus(0); 
			setMessage(msg.getMessage("0001")); 
			Logger.err.println(user_id,this,"Exception e =" + e.getMessage()); 
		} 
		  return getSepoaOut(); 
	} 
	
	private String Check_Duplicate(String[] args, String user_id) 
	throws Exception 
	{ 
		String rtn = null; 
		String count = ""; 
	    String[][] str = new String[1][2]; 
 
   		ConnectionContext ctx = getConnectionContext(); 
    	try { 
    			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
	 
				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery()); 
	 
				//String[] args = {house_code, company_code,PLANT_CODE}; 
				rtn = sm.doSelect(args); 
				SepoaFormater wf = new SepoaFormater(rtn); 
				if(wf.getRowCount() == 0) count = "X"; 
				else { 
					str = wf.getValue(); 
					count = str[0][0]; 
				} 
				if(rtn == null) throw new Exception("SQL Manager is Null"); 
	    }catch(Exception e) { 
			throw new Exception("Check_Duplicate:"+e.getMessage()); 
	    } finally{ 
			//Release(); 
	} 
		return count; 
	} 	
	
	// 저장처리
	public SepoaOut setSave(String[] setData) throws Exception { 
		try { 
			String user_id = info.getSession("ID"); 
 			Logger.debug.println(user_id,this,"######setSave#######"); 
 
 			int rtn = 1;//transaction 성공 여부를 체크한다. "-1"이면, Rollback "0"이상이면 Commit 
 
			//부서등록 
			int row = et_setSave(setData); 
 
			setValue("Insert Row="+rtn); 
			setStatus(1); 
			setMessage(msg.getMessage("0000")); 
			if (rtn == 1) Commit(); 
		}catch(Exception e) { 
			Logger.err.println("Exception e =" + e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0003")); 
			Logger.err.println(this,e.getMessage()); 
			Rollback(); 
		} 
		return getSepoaOut(); 
	} 
  
	private int et_setSave(String[] setData) throws Exception 
	{ 
   		int rtn = -1; 
   		ConnectionContext ctx = getConnectionContext(); 
   		String user_id = info.getSession("ID");
    	try {
    			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 
				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery()); 
 
 
				//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
				String[] type = {"S","S","S","S","S", 
								 "S","S","S","S","S", 
								 "S","S","S","S","S", 
								 "S","S","S","S"}; 
				String[][] tmp = new String[1][]; 
				tmp[0] = setData; 
 
				rtn = sm.doInsert(tmp, type); 
				if(rtn == -1) throw new Exception("SQL Manager is Null"); 
				//else Commit(); 
				//Commit(); 
		    }catch(Exception e) { 
		    	//	Rollback(); 
					//throw new Exception("et_setSave:"+e.getMessage()); 
		    	Logger.err.println("Exception e =" + e.getMessage()); 
		    }
    	
    	
		return rtn; 
	} 

	/** 
	*depart display 
	*상세내용 보기 
	*/ 
	public SepoaOut getDis(String[] args){ 
 
		try 
		{ 
			String user_id = info.getSession("ID"); 
 			Logger.debug.println(user_id,this,"######getDis#######"); 
			String rtn = ""; 
			rtn = et_getDis(args, user_id); 
			setValue(rtn); 
			setStatus(1); 
			setMessage(msg.getMessage("0000")); 
 
		}catch(Exception e) 
		{ 
			Logger.err.println("Exception e =" + e.getMessage()); 
			setStatus(0); 
			setMessage(msg.getMessage("0001")); 
			Logger.err.println(this,e.getMessage()); 
		} 
		return getSepoaOut(); 
	} 
 
	private String et_getDis(String[] args, String user_id) throws Exception 
	{ 
		String rtn = ""; 
   		ConnectionContext ctx = getConnectionContext(); 
    	try { 
    			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());

				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery()); 
				rtn = sm.doSelect(args); 
				if(rtn == null) throw new Exception("SQL Manager is Null"); 
		    	} catch(Exception e) { 
					throw new Exception("et_getMainternace:"+e.getMessage()); 
		    	} finally{ 
				//Release(); 
		} 
		return rtn; 
	} 

	/**
	 * depart update
	 */
	public SepoaOut setChange(String[] setData){ 
		String user_id = info.getSession("ID"); 
		try 
		{ 
			Logger.debug.println(user_id,this,"######setUpdate#######"); 
 
			String cur_date = SepoaDate.getShortDateString(); 
			String cur_time = SepoaDate.getShortTimeString(); 
			String status = "R"; 
			/*setData : Table에서 가져온 Data 
				status	 : C:Create, R:Replace, D:Delete 
				cur_date: 등록날짜 
			   cur_time : 등록시간 
			*/ 
			int rtn = et_setChange(setData, status, cur_date, cur_time, user_id); 
 
			setValue("Change Row="+rtn); 
			setStatus(1); 
			setMessage(msg.getMessage("0000")); 
 
		}catch(Exception e) 
		{ 
			Logger.err.println(user_id,this,"Exception e =" + e.getMessage()); 
			setStatus(0); 
            setMessage(msg.getMessage("0002")); 
			//log err 
		} 
		return getSepoaOut(); 
	} 
 
 
 
	private int et_setChange(String[] setData, String status, String cur_date, String cur_time, String user_id) throws Exception 
	{ 
   		int rtn = -1; 
   		ConnectionContext ctx = getConnectionContext(); 
    	try {
    			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 
				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery()); 
 
				//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
				String[] type = {"S","S","S","S","S", 
								 "S","S","S","S","S", 
								 "S","S","S","S","S", 
								 "S","S","S","S","S"}; 
 
				String[][] tmp = new String[1][]; 
				tmp[0] = setData; 
 
				rtn = sm.doInsert(tmp, type); 
				Commit(); 
	    }catch(Exception e) { 
	    		//Rollback(); 
				throw new Exception("et_setSave:"+e.getMessage()); 
	    	} finally{ 
			//Release(); 
		} 
		return rtn; 
	} 

	/**
	 * depart delete 
	 */
	public SepoaOut setDelete(String[][] setData) throws Exception { 
		 
		try 
		{ 
			String user_id = info.getSession("ID"); 
			Logger.debug.println(user_id,this,"######setDelete#######"); 
			int rtn = 0;  
			rtn = et_setDelete(setData); 
 
			setValue("Delete Row="+rtn); 
			setStatus(1); 
          		setMessage(msg.getMessage("0000")); 
 
			Commit(); 
		}catch(Exception e) 
		{ 
			Logger.err.println("Exception e =" + e.getMessage()); 
			setStatus(0); 
          setMessage(msg.getMessage("0004")); 
          Rollback(); 
			Logger.err.println(this,e.getMessage()); 
		} 
		return getSepoaOut(); 
	} 
 
 
	private int et_setDelete(String[][] setData) throws Exception 
	{ 
   		int rtn = -1; 
   		ConnectionContext ctx = getConnectionContext();
   		String user_id = info.getSession("ID");
    	try {
    			SepoaXmlParser wxp = new SepoaXmlParser(this, new Exception().getStackTrace()[0].getMethodName());
 
				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,wxp.getQuery()); 
 
				//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.) 
				String[] type = {
						"S","S","S","S","S",
						"S","S","S"
				}; 
 
				rtn = sm.doInsert(setData, type); 
				if(rtn == -1) throw new Exception("SQL Manager is Null"); 
				else Commit(); 
	    }catch(Exception e) { 
				throw new Exception("et_setDelete:"+e.getMessage()); 
	    	} finally{} 
		return rtn; 
	} 
 	
} 
 
 
