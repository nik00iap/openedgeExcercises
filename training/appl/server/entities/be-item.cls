 
 /*------------------------------------------------------------------------
    File        : be-item
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Niklas.Kosanke
    Created     : Mon May 22 20:14:34 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.server.entities.be-item FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS appl.server.entities.be-item: 
    
    DEFINE PUBLIC STATIC PROPERTY oInstance AS be-item NO-UNDO
    PUBLIC GET():
      IF NOT VALID-OBJECT(oInstance) THEN
        oInstance = NEW be-item().
      RETURN oInstance.
    END GET.
    PRIVATE SET.
    
    DEFINE TEMP-TABLE ttItem LIKE sports2000.Item.
    
    DEFINE BUFFER bItem FOR sports2000.Item.
    
    CONSTRUCTOR PUBLIC be-item():
        
    END CONSTRUCTOR.
    
    METHOD PUBLIC HANDLE mGetBatch(pRowId AS ROWID, piBatchCount AS INTEGER, plBackwards AS LOGICAL):
        DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
        DEFINE VARIABLE ii AS INTEGER NO-UNDO INIT 1.
        
        EMPTY TEMP-TABLE ttItem.
        
        
        DEFINE BUFFER bTTItem FOR ttItem.
                
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(BUFFER bItem:HANDLE).
        hQuery:QUERY-PREPARE("FOR EACH bItem BY bItem.ItemNum" + (IF plBackwards THEN " DESC" ELSE "")).
        hQuery:QUERY-OPEN().
        
        hQuery:GET-FIRST().
        IF NOT hQuery:QUERY-OFF-END THEN DO:
            hQuery:REPOSITION-TO-ROWID(pRowId).
            hQuery:GET-NEXT().
            DO WHILE NOT hQuery:QUERY-OFF-END:
                IF ii > piBatchCount THEN LEAVE.
                
                CREATE bTTItem.
                BUFFER-COPY bItem TO bTTItem.
                
                ii = ii + 1.
                hQuery:GET-NEXT().
            END.
        END.
        
        RETURN TEMP-TABLE ttItem:HANDLE.
        
        FINALLY:
            DELETE OBJECT hQuery.
        END.
    END METHOD.
    
/*  METHOD PUBLIC HANDLE getRecord (INPUT iItemNum AS INTEGER):               */
/*      DEFINE VARIABLE hBuf AS HANDLE NO-UNDO.                               */
/*                                                                            */
/*    FIND FIRST bItem WHERE bItem.ItemNum = iItemNum NO-ERROR.               */
/*    IF AVAILABLE(bItem) THEN hBuf = BUFFER bItem:HANDLE.                    */
/*                                                                            */
/*    RETURN hBuf.                                                            */
/*                                                                            */
/*  END METHOD.                                                               */
/*                                                                            */
/*  METHOD PUBLIC HANDLE getFirstRecord ():                                   */
/*    DEFINE VARIABLE hBuf AS HANDLE NO-UNDO.                                 */
/*                                                                            */
/*    FIND FIRST bItem NO-ERROR.                                              */
/*    IF AVAILABLE (bItem) THEN hBuf = BUFFER bItem:HANDLE.                   */
/*                                                                            */
/*    RETURN hBuf.                                                            */
/*                                                                            */
/*  END METHOD.                                                               */
/*                                                                            */
/*  METHOD PUBLIC HANDLE getNextRecord(pcRowid AS CHARACTER):                 */
/*    DEFINE VARIABLE hBuf AS HANDLE NO-UNDO.                                 */
/*                                                                            */
/*    FIND FIRST bItem WHERE ROWID(bItem)= TO-ROWID(pcRowid) NO-LOCK NO-ERROR.*/
/*                                                                            */
/*    FIND NEXT bItem NO-LOCK NO-ERROR.                                       */
/*                                                                            */
/*    RETURN BUFFER bItem:HANDLE.                                             */
/*  END METHOD.                                                               */
/*                                                                            */
/*  METHOD PUBLIC HANDLE getPrevRecord(pcRowid AS CHARACTER):                 */
/*    DEFINE VARIABLE hBuf AS HANDLE NO-UNDO.                                 */
/*                                                                            */
/*    FIND FIRST bItem WHERE ROWID(bItem)= TO-ROWID(pcRowid) NO-LOCK NO-ERROR.*/
/*                                                                            */
/*    FIND NEXT bItem NO-LOCK NO-ERROR.                                       */
/*                                                                            */
/*    RETURN BUFFER bItem:HANDLE.                                             */
/*  END METHOD.                                                               */
  
  METHOD PUBLIC  HANDLE getNextRecord(pcRowid AS CHARACTER):
    RETURN getRecord("NEXT",pcRowid).  
  END METHOD.

  METHOD PUBLIC  HANDLE getPrevRecord(pcRowid AS CHARACTER):
    RETURN getRecord("PREV",pcRowid).  
  END.  

  METHOD PUBLIC  HANDLE getRecord(pcAction AS CHARACTER , pcRowid AS CHARACTER):
    
    DEFINE VARIABLE cWc  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hQry AS HANDLE    NO-UNDO.

    cWc = "FOR EACH " + BUFFER bItem:NAME + " WHERE TRUE ".
    
    CREATE QUERY hQry.      
    hQry:SET-BUFFERS(BUFFER bItem:HANDLE ).
    hQry:QUERY-PREPARE (cWc).
    hQry:QUERY-OPEN().
    
    hQry:REPOSITION-TO-ROWID (TO-ROWID(pcRowid)) NO-ERROR.
    
    IF pcAction = "NEXT" THEN DO: 
      hQry:GET-NEXT().
      hQry:GET-NEXT().
    END.  
    ELSE 
      hQry:GET-PREV().
        
    RETURN BUFFER bItem:HANDLE.
    
    FINALLY:
      DELETE OBJECT hQry.              
    END FINALLY.
    
  END METHOD.
    
END CLASS.