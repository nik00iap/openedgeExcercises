 
 /*------------------------------------------------------------------------
    File        : StaticvsDynamic
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Mon May 15 08:25:48 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS examples.StaticvsDynamic: 
  
  DEFINE STREAM sExport.  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC StaticvsDynamic (  ):
    SUPER ().
    
    mDynamicRead("a", "z", "", "s").
    mStaticRead ("a", "z", "", "s").
    
    MESSAGE "finished"
    VIEW-AS ALERT-BOX.
    
  END CONSTRUCTOR.
  
    /*------------------------------------------------------------------------------
   Purpose: Dynamic reading from a Database
   Notes:
  ------------------------------------------------------------------------------*/    
  METHOD PUBLIC VOID mDynamicRead(pcCountryFrom AS CHARACTER, 
                                  pcCountryTo   AS CHARACTER,
                                  pcNameFrom    AS CHARACTER, 
                                  pcNameTo      AS CHARACTER):
    
    DEFINE VARIABLE hDynBufExpTable    AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hDynQueryExpTable  AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cWhereClause       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iStart             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iEnd               AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iRecs              AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cSqlExportFileName AS CHARACTER NO-UNDO.

    cSqlExportFileName = SESSION:TEMP-DIRECTORY  + 'DynamicDatabaseReadDifferingWhere.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.  
    
    PUT STREAM sExport UNFORMATTED 
      SKIP 
      '"Exercise Conditions: Country From "' pcCountryFrom '" to "' pcCountryTo '" and Name From "' pcNameFrom '" to "' pcNameTo '"' ' Date: ' STRING(NOW) SKIP
      SESSION:STARTUP-PARAMETERS SKIP.       
    
    iStart = MTIME.
    
    CREATE BUFFER hDynBufExpTable FOR TABLE "Customer".
    CREATE QUERY  hDynQueryExpTable.
    hDynQueryExpTable:FORWARD-ONLY = TRUE.
    hDynQueryExpTable:SET-BUFFERS( hDynBufExpTable ).
    
    IF pcCountryFrom <> "" THEN DO:
      cWhereClause = cWhereClause + hDynBufExpTable:NAME + ".Country > '" + pcCountryFrom + "' AND ".
    END.

    IF pcCountryTo <> "" THEN DO:
      cWhereClause = cWhereClause + hDynBufExpTable:NAME + ".Country < '" + pcCountryTo + "' AND ".
    END.

    IF pcNameFrom <> "" THEN DO:
      cWhereClause = cWhereClause + hDynBufExpTable:NAME + ".Name > '" + pcNameFrom + "' AND ".
    END.

    IF pcNameTo <> "" THEN DO:
      cWhereClause = cWhereClause + hDynBufExpTable:NAME + ".Name < '" + pcNameTo + "' AND ".
    END.

    IF cWhereClause <> "" THEN DO:
      cWhereClause = " WHERE " + SUBSTRING(cWhereClause, 1, LENGTH (cWhereClause) - 5).
    END.
    
    cWhereClause = "FOR EACH " + hDynBufExpTable:NAME + cWhereClause + " NO-LOCK.".      
        
    hDynQueryExpTable:QUERY-PREPARE(cWhereClause) NO-ERROR.
  
    hDynQueryExpTable:QUERY-OPEN.
    
    RECORDLOOP:
    DO WHILE TRUE:
      hDynQueryExpTable:GET-NEXT().
      IF hDynQueryExpTable:QUERY-OFF-END THEN LEAVE.
      iRecs = iRecs + 1.
    END.

    iEnd = MTIME.
    PUT STREAM sExport UNFORMATTED 
      "Records: " iRecs " Time: " iEnd - iStart "ms rec/s: "  ( iRecs / ( iEnd - iStart )) * 1000  FORMAT ">,>>>,>>9.99"  SKIP. 

    RETURN.

    FINALLY:
      DELETE OBJECT hDynQueryExpTable.
      DELETE OBJECT hDynBufExpTable.
      OUTPUT STREAM sExport CLOSE.
    END FINALLY.
  END METHOD.
  
  
  METHOD PUBLIC VOID mStaticRead(pcCountryFrom AS CHARACTER, 
                                 pcCountryTo   AS CHARACTER,
                                 pcNameFrom    AS CHARACTER, 
                                 pcNameTo      AS CHARACTER):
    
    DEFINE VARIABLE iStart             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iEnd               AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iRecs              AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cSqlExportFileName AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER bCustomer FOR Customer.
    
    cSqlExportFileName = SESSION:TEMP-DIRECTORY  + 'StaticDatabaseReadDifferingWhere.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.  
    
    PUT STREAM sExport UNFORMATTED 
      SKIP 
      '"Exercise Conditions: Country From "' pcCountryFrom '" to "' pcCountryTo '" and Name From "' pcNameFrom '" to "' pcNameTo '"' ' Date: ' STRING(NOW) SKIP
      SESSION:STARTUP-PARAMETERS SKIP.       
    
    iStart = MTIME.
    
    IF pcCountryFrom <> "" AND pcCountryTo <> "" AND pcNameFrom <> "" AND pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          AND bCustomer.Country < pcCountryTo 
          AND bCustomer.Name > pcNameFrom 
          AND bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryFrom <> "" AND pcCountryTo <> "" AND pcNameFrom <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          AND bCustomer.Country < pcCountryTo 
          AND bCustomer.Name > pcNameFrom 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryFrom <> "" AND pcCountryTo <> "" AND pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          AND bCustomer.Country < pcCountryTo 
          AND bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryFrom <> "" AND pcCountryTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          AND bCustomer.Country < pcCountryTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryFrom <> "" AND pcNameFrom <> "" AND pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          AND bCustomer.Name > pcNameFrom 
          AND bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryFrom <> "" AND pcNameFrom <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          AND bCustomer.Name > pcNameFrom 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryFrom <> "" AND pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          AND bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryFrom <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country > pcCountryFrom 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryTo <> "" AND pcNameFrom <> "" AND pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country < pcCountryTo 
          AND bCustomer.Name > pcNameFrom 
          AND bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryTo <> "" AND pcNameFrom <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country < pcCountryTo 
          AND bCustomer.Name > pcNameFrom  
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryTo <> "" AND pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country < pcCountryTo 
          AND bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcCountryTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Country < pcCountryTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcNameFrom <> "" AND pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Name > pcNameFrom 
          AND bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcNameFrom <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Name > pcNameFrom 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE IF pcNameTo <> "" THEN DO:
      FOR EACH bCustomer 
        WHERE bCustomer.Name < pcNameTo 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    ELSE DO:
      FOR EACH bCustomer 
          NO-LOCK:
        iRecs = iRecs + 1.
      END.
    END.
    
    iEnd = MTIME.
    
    PUT STREAM sExport UNFORMATTED 
      "Records: " iRecs " Time: " iEnd - iStart "ms rec/s: "  ( iRecs / ( iEnd - iStart )) * 1000  FORMAT ">,>>>,>>9.99"  SKIP. 
      
    RETURN.

    FINALLY:
       OUTPUT STREAM sExport CLOSE.
    END FINALLY.
  END METHOD.


END CLASS.