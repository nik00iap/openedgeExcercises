 
 /*------------------------------------------------------------------------
    File        : report-builder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.J�ger
    Created     : Mon Apr 01 14:52:12 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.server.report FROM PROPATH.
USING appl.builder.report-builder FROM PROPATH.


CLASS appl.builder.report-builder: 
  
  DEFINE PUBLIC PROPERTY iCustFrom          AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY iCustTo            AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY iSalesRepFrom      AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY iSalesRepTo        AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY cState             AS CHARACTER  NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY iCreditLimitFrom   AS INTEGER    NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY iCreditLimitTo     AS INTEGER    NO-UNDO GET. SET.
  
  CONSTRUCTOR PUBLIC report-builder():
  END CONSTRUCTOR.
  
  METHOD PUBLIC report-builder setICustFrom(piCust AS INTEGER):
    THIS-OBJECT:iCustFrom = piCust.
    RETURN THIS-OBJECT.
  END METHOD.
  
  METHOD PUBLIC report-builder setICustTo(piCust AS INTEGER):
    THIS-OBJECT:iCustTo = piCust.
    RETURN THIS-OBJECT.
  END METHOD.
  
  METHOD PUBLIC report-builder setISalesRepFrom(piSalesRep AS INTEGER):
    THIS-OBJECT:iSalesRepFrom = piSalesRep.
    RETURN THIS-OBJECT.
  END METHOD.
  
  METHOD PUBLIC report-builder setISalesRepTo(piSalesRep AS INTEGER):
    THIS-OBJECT:iSalesRepTo = piSalesRep.
    RETURN THIS-OBJECT.
  END METHOD.
  
  METHOD PUBLIC report-builder setCState(pcState AS CHARACTER):
    THIS-OBJECT:cState = pcState.
    RETURN THIS-OBJECT.
  END METHOD.

  METHOD PUBLIC report-builder setCreditLimitFrom (piCreditLimit AS INTEGER):
    THIS-OBJECT:iCreditLimitFrom = piCreditLimit.
    RETURN THIS-OBJECT.
  END.
  
  METHOD PUBLIC report-builder setCreditLimitTo (piCreditLimit AS INTEGER):
    THIS-OBJECT:iCreditLimitTo = piCreditLimit.
    RETURN THIS-OBJECT.
  END.
  
  METHOD PUBLIC report build():
    RETURN NEW report(THIS-OBJECT).
  END METHOD.

END CLASS.