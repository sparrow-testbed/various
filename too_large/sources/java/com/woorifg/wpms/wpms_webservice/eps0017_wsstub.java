
/**
 * EPS0017_WSStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */
        package com.woorifg.wpms.wpms_webservice;

        

        /*
        *  EPS0017_WSStub java implementation
        */

        
        public class EPS0017_WSStub extends org.apache.axis2.client.Stub
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
     _service = new org.apache.axis2.description.AxisService("EPS0017_WS" + getUniqueSuffix());
     addAnonymousOperations();

        //creating the operations
        org.apache.axis2.description.AxisOperation __operation;

        _operations = new org.apache.axis2.description.AxisOperation[1];
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService", "ePS0017"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[0]=__operation;
            
        
        }

    //populates the faults
    private void populateFaults(){
         


    }

    /**
      *Constructor that takes in a configContext
      */

    public EPS0017_WSStub(org.apache.axis2.context.ConfigurationContext configurationContext,
       java.lang.String targetEndpoint)
       throws org.apache.axis2.AxisFault {
         this(configurationContext,targetEndpoint,false);
   }


   /**
     * Constructor that takes in a configContext  and useseperate listner
     */
   public EPS0017_WSStub(org.apache.axis2.context.ConfigurationContext configurationContext,
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
    public EPS0017_WSStub(org.apache.axis2.context.ConfigurationContext configurationContext) throws org.apache.axis2.AxisFault {
        
                    this(configurationContext,"http://wpms.woorifg.com/WPMS.WebService/EPS0017_WS.asmx" );
                
    }

    /**
     * Default Constructor
     */
    public EPS0017_WSStub() throws org.apache.axis2.AxisFault {
        
                    this("http://wpms.woorifg.com/WPMS.WebService/EPS0017_WS.asmx" );
                
    }

    /**
     * Constructor taking the target endpoint
     */
    public EPS0017_WSStub(java.lang.String targetEndpoint) throws org.apache.axis2.AxisFault {
        this(null,targetEndpoint);
    }



        
                    /**
                     * Auto generated method signature
                     * &lt;br&gt;&lt;b&gt;자산등재(재산_부동산 자본적지출)&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;파라미터명&lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;등록(C)시 필수&lt;/td&gt;&lt;td width=100 align=center&gt;취소(R)시 필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE	&lt;/td&gt;&lt;td&gt;작업구분&lt;/td&gt;&lt;td&gt;string / (고정형)1&lt;/td&gt;&lt;td&gt;C (등록) , R (취소)  대문자&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMYY&lt;/td&gt;&lt;td&gt;품의년도&lt;/td&gt;&lt;td&gt;string / (고정형)4&lt;/td&gt;&lt;td&gt;EPS0019 return[1]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMNO&lt;/td&gt;&lt;td&gt;품의번호&lt;/td&gt;&lt;td&gt;string / (고정형)5&lt;/td&gt;&lt;td&gt;EPS0019 return[2]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPNO&lt;/td&gt;&lt;td&gt;승인번호&lt;/td&gt;&lt;td&gt;string / (고정형)3&lt;/td&gt;&lt;td&gt;EPS0019 return[3]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPAM&lt;/td&gt;&lt;td&gt;승인금액&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;EPS0019 return[4]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;소속점코드&lt;/td&gt;&lt;td&gt;string / (가변형)6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ASTASTGB&lt;/td&gt;&lt;td&gt;자산구분&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;토지(10) , 건물(20) , 임차점포시설물(30)&lt;br&gt;BDSBDSNO(부동산번호) 앞 2자리&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;UNQUNQNO&lt;/td&gt;&lt;td&gt;자산번호&lt;/td&gt;&lt;td&gt;string / (고정형)5&lt;/td&gt;&lt;td&gt;BDSBDSNO(부동산번호) 뒷 5자리&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ACTACTGB&lt;/td&gt;&lt;td&gt;계정구분&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;업무용토지(01),업무용건물(02)&lt;br&gt;임차시설물(03),건설중인자산(04)&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;CHGCHGAM&lt;/td&gt;&lt;td&gt;자본적지출금액&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TRNTRNGB&lt;/td&gt;&lt;td&gt;거래구분&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;계약금(79),중도금(81),잔금(83),세금(85)&lt;br&gt;부대비용(87),기타(16),인건비(68)&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;사용자행번&lt;/td&gt;&lt;td&gt;string / (고정형)8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;인터페이스번호&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;전자구매에서 생성한 인터페이스번호&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ETCETCNY&lt;/td&gt;&lt;td&gt;비고&lt;/td&gt;&lt;td&gt;string / (가변형)255&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[4]값   string[0] - 200 : 성공, 그외 에러번호 실퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - 개발자 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - 시스템 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - 재산관리에서 생성한 인터페이스번호&lt;/b&gt;&lt;br&gt;
                     * @see com.woorifg.wpms.wpms_webservice.EPS0017_WS#ePS0017
                     * @param ePS00170
                    
                     */

                    

                            public  com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response ePS0017(

                            com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017 ePS00170)
                        

                    throws java.rmi.RemoteException
                    
                    {
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[0].getName());
              _operationClient.getOptions().setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0017");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    ePS00170,
                                                    optimizeContent(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0017")), new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0017"));
                                                
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
                                             com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0017"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0017"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0017"));
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
                * &lt;br&gt;&lt;b&gt;자산등재(재산_부동산 자본적지출)&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;파라미터명&lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;등록(C)시 필수&lt;/td&gt;&lt;td width=100 align=center&gt;취소(R)시 필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE	&lt;/td&gt;&lt;td&gt;작업구분&lt;/td&gt;&lt;td&gt;string / (고정형)1&lt;/td&gt;&lt;td&gt;C (등록) , R (취소)  대문자&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMYY&lt;/td&gt;&lt;td&gt;품의년도&lt;/td&gt;&lt;td&gt;string / (고정형)4&lt;/td&gt;&lt;td&gt;EPS0019 return[1]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMNO&lt;/td&gt;&lt;td&gt;품의번호&lt;/td&gt;&lt;td&gt;string / (고정형)5&lt;/td&gt;&lt;td&gt;EPS0019 return[2]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPNO&lt;/td&gt;&lt;td&gt;승인번호&lt;/td&gt;&lt;td&gt;string / (고정형)3&lt;/td&gt;&lt;td&gt;EPS0019 return[3]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPAM&lt;/td&gt;&lt;td&gt;승인금액&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;EPS0019 return[4]값&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;소속점코드&lt;/td&gt;&lt;td&gt;string / (가변형)6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ASTASTGB&lt;/td&gt;&lt;td&gt;자산구분&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;토지(10) , 건물(20) , 임차점포시설물(30)&lt;br&gt;BDSBDSNO(부동산번호) 앞 2자리&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;UNQUNQNO&lt;/td&gt;&lt;td&gt;자산번호&lt;/td&gt;&lt;td&gt;string / (고정형)5&lt;/td&gt;&lt;td&gt;BDSBDSNO(부동산번호) 뒷 5자리&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ACTACTGB&lt;/td&gt;&lt;td&gt;계정구분&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;업무용토지(01),업무용건물(02)&lt;br&gt;임차시설물(03),건설중인자산(04)&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;CHGCHGAM&lt;/td&gt;&lt;td&gt;자본적지출금액&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;TRNTRNGB&lt;/td&gt;&lt;td&gt;거래구분&lt;/td&gt;&lt;td&gt;string / (고정형)2&lt;/td&gt;&lt;td&gt;계약금(79),중도금(81),잔금(83),세금(85)&lt;br&gt;부대비용(87),기타(16),인건비(68)&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;사용자행번&lt;/td&gt;&lt;td&gt;string / (고정형)8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;인터페이스번호&lt;/td&gt;&lt;td&gt;string / (가변형)15&lt;/td&gt;&lt;td&gt;전자구매에서 생성한 인터페이스번호&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;td&gt;필수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ETCETCNY&lt;/td&gt;&lt;td&gt;비고&lt;/td&gt;&lt;td&gt;string / (가변형)255&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[4]값   string[0] - 200 : 성공, 그외 에러번호 실퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - 개발자 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - 시스템 오류메세지&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - 재산관리에서 생성한 인터페이스번호&lt;/b&gt;&lt;br&gt;
                * @see com.woorifg.wpms.wpms_webservice.EPS0017_WS#startePS0017
                    * @param ePS00170
                
                */
                public  void startePS0017(

                 com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017 ePS00170,

                  final com.woorifg.wpms.wpms_webservice.EPS0017_WSCallbackHandler callback)

                throws java.rmi.RemoteException{

              org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[0].getName());
             _operationClient.getOptions().setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0017");
             _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              


              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env=null;
              final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

                    
                                    //Style is Doc.
                                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    ePS00170,
                                                    optimizeContent(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0017")), new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                    "ePS0017"));
                                                
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
                                                                         com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response.class,
                                                                         getEnvelopeNamespaces(resultEnv));
                                        callback.receiveResultePS0017(
                                        (com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response)object);
                                        
                            } catch (org.apache.axis2.AxisFault e) {
                                callback.receiveErrorePS0017(e);
                            }
                            }

                            public void onError(java.lang.Exception error) {
								if (error instanceof org.apache.axis2.AxisFault) {
									org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
									org.apache.axiom.om.OMElement faultElt = f.getDetail();
									if (faultElt!=null){
										if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0017"))){
											//make the fault by reflection
											try{
													java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0017"));
													java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
													java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
													//message class
													java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"EPS0017"));
														java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
													java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
													java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
															new java.lang.Class[]{messageClass});
													m.invoke(ex,new java.lang.Object[]{messageObject});
													
					
										            callback.receiveErrorePS0017(new java.rmi.RemoteException(ex.getMessage(), ex));
                                            } catch(java.lang.ClassCastException e){
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0017(f);
                                            } catch (java.lang.ClassNotFoundException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0017(f);
                                            } catch (java.lang.NoSuchMethodException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0017(f);
                                            } catch (java.lang.reflect.InvocationTargetException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0017(f);
                                            } catch (java.lang.IllegalAccessException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0017(f);
                                            } catch (java.lang.InstantiationException e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0017(f);
                                            } catch (org.apache.axis2.AxisFault e) {
                                                // we cannot intantiate the class - throw the original Axis fault
                                                callback.receiveErrorePS0017(f);
                                            }
									    } else {
										    callback.receiveErrorePS0017(f);
									    }
									} else {
									    callback.receiveErrorePS0017(f);
									}
								} else {
								    callback.receiveErrorePS0017(error);
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
                                    callback.receiveErrorePS0017(axisFault);
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
     //http://wpms.woorifg.com/WPMS.WebService/EPS0017_WS.asmx
        public static class EPS0017
        implements org.apache.axis2.databinding.ADBBean{
        
                public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService",
                "EPS0017",
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
                        * field for PUMPUMYY
                        */

                        
                                    protected java.lang.String localPUMPUMYY ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localPUMPUMYYTracker = false ;

                           public boolean isPUMPUMYYSpecified(){
                               return localPUMPUMYYTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getPUMPUMYY(){
                               return localPUMPUMYY;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param PUMPUMYY
                               */
                               public void setPUMPUMYY(java.lang.String param){
                            localPUMPUMYYTracker = param != null;
                                   
                                            this.localPUMPUMYY=param;
                                    

                               }
                            

                        /**
                        * field for PUMPUMNO
                        */

                        
                                    protected java.lang.String localPUMPUMNO ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localPUMPUMNOTracker = false ;

                           public boolean isPUMPUMNOSpecified(){
                               return localPUMPUMNOTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getPUMPUMNO(){
                               return localPUMPUMNO;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param PUMPUMNO
                               */
                               public void setPUMPUMNO(java.lang.String param){
                            localPUMPUMNOTracker = param != null;
                                   
                                            this.localPUMPUMNO=param;
                                    

                               }
                            

                        /**
                        * field for APPAPPNO
                        */

                        
                                    protected java.lang.String localAPPAPPNO ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localAPPAPPNOTracker = false ;

                           public boolean isAPPAPPNOSpecified(){
                               return localAPPAPPNOTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getAPPAPPNO(){
                               return localAPPAPPNO;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param APPAPPNO
                               */
                               public void setAPPAPPNO(java.lang.String param){
                            localAPPAPPNOTracker = param != null;
                                   
                                            this.localAPPAPPNO=param;
                                    

                               }
                            

                        /**
                        * field for APPAPPAM
                        */

                        
                                    protected java.lang.String localAPPAPPAM ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localAPPAPPAMTracker = false ;

                           public boolean isAPPAPPAMSpecified(){
                               return localAPPAPPAMTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getAPPAPPAM(){
                               return localAPPAPPAM;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param APPAPPAM
                               */
                               public void setAPPAPPAM(java.lang.String param){
                            localAPPAPPAMTracker = param != null;
                                   
                                            this.localAPPAPPAM=param;
                                    

                               }
                            

                        /**
                        * field for JUMJUMCD
                        */

                        
                                    protected java.lang.String localJUMJUMCD ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localJUMJUMCDTracker = false ;

                           public boolean isJUMJUMCDSpecified(){
                               return localJUMJUMCDTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getJUMJUMCD(){
                               return localJUMJUMCD;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param JUMJUMCD
                               */
                               public void setJUMJUMCD(java.lang.String param){
                            localJUMJUMCDTracker = param != null;
                                   
                                            this.localJUMJUMCD=param;
                                    

                               }
                            

                        /**
                        * field for ASTASTGB
                        */

                        
                                    protected java.lang.String localASTASTGB ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localASTASTGBTracker = false ;

                           public boolean isASTASTGBSpecified(){
                               return localASTASTGBTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getASTASTGB(){
                               return localASTASTGB;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ASTASTGB
                               */
                               public void setASTASTGB(java.lang.String param){
                            localASTASTGBTracker = param != null;
                                   
                                            this.localASTASTGB=param;
                                    

                               }
                            

                        /**
                        * field for UNQUNQNO
                        */

                        
                                    protected java.lang.String localUNQUNQNO ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localUNQUNQNOTracker = false ;

                           public boolean isUNQUNQNOSpecified(){
                               return localUNQUNQNOTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getUNQUNQNO(){
                               return localUNQUNQNO;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param UNQUNQNO
                               */
                               public void setUNQUNQNO(java.lang.String param){
                            localUNQUNQNOTracker = param != null;
                                   
                                            this.localUNQUNQNO=param;
                                    

                               }
                            

                        /**
                        * field for ACTACTGB
                        */

                        
                                    protected java.lang.String localACTACTGB ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localACTACTGBTracker = false ;

                           public boolean isACTACTGBSpecified(){
                               return localACTACTGBTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getACTACTGB(){
                               return localACTACTGB;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ACTACTGB
                               */
                               public void setACTACTGB(java.lang.String param){
                            localACTACTGBTracker = param != null;
                                   
                                            this.localACTACTGB=param;
                                    

                               }
                            

                        /**
                        * field for CHGCHGAM
                        */

                        
                                    protected java.lang.String localCHGCHGAM ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localCHGCHGAMTracker = false ;

                           public boolean isCHGCHGAMSpecified(){
                               return localCHGCHGAMTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getCHGCHGAM(){
                               return localCHGCHGAM;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param CHGCHGAM
                               */
                               public void setCHGCHGAM(java.lang.String param){
                            localCHGCHGAMTracker = param != null;
                                   
                                            this.localCHGCHGAM=param;
                                    

                               }
                            

                        /**
                        * field for TRNTRNGB
                        */

                        
                                    protected java.lang.String localTRNTRNGB ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localTRNTRNGBTracker = false ;

                           public boolean isTRNTRNGBSpecified(){
                               return localTRNTRNGBTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getTRNTRNGB(){
                               return localTRNTRNGB;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param TRNTRNGB
                               */
                               public void setTRNTRNGB(java.lang.String param){
                            localTRNTRNGBTracker = param != null;
                                   
                                            this.localTRNTRNGB=param;
                                    

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
                        * field for ETCETCNY
                        */

                        
                                    protected java.lang.String localETCETCNY ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localETCETCNYTracker = false ;

                           public boolean isETCETCNYSpecified(){
                               return localETCETCNYTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getETCETCNY(){
                               return localETCETCNY;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ETCETCNY
                               */
                               public void setETCETCNY(java.lang.String param){
                            localETCETCNYTracker = param != null;
                                   
                                            this.localETCETCNY=param;
                                    

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
                           namespacePrefix+":EPS0017",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "EPS0017",
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
                             } if (localPUMPUMYYTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "PUMPUMYY", xmlWriter);
                             

                                          if (localPUMPUMYY==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("PUMPUMYY cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localPUMPUMYY);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localPUMPUMNOTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "PUMPUMNO", xmlWriter);
                             

                                          if (localPUMPUMNO==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("PUMPUMNO cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localPUMPUMNO);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localAPPAPPNOTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "APPAPPNO", xmlWriter);
                             

                                          if (localAPPAPPNO==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("APPAPPNO cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localAPPAPPNO);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localAPPAPPAMTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "APPAPPAM", xmlWriter);
                             

                                          if (localAPPAPPAM==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("APPAPPAM cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localAPPAPPAM);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localJUMJUMCDTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "JUMJUMCD", xmlWriter);
                             

                                          if (localJUMJUMCD==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("JUMJUMCD cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localJUMJUMCD);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localASTASTGBTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "ASTASTGB", xmlWriter);
                             

                                          if (localASTASTGB==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("ASTASTGB cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localASTASTGB);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localUNQUNQNOTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "UNQUNQNO", xmlWriter);
                             

                                          if (localUNQUNQNO==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("UNQUNQNO cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localUNQUNQNO);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localACTACTGBTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "ACTACTGB", xmlWriter);
                             

                                          if (localACTACTGB==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("ACTACTGB cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localACTACTGB);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localCHGCHGAMTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "CHGCHGAM", xmlWriter);
                             

                                          if (localCHGCHGAM==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("CHGCHGAM cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localCHGCHGAM);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localTRNTRNGBTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "TRNTRNGB", xmlWriter);
                             

                                          if (localTRNTRNGB==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("TRNTRNGB cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localTRNTRNGB);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
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
                             } if (localETCETCNYTracker){
                                    namespace = "http://wpms.woorifg.com/WPMS.WebService";
                                    writeStartElement(null, namespace, "ETCETCNY", xmlWriter);
                             

                                          if (localETCETCNY==null){
                                              // write the nil attribute
                                              
                                                     throw new org.apache.axis2.databinding.ADBException("ETCETCNY cannot be null!!");
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localETCETCNY);
                                            
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
                                    } if (localPUMPUMYYTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "PUMPUMYY"));
                                 
                                        if (localPUMPUMYY != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localPUMPUMYY));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("PUMPUMYY cannot be null!!");
                                        }
                                    } if (localPUMPUMNOTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "PUMPUMNO"));
                                 
                                        if (localPUMPUMNO != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localPUMPUMNO));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("PUMPUMNO cannot be null!!");
                                        }
                                    } if (localAPPAPPNOTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "APPAPPNO"));
                                 
                                        if (localAPPAPPNO != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localAPPAPPNO));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("APPAPPNO cannot be null!!");
                                        }
                                    } if (localAPPAPPAMTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "APPAPPAM"));
                                 
                                        if (localAPPAPPAM != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localAPPAPPAM));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("APPAPPAM cannot be null!!");
                                        }
                                    } if (localJUMJUMCDTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "JUMJUMCD"));
                                 
                                        if (localJUMJUMCD != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localJUMJUMCD));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("JUMJUMCD cannot be null!!");
                                        }
                                    } if (localASTASTGBTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "ASTASTGB"));
                                 
                                        if (localASTASTGB != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localASTASTGB));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("ASTASTGB cannot be null!!");
                                        }
                                    } if (localUNQUNQNOTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "UNQUNQNO"));
                                 
                                        if (localUNQUNQNO != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localUNQUNQNO));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("UNQUNQNO cannot be null!!");
                                        }
                                    } if (localACTACTGBTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "ACTACTGB"));
                                 
                                        if (localACTACTGB != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localACTACTGB));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("ACTACTGB cannot be null!!");
                                        }
                                    } if (localCHGCHGAMTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "CHGCHGAM"));
                                 
                                        if (localCHGCHGAM != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localCHGCHGAM));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("CHGCHGAM cannot be null!!");
                                        }
                                    } if (localTRNTRNGBTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "TRNTRNGB"));
                                 
                                        if (localTRNTRNGB != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localTRNTRNGB));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("TRNTRNGB cannot be null!!");
                                        }
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
                                    } if (localETCETCNYTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "ETCETCNY"));
                                 
                                        if (localETCETCNY != null){
                                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localETCETCNY));
                                        } else {
                                           throw new org.apache.axis2.databinding.ADBException("ETCETCNY cannot be null!!");
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
        public static EPS0017 parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            EPS0017 object =
                new EPS0017();

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
                    
                            if (!"EPS0017".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (EPS0017)ExtensionMapper.getTypeObject(
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
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","PUMPUMYY").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"PUMPUMYY" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setPUMPUMYY(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","PUMPUMNO").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"PUMPUMNO" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setPUMPUMNO(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","APPAPPNO").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"APPAPPNO" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setAPPAPPNO(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","APPAPPAM").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"APPAPPAM" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setAPPAPPAM(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","JUMJUMCD").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"JUMJUMCD" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setJUMJUMCD(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","ASTASTGB").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"ASTASTGB" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setASTASTGB(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","UNQUNQNO").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"UNQUNQNO" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setUNQUNQNO(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","ACTACTGB").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"ACTACTGB" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setACTACTGB(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","CHGCHGAM").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"CHGCHGAM" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setCHGCHGAM(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","TRNTRNGB").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"TRNTRNGB" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setTRNTRNGB(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                              
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
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","ETCETCNY").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"ETCETCNY" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setETCETCNY(
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
    
        public static class EPS0017Response
        implements org.apache.axis2.databinding.ADBBean{
        
                public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService",
                "EPS0017Response",
                "ns1");

            

                        /**
                        * field for EPS0017Result
                        */

                        
                                    protected ArrayOfString localEPS0017Result ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localEPS0017ResultTracker = false ;

                           public boolean isEPS0017ResultSpecified(){
                               return localEPS0017ResultTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return ArrayOfString
                           */
                           public  ArrayOfString getEPS0017Result(){
                               return localEPS0017Result;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param EPS0017Result
                               */
                               public void setEPS0017Result(ArrayOfString param){
                            localEPS0017ResultTracker = param != null;
                                   
                                            this.localEPS0017Result=param;
                                    

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
                           namespacePrefix+":EPS0017Response",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "EPS0017Response",
                           xmlWriter);
                   }

               
                   }
                if (localEPS0017ResultTracker){
                                            if (localEPS0017Result==null){
                                                 throw new org.apache.axis2.databinding.ADBException("EPS0017Result cannot be null!!");
                                            }
                                           localEPS0017Result.serialize(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","EPS0017Result"),
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

                 if (localEPS0017ResultTracker){
                            elementList.add(new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                                                                      "EPS0017Result"));
                            
                            
                                    if (localEPS0017Result==null){
                                         throw new org.apache.axis2.databinding.ADBException("EPS0017Result cannot be null!!");
                                    }
                                    elementList.add(localEPS0017Result);
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
        public static EPS0017Response parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            EPS0017Response object =
                new EPS0017Response();

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
                    
                            if (!"EPS0017Response".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (EPS0017Response)ExtensionMapper.getTypeObject(
                                     nsUri,type,reader);
                              }
                        

                  }
                

                }

                

                
                // Note all attributes that were handled. Used to differ normal attributes
                // from anyAttributes.
                java.util.Vector handledAttributes = new java.util.Vector();
                

                
                    
                    reader.next();
                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService","EPS0017Result").equals(reader.getName())){
                                
                                                object.setEPS0017Result(ArrayOfString.Factory.parse(reader));
                                              
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
           
    
            private  org.apache.axiom.om.OMElement  toOM(com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017 param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017 param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017.MY_QNAME,factory));
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
        
                if (com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017.class.equals(type)){
                
                           return com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response.class.equals(type)){
                
                           return com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
        } catch (java.lang.Exception e) {
        throw org.apache.axis2.AxisFault.makeFault(e);
        }
           return null;
        }



    
   }
   