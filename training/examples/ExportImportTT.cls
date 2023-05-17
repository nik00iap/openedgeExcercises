 
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


CLASS examples.ExportImportTT: 
  
  DEFINE TEMP-TABLE tt-Customer NO-UNDO
    FIELD CustNum AS INTEGER
    FIELD Name    AS CHARACTER
    FIELD Balance AS DECIMAL
    FIELD Country AS CHARACTER
    INDEX CustNum IS PRIMARY UNIQUE CustNum.
      
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:"SESSION:TEMP-DIRECTORY  + SportsCustJSON.json".
         "SESSION:TEMP-DIRECTORY  + SportsCustXML.xml"         
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC ExportImportTT (  ):
    SUPER ().

    mImportXML(SESSION:TEMP-DIRECTORY  + "SportsCustXML.xml").
    mDisplayTT().
    
    MESSAGE "finished"
    VIEW-AS ALERT-BOX.
  END CONSTRUCTOR.
  
  /*------------------------------------------------------------------------------
   Purpose:Write a TempTable as a .json file
   Notes:
  ------------------------------------------------------------------------------*/   
  METHOD PUBLIC VOID mExportJSON(pcFile AS CHARACTER):
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    
    TEMP-TABLE btt-Customer:WRITE-JSON(cTargetType, pcFile, TRUE).
    
  END METHOD.
 
  /*------------------------------------------------------------------------------
   Purpose:Read a .json file and write it as a TempTable 
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mImportJSON(pcFile AS CHARACTER):
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    
    TEMP-TABLE btt-Customer:READ-JSON(cTargetType, pcFile, "empty").
    
  END METHOD.
   
  /*------------------------------------------------------------------------------
   Purpose:Write a TempTable as a .xml file
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mExportXML(pcFile AS CHARACTER):
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    
    TEMP-TABLE btt-Customer:WRITE-XML(cTargetType, pcFile, TRUE).
        
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose:Read a .xml file and write it as a TempTable 
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mImportXML(pcFile AS CHARACTER):
    DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    
    cTargetType = "file".
    
    TEMP-TABLE btt-Customer:READ-XML(cTargetType, pcFile, "empty", "", ?).
        
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