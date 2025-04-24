@echo off
chcp 65001 > nul

:: Проверка на запуск от имени администратора
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Запуск с правами администратора подтвержден.
) else (
    echo ОШИБКА: Этот скрипт требует прав администратора.
    echo Пожалуйста, запустите от имени Администратора.
    pause
    exit /b
)

:start
cls
echo -----------------------------------------------
echo    СЕТЕВОЙ НАСТРОЙЩИК (с помощью netsh)
echo -----------------------------------------------
echo.
echo Доступные сетевые интерфейсы:
echo.
netsh interface ipv4 show interfaces
echo.

set /p interface="Введите ID интерфейса для настройки: "

:menu
cls
echo Настройка интерфейса с ID %interface%
echo -----------------------------------------------
echo 1. Настроить автоматически (DHCP)
echo 2. Настроить вручную (статические настройки)
echo 3. Выбрать другой интерфейс
echo 4. Выход
echo.

set /p choice="Выберите действие [1-4]: "

if "%choice%"=="1" goto dhcp
if "%choice%"=="2" goto static
if "%choice%"=="3" goto start
if "%choice%"=="4" goto end

echo Неверный выбор, попробуйте еще раз.
pause
goto menu

:dhcp
echo Настройка интерфейса %interface% через DHCP...
netsh interface ipv4 set address name="%interface%" source=dhcp
netsh interface ipv4 set dnsservers name="%interface%" source=dhcp
echo Настройки успешно применены!
pause
goto menu

:static
cls
echo Введите статические настройки для интерфейса %interface%
echo (Примеры значений: 192.168.1.100, 255.255.255.0, 192.168.1.1)
echo.

set /p ip="IP-адрес: "
set /p mask="Маска подсети: "
set /p gateway="Основной шлюз: "
set /p dns1="Предпочитаемый DNS-сервер: "
set /p dns2="Альтернативный DNS-сервер (не обязательно): "

echo Применение настроек...
netsh interface ipv4 set address name="%interface%" static %ip% %mask% %gateway% 1
netsh interface ipv4 set dnsservers name="%interface%" static %dns1% primary
if not "%dns2%"=="" (
    netsh interface ipv4 add dnsservers name="%interface%" %dns2% index=2
)

echo Настройки успешно применены!
pause
goto menu

:end
echo Выход из программы...
pause