$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "SetPersonGroup" {

    Context "When a person group name is being modified" {
        New-PersonGroup "pester-1"
        Set-PersonGroup "pester-1" -name "new-name-pester-1"
        $result = Get-PersonGroup "pester-1"
        It "Should not be the new live value" {
            $result.name | Should BeExactly "new-name-pester-1"
        }
        Remove-PersonGroup "pester-1"
    }

    Context "When a person group userData is being modified" {
        New-PersonGroup "pester-1"
        Set-PersonGroup "pester-1" -userData "someUserData"
        $result = Get-PersonGroup "pester-1"
        It "Should have the new userData value" {
            $result.userData | Should BeExactly "someUserData"
        }
        It "Should not have a new name" {
            $result.name | Should BeExactly "pester-1"
        }
        Remove-PersonGroup "pester-1"
    }

}
