# How does it work?

**Gameplay** is divided into several sections.
If you just want to play, **no initial configuration is needed**.

![Main Screen](https://i.ibb.co/BHH34qgY/gameplay-manual.png)

---

## 1. Main Screen

### 1.1 Game Filters
You can choose:
- The game's language.
- The game type.
The list will update based on the selected options.

### 1.2 Emulation Engine
You can choose between three programs to launch the games:

- **DosBox**: Classic emulator, _staging_ version.
- **DosBox-X**: Similar to DosBox, but with additional features.
- **ScummVM**: Only for certain graphic adventures. When selected, the list is automatically adjusted.

> The emulator is configured automatically, you don't need to do anything.

### 1.3 General Options

- **Fullscreen**: The game will start in fullscreen mode
- **Sound**: Enable or disable the sound of the running game
- **Show info/help message**: When a game is launched, a message can be configured to display information such as optimal settings for graphics, sound, keys, etc. This option disables that message.
- **Advanced Options**: Show advanced options, meaning buttons to add, edit or delete games.

### 1.4 Search Game
If you type the name of the game you're looking for, the list will be filtered accordingly.
Press `ESC` to clear the search and show the original list.

### 1.5 Game List

Color codes:
- **Blue**: Game from the default list and available.
- **Yellow**: Manually added game and available.
- **Gray**: Listed game, but with errors and not available.

Play using `ENTER`, double-click, or the _Play_ button.
> If you type a name, it will be searched among the list.

### 1.6 Available Games / Total Games
This counter shows how many games are available / total games including default and manually added ones.<br>
If a game has data issues, it won’t appear unless forced through advanced settings (explained later).

### 1.7 Game Images
Shows one or more rotating images every second.

### 1.8 Play
Click this button to run the selected game, or double-click a game in the list.

### 1.9 Game Info
Shows the **company** and **year** of release.

### 1.10 Manual, Guide or Maps
If a game has associated documents (PDF, TXT, images), they can be opened from here.<br>
If there are many files, a folder might open instead.<br>
If the button is disabled, no documents are available.<br>

### 1.11 Advanced Configuration
Access the advanced menu where you can change:
- Directories
- Executables
- Game list visualization
- Etc...

---

## 2. Advanced Configuration

![Configuration](https://i.ibb.co/3yGQq0rB/gameplay-config.png)

### 2.1 Executable Files
To run games, Gameplay needs three emulators: DosBox, DosBox-X, and ScummVM.
Here you can change the executable files to use other versions or emulator updates.

### 2.2 Main Directories
Select directories for manuals, maps, guides, and images.
You can also change the root directory for ZIP-compressed games, or the ROMs directory for the MT32.

### 2.3 Configuration Files
You can select custom config files for the three emulators.

### 2.4 Language
Gameplay auto-selects the language, but you can choose a different one here.

### 2.5 Game Display Options
Modify how games appear in the main list:
- Read default game values: If enabled and ‘advanced options’ are active on the main screen, you'll be able to edit/delete default games (changes are temporary).
- Show all games: Displays all recognized games, whether they work or not.
- Show only broken games: Displays only the games that don’t work.
- Show only added games: Shows only manually added games.

### 2.6 Default Values
Restores original settings. (_Panic button_)

---

## 3. Add / Edit / Delete Games (Advanced Options)

![Edit Games](https://i.ibb.co/Y4LznW2m/gameplay-save.png)

If you enable 'Advanced Options' on the main screen, two more buttons will appear: 'Add Games' and 'Edit/Delete Games'.<br>
In this menu, you can add new games to the main list or edit existing manually added games.<br>
By default, you can't edit default games. To change them, enable 'Read default game values' in 'Advanced Configuration'. These changes are temporary.<br>
However, manually added games can be edited permanently.

### Configurable Parameters
- **Full Name**: Name shown in the list
- **Image Name**: Filename of the preview image. It must end with '_000' and be in PNG format. Just input the base name (e.g., 'rastan'). Additional rotating images should be named '001', '002', etc.
- **Year and Company**: Optional game info.
- **ZIP Archive**: Mark if the game is zipped. File must be in the directory set in 'Advanced Configuration'.
- **Compatible with ScummVM**: Check if the game is supported by ScummVM.
- **Directory/ZIP File**: Indicate the folder or ZIP file name. If uncompressed, the folder must be in the same location as Gameplay.
- **Executable File**: Full name of the game’s executable (e.g. '.exe', '.com', '.bat'). For disk images ('.img'), a second image option will unlock.
- **Parameters**: Parameters to pass to the executable (e.g., 'Maniac Mansion')
- **Run BEFORE**: DOS commands to run before starting the game (e.g., file copy or disk mount).
- **Run AFTER**: DOS commands to run after launching the game.
- **Installation Program**: Program to run before launching the game (e.g., 'Lost Vikings').
- **CD-ROM**: If the game has an ISO or CUE image, specify it here. Gameplay mounts it before starting the game.
- **CPU Cycles**: Emulated CPU speed. '1' = max speed, '-1' = auto (emulator decides).
- **Computer Type**: Select the type of PC to emulate.
- **RAM Memory**: Memory allocated for the game.
- **Enable GUS**: Enable Gravis Ultra Sound if the game supports it (e.g., 'Doom').
- **Keyboard Map File**: Set a custom keyboard mapping file if needed.
- **Info/Help Message**: Message shown when launching a game (e.g., graphics/sound settings or keys).
- **Extra DOSBOX Parameters**: Add specific parameters for DosBox (e.g., 'Battle Chess 4000').
- **Manuals, Maps, and Guides**: Add documents that open with the info button. Multiple files can be separated by '$'. If too many, specify a folder ending with `'\\'` (must exist in the configured path).
- **Language**: Select the game’s language. 'General' means it’s monolingual and won’t be filtered.
- **Type**: Select the game type to later filter from the main screen.