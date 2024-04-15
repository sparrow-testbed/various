
/**
 * EpsCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */

    package poasrm.sepoa.ws.provider;

    /**
     *  EpsCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class EpsCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public EpsCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public EpsCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for m04_REQ_ITEM method
            * override this method for handling normal response from m04_REQ_ITEM operation
            */
           public void receiveResultm04_REQ_ITEM(
                    poasrm.sepoa.ws.provider.EpsStub.M04_REQ_ITEMResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from m04_REQ_ITEM operation
           */
            public void receiveErrorm04_REQ_ITEM(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for ePS0022_2 method
            * override this method for handling normal response from ePS0022_2 operation
            */
           public void receiveResultePS0022_2(
                    poasrm.sepoa.ws.provider.EpsStub.EPS0022_2Response result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from ePS0022_2 operation
           */
            public void receiveErrorePS0022_2(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for m03_REQ_ITEM method
            * override this method for handling normal response from m03_REQ_ITEM operation
            */
           public void receiveResultm03_REQ_ITEM(
                    poasrm.sepoa.ws.provider.EpsStub.M03_REQ_ITEMResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from m03_REQ_ITEM operation
           */
            public void receiveErrorm03_REQ_ITEM(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for eps0030 method
            * override this method for handling normal response from eps0030 operation
            */
           public void receiveResulteps0030(
                    poasrm.sepoa.ws.provider.EpsStub.Eps0030Response result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from eps0030 operation
           */
            public void receiveErroreps0030(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for m04_REQ_PR method
            * override this method for handling normal response from m04_REQ_PR operation
            */
           public void receiveResultm04_REQ_PR(
                    poasrm.sepoa.ws.provider.EpsStub.M04_REQ_PRResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from m04_REQ_PR operation
           */
            public void receiveErrorm04_REQ_PR(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for m02_REQ_ITEM method
            * override this method for handling normal response from m02_REQ_ITEM operation
            */
           public void receiveResultm02_REQ_ITEM(
                    poasrm.sepoa.ws.provider.EpsStub.M02_REQ_ITEMResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from m02_REQ_ITEM operation
           */
            public void receiveErrorm02_REQ_ITEM(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for m01_REQ_ITEM method
            * override this method for handling normal response from m01_REQ_ITEM operation
            */
           public void receiveResultm01_REQ_ITEM(
                    poasrm.sepoa.ws.provider.EpsStub.M01_REQ_ITEMResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from m01_REQ_ITEM operation
           */
            public void receiveErrorm01_REQ_ITEM(java.lang.Exception e) {
            }
                


    }
    