# Agent Instructions for `app-menubar-builder`

Scope: all files in this repository.

## General guidelines

- Keep changes minimal and focused on the requested behavior.
- Preserve the existing AppleScript-based design and Finder integration (toolbar button and Script menu).
- Prefer AppleScript and simple shell scripts over adding new languages or heavy dependencies.
- Do not commit generated Office files or other large binaries beyond what the user explicitly includes.
- Avoid adding external services, network calls, or build tooling unless the user requests it.

## AppleScript style

- Keep scripts small and readable; avoid unnecessary abstraction.
- Use clear English for dialogs and comments.
- Do not rely on non‑portable paths other than those explicitly documented (for example, the user’s Office templates path).

## Git & releases

- Use a single main branch (`main`) unless the user requests otherwise.
- When tagging releases, include concise notes describing user‑visible behavior changes.

