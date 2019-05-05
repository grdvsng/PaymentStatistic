@echo off
@cd/d "%~dp0"

title PaymentStatistic
mode con:cols=44 lines=24

set response="%1"
set log="logs.txt"

:Run
	if %response% EQU "" (
		call :LogAppender "start dataUpdater"
		call :LogAppender "Start Python 'dataChecker'"
		call dataUpdater.bat %0
	)
	
	if %response% NEQ "0" (
		if %response%  NEQ "2" call :LogAppender "%response% dataUpdater"
	) else (
		call :LogAppender "Python checked data"
	)

	if %response% NEQ "2" call :Cleaner
	if NOT EXIST "%cd%\data\data.xls" call :Cleaner
	
	pause
	exit

:LogAppender
	echo. 				   >>%log%
	echo. 				   >>%log%
	echo --%date%%time%--  >>%log%
	echo %1  >>%log%       >>%log%
	echo. 				   >>%log%
	
	exit /b

:Cleaner
	call :LogAppender "powershell started"
	powershell %cd%\cleanData.ps1
	call :LogAppender "powershell finish"

	exit /b