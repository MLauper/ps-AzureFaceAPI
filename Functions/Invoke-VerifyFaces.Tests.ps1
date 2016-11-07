$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "InvokeVerifyFaces" {

    Context "When test data should be used"{
        It "Should be available for testing"{
            Test-Path "$here\..\SampleImages\Face_01.JPG" | Should Be $true
        }        
    }

    Context "When a face should be verified with another face"{
        $face1 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        $face2 = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"

        $result = Invoke-VerifyFaces -faceId1 $face1.faceId -faceId2 $face2.faceId
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
    }

    Context "When a face should verified with a person"{
        New-PersonGroup -personGroupId "pester-persongroup-1"
        New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        $person = Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        Start-PersonGroupTraining -personGroupId "pester-persongroup-1"
        $faceToVerify = Invoke-FaceDetection -localImagePath "$here\..\SampleImages\Face_01.JPG"
        While ($true) {
            $trainingStatus = Get-PersonGroupTrainingStatus "pester-persongroup-1" | select -Last 1
            if ($trainingStatus.status -ne "notstarted" -and $trainingStatus.status -ne "running"){
                break
            } else {
                sleep 1
            }
        }

        $result = Invoke-VerifyFaces -faceId $faceToVerify.faceId -personid $person.personId -personGroupId "pester-persongroup-1"
        It "Should return a result" {
            $result | Should Not BeNullOrEmpty
        }
        Remove-PersonGroup -personGroupId "pester-persongroup-1"
    }

}