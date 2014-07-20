option Explicit

' variables
const ForReading = 1
dim fileSysOb
dim objFolder
dim objFolder2
dim obFiles2
dim obFile2
dim obOutFile
dim obFiles
dim obFile
dim origName
dim splitName
dim fullName
dim fileEx
dim filename
dim fN
dim rfOb
dim fileStr
dim folderPath

' create the file system object to use in the program
set fileSysOb = CreateObject("Scripting.FileSystemObject")

'create the folder to put the emails in, if it doesn't already exist
if NOT fileSysOb.FolderExists("c:\emailBin") then
	fileSysOb.CreateFolder("c:\emailBin")	
	fileSysOb.CreateFolder("c:\emailBin\troubleMail")
End If

folderPath = InputBox("what is the directory to search?", "Path to Email Directory?")
' create a folder instance (make this an input)
set objFolder = fileSysOb.getFolder(folderPath)
set objFolder2 = fileSysOb.getFolder("C:\emailBin")
' set the contents of the folder to the obFiles array object
set obFiles = objFolder.Files
set obFiles2 = objFolder2.Files

folderPath = folderPath + "\"

'cycle through the folder file by file
For Each obFile in obFiles

	'if its an email move it to the temporary folder
	if lcase(fileSysOb.GetExtensionName(obFile.Name)) = "msg" then

		origName = obFile.Name
		
		fileSysOb.MoveFile folderPath & origName, "c:\emailBin\" & origName
		
	End if
Next 

For Each obFile2 in obFiles2

	'if its an email change it to a text file for reading
	if lcase(fileSysOb.GetExtensionName(obFile2.Name)) = "msg" then

		origName = obFile2.Name
		
		splitName = Split(origName, ".", 2)
		
		fN = splitName(0) & ".txt"
	
		obFile2.name = fN
		
	End if
Next 

'cycle through again and read the files
For Each obFile2 in obFiles2
	if lcase(fileSysOb.getExtensionName(obFile2.Name)) = "txt" then
			dim objRegEx
			dim colMatches
			dim strReturnStr
			dim Match
			dim VBCrLf
			
			origName = obFile2.Name
			
			set rfOb = fileSysOb.OpenTextFile("c:\emailBin\" & origName, ForReading)
			fileStr = rfOb.ReadAll

			rfOb.Close

			Set objRegEx = CreateObject("VBScript.RegExp")
			objRegEx.IgnoreCase = True
			objRegEx.Global = True
			
			objRegEx.Pattern = "[^\w\n\\\/\<\>][^ -~]"
			'objRegEx.Pattern = "test" 'this is a test search

			Set colMatches = objRegEx.Execute(fileStr)  
			
			'cycle through the matches and report. Change to move
			For Each Match in colMatches
			WScript.Echo("match(es) found")
			fileSysOb.MoveFile "c:\emailBin\" & origName, "c:\emailBin\troubleMail\" & origName
			exit For
			Next
	End If
Next

tidyUp

Function tidyUp
For Each obFile2 in obFiles2

	'if its an email change it to a text file for reading
	if lcase(fileSysOb.GetExtensionName(obFile2.Name)) = "txt" then

		origName = obFile2.Name
		
		splitName = Split(origName, ".", 2)
		
		fN = splitName(0) & ".msg"
	
		obFile2.name = fN
		
		fileSysOb.MoveFile "c:\emailBin\" & fN, folderPath & fN
		
	End if
Next 
End Function
