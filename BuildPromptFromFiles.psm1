if ($IsWindows -eq $false) {
    throw "This module is only supported on Windows operating systems."
}

foreach ($directory in @('Private', 'Public')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object { . $_.FullName }
}