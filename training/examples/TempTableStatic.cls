 
 /*------------------------------------------------------------------------
    File        : TempTableStatic
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Thu May 04 07:22:22 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS examples.TempTableStatic: 
  
  DEFINE TEMP-TABLE tt-Customer NO-UNDO
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum IS PRIMARY UNIQUE CustNum.
      
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableStatic (  ):
    SUPER ().

    mFillTT().
    mDisplayTT().
    

  END CONSTRUCTOR.
  
  
  /*------------------------------------------------------------------------------
   Purpose:Copys the specific entries from the Database into the TempTable.
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE VOID mFillTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer    FOR Customer.
    
    FOR EACH bCustomer NO-LOCK:
      CREATE btt-Customer.
      ASSIGN
        btt-Customer.CustNum  = bCustomer.CustNum
        btt-Customer.Name     = bCustomer.Name
        btt-Customer.Balance  = bCustomer.Balance
        btt-Customer.Country  = bCustomer.Country
        . 
    END.
    
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose:Displays the entries in the TempTable
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID mDisplayTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
     
    FOR EACH btt-Customer BY CustNum:
      DISPLAY btt-Customer.
    END.
  END METHOD.


END CLASS.