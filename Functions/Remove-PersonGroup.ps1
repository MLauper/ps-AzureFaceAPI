function Remove-PersonGroup
{
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )]
        [string] $personGroupId
    )

    if ($name -eq ""){ 
        $name = $personGroupId 
    }

    $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId"
    $Response = Invoke-MSCognitiveServiceRequest -Method 'DELETE' -Uri $Request
}