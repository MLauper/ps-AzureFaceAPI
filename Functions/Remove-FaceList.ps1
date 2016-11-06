function Remove-FaceList
{
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )]
        [string] $faceListId
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/facelists/$faceListId"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'DELETE' -Uri $Request
}