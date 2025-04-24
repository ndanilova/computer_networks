

# Проверка прав администратора
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Требуются права администратора! Запустите PowerShell от имени администратора." -ForegroundColor Red
    pause
    exit
}

# Установка корректной кодировки
[Console]::OutputEncoding = [System.Text.Encoding]::ANSI

function Show-Menu {
    Clear-Host
    Write-Host "=============================================="
    Write-Host "    НАСТРОЙКА СЕТЕВЫХ ИНТЕРФЕЙСОВ (PowerShell)"
    Write-Host "=============================================="
    Write-Host "1. Настроить автоматически (DHCP)"
    Write-Host "2. Настроить вручную (статический IP)"
    Write-Host "3. Показать информацию о сетевых адаптерах"
    Write-Host "4. Выход"
    Write-Host ""
}

function Get-NetworkInfo {
    $adapters = Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, LinkSpeed, MediaType
    
    Write-Host "`nИнформация о сетевых адаптерах:`n"
    $adapters | Format-Table -AutoSize
    
    foreach ($adapter in $adapters) {
        $interface = Get-NetAdapterAdvancedProperty -Name $adapter.Name | Where-Object {$_.DisplayName -match "Speed|Duplex"}
        Write-Host "`nДетали для адаптера '$($adapter.Name)':"
        $interface | Select-Object DisplayName, DisplayValue | Format-Table -AutoSize
    }
}

function Set-DHCP {
    param ($interfaceIndex)
    $interface = Get-NetAdapter -InterfaceIndex $interfaceIndex
    Write-Host "Настройка интерфейса $($interface.Name) на DHCP..."
    
    Set-NetIPInterface -InterfaceIndex $interfaceIndex -Dhcp Enabled
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ResetServerAddresses
    
    Write-Host "Настройки DHCP применены успешно!" -ForegroundColor Green
    pause
}

function Set-StaticIP {
    param ($interfaceIndex)
    $interface = Get-NetAdapter -InterfaceIndex $interfaceIndex
    
    Write-Host "`nТекущие настройки:"
    Get-NetIPConfiguration -InterfaceIndex $interfaceIndex | Format-Table
    
    $ip = Read-Host "Введите IP-адрес (пример: 192.168.1.100)"
    $mask = Read-Host "Введите маску подсети (пример: 255.255.255.0)"
    $gateway = Read-Host "Введите основной шлюз (пример: 192.168.1.1)"
    $dns1 = Read-Host "Введите основной DNS (пример: 8.8.8.8)"
    $dns2 = Read-Host "Введите альтернативный DNS (не обязательно)"
    
    # Конвертируем маску в префикс
    $prefixLength = switch ($mask) {
        "255.255.255.0" { 24 }
        "255.255.0.0" { 16 }
        "255.0.0.0" { 8 }
        default { 
            Write-Host "Неизвестная маска, используем 24" -ForegroundColor Yellow
            24
        }
    }
    
    Write-Host "`nПрименение настроек..."
    Remove-NetIPAddress -InterfaceIndex $interfaceIndex -Confirm:$false
    New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $ip -PrefixLength $prefixLength -DefaultGateway $gateway
    
    if ($dns2) {
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($dns1, $dns2)
    } else {
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $dns1
    }
    
    Write-Host "Статические настройки применены!" -ForegroundColor Green
    pause
}
# Основной цикл
do {
    Show-Menu
    $choice = Read-Host "Выберите действие [1-4]"
    
    switch ($choice) {
        '1' {
            Get-NetAdapter | Format-Table InterfaceIndex, Name, Status
            $index = Read-Host "`nВведите InterfaceIndex"
            Set-DHCP -interfaceIndex $index
        }
        '2' {
            Get-NetAdapter | Format-Table InterfaceIndex, Name, Status
            $index = Read-Host "`nВведите InterfaceIndex"
            Set-StaticIP -interfaceIndex $index
        }
        '3' { Get-NetworkInfo; pause }
        '4' { exit }
        default {
            Write-Host "Неверный выбор, попробуйте снова" -ForegroundColor Red
            pause
        }
    }
} while ($true)