'   saveTable
'		parameters:
'			filePath - string - doc full path;
'			keyWord  - string - string for find table.
'
'	description:
'		save 1 table from word doc and remove other content.
'	
' author: Sergey Trishkin

Function JsonCreater(objDoc, objWord)
	dim cell
	Set iTable  = objWord.ActiveDocument.Tables(1)

	objWord.Visible = False
    For Each cell In iTable.range.Cells
        if cell.RowIndex = 1 or cell.ColumnIndex > 2 then
        	cell.range.Select
        	objDoc.ActiveWindow.Selection.Delete
        end if
    Next
	
End Function

Function cutTable(filePath, keyWord)
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
 	
 	JsonCreater objDoc, objWord
 	
 	objDoc.save
 	objDoc.close 0
	objWord.Quit
	
End Function

cutTable WScript.Arguments(0), WScript.Arguments(1)