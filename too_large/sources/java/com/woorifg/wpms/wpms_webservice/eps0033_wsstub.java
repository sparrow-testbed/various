
/**
 * EPS0033_WSStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */
        package com.woorifg.wpms.wpms_webservice;

        

        /*
        *  EPS0033_WSStub java implementation
        */

        
        public class EPS0033_WSStub extends org.apache.axis2.client.Stub
        {
        protected org.apache.axis2.description.AxisOperation[] _operations;

        //hashmaps to keep the fault mapping
        private java.util.HashMap faultExceptionNameMap = new java.util.HashMap();
        private java.util.HashMap faultExceptionClassNameMap = new java.util.HashMap();
        private java.util.HashMap faultMessageMap = new java.util.HashMap();

        private static int counter = 0;

        private static synchronized java.lang.String getUniqueSuffix(){
            // reset the counter if it is greater than 99999
            if (counter > 99999){
                counter = 0;
            }
            counter = counter + 1; 
            return java.lang.Long.toString(java.lang.System.currentTimeMillis()) + "_" + counter;
        }

    
    private void populateAxisService() throws org.apache.axis2.AxisFault {

     //creating the Service with a unique name
     _service = new org.apache.axis2.description.AxisService("EPS0033_WS" + getUniqueSuffix());
     addAnonymousOperations();

        //creating the operations
        org.apache.axis2.description.AxisOperation __operation;

        _operations = new org.apache.axis2.description.AxisOperation[1];
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService", "ePS0033"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[0]=__operation;
            
        
        }

    //populates the faults
    private void populateFaults(){
         


    }

    /**
      *Constructor that takes in a configContext
      */

    public EPS0033_WSStub(org.apache.axis2.context.ConfigurationContext configurationContext,
       java.lang.String targetEndpoint)
       throws org.apache.axis2.AxisFault {
         this(configurationContext,targetEndpoint,false);
   }


   /**
     * Constructor that takes in a configContext  and useseperate listner
     */
   public EPS0033_WSStub(org.apache.axis2.context.ConfigurationContext configurationContext,
        java.lang.String targetEndpoint, boolean useSeparateListener)
        throws org.apache.axis2.AxisFault {
         //To populate AxisService
         populateAxisService();
         populateFaults();

        _serviceClient = new org.apache.axis2.client.ServiceClient(configurationContext,_service);
        
	
        _serviceClient.getOptions().setTo(new org.apache.axis2.addressing.EndpointReference(
                targetEndpoint));
        _serviceClient.getOptions().setUseSeparateListener(useSeparateListener);
        
            //Set the soap version
            _serviceClient.getOptions().setSoapVersionURI(org.apache.axiom.soap.SOAP12Constants.SOAP_ENVELOPE_NAMESPACE_URI);
        
        long soTimeout = 5 * 60 * 1000; //TOBE 2017-07-01 
        _serviceClient.getOptions().setTimeOutInMilliSeconds(soTimeout);
    
    }

    /**
     * Default Constructor
     */
    public EPS0033_WSStub(org.apache.axis2.context.ConfigurationContext configurationContext) throws org.apache.axis2.AxisFault {
        
                    this(configurationContext,"http://wpms.woorifg.com/WPMS.WebService/EPS0033_WS.asmx" );
                
    }

    /**
     * Default Constructor
     */
    public EPS0033_WSStub() throws org.apache.axis2.AxisFault {
        
                    this("http://wpms.woorifg.com/WPMS.WebService/EPS0033_WS.asmx" );
                
    }

    /**
     * Constructor taking the target endpoint
     */
    public EPS0033_WSStub(java.lang.String targetEndpoint) throws org.apache.axis2.AxisFault {
        this(null,targetEndpoint);
    }



        
                    /**
                     * Auto generated method signature
                     * &lt;br&gt;&lt;b&gt;일계 로그 처리&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;파라미터명&lt;/td&gt;&lt;td width=120 align=center&gt;Comments&lt;/td&gt;&lt;td width=200 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=450 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;등록(C)시 필수&lt;/td&gt;&lt;td width=100 align=center&gt;취소(R)시 필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;작업구분&lt;/td&gt;&lt;td&gt;string / (고정형)1&lt;/td&gt;&lt;td&gt;C-전문등록, R-전문등록취소 (대문자)&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BNKCD&lt;/td&gt;&lt;td&gt;은행코드&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;20 우리은행&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TRNTRNDT&lt;/td&gt;&lt;td&gt;거래일자&lt;/td&gt;&lt;td&gt;string / (고정형)8&lt;/td&gt;&lt;td&gt;ex.) 20171011&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TRNTRNCD&lt;/td&gt;&lt;td&gt;거래코드&lt;/td&gt;&lt;td&gt;string / (고정형)4&lt;/td&gt;&lt;td&gt;SELECT a.CDECDECD, a.* FROM TPMCD03 a WHERE CDECDEGB = '806'&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IGJM[]&lt;/td&gt;&lt;td&gt;일계점코드&lt;/td&gt;&lt;td&gt;string[] / (고정형)6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BSIS[]&lt;/td&gt;&lt;td&gt;B/S구분코드&lt;/td&gt;&lt;td&gt;string[] / (고정형)1&lt;/td&gt;&lt;td&gt;1-B/S, 2-I/S&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;GWCD[]&lt;/td&gt;&lt;td&gt;계정코드&lt;/td&gt;&lt;td&gt;string[] / (고정형)11&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IJGB[]&lt;/td&gt;&lt;td&gt;입지구분&lt;/td&gt;&lt;td&gt;string[] / (고정형)2&lt;/td&gt;&lt;td&gt;11-입금, 12-입금취소, 21-지급, 22-지급취소&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TSAM[]&lt;/td&gt;&lt;td&gt;대체집행액&lt;/td&gt;&lt;td&gt;string[] / (가변형)18&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;구매자행번&lt;/td&gt;&lt;td&gt;string / (고정형)8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;인터페이스번호&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;전자구매에서 생성한 인터페이스번호&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[4]값   string[0] - 200 : 성공, 그외 에러번호 실퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - 개발자 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - 시스템 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - 재산관리에서 생성한 인터페이스번호&lt;/b&gt;&lt;br&gt;
                     * @see com.woorifg.wpms.wpms_webservice.EPS0033_WS#ePS0033
                     * @param ePS00330
                    
                     */

                    

                            public  com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response ePS0033(

                            com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033 ePS00330)
                        

                    throws java.rmi.RemoteException
                    
                    {
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[0].getName());
              _operationClient.getOptions().setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0033");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    ePS00330,
                                                    optimizeContent(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0033")), new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0033"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0033"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0033"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0033"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                /**
                * Auto generated method signature for Asynchronous Invocations
                * &lt;br&gt;&lt;b&gt;일계 로그 처리&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;파라미터명&lt;/td&gt;&lt;td width=120 align=center&gt;Comments&lt;/td&gt;&lt;td width=200 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=450 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;등록(C)시 필수&lt;/td&gt;&lt;td width=100 align=center&gt;취소(R)시 필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;작업구분&lt;/td&gt;&lt;td&gt;string / (고정형)1&lt;/td&gt;&lt;td&gt;C-전문등록, R-전문등록취소 (대문자)&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BNKCD&lt;/td&gt;&lt;td&gt;은행코드&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;20 우리은행&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TRNTRNDT&lt;/td&gt;&lt;td&gt;거래일자&lt;/td&gt;&lt;td&gt;string / (고정형)8&lt;/td&gt;&lt;td&gt;ex.) 20171011&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TRNTRNCD&lt;/td&gt;&lt;td&gt;거래코드&lt;/td&gt;&lt;td&gt;string / (고정형)4&lt;/td&gt;&lt;td&gt;SELECT a.CDECDECD, a.* FROM TPMCD03 a WHERE CDECDEGB = '806'&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IGJM[]&lt;/td&gt;&lt;td&gt;일계점코드&lt;/td&gt;&lt;td&gt;string[] / (고정형)6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BSIS[]&lt;/td&gt;&lt;td&gt;B/S구분코드&lt;/td&gt;&lt;td&gt;string[] / (고정형)1&lt;/td&gt;&lt;td&gt;1-B/S, 2-I/S&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;GWCD[]&lt;/td&gt;&lt;td&gt;계정코드&lt;/td&gt;&lt;td&gt;string[] / (고정형)11&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IJGB[]&lt;/td&gt;&lt;td&gt;입지구분&lt;/td&gt;&lt;td&gt;string[] / (고정형)2&lt;/td&gt;&lt;td&gt;11-입금, 12-입금취소, 21-지급, 22-지급취소&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TSAM[]&lt;/td&gt;&lt;td&gt;대체집행액&lt;/td&gt;&lt;td&gt;string[] / (가변형)18&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;구매자행번&lt;/td&gt;&lt;td&gt;string / (고정형)8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;인터페이스번호&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;전자구매에서 생성한 인터페이스번호&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[4]값   string[0] - 200 : 성공, 그외 에러번호 실퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - 개발자 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - 시스템 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - 재산관리에서 생성한 인터페이스번호&lt;/b&gt;&lt;br&gt;
                * @see com.woorifg.wpms.wpms_webservice.EPS0033_WS#startePS0033
                    * @param ePS00330
                
                */
                public  void startePS0033(

                 com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033 ePS00330,

                  final com.woorifg.wpms.wpms_webservice.EPS0033_WSCallbackHandler callback)

                throws java.rmi.RemoteException{

              org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[0].getName());
             _operationClient.getOptions().setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0033");
             _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              


              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env=null;
              final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

                    
                                    //Style is Doc.
                                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    ePS00330,
                                                    optimizeContent(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0033")), new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0033"));
                                                
        // adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);


                    
                        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                            public void onMessage(org.apache.axis2.context.MessageContext resultContext) {
                            try {
                                org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();
                                
                                        java.lang.Object object = fromOM(resultEnv.getBody().getFirstElement(),
                                                                         com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response.class,
                                                                         getEnvelopeNamespaces(resultEnv));
                                        callback.receiveResultePS0033(
                                        (com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response)object);
                                        
                            } catch (org.apache.axis2.AxisFault e) {
                                callback.receiveErrorePS0033(e);
                            }
                            }

                            public void onError(java.lang.Exception error) {
								if (error instanceof org.apache.axis2.AxisFault) {
									org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
									org.apache.axiom.om.OMElement faultElt = f.getDetail();
									if (faultElt!=null){
										if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0033"))){
											//make the fault by reflection
											try{
													java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0033"));
													java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
													java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
													//message class
													java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0033"));
														java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
													java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
													java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
															new java.lang.Class[]{messageClass});
													m.invoke(ex,new java.lang.Object[]{messageObject});
													
					
										            callback.receiveErrorePS0033(new java.rmi.RemoteException(ex.getMessage(), ex));
                                            } catch(java.lang.ClassCastException e){
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0033(f);
                                            } catch (java.lang.ClassNotFoundException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0033(f);
                                            } catch (java.lang.NoSuchMethodException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0033(f);
                                            } catch (java.lang.reflect.InvocationTargetException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0033(f);
                                            } catch (java.lang.IllegalAccessException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0033(f);
                                            } catch (java.lang.InstantiationException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0033(f);
                                            } catch (org.apache.axis2.AxisFault e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0033(f);
                                            }
									    } else {
										    callback.receiveErrorePS0033(f);
									    }
									} else {
									    callback.receiveErrorePS0033(f);
									}
								} else {
								    callback.receiveErrorePS0033(error);
								}
                            }

                            public void onFault(org.apache.axis2.context.MessageContext faultContext) {
                                org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                                onError(fault);
                            }

                            public void onComplete() {
                                try {
                                    _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                                } catch (org.apache.axis2.AxisFault axisFault) {
                                    callback.receiveErrorePS0033(axisFault);
                                }
                            }
                });
                        

          org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;
        if ( _operations[0].getMessageReceiver()==null &&  _operationClient.getOptions().isUseSeparateListener()) {
           _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
          _operations[0].setMessageReceiver(
                    _callbackReceiver);
        }

           //execute the operation client
           _operationClient.execute(false);

                    }
                


       /**
        *  A utility method that copies the namepaces from the SOAPEnvelope
        */
       private java.util.Map getEnvelopeNamespaces(org.apache.axiom.soap.SOAPEnvelope env){
        java.util.Map returnMap = new java.util.HashMap();
        java.util.Iterator namespaceIterator = env.getAllDeclaredNamespaces();
        while (namespaceIterator.hasNext()) {
            org.apache.axiom.om.OMNamespace ns = (org.apache.axiom.om.OMNamespace) namespaceIterator.next();
            returnMap.put(ns.getPrefix(),ns.getNamespaceURI());
        }
       return returnMap;
    }

    
    
    private javax.xml.namespace.QName[] opNameArray = null;
    private boolean optimizeContent(javax.xml.namespace.QName opName) {
        

        if (opNameArray == null) {
            return false;
        }
        for (int i = 0; i < opNameArray.length; i++) {
            if (opName.equals(opNameArray[i])) {
                return true;   
            }
        }
        return false;
    }
     //http://wpms.woorifg.com/WPMS.WebService/EPS0033_WS.asmx
        public static class EPS0033
        implements org.apache.axis2.databinding.ADBBean{
        
                public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService",
                "EPS0033",
                "ns1");

            

                        /**
                        * field for MODE
                        */

                        
                                    protected java.lang.String localMODE ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localMODETracker = false ;

                           public boolean isMODESpecified(){
                               return localMODETracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getMODE(){
                               return localMODE;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param MODE
                               */
                               public void setMODE(java.lang.String param){
                            localMODETracker = param != null;
                                   
                                            this.localMODE=param;
                                    

                               }
                            

                        /**
                        * field for BNKCD
                        */

                        
                                    protected java.lang.String localBNKCD ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localBNKCDTracker = false ;

                           public boolean isBNKCDSpecified(){
                               return localBNKCDTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getBNKCD(){
                               return localBNKCD;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param BNKCD
                               */
                               public void setBNKCD(java.lang.String param){
                            localBNKCDTracker = param != null;
                                   
                                            this.localBNKCD=param;
                                    

                               }
                            

                        /**
                        * field for TRNTRNDT
                        */

                        
                                    protected java.lang.String localTRNTRNDT ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localTRNTRNDTTracker = false ;

                           public boolean isTRNTRNDTSpecified(){
                               return localTRNTRNDTTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getTRNTRNDT(){
                               return localTRNTRNDT;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param TRNTRNDT
                               */
                               public void setTRNTRNDT(java.lang.String param){
                            localTRNTRNDTTracker = param != null;
                                   
                                            this.localTRNTRNDT=param;
                                    

                               }
                            

                        /**
                        * field for TRNTRNCD
                        */

                        
                                    protected java.lang.String localTRNTRNCD ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localTRNTRNCDTracker = false ;

                           public boolean isTRNTRNCDSpecified(){
                               return localTRNTRNCDTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getTRNTRNCD(){
                               return localTRNTRNCD;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param TRNTRNCD
                               */
                               public void setTRNTRNCD(java.lang.String param){
                            localTRNTRNCDTracker = param != null;
                                   
                                            this.localTRNTRNCD=param;
                                    

                               }
                            

                        /**
                        * field for IGJM
                        */

                        
                                    protected ArrayOfString localIGJM ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localIGJMTracker = false ;

                           public boolean isIGJMSpecified(){
                               return localIGJMTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return ArrayOfString
                           */
                           public  ArrayOfString getIGJM(){
                               return localIGJM;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param IGJM
                               */
                               public void setIGJM(ArrayOfString param){
                            localIGJMTracker = param != null;
                                   
                                            this.localIGJM=param;
                                    

                               }
                            

                        /**
                        * field for BSIS
                        */

                        
                                    protected ArrayOfString localBSIS ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localBSISTracker = false ;

                           public boolean isBSISSpecified(){
                               return localBSISTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return ArrayOfString
                           */
                           public  ArrayOfString getBSIS(){
                               return localBSIS;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param BSIS
                               */
                               public void setBSIS(ArrayOfString param){
                            localBSISTracker = param != null;
                                   
                                            this.localBSIS=param;
                                    

                               }
                            

                        /**
                        * field for GWCD
                        */

                        
                                    protected ArrayOfString localGWCD ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localGWCDTracker = false ;

                           public boolean isGWCDSpecified(){
                               return localGWCDTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return ArrayOfString
                           */
                           public  ArrayOfString getGWCD(){
                               return localGWCD;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param GWCD
                               */
                               public void setGWCD(ArrayOfString param){
                            localGWCDTracker = param != null;
                                   
                                            this.localGWCD=param;
                                    

                               }
                            

                        /**
                        * field for IJGB
                        */

                        
                                    protected ArrayOfString localIJGB ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localIJGBTracker = false ;

                           public boolean isIJGBSpecified(){
                               return localIJGBTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return ArrayOfString
                           */
                           public  ArrayOfString getIJGB(){
                               return localIJGB;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param IJGB
                               */
                               public void setIJGB(ArrayOfString param){
                            localIJGBTracker = param != null;
                                   
                                            this.localIJGB=param;
                                    

                               }
                            

                        /**
                        * field for TSAM
                        */

                        
                                    protected ArrayOfString localTSAM ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localTSAMTracker = false ;

                           public boolean isTSAMSpecified(){
                               return localTSAMTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return ArrayOfString
                           */
                           public  ArrayOfString getTSAM(){
                               return localTSAM;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param TSAM
                               */
                               public void setTSAM(ArrayOfString param){
                            localTSAMTracker = param != null;
                                   
                                            this.localTSAM=param;
                                    

                               }
                            

                        /**
                        * field for USRUSRID
                        */

                        
                                    protected java.lang.String localUSRUSRID ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localUSRUSRIDTracker = false ;

                           public boolean isUSRUSRIDSpecified(){
                               return localUSRUSRIDTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getUSRUSRID(){
                               return localUSRUSRID;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param USRUSRID
                               */
                               public void setUSRUSRID(java.lang.String param){
                            localUSRUSRIDTracker = param != null;
                                   
                                            this.localUSRUSRID=param;
                                    

                               }
                            

                        /**
                        * field for INF_REF_NO
                        */

                        
                                    protected java.lang.String localINF_REF_NO ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localINF_REF_NOTracker = false ;

                           public boolean isINF_REF_NOSpecified(){
                               return localINF_REF_NOTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getINF_REF_NO(){
                               return localINF_REF_NO;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param INF_REF_NO
                               */
                               public void setINF_REF_NO(java.lang.String param){
                            localINF_REF_NOTracker = param != null;
                                   
                                            this.localINF_REF_NO=param;
                                    

                               }
                            

     
     
        /**
        *
        * @param parentQName
        * @param factory
        * @return org.apache.axiom.om.OMElement
        */
       public org.apache.axiom.om.OMElement getOMElement (
               final javax.xml.namespace.QName parentQName,
               final org.apache.axiom.om.OMFactory factory) throws org.apache.axis2.databinding.ADBException{


        
               org.apache.axiom.om.OMDataSource dataSource =
                       new org.apache.axis2.databinding.ADBDataSource(this,MY_QNAME);
               return factory.createOMElement(dataSource,MY_QNAME);
            
        }

         public void serialize(final javax.xml.namespace.QName parentQName,
                                       javax.xml.stream.XMLStreamWriter xmlWriter)
                                throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
                           serialize(parentQName,xmlWriter,false);
         }

         public void serialize(final javax.xml.namespace.QName parentQName,
                               javax.xml.stream.XMLStreamWriter xmlWriter,
                               boolean serializeType)
            throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
            
                


                java.lang.String prefix = null;
                java.lang.String namespace = null;
                

                    prefix = parentQName.getPrefix();
                    namespace = parentQName.getNamespaceURI();
                    writeStartElement(prefix, namespace, parentQName.getLocalPart(), xmlWriter);
                
                  if (serializeType){
               

                   java.lang.String namespacePrefix = registerPrefix(xmlWriter,"http://wpms.woorifg.com/WPMS.WebService");
                   if ((namespacePrefix != null) && (namespacePrefix.trim().length() > 0)){
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           namespacePrefix+":EPS0033",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "EPS0033",
                           xmlWriter);
                   }

               
                   }
                if (localMODETracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "MODE", xmlWriter);
                             

                                          if (localMODE==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("MODE cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localMODE);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localBNKCDTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "BNKCD", xmlWriter);
                             

                                          if (localBNKCD==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("BNKCD cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localBNKCD);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localTRNTRNDTTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "TRNTRNDT", xmlWriter);
                             

                                          if (localTRNTRNDT==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("TRNTRNDT cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localTRNTRNDT);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localTRNTRNCDTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "TRNTRNCD", xmlWriter);
                             

                                          if (localTRNTRNCD==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("TRNTRNCD cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localTRNTRNCD);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localIGJMTracker){
                                            if (localIGJM==null){
                                                 throw new org.apache.axis2.databinding.ADBException("IGJM cannot be null!!");
                                            }
                                           localIGJM.serialize(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","IGJM"),
                                               xmlWriter);
                                        } if (localBSISTracker){
                                            if (localBSIS==null){
                                                 throw new org.apache.axis2.databinding.ADBException("BSIS cannot be null!!");
                                            }
                                           localBSIS.serialize(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","BSIS"),
                                               xmlWriter);
                                        } if (localGWCDTracker){
                                            if (localGWCD==null){
                                                 throw new org.apache.axis2.databinding.ADBException("GWCD cannot be null!!");
                                            }
                                           localGWCD.serialize(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","GWCD"),
                                               xmlWriter);
                                        } if (localIJGBTracker){
                                            if (localIJGB==null){
                                                 throw new org.apache.axis2.databinding.ADBException("IJGB cannot be null!!");
                                            }
                                           localIJGB.serialize(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","IJGB"),
                                               xmlWriter);
                                        } if (localTSAMTracker){
                                            if (localTSAM==null){
                                                 throw new org.apache.axis2.databinding.ADBException("TSAM cannot be null!!");
                                            }
                                           localTSAM.serialize(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","TSAM"),
                                               xmlWriter);
                                        } if (localUSRUSRIDTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "USRUSRID", xmlWriter);
                             

                                          if (localUSRUSRID==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("USRUSRID cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localUSRUSRID);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localINF_REF_NOTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "INF_REF_NO", xmlWriter);
                             

                                          if (localINF_REF_NO==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("INF_REF_NO cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localINF_REF_NO);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             }
                    xmlWriter.writeEndElement();
               

        }

        private static java.lang.String generatePrefix(java.lang.String namespace) {
            if(namespace.equals("http://wpms.woorifg.com/WPMS.WebService")){
                return "ns1";
            }
            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix, java.lang.String namespace, java.lang.String localPart,
                                       javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String writerPrefix = xmlWriter.getPrefix(namespace);
            if (writerPrefix != null) {
                xmlWriter.writeStartElement(namespace, localPart);
            } else {
                if (namespace.length() == 0) {
                    prefix = "";
                } else if (prefix == null) {
                    prefix = generatePrefix(namespace);
                }

                xmlWriter.writeStartElement(prefix, localPart, namespace);
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
        }
        
        /**
         * Util method to write an attribute with the ns prefix
         */
        private void writeAttribute(java.lang.String prefix,java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            xmlWriter.writeAttribute(namespace,attName,attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName,attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace,attName,attValue);
            }
        }


           /**
             * Util method to write an attribute without the ns prefix
             */
            private void writeQNameAttribute(java.lang.String namespace, java.lang.String attName,
                                             javax.xml.namespace.QName qname, javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

                java.lang.String attributeNamespace = qname.getNamespaceURI();
                java.lang.String attributePrefix = xmlWriter.getPrefix(attributeNamespace);
                if (attributePrefix == null) {
                    attributePrefix = registerPrefix(xmlWriter, attributeNamespace);
                }
                java.lang.String attributeValue;
                if (attributePrefix.trim().length() > 0) {
                    attributeValue = attributePrefix + ":" + qname.getLocalPart();
                } else {
                    attributeValue = qname.getLocalPart();
                }

                if (namespace.equals("")) {
                    xmlWriter.writeAttribute(attName, attributeValue);
                } else {
                    registerPrefix(xmlWriter, namespace);
                    xmlWriter.writeAttribute(namespace, attName, attributeValue);
                }
            }
        /**
         *  method to handle Qnames
         */

        private void writeQName(javax.xml.namespace.QName qname,
                                javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();
            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);
                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix,namespaceURI);
                }

                if (prefix.trim().length() > 0){
                    xmlWriter.writeCharacters(prefix + ":" + org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                }

            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
                                 javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

            if (qnames != null) {
                // we have to store this data until last moment since it is not possible to write any
                // namespace data after writing the charactor data
                java.lang.StringBuffer stringToWrite = new java.lang.StringBuffer();
                java.lang.String namespaceURI = null;
                java.lang.String prefix = null;

                for (int i = 0; i < qnames.length; i++) {
                    if (i > 0) {
                        stringToWrite.append(" ");
                    }
                    namespaceURI = qnames[i].getNamespaceURI();
                    if (namespaceURI != null) {
                        prefix = xmlWriter.getPrefix(namespaceURI);
                        if ((prefix == null) || (prefix.length() == 0)) {
                            prefix = generatePrefix(namespaceURI);
                            xmlWriter.writeNamespace(prefix, namespaceURI);
                            xmlWriter.setPrefix(prefix,namespaceURI);
                        }

                        if (prefix.trim().length() > 0){
                            stringToWrite.append(prefix).append(":").append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                    }
                }
                xmlWriter.writeCharacters(stringToWrite.toString());
            }

        }


        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(javax.xml.stream.XMLStreamWriter xmlWriter, java.lang.String namespace) throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);
            if (prefix == null) {
                prefix = generatePrefix(namespace);
                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();
                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);
                    if (uri == null || uri.length() == 0) {
                        break;
                    }
                    prefix = org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
                }
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            return prefix;
        }


  
        /**
        * databinding method to get an XML representation of this object
        *
        */
        public javax.xml.stream.XMLStreamReader getPullParser(javax.xml.namespace.QName qName)
                    throws org.apache.axis2.databinding.ADBException{


        
                 java.util.ArrayList elementList = new java.util.ArrayList();
                 java.util.ArrayList attribList = new java.util.ArrayList();

                 if (localMODETracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "MODE"));
                                 
                                        if (localMODE != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localMODE));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("MODE cannot be null!!");
                                        }
                                    } if (localBNKCDTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "BNKCD"));
                                 
                                        if (localBNKCD != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localBNKCD));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("BNKCD cannot be null!!");
                                        }
                                    } if (localTRNTRNDTTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "TRNTRNDT"));
                                 
                                        if (localTRNTRNDT != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localTRNTRNDT));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("TRNTRNDT cannot be null!!");
                                        }
                                    } if (localTRNTRNCDTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "TRNTRNCD"));
                                 
                                        if (localTRNTRNCD != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localTRNTRNCD));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("TRNTRNCD cannot be null!!");
                                        }
                                    } if (localIGJMTracker){
                            elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "IGJM"));
                            
                            
                                    if (localIGJM==null){
                                         throw new org.apache.axis2.databinding.ADBException("IGJM cannot be null!!");
                                    }
                                    elementList.add(localIGJM);
                                } if (localBSISTracker){
                            elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "BSIS"));
                            
                            
                                    if (localBSIS==null){
                                         throw new org.apache.axis2.databinding.ADBException("BSIS cannot be null!!");
                                    }
                                    elementList.add(localBSIS);
                                } if (localGWCDTracker){
                            elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "GWCD"));
                            
                            
                                    if (localGWCD==null){
                                         throw new org.apache.axis2.databinding.ADBException("GWCD cannot be null!!");
                                    }
                                    elementList.add(localGWCD);
                                } if (localIJGBTracker){
                            elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "IJGB"));
                            
                            
                                    if (localIJGB==null){
                                         throw new org.apache.axis2.databinding.ADBException("IJGB cannot be null!!");
                                    }
                                    elementList.add(localIJGB);
                                } if (localTSAMTracker){
                            elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "TSAM"));
                            
                            
                                    if (localTSAM==null){
                                         throw new org.apache.axis2.databinding.ADBException("TSAM cannot be null!!");
                                    }
                                    elementList.add(localTSAM);
                                } if (localUSRUSRIDTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "USRUSRID"));
                                 
                                        if (localUSRUSRID != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localUSRUSRID));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("USRUSRID cannot be null!!");
                                        }
                                    } if (localINF_REF_NOTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "INF_REF_NO"));
                                 
                                        if (localINF_REF_NO != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localINF_REF_NO));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("INF_REF_NO cannot be null!!");
                                        }
                                    }

                return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName, elementList.toArray(), attribList.toArray());
            
            

        }

  

     /**
      *  Factory class that keeps the parse method
      */
    public static class Factory{

        
        

        /**
        * static method to create the object
        * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
        *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
        * Postcondition: If this object is an element, the reader is positioned at its end element
        *                If this object is a complex type, the reader is positioned at the end element of its outer element
        */
        public static EPS0033 parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            EPS0033 object =
                new EPS0033();

            int event;
            java.lang.String nillableValue = null;
            java.lang.String prefix ="";
            java.lang.String namespaceuri ="";
            try {
                
                while (!reader.isStartElement() && !reader.isEndElement())
                    reader.next();

                
                if (reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","type")!=null){
                  java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                        "type");
                  if (fullTypeName!=null){
                    java.lang.String nsPrefix = null;
                    if (fullTypeName.indexOf(":") > -1){
                        nsPrefix = fullTypeName.substring(0,fullTypeName.indexOf(":"));
                    }
                    nsPrefix = nsPrefix==null?"":nsPrefix;

                    java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(":")+1);
                    
                            if (!"EPS0033".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (EPS0033)ExtensionMapper.getTypeObject(
                                     nsUri,type,reader);
                              }
                        

                  }
                

                }

                

                
                // Note all attributes that were handled. Used to differ normal attributes
                // from anyAttributes.
                java.util.Vector handledAttributes = new java.util.Vector();
                

                
                    
                    reader.next();
                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","MODE").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"MODE" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setMODE(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","BNKCD").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"BNKCD" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setBNKCD(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","TRNTRNDT").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"TRNTRNDT" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setTRNTRNDT(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","TRNTRNCD").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"TRNTRNCD" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setTRNTRNCD(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","IGJM").equals(reader.getName())){
                                
                                                object.setIGJM(ArrayOfString.Factory.parse(reader));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","BSIS").equals(reader.getName())){
                                
                                                object.setBSIS(ArrayOfString.Factory.parse(reader));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","GWCD").equals(reader.getName())){
                                
                                                object.setGWCD(ArrayOfString.Factory.parse(reader));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","IJGB").equals(reader.getName())){
                                
                                                object.setIJGB(ArrayOfString.Factory.parse(reader));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","TSAM").equals(reader.getName())){
                                
                                                object.setTSAM(ArrayOfString.Factory.parse(reader));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","USRUSRID").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"USRUSRID" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setUSRUSRID(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","INF_REF_NO").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"INF_REF_NO" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setINF_REF_NO(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                  
                            while (!reader.isStartElement() && !reader.isEndElement())
                                reader.next();
                            
                                if (reader.isStartElement())
                                // A start element we are not expecting indicates a trailing invalid property
                                throw new org.apache.axis2.databinding.ADBException("Unexpected subelement " + reader.getName());
                            



            } catch (javax.xml.stream.XMLStreamException e) {
                throw new java.lang.Exception(e);
            }

            return object;
        }

        }//end of factory class

        

        }
           
    
        public static class ExtensionMapper{

          public static java.lang.Object getTypeObject(java.lang.String namespaceURI,
                                                       java.lang.String typeName,
                                                       javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{

              
                  if (
                  "http://wpms.woorifg.com/WPMS.WebService".equals(namespaceURI) &&
                  "ArrayOfString".equals(typeName)){
                   
                            return  ArrayOfString.Factory.parse(reader);
                        

                  }

              
             throw new org.apache.axis2.databinding.ADBException("Unsupported type " + namespaceURI + " " + typeName);
          }

        }
    
        public static class EPS0033Response
        implements org.apache.axis2.databinding.ADBBean{
        
                public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService",
                "EPS0033Response",
                "ns1");

            

                        /**
                        * field for EPS0033Result
                        */

                        
                                    protected ArrayOfString localEPS0033Result ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localEPS0033ResultTracker = false ;

                           public boolean isEPS0033ResultSpecified(){
                               return localEPS0033ResultTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return ArrayOfString
                           */
                           public  ArrayOfString getEPS0033Result(){
                               return localEPS0033Result;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param EPS0033Result
                               */
                               public void setEPS0033Result(ArrayOfString param){
                            localEPS0033ResultTracker = param != null;
                                   
                                            this.localEPS0033Result=param;
                                    

                               }
                            

     
     
        /**
        *
        * @param parentQName
        * @param factory
        * @return org.apache.axiom.om.OMElement
        */
       public org.apache.axiom.om.OMElement getOMElement (
               final javax.xml.namespace.QName parentQName,
               final org.apache.axiom.om.OMFactory factory) throws org.apache.axis2.databinding.ADBException{


        
               org.apache.axiom.om.OMDataSource dataSource =
                       new org.apache.axis2.databinding.ADBDataSource(this,MY_QNAME);
               return factory.createOMElement(dataSource,MY_QNAME);
            
        }

         public void serialize(final javax.xml.namespace.QName parentQName,
                                       javax.xml.stream.XMLStreamWriter xmlWriter)
                                throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
                           serialize(parentQName,xmlWriter,false);
         }

         public void serialize(final javax.xml.namespace.QName parentQName,
                               javax.xml.stream.XMLStreamWriter xmlWriter,
                               boolean serializeType)
            throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
            
                


                java.lang.String prefix = null;
                java.lang.String namespace = null;
                

                    prefix = parentQName.getPrefix();
                    namespace = parentQName.getNamespaceURI();
                    writeStartElement(prefix, namespace, parentQName.getLocalPart(), xmlWriter);
                
                  if (serializeType){
               

                   java.lang.String namespacePrefix = registerPrefix(xmlWriter,"http://wpms.woorifg.com/WPMS.WebService");
                   if ((namespacePrefix != null) && (namespacePrefix.trim().length() > 0)){
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           namespacePrefix+":EPS0033Response",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "EPS0033Response",
                           xmlWriter);
                   }

               
                   }
                if (localEPS0033ResultTracker){
                                            if (localEPS0033Result==null){
                                                 throw new org.apache.axis2.databinding.ADBException("EPS0033Result cannot be null!!");
                                            }
                                           localEPS0033Result.serialize(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","EPS0033Result"),
                                               xmlWriter);
                                        }
                    xmlWriter.writeEndElement();
               

        }

        private static java.lang.String generatePrefix(java.lang.String namespace) {
            if(namespace.equals("http://wpms.woorifg.com/WPMS.WebService")){
                return "ns1";
            }
            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix, java.lang.String namespace, java.lang.String localPart,
                                       javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String writerPrefix = xmlWriter.getPrefix(namespace);
            if (writerPrefix != null) {
                xmlWriter.writeStartElement(namespace, localPart);
            } else {
                if (namespace.length() == 0) {
                    prefix = "";
                } else if (prefix == null) {
                    prefix = generatePrefix(namespace);
                }

                xmlWriter.writeStartElement(prefix, localPart, namespace);
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
        }
        
        /**
         * Util method to write an attribute with the ns prefix
         */
        private void writeAttribute(java.lang.String prefix,java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            xmlWriter.writeAttribute(namespace,attName,attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName,attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace,attName,attValue);
            }
        }


           /**
             * Util method to write an attribute without the ns prefix
             */
            private void writeQNameAttribute(java.lang.String namespace, java.lang.String attName,
                                             javax.xml.namespace.QName qname, javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

                java.lang.String attributeNamespace = qname.getNamespaceURI();
                java.lang.String attributePrefix = xmlWriter.getPrefix(attributeNamespace);
                if (attributePrefix == null) {
                    attributePrefix = registerPrefix(xmlWriter, attributeNamespace);
                }
                java.lang.String attributeValue;
                if (attributePrefix.trim().length() > 0) {
                    attributeValue = attributePrefix + ":" + qname.getLocalPart();
                } else {
                    attributeValue = qname.getLocalPart();
                }

                if (namespace.equals("")) {
                    xmlWriter.writeAttribute(attName, attributeValue);
                } else {
                    registerPrefix(xmlWriter, namespace);
                    xmlWriter.writeAttribute(namespace, attName, attributeValue);
                }
            }
        /**
         *  method to handle Qnames
         */

        private void writeQName(javax.xml.namespace.QName qname,
                                javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();
            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);
                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix,namespaceURI);
                }

                if (prefix.trim().length() > 0){
                    xmlWriter.writeCharacters(prefix + ":" + org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                }

            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
                                 javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

            if (qnames != null) {
                // we have to store this data until last moment since it is not possible to write any
                // namespace data after writing the charactor data
                java.lang.StringBuffer stringToWrite = new java.lang.StringBuffer();
                java.lang.String namespaceURI = null;
                java.lang.String prefix = null;

                for (int i = 0; i < qnames.length; i++) {
                    if (i > 0) {
                        stringToWrite.append(" ");
                    }
                    namespaceURI = qnames[i].getNamespaceURI();
                    if (namespaceURI != null) {
                        prefix = xmlWriter.getPrefix(namespaceURI);
                        if ((prefix == null) || (prefix.length() == 0)) {
                            prefix = generatePrefix(namespaceURI);
                            xmlWriter.writeNamespace(prefix, namespaceURI);
                            xmlWriter.setPrefix(prefix,namespaceURI);
                        }

                        if (prefix.trim().length() > 0){
                            stringToWrite.append(prefix).append(":").append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                    }
                }
                xmlWriter.writeCharacters(stringToWrite.toString());
            }

        }


        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(javax.xml.stream.XMLStreamWriter xmlWriter, java.lang.String namespace) throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);
            if (prefix == null) {
                prefix = generatePrefix(namespace);
                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();
                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);
                    if (uri == null || uri.length() == 0) {
                        break;
                    }
                    prefix = org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
                }
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            return prefix;
        }


  
        /**
        * databinding method to get an XML representation of this object
        *
        */
        public javax.xml.stream.XMLStreamReader getPullParser(javax.xml.namespace.QName qName)
                    throws org.apache.axis2.databinding.ADBException{


        
                 java.util.ArrayList elementList = new java.util.ArrayList();
                 java.util.ArrayList attribList = new java.util.ArrayList();

                 if (localEPS0033ResultTracker){
                            elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "EPS0033Result"));
                            
                            
                                    if (localEPS0033Result==null){
                                         throw new org.apache.axis2.databinding.ADBException("EPS0033Result cannot be null!!");
                                    }
                                    elementList.add(localEPS0033Result);
                                }

                return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName, elementList.toArray(), attribList.toArray());
            
            

        }

  

     /**
      *  Factory class that keeps the parse method
      */
    public static class Factory{

        
        

        /**
        * static method to create the object
        * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
        *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
        * Postcondition: If this object is an element, the reader is positioned at its end element
        *                If this object is a complex type, the reader is positioned at the end element of its outer element
        */
        public static EPS0033Response parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            EPS0033Response object =
                new EPS0033Response();

            int event;
            java.lang.String nillableValue = null;
            java.lang.String prefix ="";
            java.lang.String namespaceuri ="";
            try {
                
                while (!reader.isStartElement() && !reader.isEndElement())
                    reader.next();

                
                if (reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","type")!=null){
                  java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                        "type");
                  if (fullTypeName!=null){
                    java.lang.String nsPrefix = null;
                    if (fullTypeName.indexOf(":") > -1){
                        nsPrefix = fullTypeName.substring(0,fullTypeName.indexOf(":"));
                    }
                    nsPrefix = nsPrefix==null?"":nsPrefix;

                    java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(":")+1);
                    
                            if (!"EPS0033Response".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (EPS0033Response)ExtensionMapper.getTypeObject(
                                     nsUri,type,reader);
                              }
                        

                  }
                

                }

                

                
                // Note all attributes that were handled. Used to differ normal attributes
                // from anyAttributes.
                java.util.Vector handledAttributes = new java.util.Vector();
                

                
                    
                    reader.next();
                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","EPS0033Result").equals(reader.getName())){
                                
                                                object.setEPS0033Result(ArrayOfString.Factory.parse(reader));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                  
                            while (!reader.isStartElement() && !reader.isEndElement())
                                reader.next();
                            
                                if (reader.isStartElement())
                                // A start element we are not expecting indicates a trailing invalid property
                                throw new org.apache.axis2.databinding.ADBException("Unexpected subelement " + reader.getName());
                            



            } catch (javax.xml.stream.XMLStreamException e) {
                throw new java.lang.Exception(e);
            }

            return object;
        }

        }//end of factory class

        

        }
           
    
        public static class ArrayOfString
        implements org.apache.axis2.databinding.ADBBean{
        /* This type was generated from the piece of schema that had
                name = ArrayOfString
                Namespace URI = http://wpms.woorifg.com/WPMS.WebService
                Namespace Prefix = ns1
                */
            

                        /**
                        * field for String
                        * This was an Array!
                        */

                        
                                    protected java.lang.String[] localString ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localStringTracker = false ;

                           public boolean isStringSpecified(){
                               return localStringTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String[]
                           */
                           public  java.lang.String[] getString(){
                               return localString;
                           }

                           
                        


                               
                              /**
                               * validate the array for String
                               */
                              protected void validateString(java.lang.String[] param){
                             
                              }


                             /**
                              * Auto generated setter method
                              * @param param String
                              */
                              public void setString(java.lang.String[] param){
                              
                                   validateString(param);

                               localStringTracker = true;
                                      
                                      this.localString=param;
                              }

                               
                             
                             /**
                             * Auto generated add method for the array for convenience
                             * @param param java.lang.String
                             */
                             public void addString(java.lang.String param){
                                   if (localString == null){
                                   localString = new java.lang.String[]{};
                                   }

                            
                                 //update the setting tracker
                                localStringTracker = true;
                            

                               java.util.List list =
                            org.apache.axis2.databinding.utils.ConverterUtil.toList(localString);
                               list.add(param);
                               this.localString =
                             (java.lang.String[])list.toArray(
                            new java.lang.String[list.size()]);

                             }
                             

     
     
        /**
        *
        * @param parentQName
        * @param factory
        * @return org.apache.axiom.om.OMElement
        */
       public org.apache.axiom.om.OMElement getOMElement (
               final javax.xml.namespace.QName parentQName,
               final org.apache.axiom.om.OMFactory factory) throws org.apache.axis2.databinding.ADBException{


        
               org.apache.axiom.om.OMDataSource dataSource =
                       new org.apache.axis2.databinding.ADBDataSource(this,parentQName);
               return factory.createOMElement(dataSource,parentQName);
            
        }

         public void serialize(final javax.xml.namespace.QName parentQName,
                                       javax.xml.stream.XMLStreamWriter xmlWriter)
                                throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
                           serialize(parentQName,xmlWriter,false);
         }

         public void serialize(final javax.xml.namespace.QName parentQName,
                               javax.xml.stream.XMLStreamWriter xmlWriter,
                               boolean serializeType)
            throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
            
                


                java.lang.String prefix = null;
                java.lang.String namespace = null;
                

                    prefix = parentQName.getPrefix();
                    namespace = parentQName.getNamespaceURI();
                    writeStartElement(prefix, namespace, parentQName.getLocalPart(), xmlWriter);
                
                  if (serializeType){
               

                   java.lang.String namespacePrefix = registerPrefix(xmlWriter,"http://wpms.woorifg.com/WPMS.WebService");
                   if ((namespacePrefix != null) && (namespacePrefix.trim().length() > 0)){
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           namespacePrefix+":ArrayOfString",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "ArrayOfString",
                           xmlWriter);
                   }

               
                   }
                if (localStringTracker){
                             if (localString!=null) {
                                   namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                   for (int i = 0;i < localString.length;i++){
                                        
                                            if (localString[i] != null){
                                        
                                                writeStartElement(null, namespace, "string", xmlWriter);

                                            
                                                        xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localString[i]));
                                                    
                                                xmlWriter.writeEndElement();
                                              
                                                } else {
                                                   
                                                           // write null attribute
                                                            namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                                            writeStartElement(null, namespace, "string", xmlWriter);
                                                            writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                            xmlWriter.writeEndElement();
                                                       
                                                }

                                   }
                             } else {
                                 
                                         // write the null attribute
                                        // write null attribute
                                           writeStartElement(null, "http://wpms.woorifg.com/WPMS.WebService", "string", xmlWriter);

                                           // write the nil attribute
                                           writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                           xmlWriter.writeEndElement();
                                    
                             }

                        }
                    xmlWriter.writeEndElement();
               

        }

        private static java.lang.String generatePrefix(java.lang.String namespace) {
            if(namespace.equals("http://wpms.woorifg.com/WPMS.WebService")){
                return "ns1";
            }
            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix, java.lang.String namespace, java.lang.String localPart,
                                       javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String writerPrefix = xmlWriter.getPrefix(namespace);
            if (writerPrefix != null) {
                xmlWriter.writeStartElement(namespace, localPart);
            } else {
                if (namespace.length() == 0) {
                    prefix = "";
                } else if (prefix == null) {
                    prefix = generatePrefix(namespace);
                }

                xmlWriter.writeStartElement(prefix, localPart, namespace);
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
        }
        
        /**
         * Util method to write an attribute with the ns prefix
         */
        private void writeAttribute(java.lang.String prefix,java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            xmlWriter.writeAttribute(namespace,attName,attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName,attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace,attName,attValue);
            }
        }


           /**
             * Util method to write an attribute without the ns prefix
             */
            private void writeQNameAttribute(java.lang.String namespace, java.lang.String attName,
                                             javax.xml.namespace.QName qname, javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

                java.lang.String attributeNamespace = qname.getNamespaceURI();
                java.lang.String attributePrefix = xmlWriter.getPrefix(attributeNamespace);
                if (attributePrefix == null) {
                    attributePrefix = registerPrefix(xmlWriter, attributeNamespace);
                }
                java.lang.String attributeValue;
                if (attributePrefix.trim().length() > 0) {
                    attributeValue = attributePrefix + ":" + qname.getLocalPart();
                } else {
                    attributeValue = qname.getLocalPart();
                }

                if (namespace.equals("")) {
                    xmlWriter.writeAttribute(attName, attributeValue);
                } else {
                    registerPrefix(xmlWriter, namespace);
                    xmlWriter.writeAttribute(namespace, attName, attributeValue);
                }
            }
        /**
         *  method to handle Qnames
         */

        private void writeQName(javax.xml.namespace.QName qname,
                                javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();
            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);
                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix,namespaceURI);
                }

                if (prefix.trim().length() > 0){
                    xmlWriter.writeCharacters(prefix + ":" + org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                }

            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
                                 javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

            if (qnames != null) {
                // we have to store this data until last moment since it is not possible to write any
                // namespace data after writing the charactor data
                java.lang.StringBuffer stringToWrite = new java.lang.StringBuffer();
                java.lang.String namespaceURI = null;
                java.lang.String prefix = null;

                for (int i = 0; i < qnames.length; i++) {
                    if (i > 0) {
                        stringToWrite.append(" ");
                    }
                    namespaceURI = qnames[i].getNamespaceURI();
                    if (namespaceURI != null) {
                        prefix = xmlWriter.getPrefix(namespaceURI);
                        if ((prefix == null) || (prefix.length() == 0)) {
                            prefix = generatePrefix(namespaceURI);
                            xmlWriter.writeNamespace(prefix, namespaceURI);
                            xmlWriter.setPrefix(prefix,namespaceURI);
                        }

                        if (prefix.trim().length() > 0){
                            stringToWrite.append(prefix).append(":").append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                    }
                }
                xmlWriter.writeCharacters(stringToWrite.toString());
            }

        }


        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(javax.xml.stream.XMLStreamWriter xmlWriter, java.lang.String namespace) throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);
            if (prefix == null) {
                prefix = generatePrefix(namespace);
                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();
                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);
                    if (uri == null || uri.length() == 0) {
                        break;
                    }
                    prefix = org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
                }
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            return prefix;
        }


  
        /**
        * databinding method to get an XML representation of this object
        *
        */
        public javax.xml.stream.XMLStreamReader getPullParser(javax.xml.namespace.QName qName)
                    throws org.apache.axis2.databinding.ADBException{


        
                 java.util.ArrayList elementList = new java.util.ArrayList();
                 java.util.ArrayList attribList = new java.util.ArrayList();

                 if (localStringTracker){
                            if (localString!=null){
                                  for (int i = 0;i < localString.length;i++){
                                      
                                         if (localString[i] != null){
                                          elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                              "string"));
                                          elementList.add(
                                          org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localString[i]));
                                          } else {
                                             
                                                    elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                              "string"));
                                                    elementList.add(null);
                                                
                                          }
                                      

                                  }
                            } else {
                              
                                    elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                              "string"));
                                    elementList.add(null);
                                
                            }

                        }

                return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName, elementList.toArray(), attribList.toArray());
            
            

        }

  

     /**
      *  Factory class that keeps the parse method
      */
    public static class Factory{

        
        

        /**
        * static method to create the object
        * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
        *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
        * Postcondition: If this object is an element, the reader is positioned at its end element
        *                If this object is a complex type, the reader is positioned at the end element of its outer element
        */
        public static ArrayOfString parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            ArrayOfString object =
                new ArrayOfString();

            int event;
            java.lang.String nillableValue = null;
            java.lang.String prefix ="";
            java.lang.String namespaceuri ="";
            try {
                
                while (!reader.isStartElement() && !reader.isEndElement())
                    reader.next();

                
                if (reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","type")!=null){
                  java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                        "type");
                  if (fullTypeName!=null){
                    java.lang.String nsPrefix = null;
                    if (fullTypeName.indexOf(":") > -1){
                        nsPrefix = fullTypeName.substring(0,fullTypeName.indexOf(":"));
                    }
                    nsPrefix = nsPrefix==null?"":nsPrefix;

                    java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(":")+1);
                    
                            if (!"ArrayOfString".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (ArrayOfString)ExtensionMapper.getTypeObject(
                                     nsUri,type,reader);
                              }
                        

                  }
                

                }

                

                
                // Note all attributes that were handled. Used to differ normal attributes
                // from anyAttributes.
                java.util.Vector handledAttributes = new java.util.Vector();
                

                
                    
                    reader.next();
                
                        java.util.ArrayList list1 = new java.util.ArrayList();
                    
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","string").equals(reader.getName())){
                                
                                    
                                    
                                    // Process the array and step past its final element's end.
                                    
                                              nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                              if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                                  list1.add(null);
                                                       
                                                  reader.next();
                                              } else {
                                            list1.add(reader.getElementText());
                                            }
                                            //loop until we find a start element that is not part of this array
                                            boolean loopDone1 = false;
                                            while(!loopDone1){
                                                // Ensure we are at the EndElement
                                                while (!reader.isEndElement()){
                                                    reader.next();
                                                }
                                                // Step out of this element
                                                reader.next();
                                                // Step to next element event.
                                                while (!reader.isStartElement() && !reader.isEndElement())
                                                    reader.next();
                                                if (reader.isEndElement()){
                                                    //two continuous end elements means we are exiting the xml structure
                                                    loopDone1 = true;
                                                } else {
                                                    if (new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","string").equals(reader.getName())){
                                                         
                                                          nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                                          if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                                              list1.add(null);
                                                                   
                                                              reader.next();
                                                          } else {
                                                        list1.add(reader.getElementText());
                                                        }
                                                    }else{
                                                        loopDone1 = true;
                                                    }
                                                }
                                            }
                                            // call the converter utility  to convert and set the array
                                            
                                                    object.setString((java.lang.String[])
                                                        list1.toArray(new java.lang.String[list1.size()]));
                                                
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                  
                            while (!reader.isStartElement() && !reader.isEndElement())
                                reader.next();
                            
                                if (reader.isStartElement())
                                // A start element we are not expecting indicates a trailing invalid property
                                throw new org.apache.axis2.databinding.ADBException("Unexpected subelement " + reader.getName());
                            



            } catch (javax.xml.stream.XMLStreamException e) {
                throw new java.lang.Exception(e);
            }

            return object;
        }

        }//end of factory class

        

        }
           
    
            private  org.apache.axiom.om.OMElement  toOM(com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033 param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033 param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             


        /**
        *  get the default envelope
        */
        private org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory){
        return factory.getDefaultEnvelope();
        }


        private  java.lang.Object fromOM(
        org.apache.axiom.om.OMElement param,
        java.lang.Class type,
        java.util.Map extraNamespaces) throws org.apache.axis2.AxisFault{

        try {
        
                if (com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033.class.equals(type)){
                
                           return com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response.class.equals(type)){
                
                           return com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
        } catch (java.lang.Exception e) {
        throw org.apache.axis2.AxisFault.makeFault(e);
        }
           return null;
        }



    
   }
   