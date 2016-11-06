function New-FaceListFace
{
    param(
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListNameAndLocalImage'
            )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListNameAndImageUrl'
            )]
        [string] $faceListName
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListIdAndLocalImage'
            )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListIdAndImageUrl'
            )]
        [string] $faceListId
        ,
        [parameter(Mandatory=$false)] 
        [string] $userData = ""
        ,
        # Location of the target face (exactly one), give a list with left, top, width, heigth
        [parameter(Mandatory=$false)]
        [System.Collections.ArrayList] $targetFace
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListNameAndLocalImage'
        )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListIdAndLocalImage'
        )]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]$localImagePath
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListNameAndImageUrl'
        )]
        [parameter(
            Mandatory=$true,
            ParameterSetName='byFaceListIdAndImageUrl'
        )]
        [string]$ImageUrl
    )

    if ($targetFace -ne $null -and $targetFace.count -ne 4){
        throw "Illegal paramter value for targetFace. Please provide a list with left, top, width and height"
    }

    if ($PsCmdlet.ParameterSetName -like 'byFaceListName*') {
        $faceList = Get-FaceList $faceListName
    } elseif ($PsCmdlet.ParameterSetName -like 'byFaceListId*') {
        $faceList = Get-FaceList -id $faceListId
    }
    
    $Request = "https://api.projectoxford.ai/face/v1.0/facelists/$($faceList.faceListId)/persistedFaces?userData=$userData"
    if ($targetFace -ne $null) {$Request = $Request + "&$($targetFace[0]),$($targetFace[1]),$($targetFace[2]),$($targetFace[3])"}
    
    if ($PsCmdlet.ParameterSetName -like '*LocalImage') {
        $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -inFile $localImagePath -ContentType "application/octet-stream"
    } elseif ($PsCmdlet.ParameterSetName -like '*ImageUrl') {
        $Body = "{ `"url`":`"$ImageUrl`" }"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body
    }
    
}