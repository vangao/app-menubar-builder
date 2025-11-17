-- NewOfficeFile.applescript
-- Create new DOCX, XLSX, PPTX, and TXT files in the current Finder folder
-- Behavior: click toolbar app, type full file name with extension, script decides what to do based on extension.

on run
	-- Determine target folder: current Finder window or Desktop
	tell application "Finder"
		if (count of windows) is greater than 0 then
			set targetFolder to (target of front window) as alias
		else
			set targetFolder to (path to desktop folder) as alias
		end if
	end tell
	
	-- Ask for file name INCLUDING extension
	set dialogResult to display dialog "Enter file name (with extension):" default answer "tmp.docx"
	set fileName to text returned of dialogResult
	
	if fileName is "" then
		display dialog "File name cannot be empty." buttons {"OK"} default button 1
		return
	end if
	
	-- Extract file extension (part after last dot)
	set AppleScript's text item delimiters to "."
	if (count of text items of fileName) is greater than 1 then
		set fileExtension to text item -1 of fileName
	else
		set fileExtension to ""
	end if
	set AppleScript's text item delimiters to ""
	
	-- Resolve target folder and paths
	set targetDirPOSIX to POSIX path of targetFolder
	set targetPOSIX to targetDirPOSIX & fileName
	
	-- Avoid overwriting existing files
	tell application "Finder"
		if exists file fileName of targetFolder then
			display dialog "A file named \"" & fileName & "\" already exists in this folder." buttons {"OK"} default button 1
			return
		end if
	end tell
	
		try
			if fileExtension is "docx" then
				-- Uses your existing Doc.docx base file
				my copyTemplate("Doc.docx", targetPOSIX)
			else if fileExtension is in {"xlsx", "xls"} then
				my copyTemplate("Book.xlsx", targetPOSIX)
			else if fileExtension is "pptx" then
				my copyTemplate("Presentation.pptx", targetPOSIX)
			else
				-- Default: create empty file (TXT and all other types)
				do shell script "touch " & quoted form of targetPOSIX
			end if
		
		tell application "Finder"
			update targetFolder
			select file fileName of targetFolder
			reveal file fileName of targetFolder
		end tell
	on error errMsg
		display dialog "Error creating file:" & return & errMsg buttons {"OK"} default button 1
	end try
end run

on copyTemplate(templateFileName, targetPOSIX)
	set homePOSIX to (do shell script "printf $HOME") & "/"
	set templatesDirPOSIX to homePOSIX & "Documents/office_365_templates/"
	set templatePOSIX to templatesDirPOSIX & templateFileName
	
	-- This will raise an error (and be shown by caller) if template is missing
	do shell script "cp " & quoted form of templatePOSIX & " " & quoted form of targetPOSIX
end copyTemplate
