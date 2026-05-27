:: disable `cmd.exe` from printing each command to the terminal before executing it
@echo off

:: Activate Visual Studio compiler environment for pip subprocesses
if exist "%BUILD_PREFIX%\etc\conda\activate.d\vs2022_win-64_activate.bat" (
    call "%BUILD_PREFIX%\etc\conda\activate.d\vs2022_win-64_activate.bat"
)

:: set local variables in a new scope & ensure `cmd.exe` expands variable names at execution time
setlocal enabledelayedexpansion

:: `enable`
cd "%SRC_DIR%\enable"
if errorlevel 1 exit /b 1

:: * --no-build-isolation tells `pip` to trust the `conda` environment's tools
:: * [layout,svg] extras are required for chaco
"%PYTHON%" -m pip install ".[layout,svg]" --no-build-isolation --no-deps --ignore-installed -v --prefix="%PREFIX%"
if errorlevel 1 exit /b 1

:: verify `enable` installed correctly
if not exist "%SP_DIR%\enable\__init__.py" (
    echo ERROR: enable\__init__.py not found in %SP_DIR%
    exit /b 1
)

:: `chaco`
cd "%SRC_DIR%\chaco"
if errorlevel 1 exit /b 1

"%PYTHON%" -m pip install . --no-build-isolation --no-deps --ignore-installed -v --prefix="%PREFIX%"
if errorlevel 1 exit /b 1

:: verify `chaco` installed correctly
if not exist "%SP_DIR%\chaco\__init__.py" (
    echo ERROR: chaco\__init__.py not found in %SP_DIR%
    exit /b 1
)

exit /b 0
