package sepoa.fw.util;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.ses.SepoaInfo;
import xlib.cmc.GridData;

/**
 * JSP�κ����� �Ķ���͵����͸� �����·� ����
 * 
 * 
 * @author Xogh
 *
 */
@SuppressWarnings( { "unchecked", "rawtypes" } )
public final class SepoaDataMapper {

    /** ���� ��¥ Ű */
    final public static String KEY_CURRENT_DATE         = "current_date";

    /** ���� �ð� Ű */
    final public static String KEY_CURRENT_TIME         = "current_time";

    /** ���������� USER_ID Ű */
    final public static String KEY_SESSION_USER_ID      = "session_user_id";

    /** ���������� USER_NAME Ű */
    final public static String KEY_SESSION_USER_NAME    = "session_user_name";

    /** ���� Ű */
    final public static String KEY_BLANK                = "blank";

    /** �Ķ������ �����͸� �����ϴ� Ű */
    final public static String KEY_HEADER_DATA          = "headerData";

    /** �׸��� Į�� Ű */
    final public static String KEY_COLS_IDS             = "cols_ids";

    /** �׸��� ������ Ű */
    final public static String KEY_GRID_DATA            = "gridData";

    /** �Ķ���� Ű */
    final public static String KEY_PARAMS               = "params";

    /** �Ķ���� Ű */
    final public static String KEY_REQUEST				  = "rawRequest";

    /** �Ķ���� Ű */
    final public static String KEY_RESPONSE= "rawResponse";


    private SepoaDataMapper() {
        // Initialization is not available.
    }

	/**
	 * JSP�κ����� �Ķ���͵����͸� �����¿� ��� ����<br>
	 * ex)
	 * 		SepoaDataMapper dataMap = SepoaDataMapper.getData(info, gdReq);<br>
	 * 		<br>
	 * 		String valueFromJSP = dataMap.get("key_from_jsp");<br>
	 * 		String curDate = dataMap.get(SepoaDataMapper.KEY_CURRENT_DATE);<br>
	 * 
	 * @param  info    ��������
	 * @param  gdReq   request�������� wrapped Object(GridData)
	 * @return         ����Ʈ �������� ����� ������
	 * @throws Exception
	 */
    public static Map getData( SepoaInfo info, GridData gdReq ) throws Exception {

        HashMap map     = new HashMap();
        HashMap params  = new HashMap();
        HashMap map1    = null;
        List    list    = new ArrayList();
        
		Configuration configuration = new Configuration();
		String fieldSeparator = configuration.get("sepoa.separator.field").trim();

		String[] paramNames = gdReq.getParamNames();
		for(String paramName : paramNames) {
		    map.put(paramName, gdReq.getParam(paramName));
		}
		
        String      strParams       = JSPUtil.CheckInjection( JSPUtil.nullToEmpty( gdReq.getParam( KEY_PARAMS ) ));
        			
        String      strGridColId    = null;
        String[]    strGridColArray = null;
        /*
        Sepoa_scripts.jsp���� �޾ƿ� ���� decode�� ��ȯ 
        */
        String      strEncode       = JSPUtil.CheckInjection( JSPUtil.nullToEmpty( gdReq.getParam( "_encode" ) ) );
        if("true".equals(strEncode)) {
            strParams = URLDecoder.decode( strParams, "UTF-8" );
        }

        int row_count = gdReq.getRowCount();

        String table_datas[] = SepoaString.getNullSplit( strParams, fieldSeparator);
//        String table_datas[] = StringUtils.splitPreserveAllTokens(strParams, fieldSeparator);
        for( int i = 0; i < table_datas.length - 1; i = i + 2 ) {
            params.put( table_datas[i], table_datas[i + 1].replace( "\"", "\\\"" ) );
        }
        params.put( KEY_CURRENT_DATE,       SepoaDate.getShortDateString()  );
        params.put( KEY_CURRENT_TIME,       SepoaDate.getShortTimeString()  );
        params.put( KEY_SESSION_USER_ID,    info.getSession( "ID" )         );
        params.put( KEY_SESSION_USER_NAME,  info.getSession( "NAME_LOC" )   );
        params.put( KEY_BLANK,              ""                              );

        map.put( KEY_HEADER_DATA, params );

        strGridColId = JSPUtil.paramCheck( gdReq.getParam( KEY_COLS_IDS ) ).trim();
        strGridColArray = SepoaString.parser( strGridColId, "," );
        for( int i = 0; i < row_count; i++ ) {
            map1 = new HashMap();
            for( int j = 0; j < strGridColArray.length; j++ ) {
                map1.put( strGridColArray[j], gdReq.getValue( strGridColArray[j], i ) );
            }
            list.add( map1 );
        }
        map.put( KEY_GRID_DATA, list );
        map.put( KEY_REQUEST, gdReq.getRequest());
        map.put( KEY_RESPONSE, gdReq.getResponse());
        
        return map;

    }
}
