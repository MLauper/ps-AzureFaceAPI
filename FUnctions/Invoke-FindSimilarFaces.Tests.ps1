$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "InvokeFindSimilarFaces" {

    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When a similar face should be detected in a face list"{
        New-FaceList "pester-facelist-1"
        New-FaceListFace -FaceListName "pester-facelist-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-FaceListFace -FaceListName "pester-facelist-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-FaceListFace -FaceListName "pester-facelist-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        $faceDetection = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"

        $result = Invoke-FindSimilarFaces -faceId $faceDetection.faceId -faceListId "pester-facelist-1"
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
        Remove-FaceList "pester-facelist-1"
    }

    Context "When a similar face should be detected in candidate faces"{
        $face1 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $face2 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $face3 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $faceToFind = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"

        $result = Invoke-FindSimilarFaces -faceId $faceToFind.faceId -faceIds $face1.faceId, $face2.faceId, $face3.faceId
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
    }


}