

# �������� ���� ��������������
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "��������� ����� ��������������! ��������� PowerShell �� ����� ��������������." -ForegroundColor Red
    pause
    exit
}

# ��������� ���������� ���������
[Console]::OutputEncoding = [System.Text.Encoding]::ANSI

function Show-Menu {
    Clear-Host
    Write-Host "=============================================="
    Write-Host "    ��������� ������� ����������� (PowerShell)"
    Write-Host "=============================================="
    Write-Host "1. ��������� ������������� (DHCP)"
    Write-Host "2. ��������� ������� (����������� IP)"
    Write-Host "3. �������� ���������� � ������� ���������"
    Write-Host "4. �����"
    Write-Host ""
}

function Get-NetworkInfo {
    $adapters = Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, LinkSpeed, MediaType
    
    Write-Host "`n���������� � ������� ���������:`n"
    $adapters | Format-Table -AutoSize
    
    foreach ($adapter in $adapters) {
        $interface = Get-NetAdapterAdvancedProperty -Name $adapter.Name | Where-Object {$_.DisplayName -match "Speed|Duplex"}
        Write-Host "`n������ ��� �������� '$($adapter.Name)':"
        $interface | Select-Object DisplayName, DisplayValue | Format-Table -AutoSize
    }
}

function Set-DHCP {
    param ($interfaceIndex)
    $interface = Get-NetAdapter -InterfaceIndex $interfaceIndex
    Write-Host "��������� ���������� $($interface.Name) �� DHCP..."
    
    Set-NetIPInterface -InterfaceIndex $interfaceIndex -Dhcp Enabled
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ResetServerAddresses
    
    Write-Host "��������� DHCP ��������� �������!" -ForegroundColor Green
    pause
}

function Set-StaticIP {
    param ($interfaceIndex)
    $interface = Get-NetAdapter -InterfaceIndex $interfaceIndex
    
    Write-Host "`n������� ���������:"
    Get-NetIPConfiguration -InterfaceIndex $interfaceIndex | Format-Table
    
    $ip = Read-Host "������� IP-����� (������: 192.168.1.100)"
    $mask = Read-Host "������� ����� ������� (������: 255.255.255.0)"
    $gateway = Read-Host "������� �������� ���� (������: 192.168.1.1)"
    $dns1 = Read-Host "������� �������� DNS (������: 8.8.8.8)"
    $dns2 = Read-Host "������� �������������� DNS (�� �����������)"
    
    # ������������ ����� � �������
    $prefixLength = switch ($mask) {
        "255.255.255.0" { 24 }
        "255.255.0.0" { 16 }
        "255.0.0.0" { 8 }
        default { 
            Write-Host "����������� �����, ���������� 24" -ForegroundColor Yellow
            24
        }
    }
    
    Write-Host "`n���������� ��������..."
    Remove-NetIPAddress -InterfaceIndex $interfaceIndex -Confirm:$false
    New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $ip -PrefixLength $prefixLength -DefaultGateway $gateway
    
    if ($dns2) {
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($dns1, $dns2)
    } else {
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $dns1
    }
    
    Write-Host "����������� ��������� ���������!" -ForegroundColor Green
    pause
}
# �������� ����
do {
    Show-Menu
    $choice = Read-Host "�������� �������� [1-4]"
    
    switch ($choice) {
        '1' {
            Get-NetAdapter | Format-Table InterfaceIndex, Name, Status
            $index = Read-Host "`n������� InterfaceIndex"
            Set-DHCP -interfaceIndex $index
        }
        '2' {
            Get-NetAdapter | Format-Table InterfaceIndex, Name, Status
            $index = Read-Host "`n������� InterfaceIndex"
            Set-StaticIP -interfaceIndex $index
        }
        '3' { Get-NetworkInfo; pause }
        '4' { exit }
        default {
            Write-Host "�������� �����, ���������� �����" -ForegroundColor Red
            pause
        }
    }
} while ($true)