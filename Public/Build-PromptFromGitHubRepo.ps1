function Build-PromptFromGitHubRepo {
    [CmdletBinding()]
    param(
        $slug
    )

    # [System.Environment]::OSVersion.Platform -eq "Unix"
    # check if unix or macos

    

    if ($null -eq (Get-Module -list BuildPromptFromFiles -errorAction SilentlyContinue)) {
        throw "BuildPromptFromFiles module is required. Please install - Install-Module BuildPromptFromFiles"
    }

    if (!(Test-RepoExists -slug $slug)) {
        throw "Repo $slug does not exist"
    }

    $branch = Get-GHBranch -slug $slug

    # test if github repo exists

    $url = "https://api.github.com/repos/{0}/zipball/{1}" -f $slug, $branch

    Write-Verbose "[$(Get-Date)] Retrieving $url"

    $fileName = $slug.replace("/", "-")
    $OutFile = "$PSScriptRoot\$($fileName).zip"
    
    $DestinationPath = "$PSScriptRoot\$fileName"

    Invoke-RestMethod $url -OutFile $OutFile
    
    Expand-Archive -Path $OutFile -DestinationPath $DestinationPath -Force

    $targetFullName = (Get-ChildItem $PSScriptRoot -Recurse $fileName -Directory | Get-ChildItem).FullName

    Build-PromptFromFiles $targetFullName
}

# yyz dfinke/importexcel 
# yyz dfinke/psai | clip
# yyz dfinke/InstallModuleFromGitHub
# yyz PowerShell/ProjectMercury | clip
# yyz PowerShell/PowerShell

# Build-PromptFromGitHubRepo dfinke/psai