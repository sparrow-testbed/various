package sepoa.fw.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
//import sepoa.svc.approval.madec.Madec;
import MarkAny.MaSaferJava.Madec;

public class SepoaDrmUtils {
	

	public static boolean getFileDec(String filePath, String fileName)
			throws Exception {

		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		Madec clMadec = null;
		long FileLength = 0;
		long OutFileLength = 0;
		File FileSample = new File(filePath);
		File FileOut = new File(filePath + "_DEC");
		String tempFileName = fileName+"_MAD"; java.io.FileInputStream fileinputstream = null; java.io.FileOutputStream fileoutputstream = null;
		try { fileinputstream = new FileInputStream(FileSample);  fileoutputstream = new FileOutputStream(FileOut);
			in = new BufferedInputStream(fileinputstream);
			out = new BufferedOutputStream(fileoutputstream);
			Configuration conf = new Configuration();
			
			clMadec = new Madec(conf.getString("sepoa.mad.dat.src"));
			Logger.debug.println("clMadec = " + conf.getString("sepoa.mad.dat.src"));
			
			FileLength = FileSample.length();

			long beforetime = System.currentTimeMillis();

			// only file
			OutFileLength = clMadec.lGetDecryptFileSize(tempFileName, FileLength,
					in);

//			System.out.println("OutFileLength = " + OutFileLength);

			if (OutFileLength > 0) {
//				System.out.println("Decryption !!!! Start !!!! \n ");
				String strRetCode = clMadec.strMadec(out);
//				System.out.println(strRetCode);
				Logger.debug.println("strRetCode = " + strRetCode);
			} else {
				String strErrorCode = clMadec.strGetErrorCode();
//				System.out.println("[ErrorCode] " + strErrorCode
//						+ " [ErrorDescription] "
//						+ clMadec.strGetErrorMessage(strErrorCode));
				Logger.debug.println("[ErrorCode] " + strErrorCode
						+ " [ErrorDescription] "
						+ clMadec.strGetErrorMessage(strErrorCode));
			}
		} catch (Exception e) {
    		Logger.debug.println(e);
//			e.printStackTrace();
			return false;
		} finally{ if(fileinputstream != null){ IOUtils.closeQuietly(fileinputstream); } if(fileoutputstream != null){ IOUtils.closeQuietly(fileoutputstream); } }
		return true;
	}
	
	
	static public InputStream getFileItemDecInputStream(FileItem fileItem)
			throws Exception {
				
		InputStream is = null;   
		InputStream in = null;	OutputStream os = null;	
		try {
			Config conf = new Configuration();
			in = fileItem.getInputStream();
			
			String createDate = SepoaDate.getShortDateString();
			
			String fileName2 = System.nanoTime() + ".C" + createDate;
			String filePath2 = conf.getString("sepoa.attach.path.TEMP")
					+ "/" + fileName2;
			
			File outFile = new File(filePath2);
			os = new FileOutputStream(outFile);
			IOUtils.copy(in, os);
			os.flush();
			os.close();
			in.close();
			
			getFileDec(filePath2, fileName2);
			
			outFile = new File(filePath2 + "_DEC");
			is = FileUtils.openInputStream(outFile);
			
		} catch (Exception e) {
    		Logger.debug.println(e);
//			e.printStackTrace();
			throw new Exception( "Decryption is failed.", e);
		} finally{ if(in != null){ IOUtils.closeQuietly(in); } if(os != null){ IOUtils.closeQuietly(os); }}
		return is;
	}
}
