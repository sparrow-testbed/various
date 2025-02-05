
/**
 * EPS0018_WSCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */

    package com.woorifg.wpms.wpms_webservice;

    /**
     *  EPS0018_WSCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class EPS0018_WSCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public EPS0018_WSCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public EPS0018_WSCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for ePS0018 method
            * override this method for handling normal response from ePS0018 operation
            */
           public void receiveResultePS0018(
                    com.woorifg.wpms.wpms_webservice.EPS0018_WSStub.EPS0018Response result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from ePS0018 operation
           */
            public void receiveErrorePS0018(java.lang.Exception e) {
            }
                


    }
    