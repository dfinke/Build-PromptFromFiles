<#
.SYNOPSIS
Builds a prompt from files in specified directories.

.DESCRIPTION
The Build-PromptFromFiles function scans specified directories and builds a prompt from the files found. 
It can optionally ignore certain file types and include content from .gitignore files. 
The output can be in raw format or XML format.

.PARAMETER Path
An array of directory paths to scan. Defaults to the current directory.

.PARAMETER ignore
An array of file patterns to ignore. Additional patterns are added by default.

.PARAMETER gitIgnore
A switch to include patterns from .gitignore files in the ignore list.

.PARAMETER Raw
A switch to output the content in raw format instead of XML format.

.EXAMPLE
Build-PromptFromFiles -Path "C:\Projects" -gitIgnore -Raw

This example scans the "C:\Projects" directory, includes patterns from .gitignore files, and outputs the content in raw format.

.EXAMPLE
Build-PromptFromFiles -Path "C:\Projects", "D:\Work" -ignore "*.log"

This example scans the "C:\Projects" and "D:\Work" directories, ignores .log files, and outputs the content in XML format.
#>
function Build-PromptFromFiles {
    [CmdletBinding()]
    param (
        [string[]]$Path = $pwd,
        [string[]]$ignore,
        [string[]]$ignoreFolders,
        [Switch]$gitIgnore,
        [Switch]$Raw
    )

    $targetFiles = foreach ($targetPath in $Path) {
        if (-not (Test-Path -Path $targetPath -PathType Container)) {
            Write-Error "Path $targetPath does not exist or is not a directory."
            return
        }

        $ignore += "*.pdf", "*.zip", "*.exe", "*.dll", ".gitignore"
        $ignore += "*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.tiff", "*.ico", "*.mp3", "*.mp4", "*.avi"

        if ($gitIgnore) {
            $ignore += (Get-GitIgnoreContent -Path $targetPath)
        }

        $filteredTargetPath = Get-ChildItem -Path $targetPath -Exclude $ignoreFolders

        (Get-ChildItem -Path $filteredTargetPath -Recurse -File -Exclude $ignore).FullName | Sort-Object 
    }

    $outputText = [System.Text.StringBuilder]::new()

    if ($Raw) {
        foreach ($file in $targetFiles) {
            $null = $outputText.AppendLine($file)
            $null = $outputText.AppendLine('---')
            $null = $outputText.AppendLine((Get-Content -Path $file -Raw))
            $null = $outputText.AppendLine('')
            $null = $outputText.AppendLine('---')
        }

        $outputText.ToString()
    }
    else {

        $null = $outputText.AppendLine('<documents>')

        $documnentIndex = 1

        foreach ($file in $targetFiles) {

            Write-Progress -Activity "Building Prompt" -Status "Processing $file" -PercentComplete (($documnentIndex / $targetFiles.Count) * 100)

            $null = $outputText.AppendLine("<document index='$documnentIndex'>")
            $null = $outputText.AppendLine("<source>$file</source>")
            $null = $outputText.AppendLine('<document_content>')

            $null = $outputText.AppendLine((Get-Content -Path $file -Raw))

            $null = $outputText.AppendLine('</document_content>')
            $null = $outputText.AppendLine('</document>')

            $documnentIndex++
        }

        $null = $outputText.AppendLine('</documents>')

        $outputText.ToString()
    }
}