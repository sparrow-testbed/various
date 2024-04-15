package sepoa.svc.approval.madec;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Hashtable;

import org.apache.commons.io.IOUtils;

public class Madec implements IFMaProp
{

	// internal variable
	private String 	strFileExtention;
	private int 	iPort;
	private String 	strIp;
	private String 	strPacketData;
	private String 	strReceivedPacketData;

	// socket
	ClientProgram czSocket;
	PropertyManager 	objProperty;
	
	FileNameCtrl 	objFileCtrl;
	StringCtrl 	objStringCtrl;
		
	final static int WebDec_FileDecryptReq_Sig = 0xe01;
	final static int WebDec_FileDecryptRep_Sig = 0x2e01;

	private String		gstrErrCode = new String();
	private long		glInputStreamLength = 0;
	private long		glDecryptFileLength = 0;
	private byte[]		gbytePreEncHeader = new byte[PRE_ENC_HEADER_SIZE];
	private int			giEncHeaderLength = 0;
	private InputStream	gInputStream;
	private int			giDrmFlag = 0;
	private int			giSizeFlag = 0;
	private	int			giZipFlag = 0;
	private	String		gstrDecryptFileName = new String();

	private	Hashtable 	gPropHashTable = new Hashtable();	
	
	// contructor
	public Madec()
	{
		strIp = new String();
		strPacketData = new String();
		strReceivedPacketData = new String();
		czSocket = new ClientProgram();
		
		objFileCtrl = new FileNameCtrl();
		objStringCtrl = new StringCtrl();

		iGetProperty( "/etc/" + IFMaProp.PROP_FILE_NAME );		
	}

	public Madec( String pstrPropFile )
	{
		strFileExtention = new String();

		strIp = new String();
		strPacketData = new String();
		strReceivedPacketData = new String();
		czSocket = new ClientProgram();
		
		objFileCtrl = new FileNameCtrl();
		objStringCtrl = new StringCtrl();
		
		iGetProperty( pstrPropFile );
	}
	
	public String strGetErrorCode()
	{
		return	gstrErrCode;	
	}
	
	public String strGetErrorMessage( String pstrErrCode )
	{
		String	strErrorMessage = new String();
			
		if( pstrErrCode.equals(	IFAILED ) )
			strErrorMessage = new String("DocumentSAFER Server daemon is abnormal...!!!");
		else if( pstrErrCode.equals( E_ARGUMENT_ERROR ) )
			strErrorMessage = new String("Parameter is not valid...!!!");
		else if( pstrErrCode.equals( E_FILENAME_EXT_ERROR ) )	
			strErrorMessage = new String("File name is not valid...!!!");
		else if( pstrErrCode.equals( E_CONNECT_SOCKET ) )	
			strErrorMessage = new String("DocumentSAFER Server connect fail...!!!");
		else if( pstrErrCode.equals( E_WRITE_SOCKET ) )	
			strErrorMessage = new String("Communication fail with DocumentSAFER Server...!!!");
		else if( pstrErrCode.equals( E_READ_SOCKET ) )	
			strErrorMessage = new String("Communication fail with DocumentSAFER Server...!!!");
		else if( pstrErrCode.equals( E_SOCKET ) )	
			strErrorMessage = new String("Communication channel is not valid...!!!");
		else if( pstrErrCode.equals( E_PACKET ) )	
			strErrorMessage = new String("Communication data is not valid...!!!");
		else if( pstrErrCode.equals( E_NO_DATA_FOUND ) )
			strErrorMessage = new String("Database query is fail...!!!");
		else if( pstrErrCode.equals( E_INPUTSTREAM_ERROR ) )	
			strErrorMessage = new String("InputStream is not valid...!!!");
		else if( pstrErrCode.equals( E_INPUTSTREAM_LENGTH_ERROR ) )	
			strErrorMessage = new String("InputStream length is not valid...!!!");
		else
			strErrorMessage = new String("Unknown error code...!!!");

		return strErrorMessage;			
	}

	String strInputToFile( long plRcvDataLength ) 
	{
        byte 	byteReadData[] = new byte[MAX_READ_SIZE]; 
        String	strFileName = new String();
        BufferedOutputStream outs = null;		
		try 
		{	
			File fileTmpFile = File.createTempFile ("Mark", ".zip");
			BufferedInputStream	ins = new BufferedInputStream( gInputStream );
			outs = new BufferedOutputStream(new FileOutputStream(fileTmpFile));

             int 	iReadDataSize = 0; 
             
             while ((iReadDataSize = ins.read(byteReadData, 0, MAX_READ_SIZE)) != -1)
             { 
                   outs.write( byteReadData, 0, iReadDataSize ); 
             } 
             
             outs.close(); 
             ins.close(); 
             
             strFileName = fileTmpFile.getAbsolutePath ();
		}
		catch (Exception e) 
		{
			return "-1";
		} finally { if(outs != null){ IOUtils.closeQuietly(outs); } }
				
		return 	strFileName;
	}
	
	int iInputToOutput( OutputStream pOutputStream )
	{
        byte 	byteReadData[] = new byte[MAX_READ_SIZE]; 
		
		try
		{		
			BufferedInputStream	ins = new BufferedInputStream( gInputStream );
			BufferedOutputStream outs = new BufferedOutputStream( pOutputStream );
	
	        int 	iReadDataSize = 0; 
	             
	        //if( ( giZipFlag == 0 ) && ( giSizeFlag == 0 ) )
	        if( giSizeFlag == 0 )
	        	outs.write( gbytePreEncHeader, 0, PRE_ENC_HEADER_SIZE );
	        
			while ((iReadDataSize = ins.read(byteReadData, 0, MAX_READ_SIZE)) != -1)
			{
			   outs.write( byteReadData, 0, iReadDataSize ); 
			} 
             
			outs.close(); 
			ins.close();
		}
		catch( Exception e )
		{
			return -1;
		}		
		
		return 0;	
	}	
	
	public long lGetDecryptFileSize(
		String			pstrFileName,
		long			plFileSize,
		InputStream 	pInputStream )
	{
		String			strOrgFileName = new String();
		String			strOrgFileLength = new String();
		String			strReturn = new String();
		
		long			lOutPutFileSize = 0;
		int				i = 0;
		int				iZipFlag = 0;

		// private �� �ʱ�ȭ
		gstrErrCode = new String();
		glInputStreamLength = 0;
		glDecryptFileLength = 0;
		giEncHeaderLength = 0;		
		giZipFlag = 0;
		giDrmFlag = 0;
		giSizeFlag = 0;
		gstrDecryptFileName = new String();
		
		glInputStreamLength = plFileSize;
		
		strOrgFileLength = String.valueOf (plFileSize); 
		gInputStream = pInputStream;
		
		if( plFileSize <= 0 )
		{
			gstrErrCode = E_INPUTSTREAM_LENGTH_ERROR;
			return 	0;
		}

		else if( ( plFileSize <= PRE_ENC_HEADER_SIZE ) && ( plFileSize > 0 ))
		{
			glDecryptFileLength = glInputStreamLength;
			lOutPutFileSize = glInputStreamLength;
			giDrmFlag = 1;
			giSizeFlag = 1;
		}
		else
		{	
			String	strFileExtention = new String();
			String	strUpperFileExtention = new String();
			
			if(pstrFileName.equals("###error###wrong###name###") == false)
			{
				// extracting file extention from the file name
				strFileExtention = objFileCtrl.getStrFileExtention(pstrFileName);
				
				if(strFileExtention.equals("###error###wrong###name###") == false)
					strUpperFileExtention= new String(objStringCtrl.toUpperCase(strFileExtention));
			}
			else
			{
				gstrErrCode = E_FILENAME_EXT_ERROR;
				return 0;
			}		
					
			// selection transfer port by comparing file extention[zip or others]
			/*if(strUpperFileExtention.equals("ZIP") == true)
			{
				strOrgFileName = strInputToFile( plFileSize );
				giZipFlag = 1; // Zip : 1, Zip is not : 0
			}
			else*/
			{
				strOrgFileName = pstrFileName;
			}
	
			
			strReturn = strMadecInternal(
							(String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DEC_IP ), 		// MA_DDS IP
							Integer.valueOf((String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DEC_PORT )).intValue(),	// MA_DDS PORT        
							(String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DECZIP_IP ), 		// MA_DDSZIP IP      
							Integer.valueOf((String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DECZIP_PORT )).intValue(),// MA_DDSZIP PORT     
							strOrgFileName,	// File Name
							strOrgFileLength
						);

			String strRetCode = new String( strReturn.substring( iRetCodeStartIdx, iRetCodeEndIdx ) );
			String strTmpFileLength = new String();
			String strDecFileLength = new String();
			
			if( strRetCode.equals(IORGFILE) )	// header�� filesize�� 0���� ��; �� (�Ϲ�����)
			{
				glDecryptFileLength = glInputStreamLength;
				lOutPutFileSize = glInputStreamLength;
				giDrmFlag = 1;
				server_disconnection();	
				
				/*if( giZipFlag == 1 )
					gstrDecryptFileName = strOrgFileName;*/
			}
			else if( strRetCode.equals(ISUCCESS) )
			{
				//if( giZipFlag == 0 )
				{
					strTmpFileLength = new String( strReturn.substring( iRetCodeEndIdx, iRetEndIdx ) ); // 5 ~ 517
					strDecFileLength = strNullTrim( strTmpFileLength );
					
					lOutPutFileSize = Long.parseLong(strDecFileLength);					
					glDecryptFileLength = lOutPutFileSize;
					giEncHeaderLength = (int)(glInputStreamLength - lOutPutFileSize);
				}
				/*else
				{
					// Original temp zip file delete
					File	fileOrgFile = new File( strOrgFileName );
					fileOrgFile.delete();
					
					String strFullDecryptFilePath = new String( strReturn.substring( iRetCodeEndIdx, iRetEndIdx ) );
					String strHanFullDecryptFilePath = new String();
					
					try
					{
						strHanFullDecryptFilePath = new String( strFullDecryptFilePath.getBytes("8859_1"), "KSC5601" );
					}
					catch ( UnsupportedEncodingException e )
					{
					}
	
					gstrDecryptFileName = strNullTrim( strHanFullDecryptFilePath );							
					
					File 	fileEncFile = new File( gstrDecryptFileName );				
					lOutPutFileSize = fileEncFile.length();
									
					server_disconnection();		
				}*/
			}			
			else
			{
				gstrErrCode = strRetCode;
				lOutPutFileSize = -1;
	
				// server disconnection
				server_disconnection();
			}
		}
											
		return lOutPutFileSize;
	}

	// public method : export API
	public String  strMadec 
	(
		OutputStream	pOutputStream 
	)
	{	
		boolean	bTrueFalse;
		
		if ( giDrmFlag == 1 )
		{
			//if( giZipFlag == 0 )
			{
				iInputToOutput( pOutputStream );
			}
			/*else
			{
  			    File fileDecryptFile = new File( gstrDecryptFileName );
  			    try
  			    {
					gInputStream = new FileInputStream( fileDecryptFile );			
				}
				catch( Exception e )
				{
					return IFAILED;
				}
				
				iInputToOutput( pOutputStream );
				
				// Decrypt temp zip file delete
				File	fileDecFile = new File( gstrDecryptFileName );
				fileDecFile.delete();
			}*/
		}
		else	
		{
			//if( giZipFlag == 0 )
			{
				bTrueFalse = czSocket.bSendRecvData( gInputStream, pOutputStream, glInputStreamLength - PRE_ENC_HEADER_SIZE, glDecryptFileLength, giEncHeaderLength - PRE_ENC_HEADER_SIZE );	
			
				// server disconnection
				if( server_disconnection() == false )	return E_SOCKET;
				
				if( bTrueFalse == false )				return IFAILED;
			}
			/*else
			{
				byte 	byteReadData[] = new byte[MAX_READ_SIZE]; 
				
				try
				{		
					File fileInFile = new File( gstrDecryptFileName );
					BufferedInputStream	ins = new BufferedInputStream( new FileInputStream( fileInFile ) );
					BufferedOutputStream outs = new BufferedOutputStream( pOutputStream );
			
			        int 	iReadDataSize = 0; 
			             
					while ((iReadDataSize = ins.read(byteReadData, 0, MAX_READ_SIZE)) != -1)
					{ 
					   outs.write( byteReadData, 0, iReadDataSize ); 
					} 
		             
					outs.close(); 
					ins.close();
				}
				catch( Exception e )
				{
					return IFAILED;
				}
				
				// Decrypt temp zip file delete
				File	fileDecFile = new File( gstrDecryptFileName );
				fileDecFile.delete();	
			}*/
		}
		
		return ISUCCESS;
	}
	
	// public method : export API
	String strMadecInternal
	(
		String	pstrDecIp,         
		int		piDecPort,     
		String	pstrDecZipIp,      
		int		piDecZipPort,
		String 	pstrOrgFileName,
		String	pstrOrgFileLength
	)
	{				
		String strDbg = new String("[strMadecInternal]	:");
		
		// Parameter check
		if( objStringCtrl.iCheckParameter( pstrDecIp, 0, MAX_IP ) < 0 )  							return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( pstrDecZipIp, 0, MAX_IP ) < 0 )  						return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( pstrOrgFileName, -1, MAX_PATH ) < 0 ) 					return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( pstrOrgFileLength, -1, MAX_FILE_LENGTH ) < 0 )			return E_ARGUMENT_ERROR;
					
/*		System.out.println(strDbg + "strMadecInternal-----------------------");
		System.out.println(strDbg + "pstrDecIp = " + pstrDecIp);
		System.out.println(strDbg + "piDecPort = " + piDecPort);
		System.out.println(strDbg + "pstrDecZipIp = " + pstrDecZipIp);
		System.out.println(strDbg + "piDecZipPort = " + piDecZipPort);
		System.out.println(strDbg + "pstrOrgFileName = " + pstrOrgFileName);
		System.out.println(strDbg + "pstrOrgFileLength = " + pstrOrgFileLength);
*/					
								
		// selection transfer port by comparing file extention[zip or others]
		/*if( giZipFlag == 1 )
		{
			iPort = piDecZipPort;
			strIp = new String(pstrDecZipIp);
		}
		else*/
		{
			iPort = piDecPort;
			strIp = new String(pstrDecIp);
		}
				
		/////////////// check hangul ///////////////////
		// packet data constructing
		//if( giZipFlag == 0 )
		{
			gbytePreEncHeader = czSocket.byteReadOrgStream( gInputStream, PRE_ENC_HEADER_SIZE );
			byte[]	bytePacket = PacketDefine.makeDecPacket(WebDec_FileDecryptReq_Sig, objStringCtrl.strRightTrim( pstrOrgFileLength, MAX_FILE_LENGTH ), MAX_FILE_LENGTH, gbytePreEncHeader, PRE_ENC_HEADER_SIZE );		
			
			// server connection
			if(server_connection(strIp, iPort) == false)
			{
				return E_CONNECT_SOCKET;
			}
			
			// packet setting at the socket and sending
			if(czSocket.bSendDecPacketHeader(bytePacket) == false)
			{
				server_disconnection();	
				return E_WRITE_SOCKET;
			}
		}
		/*else
		{
			StringBuffer strPacketDataBuffer = new StringBuffer( PacketDefine.DATA_MAX_SIZE );
				
			// packet data constructing
			strPacketDataBuffer.append( strRightTrim( pstrOrgFileName, MAX_PATH ) );
			strPacketData = strPacketDataBuffer.toString();						
		
			// server connection
			if(server_connection(strIp, iPort) == false)
				return E_CONNECT_SOCKET;
	
			// packet setting at the socket and sending
			if(czSocket.bSendPacketHeader(WebDec_FileDecryptReq_Sig, strPacketData) == false)
			{
				server_disconnection();	
				return E_WRITE_SOCKET;
			}			
		}*/
		
		// packet receiving
		int checkStatus [] = new int[1];
		strReceivedPacketData = new String(czSocket.bRecvPacketHeader(checkStatus), 0, iRetEndIdx);

		// check SigID
		if( checkStatus[0] != WebDec_FileDecryptRep_Sig )
		{
			server_disconnection();
			return E_PACKET;
		}
		//System.out.println( strDbg + "strReceivedPacketData = " + strReceivedPacketData);
		return strReceivedPacketData;
	}

	int	iGetProperty(String pstrPropertyFilePath)
	{
		String	strKey = new String();
		String	strValue = new String();
		int		iMaxTag = 0;

		try
		{
			objProperty = new PropertyManager();
			objProperty.read(  pstrPropertyFilePath );

			strValue = new String( objProperty.get( PropertyManager.PROP_MAX_PARAM ));			
			iMaxTag = Integer.valueOf(strValue).intValue();
		}
		catch( IOException e )
		{
			return -1;
		}
								
		for( int i = 0; i < iMaxTag; i++ )
		{
			strKey = PropertyManager.PROP_PARAM_KEY + ( i + 1 );
			strValue = objProperty.get( strKey );

			if( !strValue.equals("null") )
			{
				gPropHashTable.put( String.valueOf(i + 1), strValue ); 
			}
			else
			{
				gPropHashTable.put( String.valueOf(i + 1), "" ); 
			}
		}
		
		return	0;
	}


	boolean server_connection(String pstrServerName, int piPort)
	{
		boolean bReturn;
		
		try
		{
			bReturn = czSocket.bConnection(pstrServerName, piPort);
		}
		catch(IOException e)
		{
			server_disconnection();
			return false;
		}
		
		return bReturn;
	}

	boolean server_disconnection()
	{
		if(czSocket.bDisConnection() == true) return true;
		else return false;
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
