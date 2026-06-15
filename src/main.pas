unit main;
//{$DEFINE IS_DEBUG}
interface
uses graphics,ExtCtrls;

procedure form_principal_create;
procedure form_principal_close;
procedure form_principal_execute;
procedure pillar_juegos;
procedure ordena_juegos;
procedure mostrar_juegos;
function numero_juego:integer;
procedure abrir_ficheros_separados(nombre_ficheros,ruta_ficheros:string);
procedure config_show;
function seleccionar_directorio(inicial:string):string;
procedure PNGBlurEnImage(image:TImage;image_string:string);
function cambiar_path(cadena:string):string;
function juego_mal(ngame:integer):boolean;
function juego_dir(ngame:integer):string;
function juego_imagen(ngame:integer):string;
function juego_setup(ngame:integer):string;
function comprobar_win98:boolean;
function comprobar_win3:boolean;
function comprobar_scummvm:boolean;
{$ifdef fpc}
function comprobar_si_existe_fichero(directorio:string;var nombre:string;es_zip:boolean):boolean;
{$endif}

const
  MMSDOS=0;
  MSCUMM=1;
  MAPPLE2=2;
  MATARI8=3;
  MAMIGA=4;
  MATARIST=5;
  MWIN98=6;
  MWIN3=7;
  MGUNSTICK=254;
  MDSP=255;
  MAX_GAMES=2000;
  TEMP_DIR='TEMP';
  VERSION='v0.84β';
  BLURFACT=2;
  {$IFDEF IS_DEBUG}
  {$ifndef windows}
  debug_base_dir='/home/leniad/abandon/GamePlayVol1/';
  {$else}
  debug_base_dir='c:\datos\abandon\GamePlay_084\';
  {$ENDIF}
  {$endif}
  NREFS=2;
  ESP=$10000;
  ING=$20000;
  ALE=$40000;
  FRA=$80000;
  ITA=$100000;
  NO_SCUMM=$800000;
  AG=1;
  ARCADE=2;
  TRESD=4;
  SIMULA=8;
  SPORT=$10;
  PUZ=$20;
  RPG=$40;
  COCHES=$80;
  SIN_COMPRIMIR=0;
  FICHERO_ZIP=1;
  FICHERO_RAR=2;

type
  tipo_ref=record
    nref:integer;
    mal:boolean;
    zip:byte;
  end;
  tipo_final=record
    nombre:string;
    dir:string;
    exec:string;
    loadfix:boolean;
    params:string;
    exec_pre:string;
    exec_post:string;
    segundo_disco:string;
    tercer_disco:string;
    cuarto_disco:string;
    ciclos:integer;
    grafica:string;
    extra_param:string;
    mapper:string;
    gus:boolean;
    gunstick:boolean;
    scumm:boolean;
    cdrom:string;
    memoria:integer;
    setup:string;
    zip:byte;
    year:string;
    company:string;
    manual:string;
    map:string;
    guia:string;
    image_name:string;
    tipo:integer;
    mensaje:string;
    mal:boolean;
    ref:array[0..NREFS] of tipo_ref;
    motor:byte;
  end;
  type
  tipo_games_ref=record
    nombre_original:string;
    nombre:string;
    dir:string;
    exec:string;
    exec_pre:string;
    segundo_disco:string;
    ciclos:integer;
    grafica:string;
    mapper:string;
    manual:string;
    guia:string;
    setup:string;
    image_alt:string;
    mensaje:string;
  end;
  tipo_config=record
     config_dosbox:string;
     config_dosbox_x:string;
     config_scummvm:string;
     config_dsp:string;
     config_atari800:string;
     config_apple:string;
     config_amiga:string;
     config_atarise:string;
     mostrar_funcionan:boolean;
     motor_msdos:byte;
     dir_base:string;
     dir_manual:string;
     dir_mapas:string;
     dir_guias:string;
     dir_imgs:string;
     dir_mt32:string;
     dir_zip:string;
     motor:integer;
     apple2_joy:boolean;
     descargar_extra:boolean;
  end;

var
  orden_games:array[0..(MAX_GAMES-1)] of integer;
  games_final:array[0..(MAX_GAMES-1)] of tipo_final;
  games_final_ref:array of tipo_games_ref;
  main_config:tipo_config;
  idioma_sel,juego_editado,total_juegos:integer;
  total_scumm,total_apple,total_atari800,total_msdos,total_amiga,total_dsp,total_atarise,total_win98,total_win3:integer;
  ejecutar_setup,estoy_anadiendo,estoy_ejecutando:boolean;
  dir_dsp:string;

implementation
uses {$IFDEF WINDOWS}windows,shellapi,MMSystem{$ELSE}LCLIntf,process{$ENDIF},principal,
     inifiles,grids,sysutils,forms,idioma_info,strutils,dsp_data,
     config,dialogs{$ifdef fpc},classes,zipper{$else},zip,uitypes{$endif},
     games_download,system.ioutils,Vcl.Imaging.pngimage,math,types,System.JSON,
     mensajes,system.generics.Collections,rar;

const
 RETURN=chr(10);

procedure PNGBlurEnImage(image:TImage;image_string:string);
type
  TRGBTripleArray = array[0..$400] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;
var
  PNG:TPngImage;
  src,temp,small,blurbmp,finalbmp:graphics.tbitmap;
  x,y,xx,yy,r,g,b,count,smallw,smallh,reduce:integer;
  RowSrc,RowTemp,RowDst:PRGBTripleArray;
  Re:trect;
begin
  PNG:=TPngImage.Create;
  src:=graphics.tbitmap.Create;
  small:=graphics.tbitmap.Create;
  temp:=graphics.tbitmap.Create;
  blurbmp:=graphics.tbitmap.Create;
  finalbmp:=graphics.tbitmap.Create;
  try
    PNG.LoadFromFile(image_string);
    src.assign(PNG);
    src.pixelformat:=pf24bit;
    if src.width>600 then reduce:=4
      else if src.width>400 then reduce:=3
            else reduce:=2;
    smallw:=src.width div reduce;
    smallh:=src.height div reduce;
    small.setSize(smallw,smallh);
    small.pixelformat:=pf24bit;
    setStretchBltMode(small.canvas.handle,HALFTONE);
    setBrushOrgEx(small.canvas.handle,0,0,nil);
    re:=rect(0,0,smallw,smallh);
    small.canvas.StretchDraw(re,src);
    temp.SetSize(small.width,small.height);
    temp.pixelformat:=pf24bit;
    blurbmp.setSize(small.width,small.height);
    blurbmp.pixelformat:=pf24bit;
    // Pasada horizontal
    for y:=0 to small.Height-1 do begin
      rowsrc:=small.scanline[y];
      rowtemp:=temp.scanline[y];
      for x:=0 to small.width-1 do begin
        r:=0;
        g:=0;
        b:=0;
        Count:=0;
        for xx:=Max(0,x-blurfact) to Min(Small.Width-1,x+blurfact) do begin
          Inc(r,RowSrc[xx].rgbtRed);
          Inc(g,RowSrc[xx].rgbtGreen);
          Inc(b,RowSrc[xx].rgbtBlue);
          Inc(count);
        end;
        RowTemp[x].rgbtRed:=r div count;
        RowTemp[x].rgbtGreen:=g div count;
        RowTemp[x].rgbtBlue:=b div count;
      end;
    end;
    // Pasada vertical
    for y:=0 to temp.height-1 do begin
      rowdst:=blurbmp.scanline[y];
      for x:=0 to temp.width-1 do begin
        r:=0;
        g:=0;
        b:=0;
        count:=0;
        for yy:=max(0,y-blurfact) to min(temp.height-1,y+blurfact) do begin
          rowtemp:=temp.scanline[yy];
          inc(r,rowtemp[x].rgbtred);
          inc(g,rowtemp[x].rgbtgreen);
          inc(b,rowtemp[x].rgbtblue);
          inc(count);
        end;
        rowdst[x].rgbtred:=r div count;
        rowdst[x].rgbtgreen:=g div count;
        rowdst[x].rgbtblue:=b div count;
      end;
    end;
    finalbmp.setsize(src.width,src.height);
    finalbmp.pixelformat:=pf24bit;
    SetStretchBltMode(finalbmp.canvas.handle,HALFTONE);
    SetBrushOrgEx(finalbmp.canvas.handle,0,0,nil);
    re:=rect(0,0,finalbmp.width,finalbmp.height);
    finalbmp.canvas.stretchdraw(re,blurbmp);
    image.picture.assign(finalbmp);
  finally
    finalbmp.free;
    blurbmp.free;
    temp.free;
    small.free;
    src.free;
    PNG.free;
  end;
end;

procedure descomprime_zip(fichero,donde:string);
var
  ZipFile:TZipFile;
begin
ZipFile:=TZipFile.Create;
if Zipfile.IsValid(fichero) then begin
  message_num:=1;
  form2.show;
  form2.Update;
  ZipFile.Open(fichero,zmRead);
  ZipFIle.ExtractAll(donde);
  form2.close;
  ZipFile.Close;
end;
ZipFile.Free;
end;

procedure descomprime_rar(fichero,donde:string);
var
   rar:TRAR;
begin
rar:=Trar.Create(nil);
message_num:=1;
form2.show;
form2.Update;
try
  rar.extractArchive(fichero,donde);
finally
  form2.close;
  rar.Free;
end;
end;

function comprobar_scummvm:boolean;
begin
  comprobar_scummvm:=false;
  if not(fileexists(main_config.dir_base+'extras\scummvm\scummvm.exe')) then begin
      if MessageDlg(list_descarga[2],mtWarning,[mbOK]+[mbCancel],0)=2 then exit;
      comprobar_scummvm:=descargar_fichero('scummvm.zip',main_config.dir_base+TEMP_DIR+'\scummvm.zip',true);
      descomprime_zip(main_config.dir_base+TEMP_DIR+'\scummvm.zip',main_config.dir_base+'extras\scummvm');
      exit;
  end;
  comprobar_scummvm:=true;
end;

function comprobar_win98:boolean;
begin
  comprobar_win98:=false;
  if not(fileexists(main_config.dir_base+'extras\win98\win98.zip')) then begin
      if MessageDlg(list_descarga[0],mtWarning,[mbOK]+[mbCancel],0)=2 then exit;
      comprobar_win98:=descargar_fichero('win98.zip',main_config.dir_base+'extras\win98\win98.zip',true);
      exit;
  end;
  comprobar_win98:=true;
end;

function comprobar_win3:boolean;
begin
  comprobar_win3:=false;
  if not(fileexists(main_config.dir_base+'extras\win3\win3.zip')) then begin
      if MessageDlg(list_descarga[1],mtWarning,[mbOK]+[mbCancel],0)=2 then exit;
      comprobar_win3:=descargar_fichero('win3.zip',main_config.dir_base+'extras\win3\win3.zip',true);
      exit;
  end;
  comprobar_win3:=true;
end;

function juego_mal(ngame:integer):boolean;
begin
  juego_mal:=games_final[ngame].mal;
  if ((games_final[ngame].ref[0].nref<>0) and (form1.ComboBox1.ItemIndex<>-1)) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_mal:=games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].mal;
  end;
end;

function juego_dir(ngame:integer):string;
begin
  juego_dir:=games_final[ngame].dir;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_dir:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].dir;
  end;
end;

function juego_exec(ngame,pos:integer):string;
var
  res:string;
begin
  juego_exec:=games_final[ngame].exec;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if pos>0 then begin
        res:=games_final_ref[games_final[ngame].ref[pos-1].nref and $ffff].exec;
        if res<>'' then juego_exec:=res;
      end;
  end;
end;

function juego_setup(ngame:integer):string;
begin
  juego_setup:=games_final[ngame].setup;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_setup:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].setup;
  end;
end;

function juego_imagen(ngame:integer):string;
var
  res:string;
begin
  juego_imagen:=games_final[ngame].image_name;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then begin
        res:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].image_alt;
        if res<>'' then juego_imagen:=res;
      end;
  end;
end;

function tamano_fichero(nombre_fichero:string):integer;
var
  fichero:file of byte;
  res:integer;
begin
  res:=0;
  if fileexists(nombre_fichero) then begin
    {$I-}
    assignfile(fichero,nombre_fichero);
    reset(fichero);
    res:=filesize(fichero);
    closefile(fichero);
    {$I+}
  end;
  tamano_fichero:=res;
end;

function cambiar_path(cadena:string):string;
begin
 {$IFDEF WINDOWS}
 cambiar_path:=stringreplace(cadena,'/','\',[rfReplaceAll]);
 {$ELSE}
 cambiar_path:=stringreplace(cadena,'\','/',[rfReplaceAll]);
 {$ENDIF}
end;

function seleccionar_directorio(inicial:string):string;
var
  {$ifndef fpc}
  OpenDialog:TFileOpenDialog;
  {$else}
  OpenDialog:TSelectDirectoryDialog;
  {$endif}
begin
{$ifndef fpc}
OpenDialog:=TFileOpenDialog.Create(nil);
try
  OpenDialog.Options:=OpenDialog.Options+[fdoPickFolders];
  openDialog.DefaultFolder:=inicial;
  if OpenDialog.Execute then seleccionar_directorio:=OpenDialog.FileName;
finally
  OpenDialog.Free;
end;
{$else}
OpenDialog:=TSelectDirectoryDialog.Create(nil);
try
  openDialog.InitialDir:=inicial;
  if OpenDialog.Execute then seleccionar_directorio:=OpenDialog.FileName;
finally
  OpenDialog.Free;
end;
{$endif}
end;

procedure abrir_ficheros_separados(nombre_ficheros,ruta_ficheros:string);
var
  fichero_cut,fichero_extract:string;
  posicion:integer;
  existe,salir:boolean;
begin
fichero_cut:=nombre_ficheros;
if fichero_cut='' then exit;
salir:=false;
while not(salir) do begin
  posicion:=pos('$',fichero_cut);
  if posicion=0 then salir:=true;
  if posicion<>0 then fichero_extract:=ruta_ficheros+LeftStr(fichero_cut,posicion-1)
    else fichero_extract:=ruta_ficheros+fichero_cut;
  fichero_cut:=RightStr(fichero_cut,Length(fichero_cut)-posicion);
  existe:=true;
  if not(fileexists(fichero_extract)) then existe:=descargar_manual(numero_juego);
  if existe then begin
    {$IFDEF WINDOWS}
    ShellExecute(Application.Handle,'open',pchar(fichero_extract),nil,nil, SW_SHOWNORMAL);
    {$ELSE}
    OpenDocument(fichero_extract);
    {$ENDIF}
  end;
end;
if form1.Visible then form1.StringGrid1.SetFocus;
end;

function numero_juego:integer;
begin
  if form1.stringgrid1.Cells[1,form1.stringgrid1.row]<>'' then numero_juego:=strtoint(form1.stringgrid1.Cells[1,form1.stringgrid1.row])
    else numero_juego:=-1;
end;

function sacar_datos(var cadena:string):string;
var
  posicion:integer;
begin
posicion:=pos(';',cadena);
if posicion=0 then begin
  sacar_datos:=cadena;
  exit;
end;
sacar_datos:=LeftStr(cadena,posicion-1);
cadena:=RightStr(cadena,Length(cadena)-posicion);
end;

function sacar_numero(cadena:string):integer;
begin
if cadena='' then sacar_numero:=0
  else sacar_numero:=strtoint(cadena);
end;

procedure mostrar_juegos;
var
  f,contador,mascara,totales_bien:integer;
  temps:string;

procedure poner_juego_dsp(pos:integer);
begin
  form1.stringgrid1.RowCount:=form1.stringgrid1.RowCount+1;
  form1.stringgrid1.Cells[0,contador]:=games_final[orden_games[pos]].nombre;
  form1.stringgrid1.Cells[1,contador]:=inttostr(orden_games[pos]);
  contador:=contador+1;
  if not(games_final[orden_games[f]].mal) then totales_bien:=totales_bien+1;
end;

procedure poner_juego_motor(pos:integer);
var
  motor_final:byte;
begin
motor_final:=main_config.motor;
if ((main_config.motor=MSCUMM) and games_final[orden_games[pos]].scumm) then motor_final:=MMSDOS;
if (games_final[orden_games[pos]].motor=motor_final) then begin
  if (games_final[orden_games[f]].tipo and mascara)<>0 then begin
    form1.stringgrid1.RowCount:=form1.stringgrid1.RowCount+1;
    form1.stringgrid1.Cells[0,contador]:=games_final[orden_games[pos]].nombre;
    form1.stringgrid1.Cells[1,contador]:=inttostr(orden_games[pos]);
    contador:=contador+1;
    if not(games_final[orden_games[f]].mal) then totales_bien:=totales_bien+1;
  end;
end;
end;

begin
if total_juegos=0 then exit;
form1.stringgrid1.RowCount:=total_juegos;
form1.Timer1.Enabled:=false;
contador:=0;
totales_bien:=0;
form1.stringgrid1.Cells[0,0]:='';
form1.stringgrid1.Cells[1,0]:='-1';
for f:=0 to (total_juegos-1) do begin
  //DSP
  if (games_final[orden_games[f]].motor=MDSP) then begin
    if main_config.motor<>MDSP then continue;
    if main_config.mostrar_funcionan then begin
      if not(games_final[orden_games[f]].mal) then poner_juego_dsp(f)
    end else poner_juego_dsp(f);
  end else begin //Resto
    mascara:=AG*byte(form1.checkbox3.Checked)+ARCADE*byte(form1.checkbox16.Checked)+TRESD*byte(form1.checkbox6.Checked)+SIMULA*byte(form1.checkbox4.Checked)+SPORT*byte(form1.checkbox5.Checked)+PUZ*byte(form1.checkbox7.Checked)+RPG*byte(form1.checkbox8.Checked)+COCHES*byte(form1.checkbox17.Checked);
    if ((mascara=0) or (main_config.motor=MSCUMM)) then mascara:=$ffffff;
    if main_config.mostrar_funcionan then begin
      if not(games_final[orden_games[f]].mal) then poner_juego_motor(f);
    end else poner_juego_motor(f);
  end;
end;
case main_config.motor of
    MMSDOS:temps:=inttostr(total_msdos);
    MSCUMM:temps:=inttostr(total_scumm);
    MAPPLE2:temps:=inttostr(total_apple);
    MATARI8:temps:=inttostr(total_atari800);
    MAMIGA:temps:=inttostr(total_amiga);
    MATARIST:temps:=inttostr(total_atarise);
    MWIN98:temps:=inttostr(total_win98);
    MWIN3:temps:=inttostr(total_win3);
    MDSP:temps:=inttostr(total_dsp);
end;
form1.stringgrid1.RowCount:=contador;
form1.Label5.Caption:='TOTAL: '+inttostr(totales_bien)+'/'+temps;
form1.StringGrid1Click(nil);
if form1.Visible then form1.StringGrid1.SetFocus;
end;

procedure pillar_juegos;
function comprobar_si_existe(ngame:integer;dir:string;var tipo_comp:byte;pos:integer):boolean;
var
  juego:string;
  res:boolean;
begin
tipo_comp:=SIN_COMPRIMIR;
//Primero compruebo si existe el directorio y el fichero ejecutable
juego:=juego_exec(ngame,pos);
res:=fileexists(main_config.dir_base+dir+'\'+juego);
//No existe, pruebo si es un ZIP
if not(res) then begin
  res:=fileexists(main_config.dir_zip+dir+'.zip');
  if res then begin
    tipo_comp:=FICHERO_ZIP;
  end else begin
      res:=fileexists(main_config.dir_zip+dir+'.rar');
      if res then tipo_comp:=FICHERO_RAR;
  end;
end;
comprobar_si_existe:=res;
end;

var
  f,h,tempi:integer;
  temps:string;
  RootObj:TJSONObject;
  JSONValue:TJSONValue;
  games,games_ref,ref,version:TJSONArray;
  gameobj:TJSONObject;
begin
total_msdos:=0;
total_scumm:=0;
total_apple:=0;
total_atari800:=0;
total_amiga:=0;
total_dsp:=0;
total_atarise:=0;
total_win98:=0;
//Primero los fijos...
if not(fileexists(main_config.dir_base+'games.json')) then begin
  if MessageDlg(list_descarga[4],mtWarning,[mbYes]+[mbNO],0)=7 then exit;
  descargar_juego_sin_confirmar(0);
  if not(fileexists(main_config.dir_base+'games.json')) then exit;
end;
JSONValue:=TJSONObject.ParseJSONValue(TFile.ReadAllText(main_config.dir_base+'games.json',TEncoding.UTF8));
RootObj:=JSONValue as TJSONObject;
version:=RootObj.GetValue<TJSONArray>('version');
if version.Count=1 then begin
  gameobj:=version.Items[0] as TJSONObject;
  temps:=gameobj.GetValue<string>('version');
  tempi:=strtoint(comprobar_version_lista);
  if tempi>strtoint(temps) then begin
    if MessageDlg(list_descarga[5],mtWarning,[mbOK]+[mbCancel],0)=1 then begin
      descargar_juego_sin_confirmar(0);
    end;
  end;
end;
JSONValue.free;
JSONValue:=TJSONObject.ParseJSONValue(TFile.ReadAllText(main_config.dir_base+'games.json',TEncoding.UTF8));
RootObj:=JSONValue as TJSONObject;
games:=RootObj.GetValue<TJSONArray>('games');
games_ref:=RootObj.GetValue<TJSONArray>('games_ref');
setlength(games_final_ref,games_ref.Count+1);
for f:=0 to (games_ref.Count-1) do begin
  gameobj:=games_ref.Items[f] as TJSONObject;
  games_final_ref[f+1].nombre_original:=gameobj.GetValue<string>('nombre_original');
  games_final_ref[f+1].nombre:=gameobj.GetValue<string>('nombre');
  games_final_ref[f+1].dir:=gameobj.GetValue<string>('dir');
  games_final_ref[f+1].exec:=gameobj.GetValue<string>('exec');
  games_final_ref[f+1].exec_pre:=gameobj.GetValue<string>('exec_pre');
  games_final_ref[f+1].segundo_disco:=gameobj.GetValue<string>('segundo_disco');
  games_final_ref[f+1].ciclos:=gameobj.GetValue<integer>('ciclos');
  games_final_ref[f+1].grafica:=gameobj.GetValue<string>('grafica');
  games_final_ref[f+1].mapper:=gameobj.GetValue<string>('mapper');
  games_final_ref[f+1].manual:=gameobj.GetValue<string>('manual');
  games_final_ref[f+1].guia:=gameobj.GetValue<string>('guia');
  games_final_ref[f+1].setup:=gameobj.GetValue<string>('setup');
  games_final_ref[f+1].image_alt:=gameobj.GetValue<string>('image_alt');
  games_final_ref[f+1].mensaje:=gameobj.GetValue<string>('mensaje');
end;
for f:=0 to (games.Count-1) do begin
  gameobj:=games.Items[f] as TJSONObject;
  games_final[f].nombre:=gameobj.GetValue<string>('nombre');
  games_final[f].dir:=gameobj.GetValue<string>('dir');
  games_final[f].exec:=gameobj.GetValue<string>('exec');
  games_final[f].loadfix:=gameobj.GetValue<boolean>('loadfix');
  games_final[f].params:=gameobj.GetValue<string>('params');
  games_final[f].exec_pre:=gameobj.GetValue<string>('exec_pre');
  games_final[f].exec_post:=gameobj.GetValue<string>('exec_post');
  games_final[f].segundo_disco:=gameobj.GetValue<string>('segundo_disco');
  games_final[f].tercer_disco:=gameobj.GetValue<string>('tercer_disco');
  games_final[f].cuarto_disco:=gameobj.GetValue<string>('cuarto_disco');
  games_final[f].ciclos:=gameobj.GetValue<integer>('ciclos');
  games_final[f].grafica:=gameobj.GetValue<string>('grafica');
  games_final[f].extra_param:=gameobj.GetValue<string>('extra_param');
  games_final[f].mapper:=gameobj.GetValue<string>('mapper');
  games_final[f].gus:=gameobj.GetValue<boolean>('gus');
  games_final[f].gunstick:=gameobj.GetValue<boolean>('gunstick');
  games_final[f].scumm:=gameobj.GetValue<boolean>('scumm');
  games_final[f].cdrom:=gameobj.GetValue<string>('cdrom');
  games_final[f].memoria:=gameobj.GetValue<integer>('memoria');
  games_final[f].setup:=gameobj.GetValue<string>('setup');
  //ES IMPORTANTE ESTE ORDEN!!!
  if gameobj.tryGetValue<TJSONArray>('refs',ref) then begin
    ref:=gameobj.GetValue<TJSONArray>('refs');
    for h:=0 to NREFS do begin
      tempi:=strtoint(ref.Items[h].value);
      if (tempi<>0) then begin
        games_final[f].ref[h].nref:=tempi;
        games_final[f].ref[h].mal:=not(comprobar_si_existe(f,games_final_ref[tempi and $ffff].dir,games_final[f].ref[h].zip,h+1));
      end;
    end;
  end;
  games_final[f].mal:=not(comprobar_si_existe(f,games_final[f].dir,games_final[f].zip,0));
  games_final[f].motor:=gameobj.GetValue<byte>('motor');
  games_final[f].year:=gameobj.GetValue<string>('year');
  games_final[f].company:=gameobj.GetValue<string>('company');
  games_final[f].manual:=gameobj.GetValue<string>('manual');
  games_final[f].map:=gameobj.GetValue<string>('map');
  games_final[f].guia:=gameobj.GetValue<string>('guia');
  games_final[f].image_name:=gameobj.GetValue<string>('image_name');
  games_final[f].tipo:=gameobj.GetValue<integer>('tipo');
  games_final[f].mensaje:=gameobj.GetValue<string>('mensaje');
  case games_final[f].motor of
      MMSDOS:begin
                total_msdos:=total_msdos+1;
                if games_final[f].scumm then total_scumm:=total_scumm+1;
             end;
      MSCUMM:total_scumm:=total_scumm+1;
      MAPPLE2:total_apple:=total_apple+1;
      MATARI8:total_atari800:=total_atari800+1;
      MAMIGA:total_amiga:=total_amiga+1;
      MATARIST:total_atarise:=total_atarise+1;
      MWIN98:total_win98:=total_win98+1;
      MWIN3:total_win3:=total_win3+1;
  end;
end;
total_juegos:=games.Count;
JSONValue.free;
//Juegos DSP
for f:=0 to (GAME_TOTAL_DSP-1) do begin
 games_final[total_juegos].nombre:=GAME_DATA_DSP[f].nombre;
 games_final[total_juegos].dir:=GAME_DATA_DSP[f].dir;
 games_final[total_juegos].company:=GAME_DATA_DSP[f].exec;
 games_final[total_juegos].ciclos:=GAME_DATA_DSP[f].ciclos;
 games_final[total_juegos].year:=GAME_DATA_DSP[f].extra_param;
 games_final[total_juegos].motor:=MDSP;
 games_final[total_juegos].mal:=true;
 temps:=games_final[total_juegos].dir+'.zip';
 if temps<>'.zip' then games_final[total_juegos].mal:=not(fileexists(dir_dsp+'roms\'+temps));
 total_dsp:=total_dsp+1;
 total_juegos:=total_juegos+1;
end;
end;

procedure ordena_juegos;
var
  f,h,pos:integer;
begin
for f:=0 to (total_juegos-1) do orden_games[f]:=f;
for f:=0 to (total_juegos-2) do begin
  for h:=0 to (total_juegos-2) do begin
    if games_final[orden_games[h]].nombre>games_final[orden_games[h+1]].nombre then begin
      pos:=orden_games[h];
      orden_games[h]:=orden_games[h+1];
      orden_games[h+1]:=pos;
    end;
  end;
end;
end;

procedure cambiar_ini(motor:integer;section,identidad,valor:string);
var
  fich_ini:Tinifile;
  fichero:string;
begin
  case motor of
    MSCUMM:fichero:=main_config.config_scummvm;
    MAPPLE2:fichero:=main_config.config_apple;
    MATARI8:fichero:=main_config.config_atari800;
    MAMIGA:fichero:=main_config.config_amiga;
    MATARIST:fichero:=main_config.config_atarise;
    MDSP:fichero:=main_config.config_dsp;
    MGUNSTICK:fichero:=main_config.dir_base+'extras\dosboxgs\dosbox.conf'
  end;
  {$I-}
  if fileexists(fichero) then begin
    fich_ini:=Tinifile.Create(fichero);
    fich_ini.WriteString(section,identidad,valor);
    fich_ini.Free;
  end;
  {$I+}
end;

procedure form_principal_create;
var
  f,joysticks:integer;
  dosbox_file:textfile;
  file_name:string;
  fich_ini:Tinifile;
  joyInfo:TJoyInfo;
begin
  old_game:=-1;
  form1.Caption:='GamePlay '+VERSION;
  joysticks:=0;
  for f:=0 to (joyGetNumDevs-1) do begin
    if joyGetPos(f,@joyInfo)=JOYERR_NOERROR then joysticks:=joysticks+1;
  end;
  total_juegos:=0;
  //Montar main_config, el orden es importante!!!
  {$IFDEF IS_DEBUG}
  main_config.dir_base:=debug_base_dir;
  {$ELSE}
  main_config.dir_base:=ExtractFilePath(application.ExeName);
  {$ENDIF}
  CreateDir(cambiar_path(main_config.dir_base+TEMP_DIR));
  //Leer las opciones
  if fileexists(main_config.dir_base+'gameplay.ini') then begin
    fich_ini:=Tinifile.Create(main_config.dir_base+'gameplay.ini');
    //Filtros tipo
    form1.checkbox3.Checked:=(fich_ini.readinteger('filtros','ag',1)<>0);
    form1.checkbox16.Checked:=(fich_ini.readinteger('filtros','arcade',1)<>0);
    form1.checkbox6.Checked:=(fich_ini.readinteger('filtros','3d',1)<>0);
    form1.checkbox4.Checked:=(fich_ini.readinteger('filtros','simulador',1)<>0);
    form1.checkbox5.Checked:=(fich_ini.readinteger('filtros','deportes',1)<>0);
    form1.checkbox7.Checked:=(fich_ini.readinteger('filtros','puzles',1)<>0);
    form1.checkbox8.Checked:=(fich_ini.readinteger('filtros','rpg',1)<>0);
    form1.checkbox17.Checked:=(fich_ini.readinteger('filtros','coches',1)<>0);
    //Opciones
    main_config.motor:=fich_ini.readinteger('opciones','motor',0);
    case main_config.motor of
      MMSDOS:form1.radiobutton1.Checked:=true;
      MSCUMM:form1.radiobutton3.Checked:=true;
      MDSP:form1.radiobutton4.Checked:=true;
      MAPPLE2:form1.radiobutton5.Checked:=true;
      MATARI8:form1.radiobutton6.Checked:=true;
      MAMIGA:form1.radiobutton10.Checked:=true;
      MATARIST:form1.radiobutton11.Checked:=true;
      MWIN98:form1.radiobutton12.Checked:=true;
      MWIN3:form1.radiobutton13.Checked:=true;
    end;
    form1.checkbox1.Checked:=(fich_ini.readinteger('opciones','pantalla',1)<>0);
    form1.checkbox14.Checked:=(fich_ini.readinteger('opciones','sonido',1)<>0);
    form1.checkbox2.Checked:=(fich_ini.readinteger('opciones','ayuda',1)<>0);
    form1.checkbox15.Checked:=(fich_ini.readinteger('opciones','avanzado',0)<>0);
    idioma_sel:=fich_ini.readinteger('opciones','idioma',200);
    //ficheros extra config
    main_config.config_dosbox:=fich_ini.ReadString('opciones','config_dosbox',main_config.dir_base+'extras\config\dosbox.conf');
    main_config.config_dosbox_x:=fich_ini.ReadString('opciones','config_dosbox_x',main_config.dir_base+'extras\config\dosbox-x.conf');
    main_config.config_scummvm:=fich_ini.ReadString('opciones','config_scummvm',main_config.dir_base+'extras\config\scummvm.ini');
    main_config.config_dsp:=fich_ini.ReadString('opciones','config_dsp',main_config.dir_base+'dsp\dsp.ini');
    main_config.config_atari800:=fich_ini.ReadString('opciones','config_atari800',main_config.dir_base+'extras\config\altirra.ini');
    main_config.config_apple:=fich_ini.ReadString('opciones','config_apple',main_config.dir_base+'extras\config\apple2.ini');
    main_config.config_amiga:=fich_ini.ReadString('opciones','config_amiga',main_config.dir_base+'extras\winuae\winuae.ini');
    main_config.config_atarise:=fich_ini.ReadString('opciones','config_atarise',main_config.dir_base+'extras\config\hatari.cfg');
    main_config.mostrar_funcionan:=(fich_ini.readinteger('opciones','mostrar_todos',0)<>0);
    form1.checkbox9.Checked:=main_config.mostrar_funcionan;
    main_config.motor_msdos:=fich_ini.ReadInteger('opciones','motor_msdos',1);
    main_config.apple2_joy:=(fich_ini.readinteger('opciones','apple2_joy',0)<>0);
    form1.checkbox19.Checked:=fich_ini.readinteger('opciones','amiga_vertical',0)<>0;
    form1.checkbox20.Checked:=fich_ini.readinteger('opciones','amiga_horizontal',0)<>0;
    main_config.dir_manual:=fich_ini.ReadString('opciones','dir_manual',main_config.dir_base+'extras\manual\');
    main_config.dir_mapas:=fich_ini.ReadString('opciones','dir_maps',main_config.dir_base+'extras\maps\');
    main_config.dir_guias:=fich_ini.ReadString('opciones','dir_guias',main_config.dir_base+'extras\walk\');
    main_config.dir_imgs:=fich_ini.ReadString('opciones','dir_imgs',main_config.dir_base+'extras\imgs\');
    main_config.dir_mt32:=fich_ini.ReadString('opciones','dir_mt32',main_config.dir_base+'extras\mt32');
    main_config.dir_zip:=fich_ini.ReadString('opciones','dir_zips',main_config.dir_base+'zip_games\');
    main_config.descargar_extra:=fich_ini.readinteger('opciones','descargar_extras',1)<>0;
    form1.checkbox10.Checked:=main_config.descargar_extra;
    fich_ini.Free;
  end else begin
    main_config.motor:=MMSDOS;
    form1.radiobutton1.Checked:=true;
    //form1.groupbox8.visible:=false;
    form1.checkbox15.Checked:=false;
    idioma_sel:=200;
    main_config.mostrar_funcionan:=false;
    {$ifdef windows}
    main_config.motor_msdos:=1;
    {$else}
    {$ifdef darwin}
    main_config.dosbox_exe:='/Applications/DOSBox Staging.app/Contents/MacOS/dosbox';
    main_config.dosbox_x_exe:='/Applications/dosbox-x.app/Contents/MacOS/dosbox-x';
    main_config.scumm_exe:='/Applications/ScummVM.app/Contents/MacOS/scummvm';
    main_config.dsp_exe:='';
    {$else}
    main_config.dosbox_exe:='/snap/bin/dosbox-staging';
    main_config.dosbox_x_exe:='/snap/bin/dosbox-x';
    main_config.scumm_exe:='/snap/bin/scummvm';
    main_config.dsp_exe:=main_config.dir_base+'dsp/dsp_linux';
    {$endif}
    {$endif}
    main_config.config_dosbox:=main_config.dir_base+'extras\config\dosbox.conf';
    main_config.config_dosbox_x:=main_config.dir_base+'extras\config\dosbox-x.conf';
    main_config.config_scummvm:=main_config.dir_base+'extras\config\scummvm.ini';
    main_config.config_dsp:=main_config.dir_base+'dsp\dsp.ini';
    main_config.config_atari800:=main_config.dir_base+'extras\config\altirra.ini';
    main_config.config_apple:=main_config.dir_base+'extras\config\apple2.ini';
    main_config.config_amiga:=main_config.dir_base+'extras\winuae\winuae.ini';
    main_config.config_atarise:=main_config.dir_base+'extras\config\hatari.cfg';
    main_config.apple2_joy:=false;
    form1.checkbox19.Checked:=false;
    form1.checkbox20.Checked:=false;
    form1.checkbox15.Checked:=false;
    main_config.descargar_extra:=true;
    form1.CheckBox10.Checked:=true;
    main_config.dir_manual:=main_config.dir_base+'extras\manual\';
    main_config.dir_mapas:=main_config.dir_base+'extras\maps\';
    main_config.dir_guias:=main_config.dir_base+'extras\walk\';
    main_config.dir_imgs:=main_config.dir_base+'extras\imgs\';
    main_config.dir_zip:=main_config.dir_base+'zip_games\';
    //OJO!!! No quiere la barra final!!!!
    main_config.dir_mt32:=main_config.dir_base+'extras\mt32';
  end;
  {$ifndef windows}
  main_config.dir_manual:=cambiar_path(main_config.dir_manual);
  main_config.dir_mapas:=cambiar_path(main_config.dir_mapas);
  main_config.dir_guias:=cambiar_path(main_config.dir_guias);
  main_config.dir_imgs:=cambiar_path(main_config.dir_imgs);
  main_config.dir_zip:=cambiar_path(main_config.dir_zip);
  main_config.dir_mt32:=cambiar_path(main_config.dir_mt32);
  main_config.config_dosbox:=cambiar_path(main_config.config_dosbox);
  main_config.config_dosbox_x:=cambiar_path(main_config.config_dosbox_x);
  main_config.config_scummvm:=cambiar_path(main_config.config_scummvm);
  main_config.config_dsp:=cambiar_path(main_config.config_dsp);
  main_config.config_apple:=cambiar_path(main_config.config_apple);
  main_config.config_amiga:=cambiar_path(main_config.config_amiga);
  main_config.config_atarise:=cambiar_path(main_config.config_atarise);
  {$endif}
  seleccionar_idioma;
  cambiar_idioma_principal;
  {$I-}
  //Creo el fichero de configuracion de dosbox_x
  file_name:=cambiar_path(main_config.dir_base+TEMP_DIR+'\gameplay.conf');
  AssignFile(dosbox_file,file_name);
  ReWrite(dosbox_file);
  WriteLn(dosbox_file,'[autoexec]');
  WriteLn(dosbox_file,'mount c: "'+main_config.dir_base+'"');
  CloseFile(dosbox_file);
  {$I+}
  //Modifico el fichero de configuracion de scummvm
  cambiar_ini(MSCUMM,'scummvm','extrapath',main_config.dir_mt32);
  //Modifico la config de DSP
  dir_dsp:=extractfilepath(main_config.dir_base+'dsp\');
  if not(DirectoryExists(dir_dsp)) then CreateDir(dir_dsp);
  cambiar_ini(MDSP,'dsp','auto_exec','1');
  cambiar_ini(MDSP,'dir','arcade',dir_dsp+'roms;');
  cambiar_ini(MDSP,'dir','dir_samples',dir_dsp+'samples');
  cambiar_ini(MDSP,'dir','spectrum_rom_48',dir_dsp+'roms\spectrum.zip');
  cambiar_ini(MDSP,'dir','spectrum_rom_128',dir_dsp+'roms\spec128.zip');
  cambiar_ini(MDSP,'dir','spectrum_rom_plus3',dir_dsp+'roms\plus3.zip');
  //Compruebo si hay joystick, y si en apple2 esta marcado
  if joysticks>0 then begin
    form1.radiobutton9.enabled:=true;
    if main_config.apple2_joy then form1.radiobutton9.Checked:=true
      else form1.radiobutton2.Checked:=true;
  end else begin
    form1.radiobutton9.enabled:=false;
    form1.radiobutton2.Checked:=true;
  end;
  estoy_ejecutando:=false;
  ejecutar_setup:=false;
  //Lo pongo bonito y lo muestro todo
  form1.stringgrid1.ColWidths[0]:=form1.stringgrid1.Width-30;
  {$ifndef fpc}
  form1.stringgrid1.ColWidths[1]:=-1;
  {$else}
  form1.stringgrid1.ColWidths[1]:=0;
  {$endif}
  //Selecciono el primero
  form1.stringgrid1.row:=0;
  if main_config.motor_msdos=0 then form1.radiobutton7.Checked:=true
    else form1.RadioButton8.Checked:=true;
end;

procedure delete_dir(nombre:string);
{$ifndef windows}
var
  process:tprocess;
{$endif}
begin
{$ifdef windows}
ShellExecute(form1.Handle,'open',pChar('cmd.exe'),pchar('/c rmdir '+nombre+' /s /q'),pchar(main_config.dir_base),SW_HIDE);
{$else}
process:=tprocess.create(nil);
{$ifdef darwin}
process.commandline:='/bin/rm -fr "'+main_config.dir_base+nombre+'"';
{$else}
process.commandline:='/usr/bin/rm -fr "'+main_config.dir_base+nombre+'"';
{$endif}
process.execute;
process.free;
{$endif}
sleep(100);
end;

procedure form_principal_close;
var
  fich_ini:Tinifile;
  {$IFNDEF WINDOWS}
  process:tprocess;
  {$ENDIF}
begin
//Borro el directorio temporal
delete_dir(TEMP_DIR);
//Borro el directorio que deja el doom!
delete_dir('DOOMDATA');
deletefile(main_config.dir_base+'LCACHE00.TMP');
deletefile(main_config.dir_base+'extras\win98\win98.img');
deletefile(main_config.dir_base+'extras\win3\win3.img');
delete_dir('DELUXE');
if DirectoryExists(main_config.dir_base) then begin
  {$I-}
  //grabo las opciones
  fich_ini:=Tinifile.Create(main_config.dir_base+'gameplay.ini');
  //Filtros tipo
  fich_ini.WriteInteger('filtros','ag',byte(form1.checkbox3.Checked));
  fich_ini.WriteInteger('filtros','arcade',byte(form1.checkbox16.Checked));
  fich_ini.WriteInteger('filtros','3d',byte(form1.checkbox6.Checked));
  fich_ini.WriteInteger('filtros','simulador',byte(form1.checkbox4.Checked));
  fich_ini.WriteInteger('filtros','deportes',byte(form1.checkbox5.Checked));
  fich_ini.WriteInteger('filtros','puzles',byte(form1.checkbox7.Checked));
  fich_ini.WriteInteger('filtros','rpg',byte(form1.checkbox8.Checked));
  fich_ini.WriteInteger('filtros','coches',byte(form1.checkbox17.Checked));
  //Opciones
  fich_ini.WriteInteger('opciones','motor',main_config.motor);
  fich_ini.WriteInteger('opciones','pantalla',byte(form1.checkbox1.Checked));
  fich_ini.WriteInteger('opciones','sonido',byte(form1.checkbox14.Checked));
  fich_ini.WriteInteger('opciones','ayuda',byte(form1.checkbox2.Checked));
  fich_ini.WriteInteger('opciones','avanzado',byte(form1.checkbox15.Checked));
  fich_ini.WriteInteger('opciones','idioma',idioma_sel);
  fich_ini.WriteString('opciones','config_dosbox',main_config.config_dosbox);
  fich_ini.WriteString('opciones','config_dosbox_x',main_config.config_dosbox_x);
  fich_ini.WriteInteger('opciones','motor_msdos',main_config.motor_msdos);
  fich_ini.WriteString('opciones','config_scummvm',main_config.config_scummvm);
  fich_ini.WriteString('opciones','config_dsp',main_config.config_dsp);
  fich_ini.WriteString('opciones','config_atari800',main_config.config_atari800);
  fich_ini.WriteString('opciones','config_apple',main_config.config_apple);
  fich_ini.WriteString('opciones','config_amiga',main_config.config_amiga);
  fich_ini.WriteString('opciones','config_atarise',main_config.config_atarise);
  fich_ini.WriteInteger('opciones','mostrar_todos',byte(main_config.mostrar_funcionan));
  fich_ini.WriteInteger('opciones','apple2_joy',byte(main_config.apple2_joy));
  fich_ini.WriteInteger('opciones','amiga_vertical',byte(form1.checkbox19.Checked));
  fich_ini.WriteInteger('opciones','amiga_horizontal',byte(form1.checkbox20.Checked));
  fich_ini.WriteInteger('opciones','descargar_extras',byte(main_config.descargar_extra));
  fich_ini.WriteString('opciones','dir_manual',main_config.dir_manual);
  fich_ini.WriteString('opciones','dir_maps',main_config.dir_mapas);
  fich_ini.WriteString('opciones','dir_guias',main_config.dir_guias);
  fich_ini.WriteString('opciones','dir_imgs',main_config.dir_imgs);
  fich_ini.WriteString('opciones','dir_mt32',main_config.dir_mt32);
  fich_ini.WriteString('opciones','dir_zips',main_config.dir_zip);
  fich_ini.Free;
  {$I+}
end;
end;

procedure form_principal_execute;
function juego_grafica(ngame:integer):string;
var
  res:string;
begin
  juego_grafica:=games_final[ngame].grafica;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then begin
        res:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].grafica;
        if res<>'' then juego_grafica:=res;
      end;
  end;
end;

function juego_mapper(ngame:integer):string;
begin
  juego_mapper:=games_final[ngame].mapper;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_mapper:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].mapper;
  end;
end;

function juego_mensaje(ngame:integer):string;
begin
  juego_mensaje:=games_final[ngame].mensaje;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex<>0 then juego_mensaje:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].mensaje;
  end;
end;

function juego_gunstick(ngame:integer):boolean;
begin
  juego_gunstick:=games_final[ngame].gunstick;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex<>0 then juego_gunstick:=false;
  end;
end;

function juego_ciclos(ngame:integer):integer;
var
  res:integer;
begin
  juego_ciclos:=games_final[ngame].ciclos;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex<>0 then begin
        res:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].ciclos;
        if res<>0 then juego_ciclos:=res;
      end;
  end;
end;

function juego_exec_pre(ngame:integer):string;
var
  res:string;
begin
  juego_exec_pre:=games_final[ngame].exec_pre;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then begin
        res:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].exec_pre;
        if res<>'' then juego_exec_pre:=res;
      end;
  end;
end;

function juego_es_zip(ngame:integer):byte;
begin
  juego_es_zip:=games_final[ngame].zip;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_es_zip:=games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].zip;
  end;
end;

function juego_segundo_disco(ngame:integer):string;
begin
  juego_segundo_disco:=games_final[ngame].segundo_disco;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_segundo_disco:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].segundo_disco;
  end;
end;

var
  trad_dir,cd_rom_dir,exec_dir,exec_base,exec_memoria,exec_parametros,exec_dosbox_extra_config,temp_str,temp_str2,temp_disco,exec_mapper,exec_sd,exec_roland,exec_extra,exec_params,exec_gus,exec_sound,exec_c_param,exec_string,param_string,exec_ciclos,exec_video,exec_fullscreen,exec_pre:string;
  tipo_fichero,ngame,nfloppy,tempi:integer;
  play_file:textfile;
  {$IFNDEF WINDOWS}
  process:tprocess;
  {$ENDIF}
  temps,temp_exec:string;
begin
ngame:=numero_juego;
if ngame=-1 then exit;
estoy_ejecutando:=true;
if juego_mal(ngame) then begin
  if not(descargar_juego(ngame)) then exit;
end;
//DSP Emulator
if main_config.motor=MDSP then begin
    cambiar_ini(MDSP,'dsp','maquina',inttostr(games_final[ngame].ciclos));
    if form1.checkbox14.Checked then exec_sound:='1'
      else exec_sound:='0';
    cambiar_ini(MDSP,'dsp','sonido_ena',exec_sound);
    if form1.checkbox1.Checked then exec_fullscreen:='6'
      else exec_fullscreen:='2';
    cambiar_ini(MDSP,'dsp','video',exec_fullscreen);
    {$ifdef windows}
    ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'dsp\dsp.exe'),nil,nil,SW_SHOWNORMAL);
    {$else}
    process:=tprocess.create(nil);
    process.commandline:='"'+main_config.dsp_exe+'"';
    process.execute;
    process.free;
    {$ENDIF}
    exit;
end;
trad_dir:=juego_dir(ngame);
tipo_fichero:=juego_es_zip(ngame);
//Si es un ZIP lo descomprimo!
if (tipo_fichero<>SIN_COMPRIMIR) then begin
  delete_dir(TEMP_DIR+'\'+trad_dir);
  CreateDir(cambiar_path(main_config.dir_base+TEMP_DIR+'\'+trad_dir));
  case tipo_fichero of
    FICHERO_ZIP:descomprime_zip(main_config.dir_zip+trad_dir+'.zip',main_config.dir_base+TEMP_DIR+'\'+trad_dir);
    FICHERO_RAR:descomprime_rar(main_config.dir_zip+trad_dir+'.rar',main_config.dir_base+TEMP_DIR+'\'+trad_dir);
  end;
  exec_dir:=cambiar_path(TEMP_DIR+'\'+trad_dir);
end else exec_dir:=trad_dir;
//Mostrar mensaje de ayuda
if (form1.checkbox2.Checked and (main_config.motor<>MSCUMM)) then begin
  temp_str:=juego_mensaje(ngame);
  if temp_str<>'' then begin
    case main_config.motor of
      MMSDOS:begin
                if main_config.motor_msdos=0 then temp_disco:='CONTROL+F4'
                  else temp_disco:={$ifdef windows}'F11+O';{$else}'F12+O';{$endif}
             end;
      MAPPLE2:temp_disco:='F3';
      MATARI8:temp_disco:='ALT+O';
      MAMIGA:temp_disco:='FIN+F1';
      MATARIST:temp_disco:='F11';
    end;
    temp_str:=StringReplace(temp_str,'[KEY_DISK]',temp_disco,[rfReplaceAll]);
    temp_str:=StringReplace(temp_str,'[RET]',RETURN,[rfReplaceAll]);
    MessageDlg(temp_str,mtInformation,[mbOK],0);
  end;
end;
case main_config.motor of
  MAPPLE2:begin //Apple ][
    if form1.checkbox14.Checked then exec_sound:='0'
      else exec_sound:='59';
    cambiar_ini(MAPPLE2,'Configuration','Speaker Volume',exec_sound);
    cambiar_ini(MAPPLE2,'Configuration','Mockingboard Volume',exec_sound);
    cambiar_ini(MAPPLE2,'Configuration\Slot 6','Last Disk Image 1','');
    cambiar_ini(MAPPLE2,'Configuration\Slot 6','Last Disk Image 2','');
    if games_final[ngame].extra_param='e' then cambiar_ini(MAPPLE2,'Configuration','Apple2 Type','17')
      else cambiar_ini(MAPPLE2,'Configuration','Apple2 Type','16');
    if games_final[ngame].grafica='ideal' then cambiar_ini(MAPPLE2,'Configuration','Video Emulation','1')
      else if games_final[ngame].grafica='rgb' then cambiar_ini(MAPPLE2,'Configuration','Video Emulation','2')
        else cambiar_ini(MAPPLE2,'Configuration','Video Emulation','4');
    if main_config.apple2_joy then cambiar_ini(MAPPLE2,'Configuration','Joystick0 Emu Type v3','1')
      else cambiar_ini(MAPPLE2,'Configuration','Joystick0 Emu Type v3','2');
    if games_final[ngame].segundo_disco<>'' then exec_sd:='-d2 "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].segundo_disco+'"'
      else exec_sd:='-d2-disconnected';
    if form1.checkbox1.Checked then exec_fullscreen:=' -f'
      else exec_fullscreen:='';
    temp_str:='-d1 "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].exec+'" '+exec_sd+' -conf "'+main_config.config_apple+'"'+exec_fullscreen;
    ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'extras\apple2\AppleWin.exe'),pchar(temp_str),nil,SW_SHOWNORMAL);
  end;
  MATARI8:begin   //Atari 800
    if form1.checkbox1.Checked then exec_fullscreen:=' /f'
      else exec_fullscreen:='';
    if games_final[ngame].extra_param='osb' then begin
      cambiar_ini(MATARI8,'User\Software\virtualdub.org\Altirra\Profiles\3976D689','"Kernel path"','"roms\\ATARIOSB.ROM"');
      cambiar_ini(MATARI8,'User\Software\virtualdub.org\Altirra\Profiles\3976D689','"Kernel type"','"kernel800_osb"');
    end else begin
      cambiar_ini(MATARI8,'User\Software\virtualdub.org\Altirra\Profiles\3976D689','"Kernel path"','""');
      cambiar_ini(MATARI8,'User\Software\virtualdub.org\Altirra\Profiles\3976D689','"Kernel type"','""');
    end;
    //if not(form1.checkbox14.Checked) then exec_sound:=' -nosound'
    //  else exec_sound:=' -sound';
    exec_c_param:='';
    if ContainsText(games_final[ngame].exec,'.rom') then begin
      if tamano_fichero(main_config.dir_base+exec_dir+'\'+games_final[ngame].exec)<8193 then exec_c_param:=' /cartmapper 1'
        else exec_c_param:=' /cartmapper 2'
    end;
    temp_str:='/portablealt:"'+main_config.config_atari800+'"'+exec_fullscreen+exec_sound+exec_c_param+' "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].exec+'"';
    ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'extras\atari800\Altirra.exe'),pchar(temp_str),nil,SW_SHOWNORMAL);
  end;
  MSCUMM:begin   //ScummVM
    if not(comprobar_scummvm) then exit;
    if form1.checkbox1.Checked then exec_fullscreen:='--fullscreen'
      else exec_fullscreen:='';
    if form1.checkbox14.Checked then exec_sound:='false'
      else exec_sound:='true';
    cambiar_ini(MSCUMM,'scummvm','mute',exec_sound);
    if games_final[ngame].params='[MULTI]' then
      case idioma_ind of
        0:temp_str:='--language=es';
        1:temp_str:='--language=en';
        2:temp_str:='--language=de';
        3:temp_str:='--language=fr';
        4:temp_str:='--language=it';
      end;
    {$ifdef windows}
    exec_parametros:='--no-console ';
    {$else}
    exec_parametros:='';
    {$endif}
    param_string:=exec_parametros+'--config="'+main_config.config_scummvm+'" --path="'+main_config.dir_base+exec_dir+'" --auto-detect  --native-mt32 '+exec_fullscreen+' '+temp_str;
    {$ifdef windows}
    ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'extras\scummvm\scummvm.exe'),pchar(param_string),nil,SW_SHOWNORMAL);
    {$else}
    process:=tprocess.create(nil);
    process.commandline:='/bin/bash -c '''+main_config.scumm_exe+' '+cambiar_path(param_string)+'''';
    process.execute;
    process.free;
    {$ENDIF}
  end;
  MMSDOS:begin //MS-DOS
    //cantidad de memoria
    if games_final[ngame].memoria<>0 then exec_memoria:=inttostr(games_final[ngame].memoria)
      else exec_memoria:='16';
    //Configurar directorio del ejecutable, el ejecutable, si hay fichero extra de config y los parametros indispensables, el mt32 y los ciclos
    case main_config.motor_msdos of
      0:begin //DosBox
          exec_string:=main_config.dir_base+'extras\dosbox\dosbox.exe';
          exec_dosbox_extra_config:=' --conf "'+main_config.config_dosbox+'" -set windowresolution=800x600 -set glshader=none -set ne2000=false';
          {$ifdef windows}
          temp_str:='['+games_final[ngame].nombre+']';
          {$else}
          temp_str:=''''+games_final[ngame].nombre+'''';
          {$endif}
          exec_parametros:='-set window_titlebar="program='+temp_str+' dosbox=auto cycles=off mouse=short" -set waitonerror=false -set memsize='+exec_memoria+' -set automount=false -set startup_verbosity=quiet -set mididevice=mt32 -set ultradir=C:\extras\ULTRASND';
          exec_roland:='-set romdir="'+main_config.dir_mt32+'"';
          exec_ciclos:='-set cpu_cycles=';
        end;
      1:begin //DosBox-X
          exec_string:=main_config.dir_base+'extras\dosbox_x\dosbox-x.exe';
          exec_dosbox_extra_config:=' --conf "'+main_config.config_dosbox_x+'" -set output=direct3d -set windowresolution='{$IFDEF IS_DEBUG}+'original'{$ELSE}+'800x600'{$ENDIF};
          exec_parametros:='-set titlebar="'+games_final[ngame].nombre+'" -set showmenu=true -set "quit warning"=false -set autolock=true -set showbasic=false -set fastbioslogo=true -set "disable graphical splash"=true -set startbanner=false -set memsize='+exec_memoria+' -set mididevice=mt32 -set gustype=max -set ultradir=C:\extras\ULTRASND -set disney=true -set mouse_emulation=always';
          exec_roland:='-set mt32.romdir="'+main_config.dir_mt32+'"';
          exec_ciclos:='-set cycles=';
        end;
    end;
    //Velocidad CPU
    tempi:=juego_ciclos(ngame);
    if tempi=-1 then exec_ciclos:=exec_ciclos+'auto'
      else if tempi=1 then exec_ciclos:=exec_ciclos+'max'
        else if tempi<>0 then exec_ciclos:=exec_ciclos+inttostr(tempi)
          else exec_ciclos:=exec_ciclos+'12000';
    //Crear bat de ejecucion
    {$I-}
    AssignFile(play_file,cambiar_path(main_config.dir_base+TEMP_DIR+'\start.bat'));
    ReWrite(play_file);
    WriteLn(play_file,'@echo off');
    WriteLn(play_file,'c:');
    WriteLn(play_file,'cd \');
    WriteLn(play_file,'cd '+exec_dir);
    //Comprobar si tiene un CD
    if games_final[ngame].cdrom<>'' then begin
      cd_rom_dir:=cambiar_path(main_config.dir_base+exec_dir+'\'+games_final[ngame].cdrom);
      temp_str:='imgmount d: "'+cd_rom_dir+'" -t cdrom';
      writeln(play_file,temp_str);
    end;
    //Comprobar parametros previos a la ejecucion
    exec_pre:=juego_exec_pre(ngame);
    if exec_pre<>'' then begin
        //Si es un ZIP la carpeta base es TEMP
        if (tipo_fichero<>SIN_COMPRIMIR) then begin
            temp_str:=main_config.dir_base+TEMP_DIR+'\'+games_final[ngame].dir;
            temp_str2:='c:\'+TEMP_DIR+'\'+games_final[ngame].dir;
        end else begin
            temp_str:=main_config.dir_base+games_final[ngame].dir;
            temp_str2:='c:\'+games_final[ngame].dir;
        end;
        exec_pre:=StringReplace(exec_pre,'[GAME_DIR]','"'+temp_str+'"',[]);
        exec_pre:=StringReplace(exec_pre,'[GAME_INT]',temp_str2,[]);
        if ContainsText(exec_pre,'[RET]') then exec_pre:=StringReplace(exec_pre,'[RET]',RETURN,[rfReplaceAll]);
        WriteLn(play_file,exec_pre);
    end;
    //Añadir, si existe, un fichero de setup que hay que ejecutar
    if ejecutar_setup then WriteLn(play_file,juego_setup(ngame));
    //Añadir el ejecutable
    temp_exec:=juego_exec(ngame,form1.ComboBox1.ItemIndex);
    if games_final[ngame].params<>'[MULTI]' then exec_params:=games_final[ngame].params;
    if ContainsText(temp_exec,'.bat') then WriteLn(play_file,'call '+temp_exec+' '+exec_params)
      else if games_final[ngame].loadfix then WriteLn(play_file,'loadfix '+temp_exec+' '+exec_params)
            else WriteLn(play_file,temp_exec+' '+exec_params);
    //Añadir el ejecutable post
    if games_final[ngame].exec_post<>'' then begin
        temp_str:=games_final[ngame].exec_post;
        if ContainsText(temp_str,'[RET]') then temp_str:=StringReplace(temp_str,'[RET]',RETURN,[rfReplaceAll]);
        WriteLn(play_file,temp_str);
    end;
    WriteLn(play_file,'exit');
    CloseFile(play_file);
    {$I+}
    //Comprobar si tengo parametros extra
    exec_extra:=games_final[ngame].extra_param;
    //Comprobar si tengo que activar el sonido
    if form1.checkbox14.Checked then exec_sound:='-set nosound=false'
      else exec_sound:='-set nosound=true';
    //Comprobar si usa GUS y Roland
    if games_final[ngame].gus then begin
      exec_gus:='-set sbtype=none -set gus=true';
      exec_roland:='';
    end else begin
      exec_gus:='';
    end;
    //Comprobar grafica
    exec_video:='';
    temps:=juego_grafica(ngame);
    if temps<>'' then begin
      exec_video:='-machine '+temps;
      exec_memoria:='1';
      //Si es Dosbox, cambio el parametro
      if ((main_config.motor_msdos=0) and ContainsText(exec_video,'cga_composite')) then exec_video:='-machine cga -set composite=true';
    end;
    if form1.checkbox1.Checked then exec_fullscreen:='-set fullscreen=true'
      else exec_fullscreen:='-set fullscreen=false';
    //Mirar si tiene mapper
    temps:=juego_mapper(ngame);
    if temps<>'' then exec_mapper:='-set mapperfile="'+main_config.dir_base+'extras\mappers\'+temps +'"'
      else exec_mapper:='';
    //Comprobar si es un PC-Booter (tiene la extension .img) o un cartucho PCJR
    if ((ContainsText(temp_exec,'.img') or ContainsText(temp_exec,'.jrc')) and not(ContainsText(games_final[ngame].exec_pre,'imgmount'))) then begin
      temps:=juego_segundo_disco(ngame);
      if temps<>'' then exec_sd:=' c:\'+exec_dir+'\'+temps
        else exec_sd:='';
      exec_c_param:='-c "boot c:\'+exec_dir+'\'+temp_exec+exec_sd+'"';
      exec_memoria:='1';
    end else begin
      exec_c_param:='-c c:\'+TEMP_DIR+'\start.bat'
    end;
    //Tengo que quitar la barra del final o DosBox se marea...
    exec_base:=system.copy(main_config.dir_base,1,length(main_config.dir_base)-1);
    //Lo monto todo y ejecuto
    if juego_gunstick(ngame) then begin
      exec_string:=main_config.dir_base+'extras\dosboxgs\dosbox.exe';
      if ContainsText(temp_exec,'.img') then exec_c_param:='-c "boot c:\'+exec_dir+'\'+temp_exec+exec_sd+'"'
        else exec_c_param:='-c c:\'+TEMP_DIR+'\start.bat';
      exec_dosbox_extra_config:='-noconsole -exit -conf '+main_config.dir_base+'extras\dosboxgs\dosbox.conf -conf '+main_config.dir_base+TEMP_DIR+'\gameplay.conf '+exec_c_param;
      cambiar_ini(MGUNSTICK,'cpu','cycles',inttostr(juego_ciclos(ngame)));
      if form1.checkbox1.Checked then exec_fullscreen:='true'
        else exec_fullscreen:='false';
      cambiar_ini(MGUNSTICK,'sdl','fullscreen',exec_fullscreen);
      param_string:=exec_base+' '+exec_dosbox_extra_config;
    end else param_string:='"'+exec_base+'" '+cambiar_path(exec_dosbox_extra_config)+' --conf "'+cambiar_path(main_config.dir_base+TEMP_DIR+'\gameplay.conf"')+' --noprimaryconf '+exec_mapper+' '+exec_roland+' '+exec_video+' '+exec_extra+' '+exec_sound+' '+exec_gus+' '+exec_fullscreen+' '+exec_ciclos+' '+exec_c_param+' '+exec_parametros;
    {$IFDEF WINDOWS}
    ShellExecute(form1.Handle,'open',pchar(exec_string),pchar(param_string),nil,SW_SHOWNORMAL);
    {$ELSE}
    process:=tprocess.create(nil);
    process.commandline:='"'+exec_string+'" '+param_string;
    process.execute;
    process.free;
    {$ENDIF}
  end;
  MAMIGA:begin
    if games_final[ngame].grafica='aga' then exec_video:='gameplay_aga.uae'
      else exec_video:='gameplay.uae';
    if games_final[ngame].ciclos=0 then exec_ciclos:='-s floppy_speed=400 '
      else exec_ciclos:='-s floppy_speed='+inttostr(games_final[ngame].ciclos)+' ';
    cambiar_ini(MAMIGA,'WinUAE','FloppyPath','..\..\'+exec_dir);
    if form1.checkbox1.Checked then exec_fullscreen:='-s gfx_fullscreen_amiga=true '
      else exec_fullscreen:='';
    if not(form1.checkbox14.Checked) then exec_sound:='-s sound_output=interrupts '
      else exec_sound:='';
    if games_final[ngame].loadfix then temp_str2:='-s gfx_atari_palette_fix=3to8bit '
      else temp_str2:='';
    if ContainsText(lowercase(games_final[ngame].exec),'vhd') then begin
      temp_str:='-s hardfile2=rw,DH0:'+main_config.dir_base+exec_dir+'\'+games_final[ngame].exec+','+games_final[ngame].params+' ';
      if games_final[ngame].segundo_disco<>'' then temp_str:=temp_str+'-0 "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].segundo_disco+'" -s floppy1type=-1 ';
    end else begin
      temp_str:='-0 "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].exec+'" ';
      nfloppy:=1;
      if games_final[ngame].segundo_disco<>'' then begin
        temp_str:=temp_str+'-1 "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].segundo_disco+'" ';
        nfloppy:=2;
      end else temp_str:=temp_str+'-s floppy1type=-1 ';
      if games_final[ngame].tercer_disco<>'' then begin
        temp_str:=temp_str+'-2 "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].tercer_disco+'" -s floppy2type=0 ';
        nfloppy:=3;
      end;
      if games_final[ngame].cuarto_disco<>'' then begin
        temp_str:=temp_str+'-3 "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].cuarto_disco+'" -s floppy3type=0 ';
        nfloppy:=4;
      end;
      temp_str:=temp_str+'-s nr_floppies='+inttostr(nfloppy)+' ';
    end;
    if games_final[ngame].exec_pre<>'' then exec_pre:='-s joyport1='+games_final[ngame].exec_pre+' ';
    param_string:='-G -f "'+main_config.dir_base+'extras\config\'+exec_video+'" '+temp_str+' '+exec_fullscreen+exec_sound+exec_ciclos+temp_str2+exec_pre;
    if form1.checkbox19.Checked then param_string:=param_string+'-s gfx_center_vertical=smart ';
    if form1.checkbox20.Checked then param_string:=param_string+'-s gfx_center_horizontal=smart ';
    {$IFDEF WINDOWS}
    ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'extras\winuae\winuae.exe'),pchar(param_string),nil,SW_SHOWNORMAL);
    {$ENDIF}
  end;
  MATARIST:begin
    exec_mapper:='--tos "'+main_config.dir_base+'extras\hatari\';
    if games_final[ngame].grafica='st_102' then exec_mapper:=exec_mapper+'TOS\tos102uk.img" --machine st '
      else if games_final[ngame].grafica='st' then exec_mapper:=exec_mapper+'TOS\tos104uk.img" --machine st '
        else exec_mapper:=exec_mapper+'TOS\tos162uk.img"  --machine ste ';
    if form1.checkbox1.Checked then exec_fullscreen:='-f '
      else exec_fullscreen:='';
    if not(form1.CheckBox14.Checked) then exec_sound:='--sound off '
      else exec_sound:='';
    if games_final[ngame].segundo_disco<>'' then exec_sd:='--drive-b true --disk-b "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].segundo_disco+'" '
      else exec_sd:='--drive-b false ';
    if not(games_final[ngame].loadfix) then temp_str2:='-j 1 --joy1 keys ';
    if games_final[ngame].params<>'' then exec_extra:='-d "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].params+'" '
     else exec_extra:='';
    if games_final[ngame].exec_post<>'' then exec_extra:=exec_extra+'--auto '+games_final[ngame].exec_post+' ';
    if ((games_final[ngame].exec)<>'') then temp_str:='--disk-a "'+main_config.dir_base+exec_dir+'\'+games_final[ngame].exec+'" '
      else temp_str:='';
    param_string:='-c "'+main_config.config_atarise+'" '+temp_str+exec_extra+exec_fullscreen+' --confirm-quit false '+exec_sd+exec_mapper+temp_str2+exec_sound;
    {$IFDEF WINDOWS}
    ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'extras\hatari\hatari.exe'),pchar(param_string),nil,SW_SHOWNORMAL);
    {$ENDIF}
  end;
  MWIN98:begin
     if not(comprobar_win98) then exit;
     {$I-}
     if fileexists(main_config.dir_base+'extras\win98\win98.img') then deletefile(main_config.dir_base+'extras\win98\win98.img');
     {$I+}
     descomprime_zip(main_config.dir_base+'extras\win98\win98.zip',main_config.dir_base+'\extras\win98');
     exec_dosbox_extra_config:=' --conf "'+ExtractFilePath(main_config.config_dosbox_x)+'dosbox-x_win98.conf" -set windowresolution='{$IFDEF IS_DEBUG}+'original'{$ELSE}+'800x600'{$ENDIF};
     exec_parametros:=' -set titlebar="'+games_final[ngame].nombre+'" ';
     exec_extra:=games_final[ngame].extra_param;
     if form1.checkbox1.Checked then exec_fullscreen:=' -set fullscreen=true '
      else exec_fullscreen:=' -set fullscreen=false ';
     if form1.checkbox14.Checked then exec_sound:=' -set nosound=false '
      else exec_sound:=' -set nosound=true ';
     if games_final[ngame].cdrom<>'' then cd_rom_dir:=' -c "imgmount e: '+main_config.dir_base+exec_dir+'\'+games_final[ngame].cdrom+'"'
      else cd_rom_dir:='';
     exec_pre:=juego_exec_pre(ngame);
     if exec_pre<>'' then exec_pre:=' -c "'+exec_pre+'"';
     temps:='-c "imgmount c: '+main_config.dir_base+'extras\win98\win98.img" -c "imgmount d: '+main_config.dir_base+exec_dir+'\'+games_final[ngame].exec+'" '+cd_rom_dir+exec_pre+' -c "boot c:" ';
     param_string:=temps+exec_dosbox_extra_config+exec_parametros+exec_fullscreen+exec_sound+' '+exec_extra;
     ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'extras\dosbox_x\dosbox-x.exe'),pchar(param_string),nil,SW_SHOWNORMAL);
  end;
  MWIN3:begin
     if not(comprobar_win3) then exit;
     {$I-}
     if fileexists(main_config.dir_base+'extras\win3\win3.img') then deletefile(main_config.dir_base+'extras\win3\win3.img');
     {$I+}
     descomprime_zip(main_config.dir_base+'extras\win3\win3.zip',main_config.dir_base+'\extras\win3');
     exec_dosbox_extra_config:=' --conf "'+main_config.config_dosbox_x+'" -set cycles=max -set windowresolution='{$IFDEF IS_DEBUG}+'original'{$ELSE}+'800x600'{$ENDIF};
     exec_parametros:=' -set titlebar="'+games_final[ngame].nombre+'" -set showmenu=true -set "quit warning"=false -set autolock=true -set showbasic=false -set fastbioslogo=true -set "disable graphical splash"=true -set startbanner=false -set memsize='+exec_memoria+' -set mididevice=mt32 -set gustype=max -set ultradir=C:\extras\ULTRASND -set disney=true -set mouse_emulation=always ';
     exec_extra:=games_final[ngame].extra_param;
     if form1.checkbox1.Checked then exec_fullscreen:=' -set fullscreen=true '
      else exec_fullscreen:=' -set fullscreen=false ';
     if form1.checkbox14.Checked then exec_sound:=' -set nosound=false '
      else exec_sound:=' -set nosound=true ';
     if games_final[ngame].cdrom<>'' then cd_rom_dir:=' -c "imgmount e: '+main_config.dir_base+exec_dir+'\'+games_final[ngame].cdrom+'"'
      else cd_rom_dir:='';
     temps:='-c "imgmount c: '+main_config.dir_base+'extras\win3\win3.img" -c "mount d: '+main_config.dir_base+exec_dir+'" '+cd_rom_dir+' -c "c:\windows\win d:\'+games_final[ngame].exec+'" ';
     param_string:=temps+exec_dosbox_extra_config+exec_parametros+exec_fullscreen+exec_sound+' '+exec_extra;
     ShellExecute(form1.Handle,'open',pchar(main_config.dir_base+'extras\dosbox_x\dosbox-x.exe'),pchar(param_string),nil,SW_SHOWNORMAL);
  end;
end;
end;

function comprobar_existe(ruta:string;directorio:string):boolean;
var
  salir:boolean;
  posicion:integer;
  extract:string;
begin
if ruta[length(ruta)]='\' then begin
  comprobar_existe:=directoryexists(directorio+ruta);
  exit;
end else begin
  salir:=false;
  while not(salir) do begin
    posicion:=pos('$',ruta);
    if posicion=0 then salir:=true;
    if posicion<>0 then extract:=LeftStr(ruta,posicion-1)
      else extract:=ruta;
    ruta:=RightStr(ruta,length(ruta)-posicion);
    if not(fileexists(directorio+extract)) then begin
      comprobar_existe:=false;
      exit;
    end;
  end;
  end;
comprobar_existe:=true;
end;

procedure config_show;
begin
  form4.labelededit4.Text:=main_config.config_dosbox;
  form4.labelededit5.Text:=main_config.config_dosbox_x;
  form4.labelededit12.Text:=main_config.config_scummvm;
  form4.labelededit20.Text:=main_config.config_dsp;
  form4.labelededit17.Text:=main_config.config_apple;
  form4.labelededit18.Text:=main_config.config_atari800;
  form4.labelededit19.Text:=main_config.config_amiga;
  form4.labelededit22.Text:=main_config.config_atarise;
  //Dirs misc
  form4.labelededit6.Text:=main_config.dir_manual;
  form4.labelededit7.Text:=main_config.dir_mapas;
  form4.labelededit8.Text:=main_config.dir_guias;
  form4.labelededit9.Text:=main_config.dir_zip;
  form4.labelededit10.Text:=main_config.dir_imgs;
  form4.labelededit11.Text:=main_config.dir_mt32;
  case idioma_sel of
    200:form4.radiobutton1.Checked:=true;
    0:form4.radiobutton2.Checked:=true;
    1:form4.radiobutton3.Checked:=true;
    2:form4.radiobutton4.Checked:=true;
    3:form4.radiobutton5.Checked:=true;
    4:form4.radiobutton6.Checked:=true;
  end;
end;

end.
