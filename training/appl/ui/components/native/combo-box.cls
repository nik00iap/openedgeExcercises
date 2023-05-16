 
 /*------------------------------------------------------------------------
    File        : combo-box
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Mon Apr 01 12:06:20 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Logging.VoidLogger FROM PROPATH.
USING appl.ui.components.native.combo-box FROM PROPATH.
USING appl.ui.components.iFrame FROM PROPATH.


CLASS appl.ui.components.native.combo-box INHERITS appl.ui.components.native.component IMPLEMENTS appl.ui.components.iCombo-Box:

  DEFINE VARIABLE hLabel           AS HANDLE NO-UNDO.

  DEFINE PROPERTY SCREEN-VALUE AS CHARACTER NO-UNDO
    GET():
      RETURN hNative:Screen-Value.
    END.
    SET(INPUT pcScreen-Value AS CHARACTER):
      hNative:SCREEN-VALUE = pcScreen-Value.
    END.
    
    DEFINE PUBLIC PROPERTY Format AS CHARACTER NO-UNDO
      GET():
        RETURN hNative:FORMAT.
      END.
      SET(INPUT pcFormat AS CHARACTER ):
        hNative:FORMAT = pcFormat.
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
    
  DEFINE PUBLIC PROPERTY List-Item-Pairs AS CHARACTER NO-UNDO
    GET():
      RETURN hNative:LIST-ITEM-PAIRS.
    END.
    SET(INPUT pcList-Item-Pairs AS CHARACTER):
      hNative:LIST-ITEM-PAIRS = pcList-Item-Pairs.
    END.
    
  METHOD PROTECTED OVERRIDE VOID setX(INPUT piX AS INTEGER):
    hLabel:X = piX - 90.
  END METHOD.
  
  METHOD PROTECTED OVERRIDE VOID setY(INPUT piY AS INTEGER):
    hLabel:Y = piY.
  END METHOD.
  
  METHOD PROTECTED VOID setList-Item-Pairs (INPUT pcList-Item-Pairs AS CHARACTER):
    hNative:LIST-ITEM-PAIRS = pcList-Item-Pairs.
  END METHOD.
  
  
  CONSTRUCTOR PUBLIC COMBO-BOX (INPUT poiFrame AS CLASS iFrame):
    DEFINE VARIABLE oFrame AS appl.ui.components.native.frame NO-UNDO.
    
    oFrame = CAST(poiFrame, appl.ui.components.native.frame).
    
    CREATE COMBO-BOX hNative
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
        
    ON ENTER          OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eEnter", THIS-OBJECT).
    ON LEAVE          OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eLeave", THIS-OBJECT).  
    ON VALUE-CHANGED  OF hNative PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc) (INPUT "eValue-Changed", THIS-OBJECT).    
        
  END CONSTRUCTOR.
  
  DESTRUCTOR PUBLIC combo-box():
    DELETE OBJECT hNative.
  END DESTRUCTOR.

END CLASS.