 
 /*------------------------------------------------------------------------
    File        : editor
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Mon Apr 01 13:04:23 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.ui.components.iFrame FROM PROPATH.
USING appl.ui.components.native.editor FROM PROPATH.


CLASS appl.ui.components.native.editor INHERITS appl.ui.components.native.component IMPLEMENTS appl.ui.components.iEditor: 
  
  DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.
  
DEFINE PUBLIC PROPERTY Screen-Value AS CHARACTER NO-UNDO 
    GET():
      RETURN hNative:SCREEN-VALUE .
    END.
    SET (INPUT pcScreen-Value AS CHARACTER).
      hNative:SCREEN-VALUE = pcScreen-Value.  
    END.

  DEFINE PUBLIC PROPERTY Format AS CHARACTER NO-UNDO 
    GET():
      RETURN hNative:FORMAT.
    END.
    SET (INPUT pcFormat AS CHARACTER).
      hNative:FORMAT     = pcFormat.  
    END.

  DEFINE PUBLIC PROPERTY Data-Type AS CHARACTER NO-UNDO 
    GET():
      RETURN hNative:DATA-TYPE.
    END.
    SET (INPUT pcData-Type AS CHARACTER).
      hNative:DATA-TYPE = pcData-Type.  
    END.

  DEFINE PUBLIC PROPERTY Label AS CHARACTER NO-UNDO 
    GET():
      RETURN hLabel:SCREEN-VALUE.
    END.
    SET (INPUT pcLabel AS CHARACTER).
      hLabel:SCREEN-VALUE = pcLabel. 
    END.
 
  METHOD PROTECTED OVERRIDE VOID setX (INPUT piX AS INTEGER):
    hLabel:X = piX - 90.
  END METHOD.  
  
  METHOD PROTECTED OVERRIDE VOID setY (INPUT piY AS INTEGER):
    hLabel:Y = piY.
  END METHOD.
  
  
  CONSTRUCTOR PUBLIC editor (INPUT poiFrame AS CLASS iFrame):
    DEFINE VARIABLE oFrame AS appl.ui.components.native.frame NO-UNDO.
    
    oFrame = CAST (poiFrame,appl.ui.components.native.frame).
    
    CREATE EDITOR hNative
      ASSIGN 
        FRAME = oFrame:hNative
        .
        
    CREATE TEXT hLabel 
      ASSIGN 
        FRAME           = oFrame:hNative
        DATA-TYPE       = "CHARACTER"
        FORMAT          = "X(30)"
        WIDTH-PIXELS    = 100
        HEIGHT-PIXELS   = 21
        HIDDEN          = FALSE 
        .
        
    ON ENTER OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eEnter", THIS-OBJECT).
    ON LEAVE OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eLeave", THIS-OBJECT).
        
  END CONSTRUCTOR.
  
  DESTRUCTOR PUBLIC editor():
    DELETE OBJECT hNative.
  END DESTRUCTOR.

END CLASS.