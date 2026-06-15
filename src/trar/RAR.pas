//  originally written by Philippe Wechsler in 2008
//  completely re-written by Baz Cuda in 2025
//
//  web: www.PhilippeWechsler.ch
//  mail: contact@PhilippeWechsler.ch
//
//  please see license.txt and documentation.txt
//
//  changes in 2.1 stable
//  added findFiles()
//  minor fix to TRAROpenArchiveDataEx
//
//  changes in 2.0 stable (2025, Baz Cuda - https://github.com/BazzaCuda/TRARunrar/)
//  - supports both the 32-bit and 64-bit versions of unrar.dll
//  - switched to using the ...Ex functions in unrar.dll to get added info
//  - each file's checksum (e.g. Blake2) is now accessible
//  - support for WideChar filenames in archives
//  - reformatted the code and added significant amounts of whitespace for enhanced readability
//  - completely re-architected and rewritten
//  - started a GoFundMe page to buy Philippe a keyboard with a space bar :D
//
//  changes in 1.2 stable
//   - support for delphi 2009
//   - support for unicode filenames (see TRARFileItem.FileNameW)
//   - dll name + path is custom
//   - fixed a memory leak (thanks to Claes Enskär)
//   - some small improvements in the demo
//  changes in 1.1 stable
//   - fixed problem with mySelf pointer - you can use now multiple TRAR instances
//   - "SFX" in archive informations
//   - code better commented
//   - bugfixing in reading multivolumes
//
//  known bugs:
//   - when extracting files that contains unicode characters there's no test if
//     the file exists already
//   - open archives that contains unicode characters in the archive name fails

unit RAR;

interface

uses
  classes, sysUtils, windows,
  vcl.forms,
  RAR_DLL;

type
  TRAROperation   = (roOpenArchive, roCloseArchive, roListFiles, roExtract, roTest);
  TRARHeaderType  = (htFile, htDirectory, htSplitFile);
  TRAROpenMode    = (omRAR_OM_LIST, omRAR_OM_EXTRACT, omRAR_OM_LIST_INCSPLIT);
  TRARReplace     = (rrCancel, rrOverwrite, rrSkip);

  TRARProgressInfo = record
    fileName:           WideString; // the full path to the file within the RAR archive
    archiveBytesTotal:  LongInt;
    archiveBytesDone:   LongInt;
    fileBytesTotal:     LongInt;
    fileBytesDone:      LongInt;
  end;

  TRARFileItem = record
    // derived from processFileHeader(aHeaderDataEx: TRARHeaderDataEx)
    fileName:             AnsiString;
    fileNameW:            WideString;
    splitFile:            boolean;
    compressedSize:       cardinal;
    unCompressedSize:     cardinal;
    hostOS:               string;
    CRC32:                string;
    attributes:           cardinal;
    comment:              AnsiString;
    time:                 TDateTime;
    compressionStrength:  cardinal;
    archiverVersion:      cardinal;
    encrypted:            boolean;
    hash:                 string;
  end;

  TRARReplaceData = record
    fileName: Ansistring;
    size:     int64;
    time:     TDateTime;
  end;

  TRAROnErrorNotifyEvent    = procedure(Sender: TObject; const aErrorCode: integer; const aOperation: TRAROperation) of object;
  TRAROnListFile            = procedure(Sender: TObject; const aFileItem: TRARFileItem) of object;
  TRAROnPasswordRequired    = procedure(Sender: TObject; const aFileName: Ansistring; out oNewPassword: Ansistring; out oCancel: boolean) of object;
  TRAROnNextVolumeRequired  = procedure(Sender: TObject; const aRequiredFileName: Ansistring; out oNewFileName: Ansistring; out oCancel: boolean) of object;
  TRAROnProgress            = procedure(Sender: TObject; const aProgressInfo: TRARProgressInfo) of object;
  TRAROnReplace             = procedure(Sender: TObject; const aExistingData: TRARReplaceData; aNewData: TRARReplaceData; out oAction: TRARReplace) of object;

  TRARArchiveInfo = record
    fileName:             Ansistring;
    fileNameW:            WideString;

    // derived from RAROpenArchiveEx: TRAROpenArchiveDataEx in openArchive()
    volume:               boolean;
    archiveComment:       boolean;
    locked:               boolean;
    solid:                boolean; // also set in processFileHeader(aHeaderDataEx: TRARHeaderDataEx)
    newNumbering:         boolean;
    signed:               boolean;
    recovery:             boolean;
    headerEncrypted:      boolean;
    firstVolume:          boolean;
    SFX:                  boolean;

    // derived from processFileHeader(aHeaderDataEx: TRARHeaderDataEx);
    packedSizeMVVolume:   cardinal; // from processFileHeader(aHeaderDataEx: TRARHeaderDataEx)
    archiverMajorVersion: cardinal;
    archiverMinorVersion: cardinal;
    hostOS:               string;
    totalFiles:           integer; // incremented when processing each file header
    dictionarySize:       int64;
    compressedSize:       int64;   // totalled from aHeaderDataEx.PackSize when processing each file header
    unCompressedSize:     int64;   // totalled from aHeaderDataEx.UnpSize  when processing each file header
    multiVolume:          boolean;
    fileComment:          boolean;
  end;

  TRARArchive = class(TObject)
    handle:               THandle;
    opened:               boolean;
    password:             AnsiString;
    info:                 TRARArchiveInfo;
    fileItem:             TRARFileItem;
    progressInfo:         TRARProgressInfo;
    hasComment:           boolean;
    comment:              AnsiString;
    commentBuf:           PAnsiChar;
    commentState:         cardinal;
    ReadMVToEnd:          boolean;
    abort:                boolean;
  public
    constructor create;
    destructor  destroy; override;
  end;

  ICallBackInfo = interface
  ['{9D062B91-12D3-47E2-821A-215938DAD3CE}']
    function  getOnNextVolRequired: TRAROnNextVolumeRequired;
    function  getOnPasswordRequired: TRAROnPasswordRequired;
    function  getOnProgress: TRAROnProgress;
    function  getRAR: TRARArchive;
    procedure setOnNextVolRequired(const Value: TRAROnNextVolumeRequired);
    procedure setOnPasswordRequired(const Value: TRAROnPasswordRequired);
    procedure setOnProgress(const Value: TRAROnProgress);
    procedure setRAR(const Value: TRARArchive);
    property  RAR:                  TRARArchive               read getRAR                 write setRAR;
    property  onNextVolRequired:    TRAROnNextVolumeRequired  read getOnNextVolRequired   write setOnNextVolRequired;
    property  onPasswordRequired:   TRAROnPasswordRequired    read getOnPasswordRequired  write setOnPasswordRequired;
    property  onProgress:           TRAROnProgress            read getOnProgress          write setOnProgress;
  end;

  TCallBackInfo = class(TInterfacedObject, ICallBackInfo)
  strict private
    FRAR:                 TRARArchive;
    FOnNextVolRequired:   TRAROnNextVolumeRequired;
    FOnPasswordRequired:  TRAROnPasswordRequired;
    FOnProgress:          TRAROnProgress;
  private
    function  getOnPasswordRequired: TRAROnPasswordRequired;
    function  getOnProgress:         TRAROnProgress;
    function  getRAR:                TRARArchive;
    procedure setOnPasswordRequired(const Value: TRAROnPasswordRequired);
    procedure setOnProgress(const Value: TRAROnProgress);
    procedure setRAR(const Value: TRARArchive);
    function  getOnNextVolRequired: TRAROnNextVolumeRequired;
    procedure setOnNextVolRequired(const Value: TRAROnNextVolumeRequired);
  public
    property  RAR:                  TRARArchive               read getRAR                 write setRAR;
    property  onNextVolRequired:    TRAROnNextVolumeRequired  read getOnNextVolRequired   write setOnNextVolRequired;
    property  onPasswordRequired:   TRAROnPasswordRequired    read getOnPasswordRequired  write setOnPasswordRequired;
    property  onProgress:           TRAROnProgress            read getOnProgress          write setOnProgress;
  end;

  IRARResult = interface
  ['{8CBBE61B-C5F8-4FFD-96D0-32C29CC05AAB}']
    function  checkRARResult(const aResultCode: integer; const aOperation: TRAROperation): integer;
    function  getLastResult: integer;
    function  getOnError:    TRAROnErrorNotifyEvent;
    procedure setOnError(const Value: TRAROnErrorNotifyEvent);
    property  lastResult:    integer read getLastResult;
    property  onError:       TRAROnErrorNotifyEvent  read getOnError         write setOnError;
  end;

  TRARResult = class(TInterfacedObject, IRARResult)
  strict private
    FOnError:     TRAROnErrorNotifyEvent;
    FLastResult:  integer;
  public
    function  checkRARResult(const aResultCode: integer; const aOperation: TRAROperation): integer;
    function  getLastResult:  integer;
    function  getOnError:     TRAROnErrorNotifyEvent;
    procedure setOnError(const Value: TRAROnErrorNotifyEvent);

    property  lastResult:     integer                 read getLastResult;
    property  onError:        TRAROnErrorNotifyEvent  read getOnError         write setOnError;
  end;

type
  [ComponentPlatforms(pidWin32 or pidWin64)]
  TRAR = class(TComponent)
  strict private
    FRAR:                   TRARArchive;

    FPassword:              AnsiString;
    FReadMVToEnd:           boolean;

    FOnListFile:            TRAROnListFile;
    FOnPasswordRequired:    TRAROnPasswordRequired;
    FOnNextVolumeRequired:  TRAROnNextVolumeRequired;
    FOnProgress:            TRAROnProgress;
    FOnReplace:             TRAROnReplace;

    FFiles:                 TStringList; // list of filenames (and their full paths) within an archive, to be extracted
    FFoundFiles:            TStringList; // files found using findFiles()

    function  getOnError:   TRAROnErrorNotifyEvent;
    procedure setOnError(const Value: TRAROnErrorNotifyEvent);

    function  getDLLName: string;
    function  getVersion:string;

    procedure onRARProgressTest(Sender: TObject; const aProgressInfo: TRARProgressInfo);

    function  getArchiveInfo: TRARArchiveInfo;
    function  getDLLVersion:  integer;
  private
    FlastResult: integer;
    function  getReadMVToEnd: boolean;
    procedure setReadMVToEnd(const Value: boolean);
    function  getPassword: AnsiString;
    procedure setPassword(const Value: AnsiString);
    procedure setlastResult(const Value: integer);
    function  getLastResult: integer;

  public
    constructor create(AOwner: TComponent); override;
    destructor  destroy; override;

    procedure abort;

    procedure addFile(const aFile: string);
    procedure clearFiles;
    function  fileCount: integer;

    function  extractArchive(const aArchivePath: string; const aExtractPath: string; const aFileName: string = ''):  boolean;
    function  extractPreparedArchive(const aArchivePath: string; const aExtractPath: string; const aFileName: string = ''): boolean;
    function  listArchive(const aArchivePath:string):       boolean;
    function  prepareArchive(const aArchivePath: string):   boolean;
    function  testArchive(const aArchivePath: string):      boolean;

    function  findFiles(const aFolderPath: string; bSubFolders: boolean = TRUE; const aFileExts: string = '.rar'): integer;
    function  isMultiVol(const aArchivePath: string):       boolean;
    function  isMultiVolPart(const aArchivePath: string):   boolean;

    property archiveInfo:           TRARArchiveInfo           read getArchiveInfo;
    property DLLName:               string                    read getDLLName;
    property DLLVersion:            integer                   read getDLLVersion;
    property foundFiles:            TStringList               read FFoundFiles;
    property lastResult:            integer                   read getLastResult;
    //pro: report correct archive compressed size and list all files in all parts
    //con: "all volumes required" means that to open, you have to insert all disks if not all volumes are in the same folder
    property readMultiVolumeToEnd:  boolean                   read getReadMVToEnd         write setReadMVToEnd; //if true, mv's will be read until last part of the file
  published
    property version:               string                    read getVersion nodefault;

    property onError:               TRAROnErrorNotifyEvent    read getOnError             write setOnError;
    property onListFile:            TRAROnListFile            read FOnListFile            write FOnListFile;
    property onPasswordRequired:    TRAROnPasswordRequired    read FOnPasswordRequired    write FOnPasswordRequired;
    property onNextVolumeRequired:  TRAROnNextVolumeRequired  read FOnNextVolumeRequired  write FOnNextVolumeRequired;
    property onProgress:            TRAROnProgress            read FOnProgress            write FOnProgress;
//    property onReplace:             TRAROnReplace             read FOnReplace             write FOnReplace;

    property password:              AnsiString                read getPassword            write setPassword; // can be supplied by the user before calling an operation
  end;


implementation

uses
//  _debugWindow, // un-commenting this will activate sending debug messages to BazDebugWindow if you have it installed (https://github.com/BazzaCuda/BazDebugWindow)
  system.ioUtils;

const
  gVersion = '2.3';

var
  RR: IRARResult;

function checkRARResult(const aResultCode:integer; const aOperation: TRAROperation): integer;
begin
  result := RR.checkRARResult(aResultCode, aOperation);
end;

function unRarCallBack(msg: cardinal; userData: LPARAM; P1: LPARAM; P2: LPARAM): integer; {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
var
  vCancel:    boolean;
  vFileName:  AnsiString;
  vPassword:  AnsiString;
//  vData:      TBytes;
//  vDataString: string;
begin
  vCancel := FALSE;
  result  := RAR_CONTINUE;
  var vCBI := ICallbackInfo(userData);

  try

    case msg of
      UCM_CHANGEVOLUME:   begin
                            case vCBI.RAR.ReadMVToEnd of FALSE: begin
                                                                  result := RAR_CANCEL;
                                                                  EXIT; end;end;

                            case P2 of
                              RAR_VOL_ASK:  begin
                                              vFileName := PAnsiChar(P1);
                                              case assigned(vCBI.onNextVolRequired) of TRUE: vCBI.onNextVolRequired(vCBI.RAR, PAnsiChar(P1), vFileName, vCancel); end;
                                              case vCancel of TRUE: result := RAR_CANCEL; end;
                                              strPCopy(PAnsiChar(P1), vFileName);
                                            end;

                              RAR_VOL_NOTIFY: {$IF BazDebugWindow} {debug('found next vol')} {$ENDIF}; // occurs when next volume required and next part was found
                            end;end;

      UCM_NEEDPASSWORD: begin
                          vFileName := vCBI.RAR.info.fileName;
                          case assigned(vCBI.onPasswordRequired) of TRUE: vCBI.onPasswordRequired(vCBI.RAR, vFileName, vPassword, vCancel); end;
                          case vCancel of TRUE: result := RAR_CANCEL; end;
                          strPCopy(Pointer(P1), copy(vPassword, 1, P2)); // P1 = pointer to the password buffer in unrar; P2 = maximum size of the buffer
                        end;

      UCM_PROCESSDATA:  begin
//                          setLength(vData, P2);
//                          move(Pointer(P1)^, vData[0], P2);
//                          setString(vDataString, PAnsiChar(@vData[0]), P2);

                          vCBI.RAR.progressInfo.ArchiveBytesDone  := vCBI.RAR.progressInfo.ArchiveBytesDone + P2;
                          vCBI.RAR.progressInfo.FileBytesDone     := vCBI.RAR.progressInfo.FileBytesDone    + P2;

                          case assigned(vCBI.onProgress) of TRUE: vCBI.onProgress(vCBI.RAR, vCBI.RAR.progressInfo); end;
                          case vCBI.RAR.abort of TRUE: result := RAR_CANCEL; end;
                        end;

    end;

  except
    MessageBox(0, 'TRAR exception in unRarCallBack', 'TRAR', MB_ICONEXCLAMATION or MB_OK);
  end;
end;

function getOpenMode(bReadMVToEnd: boolean): TRAROpenMode;
begin
  case bReadMVToEnd of  TRUE: result := omRAR_OM_LIST_INCSPLIT;
                       FALSE: result := omRAR_OM_LIST; end;
end;

procedure initArchive(const aRAR: TRARArchive);
begin
  with aRAR do begin
    handle        := 0;
    opened        := FALSE;
    info          := default(TRARArchiveInfo);
    fileItem      := default(TRARFileItem);
    progressInfo  := default(TRARProgressInfo);
    hasComment    := FALSE;
    comment       := '';
    commentState  := 0;
    abort         := FALSE;
  end;
end;

function ITBS(aFolderPath: string): string;
const BACKSLASH = #92;
begin
  result := aFolderPath;
  case length(result) = 0 of TRUE: EXIT; end;
  case result[high(result)] = BACKSLASH of FALSE: result := result + BACKSLASH; end;
end;

function processDataCallBack(addr: PByte; size: integer): integer;
//var
//  vData:        TBytes;
//  vDataString:  string;
begin
//  debugInteger('data size', size);
//  setLength(vData, size);
//  move(pointer(addr)^, vData[0], size);
//  setString(vDataString, PAnsiChar(@vData[0]), size);
//  debugString('vDataString', vDataString);
//  memoryStream.write(addr^, size);
//  result := 0; // 0 = cancel. Anything else continues (rdwrfn.cpp)
// result := 1;
end;

function initCallBack(const aRAR: TRARArchive;  aOnProgress:          TRAROnProgress            = NIL;
                                                aOnPasswordRequired:  TRAROnPasswordRequired    = NIL;
                                                aOnNextVolRequired:   TRAROnNextVolumeRequired  = NIL): ICallBackInfo;
begin
  result                    := TCallBackInfo.create;
  result.RAR                := aRAR;
  result.onNextVolRequired  := aOnNextVolRequired;
  result.onProgress         := aOnProgress;
  result.onPasswordRequired := aOnPasswordRequired;
  RARSetCallback(aRAR.handle, unRarCallBack, LPARAM(result));
//  RARSetProcessDataProc(aRAR.handle, processDataCallBack);
end;

function processFileHeader(const aFileHeaderDataEx: TRARHeaderDataEx; const aRAR: TRARArchive): TRARHeaderType; // populate FArchiveInfo: TRARArchiveInfo and vFileItem: TRARFileItem from aHeaderDataEx
var
  ft:         _FILETIME;
  st:         TSystemTime;
  OS:         string;
  gSplitFile: boolean;

  function binToStr(const bin: array of byte): string;
  begin
    setLength(result, 2 * length(bin));
    for var i := low(bin) to high(bin) do begin
      result[i * 2 + 1] := lowerCase(intToHex(bin[i], 2))[1];
      result[i * 2 + 2] := lowerCase(intToHex(bin[i], 2))[2];
    end;
  end;

begin
  result := htDirectory;
  case (aFileHeaderDataEx.flags AND RHDF_DIRECTORY) = RHDF_DIRECTORY of TRUE: EXIT; end;

  result := htSplitFile;
  case aRAR.ReadMVToEnd of TRUE:
  begin
                  // a split file continued from the previous part of this archive or continued in the next part of this archive
                  // will have multiple file headers, each with a portion of the compressed size, so we have to total them all to get the correct size for the file
                  gSplitFile := ((aFileHeaderDataEx.Flags AND RHDF_SPLITBEFORE)  = RHDF_SPLITBEFORE)
                             or ((aFileHeaderDataEx.Flags AND RHDF_SPLITAFTER)   = RHDF_SPLITAFTER);

                  case gSplitFile of TRUE: begin

                            // the first file header of a split file
                            case (aRAR.readMVToEnd) and (NOT ((aFileHeaderDataEx.Flags  AND RHDF_SPLITBEFORE) = RHDF_SPLITBEFORE))
                                                    and (((aFileHeaderDataEx.Flags      AND RHDF_SPLITAFTER ) = RHDF_SPLITAFTER ))
                              of  TRUE: begin
                                          aRAR.info.packedSizeMVVolume := aFileHeaderDataEx.PackSize; // start accumulating
                                          EXIT; end;end; // skip to the next header for this split file

                            // NOT the last header of a split file, NOT the first header of split file, so a middle header then
                            case (aRAR.readMVToEnd) and (((aFileHeaderDataEx.Flags AND RHDF_SPLITBEFORE)  = RHDF_SPLITBEFORE))
                                                    and (((aFileHeaderDataEx.Flags AND RHDF_SPLITAFTER)   = RHDF_SPLITAFTER))
                              of TRUE:  begin
                                          inc(aRAR.info.packedSizeMVVolume, aFileHeaderDataEx.PackSize);
                                          EXIT; end;end; // skip to the next header for this split file

                            // last file header of a split file - we can now populate the TFileItem below
                            case (aRAR.readMVToEnd) and     (((aFileHeaderDataEx.Flags AND RHDF_SPLITBEFORE)  = RHDF_SPLITBEFORE))
                                                    and (NOT ((aFileHeaderDataEx.Flags AND RHDF_SPLITAFTER)   = RHDF_SPLITAFTER))
                              of TRUE: inc(aRAR.info.packedSizeMVVolume, aFileHeaderDataEx.PackSize); end;

                  end;end;
  end;end;

  result := htFile; // now we can notify via FOnListFile

  aRAR.info.multiVolume := gSplitFile;

  case aRAR.info.archiverMajorVersion * 10 + aRAR.info.archiverMinorVersion < aFileHeaderDataEx.UnpVer
    of TRUE:  begin
                aRAR.info.archiverMinorVersion := aFileHeaderDataEx.UnpVer mod 10;
                aRAR.info.archiverMajorVersion :=(aFileHeaderDataEx.UnpVer - aRAR.info.archiverMinorVersion) div 10; end;end;

  aRAR.info.solid := ((aFileHeaderDataEx.Flags AND ROADF_SOLID ) = ROADF_SOLID );  // ???

  OS:='unknown';
  case aFileHeaderDataEx.HostOS of
    0: OS:='DOS';
    1: OS:='IBM OS/2';
    2: OS:='Windows';
    3: OS:='Unix';
  end;
  aRAR.info.HostOS := OS;

  inc(aRAR.info.totalFiles);
  aRAR.info.dictionarySize := aFileHeaderDataEx.dictSize;

  case aRAR.ReadMVToEnd and gSplitFile of
     TRUE: inc(aRAR.info.compressedSize, aRAR.info.packedSizeMVVolume);
    FALSE: inc(aRAR.info.compressedSize, aFileHeaderDataEx.packSize); end;
  inc(aRAR.info.unCompressedSize, aFileHeaderDataEx.unpSize);

  aRAR.fileItem := default(TRARFileItem);
  with aRAR.fileItem do begin
    fileName          := strPas(aFileHeaderDataEx.fileName);
    fileNameW         := aFileHeaderDataEx.fileNameW;

    splitFile         := gSplitFile;
    case aRAR.ReadMVToEnd and gSplitFile of
       TRUE: compressedSize := aRAR.info.packedSizeMVVolume;
      FALSE: compressedSize := aFileHeaderDataEx.packSize; end;

    unCompressedSize  := aFileHeaderDataEx.unpSize;
    hostOS            := OS;
    CRC32             := format('%x',[aFileHeaderDataEx.fileCRC]);
    attributes        := aFileHeaderDataEx.fileAttr;
    comment           := aFileHeaderDataEx.cmtBuf;

    dosDateTimeToFileTime(hiWord(aFileHeaderDataEx.fileTime), loWord(aFileHeaderDataEx.fileTime), ft);
    fileTimeToSystemTime(ft, st);
    time := systemTimeToDateTime(st);

    compressionStrength := aFileHeaderDataEx.method;
    archiverVersion     := aFileHeaderDataEx.unpVer;
    encrypted           := (aFileHeaderDataEx.flags AND RHDF_ENCRYPTED) = RHDF_ENCRYPTED;

    case aFileHeaderDataEx.hashType of
      RAR_HASH_BLAKE2: hash := binToStr(aFileHeaderDataEx.hash);
    end;
  end;
  gSplitFile        := FALSE;
end;

function processOpenArchive(const aOpenArchiveDataEx: TRAROpenArchiveDataEx; const aRAR: TRARArchive): boolean;
begin
  result := FALSE;

  aRAR.info.volume          := ((aOpenArchiveDataEx.Flags AND ROADF_VOLUME)       = ROADF_VOLUME);        // Volume attribute (archive volume) ???
  aRAR.info.archiveComment  := ((aOpenArchiveDataEx.Flags AND ROADF_COMMENT)      = ROADF_COMMENT);       // not available if header is encrypted
  aRAR.info.locked          := ((aOpenArchiveDataEx.Flags AND ROADF_LOCK)         = ROADF_LOCK);          // not available if header is encrypted
  aRAR.info.solid           := ((aOpenArchiveDataEx.Flags AND ROADF_SOLID)        = ROADF_SOLID);         // not available if header is encrypted
  aRAR.info.newNumbering    := ((aOpenArchiveDataEx.Flags AND ROADF_NEWNUMBERING) = ROADF_NEWNUMBERING);  // new volume naming scheme ('volname.partN.rar')
  aRAR.info.signed          := ((aOpenArchiveDataEx.Flags AND ROADF_SIGNED)       = ROADF_SIGNED);        // not available if header is encrypted
  aRAR.info.recovery        := ((aOpenArchiveDataEx.Flags AND ROADF_RECOVERY)     = ROADF_RECOVERY);      // not available if header is encrypted
  aRAR.info.headerEncrypted := ((aOpenArchiveDataEx.Flags AND ROADF_ENCHEADERS)   = ROADF_ENCHEADERS);    // always available
  aRAR.info.firstVolume	    := ((aOpenArchiveDataEx.Flags AND ROADF_FIRSTVOLUME)  = ROADF_FIRSTVOLUME);   // ???

  aRAR.info.SFX := isSFX(aRAR.info.fileName);

  case aOpenArchiveDataEx.cmtState of // read archive comment - cmtState is actually aRAR.commentState
    RAR_COMMENT_EXISTS:   begin // not available if header is encrypted
                            aRAR.comment := strPas(aRAR.commentBuf);
                            aRAR.hasComment := TRUE;
                          end;
    ERAR_NO_MEMORY:       checkRARResult(ERAR_NO_MEMORY,       roOpenArchive);
    ERAR_BAD_DATA:        checkRARResult(ERAR_BAD_DATA,        roOpenArchive);
    ERAR_UNKNOWN_FORMAT:  checkRARResult(ERAR_UNKNOWN_FORMAT,  roOpenArchive);
    ERAR_SMALL_BUF:       checkRARResult(ERAR_SMALL_BUF,       roOpenArchive);
  end;

  case aOpenArchiveDataEx.cmtState in [RAR_NO_COMMENT, RAR_COMMENT_EXISTS] of FALSE: checkRARResult(RAR_COMMENT_UNKNOWN, roOpenArchive); end; // unknown comment condition

  result := TRUE;
end;

function openArchive(const aArchivePath: string; const aOpenMode: TRAROpenMode; const aRAR: TRARArchive; bInitArchive: boolean): boolean;
begin
  case bInitArchive of TRUE: initArchive(aRAR); end;

  aRAR.info.fileName  := aArchivePath;
  aRAR.info.fileNameW := aArchivePath;

  result := FALSE;

  var vOpenArchiveDataEx := default(TRAROpenArchiveDataEx);
  with vOpenArchiveDataEx do begin

    arcName     := PAnsiChar(aRAR.info.fileName);
    arcNameW    := PWideChar(aRAR.info.fileNameW);
    openMode    := ord(aOpenMode);

    cmtBuf      := aRAR.commentBuf;
    cmtBufSize  := RAR_MAX_COMMENT_SIZE;
    cmtSize     := length(aRAR.commentBuf);
    cmtState    := aRAR.commentState; // feedback variable
  end;

  aRAR.handle   := RAROpenArchiveEx(@vOpenArchiveDataEx);
  aRAR.opened   := aRAR.handle <> RAR_INVALID_HANDLE;
  case aRAR.handle = RAR_INVALID_HANDLE of TRUE:  begin
                                                    checkRARResult(ERAR_EOPEN, roOpenArchive);
                                                    EXIT; end;end;

  result := processOpenArchive(vOpenArchiveDataEx, aRAR);
end;

function closeArchive(const aArchiveHandle: THANDLE): boolean;
begin
  result := NOT (aArchiveHandle = RAR_INVALID_HANDLE);
  case result of TRUE: result := RARCloseArchive(aArchiveHandle) = RAR_SUCCESS; end;
end;

function extractArchiveFiles(const aExtractPath: string; const aFileName: string; const aFiles: TStringList; const aRAR: TRARArchive): boolean;
// perform the extract operation
begin
  var vHeaderDataEx := default(TRARHeaderDataEx);
  aRAR.progressInfo := default(TRARProgressInfo);

  {$IF BazDebugWindow}
  // debug('extractArchiveFiles: aExtractPath = ' + aExtractPath);
  // debug('extractArchiveFiles: aFileName   = ' + aFileName);
  {$ENDIF}

  aRAR.progressInfo.ArchiveBytesTotal := aRAR.info.unCompressedSize; // the list operation in testRARArchive obtained aRAR.info.unCompressedSize

  try
    repeat
      case checkRARResult(RARReadHeaderEx(aRAR.handle, @vHeaderDataEx), roExtract)     = RAR_SUCCESS of FALSE: EXIT; end;  // get the next file header in the archive
      processFileHeader(vHeaderDataEx, aRAR);

      aRAR.progressInfo.FileBytesDone   := 0;
      aRAR.progressInfo.FileBytesTotal  := vHeaderDataEx.UnpSize;   // aRAR.fileItem.unCompressedSize
      aRAR.progressInfo.FileName        := vHeaderDataEx.FileNameW; // aRAR.info.fileNameW

      var vUnrarOp := RAR_SKIP;
      case aFiles.count = 0 of   TRUE: case (aFileName = '') or sameText(aFileName, vHeaderDataEx.fileNameW)  of TRUE: vUnrarOp := RAR_EXTRACT; end;
                                FALSE: case aFiles.indexOf(vHeaderDataEx.fileNameW) <> -1                     of TRUE: vUnrarOp := RAR_EXTRACT; end;end;

      case checkRARResult(RARProcessFileW(aRAR.handle, vUnrarOp,  PWideChar(aExtractPath), NIL), roTest)  = RAR_SUCCESS of FALSE: EXIT; end;

      application.processMessages; // allow the user to actually press a cancel button
    until aRAR.abort;              // RARReadHeaderEx = ERAR_END_ARCHIVE will usually exit the loop

  finally
    result := RR.lastResult = ERAR_END_ARCHIVE; // not an error in this case
  end;
end;

function listArchiveFiles(const aRAR: TRARArchive; bNotify: boolean = TRUE; const aOnListFile: TRAROnListFile = NIL): boolean; forward;

function extractRARArchive(const aArchivePath: string; const aExtractPath: string; const aFileName: string; const aFiles: TStringList; aRAR: TRARArchive;
                                 aOnRARProgress:       TRAROnProgress            = NIL;
                                 aOnPasswordRequired:  TRAROnPasswordRequired    = NIL;
                                 aOnNextVolRequired:   TRAROnNextVolumeRequired  = NIL): boolean;
// setup the extract operation
begin
  begin
    result := openArchive(aArchivePath, getOpenMode(aRAR.readMVToEnd), aRAR, TRUE);
    case result of FALSE: EXIT; end;

    initCallBack(aRAR, NIL, aOnPasswordRequired, aOnNextVolRequired);
    try
      case aRAR.password = '' of FALSE: RARSetPassword(aRAR.handle, PAnsiChar(aRAR.password)); end;
      result := listArchiveFiles(aRAR, FALSE); // get archive total unCompressedSize for the progress callback below (reqd for multi-volume archives)
    finally
      closeArchive(aRAR.handle);
    end;
  end;

  begin
    result := openArchive(aArchivePath, omRAR_OM_EXTRACT, aRAR, FALSE);
    case result of FALSE: EXIT; end;

    initCallBack(aRAR, aOnRARProgress, aOnPasswordRequired, aOnNextVolRequired);
    try
      case aRAR.password = '' of FALSE: RARSetPassword(aRAR.handle, PAnsiChar(aRAR.password)); end;
      result := extractArchiveFiles(aExtractPath, aFileName, aFiles, aRAR); // perform the extract operation
    finally
      closeArchive(aRAR.handle);
    end;
  end;
end;

function listArchiveFiles(const aRAR: TRARArchive; bNotify: boolean = TRUE; const aOnListFile: TRAROnListFile = NIL): boolean;
// perform the list operation
begin
  var vHeaderDataEx := default(TRARHeaderDataEx); // is really TRARFileHeaderDataEx

  vHeaderDataEx.cmtBuf      := aRAR.commentBuf;
  vHeaderDataEx.cmtBufSize  := length(aRAR.commentBuf);
  vHeaderDataEx.cmtSize     := RAR_MAX_COMMENT_SIZE;
  vHeaderDataEx.cmtState    := aRAR.commentState;

  try
    repeat // really = RARReadFileHeaderEx
      case checkRARResult(RARReadHeaderEx(aRAR.handle, @vHeaderDataEx), roListFiles)     = RAR_SUCCESS  of FALSE: EXIT; end;  // get the next file header in the archive
      case (processFileHeader(vHeaderDataEx, aRAR) = htFile) and bNotify and assigned(aOnListFile)      of  TRUE: aOnListFile(aRAR, aRAR.fileItem); end;
      case checkRARResult(RARProcessFile(aRAR.handle, RAR_SKIP, NIL, NIL), roListFiles)  = RAR_SUCCESS  of FALSE: EXIT; end;  // do nothing - skip to next file header

      application.processMessages;  // allow the user to actually press a cancel button
    until aRAR.abort;               // RARReadHeaderEx = ERAR_END_ARCHIVE will usually exit the loop

  finally
    result := RR.lastResult = ERAR_END_ARCHIVE; // not an error in this case
  end;
end;

function listRARFiles(const aArchivePath: string; aRAR: TRARArchive;  aOnListFile:         TRAROnListFile           = NIL;
                                                                      aOnPasswordRequired: TRAROnPasswordRequired   = NIL;
                                                                      aOnNextVolRequired:  TRAROnNextVolumeRequired = NIL): boolean;
// setup the list operation
begin
  result := openArchive(aArchivePath, getOpenMode(aRAR.readMVToEnd), aRAR, TRUE);
  case result of FALSE: EXIT; end;

  initCallBack(aRAR, NIL, aOnPasswordRequired, aOnNextVolRequired);
  try
    {$IF NOT customDLL}
    case aRAR.password = '' of FALSE: RARSetPassword(aRAR.handle, PAnsiChar(aRAR.password)); end;
    {$ELSE}
      var vPW: WideString := '你好世界123!';
      RARSetPasswordW(aRAR.handle, '你好世界123!');
    {$ENDIF}
    result := listArchiveFiles(aRAR, TRUE, aOnListFile); // call the list operation
  finally
    closeArchive(aRAR.handle);
  end;
end;

function extractPreparedRARArchive(const aArchivePath: string; const aExtractPath: string; const aFileName: string; const aFiles: TStringList; aRAR: TRARArchive;
                                         aOnRARProgress:       TRAROnProgress            = NIL;
                                         aOnPasswordRequired:  TRAROnPasswordRequired    = NIL;
                                         aOnNextVolRequired:   TRAROnNextVolumeRequired  = NIL): boolean;
begin
  begin
    result := openArchive(aArchivePath, omRAR_OM_EXTRACT, aRAR, FALSE);
    case result of FALSE: EXIT; end;

    initCallBack(aRAR, aOnRARProgress, aOnPasswordRequired, aOnNextVolRequired);
    try
      case aRAR.password = '' of FALSE: RARSetPassword(aRAR.handle, PAnsiChar(aRAR.password)); end;
      result := extractArchiveFiles(aExtractPath, aFileName, aFiles, aRAR); // perform the extract operation
    finally
      closeArchive(aRAR.handle);
    end;
  end;
end;

function prepareRARArchive(const aArchivePath: string; aRAR: TRARArchive; aOnRARProgress:       TRAROnProgress            = NIL;
                                                                          aOnPasswordRequired:  TRAROnPasswordRequired    = NIL;
                                                                          aOnNextVolRequired:   TRAROnNextVolumeRequired  = NIL): boolean;
// setup the extract operation
begin
  begin
    result := openArchive(aArchivePath, getOpenMode(aRAR.readMVToEnd), aRAR, TRUE);
    case result of FALSE: EXIT; end;

    initCallBack(aRAR, NIL, aOnPasswordRequired, aOnNextVolRequired);
    try
      case aRAR.password = '' of FALSE: RARSetPassword(aRAR.handle, PAnsiChar(aRAR.password)); end;
      result := listArchiveFiles(aRAR, FALSE); // get archive total unCompressedSize for the progress callback below
    finally
      closeArchive(aRAR.handle);
    end;
  end;
end;

function testArchiveFiles(const aRAR: TRARArchive): boolean;
// perform the test operation
begin
  var vHeaderDataEx := default(TRARHeaderDataEx);
  aRAR.progressInfo := default(TRARProgressInfo);

  aRAR.progressInfo.ArchiveBytesTotal := aRAR.info.unCompressedSize; // the list operation in testRARArchive obtained aRAR.info.unCompressedSize

  try
    repeat
      case checkRARResult(RARReadHeaderEx(aRAR.handle, @vHeaderDataEx), roTest)     = RAR_SUCCESS of FALSE: EXIT; end;  // get the next file header in the archive
      processFileHeader(vHeaderDataEx, aRAR);

      aRAR.progressInfo.FileBytesDone   := 0;
      aRAR.progressInfo.FileBytesTotal  := vHeaderDataEx.UnpSize; // aRAR.fileItem.unCompressedSize
      aRAR.progressInfo.FileName        := vHeaderDataEx.FileNameW; // aRAR.info.fileNameW

      case checkRARResult(RARProcessFile(aRAR.handle, RAR_TEST, NIL, NIL), roTest)  = RAR_SUCCESS of FALSE: EXIT; end;

      application.processMessages; // allow the user to actually press a cancel button
    until aRAR.abort;              // RARReadHeaderEx = ERAR_END_ARCHIVE will usually exit the loop

  finally
    result := RR.lastResult = ERAR_END_ARCHIVE; // not an error in this case
  end;
end;

function testRARArchive(const aArchivePath: string; aRAR: TRARArchive;  aOnRARProgress:       TRAROnProgress            = NIL;
                                                                        aOnPasswordRequired:  TRAROnPasswordRequired    = NIL;
                                                                        aOnNextVolRequired:   TRAROnNextVolumeRequired  = NIL): boolean;
// setup the test operation
begin
  begin
    result := openArchive(aArchivePath, getOpenMode(aRAR.readMVToEnd), aRAR, TRUE);
    case result of FALSE: EXIT; end;

    initCallBack(aRAR, NIL, aOnPasswordRequired, aOnNextVolRequired);
    try
      case aRAR.password = '' of FALSE: RARSetPassword(aRAR.handle, PAnsiChar(aRAR.password)); end;
      result := listArchiveFiles(aRAR, FALSE); // get archive total unCompressedSize for the progress callback below
    finally
      closeArchive(aRAR.handle);
    end;
  end;

  begin
    result := openArchive(aArchivePath, omRAR_OM_EXTRACT, aRAR, FALSE);
    case result of FALSE: EXIT; end;

    initCallBack(aRAR, aOnRARProgress, aOnPasswordRequired, aOnNextVolRequired);
    try
      case aRAR.password = '' of FALSE: RARSetPassword(aRAR.handle, PAnsiChar(aRAR.password)); end;
      result := testArchiveFiles(aRAR); // perform the test operation
    finally
      closeArchive(aRAR.handle);
    end;
  end;
end;

{ TRAR }

procedure TRAR.onRARProgressTest(Sender: TObject; const aProgressInfo: TRARProgressInfo);
begin
  {$IF BazDebugWindow}
//  debugString('FileName', aProgressInfo.FileName);
//  debugFormat('Archive Bytes: %d, Archive Bytes Done: %d', [aProgressInfo.ArchiveBytesTotal, aProgressInfo.ArchiveBytesDone]);
//  debugFormat('FileBytesTotal: %d, FileBytesDone: %d', [aProgressInfo.FileBytesTotal, aProgressInfo.FileBytesDone]);
  {$ENDIF}
end;

procedure TRAR.addFile(const aFile: string);
begin
  FFiles.add(aFile);
end;

procedure TRAR.clearFiles;
begin
  FFiles.clear;
end;

constructor TRAR.create(AOwner: TComponent);
begin
  inherited create(AOwner);

  case csDesigning in componentState of FALSE: initDLL; end;

  FRAR                  := TRARArchive.create;
  readMultiVolumeToEnd  := TRUE;

  FFiles                := TStringList.create;
  FFiles.sorted         := FALSE;
  FFiles.duplicates     := dupIgnore;
  FFiles.caseSensitive  := FALSE;

  FFoundFiles           := TStringList.create;

  FOnProgress           := onRARProgressTest;
end;

destructor TRAR.Destroy;
begin
  case assigned(FRAR)         of TRUE: FRAR.free; end;
  case assigned(FFiles)       of TRUE: FFiles.free; end;
  case assigned(FFoundFiles)  of TRUE: FFoundFiles.free; end;
  inherited destroy;
end;

function TRAR.extractArchive(const aArchivePath: string; const aExtractPath: string; const aFileName: string = ''): boolean;
begin
  var vExtractPath := aExtractPath;
  case (length(vExtractPath) > 0) and (vExtractPath[length(vExtractPath)] <> '\') of TRUE: vExtractPath := vExtractPath + '\'; end;

  {$IF BazDebugWindow}
//  debugString('aArchivePath', aArchivePath);
//  debugString('vExtractPath', vExtractPath);
//  debugString('aFileName', aFileName);
  {$ENDIF}

  ForceDirectories(vExtractPath);

  result := extractRARArchive(aArchivePath, vExtractPath, aFileName, FFiles, FRAR, FOnProgress, FOnPasswordRequired, FOnNextVolumeRequired);
end;

function TRAR.extractPreparedArchive(const aArchivePath: string; const aExtractPath: string; const aFileName: string = ''): boolean;
begin
  var vExtractPath := aExtractPath;
  case (length(vExtractPath) > 0) and (vExtractPath[length(vExtractPath)] <> '\') of TRUE: vExtractPath := vExtractPath + '\'; end;

  {$IF BazDebugWindow}
//  debugString('aArchivePath', aArchivePath);
//  debugString('vExtractPath', vExtractPath);
//  debugString('aFileName', aFileName);
  {$ENDIF}

  ForceDirectories(vExtractPath);

  result := extractPreparedRARArchive(aArchivePath, vExtractPath, aFileName, FFiles, FRAR, FOnProgress, FOnPasswordRequired, FOnNextVolumeRequired);
end;

function TRAR.fileCount: integer;
begin
  result := FFiles.count;
end;

function TRAR.findFiles(const aFolderPath: string; bSubFolders: boolean = TRUE; const aFileExts: string = '.rar'): integer;
var
  SR:           TSearchRec;
  RC:           integer;

  function extOK: boolean;
  begin
    var vExt  := lowerCase(extractFileExt(SR.name));
    result    := (aFileExts = '') or (pos(vExt, aFileExts) > 0);
  end;

begin
  result          := 0;
  var vFolderPath := ITBS(aFolderPath);
  var vAttr       := faAnyFile AND NOT faHidden and NOT faSysFile;
  case bSubFolders of FALSE: vAttr := vAttr AND NOT faDirectory; end;

  case findFirst(vFolderPath + '*.*', vAttr, SR) = 0 of TRUE:
    repeat
      case ((SR.attr AND faDirectory) = faDirectory) of
         TRUE: case (SR.name <> '.') and (SR.name <> '..') of TRUE: findFiles(vFolderPath + SR.name, bSubFolders, aFileExts); end;
        FALSE: case extOK and NOT isMultiVolPart(SR.name) of TRUE: FFoundFiles.add(vFolderPath + SR.name); end;end;
    until findNext(SR) <> 0; end;

  sysUtils.findClose(SR);
  result := FFoundFiles.count;
end;

function TRAR.listArchive(const aArchivePath: string): boolean;
begin
  result := listRARFiles(aArchivePath, FRAR, FOnListFile, FOnPasswordRequired, FOnNextVolumeRequired);
end;

function TRAR.prepareArchive(const aArchivePath: string): boolean;
begin
  result := prepareRARArchive(aArchivePath, FRAR, FOnProgress, FOnPasswordRequired, FOnNextVolumeRequired);
end;

procedure TRAR.setlastResult(const Value: integer);
begin
  FlastResult := Value;
end;

function TRAR.testArchive(const aArchivePath: string): boolean;
begin
  result := testRARArchive(aArchivePath, FRAR, FOnProgress, FOnPasswordRequired, FOnNextVolumeRequired);
end;

procedure TRAR.setOnError(const Value: TRAROnErrorNotifyEvent);
begin
  RR.onError := value;
end;

procedure TRAR.setPassword(const Value: AnsiString);
begin
  FPassword     := value;
  FRAR.password := value;
end;

procedure TRAR.setReadMVToEnd(const Value: boolean);
begin
  FReadMVToEnd      := value;
  FRAR.readMVToEnd  := value;
end;

function TRAR.getArchiveInfo: TRARArchiveInfo;
begin
  result := FRAR.info;
end;

function TRAR.getDLLName: string;
begin
  case csDesigning in componentState of FALSE: result := RARDLLName; end;
end;

function TRAR.getDLLVersion: integer;
begin
  case csDesigning in componentState of FALSE: result := RARGetDLLVersion; end;
end;

function TRAR.getLastResult: integer;
begin
  result := RR.lastResult;
end;

function TRAR.getOnError: TRAROnErrorNotifyEvent;
begin
  result := RR.onError;
end;

function TRAR.getPassword: AnsiString;
begin
  result := FPassword;
end;

function TRAR.getReadMVToEnd: boolean;
begin
  result := FRAR.readMVToEnd;
end;

procedure TRAR.abort;
begin
  FRAR.abort := TRUE;
end;

function TRAR.getVersion: string;
begin
  result := gVersion;
end;

function TRAR.isMultiVol(const aArchivePath: string): boolean;
// It's the first part of a multi-volume set
begin
  var vFile := TPath.getFileNameWithoutExtension(aArchivePath); // strip off the .rar extension
  var vExt  := lowerCase(extractFileExt(vFile));                // isolate the [potential] .partn, .partnn or .partnnn part
  result := (vExt = '.part1') or (vExt = '.part01') or (vExt = '.part001');
end;

function TRAR.isMultiVolPart(const aArchivePath: string): boolean;
// It's a continuation of a multi-volume set but not the first part
begin
  var vFile := TPath.getFileNameWithoutExtension(aArchivePath); // strip off the .rar extension
  var vExt  := lowerCase(extractFileExt(vFile));                // isolate the [potential] .partn, .partnn or .partnnn part
  result := (pos('.part', vExt) = 1) and (vExt <> '.part1') and (vExt <> '.part01') and (vExt <> '.part001'); // it's a subordinate part
end;

{ TRARArchive }

constructor TRARArchive.create;
begin
  inherited create;
  getMem(commentBuf, RAR_MAX_COMMENT_SIZE);
end;

destructor TRARArchive.destroy;
begin
  case assigned(commentBuf) of TRUE: freeMem(commentBuf); end;
  inherited destroy;
end;

{ TRARResult }

function TRARResult.checkRARResult(const aResultCode: integer; const aOperation: TRAROperation): integer;
//  (ResultCode=ERAR_END_ARCHIVE) = 10 is not usually an error
begin
  result      := aResultCode;
  FLastResult := aResultCode;

  {$IF BazDebugWindow}
//    debugFormat('Error: aResultCode: %d, aOperation: %d', [aResultCode, ord(aOperation)]);
  {$ENDIF}

  var vReport := aResultCode in [
                                  RAR_DLL_LOAD_ERROR,
                                  ERAR_NO_MEMORY,
                                  ERAR_BAD_DATA,
                                  ERAR_BAD_ARCHIVE,
                                  ERAR_UNKNOWN_FORMAT,
                                  ERAR_EOPEN,
                                  ERAR_ECREATE,
                                  ERAR_ECLOSE,
                                  ERAR_EREAD,
                                  ERAR_EWRITE,
                                  ERAR_SMALL_BUF,
                                  ERAR_UNKNOWN,
                                  ERAR_MISSING_PASSWORD,
                                  ERAR_EREFERENCE,
                                  ERAR_BAD_PASSWORD,
                                  ERAR_LARGE_DICT,
                                  RAR_COMMENT_UNKNOWN
                                ];

  case vReport and assigned(FOnError) of TRUE: FOnError(SELF, aResultCode, aOperation); end;
end;

function TRARResult.getLastResult: integer;
begin
  result := FLastResult;
end;

function TRARResult.getOnError: TRAROnErrorNotifyEvent;
begin
  result := FOnError;
end;

procedure TRARResult.setOnError(const Value: TRAROnErrorNotifyEvent);
begin
  FOnError := value;
end;

{ TCallBackInfo }

function TCallBackInfo.getOnNextVolRequired: TRAROnNextVolumeRequired;
begin
  result := FOnNextVolRequired;
end;

function TCallBackInfo.getOnPasswordRequired: TRAROnPasswordRequired;
begin
  result := FOnPasswordRequired;
end;

function TCallBackInfo.getOnProgress: TRAROnProgress;
begin
  result := FOnProgress;
end;

function TCallBackInfo.getRAR: TRARArchive;
begin
  result := FRAR;
end;

procedure TCallBackInfo.setOnNextVolRequired(const Value: TRAROnNextVolumeRequired);
begin
  FOnNextVolRequired := value;
end;

procedure TCallBackInfo.setOnPasswordRequired(const Value: TRAROnPasswordRequired);
begin
  FOnPasswordRequired := value;
end;

procedure TCallBackInfo.setOnProgress(const Value: TRAROnProgress);
begin
  FOnProgress := value;
end;

procedure TCallBackInfo.setRAR(const Value: TRARArchive);
begin
  FRAR := value;
end;

initialization
  RR := TRARResult.create;

end.
