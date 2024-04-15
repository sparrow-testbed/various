/**
 * EPS_WSStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.3  Built on : Jun 27, 2015 (11:17:49 BST)
 */
package com.woorifg.wpms.wpms_webservice;


/*
 *  EPS_WSStub java implementation
 */
public class EPS_WSStub extends org.apache.axis2.client.Stub {
    private static int counter = 0;
    protected org.apache.axis2.description.AxisOperation[] _operations;

    //hashmaps to keep the fault mapping
    private java.util.HashMap faultExceptionNameMap = new java.util.HashMap();
    private java.util.HashMap faultExceptionClassNameMap = new java.util.HashMap();
    private java.util.HashMap faultMessageMap = new java.util.HashMap();
    private javax.xml.namespace.QName[] opNameArray = null;

    /**
     *Constructor that takes in a configContext
     */
    public EPS_WSStub(
        org.apache.axis2.context.ConfigurationContext configurationContext,
        java.lang.String targetEndpoint) throws org.apache.axis2.AxisFault {
        this(configurationContext, targetEndpoint, false);
    }

    /**
     * Constructor that takes in a configContext  and useseperate listner
     */
    public EPS_WSStub(
        org.apache.axis2.context.ConfigurationContext configurationContext,
        java.lang.String targetEndpoint, boolean useSeparateListener)
        throws org.apache.axis2.AxisFault {
        //To populate AxisService
        populateAxisService();
        populateFaults();

        _serviceClient = new org.apache.axis2.client.ServiceClient(configurationContext,
                _service);

        _serviceClient.getOptions()
                      .setTo(new org.apache.axis2.addressing.EndpointReference(
                targetEndpoint));
        _serviceClient.getOptions().setUseSeparateListener(useSeparateListener);

        //Set the soap version
        _serviceClient.getOptions()
                      .setSoapVersionURI(org.apache.axiom.soap.SOAP12Constants.SOAP_ENVELOPE_NAMESPACE_URI);
    }

    /**
     * Default Constructor
     */
    public EPS_WSStub(
        org.apache.axis2.context.ConfigurationContext configurationContext)
        throws org.apache.axis2.AxisFault {
        this(configurationContext,
            "http://wpms.woorifg.com/WPMS.WebService/EPS_WS.asmx");
    }

    /**
     * Default Constructor
     */
    public EPS_WSStub() throws org.apache.axis2.AxisFault {
        this("http://wpms.woorifg.com/WPMS.WebService/EPS_WS.asmx");
    }

    /**
     * Constructor taking the target endpoint
     */
    public EPS_WSStub(java.lang.String targetEndpoint)
        throws org.apache.axis2.AxisFault {
        this(null, targetEndpoint);
    }

    private static synchronized java.lang.String getUniqueSuffix() {
        // reset the counter if it is greater than 99999
        if (counter > 99999) {
            counter = 0;
        }

        counter = counter + 1;

        return java.lang.Long.toString(java.lang.System.currentTimeMillis()) +
        "_" + counter;
    }

    private void populateAxisService() throws org.apache.axis2.AxisFault {
        //creating the Service with a unique name
        _service = new org.apache.axis2.description.AxisService("EPS_WS" +
                getUniqueSuffix());
        addAnonymousOperations();

        //creating the operations
        org.apache.axis2.description.AxisOperation __operation;

        _operations = new org.apache.axis2.description.AxisOperation[7];

        __operation = new org.apache.axis2.description.OutInAxisOperation();

        __operation.setName(new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService", "ePS0034"));
        _service.addOperation(__operation);

        _operations[0] = __operation;

        __operation = new org.apache.axis2.description.OutInAxisOperation();

        __operation.setName(new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService", "ePS0019"));
        _service.addOperation(__operation);

        _operations[1] = __operation;

        __operation = new org.apache.axis2.description.OutInAxisOperation();

        __operation.setName(new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService", "ePS0019_1"));
        _service.addOperation(__operation);

        _operations[2] = __operation;

        __operation = new org.apache.axis2.description.OutInAxisOperation();

        __operation.setName(new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService", "ePS0037"));
        _service.addOperation(__operation);

        _operations[3] = __operation;

        __operation = new org.apache.axis2.description.OutInAxisOperation();

        __operation.setName(new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService", "ePS0024"));
        _service.addOperation(__operation);

        _operations[4] = __operation;

        __operation = new org.apache.axis2.description.OutInAxisOperation();

        __operation.setName(new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService", "ePS0021"));
        _service.addOperation(__operation);

        _operations[5] = __operation;

        __operation = new org.apache.axis2.description.OutInAxisOperation();

        __operation.setName(new javax.xml.namespace.QName(
                "http://wpms.woorifg.com/WPMS.WebService", "ePS0020"));
        _service.addOperation(__operation);

        _operations[6] = __operation;
    }

    //populates the faults
    private void populateFaults() {
    }

    /**
     * Auto generated method signature
     * &lt;br&gt;&lt;b&gt;?�산?�재(진행,?�료) ?��? - ?�산?�규&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;C ?�산?�재(진행,?�료) ?��?조회 , R ?�산?�재취소(진행,?�료) ?��?조회&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSBMSYY&lt;/td&gt;&lt;td&gt;?�산?�도&lt;/td&gt;&lt;td&gt;string / (고정??4&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;br&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSSRLNO&lt;/td&gt;&lt;td&gt;?�산?�련번호&lt;/td&gt;&lt;td&gt;string / (고정??5&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPNO&lt;/td&gt;&lt;td&gt;?�인번호&lt;/td&gt;&lt;td&gt;string / (고정??3&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�용?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�패&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공??'' , ?�패???�용???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�공??'' , ?�패???�스???�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#ePS0034
     * @param ePS00340
     */
    public com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response ePS0034(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034 ePS00340)
        throws java.rmi.RemoteException {
        org.apache.axis2.context.MessageContext _messageContext = null;

        try {
            org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[0].getName());
            _operationClient.getOptions()
                            .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0034");
            _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

            addPropertyToOperationClient(_operationClient,
                org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
                "&");

            // create a message context
            _messageContext = new org.apache.axis2.context.MessageContext();

            // create SOAP envelope with that payload
            org.apache.axiom.soap.SOAPEnvelope env = null;

            env = toEnvelope(getFactory(_operationClient.getOptions()
                                                        .getSoapVersionURI()),
                    ePS00340,
                    optimizeContent(
                        new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService", "ePS0034")),
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0034"));

            //adding SOAP soap_headers
            _serviceClient.addHeadersToEnvelope(env);
            // set the message context with that soap envelope
            _messageContext.setEnvelope(env);

            // add the message contxt to the operation client
            _operationClient.addMessageContext(_messageContext);

            //execute the operation client
            _operationClient.execute(true);

            org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
            org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();

            java.lang.Object object = fromOM(_returnEnv.getBody()
                                                       .getFirstElement(),
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response.class,
                    getEnvelopeNamespaces(_returnEnv));

            return (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response) object;
        } catch (org.apache.axis2.AxisFault f) {
            org.apache.axiom.om.OMElement faultElt = f.getDetail();

            if (faultElt != null) {
                if (faultExceptionNameMap.containsKey(
                            new org.apache.axis2.client.FaultMapKey(
                                faultElt.getQName(), "EPS0034"))) {
                    //make the fault by reflection
                    try {
                        java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0034"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                        //message class
                        java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0034"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,
                                messageClass, null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                new java.lang.Class[] { messageClass });
                        m.invoke(ex, new java.lang.Object[] { messageObject });

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    } catch (java.lang.ClassCastException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                } else {
                    throw f;
                }
            } else {
                throw f;
            }
        } finally {
            if (_messageContext.getTransportOut() != null) {
                _messageContext.getTransportOut().getSender()
                               .cleanup(_messageContext);
            }
        }
    }

    /**
     * Auto generated method signature for Asynchronous Invocations
     * &lt;br&gt;&lt;b&gt;?�산?�재(진행,?�료) ?��? - ?�산?�규&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;C ?�산?�재(진행,?�료) ?��?조회 , R ?�산?�재취소(진행,?�료) ?��?조회&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSBMSYY&lt;/td&gt;&lt;td&gt;?�산?�도&lt;/td&gt;&lt;td&gt;string / (고정??4&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;br&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSSRLNO&lt;/td&gt;&lt;td&gt;?�산?�련번호&lt;/td&gt;&lt;td&gt;string / (고정??5&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPNO&lt;/td&gt;&lt;td&gt;?�인번호&lt;/td&gt;&lt;td&gt;string / (고정??3&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�용?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�패&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공??'' , ?�패???�용???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�공??'' , ?�패???�스???�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#startePS0034
     * @param ePS00340
     */
    public void startePS0034(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034 ePS00340,
        final com.woorifg.wpms.wpms_webservice.EPS_WSCallbackHandler callback)
        throws java.rmi.RemoteException {
        org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[0].getName());
        _operationClient.getOptions()
                        .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0034");
        _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

        addPropertyToOperationClient(_operationClient,
            org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
            "&");

        // create SOAP envelope with that payload
        org.apache.axiom.soap.SOAPEnvelope env = null;
        final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

        //Style is Doc.
        env = toEnvelope(getFactory(_operationClient.getOptions()
                                                    .getSoapVersionURI()),
                ePS00340,
                optimizeContent(
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0034")),
                new javax.xml.namespace.QName(
                    "http://wpms.woorifg.com/WPMS.WebService", "ePS0034"));

        // adding SOAP soap_headers
        _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);

        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                public void onMessage(
                    org.apache.axis2.context.MessageContext resultContext) {
                    try {
                        org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();

                        java.lang.Object object = fromOM(resultEnv.getBody()
                                                                  .getFirstElement(),
                                com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response.class,
                                getEnvelopeNamespaces(resultEnv));
                        callback.receiveResultePS0034((com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response) object);
                    } catch (org.apache.axis2.AxisFault e) {
                        callback.receiveErrorePS0034(e);
                    }
                }

                public void onError(java.lang.Exception error) {
                    if (error instanceof org.apache.axis2.AxisFault) {
                        org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
                        org.apache.axiom.om.OMElement faultElt = f.getDetail();

                        if (faultElt != null) {
                            if (faultExceptionNameMap.containsKey(
                                        new org.apache.axis2.client.FaultMapKey(
                                            faultElt.getQName(), "EPS0034"))) {
                                //make the fault by reflection
                                try {
                                    java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0034"));
                                    java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                    java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                                    //message class
                                    java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0034"));
                                    java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                    java.lang.Object messageObject = fromOM(faultElt,
                                            messageClass, null);
                                    java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                            new java.lang.Class[] { messageClass });
                                    m.invoke(ex,
                                        new java.lang.Object[] { messageObject });

                                    callback.receiveErrorePS0034(new java.rmi.RemoteException(
                                            ex.getMessage(), ex));
                                } catch (java.lang.ClassCastException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0034(f);
                                } catch (java.lang.ClassNotFoundException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0034(f);
                                } catch (java.lang.NoSuchMethodException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0034(f);
                                } catch (java.lang.reflect.InvocationTargetException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0034(f);
                                } catch (java.lang.IllegalAccessException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0034(f);
                                } catch (java.lang.InstantiationException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0034(f);
                                } catch (org.apache.axis2.AxisFault e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0034(f);
                                }
                            } else {
                                callback.receiveErrorePS0034(f);
                            }
                        } else {
                            callback.receiveErrorePS0034(f);
                        }
                    } else {
                        callback.receiveErrorePS0034(error);
                    }
                }

                public void onFault(
                    org.apache.axis2.context.MessageContext faultContext) {
                    org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                    onError(fault);
                }

                public void onComplete() {
                    try {
                        _messageContext.getTransportOut().getSender()
                                       .cleanup(_messageContext);
                    } catch (org.apache.axis2.AxisFault axisFault) {
                        callback.receiveErrorePS0034(axisFault);
                    }
                }
            });

        org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;

        if ((_operations[0].getMessageReceiver() == null) &&
                _operationClient.getOptions().isUseSeparateListener()) {
            _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
            _operations[0].setMessageReceiver(_callbackReceiver);
        }

        //execute the operation client
        _operationClient.execute(false);
    }

    /**
     * Auto generated method signature
     * &lt;br&gt;&lt;b&gt;?�산 ?�의?�보 반환&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S ?�산 ?�의금액 반환&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BNKBNKCD&lt;/td&gt;&lt;td&gt;??��코드&lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;20 ?�리??��&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSBMSYY&lt;/td&gt;&lt;td&gt;?�산?�도&lt;/td&gt;&lt;td&gt;string / (고정??4&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;br&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SOGSOGCD&lt;/td&gt;&lt;td&gt;?��?�?��&lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;20325 : IT�?���?, 20644 : 총무�?lt;br&gt;20690 : ?�보?? 20700 : ?�리?�프?�이?�스&lt;br&gt; 20707 : �?���?, 20717 : ?�화?�금??lt;br&gt;20998 : ?�환본�?&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ASTASTGB&lt;/td&gt;&lt;td&gt;?�산구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;1:?�무?�토�?, 2:?�무?�건�?lt;br&gt;3:?�차보즘�?, 4:?�산기구&lt;br&gt;5:?�산집기 , 6:차량&lt;br&gt;7:간판 , 8:무형고정?�산 , 9:기�??�산&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MNGMNGNO&lt;/td&gt;&lt;td&gt;�?��구분&lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;?�터?�이???�의??참조&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BSSBSSNO&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??3&lt;/td&gt;&lt;td&gt;?�터?�이???�의??참조&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMDT&lt;/td&gt;&lt;td&gt;?�의?�자&lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMAM&lt;/td&gt;&lt;td&gt;?�의금액&lt;/td&gt;&lt;td&gt;string / (�????15&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ETCETCNY&lt;/td&gt;&lt;td&gt;?�요         &lt;/td&gt;&lt;td&gt;string / (�????200&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�용?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;?�터?�이?�번??lt;/td&gt;&lt;td&gt;string / (�????15&lt;/td&gt;&lt;td&gt;?�자구매?�서 ?�성???�터?�이?�번??lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[6]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�패&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공???�의?�도(BMSBMSYY,4?�리) , ?�패???�용???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�공???�의번호(BMSSRLNO,5?�리) , ?�패???�스???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - ?�공???�의?�인번호(APPAPPNO,3?�리)&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[4] - ?�공???�의?�인금액&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[5] - ?�산�?��?�서 ?�성???�터?�이?�번??lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#ePS0019
     * @param ePS00192
     */
    public com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response ePS0019(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019 ePS00192)
        throws java.rmi.RemoteException {
        org.apache.axis2.context.MessageContext _messageContext = null;

        try {
            org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[1].getName());
            _operationClient.getOptions()
                            .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0019");
            _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

            addPropertyToOperationClient(_operationClient,
                org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
                "&");

            // create a message context
            _messageContext = new org.apache.axis2.context.MessageContext();

            // create SOAP envelope with that payload
            org.apache.axiom.soap.SOAPEnvelope env = null;

            env = toEnvelope(getFactory(_operationClient.getOptions()
                                                        .getSoapVersionURI()),
                    ePS00192,
                    optimizeContent(
                        new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService", "ePS0019")),
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0019"));

            //adding SOAP soap_headers
            _serviceClient.addHeadersToEnvelope(env);
            // set the message context with that soap envelope
            _messageContext.setEnvelope(env);

            // add the message contxt to the operation client
            _operationClient.addMessageContext(_messageContext);

            //execute the operation client
            _operationClient.execute(true);

            org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
            org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();

            java.lang.Object object = fromOM(_returnEnv.getBody()
                                                       .getFirstElement(),
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response.class,
                    getEnvelopeNamespaces(_returnEnv));

            return (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response) object;
        } catch (org.apache.axis2.AxisFault f) {
            org.apache.axiom.om.OMElement faultElt = f.getDetail();

            if (faultElt != null) {
                if (faultExceptionNameMap.containsKey(
                            new org.apache.axis2.client.FaultMapKey(
                                faultElt.getQName(), "EPS0019"))) {
                    //make the fault by reflection
                    try {
                        java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0019"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                        //message class
                        java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0019"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,
                                messageClass, null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                new java.lang.Class[] { messageClass });
                        m.invoke(ex, new java.lang.Object[] { messageObject });

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    } catch (java.lang.ClassCastException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                } else {
                    throw f;
                }
            } else {
                throw f;
            }
        } finally {
            if (_messageContext.getTransportOut() != null) {
                _messageContext.getTransportOut().getSender()
                               .cleanup(_messageContext);
            }
        }
    }

    /**
     * Auto generated method signature for Asynchronous Invocations
     * &lt;br&gt;&lt;b&gt;?�산 ?�의?�보 반환&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S ?�산 ?�의금액 반환&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BNKBNKCD&lt;/td&gt;&lt;td&gt;??��코드&lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;20 ?�리??��&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSBMSYY&lt;/td&gt;&lt;td&gt;?�산?�도&lt;/td&gt;&lt;td&gt;string / (고정??4&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;br&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SOGSOGCD&lt;/td&gt;&lt;td&gt;?��?�?��&lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;20325 : IT�?���?, 20644 : 총무�?lt;br&gt;20690 : ?�보?? 20700 : ?�리?�프?�이?�스&lt;br&gt; 20707 : �?���?, 20717 : ?�화?�금??lt;br&gt;20998 : ?�환본�?&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ASTASTGB&lt;/td&gt;&lt;td&gt;?�산구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;1:?�무?�토�?, 2:?�무?�건�?lt;br&gt;3:?�차보즘�?, 4:?�산기구&lt;br&gt;5:?�산집기 , 6:차량&lt;br&gt;7:간판 , 8:무형고정?�산 , 9:기�??�산&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MNGMNGNO&lt;/td&gt;&lt;td&gt;�?��구분&lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;?�터?�이???�의??참조&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BSSBSSNO&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??3&lt;/td&gt;&lt;td&gt;?�터?�이???�의??참조&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMDT&lt;/td&gt;&lt;td&gt;?�의?�자&lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PUMPUMAM&lt;/td&gt;&lt;td&gt;?�의금액&lt;/td&gt;&lt;td&gt;string / (�????15&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ETCETCNY&lt;/td&gt;&lt;td&gt;?�요         &lt;/td&gt;&lt;td&gt;string / (�????200&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�용?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;?�터?�이?�번??lt;/td&gt;&lt;td&gt;string / (�????15&lt;/td&gt;&lt;td&gt;?�자구매?�서 ?�성???�터?�이?�번??lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[6]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�패&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공???�의?�도(BMSBMSYY,4?�리) , ?�패???�용???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�공???�의번호(BMSSRLNO,5?�리) , ?�패???�스???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - ?�공???�의?�인번호(APPAPPNO,3?�리)&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[4] - ?�공???�의?�인금액&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[5] - ?�산�?��?�서 ?�성???�터?�이?�번??lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#startePS0019
     * @param ePS00192
     */
    public void startePS0019(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019 ePS00192,
        final com.woorifg.wpms.wpms_webservice.EPS_WSCallbackHandler callback)
        throws java.rmi.RemoteException {
        org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[1].getName());
        _operationClient.getOptions()
                        .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0019");
        _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

        addPropertyToOperationClient(_operationClient,
            org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
            "&");

        // create SOAP envelope with that payload
        org.apache.axiom.soap.SOAPEnvelope env = null;
        final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

        //Style is Doc.
        env = toEnvelope(getFactory(_operationClient.getOptions()
                                                    .getSoapVersionURI()),
                ePS00192,
                optimizeContent(
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0019")),
                new javax.xml.namespace.QName(
                    "http://wpms.woorifg.com/WPMS.WebService", "ePS0019"));

        // adding SOAP soap_headers
        _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);

        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                public void onMessage(
                    org.apache.axis2.context.MessageContext resultContext) {
                    try {
                        org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();

                        java.lang.Object object = fromOM(resultEnv.getBody()
                                                                  .getFirstElement(),
                                com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response.class,
                                getEnvelopeNamespaces(resultEnv));
                        callback.receiveResultePS0019((com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response) object);
                    } catch (org.apache.axis2.AxisFault e) {
                        callback.receiveErrorePS0019(e);
                    }
                }

                public void onError(java.lang.Exception error) {
                    if (error instanceof org.apache.axis2.AxisFault) {
                        org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
                        org.apache.axiom.om.OMElement faultElt = f.getDetail();

                        if (faultElt != null) {
                            if (faultExceptionNameMap.containsKey(
                                        new org.apache.axis2.client.FaultMapKey(
                                            faultElt.getQName(), "EPS0019"))) {
                                //make the fault by reflection
                                try {
                                    java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0019"));
                                    java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                    java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                                    //message class
                                    java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0019"));
                                    java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                    java.lang.Object messageObject = fromOM(faultElt,
                                            messageClass, null);
                                    java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                            new java.lang.Class[] { messageClass });
                                    m.invoke(ex,
                                        new java.lang.Object[] { messageObject });

                                    callback.receiveErrorePS0019(new java.rmi.RemoteException(
                                            ex.getMessage(), ex));
                                } catch (java.lang.ClassCastException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019(f);
                                } catch (java.lang.ClassNotFoundException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019(f);
                                } catch (java.lang.NoSuchMethodException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019(f);
                                } catch (java.lang.reflect.InvocationTargetException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019(f);
                                } catch (java.lang.IllegalAccessException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019(f);
                                } catch (java.lang.InstantiationException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019(f);
                                } catch (org.apache.axis2.AxisFault e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019(f);
                                }
                            } else {
                                callback.receiveErrorePS0019(f);
                            }
                        } else {
                            callback.receiveErrorePS0019(f);
                        }
                    } else {
                        callback.receiveErrorePS0019(error);
                    }
                }

                public void onFault(
                    org.apache.axis2.context.MessageContext faultContext) {
                    org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                    onError(fault);
                }

                public void onComplete() {
                    try {
                        _messageContext.getTransportOut().getSender()
                                       .cleanup(_messageContext);
                    } catch (org.apache.axis2.AxisFault axisFault) {
                        callback.receiveErrorePS0019(axisFault);
                    }
                }
            });

        org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;

        if ((_operations[1].getMessageReceiver() == null) &&
                _operationClient.getOptions().isUseSeparateListener()) {
            _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
            _operations[1].setMessageReceiver(_callbackReceiver);
        }

        //execute the operation client
        _operationClient.execute(false);
    }

    /**
     * Auto generated method signature
     * &lt;br&gt;&lt;b&gt;?�산 ?�의?�보 ??��&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;D ?�산 ?�의?�보 ??��&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSBMSYY&lt;/td&gt;&lt;td&gt;?�산?�도&lt;/td&gt;&lt;td&gt;string / (고정??4&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;br&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSSRLNO&lt;/td&gt;&lt;td&gt;?�산?�련번호&lt;/td&gt;&lt;td&gt;string / (고정??5&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPNO&lt;/td&gt;&lt;td&gt;?�인번호&lt;/td&gt;&lt;td&gt;string / (고정??3&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�용?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;?�터?�이?�번??lt;/td&gt;&lt;td&gt;string / (�????15&lt;/td&gt;&lt;td&gt;?�자구매?�서 ?�성???�터?�이?�번??lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[4]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�패&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공??'' , ?�패???�용???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�공??'' , ?�패???�스???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - ?�산�?��?�서 ?�성???�터?�이?�번??lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#ePS0019_1
     * @param ePS0019_14
     */
    public com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response ePS0019_1(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1 ePS0019_14)
        throws java.rmi.RemoteException {
        org.apache.axis2.context.MessageContext _messageContext = null;

        try {
            org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[2].getName());
            _operationClient.getOptions()
                            .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0019_1");
            _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

            addPropertyToOperationClient(_operationClient,
                org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
                "&");

            // create a message context
            _messageContext = new org.apache.axis2.context.MessageContext();

            // create SOAP envelope with that payload
            org.apache.axiom.soap.SOAPEnvelope env = null;

            env = toEnvelope(getFactory(_operationClient.getOptions()
                                                        .getSoapVersionURI()),
                    ePS0019_14,
                    optimizeContent(
                        new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService",
                            "ePS0019_1")),
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0019_1"));

            //adding SOAP soap_headers
            _serviceClient.addHeadersToEnvelope(env);
            // set the message context with that soap envelope
            _messageContext.setEnvelope(env);

            // add the message contxt to the operation client
            _operationClient.addMessageContext(_messageContext);

            //execute the operation client
            _operationClient.execute(true);

            org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
            org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();

            java.lang.Object object = fromOM(_returnEnv.getBody()
                                                       .getFirstElement(),
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response.class,
                    getEnvelopeNamespaces(_returnEnv));

            return (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response) object;
        } catch (org.apache.axis2.AxisFault f) {
            org.apache.axiom.om.OMElement faultElt = f.getDetail();

            if (faultElt != null) {
                if (faultExceptionNameMap.containsKey(
                            new org.apache.axis2.client.FaultMapKey(
                                faultElt.getQName(), "EPS0019_1"))) {
                    //make the fault by reflection
                    try {
                        java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0019_1"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                        //message class
                        java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0019_1"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,
                                messageClass, null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                new java.lang.Class[] { messageClass });
                        m.invoke(ex, new java.lang.Object[] { messageObject });

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    } catch (java.lang.ClassCastException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                } else {
                    throw f;
                }
            } else {
                throw f;
            }
        } finally {
            if (_messageContext.getTransportOut() != null) {
                _messageContext.getTransportOut().getSender()
                               .cleanup(_messageContext);
            }
        }
    }

    /**
     * Auto generated method signature for Asynchronous Invocations
     * &lt;br&gt;&lt;b&gt;?�산 ?�의?�보 ??��&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;D ?�산 ?�의?�보 ??��&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSBMSYY&lt;/td&gt;&lt;td&gt;?�산?�도&lt;/td&gt;&lt;td&gt;string / (고정??4&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;br&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;BMSSRLNO&lt;/td&gt;&lt;td&gt;?�산?�련번호&lt;/td&gt;&lt;td&gt;string / (고정??5&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;APPAPPNO&lt;/td&gt;&lt;td&gt;?�인번호&lt;/td&gt;&lt;td&gt;string / (고정??3&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�용?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;INF_REF_NO&lt;/td&gt;&lt;td&gt;?�터?�이?�번??lt;/td&gt;&lt;td&gt;string / (�????15&lt;/td&gt;&lt;td&gt;?�자구매?�서 ?�성???�터?�이?�번??lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[4]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�패&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공??'' , ?�패???�용???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�공??'' , ?�패???�스???�류메세�?lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[3] - ?�산�?��?�서 ?�성???�터?�이?�번??lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#startePS0019_1
     * @param ePS0019_14
     */
    public void startePS0019_1(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1 ePS0019_14,
        final com.woorifg.wpms.wpms_webservice.EPS_WSCallbackHandler callback)
        throws java.rmi.RemoteException {
        org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[2].getName());
        _operationClient.getOptions()
                        .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0019_1");
        _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

        addPropertyToOperationClient(_operationClient,
            org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
            "&");

        // create SOAP envelope with that payload
        org.apache.axiom.soap.SOAPEnvelope env = null;
        final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

        //Style is Doc.
        env = toEnvelope(getFactory(_operationClient.getOptions()
                                                    .getSoapVersionURI()),
                ePS0019_14,
                optimizeContent(
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0019_1")),
                new javax.xml.namespace.QName(
                    "http://wpms.woorifg.com/WPMS.WebService", "ePS0019_1"));

        // adding SOAP soap_headers
        _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);

        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                public void onMessage(
                    org.apache.axis2.context.MessageContext resultContext) {
                    try {
                        org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();

                        java.lang.Object object = fromOM(resultEnv.getBody()
                                                                  .getFirstElement(),
                                com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response.class,
                                getEnvelopeNamespaces(resultEnv));
                        callback.receiveResultePS0019_1((com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response) object);
                    } catch (org.apache.axis2.AxisFault e) {
                        callback.receiveErrorePS0019_1(e);
                    }
                }

                public void onError(java.lang.Exception error) {
                    if (error instanceof org.apache.axis2.AxisFault) {
                        org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
                        org.apache.axiom.om.OMElement faultElt = f.getDetail();

                        if (faultElt != null) {
                            if (faultExceptionNameMap.containsKey(
                                        new org.apache.axis2.client.FaultMapKey(
                                            faultElt.getQName(), "EPS0019_1"))) {
                                //make the fault by reflection
                                try {
                                    java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0019_1"));
                                    java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                    java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                                    //message class
                                    java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0019_1"));
                                    java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                    java.lang.Object messageObject = fromOM(faultElt,
                                            messageClass, null);
                                    java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                            new java.lang.Class[] { messageClass });
                                    m.invoke(ex,
                                        new java.lang.Object[] { messageObject });

                                    callback.receiveErrorePS0019_1(new java.rmi.RemoteException(
                                            ex.getMessage(), ex));
                                } catch (java.lang.ClassCastException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019_1(f);
                                } catch (java.lang.ClassNotFoundException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019_1(f);
                                } catch (java.lang.NoSuchMethodException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019_1(f);
                                } catch (java.lang.reflect.InvocationTargetException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019_1(f);
                                } catch (java.lang.IllegalAccessException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019_1(f);
                                } catch (java.lang.InstantiationException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019_1(f);
                                } catch (org.apache.axis2.AxisFault e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0019_1(f);
                                }
                            } else {
                                callback.receiveErrorePS0019_1(f);
                            }
                        } else {
                            callback.receiveErrorePS0019_1(f);
                        }
                    } else {
                        callback.receiveErrorePS0019_1(error);
                    }
                }

                public void onFault(
                    org.apache.axis2.context.MessageContext faultContext) {
                    org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                    onError(fault);
                }

                public void onComplete() {
                    try {
                        _messageContext.getTransportOut().getSender()
                                       .cleanup(_messageContext);
                    } catch (org.apache.axis2.AxisFault axisFault) {
                        callback.receiveErrorePS0019_1(axisFault);
                    }
                }
            });

        org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;

        if ((_operations[2].getMessageReceiver() == null) &&
                _operationClient.getOptions().isUseSeparateListener()) {
            _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
            _operations[2].setMessageReceiver(_callbackReceiver);
        }

        //execute the operation client
        _operationClient.execute(false);
    }

    /**
     * Auto generated method signature
     * &lt;br&gt;&lt;b&gt;집행?�소??��조회&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;I 집행??��?�소 조회(?�력기�?),O 집행??��?�소 조회(출력기�?) &lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;?�속?�코??lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공?? 집행??��?�소 - 목록( ?�코?�구분자 = !| , 컬럼구분??= @| ) &lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;CODE(집행??��?�소코드) , TEXT1(�?��?�명�? , TEXT2(집행??��?�소 ?�세�? , JUMJUMCD(?�속?�코?? , TEXT4(�?��?�자?�구�?) , TEXT5(�?��?�자?�구�?) , STSSTSCD(?�태코드)&lt;br&gt;&lt;br&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#ePS0037
     * @param ePS00376
     */
    public com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response ePS0037(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037 ePS00376)
        throws java.rmi.RemoteException {
        org.apache.axis2.context.MessageContext _messageContext = null;

        try {
            org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[3].getName());
            _operationClient.getOptions()
                            .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0037");
            _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

            addPropertyToOperationClient(_operationClient,
                org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
                "&");

            // create a message context
            _messageContext = new org.apache.axis2.context.MessageContext();

            // create SOAP envelope with that payload
            org.apache.axiom.soap.SOAPEnvelope env = null;

            env = toEnvelope(getFactory(_operationClient.getOptions()
                                                        .getSoapVersionURI()),
                    ePS00376,
                    optimizeContent(
                        new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService", "ePS0037")),
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0037"));

            //adding SOAP soap_headers
            _serviceClient.addHeadersToEnvelope(env);
            // set the message context with that soap envelope
            _messageContext.setEnvelope(env);

            // add the message contxt to the operation client
            _operationClient.addMessageContext(_messageContext);

            //execute the operation client
            _operationClient.execute(true);

            org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
            org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();

            java.lang.Object object = fromOM(_returnEnv.getBody()
                                                       .getFirstElement(),
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response.class,
                    getEnvelopeNamespaces(_returnEnv));

            return (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response) object;
        } catch (org.apache.axis2.AxisFault f) {
            org.apache.axiom.om.OMElement faultElt = f.getDetail();

            if (faultElt != null) {
                if (faultExceptionNameMap.containsKey(
                            new org.apache.axis2.client.FaultMapKey(
                                faultElt.getQName(), "EPS0037"))) {
                    //make the fault by reflection
                    try {
                        java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0037"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                        //message class
                        java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0037"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,
                                messageClass, null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                new java.lang.Class[] { messageClass });
                        m.invoke(ex, new java.lang.Object[] { messageObject });

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    } catch (java.lang.ClassCastException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                } else {
                    throw f;
                }
            } else {
                throw f;
            }
        } finally {
            if (_messageContext.getTransportOut() != null) {
                _messageContext.getTransportOut().getSender()
                               .cleanup(_messageContext);
            }
        }
    }

    /**
     * Auto generated method signature for Asynchronous Invocations
     * &lt;br&gt;&lt;b&gt;집행?�소??��조회&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;I 집행??��?�소 조회(?�력기�?),O 집행??��?�소 조회(출력기�?) &lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;?�속?�코??lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공?? 집행??��?�소 - 목록( ?�코?�구분자 = !| , 컬럼구분??= @| ) &lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;CODE(집행??��?�소코드) , TEXT1(�?��?�명�? , TEXT2(집행??��?�소 ?�세�? , JUMJUMCD(?�속?�코?? , TEXT4(�?��?�자?�구�?) , TEXT5(�?��?�자?�구�?) , STSSTSCD(?�태코드)&lt;br&gt;&lt;br&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#startePS0037
     * @param ePS00376
     */
    public void startePS0037(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037 ePS00376,
        final com.woorifg.wpms.wpms_webservice.EPS_WSCallbackHandler callback)
        throws java.rmi.RemoteException {
        org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[3].getName());
        _operationClient.getOptions()
                        .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0037");
        _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

        addPropertyToOperationClient(_operationClient,
            org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
            "&");

        // create SOAP envelope with that payload
        org.apache.axiom.soap.SOAPEnvelope env = null;
        final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

        //Style is Doc.
        env = toEnvelope(getFactory(_operationClient.getOptions()
                                                    .getSoapVersionURI()),
                ePS00376,
                optimizeContent(
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0037")),
                new javax.xml.namespace.QName(
                    "http://wpms.woorifg.com/WPMS.WebService", "ePS0037"));

        // adding SOAP soap_headers
        _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);

        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                public void onMessage(
                    org.apache.axis2.context.MessageContext resultContext) {
                    try {
                        org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();

                        java.lang.Object object = fromOM(resultEnv.getBody()
                                                                  .getFirstElement(),
                                com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response.class,
                                getEnvelopeNamespaces(resultEnv));
                        callback.receiveResultePS0037((com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response) object);
                    } catch (org.apache.axis2.AxisFault e) {
                        callback.receiveErrorePS0037(e);
                    }
                }

                public void onError(java.lang.Exception error) {
                    if (error instanceof org.apache.axis2.AxisFault) {
                        org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
                        org.apache.axiom.om.OMElement faultElt = f.getDetail();

                        if (faultElt != null) {
                            if (faultExceptionNameMap.containsKey(
                                        new org.apache.axis2.client.FaultMapKey(
                                            faultElt.getQName(), "EPS0037"))) {
                                //make the fault by reflection
                                try {
                                    java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0037"));
                                    java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                    java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                                    //message class
                                    java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0037"));
                                    java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                    java.lang.Object messageObject = fromOM(faultElt,
                                            messageClass, null);
                                    java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                            new java.lang.Class[] { messageClass });
                                    m.invoke(ex,
                                        new java.lang.Object[] { messageObject });

                                    callback.receiveErrorePS0037(new java.rmi.RemoteException(
                                            ex.getMessage(), ex));
                                } catch (java.lang.ClassCastException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0037(f);
                                } catch (java.lang.ClassNotFoundException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0037(f);
                                } catch (java.lang.NoSuchMethodException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0037(f);
                                } catch (java.lang.reflect.InvocationTargetException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0037(f);
                                } catch (java.lang.IllegalAccessException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0037(f);
                                } catch (java.lang.InstantiationException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0037(f);
                                } catch (org.apache.axis2.AxisFault e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0037(f);
                                }
                            } else {
                                callback.receiveErrorePS0037(f);
                            }
                        } else {
                            callback.receiveErrorePS0037(f);
                        }
                    } else {
                        callback.receiveErrorePS0037(error);
                    }
                }

                public void onFault(
                    org.apache.axis2.context.MessageContext faultContext) {
                    org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                    onError(fault);
                }

                public void onComplete() {
                    try {
                        _messageContext.getTransportOut().getSender()
                                       .cleanup(_messageContext);
                    } catch (org.apache.axis2.AxisFault axisFault) {
                        callback.receiveErrorePS0037(axisFault);
                    }
                }
            });

        org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;

        if ((_operations[3].getMessageReceiver() == null) &&
                _operationClient.getOptions().isUseSeparateListener()) {
            _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
            _operations[3].setMessageReceiver(_callbackReceiver);
        }

        //execute the operation client
        _operationClient.execute(false);
    }

    /**
     * Auto generated method signature
     * &lt;br&gt;&lt;b&gt;?�산?�산번호 목록조회&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S ?�산?�산번호 목록조회&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;?�속?�코??lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PMKPMKCD&lt;/td&gt;&lt;td&gt;?�목코드&lt;/td&gt;&lt;td&gt;string / (고정??6&lt;/td&gt;&lt;td&gt;?�목코드,?�목�??�중???�나 ?�수&lt;/td&gt;&lt;td&gt;?�택?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PMKPMKNY&lt;/td&gt;&lt;td&gt;?�목�?lt;/td&gt;&lt;td&gt;string / (�????60&lt;/td&gt;&lt;td&gt;?�목코드,?�목�??�중???�나 ?�수&lt;/td&gt;&lt;td&gt;?�택?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공?? �?��?�번??- 목록( ?�코?�구분자 = !| , 컬럼구분??= @| ) &lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;DOSUNQNO(고유번호) , PMKPMKCD(?�목코드) , PMKPMKNM(?�목�? , JUMJUMCD(?�코?? , GEGETDT(취득?�자) , JABJABAM(취득금액) , JANJONAM(?�존�?��)&lt;/b&gt;&lt;br&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#ePS0024
     * @param ePS00248
     */
    public com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response ePS0024(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024 ePS00248)
        throws java.rmi.RemoteException {
        org.apache.axis2.context.MessageContext _messageContext = null;

        try {
            org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[4].getName());
            _operationClient.getOptions()
                            .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0024");
            _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

            addPropertyToOperationClient(_operationClient,
                org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
                "&");

            // create a message context
            _messageContext = new org.apache.axis2.context.MessageContext();

            // create SOAP envelope with that payload
            org.apache.axiom.soap.SOAPEnvelope env = null;

            env = toEnvelope(getFactory(_operationClient.getOptions()
                                                        .getSoapVersionURI()),
                    ePS00248,
                    optimizeContent(
                        new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService", "ePS0024")),
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0024"));

            //adding SOAP soap_headers
            _serviceClient.addHeadersToEnvelope(env);
            // set the message context with that soap envelope
            _messageContext.setEnvelope(env);

            // add the message contxt to the operation client
            _operationClient.addMessageContext(_messageContext);

            //execute the operation client
            _operationClient.execute(true);

            org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
            org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();

            java.lang.Object object = fromOM(_returnEnv.getBody()
                                                       .getFirstElement(),
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response.class,
                    getEnvelopeNamespaces(_returnEnv));

            return (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response) object;
        } catch (org.apache.axis2.AxisFault f) {
            org.apache.axiom.om.OMElement faultElt = f.getDetail();

            if (faultElt != null) {
                if (faultExceptionNameMap.containsKey(
                            new org.apache.axis2.client.FaultMapKey(
                                faultElt.getQName(), "EPS0024"))) {
                    //make the fault by reflection
                    try {
                        java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0024"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                        //message class
                        java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0024"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,
                                messageClass, null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                new java.lang.Class[] { messageClass });
                        m.invoke(ex, new java.lang.Object[] { messageObject });

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    } catch (java.lang.ClassCastException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                } else {
                    throw f;
                }
            } else {
                throw f;
            }
        } finally {
            if (_messageContext.getTransportOut() != null) {
                _messageContext.getTransportOut().getSender()
                               .cleanup(_messageContext);
            }
        }
    }

    /**
     * Auto generated method signature for Asynchronous Invocations
     * &lt;br&gt;&lt;b&gt;?�산?�산번호 목록조회&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S ?�산?�산번호 목록조회&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;?�속?�코??lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PMKPMKCD&lt;/td&gt;&lt;td&gt;?�목코드&lt;/td&gt;&lt;td&gt;string / (고정??6&lt;/td&gt;&lt;td&gt;?�목코드,?�목�??�중???�나 ?�수&lt;/td&gt;&lt;td&gt;?�택?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;PMKPMKNY&lt;/td&gt;&lt;td&gt;?�목�?lt;/td&gt;&lt;td&gt;string / (�????60&lt;/td&gt;&lt;td&gt;?�목코드,?�목�??�중???�나 ?�수&lt;/td&gt;&lt;td&gt;?�택?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공?? �?��?�번??- 목록( ?�코?�구분자 = !| , 컬럼구분??= @| ) &lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;DOSUNQNO(고유번호) , PMKPMKCD(?�목코드) , PMKPMKNM(?�목�? , JUMJUMCD(?�코?? , GEGETDT(취득?�자) , JABJABAM(취득금액) , JANJONAM(?�존�?��)&lt;/b&gt;&lt;br&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#startePS0024
     * @param ePS00248
     */
    public void startePS0024(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024 ePS00248,
        final com.woorifg.wpms.wpms_webservice.EPS_WSCallbackHandler callback)
        throws java.rmi.RemoteException {
        org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[4].getName());
        _operationClient.getOptions()
                        .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0024");
        _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

        addPropertyToOperationClient(_operationClient,
            org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
            "&");

        // create SOAP envelope with that payload
        org.apache.axiom.soap.SOAPEnvelope env = null;
        final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

        //Style is Doc.
        env = toEnvelope(getFactory(_operationClient.getOptions()
                                                    .getSoapVersionURI()),
                ePS00248,
                optimizeContent(
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0024")),
                new javax.xml.namespace.QName(
                    "http://wpms.woorifg.com/WPMS.WebService", "ePS0024"));

        // adding SOAP soap_headers
        _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);

        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                public void onMessage(
                    org.apache.axis2.context.MessageContext resultContext) {
                    try {
                        org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();

                        java.lang.Object object = fromOM(resultEnv.getBody()
                                                                  .getFirstElement(),
                                com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response.class,
                                getEnvelopeNamespaces(resultEnv));
                        callback.receiveResultePS0024((com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response) object);
                    } catch (org.apache.axis2.AxisFault e) {
                        callback.receiveErrorePS0024(e);
                    }
                }

                public void onError(java.lang.Exception error) {
                    if (error instanceof org.apache.axis2.AxisFault) {
                        org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
                        org.apache.axiom.om.OMElement faultElt = f.getDetail();

                        if (faultElt != null) {
                            if (faultExceptionNameMap.containsKey(
                                        new org.apache.axis2.client.FaultMapKey(
                                            faultElt.getQName(), "EPS0024"))) {
                                //make the fault by reflection
                                try {
                                    java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0024"));
                                    java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                    java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                                    //message class
                                    java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0024"));
                                    java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                    java.lang.Object messageObject = fromOM(faultElt,
                                            messageClass, null);
                                    java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                            new java.lang.Class[] { messageClass });
                                    m.invoke(ex,
                                        new java.lang.Object[] { messageObject });

                                    callback.receiveErrorePS0024(new java.rmi.RemoteException(
                                            ex.getMessage(), ex));
                                } catch (java.lang.ClassCastException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0024(f);
                                } catch (java.lang.ClassNotFoundException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0024(f);
                                } catch (java.lang.NoSuchMethodException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0024(f);
                                } catch (java.lang.reflect.InvocationTargetException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0024(f);
                                } catch (java.lang.IllegalAccessException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0024(f);
                                } catch (java.lang.InstantiationException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0024(f);
                                } catch (org.apache.axis2.AxisFault e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0024(f);
                                }
                            } else {
                                callback.receiveErrorePS0024(f);
                            }
                        } else {
                            callback.receiveErrorePS0024(f);
                        }
                    } else {
                        callback.receiveErrorePS0024(error);
                    }
                }

                public void onFault(
                    org.apache.axis2.context.MessageContext faultContext) {
                    org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                    onError(fault);
                }

                public void onComplete() {
                    try {
                        _messageContext.getTransportOut().getSender()
                                       .cleanup(_messageContext);
                    } catch (org.apache.axis2.AxisFault axisFault) {
                        callback.receiveErrorePS0024(axisFault);
                    }
                }
            });

        org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;

        if ((_operations[4].getMessageReceiver() == null) &&
                _operationClient.getOptions().isUseSeparateListener()) {
            _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
            _operations[4].setMessageReceiver(_callbackReceiver);
        }

        //execute the operation client
        _operationClient.execute(false);
    }

    /**
     * Auto generated method signature
     * &lt;br&gt;&lt;b&gt;복구충당�?�� 금액 반환&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S 복구충당�?�� 금액 반환&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;UNQUNQNO&lt;/td&gt;&lt;td&gt;고유번호&lt;/td&gt;&lt;td&gt;string / (고정??5&lt;/td&gt;&lt;td&gt;BDSBDSNO(�?��?�번?? ??5?�리&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;DURTERMY&lt;/td&gt;&lt;td&gt;?�도구분&lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;01 : ?�업??lt;br&gt;02 : 출장??lt;br&gt;03 : 무인?�포&lt;br&gt;29 : ?�시?�포&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USEUSEVL&lt;/td&gt;&lt;td&gt;?�용면적&lt;/td&gt;&lt;td&gt;string / (�????11.3&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 300 : 복구충당�?�� 기등록되???�어 추�??�록 불�? , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - 계산??결과�?복구충담�?��금액)&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#ePS0021
     * @param ePS002110
     */
    public com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response ePS0021(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021 ePS002110)
        throws java.rmi.RemoteException {
        org.apache.axis2.context.MessageContext _messageContext = null;

        try {
            org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[5].getName());
            _operationClient.getOptions()
                            .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0021");
            _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

            addPropertyToOperationClient(_operationClient,
                org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
                "&");

            // create a message context
            _messageContext = new org.apache.axis2.context.MessageContext();

            // create SOAP envelope with that payload
            org.apache.axiom.soap.SOAPEnvelope env = null;

            env = toEnvelope(getFactory(_operationClient.getOptions()
                                                        .getSoapVersionURI()),
                    ePS002110,
                    optimizeContent(
                        new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService", "ePS0021")),
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0021"));

            //adding SOAP soap_headers
            _serviceClient.addHeadersToEnvelope(env);
            // set the message context with that soap envelope
            _messageContext.setEnvelope(env);

            // add the message contxt to the operation client
            _operationClient.addMessageContext(_messageContext);

            //execute the operation client
            _operationClient.execute(true);

            org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
            org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();

            java.lang.Object object = fromOM(_returnEnv.getBody()
                                                       .getFirstElement(),
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response.class,
                    getEnvelopeNamespaces(_returnEnv));

            return (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response) object;
        } catch (org.apache.axis2.AxisFault f) {
            org.apache.axiom.om.OMElement faultElt = f.getDetail();

            if (faultElt != null) {
                if (faultExceptionNameMap.containsKey(
                            new org.apache.axis2.client.FaultMapKey(
                                faultElt.getQName(), "EPS0021"))) {
                    //make the fault by reflection
                    try {
                        java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0021"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                        //message class
                        java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0021"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,
                                messageClass, null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                new java.lang.Class[] { messageClass });
                        m.invoke(ex, new java.lang.Object[] { messageObject });

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    } catch (java.lang.ClassCastException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                } else {
                    throw f;
                }
            } else {
                throw f;
            }
        } finally {
            if (_messageContext.getTransportOut() != null) {
                _messageContext.getTransportOut().getSender()
                               .cleanup(_messageContext);
            }
        }
    }

    /**
     * Auto generated method signature for Asynchronous Invocations
     * &lt;br&gt;&lt;b&gt;복구충당�?�� 금액 반환&lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S 복구충당�?�� 금액 반환&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;UNQUNQNO&lt;/td&gt;&lt;td&gt;고유번호&lt;/td&gt;&lt;td&gt;string / (고정??5&lt;/td&gt;&lt;td&gt;BDSBDSNO(�?��?�번?? ??5?�리&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;DURTERMY&lt;/td&gt;&lt;td&gt;?�도구분&lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;01 : ?�업??lt;br&gt;02 : 출장??lt;br&gt;03 : 무인?�포&lt;br&gt;29 : ?�시?�포&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USEUSEVL&lt;/td&gt;&lt;td&gt;?�용면적&lt;/td&gt;&lt;td&gt;string / (�????11.3&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 300 : 복구충당�?�� 기등록되???�어 추�??�록 불�? , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - 계산??결과�?복구충담�?��금액)&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#startePS0021
     * @param ePS002110
     */
    public void startePS0021(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021 ePS002110,
        final com.woorifg.wpms.wpms_webservice.EPS_WSCallbackHandler callback)
        throws java.rmi.RemoteException {
        org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[5].getName());
        _operationClient.getOptions()
                        .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0021");
        _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

        addPropertyToOperationClient(_operationClient,
            org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
            "&");

        // create SOAP envelope with that payload
        org.apache.axiom.soap.SOAPEnvelope env = null;
        final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

        //Style is Doc.
        env = toEnvelope(getFactory(_operationClient.getOptions()
                                                    .getSoapVersionURI()),
                ePS002110,
                optimizeContent(
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0021")),
                new javax.xml.namespace.QName(
                    "http://wpms.woorifg.com/WPMS.WebService", "ePS0021"));

        // adding SOAP soap_headers
        _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);

        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                public void onMessage(
                    org.apache.axis2.context.MessageContext resultContext) {
                    try {
                        org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();

                        java.lang.Object object = fromOM(resultEnv.getBody()
                                                                  .getFirstElement(),
                                com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response.class,
                                getEnvelopeNamespaces(resultEnv));
                        callback.receiveResultePS0021((com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response) object);
                    } catch (org.apache.axis2.AxisFault e) {
                        callback.receiveErrorePS0021(e);
                    }
                }

                public void onError(java.lang.Exception error) {
                    if (error instanceof org.apache.axis2.AxisFault) {
                        org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
                        org.apache.axiom.om.OMElement faultElt = f.getDetail();

                        if (faultElt != null) {
                            if (faultExceptionNameMap.containsKey(
                                        new org.apache.axis2.client.FaultMapKey(
                                            faultElt.getQName(), "EPS0021"))) {
                                //make the fault by reflection
                                try {
                                    java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0021"));
                                    java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                    java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                                    //message class
                                    java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0021"));
                                    java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                    java.lang.Object messageObject = fromOM(faultElt,
                                            messageClass, null);
                                    java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                            new java.lang.Class[] { messageClass });
                                    m.invoke(ex,
                                        new java.lang.Object[] { messageObject });

                                    callback.receiveErrorePS0021(new java.rmi.RemoteException(
                                            ex.getMessage(), ex));
                                } catch (java.lang.ClassCastException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0021(f);
                                } catch (java.lang.ClassNotFoundException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0021(f);
                                } catch (java.lang.NoSuchMethodException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0021(f);
                                } catch (java.lang.reflect.InvocationTargetException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0021(f);
                                } catch (java.lang.IllegalAccessException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0021(f);
                                } catch (java.lang.InstantiationException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0021(f);
                                } catch (org.apache.axis2.AxisFault e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0021(f);
                                }
                            } else {
                                callback.receiveErrorePS0021(f);
                            }
                        } else {
                            callback.receiveErrorePS0021(f);
                        }
                    } else {
                        callback.receiveErrorePS0021(error);
                    }
                }

                public void onFault(
                    org.apache.axis2.context.MessageContext faultContext) {
                    org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                    onError(fault);
                }

                public void onComplete() {
                    try {
                        _messageContext.getTransportOut().getSender()
                                       .cleanup(_messageContext);
                    } catch (org.apache.axis2.AxisFault axisFault) {
                        callback.receiveErrorePS0021(axisFault);
                    }
                }
            });

        org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;

        if ((_operations[5].getMessageReceiver() == null) &&
                _operationClient.getOptions().isUseSeparateListener()) {
            _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
            _operations[5].setMessageReceiver(_callbackReceiver);
        }

        //execute the operation client
        _operationClient.execute(false);
    }

    /**
     * Auto generated method signature
     * &lt;br&gt;&lt;b&gt;�?��?�조??lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S �?��?�번??목록조회&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;?�속?�코??lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ASTASTCD&lt;/td&gt;&lt;td&gt;�?��?�구�?lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;10-?��?,20-건물,30-?�차?�포?�설�?lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공?? �?��?�번??- 목록( ?�코?�구분자 = !| , 컬럼구분??= @| ) &lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;ASTASTGB(�?��?�구분코?? , ASTASTNM(�?��?�구�? , UNQUNQNO(고유번호) , BDSBDSNO(�?��?�번?? , BDSBDSNM(�?��?�명�?&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp; , JUMJUMCD(?�코?? , JUMJUMNM(?�속?�이�? , GETGETDT(취득?�자) , PRSBOKAM(취득금액) , RPYCHDAM(감�??�각?�계??&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp; , NEYNEYVL(?�용?�수) , CSCASTAM(건설중인?�산금액) , GJGGJGAM(�??급금)&lt;/b&gt;&lt;br&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#ePS0020
     * @param ePS002012
     */
    public com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response ePS0020(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020 ePS002012)
        throws java.rmi.RemoteException {
        org.apache.axis2.context.MessageContext _messageContext = null;

        try {
            org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[6].getName());
            _operationClient.getOptions()
                            .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0020");
            _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

            addPropertyToOperationClient(_operationClient,
                org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
                "&");

            // create a message context
            _messageContext = new org.apache.axis2.context.MessageContext();

            // create SOAP envelope with that payload
            org.apache.axiom.soap.SOAPEnvelope env = null;

            env = toEnvelope(getFactory(_operationClient.getOptions()
                                                        .getSoapVersionURI()),
                    ePS002012,
                    optimizeContent(
                        new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService", "ePS0020")),
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0020"));

            //adding SOAP soap_headers
            _serviceClient.addHeadersToEnvelope(env);
            // set the message context with that soap envelope
            _messageContext.setEnvelope(env);

            // add the message contxt to the operation client
            _operationClient.addMessageContext(_messageContext);

            //execute the operation client
            _operationClient.execute(true);

            org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
            org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();

            java.lang.Object object = fromOM(_returnEnv.getBody()
                                                       .getFirstElement(),
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response.class,
                    getEnvelopeNamespaces(_returnEnv));

            return (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response) object;
        } catch (org.apache.axis2.AxisFault f) {
            org.apache.axiom.om.OMElement faultElt = f.getDetail();

            if (faultElt != null) {
                if (faultExceptionNameMap.containsKey(
                            new org.apache.axis2.client.FaultMapKey(
                                faultElt.getQName(), "EPS0020"))) {
                    //make the fault by reflection
                    try {
                        java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0020"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                        //message class
                        java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                    faultElt.getQName(), "EPS0020"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,
                                messageClass, null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                new java.lang.Class[] { messageClass });
                        m.invoke(ex, new java.lang.Object[] { messageObject });

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    } catch (java.lang.ClassCastException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                } else {
                    throw f;
                }
            } else {
                throw f;
            }
        } finally {
            if (_messageContext.getTransportOut() != null) {
                _messageContext.getTransportOut().getSender()
                               .cleanup(_messageContext);
            }
        }
    }

    /**
     * Auto generated method signature for Asynchronous Invocations
     * &lt;br&gt;&lt;b&gt;�?��?�조??lt;/b&gt;&lt;br&gt;&lt;br&gt;&lt;table border=1&gt;&lt;tr bgcolor=yellow&gt;&lt;td width=100 align=center&gt;?�라미터�?lt;/td&gt;&lt;td width=200 align=center&gt;Comments&lt;/td&gt;&lt;td width=120 align=center&gt;Type/Size&lt;/td&gt;&lt;td width=350 align=center&gt;로직구현&lt;/td&gt;&lt;td width=100 align=center&gt;조회(S)???�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;MODE&lt;/td&gt;&lt;td&gt;?�업구분&lt;/td&gt;&lt;td&gt;string / (고정??1&lt;/td&gt;&lt;td&gt;S �?��?�번??목록조회&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;JUMJUMCD&lt;/td&gt;&lt;td&gt;?�속?�코??lt;/td&gt;&lt;td&gt;string / (�????6&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;ASTASTCD&lt;/td&gt;&lt;td&gt;�?��?�구�?lt;/td&gt;&lt;td&gt;string / (고정??2&lt;/td&gt;&lt;td&gt;10-?��?,20-건물,30-?�차?�포?�설�?lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;USRUSRID&lt;/td&gt;&lt;td&gt;?�출?�행�?lt;/td&gt;&lt;td&gt;string / (고정??8&lt;/td&gt;&lt;td&gt;&amp;nbsp;&lt;/td&gt;&lt;td&gt;?�수&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;br&gt;&lt;b&gt;Return[3]�?  string[0] - 200 : ?�공 , 그외 ?�러번호 ?�퍠&lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[1] - ?�공?? �?��?�번??- 목록( ?�코?�구분자 = !| , 컬럼구분??= @| ) &lt;/b&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;ASTASTGB(�?��?�구분코?? , ASTASTNM(�?��?�구�? , UNQUNQNO(고유번호) , BDSBDSNO(�?��?�번?? , BDSBDSNM(�?��?�명�?&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp; , JUMJUMCD(?�코?? , JUMJUMNM(?�속?�이�? , GETGETDT(취득?�자) , PRSBOKAM(취득금액) , RPYCHDAM(감�??�각?�계??&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp; , NEYNEYVL(?�용?�수) , CSCASTAM(건설중인?�산금액) , GJGGJGAM(�??급금)&lt;/b&gt;&lt;br&gt;&lt;br&gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&lt;b&gt;string[2] - ?�류메세�?lt;/b&gt;&lt;br&gt;
     * @see com.woorifg.wpms.wpms_webservice.EPS_WS#startePS0020
     * @param ePS002012
     */
    public void startePS0020(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020 ePS002012,
        final com.woorifg.wpms.wpms_webservice.EPS_WSCallbackHandler callback)
        throws java.rmi.RemoteException {
        org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[6].getName());
        _operationClient.getOptions()
                        .setAction("http://wpms.woorifg.com/WPMS.WebService/EPS0020");
        _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

        addPropertyToOperationClient(_operationClient,
            org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,
            "&");

        // create SOAP envelope with that payload
        org.apache.axiom.soap.SOAPEnvelope env = null;
        final org.apache.axis2.context.MessageContext _messageContext = new org.apache.axis2.context.MessageContext();

        //Style is Doc.
        env = toEnvelope(getFactory(_operationClient.getOptions()
                                                    .getSoapVersionURI()),
                ePS002012,
                optimizeContent(
                    new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ePS0020")),
                new javax.xml.namespace.QName(
                    "http://wpms.woorifg.com/WPMS.WebService", "ePS0020"));

        // adding SOAP soap_headers
        _serviceClient.addHeadersToEnvelope(env);
        // create message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message context to the operation client
        _operationClient.addMessageContext(_messageContext);

        _operationClient.setCallback(new org.apache.axis2.client.async.AxisCallback() {
                public void onMessage(
                    org.apache.axis2.context.MessageContext resultContext) {
                    try {
                        org.apache.axiom.soap.SOAPEnvelope resultEnv = resultContext.getEnvelope();

                        java.lang.Object object = fromOM(resultEnv.getBody()
                                                                  .getFirstElement(),
                                com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response.class,
                                getEnvelopeNamespaces(resultEnv));
                        callback.receiveResultePS0020((com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response) object);
                    } catch (org.apache.axis2.AxisFault e) {
                        callback.receiveErrorePS0020(e);
                    }
                }

                public void onError(java.lang.Exception error) {
                    if (error instanceof org.apache.axis2.AxisFault) {
                        org.apache.axis2.AxisFault f = (org.apache.axis2.AxisFault) error;
                        org.apache.axiom.om.OMElement faultElt = f.getDetail();

                        if (faultElt != null) {
                            if (faultExceptionNameMap.containsKey(
                                        new org.apache.axis2.client.FaultMapKey(
                                            faultElt.getQName(), "EPS0020"))) {
                                //make the fault by reflection
                                try {
                                    java.lang.String exceptionClassName = (java.lang.String) faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0020"));
                                    java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                    java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(java.lang.String.class);
                                    java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());

                                    //message class
                                    java.lang.String messageClassName = (java.lang.String) faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(
                                                faultElt.getQName(), "EPS0020"));
                                    java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                    java.lang.Object messageObject = fromOM(faultElt,
                                            messageClass, null);
                                    java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                            new java.lang.Class[] { messageClass });
                                    m.invoke(ex,
                                        new java.lang.Object[] { messageObject });

                                    callback.receiveErrorePS0020(new java.rmi.RemoteException(
                                            ex.getMessage(), ex));
                                } catch (java.lang.ClassCastException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0020(f);
                                } catch (java.lang.ClassNotFoundException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0020(f);
                                } catch (java.lang.NoSuchMethodException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0020(f);
                                } catch (java.lang.reflect.InvocationTargetException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0020(f);
                                } catch (java.lang.IllegalAccessException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0020(f);
                                } catch (java.lang.InstantiationException e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0020(f);
                                } catch (org.apache.axis2.AxisFault e) {
                                    // we cannot intantiate the class - throw the original Axis fault
                                    callback.receiveErrorePS0020(f);
                                }
                            } else {
                                callback.receiveErrorePS0020(f);
                            }
                        } else {
                            callback.receiveErrorePS0020(f);
                        }
                    } else {
                        callback.receiveErrorePS0020(error);
                    }
                }

                public void onFault(
                    org.apache.axis2.context.MessageContext faultContext) {
                    org.apache.axis2.AxisFault fault = org.apache.axis2.util.Utils.getInboundFaultFromMessageContext(faultContext);
                    onError(fault);
                }

                public void onComplete() {
                    try {
                        _messageContext.getTransportOut().getSender()
                                       .cleanup(_messageContext);
                    } catch (org.apache.axis2.AxisFault axisFault) {
                        callback.receiveErrorePS0020(axisFault);
                    }
                }
            });

        org.apache.axis2.util.CallbackReceiver _callbackReceiver = null;

        if ((_operations[6].getMessageReceiver() == null) &&
                _operationClient.getOptions().isUseSeparateListener()) {
            _callbackReceiver = new org.apache.axis2.util.CallbackReceiver();
            _operations[6].setMessageReceiver(_callbackReceiver);
        }

        //execute the operation client
        _operationClient.execute(false);
    }

    /**
     *  A utility method that copies the namepaces from the SOAPEnvelope
     */
    private java.util.Map getEnvelopeNamespaces(
        org.apache.axiom.soap.SOAPEnvelope env) {
        java.util.Map returnMap = new java.util.HashMap();
        java.util.Iterator namespaceIterator = env.getAllDeclaredNamespaces();

        while (namespaceIterator.hasNext()) {
            org.apache.axiom.om.OMNamespace ns = (org.apache.axiom.om.OMNamespace) namespaceIterator.next();
            returnMap.put(ns.getPrefix(), ns.getNamespaceURI());
        }

        return returnMap;
    }

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

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034 param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019 param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1 param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037 param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024 param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021 param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020 param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.om.OMElement toOM(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response param,
        boolean optimizeContent) throws org.apache.axis2.AxisFault {
        try {
            return param.getOMElement(com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response.MY_QNAME,
                org.apache.axiom.om.OMAbstractFactory.getOMFactory());
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory,
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034 param,
        boolean optimizeContent, javax.xml.namespace.QName methodQName)
        throws org.apache.axis2.AxisFault {
        try {
            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
            emptyEnvelope.getBody()
                         .addChild(param.getOMElement(
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034.MY_QNAME,
                    factory));

            return emptyEnvelope;
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    /* methods to provide back word compatibility */
    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory,
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019 param,
        boolean optimizeContent, javax.xml.namespace.QName methodQName)
        throws org.apache.axis2.AxisFault {
        try {
            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
            emptyEnvelope.getBody()
                         .addChild(param.getOMElement(
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019.MY_QNAME,
                    factory));

            return emptyEnvelope;
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    /* methods to provide back word compatibility */
    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory,
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1 param,
        boolean optimizeContent, javax.xml.namespace.QName methodQName)
        throws org.apache.axis2.AxisFault {
        try {
            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
            emptyEnvelope.getBody()
                         .addChild(param.getOMElement(
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1.MY_QNAME,
                    factory));

            return emptyEnvelope;
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    /* methods to provide back word compatibility */
    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory,
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037 param,
        boolean optimizeContent, javax.xml.namespace.QName methodQName)
        throws org.apache.axis2.AxisFault {
        try {
            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
            emptyEnvelope.getBody()
                         .addChild(param.getOMElement(
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037.MY_QNAME,
                    factory));

            return emptyEnvelope;
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    /* methods to provide back word compatibility */
    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory,
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024 param,
        boolean optimizeContent, javax.xml.namespace.QName methodQName)
        throws org.apache.axis2.AxisFault {
        try {
            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
            emptyEnvelope.getBody()
                         .addChild(param.getOMElement(
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024.MY_QNAME,
                    factory));

            return emptyEnvelope;
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    /* methods to provide back word compatibility */
    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory,
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021 param,
        boolean optimizeContent, javax.xml.namespace.QName methodQName)
        throws org.apache.axis2.AxisFault {
        try {
            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
            emptyEnvelope.getBody()
                         .addChild(param.getOMElement(
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021.MY_QNAME,
                    factory));

            return emptyEnvelope;
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    /* methods to provide back word compatibility */
    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory,
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020 param,
        boolean optimizeContent, javax.xml.namespace.QName methodQName)
        throws org.apache.axis2.AxisFault {
        try {
            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
            emptyEnvelope.getBody()
                         .addChild(param.getOMElement(
                    com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020.MY_QNAME,
                    factory));

            return emptyEnvelope;
        } catch (org.apache.axis2.databinding.ADBException e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }
    }

    /* methods to provide back word compatibility */

    /**
     *  get the default envelope
     */
    private org.apache.axiom.soap.SOAPEnvelope toEnvelope(
        org.apache.axiom.soap.SOAPFactory factory) {
        return factory.getDefaultEnvelope();
    }

    private java.lang.Object fromOM(org.apache.axiom.om.OMElement param,
        java.lang.Class type, java.util.Map extraNamespaces)
        throws org.apache.axis2.AxisFault {
        try {
            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }

            if (com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response.class.equals(
                        type)) {
                return com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response.Factory.parse(param.getXMLStreamReaderWithoutCaching());
            }
        } catch (java.lang.Exception e) {
            throw org.apache.axis2.AxisFault.makeFault(e);
        }

        return null;
    }

    //http://wpms.woorifg.com/WPMS.WebService/EPS_WS.asmx
    public static class EPS0019_1Response implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0019_1Response", "ns1");

        /**
         * field for EPS0019_1Result
         */
        protected ArrayOfString localEPS0019_1Result;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localEPS0019_1ResultTracker = false;

        public boolean isEPS0019_1ResultSpecified() {
            return localEPS0019_1ResultTracker;
        }

        /**
         * Auto generated getter method
         * @return ArrayOfString
         */
        public ArrayOfString getEPS0019_1Result() {
            return localEPS0019_1Result;
        }

        /**
         * Auto generated setter method
         * @param param EPS0019_1Result
         */
        public void setEPS0019_1Result(ArrayOfString param) {
            localEPS0019_1ResultTracker = param != null;

            this.localEPS0019_1Result = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0019_1Response", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0019_1Response", xmlWriter);
                }
            }

            if (localEPS0019_1ResultTracker) {
                if (localEPS0019_1Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0019_1Result cannot be null!!");
                }

                localEPS0019_1Result.serialize(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0019_1Result"), xmlWriter);
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localEPS0019_1ResultTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0019_1Result"));

                if (localEPS0019_1Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0019_1Result cannot be null!!");
                }

                elementList.add(localEPS0019_1Result);
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0019_1Response parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0019_1Response object = new EPS0019_1Response();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0019_1Response".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0019_1Response) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "EPS0019_1Result").equals(reader.getName())) {
                        object.setEPS0019_1Result(ArrayOfString.Factory.parse(
                                reader));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0019 implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0019", "ns1");

        /**
         * field for MODE
         */
        protected java.lang.String localMODE;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMODETracker = false;

        /**
         * field for BNKBNKCD
         */
        protected java.lang.String localBNKBNKCD;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localBNKBNKCDTracker = false;

        /**
         * field for BMSBMSYY
         */
        protected java.lang.String localBMSBMSYY;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localBMSBMSYYTracker = false;

        /**
         * field for SOGSOGCD
         */
        protected java.lang.String localSOGSOGCD;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localSOGSOGCDTracker = false;

        /**
         * field for ASTASTGB
         */
        protected java.lang.String localASTASTGB;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localASTASTGBTracker = false;

        /**
         * field for MNGMNGNO
         */
        protected java.lang.String localMNGMNGNO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMNGMNGNOTracker = false;

        /**
         * field for BSSBSSNO
         */
        protected java.lang.String localBSSBSSNO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localBSSBSSNOTracker = false;

        /**
         * field for PUMPUMDT
         */
        protected java.lang.String localPUMPUMDT;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localPUMPUMDTTracker = false;

        /**
         * field for PUMPUMAM
         */
        protected java.lang.String localPUMPUMAM;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localPUMPUMAMTracker = false;

        /**
         * field for ETCETCNY
         */
        protected java.lang.String localETCETCNY;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localETCETCNYTracker = false;

        /**
         * field for USRUSRID
         */
        protected java.lang.String localUSRUSRID;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSRUSRIDTracker = false;

        /**
         * field for INF_REF_NO
         */
        protected java.lang.String localINF_REF_NO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localINF_REF_NOTracker = false;

        public boolean isMODESpecified() {
            return localMODETracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMODE() {
            return localMODE;
        }

        /**
         * Auto generated setter method
         * @param param MODE
         */
        public void setMODE(java.lang.String param) {
            localMODETracker = param != null;

            this.localMODE = param;
        }

        public boolean isBNKBNKCDSpecified() {
            return localBNKBNKCDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getBNKBNKCD() {
            return localBNKBNKCD;
        }

        /**
         * Auto generated setter method
         * @param param BNKBNKCD
         */
        public void setBNKBNKCD(java.lang.String param) {
            localBNKBNKCDTracker = param != null;

            this.localBNKBNKCD = param;
        }

        public boolean isBMSBMSYYSpecified() {
            return localBMSBMSYYTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getBMSBMSYY() {
            return localBMSBMSYY;
        }

        /**
         * Auto generated setter method
         * @param param BMSBMSYY
         */
        public void setBMSBMSYY(java.lang.String param) {
            localBMSBMSYYTracker = param != null;

            this.localBMSBMSYY = param;
        }

        public boolean isSOGSOGCDSpecified() {
            return localSOGSOGCDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getSOGSOGCD() {
            return localSOGSOGCD;
        }

        /**
         * Auto generated setter method
         * @param param SOGSOGCD
         */
        public void setSOGSOGCD(java.lang.String param) {
            localSOGSOGCDTracker = param != null;

            this.localSOGSOGCD = param;
        }

        public boolean isASTASTGBSpecified() {
            return localASTASTGBTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getASTASTGB() {
            return localASTASTGB;
        }

        /**
         * Auto generated setter method
         * @param param ASTASTGB
         */
        public void setASTASTGB(java.lang.String param) {
            localASTASTGBTracker = param != null;

            this.localASTASTGB = param;
        }

        public boolean isMNGMNGNOSpecified() {
            return localMNGMNGNOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMNGMNGNO() {
            return localMNGMNGNO;
        }

        /**
         * Auto generated setter method
         * @param param MNGMNGNO
         */
        public void setMNGMNGNO(java.lang.String param) {
            localMNGMNGNOTracker = param != null;

            this.localMNGMNGNO = param;
        }

        public boolean isBSSBSSNOSpecified() {
            return localBSSBSSNOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getBSSBSSNO() {
            return localBSSBSSNO;
        }

        /**
         * Auto generated setter method
         * @param param BSSBSSNO
         */
        public void setBSSBSSNO(java.lang.String param) {
            localBSSBSSNOTracker = param != null;

            this.localBSSBSSNO = param;
        }

        public boolean isPUMPUMDTSpecified() {
            return localPUMPUMDTTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getPUMPUMDT() {
            return localPUMPUMDT;
        }

        /**
         * Auto generated setter method
         * @param param PUMPUMDT
         */
        public void setPUMPUMDT(java.lang.String param) {
            localPUMPUMDTTracker = param != null;

            this.localPUMPUMDT = param;
        }

        public boolean isPUMPUMAMSpecified() {
            return localPUMPUMAMTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getPUMPUMAM() {
            return localPUMPUMAM;
        }

        /**
         * Auto generated setter method
         * @param param PUMPUMAM
         */
        public void setPUMPUMAM(java.lang.String param) {
            localPUMPUMAMTracker = param != null;

            this.localPUMPUMAM = param;
        }

        public boolean isETCETCNYSpecified() {
            return localETCETCNYTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getETCETCNY() {
            return localETCETCNY;
        }

        /**
         * Auto generated setter method
         * @param param ETCETCNY
         */
        public void setETCETCNY(java.lang.String param) {
            localETCETCNYTracker = param != null;

            this.localETCETCNY = param;
        }

        public boolean isUSRUSRIDSpecified() {
            return localUSRUSRIDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSRUSRID() {
            return localUSRUSRID;
        }

        /**
         * Auto generated setter method
         * @param param USRUSRID
         */
        public void setUSRUSRID(java.lang.String param) {
            localUSRUSRIDTracker = param != null;

            this.localUSRUSRID = param;
        }

        public boolean isINF_REF_NOSpecified() {
            return localINF_REF_NOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getINF_REF_NO() {
            return localINF_REF_NO;
        }

        /**
         * Auto generated setter method
         * @param param INF_REF_NO
         */
        public void setINF_REF_NO(java.lang.String param) {
            localINF_REF_NOTracker = param != null;

            this.localINF_REF_NO = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0019", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0019", xmlWriter);
                }
            }

            if (localMODETracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MODE", xmlWriter);

                if (localMODE == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMODE);
                }

                xmlWriter.writeEndElement();
            }

            if (localBNKBNKCDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "BNKBNKCD", xmlWriter);

                if (localBNKBNKCD == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "BNKBNKCD cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localBNKBNKCD);
                }

                xmlWriter.writeEndElement();
            }

            if (localBMSBMSYYTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "BMSBMSYY", xmlWriter);

                if (localBMSBMSYY == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSBMSYY cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localBMSBMSYY);
                }

                xmlWriter.writeEndElement();
            }

            if (localSOGSOGCDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "SOGSOGCD", xmlWriter);

                if (localSOGSOGCD == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "SOGSOGCD cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localSOGSOGCD);
                }

                xmlWriter.writeEndElement();
            }

            if (localASTASTGBTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "ASTASTGB", xmlWriter);

                if (localASTASTGB == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "ASTASTGB cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localASTASTGB);
                }

                xmlWriter.writeEndElement();
            }

            if (localMNGMNGNOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MNGMNGNO", xmlWriter);

                if (localMNGMNGNO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MNGMNGNO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMNGMNGNO);
                }

                xmlWriter.writeEndElement();
            }

            if (localBSSBSSNOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "BSSBSSNO", xmlWriter);

                if (localBSSBSSNO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "BSSBSSNO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localBSSBSSNO);
                }

                xmlWriter.writeEndElement();
            }

            if (localPUMPUMDTTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "PUMPUMDT", xmlWriter);

                if (localPUMPUMDT == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "PUMPUMDT cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localPUMPUMDT);
                }

                xmlWriter.writeEndElement();
            }

            if (localPUMPUMAMTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "PUMPUMAM", xmlWriter);

                if (localPUMPUMAM == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "PUMPUMAM cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localPUMPUMAM);
                }

                xmlWriter.writeEndElement();
            }

            if (localETCETCNYTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "ETCETCNY", xmlWriter);

                if (localETCETCNY == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "ETCETCNY cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localETCETCNY);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSRUSRIDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USRUSRID", xmlWriter);

                if (localUSRUSRID == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSRUSRID);
                }

                xmlWriter.writeEndElement();
            }

            if (localINF_REF_NOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "INF_REF_NO", xmlWriter);

                if (localINF_REF_NO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "INF_REF_NO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localINF_REF_NO);
                }

                xmlWriter.writeEndElement();
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localMODETracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MODE"));

                if (localMODE != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMODE));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                }
            }

            if (localBNKBNKCDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "BNKBNKCD"));

                if (localBNKBNKCD != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localBNKBNKCD));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "BNKBNKCD cannot be null!!");
                }
            }

            if (localBMSBMSYYTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "BMSBMSYY"));

                if (localBMSBMSYY != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localBMSBMSYY));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSBMSYY cannot be null!!");
                }
            }

            if (localSOGSOGCDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "SOGSOGCD"));

                if (localSOGSOGCD != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localSOGSOGCD));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "SOGSOGCD cannot be null!!");
                }
            }

            if (localASTASTGBTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ASTASTGB"));

                if (localASTASTGB != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localASTASTGB));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "ASTASTGB cannot be null!!");
                }
            }

            if (localMNGMNGNOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MNGMNGNO"));

                if (localMNGMNGNO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMNGMNGNO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MNGMNGNO cannot be null!!");
                }
            }

            if (localBSSBSSNOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "BSSBSSNO"));

                if (localBSSBSSNO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localBSSBSSNO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "BSSBSSNO cannot be null!!");
                }
            }

            if (localPUMPUMDTTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "PUMPUMDT"));

                if (localPUMPUMDT != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localPUMPUMDT));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "PUMPUMDT cannot be null!!");
                }
            }

            if (localPUMPUMAMTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "PUMPUMAM"));

                if (localPUMPUMAM != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localPUMPUMAM));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "PUMPUMAM cannot be null!!");
                }
            }

            if (localETCETCNYTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ETCETCNY"));

                if (localETCETCNY != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localETCETCNY));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "ETCETCNY cannot be null!!");
                }
            }

            if (localUSRUSRIDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USRUSRID"));

                if (localUSRUSRID != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSRUSRID));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                }
            }

            if (localINF_REF_NOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "INF_REF_NO"));

                if (localINF_REF_NO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localINF_REF_NO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "INF_REF_NO cannot be null!!");
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0019 parse(javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0019 object = new EPS0019();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0019".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0019) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MODE").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MODE" + "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMODE(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "BNKBNKCD").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "BNKBNKCD" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setBNKBNKCD(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "BMSBMSYY").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "BMSBMSYY" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setBMSBMSYY(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "SOGSOGCD").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "SOGSOGCD" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setSOGSOGCD(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "ASTASTGB").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "ASTASTGB" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setASTASTGB(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MNGMNGNO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MNGMNGNO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMNGMNGNO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "BSSBSSNO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "BSSBSSNO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setBSSBSSNO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "PUMPUMDT").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "PUMPUMDT" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setPUMPUMDT(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "PUMPUMAM").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "PUMPUMAM" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setPUMPUMAM(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "ETCETCNY").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "ETCETCNY" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setETCETCNY(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USRUSRID").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USRUSRID" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSRUSRID(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "INF_REF_NO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "INF_REF_NO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setINF_REF_NO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class ArrayOfString implements org.apache.axis2.databinding.ADBBean {
        /* This type was generated from the piece of schema that had
           name = ArrayOfString
           Namespace URI = http://wpms.woorifg.com/WPMS.WebService
           Namespace Prefix = ns1
         */

        /**
         * field for String
         * This was an Array!
         */
        protected java.lang.String[] localString;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localStringTracker = false;

        public boolean isStringSpecified() {
            return localStringTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String[]
         */
        public java.lang.String[] getString() {
            return localString;
        }

        /**
         * validate the array for String
         */
        protected void validateString(java.lang.String[] param) {
        }

        /**
         * Auto generated setter method
         * @param param String
         */
        public void setString(java.lang.String[] param) {
            validateString(param);

            localStringTracker = true;

            this.localString = param;
        }

        /**
         * Auto generated add method for the array for convenience
         * @param param java.lang.String
         */
        public void addString(java.lang.String param) {
            if (localString == null) {
                localString = new java.lang.String[] {  };
            }

            //update the setting tracker
            localStringTracker = true;

            java.util.List list = org.apache.axis2.databinding.utils.ConverterUtil.toList(localString);
            list.add(param);
            this.localString = (java.lang.String[]) list.toArray(new java.lang.String[list.size()]);
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    parentQName);

            return factory.createOMElement(dataSource, parentQName);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":ArrayOfString", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "ArrayOfString", xmlWriter);
                }
            }

            if (localStringTracker) {
                if (localString != null) {
                    namespace = "http://wpms.woorifg.com/WPMS.WebService";

                    for (int i = 0; i < localString.length; i++) {
                        if (localString[i] != null) {
                            writeStartElement(null, namespace, "string",
                                xmlWriter);

                            xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    localString[i]));

                            xmlWriter.writeEndElement();
                        } else {
                            // write null attribute
                            namespace = "http://wpms.woorifg.com/WPMS.WebService";
                            writeStartElement(null, namespace, "string",
                                xmlWriter);
                            writeAttribute("xsi",
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "nil", "1", xmlWriter);
                            xmlWriter.writeEndElement();
                        }
                    }
                } else {
                    // write the null attribute
                    // write null attribute
                    writeStartElement(null,
                        "http://wpms.woorifg.com/WPMS.WebService", "string",
                        xmlWriter);

                    // write the nil attribute
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "nil",
                        "1", xmlWriter);
                    xmlWriter.writeEndElement();
                }
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localStringTracker) {
                if (localString != null) {
                    for (int i = 0; i < localString.length; i++) {
                        if (localString[i] != null) {
                            elementList.add(new javax.xml.namespace.QName(
                                    "http://wpms.woorifg.com/WPMS.WebService",
                                    "string"));
                            elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    localString[i]));
                        } else {
                            elementList.add(new javax.xml.namespace.QName(
                                    "http://wpms.woorifg.com/WPMS.WebService",
                                    "string"));
                            elementList.add(null);
                        }
                    }
                } else {
                    elementList.add(new javax.xml.namespace.QName(
                            "http://wpms.woorifg.com/WPMS.WebService", "string"));
                    elementList.add(null);
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static ArrayOfString parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                ArrayOfString object = new ArrayOfString();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"ArrayOfString".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (ArrayOfString) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    java.util.ArrayList list1 = new java.util.ArrayList();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "string").equals(reader.getName())) {
                        // Process the array and step past its final element's end.
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            list1.add(null);

                            reader.next();
                        } else {
                            list1.add(reader.getElementText());
                        }

                        //loop until we find a start element that is not part of this array
                        boolean loopDone1 = false;

                        while (!loopDone1) {
                            // Ensure we are at the EndElement
                            while (!reader.isEndElement()) {
                                reader.next();
                            }

                            // Step out of this element
                            reader.next();

                            // Step to next element event.
                            while (!reader.isStartElement() &&
                                    !reader.isEndElement())
                                reader.next();

                            if (reader.isEndElement()) {
                                //two continuous end elements means we are exiting the xml structure
                                loopDone1 = true;
                            } else {
                                if (new javax.xml.namespace.QName(
                                            "http://wpms.woorifg.com/WPMS.WebService",
                                            "string").equals(reader.getName())) {
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                            "nil");

                                    if ("true".equals(nillableValue) ||
                                            "1".equals(nillableValue)) {
                                        list1.add(null);

                                        reader.next();
                                    } else {
                                        list1.add(reader.getElementText());
                                    }
                                } else {
                                    loopDone1 = true;
                                }
                            }
                        }

                        // call the converter utility  to convert and set the array
                        object.setString((java.lang.String[]) list1.toArray(
                                new java.lang.String[list1.size()]));
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0037 implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0037", "ns1");

        /**
         * field for MODE
         */
        protected java.lang.String localMODE;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMODETracker = false;

        /**
         * field for JUMJUMCD
         */
        protected java.lang.String localJUMJUMCD;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localJUMJUMCDTracker = false;

        /**
         * field for USRUSRID
         */
        protected java.lang.String localUSRUSRID;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSRUSRIDTracker = false;

        public boolean isMODESpecified() {
            return localMODETracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMODE() {
            return localMODE;
        }

        /**
         * Auto generated setter method
         * @param param MODE
         */
        public void setMODE(java.lang.String param) {
            localMODETracker = param != null;

            this.localMODE = param;
        }

        public boolean isJUMJUMCDSpecified() {
            return localJUMJUMCDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getJUMJUMCD() {
            return localJUMJUMCD;
        }

        /**
         * Auto generated setter method
         * @param param JUMJUMCD
         */
        public void setJUMJUMCD(java.lang.String param) {
            localJUMJUMCDTracker = param != null;

            this.localJUMJUMCD = param;
        }

        public boolean isUSRUSRIDSpecified() {
            return localUSRUSRIDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSRUSRID() {
            return localUSRUSRID;
        }

        /**
         * Auto generated setter method
         * @param param USRUSRID
         */
        public void setUSRUSRID(java.lang.String param) {
            localUSRUSRIDTracker = param != null;

            this.localUSRUSRID = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0037", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0037", xmlWriter);
                }
            }

            if (localMODETracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MODE", xmlWriter);

                if (localMODE == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMODE);
                }

                xmlWriter.writeEndElement();
            }

            if (localJUMJUMCDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "JUMJUMCD", xmlWriter);

                if (localJUMJUMCD == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "JUMJUMCD cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localJUMJUMCD);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSRUSRIDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USRUSRID", xmlWriter);

                if (localUSRUSRID == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSRUSRID);
                }

                xmlWriter.writeEndElement();
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localMODETracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MODE"));

                if (localMODE != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMODE));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                }
            }

            if (localJUMJUMCDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "JUMJUMCD"));

                if (localJUMJUMCD != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localJUMJUMCD));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "JUMJUMCD cannot be null!!");
                }
            }

            if (localUSRUSRIDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USRUSRID"));

                if (localUSRUSRID != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSRUSRID));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0037 parse(javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0037 object = new EPS0037();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0037".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0037) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MODE").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MODE" + "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMODE(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "JUMJUMCD").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "JUMJUMCD" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setJUMJUMCD(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USRUSRID").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USRUSRID" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSRUSRID(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0024Response implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0024Response", "ns1");

        /**
         * field for EPS0024Result
         */
        protected ArrayOfString localEPS0024Result;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localEPS0024ResultTracker = false;

        public boolean isEPS0024ResultSpecified() {
            return localEPS0024ResultTracker;
        }

        /**
         * Auto generated getter method
         * @return ArrayOfString
         */
        public ArrayOfString getEPS0024Result() {
            return localEPS0024Result;
        }

        /**
         * Auto generated setter method
         * @param param EPS0024Result
         */
        public void setEPS0024Result(ArrayOfString param) {
            localEPS0024ResultTracker = param != null;

            this.localEPS0024Result = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0024Response", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0024Response", xmlWriter);
                }
            }

            if (localEPS0024ResultTracker) {
                if (localEPS0024Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0024Result cannot be null!!");
                }

                localEPS0024Result.serialize(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0024Result"), xmlWriter);
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localEPS0024ResultTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0024Result"));

                if (localEPS0024Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0024Result cannot be null!!");
                }

                elementList.add(localEPS0024Result);
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0024Response parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0024Response object = new EPS0024Response();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0024Response".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0024Response) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "EPS0024Result").equals(reader.getName())) {
                        object.setEPS0024Result(ArrayOfString.Factory.parse(
                                reader));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0024 implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0024", "ns1");

        /**
         * field for MODE
         */
        protected java.lang.String localMODE;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMODETracker = false;

        /**
         * field for JUMJUMCD
         */
        protected java.lang.String localJUMJUMCD;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localJUMJUMCDTracker = false;

        /**
         * field for PMKPMKCD
         */
        protected java.lang.String localPMKPMKCD;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localPMKPMKCDTracker = false;

        /**
         * field for PMKPMKNY
         */
        protected java.lang.String localPMKPMKNY;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localPMKPMKNYTracker = false;

        /**
         * field for USRUSRID
         */
        protected java.lang.String localUSRUSRID;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSRUSRIDTracker = false;

        public boolean isMODESpecified() {
            return localMODETracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMODE() {
            return localMODE;
        }

        /**
         * Auto generated setter method
         * @param param MODE
         */
        public void setMODE(java.lang.String param) {
            localMODETracker = param != null;

            this.localMODE = param;
        }

        public boolean isJUMJUMCDSpecified() {
            return localJUMJUMCDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getJUMJUMCD() {
            return localJUMJUMCD;
        }

        /**
         * Auto generated setter method
         * @param param JUMJUMCD
         */
        public void setJUMJUMCD(java.lang.String param) {
            localJUMJUMCDTracker = param != null;

            this.localJUMJUMCD = param;
        }

        public boolean isPMKPMKCDSpecified() {
            return localPMKPMKCDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getPMKPMKCD() {
            return localPMKPMKCD;
        }

        /**
         * Auto generated setter method
         * @param param PMKPMKCD
         */
        public void setPMKPMKCD(java.lang.String param) {
            localPMKPMKCDTracker = param != null;

            this.localPMKPMKCD = param;
        }

        public boolean isPMKPMKNYSpecified() {
            return localPMKPMKNYTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getPMKPMKNY() {
            return localPMKPMKNY;
        }

        /**
         * Auto generated setter method
         * @param param PMKPMKNY
         */
        public void setPMKPMKNY(java.lang.String param) {
            localPMKPMKNYTracker = param != null;

            this.localPMKPMKNY = param;
        }

        public boolean isUSRUSRIDSpecified() {
            return localUSRUSRIDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSRUSRID() {
            return localUSRUSRID;
        }

        /**
         * Auto generated setter method
         * @param param USRUSRID
         */
        public void setUSRUSRID(java.lang.String param) {
            localUSRUSRIDTracker = param != null;

            this.localUSRUSRID = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0024", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0024", xmlWriter);
                }
            }

            if (localMODETracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MODE", xmlWriter);

                if (localMODE == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMODE);
                }

                xmlWriter.writeEndElement();
            }

            if (localJUMJUMCDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "JUMJUMCD", xmlWriter);

                if (localJUMJUMCD == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "JUMJUMCD cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localJUMJUMCD);
                }

                xmlWriter.writeEndElement();
            }

            if (localPMKPMKCDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "PMKPMKCD", xmlWriter);

                if (localPMKPMKCD == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "PMKPMKCD cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localPMKPMKCD);
                }

                xmlWriter.writeEndElement();
            }

            if (localPMKPMKNYTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "PMKPMKNY", xmlWriter);

                if (localPMKPMKNY == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "PMKPMKNY cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localPMKPMKNY);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSRUSRIDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USRUSRID", xmlWriter);

                if (localUSRUSRID == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSRUSRID);
                }

                xmlWriter.writeEndElement();
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localMODETracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MODE"));

                if (localMODE != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMODE));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                }
            }

            if (localJUMJUMCDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "JUMJUMCD"));

                if (localJUMJUMCD != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localJUMJUMCD));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "JUMJUMCD cannot be null!!");
                }
            }

            if (localPMKPMKCDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "PMKPMKCD"));

                if (localPMKPMKCD != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localPMKPMKCD));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "PMKPMKCD cannot be null!!");
                }
            }

            if (localPMKPMKNYTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "PMKPMKNY"));

                if (localPMKPMKNY != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localPMKPMKNY));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "PMKPMKNY cannot be null!!");
                }
            }

            if (localUSRUSRIDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USRUSRID"));

                if (localUSRUSRID != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSRUSRID));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0024 parse(javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0024 object = new EPS0024();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0024".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0024) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MODE").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MODE" + "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMODE(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "JUMJUMCD").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "JUMJUMCD" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setJUMJUMCD(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "PMKPMKCD").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "PMKPMKCD" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setPMKPMKCD(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "PMKPMKNY").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "PMKPMKNY" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setPMKPMKNY(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USRUSRID").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USRUSRID" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSRUSRID(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0034 implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0034", "ns1");

        /**
         * field for MODE
         */
        protected java.lang.String localMODE;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMODETracker = false;

        /**
         * field for BMSBMSYY
         */
        protected java.lang.String localBMSBMSYY;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localBMSBMSYYTracker = false;

        /**
         * field for BMSSRLNO
         */
        protected java.lang.String localBMSSRLNO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localBMSSRLNOTracker = false;

        /**
         * field for APPAPPNO
         */
        protected java.lang.String localAPPAPPNO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localAPPAPPNOTracker = false;

        /**
         * field for USRUSRID
         */
        protected java.lang.String localUSRUSRID;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSRUSRIDTracker = false;

        public boolean isMODESpecified() {
            return localMODETracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMODE() {
            return localMODE;
        }

        /**
         * Auto generated setter method
         * @param param MODE
         */
        public void setMODE(java.lang.String param) {
            localMODETracker = param != null;

            this.localMODE = param;
        }

        public boolean isBMSBMSYYSpecified() {
            return localBMSBMSYYTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getBMSBMSYY() {
            return localBMSBMSYY;
        }

        /**
         * Auto generated setter method
         * @param param BMSBMSYY
         */
        public void setBMSBMSYY(java.lang.String param) {
            localBMSBMSYYTracker = param != null;

            this.localBMSBMSYY = param;
        }

        public boolean isBMSSRLNOSpecified() {
            return localBMSSRLNOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getBMSSRLNO() {
            return localBMSSRLNO;
        }

        /**
         * Auto generated setter method
         * @param param BMSSRLNO
         */
        public void setBMSSRLNO(java.lang.String param) {
            localBMSSRLNOTracker = param != null;

            this.localBMSSRLNO = param;
        }

        public boolean isAPPAPPNOSpecified() {
            return localAPPAPPNOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getAPPAPPNO() {
            return localAPPAPPNO;
        }

        /**
         * Auto generated setter method
         * @param param APPAPPNO
         */
        public void setAPPAPPNO(java.lang.String param) {
            localAPPAPPNOTracker = param != null;

            this.localAPPAPPNO = param;
        }

        public boolean isUSRUSRIDSpecified() {
            return localUSRUSRIDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSRUSRID() {
            return localUSRUSRID;
        }

        /**
         * Auto generated setter method
         * @param param USRUSRID
         */
        public void setUSRUSRID(java.lang.String param) {
            localUSRUSRIDTracker = param != null;

            this.localUSRUSRID = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0034", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0034", xmlWriter);
                }
            }

            if (localMODETracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MODE", xmlWriter);

                if (localMODE == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMODE);
                }

                xmlWriter.writeEndElement();
            }

            if (localBMSBMSYYTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "BMSBMSYY", xmlWriter);

                if (localBMSBMSYY == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSBMSYY cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localBMSBMSYY);
                }

                xmlWriter.writeEndElement();
            }

            if (localBMSSRLNOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "BMSSRLNO", xmlWriter);

                if (localBMSSRLNO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSSRLNO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localBMSSRLNO);
                }

                xmlWriter.writeEndElement();
            }

            if (localAPPAPPNOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "APPAPPNO", xmlWriter);

                if (localAPPAPPNO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "APPAPPNO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localAPPAPPNO);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSRUSRIDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USRUSRID", xmlWriter);

                if (localUSRUSRID == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSRUSRID);
                }

                xmlWriter.writeEndElement();
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localMODETracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MODE"));

                if (localMODE != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMODE));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                }
            }

            if (localBMSBMSYYTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "BMSBMSYY"));

                if (localBMSBMSYY != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localBMSBMSYY));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSBMSYY cannot be null!!");
                }
            }

            if (localBMSSRLNOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "BMSSRLNO"));

                if (localBMSSRLNO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localBMSSRLNO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSSRLNO cannot be null!!");
                }
            }

            if (localAPPAPPNOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "APPAPPNO"));

                if (localAPPAPPNO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localAPPAPPNO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "APPAPPNO cannot be null!!");
                }
            }

            if (localUSRUSRIDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USRUSRID"));

                if (localUSRUSRID != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSRUSRID));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0034 parse(javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0034 object = new EPS0034();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0034".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0034) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MODE").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MODE" + "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMODE(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "BMSBMSYY").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "BMSBMSYY" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setBMSBMSYY(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "BMSSRLNO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "BMSSRLNO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setBMSSRLNO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "APPAPPNO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "APPAPPNO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setAPPAPPNO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USRUSRID").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USRUSRID" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSRUSRID(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class ExtensionMapper {
        public static java.lang.Object getTypeObject(
            java.lang.String namespaceURI, java.lang.String typeName,
            javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception {
            if ("http://wpms.woorifg.com/WPMS.WebService".equals(namespaceURI) &&
                    "ArrayOfString".equals(typeName)) {
                return ArrayOfString.Factory.parse(reader);
            }

            throw new org.apache.axis2.databinding.ADBException(
                "Unsupported type " + namespaceURI + " " + typeName);
        }
    }

    public static class EPS0034Response implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0034Response", "ns1");

        /**
         * field for EPS0034Result
         */
        protected ArrayOfString localEPS0034Result;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localEPS0034ResultTracker = false;

        public boolean isEPS0034ResultSpecified() {
            return localEPS0034ResultTracker;
        }

        /**
         * Auto generated getter method
         * @return ArrayOfString
         */
        public ArrayOfString getEPS0034Result() {
            return localEPS0034Result;
        }

        /**
         * Auto generated setter method
         * @param param EPS0034Result
         */
        public void setEPS0034Result(ArrayOfString param) {
            localEPS0034ResultTracker = param != null;

            this.localEPS0034Result = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0034Response", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0034Response", xmlWriter);
                }
            }

            if (localEPS0034ResultTracker) {
                if (localEPS0034Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0034Result cannot be null!!");
                }

                localEPS0034Result.serialize(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0034Result"), xmlWriter);
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localEPS0034ResultTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0034Result"));

                if (localEPS0034Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0034Result cannot be null!!");
                }

                elementList.add(localEPS0034Result);
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0034Response parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0034Response object = new EPS0034Response();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0034Response".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0034Response) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "EPS0034Result").equals(reader.getName())) {
                        object.setEPS0034Result(ArrayOfString.Factory.parse(
                                reader));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0019_1 implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0019_1", "ns1");

        /**
         * field for MODE
         */
        protected java.lang.String localMODE;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMODETracker = false;

        /**
         * field for BMSBMSYY
         */
        protected java.lang.String localBMSBMSYY;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localBMSBMSYYTracker = false;

        /**
         * field for BMSSRLNO
         */
        protected java.lang.String localBMSSRLNO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localBMSSRLNOTracker = false;

        /**
         * field for APPAPPNO
         */
        protected java.lang.String localAPPAPPNO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localAPPAPPNOTracker = false;

        /**
         * field for USRUSRID
         */
        protected java.lang.String localUSRUSRID;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSRUSRIDTracker = false;

        /**
         * field for INF_REF_NO
         */
        protected java.lang.String localINF_REF_NO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localINF_REF_NOTracker = false;

        public boolean isMODESpecified() {
            return localMODETracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMODE() {
            return localMODE;
        }

        /**
         * Auto generated setter method
         * @param param MODE
         */
        public void setMODE(java.lang.String param) {
            localMODETracker = param != null;

            this.localMODE = param;
        }

        public boolean isBMSBMSYYSpecified() {
            return localBMSBMSYYTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getBMSBMSYY() {
            return localBMSBMSYY;
        }

        /**
         * Auto generated setter method
         * @param param BMSBMSYY
         */
        public void setBMSBMSYY(java.lang.String param) {
            localBMSBMSYYTracker = param != null;

            this.localBMSBMSYY = param;
        }

        public boolean isBMSSRLNOSpecified() {
            return localBMSSRLNOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getBMSSRLNO() {
            return localBMSSRLNO;
        }

        /**
         * Auto generated setter method
         * @param param BMSSRLNO
         */
        public void setBMSSRLNO(java.lang.String param) {
            localBMSSRLNOTracker = param != null;

            this.localBMSSRLNO = param;
        }

        public boolean isAPPAPPNOSpecified() {
            return localAPPAPPNOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getAPPAPPNO() {
            return localAPPAPPNO;
        }

        /**
         * Auto generated setter method
         * @param param APPAPPNO
         */
        public void setAPPAPPNO(java.lang.String param) {
            localAPPAPPNOTracker = param != null;

            this.localAPPAPPNO = param;
        }

        public boolean isUSRUSRIDSpecified() {
            return localUSRUSRIDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSRUSRID() {
            return localUSRUSRID;
        }

        /**
         * Auto generated setter method
         * @param param USRUSRID
         */
        public void setUSRUSRID(java.lang.String param) {
            localUSRUSRIDTracker = param != null;

            this.localUSRUSRID = param;
        }

        public boolean isINF_REF_NOSpecified() {
            return localINF_REF_NOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getINF_REF_NO() {
            return localINF_REF_NO;
        }

        /**
         * Auto generated setter method
         * @param param INF_REF_NO
         */
        public void setINF_REF_NO(java.lang.String param) {
            localINF_REF_NOTracker = param != null;

            this.localINF_REF_NO = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0019_1", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0019_1", xmlWriter);
                }
            }

            if (localMODETracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MODE", xmlWriter);

                if (localMODE == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMODE);
                }

                xmlWriter.writeEndElement();
            }

            if (localBMSBMSYYTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "BMSBMSYY", xmlWriter);

                if (localBMSBMSYY == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSBMSYY cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localBMSBMSYY);
                }

                xmlWriter.writeEndElement();
            }

            if (localBMSSRLNOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "BMSSRLNO", xmlWriter);

                if (localBMSSRLNO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSSRLNO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localBMSSRLNO);
                }

                xmlWriter.writeEndElement();
            }

            if (localAPPAPPNOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "APPAPPNO", xmlWriter);

                if (localAPPAPPNO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "APPAPPNO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localAPPAPPNO);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSRUSRIDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USRUSRID", xmlWriter);

                if (localUSRUSRID == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSRUSRID);
                }

                xmlWriter.writeEndElement();
            }

            if (localINF_REF_NOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "INF_REF_NO", xmlWriter);

                if (localINF_REF_NO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "INF_REF_NO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localINF_REF_NO);
                }

                xmlWriter.writeEndElement();
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localMODETracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MODE"));

                if (localMODE != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMODE));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                }
            }

            if (localBMSBMSYYTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "BMSBMSYY"));

                if (localBMSBMSYY != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localBMSBMSYY));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSBMSYY cannot be null!!");
                }
            }

            if (localBMSSRLNOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "BMSSRLNO"));

                if (localBMSSRLNO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localBMSSRLNO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "BMSSRLNO cannot be null!!");
                }
            }

            if (localAPPAPPNOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "APPAPPNO"));

                if (localAPPAPPNO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localAPPAPPNO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "APPAPPNO cannot be null!!");
                }
            }

            if (localUSRUSRIDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USRUSRID"));

                if (localUSRUSRID != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSRUSRID));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                }
            }

            if (localINF_REF_NOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "INF_REF_NO"));

                if (localINF_REF_NO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localINF_REF_NO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "INF_REF_NO cannot be null!!");
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0019_1 parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0019_1 object = new EPS0019_1();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0019_1".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0019_1) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MODE").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MODE" + "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMODE(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "BMSBMSYY").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "BMSBMSYY" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setBMSBMSYY(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "BMSSRLNO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "BMSSRLNO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setBMSSRLNO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "APPAPPNO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "APPAPPNO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setAPPAPPNO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USRUSRID").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USRUSRID" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSRUSRID(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "INF_REF_NO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "INF_REF_NO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setINF_REF_NO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0020 implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0020", "ns1");

        /**
         * field for MODE
         */
        protected java.lang.String localMODE;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMODETracker = false;

        /**
         * field for JUMJUMCD
         */
        protected java.lang.String localJUMJUMCD;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localJUMJUMCDTracker = false;

        /**
         * field for ASTASTGB
         */
        protected java.lang.String localASTASTGB;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localASTASTGBTracker = false;

        /**
         * field for USRUSRID
         */
        protected java.lang.String localUSRUSRID;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSRUSRIDTracker = false;

        public boolean isMODESpecified() {
            return localMODETracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMODE() {
            return localMODE;
        }

        /**
         * Auto generated setter method
         * @param param MODE
         */
        public void setMODE(java.lang.String param) {
            localMODETracker = param != null;

            this.localMODE = param;
        }

        public boolean isJUMJUMCDSpecified() {
            return localJUMJUMCDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getJUMJUMCD() {
            return localJUMJUMCD;
        }

        /**
         * Auto generated setter method
         * @param param JUMJUMCD
         */
        public void setJUMJUMCD(java.lang.String param) {
            localJUMJUMCDTracker = param != null;

            this.localJUMJUMCD = param;
        }

        public boolean isASTASTGBSpecified() {
            return localASTASTGBTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getASTASTGB() {
            return localASTASTGB;
        }

        /**
         * Auto generated setter method
         * @param param ASTASTGB
         */
        public void setASTASTGB(java.lang.String param) {
            localASTASTGBTracker = param != null;

            this.localASTASTGB = param;
        }

        public boolean isUSRUSRIDSpecified() {
            return localUSRUSRIDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSRUSRID() {
            return localUSRUSRID;
        }

        /**
         * Auto generated setter method
         * @param param USRUSRID
         */
        public void setUSRUSRID(java.lang.String param) {
            localUSRUSRIDTracker = param != null;

            this.localUSRUSRID = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0020", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0020", xmlWriter);
                }
            }

            if (localMODETracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MODE", xmlWriter);

                if (localMODE == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMODE);
                }

                xmlWriter.writeEndElement();
            }

            if (localJUMJUMCDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "JUMJUMCD", xmlWriter);

                if (localJUMJUMCD == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "JUMJUMCD cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localJUMJUMCD);
                }

                xmlWriter.writeEndElement();
            }

            if (localASTASTGBTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "ASTASTGB", xmlWriter);

                if (localASTASTGB == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "ASTASTGB cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localASTASTGB);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSRUSRIDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USRUSRID", xmlWriter);

                if (localUSRUSRID == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSRUSRID);
                }

                xmlWriter.writeEndElement();
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localMODETracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MODE"));

                if (localMODE != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMODE));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                }
            }

            if (localJUMJUMCDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "JUMJUMCD"));

                if (localJUMJUMCD != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localJUMJUMCD));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "JUMJUMCD cannot be null!!");
                }
            }

            if (localASTASTGBTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "ASTASTGB"));

                if (localASTASTGB != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localASTASTGB));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "ASTASTGB cannot be null!!");
                }
            }

            if (localUSRUSRIDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USRUSRID"));

                if (localUSRUSRID != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSRUSRID));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0020 parse(javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0020 object = new EPS0020();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0020".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0020) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MODE").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MODE" + "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMODE(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "JUMJUMCD").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "JUMJUMCD" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setJUMJUMCD(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "ASTASTGB").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "ASTASTGB" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setASTASTGB(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USRUSRID").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USRUSRID" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSRUSRID(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0021 implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0021", "ns1");

        /**
         * field for MODE
         */
        protected java.lang.String localMODE;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localMODETracker = false;

        /**
         * field for UNQUNQNO
         */
        protected java.lang.String localUNQUNQNO;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUNQUNQNOTracker = false;

        /**
         * field for DURTERMY
         */
        protected java.lang.String localDURTERMY;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localDURTERMYTracker = false;

        /**
         * field for USEUSEVL
         */
        protected java.lang.String localUSEUSEVL;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSEUSEVLTracker = false;

        /**
         * field for USRUSRID
         */
        protected java.lang.String localUSRUSRID;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localUSRUSRIDTracker = false;

        public boolean isMODESpecified() {
            return localMODETracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getMODE() {
            return localMODE;
        }

        /**
         * Auto generated setter method
         * @param param MODE
         */
        public void setMODE(java.lang.String param) {
            localMODETracker = param != null;

            this.localMODE = param;
        }

        public boolean isUNQUNQNOSpecified() {
            return localUNQUNQNOTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUNQUNQNO() {
            return localUNQUNQNO;
        }

        /**
         * Auto generated setter method
         * @param param UNQUNQNO
         */
        public void setUNQUNQNO(java.lang.String param) {
            localUNQUNQNOTracker = param != null;

            this.localUNQUNQNO = param;
        }

        public boolean isDURTERMYSpecified() {
            return localDURTERMYTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getDURTERMY() {
            return localDURTERMY;
        }

        /**
         * Auto generated setter method
         * @param param DURTERMY
         */
        public void setDURTERMY(java.lang.String param) {
            localDURTERMYTracker = param != null;

            this.localDURTERMY = param;
        }

        public boolean isUSEUSEVLSpecified() {
            return localUSEUSEVLTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSEUSEVL() {
            return localUSEUSEVL;
        }

        /**
         * Auto generated setter method
         * @param param USEUSEVL
         */
        public void setUSEUSEVL(java.lang.String param) {
            localUSEUSEVLTracker = param != null;

            this.localUSEUSEVL = param;
        }

        public boolean isUSRUSRIDSpecified() {
            return localUSRUSRIDTracker;
        }

        /**
         * Auto generated getter method
         * @return java.lang.String
         */
        public java.lang.String getUSRUSRID() {
            return localUSRUSRID;
        }

        /**
         * Auto generated setter method
         * @param param USRUSRID
         */
        public void setUSRUSRID(java.lang.String param) {
            localUSRUSRIDTracker = param != null;

            this.localUSRUSRID = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0021", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0021", xmlWriter);
                }
            }

            if (localMODETracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "MODE", xmlWriter);

                if (localMODE == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localMODE);
                }

                xmlWriter.writeEndElement();
            }

            if (localUNQUNQNOTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "UNQUNQNO", xmlWriter);

                if (localUNQUNQNO == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "UNQUNQNO cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUNQUNQNO);
                }

                xmlWriter.writeEndElement();
            }

            if (localDURTERMYTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "DURTERMY", xmlWriter);

                if (localDURTERMY == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "DURTERMY cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localDURTERMY);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSEUSEVLTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USEUSEVL", xmlWriter);

                if (localUSEUSEVL == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USEUSEVL cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSEUSEVL);
                }

                xmlWriter.writeEndElement();
            }

            if (localUSRUSRIDTracker) {
                namespace = "http://wpms.woorifg.com/WPMS.WebService";
                writeStartElement(null, namespace, "USRUSRID", xmlWriter);

                if (localUSRUSRID == null) {
                    // write the nil attribute
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                } else {
                    xmlWriter.writeCharacters(localUSRUSRID);
                }

                xmlWriter.writeEndElement();
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localMODETracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "MODE"));

                if (localMODE != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localMODE));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "MODE cannot be null!!");
                }
            }

            if (localUNQUNQNOTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "UNQUNQNO"));

                if (localUNQUNQNO != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUNQUNQNO));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "UNQUNQNO cannot be null!!");
                }
            }

            if (localDURTERMYTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "DURTERMY"));

                if (localDURTERMY != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localDURTERMY));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "DURTERMY cannot be null!!");
                }
            }

            if (localUSEUSEVLTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USEUSEVL"));

                if (localUSEUSEVL != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSEUSEVL));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USEUSEVL cannot be null!!");
                }
            }

            if (localUSRUSRIDTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService", "USRUSRID"));

                if (localUSRUSRID != null) {
                    elementList.add(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            localUSRUSRID));
                } else {
                    throw new org.apache.axis2.databinding.ADBException(
                        "USRUSRID cannot be null!!");
                }
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0021 parse(javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0021 object = new EPS0021();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0021".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0021) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "MODE").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "MODE" + "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setMODE(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "UNQUNQNO").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "UNQUNQNO" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUNQUNQNO(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "DURTERMY").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "DURTERMY" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setDURTERMY(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USEUSEVL").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USEUSEVL" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSEUSEVL(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "USRUSRID").equals(reader.getName())) {
                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "nil");

                        if ("true".equals(nillableValue) ||
                                "1".equals(nillableValue)) {
                            throw new org.apache.axis2.databinding.ADBException(
                                "The element: " + "USRUSRID" +
                                "  cannot be null");
                        }

                        java.lang.String content = reader.getElementText();

                        object.setUSRUSRID(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                content));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0021Response implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0021Response", "ns1");

        /**
         * field for EPS0021Result
         */
        protected ArrayOfString localEPS0021Result;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localEPS0021ResultTracker = false;

        public boolean isEPS0021ResultSpecified() {
            return localEPS0021ResultTracker;
        }

        /**
         * Auto generated getter method
         * @return ArrayOfString
         */
        public ArrayOfString getEPS0021Result() {
            return localEPS0021Result;
        }

        /**
         * Auto generated setter method
         * @param param EPS0021Result
         */
        public void setEPS0021Result(ArrayOfString param) {
            localEPS0021ResultTracker = param != null;

            this.localEPS0021Result = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0021Response", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0021Response", xmlWriter);
                }
            }

            if (localEPS0021ResultTracker) {
                if (localEPS0021Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0021Result cannot be null!!");
                }

                localEPS0021Result.serialize(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0021Result"), xmlWriter);
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localEPS0021ResultTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0021Result"));

                if (localEPS0021Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0021Result cannot be null!!");
                }

                elementList.add(localEPS0021Result);
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0021Response parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0021Response object = new EPS0021Response();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0021Response".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0021Response) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "EPS0021Result").equals(reader.getName())) {
                        object.setEPS0021Result(ArrayOfString.Factory.parse(
                                reader));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0020Response implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0020Response", "ns1");

        /**
         * field for EPS0020Result
         */
        protected ArrayOfString localEPS0020Result;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localEPS0020ResultTracker = false;

        public boolean isEPS0020ResultSpecified() {
            return localEPS0020ResultTracker;
        }

        /**
         * Auto generated getter method
         * @return ArrayOfString
         */
        public ArrayOfString getEPS0020Result() {
            return localEPS0020Result;
        }

        /**
         * Auto generated setter method
         * @param param EPS0020Result
         */
        public void setEPS0020Result(ArrayOfString param) {
            localEPS0020ResultTracker = param != null;

            this.localEPS0020Result = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0020Response", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0020Response", xmlWriter);
                }
            }

            if (localEPS0020ResultTracker) {
                if (localEPS0020Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0020Result cannot be null!!");
                }

                localEPS0020Result.serialize(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0020Result"), xmlWriter);
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localEPS0020ResultTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0020Result"));

                if (localEPS0020Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0020Result cannot be null!!");
                }

                elementList.add(localEPS0020Result);
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0020Response parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0020Response object = new EPS0020Response();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0020Response".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0020Response) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "EPS0020Result").equals(reader.getName())) {
                        object.setEPS0020Result(ArrayOfString.Factory.parse(
                                reader));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0019Response implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0019Response", "ns1");

        /**
         * field for EPS0019Result
         */
        protected ArrayOfString localEPS0019Result;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localEPS0019ResultTracker = false;

        public boolean isEPS0019ResultSpecified() {
            return localEPS0019ResultTracker;
        }

        /**
         * Auto generated getter method
         * @return ArrayOfString
         */
        public ArrayOfString getEPS0019Result() {
            return localEPS0019Result;
        }

        /**
         * Auto generated setter method
         * @param param EPS0019Result
         */
        public void setEPS0019Result(ArrayOfString param) {
            localEPS0019ResultTracker = param != null;

            this.localEPS0019Result = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0019Response", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0019Response", xmlWriter);
                }
            }

            if (localEPS0019ResultTracker) {
                if (localEPS0019Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0019Result cannot be null!!");
                }

                localEPS0019Result.serialize(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0019Result"), xmlWriter);
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localEPS0019ResultTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0019Result"));

                if (localEPS0019Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0019Result cannot be null!!");
                }

                elementList.add(localEPS0019Result);
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0019Response parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0019Response object = new EPS0019Response();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0019Response".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0019Response) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "EPS0019Result").equals(reader.getName())) {
                        object.setEPS0019Result(ArrayOfString.Factory.parse(
                                reader));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }

    public static class EPS0037Response implements org.apache.axis2.databinding.ADBBean {
        public static final javax.xml.namespace.QName MY_QNAME = new javax.xml.namespace.QName("http://wpms.woorifg.com/WPMS.WebService",
                "EPS0037Response", "ns1");

        /**
         * field for EPS0037Result
         */
        protected ArrayOfString localEPS0037Result;

        /*  This tracker boolean wil be used to detect whether the user called the set method
         *   for this attribute. It will be used to determine whether to include this field
         *   in the serialized XML
         */
        protected boolean localEPS0037ResultTracker = false;

        public boolean isEPS0037ResultSpecified() {
            return localEPS0037ResultTracker;
        }

        /**
         * Auto generated getter method
         * @return ArrayOfString
         */
        public ArrayOfString getEPS0037Result() {
            return localEPS0037Result;
        }

        /**
         * Auto generated setter method
         * @param param EPS0037Result
         */
        public void setEPS0037Result(ArrayOfString param) {
            localEPS0037ResultTracker = param != null;

            this.localEPS0037Result = param;
        }

        /**
         *
         * @param parentQName
         * @param factory
         * @return org.apache.axiom.om.OMElement
         */
        public org.apache.axiom.om.OMElement getOMElement(
            final javax.xml.namespace.QName parentQName,
            final org.apache.axiom.om.OMFactory factory)
            throws org.apache.axis2.databinding.ADBException {
            org.apache.axiom.om.OMDataSource dataSource = new org.apache.axis2.databinding.ADBDataSource(this,
                    MY_QNAME);

            return factory.createOMElement(dataSource, MY_QNAME);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            serialize(parentQName, xmlWriter, false);
        }

        public void serialize(final javax.xml.namespace.QName parentQName,
            javax.xml.stream.XMLStreamWriter xmlWriter, boolean serializeType)
            throws javax.xml.stream.XMLStreamException,
                org.apache.axis2.databinding.ADBException {
            java.lang.String prefix = null;
            java.lang.String namespace = null;

            prefix = parentQName.getPrefix();
            namespace = parentQName.getNamespaceURI();
            writeStartElement(prefix, namespace, parentQName.getLocalPart(),
                xmlWriter);

            if (serializeType) {
                java.lang.String namespacePrefix = registerPrefix(xmlWriter,
                        "http://wpms.woorifg.com/WPMS.WebService");

                if ((namespacePrefix != null) &&
                        (namespacePrefix.trim().length() > 0)) {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        namespacePrefix + ":EPS0037Response", xmlWriter);
                } else {
                    writeAttribute("xsi",
                        "http://www.w3.org/2001/XMLSchema-instance", "type",
                        "EPS0037Response", xmlWriter);
                }
            }

            if (localEPS0037ResultTracker) {
                if (localEPS0037Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0037Result cannot be null!!");
                }

                localEPS0037Result.serialize(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0037Result"), xmlWriter);
            }

            xmlWriter.writeEndElement();
        }

        private static java.lang.String generatePrefix(
            java.lang.String namespace) {
            if (namespace.equals("http://wpms.woorifg.com/WPMS.WebService")) {
                return "ns1";
            }

            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix,
            java.lang.String namespace, java.lang.String localPart,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
        private void writeAttribute(java.lang.String prefix,
            java.lang.String namespace, java.lang.String attName,
            java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }

            xmlWriter.writeAttribute(namespace, attName, attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,
            java.lang.String attName, java.lang.String attValue,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName, attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace, attName, attValue);
            }
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeQNameAttribute(java.lang.String namespace,
            java.lang.String attName, javax.xml.namespace.QName qname,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();

            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);

                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix, namespaceURI);
                }

                if (prefix.trim().length() > 0) {
                    xmlWriter.writeCharacters(prefix + ":" +
                        org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                            qname));
                }
            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                        qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
            javax.xml.stream.XMLStreamWriter xmlWriter)
            throws javax.xml.stream.XMLStreamException {
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
                            xmlWriter.setPrefix(prefix, namespaceURI);
                        }

                        if (prefix.trim().length() > 0) {
                            stringToWrite.append(prefix).append(":")
                                         .append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                    qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(
                                qnames[i]));
                    }
                }

                xmlWriter.writeCharacters(stringToWrite.toString());
            }
        }

        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(
            javax.xml.stream.XMLStreamWriter xmlWriter,
            java.lang.String namespace)
            throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);

            if (prefix == null) {
                prefix = generatePrefix(namespace);

                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();

                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);

                    if ((uri == null) || (uri.length() == 0)) {
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
        public javax.xml.stream.XMLStreamReader getPullParser(
            javax.xml.namespace.QName qName)
            throws org.apache.axis2.databinding.ADBException {
            java.util.ArrayList elementList = new java.util.ArrayList();
            java.util.ArrayList attribList = new java.util.ArrayList();

            if (localEPS0037ResultTracker) {
                elementList.add(new javax.xml.namespace.QName(
                        "http://wpms.woorifg.com/WPMS.WebService",
                        "EPS0037Result"));

                if (localEPS0037Result == null) {
                    throw new org.apache.axis2.databinding.ADBException(
                        "EPS0037Result cannot be null!!");
                }

                elementList.add(localEPS0037Result);
            }

            return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName,
                elementList.toArray(), attribList.toArray());
        }

        /**
         *  Factory class that keeps the parse method
         */
        public static class Factory {
            /**
             * static method to create the object
             * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
             *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
             * Postcondition: If this object is an element, the reader is positioned at its end element
             *                If this object is a complex type, the reader is positioned at the end element of its outer element
             */
            public static EPS0037Response parse(
                javax.xml.stream.XMLStreamReader reader)
                throws java.lang.Exception {
                EPS0037Response object = new EPS0037Response();

                int event;
                java.lang.String nillableValue = null;
                java.lang.String prefix = "";
                java.lang.String namespaceuri = "";

                try {
                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.getAttributeValue(
                                "http://www.w3.org/2001/XMLSchema-instance",
                                "type") != null) {
                        java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                                "type");

                        if (fullTypeName != null) {
                            java.lang.String nsPrefix = null;

                            if (fullTypeName.indexOf(":") > -1) {
                                nsPrefix = fullTypeName.substring(0,
                                        fullTypeName.indexOf(":"));
                            }

                            nsPrefix = (nsPrefix == null) ? "" : nsPrefix;

                            java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(
                                        ":") + 1);

                            if (!"EPS0037Response".equals(type)) {
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext()
                                                               .getNamespaceURI(nsPrefix);

                                return (EPS0037Response) ExtensionMapper.getTypeObject(nsUri,
                                    type, reader);
                            }
                        }
                    }

                    // Note all attributes that were handled. Used to differ normal attributes
                    // from anyAttributes.
                    java.util.Vector handledAttributes = new java.util.Vector();

                    reader.next();

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement() &&
                            new javax.xml.namespace.QName(
                                "http://wpms.woorifg.com/WPMS.WebService",
                                "EPS0037Result").equals(reader.getName())) {
                        object.setEPS0037Result(ArrayOfString.Factory.parse(
                                reader));

                        reader.next();
                    } // End of if for expected property start element

                    else {
                    }

                    while (!reader.isStartElement() && !reader.isEndElement())
                        reader.next();

                    if (reader.isStartElement()) {
                        // A start element we are not expecting indicates a trailing invalid property
                        throw new org.apache.axis2.databinding.ADBException(
                            "Unexpected subelement " + reader.getName());
                    }
                } catch (javax.xml.stream.XMLStreamException e) {
                    throw new java.lang.Exception(e);
                }

                return object;
            }
        } //end of factory class
    }
}
