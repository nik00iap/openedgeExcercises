 
 /*------------------------------------------------------------------------
    File        : be-order
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Tue Apr 02 10:21:20 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.server.entities.be-order FROM PROPATH.


CLASS appl.server.entities.be-order: 
  
  CONSTRUCTOR PUBLIC be-order (  ):
  END CONSTRUCTOR.

  CONSTRUCTOR  STATIC be-order (  ):
  END CONSTRUCTOR.

  
  DEFINE PUBLIC STATIC PROPERTY oInstance AS be-order NO-UNDO
    PUBLIC GET():
      IF NOT VALID-OBJECT(oInstance) THEN
        oInstance = NEW be-order().
      RETURN oInstance.
    END GET.
    PRIVATE SET.
  


  DEFINE VARIABLE hBuf AS HANDLE NO-UNDO.

  DEFINE BUFFER bOrder FOR order.
      
  
  METHOD PUBLIC  HANDLE getNextRecord(pcRowid AS CHARACTER):
    RETURN getRecord("NEXT",pcRowid,0).  
  END METHOD.

  METHOD PUBLIC  HANDLE getPrevRecord(pcRowid AS CHARACTER):
    RETURN getRecord("PREV",pcRowid,0).  
  END.  

  METHOD PUBLIC  HANDLE getRecord(pcAction AS CHARACTER , pcRowid AS CHARACTER, piCustNumFrom AS INTEGER):
    
    DEFINE VARIABLE cWc  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hQry AS HANDLE    NO-UNDO.

    cWc = "FOR EACH " + BUFFER bOrder:NAME + " WHERE TRUE ". 
    
    IF piCustNumFrom > 0 THEN 
      cWc = cWc + " AND  CustNum = " + STRING (piCustNumFrom) . 
    
    CREATE QUERY hQry.      
    hQry:SET-BUFFERS(BUFFER bOrder:HANDLE ).
    hQry:QUERY-PREPARE (cWc).
    hQry:QUERY-OPEN().
    
    hQry:REPOSITION-TO-ROWID (TO-ROWID(pcRowid)) NO-ERROR.
    
    IF pcAction = "NEXT" THEN DO: 
      hQry:GET-NEXT().
      hQry:GET-NEXT().
    END.  
    ELSE 
      hQry:GET-PREV().
        
    RETURN BUFFER bOrder:HANDLE.
    
    FINALLY:
      DELETE OBJECT hQry.              
    END FINALLY.
    
  END METHOD.


END CLASS.