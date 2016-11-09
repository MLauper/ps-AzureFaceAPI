function Invoke-IdentifyFaces {
    param(
        # List of candidate faceIds, created with Invoke-FaceDetection
        [parameter(Mandatory=$true)]
        [System.Array]$faceIds
        ,
        # Existing person group, created with New-PersonGroup
        [parameter(Mandatory=$true)]
        [string]$personGroupId
        ,
        # Number of candidates returned. Max is 5, default is 1.
        [parameter(Mandatory=$false)]
        [Int16]$maxNumOfCandidatesReturned = 1
        ,
        # Threshold of identification
        [parameter(Mandatory=$false)]
        [Double]$confidenceThreshold
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/identify"
    
    $Body = "{ `"personGroupId`":`"$personGroupId`""
    $Body = $Body + ", `"faceIds`":"
    if (($faceIds | measure).Count -eq 1) {$Body = $Body + "[`"$($faceIds[0])`"]"}
    elseif (($faceIds | measure).Count -gt 1) {$Body = $Body + ($faceIds | ConvertTo-Json)}
    if ($maxNumOfCandidatesReturned -ne $null) {$Body = $Body + ",`"maxNumOfCandidatesReturned`":`"$maxNumOfCandidatesReturned`"" }
    if ($confidenceThreshold -ne 0) {$Body = $Body + ",`"confidenceThreshold`": `"$confidenceThreshold`""}
    $Body = $Body + "}"
    
    $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body

    return $Response
}