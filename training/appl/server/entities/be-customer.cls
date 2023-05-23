 
 /*------------------------------------------------------------------------
    File        : be-customer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Tue Apr 02 10:21:20 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING System.ComponentModel.ICustomTypeDescriptor FROM ASSEMBLY.


CLASS appl.server.entities.be-customer: 
  
  CONSTRUCTOR PUBLIC be-customer (  ):
  END CONSTRUCTOR.

  CONSTRUCTOR STATIC be-customer (  ):
  END CONSTRUCTOR.

  DEFINE STATIC VARIABLE hBuf AS HANDLE NO-UNDO.

  DEFINE STATIC BUFFER bCust FOR customer.
  
  DEFINE STATIC TEMP-TABLE ttCustomer LIKE Customer
    FIELD DBRowid AS CHARACTER.
  
      
  METHOD PUBLIC STATIC HANDLE getRecord (INPUT iCustNum AS INTEGER):

    FIND FIRST bCust WHERE bCust.CustNum = iCustNum NO-ERROR.
    IF AVAILABLE(bCust) THEN hBuf = BUFFER bCust:HANDLE.
    
    RETURN hBuf.

  END METHOD.
  
  METHOD PUBLIC STATIC HANDLE getFirstRecord ():
    
    FIND FIRST bCust NO-ERROR.
    IF AVAILABLE (bCust) THEN hBuf = BUFFER bCust:HANDLE.
    
    RETURN hBuf.

  END METHOD.
  
  METHOD PUBLIC STATIC HANDLE getNextRecord(pcRowid AS CHARACTER):
    
    FIND FIRST bCust WHERE ROWID(bCust)= TO-ROWID(pcRowid) NO-LOCK NO-ERROR.
    
    FIND NEXT bCust NO-LOCK NO-ERROR.
    
    RETURN BUFFER bCust:HANDLE.
  END METHOD.

  METHOD PUBLIC STATIC HANDLE getPrevRecord(pcRowid AS CHARACTER):
    
    FIND FIRST bCust WHERE ROWID(bCust)= TO-ROWID(pcRowid) NO-LOCK NO-ERROR.
    
    FIND PREV bCust NO-LOCK NO-ERROR.
    
    RETURN BUFFER bCust:HANDLE.
  END METHOD.
  
  
  
  
  

    
  

END CLASS.