unit idioma_info;

interface

procedure seleccionar_idioma;
procedure cambiar_idioma_principal;
procedure cambiar_idioma_grabar;
procedure cambiar_idioma_avanzado;

var
  idioma_ind:byte;
  list_error:array[0..8] of string;
  list_zip:array[0..3] of string;

implementation
uses principal,save_game,config,sysutils,main{$ifdef WINDOWS},windows{$endif}{$ifdef darwin},MacOSAll{$endif};

type
  tipo_idioma=record
    principal:array[0..26] of string;
    grabar:array[0..34] of string;
    error:array[0..8] of string;
    avanzado:array[0..10] of string;
  end;

const
  MAX_IDIOMAS=5-1;
  FULL_RET=chr(10)+chr(13);
  idioma_fijo:array[0..MAX_IDIOMAS] of tipo_idioma=(
  //Castellano
  (principal:('Filtros del Juego','Idioma','Tipo','Español','Inglés','Alemán','Francés','Italiano','Aventura Gráfica','Simulador','Deportes','Carreras','Opciones Generales','Sistema','Pantalla Completa','Sonido','Mensaje info/ayuda','Opciones Avanzadas','Añadir Juego','Editar/Borrar Juego','Buscar Juego','Imágenes del Juego','Información del Juego','Compañía:','Año:','Acerca de','Motor MS-DOS');
  grabar:('Añadir Juego','Juego','Nombre Completo','Año Publicación','Compañía','Nombre de la Imagen','Ejecutable','Directorio/ZIP','Fichero Ejecutable','Parámetros','Imagen Segundo Disco','Ejecutar ANTES','Ejecutar DESPUES','Programa de Instalación','Ciclos CPU','Tipo Ordenador','Memoria RAM','Activar GUS','Compatible con ScummVM','Fichero Mapa Teclado','Mensaje de información/ayuda','Parámetros Extra DOSBox','Información Extra','Manual(es)','Mapa(s)','Guia(s)','Idioma','Tipo','ACEPTAR','CANCELAR','BORRAR','Fichero ZIP','Nombre ZIP','Fichero comprimido en ZIP','Sólo funciona con ScummVM');
  error:('Error en la sección de manuales. Revisa que:'+FULL_RET+'  - Si es una carpeta debe terminar en ''\'' y debe existir dentro de [DIR_BASE]extras\manual'+FULL_RET+'  - Si es un fichero debe existir en [DIR_BASE]extras\manual'+FULL_RET+'  - Si son varios ficheros deben estar separados por el simbolo ''$'' y deben existir todos en [DIR_BASE]extras\manual','Error en la sección de mapas. Revisa que:'+FULL_RET+'  - Si es una carpeta debe terminar en ''\'' y debe existir dentro de [DIR_BASE]extras\maps'+FULL_RET+'  - Si es un fichero debe existir en [DIR_BASE]extras\maps'+FULL_RET+'  - Si son varios ficheros deben estar separados por el simbolo ''$'' y deben existir todos en [DIR_BASE]extras\maps',
  'Error en la sección de guías. Revisa que:'+FULL_RET+'  - Si es una carpeta debe terminar en ''\'' y debe existir dentro de [DIR_BASE]extras\walk'+FULL_RET+'  - Si es un fichero debe existir en [DIR_BASE]extras\walk'+FULL_RET+'  - Si son varios ficheros deben estar separados por el simbolo ''$'' y deben existir todos en [DIR_BASE]extras\walk','Error: no se puede localizar el CDROM del juego','Error: no se puede localizar el setup del juego'+FULL_RET+'Revisa el nombre del fichero o el directorio del juego!','Error: no se puede localizar el ejecutable del juego'+FULL_RET+'Revisa el nombre del fichero o el directorio del juego!','Precaución: El juego se va a borrar!'+FULL_RET+'¿Deseas continuar?',
  'El juego seleccionado no se puede ejecutar, por favor revisa la configuración','El juego seleccionado sólo se puede ejecutar con el motor ScummVM');
  avanzado:('Abrir','Configuración Avanzada','Ficheros Ejecutables','Ficheros de Configuración','Directorios Principales','Imagenes','Leer valores de los juegos fijos','Mostrar todos los juegos','VALORES POR DEFECTO','Mostrar solo los juegos que no funcionan','Mostrar solo los juegos añadidos')),
  //Ingles
  (principal:('Game Filters','Languaje','Type','Spanish','English','German','French','Italian','Graphic Adventure','Simulator','Sports','Racing','Main Options','System','Full Screen','Sound','Info/help message','Advanced Options','Add Game','Edit/Delete Game','Game Search','Game Images','Game Info','Company:','Year:','About','MS-DOS engine');
  grabar:('Add Game','Game','Full Name','Publication Year','Company','Image Name','Executable','Folder/ZIP','Executable File','Parameters','Secondary Disk Image','Execute BEFORE','Execute AFTER','Setup file','CPU Cycles','Computer Type','RAM Memory','Enable GUS','Compatible with ScummVM','Keyboard Map File','Help/Info Message','DOSBox Extra Parameters','Extra Info','Manual(s)','Map(s)','Walk Through','Languaje','Type','ACCEPT','CANCEL','DELETE','ZIP File','ZIP file name','ZIP compressed file','Only works with ScummVM');
  error:('Error in the manuals section. Check that:'+FULL_RET+'  - If it is a folder, it must end with ''\'' and exist within [DIR_BASE]extras\manual'+FULL_RET+'  - If it is a file, it must exist in [DIR_BASE]extras\manual'+FULL_RET+'  - If there are multiple files, they must be separated by the ''$'' symbol and all must exist in [DIR_BASE]extras\manual','Error in the maps section. Check that:'+FULL_RET+'  - If it is a folder, it must end with ''\'' and exist within [DIR_BASE]extras\maps'+FULL_RET+'  - If it is a file, it must exist in [DIR_BASE]extras\maps'+FULL_RET+'  - If there are multiple files, they must be separated by the ''$'' symbol and all must exist in [DIR_BASE]extras\maps',
  'Error in the Walk Through section. Check that:'+FULL_RET+'  - If it is a folder, it must end with ''\'' and exist within [DIR_BASE]extras\walk'+FULL_RET+'  - If it is a file, it must exist in [DIR_BASE]extras\walk'+FULL_RET+'  - If there are multiple files, they must be separated by the ''$'' symbol and all must exist in [DIR_BASE]extras\walk','Error: cannot locate the game''s CD-ROM','Error: cannot locate the game''s setup.'+FULL_RET+'Check the file name or the game directory!','Error: cannot locate the game''s executable'+FULL_RET+'Check the file name or the game directory!','Warning: The game is going to be deleted!'+FULL_RET+'Do you want to continue?',
  'The selected game cannot be run, please check the settings','The selected game can only be run with the ScummVM engine');
  avanzado:('Open','Advanced Configuration','Executable Files','Configuration Files','Main Directories','Images','Read fixed games values','Show all games','DEFAULT VALUES','Show only the games that don''t work','Show only the added games')),
  //Aleman
  (principal:('Spielfilter','Sprache','Typ','Spanisch','Englisch','Deutsch','Französisch','Italienisch','Grafik-Adventure','Simulator','Sport','Rennen','Hauptoptionen','System','Vollbild','Sound','Info-/Hilfemeldung','Erweiterte Optionen','Hinzufügen Spiel','Bearbeiten/Löschen Spiel','Spielsuche','Spielbilder','Spielinfo','Firma:','Jahr:','Über','MS-DOS-Engine');
  grabar:('Spiel hinzufügen','Spiel','Vollständiger Name','Erscheinungsjahr','Firma','Image-Name','Ausführbare Datei','Ordner/ZIP','Name der ausführbaren Datei','Parameter','Sekundäres Disk-Image','Ausführen VORHER','Ausführen NACHHER','Setup-Datei','CPU-Zyklen','Computertyp','RAM-Speicher','GUS aktivieren','Kompatibel mit ScummVM','Tastaturbelegungsdatei','Hilfe-/Info-Meldung','Zusätzliche DOSBox-Parameter','Zusätzliche Informationen','Handbuch(e)','Karte(n)','Anleitung','Sprache','Typ','AKZEPTIEREN','ABBRECHEN','LÖSCHEN','ZIP-Datei','ZIP-Dateiname','ZIP-komprimierte Datei','Funktioniert nur mit ScummVM');
  error:('Fehler im Handbuch-Bereich. Überprüfe folgendes:'+FULL_RET+'  - Wenn es ein Ordner ist, muss er mit ''\'' enden und innerhalb von [DIR_BASE]extras\manual existieren.'+FULL_RET+'  - Wenn es eine Datei ist, muss sie in [DIR_BASE]extras\manual existieren.'+FULL_RET+'  - Wenn es mehrere Dateien sind, müssen sie durch das ''$''-Symbol getrennt sein und alle in [DIR_BASE]extras\manual existieren','Fehler im Kartenbereich. Überprüfe folgendes:'+FULL_RET+'  - Wenn es ein Ordner ist, muss er mit ''\'' enden und innerhalb von [DIR_BASE]extras\maps existieren.'+FULL_RET+'  - Wenn es eine Datei ist, muss sie in [DIR_BASE]extras\maps existieren.'+FULL_RET+'  - Wenn es mehrere Dateien sind, müssen sie durch das ''$''-Symbol getrennt sein und alle in [DIR_BASE]extras\maps existieren',
  'Fehler im Walkthrough-Bereich. Überprüfe folgendes:'+FULL_RET+'  - Wenn es ein Ordner ist, muss er mit ''\'' enden und innerhalb von [DIR_BASE]extras\walk existieren.'+FULL_RET+'  - Wenn es eine Datei ist, muss sie in [DIR_BASE]extras\walk existieren.'+FULL_RET+'  - Wenn es mehrere Dateien sind, müssen sie durch das ''$''-Symbol getrennt sein und alle in [DIR_BASE]extras\walk existieren','Fehler: ich kann das CD-ROM des Spiels nicht finden','Fehler: ich kann das Setup des Spiels nicht finden.'+FULL_RET+'Überprüfe den Dateinamen oder das Spielverzeichnis!','Fehler: ich kann die ausführbare Datei des Spiels nicht finden.'+FULL_RET+'Überprüfe den Dateinamen oder das Spielverzeichnis!','Warnung: Das Spiel wird gelöscht!'+FULL_RET+'Möchtest du fortfahren?',
  'Das ausgewählte Spiel kann nicht gestartet werden, bitte überprüfe die Einstellungen','Das ausgewählte Spiel kann nur mit der ScummVM-Engine ausgeführt werden');
  avanzado:('Offen','Erweiterte Konfiguration','Ausführbare Dateien','Konfigurationsdateien','Hauptverzeichnisse','Bilder','Lesen Sie feste Spielwerte','Alle Spiele anzeigen','STANDARDWERTE','Nur die Spiele anzeigen, die nicht funktionieren','Nur die hinzugefügten Spiele anzeigen')),
  //Frances
  (principal:('Filtres du jeu','Langue','Type','Espagnol','Anglais','Allemand','Français','Italien','Aventure graphique','Simulateur','Sports','Courses','Options générales','Système','Plein écran','Son','Message info/aide','Options avancées','Ajouter Jeu','Modifier/Supprimer Jeu','Rechercher un jeu','Images du jeu','Informations sur le jeu','Entreprise :','Année :','À propos','Moteur MS-DOS');
  grabar:('Ajouter un jeu','Jeu','Nom complet','Année de publication','Entreprise','Nom de l''image','Exécutable','Répertoire/ZIP','Nom de l''exécutable','Paramètres','Image du deuxième disque','Exécuter AVANT','Exécuter APRÈS','Programme d''installation','Cycles CPU','Type d''ordinateur','Mémoire RAM','Activer GUS','Compatible avec ScummVM','Fichier de mappage du clavier','Message d''information/aide','Paramètres supplémentaires DOSBox','Informations supplémentaires','Manuel(s)','Carte(s)','Guide(s)','Langue','Type','ACCEPTER','ANNULER','SUPPRIMER','Fichier ZIP','Nom du fichier ZIP','Fichier compressé ZIP','Fonctionne uniquement avec ScummVM');
  error:('Erreur dans la section des manuels. Vérifiez que :'+FULL_RET+'  - Si c''est un dossier, il doit se terminer par ''\'' et exister dans [DIR_BASE]extras\manual'+FULL_RET+'  - Si c''est un fichier, il doit exister dans [DIR_BASE]extras\manual'+FULL_RET+'  - Si ce sont plusieurs fichiers, ils doivent être séparés par le symbole ''$'' et tous doivent exister dans [DIR_BASE]extras\manual.','Erreur dans la section des cartes. Vérifiez que :'+FULL_RET+'  - Si c''est un dossier, il doit se terminer par '''' et exister dans [DIR_BASE]extras\maps'+FULL_RET+'  - Si c''est un fichier, il doit exister dans [DIR_BASE]extras\maps'+FULL_RET+'  - Si ce sont plusieurs fichiers, ils doivent être séparés par le symbole ''$'' et tous doivent exister dans [DIR_BASE]extras\maps.',
  'Erreur dans la section des guides. Vérifiez que :'+FULL_RET+'  - Si c''est un dossier, il doit se terminer par ''\'' et exister dans [DIR_BASE]extras\walk'+FULL_RET+'  - Si c''est un fichier, il doit exister dans [DIR_BASE]extras\walk'+FULL_RET+'  - Si ce sont plusieurs fichiers, ils doivent être séparés par le symbole ''$'' et tous doivent exister dans [DIR_BASE]extras\walk.','Erreur : je ne peux pas localiser le CD-ROM du jeu','Erreur: je ne peux pas localiser le setup du jeu.'+FULL_RET+'Vérifiez le nom du fichier ou le répertoire du jeu!','Erreur : je ne peux pas localiser l''exécutable du jeu.'+FULL_RET+'Vérifiez le nom du fichier ou le répertoire du jeu!','Avertissement: Le jeu va être supprimé!'+FULL_RET+'Souhaitez-vous continuer?',
  'Le jeu sélectionné ne peut pas être lancé, veuillez vérifier la configuration','Le jeu sélectionné ne peut être exécuté qu''avec le moteur ScummVM');
  avanzado:('Ouvrir','Configuration Avancée','Fichiers exécutables','Fichiers de configuration','Répertoires Principaux','Images','Lire les valeurs de jeux fixes','Afficher tous les jeux','VALEURS PAR DÉFAUT','Afficher uniquement les jeux qui ne fonctionnent pas','Afficher uniquement les jeux ajoutés')),
  //Italiano
  (principal:('Filtri del gioco','Lingua','Tipo','Spagnolo','Inglese','Tedesco','Francese','Italiano','Avventura grafica','Simulatore','Sport','Corse','Opzioni generali','Sistema','Schermo intero','Suono','Messaggio info/aiuto','Opzioni avanzate','Aggiungi Gioco','Modifica/Elimina Gioco','Cerca gioco','Immagini del gioco','Informazioni sul gioco','Azienda:','Anno:','Informazioni','Motore MS-DOS');
  grabar:('Aggiungi gioco','Gioco','Nome completo','Anno di pubblicazione','Azienda','Nome immagine','Eseguibile','Directory/ZIP','Nome eseguibile','Parametri','Immagine secondo disco','Esegui PRIMA','Esegui DOPO','Programma di installazione','Cicli CPU','Tipo di computer','Memoria RAM','Attiva GUS','Compatibile con ScummVM','File mappa tastiera','Messaggio di informazioni/aiuto','Parametri extra DOSBox','Informazioni extra','Manuale(i)','Mappa(e)','Guida(e)','Lingua','Tipo','ACCETTA','ANNULLA','ELIMINA','ZIP','Nome del file ZIP','File compresso ZIP','Funziona solo con ScummVM');
  error:('Errore nella sezione dei manuali. Verifica che:'+FULL_RET+'  - Se è una cartella, deve terminare con ''\'' ed esistere all''interno di [DIR_BASE]extras\manual'+FULL_RET+'  - Se è un file, deve esistere in [DIR_BASE]extras\manual'+FULL_RET+'  - Se sono più file, devono essere separati dal simbolo ''$'' e devono esistere tutti in [DIR_BASE]extras\manual','Errore nella sezione delle mappe. Verifica che:'+FULL_RET+'  - Se è una cartella, deve terminare con ''\'' ed esistere all''interno di [DIR_BASE]extras\maps'+FULL_RET+'  - Se è un file, deve esistere in [DIR_BASE]extras\maps'+FULL_RET+'  - Se sono più file, devono essere separati dal simbolo ''$'' e devono esistere tutti in [DIR_BASE]extras\maps',
  'Errore nella sezione delle guide. Verifica che:'+FULL_RET+'  - Se è una cartella, deve terminare con ''\'' ed esistere all''interno di [DIR_BASE]extras\walk'+FULL_RET+'  - Se è un file, deve esistere in [DIR_BASE]extras\walk'+FULL_RET+'  - Se sono più file, devono essere separati dal simbolo ''$'' e devono esistere tutti in [DIR_BASE]extras\walk','Errore: non riesco a localizzare il CD-ROM del gioco','Errore: non riesco a localizzare il setup del gioco'+FULL_RET+'Controlla il nome del file o la directory del gioco!','Errore: non riesco a localizzare l''eseguibile del gioco'+FULL_RET+'Controlla il nome del file o la directory del gioco!','Attenzione: il gioco verrà eliminato!'+FULL_RET+'Vuoi continuare?',
  'Il gioco selezionato non può essere avviato, per favore controlla le impostazioni','Il gioco selezionato può essere eseguito solo con il motore ScummVM');
  avanzado:('Apri','Configurazione Avanzata','File Eseguibili','File di configurazione','Directory principali','Immagini','Leggi i valori fissi dei giochi','Mostra tutti i giochi','VALORI PREDEFINITI','Mostra solo i giochi che non funzionano','Mostra solo i giochi aggiunti'))
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
  form1.groupbox5.caption:=idioma_fijo[idioma_ind].principal[1];
  form1.groupbox4.caption:=idioma_fijo[idioma_ind].principal[2];
  form1.checkbox9.caption:=idioma_fijo[idioma_ind].principal[3];
  form1.checkbox12.caption:=idioma_fijo[idioma_ind].principal[4];
  form1.checkbox10.caption:=idioma_fijo[idioma_ind].principal[5];
  form1.checkbox11.caption:=idioma_fijo[idioma_ind].principal[6];
  form1.checkbox13.caption:=idioma_fijo[idioma_ind].principal[7];
  form1.checkbox3.caption:=idioma_fijo[idioma_ind].principal[8];
  form1.checkbox4.caption:=idioma_fijo[idioma_ind].principal[9];
  form1.checkbox5.caption:=idioma_fijo[idioma_ind].principal[10];
  form1.checkbox17.caption:=idioma_fijo[idioma_ind].principal[11];
  form1.groupbox1.caption:=idioma_fijo[idioma_ind].principal[12];
  form1.groupbox7.caption:=idioma_fijo[idioma_ind].principal[13];
  form1.checkbox1.caption:=idioma_fijo[idioma_ind].principal[14];
  form1.checkbox14.caption:=idioma_fijo[idioma_ind].principal[15];
  form1.checkbox2.caption:=idioma_fijo[idioma_ind].principal[16];
  form1.groupbox8.caption:=idioma_fijo[idioma_ind].principal[17];
  form1.button1.caption:=idioma_fijo[idioma_ind].principal[18];
  form1.button2.caption:=idioma_fijo[idioma_ind].principal[19];
  form1.groupbox6.caption:=idioma_fijo[idioma_ind].principal[22];
  form1.label1.caption:=idioma_fijo[idioma_ind].principal[23];
  form1.label2.caption:=idioma_fijo[idioma_ind].principal[24];
  form1.image6.hint:=idioma_fijo[idioma_ind].principal[25];
  form1.GroupBox9.Caption:=idioma_fijo[idioma_ind].principal[26];
  {$ifndef fpc}
  form1.image2.hint:=idioma_fijo[idioma_ind].avanzado[1];
  {$else}
  form1.bitbtn6.hint:=idioma_fijo[idioma_ind].avanzado[1];
  {$endif}
  list_error[7]:=idioma_fijo[idioma_ind].error[7];
  list_error[8]:=idioma_fijo[idioma_ind].error[8];
end;

procedure cambiar_idioma_grabar;
begin
  //Errores al grabar
  list_error[0]:=StringReplace(idioma_fijo[idioma_ind].error[0],'[DIR_BASE]',main_config.dir_base,[rfReplaceAll]);
  list_error[1]:=StringReplace(idioma_fijo[idioma_ind].error[1],'[DIR_BASE]',main_config.dir_base,[rfReplaceAll]);
  list_error[2]:=StringReplace(idioma_fijo[idioma_ind].error[2],'[DIR_BASE]',main_config.dir_base,[rfReplaceAll]);
  list_error[3]:=idioma_fijo[idioma_ind].error[3];
  list_error[4]:=idioma_fijo[idioma_ind].error[4];
  list_error[5]:=idioma_fijo[idioma_ind].error[5];
  list_error[6]:=idioma_fijo[idioma_ind].error[6];
  list_zip[0]:=idioma_fijo[idioma_ind].grabar[6];
  list_zip[1]:=idioma_fijo[idioma_ind].grabar[31];
  list_zip[2]:=idioma_fijo[idioma_ind].grabar[7];
  list_zip[3]:=idioma_fijo[idioma_ind].grabar[32];
  //Resto de objetos
  form2.caption:=idioma_fijo[idioma_ind].grabar[0];
  form2.groupbox1.caption:=idioma_fijo[idioma_ind].grabar[1];
  form2.LabeledEdit1.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[2];
  form2.LabeledEdit2.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[3];
  form2.LabeledEdit3.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[4];
  form2.LabeledEdit4.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[5];
  form2.groupbox3.caption:=idioma_fijo[idioma_ind].grabar[6];
  form2.LabeledEdit9.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[7];
  form2.LabeledEdit5.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[8];
  form2.LabeledEdit6.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[9];
  form2.LabeledEdit10.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[10];
  form2.LabeledEdit7.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[11];
  form2.LabeledEdit8.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[12];
  form2.LabeledEdit20.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[13];
  form2.LabeledEdit11.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[14];
  form2.StaticText1.Caption:=idioma_fijo[idioma_ind].grabar[15];
  form2.LabeledEdit12.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[16];
  form2.CheckBox1.Caption:=idioma_fijo[idioma_ind].grabar[17];
  form2.CheckBox2.Caption:=idioma_fijo[idioma_ind].grabar[18];
  form2.LabeledEdit13.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[19];
  form2.LabeledEdit15.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[20];
  form2.LabeledEdit14.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[21];
  form2.groupbox12.caption:=idioma_fijo[idioma_ind].grabar[22];
  form2.LabeledEdit16.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[23];
  form2.LabeledEdit17.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[24];
  form2.LabeledEdit18.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[25];
  form2.StaticText2.Caption:=idioma_fijo[idioma_ind].grabar[26];
  form2.StaticText3.Caption:=idioma_fijo[idioma_ind].grabar[27];
  form2.Button1.Caption:=idioma_fijo[idioma_ind].grabar[28];
  form2.Button2.Caption:=idioma_fijo[idioma_ind].grabar[29];
  form2.Button3.Caption:=idioma_fijo[idioma_ind].grabar[30];
  form2.combobox4.Items.Clear;
  form2.combobox4.Items.Add('General/Auto');
  form2.combobox4.Items.Add(idioma_fijo[idioma_ind].principal[3]);
  form2.combobox4.Items.Add(idioma_fijo[idioma_ind].principal[4]);
  form2.combobox4.Items.Add(idioma_fijo[idioma_ind].principal[5]);
  form2.combobox4.Items.Add(idioma_fijo[idioma_ind].principal[6]);
  form2.combobox4.Items.Add(idioma_fijo[idioma_ind].principal[7]);
  form2.combobox5.Items.Clear;
  form2.combobox5.Items.Add(idioma_fijo[idioma_ind].principal[8]);
  form2.combobox5.Items.Add('Arcade');
  form2.combobox5.Items.Add('3D');
  form2.combobox5.Items.Add(idioma_fijo[idioma_ind].principal[9]);
  form2.combobox5.Items.Add(idioma_fijo[idioma_ind].principal[10]);
  form2.combobox5.Items.Add('Puzzles');
  form2.combobox5.Items.Add('RPG');
  form2.combobox5.Items.Add(idioma_fijo[idioma_ind].principal[11]);
  form2.combobox5.Items.Add('Extra');
  form2.CheckBox4.Caption:=idioma_fijo[idioma_ind].grabar[34];
end;

procedure cambiar_idioma_avanzado;
begin
  form4.Caption:=idioma_fijo[idioma_ind].avanzado[1];
  form4.button1.Caption:=idioma_fijo[idioma_ind].grabar[28];
  form4.button7.Caption:=idioma_fijo[idioma_ind].grabar[29];
  form4.button2.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button3.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button4.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button5.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button6.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button8.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button9.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button10.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button11.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button12.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button13.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.button15.Caption:=idioma_fijo[idioma_ind].avanzado[0];
  form4.GroupBox2.Caption:=idioma_fijo[idioma_ind].avanzado[2];
  form4.GroupBox1.Caption:=idioma_fijo[idioma_ind].avanzado[3];
  form4.GroupBox3.Caption:=idioma_fijo[idioma_ind].avanzado[4];
  form4.Groupbox5.Caption:=idioma_fijo[idioma_ind].principal[1];
  form4.LabeledEdit10.EditLabel.Caption:=idioma_fijo[idioma_ind].avanzado[5];
  form4.LabeledEdit6.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[23];
  form4.LabeledEdit7.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[24];
  form4.LabeledEdit8.EditLabel.Caption:=idioma_fijo[idioma_ind].grabar[25];
  form4.CheckBox10.Caption:=idioma_fijo[idioma_ind].avanzado[6];
  form4.CheckBox11.Caption:=idioma_fijo[idioma_ind].avanzado[7];
  form4.Button14.Caption:=idioma_fijo[idioma_ind].avanzado[8];
  form4.CheckBox1.Caption:=idioma_fijo[idioma_ind].avanzado[9];
  form4.Checkbox2.Caption:=idioma_fijo[idioma_ind].avanzado[10];
end;

end.
