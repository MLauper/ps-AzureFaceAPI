$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "NewPersonGroups" {

    Context "When a person group is being created with minimal configuration" {
        New-PersonGroup "pester-1"
        $result = Get-PersonGroup "pester-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
        It "Should have the correct identifier" {
            $result.personGroupId | Should BeExactly "pester-1"
        }
        It "Should have the correct name" {
            $result.name | Should BeExactly "pester-1"
        }
        It "Should have no user data" {
            $result.userData | Should BeNullOrEmpty
        }
        Remove-PersonGroup "pester-1"
    }

    Context "When a person group is being created with full configuration" {
        New-PersonGroup -personGroupId "pester-1" -name "pester-1-name" -userData "perster-1-userData"
        $result = Get-PersonGroup "pester-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
        It "Should have the correct identifier" {
            $result.personGroupId | Should BeExactly "pester-1"
        }
        It "Should have the correct name" {
            $result.name | Should BeExactly "pester-1-name"
        }
        It "Should have the correct userData" {
            $result.userData | Should BeExactly "perster-1-userData"
        }
        Remove-PersonGroup "pester-1"
    }

    Context "When a person group is being created with illegal identifier" {
        It "Should throw" {
            {New-PersonGroup -personGroupId "IllegalName"} | Should Throw
        }
    }
}
