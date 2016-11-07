function Invoke-GroupFaces {
    param(
        # List of candidate faceIds, created with Invoke-FaceDetection
        [parameter(Mandatory=$true)]
        [System.Array]$faceIds
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/group"
    
    $Body = "{ `"faceIds`":" + ($faceIds | ConvertTo-Json) + "}"
    
    $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body

    return $Response
}