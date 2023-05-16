
 /*------------------------------------------------------------------------
    File        : calc
    Purpose     : sin cos tan acos pi (win/unix)
    Syntax      :
    Description :
    Author(s)   : Christopher.naß
    Created     : Thu Feb 22 09:13:21 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS appl.service.calc:

    &IF "{&OPSYS}" = "UNIX" &THEN
  DEFINE VARIABLE dupi AS DECIMAL NO-UNDO INITIAL -1.
  DEFINE VARIABLE dRet AS DECIMAL NO-UNDO.
  PROCEDURE cos EXTERNAL "/lib64/libm.so.6" CDECL:
      DEFINE INPUT PARAMETER dblValue AS DOUBLE NO-UNDO.
      DEFINE RETURN PARAMETER dblResult AS DOUBLE NO-UNDO.
  END PROCEDURE.

    PROCEDURE sin EXTERNAL "/lib64/libm.so.6" CDECL:
      DEFINE INPUT PARAMETER dblValue AS DOUBLE NO-UNDO.
      DEFINE RETURN PARAMETER dblResult AS DOUBLE NO-UNDO.
  END PROCEDURE.

  PROCEDURE acos EXTERNAL "/lib64/libm.so.6" CDECL:
      DEFINE INPUT PARAMETER dblValue AS DOUBLE NO-UNDO.
      DEFINE RETURN PARAMETER dblResult AS DOUBLE NO-UNDO.
  END PROCEDURE.

    PROCEDURE tan EXTERNAL "/lib64/libm.so.6" CDECL:
      DEFINE INPUT PARAMETER dblValue AS DOUBLE NO-UNDO.
      DEFINE RETURN PARAMETER dblResult AS DOUBLE NO-UNDO.
  END PROCEDURE.

    &ENDIF

  /**
   * Purpose: Returns the cosine of a given value
   * Notes:
   *
   * @param dVal : decimal given value
   * @return cosine
   */
  METHOD STATIC PUBLIC DECIMAL cos (dVal AS DECIMAL):
    &IF "{&OPSYS}" = "WIN32" &THEN
      RETURN  System.Math:Cos(dVal).
    &ELSE
      RUN cos (INPUT dVal, OUTPUT dRet).
      RETURN dRet.
    &ENDIF
  END METHOD.

/**
   * Purpose: Returns the sine of a given value
   * Notes:
   *
   * @param dVal : decimal given value
   * @return sine
   */
  METHOD STATIC PUBLIC DECIMAL sin (dVal AS DECIMAL):
    &IF "{&OPSYS}" = "WIN32" &THEN
      RETURN  System.Math:Sin(dVal).
    &ELSE
      RUN sin (INPUT dVal, OUTPUT dRet).
      RETURN dRet.
    &ENDIF
  END METHOD.

/**
   * Purpose: Returns the tangent of a given value
   * Notes:
   *
   * @param dVal : decimal given value
   * @return tangent
   */
  METHOD STATIC PUBLIC DECIMAL tan (dVal AS DECIMAL):
    &IF "{&OPSYS}" = "WIN32" &THEN
      RETURN  System.Math:Tan(dVal).
    &ELSE
      RUN tan (INPUT dVal, OUTPUT dRet).
      RETURN dRet.
    &ENDIF
  END METHOD.

/**
   * Purpose: Returns pi
   * Notes:
   *
   * @return pi
   */
  METHOD STATIC PUBLIC DECIMAL pi ():
    &IF "{&OPSYS}" = "WIN32" &THEN
      RETURN  System.Math:PI.
    &ELSE
      RUN acos (INPUT dpi1, OUTPUT dRet).
      RETURN dRet.
    &ENDIF
  END METHOD.

  /**
   * Purpose: Returns the arccosine of a given value
   * Notes:
   *
   * @param dVal : decimal given value
   * @return arccosine
   */
  METHOD STATIC PUBLIC DECIMAL acos (dVal AS DECIMAL):
    &IF "{&OPSYS}" = "WIN32" &THEN
      RETURN  System.Math:Acos(dVal).
    &ELSE
      RUN acos (INPUT dVal, OUTPUT dRet).
      RETURN dRet.
    &ENDIF
  END METHOD.

END CLASS.
