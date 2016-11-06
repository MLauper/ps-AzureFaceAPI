$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"


Describe "GetPersonFace" {
    New-PersonGroup "pester-persongroup-1"
    New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
    New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"

    Context "When a valid person face is being retrieved" {
        $person = Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        $face = $person | select -ExpandProperty persistedFaceIds -First 1 
        $result = Get-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -faceId $face
        It "Should be retrieved" {
            ($result | measure).count | Should BeExactly 1
        }
    }

    Context "When an invalid person face is being retrieved" {
        It "Should throw an exception" {
            {Get-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -faceId "42"} | Should Throw
        }
    }
    Remove-Person "pester-person-1" -personGroupId "pester-persongroup-1"
    Remove-PersonGroup "pester-persongroup-1"
}