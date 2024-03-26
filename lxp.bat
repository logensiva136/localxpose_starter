@echo off

rem Define the base directory and the executable name
set "BASE_DIR=%~dp0"
set "EXE_=loclx.exe"

rem Check if the executable exists, if not, download files
if not exist "%BASE_DIR%%EXE_%" (
    goto Get-Files
)

rem Expose
goto Expose

rem Function to download and extract files
:Get-Files
set "zipFile=%BASE_DIR%loclx.zip"
set "url=https://loclx-client.s3.amazonaws.com/loclx-windows-amd64.zip"
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipFile%'"
powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%BASE_DIR%' -Force"

rem Function to expose
:Expose
set "configFile=%BASE_DIR%config.yml"
"%BASE_DIR%%EXE_%" tunnel config -f "%configFile%"


