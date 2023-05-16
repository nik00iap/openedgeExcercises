
/*------------------------------------------------------------------------
    File        : iFill-in
    Purpose     : 
    Syntax      : 
    Description : Interface for the fill-in classes
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 14:10:40 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE appl.ui.components.ifill-in INHERITS appl.ui.components.iComponent:  
  
  DEFINE PUBLIC PROPERTY Screen-Value   AS CHARACTER  NO-UNDO GET . SET.
  DEFINE PUBLIC PROPERTY Label          AS CHARACTER  NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY Format         AS CHARACTER  NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY Data-type      AS CHARACTER  NO-UNDO GET . SET. 


  
END INTERFACE.