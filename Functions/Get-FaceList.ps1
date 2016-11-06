function Get-FaceList {
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
    )

    if ($PsCmdlet.ParameterSetName -eq 'byName') {
        $Request = "https://api.projectoxford.ai/face/v1.0/facelists"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
        
        # There is no way to retrieve a face list by name, therefore just get all face lists and filter based on name
        $Response = $Response | ? {$_.name -like $name}
        if (($Response | measure).count -eq 0){
            throw "FaceList $name not found"
        }
    } elseif ($PsCmdlet.ParameterSetName -eq 'byId') {
        $Request = "https://api.projectoxford.ai/face/v1.0/facelists/$id"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
    } elseif ($PsCmdlet.ParameterSetName -eq 'ListAll') {
        $Request = "https://api.projectoxford.ai/face/v1.0/facelists"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'GET' -Uri $Request
    }

    return $Response
}