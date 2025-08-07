@echo off
REM Sacred Omniboard Local Start (for non-Docker use)
REM Load configuration from config.env
for /f "tokens=2 delims==" %%i in ('type config.env ^| findstr "DB_NAME="') do set DB_NAME=%%i
for /f "tokens=2 delims==" %%i in ('type config.env ^| findstr "MONGO_PORT="') do set MONGO_PORT=%%i

REM Use configuration values
echo Starting Omniboard for database: %DB_NAME% on port %MONGO_PORT%
echo.
echo Note: This connects to LOCAL MongoDB, not Docker
echo For Docker environment, use start.bat instead
echo.

set "PATH=%PATH%;C:\Users\Alienor\anaconda3\envs\hardware"
start cmd /k "conda activate hardware & omniboard -m 127.0.0.1:%MONGO_PORT%:%DB_NAME%"
