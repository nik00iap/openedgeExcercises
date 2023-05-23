
/*------------------------------------------------------------------------
    File        : faclib.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : bernd.hellmann
    Created     : Mon May 22 11:24:58 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

PROCEDURE facp:
  DEFINE INPUT  PARAMETER iBase   AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER iResult AS INT64 NO-UNDO.
  iResult = iBase.
END PROCEDURE.

FUNCTION facf RETURNS INT64 (iBase AS INTEGER):
  return iBase.
END FUNCTION.