function Start-PersonGroupTraining {
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )
        ]
        [String]$PersonGroupId
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$PersonGroupId/train"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request

    return $Response
}