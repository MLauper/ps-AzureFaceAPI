$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "SetFaceList" {

    Context "When a face list name is modified" {
        New-FaceList -name "pester-1-name" -faceListId "pester-1-id" -userData "pester-1-userdata"
        Set-FaceList -name "pester-1-name" -newName "pester-1-name-new"
        $result = Get-FaceList -name "pester-1-name-new"
        It "Should exist under the new name" {
            $result.name | Should BeExactly "pester-1-name-new"
        }
        It "Should have the same userData value as before" {
            $result.userData | Should BeExactly "pester-1-userdata"
        }
        Remove-FaceList -faceListId "pester-1-id"
    }

    Context "When a face list name and userData is modified" {
        New-FaceList -name "pester-1-name" -faceListId "pester-1-id" -userData "pester-1-userdata"
        Set-FaceList -name "pester-1-name" -newName "pester-1-name-new" -userData "pester-1-userdata-new"
        $result = Get-FaceList -name "pester-1-name-new"
        It "Should exist under the new name" {
            $result.name | Should BeExactly "pester-1-name-new"
        }
        It "Should have the new userData value" {
            $result.userData | Should BeExactly "pester-1-userdata-new"
        }
        Remove-FaceList -faceListId "pester-1-id"
    }

    Context "When multiple face lists with the same name exist and a new name is set without -Force" {
        New-FaceList -name "pester-1-name" -faceListId "pester-1-id" -userData "pester-1-userdata"
        New-FaceList -name "pester-1-name" -faceListId "pester-2-id" -userData "pester-2-userdata"

        It "Should throw an exception" {
            {Set-FaceList -name "pester-1-name" -newName "pester-1-name-new"} | Should Throw
        }
        
        Remove-FaceList -faceListId "pester-1-id"
        Remove-FaceList -faceListId "pester-2-id"
    }

    Context "When multiple face lists with the same name exist and a new name is set with -Force" {
        New-FaceList -name "pester-1-name" -faceListId "pester-1-id" -userData "pester-1-userdata"
        New-FaceList -name "pester-1-name" -faceListId "pester-2-id" -userData "pester-2-userdata"

        Set-FaceList -name "pester-1-name" -newName "pester-1-name-new" -Force
        $result = Get-FaceList -name "pester-1-name-new"
        It "Should have changed the name of both entries" {
            ($result | measure).count | Should BeExactly 2
        }
        It "Should not have changed the userData values" {
            ($result | ? {$_.userData -eq "pester-1-userdata"} | measure).count | Should BeExactly 1
            ($result | ? {$_.userData -eq "pester-2-userdata"} | measure).count | Should BeExactly 1
        }
        
        Remove-FaceList -faceListId "pester-1-id"
        Remove-FaceList -faceListId "pester-2-id"
    }

    Context "When multiple face lists with the same name exist and a new userData value is set with -Force" {
        New-FaceList -name "pester-1-name" -faceListId "pester-1-id" -userData "pester-1-userdata"
        New-FaceList -name "pester-1-name" -faceListId "pester-2-id" -userData "pester-2-userdata"

        Set-FaceList -name "pester-1-name" -userData "pester-new-userdata" -Force
        $result = Get-FaceList -name "pester-1-name"
        It "Should have not changed the name of both entries" {
            ($result | measure).count | Should BeExactly 2
        }
        It "Should have changed the userData of both entries" {
            ($result | ? {$_.userData -eq "pester-new-userdata"} | measure).count | Should BeExactly 2
        }
                
        Remove-FaceList -faceListId "pester-1-id"
        Remove-FaceList -faceListId "pester-2-id"
    }

    Context "When an inexisting face list is modified by name" {
        It "Should throw an error" {
            {Set-FaceList -name "pester-non-existing" -newName "pester-test"} | Should throw
        }
    }

    Context "When an inexisting face list is modified by id" {
        It "Should throw an error" {
            {Set-FaceList -faceListId "pester-non-existing" -newName "pester-test"} | Should throw
        }
    }
}
