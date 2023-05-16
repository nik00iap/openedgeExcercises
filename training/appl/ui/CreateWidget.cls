 
 /*------------------------------------------------------------------------
    File        : CreateWidget
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : klaus.devries
    Created     : Mon Apr 01 13:31:53 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.ui.components.iWindow FROM PROPATH.
USING appl.ui.CreateWidget FROM PROPATH.
USING appl.ui.components.native.window FROM PROPATH.
USING appl.ui.screens.start FROM PROPATH.
USING appl.ui.components.iFrame FROM PROPATH.
USING appl.ui.components.ifill-in FROM PROPATH.
USING appl.ui.components.iButton FROM PROPATH.
USING appl.ui.components.iCombo-Box FROM PROPATH.
USING appl.ui.components.native.date-display FROM PROPATH.
USING appl.ui.components.iEditor FROM PROPATH.
USING appl.ui.components.iDate-Display FROM PROPATH.


CLASS appl.ui.CreateWidget: 
  

  DEFINE PUBLIC STATIC PROPERTY oInstance AS CreateWidget NO-UNDO
    PUBLIC GET():
      IF NOT VALID-OBJECT(oInstance) THEN
        oInstance = NEW CreateWidget().
      RETURN oInstance.
    END GET.
    PRIVATE SET.  
  

    
  CONSTRUCTOR PUBLIC CreateWidget (  ):
  END CONSTRUCTOR.

	CONSTRUCTOR STATIC CreateWidget (  ):
	END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC iWindow NewWindow(  ):
    
    DEFINE VARIABLE oiWindow   AS iWindow NO-UNDO.
    
    oiWindow = DYNAMIC-NEW "appl.ui.components." + appl.ui.screens.start:UIType + ".window" ().
    RETURN oiWindow.

  END METHOD.
  
  METHOD PUBLIC iFrame NewFrame( poiWindow AS CLASS appl.ui.components.iWindow ):
    
    DEFINE VARIABLE oiFrame  AS iFrame NO-UNDO.
    
    oiFrame = DYNAMIC-NEW "appl.ui.components." + appl.ui.screens.start:UIType + ".frame" (poiWindow).
    RETURN oiFrame.

  END METHOD.

  METHOD PUBLIC ifill-in NewFill-In( INPUT poiFrame           AS CLASS iFrame ):
    
    DEFINE VARIABLE oiFill-In  AS ifill-in NO-UNDO.
    
    oiFill-In = DYNAMIC-NEW "appl.ui.components." + appl.ui.screens.start:UIType + ".fill-In" (poiFrame).
    RETURN oiFill-In.

  END METHOD.

  METHOD PUBLIC iButton NewButton(INPUT poiFrame           AS CLASS iFrame):
    
    DEFINE VARIABLE oiButton  AS ibutton NO-UNDO.
    
    oiButton = DYNAMIC-NEW "appl.ui.components." + appl.ui.screens.start:UIType + ".button" (poiFrame).
    RETURN oiButton.

  END METHOD.
  
  METHOD PUBLIC iCombo-Box NewCombo-Box(INPUT poiFrame        AS CLASS iFrame):
    
    DEFINE VARIABLE oiCombo-Box AS iCombo-Box NO-UNDO.
    
    oiCombo-Box = DYNAMIC-NEW "appl.ui.components." + appl.ui.screens.start:UIType + ".combo-box" (poiFrame).
    RETURN oiCombo-Box.
    
  END METHOD.

  METHOD PUBLIC iEditor NewEditor(INPUT poiFrame        AS CLASS iFrame):
    
    DEFINE VARIABLE oiEditor AS iEditor NO-UNDO.
    
    oiEditor = DYNAMIC-NEW "appl.ui.components." + appl.ui.screens.start:UIType + ".editor" (poiFrame).
    RETURN oiEditor.
    
  END METHOD.
  
  METHOD PUBLIC iDate-Display NewDate-display(INPUT poiFrame        AS CLASS iFrame):
    
    DEFINE VARIABLE oiDate-Display AS iDate-Display NO-UNDO.
    
    oiDate-Display = DYNAMIC-NEW "appl.ui.components." + appl.ui.screens.start:UIType + ".date-display" (poiFrame).
    RETURN oiDate-Display.
    
  END METHOD.




END CLASS.