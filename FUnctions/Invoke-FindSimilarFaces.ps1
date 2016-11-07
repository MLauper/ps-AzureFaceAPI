function Invoke-FindSimilarFaces {
    param(
        # faceId of the query face, as retrieved from Invoke-FaceDetection
        [parameter(Mandatory=$true)]
        [string]$faceId
        ,
        # Existing unique candidate face list, created with New-FaceList
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceList'
        )]
        [string]$faceListId
        ,
        # List of candidate faceIds, created with Invoke-FaceDetection
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceId'
        )]
        [System.Array]$faceIds
        ,
        # Number of candidates returned. Max is 1000, default is 20.
        [parameter(Mandatory=$false)]
        [Int16]$maxNumOfCandidatesReturned
        ,
        # Can be set to matchFace or matchPerson
        # Default is matchPerson
        [parameter(Mandatory=$false)]
        [String]$mode
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/findsimilars"
    
    $Body = "{ `"faceId`":`"$faceId`""
    if ($PsCmdlet.ParameterSetName -eq "byFaceList"){ $Body = $Body + ",`"faceListId`":`"$faceListId`"" }
    elseif ($PsCmdlet.ParameterSetName -eq "byFaceId"){ $Body = $Body + ", `"faceIds`":" + ($faceIds | ConvertTo-Json) }
    if ($maxNumOfCandidatesReturned -ne $null) {$Body = $Body + ",`"maxNumOfCandidatesReturned`":`"10`"" }
    if ($mode -ne "") {$Body = $Body + ",`"mode`": `"$mode`""}
    $Body = $Body + "}"
    
    $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body

    return $Response
}