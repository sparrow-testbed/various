package sepoa.svc.approval.madec;


public class FileNameCtrl {

	public FileNameCtrl() 
	{
	}

	// extraction FileName from the full file path
	String getstrOrgFileName(String pstrOriName)
	{
		int idx = -1;
		String retStrName = new String();
		
		pstrOriName = pstrOriName.replace('\\','/');
		
		idx = pstrOriName.lastIndexOf('/');
		if(idx < 0)
		{
			if(pstrOriName.length() < 1)
			{
				return new String("###error###wrong###name###");
			}
			else
			{
				idx = -1;
			}
		}

		retStrName = new String(pstrOriName.substring(idx+1, pstrOriName.length()));
		return retStrName;
	}

	// extraction FileExtention from the FileName
	String getStrFileExtention(String pstrOriName)
	{
		int idx = -1;
		String retStrName = new String();
		idx = pstrOriName.lastIndexOf('.');
//		System.out.println( "getStrFileExtention =>  " + idx + "\n");
		if(idx < 0) return new String("###error###wrong###name###");
		

		retStrName = new String(pstrOriName.substring(idx+1, pstrOriName.length()));
		return retStrName;
	}

	String getStrNoExtFileName(String pstrOriName)
	{
		int idx = -1;
		String retStrName = new String();
		idx = pstrOriName.lastIndexOf('.');
		if(idx < 0) 
		{
			retStrName = pstrOriName;
			return retStrName;
		}
		
		retStrName = new String( pstrOriName.substring( 0, idx ));
		return retStrName;
	}
	
}
