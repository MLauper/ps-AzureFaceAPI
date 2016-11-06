function Set-PersonGroup
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

    try {
        $currentPersonGroup = Get-PersonGroup $personGroupId
    } catch [System.Exception] {
        throw "Person Group with id $personGroupId couldn't being retrieved" + $_.Exception.Message
    }

    if ($name -eq "") {$name = $currentPersonGroup.name}
    if ($userData -eq "") {$userData = $currentPersonGroup.userData} 

    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId"
    $Body = "{`"name`":`"$name`", `"userData`":`"$userData`" }"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'PATCH' -Uri $Request -Body $Body
}