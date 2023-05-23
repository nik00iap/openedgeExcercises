 
 /*------------------------------------------------------------------------
    File        : HelloWorldWebHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : iap
    Created     : Thu May 18 08:06:45 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.
USING OpenEdge.Web.WebHandler.
USING appl.server.entities.be-item FROM PROPATH.
USING Progress.Json.ObjectModel.JsonObject FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS WebHandler.ItemsWebHandler INHERITS WebHandler: 

    METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

    END METHOD.

    METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

    END METHOD.

    
    
    /*------------------------------------------------------------------------------
            Purpose: Default handler for the HTTP GET method. The request being 
                     serviced and an optional status code is returned. A zero or 
                     null value means this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
     METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
     
    
        DEFINE VARIABLE oResponse AS OpenEdge.Net.HTTP.IHttpResponse NO-UNDO.
        DEFINE VARIABLE oWriter   AS OpenEdge.Web.WebResponseWriter  NO-UNDO.
        DEFINE VARIABLE oBody     AS OpenEdge.Core.String            NO-UNDO.
        
/*        DEFINE VARIABLE oBeItem AS be-item NO-UNDO.*/
        DEFINE VARIABLE hTTItem AS HANDLE NO-UNDO.
        DEFINE VARIABLE cQryString AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cPair AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iBatchCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE iItemNumFrom AS INTEGER NO-UNDO.
        DEFINE VARIABLE ii AS INTEGER NO-UNDO.
        DEFINE VARIABLE itemRowId AS ROWID NO-UNDO.
        DEFINE VARIABLE lBackwards AS LOGICAL NO-UNDO.
        DEFINE VARIABLE oJsonResult AS JsonObject NO-UNDO.
        DEFINE VARIABLE lcJson AS LONGCHAR NO-UNDO.
        
        DEFINE BUFFER bItem FOR sports2000.Item.
        
        cQryString = STRING(poRequest:GetContextValue("QUERY_STRING")).
        DO ii = 1 TO NUM-ENTRIES(cQryString,'&'):
            cPair = ENTRY(ii, cQryString, '&').
            IF ENTRY(1,cPair,'=') = "batchcount" THEN iBatchCount = INTEGER(ENTRY(2,cPair,'=')).
            ELSE IF ENTRY(1,cPair,'=') = "itemnumfrom" THEN iItemNumFrom = INTEGER(ENTRY(2,cPair,'=')).
            ELSE IF ENTRY(1,cPair,'=') = "backwards" THEN lBackwards = (ENTRY(2,cPair,'=') = "true").
        END.
        
        IF iItemNumFrom <> ? THEN DO:
            FIND FIRST bItem WHERE bItem.Itemnum = iItemNumFrom NO-LOCK NO-ERROR.
            IF AVAILABLE (bItem) THEN itemRowId = ROWID(bItem).
        END.
        
        IF itemRowId = ? THEN DO:
            FIND FIRST bItem NO-LOCK.
            itemRowId = ROWID(bItem).
        END.
        
        oJsonResult = NEW JsonObject().
        
        hTTItem = be-item:oInstance:mGetBatch(itemRowId, IF iBatchCount <> ? THEN iBatchCount ELSE 50, lBackwards).
        hTTItem:WRITE-JSON("JsonObject", oJsonResult).
            
        /* The WebResponse body is a wrapper around an entire HTTP response message.
           It contains a status code and reason; headers; cookies and a message body.
           
           API-level doc for this and related classes can be found at
           https://documentation.progress.com/output/oehttpclient/      */
        ASSIGN 
            oResponse            = NEW OpenEdge.Web.WebResponse()
            oResponse:StatusCode = INTEGER(StatusCodeEnum:OK)
            .
        /* This body object can be a string or something else (JsonObject for instance) */               
/*        ASSIGN                                                                           */
/*            oBody = NEW OpenEdge.Core.String(                                            */
/*                             'Hello guys'                                                */
/*                           + '~r~n':u   /*CRLF */                                        */
/*                           + 'This message was returned by HandleGet in ItemsWebHandler.'*/
/*                           + STRING(iBatchCount)                                         */
/*                           ).                                                            */
                           
        lcJson = oJsonResult:GetJsonText().
        oBody = NEW OpenEdge.Core.String(lcJson).
    
        oResponse:Entity        = oBody.
        
        ASSIGN 
            oResponse:Entity        = oBody
            /* HTTP messages require a content type */
            oResponse:ContentType   = 'application/json'.
            /* ContentLength is good too */
            oResponse:ContentLength = oBody:Size
            .
        
        /* The WebResponseWriter ensures that the status line and
           all headers are writted out before the message body/entity. */
        ASSIGN 
            oWriter = NEW WebResponseWriter(oResponse).
        oWriter:Open().
        
        /* Finish writing the response message */
        oWriter:Close().
        
        /* A response of 0 means that this handler will build the entire response;
           a non-zero value is mapped to a static handler in the webapp's /static/error folder.
           The mappings are maintained in the webapps's WEB-INF/web.xml 
           A predefined set of HTTP status codes is provided in the OpenEdge.Net.HTTP.StatusCodeEnum 
           enumeration */
        RETURN 0.
        
     END METHOD. 
     
     
       
    
END CLASS.