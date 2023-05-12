
/*------------------------------------------------------------------------
    File        : AddEntrysSportsCustomer.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : IAP
    Created     : Fri May 05 07:19:30 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iX AS INTEGER NO-UNDO.
DEFINE BUFFER bCustomer FOR Customer.

DO iX = 100000 TO 200000 TRANSACTION:
  CREATE bCustomer.
  ASSIGN
    bCustomer.CustNum  = iX
    bCustomer.Name     = "Test" + String(iX)
    bCustomer.Balance  = iX * 0.01
    bCustomer.Country  = "USA"
    . 
END.
MESSAGE "finished"
VIEW-AS ALERT-BOX.