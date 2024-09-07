REM Delete eval folder with licence key and options.xml which contains a reference to it
for %%I in ("Aqua", "CLion", "DataGrip", "DataSpell", "Fleet", "GoLand", "IntelliJ", "PhpStorm", "PyCharm", "Rider", "RubyMine", "RustRover", "WebStorm", "Resharper") do (
    for /d %%a in ("%USERPROFILE%\.%%I*") do (
        rd /s /q "%%a/config/eval"
        del /q "%%a\config\options\other.xml"
    )
)

REM Delete registry key and jetbrains folder (not sure if need but however)
rmdir /s /q "%APPDATA%\JetBrains"
reg delete "HKEY_CURRENT_USER\Software\JavaSoft" /f