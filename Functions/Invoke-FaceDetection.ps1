function Invoke-FaceDetection {
    param(
        [parameter(
            Mandatory=$true,
            ParameterSetName='byLocalImage'
        )]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]$localImagePath
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byImageUrl'
        )]
        [string]$ImageUrl
        ,
        [parameter(Mandatory=$false)]
        [Boolean]$returnFaceId = $true
        ,
        [parameter(Mandatory=$false)]
        [Boolean]$returnFaceLandmarks = $false
        ,
        # Supported face attributes are age, gender, headPose, smile, facialHair, and glasses.
        # Provde list of attributes you want to retrieve.
        [parameter(Mandatory=$false)]
        [String]$returnFaceAttributes = ""
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=$returnFaceId&returnFaceLandmarks=true"
    if ($returnFaceAttributes -ne "" -and $returnFaceAttributes -ne $null) {$Request = $Request + "&returnFaceAttributes=" }
    $returnFaceAttributes | % {$Request = $Request + ",$_"}
    
    if ($PsCmdlet.ParameterSetName -like '*LocalImage') {
        $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -inFile $localImagePath -ContentType "application/octet-stream"
    } elseif ($PsCmdlet.ParameterSetName -like '*ImageUrl') {
        $Body = "{ `"url`":`"$ImageUrl`" }"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body
    }

    return $Response
}