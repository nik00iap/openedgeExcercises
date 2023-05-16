 
 /*------------------------------------------------------------------------
    File        : PersistentProcedureUse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Wed May 10 12:45:10 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.PersistentProcedureUse: 
  DEFINE TEMP-TABLE tt-Customer NO-UNDO
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum CustNum.
    
  DEFINE VARIABLE hReader AS HANDLE NO-UNDO.    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC PersistentProcedureUse (  ):
    SUPER ().
    
    mFillTT().
    RUN OpenedgeExercises/TTReader.p PERSISTENT SET hReader.
    RUN fillTable IN hReader (INPUT TABLE tt-Customer BIND).
    MESSAGE hReader:INTERNAL-ENTRIES 
    VIEW-AS ALERT-BOX.
    //RUN deleteOdds IN hReader.

    RUN ttRead IN hReader.
    //mFindCustomer(22).
    //mDisplayTT().
      
  END CONSTRUCTOR.
  
  /*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC PersistentProcedureUse ( ):
	  
    IF VALID-HANDLE (hReader) THEN DO:
      APPLY "Close" TO hReader.
      DELETE WIDGET hReader.
    END.

	END DESTRUCTOR.
  /*------------------------------------------------------------------------------
   Purpose:Copys the specific entries from the Database into the TempTable.
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE VOID mFillTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer FOR Customer.
    
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
  
  METHOD PUBLIC VOID mFindCustomer(piCustNum AS INTEGER):
    
    RUN findCustomer IN hReader(INPUT piCustNum).
    
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