<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_100");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
%>

<%!
	public void insertNode(SepoaInfo info, String name, String parent_no, String level, String sg_type)
	{
		String nickName= "SR_001";
		String conType = "TRANSACTION";
		String MethodName = "insertNode";
		Object[] obj = {name, parent_no, level, sg_type};
		sepoa.fw.srv.SepoaOut value = null; 
		sepoa.fw.util.SepoaRemote ws = null;
		
		try {
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
		}catch(SepoaServiceException wse) { nickName= "SR_001";
		}catch(Exception e) { nickName= "SR_001";
		    //e.printStackTrace();
		}finally{
			try{
				ws.Release();
			}catch(Exception e){ nickName= "SR_001"; }
		}
	}
%>

<%!
	public void updateNode(SepoaInfo info, String name, String sg_refitem, String sg_type)
	{
		String nickName= "SR_001";
		String conType = "TRANSACTION";
		String MethodName = "updateNode";
		Object[] obj = {name, sg_refitem, sg_type};
		sepoa.fw.srv.SepoaOut value = null; 
		sepoa.fw.util.SepoaRemote ws = null;
		
		try {
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
		}catch(SepoaServiceException wse) {
			nickName= "SR_001";
		}catch(Exception e) { nickName= "SR_001";
		    //e.printStackTrace();
		}finally{
			try{
				ws.Release();
			}catch(Exception e){ nickName= "SR_001"; }
		}
		
	}
%>

<%!
	public void deleteNode(SepoaInfo info, String sg_refitem)
	{
		String nickName= "SR_001";
		String conType = "TRANSACTION";
		String MethodName = "deleteNode";
		Object[] obj = {sg_refitem};
		sepoa.fw.srv.SepoaOut value = null; 
		sepoa.fw.util.SepoaRemote ws = null;
		
		try {
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
		}catch(SepoaServiceException wse) {
			nickName= "SR_001";
		}catch(Exception e) { nickName= "SR_001";
		    //e.printStackTrace();
		}finally{
			try{
				ws.Release();
			}catch(Exception e){ nickName= "SR_001"; }
		}
		
	}
%>

<%!
	public String ExpandTree(SepoaInfo info, String parent_lev, String current_lev)
	{
	    String nickName= "SR_001";
	    String conType = "CONNECTION";
	    String MethodName = "ExpandTree";
	    sepoa.fw.srv.SepoaOut value = null; 
	    Object[] obj = {parent_lev, current_lev};
	    sepoa.fw.util.SepoaRemote ws = null;
	
	    try {
		ws = new sepoa.fw.util.SepoaRemote(nickName,conType,info);
		value = ws.lookup(MethodName,obj);
		
	    }catch(Exception e) {
	    
	    } finally{
		ws.Release();
	    }
	
	    return value.result[0];
	}
%>


<%
	String mode = JSPUtil.CheckInjection(request.getParameter("mode"))==null?"":JSPUtil.CheckInjection(request.getParameter("mode"));
	String parent_lev = JSPUtil.CheckInjection(request.getParameter("parent_lev"))==null?"":JSPUtil.CheckInjection(request.getParameter("parent_lev"));
	String current_lev = JSPUtil.CheckInjection(request.getParameter("current_lev"))==null?"":JSPUtil.CheckInjection(request.getParameter("current_lev"));
	String sg_refitem = JSPUtil.CheckInjection(request.getParameter("sg_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_refitem"));
	String sg_type = JSPUtil.CheckInjection(request.getParameter("sg_type"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_type"));
	
	if(mode.equals("tree_ins")) {
		String parent_no = JSPUtil.CheckInjection(request.getParameter("parent_no"))==null?"":JSPUtil.CheckInjection(request.getParameter("parent_no"));
		String level = JSPUtil.CheckInjection(request.getParameter("level"))==null?"":JSPUtil.CheckInjection(request.getParameter("level"));
		String sg_name = JSPUtil.CheckInjection(request.getParameter("sg_name"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_name"));
		
		insertNode(info, sg_name, parent_no, level, sg_type);
	}else if(mode.equals("tree_up")){
		
		String sg_name = JSPUtil.CheckInjection(request.getParameter("sg_name"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_name"));
		updateNode(info, sg_name, sg_refitem, sg_type);
	}else if(mode.equals("tree_del")){
		//String sg_refitem = JSPUtil.CheckInjection(request.getParameter("sg_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_refitem"));
		deleteNode(info, sg_refitem);
	}
		
	String ret = ExpandTree(info, parent_lev, current_lev);
	SepoaFormater wf =  new SepoaFormater(ret);
							
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>

<Script language="javascript">

	function gogo(s)
	{
		window.open(s,"body");
	}
	
	
	function Folder(folderDescription, hreference,parentFolder, sg_refitem, parent_no, level)
	{ 
	  
	  this.desc = folderDescription
	  this.hreference = hreference
	  this.id = -1
	  this.navObj = 0
	  this.iconImg = 0
	  this.nodeImg = 0
	  this.isLastNode = 0
	  this.pFolder = parentFolder
	  
	  this.parent_no = parent_no
	  this.level = level
	  this.sg_refitem = sg_refitem
	  this.sg_name = folderDescription
	  
	  this.isOpen = true
	  this.iconSrc = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2folderopen.gif"
	
	  this.children = new Array
	  this.nChildren = 0
		  
	  this.initialize = initializeFolder
	  this.setState = setStateFolder
	  this.addChild = addChild
	  this.createIndex = createEntryIndex
	  this.hide = hideFolder
	  this.display = display
	  this.renderOb = drawFolder
	  this.totalHeight = totalHeight
	  this.subEntries = folderSubEntries
	  this.outputLink = outputFolderLink
	  
	}
	
	function tmpFolder(folderDescription, hreference, sg_refitem)
	{
	
	  this.desc = "<B><font color=#A26300>"+folderDescription+"</font></B>"
	  this.orgdesc = folderDescription
	  this.hreference = hreference
	  this.id = -1
	  this.navObj = 0
	  this.iconImg = 0
	  this.nodeImg = 0
	  this.isLastNode = 0
	  this.sg_refitem = sg_refitem
	  this.sg_name = folderDescription
	  	  
	  this.isOpen = true
	  this.iconSrc = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2folderopen.gif"
	
	
	  this.children = new Array
	  this.nChildren = 0
		  
	  this.initialize = initializeFolder
	  this.setState = setStateFolder
	  this.addChild = addChild
	  this.createIndex = createEntryIndex
	  this.hide = hideFolder
	  this.display = display
	  this.renderOb = drawFolder
	  this.totalHeight = totalHeight
	  this.subEntries = folderSubEntries
	  this.outputLink = outputFolderLink
	}
	
	function setStateFolder(isOpen)
	{
	  var subEntries
	  var totalHeight
	  var fIt = 0
	  var i=0
	
	  if (isOpen == this.isOpen)
	    return
	
	  if (browserVersion == 2)
	  {
	    totalHeight = 0
	    for (i=0; i < this.nChildren; i++)
	      totalHeight = totalHeight + this.children[i].navObj.clip.height
	      subEntries = this.subEntries()
	    if (this.isOpen)
	      totalHeight = 0 - totalHeight
	    for (fIt = this.id + subEntries + 1; fIt < nEntries; fIt++)
	      indexOfEntries[fIt].navObj.moveBy(0, totalHeight)
	  }
	  this.isOpen = isOpen
	  propagateChangesInState(this)
	}
	
	function propagateChangesInState(folder)
	{
	  var i=0
	
	  if (folder.isOpen)
	  {
	    if (folder.nodeImg)
	      if (folder.isLastNode)
		folder.nodeImg.src = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2mlastnode.gif"
	      else
		  folder.nodeImg.src = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2mlastnode.gif"
	    folder.iconImg.src = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2folderopen.gif"
	    for (i=0; i<folder.nChildren; i++)
	      folder.children[i].display()
	  }
	  else
	  {
	    if (folder.nodeImg)
	      if (folder.isLastNode)
		folder.nodeImg.src = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2plastnode.gif"
	      else
		  folder.nodeImg.src = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2plastnode.gif"
	    folder.iconImg.src = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2folderclosed.gif"
	    for (i=0; i<folder.nChildren; i++)
	      folder.children[i].hide()
	  }
	}
	
	function hideFolder()
	{	

	  if (browserVersion == 1) {
	    if (this.navObj.style.display == "none")
	      return
	    this.navObj.style.display = "none"
	  } else {
	    if (this.navObj.visibility == "hiden")
	      return
	    this.navObj.visibility = "hiden"
	  }
	
	  this.setState(0)
	}

	function initializeFolder(level, lastNode, leftSide)
	{
	var j=0
	var i=0
	var numberOfFolders
	var numberOfDocs
	var nc
	
	  nc = this.nChildren
	
	  this.createIndex()
	
	  var auxEv = ""

	  if (browserVersion > 0){
	    auxEv = "<a href='#' onMouseDown='return clickOnNode("+this.id+")'>"
	  }else {
	    auxEv = "<a>"
	  }
		
	  if (level>0)
	    if (lastNode) 
	    {
	      this.renderOb(leftSide + auxEv + "<img name='nodeIcon" + this.id + "' src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2mlastnode.gif'  border=0></a>")
	      leftSide = leftSide + "<img src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2blank.gif' >"
	      this.isLastNode = 1
	    }
	    else
	    {
	      this.renderOb(leftSide + auxEv + "<img name='nodeIcon" + this.id + "' src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2mnode.gif'  border=0></a>")
	      leftSide = leftSide + "<img src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2vertline.gif' >"
	      this.isLastNode = 0
	    }
	  else
	    this.renderOb("")
	
	  if (nc > 0)
	  {
	    level = level + 1
	    for (i=0 ; i < this.nChildren; i++)
	    {
	      if (i == this.nChildren-1)
		this.children[i].initialize(level, 1, leftSide)
	      else
		this.children[i].initialize(level, 0, leftSide)
	      }
	  }
	}
	
	function drawFolder(leftSide)
	{
	
	  if (browserVersion == 2) {
	    if (!doc.yPos)
	      doc.yPos=8
	    doc.write("<layer id='folder" + this.id + "' top=" + doc.yPos + " visibility=hiden>")
	  }
	
	  doc.write("<TABLE ")
	  if (browserVersion == 1)
	    doc.write(" id='folder" + this.id + "' style='position:block;' ")
	  doc.write(" BORDER=0 CELLSPACING=0 CELLPADDING=0>")
	  doc.write("<TR><TD>")
	  doc.write(leftSide)
	  this.outputLink()
	  doc.write("<img name='folderIcon" + this.id + "' ")
	  doc.write("src='" + this.iconSrc+"' border=0></a>")
	  doc.write("</TD><TD VALIGN=middle nowrap>")
	  if (USETEXTLINKS)
	  {
	    this.outputLink()
	    doc.write("<NOBR>" + this.desc + "</NOBR></a>")
	  }
	  else
	    doc.write("<NOBR>" + this.desc + "</NOBR>")
	  doc.write("</TD>")
	  doc.write("</TR></TABLE>")
	
	  if (browserVersion == 2) {
	    doc.write("</layer>")
	  }
	
	  if (browserVersion == 1) {
	    this.navObj = doc.all["folder"+this.id]
	    this.iconImg = doc.all["folderIcon"+this.id]
	    this.nodeImg = doc.all["nodeIcon"+this.id]
	  } else if (browserVersion == 2) {
	    this.navObj = doc.layers["folder"+this.id]
	    this.iconImg = this.navObj.document.images["folderIcon"+this.id]
	    this.nodeImg = this.navObj.document.images["nodeIcon"+this.id]
	    doc.yPos=doc.yPos+this.navObj.clip.height
	  }
	
	}
	
	function outputFolderLink()
	{

	  if (this.hreference)
	  {
	    doc.write("<a href='" + this.hreference + "' TARGET=\"" + TFRAME + "\" ")
	    if (browserVersion > 0)
	      doc.write("onMouseDown='clickOnFolder("+this.id+")'>")
	  }else{
		if (this.id!=0)
		  doc.write("<a href='javascript:;' onMouseDown='clickOnFolder("+this.id+"); return false'>") 
	  }
	}
	
	function addChild(childNode)
	{
	  this.children[this.nChildren] = childNode
	  this.nChildren++
	  return childNode
	}
	
	function folderSubEntries()
	{
	  var i = 0
	  var se = this.nChildren
	
	  for (i=0; i < this.nChildren; i++){
	    if (this.children[i].children) 
	      se = se + this.children[i].subEntries()
	  }
	
	  return se
	}
	
	
	function Item(itemDescription, itemLink,parentFolder, sg_refitem, parent_no, level)
	{
	  
	  this.desc = itemDescription
	  this.link = itemLink
	  this.id = -1 
	  this.navObj = 0 
	  this.iconImg = 0 
	  this.pFolder = parentFolder
	  this.iconSrc = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2doc.gif"
	
	  this.parent_no = parent_no
	  this.level = level
	  this.sg_refitem = sg_refitem
	  	  
	  this.initialize = initializeItem
	  this.createIndex = createEntryIndex
	  this.hide = hideItem
	  this.display = display
	  this.renderOb = drawItem
	  this.totalHeight = totalHeight
	}
	
	function testItem(itemDescription, itemLink)
	{	  
	  this.desc = "<b><font face=verdana size='2' color=FD8D4D>"+itemDescription +"</font></b>"
	  this.link = itemLink
	  this.id = -1 
	  this.navObj = 0 
	  this.iconImg = 0 
	  this.iconSrc = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2overview.gif"
		  
	  this.initialize = initializeItem
	  this.createIndex = createEntryIndex
	  this.hide = hideItem
	  this.display = display
	  this.renderOb = drawItem
	  this.totalHeight = totalHeight
	}
	
	
	function folder_image(itemDescription, itemLink)
	{	  
	  this.desc = itemDescription
	  this.link = itemLink
	  this.id = -1 
	  this.navObj = 0 
	  this.iconImg = 0 
	  this.iconSrc = "<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2folderclosed.gif"
		  
	  this.initialize = initializeItem
	  this.createIndex = createEntryIndex
	  this.hide = hideItem
	  this.display = display
	  this.renderOb = drawItem
	  this.totalHeight = totalHeight
	}
	
	
	
	function hideItem()
	{
	  if (browserVersion == 1) {
	    if (this.navObj.style.display == "none")
	      return
	    this.navObj.style.display = "none"
	  } else {
	    if (this.navObj.visibility == "hiden")
	      return
	    this.navObj.visibility = "hiden"
	  }
	}
	
	function initializeItem(level, lastNode, leftSide)
	{
	  this.createIndex()
	
	  if (level>0)
	    if (lastNode) 
	    {
	      this.renderOb(leftSide + "<img src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2lastnode.gif' >")
	      leftSide = leftSide + "<img src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2blank.gif' >"
	    }
	    else
	    {
	      this.renderOb(leftSide + "<img src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2node.gif' >")
	      leftSide = leftSide + "<img src='<%=POASRM_CONTEXT_NAME%>/images/menu/ftv2vertline.gif' >"
	    }
	  else
	    this.renderOb("")
	}
	
	function drawItem(leftSide)
	{
	
	  if (browserVersion == 2)
	    doc.write("<layer id='item" + this.id + "' top=" + doc.yPos + " visibility=hiden>")
	
	  doc.write("<TABLE ")
	  if (browserVersion == 1)
	    doc.write(" id='item" + this.id + "' style='position:block;' ")
	  doc.write(" BORDER=0 CELLSPACING=0 CELLPADDING=0>")
	  doc.write("<TR><TD>")
	  doc.write(leftSide)
	  if (this.link) {	      
	      doc.write("<a href=" + this.link + ">")
	   }
	   doc.write("<img id='itemIcon"+this.id+"' ")
	   doc.write("src='"+this.iconSrc+"' border=0>")
	
	  doc.write("</a>")
	  doc.write("</TD><TD VALIGN=middle nowrap>")
	  if (USETEXTLINKS && this.link){	    
	    doc.write("<NOBR><a href=" + this.link + ">" + this.desc + "</NOBR></a>")
	  }else{
	    doc.write("<NOBR>" + this.desc + "</NOBR>")
	  }
	  doc.write("</TD></TR></TABLE>")
	
	  if (browserVersion == 2)
	    doc.write("</layer>")
	
	  if (browserVersion == 1) {
	    this.navObj = doc.all["item"+this.id]
	    this.iconImg = doc.all["itemIcon"+this.id]
	  } else if (browserVersion == 2) {
	    this.navObj = doc.layers["item"+this.id]
	    this.iconImg = this.navObj.document.images["itemIcon"+this.id]
	    doc.yPos=doc.yPos+this.navObj.clip.height
	  }
	
	}
	
	
	function display()
	{
	  if (browserVersion == 1)
	    this.navObj.style.display = "block"
	  else
	    this.navObj.visibility = "show"
	}
	
	function createEntryIndex()
	{
	  this.id = nEntries
	  indexOfEntries[nEntries] = this
	  nEntries++
	}
		
	function totalHeight() 
	{
	  var h = this.navObj.clip.height
	  var i = 0
	
	  if (this.isOpen) 
	    for (i=0 ; i < this.nChildren; i++)
	      h = h + this.children[i].totalHeight()
	
	  return h
	}
	
	function clickOnFolder(folderId)
	{
	  var isClose = false;
	  var clicked = indexOfEntries[folderId]

	  setTreeProperty(clicked.sg_refitem, clicked.parent_no, clicked.level);	
	 
	  if (!clicked.isClose) {
	    clickOnNode(folderId)
	    return
	  }
	  if (clicked.isSelected)
	    return
	
	}
	
	function clickOnNode(folderId)
	{
	  var clickedFolder = 0
	  var state = 0
	
	  clickedFolder = indexOfEntries[folderId]
	  state = clickedFolder.isOpen
	  clickedFolder.setState(!state)
	  
	  
	  parent.setSgName(clickedFolder.sg_name);
	  setTreeProperty(clickedFolder.sg_refitem, clickedFolder.parent_no, clickedFolder.level);	
	  	  
	  return false;
	}
			
	function gFld(description, ref, parentFolder, sg_refitem, parent_no, level)
	{
	  if (DWIN && ref) ref = "javascript:go(\""+ref+"\")"
	
	  folder = new Folder(description, ref,parentFolder, sg_refitem, parent_no, level)
	  return folder
	}
	
	function tmpgFld(description, ref)
	{
	  if (DWIN && ref) ref = "javascript:go(\""+ref+"\")"
	
	  folder = new tmpFolder(description, ref)
	  return folder
	}
	
	function gLnk(target, description, ref, parentFolder, sg_refitem, parent_no, level)
	{
	  fullLink = ""

	  fullLink = ref
	
	  linkItem = new Item(description, fullLink,parentFolder, sg_refitem, parent_no, level)
	
	  return linkItem
	}
	
	function testgLnk(target, description, ref)
	{
	  fullLink = ""
	
	  if (DWIN && ref) ref = "javascript:go(\""+ref+"\")"
	
	  if (ref)
	   if (target==0)
	     fullLink = "'"+ref+"' target=\"" + TFRAME + "\""
	   else
	     fullLink = "'"+ref+"' target=_blank"
	
	  linkItem = new testItem(description, fullLink)
	
	  return linkItem
	}
	
	
	function folder_gLnk(target, description, ref)
	{
	  fullLink = ""
	
	  if (DWIN && ref) ref = "javascript:go(\""+ref+"\")"
	
	  if (ref)
	   if (target==0)
	     fullLink = "'"+ref+"' target=\"" + TFRAME + "\""
	   else
	     fullLink = "'"+ref+"' target=_blank"
	
	  linkItem = new folder_image(description, fullLink)
	
	  return linkItem
	}
	
	
	
	
	function insFld(parentFolder, childFolder)
	{	
	
	 return parentFolder.addChild(childFolder)
	}
	
	function insDoc(parentFolder, document)
	{
	  parentFolder.addChild(document)
	  
	}
	
	
	
	
	function initializeDocument()
	{
	  if (doc.all)
	    browserVersion = 1 
	  else
	    if (doc.layers)
	    {
			browserVersion = 2 
			self.onresize = self.doResize
	    }
	    else
	      browserVersion = 0 
		<%  
		    if(wf.getRowCount() > 0){  
			    out.println("menu_id_0.initialize(1, 1, '');\n");
			     
			    out.println("menu_id_0.display();\n");
		    }else{
			    out.println("foldersTree.initialize(0, 1, '');\n");
			    out.println("foldersTree.display();\n");
		    }	
		%>
	  if (browserVersion > 0)
	  {
	    doc.write("<layer top="+indexOfEntries[nEntries-1].navObj.top+">&nbsp;</layer>")

	    clickOnNode(0);
	    
	    clickOnNode(0);
	
	  }
	}
	
	function go(s)
	{
	
		onerror=goNewW; 
		sErrREF = s; 
	
		if (!opener.closed)
			opener.document.location=s;
		else
			window.open(s,"newW"); 
	
	}
	
	function goNewW() 
	{
		window.open(sErrREF,"newW");
	}
	
	function doResize() 
	{
		document.location.reload();
	}
	
	function hideLayer(layerName){
	  eval(layerRef+'["'+layerName+'"]'+styleSwitch+'.visibility="hidden"');
	}
	
	function MileStone(folderId)
	{
	
	  var msStr="<span class='location_start'> "
	  var msOrg=''
	  var my = indexOfEntries[folderId];
	  msOrg += my.desc;
	
	  var obj = my.pFolder;
	  for(;;){
	   if(obj.id == 0)
		  break;
	
		msOrg += "^@^"+obj.desc;
		obj = obj.pFolder;
	  }
		msOrg += "^@^"+obj.orgdesc;
	
		var sstr = msOrg.split('^@^');
	
		for(var i = [sstr.length-1] ; i>0 ; i--){
				msStr += sstr[i]+" > "
		}
	
		msStr +="</span><span class='location_end'>"+sstr[0]+"</span>"
		document.forms[0].wisemilestone.value = msStr;
	 }
	
	 function setTreeProperty(sg_refitem, parent_no, level) {
		
		parent.setTreeProperty(sg_refitem, parent_no, level);
		
	}
	
	function setRefItem(sg_refitem, level, sg_parent_refitem) {
		parent.setRefItem(sg_refitem, level, sg_parent_refitem);
		
	}
	function init(){
		menu_id_0.initialize(0, 1, '');
		menu_id_0.display();
	}
	
	indexOfEntries = new Array
	nEntries = 0
	doc = document
	browserVersion = 0
	selectedFolder=0
	sErrREF = ""; 
	layerRef="document.all";
	styleSwitch=".style";
	if (navigator.appName == "Netscape") {
		layerRef="document.layers";
		styleSwitch="";
	}
	USETEXTLINKS = 1
	TFRAME="body"
	DWIN=0

<%
    
   
    if(wf.getRowCount() > 0){
    
	 sg_refitem      = "";
	 String sg_name         = "";
	 String parent_sg_refitem   = "";
	 int level_count         = 0;
	 String is_leaf = "";
	 String is_use = "";
		   
	 for(int i=0; i<wf.getRowCount(); i++) 
	 {	

		sg_refitem      = wf.getValue(i, 0);
		sg_name         = wf.getValue(i, 1);
		parent_sg_refitem   = wf.getValue(i, 2);
		level_count         = Integer.parseInt(wf.getValue(i, 3));
		is_leaf   = wf.getValue(i, 4);
		is_use   = wf.getValue(i, 5);
		
		String req_str = "";
	%>    		
		
		<%if(i == 0) {%>
			menu_id_0 = tmpgFld('소싱그룹','<%=req_str%>');
		<%}%>
		<%if(level_count == 1) {%>
			menu_id_<%=sg_refitem%> = insFld(menu_id_0, gFld('<%=sg_name%>', '<%=req_str%>', 'menu_id_0', '<%=sg_refitem%>', '<%=parent_sg_refitem%>', '<%=level_count%>'));
		<%}else if(level_count == 2) {%>
			//insDoc(menu_id_<%=parent_sg_refitem%>, gLnk(0,'<%=sg_name%>', "<%=req_str%>",'menu_id_<%=parent_sg_refitem%>', '<%=sg_refitem%>', '<%=parent_sg_refitem%>', '<%=level_count%>'));
			menu_id_<%=sg_refitem%> = insFld(menu_id_<%=parent_sg_refitem%>, gFld('<%=sg_name%>', '<%=req_str%>' ,'menu_id_<%=parent_sg_refitem%>', '<%=sg_refitem%>', '<%=parent_sg_refitem%>', '<%=level_count%>'));
		<%}else if(level_count == 3) {%>
			<%req_str = "javascript:setRefItem(" + sg_refitem + "," + level_count + "," + parent_sg_refitem + ");";	%>
			insDoc(menu_id_<%=parent_sg_refitem%>, gLnk(0,'<%=sg_name%>', "<%=req_str%>",'menu_id_<%=parent_sg_refitem%>', '<%=sg_refitem%>', '<%=parent_sg_refitem%>', '<%=level_count%>'));
			
		<%}%>
	    
     <%       	
	
	}
    
    }else{
	
	out.println("foldersTree= tmpgFld('소싱그룹','');"+"\n");
    
    }
%>

</script>
</head>
	<BODY leftMargin="0" topMargin="0" marginheight="0" marginwidth="0" bgcolor="#F1F2F6" onLoad="">
		<table border="0" cellspacing="0" cellpadding="0" width="201">
			<tr>
				<td colspan="2" height="5">
					<img src="<%=POASRM_CONTEXT_NAME%>/images/menu/space.gif" width="12" height="5" alt="">
				</td>
			</tr>
			<tr>
				<td width="5">
					<img src="<%=POASRM_CONTEXT_NAME%>/images/menu/space.gif" width="5" height="5" alt="">
				</td>
				<td>
					<script type="text/javascript">initializeDocument()</script>
				</td>
			</tr>
		</table>
	</BODY>
<!---- END OF USER SOURCE CODE ---->
</html>
