/**
* @desc: object of chart
* @param: containerId - id of external container
* @type: public
**/
function dhtmlXGridToChartObject (containerId) {
  	_self = this;
	_self.externalContainer = document.getElementById(containerId);
  	if (_self.externalContainer.style.width)  _self.externalContainer.width = parseInt(_self.externalContainer.style.width);
  	if (_self.externalContainer.style.height) _self.externalContainer.height = parseInt(_self.externalContainer.style.height);
  	
  	//alert("width = "+_self.externalContainer.style.width);
  	//alert("height = "+_self.externalContainer.style.height);
	_self.sourceGrid = null;
  	_self.libName = null;
  	_self.libPath = "";  	
  	_self.libLoadStatus = false;
  	_self.chart	= null;
  	_self.chartType = "line";
  	_self.chartDataset = {};
  	_self.chartOptions;
  	_self.chartDataColInd;
  	_self.chartTicksColInd = null;
  	_self.maxValue;
  	_self.pointTitles = false;
	_self.chartBarWidth = 0;
	_self.activeColumnIds;
	_self.chartPreview = false;	
	_self.chartPreviewOptions;
	_self.chartPreviewContainer = null;
	_self.chartXMLData = "";//"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
	_self.chartDefaultColors = ["edc240", "afd8f8", "cb4b4b", "4da74d", "9440ed"];
	//_self.chartDefaultColors = ["FF0000","FF00D3","A4F94E","3334FF","2DD8FC","06CC06","900806","FF0000","FD29D8","FF0000","FD29D8","GGFF00","FD29D8","FF0000","2DD8FC","3334FF","FF0000","06CC06","FF00D3","900806"];
	_self.dataPointRadius = 3;
	
	_self.chartTypeDetail = "";
	_self.fontValue =  null;
}

/**
*	@desc: set libraries path
*	@param: libPath
*	@type: public
**/
dhtmlXGridToChartObject.prototype.setLibPath = function(libPath){
	_self.libPath = libPath
}

/**
*	@desc: set library of chart
* 	@param: libName - library name
* 	@type: public
**/
dhtmlXGridToChartObject.prototype.setLib = function(libName){
  	_self.libName=libName;
//  alert("Set lib: "+libName);
  	switch(libName) {
		case "plotr":
			_self._loadJSFile(_self.libPath+"excanvas/excanvas.pack.js,"+
							  _self.libPath+"plotr/prototype.js,"+
							  _self.libPath+"plotr/plotr.js");
		  break;    
		case "google charts":
		  	_self.libLoadStatus = true;
		  break;
		case "flot":
			_self._loadJSFile(_self.libPath+"excanvas/excanvas.pack.js,"+
							  _self.libPath+"flot/jquery.js,"+
							  _self.libPath+"flot/jquery.flot.pack.js");
		break;
		case "fly":
		    _self._loadJSFile(_self.libPath+"fly/swfobject.js");
		break;		
	}
	_self._setDefaultOptions();	
}

/**
* 	@desc: set source grid
* 	@param: gridObj - grid object
*	@type: public
**/
dhtmlXGridToChartObject.prototype.setSourceGrid = function(gridObj){
	_self.sourceGrid = gridObj;
}

/**														
* 	@desc: set type of chart (pie,line,bar)
* 	@param: chartType - grid object
* 	@type: public
**/
dhtmlXGridToChartObject.prototype.setChartType = function(chartType){
	_self.chartType = chartType;
	_self.chartTypeDetail = chartType;
	
	if(_self.chartTypeDetail.indexOf("3d") != -1) {
		_self.chartType = _self.chartTypeDetail.substring(0, _self.chartTypeDetail.indexOf("3d"));
	}
	
	if ((chartType=="bar")&&(_self.libName=="fly"))
		_self.chartType="column";
}

/** 
* 	@desc: set column indexes of data in grid
* 	@param: colInd - column index
* 	@type: public
**/
dhtmlXGridToChartObject.prototype.setDataColumnIndex = function(colInd){
	_self.chartDataColInd = colInd;
}

/**
* 	@desc: set default options for chart
* 	@type: private 
**/
dhtmlXGridToChartObject.prototype._setDefaultOptions = function(){
//  	alert("Set default options for : "+_self.libName);
  	switch(_self.libName) {
    case "fly":
    	//Graph
		_self._addXMLData("graph","","top","40");
		_self._addXMLData("graph","","left","80");
		_self._addXMLData("graph","","backgroundImage","");
		
		//Chart fonts
		_self._addXMLData("graph.font.FontCaption","","font","Arial");
		_self._addXMLData("graph.font.FontCaption","","size","14");
		_self._addXMLData("graph.font.FontCaption","","color","8e96f6");		
		_self._addXMLData("graph.font.FontCaption","","bold","false");
		_self._addXMLData("graph.font.FontCaption","","italic","false");
		//_self._addXMLData("graph.font");
		_self._addXMLData("graph.font.FontAxis","","font","Arial");
		_self._addXMLData("graph.font.FontAxis","","size","12");
		_self._addXMLData("graph.font.FontAxis","","color","8e96f6");
		_self._addXMLData("graph.font.FontAxis","","bold","false");
		_self._addXMLData("graph.font.FontAxis","","italic","false");
		//_self._addXMLData("graph.font");
		_self._addXMLData("graph.font.FontLegend","","font","Arial");
		_self._addXMLData("graph.font.FontLegend","","size","14");
		_self._addXMLData("graph.font.FontLegend","","color","8e96f6");		
		_self._addXMLData("graph.font.FontLegend","","bold","false");
		_self._addXMLData("graph.font.FontLegend","","italic","false");
		//_self._addXMLData("graph.font");
		_self._addXMLData("graph.font.FontTips","","font","Arial");
		_self._addXMLData("graph.font.FontTips","","size","10");
		_self._addXMLData("graph.font.FontTips","","color","FFFFFF");		
		_self._addXMLData("graph.font.FontTips","","bold","false");
		_self._addXMLData("graph.font.FontTips","","italic","false");
		
		//_self._addXMLData("graph.font");
		_self._addXMLData("graph.font.FontBase","","font","Arial");
		_self._addXMLData("graph.font.FontBase","","size","15");
		_self._addXMLData("graph.font.FontBase","","color","8e96f6");		
		_self._addXMLData("graph.font.FontBase","","bold","true");
		_self._addXMLData("graph.font.FontBase","","italic","true");
		_self._addXMLData("graph.font.FontBase","","align","right");
		
		//_self._addXMLData("graph.font");
		_self._addXMLData("graph.font.FontChart","","font","Arial");
		_self._addXMLData("graph.font.FontChart","","size","11");
		_self._addXMLData("graph.font.FontChart","","color","bbc0f6");		
		_self._addXMLData("graph.font.FontChart","","bold","true");
		_self._addXMLData("graph.font.FontChart","","italic","false");
		
		//tips
		_self._addXMLData("graph.tips","","font","FontTips");
		_self._addXMLData("graph.tips.color","5662f6");
		_self._addXMLData("graph.tips.borderColor","8e96f6");
		_self._addXMLData("graph.tips.mask","%chartName:%name = %value");

		//scroll


    	//caption
		_self._addXMLData("graph.caption","","caption","");
		_self._addXMLData("graph.caption","","font","FontCaption");
		_self._addXMLData("graph.caption","","caption_axisx",""); //x-title
		_self._addXMLData("graph.caption","","caption_axisy",""); //y-title
		
		//Global scene
		_self._addXMLData("graph.chartScene","","width","350");
		_self._addXMLData("graph.chartScene","","height","250");
		_self._addXMLData("graph.chartScene","","backgroundImage","");
		_self._addXMLData("graph.chartScene","","top1","40");
		_self._addXMLData("graph.chartScene","","left1","40");
		_self._addXMLData("graph.chartScene.color","FFFFFF");
		_self._addXMLData("graph.chartScene.opacity","100");
		_self._addXMLData("graph.chartScene.border","2");
		_self._addXMLData("graph.chartScene.borderColor","FFFFFF");
		
		//alert(" indexof() = "+ _self.chartTypeDetail.indexOf("3d"));
		
		if(_self.chartTypeDetail.indexOf("3d") != -1) {
			//3D SCENE
			_self._addXMLData("graph.chartScene3D","","type","cascade");
			_self._addXMLData("graph.chartScene3D.border","");
			_self._addXMLData("graph.chartScene3D.borderColor","");
			_self._addXMLData("graph.chartScene3D.depthy","3");
			_self._addXMLData("graph.chartScene3D.depthx","10");
			_self._addXMLData("graph.chartScene3D.indentHeight","30");
			_self._addXMLData("graph.chartScene3D.indentDepth","40");
			_self._addXMLData("graph.chartScene3D.colorLight","fafafa");
			_self._addXMLData("graph.chartScene3D.colorNormal","efefef");
			_self._addXMLData("graph.chartScene3D.colorDark","dedede");
			_self._addXMLData("graph.chartScene3D.shadowColor","c6e2ff");
			_self._addXMLData("graph.chartScene3D.chartPadding","10");
		}
		
		//Chart grid
/*		_self._addXMLData("graph.grid");
		_self._addXMLData("graph.grid.axisLine","1");
		_self._addXMLData("graph.grid.axisColor","2");
		_self._addXMLData("graph.grid.vertical",".1");
		_self._addXMLData("graph.grid.verticalColor","c8c8c8");
		_self._addXMLData("graph.grid.horizontal",".1");
		_self._addXMLData("graph.grid.horizontalColor","c8c8c8");
		_self._addXMLData("graph.grid.verticalMarkWidth","4");
		_self._addXMLData("graph.grid.verticalMarkHeight","1");						
		_self._addXMLData("graph.grid.verticalMarkColor","00ff00");
		_self._addXMLData("graph.grid.horizontalMarkWidth","4");
		_self._addXMLData("graph.grid.horizontalMarkHeight","1");						
		_self._addXMLData("graph.grid.horizontalMarkColor","00ff00");
*/
		_self._addXMLData("graph.grid.vertical",".1");
		_self._addXMLData("graph.grid.verticalColor","FFFFFF");
		_self._addXMLData("graph.grid.horizontal",".1");
		_self._addXMLData("graph.grid.horizontalColor","FFFFFF");

		//Axis
		_self._addXMLData("graph.axis","","font","FontAxis");		
		_self._addXMLData("graph.axis","","yname","");		
		_self._addXMLData("graph.axis","","xname","");		
		_self._addXMLData("graph.axis","","yleft","0");		
		_self._addXMLData("graph.axis","","ybottom","3");		
		_self._addXMLData("graph.axis","","xleft","5");		
		_self._addXMLData("graph.axis","","xbottom","3");
		
		_self._addXMLData("graph.axis.y-axis","","valueinterval","40");
		_self._addXMLData("graph.axis.y-axis","","intervalLine","40");
		_self._addXMLData("graph.axis.y-axis","","interval","40");		
		
	  	//_self._addXMLData("graph.axis.x-axis","","gridWidth","50");
	  	//_self._addXMLData("graph.axis.x-axis","","stepWidth","50");
	  	_self._addXMLData("graph.axis.x-axis","","rotation","off");
	  	_self._addXMLData("graph.axis.x-axis","","interval","1");
	  	_self._addXMLData("graph.axis.x-axis","","intervalLine","40");
	  	
	  	_self._addXMLData("graph.base","","color","000000");
	  	_self._addXMLData("graph.base","","font","FontBase");		
	  	
	  			
	  	_self._addXMLData("graph.pieChart","","radius","100");
	  	_self._addXMLData("graph.pieChart","","linewidth","1");
	  	_self._addXMLData("graph.pieChart","","lineopacity","35");
	  	_self._addXMLData("graph.pieChart","","lineColor","bbc0f6");
	  	
	  	/*
	  	var min_value = 0;
	  	var max_value = 0;
	  	
	  	for(var i=0; i < _self.sourceGrid.getRowsNum(); i++) {
	  		if(i == 0) {
	  			min_value = _self.sourceGrid.cells2(i, 0).getValue();
	  			max_value = _self.sourceGrid.cells2(i, 0).getValue();
	  		}
	  		
	  		min_value = Math.min(_self.sourceGrid.cells2(i, 0).getValue(), min_value);
	  		max_value = Math.max(_self.sourceGrid.cells2(i, 0).getValue(), max_value);
	  	}
	  	
	  	//_self._addXMLData("graph.axis.x-axis","","start", min_value);
	  	//_self._addXMLData("graph.axis.x-axis","","end", max_value);
	  	*/
	  	

    break;
	}
}

/**
*	@desc: add XML params
*	@param: nodeName - option name (e.g. graph.grid.color)
*	@param: nodeValue - option value
*	@param: paramName - option attribute name
*	@param: paramvalue - option attribute value
*	@param: type - type of operation (add,del or edit)
**/
dhtmlXGridToChartObject.prototype._addXMLData = function (nodeName,nodeValue,paramName,paramValue,type) {
  	var nodeList = nodeName.split("."); //속성별 split
  	if (type=="del") {	
		var openTagEndChar = _self.chartXMLData.substr(_self.chartXMLData.indexOf("<"+nodeList[nodeList.length-1])+("<"+nodeList[nodeList.length-1]).length,1);
		_self.chartXMLData =_self.chartXMLData.substr(0,_self.chartXMLData.lastIndexOf("<"+nodeList[nodeList.length-1]+openTagEndChar))+
				   _self.chartXMLData.substr(_self.chartXMLData.lastIndexOf("</"+nodeList[nodeList.length-1]+">")+("</"+nodeList[nodeList.length-1]+">").length);
		return;
	}
 	if (nodeList.length>1) {
  		if ((_self.chartXMLData.indexOf("<"+nodeList[0]+">")==-1)&&(_self.chartXMLData.indexOf("<"+nodeList[0]+" ")==-1))
		  	_self.chartXMLData+="<"+nodeList[0]+"></"+nodeList[0]+">";
		if (type=="add"&&nodeList.length==2) {
//		  	alert("star add: "+_self.chartXMLData);
  			  	_self.chartXMLData = _self.chartXMLData.substr(0,_self.chartXMLData.lastIndexOf("</"+nodeList[0]+">"))+
  						 			"<"+nodeList[1]+(paramName&&nodeList.length==2?" "+paramName+"=\""+paramValue+"\"":"")+">"+(nodeValue&&nodeList.length==2?nodeValue:"")+"</"+nodeList[1]+">"+
  						 			_self.chartXMLData.substr(_self.chartXMLData.lastIndexOf("</"+nodeList[0]+">"));  				
//		  	alert("end add: "+_self.chartXMLData);  						 			
	  	} else {
		    var parentNodeAsText = "";
			if (_self.chartXMLData.indexOf("<"+nodeList[0]+" ")!=-1)
				parentNodeAsText = _self.chartXMLData.substr(_self.chartXMLData.lastIndexOf("<"+nodeList[0]+" "),
					  			   _self.chartXMLData.lastIndexOf("</"+nodeList[0]+">")-_self.chartXMLData.lastIndexOf("<"+nodeList[0]+" ")+("</"+nodeList[0]+">").length);
			else 
				parentNodeAsText = _self.chartXMLData.substr(_self.chartXMLData.indexOf("<"+nodeList[0]+">"),
					  			   _self.chartXMLData.indexOf("</"+nodeList[0]+">")-_self.chartXMLData.indexOf("<"+nodeList[0]+">")+("</"+nodeList[0]+">").length);
					  			   
	  	  	if ((parentNodeAsText.indexOf("<"+nodeList[1]+">")==-1)&&(parentNodeAsText.indexOf("<"+nodeList[1]+" ")==-1)) {
//	  	  	  		  	alert("start edit: "+_self.chartXMLData);
  			  	_self.chartXMLData = _self.chartXMLData.substr(0,_self.chartXMLData.lastIndexOf("</"+nodeList[0]+">"))+
  						 			"<"+nodeList[1]+(paramName&&nodeList.length==2?" "+paramName+"=\""+paramValue+"\"":"")+">"+(nodeValue&&nodeList.length==2?nodeValue:"")+"</"+nodeList[1]+">"+
  						 			_self.chartXMLData.substr(_self.chartXMLData.lastIndexOf("</"+nodeList[0]+">"));  				
//						  	alert("end edit: "+_self.chartXMLData);  						 			
			}
  			else if (nodeList.length==2) {
  			  	if (_self.chartXMLData.indexOf("<"+nodeList[1]+" ")!=-1)
					var openTagEndChar = _self.chartXMLData.substr(_self.chartXMLData.indexOf("<"+nodeList[1]+" ")+("<"+nodeList[1]).length,1);
				else
					var openTagEndChar = _self.chartXMLData.substr(_self.chartXMLData.indexOf("<"+nodeList[1]+">")+("<"+nodeList[1]).length,1);
//				if (_self.chartXMLData.indexOf("<"+nodeList[1]+" ")!=-1) {
				  	var nodeAsText = _self.chartXMLData.substr(_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar),
					  				 _self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar))-_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar)+1)
					var nodeAsValue = _self.chartXMLData.substr(_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar))+1,
									  _self.chartXMLData.indexOf("<",_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar)))-_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar))-1)
//					alert("nodeastext: "+nodeAsText+" nodevalue: "+nodeAsValue);
					//Node params and value replacing block															  
					if ((paramName!="")&&nodeAsText.indexOf(paramName+"=")!=-1) {
//						alert("Node nodeAsText: "+nodeAsText+"\nreplace param: "+paramName+" with value: "+paramValue)
						nodeAsText = nodeAsText.substr(0,nodeAsText.indexOf("\"",nodeAsText.indexOf(paramName+"=")))+
									 "\""+paramValue+"\""+
									 nodeAsText.substr(nodeAsText.indexOf("\"",nodeAsText.indexOf("\"",nodeAsText.indexOf(paramName+"="))+1)+1)
					}
					//Node params and value add block
					else {
						nodeAsText = nodeAsText.substr(0,nodeAsText.length-1)+(paramName?" "+paramName+"=\""+paramValue+"\"":"")+">";
//						alert("Node nodeAsText: "+nodeAsText+"\nNew param name: "+paramName+" with value: "+paramValue)
					}
//					alert("nodeastext: "+nodeAsText+" nodevalue: "+nodeAsValue);
					nodeAsValue = (nodeValue?nodeValue:"")
					_self.chartXMLData = _self.chartXMLData.substr(0,_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar))+
										 nodeAsText+nodeAsValue+
					  				 _self.chartXMLData.substr(_self.chartXMLData.indexOf("<",_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeList[1]+openTagEndChar))))//-_self.chartXMLData.indexOf("<"+nodeList[1]+" ")))
			}			
		}
		if (nodeList.length>2) {
		  	nodeList.splice(0,1);
		  	_self._addXMLData(nodeList.join("."),nodeValue,paramName,paramValue,type)
		}
	} else
		if (_self.chartXMLData.indexOf(nodeName)==-1)
			_self.chartXMLData+="<"+nodeName+(paramName?" "+paramName+"=\""+paramValue+"\"":"")+">"+(nodeValue?nodeValue:"")+"</"+nodeName+">";
		else {
  			  	if (_self.chartXMLData.indexOf("<"+nodeName+" ")!=-1)
					var openTagEndChar = _self.chartXMLData.substr(_self.chartXMLData.indexOf("<"+nodeName+" ")+("<"+nodeName).length,1);
				else
					var openTagEndChar = _self.chartXMLData.substr(_self.chartXMLData.indexOf("<"+nodeName+">")+("<"+nodeName).length,1);
//				if (_self.chartXMLData.indexOf("<"+nodeList[1]+" ")!=-1) {
		  	var nodeAsText = _self.chartXMLData.substr(_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar),
			  				 _self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar))-_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar)+1)
			var nodeAsValue = _self.chartXMLData.substr(_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar))+1,
							  _self.chartXMLData.indexOf("<",_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar)))-_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar))-1)
//					alert("nodeastext: "+nodeAsText+" nodevalue: "+nodeAsValue);
			//Node params and value replacing block															  
			if ((paramName!="")&&nodeAsText.indexOf(paramName+"=")!=-1) {
//						alert("Node nodeAsText: "+nodeAsText+"\nreplace param: "+paramName+" with value: "+paramValue)
				nodeAsText = nodeAsText.substr(0,nodeAsText.indexOf("\"",nodeAsText.indexOf(paramName+"=")))+
							 "\""+paramValue+"\""+
							 nodeAsText.substr(nodeAsText.indexOf("\"",nodeAsText.indexOf("\"",nodeAsText.indexOf(paramName+"="))+1)+1)
			}
			//Node params and value add block
			else {
				nodeAsText = nodeAsText.substr(0,nodeAsText.length-1)+(paramName?" "+paramName+"=\""+paramValue+"\"":"")+">";
//						alert("Node nodeAsText: "+nodeAsText+"\nNew param name: "+paramName+" with value: "+paramValue)
			}
//					alert("nodeastext: "+nodeAsText+" nodevalue: "+nodeAsValue);
			nodeAsValue = (nodeValue?nodeValue:"")
			_self.chartXMLData = _self.chartXMLData.substr(0,_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar))+
								 nodeAsText+nodeAsValue+
			  				 _self.chartXMLData.substr(_self.chartXMLData.indexOf("<",_self.chartXMLData.indexOf(">",_self.chartXMLData.lastIndexOf("<"+nodeName+openTagEndChar))))//-_self.chartXMLData.indexOf("<"+nodeList[1]+" ")))					  				
		}
}

/**
* 	@desc: set options for chart
*	@param: opiton name
* 	@param: opiton value
*	@param: preview enable (true/false)
* 	@type: public
**/
dhtmlXGridToChartObject.prototype.setChartOption = function(optName,optValue,preview){
	switch(_self.libName) {
		case "fly":
			switch(optName) {
				case "chartColors" :
					_self.chartDefaultColors= optValue.replace(/#/g,"").toString().split(",")
					break;
				//*********************************************************************************************************************************************************************************
				//* graph 옵션
				case "graph_top" : 
					_self._addXMLData("graph","","top",optValue);
					break;
				case "graph_left" : 
					_self._addXMLData("graph","","left",optValue);
					break;
				case "graph_backgroundImage" : 
					_self._addXMLData("graph","","backgroundImage",optValue);
					break;
				//*********************************************************************************************************************************************************************************
				//* font 옵션
				case "font_font" : 
					optValue = optValue.split(",");
					_self._addXMLData("graph.font."+optValue[0],"","font",optValue[1]);
					break;
				case "font_size" : 
					optValue = optValue.split(",");
					_self._addXMLData("graph.font."+optValue[0],"","size",optValue[1]);
					break;
				case "font_color" : 
					optValue = optValue.split(",");
					_self._addXMLData("graph.font."+optValue[0],"","color",optValue[1]);
					break;
				case "font_bold" : 
					optValue = optValue.split(",");
					_self._addXMLData("graph.font."+optValue[0],"","bold",optValue[1]);
					break;
				case "font_italic" : 
					optValue = optValue.split(",");
					_self._addXMLData("graph.font."+optValue[0],"","italic",optValue[1]);
					break;
				//*********************************************************************************************************************************************************************************
				//* tips 옵션
				case "tips_font" : 
					_self._addXMLData("graph.tips.font","","font",optValue);
					break;
				case "tips_color" : 
					_self._addXMLData("graph.tips.color",optValue.replace(/#/g,""));
					break;
				case "tips_borderColor" : 
					_self._addXMLData("graph.tips.color",optValue.replace(/#/g,""));
					break;
				case "tips_mask" : 
					_self._addXMLData("graph.tips.mask",optValue);
					break;
				//*********************************************************************************************************************************************************************************
				//* scroll 옵션
				case "showSlider": //default 옵션 셋팅 
					if (optValue) {
						_self._addXMLData("graph.chartScene","","height",_self.externalContainer.height-120);					//Navigation
						_self._addXMLData("graph.scroll","","position","bottom");
						_self._addXMLData("graph.scroll","","top1","340");
						_self._addXMLData("graph.scroll","","left1","40");
						_self._addXMLData("graph.scroll","","height","30");
						_self._addXMLData("graph.scroll","","backgroundImage","");
						_self._addXMLData("graph.scroll.border","1");
						_self._addXMLData("graph.scroll.borderColor",_self.chartDefaultColors[0]);		
						_self._addXMLData("graph.scroll.sliderBorder","1");
						_self._addXMLData("graph.scroll.sliderBorderColor",_self.chartDefaultColors[1]);
						_self._addXMLData("graph.scroll.sliderColor",_self.chartDefaultColors[0]+","+_self.chartDefaultColors[1]+","+_self.chartDefaultColors[1]+","+_self.chartDefaultColors[0]);		
						_self._addXMLData("graph.scroll.sliderOpacity","40, 20, 20, 40");
						_self._addXMLData("graph.scroll.pictureColor",_self.chartDefaultColors[1]);						
					} else {
						//_self._addXMLData("graph.scroll","","","","del");
						//_self._addXMLData("graph.chartScene","","height",_self.externalContainer.height-50);
					}
					break;
				case "scroll_position":
						_self._addXMLData("graph.scroll","","position",optValue);
					break;
				case "scroll_top1":
						_self._addXMLData("graph.scroll","","top1",optValue);
					break;
				case "scroll_left1":
						_self._addXMLData("graph.scroll","","left1",optValue);
					break;
				case "scroll_height":
						_self._addXMLData("graph.scroll","","height",optValue);
					break;
				case "scroll_backgroundImage":
						_self._addXMLData("graph.scroll","","backgroundImage",optValue);
					break;
				case "scroll_border":
						_self._addXMLData("graph.scroll.border",optValue);
					break;
				case "scroll_borderColor":
						_self._addXMLData("graph.scroll.borderColor",optValue.replace(/#/g,""));		
					break;
				case "scroll_sliderBorder":
						_self._addXMLData("graph.scroll.sliderBorder",optValue);
					break;
				case "scroll_sliderBorderColor":
						_self._addXMLData("graph.scroll.sliderBorderColor",optValue.replace(/#/g,""));
					break;
				case "scroll_sliderColor":
						_self._addXMLData("graph.scroll.sliderColor",optValue.replace(/#/g,""));		
					break;
				case "scroll_sliderOpacity":
						_self._addXMLData("graph.scroll.sliderOpacity",optValue);
					break;
				case "scroll_pictureColor":
						_self._addXMLData("graph.scroll.pictureColor",optValue.replace(/#/g,""));						
					break;
				//*********************************************************************************************************************************************************************************
				//* Regend 옵션
				case "showLegend":
					//_self._addXMLData("graph.legend.show",optValue);
					if(optValue) {
						_self._addXMLData("graph.legend","","position","right");
				 		_self._addXMLData("graph.legend","","left","460");
						_self._addXMLData("graph.legend","","font","FontLegend");
						_self._addXMLData("graph.legend","","width","100");
						_self._addXMLData("graph.legend","","height","196");
						_self._addXMLData("graph.legend.border","1");
						_self._addXMLData("graph.legend.borderColor","FFFFFF");
						_self._addXMLData("graph.legend.color"," FFFFFF");
						_self._addXMLData("graph.legend.opacity","10, 50");
					}
					break;
				case "legend_position" :
					_self._addXMLData("graph.legend","","position",optValue);
					break;
				case "legend_left" :
					_self._addXMLData("graph.legend","","left",optValue);
					break;
				case "legend_font" :
					_self._addXMLData("graph.legend","","font",optValue);
					break;
				case "legend_width" :
					_self._addXMLData("graph.legend","","width",optValue);
					break;
				case "legend_height" :
					_self._addXMLData("graph.legend","","height",optValue);
					break;
				case "legend_backgroundImage" :
					_self._addXMLData("graph.legend","","backgroundImage",optValue);
					break;
				case "legend_border" :
					_self._addXMLData("graph.legend.border",optValue);
					break;
				case "legend_borderColor" :
					_self._addXMLData("graph.legend.borderColor",optValue.replace(/#/g,""));
					break;
				case "legend_color" :
					_self._addXMLData("graph.legend.color",optValue.replace(/#/g,""));
					break;
				case "legend_opacity" :
					_self._addXMLData("graph.legend.opacity",optValue);
					break;
				case "legend_boxWidth" :
					_self._addXMLData("graph.legend.boxWidth",optValue);
					break;
				case "legend_boxHeight" :
					_self._addXMLData("graph.legend.boxHeight",optValue);
					break;
				case "legend_boxTop" :
					_self._addXMLData("graph.legend.boxTop",optValue);
					break;
				case "legend_boxLeft" :
					_self._addXMLData("graph.legend.boxLeft",optValue);
					break;
				/*case "legendBGOpacity" :
					_self._addXMLData("graph.legend.opacity",optValue);
					break;
				case "legendBGColor":
					_self._addXMLData("graph.legend.color",optValue.replace(/#/g,""));
					break;*/
				//*********************************************************************************************************************************************************************************
				//* chartScene 옵션
				case "chartScene_width" : 
					_self._addXMLData("graph.chartScene","","width",optValue);
					break;
				case "chartScene_height" : 
					_self._addXMLData("graph.chartScene","","height",optValue);
					break;
				case "chartScene_top1" : 
					_self._addXMLData("graph.chartScene","","top1",optValue);
					break;
				case "chartScene_left1" : 
					_self._addXMLData("graph.chartScene","","left1",optValue);
					break;
				case "chartScene_backgroundImage" : 
					_self._addXMLData("graph.chartScene","","backgroundImage",optValue);
					break;
				case "chartScene_color" : 
					_self._addXMLData("graph.chartScene.color",optValue.replace(/#/g,""));
					break;
				case "chartScene_opacity" : 
					_self._addXMLData("graph.chartScene.opacity",optValue);
					break;
				case "chartScene_border" : 
					_self._addXMLData("graph.chartScene.border",optValue);
					break;
				case "chartScene_borderColor" : 
					_self._addXMLData("graph.chartScene.borderColor",optValue.replace(/#/g,""));
					break;
				//*********************************************************************************************************************************************************************************
				//* chartScene3D 옵션
				case "chartScene3D_type" : 
					_self._addXMLData("graph.chartScene3D","","type",optValue);
					break;
				case "chartScene3D_border" : 
					_self._addXMLData("graph.chartScene3D.border",optValue);
					break;
				case "chartScene3D_borderColor" : 
					_self._addXMLData("graph.chartScene3D.borderColor",optValue);
					break;
				case "chartScene3D_depthy" : 
					_self._addXMLData("graph.chartScene3D.depthy",optValue);
					break;
				case "chartScene3D_depthx" : 
					_self._addXMLData("graph.chartScene3D.depthx",optValue);
					break;
				case "chartScene3D_indentHeight" : 
					_self._addXMLData("graph.chartScene3D.indentHeight",optValue);
					break;
				case "chartScene3D_indentDepth" : 
					_self._addXMLData("graph.chartScene3D.indentDepth",optValue);
					break;
				case "chartScene3D_colorLight" : 
					_self._addXMLData("graph.chartScene3D.colorLight",optValue.replace(/#/g,""));
					break;
				case "chartScene3D_colorNormal" : 
					_self._addXMLData("graph.chartScene3D.colorNormal",optValue.replace(/#/g,""));
					break;
				case "chartScene3D_colorDark" : 
					_self._addXMLData("graph.chartScene3D.colorDark",optValue.replace(/#/g,""));
					break;
				case "chartScene3D_shadowColor" : 
					_self._addXMLData("graph.chartScene3D.shadowColor",optValue.replace(/#/g,""));
					break;
				case "chartScene3D_chartPadding" : 
					_self._addXMLData("graph.chartScene3D.chartPadding",optValue);
					break;
				//*********************************************************************************************************************************************************************************
				//* grid 옵션
				case "gridColor" :
					_self._addXMLData("graph.grid.verticalColor",optValue);
					_self._addXMLData("graph.grid.horizontalColor",optValue);
					_self._addXMLData("graph.grid.verticalMarkColor",optValue);
					_self._addXMLData("graph.grid.horizontalMarkColor",optValue);															
					break;
				case "grid_axisLine" :
					_self._addXMLData("graph.grid.axisLine",optValue);
					break;
				case "grid_axisColor" :
					_self._addXMLData("graph.grid.axisColor",optValue);
					break;
				case "grid_vertical" :
					_self._addXMLData("graph.grid.vertical",optValue);
					break;
				case "grid_verticalColor" :
					_self._addXMLData("graph.grid.verticalColor",optValue.replace(/#/g,""));
					break;
				case "grid_horizontal" :
					_self._addXMLData("graph.grid.horizontal",optValue);
					break;
				case "grid_horizontalColor" :
					_self._addXMLData("graph.grid.horizontalColor",optValue.replace(/#/g,""));
					break;
				case "grid_verticalMarkWidth" :
					_self._addXMLData("graph.grid.verticalMarkWidth",optValue);
					break;
				case "grid_verticalMarkHeight" :
					_self._addXMLData("graph.grid.verticalMarkHeight",optValue);
					break;
				case "grid_verticalMarkColor" :
					_self._addXMLData("graph.grid.verticalMarkColor",optValue.replace(/#/g,""));
					break;
				case "grid_horizontalMarkWidth" :
					_self._addXMLData("graph.grid.horizontalMarkWidth",optValue);
					break;
				case "grid_horizontalMarkHeight" :
					_self._addXMLData("graph.grid.horizontalMarkHeight",optValue);
					break;
				case "grid_horizontalMarkColor" :
					_self._addXMLData("graph.grid.horizontalMarkColor",optValue.replace(/#/g,""));
					break;
				//*********************************************************************************************************************************************************************************
				//* axis 옵션
				case "axis_xleft" :
					_self._addXMLData("graph.axis","","xleft",optValue);
					break;
				case "axis_xbottom" :
					_self._addXMLData("graph.axis","","xbottom",optValue);
					break;
				case "axis_yleft" :
					_self._addXMLData("graph.axis","","yleft",optValue);
					break;
				case "axis_ybottom" :
					_self._addXMLData("graph.axis","","ybottom",optValue);
					break;
				case "axis_xname" :
					_self._addXMLData("graph.axis","","xname",optValue);
					break;
				case "axis_yname" :
					_self._addXMLData("graph.axis","","yname",optValue);
					break;
				case "axis_font" :
					_self._addXMLData("graph.axis","","font",optValue);
					break;
				//*********************************************************************************************************************************************************************************
				//* x-axis 옵션
				case "x-axis_rotation" :	
					// x 축의 이름 표현방식
					// on : 대각선으로 보이게 한다.
					// off : 가로로 보이게 한다.
					_self._addXMLData("graph.axis.x-axis","","rotation",optValue);
					break;
				case "x-axis_start" :
				  	_self._addXMLData("graph.axis.x-axis","","start",optValue);
					break;	
				case "x-axis_end" :
				  	_self._addXMLData("graph.axis.x-axis","","end",optValue);
					break;
				case "x-axis_step" :
				  	_self._addXMLData("graph.axis.x-axis","","step",optValue);
					break;
				case "x-axis_gridWidth" :
				  	_self._addXMLData("graph.axis.x-axis","","gridWidth",optValue);
					break;
				case "x-axis_stepWidth" :
				  	_self._addXMLData("graph.axis.x-axis","","stepWidth",optValue);
					break;	
				case "x-axis_interval" :
				  	_self._addXMLData("graph.axis.x-axis","","interval",optValue);
					break;	
				case "x-axis_intervalLine" :
				  	_self._addXMLData("graph.axis.x-axis","","intervalLine",optValue);
					break;	
				//*********************************************************************************************************************************************************************************
				//* y-axis 옵션
				case "y-axis_start" :
				  	_self._addXMLData("graph.axis.y-axis","","start",optValue);
					break;	
				case "y-axis_end" :
				  	_self._addXMLData("graph.axis.y-axis","","end",optValue);
					break;	
				case "y-axis_interval" :
				  	_self._addXMLData("graph.axis.y-axis","","interval",optValue);
					break;	
				case "y-axis_intervalLine" :
				  	_self._addXMLData("graph.axis.y-axis","","intervalLine",optValue);
					break;	
				case "y-axis_valueinterval" :
				  	_self._addXMLData("graph.axis.y-axis","","valueinterval",optValue);
					break;
				//*********************************************************************************************************************************************************************************
				//* caption 옵션
				case "caption_caption" : 
					_self._addXMLData("graph.caption","","caption",optValue);
					break;
				case "caption_axisx" : 
					_self._addXMLData("graph.caption","","caption_axisx",optValue);
					break;
				case "caption_axisy" : 
					_self._addXMLData("graph.caption","","caption_axisy",optValue);
					break;
				case "caption_font" : 
					_self._addXMLData("graph.caption","","font",optValue);
					break;
				//*********************************************************************************************************************************************************************************
				//* 
				case "legendLabelsColor" :
					_self._addXMLData("graph.font.FontLegend","","color",optValue.replace(/#/g,""));
					break;
				case "fill" :
					if (optValue==true)
					_self.chartType = "area";
//						_self.chartXMLData.replace(/"line"/g,"area");				
					break;
				case "showDataPoints":
			  		_self.dataPointRadius = 0;
					break;
				case "barWidth":
						_self.chartBarWidth = optValue;
					break;
				case "showPointTitles":
						_self.pointTitles = optValue;
					break;
				case "pointsRadius":				
					_self.dataPointRadius = optValue;
					break;
				case "chartLabelsColor" :
					_self._addXMLData("graph.font.FontAxis","","color",optValue.replace(/#/g,""));					
					break;
				case "showLabels" :
					if (optValue===false)
						_self.chartTicksColInd = null;
					break
				case "labelsColInd" :
					_self.chartTicksColInd = optValue;
					break;
				//*********************************************************************************************************************************************************************************
				//
			}
			break;		
	}  	
}

/** 
* 	@desc: get data from dhtmlXGrid and prepare their for Chart 
* 	@type: private
**/
dhtmlXGridToChartObject.prototype._setChartDataset = function(){
  	var colIndexes = _self.chartDataColInd.toString().split(",");
//	alert(_self.libName+" dataset");  	
	switch(_self.libName) {
		case "plotr":
			for (j=0;j<colIndexes.length;j++) {
				var tmpArray = new Array()
				for (var i=0;i<_self.sourceGrid.getRowsNum();i++) {
					tmpArray.push([i,parseInt(_self.sourceGrid.cells2(i,colIndexes[j]).getValue())]);
				}
				_self.chartDataset[_self.sourceGrid.getHeaderCol(colIndexes[j])] = tmpArray;		
			}
			break;    
		case "google charts":
			_self.chartDataset="";
			var max = 0;
			for (j=0;j<colIndexes.length;j++) {
				for (var i=0;i<_self.sourceGrid.getRowsNum();i++) {
					if (parseInt(max)<parseInt(_self.sourceGrid.cells2(i,colIndexes[j]).getValue())) max=_self.sourceGrid.cells2(i,colIndexes[j]).getValue();
//					alert(_self.sourceGrid.cells2(i,colIndexes[j]).getValue());
				}
			}
			for (j=0;j<colIndexes.length;j++) {
				for (var i=0;i<_self.sourceGrid.getRowsNum();i++) {
					_self.chartDataset += ","+Math.round(_self.sourceGrid.cells2(i,colIndexes[j]).getValue()/max*100);
				}
				if (j!=colIndexes.length-1) _self.chartDataset += "|";
			}
			_self.chartDataset = _self.chartDataset.replace("|,","|").substr(1);
		 	_self.maxValue = max;
			break;
		case "flot":
			_self.chartDataset	= new Array();
			if (_self.chartType=="bar")			
				_self.chartBarWidth = (_self.sourceGrid.getRowsNum()-(_self.sourceGrid.getRowsNum()-1)*0.25)/(_self.sourceGrid.getRowsNum()*colIndexes.length);
			
			for (j=0;j<colIndexes.length;j++) {
			  	var tempData = new Array();
			  	var tempChartData = {};
			  	var tempChartOption = {};
				for (var i=0;i<_self.sourceGrid.getRowsNum();i++) {
				  	tempData.push([i+_self.chartBarWidth*j,parseInt(_self.sourceGrid.cells2(i,colIndexes[j]).getValue())]);
				}

				tempChartOption["show"] 	= true;
				tempChartOption["barWidth"] = _self.chartBarWidth;
				tempChartData["label"] 		= _self.sourceGrid.getHeaderCol(colIndexes[j]);
				tempChartData["data"] 		= tempData;				
				tempChartData[_self.chartType+"s"] 		= tempChartOption;//{ show: true, barWidth:_self.chartBarWidth};			
				_self.chartDataset.push(tempChartData);				
			}
		  	if (_self.chartTicksColInd)
				_self.setChartOption("labelsColInd",_self.chartTicksColInd,_self.chartPreview);
		 	_self.maxValue = max;
			break;
		case "fly":
			//_self.chartDataset = 
				if (_self.chartTicksColInd) {
					var tmp = new Array;					  
					for (var i=0;i<_self.sourceGrid.getRowsNum();i++) {
						_self._addXMLData("graph.axis.x-axis.col",_self.sourceGrid.cells2(i,_self.chartTicksColInd).getValue(),"","","add");
					}
				}
//			if (_self.chartType=="bar")			
//				_self.chartBarWidth = (_self.sourceGrid.getRowsNum()-(_self.sourceGrid.getRowsNum()-1)*0.25)/(_self.sourceGrid.getRowsNum()*colIndexes.length);

			for (j=0;j<colIndexes.length;j++) {
			  			//Chart default style
						_self._addXMLData("graph.chartstyle","","name","defstyle"+j,"add");
						_self._addXMLData("graph.chartstyle.type",_self.chartType);
						_self._addXMLData("graph.chartstyle.font","FontChart");
						_self._addXMLData("graph.chartstyle.name",_self.sourceGrid.getHeaderCol(colIndexes[j]));
						_self._addXMLData("graph.chartstyle.tips","on");
						_self._addXMLData("graph.chartstyle.pointTitles",(_self.pointTitles?"on":"off"));
						_self._addXMLData("graph.chartstyle.lineColor",_self.chartDefaultColors[j]);
						
						if(_self.chartType == "pie") {
							_self._addXMLData("graph.chartstyle.color",_self.chartDefaultColors[j]);
							_self._addXMLData("graph.chartstyle.opacity","70, 10");
						}
						
						_self._addXMLData("graph.chartstyle.knotType","circle");
						_self._addXMLData("graph.chartstyle.knotSize",(_self.dataPointRadius>0?parseInt(_self.dataPointRadius)*2:1));
						_self._addXMLData("graph.chartstyle.line","1");
						_self._addXMLData("graph.chartstyle.nullLine","2");
						_self._addXMLData("graph.chartstyle.columnTargetColor","FFFFFFF");
						_self._addXMLData("graph.chartstyle.columnWidth",(_self.chartBarWidth==0?15:_self.chartBarWidth));
						
		  		_self._addXMLData("graph.chart","","chartstyle","defstyle"+j,"add");
				for (var i=0;i<_self.sourceGrid.getRowsNum();i++) {
					_self._addXMLData("graph.chart.set","","name",(_self.chartTicksColInd?_self.sourceGrid.cells2(i,_self.chartTicksColInd).getValue():""),"add");
					_self._addXMLData("graph.chart.set","","value",_self.sourceGrid.cells2(i,colIndexes[j]).getValue());
					_self._addXMLData("graph.chart.set","","color",_self.chartDefaultColors[_self.chartType=="pie" ? i : j ]);
				}
			}
			
			if(_self.chartType != "pie") {
				_self._addXMLData("graph.chartstyle.color",_self.chartDefaultColors);
				_self._addXMLData("graph.chartstyle.opacity","100, 70");
			}
	}
}

/**
* 	@desc: function for show large preview (only for "Flot")
* 	@param: mode - switch preview on/off
* 	@param: w - width
* 	@param: h - height
* 	@type: public
**/
dhtmlXGridToChartObject.prototype.enablePreview = function(mode,w,h) {
  	_self.chartPreview = mode;
	_self.chartPreviewContainer = document.createElement("div");
	_self.chartPreviewContainer.style.width  	= (w ||"530px");
	_self.chartPreviewContainer.style.height 	= (h ||"300px");
	_self.chartPreviewContainer.style.display 	= "none";
	_self.chartPreviewContainer.style.position 	= "absolute";
	document.getElementsByTagName("body")[0].appendChild(_self.chartPreviewContainer);
	_self.externalContainer.onmousedown = function () {
		_self.chartPreviewContainer.style.display = "";
		_self.chartPreviewContainer.style.top = (document.body.clientHeight || innerHeight)/2-parseInt(_self.chartPreviewContainer.style.height)/2;		
		_self.chartPreviewContainer.style.left = (document.body.clientWidth || innerWidth)/2-parseInt(_self.chartPreviewContainer.style.width)/2;				
		document.body.onmouseup = function () {
			document.body.onmouseup = null;
			_self.chartPreviewContainer.style.display = "none";
		}
	  }
}

/**
* 	@desc: function which render a chart
* 	@type: public
**/
dhtmlXGridToChartObject.prototype.draw = function() {
	if (!_self.libLoadStatus) {
		window.setTimeout(function(){_self.draw()},100)
		return;
	}
	if (_self.chart) return;
	if ((!_self.libName)||(!_self.sourceGrid)||(!_self.chartDataColInd)) return;
	_self._setChartDataset();	
	switch(_self.libName) {
		case "fly" :
			//alert(_self.libPath);
		    var so = new SWFObject(_self.libPath+"chartlibs/FlyCharts2.swf?dataUrl=dummy%2Fxml","graph",_self.externalContainer.width,_self.externalContainer.height,"8","#FFFFFF");
		    //alert("경로 = "+_self.libPath+"chartlibs/FlyCharts2.swf?dataUrl=/poasrm/test/control_term_2.xml");
		    //var so = new SWFObject(_self.libPath+"chartlibs/FlyCharts2.swf?dataUrl=/poasrm/test/control_term_2.xml","graph",_self.externalContainer.width,_self.externalContainer.height,"8","#FFFFFF");
		    so.addParam("scale", "noscale");
			so.addParam("salign", "lt");
			so.addParam("allowScriptAccess", "sameDomain");
			//so.addParam("swliveconnect", "true");
			so.write(_self.externalContainer.id);
			var flash =  navigator.appName.indexOf("Microsoft") != -1 ? document["graph"]:window["graph"];
			flash = flash.length?flash[1]:flash;
			window.setTimeout(function() {
			  											  
			  								if (flash) flash.refresh(_self.chartXMLData);
										 }
								,500);
			//alert("xml data]"+_self.chartXMLData);
//			else 
//			flash[1].refresh(_self.chartXMLData);
			
		break;
	} 
}

/**
* 	@desc: preload JS files(libraries)
*	@param: filenames - JS filenames list with comma-splitter
* 	@type: _private
**/
dhtmlXGridToChartObject.prototype._loadJSFile = function(filenames) {
	var head = document.getElementsByTagName('head')[0]
	var script = document.createElement('script');
	var fileNamesArr = filenames.split(",");
	script.src = fileNamesArr[0];
	script.type = 'text/javascript';
	script.onreadystatechange = script.onload = function () {
		if ((!this.readyState)||(this.readyState=="complete")||(this.readyState=="loaded")) {
//		  	alert(fileNamesArr[0]+" was loaded !");
		  	fileNamesArr.splice(0,1);
		  	if (fileNamesArr.length>0) {
		  	  	filenames = fileNamesArr.join();
		  		_self._loadJSFile(filenames);
			} else {
				_self.libLoadStatus = true;
			    this.onreadystatechange = null;
			    return true;
			}
		}
		//alert(fileNamesArr[0]+" readyState: "+this.readyState);
		//_self.libLoadStatus = false;
		//return false;
	}
	
	head.appendChild(script)
}

