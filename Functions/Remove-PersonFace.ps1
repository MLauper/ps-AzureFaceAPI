function Remove-PersonFace
{
    [CmdletBinding(DefaultParameterSetName="byPersonName")]
    param(
        [parameter(
            Mandatory=$true,
            Position=1,
            ParameterSetName='byPersonName')
        ]
        [String]$personName
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byPersonId')
        ]
        [String]$personId
        ,
        [parameter(
            Mandatory=$true
            )]
        [string] $personGroupId
        ,
        [parameter(
            Mandatory=$true
            )]
        [string] $faceId
    )

    if ($PsCmdlet.ParameterSetName -eq 'byPersonName') {
        $persons = Get-Person -name $personName -personGroupId $personGroupId
        
        if (($persons | measure).count -ne 1){
            $persons | % {
                if ($_.persistedFaceIds -contains $faceId){
                    $person = $_
                    break
                }
            }
        } else {
            $person = $persons
        }

        $personId = $person.personId
    }

    
    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons/$personId/persistedFaces/$faceId"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'DELETE' -Uri $Request

}