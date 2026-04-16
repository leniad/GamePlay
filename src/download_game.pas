unit download_game;

interface

type
  TLoginRequest=class
  public
    Usuario:string;
    Password:string;
  end;
  TLoginResponse=class
  public
    Ok:Boolean;
    Token:string;
    ExpiraEnSegundos:Integer;
    Mensaje:string;
  end;
  TMessageResponse=class
  public
    Ok:Boolean;
    Mensaje:string;
  end;
  TApiClient=class
  private
    FBaseUrl:string;
    FToken:string;
  public
    constructor create(const baseurl:string);
    function login(const usuario,password:string;out mensaje:string):boolean;
    function logout(out mensaje:string):boolean;
    function downloadFile(const remoteName,localpath:string;out mensaje:string):boolean;
    property token:string read FToken;
  end;

implementation

uses
  System.SysUtils,System.Classes,System.Net.HttpClient,System.Net.URLClient,REST.Json,descarga;

constructor TApiClient.Create(const baseurl:string);
begin
  inherited Create;
  FBaseUrl:=baseurl;
  FToken:='';
end;

function TApiClient.Login(const usuario,password:string;out mensaje:string):boolean;
var
  LHttp:THTTPClient;
  LReq:TLoginRequest;
  LResp:TLoginResponse;
  LJson,LRaw:string;
  LStream:TStringStream;
  LHttpResp:IHTTPResponse;
begin
  result:=false;
  mensaje:='';
  LHttp:=THTTPClient.Create;
  try
    LReq:=TLoginRequest.Create;
    try
      LReq.Usuario:=usuario;
      LReq.Password:=password;
      LJson:=TJson.ObjectToJsonString(LReq);
      LStream:=TStringStream.create(LJson, TEncoding.UTF8);
      try
        LStream.Position:=0;
        LHttpResp:=LHttp.Post(FBaseUrl+'/login',LStream,nil,[TNameValuePair.Create('Content-Type','application/json')]);
        LRaw:=Trim(LHttpResp.ContentAsString(TEncoding.UTF8));
        if ((LHttpResp.StatusCode=200) or (LHttpResp.StatusCode=201) or (LHttpResp.StatusCode=401)) then begin
          if (LRaw='') or (LRaw[1]<>'{') then begin
            FToken:='';
            mensaje:=Format('Respuesta inesperada en login: HTTP %d - %s',[LHttpResp.StatusCode,LRaw]);
            exit;
          end;
          try
            LResp:=TJson.JsonToObject<TLoginResponse>(LRaw);
            try
              if (Assigned(LResp) and LResp.Ok) then begin
                mensaje:=LResp.Mensaje;
                case LHttpResp.StatusCode of
                  200:begin
                        FToken:=LResp.Token;
                        result:=true;
                      end;
                  201:result:=true;
                    else FToken:= '';
                end;
              end else begin
                FToken:='';
                mensaje:='Respuesta de login no valida';
              end;
            finally
              LResp.free;
            end;
          except
            on E: Exception do begin
              FToken:='';
              mensaje:='Error parseando login: '+E.Message+' | Raw='+LRaw;
            end;
          end;
        end
        else begin
          FToken:='';
          mensaje:=Format('Error HTTP %d: %s',[LHttpResp.StatusCode,LRaw]);
        end;
      finally
        LStream.free;
      end;
    finally
      LReq.free;
    end;
  finally
    LHttp.free;
  end;
end;

function TApiClient.logout(out mensaje:string):boolean;
var
  LHttp:THTTPClient;
  LResp:TMessageResponse;
  LHttpResp:IHTTPResponse;
  LEmptyBody:TStringStream;
  LRaw:string;
begin
  result:=false;
  mensaje:='';
  if FToken='' then begin
    mensaje:='No hay token';
    exit;
  end;
  LHttp:=THTTPClient.create;
  try
    LHttp.CustomHeaders['Authorization']:='Bearer '+FToken;
    LEmptyBody:=TStringStream.Create('',TEncoding.UTF8);
    try
      LHttpResp := LHttp.Post(FBaseUrl+'/logout',LEmptyBody,nil,
        [TNameValuePair.Create('Content-Type','application/json')]);
    finally
      LEmptyBody.free;
    end;
    LRaw:=Trim(LHttpResp.ContentAsString(TEncoding.UTF8));
    if (LHttpResp.StatusCode=200) or (LHttpResp.StatusCode=401) then begin
      if (LRaw='') or (LRaw[1]<>'{') then begin
        mensaje:=Format('Respuesta inesperada en logout: HTTP %d - %s',[LHttpResp.StatusCode,LRaw]);
        exit;
      end;
      try
        LResp:=TJson.JsonToObject<TMessageResponse>(LRaw);
        try
          if assigned(LResp) then begin
            mensaje:=LResp.Mensaje;
            if (LHttpResp.StatusCode=200) and LResp.Ok then begin
              FToken:='';
              result:=true;
            end;
          end else mensaje:='Respuesta no valida';
        finally
          LResp.free;
        end;
      except
        on E: Exception do mensaje:='Error parseando logout: '+E.Message+' | Raw='+LRaw;
      end;
    end
    else mensaje:=format('Error HTTP %d: %s',[LHttpResp.StatusCode,LRaw]);
  finally
    LHttp.free;
  end;
end;

function TApiClient.downloadfile(const remotename,localpath:string;out mensaje:string):boolean;
var
  LHttp:THTTPClient;
  LResp:IHTTPResponse;
  LStream:TFileStream;
  LUrl:string;
begin
  descargando.show;
  descargando.Update;
  result:=false;
  mensaje:='';
  if FToken='' then begin
    mensaje:='No hay token';
    descargando.close;
    exit;
  end;
  LHttp:=THTTPClient.create;
  try
    LHttp.CustomHeaders['Authorization']:='Bearer '+FToken;
    ForceDirectories(ExtractFileDir(localpath));
    LStream:=TFileStream.create(localpath,fmCreate);
    try
      LUrl:=FBaseUrl+'/download/'+remotename;
      LResp:=LHttp.Get(LUrl,LStream);
      if LResp.StatusCode=200 then begin
        mensaje:='Fichero descargado correctamente';
        result:=true;
      end else mensaje:=format('Error HTTP %d',[LResp.StatusCode]);
    finally
      LStream.free;
    end;
  finally
    LHttp.free;
  end;
  descargando.close;
end;

end.
