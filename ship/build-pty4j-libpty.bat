@echo on

setlocal
cd %~dp0..
set Path=C:\Python27;C:\Program Files\Git\cmd;%Path%

:: expect to have msbuild in path
:: call "%VS140COMNTOOLS%\VsDevCmd.bat" || goto :fail

rmdir /s/q build-libpty 2>NUL
mkdir build-libpty\win
mkdir build-libpty\win\x86
mkdir build-libpty\win\x86_64
mkdir build-libpty\win\aarch64

rmdir /s/q src\Release  2>NUL
rmdir /s/q src\.vs      2>NUL
del src\*.vcxproj src\*.vcxpr

call vcbuild.bat --msvc-platform Win32 --gyp-msvs-version 2022 || goto :fail
copy src\Release\Win32\winpty.dll           build-libpty\win\x86 || goto :fail
copy src\Release\Win32\winpty-agent.exe     build-libpty\win\x86 || goto :fail

call vcbuild.bat --msvc-platform x64 --gyp-msvs-version 2022 || goto :fail
copy src\Release\x64\winpty.dll             build-libpty\win\x86_64 || goto :fail
copy src\Release\x64\winpty-agent.exe       build-libpty\win\x86_64 || goto :fail

call vcbuild.bat --msvc-platform arm64 --gyp-msvs-version 2022 || goto :fail
copy src\Release\arm64\winpty.dll             build-libpty\win\aarch64 || goto :fail
copy src\Release\arm64\winpty-agent.exe       build-libpty\win\aarch64 || goto :fail

echo success
goto :EOF

:fail
echo error: build failed
exit /b 1
