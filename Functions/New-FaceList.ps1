function New-FaceList
{
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )]
        [string] $name
        ,
        [parameter(Mandatory=$false)]
        [string] $faceListId
        ,
        [parameter(Mandatory=$false)]
        [string] $userData = ""
    )

    if ($faceListId -eq ""){ 
        $faceListId = $name 
    }

    $Request = "https://api.projectoxford.ai/face/v1.0/facelists/$faceListId"
    $Body = "{`"name`":`"$name`", `"userData`":`"$userData`" }"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'PUT' -Uri $Request -Body $Body
}