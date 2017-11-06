Attribute VB_Name = "DeleteLine"
Sub DeleteLine()
'
' DeleteLine Macro
'
'
Selection.HomeKey Unit:=wdLine
Selection.EndKey Unit:=wdLine, Extend:=wdExtend
Selection.Delete Unit:=wdCharacter, Count:=1
End Sub