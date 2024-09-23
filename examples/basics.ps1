Import-Module "$PSScriptRoot/../BuildPromptFromFiles.psd1" -Force

$prompt = Build-PromptFromGitHubRepo dfinke/psai #-Verbose
$prompt