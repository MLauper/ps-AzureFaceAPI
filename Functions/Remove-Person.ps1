function Remove-Person
{
    [CmdletBinding(DefaultParameterSetName="byName")]
    param(
        [parameter(
            Mandatory=$true,
            Position=1,
            ParameterSetName='byName')
        ]
        [String]$name
        ,
        [parameter(
            Mandatory=$true,
            ParameterSetName='byId')
        ]
        [String]$id
        ,
        [parameter(
            Mandatory=$true
            )]
        [string] $personGroupId
        ,
        [parameter(
            Mandatory=$false
            )]
        [switch] $Force
    )

    if ($PsCmdlet.ParameterSetName -eq 'byName') {
        $currentPerson = Get-Person -name $name -personGroupId $personGroupId

        if (($currentPerson | measure).count -ne 1 -and $Force -ne $true){
            Throw "Found multiple persons with the name $name in person group $personGroupId `nUse -Foce to allow deletion of multiple persons with the same name"
        } 

        $currentPerson | % {
            $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons/$($_.personId)"
            $Response = Invoke-MSCognitiveServiceRequest -Method 'DELETE' -Uri $Request
        }
    } elseif($PsCmdlet.ParameterSetName -eq 'byId'){
         $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons/$id"
         $Response = Invoke-MSCognitiveServiceRequest -Method 'DELETE' -Uri $Request
    }
}