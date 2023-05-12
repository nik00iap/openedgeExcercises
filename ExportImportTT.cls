 
 /*------------------------------------------------------------------------
    File        : ExportImportTT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Thu May 11 14:30:59 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.ExportImportTT: 
  
  DEFINE TEMP-TABLE tt-Customer
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum CustNum.
      
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC ExportImportTT (  ):
    SUPER ().

    mImportXML().
    mDisplayTT().
    
    MESSAGE "finished"
    VIEW-AS ALERT-BOX.
  END CONSTRUCTOR.
  
  /*------------------------------------------------------------------------------
   Purpose:Write a TempTable as a .json file
   Notes:
  ------------------------------------------------------------------------------*/   
  METHOD PUBLIC VOID mExportJSON():
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    cFile       = "C:\temp\SportsCustJSON.json".
    
    TEMP-TABLE btt-Customer:WRITE-JSON(cTargetType, cFile, TRUE).
    
  END METHOD.
 
  /*------------------------------------------------------------------------------
   Purpose:Read a .json file and write it as a TempTable 
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mImportJSON():
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    cFile       = "C:\temp\SportsCustJSON.json".
    
    TEMP-TABLE btt-Customer:READ-JSON(cTargetType, cFile, "empty").
    
  END METHOD.
   
  /*------------------------------------------------------------------------------
   Purpose:Write a TempTable as a .xml file
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mExportXML():
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    cFile       = "C:\temp\SportsCustXML.xml".
    
    TEMP-TABLE btt-Customer:WRITE-XML(cTargetType, cFile, TRUE).
        
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose:Read a .xml file and write it as a TempTable 
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mImportXML():
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    cFile       = "C:\temp\SportsCustXML.xml".
    
    TEMP-TABLE btt-Customer:READ-XML(cTargetType, cFile, "empty", "", ?).
        
  END METHOD.  
  
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