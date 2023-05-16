@OF-1 FILE(/*----------------------------------------------------------*/
Ident          = "appl.service.geolocation.cls",
Documentation  =
"
type for geografic loactions with latitude and longitude
",
DeveloperNotes =
" 

"
/*----------------------------------------------------------------------*/).
USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Lang.*.


CLASS appl.service.geolocation:

  /**
   * Purpose: Latitude
   * Notes:
   */
  DEFINE PUBLIC PROPERTY dLAT AS DECIMAL NO-UNDO
    GET.
    SET.

  /**
   * Purpose: Longitude
   * Notes:
   *
   */
  DEFINE PUBLIC PROPERTY dLNG AS DECIMAL NO-UNDO
    GET.
    SET.


  /**
   * Purpose:
   * Notes:
   *
   * @param dLat :  decimal Latitude
   * @param dLng :  decimal Longitude
   */
  CONSTRUCTOR PUBLIC geolocation(dLat AS DECIMAL, dLng AS DECIMAL):
    THIS-OBJECT:dLAT = dLat.
    THIS-OBJECT:dLng = dLng.
  END CONSTRUCTOR.
  
  /**
   * Purpose:
   * Notes:
   *
   * @param dLat :  CHARACTER Latitude
   * @param dLng :  CHARACTER Longitude
   */
  CONSTRUCTOR PUBLIC geolocation(cLat AS CHARACTER, cLng AS CHARACTER):
    THIS-OBJECT:dLAT = DECIMAL(REPLACE(cLat, ".", ",")).
    THIS-OBJECT:dLng = DECIMAL(REPLACE(cLng, ".", ",")).
  END CONSTRUCTOR.

  /**
   * Purpose: Get the location as json array
   * Notes:
   *
   * @return JsonArray
   */
  METHOD PUBLIC JsonArray getJson():
    RETURN getJson(FALSE).
  END METHOD.
  
  /**
   * Purpose: Get the location as json array
   * Notes:
   *
   * @param lReverse : LOGICAL Swap lat and long location in array
   * @return JsonArray
   */
  METHOD PUBLIC JsonArray getJson(lReverse AS LOGICAL):
    DEFINE VARIABLE oJson AS JsonArray NO-UNDO.
    oJson = NEW JsonArray().
    IF lReverse THEN DO: 
      oJson:add(dLNG).
      oJson:add(dLAT).
    END.
    ELSE DO:
      oJson:add(dLAT).
      oJson:add(dLNG).
    END.
    RETURN oJson.
  END METHOD.



END CLASS.