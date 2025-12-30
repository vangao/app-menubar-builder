# NewOfficeFile

A native macOS toolbar app to create new Office files (DOCX, XLSX, PPTX) and text files directly from Finder.

## Features

- Click the toolbar icon → enter a filename with extension → file is created
- Supported formats:
  - `.docx` → copies from `~/Documents/office_365_templates/Doc.docx`
  - `.xlsx` / `.xls` → copies from `~/Documents/office_365_templates/Book.xlsx`
  - `.pptx` → copies from `~/Documents/office_365_templates/Presentation.pptx`
  - Any other extension → creates an empty file
- Automatically reveals the new file in Finder

## Requirements

- macOS 10.13+
- Xcode Command Line Tools (for `swiftc`)

## Setup

### 1. Prepare Office Templates

Place your Office template files in `~/Documents/office_365_templates/`:
- `Doc.docx`
- `Book.xlsx`
- `Presentation.pptx`

### 2. Build the App

```bash
cd /path/to/app-menubar-builder
./build.sh
```

This creates `NewOfficeFile.app` in the project directory.

### 3. Install

Copy to Applications:
```bash
cp -R NewOfficeFile.app /Applications/
```

### 4. Add to Finder Toolbar

1. In Finder, choose **View → Customize Toolbar…**
2. Drag `NewOfficeFile.app` from `/Applications` onto the toolbar
3. Click **Done**

## Usage

1. Navigate to a folder in Finder
2. Click the NewOfficeFile toolbar icon
3. Enter a filename with extension (e.g., `report.docx`)
4. Click OK – the file is created and revealed

## Development

Source code is in `src/main.swift`. After making changes:

```bash
./build.sh
```
