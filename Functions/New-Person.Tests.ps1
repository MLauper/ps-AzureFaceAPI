$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "NewPerson" {

    Context "When a person is being created" {
        New-PersonGroup "pester-persongroup-1"
        New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        $result = Get-Person -personGroupId "pester-persongroup-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
        Remove-PersonGroup "pester-persongroup-1"
    }

}
