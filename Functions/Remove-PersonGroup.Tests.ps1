$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "RemovePersonGroups" {

    Context "When a person group is being deleted" {
        New-PersonGroup "pester-1"
        Remove-PersonGroup "pester-1"
        It "Should not exist anymore / throw when trying to retrieve" {
            {Get-PersonGroup "pester-1"} | Should Throw
        }
    }

}
