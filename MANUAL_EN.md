# How does it work?

**GamePlay** is divided into several sections.  
If you just want to play, **there is no need to configure anything initially**.

![Main Screen](https://i.ibb.co/V0jXJtKb/gameplay-082-en.png)

---

# 1. Main Screen

## 1.1 Game Filters
You can choose the type of game, and the game list will update according to the selected options.

## 1.2 System to Emulate
You can choose between:
- **MS-DOS**: Games for the MS-DOS system.
- **Windows 3.1**: Games for Windows 3.1
- **Windows 98**: Games for Windows 95/98
- **ScummVM**: Only for certain graphic adventures.
- **DSP Emulator**: Emulator for arcade machines, 8-bit computers, and consoles
- **Apple II**: Games for the Apple II computer series
- **Atari 800**: Games for the Atari 800 computer series
- **Atari ST**: Games for the Atari ST computer series
- **Amiga**: Games for the Amiga computer

> The emulator is configured automatically, you do not need to do anything.

---

## 1.3 General Options
- **Fullscreen**: The game will start in fullscreen mode
- **Sound**: Enable or disable sound
- **Show info/help message**: When a game is launched, a message with startup information can be displayed. This option disables that message.
- **Advanced Options**: Show advanced options.

---

## 1.4 Game List
The main screen displays the list of available games for the selected emulator. A color code provides information about each game:
- **Blue**: Game ready to run
- **Yellow**: Manually added game ready to run
- **Gray**: Game not available. When you try to launch it, a dialog will appear allowing you to download it.
- **Purple**: Game that only works with the ScummVM engine, ready to run.

To play, press `ENTER` or double-click the game.  
Additionally, pressing the `DELETE` key removes the game from the list (not permanently). To restore it, you can undo the action in the game's advanced options.

> If the game is not available, a download option will appear.

---

## 1.5 Available Games / Total Games
This counter shows how many games are available / how many games exist in total, including both the built-in GamePlay list and manually added games.

---

## 1.6 Game Images
Displays one or more images in a loop, changing every second if more than one image is available.

---

## 1.7 Game Information
Displays the **company** and **year** of publication.

---

## 1.8 Manuals, Guides, or Maps
If the game has associated documents (PDF, TXT, images), they can be opened from here.  
If there are many files, a folder containing the content may be opened instead.

---

## 1.9 Select Version or Language
Some games have different versions or languages. GamePlay automatically selects the best version and language, but you can choose another version from this dropdown list.

---

## 1.10 Advanced Configuration
Access to the advanced menu, where you can change:
- Main directories
- Language
- Emulator configuration files
- Default values

---

# 2. Advanced Configuration

![Configuration](https://i.ibb.co/Hfyjwj8B/config-082-en.png)

## 2.1 Configuration Files
To launch games, GamePlay requires emulator configuration files. These files are included with GamePlay, but by switching tabs you can select different configuration files if desired.

---

## 2.2 Main Directories
Here you can select the directories where manuals, maps, guides, and image files are stored.  
You can also change the root directory where ZIP game files are stored.  
Finally, you can change the directory containing the MT32 ROMs.

---

## 2.3 Language
GamePlay automatically selects the language, but you can manually choose another language here if desired.

---

## 2.4 Game Display
Here you can modify how games are shown in the main list.
- **Read values from default games**: If this option is enabled and "Advanced Options" are also enabled on the main screen, pressing the "Modify/Delete Games" button will allow you to modify the values of the default games. Keep in mind that any changes or deletions will only be temporary; when you close and reopen GamePlay, the original values will be restored.
- **Show only added games**: Only manually added games will be displayed.

---

## 2.5 Default Values
Restores the original configuration. (_Panic button_)

---

# 3. Add / Modify / Delete Games (Advanced Options)

![Modify Games](https://i.ibb.co/whHTg15s/add-082-en.png)

If you enable the "Advanced Options" setting on the main screen, two additional buttons will appear: "Add Games" and "Modify/Delete Games".  
In this menu, you can add new games to the main list alongside the default ones, or modify already added games.  

By default, you cannot modify the values of games included in the default list. To do so, you must enable the option "Read values from default games" in the "Advanced Configuration" screen. Changes to default games are temporary and will revert after restarting GamePlay.  

However, games added manually can be permanently modified and saved.  

Depending on the selected tab, different options will appear.

---

## Configurable Parameters

- **Full Name**: Name displayed in the list
- **Image Name**: Specifies the preview image filename. The actual filename must end with `_000` and use PNG format, but here you only enter the base name. Example: if the image file is named `rastan_000.png`, entering `rastan` will load the image. Additional rotating images can be added using `_001`, `_002`, etc.
- **Publication Year and Company**: Optional game information.
- **ScummVM Compatible**: Check this if the game is supported by ScummVM. The game will appear when the ScummVM engine is selected.
- **Works Only in ScummVM**: The game only works with the ScummVM engine and will not appear with other emulators. (Example: `Arthur Teacher Trouble`)
- **Directory/ZIP File**: Specify the directory (if uncompressed) or ZIP filename. If uncompressed, the game directory must be in the same location as GamePlay.
- **Executable File**: Full executable filename including extension (`.exe`, `.com`, `.bat`, etc.). If it is a disk image with `.img` extension, the "Second Disk Image" option will be enabled to optionally add a second disk image. GamePlay checks whether the file exists either inside the game folder or ZIP file.
- **Parameters**: Command-line parameters passed to the executable. (Example: `Maniac Mansion`)
- **Run BEFORE**: MS-DOS commands to execute before launching the game. (Example: `Renegade`)
- **Run AFTER**: MS-DOS commands to execute after launching the game. (Example: `Doom`)
- **Setup Program**: If the game requires an installation/setup program before running, specify it here. It will execute when pressing the setup button. (Example: `Lost Vikings`)
- **CD-ROM**: If the game uses an ISO or CUE image, specify it here and GamePlay will mount it before starting the game. (Example: `Mortal Kombat 3`)
- **CPU Cycles**: CPU cycle count for the game. Higher values make the emulated CPU faster. `1` runs at maximum speed, `-1` uses automatic mode.
- **Computer Type**: Select the computer type used to run the game.
- **RAM Memory**: Amount of RAM assigned to the game.
- **Enable GUS**: Enable Gravis UltraSound support if the game supports it. (Example: `Doom`)
- **Keyboard Mapping File**: Specify a custom keyboard mapping file if needed. (Example: `Bruce Lee`)
- **Info/Help Message**: Optional information displayed when launching the game. (Example: `Gobliins`)
- **Extra DOSBox Parameters**: Additional DOSBox parameters required for certain games. (Example: `Battle Chess 4000`)
- **Manuals, Maps, and Guides**: Add documents to open when pressing the corresponding button. Multiple files can be separated using `$`. If there are many files, specify a directory ending with `\` to open the folder directly.
- **Language**: Select the game's language for filtering purposes. `General` means the game only has one language.
- **Type**: Select the game type for filtering in the main screen.

---

# 4. Playing on Linux or Mac

Due to recent changes, the Linux and Mac versions are currently a work in progress.
