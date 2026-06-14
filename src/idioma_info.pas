unit idioma_info;

interface

procedure seleccionar_idioma;
procedure cambiar_idioma_principal;
procedure cambiar_idioma_avanzado;
procedure cambiar_idioma_descarga;

var
  idioma_ind:byte;
  list_error:array[0..9] of string;
  list_zip:array[0..3] of string;
  list_descarga:array[0..7] of string;

implementation
uses principal,mensajes,games_download,config,sysutils,main{$ifdef WINDOWS},windows{$endif}{$ifdef darwin},MacOSAll{$endif};

type
  tipo_idioma=record
    principal:array[0..27] of string;
    grabar:array[0..35] of string;
    error:array[0..9] of string;
    avanzado:array[0..12] of string;
    descarga:array[0..8] of string;
  end;

const
  MAX_IDIOMAS=5-1;
  FULL_RET=chr(10)+chr(13);
  idioma_fijo:array[0..MAX_IDIOMAS] of tipo_idioma=(
  //Castellano
  (principal:('Filtros del Juego','Idioma','Tipo','Español','Inglés','Alemán','Francés','Italiano','Aventura Gráfica','Simulador','Deportes','Carreras','Opciones Generales','Sistema','Pantalla Completa','Sonido','Mensaje info/ayuda','Opciones Avanzadas','Añadir Juego','Editar/Borrar Juego','Buscar Juego','Imágenes del Juego','Información del Juego','Compañía:','Año:','Acerca de','Motor MS-DOS','Genérico');
  grabar:('Añadir Juego','Juego','Nombre Completo','Año Publicación','Compañía','Nombre de la Imagen','Ejecutable','Directorio/ZIP','Fichero Ejecutable','Parámetros','Imagen Segundo Disco','Ejecutar ANTES','Ejecutar DESPUES','Programa de Instalación','Ciclos CPU','Tipo Ordenador','Memoria RAM','Activar GUS','Compatible con ScummVM','Fichero Mapa Teclado','Mensaje de información/ayuda','Parámetros Extra DOSBox','Información Extra','Manual(es)','Mapa(s)','Guia(s)','Idioma','Tipo','ACEPTAR','CANCELAR','BORRAR','Fichero ZIP','Nombre ZIP','Fichero comprimido en ZIP','Sólo funciona con ScummVM','Mostar en la lista principal');
  avanzado:('Abrir','Configuración Avanzada','Ficheros Ejecutables','Ficheros de Configuración','Directorios Principales','Imagenes','Leer valores de los juegos fijos','Mostrar todos los juegos','VALORES POR DEFECTO','Mostrar sólo los juegos disponibles','Mostrar solo los juegos añadidos','Emular Joystick','Teclado');
  descarga:('Este juego no esta disponible. ¿Deseas descargarlo?','Descargar contenido extra con el juego','DESCARGANDO','Para jugar a juegos de Windows 98 hay que descargar una imagen de disco. ¿Deseas continuar?','Para jugar a juegos de Windows 3.1 hay que descargar una imagen de disco. ¿Deseas continuar?','Para jugar a juegos de ScummVM hay que descargar una imagen de disco. ¿Deseas continuar?','El listado de juegos no está disponible ¿Deseas descargarlo?','Hay una versión actualizada de la lista de juegos. ¿Deseas descargarla?','Contenido extra no encontrado ¿Quieres descargalo?')),
  //Ingles
  (principal:('Game Filters','Languaje','Type','Spanish','English','German','French','Italian','Graphic Adventure','Simulator','Sports','Racing','Main Options','System','Full Screen','Sound','Info/help message','Advanced Options','Add Game','Edit/Delete Game','Game Search','Game Images','Game Info','Company:','Year:','About','MS-DOS engine','Generic');
  grabar:('Add Game','Game','Full Name','Publication Year','Company','Image Name','Executable','Folder/ZIP','Executable File','Parameters','Secondary Disk Image','Execute BEFORE','Execute AFTER','Setup file','CPU Cycles','Computer Type','RAM Memory','Enable GUS','Compatible with ScummVM','Keyboard Map File','Help/Info Message','DOSBox Extra Parameters','Extra Info','Manual(s)','Map(s)','Walk Through','Languaje','Type','ACCEPT','CANCEL','DELETE','ZIP File','ZIP file name','ZIP compressed file','Only works with ScummVM','Show in main list');
  avanzado:('Open','Advanced Configuration','Executable Files','Configuration Files','Main Directories','Images','Read fixed games values','Show all games','DEFAULT VALUES','Show only the available games','Show only the added games','Emulate Joystick','Keyboard');
  descarga:('This game is not available. Do you want to download it?','Download extra content with the game','DOWNLOADING','A disk image is required to play Windows 98 games. Do you want to continue?','A disk image is required to play Windows 3.1 games. Do you want to continue?','A disk image is required to play Windows ScummVM games. Do you want to continue?','The game list is not available. Do you want to download it?','There''s an updated version of the game list. Would you like to download it?','Extra content not found. Do you want to download it?')),
  //Aleman
  (principal:('Spielfilter','Sprache','Typ','Spanisch','Englisch','Deutsch','Französisch','Italienisch','Grafik-Adventure','Simulator','Sport','Rennen','Hauptoptionen','System','Vollbild','Sound','Info-/Hilfemeldung','Erweiterte Optionen','Hinzufügen Spiel','Bearbeiten/Löschen Spiel','Spielsuche','Spielbilder','Spielinfo','Firma:','Jahr:','Über','MS-DOS-Engine','Generisch');
  grabar:('Spiel hinzufügen','Spiel','Vollständiger Name','Erscheinungsjahr','Firma','Image-Name','Ausführbare Datei','Ordner/ZIP','Name der ausführbaren Datei','Parameter','Sekundäres Disk-Image','Ausführen VORHER','Ausführen NACHHER','Setup-Datei','CPU-Zyklen','Computertyp','RAM-Speicher','GUS aktivieren','Kompatibel mit ScummVM','Tastaturbelegungsdatei','Hilfe-/Info-Meldung','Zusätzliche DOSBox-Parameter','Zusätzliche Informationen','Handbuch(e)','Karte(n)','Anleitung','Sprache','Typ','AKZEPTIEREN','ABBRECHEN','LÖSCHEN','ZIP-Datei','ZIP-Dateiname','ZIP-komprimierte Datei','Funktioniert nur mit ScummVM','In der Hauptliste anzeigen');
  avanzado:('Offen','Erweiterte Konfiguration','Ausführbare Dateien','Konfigurationsdateien','Hauptverzeichnisse','Bilder','Lesen Sie feste Spielwerte','Alle Spiele anzeigen','STANDARDWERTE','Zeige nur die verfügbaren Spiele','Nur die hinzugefügten Spiele anzeigen','Joystick emulieren','Tastatur');
  descarga:('Dieses Spiel ist nicht verfügbar. Möchten Sie es herunterladen?','Lade zusätzliche Inhalte mit dem Spiel herunter','HERUNTERLADEN','Zum Spielen von Windows 98-Spielen muss ein Festplatten-Image heruntergeladen werden. Fortfahren?','Zum Spielen von Windows 3.1-Spielen muss ein Festplatten-Image heruntergeladen werden. Fortfahren?','Zum Spielen von Windows ScummVM-Spielen muss ein Festplatten-Image heruntergeladen werden. Fortfahren?','Die Spieleliste ist nicht verfügbar. Möchten Sie sie herunterladen?','Es gibt eine aktualisierte Version der Spieleliste. Möchten Sie sie herunterladen?','Es wurden keine zusätzlichen Inhalte gefunden. Möchten Sie diese herunterladen?')),
  //Frances
  (principal:('Filtres du jeu','Langue','Type','Espagnol','Anglais','Allemand','Français','Italien','Aventure graphique','Simulateur','Sports','Courses','Options générales','Système','Plein écran','Son','Message info/aide','Options avancées','Ajouter Jeu','Modifier/Supprimer Jeu','Rechercher un jeu','Images du jeu','Informations sur le jeu','Entreprise :','Année :','À propos','Moteur MS-DOS','Générique');
  grabar:('Ajouter un jeu','Jeu','Nom complet','Année de publication','Entreprise','Nom de l''image','Exécutable','Répertoire/ZIP','Nom de l''exécutable','Paramètres','Image du deuxième disque','Exécuter AVANT','Exécuter APRÈS','Programme d''installation','Cycles CPU','Type d''ordinateur','Mémoire RAM','Activer GUS','Compatible avec ScummVM','Fichier de mappage du clavier','Message d''information/aide','Paramètres supplémentaires DOSBox','Informations supplémentaires','Manuel(s)','Carte(s)','Guide(s)','Langue','Type','ACCEPTER','ANNULER','SUPPRIMER','Fichier ZIP','Nom du fichier ZIP','Fichier compressé ZIP','Fonctionne uniquement avec ScummVM','Afficher dans la liste principale');
  avanzado:('Ouvrir','Configuration Avancée','Fichiers exécutables','Fichiers de configuration','Répertoires Principaux','Images','Lire les valeurs de jeux fixes','Afficher tous les jeux','VALEURS PAR DÉFAUT','Afficher seulement les jeux disponibles','Afficher uniquement les jeux ajoutés','Émuler le joystick','Clavier');
  descarga:('Ce jeu n''est pas disponible. Voulez-vous le télécharger ?','Téléchargez du contenu supplémentaire avec le jeu','TÉLÉCHARGEMENT','Pour jouer aux jeux Windows 98, une image disque doit être téléchargée. Continuer?','Pour jouer aux jeux Windows 3.1, une image disque doit être téléchargée. Continuer ?','Pour jouer aux jeux Windows ScummVM, une image disque doit être téléchargée. Continuer?','La liste des jeux n''est pas disponible. Voulez-vous la télécharger ?','Une version mise à jour de la liste des jeux est disponible. Souhaitez-vous la télécharger ?','Contenu supplémentaire introuvable. Voulez-vous le télécharger ?')),
  //Italiano
  (principal:('Filtri del gioco','Lingua','Tipo','Spagnolo','Inglese','Tedesco','Francese','Italiano','Avventura grafica','Simulatore','Sport','Corse','Opzioni generali','Sistema','Schermo intero','Suono','Messaggio info/aiuto','Opzioni avanzate','Aggiungi Gioco','Modifica/Elimina Gioco','Cerca gioco','Immagini del gioco','Informazioni sul gioco','Azienda:','Anno:','Informazioni','Motore MS-DOS','Generico');
  grabar:('Aggiungi gioco','Gioco','Nome completo','Anno di pubblicazione','Azienda','Nome immagine','Eseguibile','Directory/ZIP','Nome eseguibile','Parametri','Immagine secondo disco','Esegui PRIMA','Esegui DOPO','Programma di installazione','Cicli CPU','Tipo di computer','Memoria RAM','Attiva GUS','Compatibile con ScummVM','File mappa tastiera','Messaggio di informazioni/aiuto','Parametri extra DOSBox','Informazioni extra','Manuale(i)','Mappa(e)','Guida(e)','Lingua','Tipo','ACCETTA','ANNULLA','ELIMINA','ZIP','Nome del file ZIP','File compresso ZIP','Funziona solo con ScummVM','Mostra nell''elenco principale');
  avanzado:('Apri','Configurazione Avanzata','File Eseguibili','File di configurazione','Directory principali','Immagini','Leggi i valori fissi dei giochi','Mostra tutti i giochi','VALORI PREDEFINITI','Mostra solo i giochi disponibili','Mostra solo i giochi aggiunti','Emula joystick','Tastiera');
  descarga:('Questo gioco non è disponibile. Vuoi scaricarlo?','Scarica contenuti extra con il gioco','SCARICAMENTO','Per giocare ai giochi Windows 98 è necessario scaricare un''immagine disco. Continuare?','Per giocare ai giochi Windows 3.1 è necessario scaricare un''immagine disco. Continuare?','Per giocare ai giochi Windows ScummVM è necessario scaricare un''immagine disco. Continuare?','L''elenco dei giochi non è disponibile. Vuoi scaricarlo?','È disponibile una versione aggiornata dell''elenco dei giochi. Desideri scaricarla?','Contenuto aggiuntivo non trovato. Desideri scaricarlo?'))
  );

procedure seleccionar_idioma;
var
{$ifdef windows}
  LangID:word;
  {$else}
  {$IFDEF Darwin}
  theLocaleRef:CFLocaleRef;
  locale:CFStringRef;
  buffer:StringPtr;
  bufferSize:CFIndex;
  encoding:CFStringEncoding;
  success:boolean;
  {$endif}
  fbl,l:string;
  {$ENDIF}
begin
  if idioma_sel=200 then begin
    {$ifdef windows}
    LangID:=GetUserDefaultLangID;
    case Byte(LangID and $03ff) of
      LANG_BASQUE,LANG_CATALAN,LANG_SPANISH:idioma_ind:=0;
      LANG_DUTCH,LANG_GERMAN:idioma_ind:=2;
      LANG_FRENCH:idioma_ind:=3;
      LANG_ITALIAN:idioma_ind:=4;
      //LANG_ENGLISH:
      else idioma_ind:=1;
    end;
    {$endif}
    {$IFDEF UNIX}
      fbl:='';
      fbl:=Copy(GetEnvironmentVariable('LC_CTYPE'),1,2);
      if fbl='' then fbl:=Copy(GetEnvironmentVariable('LANG'),1,2);
    {$endif}
    {$IFDEF Darwin}
      theLocaleRef:=CFLocaleCopyCurrent;
      locale:=CFLocaleGetIdentifier(theLocaleRef);
      encoding:=0;
      bufferSize:=256;
      buffer:=new(StringPtr);
      success:=CFStringGetPascalString(locale,buffer,bufferSize,encoding);
      if success then l:=string(buffer^)
        else l:='';
      fbl:=Copy(l,1,2);
      dispose(buffer);
    {$endif}
    {$ifndef windows}
    idioma_ind:=1;
    if fbl='es' then idioma_ind:=0
      else if fbl='fr' then idioma_ind:=3
        else if fbl='gr' then idioma_ind:=2
          else if fbl='it' then idioma_ind:=4;
    {$endif}
  end else idioma_ind:=idioma_sel;
end;

procedure cambiar_idioma_principal;
begin
  form1.groupbox3.caption:=idioma_fijo[idioma_ind].principal[0];
  //form1.groupbox5.caption:=idioma_fijo[idioma_ind].principal[1];
  //form1.groupbox4.caption:=idioma_fijo[idioma_ind].principal[2];
  //form1.checkbox9.caption:=idioma_fijo[idioma_ind].principal[3];
  //form1.checkbox12.caption:=idioma_fijo[idioma_ind].principal[4];
  //form1.checkbox10.caption:=idioma_fijo[idioma_ind].principal[5];
  //form1.checkbox11.caption:=idioma_fijo[idioma_ind].principal[6];
  //form1.checkbox13.caption:=idioma_fijo[idioma_ind].principal[7];
  //form1.checkbox18.caption:=idioma_fijo[idioma_ind].principal[27];
  form1.checkbox3.caption:=idioma_fijo[idioma_ind].principal[8];
  form1.checkbox4.caption:=idioma_fijo[idioma_ind].principal[9];
  form1.checkbox5.caption:=idioma_fijo[idioma_ind].principal[10];
  form1.checkbox17.caption:=idioma_fijo[idioma_ind].principal[11];
  form1.groupbox1.caption:=idioma_fijo[idioma_ind].principal[12];
  form1.groupbox7.caption:=idioma_fijo[idioma_ind].principal[13];
  form1.checkbox1.caption:=idioma_fijo[idioma_ind].principal[14];
  form1.checkbox14.caption:=idioma_fijo[idioma_ind].principal[15];
  form1.checkbox2.caption:=idioma_fijo[idioma_ind].principal[16];
  //form1.groupbox8.caption:=idioma_fijo[idioma_ind].principal[17];
  //form1.button1.caption:=idioma_fijo[idioma_ind].principal[18];
  //form1.button2.caption:=idioma_fijo[idioma_ind].principal[19];
  form1.checkbox15.caption:=idioma_fijo[idioma_ind].principal[17];
  form1.groupbox6.caption:=idioma_fijo[idioma_ind].principal[22];
  form1.label1.caption:=idioma_fijo[idioma_ind].principal[23];
  form1.label2.caption:=idioma_fijo[idioma_ind].principal[24];
  form1.image6.hint:=idioma_fijo[idioma_ind].principal[25];
  form1.GroupBox9.Caption:=idioma_fijo[idioma_ind].principal[26];
  form1.image2.hint:=idioma_fijo[idioma_ind].avanzado[1];
  list_error[7]:=idioma_fijo[idioma_ind].error[7];
  list_error[8]:=idioma_fijo[idioma_ind].error[8];
  form1.groupbox2.caption:=idioma_fijo[idioma_ind].avanzado[11];
  form1.radiobutton2.caption:=idioma_fijo[idioma_ind].avanzado[12];
  form1.CheckBox9.Caption:=idioma_fijo[idioma_ind].avanzado[9];
  form1.CheckBox10.Caption:=idioma_fijo[idioma_ind].descarga[1];
  list_error[0]:=StringReplace(idioma_fijo[idioma_ind].error[0],'[DIR_BASE]',main_config.dir_base,[rfReplaceAll]);
  list_error[1]:=StringReplace(idioma_fijo[idioma_ind].error[1],'[DIR_BASE]',main_config.dir_base,[rfReplaceAll]);
  list_error[2]:=StringReplace(idioma_fijo[idioma_ind].error[2],'[DIR_BASE]',main_config.dir_base,[rfReplaceAll]);
  list_error[3]:=idioma_fijo[idioma_ind].error[3];
  list_error[4]:=idioma_fijo[idioma_ind].error[4];
  list_error[5]:=idioma_fijo[idioma_ind].error[5];
  list_error[6]:=idioma_fijo[idioma_ind].error[6];
  list_error[9]:=idioma_fijo[idioma_ind].error[9];
  list_zip[0]:=idioma_fijo[idioma_ind].grabar[6];
  list_zip[1]:=idioma_fijo[idioma_ind].grabar[31];
  list_zip[2]:=idioma_fijo[idioma_ind].grabar[7];
  list_zip[3]:=idioma_fijo[idioma_ind].grabar[32];
  list_descarga[0]:=idioma_fijo[idioma_ind].descarga[3];
  list_descarga[1]:=idioma_fijo[idioma_ind].descarga[4];
  list_descarga[2]:=idioma_fijo[idioma_ind].descarga[5];
  list_descarga[3]:=idioma_fijo[idioma_ind].descarga[2];
  list_descarga[4]:=idioma_fijo[idioma_ind].descarga[6];
  list_descarga[5]:=idioma_fijo[idioma_ind].descarga[7];
  list_descarga[6]:=idioma_fijo[idioma_ind].descarga[0];
  list_descarga[7]:=idioma_fijo[idioma_ind].descarga[8];
end;

procedure cambiar_idioma_avanzado;
begin
  form4.Caption:=idioma_fijo[idioma_ind].avanzado[1];
  form4.button1.Caption:=idioma_fijo[idioma_ind].grabar[28];
  form4.button7.Caption:=idioma_fijo[idioma_ind].grabar[29];
  form4.button2.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button3.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button8.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button9.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button10.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button11.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button12.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button13.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button15.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button23.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button20.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button21.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button22.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button25.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  //form4.GroupBox2.Caption:=idioma_fijo[idioma_ind].avanzado[2];
  //form4.GroupBox1.Caption:=idioma_fijo[idioma_ind].avanzado[3];
  form4.GroupBox3.Caption:=idioma_fijo[idioma_ind].avanzado[4];
  form4.Groupbox5.Caption:=idioma_fijo[idioma_ind].principal[1];
  form4.LabeledEdit10.EditLabel.Caption:=idioma_fijo[idioma_ind].avanzado[5];
  form4.LabeledEdit6.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[23];
  form4.LabeledEdit7.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[24];
  form4.LabeledEdit8.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[25];
  //form4.CheckBox11.Caption:=idioma_fijo[idioma_ind].avanzado[7];
  form4.Button14.Caption:=idioma_fijo[idioma_ind].avanzado[8];
end;

procedure cambiar_idioma_descarga;
begin
  form5.Button1.Caption:=idioma_fijo[idioma_ind].grabar[28];
  form5.Button2.Caption:=idioma_fijo[idioma_ind].grabar[29];
end;

end.
