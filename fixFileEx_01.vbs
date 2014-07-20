option Explicit

' variables
const ForReading = 1
dim fileSysOb
dim objFolder
dim obOutFile
dim obFiles
dim obFile
dim origName
dim splitName
dim fullName
dim fileEx
dim filename
dim i
dim fN
dim folderName
dim ex1
dim ex2

folderName = InputBox("What is the path to the directory you want to check? ", "directory?")
ex1 = InputBox("What is the extension you wish to fix? ", "extension to find")
ex2 = InputBox("What is the extension you wish to replace it with? ", "extension to use")

' create the file system object to use in the program
set fileSysOb = CreateObject("Scripting.FileSystemObject")
' create a folder instance (make this an input)
set objFolder = fileSysOb.getFolder(folderName)
' set the contents of the folder to the obFiles array object
set obFiles = objFolder.Files
i = 0
'cycle through the folder file by file
For Each obFile in obFiles
	'if its an email change it to a text file for reading
	if lcase(fileSysOb.GetExtensionName(obFile.Name)) = ex1 then
		origName = obFile.Name
		splitName = Split(origName, ".", 2)
		
		fN = splitName(0) & "." & ex2
		obFile.name = fN
		
	End if
Next 
