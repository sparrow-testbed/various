package sepoa.fw.util;

import java.io.IOException;
import java.util.Map;
import java.util.HashMap;
import java.util.Enumeration;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;



import org.apache.commons.fileupload.*;

public class RequestWrapper extends HttpServletRequestWrapper {
    
    private boolean multipart = false;
    
    private HashMap parameterMap;
    private HashMap fileItemMap;
    
    public RequestWrapper(HttpServletRequest request) 
    throws FileUploadException,IOException{
        this(request, -1, -1, null);
    }
    
    public RequestWrapper(HttpServletRequest request,
        int threshold, int max, String repositoryPath) throws FileUploadException,IOException {
    	
        super(request);
        readRequest(request);
    	
        parsing(request, threshold, max, repositoryPath);
    }
    
    protected void readRequest(HttpServletRequest req)
            throws IOException
    {
        int i = req.getContentLength();
        int maxSize = 1024*1024*15;
        if(i > maxSize)
            throw new IOException("파일용량이 초과되었습니다. (파일용량 : " + i + ", 최대용량 :  " + maxSize + ")");
        
//        String s = null;
//        String s1 = req.getHeader("Content-Type");
//        String s2 = req.getContentType();
//        if(s1 == null && s2 != null)
//            s = s2;
//        else
//        if(s2 == null && s1 != null)
//            s = s1;
//        else
//        if(s1 != null && s2 != null)
//            s = s1.length() <= s2.length() ? s2 : s1;
//        if(s == null || !s.toLowerCase().startsWith("multipart/form-data"))
//            throw new IOException("Posted content type isn't multipart/form-data");
//        String s3 = extractBoundary(s);
//        if(s3 == null)
//            throw new IOException("Separation boundary was not specified");
//        MultipartInputStreamHandler multipartinputstreamhandler = new MultipartInputStreamHandler(req.getInputStream(), i);
//        String s4 = multipartinputstreamhandler.readLine();
//        if(s4 == null)
//            throw new IOException("Corrupt form data: premature ending");
//        if(!s4.startsWith(s3))
//            throw new IOException("Corrupt form data: no leading boundary");
//        for(boolean flag = false; !flag; flag = readNextPart(multipartinputstreamhandler, s3));
    }
    
    private void parsing(HttpServletRequest request,
        int threshold, int max, String repositoryPath) throws FileUploadException,IOException {
    	
        if (FileUpload.isMultipartContent(request)) {
            multipart = true;
            
            parameterMap = new java.util.HashMap();
            fileItemMap = new java.util.HashMap();
            
            DiskFileUpload diskFileUpload = new DiskFileUpload();
            if (threshold != -1) {
                diskFileUpload.setSizeThreshold(threshold);
            }
            diskFileUpload.setSizeMax(max);
            if (repositoryPath != null) {
                diskFileUpload.setRepositoryPath(repositoryPath);
            }
            
            java.util.List list = diskFileUpload.parseRequest(request);
            
            for (int i = 0 ; i < list.size() ; i++) {
                FileItem fileItem = (FileItem) list.get(i);
                String name = fileItem.getFieldName();
                
                if (fileItem.isFormField()) {
                    String value = fileItem.getString();
                    String[] values = (String[]) parameterMap.get(name);
                    if (values == null) {
                        values = new String[] { value };
                    } else {
                        String[] tempValues = new String[values.length + 1];
                        System.arraycopy(values,0,tempValues,0,values.length);
                        tempValues[tempValues.length - 1] = value;
                        values = tempValues;
                    }
                    parameterMap.put(name, values);
                } else {
                    fileItemMap.put(name, fileItem);
                }
            }
            addTo(); // request 속성으로 설정한다.
        }
    }
    
    public boolean isMultipartContent() {
        return multipart;
    }
    
    public String getParameter(String name) {
        if (multipart) {
            String[] values = (String[])parameterMap.get(name);
            if (values == null) return null;
            return values[0];
        } else
            return super.getParameter(name);
    }
    
    public String[] getParameterValues(String name) {
        if (multipart)
            return (String[])parameterMap.get(name);
        else
            return super.getParameterValues(name);
    }
    
    public Enumeration getParameterNames() {
        if (multipart) {
            return new Enumeration() {
                Iterator iter = parameterMap.keySet().iterator();
                
                public boolean hasMoreElements() {
                    return iter.hasNext();
                }
                public Object nextElement() {
                    return iter.next();
                }
            };
        } else {
            return super.getParameterNames();
        }
    }
    
    public Map getParameterMap() {
        if (multipart)
            return parameterMap;
        else
            return super.getParameterMap();
    }
    
    public FileItem getFileItem(String name) {
        if (multipart)
            return (FileItem) fileItemMap.get(name);
        else
            return null;
    }
    
    /**
     * 관련된 FileItem 들의 delete() 메소드를 호출한다.
     */
    public void delete() {
        if (multipart) {
            Iterator fileItemIter = fileItemMap.values().iterator();
            while( fileItemIter.hasNext()) {
                FileItem fileItem = (FileItem)fileItemIter.next();
                fileItem.delete();
            }
        }
    }
    
    public void addTo() {
        super.setAttribute(RequestWrapper.class.getName(), this);
    }
    
    public static RequestWrapper 
                  getFrom(HttpServletRequest request) {
        return (RequestWrapper)
            request.getAttribute(RequestWrapper.class.getName());
    }
    
    public static boolean hasWrapper(HttpServletRequest request) {
        if (RequestWrapper.getFrom(request) == null) {
            return false;
        } else {
            return true;
        }
    }
}
