<%@ page contentType = "text/html; charset=UTF-8" %>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/><!-- IE 최신 버전으로 자동 전환하도록 -->
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.math.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.svc.common.*"%>
<%
	response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "Thu, 01 Dec 1994 16:00:00 GMT");
%>

<%
	Config olConfxxxx = new Configuration();
	boolean devFlag = olConfxxxx.getBoolean("sepoa.mouse.right.enable");
	boolean devCheckFlag = olConfxxxx.getBoolean("sepoa.server.development.flag");
	String POASRM_CONTEXT_NAME = olConfxxxx.getString("sepoa.context.name");
	Vector dhtmlx_read_cols_vec = new Vector();
	Vector dhtmlx_back_cols_vec = new Vector();
	// 화면에 행머지기능을 사용할지 여부의 구분
	boolean isRowsMergeable = false;
	// setHeader init 관련 구분
	boolean isReDrawHeader = false;
	String col_del         = CommonUtil.getConfig("sepoa.separator.field");
	String row_del         = CommonUtil.getConfig("sepoa.separator.line");
	
	// MultiGrid 여부
	boolean isMultiGridable = false;
	int dhtmlx_grid_cnt = 0;
	
	//cell고정기능 사용여부
	boolean isSplitGridable = false;
	int dhtmlx_split_cnt = 0; //고정시킬 cell의 개수.
	
	//   화면에 visible 기능의 관한 Vector
	Vector dhtmlx_visible_cols_vec = new Vector();
	//	 화면에 헤더 머지 기능의 관한 Vector
	Vector dhtmlx_head_merge_cols_vec = new Vector();
	
	request.setAttribute("POASRM_CONTEXT_NAME", POASRM_CONTEXT_NAME);
	request.setAttribute("DHTMLX_READ_COLS_VEC", dhtmlx_read_cols_vec);
	request.setAttribute("DHTMLX_BACK_COLS_VEC", dhtmlx_back_cols_vec);
	request.setAttribute("COL_DEL", col_del);
	request.setAttribute("ROW_DEL", row_del);

	if (! devFlag)
	{
%>
		<script language=JavaScript>m='%3Cscript%20language%3DJavaScript%3E%3C%21--%0D%0A%0D%0Avar%20message%3D%22Function%20Disabled%21%22%3B%0D%0A%0D%0Afunction%20clickIE%28%29%20%20%7Bif%20%28document.all%29%20%7Breturn%20false%3B%7D%7D%0D%0Afunction%20clickNS%28e%29%20%7Bif%20%0D%0A%28document.layers%7C%7C%28document.getElementById%26%26%21document.all%29%29%20%7B%0D%0Aif%20%28e.which%3D%3D2%7C%7Ce.which%3D%3D3%29%20%7Breturn%20false%3B%7D%7D%7D%0D%0Aif%20%28document.layers%29%20%0D%0A%7Bdocument.captureEvents%28Event.MOUSEDOWN%29%3Bdocument.onmousedown%3DclickNS%3B%7D%0D%0Aelse%7Bdocument.onmouseup%3DclickNS%3Bdocument.oncontextmenu%3DclickIE%3B%7D%0D%0A%0D%0Adocument.oncontextmenu%3Dnew%20Function%28%22return%20false%22%29%0D%0A%0D%0A//%20--%3E%3C/script%3E';d=unescape(m);document.write(d);</script>
<%
	}
%>

<%!
    public String ckNull(String value) {
        return value == null ? "" : value;
    }

    public String check_null(String value) {
        return value == null ? "" : value;
    }
%>
	<script>var _POASRM_CONTEXT_NAME = "<%=POASRM_CONTEXT_NAME%>";</script>
	<script>
		document.onkeydown = function(){
			try{
				var backspace = 8;
				var t = document.activeElement;
				
				if(event.keyCode == backspace){
					if(t.tagName == "SELECT")
						return false;
					
					if(t.tagName == "INPUT" && t.getAttribute("readonly") == "readonly"){
						event.keyCode = 0;
						return false;
					}
					if(t.tagName == "INPUT" && t.getAttribute("readonly") == true){
 						event.keyCode = 0;
						return false;
					}
					
					if(t.tagName == "TEXTAREA" && t.getAttribute("readonly") == "readonly"){
						event.keyCode = 0;
						return false;
					}
					if(t.tagName == "TEXTAREA" && t.getAttribute("readonly") == true){
 						event.keyCode = 0;
						return false;
					}
				}
			}catch(e){
				
			}
		}
	</script>
