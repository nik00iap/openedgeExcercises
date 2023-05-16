 
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



CLASS appl.ui.components.native.window INHERITS appl.ui.components.native.component  IMPLEMENTS iWindow: 
  

  DEFINE PUBLIC PROPERTY Title      AS CHARACTER NO-UNDO 
  	GET():
  	  RETURN hNative:TITLE.
  	END.
  	SET (INPUT pcTitle AS CHARACTER ).
      hNative:Title = pcTitle.
   	END.


  	
	
 	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
  	
  CONSTRUCTOR PUBLIC window ( ):

    CREATE WINDOW  hNative
      ASSIGN 
/*        X             = pix                                     */
/*        Y             = piy                                     */
/*        WIDTH-PIXELS  = piWidth-Pixels                          */
/*        HEIGHT-PIXELS = piHeight-Pixels                         */
/*        TITLE         = pcTitle                                 */
/*        // BGCOLOR       = INT(getAttr#(SESSION,"DesktopColor"))*/
        TOP-ONLY      = TRUE 
        MESSAGE-AREA  = FALSE 
        STATUS-AREA   = FALSE .
        
/*      hNative:MOVE-TO-TOP().*/
/*    ON WINDOW-CLOSE OF hNative           PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc)  (INPUT "eWindow-Close", THIS-OBJECT).*/
/*    ON ESC          OF hNative ANYWHERE  PERSISTENT RUN InvokeEvent IN (appl.ui.screens.start:eventProc)  (INPUT "eWindow-Close", THIS-OBJECT).*/
/*    hWin = CAST(oWindow, appl.ui.components.native.window):hNative.*/
/*                                                                   */
    
  END CONSTRUCTOR.

  DESTRUCTOR PUBLIC WINDOW ( ):
    DELETE OBJECT hNative NO-ERROR.     
  END DESTRUCTOR.


END CLASS.