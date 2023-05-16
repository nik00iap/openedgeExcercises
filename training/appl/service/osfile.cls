/**
 * A class representing local files.
 */
CLASS appl.service.osfile:

  /**
   * The working directory used for relative paths.
   */
  DEFINE STATIC PUBLIC PROPERTY cWorkingDirectory AS CHARACTER NO-UNDO INITIAL ?
    GET ():
      IF cWorkingDirectory = ?
        THEN cWorkingDirectory = appl.service.osfile:normalizeName('.',?).
      RETURN cWorkingDirectory.
    END GET.
    SET (cCWD AS CHARACTER):
      cCWD = appl.service.osfile:normalizeName(cCWD,?).
      cWorkingDirectory = cCWD.
    END SET.

  /**
   * The path to the file relative to the root directory.
   */
  DEFINE PUBLIC PROPERTY cPath AS CHARACTER NO-UNDO
    GET.
    PROTECTED SET (cNewName AS CHARACTER):
      cPath = appl.service.osfile:normalizeName(cNewName,appl.service.osfile:cWorkingDirectory).
    END.

  /**
   * The absolute path to the file.
   */
  DEFINE PUBLIC PROPERTY cFullPath AS CHARACTER NO-UNDO
    GET:
      FILE-INFORMATION:FILE-NAME = cPath.
      RETURN(FILE-INFORMATION:FULL-PATHNAME).
    END GET.

  /**
   * The parent directory of the file.
   */
  DEFINE PUBLIC PROPERTY cDirectory AS CHARACTER NO-UNDO
    GET:
        RETURN(SUBSTRING(cPath,1,R-INDEX(cPath,'/'))).
    END.

  /**
   * The name of the file (without the path).
   */
  DEFINE PUBLIC PROPERTY cFullname AS CHARACTER NO-UNDO
    GET:
        RETURN(SUBSTRING(cPath, R-INDEX(cPath,'/') + 1)).
    END.

  /**
   * The name of the file without the extension
   */
  DEFINE PUBLIC PROPERTY cName AS CHARACTER NO-UNDO
    GET:
      DO:
        RETURN SUBSTRING(cFullname, 1, R-INDEX(cFullname, '.') - 1).
      END.
    END.

  /**
   * The extension of the file
   */
  DEFINE PUBLIC PROPERTY cExtension AS CHARACTER NO-UNDO
    GET:
      RETURN(SUBSTRING(cPath,R-INDEX(cPath,'.') + 1)).
    END.

  /**
   * Checks if the file can be written to.
   */
  DEFINE PUBLIC PROPERTY isWritable AS LOGICAL NO-UNDO
    GET:
      DEFINE VARIABLE cAttr AS CHARACTER NO-UNDO.
      FILE-INFORMATION:FILE-NAME = THIS-OBJECT:cPath.
      cAttr = FILE-INFORMATION:FILE-TYPE.
      RETURN INDEX(cAttr,'W') > 0.
    END.

  /**
   * Checks if the file can be read from.
   */
  DEFINE PUBLIC PROPERTY isReadable AS LOGICAL NO-UNDO
    GET:
      DEFINE VARIABLE cAttr AS CHARACTER   NO-UNDO.
      FILE-INFORMATION:FILE-NAME = THIS-OBJECT:cPath.
      cAttr = FILE-INFORMATION:FILE-TYPE.
      RETURN INDEX(cAttr,'R') > 0.
    END.

  /**
   * The size of the file in bytes.
   */
  DEFINE PUBLIC PROPERTY iSize AS INTEGER  NO-UNDO
    GET:
      FILE-INFORMATION:FILE-NAME = cPath.
      RETURN(FILE-INFORMATION:FILE-SIZE).
    END.

  /**
   * The date the file was created at.
   */
  DEFINE PUBLIC PROPERTY dCreationDate AS DATE NO-UNDO
    GET:
      FILE-INFORMATION:FILE-NAME = cPath.
      RETURN(FILE-INFORMATION:FILE-CREATE-DATE).
    END.

   /**
    * Purpose: Creates a new object from a file with a given path.
    * Notes:
    *
    * @param cFileName : character path
    */
  CONSTRUCTOR PUBLIC osfile(cFileName AS CHARACTER):
    cPath = cFileName.
  END CONSTRUCTOR.

   /**
    * Purpose: Renames the file.
    * Notes: Returns true on success.
    *
    * @param cTarget : character new name
    * @return true on success
    */
  METHOD PUBLIC LOGICAL rename (cTarget AS CHARACTER):
    OS-RENAME VALUE(cPath) VALUE(cTarget).
    IF OS-ERROR <> 0 THEN RETURN(FALSE).
    cPath = cTarget.
    RETURN(TRUE).
  END METHOD.

   /**
    * Purpose: Copies the file to a target location.
    * Notes: Returns true on success.
    *
    * @param cTarget : character target location
    * @return true on success
    */
  METHOD PUBLIC LOGICAL copy (cTarget AS CHARACTER):
    OS-COPY VALUE(cPath) VALUE(cTarget).
    RETURN(OS-ERROR = 0).
  END METHOD.

   /**
    * Purpose: Deletes the file.
    * Notes: Returns true on success.
    *
    * @return true on success
    */
  METHOD PUBLIC LOGICAL delete():
    OS-DELETE VALUE(cPath).
    RETURN(OS-ERROR = 0).
  END METHOD.

   /**
    * Purpose: Executes the file.
    * Notes: Returns true on success.
    *
    * @return true if executed
    */
  METHOD PUBLIC LOGICAL execute():
    OS-COMMAND SILENT VALUE(cPath).
    RETURN(OS-ERROR = 0).
  END METHOD.

   /**
    * Purpose:  Returns paths to all files in the given directory that match the given
    * mask as a appl.service.tlist.
    * Notes:
    *
    * @param cDirectory : character directory
    * @param cMask : character mask
    * @return path list
    */
  METHOD STATIC PUBLIC appl.service.tlist search (cDirectory AS CHARACTER, cMask AS CHARACTER):
    DEFINE VARIABLE oList AS CLASS appl.service.tlist.
    oList = NEW appl.service.tlist().
    SEARCH(cDirectory, cMask, oList).
    RETURN(oList).
  END METHOD.

  DEFINE PRIVATE STREAM sDir.

/**
 * Purpose: Adds paths to all files in the given directory that match the given mask to a list
 * Notes:
 *
 * @param cDirectory : character directory
 * @param cMask : character mask
 * @param oList : appl.service.tlist list
 */
  METHOD PROTECTED STATIC VOID search (cDirectory AS CHARACTER, cMask AS CHARACTER, oList AS CLASS appl.service.tlist):
    DEFINE VARIABLE cEntry AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPath  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFlag  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFile  AS CHARACTER NO-UNDO.
    FILE-INFORMATION:FILENAME = cDirectory.
    IF FILE-INFORMATION:FULL-PATHNAME = ? THEN RETURN.
    INPUT /*STREAM sDir*/ FROM OS-DIR(FILE-INFORMATION:FULL-PATHNAME). /* The default stream works with recursion for some reason */
    REPEAT:
      IMPORT /*STREAM sDir*/ cEntry cPath cFlag.
      cPath = REPLACE(cPath, '~\', '/').
      cFile = TRIM(SUBSTRING(cPath,R-INDEX(cPath,'/')),'/').
      IF cEntry = '.' OR cEntry = '..' THEN NEXT.

      cPath = normalizeName(cPath, appl.service.osfile:cWorkingDirectory).
      CASE cFlag:
        WHEN 'D' THEN DO:
          SEARCH(cPath, cMask, oList).
          IF cFile MATCHES cMask THEN DO:
            cPath = normalizeName(cPath, appl.service.osfile:cWorkingDirectory).
            oList:add(cPath).
          END.
        END.
        WHEN 'F' THEN DO:
          IF cFile MATCHES cMask THEN DO:
            cPath = normalizeName(cPath, appl.service.osfile:cWorkingDirectory).
            oList:add(cPath).
          END.
        END.
      END CASE.
    END.
  END METHOD.

   /**
    * Purpose: Sends an email.
    * Notes: TODO: This has absolutely nothing to do in this class
    *
    * @param cAuthType : character
    * @param cServer : character
    * @param iPort : integer
    * @param cUser : character
    * @param cPass : character
    * @param cFrom : character
    * @param cTo : character
    * @param cCc : character
    * @param cSubject : character
    * @param cBody : character
    * @param cAttachments : character
    * @return
    */
  METHOD PUBLIC STATIC LOGICAL sendByMail(
      cAuthType AS CHARACTER,
      cServer AS CHARACTER,
      iPort AS INTEGER,
      cUser AS CHARACTER,
      cPass AS CHARACTER,
      cFrom AS CHARACTER,
      cTo AS CHARACTER,
      cCc AS CHARACTER,
      cSubject AS CHARACTER,
      cBody AS CHARACTER,
      cAttachments AS CHARACTER
    ):

    DEFINE VARIABLE ii AS INTEGER NO-UNDO.
    DEFINE VARIABLE cc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO INITIAL FALSE.

    DEFINE VARIABLE cAuthTypes AS CHARACTER NO-UNDO INITIAL "PLAIN,LOGIN,CRAM-MD5,NTLM,MSN".

    &IF OPSYS = "unix" &THEN
    DEFINE VARIABLE cCmd AS CHARACTER NO-UNDO.
    cCmd = cCmd + "export smtp='" + cServer.
    IF iPort > 0 THEN
      cCmd = cCmd + ":" + STRING(iPort).
    cCmd = cCmd + "'; ".
    cCmd = cCmd + "export smtp_auth='" + cAuthType + "'; ".
    IF cUser <> "" THEN
      cCmd = cCmd + "export smtp_auth_user='" + cUser + "'; ".
    IF cPass <> "" THEN
      cCmd = cCmd + "export smtp_auth_password='" + cPass + "'; ".
    cCmd = cCmd + "echo '" + cBody + "' ".
    cCmd = cCmd + "| mailx -s '" + cSubject + "' ".
    cCmd = cCmd + "-r '" + cFrom + "' ".

    DO ii = 1 TO NUM-ENTRIES(cAttachments):
      cc = ENTRY(ii, cAttachments).
      FILE-INFORMATION:FILE-NAME = cc.
      cc = FILE-INFORMATION:FULL-PATHNAME.
      IF cc <> ? THEN
        cCmd = cCmd + "-a '" + cc + "' ".
    END.
    cCmd = cCmd + cTo.

    OS-COMMAND VALUE(cCmd).
    lOk = TRUE.
    &ELSE

    DEFINE VARIABLE xsmtp AS COM-HANDLE NO-UNDO.
    CREATE "MailBee.SMTP" xsmtp.

    xsmtp:LicenseKey = "MBC600-FCECF59621-821DCCF9917BDE3228D0816BB350E2A5".
    xsmtp:AuthMethod = LOOKUP(cAuthType,cAuthTypes).
    IF xsmtp:AuthMethod > 0 THEN DO:
      xsmtp:UserName = cUser.
      xsmtp:Password = cPass.
    END.

    xsmtp:ServerName = cServer.
    IF NOT iPort = 0  THEN xsmtp:PortNumber = iPort.
    xsmtp:FromAddr   = cfrom.
    xsmtp:ToAddr     = cTo.
    xsmtp:CCAddr     = cCc.
    xsmtp:BodyText   = cBody.
    xsmtp:BodyFormat = 1.
    xsmtp:Subject    = xsmtp:Message:EncodeHeaderText("Subject", REPLACE(cSubject,"~"",""), "ISO-8859-1", 2).

    DO ii = 1 TO NUM-ENTRIES(cAttachments):
      cc = ENTRY(ii, cAttachments).
      FILE-INFORMATION:FILE-NAME = cc.
      cc = FILE-INFORMATION:FULL-PATHNAME.
      IF cc <> ? THEN
        xsmtp:AddAttachment(cc, , , ).
    END.

    IF xsmtp:connect THEN DO:
      IF xsmtp:send THEN lOk = TRUE.
      xsmtp:DISCONNECT.
    END.

    RELEASE OBJECT xsmtp.
    &ENDIF

    RETURN lOk.
  END METHOD.

   /**
    * Purpose: Returns a unix like path to the given file relative to the given directory.
    * Notes: Use ? as cRelativeTo for an absolute path
    *
    * @param cFile : character directory
    * @param cRelativeTo : character file relative
    * @return path
    */
  METHOD PUBLIC STATIC CHARACTER normalizeName(cFile AS CHARACTER, cRelativeTo AS CHARACTER):
    FILE-INFORMATION:FILE-NAME = cFile.
    IF FILE-INFORMATION:FULL-PATHNAME <> ?
      THEN cFile = REPLACE(FILE-INFORMATION:FULL-PATHNAME,'~\','/').
      ELSE cFile = REPLACE(cFile,'~\','/').

    cRelativeTo = RIGHT-TRIM(REPLACE(cRelativeTo,'~\','/'),'/').
    IF cFile BEGINS cRelativeto AND cRelativeTo > "" THEN DO:
      cFile = SUBSTRING(cFile, LENGTH(cRelativeTo) + 2).
    END.

    RETURN RIGHT-TRIM(cFile,'/').
  END METHOD.

   /**
    * Purpose: Checks if a given file exists.
    * Notes:
    *
    * @param cPath : character file path
    * @return true if exists
    */
  METHOD PUBLIC STATIC LOGICAL exists (cPath AS CHARACTER):
    FILE-INFORMATION:FILE-NAME = cPath.
    RETURN(FILE-INFORMATION:FULL-PATHNAME <> ?).
  END METHOD.

  /**
   * Convers a class-path (like appl.service.osfile) to a path to the class file
   * (like t4p/util/osfile.cls)
   */
   /**
    * Purpose: Convers a class-path (like appl.service.osfile) to a path to the class file
    * (like t4p/util/osfile.cls)
    * Notes:
    *
    * @param cClassName : character class-path
    * @return class file
    */

  METHOD PUBLIC STATIC CHARACTER classToPath (cClassName AS CHARACTER):
    RETURN REPLACE(cClassName, ".", "/") + ".cls".
  END METHOD.

   /**
    * Purpose: Converts the path to a class file (like t4p/util/osfile.cls) into a
    * class-path (like appl.service.osfile)
    * Notes:
    *
    * @param cFileName : character class file
    * @return class-path
    */
  METHOD PUBLIC STATIC CHARACTER pathToClass (cFileName AS CHARACTER):
    DEFINE VARIABLE cClass AS CHARACTER NO-UNDO.
    cClass = REPLACE(normalizeName(cFileName, appl.service.osfile:cWorkingDirectory),'/','.').
    cClass = SUBSTRING(cClass, 1, LENGTH(cClass) - 4) NO-ERROR.
    RETURN cClass.
  END METHOD.

   /**
    * Purpose: Convers a class-path to the name of the package and the name of the class.
    * Notes:
    *
    * @param cPackageAndName : character class-path
    * @param cPackage : output character package
    * @param cName : output character class
    */
  METHOD PUBLIC STATIC VOID classToPackageAndName(cPackageAndName AS CHARACTER, OUTPUT cPackage AS CHARACTER, OUTPUT cName AS CHARACTER):
    DEFINE VARIABLE iLastPeriodIndex AS INTEGER NO-UNDO.
    cPackage = ?.
    cName = ?.
    IF cPackageAndName > "" THEN DO:
      iLastPeriodIndex = R-INDEX(cPackageAndName, ".").
      IF iLastPeriodIndex > 1 THEN DO:
        cPackage = SUBSTRING(cPackageAndName, 1, iLastPeriodIndex - 1) NO-ERROR.
        cName    = SUBSTRING(cPackageAndName, iLastPeriodIndex + 1) NO-ERROR.
      END.
    END.
  END METHOD.

/**
 * Purpose: Gets the name of the given file (with extension).
 * Notes:
 *
 * @param cFileName : character file
 * @return name
 */
  METHOD PUBLIC STATIC CHARACTER getFullName (cFileName AS CHARACTER):
    RETURN (NEW appl.service.osfile (cFileName)):cFullName.
  END METHOD.

   /**
    * Purpose: Gets the name without extension of the given file.
    * Notes:
    *
    * @param cFileName : character file
    * @return name
    */
  METHOD PUBLIC STATIC CHARACTER getName (cFileName AS CHARACTER):
    RETURN (NEW appl.service.osfile (cFileName)):cName.
  END METHOD.

   /**
    * Purpose: Recusively creates the directory of a given path.
    * Notes:
    *
    * @param cFileName : character path
    * @return false on error
    */
  METHOD PUBLIC STATIC LOGICAL makeDirectory(cFileName AS CHARACTER):
    DEFINE VARIABLE cDirectory AS CHARACTER NO-UNDO.

    FILE-INFORMATION:FILE-NAME = cFilename.
    IF FILE-INFORMATION:FILE-TYPE BEGINS "D" THEN RETURN TRUE.

    cFileName = normalizeName(cFileName, "").
    cDirectory = SUBSTRING(cFileName, 1, R-INDEX(cFileName, "/") - 1).

    IF cDirectory = cFileName THEN RETURN FALSE.

    FILE-INFORMATION:FILE-NAME = cDirectory.
    IF FILE-INFORMATION:FILE-TYPE BEGINS "D" THEN RETURN TRUE.
    IF FILE-INFORMATION:FILE-TYPE = ? AND NOT appl.service.osfile:makeDirectory(cDirectory) THEN RETURN FALSE.

    OS-CREATE-DIR VALUE(cDirectory).

    RETURN (OS-ERROR = 0).
  END METHOD.

   /**
    * Purpose: Searches a procedure file with a given name.
    * Notes: preferes .r files
    *
    * @param cFile : character file name
    * @return path
    */
  METHOD PUBLIC STATIC CHARACTER searchProg (cFile AS CHARACTER):
    DEFINE VARIABLE cRet  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cExts AS CHARACTER NO-UNDO INITIAL "r,p,w".
    DEFINE VARIABLE ii    AS INTEGER   NO-UNDO.

    cFile = getName(cFile).
    IF cFile <> "" THEN DO:
      DO ii = 1 TO NUM-ENTRIES(cExts):
        FILE-INFORMATION:FILE-NAME = cFile + "." + ENTRY(ii, cExts).
        cRet = FILE-INFORMATION:FULL-PATHNAME.
        IF cRet <> ? THEN RETURN cRet.
      END.
    END.

    RETURN "".
  END METHOD.

   /**
    * Purpose: Calculates an MD5-hash value of a given file.
    * Notes: Returns ? if file name is ?
    *
    * @param cFileName : character file name
    * @return hash value
    */
  METHOD PUBLIC STATIC CHARACTER calcHash (INPUT cFileName AS CHARACTER):
    DEFINE VARIABLE cLong   AS LONGCHAR  NO-UNDO.
    DEFINE VARIABLE cResult AS CHARACTER NO-UNDO.
    FILE-INFORMATION:FILE-NAME = cFileName.
    IF FILE-INFORMATION:FULL-PATHNAME = ? THEN RETURN ?.
    COPY-LOB FROM FILE FILE-INFORMATION:FULL-PATHNAME TO cLong NO-CONVERT.
    cLong = REPLACE(cLong, CHR(13) + CHR(10), CHR(10)).
    cLong = REPLACE(cLong, CHR(13), CHR(10)).
    cResult = HEX-ENCODE(MD5-DIGEST(cLong)).
    RETURN cResult.
  END METHOD.
END CLASS.
