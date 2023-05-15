 
 /*------------------------------------------------------------------------
    File        : FunctionInWhereClause
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Tue May 09 13:40:44 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.FunctionInWhereClause: 
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

  CONSTRUCTOR PUBLIC FunctionInWhereClause (  ):
    SUPER ().
    cCountryFrom = "z".
    cCountryTo   = "a".
    cNameFrom    = "z".
    cNameTo      = "a".
  
    mReadDatabase().
    mReadDatabaseWithFunction().
    
    MESSAGE "Finished writing"
    VIEW-AS ALERT-BOX.   
  END CONSTRUCTOR.
  
  
  /*------------------------------------------------------------------------------
   Purpose: Reads entrys from a Database that fulfil the WHERE Clause
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE VOID mReadDatabase():
    DEFINE VARIABLE iX        AS INTEGER NO-UNDO.
    DEFINE VARIABLE iStart    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iEnd      AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRecs     AS INTEGER NO-UNDO.
    DEFINE VARIABLE lReadOnly AS LOGICAL NO-UNDO.

    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer    FOR Customer.
    
    cSqlExportFileName = 'C:\temp\DatabseRead.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.  
    
    PUT STREAM sExport UNFORMATTED 
      SKIP 
      '"Exercise Conditions: Country From "' cCountryFrom '" to "' cCountryTo '"' ' Date: ' STRING(NOW) SKIP
      SESSION:STARTUP-PARAMETERS SKIP.
      
      
    lReadOnly = TRUE.
    
    DO iX = 1 TO 3:
      iRecs = 0.
      iStart = MTIME.

        FOR EACH bCustomer 
          WHERE bCustomer.Country >= cCountryFrom
            AND bCustomer.Country <= cCountryTo
            NO-LOCK:
          iRecs = iRecs + 1.

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
   Purpose: Reads entrys from a Database that fulfil the WHERE Clause
   Notes: The Where Clause contains functions
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE VOID mReadDatabaseWithFunction():
    DEFINE VARIABLE iX        AS INTEGER NO-UNDO.
    DEFINE VARIABLE iStart    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iEnd      AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRecs     AS INTEGER NO-UNDO.
    DEFINE VARIABLE lReadOnly AS LOGICAL NO-UNDO.

    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer    FOR Customer.
    
    cSqlExportFileName = 'C:\temp\DatabaseReadWithFunction.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.  
    
    PUT STREAM sExport UNFORMATTED 
      SKIP 
      '"Exercise Conditions: Country From "' cCountryFrom '" to "' cCountryTo '"' ' Date: ' STRING(NOW) SKIP
      SESSION:STARTUP-PARAMETERS SKIP.
      
      
    lReadOnly = TRUE.
    
    DO iX = 1 TO 3:
      iRecs = 0.
      iStart = MTIME.

        FOR EACH bCustomer 
          WHERE SUBSTRING (bCustomer.Country,1) >= cCountryFrom
            AND SUBSTRING (bCustomer.Country,1) <= cCountryTo
            NO-LOCK:
          iRecs = iRecs + 1.

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