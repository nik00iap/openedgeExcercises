 
 /*------------------------------------------------------------------------
    File        : appl.ui.components.native.button.cls
    Purpose     : 
    Syntax      : 
    Description : Native OpenEdge Button
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 12:17:08 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/


USING Progress.Lang.*.
USING cclasses.*.
USING appl.ui.components.iFrame FROM PROPATH.



CLASS appl.ui.components.native.button INHERITS appl.ui.components.native.component IMPLEMENTS appl.ui.components.iButton:
  
  DEFINE PUBLIC PROPERTY Label      AS CHARACTER NO-UNDO 
  	GET():
  	  RETURN hNative:LABEL .
  	END.
  	SET (INPUT pcLabel AS CHARACTER ).
      hNative:LABEL = pcLabel.
   	END.
  
  DEFINE PUBLIC PROPERTY FLAT-BUTTON      AS LOGICAL   NO-UNDO 
    GET():
      RETURN hNative:FLAT-BUTTON .
    END.
    SET (INPUT plFLAT-BUTTON AS LOGICAL ).
      hNative:FLAT-BUTTON = plFLAT-BUTTON.
    END.
    
    
  // DEFINE PUBLIC EVENT onClick SIGNATURE VOID ().
	
 	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
  	
  CONSTRUCTOR PUBLIC button ( INPUT poiFrame           AS CLASS iFrame ):

    DEFINE VARIABLE oFrame AS appl.ui.components.native.frame NO-UNDO.

    oFrame = CAST (poiFrame,appl.ui.components.native.frame). 

    CREATE BUTTON hNative
      ASSIGN 
        FRAME         = oFrame:hNative. 
    
    // Native Events müssen leider über eine Prozedur umgeleitet werden     
    ON CHOOSE OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc)  (INPUT "Choose", THIS-OBJECT).

  END CONSTRUCTOR.
  

  DESTRUCTOR PUBLIC BUTTON  ( ):
    DELETE OBJECT hNative NO-ERROR.

  END DESTRUCTOR.





END CLASS.