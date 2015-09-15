#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Imgs\Icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=R.S.S.
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>

#include ".\Skins\Cosmo.au3"
#include "_UskinLibrary.au3"


_Uskin_LoadDLL()
_USkin_Init(_Cosmo(True))


Opt("GUIOnEventMode", 1)

Global $GetMapCount, $MapCountComplete, $PersonalFile = "", $PlayerNameAssignment, $PlayerAName, $PlayerBName, $CurrentVetoer = 1, $CurrentVetoerName
Global $GetPlayerAName
Global $FoundProfile = 0, $StopProgram = 0, $MainGui, $ProfileData

Dim $MapCount[8] = [2, 4, 6, 8, 10, 12, $PersonalFile]
Dim $Button[200] = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
Dim $MapButton[20]

	$CheckListProfiles = MsgBox(4, "Profiles..", "Do you wish to list the profiles saved?")
If $CheckListProfiles = 6 Then
	$IniData = IniReadSectionNames(@ScriptDir & "/Data/Profiles.ini")
	If @Error Then
		MsgBox(48, "Error", "No profiles found!")
	EndIf

	_ArrayDisplay($IniData)
EndIf


While $MapCountComplete = ""
$GetMapCount = InputBox("Map Count..", "Please input the amount of maps you will be using: 2, 4, 6, 8, 10, 12 or your personal saved file name")
$CheckProfileName = IniReadSection(@ScriptDir & "/Data/Profiles.ini", $GetMapCount)
If @error Then

For $i = 0 To 7
   If $MapCount[$i] = $GetMapCount Then
	  $MapCountComplete = 1
	  ExitLoop
   EndIf
Next
   Else
	   $PersonalFile = $GetMapCount
	   $MapCountComplete = 1
   EndIf

If $GetMapCount = "" Then
   $MapCountComplete = ""
   MsgBox(48, "Exiting...", "Cancel or no number was input. Exiting program!")
   Exit
EndIf


   If $MapCountComplete = 1 Then
	  Sleep(10)
   Else
	  MsgBox(48, "Error", "Your input was not an appropriate number. Please try again!")
   EndIf
WEnd

While $PlayerNameAssignment = ""
   $GetPlayerAName = InputBox("Name assignment..", "Please input Player A's name!")
   $GetPlayerBName = InputBox("Name assignment..", "Please input Player B's name!")
   If $GetPlayerAName = "" Then
	  $PlayerNameAssignment = 0
   Else
	  $PlayerNameAssignment = 1
   EndIf
   If $PlayerNameAssignment = 1 Then
	  If $GetPlayerBName = "" Then
		 $PlayerNameAssignment = ""
	  Else
		 $PlayerNameAssignment = 1
	  EndIf
   EndIf

	  If $PlayerNameAssignment = "" Then
		 MsgBox(48, "Error", "You did not assign the names properly, please try again!")
	  EndIf

	  If $PlayerNameAssignment = 1 Then
		 $CheckFinished = MsgBox(4, "Name Assignment..", "Are these names correct?" & @CRLF & @CRLF & "Player A: " & $GetPlayerAName & @CRLF & @CRLF & "Player B: " & $GetPlayerBName)
		 If $CheckFinished = 6 Then
			$PlayerNameAssignment = 1
		 Else
			$PlayerNameAssignment = ""
		 EndIf
	  EndIf
   WEnd



If $GetMapCount = 2 Then
   _2MapVeto()
ElseIf $GetMapCount = 4 Then
   _4MapVeto()
ElseIf $GetMapCount = 6 Then
   _6MapVeto()
ElseIf $GetMapCount = 8 Then
   _8MapVeto()
ElseIf $GetMapCount = 10 Then
   _10MapVeto()
ElseIf $GetMapCount = 12 Then
   _12MapVeto()
ElseIf $GetMapCount = $PersonalFile Then
   _SavedMapVeto()
EndIf

Func _2MapVeto()
   $MapVetoGui = GuiCreate("R.S. Map Veto", 950, 450)
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

   GuiCtrlCreateInput($GetPlayerAName, 40, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateInput($GetPlayerBName, 610, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0x1106AB)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateLabel("Current Vetoer", 408, 60, 200, 30)
   GuiCtrlSetFont(-1, 15)

   $CurrentVetoer = GuiCtrlCreateInput($GetPlayerAName, 325, 100, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   $MapButton[1] = GuiCtrlCreateButton("Map 1", 300, 180, 350, 50)
   GuiCtrlSetFont(-1, 15)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[2] = GuiCtrlCreateButton("Map 2", 300, 280, 350, 50)
   GuiCtrlSetFont(-1, 15)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   If $PersonalFile > "" Then
	   For $i = 1 To 2
		   GuiCtrlSetData($MapButton[$i], $ProfileData[$i+1][1])
	   Next
   EndIf


   $SetMapNameButton = GuiCtrlCreateButton("Set Map Names", 20,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SetMapNames")

   $SaveMapProfileButton = GuiCtrlCreateButton("Save Map Profile", 500,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SaveMapProfile")


   GuiSetState()
EndFunc

Func _ButtonPressed()
   $Msg = @Gui_CtrlId
   $MapName = GuiCtrlRead($Msg)
   $Vetoer = GuiCtrlRead($CurrentVetoer)
   $CurrentVetoerName = $Vetoer

   If $Button[$Msg] = 1 Then
	  MsgBox(48, "Error", "This map has already been vetoed, please try again!")
   Else


   $CheckVeto = MsgBox(4, "Veto", "Are you sure you wish to veto: " & $MapName)
   If $CheckVeto = 6 Then
	  If $CurrentVetoerName = $GetPlayerAName Then
		 GuiCtrlSetBkColor($Msg, 0xAB0000)
		 GuiCtrlSetBkColor($CurrentVetoer, 0x1106AB)
		 GuiCtrlSetData($CurrentVetoer, $GetPlayerBName)
		 $Button[$Msg] = 1
	  Else
		 GuiCtrlSetBkColor($Msg, 0x1106AB)
		 GuiCtrlSetBkColor($CurrentVetoer, 0xAB0000)
		 GuiCtrlSetData($CurrentVetoer, $GetPlayerAName)
		 $Button[$Msg] = 1
	  EndIf
   EndIf

EndIf

 EndFunc


Func _4MapVeto()
   $MapVetoGui = GuiCreate("Map Veto", 950, 450)
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")


   GuiCtrlCreateInput($GetPlayerAName, 40, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateInput($GetPlayerBName, 610, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0x1106AB)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateLabel("Current Vetoer", 408, 60, 200, 30)
   GuiCtrlSetFont(-1, 15)

   $CurrentVetoer = GuiCtrlCreateInput($GetPlayerAName, 325, 100, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   $MapButton[1] = GuiCtrlCreateButton("Map 1", 50, 180, 350, 50)
   GuiCtrlSetFont(-1, 15)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[2] = GuiCtrlCreateButton("Map 2", 550, 180, 350, 50)
   GuiCtrlSetFont(-1, 15)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[3] = GuiCtrlCreateButton("Map 3", 50, 280, 350, 50)
   GuiCtrlSetFont(-1, 15)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[4] = GuiCtrlCreateButton("Map 4", 550, 280, 350, 50)
   GuiCtrlSetFont(-1, 15)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

      If $PersonalFile > "" Then
	   For $i = 1 To 4
		   GuiCtrlSetData($MapButton[$i], $ProfileData[$i+1][1])
	   Next
   EndIf

   $SetMapNameButton = GuiCtrlCreateButton("Set Map Names", 20,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SetMapNames")

   $SaveMapProfileButton = GuiCtrlCreateButton("Save Map Profile", 500,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SaveMapProfile")


   GuiSetState()
EndFunc

Func _6MapVeto()
   $MapVetoGui = GuiCreate("Map Veto", 950, 450)
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

   GuiCtrlCreateInput($GetPlayerAName, 40, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateInput($GetPlayerBName, 610, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0x1106AB)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateLabel("Current Vetoer", 408, 60, 200, 30)
   GuiCtrlSetFont(-1, 15)

   $CurrentVetoer = GuiCtrlCreateInput($GetPlayerAName, 325, 100, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   $MapButton[1] = GuiCtrlCreateButton("Map 1", 30, 180, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[2] = GuiCtrlCreateButton("Map 2", 350, 180, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[3] = GuiCtrlCreateButton("Map 3", 670, 180, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[4] = GuiCtrlCreateButton("Map 4", 30, 280, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[5] = GuiCtrlCreateButton("Map 5", 350, 280, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[6] = GuiCtrlCreateButton("Map 6", 670, 280, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

      If $PersonalFile > "" Then
	   For $i = 1 To 6
		   GuiCtrlSetData($MapButton[$i], $ProfileData[$i+1][1])
	   Next
   EndIf

   $SetMapNameButton = GuiCtrlCreateButton("Set Map Names", 20,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SetMapNames")

   $SaveMapProfileButton = GuiCtrlCreateButton("Save Map Profile", 500,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SaveMapProfile")


   GuiSetState()
EndFunc

Func _8MapVeto()
   $MapVetoGui = GuiCreate("Map Veto", 950, 450)
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")


   GuiCtrlCreateInput($GetPlayerAName, 40, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateInput($GetPlayerBName, 610, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0x1106AB)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateLabel("Current Vetoer", 408, 60, 200, 30)
   GuiCtrlSetFont(-1, 15)

   $CurrentVetoer = GuiCtrlCreateInput($GetPlayerAName, 325, 100, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   $MapButton[1] = GuiCtrlCreateButton("Map 1", 30, 160, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[2] = GuiCtrlCreateButton("Map 2", 350, 160, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[3] = GuiCtrlCreateButton("Map 3", 670, 160, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[4] = GuiCtrlCreateButton("Map 4", 30, 250, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[5] = GuiCtrlCreateButton("Map 5", 350, 250, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[6] = GuiCtrlCreateButton("Map 6", 670, 250, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[7] = GuiCtrlCreateButton("Map 7", 195, 340, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[8] = GuiCtrlCreateButton("Map 8", 515, 340, 250, 50)
   GuiCtrlSetFont(-1, 14)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

      If $PersonalFile > "" Then
	   For $i = 1 To 8
		   GuiCtrlSetData($MapButton[$i], $ProfileData[$i+1][1])
	   Next
   EndIf

   $SetMapNameButton = GuiCtrlCreateButton("Set Map Names", 20,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SetMapNames")

   $SaveMapProfileButton = GuiCtrlCreateButton("Save Map Profile", 500,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SaveMapProfile")

GuiSetState()
EndFunc

Func _10MapVeto()
   $MapVetoGui = GuiCreate("Map Veto", 950, 450)
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")


   GuiCtrlCreateInput($GetPlayerAName, 40, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateInput($GetPlayerBName, 610, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0x1106AB)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateLabel("Current Vetoer", 408, 60, 200, 30)
   GuiCtrlSetFont(-1, 15)

   $CurrentVetoer = GuiCtrlCreateInput($GetPlayerAName, 325, 100, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   $MapButton[1] = GuiCtrlCreateButton("Map 1", 45, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[2] = GuiCtrlCreateButton("Map 2", 265, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[3] = GuiCtrlCreateButton("Map 3", 485, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[4] = GuiCtrlCreateButton("Map 4", 705, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[5] = GuiCtrlCreateButton("Map 5", 45, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[6] = GuiCtrlCreateButton("Map 6", 265, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[7] = GuiCtrlCreateButton("Map 7", 485, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[8] = GuiCtrlCreateButton("Map 8", 705, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[9] = GuiCtrlCreateButton("Map 9", 265, 330, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[10] = GuiCtrlCreateButton("Map 10", 485, 330, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

      If $PersonalFile > "" Then
	   For $i = 1 To 10
		   GuiCtrlSetData($MapButton[$i], $ProfileData[$i+1][1])
	   Next
   EndIf

   $SetMapNameButton = GuiCtrlCreateButton("Set Map Names", 20,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SetMapNames")

   $SaveMapProfileButton = GuiCtrlCreateButton("Save Map Profile", 500,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SaveMapProfile")

GuiSetState()
EndFunc

Func _12MapVeto()
   $MapVetoGui = GuiCreate("R.S. Map Veto", 950, 450)
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")


   GuiCtrlCreateInput($GetPlayerAName, 40, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateInput($GetPlayerBName, 610, 10, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0x1106AB)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   GuiCtrlCreateLabel("Current Vetoer", 408, 60, 200, 30)
   GuiCtrlSetFont(-1, 15)

   $CurrentVetoer = GuiCtrlCreateInput($GetPlayerAName, 325, 100, 300, 30, BitOr($ES_READONLY, $ES_CENTER))
   GuiCtrlSetBkColor(-1, 0xAB0000)
   GuiCtrlSetColor(-1, 0xFFFFFF)
   GuiCtrlSetFont(-1, 14)

   $MapButton[1] = GuiCtrlCreateButton("Map 1", 45, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[2] = GuiCtrlCreateButton("Map 2", 265, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[3] = GuiCtrlCreateButton("Map 3", 485, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[4] = GuiCtrlCreateButton("Map 4", 705, 160, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[5] = GuiCtrlCreateButton("Map 5", 45, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[6] = GuiCtrlCreateButton("Map 6", 265, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[7] = GuiCtrlCreateButton("Map 7", 485, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[8] = GuiCtrlCreateButton("Map 8", 705, 245, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[9] = GuiCtrlCreateButton("Map 9", 45, 330, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[10] = GuiCtrlCreateButton("Map 10", 265, 330, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[11] = GuiCtrlCreateButton("Map 11", 485, 330, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

   $MapButton[12] = GuiCtrlCreateButton("Map 12", 705, 330, 200, 50)
   GuiCtrlSetFont(-1, 13)
   GuiCtrlSetBkColor(-1, 0xF2AA03)
   GUICtrlSetOnEvent(-1, "_ButtonPressed")

      If $PersonalFile > "" Then
	   For $i = 1 To 12
		   GuiCtrlSetData($MapButton[$i], $ProfileData[$i+1][1])
	   Next
   EndIf

   $SetMapNameButton = GuiCtrlCreateButton("Set Map Names", 20,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SetMapNames")

   $SaveMapProfileButton = GuiCtrlCreateButton("Save Map Profile", 500,400, 430, 50)
   GuiCtrlSetFont(-1, 15)
   GUICtrlSetOnEvent(-1, "_SaveMapProfile")

GuiSetState()
EndFunc

Func _SavedMapVeto()
	$ProfileData = IniReadSection(@ScriptDir & "/Data/Profiles.ini", $PersonalFile)
	If $ProfileData[1][1] = "2" Then
		_2MapVeto()
	ElseIf $ProfileData[1][1] = "4" Then
		_4MapVeto()
	ElseIf $ProfileData[1][1] = "6" Then
		_6MapVeto()
	ElseIf $ProfileData[1][1] = "8" Then
		_8MapVeto()
	ElseIf $ProfileData[1][1] = "10" Then
		_10MapVeto()
	ElseIf $ProfileData[1][1] = "12" Then
		_12MapVeto()
	EndIf
EndFunc

Func _SetMapNames()
   Global $Count = 0, $MapNumberToEdit
   $CheckSetNames = MsgBox(4, "Set Map Names...", "Are you sure you wish to set the map names?")
   If $CheckSetNames = 6 Then
	  $CheckBulkSet = MsgBox(4, "Set Map Names...", "Do you wish to set names for all maps?")
	  If $CheckBulkSet = 6 Then
		 For $i = 1 To $GetMapCount
			$NewButtonName = InputBox("New Map Name...", "What would you like to label Map " & $i)
			GuiCtrlSetData($MapButton[$i], $NewButtonName)
		 Next
	  Else
		 $GetMapNumberEdit = InputBox("New Map Name...", "Which map would you like to edit, starting from left to right, top to bottom. Map 1 being the top left button.")
		 $NewName = InputBox("New Map Name...", "What would you like to label this map?")
		 GuiCtrlSetData($MapButton[$GetMapNumberEdit], $NewName)
	  EndIf
   EndIf
   Sleep(10)
EndFunc

Func _SaveMapProfile()
	  GuiSetState(@SW_DISABLE, $MainGui)
   $CheckSave = MsgBox(4, "Save Map Profile...", "Would you like to save your current map profile?")
   If $CheckSave = 6 Then
	  $NewProfileName = InputBox("New Profile...", "What would you like to label this new profile?")
	  		 $CheckIni = IniReadSectionNames(@ScriptDir & "/Data/Profiles.ini")
			 If @Error Then
				 $FoundProfile = 0
				 Else
		 For $i = 1 To $CheckIni[0]
			If $CheckIni[$i] = $NewProfileName Then
			   $FoundProfile = 1
			EndIf
		 Next
		 EndIf
		 If $FoundProfile = 1 Then
			MsgBox(64, "Error", "Profile name already found, please label as something else!")
			GuiSetState(@SW_ENABLE, $MainGui)
			WinActivate("R.S. Map Veto")
		 Else
			IniWrite(@ScriptDir & "/Data/Profiles.ini", $NewProfileName, "1", $GetMapCount)
	  For $i = 2 To $GetMapCount + 1
		 $CurrentMap = GuiCtrlRead($MapButton[$i-1])
		 IniWrite(@ScriptDir & "/Data/Profiles.ini", $NewProfileName, $i, $CurrentMap)
	  Next
	  		 MsgBox(0, "New Profile...", "New profile saved!")
			 GuiSetState(@SW_ENABLE, $MainGui)
			 WinActivate("R.S. Map Veto")
		  EndIf
	   Else
		  GuiSetState(@SW_ENABLE, $MainGui)
		  WinActivate("R.S. Map Veto")
Sleep(10)
   EndIf
EndFunc



Func _Exit()
   Exit
EndFunc




While 1
   Sleep(10)
WEnd
