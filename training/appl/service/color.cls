 
 /*------------------------------------------------------------------------
    File        : color
    Purpose     : 
    Syntax      : 
    Description : Contains methods regarding color
    Author(s)   : klaus.devries
    Created     : Sun Mar 31 09:13:43 CEST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS appl.service.color: 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  DEFINE STATIC  TEMP-TABLE ttcol
    FIELD ColNum  AS INT
    FIELD rgb     AS INT
    INDEX RgB    RGB
    INDEX ColNum ColNum.


  DEFINE PUBLIC STATIC PROPERTY baby-shit-green AS CHARACTER NO-UNDO INITIAL "141,156,25"   GET.
  DEFINE PUBLIC STATIC PROPERTY beige           AS CHARACTER NO-UNDO INITIAL "227,235,167"  GET.
  DEFINE PUBLIC STATIC PROPERTY beige-two       AS CHARACTER NO-UNDO INITIAL "229,234,187"  GET.
  DEFINE PUBLIC STATIC PROPERTY black           AS CHARACTER NO-UNDO INITIAL "27,33,43"     GET.
  DEFINE PUBLIC STATIC PROPERTY bluey           AS CHARACTER NO-UNDO INITIAL "158,170,182"  GET.
  DEFINE PUBLIC STATIC PROPERTY charcoal-grey   AS CHARACTER NO-UNDO INITIAL "39,44,51"     GET.

    
  CONSTRUCTOR STATIC color ():

    DEF VAR ii AS INT NO-UNDO.
    
    DO ii = 16 TO COLOR-TABLE:NUM-ENTRIES:
    
      COLOR-TABLE:SET-DYNAMIC(ii, YES) NO-ERROR.
      CREATE ttcol.
      ASSIGN
        ttcol.ColNum = ii
        ttcol.rgb    = -1.
    END.    

  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:  Converts a RGB given as comma seperated value to a OE color number
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC STATIC INTEGER RGBtoColorNum(pcColor AS CHARACTER  ):
    
    DEFINE VARIABLE result AS INTEGER NO-UNDO.

    DEF VAR iColor AS INT NO-UNDO.
  
    DEF BUFFER BTTCol FOR ttcol.
  
/*
    iColor = RGB-VALUE( MINIMUM(MAXIMUM(INT(ENTRY(1,pcColor)),0),255),
                        MINIMUM(MAXIMUM(INT(ENTRY(2,pcColor)),0),255),
                        MINIMUM(MAXIMUM(INT(ENTRY(3,pcColor)),0),255)) .

    FIND FIRST BTTcol
      WHERE BTTCol.rgb = icolor
      NO-ERROR.
    IF NOT AVAILABLE BTTcol THEN DO:
      FIND FIRST BTTcol
        WHERE BTTcol.rgb = -1
        AND   BTTcol.ColNum  >= 16
        NO-ERROR.
      IF NOT AVAILABLE BTTCol THEN DO:
        // error handling 
        //MESSAGE "Farbtabelle ist voll !".
      END.
      ELSE DO:

        BTTCol.RGB = iColor.
        COLOR-TABLE:SET-RGB-VALUE(BTTCol.ColNum, iColor) /* NO-ERROR */ .
      END.      
    END. /* of ELSE DO*/

    RETURN IF AVAILABLE BTTCol THEN BTTCol.ColNum ELSE ?.
*/
  END METHOD.




END CLASS.