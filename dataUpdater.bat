set scriptPath="%cd%\bin\python\APP_run.py"
set home=%1

:Main 
	python %scriptPath%
	IF %ERRORLEVEL% NEQ 0 call :MSG 1 "Python3 not found."
    call :MSG 0

:MSG
	cls
	if %1 EQU 1 (
		echo Application MSG!
		@echo.
		echo %2
		call %home% %2
	) else (	
		call %home% 0
	)
