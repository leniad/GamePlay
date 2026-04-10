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
    segundo_disco:string;
    ciclos:integer;
    grafica:string;
    mapper:string;
    setup:string;
    image_alt:string;
    mensaje:string;
  end;

const
  GAME_TOTAL_REF=24;

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
  (nombre_original:'EGA Version';nombre:'CGA PC-Booter';dir:'ASPARCGA';exec:'aspargp.img';ciclos:450;grafica:'cga';image_alt:'asparcga'),
  (nombre_original:'VGA Version';nombre:'EGA Version';dir:'mi_e_es';ciclos:3000;image_alt:'monkey_ega'),
  (nombre_original:'EGA Version';nombre:'CGA Version';dir:'solnegro_cga';exec:'solnegro.img';mapper:'solnegro.map';image_alt:'solnegro_cga'),
  (nombre_original:'CGA Version';nombre:'PCJr Version';dir:'MINESHJR';exec:'minshaft.jrc';ciclos:300;grafica:'pcjr';image_alt:'mineshaftjr'),
  (nombre_original:'EGA Version';nombre:'CGA Version';dir:'F15CGA';exec:'F-15_CGA.img';ciclos:450;image_alt:'f15_cga'),
  (nombre_original:'EGA Version';nombre:'CGA Version';dir:'f40pscga';exec:'f40.exe';image_alt:'f40cga'),
  (nombre_original:'Tandy/EGA Version';nombre:'CGA Version';dir:'doc_cga';exec:'doc.exe';image_alt:'doc_cga';mensaje:''),
  (nombre_original:'VGA Version';nombre:'EGA Version';dir:'kq5_es_e';image_alt:'kq5_ega'),
  (nombre_original:'Tandy/EGA Version';nombre:'PC-Booter';dir:'kq2_boot';exec:'kq2_1.img';segundo_disco:'kq2_2.img';image_alt:'kq2_b';mensaje:MDISCO2),
  (nombre_original:'New Version (SCI)';nombre:'Old Version (AGI)';dir:'kq4_agi';exec:'kq4.com';grafica:'tandy';image_alt:'kq4_agi'),
  (nombre_original:'Tandy/EGA Version';nombre:'PC-Booter';dir:'bc_boot';exec:'BC_D1.IMG';segundo_disco:'BC_D2.IMG';mensaje:MDISCO2),
  (nombre_original:'VGA Version';nombre:'EGA Version';dir:'PQ3_EN_E';exec:'SCIDUV.EXE';setup:'install.exe';image_alt:'pq3_ega'),
  (nombre_original:'EGA Version';nombre:'Tandy Version';dir:'TD_TANDY';exec:'td.exe';ciclos:1000;grafica:'tandy';mensaje:'Al empezar pulsa 2 para seleccionar Tandy'),
  (nombre_original:'EGA (New Version)';nombre:'EGA (Old Version)';dir:'ZAK_OLD';exec:'zak.exe';image_alt:'zak_old'),
  (nombre_original:'Tandy/EGA';nombre:'EGA (Old Version)';dir:'MANIACO';exec:'maniac.exe';grafica:'vga';image_alt:'maniac_old')
);

implementation

end.
