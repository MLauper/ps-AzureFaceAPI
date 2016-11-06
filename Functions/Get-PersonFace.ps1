function Get-PersonFace {
    param(
        [parameter(
            Mandatory=$true,
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
            Mandatory=$false)
        ]
        [String]$faceId
        ,
        [parameter(
            Mandatory=$true)
        ]
        [String]$personGroupId
    )

    if ($PsCmdlet.ParameterSetName -eq 'byPersonName') {
        $personId = Get-Person $personName -personGroupId $personGroupId | select -ExpandProperty personId
    }

    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons/$personId/persistedFaces/$faceId"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
        

    return $Response
}