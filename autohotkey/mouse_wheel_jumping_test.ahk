~WheelDown::
GoingDown := True
if GoingUp
{
    MsgBox, , Problem, Mouse wheel is jumping
    VarSetCapacity(GoingDown,0)
}
return

~WheelUp::
GoingUp := True
if GoingDown
{
    MsgBox, , Problem, Mouse wheel is jumping
    VarSetCapacity(GoingUp,0)
}
return