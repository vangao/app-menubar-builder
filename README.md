# AppleScript Toolbar Helper

Create new DOCX, PPTX, XLSX, and TXT files directly from Finder (menu bar Script menu or toolbar button).

## What this does

The script `NewOfficeFile.applescript`:
- Looks at the current Finder window (or Desktop if no window is open).
- Prompts you for a file name **including extension**, e.g.:
  - `doc1.docx`
  - `sheet1.xlsx`
  - `slides1.pptx`
  - `notes.txt`
- Creates the new file in that folder based on the extension:
  - `.docx` → copies `blank.docx` from `~/Documents/office_365_templates/`
  - `.xlsx` / `.xls` → copies `Book.xlsx`
  - `.pptx` → copies `Presentation.pptx`
  - any other extension (including `.txt`) → creates an empty file with `touch`.

## Setup

1. Make sure your Office templates are here (as you described):
   - `~/Documents/office_365_templates/blank.dotx`
   - `~/Documents/office_365_templates/Book.xltx`
   - `~/Documents/office_365_templates/Presentation.potx`

2. Create the “base” DOCX/XLSX/PPTX files once (to avoid Word/Excel/PowerPoint corruption errors when copying templates directly):
   - Word:
     - Open `blank.dotx` in Word.
     - Save As `blank.docx` into the same folder `~/Documents/office_365_templates/`.
   - Excel:
     - Open `Book.xltx` in Excel.
     - Save As `Book.xlsx` into the same folder.
   - PowerPoint:
     - Open `Presentation.potx` in PowerPoint.
     - Save As `Presentation.pptx` into the same folder.

2. Compile the script into an app from the command line:
   ```bash
   cd ~/projects/other_projects/app-menubar-builder
   mkdir -p ~/Applications
   osacompile -o ~/Applications/NewOfficeFile.app NewOfficeFile.applescript
   ```

## Use from Finder Script menu

1. Enable the Script menu (if you haven’t already):
   - Open the `Script Editor` app.
   - In preferences, enable “Show Script menu in menu bar”.

2. Install the script for Finder:
   - In Finder, go to `~/Library/Scripts/Applications/Finder/` (create folders if they don’t exist).
   - Copy your `NewOfficeFile.app` (or compiled script) into this folder.

3. In Finder, you should now see it under the Script menu (the scroll icon) when Finder is active.

## Use as a Finder toolbar button

1. Put `NewOfficeFile.app` somewhere convenient (e.g. `~/Applications`).
2. In Finder, open a window and choose `View › Customize Toolbar…`.
3. Drag `NewOfficeFile.app` into the toolbar area.
4. Click the new toolbar icon whenever you want to create a new DOCX/PPTX/XLSX/TXT in the current folder.
