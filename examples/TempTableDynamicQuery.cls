 
 /*------------------------------------------------------------------------
    File        : TempTableDynamicQuery
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Wed May 10 14:13:27 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.TempTableDynamicQuery: 

  DEFINE TEMP-TABLE tt-Customer
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum CustNum.
    
  DEFINE STREAM     sExport.
  DEFINE VARIABLE   cSqlExportFileName AS CHARACTER NO-UNDO.
    
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableDynamicQuery (  ):
    SUPER ().
    mDynamicWrite().
    //mDynamicRead().
    mDisplayTT().
    //mDynamicDisplay().
  END CONSTRUCTOR.
  
  /*------------------------------------------------------------------------------
   Purpose: Dynamic reading from a Database and writing the data into a TempTable
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mDynamicWrite():
    
    DEFINE VARIABLE hDynBufExpTable   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDynQueryExpTable AS HANDLE NO-UNDO.
    DEFINE VARIABLE cWhereClause      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iStart            AS INTEGER NO-UNDO.
    DEFINE VARIABLE iEnd              AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRecs             AS INTEGER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cSqlExportFileName = 'C:\temp\DynamicDatabseWrite.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.  
    
    PUT STREAM sExport UNFORMATTED 
      SKIP 
      "Exercise Dynamic Database" SKIP
      SESSION:STARTUP-PARAMETERS SKIP.       
    
    iStart = MTIME.
    
    CREATE BUFFER hDynBufExpTable FOR TABLE "Customer".
    CREATE QUERY  hDynQueryExpTable.
    hDynQueryExpTable:FORWARD-ONLY = TRUE.
    hDynQueryExpTable:SET-BUFFERS( hDynBufExpTable ).
                 
    cWhereClause = "FOR EACH " + hDynBufExpTable:NAME + " NO-LOCK".   
        
    hDynQueryExpTable:QUERY-PREPARE(cWhereClause) NO-ERROR.
  
    hDynQueryExpTable:QUERY-OPEN.
    
    RECORDLOOP: DO WHILE TRUE:
      hDynQueryExpTable:GET-NEXT().
      IF hDynQueryExpTable:QUERY-OFF-END THEN LEAVE.
        iRecs = iRecs + 1.
        CREATE btt-Customer.
        ASSIGN
          btt-Customer.CustNum  = hDynBufExpTable:BUFFER-FIELD("CustNum"):BUFFER-VALUE /*Complete Version to Access Buffer Data*/
          btt-Customer.Name     = hDynBufExpTable::NAME                                /*Shortcut Version to Access Buffer Data*/
          btt-Customer.Balance  = hDynBufExpTable::Balance
          btt-Customer.Country  = hDynBufExpTable::Country
        .
          
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
  
  /*------------------------------------------------------------------------------
   Purpose: Dynamic reading from a Database
   Notes:
  ------------------------------------------------------------------------------*/    
  METHOD PUBLIC VOID mDynamicRead():
    
    DEFINE VARIABLE hDynBufExpTable   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDynQueryExpTable AS HANDLE NO-UNDO.
    DEFINE VARIABLE cWhereClause      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iStart            AS INTEGER NO-UNDO.
    DEFINE VARIABLE iEnd              AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRecs             AS INTEGER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cSqlExportFileName = 'C:\temp\DynamicDatabseRead.txt'.
    OUTPUT STREAM sExport TO VALUE(cSqlExportFileName) APPEND.  
    
    PUT STREAM sExport UNFORMATTED 
      SKIP 
      "Exercise Dynamic Database" SKIP
      SESSION:STARTUP-PARAMETERS SKIP.       
    
    iStart = MTIME.
    
    CREATE BUFFER hDynBufExpTable FOR TABLE "Customer".
    CREATE QUERY  hDynQueryExpTable.
    hDynQueryExpTable:FORWARD-ONLY = TRUE.
    hDynQueryExpTable:SET-BUFFERS( hDynBufExpTable ).
                 
    cWhereClause = "FOR EACH " + hDynBufExpTable:NAME + " NO-LOCK".   
        
    hDynQueryExpTable:QUERY-PREPARE(cWhereClause) NO-ERROR.
  
    hDynQueryExpTable:QUERY-OPEN.
    
    RECORDLOOP: DO WHILE TRUE:
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
  
    
  /*------------------------------------------------------------------------------
   Purpose: Dynamic Search for a certain entry in a TempTabl
   Notes:
  ------------------------------------------------------------------------------*/    
  METHOD PUBLIC VOID mDynamicDisplay():
    
    DEFINE VARIABLE hDynBufExpTable   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDynQueryExpTable AS HANDLE NO-UNDO.
    DEFINE VARIABLE cWhereClause      AS CHARACTER NO-UNDO.       
      
    CREATE BUFFER hDynBufExpTable FOR TABLE "tt-Customer".
    CREATE QUERY  hDynQueryExpTable.
    hDynQueryExpTable:FORWARD-ONLY = TRUE.
    hDynQueryExpTable:SET-BUFFERS( hDynBufExpTable ).
                 
    cWhereClause = "FIND " + hDynBufExpTable:NAME + " WHERE " + hDynBufExpTable:NAME + ".CustNum = 1 NO-LOCK".   
        
    hDynQueryExpTable:QUERY-PREPARE(cWhereClause) NO-ERROR.
  
    hDynQueryExpTable:QUERY-OPEN.
    
    RECORDLOOP: DO WHILE TRUE:
      hDynQueryExpTable:GET-NEXT().
      IF hDynQueryExpTable:QUERY-OFF-END THEN LEAVE.
        DISPLAY hDynBufExpTable::CustNum hDynBufExpTable::NAME.
      END.
      
    RETURN.
    FINALLY:
      DELETE OBJECT hDynQueryExpTable.
      DELETE OBJECT hDynBufExpTable.
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