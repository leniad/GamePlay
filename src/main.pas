unit main;
//{$DEFINE IS_DEBUG}
interface

procedure form_principal_create;
procedure form_principal_close;
procedure form_principal_execute;
procedure pillar_juegos;
procedure ordena_juegos;
procedure mostrar_juegos;
function numero_juego:integer;
procedure abrir_ficheros_separados(nombre_ficheros,ruta_ficheros:string);
function save_game_accept:boolean;
procedure save_game_show;
procedure config_show;
function seleccionar_directorio(inicial:string):string;
procedure guardar_juegos_anadidos;
{$ifdef fpc}
function cambiar_path(cadena:string):string;
function comprobar_si_existe_fichero(directorio:string;var nombre:string;es_zip:boolean):boolean;
{$endif}

type
  tipo_final=record
    nombre:string;
    dir:string;
    exec:string;
    loadfix:boolean;
    params:string;
    exec_pre:string;
    exec_post:string;
    segundo_disco:string;
    ciclos:integer;
    grafica:string;
    extra_param:string;
    mapper:string;
    gus:boolean;
    scumm:boolean;
    cdrom:string;
    memoria:integer;
    setup:string;
    zip:boolean;
    year:string;
    company:string;
    manual:string;
    map:string;
    guia:string;
    image_name:string;
    idioma:integer;
    tipo:integer;
    mensaje:string;
    interno:boolean;
    mal:boolean;
    motor:byte;
  end;
  tipo_config=record
     config_dosbox:string;
     config_dosbox_x:string;
     config_scummvm:string;
     config_atari800:string;
     config_apple:string;
     leer_fijos:boolean;
     mostrar_todos:boolean;
     mostrar_fallan:boolean;
     mostrar_anadidos:boolean;
     motor_msdos:byte;
     dir_base:string;
     dosbox_exe:string;
     dosbox_x_exe:string;
     scumm_exe:string;
     dsp_exe:string;
     apple2_exe:string;
     atari800_exe:string;
     dir_manual:string;
     dir_mapas:string;
     dir_guias:string;
     dir_imgs:string;
     dir_mt32:string;
     dir_zip:string;
     motor:integer;
     apple2_joy:boolean;
  end;

const
  MMSDOS=0;
  MSCUMM=1;
  MAPPLE2=2;
  MATARI8=3;
  MDSP=255;
  MAX_GAMES=2000;
  TEMP_DIR='TEMP';
  VERSION='v0.42β';
  {$IFDEF IS_DEBUG}
  {$ifndef windows}
  debug_base_dir='/home/leniad/abandon/GamePlayVol1/';
  {$else}
  debug_base_dir='c:\datos\abandon\GamePlay_050\';
  {$ENDIF}
  {$endif}

var
  orden_games:array[0..(MAX_GAMES-1)] of integer;
  games_final:array[0..(MAX_GAMES-1)] of tipo_final;
  main_config:tipo_config;
  idioma_sel,juego_editado,total_juegos,total_scumm,total_apple,total_atari800,total_msdos:integer;
  ejecutar_setup,estoy_anadiendo,estoy_ejecutando:boolean;
  dir_dsp:string;

implementation
uses {$IFDEF WINDOWS}windows,shellapi,MMSystem{$ELSE}LCLIntf,process{$ENDIF},principal,
     inifiles,grids,sysutils,forms,idioma_info,games_data,games_info,strutils,dsp_data,
     config,dialogs,save_game{$ifdef fpc},classes,zipper{$else},zip,uitypes{$endif};

const
 RETURN=chr(10);

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
 cambiar_path:=cadena;
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
  salir:boolean;
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
  {$IFDEF WINDOWS}
  ShellExecute(Application.Handle,'open',pchar(fichero_extract),nil,nil, SW_SHOWNORMAL);
  {$ELSE}
  OpenDocument(fichero_extract);
  {$ENDIF}
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
  f,contador,mascara,idioma_masq:integer;
  temp_str:string;

procedure poner_juego_dsp(pos:integer);
begin
  form1.stringgrid1.Cells[0,contador]:=games_final[orden_games[pos]].nombre;
  form1.stringgrid1.Cells[1,contador]:=inttostr(orden_games[pos]);
  contador:=contador+1;
end;

procedure poner_juego_motor(pos:integer);
var
  motor_final:byte;
begin
motor_final:=main_config.motor;
if ((main_config.motor=MSCUMM) and games_final[orden_games[pos]].scumm) then motor_final:=MMSDOS;
if (games_final[orden_games[pos]].motor=motor_final) then begin
  if (((games_final[orden_games[f]].idioma and idioma_masq)<>0) or ((main_config.motor<>MMSDOS) and (main_config.motor<>MSCUMM)) or (form1.CheckBox18.Checked and (games_final[orden_games[f]].idioma=0))) then begin
    if (games_final[orden_games[f]].tipo and mascara)<>0 then begin
      form1.stringgrid1.Cells[0,contador]:=games_final[orden_games[pos]].nombre;
      form1.stringgrid1.Cells[1,contador]:=inttostr(orden_games[pos]);
      contador:=contador+1;
    end;
  end;
end;
end;

begin
if total_juegos=0 then exit;
form1.stringgrid1.RowCount:=total_juegos;
form1.Timer1.Enabled:=false;
contador:=0;
for f:=0 to (total_juegos-1) do begin
  //DSP
  if (games_final[orden_games[f]].motor=MDSP) then begin
    if main_config.motor<>MDSP then continue;
    if main_config.mostrar_todos then poner_juego_dsp(f)
      else begin
              if main_config.mostrar_fallan then begin
                if games_final[orden_games[f]].mal then poner_juego_dsp(f);
              end else if not(games_final[orden_games[f]].mal) then poner_juego_dsp(f);
          end;
  end else begin //Resto
    mascara:=AG*byte(form1.checkbox3.Checked)+ARCADE*byte(form1.checkbox16.Checked)+TRESD*byte(form1.checkbox6.Checked)+SIMULA*byte(form1.checkbox4.Checked)+SPORT*byte(form1.checkbox5.Checked)+PUZ*byte(form1.checkbox7.Checked)+RPG*byte(form1.checkbox8.Checked)+COCHES*byte(form1.checkbox17.Checked);
    if ((mascara=0) or (main_config.motor=MSCUMM)) then mascara:=$ffffff;
    idioma_masq:=ESP*byte(form1.CheckBox9.Checked)+ING*byte(form1.CheckBox12.Checked)+ALE*byte(form1.CheckBox10.Checked)+FRA*byte(form1.CheckBox11.Checked)+ITA*byte(form1.CheckBox13.Checked)+$400*byte(form1.CheckBox18.Checked);
    if ((idioma_masq=0) or (games_final[orden_games[f]].idioma=MUL)) then idioma_masq:=$ffffff;
    if main_config.mostrar_todos then poner_juego_motor(f)
      else begin
        if main_config.mostrar_fallan then begin
          if games_final[orden_games[f]].mal then poner_juego_motor(f)
        end else if not(games_final[orden_games[f]].mal) then poner_juego_motor(f);
      end;
  end;
end;
  case main_config.motor of
    MMSDOS:temp_str:=inttostr(total_msdos);
    MSCUMM:temp_str:=inttostr(total_scumm);
    MAPPLE2:temp_str:=inttostr(total_apple);
    MATARI8:temp_str:=inttostr(total_atari800);
    MDSP:temp_str:=inttostr(GAME_TOTAL_DSP);
  end;
  form1.Label5.Caption:='TOTAL: '+inttostr(contador)+'/'+temp_str;
  //Si no hay nada, lo muestro todo y todos mal
  if contador=0 then form1.stringgrid1.RowCount:=1
    else form1.stringgrid1.RowCount:=contador;
  form1.StringGrid1Click(nil);
  if form1.Visible then form1.StringGrid1.SetFocus;
end;

function search_file_zip(nombre_zip,nombre_file:string):boolean;
var
  f:integer;
{$ifndef fpc}
  ZipFile:TZipFile;
{$else}
  ZipFile:TUnZipper;
  dir,fichero:string;
{$endif}
begin
search_file_zip:=false;
{$ifndef fpc}
  if not(FileExists(nombre_zip)) then exit;
  ZipFile:=TZipFile.Create;
  ZipFile.Open(nombre_zip,zmRead);
  for f:=0 to (ZipFile.FileCount-1) do begin
    if ContainsText(lowercase(ZipFile.FileNames[f]),lowercase(nombre_file)) then begin
      search_file_zip:=true;
      break;
    end;
  end;
  ZipFile.Close;
  ZipFile.Free;
{$else}
  dir:=extractfilepath(nombre_zip);
  fichero:=extractfilename(nombre_zip);
  if not(comprobar_si_existe_fichero(dir,fichero,false)) then exit;
  ZipFile:=TUnZipper.create;
  ZipFile.FileName:=dir+fichero;
  ZipFile.Examine;
  for f:=0 to (ZipFile.Entries.Count-1) do begin
    if ContainsText(lowercase(ZipFile.Entries[f].ArchiveFileName),lowercase(nombre_file)) then begin
      search_file_zip:=true;
      break;
    end;
  end;
  ZipFile.Free;
{$endif}
end;

function comprobar_si_existe_fichero(directorio:string;var nombre:string;es_zip:boolean):boolean;
{$ifndef windows}
var
   search:TSearchRec;
   res:boolean;
   temp_dir,temp_nom:string;
{$endif}
begin
if es_zip then begin
  if nombre='' then begin
      {$ifdef windows}
      comprobar_si_existe_fichero:=fileexists(directorio+'.zip');
      {$else}
      temp_dir:=ExtractFilePath(directorio+'.zip');
      temp_nom:=ExtractFileName(directorio+'.zip');
      res:=false;
      if findfirst(includetrailingpathdelimiter(temp_dir)+'*',faAnyFile,search)=0 then begin
      repeat
        if AnsiCompareText(search.name,temp_nom)=0 then begin
          res:=true;
          break;
        end;
      until FindNext(search)<>0;
      FindClose(search)
      end;
      comprobar_si_existe_fichero:=res;
      {$endif}
  end else comprobar_si_existe_fichero:=search_file_zip(directorio+'.zip',nombre);
end else begin
  {$ifdef windows}
  comprobar_si_existe_fichero:=fileexists(directorio+'\'+nombre);
  {$else}
  res:=false;
  if findfirst(includetrailingpathdelimiter(directorio)+'*',faAnyFile,search)=0 then begin
    repeat
       if AnsiCompareText(search.name,nombre)=0 then begin
         nombre:=search.name;
         res:=true;
         break;
       end;
    until FindNext(search)<>0;
    FindClose(search)
  end;
  comprobar_si_existe_fichero:=res;
  {$endif}
end;
end;

procedure pillar_juegos;
var
  f:integer;
  games_file:textfile;
  temps,juego:string;
  mal:boolean;
begin
//Primero los fijos...
for f:=0 to (GAME_TOTAL-1) do begin
  //Primero compruebo si existe el directorio y el fichero ejecutable
  juego:=GAME_DATA[f].exec;
  mal:=not(comprobar_si_existe_fichero(main_config.dir_base+GAME_DATA[f].dir,juego,false));
  //No existe, pruebo si es un ZIP
  if mal then begin
    mal:=not(comprobar_si_existe_fichero(main_config.dir_zip+GAME_DATA[f].dir,juego,true));
    if not(mal) then games_final[f].zip:=true;
  end;
  games_final[f].mal:=mal;
  games_final[f].nombre:=GAME_DATA[f].nombre;
  games_final[f].dir:=GAME_DATA[f].dir;
  games_final[f].exec:=GAME_DATA[f].exec;
  games_final[f].loadfix:=GAME_DATA[f].loadfix;
  games_final[f].params:=GAME_DATA[f].params;
  games_final[f].exec_pre:=GAME_DATA[f].exec_pre;
  games_final[f].exec_post:=GAME_DATA[f].exec_post;
  games_final[f].segundo_disco:=GAME_DATA[f].segundo_disco;
  games_final[f].ciclos:=GAME_DATA[f].ciclos;
  games_final[f].grafica:=GAME_DATA[f].grafica;
  games_final[f].extra_param:=GAME_DATA[f].extra_param;
  games_final[f].mapper:=GAME_DATA[f].mapper;
  games_final[f].gus:=GAME_DATA[f].gus;
  games_final[f].scumm:=GAME_DATA[f].scumm;
  games_final[f].cdrom:=GAME_DATA[f].cdrom;
  games_final[f].memoria:=GAME_DATA[f].memoria;
  games_final[f].setup:=GAME_DATA[f].setup;
  //games_final[f].zip:=GAME_DATA[f].zip;
  games_final[f].motor:=GAME_DATA[f].motor;
  games_final[f].year:=GAME_INFO[f].year;
  games_final[f].company:=GAME_INFO[f].company;
  games_final[f].manual:=GAME_INFO[f].manual;
  games_final[f].map:=GAME_INFO[f].map;
  games_final[f].guia:=GAME_INFO[f].guia;
  games_final[f].image_name:=GAME_INFO[f].image_name;
  games_final[f].idioma:=GAME_INFO[f].idioma;
  games_final[f].tipo:=GAME_INFO[f].tipo;
  games_final[f].mensaje:=GAME_INFO[f].mensaje;
  games_final[f].interno:=true;
end;
//Juegos DSP
total_juegos:=GAME_TOTAL;
for f:=0 to (GAME_TOTAL_DSP-1) do begin
 games_final[total_juegos].nombre:=GAME_DATA_DSP[f].nombre;
 games_final[total_juegos].dir:=GAME_DATA_DSP[f].dir;
 games_final[total_juegos].company:=GAME_DATA_DSP[f].exec;
 games_final[total_juegos].ciclos:=GAME_DATA_DSP[f].ciclos;
 games_final[total_juegos].year:=GAME_DATA_DSP[f].extra_param;
 games_final[total_juegos].motor:=MDSP;
 temps:=games_final[total_juegos].dir+'.zip';
 if temps<>'.zip' then begin
    games_final[total_juegos].mal:=not(comprobar_si_existe_fichero(dir_dsp+'roms',temps,false));
    games_final[total_juegos].dir:=StringReplace(temps,'.zip','',[]);
 end;
 total_juegos:=total_juegos+1;
end;
//Y ahora los añadidos
{$I-}
if fileexists(main_config.dir_base+'extra_games.info') then begin
  AssignFile(games_file,main_config.dir_base+'extra_games.info');
  reset(games_file);
  while not(eof(games_file)) do begin
    Readln(games_file,juego);
    games_final[total_juegos].nombre:=sacar_datos(juego);
    games_final[total_juegos].dir:=sacar_datos(juego);
    games_final[total_juegos].exec:=sacar_datos(juego);
    games_final[total_juegos].params:=sacar_datos(juego);
    games_final[total_juegos].exec_pre:=sacar_datos(juego);
    games_final[total_juegos].exec_post:=sacar_datos(juego);
    games_final[total_juegos].segundo_disco:=sacar_datos(juego);
    games_final[total_juegos].ciclos:=sacar_numero(sacar_datos(juego));
    games_final[total_juegos].grafica:=sacar_datos(juego);
    games_final[total_juegos].extra_param:=sacar_datos(juego);
    games_final[total_juegos].mapper:=sacar_datos(juego);
    games_final[total_juegos].gus:=sacar_numero(sacar_datos(juego))<>0;
    games_final[total_juegos].scumm:=sacar_numero(sacar_datos(juego))<>0;
    games_final[total_juegos].year:=sacar_datos(juego);
    games_final[total_juegos].company:=sacar_datos(juego);
    games_final[total_juegos].manual:=sacar_datos(juego);
    games_final[total_juegos].map:=sacar_datos(juego);
    games_final[total_juegos].guia:=sacar_datos(juego);
    games_final[total_juegos].image_name:=sacar_datos(juego);
    games_final[total_juegos].idioma:=sacar_numero(sacar_datos(juego));
    games_final[total_juegos].tipo:=sacar_numero(sacar_datos(juego));
    games_final[total_juegos].cdrom:=sacar_datos(juego);
    games_final[total_juegos].memoria:=sacar_numero(sacar_datos(juego));
    games_final[total_juegos].setup:=sacar_datos(juego);
    games_final[total_juegos].zip:=sacar_numero(sacar_datos(juego))<>0; //Lo dejo para no romper la compatibilidad
    games_final[total_juegos].motor:=sacar_numero(sacar_datos(juego));
    games_final[total_juegos].loadfix:=sacar_numero(sacar_datos(juego))<>0;
    games_final[total_juegos].interno:=false;
    //Primero compruebo si existe el directorio y el fichero ejecutable
    juego:=games_final[total_juegos].exec;
    mal:=not(comprobar_si_existe_fichero(main_config.dir_base+games_final[total_juegos].dir,juego,false));
    //No existe, pruebo si es un ZIP
    if mal then begin
      mal:=not(comprobar_si_existe_fichero(main_config.dir_zip+games_final[total_juegos].dir,juego,true));
      if not(mal) then games_final[total_juegos].zip:=true;
    end;
    games_final[total_juegos].mal:=mal;
    total_juegos:=total_juegos+1;
end;
closefile(games_file);
end;
{AssignFile(games_file,'d:\abandon\listado.txt');
ReWrite(games_file);
for f:=0 to (total_juegos-1) do if not(games_final[total_juegos].solo_dsp) then writeLn(games_file,games_final[f].nombre);
closefile(games_file);}
{$I+}
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
total_scumm:=0;
total_msdos:=0;
total_apple:=0;
total_atari800:=0;
for f:=0 to (total_juegos-1) do begin
  case games_final[f].motor of
    0:begin
        total_msdos:=total_msdos+1;
        if games_final[f].scumm then total_scumm:=total_scumm+1;
      end;
    1:total_scumm:=total_scumm+1;
    2:total_apple:=total_apple+1;
    3:total_atari800:=total_atari800+1;
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
    MDSP:fichero:=dir_dsp+'dsp.ini';
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
    //Filtros idioma
    form1.checkbox18.Checked:=(fich_ini.readinteger('filtros','gen',1)<>0);
    form1.checkbox9.Checked:=(fich_ini.readinteger('filtros','esp',1)<>0);
    form1.checkbox12.Checked:=(fich_ini.readinteger('filtros','ing',1)<>0);
    form1.checkbox10.Checked:=(fich_ini.readinteger('filtros','ale',1)<>0);
    form1.checkbox11.Checked:=(fich_ini.readinteger('filtros','fra',1)<>0);
    form1.checkbox13.Checked:=(fich_ini.readinteger('filtros','ita',1)<>0);
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
    main_config.config_atari800:=fich_ini.ReadString('opciones','config_atari800',main_config.dir_base+'extras\config\altirra.ini');
    main_config.config_apple:=fich_ini.ReadString('opciones','config_apple',main_config.dir_base+'extras\config\apple2.ini');
    main_config.leer_fijos:=(fich_ini.readinteger('opciones','leer_fijos',0)<>0);
    main_config.mostrar_todos:=(fich_ini.readinteger('opciones','mostrar_todos',0)<>0);
    main_config.mostrar_fallan:=(fich_ini.readinteger('opciones','mostrar_fallan',0)<>0);
    main_config.mostrar_anadidos:=(fich_ini.readinteger('opciones','mostrar_anadidos',0)<>0);
    main_config.dosbox_exe:=fich_ini.ReadString('opciones','dosbox_exe','');
    main_config.dosbox_x_exe:=fich_ini.ReadString('opciones','dosbox_x_exe','');
    main_config.motor_msdos:=fich_ini.ReadInteger('opciones','motor_msdos',1);
    main_config.dsp_exe:=fich_ini.ReadString('opciones','dsp_exe',main_config.dir_base+'dsp\dsp.exe');
    main_config.apple2_exe:=fich_ini.ReadString('opciones','apple2_exe',main_config.dir_base+'extras\apple2\AppleWin.exe');
    main_config.apple2_joy:=(fich_ini.readinteger('opciones','apple2_joy',0)<>0);
    main_config.atari800_exe:=fich_ini.ReadString('opciones','atari800_exe',main_config.dir_base+'extras\atari800\altirra.exe');
    main_config.scumm_exe:=fich_ini.ReadString('opciones','scumm_exe',main_config.dir_base+'extras\scummvm\scummvm.exe');
    main_config.dir_manual:=fich_ini.ReadString('opciones','dir_manual',main_config.dir_base+'extras\manual\');
    main_config.dir_mapas:=fich_ini.ReadString('opciones','dir_maps',main_config.dir_base+'extras\maps\');
    main_config.dir_guias:=fich_ini.ReadString('opciones','dir_guias',main_config.dir_base+'extras\walk\');
    main_config.dir_imgs:=fich_ini.ReadString('opciones','dir_imgs',main_config.dir_base+'extras\imgs\');
    main_config.dir_mt32:=fich_ini.ReadString('opciones','dir_mt32',main_config.dir_base+'extras\mt32');
    main_config.dir_zip:=fich_ini.ReadString('opciones','dir_zips',main_config.dir_base+'zip_games\');
    fich_ini.Free;
  end else begin
    main_config.motor:=MMSDOS;
    form1.radiobutton1.Checked:=true;
    form1.groupbox8.visible:=true;
    idioma_sel:=200;
    main_config.leer_fijos:=false;
    main_config.mostrar_todos:=false;
    main_config.mostrar_fallan:=false;
    main_config.mostrar_anadidos:=false;
    {$ifdef windows}
    main_config.dosbox_exe:=main_config.dir_base+'extras\dosbox\dosbox.exe';
    main_config.dosbox_x_exe:=main_config.dir_base+'extras\dosbox_x\dosbox-x.exe';
    main_config.scumm_exe:=main_config.dir_base+'extras\scummvm\scummvm.exe';
    main_config.dsp_exe:=main_config.dir_base+'dsp\dsp.exe';
    main_config.apple2_exe:=main_config.dir_base+'extras\apple2\AppleWin.exe';
    main_config.atari800_exe:=main_config.dir_base+'extras\atari800\altirra.exe';
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
    main_config.config_atari800:=main_config.dir_base+'extras\config\altirra.ini';
    main_config.config_apple:=main_config.dir_base+'extras\config\apple2.ini';
    main_config.apple2_joy:=false;
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
  main_config.config_apple:=cambiar_path(main_config.config_apple);
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
  dir_dsp:=extractfilepath(main_config.dsp_exe);
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
  //Meto los juegos
  pillar_juegos;
  //Los ordeno...
  ordena_juegos;
  //Lo pongo bonito y lo muestro todo
  form1.stringgrid1.ColWidths[0]:=form1.stringgrid1.Width-30;
  {$ifndef fpc}
  form1.stringgrid1.ColWidths[1]:=-1;
  {$else}
  form1.stringgrid1.ColWidths[1]:=0;
  {$endif}
  mostrar_juegos;
  //Selecciono el primero
  form1.stringgrid1.row:=0;
  if main_config.motor_msdos=0 then form1.radiobutton7.Checked:=true
    else form1.RadioButton8.Checked:=true;
  estoy_ejecutando:=false;
  ejecutar_setup:=false;
end;

procedure guardar_juegos_anadidos;
var
  games_file:textfile;
  f:integer;
begin
if DirectoryExists(main_config.dir_base) then begin
  //grabo los juegos
  {$I-}
  AssignFile(games_file,main_config.dir_base+'extra_games.info');
  ReWrite(games_file);
  for f:=0 to (total_juegos-1) do begin
    if (not(games_final[f].interno) and (games_final[f].motor<>MDSP)) then begin
      write(games_file,games_final[f].nombre+';');
      write(games_file,games_final[f].dir+';');
      write(games_file,games_final[f].exec+';');
      write(games_file,games_final[f].params+';');
      write(games_file,games_final[f].exec_pre+';');
      write(games_file,games_final[f].exec_post+';');
      write(games_file,games_final[f].segundo_disco+';');
      write(games_file,inttostr(games_final[f].ciclos)+';');
      write(games_file,games_final[f].grafica+';');
      write(games_file,games_final[f].extra_param+';');
      write(games_file,games_final[f].mapper+';');
      write(games_file,inttostr(byte(games_final[f].gus))+';');
      write(games_file,inttostr(byte(games_final[f].scumm))+';');
      write(games_file,games_final[f].year+';');
      write(games_file,games_final[f].company+';');
      write(games_file,games_final[f].manual+';');
      write(games_file,games_final[f].map+';');
      write(games_file,games_final[f].guia+';');
      write(games_file,games_final[f].image_name+';');
      write(games_file,inttostr(games_final[f].idioma)+';');
      write(games_file,inttostr(games_final[f].tipo)+';');
      write(games_file,games_final[f].cdrom+';');
      write(games_file,inttostr(games_final[f].memoria)+';');
      write(games_file,games_final[f].setup+';');
      write(games_file,inttostr(byte(games_final[f].zip))+';');
      write(games_file,inttostr(games_final[f].motor));
    end;
  end;
  CloseFile(games_file);
  {$I+}
end;
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
delete_dir('DELUXE');
if DirectoryExists(main_config.dir_base) then begin
  {$I-}
  //grabo los juegos
  guardar_juegos_anadidos;
  //grabo las opciones
  fich_ini:=Tinifile.Create(main_config.dir_base+'gameplay.ini');
  //Filtros idioma
  fich_ini.WriteInteger('filtros','esp',byte(form1.checkbox9.Checked));
  fich_ini.WriteInteger('filtros','ing',byte(form1.checkbox12.Checked));
  fich_ini.WriteInteger('filtros','ale',byte(form1.checkbox10.Checked));
  fich_ini.WriteInteger('filtros','fra',byte(form1.checkbox11.Checked));
  fich_ini.WriteInteger('filtros','ita',byte(form1.checkbox13.Checked));
  fich_ini.WriteInteger('filtros','gen',byte(form1.checkbox18.Checked));
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
  fich_ini.WriteString('opciones','config_atari800',main_config.config_atari800);
  fich_ini.WriteString('opciones','config_apple',main_config.config_apple);
  fich_ini.WriteInteger('opciones','leer_fijos',byte(main_config.leer_fijos));
  fich_ini.WriteInteger('opciones','mostrar_todos',byte(main_config.mostrar_todos));
  fich_ini.WriteInteger('opciones','mostrar_fallan',byte(main_config.mostrar_fallan));
  fich_ini.WriteInteger('opciones','mostrar_anadidos',byte(main_config.mostrar_anadidos));
  fich_ini.WriteString('opciones','dosbox_exe',main_config.dosbox_exe);
  fich_ini.WriteString('opciones','dosbox_x_exe',main_config.dosbox_x_exe);
  fich_ini.WriteString('opciones','scumm_exe',main_config.scumm_exe);
  fich_ini.WriteString('opciones','dsp_exe',main_config.dsp_exe);
  fich_ini.WriteString('opciones','apple2_exe',main_config.apple2_exe);
  fich_ini.WriteInteger('opciones','apple2_joy',byte(main_config.apple2_joy));
  fich_ini.WriteString('opciones','atari800_exe',main_config.atari800_exe);
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

function extract_zip(dir,nombre:string):boolean;
var
{$ifndef fpc}
  ZipFile:TZipFile;
  nombre_zip:string;
{$else}
  ZipFile:TUnZipper;
  fichero:string;
{$endif}
begin
  extract_zip:=false;
{$ifndef fpc}
  nombre_zip:=dir+'\'+nombre+'.zip';
  if not(FileExists(nombre_zip)) then exit;
  ZipFile:=TZipFile.Create;
  if not(Zipfile.IsValid(nombre_zip)) then exit;
  ZipFile.Open(nombre_zip,zmRead);
  ZipFIle.ExtractAll(main_config.dir_base+TEMP_DIR+'\'+nombre);
  ZipFile.Close;
  ZipFile.Free;
{$else}
  fichero:=nombre+'.zip';
  if not(comprobar_si_existe_fichero(dir,fichero,false)) then exit;
  ZipFile:=TUnZipper.create;
  ZipFile.FileName:=dir+fichero;
  ZipFile.OutputPath:=main_config.dir_base+TEMP_DIR+'/'+nombre;
  ZipFile.Examine;
  Zipfile.UnZipAllFiles;
  ZipFile.Free;
{$endif}
extract_zip:=true;
end;

procedure form_principal_execute;
var
  cd_rom_dir,exec_dir,exec_base,exec_memoria,exec_parametros,exec_dosbox_extra_config,temp_str,temp_str2,temp_disco,exec_mapper,exec_sd,exec_roland,exec_extra,exec_params,exec_gus,exec_sound,exec_c_param,exec_string,param_string,exec_ciclos,exec_video,exec_fullscreen,exec_pre:string;
  ngame:integer;
  play_file:textfile;
  {$IFNDEF WINDOWS}
  process:tprocess;
  {$ENDIF}
begin
ngame:=numero_juego;
if ngame=-1 then exit;
if games_final[ngame].mal then begin
  MessageDlg(list_error[7],mtError,[mbOk],0);
  exit;
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
    ShellExecute(form1.Handle,'open',pchar(main_config.dsp_exe),nil,nil,SW_SHOWNORMAL);
    {$else}
    process:=tprocess.create(nil);
    process.commandline:='"'+main_config.dsp_exe+'"';
    process.execute;
    process.free;
    {$ENDIF}
    exit;
end;
//Si es un ZIP lo descomprimo!
if games_final[ngame].zip then begin
  delete_dir(TEMP_DIR+'\'+games_final[ngame].dir);
  CreateDir(cambiar_path(main_config.dir_base+TEMP_DIR+'\'+games_final[ngame].dir));
  extract_zip(main_config.dir_zip,games_final[ngame].dir);
  exec_dir:=cambiar_path(TEMP_DIR+'\'+games_final[ngame].dir);
end else exec_dir:=games_final[ngame].dir;
//Mostrar mensaje de ayuda
if (form1.checkbox2.Checked and (main_config.motor<>MSCUMM)) then begin
  if games_final[ngame].mensaje<>'' then begin
    estoy_ejecutando:=true;
    temp_str:=games_final[ngame].mensaje;
    if main_config.motor_msdos=0 then temp_disco:='CONTROL+F4'
      else temp_disco:={$ifdef windows}'F11+O';{$else}'F12+O';{$endif}
    if ContainsText(temp_str,'[KEY_DISK]') then temp_str:=StringReplace(temp_str,'[KEY_DISK]',temp_disco,[]);
    if ContainsText(temp_str,'[RET]') then temp_str:=StringReplace(temp_str,'[RET]',RETURN,[rfReplaceAll]);
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
    ShellExecute(form1.Handle,'open',pchar(main_config.apple2_exe),pchar(temp_str),nil,SW_SHOWNORMAL);
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
    ShellExecute(form1.Handle,'open',pchar(main_config.atari800_exe),pchar(temp_str),nil,SW_SHOWNORMAL);
  end;
  MSCUMM:begin   //ScummVM
    if form1.checkbox1.Checked then exec_fullscreen:='--fullscreen'
      else exec_fullscreen:='';
    if form1.checkbox14.Checked then exec_sound:='false'
      else exec_sound:='true';
    cambiar_ini(MSCUMM,'scummvm','mute',exec_sound);
    temp_str:='--language=en';
    case games_final[ngame].idioma of
      MUL:case idioma_ind of
            0:temp_str:='--language=es';
            2:temp_str:='--language=de';
            3:temp_str:='--language=fr';
            4:temp_str:='--language=it';
          end;
      ESP:temp_str:='--language=es';
      //ING:temp_str:='--language=en';
      ALE:temp_str:='--language=de';
      FRA:temp_str:='--language=fr';
      ITA:temp_str:='--language=it';
    end;
    {$ifdef windows}
    exec_parametros:='--no-console ';
    {$else}
    exec_parametros:='';
    {$endif}
    param_string:=exec_parametros+'--config="'+main_config.config_scummvm+'" --path="'+main_config.dir_base+exec_dir+'" --auto-detect  --native-mt32 '+exec_fullscreen+' '+temp_str;
    {$ifdef windows}
    ShellExecute(form1.Handle,'open',pchar(main_config.scumm_exe),pchar(param_string),nil,SW_SHOWNORMAL);
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
          exec_string:=main_config.dosbox_exe;
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
          exec_string:=main_config.dosbox_x_exe;
          exec_dosbox_extra_config:=' --conf "'+main_config.config_dosbox_x+'" -set output=direct3d -set windowresolution='{$IFDEF IS_DEBUG}+'original'{$ELSE}+'800x600'{$ENDIF};
          exec_parametros:='-set titlebar="'+games_final[ngame].nombre+'" -set showmenu=true -set "quit warning"=false -set autolock=true -set showbasic=false -set fastbioslogo=true -set "disable graphical splash"=true -set startbanner=false -set memsize='+exec_memoria+' -set mididevice=mt32 -set gustype=max -set ultradir=C:\extras\ULTRASND -set disney=true -set mouse_emulation=always';
          exec_roland:='-set mt32.romdir="'+main_config.dir_mt32+'"';
          exec_ciclos:='-set cycles=';
        end;
    end;
    //Velocidad CPU
    if games_final[ngame].ciclos=-1 then exec_ciclos:=exec_ciclos+'auto'
      else if games_final[ngame].ciclos=1 then exec_ciclos:=exec_ciclos+'max'
        else if games_final[ngame].ciclos<>0 then exec_ciclos:=exec_ciclos+inttostr(games_final[ngame].ciclos)
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
    if games_final[ngame].exec_pre<>'' then begin
        exec_pre:=games_final[ngame].exec_pre;
        //Si es un ZIP la carpeta base es TEMP
        if games_final[ngame].zip then begin
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
    if ejecutar_setup then WriteLn(play_file,games_final[ngame].setup);
    //Añadir el ejecutable
    exec_params:=games_final[ngame].params;
    if ContainsText(games_final[ngame].exec,'.bat') then WriteLn(play_file,'call '+games_final[ngame].exec+' '+exec_params)
      else if games_final[ngame].loadfix then WriteLn(play_file,'loadfix '+games_final[ngame].exec+' '+exec_params)
            else WriteLn(play_file,games_final[ngame].exec+' '+exec_params);
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
    if games_final[ngame].grafica<>'' then begin
      exec_video:='-machine '+games_final[ngame].grafica;
      exec_memoria:='1';
      //Si es Dosbox, cambio el parametro
      if ((main_config.motor_msdos=0) and ContainsText(exec_video,'cga_composite')) then exec_video:='-machine cga -set composite=true';
    end;
    if form1.checkbox1.Checked then exec_fullscreen:='-set fullscreen=true'
      else exec_fullscreen:='-set fullscreen=false';
    //Mirar si tiene mapper
    if games_final[ngame].mapper<>'' then exec_mapper:='-set mapperfile="'+main_config.dir_base+'extras\mappers\'+games_final[ngame].mapper +'"'
      else exec_mapper:='';
    //Comprobar si es un PC-Booter (tiene la extension .img) o un cartucho PCJR
    if ((ContainsText(games_final[ngame].exec,'.img') or ContainsText(games_final[ngame].exec,'.jrc')) and not(ContainsText(games_final[ngame].exec_pre,'imgmount'))) then begin
      if games_final[ngame].segundo_disco<>'' then exec_sd:=' c:\'+exec_dir+'\'+games_final[ngame].segundo_disco
        else exec_sd:='';
      exec_c_param:='-c "boot c:\'+exec_dir+'\'+games_final[ngame].exec+exec_sd+'"';
      exec_memoria:='1';
    end else begin
      exec_c_param:='-c c:\TEMP\start.bat'
    end;
    //Tengo que quitar la barra del final o DosBox se marea...
    exec_base:=system.copy(main_config.dir_base,1,length(main_config.dir_base)-1);
    //Lo monto todo y ejecuto
    param_string:='"'+exec_base+'" '+cambiar_path(exec_dosbox_extra_config)+' --conf "'+cambiar_path(main_config.dir_base+TEMP_DIR+'\gameplay.conf"')+' --noprimaryconf '+exec_mapper+' '+exec_roland+' '+exec_video+' '+exec_extra+' '+exec_sound+' '+exec_gus+' '+exec_fullscreen+' '+exec_ciclos+' '+exec_c_param+' '+exec_parametros;
    {$IFDEF WINDOWS}
    ShellExecute(form1.Handle,'open',pchar(exec_string),pchar(param_string),nil,SW_SHOWNORMAL);
    {$ELSE}
    process:=tprocess.create(nil);
    process.commandline:='"'+exec_string+'" '+param_string;
    process.execute;
    process.free;
    {$ENDIF}
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

function save_game_accept:boolean;
var
  temps,directorio_final:string;
  es_zip:boolean;
begin
  save_game_accept:=false;
  if containstext(lowercase(form2.labelededit9.Text),'.zip') then es_zip:=true
    else es_zip:=false;
  games_final[juego_editado].nombre:=form2.labelededit1.Text;
  temps:=form2.labelededit9.Text;
  if es_zip then temps:=stringreplace(temps,'.zip','',[rfIgnoreCase]);
  games_final[juego_editado].dir:=temps;
  games_final[juego_editado].exec:=form2.labelededit5.Text;
  games_final[juego_editado].loadfix:=form2.CheckBox3.Checked;
  games_final[juego_editado].params:=form2.labelededit6.Text;
  games_final[juego_editado].exec_pre:=form2.labelededit7.Text;
  games_final[juego_editado].exec_post:=form2.labelededit8.Text;
  games_final[juego_editado].segundo_disco:=form2.labelededit10.Text;
  games_final[juego_editado].ciclos:=strtoint(form2.labelededit11.Text);
  if games_final[juego_editado].ciclos=0 then games_final[juego_editado].ciclos:=-1;
  if games_final[juego_editado].ciclos=12000 then games_final[juego_editado].ciclos:=0;
  games_final[juego_editado].memoria:=strtoint(form2.labelededit12.Text);
  case form2.combobox1.ItemIndex of
    0:games_final[juego_editado].grafica:='';
    1:games_final[juego_editado].grafica:='cga';
    2:games_final[juego_editado].grafica:='tandy';
    3:games_final[juego_editado].grafica:='pcjr';
    4:games_final[juego_editado].grafica:='cga_composite';
    5:games_final[juego_editado].grafica:='hercules';
  end;
  games_final[juego_editado].extra_param:=form2.labelededit14.Text;
  games_final[juego_editado].mapper:=form2.labelededit13.Text;
  games_final[juego_editado].gus:=form2.checkbox1.Checked;
  games_final[juego_editado].scumm:=form2.checkbox2.Checked;
  games_final[juego_editado].year:=form2.labelededit2.Text;
  games_final[juego_editado].company:=form2.labelededit3.Text;
  games_final[juego_editado].mensaje:=form2.labelededit15.Text;
  games_final[juego_editado].cdrom:=form2.labelededit19.Text;
  games_final[juego_editado].setup:=form2.labelededit20.Text;
  if form2.labelededit16.text<>'' then begin
    if comprobar_existe(form2.labelededit16.text,main_config.dir_manual) then games_final[juego_editado].manual:=form2.labelededit16.Text
      else begin
        MessageDlg(list_error[0],mtError,[mbOk],0);
        exit;
      end;
  end else games_final[juego_editado].manual:='';
  if form2.labelededit17.text<>'' then begin
    if comprobar_existe(form2.labelededit17.text,main_config.dir_mapas) then games_final[juego_editado].map:=form2.labelededit17.Text
      else begin
        MessageDlg(list_error[1],mtError,[mbOk],0);
        exit;
      end;
  end else games_final[juego_editado].map:='';
  if form2.labelededit18.text<>'' then begin
    if comprobar_existe(form2.labelededit18.text,main_config.dir_guias) then games_final[juego_editado].guia:=form2.labelededit18.Text
      else begin
        MessageDlg(list_error[2],mtError,[mbOk],0);
        exit;
      end;
  end else games_final[juego_editado].guia:='';
  games_final[juego_editado].image_name:=form2.labelededit4.Text;
  games_final[juego_editado].idioma:=form2.combobox4.ItemIndex;
  case form2.combobox5.ItemIndex of
    0:games_final[juego_editado].tipo:=1;
    1:games_final[juego_editado].tipo:=2;
    2:games_final[juego_editado].tipo:=4;
    3:games_final[juego_editado].tipo:=8;
    4:games_final[juego_editado].tipo:=$10;
    5:games_final[juego_editado].tipo:=$20;
    6:games_final[juego_editado].tipo:=$40;
    7:games_final[juego_editado].tipo:=$80;
    8:games_final[juego_editado].tipo:=$200;
  end;
  if es_zip then directorio_final:=main_config.dir_zip+games_final[juego_editado].dir
    else directorio_final:=main_config.dir_base+games_final[juego_editado].dir;
  if ((games_final[juego_editado].cdrom<>'') and (not(comprobar_si_existe_fichero(directorio_final,games_final[juego_editado].cdrom,es_zip)))) then begin
    MessageDlg(list_error[3],mtError,[mbOk],0);
    exit;
  end;
  if ((games_final[juego_editado].setup<>'') and (not(comprobar_si_existe_fichero(directorio_final,games_final[juego_editado].setup,es_zip)))) then begin
    MessageDlg(list_error[4],mtError,[mbOk],0);
    exit;
  end;
  //Solo ScummVM
  if form2.CheckBox4.Checked then begin
    if es_zip then begin
      if not(comprobar_si_existe_fichero(directorio_final,games_final[juego_editado].exec,true)) then begin
        MessageDlg(list_error[5],mtError,[mbOk],0);
        exit;
      end;
    end else begin
      if not(directoryexists(directorio_final)) then begin
        MessageDlg(list_error[5],mtError,[mbOk],0);
        exit;
      end;
    end;
    if form2.checkbox4.Checked then games_final[juego_editado].motor:=1;
    games_final[juego_editado].exec:='';
  end else begin //Resto
    if not(comprobar_si_existe_fichero(directorio_final,games_final[juego_editado].exec,es_zip)) then begin
      MessageDlg(list_error[5],mtError,[mbOk],0);
      exit;
    end;
  end;
  games_final[juego_editado].zip:=es_zip;
  games_final[juego_editado].mal:=false;
  if estoy_anadiendo then begin
    games_final[juego_editado].interno:=false;
    total_juegos:=total_juegos+1;
  end;
  guardar_juegos_anadidos;
  save_game_accept:=true;
end;

procedure save_game_show;
var
  r:trect;
  image_string:string;
begin
datos_cancel:=games_final[juego_editado];
if not(estoy_anadiendo) then begin
  form2.labelededit1.Text:=games_final[juego_editado].nombre;
  if games_final[juego_editado].zip then form2.labelededit9.Text:=games_final[juego_editado].dir+'.zip'
    else form2.labelededit9.Text:=games_final[juego_editado].dir;
  form2.labelededit5.Text:=games_final[juego_editado].exec;
  form2.CheckBox3.Checked:=games_final[juego_editado].loadfix;
  if ContainsText(form2.labelededit5.Text,'.img') then form2.labelededit10.Enabled:=true
    else form2.labelededit10.Enabled:=false;
  form2.labelededit6.Text:=games_final[juego_editado].params;
  form2.labelededit7.Text:=games_final[juego_editado].exec_pre;
  form2.labelededit8.Text:=games_final[juego_editado].exec_post;
  form2.labelededit10.Text:=games_final[juego_editado].segundo_disco;
  if games_final[juego_editado].ciclos=-1 then form2.labelededit11.Text:='0'
    else if games_final[juego_editado].ciclos=0 then form2.labelededit11.Text:='12000'
      else form2.labelededit11.Text:=inttostr(games_final[juego_editado].ciclos);
  if games_final[juego_editado].grafica='cga' then form2.combobox1.ItemIndex:=1
    else if games_final[juego_editado].grafica='tandy' then form2.combobox1.ItemIndex:=2
      else if games_final[juego_editado].grafica='pcjr' then form2.combobox1.ItemIndex:=3
        else if games_final[juego_editado].grafica='cga_composite' then form2.combobox1.ItemIndex:=4
          else if games_final[juego_editado].grafica='hercules' then form2.combobox1.ItemIndex:=5
            else form2.combobox1.ItemIndex:=0;
  form2.labelededit14.Text:=games_final[juego_editado].extra_param;
  form2.labelededit13.Text:=games_final[juego_editado].mapper;
  form2.checkbox1.Checked:=games_final[juego_editado].gus;
  form2.checkbox2.Checked:=games_final[juego_editado].scumm;
  form2.CheckBox4.Checked:=(games_final[juego_editado].motor=1);
  form2.checkbox4click(nil);
  form2.labelededit2.Text:=games_final[juego_editado].year;
  form2.labelededit3.Text:=games_final[juego_editado].company;
  form2.labelededit15.Text:=games_final[juego_editado].mensaje;
  form2.labelededit16.Text:=games_final[juego_editado].manual;
  form2.labelededit17.Text:=games_final[juego_editado].map;
  form2.labelededit18.Text:=games_final[juego_editado].guia;
  form2.labelededit20.Text:=games_final[juego_editado].setup;
  form2.labelededit4.Text:=games_final[juego_editado].image_name;
  form2.labelededit19.Text:=games_final[juego_editado].cdrom;
  if games_final[juego_editado].memoria=0 then form2.labelededit12.Text:='16'
    else form2.labelededit12.Text:=inttostr(games_final[juego_editado].memoria);
  form2.combobox4.ItemIndex:=games_final[juego_editado].idioma;
  if (games_final[juego_editado].tipo and 2)<>0 then form2.combobox5.ItemIndex:=1
    else if (games_final[juego_editado].tipo and 4)<>0 then form2.combobox5.ItemIndex:=2
      else if (games_final[juego_editado].tipo and 8)<>0 then form2.combobox5.ItemIndex:=3
        else if (games_final[juego_editado].tipo and $10)<>0 then form2.combobox5.ItemIndex:=4
          else if (games_final[juego_editado].tipo and $20)<>0 then form2.combobox5.ItemIndex:=5
            else if (games_final[juego_editado].tipo and $40)<>0 then form2.combobox5.ItemIndex:=6
              else if (games_final[juego_editado].tipo and $80)<>0 then form2.combobox5.ItemIndex:=7
                else if (games_final[juego_editado].tipo and $200)<>0 then form2.combobox5.ItemIndex:=8
                  else form2.combobox5.ItemIndex:=0;
  form2.button3.visible:=true;
end else begin
  form2.labelededit1.Text:='';
  form2.labelededit2.Text:='';
  form2.labelededit3.Text:='';
  form2.labelededit4.Text:='';
  form2.labelededit5.Text:='';
  form2.labelededit6.Text:='';
  form2.labelededit7.Text:='';
  form2.labelededit11.Text:='3000';
  form2.labelededit12.Text:='1';
  form2.combobox1.ItemIndex:=0;
  form2.labelededit8.Text:='';
  form2.labelededit9.Text:='';
  form2.checkbox1.Checked:=false;
  form2.checkbox2.Checked:=false;
  form2.CheckBox4.Checked:=false;
  form2.labelededit10.Text:='';
  form2.labelededit13.Text:='';
  form2.labelededit14.Text:='';
  form2.labelededit15.Text:='';
  form2.labelededit16.Text:='';
  form2.labelededit17.Text:='';
  form2.labelededit20.Text:='';
  form2.combobox4.ItemIndex:=0;
  form2.combobox5.ItemIndex:=1;
  form2.labelededit10.Enabled:=false;
  form2.button3.visible:=false;
end;
image_string:=main_config.dir_imgs+form2.labelededit4.text+'_000.png';
if FileExists(image_string) then begin
    form2.Image1.Picture.LoadFromFile(image_string);
    image_num:=0;
    form2.timer1.Enabled:=true;
end else begin
    r.top:=0;
    r.Left:=form2.image1.width;
    r.Right:=0;
    r.Bottom:=form2.image1.height;
    form2.image1.Picture:=nil;
    form2.image1.Canvas.Brush.Color:=0;
    form2.image1.Canvas.FillRect(r);
end;
end;

procedure config_show;
begin
  form4.labelededit4.Text:=main_config.config_dosbox;
  form4.labelededit5.Text:=main_config.config_dosbox_x;
  form4.labelededit12.Text:=main_config.config_scummvm;
  form4.labelededit1.Text:=main_config.dosbox_exe;
  form4.labelededit2.Text:=main_config.dosbox_x_exe;
  form4.labelededit3.Text:=main_config.scumm_exe;
  form4.labelededit13.Text:=main_config.dsp_exe;
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
  form4.checkbox10.Checked:=main_config.leer_fijos;
  form4.checkbox11.Checked:=main_config.mostrar_todos;
  form4.checkbox1.Checked:=main_config.mostrar_fallan;
  form4.checkbox2.Checked:=main_config.mostrar_anadidos;
end;

end.
