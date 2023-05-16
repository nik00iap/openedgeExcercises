 
 /*------------------------------------------------------------------------
    File        : TempTableTime
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Fri May 05 12:08:41 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.TempTableTime: 
  
  DEFINE TEMP-TABLE tt-Customer NO-UNDO
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum IS PRIMARY UNIQUE CustNum.
  
  DEFINE STREAM sExport.
 
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableTime (  ):
    SUPER ().
  
    mReadTT().
    MESSAGE "Finished writing"
    VIEW-AS ALERT-BOX.   
  END CONSTRUCTOR.
  
  /*------------------------------------------------------------------------------
   Purpose:Reads a Database without limiters and writes the time it takes into a document.
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE VOID mReadTT():
    DEFINE VARIABLE iX                 AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iStart             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iEnd               AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iRecs              AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lReadOnly          AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cSqlExportFileName AS CHARACTER NO-UNDO. 

    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer    FOR Customer.
    
    cSqlExportFileName = 'C:\temp\WithoutWC.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.
    
    PUT STREAM sExport UNFORMATTED
                       SKIP 
                       "Exercise Condition" " Date: " STRING(NOW) SKIP
                       SESSION:STARTUP-PARAMETERS SKIP.
    
    lReadOnly = TRUE.
    
    DO iX = 1 TO 3:
      iRecs = 0.
      iStart = MTIME.
      FOR EACH bCustomer NO-LOCK:
/*      FOR EACH bCustomer:*/
        iRecs = iRecs + 1.
/*        IF NOT lReadOnly THEN DO:                      */
/*          CREATE btt-Customer.                         */
/*            ASSIGN                                     */
/*              btt-Customer.CustNum  = bCustomer.CustNum*/
/*              btt-Customer.Name = bCustomer.Name       */
/*              btt-Customer.Balance = bCustomer.Balance */
/*              btt-Customer.Country = bCustomer.Country */
/*              .                                        */
/*        END.*/
      END.
    
      iEnd = MTIME.
    
      PUT STREAM sExport UNFORMATTED 
      iX " Records: " iRecs " Time: " iEnd - iStart "ms Read Only: " lReadOnly " rec/s: "  ( iRecs / ( iEnd - iStart )) * 1000  FORMAT ">,>>>,>>9.99"  SKIP.
    END.
    
    FINALLY:
      OUTPUT STREAM sExport CLOSE.  
    END FINALLY.
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