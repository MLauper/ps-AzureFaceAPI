$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "RemoveFaceList" {
    
    Context "When a face list is deleted" {
        New-FaceList "pester-1"
        Remove-FaceList "pester-1"

        It "Should not exist anymore / throw when trying to retrieve" {
            {Get-FaceList -name "pester-1"} | Should Throw
        }
    }

    Context "When an inexisting face list is deleted" {
         It "Should throw an exception" {
            {Remove-FaceList "pester-1"} | Should Throw
        }
    }

}
