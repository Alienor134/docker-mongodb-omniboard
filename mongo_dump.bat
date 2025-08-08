@echo off
REM Sacred MongoDB Dump & Restore Script
REM This script uses environment variables primarily, with config.env as fallback

REM First, try to get DB_NAME from environment variable
if not "%DB_NAME%"=="" (
    echo Using DB_NAME from environment variable: %DB_NAME%
) else (
    REM Fallback: Load configuration from config.env
    if exist "config.env" (
        echo Loading DB_NAME from config.env...
        for /f "tokens=2 delims==" %%i in ('type config.env ^| findstr "DB_NAME="') do set DB_NAME=%%i
    )
    
    REM Validate DB_NAME was loaded
    if "%DB_NAME%"=="" (
        echo ERROR: DB_NAME not found in environment variable or config.env
        echo Please either:
        echo   1. Set environment variable: set DB_NAME=your_database_name
        echo   2. Ensure config.env contains: DB_NAME=your_database_name
        pause
        exit /b 1
    )
)

REM Get Atlas credentials from environment variables (required)
SET "mongo_user=%ATLAS_USER%"
SET "mongo_password=%ATLAS_PASSWORD%"
SET "mongo_url=%ATLAS_URL%"

REM Validate required Atlas credentials
if "%mongo_user%"=="" (
    echo ERROR: ATLAS_USER environment variable not set
    echo Please set Atlas credentials as environment variables:
    echo   set ATLAS_USER=your_username
    echo   set ATLAS_PASSWORD=your_password
    echo   set ATLAS_URL=your_cluster_url
    echo.
    echo Press any key to return to deployment script...
    pause
    exit /b 1
)

if "%mongo_password%"=="" (
    echo ERROR: ATLAS_PASSWORD environment variable not set
    echo Please set Atlas credentials as environment variables
    echo.
    echo Press any key to return to deployment script...
    pause
    exit /b 1
)

if "%mongo_url%"=="" (
    echo ERROR: ATLAS_URL environment variable not set
    echo Please set Atlas credentials as environment variables
    echo.
    echo Press any key to return to deployment script...
    pause
    exit /b 1
)

REM Use the DB_NAME from config
echo Using database name: %DB_NAME%
echo Atlas user: %mongo_user%
echo.

REM Construct MongoDB URI
SET "mongo_uri=mongodb://%mongo_user%:%mongo_password%@%mongo_url%/?authsource=%DB_NAME%"

REM Dump the remote MongoDB database
echo Dumping remote MongoDB database...
mongodump --uri="%mongo_uri%" --out="dump-folder"

if %errorlevel% neq 0 (
    echo  Dump failed
    pause
    exit /b 1
) else (
    echo Dump completed successfully!
    echo Dump saved to: dump-folder/%DB_NAME%/
)
