param (
    [string]$file = $(throw "-file is required."),
    [string]$text = $(throw "-text is required.")
)

$InputFile = Get-Content $file
ForEach($Obj in $InputFile)
{
	$start = $text
	$combine = $start + $Obj
	Add-Content -path "$file-output" -value $combine
}