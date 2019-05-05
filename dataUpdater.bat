@echo off

set scriptPath="%cd%\bin\python\APP_run.py"
set home=%1

:Main 
	python %scriptPath%
	set response=%ERRORLEVEL%

	IF %response% NEQ 0 ( 
		IF %response% NEQ 2 call :MSG 1 "Python3 not found."
		IF %response% EQU 2 call :MSG 0 2
	) else (
    	call :MSG 0 0
    )

:MSG
	cls
	if %1 EQU 1 (
		echo Application MSG!
		@echo.
		echo %2
	)
	
	call %home% %2