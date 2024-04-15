/**
	catalog.js
	ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT
	 
	??)
	1)
	if(part == "CATALOG") //
	{
		if( !checkEmpty(f.account_code,"계정코드를 입력하셔야 합니다.") )
			return;
		var str_bin_flag = 'Y';
		setCatalogIndex("ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT"); //--
		url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ; //--
	}
	PopupGeneral(url, "", "", "");
	
	2)
	ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT
	function setCatalog(arr)
	{
		var wise = document.WiseTable;
		
		
		//INDEX=ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT
		var ITEM_NO = arr[getCatalogIndex("ITEM_NO")];
		alert(ITEM_NO);
		var dup_flag = false;
		for(var i=0;i<wise.getRowCount();i++)
		{
			if(ITEM_NO == wise.getValue(i,INDEX_ITEM_NO))
			{
				dup_flag = true;
				break;
			}
		}
		
		if(!dup_flag)
		{
			var iMaxRow = wise.getRowCount();
			wise.addRow();
			
			wise.setValue(iMaxRow, INDEX_ITEM_NO, "null&"+ITEM_NO+"&"+ITEM_NO, "&");
			wise.setValue(iMaxRow, INDEX_DESCRIPTION_LOC, arr[getCatalogIndex("DESCRIPTION_LOC")]);
			wise.setValue(iMaxRow, INDEX_SPECIFICATION, arr[getCatalogIndex("SPECIFICATION")]);
			wise.setValue(iMaxRow, INDEX_UNIT_MEASURE, arr[getCatalogIndex("BASIC_UNIT")]);
		
			wise.update();
		}
	}
	
*/
//<!--
var G_CATALOG_INDEX;

/*
	G_CATALOG_INDEX를 셋팅합니다.
*/
function setCatalogIndex(idxes)
{
	G_CATALOG_INDEX = idxes.split(":");
}

/*
	ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT와 같은 형태를 반환합니다.
	url = "/kr/catalog/cat_pp_lis_frame.jsp?INDEX=" + getAllCatalogIndex() ;? ?? ??? ????.
*/
function getAllCatalogIndex()
{
	var rtn = "";
	for(var i=0;i<G_CATALOG_INDEX.length;i++)
	{
		if(i==G_CATALOG_INDEX.length-1)
			rtn = rtn + G_CATALOG_INDEX[i];
		else
			rtn = rtn + G_CATALOG_INDEX[i]+ ":";
	}
	return rtn;
}

/*
	//INDEX=ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT
	var ITEM_NO = arr[getCatalogIndex("ITEM_NO")];
*/
function getCatalogIndex(idx_str)
{
	for(var i=0;i<G_CATALOG_INDEX.length;i++)
	{
		if(G_CATALOG_INDEX[i] == idx_str)
			return i;
	}
	return -1;
}
//-->
