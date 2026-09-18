@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Ejecute como Administrador.
    pause
    exit /b 1
)

echo Habilitando almacenamiento USB...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v "Start" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices" /v "Deny_All" /t REG_DWORD /d 0 /f >nul 2>&1
gpupdate /force >nul 2>&1

echo [OK] Almacenamiento USB habilitado correctamente.
pause