@echo off
color 02

:: Richiedi l'avvio come amministratore
echo.
echo ==================================================
echo CONTROLLO PRIVILEGI AMMINISTRATORE
echo ==================================================
echo.
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: Se l'errorelevel è diverso da 0, significa che l'utente non ha i privilegi di amministratore
if %errorlevel% neq 0 (
    echo Richiesta di avvio come amministratore negata.
    echo Riavvia il file batch come amministratore.
    pause
    exit /b
)
echo Privilegi controllati e garantiti.

:: Il codice qui di seguito verrà eseguito solo se l'avvio come amministratore è stato consentito
set "serviceName=MySQL80"
echo. 
echo ==================================================
echo Controllo STATUS Servizio: %serviceName%
echo ==================================================
echo. 

REM Verifica lo stato del servizio
sc query "%serviceName%" | find "RUNNING" >nul

if %errorlevel% equ 0 (
    REM Il servizio è in esecuzione, quindi lo spegne
    net stop "%serviceName%"
    echo.
    echo Il servizio %serviceName% è stato spento.
) else (
    REM Il servizio non è in esecuzione, quindi lo accende
    net start "%serviceName%"
    echo.
    echo Il servizio %serviceName% è stato acceso.
)

:LOOP
REM Verifica lo stato del servizio
sc query "%serviceName%" | find "RUNNING" >nul
if %errorlevel% equ 0 (
    REM Il servizio è in esecuzione
    echo.
    echo Il servizio %serviceName% risulta ACCESSO.
    echo.
) else (
    REM Il servizio non è in esecuzione
    echo.
    echo Il servizio %serviceName% risulta SPENTO.
    echo.
)

REM Attendere 60 secondi
timeout /t 60 /nobreak >nul

goto LOOP
