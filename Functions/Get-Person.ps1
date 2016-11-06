function Get-Person {
    [CmdletBinding(DefaultParameterSetName="ListAll")]
    param(
        [parameter(
            Mandatory=$false,
            Position=1,
            ParameterSetName='byName')
        ]
        [String]$name
        ,
        [parameter(
            Mandatory=$false,
            ParameterSetName='byId')
        ]
        [String]$id
        ,
        [parameter(
            Mandatory=$false,
            ParameterSetName='ListAll')
        ]
        [Switch]$ListAll
        ,
        [parameter(
            Mandatory=$true)
        ]
        [String]$personGroupId
    )

    if ($PsCmdlet.ParameterSetName -eq 'byName') {
        $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$PersonGroupId/persons"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
        
        # There is no way to retrieve a person by name, therefore just get all persons and filter based on name
        $Response = $Response | ? {$_.name -like $name}
        if (($Response | measure).count -eq 0){
            throw "Person $name not found in group $PersonGroupId"
        }
    } elseif ($PsCmdlet.ParameterSetName -eq 'byId') {
        $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$PersonGroupId/persons/$id"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
    } elseif ($PsCmdlet.ParameterSetName -eq 'ListAll') {
        $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$PersonGroupId/persons"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
    }


    return $Response
}