$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "GetPersonGroupTrainingStatus" {

    Context "When a person group is not being trained" {
        New-PersonGroup "pester-1"
        It "Should throw when trying to retrieve training status" {
            {Get-PersonGroupTrainingStatus "pester-1"} | Should Throw
        }
        Remove-PersonGroup "pester-1"
    }

    Context "When a person group has been trained" {
        New-PersonGroup "pester-1"
        Start-PersonGroupTraining "pester-1"
        It "Should not throw when trying to retrieve training status" {
            {Get-PersonGroupTrainingStatus "pester-1"} | Should Not Throw
        }
        It "Should have exactly one status" {
            $result = Get-PersonGroupTrainingStatus "pester-1"
            ($result | measure).count | Should BeExactly 1
        }
        Remove-PersonGroup "pester-1"
    }

}
