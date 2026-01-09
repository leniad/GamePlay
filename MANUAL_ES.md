# ¿Cómo funciona?

**Gameplay** está dividido en varias secciones.
Si sólo quieres jugar, **inicialmente no hay que configurar nada**.

![Pantalla Principal](https://i.ibb.co/kgMc9yXS/gameplay-040-es.png)

---
## 1. Pantalla principal

### 1.1 Filtros para los juegos
Puedes elegir:
- El idioma del juego.
- El tipo de juego.

La lista se actualizará según las opciones elegidas.

### 1.2 Sistema a emular
Puedes elegir entre:

- **MS-DOS**: Juegos para el sistema MS-DOS.
- **ScummVM**: Solo para ciertas aventuras gráficas. Al seleccionarlo, la lista se ajusta automáticamente.
- **DSP Emulator**: Emulador para Arcade, Ordenadores 8bits y Consolas
- **Apple II**: Juegos para la serie de ordenadores Apple II
- **Atari 800**: Juegos para la serie de ordenadores Atari 800

> El emulador se configura automáticamente, no necesitas hacer nada.


### 1.3 Opciones Generales

- **Pantalla completa**: Cuando arranque el juego se hará a pantalla completa
- **Sonido**: Activar o desactivar el sonido del juego ejecutado
- **Mostrar mensaje de info/ayuda**: Cuando se ejecuta un juego, se puede configurar un mensaje con información sobre, por ejemplo, que opciones elegir para una mejor experiencia o tarjeta gráfica, sonido, teclas, etc. Con esta opción se puede desactivar y que no aparezca el mensaje
- **Opciones Avanzadas**: Mostrar las opciones avanzadas, o lo que es lo mismo, los botones para añadir juegos, editarlos o borrarlos.

### 1.4 Buscar juego
Si tecleas el nombre del juego que buscas, se buscará en el listado.

### 1.5 Listado de juegos

Código de colores:
- **Azul**: Juego del listado predeterminado y disponible.
- **Amarillo**: Juego añadido manualmente y disponible.
- **Gris**: Juego listado, pero con errores y no disponible.
- **Morado**: Juego que funciona sólo con el motor ScummVM.

Juega pulsando `ENTER` o doble click sobre el juego.
> Si escribes el nombre, se buscará entre los de la lista.

### 1.6 Juegos disponibles / Juegos totales
Este contador indica cuantos juegos hay disponibles / cuantos juegos hay en total, incluidos los fijos del listado de Gameplay y los añadidos manualmente.<br>
Si hay un problema con los datos del juego, no aparecerá en el listado, a menos que se fuerce en la configuración avanzada que los muestre (más adelante se explica)

### 1.7 Imágenes del juego
Muestra una o varias imágenes en bucle cada segundo.

### 1.8 Jugar
Si pulsamos este botón se ejecutará el juego seleccionado, al igual que hacer doble click con el ratón en el listado.

### 1.9 Información del juego
Aparece la **compañía** y el **año** de publicación.

### 1.10 Manual, guía o mapas
Si el juego tiene documentos asociados (PDF, TXT, imágenes), se pueden abrir desde aquí.<br>
Si hay muchos ficheros, puede que se abra una carpeta con el contenido.<br>
Si el botón aparece apagado, no hay documentos disponibles.<br>
### 1.11 Configuración Avanzada
Acceso al menú avanzado, donde puedes cambiar:
- Directorios
- Ejecutables
- Visualización del listado
- Etc...

---
## 2. Configuración Avanzada

![Configuración](https://i.ibb.co/DHSg5h0S/config.png)

### 2.1 Ficheros ejecutables
Par poder lanzar los juegos, Gameplay necesita cuatro emuladores *DosBox, DosBox-X, ScummVM y DSP Emulator*.
Aquí se pueden cambiar los ficheros ejecutables para elegir otras versiones, o actualizaciones de los emuladores.

### 2.2 Directorios Principales
Aquí se pueden seleccionar los directorios donde estén alojados los ficheros de manuales, mapas, guías e imágenes.
También se puede cambiar el directorio raíz donde se guardan los juegos en formato ZIP.
Por último se puede cambiar el directorio donde estén las ROMs para el MT32.

### 2.3 Ficheros de configuración
Aquí puedes seleccionar ficheros de configuración personalizados para los tres emuladores.

### 2.4 Idioma
Gameplay selecciona automáticamente el idioma, pero si quieres seleccionar otro aquí puedes hacerlo.

### 2.5 Visualización de juegos
Aquí puedes modificar como se muestran los juegos en la lista general.
- Leer los valores de los juegos predeterminados: Si seleccionas esta opción y además activas las 'opciones avanzadas' en la pantalla principal, si pulsas el botón de 'modificar/borrar juegos' podrás modificar los valores de los juegos predeterminados. Ten en cuenta que puedes modificar los valores o borrar el juego, pero cuando cierres el programa y vuelvas a entrar, se cargarán de nuevo los valores  originales.
- Mostrar todos los juegos: Si seleccionas esta opción, se mostrarán todos los juegos reconocidos (predeterminados y añadidos manualmente), funcionen o no.
- Mostrar solo los juegos que no funcionan: Se mostrarán los juegos que no funcionan (al revés del listado normal)
- Mostrar solo los juegos añadidos: Se listarán sólo los juegos que se han añadido manualmente.

### 2.6 Valores por defecto
Restaura la configuración original. (_Botón del pánico_)

---
## 3. Añadir / Modificar / Borrar Juegos (Opciones Avanzadas)

![Modificar Juegos](https://i.ibb.co/VYw0Y7q8/add-game-040-es.png)

Si pulsas la opción en la pantalla principal 'Opciones Avanzadas' aparecerán dos botones extras, 'Añadir Juegos' y 'Modificar/Borrar Juegos'.<br>
En este menú, puedes añadir juegos nuevos que se añadirán a la lista principal junto con los que vienen por defecto o puedes modificar los juegos ya añadidos.<br>
Por defecto, no se pueden modificar los valores de los juegos que vienen en el listado por defecto, pero si quieres cambiarlos, deberás activar la opción 'Leer los valores de los juegos fijos' en la pantalla de 'Configuración Avanzada'. Los valores de los juegos predeterminados, sólo se modificarán en el momento, si cierras la Gameplay y vuelves lo vuelves a abrir, los valores volverán a la normalidad.<br>
En cambio, si el juego lo has añadido manualmente, si podrás modificar los valores y estos se guardarán.

### Parámetros configurables
- **Nombre completo**: Nombre que aparecerá en el listado
- **Nombre de la imagen**: Aquí se especifica el nombre del fichero de la imagen de previsualización. Hay que tener varias cosas en cuenta, el nombre del fichero real debe finalizar con '_000' y el formato debe ser PNG, pero en este apartado no tienes que poner '_000.png' sólo el nombre. Por ejemplo, tenemos un fichero de imagen con el nombre 'rastan_000.png', si ponemos 'rastan' veremos que carga la imagen. Si queremos añadir más imágenes que vayan rotando cada segundo, simplemente deberemos llamarlas con '001', '002', etc. Siguiendo el ejemplo si tenemos tres ficheros de imágenes 'rastan_000.png', 'rastan_001.png' y 'rastan_002.png', veremos como se cargan las tres imágenes rotando con un segundo de tiempo entre cada una.
- **Año de publicación y compañía**: Información del juego, es opcional.
- **Compatible con ScummVM**: Si el juego está en el listado de los soportados por ScummVM, marca esta casilla. Cuando selecciones el motor de emulación ScummVM, este juego aparecerá en el listado
-  **Sólo funciona en ScummVM**: El juego sólo funciona con el motor ScummVM, por lo que no se listará cuando se seleccione los otros motores. (Ejemplo: 'Arthur Teacher Trouble')
- **Directorio/Fichero ZIP**: Aquí se debe indicar el directorio (en caso de que no esté comprimido) o el nombre del fichero ZIP. En caso de no estar comprimido, el directorio con el juego debe estar en el mismo lugar que Gameplay.
- **Fichero Ejecutable**: Aquí hay que indicar el nombre completo del fichero ejecutable del juego, con su extensión, puede ser '.exe', '.com', '.bat', etc. En el caso de que sea una imagen de disco con extensión '.img', se desbloqueará la casilla 'Imagen Segundo Disco' donde se podrá añadir una imagen de un segundo disco de forma opcional. Gameplay comprueba que este fichero exista, ya sea en la carpeta del juego o dentro del fichero ZIP, en caso de no existir, no se puede continuar
- **Parámetros**: Aquí hay que poner los parámetros que queremos pasarle al fichero que ejecuta el juego (Ejemplo: 'Maniac Mansion')
- **Ejecutar ANTES**: Puedes indicar comandos de MSDOS que quieres ejecutar antes de arrancar el juego, por ejemplo copiar ficheros, montar unidades de disco, etc. (Ejemplo: 'Renegade')
- **Ejecutar DESPUES**: Puedes indicar comandos de MSDOS que quieres ejecutar después de arrancar el juego (Ejemplo: 'Doom')
- **Programa de Instalación**: Si quieres ejecutar un juego, pero antes necesita ejecutar un programa de instalación, puedes indicarlo aquí y se ejecutará antes que el juego (Ejemplo: 'Lost Vikings')
- **CD-ROM**: Si el juego tiene una imagen iso o cue aquí puedes añadir el fichero y Gameplay lo montará antes de empezar el juego (Ejemplo: 'Mortal Kombat 3')
- **Ciclos CPU**: La cantidad de ciclos CPU que quieres para el juego, cuantos más ciclos más rápida será la CPU emulada, y algunos juegos podrían ir demasiado rápidos. Si pones '1' Gameplay ejecutará la emulación a máxima velocidad, si pones '-1' la ejecutará como 'auto' y dejará en manos del emulador la velocidad.
- **Tipo Ordenador**: Debes elegir que tipo de ordenador va a ejecutar el juego
- **Memoria RAM**: La cantidad de memoria asignada para el juego
- **Activar GUS**: Si el juego es compatible con la tarjeta de audio Gravis Ultra Sound, activa esta casilla (Ejemplo: 'Doom')
- **Fichero mapa de teclado**: Si configuras el teclado de una forma especial y quieres que se cargue, aquí lo puedes indicar el fichero de mapeo de teclas (Ejemplo: 'Bruce Lee')
- **Mensaje información/ayuda**: Cuando un juego arranca, se puede abrir una ventana con información referida al juego, por ejemplo que teclas pulsar para que arranque con VGA y adlib. En este recuadro se pone ese mensaje. (Ejemplo 'Gobliins')
- **Parámetros Extra DOSBOX**: Si necesitas añadir parámetros específicos para que el juego funcione, los puedes poner aquí. (Ejemplo: 'Battle Chess 4000')
- **Manuales, Mapas y Guías**: Puedes añadir cualquier documento para que cuando se pulse el botón se abra. Si hay más de un documento que quieras que se abra (por ejemplo varios manuales), puedes separarlos por el símbolo '$' (Ejemplo 'manual1.pdf$manual2.pdf$manual3.txt$) y se abrirán todos a la vez. Si son una cantidad importante de ficheros, puedes indicar un directorio simplemente terminando el nombre con el carácter '`\`' y cuando se pulse el botón correspondiente se abrirá la carpeta seleccionada (ten en cuenta que debe estar dentro de la ruta indicada en la configuración). Ejemplo: 'Leisure Suir Larry in the Land of the Lounge Lizards'
- **Idioma**: Aquí puedes seleccionar el idioma del juego, para luego con los filtros de idioma poder seleccionarlo. El idioma 'General' significa que sólo tiene un idioma, por lo que no se puede filtrar.
- **Tipo**: Aquí se puede seleccionar el tipo de juego, para poder filtrarlo más tarde en los filtros de la pantalla principal.
---
### 4. Jugar en Linux
Si tienes algún problema ejecutando Gameplay tras descomprimir el fichero, debes ejecutar el siguiente comando en la misma carpeta donde lo has descomprimido (esto añadirá el atributo de ejecutable)<br>
<pre>
bash fix_linux_exec.sh
</pre>
Para añadir los motores y posteriormente configurarlos en gameplay en un Linux, lo más sencillo es utilizar la herramienta 'snap'.<br>
Una vez la tengas instalada (consulta Google para ver tu distro e instalar la herramienta) ejecuta lo siguiente:<br>
<pre>
sudo snap install dosbox-x
sudo snap install dosbox-staging
sudo snap install scummvm
</pre>
Una vez terminada la instalación de los tres motores, deberás ejecutar los siguientes comandos para localizar los ejecutables y poder ponerlos en la configuración de Gameplay:<br>
<pre>
whereis dosbox-x
whereis dosbox-staging
whereis scummvm
</pre>
El motor de *DSP Emulator*, ya viene listo para ejecutar.