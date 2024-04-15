package com.tcLib2;


public class pvException extends Exception {

  private static final long serialVersionUID = 1L;

  public pvException()
  {
  }
  public pvException(String sMessages)
  {
      super(sMessages);
  }
  
  public pvException(String ProgramName, String ErrorCode, String ErrorMessage, String ErrorValue)
  {
      super(ProgramName+":"+ErrorCode +":" +ErrorMessage +":"+ErrorValue);
  }
}