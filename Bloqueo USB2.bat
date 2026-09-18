@echo off
:: ==============================================================================
:: Script de Bloqueo Automático de Dispositivos de Almacenamiento USB
:: ==============================================================================

:: Verificar si se está ejecutando como Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ==============================================================================
    echo ERROR: Este script requiere permisos de Administrador.
    echo Haga clic derecho sobre el archivo y seleccione "Ejecutar como administrador".
    echo ==============================================================================
    echo.
    pause
    exit /b 1
)

echo.
echo ==============================================================================
echo Aplicando restricciones de almacenamiento USB...
echo ==============================================================================
echo.

:: 1. Deshabilitar el servicio USBSTOR en el Registro (Start = 4)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Servicio USBSTOR deshabilitado en el Registro.
) else (
    echo [ERROR] No se pudo modificar la clave USBSTOR.
)

:: 2. Configurar la Directiva del Registro para denegar lectura/escritura de almacenamiento extraíble
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices" /v "Deny_All" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Directiva Deny_All aplicada correctamente.
) else (
    echo [ERROR] No se pudo aplicar la directiva Deny_All.
)

:: 3. Forzar actualización de Directivas de Grupo (GPO)
echo.
echo Actualizando directivas del sistema (gpupdate /force)...
gpupdate /force >nul 2>&1
echo [OK] Directivas del sistema actualizadas.

echo.
echo ==============================================================================
echo PROCESO COMPLETADO EXITOSAMENTE
echo Las memorias y discos USB externos quedan bloqueados.
echo Teclados, ratones e impresoras USB seguirán funcionando normalmente.
echo ==============================================================================
echo.
pause