
/*------------------------------------------------------------------------
    File        : startApplication.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : klaus.devries
    Created     : Sun Mar 31 12:31:28 CEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */


USING appl.ui.screens.start FROM PROPATH.
USING appl.ui.components.native.component FROM PROPATH.
USING appl.ui.components.iComponent FROM PROPATH.


SESSION:APPL-ALERT-BOXES    = TRUE.
SESSION:SYSTEM-ALERT-BOXES  = TRUE.



appl.ui.screens.START:Eventproc = THIS-PROCEDURE.


IF INDEX(SESSION:PARAMETER,"Web") > 0 THEN 
  appl.ui.screens.START:UIType    = "web".
ELSE 
  appl.ui.screens.START:UIType    = "native".



appl.ui.screens.START:InitSession().

// start the 'dektop screen'
NEW appl.ui.screens.start().

appl.ui.screens.START:WaitForGoon().

appl.ui.screens.START:QuitSession(). 
    
/*  /* TODO */              */
/*  DO ON ERROR UNDO, LEAVE:*/
/*                          */
/*  END.                    */
  
QUIT.



// This is necessary for the native trigger
PROCEDURE InvokeEvent:
  DEFINE INPUT PARAMETER pcEventName   AS CHARACTER.
  DEFINE INPUT PARAMETER poEventSource AS iComponent.

  poEventSource:eEvent(pcEventName).
  
END.

