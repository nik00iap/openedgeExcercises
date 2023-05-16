 
 /*------------------------------------------------------------------------
    File        : report
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Mon Apr 01 14:40:34 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.builder.report-builder FROM PROPATH.


CLASS appl.server.report: 
  
  DEFINE PUBLIC PROPERTY iCustFrom          AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY iCustTo            AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY iSalesRepFrom      AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY iSalesRepTo        AS INTEGER    NO-UNDO GET. SET. 
  DEFINE PUBLIC PROPERTY cState             AS CHARACTER  NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY iCreditLimitFrom   AS INTEGER    NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY iCreditLimitTo     AS INTEGER    NO-UNDO GET. SET.
  
  CONSTRUCTOR PUBLIC report():
  END CONSTRUCTOR.
  
  CONSTRUCTOR PUBLIC report(piCustFrom AS INTEGER, piCustTo AS INTEGER, piSalesRepFrom AS INTEGER, piSalesRepTo AS INTEGER, pcState AS CHARACTER, piCreditLimitFrom AS INTEGER, iCreditLimitTo AS INTEGER):
    
  /*

  .
  
  ...
  
  .....
  
  ...
  
  .
  
  */    
  
  END CONSTRUCTOR.
  
  CONSTRUCTOR PUBLIC report(poBuilder AS report-builder):
    iCustFrom         = poBuilder:iCustFrom.
    iCustTo           = poBuilder:iCustTo.
    iSalesRepFrom     = poBuilder:iSalesRepFrom.
    iSalesRepTo       = poBuilder:iSalesRepTo.
    cState            = poBuilder:cState.
    iCreditLimitFrom  = poBuilder:iCreditLimitFrom.
    iCreditLimitTo    = poBuilder:iCreditLimitTo.

  END CONSTRUCTOR.
  
END CLASS.
