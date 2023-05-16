/**
 * Buffer
 *
 * Wrapes a buffer handle, so it can be garbage collected.
 */
CLASS appl.service.buffer:
  DEFINE PUBLIC VARIABLE handle AS HANDLE NO-UNDO.

   /**
    * Purpose: Creates a new buffer for the table of the given name.
    * Notes:
    *
    * @param cTable : character name of table
    */
  CONSTRUCTOR buffer(cTable AS CHARACTER):
    CREATE BUFFER handle FOR TABLE cTable.
  END CONSTRUCTOR.

   /**
    * Purpose: Creates a new buffer for the given temp-table handle or for the same table
    * as a given buffer handle.
    * Notes:
    *
    * @param hTable : handle temp-table/buffer handle
    */
  CONSTRUCTOR buffer(hTable AS HANDLE):
    CREATE BUFFER handle FOR TABLE hTable.
  END CONSTRUCTOR.

   /**
    * Purpose: Creates a new buffer for the table of the given name.
    * Notes: The second parameter is the name of the buffer.
    *
    * @param cTable : character name of table
    * @param cName : character name of the buffer
    */
  CONSTRUCTOR buffer(cTable AS CHARACTER, cName AS CHARACTER):
    CREATE BUFFER handle FOR TABLE cTable BUFFER-NAME cName.
  END CONSTRUCTOR.

   /**
    * Purpose: Creates a new buffer for the given temp-table handle or for the same table as a given buffer handle.
    * Notes: The second parameter is the name of the buffer.
    *
    * @param hTable : handle temp-table/buffer handle
    * @param cName : character name of the buffer
    */
  CONSTRUCTOR buffer(hTable AS HANDLE, cName AS CHARACTER):
    CREATE BUFFER handle FOR TABLE hTable BUFFER-NAME cName.
  END CONSTRUCTOR.

  /**
   * Purpose: Deletes the Buffer
   * Notes:
   *
   */
  DESTRUCTOR buffer():
      IF VALID-HANDLE(handle) THEN DELETE OBJECT handle.
  END DESTRUCTOR.
  
  
  METHOD STATIC PUBLIC INTEGER CountRecs(phb AS HANDLE ):
    DEFINE VARIABLE hq AS HANDLE NO-UNDO.
    DEFINE VARIABLE hb AS HANDLE NO-UNDO.
    DEFINE VARIABLE ii AS INTEGER NO-UNDO.
    
    IF VALID-HANDLE(phb) THEN DO:
      
      CREATE BUFFER hb FOR TABLE phb.
      CREATE QUERY hq.
      hq:SET-BUFFERS(hb).
      hq:QUERY-PREPARE("FOR EACH " + hb:NAME).
      hq:QUERY-OPEN().
      hq:GET-FIRST().
      DO WHILE hb:AVAILABLE: 
        ii = ii + 1.
        hq:GET-NEXT().
      END.
      
      
      DELETE OBJECT hq.
      DELETE OBJECT hb.
    END.
    ELSE ii = - 1.     
    
    RETURN ii.
  
  END.
  
  
END CLASS.
