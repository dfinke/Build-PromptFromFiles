function Get-GHBranch {
    [CmdletBinding()]
    param(
        [string]$slug
    )

    $branches = Invoke-RestMethod "https://api.github.com/repos/$slug/branches"

    $branchName = $branches.name    
    return ($branchName -eq 'main') ? 'main' : ($branchName -eq 'master') ? 'master' : $branches[0].name
}