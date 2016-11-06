$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "NewFaceList" {

    Context "When a face list is being created" {
        New-FaceList "pester-1"

        $result = Get-FaceList "pester-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
        Remove-FaceList "pester-1"
    }

    Context "When a face with userData is being created" {
        New-FaceList "pester-1" -userData "pester-user-data"

        $result = Get-FaceList "pester-1"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
        It "Should have the userData set" {
            $result.userData | Should Be "pester-user-data"
        }
        Remove-FaceList "pester-1"
    }

    Context "When a face with different name and id is being created" {
        New-FaceList -name "pester-1-name" -faceListId "pester-1-id" -userData "pester-user-data"

        $result = Get-FaceList "pester-1-name"
        It "Should exist" {
            ($result | measure).count | Should Be 1
        }
        It "Should have the correct id" {
            $result.faceListId | Should Be "pester-1-id"
        }
        It "Should have the correct name" {
            $result.name | Should Be "pester-1-name"
        }
        It "Should have the userData set" {
            $result.userData | Should Be "pester-user-data"
        }
        Remove-FaceList "pester-1-id"
    }

}
