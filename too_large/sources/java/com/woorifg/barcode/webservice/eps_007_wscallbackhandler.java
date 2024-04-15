
/**
 * EPS_WSCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */

    package com.woorifg.barcode.webservice;

    /**
     *  EPS_WSCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class EPS_007_WSCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public EPS_007_WSCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public EPS_007_WSCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for helloWorld method
            * override this method for handling normal response from helloWorld operation
            */
           public void receiveResulthelloWorld(
                    com.woorifg.barcode.webservice.EPS_007_WSStub.HelloWorldResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from helloWorld operation
           */
            public void receiveErrorhelloWorld(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for ePS007 method
            * override this method for handling normal response from ePS007 operation
            */
           public void receiveResultePS007(
                    com.woorifg.barcode.webservice.EPS_007_WSStub.EPS007Response result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from ePS007 operation
           */
            public void receiveErrorePS007(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for ePS0029 method
            * override this method for handling normal response from ePS0029 operation
            */
           public void receiveResultePS0029(
                    com.woorifg.barcode.webservice.EPS_007_WSStub.EPS0029Response result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from ePS0029 operation
           */
            public void receiveErrorePS0029(java.lang.Exception e) {
            }
                


    }
    