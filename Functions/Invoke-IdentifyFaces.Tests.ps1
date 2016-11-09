$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "InvokeIdentifyFaces" {

    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When a similar face should be identified in a person group"{
        New-PersonGroup -personGroupId "pester-persongroup-1"
        New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        Start-PersonGroupTraining -personGroupId "pester-persongroup-1"
        $face1 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $face2 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $face3 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        While ($true) {
            $trainingStatus = Get-PersonGroupTrainingStatus "pester-persongroup-1" | select -Last 1
            if ($trainingStatus.status -ne "notstarted" -and $trainingStatus.status -ne "running"){
                break
            } else {
                sleep 1
            }
        }

        $result = Invoke-IdentifyFaces -faceIds $face1.faceId, $face2.faceId, $face3.faceId -personGroup "pester-persongroup-1"
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
        Remove-PersonGroup -personGroupId "pester-persongroup-1"
    }

    Context "When a single face should be identified in a person group"{
        New-PersonGroup -personGroupId "pester-persongroup-1"
        New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        Start-PersonGroupTraining -personGroupId "pester-persongroup-1"
        $face = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        While ($true) {
            $trainingStatus = Get-PersonGroupTrainingStatus "pester-persongroup-1" | select -Last 1
            if ($trainingStatus.status -ne "notstarted" -and $trainingStatus.status -ne "running"){
                break
            } else {
                sleep 1
            }
        }

        $result = Invoke-IdentifyFaces -faceIds $face.faceId -personGroup "pester-persongroup-1"
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
        Remove-PersonGroup -personGroupId "pester-persongroup-1"
    }

}