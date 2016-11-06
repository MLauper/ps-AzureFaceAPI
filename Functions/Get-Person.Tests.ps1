$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

New-PersonGroup "pester-persongroup-1"
New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
New-Person "pester-person-2" -personGroupId "pester-persongroup-1"
New-Person "pester-person-3" -personGroupId "pester-persongroup-1"

Describe "GetPerson" {

    Context "When all Persons in a group are requested" {
        $result = Get-Person -personGroupId "pester-persongroup-1"
        It "Returns all persons" {
            ($result | measure).count | Should BeExactly 3
        }
    }

    Context "When a single Person in a groups is requested by name" {
        $result = Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        It "Returns a single persons" {
            ($result | measure).count | Should BeExactly 1
        }
    }

    Context "When a single Person in a groups is requested by id" {
        $person = Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        $result = Get-Person -id $person.personId -personGroupId "pester-persongroup-1"
        It "Returns a single persons" {
            ($result | measure).count | Should BeExactly 1
        }
    }

    Context "When a non-existing Person in a group is requested" {
        It "Should throw" {
            {Get-Person "pester-person-non-existing" -personGroupId "pester-persongroup-1"} | Should Throw
        }
    }
    
    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When no faces were uploaded"{
        $result =  Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        It "Shout not retrieve any"{
            ($result | select persistedFaceIds | measure).count | Should Be 0
        }        
    }

    New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
    New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
    New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"

    Context "When a person has uploaded faces" {
        $result =  Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        It "they should be returned" {
            ($result | measure).count | Should Be 3
        }
    }

    Remove-Person "pester-person-1" -personGroupId "pester-persongroup-1"
    Remove-PersonGroup "pester-persongroup-1"
}

