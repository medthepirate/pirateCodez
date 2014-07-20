dim timeInMins
dim timeInHours
dim fso
dim txtFile
dim str
set fso = CreateObject("Scripting.FileSystemObject")
dim listenForBox

If Not WScript.Arguments.Named.Exists("elevate") Then
  CreateObject("Shell.Application").ShellExecute WScript.FullName _
    , WScript.ScriptFullName & " /elevate", "", "runas", 1
  WScript.Quit
End If

if Not fso.FileExists("c:\hours.txt") Then
	fso.CreateTextFile("c:\hours.txt")
	set txtFile = fso.OpenTextFile("c:\hours.txt", 2)
	txtFile.WriteLine("0")
	txtFile.Close
End If

set txtFile = fso.OpenTextFile("c:\hours.txt", 1)
timeInMins = txtFile.ReadAll
txtFile.Close
timeInMins = timeInMins+15
timeInHours = timeInMins/60
set writeFinal = fso.OpenTextFile("c:\hours.txt", 2)
str = FormatNumber(timeInMins)
writeFinal.WriteLine(str)
writeFinal.Close
WScript.Echo("time in minutes: " & timeInMins & " time in hours: " & timeInHours)

listenForBox = MsgBox("reset?", 3,"reset?")

If listenForBox = 6 Then
	set writeFinal = fso.OpenTextFile("c:\hours.txt", 2)
	writeFinal.WriteLine("0")
	writeFinal.Close
Else
	WScript.Quit
End If