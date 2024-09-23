function Test-RepoExists {
    [CmdletBinding()]
    param(
        $slug
    )

    $repoExists = $false
    
    try {
        $null = Invoke-RestMethod "https://api.github.com/repos/$slug" 
        $repoExists = $true
    }
    catch {
        Write-Verbose "Repo $slug does not exist"
    }
    
    $repoExists
}
