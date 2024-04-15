<%@ page contentType="text/html; charset=UTF-8"%>
<%-- <%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="java.util.*"%> --%>
<%
	Configuration hub_configuration = new Configuration();
	String encoding_status = hub_configuration.getString("sepoa.database.encoding");
	String fieldSeparator = hub_configuration.getString("sepoa.separator.field");
	//System.out.println("encoding_status==>"+encoding_status);
	Enumeration enumeration =  request.getParameterNames();
	HashMap<String,String> hashMap = new HashMap<String, String>();
	String sepoaQueryString = "";
	while(enumeration.hasMoreElements()){
		String name_temp  = (String) enumeration.nextElement();
		String value_temp = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter(name_temp)));
		hashMap.put(name_temp, value_temp);
		sepoaQueryString += name_temp + "=" + value_temp + "&";
		Logger.debug.println("Parameter Name  : " + name_temp  + "\t\t\t\t\t\t\tParameter Value : " + value_temp + "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
	}
%>


<!-- <script>hF="/codebase/";</script> -->
<script>
//dhtmlx 내부에서 사용되는 자바스크립트 전역변수
_css_prefix="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/";
_js_prefix="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/";
//sepoa_scripts.js에 사용되는 자바스크립트 전역변수
var _POASRM_CONTEXT_NAME = "<%=POASRM_CONTEXT_NAME%>";
var _fieldSeparator = "<%=fieldSeparator%>";
var _SepoaDataMapper_KEY_PARAMS = "<%=SepoaDataMapper.KEY_PARAMS%>";
</script>
<%-- 
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/dhtmlxcommon.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.js"></script>
<script  src='<%=POASRM_CONTEXT_NAME%>/include/sepoa_dhtmlxgrid.js'></script>	<!-- dhtmlxgrid.js를 오버라이딩 하기 위해  -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/dhtmlxgridcell.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_post.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_srnd.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_hmenu.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_ssc.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_splt.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_nxml.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_mcol.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_undo.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_filter.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_selection.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_rowspan.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_calendar.js"></script>		<!-- libCompiler관련 : 3.6에 있지만 libCompiler 목록에 없음 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_dhxcalendar.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_combo.js" type="text/javascript"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_link.js"></script>
<!--  <script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxDataProcessor/codebase/dhtmlxdataprocessor.js"></script>-->	<!-- 우선 주석처리 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxDataProcessor/codebase/dhtmlxdataprocessor2.1custom.js"></script>	<!-- 2.1custom을 넣어서 실습 -->	<!-- 따로 추가함 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcommon.js"></script>	<!-- 추가함 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxCalendar/codebase/dhtmlxcalendar.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxCombo/codebase/dhtmlxcombo.js" type="text/javascript"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxMenu/codebase/dhtmlxmenu.js" type="text/javascript"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxMenu/codebase/ext/dhtmlxmenu_ext.js" type="text/javascript"></script><!-- 3.6에서 추가함 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxWindows/codebase/dhtmlxwindows.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxWindows/codebase/dhtmlxcontainer.js"></script>						<!-- dhtmlx 3.6 추가 -->
<!-- Tree Grid용 js 추가 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_math.js"></script>
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/fly/swfobject.js"></script>		<!-- libCompiler관련 : 3.6 에 없음 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/dhtmlxGridToChart.js"></script>	<!-- libCompiler관련 : 3.6 에 없음 -->
<!-- Tree Grid용 js 추가 끝 -->

<!-- 새끼그리드용 js 추가 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_sub_row.js"></script>
<!-- 새끼그리드용 js 끝 -->

<!-- grid tree (좌측메뉴) -->
<script src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxTree/codebase/dhtmlxtree.js"></script>	<!-- 3.6에서 추가 -->
--%>

<script src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/dhtmlx.js"></script>	<!-- dhtmlx 관련 js파일을 압축함.압축된 파일목록은 manifest.txt에 기술되어 있음  -->
<%-- <script src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/dhtmlxgrid_excell_calendar.js"></script>		<!-- 3.6에 있지만 libCompiler components.xml목록에 없어서 따로 xml에 추가해서 제작하였음 --> --%>
<%-- <script src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/fly/swfobject.js"></script>		<!-- 3.6 에 없음 - 우선 사용하지 않기로 함 --> 
<script src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/dhtmlxGridToChart.js"></script>	<!-- 3.6 에 없음 - 우선 사용하지 않기로 함 --> --%>
<script src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/dhtmlxdataprocessor2.1custom.js"></script>
<!-- Tree Grid용 js 추가 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/swfobject.js"></script>		<!-- libCompiler관련 : 3.6 에 없음 -->
<script  src="<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/dhtmlxGridToChart.js"></script>	<!-- libCompiler관련 : 3.6 에 없음 -->
<!-- Tree Grid용 js 추가 끝 -->
<script src='<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/sepoa_dhtmlx.js'></script>	<!-- dhtmlx.js를 오버라이딩 하기 위해  -->
<%-- <!-- 편집중이라서 임시로... -->
<%@ include file="/dhtmlx/dhtmlx_full_version/sepoa_dhtmlx.jsp"%> --%>

<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/lib/jquery-1.10.2.min.js"></script>

<Script language="javascript">
var encoding_status = "<%=encoding_status%>";
var G_IMG_ICON = '<%=POASRM_CONTEXT_NAME%>/images/button/query.gif';
// var G_MSS1_SELECT = 'The selected data does not exist.';
var G_MSS1_SELECT = '선택된 행이 없습니다.';
var G_MSS2_SELECT = '하나 이상 선택할 수 없습니다.';
var G_COL1_OPT    = '242|242|242';
var G_COL1_ESS    = '251|251|92';

</Script>
<Script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/sepoa_scripts.js"></Script>
<Script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/sepoa_ie10.js"></Script>
<Script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/include/script/catalog/catalog.js"></Script><%-- setCatalogIndex 함수를 위해 추가 --%>
