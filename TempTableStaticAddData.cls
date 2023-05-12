 
 /*------------------------------------------------------------------------
    File        : TempTableStaticAddData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Thu May 04 10:48:09 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.TempTableStaticAddData: 
  
  DEFINE TEMP-TABLE tt-Customer
    FIELD CustNum AS INTEGER
    FIELD Name AS CHARACTER
    FIELD Balance AS DECIMAL
    INDEX CustNum CustNum.
      
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableStaticAddData (  ):
    SUPER ().
    mFillTT().
    mAddDataToTT().
    mDisplayTT().
    
  END CONSTRUCTOR.
  
  
  /*------------------------------------------------------------------------------
   Purpose:Copys the specific Entrys from the Database into the TempTable.
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PRIVATE VOID mFillTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    DEFINE BUFFER bCustomer FOR Customer.
    
    FOR EACH bCustomer:
      CREATE btt-Customer.
       ASSIGN
        btt-Customer.CustNum  = bCustomer.CustNum
        btt-Customer.Name = bCustomer.Name
        btt-Customer.Balance = bCustomer.Balance
        . 
      
    END.
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose:Creates new Entrys in the TempTable after checking if there is already an entry with the same CustNum.
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PRIVATE VOID mAddDataToTT():
    DEFINE VARIABLE iX AS INTEGER NO-UNDO.
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    DO iX = 1 TO 1000:
      FIND btt-Customer WHERE btt-Customer.CustNum = iX NO-LOCK NO-ERROR.
      IF NOT AVAILABLE btt-Customer THEN DO:
        CREATE btt-Customer.
          ASSIGN
            btt-Customer.CustNum  = iX
            btt-Customer.Name = "Test " + STRING(iX)
            btt-Customer.Balance = iX * 10
            . 
      END.
    END.
    
  END METHOD.
  
  
  /*------------------------------------------------------------------------------
   Purpose:Displays the Entries in the TempTable
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mDisplayTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
     
    FOR EACH btt-Customer BY CustNum:
      DISPLAY btt-Customer.
    END.
  END METHOD.


END CLASS.