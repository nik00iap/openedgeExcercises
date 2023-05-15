 
 /*------------------------------------------------------------------------
    File        : TempTableWhere
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Thu May 04 13:04:10 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.TempTableWhere: 
  DEFINE TEMP-TABLE tt-Customer
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum CustNum.
    
  DEFINE VARIABLE cCountryFrom  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCountryTo    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNameFrom     AS CHARACTER NO-UNDO.    
  DEFINE VARIABLE cNameTo       AS CHARACTER NO-UNDO. 
  
  
  DEFINE STREAM     sExport.
  DEFINE VARIABLE   cSqlExportFileName AS CHARACTER NO-UNDO.  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableWhere (  ):
    SUPER ().
    cCountryFrom = "a".
    cCountryTo   = "Z".
    cNameFrom    = "a".
    cNameTo      = "Z".
  
    mFillTT().
    MESSAGE "Finished writing"
    VIEW-AS ALERT-BOX.   
  END CONSTRUCTOR.
  
  
  /*------------------------------------------------------------------------------
   Purpose:Reads a Database with limiters either Set by an IF or by a WHERE and writes the time it takes into a document.
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE VOID mFillTT():
    DEFINE VARIABLE iX        AS INTEGER NO-UNDO.
    DEFINE VARIABLE iStart    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iEnd      AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRecs     AS INTEGER NO-UNDO.
    DEFINE VARIABLE lReadOnly AS LOGICAL NO-UNDO.

    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer    FOR Customer.
    
/*    cSqlExportFileName = 'C:\temp\WithIF.txt'.*/
    cSqlExportFileName = 'C:\temp\WithWHERE.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.  
    
    PUT STREAM sExport UNFORMATTED 
      SKIP 
      '"Exercise Conditions: Country From "' cCountryFrom '" to "' cCountryTo '" and Name From "' cNameFrom '" to "' cNameTo '"' ' Date: ' STRING(NOW) SKIP
      SESSION:STARTUP-PARAMETERS SKIP.
      
      
    lReadOnly = TRUE.
    
    DO iX = 1 TO 3:
      iRecs = 0.
      iStart = MTIME.
      
/*      FOR EACH bCustomer NO-LOCK:                                   */
/*        iRecs = iRecs + 1.                                          */
/*        IF (cCountryFrom  = "" OR bCustomer.Country >= cCountryFrom)*/
/*        AND (cCountryTo   = "" OR bCustomer.Country <= cCountryTo)  */
/*        AND (cNameFrom    = "" OR bCustomer.Name    >= cNameFrom)   */
/*        AND (cNameTo      = "" OR bCustomer.Name    <= cNameTo)     */
/*        THEN DO:                                                    */
          
        FOR EACH bCustomer 
          WHERE (cCountryFrom  = ""  OR bCustomer.Country >= cCountryFrom)
            AND (cCountryTo    = ""  OR bCustomer.Country <= cCountryTo)
            AND (cNameFrom     = ""  OR bCustomer.Name    >= cNameFrom)
            AND (cNameTo       = ""  OR bCustomer.Name    <= cNameTo) 
            NO-LOCK:
          iRecs = iRecs + 1.
          
/*          IF NOT lReadOnly THEN DO:                    */
/*            CREATE btt-Customer.                       */
/*            ASSIGN                                     */
/*              btt-Customer.CustNum  = bCustomer.CustNum*/
/*              btt-Customer.Name = bCustomer.Name       */
/*              btt-Customer.Balance = bCustomer.Balance */
/*              btt-Customer.Country = bCustomer.Country */
/*              .                                        */
/*          END.                                         */
/*        END.*/
      END.
    
      iEnd = MTIME.

      PUT STREAM sExport UNFORMATTED 
      iX " Records: " iRecs " Time: " iEnd - iStart "ms Read Only: " lReadOnly " rec/s: " ( iRecs / ( iEnd - iStart )) * 1000 FORMAT ">,>>>,>>9.99" SKIP.
    END.
    
    FINALLY:
      OUTPUT STREAM sExport CLOSE.  
    END FINALLY.
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