function Build-PromptFromGitHubRepo {
    [CmdletBinding()]
    param(
        $slug
    )
    
    if (!(Test-RepoExists -slug $slug)) {
        throw "Repo $slug does not exist"
    }

    $branch = Get-GHBranch -slug $slug

    # test if github repo exists

    $url = "https://api.github.com/repos/{0}/zipball/{1}" -f $slug, $branch

    Write-Verbose "[$(Get-Date)] Retrieving $url"

    $fileName = $slug.replace("/", "-")
    $folderName = [System.IO.Path]::GetTempPath()
    $OutFile = "$folderName\$($fileName).zip"
    
    $DestinationPath = "$folderName\$fileName"

    Invoke-RestMethod $url -OutFile $OutFile
    Expand-Archive -Path $OutFile -DestinationPath $DestinationPath -Force
    $targetFullName = (Get-ChildItem $folderName -Recurse $fileName -Directory | Get-ChildItem).FullName

    Write-Verbose "[$(Get-Date)] $OutFile"
    Write-Verbose "[$(Get-Date)] $DestinationPath"
    Build-PromptFromFiles $targetFullName

    $null = Remove-Item $OutFile -Force -Verbose:$Verbose
    $null = Remove-Item $DestinationPath -Recurse -Force -Verbose:$Verbose
}