package sepoa.svc.approval.madec;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Hashtable;

import org.apache.commons.io.IOUtils;

public class Madn implements IFMaProp
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
		
	final static int DnDds_EncryptReq_Sig = 0x700;
	final static int DnDds_EncryptRep_Sig = 0x2700;

	private String		gstrErrCode = new String();
	private long		glInputStreamLength = 0;
	private long		glEncryptFileLength = 0;
	private InputStream	gInputStream;
	private int			giNewReadInputStream = 0;
	private	int			giZipFlag = 0;
	private int			giDrmFlag = 0;		// 1 : Org , 0 : Enc
	private	String		gstrEncryptFileName = new String();
	private	int			gPacketSizeCHK = 0;
	
	private	Hashtable 	gPropHashTable = new Hashtable();

	// contructor
	public Madn()
	{
		strFileExtention = new String();

		strIp = new String();
		strPacketData = new String();
		strReceivedPacketData = new String();
		czSocket = new ClientProgram();
		
		objFileCtrl = new FileNameCtrl();
		objStringCtrl = new StringCtrl();
		
		iGetProperty( "/etc/" + PropertyManager.PROP_FILE_NAME );
	}

	public Madn( String	pstrPropFile )
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
	
	public long lGetEncryptFileSize(
            int piAclFlag,
            String pstrDocLevel,
            String pstrUserId,
            String pstrFileName,
            long plFileSize,
            String pstrOwnerId,
            String pstrCompanyId,
            String pstrGroupId,
            String pstrPositionId,
            String pstrGrade,
            String pstrFileId,
            int piCanSave,        
            int piCanEdit,        
            int piBlockCopy,      
            int piOpenCount,      
            int piPrintCount,     
            int piValidPeriod,    
            int piSaveLog,        
            int piPrintLog,       
            int piOpenLog,         
            int piVisualPrint, 
            int piImageSafer,
            int piRealTimeAcl,
            String pstrDocumentTitle,
            String pstrCompanyName,
            String pstrGroupName,
            String pstrPositionName,
            String pstrUserName,
            String pstrUserIp,
            String pstrServerOrigin,
            int piExchangePolicy,
            int piDrmFlag,
            int     piBlockSize,
            String  pstrMachineKey,
            InputStream     pInputStream 
            )
	{
		String			strOrgFileLength = new String();
		String			strOrgFileName = new String();
		String			strReturn = new String();
		
		long			lOutPutFileSize = 0;
		int				i = 0;
		int				iZipFlag = 0;
		
		if( plFileSize < 0 )
		{
			gstrErrCode = E_INPUTSTREAM_LENGTH_ERROR;
			return 	0;
		}

		// private �� �ʱ�ȭ
		gstrErrCode = new String();
		glInputStreamLength = 0;
		glEncryptFileLength = 0;
		giNewReadInputStream = 0;
		giZipFlag = 0;
		giDrmFlag = 0;		// 1 : Org , 0 : Enc
		gstrEncryptFileName = new String();
	
		giDrmFlag = piDrmFlag;
		
		glInputStreamLength = plFileSize;
		strOrgFileLength = String.valueOf (plFileSize); 

		gInputStream = pInputStream;

		String	strFileExtention = new String();
		String	strUpperFileExtention = new String();
		
		if(pstrFileName.equals("###error###wrong###name###") == false)
		{
			// extracting file extention from the file name
			strFileExtention = new String(objFileCtrl.getStrFileExtention(pstrFileName));

			if(strFileExtention.equals("###error###wrong###name###") == false)
				strUpperFileExtention= new String(objStringCtrl.toUpperCase(strFileExtention));
		
		}
		else
		{
			gstrErrCode = E_ARGUMENT_ERROR;
			return 0;
		}		
				
		// selection transfer port by comparing file extention[zip or others]
		if(strUpperFileExtention.equals("ZIP") == true)
		{
			if ( giDrmFlag == 0 ) // Zip & Drm
				strOrgFileName = strInputToFile( plFileSize );

			giZipFlag = 1; // Zip : 1, Zip is not : 0
		}

		strReturn = strMadnInternal(
					piAclFlag,       
					pstrDocLevel,       
					pstrUserId, 	// User Id        
					(String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DDS_IP ), 		// MA_DDS IP
					Integer.valueOf((String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DDS_PORT )).intValue(),	// MA_DDS PORT        
					(String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DDSZIP_IP ), 		// MA_DDSZIP IP      
					Integer.valueOf((String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_DDSZIP_PORT )).intValue(),// MA_DDSZIP PORT     
					strOrgFileName,	// File Name
					strOrgFileLength,
					pstrFileName,
					pstrOwnerId,   
                    pstrCompanyId,  // Company Id     
                    pstrGroupId,    // Group Id     
                    pstrPositionId, // Position Id    
                    pstrGrade,      // Grade         
                    pstrFileId,     // File Id        
					piCanSave,
					piCanEdit,
					piBlockCopy,
					piOpenCount,
					piPrintCount,
					piValidPeriod,
					piSaveLog,
					piPrintLog,
					piOpenLog,
					piVisualPrint,
					piImageSafer,
					piRealTimeAcl,  
					(String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_SERVER_ADDR ),	// ServerAddr    
					Integer.valueOf((String)gPropHashTable.get( PropertyManager.MA_PROP_TAG_CREATED_BY )).intValue(), // CreateBy      
					pstrDocumentTitle,// Document Title
                    pstrCompanyName,
                    pstrGroupName,
                    pstrPositionName,
                    pstrUserName,
                    pstrUserIp,
                    pstrServerOrigin,
                    /*(String)gPropHashTable.get( MaPropertyManager.MA_PROP_TAG_SERVER_ORIGIN ),*/
                    piExchangePolicy,
                    piDrmFlag,
                    piBlockSize,
                    pstrMachineKey
                    );


		
		String strRetCode = new String( strReturn.substring( iRetCodeStartIdx, iRetCodeEndIdx ) );
		String strTmpFileLength = new String();
		String strEncFileLength = new String();
		
		if( strRetCode.equals(IORGFILE) )
		{
			strRetCode = ISUCCESS;
			giDrmFlag = 1;
			giNewReadInputStream = 1;
		}
			
		if( strRetCode.equals(ISUCCESS) )
		{
			// Not Zip file
			if( giZipFlag == 0 )
			{
				if( giDrmFlag == 1 ) // Original
				{
					glEncryptFileLength = glInputStreamLength;
					lOutPutFileSize = glInputStreamLength;
					server_disconnection();		
				}
				else
				{
					strTmpFileLength = new String( strReturn.substring( iRetCodeEndIdx, iRetEndIdx ) );
					strEncFileLength = objStringCtrl.strNullTrim( strTmpFileLength );
					
					lOutPutFileSize = Long.parseLong(strEncFileLength);					
					glEncryptFileLength = lOutPutFileSize;
				}
			}
			// Zip file
			else
			{
				if( giDrmFlag == 1 )
				{
					glEncryptFileLength = glInputStreamLength;	
					lOutPutFileSize = glInputStreamLength;

					if ( giNewReadInputStream == 1 )
					{
						File fileOrgFile = new File( strOrgFileName );
		  			    try
		  			    {
							gInputStream = new FileInputStream( fileOrgFile );			
						}
						catch( Exception e )
						{
							giNewReadInputStream = 1;
						}
						
						gstrEncryptFileName = strOrgFileName;
					}
				}
				else
				{
					// Original tmp file delete
					File	fileOrgFile = new File( strOrgFileName );
					fileOrgFile.delete();
					
					// Encrypt zip file processing ...!!!
					String strFullEncryptFilePath = new String( strReturn.substring( iRetCodeEndIdx, iRetEndIdx ) );
					String strHanFullEncryptFilePath = new String();
						
					try
					{
						strHanFullEncryptFilePath = new String( strFullEncryptFilePath.getBytes("8859_1"), "UTF-8" );
					}
					catch ( UnsupportedEncodingException e )
					{
						giDrmFlag = 0;
					}
	
					gstrEncryptFileName = objStringCtrl.strNullTrim( strHanFullEncryptFilePath );							
					
	
					File 	fileEncFile = new File( gstrEncryptFileName );				
					lOutPutFileSize = fileEncFile.length();
				}
								
				server_disconnection();		
			}
		}
		else
		{
			gstrErrCode = strRetCode;
			lOutPutFileSize = -1;

			// server disconnection
			server_disconnection();
		}
									
		return lOutPutFileSize;
	}

	// public method : export API
	public String  strMadn 
	(
		OutputStream	pOutputStream 
	)
	{	
		boolean	bTrueFalse;
		BufferedInputStream	ins = null;
		if( giZipFlag == 0 )
		{
			if ( giDrmFlag == 1 )
			{
				iInputToOutput( pOutputStream );		
			}
			else	
			{
				bTrueFalse = czSocket.bSendRecvData( gInputStream, pOutputStream, glInputStreamLength, glEncryptFileLength );	
			
				// server disconnection
				if( server_disconnection() == false )	return E_SOCKET;
				
				if( bTrueFalse == false )				return IFAILED;
			}
			
		}
		else
		{
			if ( giDrmFlag == 1 )
			{	
				iInputToOutput( pOutputStream );
				
				// Original tmp file delete
				File	fileOrgFile = new File( gstrEncryptFileName );
				fileOrgFile.delete();	
			}
			else
			{
		        byte 	byteReadData[] = new byte[MAX_READ_SIZE]; 
				
				try
				{		
					File fileInFile = new File( gstrEncryptFileName );
					ins = new BufferedInputStream( new FileInputStream( fileInFile ) );
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
				} finally { if(ins != null){ IOUtils.closeQuietly(ins); } }
				
				// Encrypted zip file delete
				File	fileEncFile = new File( gstrEncryptFileName );
				fileEncFile.delete();
			}
		}	
		
		return ISUCCESS;
	}
	
	// public method : export API
    String strMadnInternal(
            int     piAclFlag, 
            String      pstrDocLevel,       
            String  pstrUserId,        
            String  pstrDdsIp,         
            int     piDdsPort,        
            String  pstrDdsZipIp,      
            int     piDdsZipPort, 
            String  pstrOrgFileName,
            String  pstrOrgFileLength,
            String  pstrAssignedOrgFileName,
            String  pstrOwnerId,
            String  pstrCompanyId,     
            String  pstrGroupId,       
            String  pstrPositionId,    
            String  pstrGrade,         
            String  pstrFileId,        
            int     piCanSave,        
            int     piCanEdit,        
            int     piBlockCopy,      
            int     piOpenCount,      
            int     piPrintCount,     
            int     piValidPeriod,    
            int     piSaveLog,        
            int     piPrintLog,       
            int     piOpenLog,        
            int     piVisualPrint,    
            int     piImageSafer,     
            int     piRealTimeAcl,    
            String  pstrServerAddr,    
            int     piCreatedBy,      
            String  pstrDocumentTitle,
            String  pstrCompanyName,
            String  pstrGroupName,
            String  pstrPositionName,
            String  pstrUserName,
            String  pstrUserIp,
            String  pstrServerOrigin,
            int     piExchangePolicy,
            int     piDrmFlag,
            int     piBlockSize,
            String  pstrMachineKey
            )
	{
		// Parameter check
		if( objStringCtrl.iCheckParameter( piAclFlag, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;   
		//if( objStringCtrl.iCheckParameter( piDocLevel, 0, 10000 ) < 0 )	return E_ARGUMENT_ERROR;    
		if( objStringCtrl.iCheckParameter( piCanSave, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piCanEdit, 0, 1 ) < 0 )  		return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piBlockCopy, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piSaveLog, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piPrintLog, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piOpenLog, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piVisualPrint, 0, 1 ) < 0 )	return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piImageSafer, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piRealTimeAcl, 0, 1 ) < 0 )    return E_ARGUMENT_ERROR;
		if( objStringCtrl.iCheckParameter( piCreatedBy, 0, 2 ) < 0 )		return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( piExchangePolicy, 0, 13 ) < 0 )        return E_ARGUMENT_ERROR;    
		if( objStringCtrl.iCheckParameter( piDrmFlag, 0, 1 ) < 0 )		return E_ARGUMENT_ERROR;	

        if( objStringCtrl.iCheckParameter( pstrDocLevel.length(), 0, MAX_DOC_LEVEL ) < 0 )                        return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrUserId.length(), 0, MAX_ID ) < 0 )                         return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrOwnerId.length(), 0, MAX_ID ) < 0 )                        return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrDdsIp.length(), 0, MAX_IP ) < 0 )                              return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrDdsZipIp.length(), 0, MAX_IP ) < 0 )                       return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrOrgFileName.length(), -1, MAX_PATH ) < 0 )                     return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrOrgFileLength.length(), -1, MAX_FILE_LENGTH ) < 0 )            return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrAssignedOrgFileName.length(), -1, MAX_PATH ) < 0 )             return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrCompanyId.length(), -1, MAX_COMPANY_ID ) < 0 )             return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrGroupId.length(), -1, MAX_GROUP_ID ) < 0 )                 return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrPositionId.length(), -1, MAX_POSITION_ID ) < 0 )           return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrGrade.length(), -1, MAX_GRADE ) < 0 )                          return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrFileId.length(), -1, MAX_FILE_ID ) < 0 )                   return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrServerAddr.length(), -1, MAX_DN ) < 0 )                    return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrServerOrigin.length(), -1, MAX_SERVER_ORIGIN ) < 0 )      return E_ARGUMENT_ERROR;    
        if( objStringCtrl.iCheckParameter( pstrDocumentTitle.length(), -1, MAX_DOCUMENT_TITLE ) < 0 )      return E_ARGUMENT_ERROR;    

		if( objStringCtrl.iCheckParameter( pstrCompanyName, 	-1, MAX_COMPANY_NAME ) < 0 )  		return E_ARGUMENT_ERROR;	
		if( objStringCtrl.iCheckParameter( pstrGroupName, 	-1, MAX_GROUP_NAME ) < 0 )  		return E_ARGUMENT_ERROR;	
		if( objStringCtrl.iCheckParameter( pstrPositionName, -1, MAX_POSITION_NAME ) < 0 )  		return E_ARGUMENT_ERROR;	
		if( objStringCtrl.iCheckParameter( pstrUserName, 	-1, MAX_USER_NAME ) < 0 )  				return E_ARGUMENT_ERROR;	

		if( objStringCtrl.iCheckParameter( pstrUserIp, -1, 	MAX_IP ) < 0 )						return E_ARGUMENT_ERROR;
        if( objStringCtrl.iCheckParameter( pstrMachineKey.length(), -1, MA_MAX_KEY_SIZE ) < 0 )               return E_ARGUMENT_ERROR;
//		if( objStringCtrl.iCheckParameter( pstrOrgRequestName, -1, MAX_USER_NAME ) < 0 )			return E_ARGUMENT_ERROR;
//		if( objStringCtrl.iCheckParameter( pstrOrgRequestDept, -1, MAX_GROUP_NAME ) < 0 )			return E_ARGUMENT_ERROR;
//		if( objStringCtrl.iCheckParameter( pstrOrgReason, -1, MAX_REASON ) < 0 )					return E_ARGUMENT_ERROR;
									
		// selection transfer port by comparing file extention[zip or others]
		if( giZipFlag == 1 )
		{
			iPort = piDdsZipPort;
			strIp = new String(pstrDdsZipIp);
		}
		else
		{
			iPort = piDdsPort;
			strIp = new String(pstrDdsIp);
		}
			
		/////////////// check hangul ///////////////////
		// packet data constructing
		char nullData[] = {' '};
		gPacketSizeCHK = 0;
		StringBuffer strPacketDataBuffer = new StringBuffer( PacketDefine.DATA_MAX_SIZE );
						
		// packet data constructing
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piAclFlag, MAX_FLAG ) );
        strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrDocLevel,         MAX_DOC_LEVEL ) );
//		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piDocLevel, MAX_DOC_LEVEL ) );
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrOrgFileName, MAX_PATH ) );
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrOrgFileLength, MAX_FILE_LENGTH ) );
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrAssignedOrgFileName, MAX_FILE_NAME ) );		
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrAssignedOrgFileName, MAX_FILE_NAME ) );
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrUserId, MAX_ID ));
        strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrOwnerId, MAX_ID ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrCompanyId, MAX_COMPANY_ID ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrGroupId, MAX_GROUP_ID ));
		
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrPositionId, MAX_POSITION_ID ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrGrade, MAX_GRADE ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrFileId, MAX_FILE_ID ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piCanSave, 	MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piCanEdit, 	MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piBlockCopy, 	MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piOpenCount, 	MAX_OPEN_COUNT ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piPrintCount, 	MAX_PRINT_COUNT ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piValidPeriod, MAX_VALID_PERIOD ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piSaveLog, 	MAX_FLAG ));
		
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piPrintLog, 	MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piOpenLog, 	MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piVisualPrint, MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piImageSafer, 	MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piRealTimeAcl, MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrServerAddr, MAX_DN ));
		strPacketDataBuffer.append( objStringCtrl.strIntToStr( piCreatedBy, 	MAX_FLAG ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrDocumentTitle, MAX_DOCUMENT_TITLE ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrCompanyName, MAX_COMPANY_NAME ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrGroupName, MAX_GROUP_NAME ));
		
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrPositionName, MAX_POSITION_NAME ));
		strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrUserName, MAX_USER_NAME ));
        strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrUserIp,       MAX_IP ));        
        strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrServerOrigin, MAX_SERVER_ORIGIN ));
        strPacketDataBuffer.append( objStringCtrl.strIntToStr( piExchangePolicy,  MAX_EXCHANGEPOLICY ));      
        strPacketDataBuffer.append( objStringCtrl.strIntToStr( piDrmFlag,         MAX_FLAG ));
        strPacketDataBuffer.append( objStringCtrl.strIntToStr( piBlockSize, MAX_BLOCK_SIZE ));        
        strPacketDataBuffer.append( objStringCtrl.strRightTrim( pstrMachineKey, MA_MAX_KEY_SIZE ));       
		
//		if (gPacketSizeCHK > strPacketDataBuffer.length())
//		{
//			int tmp_cnt = gPacketSizeCHK - strPacketDataBuffer.length();
//			for (int i=0; i < tmp_cnt+3; i++)
//			{
//				//System.out.println("["+i+"][gPacketSizeCHK] = " + strPacketDataBuffer.length() + ", ["+(gPacketSizeCHK - strPacketDataBuffer.length())+"]\n ");
//				strPacketDataBuffer.append( nullData );
//			}
//		}
		
		strPacketData = strPacketDataBuffer.toString();						
//		System.out.println("[gPacketSizeCHK] = " + gPacketSizeCHK + "\n ");
//		System.out.println("[strPacketData] = " + strPacketData.length() + "\n ");
		
		// server connection
		if(server_connection(strIp, iPort) == false)
			return E_CONNECT_SOCKET;

		// packet setting at the socket and sending
		if(czSocket.bSendPacketHeader(DnDds_EncryptReq_Sig, strPacketData) == false)
		{
			server_disconnection();	
			return E_WRITE_SOCKET;
		}

		// packet receiving
		int checkStatus [] = new int[1];
		strReceivedPacketData = new String(czSocket.bRecvPacketHeader(checkStatus), 0, iRetEndIdx);

		// check SigID
		if( checkStatus[0] != DnDds_EncryptRep_Sig )
		{
			server_disconnection();
			return E_PACKET;
		}

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
}
