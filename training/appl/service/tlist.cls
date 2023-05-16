/**
 * tlist
 *
 * Represents a list of elements of varying types.
 */
CLASS appl.service.tlist:
  DEFINE PROTECTED STATIC TEMP-TABLE tData NO-UNDO
    FIELD oList AS CLASS Progress.Lang.Object SERIALIZE-HIDDEN
    FIELD iKey  AS INTEGER
    FIELD cVal  AS CHARACTER
    FIELD oVal  AS CLASS Progress.Lang.Object SERIALIZE-HIDDEN
    FIELD cType AS CHARACTER
    INDEX cKey IS UNIQUE oList iKey.


  DEFINE PROTECTED BUFFER bCurrentEntry FOR tData.

  /**
   * The current entry of the list as an object.
   */
  DEFINE PUBLIC PROPERTY oEntry AS Progress.Lang.Object NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(oEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(oVal AS Progress.Lang.Object).
      IF AVAILABLE bCurrentEntry THEN oEntry(bCurrentEntry.iKey, oVal).
    END SET.


  /**
   * The dataype of the current entry of the list.
   */
  DEFINE PUBLIC PROPERTY type AS CHARACTER NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(bCurrentEntry.cType).
      RETURN(?).
    END GET.
    SET(cType AS CHARACTER).
      IF AVAILABLE bCurrentEntry THEN bCurrentEntry.cType = cType.
    END SET.

  /**
   * The current entry of the list as a string.
   */
  DEFINE PUBLIC PROPERTY cEntry AS CHARACTER NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(cEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(cVal AS CHARACTER).
      IF AVAILABLE bCurrentEntry THEN cEntry(bCurrentEntry.iKey, cVal).
    END SET.

  /**
   * The current entry of the list as an integer.
   */
  DEFINE PUBLIC PROPERTY iEntry AS INTEGER NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(iEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(iVal AS INTEGER).
      IF AVAILABLE bCurrentEntry THEN iEntry(bCurrentEntry.iKey,iVal).
    END SET.

  /**
   * The current entry of the list as a decimal value.
   */
  DEFINE PUBLIC PROPERTY fEntry AS DECIMAL NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(fEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(fVal AS DECIMAL).
      IF AVAILABLE bCurrentEntry THEN fEntry(bCurrentEntry.iKey, fVal).
    END SET.

  /**
   * The current entry of the list as a logical value.
   */
  DEFINE PUBLIC PROPERTY lEntry AS LOGICAL NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(lEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(lVal AS LOGICAL).
      IF AVAILABLE bCurrentEntry THEN lEntry(bCurrentEntry.iKey, lVal).
    END SET.

  /**
   * The current entry of the list as a date.
   */
  DEFINE PUBLIC PROPERTY dEntry AS DATE NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(dEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(dVal AS DATE).
      IF AVAILABLE bCurrentEntry THEN dEntry(bCurrentEntry.iKey, dVal).
    END SET.

  /**
   * The current entry of the list as a datetime value.
   */
  DEFINE PUBLIC PROPERTY dtEntry AS DATETIME NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(dtEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(dtVal AS DATETIME).
      IF AVAILABLE bCurrentEntry THEN dtEntry(bCurrentEntry.iKey, dtVal).
    END SET.

  /**
   * The current entry of the list as a datetime value.
   */
  DEFINE PUBLIC PROPERTY hEntry AS HANDLE NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(hEntry(bCurrentEntry.iKey)).
      RETURN(?).
    END GET.
    SET(hVal AS HANDLE).
      IF AVAILABLE bCurrentEntry THEN hEntry(bCurrentEntry.iKey, hVal).
    END SET.

  /**
   * The number of elements in the list.
   */
  DEFINE PUBLIC PROPERTY iNumEntries AS INTEGER NO-UNDO
    GET():
      DEFINE BUFFER bData FOR tData.
      DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
      FOR EACH bData WHERE bData.oList = THIS-OBJECT:
        iCount = iCount + 1.
      END.
      RETURN iCount.
    END GET.

  /**
   * The current position inside the list.
   */
  DEFINE PUBLIC PROPERTY iEntryIndex AS INTEGER NO-UNDO
    GET():
      IF AVAILABLE bCurrentEntry THEN RETURN(bCurrentEntry.iKey).
      RETURN(?).
    END GET.
    SET(i AS INTEGER):
      FIND bCurrentEntry WHERE bCurrentEntry.oList = THIS-OBJECT AND bCurrentEntry.iKey = i NO-ERROR.
    END SET.

   /**
    * Purpose: Creates a new, empty list.
    * Notes:
    *
    */
  CONSTRUCTOR PUBLIC tlist():
  END CONSTRUCTOR.

   /**
    * Purpose: Creates a new list based of a character list, seperated by a given delimiter.
    * Notes:
    *
    * @param cList : character character list
    * @param cDelimiter : character delimiter
    */
  CONSTRUCTOR PUBLIC tlist(cList AS CHARACTER, cDelimiter AS CHARACTER):
    THIS-OBJECT:add(cList, cDelimiter).
  END CONSTRUCTOR.

   /**
    * Purpose: Creates a new list based of a longchar list, seperated by a given delimiter.
    * Notes:
    *
    * @param cList : longchar longchar list
    * @param cDelimiter : character delimiter
    */
  CONSTRUCTOR PUBLIC tlist(cList AS LONGCHAR, cDelimiter AS CHARACTER):
    THIS-OBJECT:add(cList, cDelimiter).
  END CONSTRUCTOR.

  /**
   * Purpose: Empties the list.
   * Notes:
   *
   */
  DESTRUCTOR PUBLIC tList ():
    empty().
  END DESTRUCTOR.

   /**
    * Purpose: Positions the internal pointer to the first element of the list.
    * Notes:
    *
    * @return true if valid entry
    */
  METHOD PUBLIC LOGICAL first():
    FIND FIRST bCurrentEntry WHERE bCurrentEntry.oList = THIS-OBJECT NO-ERROR.
    RETURN AVAILABLE bCurrentEntry.
  END METHOD.

   /**
    * Purpose: Positions the internal pointer to the last element of the list.
    * Notes:
    *
    * @return true if valid entry
    */
  METHOD PUBLIC LOGICAL last():
    FIND LAST bCurrentEntry WHERE bCurrentEntry.oList = THIS-OBJECT NO-ERROR.
    RETURN AVAILABLE bCurrentEntry.
  END METHOD.

   /**
    * Purpose: Positions the internal pointer to the next element of the list.
    * Notes:
    *
    * @return true if valid entry
    */
  METHOD PUBLIC LOGICAL next():
    IF NOT AVAILABLE bCurrentEntry THEN RETURN(THIS-OBJECT:first()).
    FIND NEXT bCurrentEntry WHERE bCurrentEntry.oList = THIS-OBJECT NO-ERROR.
    RETURN AVAILABLE bCurrentEntry.
  END METHOD.

   /**
    * Purpose: Positions the internal pointer to the previous element of the list.
    * Notes:
    *
    * @return true if valid entry
    */
  METHOD PUBLIC LOGICAL prev():
    IF NOT AVAILABLE bCurrentEntry THEN RETURN(THIS-OBJECT:last()).
    FIND PREV bCurrentEntry WHERE bCurrentEntry.oList = THIS-OBJECT NO-ERROR.
    RETURN AVAILABLE bCurrentEntry.
  END METHOD.

   /**
    * Purpose: Returns the element of the list at the given position as an object.
    * Notes: If no element was found, ? is returned.
    *
    * @param iKey : integer position
    * @return list element as object
    */
  METHOD PUBLIC Progress.Lang.Object oEntry (iKey AS INTEGER):
    DEFINE BUFFER bData FOR tData.
    FIND FIRST bData WHERE bData.oList = THIS-OBJECT AND bData.iKey = iKey NO-LOCK NO-ERROR.
    RETURN (IF AVAILABLE bData THEN bData.oVal ELSE ?).
  END METHOD.

   /**
    * Purpose: Returns the element of the list at the given position as a string.
    * Notes: If no element was found, ? is returned.
    *
    * @param iKey : integer position
    * @return list element as string
    */
  METHOD PUBLIC CHARACTER cEntry (iKey AS INTEGER):
    DEFINE BUFFER bData FOR tData.
    FIND bData WHERE bData.oList = THIS-OBJECT AND bData.iKey = iKey NO-LOCK NO-ERROR.
    RETURN (IF AVAILABLE bData THEN bData.cVal ELSE ?).
  END METHOD.

   /**
    * Purpose: Returns the element of the list at the given position as an integer.
    * Notes: If no element was found, ? is returned.
    *
    * @param iKey : integer position
    * @return list element as integer
    */
  METHOD PUBLIC INTEGER iEntry (iKey AS INTEGER):
    DEFINE VARIABLE iVal AS INTEGER NO-UNDO.
    iVal = INTEGER(cEntry(iKey)) NO-ERROR.
    RETURN iVal.
  END METHOD.

   /**
    * Purpose: Returns the element of the list at the given position as a decimal.
    * Notes: If no element was found, ? is returned.
    *
    * @param iKey : integer position
    * @return list element as decimal
    */
  METHOD PUBLIC DECIMAL fEntry (iKey AS INTEGER):
    DEFINE VARIABLE fVal AS DECIMAL NO-UNDO.
    fVal = DECIMAL(cEntry(iKey)) NO-ERROR.
    RETURN fVal.
  END METHOD.
   /**
    * Purpose: Returns the element of the list at the given position as a logical value.
    * Notes: If no element was found, ? is returned.
    *
    * @param iKey : integer position
    * @return list element as logical value
    */
  METHOD PUBLIC LOGICAL lEntry (iKey AS INTEGER):
    DEFINE VARIABLE lVal AS LOGICAL NO-UNDO.
    lVal = LOGICAL(cEntry(iKey)) NO-ERROR.
    RETURN lVal.
  END METHOD.

   /**
    * Purpose: Returns the element of the list at the given position as a date.
    * Notes: If no element was found, ? is returned.
    *
    * @param iKey : integer position
    * @return list element as date
    */
  METHOD PUBLIC DATE dEntry (iKey AS INTEGER):
    DEFINE VARIABLE dVal AS DATE NO-UNDO.
    dVal = DATE(cEntry(iKey)) NO-ERROR.
    RETURN dVal.
  END METHOD.

   /**
    * Purpose: Returns the element of the list at the given position as a datetime value.
    * Notes: If no element was found, ? is returned.
    *
    * @param iKey : integer position
    * @return list element as datetime value
    */
  METHOD PUBLIC DATETIME dtEntry (iKey AS INTEGER):
    DEFINE VARIABLE dtVal AS DATETIME NO-UNDO.
    dtVal = DATETIME(cEntry(iKey)) NO-ERROR.
    RETURN dtVal.
  END METHOD.

  /**
   * Purpose: Returns the element of the list at the given position as a handle.
   * Notes: If no element was found, ? is returned.
   *
   * @param iKey : integer position
   * @return  list element as handle
   */
  METHOD PUBLIC HANDLE hEntry (iKey AS INTEGER):
    DEFINE VARIABLE hVal AS HANDLE NO-UNDO.
    hVal = WIDGET-HANDLE(cEntry(iKey)) NO-ERROR.
    RETURN hVal.
  END METHOD.

   /**
    * Purpose: Sets the value at the given position to the given object.
    * Notes:
    *
    * @param iKey : integer position
    * @param oValue : Progress.Lang.Object value
    * @return true if succesfull
    */
  METHOD PUBLIC LOGICAL oEntry (iKey AS INTEGER, oValue AS Progress.Lang.Object):
    DEFINE BUFFER bData FOR tData.
    FIND FIRST bData WHERE bData.oList = THIS-OBJECT AND bData.iKey = iKey NO-LOCK NO-ERROR.
    IF AVAILABLE bData THEN bData.oVal = oValue.
    RETURN (AVAILABLE (bData)).
  END METHOD.

   /**
    * Purpose: Sets the value at the given position to the given character value.
    * Notes:
    *
    * @param iKey : integer position
    * @param cValue : character value
    * @return true if succesfull
    */
  METHOD PUBLIC LOGICAL cEntry (iKey AS INTEGER, cValue AS CHARACTER):
    DEFINE BUFFER bData FOR tData.
    FIND FIRST bData WHERE bData.oList = THIS-OBJECT AND bData.iKey = iKey NO-LOCK NO-ERROR.
    IF AVAILABLE bData THEN bData.cVal = cValue.
    RETURN (AVAILABLE (bData)).
  END METHOD.

   /**
    * Purpose: Sets the value at the given position to the given integer value.
    * Notes:
    *
    * @param iKey : integer position
    * @param iValue : integer value
    * @return true if succesfull
    */
  METHOD PUBLIC LOGICAL iEntry (iKey AS INTEGER, iValue AS INTEGER):
    RETURN cEntry(iKey, STRING(iValue)).
  END METHOD.

  /**
   * Purpose: Sets the value at the given position to the given float value.
   * Notes:
   *
   * @param iKey : integer position
   * @param fValue : decimal value
   * @return true if succesfull
   */
  METHOD PUBLIC LOGICAL fEntry (iKey AS INTEGER, fValue AS DECIMAL):
    RETURN cEntry(iKey, STRING(fValue)).
  END METHOD.

   /**
    * Purpose: Sets the value at the given position to the given logical value.
    * Notes:
    *
    * @param iKey : integer position
    * @param lValue : logical value
    * @return true if succesfull
    */
  METHOD PUBLIC LOGICAL lEntry (iKey AS INTEGER, lValue AS LOGICAL):
    RETURN cEntry(iKey, STRING(lValue)).
  END METHOD.

  /**
   * Purpose: Sets the value at the given position to the given date.
   * Notes:
   *
   * @param iKey : integer position
   * @param dValue : date value
   * @return true if succesfull
   */
  METHOD PUBLIC LOGICAL dEntry (iKey AS INTEGER, dValue AS DATE):
    RETURN cEntry(iKey, STRING(dValue)).
  END METHOD.

  /**
   * Purpose: Sets the value at the given position to the given datetime value.
   * Notes:
   *
   * @param iKey : integer position
   * @param dtValue : datetime value
   * @return true if succesfull
   */
  METHOD PUBLIC LOGICAL dtEntry (iKey AS INTEGER, dtValue AS DATETIME):
    RETURN cEntry(iKey, STRING(dtValue)).
  END METHOD.

  /**
   * Purpose: Sets the value at the given position to the given handle.
   * Notes:
   *
   * @param iKey : integer position
   * @param hValue : handle value
   * @return true if succesfull
   */
  METHOD PUBLIC LOGICAL hEntry (iKey AS INTEGER, hValue AS HANDLE):
    RETURN cEntry(iKey, STRING(hValue)).
  END METHOD.

   /**
    * Purpose: Adds a new value at the given position into the list.
    * Notes: If the position is ?, it inserts the value at the end of the list.
    *
    * @param iKey : integer position
    * @param cValue : character first value
    * @param oValue : Progress.Lang.Object second value
    * @param cType : character third value
    */
  METHOD PUBLIC VOID addKey (iKey AS INTEGER, cValue AS CHARACTER, oValue AS Progress.Lang.Object, cType AS CHARACTER):
    DEFINE BUFFER bData FOR tData.
    IF iKey = ? THEN DO:
      FIND LAST bData WHERE bData.oList = THIS-OBJECT NO-ERROR.
      iKey = IF AVAILABLE bData THEN bData.iKey + 1 ELSE 1.
    END.
    FIND bData WHERE bData.oList = THIS-OBJECT AND bData.iKey = iKey NO-ERROR.
    IF NOT AVAILABLE bData THEN DO:
      FIND FIRST bData WHERE bData.oList = ? NO-ERROR.
      IF NOT AVAILABLE bData THEN CREATE bData.
    END.
    ASSIGN
      bData.oList = THIS-OBJECT
      bData.iKey = iKey
      bData.cVal = cValue
      bData.oVal = oValue
      bData.cType = cType.
  END METHOD.

  /**
   * Purpose: Adds an object to the end of the list.
   * Notes:
   *
   * @param oValue : Progress.Lang.Object object
   */
  METHOD PUBLIC VOID add (oValue AS Progress.Lang.Object):
    THIS-OBJECT:addKey(?, ?, oValue, "OBJECT").
  END METHOD.

  /**
   * Purpose: Adds a string to the end of the list.
   * Notes:
   *
   * @param cValue : character string
   */
  METHOD PUBLIC VOID add (cValue AS CHARACTER):
    THIS-OBJECT:addKey(?, cValue, ?, "CHARACTER").
  END METHOD.

  /**
   * Purpose: Adds an integer to the end of the list.
   * Notes:
   *
   * @param iValue : integer integer
   */
  METHOD PUBLIC VOID add (iValue AS INTEGER):
    THIS-OBJECT:addKey(?, STRING(iValue), ?, "INTEGER").
  END METHOD.

  /**
   * Purpose: Adds a decimal to the end of the list.
   * Notes:
   *
   * @param fValue : decimal decimal
   */
  METHOD PUBLIC VOID add (fValue AS DECIMAL):
    THIS-OBJECT:addKey(?, STRING(fValue), ?, "DECIMAL").
  END METHOD.

  /**
   * Purpose: Adds a date to the end of the list.
   * Notes:
   *
   * @param dValue : date date
   */
  METHOD PUBLIC VOID add (dValue AS DATE):
    THIS-OBJECT:addKey(?, STRING(dValue), ?, "DATE").
  END METHOD.

  /**
   * Purpose: Adds a handle to the end of the list.
   * Notes:
   *
   * @param dValue : date date
   */
  METHOD PUBLIC VOID add (dValue AS HANDLE):
    THIS-OBJECT:addKey(?, STRING(dValue), ?, "HANDLE").
  END METHOD.

  /**
   * Purpose: Adds an existing character list to the end of this list, seperated by cDelimiter
   * Notes:
   *
   * @param cList : character character list
   * @param cDelimiter : character seperator
   */
  METHOD PUBLIC VOID add (cList AS CHARACTER, cDelimiter AS CHARACTER):
    DEFINE VARIABLE ii AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
    iCount = NUM-ENTRIES(cList, cDelimiter).
    DO ii = 1 TO iCount:
      THIS-OBJECT:add(ENTRY(ii,cList,cDelimiter)).
    END.
  END METHOD.

  /**
   * Purpose:Adds an existing longchar list to the end of this list, seperated by cDelimiter
   * Notes:
   *
   * @param cList : longchar longchar list
   * @param cDelimiter : character seperator
   */
  METHOD PUBLIC VOID add (cList AS LONGCHAR, cDelimiter AS CHARACTER):
    DEFINE VARIABLE ii AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
    iCount = NUM-ENTRIES(cList, cDelimiter).
    DO ii = 1 TO iCount:
      THIS-OBJECT:add(STRING(ENTRY(ii,cList,cDelimiter))).
    END.
  END METHOD.

  /**
   * Purpose: Clears this list.
   * Notes:
   *
   */
  METHOD PUBLIC VOID empty():
    DEFINE BUFFER bData FOR tData.
    FOR EACH bData WHERE bData.oList = THIS-OBJECT:
      bData.oList = ?.
      bData.oVal = ?.
      DELETE bData.
    END.
  END METHOD.

  /**
   * Purpose: Removes all instances of the given object from the list.
   * Notes:
   *
   * @param oValue : Progress.Lang.Object object
   */
  METHOD PUBLIC VOID remove (oValue AS Progress.Lang.Object):
    DEFINE BUFFER bData FOR tData.
    FOR EACH bData WHERE bData.oList = THIS-OBJECT AND bData.oVal = oValue NO-LOCK:
      bData.oList = ?.
      bData.oVal = ?.
    END.
  END METHOD.

  /**
   * Purpose: Removes all instances of the given string from the list.
   * Notes:
   *
   * @param cValue : character string
   */
  METHOD PUBLIC LOGICAL remove (cValue AS CHARACTER):
    DEFINE BUFFER bData FOR tData.
    FOR EACH bData WHERE bData.oList = THIS-OBJECT AND bData.cVal = cValue NO-LOCK:
      bData.oList = ?.
    END.
  END METHOD.

  /**
   * Purpose: Removes all instances of the given integer from the list.
   * Notes:
   *
   * @param iValue : integer integer
   */
  METHOD PUBLIC LOGICAL remove (iValue AS INTEGER):
    RETURN remove(STRING(iValue)).
  END METHOD.

  /**
   * Purpose: Removes all instances of the given decimal from the list.
   * Notes:
   *
   * @param fValue : decimal decimal
   */
  METHOD PUBLIC LOGICAL remove (fValue AS DECIMAL):
    RETURN remove(STRING(fValue)).
  END METHOD.

  /**
   * Purpose: Removes all instances of the given logical value from the list.
   * Notes:
   *
   * @param lValue : logical logical value
   */
  METHOD PUBLIC LOGICAL remove (lValue AS LOGICAL):
    RETURN remove(STRING(lValue)).
  END METHOD.

  /**
   * Purpose: Removes all instances of the given date value from the list.
   * Notes:
   *
   * @param dValue : date date value
   * @return
   */
  METHOD PUBLIC LOGICAL remove (dValue AS DATE):
    RETURN remove(STRING(dValue)).
  END METHOD.

  /**
   * Purpose: Removes all instances of every entry in a given list from this list.
   * Notes:
   *
   * @param oOther : appl.service.tlist list
   */
  METHOD PUBLIC LOGICAL removeList (oOther AS appl.service.tlist):
    DEFINE BUFFER bMyData FOR tData.
    DEFINE BUFFER bOtherData FOR tData.

    FOR EACH bOtherData WHERE bOtherData.oList = oOther,
        EACH bMyData WHERE bMyData.oVal = THIS-OBJECT AND bMyData.cVal = bOtherData.cVal AND bMyData.oVal = bOtherData.oVal:
      bMyData.oList = ?.
      bMyData.oVal = ?.
    END.
  END METHOD.

  /**
   * Purpose: Adds all elements of the given list to this list if they are not already there
   * Notes:
   *
   * @param oOther : appl.service.tlist list
   */
  METHOD PUBLIC LOGICAL addListUnique (oOther AS appl.service.tlist):
    DEFINE BUFFER bMyData FOR tData.
    DEFINE BUFFER bOtherData FOR tData.

    FOR EACH bOtherData WHERE bOtherData.oList = oOther:
      IF NOT CAN-FIND (bMyData WHERE bMyData.oList = THIS-OBJECT AND bMyData.cVal = bOtherData.cVal AND bMyData.oVal = bOtherData.oVal) THEN DO:
        addKey(?, bOtherData.cVal, bOtherData.oVal, ?).
      END.
    END.
  END METHOD.

  /**
   * Purpose: Checks if this list and the given list contain the same elements.
   * Notes: Regardless of positioning
   *
   * @param oOther : appl.service.tlist list
   * @return true if succesfull
   */
  METHOD PUBLIC LOGICAL equals (oOther AS appl.service.tlist):
    DEFINE BUFFER bMyData FOR tData.
    DEFINE BUFFER bOtherData FOR tData.
    IF iNumEntries <> oOther:iNumEntries THEN RETURN FALSE.

    FOR EACH bOtherData WHERE bOtherData.oList = oOther:
      IF NOT CAN-FIND (bMyData WHERE bMyData.oList = THIS-OBJECT AND bMyData.cVal = bOtherData.cVal AND bMyData.oVal = bOtherData.oVal) THEN DO:
        RETURN FALSE.
      END.
    END.

    RETURN TRUE.
  END.

  /**
   * Purpose: Returns the list as a comma seperated character list.
   * Notes:
   *
   * @return list
   */
  METHOD OVERRIDE PUBLIC CHARACTER toString():
    RETURN toString(",").
  END.

  /**
   * Purpose: Returns the list as a character list seperated by the given delimiter.
   * Notes:
   *
   * @param cDelim : character delimiter
   * @return character list
   */
  METHOD PUBLIC CHARACTER toString(cDelim AS CHARACTER):
    DEFINE VARIABLE cList AS CHARACTER NO-UNDO.

    FOR EACH tData WHERE tData.oList = THIS-OBJECT:
      cList = cList + cDelim + (IF VALID-OBJECT(tData.oVal) THEN tData.oVal:toString() ELSE tData.cVal).
    END.

    RETURN TRIM(cList, cDelim).
  END METHOD.

  /**
   * Purpose: Removes all elements from this list that are not also contained within the given list.
   * Notes:
   *
   * @param oOther : appl.service.tlist list
   */
  METHOD PUBLIC VOID setIntersection (oOther AS appl.service.tlist):
    DEFINE BUFFER bMyData FOR tData.
    DEFINE BUFFER bOtherData FOR tData.

    FOR EACH bMyData WHERE bMyData.oList = THIS-OBJECT:
      IF NOT CAN-FIND (bOtherData WHERE bOtherData.oVal = oOther AND bMyData.cVal = bOtherData.cVal AND bMyData.oVal = bOtherData.oVal) THEN DO:
        bMyData.oList = ?.
        bMyData.oVal = ?.
      END.
    END.
  END METHOD.

  /**
   * Purpose: Creates a shallow copy of this list.
   * Notes:
   *
   * @return copy
   */
  METHOD PUBLIC appl.service.tlist copy ():
    DEFINE BUFFER bMyData FOR tData.
    DEFINE BUFFER bOtherData FOR tData.

    DEFINE VARIABLE oList AS appl.service.tlist NO-UNDO.
    oList = NEW appl.service.tlist ().

    FOR EACH bMyData WHERE bMyData.oList = THIS-OBJECT:
      oList:addKey(?, bMyData.cVal, bMyData.oVal, bMyData.cType).
    END.

    RETURN oList.
  END METHOD.

  /**
   * Purpose: Checks if two character lists contain the same elements.
   * Notes: regardless of position
   *
   * @param cList1 : character first list
   * @param cList2 : character second list
   * @return  true if same
   */
  METHOD PUBLIC STATIC LOGICAL listsEqual(cList1 AS CHARACTER, cList2 AS CHARACTER):
    DEFINE VARIABLE ii   AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCnt AS INTEGER NO-UNDO.
    iCnt = NUM-ENTRIES(cList1).
    IF NUM-ENTRIES(cList2) <> iCnt THEN RETURN FALSE.
    DO ii = 1 TO iCnt:
      IF LOOKUP(ENTRY(ii,cList1), cList2) = 0 THEN RETURN FALSE.
    END.
    RETURN TRUE.
  END METHOD.

  /**
   * Purpose: Returns the last value of a given list.
   * Notes:
   *
   * @param cList : character list
   * @param cDelimiter : character delimiter
   * @return value
   */
  METHOD PUBLIC STATIC CHARACTER lastEntry(cList AS CHARACTER, cDelimiter AS CHARACTER):
    IF cDelimiter > "" THEN cDelimiter = ",".
    RETURN ENTRY(NUM-ENTRIES(cList, cDelimiter), cList, cDelimiter).
  END METHOD.


END CLASS.
