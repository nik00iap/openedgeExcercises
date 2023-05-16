
/*------------------------------------------------------------------------
    File        : iButton
    Purpose     : 
    Syntax      : 
    Description : Interface for the button classes
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 14:10:40 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE appl.ui.components.iButton INHERITS appl.ui.components.iComponent:  
  
  DEFINE PUBLIC PROPERTY Flat-Button    AS LOGICAL    NO-UNDO GET . SET.
  DEFINE PUBLIC PROPERTY Label          AS CHARACTER  NO-UNDO GET . SET. 
  
  // DEFINE PUBLIC EVENT onClick SIGNATURE VOID ().
  
END INTERFACE.