$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "RemovePerson" {

    New-PersonGroup "pester-1"
        
    Context "When a person is being deleted by name" {
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        Remove-Person -name "pester-person-1" -personGroupId "pester-1"
        
        It "Should not exist anymore / throw when trying to retrieve" {
            {Get-Person -name "pester-person-1" -personGroupId "pester-1"} | Should Throw
        }
    }

    Context "When a person is being deleted by id" {
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        $person = Get-Person -name "pester-person-1" -personGroupId "pester-1"
        Remove-Person -id $person.personId -personGroupId "pester-1"
        
        It "Should not exist anymore / throw when trying to retrieve" {
            {Get-Person -name "pester-person-1" -personGroupId "pester-1"} | Should Throw
        }
    }
    
    Context "When a non-existing person is being deleted by name" {
        It "Should throw an exception" {
            {Remove-Person -name "pester-person-non-existing" -personGroupId "pester-1"} | Should Throw
        }
    }

    Context "When a non-existing person is being deleted by name" {
        It "Should throw an exception" {
            {Remove-Person -id "42" -personGroupId "pester-1"} | Should Throw
        }
    }

    Context "When multiple persons with the same name exist and force is set" {
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        New-Person -name "pester-person-1" -personGroupId "pester-1"

        Remove-Person -name "pester-person-1" -personGroupId "pester-1" -Force
        It "Should remove all persons with that name" {
            {Get-Person -name "pester-person-1" -personGroupId "pester-1"} | Should Throw
        }
    }

    Context "When multiple persons with the same name exist and force is not set" {
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        New-Person -name "pester-person-1" -personGroupId "pester-1"

        It "Should throw an exception" {
            {Remove-Person -name "pester-person-1" -personGroupId "pester-1"} | Should Throw
        }

        Remove-Person -name "pester-person-1" -personGroupId "pester-1" -Force
    }

    Remove-PersonGroup "pester-1"

}
