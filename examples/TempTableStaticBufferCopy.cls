 
 /*------------------------------------------------------------------------
    File        : TempTableStaticBufferCopy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Thu May 04 07:57:56 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.TempTableStaticBufferCopy: 
  
  DEFINE TEMP-TABLE tt-Customer
    FIELD CustNum AS INTEGER
    FIELD Name AS CHARACTER
    FIELD Balance AS DECIMAL
    INDEX CustNum CustNum.
      
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableStaticBufferCopy (  ):
    SUPER ().
    mFillTT().
    mDisplayTT().
    
  END CONSTRUCTOR.
  
  
/*------------------------------------------------------------------------------
   Purpose:Copys the all Entrys that the Databas and the TempTable share from the Database into the TempTable.
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PRIVATE VOID mFillTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer FOR Customer.
    
    FOR EACH bCustomer NO-LOCK:
      CREATE btt-Customer.
      BUFFER-COPY bCustomer TO btt-Customer.
      
    END.
  END METHOD.
  
  
  
  /*------------------------------------------------------------------------------
   Purpose:Displays the Entries in the TempTable
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mDisplayTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
     
    FOR EACH btt-Customer BY CustNum:
      DISPLAY btt-Customer .
    END.
  END METHOD.


END CLASS.