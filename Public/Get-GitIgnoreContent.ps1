<#
.SYNOPSIS
Retrieves the content of the .gitignore file from a specified directory.

.DESCRIPTION
The Get-GitIgnoreContent function reads the .gitignore file from the specified directory and returns its content, excluding empty lines and comments. If the .gitignore file does not exist, it returns an empty array.

.PARAMETER Path
The path to the directory containing the .gitignore file. Defaults to the current working directory.

.EXAMPLE
PS C:\> Get-GitIgnoreContent -Path "C:\MyProject"
This command retrieves the content of the .gitignore file located in the "C:\MyProject" directory.

.EXAMPLE
PS C:\> Get-GitIgnoreContent
This command retrieves the content of the .gitignore file from the current working directory.
#>
function Get-GitIgnoreContent {
    [CmdletBinding()]
    param (
        [string]$Path = $pwd
    )

    $gitignorePath = Join-Path -Path $Path -ChildPath ".gitignore"

    if (Test-Path -Path $gitignorePath -PathType Leaf) {
        Get-Content -Path $gitignorePath | Where-Object { $_ -match '\S' -and $_ -notmatch '^#' }
    }
    else {
        @()
    }
}