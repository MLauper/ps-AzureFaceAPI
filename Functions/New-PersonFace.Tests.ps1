$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "NewPersonFace" {

    New-PersonGroup "pester-persongroup-1"
    New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
    
    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When a person face from a local image is added" {
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        $result = Get-Person -personGroupId "pester-persongroup-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
    }

    Context "When a person face from a local image is added with target face coordinates" {
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG" -targetFace (5,5,5,5)
        $result = Get-Person -personGroupId "pester-persongroup-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
    }

    Context "When a person face from a local image is added with target illegal face coordinates" {
        It "Should throw an exception" {
            {New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG" -targetFace (5,5,5)} | Should Throw
        }
    }

    Context "When a person face from an existing Url is added" {
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -ImageUrl "https://github.com/MLauper/CPVR_FaceRecognition/blob/master/Images/cpvr_faces_320/0035/03.JPG?raw=true"
        $result = Get-Person -personGroupId "pester-persongroup-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
    }

    Remove-Person "pester-person-1" -personGroupId "pester-persongroup-1"
    Remove-PersonGroup "pester-persongroup-1"

}
