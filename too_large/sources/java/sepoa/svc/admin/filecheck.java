package sepoa.svc.admin;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.util.zip.CRC32;
import java.util.zip.Checksum;

public class FileCheck {

	/**
	 * ������ CRC���� ���
	 * 
	 * @param filePath
	 * @return
	 * @throws Exception
	 */
	public static String crc(File file) throws Exception {
		BufferedInputStream in = null;
		
		if (file == null || !file.exists()) {
			return "";
		}
		Checksum crc = new CRC32();
		try {
			in = new BufferedInputStream(
					new FileInputStream(file));
			byte buffer[] = new byte[32768];
			int length = 0;
			while ((length = in.read(buffer)) >= 0) {
				crc.update(buffer, 0, length);
			}
			in.close();
		} catch (IOException e) {
			throw new RuntimeException("Error occured. caused by : "
					+ e.getMessage(), e);
		}
		finally{
			if(in != null){
				try{
					in.close();
				}
				catch(Exception e){
					throw new RuntimeException("Error occured. caused by : "
						+ e.getMessage(), e);
				}
			}
		}
		return Long.toHexString(crc.getValue());
	}

	/**
	 * File sha256
	 * 
	 * @param file
	 * @return
	 */
	public static String sha256(File file) {
		StringBuffer hexString = new StringBuffer();
		FileInputStream fis = null;
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			fis = new FileInputStream(file);

			byte[] dataBytes = new byte[1024];

			int nread = 0;
			while ((nread = fis.read(dataBytes)) != -1) {
				md.update(dataBytes, 0, nread);
			}
			;
			byte[] mdbytes = md.digest();

			for (int i = 0; i < mdbytes.length; i++) {
				hexString.append(Integer.toHexString(0xFF & mdbytes[i]));
			}
		} catch (Exception e) {
			throw new RuntimeException("Error occured. caused by : "
					+ e.getMessage(), e);
		} finally {
			try {
				if(fis != null){ fis.close(); }
			} catch (Exception e) {
				throw new RuntimeException("Error occured. caused by : "
						+ e.getMessage(), e);
			}
		}
		return hexString.toString();
	}

	/**
	 * File MD5 checksum
	 * 
	 * @param file
	 * @return
	 */
	public static String md5(File file) {
		MessageDigest complete = null;
		InputStream fis = null;
		try {
			fis = new FileInputStream(file);

			byte[] buffer = new byte[1024];
			complete = MessageDigest.getInstance("MD5");
			int numRead;
			do {
				numRead = fis.read(buffer);
				if (numRead > 0) {
					complete.update(buffer, 0, numRead);
				}
			} while (numRead != -1);
		} catch (Exception e) {
			throw new RuntimeException("Error occured. caused by : "
					+ e.getMessage(), e);
		} finally {
			try {
				if(fis != null){ fis.close(); }
			} catch (Exception e) {
				throw new RuntimeException("Error occured. caused by : "
						+ e.getMessage(), e);
			}
		}
		return new String(complete.digest());
	}
}
