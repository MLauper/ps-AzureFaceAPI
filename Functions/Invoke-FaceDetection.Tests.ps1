$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "InvokeFaceDetection" {
    
    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When a face from a local image should be detected"{
        $result = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
    }

    Context "When a face from a local image should be detected and returnFaceId is false"{
        $result = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG" -returnFaceId $false
        It "Should not return a faceId" {
            $result.faceId | Should BeNullOrEmpty
        }
    }

    # Todo: Couldn't retrieve FaceLandmarks
    #Context "When a face from a local image should be detected and retrunFaceLandamrks is true"{
    ##    $result = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG" -returnFaceLandmarks $true
    #}

}