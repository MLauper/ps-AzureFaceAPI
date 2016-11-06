function New-Person
{
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )]
        [string] $name
        ,
        [parameter(Mandatory=$true)]
        [string] $personGroupId
        ,
        [parameter(Mandatory=$false)]
        [string] $userData = ""
    )

    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons"
    $Body = "{`"name`":`"$name`", `"userData`":`"$userData`" }"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'POST' -Uri $Request -Body $Body
}