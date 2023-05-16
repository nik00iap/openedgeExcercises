 
 /*------------------------------------------------------------------------
    File        : iCombo-
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Alexander.Jäger
    Created     : Mon Apr 01 11:53:02 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE appl.ui.components.iCombo-Box INHERITS appl.ui.components.iComponent:
  
  DEFINE PUBLIC PROPERTY Screen-Value     AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Label            AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Format           AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Data-Type        AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY List-Item-Pairs  AS CHARACTER NO-UNDO GET. SET.

END INTERFACE.