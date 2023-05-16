 /*------------------------------------------------------------------------
    File        : appl.ui.components.native.frame.cls
    Purpose     : 
    Syntax      : 
    Description : Native OpenEdge Frame
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 12:17:08 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/
USING Progress.Lang.*.


CLASS appl.ui.components.native.frame INHERITS appl.ui.components.native.component  IMPLEMENTS appl.ui.components.iframe:
	
  DEFINE PUBLIC PROPERTY Title      AS CHARACTER NO-UNDO 
    GET():
      RETURN hNative:TITLE.
    END.
    SET (INPUT pcTitle AS CHARACTER ).
      hNative:LABEL = pcTitle.
    END.

	
  /*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
  ------------------------------------------------------------------------------*/
  	
  CONSTRUCTOR PUBLIC frame( poiWindow AS CLASS appl.ui.components.iWindow ):

    DEFINE VARIABLE oWindow AS appl.ui.components.native.window NO-UNDO.
  
    oWindow = CAST (poiWindow,appl.ui.components.native.window). 

    CREATE FRAME hNative
      ASSIGN
        PARENT        = oWindow:hNative
        THREE-D       = TRUE
        BOX           = FALSE
        .
    
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC frame  ( ):
    DELETE OBJECT hNative NO-ERROR.
  END DESTRUCTOR.



END CLASS.