Describe "TestFunctionsExist" -Tag "TestFunctionsExist" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../BuildPromptFromFiles.psd1" -Force
    }

    It "Should have Build-PromptFromGitHubRepo" {
        $actual = Get-Command -module BuildPromptFromFiles Build-PromptFromGitHubRepo -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It "Should have Build-PromptFromFiles" {
        $actual = Get-Command -module BuildPromptFromFiles Build-PromptFromFiles -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It "Should have Get-GHBranch" {
        $actual = Get-Command -module BuildPromptFromFiles Get-GHBranch -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It "Should have Get-GitIgnoreContent" {
        $actual = Get-Command -module BuildPromptFromFiles Get-GitIgnoreContent -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It "Should have Test-RepoExists" {
        $actual = Get-Command -module BuildPromptFromFiles Test-RepoExists -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }
}