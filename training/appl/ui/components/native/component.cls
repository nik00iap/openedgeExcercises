 
 /*------------------------------------------------------------------------
    File        : appl.ui.components.native.window.cls
    Purpose     : 
    Syntax      : 
    Description : Native OpenEdge Window
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 12:17:08 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING cclasses.*.
USING appl.service.color FROM PROPATH.
USING appl.ui.components.iWindow FROM PROPATH.
USING appl.ui.components.iComponent FROM PROPATH.
USING appl.ui.service.eventhandler FROM PROPATH.



CLASS appl.ui.components.native.component IMPLEMENTS iComponent ABSTRACT : 
  
  DEFINE PUBLIC PROPERTY hNative      AS HANDLE   NO-UNDO 
  	GET.
  	PROTECTED SET.
  
  DEFINE PUBLIC PROPERTY Sensitive      AS LOGICAL  NO-UNDO 
  	GET():
  	  RETURN hNative:SENSITIVE.
  	END.
  	SET (INPUT plSensitive AS LOGICAL ).
      hNative:SENSITIVE = plSensitive.
   	END.

  DEFINE PUBLIC PROPERTY Visible      AS LOGICAL  NO-UNDO 
  	GET():
  	  RETURN hNative:VISIBLE.
  	END.
  	SET (INPUT plVisible AS LOGICAL ).
      hNative:VISIBLE = plVisible.
      setVisible(plVisible).
   	END.
  
  // Empty method to override 
  METHOD PROTECTED VOID setVisible (INPUT plVisible AS LOGICAL ):
  END METHOD.
  
  DEFINE PUBLIC PROPERTY x      AS INTEGER   NO-UNDO 
  	GET():
  	  RETURN hNative:X.
  	END.
  	SET (INPUT pix AS INTEGER ).
      hNative:X = pix.
      setX(pix).
   	END.

  // Empty method to override 
  METHOD PROTECTED VOID setX (INPUT piX AS INTEGER):
  END METHOD.

  DEFINE PUBLIC PROPERTY y      AS INTEGER   NO-UNDO 
  	GET():
  	  RETURN hNative:Y.
  	END.
  	SET (INPUT piy AS INTEGER ).
      hNative:Y = piy.
      setY(piy).
   	END.

  // Empty method to override 
  METHOD PROTECTED VOID sety (INPUT piy AS INTEGER):
  END METHOD.
  

  DEFINE PUBLIC PROPERTY WIDTH-PIXELS      AS INTEGER   NO-UNDO 
  	GET():
  	  RETURN hNative:WIDTH-PIXEL.
  	END.
  	SET (INPUT piWidth AS INTEGER ).
      hNative:WIDTH-PIXELS = piWidth.
   	END.

  DEFINE PUBLIC PROPERTY HEIGHT-PIXELS      AS INTEGER   NO-UNDO 
  	GET():
  	  RETURN hNative:HEIGHT-PIXEL.
  	END.
  	SET (INPUT piHeight AS INTEGER ).
      hNative:HEIGHT-PIXEL  = piHeight.
   	END.

  DEFINE PUBLIC PROPERTY BGColor      AS CHARACTER   NO-UNDO 
    GET.
    SET (INPUT pcBGColor AS CHARACTER ).
      DEFINE VARIABLE ii AS INTEGER NO-UNDO.
      ii = COLOR:RGBtoColorNum(pcBGColor).
      hNative:BGCOLOR = ii.
    END.

  DEFINE PUBLIC PROPERTY FGColor      AS CHARACTER   NO-UNDO 
    GET.
    SET (INPUT pcFGColor AS CHARACTER ).
      DEFINE VARIABLE ii AS INTEGER NO-UNDO.
      ii = COLOR:RGBtoColorNum(pcFGColor).
      hNative:FGCOLOR = ii.
    END.

  DEFINE PUBLIC PROPERTY Name      AS CHARACTER NO-UNDO 
    GET():
      RETURN hNative:NAME .
    END.
    SET (INPUT pcName AS CHARACTER ).
      hNative:NAME = pcName.
    END.

  	
	
 	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
  	
  CONSTRUCTOR PUBLIC component ( ):
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID SUBSCRIBE ( pcEventName AS CHARACTER, poEventRecipient AS Progress.Lang.Object, pcEventMethod AS CHARACTER ):
    eventhandler:subscribe(pcEventName, THIS-OBJECT, poEventRecipient, pcEventMethod).    
    
  END METHOD.

  // Receive the event from  startapplication . InvokeEvent
  METHOD PUBLIC VOID eEvent( INPUT pcEventName AS CHARACTER):

    // and publish it to the subscriber ( recipient) 
    eventhandler:publishEvent(pcEventName, THIS-OBJECT).    

    RETURN.

  END METHOD.

  DESTRUCTOR PUBLIC component ( ):
    DELETE OBJECT hNative NO-ERROR.     
  END DESTRUCTOR.


END CLASS.