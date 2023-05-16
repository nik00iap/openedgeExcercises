 
 /*------------------------------------------------------------------------
    File        : start
    Purpose     : 
    Syntax      : 
    Description : Starts the Workshop demo
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 12:17:08 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.ui.components.iWindow FROM PROPATH.
USING appl.ui.components.iFrame FROM PROPATH.
USING appl.ui.components.iButton FROM PROPATH.
USING appl.ui.components.ifill-in FROM PROPATH.
USING appl.ui.components.iDate-Display FROM PROPATH.
USING appl.ui.components.iEditor FROM PROPATH.
USING appl.ui.components.iCombo-Box FROM PROPATH.

CLASS appl.ui.screens.start: 
  
  DEFINE VARIABLE oWindow     AS iWindow NO-UNDO.
  DEFINE VARIABLE oFrame      AS iFrame  NO-UNDO.
  DEFINE VARIABLE oBtCustomer AS iButton NO-UNDO.
  DEFINE VARIABLE oBtOrder    AS iButton NO-UNDO.


  DEFINE PUBLIC STATIC PROPERTY eventProc      AS HANDLE                     NO-UNDO  GET. SET. 
  DEFINE PUBLIC STATIC PROPERTY UIType         AS CHARACTER                  NO-UNDO  GET. SET. 
  DEFINE PUBLIC STATIC PROPERTY oCreateWidget  AS appl.ui.CreateWidget       NO-UNDO  GET. SET. 
  DEFINE PUBLIC STATIC PROPERTY hWin           AS HANDLE                     NO-UNDO  GET. SET.



  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC start (  ):

    
    oCreateWidget = appl.ui.CreateWidget:oInstance.
    
    oWindow = oCreateWidget:NewWindow().
    oWindow:NAME          = "Desktop".
    oWindow:x             = 0.
    oWindow:y             = 2.
    oWindow:WIDTH-PIXELS  = 1000.
    oWindow:HEIGHT-PIXELS = 500.
    oWindow:TITLE         = "Desktop".
    oWindow:BGCOLOR       = appl.service.color:charcoal-grey.
    oWindow:VISIBLE       = TRUE.
    
    IF appl.ui.screens.START:UIType  = "native" THEN 
      hWin = CAST(oWindow, appl.ui.components.native.window):hNative.
    
    oFrame = oCreateWidget:NewFrame(oWindow).
    oFrame:BGCOLOR        = appl.service.color:beige-two.
    oFrame:x              = 10.
    oFrame:y              = 10.
    oFrame:HEIGHT-PIXELS  = oWindow:HEIGHT-PIXELS - 20.
    oFrame:WIDTH-PIXELS   = oWindow:WIDTH-PIXELS  - 20.
    oFrame:VISIBLE        = TRUE.
    
    
    oBtCustomer = oCreateWidget:NewButton(oFrame).
    oBtCustomer:x               = 20.
    oBtCustomer:y               = 20.
    oBtCustomer:HEIGHT-PIXELS   = 25.
    oBtCustomer:WIDTH-PIXELS    = 100.
    oBtCustomer:NAME            = "Customer".
    oBtCustomer:Label           = "Customer".
    oBtCustomer:SENSITIVE       = TRUE.
    oBtCustomer:VISIBLE         = TRUE.
    oBtCustomer:SUBSCRIBE("CHOOSE", THIS-OBJECT, "eCustomer").

    oBtOrder = oCreateWidget:NewButton(oFrame).
    oBtOrder:x               = 140.
    oBtOrder:y               = 20.
    oBtOrder:HEIGHT-PIXELS   = 25.
    oBtOrder:WIDTH-PIXELS    = 100.
    oBtOrder:NAME            = "Order".
    oBtOrder:Label           = "Order".
    oBtOrder:SENSITIVE       = TRUE.
    oBtOrder:VISIBLE         = TRUE.
    oBtOrder:SUBSCRIBE("CHOOSE", THIS-OBJECT, "eOrder").
    
   
    
  END CONSTRUCTOR.

  METHOD PUBLIC STATIC VOID InitSession():
    // IF appl.ui.screens.START:UIType  = "web" THEN  SC:initSession(). 
  END.
  
  METHOD PUBLIC STATIC VOID WaitForGoon():
        
/*    IF appl.ui.screens.START:UIType  = "web" THEN*/
/*      SC:waitForGoon().                          */
/*    ELSE DO:                                     */
      WAIT-FOR WINDOW-CLOSE OF hWin.
/*    END.*/

  END.
  
  METHOD PUBLIC STATIC VOID QuitSession():
/*    IF appl.ui.screens.START:UIType  = "web" THEN*/
/*      SC:quitSession().                          */
      
  END.
  

  // Start the customer screen   
  METHOD PUBLIC VOID eCustomer():
    NEW appl.ui.screens.customer().
  END.
  METHOD PUBLIC VOID eOrder():
    // NEW appl.ui.screens.wawi.order().
  END.


END CLASS.