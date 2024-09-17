foreach ($directory in @('Private', 'Public')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object { . $_.FullName }
}