# ─── Driver Ghostbuster by ChatGPT-4o ───
# 💀 Limpador de drivers fantasmas (Test Edition)

function Menu {
    Clear-Host
    Write-Host "=== DRIVER GHOSTBUSTER ===`n" -ForegroundColor Cyan
    Write-Host "[1] Ver drivers ativos por palavra-chave"
    Write-Host "[2] Localizar INF original de um .SYS"
    Write-Host "[3] Verificar existência do arquivo .SYS"
    Write-Host "[4] Verificar chave de registro do driver"
    Write-Host "[5] Remover driver via PNPUTIL"
    Write-Host "[6] Apagar .SYS manualmente"
    Write-Host "[0] Sair"
    Write-Host ""
}

function Get-DriversByKeyword {
    $keyword = Read-Host "Digite parte do nome do driver (ex: spio, kinect)"
    Get-WmiObject Win32_PnPSignedDriver | Where-Object {
        $_.DriverName -like "*$keyword*" -or
        $_.InfName -like "*$keyword*" -or
        $_.DeviceName -like "*$keyword*" -or
        $_.FriendlyName -like "*$keyword*"
    } | Select-Object DeviceName, DriverVersion, InfName, DriverDate, DriverProviderName
    Pause
}

function FindINFBySYS {
    $sysname = Read-Host "Digite o nome exato do .sys (ex: spio.sys)"
    Get-ChildItem -Path "C:\Windows\INF" -Filter "*.inf" -Recurse | Select-String -Pattern $sysname | Select-Object Filename, Line
    Pause
}

function CheckIfSYSExists {
    $sysname = Read-Host "Digite o nome do .sys (ex: spio.sys)"
    $path = "C:\Windows\System32\drivers\$sysname"
    if (Test-Path $path) {
        Write-Host "✅ Encontrado: $path" -ForegroundColor Green
    } else {
        Write-Host "❌ Não encontrado: $path" -ForegroundColor Red
    }
    Pause
}

function CheckRegistryForDriver {
    $driverKey = Read-Host "Digite o nome do serviço/driver (ex: spio)"
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\$driverKey"
    if (Test-Path $regPath) {
        Write-Host "✅ Chave encontrada: $regPath" -ForegroundColor Yellow
        Read-Host "Pressione ENTER para abrir no Regedit"
        Start-Process "regedit.exe" "/m, $regPath"
    } else {
        Write-Host "❌ Nenhuma chave encontrada com esse nome." -ForegroundColor Red
    }
    Pause
}

function RemoveINF {
    $inf = Read-Host "Digite o nome do .inf instalado (ex: oem25.inf)"
    pnputil /delete-driver $inf /uninstall /force
    Pause
}

function DeleteSYS {
    $sys = Read-Host "Digite o nome do .sys (ex: spio.sys)"
    $full = "C:\Windows\System32\drivers\$sys"
    if (Test-Path $full) {
        Remove-Item $full -Force
        Write-Host "✅ $sys apagado." -ForegroundColor Green
    } else {
        Write-Host "❌ $sys não encontrado." -ForegroundColor Red
    }
    Pause
}

do {
    Menu
    $option = Read-Host "Escolha uma opção"
    switch ($option) {
        "1" { Get-DriversByKeyword }
        "2" { FindINFBySYS }
        "3" { CheckIfSYSExists }
        "4" { CheckRegistryForDriver }
        "5" { RemoveINF }
        "6" { DeleteSYS }
    }
} while ($option -ne "0")

Write-Host "`n👻 Até a próxima limpeza, Ghostbuster." -ForegroundColor Magenta
