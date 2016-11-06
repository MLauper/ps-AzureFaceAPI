$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "StartPersonGroupTraining" {

    Context "When a person group without persons starts training" {
        New-PersonGroup "pester-1"
        It "Should not throw" {
            {Start-PersonGroupTraining "pester-1"} | Should Not Throw
        }
        It "Should have a training status" {
            (Get-PersonGroupTrainingStatus "pester-1" | measure).count | Should Be 1
        }
        
        It "Should have a training status with status failed" {
            $result = Get-PersonGroupTrainingStatus "pester-1"
            $result.status | Should Be "failed"
        }
        Remove-PersonGroup "pester-1"
    }

}
