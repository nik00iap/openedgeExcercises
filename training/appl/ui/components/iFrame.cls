
/*------------------------------------------------------------------------
    File        : iWindow
    Purpose     : 
    Syntax      : 
    Description : Interface for the frame classes
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 14:10:40 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE appl.ui.components.iFrame INHERITS appl.ui.components.iComponent:  
  
  DEFINE PUBLIC PROPERTY Title          AS CHARACTER  NO-UNDO GET . SET. 
  
  
END INTERFACE.