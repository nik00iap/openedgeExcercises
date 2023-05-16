 /*------------------------------------------------------------------------
    File        : appl.ui.components.native.fill-in.cls
    Purpose     : 
    Syntax      : 
    Description : Native OpenEdge Fill-In
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 12:17:08 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING cclasses.*.
USING appl.ui.components.native.fill-in FROM PROPATH.
USING appl.ui.components.iFrame FROM PROPATH.

CLASS appl.ui.components.native.fill-in INHERITS appl.ui.components.native.component IMPLEMENTS appl.ui.components.ifill-in:

  
  DEFINE VARIABLE hLabel    AS HANDLE NO-UNDO.		

  DEFINE PUBLIC PROPERTY Screen-Value AS CHARACTER NO-UNDO 
  	GET():
  	  RETURN hNative:SCREEN-VALUE .
  	END.
  	SET (INPUT pcScreen-Value AS CHAR).
      hNative:SCREEN-VALUE = pcScreen-Value. 	
   	END.

  DEFINE PUBLIC PROPERTY Format AS CHARACTER NO-UNDO 
  	GET():
  	  RETURN hNative:FORMAT.
  	END.
  	SET (INPUT pcFormat AS CHAR).
      hNative:FORMAT     = pcFormat. 	
   	END.

  DEFINE PUBLIC PROPERTY Data-Type AS CHARACTER NO-UNDO 
  	GET():
  	  RETURN hNative:DATA-TYPE.
  	END.
  	SET (INPUT pcData-Type AS CHAR).
      hNative:DATA-TYPE = pcData-Type. 	
   	END.

  DEFINE PUBLIC PROPERTY Label AS CHARACTER NO-UNDO 
    GET():
      RETURN hLabel:SCREEN-VALUE.
    END.
    SET (INPUT pcLabel AS CHAR).
      hLabel:SCREEN-VALUE = pcLabel. 
    END.
    
  METHOD PROTECTED OVERRIDE VOID setVisible (INPUT plVisible AS LOGICAL ):
    hLabel:VISIBLE = plVisible.
  END METHOD.

  METHOD PROTECTED OVERRIDE VOID setX (INPUT pix AS INTEGER):
    hLabel:X = pix - 90.
  END METHOD.  
  
  METHOD PROTECTED OVERRIDE VOID setY (INPUT piy AS INTEGER):
    hLabel:Y = piy.
  END METHOD.

	
 	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
  	
  CONSTRUCTOR PUBLIC fill-in ( INPUT poiFrame           AS CLASS iFrame):

    DEFINE VARIABLE oFrame AS appl.ui.components.native.frame NO-UNDO.

    oFrame = CAST (poiFrame,appl.ui.components.native.frame). 
      
    CREATE FILL-IN hNative
      ASSIGN
        FRAME = oFrame:hNative
        .
        
    CREATE TEXT hLabel
      ASSIGN
        FRAME         = oFrame:hNative
        DATA-TYPE     = "CHARACTER"
        FORMAT        = "X(30)"
        WIDTH-PIXELS  = 100
        HEIGHT-PIXELS = 21  
        HIDDEN        = FALSE 
        .
  
    // Unfortunately we have to fire the UI event via a event procedure
    ON ENTER OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc)  (INPUT "eEnter", THIS-OBJECT).
    ON LEAVE OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc)  (INPUT "eLeave", THIS-OBJECT).

  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC fill-in ( ):
    IF VALID-HANDLE(hNative) THEN DELETE OBJECT hNative.

  END DESTRUCTOR.

END CLASS.