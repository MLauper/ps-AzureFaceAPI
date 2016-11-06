function Remove-Person
{
    param(
        [parameter(
            Mandatory=$true,
            Position=1
            )]
        [string] $name
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

    $currentPerson = Get-Person -name $name -personGroupId $personGroupId

    if (($currentPerson | measure).count -ne 1 -and $Force -ne $true){
        Throw "Found multiple persons with the name $name in person group $personGroupId `nUse -Foce to allow deletion of multiple persons with the same name"
    } 

    $currentPerson | % {
        $Request = "https://api.projectoxford.ai/face/v1.0/persongroups/$personGroupId/persons/$($_.personId)"
        $Response = Invoke-MSCognitiveServiceRequest -Method 'DELETE' -Uri $Request
    }
}