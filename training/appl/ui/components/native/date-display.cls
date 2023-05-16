 
 /*------------------------------------------------------------------------
    File        : date
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.J�ger
    Created     : Mon Apr 01 13:46:32 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.ui.components.iFrame FROM PROPATH.


CLASS appl.ui.components.native.date-display INHERITS appl.ui.components.native.fill-in IMPLEMENTS appl.ui.components.iDate-Display: 
  
  CONSTRUCTOR PUBLIC date-display (INPUT poiFrame AS CLASS iFrame):
    SUPER(poiFrame).
    
    THIS-OBJECT:DATA-TYPE = "DATE".
/*    ON Key-Pressed OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eKey-Pressed").*/
    ON CURSOR-UP    OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eCursor-Up",THIS-OBJECT).
    ON CURSOR-DOWN  OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eCursor-Down",THIS-OBJECT).
  END CONSTRUCTOR.
  
  METHOD PUBLIC OVERRIDE VOID eEvent( INPUT pcEventName AS CHARACTER):
    
    
    CASE pcEventName:
      WHEN "eKey-Pressed" THEN DO:
        /*IF oParam:cVal("LABEL") = "+" THEN */
        /*THIS-OBJECT:SCREEN-VALUE = STRING (DATE (THIS-OBJECT:Screen-Value) + 1).*/
      END.
      WHEN "eCursor-Up"    THEN THIS-OBJECT:SCREEN-VALUE = STRING(DATE (THIS-OBJECT:Screen-Value) + 1).
      WHEN "eCursor-Down"  THEN THIS-OBJECT:SCREEN-VALUE = STRING(DATE (THIS-OBJECT:Screen-Value) - 1).
    END CASE.
    
    RETURN.

  END METHOD.
  
END CLASS.