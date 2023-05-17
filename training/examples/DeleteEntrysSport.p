
/*------------------------------------------------------------------------
    File        : DeleteEntrysSport.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : IAP
    Created     : Fri May 05 07:24:52 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

DEFINE VARIABLE iX AS INTEGER NO-UNDO.
DEFINE BUFFER bCustomer FOR Customer.

FOR EACH bCustomer:
  IF bCustomer.CustNum > 99999 THEN DO:
    DELETE bCustomer.
  END.
END.
MESSAGE "finished"
VIEW-AS ALERT-BOX.