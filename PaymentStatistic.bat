@echo off
@cd/d "%~dp0"

title PaymentStatistic
mode con:cols=48 lines=24

set response="%1"
set log="logs.txt"

:Run
	if %response% EQU "" (
		call :LogAppender "start dataUpdater"
		call :LogAppender "Start Python 'dataChecker'"
		call dataUpdater.bat %0
	)
	
	if %response% NEQ "0" (
		call dataUpdater.bat "%response% dataUpdater"
	) else (
		call :LogAppender "Python checked data"
	)
	
	powershell %cd%\cleanData.ps1
	pause
	
:LogAppender
	echo. 				   >>%log%
	echo. 				   >>%log%
	echo --%date%%time%--  >>%log%
	echo %1  >>%log%       >>%log%
	echo. 				   >>%log%