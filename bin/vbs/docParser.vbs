'   saveTable
'		parameters:
'			filePath - string - doc full path;
'			keyWord  - string - string for find table.
'
'	description:
'		save 1 table from word doc and remove other content.
'	
' author: Sergey Trishkin

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
 	
 	objDoc.save
 	objDoc.close 0
	objWord.Quit
	
End Function

cutTable WScript.Arguments(0), WScript.Arguments(1)