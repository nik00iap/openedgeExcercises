
/*------------------------------------------------------------------------
    File        : iWindow
    Purpose     : 
    Syntax      : 
    Description : Interface for the componenent classes
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 14:10:40 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE appl.ui.components.iComponent:  
  
  DEFINE PUBLIC PROPERTY Sensitive      AS LOGICAL    NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY Visible        AS LOGICAL    NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY x              AS INTEGER    NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY y              AS INTEGER    NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY WIDTH-PIXELS   AS INTEGER    NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY HEIGHT-PIXELS  AS INTEGER    NO-UNDO GET . SET. 
  DEFINE PUBLIC PROPERTY BGColor        AS CHARACTER  NO-UNDO GET . SET.
  DEFINE PUBLIC PROPERTY NAME           AS CHARACTER  NO-UNDO GET . SET.

  METHOD PUBLIC VOID SUBSCRIBE ( pcEventName AS CHARACTER, poEventRecipient AS Progress.Lang.Object, pcEventMethod AS CHARACTER ).
    // Receive the event 
  METHOD PUBLIC VOID eEvent( INPUT pcEventName AS CHARACTER). 
  
  
END INTERFACE.