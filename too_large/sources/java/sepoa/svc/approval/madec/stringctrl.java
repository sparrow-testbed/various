package sepoa.svc.approval.madec;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;

public class StringCtrl {


	public StringCtrl() 
	{
	}

	// check value : internally using
	int iCheckParameter(int piValue, int piStartNum, int piEndNum)
	{
		if((piValue >= piStartNum) && (piValue <= piEndNum))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	
	int iCheckParameter(String pstrValue, int piStartNum, int piEndNum)
	{
		int	iValueSize = 0;
		int rtn = 0;
		try
		{
			byte[]	byteTemp = pstrValue.getBytes( "UTF-8" );
			iValueSize = byteTemp.length;
		}
		catch ( Exception e )
		{			rtn = 0;
		}
		 
		if(( iValueSize >= piStartNum) && ( iValueSize <= piEndNum))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}

	// convert to Upper case stirng
	String toUpperCase(String pstrOriStr)
	{
		return pstrOriStr.toUpperCase();
	}

	String strConcatCharRow(String pstrBody, char [] pszToken, int piTokenSize)
	{
		StringBuffer strbToken = new StringBuffer();
		strbToken.append(pszToken, 0, piTokenSize);
		pstrBody += strbToken.toString();
		return pstrBody;
	}
/*
	void vToChar(int j, char [] retValue, int piSize)
	{
		Integer czI = new Integer(j);
		String str  = new String(czI.toString());

		for(int i = 0; i < str.length(); i++)
		{
			retValue[i] = str.charAt(i);
		}


		for(int i = str.length(); i < piSize; i++)
		{
			retValue[i] = 0x00;
		}
	}
*/
	void vToChar(int j, char [] retValue, int piSize)
	{
		char czZero = '0';
		char czBlank;
		Character czChar = new Character(' ');
		Integer czI = new Integer(j);
		String str = new String(czI.toString());

		String tmp = new String(" ");
		ByteArrayInputStream czByteStrm = null;
		try
		{
			czByteStrm = new ByteArrayInputStream(tmp.getBytes());
			InputStreamReader czIsr = new InputStreamReader(czByteStrm, "UTF-8");
			Reader in = new BufferedReader(czIsr);
			czZero = (char)in.read();
		}
		catch(Exception e)
		{			czBlank = '0';
		}

		for(int i = 0; i < str.length(); i++)
		{
			retValue[i] = str.charAt(i);

			if(retValue[i] == 0x00)
			{
				retValue[i] = czZero;
			}
		}

		for(int i = str.length(); i < piSize; i++)
		{
			retValue[i] = czZero;
		}
	}

	String strConcatChar(String pstrBody, int piInputInteger, int piIntegerSize)
	{
		char charArray[] = new char[piIntegerSize];
		vToChar(piInputInteger, charArray, piIntegerSize);

		pstrBody = strConcatCharRow(pstrBody, charArray, piIntegerSize);
		return pstrBody;
	}

	String strRightTrim( String pstrInputString, int piStringSize )
	{
		StringBuffer strbString = new StringBuffer();		
		String	     strReturn = new String();
		String		 strTemp = new String();
			
		int			 iMax = 0;
		
		try
		{
			strTemp = new String( pstrInputString.getBytes("UTF-8"), "8859_1" );
		}
		catch ( UnsupportedEncodingException e )
		{			iMax = 0;
		}
		
		strbString.setLength( piStringSize );
		strbString.replace ( 0, strTemp.length(), strTemp );			
		
		strTemp = strbString.toString();
		
		try
		{
			strReturn = new String(strTemp.getBytes("8859_1"), "UTF-8");
		}
		catch ( UnsupportedEncodingException e )
		{ iMax = 0; }
		//gPacketSizeCHK += piStringSize; //piStringSize;

		return strReturn;
	}
		
	String strConcatChar(String pstrBody, String pstrInputString, int piStringSize )
	{
		StringBuffer strbString = new StringBuffer();
		int			 iMax = 0;
		
		iMax = pstrInputString.length();
		strbString.setLength(iMax);
				
		for(int i = 0; i < iMax; i++)
		{			
			strbString.setCharAt(i, pstrInputString.charAt(i));
		}
		pstrBody += strbString.toString();
				
		return pstrBody;
	}
	
	
	String strIntToStr( int piInputInteger, int piIntegerSize)
	{
		String	strReturn = new String();
		char 	charArray[] = new char[piIntegerSize];
		vToChar(piInputInteger, charArray, piIntegerSize);

		StringBuffer strbToken = new StringBuffer(piIntegerSize);
		strbToken.append( charArray, 0, piIntegerSize );
		return strbToken.toString();
	}
	
	String strNullTrim( String pstrOriginal )
	{	
		int	iStop;
		int	iMax;
		
		iMax = pstrOriginal.length();
		iStop = iMax;
				
		for( int i = 0; i < iMax; i++)
		{			
			if ( pstrOriginal.charAt(i) == 0x00 )
			{
				iStop = i;
				break;			
			}
		}
				
		return pstrOriginal.substring( 0, iStop );
	}		
}


