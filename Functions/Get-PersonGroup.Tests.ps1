$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

New-PersonGroup "pester-1"
New-PersonGroup "pester-2"

Describe "GetPersonGroups" {

    Context "When all Person Groups are requested" {
        $result = Get-PersonGroup
        It "Returns more than one group" {
            ($result | measure).count | Should BeGreaterThan 1
        }
    }

    Context "When all Person Groups are requested with Switch Parameter" {
        $result = Get-PersonGroup -ListAll
        It "Returns more than one group" {
            ($result | measure).count | Should BeGreaterThan 1
        }
    }

    Context "When a specific group is requested" {
        $result = Get-PersonGroup -PersonGroupId "pester-1"
        It "Should return exactly one person group" {
            ($result | measure).count | Should Be 1
        }
    }

    Context "When a non existing group is being requested" {
        It "should throw an exception" {
            { Get-PersonGroup "pester-non-existing" } | Should Throw
        }
    }

}

Remove-PersonGroup "pester-1"
Remove-PersonGroup "pester-2"