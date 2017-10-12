Option Explicit

'---------------------
' CONFIGURATION START
'---------------------
'Display a summary in a message box when the conversions are complete
Const SUMMARY_DISPLAY = TRUE
Const SUMMARY_TITLE = "Conversion Complete"

'File extensions for PDFs
Const PDF_Extension = "pdf"

'Results for CheckFile Function
Const CHECKFILE_OK = 0
Const CHECKFILE_FileDoesNotExist = 1
Const CHECKFILE_NotMSOFile = 2

'Settings to produce PDFs from the applications
Const EXCEL_PDF = 0
Const EXCEL_QualityStandard = 0
Const WORD_PDF = 17
Const POWERPOINT_PDF = 32

'File types returned from OfficeFileType function
Const FILE_TYPE_NotOffice = 0
Const FILE_TYPE_Word = 1
Const FILE_TYPE_Excel = 2
Const FILE_TYPE_PowerPoint = 3

'Valid file type lists
Const FILE_TYPE_DELIMITER = "|"
Dim g_strFileTypesWord
g_strFileTypesWord="|DOC|DOCX|"
Dim g_strFileTypesExcel
g_strFileTypesExcel="|XLS|XLSX|"
Dim g_strFileTypesPowerPoint
g_strFileTypesPowerPoint="|PPT|PPTX|"
'----------------------
' CONFIGURATION FINISH
'----------------------


'Call the main routine
Main
'--------------------
' MAIN ROUTINE START
'--------------------
Sub Main()
    Dim colArgs, intCounter, objFSO, strFilePath

    'Get the command line arguments for the script
    ' - Each chould be a file to be processed
    Set colArgs = Wscript.Arguments
    If colArgs.Count > 0 Then
        For intCounter = 0 to colArgs.Count - 1
            strFilePath = Wscript.Arguments(intCounter)

            'Check we have a valid file and process it
            Select Case CheckFile(strFilePath)
                Case CHECKFILE_OK
                    Select Case OfficeFileType(strFilePath)
                        Case FILE_TYPE_Word
                            SaveWordAsPDF strFilePath

                        Case FILE_TYPE_Excel
                            SaveExcelAsPDF strFilePath

                        Case FILE_TYPE_PowerPoint
                            SavePowerPointAsPDF strFilePath
                    End Select

                Case CHECKFILE_FileDoesNotExist
                    MsgBox """" & strFilePath & """", vbCritical, "File " & intCounter & " does not exist"
                    WScript.Quit

                Case CHECKFILE_NotMSOFile
                    MsgBox """" & strFilePath & """", vbCritical, "File " & intCounter & " is not a valid file type"
                    WScript.Quit
            End Select
        Next
    Else
        'If there's not even one argument/file to process then exit
        Msgbox "Please pass a file to this script", 48,"No File Provided"
        WScript.Quit
    End If


    'Display an optional summary message
    If SUMMARY_DISPLAY then
        If colArgs.Count > 1 then
            MsgBox CStr(colArgs.Count) & " files converted.", vbInformation, SUMMARY_TITLE
        Else
            MsgBox "1 file converted.", vbInformation, SUMMARY_TITLE
        End If
    End If
End Sub
'---------------------
' MAIN ROUTINE FINISH
'---------------------


'--------------------
' SUB-ROUTINES START
'--------------------
Sub SaveExcelAsPDF(p_strFilePath)
    'Save Excel file as a PDF

    'Initialise
    Dim objExcel, objWorkbook
    Set objExcel = CreateObject("Excel.Application")

    'Open the file
    Set objWorkbook = objExcel.Workbooks.Open(p_strFilePath)

    'Save the PDF
    objWorkbook.ExportAsFixedFormat EXCEL_PDF, PathOfPDF(p_strFilePath), EXCEL_QualityStandard, TRUE, FALSE, , , FALSE

    'Close the file and exit the application
    objWorkbook.Close FALSE
    objExcel.Quit
End Sub


Sub SaveWordAsPDF(p_strFilePath)
    'Save Word file as a PDF

    'Initialise
    Dim objWord, objDocument
    Set objWord = CreateObject("Word.Application")

    'Open the file
    Set objDocument = objWord.Documents.Open(p_strFilePath)

    'Save the PDF
    objDocument.SaveAs PathOfPDF(p_strFilePath), WORD_PDF

    'Close the file and exit the application
    objDocument.Close FALSE
    objWord.Quit
End Sub


Sub SavePowerPointAsPDF(p_strFilePath)
    'Save PowerPoint file as a PDF (slides only)

    'Initialise
    Dim objPowerPoint, objSlideDeck
    Set objPowerPoint = CreateObject("PowerPoint.Application")

    'PowerPoint errors if it isn't visible :-(
    'objPowerPoint.Visible = TRUE

    'Open the file
    Set objSlideDeck = objPowerPoint.Presentations.Open(p_strFilePath, , , FALSE)

    'Save the PDF
    objSlideDeck.SaveAs PathOfPDF(p_strFilePath), POWERPOINT_PDF, True

    'Close the file and exit the application
    objSlideDeck.Close
    objPowerPoint.Quit
End Sub
'---------------------
' SUB-ROUTINES FINISH
'---------------------


'-----------------
' FUNCTIONS START
'-----------------
Function CheckFile(p_strFilePath)
    'Check file exists and is an office file (Excel, Word, PowerPoint)

    'Initialise
    Dim objFSO
    Set objFSO = CreateObject("Scripting.FileSystemObject")

    'Check the file exists and is an office file
    If IsOfficeFile(p_strFilePath) then
        If objFSO.FileExists(p_strFilePath) then
            CheckFile = CHECKFILE_OK
        Else
            CheckFile = CHECKFILE_FileDoesNotExist
        End If
    Else
        CheckFile = CHECKFILE_NotMSOFile
    End If
End Function


Function OfficeFileType(p_strFilePath)
    'Returns the type of office file, based upon file extension

    OfficeFileType = FILE_TYPE_NotOffice

    If IsWordFile(p_strFilePath) then
        OfficeFileType = FILE_TYPE_Word
    End If

    If IsExcelFile(p_strFilePath) then
        OfficeFileType = FILE_TYPE_Excel
    End If

    If IsPowerPointFile(p_strFilePath) then
        OfficeFileType = FILE_TYPE_PowerPoint
    End If
End Function

Function IsOfficeFile(p_strFilePath)
    'Returns true if a file is an office file (Excel, Word, PowerPoint)

    IsOfficeFile = IsWordFile(p_strFilePath) OR IsExcelFile(p_strFilePath) OR IsPowerPointFile(p_strFilePath)
End Function


Function IsWordFile(p_strFilePath)
    'Returns true if a file is a Word file

    IsWordFile = IsInList(GetFileExtension(p_strFilePath), g_strFileTypesWord)
End Function


Function IsExcelFile(p_strFilePath)
'Returns true if a file is an Excel file

    IsExcelFile = IsInList(GetFileExtension(p_strFilePath), g_strFileTypesExcel)
End Function


Function IsPowerPointFile(p_strFilePath)
'Returns true if a file is a PowerPoint file

    IsPowerPointFile = IsInList(GetFileExtension(p_strFilePath), g_strFileTypesPowerPoint)
End Function


Function IsInList(p_strSearchFor, p_strSearchIn)
    'Search a delimited list for a text string and return true if it's found

    Dim intResult

    intResult = InStr(1, p_strSearchIn, FILE_TYPE_DELIMITER & p_strSearchFor & FILE_TYPE_DELIMITER, vbTextCompare)

    If IsNull(intResult) then
        IsInList = FALSE
    Else
        If intResult = 0 then
            IsInList = FALSE
        Else
            IsInList = TRUE
        End If
    End If
End Function


Function GetFileExtension(p_strFilePath)
    'Return the file extension from a file path

    Dim objFSO
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    GetFileExtension = objFSO.GetExtensionName(p_strFilePath)
End Function


Function PathOfPDF(p_strOriginalFilePath)
    'Return the path for the PDF file
    'The path will be the same as the original file but with a different file extension

    Dim objFSO

    'Initialise
    Set objFSO = CreateObject("Scripting.FileSystemObject")

        'Build the file path
    'Set the directory
    PathOfPDF = objFSO.GetParentFolderName(p_strOriginalFilePath) & "\"

    'Add the original file name without the extension
    PathOfPDF = PathOfPDF & Left(objFSO.GetFileName(p_strOriginalFilePath), Len(objFSO.GetFileName(p_strOriginalFilePath)) - Len(objFSO.GetExtensionName(p_strOriginalFilePath)))

    'Finally add the the new file extension
    PathOfPDF = PathOfPDF & PDF_Extension
End Function
'------------------
' FUNCTIONS FINISH
'------------------