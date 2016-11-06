$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force "$here\..\ps-AzureFaceAPI.psd1"

Describe "RemovePerson" {

    New-PersonGroup "pester-persongroup-1"
    New-Person "pester-person-1" -personGroupId "pester-persongroup-1"
    
    Context "When a person face is being deleted with person name" {
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        $person = Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        $faceId = $person | select -ExpandProperty persistedFaceIds | select -first 1
        Remove-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -faceId $faceId
        
        It "Should not exist anymore" {
            (Get-Person -name "pester-person-1" -personGroupId "pester-persongroup-1" | select -expandproperty persistedFaceIds | measure).Count | Should BeExactly 0
        }
    }

    Context "When a person face is being deleted with person id" {
        New-PersonFace -personName "pester-person-1" -personGroupId "pester-persongroup-1" -LocalImagePath "$here\..\SampleImages\Face_01.JPG"
        $person = Get-Person "pester-person-1" -personGroupId "pester-persongroup-1"
        $personId = $person.personId
        $faceId = $person | select -ExpandProperty persistedFaceIds | select -first 1
        Remove-PersonFace -personId $personId -personGroupId "pester-persongroup-1" -faceId $faceId

        It "Should not exist anymore" {
            (Get-Person -name "pester-person-1" -personGroupId "pester-persongroup-1" | select -expandproperty persistedFaceIds | measure).Count | Should BeExactly 0
        }
    }

    Remove-Person "pester-person-1" -personGroupId "pester-persongroup-1"
    Remove-PersonGroup "pester-persongroup-1"

}
