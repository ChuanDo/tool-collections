@echo off
setlocal enabledelayedexpansion

REM List of JetBrains products
set "products=Aqua CLion DataGrip DataSpell Fleet GoLand IntelliJ PhpStorm PyCharm Rider RubyMine RustRover WebStorm Resharper"
set "number_of_products=0"

REM Display list and prompt user to choose product to delete eval and options.xml
echo ---- RESET TRIAL IDE 1.0 ----
echo.

REM Print products list
set i=1
for %%I in (%products%) do (
    set /a number_of_products+=1
    if !i! lss 10 (
        set "pad=  "
    ) else (
        set "pad= "
    )
    echo !i!.!pad!%%I
    set /a i+=1
)

REM Print exit option
echo 0.  Exit
echo.

echo -----------------------------
REM Prompt user to enter choice
set /p choice=Enter your choice (0-%number_of_products% or q):

if /i "%choice%"=="0" goto end
if /i "%choice%"=="q" goto end

REM Validate choice
set i=1
for %%I in (%products%) do (
    if "%choice%"=="!i!" (
        set "selected_product=%%I"
    )
    set /a i+=1
)

REM If no product selected, exit
if "%selected_product%"=="" (
    echo Invalid choice.
    goto end
)

REM Delete eval and other.xml
echo Deleting eval folder and other.xml file in the %selected_product% directory...
for /d %%a in ("%USERPROFILE%\.%selected_product%*") do (
    if exist "%%a/config/eval" (
        rd /s /q "%%a/config/eval"
        echo Deleted eval folder in %%a
    )
    if exist "%%a/config/options/other.xml" (
        del /q "%%a/config/options/other.xml"
        echo Deleted other.xml file in %%a
    )
)

REM Ask user if they want to delete %APPDATA%\JetBrains\<prefix> directories or just delete .key files
echo Do you want to delete directories with prefix %APPDATA%\JetBrains\%selected_product%? (y/n):
set /p clear_settings=

REM Delete directories or .key files
echo Processing directories and files for %selected_product%...

if /i "%clear_settings%"=="y" (
    echo Deleting directories with prefix %APPDATA%\JetBrains\%selected_product%...
    for /d %%a in ("%APPDATA%\JetBrains\%selected_product%*") do (
        if exist "%%a" (
            echo Deleting folder: %%a
            rmdir /s /q "%%a"
            echo Deleted folder %%a
        ) else (
            echo Folder not found: %%a
        )
    )
) else (
    echo Deleting .key files in directories for %selected_product%...
    set "found_key_files=0"
    for /d %%a in ("%APPDATA%\JetBrains\%selected_product%*") do (
        if exist "%%a" (
            pushd "%%a"
            for /r %%f in (*.key) do (
                del /f /q "%%f"
                echo Deleted file: %%f
                set "found_key_files=1"
            )
            popd
        ) else (
            echo Directory not found: %%a
        )
    )
    if "%found_key_files%"=="0" (
        echo No .key files found in the directory for %selected_product%.
    ) else (
        echo Deleted all .key files in the directory for %selected_product%.
    )
)

:end
echo Program terminated.
exit /b

:invalid_choice
echo Invalid choice. Please enter a number between 0 and %number_of_products%, or q to quit.
goto end
