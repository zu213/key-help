$installDir = "$HOME\Scripts"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

$keyHelp = @'
# Key-help for PowerShell
if ($PSVersionTable) {
    Write-Host "hello" -ForegroundColor Red
}
else {
    Write-Host "hello"
}
'@

$keyHelpPath = "$installDir\key-help.ps1"
Set-Content -Path $keyHelpPath -Value $keyHelp -Encoding UTF8

# Add to PATH if not already present
if (-not ($env:Path -split ';' | Where-Object { $_ -eq $installDir })) {
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$installDir", "User")
    Write-Host "ℹ️  Added $installDir to PATH. Restart your terminal for changes to apply."
}

Write-Host "✅ Installed key-help at $keyHelpPath"
