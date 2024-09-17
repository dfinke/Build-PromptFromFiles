<#
.SYNOPSIS
Builds a prompt from the contents of files in specified directories.

.DESCRIPTION
The Build-PromptFromFiles function recursively scans specified directories for files, excluding certain file types, and builds a prompt from the contents of these files. The output can be in raw text format or wrapped in XML tags.

.PARAMETER Path
An array of directory paths to scan for files. Defaults to the current directory.

.PARAMETER ignore
An array of file patterns to exclude from the scan. Additional patterns are added by default.

.PARAMETER NoCDATA
(Not used in the current implementation.)

.PARAMETER Raw
If specified, the output will be in raw text format. Otherwise, the output will be wrapped in XML tags.

.EXAMPLE
Build-PromptFromFiles -Path "C:\MyFolder" -Raw

This example scans the "C:\MyFolder" directory for files, excluding certain file types, and outputs the contents in raw text format.

.EXAMPLE
Build-PromptFromFiles -Path "C:\MyFolder"

This example scans the "C:\MyFolder" directory for files, excluding certain file types, and outputs the contents wrapped in XML tags.

.NOTES
The function excludes certain file types by default, such as PDFs, ZIPs, executables, images, and media files.
#>
function Build-PromptFromFiles {
    [CmdletBinding()]
    param (
        [string[]]$Path = $pwd,
        [string[]]$ignore,
        [Switch]$NoCDATA,
        [Switch]$Raw
    )

    $ignore += "*.pdf"
    $ignore += "*.zip"
    $ignore += "*.exe"
    $ignore += "*.dll"
    $ignore += "*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.tiff", "*.ico", "*.mp3", "*.mp4", "*.avi"

    $targetFiles = foreach ($targetPath in $Path) {
        if (-not (Test-Path -Path $targetPath -PathType Container)) {
            Write-Error "Path $targetPath does not exist or is not a directory."
            return
        }
         (Get-ChildItem -Path $targetPath -Recurse -File -Exclude $ignore).FullName | Sort-Object 
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