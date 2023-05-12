 
 /*------------------------------------------------------------------------
    File        : TempTableStaticIndex
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Thu May 04 09:55:35 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.TempTableStaticIndex: 
  
  DEFINE TEMP-TABLE tt-Customer LIKE Customer.
    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableStaticIndex (  ):
    SUPER ().
    mFillTT().
    //mStuffTT().
    mIndexTest().
     
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
   Purpose:Creates new Entrys in the TempTable after checking if there is already an entry with the same CustNum.
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PRIVATE VOID mStuffTT():
    DEFINE VARIABLE iX AS INTEGER NO-UNDO.
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    DO iX = 10000 TO 1000000:
     
        CREATE btt-Customer.
          ASSIGN
            btt-Customer.CustNum  = iX
            btt-Customer.Name = "Test" + String(iX)
            btt-Customer.Balance = iX * 0.01
          . 
    END.
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose:Displays the Entries in the TempTable
   Notes:
  ------------------------------------------------------------------------------*/ 
  METHOD PUBLIC VOID mDisplayTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    FOR EACH btt-Customer BY CustNum:
      DISPLAY btt-Customer EXCEPT btt-Customer.Comments.
    END.
  END METHOD.
  
  METHOD PUBLIC VOID mIndexTest():
    DEFINE VARIABLE iStart AS INTEGER NO-UNDO.
    DEFINE VARIABLE iEnd   AS INTEGER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    iStart = MTIME.
    FIND btt-Customer WHERE btt-Customer.CustNum = 3035 USE-INDEX CustNum NO-LOCK NO-ERROR.
    iEnd = MTIME.
/*    IF AVAILABLE btt-Customer THEN DO:                  */
/*      DISPLAY btt-Customer EXCEPT btt-Customer.Comments.*/
/*    END.                                                */

    MESSAGE iEnd - iStart 
    VIEW-AS ALERT-BOX.
  END METHOD.

END CLASS.