$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

New-FaceList "pester-1" -faceListId "pester-1-id"
New-FaceList "pester-2" -faceListId "pester-2-id"
New-FaceList "pester-3" -faceListId "pester-3-id"

Describe "GetFaceList" {

    Context "When a single face list is retrieved by name" {
        $result = Get-FaceList "pester-1"
        It "Shout return the face list" {
            ($result | measure).count | Should BeExactly 1
            $result.name | Should BeExactly "pester-1"
        }
    }

    Context "When a single face list is retrieved by id" {
        $result = Get-FaceList -id "pester-1-id"
        It "Shout return the face list" {
            ($result | measure).count | Should BeExactly 1
            $result.name | Should BeExactly "pester-1"
        }
    }

    Context "When all facelists are retrieved" {
        $result = Get-FaceList
        It "Shout return all face list" {
            ($result | measure).count | Should BeGreaterThan 2
            ($result | ? {$_.name -eq "pester-1"} | measure).count | Should BeExactly 1
            ($result | ? {$_.name -eq "pester-2"} | measure).count | Should BeExactly 1
            ($result | ? {$_.name -eq "pester-3"} | measure).count | Should BeExactly 1
        }
    }

}

Remove-FaceList "pester-1-id"
Remove-FaceList "pester-2-id"
Remove-FaceList "pester-3-id"