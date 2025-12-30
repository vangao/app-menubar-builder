import AppKit
import Foundation

// MARK: - AppleScript Helper (from reference app)

func runAppleScript(_ source: String) -> NSAppleEventDescriptor? {
    var error: NSDictionary?
    guard let script = NSAppleScript(source: source) else { return nil }
    let result = script.executeAndReturnError(&error)
    if let error = error {
        _ = error // Suppress unused warning
    }
    return result
}

// MARK: - Finder Directory (from reference app)

func frontFinderDirectory() -> URL {
    let script = """
    tell application "Finder"
      if (count of windows) is 0 then
        return POSIX path of (path to desktop)
      else
        try
          return POSIX path of (target of front window as alias)
        on error
          return POSIX path of (path to desktop)
        end try
      end if
    end tell
    """
    if let desc = runAppleScript(script), let path = desc.stringValue {
        return URL(fileURLWithPath: path, isDirectory: true)
    }
    let desktop = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    return desktop
}

// MARK: - Dialog

func askForFileName() -> String? {
    let script = """
    tell current application
        activate
        try
            set dialogResult to display dialog "Enter file name (with extension):" default answer "tmp.docx" buttons {"Cancel", "OK"} default button "OK" with title "New File"
            return text returned of dialogResult
        on error
            return ""
        end try
    end tell
    """
    if let desc = runAppleScript(script), let result = desc.stringValue, !result.isEmpty {
        return result
    }
    return nil
}

// MARK: - File Creation

func copyTemplate(to destination: URL, ext: String) throws {
    let fm = FileManager.default
    let home = fm.homeDirectoryForCurrentUser
    let templatesDir = home.appendingPathComponent("Documents/office_365_templates")
    
    var templateName: String?
    switch ext.lowercased() {
    case "docx": templateName = "Doc.docx"
    case "xlsx", "xls": templateName = "Book.xlsx"
    case "pptx": templateName = "Presentation.pptx"
    default: templateName = nil
    }
    
    if let name = templateName {
        let templatePath = templatesDir.appendingPathComponent(name)
        if fm.fileExists(atPath: templatePath.path) {
            try fm.copyItem(at: templatePath, to: destination)
            return
        }
    }
    
    // Default: create empty file
    try Data().write(to: destination)
}

func displayNotification(title: String, body: String) {
    let safeTitle = title.replacingOccurrences(of: "\"", with: "\\\"")
    let safeBody = body.replacingOccurrences(of: "\"", with: "\\\"")
    let script = "display notification \"\(safeBody)\" with title \"\(safeTitle)\" sound name \"default\""
    _ = runAppleScript(script)
}

// MARK: - Main

func main() {
    // Get filename from user
    guard let fileName = askForFileName() else {
        exit(0)
    }
    
    // Get target directory
    let dir = frontFinderDirectory()
    let destination = dir.appendingPathComponent(fileName)
    let fm = FileManager.default
    
    // Check if file exists
    if fm.fileExists(atPath: destination.path) {
        displayNotification(title: "New File", body: "File '\(fileName)' already exists.")
        exit(1)
    }
    
    // Create file
    do {
        let ext = destination.pathExtension
        try copyTemplate(to: destination, ext: ext)
        
        // Reveal in Finder
        NSWorkspace.shared.selectFile(destination.path, inFileViewerRootedAtPath: dir.path)
        
        displayNotification(title: "New File Created", body: destination.path)
    } catch {
        displayNotification(title: "Error", body: error.localizedDescription)
        exit(1)
    }
}

main()
