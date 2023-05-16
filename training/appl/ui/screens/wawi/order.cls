 
 /*------------------------------------------------------------------------
    File        : order
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Klaus de Vries
    Created     : Tue Apr 02 09:30:33 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.ui.components.iWindow FROM PROPATH.
USING appl.ui.components.iFrame FROM PROPATH.
USING appl.ui.components.iButton FROM PROPATH.
USING appl.ui.components.ifill-in FROM PROPATH.
USING appl.server.entities.be-customer FROM PROPATH.
USING appl.ui.components.iEditor FROM PROPATH.


CLASS appl.ui.screens.wawi.order: 
  
  DEFINE VARIABLE oBtNext         AS iButton   NO-UNDO.
  DEFINE VARIABLE oBtPrev         AS iButton   NO-UNDO.
  DEFINE VARIABLE oFiOrderNum     AS ifill-in  NO-UNDO.
  DEFINE VARIABLE oFiCustNum      AS ifill-in  NO-UNDO.
  DEFINE VARIABLE oFiOrderDate    AS ifill-in  NO-UNDO.
  DEFINE VARIABLE oEdInstructions AS iEditor   NO-UNDO.
  
  DEFINE VARIABLE cDbRowId     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE oWindow      AS iWindow   NO-UNDO.
  DEFINE VARIABLE oFrame       AS iFrame    NO-UNDO.
  DEFINE VARIABLE hWin         AS HANDLE    NO-UNDO.
  
  

  
  DEFINE VARIABLE oParentScreen  AS appl.ui.screens.customer.
  
  
  DEFINE PUBLIC STATIC PROPERTY oCreateWidget AS appl.ui.CreateWidget NO-UNDO GET. SET.
  
  
  CONSTRUCTOR PUBLIC order (poParentScreen AS appl.ui.screens.customer):
    
    oParentScreen = poParentScreen.
    
    
    CreComponents().

  END CONSTRUCTOR.
  CONSTRUCTOR PUBLIC order ():
    CreComponents().

  END CONSTRUCTOR.

  METHOD PRIVATE VOID CreComponents ():
    oCreateWidget = appl.ui.CreateWidget:oInstance.
    
    oWindow = oCreateWidget:NewWindow().
    oWindow:NAME          = "Order".
    oWindow:x             = 50.
    oWindow:y             = 50.
    oWindow:WIDTH-PIXELS  = 500.
    oWindow:HEIGHT-PIXELS = 500.
    oWindow:TITLE         = "Order".
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
    oFiCustNum:NAME            = "CustNum".
    oFiCustNum:Label           = "Cust Num".
    oFiCustNum:SENSITIVE       = TRUE.
    oFiCustNum:VISIBLE         = TRUE.
    
    oFiOrderNum = oCreateWidget:NewFill-In(oFrame).
    oFiOrderNum:x               = 100.
    oFiOrderNum:y               = 70.
    oFiOrderNum:HEIGHT-PIXELS   = 21.
    oFiOrderNum:WIDTH-PIXELS    = 100.
    oFiOrderNum:NAME            = "OrderNum".
    oFiOrderNum:Label           = "OrderNum".
    oFiOrderNum:SENSITIVE       = TRUE.
    oFiOrderNum:VISIBLE         = TRUE.
    
    oFiOrderDate = oCreateWidget:NewDate-display(oFrame).
    oFiOrderDate:x               = 100.
    oFiOrderDate:y               = 100.
    oFiOrderDate:HEIGHT-PIXELS   = 21.
    oFiOrderDate:WIDTH-PIXELS    = 100.
    oFiOrderDate:NAME            = "OrderDate".
    oFiOrderDate:Label           = "OrderDate".
    oFiOrderDate:SENSITIVE       = TRUE.
    oFiOrderDate:VISIBLE         = TRUE.


    oEdInstructions = oCreateWidget:NewEditor(oFrame).
    oEdInstructions:x               = 100.
    oEdInstructions:y               = 130.
    oEdInstructions:HEIGHT-PIXELS   = 50.
    oEdInstructions:WIDTH-PIXELS    = 100.
    oEdInstructions:NAME            = "Instructions".
    oEdInstructions:Label           = "Instructions".
    oEdInstructions:SENSITIVE       = TRUE.
    oEdInstructions:VISIBLE         = TRUE.


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
  
  END.



  
  METHOD PUBLIC VOID ePrev ():
    DEFINE VARIABLE hBuf     AS HANDLE  NO-UNDO.
    DEFINE VARIABLE iCustNum AS INTEGER NO-UNDO.

    IF VALID-OBJECT (oParentScreen) THEN 
      iCustNum = INTEGER(oParentScreen:oFiCustNum:Screen-Value).

    hBuf = appl.server.entities.be-order:oInstance:getRecord("prev",cDbRowId,iCustNum).

    displayRecords(hBuf).
  END.
   
  METHOD PUBLIC VOID eNext ():
    DEFINE VARIABLE hBuf     AS HANDLE  NO-UNDO.
    DEFINE VARIABLE iCustNum AS INTEGER NO-UNDO.

    IF VALID-OBJECT (oParentScreen) THEN 
      iCustNum = INTEGER(oParentScreen:oFiCustNum:Screen-Value).

    hBuf = appl.server.entities.be-order:oInstance:getRecord("next",cDbRowId,iCustNum).
    displayRecords(hBuf).
  END.
  
  METHOD PRIVATE VOID displayRecords(phBuf AS HANDLE):
    
    IF VALID-HANDLE(phBuf) AND phBuf:AVAILABLE THEN DO:
      cDbRowId = STRING(phBuf:ROWID).
      
      oFiCustNum:SCREEN-VALUE       = phBuf:BUFFER-FIELD ("CustNum"):BUFFER-VALUE.
      oFiOrderNum:SCREEN-VALUE      = phBuf:BUFFER-FIELD ("OrderNum"):BUFFER-VALUE.
      oFiOrderDate:SCREEN-VALUE     = phBuf:BUFFER-FIELD ("Orderdate"):BUFFER-VALUE.
      oEdInstructions:SCREEN-VALUE  = phBuf:BUFFER-FIELD ("Instructions"):BUFFER-VALUE.
    
    END.
  END.
  
END CLASS.