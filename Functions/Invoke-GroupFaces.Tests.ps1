$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "InvokeGroupFaces" {

    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When faces should be grouped"{
        $face1 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $face2 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $face3 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"

        $result = Invoke-GroupFaces -faceIds $face1.faceId, $face2.faceId, $face3.faceId
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
    }


}