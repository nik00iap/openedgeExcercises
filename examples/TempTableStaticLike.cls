 
 /*------------------------------------------------------------------------
    File        : TempTableStaticLike
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : IAP
    Created     : Thu May 04 08:01:14 CEST 2023
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS OpenedgeExercises.TempTableStaticLike: 
  
  DEFINE TEMP-TABLE tt-Customer LIKE Customer.

      
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC TempTableStaticLike (  ):
    SUPER ().
    mFillTT().
    mDisplayTT().
    
  END CONSTRUCTOR.
  
  
  /*------------------------------------------------------------------------------
   Purpose:Copys the all Entrys that the Databas and the TempTable share from the Database into the TempTable.
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PRIVATE VOID mFillTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
    DEFINE BUFFER bCustomer FOR Customer.
    
    FOR EACH bCustomer:
      CREATE btt-Customer.
       BUFFER-COPY bCustomer TO btt-Customer.
      
    END.
  END METHOD.
  
  
  /*------------------------------------------------------------------------------
   Purpose:Displays the Entries in the TempTable
   Notes:
  ------------------------------------------------------------------------------*/  
  METHOD PUBLIC VOID mDisplayTT():
    DEFINE BUFFER btt-Customer FOR tt-Customer.
     
    FOR EACH btt-Customer BY CustNum:
      DISPLAY btt-Customer EXCEPT btt-Customer.Comments.
    END.
  END METHOD.


END CLASS.