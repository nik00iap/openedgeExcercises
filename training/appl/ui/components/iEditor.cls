
/*------------------------------------------------------------------------
    File        : iEditor
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Mon Apr 01 11:59:40 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE appl.ui.components.iEditor INHERITS appl.ui.components.iComponent:  
  
  DEFINE PUBLIC PROPERTY Screen-Value   AS  CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Label          AS  CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Format         AS  CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Data-Type      AS  CHARACTER NO-UNDO GET. SET.
  
END INTERFACE.