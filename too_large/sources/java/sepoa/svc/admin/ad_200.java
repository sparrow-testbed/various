package sepoa.svc.admin;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.SepoaSQLManager;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;


public class AD_200 extends SepoaService
{
	String processId = "P60";
	String language = "KO"; //info.getSession("LANGUAGE"); Session객체가 없는 User을 위한 Util제공을 위해 세션객체는 사용하지 않는다.
	//String user_id = "LEPPLE";//info.getSession("ID");
    String user_id = info.getSession("ID");
//	Message msg = new Message(language, processId);
    Message msg = null;

	public AD_200(String opt,SepoaInfo info) throws SepoaServiceException
	{
		super(opt,info);
		msg = new Message(info, processId);
		setVersion("1.0.0");
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




	/* Display _icomptgl */

	public sepoa.fw.srv.SepoaOut getMainternace(String[] args){

		try
		{
			String user_id = info.getSession("ID");
			String rtn = null;

			rtn = getMainternace(args, user_id );
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}catch(Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this,e.getMessage());
		}
		  return getSepoaOut();
	}
	private String getMainternace(String[] args, String user_id)
	throws Exception
	{

		String rtn = null;
		String house_code = info.getSession("house_code");

   		ConnectionContext ctx = getConnectionContext();
    	try {
			StringBuffer tSQL = new StringBuffer();
			tSQL.append( " select                               \n ");
 			tSQL.append( " use_flag,code,                       \n ");
 			tSQL.append( " text1,text2,text3,flag ,text4        \n ");
 			tSQL.append( " from scode                        \n ");
 			tSQL.append( " where type = 'S000'               \n ");
 			tSQL.append("    and language = '" + info.getSession("LANGUAGE") + "' \n ");
 			tSQL.append( " <OPT=F,S> and code like ? </OPT>     \n ");
 			tSQL.append( " <OPT=F,S> and flag like ? </OPT>     \n ");
 			tSQL.append( " <OPT=F,S> and  ( text1 like ? </OPT> \n ");
       		tSQL.append( " <OPT=F,S> or     text2 like ? </OPT> \n ");
       		tSQL.append( " <OPT=F,S> or text3 like ? </OPT>     \n ");
       		tSQL.append( " <OPT=F,S> ) and text4 like ? </OPT>  \n ");
       		tSQL.append( "  and code != 'ID' and code != 'REVIEW'   \n ");
			tSQL.append( "  order by code                           \n ");


			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
			rtn = sm.doSelect(args);

			if(rtn == null) throw new Exception("SQL Manager is Null");
	    	}catch(Exception e) {
				throw new Exception("getMainternace:"+e.getMessage());
	    	} finally{
			//Release();
		}
		return rtn;
	}



	/**
	 * 고통팝업 코드 내용 상세 조회
         */
	public sepoa.fw.srv.SepoaOut getDisplay(String args){
		try
		{
			String user_id = info.getSession("ID");
			String rtn = null;

			rtn = getDisplay(args, user_id );
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}catch(Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(this,e.getMessage());
		}
		  return getSepoaOut();
	}
	private String getDisplay(String val, String user_id)
	throws Exception
	{

		String rtn = null;
		String house_code = info.getSession("house_code");

   		ConnectionContext ctx = getConnectionContext();
    		try {
			StringBuffer tSQL = new StringBuffer();
			tSQL.append( " select text2,use_flag ,flag,         \n ");
 			tSQL.append( "      text1,text3,text4,text5         \n ");
 			tSQL.append( " from scode                        \n ");
 			tSQL.append( " where  type = 'S000'               \n ");
 			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
 			tSQL.append( " <OPT=F,S> and code = ? </OPT>        \n ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());
			String[] args = {val};
			rtn = sm.doSelect(args);

			if(rtn == null) throw new Exception("SQL Manager is Null");
	    	}catch(Exception e) {
				throw new Exception("getMainternace:"+e.getMessage());
	    	} finally{
			//Release();
		}
		return rtn;
	}






	/**
	*Save
	*/
	public SepoaOut setSave(String[] setData){
		try
		{
			String user_id = info.getSession("ID");
			String HOUSE_CODE = info.getSession("HOUSE_CODE");

			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			/*setData : Table에서 가져온 Data
				status	 : C:Create, R:Replace, D:Delete
			*/
			int rtn = et_setSave(setData,  cur_date, cur_time, user_id,HOUSE_CODE);


			setValue("Insert Row="+rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}catch(Exception e)
		{

			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
			setMessage(msg.getMessage("0003"));
			Logger.err.println(this,e.getMessage());
			//log err
		}
		return getSepoaOut();
	}



	private int et_setSave(String[] setData,  String cur_date, String cur_time, String user_id,String HOUSE_CODE) throws Exception
	{
   		int rtn = -1;
   		ConnectionContext ctx = getConnectionContext();
    		try {

				StringBuffer tSQL = new StringBuffer();
				tSQL.append( " INSERT INTO scode ");
				tSQL.append( " (TYPE ,CODE , TEXT2, FLAG, TEXT1, TEXT3, TEXT4,  ");
				tSQL.append( " ADD_DATE, ADD_TIME, ADD_USER_ID, ");
				tSQL.append( " CHANGE_DATE , CHANGE_TIME , CHANGE_USER_ID , ");
				tSQL.append( " USE_FLAG, TEXT5, LANGUAGE ) ");
				tSQL.append( " VALUES ('S000' , ?, ?, ?, ?, ?, ?,  '"+cur_date+"','"+cur_time+"','"+user_id+"' ,  ");
				tSQL.append( " '"+cur_date+"','"+cur_time+"','"+user_id+"' , ?, ?, '" + info.getSession("LANGUAGE") + "'  ) ");

				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

				//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
				String[] type = {"S","S","S","S","S","S","S","S"};

				String[][] tmp = new String[1][];
				tmp[0] = setData;

				rtn = sm.doInsert(tmp, type);
				if(rtn == -1) throw new Exception("SQL Manager is Null");
				else Commit();
				Commit();
	    	}catch(Exception e) {
	    		Rollback();
				throw new Exception("et_setSave:"+e.getMessage());
	    	} finally{
			//Release();
		}
		return rtn;
	}


	/**
	 * 팝업 코드의 내용을 수정한다.
	 */
	public SepoaOut setChange(String[] setData){
		String user_id = info.getSession("ID");
		try
		{

			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			int rtn = et_setChange(setData, cur_date, cur_time, user_id);

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



	private int et_setChange(String[] setData, String cur_date, String cur_time, String user_id) throws Exception
	{
   		int rtn = -1;
   		ConnectionContext ctx = getConnectionContext();
    	try {

				String HOUSE_CODE = info.getSession("HOUSE_CODE");

				StringBuffer tSQL = new StringBuffer();
				tSQL.append( " UPDATE scode ");
				tSQL.append( " SET TEXT2 = ?, USE_FLAG =? ,FLAG = ?, TEXT1 = ?, TEXT3 = ?, TEXT4 = ?,  TEXT5 = ?, ");
				tSQL.append( " ADD_DATE = '"+cur_date+"', ADD_TIME = '"+cur_time+"', ADD_USER_ID = '"+ user_id +"', ");
				tSQL.append( " CHANGE_DATE = '"+cur_date+"', CHANGE_TIME = '"+cur_time+"', CHANGE_USER_ID = '"+ user_id +"' " );
				tSQL.append( " WHERE TYPE = 'S000'  ");
				tSQL.append( " AND CODE = ?  ");
				tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

				//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
				String[] type = {"S","S","S","S","S","S","S","S"};
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



	public SepoaOut setDelete(String[][] setData){
		try
		{
			String user_id = info.getSession("ID");
			int rtn = 0;

			setValue("Delete Row="+rtn);
			setStatus(1);
            setMessage(msg.getMessage("0000"));

            rtn = et_setDelete(setData,user_id);

			setValue("Delete Row="+rtn);
			setStatus(1);
            setMessage(msg.getMessage("0000"));

		}catch(Exception e)
		{
			Logger.err.println("Exception e =" + e.getMessage());
			setStatus(0);
            setMessage(msg.getMessage("0004"));
			Logger.err.println(this,e.getMessage());
		}
		return getSepoaOut();
	}




	private int et_setDelete(String[][] setData , String user_id) throws Exception
	{
   		int rtn = -1;
   		ConnectionContext ctx = getConnectionContext();
    	try {
				String HOUSE_CODE = info.getSession("HOUSE_CODE");
				StringBuffer tSQL = new StringBuffer();
				tSQL.append( " delete from scode ");
				tSQL.append( " where type = 'S000' ");
				tSQL.append( " and  CODE = ?  ");
				tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

				//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
				String[] type = {"S"};

				rtn = sm.doDelete(setData, type);
				if(rtn == -1) throw new Exception("SQL Manager is Null");
				else Commit();
	    }catch(Exception e) {
				throw new Exception("et_setDelete:"+e.getMessage());
	    	} finally{}
		return rtn;
	}





		public SepoaOut setReview(String[] setData){
		String user_id = info.getSession("ID");
		try
		{

			String cur_date = SepoaDate.getShortDateString();
			String cur_time = SepoaDate.getShortTimeString();

			int rtn = setReview(setData, cur_date, cur_time, user_id);

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



	private int setReview(String[] setData, String cur_date, String cur_time, String user_id) throws Exception
	{
   		int rtn = -1;
   		ConnectionContext ctx = getConnectionContext();
    	try {

				String HOUSE_CODE = info.getSession("HOUSE_CODE");
				StringBuffer tSQL = new StringBuffer();
				tSQL.append( " update scode ");
				tSQL.append( " set text2 = ?, flag = ?, text1 = ?, text3 = ?, text4 = ?, use_flag =? , ");
				tSQL.append( " ADD_DATE = '"+cur_date+"', ADD_TIME = '"+cur_time+"', ADD_USER_ID = '"+ user_id +"', ");
				tSQL.append( " CHANGE_DATE = '"+cur_date+"', CHANGE_TIME = '"+cur_time+"', CHANGE_USER_ID = '"+ user_id +"' ");
				tSQL.append( " where type = 'S000'  ");
				tSQL.append( " and CODE = 'REVIEW'  ");
				tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

				//넘기는 데이타의 type : String S, Number N(int, double 모두 포함.)
				String[] type = {"S","S","S","S","S","S" };
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





	/* 중복체크 */

	public SepoaOut getDuplicate(String args){

		String user_id = info.getSession("ID");
		String rtn = null;
		try
		{
			//Logger.debug.println(user_id,this,"######getDuplicate#######");
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
	private String Check_Duplicate(String val, String user_id)
	throws Exception
	{
		String rtn = null;
		String count = "";
	    String[][] str = new String[1][2];

   		ConnectionContext ctx = getConnectionContext();
    	try {
			StringBuffer tSQL = new StringBuffer();

			String HOUSE_CODE = info.getSession("HOUSE_CODE");
			tSQL.append( " select ");
 			tSQL.append( " count(*) ");
 			tSQL.append( " from scode ");
 			tSQL.append( " where type = 'S000'  ");
 			tSQL.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");
 			tSQL.append( " <OPT=F,S> and code = ? </OPT> ");

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

			String[] args = {val};
			rtn = sm.doSelect(args);
			SepoaFormater wf = new SepoaFormater(rtn);
			str = wf.getValue();
			count = str[0][0];
			if(rtn == null) throw new Exception("SQL Manager is Null");
	    	}catch(Exception e) {
				throw new Exception("Check_Duplicate:"+e.getMessage());
	    	} finally{
			//Release();
		}
		return count;
	}




	/** sql 이 정확한지 확인하기 위해 필요한 method
	 */
	public SepoaOut VerifyDB(String args){

		boolean existwhere = false; // where 문이 있는지 여부
		boolean existorder = false; // order 문이 있는지 여부
		boolean existgroup = false; // group 문이 있는지 여부

		int index =0;

		int indexwhere =0;
		int indexorder =0;
		int indexgroup =0;

		String user_id = info.getSession("ID");
		String[] v = new String[10];
		String[] change = new String[2];

		//Logger.debug.println(user_id,this,"args = " + args);

		String pargs ="";
		// ?  -> ' '바꿈
		for (int i =0; i < args.length(); i++)
		 if (args.charAt(i) == '?') {
		  change[0] = args.substring(0,i);
		  change[1] = args.substring(i+1,args.length());
		  args = change[0] + " '' " + change[1];
		 }


		//  rownum = 1 을 sql 에 붙이기 위한 작업

		indexwhere = args.lastIndexOf("WHERE");
		if ( indexwhere  == -1)
			;
			// where 없다.
		else {  //where 있다.
			  existwhere =true;
		}


		indexorder = args.lastIndexOf("ORDER BY");
		if ( indexorder  == -1 || indexorder < indexwhere) {   // order이 not exist 때
			;


		}else {  //order 가 있다.

			  existorder =true;

				 v[1] = args.substring(0,indexorder);
					//  ~order 전
				 v[2] = args.substring(indexorder,args.length());
		}

		// GROUP BY 절이 오면 rownum = 1 을 이것 앞에 놓아야 한다.
		// order by는 group by 뒤에 위치됨으로 신경쓸 필요업다.
		indexgroup = args.lastIndexOf("GROUP BY");



		if ( indexgroup  == -1 || indexgroup < indexwhere) {   // group이 not exist 때
			;
		}else {  //group이 있다.


			  existgroup =true;

				 v[1] = args.substring(0,indexgroup);
					//  ~group 전
				 v[2] = args.substring(indexgroup,args.length());
		}


		/*
		Logger.debug.println(user_id,this,"indexwhere = " + indexwhere);
		Logger.debug.println(user_id,this,"indexorder = " + indexorder);
		Logger.debug.println(user_id,this,"existwhere = " + existwhere);
		Logger.debug.println(user_id,this,"existorder = " + existorder);
		Logger.debug.println(user_id,this,"existgroup = " + existgroup);
		*/
		if(SEPOA_DB_VENDOR.equals("ORACLE")){
			if ((existwhere == false) && (existorder == false || existgroup == false ))
			pargs = args + " WHERE ROWNUM = 1 ";
			if ((existwhere == true) && (existorder == false  || existgroup == false ))
			pargs = args + " AND ROWNUM = 1 ";
			if ((existwhere == false) && (existorder == true  || existgroup == true ))
			pargs = v[1] + " WHERE ROWNUM = 1 " + v[2];
			if ((existwhere == true) && (existorder == true   || existgroup == true ))
			pargs = v[1] + " AND ROWNUM = 1 " + v[2];
		}else if(SEPOA_DB_VENDOR.equals("MYSQL")){
			if ((existwhere == false) && (existorder == false || existgroup == false ))
			pargs = args + " LIMIT 1  ";
			if ((existwhere == true) && (existorder == false  || existgroup == false ))
			pargs = args + " LIMIT 1 ";
			if ((existwhere == false) && (existorder == true  || existgroup == true ))
			pargs = v[1] + " LIMIT 1 " + v[2];
			if ((existwhere == true) && (existorder == true   || existgroup == true ))
			pargs = v[1] + " LIMIT 1 " + v[2];
		}

		//Logger.debug.println(user_id,this,"pargs = " + pargs);

		String rtn = null;
		try
		{
			rtn = VerifyDB(pargs, user_id);

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
	private String VerifyDB(String val, String user_id)
	throws Exception
	{
		String rtn = null;
		String resultv = "";
	    String[][] str = new String[1][2];

   		ConnectionContext ctx = getConnectionContext();
    	try {
			StringBuffer tSQL = new StringBuffer();

			tSQL.append(val);

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,tSQL.toString());

			rtn = sm.doSelect((String[])null);
			SepoaFormater wf = new SepoaFormater(rtn);


			//str = wf.getValue();
			//count = str[0][0];
			if(rtn == null) throw new Exception("SQL Manager is Null");

			resultv = "Verified SQL Successfully";

	    }catch(Exception e) {
				//throw new Exception("Check_Duplicate:"+e.getMessage());
				resultv = e.getMessage();
	    }

		return resultv;
	}


	/*어떤 코드들이 사용되지 않는 코드인지 찾아서 보여준다.*/
public sepoa.fw.srv.SepoaOut getCode(String[] args) {
		String user_id = info.getSession("ID");
		String house_code = info.getSession("house_code");

		try {
			String rtn = null;
			rtn = et_getCode(user_id, args, house_code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0000"));
		}catch(Exception e){
			
			setStatus(0);
			setMessage(msg.getMessage("0001"));
			Logger.err.println(user_id,this, e.getMessage());
		}
		return getSepoaOut();
	}

	public String et_getCode(String user_id, String[] args, String house_code) throws Exception {
		String result = null;
		ConnectionContext ctx = getConnectionContext();
		try {
				StringBuffer tSQL = new StringBuffer();


				if(SEPOA_DB_VENDOR.equals("ORACLE")){
					tSQL.append(" 	select '"+args[0]+"'||code 													\n");
	  				tSQL.append("  	from (  																		\n");
	            	tSQL.append(" 		select LTRIM(RTRIM(to_char(rownum,'0000'))) as code 								\n");
	               	tSQL.append("  		from scode 																\n");
	            	tSQL.append("		where type ='S000' and  rownum < 10000 	\n");
	            	tSQL.append("         and language = '" + info.getSession("LANGUAGE") + "' \n ");
	            	tSQL.append(" 	minus 																			\n");
	           		tSQL.append("		select substr(code,3) 														\n");
	             	tSQL.append(" 		from scode 																\n");
	             	tSQL.append(" 		where  type ='S000' 															\n");
	             	tSQL.append("          and language = '" + info.getSession("LANGUAGE") + "' \n ");
	              	tSQL.append(" <OPT=F,S> and flag = ? 	                   </OPT>								\n");
	       			tSQL.append(" 		)																			\n");
					tSQL.append(" 	WHERE ROWNUM < 2																\n");
				}else if(SEPOA_DB_VENDOR.equals("MYSQL")){
					tSQL.append(" 	select concat('"+args[0]+"',code )													\n");
	  				tSQL.append("  	from (  																		\n");
	            	tSQL.append(" 		select LTRIM(RTRIM(to_char(rownum,'0000'))) as code 								\n");
	               	tSQL.append("  		from scode 																\n");
	            	tSQL.append("		where type ='S000' limit < 10000 	\n");
	            	tSQL.append("        and language = '" + info.getSession("LANGUAGE") + "' \n ");
	        		tSQL.append(" 	minus 																			\n");
	           		tSQL.append("		select substr(code,3) 														\n");
	             	tSQL.append(" 		from scode 																\n");
	             	tSQL.append(" 		where  type ='S000' 															\n");
	             	tSQL.append("          and language = '" + info.getSession("LANGUAGE") + "' \n ");
	              	tSQL.append(" <OPT=F,S> and flag = ? 	                   </OPT>								\n");
	       			tSQL.append(" 		)																			\n");
					tSQL.append(" 	WHERE limit 1																\n");
				}


				SepoaSQLManager sm = new SepoaSQLManager(user_id, this, ctx, tSQL.toString());
				result = sm.doSelect(args);
				if(result == null) throw new Exception("SQLManager is null");
		}catch(Exception ex) {
			throw new Exception("et_getCode()"+ ex.getMessage());
		}
		return result;
	}


	/*****************   Server popup *****************/

		public SepoaOut getCodeMaster(String code){

		try
		{
			String rtn = "";

			//Query 수행부분 Call
			rtn = et_getCodeMaster(code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		}catch(Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			//Logger.err.println(info.getSession("ID"),this,e.getMessage());
		}
		return getSepoaOut();
	}


/**
 *메소드명 	: et_getCodeMaster
 *Description : 제목 가져오기
 *Argument :
 **/

	private String et_getCodeMaster(String code) throws Exception
	{
		String rtn = "";
		String house_code = info.getSession("house_code");
   		ConnectionContext ctx = getConnectionContext();


    	try {
			StringBuffer sql = new StringBuffer();
			if(SEPOA_DB_VENDOR.equals("ORACLE")){
				 sql.append( " SELECT CODE, ISNULL(text1, ' '), ISNULL(text2,' ') ");
			}else if(SEPOA_DB_VENDOR.equals("MYSQL")){
				 sql.append( " SELECT CODE, IFNULL(text1, ' '), IFNULL(text2,' ') ");
			}

            sql.append( " FROM scode ");
            sql.append( " WHERE TYPE = 'S000' AND CODE ='"+code+"'  ");
            sql.append("   and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
			String[] args = {};
			rtn = sm.doSelect((String[])null);

			if(rtn == null) throw new Exception("SQL Manager is Null");

	    	}catch(Exception e) {
				throw new Exception("et_getCodeMaster:"+e.getMessage());
	    	}finally{
			}
		return rtn;
	}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 *메소드명 	: getCodeColumn()
 *Description   :  1. EP 코드 조회 ( oep_pp_lis3.jsp에서 호출 )
                  		2. getCodeColumn() call
                  		3. 헤더부분 값 가져오기
 *작성일        : 2001.08.03
 **/
	public SepoaOut getCodeColumn(String code){
		String rtn = "";
		try {
					//Query 수행부분 Call
					rtn = et_getCodeColumn(code);
					//Logger.debug.println("getCode","result====>"+rtn);
					setValue(rtn);
					setStatus(1);
					setMessage(msg.getMessage("0001"));
				}catch(Exception e)
				{
					setStatus(0);
					setMessage(msg.getMessage("0002"));
					Logger.err.println(info.getSession("ID"),this,e.getMessage());
				}
				return getSepoaOut();
		}


/**
 *메소드명 	: et_getCodeColumn
 *Description : 제목 가져오기
 *Argument :
 **/

	private String et_getCodeColumn(String code) throws Exception
	{
		String rtn = "";
		String house_code = info.getSession("house_code");

   		ConnectionContext ctx = getConnectionContext();

    	try {
			StringBuffer sql = new StringBuffer();
            sql.append( " SELECT TEXT3 ");
            sql.append( " FROM scode ");
            sql.append( " WHERE TYPE = 'S000' AND CODE ='"+code+"'  ");
            sql.append("   and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
			String[] args = {};
			rtn = sm.doSelect((String[])null);

			if(rtn == null) throw new Exception("SQL Manager is Null");

	    	}catch(Exception e) {
				throw new Exception("et_getCodeMaster:"+e.getMessage());
	    	}finally{
			}
		return rtn;
	}




///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *메소드명 	: getCodeSearch()
 *Description   : 1. Code 코드 조회 ( oep_pp_lis2.jsp에서 호출 )
                  2. et_getCodeSearch() call
 *작성일        : 2001.09.21
 **/

	public SepoaOut getCodeSearch(String code, 	//CODE_ID
														String[] values){	//조회 DESCRIPTION

		try
		{
			String rtn = "";

			//Query 수행부분 Call
			rtn = et_getCodeSearch(code, values);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		}catch(Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(user_id,this,e.getMessage());
		}
		return getSepoaOut();
	}


/**
 *메소드명 	: et_getCodeSearch
 *Description : Code 내용을 조회한다.
 *Argument :
 **/

	private String et_getCodeSearch(String code, 	//CODE_ID
														String[] values)  throws Exception
	{
		String rtn = "";
   		ConnectionContext ctx = getConnectionContext();

    	try {
				StringBuffer sql = new StringBuffer();

				//Code ID로 등록된 Query문을 Select해 온다.
				String query = et_getCodeQuery(code);

				SepoaFormater wf = new SepoaFormater(query);

				query = wf.getValue("TEXT4",0);

//                Logger.debug.println(user_id+">>>>>>>>>>>>>>>>>>>>>>>>",this,query);

				String tmp = "";
				String tmp_s = ""; //인자로 나눠진 앞부분을 담는다.
				String tmp_e = ""; //인자로 나눠진 뒷부분을 담는다.


				if (values != null)  {
					//파라미터값 Set
					for(int i = 0; i<values.length; i++)	 {
						if (values[i] == null) values[i] = "";
//                        Logger.debug.println(user_id+">>>>>>>>>>>>>>>>>>>>>>>>",this,"values["+i+"]==="+values[i]);
//System.out.println("values["+i+"]==="+values[i]);
						int index_start = query.indexOf("?");

						//인자로 나눠진 앞부분
						tmp_s = query.substring(0, index_start);
						//인자로 나눠진 뒷부분
						tmp_e = query.substring(index_start+1);

//						인자값인지, like문에 들어가는 인자값인지 구분한다.
						if (tmp_e.length() != 0) tmp = query.substring(index_start-1, index_start+2);
//						like문에 들어가는 인자값일 경우
						if (tmp.equals("%?%")) {
							query = tmp_s +values[i]+ tmp_e;
//System.out.println("query_%?%==="+query);
						} else {
							query = tmp_s+" '"+values[i]+"' "+tmp_e;
						}
					}


				}

				//ROWNUM <= 500 에 관한내용 4.11 이 부분이 필요하지 낳을것이라 판단됨.
				//frame work에 숫자제한기능이 있음
				//query = addrownum(query);

				Logger.debug.println(user_id,this,")))))))))))) query ===>" + query);

				//long startTime = System.currentTimeMillis();// 시간체크 용
				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,query);
				rtn = sm.doSelect((String[])null);
			    //long endTime = System.currentTimeMillis();// 시간체크 용

				//Logger.debug.println(user_id,this,"DelayTime = " + (endTime - startTime ));

Logger.debug.println(user_id,this,"rtn ========" + rtn + "--------");
//System.out.println("Final=======RTN==="+rtn);
				if(rtn == null) throw new Exception("SQL Manager is Null");

		    	}catch(Exception e) {
					//throw new Exception("et_getCodeSearch:"+stackTrace(e));
		    		Logger.err.println(info.getSession("ID"),this,e.getMessage());
		    	}
    	
			return rtn;
	}


	/**
	 * ListBoxArr에서 호출한다.
	 * <pre>
	 * 조회하고자하는 코드들을 한꺼번에 가져온다.
	 * et_getCodeSearchArr, et_getCodeQueryArr 를 이용한다.
	 * </pre>
	 * @param code
	 * @param values
	 * @return
	 */
	public SepoaOut getCodeSearchArr(String[] codes, String[] params)
	{
		try
		{
			String rtn = "";
			for(int i=0;i<codes.length;i++)
			{
				String[] values =  CommonUtil.getTokenData(params[i],"#");
				rtn = et_getCodeSearchArr(codes[i], values);
				setValue(rtn);
			}
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		}catch(Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(user_id,this,e.getMessage());
		}
		return getSepoaOut();
	}



	private String et_getCodeSearchArr(String code, String[] values)  throws Exception
	{
		String rtn = "";
   		ConnectionContext ctx = getConnectionContext();

    	try
    	{
    		String query = et_getCodeQuery(code);

			SepoaFormater wf = new SepoaFormater(query);
	        query = wf.getValue("TEXT4",0);

	        String tmp = "";
			String tmp_s = ""; //인자로 나눠진 앞부분을 담는다.
			String tmp_e = ""; //인자로 나눠진 뒷부분을 담는다.


			if (values != null)
			{
				for(int i = 0; i<values.length; i++)
				{
					if (values[i] == null) values[i] = "";
					int index_start = query.indexOf("?");

					tmp_s = query.substring(0, index_start);
					tmp_e = query.substring(index_start+1);

					if (tmp_e.length() != 0)
						tmp = query.substring(index_start-1, index_start+2);

					if (tmp.equals("%?%"))
					{
						query = tmp_s +values[i]+ tmp_e;
						continue;
					}

					query = tmp_s+" '"+values[i]+"' "+tmp_e;

				}
			}

			SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,query);
			rtn = sm.doSelect((String[])null);

			if(rtn == null)
				throw new Exception("SQL Manager is Null");

		}
    	catch(Exception e)
		{
			//throw new Exception("et_getCodeSearch:"+stackTrace(e));
    		Logger.err.println(info.getSession("ID"),this,e.getMessage());
	    }

		return rtn;
	}

	// rownum <= 500 추가하는 데 쓰임
	private String addrownum(String args) {
		boolean existwhere = false; // where 문이 있는지 여부
		boolean existorder = false; // order 문이 있는지 여부
		boolean existgroup = false; // group 문이 있는지 여부


		int index =0;

		int indexwhere =0;
		int indexorder =0;
		int indexgroup =0;

		String user_id = info.getSession("ID");
		String[] v = new String[10];
		String pargs ="";
		//  rownum <= 500 을 sql 에 붙이기 위한 작업

		indexwhere = args.lastIndexOf("WHERE");
		if ( indexwhere  == -1)
			;

			// where 없다.

		else {  //where 있다.

			  existwhere =true;
		}


		indexorder = args.lastIndexOf("ORDER BY");
		if ( indexorder  == -1 || indexorder < indexwhere ) {   // order이 not exist 때

			;


		}else {  //order 가 있다.

			  existorder =true;

				 v[1] = args.substring(0,indexorder);
					//  ~order 전
				 v[2] = args.substring(indexorder,args.length());
		}

		// GROUP BY 절이 오면 rownum = 500 을 이것 앞에 놓아야 한다.
		// order by는 group by 뒤에 위치됨으로 신경쓸 필요업다.



		indexgroup = args.lastIndexOf("GROUP BY");
		if ( indexgroup  == -1 || indexgroup < indexwhere ) {   // group이 not exist 때
			;
		}else {  //group이 있다.


			  existgroup =true;

				 v[1] = args.substring(0,indexgroup);
					//  ~group 전
				 v[2] = args.substring(indexgroup,args.length());
		}



		/*
		Logger.debug.println(user_id,this,"indexwhere = " + indexwhere);
		Logger.debug.println(user_id,this,"indexorder = " + indexorder);
		Logger.debug.println(user_id,this,"existwhere = " + existwhere);
		Logger.debug.println(user_id,this,"existorder = " + existorder);
		Logger.debug.println(user_id,this,"existgroup = " + existgroup);
		*/
		if(SEPOA_DB_VENDOR.equals("ORACLE")){
			if ((existwhere == false) && (existorder == false || existgroup == false ))
			pargs = args + " WHERE ROWNUM <= 500 ";
			if ((existwhere == true) && (existorder == false  || existgroup == false ))
			pargs = args + " AND ROWNUM <= 500 ";
			if ((existwhere == false) && (existorder == true  || existgroup == true ))
			pargs = v[1] + " WHERE ROWNUM <= 500 " + v[2];
			if ((existwhere == true) && (existorder == true   || existgroup == true ))
			pargs = v[1] + " AND ROWNUM <= 500 " + v[2];
		}else if(SEPOA_DB_VENDOR.equals("MYSQL")){
			if ((existwhere == false) && (existorder == false || existgroup == false ))
			pargs = args + " LIMIT 500 ";
			if ((existwhere == true) && (existorder == false  || existgroup == false ))
			pargs = args + " LIMIT 500 ";
			if ((existwhere == false) && (existorder == true  || existgroup == true ))
			pargs = v[1] + " LIMIT 500 " + v[2];
			if ((existwhere == true) && (existorder == true   || existgroup == true ))
			pargs = v[1] + " LIMIT 500 " + v[2];
		}


		//Logger.debug.println("JHYOON",this,"pargs = " + SepoaString.replace(pargs,"\n",""));
		return pargs;
	}




/**
 *메소드명 	: et_getCodeQuery
 *Description : 제목 가져오기
 *Argument :
 **/

	private String et_getCodeQuery(String code) throws Exception
	{
		String rtn = "";
		String house_code = info.getSession("house_code");

   		ConnectionContext ctx = getConnectionContext();

    	try {
			StringBuffer sql = new StringBuffer();

            sql.append( " SELECT TEXT4 ");
            sql.append( " FROM scode ");
            sql.append( " WHERE TYPE = 'S000' AND CODE ='"+code+"'  ");
            sql.append("   and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
			String[] args = {};
			rtn = sm.doSelect((String[])null);
			if(rtn == null) throw new Exception("SQL Manager is Null");

	    	}catch(Exception e) {
				throw new Exception("et_getCodeQuery:"+e.getMessage());
	    	}finally{
			}
			Logger.err.println("★★★★★★★★★★★★★★★★★★★★★★★★"+rtn);
		return rtn;
	}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 *메소드명 	: getCodeFlag()
 *Description   :  1. 서비스될 타입 설정.


 *작성일        : 2001.08.03
 **/
	public SepoaOut getCodeFlag(String code){
		String rtn = "";
		try {

					//Query 수행부분 Call
					rtn = et_getCodeFlag(code);
					setValue(rtn);
					setStatus(1);
					setMessage(msg.getMessage("0001"));
				}catch(Exception e)
				{
					setStatus(0);
					setMessage(msg.getMessage("0002"));
					Logger.err.println(info.getSession("ID"),this,e.getMessage());
				}
				return getSepoaOut();
		}


/**
 *메소드명 	: et_getCodeFlag
 *Description : 1. 서비스될 타입 설정.
 *Argument :
 **/

	private String et_getCodeFlag(String code) throws Exception
	{
		String rtn = "";
		String house_code = info.getSession("house_code");

   		ConnectionContext ctx = getConnectionContext();

    		try {
			StringBuffer sql = new StringBuffer();
    		sql.append( " SELECT FLAG, TEXT5 ");
    		sql.append( " FROM scode ");
    		sql.append( " WHERE TYPE = 'S000' AND CODE ='"+code+"'  ");
    		sql.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
			String[] args = {};
			rtn = sm.doSelect((String[])null);

			if(rtn == null) throw new Exception("SQL Manager is Null");

	    	}catch(Exception e) {
				throw new Exception("et_getCodeMaster:"+e.getMessage());
	    	}finally{
		}
		return rtn;
	}

	/**
	 * 다중 코드 조회를 위해 사용된다.
	 * @param code
	 * @return
	 */
	public SepoaOut getCodeFlagArr(String code){
		String rtn = "";
		try {
			//Query 수행부분 Call
			rtn = et_getCodeFlagArr(code);
			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		}catch(Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
		}
		return getSepoaOut();
	}

	private String et_getCodeFlagArr(String code) throws Exception
	{
		String rtn = "";
		String house_code = info.getSession("house_code");

   		ConnectionContext ctx = getConnectionContext();

		try
		{
			StringBuffer sql = new StringBuffer();
			sql.append( " SELECT FLAG, TEXT5, CODE                    \n");
			sql.append( " FROM scode                               \n");
			sql.append( " WHERE TYPE = 'S000' AND CODE IN ("+code+")  \n");
			sql.append(" and language = '" + info.getSession("LANGUAGE") + "' \n ");

			SepoaSQLManager sm = new SepoaSQLManager(info.getSession("ID"),this,ctx,sql.toString());
			rtn = sm.doSelect((String[])null);

		if(rtn == null)
			throw new Exception("SQL Manager is Null");

    	}
		catch(Exception e) {
			throw new Exception("et_getCodeMaster:"+e.getMessage());
    	}
    	finally{
    	}
		return rtn;
	}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//코드POPUP Manual조회시 Desc를 보여준다.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *메소드명 	: getPOPUP_Search()
 *Description   : 1. Manual로 입력된 코드로 해당 Desc를 조회한다.
                  	  2. getPOPUP_Search() call
 *작성일        : 2001.09.21
 **/

	public SepoaOut getPOPUP_Search(String sql){	//조회 DESCRIPTION

		try
		{
			String rtn = "";

			//Query 수행부분 Call
			rtn = et_getPOPUP_Search(sql);

			SepoaFormater wf = new SepoaFormater(rtn);
			int rowCount = wf.getRowCount();

			if(rowCount != 0)	{
				for ( int i = 0; i<wf.getRowCount(); i++) {
					for ( int j = 0; j<wf.getColumnCount(); j++) {
						rtn = wf.getValue(i,j);
					}
				}
			} else {
				rtn = "Not Defined";
			}//if

			setValue(rtn);
			setStatus(1);
			setMessage(msg.getMessage("0001"));
		}catch(Exception e)
		{
			setStatus(0);
			setMessage(msg.getMessage("0002"));
			Logger.err.println(info.getSession("ID"),this,e.getMessage());
		}
		return getSepoaOut();
	}


/**
 *메소드명 	: et_getPOPUP_Search
 *Description : Code 내용을 조회한다.
 *Argument :
 **/

	private String et_getPOPUP_Search(String sql)  throws Exception
	{
		String rtn = "";
   		ConnectionContext ctx = getConnectionContext();

    	try {
				SepoaSQLManager sm = new SepoaSQLManager(user_id,this,ctx,sql);
				rtn = sm.doSelect((String[])null);
				if(rtn == null) throw new Exception("SQL Manager is Null");

		    	}catch(Exception e) {
					throw new Exception("getPOPUP_Search:"+e.getMessage());
		    	}finally{
				}
			return rtn;
	}

}

