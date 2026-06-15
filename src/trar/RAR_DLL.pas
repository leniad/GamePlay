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
//  - support for both the 32-bit and 64-bit versions of unrar.dll
//  - switched to using the ...Ex functions in unrar.dll to get added info
//  - each file's checksum (e.g. Blake2) is now accessible
//  - support for WideChar filenames in archives
//  - reformatted the code and added significant amounts of whitespace for enhanced readability
//  - completely refactored and rewritten
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

unit RAR_DLL;

interface

uses
  windows, sysUtils;

const
  customDLL            = FALSE;

  RAR_METHOD_STORE      = 48;
  RAR_METHOD_FASTEST    = 49;
  RAR_METHOD_FAST       = 50;
  RAR_METHOD_NORMAL     = 51;
  RAR_METHOD_GOOD       = 52;
  RAR_METHOD_BEST       = 53;

  RAR_SUCCESS           =  0;
  ERAR_END_ARCHIVE      = 10;
  ERAR_NO_MEMORY        = 11;
  ERAR_BAD_DATA         = 12;
  ERAR_BAD_ARCHIVE      = 13;
  ERAR_UNKNOWN_FORMAT   = 14;
  ERAR_EOPEN            = 15;
  ERAR_ECREATE          = 16;
  ERAR_ECLOSE           = 17;
  ERAR_EREAD            = 18;
  ERAR_EWRITE           = 19;
  ERAR_SMALL_BUF        = 20;
  ERAR_UNKNOWN          = 21;
  ERAR_MISSING_PASSWORD = 22;
  ERAR_EREFERENCE       = 23;
  ERAR_BAD_PASSWORD     = 24;
  ERAR_LARGE_DICT       = 25;

  RAR_HASH_NONE         =  0;
  RAR_HASH_CRC32        =  1;
  RAR_HASH_BLAKE2       =  2;

  RAR_OM_LIST           =  0;
  RAR_OM_EXTRACT        =  1;
  RAR_OM_LIST_INCSPLIT  =  2;

  RAR_SKIP              =  0;
  RAR_TEST              =  1;
  RAR_EXTRACT           =  2;

  RAR_VOL_ASK           =  0;
  RAR_VOL_NOTIFY        =  1;

  RAR_DLL_VERSION       =  3;

  ROADF_VOLUME          = $0001;
  ROADF_COMMENT         = $0002;
  ROADF_LOCK            = $0004;
  ROADF_SOLID           = $0008;
  ROADF_NEWNUMBERING    = $0010;
  ROADF_SIGNED          = $0020;
  ROADF_RECOVERY        = $0040;
  ROADF_ENCHEADERS      = $0080;
  ROADF_FIRSTVOLUME     = $0100;

  ROADOF_KEEPBROKEN     = $0001;

  RHDF_SPLITBEFORE      = $01;
  RHDF_SPLITAFTER       = $02;
  RHDF_ENCRYPTED        = $04;
  RHDF_SOLID            = $10;
  RHDF_DIRECTORY        = $20;

  UCM_CHANGEVOLUME      =  0;
  UCM_PROCESSDATA       =  1;
  UCM_NEEDPASSWORD      =  2;
  UCM_CHANGEVOLUMEW     =  3;
  UCM_NEEDPASSWORDW     =  4;
  UCM_LARGEDICT         =  5;

  RAR_MAX_COMMENT_SIZE  = 65536;
  RAR_MIN_VERSION       =  4;

  RAR_CANCEL            = -1;
  RAR_CONTINUE          =  0;

//
  RAR_COMMENT_EXISTS    =  1;
  RAR_NO_COMMENT        =  0;
  RAR_COMMENT_UNKNOWN   = 98;
  RAR_DLL_LOAD_ERROR    = 99;
  RAR_INVALID_HANDLE    =  0;

type
  TProcessDataProc  = function(Addr: PByte; Size: integer): integer;
  TChangeVolProc    = function(ArcName: PAnsiChar; Mode: integer): integer; {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  TUnRarCallBack    = function(msg: Cardinal; UserData: LPARAM; P1: LPARAM; P2: LPARAM): integer; {stdcall;} {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};

  TRARHeaderData = packed record
    arcName:    array[0..259] of AnsiChar;
    fileName:   array[0..259] of AnsiChar;
    flags:      cardinal;
    packSize:   cardinal;
    unpSize:    cardinal;
    hostOS:     cardinal;
    fileCRC:    cardinal;
    fileTime:   cardinal;
    unpVer:     cardinal;
    method:     cardinal;
    fileAttr:   cardinal;
    cmtBuf:     PAnsiChar;
    cmtBufSize: cardinal;
    cmtSize:    cardinal;
    cmtState:   cardinal;
  end;
  PRARHeaderData = ^TRARHeaderData;

  //for UniCode FileNames and 64-Bit Sizes
//  {$ALIGN 1}
  TRARHeaderDataEx = packed record
    arcName:      array[0..1023] of AnsiChar;
    arcNameW:     array[0..1023] of WideChar;
    fileName:     array[0..1023] of AnsiChar;
    fileNameW:    array[0..1023] of WideChar;
    flags:        cardinal;
    packSize:     cardinal;
    packSizeHigh: cardinal;
    unpSize:      cardinal;
    unpSizeHigh:  cardinal;
    hostOS:       cardinal;
    fileCRC:      cardinal;
    fileTime:     cardinal;
    unpVer:       cardinal;
    method:       cardinal;
    fileAttr:     cardinal;
    cmtBuf:       PAnsiChar;
    cmtBufSize:   cardinal;
    cmtSize:      cardinal;
    cmtState:     cardinal;
    dictSize:     cardinal;
    hashType:     cardinal;
    hash:         array[0..31] of byte;
    redirType:    cardinal;
    redirName:    PWideChar;
    redirNameSize: cardinal;
    dirTarget:    cardinal;
    MTimeLow:     cardinal;
    MTimeHigh:    cardinal;
    CTimeLow:     cardinal;
    CTimeHigh:    cardinal;
    ATimeLow:     cardinal;
    ATimeHigh:    cardinal;
    arcNameEx:    PWideChar;
    arcNameExSize: cardinal;
    fileNameEx:   PWideChar;
    fileNameExSize: cardinal;
    reserved:     array[0..981] of cardinal;
//    reserved2:    array[0..275] of cardinal;
  end;
//  {$A-} // Reset alignment to default
  PRARHeaderDataEx = ^TRARHeaderDataEx;

  TRAROpenArchiveData = packed record
    arcName:    PAnsiChar;
    openMode:   cardinal;
    openResult: cardinal;
    cmtBuf:     PAnsiChar;
    cmtBufSize: cardinal;
    cmtSize:    cardinal;
    cmtState:   cardinal;
  end;
  PRAROpenArchiveData = ^TRAROpenArchiveData;

  TRAROpenArchiveDataEx = packed record
    arcName:      PAnsiChar;
    arcNameW:     PWideChar;
    openMode:     cardinal;
    openResult:   cardinal;
    cmtBuf:       PAnsiChar;
    cmtBufSize:   cardinal;
    cmtSize:      cardinal;
    cmtState:     cardinal;
//
    flags:        cardinal;
    callback:     {$IFDEF Win32} cardinal {$ELSE} NativeUInt {$ENDIF};
    userData:     LPARAM;
    opFlags:      cardinal;
    cmtBufW:      PWideChar;
    markOfTheWeb: PWideChar;
    reserved:   array[1..23] of cardinal;
  end;
  PRAROpenArchiveDataEx = ^TRAROpenArchiveDataEx;

var
  RAROpenArchive:         function  (ArchiveData: PRAROpenArchiveData):   THandle;                                                {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RAROpenArchiveEx:       function  (ArchiveData: PRAROpenArchiveDataEx): THandle;                                                {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};

  RARCloseArchive:        function  (hArcData: THandle):                                                                integer;  {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RARReadHeader:          function  (hArcData: THandle; HeaderData: PRARHeaderData):                                    integer;  {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RARReadHeaderEx:        function  (hArcData: THandle; HeaderData: PRARHeaderDataEx):                                  integer;  {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};

  RARProcessFile:         function  (hArcData: THandle; Operation: integer; DestPath: PAnsiChar; DestName: PAnsiChar):  integer;  {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RARProcessFileW:        function  (hArcData: THandle; Operation: integer; DestPath: PWideChar; DestName: PWideChar):  integer;  {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};

  RARSetCallback:         procedure (hArcData: THandle; Callback:         TUnRarCallback; UserData: LPARAM);                      {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RARSetChangeVolProc:    procedure (hArcData: THandle; ChangeVolProc:    TChangeVolProc);                                        {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RARSetProcessDataProc:  procedure (hArcData: THandle; ProcessDataProc:  TProcessDataProc);                                      {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RARSetPassword:         procedure (hArcData: THandle; Password:         PAnsiChar);                                             {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
  RARGetDllVersion:       function:                                                                                     integer;  {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};

{$IF customDLL}
  RARSetPasswordW:        procedure (hArcData: THandle; Password:         PWideChar);                                             {$IFDEF Win32} stdcall {$ELSE} cdecl {$ENDIF};
{$ENDIF}


function getFileModifiedDate(const aFilePath: string): TDateTime;
function getFileSize(const s: string): int64;
function isSFX(const fileName:String): boolean;
function RARDLLName: string;

procedure initDLL;

implementation

type
  IDLL = interface
  ['{59866286-8FC9-4044-AF9E-712E53744112}']
    function DLLName: string;
  end;

  TDLL = class(TInterfacedObject, IDLL)
  strict private
    FRARDLLInstance:  THandle;
    FDLLName:         string;
  private
    function  loadDLL(const aDLLPath: string): THANDLE;
    procedure unloadDLL;
    function  isDLLLoaded: boolean;
   protected
    constructor create;
    destructor  destroy;
   public
     function DLLName: string;
  end;

var
  gDLL: IDLL;

procedure initDLL;
begin
  gDLL := TDLL.create;
end;

function RARDLLName: string;
begin
  result := gDLL.DLLName;
end;

function getFileModifiedDate(const aFilePath:string): TDateTime;
var
  vHandle:    THandle;
  vStruct:    TOFStruct;
  vLastWrite: integer;
begin
  result  := 0;
  vHandle := openFile(PAnsiChar(aFilePath), vStruct, OF_SHARE_DENY_NONE);
  try
    if vHandle <> HFILE_ERROR then
    begin
      vLastwrite := fileGetDate(vHandle);
      result    := fileDateToDateTime(vLastwrite);
    end;
  finally
    closeHandle(vHandle);
  end;
end;

function getFileSize(const s:string): int64;
var
  vFindData:  TWin32FindDataA;
  vHandle:    cardinal;
begin
  vHandle := findFirstFileA(PAnsiChar(s), vFindData);
  if (vHandle <> INVALID_HANDLE_VALUE) then
  begin
    result := vFindData.nFileSizeLow;
    PCardinal(cardinal(@result) + sizeOf(cardinal))^ := vFindData.nFileSizeHigh;
    windows.findClose(vHandle);
  end
  else
    result := 0;
end;

function isSFX(const fileName:String):boolean;
var
  vBinaryType: DWORD;
begin
  if getBinaryTypeA(PAnsiChar(fileName), vBinaryType) then  begin
                                                              if (vBinaryType = SCS_32BIT_BINARY)
                                                              or (vBinaryType = SCS_DOS_BINARY)
                                                              or (vBinaryType = SCS_WOW_BINARY)
                                                              or (vBinaryType = SCS_PIF_BINARY)
                                                              or (vBinaryType = SCS_POSIX_BINARY)
                                                              or (vBinaryType = SCS_OS216_BINARY)
                                                              then result := TRUE
                                                              else result := FALSE;
                                                            end
  else
    result := FALSE;
end;

{ TDLL }

constructor TDLL.create;
begin
  inherited create;
  FRARDLLInstance := loadDLL({$IFDEF WIN32} 'UnRAR32.dll' {$ELSE} 'UnRAR64.dll' {$ENDIF});
  case FRARDLLInstance = RAR_INVALID_HANDLE of TRUE:  begin
                                                        messageBox(0, pchar('unable to load DLL: ' + FDLLName), 'Error', MB_ICONSTOP or MB_OK);
                                                        //HALT;
                                                      end;end;
end;

function TDLL.loadDLL(const aDLLPath: string): THANDLE;
begin
  FDLLName  := aDLLPath;
  result    := loadLibrary({$IFDEF WIN32}PChar{$ELSE}PWideChar{$ENDIF}(aDLLPath));

  case result = RAR_INVALID_HANDLE of TRUE: EXIT; end;

  @RAROpenArchive         := getProcAddress(result, 'RAROpenArchive');
  @RAROpenArchiveEx       := getProcAddress(result, 'RAROpenArchiveEx');
  @RARCloseArchive        := getProcAddress(result, 'RARCloseArchive');
  @RARReadHeader          := getProcAddress(result, 'RARReadHeader');
  @RARReadHeaderEx        := getProcAddress(result, 'RARReadHeaderEx');
  @RARProcessFile         := getProcAddress(result, 'RARProcessFile');
  @RARProcessFileW        := getProcAddress(result, 'RARProcessFileW');
  @RARSetCallback         := getProcAddress(result, 'RARSetCallback');
  @RARSetChangeVolProc    := getProcAddress(result, 'RARSetChangeVolProc');
  @RARSetProcessDataProc  := getProcAddress(result, 'RARSetProcessDataProc');
  @RARSetPassword         := getProcAddress(result, 'RARSetPassword');
  @RARGetDllVersion       := getProcAddress(result, 'RARGetDllVersion');

  {$IF customDLL}
  @RARSetPasswordW        := GetProcAddress(result, 'RARSetPasswordW');
  {$ENDIF}


  if (@RAROpenArchive = NIL) or (@RAROpenArchiveEx    = NIL) or (@RARCloseArchive = NIL)
  or (@RARReadHeader  = NIL) or (@RARReadHeaderEx     = NIL) or (@RARProcessFile = NIL) or (@RARProcessFileW = NIL)
  or (@RARSetCallback = NIL) or (@RARSetChangeVolProc = NIL) or (@RARSetProcessDataProc = NIL)
  or (@RARSetPassword = NIL) or (@RARGetDllVersion    = NIL) {$IF customDLL} or (@RARSetPasswordW = NIL) {$ENDIF}
  then unloadDLL
  else if RARGetDllVersion < RAR_MIN_VERSION then messageBox(0, 'please download the latest "unrar.dll" file. See www.rarlab.com', 'Error', MB_ICONSTOP or MB_OK);
end;

destructor TDLL.destroy;
begin
  unloadDLL;
  inherited destroy;
end;

function TDLL.dllName: string;
begin
  result := FDLLName;
end;

function TDLL.isDLLLoaded: boolean;
begin
  result := FRARDLLInstance <> RAR_INVALID_HANDLE;
end;

procedure TDLL.unloadDLL;
begin
  if isDLLLoaded then begin
    freeLibrary(FRARDLLInstance);
    FRARDLLInstance := 0;
  end;
end;

end.
