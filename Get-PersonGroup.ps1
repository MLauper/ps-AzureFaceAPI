function Get-PersonGroup {
    param(
        [parameter(
            Mandatory=$true,
            ParameterSetName='ListAllGroups')
        ]
        [switch]$ListAll
        ,
        [parameter(
            Mandatory=$false,
            Position=1,
            ParameterSetName='GetSingleGroup')
        ]
        [String]$PersonGroupId
    )

    if ($PsCmdlet.ParameterSetName -eq 'ListAllGroups') {
        $Request = "https://api.projectoxford.ai/face/v1.0/persongroups?start=0&top=1000"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
    } elseif ($PsCmdlet.ParameterSetName -eq 'GetSingleGroup') {
        $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$PersonGroupId"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
    }

    return $Response
}