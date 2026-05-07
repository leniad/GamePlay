unit games_ref;
{$ifdef fpc}{$mode delphi}{$H+}{$endif}

interface
uses games_data,games_info;

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
    setup:string;
    image_alt:string;
    mensaje:string;
  end;

const
  GAME_TOTAL_REF=61;

GAME_DATA_REF:array[1..GAME_TOTAL_REF] of tipo_games_ref=(
  (nombre_original:'Original';nombre:'Español no oficial';dir:'U7_ES'),
  (nombre_original:'Original';nombre:'Español no oficial';dir:'WCOMM_ES'),
  (nombre_original:'EGA Version';nombre:'CGA Version';dir:'war_cga';exec:'war.exe';grafica:'cga_composite';image_alt:'warcga'),
  (nombre_original:'VGA Version';nombre:'EGA Version';dir:'bchess_e';image_alt:'bchess_ega'),
  (nombre_original:'Hi Res';nombre:'Low Res';dir:'bc4k_l';image_alt:'bc4000_low'),
  (nombre_original:'VGA Version';nombre:'EGA Version';dir:'BABYEGA';image_alt:'babyega'),
  (nombre_original:'Tandy/EGA Version';nombre:'CGA PC-Booter';dir:'kq1_cga';exec:'kq1_cga.img';ciclos:300;grafica:'cga_composite';image_alt:'kq1_cga'),
  (nombre:'Tandy PC-Booter';dir:'kq1tandy';exec:'kq1tandy.img';grafica:'tandy'),
  (nombre:'PcJr PC-Booter';dir:'kq1pcjr';exec:'kq1pcjr.img';ciclos:300;grafica:'pcjr'),
  (nombre:'Español CGA PC-Booter';dir:'ASPARCGA';exec:'aspargp.img';ciclos:450;grafica:'cga';image_alt:'asparcga'),
  (nombre:'Español EGA';dir:'mi_e_es';ciclos:3000;image_alt:'monkey_ega'),
  (nombre_original:'EGA Version';nombre:'CGA Version';dir:'solnegro_cga';exec:'solnegro.img';mapper:'solnegro.map';image_alt:'solnegro_cga'),
  (nombre_original:'CGA Version';nombre:'PCJr Version';dir:'MINESHJR';exec:'minshaft.jrc';ciclos:300;grafica:'pcjr';image_alt:'mineshaftjr'),
  (nombre_original:'EGA Version';nombre:'CGA Version';dir:'F15CGA';exec:'F-15_CGA.img';ciclos:450;image_alt:'f15_cga'),
  (nombre_original:'EGA Version';nombre:'CGA Version';dir:'f40pscga';exec:'f40.exe';image_alt:'f40cga'),
  (nombre_original:'Tandy/EGA Version';nombre:'CGA Version';dir:'doc_cga';exec:'doc.exe';image_alt:'doc_cga';mensaje:''),
  (nombre_original:'VGA Version';nombre:'EGA Version';dir:'kq5_es_e';image_alt:'kq5_ega'),
  (nombre_original:'Tandy/EGA Version';nombre:'PC-Booter';dir:'kq2_boot';exec:'kq2_1.img';segundo_disco:'kq2_2.img';image_alt:'kq2_b';mensaje:MDISCO2),
  (nombre_original:'New Version (SCI)';nombre:'Old Version (AGI)';dir:'kq4_agi';exec:'kq4.com';grafica:'tandy';image_alt:'kq4_agi'),
  (nombre_original:'Tandy/EGA Version';nombre:'PC-Booter';dir:'bc_boot';exec:'BC_D1.IMG';segundo_disco:'BC_D2.IMG';mensaje:MDISCO2),
  (nombre_original:'English VGA';nombre:'English EGA';dir:'PQ3_EN_E';exec:'SCIDUV.EXE';setup:'install.exe';image_alt:'pq3_ega'),
  (nombre_original:'EGA Version';nombre:'Tandy Version';dir:'TD_TANDY';exec:'td.exe';ciclos:1000;grafica:'tandy';mensaje:'Al empezar pulsa 2 para seleccionar Tandy'),
  (nombre_original:'EGA (New Version)';nombre:'EGA (Old Version)';dir:'ZAK_OLD';exec:'zak.exe';image_alt:'zak_old'),
  (nombre_original:'Tandy/EGA';nombre:'EGA (Old Version)';dir:'MANIACO';exec:'maniac.exe';grafica:'vga';image_alt:'maniac_old'),
  (nombre_original:'Parte I';nombre:'Parte II';dir:'ZIPIZAPE';exec:'ZAPE.EXE'),
  (nombre_original:'Joker';nombre:'Penguin';dir:'batmancc';exec:'penguin.exe'),
  (nombre_original:'English';nombre:'Español';dir:'ijfa_es';exec:'atlantis.exe';manual:'indyfa_manual_es.pdf$indyfa_Libro de Pistas.pdf$indyfa_comic.pdf'),
  (nombre:'Deutsch';dir:'ijfa_de';exec:'atlantis.exe';manual:'indyfa_comic.pdf'),
  (nombre_original:'English';nombre:'Español VGA';dir:'mi_v_es';exec:'monkey.exe'),
  (nombre_original:'English';nombre:'Español';dir:'loom_es';exec:'loom.exe';manual:'Loom_manual_es.pdf$Loom_Libro de Pistas.pdf$Loom_El Libro de los Patrones.pdf'),
  (nombre:'Deutsch';dir:'loom_de';exec:'loom.exe'),
  (nombre:'Français';dir:'loom_fr';exec:'loom.exe';manual:'Loom_manuel_fr.pdf$Loom_Carte de référence.pdf$Loom_Cahier de Trames.pdf$Loom_Livre des astuces.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'alitd_es';exec:'tatou.com';manual:'alitd1_manual_es.pdf$alitd1_newspaper_es.pdf'),
  (nombre:'Deutsch';dir:'alitd_de';exec:'tatou.com';manual:'alitd1_manual.pdf$alitd1_Newspaper.pdf'),
  (nombre:'Français';dir:'alitd_fr';exec:'tatou.com';manual:'alitd1_manual.pdf$alitd1_Newspaper.pdf'),
  (nombre_original:'English';nombre:'Español EGA';dir:'ASPARGP';exec:'dinamic.bat'),
  (nombre_original:'English';nombre:'Español';dir:'gob2_es';exec:'LOADER.EXE'),
  (nombre:'Deutsch';dir:'gob2_de';exec:'LOADER.EXE'),
  (nombre:'Italiano';dir:'gob2_it';exec:'LOADER.EXE'),
  (nombre_original:'English';nombre:'Español';dir:'batt_es';exec:'loader.exe';manual:'bargon_manual.pdf';mensaje:'Solo puedes seleccionar el idioma ESPAÑOL! Pulsa D[RET]Despues pulsa S para validar y E para sonido SoundBlaster'),
  (nombre_original:'English/Deutsch';nombre:'Español';dir:'COLOR_ES';exec:'colorado.exe';manual:'colorado_manual_ES.pdf'),
  (nombre:'Español';dir:'MANIACES';exec:'maniac.exe';grafica:'tandy';manual:'ManiacMansion_ Manual_ES.pdf$ManiacMansion_Claves.pdf$ManiacMansion_Libro _Pistas.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'sq1_es';exec:'scidhuv.exe';manual:'sq1_manual_r_es.pdf$sq1_Hintbook.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'risky_es';exec:'risky.exe'),
  (nombre_original:'English';nombre:'Español';dir:'CERBE_ES';exec:'cerberus.bat';manual:'Elvira2_Manual_ES.pdf$Elvira2_Hintbook.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'emma_es';exec:'loader.com';manual:'Emmanuelle_manual_es.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'LD_ES';exec:'L&D.EXE';manual:'L&D_Manual.pdf$L&D_Claves.pdf$L&D_Anatomy_and_the_Surgical_Technique.pdf$L&D_New_Resident_Orientation.pdf$L&D_The_History_of_Surgery.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'EOB_ES';exec:'start1.exe';manual:'EOB_rulebook.pdf$EOB_RF.pdf$EOB_cluebook.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'EOB2_ES';exec:'start.exe';ciclos:6000;manual:'EOB2_manual.pdf$EOB2_RF.pdf$EOB2_Cluebook.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'EOB3_ES';exec:'aesop.exe';manual:'EOB3_manual.pdf$EOB3_cluebook.pdf'),
  (nombre_original:'English';nombre:'Español';dir:'FPFP_ES';exec:'sierra.exe';manual:'Freddy Pharkas_Manual_ES.pdf$Freddy Pharkas_HB_ES.pdf';setup:'install.exe'),
  (nombre_original:'English';nombre:'Español';dir:'lsl1_es';exec:'scidhuv.exe';ciclos:6000;manual:'lsl1\';setup:'install.exe'),
  (nombre_original:'English';nombre:'Español';dir:'lsl6_es';exec:'sierra.exe';manual:'lsl6_manual_es.pdf$lsl6_hintbook.pdf$lsl6_RC.pdf';setup:'install.exe'),
  (nombre_original:'English';nombre:'Español';dir:'lsl5_es';exec:'SCIDHUV.EXE';manual:'lsl5_playspy_es.pdf$lsl5_Folleto AeroDork Airlines.pdf$lsl5_HintBook.pdf';setup:'install.exe'),
  (nombre_original:'English';nombre:'Español';dir:'metal_es';exec:'metal.exe';manual:'metalmutant_manual.pdf';mensaje:'Pulsa F2 para VGA'),
  (nombre:'Français';dir:'metal_fr';exec:'metal.exe';manual:'metalmutant_manual.pdf';mensaje:'Appuyez sur F2 pour VGA'),
  (nombre_original:'English';nombre:'Español';dir:'PQ3_ES';exec:'sierra.exe';manual:'PQ3_Manual_ES.pdf$PQ3_HB_ES.pdf';setup:'install.exe'),
  (nombre_original:'English';nombre:'Español';dir:'CANNONF2';exec:'cannon.exe';exec_pre:'cd exe[RET]copy cf2_es.exe ..\cannon.exe[RET]cd ..[RET]loadfix -1';manual:'CannonFodder2_Manual.pdf$CannonFodder2_RF.pdf';setup:'install.exe'),
  (nombre:'Français';dir:'CANNONF2';exec:'cannon.exe';exec_pre:'cd exe[RET]copy cf2_fr.exe ..\cannon.exe[RET]cd ..[RET]loadfix -1';manual:'CannonFodder2_Manual.pdf$CannonFodder2_RF.pdf';setup:'install.exe'),
  (nombre:'Italiano';dir:'CANNONF2';exec:'cannon.exe';exec_pre:'cd exe[RET]copy cf2_it.exe ..\cannon.exe[RET]cd ..[RET]loadfix -1';manual:'CannonFodder2_Manual.pdf$CannonFodder2_RF.pdf';setup:'install.exe'),
  (nombre_original:'English';nombre:'Español';dir:'darkf_es';exec:'dark.exe';ciclos:1;setup:'setup.exe')
);

implementation

end.
