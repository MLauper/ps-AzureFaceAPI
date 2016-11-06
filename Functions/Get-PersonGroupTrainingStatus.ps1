function Get-PersonGroupTrainingStatus {
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )
        ]
        [String]$PersonGroupId
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$PersonGroupId/training"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request

    return $Response
}