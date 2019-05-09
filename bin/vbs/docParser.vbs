'	
' author: Sergey Trishkin
Function delBadChr(str)
	dim symbsASCII, regExp
	
	Set regExp = New RegExp
	
	regExp.IgnoreCase = True
	regExp.Global     = True
	regExp.Pattern    = "[^а-я1-9 !:]"

    delBadChr = regExp.Replace(str, "")

End Function

Function wBook(objExcel, path)
	dim workBook

	If fso.FileExists(path) = True then
		Set workBook = objExcel.Workbooks.Open(path)
	else
		Set workBook = objExcel.Workbooks.Add()
		workBook.saveAs path, ConflictResolution=False
	end if

	Set wBook = workBook

End Function

Function createrTable(objDoc, objWord, excelDocPath, columnIndex, colName)
	dim cell, objExcel

	Set objExcel    = CreateObject("Excel.Application")
	Set iTable      = objWord.ActiveDocument.Tables(1)
	Set objRange    = objDoc.Range()
	Set objWorkbook = wBook(objExcel, excelDocPath)

    objExcel.Visible = False
    
    For Each cell In iTable.range.Cells
        if cell.RowIndex > 3 and cell.ColumnIndex < 3 then 
        	if cell.ColumnIndex = 1 then 
        		cIndex = 1
    		else 
    			cIndex = columnIndex
			end if

        	objExcel.Cells(cell.RowIndex-2, cIndex).value = delBadChr(cell.Range.Text)
        
        elseif cell.RowIndex > 1 then
        	objExcel.Cells(1, columnIndex).value = colName
        end if
    Next
	
	objWorkbook.save
	objWorkbook.close
	objExcel.Quit

End Function

Function cutTable(filePath, keyWord, excelDocPath, columnIndex, colName)
    Dim iParagraphs, _
        iRange, _
        toRemove, _
		objWord, _
		objDocp

	Set objWord = CreateObject("Word.Application")
	Set objDoc  = objWord.Documents.Open(filePath)
    Set iRange  = objDoc.Content
	
	objWord.Visible = False
	
    If iRange.Find.Execute(keyWord) Then
        objDoc.Range(0, iRange.End).Select
        objWord.ActiveWindow.Selection.Delete
    End If
    
    objDoc.Range(objDoc.Tables(1).Range.End).Select
 	objDoc.ActiveWindow.Selection.Delete
 	createrTable objDoc, objWord, excelDocPath, columnIndex, colName
 	
 	objDoc.save
 	objDoc.close
	objWord.Quit
	
End Function


dim fso, filePath, keyWord, excelDocPath
Set fso = CreateObject("Scripting.FileSystemObject")

filePath     = WScript.Arguments(0)  
keyWord	     = WScript.Arguments(1)
excelDocPath = CStr(fso.GetFile(WScript.Arguments(0)).ParentFolder) + "\data.xls" 
columnIndex  = CInt(WScript.Arguments(2))  
colName      = CStr(WScript.Arguments(3))

cutTable filePath, keyWord, excelDocPath, columnIndex, colName
WScript.Quit