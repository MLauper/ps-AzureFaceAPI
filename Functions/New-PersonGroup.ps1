function New-PersonGroup
{
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )]
        [string] $personGroupId
        ,
        [parameter(Mandatory=$false)]
        [string] $name
        ,
        [parameter(Mandatory=$false)]
        [string] $userData = ""
    )

    if ($name -eq ""){ 
        $name = $personGroupId 
    }

    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId"
    $Body = "{`"name`":`"$name`", `"userData`":`"$userData`" }"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'PUT' -Uri $Request -Body $Body
}