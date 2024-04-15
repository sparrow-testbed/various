package sepoa.svc.approval.madec;

 interface IFMaProp {

	/*
	 *  Refactor from ClientProgram
	 */
	 static final int MAX_ENC_SIZE = 4096;

	 
	/*
	 *  Refactor from CnvData
	 */ 
	final static int BYTE = 1;
	final static int SHORT = 2;
	final static int INT = 4;
	final static int LONG = 8;


	/*
	 *  Refactor from PacketDefine
	 */
	static final int PACKET_SIZE = 4096;

	static final int SIGID_POS = 0;			// int
	static final int DATA_POS = 4;			// byte[]
	static final int DATA_MAX_SIZE = 4092;

	/*
	 *  Refactor from PropertyManager
	 */
	public final static String  MA_PROP_TAG_DDS_IP		= new String("1");
	public final static String  MA_PROP_TAG_DDS_PORT	= new String("2");
	public final static String  MA_PROP_TAG_DDSZIP_IP	= new String("3");
	public final static String  MA_PROP_TAG_DDSZIP_PORT	= new String("4");
	public final static String  MA_PROP_TAG_COMPANY_ID	= new String("5");
	public final static String  MA_PROP_TAG_GRADE		= new String("6");
	public final static String  MA_PROP_TAG_SERVER_ADDR	= new String("7");
	public final static String  MA_PROP_TAG_CREATED_BY	= new String("8");
	public final static String  MA_PROP_TAG_COMPANY_NAME = new String("9");
	public final static String  MA_PROP_TAG_DEC_IP		 = new String("10");
	public final static String  MA_PROP_TAG_DEC_PORT	 = new String("11");
	public final static String  MA_PROP_TAG_DECZIP_IP	 = new String("12");
	public final static String  MA_PROP_TAG_DECZIP_PORT	 = new String("13");	
	public final static String  MA_PROP_TAG_SERVER_ORIGIN	 = new String("14");	

	public final static String  PROP_FILE_NAME   = new String("StreamDrmInfo.dat");
	public final static	String 	PROP_MAX_PARAM	 = new String("MAXTAG");
	public final static String  PROP_PARAM_KEY   = new String("TAG#");
		
	/*
	 *  Refactor from MadnFile, MaWcdn, Madn, Madec
	 */
	// declaration constant variable
	final static String ISUCCESS = new String("00000");
	final static String IFAILED = new String("10000");
	final static String IORGFILE = new String("00001");
	final static int	iRetCodeStartIdx = 0;
	final static int iRetCodeEndIdx = 5;
	final static int iRetEncFileNameEndIdx = 517;
	final static int iRetEndIdx = 517;
	
	// internal constant variable                                    
	final static String E_CONNECT_SOCKET = new String("10001");      
	final static String E_WRITE_SOCKET = new String("10015");        
	final static String E_READ_SOCKET = new String("10016");
	final static String E_SOCKET = new String("10014");
	final static String E_PACKET = new String("10017");	
	final static String E_NO_DATA_FOUND = new String("21000");
	final static String E_ARGUMENT_ERROR = new String("90001");    
	final static String E_FILENAME_EXT_ERROR = new String("90004");
	final static String E_INPUTSTREAM_ERROR = new String("90005");
	final static String E_INPUTSTREAM_LENGTH_ERROR = new String("90006");

	// packet field size
    final static int MAX_ID = 50;   
    final static int MAX_FILE_ID = 50;
    //final static int MAX_FILE_LENGTH = 32;

	final static int MAX_FILE_NAME	= 256;
	final static int MAX_IP = 20;
	final static int MAX_DN = 64;
	final static int MAX_COMNAME = 100;
	final static int MAX_OPER_TYPE = 10;

	final static int MAX_DOC_LEVEL = 8;
	final static int MAX_OPEN_COUNT	= 4;
	final static int MAX_PRINT_COUNT = 4;
	final static int MAX_VALID_PERIOD = 4;
	final static int MAX_FLAG = 1;
	
	final static int MAX_PATH = 512;
	final static int MAX_DIR_NAME = 256;
	
	final static int MAX_COMPANY_ID	= 64;
	final static int MAX_GROUP_ID = 64;
	final static int MAX_POSITION_ID = 64;
	final static int MAX_GRADE = 16;
	final static int MAX_FILE_TYPE = 16;
	final static int MAX_DOCUMENT_TITLE = 256;
	
	final static int MAX_COMPANY_NAME =	64;
	final static int MAX_GROUP_NAME	= 128;
	final static int MAX_POSITION_NAME = 64;
	final static int MAX_USER_NAME = 16;
	final static int MAX_REASON = 512;

	final static int MAX_SEQ_NUM = 18;	/* 다운로드 로그 Primary Key 사이즈 */
    final static int MAX_SERVER_ORIGIN = 50;
    final static int MAX_EXCHANGEPOLICY = 2;
    final static int MAX_BLOCK_SIZE = 10;
    
    final static int MA_MAX_KEY_SIZE = 16;

	final static int MAX_FUNCTION_GUBUN	= 8;
	final static int MAX_PORT = 5;
	final static int MAX_METHOD	= 16;
	final static int MAX_URL = 1024;
	final static int MAX_HTTP_HEADER = 512;
	final static int MAX_HTTP_COOKIE = 256;
	final static int MAX_HTTP_AUTHORIZATION = 128;
	final static int MAX_HTTP_PARAMETER = 2048;
	
	final static int 	MAX_READ_SIZE = 4096;
	final static int	PRE_ENC_HEADER_SIZE = 32;
	final static int 	MAX_FILE_LENGTH = 32;

}