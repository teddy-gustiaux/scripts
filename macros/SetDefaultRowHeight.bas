Attribute VB_Name = "SetDefaultRowHeight"
Sub SetDefaultRowHeight()

Dim t As Task

For Each t In ActiveProject.Tasks
    If Not t Is Nothing Then
        SetRowHeight unit:=1, Rows:=t.UniqueID, useuniqueID:=True
    End If
Next t

End Sub

