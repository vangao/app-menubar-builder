# Agent Instructions for `app-menubar-builder`

Scope: all files in this repository.

## Project Overview

This is a **native Swift application** that creates new Office files (DOCX, XLSX, PPTX) and text files from the Finder toolbar.

## Key Files

- `src/main.swift` – Main application source code
- `build.sh` – Compiles the app using `swiftc`
- `NewOfficeFileIcon.png` – App icon

## General Guidelines

- Keep changes minimal and focused on the requested behavior.
- The app uses Swift with AppKit; avoid adding heavy dependencies.
- AppleScript is used only for dialogs and Finder path detection (via `NSAppleScript`).
- Do not commit the compiled `.app` bundle or large binaries.

## Build Process

```bash
./build.sh
```

This compiles `src/main.swift` into `NewOfficeFile.app` in the project directory.

## Git & Releases

- Use a single main branch (`main`) unless the user requests otherwise.
- When tagging releases, include concise notes describing user-visible behavior changes.
