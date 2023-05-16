 
 /*------------------------------------------------------------------------
    File        : customer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Tue Apr 02 09:30:33 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.ui.components.iWindow FROM PROPATH.
USING appl.ui.components.iFrame FROM PROPATH.
USING appl.ui.components.iButton FROM PROPATH.
USING appl.ui.components.ifill-in FROM PROPATH.
USING appl.server.entities.be-customer FROM PROPATH.


CLASS appl.ui.screens.customer: 
  
  DEFINE        VARIABLE oBtOrder    AS iButton   NO-UNDO.
  DEFINE        VARIABLE oBtNext     AS iButton   NO-UNDO.
  DEFINE        VARIABLE oBtPrev     AS iButton   NO-UNDO.
  DEFINE        VARIABLE oBtToggle   AS iButton   NO-UNDO.
  DEFINE PUBLIC VARIABLE oFiCustNum  AS ifill-in  NO-UNDO.
  DEFINE        VARIABLE oFiName     AS ifill-in  NO-UNDO.
  DEFINE        VARIABLE oFiSalesRep AS ifill-in  NO-UNDO.
  
  DEFINE        VARIABLE cDbRowId    AS CHARACTER NO-UNDO.
  DEFINE        VARIABLE oWindow     AS iWindow   NO-UNDO.
  DEFINE        VARIABLE oFrame      AS iFrame    NO-UNDO.
  DEFINE        VARIABLE hWin        AS HANDLE    NO-UNDO.


  DEFINE TEMP-TABLE ttCustomer LIKE Customer
    FIELD DBRowid AS CHARACTER.
  
  DEFINE PUBLIC STATIC PROPERTY oCreateWidget AS appl.ui.CreateWidget NO-UNDO GET. SET.
  
  
  CONSTRUCTOR PUBLIC customer():
    
    oCreateWidget = appl.ui.CreateWidget:oInstance.
    
    oWindow = oCreateWidget:NewWindow().
    oWindow:NAME          = "Desktop".
    oWindow:x             = 50.
    oWindow:y             = 50.
    oWindow:WIDTH-PIXELS  = 500.
    oWindow:HEIGHT-PIXELS = 500.
    oWindow:TITLE         = "Customer".
    oWindow:BGCOLOR       = appl.service.color:charcoal-grey.
    oWindow:VISIBLE       = TRUE.
    
    oFrame = oCreateWidget:NewFrame(oWindow).
    oFrame:BGCOLOR        = appl.service.color:beige-two.
    oFrame:x              = 10.
    oFrame:y              = 10.
    oFrame:HEIGHT-PIXELS  = oWindow:HEIGHT-PIXELS - 20.
    oFrame:WIDTH-PIXELS   = oWindow:WIDTH-PIXELS  - 20.
    oFrame:VISIBLE        = TRUE.    

    
    oFiCustNum = oCreateWidget:NewFill-In(oFrame).
    oFiCustNum:x               = 100.
    oFiCustNum:y               = 40.
    oFiCustNum:HEIGHT-PIXELS   = 21.
    oFiCustNum:WIDTH-PIXELS    = 100.
    oFiCustNum:NAME            = "oFiCustNum".
    oFiCustNum:Label           = "Cust Num".
    oFiCustNum:SENSITIVE       = TRUE.
    oFiCustNum:VISIBLE         = TRUE.
    
    oFiName = oCreateWidget:NewFill-In(oFrame).
    oFiName:x               = 100.
    oFiName:y               = 70.
    oFiName:HEIGHT-PIXELS   = 21.
    oFiName:WIDTH-PIXELS    = 100.
    oFiName:NAME            = "oFiName".
    oFiName:Label           = "Name".
    oFiName:SENSITIVE       = TRUE.
    oFiName:VISIBLE         = TRUE.
    
    oFiSalesRep = oCreateWidget:NewFill-In(oFrame).
    oFiSalesRep:x               = 100.
    oFiSalesRep:y               = 100.
    oFiSalesRep:HEIGHT-PIXELS   = 21.
    oFiSalesRep:WIDTH-PIXELS    = 100.
    oFiSalesRep:NAME            = "oFiSalesrep".
    oFiSalesRep:Label           = "Sales Rep".
    oFiSalesRep:SENSITIVE       = TRUE.
    oFiSalesRep:VISIBLE         = TRUE.

    oBtPrev = oCreateWidget:NewButton(oFrame).
    oBtPrev:x               = 210.
    oBtPrev:y               = 38.
    oBtPrev:HEIGHT-PIXELS   = 25.
    oBtPrev:WIDTH-PIXELS    = 40.
    oBtPrev:NAME            = "oBtPrev".
    oBtPrev:Label           = "<".
    oBtPrev:SENSITIVE       = TRUE.
    oBtPrev:VISIBLE         = TRUE.
    oBtPrev:SUBSCRIBE("CHOOSE", THIS-OBJECT, "ePrev").
    
    oBtNext = oCreateWidget:NewButton(oFrame).
    oBtNext:x               = 260.
    oBtNext:y               = 38.
    oBtNext:HEIGHT-PIXELS   = 25.
    oBtNext:WIDTH-PIXELS    = 40.
    oBtNext:NAME            = "oBtNext".
    oBtNext:Label           = ">".
    oBtNext:SENSITIVE       = TRUE.
    oBtNext:VISIBLE         = TRUE.
    oBtNext:SUBSCRIBE("CHOOSE", THIS-OBJECT, "eNext").
    

    oBtOrder = oCreateWidget:NewButton(oFrame).
    oBtOrder:x               = 300.
    oBtOrder:y               = 38.
    oBtOrder:HEIGHT-PIXELS   = 25.
    oBtOrder:WIDTH-PIXELS    = 100.
    oBtOrder:NAME            = "Order".
    oBtOrder:Label           = "Order".
    oBtOrder:SENSITIVE       = TRUE.
    oBtOrder:VISIBLE         = TRUE.
    oBtOrder:SUBSCRIBE("CHOOSE", THIS-OBJECT, "eOrder").


    oBtToggle = oCreateWidget:NewButton(oFrame).
    oBtToggle:x               = 100.
    oBtToggle:y               = 140.
    oBtToggle:HEIGHT-PIXELS   = 25.
    oBtToggle:WIDTH-PIXELS    = 40.
    oBtToggle:NAME            = "Toggle".
    oBtToggle:Label           = "Toggle".
    oBtToggle:SENSITIVE       = TRUE.
    oBtToggle:VISIBLE         = TRUE.
    oBtToggle:SUBSCRIBE("CHOOSE", THIS-OBJECT, "eToggle").
    
    
    
  END CONSTRUCTOR.
  
  METHOD PUBLIC VOID ePrev ():
    DEFINE VARIABLE hBuf AS HANDLE NO-UNDO.
    hBuf = appl.server.entities.be-customer:getPrevRecord(cDbRowId).
    displayRecords(hBuf).
  END.
   
  METHOD PUBLIC VOID eNext ():
    DEFINE VARIABLE hBuf AS HANDLE NO-UNDO.
    hBuf = appl.server.entities.be-customer:getNextRecord(cDbRowId).
    displayRecords(hBuf).
  END.
  
  METHOD PUBLIC VOID eOrder():
    
    NEW appl.ui.screens.wawi.order(THIS-OBJECT).
  END.
  
  METHOD PUBLIC VOID eToggle():
    oFiCustNum:VISIBLE = NOT oFiCustNum:VISIBLE.
  END.
  
  
  
  METHOD PRIVATE VOID displayRecords(phBuf AS HANDLE):
    
    cDbRowId = STRING(phBuf:ROWID).
    
    oFiCustNum:SCREEN-VALUE   = phBuf:BUFFER-FIELD ("CustNum"):BUFFER-VALUE.
    oFiName:SCREEN-VALUE      = phBuf:BUFFER-FIELD ("Name"):BUFFER-VALUE.
    oFiSalesRep:SCREEN-VALUE  = phBuf:BUFFER-FIELD ("SalesRep"):BUFFER-VALUE.


  END.
  
  
  
END CLASS.