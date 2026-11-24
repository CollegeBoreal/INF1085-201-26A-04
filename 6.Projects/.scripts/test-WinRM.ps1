#!/usr/bin/env pwsh

# --------------------------------------------------
# WinRM / PSRemoting Connectivity Test
# --------------------------------------------------


$Server = "10.7.237.221"

$User = "Administrator"

$Password = ConvertTo-SecureString `
    "Boreal@2026" `
    -AsPlainText `
    -Force

$Credential = New-Object PSCredential (
    $User,
    $Password
)

Write-Host ""
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host " Server: $Server"
Write-Host " User  : $User"
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host ""

try {

    Write-Host "Testing TCP connectivity..." -ForegroundColor Yellow

    $TcpClient = [System.Net.Sockets.TcpClient]::new()

    $Connect = $TcpClient.ConnectAsync($Server, 5985)

    if ($Connect.Wait(3000)) {
        Write-Host "TCP 5985 Open : True" -ForegroundColor Green
    }
    else {
        Write-Host "TCP 5985 Open : False" -ForegroundColor Red
    }

    $TcpClient.Dispose()
}
catch {
    Write-Host "TCP 5985 Open : False" -ForegroundColor Red
}

try {

    Write-Host "Creating PSSession..." -ForegroundColor Yellow

    $Session = New-PSSession `
        -ComputerName $Server `
        -Credential $Credential `
        -Authentication Negotiate `
        -Verbose `
        -ErrorAction Stop

    Write-Host ""
    Write-Host "SUCCESS: Session created" -ForegroundColor Green
    Write-Host ""

    Write-Host "Executing remote commands..." -ForegroundColor Yellow

    $Result = Invoke-Command `
        -Session $Session `
        -ScriptBlock {

            @{
                Hostname      = hostname
                User          = whoami
                WinRM         = (Get-Service WinRM).Status
                ComputerName  = $env:COMPUTERNAME
                OS            = (Get-CimInstance Win32_OperatingSystem).Caption
            }
        }

    Write-Host ""
    Write-Host "Remote Information" -ForegroundColor Green
    Write-Host "----------------------------------------"

    $Result.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key): $($_.Value)"
    }

    Remove-PSSession $Session
}
catch {

    Write-Host ""
    Write-Host "FAILED" -ForegroundColor Red
    Write-Host "----------------------------------------"

    Write-Host ""
    Write-Host "Error Record:" -ForegroundColor Yellow

    $_ | Format-List * -Force

    Write-Host ""
    Write-Host "Exception:" -ForegroundColor Yellow

    $_.Exception | Format-List * -Force

    Write-Host ""
    Write-Host "Inner Exception:" -ForegroundColor Yellow

    if ($_.Exception.InnerException) {
        $_.Exception.InnerException | Format-List * -Force
    }
}