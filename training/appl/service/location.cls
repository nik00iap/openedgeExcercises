
 /*------------------------------------------------------------------------
    File        : location
    Purpose     : calculates distances
    Syntax      :
    Description :
    Author(s)   : Christopher.naß
    Created     : Wed Feb 14 13:11:06 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING appl.service.geolocation.
USING appl.service.calc.
USING appl.service.location.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS appl.service.location:





  /**
   * Purpose: Calculates the distance between two coordinates in km
   * Notes:
   *
   * @param ocord1 : appl.service.geolocation first coordinates
   * @param ocord2 : appl.service.geolocation second coordinates
   * @return distance
   */
  METHOD STATIC PUBLIC DECIMAL distance (ocord1 AS appl.service.geolocation, ocord2 AS appl.service.geolocation):
    DEFINE VARIABLE dlat1  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dlat2  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dlng1  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dlng2  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dacos AS DECIMAL NO-UNDO.

    ASSIGN
      dlat1 = ocord1:dLat * appl.service.calc:pi() / 180
      dlat2 = ocord2:dLat * appl.service.calc:pi() / 180
      dlng1 = ocord1:dLng * appl.service.calc:pi() / 180
      dlng2 = ocord2:dLng * appl.service.calc:pi() / 180.

    RETURN 6378.388 * appl.service.calc:acos(appl.service.calc:sin(dlat1) * appl.service.calc:sin(dlat2) + appl.service.calc:cos(dlat1) * appl.service.calc:cos(dlat2) * appl.service.calc:cos(dlng2 - dlng1)).
  END METHOD.


  /**
   * Purpose: Returns true if given coordinates are within iDist km of the other given coordinates
   * Notes: uses distance
   *
   * @param ocord1 : appl.service.geolocation first coordinates
   * @param ocord2 : appl.service.geolocation second coordinates
   * @param iDist : integer distance
   * @return true if within
   */
  METHOD STATIC PUBLIC LOGICAL inRadius (ocord1 AS appl.service.geolocation, ocord2 AS appl.service.geolocation, dDist AS DECIMAL):
    RETURN distance(ocord1, ocord2) <= dDist .
  END METHOD.

  /**
   * Purpose: Returns the coordinated of the top left corner of a rectangle with the given coordinates as the middle and the edges(not corners) are dDist km away from the middle(= 2dDist by 2dDist rectangle)
   * Notes:
   *
   * @param dDist : decimal the distance from the middle
   * @param ocord : appl.service.geolocation middle coordinates
   * @return top left coordinates
   */
  METHOD STATIC PUBLIC appl.service.geolocation topLeft (dDist AS DECIMAL, ocord AS appl.service.geolocation):
    DEFINE VARIABLE dlat AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dlon AS DECIMAL NO-UNDO.

    dlat = ocord:dLAT + dDist / 111.3.
    dlon = ocord:dLNG - dDist / (111.3 * appl.service.calc:cos((ocord:dLAT + dlat) / 2 * 0.01745)).

    RETURN NEW appl.service.geolocation(dlat,dlon).
  END METHOD.

  /**
   * Purpose: Returns the coordinated of the bottom right corner of a rectangle with the given coordinates as the middle and the edges(not corners) are dDist km away from the middle(= 2dDist by 2dDist rectangle)
   * Notes:
   *
   * @param dDist : decimal the distance from the middle
   * @param ocord : appl.service.geolocation middle coordinates
   * @return bottom right coordinates
   */
  METHOD STATIC PUBLIC appl.service.geolocation bottomRight (dDist AS DECIMAL, ocord AS appl.service.geolocation):
    DEFINE VARIABLE dlat AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dlon AS DECIMAL NO-UNDO.

    dlat = ocord:dLAT - dDist / 111.3.
    dlon = ocord:dLNG + dDist / (111.3 * appl.service.calc:cos((ocord:dLAT + dlat) / 2 * 0.01745)).

    RETURN NEW appl.service.geolocation(dlat,dlon).
  END METHOD.

  /**
   * Purpose: Returns true if given coordinates are within iDist km of the other given coordinates
   * Notes: uses rectangle with cord1 as middle
   *
   * @param ocord1 : appl.service.geolocation first coordinates
   * @param ocord2 : appl.service.geolocation second coordinates
   * @param iDist : integer distance
   * @return true if within
   */
  METHOD STATIC PUBLIC LOGICAL inRectangle(ocord1 AS appl.service.geolocation, ocord2 AS appl.service.geolocation, dDist AS DECIMAL):
    DEFINE VARIABLE obR AS appl.service.geolocation NO-UNDO.
    DEFINE VARIABLE otL AS appl.service.geolocation NO-UNDO.
    ASSIGN
      obR = bottomRight(dDist, ocord1)
      otL = topLeft(dDist, ocord1).
    RETURN obR:dLAT <= ocord2:dLAT AND ocord2:dLAT <= otL:dLAT AND
           otL:dLNG <= ocord2:dLNG AND ocord2:dLNG <= obR:dLNG.
  END METHOD.

  /**
   * Purpose: Returns the differenz in coordinates to the top left (north west)corner of a rectangle around a given middle and the edges(not corners) of the rectangle are dDist km away from the middle(= 2*dDist by 2*dDist rectangle)
   * Notes:
   *
   * @param dDist : decimal the distance from the middle
   * @param ocord : appl.service.geolocation middle coordinates
   * @return the differenz as coordinates
   */
  METHOD STATIC PUBLIC appl.service.geolocation maxDif(dDist AS DECIMAL, ocord AS appl.service.geolocation):
    DEFINE VARIABLE dlat AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dlon AS DECIMAL NO-UNDO.

    dlat = dDist / 111.3.
    dlon = -(dDist / (111.3 * appl.service.calc:cos((ocord:dLAT + (ocord:dLAT + dDist / 111.3)) / 2 * 0.01745))).

    RETURN NEW appl.service.geolocation(dlat,dlon).
  END METHOD.

END CLASS.