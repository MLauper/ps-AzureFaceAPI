$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "SetPerson" {

    New-PersonGroup "pester-1"

    Context "When a person name is being modified" {
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        Set-Person -name "pester-person-1" -personGroupId "pester-1" -newName "pester-person-1-newName"
        $result = Get-Person -name "pester-person-1-newName" -personGroupId "pester-1"
        It "Should exist under the new name" {
            $result.name | Should BeExactly "pester-person-1-newName"
        }
        Remove-Person -name "pester-person-1-newName" -personGroupId "pester-1"
    }

    Context "When a person userData is being modified" {
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        Set-Person "pester-person-1" -personGroupId "pester-1" -userData "someUserData"
        $result = Get-Person -name "pester-person-1" -personGroupId "pester-1"
        It "Should have the new userData value" {
            $result.userData | Should BeExactly "someUserData"
        }
        Remove-Person -name "pester-person-1" -personGroupId "pester-1"
    }

    Context "When multiple persons with the same name exist, and the name is being modified without -Force" {
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        New-Person -name "pester-person-1" -personGroupId "pester-1"
        
        It "Should throw because the userData property will be cleared" {
           {Set-Person "pester-person-1" -personGroupId "pester-1" -newName "pester-person-2"} | Should Throw
        }
        Remove-Person -name "pester-person-1" -personGroupId "pester-1" -Force
    }

    Context "When multiple persons with the same name exist, and the name is being modified with -Force" {
        New-Person -name "pester-person-1" -personGroupId "pester-1" -userData "user-data-1"
        New-Person -name "pester-person-1" -personGroupId "pester-1" -userData "user-data-2"
        
        Set-Person "pester-person-1" -personGroupId "pester-1" -newName "pester-person-2" -Force
        $result = Get-Person "pester-person-2" -personGroupId "pester-1"
        It "Should update each persons name, without modifying the userData value" {
            ($result | measure).count | Should BeExactly 2
            ($result | ? {$_.userData -eq "user-data-1"} | measure).count | Should BeExactly 1
            ($result | ? {$_.userData -eq "user-data-2"} | measure).count | Should BeExactly 1
        }
        Remove-Person -name "pester-person-2" -personGroupId "pester-1" -Force
    }

    Context "When multiple persons with the same name exist, and the userData is being modified with -Force" {
        New-Person -name "pester-person-1" -personGroupId "pester-1" -userData "user-data-1"
        New-Person -name "pester-person-1" -personGroupId "pester-1" -userData "user-data-2"
        
        Set-Person "pester-person-1" -personGroupId "pester-1" -userData "user-data-3" -Force
        $result = Get-Person "pester-person-1" -personGroupId "pester-1"
        It "Should update each persons userData" {
            ($result | measure).count | Should BeExactly 2
            ($result | ? {$_.userData -eq "user-data-1"} | measure).count | Should BeExactly 0
            ($result | ? {$_.userData -eq "user-data-2"} | measure).count | Should BeExactly 0
            ($result | ? {$_.userData -eq "user-data-3"} | measure).count | Should BeExactly 2
        }
        Remove-Person -name "pester-person-1" -personGroupId "pester-1" -Force
    }

    Remove-PersonGroup "pester-1"

}
