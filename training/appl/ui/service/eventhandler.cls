 
 /*------------------------------------------------------------------------
    File        : eventhandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : klaus.devries
    Created     : Mon Apr 01 20:37:54 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS appl.ui.service.eventhandler: 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  DEFINE STATIC TEMP-TABLE ttEvents NO-UNDO 
    FIELD EventName     AS CHARACTER 
    FIELD SubscribeObj  AS Progress.Lang.Object  // the object which subscribes to this event
    FIELD InvokeObj     AS Progress.Lang.Object
    FIELD InvokeMethod  AS CHARACTER     
    INDEX EventName SubscribeObj EventName.   
    
  CONSTRUCTOR PUBLIC eventhandler (  ):
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose: Subscribe an event for a specific object
   Notes:  We support only one target for each event 
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC STATIC LOGICAL subscribe(pcEventName    AS CHARACTER ,
                                         poSubscribeObj AS Progress.Lang.Object, 
                                         poInvokeObj    AS Progress.Lang.Object,
                                         pcInvokeMethod AS CHARACTER   ):
    
    DEFINE BUFFER BttEvents FOR ttEvents. 
    
    FIND FIRST BttEvents
      WHERE BttEvents.EventName     = pcEventName
      AND   BttEvents.SubscribeObj  = poSubscribeObj
      NO-ERROR.
      
    IF NOT AVAILABLE BttEvents THEN DO:
      CREATE BttEvents.
      ASSIGN 
        BttEvents.EventName     = pcEventName
        BttEvents.SubscribeObj  = poSubscribeObj.
    END.
    BttEvents.InvokeObj     = poInvokeObj.
    BttEvents.InvokeMethod  = pcInvokeMethod.  
    
    RETURN TRUE.  
    
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose: Unsubscribe an event for a specific object
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC STATIC LOGICAL unSubscribe(pcEventName    AS CHARACTER ,
                                           poSubscribeObj AS Progress.Lang.Object ):
    
    DEFINE BUFFER BttEvents FOR ttEvents. 
    
    FIND FIRST BttEvents
      WHERE BttEvents.EventName     = pcEventName
      AND   BttEvents.SubscribeObj  = poSubscribeObj
      NO-ERROR.
      
    IF AVAILABLE BttEvents THEN DO:
      DELETE  BttEvents.
    END.
        
    RETURN TRUE.  
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Unsubscribe all events for a specific object
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC STATIC LOGICAL unSubscribeAll( poSubscribeObj AS Progress.Lang.Object ):
    DEFINE BUFFER BttEvents FOR ttEvents. 
    
    FOR EACH  BttEvents
      WHERE BttEvents.SubscribeObj  = poSubscribeObj:
      DELETE  BttEvents.
    END.
  END.
  
  
  METHOD PUBLIC STATIC LOGICAL publishEvent (pcEventName    AS CHARACTER ,
                                             poSubscribeObj AS Progress.Lang.Object ):
    DEFINE BUFFER BttEvents FOR ttEvents. 

    DEFINE VARIABLE oEventRecipient   AS Progress.Lang.Class  NO-UNDO. 
    
    FIND FIRST BttEvents
      WHERE BttEvents.EventName     = pcEventName
      AND   BttEvents.SubscribeObj  = poSubscribeObj
      NO-ERROR.

    IF AVAILABLE BttEvents THEN DO:
      oEventRecipient = BttEvents.InvokeObj:GETCLASS (). 
      oEventRecipient:Invoke (  BttEvents.InvokeObj ,  BttEvents.InvokeMethod ).
    END.

  END.  


  DESTRUCTOR PUBLIC eventhandler ( ):

  END DESTRUCTOR.

END CLASS.