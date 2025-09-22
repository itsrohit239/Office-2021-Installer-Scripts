@echo off
setlocal enabledelayedexpansion

REM ============================================
REM Office 2021 Silent Installer Script
REM Developed by: Rohit Vadher
REM GitHub: https://github.com/itsrohit239
REM Description: Automates download, extraction, and installation
REM              of Office 2021 ProPlus Volume 64-bit edition.
REM ============================================
echo ============================================
echo Office 2021 Installer Script
echo Developed by: Rohit Vadher
echo GitHub: https://github.com/itsrohit239
echo ============================================

REM ============================
REM Check for Administrator Rights
REM ============================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script must be run as Administrator.
    exit /b 1
)

REM ============================
REM Define URLs and paths
REM ============================
set OfficeToolURL=https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_17830-20162.exe
set TempPath=%TEMP%\OfficeInstall
set OfficeToolPath=%TempPath%\OfficeDeploymentTool.exe
set Config64Bit=%TempPath%\Configuration-64bit.xml
set LogFile=%TempPath%\InstallLog.txt

REM ============================
REM Ensure the temp folder exists
REM ============================
if not exist "%TempPath%" mkdir "%TempPath%"

REM ============================
REM Start logging
REM ============================
echo Installation started at %DATE% %TIME% > "%LogFile%"

REM ============================
REM Download the Office Deployment Tool
REM ============================
echo Downloading Office Deployment Tool...
echo Downloading Office Deployment Tool... >> "%LogFile%"
curl -o "%OfficeToolPath%" "%OfficeToolURL%" -s --fail
if errorlevel 1 (
    echo ERROR: Failed to download Office Deployment Tool.
    echo ERROR: Failed to download Office Deployment Tool. >> "%LogFile%"
    exit /b 1
)

REM ============================
REM Extract the Office Deployment Tool
REM ============================
echo Extracting Office Deployment Tool...
echo Extracting Office Deployment Tool... >> "%LogFile%"
"%OfficeToolPath%" /quiet /extract:"%TempPath%"
if errorlevel 1 (
    echo ERROR: Failed to extract Office Deployment Tool.
    echo ERROR: Failed to extract Office Deployment Tool. >> "%LogFile%"
    exit /b 1
)

REM ============================
REM Create the configuration file
REM ============================
echo Creating the configuration file... >> "%LogFile%"
(
    echo ^<Configuration^>
    echo   ^<Add OfficeClientEdition="64" Channel="PerpetualVL2021"^>
    echo     ^<Product ID="ProPlus2021Volume"^>
    echo       ^<Language ID="en-us" /^>
    echo     ^</Product^>
    echo   ^</Add^>
    echo   ^<RemoveMSI /^>
    echo ^</Configuration^>
) > "%Config64Bit%"

REM ============================
REM Run the Office setup with the configuration file
REM ============================
echo Running Office setup...
echo Running Office setup... >> "%LogFile%"
"%TempPath%\Setup.exe" /configure "%Config64Bit%"
if errorlevel 1 (
    echo ERROR: Installation failed. Please check the logs.
    echo ERROR: Installation failed. >> "%LogFile%"
    exit /b 1
)

REM ============================
REM Cleanup temporary files
REM ============================
echo Cleaning up temporary files...
echo Cleaning up temporary files... >> "%LogFile%"
rd /s /q "%TempPath%"

REM ============================
REM Final message
REM ============================
echo.
echo ============================================
echo Installation completed successfully!
echo Script by: Rohit Vadher | GitHub: itsrohit239
echo ============================================
echo Installation completed successfully at %DATE% %TIME% >> "%LogFile%"
exit /b 0