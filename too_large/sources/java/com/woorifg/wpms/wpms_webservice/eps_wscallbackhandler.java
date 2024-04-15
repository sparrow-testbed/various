/**
 * EPS_WSCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.3  Built on : Jun 27, 2015 (11:17:49 BST)
 */
package com.woorifg.wpms.wpms_webservice;


/**
 *  EPS_WSCallbackHandler Callback class, Users can extend this class and implement
 *  their own receiveResult and receiveError methods.
 */
public abstract class EPS_WSCallbackHandler {
    protected Object clientData;

    /**
     * User can pass in any object that needs to be accessed once the NonBlocking
     * Web service call is finished and appropriate method of this CallBack is called.
     * @param clientData Object mechanism by which the user can pass in user data
     * that will be avilable at the time this callback is called.
     */
    public EPS_WSCallbackHandler(Object clientData) {
        this.clientData = clientData;
    }

    /**
     * Please use this constructor if you don't want to set any clientData
     */
    public EPS_WSCallbackHandler() {
        this.clientData = null;
    }

    /**
     * Get the client data
     */
    public Object getClientData() {
        return clientData;
    }

    /**
     * auto generated Axis2 call back method for ePS0034 method
     * override this method for handling normal response from ePS0034 operation
     */
    public void receiveResultePS0034(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from ePS0034 operation
     */
    public void receiveErrorePS0034(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for ePS0019 method
     * override this method for handling normal response from ePS0019 operation
     */
    public void receiveResultePS0019(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019Response result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from ePS0019 operation
     */
    public void receiveErrorePS0019(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for ePS0019_1 method
     * override this method for handling normal response from ePS0019_1 operation
     */
    public void receiveResultePS0019_1(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from ePS0019_1 operation
     */
    public void receiveErrorePS0019_1(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for ePS0037 method
     * override this method for handling normal response from ePS0037 operation
     */
    public void receiveResultePS0037(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from ePS0037 operation
     */
    public void receiveErrorePS0037(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for ePS0024 method
     * override this method for handling normal response from ePS0024 operation
     */
    public void receiveResultePS0024(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from ePS0024 operation
     */
    public void receiveErrorePS0024(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for ePS0021 method
     * override this method for handling normal response from ePS0021 operation
     */
    public void receiveResultePS0021(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0021Response result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from ePS0021 operation
     */
    public void receiveErrorePS0021(java.lang.Exception e) {
    }

    /**
     * auto generated Axis2 call back method for ePS0020 method
     * override this method for handling normal response from ePS0020 operation
     */
    public void receiveResultePS0020(
        com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response result) {
    }

    /**
     * auto generated Axis2 Error handler
     * override this method for handling error response from ePS0020 operation
     */
    public void receiveErrorePS0020(java.lang.Exception e) {
    }
}
