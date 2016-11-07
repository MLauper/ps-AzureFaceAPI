function Invoke-VerifyFaces {
    param(
        [parameter(
            Mandatory=$true,
            ParameterSetName='FaceToFaceVerification'
        )]
        [String]$faceId1
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='FaceToFaceVerification'
        )]
        [String]$faceId2
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='FaceToPersonVerification'
        )]
        [String]$faceId
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='FaceToPersonVerification'
        )]
        [String]$personGroupId
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='FaceToPersonVerification'
        )]
        [String]$personId

    )

    $Request = "https://api.projectoxford.ai/face/v1.0/verify"
    
    if ($PSCmdlet.ParameterSetName -eq 'FaceToFaceVerification'){
        $Body = "{`"faceId1`":`"$faceId1`",`"faceId2`":`"$faceId2`"}"
    } elseif ($PSCmdlet.ParameterSetName -eq 'FaceToPersonVerification'){
        $Body = "{`"faceId`":`"$faceId`",`"personId`":`"$personId`",`"personGroupId`":`"$personGroupId`"}"
    }
    
    $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body

    return $Response
}