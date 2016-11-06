$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "NewFaceListFace" {
    
    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When a FaceList face from a local image is added" {
        New-FaceList "pester-facelist-1"
        New-FaceListFace -FaceListName "pester-facelist-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        $result = Get-FaceList -id "pester-facelist-1"
        It "Should exist" {
            ($result | select -expandProperty persistedFaces | measure).count | Should Be 1
        }
        Remove-FaceList "pester-facelist-1"
    }

    Context "When multiple FaceList faces are added" {
        New-FaceList "pester-facelist-1"
        New-FaceListFace -FaceListName "pester-facelist-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-FaceListFace -FaceListName "pester-facelist-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-FaceListFace -FaceListName "pester-facelist-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        $result = Get-FaceList -id "pester-facelist-1"
        It "Should have created all faces" {
            ($result | select -expandProperty persistedFaces | measure).count | Should Be 3
        }
        Remove-FaceList "pester-facelist-1"
    }  

}
