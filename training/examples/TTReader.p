
/*------------------------------------------------------------------------
    File        : TTReader.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : IAP
    Created     : Wed May 10 08:49:48 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEFINE TEMP-TABLE tt-Customer REFERENCE-ONLY
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum IS PRIMARY UNIQUE CustNum.



/*------------------------------------------------------------------------------
  Purpose: Create a Connection between the Temp Taple of this Procedure and another
  Notes:
------------------------------------------------------------------------------*/
PROCEDURE fillTable:

  DEFINE INPUT PARAMETER TABLE FOR tt-Customer BIND.
  
END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose: Reads out the entries from the TempTable
  Notes:
------------------------------------------------------------------------------*/
PROCEDURE TTRead:

  DEFINE BUFFER btt-Customer FOR tt-Customer.
     
  FOR EACH btt-Customer BY CustNum:
    DISPLAY btt-Customer.
  END.
    
END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose: Searches for a certain TT entry and and Displays the entry
  Notes:  
------------------------------------------------------------------------------*/
PROCEDURE findCustomer:
  
  DEFINE INPUT PARAMETER iCustNum AS INTEGER.
  
  DEFINE BUFFER btt-Customer FOR tt-Customer.
  
  FIND FIRST btt-Customer WHERE btt-Customer.CustNum = iCustNum NO-LOCK NO-ERROR.
  IF AVAILABLE btt-Customer THEN DO:
    DISPLAY btt-Customer.
  END.
  
END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose: Deletes all TT entries with uneven customer numbers
  Notes:
------------------------------------------------------------------------------*/
PROCEDURE deleteOdds:
  DEFINE BUFFER btt-Customer FOR tt-Customer.
  
  FOR EACH btt-Customer WHERE btt-Customer.CustNum MOD 2 <> 0 NO-LOCK:
    DELETE btt-Customer.
  END.
 
END PROCEDURE.