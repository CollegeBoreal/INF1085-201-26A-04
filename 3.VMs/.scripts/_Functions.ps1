function Get-StudentRemoteChecks {
    param(
        [string]$Server
    )

    $User = "Administrator"

    $Password = ConvertTo-SecureString `
        "Boreal@2026" `
        -AsPlainText `
        -Force

    $Credential = :new(
        $User,
        $Password
    )

    try {

        Write-Host "Connecting to $Server..." -ForegroundColor Cyan
        $Session = New-PSSession `
            -ComputerName $Server `
            -Credential $Credential `
            -ErrorAction Stop

        Write-Host "Connection successful!" -ForegroundColor Green

    }
    catch {
        Write-Host "Connection failed!" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow

        return @{
            ADDS = ":no_entry:"
        }
    }
    finally {
        Remove-PSSession $Session `
            -ErrorAction SilentlyContinue
    }
}